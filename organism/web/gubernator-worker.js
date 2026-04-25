/**
 * ============================================================================
 *  GUBERNATOR WORKER — GUBERNATOR GREGIS
 *  Kernel AI GOK-GUBERNATOR-001  ·  Family: GOVERNANCE_CRM
 * ============================================================================
 *
 *  Enterprise maps · Salesforce answer layer · 14 ASIs · 40 scripts · 35 APIs
 *  Client / governance infrastructure
 *
 *  MiniHeart  — 873 ms Kuramoto pulse, φ-phase advance
 *  MiniBrain  — 5 regions, 3 chemicals, LIF membrane model
 *
 *  Commands:
 *    QUERY_API        — invoke one of 35 governance APIs
 *    RUN_SCRIPT       — run one of 40 governance scripts
 *    GET_ASIS         — list 14 ASI controllers
 *    GET_CLIENTS      — client registry
 *    ADD_CLIENT       — register a client
 *    GET_ENTERPRISE_MAP — enterprise topology map
 *    GET_GOVERNANCE   — governance dashboard
 *    GET_APIS         — list all 35 APIs
 *    GET_SCRIPTS      — list all 40 scripts
 *    GET_VITALS       — MiniHeart + MiniBrain vitals
 *    status           — kernel status
 *    stop             — graceful shutdown
 *
 *  Zero external dependencies.
 * ============================================================================
 */

/* ── §1  CONSTANTS ──────────────────────────────────────────────────────── */

var KERNEL_ID      = 'GOK-GUBERNATOR-001';
var KERNEL_FAMILY  = 'GOVERNANCE_CRM';
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
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    phase:       kernelPhase,
    asiCount:    ASIS.length,
    clientCount: clients.length
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

/* ── §4  14 ASI CONTROLLERS ─────────────────────────────────────────────── */

var ASIS = [
  { id: 'ASI-01', name: 'PRAEFECTUS',    domain: 'Executive Governance',       status: 'ACTIVE' },
  { id: 'ASI-02', name: 'STRATEGICUS',   domain: 'Strategic Planning',          status: 'ACTIVE' },
  { id: 'ASI-03', name: 'FISCALIS',      domain: 'Financial Oversight',         status: 'ACTIVE' },
  { id: 'ASI-04', name: 'SECURITAS',     domain: 'Security & Compliance',       status: 'ACTIVE' },
  { id: 'ASI-05', name: 'RELATOR',       domain: 'Client Relations',            status: 'ACTIVE' },
  { id: 'ASI-06', name: 'ANALYTICUS',    domain: 'Data Analytics',              status: 'ACTIVE' },
  { id: 'ASI-07', name: 'INTEGRATOR',    domain: 'System Integration',          status: 'ACTIVE' },
  { id: 'ASI-08', name: 'PROVISOR',      domain: 'Resource Provisioning',       status: 'ACTIVE' },
  { id: 'ASI-09', name: 'REGULARIS',     domain: 'Regulatory Compliance',       status: 'ACTIVE' },
  { id: 'ASI-10', name: 'MERCATOR',      domain: 'Market Intelligence',         status: 'ACTIVE' },
  { id: 'ASI-11', name: 'ARBITER',       domain: 'Dispute Resolution',          status: 'ACTIVE' },
  { id: 'ASI-12', name: 'DOCUMENTOR',    domain: 'Document Management',         status: 'ACTIVE' },
  { id: 'ASI-13', name: 'COMMUNICATOR',  domain: 'Communications Hub',          status: 'ACTIVE' },
  { id: 'ASI-14', name: 'AUDITOR',       domain: 'Audit & Accountability',      status: 'ACTIVE' }
];

/* ── §5  35 GOVERNANCE APIS ─────────────────────────────────────────────── */

var APIS = [
  /* Client Management */
  { id: 'API-01', name: 'client.create',         category: 'Client',     method: 'POST' },
  { id: 'API-02', name: 'client.read',           category: 'Client',     method: 'GET' },
  { id: 'API-03', name: 'client.update',         category: 'Client',     method: 'PUT' },
  { id: 'API-04', name: 'client.delete',         category: 'Client',     method: 'DELETE' },
  { id: 'API-05', name: 'client.search',         category: 'Client',     method: 'GET' },
  /* Governance */
  { id: 'API-06', name: 'governance.policies',   category: 'Governance', method: 'GET' },
  { id: 'API-07', name: 'governance.enforce',     category: 'Governance', method: 'POST' },
  { id: 'API-08', name: 'governance.audit',       category: 'Governance', method: 'GET' },
  { id: 'API-09', name: 'governance.compliance',  category: 'Governance', method: 'GET' },
  { id: 'API-10', name: 'governance.exceptions',  category: 'Governance', method: 'POST' },
  /* Finance */
  { id: 'API-11', name: 'finance.invoices',       category: 'Finance',   method: 'GET' },
  { id: 'API-12', name: 'finance.payments',       category: 'Finance',   method: 'POST' },
  { id: 'API-13', name: 'finance.revenue',        category: 'Finance',   method: 'GET' },
  { id: 'API-14', name: 'finance.forecast',       category: 'Finance',   method: 'GET' },
  { id: 'API-15', name: 'finance.budget',         category: 'Finance',   method: 'GET' },
  /* Analytics */
  { id: 'API-16', name: 'analytics.dashboard',    category: 'Analytics', method: 'GET' },
  { id: 'API-17', name: 'analytics.reports',      category: 'Analytics', method: 'GET' },
  { id: 'API-18', name: 'analytics.metrics',      category: 'Analytics', method: 'GET' },
  { id: 'API-19', name: 'analytics.trends',       category: 'Analytics', method: 'GET' },
  { id: 'API-20', name: 'analytics.predict',      category: 'Analytics', method: 'POST' },
  /* Security */
  { id: 'API-21', name: 'security.scan',          category: 'Security',  method: 'POST' },
  { id: 'API-22', name: 'security.incidents',     category: 'Security',  method: 'GET' },
  { id: 'API-23', name: 'security.access',        category: 'Security',  method: 'GET' },
  { id: 'API-24', name: 'security.certificates',  category: 'Security',  method: 'GET' },
  { id: 'API-25', name: 'security.keys',          category: 'Security',  method: 'GET' },
  /* Integration */
  { id: 'API-26', name: 'integration.salesforce',  category: 'Integration', method: 'POST' },
  { id: 'API-27', name: 'integration.erp',         category: 'Integration', method: 'POST' },
  { id: 'API-28', name: 'integration.crm',         category: 'Integration', method: 'POST' },
  { id: 'API-29', name: 'integration.webhook',     category: 'Integration', method: 'POST' },
  { id: 'API-30', name: 'integration.sync',        category: 'Integration', method: 'POST' },
  /* Regulatory */
  { id: 'API-31', name: 'regulatory.gdpr',         category: 'Regulatory', method: 'GET' },
  { id: 'API-32', name: 'regulatory.sox',          category: 'Regulatory', method: 'GET' },
  { id: 'API-33', name: 'regulatory.hipaa',        category: 'Regulatory', method: 'GET' },
  { id: 'API-34', name: 'regulatory.iso27001',     category: 'Regulatory', method: 'GET' },
  { id: 'API-35', name: 'regulatory.fedramp',      category: 'Regulatory', method: 'GET' }
];

/* ── §6  40 GOVERNANCE SCRIPTS ──────────────────────────────────────────── */

var SCRIPTS = [
  /* Policy */
  { id: 'GS-01', name: 'policy-enforcer',         category: 'Policy',     interval: 10 },
  { id: 'GS-02', name: 'policy-validator',        category: 'Policy',     interval: 15 },
  { id: 'GS-03', name: 'policy-propagator',       category: 'Policy',     interval: 20 },
  { id: 'GS-04', name: 'policy-versioner',        category: 'Policy',     interval: 50 },
  /* Compliance */
  { id: 'GS-05', name: 'compliance-scanner',      category: 'Compliance', interval: 10 },
  { id: 'GS-06', name: 'compliance-reporter',     category: 'Compliance', interval: 30 },
  { id: 'GS-07', name: 'compliance-remediator',   category: 'Compliance', interval: 20 },
  { id: 'GS-08', name: 'compliance-certifier',    category: 'Compliance', interval: 60 },
  /* Audit */
  { id: 'GS-09', name: 'audit-logger',            category: 'Audit',      interval: 3 },
  { id: 'GS-10', name: 'audit-analyzer',          category: 'Audit',      interval: 15 },
  { id: 'GS-11', name: 'audit-reporter',          category: 'Audit',      interval: 30 },
  { id: 'GS-12', name: 'audit-archiver',          category: 'Audit',      interval: 100 },
  /* Client Ops */
  { id: 'GS-13', name: 'client-onboarding',       category: 'ClientOps',  interval: 5 },
  { id: 'GS-14', name: 'client-health-check',     category: 'ClientOps',  interval: 8 },
  { id: 'GS-15', name: 'client-engagement',       category: 'ClientOps',  interval: 12 },
  { id: 'GS-16', name: 'client-renewal',          category: 'ClientOps',  interval: 30 },
  { id: 'GS-17', name: 'client-escalation',       category: 'ClientOps',  interval: 5 },
  /* Data */
  { id: 'GS-18', name: 'data-classifier',         category: 'Data',       interval: 10 },
  { id: 'GS-19', name: 'data-anonymizer',         category: 'Data',       interval: 20 },
  { id: 'GS-20', name: 'data-retention',          category: 'Data',       interval: 60 },
  { id: 'GS-21', name: 'data-lineage',            category: 'Data',       interval: 30 },
  /* Risk */
  { id: 'GS-22', name: 'risk-assessor',           category: 'Risk',       interval: 15 },
  { id: 'GS-23', name: 'risk-mitigator',          category: 'Risk',       interval: 20 },
  { id: 'GS-24', name: 'risk-monitor',            category: 'Risk',       interval: 8 },
  { id: 'GS-25', name: 'risk-reporter',           category: 'Risk',       interval: 30 },
  /* Integration */
  { id: 'GS-26', name: 'salesforce-sync',         category: 'Integration', interval: 10 },
  { id: 'GS-27', name: 'erp-bridge',              category: 'Integration', interval: 15 },
  { id: 'GS-28', name: 'crm-updater',             category: 'Integration', interval: 10 },
  { id: 'GS-29', name: 'webhook-dispatcher',      category: 'Integration', interval: 3 },
  { id: 'GS-30', name: 'api-health-check',        category: 'Integration', interval: 5 },
  /* Finance */
  { id: 'GS-31', name: 'invoice-generator',       category: 'Finance',    interval: 20 },
  { id: 'GS-32', name: 'payment-reconciler',      category: 'Finance',    interval: 15 },
  { id: 'GS-33', name: 'revenue-calculator',      category: 'Finance',    interval: 10 },
  { id: 'GS-34', name: 'forecast-modeler',        category: 'Finance',    interval: 60 },
  /* Security */
  { id: 'GS-35', name: 'access-reviewer',         category: 'Security',   interval: 20 },
  { id: 'GS-36', name: 'cert-rotator',            category: 'Security',   interval: 100 },
  { id: 'GS-37', name: 'anomaly-detector',        category: 'Security',   interval: 5 },
  /* Reporting */
  { id: 'GS-38', name: 'board-report-gen',        category: 'Reporting',  interval: 200 },
  { id: 'GS-39', name: 'kpi-tracker',             category: 'Reporting',  interval: 10 },
  { id: 'GS-40', name: 'dashboard-updater',       category: 'Reporting',  interval: 5 }
];

/* runtime state for scripts */
var scriptState = {};
(function() {
  for (var i = 0; i < SCRIPTS.length; i++) {
    scriptState[SCRIPTS[i].id] = { runCount: 0, lastRun: 0, status: 'IDLE', nextRun: SCRIPTS[i].interval };
  }
})();

/* ── §7  CLIENT REGISTRY ────────────────────────────────────────────────── */

var clients = [];

function addClient(name, tier, industry) {
  var client = {
    id:        'CLT-' + Date.now().toString(36),
    name:      name,
    tier:      tier || 'STANDARD',
    industry:  industry || 'Technology',
    createdAt: Date.now(),
    status:    'ACTIVE',
    health:    1.0
  };
  clients.push(client);
  return client;
}

/* ── §8  ENTERPRISE MAP ─────────────────────────────────────────────────── */

function getEnterpriseMap() {
  return {
    asis:       ASIS.length,
    apis:       APIS.length,
    scripts:    SCRIPTS.length,
    clients:    clients.length,
    categories: {
      apis:    groupByCategory(APIS),
      scripts: groupByCategory(SCRIPTS)
    },
    asiDomains: ASIS.map(function(a) { return { id: a.id, name: a.name, domain: a.domain }; }),
    topology: {
      layers: [
        { name: 'Presentation', components: ['Dashboard', 'Reports', 'Alerts'] },
        { name: 'API Gateway',  components: APIS.slice(0, 5).map(function(a) { return a.name; }) },
        { name: 'ASI Fleet',    components: ASIS.map(function(a) { return a.name; }) },
        { name: 'Script Engine', components: ['Policy', 'Compliance', 'Audit', 'Data', 'Risk'] },
        { name: 'Data Layer',   components: ['Client DB', 'Audit Log', 'Policy Store', 'Analytics'] }
      ]
    }
  };
}

function groupByCategory(items) {
  var groups = {};
  for (var i = 0; i < items.length; i++) {
    var cat = items[i].category;
    if (!groups[cat]) groups[cat] = 0;
    groups[cat]++;
  }
  return groups;
}

/* ── §9  GOVERNANCE DASHBOARD ───────────────────────────────────────────── */

function getGovernanceDashboard() {
  var totalRuns = 0;
  for (var k in scriptState) totalRuns += scriptState[k].runCount;
  return {
    asiStatus:   ASIS.map(function(a) { return { id: a.id, name: a.name, status: a.status }; }),
    apiCount:    APIS.length,
    scriptCount: SCRIPTS.length,
    clientCount: clients.length,
    totalScriptRuns: totalRuns,
    coherence:   brain.coherenceField,
    health:      clamp01((brain.coherenceField * PHI + (totalRuns > 0 ? 0.5 : 0)) / PHI_SQ)
  };
}

/* ── §10 SCRIPT RUNNER ──────────────────────────────────────────────────── */

function runGovernanceScript(scriptId) {
  var s = SCRIPTS.find(function(x) { return x.id === scriptId; });
  if (!s) return { error: 'Script not found: ' + scriptId };
  var st = scriptState[scriptId];
  st.runCount++;
  st.lastRun = beatCount;
  st.nextRun = beatCount + s.interval;
  return {
    scriptId: s.id,
    name:     s.name,
    category: s.category,
    runCount: st.runCount,
    result:   'SUCCESS'
  };
}

/* ── §11 API QUERY ──────────────────────────────────────────────────────── */

function queryApi(apiId, params) {
  var api = APIS.find(function(a) { return a.id === apiId; });
  if (!api) return { error: 'API not found: ' + apiId };
  return {
    apiId:    api.id,
    name:     api.name,
    method:   api.method,
    category: api.category,
    params:   params || {},
    result:   'OK',
    latencyMs: Math.floor(Math.random() * 100 * PHI_INV) + 5,
    timestamp: Date.now()
  };
}

/* ── §12 MESSAGE HANDLER ────────────────────────────────────────────────── */

self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {
    case 'QUERY_API': {
      var result = queryApi(msg.apiId, msg.params);
      self.postMessage({ type: 'API_RESULT', result: result, kernelId: KERNEL_ID });
      break;
    }
    case 'RUN_SCRIPT': {
      var sr = runGovernanceScript(msg.scriptId);
      self.postMessage({ type: 'SCRIPT_RESULT', result: sr, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_ASIS': {
      self.postMessage({ type: 'ASIS', result: ASIS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_CLIENTS': {
      self.postMessage({ type: 'CLIENTS', result: clients, kernelId: KERNEL_ID });
      break;
    }
    case 'ADD_CLIENT': {
      var cl = addClient(msg.name, msg.tier, msg.industry);
      self.postMessage({ type: 'CLIENT_ADDED', result: cl, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_ENTERPRISE_MAP': {
      self.postMessage({ type: 'ENTERPRISE_MAP', result: getEnterpriseMap(), kernelId: KERNEL_ID });
      break;
    }
    case 'GET_GOVERNANCE': {
      self.postMessage({ type: 'GOVERNANCE', result: getGovernanceDashboard(), kernelId: KERNEL_ID });
      break;
    }
    case 'GET_APIS': {
      self.postMessage({ type: 'API_LIST', result: APIS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_SCRIPTS': {
      self.postMessage({ type: 'SCRIPT_LIST', result: SCRIPTS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_VITALS': {
      self.postMessage({
        type: 'VITALS',
        result: {
          heart: { beat: beatCount, phase: kernelPhase, bpm: 60000 / HEARTBEAT },
          brain: brain,
          asis: ASIS.length,
          apis: APIS.length,
          scripts: SCRIPTS.length,
          clients: clients.length
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
        asis:         ASIS.length,
        apis:         APIS.length,
        scripts:      SCRIPTS.length,
        clients:      clients.length
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

/* ── §13 BOOT ───────────────────────────────────────────────────────────── */

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);

self.postMessage({
  type:     'init',
  kernelId: KERNEL_ID,
  family:   KERNEL_FAMILY,
  version:  KERNEL_VERSION,
  asis:     ASIS.length,
  apis:     APIS.length,
  scripts:  SCRIPTS.length,
  commands: [
    'QUERY_API', 'RUN_SCRIPT', 'GET_ASIS', 'GET_CLIENTS', 'ADD_CLIENT',
    'GET_ENTERPRISE_MAP', 'GET_GOVERNANCE', 'GET_APIS', 'GET_SCRIPTS',
    'GET_VITALS', 'status', 'stop'
  ]
});
