import { ensureState, getState, mutate, createId } from './state.js';
import { evaluateSignal, evaluateRisk, buildPaperOrder, settlePaperOrder } from './agentRuntime.js';

let timer;
let running = false;

async function executeStrategy(strategy) {
  const state = getState();
  const market = state.markets.find((item) => item.symbol === strategy.market);
  if (!market || strategy.status !== 'paper') return null;
  const notional = Number(strategy.default_notional || 10000);

  return mutate('automation.scheduler-cycle.completed', { strategy_id:strategy.id, notional }, (current) => {
    const signal = evaluateSignal({ strategy, market });
    const risk = evaluateRisk({ state:current, strategy, signal, requestedNotional:notional });
    const order = buildPaperOrder({ strategy, signal, market, risk, notional });
    const fill = settlePaperOrder({ order, market });

    current.signals.push(signal);
    current.risk_decisions.push(risk);
    if (order) current.orders.push(order);
    if (fill) current.fills.push(fill);
    if (fill) current.tokenomics.PXGPU += 1;

    const run = {
      id:createId('run'),
      workflow_id:'workflow_signal_to_receipt',
      trigger:'scheduler',
      strategy_id:strategy.id,
      agents:['agent_nova_hft','agent_argos_clear','agent_plax_sns'],
      stages:['market-data','signal-agent','risk-gate',order ? 'paper-order' : 'order-skipped',fill ? 'clearing' : 'clearing-pending','receipt'],
      signal,
      risk,
      order,
      fill,
      status:fill ? 'settled-paper' : order?.status === 'pending-approval' ? 'pending-human-approval' : 'no-trade',
      created_at:new Date().toISOString()
    };
    current.automation_runs.push(run);
    return run;
  });
}

export async function runAutomationCycle() {
  if (running) return { skipped:true, reason:'cycle-already-running' };
  running = true;
  try {
    await ensureState();
    const active = getState().strategies.filter((item) => item.status === 'paper');
    const results = [];
    for (const strategy of active) {
      try { results.push(await executeStrategy(strategy)); }
      catch (error) { results.push({ strategy_id:strategy.id, error:error.message }); }
    }
    return { skipped:false, strategies:active.length, results };
  } finally {
    running = false;
  }
}

export function startAutomationScheduler({ intervalMs = 60000, enabled = true } = {}) {
  if (!enabled || timer) return;
  timer = setInterval(() => runAutomationCycle().catch((error) => console.error('automation cycle failed', error)), intervalMs);
  timer.unref?.();
}

export function stopAutomationScheduler() {
  if (timer) clearInterval(timer);
  timer = undefined;
}
