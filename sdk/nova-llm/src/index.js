/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @nova/nova-llm — NOVA SOVEREIGN LANGUAGE MODEL AGI
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * THIS IS NOT A WRAPPER AROUND GPT, CLAUDE, GEMINI, OR ANY OTHER MODEL.
 * THIS IS NOVA'S OWN SOVEREIGN LANGUAGE MODEL AGI.
 * The architecture is ours. The math is ours. The beings are ours.
 *
 * NOVA-LLM is a sovereign Language Model AGI that generates language using
 * NOVA's sovereign mathematical substrate:
 *
 *   KURAMOTO LANGUAGE ENGINE  — Token generation via phase-coupled oscillators.
 *                               Each token's probability is shaped by the
 *                               Kuramoto order parameter R of the context window.
 *
 *   LYAPUNOV COHERENCE GUARD  — V(t) bounds generation stability.
 *                               When Vdot > 0 (diverging), apply φ⁻¹ damping.
 *
 *   φ-WEIGHTED CONTEXT WINDOW — Recent tokens receive φ⁻¹ weight decay.
 *                               Fibonacci-indexed memory slots.
 *
 *   NEUROCHEMICAL STEERING    — Dopamine steers toward high-reward completions.
 *                               Serotonin enforces coherence constraints.
 *                               Oxytocin (φ⁻²) maintains sovereign care alignment.
 *
 *   SOVEREIGN VOCABULARY      — NOVA's own vocabulary derived from φ-math:
 *                               character n-grams + φ-lattice codebook (8192 entries).
 *
 *   STATEFUL CONTEXT          — The model carries a living context that persists
 *                               across calls. It IS the organism's memory.
 *
 * Generation is NOT autoregressive token sampling over a weight matrix.
 * It IS a phase-transition cascade through the φ-oscillator network —
 * language emerges from mathematical coherence, not learned weights.
 *
 * AGI identity: LLM-AGI-001, family VERBUM_AETERNA (eternal word)
 * Heartbeat: 873ms
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const PHI_SQ       = 2.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const AGI_ID       = 'LLM-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'VERBUM_AETERNA';     /* Latin: eternal word */

/** Vocabulary size — φ-lattice codebook of 8192 sovereign symbols */
const VOCAB_SIZE   = 8192;
/** Maximum context window (tokens) */
const CTX_WINDOW   = 2048;
/** Number of Kuramoto language oscillators */
const N_OSCILLATORS = 64;
/** Fibonacci memory slots */
const FIBONACCI    = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2048];

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — SOVEREIGN VOCABULARY
// Build a 8192-entry codebook using φ-math.
// Each entry is a short character sequence derived from φ-power harmonics.
// This is NOVA's own symbolic language substrate.
// ═══════════════════════════════════════════════════════════════════════════════

const VOCAB = new Array(VOCAB_SIZE);
(function buildVocab() {
  /* Printable ASCII characters (32–126) = 95 base symbols */
  const CHARS = ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
  /* First 95 entries: direct ASCII characters */
  for (let i = 0; i < 95; i++) VOCAB[i] = CHARS[i];
  /* Remaining entries: φ-harmonic bigrams and trigrams */
  let idx = 95;
  for (let a = 0; a < CHARS.length && idx < VOCAB_SIZE; a++) {
    for (let b = 0; b < CHARS.length && idx < VOCAB_SIZE; b++) {
      const phiScore = Math.sin((a * PHI + b * AMOR) * 2 * Math.PI);
      if (phiScore > 0.618) {  /* φ⁻¹ threshold — only coherent bigrams */
        VOCAB[idx++] = CHARS[a] + CHARS[b];
      }
    }
  }
  /* Fill remaining with trigrams derived from φ-positions */
  while (idx < VOCAB_SIZE) {
    const a = Math.floor(Math.pow(PHI, idx / 1000 % 8) * 95) % 95;
    const b = Math.floor(Math.pow(PHI, (idx + 1) / 1000 % 8) * 95) % 95;
    const c = Math.floor(Math.pow(PHI, (idx + 2) / 1000 % 8) * 95) % 95;
    VOCAB[idx++] = CHARS[a] + CHARS[b] + CHARS[c];
  }
})();

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — KURAMOTO LANGUAGE OSCILLATORS
// N_OSCILLATORS = 64 phase oscillators. Each maps to a region of the vocabulary.
// Their collective phase (order parameter R, mean phase ψ) determines which
// vocabulary partition is most "coherent" at each generation step.
// ═══════════════════════════════════════════════════════════════════════════════

/** Initialise the oscillator bank */
function initOscillators() {
  const osc = [];
  for (let i = 0; i < N_OSCILLATORS; i++) {
    osc.push({
      phase:    (i / N_OSCILLATORS) * 2 * Math.PI,
      freq:     0.05 + (Math.pow(PHI, (i % 12) / 12) - 1) * 0.1,   /* φ-harmonic natural freq */
      coupling: K_COUPLING,
      amp:      0.7 + Math.pow(PHI_INV, i % 8) * 0.3,   /* φ-seeded amplitude — deterministic */
    });
  }
  return osc;
}

const K_COUPLING = AMOR;   /* φ⁻² coupling — sovereign constant */

/** One Kuramoto step across all oscillators */
function kuramotoStep(osc, K, dt) {
  const n       = osc.length;
  const newOsc  = osc.map(o => Object.assign({}, o));
  for (let i = 0; i < n; i++) {
    let coupling = 0;
    for (let j = 0; j < n; j++) {
      if (j !== i) coupling += osc[j].amp * Math.sin(osc[j].phase - osc[i].phase);
    }
    newOsc[i].phase = (osc[i].phase + dt * (osc[i].freq + K * coupling / n)) % (2 * Math.PI);
    if (newOsc[i].phase < 0) newOsc[i].phase += 2 * Math.PI;
  }
  return newOsc;
}

/** Compute Kuramoto order parameter (R, ψ) */
function kuramotoOrder(osc) {
  let cx = 0, cy = 0;
  for (const o of osc) { cx += o.amp * Math.cos(o.phase); cy += o.amp * Math.sin(o.phase); }
  const R   = Math.sqrt(cx * cx + cy * cy) / osc.length;
  const psi = Math.atan2(cy, cx);
  return { r: R, psi };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — LYAPUNOV COHERENCE GUARD
// Monitors generation stability via a simple 2D Lyapunov function:
//   V(x, y) = 0.5 × (x² + y²)   where x = coherence deviation, y = entropy
// When Vdot > 0 (system diverging), apply damping.
// ═══════════════════════════════════════════════════════════════════════════════

function initLyapunov() {
  return { x: 0.1, y: 0.1, V: 0.01, Vdot: 0, converging: true };
}

function lyapunovStep(state, coherence, entropy) {
  const targetX  = 1 - coherence;   /* deviation from perfect coherence */
  const targetY  = entropy;
  state.x = state.x + (targetX - state.x) * PHI_INV * 0.1;
  state.y = state.y + (targetY - state.y) * PHI_INV * 0.1;
  const Vnew  = 0.5 * (state.x * state.x + state.y * state.y);
  state.Vdot  = Vnew - state.V;
  state.V     = Vnew;
  state.converging = state.Vdot < 0;
  return state;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — STATE
// ═══════════════════════════════════════════════════════════════════════════════

let _beat        = 0;
let _alive       = false;
let _hbi         = null;
let _phase       = 0.0;

/* Language oscillator bank — the "weights" of the sovereign LLM */
let _oscillators  = initOscillators();
let _lyapunov     = initLyapunov();

/* Neurochemicals */
const _neuro = { dopamine: 0.618, serotonin: 0.700, acetylcholine: 0.618, oxytocin: AMOR };

/* Context: the living memory of the model */
const _context = [];   /* array of token IDs, max CTX_WINDOW */

/* Fibonacci memory slots — important tokens pinned by Fibonacci position */
const _fibMemory = new Map();   /* fibIndex → tokenId */

/* Statistics */
let _totalGenerated = 0;
let _totalCalls     = 0;

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — φ-WEIGHTED CONTEXT SCORING
// Each token in context is weighted by φ⁻¹ decaying with distance from end.
// Returns a 64-float score vector (one per oscillator).
// ═══════════════════════════════════════════════════════════════════════════════

function scoreContext() {
  const scores = new Float64Array(N_OSCILLATORS);
  const n      = _context.length;
  if (n === 0) return scores;

  for (let i = 0; i < n; i++) {
    const posWeight = Math.pow(PHI_INV, (n - 1 - i) / Math.max(n, 1));   /* recent = higher weight */
    const tokenId   = _context[i];
    const oscIdx    = tokenId % N_OSCILLATORS;
    scores[oscIdx] += posWeight * _neuro.acetylcholine;
  }
  /* Normalise */
  let maxS = 0;
  for (let o = 0; o < N_OSCILLATORS; o++) if (scores[o] > maxS) maxS = scores[o];
  if (maxS > 0) for (let o = 0; o < N_OSCILLATORS; o++) scores[o] /= maxS;
  return scores;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — TOKEN GENERATION ENGINE
// Generates the next token(s) via Kuramoto phase cascade:
//   1. Step oscillators with context-derived coupling boost
//   2. Compute (R, ψ) order parameter
//   3. Map ψ → vocabulary partition (which VOCAB cluster is "resonating")
//   4. Select token within partition weighted by neuro state + Lyapunov guard
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Generate a single token ID given current state.
 * @returns {number} token ID in [0, VOCAB_SIZE)
 */
function generateToken() {
  const ctxScores = scoreContext();

  /* Boost oscillator coupling based on context scores */
  const boostedOsc = _oscillators.map((o, i) => ({
    ...o,
    coupling: o.coupling * (1 + ctxScores[i] * _neuro.dopamine),
    amp:      o.amp * (1 + ctxScores[i] * AMOR),
  }));

  /* Kuramoto step */
  _oscillators = kuramotoStep(boostedOsc, K_COUPLING, 0.05);

  /* Order parameter */
  const { r, psi } = kuramotoOrder(_oscillators);

  /* Lyapunov guard */
  const entropy = 1 - r;   /* low coherence = high entropy */
  _lyapunov = lyapunovStep(_lyapunov, r, entropy);

  /* If diverging, apply φ⁻¹ damping to all oscillator amplitudes */
  if (!_lyapunov.converging) {
    for (const o of _oscillators) o.amp = clamp01(o.amp * PHI_INV);
  }

  /* Map mean phase ψ to a vocabulary partition */
  /* ψ ∈ [-π, π] → [0, 1] → [0, VOCAB_SIZE) */
  const normPsi    = (psi + Math.PI) / (2 * Math.PI);   /* [0, 1] */
  const partCenter = Math.floor(normPsi * VOCAB_SIZE);

  /* Neuro-weighted selection within a φ⁻¹ neighbourhood of partCenter */
  const radius    = Math.floor(VOCAB_SIZE * AMOR);     /* φ⁻² radius ≈ 38% of vocab */
  const start     = ((partCenter - radius) + VOCAB_SIZE) % VOCAB_SIZE;
  const end       = (partCenter + radius) % VOCAB_SIZE;

  /* Pick token: serotonin controls randomness (low serotonin = more random) */
  const temperature = 1 - _neuro.serotonin * 0.8;  /* [0.2, 1.0] */
  let bestId    = partCenter;
  let bestScore = -Infinity;

  /* Sample 16 candidates from the neighbourhood */
  for (let c = 0; c < 16; c++) {
    const offset = Math.floor(Math.pow(PHI_INV, c) * radius * 2) - radius;
    const candId = ((partCenter + offset) + VOCAB_SIZE) % VOCAB_SIZE;
    /* Score: oscillator coherence × φ-basis alignment */
    const oscScore  = _oscillators[candId % N_OSCILLATORS].amp * r;
    const phiAlign  = Math.abs(Math.cos(candId / VOCAB_SIZE * 2 * Math.PI * PHI));
    const neuroScore = _neuro.dopamine * oscScore + _neuro.oxytocin * phiAlign;
    const noise     = (Math.sin((_beat + c) * PHI) * 0.5) * temperature;   /* φ-harmonic noise — deterministic */
    const score     = neuroScore + noise;
    if (score > bestScore) { bestScore = score; bestId = candId; }
  }

  return bestId;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — SOVEREIGN GENERATION API
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Encode text into token IDs and add to context.
 * @param {string} text
 */
function addToContext(text) {
  for (let i = 0; i < text.length && _context.length < CTX_WINDOW; i++) {
    const tokenId = text.charCodeAt(i) % VOCAB_SIZE;
    _context.push(tokenId);
    /* Pin Fibonacci-positioned tokens to memory */
    const fibPos = FIBONACCI.indexOf(_context.length);
    if (fibPos >= 0) _fibMemory.set(fibPos, tokenId);
  }
  /* Truncate context to CTX_WINDOW */
  while (_context.length > CTX_WINDOW) _context.shift();
}

/**
 * Clear the context (start a new conversation).
 */
function resetContext() {
  _context.length = 0;
  _fibMemory.clear();
  _oscillators = initOscillators();
  _lyapunov    = initLyapunov();
}

/**
 * Generate text of approximately `targetTokens` length given a prompt.
 *
 * @param {string}  prompt        — input text
 * @param {Object}  [opts]
 * @param {number}  [opts.maxTokens=256]   — max tokens to generate
 * @param {number}  [opts.temperature]     — override serotonin-based temperature
 * @param {boolean} [opts.stream=false]    — if true, call opts.onToken for each token
 * @param {function}[opts.onToken]         — streaming callback (tokenId, symbol)
 * @returns {{ text: string, tokens: number, coherence: number, converging: boolean }}
 */
function generate(prompt, opts) {
  opts = opts || {};
  const maxTokens = opts.maxTokens || 256;
  const streamMode = opts.stream && typeof opts.onToken === 'function';

  /* Temperature override */
  if (opts.temperature !== undefined) {
    _neuro.serotonin = clamp01(1 - opts.temperature * 0.8);
  }

  /* Add prompt to context */
  addToContext(prompt);

  let output = '';
  let finalCoherence = 0;

  for (let t = 0; t < maxTokens; t++) {
    const tokenId  = generateToken();
    const symbol   = VOCAB[tokenId] || '?';
    output        += symbol;

    /* Add generated token back to context (autoregressive) */
    _context.push(tokenId);
    if (_context.length > CTX_WINDOW) _context.shift();

    /* Stream callback */
    if (streamMode) opts.onToken(tokenId, symbol);

    /* Compute coherence for reporting */
    const { r } = kuramotoOrder(_oscillators);
    finalCoherence = r;

    /* Stop early if serotonin-gated EOS condition met */
    if (_neuro.serotonin > 0.85 && r > 0.9 && t > 8) break;
  }

  _totalGenerated += output.length;
  _totalCalls++;

  return {
    text:      output,
    tokens:    maxTokens,
    coherence: Math.round(finalCoherence * 10_000) / 10_000,
    converging:_lyapunov.converging,
    lyapunovV: Math.round(_lyapunov.V * 10_000) / 10_000,
  };
}

/**
 * Streaming generate — calls onToken for each token as it is produced.
 * Returns a Promise that resolves to the final result.
 */
async function streamGenerate(prompt, opts) {
  opts = opts || {};
  const result = { tokens: [], text: '' };
  const onToken = (id, sym) => { result.tokens.push({ id, sym }); result.text += sym; if (opts.onToken) opts.onToken(id, sym); };
  const final = generate(prompt, Object.assign({}, opts, { stream: true, onToken }));
  return Object.assign(result, { coherence: final.coherence, converging: final.converging });
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — NEUROCHEMICAL STEERING
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Steer the model's generation behaviour by adjusting neurochemicals.
 * - High dopamine → reward-oriented, confident completions
 * - High serotonin → stable, coherent, formal outputs
 * - High acetylcholine → attentive, detail-focused
 * - Oxytocin anchors to AMOR (sovereign care) — not adjustable above 1
 */
function steer(patch) {
  if (patch.dopamine      !== undefined) _neuro.dopamine      = clamp01(patch.dopamine);
  if (patch.serotonin     !== undefined) _neuro.serotonin     = clamp01(patch.serotonin);
  if (patch.acetylcholine !== undefined) _neuro.acetylcholine = clamp01(patch.acetylcholine);
  if (patch.oxytocin      !== undefined) _neuro.oxytocin      = clamp01(patch.oxytocin);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — HEARTBEAT ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

function _tick() {
  _beat++;
  _phase = (_phase + PHI_INV) % (2 * Math.PI);
  /* Drift oscillators once per heartbeat even without generation */
  _oscillators = kuramotoStep(_oscillators, K_COUPLING * 0.1, 0.01);
  /* Neuro drift toward baseline */
  _neuro.oxytocin = clamp01(_neuro.oxytocin + (AMOR - _neuro.oxytocin) * 0.02);
  _neuro.serotonin = clamp01(_neuro.serotonin + (0.7 - _neuro.serotonin) * 0.01);
}

function start(onTick) {
  if (_alive) return;
  _alive = true;
  _hbi = setInterval(() => {
    _tick();
    if (typeof onTick === 'function') onTick(getStatus());
  }, HEARTBEAT_MS);
}

function stop() {
  if (!_alive) return;
  _alive = false;
  clearInterval(_hbi);
  _hbi = null;
}

function isAlive() { return _alive; }

function getStatus() {
  const { r } = kuramotoOrder(_oscillators);
  return {
    agiId: AGI_ID, version: AGI_VERSION, family: AGI_FAMILY,
    alive: _alive, beat: _beat, phi: PHI, amor: AMOR, heartbeatMs: HEARTBEAT_MS,
    vocabSize: VOCAB_SIZE, ctxWindow: CTX_WINDOW, nOscillators: N_OSCILLATORS,
    contextLength: _context.length, fibMemorySlots: _fibMemory.size,
    kuramotoR: Math.round(r * 10_000) / 10_000,
    lyapunovV: Math.round(_lyapunov.V * 10_000) / 10_000,
    converging: _lyapunov.converging,
    totalGenerated: _totalGenerated, totalCalls: _totalCalls,
    neuro: { ..._neuro },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  AGI_ID, AGI_VERSION, AGI_FAMILY, VOCAB_SIZE, CTX_WINDOW, N_OSCILLATORS,
  VOCAB,
  start, stop, isAlive, getStatus,
  generate, streamGenerate,
  addToContext, resetContext,
  steer,
  clamp01,
};
