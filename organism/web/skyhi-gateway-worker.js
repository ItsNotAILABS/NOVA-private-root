/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SKYHI GATEWAY — Sovereign Edge Gateway Worker
 *  Kernel AI GOL-SKYHI-001  ·  Family: CAELUM_AETERNA
 *  Web Worker #71 · The Airport Intelligence Gateway
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR CAELI — The sovereign edge gateway for Skyhi Group.
 *  Runs as Web Worker (browser) and Cloudflare Worker (edge).
 *  Handles: rate limiting, DDoS absorption, device fingerprinting,
 *  geolocation coarsening, bot detection, and traffic classification.
 *
 *  Architecture (5 engines):
 *    RATE_LIMITER        — Adaptive φ-tier throttling (FLOODGATES/TRICKLE/NORMAL/HIGH)
 *    DEVICE_FINGERPRINT  — Timing analysis + header entropy for bot detection
 *    GEO_COARSENER       — On-device GPS → IATA airport code (never raw GPS)
 *    TRAFFIC_CLASSIFIER  — L7 request classification for AEGIS routing
 *    HONEYPOT_DETECTOR   — Identifies requests targeting synthetic flights
 *
 *  Operations (page → self.onmessage):
 *    CLASSIFY             — classify incoming request
 *    RATE_CHECK           — check rate limit for principal
 *    FINGERPRINT          — compute device fingerprint
 *    COARSEN_LOCATION     — GPS → nearest IATA code
 *    CHECK_HONEYPOT       — check if request targets honeypot
 *    HEARTBEAT_PROBE      — 873ms liveness check
 *    status               — kernel liveness probe
 *    stop                 — graceful shutdown
 *
 *  Commands (self.postMessage → page):
 *    heartbeat            — tick pulse with gateway state
 *    classify_result      — { type:'classify_result', classification }
 *    rate_result          — { type:'rate_result', allowed }
 *    fingerprint_result   — { type:'fingerprint_result', fp }
 *    coarsen_result       — { type:'coarsen_result', iata }
 *    honeypot_result      — { type:'honeypot_result', isHoneypot }
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var KERNEL_ID      = 'GOL-SKYHI-001';
var KERNEL_FAMILY  = 'CAELUM_AETERNA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR CAELI';

var PHI       = 1.6180339887498948482;   /* φ — the golden ratio              */
var PHI_INV   = 0.6180339887498948482;   /* φ⁻¹ — coherence weight            */
var PHI_SQ    = 2.6180339887498948482;   /* φ² — elevated threshold           */
var AMOR      = 0.3819660112501051518;   /* φ⁻² — love constant               */
var HEARTBEAT = 873;                     /* ms — Kuramoto φ-phase period       */

/* Rate limiting tiers (requests per window) */
var RATE_TIERS = {
  FLOODGATES: { max: 1000, window: 60000, tier: 'FLOODGATES' },
  HIGH:       { max: 100,  window: 60000, tier: 'HIGH'       },
  NORMAL:     { max: 30,   window: 60000, tier: 'NORMAL'     },
  TRICKLE:    { max: 5,    window: 60000, tier: 'TRICKLE'    },
  PAUSED:     { max: 0,    window: 60000, tier: 'PAUSED'     },
};

/* Major airport IATA codes with approximate coordinates */
var AIRPORTS = [
  { iata: 'DFW', lat: 32.8998, lon: -97.0403, name: 'Dallas/Fort Worth' },
  { iata: 'LAX', lat: 33.9425, lon: -118.4081, name: 'Los Angeles' },
  { iata: 'JFK', lat: 40.6413, lon: -73.7781, name: 'New York JFK' },
  { iata: 'ORD', lat: 41.9742, lon: -87.9073, name: 'Chicago O\'Hare' },
  { iata: 'ATL', lat: 33.6407, lon: -84.4277, name: 'Atlanta' },
  { iata: 'SFO', lat: 37.6213, lon: -122.3790, name: 'San Francisco' },
  { iata: 'MIA', lat: 25.7959, lon: -80.2870, name: 'Miami' },
  { iata: 'SEA', lat: 47.4502, lon: -122.3088, name: 'Seattle' },
  { iata: 'DEN', lat: 39.8561, lon: -104.6737, name: 'Denver' },
  { iata: 'LHR', lat: 51.4700, lon: -0.4543, name: 'London Heathrow' },
  { iata: 'CDG', lat: 49.0097, lon: 2.5479, name: 'Paris CDG' },
  { iata: 'NRT', lat: 35.7720, lon: 140.3929, name: 'Tokyo Narita' },
  { iata: 'MEX', lat: 19.4363, lon: -99.0721, name: 'Mexico City' },
  { iata: 'MTY', lat: 25.7785, lon: -100.1070, name: 'Monterrey' },
  { iata: 'GDL', lat: 20.5218, lon: -103.3113, name: 'Guadalajara' },
  { iata: 'CUN', lat: 21.0365, lon: -86.8770, name: 'Cancún' },
];

/* ════════════════════════════════════════════════════════════════════════════
   §2  STATE
════════════════════════════════════════════════════════════════════════════ */

var tick         = 0;
var alive        = true;
var rateBuckets  = {};    /* principal → { count, windowStart, tier } */
var totalRequests = 0;
var blockedRequests = 0;
var fingerprintCache = {};
var honeypotIds  = {};    /* set of known honeypot flight IDs */
var threatScore  = 0.0;

/* ════════════════════════════════════════════════════════════════════════════
   §3  RATE LIMITER — Adaptive φ-tier Throttling
════════════════════════════════════════════════════════════════════════════ */

function rateLimitCheck(principal, now) {
  totalRequests++;
  if (!rateBuckets[principal]) {
    rateBuckets[principal] = { count: 0, windowStart: now, tier: 'NORMAL' };
  }
  var bucket = rateBuckets[principal];

  /* Reset window */
  var tierConfig = RATE_TIERS[bucket.tier] || RATE_TIERS.NORMAL;
  if (now - bucket.windowStart > tierConfig.window) {
    bucket.count = 0;
    bucket.windowStart = now;
  }

  bucket.count++;

  /* Check limit */
  if (bucket.count > tierConfig.max) {
    blockedRequests++;
    /* Escalate down to next tier */
    if (bucket.tier === 'FLOODGATES') bucket.tier = 'HIGH';
    else if (bucket.tier === 'HIGH')  bucket.tier = 'NORMAL';
    else if (bucket.tier === 'NORMAL') bucket.tier = 'TRICKLE';
    else bucket.tier = 'PAUSED';
    return { allowed: false, tier: bucket.tier, reason: 'RATE_EXCEEDED' };
  }

  return { allowed: true, tier: bucket.tier, remaining: tierConfig.max - bucket.count };
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  DEVICE FINGERPRINT — Timing + Entropy Analysis
════════════════════════════════════════════════════════════════════════════ */

function computeFingerprint(headers) {
  /* FNV-1a hash of concatenated header values */
  var raw = '';
  var keys = ['user-agent', 'accept-language', 'accept-encoding', 'connection'];
  for (var i = 0; i < keys.length; i++) {
    raw += (headers[keys[i]] || '') + '|';
  }

  var hash = 2166136261;
  for (var j = 0; j < raw.length; j++) {
    hash ^= raw.charCodeAt(j);
    hash = (hash * 16777619) >>> 0;
  }

  /* Entropy score: higher = more likely human */
  var entropy = 0;
  var seen = {};
  for (var k = 0; k < raw.length; k++) {
    var ch = raw[k];
    if (!seen[ch]) { seen[ch] = 0; }
    seen[ch]++;
  }
  var total = raw.length || 1;
  var chars = Object.keys(seen);
  for (var m = 0; m < chars.length; m++) {
    var p = seen[chars[m]] / total;
    if (p > 0) entropy -= p * Math.log2(p);
  }

  var isBot = entropy < PHI;  /* Low entropy = likely automated */

  return {
    hash: hash.toString(16),
    entropy: Math.round(entropy * 1000) / 1000,
    isBot: isBot,
    headerCount: keys.filter(function(k) { return !!headers[k]; }).length,
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  GEO COARSENER — GPS → Nearest IATA Airport Code
════════════════════════════════════════════════════════════════════════════ */

function coarsenLocation(lat, lon) {
  /* Find nearest airport — Haversine distance */
  var nearest = null;
  var minDist = Infinity;

  for (var i = 0; i < AIRPORTS.length; i++) {
    var a = AIRPORTS[i];
    var dLat = (a.lat - lat) * Math.PI / 180;
    var dLon = (a.lon - lon) * Math.PI / 180;
    var sinLat = Math.sin(dLat / 2);
    var sinLon = Math.sin(dLon / 2);
    var h = sinLat * sinLat +
            Math.cos(lat * Math.PI / 180) * Math.cos(a.lat * Math.PI / 180) *
            sinLon * sinLon;
    var dist = 2 * 6371 * Math.asin(Math.sqrt(h));  /* km */

    if (dist < minDist) {
      minDist = dist;
      nearest = a;
    }
  }

  /* Only return IATA code + name — NEVER raw GPS */
  return {
    iata: nearest ? nearest.iata : 'UNK',
    name: nearest ? nearest.name : 'Unknown',
    distanceKm: Math.round(minDist * 10) / 10,
    withinAirport: minDist < 10,
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §6  TRAFFIC CLASSIFIER — L7 Request Classification
════════════════════════════════════════════════════════════════════════════ */

function classifyRequest(request) {
  var path = request.path || '';
  var method = request.method || 'GET';

  /* Classification categories */
  if (path.indexOf('/admin') === 0 || path.indexOf('/api/admin') === 0) {
    return { category: 'SHADOW_ADMIN', severity: 8, action: 'FINGERPRINT_AND_BLOCK' };
  }
  if (path.indexOf('/api/booking') === 0 && method === 'POST') {
    return { category: 'BOOKING', severity: 0, action: 'ALLOW_AND_MONITOR' };
  }
  if (path.indexOf('/api/social') === 0) {
    return { category: 'SOCIAL', severity: 0, action: 'ALLOW' };
  }
  if (path.indexOf('/api/flights') === 0) {
    return { category: 'FLIGHT_DATA', severity: 1, action: 'ALLOW_AND_RATE_LIMIT' };
  }
  if (path.indexOf('/api/translate') === 0) {
    return { category: 'TRANSLATION', severity: 0, action: 'ALLOW' };
  }
  if (path.indexOf('/api/agi') === 0) {
    return { category: 'AGI_QUERY', severity: 2, action: 'ALLOW_AND_LOG' };
  }

  return { category: 'GENERAL', severity: 0, action: 'ALLOW' };
}

/* ════════════════════════════════════════════════════════════════════════════
   §7  HONEYPOT DETECTOR
════════════════════════════════════════════════════════════════════════════ */

function checkHoneypot(flightId) {
  return {
    isHoneypot: !!honeypotIds[flightId],
    flightId: flightId,
  };
}

function registerHoneypot(flightId) {
  honeypotIds[flightId] = true;
}

/* ════════════════════════════════════════════════════════════════════════════
   §8  COR PARVUM — 873ms MiniHeart Oscillator
════════════════════════════════════════════════════════════════════════════ */

var COR_PARVUM = null;

function startHeart() {
  if (COR_PARVUM) return;
  COR_PARVUM = setInterval(function() {
    if (!alive) return;
    tick++;

    /* φ-weighted threat decay */
    threatScore *= PHI_INV;

    self.postMessage({
      type: 'heartbeat',
      kernel: KERNEL_ID,
      family: KERNEL_FAMILY,
      latin:  KERNEL_LATIN,
      tick:   tick,
      totalRequests:   totalRequests,
      blockedRequests: blockedRequests,
      threatScore:     Math.round(threatScore * 1000) / 1000,
      activeBuckets:   Object.keys(rateBuckets).length,
      honeypotCount:   Object.keys(honeypotIds).length,
      heartbeat:       HEARTBEAT,
      phi:             PHI,
    });
  }, HEARTBEAT);
}

function stopHeart() {
  if (COR_PARVUM) {
    clearInterval(COR_PARVUM);
    COR_PARVUM = null;
  }
  alive = false;
}

/* ════════════════════════════════════════════════════════════════════════════
   §9  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var d = e.data;
  if (!d || !d.type) return;

  switch (d.type) {
    case 'CLASSIFY': {
      var classification = classifyRequest(d.request || {});
      self.postMessage({ type: 'classify_result', classification: classification });
      break;
    }

    case 'RATE_CHECK': {
      var result = rateLimitCheck(d.principal || 'anonymous', Date.now());
      self.postMessage({ type: 'rate_result', result: result });
      break;
    }

    case 'FINGERPRINT': {
      var fp = computeFingerprint(d.headers || {});
      if (fp.isBot) {
        threatScore += PHI;
      }
      self.postMessage({ type: 'fingerprint_result', fingerprint: fp });
      break;
    }

    case 'COARSEN_LOCATION': {
      var coarsened = coarsenLocation(d.lat || 0, d.lon || 0);
      self.postMessage({ type: 'coarsen_result', location: coarsened });
      break;
    }

    case 'CHECK_HONEYPOT': {
      var hp = checkHoneypot(d.flightId || '');
      self.postMessage({ type: 'honeypot_result', result: hp });
      break;
    }

    case 'REGISTER_HONEYPOT': {
      registerHoneypot(d.flightId || '');
      self.postMessage({ type: 'honeypot_registered', flightId: d.flightId });
      break;
    }

    case 'HEARTBEAT_PROBE': {
      self.postMessage({
        type: 'heartbeat_probe_result',
        alive: alive,
        tick: tick,
        totalRequests: totalRequests,
        blockedRequests: blockedRequests,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'status',
        kernel: KERNEL_ID,
        family: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        latin: KERNEL_LATIN,
        alive: alive,
        tick: tick,
        totalRequests: totalRequests,
        blockedRequests: blockedRequests,
        threatScore: threatScore,
        phi: PHI,
        heartbeat: HEARTBEAT,
      });
      break;
    }

    case 'stop': {
      stopHeart();
      self.postMessage({ type: 'stopped', kernel: KERNEL_ID, tick: tick });
      break;
    }

    default:
      self.postMessage({ type: 'error', message: 'Unknown operation: ' + d.type });
  }
};

/* ════════════════════════════════════════════════════════════════════════════
   §10  BOOT
════════════════════════════════════════════════════════════════════════════ */

startHeart();
self.postMessage({
  type:   'boot',
  kernel: KERNEL_ID,
  family: KERNEL_FAMILY,
  latin:  KERNEL_LATIN,
  version: KERNEL_VERSION,
  message: KERNEL_LATIN + ' — The Airport Intelligence Gateway — AWAKE',
  phi:     PHI,
  heartbeat: HEARTBEAT,
});
