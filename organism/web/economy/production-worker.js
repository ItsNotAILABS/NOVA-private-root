/**
 * ============================================================================
 *  PRODUCTION WORKER — FABRICATOR PRODUCTIONIS
 *  Kernel AI GOK-PRODUCTION-001  ·  Family: PRODUCTION_PIPELINE
 * ============================================================================
 *
 *  Product factory + build pipeline + deploy pipeline + pipeline math layer.
 *  30 products × 10 categories × 12 pipeline stages × 6 environments.
 *
 *  MiniHeart  — 873 ms Kuramoto pulse, φ-phase advance
 *  MiniBrain  — 5 regions (Sensory/Associative/Executive/Motor/Memory),
 *               3 chemicals (Dopamine/Serotonin/Acetylcholine),
 *               LIF membrane model (−70 → −55 mV spike-reset)
 *
 *  Commands:
 *    BUILD           — trigger a build for a product
 *    DEPLOY          — deploy artifact to an environment
 *    ROLLBACK        — rollback to previous artifact
 *    GET_PIPELINE    — pipeline status for a product
 *    GET_CATALOG     — full product catalog
 *    GET_METRICS     — pipeline metrics (throughput, latency, success rate)
 *    GET_ENVIRONMENTS— list deployment environments
 *    GET_VITALS      — MiniHeart + MiniBrain vitals
 *    status          — kernel status
 *    stop            — graceful shutdown
 *
 *  Zero external dependencies.
 * ============================================================================
 */

/* ── §1  CONSTANTS ──────────────────────────────────────────────────────── */

var KERNEL_ID      = 'GOK-PRODUCTION-001';
var KERNEL_FAMILY  = 'PRODUCTION_PIPELINE';
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
    pipelineCount:  Object.keys(pipelines).length,
    buildCount:     buildHistory.length,
    deployCount:    deployHistory.length
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
    /* LIF: leak toward −70, random excitation */
    r.lif += ((-70.0 - r.lif) * 0.05) + (Math.random() * 3.0);
    if (r.lif >= -55.0) {
      r.activation = Math.min(1.0, r.activation + 0.2);
      r.lif = -70.0; /* spike-reset */
    }
    r.activation *= 0.95; /* decay */
  }
  /* chemical drift */
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  /* coherence */
  var sum = 0;
  for (var j = 0; j < brain.regions.length; j++) sum += brain.regions[j].activation;
  brain.coherenceField = sum / brain.regions.length;
}

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

/* ── §4  PRODUCT CATALOG ────────────────────────────────────────────────── */

var CATEGORIES = [
  'SDK', 'EXTENSION', 'SERVICE', 'CLI', 'LIBRARY',
  'FIRMWARE', 'PLATFORM', 'AGENT', 'PROTOCOL', 'RESEARCH'
];

var PRODUCTS = [];

(function initCatalog() {
  var names = [
    'NOVA Core SDK',            'NOVA Browser Extension',     'NOVA Terminal',
    'NOVA CLI',                 'NOVA Desktop App',           'NOVA Mobile App',
    'NOVA API Gateway',         'NOVA Auth Service',          'NOVA Data Pipeline',
    'NOVA ML Engine',           'NOVA Edge Runtime',          'NOVA IoT Firmware',
    'NOVA Mesh Protocol',       'NOVA Consensus Layer',       'NOVA Governance SDK',
    'NOVA Analytics Dashboard', 'NOVA Monitoring Agent',      'NOVA Security Scanner',
    'NOVA CI/CD Plugin',        'NOVA Container Runtime',     'NOVA Serverless Runtime',
    'NOVA Quantum Bridge',      'NOVA Neural Compiler',       'NOVA Knowledge Graph',
    'NOVA Digital Twin',        'NOVA Simulation Engine',     'NOVA Marketplace SDK',
    'NOVA Payment Gateway',     'NOVA Identity Service',      'NOVA Research Platform'
  ];
  for (var i = 0; i < names.length; i++) {
    PRODUCTS.push({
      id:       'PROD-' + String(i + 1).padStart(3, '0'),
      name:     names[i],
      category: CATEGORIES[i % CATEGORIES.length],
      version:  '1.0.0',
      status:   'ACTIVE'
    });
  }
})();

/* ── §5  PIPELINE ENGINE ────────────────────────────────────────────────── */

var STAGES = [
  'PLAN', 'BUILD', 'TEST', 'SCAN', 'CERTIFY', 'PACKAGE',
  'STAGE', 'CANARY', 'DEPLOY', 'VERIFY', 'MONITOR', 'COMPLETE'
];

var ENVIRONMENTS = [
  { id: 'DEV',        name: 'Development',  tier: 1 },
  { id: 'STAGING',    name: 'Staging',      tier: 2 },
  { id: 'CANARY',     name: 'Canary',       tier: 3 },
  { id: 'PRODUCTION', name: 'Production',   tier: 4 },
  { id: 'SOVEREIGN',  name: 'Sovereign',    tier: 5 },
  { id: 'EDGE',       name: 'Edge',         tier: 6 }
];

var pipelines     = Object.create(null);  /* productId → pipeline state */
var buildHistory  = [];
var deployHistory = [];

function makePipelineId() { return 'PL-' + Date.now().toString(36); }

function startBuild(productId) {
  var prod = PRODUCTS.find(function(p) { return p.id === productId; });
  if (!prod) return { error: 'Product not found: ' + productId };
  var plId = makePipelineId();
  var now  = Date.now();
  var pipeline = {
    pipelineId: plId,
    productId:  productId,
    product:    prod.name,
    stage:      STAGES[0],
    stageIndex: 0,
    startedAt:  now,
    updatedAt:  now,
    artifacts:  [],
    status:     'IN_PROGRESS'
  };
  pipelines[productId] = pipeline;
  buildHistory.push({ pipelineId: plId, productId: productId, startedAt: now });
  /* simulate stage progression */
  advancePipeline(productId);
  return pipeline;
}

function advancePipeline(productId) {
  var p = pipelines[productId];
  if (!p || p.status !== 'IN_PROGRESS') return;
  if (p.stageIndex < STAGES.length - 1) {
    p.stageIndex++;
    p.stage     = STAGES[p.stageIndex];
    p.updatedAt = Date.now();
    if (p.stageIndex === 5) { /* PACKAGE */
      p.artifacts.push({
        id:   'ART-' + Date.now().toString(36),
        type: 'WASM',
        size: Math.floor(Math.random() * 1000000) + 50000,
        hash: 'sha256-' + Math.random().toString(36).slice(2, 18)
      });
    }
    if (p.stageIndex >= STAGES.length - 1) {
      p.status = 'COMPLETE';
    }
  }
}

function deployProduct(productId, envId) {
  var prod = PRODUCTS.find(function(p) { return p.id === productId; });
  if (!prod) return { error: 'Product not found: ' + productId };
  var env = ENVIRONMENTS.find(function(e) { return e.id === envId; });
  if (!env) return { error: 'Environment not found: ' + envId };
  var record = {
    deployId:   'DEP-' + Date.now().toString(36),
    productId:  productId,
    product:    prod.name,
    envId:      envId,
    env:        env.name,
    deployedAt: Date.now(),
    status:     'DEPLOYED',
    version:    prod.version
  };
  deployHistory.push(record);
  return record;
}

function rollback(productId, envId) {
  var prev = null;
  for (var i = deployHistory.length - 1; i >= 0; i--) {
    if (deployHistory[i].productId === productId && deployHistory[i].envId === envId) {
      if (prev) break;
      prev = deployHistory[i];
    }
  }
  if (!prev) return { error: 'No deployment to rollback' };
  var record = {
    deployId:    'RBK-' + Date.now().toString(36),
    productId:   productId,
    envId:       envId,
    rolledBackTo: prev.deployId,
    rolledBackAt: Date.now(),
    status:      'ROLLED_BACK'
  };
  deployHistory.push(record);
  return record;
}

/* ── §6  PIPELINE MATH LAYER ────────────────────────────────────────────── */

function getPipelineMetrics() {
  var total   = buildHistory.length;
  var success = 0;
  var latencies = [];
  for (var k in pipelines) {
    if (pipelines[k].status === 'COMPLETE') {
      success++;
      latencies.push(pipelines[k].updatedAt - pipelines[k].startedAt);
    }
  }
  var avgLatency = latencies.length > 0
    ? latencies.reduce(function(a, b) { return a + b; }, 0) / latencies.length
    : 0;
  return {
    totalBuilds:    total,
    successRate:    total > 0 ? (success / total) : 0,
    avgLatencyMs:   avgLatency,
    totalDeploys:   deployHistory.length,
    environments:   ENVIRONMENTS.length,
    products:       PRODUCTS.length,
    phiThroughput:  total * PHI_INV,  /* φ-weighted throughput */
    coherence:      brain.coherenceField
  };
}

/* ── §7  MESSAGE HANDLER ────────────────────────────────────────────────── */

self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {
    case 'BUILD': {
      var result = startBuild(msg.productId);
      self.postMessage({ type: 'BUILD_RESULT', result: result, kernelId: KERNEL_ID });
      break;
    }
    case 'DEPLOY': {
      var dr = deployProduct(msg.productId, msg.envId);
      self.postMessage({ type: 'DEPLOY_RESULT', result: dr, kernelId: KERNEL_ID });
      break;
    }
    case 'ROLLBACK': {
      var rb = rollback(msg.productId, msg.envId);
      self.postMessage({ type: 'ROLLBACK_RESULT', result: rb, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_PIPELINE': {
      var pl = pipelines[msg.productId] || null;
      self.postMessage({ type: 'PIPELINE_STATUS', result: pl, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_CATALOG': {
      self.postMessage({ type: 'CATALOG', result: PRODUCTS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_METRICS': {
      self.postMessage({ type: 'METRICS', result: getPipelineMetrics(), kernelId: KERNEL_ID });
      break;
    }
    case 'GET_ENVIRONMENTS': {
      self.postMessage({ type: 'ENVIRONMENTS', result: ENVIRONMENTS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_VITALS': {
      self.postMessage({
        type: 'VITALS',
        result: {
          heart: { beat: beatCount, phase: kernelPhase, bpm: 60000 / HEARTBEAT },
          brain: brain,
          pipelines: Object.keys(pipelines).length,
          builds: buildHistory.length,
          deploys: deployHistory.length
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
        products:     PRODUCTS.length,
        categories:   CATEGORIES.length,
        stages:       STAGES.length,
        environments: ENVIRONMENTS.length
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
  products: PRODUCTS.length,
  categories: CATEGORIES.length,
  stages:   STAGES.length,
  environments: ENVIRONMENTS.length,
  commands: [
    'BUILD', 'DEPLOY', 'ROLLBACK', 'GET_PIPELINE',
    'GET_CATALOG', 'GET_METRICS', 'GET_ENVIRONMENTS', 'GET_VITALS',
    'status', 'stop'
  ]
});
