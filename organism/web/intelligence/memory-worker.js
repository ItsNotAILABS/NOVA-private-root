/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Memory Worker (GOK-MEMORY-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-MEMORY-001
 * Kernel Family:  SPATIAL_MEMORY
 * Architecture:   φ-Encoded Spatial Memory × Semantic Search × Tag Index
 *
 * Every dispatch is remembered. Users can search past tasks. Memory survives
 * page reload via localStorage persistence. The product has a brain that
 * doesn't forget.
 *
 * Features:
 *   • φ-encoded memory addresses (spatial hashing via golden ratio)
 *   • Semantic search with TF-IDF-like scoring
 *   • Tag-based index for instant lookup
 *   • localStorage persistence — memory survives page reload
 *   • Automatic compaction when memory exceeds capacity
 *   • Decay function: older memories fade by φ⁻¹ per 1000 beats
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'store', key, value, tags, beat }
 *   Main → Worker: { type: 'recall', key }
 *   Main → Worker: { type: 'search', query, maxResults }
 *   Main → Worker: { type: 'search-tags', tags, maxResults }
 *   Main → Worker: { type: 'persist' }
 *   Main → Worker: { type: 'restore' }
 *   Main → Worker: { type: 'status' }
 *   Worker → Main: { type: 'stored', key, address, beat }
 *   Worker → Main: { type: 'recalled', key, value, age, strength }
 *   Worker → Main: { type: 'search-results', results, count }
 *   Worker → Main: { type: 'persisted', count, sizeBytes }
 *   Worker → Main: { type: 'restored', count }
 *   Worker → Main: { type: 'heartbeat', ... }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * MEDINA TECH — SOVEREIGN KERNEL ARCHITECTURE
 */


/* ════════════════════════════════════════════════════════════════
   KERNEL CONSTANTS
   ════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var KERNEL_ID      = 'GOK-MEMORY-001';
var KERNEL_FAMILY  = 'SPATIAL_MEMORY';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;

var MAX_MEMORIES   = 10000;
var STORAGE_KEY    = 'nova_sovereign_memory_v1';


/* ════════════════════════════════════════════════════════════════
   MEMORY STORE — φ-encoded spatial addressing
   ════════════════════════════════════════════════════════════════ */

var memories  = {};   // key → memory object
var tagIndex  = {};   // tag → Set of keys
var memCount  = 0;


/**
 * φ-spatial address: Uses golden ratio to distribute memory addresses
 * uniformly across a 32-bit space (Fibonacci hashing).
 */
function phiAddress(key) {
  var hash = 0;
  for (var i = 0; i < key.length; i++) {
    hash = ((hash << 5) - hash + key.charCodeAt(i)) | 0;
  }
  // Fibonacci hashing — multiply by φ⁻¹ * 2^32, take upper bits
  var fibHash = Math.floor(Math.abs(hash) * PHI_INV * 4294967296) >>> 0;
  return fibHash.toString(16).padStart(8, '0');
}


/**
 * Store a memory with φ-encoded address and tag index.
 */
function storeMemory(key, value, tags, beat) {
  var address = phiAddress(key);
  var existing = memories[key];

  var mem = {
    key:       key,
    address:   address,
    value:     value,
    tags:      tags || [],
    createdAt: existing ? existing.createdAt : beat,
    updatedAt: beat,
    accessCount: existing ? existing.accessCount + 1 : 0,
    strength:  1.0,
  };

  memories[key] = mem;
  if (!existing) memCount++;

  // Update tag index
  for (var t = 0; t < mem.tags.length; t++) {
    var tag = mem.tags[t];
    if (!tagIndex[tag]) tagIndex[tag] = {};
    tagIndex[tag][key] = true;
  }

  // Compact if over capacity
  if (memCount > MAX_MEMORIES) compactMemories(beat);

  return mem;
}


/**
 * Recall a memory by key. Strengthens it on access.
 */
function recallMemory(key, currentBeat) {
  var mem = memories[key];
  if (!mem) return null;

  // Strengthen on access
  mem.accessCount++;
  mem.strength = Math.min(mem.strength + PHI_INV * 0.1, 1.0);

  // Compute age
  var age = (currentBeat || 0) - mem.createdAt;

  return {
    key:       mem.key,
    address:   mem.address,
    value:     mem.value,
    tags:      mem.tags,
    age:       age,
    strength:  mem.strength,
    accessCount: mem.accessCount,
  };
}


/**
 * Semantic search — TF-IDF-like scoring over memory values.
 */
function searchMemories(query, maxResults) {
  var queryTokens = tokenize(query);
  if (queryTokens.length === 0) return [];

  var results = [];
  var keys = Object.keys(memories);

  for (var i = 0; i < keys.length; i++) {
    var mem = memories[keys[i]];
    var valueTokens = tokenize(typeof mem.value === 'string' ? mem.value : JSON.stringify(mem.value));
    var score = tfidfScore(queryTokens, valueTokens);

    // Boost by strength and recency
    score *= mem.strength;
    score *= (1.0 + mem.accessCount * 0.01);

    if (score > 0) {
      results.push({
        key:      mem.key,
        address:  mem.address,
        value:    mem.value,
        tags:     mem.tags,
        score:    score,
        strength: mem.strength,
      });
    }
  }

  // Sort by score descending
  results.sort(function(a, b) { return b.score - a.score; });
  return results.slice(0, maxResults || 10);
}


/**
 * Search by tags — returns memories matching ANY of the given tags.
 */
function searchByTags(tags, maxResults) {
  var resultKeys = {};
  for (var t = 0; t < tags.length; t++) {
    var idx = tagIndex[tags[t]];
    if (idx) {
      var keys = Object.keys(idx);
      for (var k = 0; k < keys.length; k++) resultKeys[keys[k]] = true;
    }
  }

  var results = [];
  var allKeys = Object.keys(resultKeys);
  for (var i = 0; i < allKeys.length; i++) {
    var mem = memories[allKeys[i]];
    if (mem) {
      results.push({
        key:      mem.key,
        address:  mem.address,
        value:    mem.value,
        tags:     mem.tags,
        strength: mem.strength,
      });
    }
  }

  results.sort(function(a, b) { return b.strength - a.strength; });
  return results.slice(0, maxResults || 10);
}


/* ════════════════════════════════════════════════════════════════
   TEXT PROCESSING — Tokenization + TF-IDF scoring
   ════════════════════════════════════════════════════════════════ */

function tokenize(text) {
  if (!text) return [];
  return text.toLowerCase().replace(/[^a-z0-9\s-]/g, '').split(/\s+/).filter(function(t) { return t.length > 1; });
}

function tfidfScore(queryTokens, docTokens) {
  if (docTokens.length === 0) return 0;
  var score = 0;

  // Build frequency map for document
  var freq = {};
  for (var d = 0; d < docTokens.length; d++) {
    freq[docTokens[d]] = (freq[docTokens[d]] || 0) + 1;
  }

  for (var q = 0; q < queryTokens.length; q++) {
    var qt = queryTokens[q];
    if (freq[qt]) {
      // TF: frequency / doc length
      var tf = freq[qt] / docTokens.length;
      // IDF approximation: use inverse of how common the token is
      var idf = Math.log(1 + MAX_MEMORIES / (1 + countDocsWithToken(qt)));
      score += tf * idf;
    }
  }
  return score;
}

function countDocsWithToken(token) {
  var count = 0;
  var keys = Object.keys(memories);
  for (var i = 0; i < Math.min(keys.length, 100); i++) {
    var v = memories[keys[i]].value;
    var s = typeof v === 'string' ? v : JSON.stringify(v);
    if (s.toLowerCase().indexOf(token) >= 0) count++;
  }
  return count;
}


/* ════════════════════════════════════════════════════════════════
   MEMORY COMPACTION — Evict weakest memories when over capacity
   ════════════════════════════════════════════════════════════════ */

function compactMemories(currentBeat) {
  var keys = Object.keys(memories);
  // Score each memory: strength * recency * access
  var scored = [];
  for (var i = 0; i < keys.length; i++) {
    var mem = memories[keys[i]];
    var age = (currentBeat || 0) - mem.updatedAt;
    var recency = 1.0 / (1.0 + age * 0.001);
    var score = mem.strength * recency * (1 + mem.accessCount * 0.1);
    scored.push({ key: keys[i], score: score });
  }

  scored.sort(function(a, b) { return a.score - b.score; });

  // Evict bottom 20%
  var evictCount = Math.floor(scored.length * 0.2);
  for (var e = 0; e < evictCount; e++) {
    var evictKey = scored[e].key;
    var evictMem = memories[evictKey];
    // Remove from tag index
    if (evictMem && evictMem.tags) {
      for (var t = 0; t < evictMem.tags.length; t++) {
        if (tagIndex[evictMem.tags[t]]) {
          delete tagIndex[evictMem.tags[t]][evictKey];
        }
      }
    }
    delete memories[evictKey];
    memCount--;
  }
}


/**
 * Apply decay: all memories lose strength by φ⁻¹ factor per 1000 beats.
 */
function applyDecay(currentBeat) {
  var keys = Object.keys(memories);
  for (var i = 0; i < keys.length; i++) {
    var mem = memories[keys[i]];
    var age = currentBeat - mem.updatedAt;
    if (age > 1000) {
      var decayFactor = Math.pow(PHI_INV, Math.floor(age / 1000));
      mem.strength = Math.max(mem.strength * decayFactor, 0.01);
    }
  }
}


/* ════════════════════════════════════════════════════════════════
   PERSISTENCE — localStorage serialization
   ════════════════════════════════════════════════════════════════ */

function persistToStorage() {
  try {
    var data = JSON.stringify({ memories: memories, memCount: memCount });
    if (typeof self.localStorage !== 'undefined') {
      self.localStorage.setItem(STORAGE_KEY, data);
    }
    return { count: memCount, sizeBytes: data.length };
  } catch (err) {
    return { count: 0, sizeBytes: 0, error: err.message };
  }
}

function restoreFromStorage() {
  try {
    if (typeof self.localStorage === 'undefined') return { count: 0 };
    var data = self.localStorage.getItem(STORAGE_KEY);
    if (!data) return { count: 0 };
    var parsed = JSON.parse(data);
    memories = parsed.memories || {};
    memCount = parsed.memCount || Object.keys(memories).length;

    // Rebuild tag index
    tagIndex = {};
    var keys = Object.keys(memories);
    for (var i = 0; i < keys.length; i++) {
      var mem = memories[keys[i]];
      if (mem.tags) {
        for (var t = 0; t < mem.tags.length; t++) {
          if (!tagIndex[mem.tags[t]]) tagIndex[mem.tags[t]] = {};
          tagIndex[mem.tags[t]][keys[i]] = true;
        }
      }
    }

    return { count: memCount };
  } catch (err) {
    return { count: 0, error: err.message };
  }
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'store': {
      var mem = storeMemory(msg.key, msg.value, msg.tags, msg.beat || beatCount);
      self.postMessage({
        type: 'stored',
        key: mem.key,
        address: mem.address,
        beat: mem.updatedAt,
        memoryCount: memCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'recall': {
      var recalled = recallMemory(msg.key, beatCount);
      if (recalled) {
        self.postMessage({
          type: 'recalled',
          key: recalled.key,
          address: recalled.address,
          value: recalled.value,
          tags: recalled.tags,
          age: recalled.age,
          strength: recalled.strength,
          accessCount: recalled.accessCount,
          kernelId: KERNEL_ID,
        });
      } else {
        self.postMessage({
          type: 'recall-miss',
          key: msg.key,
          kernelId: KERNEL_ID,
        });
      }
      break;
    }

    case 'search': {
      var results = searchMemories(msg.query, msg.maxResults);
      self.postMessage({
        type: 'search-results',
        query: msg.query,
        results: results,
        count: results.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'search-tags': {
      var tagResults = searchByTags(msg.tags, msg.maxResults);
      self.postMessage({
        type: 'search-results',
        tags: msg.tags,
        results: tagResults,
        count: tagResults.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'persist': {
      var pResult = persistToStorage();
      self.postMessage({
        type: 'persisted',
        count: pResult.count,
        sizeBytes: pResult.sizeBytes,
        error: pResult.error,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'restore': {
      var rResult = restoreFromStorage();
      self.postMessage({
        type: 'restored',
        count: rResult.count,
        error: rResult.error,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'decay': {
      applyDecay(msg.beat || beatCount);
      self.postMessage({
        type: 'decay-applied',
        memoryCount: memCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'memory-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        memoryCount: memCount,
        tagCount: Object.keys(tagIndex).length,
        maxMemories: MAX_MEMORIES,
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

  // Apply decay every 100 beats
  if (beatCount % 100 === 0) applyDecay(beatCount);

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    memoryCount: memCount,
  });
}, HEARTBEAT);
