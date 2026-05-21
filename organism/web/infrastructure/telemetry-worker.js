/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Telemetry Worker (GOK-TELEMETRY-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-TELEMETRY-001
 * Kernel Family:  IMMUNE_SYSTEM
 * Architecture:   Per-Worker Health × φ-Weighted Scores × 9-Ring Status
 *
 * The product monitors itself. If any worker dies, telemetry detects it
 * within 3 heartbeats and fires an alert. Ring health tracks all 9 organism
 * layers. This is the immune system.
 *
 * 9 Organism Rings:
 *   Ring 0: KERNEL       — Core engine health
 *   Ring 1: MEMORY       — Memory worker health
 *   Ring 2: ROUTING      — Protocol routing health
 *   Ring 3: CRYPTO       — Cryptographic subsystem health
 *   Ring 4: DOWNLOAD     — Archive builder health
 *   Ring 5: CANISTER     — Backend canister connection
 *   Ring 6: FRONTEND     — UI rendering health
 *   Ring 7: NETWORK      — Network connectivity
 *   Ring 8: SOVEREIGN    — Overall organism sovereignty
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'report', workerId, metrics }
 *   Main → Worker: { type: 'ring-status' }
 *   Main → Worker: { type: 'alerts' }
 *   Main → Worker: { type: 'worker-health', workerId }
 *   Main → Worker: { type: 'status' }
 *   Worker → Main: { type: 'health-report', workerId, health, score }
 *   Worker → Main: { type: 'ring-map', rings }
 *   Worker → Main: { type: 'alert-list', alerts }
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

var KERNEL_ID      = 'GOK-TELEMETRY-001';
var KERNEL_FAMILY  = 'IMMUNE_SYSTEM';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;

var MISS_THRESHOLD = 3; // Declare dead after 3 missed heartbeats


/* ════════════════════════════════════════════════════════════════
   9-RING ORGANISM HEALTH MODEL
   ════════════════════════════════════════════════════════════════ */

var RING_NAMES = [
  'KERNEL',      // Ring 0
  'MEMORY',      // Ring 1
  'ROUTING',     // Ring 2
  'CRYPTO',      // Ring 3
  'DOWNLOAD',    // Ring 4
  'CANISTER',    // Ring 5
  'FRONTEND',    // Ring 6
  'NETWORK',     // Ring 7
  'SOVEREIGN',   // Ring 8
];

var rings = {};
for (var ri = 0; ri < RING_NAMES.length; ri++) {
  rings[RING_NAMES[ri]] = {
    id: ri,
    name: RING_NAMES[ri],
    health: 1.0,
    lastUpdate: Date.now(),
    workerCount: 0,
    alertCount: 0,
    status: 'HEALTHY', // HEALTHY, DEGRADED, CRITICAL, DEAD
  };
}


/* ════════════════════════════════════════════════════════════════
   PER-WORKER HEALTH TRACKING
   ════════════════════════════════════════════════════════════════ */

var workerHealth = {};  // workerId → health record
var alerts = [];        // alert history
var alertIdCounter = 0;

function reportWorkerHealth(workerId, metrics) {
  var now = Date.now();
  var existing = workerHealth[workerId];

  // Compute φ-weighted health score
  var latency    = metrics.latencyMs  || 0;
  var errorRate  = metrics.errorRate  || 0;
  var throughput = metrics.throughput || 1;
  var uptime     = metrics.uptime     || 1.0;

  // Health score: weighted combination
  var latencyScore    = 1.0 / (1.0 + latency / 100);          // Lower latency = better
  var errorScore      = 1.0 - Math.min(errorRate, 1.0);       // Lower error = better
  var throughputScore = Math.min(throughput / 10, 1.0);        // Higher throughput = better
  var uptimeScore     = uptime;

  // φ-weighted combination
  var healthScore = (
    latencyScore    * PHI +
    errorScore      * PHI_SQ +
    throughputScore * PHI_INV +
    uptimeScore     * PHI
  ) / (PHI + PHI_SQ + PHI_INV + PHI);

  healthScore = Math.min(Math.max(healthScore, 0), 1);

  var record = {
    workerId: workerId,
    ring: metrics.ring || 'KERNEL',
    healthScore: healthScore,
    latencyMs: latency,
    errorRate: errorRate,
    throughput: throughput,
    uptime: uptime,
    lastHeartbeat: now,
    missedBeats: 0,
    status: healthScore > 0.8 ? 'HEALTHY' : healthScore > 0.5 ? 'DEGRADED' : healthScore > 0.2 ? 'CRITICAL' : 'DEAD',
    beat: beatCount,
  };

  workerHealth[workerId] = record;

  // Update ring health
  updateRingHealth(record.ring);

  // Check for alerts
  if (record.status === 'CRITICAL' || record.status === 'DEAD') {
    fireAlert(workerId, record.status, 'Health score: ' + healthScore.toFixed(3));
  }

  return record;
}

var PHI_SQ = 2.6180339887498948482;

function updateRingHealth(ringName) {
  var ring = rings[ringName];
  if (!ring) return;

  // Aggregate health from all workers in this ring
  var total = 0;
  var count = 0;
  var wKeys = Object.keys(workerHealth);
  for (var i = 0; i < wKeys.length; i++) {
    if (workerHealth[wKeys[i]].ring === ringName) {
      total += workerHealth[wKeys[i]].healthScore;
      count++;
    }
  }

  ring.workerCount = count;
  ring.health = count > 0 ? total / count : 1.0;
  ring.lastUpdate = Date.now();
  ring.status = ring.health > 0.8 ? 'HEALTHY' : ring.health > 0.5 ? 'DEGRADED' : ring.health > 0.2 ? 'CRITICAL' : 'DEAD';
}


/* ════════════════════════════════════════════════════════════════
   ALERT SYSTEM — Fires when workers die or degrade
   ════════════════════════════════════════════════════════════════ */

function fireAlert(workerId, severity, message) {
  alertIdCounter++;
  var alert = {
    id: 'ALERT-' + alertIdCounter,
    workerId: workerId,
    severity: severity,
    message: message,
    timestamp: Date.now(),
    beat: beatCount,
    acknowledged: false,
  };
  alerts.push(alert);

  // Keep alert history bounded
  if (alerts.length > 1000) alerts = alerts.slice(-500);

  // Post alert to main thread immediately
  self.postMessage({
    type: 'alert',
    alert: alert,
    kernelId: KERNEL_ID,
  });

  // Update ring alert count
  var wh = workerHealth[workerId];
  if (wh && rings[wh.ring]) {
    rings[wh.ring].alertCount++;
  }
}


/**
 * Dead-worker detection: check all workers for missed heartbeats.
 * Called every heartbeat cycle.
 */
function checkDeadWorkers() {
  var now = Date.now();
  var deadThreshold = HEARTBEAT * MISS_THRESHOLD;
  var wKeys = Object.keys(workerHealth);

  for (var i = 0; i < wKeys.length; i++) {
    var wh = workerHealth[wKeys[i]];
    var elapsed = now - wh.lastHeartbeat;

    if (elapsed > deadThreshold) {
      wh.missedBeats = Math.floor(elapsed / HEARTBEAT);
      if (wh.status !== 'DEAD') {
        wh.status = 'DEAD';
        wh.healthScore = 0;
        fireAlert(wh.workerId, 'DEAD', 'Worker missed ' + wh.missedBeats + ' heartbeats');
        updateRingHealth(wh.ring);
      }
    } else if (elapsed > HEARTBEAT * 2) {
      wh.missedBeats = Math.floor(elapsed / HEARTBEAT);
      if (wh.status !== 'CRITICAL' && wh.status !== 'DEAD') {
        wh.status = 'DEGRADED';
        fireAlert(wh.workerId, 'DEGRADED', 'Worker slow — ' + wh.missedBeats + ' beats behind');
      }
    }
  }
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'report': {
      var record = reportWorkerHealth(msg.workerId, msg.metrics || {});
      self.postMessage({
        type: 'health-report',
        workerId: record.workerId,
        ring: record.ring,
        healthScore: record.healthScore,
        status: record.status,
        beat: record.beat,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'ring-status': {
      var ringMap = [];
      for (var rn = 0; rn < RING_NAMES.length; rn++) {
        ringMap.push(rings[RING_NAMES[rn]]);
      }
      // Compute overall organism health (φ-weighted average of all rings)
      var totalHealth = 0;
      var totalWeight = 0;
      for (var rw = 0; rw < ringMap.length; rw++) {
        var weight = (rw === 0) ? PHI : (rw === 8) ? PHI_SQ : 1.0;
        totalHealth += ringMap[rw].health * weight;
        totalWeight += weight;
      }
      self.postMessage({
        type: 'ring-map',
        rings: ringMap,
        ringCount: RING_NAMES.length,
        organismHealth: totalHealth / totalWeight,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'alerts': {
      var unacked = alerts.filter(function(a) { return !a.acknowledged; });
      self.postMessage({
        type: 'alert-list',
        alerts: unacked,
        totalAlerts: alerts.length,
        unacknowledged: unacked.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'acknowledge': {
      for (var ai = 0; ai < alerts.length; ai++) {
        if (alerts[ai].id === msg.alertId) {
          alerts[ai].acknowledged = true;
          break;
        }
      }
      self.postMessage({
        type: 'alert-acknowledged',
        alertId: msg.alertId,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'worker-health': {
      var wh = workerHealth[msg.workerId];
      self.postMessage({
        type: 'worker-health-detail',
        workerId: msg.workerId,
        health: wh || null,
        found: !!wh,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'telemetry-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        workerCount: Object.keys(workerHealth).length,
        ringCount: RING_NAMES.length,
        alertCount: alerts.length,
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

  // Check for dead workers every beat
  checkDeadWorkers();

  // Compute organism-wide health
  var totalRingHealth = 0;
  for (var r = 0; r < RING_NAMES.length; r++) {
    totalRingHealth += rings[RING_NAMES[r]].health;
  }
  var organismHealth = totalRingHealth / RING_NAMES.length;

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    organismHealth: organismHealth,
    workerCount: Object.keys(workerHealth).length,
    alertCount: alerts.length,
  });
}, HEARTBEAT);
