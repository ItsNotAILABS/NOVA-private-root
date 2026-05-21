/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Cache Worker (GOK-CACHE-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-CACHE-001
 * Kernel Family:  HOT_CACHE
 * Architecture:   LRU Eviction × TTL Expiry × φ-Weighted Hit Scoring × Prefetch
 *
 * High-performance in-memory cache with LRU eviction, per-entry TTL,
 * namespace partitioning, and access-pattern prediction for intelligent
 * prefetch suggestions. Hit/miss ratios are scored using the golden ratio
 * to surface cache health to the telemetry ring.
 *
 * Features:
 *   • LRU eviction with configurable max size (default 5000 entries)
 *   • Per-entry TTL expiration with lazy + periodic sweep
 *   • Hit/miss ratio tracking with φ-weighted scoring
 *   • Access-pattern prediction for prefetch suggestions
 *   • Namespace-partitioned cache spaces
 *   • Bulk invalidation by namespace or pattern
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'set', key, value, ttl, namespace }
 *   Main → Worker: { type: 'get', key, namespace }
 *   Main → Worker: { type: 'invalidate', key, namespace, pattern }
 *   Main → Worker: { type: 'flush', namespace }
 *   Main → Worker: { type: 'stats', namespace }
 *   Main → Worker: { type: 'predict', namespace }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'cache-hit', key, value, age }
 *   Worker → Main: { type: 'cache-miss', key }
 *   Worker → Main: { type: 'cache-set', key, namespace }
 *   Worker → Main: { type: 'cache-stats', hits, misses, ratio, entries }
 *   Worker → Main: { type: 'prefetch-suggestions', keys }
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

var KERNEL_ID      = 'GOK-CACHE-001';
var KERNEL_FAMILY  = 'HOT_CACHE';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;

var MAX_ENTRIES       = 5000;
var DEFAULT_TTL_MS    = 300000;  // 5 minutes
var SWEEP_INTERVAL    = 50;     // sweep every 50 beats
var PATTERN_WINDOW    = 100;    // recent accesses to track


/* ════════════════════════════════════════════════════════════════
   CACHE DATA STRUCTURES
   ════════════════════════════════════════════════════════════════ */

var namespaces  = {};   // ns → { entries, order[], hits, misses }
var accessLog   = [];   // recent access keys for pattern prediction
var totalHits   = 0;
var totalMisses = 0;

/**
 * Get or create a namespace partition.
 */
function getNamespace(ns) {
  ns = ns || '_default';
  if (!namespaces[ns]) {
    namespaces[ns] = {
      name: ns,
      entries: {},
      order: [],
      hits: 0,
      misses: 0,
    };
  }
  return namespaces[ns];
}

/**
 * Count total entries across all namespaces.
 */
function totalEntryCount() {
  var count = 0;
  var nsKeys = Object.keys(namespaces);
  for (var i = 0; i < nsKeys.length; i++) {
    count += namespaces[nsKeys[i]].order.length;
  }
  return count;
}


/* ════════════════════════════════════════════════════════════════
   LRU OPERATIONS
   ════════════════════════════════════════════════════════════════ */

/**
 * Move a key to the most-recently-used position.
 */
function touchKey(nsObj, key) {
  var idx = nsObj.order.indexOf(key);
  if (idx > -1) nsObj.order.splice(idx, 1);
  nsObj.order.push(key);
}

/**
 * Evict least-recently-used entries until under MAX_ENTRIES.
 */
function evictIfNeeded() {
  while (totalEntryCount() > MAX_ENTRIES) {
    var oldestNs = null;
    var oldestTime = Infinity;
    var nsKeys = Object.keys(namespaces);
    for (var i = 0; i < nsKeys.length; i++) {
      var ns = namespaces[nsKeys[i]];
      if (ns.order.length > 0) {
        var firstKey = ns.order[0];
        var entry = ns.entries[firstKey];
        if (entry && entry.createdAt < oldestTime) {
          oldestTime = entry.createdAt;
          oldestNs = ns;
        }
      }
    }
    if (!oldestNs || oldestNs.order.length === 0) break;
    var evictKey = oldestNs.order.shift();
    delete oldestNs.entries[evictKey];
  }
}

/**
 * Check if an entry has expired.
 */
function isExpired(entry) {
  if (!entry || !entry.ttl) return false;
  return Date.now() > entry.createdAt + entry.ttl;
}


/* ════════════════════════════════════════════════════════════════
   CACHE SET / GET / INVALIDATE
   ════════════════════════════════════════════════════════════════ */

function cacheSet(key, value, ttl, namespace) {
  var ns = getNamespace(namespace);
  var now = Date.now();
  var entry = {
    key: key,
    value: value,
    ttl: (typeof ttl === 'number') ? ttl : DEFAULT_TTL_MS,
    createdAt: now,
    accessCount: 0,
    lastAccess: now,
  };
  if (ns.entries[key]) {
    var idx = ns.order.indexOf(key);
    if (idx > -1) ns.order.splice(idx, 1);
  }
  ns.entries[key] = entry;
  ns.order.push(key);
  evictIfNeeded();
  return { key: key, namespace: ns.name };
}

function cacheGet(key, namespace) {
  var ns = getNamespace(namespace);
  var entry = ns.entries[key];
  if (!entry || isExpired(entry)) {
    if (entry && isExpired(entry)) {
      var idx = ns.order.indexOf(key);
      if (idx > -1) ns.order.splice(idx, 1);
      delete ns.entries[key];
    }
    ns.misses++;
    totalMisses++;
    accessLog.push({ key: key, ns: ns.name, hit: false, time: Date.now() });
    if (accessLog.length > PATTERN_WINDOW) accessLog.shift();
    return null;
  }
  entry.accessCount++;
  entry.lastAccess = Date.now();
  touchKey(ns, key);
  ns.hits++;
  totalHits++;
  accessLog.push({ key: key, ns: ns.name, hit: true, time: Date.now() });
  if (accessLog.length > PATTERN_WINDOW) accessLog.shift();
  return {
    key: key,
    value: entry.value,
    age: Date.now() - entry.createdAt,
    accessCount: entry.accessCount,
  };
}

function cacheInvalidate(key, namespace, pattern) {
  var invalidated = 0;
  var targets = namespace ? [getNamespace(namespace)] : objectValues(namespaces);
  for (var n = 0; n < targets.length; n++) {
    var ns = targets[n];
    if (key) {
      if (ns.entries[key]) {
        delete ns.entries[key];
        var idx = ns.order.indexOf(key);
        if (idx > -1) ns.order.splice(idx, 1);
        invalidated++;
      }
    } else if (pattern) {
      var re = new RegExp(pattern);
      var keys = Object.keys(ns.entries);
      for (var k = 0; k < keys.length; k++) {
        if (re.test(keys[k])) {
          delete ns.entries[keys[k]];
          var oidx = ns.order.indexOf(keys[k]);
          if (oidx > -1) ns.order.splice(oidx, 1);
          invalidated++;
        }
      }
    }
  }
  return invalidated;
}

function cacheFlush(namespace) {
  if (namespace) {
    var ns = getNamespace(namespace);
    var count = ns.order.length;
    ns.entries = {};
    ns.order = [];
    return count;
  }
  var total = totalEntryCount();
  namespaces = {};
  return total;
}

function objectValues(obj) {
  var vals = [];
  var keys = Object.keys(obj);
  for (var i = 0; i < keys.length; i++) vals.push(obj[keys[i]]);
  return vals;
}


/* ════════════════════════════════════════════════════════════════
   HIT/MISS STATS — φ-weighted scoring
   ════════════════════════════════════════════════════════════════ */

function cacheStats(namespace) {
  var hits = 0;
  var misses = 0;
  var entries = 0;
  var targets = namespace ? [getNamespace(namespace)] : objectValues(namespaces);
  for (var n = 0; n < targets.length; n++) {
    hits += targets[n].hits;
    misses += targets[n].misses;
    entries += targets[n].order.length;
  }
  var total = hits + misses;
  var ratio = total > 0 ? hits / total : 0;
  var phiScore = ratio * PHI;
  return {
    hits: hits,
    misses: misses,
    total: total,
    ratio: ratio,
    phiScore: phiScore,
    entries: entries,
    namespaceCount: Object.keys(namespaces).length,
    maxEntries: MAX_ENTRIES,
  };
}


/* ════════════════════════════════════════════════════════════════
   PREFETCH PREDICTION — access pattern analysis
   ════════════════════════════════════════════════════════════════ */

/**
 * Analyze recent access patterns to suggest keys for prefetch.
 * Uses sequential pair frequency: if key A is often followed by key B,
 * suggest prefetching B when A is accessed.
 */
function predictPrefetch(namespace) {
  var pairFreq = {};
  var filtered = accessLog;
  if (namespace) {
    filtered = [];
    for (var f = 0; f < accessLog.length; f++) {
      if (accessLog[f].ns === namespace) filtered.push(accessLog[f]);
    }
  }
  for (var i = 1; i < filtered.length; i++) {
    var pair = filtered[i - 1].key + '→' + filtered[i].key;
    pairFreq[pair] = (pairFreq[pair] || 0) + 1;
  }
  var pairs = Object.keys(pairFreq);
  var scored = [];
  for (var p = 0; p < pairs.length; p++) {
    scored.push({ pair: pairs[p], freq: pairFreq[pairs[p]] });
  }
  scored.sort(function(a, b) { return b.freq - a.freq; });
  var suggestions = [];
  for (var s = 0; s < Math.min(scored.length, 10); s++) {
    var parts = scored[s].pair.split('→');
    suggestions.push({
      after: parts[0],
      prefetch: parts[1],
      confidence: scored[s].freq / filtered.length,
      phiWeight: scored[s].freq * PHI_INV,
    });
  }
  return suggestions;
}


/* ════════════════════════════════════════════════════════════════
   TTL SWEEP — periodic expiration pass
   ════════════════════════════════════════════════════════════════ */

function sweepExpired() {
  var swept = 0;
  var nsKeys = Object.keys(namespaces);
  for (var n = 0; n < nsKeys.length; n++) {
    var ns = namespaces[nsKeys[n]];
    var keys = Object.keys(ns.entries);
    for (var k = 0; k < keys.length; k++) {
      if (isExpired(ns.entries[keys[k]])) {
        delete ns.entries[keys[k]];
        var idx = ns.order.indexOf(keys[k]);
        if (idx > -1) ns.order.splice(idx, 1);
        swept++;
      }
    }
  }
  return swept;
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'set': {
      var setResult = cacheSet(msg.key, msg.value, msg.ttl, msg.namespace);
      self.postMessage({
        type: 'cache-set',
        key: setResult.key,
        namespace: setResult.namespace,
        totalEntries: totalEntryCount(),
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'get': {
      var hit = cacheGet(msg.key, msg.namespace);
      if (hit) {
        self.postMessage({
          type: 'cache-hit',
          key: hit.key,
          value: hit.value,
          age: hit.age,
          accessCount: hit.accessCount,
          kernelId: KERNEL_ID,
        });
      } else {
        self.postMessage({
          type: 'cache-miss',
          key: msg.key,
          namespace: msg.namespace || '_default',
          kernelId: KERNEL_ID,
        });
      }
      break;
    }

    case 'invalidate': {
      var invCount = cacheInvalidate(msg.key, msg.namespace, msg.pattern);
      self.postMessage({
        type: 'cache-invalidated',
        count: invCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'flush': {
      var flushed = cacheFlush(msg.namespace);
      self.postMessage({
        type: 'cache-flushed',
        flushed: flushed,
        namespace: msg.namespace || 'ALL',
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'stats': {
      var stats = cacheStats(msg.namespace);
      self.postMessage({
        type: 'cache-stats',
        stats: stats,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'predict': {
      var suggestions = predictPrefetch(msg.namespace);
      self.postMessage({
        type: 'prefetch-suggestions',
        suggestions: suggestions,
        count: suggestions.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'cache-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalEntries: totalEntryCount(),
        namespaceCount: Object.keys(namespaces).length,
        maxEntries: MAX_ENTRIES,
        totalHits: totalHits,
        totalMisses: totalMisses,
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

  // Periodic TTL sweep
  if (beatCount % SWEEP_INTERVAL === 0) sweepExpired();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalEntries: totalEntryCount(),
  });
}, HEARTBEAT);
