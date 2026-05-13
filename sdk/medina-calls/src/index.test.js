import test from 'node:test';
import assert from 'node:assert/strict';
import { CALL_TYPES, CALL_STATUS, InternalCalls, ExternalCalls, CallRecord } from './index.js';

function wait(ms = 10) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

test('InternalCalls keeps INTERNAL contract and completes via handler', async () => {
  const calls = new InternalCalls();
  calls.registerHandler('sum', (a, b) => a + b);

  const record = calls.call('sum', [2, 3], 'agent:A', 'agent:B');
  await wait();

  assert.equal(record.type, CALL_TYPES.INTERNAL);
  assert.equal(record.status, CALL_STATUS.COMPLETED);
  assert.equal(record.result, 5);
});

test('ExternalCalls enforces rate limits for same source+method', () => {
  const calls = new ExternalCalls();
  calls.registerHandler('ping', () => 'pong', { rateLimit: { maxCalls: 1, windowMs: 1000 } });

  calls.call('ping', [], 'user-1');
  assert.throws(() => calls.call('ping', [], 'user-1'), /Rate limit exceeded/);
});

test('CallRecord retries before terminal failure', () => {
  const record = new CallRecord(CALL_TYPES.EXTERNAL, 'missing', [], 'user', 'system');
  record.fail(new Error('one'));
  assert.equal(record.status, CALL_STATUS.RETRYING);
  assert.equal(record.retries, 1);
});
