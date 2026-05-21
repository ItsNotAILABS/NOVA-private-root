/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Product Lifecycle Worker (GOK-PRODUCT-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-PRODUCT-001
 * Kernel Family:  PRODUCT_LIFECYCLE
 * Architecture:   Product Registry × Lifecycle FSM × Feature Flags × Release Mgmt
 *
 * Manages the full lifecycle of NOVA products from ideation through sunset.
 * Tracks product metadata, version history, feature flags, dependencies,
 * and health metrics across the organism's portfolio.
 *
 * Features:
 *   • Product registry with name, version, status, features, dependencies
 *   • Lifecycle FSM: IDEA → DESIGN → BUILD → TEST → LAUNCH → MAINTAIN → SUNSET
 *   • Per-product feature flag toggles
 *   • Release management with semver bumping and changelog generation
 *   • 15+ pre-registered NOVA products
 *   • Product health scoring with φ-weighted metrics
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'register-product', product }
 *   Main → Worker: { type: 'update-lifecycle', id, stage }
 *   Main → Worker: { type: 'add-feature', id, feature }
 *   Main → Worker: { type: 'release', id, bump }
 *   Main → Worker: { type: 'list-products' }
 *   Main → Worker: { type: 'product-health', id }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
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

var KERNEL_ID      = 'GOK-PRODUCT-001';
var KERNEL_FAMILY  = 'PRODUCT_LIFECYCLE';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;

var LIFECYCLE_STAGES = ['IDEA', 'DESIGN', 'BUILD', 'TEST', 'LAUNCH', 'MAINTAIN', 'SUNSET'];


/* ════════════════════════════════════════════════════════════════
   PRODUCT REGISTRY
   ════════════════════════════════════════════════════════════════ */

var products = {};


/* ════════════════════════════════════════════════════════════════
   SEMVER UTILITIES
   ════════════════════════════════════════════════════════════════ */

function parseSemver(v) {
  var parts = String(v || '1.0.0').split('.');
  return {
    major: parseInt(parts[0], 10) || 0,
    minor: parseInt(parts[1], 10) || 0,
    patch: parseInt(parts[2], 10) || 0
  };
}

function bumpVersion(version, bump) {
  var sv = parseSemver(version);
  if (bump === 'major') { sv.major++; sv.minor = 0; sv.patch = 0; }
  else if (bump === 'minor') { sv.minor++; sv.patch = 0; }
  else { sv.patch++; }
  return sv.major + '.' + sv.minor + '.' + sv.patch;
}


/* ════════════════════════════════════════════════════════════════
   PRODUCT MANAGEMENT
   ════════════════════════════════════════════════════════════════ */

/**
 * Register a new product in the registry.
 */
function registerProduct(product) {
  var id = product.id || ('prod-' + Date.now());
  var entry = {
    id: id,
    name: product.name || id,
    version: product.version || '1.0.0',
    stage: product.stage || 'IDEA',
    features: product.features || {},
    dependencies: product.dependencies || [],
    description: product.description || '',
    category: product.category || 'general',
    changelog: product.changelog || [],
    releases: product.releases || [],
    createdAt: Date.now(),
    updatedAt: Date.now(),
    health: 1.0
  };
  products[id] = entry;
  return entry;
}

/**
 * Advance or set lifecycle stage for a product.
 */
function updateLifecycle(id, stage) {
  if (!products[id]) return { error: 'Product not found: ' + id };
  var idx = LIFECYCLE_STAGES.indexOf(stage);
  if (idx === -1) return { error: 'Invalid stage: ' + stage };
  var prev = products[id].stage;
  products[id].stage = stage;
  products[id].updatedAt = Date.now();
  products[id].changelog.push({
    type: 'lifecycle',
    from: prev,
    to: stage,
    timestamp: Date.now()
  });
  return { id: id, previousStage: prev, newStage: stage };
}

/**
 * Add or toggle a feature flag on a product.
 */
function addFeature(id, featureName, enabled) {
  if (!products[id]) return { error: 'Product not found: ' + id };
  var isEnabled = (enabled !== undefined) ? !!enabled : true;
  products[id].features[featureName] = isEnabled;
  products[id].updatedAt = Date.now();
  products[id].changelog.push({
    type: 'feature',
    feature: featureName,
    enabled: isEnabled,
    timestamp: Date.now()
  });
  return { id: id, feature: featureName, enabled: isEnabled, totalFeatures: Object.keys(products[id].features).length };
}

/**
 * Create a release for a product with version bump.
 */
function releaseProduct(id, bump) {
  if (!products[id]) return { error: 'Product not found: ' + id };
  var oldVersion = products[id].version;
  var newVersion = bumpVersion(oldVersion, bump || 'patch');
  var release = {
    version: newVersion,
    previousVersion: oldVersion,
    timestamp: Date.now(),
    stage: products[id].stage,
    features: Object.keys(products[id].features).filter(function(f) { return products[id].features[f]; }),
    changelogEntries: products[id].changelog.length
  };
  products[id].version = newVersion;
  products[id].releases.push(release);
  products[id].updatedAt = Date.now();
  products[id].changelog.push({
    type: 'release',
    version: newVersion,
    bump: bump || 'patch',
    timestamp: Date.now()
  });
  return release;
}

/**
 * Calculate product health score using φ-weighted factors.
 */
function productHealth(id) {
  if (!products[id]) return { error: 'Product not found: ' + id };
  var p = products[id];
  var stageIdx = LIFECYCLE_STAGES.indexOf(p.stage);
  var stageScore = (stageIdx >= 0) ? (stageIdx + 1) / LIFECYCLE_STAGES.length : 0.5;
  var featureCount = Object.keys(p.features).length;
  var enabledCount = 0;
  var fkeys = Object.keys(p.features);
  for (var i = 0; i < fkeys.length; i++) {
    if (p.features[fkeys[i]]) enabledCount++;
  }
  var featureRatio = featureCount > 0 ? enabledCount / featureCount : 1.0;
  var releaseScore = Math.min(p.releases.length / 5, 1.0);
  var ageDays = (Date.now() - p.createdAt) / 86400000;
  var freshnessScore = 1.0 / (1.0 + ageDays * PHI_INV * 0.01);
  var health = (stageScore * PHI + featureRatio + releaseScore * PHI_INV + freshnessScore) / (PHI + 1 + PHI_INV + 1);
  p.health = Math.round(health * 1000) / 1000;
  return {
    id: id,
    name: p.name,
    health: p.health,
    stage: p.stage,
    stageScore: Math.round(stageScore * 1000) / 1000,
    featureRatio: Math.round(featureRatio * 1000) / 1000,
    releaseScore: Math.round(releaseScore * 1000) / 1000,
    freshnessScore: Math.round(freshnessScore * 1000) / 1000,
    version: p.version,
    releaseCount: p.releases.length
  };
}


/* ════════════════════════════════════════════════════════════════
   PRE-REGISTERED NOVA PRODUCTS
   ════════════════════════════════════════════════════════════════ */

var NOVA_PRODUCTS = [
  { id: 'nova-browser-ext',      name: 'NOVA Browser Extension',        category: 'extension',  stage: 'LAUNCH',   features: { tabCapture: true, aiAssist: true, darkMode: true } },
  { id: 'nova-dev-tools',        name: 'NOVA Developer Tools',          category: 'extension',  stage: 'BUILD',    features: { inspector: true, profiler: true } },
  { id: 'nova-sdk-js',           name: 'NOVA JavaScript SDK',           category: 'sdk',        stage: 'LAUNCH',   features: { agentAPI: true, streaming: true, plugins: true } },
  { id: 'nova-sdk-python',       name: 'NOVA Python SDK',               category: 'sdk',        stage: 'DESIGN',   features: { asyncSupport: true } },
  { id: 'nova-sdk-rust',         name: 'NOVA Rust SDK',                 category: 'sdk',        stage: 'IDEA',     features: {} },
  { id: 'nova-canister-brain',   name: 'Swarm Brain Canister',          category: 'canister',   stage: 'MAINTAIN', features: { moduleGraph: true, reasoning: true, consensus: true } },
  { id: 'nova-canister-organism',name: 'Swarm Organism Canister',       category: 'canister',   stage: 'MAINTAIN', features: { orchestration: true, stateSync: true } },
  { id: 'nova-terminal',         name: 'NOVA Terminal',                 category: 'terminal',   stage: 'BUILD',    features: { repl: true, themes: true } },
  { id: 'nova-terminal-mobile',  name: 'NOVA Mobile Terminal',          category: 'terminal',   stage: 'DESIGN',   features: { touch: true } },
  { id: 'nova-landing',          name: 'NOVA Landing Page',             category: 'web',        stage: 'LAUNCH',   features: { animations: true, download: true } },
  { id: 'nova-docs-site',        name: 'NOVA Documentation Site',       category: 'web',        stage: 'BUILD',    features: { search: true, versioning: true } },
  { id: 'nova-api-gateway',      name: 'NOVA API Gateway',              category: 'service',    stage: 'TEST',     features: { rateLimit: true, auth: true, logging: true } },
  { id: 'nova-auth-service',     name: 'NOVA Auth Service',             category: 'service',    stage: 'LAUNCH',   features: { iiAuth: true, sessions: true } },
  { id: 'nova-analytics-dash',   name: 'NOVA Analytics Dashboard',      category: 'web',        stage: 'DESIGN',   features: { charts: true } },
  { id: 'nova-marketplace',      name: 'NOVA Extension Marketplace',    category: 'web',        stage: 'IDEA',     features: {} },
  { id: 'nova-cli',              name: 'NOVA CLI Tool',                 category: 'tool',       stage: 'BUILD',    features: { deploy: true, check: true, build: true } },
  { id: 'nova-sacred-geo',       name: 'Sacred Geometry Engine',        category: 'engine',     stage: 'MAINTAIN', features: { phiHarmonics: true, fractal: true } }
];

for (var pi = 0; pi < NOVA_PRODUCTS.length; pi++) {
  registerProduct(NOVA_PRODUCTS[pi]);
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'register-product': {
      var rp = registerProduct(msg.product || msg);
      self.postMessage({
        type: 'product-registered',
        id: rp.id,
        name: rp.name,
        version: rp.version,
        stage: rp.stage,
        totalProducts: Object.keys(products).length,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'update-lifecycle': {
      var ul = updateLifecycle(msg.id, msg.stage);
      self.postMessage({
        type: 'lifecycle-updated',
        id: msg.id,
        previousStage: ul.previousStage || null,
        newStage: ul.newStage || null,
        error: ul.error || null,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'add-feature': {
      var af = addFeature(msg.id, msg.feature, msg.enabled);
      self.postMessage({
        type: 'feature-added',
        id: msg.id,
        feature: af.feature || null,
        enabled: af.enabled,
        totalFeatures: af.totalFeatures || 0,
        error: af.error || null,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'release': {
      var rel = releaseProduct(msg.id, msg.bump);
      self.postMessage({
        type: 'released',
        id: msg.id,
        version: rel.version || null,
        previousVersion: rel.previousVersion || null,
        features: rel.features || [],
        error: rel.error || null,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'list-products': {
      var list = [];
      var pids = Object.keys(products);
      for (var lp = 0; lp < pids.length; lp++) {
        var pr = products[pids[lp]];
        list.push({
          id: pr.id,
          name: pr.name,
          version: pr.version,
          stage: pr.stage,
          category: pr.category,
          featureCount: Object.keys(pr.features).length,
          releaseCount: pr.releases.length,
          health: pr.health
        });
      }
      self.postMessage({
        type: 'product-list',
        products: list,
        count: list.length,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'product-health': {
      var ph = productHealth(msg.id);
      self.postMessage({
        type: 'health-report',
        report: ph,
        error: ph.error || null,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'status',
        kernelId: KERNEL_ID,
        family: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalProducts: Object.keys(products).length,
        lifecycleStages: LIFECYCLE_STAGES,
        beat: beatCount,
        phase: kernelPhase,
        phi: PHI
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
    totalProducts: Object.keys(products).length
  });
}, HEARTBEAT);
