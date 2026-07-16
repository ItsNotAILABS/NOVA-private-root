import { readFile } from 'node:fs/promises';
import { extname, join, normalize } from 'node:path';
import { config } from './config.js';
import { getState, transact, makeId, verifyReceiptChain } from './store.js';
import { normalizeAlert, signalFromAlert, generateNativeSignal, runWorkflow, fillOrder, applyFill } from './tradingEngine.js';
import { verifyTradingView, securityHeaders } from './security.js';

const now = () => new Date().toISOString();
const mime = { '.html':'text/html; charset=utf-8', '.css':'text/css; charset=utf-8', '.js':'text/javascript; charset=utf-8', '.json':'application/json; charset=utf-8', '.svg':'image/svg+xml' };

function send(res, status, payload, extra={}) {
  res.writeHead(status, { 'content-type':'application/json; charset=utf-8', 'cache-control':'no-store', ...securityHeaders(), ...extra });
  res.end(JSON.stringify(payload));
}

async function readBody(req) {
  const chunks=[]; let size=0;
  for await (const chunk of req) {
    size += chunk.length;
    if (size > config.maxBodyBytes) throw Object.assign(new Error('request body too large'), { status:413 });
    chunks.push(chunk);
  }
  const raw = Buffer.concat(chunks).toString('utf8');
  return { raw, json:raw ? JSON.parse(raw) : {} };
}

function requireMode(input={}) {
  const mode = input.mode || 'paper';
  if (!['paper','testnet'].includes(mode)) throw Object.assign(new Error('live execution is not enabled'), { status:403 });
}

function findStrategy(state, id, symbol) {
  return state.strategies.find(x => x.id === id) || state.strategies.find(x => x.symbol === symbol && x.status === 'active') || state.strategies[0];
}

function findBot(state, id, strategyId) {
  return state.bots.find(x => x.id === id) || state.bots.find(x => x.strategy_id === strategyId && x.status === 'active') || null;
}

function dashboard(state) {
  const portfolio = state.portfolios[0];
  return {
    portfolio,
    active_bots:state.bots.filter(x => x.status === 'active').length,
    active_strategies:state.strategies.filter(x => x.status === 'active').length,
    pending_orders:state.orders.filter(x => x.status === 'pending-approval').length,
    alerts_today:state.alerts.filter(x => x.received_at?.startsWith(new Date().toISOString().slice(0,10))).length,
    fills_today:state.fills.filter(x => x.created_at?.startsWith(new Date().toISOString().slice(0,10))).length,
    receipt_chain_valid:verifyReceiptChain(),
    recent_activity:state.activity.slice(-12).reverse()
  };
}

async function staticFile(pathname, res) {
  const relative = pathname === '/' ? 'index.html' : pathname.replace(/^\//, '');
  const safe = normalize(relative).replace(/^(\.\.[/\\])+/, '');
  const path = join(config.publicDir, safe);
  try {
    const data = await readFile(path);
    res.writeHead(200, { 'content-type':mime[extname(path)] || 'application/octet-stream', 'cache-control':'no-cache', ...securityHeaders() });
    res.end(data);
  } catch { send(res, 404, { ok:false, error:'not found' }); }
}

export async function route(req, res) {
  const url = new URL(req.url, 'http://localhost');
  const state = getState();

  try {
    if (req.method === 'GET' && url.pathname === '/api/health') return send(res, 200, {
      ok:true, app:config.appName, version:config.version, mode:state.settings.execution_mode,
      tradingview:{ chart:true, webhook:config.tradingview.webhookPath, auth_configured:Boolean(config.tradingview.token || config.tradingview.secret) },
      receipt_chain_valid:verifyReceiptChain(), timestamp:now()
    });
    if (req.method === 'GET' && url.pathname === '/api/dashboard') return send(res, 200, { ok:true, dashboard:dashboard(state) });
    if (req.method === 'GET' && url.pathname === '/api/state') return send(res, 200, { ok:true, state });
    if (req.method === 'GET' && url.pathname === '/api/markets') return send(res, 200, { ok:true, markets:state.markets });
    if (req.method === 'GET' && url.pathname === '/api/portfolio') return send(res, 200, { ok:true, portfolio:state.portfolios[0] });
    if (req.method === 'GET' && url.pathname === '/api/strategies') return send(res, 200, { ok:true, strategies:state.strategies });
    if (req.method === 'GET' && url.pathname === '/api/bots') return send(res, 200, { ok:true, bots:state.bots });
    if (req.method === 'GET' && url.pathname === '/api/alerts') return send(res, 200, { ok:true, alerts:state.alerts.slice().reverse() });
    if (req.method === 'GET' && url.pathname === '/api/orders') return send(res, 200, { ok:true, orders:state.orders.slice().reverse() });
    if (req.method === 'GET' && url.pathname === '/api/fills') return send(res, 200, { ok:true, fills:state.fills.slice().reverse() });
    if (req.method === 'GET' && url.pathname === '/api/wallets') return send(res, 200, { ok:true, wallets:state.wallets });
    if (req.method === 'GET' && url.pathname === '/api/connections') return send(res, 200, { ok:true, connections:state.connections });
    if (req.method === 'GET' && url.pathname === '/api/receipts') return send(res, 200, { ok:true, valid:verifyReceiptChain(), receipts:state.receipts.slice().reverse() });
    if (req.method === 'GET' && url.pathname === '/api/activity') return send(res, 200, { ok:true, activity:state.activity.slice().reverse() });

    if (req.method === 'POST' && url.pathname === '/api/strategies') {
      const { json } = await readBody(req); requireMode(json);
      if (!json.name || !json.symbol) throw Object.assign(new Error('name and symbol are required'), { status:400 });
      const out = await transact('strategy.created', json, (s) => {
        const item = { id:makeId('strat'), workspace_id:'ws_primary', name:String(json.name), symbol:String(json.symbol).toUpperCase(), timeframe:String(json.timeframe || '15'), source:json.source || 'native', status:json.status || 'draft', risk_limit:Number(json.risk_limit || 0.01), default_notional:Number(json.default_notional || 1000), rules:json.rules || { entry:'custom', exit:'custom' }, created_at:now() };
        s.strategies.push(item); return item;
      }, 'operator');
      return send(res, 201, { ok:true, ...out });
    }

    if (req.method === 'PATCH' && url.pathname.startsWith('/api/strategies/')) {
      const id = url.pathname.split('/')[3]; const { json } = await readBody(req); requireMode(json);
      const out = await transact('strategy.updated', json, (s) => {
        const item=s.strategies.find(x=>x.id===id); if(!item) throw Object.assign(new Error('strategy not found'),{status:404});
        for(const key of ['name','symbol','timeframe','status','risk_limit','default_notional','rules']) if(json[key]!==undefined) item[key]=json[key];
        item.updated_at=now(); return item;
      }, 'operator');
      return send(res, 200, { ok:true, ...out });
    }

    if (req.method === 'POST' && url.pathname === '/api/bots') {
      const { json } = await readBody(req); requireMode(json);
      const strategy = state.strategies.find(x => x.id === json.strategy_id);
      if (!strategy) throw Object.assign(new Error('strategy not found'), { status:404 });
      const out = await transact('bot.created', json, (s) => {
        const bot={ id:makeId('bot'), workspace_id:'ws_primary', name:String(json.name || `${strategy.name} Bot`), strategy_id:strategy.id, trigger:json.trigger || 'manual', symbols:Array.isArray(json.symbols)?json.symbols:[strategy.symbol], status:json.status || 'draft', mode:'paper', risk_profile:json.risk_profile || 'balanced', max_notional:Number(json.max_notional || strategy.default_notional || 1000), allowed_actions:['signal','risk-check','paper-order','receipt'], runs:0, created_at:now(), updated_at:now() };
        s.bots.push(bot); return bot;
      }, 'operator');
      return send(res, 201, { ok:true, ...out });
    }

    if (req.method === 'PATCH' && url.pathname.startsWith('/api/bots/')) {
      const id=url.pathname.split('/')[3]; const { json }=await readBody(req); requireMode(json);
      const out=await transact('bot.updated',json,(s)=>{const bot=s.bots.find(x=>x.id===id);if(!bot)throw Object.assign(new Error('bot not found'),{status:404});for(const key of ['name','status','trigger','symbols','risk_profile','max_notional'])if(json[key]!==undefined)bot[key]=json[key];bot.updated_at=now();return bot;},'operator');
      return send(res,200,{ok:true,...out});
    }

    if (req.method === 'POST' && url.pathname.startsWith('/api/bots/') && url.pathname.endsWith('/run')) {
      const id=url.pathname.split('/')[3]; const { json }=await readBody(req); requireMode(json);
      const bot=state.bots.find(x=>x.id===id); if(!bot)throw Object.assign(new Error('bot not found'),{status:404});
      const strategy=state.strategies.find(x=>x.id===bot.strategy_id); const market=state.markets.find(x=>x.symbol===strategy.symbol);
      const signal=generateNativeSignal({strategy,market});
      const out=await transact('bot.run',json,(s)=>({id:makeId('run'),bot_id:bot.id,...runWorkflow({state:s,strategy,bot,signal,notional:Number(json.notional||bot.max_notional)}),created_at:now()}),'operator');
      return send(res,201,{ok:true,...out});
    }

    if (req.method === 'POST' && url.pathname === config.tradingview.webhookPath) {
      const { raw, json }=await readBody(req);
      const auth=verifyTradingView(raw,req.headers);
      if(!auth.ok) throw Object.assign(new Error('invalid TradingView webhook authentication'),{status:401});
      const alert=normalizeAlert(json); const strategy=findStrategy(state,alert.strategy_id,alert.symbol); const bot=findBot(state,alert.bot_id,strategy?.id);
      const signal=signalFromAlert(alert,strategy);
      const out=await transact('tradingview.alert.processed',json,(s)=>{s.alerts.push({...alert,auth_method:auth.method});const workflow=runWorkflow({state:s,strategy,bot,signal,notional:alert.notional||bot?.max_notional||strategy?.default_notional});return {id:makeId('tvrun'),alert:{...alert,auth_method:auth.method},bot_id:bot?.id||null,strategy_id:strategy?.id||null,...workflow,created_at:now()};},'tradingview');
      return send(res,201,{ok:true,...out});
    }

    if (req.method === 'POST' && url.pathname.startsWith('/api/orders/') && url.pathname.endsWith('/approve')) {
      const id=url.pathname.split('/')[3];
      const out=await transact('order.approved',{order_id:id},(s)=>{const order=s.orders.find(x=>x.id===id);if(!order)throw Object.assign(new Error('order not found'),{status:404});if(order.status!=='pending-approval')throw Object.assign(new Error('order is not pending approval'),{status:409});order.status='accepted';order.approved_at=now();const market=s.markets.find(x=>x.symbol===order.symbol);const fill=fillOrder({order,market});if(fill){s.fills.push(fill);applyFill(s.portfolios[0],fill);}return {order,fill};},'operator');
      return send(res,200,{ok:true,...out});
    }

    if (req.method === 'POST' && url.pathname === '/api/wallets') {
      const { json }=await readBody(req);
      if(json.private_key||json.seed_phrase||json.mnemonic)throw Object.assign(new Error('private keys and seed phrases are never accepted'),{status:400});
      if(!json.address||!json.network)throw Object.assign(new Error('address and network are required'),{status:400});
      const out=await transact('wallet.registered',json,(s)=>{const wallet={id:makeId('wallet'),label:json.label||json.network,network:String(json.network).toLowerCase(),address:String(json.address),environment:json.environment||'testnet',permissions:['view','prepare-intent'],created_at:now()};s.wallets.push(wallet);return wallet;},'operator');
      return send(res,201,{ok:true,...out});
    }

    if (req.method === 'POST' && url.pathname === '/api/wallets/intents') {
      const { json }=await readBody(req); requireMode(json);
      const wallet=state.wallets.find(x=>x.id===json.wallet_id);if(!wallet)throw Object.assign(new Error('wallet not found'),{status:404});
      const out=await transact('wallet.intent.created',json,(s)=>{const intent={id:makeId('intent'),wallet_id:wallet.id,network:wallet.network,action:json.action||'transfer',asset:json.asset||'UNKNOWN',amount:String(json.amount||'0'),destination:json.destination||null,mode:json.mode||'testnet',status:'unsigned-human-approval-required',created_at:now()};s.wallet_intents.push(intent);return intent;},'operator');
      return send(res,201,{ok:true,...out});
    }

    if (req.method === 'PATCH' && url.pathname === '/api/settings') {
      const { json }=await readBody(req); requireMode(json);
      const out=await transact('settings.updated',json,(s)=>{for(const key of ['execution_mode','require_human_approval_above','max_order_notional','max_daily_loss','max_open_positions'])if(json[key]!==undefined)s.settings[key]=json[key];s.settings.live_enabled=false;s.settings.custody_enabled=false;return s.settings;},'operator');
      return send(res,200,{ok:true,...out});
    }

    if (url.pathname.startsWith('/api/')) return send(res,404,{ok:false,error:'unknown API route'});
    return staticFile(url.pathname,res);
  } catch (error) {
    return send(res,error.status||500,{ok:false,error:error.message});
  }
}
