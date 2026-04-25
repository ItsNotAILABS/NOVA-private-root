/**
 * ============================================================================
 *  CERTIFICATION WORKER — CERTIFICATOR GRADUUM
 *  Kernel AI GOK-CERT-001  ·  Family: CERTIFICATION_ORGANISM
 * ============================================================================
 *
 *  Formal skill / certification ladder  ·  Fibonacci cert levels F1→F377
 *  Structured capability progression  ·  Skill assessment engine
 *
 *  Fibonacci Certification Levels:
 *    F1  (1)   — Initiate          F2  (1)   — Apprentice
 *    F3  (2)   — Practitioner      F5  (5)   — Specialist
 *    F8  (8)   — Expert            F13 (13)  — Master
 *    F21 (21)  — Architect         F34 (34)  — Principal
 *    F55 (55)  — Fellow            F89 (89)  — Distinguished
 *    F144(144) — Sovereign         F233(233) — Transcendent
 *    F377(377) — Omega
 *
 *  MiniHeart  — 873 ms Kuramoto pulse, φ-phase advance
 *  MiniBrain  — 5 regions, 3 chemicals, LIF membrane model
 *
 *  Commands:
 *    CERTIFY          — issue a certification to an entity
 *    ASSESS           — assess skill level
 *    GET_LADDER       — get the full certification ladder
 *    GET_CERTS        — list all issued certifications
 *    GET_ENTITY       — get certifications for a specific entity
 *    ADVANCE          — advance an entity to next Fibonacci level
 *    GET_DOMAINS      — list certification domains
 *    GET_VITALS       — MiniHeart + MiniBrain vitals
 *    status           — kernel status
 *    stop             — graceful shutdown
 *
 *  Zero external dependencies.
 * ============================================================================
 */

/* ── §1  CONSTANTS ──────────────────────────────────────────────────────── */

var KERNEL_ID      = 'GOK-CERT-001';
var KERNEL_FAMILY  = 'CERTIFICATION_ORGANISM';
var KERNEL_VERSION = '1.0.0';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var PHI_SQ    = 2.6180339887498948482;
var SQRT5     = 2.2360679774997896964;
var HEARTBEAT = 873;

/* ── §2  FIBONACCI LADDER ───────────────────────────────────────────────── */

var FIB_LEVELS = [
  { level: 'F1',   fib: 1,   title: 'Initiate',       minSkill: 0.00, color: '#808080' },
  { level: 'F2',   fib: 1,   title: 'Apprentice',      minSkill: 0.05, color: '#A0A0A0' },
  { level: 'F3',   fib: 2,   title: 'Practitioner',    minSkill: 0.10, color: '#4CAF50' },
  { level: 'F5',   fib: 5,   title: 'Specialist',      minSkill: 0.20, color: '#2196F3' },
  { level: 'F8',   fib: 8,   title: 'Expert',           minSkill: 0.35, color: '#9C27B0' },
  { level: 'F13',  fib: 13,  title: 'Master',           minSkill: 0.50, color: '#FF9800' },
  { level: 'F21',  fib: 21,  title: 'Architect',        minSkill: 0.618, color: '#F44336' },
  { level: 'F34',  fib: 34,  title: 'Principal',        minSkill: 0.72, color: '#E91E63' },
  { level: 'F55',  fib: 55,  title: 'Fellow',           minSkill: 0.80, color: '#00BCD4' },
  { level: 'F89',  fib: 89,  title: 'Distinguished',    minSkill: 0.88, color: '#FFD700' },
  { level: 'F144', fib: 144, title: 'Sovereign',        minSkill: 0.93, color: '#FF6F00' },
  { level: 'F233', fib: 233, title: 'Transcendent',     minSkill: 0.97, color: '#D500F9' },
  { level: 'F377', fib: 377, title: 'Omega',            minSkill: 0.99, color: '#FFFFFF' }
];

/* ── §3  CERTIFICATION DOMAINS ──────────────────────────────────────────── */

var DOMAINS = [
  { id: 'DOM-ARCH',  name: 'Architecture',        weight: PHI },
  { id: 'DOM-CODE',  name: 'Software Engineering', weight: PHI },
  { id: 'DOM-DATA',  name: 'Data Engineering',     weight: PHI_INV },
  { id: 'DOM-SEC',   name: 'Security',             weight: PHI },
  { id: 'DOM-ML',    name: 'Machine Learning',     weight: PHI_INV },
  { id: 'DOM-DEVOP', name: 'DevOps',               weight: PHI_INV },
  { id: 'DOM-CLOUD', name: 'Cloud Infrastructure', weight: PHI_INV },
  { id: 'DOM-QUANT', name: 'Quantum Computing',    weight: PHI_SQ },
  { id: 'DOM-LEAD',  name: 'Technical Leadership', weight: PHI },
  { id: 'DOM-EMER',  name: 'Emergence Science',    weight: PHI_SQ },
  { id: 'DOM-NEURO', name: 'Neuromorphic Systems', weight: PHI_SQ },
  { id: 'DOM-CRYPT', name: 'Cryptography',         weight: PHI },
  { id: 'DOM-BIO',   name: 'Bioinformatics',       weight: PHI_INV },
  { id: 'DOM-ROBOT', name: 'Robotics',             weight: PHI_INV }
];

/* ── §4  MINI-HEART ─────────────────────────────────────────────────────── */

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
    certCount:   certStore.length,
    entities:    Object.keys(entityIndex).length
  });
}

/* ── §5  MINI-BRAIN ─────────────────────────────────────────────────────── */

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

/* ── §6  CERTIFICATION ENGINE ───────────────────────────────────────────── */

var certStore   = [];
var entityIndex = Object.create(null);  /* entityId → [ certId, ... ] */

function assessLevel(skillScore) {
  var level = FIB_LEVELS[0];
  for (var i = FIB_LEVELS.length - 1; i >= 0; i--) {
    if (skillScore >= FIB_LEVELS[i].minSkill) {
      level = FIB_LEVELS[i];
      break;
    }
  }
  return level;
}

function certify(entityId, domainId, skillScore) {
  var domain = DOMAINS.find(function(d) { return d.id === domainId; });
  if (!domain) return { error: 'Domain not found: ' + domainId };
  var weighted = Math.min(1.0, skillScore * domain.weight / PHI);
  var level = assessLevel(weighted);
  var cert = {
    certId:     'CERT-' + Date.now().toString(36) + '-' + certStore.length,
    entityId:   entityId,
    domainId:   domainId,
    domain:     domain.name,
    rawScore:   skillScore,
    weighted:   weighted,
    level:      level.level,
    title:      level.title,
    fib:        level.fib,
    issuedAt:   Date.now(),
    issuedBeat: beatCount,
    valid:      true
  };
  certStore.push(cert);
  if (!entityIndex[entityId]) entityIndex[entityId] = [];
  entityIndex[entityId].push(cert.certId);
  return cert;
}

function advanceEntity(entityId) {
  var certs = entityIndex[entityId];
  if (!certs || certs.length === 0) return { error: 'No certs for entity: ' + entityId };
  /* find highest current level across all domains */
  var maxIdx = 0;
  for (var i = 0; i < certs.length; i++) {
    var c = certStore.find(function(x) { return x.certId === certs[i]; });
    if (c) {
      var idx = FIB_LEVELS.findIndex(function(l) { return l.level === c.level; });
      if (idx > maxIdx) maxIdx = idx;
    }
  }
  if (maxIdx >= FIB_LEVELS.length - 1) return { error: 'Already at maximum level (Omega)' };
  var nextLevel = FIB_LEVELS[maxIdx + 1];
  return {
    entityId:  entityId,
    from:      FIB_LEVELS[maxIdx].title,
    to:        nextLevel.title,
    newLevel:  nextLevel.level,
    newFib:    nextLevel.fib,
    minSkill:  nextLevel.minSkill
  };
}

function getEntityCerts(entityId) {
  var ids = entityIndex[entityId] || [];
  return ids.map(function(cid) {
    return certStore.find(function(c) { return c.certId === cid; });
  }).filter(Boolean);
}

/* ── §7  MESSAGE HANDLER ────────────────────────────────────────────────── */

self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {
    case 'CERTIFY': {
      var result = certify(msg.entityId, msg.domainId, msg.skillScore || 0);
      self.postMessage({ type: 'CERTIFY_RESULT', result: result, kernelId: KERNEL_ID });
      break;
    }
    case 'ASSESS': {
      var level = assessLevel(msg.skillScore || 0);
      self.postMessage({ type: 'ASSESS_RESULT', result: level, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_LADDER': {
      self.postMessage({ type: 'LADDER', result: FIB_LEVELS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_CERTS': {
      self.postMessage({ type: 'CERTS', result: certStore, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_ENTITY': {
      var ec = getEntityCerts(msg.entityId);
      self.postMessage({ type: 'ENTITY_CERTS', result: ec, entityId: msg.entityId, kernelId: KERNEL_ID });
      break;
    }
    case 'ADVANCE': {
      var adv = advanceEntity(msg.entityId);
      self.postMessage({ type: 'ADVANCE_RESULT', result: adv, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_DOMAINS': {
      self.postMessage({ type: 'DOMAINS', result: DOMAINS, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_VITALS': {
      self.postMessage({
        type: 'VITALS',
        result: {
          heart: { beat: beatCount, phase: kernelPhase, bpm: 60000 / HEARTBEAT },
          brain: brain,
          certCount: certStore.length,
          entities:  Object.keys(entityIndex).length,
          domains:   DOMAINS.length,
          levels:    FIB_LEVELS.length
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
        certCount:    certStore.length,
        domains:      DOMAINS.length,
        levels:       FIB_LEVELS.length
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
  domains:  DOMAINS.length,
  levels:   FIB_LEVELS.length,
  ladder:   FIB_LEVELS.map(function(l) { return l.level + ' ' + l.title; }),
  commands: [
    'CERTIFY', 'ASSESS', 'GET_LADDER', 'GET_CERTS',
    'GET_ENTITY', 'ADVANCE', 'GET_DOMAINS', 'GET_VITALS',
    'status', 'stop'
  ]
});
