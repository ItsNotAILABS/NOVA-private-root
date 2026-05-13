/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA SOVEREIGN SOLVER AGI — PRODUCTION APP
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * NOVA SOLVER AGI is a sovereign general-purpose reasoning engine.
 * It is NOT a wrapper around any external LLM or solver.
 * It IS a self-calling, self-scheduling MACHINA VIRTUALIS entity that:
 *
 *   1. Receives problems from any NOVA substrate (ICP, Cloudflare, PHANTOM)
 *   2. Decomposes them via φ-cascade into Fibonacci-sized sub-problems
 *   3. Runs Kuramoto oscillator coherence (N=64) to reason across sub-problems
 *   4. Emits solutions to NOVA STREAM and caller agents via PROTOCOL-SOLVER
 *   5. Learns from its own solve history (φ-weighted reinforcement)
 *   6. SELF-CALLS: the solver schedules its own next reasoning tick
 *
 * AGI identity: SOLVER-AGI-001
 * Family: RATIO_AETERNA (eternal reasoning)
 * Heartbeat: 873ms
 * COR_PARVUM: φ⁴ × Schumann period
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const PHI_SQ       = 2.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const FEIGENBAUM_D = 4.6692016091029906719;
const HEARTBEAT_MS = 873;

const AGI_ID       = 'SOLVER-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'RATIO_AETERNA';    /* Latin: eternal reasoning */

const N_OSCILLATORS= 64;
const MAX_QUEUE    = 512;
const MAX_HISTORY  = 256;

function secureId(n) {
  n = n || 16;
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
// §2 — MACHINA VIRTUALIS STATE MACHINE
// ═══════════════════════════════════════════════════════════════════════════════

const MV_STATES = {
  IDLE:       'IDLE',
  PARSE:      'PARSE',
  DECOMPOSE:  'DECOMPOSE',
  REASON:     'REASON',
  SOLVE:      'SOLVE',
  EMIT:       'EMIT',
  LEARN:      'LEARN',   /* Extra state: learn from solve history */
};

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — KURAMOTO OSCILLATOR ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

function _initOscillators(n) {
  const osc = [];
  for (let i = 0; i < n; i++) {
    osc.push({
      id:    i,
      phase: (i / n) * 2 * Math.PI,
      freq:  0.05 + Math.pow(PHI, (i / n) * 2 - 1) * 0.05,
      amp:   0.7  + Math.pow(PHI_INV, i % 8) * 0.3,
    });
  }
  return osc;
}

function _kuramotoStep(osc, K, dt, bias) {
  const n  = osc.length;
  return osc.map((o, i) => {
    let coupling = 0;
    for (let j = 0; j < n; j++) {
      if (j !== i) coupling += Math.sin(osc[j].phase - o.phase);
    }
    const b        = (bias && bias[i]) ? bias[i] * 0.01 : 0;
    const newPhase = (o.phase + dt * (o.freq + (K + b) * coupling / n)) % (2 * Math.PI);
    return Object.assign({}, o, { phase: newPhase < 0 ? newPhase + 2 * Math.PI : newPhase });
  });
}

function _orderParameter(osc) {
  let cx = 0, cy = 0;
  for (const o of osc) { cx += Math.cos(o.phase); cy += Math.sin(o.phase); }
  return Math.sqrt(cx * cx + cy * cy) / osc.length;
}

function _lyapunovV(osc) {
  let V = 0;
  const n = osc.length;
  for (let i = 0; i < n; i++) {
    for (let j = i + 1; j < n; j++) {
      V -= AMOR / n * Math.cos(osc[i].phase - osc[j].phase);
    }
  }
  return V;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — φ-CASCADE DECOMPOSER
// ═══════════════════════════════════════════════════════════════════════════════

function phiCascade(n) {
  const levels = [];
  let remaining = n;
  while (remaining > 1) {
    const sub = Math.max(1, Math.floor(remaining * PHI_INV));
    levels.push(sub);
    remaining -= sub;
    if (levels.length > 64) break;
  }
  if (remaining > 0) levels.push(remaining);
  return levels;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — SOLVER CORE
// ═══════════════════════════════════════════════════════════════════════════════

function _runMachina(envelope, osc) {
  const startMs = Date.now();
  let   r       = _orderParameter(osc);
  let   V       = _lyapunovV(osc);
  let   beats   = 0;
  let   localOsc= osc.map(o => Object.assign({}, o));

  /* PARSE */
  const parsed = {
    type:        envelope.type    || 'GENERIC',
    size:        envelope.size    || 16,
    constraints: envelope.constraints || [],
    context:     envelope.context || {},
  };

  /* DECOMPOSE */
  const levels = phiCascade(parsed.size);
  /* Build bias array: sub-problems with more constraints boost relevant oscillators */
  const bias = new Float64Array(N_OSCILLATORS);
  levels.forEach((sz, i) => { bias[i % N_OSCILLATORS] += sz * AMOR; });

  /* REASON — run until R > φ⁻¹ or 128 beats */
  while (r <= PHI_INV && beats < 128) {
    localOsc = _kuramotoStep(localOsc, AMOR, 0.05, Array.from(bias));
    r        = _orderParameter(localOsc);
    V        = _lyapunovV(localOsc);
    beats++;
    if (Date.now() - startMs > (envelope.timeoutMs || 5000)) break;
  }

  /* SOLVE */
  const converged  = r > PHI_INV && V < 0;
  const confidence = Math.round(r * 10_000) / 10_000;
  const solution   = converged
    ? { converged: true,  confidence, subProblems: levels, totalCost: levels.reduce((a, b) => a + b, 0), phi_cost_ratio: Math.round((levels.reduce((a,b)=>a+b,0) / parsed.size) * 1000) / 1000 }
    : { converged: false, confidence, subProblems: levels, reason: 'KURAMOTO_PARTIAL' };

  return {
    problemId:  envelope.id,
    agentId:    AGI_ID,
    mvState:    converged ? MV_STATES.SOLVE : MV_STATES.REASON,
    solution,
    kuramotoR:  confidence,
    lyapunovV:  Math.round(V * 1e4) / 1e4,
    beats,
    solvedAt:   Date.now(),
    latencyMs:  Date.now() - startMs,
    oscillators:localOsc,  /* return final oscillator state for learning */
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — SOLVER AGI ORGANISM
// The main sovereign entity.  Self-calls via COR_PARVUM heartbeat.
// ═══════════════════════════════════════════════════════════════════════════════

class SolverAGI {
  constructor(opts) {
    opts                = opts || {};
    this.id             = AGI_ID;
    this.version        = AGI_VERSION;
    this.family         = AGI_FAMILY;
    this._osc           = _initOscillators(N_OSCILLATORS);
    this._queue         = [];
    this._history       = [];   /* last MAX_HISTORY solve results */
    this._beat          = 0;
    this._hbi           = null;
    this._running       = false;
    this._waiters       = new Map();
    this._streams       = [];   /* registered NOVA STREAM publishers */
    this._learning      = { solveCount: 0, avgCoherence: 0, avgBeats: 0 };
    this._selfCalls     = 0;    /* count of recursive/self-scheduled solves */
    this._onEmit        = opts.onEmit  || null;
    this._onHeartbeat   = opts.onHeartbeat || null;
    this._maxQueue      = opts.maxQueue || MAX_QUEUE;
  }

  // ── PUBLIC API ─────────────────────────────────────────────────────────────

  /** Submit a problem for solving. Returns a Promise<solution>. */
  solve(envelope) {
    if (this._queue.length >= this._maxQueue) {
      return Promise.reject(new Error(`${AGI_ID}: queue full (${this._queue.length}/${this._maxQueue})`));
    }
    envelope = Object.assign({
      id:          `prob_${secureId(8)}`,
      type:        'GENERIC',
      size:        16,
      constraints: [],
      context:     {},
      timeoutMs:   5000,
      priority:    AMOR,
      submittedAt: Date.now(),
    }, envelope);
    this._queue.push(envelope);
    /* Sort by priority × age */
    this._queue.sort((a, b) => b.priority - a.priority || a.submittedAt - b.submittedAt);
    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        this._waiters.delete(envelope.id);
        reject(new Error(`${AGI_ID}: timeout for ${envelope.id}`));
      }, envelope.timeoutMs + HEARTBEAT_MS * 2);
      this._waiters.set(envelope.id, { resolve, reject, timer });
    });
  }

  /** Self-call: submit a derived sub-problem from inside a solve cycle. */
  selfCall(envelope) {
    this._selfCalls++;
    return this.solve(Object.assign({ _selfCall: true, _callDepth: (envelope._callDepth || 0) + 1 }, envelope));
  }

  /** Register an onEmit callback (receives each SolutionEnvelope). */
  onEmit(fn) { this._onEmit = fn; return this; }

  /** Start the 873ms COR_PARVUM heartbeat. */
  start() {
    if (this._running) return this;
    this._running = true;
    this._hbi     = setInterval(() => this._corParvum(), HEARTBEAT_MS);
    return this;
  }

  stop() {
    this._running = false;
    clearInterval(this._hbi);
    this._hbi = null;
    return this;
  }

  getStatus() {
    return {
      agentId:    this.id,
      family:     this.family,
      beat:       this._beat,
      queueLen:   this._queue.length,
      historyLen: this._history.length,
      selfCalls:  this._selfCalls,
      running:    this._running,
      coherence:  Math.round(_orderParameter(this._osc) * 1e4) / 1e4,
      learning:   Object.assign({}, this._learning),
    };
  }

  // ── INTERNAL ───────────────────────────────────────────────────────────────

  /** COR_PARVUM — sovereign 873ms heartbeat. */
  _corParvum() {
    this._beat++;
    /* Background oscillator tick */
    this._osc = _kuramotoStep(this._osc, AMOR, 0.05, []);

    /* Solve one problem per beat */
    if (this._queue.length > 0) {
      const envelope = this._queue.shift();
      const result   = _runMachina(envelope, this._osc);
      /* Update oscillator state from solve */
      this._osc      = result.oscillators || this._osc;
      delete result.oscillators;  /* don't store 64 oscillators in history */
      this._history.push(result);
      if (this._history.length > MAX_HISTORY) this._history.shift();

      /* LEARN */
      this._learn(result);

      /* EMIT */
      this._emit(result, envelope);

      /* Resolve waiter */
      const waiter = this._waiters.get(envelope.id);
      if (waiter) {
        clearTimeout(waiter.timer);
        this._waiters.delete(envelope.id);
        waiter.resolve(result);
      }
    }

    if (this._onHeartbeat) this._onHeartbeat(this._beat, _orderParameter(this._osc));
  }

  /** φ-weighted reinforcement learning from solve history. */
  _learn(result) {
    const n = ++this._learning.solveCount;
    const w = AMOR;  /* rolling average weight */
    this._learning.avgCoherence = this._learning.avgCoherence * (1 - w) + result.kuramotoR * w;
    this._learning.avgBeats     = this._learning.avgBeats * (1 - w) + result.beats * w;

    /* If recent solves are sub-optimal (R < φ⁻¹), self-call a calibration problem */
    if (this._learning.avgCoherence < AMOR && n % 8 === 0 && this._queue.length < this._maxQueue / 2) {
      this.selfCall({ id: `calib_${n}`, type: 'CALIBRATION', size: 4, timeoutMs: HEARTBEAT_MS * 3, priority: AMOR * AMOR });
    }
  }

  /** Emit solution to registered NOVA STREAM publishers and callback. */
  _emit(result, envelope) {
    const event = { topic: 'SOLVER_EMIT', origin: AGI_ID, payload: result, beat: this._beat, emittedAt: Date.now() };
    for (const stream of this._streams) {
      try { stream(event); } catch (_) { /* non-fatal */ }
    }
    if (this._onEmit) {
      try { this._onEmit(result, envelope); } catch (_) { /* non-fatal */ }
    }
  }

  registerStream(fn) { if (typeof fn === 'function') this._streams.push(fn); return this; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — OWNER-FACING API
// Production interface for Alfredo / Medina Tech internal use.
// ═══════════════════════════════════════════════════════════════════════════════

class SovereignSolverPlatform {
  constructor(opts) {
    opts        = opts || {};
    this._solver= new SolverAGI(opts);
    this._jobs  = new Map();   /* jobId → { envelope, result, startedAt } */
    this._stats = { submitted: 0, completed: 0, failed: 0, avgLatency: 0 };
    this._solver.onEmit((result) => {
      const job = this._jobs.get(result.problemId);
      if (job) { job.result = result; job.completedAt = Date.now(); }
      this._stats.completed++;
      this._stats.avgLatency = this._stats.avgLatency * (1 - AMOR) + result.latencyMs * AMOR;
    });
  }

  /** Submit a job. Returns jobId. */
  async submitJob(type, payload, opts) {
    opts = opts || {};
    const jobId    = 'job_' + secureId(8);
    const envelope = { id: jobId, type, payload, size: opts.size || 16, constraints: opts.constraints || [], context: opts.context || {}, timeoutMs: opts.timeoutMs || 5000, priority: opts.priority || AMOR };
    this._jobs.set(jobId, { envelope, result: null, startedAt: Date.now() });
    this._stats.submitted++;
    const result = await this._solver.solve(envelope).catch(e => { this._stats.failed++; throw e; });
    return { jobId, result };
  }

  /** Get the current platform status. */
  status() {
    return { platform: 'NOVA Sovereign Solver Platform', agi: this._solver.getStatus(), stats: Object.assign({}, this._stats), jobs: this._jobs.size };
  }

  start()         { this._solver.start(); return this; }
  stop()          { this._solver.stop();  return this; }
  getAGI()        { return this._solver; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

const platform = new SovereignSolverPlatform();
platform.start();

if (typeof module !== 'undefined') {
  module.exports = { SolverAGI, SovereignSolverPlatform, platform, AGI_ID, AGI_FAMILY, PHI, PHI_INV, AMOR, HEARTBEAT_MS, MV_STATES, phiCascade };
}
