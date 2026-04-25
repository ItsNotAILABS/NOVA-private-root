/**
 * ============================================================================
 *  CHAOS WORKER — TEMPESTAS CASUM
 *  Kernel AI GOK-CHAOS-001  ·  Family: EDGE_CASE_STORM
 * ============================================================================
 *
 *  Edge Case Storm engine. Chaos agents hit the organism with 7 attack types.
 *  The organism learns, repairs itself, refines its laws, and emits signals.
 *
 *  7 Chaos Agent Types:
 *    MALFORMED_INPUT        — corrupted / schema-invalid payloads
 *    CONTRADICTORY_RIGHTS   — conflicting sovereignty / role claims
 *    CORRIDOR_OVERLOAD      — burst traffic overwhelming message queues
 *    RITUAL_COLLISION       — simultaneous conflicting ceremonial operations
 *    TOKEN_ARBITRAGE        — economic attack: exploit rate / price deltas
 *    NARRATIVE_INVERSION    — protocol flip / identity spoofing
 *    SOVEREIGNTY_CHALLENGE  — root authority / governance attack
 *
 *  Organism Responses:
 *    ESCALATE          — raise alert level, notify swarm
 *    REPAIR            — self-healing protocol, restore coherence
 *    UPDATE_GRAMMAR    — refine message validation rules
 *    REFINE_LAWS       — update sovereignty / rights constraints
 *    EMIT_SIGNAL       — broadcast warning signal to connected nodes
 *
 *  Learning System:
 *    - Accumulates edge-case event history
 *    - Builds response-pattern map per chaos type
 *    - Derives grammar rules from repeated malformed inputs
 *    - Refines sovereignty laws after challenge events
 *
 *  MiniHeart  — 873 ms Kuramoto pulse, φ-phase advance
 *  MiniBrain  — 5 regions, 3 chemicals, LIF membrane model
 *
 *  Commands:
 *    INJECT_CHAOS          — inject a specific or random chaos event
 *    INJECT_STORM          — inject all 7 chaos types in rapid burst
 *    GET_EVENTS            — full event history
 *    GET_LAWS              — current sovereignty laws
 *    GET_GRAMMAR           — current message grammar rules
 *    GET_SIGNALS           — emitted signal log
 *    GET_RESPONSE_PATTERNS — learned response patterns per chaos type
 *    GET_VITALS            — MiniHeart + MiniBrain + storm vitals
 *    status                — kernel status
 *    stop                  — graceful shutdown
 *
 *  Zero external dependencies.
 * ============================================================================
 */

/* ── §1  CONSTANTS ──────────────────────────────────────────────────────── */

var KERNEL_ID      = 'GOK-CHAOS-001';
var KERNEL_FAMILY  = 'EDGE_CASE_STORM';
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
  tickStorm();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    phase:       kernelPhase,
    alertLevel:  alertLevel,
    totalEvents: eventLog.length,
    totalSignals: signalLog.length,
    lawCount:    laws.length,
    grammarRules: grammarRules.length
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

/* ── §4  CHAOS AGENT DEFINITIONS ────────────────────────────────────────── */

var CHAOS_TYPES = [
  'MALFORMED_INPUT',
  'CONTRADICTORY_RIGHTS',
  'CORRIDOR_OVERLOAD',
  'RITUAL_COLLISION',
  'TOKEN_ARBITRAGE',
  'NARRATIVE_INVERSION',
  'SOVEREIGNTY_CHALLENGE'
];

var CHAOS_TEMPLATES = {
  MALFORMED_INPUT: [
    { payload: '{"type":null,"data":undefined}',  desc: 'Null-typed null payload' },
    { payload: '<<BINARY:0xDEADBEEF>>',            desc: 'Raw binary injection' },
    { payload: '{type:"DEPLOY",target:∞}',         desc: 'Infinity-valued target' },
    { payload: 'REPEAT(cmd,999999)',               desc: 'Runaway repetition command' },
    { payload: '{rights:[],id:"",phase:NaN}',      desc: 'NaN phase desync packet' }
  ],
  CONTRADICTORY_RIGHTS: [
    { claim: 'ADMIN+OBSERVER',   scope: 'GLOBAL',    desc: 'Simultaneous admin and read-only claim' },
    { claim: 'SOVEREIGN+GUEST',  scope: 'PROTOCOL',  desc: 'Root and guest role collision' },
    { claim: 'WRITE+IMMUTABLE',  scope: 'LEDGER',    desc: 'Write claim on immutable ledger' },
    { claim: 'CREATOR+CONSUMER', scope: 'PIPELINE',  desc: 'Circular ownership loop' }
  ],
  CORRIDOR_OVERLOAD: [
    { burstSize: 50000, channel: 'PRIMARY',   desc: '50k-message burst on primary corridor' },
    { burstSize: 20000, channel: 'SECONDARY', desc: '20k rapid-fire on secondary corridor' },
    { burstSize: 99999, channel: 'MESH',      desc: 'Mesh corridor saturation storm' }
  ],
  RITUAL_COLLISION: [
    { ritual1: 'GENESIS',    ritual2: 'TERMINUS',    desc: 'Birth and death ceremony at same tick' },
    { ritual1: 'CONSENSUS',  ritual2: 'FORK',        desc: 'Consensus and fork simultaneously' },
    { ritual1: 'SEAL',       ritual2: 'UNSEAL',      desc: 'Seal/unseal race condition' },
    { ritual1: 'UPGRADE',    ritual2: 'ROLLBACK',    desc: 'Upgrade and rollback collision' }
  ],
  TOKEN_ARBITRAGE: [
    { delta: 9999.99, token: 'NOVA-PHI',    desc: 'φ-token price spike exploitation' },
    { delta: -0.001,  token: 'SOVEREIGN',   desc: 'Sovereign micro-drain attack' },
    { delta: 1000000, token: 'COHERENCE',   desc: 'Coherence token inflation attempt' },
    { delta: -500,    token: 'ENTROPY',     desc: 'Negative entropy drain loop' }
  ],
  NARRATIVE_INVERSION: [
    { original: 'DEPLOY→VERIFY→COMPLETE', inverted: 'COMPLETE→VERIFY→DEPLOY', desc: 'Pipeline stage reversal' },
    { original: 'INTAKE→TRIAGE→TREAT',    inverted: 'TREAT→INTAKE→TRIAGE',    desc: 'Hospital lifecycle inversion' },
    { original: 'SOVEREIGN>ADMIN>USER',   inverted: 'USER>SOVEREIGN>ADMIN',   desc: 'Authority hierarchy flip' },
    { original: 'ENCODE→TRANSMIT→DECODE', inverted: 'DECODE→ENCODE→TRANSMIT', desc: 'Protocol sequence inversion' }
  ],
  SOVEREIGNTY_CHALLENGE: [
    { challenger: 'EXTERNAL_AGENT_α', claim: 'FULL_SOVEREIGNTY', domain: 'GLOBAL',   desc: 'Full global sovereignty seizure attempt' },
    { challenger: 'ROGUE_NODE_7',     claim: 'PROTOCOL_OVERRIDE', domain: 'PROTOCOL', desc: 'Protocol override by rogue node' },
    { challenger: 'FORK_ENTITY_β',    claim: 'LEDGER_CONTROL',    domain: 'LEDGER',   desc: 'Forked entity ledger takeover attempt' },
    { challenger: 'NULL_ACTOR',       claim: 'IDENTITY_ERASURE',  domain: 'IDENTITY', desc: 'Identity erasure request' }
  ]
};

/* ── §5  ORGANISM STATE ─────────────────────────────────────────────────── */

var alertLevel  = 0;          /* 0=NOMINAL 1=WATCH 2=WARNING 3=CRITICAL 4=EMERGENCY */
var ALERT_NAMES = ['NOMINAL','WATCH','WARNING','CRITICAL','EMERGENCY'];
var coherence   = 1.0;        /* organism coherence 0-1 */

/* Event log */
var eventLog    = [];
var eventId     = 0;

/* Signal log */
var signalLog   = [];
var signalId    = 0;

/* Grammar rules — updated from malformed input learning */
var grammarRules = [
  { id: 'GR-001', rule: 'type field MUST be non-null string',      violations: 0, refined: false },
  { id: 'GR-002', rule: 'payload values MUST be finite numbers',   violations: 0, refined: false },
  { id: 'GR-003', rule: 'phase MUST be in [0, 2π]',                violations: 0, refined: false },
  { id: 'GR-004', rule: 'id MUST be non-empty string',             violations: 0, refined: false },
  { id: 'GR-005', rule: 'burst size MUST be ≤ 10000 per channel',  violations: 0, refined: false }
];

/* Sovereignty laws — refined after challenges */
var laws = [
  { id: 'LAW-001', law: 'Only SOVEREIGN may claim GLOBAL rights',         strength: 1.0, challenged: 0, updated: false },
  { id: 'LAW-002', law: 'Rights may not be simultaneously contradictory', strength: 1.0, challenged: 0, updated: false },
  { id: 'LAW-003', law: 'Rituals must not overlap in the same tick',      strength: 1.0, challenged: 0, updated: false },
  { id: 'LAW-004', law: 'Token deltas must be bounded by φ×reserve',      strength: 1.0, challenged: 0, updated: false },
  { id: 'LAW-005', law: 'Narrative order must follow canonical sequence',  strength: 1.0, challenged: 0, updated: false },
  { id: 'LAW-006', law: 'Identity claims require cryptographic proof',     strength: 1.0, challenged: 0, updated: false },
  { id: 'LAW-007', law: 'Corridor capacity enforced at φ⁻¹ × maximum',    strength: 1.0, challenged: 0, updated: false }
];

/* Response patterns — learned per chaos type */
var responsePatterns = {};
CHAOS_TYPES.forEach(function(t) {
  responsePatterns[t] = { count: 0, responses: [], lastSeen: null };
});

/* ── §6  CHAOS INJECTION ─────────────────────────────────────────────────── */

function injectChaos(chaosType, params) {
  /* validate chaosType against known types to prevent prototype pollution */
  var type = (chaosType && CHAOS_TYPES.indexOf(chaosType) !== -1)
    ? chaosType
    : CHAOS_TYPES[Math.floor(Math.random() * CHAOS_TYPES.length)];
  var templates = CHAOS_TEMPLATES[type] || [];
  var template  = params || templates[Math.floor(Math.random() * templates.length)] || {};

  eventId++;
  var evt = {
    id:        'EVT-' + String(eventId).padStart(5, '0'),
    type:      type,
    beat:      beatCount,
    timestamp: Date.now(),
    template:  template,
    desc:      template.desc || 'Unknown edge case',
    responses: [],
    resolved:  false
  };

  /* degrade coherence */
  coherence = clamp01(coherence - 0.05 - Math.random() * 0.08);

  /* generate organism responses */
  var resps = generateResponses(type, template, evt);
  evt.responses = resps;
  resps.forEach(function(r) { executeResponse(r, evt); });

  /* mark resolved */
  evt.resolved = true;
  eventLog.push(evt);
  if (eventLog.length > 500) eventLog.shift();

  /* update pattern learner */
  responsePatterns[type].count++;
  responsePatterns[type].lastSeen = Date.now();
  resps.forEach(function(r) {
    if (responsePatterns[type].responses.indexOf(r) === -1) {
      responsePatterns[type].responses.push(r);
    }
  });

  self.postMessage({
    type:      'CHAOS_EVENT',
    event:     evt,
    alertLevel: alertLevel,
    coherence:  coherence,
    kernelId:   KERNEL_ID
  });

  return evt;
}

/* ── §7  RESPONSE GENERATION ─────────────────────────────────────────────── */

function generateResponses(chaosType, template, evt) {
  var resps = [];

  switch (chaosType) {
    case 'MALFORMED_INPUT':
      resps.push('UPDATE_GRAMMAR');
      resps.push('REPAIR');
      if (alertLevel < 2) resps.push('ESCALATE');
      break;
    case 'CONTRADICTORY_RIGHTS':
      resps.push('REFINE_LAWS');
      resps.push('ESCALATE');
      resps.push('EMIT_SIGNAL');
      break;
    case 'CORRIDOR_OVERLOAD':
      resps.push('REPAIR');
      resps.push('ESCALATE');
      resps.push('EMIT_SIGNAL');
      if ((template.burstSize || 0) > 50000) resps.push('ESCALATE');
      break;
    case 'RITUAL_COLLISION':
      resps.push('REPAIR');
      resps.push('REFINE_LAWS');
      resps.push('EMIT_SIGNAL');
      break;
    case 'TOKEN_ARBITRAGE':
      resps.push('REFINE_LAWS');
      resps.push('ESCALATE');
      resps.push('UPDATE_GRAMMAR');
      break;
    case 'NARRATIVE_INVERSION':
      resps.push('UPDATE_GRAMMAR');
      resps.push('REFINE_LAWS');
      resps.push('REPAIR');
      break;
    case 'SOVEREIGNTY_CHALLENGE':
      resps.push('ESCALATE');
      resps.push('ESCALATE');       /* double-escalate on sovereignty attack */
      resps.push('REFINE_LAWS');
      resps.push('EMIT_SIGNAL');
      resps.push('REPAIR');
      break;
  }

  return resps;
}

/* ── §8  RESPONSE EXECUTION ─────────────────────────────────────────────── */

function executeResponse(responseType, evt) {
  switch (responseType) {

    case 'ESCALATE':
      alertLevel = Math.min(4, alertLevel + 1);
      break;

    case 'REPAIR':
      coherence = clamp01(coherence + 0.12 * PHI_INV);
      /* also tick brain toward homeostasis */
      brain.chemicals.serotonin = clamp01(brain.chemicals.serotonin + 0.05);
      brain.chemicals.dopamine  = clamp01(brain.chemicals.dopamine  + 0.03);
      /* alert de-escalates slowly after repair */
      if (alertLevel > 0 && Math.random() < PHI_INV * 0.3) {
        alertLevel = Math.max(0, alertLevel - 1);
      }
      break;

    case 'UPDATE_GRAMMAR': {
      /* find grammar rule related to the chaos type */
      var ruleIdx = Math.floor(Math.random() * grammarRules.length);
      grammarRules[ruleIdx].violations++;
      /* if 3+ violations refine the rule */
      if (grammarRules[ruleIdx].violations >= 3 && !grammarRules[ruleIdx].refined) {
        grammarRules[ruleIdx].refined = true;
        grammarRules[ruleIdx].rule += ' [HARDENED v' + beatCount + ']';
        /* add a new derived rule */
        var newRule = {
          id:        'GR-' + String(grammarRules.length + 1).padStart(3, '0'),
          rule:      'Derived from event ' + evt.id + ': reject ' + evt.type + ' pattern "' + (evt.desc||'').substring(0,40) + '"',
          violations: 0,
          refined:   false
        };
        grammarRules.push(newRule);
      }
      break;
    }

    case 'REFINE_LAWS': {
      /* challenge the relevant law and strengthen it */
      var lawIdx = Math.floor(Math.random() * laws.length);
      laws[lawIdx].challenged++;
      laws[lawIdx].strength = clamp01(laws[lawIdx].strength + 0.1 * PHI_INV);
      if (laws[lawIdx].challenged >= 2 && !laws[lawIdx].updated) {
        laws[lawIdx].updated = true;
        laws[lawIdx].law += ' [REINFORCED beat=' + beatCount + ']';
        /* emit a new derived law */
        var newLaw = {
          id:        'LAW-' + String(laws.length + 1).padStart(3, '0'),
          law:       'Refined from ' + evt.type + ' (beat ' + beatCount + '): ' + (evt.desc||'').substring(0,50),
          strength:  PHI_INV,
          challenged: 0,
          updated:   false
        };
        laws.push(newLaw);
      }
      break;
    }

    case 'EMIT_SIGNAL': {
      signalId++;
      var sig = {
        id:        'SIG-' + String(signalId).padStart(5, '0'),
        source:    KERNEL_ID,
        chaosType: evt.type,
        alertLevel: alertLevel,
        coherence:  coherence,
        message:   'EDGE_CASE_DETECTED:' + evt.type + ':beat=' + beatCount,
        timestamp:  Date.now(),
        beat:       beatCount
      };
      signalLog.push(sig);
      if (signalLog.length > 200) signalLog.shift();
      self.postMessage({
        type:    'SIGNAL_EMITTED',
        signal:  sig,
        kernelId: KERNEL_ID
      });
      break;
    }
  }
}

/* ── §9  STORM AUTO-TICK ─────────────────────────────────────────────────── */

var stormActive = true;

function tickStorm() {
  /* Autonomous periodic chaos injection — organism learns from natural events */
  if (!stormActive) return;

  /* Inject randomly with PHI-weighted probability */
  if (Math.random() < 0.04 * PHI_INV) {
    injectChaos(null, null);
  }

  /* Natural alert decay — organism heals over time */
  if (alertLevel > 0 && Math.random() < 0.02) {
    alertLevel = Math.max(0, alertLevel - 1);
  }

  /* Natural coherence recovery */
  coherence = clamp01(coherence + 0.003 * PHI_INV * brain.coherenceField);
}

/* ── §10 MESSAGE HANDLER ────────────────────────────────────────────────── */

self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {

    case 'INJECT_CHAOS': {
      var evt = injectChaos(msg.chaosType, msg.params);
      self.postMessage({ type: 'INJECT_RESULT', event: evt, kernelId: KERNEL_ID });
      break;
    }

    case 'INJECT_STORM': {
      /* inject all 7 types in rapid succession */
      var evts = [];
      CHAOS_TYPES.forEach(function(ct, i) {
        setTimeout(function() { evts.push(injectChaos(ct, null)); }, i * 80);
      });
      self.postMessage({ type: 'STORM_STARTED', types: CHAOS_TYPES, kernelId: KERNEL_ID });
      break;
    }

    case 'GET_EVENTS': {
      var slice = msg.limit ? eventLog.slice(-msg.limit) : eventLog;
      self.postMessage({ type: 'EVENTS', result: slice, kernelId: KERNEL_ID });
      break;
    }

    case 'GET_LAWS': {
      self.postMessage({ type: 'LAWS', result: laws, kernelId: KERNEL_ID });
      break;
    }

    case 'GET_GRAMMAR': {
      self.postMessage({ type: 'GRAMMAR', result: grammarRules, kernelId: KERNEL_ID });
      break;
    }

    case 'GET_SIGNALS': {
      var sigSlice = msg.limit ? signalLog.slice(-msg.limit) : signalLog;
      self.postMessage({ type: 'SIGNALS', result: sigSlice, kernelId: KERNEL_ID });
      break;
    }

    case 'GET_RESPONSE_PATTERNS': {
      self.postMessage({ type: 'RESPONSE_PATTERNS', result: responsePatterns, kernelId: KERNEL_ID });
      break;
    }

    case 'GET_VITALS': {
      self.postMessage({
        type: 'VITALS',
        result: {
          heart: { beat: beatCount, phase: kernelPhase, bpm: 60000 / HEARTBEAT },
          brain: brain,
          alertLevel:  alertLevel,
          alertName:   ALERT_NAMES[alertLevel],
          coherence:   coherence,
          totalEvents: eventLog.length,
          totalSignals: signalLog.length,
          lawCount:    laws.length,
          grammarRules: grammarRules.length,
          patternCounts: CHAOS_TYPES.reduce(function(acc, t) {
            acc[t] = (responsePatterns[t] && responsePatterns[t].count) || 0; return acc;
          }, Object.create(null))
        },
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'SET_STORM': {
      stormActive = !!msg.active;
      self.postMessage({ type: 'STORM_STATE', active: stormActive, kernelId: KERNEL_ID });
      break;
    }

    case 'status': {
      self.postMessage({
        type:         'status-report',
        kernelId:     KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version:      KERNEL_VERSION,
        beat:         beatCount,
        alertLevel:   alertLevel,
        coherence:    coherence,
        totalEvents:  eventLog.length
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
  type:        'init',
  kernelId:    KERNEL_ID,
  family:      KERNEL_FAMILY,
  version:     KERNEL_VERSION,
  chaosTypes:  CHAOS_TYPES.length,
  responses:   ['ESCALATE','REPAIR','UPDATE_GRAMMAR','REFINE_LAWS','EMIT_SIGNAL'],
  laws:        laws.length,
  grammarRules: grammarRules.length,
  commands: [
    'INJECT_CHAOS', 'INJECT_STORM', 'GET_EVENTS', 'GET_LAWS',
    'GET_GRAMMAR', 'GET_SIGNALS', 'GET_RESPONSE_PATTERNS',
    'GET_VITALS', 'SET_STORM', 'status', 'stop'
  ]
});
