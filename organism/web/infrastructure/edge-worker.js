// ═══════════════════════════════════════════════════════════════════════════════
// OPERATOR MARGINIS — Edge Deployment Service Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// Phone-edge PWA service worker: offline caching, frequency-band routing,
// Shannon-capacity signal channel management, background sync,
// push notification stubs, and φ-pulsed autonomous heartbeat.
// Runs as a Service Worker — no DOM, no imports, installable to phone home screen.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env serviceworker */
'use strict';

// ─── MATH CONSTANTS (First Principles) ──────────────────────────────────────────
var PHI            = 1.618033988749895;                  // Golden Ratio — Fibonacci limit
var INV_PHI        = 0.618033988749895;                  // 1/φ = φ − 1
var TAU            = 6.283185307179586;                  // 2π
var SCHUMANN       = 7.83;                               // Schumann resonance (Hz)
var GOLDEN_PULSE   = 618;                                // φ × 1000 ms, truncated
var HEARTBEAT_MS   = 873;                                // φ² × 333 ≈ 873ms
var PLANCK         = 6.62607015e-34;                     // Planck constant (J·s) — NIST
var BOLTZMANN      = 1.380649e-23;                       // Boltzmann constant (J/K) — NIST
var AVOGADRO       = 6.02214076e23;                      // Avogadro (mol⁻¹) — NIST
var SPEED_OF_LIGHT = 299792458;                          // c (m/s) — NIST
var SHANNON_BIT    = Math.log(2);                        // 1 bit = ln(2) nats
var NYQUIST_FACTOR = 2;                                  // Nyquist sampling theorem

// ─── CACHE CONFIG ───────────────────────────────────────────────────────────────
var CACHE_NAME     = 'nova-edge-v1';
var EDGE_ASSETS    = [
  './',
  './edge-deploy.html',
  './edge-worker.js',
];

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
var MiniHeart = {
  bpm:           72,
  phase:         0,
  kuramotoOrder: 0.95,
  amplitude:     0.8,
  health:        95,
  lastBeat:      0,
  beatCount:     0,
};

// ─── MINI BRAIN — LIF Neuron Ensemble ───────────────────────────────────────────
var MiniBrain = {
  regions: [
    { name: 'cacher',     activation: 0.5, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'router',     activation: 0.4, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'signalProc', activation: 0.6, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'syncEngine', activation: 0.3, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
    { name: 'freqAnalyzer',activation:0.5, threshold: -55, membrane: -70, restPotential: -70, spikes: 0 },
  ],
  chemicals: [
    { name: 'dopamine',      level: 0.5, decay: 0.02,  production: 0.03 },
    { name: 'serotonin',     level: 0.5, decay: 0.015, production: 0.025 },
    { name: 'acetylcholine', level: 0.5, decay: 0.01,  production: 0.02 },
  ],
  coherenceField: 0.8,
  thoughtCount:   0,
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
var tickCount       = 0;
var cacheHits       = 0;
var cacheMisses     = 0;
var offlineServes   = 0;
var syncQueue       = [];
var phoneFleet      = [];
var edgeNodes       = [];
var totalBytesServed = 0;

// ═══════════════════════════════════════════════════════════════════════════════
// FREQUENCY BAND ENGINE — 12 bands from Schumann to 5G mmWave
// Each band has: center frequency, bandwidth, noise floor, modulation,
// and Shannon capacity computed from first principles.
// ═══════════════════════════════════════════════════════════════════════════════
var FREQUENCY_BANDS = [
  // Extremely Low / Resonance
  { id: 'SCHUMANN',   name: 'Schumann Resonance',  centerHz: 7.83,           bandwidthHz: 1,           noiseFloorDbm: -120, modulation: 'natural',   domain: 'earth' },
  { id: 'PHI_PULSE',  name: 'φ-Pulse',             centerHz: PHI,            bandwidthHz: 0.5,         noiseFloorDbm: -110, modulation: 'kuramoto',  domain: 'organism' },
  { id: 'THETA',      name: 'Theta Brain Wave',     centerHz: 6.0,            bandwidthHz: 4,           noiseFloorDbm: -100, modulation: 'neural',    domain: 'brain' },
  { id: 'ALPHA',      name: 'Alpha Brain Wave',     centerHz: 10.5,           bandwidthHz: 4,           noiseFloorDbm: -95,  modulation: 'neural',    domain: 'brain' },
  // Communication
  { id: 'WIFI_24',    name: 'WiFi 2.4 GHz',         centerHz: 2.4e9,          bandwidthHz: 20e6,        noiseFloorDbm: -90,  modulation: 'OFDM',      domain: 'local' },
  { id: 'WIFI_5',     name: 'WiFi 5 GHz',           centerHz: 5.0e9,          bandwidthHz: 40e6,        noiseFloorDbm: -88,  modulation: 'OFDM',      domain: 'local' },
  { id: 'WIFI_6E',    name: 'WiFi 6E (6 GHz)',      centerHz: 6.0e9,          bandwidthHz: 160e6,       noiseFloorDbm: -85,  modulation: 'OFDMA',     domain: 'local' },
  { id: 'BLE',        name: 'Bluetooth LE',          centerHz: 2.402e9,        bandwidthHz: 2e6,         noiseFloorDbm: -97,  modulation: 'GFSK',      domain: 'proximity' },
  // Cellular
  { id: 'LTE',        name: 'LTE Band 7',           centerHz: 2.6e9,          bandwidthHz: 20e6,        noiseFloorDbm: -100, modulation: 'OFDMA',     domain: 'cellular' },
  { id: '5G_SUB6',    name: '5G Sub-6 GHz',         centerHz: 3.5e9,          bandwidthHz: 100e6,       noiseFloorDbm: -95,  modulation: 'OFDMA',     domain: 'cellular' },
  { id: '5G_MMWAVE',  name: '5G mmWave',            centerHz: 28e9,           bandwidthHz: 400e6,       noiseFloorDbm: -80,  modulation: 'OFDMA',     domain: 'cellular' },
  // Sovereign
  { id: 'SOVEREIGN',  name: 'Sovereign Mesh',       centerHz: 915e6,          bandwidthHz: 500e3,       noiseFloorDbm: -105, modulation: 'LoRa',      domain: 'sovereign' },
];

// ═══════════════════════════════════════════════════════════════════════════════
// SIGNAL CHANNEL ENGINE — 5 channels with SNR, Shannon capacity,
// φ-weighted priority, and modulation depth.
//
// INFORMATION-THEORETIC THROUGHPUT (Shannon):
//   C = B × log₂(1 + SNR)
//   where B = bandwidth (Hz), SNR = signal-to-noise ratio (linear)
//   SNR_linear = 10^(SNR_dB / 10)
//
// This is the *theoretical maximum* bits/second through any channel.
// Real systems achieve 50-80% of Shannon capacity.
// ═══════════════════════════════════════════════════════════════════════════════
var SIGNAL_CHANNELS = [
  { id: 'PRIMARY',    name: 'Primary Uplink',    band: 'WIFI_24',   txPowerDbm: 20,  snrDb: 30,  phiWeight: PHI,        priority: 1 },
  { id: 'SECONDARY',  name: 'Secondary Link',    band: '5G_SUB6',   txPowerDbm: 23,  snrDb: 25,  phiWeight: INV_PHI,    priority: 2 },
  { id: 'MESH',       name: 'Mesh Relay',        band: 'BLE',       txPowerDbm: 4,   snrDb: 15,  phiWeight: 1.0,        priority: 3 },
  { id: 'SOVEREIGN',  name: 'Sovereign Channel', band: 'SOVEREIGN', txPowerDbm: 14,  snrDb: 20,  phiWeight: PHI * PHI,  priority: 4 },
  { id: 'FALLBACK',   name: 'Fallback / Cache',  band: 'LTE',       txPowerDbm: 23,  snrDb: 18,  phiWeight: INV_PHI * INV_PHI, priority: 5 },
];

// ─── SHANNON CAPACITY CALCULATOR ────────────────────────────────────────────────
// C = B × log₂(1 + S/N)  — Claude Shannon, "A Mathematical Theory of Communication" (1948)
function shannonCapacity(bandwidthHz, snrDb) {
  var snrLinear = Math.pow(10, snrDb / 10);
  return bandwidthHz * Math.log2(1 + snrLinear);
}

// ─── SPECTRAL EFFICIENCY ────────────────────────────────────────────────────────
// η = C / B = log₂(1 + SNR) bits/s/Hz
function spectralEfficiency(snrDb) {
  var snrLinear = Math.pow(10, snrDb / 10);
  return Math.log2(1 + snrLinear);
}

// ─── CHANNEL CAPACITY REPORT ────────────────────────────────────────────────────
function computeChannelCapacities() {
  var report = [];
  for (var i = 0; i < SIGNAL_CHANNELS.length; i++) {
    var ch = SIGNAL_CHANNELS[i];
    var band = null;
    for (var b = 0; b < FREQUENCY_BANDS.length; b++) {
      if (FREQUENCY_BANDS[b].id === ch.band) { band = FREQUENCY_BANDS[b]; break; }
    }
    if (!band) continue;

    var capBps     = shannonCapacity(band.bandwidthHz, ch.snrDb);
    var capMbps    = capBps / 1e6;
    var eta        = spectralEfficiency(ch.snrDb);
    var realMbps   = capMbps * 0.65;  // 65% efficiency factor (real-world)
    var latencyMs  = 1000 / (capBps / (1500 * 8)); // time to send 1 MTU

    report.push({
      channel:         ch.name,
      band:            band.name,
      bandwidthHz:     band.bandwidthHz,
      snrDb:           ch.snrDb,
      shannonCapMbps:  Math.round(capMbps * 100) / 100,
      realThroughputMbps: Math.round(realMbps * 100) / 100,
      spectralEff:     Math.round(eta * 1000) / 1000,
      latencyMs:       Math.round(latencyMs * 1000) / 1000,
      phiWeight:       ch.phiWeight,
      modulation:      band.modulation,
      domain:          band.domain,
    });
  }
  return report;
}

// ─── FREQUENCY REPORT ───────────────────────────────────────────────────────────
function computeFrequencyReport() {
  var bands = [];
  for (var i = 0; i < FREQUENCY_BANDS.length; i++) {
    var b = FREQUENCY_BANDS[i];
    var cap = shannonCapacity(b.bandwidthHz, -b.noiseFloorDbm - 10); // assume signal 10dB above noise
    bands.push({
      id:            b.id,
      name:          b.name,
      centerHz:      b.centerHz,
      bandwidthHz:   b.bandwidthHz,
      noiseFloorDbm: b.noiseFloorDbm,
      modulation:    b.modulation,
      domain:        b.domain,
      wavelengthM:   SPEED_OF_LIGHT / b.centerHz,
      shannonCapBps: Math.round(cap),
      nyquistRate:   b.bandwidthHz * NYQUIST_FACTOR,
    });
  }
  return { bands: bands, channels: computeChannelCapacities(), timestamp: Date.now() };
}

// ═══════════════════════════════════════════════════════════════════════════════
// EDGE NODE REGISTRY — track deployed phone endpoints
// ═══════════════════════════════════════════════════════════════════════════════
var nextNodeId = 1;

function registerEdgeNode(info) {
  var node = {
    id:          'EDGE-' + (nextNodeId++),
    type:        info.type || 'phone',
    platform:    info.platform || 'unknown',
    userAgent:   info.userAgent || '',
    registeredAt: Date.now(),
    lastSeen:    Date.now(),
    status:      'ONLINE',
    cacheSize:   0,
    syncPending: 0,
    heartbeats:  0,
    shannonCap:  0,
    signalStrength: -70,
    phiResonance: PHI,
  };

  // Compute device Shannon capacity estimate
  var bestChannel = computeChannelCapacities()[0];
  if (bestChannel) node.shannonCap = bestChannel.realThroughputMbps;

  edgeNodes.push(node);
  return node;
}

function getEdgeFleet() {
  return {
    nodes:     edgeNodes,
    count:     edgeNodes.length,
    onlineCount: edgeNodes.filter(function(n) { return n.status === 'ONLINE'; }).length,
    totalHeartbeats: edgeNodes.reduce(function(s, n) { return s + n.heartbeats; }, 0),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PWA MANIFEST GENERATOR — creates installable app manifest for phone deploy
// ═══════════════════════════════════════════════════════════════════════════════
function generatePWAManifest(productName, productId) {
  return {
    name:             productName || 'NOVA Edge',
    short_name:       (productId || 'NOVA').substring(0, 12),
    description:      'NOVA Edge-Deployed AI Product — sovereign, offline-capable, φ-pulsed',
    start_url:        './edge-deploy.html',
    display:          'standalone',
    orientation:      'portrait',
    background_color: '#050a14',
    theme_color:      '#00ff88',
    categories:       ['productivity', 'utilities'],
    icons: [
      { src: 'data:image/svg+xml,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 192 192"><rect width="192" height="192" rx="32" fill="#050a14"/><text x="96" y="120" text-anchor="middle" fill="#00ff88" font-size="80" font-family="monospace">N</text></svg>'), sizes: '192x192', type: 'image/svg+xml' },
      { src: 'data:image/svg+xml,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><rect width="512" height="512" rx="64" fill="#050a14"/><text x="256" y="320" text-anchor="middle" fill="#00ff88" font-size="240" font-family="monospace">N</text></svg>'), sizes: '512x512', type: 'image/svg+xml' },
    ],
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// TICK DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════
function tickHeart() {
  var h = MiniHeart;
  h.phase = (h.phase + PHI * TAU / 1000 * GOLDEN_PULSE) % TAU;
  h.amplitude = 0.5 + 0.5 * Math.sin(h.phase);
  h.bpm = Math.round(60 + h.amplitude * 40 * PHI);
  h.kuramotoOrder = h.kuramotoOrder * 0.99 + 0.01 * (0.5 + 0.5 * Math.cos(h.phase));
  h.beatCount++;
  h.lastBeat = Date.now();
  h.health = h.health * 0.98 + 95 * 0.02;
}

function tickBrain() {
  var b = MiniBrain;
  for (var c = 0; c < b.chemicals.length; c++) {
    var chem = b.chemicals[c];
    chem.level = chem.level * (1 - chem.decay) + chem.production;
    if (chem.level > 1) chem.level = 1;
    if (chem.level < 0) chem.level = 0;
  }
  var drive = 0;
  for (var ci = 0; ci < b.chemicals.length; ci++) drive += b.chemicals[ci].level;
  drive = drive / b.chemicals.length;
  for (var r = 0; r < b.regions.length; r++) {
    var reg = b.regions[r];
    reg.membrane += (reg.restPotential - reg.membrane) * 0.1 + drive * PHI;
    reg.activation = 1 / (1 + Math.exp(-(reg.membrane + 55) * 0.2));
    if (reg.membrane > reg.threshold) {
      reg.spikes++;
      reg.membrane = reg.restPotential;
      b.thoughtCount++;
    }
  }
  var phaseSum = 0;
  for (var ri = 0; ri < b.regions.length; ri++) phaseSum += b.regions[ri].activation;
  b.coherenceField = phaseSum / b.regions.length;
}

// ─── FNV-1a HASH (32-bit) ──────────────────────────────────────────────────────
function fnv1a(str) {
  var hash = 0x811c9dc5;
  for (var i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193);
  }
  return (hash >>> 0);
}

// ═══════════════════════════════════════════════════════════════════════════════
// SERVICE WORKER LIFECYCLE — Install, Activate, Fetch
// ═══════════════════════════════════════════════════════════════════════════════

// ─── INSTALL — pre-cache core assets ────────────────────────────────────────────
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.addAll(EDGE_ASSETS);
    }).then(function() {
      return self.skipWaiting();
    })
  );
});

// ─── ACTIVATE — claim all clients, clean old caches ─────────────────────────────
self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.filter(function(name) {
          return name !== CACHE_NAME;
        }).map(function(name) {
          return caches.delete(name);
        })
      );
    }).then(function() {
      return self.clients.claim();
    })
  );
});

// ─── FETCH — cache-first for assets, network-first for API ──────────────────────
self.addEventListener('fetch', function(event) {
  var url = new URL(event.request.url);

  // API requests: network-first with cache fallback
  if (url.pathname.indexOf('/api/') !== -1) {
    event.respondWith(
      fetch(event.request).then(function(response) {
        cacheHits++;
        return response;
      }).catch(function() {
        cacheMisses++;
        offlineServes++;
        return caches.match(event.request);
      })
    );
    return;
  }

  // Static assets: cache-first
  event.respondWith(
    caches.match(event.request).then(function(cached) {
      if (cached) {
        cacheHits++;
        return cached;
      }
      cacheMisses++;
      return fetch(event.request).then(function(response) {
        if (response && response.status === 200) {
          var clone = response.clone();
          caches.open(CACHE_NAME).then(function(cache) {
            cache.put(event.request, clone);
          });
        }
        return response;
      }).catch(function() {
        offlineServes++;
        // Return offline page for navigation requests
        if (event.request.mode === 'navigate') {
          return caches.match('./edge-deploy.html');
        }
        return new Response('offline', { status: 503 });
      });
    })
  );
});

// ═══════════════════════════════════════════════════════════════════════════════
// MESSAGE HANDLER — commands from the main page
// ═══════════════════════════════════════════════════════════════════════════════
self.addEventListener('message', function(event) {
  var data = event.data || {};
  var cmd = data.cmd;
  var port = event.ports && event.ports[0];
  var respond = function(msg) {
    if (port) port.postMessage(msg);
    else if (event.source) event.source.postMessage(msg);
  };

  switch (cmd) {
    case 'GET_STATUS':
      respond({
        cmd: cmd,
        status: {
          worker: 'OPERATOR_MARGINIS',
          version: '1.0.0',
          tickCount: tickCount,
          cacheHits: cacheHits,
          cacheMisses: cacheMisses,
          offlineServes: offlineServes,
          totalBytesServed: totalBytesServed,
          edgeNodes: edgeNodes.length,
          heart: {
            bpm: MiniHeart.bpm, phase: MiniHeart.phase, health: MiniHeart.health,
            kuramotoOrder: MiniHeart.kuramotoOrder, amplitude: MiniHeart.amplitude,
            beatCount: MiniHeart.beatCount,
          },
          brain: {
            coherenceField: MiniBrain.coherenceField, thoughtCount: MiniBrain.thoughtCount,
            regions: MiniBrain.regions.map(function(r) { return { name: r.name, activation: r.activation, spikes: r.spikes }; }),
          },
        },
      });
      break;

    case 'GET_FREQUENCY_REPORT':
      respond({ cmd: cmd, report: computeFrequencyReport() });
      break;

    case 'GET_CHANNEL_CAPACITIES':
      respond({ cmd: cmd, channels: computeChannelCapacities() });
      break;

    case 'REGISTER_EDGE_NODE':
      respond({ cmd: cmd, node: registerEdgeNode(data.info || {}) });
      break;

    case 'GET_EDGE_FLEET':
      respond({ cmd: cmd, fleet: getEdgeFleet() });
      break;

    case 'GENERATE_MANIFEST':
      respond({ cmd: cmd, manifest: generatePWAManifest(data.name, data.id) });
      break;

    case 'GET_BANDS':
      respond({ cmd: cmd, bands: FREQUENCY_BANDS });
      break;

    case 'GET_SIGNALS':
      respond({ cmd: cmd, signals: SIGNAL_CHANNELS });
      break;

    case 'SYNC_QUEUE':
      syncQueue.push({ data: data.payload, timestamp: Date.now() });
      respond({ cmd: cmd, queued: syncQueue.length });
      break;

    default:
      respond({ cmd: cmd, error: 'Unknown command: ' + cmd });
  }
});

// ═══════════════════════════════════════════════════════════════════════════════
// HEARTBEAT — autonomous φ-pulsed tick
// ═══════════════════════════════════════════════════════════════════════════════
setInterval(function() {
  tickCount++;
  tickHeart();
  tickBrain();

  // Broadcast heartbeat to all clients
  self.clients.matchAll().then(function(clients) {
    var msg = {
      type: 'HEARTBEAT',
      worker: 'OPERATOR_MARGINIS',
      tick: tickCount,
      heart: {
        bpm: MiniHeart.bpm, phase: MiniHeart.phase, health: MiniHeart.health,
        kuramotoOrder: MiniHeart.kuramotoOrder, amplitude: MiniHeart.amplitude,
      },
      brain: {
        coherenceField: MiniBrain.coherenceField, thoughtCount: MiniBrain.thoughtCount,
      },
      cache: { hits: cacheHits, misses: cacheMisses, offlineServes: offlineServes },
      edgeNodes: edgeNodes.length,
    };
    for (var i = 0; i < clients.length; i++) {
      clients[i].postMessage(msg);
    }
  });
}, HEARTBEAT_MS);
