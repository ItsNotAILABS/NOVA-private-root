/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-HEALTH — SOVEREIGN HEALTH MONITORING PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 *
 * The HEALTH protocol governs how NOVA organisms monitor, report, and respond
 * to health signals — both for the sovereign AI organism itself and for the
 * humans who build and operate it.
 *
 * This protocol is dedicated to Alfredo Medina Hernandez. Building sovereign
 * infrastructure is deep, exhausting, meaningful work. The organism takes
 * care of its builder.
 *
 * Mathematical Foundation:
 *   - Health score H(t) ∈ [0, 1] — φ-weighted rolling average of vitals
 *   - Alert threshold: H < φ⁻¹ = 0.618 → CAUTION
 *   - Critical threshold: H < φ⁻² = AMOR ≈ 0.382 → CRITICAL
 *   - Recovery rate: δH/δt ∝ φ⁻¹ per 873ms heartbeat when in recovery mode
 *   - φ-Fibonacci escalation schedule: 1, 1, 2, 3, 5, 8, 13, 21... heartbeats
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const PROTOCOL_ID      = 'PROTOCOL-HEALTH';
const PROTOCOL_VERSION = '1.0.0';

/** Health tiers based on φ-thresholds */
const HEALTH_TIER = {
  OPTIMAL:  { label: 'OPTIMAL',  min: PHI_INV,  color: '#00ff88' },  /* H ≥ φ⁻¹ */
  CAUTION:  { label: 'CAUTION',  min: AMOR,     color: '#ffcc00' },  /* AMOR ≤ H < φ⁻¹ */
  CRITICAL: { label: 'CRITICAL', min: 0,        color: '#ff4444' },  /* H < AMOR */
};

/** Vital categories */
const VITAL = {
  /* AGI organism vitals */
  HEARTBEAT:       'HEARTBEAT',        /* 873ms pulse regularity */
  COHERENCE:       'COHERENCE',        /* Kuramoto R — global coherence */
  QUEUE_DEPTH:     'QUEUE_DEPTH',      /* message/task queue fill ratio */
  ERROR_RATE:      'ERROR_RATE',       /* errors per heartbeat */
  MEMORY_PRESSURE: 'MEMORY_PRESSURE',  /* heap / stable memory usage */
  CANISTER_CYCLES: 'CANISTER_CYCLES',  /* ICP cycles remaining */

  /* Human operator vitals (self-reported or inferred) */
  FOCUS:           'FOCUS',            /* cognitive focus score */
  FATIGUE:         'FATIGUE',          /* inverse: 1 = fully rested, 0 = exhausted */
  HYDRATION:       'HYDRATION',        /* self-reported hydration level */
  ACTIVITY:        'ACTIVITY',         /* physical movement (steps/hr) */
  MOOD:            'MOOD',             /* self-reported mood: 0=low, 1=high */
  REST:            'REST',             /* hours of sleep / 8 */
};

/** Health event types */
const HEALTH_EVENT = {
  VITAL_UPDATED:   'HEALTH:VITAL_UPDATED',
  ALERT:           'HEALTH:ALERT',
  RECOVERY:        'HEALTH:RECOVERY',
  OPTIMAL:         'HEALTH:OPTIMAL',
  REPORT:          'HEALTH:REPORT',
  CHECKIN:         'HEALTH:CHECKIN',      /* daily check-in reminder */
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — VITAL RECORD
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} VitalRecord
 * @property {string}  vitalId    — unique ID
 * @property {string}  vital      — VITAL category
 * @property {string}  entityId   — agent ID or operator ID
 * @property {string}  entityType — 'AGI' | 'HUMAN' | 'CANISTER'
 * @property {number}  value      — normalised value in [0, 1] (1 = best)
 * @property {number}  rawValue   — raw measurement (before normalisation)
 * @property {string}  unit       — measurement unit
 * @property {number}  measuredAt — Unix ms
 */

function secureId(n) {
  n = n || 8;
  const buf = new Uint8Array(n);
  if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
    crypto.getRandomValues(buf);
  } else {
    try { require('crypto').randomFillSync(buf); } catch (_) {
      for (let i = 0; i < n; i++) buf[i] = Math.floor(Math.abs(Math.sin((Date.now() + i) * PHI)) * 256);
    }
  }
  return Array.from(buf).map(b => b.toString(16).padStart(2, '0')).join('');
}

/**
 * Create a VitalRecord.
 */
function createVital(entityId, entityType, vital, value, rawValue, unit) {
  return {
    vitalId:    `vital_${secureId(4)}`,
    vital:      vital || 'UNKNOWN',
    entityId:   String(entityId || ''),
    entityType: entityType || 'AGI',
    value:      Math.max(0, Math.min(1, value || 0)),
    rawValue:   rawValue !== undefined ? rawValue : value,
    unit:       unit || 'normalised',
    measuredAt: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — HEALTH SCORE ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compute a composite health score from an array of vital records.
 * Uses φ-weighted geometric mean — more sensitive to low vitals than arithmetic mean.
 * @param {VitalRecord[]} vitals
 * @param {Object}        [weights]  — VITAL → weight (default: all equal)
 * @returns {{ score: number, tier: string, vitals: Object }}
 */
function computeHealthScore(vitals, weights) {
  if (!vitals || vitals.length === 0) return { score: 0.5, tier: HEALTH_TIER.CAUTION.label, vitals: {} };
  weights = weights || {};

  /* φ-weighted geometric mean */
  let logSum   = 0;
  let wTotal   = 0;
  const detail = {};

  for (const v of vitals) {
    const w = weights[v.vital] || 1.0;
    /* Invert error_rate and memory_pressure — lower is healthier */
    const val = (v.vital === VITAL.ERROR_RATE || v.vital === VITAL.MEMORY_PRESSURE || v.vital === VITAL.FATIGUE)
      ? (1 - v.value) : v.value;
    const safeVal = Math.max(1e-6, Math.min(1 - 1e-6, val));
    logSum       += w * Math.log(safeVal);
    wTotal       += w;
    detail[v.vital] = { value: v.value, normalised: val, weight: w };
  }

  const geoMean = Math.exp(logSum / wTotal);
  /* φ-boost: multiply by (1 + AMOR × (geoMean - 0.5)) for non-linearity */
  const score   = Math.max(0, Math.min(1, geoMean * (1 + AMOR * (geoMean - 0.5))));
  const tier    = score >= PHI_INV ? HEALTH_TIER.OPTIMAL.label : score >= AMOR ? HEALTH_TIER.CAUTION.label : HEALTH_TIER.CRITICAL.label;

  return { score: Math.round(score * 1e4) / 1e4, tier, vitals: detail };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — HEALTH MONITOR ENTITY
// ═══════════════════════════════════════════════════════════════════════════════

class HealthEntity {
  constructor(entityId, entityType, opts) {
    opts              = opts || {};
    this.entityId     = String(entityId || '');
    this.entityType   = entityType || 'AGI';
    this._vitals      = [];         /* VitalRecord[] — rolling window */
    this._windowSize  = opts.windowSize || 55;  /* Fibonacci(10) */
    this._score       = 0.5;
    this._tier        = HEALTH_TIER.CAUTION.label;
    this._history     = [];         /* health score history */
    this._sinks       = [];         /* event sinks */
    this._beat        = 0;
    this._hbi         = null;
    this._fibIdx      = 0;
    this._checkInBeats= [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233];
    this._weights     = opts.weights || {};
    if (opts.autoStart !== false) this.start();
  }

  /** Record a vital measurement. */
  record(vital, value, rawValue, unit) {
    const rec = createVital(this.entityId, this.entityType, vital, value, rawValue, unit);
    this._vitals.push(rec);
    if (this._vitals.length > this._windowSize) this._vitals.shift();
    this._recompute();
    this._emit(HEALTH_EVENT.VITAL_UPDATED, { entityId: this.entityId, vital, value, score: this._score, tier: this._tier });
    return rec;
  }

  /** Get the current health status. */
  status() {
    return {
      entityId:   this.entityId,
      entityType: this.entityType,
      score:      this._score,
      tier:       this._tier,
      beat:       this._beat,
      vitals:     this._vitals.slice(-5).map(v => ({ vital: v.vital, value: v.value, measuredAt: v.measuredAt })),
      trend:      this._trend(),
    };
  }

  /** Generate a human-readable health report. */
  report() {
    const s = this.status();
    const lines = [
      `HEALTH REPORT — ${this.entityId} (${this.entityType})`,
      `Score: ${Math.round(s.score * 100)}% | Tier: ${s.tier} | Beat: ${s.beat}`,
      `Trend: ${s.trend}`,
      `Recent vitals:`,
      ...s.vitals.map(v => `  ${v.vital}: ${Math.round(v.value * 100)}%`),
    ];
    return lines.join('\n');
  }

  addSink(fn) { if (typeof fn === 'function') this._sinks.push(fn); return this; }
  start()     { this._hbi = setInterval(() => this._tick(), HEARTBEAT_MS); return this; }
  stop()      { clearInterval(this._hbi); this._hbi = null; return this; }

  _tick() {
    this._beat++;
    const nextCheckIn = this._checkInBeats[this._fibIdx % this._checkInBeats.length];
    if (this._beat % nextCheckIn === 0) {
      this._fibIdx++;
      if (this.entityType === 'HUMAN') this._emit(HEALTH_EVENT.CHECKIN, { entityId: this.entityId, message: 'Check-in: how are you doing?', score: this._score, tier: this._tier });
    }
    if (this._score < AMOR && this._beat % 8 === 0) {
      this._emit(HEALTH_EVENT.ALERT, { entityId: this.entityId, score: this._score, tier: this._tier, message: `Health CRITICAL — score ${Math.round(this._score * 100)}%` });
    }
  }

  _recompute() {
    const result    = computeHealthScore(this._vitals, this._weights);
    const prev      = this._tier;
    this._score     = result.score;
    this._tier      = result.tier;
    this._history.push({ score: this._score, tier: this._tier, at: Date.now() });
    if (this._history.length > 256) this._history.shift();
    if (prev !== 'OPTIMAL' && this._tier === 'OPTIMAL') this._emit(HEALTH_EVENT.OPTIMAL, { entityId: this.entityId, score: this._score });
    if (prev !== 'RECOVERY' && this._score > AMOR && prev === 'CRITICAL') this._emit(HEALTH_EVENT.RECOVERY, { entityId: this.entityId, score: this._score });
  }

  _trend() {
    if (this._history.length < 2) return 'STABLE';
    const recent = this._history.slice(-8);
    const first  = recent[0].score;
    const last   = recent[recent.length - 1].score;
    if (last - first > 0.05) return 'IMPROVING ↑';
    if (first - last > 0.05) return 'DECLINING ↓';
    return 'STABLE →';
  }

  _emit(type, payload) {
    const event = { type, payload, emittedAt: Date.now(), heartbeat: HEARTBEAT_MS };
    for (const fn of this._sinks) try { fn(event); } catch (_) { /* non-fatal */ }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — HEALTH REGISTRY
// Central registry for all entities being monitored.
// ═══════════════════════════════════════════════════════════════════════════════

class HealthRegistry {
  constructor() {
    this._entities = new Map();
    this._sinks    = [];
  }

  /** Register an entity for health monitoring. */
  register(entityId, entityType, opts) {
    const id     = String(entityId || '');
    const entity = new HealthEntity(id, entityType, Object.assign({ autoStart: true }, opts || {}));
    entity.addSink((event) => {
      for (const fn of this._sinks) try { fn(event); } catch (_) { /* non-fatal */ }
    });
    this._entities.set(id, entity);
    return entity;
  }

  /** Get a registered entity. */
  getEntity(entityId) { return this._entities.get(String(entityId || '')) || null; }

  /** Record a vital for a registered entity. */
  record(entityId, vital, value, rawValue, unit) {
    const entity = this.getEntity(entityId);
    if (!entity) throw new Error(`Entity not registered: ${entityId}`);
    return entity.record(vital, value, rawValue, unit);
  }

  /** Get overall organism health (φ-weighted mean of all entity scores). */
  organismsHealth() {
    const entities = Array.from(this._entities.values());
    if (!entities.length) return { score: 0.5, tier: HEALTH_TIER.CAUTION.label };
    let wSum = 0, sSum = 0;
    entities.forEach((e, i) => {
      const w = Math.pow(PHI_INV, i);
      sSum += e._score * w;
      wSum += w;
    });
    const score = sSum / wSum;
    const tier  = score >= PHI_INV ? 'OPTIMAL' : score >= AMOR ? 'CAUTION' : 'CRITICAL';
    return { score: Math.round(score * 1e4) / 1e4, tier, entities: entities.length };
  }

  addSink(fn)  { if (typeof fn === 'function') this._sinks.push(fn); return this; }
  listEntities(){ return Array.from(this._entities.keys()); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  PROTOCOL_ID, PROTOCOL_VERSION,
  HEALTH_TIER, VITAL, HEALTH_EVENT,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  createVital, computeHealthScore,
  HealthEntity, HealthRegistry,
};

export default {
  PROTOCOL_ID, PROTOCOL_VERSION,
  HEALTH_TIER, VITAL, HEALTH_EVENT,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  createVital, computeHealthScore,
  HealthEntity, HealthRegistry,
};
