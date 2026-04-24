// ═══════════════════════════════════════════════════════════════════════════════
// SOCIETAS OPERANS — Internal Company Management Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// 8 departments, 20 autonomous scripts, 30 company protocols, KPI tracking.
// Manages the company-as-organism: budgets, staffing, scripts, governance.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI            = 1.618033988749895;
const INV_PHI        = 0.618033988749895;
const TAU            = 6.283185307179586;
const SCHUMANN       = 7.83;              // Earth resonance (Hz)
const HEARTBEAT_MS   = 873;               // ~69 bpm resting heart
const GOLDEN_PULSE_MS = 618;              // φ-aligned tick interval
const PLANCK         = 6.62607015e-34;    // Planck constant (J·s)
const BOLTZMANN      = 1.380649e-23;      // Boltzmann constant (J/K)

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  phase: Math.random() * TAU,
  freq: TAU / HEARTBEAT_MS,
  tick: function () {
    this.phase = (this.phase + this.freq * HEARTBEAT_MS * 0.001) % TAU;
    return { phase: this.phase, pulse: Math.sin(this.phase) };
  }
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
let tickCount = 0;

// ─── DEPARTMENT REGISTRY ────────────────────────────────────────────────────────
var DEPT_DEFS = [
  { name: 'ENGINEERING',  latinName: 'Ingenium',     head: 'Praefectus Ingenium',    staff: 24 },
  { name: 'RESEARCH',     latinName: 'Investigatio', head: 'Praefectus Investigatio', staff: 16 },
  { name: 'OPERATIONS',   latinName: 'Operatio',     head: 'Praefectus Operatio',     staff: 12 },
  { name: 'SECURITY',     latinName: 'Securitas',    head: 'Praefectus Securitas',    staff: 10 },
  { name: 'PRODUCT',      latinName: 'Productum',    head: 'Praefectus Productum',    staff: 8 },
  { name: 'MARKETING',    latinName: 'Mercatura',    head: 'Praefectus Mercatura',    staff: 6 },
  { name: 'FINANCE',      latinName: 'Fiscus',       head: 'Praefectus Fiscus',       staff: 5 },
  { name: 'GOVERNANCE',   latinName: 'Gubernatio',   head: 'Praefectus Gubernatio',   staff: 4 },
];

function buildDepartments() {
  var depts = [];
  for (var i = 0; i < DEPT_DEFS.length; i++) {
    var d = DEPT_DEFS[i];
    var phiWeight = Math.pow(PHI, i + 1);
    depts.push({
      id: i,
      name: d.name,
      latinName: d.latinName,
      head: d.head,
      staff: d.staff,
      budget: Math.round(phiWeight * 50000 * 100) / 100,
      projects: ['Project-' + d.latinName + '-Alpha', 'Project-' + d.latinName + '-Beta'],
      kpis: {
        efficiency: 0.85 + Math.random() * 0.14,
        delivery: 0.80 + Math.random() * 0.19,
        quality: 0.88 + Math.random() * 0.11,
      },
      status: 'ACTIVE',
    });
  }
  return depts;
}

var departments = buildDepartments();

// ─── AUTONOMOUS SCRIPTS REGISTRY ────────────────────────────────────────────────
var SCRIPT_NAMES = [
  'auto-deploy',   'auto-test',     'auto-monitor',  'auto-backup',   'auto-scale',
  'auto-heal',     'auto-report',   'auto-audit',    'auto-train',    'auto-optimize',
  'auto-research', 'auto-document', 'auto-release',  'auto-certify',  'auto-compress',
  'auto-archive',  'auto-sync',     'auto-notify',   'auto-review',   'auto-plan',
];

var SCRIPT_TYPES = ['CRON', 'EVENT', 'CONTINUOUS'];

function buildScripts() {
  var scripts = [];
  for (var i = 0; i < SCRIPT_NAMES.length; i++) {
    var typeIdx = i % 3;
    scripts.push({
      id: i,
      name: SCRIPT_NAMES[i],
      type: SCRIPT_TYPES[typeIdx],
      status: typeIdx === 2 ? 'RUNNING' : 'IDLE',
      interval_ms: Math.round(HEARTBEAT_MS * Math.pow(PHI, (i % 5) + 1)),
      lastRun: 0,
      runCount: 0,
      successRate: 1.0,
    });
  }
  return scripts;
}

var scripts = buildScripts();

// ─── PRNG — Seeded xorshift ─────────────────────────────────────────────────────
var _seed = Date.now() ^ 0xFACEFEED;
function rand() {
  _seed ^= _seed << 13;
  _seed ^= _seed >> 17;
  _seed ^= _seed << 5;
  return ((_seed >>> 0) / 0xFFFFFFFF);
}

// ─── COMPANY PROTOCOLS ──────────────────────────────────────────────────────────
var PROTOCOL_CATEGORIES = ['HR', 'Finance', 'Operations', 'Security', 'Engineering', 'Governance'];

function buildProtocols() {
  var protos = [];
  var protoNames = [
    'Hiring Process', 'Onboarding', 'Performance Review', 'Termination', 'Training',
    'Budget Allocation', 'Expense Approval', 'Revenue Reporting', 'Audit Cycle', 'Tax Compliance',
    'Incident Response', 'Change Management', 'Capacity Planning', 'SLA Management', 'Disaster Recovery',
    'Access Control', 'Vulnerability Scan', 'Penetration Test', 'Data Classification', 'Breach Notification',
    'Code Review', 'Release Process', 'Architecture Review', 'Tech Debt Tracking', 'CI/CD Pipeline',
    'Board Reporting', 'Compliance Audit', 'Risk Assessment', 'Policy Update', 'Sovereign Oversight',
  ];
  for (var i = 0; i < 30; i++) {
    protos.push({
      id: i,
      name: protoNames[i],
      category: PROTOCOL_CATEGORIES[Math.floor(i / 5)],
      version: '1.' + Math.floor(i / 5) + '.' + (i % 5),
      status: 'ACTIVE',
      lastReview: Date.now() - Math.round(rand() * 86400000 * 30),
      compliance: 0.85 + rand() * 0.14,
    });
  }
  return protos;
}

var protocols = buildProtocols();

// ─── SCRIPT EXECUTION ───────────────────────────────────────────────────────────
function runScript(scriptId) {
  var script = scripts[scriptId];
  if (!script) return { error: 'Script not found: ' + scriptId };

  var startTime = Date.now();
  var prevStatus = script.status;
  script.status = 'RUNNING';

  // Simulate execution
  var success = rand() > 0.05;
  var duration = Math.round(GOLDEN_PULSE_MS * rand() * PHI);
  var output = script.name + ' completed in ' + duration + 'ms';

  script.runCount++;
  script.lastRun = Date.now();
  script.successRate = (script.successRate * (script.runCount - 1) + (success ? 1 : 0)) / script.runCount;
  script.status = success ? (script.type === 'CONTINUOUS' ? 'RUNNING' : 'IDLE') : 'ERROR';

  return {
    script: snapshotScript(script),
    result: { duration: duration, output: output, success: success }
  };
}

function snapshotScript(s) {
  return {
    id: s.id, name: s.name, type: s.type, status: s.status,
    interval_ms: s.interval_ms, lastRun: s.lastRun,
    runCount: s.runCount, successRate: Math.round(s.successRate * 10000) / 10000,
  };
}

function tickScripts() {
  var ticked = 0;
  for (var i = 0; i < scripts.length; i++) {
    if (scripts[i].type === 'CONTINUOUS' && scripts[i].status === 'RUNNING') {
      scripts[i].runCount++;
      scripts[i].lastRun = Date.now();
      ticked++;
    }
  }
  return { tickedCount: ticked, totalScripts: scripts.length };
}

// ─── KPI TRACKING ───────────────────────────────────────────────────────────────
function getKPIs() {
  var totalRuns = 0;
  var totalSuccess = 0;
  for (var i = 0; i < scripts.length; i++) {
    totalRuns += scripts[i].runCount;
    totalSuccess += scripts[i].runCount * scripts[i].successRate;
  }
  return {
    revenueGrowth: Math.round(PHI * tickCount * 0.01 * 100) / 100,
    deploymentFrequency: totalRuns / (tickCount || 1),
    meanTimeToRecovery: Math.round(HEARTBEAT_MS * INV_PHI),
    changeFailureRate: totalRuns > 0 ? 1 - (totalSuccess / totalRuns) : 0,
    leadTime: Math.round(GOLDEN_PULSE_MS * PHI),
  };
}

// ─── COMPANY STATUS ─────────────────────────────────────────────────────────────
function getCompanyStatus() {
  var deptHealth = [];
  for (var i = 0; i < departments.length; i++) {
    var k = departments[i].kpis;
    deptHealth.push((k.efficiency + k.delivery + k.quality) / 3);
  }
  var avgHealth = 0;
  for (var j = 0; j < deptHealth.length; j++) avgHealth += deptHealth[j];
  avgHealth = avgHealth / deptHealth.length;

  var runningScripts = 0;
  for (var s = 0; s < scripts.length; s++) {
    if (scripts[s].status === 'RUNNING') runningScripts++;
  }

  var complianceSum = 0;
  for (var p = 0; p < protocols.length; p++) complianceSum += protocols[p].compliance;
  var avgCompliance = complianceSum / protocols.length;

  return {
    departments: departments.map(function (d) {
      return { id: d.id, name: d.name, latinName: d.latinName, head: d.head, staff: d.staff, status: d.status };
    }),
    scripts: scripts.map(snapshotScript),
    kpis: getKPIs(),
    healthScore: Math.round(avgHealth * 100),
    runningScripts: runningScripts,
    protocolCompliance: Math.round(avgCompliance * 10000) / 10000,
  };
}

// ─── KURAMOTO / PHI COHERENCE ───────────────────────────────────────────────────
function computePhiCoherence() {
  var sumCos = 0;
  var sumSin = 0;
  for (var i = 0; i < departments.length; i++) {
    var theta = (i * PHI * TAU + MiniHeart.phase) % TAU;
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }
  return Math.sqrt(sumCos * sumCos + sumSin * sumSin) / departments.length;
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  var data = e.data || {};
  var cmd = data.cmd;
  switch (cmd) {
    case 'GET_DEPARTMENTS':
      self.postMessage({
        cmd: cmd,
        departments: departments.map(function (d) {
          return { id: d.id, name: d.name, latinName: d.latinName, head: d.head, staff: d.staff, budget: d.budget, projects: d.projects, kpis: d.kpis, status: d.status };
        })
      });
      break;
    case 'GET_SCRIPTS':
      self.postMessage({ cmd: cmd, scripts: scripts.map(snapshotScript) });
      break;
    case 'RUN_SCRIPT':
      self.postMessage({ cmd: cmd, result: runScript(data.scriptId) });
      break;
    case 'GET_PROTOCOLS':
      self.postMessage({ cmd: cmd, protocols: protocols });
      break;
    case 'GET_COMPANY_STATUS':
      self.postMessage({ cmd: cmd, status: getCompanyStatus() });
      break;
    case 'TICK_SCRIPTS':
      self.postMessage({ cmd: cmd, result: tickScripts() });
      break;
    case 'GET_STATUS': {
      var heart = MiniHeart.tick();
      self.postMessage({
        cmd: cmd, status: {
          worker: 'SOCIETAS_OPERANS', tickCount: tickCount,
          heartPhase: heart.phase, departments: departments.length,
          scripts: scripts.length, protocols: protocols.length,
        }
      });
      break;
    }
    default:
      self.postMessage({ cmd: cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT ──────────────────────────────────────────────────────────────────
setInterval(function () {
  tickCount++;
  tickScripts();
  var heart = MiniHeart.tick();

  var deptHealthScores = [];
  for (var i = 0; i < departments.length; i++) {
    var k = departments[i].kpis;
    deptHealthScores.push(Math.round(((k.efficiency + k.delivery + k.quality) / 3) * 100));
  }

  var runningCount = 0;
  for (var s = 0; s < scripts.length; s++) {
    if (scripts[s].status === 'RUNNING') runningCount++;
  }

  var complianceSum = 0;
  for (var p = 0; p < protocols.length; p++) complianceSum += protocols[p].compliance;

  self.postMessage({
    type: 'HEARTBEAT', worker: 'SOCIETAS_OPERANS',
    tick: tickCount, heart: heart,
    deptHealthScores: deptHealthScores,
    runningScripts: runningCount,
    protocolCompliance: Math.round((complianceSum / protocols.length) * 10000) / 10000,
    kuramotoPhase: heart.phase,
    phiCoherence: computePhiCoherence(),
  });
}, HEARTBEAT_MS);
