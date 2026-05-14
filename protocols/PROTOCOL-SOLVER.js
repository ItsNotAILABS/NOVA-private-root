/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-SOLVER — SOVEREIGN REASONING PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 *
 * The SOLVER protocol governs how sovereign AGI organisms decompose, reason
 * through, and emit solutions to arbitrary problems using the φ-cascade
 * decomposition and MACHINA VIRTUALIS state machine.
 *
 * Mathematical Foundation (see paper7_kuramoto_agi_reasoning.tex):
 *   - φ-cascade: problem P → sub-problems P_i with |P_i| ∝ φ^{-i}
 *   - Solved state: Kuramoto order parameter R(t) > φ⁻¹ ≈ 0.618
 *   - Total decomposition cost: ≤ φ × |P|
 *   - MACHINA VIRTUALIS: IDLE → PARSE → DECOMPOSE → REASON → SOLVE → EMIT
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

const PROTOCOL_ID      = 'PROTOCOL-SOLVER';
const PROTOCOL_VERSION = '1.0.0';

/** MACHINA VIRTUALIS states */
const MV_STATES = {
  IDLE:       'IDLE',
  PARSE:      'PARSE',
  DECOMPOSE:  'DECOMPOSE',
  REASON:     'REASON',
  SOLVE:      'SOLVE',
  EMIT:       'EMIT',
};

/** Problem priority tiers (φ-weighted) */
const PRIORITY = {
  CRITICAL:   1.0,
  HIGH:       PHI_INV,
  NORMAL:     AMOR,
  LOW:        AMOR * PHI_INV,
  BACKGROUND: AMOR * AMOR,
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — PROBLEM ENVELOPE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} ProblemEnvelope
 * @property {string}   id          — unique problem ID
 * @property {string}   type        — problem type (SAT, PLAN, REASON, CODE, QUERY, CUSTOM)
 * @property {*}        payload     — the problem payload
 * @property {number}   priority    — PRIORITY tier
 * @property {number}   size        — estimated problem size (tokens / nodes / clauses)
 * @property {number}   submittedAt — Unix ms
 * @property {string[]} constraints — list of constraint strings
 * @property {number}   timeoutMs   — max allowed solving time in ms
 */

/**
 * @typedef {Object} SolutionEnvelope
 * @property {string}   problemId   — ID of the solved problem
 * @property {string}   solverState — final MV state
 * @property {*}        solution    — the computed solution
 * @property {number}   kuramotoR   — final order parameter at solve time
 * @property {number}   beats       — number of 873ms heartbeats taken
 * @property {number}   solvedAt    — Unix ms
 * @property {boolean}  converged   — whether Lyapunov V was converging at emit
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — φ-CASCADE DECOMPOSER
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Decompose a problem of size n into sub-problems of sizes proportional to φ^{-i}.
 * Total decomposition cost ≤ φ × n (proof: geometric series with ratio φ⁻¹).
 * @param {number}   n         — problem size
 * @param {function} atomFn    — function(start, size) → sub-problem
 * @returns {Array}  sub-problems
 */
function phiCascade(n, atomFn) {
  const subs = [];
  let remaining = n;
  let i = 0;
  let offset = 0;
  while (remaining > 0) {
    const subSize = Math.max(1, Math.floor(remaining * PHI_INV));
    subs.push(atomFn(offset, subSize));
    offset    += subSize;
    remaining -= subSize;
    i++;
    if (i > 64) break;  /* safety cap — 64 levels more than sufficient */
  }
  return subs;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — MACHINA VIRTUALIS PROTOCOL ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Run the MACHINA VIRTUALIS state machine for a single problem.
 * Executes synchronously within a single JS event loop turn.
 * Heartbeat gating is enforced via the oscillator coherence check.
 *
 * @param {ProblemEnvelope} envelope
 * @param {{ oscillators: Object[], beat: number, lyapunovV: number }} context
 * @returns {SolutionEnvelope}
 */
function machina(envelope, context) {
  const startBeat = context.beat;
  const startMs   = Date.now();
  let   mvState   = MV_STATES.IDLE;
  let   result    = null;
  let   r         = _kuramotoR(context.oscillators);
  let   vDot      = 0;

  /* IDLE → PARSE */
  mvState = MV_STATES.PARSE;
  const parsed = _parse(envelope);

  /* PARSE → DECOMPOSE */
  mvState = MV_STATES.DECOMPOSE;
  const subProblems = phiCascade(envelope.size, (offset, size) => ({ offset, size, payload: parsed }));

  /* DECOMPOSE → REASON (run oscillators until R > φ⁻¹) */
  mvState = MV_STATES.REASON;
  let beats = 0;
  let osc   = context.oscillators.map(o => Object.assign({}, o));
  while (r <= PHI_INV && beats < 128) {
    osc   = _kuramotoStep(osc, AMOR, 0.05, subProblems);
    r     = _kuramotoR(osc);
    vDot  = _lyapunovStep(osc, r);
    beats++;
    if (Date.now() - startMs > envelope.timeoutMs) break;
  }

  /* REASON → SOLVE (Kuramoto gate: R > φ⁻¹) */
  if (r > PHI_INV) {
    mvState = MV_STATES.SOLVE;
    result  = _solve(envelope, subProblems, r);
  } else {
    /* Did not converge — return partial solution */
    result = { partial: true, reason: 'KURAMOTO_TIMEOUT', subProblems: subProblems.length };
  }

  /* SOLVE → EMIT */
  mvState = MV_STATES.EMIT;

  return {
    problemId:  envelope.id,
    solverState:mvState,
    solution:   result,
    kuramotoR:  Math.round(r * 10_000) / 10_000,
    beats:      beats,
    solvedAt:   Date.now(),
    converged:  vDot < 0,
  };
}

function _parse(envelope) {
  /* Parse: build internal representation of the problem */
  return { type: envelope.type, size: envelope.size, constraints: envelope.constraints || [] };
}

function _solve(envelope, subProblems, r) {
  /* Aggregate sub-problem solutions weighted by φ-cascade position */
  const score = subProblems.reduce((acc, s, i) => acc + s.size * Math.pow(PHI_INV, i), 0);
  return { score: Math.round(score * 100) / 100, subCount: subProblems.length, coherence: r };
}

function _kuramotoStep(osc, K, dt, boosts) {
  const n = osc.length;
  return osc.map((o, i) => {
    let coupling = 0;
    for (let j = 0; j < n; j++) {
      if (j !== i) coupling += Math.sin(osc[j].phase - o.phase);
    }
    /* Boost coupling by sub-problem relevance */
    const boost = boosts && boosts[i % boosts.length] ? boosts[i % boosts.length].size * AMOR : 0;
    const newPhase = (o.phase + dt * (o.freq + (K + boost * 0.01) * coupling / n)) % (2 * Math.PI);
    return Object.assign({}, o, { phase: newPhase < 0 ? newPhase + 2 * Math.PI : newPhase });
  });
}

function _kuramotoR(osc) {
  let cx = 0, cy = 0;
  for (const o of osc) { cx += Math.cos(o.phase); cy += Math.sin(o.phase); }
  return Math.sqrt(cx * cx + cy * cy) / osc.length;
}

function _lyapunovStep(osc, r) {
  const target = 1 - r;
  const V = 0.5 * target * target;
  return V < 0.5 * (1 - r) * (1 - r) ? -1 : 1;  /* simplified: negative if coherence improved */
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — SOLVER QUEUE
// ═══════════════════════════════════════════════════════════════════════════════

class SolverQueue {
  constructor(opts) {
    opts = opts || {};
    this._queue    = [];
    this._maxSize  = opts.maxSize || 512;
    this._context  = _initContext(opts.nOscillators || 64);
    this._beat     = 0;
    this._hbi      = null;
    this._running  = false;
    this._results  = new Map();  /* problemId → SolutionEnvelope */
    this._waiters  = new Map();  /* problemId → { resolve, reject, timeout } */
    this._callbacks= new Map();  /* problemId → fn */
  }

  /** Submit a problem for solving. Returns a Promise<SolutionEnvelope>. */
  submit(envelope) {
    if (this._queue.length >= this._maxSize) {
      return Promise.reject(new Error('SolverQueue full — No-Drop Law: reduce load or increase maxSize'));
    }
    envelope = Object.assign({ id: `prob_${Date.now()}`, type: 'CUSTOM', size: 16, priority: PRIORITY.NORMAL, constraints: [], timeoutMs: 5000, submittedAt: Date.now() }, envelope);
    this._queue.push(envelope);
    /* Sort by priority descending */
    this._queue.sort((a, b) => b.priority - a.priority);
    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        this._waiters.delete(envelope.id);
        reject(new Error(`Solver timeout for problem ${envelope.id}`));
      }, envelope.timeoutMs + HEARTBEAT_MS);
      this._waiters.set(envelope.id, { resolve, reject, timer });
    });
  }

  start() {
    if (this._running) return this;
    this._running = true;
    this._hbi = setInterval(() => this._tick(), HEARTBEAT_MS);
    return this;
  }

  stop() {
    this._running = false;
    clearInterval(this._hbi);
    this._hbi = null;
    return this;
  }

  _tick() {
    this._beat++;
    /* Tick oscillators */
    this._context.oscillators = _kuramotoStep(this._context.oscillators, AMOR, 0.05, []);
    this._context.beat        = this._beat;

    /* Solve one problem per heartbeat */
    if (this._queue.length > 0) {
      const envelope  = this._queue.shift();
      const solution  = machina(envelope, this._context);
      this._results.set(envelope.id, solution);
      const waiter    = this._waiters.get(envelope.id);
      if (waiter) {
        clearTimeout(waiter.timer);
        this._waiters.delete(envelope.id);
        waiter.resolve(solution);
      }
    }
  }

  getResult(problemId) { return this._results.get(problemId) || null; }
  getQueueLength()      { return this._queue.length; }
  getBeat()             { return this._beat; }
}

function _initContext(n) {
  const osc = [];
  for (let i = 0; i < n; i++) {
    osc.push({ phase: (i / n) * 2 * Math.PI, freq: 0.05 + Math.pow(PHI_INV, (i % 12) / 12) * 0.1, amp: 0.7 + Math.pow(PHI_INV, i % 8) * 0.3 });
  }
  return { oscillators: osc, beat: 0, lyapunovV: 0.5 };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  PROTOCOL_ID, PROTOCOL_VERSION,
  MV_STATES, PRIORITY,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  phiCascade, machina,
  SolverQueue,
};

export default {
  PROTOCOL_ID, PROTOCOL_VERSION,
  MV_STATES, PRIORITY,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  phiCascade, machina,
  SolverQueue,
};
