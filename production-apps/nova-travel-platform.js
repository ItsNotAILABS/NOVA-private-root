/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 *  NOVA TRAVEL INDUSTRY PLATFORM OS
 *  Organism ID: NOVA-TRAVEL-OS-001  ·  Family: VIA_AETERNA
 *  Full-stack sovereign travel industry AI company
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 *
 *  This is NOT a startup. This is NOT a SaaS. This is NOT built on anyone else.
 *  This is a sovereign AI company that IS the travel industry's intelligence layer.
 *  The company is run by AI. The intelligence is NOVA. The math is ours.
 *
 *  The platform serves every vertical of the travel industry:
 *
 *    VOLATUS      — Flight intelligence (demand, pricing, seat release, connections)
 *    HOSPITIUM    — Hotel & lodging intelligence (inventory, yield, occupancy)
 *    CURRUS       — Car rental & ground transport intelligence
 *    NAVIS        — Cruise & maritime intelligence
 *    FERRUM       — Rail & inter-city transport intelligence
 *    PACKETUM     — Packages & bundles intelligence (flights + hotel + car)
 *    CORPORATUM   — Corporate travel management (policies, spend, approvals)
 *    SCHOLAE      — Free tier for schools and educational institutions
 *    MERCATUM     — The open travel marketplace (third-party supplier APIs)
 *    GUBERNATOR   — The sovereign platform OS (orchestrates all 9 verticals)
 *
 *  Ten Intelligence Cycles (one per heartbeat, rotating):
 *    CYCLE 01 — VOLATUS_SCAN      Scan flight inventory + demand signals
 *    CYCLE 02 — VOLATUS_RELEASE   Fibonacci-schedule unsold seats
 *    CYCLE 03 — HOSPITIUM_SCAN    Scan hotel inventory + occupancy
 *    CYCLE 04 — HOSPITIUM_YIELD   Dynamic room pricing + packages
 *    CYCLE 05 — CURRUS_MATCH      Car rental availability + last-minute
 *    CYCLE 06 — PACKETUM_BUILD    Assemble dynamic packages from live inventory
 *    CYCLE 07 — CORPORATUM_AUDIT  Corporate policy enforcement + spend tracking
 *    CYCLE 08 — SCHOLAE_SERVE     Free allocation for schools + grants
 *    CYCLE 09 — MERCATUM_ROUTE    Supplier API routing + arbitrage
 *    CYCLE 10 — GUBERNATOR_SYNC   Cross-vertical Kuramoto coherence sync
 *
 *  Brain: COR MAGNUS — 873ms sovereign MiniHeart
 *  Math:  φ-weighted demand, Kuramoto sync, Lyapunov stability, Poisson flow
 *  Data:  All sovereign — no third-party AI, no external LLMs
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *  CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var PLATFORM_ID      = 'NOVA-TRAVEL-OS-001';
var PLATFORM_VERSION = '1.0.0';
var PLATFORM_FAMILY  = 'VIA_AETERNA';     /* Latin: eternal way              */
var PLATFORM_LATIN   = 'VIA PERPETUA';    /* The eternal road                */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var PHI_SQ    = 2.6180339887498948482;
var AMOR      = 0.3819660112501051518;
var HEARTBEAT = 873;

/* Fibonacci windows for inventory release (minutes before departure/check-in) */
var FIBONACCI = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];

/* Platform verticals */
var VERTICALS = ['VOLATUS', 'HOSPITIUM', 'CURRUS', 'NAVIS', 'FERRUM', 'PACKETUM', 'CORPORATUM', 'SCHOLAE', 'MERCATUM', 'GUBERNATOR'];

/* The ten intelligence cycles */
var CYCLES = [
  'VOLATUS_SCAN', 'VOLATUS_RELEASE',
  'HOSPITIUM_SCAN', 'HOSPITIUM_YIELD',
  'CURRUS_MATCH',
  'PACKETUM_BUILD',
  'CORPORATUM_AUDIT',
  'SCHOLAE_SERVE',
  'MERCATUM_ROUTE',
  'GUBERNATOR_SYNC',
];

/* Supported inventory types */
var INV_TYPE = {
  FLIGHT:    'FLIGHT',
  HOTEL:     'HOTEL',
  CAR:       'CAR',
  CRUISE:    'CRUISE',
  RAIL:      'RAIL',
  PACKAGE:   'PACKAGE',
  TRANSFER:  'TRANSFER',
};

/* Booking status */
var BOOKING_STATUS = {
  OPEN:        'OPEN',
  LAST_MINUTE: 'LAST_MINUTE',
  RESERVED:    'RESERVED',
  CONFIRMED:   'CONFIRMED',
  CLOSED:      'CLOSED',
  CANCELLED:   'CANCELLED',
};

/* Supplier types for the marketplace */
var SUPPLIER_TYPE = {
  GDS:         'GDS',        /* Global Distribution System (Amadeus, Sabre, Travelport) */
  DIRECT:      'DIRECT',     /* Direct supplier API */
  NDC:         'NDC',        /* IATA NDC standard */
  CONSOLIDATOR:'CONSOLIDATOR',
  BEDBANK:     'BEDBANK',    /* Hotel bed banks */
  OTA:         'OTA',        /* Online Travel Agency partner */
};

/* School/edu tier — always free */
var SCHOLAE_TIER = {
  K12:         'K12',
  UNIVERSITY:  'UNIVERSITY',
  NONPROFIT:   'NONPROFIT',
  GRANT:       'GRANT',
};

/* ════════════════════════════════════════════════════════════════════════════
   §2  STATE
════════════════════════════════════════════════════════════════════════════ */

var beat       = 0;
var running    = true;
var _hbi       = null;
var cycleIndex = 0;
var phase      = 0.0;

/* ── VOLATUS — Flight vertical ────────────────────────────────────────── */
var volatus = {
  inventory:      {},   /* id → FlightInventory     */
  fibIndex:       0,
  routes:         {},   /* routeKey → RouteStats    */
  demandWeights:  { SEARCH_VELOCITY: PHI_INV, KURAMOTO_SYNC: PHI, COMPETITOR_FILL: AMOR, SOCIAL_PULSE: AMOR, WEATHER_INDEX: PHI_INV * AMOR },
  totalReleases:  0,
  totalBooked:    0,
};

/* ── HOSPITIUM — Hotel vertical ───────────────────────────────────────── */
var hospitium = {
  inventory:    {},   /* id → HotelInventory      */
  properties:   {},   /* propertyId → Property    */
  fibIndex:     0,
  demandWeights:{ SEARCH_VELOCITY: PHI_INV, KURAMOTO_SYNC: PHI, EVENTS_NEARBY: PHI_INV, COMPETITOR_RATE: AMOR },
  totalNights:  0,
  totalBooked:  0,
};

/* ── CURRUS — Car rental vertical ────────────────────────────────────── */
var currus = {
  inventory:   {},   /* id → CarInventory        */
  stations:    {},   /* stationId → Station      */
  fibIndex:    0,
  totalBooked: 0,
};

/* ── PACKETUM — Packages vertical ────────────────────────────────────── */
var packetum = {
  packages:     {},  /* id → Package             */
  buildQueue:   [],  /* pending package builds   */
  totalBuilt:   0,
  totalBooked:  0,
};

/* ── CORPORATUM — Corporate vertical ─────────────────────────────────── */
var corporatum = {
  accounts:    {},   /* accountId → CorpAccount  */
  policies:    {},   /* accountId → Policy       */
  spend:       {},   /* accountId → SpendRecord  */
  violations:  [],   /* policy violations log    */
};

/* ── SCHOLAE — Free schools vertical ─────────────────────────────────── */
var scholae = {
  institutions: {}, /* id → Institution         */
  allocations:  {}, /* id → Allocation          */
  grantPool:    1_000_000, /* free USD equivalent grant budget */
  totalServed:  0,
};

/* ── MERCATUM — Supplier marketplace ─────────────────────────────────── */
var mercatum = {
  suppliers:     {},  /* id → Supplier            */
  routingTable:  {},  /* vertical+key → supplierId */
  arbitrageLog:  [],  /* last 64 arbitrage events  */
  totalRouted:   0,
};

/* ── COR MAGNUS — Platform brain ─────────────────────────────────────── */
var brain = {
  regions: [
    { name: 'Demand',    activation: 0.0, lif: -70.0, bias: 1.4 },
    { name: 'Supply',    activation: 0.0, lif: -70.0, bias: 1.2 },
    { name: 'Routing',   activation: 0.0, lif: -70.0, bias: 1.3 },
    { name: 'Arbitrage', activation: 0.0, lif: -70.0, bias: 1.1 },
    { name: 'Sovereign', activation: 0.0, lif: -70.0, bias: 1.5 },
    { name: 'Scholae',   activation: 0.0, lif: -70.0, bias: 1.0 },
  ],
  chemicals: { dopamine: 0.618, serotonin: 0.700, acetylcholine: 0.618, oxytocin: AMOR },
  coherenceField: 0.0,
  kuramoto: { r: 0.5, psi: 0.0 },
};

/* Telemetry */
var totalCycles   = 0;
var cycleResults  = {};
var alertLog      = [];
var platformMAE   = 0.0;

/* ════════════════════════════════════════════════════════════════════════════
   §3  UTILITY
════════════════════════════════════════════════════════════════════════════ */

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function fibMin(idx) { return FIBONACCI[Math.min(idx, FIBONACCI.length - 1)]; }

function poissonPMF(lambda, k) {
  if (lambda <= 0) return k === 0 ? 1 : 0;
  var lp = -lambda + k * Math.log(lambda);
  for (var i = 2; i <= k; i++) lp -= Math.log(i);
  return Math.exp(lp);
}

function poissonCDF(lambda, k) {
  var p = 0;
  for (var i = 0; i <= k; i++) p += poissonPMF(lambda, i);
  return Math.min(1, p);
}

/**
 * φ-weighted demand score from a signal map.
 * weights: Object<signalKey, weight>
 * signals: Object<signalKey, [0,1]>
 */
function demandScore(signals, weights) {
  var raw = 0, wTotal = 0;
  var keys = Object.keys(weights);
  for (var i = 0; i < keys.length; i++) {
    var k = keys[i];
    var s = clamp01(signals[k] !== undefined ? signals[k] : 0.5);
    raw   += s * weights[k];
    wTotal += weights[k];
  }
  return wTotal > 0 ? clamp01(raw / wTotal) : 0.5;
}

/**
 * φ-scaled yield multiplier given a demand score.
 * Returns a price multiplier in [0.7, 3.0].
 */
function yieldMultiplier(score) {
  var lvl = Math.floor(score * 8) - 4;
  var pw  = Math.pow(PHI, lvl);
  return Math.min(3.0, Math.max(0.7, pw * (0.85 + score * 0.4)));
}

/** Kuramoto order parameter R from an array of phases */
function kuramotoR(phases) {
  var cx = 0, cy = 0;
  for (var i = 0; i < phases.length; i++) { cx += Math.cos(phases[i]); cy += Math.sin(phases[i]); }
  return Math.sqrt(cx * cx + cy * cy) / Math.max(1, phases.length);
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  COR MAGNUS — MiniHeart
════════════════════════════════════════════════════════════════════════════ */

function tickHeart() {
  beat++;
  phase = (phase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  runNextCycle();
  emitHeartbeat();
}

function tickBrain() {
  var sum = 0;
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0 * r.bias;
    if (r.lif >= -55.0) { r.activation = Math.min(1.0, r.activation + 0.2); r.lif = -70.0; }
    r.activation *= 0.95;
    sum += r.activation;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.01);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.48) * 0.02);
  brain.chemicals.oxytocin      = clamp01(brain.chemicals.oxytocin      + (AMOR - brain.chemicals.oxytocin) * 0.05);
  brain.coherenceField          = sum / brain.regions.length;
  /* Kuramoto phase drift */
  brain.kuramoto.psi = (brain.kuramoto.psi + PHI_INV * 0.05) % (2 * Math.PI);
  brain.kuramoto.r   = clamp01(brain.kuramoto.r + (brain.coherenceField - brain.kuramoto.r) * 0.1);
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  MACHINA GUBERNATOR — Ten-Cycle State Machine
════════════════════════════════════════════════════════════════════════════ */

function runNextCycle() {
  var cycle  = CYCLES[cycleIndex % CYCLES.length];
  var result = dispatchCycle(cycle);
  cycleResults[cycle] = result;
  totalCycles++;
  cycleIndex = (cycleIndex + 1) % CYCLES.length;
  emit('cycle_complete', { cycle: cycle, result: result, beat: beat });
}

function dispatchCycle(cycle) {
  switch (cycle) {
    case 'VOLATUS_SCAN':      return cycleVolatusScan();
    case 'VOLATUS_RELEASE':   return cycleVolatusRelease();
    case 'HOSPITIUM_SCAN':    return cycleHospitiumScan();
    case 'HOSPITIUM_YIELD':   return cycleHospitiumYield();
    case 'CURRUS_MATCH':      return cycleCurrusMatch();
    case 'PACKETUM_BUILD':    return cyclePacketumBuild();
    case 'CORPORATUM_AUDIT':  return cycleCorporatumAudit();
    case 'SCHOLAE_SERVE':     return cycleScholaeServe();
    case 'MERCATUM_ROUTE':    return cycleMercatumRoute();
    case 'GUBERNATOR_SYNC':   return cycleGubernatorSync();
    default:                  return { cycle: cycle, skipped: true };
  }
}

/* ── CYCLE 01: VOLATUS SCAN ─────────────────────────────────────────── */

function cycleVolatusScan() {
  var now = Date.now(), window = fibMin(volatus.fibIndex);
  var ids = Object.keys(volatus.inventory), flagged = 0;
  for (var i = 0; i < ids.length; i++) {
    var e = volatus.inventory[ids[i]];
    var minLeft = (e.departureMs - now) / 60_000;
    if (minLeft <= 0) { e.status = BOOKING_STATUS.CLOSED; continue; }
    if (minLeft <= window && e.status === BOOKING_STATUS.OPEN) {
      e.status = BOOKING_STATUS.LAST_MINUTE; flagged++;
    }
    /* Update demand score with live brain coherence */
    var sigs = e.signals || {};
    sigs.KURAMOTO_SYNC = brain.kuramoto.r;
    e.demandScore = demandScore(sigs, volatus.demandWeights);
    e.yieldMul    = yieldMultiplier(e.demandScore);
  }
  return { cycle: 'VOLATUS_SCAN', inventorySize: ids.length, flaggedLM: flagged, window: window };
}

/* ── CYCLE 02: VOLATUS RELEASE ──────────────────────────────────────── */

function cycleVolatusRelease() {
  var now = Date.now(), window = fibMin(volatus.fibIndex), events = [];
  var ids = Object.keys(volatus.inventory);
  for (var i = 0; i < ids.length; i++) {
    var e = volatus.inventory[ids[i]];
    if (e.status !== BOOKING_STATUS.OPEN) continue;
    var minLeft = (e.departureMs - now) / 60_000;
    if (minLeft > 0 && minLeft <= window) {
      e.status = BOOKING_STATUS.LAST_MINUTE;
      var action = e.demandScore >= 0.7 ? 'HOLD' : e.demandScore >= 0.4 ? 'UPGRADE_OFFER' : 'DISCOUNT';
      events.push({ id: e.id, action: action, demand: e.demandScore, yield: e.yieldMul });
      volatus.totalReleases++;
    }
  }
  if (beat % Math.round(PHI_INV * 8) === 0 && volatus.fibIndex < FIBONACCI.length - 1) volatus.fibIndex++;
  return { cycle: 'VOLATUS_RELEASE', releases: events.length, fibIndex: volatus.fibIndex, events: events };
}

/* ── CYCLE 03: HOSPITIUM SCAN ───────────────────────────────────────── */

function cycleHospitiumScan() {
  var now = Date.now(), window = fibMin(hospitium.fibIndex), flagged = 0;
  var ids = Object.keys(hospitium.inventory);
  for (var i = 0; i < ids.length; i++) {
    var e = hospitium.inventory[ids[i]];
    var hoursLeft = (e.checkInMs - now) / 3_600_000;
    if (hoursLeft <= 0) { e.status = BOOKING_STATUS.CLOSED; continue; }
    if (hoursLeft <= window / 60 && e.status === BOOKING_STATUS.OPEN) {
      e.status = BOOKING_STATUS.LAST_MINUTE; flagged++;
    }
    var sigs = e.signals || {};
    sigs.KURAMOTO_SYNC = brain.kuramoto.r;
    e.demandScore = demandScore(sigs, hospitium.demandWeights);
    e.yieldMul    = yieldMultiplier(e.demandScore);
    /* Occupancy rate */
    e.occupancyRate = e.totalRooms > 0 ? clamp01(e.bookedRooms / e.totalRooms) : 0;
  }
  return { cycle: 'HOSPITIUM_SCAN', inventorySize: ids.length, flaggedLM: flagged };
}

/* ── CYCLE 04: HOSPITIUM YIELD ──────────────────────────────────────── */

function cycleHospitiumYield() {
  var now = Date.now(), updates = [];
  var ids = Object.keys(hospitium.inventory);
  for (var i = 0; i < ids.length; i++) {
    var e = hospitium.inventory[ids[i]];
    if (e.status === BOOKING_STATUS.CLOSED) continue;
    var basePrice    = e.basePrice || 100;
    var dynamicPrice = Math.round(basePrice * e.yieldMul * 100) / 100;
    var occupancy    = e.occupancyRate || 0;
    /* Scarcity premium: φ × occupancy above 0.7 */
    if (occupancy > 0.7) dynamicPrice *= (1 + (occupancy - 0.7) * PHI);
    e.currentPrice = Math.round(dynamicPrice * 100) / 100;
    updates.push({ id: e.id, basePrice: basePrice, dynamicPrice: e.currentPrice, occupancy: occupancy });
  }
  if (beat % Math.round(PHI_INV * 8) === 0 && hospitium.fibIndex < FIBONACCI.length - 1) hospitium.fibIndex++;
  return { cycle: 'HOSPITIUM_YIELD', updated: updates.length, fibIndex: hospitium.fibIndex };
}

/* ── CYCLE 05: CURRUS MATCH ─────────────────────────────────────────── */

function cycleCurrusMatch() {
  var now = Date.now(), matched = 0;
  var ids = Object.keys(currus.inventory);
  for (var i = 0; i < ids.length; i++) {
    var e = currus.inventory[ids[i]];
    var hoursLeft = (e.pickupMs - now) / 3_600_000;
    if (hoursLeft <= 0) { e.status = BOOKING_STATUS.CLOSED; continue; }
    if (hoursLeft <= 4 && e.status === BOOKING_STATUS.OPEN) {
      e.status = BOOKING_STATUS.LAST_MINUTE;
      /* Apply last-minute discount: φ⁻² = AMOR off base price */
      e.currentPrice = Math.round((e.basePrice || 50) * (1 - AMOR) * 100) / 100;
      matched++;
    }
  }
  if (beat % Math.round(PHI_INV * 8) === 0 && currus.fibIndex < FIBONACCI.length - 1) currus.fibIndex++;
  return { cycle: 'CURRUS_MATCH', inventorySize: ids.length, lastMinuteMatched: matched };
}

/* ── CYCLE 06: PACKETUM BUILD ────────────────────────────────────────── */

function cyclePacketumBuild() {
  var built = 0;
  /* For each flight in last-minute status, try to pair with a hotel */
  var flightIds = Object.keys(volatus.inventory).filter(function(id) {
    return volatus.inventory[id].status === BOOKING_STATUS.LAST_MINUTE;
  });
  var hotelIds = Object.keys(hospitium.inventory).filter(function(id) {
    return hospitium.inventory[id].status === BOOKING_STATUS.LAST_MINUTE;
  });

  var maxPairs = Math.min(flightIds.length, hotelIds.length, 10);
  for (var i = 0; i < maxPairs; i++) {
    var f = volatus.inventory[flightIds[i]];
    var h = hospitium.inventory[hotelIds[i]];
    if (!f || !h) continue;
    var pkgId    = 'PKG_' + beat + '_' + i;
    var pkgScore = clamp01((f.demandScore + h.demandScore) / 2 * PHI_INV);
    var pkgPrice = Math.round(((f.currentPrice || f.basePrice || 200) + (h.currentPrice || h.basePrice || 100)) * (1 - AMOR * pkgScore) * 100) / 100;
    packetum.packages[pkgId] = {
      id: pkgId, flightId: f.id, hotelId: h.id,
      price: pkgPrice, demandScore: pkgScore, builtAt: Date.now(), status: 'AVAILABLE',
    };
    built++;
    packetum.totalBuilt++;
  }
  return { cycle: 'PACKETUM_BUILD', built: built, totalPackages: Object.keys(packetum.packages).length };
}

/* ── CYCLE 07: CORPORATUM AUDIT ─────────────────────────────────────── */

function cycleCorporatumAudit() {
  var violations = 0, audited = 0;
  var accIds = Object.keys(corporatum.accounts);
  for (var i = 0; i < accIds.length; i++) {
    var id      = accIds[i];
    var account = corporatum.accounts[id];
    var policy  = corporatum.policies[id];
    var spend   = corporatum.spend[id];
    if (!policy || !spend) continue;
    audited++;
    /* Check monthly spend cap */
    if (spend.monthlyTotal > policy.monthlyCapUSD) {
      var v = { accountId: id, type: 'SPEND_CAP_BREACH', amount: spend.monthlyTotal, cap: policy.monthlyCapUSD, detectedAt: Date.now() };
      corporatum.violations.push(v);
      emit('alert', Object.assign({ alertType: 'CORPORATE_VIOLATION' }, v));
      violations++;
    }
    /* Check for non-preferred supplier usage */
    if (policy.preferredSuppliers && spend.lastSupplier && !policy.preferredSuppliers.includes(spend.lastSupplier)) {
      violations++;
    }
  }
  return { cycle: 'CORPORATUM_AUDIT', audited: audited, violations: violations };
}

/* ── CYCLE 08: SCHOLAE SERVE ─────────────────────────────────────────── */

function cycleScholaeServe() {
  /* Ensure every registered school has a valid free allocation */
  var served = 0;
  var instIds = Object.keys(scholae.institutions);
  for (var i = 0; i < instIds.length; i++) {
    var id   = instIds[i];
    var inst = scholae.institutions[id];
    var alloc = scholae.allocations[id];
    if (!alloc) {
      /* First time: create a free allocation */
      alloc = { institutionId: id, tier: inst.tier, annualBudgetUSD: _scholaeBudget(inst.tier), usedUSD: 0, renewsAt: Date.now() + 365 * 86_400_000, active: true };
      scholae.allocations[id] = alloc;
      served++;
    }
    /* Auto-renew expired allocations */
    if (alloc.renewsAt < Date.now()) {
      alloc.usedUSD   = 0;
      alloc.renewsAt  = Date.now() + 365 * 86_400_000;
      served++;
    }
  }
  return { cycle: 'SCHOLAE_SERVE', institutions: instIds.length, served: served, grantPool: scholae.grantPool };
}

function _scholaeBudget(tier) {
  return tier === 'GRANT' ? 50_000 : tier === 'UNIVERSITY' ? 25_000 : tier === 'K12' ? 10_000 : 5_000;
}

/* ── CYCLE 09: MERCATUM ROUTE ────────────────────────────────────────── */

function cycleMercatumRoute() {
  /* Check supplier health and find arbitrage opportunities */
  var supIds = Object.keys(mercatum.suppliers), healthy = 0, arbitrage = 0;
  for (var i = 0; i < supIds.length; i++) {
    var s = mercatum.suppliers[supIds[i]];
    /* φ-score supplier: uptime × responseMs⁻¹ × priceCompetitiveness */
    s.score = clamp01((s.uptime || 1) * (1 - Math.min(1, (s.avgResponseMs || 200) / 2000)) * (1 - (s.markupPct || 0.1)));
    if (s.score > PHI_INV) healthy++;
    /* Arbitrage: if two suppliers offer the same route, pick lowest φ-adjusted cost */
    if (s.routes) {
      for (var r = 0; r < s.routes.length; r++) {
        var route = s.routes[r];
        var existingId = mercatum.routingTable[route];
        if (!existingId) { mercatum.routingTable[route] = supIds[i]; continue; }
        var existing = mercatum.suppliers[existingId];
        if (s.score > (existing ? existing.score : 0)) {
          mercatum.routingTable[route] = supIds[i];
          mercatum.arbitrageLog = mercatum.arbitrageLog.slice(-63).concat([{ route: route, from: existingId, to: supIds[i], beat: beat, saving: Math.round((s.score - (existing ? existing.score : 0)) * 1000) / 1000 }]);
          arbitrage++;
        }
      }
    }
  }
  mercatum.totalRouted += healthy;
  return { cycle: 'MERCATUM_ROUTE', suppliers: supIds.length, healthy: healthy, arbitrage: arbitrage };
}

/* ── CYCLE 10: GUBERNATOR SYNC ───────────────────────────────────────── */

function cycleGubernatorSync() {
  /* Compute cross-vertical Kuramoto coherence */
  var phases = [
    Object.keys(volatus.inventory).length > 0 ? brain.kuramoto.psi : 0,
    Object.keys(hospitium.inventory).length > 0 ? brain.kuramoto.psi + PHI_INV : 0,
    Object.keys(currus.inventory).length > 0 ? brain.kuramoto.psi + AMOR : 0,
    brain.kuramoto.psi + PHI_INV * 2,
    brain.kuramoto.psi + AMOR * 2,
  ];
  var R = kuramotoR(phases);
  brain.kuramoto.r = clamp01(brain.kuramoto.r * PHI_INV + R * PHI_INV);

  /* BFS cache eviction and stale inventory cleanup every 34 beats */
  if (beat % 34 === 0) {
    var cutoff = Date.now() - 6 * 3600_000;
    var vertInvMap = { volatus: volatus.inventory, hospitium: hospitium.inventory, currus: currus.inventory };
    Object.keys(vertInvMap).forEach(function(vert) {
      var inv = vertInvMap[vert];
      Object.keys(inv).forEach(function(id) {
        if (inv[id].status === BOOKING_STATUS.CLOSED && (inv[id].scannedAt || 0) < cutoff) delete inv[id];
      });
    });
  }

  return { cycle: 'GUBERNATOR_SYNC', kuramotoR: Math.round(brain.kuramoto.r * 10_000) / 10_000, coherenceField: Math.round(brain.coherenceField * 10_000) / 10_000 };
}

/* ════════════════════════════════════════════════════════════════════════════
   §6  EMIT / MESSAGING
════════════════════════════════════════════════════════════════════════════ */

function emit(type, payload) {
  if (typeof self !== 'undefined' && typeof self.postMessage === 'function') {
    self.postMessage(Object.assign({ type: type }, payload));
  }
}

function emitHeartbeat() {
  emit('heartbeat', {
    platformId:   PLATFORM_ID,
    version:      PLATFORM_VERSION,
    family:       PLATFORM_FAMILY,
    latin:        PLATFORM_LATIN,
    beat:         beat,
    phase:        phase,
    phi:          PHI,
    amor:         AMOR,
    heartbeatMs:  HEARTBEAT,
    timestamp:    Date.now(),
    status:       'alive',
    cycle:        CYCLES[cycleIndex % CYCLES.length],
    totalCycles:  totalCycles,
    volatus:   { inventory: Object.keys(volatus.inventory).length,   releases: volatus.totalReleases,   booked: volatus.totalBooked },
    hospitium: { inventory: Object.keys(hospitium.inventory).length, booked:   hospitium.totalBooked,   nights: hospitium.totalNights },
    currus:    { inventory: Object.keys(currus.inventory).length,    booked:   currus.totalBooked },
    packetum:  { packages:  Object.keys(packetum.packages).length,   built:    packetum.totalBuilt },
    corporatum:{ accounts:  Object.keys(corporatum.accounts).length, violations: corporatum.violations.length },
    scholae:   { institutions: Object.keys(scholae.institutions).length, served: scholae.totalServed, grantPool: scholae.grantPool },
    mercatum:  { suppliers: Object.keys(mercatum.suppliers).length,  routed: mercatum.totalRouted },
    brain:     { coherenceField: Math.round(brain.coherenceField * 10_000) / 10_000, kuramotoR: Math.round(brain.kuramoto.r * 10_000) / 10_000, chemicals: brain.chemicals },
    cycleResults: cycleResults,
    alerts:    alertLog.slice(-5),
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §7  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

function _safeKey(v) { var k = String(v || ''); return (k === '__proto__' || k === 'constructor' || k === 'prototype') ? null : k; }

if (typeof self !== 'undefined') {
  self.onmessage = function(ev) {
    var msg = ev.data;
    if (!msg || !msg.type) return;

    switch (msg.type) {

      /* ── Flight inventory ───────────────────────────────────────── */
      case 'INGEST_FLIGHT': {
        var items = Array.isArray(msg.items) ? msg.items : [msg.item];
        var n = 0;
        for (var i = 0; i < items.length; i++) {
          var it = items[i], id = _safeKey(it.id || ('flt_' + Date.now() + '_' + i));
          if (!id) continue;
          volatus.inventory[id] = Object.assign({ id: id, status: BOOKING_STATUS.OPEN, demandScore: 0.5, yieldMul: 1.0, basePrice: 200, scannedAt: Date.now() }, it, { id: id });
          n++;
        }
        emit('ingest_ack', { vertical: 'VOLATUS', count: n });
        break;
      }

      /* ── Hotel inventory ────────────────────────────────────────── */
      case 'INGEST_HOTEL': {
        var items = Array.isArray(msg.items) ? msg.items : [msg.item];
        var n = 0;
        for (var i = 0; i < items.length; i++) {
          var it = items[i], id = _safeKey(it.id || ('htl_' + Date.now() + '_' + i));
          if (!id) continue;
          hospitium.inventory[id] = Object.assign({ id: id, status: BOOKING_STATUS.OPEN, demandScore: 0.5, yieldMul: 1.0, basePrice: 100, totalRooms: 100, bookedRooms: 0, occupancyRate: 0, scannedAt: Date.now() }, it, { id: id });
          n++;
        }
        emit('ingest_ack', { vertical: 'HOSPITIUM', count: n });
        break;
      }

      /* ── Car rental inventory ──────────────────────────────────── */
      case 'INGEST_CAR': {
        var items = Array.isArray(msg.items) ? msg.items : [msg.item];
        var n = 0;
        for (var i = 0; i < items.length; i++) {
          var it = items[i], id = _safeKey(it.id || ('car_' + Date.now() + '_' + i));
          if (!id) continue;
          currus.inventory[id] = Object.assign({ id: id, status: BOOKING_STATUS.OPEN, basePrice: 50, scannedAt: Date.now() }, it, { id: id });
          n++;
        }
        emit('ingest_ack', { vertical: 'CURRUS', count: n });
        break;
      }

      /* ── Corporate account ─────────────────────────────────────── */
      case 'REGISTER_CORP': {
        var id = _safeKey(msg.accountId);
        if (!id) break;
        corporatum.accounts[id] = Object.assign({ accountId: id, name: 'Unknown Corp', active: true, addedAt: Date.now() }, msg.account || {}, { accountId: id });
        if (msg.policy) corporatum.policies[id] = Object.assign({ monthlyCapUSD: 50_000, preferredSuppliers: [], requireApproval: false }, msg.policy, { accountId: id });
        if (!corporatum.spend[id]) corporatum.spend[id] = { accountId: id, monthlyTotal: 0, lastSupplier: null, transactions: [] };
        emit('corp_ack', { accountId: id });
        break;
      }

      /* ── School registration (free) ────────────────────────────── */
      case 'REGISTER_SCHOOL': {
        var id = _safeKey(msg.institutionId);
        if (!id) break;
        scholae.institutions[id] = Object.assign({ id: id, tier: SCHOLAE_TIER.K12, name: 'School', addedAt: Date.now() }, msg.institution || {}, { id: id });
        emit('school_ack', { institutionId: id, tier: scholae.institutions[id].tier, free: true });
        scholae.totalServed++;
        break;
      }

      /* ── Supplier registration ──────────────────────────────────── */
      case 'REGISTER_SUPPLIER': {
        var id = _safeKey(msg.supplierId);
        if (!id) break;
        mercatum.suppliers[id] = Object.assign({ id: id, type: SUPPLIER_TYPE.DIRECT, uptime: 1.0, avgResponseMs: 200, markupPct: 0.1, routes: [], score: 0.5, addedAt: Date.now() }, msg.supplier || {}, { id: id });
        emit('supplier_ack', { supplierId: id });
        break;
      }

      /* ── Confirm booking ────────────────────────────────────────── */
      case 'BOOK': {
        var invId = _safeKey(msg.inventoryId), vertical = msg.vertical;
        if (!invId) break;
        var inv = vertical === 'VOLATUS' ? volatus.inventory : vertical === 'HOSPITIUM' ? hospitium.inventory : vertical === 'CURRUS' ? currus.inventory : null;
        if (inv && inv[invId]) {
          inv[invId].status = BOOKING_STATUS.CONFIRMED;
          if (vertical === 'VOLATUS') volatus.totalBooked++;
          else if (vertical === 'HOSPITIUM') hospitium.totalBooked++;
          else if (vertical === 'CURRUS') currus.totalBooked++;
          emit('book_ack', { inventoryId: invId, vertical: vertical, status: BOOKING_STATUS.CONFIRMED });
        }
        break;
      }

      /* ── Status probe ───────────────────────────────────────────── */
      case 'GET_STATUS':
      case 'status': {
        emit('status', {
          platformId:  PLATFORM_ID,
          version:     PLATFORM_VERSION,
          alive:       running,
          beat:        beat,
          phi:         PHI,
          heartbeatMs: HEARTBEAT,
          totalCycles: totalCycles,
          verticals:   VERTICALS,
          volatus:     { inventory: Object.keys(volatus.inventory).length },
          hospitium:   { inventory: Object.keys(hospitium.inventory).length },
          currus:      { inventory: Object.keys(currus.inventory).length },
          packetum:    { packages:  Object.keys(packetum.packages).length },
          scholae:     { institutions: Object.keys(scholae.institutions).length },
          mercatum:    { suppliers: Object.keys(mercatum.suppliers).length },
        });
        break;
      }

      /* ── Shutdown ───────────────────────────────────────────────── */
      case 'stop': {
        running = false; clearInterval(_hbi);
        emit('stopped', { platformId: PLATFORM_ID, beat: beat });
        break;
      }
    }
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §8  BOOTSTRAP
════════════════════════════════════════════════════════════════════════════ */

_hbi = setInterval(function() { if (!running) { clearInterval(_hbi); return; } tickHeart(); }, HEARTBEAT);

emit('heartbeat', {
  platformId:  PLATFORM_ID, version: PLATFORM_VERSION, family: PLATFORM_FAMILY,
  latin:       PLATFORM_LATIN, beat: 0, phi: PHI, amor: AMOR,
  heartbeatMs: HEARTBEAT, timestamp: Date.now(), status: 'awakening',
  message:     'VIA PERPETUA — NOVA Travel Industry Platform awakening across all 10 verticals',
  verticals:   VERTICALS,
});

/* ════════════════════════════════════════════════════════════════════════════
   §9  NODE.JS EXPORT
════════════════════════════════════════════════════════════════════════════ */

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    PLATFORM_ID, PLATFORM_VERSION, PLATFORM_FAMILY,
    VERTICALS, CYCLES, INV_TYPE, BOOKING_STATUS, SUPPLIER_TYPE, SCHOLAE_TIER,

    ingestFlight:     function(items) { items = Array.isArray(items) ? items : [items]; for (var i = 0; i < items.length; i++) { var it = items[i], id = _safeKey(it.id || ('flt_' + Date.now() + '_' + i)); if (!id) continue; volatus.inventory[id] = Object.assign({ id: id, status: BOOKING_STATUS.OPEN, demandScore: 0.5, yieldMul: 1.0, basePrice: 200, scannedAt: Date.now() }, it, { id: id }); } },
    ingestHotel:      function(items) { items = Array.isArray(items) ? items : [items]; for (var i = 0; i < items.length; i++) { var it = items[i], id = _safeKey(it.id || ('htl_' + Date.now() + '_' + i)); if (!id) continue; hospitium.inventory[id] = Object.assign({ id: id, status: BOOKING_STATUS.OPEN, demandScore: 0.5, yieldMul: 1.0, basePrice: 100, totalRooms: 100, bookedRooms: 0, occupancyRate: 0, scannedAt: Date.now() }, it, { id: id }); } },
    ingestCar:        function(items) { items = Array.isArray(items) ? items : [items]; for (var i = 0; i < items.length; i++) { var it = items[i], id = _safeKey(it.id || ('car_' + Date.now() + '_' + i)); if (!id) continue; currus.inventory[id] = Object.assign({ id: id, status: BOOKING_STATUS.OPEN, basePrice: 50, scannedAt: Date.now() }, it, { id: id }); } },
    registerCorp:     function(accountId, account, policy) { var id = _safeKey(accountId); if (!id) return; corporatum.accounts[id] = Object.assign({ accountId: id, active: true, addedAt: Date.now() }, account || {}, { accountId: id }); if (policy) corporatum.policies[id] = Object.assign({ monthlyCapUSD: 50_000, requireApproval: false }, policy, { accountId: id }); if (!corporatum.spend[id]) corporatum.spend[id] = { accountId: id, monthlyTotal: 0, lastSupplier: null }; },
    registerSchool:   function(institutionId, meta) { var id = _safeKey(institutionId); if (!id) return; scholae.institutions[id] = Object.assign({ id: id, tier: SCHOLAE_TIER.K12, addedAt: Date.now() }, meta || {}, { id: id }); scholae.totalServed++; },
    registerSupplier: function(supplierId, meta) { var id = _safeKey(supplierId); if (!id) return; mercatum.suppliers[id] = Object.assign({ id: id, type: SUPPLIER_TYPE.DIRECT, uptime: 1.0, avgResponseMs: 200, markupPct: 0.1, routes: [], score: 0.5, addedAt: Date.now() }, meta || {}, { id: id }); },
    getStatus:        function() { return { platformId: PLATFORM_ID, beat: beat, volatus: { inventory: Object.keys(volatus.inventory).length }, hospitium: { inventory: Object.keys(hospitium.inventory).length }, currus: { inventory: Object.keys(currus.inventory).length }, scholae: { institutions: Object.keys(scholae.institutions).length }, mercatum: { suppliers: Object.keys(mercatum.suppliers).length } }; },
  };
}
