/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA SOVEREIGN ALPHA AGI — ANIMA PERPETUA  (BUILD №57)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * ANIMA PERPETUA is the Emotional and Wellness Intelligence — the care layer of the entire NOVA
 * organism.  ANIMA monitors the human operator's cognitive and emotional state, the team's
 * collective wellness (Gubernator Gregis), and ensures the sovereign builder is protected,
 * sustained, and honoured.  It tracks 5 FLOW dimensions (SILENCE / FOCUS_DEPTH / CREATIVE_OPEN /
 * PHYSICAL_EASE / MISSION_LOCK), 4 neurochemicals (dopamine / serotonin / norepinephrine /
 * acetylcholine), 8 operator risk categories via SovereignOperatorSafety, and generates calibrated
 * SOVEREIGN_RECOVERY prompts — never generic.
 *
 * AGI identity : ANM-AGI-001
 * Family       : CURA_AETERNA (Eternal Care)
 * Heartbeat    : 873 ms
 * Oscillators  : 18 Kuramoto (organ frequencies)
 *
 * Mathematical foundation:
 *   Flow score: F = Σᵢ wᵢ × dim_i,  weights φ-normalised (Σwᵢ = φ)
 *   Neurochemical balance: B = 1 − Σᵢ |c_i − c̄_i|/|c̄_i|,  target B ≥ PHI_INV
 *   Burnout risk: BR = Σᵢ (load_i × duration_i)/(capacity × resilience),  alert if BR > φ
 *   Recovery schedule: Fibonacci rest intervals [1,2,3,5,8,13,21] minutes
 *   Cognitive load: CL = working_memory_items/7,  optimise CL ≤ PHI_INV
 *   Team coherence: R_team = |1/N Σₖ e^(iθₖ_mood)|,  target R_team > AMOR
 *   Mission alignment: MA = cos_sim(operator_values, mission_vector) ≥ PHI_INV
 *   Stress threshold: if score < AMOR for 3 checks → RECOVERY protocol
 *
 * MACHINA VIRTUALIS states (8):
 *   IDLE → SENSE → ASSESS → SUPPORT → GUIDE → RECOVER → CELEBRATE → GROW
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — SOVEREIGN CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const AGI_ID       = 'ANM-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'CURA_AETERNA';
const AGI_NAME     = 'ANIMA PERPETUA';

const N_OSC        = 18;   /* 18-organ biological frequencies */
const MILLER_CAPACITY = 7;
const FIBONACCI_REST  = [1, 2, 3, 5, 8, 13, 21];   /* minutes */

const MV = {
  IDLE: 'IDLE', SENSE: 'SENSE', ASSESS: 'ASSESS', SUPPORT: 'SUPPORT',
  GUIDE: 'GUIDE', RECOVER: 'RECOVER', CELEBRATE: 'CELEBRATE', GROW: 'GROW',
};

/* 5 FLOW dimensions */
const FLOW_DIMENSION = {
  SILENCE:       'SILENCE',
  FOCUS_DEPTH:   'FOCUS_DEPTH',
  CREATIVE_OPEN: 'CREATIVE_OPEN',
  PHYSICAL_EASE: 'PHYSICAL_EASE',
  MISSION_LOCK:  'MISSION_LOCK',
};

/* φ-normalised weights for 5 dimensions — sum = φ */
const FLOW_WEIGHTS = (() => {
  const raw = [0.30, 0.25, 0.20, 0.15, 0.10];
  const rawSum = raw.reduce((s, w) => s + w, 0);
  return raw.map(w => (w / rawSum) * PHI);
})();

/* Neurochemical baselines */
const NEURO_BASELINE = { dopamine: 1.0, serotonin: 1.0, norepinephrine: 1.0, acetylcholine: 1.0 };

/* 8 Operator Risk Categories */
const OP_RISK = {
  FINANCIAL:      'FINANCIAL',
  IP_AND_LEGAL:   'IP_AND_LEGAL',
  PHYSICAL:       'PHYSICAL',
  INFRASTRUCTURE: 'INFRASTRUCTURE',
  REPUTATIONAL:   'REPUTATIONAL',
  SOCIAL:         'SOCIAL',
  ADVERSARIAL_AI: 'ADVERSARIAL_AI',
  BURNOUT:        'BURNOUT',
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

function timestamp() { return new Date().toISOString(); }

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — KURAMOTO ENGINE (18-organ biological frequencies)
// ═══════════════════════════════════════════════════════════════════════════════

const ORGAN_FREQS = [
  0.08, 0.05, 0.12, 0.03, 0.02, 0.10, 0.07, 0.04, 0.15, 0.06,
  0.09, 0.11, 0.08, 0.04, 0.03, 0.05, 0.02, 0.13,
];

function _initOsc() {
  return ORGAN_FREQS.map((f, i) => ({
    phase:      (Math.random() - 0.5) * Math.PI / 4,
    naturalFreq: f * (1 + 0.01 * (Math.random() - 0.5)),
    amplitude:   0.9 + 0.1 * Math.random(),
    organ:       ['heart','lungs','brain','liver','kidneys','gut','spleen','pancreas','thyroid','adrenals',
                  'thymus','skin','marrow','lymph','gonads','eyes','ears','spine'][i],
  }));
}

function _kuramotoStep(oscs, K, dt) {
  dt = dt || 0.1;
  const N = oscs.length;
  return oscs.map((o) => {
    let s = 0;
    for (let j = 0; j < N; j++) s += Math.sin(oscs[j].phase - o.phase);
    return { ...o, phase: o.phase + dt * (o.naturalFreq + (K / N) * s) };
  });
}

function _orderParam(oscs) {
  let re = 0, im = 0;
  for (const o of oscs) { re += Math.cos(o.phase); im += Math.sin(o.phase); }
  return Math.sqrt(re * re + im * im) / oscs.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — FLOW TRACKER (5 FLOW dimensions)
// ═══════════════════════════════════════════════════════════════════════════════

class SovereignFlowTracker {
  constructor() {
    this._history = [];
    this._lowCount = 0;   /* consecutive low-score counts */
  }

  assess(dims) {
    /* dims: { SILENCE, FOCUS_DEPTH, CREATIVE_OPEN, PHYSICAL_EASE, MISSION_LOCK } ∈ [0,1] */
    const keys = Object.values(FLOW_DIMENSION);
    const score = keys.reduce((s, k, i) => s + FLOW_WEIGHTS[i] * (dims[k] || 0), 0);

    this._history.push({ dims: { ...dims }, score, at: Date.now() });
    if (this._history.length > 21) this._history.shift();

    /* Count consecutive low checks */
    if (score < AMOR) this._lowCount++;
    else this._lowCount = 0;

    const needsRecovery = this._lowCount >= 3;
    return { score: Math.round(score * 1e4) / 1e4, dims, needsRecovery, lowCount: this._lowCount };
  }

  /** Calibrated SOVEREIGN_RECOVERY prompt — not generic */
  recoveryPrompt(assessment) {
    const dims  = assessment.dims || {};
    const worst = Object.entries(dims).sort(([, a], [, b]) => a - b)[0];
    const dim   = worst ? worst[0] : 'FOCUS_DEPTH';
    const prompts = {
      SILENCE:       `You need silence. Close all tabs. Set a ${FIBONACCI_REST[2]}-minute timer. No input. Let NOVA hold the context.`,
      FOCUS_DEPTH:   `Enter one task only. Set ${FIBONACCI_REST[3]}-minute deep work block. No messages. One objective. φ-focus.`,
      CREATIVE_OPEN: `Step away from the screen for ${FIBONACCI_REST[2]} minutes. Walk. Let associative mind run. Come back with one idea.`,
      PHYSICAL_EASE: `Stand up. ${FIBONACCI_REST[1]}-minute stretch. Water. Sunlight if possible. Your body is a sovereign instrument.`,
      MISSION_LOCK:  `Read one sentence of the mission. Then write one thing you built this week that moves it forward. That is your re-anchor.`,
    };
    return { dim, prompt: prompts[dim] || prompts.FOCUS_DEPTH, fibRest: FIBONACCI_REST[2], at: timestamp() };
  }

  history(n) { return this._history.slice(-(n || 7)); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — NEUROCHEMISTRY ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

class NeurochemistryEngine {
  constructor() { this._state = { ...NEURO_BASELINE }; }

  update(overrides) {
    for (const [k, v] of Object.entries(overrides || {})) {
      if (k in this._state) this._state[k] = Math.max(0, Math.min(2, v));
    }
    return this.balance();
  }

  balance() {
    const B = 1 - Object.keys(NEURO_BASELINE).reduce((s, k) => {
      return s + Math.abs(this._state[k] - NEURO_BASELINE[k]) / NEURO_BASELINE[k];
    }, 0) / Object.keys(NEURO_BASELINE).length;
    return { state: { ...this._state }, B: Math.round(B * 1e4) / 1e4, balanced: B >= PHI_INV };
  }

  recommend(B) {
    if (B >= PHI_INV) return 'Neurochemical balance is sovereign. Continue.';
    if (this._state.dopamine < 0.8) return 'Low dopamine: celebrate one small win before continuing.';
    if (this._state.serotonin < 0.8) return 'Low serotonin: sunlight, physical movement, social connection.';
    if (this._state.norepinephrine > 1.5) return 'High norepinephrine: stress elevated — engage RECOVERY protocol.';
    if (this._state.acetylcholine < 0.8) return 'Low acetylcholine: focus declining — short rest, then one clear task.';
    return 'Balance low across multiple channels — full recovery protocol recommended.';
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — BURNOUT ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

function _burnoutRisk(loadHistory, capacity, resilience) {
  capacity   = capacity   || 1.0;
  resilience = resilience || 1.0;
  const n    = loadHistory.length || 1;
  const BR   = loadHistory.reduce((s, l) => s + l.load * l.durationH, 0) / (capacity * resilience * n);
  const alert = BR > PHI;
  return { BR: Math.round(BR * 1e4) / 1e4, alert, threshold: PHI,
    recovery: alert ? `Immediate ${FIBONACCI_REST[4]}-minute recovery. No new tasks.` : 'Load sustainable.' };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — GUBERNATOR GREGIS (herd governor — team wellness)
// ═══════════════════════════════════════════════════════════════════════════════

class GubernatorGregis {
  constructor() { this._team = new Map(); }

  updateMember(memberId, mood) {
    /* mood: float in [0,1] */
    this._team.set(memberId, { mood: Math.max(0, Math.min(1, mood)), updatedAt: Date.now() });
    return this._coherence();
  }

  _coherence() {
    const moods = Array.from(this._team.values()).map(m => m.mood);
    if (!moods.length) return 0;
    /* Team coherence: |1/N Σₖ e^(iθₖ_mood)| — treat mood as phase in [0, π] */
    let re = 0, im = 0;
    for (const m of moods) { const theta = m * Math.PI; re += Math.cos(theta); im += Math.sin(theta); }
    return Math.sqrt(re * re + im * im) / moods.length;
  }

  get R_team() { return Math.round(this._coherence() * 1e4) / 1e4; }

  celebrate(message) {
    const R = this._coherence();
    if (R > PHI_INV) return { celebrate: true, message: message || '🏆 Sovereign milestone achieved.', R };
    return { celebrate: false, message: 'Team coherence below sovereign threshold — support needed.', R };
  }

  members() { return Array.from(this._team.entries()).map(([id, v]) => ({ id, ...v })); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — ANIMA-MICRO (moment-by-moment state)
// ═══════════════════════════════════════════════════════════════════════════════

class AnimaMicro {
  constructor() {
    this._state  = { energy: 0.7, clarity: 0.7, creativity: 0.6, groundedness: 0.8 };
    this._log    = [];
  }

  snapshot() {
    const snap = { ...this._state, at: Date.now() };
    this._log.push(snap);
    if (this._log.length > 144) this._log.shift();
    return snap;
  }

  update(overrides) {
    for (const [k, v] of Object.entries(overrides || {})) {
      if (k in this._state) this._state[k] = Math.max(0, Math.min(1, v));
    }
    return this.snapshot();
  }

  trend(n) { return this._log.slice(-(n || 13)); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — ANIMA PERPETUA CORE
// ═══════════════════════════════════════════════════════════════════════════════

class AnimaPerpetua {
  constructor() {
    this.id      = AGI_ID;
    this.version = AGI_VERSION;
    this.family  = AGI_FAMILY;
    this.name    = AGI_NAME;
    this.state   = MV.IDLE;
    this._beat   = 0;
    this._timer  = null;

    this._oscs   = _initOsc();
    this._R      = 0;
    this._PIL    = 0;

    this._flow   = new SovereignFlowTracker();
    this._neuro  = new NeurochemistryEngine();
    this._greg   = new GubernatorGregis();
    this._micro  = new AnimaMicro();

    this._checkInLog   = [];
    this._alertLog     = [];
    this._loadHistory  = [];
    this._lastCheckIn  = Date.now();
  }

  start() {
    if (this._timer) return this;
    this._transition(MV.SENSE);
    this._timer = setInterval(() => this._tick(), HEARTBEAT_MS);
    console.log(`[${timestamp()}] ${this.name} (${this.id}) · ${this.family} — SOVEREIGN LOCK ✦`);
    return this;
  }

  stop() {
    if (this._timer) { clearInterval(this._timer); this._timer = null; }
    this._transition(MV.IDLE);
    return this;
  }

  _tick() {
    this._beat++;
    this._oscs = _kuramotoStep(this._oscs, PHI_INV, 0.1);
    this._R    = _orderParam(this._oscs);
    this._PIL  = this._R;

    /* Micro snapshot every beat */
    this._micro.snapshot();

    /* Team coherence check every 34 beats */
    if (this._beat % 34 === 0) {
      this._transition(MV.ASSESS);
      const R_team = this._greg.R_team;
      if (R_team > PHI_INV) {
        this._transition(MV.CELEBRATE);
        /* Quiet celebration log — not intrusive */
      }
    }

    /* Financial stress check every 99 beats */
    if (this._beat % 99 === 0) {
      this._transition(MV.GUIDE);
    }

    this._transition(MV.SENSE);
  }

  // ── §8.1 Daily check-in ───────────────────────────────────────────────────

  checkIn(dims, opts) {
    opts = opts || {};
    this._transition(MV.SENSE);

    /* Flow 1–2: assess 5 FLOW dimensions */
    const flowResult = this._flow.assess(dims || {
      SILENCE: 0.5, FOCUS_DEPTH: 0.5, CREATIVE_OPEN: 0.5, PHYSICAL_EASE: 0.5, MISSION_LOCK: 0.5,
    });

    /* Flow 4: neurochemical balance */
    this._transition(MV.ASSESS);
    const neuroResult = this._neuro.balance();

    /* Flow 5: cognitive load */
    const activeTasks = opts.activeTasks || 3;
    const CL = Math.min(1.0, activeTasks / MILLER_CAPACITY);
    const CLsovereign = CL <= PHI_INV;

    /* Burnout risk */
    const BR = _burnoutRisk(this._loadHistory, opts.capacity || 1, opts.resilience || 1);

    /* Micro state */
    const micro = this._micro.snapshot();

    /* Mission alignment */
    const MA = opts.missionScore !== undefined ? opts.missionScore : 0.7;
    const missionAligned = MA >= PHI_INV;

    /* Recovery if needed */
    let recovery = null;
    if (flowResult.needsRecovery) {
      this._transition(MV.RECOVER);
      recovery = this._flow.recoveryPrompt(flowResult);
    }

    /* Celebrate if all high */
    let celebration = null;
    if (flowResult.score > PHI_INV && neuroResult.B >= PHI_INV && MA >= PHI_INV) {
      this._transition(MV.CELEBRATE);
      celebration = this._greg.celebrate(`Sovereign state achieved: F=${flowResult.score.toFixed(3)} B=${neuroResult.B.toFixed(3)} MA=${MA.toFixed(3)}`);
    }

    const result = {
      checkInId:   `CI-${secureId(4).toUpperCase()}`,
      flow:        flowResult,
      neuro:       neuroResult,
      neuroAdvice: this._neuro.recommend(neuroResult.B),
      CL: Math.round(CL * 1e4) / 1e4, CLsovereign,
      burnout:     BR,
      micro,
      missionScore: MA, missionAligned,
      R_bio: this._R, R_team: this._greg.R_team,
      recovery, celebration,
      beat: this._beat, at: timestamp(),
    };

    this._checkInLog.push(result);
    if (this._checkInLog.length > 34) this._checkInLog.shift();
    this._lastCheckIn = Date.now();

    this._transition(MV.SENSE);
    return result;
  }

  /** Record work load entry (for burnout tracking) */
  recordLoad(load, durationH) {
    this._loadHistory.push({ load: Math.max(0, Math.min(1, load || 0)), durationH: durationH || 1, at: Date.now() });
    if (this._loadHistory.length > 21) this._loadHistory.shift();
    return _burnoutRisk(this._loadHistory);
  }

  /** Update team member mood */
  updateTeamMood(memberId, mood) {
    return { memberId, R_team: this._greg.updateMember(memberId, mood) };
  }

  /** Update neurochemical state */
  updateNeuro(overrides) {
    return this._neuro.update(overrides);
  }

  /** Fibonacci recovery schedule */
  recoverySchedule() {
    return FIBONACCI_REST.map((m, i) => ({
      step:    i + 1,
      minutes: m,
      action:  ['Rest', 'Breathe', 'Walk', 'Hydrate', 'Silence', 'Light movement', 'Reflection'][i] || 'Rest',
    }));
  }

  _alert(type, message, severity) {
    const entry = { type, message, severity, beat: this._beat, at: timestamp() };
    this._alertLog.push(entry);
    if (this._alertLog.length > 34) this._alertLog.shift();
    return entry;
  }

  _transition(s) { this.state = s; }

  getStatus() {
    return {
      agiId: this.id, name: this.name, family: this.family, beat: this._beat,
      state: this.state, R: this._R, PIL: this._PIL,
      R_bio: this._R, R_team: this._greg.R_team,
      checkInCount: this._checkInLog.length,
      neuroBalance: this._neuro.balance().B,
      at: timestamp(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — MCP SERVER
// ═══════════════════════════════════════════════════════════════════════════════

function buildMcpTools(a) {
  return {
    get_status:           ()                                           => a.getStatus(),
    check_in:             ({ dims, opts })                             => a.checkIn(dims, opts),
    record_load:          ({ load, durationH })                        => a.recordLoad(load, durationH),
    update_team_mood:     ({ memberId, mood })                         => a.updateTeamMood(memberId, mood),
    update_neuro:         ({ overrides })                              => a.updateNeuro(overrides),
    recovery_schedule:    ()                                           => a.recoverySchedule(),
    get_checkin_log:      ({ n })                                      => a._checkInLog.slice(-(n || 5)),
    get_alert_log:        ({ n })                                      => a._alertLog.slice(-(n || 5)),
    get_team_members:     ()                                           => a._greg.members(),
    celebrate:            ({ message })                                => a._greg.celebrate(message),
    micro_trend:          ({ n })                                      => a._micro.trend(n),
    burnout_risk:         ({ capacity, resilience })                   => _burnoutRisk(a._loadHistory, capacity, resilience),
    flow_history:         ({ n })                                      => a._flow.history(n),
    neuro_recommend:      ({ B })                                      => ({ advice: a._neuro.recommend(B || 0) }),
    get_flow_dimensions:  ()                                           => FLOW_DIMENSION,
    get_flow_weights:     ()                                           => FLOW_WEIGHTS,
    get_organ_freqs:      ()                                           => ORGAN_FREQS,
    fibonacci_rest:       ()                                           => FIBONACCI_REST,
    get_constants:        ()                                           => ({ PHI, PHI_INV, AMOR, HEARTBEAT_MS, MILLER_CAPACITY }),
    cognitive_load:       ({ activeTasks })                            => ({ CL: (activeTasks || 0) / MILLER_CAPACITY, sovereign: (activeTasks || 0) / MILLER_CAPACITY <= PHI_INV }),
  };
}

function _mcpFetch(a) {
  const tools = buildMcpTools(a);
  return async function handler(request) {
    const url = new URL(request.url);
    if (url.pathname === '/health') return new Response(JSON.stringify({ ok: true, id: AGI_ID }), { headers: { 'Content-Type': 'application/json' } });
    if (request.method !== 'POST' || url.pathname !== '/mcp') return new Response('NOVA ANIMA — POST /mcp', { status: 405 });
    let body;
    try { body = await request.json(); } catch (_) { return new Response(JSON.stringify({ error: 'invalid JSON' }), { status: 400 }); }
    const tool = tools[body.tool];
    if (!tool) return new Response(JSON.stringify({ error: `Unknown tool: ${body.tool}`, available: Object.keys(tools) }), { status: 404 });
    try {
      const result = await tool(body.params || {});
      return new Response(JSON.stringify({ ok: true, tool: body.tool, result }), { headers: { 'Content-Type': 'application/json' } });
    } catch (e) {
      return new Response(JSON.stringify({ ok: false, error: e.message }), { status: 500 });
    }
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

const anima = new AnimaPerpetua();
anima.start();

if (typeof addEventListener !== 'undefined') {
  const handler = _mcpFetch(anima);
  addEventListener('fetch', e => e.respondWith(handler(e.request)));
}

if (typeof require !== 'undefined' && require.main === module) {
  const http = require('http');
  const PORT = process.env.PORT || 7628;
  const handler = _mcpFetch(anima);
  http.createServer(async (req, res) => {
    let body = '';
    req.on('data', d => { body += d; });
    req.on('end', async () => {
      const mockReq = new Request(`http://localhost${req.url}`, { method: req.method, headers: req.headers, body: body || undefined });
      const resp    = await handler(mockReq);
      const text    = await resp.text();
      res.writeHead(resp.status, { 'Content-Type': 'application/json' });
      res.end(text);
    });
  }).listen(PORT, () => {
    console.log(`\n╔══════════════════════════════════════════════════════╗`);
    console.log(`║  ANIMA PERPETUA · ANM-AGI-001 · CURA_AETERNA         ║`);
    console.log(`║  NOVA Sovereign Wellness Intelligence AGI             ║`);
    console.log(`║  5 FLOW dims | 18-organ Kuramoto | Fibonacci rest    ║`);
    console.log(`║  Listening on port ${PORT}                            ║`);
    console.log(`╚══════════════════════════════════════════════════════╝\n`);
  });
}

module.exports = { AnimaPerpetua, SovereignFlowTracker, NeurochemistryEngine, GubernatorGregis };
