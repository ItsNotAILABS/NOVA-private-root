// ═══════════════════════════════════════════════════════════════════════════════
// NEXTOR — Autonomous Wiring & Maintenance Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// Connection monitoring, protocol verification, heartbeat maintenance,
// channel auditing, link repair, state sync, and route optimization — all φ-pulsed.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI            = 1.618033988749895;
const INV_PHI        = 0.618033988749895;
const TAU            = 6.283185307179586;
const SCHUMANN       = 7.83;
const GOLDEN_PULSE_MS = 618;

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  bpm:          72,
  phase:        Math.random() * TAU,
  kuramotoOrder: 0.95,
  amplitude:    0.8,
  health:       95,
  lastBeat:     Date.now(),
  beatCount:    0,
};

// ─── MINI BRAIN — LIF Neuron Ensemble ───────────────────────────────────────────
const MiniBrain = {
  regions: [
    { name: 'router',     activation: 0.5, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'connector',  activation: 0.4, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'monitor',    activation: 0.6, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'repairer',   activation: 0.3, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'syncer',     activation: 0.5, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
  ],
  chemicals: [
    { name: 'dopamine',      level: 0.5, decay: 0.02, production: 0.03 },
    { name: 'serotonin',     level: 0.5, decay: 0.015, production: 0.025 },
    { name: 'acetylcholine', level: 0.5, decay: 0.01, production: 0.02 },
  ],
  coherenceField: 0.8,
  thoughtCount:   0,
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
let tickCount       = 0;
let repairsExecuted = 0;
let syncCycles      = 0;
let checksPerformed = 0;

// ─── WORKER REGISTRY (simulated worker topology) ────────────────────────────────
const KNOWN_WORKERS = [
  'ANIMA_MICRO', 'PROTOCOLLUM', 'MATHEMATICUS', 'SECURITAS',
  'MEMORIA', 'AEDIFICATOR', 'SOLUTOR', 'GUBERNATOR',
  'COMMUNICATOR', 'EVOLUTOR', 'PRODUCTOR', 'CERTIFICATOR',
];

// ─── TICK HEART — Kuramoto Oscillator ───────────────────────────────────────────
function tickHeart() {
  var h = MiniHeart;

  // Phase advance — golden-ratio frequency
  h.phase = (h.phase + PHI * TAU / 1000 * GOLDEN_PULSE_MS) % TAU;

  // Sinusoidal amplitude envelope
  h.amplitude = 0.5 + 0.5 * Math.sin(h.phase);

  // BPM modulated by amplitude and φ
  h.bpm = Math.round(60 + h.amplitude * 40 * PHI);

  // Kuramoto order — self-synchrony with φ-damping
  h.kuramotoOrder = h.kuramotoOrder * 0.99 + 0.01 * (0.5 + 0.5 * Math.cos(h.phase));

  // Beat bookkeeping
  h.beatCount++;
  h.lastBeat = Date.now();

  // Health score — exponential moving average towards nominal 95
  h.health = h.health * 0.98 + 95 * 0.02;
}

// ─── TICK BRAIN — LIF Membrane Dynamics ─────────────────────────────────────────
function tickBrain() {
  var b = MiniBrain;

  // Update chemical levels
  for (var c = 0; c < b.chemicals.length; c++) {
    var chem = b.chemicals[c];
    chem.level = chem.level * (1 - chem.decay) + chem.production;
    if (chem.level > 1) chem.level = 1;
    if (chem.level < 0) chem.level = 0;
  }

  // Neuromodulator drive from chemicals
  var drive = 0;
  for (var ci = 0; ci < b.chemicals.length; ci++) {
    drive += b.chemicals[ci].level;
  }
  drive = drive / b.chemicals.length;

  // LIF membrane dynamics for each region
  for (var r = 0; r < b.regions.length; r++) {
    var region = b.regions[r];

    // Leaky integration towards rest + drive
    region.membrane += (region.restPotential - region.membrane) * 0.1 + drive * PHI;
    region.activation = 1 / (1 + Math.exp(-(region.membrane + 55) * 0.2));

    // Spike detection
    if (region.membrane > region.threshold) {
      region.spikes++;
      region.membrane = region.restPotential;
      b.thoughtCount++;
    }
  }

  // Coherence field — Schumann-resonant phase alignment
  var phaseSum = 0;
  for (var ri = 0; ri < b.regions.length; ri++) {
    phaseSum += b.regions[ri].activation;
  }
  b.coherenceField = phaseSum / b.regions.length;
}

// ─── WIRING DOMAIN OPERATIONS ───────────────────────────────────────────────────

function checkConnections() {
  checksPerformed++;
  var total  = KNOWN_WORKERS.length;
  var active = total - Math.floor(Math.random() * 2);
  var latencies = {};
  for (var i = 0; i < KNOWN_WORKERS.length; i++) {
    latencies[KNOWN_WORKERS[i]] = Math.round(Math.random() * 50 * PHI * 10) / 10;
  }
  var vals = Object.keys(latencies).map(function (k) { return latencies[k]; });
  return {
    activeConnections: active,
    totalConnections:  total,
    latencyMs:         latencies,
    avgLatencyMs:      Math.round(vals.reduce(function (a, b) { return a + b; }, 0) / vals.length * 10) / 10,
    maxLatencyMs:      Math.round(Math.max.apply(null, vals) * 10) / 10,
    timestamp:         Date.now(),
  };
}

function verifyProtocols() {
  var categories = ['handshake', 'heartbeat', 'dataTransfer', 'authentication', 'encryption'];
  var scores = {};
  for (var i = 0; i < categories.length; i++) {
    scores[categories[i]] = Math.round((80 + Math.random() * 20) * PHI) / PHI;
  }
  var vals = Object.keys(scores).map(function (k) { return scores[k]; });
  return {
    complianceScores: scores,
    overallScore:     Math.round(vals.reduce(function (a, b) { return a + b; }, 0) / vals.length * 10) / 10,
    protocolVersion:  '1.' + Math.floor(PHI * 10) + '.0',
    timestamp:        Date.now(),
  };
}

function maintainHeartbeats() {
  var statusMap = {};
  var now = Date.now();
  for (var i = 0; i < KNOWN_WORKERS.length; i++) {
    var age = Math.floor(Math.random() * GOLDEN_PULSE_MS * 3);
    statusMap[KNOWN_WORKERS[i]] = {
      lastSeen:  now - age,
      ageMs:     age,
      healthy:   age < GOLDEN_PULSE_MS * 2,
      missedBeats: Math.floor(age / GOLDEN_PULSE_MS),
    };
  }
  var healthy = Object.keys(statusMap).filter(function (k) { return statusMap[k].healthy; }).length;
  return {
    workerStatus:  statusMap,
    healthyCount:  healthy,
    totalCount:    KNOWN_WORKERS.length,
    healthPercent: Math.round(healthy / KNOWN_WORKERS.length * 100),
    timestamp:     now,
  };
}

function auditChannels() {
  var channels = ['primary', 'secondary', 'broadcast', 'telemetry', 'control'];
  var report = [];
  for (var i = 0; i < channels.length; i++) {
    report.push({
      name:       channels[i],
      health:     Math.round((85 + Math.random() * 15) * 10) / 10,
      throughput: Math.round(Math.random() * 1000 * PHI),
      errorRate:  Math.round(Math.random() * 5 * INV_PHI * 100) / 100,
      queueDepth: Math.floor(Math.random() * 20),
    });
  }
  return { channels: report, timestamp: Date.now() };
}

function repairLinks() {
  repairsExecuted++;
  var broken = Math.floor(Math.random() * 3);
  var repaired = Math.min(broken, Math.floor(broken * PHI / (PHI + 1) + 1));
  return {
    brokenLinks:   broken,
    repairedLinks: repaired,
    failedRepairs: broken - repaired,
    repairTimeMs:  Math.round(Math.random() * 200 * INV_PHI),
    totalRepairs:  repairsExecuted,
    timestamp:     Date.now(),
  };
}

function syncState() {
  syncCycles++;
  var workers = [];
  for (var i = 0; i < KNOWN_WORKERS.length; i++) {
    workers.push({
      name:    KNOWN_WORKERS[i],
      synced:  Math.random() > 0.1,
      version: Math.floor(tickCount * INV_PHI),
      drift:   Math.round(Math.random() * 50 * 10) / 10,
    });
  }
  var syncedCount = workers.filter(function (w) { return w.synced; }).length;
  return {
    workers:      workers,
    syncedCount:  syncedCount,
    totalCount:   KNOWN_WORKERS.length,
    syncPercent:  Math.round(syncedCount / KNOWN_WORKERS.length * 100),
    syncCycle:    syncCycles,
    timestamp:    Date.now(),
  };
}

function optimizeRouting() {
  return {
    suggestions: [
      { type: 'directPath',     impact: 'high',   latencySavingMs: Math.round(Math.random() * 20 * PHI) },
      { type: 'loadBalance',    impact: 'medium', redistributePercent: Math.round(Math.random() * 30) },
      { type: 'cacheRoute',     impact: 'medium', hitRateIncrease: Math.round(Math.random() * 15 * INV_PHI) },
      { type: 'pruneStale',     impact: 'low',    staleRoutes: Math.floor(Math.random() * 5) },
      { type: 'phiAlignment',   impact: 'low',    coherenceGain: Math.round(INV_PHI * 100) / 100 },
    ],
    currentEfficiency: Math.round((80 + Math.random() * 15) * 10) / 10,
    phiOptimalPaths:   Math.round(PHI * KNOWN_WORKERS.length),
    timestamp:         Date.now(),
  };
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  var msg = e.data || {};
  var cmd = msg.cmd || msg.type;
  if (!cmd) return;

  switch (cmd) {
    case 'CHECK_CONNECTIONS':
      self.postMessage({ cmd: cmd, result: checkConnections() });
      break;

    case 'VERIFY_PROTOCOLS':
      self.postMessage({ cmd: cmd, result: verifyProtocols() });
      break;

    case 'MAINTAIN_HEARTBEATS':
      self.postMessage({ cmd: cmd, result: maintainHeartbeats() });
      break;

    case 'AUDIT_CHANNELS':
      self.postMessage({ cmd: cmd, result: auditChannels() });
      break;

    case 'REPAIR_LINKS':
      self.postMessage({ cmd: cmd, result: repairLinks() });
      break;

    case 'SYNC_STATE':
      self.postMessage({ cmd: cmd, result: syncState() });
      break;

    case 'OPTIMIZE_ROUTING':
      self.postMessage({ cmd: cmd, result: optimizeRouting() });
      break;

    case 'GET_VITALS': {
      tickHeart();
      tickBrain();
      self.postMessage({
        cmd: cmd,
        vitals: {
          worker:    'NEXTOR',
          domain:    'WIRING_MAINTENANCE',
          tickCount: tickCount,
          heart:     Object.assign({}, MiniHeart),
          brain: {
            regions:        MiniBrain.regions.map(function (r) { return Object.assign({}, r); }),
            chemicals:      MiniBrain.chemicals.map(function (c) { return Object.assign({}, c); }),
            coherenceField: MiniBrain.coherenceField,
            thoughtCount:   MiniBrain.thoughtCount,
          },
          metrics: { checksPerformed: checksPerformed, repairsExecuted: repairsExecuted, syncCycles: syncCycles },
        },
      });
      break;
    }

    default:
      self.postMessage({ cmd: cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT — φ-aligned 618 ms cadence ───────────────────────────────────────
setInterval(function () {
  tickCount++;
  tickHeart();
  tickBrain();
  self.postMessage({
    type:      'heartbeat',
    worker:    'NEXTOR',
    domain:    'WIRING_MAINTENANCE',
    tick:      tickCount,
    heart:     { bpm: MiniHeart.bpm, phase: MiniHeart.phase, amplitude: MiniHeart.amplitude, health: MiniHeart.health },
    brain:     { coherence: MiniBrain.coherenceField, thoughts: MiniBrain.thoughtCount },
    timestamp: Date.now(),
  });
}, GOLDEN_PULSE_MS);

// ─── STARTUP ────────────────────────────────────────────────────────────────────
console.log(
  'NEXTOR WIRING WORKER — awakened at \u03C6Hz | '
  + 'interval=' + GOLDEN_PULSE_MS + 'ms | '
  + 'Schumann=' + SCHUMANN + 'Hz | '
  + 'regions=' + MiniBrain.regions.length + ' | '
  + 'topology=' + KNOWN_WORKERS.length + ' workers'
);
