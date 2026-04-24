/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Heartbeat Worker (GOK-HEARTBEAT-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-HEARTBEAT-001
 * Kernel Family:  SYSTEM_PULSE
 * Architecture:   Pulse Coordinator × Cascade Detection × Kuramoto Sync × Recovery
 *
 * Master pulse coordinator for the NOVA organism. Tracks heartbeats from all
 * 30+ workers, detects cascade failures, monitors Kuramoto phase
 * synchronization, computes organism-wide coherence, and orchestrates
 * recovery for failed workers. This is the organism's master clock.
 *
 * Features:
 *   • Master pulse coordinator: tracks all 30+ worker heartbeats
 *   • Cascade detection: 3+ failures within 5 beats triggers cascade alert
 *   • Liveness probes: configurable per-worker liveness checks
 *   • Phase synchronization: Kuramoto sync monitoring across all workers
 *   • Organism-wide coherence score (aggregate of all worker phases)
 *   • Recovery orchestration: restart recommendations for failed workers
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'register-worker', workerId, config }
 *   Main → Worker: { type: 'worker-beat', workerId, phase, timestamp }
 *   Main → Worker: { type: 'check-liveness', workerId }
 *   Main → Worker: { type: 'cascade-status' }
 *   Main → Worker: { type: 'coherence' }
 *   Main → Worker: { type: 'recovery-plan', workerId }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'worker-registered', workerId }
 *   Worker → Main: { type: 'beat-ack', workerId }
 *   Worker → Main: { type: 'liveness-result', workerId, alive }
 *   Worker → Main: { type: 'cascade-report', cascadeActive, details }
 *   Worker → Main: { type: 'coherence-report', score, breakdown }
 *   Worker → Main: { type: 'recovery-recommendation', workerId, actions }
 *   Worker → Main: { type: 'heartbeat', ... }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * MEDINA TECH — SOVEREIGN KERNEL ARCHITECTURE
 */


/* ════════════════════════════════════════════════════════════════
   KERNEL CONSTANTS
   ════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var KERNEL_ID      = 'GOK-HEARTBEAT-001';
var KERNEL_FAMILY  = 'SYSTEM_PULSE';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;

var CASCADE_THRESHOLD  = 3;   // Failures needed for cascade
var CASCADE_WINDOW     = 5;   // Beat window for cascade detection
var LIVENESS_TIMEOUT   = 3;   // Beats before declaring dead


/* ════════════════════════════════════════════════════════════════
   WORKER REGISTRY
   ════════════════════════════════════════════════════════════════ */

var workers = {};   // workerId → worker state

function registerWorker(workerId, config) {
  config = config || {};
  var w = {
    id: workerId,
    name: config.name || workerId,
    family: config.family || 'unknown',
    phase: 0.0,
    lastBeat: Date.now(),
    lastBeatNumber: 0,
    beatCount: 0,
    missedBeats: 0,
    alive: true,
    status: 'registered',
    livenessTimeout: config.livenessTimeout || LIVENESS_TIMEOUT,
    registeredAt: Date.now(),
    deathHistory: [],
  };
  workers[workerId] = w;
  return w;
}


/* ════════════════════════════════════════════════════════════════
   BEAT PROCESSING
   ════════════════════════════════════════════════════════════════ */

function processWorkerBeat(workerId, phase, timestamp) {
  var w = workers[workerId];
  if (!w) {
    w = registerWorker(workerId, {});
  }

  w.lastBeat = timestamp || Date.now();
  w.lastBeatNumber = beatCount;
  w.beatCount++;
  w.missedBeats = 0;
  w.alive = true;
  w.status = 'alive';

  if (typeof phase === 'number') {
    w.phase = phase;
  }

  return { workerId: workerId, alive: true, beatCount: w.beatCount };
}


/* ════════════════════════════════════════════════════════════════
   LIVENESS PROBES
   ════════════════════════════════════════════════════════════════ */

function checkLiveness(workerId) {
  if (workerId) {
    var w = workers[workerId];
    if (!w) return { success: false, error: 'Unknown worker: ' + workerId };
    return { success: true, result: computeLiveness(w) };
  }
  // Check all workers
  var results = [];
  var ids = Object.keys(workers);
  for (var i = 0; i < ids.length; i++) {
    results.push(computeLiveness(workers[ids[i]]));
  }
  return { success: true, results: results, count: results.length };
}

function computeLiveness(w) {
  var now = Date.now();
  var elapsed = now - w.lastBeat;
  var missedBeats = Math.floor(elapsed / HEARTBEAT);
  var alive = missedBeats <= w.livenessTimeout;

  w.missedBeats = missedBeats;
  w.alive = alive;
  w.status = alive ? 'alive' : (missedBeats > w.livenessTimeout * 2 ? 'dead' : 'unresponsive');

  if (!alive && w.deathHistory.length === 0 || (!alive && w.deathHistory[w.deathHistory.length - 1].recoveredAt !== null)) {
    w.deathHistory.push({ detectedAt: now, missedBeats: missedBeats, recoveredAt: null });
    if (w.deathHistory.length > 50) w.deathHistory = w.deathHistory.slice(-40);
  }

  return {
    workerId: w.id,
    name: w.name,
    alive: alive,
    status: w.status,
    missedBeats: missedBeats,
    lastBeat: w.lastBeat,
    phase: w.phase,
    totalBeats: w.beatCount,
    deathCount: w.deathHistory.length,
  };
}

// Run on each heartbeat to update all workers
function sweepLiveness() {
  var ids = Object.keys(workers);
  for (var i = 0; i < ids.length; i++) {
    computeLiveness(workers[ids[i]]);
  }
}


/* ════════════════════════════════════════════════════════════════
   CASCADE DETECTION
   ════════════════════════════════════════════════════════════════ */

var cascadeEvents  = [];   // [{beat, workerId, timestamp}, …]
var cascadeActive  = false;
var cascadeStarted = 0;

function detectCascade() {
  // Prune old events outside the window
  var cutoff = beatCount - CASCADE_WINDOW;
  var pruned = [];
  for (var i = 0; i < cascadeEvents.length; i++) {
    if (cascadeEvents[i].beat >= cutoff) pruned.push(cascadeEvents[i]);
  }
  cascadeEvents = pruned;

  // Count unique failed workers in the window
  var failedWorkers = {};
  for (var j = 0; j < cascadeEvents.length; j++) {
    failedWorkers[cascadeEvents[j].workerId] = true;
  }
  var failCount = Object.keys(failedWorkers).length;

  var wasCascade = cascadeActive;
  cascadeActive = failCount >= CASCADE_THRESHOLD;

  if (cascadeActive && !wasCascade) {
    cascadeStarted = Date.now();
    self.postMessage({
      type: 'cascade-alert',
      cascadeActive: true,
      failedWorkers: Object.keys(failedWorkers),
      failCount: failCount,
      window: CASCADE_WINDOW,
      threshold: CASCADE_THRESHOLD,
      kernelId: KERNEL_ID,
    });
  }

  return {
    cascadeActive: cascadeActive,
    failCount: failCount,
    failedWorkers: Object.keys(failedWorkers),
    window: CASCADE_WINDOW,
    threshold: CASCADE_THRESHOLD,
    events: cascadeEvents.length,
    cascadeStarted: cascadeActive ? cascadeStarted : null,
  };
}

function recordFailure(workerId) {
  cascadeEvents.push({
    beat: beatCount,
    workerId: workerId,
    timestamp: Date.now(),
  });
}

// Check for new failures each heartbeat
function sweepFailures() {
  var ids = Object.keys(workers);
  for (var i = 0; i < ids.length; i++) {
    var w = workers[ids[i]];
    if (!w.alive && w.missedBeats === w.livenessTimeout + 1) {
      recordFailure(ids[i]);
    }
  }
  detectCascade();
}


/* ════════════════════════════════════════════════════════════════
   KURAMOTO PHASE SYNCHRONIZATION
   ════════════════════════════════════════════════════════════════ */

function computeCoherence() {
  var ids = Object.keys(workers);
  if (ids.length === 0) {
    return { score: 1.0, breakdown: [], workerCount: 0, orderParameter: 1.0 };
  }

  // Kuramoto order parameter: r = |1/N Σ e^(i·θ_k)|
  var sumCos = 0;
  var sumSin = 0;
  var breakdown = [];
  var aliveCount = 0;

  for (var i = 0; i < ids.length; i++) {
    var w = workers[ids[i]];
    var theta = w.phase;
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
    if (w.alive) aliveCount++;

    // Phase deviation from master (this worker's phase)
    var deviation = angleDiff(theta, kernelPhase);

    breakdown.push({
      workerId: w.id,
      name: w.name,
      phase: Math.round(w.phase * 1000) / 1000,
      deviation: Math.round(deviation * 1000) / 1000,
      alive: w.alive,
      syncScore: Math.round((1.0 - Math.abs(deviation) / Math.PI) * 1000) / 1000,
    });
  }

  var n = ids.length;
  var orderParameter = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
  var meanPhase = Math.atan2(sumSin / n, sumCos / n);
  if (meanPhase < 0) meanPhase += 2 * Math.PI;

  // Coherence score combines order parameter, alive ratio, and phi weighting
  var aliveRatio = n > 0 ? aliveCount / n : 1.0;
  var coherenceScore = (orderParameter * PHI + aliveRatio) / (PHI + 1);

  return {
    score: Math.round(coherenceScore * 10000) / 10000,
    orderParameter: Math.round(orderParameter * 10000) / 10000,
    meanPhase: Math.round(meanPhase * 1000) / 1000,
    masterPhase: Math.round(kernelPhase * 1000) / 1000,
    aliveCount: aliveCount,
    totalWorkers: n,
    aliveRatio: Math.round(aliveRatio * 10000) / 10000,
    breakdown: breakdown,
    computedAt: Date.now(),
    computedBy: KERNEL_ID,
  };
}

function angleDiff(a, b) {
  var d = a - b;
  while (d > Math.PI) d -= 2 * Math.PI;
  while (d < -Math.PI) d += 2 * Math.PI;
  return d;
}


/* ════════════════════════════════════════════════════════════════
   RECOVERY ORCHESTRATION
   ════════════════════════════════════════════════════════════════ */

function recoveryPlan(workerId) {
  if (workerId) {
    var w = workers[workerId];
    if (!w) return { success: false, error: 'Unknown worker: ' + workerId };
    return { success: true, plan: buildRecoveryPlan(w) };
  }

  // Generate plans for all unhealthy workers
  var plans = [];
  var ids = Object.keys(workers);
  for (var i = 0; i < ids.length; i++) {
    var wrk = workers[ids[i]];
    if (!wrk.alive) {
      plans.push(buildRecoveryPlan(wrk));
    }
  }
  return { success: true, plans: plans, count: plans.length };
}

function buildRecoveryPlan(w) {
  var actions = [];
  var priority = 'low';

  if (w.status === 'dead') {
    actions.push({ step: 1, action: 'terminate', detail: 'Terminate unresponsive worker process' });
    actions.push({ step: 2, action: 'restart', detail: 'Spawn new worker instance' });
    actions.push({ step: 3, action: 'verify', detail: 'Wait for first heartbeat within ' + (LIVENESS_TIMEOUT * HEARTBEAT) + 'ms' });
    priority = 'critical';
  } else if (w.status === 'unresponsive') {
    actions.push({ step: 1, action: 'ping', detail: 'Send status probe to worker' });
    actions.push({ step: 2, action: 'wait', detail: 'Allow ' + (w.livenessTimeout * HEARTBEAT) + 'ms for recovery' });
    actions.push({ step: 3, action: 'restart', detail: 'Restart if still unresponsive' });
    priority = 'high';
  } else {
    actions.push({ step: 1, action: 'monitor', detail: 'Continue monitoring; no action needed' });
  }

  // Check for repeated failures
  if (w.deathHistory.length >= 3) {
    actions.push({ step: actions.length + 1, action: 'investigate', detail: 'Worker has died ' + w.deathHistory.length + ' times; investigate root cause' });
    if (priority !== 'critical') priority = 'high';
  }

  // Add cascade context if active
  if (cascadeActive) {
    actions.push({ step: actions.length + 1, action: 'cascade-aware', detail: 'Cascade failure active; coordinate restart order via dependency graph' });
  }

  return {
    workerId: w.id,
    workerName: w.name,
    currentStatus: w.status,
    priority: priority,
    actions: actions,
    actionCount: actions.length,
    missedBeats: w.missedBeats,
    deathCount: w.deathHistory.length,
    planCreatedAt: Date.now(),
    planCreatedBy: KERNEL_ID,
  };
}


/* ════════════════════════════════════════════════════════════════
   DEFAULT WORKER REGISTRATIONS (30+)
   ════════════════════════════════════════════════════════════════ */

var DEFAULT_WORKERS = [
  { id: 'GOK-ENGINE-001',     name: 'Engine Worker',       family: 'REASONING' },
  { id: 'GOK-MEMORY-001',     name: 'Memory Worker',       family: 'MEMORY' },
  { id: 'GOK-ROUTING-001',    name: 'Routing Worker',      family: 'ROUTING' },
  { id: 'GOK-CRYPTO-001',     name: 'Crypto Worker',       family: 'SOVEREIGN_CRYPTO' },
  { id: 'GOK-TELEMETRY-001',  name: 'Telemetry Worker',    family: 'IMMUNE_SYSTEM' },
  { id: 'GOK-DOWNLOAD-001',   name: 'Download Worker',     family: 'DOWNLOAD' },
  { id: 'GOK-LEARNING-001',   name: 'Learning Worker',     family: 'LEARNING' },
  { id: 'GOK-PLANNING-001',   name: 'Planning Worker',     family: 'PLANNING' },
  { id: 'GOK-CACHE-001',      name: 'Cache Worker',        family: 'CACHE' },
  { id: 'GOK-ARCHIVE-001',    name: 'Archive Worker',      family: 'ARCHIVE' },
  { id: 'GOK-SCHEDULER-001',  name: 'Scheduler Worker',    family: 'SCHEDULER' },
  { id: 'GOK-CONFIG-001',     name: 'Config Worker',       family: 'CONFIG' },
  { id: 'GOK-REGISTRY-001',   name: 'Registry Worker',     family: 'SERVICE_REGISTRY' },
  { id: 'GOK-REASONING-001',  name: 'Reasoning Worker',    family: 'REASONING' },
  { id: 'GOK-CONTRACT-001',   name: 'Contract Worker',     family: 'SMART_CONTRACT' },
  { id: 'GOK-LEGAL-001',      name: 'Legal Worker',        family: 'LEGAL_ENGINE' },
  { id: 'GOK-GUARDIAN-001',   name: 'Guardian Worker',     family: 'SECURITY_GUARDIAN' },
  { id: 'GOK-SENTINEL-001',   name: 'Sentinel Worker',     family: 'CONTINUOUS_WATCH' },
  { id: 'canister-brain',     name: 'Swarm Brain',         family: 'CANISTER' },
  { id: 'canister-organism',  name: 'Swarm Organism',      family: 'CANISTER' },
  { id: 'frontend-ui',        name: 'Frontend UI',         family: 'FRONTEND' },
  { id: 'frontend-state',     name: 'Frontend State',      family: 'FRONTEND' },
  { id: 'sdk-icp-agent',      name: 'ICP Agent SDK',       family: 'SDK' },
  { id: 'sdk-candid',         name: 'Candid Interface',    family: 'SDK' },
  { id: 'sdk-auth',           name: 'Auth Service',        family: 'SDK' },
  { id: 'sdk-ledger',         name: 'Ledger Service',      family: 'SDK' },
  { id: 'net-http',           name: 'HTTP Client',         family: 'NETWORK' },
  { id: 'net-websocket',      name: 'WebSocket Client',    family: 'NETWORK' },
  { id: 'defense-membrane',   name: 'Defense Membrane',    family: 'DEFENSE' },
  { id: 'defense-audit',      name: 'Audit Logger',        family: 'DEFENSE' },
  { id: 'geo-sacred',         name: 'Sacred Geometry',     family: 'GEOMETRY' },
  { id: 'consciousness',      name: 'Consciousness Field', family: 'EMERGENCE' },
];

for (var wi = 0; wi < DEFAULT_WORKERS.length; wi++) {
  var dw = DEFAULT_WORKERS[wi];
  registerWorker(dw.id, { name: dw.name, family: dw.family });
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'register-worker': {
      var w = registerWorker(msg.workerId, msg.config || {});
      self.postMessage({
        type: 'worker-registered',
        workerId: w.id,
        name: w.name,
        totalWorkers: Object.keys(workers).length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'worker-beat': {
      var ack = processWorkerBeat(msg.workerId, msg.phase, msg.timestamp);
      self.postMessage({
        type: 'beat-ack',
        workerId: msg.workerId,
        ack: ack,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'check-liveness': {
      var liveResult = checkLiveness(msg.workerId);
      self.postMessage({
        type: 'liveness-result',
        workerId: msg.workerId || null,
        result: liveResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'cascade-status': {
      var cascade = detectCascade();
      self.postMessage({
        type: 'cascade-report',
        cascade: cascade,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'coherence': {
      var coh = computeCoherence();
      self.postMessage({
        type: 'coherence-report',
        coherence: coh,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'recovery-plan': {
      var recPlan = recoveryPlan(msg.workerId);
      self.postMessage({
        type: 'recovery-recommendation',
        workerId: msg.workerId || null,
        result: recPlan,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      var aliveCount = 0;
      var totalW = Object.keys(workers).length;
      var wids = Object.keys(workers);
      for (var si = 0; si < wids.length; si++) {
        if (workers[wids[si]].alive) aliveCount++;
      }
      self.postMessage({
        type: 'pulse-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalWorkers: totalW,
        aliveWorkers: aliveCount,
        deadWorkers: totalW - aliveCount,
        cascadeActive: cascadeActive,
        beat: beatCount,
        phase: kernelPhase,
        phi: PHI,
      });
      break;
    }

    case 'stop': {
      running = false;
      clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
    }
  }
};


/* ════════════════════════════════════════════════════════════════
   φ-COUPLED HEARTBEAT — 873ms Kuramoto pulse
   ════════════════════════════════════════════════════════════════ */

var _hbi = setInterval(function() {
  if (!running) return;
  beatCount++;
  kernelPhase += PHI_INV;
  if (kernelPhase > 2 * Math.PI) kernelPhase -= 2 * Math.PI;

  // Sweep liveness and cascade detection
  sweepLiveness();
  sweepFailures();

  var aliveNow = 0;
  var totalNow = Object.keys(workers).length;
  var wk = Object.keys(workers);
  for (var h = 0; h < wk.length; h++) {
    if (workers[wk[h]].alive) aliveNow++;
  }

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalWorkers: totalNow,
    aliveWorkers: aliveNow,
    cascadeActive: cascadeActive,
  });
}, HEARTBEAT);
