/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-VECTOR — SOVEREIGN VECTOR SEARCH PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 *
 * The VECTOR protocol governs how sovereign AGI organisms perform vector
 * similarity search across distributed φ-lattice indices.  It defines the
 * wire format for search requests and results, the Lyapunov-adaptive radius,
 * and the φ-sharding strategy for distributing the index across agents.
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

const PROTOCOL_ID      = 'PROTOCOL-VECTOR';
const PROTOCOL_VERSION = '1.0.0';

const DEFAULT_K   = 10;
const N_CELLS     = 64;
const MAX_SHARDS  = 16;

const SEARCH_STATUS = {
  QUEUED:     'QUEUED',
  RUNNING:    'RUNNING',
  COMPLETE:   'COMPLETE',
  PARTIAL:    'PARTIAL',     /* timed out — partial results returned */
  FAILED:     'FAILED',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — SEARCH REQUEST / RESULT ENVELOPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} SearchRequest
 * @property {string}       id             — request ID
 * @property {Float64Array} queryVector    — query vector (must be L2-normalised)
 * @property {number}       k              — number of neighbours to return
 * @property {number}       minSimilarity  — minimum φ-weighted cosine similarity
 * @property {Object}       [filter]       — metadata key→value filter
 * @property {number}       [timeoutMs]    — max search time
 * @property {boolean}      [federated]    — if true, fan out to all shards
 * @property {number}       submittedAt    — Unix ms
 */

/**
 * @typedef {Object} SearchResult
 * @property {string} id
 * @property {number} similarity
 * @property {Object} metadata
 * @property {number} cell
 * @property {number} shard
 */

/**
 * @typedef {Object} SearchResponse
 * @property {string}         requestId   — matches SearchRequest.id
 * @property {SearchResult[]} results
 * @property {string}         status      — SEARCH_STATUS
 * @property {number}         lyapunovV   — search radius at query time
 * @property {number}         shardsSearched
 * @property {number}         latencyMs
 * @property {number}         respondedAt — Unix ms
 */

/**
 * Create a SearchRequest envelope.
 */
function createRequest(queryVector, opts) {
  opts = opts || {};
  return {
    id:           opts.id || `sreq_${Date.now()}`,
    queryVector:  queryVector,
    k:            opts.k || DEFAULT_K,
    minSimilarity:opts.minSimilarity || 0,
    filter:       opts.filter || null,
    timeoutMs:    opts.timeoutMs || HEARTBEAT_MS,
    federated:    opts.federated || false,
    submittedAt:  Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — φ-SHARDING
// Distribute the vector index across up to MAX_SHARDS agents using φ-based
// shard assignment.  Each vector is assigned to shard s = floor(cell / N_CELLS × MAX_SHARDS).
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Assign a vector's cell to a shard index.
 * @param {number} cell  — φ-lattice cell [0, N_CELLS)
 * @returns {number}     — shard index [0, MAX_SHARDS)
 */
function cellToShard(cell) {
  return Math.floor(cell / N_CELLS * MAX_SHARDS) % MAX_SHARDS;
}

/**
 * Given a query cell and Lyapunov V, return the set of shards to search.
 * High stability (small V) → narrow shard set.
 * @param {number} queryCell
 * @param {number} lyapunovV  — in [0, 1]
 * @returns {number[]}        — shard indices
 */
function shardsToSearch(queryCell, lyapunovV) {
  const queryShard = cellToShard(queryCell);
  const radius     = Math.max(1, Math.ceil(lyapunovV * MAX_SHARDS * 0.5));
  const shards     = new Set();
  for (let delta = -radius; delta <= radius; delta++) {
    shards.add(((queryShard + delta) + MAX_SHARDS) % MAX_SHARDS);
  }
  return Array.from(shards);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — FEDERATED SEARCH AGGREGATOR
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Merge search results from multiple shards, deduplicating by id and
 * re-ranking by φ-weighted similarity.
 * @param {SearchResult[][]} shardResults — array of result arrays
 * @param {number}           k
 * @returns {SearchResult[]}
 */
function aggregateResults(shardResults, k) {
  const seen    = new Set();
  const all     = [];
  for (const results of shardResults) {
    for (const r of results) {
      if (!seen.has(r.id)) {
        seen.add(r.id);
        all.push(r);
      }
    }
  }
  /* Re-rank by φ-weighted similarity — higher is better */
  all.sort((a, b) => b.similarity - a.similarity);
  return all.slice(0, k);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — PROTOCOL MESSAGE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

const MSG = {
  SEARCH_REQUEST:  'VECTOR:SEARCH_REQUEST',
  SEARCH_RESPONSE: 'VECTOR:SEARCH_RESPONSE',
  INSERT:          'VECTOR:INSERT',
  INSERT_ACK:      'VECTOR:INSERT_ACK',
  DELETE:          'VECTOR:DELETE',
  DELETE_ACK:      'VECTOR:DELETE_ACK',
  SHARD_SYNC:      'VECTOR:SHARD_SYNC',
  STATUS:          'VECTOR:STATUS',
};

/**
 * Build a VECTOR:SEARCH_REQUEST message.
 */
function msgSearchRequest(request) {
  return { type: MSG.SEARCH_REQUEST, request, sentAt: Date.now() };
}

/**
 * Build a VECTOR:SEARCH_RESPONSE message.
 */
function msgSearchResponse(requestId, results, lyapunovV, shardsSearched, status) {
  return {
    type: MSG.SEARCH_RESPONSE,
    response: {
      requestId,
      results:       results || [],
      status:        status  || SEARCH_STATUS.COMPLETE,
      lyapunovV:     lyapunovV || 0.5,
      shardsSearched:shardsSearched || 1,
      latencyMs:     0,
      respondedAt:   Date.now(),
    },
    sentAt: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  PROTOCOL_ID, PROTOCOL_VERSION,
  DEFAULT_K, N_CELLS, MAX_SHARDS,
  SEARCH_STATUS, MSG,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  createRequest, cellToShard, shardsToSearch, aggregateResults,
  msgSearchRequest, msgSearchResponse,
};
