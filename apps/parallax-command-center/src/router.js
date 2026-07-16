import { readFile } from 'node:fs/promises';
import { extname, join, normalize } from 'node:path';
import { config } from './config.js';
import { ensureState, getState, mutate, createId, verifyReceiptChain } from './state.js';
import { evaluateSignal, evaluateRisk, buildPaperOrder, settlePaperOrder } from './agentRuntime.js';
import { resolveEcosystem } from './ecosystemRegistry.js';
import { probeEcosystem, dispatchFederatedAction } from './federationRuntime.js';
import { verifyTradingViewRequest, normalizeTradingViewAlert, routeAlertToPaperWorkflow } from './tradingviewRuntime.js';
import { createBot, updateBot } from './botRuntime.js';
import { registerWallet, createTransactionIntent } from './walletRuntime.js';

const send = (res, status, payload) => { res.writeHead(status, { 'content-type':'application/json; charset=utf-8', 'cache-control':'no-store' }); res.end(JSON.stringify(payload)); };
async function readBody(req) { const chunks=[]; let size=0; for await (const chunk of req) { size += chunk.length; if (size > config.maxBodyBytes) throw new Error('request too large'); chunks.push(chunk); } const rawBody = Buffer.concat(chunks).toString('utf8'); return { rawBody, input:rawBody ? JSON.parse(rawBody) : {} }; }
const requirePaperMode = (input={}) => { if (input.mode && !['paper','testnet','internal-credit'].includes(input.mode)) throw new Error('live execution is blocked'); };
async function staticFile(pathname, res) { const relative=pathname==='/'?'index.html':pathname.replace(/^\//,''); const safe=normalize(relative).replace(/^(\.\.[/\\])+/,''); const file=join(config.publicDir,safe); try { const data=await readFile(file); const type={'.html':'text/html; charset=utf-8','.js':'text/javascript; charset=utf-8','.css':'text/css; charset=utf-8','.json':'application/json; charset=utf-8','.svg':'image/svg+xml'}[extname(file)]||'application/octet-stream'; res.writeHead(200,{'content-type':type,'cache-control':'no-cache'}); res.end(data); } catch { send(res,404,{ok:false,error:'not found'}); } }

function runAutomation(state, input) {
  const strategy = state.strategies.find((item)=>item.id===input.strategy_id) || state.strategies.find((item)=>item.status==='paper');
  if (!strategy) throw new Error('strategy not found');
  const market = state.markets.find((item)=>item.symbol===(input.symbol||strategy.market));
  if (!market) throw new Error('market not found');
  const notional = Number(input.notional || strategy.default_notional || 1000);
  const signal = evaluateSignal({ strategy, market });
  if (input.requested_action && ['buy','sell','hold'].includes(input.requested_action)) signal.direction = input.requested_action;
  const risk = evaluateRisk({ state, strategy, signal, requestedNotional:notional });
  const order = buildPaperOrder({ strategy, signal, market, risk, notional });
  const fill = settlePaperOrder({ order, market });
  state.signals.push(signal); state.risk_decisions.push(risk); if (order) state.orders.push(order); if (fill) state.fills.push(fill);
  const run = { id:createId('run'), workflow_id:input.workflow_id||'workflow_signal_to_receipt', strategy_id:strategy.id, bot_id:input.bot_id||null, source_alert_id:input.source_alert_id||null, agents:['agent_nova_hft','agent_argos_clear','agent_plax_sns'], signal,risk,order,fill,status:fill?'settled-paper':order?.status==='pending-approval'?'pending-human-approval':'no-trade',created_at:new Date().toISOString() };
  state.automation_runs.push(run); return run;
}

export async function route(req,res) {
  await ensureState(); const url=new URL(req.url,'http://local'); const s=getState();
  if (req.method==='GET' && url.pathname==='/api/health') return send(res,200,{ok:true,app:config.appName,version:config.version,environment:s.environment,receipt_chain_valid:verifyReceiptChain(),automation:{runs:s.automation_runs.length},platform:{bots:s.bots.length,wallets:s.wallets.length,tradingview_alerts:s.tradingview_alerts.length,mcp:true},ecosystem:{services:resolveEcosystem(config).length}});
  if (req.method==='GET' && url.pathname==='/api/state') return send(res,200,{ok:true,state:s});
  if (req.method==='GET' && url.pathname==='/api/agents') return send(res,200,{ok:true,agents:s.agents});
  if (req.method==='GET' && url.pathname==='/api/strategies') return send(res,200,{ok:true,strategies:s.strategies});
  if (req.method==='GET' && url.pathname==='/api/bots') return send(res,200,{ok:true,bots:s.bots});
  if (req.method==='GET' && url.pathname==='/api/wallets') return send(res,200,{ok:true,wallets:s.wallets,wallet_intents:s.wallet_intents});
  if (req.method==='GET' && url.pathname==='/api/tradingview/alerts') return send(res,200,{ok:true,alerts:s.tradingview_alerts.slice().reverse()});
  if (req.method==='GET' && url.pathname==='/api/automation/runs') return send(res,200,{ok:true,runs:s.automation_runs.slice().reverse()});
  if (req.method==='GET' && url.pathname==='/api/receipts') return send(res,200,{ok:true,valid:verifyReceiptChain(),receipts:s.receipts.slice().reverse()});
  if (req.method==='GET' && url.pathname==='/api/ecosystem') return send(res,200,{ok:true,services:resolveEcosystem(config)});
  if (req.method==='GET' && url.pathname==='/api/ecosystem/status') return send(res,200,{ok:true,services:await probeEcosystem(config)});

  if (req.method==='POST' && url.pathname==='/api/tradingview/webhook') {
    const {rawBody,input}=await readBody(req); const authenticated=verifyTradingViewRequest({rawBody,headers:req.headers,config});
    if (config.tradingView.requireAuthentication && !authenticated) return send(res,401,{ok:false,error:'invalid TradingView webhook authentication'});
    const alert=normalizeTradingViewAlert(input); const routed=routeAlertToPaperWorkflow({alert,state:s});
    const out=await mutate('tradingview.alert.received',input,(state)=>{ state.tradingview_alerts.push(alert); const bot=state.bots.find((item)=>item.id===alert.bot_id); if (bot && bot.status!=='active') return {alert,routed,run:null,reason:'bot-not-active'}; return {alert,routed,run:runAutomation(state,{...routed,bot_id:bot?.id||null})}; });
    return send(res,202,{ok:true,...out});
  }
  if (req.method==='POST' && url.pathname==='/api/bots') { const {input}=await readBody(req); requirePaperMode(input); const out=await mutate('bot.created',input,(state)=>{ const bot=createBot(input); state.bots.push(bot); return bot; }); return send(res,201,{ok:true,...out}); }
  if (req.method==='PATCH' && url.pathname.startsWith('/api/bots/')) { const {input}=await readBody(req); const id=url.pathname.split('/')[3]; const out=await mutate('bot.updated',input,(state)=>updateBot(state.bots.find((item)=>item.id===id),input)); return send(res,200,{ok:true,...out}); }
  if (req.method==='POST' && url.pathname==='/api/wallets') { const {input}=await readBody(req); const out=await mutate('wallet.registered',{...input,private_key:undefined,seed_phrase:undefined,mnemonic:undefined},(state)=>{ const wallet=registerWallet(input); state.wallets.push(wallet); return wallet; }); return send(res,201,{ok:true,...out}); }
  if (req.method==='POST' && url.pathname==='/api/wallets/intents') { const {input}=await readBody(req); requirePaperMode(input); const out=await mutate('wallet.intent.created',input,(state)=>{ const intent=createTransactionIntent({wallet:state.wallets.find((item)=>item.id===input.wallet_id),input,governance:state.governance}); state.wallet_intents.push(intent); return intent; }); return send(res,201,{ok:true,...out}); }
  if (req.method==='POST' && url.pathname==='/api/automation/run') { const {input}=await readBody(req); requirePaperMode(input); const out=await mutate('automation.workflow.completed',input,(state)=>runAutomation(state,input)); return send(res,201,{ok:true,...out}); }
  if (req.method==='POST' && url.pathname==='/api/ecosystem/actions') { const {input}=await readBody(req); requirePaperMode(input); const result=await dispatchFederatedAction(config,input); const out=await mutate('ecosystem.action.dispatched',input,(state)=>{ const event={id:createId('eco'),...result,created_at:new Date().toISOString()}; state.ecosystem_events.push(event); return event; }); return send(res,result.delivered?200:502,{ok:result.delivered,...out}); }
  if (req.method==='POST' && url.pathname==='/api/agents') { const {input}=await readBody(req); requirePaperMode(input); const out=await mutate('agent.created',input,(state)=>{ const agent={id:createId('agent'),name:input.name||'Unnamed Agent',role:input.role||'research',status:'ready',model:input.model||'polyglot-runtime',risk:input.risk||'medium',capabilities:input.capabilities||[],created_at:new Date().toISOString()}; state.agents.push(agent); return agent; }); return send(res,201,{ok:true,...out}); }
  if (req.method==='POST' && url.pathname==='/api/strategies') { const {input}=await readBody(req); requirePaperMode(input); if (Number(input.risk_limit||0)>s.governance.max_strategy_risk_limit) return send(res,403,{ok:false,error:'strategy risk limit exceeds governance maximum'}); const out=await mutate('strategy.created',input,(state)=>{ const strategy={id:createId('strategy'),name:input.name||'Untitled Strategy',market:input.market||'BTC-USD',timeframe:input.timeframe||'15m',signal:input.signal||'custom',risk_limit:Number(input.risk_limit||0.01),default_notional:Number(input.default_notional||1000),status:'paper',created_at:new Date().toISOString()}; state.strategies.push(strategy); return strategy; }); return send(res,201,{ok:true,...out}); }
  if (req.method==='POST' && url.pathname==='/api/governance/evaluate') { const {input}=await readBody(req); const blocked=['live-broker-route','custody','wallet-live-submission','public-token-sale','mainnet-autonomous-trading'].includes(input.action); const out=await mutate('governance.evaluated',input,()=>({decision:blocked?'deny':'allow-paper-testnet',reason:blocked?'blocked by production boundary':'allowed inside paper/testnet boundary'})); return send(res,200,{ok:true,...out}); }
  if (url.pathname.startsWith('/api/')) return send(res,404,{ok:false,error:'unknown api route'});
  return staticFile(url.pathname,res);
}
