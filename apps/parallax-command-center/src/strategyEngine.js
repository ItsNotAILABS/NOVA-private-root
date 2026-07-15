import { createId } from './state.js';

const clamp = (value, min, max) => Math.min(max, Math.max(min, value));

export function evaluateStrategy(state, input = {}) {
  const strategy = state.strategies.find((item) => item.id === input.strategy_id);
  if (!strategy) throw new Error('strategy not found');
  const market = state.markets.find((item) => item.symbol === strategy.market);
  if (!market) throw new Error('market not found');

  const change = Number(market.change || 0);
  const signalType = String(strategy.signal || '').toLowerCase();
  let direction = 'flat';
  let confidence = 0.5;

  if (signalType.includes('momentum') || signalType.includes('ema')) {
    direction = change > 0 ? 'buy' : change < 0 ? 'sell' : 'flat';
    confidence = clamp(0.5 + Math.abs(change) / 10, 0.5, 0.95);
  } else if (signalType.includes('mean') || signalType.includes('z-score')) {
    direction = change > 1 ? 'sell' : change < -1 ? 'buy' : 'flat';
    confidence = clamp(0.5 + Math.abs(change) / 12, 0.5, 0.92);
  } else {
    direction = change >= 0 ? 'buy' : 'sell';
    confidence = 0.55;
  }

  const maxRisk = Number(state.governance.max_strategy_risk_limit || 0.03);
  const approvedRisk = Math.min(Number(strategy.risk_limit || 0.01), maxRisk);
  const maxNotional = Number(state.governance.max_order_notional_usd || 100000);
  const requestedNotional = Number(input.notional_usd || 10000);
  const notional = Math.min(requestedNotional, maxNotional);
  const quantity = market.price > 0 ? Number((notional / market.price).toFixed(8)) : 0;

  return {
    id: createId('signal'),
    strategy_id: strategy.id,
    symbol: market.symbol,
    direction,
    confidence: Number(confidence.toFixed(4)),
    risk_limit: approvedRisk,
    proposed_notional_usd: notional,
    proposed_quantity: quantity,
    reference_price: market.price,
    environment: 'paper',
    status: direction === 'flat' ? 'no-trade' : 'proposed',
    generated_at: new Date().toISOString()
  };
}

export function createPaperOrderFromSignal(state, signal) {
  if (signal.status !== 'proposed') return { skipped: true, reason: 'signal produced no trade' };
  const notional = signal.proposed_quantity * signal.reference_price;
  const approval = notional >= state.governance.human_approval_threshold_usd ? 'required' : 'not-required';
  const order = {
    id: createId('order'),
    strategy_id: signal.strategy_id,
    signal_id: signal.id,
    symbol: signal.symbol,
    side: signal.direction,
    quantity: signal.proposed_quantity,
    price: signal.reference_price,
    type: 'limit',
    mode: 'paper',
    status: approval === 'required' ? 'pending-approval' : 'accepted-paper',
    human_approval: approval,
    created_at: new Date().toISOString()
  };
  state.orders.push(order);
  return order;
}
