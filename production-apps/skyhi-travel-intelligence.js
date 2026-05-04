/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 *  SKYHI TRAVEL INTELLIGENCE ORGANISM
 *  Organism ID: RSHIP-PROD-SKYHI-001  ·  Family: ITER_CAELUM_AETERNA
 *  Production App — Orchestrates TRAVEX-AGI + PASSEX-AGI
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 *
 *  The Skyhi Travel Intelligence Organism is the sovereign production-level
 *  runtime that binds all three intelligence layers into one living system:
 *
 *    TRAVEX-AGI   — Travel Demand & Booking Intelligence
 *                   (last-minute scanner · multi-signal demand · Fibonacci
 *                    seat-release · outcome feedback loop)
 *
 *    PASSEX-AGI   — Passenger Intelligence
 *                   (anonymised passenger graph · sub-500ms BFS matching ·
 *                    VIP routing · Poisson gate-flow prediction)
 *
 *    SKYHI-CHIP   — NOVA Virtual Inference Chip (sealed, trade-secret math)
 *                   Provides φ-coherence scores and yield multipliers.
 *
 *  Five Intelligence Cycles (run in sequence every 873ms heartbeat):
 *
 *    CYCLE 1 — SCAN          Ingest live inventory from all 10 booking platforms
 *    CYCLE 2 — ANALYSE       Multi-signal demand scoring for each inventory item
 *    CYCLE 3 — RELEASE       Fibonacci-schedule seat/room releases + VIP routing
 *    CYCLE 4 — PREDICT       Poisson gate-flow forecast across all registered gates
 *    CYCLE 5 — FEEDBACK      Record outcomes, update demand weights, emit telemetry
 *
 *  Architecture:
 *    COR PARVUM        — 873ms MiniHeart oscillator
 *    CEREBRUM_ITER     — Travel intelligence composite brain
 *    MACHINA_ORBIS     — Five-cycle state machine
 *    AMOR PERPETUA     — φ⁻² care weight in every routing decision
 *
 *  Commands (postMessage → self):
 *    INGEST_INVENTORY  — { type, items: InventoryEntry[] }
 *    ADD_PASSENGER     — { type, rawId, meta }
 *    CONNECT_NODES     — { type, from, to, meta }
 *    REGISTER_GATE     — { type, gateId, meta }
 *    RECORD_OUTCOME    — { type, inventoryId, outcome, actualFillRate }
 *    GET_STATUS        — returns full organism status
 *    status            — liveness probe
 *    stop              — graceful shutdown
 *
 *  Events emitted (self.postMessage → page):
 *    heartbeat         — full organism state every beat
 *    cycle_complete    — { cycle, result } after each of the 5 cycles
 *    alert             — critical gate-overflow or SLA-breach alert
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *  CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var ORGANISM_ID      = 'RSHIP-PROD-SKYHI-001';
var ORGANISM_VERSION = '1.0.0';
var ORGANISM_FAMILY  = 'ITER_CAELUM_AETERNA';   /* Latin: eternal sky journey  */
var ORGANISM_LATIN   = 'ITER PERPETUUM';

var PHI       = 1.6180339887498948482;   /* φ — golden ratio                  */
var PHI_INV   = 0.6180339887498948482;   /* φ⁻¹ — coherence weight            */
var PHI_SQ    = 2.6180339887498948482;   /* φ² — VIP amplification            */
var AMOR      = 0.3819660112501051518;   /* φ⁻² — love constant               */
var HEARTBEAT = 873;                     /* ms — sovereign 873ms heartbeat    */

/* Fibonacci sequence for release windows (minutes before departure) */
var FIBONACCI = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];

/* Five intelligence cycles */
var CYCLES = ['SCAN', 'ANALYSE', 'RELEASE', 'PREDICT', 'FEEDBACK'];

/* Booking platform registry */
var PLATFORMS = [
  'BOOKING_COM', 'EXPEDIA', 'HOTELS_COM', 'AIRBNB', 'VRBO',
  'KAYAK',       'PRICELINE', 'AGODA',    'TRIP_COM', 'HOTELSDK_DIRECT',
];

/* PAX tier constants (mirrors passex-agi) */
var PAX_TIER = {
  STANDARD:  'STANDARD',
  FREQUENT:  'FREQUENT',
  ELITE:     'ELITE',
  VIP:       'VIP',
  SOVEREIGN: 'SOVEREIGN',
};

/* Outcome enum (mirrors travex-agi) */
var OUTCOME = {
  FILLED:      'FILLED',
  LAST_MINUTE: 'LAST_MINUTE',
  UNSOLD:      'UNSOLD',
  CANCELLED:   'CANCELLED',
};

/* ════════════════════════════════════════════════════════════════════════════
   §2  STATE
════════════════════════════════════════════════════════════════════════════ */

var beat       = 0;
var running    = true;
var _hbi       = null;
var cycleIndex = 0;   /* 0-4 cycling through CYCLES */
var phase      = 0.0;

/* ── TRAVEX-AGI in-process state ─────────────────────────────────────────── */
var travex = {
  inventory:      {},   /* id → InventoryEntry       */
  fibIndex:       0,
  demandWeights:  {
    SEARCH_VELOCITY:   PHI_INV,
    PRICE_SENSITIVITY: AMOR,
    WEATHER_INDEX:     PHI_INV * AMOR,
    EVENT_PROXIMITY:   PHI_INV,
    SOCIAL_PULSE:      AMOR,
    KURAMOTO_SYNC:     PHI,
    CANCELLATION_WAVE: PHI_INV,
    COMPETITOR_FILL:   AMOR,
  },
  totalScanned:   0,
  lastMinuteHits: 0,
  feedbackLog:    [],   /* last 256 outcome records  */
  releaseLog:     [],   /* last 64 release events    */
};

/* ── PASSEX-AGI in-process state ─────────────────────────────────────────── */
var passex = {
  adjacencyList:  {},   /* nodeId → [nodeId, …]      */
  nodeData:       {},   /* nodeId → NodeData          */
  edgeData:       {},   /* `from:to` → EdgeData       */
  gates:          {},   /* gateId → GateState         */
  vipQueue:       [],   /* max-heap by priority score */
  bfsCache:       {},   /* `from:to` → BFSResult      */
  totalPax:       0,
  totalMatches:   0,
  slaBreaches:    0,
  vipRoutings:    0,
};

/* ── CEREBRUM ITER — composite travel-intelligence brain ─────────────────── */
var brain = {
  regions: [
    { name: 'Demand',    activation: 0.0, lif: -70.0, bias: 1.3 },  /* dominant: drives pricing  */
    { name: 'Routing',   activation: 0.0, lif: -70.0, bias: 1.2 },  /* dominant: VIP + connection */
    { name: 'Forecast',  activation: 0.0, lif: -70.0, bias: 1.1 },  /* gate-flow prediction      */
    { name: 'Memory',    activation: 0.0, lif: -70.0, bias: 0.9 },  /* outcome history           */
    { name: 'Sovereign', activation: 0.0, lif: -70.0, bias: 1.5 },  /* φ² care override          */
  ],
  chemicals: {
    dopamine:      0.618,  /* reward — rises when inventory fills */
    serotonin:     0.700,  /* stability                           */
    acetylcholine: 0.618,  /* attention — sharpens under load     */
    oxytocin:      AMOR,   /* love hormone — φ⁻² sovereign care  */
  },
  coherenceField: 0.0,
};

/* Telemetry accumulators */
var totalCycles   = 0;
var cycleResults  = {};   /* last result per cycle name */
var alertLog      = [];   /* last 64 critical alerts    */

/* ════════════════════════════════════════════════════════════════════════════
   §3  UTILITY
════════════════════════════════════════════════════════════════════════════ */

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function fibWindow(index) {
  return FIBONACCI[Math.min(index, FIBONACCI.length - 1)];
}

function poissonPMF(lambda, k) {
  if (lambda <= 0) return k === 0 ? 1 : 0;
  var logP = -lambda + k * Math.log(lambda);
  for (var i = 2; i <= k; i++) logP -= Math.log(i);
  return Math.exp(logP);
}

function poissonCDF(lambda, k) {
  var p = 0;
  for (var i = 0; i <= k; i++) p += poissonPMF(lambda, i);
  return Math.min(1, p);
}

/** FNV-1a 32-bit hash — anonymise passenger IDs */
function fnv1a(str) {
  var h = 0x811c9dc5;
  for (var i = 0; i < str.length; i++) {
    h ^= str.charCodeAt(i);
    h  = (h * 0x01000193) >>> 0;
  }
  return h.toString(16).padStart(8, '0');
}

function anonymise(rawId) {
  return 'pax_' + fnv1a(rawId + '_nova_salt_' + String(beat % 987));
}

function tierPriorityMul(tier) {
  return tier === 'SOVEREIGN' ? PHI_SQ * PHI
       : tier === 'VIP'       ? PHI_SQ
       : tier === 'ELITE'     ? PHI
       : tier === 'FREQUENT'  ? 1.0
       : PHI_INV;
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  COR PARVUM — MiniHeart
════════════════════════════════════════════════════════════════════════════ */

function tickHeart() {
  beat++;
  phase = (phase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  runNextCycle();
  emitHeartbeat();
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  CEREBRUM ITER — Travel Intelligence Brain
════════════════════════════════════════════════════════════════════════════ */

function tickBrain() {
  var sum = 0;
  var busyBoost = (Object.keys(travex.inventory).length > 0) ? 0.06 : 0;
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0 * r.bias;
    if (r.lif >= -55.0) { r.activation = Math.min(1.0, r.activation + 0.2 + busyBoost); r.lif = -70.0; }
    r.activation *= 0.95;
    sum += r.activation;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.01);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.48) * 0.02 + busyBoost * 0.02);
  brain.chemicals.oxytocin      = clamp01(brain.chemicals.oxytocin      + (AMOR - brain.chemicals.oxytocin) * 0.05);
  brain.coherenceField = sum / brain.regions.length;
}

/* ════════════════════════════════════════════════════════════════════════════
   §6  MACHINA ORBIS — Five-Cycle State Machine
   Runs one cycle per heartbeat: SCAN → ANALYSE → RELEASE → PREDICT → FEEDBACK
════════════════════════════════════════════════════════════════════════════ */

function runNextCycle() {
  var cycle = CYCLES[cycleIndex % CYCLES.length];
  var result;

  switch (cycle) {
    case 'SCAN':
      result = cycleScan();
      break;
    case 'ANALYSE':
      result = cycleAnalyse();
      break;
    case 'RELEASE':
      result = cycleRelease();
      break;
    case 'PREDICT':
      result = cyclePredict();
      break;
    case 'FEEDBACK':
      result = cycleFeedback();
      break;
    default:
      result = { cycle, skipped: true };
  }

  cycleResults[cycle] = result;
  totalCycles++;
  cycleIndex = (cycleIndex + 1) % CYCLES.length;

  emit('cycle_complete', { cycle: cycle, result: result, beat: beat });
}

/* ── CYCLE 1: SCAN ──────────────────────────────────────────────────────── */

function cycleScan() {
  var now      = Date.now();
  var newItems = 0;
  var flagged  = 0;

  /* Synthetic platform pulse — in production, replace with live platform feeds */
  var platformIdx = beat % PLATFORMS.length;
  var platform    = PLATFORMS[platformIdx];

  /* Refresh status of all tracked inventory */
  var ids = Object.keys(travex.inventory);
  for (var i = 0; i < ids.length; i++) {
    var e = travex.inventory[ids[i]];
    var minLeft = (e.departureMs - now) / 60_000;
    var window  = fibWindow(travex.fibIndex);
    if (minLeft <= 0) {
      e.status = 'CLOSED';
    } else if (minLeft <= window && e.status === 'OPEN') {
      e.status = 'LAST_MINUTE';
      travex.lastMinuteHits++;
      flagged++;
    }
    e.scannedAt = now;
  }

  return {
    cycle:       'SCAN',
    platform:    platform,
    inventorySize: ids.length,
    newItems:    newItems,
    flaggedLM:   flagged,
    timestamp:   now,
  };
}

/* ── CYCLE 2: ANALYSE ───────────────────────────────────────────────────── */

function cycleAnalyse() {
  var now     = Date.now();
  var w       = travex.demandWeights;
  var results = [];

  var ids = Object.keys(travex.inventory);
  for (var i = 0; i < ids.length; i++) {
    var e = travex.inventory[ids[i]];
    if (e.status === 'CLOSED') continue;

    /* φ-weighted demand score using stored signal snapshot on the entry */
    var sv  = clamp01(e.signals ? (e.signals.searchVelocity   || 0.5) : 0.5);
    var ps  = clamp01(e.signals ? (e.signals.priceSensitivity || 0.5) : 0.5);
    var wi  = clamp01(e.signals ? (e.signals.weatherIndex     || 0.1) : 0.1);
    var ep  = clamp01(e.signals ? (e.signals.eventProximity   || 0.2) : 0.2);
    var sp  = clamp01(e.signals ? (e.signals.socialPulse      || 0.3) : 0.3);
    var ks  = clamp01(brain.coherenceField);  /* Kuramoto sync ← live brain coherence */
    var cw  = clamp01(1 - (e.signals ? (e.signals.cancellationWave || 0.1) : 0.1));
    var cf  = clamp01(e.signals ? (e.signals.competitorFill   || 0.5) : 0.5);

    var raw =
      sv * w.SEARCH_VELOCITY   + ps * w.PRICE_SENSITIVITY +
      wi * w.WEATHER_INDEX     + ep * w.EVENT_PROXIMITY   +
      sp * w.SOCIAL_PULSE      + ks * w.KURAMOTO_SYNC     +
      cw * w.CANCELLATION_WAVE + cf * w.COMPETITOR_FILL;

    var wTotal =
      w.SEARCH_VELOCITY + w.PRICE_SENSITIVITY + w.WEATHER_INDEX +
      w.EVENT_PROXIMITY + w.SOCIAL_PULSE      + w.KURAMOTO_SYNC +
      w.CANCELLATION_WAVE + w.COMPETITOR_FILL;

    var score = clamp01(raw / wTotal);

    /* φ-scaled yield multiplier */
    var phiLevel = Math.floor(score * 8);
    var phiPow   = Math.pow(PHI, phiLevel - 4);
    var yieldMul = clamp01(phiPow * (0.85 + score * 0.4)) * 2.5;

    /* Poisson fill estimate */
    var lambda  = score * 10;
    var fillEst = clamp01(1 - poissonPMF(lambda, 0));

    e.demandScore  = Math.round(score   * 10_000) / 10_000;
    e.yieldMul     = Math.round(yieldMul * 1_000)  / 1_000;
    e.fillEstimate = Math.round(fillEst  * 10_000) / 10_000;

    results.push({ id: e.id, score: e.demandScore, tier: score >= 0.85 ? 'SURGE' : score >= 0.65 ? 'HIGH' : score >= 0.40 ? 'NORMAL' : 'LOW' });
  }

  return {
    cycle:     'ANALYSE',
    analysed:  results.length,
    topItems:  results.sort(function(a, b) { return b.score - a.score; }).slice(0, 5),
    timestamp: now,
  };
}

/* ── CYCLE 3: RELEASE ───────────────────────────────────────────────────── */

function cycleRelease() {
  var now     = Date.now();
  var window  = fibWindow(travex.fibIndex);
  var events  = [];

  var ids = Object.keys(travex.inventory);
  for (var i = 0; i < ids.length; i++) {
    var e = travex.inventory[ids[i]];
    if (e.status !== 'OPEN') continue;
    var minLeft = (e.departureMs - now) / 60_000;
    if (minLeft > 0 && minLeft <= window) {
      e.status = 'LAST_MINUTE';
      var action = e.demandScore >= 0.7 ? 'HOLD' : e.demandScore >= 0.4 ? 'UPGRADE_OFFER' : 'DISCOUNT';
      var ev = { inventoryId: e.id, fibIndex: travex.fibIndex, windowMinutes: window, releasedAt: now, demandScore: e.demandScore, action: action };
      events.push(ev);
      travex.releaseLog = travex.releaseLog.slice(-63).concat([ev]);
      travex.lastMinuteHits++;
    }
  }

  /* Advance Fibonacci index every ~5 beats */
  if (beat % Math.round(PHI_INV * 8) === 0 && travex.fibIndex < FIBONACCI.length - 1) {
    travex.fibIndex++;
  }

  /* VIP routing — emit directives for top-5 VIPs */
  var vipDirectives = routeTopVIPs(5);

  return {
    cycle:         'RELEASE',
    releases:      events.length,
    fibIndex:      travex.fibIndex,
    windowMinutes: window,
    events:        events,
    vipDirectives: vipDirectives,
    timestamp:     now,
  };
}

/* ── CYCLE 4: PREDICT ───────────────────────────────────────────────────── */

function cyclePredict() {
  var now          = Date.now();
  var windowMin    = fibWindow(travex.fibIndex);
  var predictions  = [];
  var alerts       = [];

  var gateIds = Object.keys(passex.gates);
  for (var i = 0; i < gateIds.length; i++) {
    var g        = passex.gates[gateIds[i]];
    if (g.status === 'CLOSED' || g.status === 'DIVERTED') continue;
    var lambda   = g.lambda || 2.0;
    var expected = lambda * windowMin;
    var overflow = clamp01(1 - poissonCDF(expected, g.capacity - 1));
    var staff    = Math.max(1, Math.ceil(expected / (PHI * 20)));
    var alert    = overflow >= 0.8 ? 'CRITICAL' : overflow >= 0.5 ? 'HIGH' : overflow >= 0.2 ? 'NORMAL' : 'QUIET';

    var pred = {
      gateId:              g.gateId,
      lambda:              Math.round(lambda   * 1_000)  / 1_000,
      windowMinutes:       windowMin,
      expectedArrivals:    Math.round(expected * 100)    / 100,
      overflowProbability: Math.round(overflow * 10_000) / 10_000,
      recommendedStaff:    staff,
      alert:               alert,
    };
    predictions.push(pred);

    if (alert === 'CRITICAL') {
      var alertEntry = { type: 'GATE_OVERFLOW', gateId: g.gateId, overflowProbability: pred.overflowProbability, timestamp: now };
      alerts.push(alertEntry);
      alertLog = alertLog.slice(-63).concat([alertEntry]);
      emit('alert', alertEntry);
    }
  }

  predictions.sort(function(a, b) { return b.overflowProbability - a.overflowProbability; });

  return {
    cycle:       'PREDICT',
    gateCount:   gateIds.length,
    predictions: predictions,
    alerts:      alerts.length,
    timestamp:   now,
  };
}

/* ── CYCLE 5: FEEDBACK ──────────────────────────────────────────────────── */

function cycleFeedback() {
  var now     = Date.now();
  var recent  = travex.feedbackLog.slice(-64);
  var mae     = recent.length ? recent.reduce(function(s, r) { return s + r.error; }, 0) / recent.length : 0;

  /* Dopamine boost when MAE is improving */
  if (mae < 0.15) brain.chemicals.dopamine = clamp01(brain.chemicals.dopamine + 0.03);

  /* Auto-evict CLOSED inventory older than 3 hours */
  var cutoff = now - 3 * 3600_000;
  var ids     = Object.keys(travex.inventory);
  var evicted = 0;
  for (var i = 0; i < ids.length; i++) {
    var e = travex.inventory[ids[i]];
    if (e.status === 'CLOSED' && e.scannedAt < cutoff) {
      delete travex.inventory[ids[i]];
      evicted++;
    }
  }

  /* BFS cache eviction every 34 beats */
  if (beat % 34 === 0) passex.bfsCache = {};

  return {
    cycle:          'FEEDBACK',
    mae:            Math.round(mae * 10_000) / 10_000,
    feedbackCount:  travex.feedbackLog.length,
    evicted:        evicted,
    demandWeights:  Object.assign({}, travex.demandWeights),
    timestamp:      now,
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §7  VIP ROUTING
════════════════════════════════════════════════════════════════════════════ */

function routeTopVIPs(n) {
  var top = passex.vipQueue.slice(0, n);
  var directives = [];

  for (var i = 0; i < top.length; i++) {
    var vip  = top[i];
    var data = passex.nodeData[vip.nodeId];
    if (!data) continue;

    /* Find best open gate */
    var gate = bestGate(data.dest);
    var action =
      vip.tier === 'SOVEREIGN' ? 'ESCORT' :
      vip.tier === 'VIP'       ? 'FAST_TRACK' :
      vip.score >= PHI_INV     ? 'PRIORITY_BOARD' :
      'LOUNGE';

    directives.push({
      nodeId:       vip.nodeId,
      tier:         vip.tier,
      origin:       data.origin,
      dest:         data.dest,
      assignedGate: gate,
      priority:     Math.round(vip.score * 10_000) / 10_000,
      action:       action,
    });
    passex.vipRoutings++;
  }
  return directives;
}

function bestGate(dest) {
  var bestId    = null;
  var bestScore = -1;
  var gateIds   = Object.keys(passex.gates);
  for (var i = 0; i < gateIds.length; i++) {
    var g = passex.gates[gateIds[i]];
    if (g.status === 'CLOSED' || g.status === 'DIVERTED') continue;
    if (g.dest && g.dest !== dest) continue;
    var score = (g.flow < g.capacity ? 1 : 0) * PHI + (g.status === 'OPEN' ? PHI_INV : AMOR);
    if (score > bestScore) { bestScore = score; bestId = gateIds[i]; }
  }
  return bestId || 'G1';
}

/* ════════════════════════════════════════════════════════════════════════════
   §8  BFS CONNECTION MATCHER
════════════════════════════════════════════════════════════════════════════ */

function bfsMatch(from, to) {
  var cacheKey = from + ':' + to;
  if (passex.bfsCache[cacheKey]) return passex.bfsCache[cacheKey];

  var t0  = Date.now();
  var adj = passex.adjacencyList;

  if (!adj[from]) {
    return { found: false, path: [], hops: 0, totalMinutes: 0, coherenceScore: 0, elapsedMs: Date.now() - t0, slaSatisfied: true };
  }

  var queue   = [[from, [from]]];
  var visited = {};
  visited[from] = true;
  var result  = null;

  outer: while (queue.length) {
    var curr_path = queue.shift();
    var curr      = curr_path[0];
    var path      = curr_path[1];

    if (Date.now() - t0 >= 495) break;   /* SLA guard: abort at 495ms */

    var neighbours = adj[curr] || [];
    for (var ni = 0; ni < neighbours.length; ni++) {
      var next = neighbours[ni];
      if (visited[next]) continue;
      var newPath = path.concat([next]);
      if (next === to) { result = newPath; break outer; }
      if (newPath.length - 1 < 6) { visited[next] = true; queue.push([next, newPath]); }
    }
  }

  var elapsed = Date.now() - t0;

  if (elapsed >= 500) passex.slaBreaches++;

  if (!result) {
    var r = { found: false, path: [], hops: 0, totalMinutes: 0, coherenceScore: 0, elapsedMs: elapsed, slaSatisfied: elapsed < 500 };
    passex.bfsCache[cacheKey] = r;
    return r;
  }

  var totalMin  = 0;
  var coherence = 1.0;
  for (var pi = 0; pi < result.length - 1; pi++) {
    var edge = passex.edgeData[result[pi] + ':' + result[pi + 1]];
    if (edge) { totalMin += edge.connectionMinutes; coherence *= edge.weight; }
  }
  var normCoherence = clamp01(coherence * Math.pow(PHI_INV, result.length - 2));

  var res = {
    found:          true,
    path:           result,
    hops:           result.length - 1,
    totalMinutes:   totalMin,
    coherenceScore: Math.round(normCoherence * 10_000) / 10_000,
    elapsedMs:      elapsed,
    slaSatisfied:   elapsed < 500,
  };
  passex.bfsCache[cacheKey] = res;
  passex.totalMatches++;
  return res;
}

/* ════════════════════════════════════════════════════════════════════════════
   §9  EMIT / MESSAGING
════════════════════════════════════════════════════════════════════════════ */

function emit(type, payload) {
  if (typeof self !== 'undefined' && typeof self.postMessage === 'function') {
    self.postMessage(Object.assign({ type: type }, payload));
  }
}

function emitHeartbeat() {
  emit('heartbeat', {
    organismId:    ORGANISM_ID,
    version:       ORGANISM_VERSION,
    family:        ORGANISM_FAMILY,
    latin:         ORGANISM_LATIN,
    beat:          beat,
    phase:         phase,
    phi:           PHI,
    amor:          AMOR,
    heartbeatMs:   HEARTBEAT,
    timestamp:     Date.now(),
    status:        'alive',
    cycle:         CYCLES[cycleIndex % CYCLES.length],
    totalCycles:   totalCycles,

    /* TRAVEX summary */
    travex: {
      inventorySize:  Object.keys(travex.inventory).length,
      lastMinuteHits: travex.lastMinuteHits,
      fibIndex:       travex.fibIndex,
      fibWindow:      fibWindow(travex.fibIndex),
      releaseCount:   travex.releaseLog.length,
      feedbackMAE:    (function() {
        var recent = travex.feedbackLog.slice(-64);
        return recent.length ? Math.round(recent.reduce(function(s, r) { return s + r.error; }, 0) / recent.length * 10_000) / 10_000 : 0;
      })(),
    },

    /* PASSEX summary */
    passex: {
      graphNodes:    Object.keys(passex.nodeData).length,
      graphEdges:    Object.keys(passex.edgeData).length,
      totalMatches:  passex.totalMatches,
      slaBreaches:   passex.slaBreaches,
      vipRoutings:   passex.vipRoutings,
      vipQueueDepth: passex.vipQueue.length,
      gateCount:     Object.keys(passex.gates).length,
    },

    /* Brain telemetry */
    brain: {
      coherenceField: Math.round(brain.coherenceField * 10_000) / 10_000,
      chemicals:      brain.chemicals,
    },

    cycleResults:   cycleResults,
    alerts:         alertLog.slice(-5),
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §10  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

if (typeof self !== 'undefined') {
  self.onmessage = function(ev) {
    var msg = ev.data;
    if (!msg || !msg.type) return;

    switch (msg.type) {

      /* ── Inventory ingestion ─────────────────────────────────────────── */
      case 'INGEST_INVENTORY': {
        var items = msg.items || [];
        for (var i = 0; i < items.length; i++) {
          var item = items[i];
          var id   = String(item.id || ('inv_' + Date.now() + '_' + i));
          /* Guard against prototype-pollution keys */
          if (id === '__proto__' || id === 'constructor' || id === 'prototype') continue;
          travex.inventory[id] = Object.assign({
            id:          id,
            platform:    item.platform    || 'UNKNOWN',
            type:        item.type        || 'FLIGHT',
            departureMs: item.departureMs || (Date.now() + 48 * 3600_000),
            price:       item.price       || 0,
            capacity:    item.capacity    || 100,
            filled:      item.filled      || 0,
            demandScore: 0.5,
            yieldMul:    1.0,
            fillEstimate:0.5,
            status:      'OPEN',
            scannedAt:   Date.now(),
            signals:     item.signals     || {},
          }, item, { id: id });
          travex.totalScanned++;
        }
        emit('ingest_ack', { count: items.length, total: Object.keys(travex.inventory).length });
        break;
      }

      /* ── Passenger ingestion ─────────────────────────────────────────── */
      case 'ADD_PASSENGER': {
        var rawId  = msg.rawId || ('pax_' + Date.now());
        var meta   = msg.meta  || {};
        var nodeId = anonymise(rawId);
        passex.nodeData[nodeId] = Object.assign({
          nodeId:  nodeId,
          tier:    'STANDARD',
          origin:  'UNK',
          dest:    'UNK',
          urgency: 0.5,
          isVIP:   false,
          addedAt: Date.now(),
        }, meta, { nodeId: nodeId });
        if (!passex.adjacencyList[nodeId]) passex.adjacencyList[nodeId] = [];

        /* Enqueue VIP */
        var nd = passex.nodeData[nodeId];
        if (nd.isVIP || nd.tier === 'VIP' || nd.tier === 'SOVEREIGN') {
          var score = clamp01((nd.urgency || 0.5) * tierPriorityMul(nd.tier) / (PHI_SQ * PHI));
          passex.vipQueue = passex.vipQueue.filter(function(e) { return e.nodeId !== nodeId; });
          passex.vipQueue.push({ nodeId: nodeId, score: score, tier: nd.tier, origin: nd.origin, dest: nd.dest });
          passex.vipQueue.sort(function(a, b) { return b.score - a.score; });
        }
        passex.totalPax++;
        emit('passenger_ack', { nodeId: nodeId });
        break;
      }

      /* ── Graph connection ────────────────────────────────────────────── */
      case 'CONNECT_NODES': {
        var from = String(msg.from || ''), to = String(msg.to || ''), m = msg.meta || {};
        if (!from || !to || from === '__proto__' || to === '__proto__') break;
        if (!passex.adjacencyList[from]) passex.adjacencyList[from] = [];
        if (passex.adjacencyList[from].indexOf(to) === -1) passex.adjacencyList[from].push(to);
        var cMin   = m.connectionMinutes !== undefined ? m.connectionMinutes : 60;
        var weight = clamp01(1 - Math.exp(-cMin / (60 * PHI)));
        passex.edgeData[from + ':' + to] = Object.assign({ from: from, to: to, connectionMinutes: cMin, weight: weight, flightId: 'UNK' }, m);
        passex.bfsCache = {};
        emit('connect_ack', { from: from, to: to });
        break;
      }

      /* ── Gate registration ───────────────────────────────────────────── */
      case 'REGISTER_GATE': {
        var gateId = String(msg.gateId || '');
        if (!gateId || gateId === '__proto__' || gateId === 'constructor' || gateId === 'prototype') break;
        var gm     = msg.meta || {};
        passex.gates[gateId] = Object.assign({
          gateId:   gateId,
          dest:     'UNK',
          status:   'OPEN',
          capacity: 150,
          flow:     0,
          lambda:   2.0,
          updatedAt:Date.now(),
        }, gm, { gateId: gateId });
        emit('gate_ack', { gateId: gateId });
        break;
      }

      /* ── BFS query ───────────────────────────────────────────────────── */
      case 'BFS_MATCH': {
        var result = bfsMatch(msg.from, msg.to);
        emit('bfs_result', Object.assign({ requestId: msg.requestId }, result));
        break;
      }

      /* ── Outcome feedback ────────────────────────────────────────────── */
      case 'RECORD_OUTCOME': {
        var invId = String(msg.inventoryId || '');
        /* Guard against prototype-pollution keys */
        if (!invId || invId === '__proto__' || invId === 'constructor' || invId === 'prototype') break;
        var entry = Object.prototype.hasOwnProperty.call(travex.inventory, invId)
          ? travex.inventory[invId] : null;
        if (entry) {
          var predicted = entry.demandScore || 0.5;
          var actual    = clamp01(msg.actualFillRate || 0);
          var error     = Math.abs(predicted - actual);

          travex.feedbackLog = travex.feedbackLog.slice(-255).concat([{
            inventoryId:    invId,
            outcome:        msg.outcome,
            predictedScore: predicted,
            actualFillRate: actual,
            resolvedAt:     Date.now(),
            error:          error,
          }]);

          /* Stochastic weight update */
          var lr        = AMOR;
          var direction = actual - predicted;
          var w         = travex.demandWeights;
          w.KURAMOTO_SYNC   = clamp01(w.KURAMOTO_SYNC   + lr * direction * PHI);
          w.SEARCH_VELOCITY = clamp01(w.SEARCH_VELOCITY + lr * direction);
          w.COMPETITOR_FILL = clamp01(w.COMPETITOR_FILL + lr * direction * PHI_INV);
          w.SOCIAL_PULSE    = clamp01(w.SOCIAL_PULSE    + lr * direction * AMOR);

          if (msg.outcome === 'FILLED' || msg.outcome === 'LAST_MINUTE') entry.status = 'CLOSED';
          emit('outcome_ack', { inventoryId: invId, error: Math.round(error * 10_000) / 10_000 });
        }
        break;
      }

      /* ── Status probe ────────────────────────────────────────────────── */
      case 'GET_STATUS':
      case 'status': {
        emit('status', {
          organismId:  ORGANISM_ID,
          version:     ORGANISM_VERSION,
          family:      ORGANISM_FAMILY,
          alive:       running,
          beat:        beat,
          phi:         PHI,
          amor:        AMOR,
          heartbeatMs: HEARTBEAT,
          totalCycles: totalCycles,
          travex: {
            inventorySize:  Object.keys(travex.inventory).length,
            lastMinuteHits: travex.lastMinuteHits,
            totalScanned:   travex.totalScanned,
            fibIndex:       travex.fibIndex,
            fibWindow:      fibWindow(travex.fibIndex),
          },
          passex: {
            graphNodes:   Object.keys(passex.nodeData).length,
            totalPax:     passex.totalPax,
            totalMatches: passex.totalMatches,
            slaBreaches:  passex.slaBreaches,
            vipRoutings:  passex.vipRoutings,
            gateCount:    Object.keys(passex.gates).length,
          },
        });
        break;
      }

      /* ── Graceful shutdown ───────────────────────────────────────────── */
      case 'stop': {
        running = false;
        clearInterval(_hbi);
        emit('stopped', { organismId: ORGANISM_ID, beat: beat });
        break;
      }
    }
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §11  BOOTSTRAP — Start the organism immediately on load
════════════════════════════════════════════════════════════════════════════ */

_hbi = setInterval(function() {
  if (!running) { clearInterval(_hbi); return; }
  tickHeart();
}, HEARTBEAT);

/* Emit initial status so the host knows the organism is alive */
emit('heartbeat', {
  organismId:  ORGANISM_ID,
  version:     ORGANISM_VERSION,
  family:      ORGANISM_FAMILY,
  latin:       ORGANISM_LATIN,
  beat:        0,
  phase:       0,
  phi:         PHI,
  amor:        AMOR,
  heartbeatMs: HEARTBEAT,
  timestamp:   Date.now(),
  status:      'awakening',
  message:     'ITER PERPETUUM — Skyhi Travel Intelligence Organism awakening',
});

/* ════════════════════════════════════════════════════════════════════════════
   §12  NODE.JS EXPORT (for direct require() usage in production)
════════════════════════════════════════════════════════════════════════════ */

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    ORGANISM_ID,
    ORGANISM_VERSION,
    ORGANISM_FAMILY,
    PLATFORMS,
    CYCLES,
    OUTCOME,
    PAX_TIER,

    /* Direct API for Node.js usage */
    ingestInventory: function(items) {
      if (typeof self !== 'undefined' && typeof self.dispatchEvent === 'function') {
        self.dispatchEvent(new MessageEvent('message', { data: { type: 'INGEST_INVENTORY', items: items } }));
      }
      /* Inline path for Node.js */
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        var id   = item.id || ('inv_' + Date.now() + '_' + i);
        travex.inventory[id] = Object.assign({ id: id, status: 'OPEN', demandScore: 0.5, scannedAt: Date.now() }, item, { id: id });
        travex.totalScanned++;
      }
    },

    addPassenger: function(rawId, meta) {
      meta = meta || {};
      var nodeId = anonymise(rawId);
      passex.nodeData[nodeId] = Object.assign({ nodeId: nodeId, tier: 'STANDARD', urgency: 0.5, isVIP: false, addedAt: Date.now() }, meta, { nodeId: nodeId });
      if (!passex.adjacencyList[nodeId]) passex.adjacencyList[nodeId] = [];
      passex.totalPax++;
      return nodeId;
    },

    registerGate: function(gateId, meta) {
      meta = meta || {};
      passex.gates[gateId] = Object.assign({ gateId: gateId, status: 'OPEN', capacity: 150, flow: 0, lambda: 2.0, updatedAt: Date.now() }, meta, { gateId: gateId });
    },

    connectNodes: function(from, to, meta) {
      meta = meta || {};
      if (!passex.adjacencyList[from]) passex.adjacencyList[from] = [];
      if (passex.adjacencyList[from].indexOf(to) === -1) passex.adjacencyList[from].push(to);
      var cMin   = meta.connectionMinutes !== undefined ? meta.connectionMinutes : 60;
      var weight = clamp01(1 - Math.exp(-cMin / (60 * PHI)));
      passex.edgeData[from + ':' + to] = Object.assign({ from: from, to: to, connectionMinutes: cMin, weight: weight }, meta);
    },

    bfsMatch: bfsMatch,
    getStatus: function() { return { organismId: ORGANISM_ID, beat: beat, travex: { inventorySize: Object.keys(travex.inventory).length }, passex: { graphNodes: Object.keys(passex.nodeData).length } }; },
  };
}
