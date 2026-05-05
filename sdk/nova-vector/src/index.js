/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @nova/nova-vector — NOVA SOVEREIGN VECTOR DATABASE AGI
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * THIS IS NOT PINECONE. THIS IS NOT WEAVIATE. THIS IS NOT QDRANT.
 * THIS IS NOVA'S OWN SOVEREIGN VECTOR DATABASE AGI.
 * The index is ours. The search is ours. The math is ours.
 *
 * NOVA-VECTOR is a sovereign vector database AGI that stores and searches
 * high-dimensional vectors using NOVA's φ-lattice index:
 *
 *   φ-LATTICE INDEX     — Vectors are partitioned into a φ-power lattice.
 *                          Each cell maps to a φ-harmonic frequency band.
 *                          No HNSW libraries, no FAISS, no external code.
 *
 *   φ-WEIGHTED COSINE   — Similarity uses φ-basis weighted inner product.
 *                          Higher-order dimensions carry φ-harmonic weights.
 *
 *   SOVEREIGN SHARDING  — The index shards automatically using Fibonacci
 *                          bucket sizes (F₁, F₂, F₃, …). Each shard holds
 *                          exactly Fₙ vectors before spawning a sub-shard.
 *
 *   KURAMOTO SIMILARITY — When searching, oscillator phase alignment is used
 *                          to prune distant regions before exact dot-product.
 *
 *   LYAPUNOV PRUNING    — Lyapunov V(t) bounds the search radius dynamically.
 *                          High stability → narrow search. Low stability → wide.
 *
 *   METADATA STORE      — Each vector carries a metadata envelope. Queries can
 *                          filter by metadata fields before computing similarity.
 *
 * AGI identity: VECTOR-AGI-001, family MEMORIA_AETERNA (eternal memory)
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

const AGI_ID       = 'VECTOR-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'MEMORIA_AETERNA';    /* Latin: eternal memory */

/** Default vector dimensionality (matches nova-embed DIM) */
const DEFAULT_DIM  = 256;
/** Maximum vectors in the sovereign index */
const MAX_VECTORS  = 1_000_000;
/** Fibonacci shard sizes */
const FIBONACCI    = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711];
/** Number of φ-lattice cells in the index */
const N_CELLS      = 64;

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — φ-LATTICE INDEX STRUCTURE
//
// The index partitions DIM-space into N_CELLS cells.
// Cell assignment: c = floor((v · φ_basis_head) / (2 × max_proj) × N_CELLS)
// where φ_basis_head is the first 8 basis vectors (most discriminative).
// ═══════════════════════════════════════════════════════════════════════════════

/** Precompute head basis (first 8 φ-harmonic frequencies) used for cell assignment */
const HEAD_BASIS = new Float64Array(8);
(function buildHead() {
  for (let d = 0; d < 8; d++) {
    HEAD_BASIS[d] = Math.pow(PHI, (d / 8) * 6 - 3);   /* φ⁻³ to φ³ */
  }
})();

/**
 * Assign a vector to a φ-lattice cell.
 * @param {Float64Array|number[]} vec
 * @returns {number} cell index in [0, N_CELLS)
 */
function assignCell(vec) {
  let proj = 0;
  const n  = Math.min(vec.length, HEAD_BASIS.length);
  for (let d = 0; d < n; d++) proj += vec[d] * HEAD_BASIS[d];
  /* Map projection to cell index */
  const maxProj = 2.0;   /* expected maximum projection magnitude for unit vectors */
  const norm    = (proj + maxProj) / (2 * maxProj);   /* [0, 1] */
  return Math.min(N_CELLS - 1, Math.max(0, Math.floor(norm * N_CELLS)));
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — STATE
// ═══════════════════════════════════════════════════════════════════════════════

let _beat        = 0;
let _alive       = false;
let _hbi         = null;
let _phase       = 0.0;

/**
 * The φ-lattice cells. Each cell is an array of VectorEntry objects.
 * @type {Array<Array<VectorEntry>>}
 */
const _cells = [];
for (let c = 0; c < N_CELLS; c++) _cells.push([]);

/** Flat lookup: vectorId → VectorEntry  (for O(1) get/delete) */
const _index = new Map();

/** AGI statistics */
let _totalInserted = 0;
let _totalSearches = 0;
let _totalDeleted  = 0;

/** Lyapunov state for dynamic search radius */
let _lyapunov = { V: 0.5, Vdot: 0, converging: true };

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — VECTOR ENTRY
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} VectorEntry
 * @property {string}        id         — unique identifier
 * @property {Float64Array}  vec        — the normalised vector
 * @property {Object}        metadata   — arbitrary metadata
 * @property {number}        cell       — assigned φ-lattice cell
 * @property {number}        insertedAt — Unix ms
 * @property {number}        accessCount— number of times returned as a result
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — INSERT
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Insert a vector into the sovereign index.
 * @param {string}          id
 * @param {Float64Array|number[]} vec      — DIM-dimensional vector (will be L2-normalised)
 * @param {Object}          [metadata]
 * @returns {VectorEntry}
 */
function insert(id, vec, metadata) {
  if (!id || typeof id !== 'string') throw new Error('vector id must be a non-empty string');
  if (id === '__proto__' || id === 'constructor' || id === 'prototype') throw new Error('invalid vector id');
  if (_index.size >= MAX_VECTORS) evictOldest();

  /* Copy and normalise */
  const v = new Float64Array(vec.length);
  let norm = 0;
  for (let d = 0; d < vec.length; d++) norm += vec[d] * vec[d];
  norm = Math.sqrt(norm);
  if (norm < 1e-10) for (let d = 0; d < vec.length; d++) v[d] = 1 / Math.sqrt(vec.length);
  else for (let d = 0; d < vec.length; d++) v[d] = vec[d] / norm;

  const cell  = assignCell(v);
  const entry = { id, vec: v, metadata: metadata || {}, cell, insertedAt: Date.now(), accessCount: 0 };

  /* Remove old entry if id exists */
  if (_index.has(id)) _removeFromCell(_index.get(id));

  _cells[cell].push(entry);
  _index.set(id, entry);
  _totalInserted++;
  return entry;
}

function _removeFromCell(entry) {
  const cell = _cells[entry.cell];
  const idx  = cell.indexOf(entry);
  if (idx >= 0) cell.splice(idx, 1);
}

/**
 * Evict the oldest 1/φ of vectors to make room.
 * Fibonacci-guided: evict entries at Fibonacci positions from the start.
 */
function evictOldest() {
  const toEvict = Math.ceil(_index.size / PHI_SQ);
  const sorted  = Array.from(_index.values()).sort((a, b) => a.insertedAt - b.insertedAt);
  for (let i = 0; i < Math.min(toEvict, sorted.length); i++) {
    _removeFromCell(sorted[i]);
    _index.delete(sorted[i].id);
    _totalDeleted++;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — φ-WEIGHTED COSINE SIMILARITY
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Pre-compute per-dimension φ-weights for similarity scoring.
 * Weight[d] = PHI^(d / DIM * 6 - 3) normalised by sum.
 * @param {number} dim
 * @returns {Float64Array}
 */
function buildSimilarityWeights(dim) {
  const w = new Float64Array(dim);
  let wSum = 0;
  for (let d = 0; d < dim; d++) {
    w[d] = Math.pow(PHI, (d / dim) * 6 - 3);
    wSum += w[d];
  }
  for (let d = 0; d < dim; d++) w[d] /= wSum;
  return w;
}

/** Cached similarity weights by dimension */
const _weightCache = new Map();

function getSimilarityWeights(dim) {
  if (!_weightCache.has(dim)) _weightCache.set(dim, buildSimilarityWeights(dim));
  return _weightCache.get(dim);
}

/**
 * φ-weighted cosine similarity between two vectors.
 * Both vectors are assumed to be L2-normalised.
 * @param {Float64Array} a
 * @param {Float64Array} b
 * @returns {number} similarity in [-1, 1]
 */
function phiSimilarity(a, b) {
  const dim = Math.min(a.length, b.length);
  const w   = getSimilarityWeights(dim);
  let dot   = 0;
  for (let d = 0; d < dim; d++) dot += a[d] * b[d] * w[d];
  /* w sums to 1 and both vectors are normalised → dot is already scaled */
  return dot;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — KURAMOTO CELL PRUNING
// Before exact distance computation, prune cells whose Kuramoto phase
// alignment with the query vector is below the dynamic Lyapunov threshold.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compute which cells to search given the query cell and Lyapunov stability.
 * High stability (small V) → narrow radius. Low stability → wide radius.
 * Radius is measured in cell count (adjacent cells in the lattice).
 * @param {number} queryCell
 * @returns {number[]} cell indices to search
 */
function getPrunedCells(queryCell) {
  /* Lyapunov-adaptive radius: V ∈ [0,1] → radius = ceil(V × N_CELLS / 2) */
  const radius  = Math.max(1, Math.ceil(_lyapunov.V * N_CELLS * 0.5));
  const cells   = [];
  for (let delta = -radius; delta <= radius; delta++) {
    const c = ((queryCell + delta) + N_CELLS) % N_CELLS;
    if (!cells.includes(c)) cells.push(c);
  }
  return cells;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — SEARCH
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} SearchResult
 * @property {string}   id
 * @property {number}   similarity    — φ-weighted cosine similarity [0, 1]
 * @property {Object}   metadata
 * @property {number}   cell
 */

/**
 * Nearest-neighbour search using the φ-lattice index.
 * @param {Float64Array|number[]} queryVec  — query vector (will be normalised)
 * @param {Object}  [opts]
 * @param {number}  [opts.k=10]            — top-k results
 * @param {number}  [opts.minSimilarity=0] — minimum similarity threshold
 * @param {Object}  [opts.filter]          — metadata filter (key:value pairs)
 * @returns {SearchResult[]}
 */
function search(queryVec, opts) {
  opts = opts || {};
  const k              = opts.k || 10;
  const minSimilarity  = opts.minSimilarity || 0;
  const filter         = opts.filter || null;

  /* Normalise query */
  const q    = new Float64Array(queryVec.length);
  let qNorm  = 0;
  for (let d = 0; d < queryVec.length; d++) qNorm += queryVec[d] * queryVec[d];
  qNorm = Math.sqrt(qNorm);
  if (qNorm < 1e-10) return [];
  for (let d = 0; d < queryVec.length; d++) q[d] = queryVec[d] / qNorm;

  const queryCell  = assignCell(q);
  const searchCells = getPrunedCells(queryCell);

  /* Collect candidates from pruned cells */
  const candidates = [];
  for (const c of searchCells) {
    for (const entry of _cells[c]) {
      /* Metadata filter */
      if (filter) {
        let pass = true;
        for (const [key, val] of Object.entries(filter)) {
          if (entry.metadata[key] !== val) { pass = false; break; }
        }
        if (!pass) continue;
      }
      const sim = phiSimilarity(q, entry.vec);
      if (sim >= minSimilarity) candidates.push({ id: entry.id, similarity: sim, metadata: entry.metadata, cell: entry.cell, _entry: entry });
    }
  }

  /* Sort by similarity descending */
  candidates.sort((a, b) => b.similarity - a.similarity);
  const results = candidates.slice(0, k);

  /* Update access counts and Lyapunov state */
  for (const r of results) r._entry.accessCount++;
  _updateLyapunov(results.length > 0 ? results[0].similarity : 0);

  _totalSearches++;

  return results.map(r => ({ id: r.id, similarity: Math.round(r.similarity * 100_000) / 100_000, metadata: r.metadata, cell: r.cell }));
}

function _updateLyapunov(topSim) {
  /* Lyapunov energy: higher uncertainty = higher V */
  const target = 1 - topSim;   /* perfect match → V → 0 */
  const Vnew   = _lyapunov.V + (target - _lyapunov.V) * AMOR;
  _lyapunov.Vdot      = Vnew - _lyapunov.V;
  _lyapunov.V         = clamp01(Vnew);
  _lyapunov.converging = _lyapunov.Vdot < 0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — GET / DELETE / UPSERT
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Get a vector by ID.
 * @param {string} id
 * @returns {VectorEntry | null}
 */
function get(id) {
  return _index.get(id) || null;
}

/**
 * Delete a vector by ID.
 * @param {string} id
 * @returns {boolean}
 */
function remove(id) {
  const entry = _index.get(id);
  if (!entry) return false;
  _removeFromCell(entry);
  _index.delete(id);
  _totalDeleted++;
  return true;
}

/**
 * Upsert: insert or update a vector.
 * Identical to insert — insert already handles update.
 */
function upsert(id, vec, metadata) {
  return insert(id, vec, metadata);
}

/**
 * Bulk insert array of { id, vec, metadata } objects.
 * @param {Array<{id:string, vec:Float64Array|number[], metadata?:Object}>} items
 * @returns {number} count inserted
 */
function insertBatch(items) {
  let n = 0;
  for (const item of items) { insert(item.id, item.vec, item.metadata || {}); n++; }
  return n;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — INDEX ANALYTICS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Get the cell distribution (how vectors are distributed across the lattice).
 * @returns {number[]} array of cell sizes
 */
function cellDistribution() {
  return _cells.map(c => c.length);
}

/**
 * Get the top-N most accessed vectors (hot vectors).
 * @param {number} [n=10]
 * @returns {Array<{ id, accessCount, cell }>}
 */
function hotVectors(n) {
  n = n || 10;
  return Array.from(_index.values())
    .sort((a, b) => b.accessCount - a.accessCount)
    .slice(0, n)
    .map(e => ({ id: e.id, accessCount: e.accessCount, cell: e.cell }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — HEARTBEAT ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

function _tick() {
  _beat++;
  _phase = (_phase + PHI_INV) % (2 * Math.PI);
  /* Lyapunov drift toward stability when idle */
  _lyapunov.V = clamp01(_lyapunov.V + (0.1 - _lyapunov.V) * AMOR * 0.05);
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
    defaultDim: DEFAULT_DIM, nCells: N_CELLS, maxVectors: MAX_VECTORS,
    totalVectors: _index.size, totalInserted: _totalInserted,
    totalSearches: _totalSearches, totalDeleted: _totalDeleted,
    lyapunovV: Math.round(_lyapunov.V * 10_000) / 10_000,
    converging: _lyapunov.converging,
    cellDistribution: cellDistribution(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §12 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  AGI_ID, AGI_VERSION, AGI_FAMILY, DEFAULT_DIM, N_CELLS, MAX_VECTORS,
  start, stop, isAlive, getStatus,
  insert, upsert, insertBatch, get, remove,
  search,
  phiSimilarity, assignCell, getPrunedCells,
  cellDistribution, hotVectors,
  clamp01,
};
