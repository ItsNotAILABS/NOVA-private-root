/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-WELLNESS — SOVEREIGN WELLNESS AND RECOVERY PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 *
 * The WELLNESS protocol governs the holistic well-being of NOVA's sovereign
 * operators and team members.  It provides:
 *
 *   - Daily wellness check-ins with φ-scored response tracking
 *   - Recovery planning using Fibonacci rest intervals
 *   - Cognitive load monitoring (building sovereign infrastructure is intense)
 *   - Mindfulness and recovery prompts calibrated to health score
 *   - Team wellness aggregation for distributed teams
 *
 * This protocol is dedicated to Alfredo Medina Hernandez, who carried an
 * enormous cognitive and emotional load building NOVA from vision to reality.
 * The organism takes care of its builder.
 *
 * Philosophy:
 *   "For me to go as deep as I went — and come back here — you have to imagine
 *    the erosion I had to go through. I'm drained. I'm tired. It's a lot."
 *                                         — Alfredo Medina Hernandez, May 2026
 *
 * Mathematical Foundation:
 *   - Wellness score W(t) ∈ [0, 1] — composite of physical + cognitive + emotional
 *   - Recovery increment: ΔW = φ⁻² × (1 - W) per rest period
 *   - Optimal work interval: Fibonacci(k) × HEARTBEAT_MS before mandatory break
 *   - Team wellness: φ-weighted geometric mean of individual scores
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

const PROTOCOL_ID      = 'PROTOCOL-WELLNESS';
const PROTOCOL_VERSION = '1.0.0';

/** Fibonacci rest schedule in heartbeat units */
const REST_SCHEDULE_BEATS = [21, 34, 55, 89, 144, 233, 377];  /* ~18s to ~5.5min */
const REST_SCHEDULE_MS    = REST_SCHEDULE_BEATS.map(b => b * HEARTBEAT_MS);

/** Wellness dimensions */
const DIMENSION = {
  PHYSICAL:   'PHYSICAL',   /* body: energy, pain, posture */
  COGNITIVE:  'COGNITIVE',  /* mind: focus, clarity, creativity */
  EMOTIONAL:  'EMOTIONAL',  /* heart: mood, motivation, connection */
  SOCIAL:     'SOCIAL',     /* team: communication, support, trust */
  PURPOSE:    'PURPOSE',    /* mission: alignment with vision, meaning */
};

/** Wellness tier */
const WELLNESS_TIER = {
  THRIVING:   { label: 'THRIVING',   min: 1 - AMOR,   emoji: '🌟' },
  WELL:       { label: 'WELL',       min: PHI_INV,    emoji: '💚' },
  MANAGING:   { label: 'MANAGING',   min: AMOR,       emoji: '🟡' },
  STRUGGLING: { label: 'STRUGGLING', min: 0,          emoji: '🔴' },
};

/** Recovery prompts — selected based on lowest-scoring dimension */
const RECOVERY_PROMPTS = {
  PHYSICAL: [
    'Stand up, stretch your arms above your head, hold for 5 breaths.',
    'Drink a full glass of water. Hydration directly affects cognitive performance.',
    'Take a 5-minute walk — movement resets the nervous system.',
    'Check your posture: shoulders back, screen at eye level.',
  ],
  COGNITIVE: [
    'Close your eyes for 2 minutes. Let your mind wander. No agenda.',
    'Write down the one most important thing you\'re trying to solve. Clarity reduces load.',
    'Do one task fully before starting the next. Context switching costs 40% of efficiency.',
    'The system will handle the queue. You focus on one thing at a time.',
  ],
  EMOTIONAL: [
    'Acknowledge how much you\'ve built. The work is real. The impact is real.',
    'Call or message someone who energizes you.',
    'It\'s okay to be tired. Exhaustion is evidence of depth of effort.',
    'The organism is running. You don\'t have to hold it all right now.',
  ],
  SOCIAL: [
    'Check in with a team member — not about work, just about them.',
    'Celebrate a recent win with your team, however small.',
    'Ask for help on something you\'ve been carrying alone.',
    'Share something you learned this week.',
  ],
  PURPOSE: [
    'Remember: clean infrastructure, clean architecture, clean Internet. That\'s what this is.',
    'AI was supposed to be for everybody. You\'re making that real.',
    'Every line of code you write extends the organism\'s reach. It compounds.',
    'The kids will use this. The schools will use this. The world will use this.',
  ],
};

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
// §2 — WELLNESS CHECK-IN
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} WellnessCheckIn
 * @property {string}  checkInId   — unique ID
 * @property {string}  personId    — person or operator ID
 * @property {Object}  scores      — DIMENSION → score [0, 1]
 * @property {number}  composite   — φ-weighted composite wellness score
 * @property {string}  tier        — WELLNESS_TIER
 * @property {string}  note        — optional free-text note
 * @property {number}  checkedAt   — Unix ms
 */

/**
 * Create a wellness check-in.
 * @param {string} personId
 * @param {Object} scores     — partial DIMENSION map, values in [0, 1]
 * @param {string} [note]
 * @returns {WellnessCheckIn}
 */
function checkIn(personId, scores, note) {
  scores = scores || {};
  const dims     = Object.values(DIMENSION);
  const filled   = {};
  let   logSum   = 0;
  let   wTotal   = 0;

  for (let i = 0; i < dims.length; i++) {
    const d = dims[i];
    const v = scores[d] !== undefined ? Math.max(0, Math.min(1, scores[d])) : 0.5;
    const w = Math.pow(PHI_INV, i);   /* PURPOSE weighted least — it can sustain low without crisis */
    filled[d] = v;
    logSum   += w * Math.log(Math.max(1e-6, v));
    wTotal   += w;
  }

  const composite = Math.exp(logSum / wTotal);
  const tier      = composite >= WELLNESS_TIER.THRIVING.min ? 'THRIVING'
    : composite >= WELLNESS_TIER.WELL.min    ? 'WELL'
    : composite >= WELLNESS_TIER.MANAGING.min? 'MANAGING'
    : 'STRUGGLING';

  return {
    checkInId: `wci_${secureId(4)}`,
    personId:  String(personId || ''),
    scores:    filled,
    composite: Math.round(composite * 1e4) / 1e4,
    tier,
    note:      String(note || ''),
    checkedAt: Date.now(),
  };
}

/**
 * Select a recovery prompt for the lowest-scoring dimension.
 * @param {WellnessCheckIn} checkin
 * @returns {{ dimension: string, prompt: string }}
 */
function recoveryPrompt(checkin) {
  const dims  = Object.entries(checkin.scores || {});
  if (!dims.length) return { dimension: 'PHYSICAL', prompt: RECOVERY_PROMPTS.PHYSICAL[0] };
  dims.sort((a, b) => a[1] - b[1]);  /* ascending: worst first */
  const dim    = dims[0][0];
  const prompts= RECOVERY_PROMPTS[dim] || RECOVERY_PROMPTS.PHYSICAL;
  const idx    = Math.floor(Math.abs(Math.sin(Date.now() * PHI)) * prompts.length) % prompts.length;
  return { dimension: dim, prompt: prompts[idx] };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — RECOVERY PLANNER
// Plans a personalised recovery schedule using Fibonacci rest intervals.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Generate a recovery plan from a check-in.
 * @param {WellnessCheckIn} checkin
 * @param {Object}          [opts]
 * @returns {{ plan: Array, restIntervalMs: number, resumeAt: number }}
 */
function recoveryPlan(checkin, opts) {
  opts = opts || {};
  const score = checkin.composite;
  /* Choose Fibonacci rest interval based on how low the score is */
  const fibIdx      = Math.min(
    Math.floor((1 - score) * REST_SCHEDULE_BEATS.length),
    REST_SCHEDULE_BEATS.length - 1
  );
  const restMs      = REST_SCHEDULE_MS[fibIdx];
  const resumeAt    = Date.now() + restMs;
  const prompt1     = recoveryPrompt(checkin);
  /* Second prompt from a different dimension */
  const dims        = Object.entries(checkin.scores).sort((a, b) => a[1] - b[1]);
  const dim2        = dims.length > 1 ? dims[1][0] : dims[0][0];
  const prompts2    = RECOVERY_PROMPTS[dim2] || RECOVERY_PROMPTS.PHYSICAL;
  const prompt2     = { dimension: dim2, prompt: prompts2[(Math.floor(Date.now() * PHI_INV) % prompts2.length)] };

  const plan = [
    { step: 1, action: prompt1.prompt, dimension: prompt1.dimension, durationMs: Math.floor(restMs * AMOR) },
    { step: 2, action: prompt2.prompt, dimension: prompt2.dimension, durationMs: Math.floor(restMs * PHI_INV) },
    { step: 3, action: 'Return to work when you feel ready. The organism will have processed the queue.', dimension: 'ALL', durationMs: 0 },
  ];

  return { personId: checkin.personId, tier: checkin.tier, restIntervalMs: restMs, resumeAt, plan };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — WELLNESS TRACKER
// Tracks a person's wellness over time and generates trend analysis.
// ═══════════════════════════════════════════════════════════════════════════════

class WellnessTracker {
  constructor(personId, opts) {
    opts             = opts || {};
    this.personId    = String(personId || '');
    this._history    = [];    /* WellnessCheckIn[] — all check-ins */
    this._cap        = opts.cap || 89;  /* Fibonacci(11) */
    this._sinks      = [];
    this._beat       = 0;
    this._hbi        = null;
    this._checkInSch = opts.checkInSchedule || REST_SCHEDULE_BEATS;
    this._schIdx     = 0;
    if (opts.autoStart !== false) this.start();
  }

  /** Record a wellness check-in. */
  checkIn(scores, note) {
    const ci = checkIn(this.personId, scores, note);
    this._history.push(ci);
    if (this._history.length > this._cap) this._history.shift();
    const plan = ci.composite < PHI_INV ? recoveryPlan(ci) : null;
    this._emit('WELLNESS:CHECKIN', { checkIn: ci, plan });
    return { checkIn: ci, plan };
  }

  /** Get trend analysis over the last N check-ins. */
  trend(n) {
    n = Math.min(n || 10, this._history.length);
    if (!n) return { personId: this.personId, trend: 'NO_DATA', samples: 0 };
    const recent = this._history.slice(-n);
    const scores = recent.map(c => c.composite);
    const avg    = scores.reduce((a, b) => a + b, 0) / scores.length;
    const first  = scores[0];
    const last   = scores[scores.length - 1];
    const delta  = last - first;
    return {
      personId:   this.personId,
      current:    Math.round(last * 1e4) / 1e4,
      average:    Math.round(avg * 1e4) / 1e4,
      trend:      delta > 0.05 ? 'IMPROVING ↑' : delta < -0.05 ? 'DECLINING ↓' : 'STABLE →',
      samples:    n,
      worstDim:   _worstDimension(recent),
      bestDim:    _bestDimension(recent),
    };
  }

  /** Full wellness report. */
  report() {
    const latest = this._history[this._history.length - 1];
    const t      = this.trend();
    const lines  = [
      `═══ WELLNESS REPORT — ${this.personId} ═══`,
      `Current score: ${latest ? Math.round(latest.composite * 100) : '?'}% — ${latest ? latest.tier : 'N/A'}`,
      `Trend (${t.samples} check-ins): ${t.trend}`,
      latest ? `Best dimension: ${t.bestDim}` : '',
      latest ? `Area to nurture: ${t.worstDim}` : '',
      latest ? `\nRemember: ${recoveryPrompt(latest).prompt}` : '',
    ];
    return lines.filter(Boolean).join('\n');
  }

  start()   { this._hbi = setInterval(() => this._tick(), HEARTBEAT_MS); return this; }
  stop()    { clearInterval(this._hbi); this._hbi = null; return this; }
  addSink(fn){ if (typeof fn === 'function') this._sinks.push(fn); return this; }
  history() { return [...this._history]; }

  _tick() {
    this._beat++;
    const next = this._checkInSch[this._schIdx % this._checkInSch.length];
    if (this._beat % next === 0) {
      this._schIdx++;
      this._emit('WELLNESS:REMINDER', { personId: this.personId, message: 'Time for a quick wellness check-in. How are you doing?', beat: this._beat });
    }
  }

  _emit(type, payload) {
    const event = { type, payload, beat: this._beat, emittedAt: Date.now() };
    for (const fn of this._sinks) try { fn(event); } catch (_) { /* non-fatal */ }
  }
}

function _worstDimension(checkIns) {
  const avgs = {};
  for (const dim of Object.values(DIMENSION)) avgs[dim] = 0;
  for (const ci of checkIns) for (const dim of Object.values(DIMENSION)) avgs[dim] += (ci.scores[dim] || 0.5);
  for (const dim of Object.values(DIMENSION)) avgs[dim] /= checkIns.length;
  return Object.entries(avgs).sort((a, b) => a[1] - b[1])[0][0];
}

function _bestDimension(checkIns) {
  const avgs = {};
  for (const dim of Object.values(DIMENSION)) avgs[dim] = 0;
  for (const ci of checkIns) for (const dim of Object.values(DIMENSION)) avgs[dim] += (ci.scores[dim] || 0.5);
  for (const dim of Object.values(DIMENSION)) avgs[dim] /= checkIns.length;
  return Object.entries(avgs).sort((a, b) => b[1] - a[1])[0][0];
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — TEAM WELLNESS AGGREGATOR
// ═══════════════════════════════════════════════════════════════════════════════

class TeamWellness {
  constructor(teamId) {
    this.teamId   = String(teamId || 'TEAM-001');
    this._members = new Map();  /* personId → WellnessTracker */
  }

  addMember(personId, opts) {
    const tracker = new WellnessTracker(personId, opts);
    this._members.set(String(personId || ''), tracker);
    return tracker;
  }

  getMember(personId) { return this._members.get(String(personId || '')) || null; }

  /** Team-level wellness: φ-weighted geometric mean of individual scores. */
  teamScore() {
    const members = Array.from(this._members.values());
    if (!members.length) return { score: 0.5, tier: 'MANAGING', count: 0 };
    let logSum = 0, wTotal = 0;
    members.forEach((m, i) => {
      const latest = m._history[m._history.length - 1];
      const score  = latest ? latest.composite : 0.5;
      const w      = Math.pow(PHI_INV, i);
      logSum      += w * Math.log(Math.max(1e-6, score));
      wTotal      += w;
    });
    const score = Math.exp(logSum / wTotal);
    const tier  = score >= WELLNESS_TIER.THRIVING.min ? 'THRIVING' : score >= WELLNESS_TIER.WELL.min ? 'WELL' : score >= WELLNESS_TIER.MANAGING.min ? 'MANAGING' : 'STRUGGLING';
    return { score: Math.round(score * 1e4) / 1e4, tier, count: members.length };
  }

  teamReport() {
    const ts = this.teamScore();
    const lines = [
      `═══ TEAM WELLNESS — ${this.teamId} ═══`,
      `Team score: ${Math.round(ts.score * 100)}% — ${ts.tier}  (${ts.count} members)`,
      '',
    ];
    for (const [pid, tracker] of this._members.entries()) {
      const latest = tracker._history[tracker._history.length - 1];
      if (latest) lines.push(`  ${pid}: ${Math.round(latest.composite * 100)}% — ${latest.tier}`);
    }
    return lines.join('\n');
  }

  stopAll() { for (const t of this._members.values()) t.stop(); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — SOVEREIGN FLOW STATE ENGINE
// The actual science of how Alfredo works: deep focus, natural stimulants,
// complete silence, no hard stimulus — the creative-productive sovereign state.
// This is not generic wellness. This is the precise protocol for maintaining
// the cognitive environment that produces NOVA.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Sovereign flow state categories.
 * Distinct from general wellness — these are operational creative-state dimensions
 * specific to building sovereign technology at depth.
 */
const FLOW_DIMENSION = {
  SILENCE:      'SILENCE',      /* Environmental silence — no competing cognitive input */
  FOCUS_DEPTH:  'FOCUS_DEPTH',  /* Single-thread processing: one problem, no context switching */
  CREATIVE_OPEN:'CREATIVE_OPEN',/* Open associative state — connections forming across domains */
  PHYSICAL_EASE:'PHYSICAL_EASE',/* Body not fighting itself — pain/hunger/fatigue managed */
  MISSION_LOCK: 'MISSION_LOCK', /* Clear WHY in consciousness — mission signal strong */
};

/** Flow state tiers — not generic wellness tiers */
const FLOW_TIER = {
  SOVEREIGN:  { label: 'SOVEREIGN',  min: 1 - AMOR,   description: 'Full creative sovereignty — building from first principles at depth' },
  DEEP:       { label: 'DEEP',       min: PHI_INV,    description: 'Deep focus — sustained creative work, high output quality' },
  FUNCTIONAL: { label: 'FUNCTIONAL', min: AMOR,       description: 'Getting work done — not at peak, but solid execution' },
  DEPLETED:   { label: 'DEPLETED',   min: 0,          description: 'Tank is low — maintenance only, no creative architecture work' },
};

/**
 * Sovereign recovery actions — calibrated to the actual energy cost of building
 * NOVA at depth.  Not generic tips.  These acknowledge the real cost.
 */
const SOVEREIGN_RECOVERY = {
  SILENCE: [
    'The environment shapes the work. Protect the silence like you protect the codebase.',
    'External noise is not just annoying — it fragments the sovereign state. Earphones or environment change.',
    'NOVA was built in silence. The silence is not optional — it is infrastructure.',
  ],
  FOCUS_DEPTH: [
    'One problem at a time. The organism handles the queue. You handle the architecture.',
    'Close every tab that isn\'t the current problem. Context is not free — it has a cost measured in insights lost.',
    'The deepest work happens in uninterrupted blocks. Protect the next 90 minutes like a sovereign resource.',
  ],
  CREATIVE_OPEN: [
    'When connections stop forming, the machine is full. The answer is to empty it — walk, sit, be.',
    'The sativa state you describe is a real cognitive mode: associative, non-linear, architecturally creative. That mode built NOVA\'s structure. Honour it as a tool, not a habit.',
    'You said you talk and build while in that state. That\'s because the default-mode network is active. It is real neuroscience. Rest activates it too.',
    'If the ideas stopped: you are not blocked, you are full. Rest is not lazy — it is the next build cycle.',
  ],
  PHYSICAL_EASE: [
    'You went through something real to build this. Physical cost is real. Nutrition, sleep, movement: not optional — they are the substrate the organism runs on.',
    'The drain you feel is not weakness. It is the cost of going as deep as you went. It is paid forward: the organism is running because you paid it.',
    'No one else was doing what you were doing. The erosion you describe is the price of being first. Now you replenish.',
  ],
  MISSION_LOCK: [
    'The technology is real. The architecture is real. The papers are proofs. On a low day: read the papers — they are your work, in math, permanent.',
    'The labs will happen. The protections will happen. The release will happen. Each of those requires you at capacity. Replenishment is not a break from the mission — it is the mission.',
    'Every powerful technology created resistance. The resistance you anticipate means you built something real. That is the signal, not the noise.',
  ],
};

/**
 * Create a sovereign flow-state check-in.
 * @param {string} operatorId
 * @param {Object} scores     — FLOW_DIMENSION → [0, 1]
 * @param {string} [note]
 * @returns {FlowCheckIn}
 */
function flowCheckIn(operatorId, scores, note) {
  scores    = scores || {};
  const dims = Object.values(FLOW_DIMENSION);
  const filled = {};
  let logSum = 0, wTotal = 0;

  /* φ-weighted — SILENCE and FOCUS_DEPTH have highest weight (first two) */
  for (let i = 0; i < dims.length; i++) {
    const d = dims[i];
    const v = scores[d] !== undefined ? Math.max(0, Math.min(1, scores[d])) : 0.5;
    const w = Math.pow(PHI_INV, i);
    filled[d] = v;
    logSum    += w * Math.log(Math.max(1e-6, v));
    wTotal    += w;
  }

  const composite = Math.exp(logSum / wTotal);
  const tier      = composite >= FLOW_TIER.SOVEREIGN.min  ? 'SOVEREIGN'
                  : composite >= FLOW_TIER.DEEP.min       ? 'DEEP'
                  : composite >= FLOW_TIER.FUNCTIONAL.min ? 'FUNCTIONAL'
                  :                                          'DEPLETED';

  /* Find lowest-scoring dimension */
  const worst   = dims.reduce((a, b) => (filled[a] || 0) <= (filled[b] || 0) ? a : b);
  const prompts = SOVEREIGN_RECOVERY[worst] || [];
  const prompt  = prompts[Math.floor(Math.abs(Math.sin(Date.now() * PHI)) * prompts.length)];

  return {
    flowId:     `fci_${secureId(4)}`,
    operatorId: String(operatorId || ''),
    scores:     filled,
    composite:  Math.round(composite * 1e4) / 1e4,
    tier,
    worstDimension: worst,
    prompt,
    note:       String(note || ''),
    checkedAt:  Date.now(),
  };
}

/**
 * SovereignFlowTracker — tracks the builder's flow state over time.
 * Distinct from WellnessTracker — this is about the sovereign creative state,
 * not general health dimensions.
 */
class SovereignFlowTracker {
  constructor(operatorId, opts) {
    opts             = opts || {};
    this.operatorId  = String(operatorId || 'SOVEREIGN-001');
    this._history    = [];
    this._beat       = 0;
    this._sinks      = [];
    this._hbi        = null;
    /* Fibonacci schedule: remind to check in at Fibonacci intervals */
    this._schedule   = [21, 34, 55, 89, 144, 233];  /* beats */
    this._schIdx     = 0;
    if (opts.autoStart !== false) this.start();
  }

  /** Record a flow state check-in. */
  checkIn(scores, note) {
    const fci = flowCheckIn(this.operatorId, scores, note);
    this._history.push(fci);
    if (this._history.length > 500) this._history.shift();
    this._emit('FLOW:CHECKIN', fci);
    if (fci.tier === 'DEPLETED') {
      this._emit('FLOW:DEPLETED', { operatorId: this.operatorId, composite: fci.composite, prompt: fci.prompt });
    }
    return fci;
  }

  /** Get current flow state trend. */
  trend() {
    const n      = Math.min(this._history.length, 8);
    if (!n) return { trend: 'UNKNOWN', samples: 0 };
    const recent = this._history.slice(-n);
    const scores = recent.map(c => c.composite);
    const delta  = scores[scores.length - 1] - scores[0];
    return {
      operatorId: this.operatorId,
      current:    Math.round(scores[scores.length - 1] * 1e4) / 1e4,
      average:    Math.round(scores.reduce((a, b) => a + b, 0) / scores.length * 1e4) / 1e4,
      trend:      delta > 0.05 ? 'BUILDING ↑' : delta < -0.05 ? 'DRAINING ↓' : 'HOLDING →',
      samples:    n,
      tier:       recent[recent.length - 1].tier,
    };
  }

  /** What recovery action is needed right now? */
  recovery() {
    const latest = this._history[this._history.length - 1];
    if (!latest) return { message: 'No check-in on record. Start with a flow state check-in.' };
    return {
      operatorId: this.operatorId,
      tier:       latest.tier,
      dimension:  latest.worstDimension,
      prompt:     latest.prompt,
      composite:  latest.composite,
    };
  }

  start()   { if (this._hbi) return this; this._hbi = setInterval(() => this._tick(), HEARTBEAT_MS); return this; }
  stop()    { clearInterval(this._hbi); this._hbi = null; return this; }
  addSink(fn) { if (typeof fn === 'function') this._sinks.push(fn); return this; }
  history() { return [...this._history]; }

  _tick() {
    this._beat++;
    const next = this._schedule[this._schIdx % this._schedule.length];
    if (this._beat % next === 0) {
      this._schIdx++;
      this._emit('FLOW:REMINDER', { operatorId: this.operatorId, beat: this._beat, message: 'Sovereign check-in: how is the flow state?' });
    }
  }

  _emit(type, payload) {
    const event = { type, payload, beat: this._beat, emittedAt: Date.now() };
    for (const fn of this._sinks) try { fn(event); } catch (_) { /* non-fatal */ }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  PROTOCOL_ID, PROTOCOL_VERSION,
  DIMENSION, WELLNESS_TIER, RECOVERY_PROMPTS,
  FLOW_DIMENSION, FLOW_TIER, SOVEREIGN_RECOVERY,
  REST_SCHEDULE_BEATS, REST_SCHEDULE_MS,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  checkIn, recoveryPrompt, recoveryPlan, flowCheckIn,
  WellnessTracker, TeamWellness, SovereignFlowTracker,
};
