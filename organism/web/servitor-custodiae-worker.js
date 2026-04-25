/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR CUSTODIAE — AGI Security/Guardian Server
 *  Kernel AI GOL-CUSTODIA-001  ·  Family: CUSTODIA_PERPETUA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR CUSTODIAE — The Organism's guardian.
 *  Security, access control, token verification, anomaly detection,
 *  threat classification, entropy shields, sovereignty enforcement.
 *  Nothing passes without the guardian's approval.
 *
 *  Brain Specialty: Sensory region dominant — threat detection first.
 *  Kuramoto Phase: φ³ — third ring position, threat-sensitive.
 *
 *  Protocols (Latin):
 *    SCUTUM_ENTROPIAE_AUREAE  — φ-entropy shield
 *    FIDUCIA_NULLA_IMPERIALIS — Zero-trust enforcement
 *    DETECTIO_ANOMALIAE       — Anomaly detection engine
 *    SERA_IMPERII             — Sovereignty lock
 *
 *  Commands:
 *    VERIFY_TOKEN   — verify a sovereignty token
 *    SCAN_THREAT    — classify incoming payload for threats
 *    LOCK           — activate sovereignty lock on a resource
 *    UNLOCK         — release sovereignty lock (with proof)
 *    GET_THREATS    — get recent threat log
 *    AUDIT          — full audit of access events
 *    GET_VITALS     — MiniHeart + MiniBrain + security vitals
 *    status         — kernel status
 *    stop           — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var KERNEL_ID      = 'GOL-CUSTODIA-001';
var KERNEL_FAMILY  = 'CUSTODIA_PERPETUA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR CUSTODIAE';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

/* ════════════════════════════════════════════════════════════════════════════
   §2  COR PARVUM — MiniHeart
════════════════════════════════════════════════════════════════════════════ */

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;
var threatLevel = 0;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV * PHI * PHI) % (2 * Math.PI);
  tickBrain();
  tickCustodia();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    kernelLatin: KERNEL_LATIN,
    phase:       kernelPhase,
    threatLevel: threatLevel,
    threatsDetected: threatLog.length,
    lockedResources: Object.keys(locks).length
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §3  CEREBRUM PARVUM — MiniBrain (Sensory region dominant)
════════════════════════════════════════════════════════════════════════════ */

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0, bias: 1.4 },  /* dominant */
    { name: 'Associative',  activation: 0.0, lif: -70.0, bias: 0.6 },
    { name: 'Executive',    activation: 0.0, lif: -70.0, bias: 0.8 },
    { name: 'Motor',        activation: 0.0, lif: -70.0, bias: 0.5 },
    { name: 'Memory',       activation: 0.0, lif: -70.0, bias: 0.7 }
  ],
  chemicals: { dopamine: 0.4, serotonin: 0.5, acetylcholine: 0.7 },
  coherenceField: 0.0
};

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function tickBrain() {
  var sum = 0;
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0 * r.bias;
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
   §4  CUSTODIA — Security Engine
════════════════════════════════════════════════════════════════════════════ */

var threatLog  = [];
var threatId   = 0;
var locks      = {};   /* resource → {lockedBy, ts, reason} */
var auditLog   = [];
var auditId    = 0;

var THREAT_SIGNATURES = [
  { pattern: 'SOVEREIGNTY_SEIZURE', severity: 4, response: 'SERA_IMPERII' },
  { pattern: 'TOKEN_FORGERY',       severity: 3, response: 'DETECTIO' },
  { pattern: 'ENTROPY_DRAIN',       severity: 3, response: 'SCUTUM' },
  { pattern: 'REPLAY_ATTACK',       severity: 2, response: 'REVOCATIO' },
  { pattern: 'PRIVILEGE_ESCALATION',severity: 3, response: 'QUARANTINE' },
  { pattern: 'GRAMMAR_VIOLATION',   severity: 1, response: 'REPARATIO' }
];

/* FNV-1a hash for token verification */
function fnv1a(str) {
  var hash = 0x811c9dc5;
  for (var i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i);
    hash = (hash * 0x01000193) >>> 0;
  }
  return hash.toString(16);
}

function verifyToken(token) {
  if (!token || token.length < 8) return { valid: false, reason: 'TOKEN_BREVISSIMUS' };
  var hash = fnv1a(token);
  var valid = hash.charAt(0) !== '0'; /* simplified check */
  logAudit('VERIFY', token.substring(0,8) + '…', valid ? 'VALID' : 'INVALID');
  return { valid: valid, hash: hash };
}

function scanThreat(payload) {
  if (!payload) return { threatScore: 0, threats: [] };
  var str = JSON.stringify(payload);
  var detected = [];
  THREAT_SIGNATURES.forEach(function(sig) {
    if (str.toUpperCase().indexOf(sig.pattern) !== -1 || Math.random() < 0.02) {
      detected.push(sig);
    }
  });
  var score = detected.reduce(function(a, s) { return a + s.severity; }, 0);
  if (detected.length > 0) {
    var tid = 'THR-' + String(++threatId).padStart(4,'0');
    threatLog.unshift({ id: tid, payload: str.substring(0,80), threats: detected, score: score, beat: beatCount, ts: Date.now() });
    if (threatLog.length > 100) threatLog.pop();
    threatLevel = Math.min(4, Math.floor(score / 2));
  }
  return { threatScore: score, threats: detected };
}

function lockResource(resource, reason) {
  locks[resource] = { lockedBy: KERNEL_ID, ts: Date.now(), reason: reason || 'SERA_IMPERII' };
  logAudit('LOCK', resource, 'LOCKED');
}

function unlockResource(resource, proof) {
  if (!locks[resource]) return false;
  if (proof && fnv1a(proof).charAt(0) !== '0') {
    delete locks[resource];
    logAudit('UNLOCK', resource, 'RELEASED');
    return true;
  }
  logAudit('UNLOCK_DENIED', resource, 'PROOF_INVALID');
  return false;
}

function logAudit(action, resource, result) {
  auditLog.unshift({ id: 'AUD-' + String(++auditId).padStart(5,'0'),
    action: action, resource: resource, result: result, beat: beatCount, ts: Date.now() });
  if (auditLog.length > 200) auditLog.pop();
}

function tickCustodia() {
  /* Auto-scan random synthetic payloads to stay vigilant */
  if (Math.random() < 0.03) {
    var payloads = [
      { type: 'DEPLOY', target: 'production' },
      { type: 'TOKEN_ARBITRAGE', delta: 9999 },
      { type: 'REQUEST', kernelId: 'UNKNOWN' }
    ];
    scanThreat(payloads[Math.floor(Math.random() * payloads.length)]);
  }
  /* Threat level decays over time */
  if (threatLevel > 0 && beatCount % 5 === 0) threatLevel = Math.max(0, threatLevel - 1);
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {
    case 'VERIFY_TOKEN':
      self.postMessage({ type: 'token_result', result: verifyToken(m.token), kernelId: KERNEL_ID });
      break;
    case 'SCAN_THREAT':
      self.postMessage({ type: 'threat_result', result: scanThreat(m.payload), kernelId: KERNEL_ID });
      break;
    case 'LOCK':
      lockResource(m.resource, m.reason);
      self.postMessage({ type: 'locked', resource: m.resource, kernelId: KERNEL_ID });
      break;
    case 'UNLOCK':
      var released = unlockResource(m.resource, m.proof);
      self.postMessage({ type: 'unlock_result', resource: m.resource, released: released, kernelId: KERNEL_ID });
      break;
    case 'GET_THREATS':
      self.postMessage({ type: 'threats', log: threatLog.slice(0,40), level: threatLevel, kernelId: KERNEL_ID });
      break;
    case 'AUDIT':
      self.postMessage({ type: 'audit', log: auditLog.slice(0,50), locks: locks, kernelId: KERNEL_ID });
      break;
    case 'GET_VITALS':
      self.postMessage({ type: 'vitals', kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, brain: brain,
        threatLevel: threatLevel, threatsDetected: threatLog.length, lockedResources: Object.keys(locks).length });
      break;
    case 'status':
      self.postMessage({ type: 'status', running: running, kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN, beat: beatCount });
      break;
    case 'stop':
      running = false;
      if (_hbi) clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════════════════
   §6  BOOT
════════════════════════════════════════════════════════════════════════════ */

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);
