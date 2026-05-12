import test from 'node:test';
import assert from 'node:assert/strict';
import { Event, EVENT_STATUS, EventHandler, EventBus } from './index.js';

test('Event fail transitions to DEAD_LETTER after third failure', () => {
  const event = new Event('agent.created', { id: 1 });
  event.failed(new Error('1'));
  event.failed(new Error('2'));
  event.failed(new Error('3'));
  assert.equal(event.status, EVENT_STATUS.DEAD_LETTER);
  assert.equal(event.deliveryAttempts, 3);
});

test('Event derive preserves causation and correlation ids', () => {
  const parent = new Event('parent', {}, { id: 'evt_parent' });
  const child = parent.derive('child', { ok: true });
  assert.equal(child.causationId, 'evt_parent');
  assert.equal(child.correlationId, 'evt_parent');
});

test('EventHandler filter supports type prefix matching', () => {
  const handler = new EventHandler('h1', async () => {}, { filter: 'agent' });
  assert.equal(handler.shouldHandle(new Event('agent.created', {})), true);
  assert.equal(handler.shouldHandle(new Event('billing.created', {})), false);
});

test('EventBus onAll receives emitted event', async () => {
  const bus = new EventBus();
  let seen = false;
  bus.onAll(async (event) => { if (event.type === 'heartbeat.tick') seen = true; }, { timeout: 1 });
  await bus.emitAsync('heartbeat.tick', { beat: 1 });
  assert.equal(seen, true);
});
