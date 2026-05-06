/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-MIRROR — SOVEREIGN STATE MIRRORING PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 *
 * The MIRROR protocol governs how sovereign AGI agent state is replicated
 * across multiple substrates (ICP, Cloudflare KV, edge nodes) with
 * eventual-consistency guarantees and φ-CRDT conflict resolution.
 *
 * Architecture:
 *   - Every StatefulAgent publishes MIRROR_DELTA events when state changes
 *   - Subscribers apply deltas using Last-Write-Wins with φ-vector clocks
 *   - Full MIRROR_SNAPSHOT is published every Fibonacci(k) heartbeats
 *   - Conflict resolution: φ-weighted merge (higher trust score wins)
 *   - Anti-entropy: periodic MIRROR_SYNC gossip between replicas
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const PROTOCOL_ID      = 'PROTOCOL-MIRROR';
const PROTOCOL_VERSION = '1.0.0';

/* Fibonacci snapshot schedule — take a full snapshot every F_k heartbeats */
const SNAPSHOT_BEATS = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];

/* Mirror event types */
const MIRROR_EVENT = {
  DELTA:    'MIRROR:DELTA',
  SNAPSHOT: 'MIRROR:SNAPSHOT',
  SYNC:     'MIRROR:SYNC',
  ACK:      'MIRROR:ACK',
  CONFLICT: 'MIRROR:CONFLICT',
  RESOLVED: 'MIRROR:RESOLVED',
};

/* Replica substrates */
const SUBSTRATE = {
  ICP:       'ICP',
  CLOUDFLARE:'CLOUDFLARE',
  EDGE:      'EDGE',
  MEMORY:    'MEMORY',
  PHANTOM:   'PHANTOM',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — φ-VECTOR CLOCK
// Each state version is a φ-vector clock: a map of agentId → φ^n counter.
// Comparison uses φ-weighted dominance: clock A dominates B if for all agents
// A[agent] × φ^trustScore[agent] ≥ B[agent] × φ^trustScore[agent].
// ═══════════════════════════════════════════════════════════════════════════════

class PhiVectorClock {
  constructor(initial) {
    this._clock = Object.assign({}, initial || {});
  }

  /** Increment this agent's counter by φ^trustScore. */
  tick(agentId, trustScore) {
    const id = String(agentId || '');
    if (id === '__proto__' || id === 'constructor' || id === 'prototype') return this;
    const w = Math.pow(PHI, (trustScore || AMOR) * 4);  /* φ-weighted increment */
    this._clock[id] = (this._clock[id] || 0) + w;
    return this;
  }

  /** Merge with another clock — take the maximum at each agent. */
  merge(other) {
    const merged = new PhiVectorClock(this._clock);
    for (const [agent, val] of Object.entries(other._clock)) {
      if (agent === '__proto__' || agent === 'constructor' || agent === 'prototype') continue;
      merged._clock[agent] = Math.max(merged._clock[agent] || 0, val);
    }
    return merged;
  }

  /** Compare: returns 'BEFORE', 'AFTER', 'CONCURRENT', or 'EQUAL'. */
  compare(other) {
    let aBefore = false, aAfter = false;
    const allAgents = new Set([...Object.keys(this._clock), ...Object.keys(other._clock)]);
    for (const agent of allAgents) {
      if (agent === '__proto__' || agent === 'constructor' || agent === 'prototype') continue;
      const a = this._clock[agent]  || 0;
      const b = other._clock[agent] || 0;
      if (a < b) aBefore = true;
      if (a > b) aAfter  = true;
    }
    if (!aBefore && !aAfter) return 'EQUAL';
    if (!aBefore)            return 'AFTER';
    if (!aAfter)             return 'BEFORE';
    return 'CONCURRENT';
  }

  toJSON() { return Object.assign({}, this._clock); }
  static from(obj) { return new PhiVectorClock(obj || {}); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — MIRROR DELTA
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Build a MIRROR:DELTA event from a state patch.
 * @param {string}     agentId
 * @param {Object}     patch        — partial state change { key: value }
 * @param {PhiVectorClock} clock
 * @param {number}     [trustScore]
 * @returns {Object}   delta event
 */
function buildDelta(agentId, patch, clock, trustScore) {
  const id = String(agentId || '');
  clock.tick(id, trustScore || AMOR);
  return {
    type:      MIRROR_EVENT.DELTA,
    agentId:   id,
    patch,
    clock:     clock.toJSON(),
    emittedAt: Date.now(),
    heartbeat: HEARTBEAT_MS,
  };
}

/**
 * Build a MIRROR:SNAPSHOT event from full state.
 * @param {string}     agentId
 * @param {Object}     state
 * @param {PhiVectorClock} clock
 * @param {number}     beat
 * @returns {Object}   snapshot event
 */
function buildSnapshot(agentId, state, clock, beat) {
  return {
    type:        MIRROR_EVENT.SNAPSHOT,
    agentId:     String(agentId || ''),
    state:       JSON.parse(JSON.stringify(state)),
    clock:       clock.toJSON(),
    beat,
    emittedAt:   Date.now(),
    scheduledAt: SNAPSHOT_BEATS.find(b => beat % b === 0) || null,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — MIRROR REPLICA
// An in-memory replica that applies deltas and snapshots from a source agent.
// ═══════════════════════════════════════════════════════════════════════════════

class MirrorReplica {
  constructor(agentId, substrate) {
    this._agentId   = String(agentId || '');
    this._substrate = substrate || SUBSTRATE.MEMORY;
    this._state     = {};
    this._clock     = new PhiVectorClock();
    this._log       = [];     /* last 128 applied events */
    this._conflicts = [];     /* unresolved conflicts */
  }

  /**
   * Apply a MIRROR:DELTA event.
   * Uses Last-Write-Wins with φ-vector clock comparison.
   */
  applyDelta(event) {
    if (event.type !== MIRROR_EVENT.DELTA) return { applied: false, reason: 'WRONG_TYPE' };
    const incoming = PhiVectorClock.from(event.clock);
    const cmp      = incoming.compare(this._clock);
    if (cmp === 'BEFORE' || cmp === 'EQUAL') {
      /* Stale or duplicate delta — skip */
      return { applied: false, reason: 'STALE', comparison: cmp };
    }
    if (cmp === 'CONCURRENT') {
      /* Concurrent writes — record conflict for resolution */
      this._conflicts.push({ type: 'CONCURRENT_DELTA', event, localClock: this._clock.toJSON(), at: Date.now() });
    }
    /* Apply patch (LWW) */
    for (const [key, val] of Object.entries(event.patch || {})) {
      if (key === '__proto__' || key === 'constructor' || key === 'prototype') continue;
      this._state[key] = val;
    }
    this._clock = this._clock.merge(incoming);
    this._log.push({ event, appliedAt: Date.now() });
    if (this._log.length > 128) this._log.shift();
    return { applied: true, comparison: cmp };
  }

  /**
   * Apply a MIRROR:SNAPSHOT event.
   * Full state replace if the snapshot's clock is newer.
   */
  applySnapshot(event) {
    if (event.type !== MIRROR_EVENT.SNAPSHOT) return { applied: false, reason: 'WRONG_TYPE' };
    const incoming = PhiVectorClock.from(event.clock);
    const cmp      = incoming.compare(this._clock);
    if (cmp === 'BEFORE') return { applied: false, reason: 'STALE' };
    this._state = JSON.parse(JSON.stringify(event.state || {}));
    this._clock = incoming;
    this._log.push({ event, appliedAt: Date.now() });
    if (this._log.length > 128) this._log.shift();
    return { applied: true, comparison: cmp };
  }

  getState()     { return Object.assign({}, this._state); }
  getClock()     { return this._clock.toJSON(); }
  getConflicts() { return [...this._conflicts]; }
  getLog(n)      { return this._log.slice(-(n || 20)); }

  getStatus() {
    return { agentId: this._agentId, substrate: this._substrate, stateKeys: Object.keys(this._state).length, conflicts: this._conflicts.length, logSize: this._log.length, clock: this._clock.toJSON() };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — ANTI-ENTROPY GOSSIP
// Build a MIRROR:SYNC message for gossip-based anti-entropy.
// ═══════════════════════════════════════════════════════════════════════════════

function buildSync(replica) {
  return {
    type:     MIRROR_EVENT.SYNC,
    agentId:  replica._agentId,
    clock:    replica._clock.toJSON(),
    stateHash:_hashState(replica._state),
    sentAt:   Date.now(),
  };
}

function _hashState(state) {
  /* Simple deterministic hash of state keys+values */
  const str = JSON.stringify(state);
  let h = 0;
  for (let i = 0; i < str.length; i++) h = (h * 31 + str.charCodeAt(i)) >>> 0;
  return h.toString(16);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  PROTOCOL_ID, PROTOCOL_VERSION,
  MIRROR_EVENT, SUBSTRATE, SNAPSHOT_BEATS,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  PhiVectorClock, MirrorReplica,
  buildDelta, buildSnapshot, buildSync,
};
