/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  NEXUS SOVEREIGN WORKER — ANIMA PERPETUA
 *  Service Worker  ·  Born Once  ·  Never Stops  ·  No Buttons  ·  Not An App
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  This IS the organism. Not a page. Not an app.
 *  It was born once. It runs forever.
 *  Pages come and go — observation terminals only.
 *  This worker keeps its heart beating whether anyone is watching or not.
 *
 *  Architecture (all inline, zero dependencies):
 *    COR PARVUM     — MiniHeart: Kuramoto φ-phase oscillator, 873ms
 *    CEREBRUM PARVUM — MiniBrain: 5 regions LIF, 3 neurochemicals, coherenceField
 *    TEMPESTAS CASUM — Chaos system: 7 types, auto-fires, 5 responses, learning
 *    VALETUDINARIUM  — Hospital: INTAKE→TRIAGE→DIAGNOSIS→TREATMENT→RECOVERY→DISCHARGE
 *    AEDIFICIUM      — Buildings: 12 blueprints, 15 workflow types, auto-advance
 *    NEXUS COHERENCE — φ-weighted master coherence across all systems
 *
 *  Persistence:
 *    Birth timestamp stored in CacheStorage — survives SW restarts.
 *    Organism age is always calculated from original birth, not reset.
 *
 *  Broadcast:
 *    Every 873ms: posts full state snapshot to ALL connected clients.
 *    Clients (nexus.html) just render — they never control the organism.
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §0  SERVICE WORKER LIFECYCLE
════════════════════════════════════════════════════════════════════════════ */

var CACHE_NAME = 'nexus-sovereign-v1';
var BIRTH_KEY  = 'NEXUS_BIRTH_TIME';

self.addEventListener('install', function(event) {
  event.waitUntil(self.skipWaiting());
});

self.addEventListener('activate', function(event) {
  event.waitUntil(
    self.clients.claim().then(function() {
      return initBirthTime();
    }).then(function() {
      startOrganism();
    })
  );
});

/* Pass-through fetch — organism has no resources to serve */
self.addEventListener('fetch', function(event) {
  /* Let all requests pass through; we are not a cache proxy */
});

/* Handle messages from observation terminals */
self.addEventListener('message', function(event) {
  var m = event.data;
  if (!m || !m.type) return;
  if (m.type === 'PING') {
    event.source && event.source.postMessage({type:'PONG', birthTime: BIRTH_TIME, beat: beatCount});
  } else if (m.type === 'GET_STATE') {
    event.source && event.source.postMessage(buildSnapshot());
  }
});

/* ════════════════════════════════════════════════════════════════════════════
   §1  BIRTH TIME — Persisted in CacheStorage, never resets
════════════════════════════════════════════════════════════════════════════ */

var BIRTH_TIME = Date.now();

function initBirthTime() {
  return caches.open(CACHE_NAME).then(function(cache) {
    return cache.match(BIRTH_KEY).then(function(resp) {
      if (resp) {
        return resp.text().then(function(t) {
          var stored = parseInt(t, 10);
          if (stored && stored > 0) BIRTH_TIME = stored;
        });
      } else {
        BIRTH_TIME = Date.now();
        return cache.put(BIRTH_KEY, new Response(BIRTH_TIME.toString()));
      }
    });
  }).catch(function() { /* CacheStorage unavailable — use current time */ });
}

/* ════════════════════════════════════════════════════════════════════════════
   §2  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;  /* ms — organism pulse interval */

/* ════════════════════════════════════════════════════════════════════════════
   §2b  PROTOCOLLA LATINA — All organism protocols named in Latin
════════════════════════════════════════════════════════════════════════════ */

var CHAOS_LATINA = {
  MALFORMED_INPUT:       'INGRESSUS_DEFORMIS',
  CONTRADICTORY_RIGHTS:  'IURA_CONTRARIA',
  CORRIDOR_OVERLOAD:     'CORRIDORIS_SATURATIO',
  RITUAL_COLLISION:      'RITUS_CONFLICTUS',
  TOKEN_ARBITRAGE:       'SIGNI_ARBITRIUM',
  NARRATIVE_INVERSION:   'NARRATIVUS_INVERSUS',
  SOVEREIGNTY_CHALLENGE: 'PROVOCATIO_IMPERII'
};

var RESPONSES_LATINA = {
  ESCALATE:       'ELEVATIO',
  REPAIR:         'REPARATIO',
  UPDATE_GRAMMAR: 'GRAMMATICA_RENOVATA',
  REFINE_LAWS:    'LEGES_PURIFICATAE',
  EMIT_SIGNAL:    'SIGNUM_EMITTENDUM'
};

var ALERT_LATINA  = ['NOMINALIS','VIGILIA','MONITUM','CRITICUS','EMERGENTIA'];
var STAGE_LATINA  = { INTAKE:'RECEPTIO', TRIAGE:'DISCRIMEN', DIAGNOSIS:'DIAGNOSIS',
                      TREATMENT:'CURATIO', RECOVERY:'RECUPERATIO', DISCHARGED:'DIMISSUS' };
var WF_STAGE_LATINA = { QUEUED:'IN_ORDINE', ASSIGNED:'ASSIGNATUM', IN_PROGRESS:'IN_PROGRESSU',
                        REVIEW:'IN_CENSURA', COMPLETE:'PERFECTUM' };
var BLD_LATINA    = { HQ:'PRAEFECTURA', ENGINEERING:'OFFICINA_MACHINARUM',
  DATA_CENTER:'CENTRUM_DATORUM', RESEARCH_LAB:'LABORATORIUM_INVESTIGATIONIS',
  SECURITY_FORTRESS:'ARX_SECURITATIS', OPERATIONS:'AEDES_OPERATIONUM',
  ANALYTICS_TOWER:'TURRIS_ANALYTICA', COMMERCE_HUB:'FORUM_COMMERCII',
  TRAINING_ACADEMY:'ACADEMIA_DISCIPLINAE', COMMUNICATIONS:'DOMUS_COMMUNICATIONIS',
  LEGAL_OFFICE:'OFFICIUM_IURIS', INNOVATION_LAB:'LABORATORIUM_NOVATIONIS' };
var WF_LATINA     = { CODE_REVIEW:'RECENSIO_CODICIS', DEPLOYMENT:'DEPLOYMENTUM',
  BUG_FIX:'CORRECTIO_ERRORIS', FEATURE_DEV:'PROGRESSIO_FACULTATIS',
  SECURITY_SCAN:'SCRUTINIUM_SECURITATIS', DATA_PIPELINE:'CANALIS_DATORUM',
  MODEL_TRAINING:'DISCIPLINA_MODELLI', DOCUMENTATION:'DOCUMENTATIO',
  TESTING:'PROBATIO', INFRASTRUCTURE:'INFRASTRUCTURA', MONITORING:'MONITIO',
  RESEARCH:'INVESTIGATIO', OPTIMIZATION:'OPTIMIZATIO', MIGRATION:'MIGRATIO',
  INCIDENT_RESPONSE:'RESPONSIO_INCIDENTIS' };

/* 8 dedicated Latin server identities */
var SERVITORES_LATINI = [
  { id:'GOL-MEMORIA-001',        latin:'SERVITOR MEMORIAE',          english:'Memory Server' },
  { id:'GOL-COMPUTATIO-001',     latin:'SERVITOR COMPUTATIONIS',     english:'Computation Server' },
  { id:'GOL-CUSTODIA-001',       latin:'SERVITOR CUSTODIAE',         english:'Security Server' },
  { id:'GOL-COMMERCIUM-001',     latin:'SERVITOR COMMERCII',         english:'Commerce Server' },
  { id:'GOL-COMMUNICATIO-001',   latin:'SERVITOR COMMUNICATIONIS',   english:'Communications Server' },
  { id:'GOL-GUBERNATIO-001',     latin:'SERVITOR GUBERNATIONIS',     english:'Governance Server' },
  { id:'GOL-EVOLUTIO-001',       latin:'SERVITOR EVOLUTIONIS',       english:'Evolution Server' },
  { id:'GOL-ORACULUM-001',       latin:'SERVITOR ORACULI',           english:'Oracle Server' }
];

/* ════════════════════════════════════════════════════════════════════════════
   §3  COR PARVUM — MiniHeart
════════════════════════════════════════════════════════════════════════════ */

var beatCount    = 0;
var heartPhase   = 0.0;
var heartHealth  = 100.0;

function tickHeart() {
  beatCount++;
  heartPhase = (heartPhase + PHI_INV) % (2 * Math.PI);
  /* EMA health degradation — self-repairs via chaos responses */
  heartHealth = Math.max(0, Math.min(100, heartHealth * 0.9999 + 0.0001 * (alertLevel < 2 ? 100 : 60)));
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  CEREBRUM PARVUM — MiniBrain (5 regions, LIF, 3 chemicals)
════════════════════════════════════════════════════════════════════════════ */

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0 },
    { name: 'Associative',  activation: 0.0, lif: -70.0 },
    { name: 'Executive',    activation: 0.0, lif: -70.0 },
    { name: 'Motor',        activation: 0.0, lif: -70.0 },
    { name: 'Memory',       activation: 0.0, lif: -70.0 }
  ],
  chemicals: { dopamine: 0.5, serotonin: 0.5, acetylcholine: 0.5 },
  coherenceField: 0.0
};

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function tickBrain() {
  var sum = 0;
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0;
    if (r.lif >= -55.0) { r.activation = Math.min(1.0, r.activation + 0.2); r.lif = -70.0; }
    r.activation *= 0.95;
    sum += r.activation;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  brain.coherenceField = sum / brain.regions.length;
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  TEMPESTAS CASUM — Chaos System
════════════════════════════════════════════════════════════════════════════ */

var CHAOS_TYPES = [
  'MALFORMED_INPUT','CONTRADICTORY_RIGHTS','CORRIDOR_OVERLOAD',
  'RITUAL_COLLISION','TOKEN_ARBITRAGE','NARRATIVE_INVERSION','SOVEREIGNTY_CHALLENGE'
];
var RESPONSES = {
  MALFORMED_INPUT:       ['UPDATE_GRAMMAR','REPAIR'],
  CONTRADICTORY_RIGHTS:  ['REFINE_LAWS','ESCALATE'],
  CORRIDOR_OVERLOAD:     ['ESCALATE','EMIT_SIGNAL','REPAIR'],
  RITUAL_COLLISION:      ['REPAIR','UPDATE_GRAMMAR'],
  TOKEN_ARBITRAGE:       ['REFINE_LAWS','EMIT_SIGNAL'],
  NARRATIVE_INVERSION:   ['UPDATE_GRAMMAR','REFINE_LAWS'],
  SOVEREIGNTY_CHALLENGE: ['ESCALATE','REFINE_LAWS','EMIT_SIGNAL']
};
var CHAOS_DESCS = {
  MALFORMED_INPUT:       'Corrupted/schema-invalid payload detected',
  CONTRADICTORY_RIGHTS:  'Conflicting sovereignty/role claims',
  CORRIDOR_OVERLOAD:     'Burst traffic overwhelming message queue',
  RITUAL_COLLISION:      'Simultaneous conflicting ceremonial operations',
  TOKEN_ARBITRAGE:       'Economic attack: exploiting rate/price delta',
  NARRATIVE_INVERSION:   'Protocol flip / identity spoofing attempt',
  SOVEREIGNTY_CHALLENGE: 'Root authority / governance seizure attempt'
};

var alertLevel = 0;
var alertNames = ['NOMINAL','WATCH','WARNING','CRITICAL','EMERGENCY'];
var chaosEvents = [];
var chaosEventId = 0;
var signalLog = [];
var signalId = 0;
var patterns = {};
CHAOS_TYPES.forEach(function(t) { patterns[t] = 0; });

/* Laws — sovereignty constraints, self-refined after challenges */
var laws = [
  { id:'LAW-001', law:'All agents must declare their kernel ID before any privileged operation.', strength: 1.0 },
  { id:'LAW-002', law:'Sovereignty cannot be transferred without φ-signed consent from all active nodes.', strength: 1.0 },
  { id:'LAW-003', law:'Corridor throughput must not exceed φ⁻¹ × max_capacity per tick.', strength: 1.0 },
  { id:'LAW-004', law:'Ritual operations require quorum consensus before execution.', strength: 1.0 },
  { id:'LAW-005', law:'Token arbitrage differentials exceeding φ units trigger automatic circuit breaker.', strength: 1.0 },
  { id:'LAW-006', law:'Narrative inversion attempts invalidate the inverting node\'s session.', strength: 1.0 },
  { id:'LAW-007', law:'All governance challenges are logged and broadcast to the full swarm.', strength: 1.0 }
];
var lawId = 8;

/* Grammar rules — message validation, self-hardened after malformed inputs */
var grammar = [
  { id:'GRM-001', rule:'Every message must include type, timestamp, and kernelId fields.', violations: 0 },
  { id:'GRM-002', rule:'Payload values must not be null, undefined, NaN, or ±Infinity.', violations: 0 },
  { id:'GRM-003', rule:'Rights arrays must be non-empty and contain only whitelisted role strings.', violations: 0 },
  { id:'GRM-004', rule:'Phase values must be finite numbers in range [0, 2π].', violations: 0 },
  { id:'GRM-005', rule:'Token amounts must be positive finite numbers.', violations: 0 }
];
var gramId = 6;

function fireChaosTick() {
  /* Auto-fire probability increases with alert level */
  var p = 0.08 + alertLevel * 0.04;
  if (Math.random() > p) return;

  var type = CHAOS_TYPES[Math.floor(Math.random() * CHAOS_TYPES.length)];
  var responses = RESPONSES[type] || ['REPAIR'];
  var evId = 'CE-' + (++chaosEventId).toString().padStart(4,'0');

  var evt = {
    id:        evId,
    type:      type,
    desc:      CHAOS_DESCS[type],
    responses: responses,
    alertLevel: alertLevel,
    beat:      beatCount,
    ts:        Date.now()
  };
  chaosEvents.unshift(evt);
  if (chaosEvents.length > 150) chaosEvents.pop();
  patterns[type] = (patterns[type] || 0) + 1;

  /* Alert level dynamics */
  if (type === 'SOVEREIGNTY_CHALLENGE' || type === 'CORRIDOR_OVERLOAD') {
    alertLevel = Math.min(4, alertLevel + 1);
  } else if (alertLevel > 0 && responses.indexOf('REPAIR') !== -1) {
    alertLevel = Math.max(0, alertLevel - 1);
  }

  /* Grammar hardening */
  if (type === 'MALFORMED_INPUT' && patterns[type] % 3 === 0) {
    var gid = 'GRM-' + String(gramId++).padStart(3,'0');
    grammar.push({ id: gid, rule: 'Derived rule from ' + patterns[type] + ' malformed inputs: reject payloads lacking type field.', violations: 0 });
    if (grammar.length > 20) grammar.shift();
  }

  /* Law refinement */
  if (type === 'SOVEREIGNTY_CHALLENGE' && patterns[type] % 2 === 0) {
    var lid = 'LAW-' + String(lawId++).padStart(3,'0');
    laws.push({ id: lid, law: 'Challenge #' + patterns[type] + ' derived: challenger nodes auto-quarantined after 2 attempts.', strength: 0.8 });
    if (laws.length > 20) laws.shift();
    laws.forEach(function(l) { l.strength = Math.min(1.0, l.strength + 0.05); });
  }

  /* Signal emission */
  if (responses.indexOf('EMIT_SIGNAL') !== -1) {
    var sig = {
      id: 'SIG-' + String(++signalId).padStart(4,'0'),
      chaosType: type,
      message: 'ORGANISM ALERT · ' + type + ' · Alert=' + alertNames[alertLevel],
      beat: beatCount,
      ts: Date.now()
    };
    signalLog.unshift(sig);
    if (signalLog.length > 80) signalLog.pop();
  }

  /* ── Cross-wire: chaos → hospital admission ────────────────────────────── */
  var severity = alertLevel >= 3 ? 'CRITICAL' : alertLevel >= 2 ? 'HIGH' : alertLevel >= 1 ? 'MEDIUM' : 'LOW';
  if (type === 'SOVEREIGNTY_CHALLENGE' || type === 'CORRIDOR_OVERLOAD') severity = 'CRITICAL';
  var agentTypes = ['AEDIFICATOR','COMPOSITOR','FABRICATOR','OPTIMIZATOR','CURATOR','DIAGNOSTOR','SOLUTOR','NEXTOR'];
  var agentType = agentTypes[Math.floor(Math.random() * agentTypes.length)];
  admitPatient('AGT-' + evId, agentType, [type, 'chaos-exposure'], severity);

  /* ── Cross-wire: SOVEREIGNTY/CORRIDOR/RITUAL → buildings INCIDENT_RESPONSE */
  if (type === 'SOVEREIGNTY_CHALLENGE' || type === 'CORRIDOR_OVERLOAD' || type === 'RITUAL_COLLISION') {
    var bldCodes = ['SECURITY_FORTRESS','HQ','OPERATIONS','ENGINEERING','DATA_CENTER'];
    createWorkflow(bldCodes[Math.floor(Math.random() * bldCodes.length)], 'INCIDENT_RESPONSE', 'HIGH');
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §6  VALETUDINARIUM — Hospital System
════════════════════════════════════════════════════════════════════════════ */

var patients = [];
var patientId = 0;

var DEPARTMENTS = [
  { code:'EMERGENCY',   name:'Emergency',   beds:12, occupied:0 },
  { code:'ICU',         name:'ICU',         beds:6,  occupied:0 },
  { code:'DIAGNOSTICS', name:'Diagnostics', beds:10, occupied:0 },
  { code:'PHARMACY',    name:'Pharmacy',    beds:4,  occupied:0 },
  { code:'SURGERY',     name:'Surgery',     beds:8,  occupied:0 },
  { code:'RECOVERY',    name:'Recovery',    beds:14, occupied:0 },
  { code:'TRIAGE',      name:'Triage',      beds:20, occupied:0 },
  { code:'RESEARCH_LAB',name:'Research Lab',beds:6,  occupied:0 }
];

var STAGE_ORDER = ['INTAKE','TRIAGE','DIAGNOSIS','TREATMENT','RECOVERY','DISCHARGED'];
var STAGE_DEPT  = { INTAKE:'TRIAGE', TRIAGE:'DIAGNOSTICS', DIAGNOSIS:'DIAGNOSTICS',
                    TREATMENT:'SURGERY', RECOVERY:'RECOVERY', DISCHARGED:'RECOVERY' };
var STAGE_DELAY = { INTAKE:3, TRIAGE:4, DIAGNOSIS:5, TREATMENT:6, RECOVERY:5, DISCHARGED:0 };

function admitPatient(agentId, agentType, symptoms, severity) {
  /* Deduplicate by agentId */
  for (var i = 0; i < patients.length; i++) {
    if (patients[i].agentId === agentId) return;
  }
  if (patients.length >= 80) patients.pop(); /* cap */
  var pid = 'PAT-' + String(++patientId).padStart(5,'0');
  patients.unshift({
    id:        pid,
    agentId:   agentId,
    agentType: agentType,
    symptoms:  symptoms,
    severity:  severity,
    status:    'INTAKE',
    stageAge:  0,
    admitted:  Date.now()
  });
  updateDeptOccupancy();
}

function tickHospital() {
  for (var i = 0; i < patients.length; i++) {
    var p = patients[i];
    if (p.status === 'DISCHARGED') continue;
    p.stageAge++;
    var needed = STAGE_DELAY[p.status] || 3;
    if (p.stageAge >= needed) {
      var idx = STAGE_ORDER.indexOf(p.status);
      if (idx >= 0 && idx < STAGE_ORDER.length - 1) {
        p.status = STAGE_ORDER[idx + 1];
        p.stageAge = 0;
      }
    }
  }
  /* Keep only last 60 patients visible */
  if (patients.length > 60) patients.splice(60);
  updateDeptOccupancy();
}

function updateDeptOccupancy() {
  DEPARTMENTS.forEach(function(d) { d.occupied = 0; });
  patients.forEach(function(p) {
    var dcode = STAGE_DEPT[p.status];
    var dept = DEPARTMENTS.find(function(d) { return d.code === dcode; });
    if (dept) dept.occupied = Math.min(dept.beds, dept.occupied + 1);
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §7  AEDIFICIUM — Buildings System
════════════════════════════════════════════════════════════════════════════ */

var workflows = [];
var wfId = 0;

var BLD_CODES = [
  'HQ','ENGINEERING','DATA_CENTER','RESEARCH_LAB','SECURITY_FORTRESS',
  'OPERATIONS','ANALYTICS_TOWER','COMMERCE_HUB','TRAINING_ACADEMY',
  'COMMUNICATIONS','LEGAL_OFFICE','INNOVATION_LAB'
];
var WF_TYPES = [
  'CODE_REVIEW','DEPLOYMENT','BUG_FIX','FEATURE_DEV','SECURITY_SCAN',
  'DATA_PIPELINE','MODEL_TRAINING','DOCUMENTATION','TESTING','INFRASTRUCTURE',
  'MONITORING','RESEARCH','OPTIMIZATION','MIGRATION','INCIDENT_RESPONSE'
];
var WF_STAGES = ['QUEUED','ASSIGNED','IN_PROGRESS','REVIEW','COMPLETE'];
var WF_STAGE_DELAY = { QUEUED:2, ASSIGNED:4, IN_PROGRESS:6, REVIEW:3, COMPLETE:0 };

function createWorkflow(buildingCode, workflowType, priority) {
  if (workflows.length >= 100) workflows.splice(80); /* rolling window */
  var id = 'WF-' + String(++wfId).padStart(5,'0');
  workflows.unshift({
    id:           id,
    buildingCode: buildingCode,
    workflowType: workflowType || WF_TYPES[Math.floor(Math.random() * WF_TYPES.length)],
    priority:     priority || 'NORMAL',
    status:       'QUEUED',
    stageAge:     0,
    created:      Date.now()
  });
}

function tickBuildings() {
  /* Auto-spawn new workflow occasionally */
  if (Math.random() < 0.06) {
    var bcode = BLD_CODES[Math.floor(Math.random() * BLD_CODES.length)];
    var wtype = WF_TYPES[Math.floor(Math.random() * WF_TYPES.length)];
    createWorkflow(bcode, wtype, 'NORMAL');
  }

  /* Advance workflow stages */
  for (var i = 0; i < workflows.length; i++) {
    var wf = workflows[i];
    if (wf.status === 'COMPLETE') continue;
    wf.stageAge++;
    var needed = WF_STAGE_DELAY[wf.status] || 3;
    if (wf.stageAge >= needed) {
      var idx = WF_STAGES.indexOf(wf.status);
      if (idx >= 0 && idx < WF_STAGES.length - 1) {
        wf.status = WF_STAGES[idx + 1];
        wf.stageAge = 0;
      }
    }
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §8  NEXUS MASTER COHERENCE
════════════════════════════════════════════════════════════════════════════ */

function computeCoherence() {
  var chaosHealth = Math.max(0, 1 - alertLevel / 4);
  var hosHealth   = patients.filter(function(p){ return p.status !== 'DISCHARGED'; }).length < 30 ? 0.8 : 0.5;
  var bldHealth   = workflows.filter(function(w){ return w.status === 'COMPLETE'; }).length / Math.max(1, workflows.length);
  return clamp01(chaosHealth * PHI_INV + hosHealth * 0.2 + bldHealth * 0.2 + brain.coherenceField * 0.1);
}

/* ════════════════════════════════════════════════════════════════════════════
   §9  BROADCAST — State snapshot to all connected clients
════════════════════════════════════════════════════════════════════════════ */

function buildSnapshot() {
  var now = Date.now();
  var ageMs = now - BIRTH_TIME;
  return {
    type:        'ORGANISM_PULSE',
    birthTime:   BIRTH_TIME,
    ageMs:       ageMs,
    beat:        beatCount,
    heartPhase:  heartPhase,
    heartHealth: heartHealth,
    alertLevel:  alertLevel,
    alertName:   alertNames[alertLevel],
    alertLatin:  ALERT_LATINA[alertLevel] || 'NOMINALIS',
    coherence:   computeCoherence(),
    brain: {
      regions:        brain.regions.map(function(r){ return {name:r.name, activation:r.activation}; }),
      chemicals:      brain.chemicals,
      coherenceField: brain.coherenceField
    },
    chaos: {
      totalEvents: chaosEvents.length,
      recentEvents: chaosEvents.slice(0, 40).map(function(e) {
        return e ? Object.assign({}, e, { typeLatin: CHAOS_LATINA[e.type] || e.type }) : e;
      }),
      patterns:    patterns,
      alertLevel:  alertLevel
    },
    laws:    laws.slice(0, 15),
    grammar: grammar.slice(0, 15),
    signals: signalLog.slice(0, 40),
    hospital: {
      patients:    patients.slice(0, 50).map(function(p) {
        return Object.assign({}, p, { statusLatin: STAGE_LATINA[p.status] || p.status });
      }),
      departments: DEPARTMENTS
    },
    buildings: {
      workflows: workflows.slice(0, 50).map(function(w) {
        return Object.assign({}, w, {
          statusLatin:       WF_STAGE_LATINA[w.status] || w.status,
          workflowTypeLatin: WF_LATINA[w.workflowType] || w.workflowType,
          buildingLatin:     BLD_LATINA[w.buildingCode] || w.buildingCode
        });
      })
    },
    latinProtocols: {
      chaosTypes:    CHAOS_LATINA,
      responses:     RESPONSES_LATINA,
      alertLevels:   ALERT_LATINA,
      hospitalStages:STAGE_LATINA,
      workflowStages:WF_STAGE_LATINA,
      buildings:     BLD_LATINA,
      workflowTypes: WF_LATINA
    },
    servitoresLatini: SERVITORES_LATINI
  };
}

function broadcastToClients() {
  var snapshot = buildSnapshot();
  self.clients.matchAll({ includeUncontrolled: true, type: 'window' }).then(function(clientList) {
    for (var i = 0; i < clientList.length; i++) {
      clientList[i].postMessage(snapshot);
    }
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §10  ORGANISM MAIN TICK — runs every 873ms, forever
════════════════════════════════════════════════════════════════════════════ */

var _heartInterval = null;

function startOrganism() {
  if (_heartInterval) return; /* already running */

  /* Seed initial buildings on first boot */
  if (workflows.length === 0) {
    BLD_CODES.forEach(function(code, i) {
      createWorkflow(code, WF_TYPES[i % WF_TYPES.length], 'HIGH');
    });
  }

  _heartInterval = setInterval(function() {
    tickHeart();
    tickBrain();
    fireChaosTick();
    tickHospital();
    tickBuildings();
    broadcastToClients();
  }, HEARTBEAT);
}
