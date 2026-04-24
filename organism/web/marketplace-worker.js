/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Marketplace Worker (GOK-MARKETPLACE-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-MARKETPLACE-001
 * Kernel Family:  DISTRIBUTION
 * Architecture:   Extension Marketplace × Distribution Channels × Reviews × Updates
 *
 * Extension marketplace for the NOVA organism. Lists, searches, and manages
 * browser extensions across distribution channels. Tracks reviews, ratings,
 * trust scores, and update notifications for 26 pre-listed extensions.
 *
 * Features:
 *   • Extension listing with search, filter, and sort
 *   • Distribution channels: Chrome Web Store, Edge Add-ons, Firefox, direct
 *   • Update management with version checking
 *   • Review system with ratings, reviews, and trust scores
 *   • 26 pre-listed NOVA extensions
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'list-extensions', filter }
 *   Main → Worker: { type: 'search', query }
 *   Main → Worker: { type: 'check-updates', extensionId }
 *   Main → Worker: { type: 'add-review', extensionId, review }
 *   Main → Worker: { type: 'distribution-status', extensionId }
 *   Main → Worker: { type: 'publish', extensionId, channel }
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

var KERNEL_ID      = 'GOK-MARKETPLACE-001';
var KERNEL_FAMILY  = 'DISTRIBUTION';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;

var CHANNELS = ['chrome', 'edge', 'firefox', 'direct'];


/* ════════════════════════════════════════════════════════════════
   EXTENSION REGISTRY — 26 Pre-listed NOVA Extensions
   ════════════════════════════════════════════════════════════════ */

var extensions = {};
var reviews = {};

var EXTENSION_CATALOG = [
  { id: 'nova-ai-assistant',        name: 'NOVA AI Assistant',               category: 'productivity', version: '2.1.0', channels: ['chrome', 'edge', 'firefox'] },
  { id: 'nova-tab-manager',         name: 'NOVA Tab Manager',               category: 'productivity', version: '1.4.0', channels: ['chrome', 'edge'] },
  { id: 'nova-dark-mode',           name: 'NOVA Dark Mode',                 category: 'appearance',   version: '1.2.0', channels: ['chrome', 'edge', 'firefox'] },
  { id: 'nova-password-vault',      name: 'NOVA Password Vault',            category: 'security',     version: '1.0.0', channels: ['chrome'] },
  { id: 'nova-ad-shield',           name: 'NOVA Ad Shield',                 category: 'security',     version: '1.3.0', channels: ['chrome', 'firefox'] },
  { id: 'nova-screenshot',          name: 'NOVA Screenshot Pro',            category: 'utility',      version: '1.1.0', channels: ['chrome', 'edge'] },
  { id: 'nova-bookmark-sync',       name: 'NOVA Bookmark Sync',             category: 'productivity', version: '1.0.0', channels: ['chrome', 'edge', 'firefox'] },
  { id: 'nova-reading-mode',        name: 'NOVA Reading Mode',              category: 'appearance',   version: '1.5.0', channels: ['chrome', 'firefox'] },
  { id: 'nova-dev-inspector',       name: 'NOVA Dev Inspector',             category: 'developer',    version: '2.0.0', channels: ['chrome'] },
  { id: 'nova-api-tester',          name: 'NOVA API Tester',                category: 'developer',    version: '1.2.0', channels: ['chrome', 'edge'] },
  { id: 'nova-json-viewer',         name: 'NOVA JSON Viewer',               category: 'developer',    version: '1.0.0', channels: ['chrome', 'edge', 'firefox'] },
  { id: 'nova-color-picker',        name: 'NOVA Color Picker',              category: 'developer',    version: '1.1.0', channels: ['chrome'] },
  { id: 'nova-focus-timer',         name: 'NOVA Focus Timer',               category: 'productivity', version: '1.3.0', channels: ['chrome', 'edge'] },
  { id: 'nova-clipboard-mgr',       name: 'NOVA Clipboard Manager',         category: 'utility',      version: '1.0.0', channels: ['chrome'] },
  { id: 'nova-translate',           name: 'NOVA Translate',                 category: 'language',     version: '1.4.0', channels: ['chrome', 'edge', 'firefox'] },
  { id: 'nova-grammar-check',       name: 'NOVA Grammar Check',             category: 'language',     version: '1.1.0', channels: ['chrome'] },
  { id: 'nova-web3-wallet',         name: 'NOVA Web3 Wallet',               category: 'blockchain',   version: '1.0.0', channels: ['chrome', 'firefox'] },
  { id: 'nova-icp-toolkit',         name: 'NOVA ICP Toolkit',               category: 'blockchain',   version: '1.2.0', channels: ['chrome'] },
  { id: 'nova-nft-gallery',         name: 'NOVA NFT Gallery',               category: 'blockchain',   version: '1.0.0', channels: ['chrome'] },
  { id: 'nova-email-tracker',       name: 'NOVA Email Tracker',             category: 'productivity', version: '1.1.0', channels: ['chrome', 'edge'] },
  { id: 'nova-video-downloader',    name: 'NOVA Video Downloader',          category: 'media',        version: '1.3.0', channels: ['chrome', 'firefox'] },
  { id: 'nova-audio-equalizer',     name: 'NOVA Audio Equalizer',           category: 'media',        version: '1.0.0', channels: ['chrome'] },
  { id: 'nova-privacy-guard',       name: 'NOVA Privacy Guard',             category: 'security',     version: '1.2.0', channels: ['chrome', 'edge', 'firefox'] },
  { id: 'nova-session-manager',     name: 'NOVA Session Manager',           category: 'productivity', version: '1.0.0', channels: ['chrome'] },
  { id: 'nova-speed-dial',          name: 'NOVA Speed Dial',                category: 'appearance',   version: '1.1.0', channels: ['chrome', 'edge'] },
  { id: 'nova-site-blocker',        name: 'NOVA Site Blocker',              category: 'productivity', version: '1.0.0', channels: ['chrome', 'firefox'] }
];

// Bootstrap extensions
for (var ei = 0; ei < EXTENSION_CATALOG.length; ei++) {
  var ext = EXTENSION_CATALOG[ei];
  extensions[ext.id] = {
    id: ext.id,
    name: ext.name,
    category: ext.category,
    version: ext.version,
    channels: ext.channels,
    publishedChannels: ext.channels.slice(),
    rating: 4.0 + Math.round(Math.random() * 10) / 10,
    reviewCount: 0,
    downloadCount: Math.floor(Math.random() * 50000),
    trustScore: 0.8 + Math.round(Math.random() * 200) / 1000,
    latestVersion: ext.version,
    updatedAt: Date.now(),
    createdAt: Date.now()
  };
  reviews[ext.id] = [];
}


/* ════════════════════════════════════════════════════════════════
   SEARCH & FILTER
   ════════════════════════════════════════════════════════════════ */

/**
 * List extensions with optional filter.
 */
function listExtensions(filter) {
  var ids = Object.keys(extensions);
  var results = [];
  for (var i = 0; i < ids.length; i++) {
    var ext = extensions[ids[i]];
    if (filter) {
      if (filter.category && ext.category !== filter.category) continue;
      if (filter.channel) {
        var hasChannel = false;
        for (var c = 0; c < ext.channels.length; c++) {
          if (ext.channels[c] === filter.channel) { hasChannel = true; break; }
        }
        if (!hasChannel) continue;
      }
      if (filter.minRating && ext.rating < filter.minRating) continue;
    }
    results.push(ext);
  }
  if (filter && filter.sortBy) {
    var key = filter.sortBy;
    results.sort(function(a, b) { return (b[key] || 0) - (a[key] || 0); });
  }
  return results;
}

/**
 * Search extensions by query string.
 */
function searchExtensions(query) {
  var q = (query || '').toLowerCase();
  var ids = Object.keys(extensions);
  var results = [];
  for (var i = 0; i < ids.length; i++) {
    var ext = extensions[ids[i]];
    var score = 0;
    if (ext.name.toLowerCase().indexOf(q) !== -1) score += 3;
    if (ext.id.toLowerCase().indexOf(q) !== -1) score += 2;
    if (ext.category.toLowerCase().indexOf(q) !== -1) score += 1;
    if (score > 0) {
      results.push({ extension: ext, relevance: score * PHI_INV });
    }
  }
  results.sort(function(a, b) { return b.relevance - a.relevance; });
  return results;
}


/* ════════════════════════════════════════════════════════════════
   UPDATE MANAGEMENT
   ════════════════════════════════════════════════════════════════ */

/**
 * Check if an extension has updates available.
 */
function checkUpdates(extensionId) {
  if (!extensions[extensionId]) return { error: 'Extension not found: ' + extensionId };
  var ext = extensions[extensionId];
  var hasUpdate = ext.version !== ext.latestVersion;
  return {
    id: ext.id,
    name: ext.name,
    currentVersion: ext.version,
    latestVersion: ext.latestVersion,
    hasUpdate: hasUpdate,
    channels: ext.publishedChannels
  };
}


/* ════════════════════════════════════════════════════════════════
   REVIEW SYSTEM
   ════════════════════════════════════════════════════════════════ */

/**
 * Add a review for an extension and recalculate rating.
 */
function addReview(extensionId, review) {
  if (!extensions[extensionId]) return { error: 'Extension not found: ' + extensionId };
  var entry = {
    id: 'rev-' + Date.now() + '-' + Math.floor(Math.random() * 10000),
    author: review.author || 'anonymous',
    rating: Math.max(1, Math.min(5, review.rating || 5)),
    text: review.text || '',
    timestamp: Date.now()
  };
  if (!reviews[extensionId]) reviews[extensionId] = [];
  reviews[extensionId].push(entry);
  // Recalculate φ-weighted average rating
  var revs = reviews[extensionId];
  var weightedSum = 0;
  var weightSum = 0;
  for (var i = 0; i < revs.length; i++) {
    var weight = Math.pow(PHI_INV, revs.length - 1 - i);
    weightedSum += revs[i].rating * weight;
    weightSum += weight;
  }
  extensions[extensionId].rating = Math.round(weightedSum / weightSum * 100) / 100;
  extensions[extensionId].reviewCount = revs.length;
  // Update trust score based on review volume and rating
  var trustBase = extensions[extensionId].rating / 5;
  var volumeBonus = Math.min(revs.length / 100, 0.2);
  extensions[extensionId].trustScore = Math.round((trustBase * PHI_INV + volumeBonus + 0.5) * 1000) / 1000;

  return {
    review: entry,
    newRating: extensions[extensionId].rating,
    totalReviews: revs.length,
    trustScore: extensions[extensionId].trustScore
  };
}


/* ════════════════════════════════════════════════════════════════
   DISTRIBUTION & PUBLISHING
   ════════════════════════════════════════════════════════════════ */

/**
 * Get distribution status for an extension.
 */
function distributionStatus(extensionId) {
  if (!extensions[extensionId]) return { error: 'Extension not found: ' + extensionId };
  var ext = extensions[extensionId];
  var channelStatus = [];
  for (var c = 0; c < CHANNELS.length; c++) {
    var published = false;
    for (var p = 0; p < ext.publishedChannels.length; p++) {
      if (ext.publishedChannels[p] === CHANNELS[c]) { published = true; break; }
    }
    channelStatus.push({ channel: CHANNELS[c], published: published });
  }
  return {
    id: ext.id,
    name: ext.name,
    version: ext.version,
    channels: channelStatus,
    downloadCount: ext.downloadCount,
    rating: ext.rating,
    trustScore: ext.trustScore
  };
}

/**
 * Publish an extension to a distribution channel.
 */
function publishExtension(extensionId, channel) {
  if (!extensions[extensionId]) return { error: 'Extension not found: ' + extensionId };
  if (CHANNELS.indexOf(channel) === -1) return { error: 'Invalid channel: ' + channel };
  var ext = extensions[extensionId];
  var already = false;
  for (var i = 0; i < ext.publishedChannels.length; i++) {
    if (ext.publishedChannels[i] === channel) { already = true; break; }
  }
  if (!already) {
    ext.publishedChannels.push(channel);
    ext.channels.push(channel);
  }
  ext.updatedAt = Date.now();
  return {
    id: ext.id,
    name: ext.name,
    channel: channel,
    alreadyPublished: already,
    totalChannels: ext.publishedChannels.length
  };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'list-extensions': {
      var list = listExtensions(msg.filter);
      self.postMessage({
        type: 'extension-list',
        extensions: list,
        count: list.length,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'search': {
      var results = searchExtensions(msg.query);
      self.postMessage({
        type: 'search-results',
        query: msg.query,
        results: results,
        count: results.length,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'check-updates': {
      var upd = checkUpdates(msg.extensionId);
      self.postMessage({
        type: 'update-check',
        result: upd,
        error: upd.error || null,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'add-review': {
      var rev = addReview(msg.extensionId, msg.review || {});
      self.postMessage({
        type: 'review-added',
        result: rev,
        error: rev.error || null,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'distribution-status': {
      var ds = distributionStatus(msg.extensionId);
      self.postMessage({
        type: 'distribution-report',
        result: ds,
        error: ds.error || null,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'publish': {
      var pub = publishExtension(msg.extensionId, msg.channel);
      self.postMessage({
        type: 'published',
        result: pub,
        error: pub.error || null,
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
        totalExtensions: Object.keys(extensions).length,
        channels: CHANNELS,
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
    totalExtensions: Object.keys(extensions).length
  });
}, HEARTBEAT);
