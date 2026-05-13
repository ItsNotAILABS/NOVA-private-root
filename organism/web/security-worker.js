// ═══════════════════════════════════════════════════════════════════════════════
// CUSTOS OPERANS — Security & Threat Analysis Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// FNV-1a hashing, Shannon entropy, threat pattern scanning, key generation.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI          = 1.618033988749895;
const INV_PHI      = 0.618033988749895;
const TAU          = 6.283185307179586;
const HEARTBEAT_MS = 873;

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  phase: Math.random() * TAU,
  freq: TAU / HEARTBEAT_MS,
  tick() {
    this.phase = (this.phase + this.freq * HEARTBEAT_MS * 0.001) % TAU;
    return { phase: this.phase, pulse: Math.sin(this.phase) };
  }
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
let tickCount = 0;
let scansPerformed = 0;
let hashesComputed = 0;

// ─── FNV-1a HASH (32-bit) ──────────────────────────────────────────────────────
function fnv1a(data) {
  const str = typeof data === 'string' ? data : String(data);
  let hash = 0x811c9dc5; // FNV offset basis
  for (let i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193); // FNV prime
  }
  hashesComputed++;
  return (hash >>> 0); // Ensure unsigned 32-bit
}

// ─── SHANNON ENTROPY ────────────────────────────────────────────────────────────
// Measures bits of entropy per character in a string
function shannonEntropy(str) {
  if (!str || str.length === 0) return 0;
  const freq = {};
  for (let i = 0; i < str.length; i++) {
    const c = str[i];
    freq[c] = (freq[c] || 0) + 1;
  }
  let entropy = 0;
  const len = str.length;
  for (const c in freq) {
    const p = freq[c] / len;
    if (p > 0) entropy -= p * Math.log2(p);
  }
  return entropy;
}

// ─── THREAT PATTERNS ────────────────────────────────────────────────────────────
const THREAT_PATTERNS = [
  { name: 'SQL_INJECTION',      pattern: /(\b(SELECT|INSERT|UPDATE|DELETE|DROP|UNION)\b.*\b(FROM|INTO|SET|TABLE|WHERE)\b)/i, weight: 0.9 },
  { name: 'XSS_SCRIPT',        pattern: /<script[\s>]/i,                                        weight: 0.85 },
  { name: 'XSS_EVENT',         pattern: /\bon\w+\s*=/i,                                         weight: 0.7 },
  { name: 'PATH_TRAVERSAL',    pattern: /\.\.\//g,                                               weight: 0.8 },
  { name: 'COMMAND_INJECTION', pattern: /[;&|`$]\s*(rm|cat|wget|curl|chmod|eval|exec)\b/i,       weight: 0.95 },
  { name: 'NULL_BYTE',         pattern: /%00|\\0/,                                               weight: 0.75 },
  { name: 'HEX_SHELLCODE',     pattern: /\\x[0-9a-f]{2}(\\x[0-9a-f]{2}){3,}/i,                  weight: 0.8 },
  { name: 'BASE64_PAYLOAD',    pattern: /[A-Za-z0-9+/]{40,}={0,2}/,                             weight: 0.4 },
  { name: 'LDAP_INJECTION',    pattern: /[()&|!][a-zA-Z]+=\*/,                                  weight: 0.7 },
  { name: 'OVERFLOW_ATTEMPT',  pattern: /(.)\1{100,}/,                                           weight: 0.6 },
];

function scanThreats(text) {
  if (typeof text !== 'string') return { score: 0, threats: [], safe: true };
  const threats = [];
  let maxWeight = 0;
  for (const tp of THREAT_PATTERNS) {
    if (tp.pattern.test(text)) {
      threats.push({ name: tp.name, weight: tp.weight });
      if (tp.weight > maxWeight) maxWeight = tp.weight;
    }
  }
  // Combined score: weighted by worst threat and count
  const score = threats.length === 0 ? 0 : Math.min(1, maxWeight * (0.5 + 0.5 * Math.min(threats.length / 5, 1)));
  scansPerformed++;
  return { score, threats, safe: score < 0.5 };
}

// ─── KEY GENERATION ─────────────────────────────────────────────────────────────
// Generates a random hex key of the specified byte length using xorshift128+
function generateKey(byteLength) {
  const len = typeof byteLength === 'number' && byteLength > 0 ? byteLength : 32;
  let s0 = (Date.now() ^ 0xDEADBEEF) >>> 0;
  let s1 = (tickCount * 2654435761 ^ 0xCAFEBABE) >>> 0;
  let hex = '';
  for (let i = 0; i < len; i++) {
    // xorshift128+
    let t = s0;
    const u = s1;
    s0 = u;
    t ^= (t << 23) >>> 0;
    t ^= (t >>> 17);
    t ^= u ^ (u >>> 26);
    s1 = t;
    const byte = ((t + u) >>> 0) & 0xFF;
    hex += byte.toString(16).padStart(2, '0');
  }
  return hex;
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  const { cmd, data, text, length } = e.data || {};
  switch (cmd) {
    case 'HASH': {
      const hash = fnv1a(data);
      self.postMessage({ cmd, hash, hex: '0x' + hash.toString(16).padStart(8, '0') });
      break;
    }
    case 'ENTROPY': {
      const str = typeof data === 'string' ? data : (text || '');
      const entropy = shannonEntropy(str);
      self.postMessage({ cmd, entropy, length: str.length, maxEntropy: Math.log2(new Set(str).size || 1) });
      break;
    }
    case 'SCAN': {
      const input = typeof data === 'string' ? data : (text || '');
      self.postMessage({ cmd, result: scanThreats(input) });
      break;
    }
    case 'GENERATE_KEY': {
      const key = generateKey(length);
      self.postMessage({ cmd, key, byteLength: length || 32 });
      break;
    }
    case 'GET_STATUS': {
      const heart = MiniHeart.tick();
      self.postMessage({
        cmd, status: {
          worker: 'CUSTOS_OPERANS', tickCount, heartPhase: heart.phase,
          hashesComputed, scansPerformed, threatPatterns: THREAT_PATTERNS.length
        }
      });
      break;
    }
    default:
      self.postMessage({ cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT ──────────────────────────────────────────────────────────────────
setInterval(() => {
  tickCount++;
  const heart = MiniHeart.tick();
  self.postMessage({ type: 'heartbeat', worker: 'CUSTOS_OPERANS', tick: tickCount, heart });
}, HEARTBEAT_MS);
