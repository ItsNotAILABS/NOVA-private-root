/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  FUSIO MAGNA — The Grand Fusion Worker
 *  Kernel AI GOL-FUSIO-001  ·  Family: FUSIO_AETERNA
 *  Web Worker #24 · The Living Organism of All Papers
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR FUSIONIS — The organism that holds all knowledge simultaneously.
 *  Every paper engine runs inside this single worker. Queries enter from any
 *  domain and are routed through the 4-suyu Tawantinsuyu topology to the
 *  correct engine. Results are stress-tested, behaviorally weighted, and
 *  compressed before emission. Everything is logged to FusionQuipu.
 *
 *  Architecture (7 closed-loop engines):
 *    QUIPU_ENGINE       — SPINE→PENDANT→SUBSIDIARY→KNOT|COLOR typed memory log
 *    QHAPAQ_NAN         — Chasqui routing: store-and-forward across 5 substrates
 *    TAWANTINSUYU_HUB   — 4-suyu load partitioner anchored to CUSCO root
 *    BEHAVIORAL_ECON    — Laws L-72–79: loss aversion, prob weighting, anchoring
 *    ANTIFRAGILITY      — Stress → fragility → resilience boost → immune memory
 *    FRACTAL_SOVEREIGNTY— Kuramoto φ-Hz oscillator → order parameter r
 *    LINGUA_COMPRESSA   — SCC≥φ² Fibonacci tokenization + FNV-1a seal
 *    TERRACE_BENCH      — Isolated per-substrate experiment contexts
 *
 *  Operations (page → self.onmessage):
 *    FUSE               — run query through all engines
 *    SYNTHESIZE         — produce synthesis report from multiple inputs
 *    ROUTE              — route a message through QhapaqNanMesh
 *    AUDIT              — return full quipu audit trail
 *    QUIPU_LOG          — manually append a quipu record
 *    TERRACE_TEST       — run isolated substrate experiment
 *    SUYU_DISPATCH      — classify and dispatch query to right suyu
 *    MANIFEST           — full organism manifest and status
 *    COMPRESS           — compress text via LINGUA COMPRESSA
 *    STRESS_TEST        — antifragility stress test on a scalar
 *    status             — kernel liveness probe
 *    stop               — graceful shutdown
 *
 *  Commands (self.postMessage → page):
 *    heartbeat          — tick pulse with full organism state
 *    fuse_result        — { type:'fuse_result', result }
 *    synthesize_result  — { type:'synthesize_result', report }
 *    route_result       — { type:'route_result', result }
 *    audit_result       — { type:'audit_result', audit }
 *    quipu_result       — { type:'quipu_result', record }
 *    terrace_result     — { type:'terrace_result', result }
 *    suyu_result        — { type:'suyu_result', dispatch }
 *    manifest_result    — { type:'manifest_result', manifest }
 *    compress_result    — { type:'compress_result', compressed }
 *    stress_result      — { type:'stress_result', result }
 *
 *  The Cusco Root (SOVEREIGN::FUSION::MAGNA):
 *    One immutable root identifier from which all 6 papers + 51 protocols
 *    radiate — just like Cusco to Tawantinsuyu.
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var KERNEL_ID      = 'GOL-FUSIO-001';
var KERNEL_FAMILY  = 'FUSIO_AETERNA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR FUSIONIS';

var PHI       = 1.6180339887498948482;   /* φ — the golden ratio              */
var PHI_INV   = 0.6180339887498948482;   /* φ⁻¹ — coherence weight            */
var PHI_SQ    = 2.6180339887498948482;   /* φ² — SCC minimum, loss aversion   */
var PHI_CU    = 4.2360679774997896964;   /* φ³ — sovereign-grade compression  */
var AMOR      = 0.3819660112501051518;   /* φ⁻² — love constant               */
var HEARTBEAT = 873;                     /* ms — Kuramoto φ-phase period       */

/* Substrate multipliers */
var SUBSTRATE = { ICP:1.0, BLOCKCHAIN:1.0, EDGE:PHI, CLOUD:PHI_SQ, PHANTOM:PHI_CU };

/* CUSCO: sovereign root identifier */
var CUSCO = 'SOVEREIGN::FUSION::MAGNA — sovereign_factory + agi_main';

/* ════════════════════════════════════════════════════════════════════════════
   §2  COR PARVUM — MiniHeart (873ms Kuramoto φ-oscillator)
════════════════════════════════════════════════════════════════════════════ */

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase += (2 * Math.PI * PHI_INV) / 100;
  if (kernelPhase >= 2 * Math.PI) kernelPhase -= 2 * Math.PI;
}

/* ════════════════════════════════════════════════════════════════════════════
   §3  CEREBRUM COMPOSITUM — CompositeMiniBrain (memory + executive dominant)
════════════════════════════════════════════════════════════════════════════ */

var BRAIN_REGIONS = [
  { name:'Memory',    activation:0.0, naturalFreq:0.08 },
  { name:'Assoc',     activation:0.0, naturalFreq:0.10 },
  { name:'Executive', activation:0.0, naturalFreq:0.12 },
  { name:'Language',  activation:0.0, naturalFreq:0.09 },
  { name:'Pattern',   activation:0.0, naturalFreq:0.11 },
];

var coherenceField  = 0.0;
var fleetCoherences = {};  /* Map<id, coherence> from other workers */

function tickBrain(kuramotoR) {
  var total = 0;
  for (var i = 0; i < BRAIN_REGIONS.length; i++) {
    var r = BRAIN_REGIONS[i];
    var noise = (Math.random() - 0.5) * 0.1;
    r.activation = Math.max(0, Math.min(1,
      r.activation * PHI_INV + kuramotoR * (1 - PHI_INV) + noise
    ));
    total += r.activation;
  }
  coherenceField = Math.min(1.0, total / BRAIN_REGIONS.length * PHI_INV + kuramotoR * PHI_INV);
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  QUIPU ENGINE (Paper VI)
════════════════════════════════════════════════════════════════════════════ */

var QUIPU_CAP    = 4096;
var quipuRecords = [];
var nextQuipuId  = 1;
var totalKnot    = 0;

var VALID_SPINES   = ['ECONOMY','ROUTING','PRODUCTION','GOVERNANCE','SENTINEL','QUIPU_META'];
var VALID_PENDANTS = ['SIGNAL','ACTION','TELEMETRY','TRIBUTE','RELAY','ARTIFACT'];

function quipuAppend(spine, pendant, depth, value, colorTag, emitter, reason, parentId) {
  if (quipuRecords.length >= QUIPU_CAP) return null;
  parentId = parentId || 0;
  var rec = {
    id: nextQuipuId++,
    spine: spine, pendant: pendant,
    depth: Math.min(3, Math.max(0, depth)),
    value: value, colorTag: colorTag, emitter: emitter, reason: reason,
    status: 'PENDING', parentId: parentId,
    createdAt: Date.now(), executedAt: 0, settledAt: 0,
  };
  quipuRecords.push(rec);
  totalKnot += value;
  return rec;
}

function quipuClaim(id, executor) {
  var rec = quipuRecords.find(function(r){ return r.id === id; });
  if (!rec || rec.status !== 'PENDING') return false;
  rec.status = 'EXECUTING';
  rec.executedAt = Date.now();
  rec.emitter = rec.emitter + ' → ' + executor;
  return true;
}

function quipuSettle(id, outcome) {
  var rec = quipuRecords.find(function(r){ return r.id === id; });
  if (!rec || rec.status !== 'EXECUTING') return false;
  rec.status = 'SETTLED';
  rec.settledAt = Date.now();
  rec.reason = rec.reason + ' | SETTLED: ' + outcome;
  return true;
}

function quipuGetPending(limit) {
  return quipuRecords.filter(function(r){ return r.status === 'PENDING'; }).slice(0, limit || 20);
}

function quipuGetMetrics() {
  var pending   = quipuRecords.filter(function(r){ return r.status === 'PENDING';   }).length;
  var executing = quipuRecords.filter(function(r){ return r.status === 'EXECUTING'; }).length;
  var settled   = quipuRecords.filter(function(r){ return r.status === 'SETTLED';   }).length;
  var cancelled = quipuRecords.filter(function(r){ return r.status === 'CANCELLED'; }).length;
  return {
    totalRecords: quipuRecords.length,
    pending: pending, executing: executing, settled: settled, cancelled: cancelled,
    totalKnotValue: totalKnot,
    compressionRatio: quipuRecords.length / (36 * PHI),
    phi: PHI,
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  QHAPAQ ÑAN MESH (Paper VI — Chasqui routing)
════════════════════════════════════════════════════════════════════════════ */

var TAMBO_CAP    = 512;
var tamboMsgs    = [];
var nextMsgId    = 1;
var meshBeat     = 0;
var totalFwd     = 0;
var totalExpired = 0;

function meshStore(fromSub, toSub, payload, priority, ttl) {
  if (tamboMsgs.length >= TAMBO_CAP) return null;
  var msg = {
    id: nextMsgId++, fromSubstrate: fromSub, toSubstrate: toSub,
    payload: payload, priority: priority || 0.5, ttlBeats: ttl || 0,
    status: 'STORED', storedAt: meshBeat, forwardedAt: 0, createdAt: Date.now(),
  };
  tamboMsgs.push(msg);
  return msg;
}

function meshForward(id) {
  var msg = tamboMsgs.find(function(m){ return m.id === id; });
  if (!msg) return { success: false, reason: 'NOT_FOUND' };
  if (msg.status !== 'STORED') return { success: false, reason: msg.status };
  if (msg.ttlBeats > 0 && meshBeat > msg.storedAt + msg.ttlBeats) {
    msg.status = 'EXPIRED'; totalExpired++;
    return { success: false, reason: 'EXPIRED' };
  }
  msg.status = 'FORWARDED'; msg.forwardedAt = meshBeat; totalFwd++;
  return { success: true, reason: 'FORWARDED' };
}

function meshRoute(fromSub, toSub, payload, directAvailable, priority, ttl) {
  var cost = Math.abs((SUBSTRATE[toSub] || 1) - (SUBSTRATE[fromSub] || 1)) * PHI;
  if (directAvailable !== false) {
    quipuAppend('ROUTING','RELAY',0,cost,toSub,'QHAPAQ_NAN',
      'Direct route ' + fromSub + '→' + toSub + ' cost=' + cost.toFixed(3));
    return { directRouted: true, cost: cost };
  }
  var msg = meshStore(fromSub, toSub, payload, priority, ttl);
  return { directRouted: false, tamboId: msg ? msg.id : null, cost: cost };
}

function meshGetStatus() {
  var stored = tamboMsgs.filter(function(m){ return m.status === 'STORED'; }).length;
  return {
    totalMessages: tamboMsgs.length, stored: stored,
    forwarded: totalFwd, expired: totalExpired, currentBeat: meshBeat,
    substrateMultipliers: SUBSTRATE,
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §6  TAWANTINSUYU HUB (Paper VI — 4-suyu partitioner)
════════════════════════════════════════════════════════════════════════════ */

var SUYU_KEYWORDS = {
  HANAN: ['math','phi','fibonacci','golden','spiral','compute','calculate','number','ratio','geometry','antifragil','kuramoto','sync','coherence'],
  ANTI:  ['data','record','log','memory','store','document','archive','quipu','history','knowledge','classify','register','ledger'],
  CUNTI: ['build','create','deploy','structure','construct','architect','replicate','generate','design','forge','spawn','produce'],
  QULLA: ['route','relay','network','propagate','substrate','edge','cloud','phantom','icp','message','connect','tambo','forward'],
};

var SUYU_DOMAINS = {
  HANAN: { quechua:'HANAN SUYU', organism:'CHRYSALIS', domain:'GOLDEN MATHEMATICS', compass:'UPPER' },
  ANTI:  { quechua:'ANTI SUYU',  organism:'SCRIBE',    domain:'DATA AND RECORDS',   compass:'EAST'  },
  CUNTI: { quechua:'CUNTI SUYU', organism:'ARCHITECT', domain:'BUILDING AND STRUCTURE', compass:'WEST' },
  QULLA: { quechua:'QULLA SUYU', organism:'NEXUS',     domain:'ROUTING AND PROPAGATION', compass:'SOUTH' },
};

function hubClassify(query) {
  var q = query.toLowerCase();
  var scores = { HANAN:0, ANTI:0, CUNTI:0, QULLA:0 };
  var suyus = Object.keys(SUYU_KEYWORDS);
  for (var si = 0; si < suyus.length; si++) {
    var suyu = suyus[si];
    var kws = SUYU_KEYWORDS[suyu];
    for (var ki = 0; ki < kws.length; ki++) {
      if (q.indexOf(kws[ki]) !== -1) scores[suyu]++;
    }
  }
  var best = 'ANTI'; var bestScore = -1;
  for (var s in scores) {
    if (scores[s] > bestScore) { bestScore = scores[s]; best = s; }
  }
  var total = scores.HANAN + scores.ANTI + scores.CUNTI + scores.QULLA || 1;
  return { suyu: best, domain: SUYU_DOMAINS[best], confidence: Math.min(1, bestScore / total) };
}

function hubDispatch(query) {
  var cl = hubClassify(query);
  var qr = quipuAppend('ROUTING','ACTION',0,cl.confidence,cl.suyu,'TAWANTINSUYU',
    'Dispatch to ' + cl.domain.quechua + ': query="' + query.slice(0,64) + '"');
  return { suyu: cl.suyu, domain: cl.domain, confidence: cl.confidence, cusco: CUSCO, quipuRecord: qr };
}

/* ════════════════════════════════════════════════════════════════════════════
   §7  BEHAVIORAL ECONOMICS (Paper V — Laws L-72 to L-79)
════════════════════════════════════════════════════════════════════════════ */

var LAMBDA = PHI_SQ;     /* L-72: loss aversion λ = φ² */
var PROB_A = PHI_INV;    /* L-73: Prelec α = φ⁻¹       */
var ANCH_W = PHI_INV;    /* L-74: anchoring weight      */
var SQ_COST = 1-PHI_INV; /* L-75: switching cost 38.2%  */
var FRAME_M = 1+(1-PHI_INV); /* L-76: frame multiplier */
var AVAIL_W = PHI_INV*PHI_INV; /* L-77: availability   */
var HYPER_K = PHI_INV;   /* L-78: hyperbolic k          */
var SUNK_R  = PHI_INV;   /* L-79: sunk cost resistance  */

function prelecWeight(p) {
  p = Math.max(1e-6, Math.min(1-1e-6, p));
  return Math.exp(-Math.pow(-Math.log(p), PROB_A));
}

function prospectValue(gl) {
  var a = PHI_INV;
  if (gl >= 0) return Math.pow(gl, a);
  return -LAMBDA * Math.pow(-gl, a);
}

function applyBehavioralLaws(rawScore, gainLoss, probability, refPoint, currentState, frameValence, recency, delay, sunkCost) {
  var s = Math.max(0, Math.min(1, rawScore));
  /* L-72 */ var wg  = Math.max(0, Math.min(1, s + prospectValue(gainLoss || 0) * PHI_INV));
  /* L-73 */ var pp  = Math.max(0, Math.min(1, s * prelecWeight(probability || s || 0.5)));
  /* L-74 */ var av  = Math.max(0, Math.min(1, ANCH_W * (refPoint || PHI_INV) + (1-ANCH_W)*s));
  /* L-75 */ var sqc = SQ_COST * Math.abs(s - (currentState || s));
  /* L-76 */ var fv  = Math.max(0, Math.min(1, s * (1 + (frameValence||0)*(FRAME_M-1)*0.5)));
  /* L-77 */ var avb = AVAIL_W * Math.max(0, Math.min(1, recency || 0));
  /* L-78 */ var ds  = Math.max(0, Math.min(1, s / (1 + HYPER_K*(delay||0))));
  /* L-79 */ var skp = SUNK_R * Math.max(0, Math.min(1, sunkCost||0)) * 0.2;

  var composite = Math.max(0, Math.min(1,
    wg*PHI_INV + pp*(1-PHI_INV)*PHI_INV + av*(1-PHI_INV)*(1-PHI_INV)*PHI_INV
    + (s-sqc)*0.05 + fv*0.05 + (s+avb*s)*0.03 + ds*0.04 + (s-skp)*0.02
  ));
  return { adjustedScore: composite, weightedGain: wg, perceivedProb: pp, anchoredValue: av };
}

/* ════════════════════════════════════════════════════════════════════════════
   §8  ANTIFRAGILITY ENGINE (Papers II+III)
════════════════════════════════════════════════════════════════════════════ */

var immuneMemory     = [];
var totalStress      = 0;
var antifragileCount = 0;
var robustCount      = 0;
var fragileCount     = 0;

function applyStressor(v, name) {
  switch(name) {
    case 'GAUSSIAN_NOISE':    return v + (Math.random()-0.5)*2*0.3*v;
    case 'SPIKE_UP':          return v*(1+PHI*0.3);
    case 'SPIKE_DOWN':        return v*(1-0.3);
    case 'LATENCY_DELAY':     return v*PHI_INV;
    case 'ENTROPY_INJECTION': return v + Math.random()*0.1*v;
    case 'LOAD_DOUBLING':     return v*2.0;
    case 'SUBSTRATE_CUT':     return v*(1-PHI_INV);
    default:                  return v + (Math.random()-0.5)*0.2*v;
  }
}

var STRESSOR_NAMES = ['GAUSSIAN_NOISE','SPIKE_UP','SPIKE_DOWN','LATENCY_DELAY','ENTROPY_INJECTION','LOAD_DOUBLING','SUBSTRATE_CUT'];

function stressTest(value, stressorName) {
  totalStress++;
  var sName = stressorName || STRESSOR_NAMES[Math.floor(Math.random()*STRESSOR_NAMES.length)];
  var stressed = applyStressor(value, sName);
  var delta = stressed - value;
  var fragility = Math.max(-1, Math.min(1, delta / (Math.abs(value)+1e-10)));
  var fragClass = fragility > 0.05 ? 'ANTIFRAGILE' : fragility < -0.05 ? 'FRAGILE' : 'ROBUST';
  var survived  = fragility >= -0.5;
  var resilience = Math.max(0, Math.min(1, 1 - Math.abs(fragility)));
  var gain = fragClass === 'ANTIFRAGILE' ? Math.max(0, Math.min(PHI, fragility*PHI)) : 0;

  if (fragClass === 'ANTIFRAGILE') antifragileCount++;
  else if (fragClass === 'FRAGILE') fragileCount++;
  else robustCount++;

  if (immuneMemory.length >= 64) immuneMemory.shift();
  immuneMemory.push({ stressor:sName, fragility:fragility, survived:survived, gain:gain, ts:Date.now() });

  return { originalValue:value, stressedValue:stressed, delta:delta, fragility:fragility,
           fragClass:fragClass, resilience:resilience, antifragileGain:gain, stressorApplied:sName };
}

function applyResilienceBoost(value, sr) {
  return isFinite(value) ? value + sr.antifragileGain * PHI_INV : value;
}

function getImmuneStatus() {
  var total = totalStress || 1;
  var ratio = antifragileCount / total;
  return {
    totalStressTests: totalStress, antifragileCount: antifragileCount,
    robustCount: robustCount, fragileCount: fragileCount,
    antifragileRatio: Math.min(1, ratio),
    healthVerdict: ratio > 0.5 ? 'ANTIFRAGILE — gains from disorder'
                 : ratio > 0.2 ? 'ROBUST — absorbs disorder'
                 :               'FRAGILE — needs barbell hardening',
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §9  FRACTAL SOVEREIGNTY — Kuramoto synchronization (Paper IV)
════════════════════════════════════════════════════════════════════════════ */

var OSC_POOL = [
  { phase:0.0, natFreq:0.12, coupling:PHI_INV, amplitude:1.0  },
  { phase:1.0, natFreq:0.08, coupling:PHI_INV, amplitude:0.9  },
  { phase:2.0, natFreq:0.05, coupling:PHI_INV, amplitude:0.8  },
  { phase:3.0, natFreq:0.10, coupling:PHI_INV, amplitude:0.85 },
  { phase:4.0, natFreq:0.13, coupling:PHI_INV, amplitude:0.95 },
  { phase:5.0, natFreq:0.09, coupling:PHI_INV, amplitude:0.75 },
];

function kuramotoR() {
  var n = OSC_POOL.length;
  var sc=0, ss=0;
  for (var i=0; i<n; i++) {
    sc += Math.cos(OSC_POOL[i].phase) * OSC_POOL[i].amplitude;
    ss += Math.sin(OSC_POOL[i].phase) * OSC_POOL[i].amplitude;
  }
  return Math.max(0, Math.min(1, Math.sqrt(sc*sc+ss*ss)/n));
}

function tickOscillators() {
  var r = kuramotoR();
  var psi = Math.atan2(
    OSC_POOL.reduce(function(s,o){ return s+Math.sin(o.phase)*o.amplitude; },0),
    OSC_POOL.reduce(function(s,o){ return s+Math.cos(o.phase)*o.amplitude; },0)
  );
  var K = PHI_INV, dt = 0.01;
  for (var i=0; i<OSC_POOL.length; i++) {
    var o = OSC_POOL[i];
    o.phase += (o.natFreq + K*r*Math.sin(psi-o.phase)) * dt;
    o.phase %= 2*Math.PI;
  }
  return kuramotoR();
}

/* ════════════════════════════════════════════════════════════════════════════
   §10  LINGUA COMPRESSA (PROT-051)
════════════════════════════════════════════════════════════════════════════ */

var SCC_MIN = PHI_SQ;   /* φ² — minimum SCC for valid transmission */

var STOP_WORDS_LC = new Set([
  'the','a','an','is','are','was','were','be','been','being',
  'have','has','had','do','does','did','will','would','could','should',
  'may','might','shall','can','need','dare','ought','used',
  'i','we','you','he','she','it','they','them','us','our','your','his',
  'her','its','their','this','that','these','those','what','which',
  'who','whom','whose','when','where','why','how',
  'and','but','or','nor','for','yet','so','at','by','in','on','to',
  'up','with','of','from','into','about','than','then','there',
]);

var FIB_LENS_LC = [1,1,2,3,5,8,13,21];

function fnv1a(text) {
  var h = 0x811c9dc5;
  for (var i=0; i<text.length; i++) {
    h ^= text.charCodeAt(i);
    h = Math.imul(h, 0x01000193) >>> 0;
  }
  return h.toString(16).padStart(8,'0');
}

function linguaCompress(text) {
  if (!text || !text.trim()) return { scc:0, tokens:[], quipuHash:fnv1a(''), originalLength:0, compressedLength:0, ratio:0, valid:false, protocol:'PROT-051' };
  var hash = fnv1a(text);
  var rawWords = text.trim().split(/\s+/);
  var lex = text.toLowerCase().replace(/[^a-z0-9\s]/g,' ').split(/\s+/).filter(function(w){ return w.length>0 && !STOP_WORDS_LC.has(w); });
  var fibbed = [];
  var pos=0, fi=0;
  while (pos < lex.length) {
    var sz = FIB_LENS_LC[fi % FIB_LENS_LC.length];
    fibbed.push(lex.slice(pos, pos+sz).join('·'));
    pos += sz; fi++;
  }
  var compressed = fibbed.join(' ') || ' ';
  var scc = (rawWords.length / (fibbed.length||1)) * PHI;
  var ratio = text.length / (compressed.length||1);
  return { scc: Math.min(100,scc), tokens: fibbed, quipuHash: hash,
           originalLength: text.length, compressedLength: compressed.length,
           ratio: Math.min(100,ratio), valid: scc >= SCC_MIN, protocol:'PROT-051' };
}

/* ════════════════════════════════════════════════════════════════════════════
   §11  TERRACE BENCH (Paper VI — isolated substrate experiments)
════════════════════════════════════════════════════════════════════════════ */

var TERRACES = {
  ICP:        { substrate:'ICP',        multiplier:1.0,   yields:[], avgYield:0, experiments:0,
                agents:['GOL-MEMORIA-001','GOL-COMPUTATIO-001','GOL-CUSTODIA-001'],
                conditions:{ latencyMs:2000, computeUnits:1.0, consensus:1.0, privacy:0.8 } },
  BLOCKCHAIN: { substrate:'BLOCKCHAIN', multiplier:1.0,   yields:[], avgYield:0, experiments:0,
                agents:['GOL-COMMERCIUM-001','GOL-GUBERNATIO-001'],
                conditions:{ latencyMs:3000, computeUnits:1.0, consensus:0.9, privacy:0.6 } },
  EDGE:       { substrate:'EDGE',       multiplier:PHI,   yields:[], avgYield:0, experiments:0,
                agents:['GOL-TEMPUS-001','GOL-SPATIUM-001','GOL-COMMUNICATIO-001'],
                conditions:{ latencyMs:50, computeUnits:PHI, consensus:0.7, privacy:0.7 } },
  CLOUD:      { substrate:'CLOUD',      multiplier:PHI_SQ,yields:[], avgYield:0, experiments:0,
                agents:['GOL-ORACULUM-001','GOL-PROPHETIA-001','GOL-LUX-001','GOL-HARMONIA-001'],
                conditions:{ latencyMs:200, computeUnits:PHI_SQ, consensus:0.8, privacy:0.5 } },
  PHANTOM:    { substrate:'PHANTOM',    multiplier:PHI_CU,yields:[], avgYield:0, experiments:0,
                agents:['GOL-QUANTUM-001','GOL-PHANTOMA-001','GOL-POTENTIA-001'],
                conditions:{ latencyMs:500, computeUnits:PHI_CU, consensus:1.0, privacy:1.0 } },
};

function terraceExperiment(substrate, agent, score) {
  var tier = TERRACES[substrate] || TERRACES.ICP;
  var yv   = Math.max(0, Math.min(10, score * tier.multiplier * (1 + tier.conditions.privacy * PHI_INV)));
  if (tier.yields.length >= 8) tier.yields.shift();
  tier.yields.push(yv);
  tier.avgYield = tier.yields.reduce(function(s,v){ return s+v; },0) / tier.yields.length;
  tier.experiments++;
  var qr = quipuAppend('PRODUCTION','ARTIFACT',1,yv,substrate,agent,
    'Terrace['+substrate+'] exp#'+tier.experiments+' score='+score.toFixed(3)+' yield='+yv.toFixed(3));
  return { tier:tier, yieldDelta:yv, quipuRecord:qr };
}

/* ════════════════════════════════════════════════════════════════════════════
   §12  PAPER REGISTRY — all 6 papers + 51+ protocols
════════════════════════════════════════════════════════════════════════════ */

var PAPER_ENGINES = [
  { id:'PAPER-II-III',     engine:'ANTIFRAGILITY',       layer:'IMMUNE',    suyu:'HANAN', phi:PHI },
  { id:'PAPER-IV',         engine:'FRACTAL_SOVEREIGNTY', layer:'SYNC',      suyu:'HANAN', phi:PHI_INV },
  { id:'PAPER-V',          engine:'BEHAVIORAL_ECON',     layer:'ECONOMICS', suyu:'CUNTI', phi:PHI_SQ },
  { id:'PAPER-VI-QUIPU',   engine:'QUIPU_ENGINE',        layer:'MEMORY',    suyu:'ANTI',  phi:PHI_INV },
  { id:'PAPER-VI-QHAPAQ',  engine:'QHAPAQ_NAN',          layer:'ROUTING',   suyu:'QULLA', phi:PHI },
  { id:'PAPER-VI-TAWANTIN',engine:'TAWANTINSUYU',        layer:'TOPOLOGY',  suyu:'CUNTI', phi:PHI_CU },
  { id:'PAPER-VI-TERRACE', engine:'TERRACE_BENCH',       layer:'TESTING',   suyu:'HANAN', phi:PHI_SQ },
  { id:'PROT-051',         engine:'LINGUA_COMPRESSA',    layer:'PROTOCOL',  suyu:'ANTI',  phi:PHI_SQ },
];

/* ════════════════════════════════════════════════════════════════════════════
   §13  FUSION CORE — FUSE operation (all engines, closed loop)
════════════════════════════════════════════════════════════════════════════ */

var fusionBeat = 0;

function fusionFuse(query, substrate, gainLoss, delay, priority) {
  fusionBeat++;
  var quipuIds = [];

  /* 1. TAWANTINSUYU: classify suyu */
  var dispatch = hubDispatch(query);
  if (dispatch.quipuRecord) quipuIds.push(dispatch.quipuRecord.id);

  /* 2. LINGUA COMPRESSA: compress query */
  var compressed = linguaCompress(query);

  /* 3. FRACTAL SOVEREIGNTY: tick → coherence */
  var r = tickOscillators();

  /* 4. Raw score */
  var rawScore = Math.max(0, Math.min(1,
    r * PHI_INV + dispatch.confidence*(1-PHI_INV)*PHI_INV + (compressed.valid ? AMOR : 0)
  ));

  /* 5. BEHAVIORAL ECONOMICS: L-72–79 */
  var beh = applyBehavioralLaws(rawScore, gainLoss||0, rawScore, PHI_INV, rawScore,
                                (gainLoss||0)>=0?1:-1, r, delay||0, 0);

  /* 6. ANTIFRAGILITY: stress test */
  var sr = stressTest(beh.adjustedScore);
  var boosted = applyResilienceBoost(beh.adjustedScore, sr);

  /* 7. TERRACE BENCH: run experiment */
  var sub = substrate || 'ICP';
  var terr = terraceExperiment(sub, 'FUSIO_MAGNA', beh.adjustedScore);
  if (terr.quipuRecord) quipuIds.push(terr.quipuRecord.id);

  /* 8. QUIPU: log the fusion record */
  var qr = quipuAppend('PRODUCTION','ACTION',0,boosted,dispatch.suyu,'GOL-FUSIO-001',
    'fuse(): suyu='+dispatch.suyu+' score='+boosted.toFixed(4)+
    ' fragility='+sr.fragClass+' scc='+compressed.scc.toFixed(2)+
    ' r='+r.toFixed(3));
  if (qr) { quipuClaim(qr.id,'FUSIO_MAGNA'); quipuIds.push(qr.id); }

  return {
    query: query, suyu: dispatch.suyu, suyuDomain: dispatch.domain.quechua,
    rawScore: rawScore, behavioralScore: beh.adjustedScore,
    antifragileClass: sr.fragClass, antifragileGain: sr.antifragileGain,
    compressedQuery: { scc: compressed.scc, valid: compressed.valid, tokens: compressed.tokens },
    kuramotoR: r, terraceYield: terr.yieldDelta,
    quipuIds: quipuIds, fusionTimestampMs: 0, phi: PHI,
  };
}

function fusionSynthesize(results) {
  if (!results.length) return { inputs:[], avgBehavioral:0, avgAntifragile:0, avgKuramotoR:0, dominantSuyu:'ANTI', sovereignVerdict:'NO_DATA', phi:PHI };
  var avgB = results.reduce(function(s,r){ return s+r.behavioralScore; },0)/results.length;
  var avgA = results.reduce(function(s,r){ return s+r.antifragileGain; },0)/results.length;
  var avgR = results.reduce(function(s,r){ return s+(r.kuramotoR||0); },0)/results.length;
  var suyuCnt = {};
  results.forEach(function(r){ suyuCnt[r.suyu] = (suyuCnt[r.suyu]||0)+1; });
  var dom = Object.keys(suyuCnt).sort(function(a,b){ return suyuCnt[b]-suyuCnt[a]; })[0];
  var verdict = avgR > PHI_INV ? 'SOVEREIGN_COHERENT' : avgR > 0.3 ? 'PARTIALLY_SYNCHRONIZED' : 'DESYNCHRONIZED';
  var h = 0x811c9dc5;
  results.forEach(function(r){ for(var i=0;i<r.query.length;i++){ h^=r.query.charCodeAt(i); h=Math.imul(h,0x01000193)>>>0; } });
  return { inputs:results, avgBehavioral:avgB, avgAntifragile:avgA, avgKuramotoR:avgR,
           dominantSuyu:dom, sovereignVerdict:verdict, quipuHash:h.toString(16).padStart(8,'0'), phi:PHI };
}

function fusionAudit() {
  return {
    quipuMetrics:  quipuGetMetrics(),
    pending:       quipuGetPending(10),
    meshStatus:    meshGetStatus(),
    immuneStatus:  getImmuneStatus(),
    fusionBeat:    fusionBeat,
    kuramotoR:     kuramotoR(),
    paperCount:    PAPER_ENGINES.length,
    cusco:         CUSCO,
  };
}

function fusionManifest() {
  return {
    identity:    'NOVA FUSION ORGANISM — All Papers, One Living System',
    kernelId:    KERNEL_ID, kernelFamily: KERNEL_FAMILY,
    buildNumber: 30, fusionBeat: fusionBeat,
    papers:      PAPER_ENGINES,
    cusco:       CUSCO,
    phi:         PHI,
    architecture:'QuipuEngine(memory)→QhapaqNan(routing)→Tawantinsuyu(topology)→'
               +'BehavioralEcon(decisions)→Antifragility(resilience)→'
               +'FractalSov(coherence)→LinguaCompressa(compression)→TerraceBench(testing)',
    terraces:    Object.values(TERRACES),
    meshStatus:  meshGetStatus(),
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §14  HEARTBEAT LOOP
════════════════════════════════════════════════════════════════════════════ */

function heartbeat() {
  if (!running) return;
  tickHeart();
  meshBeat++;
  var r = tickOscillators();
  tickBrain(r);

  /* Write a periodic telemetry record to quipu */
  if (beatCount % 5 === 0) {
    quipuAppend('SENTINEL','TELEMETRY',0,r,'FUSION_BEAT','GOL-FUSIO-001',
      'heartbeat #'+beatCount+' r='+r.toFixed(4)+' coherence='+coherenceField.toFixed(4));
  }

  self.postMessage({
    type:    'heartbeat',
    beat:    beatCount,
    phase:   kernelPhase,
    phi:     PHI,
    brain:   { regions: BRAIN_REGIONS, coherenceField: coherenceField },
    fusion:  {
      fusionBeat:      fusionBeat,
      kuramotoR:       r,
      quipuTotal:      quipuRecords.length,
      quipuPending:    quipuGetPending(5).length,
      tamboStored:     tamboMsgs.filter(function(m){ return m.status==='STORED'; }).length,
      immuneHealth:    getImmuneStatus().healthVerdict,
    },
  });
}

_hbi = setInterval(heartbeat, HEARTBEAT);

/* ════════════════════════════════════════════════════════════════════════════
   §15  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var d = e.data;
  if (!d) return;

  switch (d.type) {

    case 'FUSE': {
      var result = fusionFuse(d.query||'', d.substrate, d.gainLoss, d.delay, d.priority);
      self.postMessage({ type:'fuse_result', result: result });
      break;
    }

    case 'SYNTHESIZE': {
      var report = fusionSynthesize(d.results||[]);
      self.postMessage({ type:'synthesize_result', report: report });
      break;
    }

    case 'ROUTE': {
      var rr = meshRoute(d.fromSubstrate||'ICP', d.toSubstrate||'ICP',
                         d.payload||'', d.directAvailable, d.priority, d.ttlBeats);
      self.postMessage({ type:'route_result', result: rr });
      break;
    }

    case 'AUDIT': {
      self.postMessage({ type:'audit_result', audit: fusionAudit() });
      break;
    }

    case 'QUIPU_LOG': {
      var qr = quipuAppend(d.spine||'QUIPU_META', d.pendant||'TELEMETRY',
                           d.depth||0, d.value||0, d.colorTag||'USER',
                           d.emitter||'EXTERNAL', d.reason||'manual log', d.parentId||0);
      self.postMessage({ type:'quipu_result', record: qr });
      break;
    }

    case 'TERRACE_TEST': {
      var tr = terraceExperiment(d.substrate||'ICP', d.agent||'EXTERNAL', d.score||0);
      self.postMessage({ type:'terrace_result', result: tr });
      break;
    }

    case 'SUYU_DISPATCH': {
      var sd = hubDispatch(d.query||'');
      self.postMessage({ type:'suyu_result', dispatch: sd });
      break;
    }

    case 'MANIFEST': {
      self.postMessage({ type:'manifest_result', manifest: fusionManifest() });
      break;
    }

    case 'COMPRESS': {
      var cm = linguaCompress(d.text||'');
      self.postMessage({ type:'compress_result', compressed: cm });
      break;
    }

    case 'STRESS_TEST': {
      var sr2 = stressTest(d.value||0, d.stressor);
      self.postMessage({ type:'stress_result', result: sr2 });
      break;
    }

    case 'FLEET_COHERENCE': {
      if (d.nodeId) fleetCoherences[d.nodeId] = d.coherence || 0;
      break;
    }

    case 'GET_STATUS':
    case 'status': {
      self.postMessage({
        type:'status', alive:true, kernelId:KERNEL_ID, family:KERNEL_FAMILY,
        beat:beatCount, fusionBeat:fusionBeat, kuramotoR:kuramotoR(),
        coherence:coherenceField, cusco:CUSCO,
      });
      break;
    }

    case 'stop': {
      running = false;
      if (_hbi) { clearInterval(_hbi); _hbi = null; }
      self.postMessage({ type:'stopped', kernelId:KERNEL_ID });
      break;
    }
  }
};
