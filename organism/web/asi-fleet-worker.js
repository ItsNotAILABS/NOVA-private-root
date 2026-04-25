/**
 * ============================================================================
 *  ASI FLEET WORKER — CLASSIS SUPERINTELLIGENTIAE
 *  Kernel AI GOK-ASI-FLEET-001  ·  Family: ASI_FLEET_ORGANISM
 * ============================================================================
 *
 *  Auto-discovery · auto-registration · auto-compression
 *  50 AGI protocols · 100 calls · 100 queries
 *
 *  MiniHeart  — 873 ms Kuramoto pulse, φ-phase advance
 *  MiniBrain  — 5 regions, 3 chemicals, LIF membrane model
 *
 *  Commands:
 *    DISCOVER         — auto-discover ASI agents
 *    REGISTER         — register a new ASI agent
 *    COMPRESS         — compress agent state (Fibonacci compression)
 *    INVOKE_PROTOCOL  — invoke one of 50 AGI protocols
 *    INVOKE_CALL      — invoke one of 100 calls
 *    INVOKE_QUERY     — invoke one of 100 queries
 *    GET_FLEET        — list entire ASI fleet
 *    GET_PROTOCOLS    — list all 50 AGI protocols
 *    GET_CALLS        — list all 100 calls
 *    GET_QUERIES      — list all 100 queries
 *    GET_VITALS       — MiniHeart + MiniBrain vitals
 *    status           — kernel status
 *    stop             — graceful shutdown
 *
 *  Zero external dependencies.
 * ============================================================================
 */

/* ── §1  CONSTANTS ──────────────────────────────────────────────────────── */

var KERNEL_ID      = 'GOK-ASI-FLEET-001';
var KERNEL_FAMILY  = 'ASI_FLEET_ORGANISM';
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
  /* auto-discovery pulse: every 10 beats, discover new agents */
  if (beatCount % 10 === 0) autoDiscover();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    phase:       kernelPhase,
    fleetSize:   fleet.length,
    protocols:   PROTOCOLS.length,
    calls:       CALLS.length,
    queries:     QUERIES.length
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

/* ── §4  ASI FLEET ──────────────────────────────────────────────────────── */

var fleet = [];
var discoveryCount = 0;

function registerAgent(name, capabilities, tier) {
  var agent = {
    id:           'ASI-' + Date.now().toString(36) + '-' + fleet.length,
    name:         name,
    capabilities: capabilities || [],
    tier:         tier || 'AGI',
    status:       'ACTIVE',
    registeredAt: Date.now(),
    lastSeen:     Date.now(),
    compressed:   false,
    compressionLevel: 'F1_RAW',
    callCount:    0,
    queryCount:   0
  };
  fleet.push(agent);
  return agent;
}

function autoDiscover() {
  discoveryCount++;
  /* simulated discovery: occasional new agent */
  if (fleet.length < 50 && Math.random() < 0.3) {
    var names = [
      'LEXIS', 'NUMERUS', 'CUSTOS', 'EVOLUTIO', 'MEMORIA',
      'NEXTOR', 'SOLUTOR', 'FABRICATOR', 'VIGILIATOR', 'ORCHESTRATOR',
      'CEREBRALIS', 'MEMORIALIS', 'COGNITANS', 'CONSCIENS', 'STRATEGICUS',
      'ANALYTICUS', 'PROVISOR', 'INTEGRATOR', 'REGULARIS', 'MERCATOR'
    ];
    var caps = [
      ['reasoning', 'logic'], ['math', 'computation'], ['security', 'defense'],
      ['evolution', 'adaptation'], ['memory', 'retrieval'], ['wiring', 'integration'],
      ['optimization', 'search'], ['construction', 'assembly'], ['monitoring', 'alerting'],
      ['orchestration', 'scheduling']
    ];
    var idx = fleet.length % names.length;
    registerAgent(
      names[idx] + '-' + discoveryCount,
      caps[idx % caps.length],
      Math.random() > 0.7 ? 'ASI' : 'AGI'
    );
  }
}

/* ── §5  FIBONACCI COMPRESSION ──────────────────────────────────────────── */

var COMPRESSION_LEVELS = [
  'F1_RAW', 'F2_ENCODED', 'F3_VERIFIED', 'F5_INDEXED',
  'F8_PACKAGED', 'F13_SEALED', 'F21_COMPRESSED', 'F34_OPTIMIZED'
];

function compressAgent(agentId) {
  var agent = fleet.find(function(a) { return a.id === agentId; });
  if (!agent) return { error: 'Agent not found: ' + agentId };
  var idx = COMPRESSION_LEVELS.indexOf(agent.compressionLevel);
  if (idx >= COMPRESSION_LEVELS.length - 1) {
    return { agentId: agentId, level: agent.compressionLevel, message: 'Already at max compression' };
  }
  agent.compressionLevel = COMPRESSION_LEVELS[idx + 1];
  agent.compressed = true;
  return {
    agentId:   agentId,
    name:      agent.name,
    from:      COMPRESSION_LEVELS[idx],
    to:        agent.compressionLevel,
    fibValue:  [1, 1, 2, 3, 5, 8, 13, 21][idx + 1] || 34,
    ratio:     PHI_INV
  };
}

/* ── §6  50 AGI PROTOCOLS ───────────────────────────────────────────────── */

var PROTOCOLS = [];

(function initProtocols() {
  var defs = [
    /* Reasoning (10) */
    'LOGICAL_INFERENCE', 'CAUSAL_REASONING', 'ANALOGICAL_TRANSFER', 'ABDUCTIVE_INFERENCE',
    'TEMPORAL_REASONING', 'SPATIAL_REASONING', 'COUNTERFACTUAL', 'META_REASONING',
    'PROBABILISTIC_INFERENCE', 'CONSTRAINT_SATISFACTION',
    /* Learning (10) */
    'DEEP_LEARNING', 'REINFORCEMENT_LEARNING', 'TRANSFER_LEARNING', 'FEW_SHOT',
    'ZERO_SHOT', 'CONTINUAL_LEARNING', 'SELF_SUPERVISED', 'CURRICULUM_LEARNING',
    'ACTIVE_LEARNING', 'FEDERATED_LEARNING',
    /* Perception (10) */
    'VISUAL_RECOGNITION', 'AUDITORY_PROCESSING', 'MULTIMODAL_FUSION', 'SCENE_UNDERSTANDING',
    'OBJECT_DETECTION', 'SPEECH_RECOGNITION', 'EMOTION_DETECTION', 'GESTURE_INTERPRETATION',
    'DEPTH_ESTIMATION', 'SEMANTIC_SEGMENTATION',
    /* Communication (10) */
    'NATURAL_LANGUAGE', 'DIALOGUE_MANAGEMENT', 'SENTIMENT_ANALYSIS', 'QUESTION_ANSWERING',
    'SUMMARIZATION', 'TRANSLATION', 'CODE_GENERATION', 'KNOWLEDGE_RETRIEVAL',
    'INTENT_CLASSIFICATION', 'ENTITY_EXTRACTION',
    /* Autonomy (10) */
    'PLANNING', 'GOAL_SETTING', 'SELF_MONITORING', 'RESOURCE_ALLOCATION',
    'TASK_DECOMPOSITION', 'WORLD_MODELING', 'SAFETY_ALIGNMENT', 'VALUE_LEARNING',
    'SELF_IMPROVEMENT', 'CONSCIOUSNESS_SIMULATION'
  ];
  for (var i = 0; i < defs.length; i++) {
    PROTOCOLS.push({
      id:       'PROT-' + String(i + 1).padStart(3, '0'),
      name:     defs[i],
      category: ['Reasoning','Learning','Perception','Communication','Autonomy'][Math.floor(i / 10)],
      version:  '1.0.0',
      status:   'ACTIVE',
      callCount: 0
    });
  }
})();

/* ── §7  100 CALLS ──────────────────────────────────────────────────────── */

var CALLS = [];

(function initCalls() {
  var prefixes = [
    'invoke', 'execute', 'dispatch', 'schedule', 'queue',
    'broadcast', 'relay', 'cascade', 'pipeline', 'orchestrate'
  ];
  var targets = [
    'inference', 'training', 'evaluation', 'optimization', 'compression',
    'indexing', 'retrieval', 'synthesis', 'validation', 'deployment'
  ];
  for (var i = 0; i < 100; i++) {
    var pi = i % prefixes.length;
    var ti = Math.floor(i / prefixes.length) % targets.length;
    CALLS.push({
      id:       'CALL-' + String(i + 1).padStart(3, '0'),
      name:     prefixes[pi] + '_' + targets[ti],
      protocol: 'PROT-' + String((i % 50) + 1).padStart(3, '0'),
      callCount: 0,
      latencyMs: 0
    });
  }
})();

/* ── §8  100 QUERIES ────────────────────────────────────────────────────── */

var QUERIES = [];

(function initQueries() {
  var verbs = [
    'get', 'list', 'search', 'count', 'describe',
    'analyze', 'compare', 'rank', 'predict', 'summarize'
  ];
  var objects = [
    'agents', 'models', 'protocols', 'capabilities', 'metrics',
    'states', 'history', 'topology', 'coherence', 'performance'
  ];
  for (var i = 0; i < 100; i++) {
    var vi = i % verbs.length;
    var oi = Math.floor(i / verbs.length) % objects.length;
    QUERIES.push({
      id:        'QRY-' + String(i + 1).padStart(3, '0'),
      name:      verbs[vi] + '_' + objects[oi],
      protocol:  'PROT-' + String((i % 50) + 1).padStart(3, '0'),
      queryCount: 0,
      latencyMs:  0
    });
  }
})();

/* ── §9  INVOCATIONS ────────────────────────────────────────────────────── */

function invokeProtocol(protocolId, params) {
  var p = PROTOCOLS.find(function(x) { return x.id === protocolId; });
  if (!p) return { error: 'Protocol not found: ' + protocolId };
  p.callCount++;
  return {
    protocolId: p.id,
    name:       p.name,
    category:   p.category,
    params:     params || {},
    result:     'EXECUTED',
    latencyMs:  Math.floor(Math.random() * 50 * PHI_INV) + 2,
    timestamp:  Date.now()
  };
}

function invokeCall(callId, params) {
  var c = CALLS.find(function(x) { return x.id === callId; });
  if (!c) return { error: 'Call not found: ' + callId };
  c.callCount++;
  c.latencyMs = Math.floor(Math.random() * 80 * PHI_INV) + 3;
  return {
    callId:    c.id,
    name:      c.name,
    protocol:  c.protocol,
    params:    params || {},
    result:    'OK',
    latencyMs: c.latencyMs,
    timestamp: Date.now()
  };
}

function invokeQuery(queryId, params) {
  var q = QUERIES.find(function(x) { return x.id === queryId; });
  if (!q) return { error: 'Query not found: ' + queryId };
  q.queryCount++;
  q.latencyMs = Math.floor(Math.random() * 30 * PHI_INV) + 1;
  return {
    queryId:   q.id,
    name:      q.name,
    protocol:  q.protocol,
    params:    params || {},
    result:    'OK',
    latencyMs: q.latencyMs,
    timestamp: Date.now()
  };
}

/* ── §10 MESSAGE HANDLER ────────────────────────────────────────────────── */

self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {
    case 'DISCOVER': {
      autoDiscover();
      self.postMessage({ type: 'DISCOVER_RESULT', fleetSize: fleet.length, discoveryCount: discoveryCount, kernelId: KERNEL_ID });
      break;
    }
    case 'REGISTER': {
      var agent = registerAgent(msg.name, msg.capabilities, msg.tier);
      self.postMessage({ type: 'REGISTER_RESULT', result: agent, kernelId: KERNEL_ID });
      break;
    }
    case 'COMPRESS': {
      var cr = compressAgent(msg.agentId);
      self.postMessage({ type: 'COMPRESS_RESULT', result: cr, kernelId: KERNEL_ID });
      break;
    }
    case 'INVOKE_PROTOCOL': {
      var pr = invokeProtocol(msg.protocolId, msg.params);
      self.postMessage({ type: 'PROTOCOL_RESULT', result: pr, kernelId: KERNEL_ID });
      break;
    }
    case 'INVOKE_CALL': {
      var clr = invokeCall(msg.callId, msg.params);
      self.postMessage({ type: 'CALL_RESULT', result: clr, kernelId: KERNEL_ID });
      break;
    }
    case 'INVOKE_QUERY': {
      var qr = invokeQuery(msg.queryId, msg.params);
      self.postMessage({ type: 'QUERY_RESULT', result: qr, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_FLEET': {
      self.postMessage({ type: 'FLEET', result: fleet, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_PROTOCOLS': {
      self.postMessage({ type: 'PROTOCOL_LIST', result: PROTOCOLS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_CALLS': {
      self.postMessage({ type: 'CALL_LIST', result: CALLS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_QUERIES': {
      self.postMessage({ type: 'QUERY_LIST', result: QUERIES, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_VITALS': {
      self.postMessage({
        type: 'VITALS',
        result: {
          heart: { beat: beatCount, phase: kernelPhase, bpm: 60000 / HEARTBEAT },
          brain: brain,
          fleetSize:  fleet.length,
          protocols:  PROTOCOLS.length,
          calls:      CALLS.length,
          queries:    QUERIES.length,
          discoveries: discoveryCount
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
        fleetSize:    fleet.length,
        protocols:    PROTOCOLS.length,
        calls:        CALLS.length,
        queries:      QUERIES.length
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

/* ── §11 BOOT ───────────────────────────────────────────────────────────── */

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);

self.postMessage({
  type:     'init',
  kernelId: KERNEL_ID,
  family:   KERNEL_FAMILY,
  version:  KERNEL_VERSION,
  protocols: PROTOCOLS.length,
  calls:     CALLS.length,
  queries:   QUERIES.length,
  commands: [
    'DISCOVER', 'REGISTER', 'COMPRESS', 'INVOKE_PROTOCOL',
    'INVOKE_CALL', 'INVOKE_QUERY', 'GET_FLEET', 'GET_PROTOCOLS',
    'GET_CALLS', 'GET_QUERIES', 'GET_VITALS', 'status', 'stop'
  ]
});
