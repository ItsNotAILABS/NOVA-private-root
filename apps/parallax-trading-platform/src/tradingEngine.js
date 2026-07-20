import crypto from 'node:crypto';
import { makeId } from './store.js';

const now = () => new Date().toISOString();
const unit = (seed) => Number.parseInt(crypto.createHash('sha256').update(seed).digest('hex').slice(0, 12), 16) / 0xffffffffffff;

export function normalizeSymbol(symbol = '') {
  return String(symbol).toUpperCase().replace(/[^A-Z0-9:_-]/g, '').split(':').at(-1);
}

export function normalizeAlert(input = {}) {
  const action = String(input.action || input.side || input.signal || '').toLowerCase();
  if (!['buy','sell','close','hold'].includes(action)) throw new Error('TradingView action must be buy, sell, close, or hold');
  const symbol = normalizeSymbol(input.symbol || input.ticker);
  if (!symbol) throw new Error('symbol is required');
  return {
    id: makeId('alert'),
    external_id: String(input.alert_id || input.id || makeId('tv')),
    source:'tradingview',
    symbol,
    exchange:String(input.exchange || '').toUpperCase(),
    action,
    price:Number(input.price || input.close || 0),
    timeframe:String(input.timeframe || input.interval || ''),
    strategy_id:input.strategy_id || null,
    bot_id:input.bot_id || null,
    notional:Number(input.notional || 0),
    raw:input,
    received_at:now()
  };
}

export function generateNativeSignal({ strategy, market }) {
  const score = Number((unit(`${strategy.id}:${market.symbol}:${market.price}:${market.change_pct}:${Date.now() >> 16}`) * 2 - 1).toFixed(4));
  const threshold = strategy.rules?.entry?.includes('zscore') ? 0.35 : 0.22;
  return {
    id:makeId('sig'), source:'native-agent', strategy_id:strategy.id, symbol:market.symbol,
    action:score > threshold ? 'buy' : score < -threshold ? 'sell' : 'hold', score, threshold,
    price:market.price, created_at:now()
  };
}

export function signalFromAlert(alert, strategy) {
  return {
    id:makeId('sig'), source:'tradingview', alert_id:alert.id, strategy_id:strategy?.id || alert.strategy_id,
    symbol:alert.symbol, action:alert.action, score:null, price:alert.price, timeframe:alert.timeframe,
    created_at:now()
  };
}

export function evaluateRisk({ state, bot, strategy, signal, requestedNotional }) {
  const reasons = [];
  const settings = state.settings;
  const portfolio = state.portfolios[0];
  const today = new Date().toISOString().slice(0,10);
  const dailyLoss = Math.min(0, state.fills.filter(x => x.created_at.startsWith(today)).reduce((sum,x) => sum + Number(x.realized_pnl || 0), 0));
  const openPositions = portfolio.positions.filter(x => Number(x.quantity) !== 0).length;
  const notional = Number(requestedNotional || strategy?.default_notional || 0);
  const maxBot = Number(bot?.max_notional || settings.max_order_notional);
  if (!['buy','sell','close'].includes(signal.action)) reasons.push('non-actionable-signal');
  if (notional <= 0) reasons.push('invalid-notional');
  if (notional > settings.max_order_notional) reasons.push('platform-max-notional');
  if (notional > maxBot) reasons.push('bot-max-notional');
  if (Number(strategy?.risk_limit || 0) > 0.05) reasons.push('strategy-risk-limit');
  if (Math.abs(dailyLoss) >= settings.max_daily_loss) reasons.push('daily-loss-limit');
  if (openPositions >= settings.max_open_positions && signal.action !== 'close') reasons.push('max-open-positions');
  const approval = notional >= settings.require_human_approval_above;
  return {
    id:makeId('risk'), signal_id:signal.id, bot_id:bot?.id || null, strategy_id:strategy?.id || null,
    requested_notional:notional, decision:reasons.length ? 'deny' : approval ? 'review' : 'allow',
    reasons, human_approval_required:approval, evaluated_at:now()
  };
}

export function createOrder({ signal, strategy, bot, risk, market }) {
  if (risk.decision === 'deny') return null;
  const price = Number(signal.price || market?.price || 0);
  if (!(price > 0)) throw new Error('valid market or alert price is required');
  const quantity = Number((risk.requested_notional / price).toFixed(8));
  return {
    id:makeId('ord'), workspace_id:'ws_primary', portfolio_id:'pf_primary', bot_id:bot?.id || null,
    strategy_id:strategy?.id || null, signal_id:signal.id, symbol:signal.symbol, side:signal.action,
    quantity, requested_price:price, type:'market', time_in_force:'day', mode:'paper',
    status:risk.decision === 'review' ? 'pending-approval' : 'accepted',
    created_at:now(), updated_at:now()
  };
}

export function fillOrder({ order, market }) {
  if (!order || order.status !== 'accepted') return null;
  const base = Number(market?.price || order.requested_price);
  const bps = 3 + Math.round(unit(order.id) * 4);
  const direction = order.side === 'buy' ? 1 : -1;
  const fillPrice = Number((base * (1 + direction * bps / 10000)).toFixed(8));
  return {
    id:makeId('fill'), order_id:order.id, symbol:order.symbol, side:order.side, quantity:order.quantity,
    fill_price:fillPrice, notional:Number((fillPrice * order.quantity).toFixed(2)), slippage_bps:bps,
    venue:'PARALLAX-PAPER', realized_pnl:0, created_at:now()
  };
}

export function applyFill(portfolio, fill) {
  const signed = fill.side === 'buy' ? fill.quantity : -fill.quantity;
  let position = portfolio.positions.find(x => x.symbol === fill.symbol);
  if (!position) {
    position = { symbol:fill.symbol, quantity:0, average_price:0, mark:fill.fill_price, unrealized_pnl:0 };
    portfolio.positions.push(position);
  }
  const oldQty = Number(position.quantity);
  const newQty = Number((oldQty + signed).toFixed(8));
  if (oldQty === 0 || Math.sign(oldQty) === Math.sign(signed)) {
    const oldCost = Math.abs(oldQty) * Number(position.average_price || 0);
    const newCost = Math.abs(signed) * fill.fill_price;
    position.average_price = Number(((oldCost + newCost) / Math.max(Math.abs(newQty), 1e-12)).toFixed(8));
  }
  position.quantity = newQty;
  position.mark = fill.fill_price;
  portfolio.cash = Number((portfolio.cash - signed * fill.fill_price).toFixed(2));
  portfolio.nav = Number((portfolio.cash + portfolio.positions.reduce((sum,p) => sum + Number(p.quantity) * Number(p.mark), 0)).toFixed(2));
  portfolio.updated_at = now();
}

export function runWorkflow({ state, strategy, bot, signal, notional }) {
  const market = state.markets.find(x => normalizeSymbol(x.symbol) === normalizeSymbol(signal.symbol)) || { symbol:signal.symbol, price:signal.price };
  const risk = evaluateRisk({ state, bot, strategy, signal, requestedNotional:notional });
  const order = createOrder({ signal, strategy, bot, risk, market });
  const fill = fillOrder({ order, market });
  state.signals.push(signal);
  state.risk_decisions.push(risk);
  if (order) state.orders.push(order);
  if (fill) {
    state.fills.push(fill);
    applyFill(state.portfolios[0], fill);
  }
  if (bot) { bot.runs = Number(bot.runs || 0) + 1; bot.updated_at = now(); }
  return { signal, risk, order, fill, status:fill ? 'filled-paper' : order?.status || 'no-trade' };
}
