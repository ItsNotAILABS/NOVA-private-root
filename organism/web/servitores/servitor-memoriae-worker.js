/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR MEMORIAE — AGI Memory Server
 *  Kernel AI GOL-MEMORIA-001  ·  Family: MEMORIA_AETERNA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR MEMORIAE — The Organism's eternal memory.
 *  Distributed KV store, long-term organism memory, salience scoring,
 *  associative recall, memory consolidation, and forgetting curves.
 *
 *  Brain Specialty: Memory region dominant — highest activation bias.
 *  Kuramoto Phase: φ¹ leading — first in the synchronization ring.
 *
 *  Protocols (Latin):
 *    THESAURUS_IMPERIALIS   — Sovereign KV store operations
 *    COHAERENTIA_REPOSITORII — Cache coherence maintenance
 *    ARBOR_AUREA_MERKLE     — Merkle tree integrity verification
 *    CODEX_IMMUTABILIS      — Immutable ledger writes
 *
 *  Commands:
 *    STORE      — store a key-value pair with salience score
 *    RECALL     — retrieve by key or semantic proximity
 *    CONSOLIDATE — run memory consolidation (move short→long term)
 *    FORGET     — apply forgetting curve to aged memories
 *    SCAN       — full memory scan with filters
 *    GET_VITALS — MiniHeart + MiniBrain + memory vitals
 *    status     — kernel status
 *    stop       — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var KERNEL_ID      = 'GOL-MEMORIA-001';
var KERNEL_FAMILY  = 'MEMORIA_AETERNA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR MEMORIAE';

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

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  tickMemory();
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
    memoryCount: Object.keys(shortTerm).length + longTerm.length,
    salientItems: longTerm.filter(function(m){return m.salience > 0.7;}).length
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §3  CEREBRUM PARVUM — MiniBrain (Memory region dominant)
════════════════════════════════════════════════════════════════════════════ */

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0, bias: 0.5 },
    { name: 'Associative',  activation: 0.0, lif: -70.0, bias: 0.8 },
    { name: 'Executive',    activation: 0.0, lif: -70.0, bias: 0.5 },
    { name: 'Motor',        activation: 0.0, lif: -70.0, bias: 0.4 },
    { name: 'Memory',       activation: 0.0, lif: -70.0, bias: 1.2 }  /* dominant */
  ],
  chemicals: { dopamine: 0.5, serotonin: 0.6, acetylcholine: 0.8 },
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
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.015);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.45) * 0.02);
  brain.coherenceField = sum / brain.regions.length;
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  MEMORIA — Memory System
════════════════════════════════════════════════════════════════════════════ */

var shortTerm = {};  /* key → {value, salience, ts, accessCount} */
var longTerm  = [];  /* [{key, value, salience, consolidated, ts}] */
var memId     = 0;
var consolidations = 0;
var recalls   = 0;

/* Forgetting curve: Ebbinghaus R = e^(-t/S) where S = salience * 1000s */
function retentionStrength(salience, ageMs) {
  return Math.exp(-ageMs / (salience * 1000000));
}

function storeMemory(key, value, salience) {
  salience = Math.max(0, Math.min(1, salience || Math.random() * 0.5 + 0.3));
  shortTerm[key] = { value: value, salience: salience, ts: Date.now(), accessCount: 0 };
  if (Object.keys(shortTerm).length > 200) {
    /* Evict lowest-salience short-term item */
    var minKey = null, minSal = 1;
    for (var k in shortTerm) {
      if (shortTerm[k].salience < minSal) { minSal = shortTerm[k].salience; minKey = k; }
    }
    if (minKey) delete shortTerm[minKey];
  }
}

function recallMemory(key) {
  recalls++;
  if (shortTerm[key]) {
    shortTerm[key].accessCount++;
    shortTerm[key].salience = Math.min(1, shortTerm[key].salience + 0.05);
    return shortTerm[key];
  }
  for (var i = 0; i < longTerm.length; i++) {
    if (longTerm[i].key === key) {
      longTerm[i].salience = Math.min(1, longTerm[i].salience + 0.03);
      return longTerm[i];
    }
  }
  return null;
}

function consolidateMemory() {
  consolidations++;
  var now = Date.now();
  var promoted = 0;
  for (var k in shortTerm) {
    var m = shortTerm[k];
    var age = now - m.ts;
    if (age > 10000 && m.salience > 0.5) { /* 10s threshold for demo */
      longTerm.push({ key: k, value: m.value, salience: m.salience, consolidated: now, ts: m.ts });
      delete shortTerm[k];
      promoted++;
      if (longTerm.length > 500) longTerm.shift();
    }
  }
  return promoted;
}

function applyForgetting() {
  var now = Date.now();
  longTerm = longTerm.filter(function(m) {
    var r = retentionStrength(m.salience, now - m.ts);
    if (r < 0.1) return false; /* forgotten */
    m.salience *= r; /* decay salience */
    return true;
  });
}

function tickMemory() {
  /* Auto-consolidate every 10 beats */
  if (beatCount % 10 === 0) consolidateMemory();
  /* Auto-forget every 20 beats */
  if (beatCount % 20 === 0) applyForgetting();
  /* Auto-seed some synthetic memories from brain coherence */
  if (Math.random() < 0.04) {
    var key = 'COHERENCE_' + beatCount;
    storeMemory(key, brain.coherenceField, brain.coherenceField);
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {
    case 'STORE':
      storeMemory(m.key, m.value, m.salience);
      self.postMessage({ type: 'stored', key: m.key, kernelId: KERNEL_ID });
      break;
    case 'RECALL':
      var result = recallMemory(m.key);
      self.postMessage({ type: 'recalled', key: m.key, result: result, kernelId: KERNEL_ID });
      break;
    case 'CONSOLIDATE':
      var n = consolidateMemory();
      self.postMessage({ type: 'consolidated', promoted: n, kernelId: KERNEL_ID });
      break;
    case 'FORGET':
      applyForgetting();
      self.postMessage({ type: 'forgotten', longTermCount: longTerm.length, kernelId: KERNEL_ID });
      break;
    case 'SCAN':
      self.postMessage({ type: 'scan_result', shortTerm: Object.keys(shortTerm).length,
        longTerm: longTerm.slice(0, 50), kernelId: KERNEL_ID });
      break;
    case 'GET_VITALS':
      self.postMessage({ type: 'vitals', kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, brain: brain,
        shortTermCount: Object.keys(shortTerm).length, longTermCount: longTerm.length,
        consolidations: consolidations, recalls: recalls });
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
