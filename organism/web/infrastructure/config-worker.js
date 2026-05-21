/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Configuration Worker (GOK-CONFIG-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-CONFIG-001
 * Kernel Family:  CONFIGURATION_PLANE
 * Architecture:   Hierarchical Config × Feature Flags × Schema Validation
 *
 * Central configuration plane for the NOVA organism. Manages a four-layer
 * config hierarchy (defaults → environment → runtime → override), feature
 * flags with percentage-based rollout, schema validation, and change
 * notification via diff detection.
 *
 * Config Layers (lowest to highest precedence):
 *   1. DEFAULTS    — built-in safe defaults
 *   2. ENVIRONMENT — environment-specific overrides
 *   3. RUNTIME     — dynamically set during execution
 *   4. OVERRIDE    — emergency / admin overrides
 *
 * Features:
 *   • Hierarchical config resolution with 4 layers
 *   • Feature flags with percentage-based rollout
 *   • Schema validation (type checking, range, required)
 *   • Change notification with diff detection
 *   • 50+ pre-defined NOVA configuration keys
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'get-config', key }
 *   Main → Worker: { type: 'set-config', key, value, layer }
 *   Main → Worker: { type: 'set-flag', flag, enabled, rollout }
 *   Main → Worker: { type: 'get-flag', flag, userId }
 *   Main → Worker: { type: 'validate', key, value }
 *   Main → Worker: { type: 'diff', layer1, layer2 }
 *   Main → Worker: { type: 'reset', layer }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'config-value', key, value, source }
 *   Worker → Main: { type: 'config-set', key, layer }
 *   Worker → Main: { type: 'flag-value', flag, enabled }
 *   Worker → Main: { type: 'validation-result', key, valid, errors }
 *   Worker → Main: { type: 'config-diff', changes }
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

var KERNEL_ID      = 'GOK-CONFIG-001';
var KERNEL_FAMILY  = 'CONFIGURATION_PLANE';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;

var LAYER_NAMES = ['defaults', 'environment', 'runtime', 'override'];


/* ════════════════════════════════════════════════════════════════
   CONFIG LAYERS
   ════════════════════════════════════════════════════════════════ */

var layers = {
  defaults:    {},
  environment: {},
  runtime:     {},
  override:    {},
};


/* ════════════════════════════════════════════════════════════════
   FEATURE FLAGS
   ════════════════════════════════════════════════════════════════ */

var featureFlags = {};   // name → { enabled, rolloutPct, createdAt }


/* ════════════════════════════════════════════════════════════════
   CONFIG SCHEMA (type validation)
   ════════════════════════════════════════════════════════════════ */

var schemas = {};   // key → { type, min, max, required, enum }


/* ════════════════════════════════════════════════════════════════
   50+ PRE-DEFINED NOVA CONFIG KEYS
   ════════════════════════════════════════════════════════════════ */

var NOVA_DEFAULTS = {
  'kernel.heartbeat.interval':      873,
  'kernel.heartbeat.timeout':       5000,
  'kernel.phi':                     PHI,
  'kernel.phi.inv':                 PHI_INV,
  'kernel.version':                 '1.0.0',
  'kernel.debug':                   false,
  'kernel.logLevel':                'info',
  'organism.rings':                 9,
  'organism.maxWorkers':            16,
  'organism.workerTimeout':         30000,
  'organism.healthCheckInterval':   10000,
  'organism.autoRestart':           true,
  'memory.maxEntries':              10000,
  'memory.persistInterval':         60000,
  'memory.decayRate':               PHI_INV,
  'memory.storageKey':              'nova_sovereign_memory_v1',
  'cache.maxEntries':               5000,
  'cache.defaultTTL':               300000,
  'cache.sweepInterval':            50,
  'cache.evictionPolicy':           'lru',
  'archive.tierHotMax':             3600000,
  'archive.tierWarmMax':            86400000,
  'archive.tierColdMax':            2592000000,
  'archive.compressionEnabled':     true,
  'routing.maxHops':                10,
  'routing.circuitBreakerThreshold': 3,
  'routing.circuitBreakerCooldown': 30000,
  'routing.protocols':              10,
  'crypto.algorithm':               'AES-GCM',
  'crypto.keyLength':               256,
  'crypto.hashAlgorithm':           'SHA-256',
  'crypto.signatureScheme':         'ECDSA',
  'telemetry.missThreshold':        3,
  'telemetry.alertCooldown':        10000,
  'telemetry.ringCount':            9,
  'scheduler.maxConcurrency':       8,
  'scheduler.defaultPriority':      5,
  'scheduler.retryBackoffBase':     PHI,
  'scheduler.maxRetries':           5,
  'registry.healthDecayRate':       PHI_INV,
  'registry.preRegistered':         32,
  'frontend.theme':                 'dark',
  'frontend.locale':                'en',
  'frontend.animationsEnabled':     true,
  'frontend.maxChatHistory':        200,
  'frontend.autoScroll':            true,
  'network.timeout':                15000,
  'network.retries':                3,
  'network.baseUrl':                '',
  'security.maxInputLength':        50000,
  'security.rateLimitPerMin':       120,
  'security.csrfEnabled':           true,
  'icp.canisterId.brain':           '',
  'icp.canisterId.organism':        '',
  'icp.host':                       'https://ic0.app',
};

// Load defaults and create schemas
var defaultKeys = Object.keys(NOVA_DEFAULTS);
for (var di = 0; di < defaultKeys.length; di++) {
  var dk = defaultKeys[di];
  var dv = NOVA_DEFAULTS[dk];
  layers.defaults[dk] = dv;

  var stype = typeof dv;
  schemas[dk] = {
    type: stype,
    required: false,
  };
  if (stype === 'number') {
    schemas[dk].min = -Infinity;
    schemas[dk].max = Infinity;
  }
}


/* ════════════════════════════════════════════════════════════════
   CONFIG RESOLUTION — hierarchical lookup
   ════════════════════════════════════════════════════════════════ */

function resolveConfig(key) {
  for (var l = LAYER_NAMES.length - 1; l >= 0; l--) {
    var layer = layers[LAYER_NAMES[l]];
    if (layer.hasOwnProperty(key)) {
      return { value: layer[key], source: LAYER_NAMES[l] };
    }
  }
  return { value: undefined, source: null };
}

function setConfig(key, value, layer) {
  layer = layer || 'runtime';
  if (LAYER_NAMES.indexOf(layer) === -1) layer = 'runtime';
  var oldResolved = resolveConfig(key);
  layers[layer][key] = value;
  var newResolved = resolveConfig(key);

  // Emit change notification if effective value changed
  if (oldResolved.value !== newResolved.value) {
    self.postMessage({
      type: 'config-changed',
      key: key,
      oldValue: oldResolved.value,
      newValue: newResolved.value,
      oldSource: oldResolved.source,
      newSource: newResolved.source,
      kernelId: KERNEL_ID,
    });
  }

  return { key: key, layer: layer };
}


/* ════════════════════════════════════════════════════════════════
   FEATURE FLAGS — percentage rollout
   ════════════════════════════════════════════════════════════════ */

function setFlag(name, enabled, rolloutPct) {
  featureFlags[name] = {
    enabled: !!enabled,
    rolloutPct: typeof rolloutPct === 'number' ? Math.max(0, Math.min(100, rolloutPct)) : 100,
    createdAt: Date.now(),
  };
  return featureFlags[name];
}

/**
 * Evaluate a flag for a given userId. Uses deterministic hashing
 * to ensure the same user always gets the same result.
 */
function getFlag(name, userId) {
  var flag = featureFlags[name];
  if (!flag) return { enabled: false, reason: 'not_found' };
  if (!flag.enabled) return { enabled: false, reason: 'disabled' };
  if (flag.rolloutPct >= 100) return { enabled: true, reason: 'full_rollout' };
  if (flag.rolloutPct <= 0) return { enabled: false, reason: 'zero_rollout' };

  // Deterministic hash of userId → percentage bucket
  var hash = 0;
  var uid = String(userId || 'anonymous');
  for (var i = 0; i < uid.length; i++) {
    hash = ((hash << 5) - hash + uid.charCodeAt(i)) | 0;
  }
  var bucket = Math.abs(hash) % 100;
  var inRollout = bucket < flag.rolloutPct;
  return { enabled: inRollout, reason: inRollout ? 'in_rollout' : 'out_of_rollout', bucket: bucket };
}


/* ════════════════════════════════════════════════════════════════
   SCHEMA VALIDATION
   ════════════════════════════════════════════════════════════════ */

function validateConfig(key, value) {
  var schema = schemas[key];
  var errors = [];

  if (!schema) {
    return { valid: true, errors: [], warning: 'no_schema' };
  }

  if (schema.type && typeof value !== schema.type) {
    errors.push('Expected type "' + schema.type + '", got "' + typeof value + '"');
  }

  if (schema.type === 'number' && typeof value === 'number') {
    if (value < schema.min) errors.push('Value ' + value + ' below minimum ' + schema.min);
    if (value > schema.max) errors.push('Value ' + value + ' above maximum ' + schema.max);
  }

  if (schema.enumValues && schema.enumValues.indexOf(value) === -1) {
    errors.push('Value must be one of: ' + schema.enumValues.join(', '));
  }

  return { valid: errors.length === 0, errors: errors };
}


/* ════════════════════════════════════════════════════════════════
   DIFF DETECTION — compare two layers
   ════════════════════════════════════════════════════════════════ */

function diffLayers(layerName1, layerName2) {
  var l1 = layers[layerName1] || {};
  var l2 = layers[layerName2] || {};
  var allKeys = {};
  var k1 = Object.keys(l1);
  var k2 = Object.keys(l2);
  var i;
  for (i = 0; i < k1.length; i++) allKeys[k1[i]] = true;
  for (i = 0; i < k2.length; i++) allKeys[k2[i]] = true;

  var changes = [];
  var keys = Object.keys(allKeys);
  for (i = 0; i < keys.length; i++) {
    var key = keys[i];
    var v1 = l1.hasOwnProperty(key) ? l1[key] : undefined;
    var v2 = l2.hasOwnProperty(key) ? l2[key] : undefined;
    if (v1 !== v2) {
      changes.push({
        key: key,
        layer1Value: v1,
        layer2Value: v2,
        status: v1 === undefined ? 'added' : (v2 === undefined ? 'removed' : 'changed'),
      });
    }
  }
  return changes;
}


/* ════════════════════════════════════════════════════════════════
   LAYER RESET
   ════════════════════════════════════════════════════════════════ */

function resetLayer(layerName) {
  if (layerName === 'defaults') {
    // Re-initialize defaults from NOVA_DEFAULTS
    layers.defaults = {};
    var dks = Object.keys(NOVA_DEFAULTS);
    for (var i = 0; i < dks.length; i++) {
      layers.defaults[dks[i]] = NOVA_DEFAULTS[dks[i]];
    }
    return dks.length;
  }
  if (layers[layerName]) {
    var count = Object.keys(layers[layerName]).length;
    layers[layerName] = {};
    return count;
  }
  return 0;
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'get-config': {
      var resolved = resolveConfig(msg.key);
      self.postMessage({
        type: 'config-value',
        key: msg.key,
        value: resolved.value,
        source: resolved.source,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'set-config': {
      var validation = validateConfig(msg.key, msg.value);
      if (!validation.valid) {
        self.postMessage({
          type: 'config-rejected',
          key: msg.key,
          errors: validation.errors,
          kernelId: KERNEL_ID,
        });
        break;
      }
      var setResult = setConfig(msg.key, msg.value, msg.layer);
      self.postMessage({
        type: 'config-set',
        key: setResult.key,
        layer: setResult.layer,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'set-flag': {
      var flag = setFlag(msg.flag, msg.enabled, msg.rollout);
      self.postMessage({
        type: 'flag-set',
        flag: msg.flag,
        enabled: flag.enabled,
        rolloutPct: flag.rolloutPct,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'get-flag': {
      var flagResult = getFlag(msg.flag, msg.userId);
      self.postMessage({
        type: 'flag-value',
        flag: msg.flag,
        enabled: flagResult.enabled,
        reason: flagResult.reason,
        bucket: flagResult.bucket,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'validate': {
      var valResult = validateConfig(msg.key, msg.value);
      self.postMessage({
        type: 'validation-result',
        key: msg.key,
        valid: valResult.valid,
        errors: valResult.errors,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'diff': {
      var changes = diffLayers(msg.layer1 || 'defaults', msg.layer2 || 'runtime');
      self.postMessage({
        type: 'config-diff',
        layer1: msg.layer1 || 'defaults',
        layer2: msg.layer2 || 'runtime',
        changes: changes,
        count: changes.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'reset': {
      var cleared = resetLayer(msg.layer || 'runtime');
      self.postMessage({
        type: 'config-reset',
        layer: msg.layer || 'runtime',
        clearedKeys: cleared,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      var configCount = 0;
      for (var li = 0; li < LAYER_NAMES.length; li++) {
        configCount += Object.keys(layers[LAYER_NAMES[li]]).length;
      }
      self.postMessage({
        type: 'config-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalConfigKeys: configCount,
        layerCounts: {
          defaults: Object.keys(layers.defaults).length,
          environment: Object.keys(layers.environment).length,
          runtime: Object.keys(layers.runtime).length,
          override: Object.keys(layers.override).length,
        },
        totalFlags: Object.keys(featureFlags).length,
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

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalConfigKeys: Object.keys(layers.defaults).length,
  });
}, HEARTBEAT);
