/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Analytics Worker (GOK-ANALYTICS-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-ANALYTICS-001
 * Kernel Family:  USAGE_ANALYTICS
 * Architecture:   Event Tracking × Funnel Analysis × Cohort Analysis × Sessions
 *
 * Real-time usage analytics engine for the NOVA organism. Tracks events,
 * sessions, funnels, and cohorts with φ-weighted moving averages for
 * real-time counters and engagement scoring.
 *
 * Features:
 *   • Event tracking (page views, clicks, actions, errors)
 *   • Funnel analysis with stage conversion tracking
 *   • Cohort analysis grouped by time period or behavior
 *   • Real-time counters with φ-weighted moving averages
 *   • Session tracking with duration and engagement scoring
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'track', event }
 *   Main → Worker: { type: 'funnel', funnelId, stages }
 *   Main → Worker: { type: 'cohort', cohortId, groupBy }
 *   Main → Worker: { type: 'counter', name, delta }
 *   Main → Worker: { type: 'session-start', sessionId }
 *   Main → Worker: { type: 'session-end', sessionId }
 *   Main → Worker: { type: 'report', reportType }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
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

var KERNEL_ID      = 'GOK-ANALYTICS-001';
var KERNEL_FAMILY  = 'USAGE_ANALYTICS';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;


/* ════════════════════════════════════════════════════════════════
   DATA STORES
   ════════════════════════════════════════════════════════════════ */

var events   = [];
var sessions = {};
var funnels  = {};
var cohorts  = {};
var counters = {};

var MAX_EVENTS = 10000;
var EVENT_CATEGORIES = ['pageview', 'click', 'action', 'error', 'custom'];


/* ════════════════════════════════════════════════════════════════
   EVENT TRACKING
   ════════════════════════════════════════════════════════════════ */

/**
 * Track an event with category, action, label, and value.
 */
function trackEvent(event) {
  var entry = {
    id: 'evt-' + Date.now() + '-' + Math.floor(Math.random() * 10000),
    category: event.category || 'custom',
    action: event.action || 'unknown',
    label: event.label || '',
    value: event.value || 0,
    sessionId: event.sessionId || null,
    metadata: event.metadata || {},
    timestamp: Date.now()
  };
  events.push(entry);
  if (events.length > MAX_EVENTS) {
    events = events.slice(events.length - MAX_EVENTS);
  }
  // Update session if linked
  if (entry.sessionId && sessions[entry.sessionId]) {
    sessions[entry.sessionId].eventCount++;
    sessions[entry.sessionId].lastActivity = Date.now();
  }
  // Update counters
  var counterKey = entry.category + ':' + entry.action;
  if (!counters[counterKey]) {
    counters[counterKey] = { value: 0, average: 0, samples: 0 };
  }
  counters[counterKey].value++;
  counters[counterKey].samples++;
  // φ-weighted moving average
  var c = counters[counterKey];
  c.average = c.average * PHI_INV + c.value * (1 - PHI_INV);
  return entry;
}


/* ════════════════════════════════════════════════════════════════
   SESSION TRACKING
   ════════════════════════════════════════════════════════════════ */

/**
 * Start a new session.
 */
function startSession(sessionId) {
  var id = sessionId || ('sess-' + Date.now());
  sessions[id] = {
    id: id,
    startedAt: Date.now(),
    endedAt: null,
    eventCount: 0,
    pageCount: 0,
    lastActivity: Date.now(),
    duration: 0,
    engagement: 0.0,
    active: true
  };
  return sessions[id];
}

/**
 * End a session and compute engagement score.
 */
function endSession(sessionId) {
  if (!sessions[sessionId]) return { error: 'Session not found: ' + sessionId };
  var s = sessions[sessionId];
  s.endedAt = Date.now();
  s.duration = s.endedAt - s.startedAt;
  s.active = false;
  // Engagement = φ-weighted combination of event density and duration
  var durationMinutes = s.duration / 60000;
  var eventDensity = durationMinutes > 0 ? s.eventCount / durationMinutes : 0;
  s.engagement = Math.round((eventDensity * PHI_INV + Math.min(durationMinutes, 30) / 30 * PHI_INV) * 1000) / 1000;
  return s;
}


/* ════════════════════════════════════════════════════════════════
   FUNNEL ANALYSIS
   ════════════════════════════════════════════════════════════════ */

/**
 * Define a funnel with ordered stages.
 */
function defineFunnel(funnelId, stages) {
  var stageData = [];
  for (var i = 0; i < stages.length; i++) {
    stageData.push({ name: stages[i], count: 0, convertedFrom: 0 });
  }
  funnels[funnelId] = {
    id: funnelId,
    stages: stageData,
    createdAt: Date.now()
  };
  return funnels[funnelId];
}

/**
 * Record a funnel event at a given stage.
 */
function recordFunnelEvent(funnelId, stageName) {
  if (!funnels[funnelId]) return { error: 'Funnel not found: ' + funnelId };
  var f = funnels[funnelId];
  for (var i = 0; i < f.stages.length; i++) {
    if (f.stages[i].name === stageName) {
      f.stages[i].count++;
      if (i > 0) f.stages[i].convertedFrom = f.stages[i - 1].count;
      break;
    }
  }
  return f;
}

/**
 * Get funnel conversion report.
 */
function funnelReport(funnelId) {
  if (!funnels[funnelId]) return { error: 'Funnel not found: ' + funnelId };
  var f = funnels[funnelId];
  var report = { id: funnelId, stages: [], overallConversion: 0 };
  for (var i = 0; i < f.stages.length; i++) {
    var stage = {
      name: f.stages[i].name,
      count: f.stages[i].count,
      conversionRate: 0
    };
    if (i > 0 && f.stages[i - 1].count > 0) {
      stage.conversionRate = Math.round(f.stages[i].count / f.stages[i - 1].count * 10000) / 100;
    } else if (i === 0) {
      stage.conversionRate = 100;
    }
    report.stages.push(stage);
  }
  if (f.stages.length > 1 && f.stages[0].count > 0) {
    report.overallConversion = Math.round(f.stages[f.stages.length - 1].count / f.stages[0].count * 10000) / 100;
  }
  return report;
}


/* ════════════════════════════════════════════════════════════════
   COHORT ANALYSIS
   ════════════════════════════════════════════════════════════════ */

/**
 * Define or add to a cohort group.
 */
function defineCohort(cohortId, config) {
  cohorts[cohortId] = {
    id: cohortId,
    groupBy: config.groupBy || 'week',
    members: config.members || [],
    buckets: {},
    createdAt: Date.now()
  };
  return cohorts[cohortId];
}

/**
 * Add a member to a cohort bucket.
 */
function addCohortMember(cohortId, memberId, bucketKey) {
  if (!cohorts[cohortId]) return { error: 'Cohort not found: ' + cohortId };
  var c = cohorts[cohortId];
  var key = bucketKey || 'default';
  if (!c.buckets[key]) c.buckets[key] = { members: [], eventCount: 0 };
  c.buckets[key].members.push(memberId);
  c.members.push(memberId);
  return c;
}

/**
 * Get cohort retention report.
 */
function cohortReport(cohortId) {
  if (!cohorts[cohortId]) return { error: 'Cohort not found: ' + cohortId };
  var c = cohorts[cohortId];
  var bucketKeys = Object.keys(c.buckets);
  var report = { id: cohortId, groupBy: c.groupBy, buckets: [], totalMembers: c.members.length };
  for (var i = 0; i < bucketKeys.length; i++) {
    report.buckets.push({
      key: bucketKeys[i],
      memberCount: c.buckets[bucketKeys[i]].members.length,
      eventCount: c.buckets[bucketKeys[i]].eventCount
    });
  }
  return report;
}


/* ════════════════════════════════════════════════════════════════
   REAL-TIME COUNTERS WITH φ-WEIGHTED MOVING AVERAGES
   ════════════════════════════════════════════════════════════════ */

/**
 * Increment or decrement a named counter.
 */
function updateCounter(name, delta) {
  if (!counters[name]) {
    counters[name] = { value: 0, average: 0, samples: 0 };
  }
  var d = (delta !== undefined) ? delta : 1;
  counters[name].value += d;
  counters[name].samples++;
  counters[name].average = counters[name].average * PHI_INV + counters[name].value * (1 - PHI_INV);
  return {
    name: name,
    value: counters[name].value,
    average: Math.round(counters[name].average * 1000) / 1000,
    samples: counters[name].samples
  };
}


/* ════════════════════════════════════════════════════════════════
   REPORT GENERATION
   ════════════════════════════════════════════════════════════════ */

/**
 * Generate an analytics summary report.
 */
function generateReport(reportType) {
  if (reportType === 'events') {
    var catCounts = {};
    for (var i = 0; i < events.length; i++) {
      var cat = events[i].category;
      catCounts[cat] = (catCounts[cat] || 0) + 1;
    }
    return { type: 'events', totalEvents: events.length, byCategory: catCounts };
  }
  if (reportType === 'sessions') {
    var sids = Object.keys(sessions);
    var activeSessions = 0;
    var totalDuration = 0;
    var totalEngagement = 0;
    for (var s = 0; s < sids.length; s++) {
      if (sessions[sids[s]].active) activeSessions++;
      totalDuration += sessions[sids[s]].duration;
      totalEngagement += sessions[sids[s]].engagement;
    }
    return {
      type: 'sessions',
      total: sids.length,
      active: activeSessions,
      avgDuration: sids.length > 0 ? Math.round(totalDuration / sids.length) : 0,
      avgEngagement: sids.length > 0 ? Math.round(totalEngagement / sids.length * 1000) / 1000 : 0
    };
  }
  if (reportType === 'counters') {
    var ckeys = Object.keys(counters);
    var counterList = [];
    for (var c = 0; c < ckeys.length; c++) {
      counterList.push({
        name: ckeys[c],
        value: counters[ckeys[c]].value,
        average: Math.round(counters[ckeys[c]].average * 1000) / 1000
      });
    }
    return { type: 'counters', counters: counterList, total: counterList.length };
  }
  // Default: summary
  return {
    type: 'summary',
    totalEvents: events.length,
    totalSessions: Object.keys(sessions).length,
    totalFunnels: Object.keys(funnels).length,
    totalCohorts: Object.keys(cohorts).length,
    totalCounters: Object.keys(counters).length
  };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'track': {
      var evt = trackEvent(msg.event || msg);
      self.postMessage({
        type: 'tracked',
        event: evt,
        totalEvents: events.length,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'funnel': {
      if (msg.stages) {
        var fd = defineFunnel(msg.funnelId, msg.stages);
        self.postMessage({ type: 'funnel-defined', funnel: fd, kernelId: KERNEL_ID });
      } else if (msg.stage) {
        var fr = recordFunnelEvent(msg.funnelId, msg.stage);
        self.postMessage({ type: 'funnel-recorded', funnelId: msg.funnelId, error: fr.error || null, kernelId: KERNEL_ID });
      } else {
        var rep = funnelReport(msg.funnelId);
        self.postMessage({ type: 'funnel-report', report: rep, kernelId: KERNEL_ID });
      }
      break;
    }

    case 'cohort': {
      if (msg.groupBy || msg.members) {
        var cd = defineCohort(msg.cohortId, msg);
        self.postMessage({ type: 'cohort-defined', cohort: cd, kernelId: KERNEL_ID });
      } else if (msg.memberId) {
        var ca = addCohortMember(msg.cohortId, msg.memberId, msg.bucket);
        self.postMessage({ type: 'cohort-member-added', cohortId: msg.cohortId, error: ca.error || null, kernelId: KERNEL_ID });
      } else {
        var cr = cohortReport(msg.cohortId);
        self.postMessage({ type: 'cohort-report', report: cr, kernelId: KERNEL_ID });
      }
      break;
    }

    case 'counter': {
      var cu = updateCounter(msg.name, msg.delta);
      self.postMessage({ type: 'counter-updated', counter: cu, kernelId: KERNEL_ID });
      break;
    }

    case 'session-start': {
      var ss = startSession(msg.sessionId);
      self.postMessage({
        type: 'session-started',
        session: { id: ss.id, startedAt: ss.startedAt },
        totalSessions: Object.keys(sessions).length,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'session-end': {
      var se = endSession(msg.sessionId);
      self.postMessage({
        type: 'session-ended',
        session: se,
        error: se.error || null,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'report': {
      var rpt = generateReport(msg.reportType || 'summary');
      self.postMessage({ type: 'analytics-report', report: rpt, kernelId: KERNEL_ID });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'status',
        kernelId: KERNEL_ID,
        family: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalEvents: events.length,
        totalSessions: Object.keys(sessions).length,
        totalFunnels: Object.keys(funnels).length,
        totalCohorts: Object.keys(cohorts).length,
        totalCounters: Object.keys(counters).length,
        beat: beatCount,
        phase: kernelPhase,
        phi: PHI
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

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalEvents: events.length,
    activeSessions: Object.keys(sessions).length
  });
}, HEARTBEAT);
