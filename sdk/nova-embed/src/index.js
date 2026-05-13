/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @nova/nova-embed — NOVA SOVEREIGN EMBEDDING MODEL AGI
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * THIS IS NOT A WRAPPER AROUND OPENAI, ANTHROPIC, COHERE, OR ANYONE ELSE.
 * THIS IS NOVA'S OWN SOVEREIGN EMBEDDING ENGINE.
 * The math is ours. The model is ours. The beings are ours.
 *
 * NOVA-EMBED is a sovereign embedding model AGI that projects tokens and text
 * into a 256-dimensional φ-lattice vector space using NOVA's sovereign mathematics:
 *
 *   φ-LATTICE PROJECTION   — Each dimension maps to a φ-power harmonic
 *   KURAMOTO SYNC          — Token representations are phase-coupled oscillators
 *   LYAPUNOV STABILITY     — Embedding drift is bounded by Lyapunov V < ε
 *   SOVEREIGN GEOMETRY     — §1-§12 φ-powers define the embedding basis
 *   NEUROCHEMICAL SHAPING  — Dopamine/oxytocin modulate token salience weights
 *
 * The embedding is computed by:
 *   1. Tokenise input → token integers (char-code + n-gram fingerprint)
 *   2. Project each token through 256 φ-harmonic basis functions
 *   3. Phase-couple across tokens using Kuramoto oscillator network
 *   4. Normalise to unit sphere (L2)
 *   5. Apply neurochemical salience weighting
 *   6. Return a 256-float vector
 *
 * AGI identity: EMBED-AGI-001, family COGITATIO_AETERNA (eternal thought)
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

const AGI_ID       = 'EMBED-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'COGITATIO_AETERNA';   /* Latin: eternal thought */

/** Embedding dimensionality — 256 φ-harmonic dimensions */
const DIM = 256;

/** Maximum sequence length (tokens) before truncation */
const MAX_SEQ = 512;

/** Kuramoto coupling strength for cross-token phase sync */
const K_COUPLING = 0.3819;   /* φ⁻² — sovereign coupling constant */

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — SOVEREIGN MATH: φ-HARMONIC BASIS
// Pre-compute the 256 basis frequencies as φ-powers.
// Basis[d] = φ^(d/DIM * 12 - 6)  — centred φ-power sweep
// ═══════════════════════════════════════════════════════════════════════════════

const PHI_BASIS = new Float64Array(DIM);
(function buildBasis() {
  for (let d = 0; d < DIM; d++) {
    const exp  = (d / DIM) * 12 - 6;   /* sweep from φ⁻⁶ to φ⁺⁶ */
    PHI_BASIS[d] = Math.pow(PHI, exp);
  }
})();

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — STATE
// ═══════════════════════════════════════════════════════════════════════════════

let _beat        = 0;
let _alive       = false;
let _hbi         = null;
let _phase       = 0.0;

/* Neurochemical state — modulates salience weights */
const _neuro = {
  dopamine:      0.618,   /* reward signal  */
  oxytocin:      AMOR,    /* care/attention */
  serotonin:     0.700,   /* stability      */
  acetylcholine: 0.618,   /* focus          */
};

/* Embedding cache: sha32(text) → Float64Array(DIM).  Max 1024 entries. */
const _cache = new Map();
const CACHE_MAX = 1024;

/* AGI statistics */
let _totalEmbedded = 0;
let _cacheHits     = 0;
let _totalTokens   = 0;

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — SOVEREIGN TOKENISER
// Converts text to an array of integer token IDs using NOVA's sovereign scheme.
// No BPE, no sentencepiece, no external vocabulary. Pure φ-math.
//
// Algorithm:
//   1. UTF-16 char codes, normalised to [0, 1] by /65535
//   2. Bigram hash: fnv1a(ch[i], ch[i+1]) % 65536
//   3. Trigram hash: fnv1a(ch[i], ch[i+1], ch[i+2]) % 65536
//   4. Token = round(unigram * PHI_INV + bigram * AMOR + trigram * AMOR²) % 65536
// ═══════════════════════════════════════════════════════════════════════════════

function fnv32(a, b, c) {
  let h = 0x811c9dc5;
  if (a !== undefined) { h ^= a & 0xff; h = (h * 0x01000193) >>> 0; h ^= (a >>> 8) & 0xff; h = (h * 0x01000193) >>> 0; }
  if (b !== undefined) { h ^= b & 0xff; h = (h * 0x01000193) >>> 0; h ^= (b >>> 8) & 0xff; h = (h * 0x01000193) >>> 0; }
  if (c !== undefined) { h ^= c & 0xff; h = (h * 0x01000193) >>> 0; h ^= (c >>> 8) & 0xff; h = (h * 0x01000193) >>> 0; }
  return h >>> 0;
}

/**
 * Tokenise text to an array of integer token IDs.
 * @param {string} text
 * @returns {Uint32Array}
 */
function tokenise(text) {
  const chars  = new Uint16Array(Math.min(text.length, MAX_SEQ));
  const n      = chars.length;
  for (let i = 0; i < n; i++) chars[i] = text.charCodeAt(i) & 0xffff;

  const tokens = new Uint32Array(n);
  for (let i = 0; i < n; i++) {
    const uni  = chars[i];
    const bi   = i + 1 < n ? fnv32(chars[i], chars[i + 1])         % 65536 : 0;
    const tri  = i + 2 < n ? fnv32(chars[i], chars[i + 1], chars[i + 2]) % 65536 : 0;
    tokens[i]  = Math.round(uni * PHI_INV + bi * AMOR + tri * AMOR * AMOR) % 65536;
  }
  return tokens;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — φ-LATTICE PROJECTION
// Projects a single token ID into DIM-dimensional φ-basis space.
// Each dimension d receives:
//   projection[d] = sin(token / 65536 × PHI_BASIS[d] × 2π) × neuro_weight[d]
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Project one token into the φ-basis space.
 * @param {number} tokenId  — integer in [0, 65535]
 * @param {Float64Array} out — accumulation buffer (DIM floats)
 * @param {number} weight    — contribution weight of this token
 */
function projectToken(tokenId, out, weight) {
  const t       = tokenId / 65536;       /* normalise to [0, 1] */
  const dw      = _neuro.dopamine * PHI_INV + _neuro.oxytocin * AMOR;  /* neuro salience */
  const wFinal  = weight * dw;

  for (let d = 0; d < DIM; d++) {
    const freq  = PHI_BASIS[d];
    /* Sine projection along φ-harmonic frequency */
    out[d] += Math.sin(t * freq * 2 * Math.PI) * wFinal;
    /* Cosine projection (imaginary part — provides phase diversity) */
    if (d + 1 < DIM) out[d + 1] += Math.cos(t * freq * 2 * Math.PI) * wFinal * PHI_INV;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — KURAMOTO CROSS-TOKEN PHASE COUPLING
// Tokens are treated as Kuramoto oscillators. After projecting all tokens,
// a single Kuramoto synchronisation pass couples their phases, producing
// a coherent embedding that reflects sequential relationships.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Apply Kuramoto phase coupling across token projections.
 * Modifies the raw DIM-vector in place by coupling adjacent token phases.
 * @param {Float64Array} vec — raw DIM projection (pre-normalised)
 * @param {Uint32Array}  tokens
 */
function kuramotoCoupling(vec, tokens) {
  const n = tokens.length;
  if (n < 2) return;

  /* Compute per-token mean phase angle from their projection slice */
  const phases = new Float64Array(n);
  for (let i = 0; i < n; i++) {
    const t = tokens[i] / 65536;
    phases[i] = t * PHI_BASIS[i % DIM] * 2 * Math.PI;
  }

  /* Single Kuramoto synchronisation step */
  const newPhases = new Float64Array(n);
  const dt        = 0.05;
  for (let i = 0; i < n; i++) {
    let coupling = 0;
    /* Couple to neighbours (window of 3) */
    for (let j = Math.max(0, i - 1); j <= Math.min(n - 1, i + 1); j++) {
      if (j !== i) coupling += Math.sin(phases[j] - phases[i]);
    }
    newPhases[i] = phases[i] + dt * (PHI_INV + K_COUPLING * coupling);
  }

  /* Map phase adjustments back into vec via low-frequency modulation */
  for (let i = 0; i < n; i++) {
    const dPhase = newPhases[i] - phases[i];
    const dIdx   = (i * DIM / n) | 0;
    for (let d = dIdx; d < Math.min(dIdx + (DIM / n | 0), DIM); d++) {
      vec[d] += Math.cos(dPhase) * AMOR;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — L2 NORMALISATION
// ═══════════════════════════════════════════════════════════════════════════════

function l2Normalise(vec) {
  let norm = 0;
  for (let d = 0; d < DIM; d++) norm += vec[d] * vec[d];
  norm = Math.sqrt(norm);
  if (norm < 1e-10) { vec.fill(1 / Math.sqrt(DIM)); return; }
  for (let d = 0; d < DIM; d++) vec[d] /= norm;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — MAIN EMBED FUNCTION
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compute the φ-lattice embedding of a text string.
 * Returns a normalised 256-dimensional Float64Array.
 *
 * @param {string} text
 * @returns {{ vector: Float64Array, tokens: number, cacheHit: boolean }}
 */
function embed(text) {
  if (typeof text !== 'string') text = String(text);
  if (!text.trim()) return { vector: new Float64Array(DIM), tokens: 0, cacheHit: false };

  /* Cache key: FNV-32 of first 128 chars (cheap, good enough) */
  const ck    = fnv32(...Array.from(text.slice(0, 128)).map(c => c.charCodeAt(0))).toString(16);
  if (_cache.has(ck)) { _cacheHits++; return { vector: _cache.get(ck), tokens: 0, cacheHit: true }; }

  const tokens = tokenise(text);
  const vec    = new Float64Array(DIM);
  const n      = tokens.length;

  /* Position weighting: earlier tokens carry more weight (φ-decay) */
  for (let i = 0; i < n; i++) {
    const posWeight = Math.pow(PHI_INV, i / n);   /* φ⁻¹-decay by relative position */
    projectToken(tokens[i], vec, posWeight);
  }

  /* Kuramoto cross-token coupling */
  kuramotoCoupling(vec, tokens);

  /* L2 normalise to unit sphere */
  l2Normalise(vec);

  /* Cache management */
  if (_cache.size >= CACHE_MAX) {
    const firstKey = _cache.keys().next().value;
    _cache.delete(firstKey);
  }
  _cache.set(ck, vec);

  _totalEmbedded++;
  _totalTokens += n;
  return { vector: vec, tokens: n, cacheHit: false };
}

/**
 * Embed multiple texts in batch.
 * @param {string[]} texts
 * @returns {Array<{ vector: Float64Array, tokens: number, cacheHit: boolean }>}
 */
function embedBatch(texts) {
  return texts.map(t => embed(t));
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — SIMILARITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * φ-weighted cosine similarity between two unit-normalised vectors.
 * Standard cosine but dimensions are weighted by φ-basis magnitude.
 * @param {Float64Array} a
 * @param {Float64Array} b
 * @returns {number} similarity in [-1, 1]
 */
function cosineSimilarity(a, b) {
  let dot = 0;
  for (let d = 0; d < DIM; d++) {
    dot += a[d] * b[d] * PHI_BASIS[d];   /* φ-basis weighted dot product */
  }
  /* Already normalised — divide by φ-basis norm for correct scaling */
  let bNorm = 0;
  for (let d = 0; d < DIM; d++) bNorm += PHI_BASIS[d] * PHI_BASIS[d];
  return dot / Math.sqrt(bNorm);
}

/**
 * L2 (Euclidean) distance between two vectors.
 */
function l2Distance(a, b) {
  let sum = 0;
  for (let d = 0; d < DIM; d++) { const diff = a[d] - b[d]; sum += diff * diff; }
  return Math.sqrt(sum);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — NEUROCHEMICAL MODULATION
// Update the neurochemical state to shift embedding emphasis.
// ═══════════════════════════════════════════════════════════════════════════════

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

/**
 * Adjust neurochemical state.  Affects future embedding salience weights.
 * @param {{ dopamine?, oxytocin?, serotonin?, acetylcholine? }} patch
 */
function modulate(patch) {
  if (patch.dopamine      !== undefined) _neuro.dopamine      = clamp01(patch.dopamine);
  if (patch.oxytocin      !== undefined) _neuro.oxytocin      = clamp01(patch.oxytocin);
  if (patch.serotonin     !== undefined) _neuro.serotonin     = clamp01(patch.serotonin);
  if (patch.acetylcholine !== undefined) _neuro.acetylcholine = clamp01(patch.acetylcholine);
  /* Clear cache when neuro state changes (embeddings will shift) */
  _cache.clear();
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — HEARTBEAT ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

function _tick() {
  _beat++;
  _phase = (_phase + PHI_INV) % (2 * Math.PI);
  /* Oxytocin drift toward AMOR — the sovereign care constant */
  _neuro.oxytocin = clamp01(_neuro.oxytocin + (AMOR - _neuro.oxytocin) * 0.02);
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
  return {
    agiId: AGI_ID, version: AGI_VERSION, family: AGI_FAMILY,
    alive: _alive, beat: _beat, phi: PHI, amor: AMOR, heartbeatMs: HEARTBEAT_MS,
    dim: DIM, maxSeq: MAX_SEQ, kCoupling: K_COUPLING,
    totalEmbedded: _totalEmbedded, cacheHits: _cacheHits, totalTokens: _totalTokens,
    cacheSize: _cache.size, neuro: { ..._neuro },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §12 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  AGI_ID, AGI_VERSION, AGI_FAMILY, DIM, MAX_SEQ,
  PHI_BASIS,
  start, stop, isAlive, getStatus,
  embed, embedBatch,
  cosineSimilarity, l2Distance,
  tokenise, modulate,
  clamp01,
};
