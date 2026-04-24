/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Sentinel Worker (GOK-SENTINEL-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-SENTINEL-001
 * Kernel Family:  CONTINUOUS_WATCH
 * Architecture:   Monitor Registry × Incident Pipeline × Escalation × SLA
 *
 * 24/7 continuous monitoring sentinel for the NOVA organism. Manages
 * configurable health monitors, drives the incident lifecycle from detection
 * through postmortem, auto-escalates unresolved incidents, and tracks SLA
 * compliance. 20+ pre-configured monitors ship out of the box.
 *
 * Features:
 *   • 24/7 monitoring with configurable check intervals
 *   • Incident management (detect → triage → respond → resolve → postmortem)
 *   • Escalation chains (L1 → L2 → L3 with timeout-based auto-escalation)
 *   • SLA tracking (uptime targets, response time targets)
 *   • 20+ pre-configured monitors
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'add-monitor', monitor }
 *   Main → Worker: { type: 'remove-monitor', monitorId }
 *   Main → Worker: { type: 'check-now', monitorId }
 *   Main → Worker: { type: 'incident', action, incidentId, data }
 *   Main → Worker: { type: 'escalate', incidentId }
 *   Main → Worker: { type: 'sla-report', monitorId }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'monitor-added', monitor }
 *   Worker → Main: { type: 'monitor-removed', monitorId }
 *   Worker → Main: { type: 'check-result', monitorId, result }
 *   Worker → Main: { type: 'incident-update', incident }
 *   Worker → Main: { type: 'escalation', incidentId, level }
 *   Worker → Main: { type: 'sla-data', report }
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

var KERNEL_ID      = 'GOK-SENTINEL-001';
var KERNEL_FAMILY  = 'CONTINUOUS_WATCH';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;


/* ════════════════════════════════════════════════════════════════
   MONITOR REGISTRY
   ════════════════════════════════════════════════════════════════ */

var monitors    = {};   // monitorId → monitor descriptor
var incidents   = {};   // incidentId → incident record
var slaRecords  = {};   // monitorId → SLA tracking data
var nextIncId   = 1;

function createMonitor(cfg) {
  var id = cfg.id || ('mon-' + Date.now());
  var mon = {
    id: id,
    name: cfg.name || id,
    target: cfg.target || 'unknown',
    type: cfg.type || 'heartbeat',
    interval: cfg.interval || 5,              // check every N beats
    timeout: cfg.timeout || 3,                // miss threshold
    enabled: cfg.enabled !== false,
    status: 'unknown',
    lastCheck: 0,
    lastSeen: Date.now(),
    consecutiveFails: 0,
    totalChecks: 0,
    totalPasses: 0,
    totalFails: 0,
    createdAt: Date.now(),
  };
  monitors[id] = mon;

  // Initialise SLA record
  slaRecords[id] = {
    monitorId: id,
    uptimeTarget: cfg.uptimeTarget || 0.999,
    responseTarget: cfg.responseTarget || 1000,
    totalUptime: 0,
    totalDowntime: 0,
    windowStart: Date.now(),
    checks: [],
  };

  return mon;
}

function removeMonitor(id) {
  if (!monitors[id]) return false;
  delete monitors[id];
  delete slaRecords[id];
  return true;
}


/* ════════════════════════════════════════════════════════════════
   HEALTH CHECK ENGINE
   ════════════════════════════════════════════════════════════════ */

function checkMonitor(id) {
  var mon = monitors[id];
  if (!mon) return { success: false, error: 'Unknown monitor: ' + id };

  var now = Date.now();
  var elapsed = now - mon.lastSeen;
  var missedBeats = Math.floor(elapsed / HEARTBEAT);
  mon.totalChecks++;
  mon.lastCheck = now;

  // φ-weighted health decay
  var healthy = missedBeats <= mon.timeout;
  if (healthy) {
    mon.consecutiveFails = 0;
    mon.totalPasses++;
    mon.status = 'healthy';
  } else {
    mon.consecutiveFails++;
    mon.totalFails++;
    mon.status = mon.consecutiveFails > mon.timeout * 2 ? 'critical' : 'degraded';
  }

  // Update SLA
  var sla = slaRecords[id];
  if (sla) {
    if (healthy) {
      sla.totalUptime += HEARTBEAT * mon.interval;
    } else {
      sla.totalDowntime += HEARTBEAT * mon.interval;
    }
    sla.checks.push({ time: now, healthy: healthy, missed: missedBeats });
    if (sla.checks.length > 1000) sla.checks = sla.checks.slice(-800);
  }

  // Auto-create incident on failure
  if (!healthy && mon.consecutiveFails === mon.timeout) {
    createIncident(id, 'Monitor ' + mon.name + ' exceeded miss threshold');
  }

  return {
    success: true,
    monitorId: id,
    status: mon.status,
    healthy: healthy,
    missedBeats: missedBeats,
    consecutiveFails: mon.consecutiveFails,
    checkedAt: now,
  };
}

// Periodic auto-check runs on each heartbeat
function autoCheck() {
  var ids = Object.keys(monitors);
  for (var i = 0; i < ids.length; i++) {
    var mon = monitors[ids[i]];
    if (!mon.enabled) continue;
    if (beatCount % mon.interval === 0) {
      var result = checkMonitor(ids[i]);
      if (!result.healthy) {
        self.postMessage({
          type: 'check-result',
          monitorId: ids[i],
          result: result,
          kernelId: KERNEL_ID,
        });
      }
    }
  }
  // Auto-escalation sweep
  autoEscalate();
}


/* ════════════════════════════════════════════════════════════════
   INCIDENT MANAGEMENT
   ════════════════════════════════════════════════════════════════ */

var INCIDENT_STATES = ['detected', 'triaged', 'responding', 'resolved', 'postmortem'];

function createIncident(monitorId, description) {
  var id = 'INC-' + ('0000' + nextIncId).slice(-4);
  nextIncId++;

  var incident = {
    id: id,
    monitorId: monitorId,
    description: description || 'Incident detected',
    state: 'detected',
    severity: 'warning',
    escalationLevel: 1,
    escalatedAt: Date.now(),
    createdAt: Date.now(),
    updatedAt: Date.now(),
    resolvedAt: null,
    timeline: [{ state: 'detected', time: Date.now(), note: description }],
    assignee: null,
  };

  incidents[id] = incident;

  self.postMessage({
    type: 'incident-update',
    incident: incident,
    action: 'created',
    kernelId: KERNEL_ID,
  });

  return incident;
}

function transitionIncident(incidentId, action, data) {
  var inc = incidents[incidentId];
  if (!inc) return { success: false, error: 'Unknown incident: ' + incidentId };

  var now = Date.now();
  data = data || {};

  switch (action) {
    case 'triage':
      inc.state = 'triaged';
      inc.severity = data.severity || inc.severity;
      inc.assignee = data.assignee || inc.assignee;
      break;
    case 'respond':
      inc.state = 'responding';
      break;
    case 'resolve':
      inc.state = 'resolved';
      inc.resolvedAt = now;
      // Refresh monitor on resolve
      if (monitors[inc.monitorId]) {
        monitors[inc.monitorId].consecutiveFails = 0;
        monitors[inc.monitorId].status = 'healthy';
        monitors[inc.monitorId].lastSeen = now;
      }
      break;
    case 'postmortem':
      inc.state = 'postmortem';
      inc.postmortem = data.summary || 'No summary provided';
      break;
    default:
      return { success: false, error: 'Unknown action: ' + action };
  }

  inc.updatedAt = now;
  inc.timeline.push({ state: inc.state, time: now, note: data.note || action });

  return { success: true, incident: inc };
}


/* ════════════════════════════════════════════════════════════════
   ESCALATION CHAINS — L1 → L2 → L3
   ════════════════════════════════════════════════════════════════ */

var ESCALATION_TIMEOUTS = [0, 5 * HEARTBEAT, 10 * HEARTBEAT, 20 * HEARTBEAT];

function escalateIncident(incidentId) {
  var inc = incidents[incidentId];
  if (!inc) return { success: false, error: 'Unknown incident: ' + incidentId };
  if (inc.state === 'resolved' || inc.state === 'postmortem') {
    return { success: false, error: 'Cannot escalate resolved incident' };
  }

  if (inc.escalationLevel < 3) {
    inc.escalationLevel++;
    inc.escalatedAt = Date.now();
    inc.updatedAt = Date.now();
    inc.severity = inc.escalationLevel >= 3 ? 'critical' : (inc.escalationLevel >= 2 ? 'high' : 'warning');
    inc.timeline.push({ state: 'escalated', time: Date.now(), note: 'Escalated to L' + inc.escalationLevel });

    self.postMessage({
      type: 'escalation',
      incidentId: incidentId,
      level: inc.escalationLevel,
      severity: inc.severity,
      kernelId: KERNEL_ID,
    });
  }

  return { success: true, incident: inc };
}

function autoEscalate() {
  var now = Date.now();
  var ids = Object.keys(incidents);
  for (var i = 0; i < ids.length; i++) {
    var inc = incidents[ids[i]];
    if (inc.state === 'resolved' || inc.state === 'postmortem') continue;
    if (inc.escalationLevel >= 3) continue;
    var timeout = ESCALATION_TIMEOUTS[inc.escalationLevel] || (10 * HEARTBEAT);
    if (now - inc.escalatedAt > timeout) {
      escalateIncident(ids[i]);
    }
  }
}


/* ════════════════════════════════════════════════════════════════
   SLA TRACKING
   ════════════════════════════════════════════════════════════════ */

function slaReport(monitorId) {
  if (monitorId) {
    var sla = slaRecords[monitorId];
    if (!sla) return { success: false, error: 'No SLA data for: ' + monitorId };
    return { success: true, report: computeSLA(sla) };
  }
  // All monitors
  var reports = [];
  var ids = Object.keys(slaRecords);
  for (var i = 0; i < ids.length; i++) {
    reports.push(computeSLA(slaRecords[ids[i]]));
  }
  return { success: true, reports: reports, count: reports.length };
}

function computeSLA(sla) {
  var total = sla.totalUptime + sla.totalDowntime;
  var actualUptime = total > 0 ? sla.totalUptime / total : 1.0;
  var meetingTarget = actualUptime >= sla.uptimeTarget;

  return {
    monitorId: sla.monitorId,
    uptimeTarget: sla.uptimeTarget,
    actualUptime: Math.round(actualUptime * 10000) / 10000,
    meetingTarget: meetingTarget,
    totalUptime: sla.totalUptime,
    totalDowntime: sla.totalDowntime,
    totalChecks: sla.checks.length,
    windowStart: sla.windowStart,
    reportedAt: Date.now(),
  };
}


/* ════════════════════════════════════════════════════════════════
   PRE-CONFIGURED MONITORS (20+)
   ════════════════════════════════════════════════════════════════ */

var DEFAULT_MONITORS = [
  { id: 'mon-engine',       name: 'Engine Worker',        target: 'GOK-ENGINE-001',     interval: 3 },
  { id: 'mon-memory',       name: 'Memory Worker',        target: 'GOK-MEMORY-001',     interval: 3 },
  { id: 'mon-routing',      name: 'Routing Worker',       target: 'GOK-ROUTING-001',    interval: 3 },
  { id: 'mon-crypto',       name: 'Crypto Worker',        target: 'GOK-CRYPTO-001',     interval: 5 },
  { id: 'mon-telemetry',    name: 'Telemetry Worker',     target: 'GOK-TELEMETRY-001',  interval: 3 },
  { id: 'mon-download',     name: 'Download Worker',      target: 'GOK-DOWNLOAD-001',   interval: 5 },
  { id: 'mon-learning',     name: 'Learning Worker',      target: 'GOK-LEARNING-001',   interval: 5 },
  { id: 'mon-planning',     name: 'Planning Worker',      target: 'GOK-PLANNING-001',   interval: 5 },
  { id: 'mon-cache',        name: 'Cache Worker',         target: 'GOK-CACHE-001',      interval: 5 },
  { id: 'mon-archive',      name: 'Archive Worker',       target: 'GOK-ARCHIVE-001',    interval: 5 },
  { id: 'mon-scheduler',    name: 'Scheduler Worker',     target: 'GOK-SCHEDULER-001',  interval: 3 },
  { id: 'mon-config',       name: 'Config Worker',        target: 'GOK-CONFIG-001',     interval: 5 },
  { id: 'mon-registry',     name: 'Registry Worker',      target: 'GOK-REGISTRY-001',   interval: 3 },
  { id: 'mon-reasoning',    name: 'Reasoning Worker',     target: 'GOK-REASONING-001',  interval: 5 },
  { id: 'mon-contract',     name: 'Contract Worker',      target: 'GOK-CONTRACT-001',   interval: 5 },
  { id: 'mon-legal',        name: 'Legal Worker',         target: 'GOK-LEGAL-001',      interval: 5 },
  { id: 'mon-guardian',     name: 'Guardian Worker',      target: 'GOK-GUARDIAN-001',   interval: 3 },
  { id: 'mon-heartbeat',    name: 'Heartbeat Worker',     target: 'GOK-HEARTBEAT-001',  interval: 3 },
  { id: 'mon-canister-b',   name: 'Swarm Brain',          target: 'canister-brain',     interval: 5 },
  { id: 'mon-canister-o',   name: 'Swarm Organism',       target: 'canister-organism',  interval: 5 },
  { id: 'mon-frontend',     name: 'Frontend UI',          target: 'frontend-ui',        interval: 5 },
];

for (var mi = 0; mi < DEFAULT_MONITORS.length; mi++) {
  createMonitor(DEFAULT_MONITORS[mi]);
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'add-monitor': {
      var mon = createMonitor(msg.monitor || {});
      self.postMessage({
        type: 'monitor-added',
        monitor: mon,
        totalMonitors: Object.keys(monitors).length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'remove-monitor': {
      var removed = removeMonitor(msg.monitorId);
      self.postMessage({
        type: 'monitor-removed',
        monitorId: msg.monitorId,
        success: removed,
        totalMonitors: Object.keys(monitors).length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'check-now': {
      var result = checkMonitor(msg.monitorId);
      self.postMessage({
        type: 'check-result',
        monitorId: msg.monitorId,
        result: result,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'incident': {
      var incResult;
      if (msg.action === 'create') {
        var inc = createIncident(msg.monitorId, msg.description);
        incResult = { success: true, incident: inc };
      } else {
        incResult = transitionIncident(msg.incidentId, msg.action, msg.data);
      }
      self.postMessage({
        type: 'incident-update',
        action: msg.action,
        result: incResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'escalate': {
      var escResult = escalateIncident(msg.incidentId);
      self.postMessage({
        type: 'escalation',
        incidentId: msg.incidentId,
        result: escResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'sla-report': {
      var slaResult = slaReport(msg.monitorId);
      self.postMessage({
        type: 'sla-data',
        monitorId: msg.monitorId || null,
        result: slaResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      var openInc = 0;
      var incIds = Object.keys(incidents);
      for (var ii = 0; ii < incIds.length; ii++) {
        if (incidents[incIds[ii]].state !== 'resolved' && incidents[incIds[ii]].state !== 'postmortem') openInc++;
      }
      self.postMessage({
        type: 'sentinel-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalMonitors: Object.keys(monitors).length,
        totalIncidents: incIds.length,
        openIncidents: openInc,
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

  // Run auto-checks every heartbeat
  autoCheck();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalMonitors: Object.keys(monitors).length,
    openIncidents: Object.keys(incidents).reduce(function(c, k) {
      return c + (incidents[k].state !== 'resolved' && incidents[k].state !== 'postmortem' ? 1 : 0);
    }, 0),
  });
}, HEARTBEAT);
