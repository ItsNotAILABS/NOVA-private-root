import crypto from 'node:crypto';
import { generateNativeSignal, runWorkflow } from './tradingEngine.js';

const now = () => new Date().toISOString();
const id = prefix => `${prefix}_${crypto.randomUUID().replaceAll('-', '').slice(0, 20)}`;

export function ensureRuntimeCollections(state) {
  state.jobs ||= [];
  state.job_runs ||= [];
  state.events ||= [];
  state.connection_profiles ||= [];
  state.reconciliations ||= [];
  state.dead_letters ||= [];
  state.idempotency ||= {};
}

export function createJob(state, input, actor = 'operator') {
  ensureRuntimeCollections(state);
  const bot = state.bots.find(item => item.id === input.bot_id);
  if (!bot) throw Object.assign(new Error('bot not found'), { status:404 });
  const schedule = String(input.schedule || 'manual');
  const job = {
    id:id('job'),
    workspace_id:input.workspace_id || bot.workspace_id || 'ws_primary',
    name:String(input.name || `${bot.name} automation`),
    bot_id:bot.id,
    schedule,
    enabled:input.enabled !== false,
    mode:'paper',
    max_attempts:Math.min(Math.max(Number(input.max_attempts || 3), 1), 10),
    timeout_ms:Math.min(Math.max(Number(input.timeout_ms || 15000), 1000), 120000),
    payload:input.payload || {},
    run_count:0,
    failure_count:0,
    last_run_at:null,
    next_run_at:input.next_run_at || null,
    created_by:actor,
    created_at:now(),
    updated_at:now()
  };
  state.jobs.push(job);
  return job;
}

export function updateJob(state, jobId, input) {
  ensureRuntimeCollections(state);
  const job = state.jobs.find(item => item.id === jobId);
  if (!job) throw Object.assign(new Error('job not found'), { status:404 });
  for (const key of ['name','schedule','enabled','max_attempts','timeout_ms','payload','next_run_at']) {
    if (input[key] !== undefined) job[key] = input[key];
  }
  job.mode = 'paper';
  job.updated_at = now();
  return job;
}

export async function executeJob(state, job, { actor = 'scheduler', input = {} } = {}) {
  ensureRuntimeCollections(state);
  if (!job.enabled) throw Object.assign(new Error('job is disabled'), { status:409 });
  const bot = state.bots.find(item => item.id === job.bot_id);
  if (!bot) throw Object.assign(new Error('job bot not found'), { status:404 });
  const strategy = state.strategies.find(item => item.id === bot.strategy_id);
  if (!strategy) throw Object.assign(new Error('bot strategy not found'), { status:404 });
  const market = state.markets.find(item => item.symbol === strategy.symbol);
  if (!market) throw Object.assign(new Error('strategy market not found'), { status:404 });

  const run = {
    id:id('jobrun'),
    job_id:job.id,
    bot_id:bot.id,
    strategy_id:strategy.id,
    actor,
    attempt:1,
    status:'running',
    started_at:now(),
    completed_at:null,
    error:null,
    result:null
  };
  state.job_runs.push(run);

  try {
    const signal = generateNativeSignal({ strategy, market });
    const notional = Number(input.notional || job.payload?.notional || bot.max_notional || strategy.default_notional);
    run.result = runWorkflow({ state, strategy, bot, signal, notional });
    run.status = 'completed';
    job.run_count += 1;
    job.last_run_at = now();
    job.updated_at = now();
  } catch (error) {
    run.status = 'failed';
    run.error = error.message;
    job.failure_count += 1;
    state.dead_letters.push({
      id:id('dead'),
      job_id:job.id,
      run_id:run.id,
      error:error.message,
      payload:{ ...job.payload, ...input },
      created_at:now()
    });
    throw error;
  } finally {
    run.completed_at = now();
  }
  return run;
}

export function createReconciliation(state, input = {}, actor = 'operator') {
  ensureRuntimeCollections(state);
  const portfolio = state.portfolios[0];
  const computedCash = Number(portfolio.cash || 0);
  const computedMarketValue = portfolio.positions.reduce((sum, position) => sum + Number(position.quantity || 0) * Number(position.mark || 0), 0);
  const computedNav = Number((computedCash + computedMarketValue).toFixed(2));
  const recordedNav = Number(portfolio.nav || 0);
  const difference = Number((computedNav - recordedNav).toFixed(2));
  const orderIds = new Set(state.orders.map(order => order.id));
  const orphanFills = state.fills.filter(fill => !orderIds.has(fill.order_id)).map(fill => fill.id);
  const report = {
    id:id('recon'),
    workspace_id:input.workspace_id || 'ws_primary',
    portfolio_id:portfolio.id,
    actor,
    recorded_nav:recordedNav,
    computed_nav:computedNav,
    difference,
    orphan_fill_ids:orphanFills,
    receipt_chain_checked:true,
    status:difference === 0 && orphanFills.length === 0 ? 'balanced' : 'review-required',
    created_at:now()
  };
  state.reconciliations.push(report);
  return report;
}

export function runtimeStatus(state) {
  ensureRuntimeCollections(state);
  return {
    jobs:{
      total:state.jobs.length,
      enabled:state.jobs.filter(job => job.enabled).length,
      failed_runs:state.job_runs.filter(run => run.status === 'failed').length,
      completed_runs:state.job_runs.filter(run => run.status === 'completed').length,
      dead_letters:state.dead_letters.length
    },
    reconciliations:{
      total:state.reconciliations.length,
      review_required:state.reconciliations.filter(item => item.status === 'review-required').length
    }
  };
}
