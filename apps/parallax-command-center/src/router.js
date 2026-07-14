import { readFile } from 'node:fs/promises';
import { extname, join, normalize } from 'node:path';
import { config } from './config.js';
import { ensureState, getState, mutate, createId, verifyReceiptChain } from './state.js';

const json = (res, status, body) => { res.writeHead(status, { 'content-type': 'application/json; charset=utf-8', 'cache-control': 'no-store' }); res.end(JSON.stringify(body)); };

async function body(req) {
  const chunks = []; let size = 0;
  for await (const chunk of req) { size += chunk.length; if (size > config.maxBodyBytes) throw new Error('request too large'); chunks.push(chunk); }
  return chunks.length ? JSON.parse(Buffer.concat(chunks).toString('utf8')) : {};
}

function requirePaperMode(input = {}) {
  if (input.mode && !['paper', 'testnet', 'internal-credit'].includes(input.mode)) throw new Error('live execution is blocked');
}

async function staticFile(pathname, res) {
  const relative = pathname === '/' ? 'index.html' : pathname.replace(/^\//, '');
  const safe = normalize(relative).replace(/^(\.\.[/\\])+/, '');
  const file = join(config.publicDir, safe);
  try {
    const data = await readFile(file);
    const type = { '.html':'text/html; charset=utf-8', '.js':'text/javascript; charset=utf-8', '.css':'text/css; charset=utf-8', '.json':'application/json; charset=utf-8', '.svg':'image/svg+xml' }[extname(file)] || 'application/octet-stream';
    res.writeHead(200, { 'content-type': type, 'cache-control': 'no-cache' }); res.end(data);
  } catch { json(res, 404, { ok:false, error:'not found' }); }
}

export async function route(req, res) {
  await ensureState();
  const url = new URL(req.url, 'http://local');
  const s = getState();

  if (req.method === 'GET' && url.pathname === '/api/health') return json(res, 200, { ok:true, app:config.appName, version:config.version, environment:s.environment, receipt_chain_valid:verifyReceiptChain(), federation:config.federation });
  if (req.method === 'GET' && url.pathname === '/api/state') return json(res, 200, { ok:true, state:s });
  if (req.method === 'GET' && url.pathname === '/api/markets') return json(res, 200, { ok:true, markets:s.markets });
  if (req.method === 'GET' && url.pathname === '/api/agents') return json(res, 200, { ok:true, agents:s.agents });
  if (req.method === 'GET' && url.pathname === '/api/strategies') return json(res, 200, { ok:true, strategies:s.strategies });
  if (req.method === 'GET' && url.pathname === '/api/workflows') return json(res, 200, { ok:true, workflows:s.workflows });
  if (req.method === 'GET' && url.pathname === '/api/receipts') return json(res, 200, { ok:true, valid:verifyReceiptChain(), receipts:s.receipts.slice().reverse() });

  if (req.method === 'POST' && url.pathname === '/api/agents') {
    const input = await body(req); requirePaperMode(input);
    const out = await mutate('agent.created', input, (state) => {
      const agent = { id:createId('agent'), name:input.name || 'Unnamed Agent', role:input.role || 'research', status:'ready', model:input.model || 'polyglot-runtime', risk:input.risk || 'medium', capabilities:input.capabilities || [], created_at:new Date().toISOString() };
      state.agents.push(agent); return agent;
    }); return json(res, 201, { ok:true, ...out });
  }

  if (req.method === 'POST' && url.pathname === '/api/strategies') {
    const input = await body(req); requirePaperMode(input);
    if (Number(input.risk_limit || 0) > s.governance.max_strategy_risk_limit) return json(res, 403, { ok:false, error:'strategy risk limit exceeds governance maximum' });
    const out = await mutate('strategy.created', input, (state) => {
      const strategy = { id:createId('strategy'), name:input.name || 'Untitled Strategy', market:input.market || 'BTC-USD', timeframe:input.timeframe || '15m', signal:input.signal || 'custom', risk_limit:Number(input.risk_limit || 0.01), status:'paper', created_at:new Date().toISOString() };
      state.strategies.push(strategy); return strategy;
    }); return json(res, 201, { ok:true, ...out });
  }

  if (req.method === 'POST' && url.pathname === '/api/workflows') {
    const input = await body(req);
    const out = await mutate('workflow.created', input, (state) => {
      const workflow = { id:createId('workflow'), name:input.name || 'Untitled Workflow', status:'active', stages:Array.isArray(input.stages) ? input.stages : ['market-data','signal-agent','risk-gate','paper-order','clearing','receipt'], created_at:new Date().toISOString() };
      state.workflows.push(workflow); return workflow;
    }); return json(res, 201, { ok:true, ...out });
  }

  if (req.method === 'POST' && url.pathname === '/api/orders') {
    const input = await body(req); requirePaperMode(input);
    const notional = Number(input.quantity || 0) * Number(input.price || 0);
    if (notional > s.governance.max_order_notional_usd) return json(res, 403, { ok:false, error:'order exceeds max notional' });
    const approval = notional >= s.governance.human_approval_threshold_usd ? 'required' : 'not-required';
    const out = await mutate('paper-order.proposed', input, (state) => {
      const order = { id:createId('order'), symbol:input.symbol || 'BTC-USD', side:input.side || 'buy', quantity:Number(input.quantity || 0), price:Number(input.price || 0), type:input.type || 'limit', mode:'paper', status:approval === 'required' ? 'pending-approval' : 'accepted-paper', human_approval:approval, created_at:new Date().toISOString() };
      state.orders.push(order); return order;
    }); return json(res, 201, { ok:true, ...out });
  }

  if (req.method === 'POST' && url.pathname === '/api/backtests') {
    const input = await body(req);
    const strategy = s.strategies.find(x => x.id === input.strategy_id) || s.strategies[0];
    const result = { id:createId('backtest'), strategy_id:strategy?.id, market:strategy?.market || 'BTC-USD', period:input.period || '90d', mode:'deterministic-paper-simulation', metrics:{ return_pct:8.4, max_drawdown_pct:3.1, sharpe:1.42, win_rate:0.57, trades:184 }, created_at:new Date().toISOString() };
    const out = await mutate('backtest.completed', input, (state) => { state.backtests.push(result); state.tokenomics.PXGPU += 1; return result; });
    return json(res, 201, { ok:true, ...out });
  }

  if (req.method === 'POST' && url.pathname === '/api/governance/evaluate') {
    const input = await body(req); const blocked = ['live-broker-route','custody','public-token-sale','mainnet-autonomous-trading'].includes(input.action);
    const out = await mutate('governance.evaluated', input, () => ({ decision:blocked ? 'deny' : 'allow-paper-testnet', score:blocked ? 0.08 : 0.91, reason:blocked ? 'blocked by production boundary' : 'allowed inside paper/testnet/internal-credit boundary' }));
    return json(res, 200, { ok:true, ...out });
  }

  if (url.pathname.startsWith('/api/')) return json(res, 404, { ok:false, error:'unknown api route' });
  return staticFile(url.pathname, res);
}
