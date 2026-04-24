// ═══════════════════════════════════════════════════════════════════════════════
// MEMORIA OPERANS — Salience-Scored Memory Store Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// In-memory Map with salience decay, access boosting, and pattern search.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI          = 1.618033988749895;
const INV_PHI      = 0.618033988749895;
const TAU          = 6.283185307179586;
const HEARTBEAT_MS = 873;

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  phase: Math.random() * TAU,
  freq: TAU / HEARTBEAT_MS,
  tick() {
    this.phase = (this.phase + this.freq * HEARTBEAT_MS * 0.001) % TAU;
    return { phase: this.phase, pulse: Math.sin(this.phase) };
  }
};

// ─── MEMORY STORE ───────────────────────────────────────────────────────────────
const store = new Map();
let tickCount = 0;
const DECAY_PER_TICK = 0.01;

// ─── CORE OPERATIONS ────────────────────────────────────────────────────────────

function storeEntry(key, value, salience) {
  const s = typeof salience === 'number' ? Math.max(0, Math.min(1, salience)) : 0.5;
  store.set(key, {
    key,
    value,
    salience: s,
    createdAt: Date.now(),
    accessCount: 0,
    decayRate: DECAY_PER_TICK
  });
  return { key, salience: s, stored: true };
}

function recallEntry(key) {
  const entry = store.get(key);
  if (!entry) return { key, found: false };
  // Boost salience on access (diminishing returns via φ)
  entry.accessCount++;
  entry.salience = Math.min(1, entry.salience + INV_PHI / (entry.accessCount + 1));
  return { key, value: entry.value, salience: entry.salience, accessCount: entry.accessCount, found: true };
}

function consolidate() {
  const pruned = [];
  for (const [key, entry] of store) {
    if (entry.salience < 0.1) {
      pruned.push(key);
      store.delete(key);
    }
  }
  return { pruned, prunedCount: pruned.length, remaining: store.size };
}

function decayAll(factor) {
  const f = typeof factor === 'number' ? factor : DECAY_PER_TICK;
  for (const entry of store.values()) {
    entry.salience = Math.max(0, entry.salience - f);
  }
  return { factor: f, remaining: store.size };
}

function searchKeys(pattern) {
  const results = [];
  const regex = new RegExp(pattern, 'i');
  for (const [key, entry] of store) {
    if (regex.test(key)) {
      results.push({ key, salience: entry.salience, accessCount: entry.accessCount });
    }
  }
  // Sort by salience descending
  results.sort((a, b) => b.salience - a.salience);
  return results;
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  const { cmd, key, value, salience, factor, pattern } = e.data || {};
  switch (cmd) {
    case 'STORE':
      self.postMessage({ cmd, result: storeEntry(key, value, salience) });
      break;
    case 'RECALL':
      self.postMessage({ cmd, result: recallEntry(key) });
      break;
    case 'CONSOLIDATE':
      self.postMessage({ cmd, result: consolidate() });
      break;
    case 'DECAY':
      self.postMessage({ cmd, result: decayAll(factor) });
      break;
    case 'SEARCH':
      self.postMessage({ cmd, results: searchKeys(pattern || '') });
      break;
    case 'GET_STATUS': {
      const heart = MiniHeart.tick();
      let totalSalience = 0;
      for (const entry of store.values()) totalSalience += entry.salience;
      self.postMessage({
        cmd, status: {
          worker: 'MEMORIA_OPERANS', tickCount, heartPhase: heart.phase,
          entryCount: store.size,
          avgSalience: store.size > 0 ? totalSalience / store.size : 0,
          totalSalience
        }
      });
      break;
    }
    default:
      self.postMessage({ cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT — Auto-decay all entries each tick ───────────────────────────────
setInterval(() => {
  tickCount++;
  decayAll(DECAY_PER_TICK);
  const heart = MiniHeart.tick();
  self.postMessage({ type: 'heartbeat', worker: 'MEMORIA_OPERANS', tick: tickCount, heart, entries: store.size });
}, HEARTBEAT_MS);
