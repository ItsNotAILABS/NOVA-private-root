/**
 * ============================================================================
 *  COMPANY WORKER — SOCIETAS AUTONOMA
 *  Kernel AI GOK-COMPANY-001  ·  Family: COMPANY_ORGANISM
 * ============================================================================
 *
 *  Internal departments · autonomous company scripts · company runtime.
 *  14 departments, 40 autonomous scripts, department health monitoring.
 *
 *  MiniHeart  — 873 ms Kuramoto pulse, φ-phase advance
 *  MiniBrain  — 5 regions, 3 chemicals, LIF membrane model
 *
 *  Commands:
 *    RUN_SCRIPT       — execute an autonomous company script
 *    GET_DEPARTMENTS  — list all internal departments
 *    GET_SCRIPTS      — list all autonomous scripts
 *    GET_ORG_CHART    — organizational topology
 *    DEPT_HEALTH      — department health report
 *    GET_BUDGET       — department budget allocation (φ-weighted)
 *    HIRE             — add headcount to a department
 *    GET_VITALS       — MiniHeart + MiniBrain vitals
 *    status           — kernel status
 *    stop             — graceful shutdown
 *
 *  Zero external dependencies.
 * ============================================================================
 */

/* ── §1  CONSTANTS ──────────────────────────────────────────────────────── */

var KERNEL_ID      = 'GOK-COMPANY-001';
var KERNEL_FAMILY  = 'COMPANY_ORGANISM';
var KERNEL_VERSION = '1.0.0';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var PHI_SQ    = 2.6180339887498948482;
var SQRT5     = 2.2360679774997896964;
var HEARTBEAT = 873;

/* ── §2  MINI-HEART ─────────────────────────────────────────────────────── */

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  /* auto-tick scripts */
  tickScripts();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    phase:       kernelPhase,
    departments: departments.length,
    activeScripts: scripts.filter(function(s) { return s.status === 'RUNNING'; }).length
  });
}

/* ── §3  MINI-BRAIN ─────────────────────────────────────────────────────── */

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0 },
    { name: 'Associative',  activation: 0.0, lif: -70.0 },
    { name: 'Executive',    activation: 0.0, lif: -70.0 },
    { name: 'Motor',        activation: 0.0, lif: -70.0 },
    { name: 'Memory',       activation: 0.0, lif: -70.0 }
  ],
  chemicals: {
    dopamine:      0.5,
    serotonin:     0.5,
    acetylcholine: 0.5
  },
  coherenceField: 0.0
};

function tickBrain() {
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += ((-70.0 - r.lif) * 0.05) + (Math.random() * 3.0);
    if (r.lif >= -55.0) {
      r.activation = Math.min(1.0, r.activation + 0.2);
      r.lif = -70.0;
    }
    r.activation *= 0.95;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  var sum = 0;
  for (var j = 0; j < brain.regions.length; j++) sum += brain.regions[j].activation;
  brain.coherenceField = sum / brain.regions.length;
}

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

/* ── §4  DEPARTMENTS ────────────────────────────────────────────────────── */

var departments = [
  { id: 'DEPT-ENG',  name: 'Engineering',         head: 'CTO',    headcount: 42, budget: 0 },
  { id: 'DEPT-RD',   name: 'Research & Development', head: 'VP R&D', headcount: 18, budget: 0 },
  { id: 'DEPT-PROD', name: 'Product',              head: 'CPO',    headcount: 12, budget: 0 },
  { id: 'DEPT-DSGN', name: 'Design',               head: 'CDO',    headcount: 8,  budget: 0 },
  { id: 'DEPT-DATA', name: 'Data Science',          head: 'Chief Data Officer', headcount: 15, budget: 0 },
  { id: 'DEPT-SEC',  name: 'Security',              head: 'CISO',   headcount: 10, budget: 0 },
  { id: 'DEPT-OPS',  name: 'Operations',            head: 'COO',    headcount: 14, budget: 0 },
  { id: 'DEPT-FIN',  name: 'Finance',               head: 'CFO',    headcount: 8,  budget: 0 },
  { id: 'DEPT-LEG',  name: 'Legal',                 head: 'CLO',    headcount: 6,  budget: 0 },
  { id: 'DEPT-HR',   name: 'Human Resources',       head: 'CHRO',   headcount: 7,  budget: 0 },
  { id: 'DEPT-MKT',  name: 'Marketing',             head: 'CMO',    headcount: 11, budget: 0 },
  { id: 'DEPT-SALE', name: 'Sales',                 head: 'CRO',    headcount: 20, budget: 0 },
  { id: 'DEPT-SUP',  name: 'Customer Support',      head: 'VP Support', headcount: 16, budget: 0 },
  { id: 'DEPT-GOV',  name: 'Governance & Compliance', head: 'CGO', headcount: 5,  budget: 0 }
];

/* φ-weighted budget allocation: larger depts get proportionally more */
(function allocateBudgets() {
  var totalHC = departments.reduce(function(s, d) { return s + d.headcount; }, 0);
  var baseBudget = 10000000; /* $10M total */
  for (var i = 0; i < departments.length; i++) {
    var ratio = departments[i].headcount / totalHC;
    departments[i].budget = Math.round(baseBudget * ratio * PHI_INV + baseBudget * ratio * (1 - PHI_INV));
  }
})();

/* ── §5  AUTONOMOUS SCRIPTS ─────────────────────────────────────────────── */

var scripts = [];

(function initScripts() {
  var defs = [
    /* Engineering */
    { name: 'auto-deploy',         dept: 'DEPT-ENG',  interval: 10, desc: 'Continuous deployment pipeline' },
    { name: 'code-review-bot',     dept: 'DEPT-ENG',  interval: 5,  desc: 'Automated code review and linting' },
    { name: 'dependency-updater',  dept: 'DEPT-ENG',  interval: 50, desc: 'Auto-update dependencies' },
    { name: 'perf-profiler',       dept: 'DEPT-ENG',  interval: 20, desc: 'Performance regression detector' },
    /* R&D */
    { name: 'experiment-runner',   dept: 'DEPT-RD',   interval: 15, desc: 'A/B experiment orchestration' },
    { name: 'paper-scanner',       dept: 'DEPT-RD',   interval: 100,desc: 'Research paper discovery' },
    { name: 'model-trainer',       dept: 'DEPT-RD',   interval: 30, desc: 'ML model training scheduler' },
    /* Product */
    { name: 'feature-flagger',     dept: 'DEPT-PROD', interval: 8,  desc: 'Feature flag management' },
    { name: 'roadmap-sync',        dept: 'DEPT-PROD', interval: 60, desc: 'Roadmap synchronization' },
    { name: 'user-feedback-ingest',dept: 'DEPT-PROD', interval: 12, desc: 'User feedback aggregation' },
    /* Data Science */
    { name: 'etl-pipeline',        dept: 'DEPT-DATA', interval: 10, desc: 'Extract-Transform-Load pipeline' },
    { name: 'anomaly-detector',    dept: 'DEPT-DATA', interval: 5,  desc: 'Real-time anomaly detection' },
    { name: 'data-quality-check',  dept: 'DEPT-DATA', interval: 15, desc: 'Data quality validation' },
    /* Security */
    { name: 'vuln-scanner',        dept: 'DEPT-SEC',  interval: 20, desc: 'Vulnerability scanning' },
    { name: 'access-auditor',      dept: 'DEPT-SEC',  interval: 25, desc: 'Access control audit' },
    { name: 'threat-intel',        dept: 'DEPT-SEC',  interval: 30, desc: 'Threat intelligence feed' },
    { name: 'secret-rotator',      dept: 'DEPT-SEC',  interval: 100,desc: 'Secret and key rotation' },
    /* Operations */
    { name: 'infra-scaler',        dept: 'DEPT-OPS',  interval: 8,  desc: 'Auto-scaling infrastructure' },
    { name: 'cost-optimizer',      dept: 'DEPT-OPS',  interval: 50, desc: 'Cloud cost optimization' },
    { name: 'incident-responder',  dept: 'DEPT-OPS',  interval: 3,  desc: 'Automated incident response' },
    { name: 'backup-verifier',     dept: 'DEPT-OPS',  interval: 60, desc: 'Backup integrity verification' },
    /* Finance */
    { name: 'invoice-processor',   dept: 'DEPT-FIN',  interval: 20, desc: 'Automated invoice processing' },
    { name: 'expense-categorizer', dept: 'DEPT-FIN',  interval: 15, desc: 'Expense auto-categorization' },
    { name: 'revenue-tracker',     dept: 'DEPT-FIN',  interval: 10, desc: 'Real-time revenue tracking' },
    /* Legal */
    { name: 'compliance-checker',  dept: 'DEPT-LEG',  interval: 30, desc: 'Regulatory compliance checking' },
    { name: 'contract-analyzer',   dept: 'DEPT-LEG',  interval: 25, desc: 'Contract clause analysis' },
    /* HR */
    { name: 'onboarding-flow',     dept: 'DEPT-HR',   interval: 40, desc: 'New hire onboarding automation' },
    { name: 'satisfaction-pulse',  dept: 'DEPT-HR',   interval: 50, desc: 'Employee satisfaction surveys' },
    { name: 'pto-manager',         dept: 'DEPT-HR',   interval: 20, desc: 'PTO and leave management' },
    /* Marketing */
    { name: 'campaign-optimizer',  dept: 'DEPT-MKT',  interval: 10, desc: 'Marketing campaign optimization' },
    { name: 'social-monitor',      dept: 'DEPT-MKT',  interval: 5,  desc: 'Social media monitoring' },
    { name: 'content-scheduler',   dept: 'DEPT-MKT',  interval: 15, desc: 'Content publication scheduling' },
    /* Sales */
    { name: 'lead-scorer',         dept: 'DEPT-SALE', interval: 8,  desc: 'Lead scoring engine' },
    { name: 'pipeline-forecast',   dept: 'DEPT-SALE', interval: 20, desc: 'Sales pipeline forecasting' },
    { name: 'quote-generator',     dept: 'DEPT-SALE', interval: 12, desc: 'Automated quote generation' },
    { name: 'territory-mapper',    dept: 'DEPT-SALE', interval: 60, desc: 'Sales territory optimization' },
    /* Support */
    { name: 'ticket-router',       dept: 'DEPT-SUP',  interval: 3,  desc: 'Support ticket auto-routing' },
    { name: 'kb-updater',          dept: 'DEPT-SUP',  interval: 30, desc: 'Knowledge base auto-update' },
    { name: 'sentiment-analyzer',  dept: 'DEPT-SUP',  interval: 5,  desc: 'Customer sentiment analysis' },
    /* Governance */
    { name: 'policy-enforcer',     dept: 'DEPT-GOV',  interval: 15, desc: 'Policy enforcement engine' },
    { name: 'audit-trail-logger',  dept: 'DEPT-GOV',  interval: 5,  desc: 'Audit trail logging' }
  ];
  for (var i = 0; i < defs.length; i++) {
    scripts.push({
      id:       'SCR-' + String(i + 1).padStart(3, '0'),
      name:     defs[i].name,
      deptId:   defs[i].dept,
      interval: defs[i].interval,  /* ticks between runs */
      desc:     defs[i].desc,
      status:   'IDLE',
      lastRun:  0,
      runCount: 0,
      nextRun:  defs[i].interval
    });
  }
})();

function tickScripts() {
  for (var i = 0; i < scripts.length; i++) {
    var s = scripts[i];
    if (beatCount >= s.nextRun) {
      s.status   = 'RUNNING';
      s.lastRun  = beatCount;
      s.runCount++;
      s.nextRun  = beatCount + s.interval;
      /* simulate completion after 1 tick */
      s.status = 'IDLE';
    }
  }
}

function runScript(scriptId) {
  var s = scripts.find(function(x) { return x.id === scriptId; });
  if (!s) return { error: 'Script not found: ' + scriptId };
  s.status   = 'RUNNING';
  s.lastRun  = beatCount;
  s.runCount++;
  s.nextRun  = beatCount + s.interval;
  s.status   = 'IDLE';
  return {
    scriptId: s.id,
    name:     s.name,
    dept:     s.deptId,
    runCount: s.runCount,
    result:   'SUCCESS'
  };
}

/* ── §6  ORG CHART ──────────────────────────────────────────────────────── */

function getOrgChart() {
  var ceo = { role: 'CEO', reports: [] };
  for (var i = 0; i < departments.length; i++) {
    var d = departments[i];
    ceo.reports.push({
      role:       d.head,
      department: d.name,
      deptId:     d.id,
      headcount:  d.headcount,
      scripts:    scripts.filter(function(s) { return s.deptId === d.id; }).length
    });
  }
  return ceo;
}

function getDeptHealth(deptId) {
  var d = departments.find(function(x) { return x.id === deptId; });
  if (!d) return { error: 'Department not found: ' + deptId };
  var deptScripts = scripts.filter(function(s) { return s.deptId === deptId; });
  var totalRuns = deptScripts.reduce(function(s, x) { return s + x.runCount; }, 0);
  var activeCount = deptScripts.filter(function(s) { return s.status === 'RUNNING'; }).length;
  return {
    department:  d.name,
    deptId:      d.id,
    head:        d.head,
    headcount:   d.headcount,
    budget:      d.budget,
    scripts:     deptScripts.length,
    totalRuns:   totalRuns,
    activeNow:   activeCount,
    health:      Math.min(1.0, (totalRuns * PHI_INV + d.headcount * 0.01) / (deptScripts.length + 1)),
    coherence:   brain.coherenceField
  };
}

/* ── §7  MESSAGE HANDLER ────────────────────────────────────────────────── */

self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {
    case 'RUN_SCRIPT': {
      var result = runScript(msg.scriptId);
      self.postMessage({ type: 'SCRIPT_RESULT', result: result, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_DEPARTMENTS': {
      self.postMessage({ type: 'DEPARTMENTS', result: departments, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_SCRIPTS': {
      self.postMessage({ type: 'SCRIPTS', result: scripts, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_ORG_CHART': {
      self.postMessage({ type: 'ORG_CHART', result: getOrgChart(), kernelId: KERNEL_ID });
      break;
    }
    case 'DEPT_HEALTH': {
      var hr = getDeptHealth(msg.deptId);
      self.postMessage({ type: 'DEPT_HEALTH_RESULT', result: hr, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_BUDGET': {
      var budgets = departments.map(function(d) {
        return { deptId: d.id, name: d.name, budget: d.budget, headcount: d.headcount };
      });
      self.postMessage({ type: 'BUDGET', result: budgets, totalBudget: 10000000, kernelId: KERNEL_ID });
      break;
    }
    case 'HIRE': {
      var dept = departments.find(function(d) { return d.id === msg.deptId; });
      if (!dept) {
        self.postMessage({ type: 'HIRE_RESULT', result: { error: 'Dept not found' }, kernelId: KERNEL_ID });
      } else {
        dept.headcount += (msg.count || 1);
        self.postMessage({ type: 'HIRE_RESULT', result: { deptId: dept.id, newHeadcount: dept.headcount }, kernelId: KERNEL_ID });
      }
      break;
    }
    case 'GET_VITALS': {
      self.postMessage({
        type: 'VITALS',
        result: {
          heart: { beat: beatCount, phase: kernelPhase, bpm: 60000 / HEARTBEAT },
          brain: brain,
          departments: departments.length,
          scripts: scripts.length,
          totalScriptRuns: scripts.reduce(function(s, x) { return s + x.runCount; }, 0)
        },
        kernelId: KERNEL_ID
      });
      break;
    }
    case 'status': {
      self.postMessage({
        type:         'status-report',
        kernelId:     KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version:      KERNEL_VERSION,
        beat:         beatCount,
        phase:        kernelPhase,
        departments:  departments.length,
        scripts:      scripts.length
      });
      break;
    }
    case 'stop': {
      running = false;
      if (_hbi) clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
    }
  }
};

/* ── §8  BOOT ───────────────────────────────────────────────────────────── */

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);

self.postMessage({
  type:     'init',
  kernelId: KERNEL_ID,
  family:   KERNEL_FAMILY,
  version:  KERNEL_VERSION,
  departments: departments.length,
  scripts: scripts.length,
  commands: [
    'RUN_SCRIPT', 'GET_DEPARTMENTS', 'GET_SCRIPTS', 'GET_ORG_CHART',
    'DEPT_HEALTH', 'GET_BUDGET', 'HIRE', 'GET_VITALS', 'status', 'stop'
  ]
});
