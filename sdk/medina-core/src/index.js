/**
 * @medina/medina-core — SHARED CORE PRIMITIVES
 */

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

function secureHexId(bytes = 16) {
  const normalizedBytes = Number.isFinite(bytes) && bytes > 0 ? Math.floor(bytes) : 16;
  const buffer = new Uint8Array(normalizedBytes);

  if (globalThis.crypto && typeof globalThis.crypto.getRandomValues === 'function') {
    globalThis.crypto.getRandomValues(buffer);
  } else {
    for (let i = 0; i < buffer.length; i++) {
      buffer[i] = Math.floor(Math.abs(Math.sin((Date.now() + i) * PHI)) * 256);
    }
  }

  return Array.from(buffer).map((value) => value.toString(16).padStart(2, '0')).join('');
}

function createEntityId(prefix, now = Date.now, random = Math.random) {
  return `${prefix}_${now()}_${random().toString(36).substr(2, 9)}`;
}

export {
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  secureHexId,
  createEntityId,
};

export default {
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  secureHexId,
  createEntityId,
};
