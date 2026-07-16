import { createId } from './state.js';

const allowedTriggers = new Set(['schedule','tradingview','manual','market-scan']);
const allowedActions = new Set(['run-strategy','request-signal','run-backtest','propose-paper-order','evaluate-risk','prepare-wallet-intent']);

export function createBot(input = {}) {
  const trigger = input.trigger || 'manual';
  if (!allowedTriggers.has(trigger)) throw new Error('unsupported bot trigger');
  const actions = Array.isArray(input.actions) ? input.actions : ['request-signal','evaluate-risk','propose-paper-order'];
  if (actions.some((action) => !allowedActions.has(action))) throw new Error('unsupported bot action');
  return {
    id: createId('bot'),
    name: input.name || 'Untitled Trading Bot',
    description: input.description || '',
    trigger,
    actions,
    strategy_id: input.strategy_id || null,
    symbols: Array.isArray(input.symbols) ? input.symbols.map(String) : [],
    default_notional: Number(input.default_notional || 1000),
    risk_profile: input.risk_profile || 'conservative',
    mode: 'paper',
    status: input.enabled === false ? 'paused' : 'active',
    created_at: new Date().toISOString()
  };
}

export function updateBot(bot, input = {}) {
  if (!bot) throw new Error('bot not found');
  if (input.mode && input.mode !== 'paper') throw new Error('live bot mode is disabled');
  if (input.actions && input.actions.some((action) => !allowedActions.has(action))) throw new Error('unsupported bot action');
  Object.assign(bot, {
    name: input.name ?? bot.name,
    description: input.description ?? bot.description,
    actions: input.actions ?? bot.actions,
    symbols: input.symbols ?? bot.symbols,
    default_notional: input.default_notional ? Number(input.default_notional) : bot.default_notional,
    strategy_id: input.strategy_id ?? bot.strategy_id,
    status: input.status ?? bot.status,
    updated_at: new Date().toISOString()
  });
  return bot;
}
