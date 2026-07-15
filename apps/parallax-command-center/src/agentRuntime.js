import crypto from 'node:crypto';
import { createId } from './state.js';

const hashNumber = (value) => {
  const hex = crypto.createHash('sha256').update(String(value)).digest('hex').slice(0, 12);
  return Number.parseInt(hex, 16) / 0xffffffffffff;
};

export function evaluateSignal({ strategy, market }) {
  const seed = `${strategy.id}:${market.symbol}:${market.price}:${market.change}`;
  const score = Number((hashNumber(seed) * 2 - 1).toFixed(4));
  const threshold = strategy.signal === 'z-score' ? 0.22 : 0.18;
  const direction = score > threshold ? 'buy' : score < -threshold ? 'sell' : 'hold';
  return {
    id: createId('signal'),
    strategy_id: strategy.id,
    symbol: market.symbol,
    score,
    threshold,
    direction,
    source: 'deterministic-runtime-agent',
    created_at: new Date().toISOString()
  };
}

export function evaluateRisk({ state, strategy, signal, requestedNotional }) {
  const maxNotional = state.governance.max_order_notional_usd;
  const strategyLimit = state.governance.max_strategy_risk_limit;
  const reasons = [];
  if (strategy.risk_limit > strategyLimit) reasons.push('strategy-risk-limit');
  if (requestedNotional > maxNotional) reasons.push('max-order-notional');
  if (signal.direction === 'hold') reasons.push('no-actionable-signal');
  const humanApproval = requestedNotional >= state.governance.human_approval_threshold_usd;
  return {
    id: createId('risk'),
    decision: reasons.length ? 'deny' : humanApproval ? 'review' : 'allow-paper',
    reasons,
    human_approval_required: humanApproval,
    requested_notional: requestedNotional,
    created_at: new Date().toISOString()
  };
}

export function buildPaperOrder({ strategy, signal, market, risk, notional }) {
  if (risk.decision === 'deny') return null;
  const quantity = Number((notional / market.price).toFixed(8));
  return {
    id: createId('order'),
    strategy_id: strategy.id,
    signal_id: signal.id,
    symbol: market.symbol,
    side: signal.direction,
    quantity,
    price: market.price,
    type: 'market-simulated',
    mode: 'paper',
    status: risk.decision === 'review' ? 'pending-approval' : 'accepted-paper',
    human_approval: risk.human_approval_required ? 'required' : 'not-required',
    created_at: new Date().toISOString()
  };
}

export function settlePaperOrder({ order, market }) {
  if (!order || order.status !== 'accepted-paper') return null;
  const slippageBps = 4;
  const multiplier = order.side === 'buy' ? 1 + slippageBps / 10000 : 1 - slippageBps / 10000;
  const fillPrice = Number((market.price * multiplier).toFixed(8));
  return {
    id: createId('fill'),
    order_id: order.id,
    symbol: order.symbol,
    side: order.side,
    quantity: order.quantity,
    fill_price: fillPrice,
    notional: Number((order.quantity * fillPrice).toFixed(2)),
    settlement_mode: 'paper-ledger',
    created_at: new Date().toISOString()
  };
}
