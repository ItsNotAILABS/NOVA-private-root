import { createId } from './state.js';

const now = () => new Date().toISOString();

export function createAutomation(input = {}) {
  const cadence = input.cadence || 'manual';
  const allowedCadence = ['manual', 'hourly', 'daily', 'market-open', 'market-close', 'event-driven'];
  if (!allowedCadence.includes(cadence)) throw new Error('unsupported automation cadence');
  return {
    id: createId('automation'),
    name: input.name || 'Untitled Automation',
    agent_id: input.agent_id || 'agent_nova_hft',
    workflow_id: input.workflow_id || 'workflow_signal_to_receipt',
    strategy_id: input.strategy_id || null,
    cadence,
    trigger: input.trigger || { type: cadence },
    enabled: input.enabled !== false,
    execution_mode: 'paper',
    approval_policy: input.approval_policy || 'governance-threshold',
    max_runs_per_day: Math.max(1, Math.min(1000, Number(input.max_runs_per_day || 24))),
    run_count: 0,
    last_run_at: null,
    next_run_at: null,
    status: 'ready',
    created_at: now()
  };
}

export function runAutomation(state, automationId, context = {}) {
  const automation = state.automations.find((item) => item.id === automationId);
  if (!automation) throw new Error('automation not found');
  if (!automation.enabled) throw new Error('automation disabled');
  if (automation.run_count >= automation.max_runs_per_day) throw new Error('automation daily run limit reached');

  const workflow = state.workflows.find((item) => item.id === automation.workflow_id);
  const strategy = state.strategies.find((item) => item.id === automation.strategy_id) || null;
  const market = state.markets.find((item) => item.symbol === (strategy?.market || context.symbol)) || state.markets[0];

  const run = {
    id: createId('run'),
    automation_id: automation.id,
    workflow_id: workflow?.id || automation.workflow_id,
    strategy_id: strategy?.id || null,
    agent_id: automation.agent_id,
    environment: state.environment,
    started_at: now(),
    status: 'completed-paper',
    stages: [],
    context: {
      symbol: market?.symbol || 'BTC-USD',
      market_price: market?.price || 0,
      source: context.source || 'operator-or-scheduler'
    }
  };

  const stages = workflow?.stages || ['market-data', 'signal-agent', 'risk-gate', 'paper-order', 'clearing', 'receipt'];
  for (const stage of stages) {
    run.stages.push({ stage, status: 'completed', at: now() });
  }

  automation.run_count += 1;
  automation.last_run_at = run.started_at;
  automation.status = 'ready';
  state.automation_runs.push(run);
  return run;
}
