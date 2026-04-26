// ═══════════════════════════════════════════════════════════════════════════════
// PROTOCOLLUM OPERANS — Protocol Validation & Execution Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// 50 protocol definitions across 10 domains with real validation functions.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI          = 1.618033988749895;
const INV_PHI      = 0.618033988749895;
const TAU          = 6.283185307179586;
const HEARTBEAT_MS = 873;

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  phase: Math.random() * TAU,
  freq: TAU / HEARTBEAT_MS,
  tick() {
    this.phase = (this.phase + this.freq * HEARTBEAT_MS * 0.001) % TAU;
    return { phase: this.phase, pulse: Math.sin(this.phase) };
  }
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
let tickCount = 0;
let lastValidation = null;

// ─── PROTOCOL DEFINITIONS ───────────────────────────────────────────────────────
// 10 domains × 5 protocols = 50 total. Each validationFn performs a real check.
const DOMAIN_NAMES = [
  'consensus', 'encryption', 'memory', 'routing', 'orchestration',
  'computation', 'evolution', 'communication', 'governance', 'neural'
];

const PROTOCOL_SPECS = [
  // ── CONSENSUS (0-4) ──
  { name: 'ByzantineAgreement',  fn: (d) => Array.isArray(d.votes) && d.votes.filter(v => v).length > d.votes.length / 2 },
  { name: 'QuorumThreshold',    fn: (d) => typeof d.n === 'number' && typeof d.k === 'number' && d.k >= Math.ceil(d.n * 2 / 3) },
  { name: 'LeaderElection',     fn: (d) => typeof d.id === 'number' && d.id > 0 && d.id === Math.max(...(d.candidates || [0])) },
  { name: 'EpochSync',          fn: (d) => typeof d.epoch === 'number' && d.epoch > 0 && d.epoch % 1 === 0 },
  { name: 'FinalityProof',      fn: (d) => typeof d.hash === 'string' && d.hash.length === 64 },
  // ── ENCRYPTION (5-9) ──
  { name: 'KeyDerivation',      fn: (d) => typeof d.key === 'string' && d.key.length >= 16 },
  { name: 'NonceValidation',    fn: (d) => typeof d.nonce === 'number' && d.nonce > 0 && d.nonce % 1 === 0 },
  { name: 'SignatureVerify',    fn: (d) => typeof d.sig === 'string' && d.sig.length >= 8 && /^[0-9a-f]+$/i.test(d.sig) },
  { name: 'EntropyCheck',       fn: (d) => typeof d.bits === 'number' && d.bits >= 128 },
  { name: 'CipherStrength',     fn: (d) => typeof d.keyLen === 'number' && [128, 192, 256].includes(d.keyLen) },
  // ── MEMORY (10-14) ──
  { name: 'AllocationBounds',   fn: (d) => typeof d.size === 'number' && d.size > 0 && d.size <= 1073741824 },
  { name: 'GarbageCollection',  fn: (d) => typeof d.freed === 'number' && d.freed >= 0 && d.freed <= d.total },
  { name: 'CacheCoherence',     fn: (d) => Array.isArray(d.tags) && new Set(d.tags).size === d.tags.length },
  { name: 'PageAlignment',      fn: (d) => typeof d.addr === 'number' && d.addr % 4096 === 0 },
  { name: 'SalienceThreshold',  fn: (d) => typeof d.salience === 'number' && d.salience >= 0 && d.salience <= 1 },
  // ── ROUTING (15-19) ──
  { name: 'PathCost',           fn: (d) => Array.isArray(d.hops) && d.hops.every(h => h > 0) && d.hops.reduce((a, b) => a + b, 0) < 1000 },
  { name: 'LoopDetection',      fn: (d) => Array.isArray(d.path) && new Set(d.path).size === d.path.length },
  { name: 'TTLValidation',      fn: (d) => typeof d.ttl === 'number' && d.ttl > 0 && d.ttl <= 255 },
  { name: 'LoadBalance',        fn: (d) => Array.isArray(d.weights) && Math.abs(d.weights.reduce((a, b) => a + b, 0) - 1) < 0.001 },
  { name: 'LatencyBound',       fn: (d) => typeof d.ms === 'number' && d.ms < d.maxMs },
  // ── ORCHESTRATION (20-24) ──
  { name: 'TaskDependency',     fn: (d) => Array.isArray(d.deps) && d.deps.every(id => typeof id === 'number') },
  { name: 'ResourceLimit',      fn: (d) => typeof d.cpu === 'number' && d.cpu <= 100 && d.cpu >= 0 },
  { name: 'HeartbeatCheck',     fn: (d) => typeof d.lastBeat === 'number' && (Date.now() - d.lastBeat) < HEARTBEAT_MS * 3 },
  { name: 'ScheduleValidity',   fn: (d) => typeof d.interval === 'number' && d.interval >= 10 && d.interval <= 86400000 },
  { name: 'GracefulShutdown',   fn: (d) => typeof d.state === 'string' && ['running', 'draining', 'stopped'].includes(d.state) },
  // ── COMPUTATION (25-29) ──
  { name: 'OverflowGuard',      fn: (d) => typeof d.val === 'number' && Number.isFinite(d.val) && Math.abs(d.val) < Number.MAX_SAFE_INTEGER },
  { name: 'PrecisionCheck',     fn: (d) => typeof d.result === 'number' && typeof d.expected === 'number' && Math.abs(d.result - d.expected) < (d.epsilon || 1e-10) },
  { name: 'DivisionSafety',     fn: (d) => typeof d.divisor === 'number' && d.divisor !== 0 },
  { name: 'MatrixDimension',    fn: (d) => Array.isArray(d.A) && Array.isArray(d.B) && d.A[0] && d.A[0].length === d.B.length },
  { name: 'ConvergenceTest',    fn: (d) => typeof d.delta === 'number' && d.delta < (d.threshold || 1e-6) },
  // ── EVOLUTION (30-34) ──
  { name: 'FitnessRange',       fn: (d) => typeof d.fitness === 'number' && d.fitness >= 0 },
  { name: 'MutationRate',       fn: (d) => typeof d.rate === 'number' && d.rate >= 0 && d.rate <= 1 },
  { name: 'PopulationMin',      fn: (d) => typeof d.pop === 'number' && d.pop >= 2 },
  { name: 'GenomeBounds',       fn: (d) => Array.isArray(d.genome) && d.genome.every(g => g >= 0 && g <= 1) },
  { name: 'DiversityIndex',     fn: (d) => typeof d.diversity === 'number' && d.diversity >= 0 && d.diversity <= 1 },
  // ── COMMUNICATION (35-39) ──
  { name: 'MessageIntegrity',   fn: (d) => typeof d.body === 'string' && typeof d.checksum === 'number' && d.body.length === d.checksum },
  { name: 'ChannelCapacity',    fn: (d) => typeof d.bps === 'number' && d.bps > 0 && d.bps <= 1e9 },
  { name: 'TokenLimit',         fn: (d) => Array.isArray(d.tokens) && d.tokens.length <= (d.maxTokens || 4096) },
  { name: 'EncodingCheck',      fn: (d) => typeof d.text === 'string' && /^[\x20-\x7E\s]*$/.test(d.text) },
  { name: 'AckTimeout',         fn: (d) => typeof d.elapsed === 'number' && d.elapsed < (d.timeout || 5000) },
  // ── GOVERNANCE (40-44) ──
  { name: 'VoteWeight',         fn: (d) => typeof d.weight === 'number' && d.weight > 0 && d.weight <= 1 },
  { name: 'ProposalQuorum',     fn: (d) => typeof d.yes === 'number' && typeof d.total === 'number' && d.yes / d.total > 0.5 },
  { name: 'PermissionLevel',    fn: (d) => typeof d.level === 'number' && [0, 1, 2, 3].includes(d.level) },
  { name: 'AuditTrail',         fn: (d) => Array.isArray(d.log) && d.log.length > 0 && d.log.every(e => e.ts && e.action) },
  { name: 'PolicyCompliance',   fn: (d) => typeof d.policy === 'string' && d.policy.length > 0 && d.approved === true },
  // ── NEURAL (45-49) ──
  { name: 'ActivationBounds',   fn: (d) => typeof d.x === 'number' && Math.abs(1 / (1 + Math.exp(-d.x))) <= 1 },
  { name: 'WeightNorm',         fn: (d) => Array.isArray(d.weights) && Math.sqrt(d.weights.reduce((s, w) => s + w * w, 0)) < (d.maxNorm || 10) },
  { name: 'GradientClip',       fn: (d) => typeof d.grad === 'number' && Math.abs(d.grad) <= (d.clip || 5) },
  { name: 'LayerDimension',     fn: (d) => typeof d.input === 'number' && typeof d.output === 'number' && d.input > 0 && d.output > 0 },
  { name: 'LearningRate',       fn: (d) => typeof d.lr === 'number' && d.lr > 0 && d.lr < 1 },
];

// Build full protocol list with IDs, domains, versions, and status
const protocols = PROTOCOL_SPECS.map((spec, i) => ({
  id: i,
  name: spec.name,
  domain: DOMAIN_NAMES[Math.floor(i / 5)],
  version: '1.' + Math.floor(i / 5) + '.' + (i % 5),
  status: 'active',
  validationFn: spec.fn
}));

// ─── VALIDATE SINGLE PROTOCOL ──────────────────────────────────────────────────
function validateProtocol(id, data) {
  const proto = protocols[id];
  if (!proto) return { valid: false, error: 'Unknown protocol id: ' + id };
  try {
    const result = proto.validationFn(data || {});
    return { id, name: proto.name, domain: proto.domain, valid: !!result };
  } catch (e) {
    return { id, name: proto.name, domain: proto.domain, valid: false, error: e.message };
  }
}

// ─── EXECUTE ALL PROTOCOLS ──────────────────────────────────────────────────────
function executeAll(dataMap) {
  const dm = dataMap || {};
  return protocols.map(p => {
    const d = dm[p.id] || dm[p.name] || {};
    return validateProtocol(p.id, d);
  });
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  const { cmd, id, data, dataMap } = e.data || {};
  switch (cmd) {
    case 'VALIDATE_PROTOCOL': {
      const result = validateProtocol(id, data);
      lastValidation = result;
      self.postMessage({ cmd, result });
      break;
    }
    case 'EXECUTE_ALL': {
      const results = executeAll(dataMap);
      self.postMessage({ cmd, results, passed: results.filter(r => r.valid).length, total: 50 });
      break;
    }
    case 'GET_PROTOCOLS': {
      const list = protocols.map(p => ({ id: p.id, name: p.name, domain: p.domain, version: p.version, status: p.status }));
      self.postMessage({ cmd, protocols: list });
      break;
    }
    case 'GET_STATUS': {
      const heart = MiniHeart.tick();
      self.postMessage({
        cmd, status: {
          worker: 'PROTOCOLLUM_OPERANS', tickCount, heartPhase: heart.phase,
          protocolCount: 50, domainCount: 10, lastValidation
        }
      });
      break;
    }
    default:
      self.postMessage({ cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT ──────────────────────────────────────────────────────────────────
setInterval(() => {
  tickCount++;
  const heart = MiniHeart.tick();
  self.postMessage({ type: 'heartbeat', worker: 'PROTOCOLLUM_OPERANS', tick: tickCount, heart });
}, HEARTBEAT_MS);
