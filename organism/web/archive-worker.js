/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Archive Worker (GOK-ARCHIVE-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-ARCHIVE-001
 * Kernel Family:  COLD_STORAGE
 * Architecture:   Tiered Storage × RLE Compression × Retention Policies
 *
 * Long-term cold storage engine. Data flows through four temperature tiers
 * (HOT → WARM → COLD → FROZEN) based on age and access frequency. RLE
 * compression reduces payload size. Retention policies control automatic
 * pruning by time, count, or importance score.
 *
 * Storage Tiers:
 *   HOT    — Recently archived, < 1 hour old
 *   WARM   — 1 hour to 24 hours old
 *   COLD   — 1 day to 30 days old
 *   FROZEN — Over 30 days, fully compressed
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'archive', key, value, importance, tags }
 *   Main → Worker: { type: 'retrieve', key }
 *   Main → Worker: { type: 'compact' }
 *   Main → Worker: { type: 'tier-status' }
 *   Main → Worker: { type: 'set-retention', policy }
 *   Main → Worker: { type: 'export', tier }
 *   Main → Worker: { type: 'import', records }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'archived', key, tier }
 *   Worker → Main: { type: 'retrieved', key, value, tier }
 *   Worker → Main: { type: 'compacted', freed }
 *   Worker → Main: { type: 'tier-report', tiers }
 *   Worker → Main: { type: 'exported', records, count }
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

var KERNEL_ID      = 'GOK-ARCHIVE-001';
var KERNEL_FAMILY  = 'COLD_STORAGE';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;


/* ════════════════════════════════════════════════════════════════
   TIER THRESHOLDS (milliseconds)
   ════════════════════════════════════════════════════════════════ */

var TIER_HOT_MAX    = 3600000;       // 1 hour
var TIER_WARM_MAX   = 86400000;      // 24 hours
var TIER_COLD_MAX   = 2592000000;    // 30 days

var TIER_NAMES = ['HOT', 'WARM', 'COLD', 'FROZEN'];


/* ════════════════════════════════════════════════════════════════
   ARCHIVE STORAGE
   ════════════════════════════════════════════════════════════════ */

var store      = {};   // key → record
var storeCount = 0;

var retentionPolicy = {
  maxAge: null,        // max milliseconds to keep (null = forever)
  maxCount: null,      // max total records (null = unlimited)
  minImportance: 0,    // drop records below this importance
};


/* ════════════════════════════════════════════════════════════════
   RUN-LENGTH ENCODING — simple compression
   ════════════════════════════════════════════════════════════════ */

function rleEncode(str) {
  if (typeof str !== 'string' || str.length === 0) return '';
  var result = '';
  var count = 1;
  for (var i = 1; i <= str.length; i++) {
    if (i < str.length && str[i] === str[i - 1]) {
      count++;
    } else {
      result += (count > 1 ? count : '') + str[i - 1];
      count = 1;
    }
  }
  return result;
}

function rleDecode(encoded) {
  if (typeof encoded !== 'string' || encoded.length === 0) return '';
  var result = '';
  var numBuf = '';
  for (var i = 0; i < encoded.length; i++) {
    var ch = encoded[i];
    if (ch >= '0' && ch <= '9') {
      numBuf += ch;
    } else {
      var repeat = numBuf ? parseInt(numBuf, 10) : 1;
      for (var r = 0; r < repeat; r++) result += ch;
      numBuf = '';
    }
  }
  return result;
}


/* ════════════════════════════════════════════════════════════════
   TIER CLASSIFICATION
   ════════════════════════════════════════════════════════════════ */

function classifyTier(ageMs) {
  if (ageMs < TIER_HOT_MAX) return 'HOT';
  if (ageMs < TIER_WARM_MAX) return 'WARM';
  if (ageMs < TIER_COLD_MAX) return 'COLD';
  return 'FROZEN';
}

function tierIndex(name) {
  return TIER_NAMES.indexOf(name);
}


/* ════════════════════════════════════════════════════════════════
   ARCHIVE / RETRIEVE
   ════════════════════════════════════════════════════════════════ */

function archiveRecord(key, value, importance, tags) {
  var now = Date.now();
  var serialized = typeof value === 'string' ? value : JSON.stringify(value);
  var record = {
    key: key,
    rawValue: serialized,
    compressed: null,
    importance: typeof importance === 'number' ? importance : 0.5,
    tags: tags || [],
    createdAt: now,
    lastAccess: now,
    accessCount: 0,
    tier: 'HOT',
    isCompressed: false,
    sizeRaw: serialized.length,
    sizeCompressed: 0,
  };
  if (!store[key]) storeCount++;
  store[key] = record;
  return { key: key, tier: 'HOT' };
}

function retrieveRecord(key) {
  var record = store[key];
  if (!record) return null;
  record.lastAccess = Date.now();
  record.accessCount++;
  var value = record.isCompressed
    ? rleDecode(record.compressed)
    : record.rawValue;
  return {
    key: record.key,
    value: value,
    tier: record.tier,
    importance: record.importance,
    tags: record.tags,
    age: Date.now() - record.createdAt,
    accessCount: record.accessCount,
  };
}


/* ════════════════════════════════════════════════════════════════
   COMPACTION — compress & re-tier
   ════════════════════════════════════════════════════════════════ */

function compact() {
  var now = Date.now();
  var freed = 0;
  var keys = Object.keys(store);
  for (var i = 0; i < keys.length; i++) {
    var rec = store[keys[i]];
    var age = now - rec.createdAt;
    var newTier = classifyTier(age);

    // Promote compression for COLD/FROZEN records
    if (tierIndex(newTier) >= 2 && !rec.isCompressed) {
      rec.compressed = rleEncode(rec.rawValue);
      rec.sizeCompressed = rec.compressed.length;
      freed += rec.sizeRaw - rec.sizeCompressed;
      rec.rawValue = null;
      rec.isCompressed = true;
    }
    rec.tier = newTier;
  }
  return freed > 0 ? freed : 0;
}


/* ════════════════════════════════════════════════════════════════
   RETENTION ENFORCEMENT
   ════════════════════════════════════════════════════════════════ */

function enforceRetention() {
  var now = Date.now();
  var pruned = 0;
  var keys = Object.keys(store);

  // Importance-based pruning
  if (retentionPolicy.minImportance > 0) {
    for (var i = keys.length - 1; i >= 0; i--) {
      if (store[keys[i]].importance < retentionPolicy.minImportance) {
        delete store[keys[i]];
        keys.splice(i, 1);
        storeCount--;
        pruned++;
      }
    }
  }

  // Time-based pruning
  if (retentionPolicy.maxAge) {
    for (var t = keys.length - 1; t >= 0; t--) {
      if (now - store[keys[t]].createdAt > retentionPolicy.maxAge) {
        delete store[keys[t]];
        keys.splice(t, 1);
        storeCount--;
        pruned++;
      }
    }
  }

  // Count-based pruning (remove oldest first)
  if (retentionPolicy.maxCount && keys.length > retentionPolicy.maxCount) {
    keys.sort(function(a, b) { return store[a].createdAt - store[b].createdAt; });
    while (keys.length > retentionPolicy.maxCount) {
      var oldest = keys.shift();
      delete store[oldest];
      storeCount--;
      pruned++;
    }
  }

  return pruned;
}


/* ════════════════════════════════════════════════════════════════
   TIER STATUS REPORT
   ════════════════════════════════════════════════════════════════ */

function tierStatus() {
  var report = {};
  for (var t = 0; t < TIER_NAMES.length; t++) {
    report[TIER_NAMES[t]] = { count: 0, totalSize: 0 };
  }
  var keys = Object.keys(store);
  for (var i = 0; i < keys.length; i++) {
    var rec = store[keys[i]];
    var tier = report[rec.tier];
    if (tier) {
      tier.count++;
      tier.totalSize += rec.isCompressed ? rec.sizeCompressed : rec.sizeRaw;
    }
  }
  return report;
}


/* ════════════════════════════════════════════════════════════════
   BULK EXPORT / IMPORT
   ════════════════════════════════════════════════════════════════ */

function exportRecords(tierFilter) {
  var records = [];
  var keys = Object.keys(store);
  for (var i = 0; i < keys.length; i++) {
    var rec = store[keys[i]];
    if (tierFilter && rec.tier !== tierFilter) continue;
    records.push({
      key: rec.key,
      value: rec.isCompressed ? rleDecode(rec.compressed) : rec.rawValue,
      importance: rec.importance,
      tags: rec.tags,
      tier: rec.tier,
      createdAt: rec.createdAt,
    });
  }
  return records;
}

function importRecords(records) {
  var imported = 0;
  for (var i = 0; i < records.length; i++) {
    var r = records[i];
    archiveRecord(r.key, r.value, r.importance, r.tags);
    imported++;
  }
  return imported;
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'archive': {
      var result = archiveRecord(msg.key, msg.value, msg.importance, msg.tags);
      self.postMessage({
        type: 'archived',
        key: result.key,
        tier: result.tier,
        totalRecords: storeCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'retrieve': {
      var rec = retrieveRecord(msg.key);
      if (rec) {
        self.postMessage({
          type: 'retrieved',
          key: rec.key,
          value: rec.value,
          tier: rec.tier,
          importance: rec.importance,
          age: rec.age,
          kernelId: KERNEL_ID,
        });
      } else {
        self.postMessage({
          type: 'retrieve-miss',
          key: msg.key,
          kernelId: KERNEL_ID,
        });
      }
      break;
    }

    case 'compact': {
      var freed = compact();
      self.postMessage({
        type: 'compacted',
        freed: freed,
        totalRecords: storeCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'tier-status': {
      var tiers = tierStatus();
      self.postMessage({
        type: 'tier-report',
        tiers: tiers,
        totalRecords: storeCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'set-retention': {
      if (msg.policy) {
        if (typeof msg.policy.maxAge === 'number') retentionPolicy.maxAge = msg.policy.maxAge;
        if (typeof msg.policy.maxCount === 'number') retentionPolicy.maxCount = msg.policy.maxCount;
        if (typeof msg.policy.minImportance === 'number') retentionPolicy.minImportance = msg.policy.minImportance;
      }
      self.postMessage({
        type: 'retention-set',
        policy: retentionPolicy,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'export': {
      var exported = exportRecords(msg.tier);
      self.postMessage({
        type: 'exported',
        records: exported,
        count: exported.length,
        tier: msg.tier || 'ALL',
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'import': {
      var count = importRecords(msg.records || []);
      self.postMessage({
        type: 'imported',
        count: count,
        totalRecords: storeCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'archive-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalRecords: storeCount,
        tiers: tierStatus(),
        retentionPolicy: retentionPolicy,
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

  // Enforce retention every 200 beats
  if (beatCount % 200 === 0) enforceRetention();
  // Re-tier every 100 beats
  if (beatCount % 100 === 0) compact();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalRecords: storeCount,
  });
}, HEARTBEAT);
