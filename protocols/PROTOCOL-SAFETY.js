/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-SAFETY — SOVEREIGN SAFETY ALERT AND INCIDENT PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 *
 * The SAFETY protocol governs safety incidents, alerts, and hazard management
 * across all NOVA operations — both digital (system security, data integrity)
 * and physical (workplace safety for commercial installations and field teams).
 *
 * This protocol supports:
 *   - NOVA internal AGI safety (Lyapunov divergence alerts, anomaly detection)
 *   - Physical workplace safety (furniture installation teams, field operations)
 *   - Environmental safety (occupancy limits, load calculations, egress)
 *   - Personal safety (equipment checks, PPE compliance, incident reporting)
 *
 * Mathematical Foundation:
 *   - Safety score S(t) ∈ [0, 1] — φ-weighted risk accumulator
 *   - Risk threshold: S < φ⁻¹ → UNSAFE (stop work)
 *   - Green threshold: S ≥ 1 - φ⁻² → SAFE
 *   - Incident severity: φ-weighted 1–5 scale
 *   - φ-backoff escalation: alert every F_k heartbeats until resolved
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

const PROTOCOL_ID      = 'PROTOCOL-SAFETY';
const PROTOCOL_VERSION = '1.0.0';

/** Fibonacci escalation beats: alert repeats at these heartbeat intervals */
const FIB_ESCALATION = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];

/** Safety levels — inverse of risk */
const SAFETY_LEVEL = {
  SAFE:      { label: 'SAFE',      minScore: 1 - AMOR,   color: '#00ff88', action: 'PROCEED' },
  CAUTION:   { label: 'CAUTION',   minScore: PHI_INV,    color: '#ffcc00', action: 'PROCEED_WITH_CARE' },
  UNSAFE:    { label: 'UNSAFE',    minScore: 0,          color: '#ff4444', action: 'STOP_WORK' },
};

/** Hazard categories */
const HAZARD = {
  /* Physical / field */
  STRUCTURAL_LOAD:   'STRUCTURAL_LOAD',   /* floor/wall load limit */
  FALL_RISK:         'FALL_RISK',         /* height, ladder, roof work */
  PINCH_POINT:       'PINCH_POINT',       /* panel/door pinch */
  ELECTRICAL:        'ELECTRICAL',        /* electrical exposure */
  CHEMICAL:          'CHEMICAL',          /* solvent, adhesive fumes */
  ERGONOMIC:         'ERGONOMIC',         /* lifting, repetitive motion */
  TRAFFIC:           'TRAFFIC',           /* vehicle/pedestrian conflict */

  /* Digital / AGI */
  LYAPUNOV_DIVERGE:  'LYAPUNOV_DIVERGE', /* oscillator coherence collapse */
  QUEUE_OVERFLOW:    'QUEUE_OVERFLOW',    /* STREAM buffer approaching cap */
  CANISTER_DRAIN:    'CANISTER_DRAIN',    /* ICP cycles critically low */
  DATA_INTEGRITY:    'DATA_INTEGRITY',    /* checksum mismatch */
  AUTH_ANOMALY:      'AUTH_ANOMALY',      /* suspicious authentication */
};

/** Incident status */
const INCIDENT_STATUS = {
  OPEN:        'OPEN',
  INVESTIGATING:'INVESTIGATING',
  MITIGATING:  'MITIGATING',
  RESOLVED:    'RESOLVED',
  CLOSED:      'CLOSED',
};

/** Severity: 1 (minor) → 5 (critical), φ-weighted impact */
const SEVERITY_WEIGHT = [0, AMOR * AMOR, AMOR, PHI_INV * AMOR, PHI_INV, 1.0];

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

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — INCIDENT RECORD
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} IncidentRecord
 * @property {string}  incidentId   — unique incident ID (INC-NNNN)
 * @property {string}  hazard       — HAZARD category
 * @property {number}  severity     — 1–5
 * @property {string}  location     — physical or logical location
 * @property {string}  description  — human-readable description
 * @property {string}  reporter     — reporter ID (agent or human)
 * @property {string}  status       — INCIDENT_STATUS
 * @property {string[]}actions      — corrective actions taken
 * @property {number}  raisedAt     — Unix ms
 * @property {number}  resolvedAt   — Unix ms or null
 */

/**
 * Create a new IncidentRecord.
 */
function createIncident(hazard, severity, location, description, reporter) {
  return {
    incidentId:  `INC-${secureId(4).toUpperCase()}`,
    hazard:      hazard || HAZARD.DATA_INTEGRITY,
    severity:    Math.max(1, Math.min(5, severity || 1)),
    location:    String(location || 'UNKNOWN'),
    description: String(description || ''),
    reporter:    String(reporter || 'SYSTEM'),
    status:      INCIDENT_STATUS.OPEN,
    actions:     [],
    raisedAt:    Date.now(),
    resolvedAt:  null,
    escalations: 0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — SAFETY SCORE CALCULATOR
// Computes a site/system safety score from active incidents.
// S = 1 - Σ (severity_weight_i × φ^{-i}) / Σ φ^{-i}
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compute safety score from active incidents.
 * @param {IncidentRecord[]} incidents
 * @returns {{ score: number, level: string, criticalCount: number }}
 */
function computeSafetyScore(incidents) {
  const active = (incidents || []).filter(i => i.status !== INCIDENT_STATUS.CLOSED && i.status !== INCIDENT_STATUS.RESOLVED);
  if (!active.length) return { score: 1.0, level: SAFETY_LEVEL.SAFE.label, criticalCount: 0 };

  /* Sort by severity descending — worst first */
  active.sort((a, b) => b.severity - a.severity);

  let riskSum = 0, wTotal = 0;
  for (let i = 0; i < active.length; i++) {
    const w    = Math.pow(PHI_INV, i);
    riskSum   += SEVERITY_WEIGHT[active[i].severity] * w;
    wTotal    += w;
  }
  const risk   = riskSum / wTotal;
  const score  = Math.max(0, 1 - risk);
  const level  = score >= SAFETY_LEVEL.SAFE.minScore ? 'SAFE' : score >= SAFETY_LEVEL.CAUTION.minScore ? 'CAUTION' : 'UNSAFE';
  const criticalCount = active.filter(i => i.severity >= 4).length;

  return { score: Math.round(score * 1e4) / 1e4, level, criticalCount, activeCount: active.length };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — SAFETY MONITOR
// ═══════════════════════════════════════════════════════════════════════════════

class SafetyMonitor {
  constructor(siteId, opts) {
    opts              = opts || {};
    this.siteId       = String(siteId || 'SITE-001');
    this._incidents   = new Map();   /* incidentId → IncidentRecord */
    this._counter     = 0;
    this._score       = 1.0;
    this._level       = SAFETY_LEVEL.SAFE.label;
    this._sinks       = [];
    this._beat        = 0;
    this._fibEscIdx   = 0;
    this._hbi         = null;
    this._maxSeverity = opts.maxSeverity || 5;
    if (opts.autoStart !== false) this.start();
  }

  /** Report a new incident. Returns the incident record. */
  report(hazard, severity, location, description, reporter) {
    const inc = createIncident(hazard, severity, location, description, reporter);
    this._incidents.set(inc.incidentId, inc);
    this._counter++;
    this._recompute();
    this._emit('SAFETY:INCIDENT_REPORTED', inc);
    /* Immediate stop-work if critical */
    if (severity >= 4 || this._level === 'UNSAFE') {
      this._emit('SAFETY:STOP_WORK', { siteId: this.siteId, incident: inc, score: this._score });
    }
    return inc;
  }

  /** Add a corrective action to an incident. */
  addAction(incidentId, action, by) {
    const inc = this._incidents.get(incidentId);
    if (!inc) throw new Error(`Incident not found: ${incidentId}`);
    inc.actions.push({ action, by: String(by || 'UNKNOWN'), at: Date.now() });
    inc.status = INCIDENT_STATUS.MITIGATING;
    this._recompute();
    return inc;
  }

  /** Resolve an incident. */
  resolve(incidentId, resolution, by) {
    const inc = this._incidents.get(incidentId);
    if (!inc) throw new Error(`Incident not found: ${incidentId}`);
    inc.status     = INCIDENT_STATUS.RESOLVED;
    inc.resolvedAt = Date.now();
    inc.actions.push({ action: `RESOLVED: ${resolution}`, by: String(by || 'UNKNOWN'), at: Date.now() });
    this._recompute();
    this._emit('SAFETY:INCIDENT_RESOLVED', inc);
    return inc;
  }

  /** Get a safety inspection report. */
  inspectionReport() {
    const active   = this._activeIncidents();
    const resolved = Array.from(this._incidents.values()).filter(i => i.status === INCIDENT_STATUS.RESOLVED);
    return {
      siteId:       this.siteId,
      score:        this._score,
      level:        this._level,
      action:       SAFETY_LEVEL[this._level] ? SAFETY_LEVEL[this._level].action : 'UNKNOWN',
      activeCount:  active.length,
      resolvedCount:resolved.length,
      critical:     active.filter(i => i.severity >= 4).length,
      incidents:    active.map(i => ({ id: i.incidentId, hazard: i.hazard, severity: i.severity, status: i.status })),
      generatedAt:  Date.now(),
    };
  }

  status()  { return { siteId: this.siteId, score: this._score, level: this._level, beat: this._beat, active: this._activeIncidents().length }; }
  addSink(fn){ if (typeof fn === 'function') this._sinks.push(fn); return this; }
  start()   { this._hbi = setInterval(() => this._tick(), HEARTBEAT_MS); return this; }
  stop()    { clearInterval(this._hbi); this._hbi = null; return this; }

  _tick() {
    this._beat++;
    /* φ-Fibonacci escalation for unresolved critical incidents */
    const nextEsc = FIB_ESCALATION[this._fibEscIdx % FIB_ESCALATION.length];
    if (this._beat % nextEsc === 0) {
      const critical = this._activeIncidents().filter(i => i.severity >= 4);
      if (critical.length > 0) {
        this._fibEscIdx++;
        for (const inc of critical) {
          inc.escalations++;
          this._emit('SAFETY:ESCALATION', { siteId: this.siteId, incident: inc, escalation: inc.escalations });
        }
      }
    }
    /* Periodic safety summary (every 144 beats ≈ 2 minutes at 873ms/beat) */
    if (this._beat % 144 === 0) {
      this._emit('SAFETY:REPORT', this.inspectionReport());
    }
  }

  _recompute() {
    const result  = computeSafetyScore(Array.from(this._incidents.values()));
    this._score   = result.score;
    this._level   = result.level;
  }

  _activeIncidents() {
    return Array.from(this._incidents.values()).filter(i => i.status !== INCIDENT_STATUS.CLOSED && i.status !== INCIDENT_STATUS.RESOLVED);
  }

  _emit(type, payload) {
    const event = { type, siteId: this.siteId, payload, beat: this._beat, emittedAt: Date.now() };
    for (const fn of this._sinks) try { fn(event); } catch (_) { /* non-fatal */ }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — PRE-TASK SAFETY CHECKLIST
// Sovereign pre-task safety checklist for field operations.
// ═══════════════════════════════════════════════════════════════════════════════

const DEFAULT_CHECKLIST = [
  { id: 'PPE',        item: 'Personal protective equipment verified (gloves, safety glasses, hard hat if required)' },
  { id: 'LOAD',       item: 'Floor load capacity verified for furniture weight + workers' },
  { id: 'EGRESS',     item: 'Emergency egress paths clear and unobstructed' },
  { id: 'TOOLS',      item: 'Tools inspected — no damaged cords, blades, or handles' },
  { id: 'LIFT',       item: 'Heavy items: team lift plan confirmed (≥20kg requires 2+ persons)' },
  { id: 'CHEM',       item: 'Adhesives/solvents: ventilation confirmed, MSDS available' },
  { id: 'ELEC',       item: 'Electrical outlets/panels: clearance maintained, no wet conditions' },
  { id: 'COMMS',      item: 'Communication plan set — team lead contact confirmed' },
  { id: 'FIRST_AID',  item: 'First aid kit location known by all team members' },
  { id: 'EMERGENCY',  item: 'Emergency procedures reviewed — site address on hand for 911' },
];

/**
 * Run a safety checklist for a site.
 * @param {string}   siteId
 * @param {string[]} completedItemIds  — IDs of completed checklist items
 * @returns {{ siteId, score, passed, failed, readyToStart }}
 */
function runChecklist(siteId, completedItemIds) {
  const completed = new Set(completedItemIds || []);
  const results   = DEFAULT_CHECKLIST.map(item => ({
    id:     item.id,
    item:   item.item,
    passed: completed.has(item.id),
  }));
  const passed    = results.filter(r => r.passed).length;
  const total     = results.length;
  const score     = passed / total;
  return {
    siteId,
    score:        Math.round(score * 1e4) / 1e4,
    passed,
    total,
    failed:       results.filter(r => !r.passed).map(r => ({ id: r.id, item: r.item })),
    readyToStart: score >= PHI_INV,   /* require ≥ φ⁻¹ ≈ 61.8% completion to start */
    checkedAt:    Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  PROTOCOL_ID, PROTOCOL_VERSION,
  SAFETY_LEVEL, HAZARD, INCIDENT_STATUS, SEVERITY_WEIGHT,
  FIB_ESCALATION, DEFAULT_CHECKLIST,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  createIncident, computeSafetyScore,
  SafetyMonitor, runChecklist,
};
