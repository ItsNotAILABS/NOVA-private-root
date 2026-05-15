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
// §6 — SOVEREIGN OPERATOR SAFETY
// Protection for the sovereign builder releasing disruptive technology.
// This is NOT generic wellness. This is operational safety for a founder
// whose work will draw attention from powerful, entrenched interests.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Sovereign operator risk categories.
 * Not physical hazards on a job site — existential risks to the mission.
 */
const OP_RISK = {
  FINANCIAL_STRESS:  'FINANCIAL_STRESS',    /* Revenue gap, uncollected invoices, burn rate */
  IP_EXPOSURE:       'IP_EXPOSURE',          /* Code/papers/architecture leaking before release */
  LEGAL_EXPOSURE:    'LEGAL_EXPOSURE',       /* IP theft, defamation, predatory litigation */
  PHYSICAL_SECURITY: 'PHYSICAL_SECURITY',    /* Personal safety of builder and collaborators */
  TECHNICAL_SABOTAGE:'TECHNICAL_SABOTAGE',   /* Hostile actors disrupting infrastructure */
  SOCIAL_ENGINEERING:'SOCIAL_ENGINEERING',  /* Manipulation of team, partners, or collaborators */
  REPUTATIONAL_ATTACK:'REPUTATIONAL_ATTACK', /* Coordinated misinformation or market FUD */
  ENERGY_DEPLETION:  'ENERGY_DEPLETION',    /* Builder cognitive/physical drain beyond sustainable limit */
};

/**
 * Sovereign operator safety protections.
 * These are the actual actions that build the wall of protection.
 */
const OP_PROTECTION = {
  FINANCIAL: [
    { priority: 1, action: 'INVOICE_IMMEDIATELY', description: 'Invoice every client on completion — not weekly. Same day. Sovereign cash flow requires no lag.' },
    { priority: 2, action: 'COLLECT_RETAINER',    description: 'Any project > 1 week requires 50% deposit before work begins. No exceptions. No deposit = no start.' },
    { priority: 3, action: 'MINIMUM_RESERVE',     description: 'Maintain 3-month operating reserve before any public technology release. Predators attack when you\'re on empty.' },
    { priority: 4, action: 'REVENUE_VELOCITY',    description: 'Track weekly: invoiced vs collected. Gap > 14 days triggers escalation. φ-weighted: oldest debt has highest cost.' },
    { priority: 5, action: 'DIVERSIFY_INCOME',    description: 'No single client > AMOR (38.2%) of monthly revenue. Single-source dependency = leverage point for adversaries.' },
  ],
  IP_AND_LEGAL: [
    { priority: 1, action: 'NDA_FIRST',           description: 'Every demo, every conversation about architecture — NDA signed before. Not after. Not during. Before.' },
    { priority: 2, action: 'PROVISIONAL_PATENT',  description: 'File provisional patents on core mechanisms (φ-lattice embed, MACHINA VIRTUALIS, No-Drop Law) before any public release.' },
    { priority: 3, action: 'TIMESTAMP_EVERYTHING',description: 'Every commit, every paper draft, every design document: git commit hash + timestamp is your prior art. NOVA repo is your evidence vault.' },
    { priority: 4, action: 'LEGAL_RETAINER',      description: 'Have IP attorney on retainer before release. Cost: ~$500/mo. Value: priceless when needed. This is infrastructure, not a luxury.' },
    { priority: 5, action: 'SEPARATE_ENTITIES',   description: 'Operating company ≠ IP holding company. IP lives in a separate LLC/trust. This is the first wall of legal protection.' },
  ],
  PHYSICAL_AND_PERSONAL: [
    { priority: 1, action: 'LOCATION_DISCRETION', description: 'Do not broadcast real-time location on public channels during periods of high technology exposure. Operational silence.' },
    { priority: 2, action: 'TRUSTED_CIRCLE',      description: 'Identify 3–5 people who know the full architecture. Everyone else gets component-level knowledge only. Compartmentalization.' },
    { priority: 3, action: 'DIGITAL_HYGIENE',     description: 'Separate devices for sovereign work vs public life. Work machine: full disk encryption, VPN, no social apps.' },
    { priority: 4, action: 'LEGAL_SAFE_WORD',     description: 'Pre-establish clear legal contacts (attorney, trusted advisor) who know your situation and can act fast if needed.' },
    { priority: 5, action: 'DOCUMENT_THREATS',    description: 'Any threatening communication: screenshot + date + context. Do not delete. Evidence chain starts with the first incident.' },
  ],
  INFRASTRUCTURE: [
    { priority: 1, action: 'MULTI_CLOUD_BACKUP',  description: 'NOVA codebase mirrored to at least 2 independent providers. Single-point deletion must not be possible.' },
    { priority: 2, action: 'ACCESS_REVOKE_PLAN',  description: 'For every collaborator: document access level. Have a written revocation process that can execute in < 15 minutes.' },
    { priority: 3, action: 'CANARY_DEPLOY',       description: 'Release technology in layers: closed → trusted → limited → public. Never go from 0 to world simultaneously.' },
    { priority: 4, action: 'MONITOR_MENTIONS',    description: 'Set up sovereign monitoring for mentions of: your name, NOVA, key papers, AGI-ID strings. Know who\'s watching before they act.' },
    { priority: 5, action: 'DEAD_MAN_PROTOCOL',   description: 'If communication goes silent > 72h: trusted person has access to release critical documentation. Continuity of the mission.' },
  ],
};

/**
 * SovereignOperatorSafety — tracks operational risk levels and generates
 * action plans for the sovereign builder releasing disruptive technology.
 */
class SovereignOperatorSafety {
  constructor(operatorId) {
    this.operatorId   = String(operatorId || 'SOVEREIGN-001');
    this._risks       = new Map();   /* riskType → { level, notes, updatedAt } */
    this._actions     = [];          /* completed protection actions */
    this._assessments = [];          /* history of risk assessments */
  }

  /**
   * Record an operational risk level.
   * @param {string} riskType   — OP_RISK category
   * @param {number} level      — 0.0 (none) to 1.0 (critical)
   * @param {string} [note]     — context note
   */
  recordRisk(riskType, level, note) {
    level = Math.max(0, Math.min(1, Number(level) || 0));
    this._risks.set(riskType, { level, note: String(note || ''), updatedAt: Date.now() });
    this._assessments.push({ riskType, level, note, at: Date.now() });
    return this.riskSnapshot();
  }

  /**
   * Mark a protection action as completed.
   * @param {string} category — 'FINANCIAL' | 'IP_AND_LEGAL' | 'PHYSICAL_AND_PERSONAL' | 'INFRASTRUCTURE'
   * @param {string} actionId — OP_PROTECTION[category][i].action
   */
  completeAction(category, actionId, note) {
    this._actions.push({ category, actionId, note: String(note || ''), completedAt: Date.now() });
    return this;
  }

  /** Compute composite operational risk score. */
  riskSnapshot() {
    const risks = Array.from(this._risks.entries());
    if (!risks.length) return { score: 0, level: 'UNKNOWN', risks: {} };
    /* φ-weighted: sort descending by level, higher risks weight more */
    risks.sort((a, b) => b[1].level - a[1].level);
    let wSum = 0, wTotal = 0;
    risks.forEach(([, v], i) => {
      const w  = Math.pow(PHI_INV, i);
      wSum    += v.level * w;
      wTotal  += w;
    });
    const score = Math.round(wSum / wTotal * 1e4) / 1e4;
    const level = score >= 1 - AMOR ? 'CRITICAL' : score >= PHI_INV ? 'HIGH' : score >= AMOR ? 'MEDIUM' : 'LOW';
    const riskMap = {};
    for (const [k, v] of this._risks.entries()) riskMap[k] = { level: Math.round(v.level * 1e4) / 1e4, note: v.note };
    return { operatorId: this.operatorId, score, level, risks: riskMap, assessedAt: Date.now() };
  }

  /**
   * Generate an action plan for the highest-risk categories.
   * Returns prioritised list of uncompleted protection actions.
   */
  actionPlan() {
    const completed = new Set(this._actions.map(a => `${a.category}::${a.actionId}`));
    const plan = [];

    /* Sort risks highest first */
    const sortedRisks = Array.from(this._risks.entries()).sort((a, b) => b[1].level - a[1].level);

    for (const [riskType] of sortedRisks) {
      let category;
      if (riskType === OP_RISK.FINANCIAL_STRESS)               category = 'FINANCIAL';
      else if (riskType === OP_RISK.IP_EXPOSURE || riskType === OP_RISK.LEGAL_EXPOSURE)  category = 'IP_AND_LEGAL';
      else if (riskType === OP_RISK.PHYSICAL_SECURITY)         category = 'PHYSICAL_AND_PERSONAL';
      else if (riskType === OP_RISK.TECHNICAL_SABOTAGE)        category = 'INFRASTRUCTURE';
      if (!category) continue;
      for (const action of OP_PROTECTION[category] || []) {
        const key = `${category}::${action.action}`;
        if (!completed.has(key)) {
          plan.push({ riskType, category, priority: action.priority, action: action.action, description: action.description });
        }
      }
    }

    /* Sort by risk level (already highest first) then by priority within risk */
    plan.sort((a, b) => a.priority - b.priority);
    return { operatorId: this.operatorId, planGeneratedAt: Date.now(), actions: plan.slice(0, 10) };
  }

  /** Get all protection templates for a category. */
  protections(category) {
    return OP_PROTECTION[category] || [];
  }

  status() {
    return {
      operatorId:      this.operatorId,
      riskSnapshot:    this.riskSnapshot(),
      completedActions:this._actions.length,
      assessmentCount: this._assessments.length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  PROTOCOL_ID, PROTOCOL_VERSION,
  SAFETY_LEVEL, HAZARD, INCIDENT_STATUS, SEVERITY_WEIGHT,
  FIB_ESCALATION, DEFAULT_CHECKLIST,
  OP_RISK, OP_PROTECTION,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  createIncident, computeSafetyScore,
  SafetyMonitor, runChecklist, SovereignOperatorSafety,
};

export default {
  PROTOCOL_ID, PROTOCOL_VERSION,
  SAFETY_LEVEL, HAZARD, INCIDENT_STATUS, SEVERITY_WEIGHT,
  FIB_ESCALATION, DEFAULT_CHECKLIST,
  OP_RISK, OP_PROTECTION,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  createIncident, computeSafetyScore,
  SafetyMonitor, runChecklist, SovereignOperatorSafety,
};
