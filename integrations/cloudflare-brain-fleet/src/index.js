const JSON_HEADERS = {
  'content-type': 'application/json; charset=utf-8',
  'cache-control': 'no-store'
};

const MAX_BODY_BYTES = 64 * 1024;
const DEFAULT_LEASE_MS = 30_000;
const DEFAULT_HEARTBEAT_MS = 20_000;
const CAPABILITIES = new Set([
  'repo.monitor',
  'repo.ci',
  'repo.repair-plan',
  'release.validate',
  'docs.summarize',
  'edge.inference',
  'browser.mesh',
  'memory.recall',
  'receipt.emit'
]);

function json(body, status = 200) {
  return new Response(JSON.stringify(body, null, 2), { status, headers: JSON_HEADERS });
}

function notFound() {
  return json({ ok: false, error: 'not_found' }, 404);
}

async function readJson(request) {
  const size = Number(request.headers.get('content-length') || 0);
  if (size > MAX_BODY_BYTES) throw new Error('body_too_large');
  const text = await request.text();
  if (!text.trim()) return {};
  if (new TextEncoder().encode(text).byteLength > MAX_BODY_BYTES) throw new Error('body_too_large');
  return JSON.parse(text);
}

async function sha256(value) {
  const data = new TextEncoder().encode(typeof value === 'string' ? value : JSON.stringify(value));
  const digest = await crypto.subtle.digest('SHA-256', data);
  return [...new Uint8Array(digest)].map((byte) => byte.toString(16).padStart(2, '0')).join('');
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

export class BrainCoordinator {
  constructor(state, env) {
    this.state = state;
    this.env = env;
  }

  async fetch(request) {
    const url = new URL(request.url);
    try {
      if (request.method === 'GET' && url.pathname.endsWith('/health')) return this.health();
      const auth = requireToken(request, this.env);
      if (!auth.ok) return auth.response;
      if (request.method === 'POST' && url.pathname.endsWith('/brains/register')) return this.register(request, auth.actor);
      if (request.method === 'POST' && url.pathname.match(/\/brains\/[^/]+\/heartbeat$/)) return this.heartbeat(request, auth.actor);
      if (request.method === 'GET' && url.pathname.endsWith('/brains')) return this.listBrains();
      if (request.method === 'POST' && url.pathname.endsWith('/tasks')) return this.enqueue(request, auth.actor);
      if (request.method === 'POST' && url.pathname.endsWith('/tasks/claim')) return this.claim(request, auth.actor);
      if (request.method === 'POST' && url.pathname.match(/\/tasks\/[^/]+\/complete$/)) return this.complete(request, auth.actor);
      if (request.method === 'GET' && url.pathname.endsWith('/tasks')) return this.listTasks();
      if (request.method === 'GET' && url.pathname.endsWith('/receipts')) return this.receipts();
      return notFound();
    } catch (error) {
      return json({ ok: false, error: error.message || 'internal_error' }, error.message === 'body_too_large' ? 413 : 400);
    }
  }

  async health() {
    return json({ ok: true, service: 'nova-cloudflare-brain-fleet', schema: 'nova.edge.brain_fleet.v1' });
  }

  async register(request, actor) {
    const body = await readJson(request);
    const id = String(body.id || crypto.randomUUID()).slice(0, 80);
    const now = new Date().toISOString();
    const brain = {
      schema: 'nova.edge.brain.v1',
      id,
      actor,
      region: request.cf?.colo || body.region || 'unknown',
      role: String(body.role || 'edge-brain').slice(0, 80),
      capabilities: normalizeCapabilities(body.capabilities),
      repo: String(body.repo || '').slice(0, 120),
      registeredAt: now,
      lastHeartbeatAt: now,
      heartbeatMs: Number(body.heartbeatMs || DEFAULT_HEARTBEAT_MS)
    };
    await this.state.storage.put(`brain:${id}`, brain);
    await this.receipt('brain.registered', actor, { brain });
    return json({ ok: true, brain });
  }

  async heartbeat(request, actor) {
    const id = new URL(request.url).pathname.split('/').at(-2);
    const brain = await this.state.storage.get(`brain:${id}`);
    if (!brain) return json({ ok: false, error: 'brain_not_registered' }, 404);
    brain.lastHeartbeatAt = new Date().toISOString();
    await this.state.storage.put(`brain:${id}`, brain);
    await this.receipt('brain.heartbeat', actor, { id });
    return json({ ok: true, brain });
  }

  async listBrains() {
    const list = await this.state.storage.list({ prefix: 'brain:' });
    return json({ ok: true, brains: [...list.values()] });
  }

  async enqueue(request, actor) {
    const body = await readJson(request);
    const task = {
      schema: 'nova.edge.brain_task.v1',
      id: String(body.id || crypto.randomUUID()).slice(0, 80),
      actor,
      type: String(body.type || 'repo.monitor').slice(0, 80),
      repo: String(body.repo || '').slice(0, 120),
      payload: body.payload || {},
      priority: Number(body.priority || 0),
      status: 'queued',
      createdAt: new Date().toISOString(),
      leaseExpiresAt: null,
      leasedBy: null,
      attempts: 0
    };
    if (!CAPABILITIES.has(task.type)) return json({ ok: false, error: 'capability_not_allowed' }, 403);
    task.hash = await sha256(task);
    await this.state.storage.put(`task:${task.id}`, task);
    await this.receipt('task.enqueued', actor, { id: task.id, type: task.type, repo: task.repo, hash: task.hash });
    return json({ ok: true, task });
  }

  async claim(request, actor) {
    const body = await readJson(request);
    const brainId = String(body.brainId || '').slice(0, 80);
    const brain = await this.state.storage.get(`brain:${brainId}`);
    if (!brain) return json({ ok: false, error: 'brain_not_registered' }, 404);
    const tasks = [...(await this.state.storage.list({ prefix: 'task:' })).values()]
      .filter((task) => task.status === 'queued' || (task.status === 'leased' && Date.parse(task.leaseExpiresAt) < Date.now()))
      .filter((task) => brain.capabilities.includes(task.type))
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

  async complete(request, actor) {
    const id = new URL(request.url).pathname.split('/').at(-2);
    const body = await readJson(request);
    const task = await this.state.storage.get(`task:${id}`);
    if (!task) return json({ ok: false, error: 'task_not_found' }, 404);
    task.status = body.ok === false ? 'failed' : 'completed';
    task.completedAt = new Date().toISOString();
    task.result = body.result || {};
    task.resultHash = await sha256(task.result);
    await this.state.storage.put(`task:${id}`, task);
    await this.receipt('task.completed', actor, { id, status: task.status, resultHash: task.resultHash });
    return json({ ok: true, task });
  }

  async listTasks() {
    const list = await this.state.storage.list({ prefix: 'task:' });
    return json({ ok: true, tasks: [...list.values()].sort((a, b) => b.createdAt.localeCompare(a.createdAt)) });
  }

  async receipt(type, actor, detail) {
    const receipt = {
      schema: 'nova.edge.brain_receipt.v1',
      id: crypto.randomUUID(),
      type,
      actor,
      detail,
      createdAt: new Date().toISOString()
    };
    receipt.hash = await sha256(receipt);
    await this.state.storage.put(`receipt:${receipt.createdAt}:${receipt.id}`, receipt);
    return receipt;
  }

  async receipts() {
    const list = await this.state.storage.list({ prefix: 'receipt:' });
    return json({ ok: true, receipts: [...list.values()].slice(-200) });
  }
}

export default {
  async fetch(request, env) {
    const id = env.BRAIN_COORDINATOR.idFromName('global');
    const coordinator = env.BRAIN_COORDINATOR.get(id);
    return coordinator.fetch(request);
  }
};
