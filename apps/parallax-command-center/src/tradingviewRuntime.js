import crypto from 'node:crypto';
import { createId } from './state.js';

const safeEqual = (a, b) => {
  const left = Buffer.from(String(a || ''));
  const right = Buffer.from(String(b || ''));
  return left.length === right.length && crypto.timingSafeEqual(left, right);
};

export function verifyTradingViewRequest({ rawBody, headers, config }) {
  const suppliedToken = headers['x-parallax-webhook-token'];
  const suppliedSignature = headers['x-parallax-signature'];
  const tokenValid = config.tradingView.webhookToken && safeEqual(suppliedToken, config.tradingView.webhookToken);
  const expectedSignature = config.tradingView.webhookSecret
    ? crypto.createHmac('sha256', config.tradingView.webhookSecret).update(rawBody).digest('hex')
    : '';
  const signatureValid = expectedSignature && safeEqual(suppliedSignature, expectedSignature);
  return Boolean(tokenValid || signatureValid);
}

export function normalizeTradingViewAlert(input = {}) {
  const action = String(input.action || input.side || input.signal || '').toLowerCase();
  if (!['buy', 'sell', 'close', 'hold'].includes(action)) throw new Error('unsupported TradingView action');
  const symbol = String(input.symbol || input.ticker || '').trim().toUpperCase();
  if (!symbol) throw new Error('TradingView symbol is required');
  const price = Number(input.price || input.close || 0);
  const quantity = Number(input.quantity || input.qty || 0);
  const notional = Number(input.notional || (price > 0 && quantity > 0 ? price * quantity : 0));
  return {
    id: createId('tv'),
    source: 'tradingview-webhook',
    symbol,
    action,
    price,
    quantity,
    notional,
    strategy_id: input.strategy_id || null,
    bot_id: input.bot_id || null,
    timeframe: input.timeframe || input.interval || null,
    alert_id: input.alert_id || input.id || null,
    raw: input,
    received_at: new Date().toISOString()
  };
}

export function routeAlertToPaperWorkflow({ alert, state }) {
  const strategy = state.strategies.find((item) => item.id === alert.strategy_id)
    || state.strategies.find((item) => item.market === alert.symbol)
    || state.strategies[0];
  if (!strategy) throw new Error('no strategy available for TradingView alert');
  return {
    strategy_id: strategy.id,
    symbol: alert.symbol,
    notional: alert.notional || strategy.default_notional || 1000,
    mode: 'paper',
    source_alert_id: alert.id,
    requested_action: alert.action
  };
}
