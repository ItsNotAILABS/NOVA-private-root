import test from 'node:test';
import assert from 'node:assert/strict';
import { HEARTBEAT_MS, RHYTHM_STATES, HeartbeatProtocol } from '../PROTOCOL-HEARTBEAT.js';

function delay(ms = 20) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

test('HeartbeatProtocol defaults to sovereign period', () => {
  const protocol = new HeartbeatProtocol();
  assert.equal(protocol.period, HEARTBEAT_MS);
  assert.equal(protocol.getState(), RHYTHM_STATES.ASYSTOLE);
});

test('HeartbeatProtocol emits beats and returns to asystole on stop', async () => {
  const protocol = new HeartbeatProtocol({ period: 5, tolerance: 100, maxBeats: 10 });
  protocol.start();
  await delay(30);
  protocol.stop();

  const stats = protocol.getStats();
  assert.ok(stats.totalBeats > 0);
  assert.equal(protocol.getState(), RHYTHM_STATES.ASYSTOLE);
});

test('HeartbeatProtocol syncWith sets next beat time', () => {
  const protocol = new HeartbeatProtocol({ period: 100 });
  protocol.start();
  const targetTime = Date.now() + 1000;
  protocol.syncWith(targetTime);
  assert.ok(protocol.getNextBeatTime() !== null);
  protocol.stop();
});
