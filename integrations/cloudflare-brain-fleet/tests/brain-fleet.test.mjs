import test from 'node:test';
import assert from 'node:assert/strict';
import { BrainCoordinator, performTask } from '../src/index.js';

class MockStorage {
  constructor() { this.map = new Map(); }
  async get(key) { return this.map.get(key); }
  async put(key, value) { this.map.set(key, value); }
  async list({ prefix } = {}) {
    const out = new Map();
    for (const [key, value] of this.map.entries()) if (!prefix || key.startsWith(prefix)) out.set(key, value);
    return out;
  }
}

function coordinator(env = {}) {
  return new BrainCoordinator({ storage: new MockStorage() }, env);
}

async function call(runtime, path, body, method = 'POST') {
  const init = { method, headers: { 'content-type': 'application/json' } };
  if (body !== undefined && method !== 'GET') init.body = JSON.stringify(body);
  const response = await runtime.fetch(new Request(`https://fleet.local/fleet${path}`, init));
  return { status: response.status, body: await response.json() };
}

test('executable runtime registers a brain, leases work, executes work, and records receipts', async () => {
  const runtime = coordinator();
  const registered = await call(runtime, '/brains/register', {
    id: 'brain-1',
    role: 'edge-inference',
    repo: 'ItsNotAILABS/NOVA-private-root',
    capabilities: ['edge.inference', 'repo.repair-plan', 'not.allowed']
  });
  assert.equal(registered.status, 200);
  assert.deepEqual(registered.body.brain.capabilities, ['edge.inference', 'repo.repair-plan']);

  const enqueued = await call(runtime, '/tasks', {
    id: 'task-1',
    type: 'edge.inference',
    repo: 'ItsNotAILABS/NOVA-private-root',
    priority: 10,
    payload: { prompt: 'Fix CI and release harness on Cloudflare Workers' }
  });
  assert.equal(enqueued.status, 200);
  assert.equal(enqueued.body.task.status, 'queued');

  const claimed = await call(runtime, '/tasks/claim', { brainId: 'brain-1', leaseMs: 1000 });
  assert.equal(claimed.status, 200);
  assert.equal(claimed.body.task.id, 'task-1');
  assert.equal(claimed.body.task.status, 'leased');

  const executed = await call(runtime, '/tasks/task-1/execute', { brainId: 'brain-1' });
  assert.equal(executed.status, 200);
  assert.equal(executed.body.task.status, 'completed');
  assert.ok(executed.body.task.result.tags.includes('ci-repair'));

  const snapshot = await call(runtime, '/snapshot', undefined, 'GET');
  assert.equal(snapshot.status, 200);
  assert.equal(snapshot.body.brains.length, 1);
  assert.equal(snapshot.body.tasks.length, 1);
  assert.ok(snapshot.body.receipts.length >= 4);
});

test('seeds a 71 brain fleet and scheduled ticks enqueue repo CI tasks', async () => {
  const runtime = coordinator({ NOVA_FLEET_REPOS: 'ItsNotAILABS/NOVA-private-root,ItsNotAILABS/SNS---TOKEN' });
  const seeded = await call(runtime, '/brains/seed', { count: 71 });
  assert.equal(seeded.status, 200);
  assert.equal(seeded.body.created.length, 71);

  const scheduled = await call(runtime, '/internal/scheduled', {});
  assert.equal(scheduled.status, 200);
  assert.equal(scheduled.body.created, 2);

  const metrics = await call(runtime, '/metrics', undefined, 'GET');
  assert.equal(metrics.body.metrics.brains, 71);
  assert.equal(metrics.body.metrics.byStatus.queued, 2);
});

test('unsupported capabilities are rejected and lease ownership is enforced', async () => {
  const runtime = coordinator();
  const rejected = await call(runtime, '/tasks', { type: 'shell.exec', payload: {} });
  assert.equal(rejected.status, 403);

  await call(runtime, '/brains/register', { id: 'brain-a', capabilities: ['docs.summarize'] });
  await call(runtime, '/brains/register', { id: 'brain-b', capabilities: ['docs.summarize'] });
  await call(runtime, '/tasks', { id: 'doc-task', type: 'docs.summarize', payload: { text: 'One. Two. Three.' } });
  await call(runtime, '/tasks/claim', { brainId: 'brain-a' });
  const denied = await call(runtime, '/tasks/doc-task/execute', { brainId: 'brain-b' });
  assert.equal(denied.status, 403);
});

test('performTask creates deterministic repair plans without external services', async () => {
  const result = await performTask({ type: 'repo.repair-plan', repo: 'ItsNotAILABS/NOVA-private-root', priority: 7, payload: { workflow: 'CI', failures: ['install deps', 'rerun tests'] } }, {});
  assert.equal(result.ok, true);
  assert.equal(result.plan.repo, 'ItsNotAILABS/NOVA-private-root');
  assert.equal(result.plan.actions.length, 2);
  assert.ok(result.plan.guardrails.includes('no secret exposure'));
});
