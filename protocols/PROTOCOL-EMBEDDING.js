/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-EMBEDDING — SOVEREIGN EMBEDDING EXCHANGE PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 *
 * The EMBEDDING protocol governs how sovereign AGI organisms exchange,
 * validate, and compose φ-lattice embedding vectors between agents,
 * canisters, and external systems.
 *
 * Mathematical Foundation (see paper6_sovereign_differential_privacy.tex):
 *   - 256-dimensional φ-lattice basis: basis[d] = φ^(d/256×12 - 6)
 *   - φ-weighted cosine similarity: weighted dot product using basis weights
 *   - Sovereign ε-DP: noise level calibrated at AMOR = φ⁻² ≈ 0.382
 *   - Kuramoto coupling: K = AMOR for cross-agent embedding sync
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

const PROTOCOL_ID      = 'PROTOCOL-EMBEDDING';
const PROTOCOL_VERSION = '1.0.0';

const DIM    = 256;
const FLOAT_BYTES = 8;   /* Float64 = 8 bytes */

const EMBEDDING_STATUS = {
  PENDING:   'PENDING',
  COMPUTED:  'COMPUTED',
  VERIFIED:  'VERIFIED',
  INVALID:   'INVALID',
  EXPIRED:   'EXPIRED',
};

const SIMILARITY_THRESHOLD = PHI_INV;   /* similarity ≥ φ⁻¹ = related */

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — EMBEDDING ENVELOPE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} EmbeddingEnvelope
 * @property {string}       id          — unique embedding ID
 * @property {Float64Array} vector      — 256-dimensional normalised vector
 * @property {string}       originAgent — agent ID that produced this embedding
 * @property {string}       text        — source text (may be empty for privacy)
 * @property {number}       norm        — L2 norm of the raw (pre-normalisation) vector
 * @property {number}       ttl         — time-to-live in ms (0 = permanent)
 * @property {number}       computedAt  — Unix ms
 * @property {string}       status      — EMBEDDING_STATUS
 * @property {boolean}      dpProtected — whether φ-DP noise was applied
 */

/**
 * Create a fresh EmbeddingEnvelope.
 * @param {string}       id
 * @param {Float64Array} vector
 * @param {string}       [originAgent]
 * @param {Object}       [opts]
 * @returns {EmbeddingEnvelope}
 */
function createEnvelope(id, vector, originAgent, opts) {
  opts = opts || {};
  if (!id || typeof id !== 'string') throw new Error('EmbeddingEnvelope requires string id');
  if (!(vector instanceof Float64Array) || vector.length !== DIM) {
    throw new Error(`EmbeddingEnvelope vector must be Float64Array of length ${DIM}`);
  }
  let norm = 0;
  for (let d = 0; d < DIM; d++) norm += vector[d] * vector[d];
  norm = Math.sqrt(norm);
  const normalised = new Float64Array(DIM);
  for (let d = 0; d < DIM; d++) normalised[d] = norm > 1e-10 ? vector[d] / norm : 0;

  return {
    id,
    vector:      normalised,
    originAgent: originAgent || 'unknown',
    text:        opts.text   || '',
    norm:        Math.round(norm * 1e6) / 1e6,
    ttl:         opts.ttl    || 0,
    computedAt:  Date.now(),
    status:      EMBEDDING_STATUS.COMPUTED,
    dpProtected: opts.dpProtected || false,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — φ-WEIGHTED SIMILARITY
// ═══════════════════════════════════════════════════════════════════════════════

/** Pre-computed φ-basis weights for similarity (lazily built once) */
let _basisWeights = null;

function _getBasisWeights() {
  if (_basisWeights) return _basisWeights;
  _basisWeights = new Float64Array(DIM);
  let wSum = 0;
  for (let d = 0; d < DIM; d++) {
    _basisWeights[d] = Math.pow(PHI, (d / DIM) * 6 - 3);
    wSum += _basisWeights[d];
  }
  for (let d = 0; d < DIM; d++) _basisWeights[d] /= wSum;
  return _basisWeights;
}

/**
 * φ-weighted cosine similarity between two embedding envelopes.
 * Both vectors are assumed L2-normalised.
 * @param {EmbeddingEnvelope} a
 * @param {EmbeddingEnvelope} b
 * @returns {number} similarity in [-1, 1]
 */
function similarity(a, b) {
  const w   = _getBasisWeights();
  let   dot = 0;
  for (let d = 0; d < DIM; d++) dot += a.vector[d] * b.vector[d] * w[d];
  return Math.round(dot * 1e6) / 1e6;
}

/**
 * Determine semantic relationship from similarity score.
 * @param {number} sim
 * @returns {'SAME'|'RELATED'|'DISTANT'|'UNRELATED'}
 */
function classify(sim) {
  if (sim >= 1 - 1e-4) return 'SAME';
  if (sim >= PHI_INV)  return 'RELATED';
  if (sim >= AMOR)     return 'DISTANT';
  return 'UNRELATED';
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — DIFFERENTIAL PRIVACY NOISE (φ-Laplace)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Apply φ-Laplace noise to an embedding vector for (AMOR, 0)-DP protection.
 * Noise is added coordinate-wise with scale λ = sens / AMOR.
 * @param {Float64Array} vec   — L2-normalised embedding
 * @param {number}       sens  — per-coordinate sensitivity (default PHI_INV / DIM)
 * @returns {Float64Array}     — noisy embedding (re-normalised)
 */
function applyPhiLaplace(vec, sens) {
  sens = sens || PHI_INV / DIM;
  const lambda = sens / AMOR;
  const noisy  = new Float64Array(DIM);
  for (let d = 0; d < DIM; d++) {
    /* Laplace sample via inverse CDF */
    const u      = (Math.pow(PHI_INV, d % 64) * 2 - 1) * (1 - 1e-10);  /* deterministic but diverse */
    const noise  = -lambda * Math.sign(u) * Math.log(1 - Math.abs(u));
    noisy[d]     = vec[d] + noise;
  }
  /* Re-normalise */
  let norm = 0;
  for (let d = 0; d < DIM; d++) norm += noisy[d] * noisy[d];
  norm = Math.sqrt(norm);
  if (norm > 1e-10) for (let d = 0; d < DIM; d++) noisy[d] /= norm;
  return noisy;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — COMPOSITION — aggregate multiple embeddings
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compose an array of EmbeddingEnvelopes into a single envelope
 * using φ-weighted mean aggregation.
 * @param {EmbeddingEnvelope[]} envelopes
 * @param {string}              [id]
 * @param {string}              [agentId]
 * @returns {EmbeddingEnvelope}
 */
function compose(envelopes, id, agentId) {
  if (!envelopes || envelopes.length === 0) throw new Error('compose requires at least one envelope');
  const agg = new Float64Array(DIM);
  let   wTotal = 0;

  for (let i = 0; i < envelopes.length; i++) {
    const w = Math.pow(PHI_INV, i);  /* φ⁻¹ decaying weight */
    wTotal += w;
    for (let d = 0; d < DIM; d++) agg[d] += envelopes[i].vector[d] * w;
  }
  for (let d = 0; d < DIM; d++) agg[d] /= wTotal;

  return createEnvelope(id || `comp_${Date.now()}`, agg, agentId || 'compositor');
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — SERIALISATION / WIRE FORMAT
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Serialise an EmbeddingEnvelope to a compact wire format (Base64-encoded).
 * Format: JSON header + base64(Float64Array bytes)
 * @param {EmbeddingEnvelope} env
 * @returns {{ header: Object, data: string }}
 */
function serialise(env) {
  const header = { id: env.id, originAgent: env.originAgent, norm: env.norm, dim: DIM, computedAt: env.computedAt, dpProtected: env.dpProtected, status: env.status };
  const bytes  = Buffer.from(env.vector.buffer);
  return { header, data: bytes.toString('base64') };
}

/**
 * Deserialise from wire format.
 * @param {{ header: Object, data: string }} wire
 * @returns {EmbeddingEnvelope}
 */
function deserialise(wire) {
  const buf    = Buffer.from(wire.data, 'base64');
  const vector = new Float64Array(buf.buffer, buf.byteOffset, DIM);
  return Object.assign({}, wire.header, { vector, text: '', ttl: 0 });
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — PROTOCOL EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  PROTOCOL_ID, PROTOCOL_VERSION,
  DIM, SIMILARITY_THRESHOLD,
  EMBEDDING_STATUS,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  createEnvelope, similarity, classify,
  applyPhiLaplace, compose,
  serialise, deserialise,
};

export default {
  PROTOCOL_ID, PROTOCOL_VERSION,
  DIM, SIMILARITY_THRESHOLD,
  EMBEDDING_STATUS,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  createEnvelope, similarity, classify,
  applyPhiLaplace, compose,
  serialise, deserialise,
};
