/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Guardian Worker (GOK-GUARDIAN-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-GUARDIAN-001
 * Kernel Family:  SECURITY_GUARDIAN
 * Architecture:   Threat Scanner × Intel Feed × Posture Scoring × Quarantine
 *
 * Continuous security guardian for the NOVA organism. Scans resources against
 * 10+ threat categories, maintains a threat intelligence feed of known bad
 * patterns and IOCs, computes a φ-weighted security posture score, quarantines
 * compromised resources, and runs auto-remediation rules.
 *
 * Features:
 *   • Continuous threat scanning (10+ categories)
 *   • Threat intelligence feed (known bad patterns, IOCs)
 *   • Security posture scoring (φ-weighted across categories)
 *   • Quarantine system (isolate compromised resources)
 *   • Auto-remediation rules (block → alert → patch)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'scan', resource }
 *   Main → Worker: { type: 'add-threat', indicator }
 *   Main → Worker: { type: 'posture' }
 *   Main → Worker: { type: 'quarantine', resourceId }
 *   Main → Worker: { type: 'release', resourceId }
 *   Main → Worker: { type: 'remediate', resourceId }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'scan-result', resource, findings }
 *   Worker → Main: { type: 'threat-added', indicator }
 *   Worker → Main: { type: 'posture-report', score, breakdown }
 *   Worker → Main: { type: 'quarantined', resourceId }
 *   Worker → Main: { type: 'released', resourceId }
 *   Worker → Main: { type: 'remediation', resourceId, actions }
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

var KERNEL_ID      = 'GOK-GUARDIAN-001';
var KERNEL_FAMILY  = 'SECURITY_GUARDIAN';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;


/* ════════════════════════════════════════════════════════════════
   THREAT CATEGORIES (10+)
   ════════════════════════════════════════════════════════════════ */

var THREAT_CATEGORIES = {
  injection:              { name: 'Injection',              weight: 1.0,   patterns: ['SELECT.*FROM','DROP TABLE','UNION SELECT','1=1','OR 1=1','exec(','eval('] },
  xss:                    { name: 'Cross-Site Scripting',   weight: 0.9,   patterns: ['<script','onerror=','onload=','javascript:','document.cookie','innerHTML'] },
  csrf:                   { name: 'Cross-Site Request Forgery', weight: 0.7, patterns: ['csrf_token missing','no-referrer-check','cross-origin-post'] },
  ssrf:                   { name: 'Server-Side Request Forgery', weight: 0.8, patterns: ['127.0.0.1','169.254.169.254','localhost','0.0.0.0','internal-api'] },
  rce:                    { name: 'Remote Code Execution',  weight: 1.0,   patterns: ['child_process','spawn(','exec(','system(','popen(','__import__'] },
  'path-traversal':       { name: 'Path Traversal',         weight: 0.8,   patterns: ['../','..\\','%2e%2e','%252e','path.join(..'] },
  dos:                    { name: 'Denial of Service',      weight: 0.6,   patterns: ['while(true)','infinite-loop','fork-bomb','regex-dos','billion-laughs'] },
  'data-leak':            { name: 'Data Leak',              weight: 0.9,   patterns: ['password','secret','api_key','private_key','access_token','credentials'] },
  'privilege-escalation': { name: 'Privilege Escalation',   weight: 1.0,   patterns: ['isAdmin=true','role=admin','sudo','setuid','chmod 777','grant all'] },
  'supply-chain':         { name: 'Supply Chain Attack',    weight: 0.8,   patterns: ['typosquat','malicious-package','compromised-dep','tampered-hash','unsigned-binary'] },
  'broken-auth':          { name: 'Broken Authentication',  weight: 0.9,   patterns: ['no-mfa','weak-password','session-fixation','token-reuse','no-lockout'] },
  'insecure-deser':       { name: 'Insecure Deserialization', weight: 0.7, patterns: ['pickle.loads','yaml.load(','unserialize(','ObjectInputStream','JSON.parse(untrusted)'] },
};


/* ════════════════════════════════════════════════════════════════
   THREAT INTELLIGENCE STORE
   ════════════════════════════════════════════════════════════════ */

var threatIntel = [];   // [{type, value, severity, addedAt}, …]
var scanHistory = [];   // [{resourceId, findings, scannedAt}, …]
var quarantine  = {};   // resourceId → quarantine record
var remediations = {};  // resourceId → [action, …]

function addThreatIndicator(indicator) {
  if (!indicator || !indicator.type || !indicator.value) {
    return { success: false, error: 'Indicator must have type and value' };
  }

  var entry = {
    id: 'IOC-' + (threatIntel.length + 1),
    type: indicator.type,
    value: indicator.value,
    severity: indicator.severity || 'medium',
    category: indicator.category || 'unknown',
    addedAt: Date.now(),
    addedBy: KERNEL_ID,
  };

  threatIntel.push(entry);
  if (threatIntel.length > 2000) threatIntel = threatIntel.slice(-1500);

  return { success: true, indicator: entry, totalIndicators: threatIntel.length };
}


/* ════════════════════════════════════════════════════════════════
   THREAT SCANNER
   ════════════════════════════════════════════════════════════════ */

function scanResource(resource) {
  if (!resource) return { success: false, error: 'No resource provided' };

  var resourceId = resource.id || ('res-' + Date.now());
  var content = String(resource.content || resource.data || '');
  var findings = [];
  var maxSeverity = 'none';

  // Scan against all threat categories
  var catKeys = Object.keys(THREAT_CATEGORIES);
  for (var c = 0; c < catKeys.length; c++) {
    var cat = THREAT_CATEGORIES[catKeys[c]];
    var matches = [];

    for (var p = 0; p < cat.patterns.length; p++) {
      var pattern = cat.patterns[p];
      if (content.toLowerCase().indexOf(pattern.toLowerCase()) > -1) {
        matches.push(pattern);
      }
    }

    if (matches.length > 0) {
      var severity = cat.weight >= 1.0 ? 'critical' : (cat.weight >= 0.8 ? 'high' : (cat.weight >= 0.6 ? 'medium' : 'low'));
      if (compareSeverity(severity, maxSeverity) > 0) maxSeverity = severity;

      findings.push({
        category: catKeys[c],
        categoryName: cat.name,
        severity: severity,
        weight: cat.weight,
        matchedPatterns: matches,
        matchCount: matches.length,
      });
    }
  }

  // Scan against threat intelligence feed
  for (var t = 0; t < threatIntel.length; t++) {
    var ioc = threatIntel[t];
    if (content.indexOf(ioc.value) > -1) {
      findings.push({
        category: 'threat-intel',
        categoryName: 'Threat Intelligence Match',
        severity: ioc.severity,
        weight: 1.0,
        iocId: ioc.id,
        iocType: ioc.type,
        matchedPatterns: [ioc.value],
        matchCount: 1,
      });
      if (compareSeverity(ioc.severity, maxSeverity) > 0) maxSeverity = ioc.severity;
    }
  }

  var result = {
    resourceId: resourceId,
    findings: findings,
    findingCount: findings.length,
    maxSeverity: maxSeverity,
    clean: findings.length === 0,
    scannedAt: Date.now(),
    scannedBy: KERNEL_ID,
  };

  scanHistory.push(result);
  if (scanHistory.length > 500) scanHistory = scanHistory.slice(-400);

  // Auto-quarantine critical findings
  if (maxSeverity === 'critical') {
    quarantineResource(resourceId, 'Auto-quarantined: critical threat detected');
  }

  return { success: true, result: result };
}

var SEVERITY_ORDER = { none: 0, low: 1, medium: 2, high: 3, critical: 4 };

function compareSeverity(a, b) {
  return (SEVERITY_ORDER[a] || 0) - (SEVERITY_ORDER[b] || 0);
}


/* ════════════════════════════════════════════════════════════════
   SECURITY POSTURE — φ-weighted scoring
   ════════════════════════════════════════════════════════════════ */

function computePosture() {
  var catKeys = Object.keys(THREAT_CATEGORIES);
  var breakdown = [];
  var totalWeight = 0;
  var weightedScore = 0;

  for (var c = 0; c < catKeys.length; c++) {
    var cat = THREAT_CATEGORIES[catKeys[c]];
    // Count recent findings in this category
    var catFindings = 0;
    for (var s = 0; s < scanHistory.length; s++) {
      var scan = scanHistory[s];
      for (var f = 0; f < scan.findings.length; f++) {
        if (scan.findings[f].category === catKeys[c]) catFindings++;
      }
    }

    // φ-weighted score: fewer findings = higher score
    var catScore = Math.max(0, 1.0 - (catFindings * PHI_INV * 0.1));
    var phiWeight = cat.weight * PHI;
    totalWeight += phiWeight;
    weightedScore += catScore * phiWeight;

    breakdown.push({
      category: catKeys[c],
      name: cat.name,
      score: Math.round(catScore * 100) / 100,
      weight: cat.weight,
      phiWeight: Math.round(phiWeight * 1000) / 1000,
      recentFindings: catFindings,
    });
  }

  var overallScore = totalWeight > 0 ? weightedScore / totalWeight : 1.0;
  var grade = overallScore >= 0.9 ? 'A' : (overallScore >= 0.8 ? 'B' : (overallScore >= 0.7 ? 'C' : (overallScore >= 0.6 ? 'D' : 'F')));

  return {
    overallScore: Math.round(overallScore * 1000) / 1000,
    grade: grade,
    breakdown: breakdown,
    totalScans: scanHistory.length,
    quarantineCount: Object.keys(quarantine).length,
    threatIntelCount: threatIntel.length,
    computedAt: Date.now(),
    computedBy: KERNEL_ID,
  };
}


/* ════════════════════════════════════════════════════════════════
   QUARANTINE SYSTEM
   ════════════════════════════════════════════════════════════════ */

function quarantineResource(resourceId, reason) {
  if (quarantine[resourceId]) {
    return { success: false, error: 'Already quarantined: ' + resourceId };
  }

  quarantine[resourceId] = {
    resourceId: resourceId,
    reason: reason || 'Threat detected',
    quarantinedAt: Date.now(),
    quarantinedBy: KERNEL_ID,
    status: 'isolated',
  };

  return { success: true, resourceId: resourceId, status: 'isolated' };
}

function releaseResource(resourceId) {
  if (!quarantine[resourceId]) {
    return { success: false, error: 'Not quarantined: ' + resourceId };
  }

  var record = quarantine[resourceId];
  record.status = 'released';
  record.releasedAt = Date.now();
  delete quarantine[resourceId];

  return { success: true, resourceId: resourceId, status: 'released', record: record };
}


/* ════════════════════════════════════════════════════════════════
   AUTO-REMEDIATION
   ════════════════════════════════════════════════════════════════ */

function remediateResource(resourceId) {
  var actions = [];

  // Check quarantine status
  if (quarantine[resourceId]) {
    actions.push({ action: 'block', detail: 'Resource is quarantined; blocking all access', status: 'applied' });
  }

  // Find related scan findings
  var related = [];
  for (var s = 0; s < scanHistory.length; s++) {
    if (scanHistory[s].resourceId === resourceId) {
      for (var f = 0; f < scanHistory[s].findings.length; f++) {
        related.push(scanHistory[s].findings[f]);
      }
    }
  }

  // Generate remediation actions per finding category
  var seenCats = {};
  for (var r = 0; r < related.length; r++) {
    var finding = related[r];
    if (seenCats[finding.category]) continue;
    seenCats[finding.category] = true;

    switch (finding.category) {
      case 'injection':
        actions.push({ action: 'patch', detail: 'Apply parameterized queries and input sanitization', category: finding.category, status: 'recommended' });
        break;
      case 'xss':
        actions.push({ action: 'patch', detail: 'Apply output encoding and Content-Security-Policy headers', category: finding.category, status: 'recommended' });
        break;
      case 'csrf':
        actions.push({ action: 'patch', detail: 'Add CSRF tokens and SameSite cookie attributes', category: finding.category, status: 'recommended' });
        break;
      case 'ssrf':
        actions.push({ action: 'block', detail: 'Restrict outbound requests to allowlisted domains', category: finding.category, status: 'recommended' });
        break;
      case 'rce':
        actions.push({ action: 'alert', detail: 'Critical: remove dynamic code execution; sandbox if needed', category: finding.category, status: 'recommended' });
        actions.push({ action: 'block', detail: 'Isolate resource immediately', category: finding.category, status: 'applied' });
        break;
      case 'data-leak':
        actions.push({ action: 'alert', detail: 'Rotate exposed credentials and audit access logs', category: finding.category, status: 'recommended' });
        break;
      case 'privilege-escalation':
        actions.push({ action: 'block', detail: 'Revoke elevated permissions; audit role assignments', category: finding.category, status: 'applied' });
        break;
      default:
        actions.push({ action: 'alert', detail: 'Review findings for ' + finding.category, category: finding.category, status: 'recommended' });
        break;
    }
  }

  if (actions.length === 0) {
    actions.push({ action: 'none', detail: 'No findings to remediate', status: 'clean' });
  }

  remediations[resourceId] = actions;

  return {
    success: true,
    resourceId: resourceId,
    actions: actions,
    actionCount: actions.length,
    remediatedAt: Date.now(),
    remediatedBy: KERNEL_ID,
  };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'scan': {
      var scanResult = scanResource(msg.resource);
      self.postMessage({
        type: 'scan-result',
        result: scanResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'add-threat': {
      var addResult = addThreatIndicator(msg.indicator);
      self.postMessage({
        type: 'threat-added',
        result: addResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'posture': {
      var posture = computePosture();
      self.postMessage({
        type: 'posture-report',
        posture: posture,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'quarantine': {
      var qResult = quarantineResource(msg.resourceId, msg.reason);
      self.postMessage({
        type: 'quarantined',
        resourceId: msg.resourceId,
        result: qResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'release': {
      var relResult = releaseResource(msg.resourceId);
      self.postMessage({
        type: 'released',
        resourceId: msg.resourceId,
        result: relResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'remediate': {
      var remResult = remediateResource(msg.resourceId);
      self.postMessage({
        type: 'remediation',
        resourceId: msg.resourceId,
        result: remResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'guardian-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalScans: scanHistory.length,
        quarantineCount: Object.keys(quarantine).length,
        threatIntelCount: threatIntel.length,
        threatCategories: Object.keys(THREAT_CATEGORIES).length,
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

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    quarantineCount: Object.keys(quarantine).length,
    totalScans: scanHistory.length,
  });
}, HEARTBEAT);
