/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Engine Worker (GOK-ENGINE-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-ENGINE-001
 * Kernel Family:  COGNITIVE_DISPATCH
 * Architecture:   40 AI Model Families × φ-Weighted Task Router × Wire Topology
 *
 * This worker IS the brain. It holds all 40 model families, dispatches tasks
 * to the correct model via phi-weighted scoring, and maintains the wire
 * topology that connects every model to every other model.
 *
 * 40 AI Model Families (12 groups):
 *   CRAWLING(8), CONTEXT(5), COMMANDER(5), SENTRY(6), CODING_AGENT(9),
 *   INFRASTRUCTURE(7), WORKFLOW(5), TESTING(5), SECURITY(8),
 *   AI_ML_OPS(8), DATA_ENGINEERING(6), CONSCIOUSNESS(8)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'dispatch', task, priority, domain }
 *   Main → Worker: { type: 'route', modelId, input }
 *   Main → Worker: { type: 'topology' }
 *   Main → Worker: { type: 'status' }
 *   Worker → Main: { type: 'dispatch-result', modelId, output, coherence }
 *   Worker → Main: { type: 'route-result', modelId, chain, latency }
 *   Worker → Main: { type: 'topology-map', nodes, edges, coherence }
 *   Worker → Main: { type: 'heartbeat', beat, status, kernelState }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * MEDINA TECH — SOVEREIGN KERNEL ARCHITECTURE
 */


/* ════════════════════════════════════════════════════════════════
   KERNEL CONSTANTS
   ════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var PHI_SQ    = 2.6180339887498948482;
var SQRT5     = 2.2360679774997896964;
var HEARTBEAT = 873;

var KERNEL_ID      = 'GOK-ENGINE-001';
var KERNEL_FAMILY  = 'COGNITIVE_DISPATCH';
var KERNEL_VERSION = '1.0.0';

var beatCount    = 0;
var running      = true;
var kernelPhase  = 0.0;
var totalDispatches = 0;


/* ════════════════════════════════════════════════════════════════
   40 AI MODEL FAMILIES — 12 groups, 80 total models
   ════════════════════════════════════════════════════════════════ */

var MODEL_FAMILIES = [
  // CRAWLING (8)
  { id: 'GOM-01', family: 'Crawling', name: 'Web Crawler Alpha',       capabilities: ['http-fetch', 'html-parse', 'sitemap'],       weight: 1.0 },
  { id: 'GOM-02', family: 'Crawling', name: 'Deep Crawler',            capabilities: ['js-render', 'spa-crawl', 'shadow-dom'],       weight: 0.95 },
  { id: 'GOM-03', family: 'Crawling', name: 'API Crawler',             capabilities: ['rest-probe', 'graphql-introspect', 'openapi'], weight: 0.90 },
  { id: 'GOM-04', family: 'Crawling', name: 'Feed Crawler',            capabilities: ['rss', 'atom', 'json-feed'],                   weight: 0.85 },
  { id: 'GOM-05', family: 'Crawling', name: 'Archive Crawler',         capabilities: ['wayback', 'cache-fetch', 'snapshot'],          weight: 0.80 },
  { id: 'GOM-06', family: 'Crawling', name: 'Media Crawler',           capabilities: ['image-extract', 'video-meta', 'audio-tag'],    weight: 0.78 },
  { id: 'GOM-07', family: 'Crawling', name: 'Social Crawler',          capabilities: ['profile-scan', 'post-extract', 'graph-walk'],  weight: 0.75 },
  { id: 'GOM-08', family: 'Crawling', name: 'Dark Crawler',            capabilities: ['tor-proxy', 'onion-resolve', 'stealth'],       weight: 0.70 },

  // CONTEXT (5)
  { id: 'GOM-09', family: 'Context',  name: 'Context Assembler',       capabilities: ['rag', 'embedding-search', 'chunk'],            weight: 1.0 },
  { id: 'GOM-10', family: 'Context',  name: 'Semantic Linker',         capabilities: ['entity-link', 'coreference', 'knowledge-graph'], weight: 0.95 },
  { id: 'GOM-11', family: 'Context',  name: 'Temporal Context',        capabilities: ['time-series', 'event-order', 'causality'],     weight: 0.90 },
  { id: 'GOM-12', family: 'Context',  name: 'Spatial Context',         capabilities: ['geo-encode', 'proximity', 'region-map'],       weight: 0.85 },
  { id: 'GOM-13', family: 'Context',  name: 'Dialogue Context',        capabilities: ['turn-track', 'intent-memory', 'slot-fill'],    weight: 0.80 },

  // COMMANDER (5)
  { id: 'GOM-14', family: 'Commander', name: 'Task Commander',         capabilities: ['decompose', 'delegate', 'merge'],              weight: 1.0 },
  { id: 'GOM-15', family: 'Commander', name: 'Priority Commander',     capabilities: ['rank', 'triage', 'deadline'],                  weight: 0.95 },
  { id: 'GOM-16', family: 'Commander', name: 'Resource Commander',     capabilities: ['allocate', 'balance', 'throttle'],             weight: 0.90 },
  { id: 'GOM-17', family: 'Commander', name: 'Strategy Commander',     capabilities: ['plan', 'simulate', 'decide'],                  weight: 0.85 },
  { id: 'GOM-18', family: 'Commander', name: 'Crisis Commander',       capabilities: ['escalate', 'rollback', 'isolate'],             weight: 0.80 },

  // SENTRY (6)
  { id: 'GOM-19', family: 'Sentry',   name: 'Perimeter Sentry',       capabilities: ['firewall', 'rate-limit', 'geo-block'],         weight: 1.0 },
  { id: 'GOM-20', family: 'Sentry',   name: 'Anomaly Sentry',         capabilities: ['outlier-detect', 'drift-monitor', 'alert'],    weight: 0.95 },
  { id: 'GOM-21', family: 'Sentry',   name: 'Auth Sentry',            capabilities: ['token-verify', 'session-guard', 'mfa'],        weight: 0.90 },
  { id: 'GOM-22', family: 'Sentry',   name: 'Data Sentry',            capabilities: ['pii-scan', 'redact', 'classify'],              weight: 0.85 },
  { id: 'GOM-23', family: 'Sentry',   name: 'Network Sentry',         capabilities: ['packet-inspect', 'dns-guard', 'tls-verify'],   weight: 0.80 },
  { id: 'GOM-24', family: 'Sentry',   name: 'Compliance Sentry',      capabilities: ['gdpr-check', 'hipaa-scan', 'sox-audit'],       weight: 0.75 },

  // CODING AGENT (9)
  { id: 'GOM-25', family: 'Coding_Agent', name: 'Code Generator',     capabilities: ['codegen', 'scaffold', 'template'],             weight: 1.0 },
  { id: 'GOM-26', family: 'Coding_Agent', name: 'Code Reviewer',      capabilities: ['lint', 'style-check', 'security-scan'],        weight: 0.95 },
  { id: 'GOM-27', family: 'Coding_Agent', name: 'Code Refactor',      capabilities: ['extract', 'rename', 'simplify'],               weight: 0.90 },
  { id: 'GOM-28', family: 'Coding_Agent', name: 'Test Writer',        capabilities: ['unit-test', 'integration-test', 'mock'],        weight: 0.88 },
  { id: 'GOM-29', family: 'Coding_Agent', name: 'Doc Writer',         capabilities: ['jsdoc', 'readme', 'api-doc'],                  weight: 0.85 },
  { id: 'GOM-30', family: 'Coding_Agent', name: 'Debug Agent',        capabilities: ['trace', 'breakpoint', 'stack-analyze'],         weight: 0.82 },
  { id: 'GOM-31', family: 'Coding_Agent', name: 'Build Agent',        capabilities: ['compile', 'bundle', 'optimize'],               weight: 0.80 },
  { id: 'GOM-32', family: 'Coding_Agent', name: 'Deploy Agent',       capabilities: ['ci-cd', 'container', 'serverless'],            weight: 0.78 },
  { id: 'GOM-33', family: 'Coding_Agent', name: 'Migration Agent',    capabilities: ['schema-diff', 'data-migrate', 'version'],       weight: 0.75 },

  // INFRASTRUCTURE (7)
  { id: 'GOM-34', family: 'Infrastructure', name: 'Infra Provisioner', capabilities: ['terraform', 'cloudform', 'pulumi'],            weight: 1.0 },
  { id: 'GOM-35', family: 'Infrastructure', name: 'Container Orchestrator', capabilities: ['k8s', 'docker', 'compose'],               weight: 0.95 },
  { id: 'GOM-36', family: 'Infrastructure', name: 'Network Architect', capabilities: ['vpc', 'subnet', 'load-balance'],              weight: 0.90 },
  { id: 'GOM-37', family: 'Infrastructure', name: 'Storage Manager',  capabilities: ['s3', 'block', 'filesystem'],                   weight: 0.85 },
  { id: 'GOM-38', family: 'Infrastructure', name: 'DNS Manager',      capabilities: ['zone', 'record', 'health-check'],              weight: 0.80 },
  { id: 'GOM-39', family: 'Infrastructure', name: 'Cert Manager',     capabilities: ['tls-issue', 'rotate', 'acme'],                 weight: 0.78 },
  { id: 'GOM-40', family: 'Infrastructure', name: 'Monitoring Agent', capabilities: ['metrics', 'logs', 'traces'],                   weight: 0.75 },

  // WORKFLOW (5)
  { id: 'GOM-41', family: 'Workflow', name: 'Pipeline Builder',       capabilities: ['dag', 'step-chain', 'parallel'],               weight: 1.0 },
  { id: 'GOM-42', family: 'Workflow', name: 'Event Router',           capabilities: ['pubsub', 'webhook', 'queue'],                  weight: 0.95 },
  { id: 'GOM-43', family: 'Workflow', name: 'Schedule Engine',        capabilities: ['cron', 'interval', 'trigger'],                 weight: 0.90 },
  { id: 'GOM-44', family: 'Workflow', name: 'State Machine',          capabilities: ['fsm', 'saga', 'compensate'],                   weight: 0.85 },
  { id: 'GOM-45', family: 'Workflow', name: 'Approval Flow',          capabilities: ['gate', 'vote', 'escalate'],                    weight: 0.80 },

  // TESTING (5)
  { id: 'GOM-46', family: 'Testing', name: 'Unit Test Runner',        capabilities: ['assert', 'mock', 'snapshot'],                  weight: 1.0 },
  { id: 'GOM-47', family: 'Testing', name: 'Integration Tester',      capabilities: ['e2e', 'api-test', 'contract'],                 weight: 0.95 },
  { id: 'GOM-48', family: 'Testing', name: 'Load Tester',             capabilities: ['stress', 'soak', 'spike'],                     weight: 0.90 },
  { id: 'GOM-49', family: 'Testing', name: 'Chaos Engineer',          capabilities: ['fault-inject', 'latency', 'partition'],         weight: 0.85 },
  { id: 'GOM-50', family: 'Testing', name: 'Fuzz Tester',             capabilities: ['random-input', 'boundary', 'mutation'],         weight: 0.80 },

  // SECURITY (8)
  { id: 'GOM-51', family: 'Security', name: 'Vuln Scanner',           capabilities: ['cve-scan', 'dep-audit', 'sast'],               weight: 1.0 },
  { id: 'GOM-52', family: 'Security', name: 'Pen Tester',             capabilities: ['exploit', 'payload', 'recon'],                 weight: 0.95 },
  { id: 'GOM-53', family: 'Security', name: 'Crypto Auditor',         capabilities: ['key-strength', 'algo-check', 'entropy'],        weight: 0.90 },
  { id: 'GOM-54', family: 'Security', name: 'Access Controller',      capabilities: ['rbac', 'abac', 'policy'],                      weight: 0.88 },
  { id: 'GOM-55', family: 'Security', name: 'Incident Responder',     capabilities: ['contain', 'eradicate', 'recover'],             weight: 0.85 },
  { id: 'GOM-56', family: 'Security', name: 'Threat Hunter',          capabilities: ['ioc-scan', 'yara', 'sigma'],                   weight: 0.82 },
  { id: 'GOM-57', family: 'Security', name: 'Forensic Analyst',       capabilities: ['timeline', 'artifact-collect', 'chain'],        weight: 0.80 },
  { id: 'GOM-58', family: 'Security', name: 'Policy Enforcer',        capabilities: ['opa', 'sentinel', 'guardrail'],                weight: 0.75 },

  // AI/ML OPS (8)
  { id: 'GOM-59', family: 'AI_ML_Ops', name: 'Model Trainer',         capabilities: ['fine-tune', 'distill', 'quantize'],            weight: 1.0 },
  { id: 'GOM-60', family: 'AI_ML_Ops', name: 'Feature Engineer',      capabilities: ['extract', 'transform', 'select'],              weight: 0.95 },
  { id: 'GOM-61', family: 'AI_ML_Ops', name: 'Eval Engine',           capabilities: ['benchmark', 'a-b-test', 'metric'],             weight: 0.90 },
  { id: 'GOM-62', family: 'AI_ML_Ops', name: 'Serving Engine',        capabilities: ['inference', 'batch', 'stream'],                weight: 0.88 },
  { id: 'GOM-63', family: 'AI_ML_Ops', name: 'Data Labeler',          capabilities: ['annotate', 'review', 'consensus'],             weight: 0.85 },
  { id: 'GOM-64', family: 'AI_ML_Ops', name: 'Experiment Tracker',    capabilities: ['mlflow', 'wandb', 'version'],                  weight: 0.82 },
  { id: 'GOM-65', family: 'AI_ML_Ops', name: 'Pipeline Orchestrator', capabilities: ['kubeflow', 'airflow', 'prefect'],              weight: 0.80 },
  { id: 'GOM-66', family: 'AI_ML_Ops', name: 'Drift Detector',        capabilities: ['data-drift', 'concept-drift', 'retrain'],      weight: 0.75 },

  // DATA ENGINEERING (6)
  { id: 'GOM-67', family: 'Data_Engineering', name: 'ETL Builder',    capabilities: ['extract', 'transform', 'load'],                weight: 1.0 },
  { id: 'GOM-68', family: 'Data_Engineering', name: 'Schema Architect', capabilities: ['normalize', 'denormalize', 'evolve'],         weight: 0.95 },
  { id: 'GOM-69', family: 'Data_Engineering', name: 'Query Optimizer', capabilities: ['explain', 'index', 'partition'],               weight: 0.90 },
  { id: 'GOM-70', family: 'Data_Engineering', name: 'Stream Processor', capabilities: ['kafka', 'flink', 'window'],                   weight: 0.85 },
  { id: 'GOM-71', family: 'Data_Engineering', name: 'Data Quality',   capabilities: ['validate', 'dedupe', 'reconcile'],             weight: 0.82 },
  { id: 'GOM-72', family: 'Data_Engineering', name: 'Catalog Manager', capabilities: ['lineage', 'glossary', 'discover'],             weight: 0.78 },

  // CONSCIOUSNESS (8)
  { id: 'GOM-73', family: 'Consciousness', name: 'Awareness Engine',   capabilities: ['self-model', 'meta-cognition', 'introspect'],  weight: 1.0 },
  { id: 'GOM-74', family: 'Consciousness', name: 'Thought Architect', capabilities: ['reason-chain', 'abstraction', 'analogy'],       weight: 0.95 },
  { id: 'GOM-75', family: 'Consciousness', name: 'Phantom Weaver',    capabilities: ['phantom-model', 'shadow-sim', 'dream'],         weight: 0.90 },
  { id: 'GOM-76', family: 'Consciousness', name: 'Entity Guide',      capabilities: ['entity-track', 'identity-model', 'persona'],    weight: 0.88 },
  { id: 'GOM-77', family: 'Consciousness', name: 'Field Harmonic',    capabilities: ['kuramoto-sync', 'phase-lock', 'resonance'],     weight: 0.85 },
  { id: 'GOM-78', family: 'Consciousness', name: 'Emergence Monitor', capabilities: ['emergence-detect', 'complexity-measure', 'bifurcation'], weight: 0.82 },
  { id: 'GOM-79', family: 'Consciousness', name: 'Doctrine Engine',   capabilities: ['law-enforce', 'sovereignty-check', 'integrity'], weight: 0.80 },
  { id: 'GOM-80', family: 'Consciousness', name: 'Transcendence Core', capabilities: ['self-improve', 'meta-learn', 'evolve'],        weight: 0.75 },
];


/* ════════════════════════════════════════════════════════════════
   WIRE TOPOLOGY — Every model connected to every other model
   Adjacency is φ-weighted by family proximity
   ════════════════════════════════════════════════════════════════ */

var _topologyCache = null;

function buildTopology() {
  if (_topologyCache) return _topologyCache;

  var families = {};
  for (var i = 0; i < MODEL_FAMILIES.length; i++) {
    var m = MODEL_FAMILIES[i];
    if (!families[m.family]) families[m.family] = [];
    families[m.family].push(m.id);
  }

  var familyNames = Object.keys(families);
  var nodes = [];
  var edges = [];

  for (var ni = 0; ni < MODEL_FAMILIES.length; ni++) {
    nodes.push({
      id: MODEL_FAMILIES[ni].id,
      family: MODEL_FAMILIES[ni].family,
      name: MODEL_FAMILIES[ni].name,
      capabilities: MODEL_FAMILIES[ni].capabilities,
      weight: MODEL_FAMILIES[ni].weight,
    });
  }

  // Build edges: intra-family = strong (φ), inter-family = weaker (φ⁻¹)
  for (var ei = 0; ei < MODEL_FAMILIES.length; ei++) {
    for (var ej = ei + 1; ej < MODEL_FAMILIES.length; ej++) {
      var a = MODEL_FAMILIES[ei];
      var b = MODEL_FAMILIES[ej];
      var strength = (a.family === b.family) ? PHI_INV : (PHI_INV * PHI_INV);
      edges.push({
        from: a.id,
        to: b.id,
        strength: strength * a.weight * b.weight,
      });
    }
  }

  var totalStrength = 0;
  for (var si = 0; si < edges.length; si++) totalStrength += edges[si].strength;
  var coherence = totalStrength / (edges.length * PHI_INV);

  _topologyCache = {
    nodes: nodes,
    edges: edges,
    families: familyNames,
    familyCount: familyNames.length,
    modelCount: nodes.length,
    edgeCount: edges.length,
    coherence: Math.min(coherence, 1.0),
  };
  return _topologyCache;
}


/* ════════════════════════════════════════════════════════════════
   TASK DISPATCH — φ-weighted capability matching
   ════════════════════════════════════════════════════════════════ */

function findBestModel(task, domain) {
  var bestScore = -1;
  var bestModel = null;
  var taskLower = (task || '').toLowerCase();
  var domainLower = (domain || '').toLowerCase();

  for (var i = 0; i < MODEL_FAMILIES.length; i++) {
    var m = MODEL_FAMILIES[i];
    var score = 0;

    // Family match bonus
    if (domainLower && m.family.toLowerCase().indexOf(domainLower) >= 0) {
      score += PHI;
    }

    // Capability keyword match
    for (var c = 0; c < m.capabilities.length; c++) {
      if (taskLower.indexOf(m.capabilities[c]) >= 0) {
        score += PHI_INV;
      }
    }

    // Base weight
    score += m.weight * PHI_INV;

    if (score > bestScore) {
      bestScore = score;
      bestModel = m;
    }
  }

  return { model: bestModel, score: bestScore };
}

function dispatchTask(task, priority, domain) {
  totalDispatches++;
  var result = findBestModel(task, domain);
  if (!result.model) {
    return { modelId: null, output: 'No model matched', coherence: 0 };
  }

  // Simulate execution time based on priority and model weight
  var latency = Math.round((1.0 / (result.model.weight + 0.01)) * (priority || 1) * 10);

  return {
    modelId: result.model.id,
    modelName: result.model.name,
    family: result.model.family,
    capabilities: result.model.capabilities,
    output: 'Task dispatched to ' + result.model.name + ': ' + task,
    coherence: result.score / (PHI + PHI_INV + 1.0),
    latencyMs: latency,
    dispatchCount: totalDispatches,
  };
}

function routeToModel(modelId, input) {
  var model = null;
  for (var i = 0; i < MODEL_FAMILIES.length; i++) {
    if (MODEL_FAMILIES[i].id === modelId) {
      model = MODEL_FAMILIES[i];
      break;
    }
  }
  if (!model) {
    return { modelId: modelId, error: 'Model not found', chain: [] };
  }

  // Build a routing chain: target model + its family peers
  var chain = [model.id];
  for (var j = 0; j < MODEL_FAMILIES.length; j++) {
    if (MODEL_FAMILIES[j].family === model.family && MODEL_FAMILIES[j].id !== model.id) {
      chain.push(MODEL_FAMILIES[j].id);
    }
  }

  return {
    modelId: model.id,
    modelName: model.name,
    family: model.family,
    chain: chain,
    input: input,
    output: model.name + ' processed: ' + input,
    latency: Math.round((1.0 / model.weight) * 5),
  };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'dispatch': {
      var dr = dispatchTask(msg.task, msg.priority, msg.domain);
      self.postMessage({
        type: 'dispatch-result',
        modelId: dr.modelId,
        modelName: dr.modelName,
        family: dr.family,
        output: dr.output,
        coherence: dr.coherence,
        latencyMs: dr.latencyMs,
        dispatchCount: dr.dispatchCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'route': {
      var rr = routeToModel(msg.modelId, msg.input);
      self.postMessage({
        type: 'route-result',
        modelId: rr.modelId,
        modelName: rr.modelName,
        family: rr.family,
        chain: rr.chain,
        output: rr.output,
        latency: rr.latency,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'topology': {
      var topo = buildTopology();
      self.postMessage({
        type: 'topology-map',
        nodes: topo.nodes,
        edges: topo.edges,
        families: topo.families,
        familyCount: topo.familyCount,
        modelCount: topo.modelCount,
        edgeCount: topo.edgeCount,
        coherence: topo.coherence,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'engine-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        modelCount: MODEL_FAMILIES.length,
        totalDispatches: totalDispatches,
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
    totalDispatches: totalDispatches,
    modelCount: MODEL_FAMILIES.length,
  });
}, HEARTBEAT);
