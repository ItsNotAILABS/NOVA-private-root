// ═══════════════════════════════════════════════════════════════════════════════
// CERTIFICATOR OPERANS — Certification Pipeline Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// Fibonacci-inspired certification levels, test suite runner, FNV-1a hashing,
// Shannon entropy scoring, callable interface verification.
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
let certIdCounter = 0;

// ─── CERTIFICATION LEVELS (Fibonacci-inspired) ─────────────────────────────────
var CERT_LEVELS = [
  { level: 'F1_DRAFT',      threshold: 0.0,  fib: 1 },
  { level: 'F2_REVIEWED',   threshold: 0.3,  fib: 2 },
  { level: 'F3_TESTED',     threshold: 0.5,  fib: 3 },
  { level: 'F5_VALIDATED',  threshold: 0.7,  fib: 5 },
  { level: 'F8_CERTIFIED',  threshold: 0.85, fib: 8 },
  { level: 'F13_SOVEREIGN', threshold: 0.95, fib: 13 },
];

// ─── CERTIFICATION REGISTRY ─────────────────────────────────────────────────────
var registry = {};

// ─── FNV-1a HASH (32-bit) ──────────────────────────────────────────────────────
function fnv1a(str) {
  var s = typeof str === 'string' ? str : String(str);
  var hash = 0x811c9dc5;
  for (var i = 0; i < s.length; i++) {
    hash ^= s.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193);
  }
  return (hash >>> 0);
}

// ─── SHANNON ENTROPY ────────────────────────────────────────────────────────────
function shannonEntropy(str) {
  if (!str || str.length === 0) return 0;
  var freq = {};
  for (var i = 0; i < str.length; i++) {
    var c = str[i];
    freq[c] = (freq[c] || 0) + 1;
  }
  var entropy = 0;
  var len = str.length;
  var keys = Object.keys(freq);
  for (var k = 0; k < keys.length; k++) {
    var p = freq[keys[k]] / len;
    if (p > 0) entropy -= p * Math.log2(p);
  }
  return entropy;
}

// ─── VALIDATION CHECKS ─────────────────────────────────────────────────────────
function runChecks(componentData) {
  var dataStr = typeof componentData === 'string' ? componentData : JSON.stringify(componentData || {});
  var checks = [];

  // 1. Syntax check — data must be non-empty
  var syntaxPass = dataStr.length > 2;
  checks.push({ name: 'syntax', passed: syntaxPass, score: syntaxPass ? 1.0 : 0.0 });

  // 2. Integrity check — FNV-1a hash must be non-zero
  var hash = fnv1a(dataStr);
  var integrityPass = hash !== 0;
  checks.push({ name: 'integrity', passed: integrityPass, score: integrityPass ? 1.0 : 0.0 });

  // 3. Coherence check — entropy should indicate meaningful content
  var entropy = shannonEntropy(dataStr);
  var maxEntropy = Math.log2(Math.max(new Set(dataStr).size, 1));
  var coherenceScore = maxEntropy > 0 ? entropy / maxEntropy : 0;
  checks.push({ name: 'coherence', passed: coherenceScore > 0.3, score: coherenceScore });

  // 4. Performance check — data should not be excessively large
  var perfScore = Math.min(1.0, 1.0 - (dataStr.length / 100000));
  checks.push({ name: 'performance', passed: perfScore > 0.2, score: Math.max(0, perfScore) });

  // 5. Security check — no obvious injection patterns
  var securityPass = !/(<script|eval\(|__proto__)/.test(dataStr);
  checks.push({ name: 'security', passed: securityPass, score: securityPass ? 1.0 : 0.3 });

  // 6. Callable interface — check for required methods in component data
  var callableFields = ['think', 'pulse', 'reflect', 'status'];
  var callableFound = 0;
  for (var f = 0; f < callableFields.length; f++) {
    if (dataStr.indexOf(callableFields[f]) !== -1) callableFound++;
  }
  var callableScore = callableFound / callableFields.length;
  checks.push({ name: 'callable', passed: callableScore >= 0.5, score: callableScore });

  return { checks: checks, hash: hash, entropy: entropy };
}

// ─── DETERMINE CERTIFICATION LEVEL ─────────────────────────────────────────────
function determineCertLevel(checks) {
  var totalScore = 0;
  var passCount = 0;
  for (var i = 0; i < checks.length; i++) {
    totalScore += checks[i].score;
    if (checks[i].passed) passCount++;
  }
  var avgScore = totalScore / checks.length;
  var passRate = passCount / checks.length;
  var combined = avgScore * 0.6 + passRate * 0.4;

  var level = CERT_LEVELS[0].level;
  for (var j = CERT_LEVELS.length - 1; j >= 0; j--) {
    if (combined >= CERT_LEVELS[j].threshold) {
      level = CERT_LEVELS[j].level;
      break;
    }
  }
  return { level: level, score: combined };
}

// ─── CERTIFY COMPONENT ──────────────────────────────────────────────────────────
function certifyComponent(componentId, componentData) {
  var checkResult = runChecks(componentData);
  var levelResult = determineCertLevel(checkResult.checks);

  certIdCounter++;
  var certId = 'CERT-' + certIdCounter.toString().padStart(6, '0');

  var certificate = {
    id: certId,
    componentId: componentId,
    level: levelResult.level,
    score: Math.round(levelResult.score * 10000) / 10000,
    hash: '0x' + checkResult.hash.toString(16).padStart(8, '0'),
    entropy: Math.round(checkResult.entropy * 10000) / 10000,
    timestamp: Date.now(),
    checks: checkResult.checks,
    valid: true,
  };

  registry[certId] = certificate;
  return { certificate: certificate };
}

// ─── VERIFY CERTIFICATE ─────────────────────────────────────────────────────────
function verifyCertificate(certificateId) {
  var cert = registry[certificateId];
  if (!cert) return { verified: false, error: 'Certificate not found: ' + certificateId };

  var age = Date.now() - cert.timestamp;
  var maxAge = HEARTBEAT_MS * 1000 * 60;
  var fresh = age < maxAge;

  return {
    verified: cert.valid && fresh,
    certificate: cert,
    age: age,
    fresh: fresh,
  };
}

// ─── REGISTRY STATS ─────────────────────────────────────────────────────────────
function getStats() {
  var keys = Object.keys(registry);
  var total = keys.length;
  var byLevel = {};
  var entropySum = 0;
  var integrityCount = 0;

  for (var i = 0; i < CERT_LEVELS.length; i++) byLevel[CERT_LEVELS[i].level] = 0;

  for (var k = 0; k < keys.length; k++) {
    var cert = registry[keys[k]];
    if (byLevel[cert.level] !== undefined) byLevel[cert.level]++;
    entropySum += cert.entropy;
    if (cert.valid) integrityCount++;
  }

  return {
    totalCertified: total,
    byLevel: byLevel,
    avgEntropy: total > 0 ? Math.round((entropySum / total) * 10000) / 10000 : 0,
    integrityRate: total > 0 ? Math.round((integrityCount / total) * 10000) / 10000 : 1,
  };
}

// ─── KURAMOTO / PHI COHERENCE ───────────────────────────────────────────────────
function computePhiCoherence() {
  var certKeys = Object.keys(registry);
  var n = Math.max(certKeys.length, 1);
  var sumCos = 0;
  var sumSin = 0;
  for (var i = 0; i < n; i++) {
    var theta = (i * PHI * TAU + MiniHeart.phase) % TAU;
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }
  return Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  var data = e.data || {};
  var cmd = data.cmd;
  switch (cmd) {
    case 'CERTIFY':
      self.postMessage({ cmd: cmd, result: certifyComponent(data.componentId, data.componentData) });
      break;
    case 'VERIFY':
      self.postMessage({ cmd: cmd, result: verifyCertificate(data.certificateId) });
      break;
    case 'GET_REGISTRY': {
      var keys = Object.keys(registry);
      var list = [];
      for (var i = 0; i < keys.length; i++) list.push(registry[keys[i]]);
      self.postMessage({ cmd: cmd, registry: list });
      break;
    }
    case 'RUN_CHECKS':
      self.postMessage({ cmd: cmd, result: runChecks(data.componentData) });
      break;
    case 'GET_STATS':
      self.postMessage({ cmd: cmd, stats: getStats() });
      break;
    case 'GET_STATUS': {
      var heart = MiniHeart.tick();
      self.postMessage({
        cmd: cmd, status: {
          worker: 'CERTIFICATOR_OPERANS', tickCount: tickCount,
          heartPhase: heart.phase, totalCertified: Object.keys(registry).length,
          certIdCounter: certIdCounter,
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
  var heart = MiniHeart.tick();
  var stats = getStats();
  self.postMessage({
    type: 'HEARTBEAT', worker: 'CERTIFICATOR_OPERANS',
    tick: tickCount, heart: heart,
    certifiedCount: stats.totalCertified,
    pendingCount: 0,
    integrityScore: stats.integrityRate,
    kuramotoPhase: heart.phase,
    phiCoherence: computePhiCoherence(),
  });
}, HEARTBEAT_MS);
