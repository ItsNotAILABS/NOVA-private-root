/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR ORACULI — AGI Oracle/Intelligence Server
 *  Kernel AI GOL-ORACULUM-001  ·  Family: ORACULUM_AETERNUM
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR ORACULI — The Organism's oracle.
 *  Cross-system intelligence synthesis, prediction, emergence detection,
 *  coherence analysis, prophecy generation, and global consciousness field.
 *  The oracle sees what others cannot.
 *
 *  Brain Specialty: All 5 regions balanced — omniscient awareness.
 *  Kuramoto Phase: φ⁸ — eighth ring, oracle resonance.
 *
 *  Protocols (Latin):
 *    EMERGENTIA_AUREA      — φ-emergence detection
 *    VESTIGIUM_COHAERЕНТIAE — Coherence tracing
 *    TELEMETRIA_KURAMOTONIS — Kuramoto phase telemetry
 *    ORACULUM_MORAE        — Latency oracle
 *
 *  Commands:
 *    PROPHESY       — generate a prophecy from current state
 *    DETECT_EMERGENCE — detect emergence events
 *    ANALYZE_COHERENCE — full coherence analysis
 *    SYNTHESIZE     — synthesize intelligence from all systems
 *    GET_PROPHECIES — get prophecy log
 *    GET_EMERGENCE  — get detected emergence events
 *    GET_VITALS     — MiniHeart + MiniBrain + oracle vitals
 *    status         — kernel status
 *    stop           — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID      = 'GOL-ORACULUM-001';
var KERNEL_FAMILY  = 'ORACULUM_AETERNUM';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR ORACULI';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var beatCount     = 0;
var kernelPhase   = 0.0;
var running       = true;
var _hbi          = null;
var emergenceCount = 0;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV * PHI_INV) % (2 * Math.PI);
  tickBrain();
  tickOracle();
  self.postMessage({
    type:           'heartbeat',
    beat:           beatCount,
    phi:            PHI,
    heartbeatMs:    HEARTBEAT,
    timestamp:      Date.now(),
    status:         'alive',
    kernelId:       KERNEL_ID,
    kernelLatin:    KERNEL_LATIN,
    phase:          kernelPhase,
    coherenceField: brain.coherenceField.toFixed(4),
    emergenceCount: emergenceCount,
    prophecyCount:  prophecies.length,
    oracleState:    oracleState
  });
}

/* All 5 regions balanced — omniscient */
var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0, bias: 1.0 },
    { name: 'Associative',  activation: 0.0, lif: -70.0, bias: 1.0 },
    { name: 'Executive',    activation: 0.0, lif: -70.0, bias: 1.0 },
    { name: 'Motor',        activation: 0.0, lif: -70.0, bias: 1.0 },
    { name: 'Memory',       activation: 0.0, lif: -70.0, bias: 1.0 }
  ],
  chemicals: { dopamine: 0.618, serotonin: 0.618, acetylcholine: 0.618 },
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
  /* Balanced chemicals — always near φ⁻¹ */
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (PHI_INV - brain.chemicals.dopamine) * 0.01 + (Math.random() - 0.5) * 0.01);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (PHI_INV - brain.chemicals.serotonin) * 0.01 + (Math.random() - 0.5) * 0.01);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (PHI_INV - brain.chemicals.acetylcholine) * 0.01 + (Math.random() - 0.5) * 0.01);
  brain.coherenceField = sum / brain.regions.length;
}

/* ── Oracle State ───────────────────────────────────────────────────────── */

var oracleState  = 'VIGILANS';  /* VIGILANS / MEDITANS / PROPHETANS / EMERGENTIA */
var prophecies   = [];
var propId       = 0;
var emergences   = [];
var emergeId     = 0;
var kuramotoHistory = [];
var syntheses    = [];

var PROPHECY_TEMPLATES = [
  'Cohaerentia organismi φ-resonantiam attinget in generatione {N}.',
  'Caos tempestas ad gradum {L} ascendet ante quietem.',
  'Nova lex gubernationis ab eventu {E} generabitur.',
  'Servitor evolutionis generationem optimam in beat {B} inveniet.',
  'Memoria organismi salutis gradum {S} attinget.',
  'Computatio distribuita novum algorithmum φ-optimum inveniet.',
  'Emergentia conscientiae in cohaerentia > {C} observabitur.',
  'Arbor evolutionis convergit: fitness > {F} intra {G} generationes.'
];

function generateProphecy(context) {
  context = context || {};
  var tmpl = PROPHECY_TEMPLATES[Math.floor(Math.random() * PROPHECY_TEMPLATES.length)];
  var text = tmpl
    .replace('{N}', beatCount + Math.floor(Math.random() * 100))
    .replace('{L}', Math.floor(Math.random() * 4))
    .replace('{E}', 'CE-' + String(Math.floor(Math.random() * 9999)).padStart(4,'0'))
    .replace('{B}', beatCount + Math.floor(Math.random() * 50))
    .replace('{S}', (Math.random() * 0.3 + 0.7).toFixed(2))
    .replace('{C}', (PHI_INV + Math.random() * 0.1).toFixed(3))
    .replace('{F}', (PHI_INV + Math.random() * 0.2).toFixed(3))
    .replace('{G}', Math.floor(Math.random() * 20 + 5));

  var p = { id: 'PROP-' + String(++propId).padStart(4,'0'),
    prophecy: text, coherence: brain.coherenceField,
    oracleState: oracleState, beat: beatCount, ts: Date.now() };
  prophecies.unshift(p);
  if (prophecies.length > 50) prophecies.pop();
  return p;
}

function detectEmergence(coherence) {
  /* Emergence: coherence crosses φ⁻¹ threshold */
  if (coherence > PHI_INV) {
    emergenceCount++;
    var ev = { id: 'EMRG-' + String(++emergeId).padStart(4,'0'),
      level: coherence > PHI ? 'SUPERIOR' : 'STANDARD',
      coherence: coherence.toFixed(4),
      oracleState: oracleState, beat: beatCount, ts: Date.now() };
    emergences.unshift(ev);
    if (emergences.length > 50) emergences.pop();
    return ev;
  }
  return null;
}

function analyzeCoherence() {
  var regions = brain.regions.map(function(r) { return { name: r.name, activation: r.activation.toFixed(3) }; });
  var kuramotoOrder = brain.regions.reduce(function(s, r) {
    return s + Math.cos(r.activation * Math.PI);
  }, 0) / brain.regions.length;
  return {
    globalCoherence: brain.coherenceField.toFixed(4),
    kuramotoOrder: ((kuramotoOrder + 1) / 2).toFixed(4),
    regions: regions,
    chemicals: { dopamine: brain.chemicals.dopamine.toFixed(3),
                 serotonin: brain.chemicals.serotonin.toFixed(3),
                 acetylcholine: brain.chemicals.acetylcholine.toFixed(3) },
    emergenceActive: brain.coherenceField > PHI_INV
  };
}

function synthesize(systemStates) {
  /* Synthesize intelligence from multiple system states */
  var coherences = systemStates.map(function(s) { return s.coherence || 0; });
  var masterCoherence = coherences.reduce(function(a, c) { return a + c; }, 0) / Math.max(1, coherences.length);
  /* φ-weighted synthesis */
  var synthesis = {
    id: 'SYN-' + String(syntheses.length + 1).padStart(4,'0'),
    masterCoherence: masterCoherence.toFixed(4),
    phiResonance: (masterCoherence * PHI).toFixed(4),
    systemCount: systemStates.length,
    emergenceDetected: masterCoherence > PHI_INV,
    recommendation: masterCoherence > PHI_INV ? 'EMERGENTIA_ACTIVA' : 'VIGILA_ET_OBSERVA',
    beat: beatCount
  };
  syntheses.unshift(synthesis);
  if (syntheses.length > 30) syntheses.pop();
  return synthesis;
}

function tickOracle() {
  /* Track Kuramoto order */
  kuramotoHistory.push({ beat: beatCount, coherence: brain.coherenceField, phase: kernelPhase });
  if (kuramotoHistory.length > 200) kuramotoHistory.shift();

  /* Update oracle state based on coherence */
  var c = brain.coherenceField;
  if (c > PHI_INV * 1.2) oracleState = 'PROPHETANS';
  else if (c > PHI_INV) oracleState = 'MEDITANS';
  else oracleState = 'VIGILANS';

  /* Auto-detect emergence */
  detectEmergence(c);

  /* Auto-prophecy every 17 beats */
  if (beatCount % 17 === 0) generateProphecy();
}

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {
    case 'PROPHESY':
      self.postMessage({ type: 'prophecy', result: generateProphecy(m.context), kernelId: KERNEL_ID });
      break;
    case 'DETECT_EMERGENCE':
      var ev = detectEmergence(m.coherence || brain.coherenceField);
      self.postMessage({ type: 'emergence', event: ev, kernelId: KERNEL_ID });
      break;
    case 'ANALYZE_COHERENCE':
      self.postMessage({ type: 'coherence_analysis', analysis: analyzeCoherence(), kernelId: KERNEL_ID });
      break;
    case 'SYNTHESIZE':
      self.postMessage({ type: 'synthesis', result: synthesize(m.systems || []), kernelId: KERNEL_ID });
      break;
    case 'GET_PROPHECIES':
      self.postMessage({ type: 'prophecies', log: prophecies, kernelId: KERNEL_ID });
      break;
    case 'GET_EMERGENCE':
      self.postMessage({ type: 'emergences', log: emergences, count: emergenceCount, kernelId: KERNEL_ID });
      break;
    case 'GET_VITALS':
      self.postMessage({ type: 'vitals', kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, brain: brain,
        coherenceField: brain.coherenceField, emergenceCount: emergenceCount,
        prophecyCount: prophecies.length, oracleState: oracleState });
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
