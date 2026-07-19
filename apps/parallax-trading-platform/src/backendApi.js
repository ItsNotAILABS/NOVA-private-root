import { getState, transact, save, verifyReceiptChain } from './store.js';
import { requestContext, redactSecrets } from './apiAuth.js';
import { adapterCatalog, tradingViewUrl, upsertConnection, testConnection, connectionSummary } from './connectionRuntime.js';
import { createJob, updateJob, executeJob, createReconciliation, runtimeStatus, ensureRuntimeCollections } from './automationRuntime.js';
import { createEventBus } from './eventBus.js';
import { securityHeaders } from './security.js';

const bus = createEventBus({ getState, save });

function send(res, status, payload, extra={}) {
  res.writeHead(status, { 'content-type':'application/json; charset=utf-8', 'cache-control':'no-store', ...securityHeaders(), ...extra });
  res.end(JSON.stringify(payload));
}

async function body(req, limit = 1_000_000) {
  const chunks=[]; let size=0;
  for await (const chunk of req) {
    size += chunk.length;
    if (size > limit) throw Object.assign(new Error('request body too large'), { status:413 });
    chunks.push(chunk);
  }
  const raw = Buffer.concat(chunks).toString('utf8');
  return raw ? JSON.parse(raw) : {};
}

const routeId = pathname => pathname.split('/').filter(Boolean).at(-1);

export async function handleBackendApi(req, res, url) {
  if (!url.pathname.startsWith('/api/v1/')) return false;
  const state = getState();
  ensureRuntimeCollections(state);

  try {
    if (req.method === 'GET' && url.pathname === '/api/v1/platform') {
      const ctx = requestContext(req, 'read');
      return send(res, 200, {
        ok:true,
        platform:{
          name:'PARALLAX Trading Platform',
          schema:state.schema,
          execution_mode:state.settings.execution_mode,
          receipt_chain_valid:verifyReceiptChain(),
          live_enabled:false,
          custody_enabled:false,
          runtime:runtimeStatus(state),
          connections:connectionSummary(state),
          counts:{ strategies:state.strategies.length, bots:state.bots.length, orders:state.orders.length, fills:state.fills.length }
        },
        context:ctx
      });
    }

    if (req.method === 'GET' && url.pathname === '/api/v1/adapters') {
      requestContext(req, 'read');
      return send(res, 200, { ok:true, adapters:adapterCatalog() });
    }

    if (req.method === 'GET' && url.pathname === '/api/v1/connections') {
      requestContext(req, 'read');
      return send(res, 200, { ok:true, ...connectionSummary(state) });
    }

    if (req.method === 'POST' && url.pathname === '/api/v1/connections') {
      const ctx = requestContext(req, 'connection:write');
      const input = await body(req);
      const out = await transact('connection.upserted', redactSecrets(input), s => upsertConnection(s, input, ctx.actor), ctx.actor, ctx.request_id);
      await bus.emit('connection.updated', { connection_id:out.result.profile.id, provider:out.result.profile.provider }, ctx);
      return send(res, 201, { ok:true, ...out });
    }

    if (req.method === 'POST' && /^\/api\/v1\/connections\/[^/]+\/test$/.test(url.pathname)) {
      const ctx = requestContext(req, 'connection:write');
      const id = url.pathname.split('/')[4];
      const profile = state.connection_profiles.find(item => item.id === id);
      if (!profile) throw Object.assign(new Error('connection not found'), { status:404 });
      const result = await testConnection(state, profile);
      await save();
      await bus.emit('connection.tested', { connection_id:id, result }, ctx);
      return send(res, result.ok ? 200 : 503, { ok:result.ok, result, profile:redactSecrets(profile) });
    }

    if (req.method === 'GET' && url.pathname === '/api/v1/tradingview/link') {
      requestContext(req, 'read');
      return send(res, 200, { ok:true, url:tradingViewUrl({ symbol:url.searchParams.get('symbol') || 'COINBASE:BTCUSD', interval:url.searchParams.get('interval') || '15' }) });
    }

    if (req.method === 'GET' && url.pathname === '/api/v1/jobs') {
      requestContext(req, 'read');
      return send(res, 200, { ok:true, jobs:state.jobs, runs:state.job_runs.slice(-100).reverse(), dead_letters:state.dead_letters.slice(-100).reverse() });
    }

    if (req.method === 'POST' && url.pathname === '/api/v1/jobs') {
      const ctx = requestContext(req, 'bot:write');
      const input = await body(req);
      const out = await transact('job.created', input, s => createJob(s, input, ctx.actor), ctx.actor, ctx.request_id);
      await bus.emit('job.created', { job_id:out.result.id, bot_id:out.result.bot_id }, ctx);
      return send(res, 201, { ok:true, ...out });
    }

    if (req.method === 'PATCH' && /^\/api\/v1\/jobs\/[^/]+$/.test(url.pathname)) {
      const ctx = requestContext(req, 'bot:write');
      const input = await body(req);
      const id = routeId(url.pathname);
      const out = await transact('job.updated', input, s => updateJob(s, id, input), ctx.actor, ctx.request_id);
      return send(res, 200, { ok:true, ...out });
    }

    if (req.method === 'POST' && /^\/api\/v1\/jobs\/[^/]+\/run$/.test(url.pathname)) {
      const ctx = requestContext(req, 'bot:run');
      const input = await body(req);
      const id = url.pathname.split('/')[4];
      const job = state.jobs.find(item => item.id === id);
      if (!job) throw Object.assign(new Error('job not found'), { status:404 });
      const out = await transact('job.executed', input, s => executeJob(s, job, { actor:ctx.actor, input }), ctx.actor, ctx.request_id);
      await bus.emit('job.completed', { job_id:id, run_id:out.result.id, status:out.result.status }, ctx);
      return send(res, 201, { ok:true, ...out });
    }

    if (req.method === 'GET' && url.pathname === '/api/v1/events') {
      requestContext(req, 'read');
      return send(res, 200, { ok:true, events:bus.query({ topic:url.searchParams.get('topic') || undefined, limit:url.searchParams.get('limit') || 100, after:url.searchParams.get('after') || undefined }) });
    }

    if (req.method === 'POST' && url.pathname === '/api/v1/reconciliations') {
      const ctx = requestContext(req, 'read');
      const input = await body(req);
      const out = await transact('reconciliation.completed', input, s => createReconciliation(s, input, ctx.actor), ctx.actor, ctx.request_id);
      await bus.emit('reconciliation.completed', { reconciliation_id:out.result.id, status:out.result.status }, ctx);
      return send(res, 201, { ok:true, ...out });
    }

    if (req.method === 'GET' && url.pathname === '/api/v1/reconciliations') {
      requestContext(req, 'read');
      return send(res, 200, { ok:true, reconciliations:state.reconciliations.slice().reverse() });
    }

    return send(res, 404, { ok:false, error:'unknown v1 API route' });
  } catch (error) {
    return send(res, error.status || 500, { ok:false, error:error.message });
  }
}
