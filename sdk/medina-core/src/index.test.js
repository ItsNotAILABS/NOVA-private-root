import test from 'node:test';
import assert from 'node:assert/strict';
import { PHI, PHI_INV, HEARTBEAT_MS, secureHexId, createEntityId } from './index.js';

test('shared sovereign constants are stable', () => {
  assert.equal(PHI, 1.6180339887498948482);
  assert.equal(PHI_INV, 0.6180339887498948482);
  assert.equal(HEARTBEAT_MS, 873);
});

test('secureHexId returns expected hex length', () => {
  const hex = secureHexId(8);
  assert.equal(hex.length, 16);
  assert.match(hex, /^[0-9a-f]+$/);
});

test('createEntityId produces deterministic format', () => {
  const id = createEntityId('evt', () => 42, () => 0.123456789);
  assert.match(id, /^evt_42_[a-z0-9]+$/);
});
