/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @nova/passex-agi — PASSENGER INTELLIGENCE AGI
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * PASSEX-AGI is the sovereign Passenger Intelligence engine.
 * It maintains an anonymised passenger graph, performs sub-500ms BFS connection
 * matching, routes VIP passengers with φ-priority uplift, and forecasts gate
 * flow using a Poisson arrival model.
 *
 * Four sovereign engines:
 *   PASSENGER_GRAPH     — Anonymised directed graph of passenger journeys
 *   BFS_MATCHER         — Sub-500ms BFS multi-hop connection matching
 *   VIP_ROUTER          — φ-priority VIP routing with preference override
 *   GATE_FLOW_PREDICTOR — Poisson λ-model gate arrival forecasting
 *
 * Heartbeat: 873ms (φ⁴ × Schumann — NOVA sovereign, not ICP)
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;  /* φ — golden ratio               */
const PHI_INV      = 0.6180339887498948482;  /* φ⁻¹ — coherence weight         */
const PHI_SQ       = 2.6180339887498948482;  /* φ² — VIP amplification         */
const AMOR         = 0.3819660112501051518;  /* φ⁻² — care constant            */
const HEARTBEAT_MS = 873;                    /* sovereign 873ms heartbeat      */
const AGI_ID       = 'PASSEX-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'VIATOR_AETERNA';      /* Latin: eternal traveller       */

/* BFS SLA: any connection match must complete under 500ms */
const BFS_SLA_MS   = 500;
/* Maximum BFS search depth (hops) */
const BFS_MAX_HOPS = 6;
/* Maximum passengers in the live graph */
const GRAPH_CAP    = 10_000;

/* Passenger tier classification */
const PAX_TIER = {
  STANDARD:  'STANDARD',
  FREQUENT:  'FREQUENT',
  ELITE:     'ELITE',
  VIP:       'VIP',
  SOVEREIGN: 'SOVEREIGN',   /* highest tier — φ² routing priority */
};

/* Gate status enum */
const GATE_STATUS = {
  OPEN:      'OPEN',
  BOARDING:  'BOARDING',
  CLOSED:    'CLOSED',
  DELAYED:   'DELAYED',
  DIVERTED:  'DIVERTED',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — STATE
// ═══════════════════════════════════════════════════════════════════════════════

let _beat  = 0;
let _alive = false;
let _hbi   = null;
let _phase = 0.0;

/*
 * PASSENGER GRAPH
 * adjacencyList: Map<nodeId, Set<nodeId>>   directed connections
 * nodeData:      Map<nodeId, NodeData>       node metadata (anonymised)
 * edgeData:      Map<edgeKey, EdgeData>      edge metadata (connection details)
 *
 * Privacy guarantee: nodeId is a one-way hash — never raw passenger PII.
 */
const _adjacencyList = new Map();   /* nodeId → Set<nodeId> */
const _nodeData      = new Map();   /* nodeId → NodeData    */
const _edgeData      = new Map();   /* `${from}:${to}` → EdgeData */

/* Gate registry */
const _gates = new Map();   /* gateId → GateState */

/* VIP priority queue (max-heap by priority score) */
let _vipQueue = [];

/* BFS cache: `${from}:${to}` → BFSResult — evicted every 34 beats */
const _bfsCache = new Map();

/* AGI statistics */
let _totalPax        = 0;
let _totalMatches    = 0;
let _slaBreaches     = 0;
let _vipRoutings     = 0;

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — UTILITY
// ═══════════════════════════════════════════════════════════════════════════════

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

/**
 * Lightweight FNV-1a 32-bit hash — used for anonymised node IDs.
 * Never expose raw PII.  Always hash before storing.
 * @param {string} str
 * @returns {string} 8-char hex
 */
function fnv1a(str) {
  let h = 0x811c9dc5;
  for (let i = 0; i < str.length; i++) {
    h ^= str.charCodeAt(i);
    h  = (h * 0x01000193) >>> 0;
  }
  return h.toString(16).padStart(8, '0');
}

/**
 * Anonymise a passenger identifier before inserting into the graph.
 * Combines a one-way hash with a salt derived from the current Fibonacci beat.
 * @param {string} rawId
 * @returns {string} anonymised node ID
 */
function anonymise(rawId) {
  /* Salt: beat-derived so the same rawId maps to different nodes across cycles */
  return 'pax_' + fnv1a(rawId + '_nova_salt_' + String(_beat % 987));
}

/**
 * Poisson probability mass: P(k | λ).
 */
function poissonPMF(lambda, k) {
  if (lambda <= 0) return k === 0 ? 1 : 0;
  let logP = -lambda + k * Math.log(lambda);
  for (let i = 2; i <= k; i++) logP -= Math.log(i);
  return Math.exp(logP);
}

/**
 * Poisson CDF: P(X ≤ k | λ) — probability of at most k arrivals.
 */
function poissonCDF(lambda, k) {
  let p = 0;
  for (let i = 0; i <= k; i++) p += poissonPMF(lambda, i);
  return Math.min(1, p);
}

/* φ-priority score for a passenger node (higher = more urgent routing) */
function priorityScore(nodeData) {
  const tierMul = {
    STANDARD:  1.0,
    FREQUENT:  PHI_INV * PHI,       /* ≈ 1 */
    ELITE:     PHI,
    VIP:       PHI_SQ,
    SOVEREIGN: PHI_SQ * PHI,
  }[nodeData.tier] || 1.0;
  return clamp01((nodeData.urgency || 0.5) * tierMul / (PHI_SQ * PHI));
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — PASSENGER GRAPH (Anonymised)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} NodeData
 * @property {string}  nodeId    — anonymised hash ID
 * @property {string}  tier      — PAX_TIER value
 * @property {string}  origin    — IATA departure code
 * @property {string}  dest      — IATA destination code
 * @property {number}  urgency   — [0,1] time pressure (1 = tight connection)
 * @property {boolean} isVIP
 * @property {number}  addedAt   — Unix ms
 */

/**
 * @typedef {Object} EdgeData
 * @property {string}  from
 * @property {string}  to
 * @property {number}  connectionMinutes — layover time in minutes
 * @property {number}  weight            — φ-scaled routing weight [0,1]
 * @property {string}  flightId          — connecting flight identifier
 */

/**
 * Add or update an anonymised passenger node.
 * @param {string} rawId          — raw passenger identifier (hashed internally)
 * @param {Partial<NodeData>} meta
 * @returns {string} anonymised nodeId
 */
function addPassenger(rawId, meta = {}) {
  if (_nodeData.size >= GRAPH_CAP) {
    /* Evict oldest standard-tier node when capacity reached */
    for (const [id, n] of _nodeData.entries()) {
      if (n.tier === PAX_TIER.STANDARD) { removePassenger(id); break; }
    }
  }

  const nodeId = anonymise(rawId);
  const existing = _nodeData.get(nodeId) || {};
  const data = {
    nodeId,
    tier:    meta.tier    || PAX_TIER.STANDARD,
    origin:  meta.origin  || 'UNK',
    dest:    meta.dest    || 'UNK',
    urgency: meta.urgency !== undefined ? clamp01(meta.urgency) : 0.5,
    isVIP:   meta.isVIP   || (meta.tier === PAX_TIER.VIP || meta.tier === PAX_TIER.SOVEREIGN),
    addedAt: existing.addedAt || Date.now(),
    ...existing,
    ...meta,
    nodeId,   /* always preserve the correct nodeId */
  };
  _nodeData.set(nodeId, data);
  if (!_adjacencyList.has(nodeId)) _adjacencyList.set(nodeId, new Set());

  if (data.isVIP) _enqueueVIP(nodeId, data);
  _totalPax++;
  return nodeId;
}

/**
 * Remove a passenger node and all its edges.
 * @param {string} nodeId — anonymised node ID
 */
function removePassenger(nodeId) {
  _adjacencyList.delete(nodeId);
  _nodeData.delete(nodeId);
  /* Remove incoming edges */
  for (const [id, adj] of _adjacencyList.entries()) {
    adj.delete(nodeId);
    _edgeData.delete(`${id}:${nodeId}`);
  }
  _bfsCache.clear();
}

/**
 * Connect two passenger nodes with a directed edge (from → to).
 * Represents "passenger at node 'from' can reach node 'to' via a connection."
 * @param {string} from
 * @param {string} to
 * @param {Partial<EdgeData>} meta
 */
function connectNodes(from, to, meta = {}) {
  if (!_adjacencyList.has(from)) _adjacencyList.set(from, new Set());
  _adjacencyList.get(from).add(to);

  const connectionMinutes = meta.connectionMinutes ?? 60;
  /* φ-weighted routing weight: tighter connections get lower weight (more urgent) */
  const weight = clamp01(1 - Math.exp(-connectionMinutes / (60 * PHI)));

  _edgeData.set(`${from}:${to}`, {
    from,
    to,
    connectionMinutes,
    weight,
    flightId: meta.flightId || 'UNK',
    ...meta,
  });
  _bfsCache.clear();
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — BFS CONNECTION MATCHER (sub-500ms SLA)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} BFSResult
 * @property {boolean}  found
 * @property {string[]} path           — ordered list of node IDs
 * @property {number}   hops
 * @property {number}   totalMinutes   — sum of connection times along path
 * @property {number}   coherenceScore — φ-weighted path quality [0,1]
 * @property {number}   elapsedMs      — time taken to compute
 * @property {boolean}  slaSatisfied   — elapsedMs < BFS_SLA_MS
 */

/**
 * BFS connection match: find the shortest path (fewest hops) from
 * nodeFrom to nodeTo in the passenger graph.
 * Memoised — repeated queries return cached result within 34 beats.
 * @param {string} nodeFrom — anonymised source node
 * @param {string} nodeTo   — anonymised target node
 * @returns {BFSResult}
 */
function bfsMatch(nodeFrom, nodeTo) {
  const cacheKey = `${nodeFrom}:${nodeTo}`;
  if (_bfsCache.has(cacheKey)) return _bfsCache.get(cacheKey);

  const t0 = Date.now();

  if (!_adjacencyList.has(nodeFrom)) {
    return _bfsResult(false, [], 0, 0, 0, Date.now() - t0);
  }

  /* Standard BFS */
  const queue   = [[nodeFrom, [nodeFrom]]];
  const visited = new Set([nodeFrom]);
  let   result  = null;

  outer: while (queue.length) {
    const [curr, path] = queue.shift();

    /* SLA guard — abort if we have already spent too long */
    if (Date.now() - t0 >= BFS_SLA_MS - 5) break;

    const neighbours = _adjacencyList.get(curr);
    if (!neighbours) continue;

    for (const next of neighbours) {
      if (visited.has(next)) continue;
      const newPath = [...path, next];
      if (next === nodeTo) {
        result = newPath;
        break outer;
      }
      if (newPath.length - 1 < BFS_MAX_HOPS) {
        visited.add(next);
        queue.push([next, newPath]);
      }
    }
  }

  const elapsed = Date.now() - t0;

  if (!result) {
    const r = _bfsResult(false, [], 0, 0, 0, elapsed);
    _bfsCache.set(cacheKey, r);
    return r;
  }

  /* Compute total connection minutes and coherence along the path */
  let totalMin   = 0;
  let coherence  = 1.0;
  for (let i = 0; i < result.length - 1; i++) {
    const e = _edgeData.get(`${result[i]}:${result[i + 1]}`);
    if (e) {
      totalMin  += e.connectionMinutes;
      coherence *= e.weight;  /* product of weights — coherence decays per hop */
    }
  }
  /* φ-normalise coherence: 1 hop = φ-near-perfect, each hop decays by PHI_INV */
  const normCoherence = clamp01(coherence * Math.pow(PHI_INV, result.length - 2));

  const r = _bfsResult(true, result, result.length - 1, totalMin, normCoherence, elapsed);
  _bfsCache.set(cacheKey, r);
  _totalMatches++;
  if (elapsed >= BFS_SLA_MS) _slaBreaches++;
  return r;
}

function _bfsResult(found, path, hops, totalMinutes, coherenceScore, elapsedMs) {
  return {
    found,
    path,
    hops,
    totalMinutes,
    coherenceScore: Math.round(coherenceScore * 10_000) / 10_000,
    elapsedMs,
    slaSatisfied: elapsedMs < BFS_SLA_MS,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — VIP ROUTER
// VIP passengers are placed in a φ-priority max-heap.  Each heartbeat the
// router emits routing directives for the top-N VIPs (N = Fibonacci index).
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} VIPDirective
 * @property {string}  nodeId        — anonymised VIP node ID
 * @property {string}  tier
 * @property {string}  origin
 * @property {string}  dest
 * @property {string}  assignedGate  — recommended gate
 * @property {number}  priority      — [0,1] φ-scaled routing priority
 * @property {string}  action        — 'FAST_TRACK' | 'LOUNGE' | 'ESCORT' | 'PRIORITY_BOARD'
 */

function _enqueueVIP(nodeId, data) {
  const score = priorityScore(data);
  /* Remove if already present, then re-insert with fresh score */
  _vipQueue = _vipQueue.filter(e => e.nodeId !== nodeId);
  _vipQueue.push({ nodeId, score, tier: data.tier, origin: data.origin, dest: data.dest });
  /* Max-heap sort by score */
  _vipQueue.sort((a, b) => b.score - a.score);
}

/**
 * Route the top-N VIPs this heartbeat.
 * @param {number} [n=5] — number of VIPs to route
 * @returns {VIPDirective[]}
 */
function routeVIPs(n = 5) {
  const directives = [];
  const top = _vipQueue.slice(0, n);

  for (const vip of top) {
    const data     = _nodeData.get(vip.nodeId);
    if (!data) continue;

    /* Find the best open gate for this VIP's destination */
    const gate = _bestGate(data.dest);

    const action =
      vip.tier === PAX_TIER.SOVEREIGN ? 'ESCORT' :
      vip.tier === PAX_TIER.VIP       ? 'FAST_TRACK' :
      vip.score >= PHI_INV            ? 'PRIORITY_BOARD' :
      'LOUNGE';

    directives.push({
      nodeId:       vip.nodeId,
      tier:         vip.tier,
      origin:       data.origin,
      dest:         data.dest,
      assignedGate: gate,
      priority:     Math.round(vip.score * 10_000) / 10_000,
      action,
    });
    _vipRoutings++;
  }
  return directives;
}

function _bestGate(dest) {
  let best = null, bestScore = -1;
  for (const [gateId, g] of _gates.entries()) {
    if (g.status === GATE_STATUS.CLOSED || g.status === GATE_STATUS.DIVERTED) continue;
    if (g.dest && g.dest !== dest) continue;
    const score = (g.flow < g.capacity ? 1 : 0) * PHI + (g.status === GATE_STATUS.OPEN ? PHI_INV : AMOR);
    if (score > bestScore) { bestScore = score; best = gateId; }
  }
  return best || 'G1';
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — POISSON GATE FLOW PREDICTOR
// Each gate has a Poisson arrival rate λ (passengers per minute).
// The predictor computes: expected queue depth, overflow probability,
// and recommended staffing level for the next Fibonacci window.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} GateState
 * @property {string}  gateId
 * @property {string}  dest        — IATA destination code served
 * @property {string}  status      — GATE_STATUS enum
 * @property {number}  capacity    — max simultaneous passengers at gate
 * @property {number}  flow        — current passenger count in gate area
 * @property {number}  lambda      — Poisson arrival rate (pax/minute)
 * @property {number}  updatedAt
 */

/**
 * Register or update a gate.
 * @param {string} gateId
 * @param {Partial<GateState>} meta
 */
function registerGate(gateId, meta = {}) {
  const existing = _gates.get(gateId) || {};
  _gates.set(gateId, {
    gateId,
    dest:      meta.dest     || 'UNK',
    status:    meta.status   || GATE_STATUS.OPEN,
    capacity:  meta.capacity || 150,
    flow:      meta.flow     || 0,
    lambda:    meta.lambda   || 2.0,   /* default: 2 passengers/minute */
    updatedAt: Date.now(),
    ...existing,
    ...meta,
    gateId,
  });
}

/**
 * @typedef {Object} GateFlowPrediction
 * @property {string}  gateId
 * @property {number}  lambda               — arrival rate (pax/min)
 * @property {number}  windowMinutes        — forecast horizon
 * @property {number}  expectedArrivals     — λ × windowMinutes
 * @property {number}  overflowProbability  — P(arrivals > capacity)
 * @property {number}  recommendedStaff     — φ-scaled staffing level
 * @property {string}  alert                — 'CRITICAL' | 'HIGH' | 'NORMAL' | 'QUIET'
 */

/**
 * Predict gate flow for a Fibonacci-spaced window ahead.
 * @param {string} gateId
 * @param {number} windowMinutes — forecast horizon in minutes
 * @returns {GateFlowPrediction | null}
 */
function predictGateFlow(gateId, windowMinutes) {
  const gate = _gates.get(gateId);
  if (!gate) return null;

  const lambda   = gate.lambda;
  const expected = lambda * windowMinutes;
  /* P(X > capacity) = 1 − CDF(capacity − 1) */
  const overflowProb = clamp01(1 - poissonCDF(expected, gate.capacity - 1));
  /* φ-scaled staffing: ceil(expected / (PHI × 20))  — one agent per PHI×20 expected pax */
  const staff = Math.ceil(expected / (PHI * 20));

  let alert;
  if (overflowProb >= 0.8)      alert = 'CRITICAL';
  else if (overflowProb >= 0.5) alert = 'HIGH';
  else if (overflowProb >= 0.2) alert = 'NORMAL';
  else                          alert = 'QUIET';

  return {
    gateId,
    lambda:              Math.round(lambda    * 1_000) / 1_000,
    windowMinutes,
    expectedArrivals:    Math.round(expected  * 100)   / 100,
    overflowProbability: Math.round(overflowProb * 10_000) / 10_000,
    recommendedStaff:    Math.max(1, staff),
    alert,
  };
}

/**
 * Predict flow for all registered gates.
 * @param {number} [windowMinutes=21] — default: Fibonacci F₈ = 21 min
 * @returns {GateFlowPrediction[]}
 */
function predictAllGates(windowMinutes = 21) {
  const results = [];
  for (const gateId of _gates.keys()) {
    const p = predictGateFlow(gateId, windowMinutes);
    if (p) results.push(p);
  }
  results.sort((a, b) => b.overflowProbability - a.overflowProbability);
  return results;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — HEARTBEAT ENGINE (COR PARVUM)
// ═══════════════════════════════════════════════════════════════════════════════

function _tick() {
  _beat++;
  _phase = (_phase + PHI_INV) % (2 * Math.PI);

  /* BFS cache eviction every 34 beats */
  if (_beat % 34 === 0) _bfsCache.clear();

  /* Trim VIP queue — keep top 64 */
  if (_vipQueue.length > 64) _vipQueue = _vipQueue.slice(0, 64);

  return {
    agiId:        AGI_ID,
    beat:         _beat,
    phase:        _phase,
    timestamp:    Date.now(),
    graphNodes:   _nodeData.size,
    graphEdges:   _edgeData.size,
    totalPax:     _totalPax,
    totalMatches: _totalMatches,
    slaBreaches:  _slaBreaches,
    vipRoutings:  _vipRoutings,
    vipQueueDepth:_vipQueue.length,
    gateCount:    _gates.size,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — PUBLIC AGI INTERFACE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Start the PASSEX-AGI heartbeat.  Idempotent.
 * @param {function} [onTick]
 */
function start(onTick) {
  if (_alive) return;
  _alive = true;
  _hbi = setInterval(() => {
    const state = _tick();
    if (typeof onTick === 'function') onTick(state);
  }, HEARTBEAT_MS);
}

/** Stop the PASSEX-AGI heartbeat. */
function stop() {
  if (!_alive) return;
  _alive = false;
  clearInterval(_hbi);
  _hbi = null;
}

/** @returns {boolean} */
function isAlive() { return _alive; }

/** Full AGI status snapshot. */
function getStatus() {
  return {
    agiId:        AGI_ID,
    version:      AGI_VERSION,
    family:       AGI_FAMILY,
    alive:        _alive,
    beat:         _beat,
    phi:          PHI,
    amor:         AMOR,
    heartbeatMs:  HEARTBEAT_MS,
    bfsSlaMs:     BFS_SLA_MS,
    graphNodes:   _nodeData.size,
    graphEdges:   _edgeData.size,
    totalPax:     _totalPax,
    totalMatches: _totalMatches,
    slaBreaches:  _slaBreaches,
    vipRoutings:  _vipRoutings,
    vipQueueDepth:_vipQueue.length,
    gateCount:    _gates.size,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  /* Identity */
  AGI_ID,
  AGI_VERSION,
  AGI_FAMILY,
  PAX_TIER,
  GATE_STATUS,
  BFS_SLA_MS,

  /* Lifecycle */
  start,
  stop,
  isAlive,
  getStatus,

  /* Passenger graph */
  addPassenger,
  removePassenger,
  connectNodes,
  anonymise,

  /* BFS matcher */
  bfsMatch,

  /* VIP router */
  routeVIPs,

  /* Gate flow predictor */
  registerGate,
  predictGateFlow,
  predictAllGates,

  /* Utility */
  clamp01,
  anonymise,
  poissonPMF,
  poissonCDF,
  priorityScore,
};
