import crypto from 'node:crypto';
import fs from 'node:fs/promises';
import { config } from './config.js';

const now = () => new Date().toISOString();
const id = (prefix) => `${prefix}_${crypto.randomUUID().replaceAll('-', '').slice(0, 20)}`;
const hash = (value) => crypto.createHash('sha256').update(JSON.stringify(value)).digest('hex');

const seed = () => ({
  schema: 'parallax.trading.platform.v1',
  created_at: now(),
  updated_at: now(),
  users: [{ id:'usr_founder', name:'Alfredo Medina', role:'owner', status:'active', created_at:now() }],
  workspaces: [{ id:'ws_primary', name:'Primary Trading Workspace', owner_id:'usr_founder', members:['usr_founder'], created_at:now() }],
  sessions: [],
  connections: {
    tradingview: { status:'configured-local', webhook_path:'/api/tradingview/webhook', chart_embed:true, broker_api:false },
    alpaca: { status:'not-configured', mode:'paper' },
    ibkr: { status:'not-configured', mode:'paper' },
    coinbase: { status:'not-configured', mode:'paper' },
    kraken: { status:'not-configured', mode:'paper' },
    mt5: { status:'not-configured', mode:'paper' }
  },
  markets: [
    { symbol:'BTCUSD', exchange:'COINBASE', asset_class:'crypto', price:64250.20, change_pct:1.82, volume:934000000, updated_at:now() },
    { symbol:'ETHUSD', exchange:'COINBASE', asset_class:'crypto', price:3510.14, change_pct:-0.34, volume:512000000, updated_at:now() },
    { symbol:'AAPL', exchange:'NASDAQ', asset_class:'equity', price:228.31, change_pct:0.72, volume:63100000, updated_at:now() },
    { symbol:'EURUSD', exchange:'FX', asset_class:'forex', price:1.0862, change_pct:0.18, volume:0, updated_at:now() }
  ],
  portfolios: [{
    id:'pf_primary', workspace_id:'ws_primary', name:'PARALLAX Core', currency:'USD', cash:100000, nav:100000,
    realized_pnl:0, unrealized_pnl:0, positions:[], updated_at:now()
  }],
  strategies: [
    { id:'strat_momentum', workspace_id:'ws_primary', name:'Momentum Breakout', symbol:'BTCUSD', timeframe:'15', source:'native', status:'active', risk_limit:0.01, default_notional:2500, rules:{ entry:'price_crosses_ema', exit:'atr_or_reverse_signal' }, created_at:now() },
    { id:'strat_reversion', workspace_id:'ws_primary', name:'Mean Reversion', symbol:'EURUSD', timeframe:'5', source:'native', status:'draft', risk_limit:0.0075, default_notional:1000, rules:{ entry:'zscore_extreme', exit:'mean_reversion' }, created_at:now() }
  ],
  bots: [
    { id:'bot_alpha', workspace_id:'ws_primary', name:'Alpha Momentum Agent', strategy_id:'strat_momentum', trigger:'tradingview', symbols:['BTCUSD'], status:'active', mode:'paper', risk_profile:'balanced', max_notional:5000, allowed_actions:['signal','risk-check','paper-order','receipt'], runs:0, created_at:now(), updated_at:now() }
  ],
  alerts: [],
  signals: [],
  risk_decisions: [],
  orders: [],
  fills: [],
  wallets: [],
  wallet_intents: [],
  activity: [],
  receipts: [],
  settings: {
    execution_mode:'paper',
    require_human_approval_above:10000,
    max_order_notional:25000,
    max_daily_loss:2500,
    max_open_positions:10,
    live_enabled:false,
    custody_enabled:false
  }
});

let state;

async function persist() {
  state.updated_at = now();
  const tmp = `${config.stateFile}.tmp`;
  await fs.mkdir(config.dataDir, { recursive:true });
  await fs.writeFile(tmp, `${JSON.stringify(state, null, 2)}\n`, 'utf8');
  await fs.rename(tmp, config.stateFile);
}

export async function initStore() {
  await fs.mkdir(config.dataDir, { recursive:true });
  try {
    state = JSON.parse(await fs.readFile(config.stateFile, 'utf8'));
  } catch {
    state = seed();
    await persist();
  }
  for (const key of ['sessions','alerts','signals','risk_decisions','orders','fills','wallets','wallet_intents','activity','receipts']) state[key] ||= [];
  return state;
}

export function getState() {
  if (!state) throw new Error('store not initialized');
  return state;
}

export function makeId(prefix) { return id(prefix); }

function appendReceipt(type, input, output, actor='system') {
  const previous_hash = state.receipts.at(-1)?.hash || 'GENESIS';
  const body = { id:id('rcpt'), type, actor, timestamp:now(), previous_hash, input_hash:hash(input), output_hash:hash(output) };
  body.hash = hash(body);
  state.receipts.push(body);
  return body;
}

export function verifyReceiptChain() {
  let previous = 'GENESIS';
  for (const receipt of state.receipts) {
    const { hash:stored, ...body } = receipt;
    if (body.previous_hash !== previous || hash(body) !== stored) return false;
    previous = stored;
  }
  return true;
}

export async function transact(type, input, fn, actor='system') {
  const result = await fn(state);
  const receipt = appendReceipt(type, input, result, actor);
  state.activity.push({ id:id('evt'), type, actor, result_ref:result?.id || null, created_at:now() });
  await persist();
  return { result, receipt };
}

export async function save() { await persist(); }
