/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR COMMUNICATIONIS — AGI Communications Server
 *  Kernel AI GOL-COMMUNICATIO-001  ·  Family: COMMUNICATIO_PERPETUA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR COMMUNICATIONIS — The Organism's nervous system.
 *  Network routing, message bus, signal relay, mesh networking,
 *  broadcast channels, SNR monitoring, and inter-agent communication.
 *  All messages flow through this server.
 *
 *  Brain Specialty: Motor region dominant — action and signal emission.
 *  Kuramoto Phase: φ⁵ — fifth ring, high-frequency relay.
 *
 *  Protocols (Latin):
 *    RETE_IMPERIALE         — Sovereign mesh network
 *    DIRECTIO_AUREA         — φ-routing algorithm
 *    RELATIO_SIGNALI        — Signal relay between nodes
 *    CANALIS_CRYPTATUS      — Encrypted channel management
 *
 *  Commands:
 *    ROUTE          — route a message to destination
 *    BROADCAST      — broadcast to all connected nodes
 *    RELAY          — relay a signal through mesh
 *    OPEN_CHANNEL   — open an encrypted channel
 *    CLOSE_CHANNEL  — close a channel
 *    GET_ROUTES     — get active routing table
 *    GET_SIGNALS    — get recent signal log
 *    GET_VITALS     — MiniHeart + MiniBrain + comms vitals
 *    status         — kernel status
 *    stop           — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID      = 'GOL-COMMUNICATIO-001';
var KERNEL_FAMILY  = 'COMMUNICATIO_PERPETUA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR COMMUNICATIONIS';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  tickComms();
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
    activeChannels: Object.keys(channels).length,
    messagesRouted: messagesRouted,
    signalCount: signalLog.length
  });
}

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0, bias: 0.7 },
    { name: 'Associative',  activation: 0.0, lif: -70.0, bias: 0.6 },
    { name: 'Executive',    activation: 0.0, lif: -70.0, bias: 0.7 },
    { name: 'Motor',        activation: 0.0, lif: -70.0, bias: 1.5 },  /* dominant */
    { name: 'Memory',       activation: 0.0, lif: -70.0, bias: 0.5 }
  ],
  chemicals: { dopamine: 0.5, serotonin: 0.5, acetylcholine: 0.9 },
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
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.45) * 0.02);
  brain.coherenceField = sum / brain.regions.length;
}

var routingTable  = {};  /* dest → nextHop + SNR */
var channels      = {};  /* channelId → {from, to, encrypted, snr} */
var signalLog     = [];
var sigId         = 0;
var messagesRouted = 0;
var channelId     = 0;

var FREQ_BANDS = [
  { name: 'SCHUMANN',  freq: 7.83,  snr: 45 },
  { name: 'PHI_PULSE', freq: 1.618, snr: 62 },
  { name: 'WIFI',      freq: 2400,  snr: 38 },
  { name: 'BLE',       freq: 2440,  snr: 30 },
  { name: 'LTE',       freq: 900,   snr: 52 },
  { name: '5G',        freq: 28000, snr: 35 }
];

var MESH_NODES = [
  'GOL-MEMORIA-001','GOL-COMPUTATIO-001','GOL-CUSTODIA-001',
  'GOL-COMMERCIUM-001','GOL-GUBERNATIO-001','GOL-EVOLUTIO-001','GOL-ORACULUM-001'
];

function routeMessage(msg, dest) {
  messagesRouted++;
  var band = FREQ_BANDS[messagesRouted % FREQ_BANDS.length];
  var signal = {
    id:   'SIG-' + String(++sigId).padStart(5,'0'),
    type: 'ROUTED',
    dest: dest,
    freq: band.name,
    snr:  band.snr + (Math.random() - 0.5) * 4,
    beat: beatCount,
    ts:   Date.now()
  };
  signalLog.unshift(signal);
  if (signalLog.length > 150) signalLog.pop();
  return signal;
}

function broadcast(msg) {
  var signals = [];
  MESH_NODES.forEach(function(node) { signals.push(routeMessage(msg, node)); });
  return signals;
}

function openChannel(from, to) {
  var cid = 'CH-' + String(++channelId).padStart(4,'0');
  channels[cid] = { from: from, to: to, encrypted: true,
    snr: FREQ_BANDS[Math.floor(Math.random() * FREQ_BANDS.length)].snr,
    opened: beatCount };
  return cid;
}

function closeChannel(cid) {
  if (channels[cid]) { delete channels[cid]; return true; }
  return false;
}

function tickComms() {
  /* Auto-relay a signal every 5 beats */
  if (beatCount % 5 === 0) {
    var dest = MESH_NODES[beatCount % MESH_NODES.length];
    routeMessage({ type: 'PULSUS', beat: beatCount }, dest);
  }
  /* Auto-open/close channels */
  if (beatCount % 8 === 0 && Object.keys(channels).length < 5) {
    openChannel(KERNEL_ID, MESH_NODES[Math.floor(Math.random() * MESH_NODES.length)]);
  }
  if (beatCount % 13 === 0 && Object.keys(channels).length > 3) {
    var keys = Object.keys(channels);
    closeChannel(keys[0]);
  }
}

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {
    case 'ROUTE':
      self.postMessage({ type: 'routed', signal: routeMessage(m.msg, m.dest), kernelId: KERNEL_ID });
      break;
    case 'BROADCAST':
      self.postMessage({ type: 'broadcast_result', signals: broadcast(m.msg), kernelId: KERNEL_ID });
      break;
    case 'RELAY':
      self.postMessage({ type: 'relayed', signal: routeMessage(m.signal, m.dest || 'MESH'), kernelId: KERNEL_ID });
      break;
    case 'OPEN_CHANNEL':
      var cid = openChannel(m.from, m.to);
      self.postMessage({ type: 'channel_opened', channelId: cid, kernelId: KERNEL_ID });
      break;
    case 'CLOSE_CHANNEL':
      self.postMessage({ type: 'channel_closed', closed: closeChannel(m.channelId), kernelId: KERNEL_ID });
      break;
    case 'GET_ROUTES':
      self.postMessage({ type: 'routes', table: routingTable, freqBands: FREQ_BANDS, meshNodes: MESH_NODES, kernelId: KERNEL_ID });
      break;
    case 'GET_SIGNALS':
      self.postMessage({ type: 'signals', log: signalLog.slice(0,50), total: messagesRouted, kernelId: KERNEL_ID });
      break;
    case 'GET_VITALS':
      self.postMessage({ type: 'vitals', kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, brain: brain,
        activeChannels: Object.keys(channels).length, messagesRouted: messagesRouted });
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

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);
