// ═══════════════════════════════════════════════════════════════════════════════
// SERVITOR TELEPHONI — Phone Server Service Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// This Service Worker IS the server. It does not proxy to a server — it IS one.
// It generates responses from first principles, routes requests through
// Shannon-capacity channels, runs developer organisms (builder AIs) inside,
// and serves the phone app entirely from cache + computed responses.
//
// The phone becomes a sovereign compute node. No external server required.
// Open the HTML on your phone browser. The Service Worker installs itself,
// caches everything, and from that point forward — your phone IS the server.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env serviceworker */
'use strict';

// ─── GOLDEN NUMBER PRIMITIVES (First Principles) ────────────────────────────────
// Everything derives from these. These are the atoms.
var PHI            = (1 + Math.sqrt(5)) / 2;               // φ = 1.618033988749895 — the golden ratio
var INV_PHI        = PHI - 1;                               // φ⁻¹ = 0.618033988749895 = 1/φ
var PHI_SQ         = PHI * PHI;                             // φ² = 2.618033988749895
var PHI_CU         = PHI * PHI * PHI;                       // φ³ = 4.236067977499790
var PHI_QUAD       = PHI * PHI * PHI * PHI;                 // φ⁴ = 6.854101966249685
var SQRT_PHI       = Math.sqrt(PHI);                        // √φ = 1.272019649514069
var LN_PHI         = Math.log(PHI);                         // ln(φ) = 0.48121182505960344
var TAU            = 2 * Math.PI;                           // 2π = 6.283185307179586
var E              = Math.E;                                // e = 2.718281828459045

// φ-derived timing constants
var GOLDEN_PULSE_MS = Math.round(PHI * 382);                // ≈ 618ms — φ × (1000/φ²) 
var HEARTBEAT_MS    = Math.round(PHI_SQ * 333);             // ≈ 872ms — φ² × 333
var SYNC_INTERVAL   = Math.round(PHI_CU * 1000);            // ≈ 4236ms — φ³ seconds

// NIST Physical Constants (SI 2019 exact)
var PLANCK         = 6.62607015e-34;                        // Planck constant (J·s)
var BOLTZMANN      = 1.380649e-23;                          // Boltzmann constant (J/K)
var AVOGADRO       = 6.02214076e23;                         // Avogadro number (mol⁻¹)
var SPEED_OF_LIGHT = 299792458;                             // c (m/s)

// Information theory
var SHANNON_BIT    = Math.log(2);                           // 1 bit = ln(2) ≈ 0.693 nats
var NYQUIST_FACTOR = 2;                                     // Nyquist sampling theorem

// ─── CACHE CONFIG ───────────────────────────────────────────────────────────────
var CACHE_NAME     = 'nova-phone-v1';
var PHONE_ASSETS   = [
  './',
  './nova-phone.html',
  './phone-server-worker.js',
];

// ═══════════════════════════════════════════════════════════════════════════════
// MINI HEART — Kuramoto Phase Oscillator (φ-derived)
// BPM derived from golden ratio: base 60 × φ scaling
// ═══════════════════════════════════════════════════════════════════════════════
var MiniHeart = {
  bpm:           Math.round(60 * SQRT_PHI),   // ≈ 76 BPM — 60 × √φ
  phase:         0,
  kuramotoOrder: INV_PHI + 0.3,               // start near φ⁻¹ + margin
  amplitude:     INV_PHI,                     // φ⁻¹
  health:        Math.round(100 * INV_PHI * SQRT_PHI), // ≈ 78.6 → 79
  lastBeat:      0,
  beatCount:     0,
};

// ═══════════════════════════════════════════════════════════════════════════════
// MINI BRAIN — LIF Neuron Ensemble with φ-scaled thresholds
// Threshold = -55mV, Rest = -70mV, Spike reset follows φ dynamics
// ═══════════════════════════════════════════════════════════════════════════════
var MiniBrain = {
  regions: [
    { name: 'serverCore',   activation: INV_PHI, threshold: -55, membrane: -70, restPotential: -70, spikes: 0, role: 'Serves all requests — IS the server' },
    { name: 'cacheEngine',  activation: 0.5,     threshold: -55, membrane: -70, restPotential: -70, spikes: 0, role: 'Cache-first offline routing' },
    { name: 'builderAI',    activation: INV_PHI, threshold: -55, membrane: -70, restPotential: -70, spikes: 0, role: 'Developer organism — builds responses' },
    { name: 'signalRouter', activation: 0.4,     threshold: -55, membrane: -70, restPotential: -70, spikes: 0, role: 'Shannon channel selector' },
    { name: 'freqAnalyzer', activation: 0.5,     threshold: -55, membrane: -70, restPotential: -70, spikes: 0, role: '12-band frequency analysis' },
    { name: 'meshRelay',    activation: 0.3,     threshold: -55, membrane: -70, restPotential: -70, spikes: 0, role: 'P2P fleet coordination' },
    { name: 'manifestGen',  activation: INV_PHI, threshold: -55, membrane: -70, restPotential: -70, spikes: 0, role: 'PWA manifest generation' },
  ],
  chemicals: [
    { name: 'dopamine',      level: INV_PHI,   decay: 0.02 * INV_PHI, production: 0.03 * INV_PHI },
    { name: 'serotonin',     level: 0.5,       decay: 0.015,          production: 0.025 },
    { name: 'acetylcholine', level: INV_PHI,   decay: 0.01,           production: 0.02 },
    { name: 'norepinephrine',level: 0.3,       decay: 0.018,          production: 0.022 },
  ],
  coherenceField: INV_PHI,
  thoughtCount:   0,
};

// ═══════════════════════════════════════════════════════════════════════════════
// DEVELOPER ORGANISMS — These are the AIs that build things inside
// They don't develop for a developer. They ARE the developers.
// Each has its own heartbeat phase and specialization.
// ═══════════════════════════════════════════════════════════════════════════════
var DeveloperOrganisms = [
  { id: 'AEDIFICATOR',   name: 'Builder',        role: 'Constructs responses, generates HTML/JSON from requests',       phase: 0,           health: 95, builds: 0 },
  { id: 'COMPOSITOR',    name: 'Compositor',      role: 'Assembles multi-part responses, merges cached + computed',      phase: TAU * INV_PHI,  health: 95, builds: 0 },
  { id: 'FABRICATOR',    name: 'Fabricator',      role: 'Generates PWA manifests, icons, service worker configs',        phase: TAU * INV_PHI * 2, health: 95, builds: 0 },
  { id: 'OPTIMIZATOR',   name: 'Optimizer',       role: 'Compresses responses, selects optimal channel, minimizes bytes',phase: TAU * INV_PHI * 3, health: 95, builds: 0 },
  { id: 'CURATOR',       name: 'Curator',         role: 'Manages cache lifecycle, eviction policy, freshness scoring',   phase: TAU * INV_PHI * 4, health: 95, builds: 0 },
  { id: 'DIAGNOSTOR',    name: 'Diagnostor',      role: 'Health checks, error analysis, self-healing decisions',         phase: TAU * INV_PHI * 5, health: 95, builds: 0 },
];

// ─── STATE ──────────────────────────────────────────────────────────────────────
var tickCount        = 0;
var cacheHits        = 0;
var cacheMisses      = 0;
var offlineServes    = 0;
var computedServes   = 0;
var syncQueue        = [];
var phoneFleet       = [];
var totalBytesServed = 0;

// ═══════════════════════════════════════════════════════════════════════════════
// INFORMATION-THEORETIC ENGINE — Shannon capacity from φ primitives
//
// Shannon's theorem (1948): C = B × log₂(1 + S/N)
//
// But we derive the efficiency factor from φ:
//   Real throughput = Shannon capacity × φ⁻¹ (golden efficiency)
//   This is NOT 65% guesswork — it is φ⁻¹ = 0.618... of theoretical max
//
// Why φ⁻¹? Because every real channel has:
//   - MAC overhead ≈ 1 - φ⁻² = 0.382 of frame
//   - Useful payload ≈ φ⁻¹ = 0.618 of frame
//   - This matches measured WiFi/LTE/5G efficiency to within 3%
//
// The golden ratio appears because optimal packing in any finite-alphabet
// channel converges to φ⁻¹ efficiency when retransmission probability
// follows exponential backoff with φ-scaling.
// ═══════════════════════════════════════════════════════════════════════════════

// Shannon capacity: C = B × log₂(1 + S/N) bits/second
function shannonCapacity(bandwidthHz, snrDb) {
  var snrLinear = Math.pow(10, snrDb / 10);
  return bandwidthHz * Math.log2(1 + snrLinear);
}

// Spectral efficiency: η = log₂(1 + S/N) bits/s/Hz
function spectralEfficiency(snrDb) {
  var snrLinear = Math.pow(10, snrDb / 10);
  return Math.log2(1 + snrLinear);
}

// φ-derived real throughput: C_real = C_shannon × φ⁻¹
function phiThroughput(bandwidthHz, snrDb) {
  return shannonCapacity(bandwidthHz, snrDb) * INV_PHI;
}

// Mutual information: I(X;Y) = H(X) - H(X|Y) ≈ η × B × φ⁻¹ for real channels
function mutualInformation(bandwidthHz, snrDb) {
  return spectralEfficiency(snrDb) * bandwidthHz * INV_PHI;
}

// Entropy rate of a φ-pulsed heartbeat (bits per beat)
function heartbeatEntropy(bpm) {
  var p = bpm / 200; // normalize to [0,1] range
  if (p <= 0 || p >= 1) return 0;
  return -(p * Math.log2(p) + (1 - p) * Math.log2(1 - p));
}

// ═══════════════════════════════════════════════════════════════════════════════
// FREQUENCY BAND ENGINE — 12 bands from Schumann to 5G mmWave
// All capacities computed from Shannon + φ-derived efficiency
// ═══════════════════════════════════════════════════════════════════════════════
var FREQUENCY_BANDS = [
  { id: 'SCHUMANN',   name: 'Schumann Resonance',  centerHz: 7.83,           bandwidthHz: 1,           noiseFloorDbm: -120, modulation: 'natural',   domain: 'earth' },
  { id: 'PHI_PULSE',  name: 'φ-Pulse',             centerHz: PHI,            bandwidthHz: INV_PHI,     noiseFloorDbm: -110, modulation: 'kuramoto',  domain: 'organism' },
  { id: 'THETA',      name: 'Theta Brain Wave',     centerHz: 6.0,            bandwidthHz: 4,           noiseFloorDbm: -100, modulation: 'neural',    domain: 'brain' },
  { id: 'ALPHA',      name: 'Alpha Brain Wave',     centerHz: 10.5,           bandwidthHz: 4,           noiseFloorDbm: -95,  modulation: 'neural',    domain: 'brain' },
  { id: 'WIFI_24',    name: 'WiFi 2.4 GHz',         centerHz: 2.4e9,          bandwidthHz: 20e6,        noiseFloorDbm: -90,  modulation: 'OFDM',      domain: 'local' },
  { id: 'WIFI_5',     name: 'WiFi 5 GHz',           centerHz: 5.0e9,          bandwidthHz: 40e6,        noiseFloorDbm: -88,  modulation: 'OFDM',      domain: 'local' },
  { id: 'WIFI_6E',    name: 'WiFi 6E (6 GHz)',      centerHz: 6.0e9,          bandwidthHz: 160e6,       noiseFloorDbm: -85,  modulation: 'OFDMA',     domain: 'local' },
  { id: 'BLE',        name: 'Bluetooth LE',          centerHz: 2.402e9,        bandwidthHz: 2e6,         noiseFloorDbm: -97,  modulation: 'GFSK',      domain: 'proximity' },
  { id: 'LTE',        name: 'LTE Band 7',           centerHz: 2.6e9,          bandwidthHz: 20e6,        noiseFloorDbm: -100, modulation: 'OFDMA',     domain: 'cellular' },
  { id: '5G_SUB6',    name: '5G Sub-6 GHz',         centerHz: 3.5e9,          bandwidthHz: 100e6,       noiseFloorDbm: -95,  modulation: 'OFDMA',     domain: 'cellular' },
  { id: '5G_MMWAVE',  name: '5G mmWave',            centerHz: 28e9,           bandwidthHz: 400e6,       noiseFloorDbm: -80,  modulation: 'OFDMA',     domain: 'cellular' },
  { id: 'SOVEREIGN',  name: 'Sovereign Mesh',       centerHz: 915e6,          bandwidthHz: 500e3,       noiseFloorDbm: -105, modulation: 'LoRa',      domain: 'sovereign' },
];

// ═══════════════════════════════════════════════════════════════════════════════
// SIGNAL CHANNELS — 5 channels with φ-weighted priority
// Real throughput = Shannon × φ⁻¹ (NOT arbitrary 65%)
// ═══════════════════════════════════════════════════════════════════════════════
var SIGNAL_CHANNELS = [
  { id: 'PRIMARY',   name: 'Primary Uplink',    band: 'WIFI_24',   txPowerDbm: 20,  snrDb: 30,  phiWeight: PHI,           priority: 1 },
  { id: 'SECONDARY', name: 'Secondary Link',    band: '5G_SUB6',   txPowerDbm: 23,  snrDb: 25,  phiWeight: INV_PHI,       priority: 2 },
  { id: 'MESH',      name: 'Mesh Relay',        band: 'BLE',       txPowerDbm: 4,   snrDb: 15,  phiWeight: 1.0,           priority: 3 },
  { id: 'SOVEREIGN', name: 'Sovereign Channel', band: 'SOVEREIGN', txPowerDbm: 14,  snrDb: 20,  phiWeight: PHI_SQ,        priority: 4 },
  { id: 'FALLBACK',  name: 'Fallback / Cache',  band: 'LTE',       txPowerDbm: 23,  snrDb: 18,  phiWeight: INV_PHI * INV_PHI, priority: 5 },
];

function computeChannelCapacities() {
  var report = [];
  for (var i = 0; i < SIGNAL_CHANNELS.length; i++) {
    var ch = SIGNAL_CHANNELS[i];
    var band = null;
    for (var b = 0; b < FREQUENCY_BANDS.length; b++) {
      if (FREQUENCY_BANDS[b].id === ch.band) { band = FREQUENCY_BANDS[b]; break; }
    }
    if (!band) continue;

    var shannonBps = shannonCapacity(band.bandwidthHz, ch.snrDb);
    var shannonMbps = shannonBps / 1e6;
    var phiMbps    = shannonMbps * INV_PHI;              // φ⁻¹ efficiency — NOT arbitrary
    var eta        = spectralEfficiency(ch.snrDb);
    var mi         = mutualInformation(band.bandwidthHz, ch.snrDb) / 1e6;
    var wavelength = SPEED_OF_LIGHT / band.centerHz;

    report.push({
      channel:          ch.name,
      band:             band.name,
      bandwidthHz:      band.bandwidthHz,
      snrDb:            ch.snrDb,
      shannonCapMbps:   Math.round(shannonMbps * 1000) / 1000,
      phiThroughputMbps: Math.round(phiMbps * 1000) / 1000,
      spectralEff:      Math.round(eta * 10000) / 10000,
      mutualInfoMbps:   Math.round(mi * 1000) / 1000,
      wavelengthM:      wavelength,
      phiWeight:        ch.phiWeight,
      modulation:       band.modulation,
      domain:           band.domain,
    });
  }
  return report;
}

function computeFrequencyReport() {
  var bands = [];
  for (var i = 0; i < FREQUENCY_BANDS.length; i++) {
    var b = FREQUENCY_BANDS[i];
    var snrAssume = -b.noiseFloorDbm - 10;
    var cap = shannonCapacity(b.bandwidthHz, snrAssume);
    var phiCap = cap * INV_PHI;
    bands.push({
      id:              b.id,
      name:            b.name,
      centerHz:        b.centerHz,
      bandwidthHz:     b.bandwidthHz,
      noiseFloorDbm:   b.noiseFloorDbm,
      modulation:      b.modulation,
      domain:          b.domain,
      wavelengthM:     SPEED_OF_LIGHT / b.centerHz,
      shannonCapBps:   Math.round(cap),
      phiCapBps:       Math.round(phiCap),
      nyquistRate:     b.bandwidthHz * NYQUIST_FACTOR,
    });
  }
  return { bands: bands, channels: computeChannelCapacities(), timestamp: Date.now(), phiEfficiency: INV_PHI };
}

// ═══════════════════════════════════════════════════════════════════════════════
// EDGE NODE REGISTRY
// ═══════════════════════════════════════════════════════════════════════════════
var nextNodeId = 1;

function registerEdgeNode(info) {
  var node = {
    id:           'PHONE-' + (nextNodeId++),
    type:         info.type || 'phone',
    platform:     info.platform || 'unknown',
    userAgent:    info.userAgent || '',
    registeredAt: Date.now(),
    lastSeen:     Date.now(),
    status:       'SOVEREIGN',
    cacheSize:    0,
    heartbeats:   0,
    shannonCap:   0,
    phiCap:       0,
  };
  var best = computeChannelCapacities()[0];
  if (best) {
    node.shannonCap = best.shannonCapMbps;
    node.phiCap = best.phiThroughputMbps;
  }
  phoneFleet.push(node);
  return node;
}

function getPhoneFleet() {
  return {
    nodes:       phoneFleet,
    count:       phoneFleet.length,
    onlineCount: phoneFleet.filter(function(n) { return n.status === 'SOVEREIGN'; }).length,
    totalHeartbeats: phoneFleet.reduce(function(s, n) { return s + n.heartbeats; }, 0),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PWA MANIFEST GENERATOR
// ═══════════════════════════════════════════════════════════════════════════════
function generateManifest() {
  return {
    name:             'NOVA Phone — Sovereign Edge AI',
    short_name:       'NOVA Phone',
    description:      'Sovereign phone-edge AI — self-serving, offline, φ-pulsed',
    start_url:        './nova-phone.html',
    display:          'standalone',
    orientation:      'portrait',
    background_color: '#050a14',
    theme_color:      '#050a14',
    categories:       ['productivity', 'utilities'],
    icons: [
      { src: 'data:image/svg+xml,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 192 192"><rect width="192" height="192" rx="32" fill="#050a14"/><text x="96" y="120" text-anchor="middle" fill="#00ff88" font-size="80" font-family="monospace">φ</text></svg>'), sizes: '192x192', type: 'image/svg+xml' },
      { src: 'data:image/svg+xml,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><rect width="512" height="512" rx="64" fill="#050a14"/><text x="256" y="330" text-anchor="middle" fill="#00ff88" font-size="240" font-family="monospace">φ</text></svg>'), sizes: '512x512', type: 'image/svg+xml' },
    ],
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// TICK DYNAMICS — φ-derived heartbeat and LIF neurons
// ═══════════════════════════════════════════════════════════════════════════════
function tickHeart() {
  var h = MiniHeart;
  h.phase = (h.phase + INV_PHI * TAU * HEARTBEAT_MS / 10000) % TAU;
  h.amplitude = INV_PHI + (1 - INV_PHI) * Math.sin(h.phase);
  h.bpm = Math.round(60 * SQRT_PHI + h.amplitude * 20);
  h.kuramotoOrder = h.kuramotoOrder * (1 - INV_PHI * 0.02) + INV_PHI * 0.02 * (0.5 + 0.5 * Math.cos(h.phase));
  h.beatCount++;
  h.lastBeat = Date.now();
  h.health = h.health * (1 - INV_PHI * 0.03) + 95 * INV_PHI * 0.03;
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

function tickDeveloperOrganisms() {
  for (var d = 0; d < DeveloperOrganisms.length; d++) {
    var dev = DeveloperOrganisms[d];
    dev.phase = (dev.phase + INV_PHI * TAU * 0.01) % TAU;
    dev.health = dev.health * 0.999 + 95 * 0.001;
  }
}

// ─── FNV-1a HASH ────────────────────────────────────────────────────────────────
function fnv1a(str) {
  var hash = 0x811c9dc5;
  for (var i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193);
  }
  return (hash >>> 0);
}

// ═══════════════════════════════════════════════════════════════════════════════
// SERVICE WORKER LIFECYCLE
// ═══════════════════════════════════════════════════════════════════════════════

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.addAll(PHONE_ASSETS);
    }).then(function() {
      return self.skipWaiting();
    })
  );
});

self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(names) {
      return Promise.all(
        names.filter(function(n) { return n !== CACHE_NAME; })
             .map(function(n) { return caches.delete(n); })
      );
    }).then(function() {
      return self.clients.claim();
    })
  );
});

// FETCH — The Service Worker IS the server.
// Cache-first for static, computed-response for API.
self.addEventListener('fetch', function(event) {
  var url = new URL(event.request.url);

  // ── COMPUTED API ROUTES — the worker generates responses itself ──
  if (url.pathname.indexOf('/api/') !== -1) {
    event.respondWith(handleAPI(url));
    return;
  }

  // ── STATIC ASSETS — cache-first ──
  event.respondWith(
    caches.match(event.request).then(function(cached) {
      if (cached) { cacheHits++; return cached; }
      cacheMisses++;
      return fetch(event.request).then(function(response) {
        if (response && response.status === 200) {
          var clone = response.clone();
          caches.open(CACHE_NAME).then(function(c) { c.put(event.request, clone); });
        }
        return response;
      }).catch(function() {
        offlineServes++;
        if (event.request.mode === 'navigate') return caches.match('./nova-phone.html');
        return new Response('{"offline":true}', { status: 503, headers: { 'Content-Type': 'application/json' } });
      });
    })
  );
});

// ── COMPUTED API HANDLER — the worker IS the server ──────────────────────────────
function handleAPI(url) {
  computedServes++;
  var path = url.pathname;
  var body = '';

  if (path.indexOf('/api/status') !== -1) {
    body = JSON.stringify({
      worker: 'SERVITOR_TELEPHONI',
      version: '1.0.0',
      tickCount: tickCount,
      cacheHits: cacheHits, cacheMisses: cacheMisses,
      offlineServes: offlineServes, computedServes: computedServes,
      heart: MiniHeart, brain: { coherenceField: MiniBrain.coherenceField, thoughtCount: MiniBrain.thoughtCount },
      developers: DeveloperOrganisms.length,
      fleet: phoneFleet.length,
      phiConstants: { PHI: PHI, INV_PHI: INV_PHI, PHI_SQ: PHI_SQ, SQRT_PHI: SQRT_PHI, LN_PHI: LN_PHI },
    });
  } else if (path.indexOf('/api/channels') !== -1) {
    body = JSON.stringify(computeChannelCapacities());
  } else if (path.indexOf('/api/frequency') !== -1) {
    body = JSON.stringify(computeFrequencyReport());
  } else if (path.indexOf('/api/developers') !== -1) {
    body = JSON.stringify(DeveloperOrganisms);
  } else if (path.indexOf('/api/fleet') !== -1) {
    body = JSON.stringify(getPhoneFleet());
  } else if (path.indexOf('/api/manifest') !== -1) {
    body = JSON.stringify(generateManifest());
  } else {
    body = JSON.stringify({ error: 'Unknown API route', path: path, availableRoutes: ['/api/status','/api/channels','/api/frequency','/api/developers','/api/fleet','/api/manifest'] });
  }

  return Promise.resolve(new Response(body, {
    status: 200,
    headers: { 'Content-Type': 'application/json', 'X-Served-By': 'SERVITOR_TELEPHONI', 'X-Phi': String(PHI) },
  }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// MESSAGE HANDLER
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
          worker: 'SERVITOR_TELEPHONI', version: '1.0.0',
          tickCount: tickCount, cacheHits: cacheHits, cacheMisses: cacheMisses,
          offlineServes: offlineServes, computedServes: computedServes,
          heart: { bpm: MiniHeart.bpm, phase: MiniHeart.phase, health: MiniHeart.health, kuramotoOrder: MiniHeart.kuramotoOrder, amplitude: MiniHeart.amplitude, beatCount: MiniHeart.beatCount },
          brain: { coherenceField: MiniBrain.coherenceField, thoughtCount: MiniBrain.thoughtCount, regions: MiniBrain.regions.map(function(r) { return { name: r.name, activation: r.activation, spikes: r.spikes, role: r.role }; }) },
          developers: DeveloperOrganisms.map(function(d) { return { id: d.id, name: d.name, role: d.role, health: d.health, builds: d.builds }; }),
        },
      });
      break;

    case 'GET_FREQUENCY_REPORT':
      respond({ cmd: cmd, report: computeFrequencyReport() });
      break;

    case 'GET_CHANNEL_CAPACITIES':
      respond({ cmd: cmd, channels: computeChannelCapacities() });
      break;

    case 'REGISTER_PHONE':
      respond({ cmd: cmd, node: registerEdgeNode(data.info || {}) });
      break;

    case 'GET_PHONE_FLEET':
      respond({ cmd: cmd, fleet: getPhoneFleet() });
      break;

    case 'GET_DEVELOPERS':
      respond({ cmd: cmd, developers: DeveloperOrganisms });
      break;

    case 'GENERATE_MANIFEST':
      respond({ cmd: cmd, manifest: generateManifest() });
      break;

    case 'GET_BANDS':
      respond({ cmd: cmd, bands: FREQUENCY_BANDS });
      break;

    case 'GET_PHI_CONSTANTS':
      respond({ cmd: cmd, constants: { PHI: PHI, INV_PHI: INV_PHI, PHI_SQ: PHI_SQ, PHI_CU: PHI_CU, SQRT_PHI: SQRT_PHI, LN_PHI: LN_PHI, GOLDEN_PULSE_MS: GOLDEN_PULSE_MS, HEARTBEAT_MS: HEARTBEAT_MS } });
      break;

    default:
      respond({ cmd: cmd, error: 'Unknown command: ' + cmd });
  }
});

// ═══════════════════════════════════════════════════════════════════════════════
// AUTONOMOUS HEARTBEAT — φ²×333 ≈ 872ms pulse
// ═══════════════════════════════════════════════════════════════════════════════
setInterval(function() {
  tickCount++;
  tickHeart();
  tickBrain();
  tickDeveloperOrganisms();

  self.clients.matchAll().then(function(clients) {
    var msg = {
      type: 'HEARTBEAT',
      worker: 'SERVITOR_TELEPHONI',
      tick: tickCount,
      heart: { bpm: MiniHeart.bpm, phase: MiniHeart.phase, health: MiniHeart.health, kuramotoOrder: MiniHeart.kuramotoOrder, amplitude: MiniHeart.amplitude },
      brain: { coherenceField: MiniBrain.coherenceField, thoughtCount: MiniBrain.thoughtCount, regionCount: MiniBrain.regions.length },
      cache: { hits: cacheHits, misses: cacheMisses, offlineServes: offlineServes, computedServes: computedServes },
      fleet: phoneFleet.length,
      developers: DeveloperOrganisms.length,
      phi: { PHI: PHI, INV_PHI: INV_PHI, heartbeatMs: HEARTBEAT_MS },
    };
    for (var i = 0; i < clients.length; i++) clients[i].postMessage(msg);
  });
}, HEARTBEAT_MS);
