import test from 'node:test';
import assert from 'node:assert/strict';
import { BrainCoordinator, performTask, CAPABILITIES } from '../src/index.js';

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

test('BrainCoordinator is executable and reports empty fleet health', async () => {
  const runtime = new BrainCoordinator({ storage: new MockStorage() }, {});
  const response = await runtime.health();
  const body = await response.json();
  assert.equal(response.status, 200);
  assert.equal(body.ok, true);
  assert.equal(body.metrics.brains, 0);
  assert.equal(body.metrics.tasks, 0);
});

test('capability registry exposes real fleet work types', () => {
  for (const capability of ['repo.monitor', 'repo.ci', 'repo.repair-plan', 'release.validate', 'edge.inference', 'receipt.emit']) {
    assert.equal(CAPABILITIES.has(capability), true);
  }
  assert.equal(CAPABILITIES.has('shell.exec'), false);
});

test('performTask creates deterministic repair plans without external services', async () => {
  const result = await performTask({ type: 'repo.repair-plan', repo: 'ItsNotAILABS/NOVA-private-root', priority: 7, payload: { workflow: 'CI', failures: ['install deps', 'rerun tests'] } }, {});
  assert.equal(result.ok, true);
  assert.equal(result.plan.repo, 'ItsNotAILABS/NOVA-private-root');
  assert.equal(result.plan.actions.length, 2);
  assert.ok(result.plan.guardrails.includes('no secret exposure'));
});

test('performTask executes local edge inference deterministically', async () => {
  const result = await performTask({ type: 'edge.inference', payload: { prompt: 'Fix Cloudflare worker CI and release harness' } }, {});
  assert.equal(result.ok, true);
  assert.ok(result.tags.includes('ci-repair'));
  assert.ok(result.tags.includes('release-harness'));
  assert.ok(result.tags.includes('edge-fleet'));
});
