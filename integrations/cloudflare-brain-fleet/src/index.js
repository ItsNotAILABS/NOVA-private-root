const JSON_HEADERS = { 'content-type': 'application/json; charset=utf-8', 'cache-control': 'no-store' };
const MAX_BODY_BYTES = 128 * 1024;
const DEFAULT_LEASE_MS = 30_000;
const DEFAULT_HEARTBEAT_MS = 20_000;
const DEFAULT_MAX_ATTEMPTS = 3;
const DEFAULT_RECEIPT_LIMIT = 500;
const DEFAULT_TASK_LIMIT = 500;

export const CAPABILITIES = new Set([
  'repo.monitor',
  'repo.ci',
  'repo.repair-plan',
  'repo.autofix-plan',
  'release.validate',
  'docs.summarize',
  'edge.inference',
  'browser.mesh',
  'memory.recall',
  'receipt.emit'
]);

const TERMINAL_TASK_STATES = new Set(['completed', 'failed', 'denied', 'dead-lettered']);

function json(body, status = 200) {
  return new Response(JSON.stringify(body, null, 2), { status, headers: JSON_HEADERS });
}

function route(pathname) {
  return pathname.replace(/^\/fleet\/?/, '/').replace(/\/+/g, '/');
}

function nowIso() {
  return new Date().toISOString();
}

function clamp(value, max = 120) {
  return String(value || '').slice(0, max);
}

function parseRepo(value) {
  const repo = clamp(value, 180);
  if (!/^[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+$/.test(repo)) return null;
  return repo;
}

async function sha256(value) {
  const data = new TextEncoder().encode(typeof value === 'string' ? value : JSON.stringify(value));
  const digest = await crypto.subtle.digest('SHA-256', data);
  return [...new Uint8Array(digest)].map((byte) => byte.toString(16).padStart(2, '0')).join('');
}

async function readJson(request) {
  const declared = Number(request.headers.get('content-length') || 0);
  if (declared > MAX_BODY_BYTES) throw Object.assign(new Error('body_too_large'), { status: 413 });
  const text = await request.text();
  if (!text.trim()) return {};
  if (new TextEncoder().encode(text).byteLength > MAX_BODY_BYTES) throw Object.assign(new Error('body_too_large'), { status: 413 });
  try {
    return JSON.parse(text);
  } catch {
    throw Object.assign(new Error('invalid_json'), { status: 400 });
  }
}

function requireToken(request, env) {
  const expected = env.NOVA_BRAIN_FLEET_TOKEN;
  if (!expected) return { ok: true, actor: 'local-dev' };
  const token = request.headers.get('authorization')?.replace(/^Bearer\s+/i, '') || request.headers.get('x-nova-brain-token');
  if (token !== expected) return { ok: false, response: json({ ok: false, error: 'unauthorized' }, 401) };
  return { ok: true, actor: request.headers.get('x-nova-actor') || 'operator' };
}

function normalizeCapabilities(input = []) {
  return [...new Set(input)].filter((capability) => CAPABILITIES.has(capability));
}

async function githubFetch(env, path) {
  const headers = {
    accept: 'application/vnd.github+json',
    'user-agent': 'nova-cloudflare-brain-fleet',
    'x-github-api-version': '2022-11-28'
  };
  if (env.GITHUB_TOKEN) headers.authorization = `Bearer ${env.GITHUB_TOKEN}`;
  const response = await fetch(`https://api.github.com${path}`, { headers });
  const text = await response.text();
  let body;
  try { body = text ? JSON.parse(text) : {}; } catch { body = { text: text.slice(0, 4000) }; }
  return { ok: response.ok, status: response.status, body };
}

function repairPlan(task, source) {
  const repo = task.repo || source.repo || 'unknown/repo';
  const workflow = source.workflow || source.name || 'repo workflow';
  const failures = Array.isArray(source.failures) ? source.failures : [];
  const steps = failures.length ? failures : ['inspect failing workflow logs', 'patch root cause', 'rerun affected checks'];
  return {
    schema: 'nova.edge.repair_plan.v1',
    repo,
    workflow,
    priority: task.priority,
    actions: steps.map((item, index) => ({ order: index + 1, action: String(item).slice(0, 240) })),
    guardrails: ['no secret exposure', 'no force merge while required checks fail', 'operator approval before production deployment'],
    generatedAt: nowIso()
  };
}

function localInference(payload = {}) {
  const prompt = String(payload.prompt || payload.text || '').trim();
  const lowered = prompt.toLowerCase();
  const tags = [];
  if (/ci|build|test|workflow|error|fail/.test(lowered)) tags.push('ci-repair');
  if (/release|manifest|schema|harness/.test(lowered)) tags.push('release-harness');
  if (/repo|pull request|github|branch/.test(lowered)) tags.push('repo-ops');
  if (/memory|recall|continuity/.test(lowered)) tags.push('memory');
  if (/cloudflare|worker|edge|durable/.test(lowered)) tags.push('edge-fleet');
  return {
    schema: 'nova.edge.local_inference.v1',
    model: 'deterministic-edge-router',
    tags: tags.length ? tags : ['general'],
    confidence: Math.min(0.95, 0.55 + tags.length * 0.1),
    summary: prompt ? prompt.slice(0, 280) : 'empty prompt',
    generatedAt: nowIso()
  };
}

function summarizeText(payload = {}) {
  const text = String(payload.text || payload.markdown || '').replace(/\s+/g, ' ').trim();
  const sentences = text.split(/(?<=[.!?])\s+/).filter(Boolean).slice(0, 5);
  return {
    schema: 'nova.edge.summary.v1',
    characters: text.length,
    summary: sentences.join(' ').slice(0, 1000),
    generatedAt: nowIso()
  };
}

export async function performTask(task, env) {
  const payload = task.payload || {};
  if (task.type === 'repo.monitor') {
    const repo = parseRepo(task.repo || payload.repo);
    if (!repo) return { ok: false, error: 'invalid_repo' };
    const meta = await githubFetch(env, `/repos/${repo}`);
    return { ok: meta.ok, kind: 'repo.monitor', status: meta.status, repo, result: meta.body };
  }
  if (task.type === 'repo.ci') {
    const repo = parseRepo(task.repo || payload.repo);
    if (!repo) return { ok: false, error: 'invalid_repo' };
    const runs = await githubFetch(env, `/repos/${repo}/actions/runs?per_page=10`);
    const reduced = (runs.body.workflow_runs || []).map((run) => ({ id: run.id, name: run.name, status: run.status, conclusion: run.conclusion, head_sha: run.head_sha, html_url: run.html_url }));
    return { ok: runs.ok, kind: 'repo.ci', status: runs.status, repo, runs: reduced };
  }
  if (task.type === 'repo.repair-plan' || task.type === 'repo.autofix-plan') {
    return { ok: true, kind: task.type, plan: repairPlan(task, payload) };
  }
  if (task.type === 'release.validate') {
    const evidence = Array.isArray(payload.evidence) ? payload.evidence : [];
    const boundaries = Array.isArray(payload.boundaries) ? payload.boundaries : [];
    return { ok: evidence.length >= 3 && boundaries.length >= 2, kind: 'release.validate', evidence: evidence.length, boundaries: boundaries.length };
  }
  if (task.type === 'docs.summarize') return { ok: true, kind: 'docs.summarize', ...summarizeText(payload) };
  if (task.type === 'edge.inference') return { ok: true, kind: 'edge.inference', ...localInference(payload) };
  if (task.type === 'browser.mesh') return { ok: true, kind: 'browser.mesh', accepted: true, channels: payload.channels || ['tabs', 'side-panel', 'service-worker'] };
  if (task.type === 'memory.recall') return { ok: true, kind: 'memory.recall', query: clamp(payload.query, 500), matches: [] };
  if (task.type === 'receipt.emit') return { ok: true, kind: 'receipt.emit', external: payload.receipt || payload };
  return { ok: false, error: 'unsupported_task_type' };
}

export class BrainCoordinator {
  constructor(state, env) {
    this.state = state;
    this.env = env;
  }

  async fetch(request) {
    const url = new URL(request.url);
    const path = route(url.pathname);
    try {
      if (request.method === 'GET' && path === '/health') return this.health();
      const auth = requireToken(request, this.env);
      if (!auth.ok) return auth.response;
      if (request.method === 'POST' && path === '/brains/register') return this.register(request, auth.actor);
      if (request.method === 'POST' && /^\/brains\/[^/]+\/heartbeat$/.test(path)) return this.heartbeat(request, auth.actor);
      if (request.method === 'GET' && path === '/brains') return this.listBrains();
      if (request.method === 'POST' && path === '/brains/seed') return this.seedBrains(request, auth.actor);
      if (request.method === 'POST' && path === '/tasks') return this.enqueue(request, auth.actor);
      if (request.method === 'POST' && path === '/tasks/claim') return this.claim(request, auth.actor);
      if (request.method === 'POST' && /^\/tasks\/[^/]+\/execute$/.test(path)) return this.execute(request, auth.actor);
      if (request.method === 'POST' && /^\/tasks\/[^/]+\/complete$/.test(path)) return this.complete(request, auth.actor);
      if (request.method === 'GET' && path === '/tasks') return this.listTasks();
      if (request.method === 'GET' && path === '/metrics') return this.metrics();
      if (request.method === 'GET' && path === '/snapshot') return this.snapshot();
      if (request.method === 'GET' && path === '/receipts') return this.receipts();
      return json({ ok: false, error: 'not_found' }, 404);
    } catch (error) {
      return json({ ok: false, error: error.message || 'internal_error' }, error.status || 400);
    }
  }

  async health() {
    const metrics = await this.computeMetrics();
    return json({ ok: true, service: 'nova-cloudflare-brain-fleet', schema: 'nova.edge.brain_fleet.v1', metrics });
  }

  async register(request, actor) {
    const body = await readJson(request);
    const id = clamp(body.id || crypto.randomUUID(), 80);
    const now = nowIso();
    const brain = {
      schema: 'nova.edge.brain.v1',
      id,
      actor,
      region: clamp(request.cf?.colo || body.region || 'unknown', 60),
      role: clamp(body.role || 'edge-brain', 80),
      capabilities: normalizeCapabilities(body.capabilities),
      repo: clamp(body.repo || '', 180),
      registeredAt: now,
      lastHeartbeatAt: now,
      heartbeatMs: Number(body.heartbeatMs || DEFAULT_HEARTBEAT_MS),
      status: 'active'
    };
    if (!brain.capabilities.length) throw new Error('brain_requires_capability');
    await this.state.storage.put(`brain:${id}`, brain);
    await this.receipt('brain.registered', actor, { brainId: id, capabilities: brain.capabilities, repo: brain.repo });
    return json({ ok: true, brain });
  }

  async heartbeat(request, actor) {
    const id = new URL(request.url).pathname.split('/').at(-2);
    const brain = await this.state.storage.get(`brain:${id}`);
    if (!brain) return json({ ok: false, error: 'brain_not_registered' }, 404);
    brain.lastHeartbeatAt = nowIso();
    brain.status = 'active';
    await this.state.storage.put(`brain:${id}`, brain);
    await this.receipt('brain.heartbeat', actor, { id });
    return json({ ok: true, brain });
  }

  async seedBrains(request, actor) {
    const body = await readJson(request);
    const repos = Array.isArray(body.repos) && body.repos.length ? body.repos : String(this.env.NOVA_FLEET_REPOS || 'ItsNotAILABS/NOVA-private-root').split(',');
    const roles = ['repo-monitor', 'ci-observer', 'repair-planner', 'release-validator', 'memory-reader', 'edge-inference'];
    const count = Math.min(Number(body.count || 71), 500);
    const created = [];
    for (let i = 0; i < count; i += 1) {
      const role = roles[i % roles.length];
      const repo = clamp(repos[i % repos.length].trim(), 180);
      const capabilities = role === 'repo-monitor' ? ['repo.monitor'] : role === 'ci-observer' ? ['repo.ci'] : role === 'repair-planner' ? ['repo.repair-plan', 'repo.autofix-plan'] : role === 'release-validator' ? ['release.validate', 'receipt.emit'] : role === 'memory-reader' ? ['memory.recall', 'docs.summarize'] : ['edge.inference', 'browser.mesh'];
      const id = clamp(`${role}-${i + 1}-${crypto.randomUUID().slice(0, 8)}`, 80);
      const now = nowIso();
      const brain = { schema: 'nova.edge.brain.v1', id, actor, role, capabilities, repo, region: 'edge-auto', registeredAt: now, lastHeartbeatAt: now, heartbeatMs: DEFAULT_HEARTBEAT_MS, status: 'active' };
      await this.state.storage.put(`brain:${id}`, brain);
      created.push({ id, role, repo, capabilities });
    }
    await this.receipt('fleet.seeded', actor, { count: created.length, repos: repos.map((repo) => clamp(repo, 180)) });
    return json({ ok: true, created });
  }

  async listBrains() {
    const list = await this.state.storage.list({ prefix: 'brain:' });
    return json({ ok: true, brains: [...list.values()] });
  }

  async enqueue(request, actor) {
    const body = await readJson(request);
    return json({ ok: true, task: await this.createTask(body, actor) });
  }

  async createTask(body, actor) {
    const type = clamp(body.type || 'repo.monitor', 80);
    if (!CAPABILITIES.has(type)) throw Object.assign(new Error('capability_not_allowed'), { status: 403 });
    const task = {
      schema: 'nova.edge.brain_task.v1',
      id: clamp(body.id || crypto.randomUUID(), 80),
      actor,
      type,
      repo: clamp(body.repo || body.payload?.repo || '', 180),
      payload: body.payload || {},
      priority: Number(body.priority || 0),
      status: 'queued',
      createdAt: nowIso(),
      leaseExpiresAt: null,
      leasedBy: null,
      attempts: 0,
      maxAttempts: Number(body.maxAttempts || DEFAULT_MAX_ATTEMPTS)
    };
    task.hash = await sha256({ ...task, hash: undefined });
    await this.state.storage.put(`task:${task.id}`, task);
    await this.receipt('task.enqueued', actor, { id: task.id, type: task.type, repo: task.repo, hash: task.hash });
    return task;
  }

  async claim(request, actor) {
    await this.recoverExpiredLeases(actor);
    const body = await readJson(request);
    const brainId = clamp(body.brainId, 80);
    const brain = await this.state.storage.get(`brain:${brainId}`);
    if (!brain) return json({ ok: false, error: 'brain_not_registered' }, 404);
    const tasks = [...(await this.state.storage.list({ prefix: 'task:' })).values()]
      .filter((task) => task.status === 'queued')
      .filter((task) => brain.capabilities.includes(task.type))
      .filter((task) => !task.repo || !brain.repo || task.repo === brain.repo)
      .sort((a, b) => b.priority - a.priority || a.createdAt.localeCompare(b.createdAt));
    const task = tasks[0];
    if (!task) return json({ ok: true, task: null });
    task.status = 'leased';
    task.leasedBy = brainId;
    task.attempts += 1;
    task.leaseExpiresAt = new Date(Date.now() + Number(body.leaseMs || DEFAULT_LEASE_MS)).toISOString();
    task.leaseHash = await sha256({ id: task.id, leasedBy: brainId, leaseExpiresAt: task.leaseExpiresAt, attempts: task.attempts });
    await this.state.storage.put(`task:${task.id}`, task);
    await this.receipt('task.claimed', actor, { id: task.id, brainId, leaseHash: task.leaseHash });
    return json({ ok: true, task });
  }

  async execute(request, actor) {
    const id = new URL(request.url).pathname.split('/').at(-2);
    const body = await readJson(request);
    const task = await this.state.storage.get(`task:${id}`);
    if (!task) return json({ ok: false, error: 'task_not_found' }, 404);
    if (TERMINAL_TASK_STATES.has(task.status)) return json({ ok: false, error: 'task_terminal' }, 409);
    if (task.status !== 'leased') return json({ ok: false, error: 'task_not_leased' }, 409);
    if (body.brainId && task.leasedBy !== body.brainId) return json({ ok: false, error: 'lease_owner_mismatch' }, 403);
    const result = await performTask(task, this.env);
    task.status = result.ok === false ? (task.attempts >= task.maxAttempts ? 'dead-lettered' : 'failed') : 'completed';
    task.completedAt = nowIso();
    task.result = result;
    task.resultHash = await sha256(result);
    await this.state.storage.put(`task:${id}`, task);
    await this.receipt('task.executed', actor, { id, status: task.status, resultHash: task.resultHash, brainId: task.leasedBy });
    return json({ ok: true, task });
  }

  async complete(request, actor) {
    const id = new URL(request.url).pathname.split('/').at(-2);
    const body = await readJson(request);
    const task = await this.state.storage.get(`task:${id}`);
    if (!task) return json({ ok: false, error: 'task_not_found' }, 404);
    if (body.brainId && task.leasedBy !== body.brainId) return json({ ok: false, error: 'lease_owner_mismatch' }, 403);
    task.status = body.ok === false ? 'failed' : 'completed';
    task.completedAt = nowIso();
    task.result = body.result || {};
    task.resultHash = await sha256(task.result);
    await this.state.storage.put(`task:${id}`, task);
    await this.receipt('task.completed', actor, { id, status: task.status, resultHash: task.resultHash });
    return json({ ok: true, task });
  }

  async recoverExpiredLeases(actor = 'system') {
    const tasks = [...(await this.state.storage.list({ prefix: 'task:' })).values()];
    let recovered = 0;
    let dead = 0;
    for (const task of tasks) {
      if (task.status !== 'leased' || !task.leaseExpiresAt || Date.parse(task.leaseExpiresAt) >= Date.now()) continue;
      if (task.attempts >= task.maxAttempts) {
        task.status = 'dead-lettered';
        dead += 1;
      } else {
        task.status = 'queued';
        task.leasedBy = null;
        task.leaseExpiresAt = null;
        recovered += 1;
      }
      await this.state.storage.put(`task:${task.id}`, task);
    }
    if (recovered || dead) await this.receipt('leases.recovered', actor, { recovered, dead });
    return { recovered, dead };
  }

  async listTasks() {
    await this.recoverExpiredLeases('system');
    const list = await this.state.storage.list({ prefix: 'task:' });
    return json({ ok: true, tasks: [...list.values()].sort((a, b) => b.createdAt.localeCompare(a.createdAt)).slice(0, DEFAULT_TASK_LIMIT) });
  }

  async computeMetrics() {
    const brains = [...(await this.state.storage.list({ prefix: 'brain:' })).values()];
    const tasks = [...(await this.state.storage.list({ prefix: 'task:' })).values()];
    const receipts = await this.state.storage.list({ prefix: 'receipt:' });
    const byStatus = tasks.reduce((acc, task) => ({ ...acc, [task.status]: (acc[task.status] || 0) + 1 }), {});
    const byCapability = brains.flatMap((brain) => brain.capabilities).reduce((acc, cap) => ({ ...acc, [cap]: (acc[cap] || 0) + 1 }), {});
    return { brains: brains.length, tasks: tasks.length, receipts: receipts.size, byStatus, byCapability };
  }

  async metrics() {
    await this.recoverExpiredLeases('system');
    return json({ ok: true, metrics: await this.computeMetrics() });
  }

  async snapshot() {
    await this.recoverExpiredLeases('system');
    const brains = [...(await this.state.storage.list({ prefix: 'brain:' })).values()];
    const tasks = [...(await this.state.storage.list({ prefix: 'task:' })).values()];
    const receipts = [...(await this.state.storage.list({ prefix: 'receipt:' })).values()].slice(-DEFAULT_RECEIPT_LIMIT);
    return json({ ok: true, schema: 'nova.edge.brain_fleet.v1', brains, tasks, receipts, metrics: await this.computeMetrics() });
  }

  async receipt(type, actor, detail) {
    const previousHash = (await this.state.storage.get('meta:receiptHead')) || null;
    const receipt = { schema: 'nova.edge.brain_receipt.v1', id: crypto.randomUUID(), type, actor, detail, previousHash, createdAt: nowIso() };
    receipt.hash = await sha256(receipt);
    await this.state.storage.put(`receipt:${receipt.createdAt}:${receipt.id}`, receipt);
    await this.state.storage.put('meta:receiptHead', receipt.hash);
    return receipt;
  }

  async receipts() {
    const list = await this.state.storage.list({ prefix: 'receipt:' });
    return json({ ok: true, receipts: [...list.values()].slice(-DEFAULT_RECEIPT_LIMIT) });
  }

  async scheduled(actor = 'scheduler') {
    await this.recoverExpiredLeases(actor);
    const repos = String(this.env.NOVA_FLEET_REPOS || 'ItsNotAILABS/NOVA-private-root').split(',').map((repo) => repo.trim()).filter(Boolean);
    const created = [];
    for (const repo of repos.slice(0, 100)) {
      created.push(await this.createTask({ type: 'repo.ci', repo, priority: 5, payload: { repo, source: 'scheduled' } }, actor));
    }
    await this.receipt('scheduler.tick', actor, { repos: repos.length, tasks: created.length });
    return { created: created.length };
  }
}

async function coordinator(env) {
  const id = env.BRAIN_COORDINATOR.idFromName(env.NOVA_BRAIN_FLEET_NAME || 'global');
  return env.BRAIN_COORDINATOR.get(id);
}

export default {
  async fetch(request, env) {
    const instance = await coordinator(env);
    return instance.fetch(request);
  },
  async scheduled(_event, env) {
    const instance = await coordinator(env);
    return instance.fetch(new Request('https://brain-fleet.local/fleet/internal/scheduled', { method: 'POST', headers: { 'x-nova-brain-token': env.NOVA_BRAIN_FLEET_TOKEN || '' } }));
  }
};