// ─── NOVA / PARALLAX — Paper VI Engines: Quipu, Qhapaq Ñan, Tawantinsuyu, Terrace ──
// Paper VI: The Inca organism engines — memory, routing, topology, test benches.
//
// Four engines from Paper VI:
//
//   QuipuEngine      — typed, hierarchical, append-only, executable memory log
//                      SPINE→PENDANT→SUBSIDIARY→KNOT(value)|COLOR(tag)
//                      Lifecycle: PENDING → EXECUTING → SETTLED | CANCELLED
//
//   QhapaqNanMesh    — chasqui message routing across the 5-substrate road network
//                      Store-and-forward: when direct route fails, buffer at tambo,
//                      forward when connectivity resumes
//
//   TawantinsuyuHub  — 4-suyu load partitioner anchored to CUSCO root
//                      Routes any query to the right engine/domain based on
//                      the query's natural suyu (HANAN/ANTI/CUNTI/QULLA)
//
//   TerraceBench     — isolated per-substrate experiment context
//                      Each φ-tier substrate = a controlled micro-climate
//                      Parameterized: what agents run, what conditions, what yields
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, PHI, PHI_INV } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// QUIPU ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export type QuipuStatus = 'PENDING' | 'EXECUTING' | 'SETTLED' | 'CANCELLED';
export type QuipuSpine  = 'ECONOMY' | 'ROUTING' | 'PRODUCTION' | 'GOVERNANCE' | 'SENTINEL' | 'QUIPU_META';
export type QuipuPendant = 'SIGNAL' | 'ACTION' | 'TELEMETRY' | 'TRIBUTE' | 'RELAY' | 'ARTIFACT';

export interface QuipuRecord {
  id:         number;
  spine:      QuipuSpine;
  pendant:    QuipuPendant;
  depth:      number;       // 0 = spine-level, 1 = pendant, 2 = subsidiary, 3 = sub-subsidiary
  value:      number;       // knot value (positionally encoded magnitude)
  colorTag:   string;       // type system: sub-token, substrate, organism, or entity
  emitter:    string;       // source engine/canister name
  reason:     string;       // human-readable description
  status:     QuipuStatus;
  parentId:   number;       // 0 = no parent (top-level)
  createdAt:  number;
  executedAt: number;
  settledAt:  number;
}

const QUIPU_CAP = 4096;
let quipuRecords: QuipuRecord[] = [];
let nextQuipuId = 1;
let totalKnotValue = 0;

function isValidSpine(s: string): s is QuipuSpine {
  return ['ECONOMY','ROUTING','PRODUCTION','GOVERNANCE','SENTINEL','QUIPU_META'].includes(s);
}
function isValidPendant(p: string): p is QuipuPendant {
  return ['SIGNAL','ACTION','TELEMETRY','TRIBUTE','RELAY','ARTIFACT'].includes(p);
}

// Append a new PENDING record to the quipu
export function quipuAppend(
  spine:    QuipuSpine,
  pendant:  QuipuPendant,
  depth:    number,
  value:    number,
  colorTag: string,
  emitter:  string,
  reason:   string,
  parentId  = 0,
): QuipuRecord | null {
  if (quipuRecords.length >= QUIPU_CAP) return null;
  if (!isValidSpine(spine) || !isValidPendant(pendant)) return null;
  const rec: QuipuRecord = {
    id: nextQuipuId++,
    spine, pendant,
    depth: Math.min(3, Math.max(0, depth)),
    value, colorTag, emitter, reason,
    status:     'PENDING',
    parentId,
    createdAt:  Date.now(),
    executedAt: 0,
    settledAt:  0,
  };
  quipuRecords.push(rec);
  totalKnotValue += value;
  return rec;
}

// Claim a PENDING record → EXECUTING (atomic in single-threaded JS)
export function quipuClaim(id: number, executor: string): boolean {
  const rec = quipuRecords.find(r => r.id === id);
  if (!rec || rec.status !== 'PENDING') return false;
  rec.status = 'EXECUTING';
  rec.executedAt = Date.now();
  rec.emitter = `${rec.emitter} → ${executor}`;
  return true;
}

// Settle an EXECUTING record → SETTLED (immutable audit trail)
export function quipuSettle(id: number, outcome: string): boolean {
  const rec = quipuRecords.find(r => r.id === id);
  if (!rec || rec.status !== 'EXECUTING') return false;
  rec.status = 'SETTLED';
  rec.settledAt = Date.now();
  rec.reason = `${rec.reason} | SETTLED: ${outcome}`;
  return true;
}

// Cancel a PENDING record
export function quipuCancel(id: number, reason: string): boolean {
  const rec = quipuRecords.find(r => r.id === id);
  if (!rec || rec.status !== 'PENDING') return false;
  rec.status = 'CANCELLED';
  rec.reason = `${rec.reason} | CANCELLED: ${reason}`;
  return true;
}

// Query PENDING records (the instruction queue)
export function quipuGetPending(limit = 20): QuipuRecord[] {
  return quipuRecords.filter(r => r.status === 'PENDING').slice(0, limit);
}

// Query by spine domain
export function quipuGetBySpine(spine: QuipuSpine, limit = 50): QuipuRecord[] {
  return quipuRecords.filter(r => r.spine === spine).slice(0, limit);
}

// Query by color tag
export function quipuGetByColor(colorTag: string, limit = 50): QuipuRecord[] {
  return quipuRecords.filter(r => r.colorTag === colorTag).slice(0, limit);
}

// Get subsidiaries of a parent
export function quipuGetSubsidiaries(parentId: number): QuipuRecord[] {
  return quipuRecords.filter(r => r.parentId === parentId && parentId !== 0);
}

// Compression metrics (φ-normalized information density)
export function quipuGetMetrics(): {
  totalRecords: number;
  pending: number;
  executing: number;
  settled: number;
  cancelled: number;
  totalKnotValue: number;
  compressionRatio: number;
  phi: number;
} {
  const pending   = quipuRecords.filter(r => r.status === 'PENDING').length;
  const executing = quipuRecords.filter(r => r.status === 'EXECUTING').length;
  const settled   = quipuRecords.filter(r => r.status === 'SETTLED').length;
  const cancelled = quipuRecords.filter(r => r.status === 'CANCELLED').length;
  // 6 spines × 6 pendants = 36 distinct categories
  const ratio = quipuRecords.length / (36 * PHI);
  return {
    totalRecords: quipuRecords.length,
    pending, executing, settled, cancelled,
    totalKnotValue,
    compressionRatio: clamp(ratio, 0, 10),
    phi: PHI,
  };
}

export function quipuReset(): void {
  quipuRecords = [];
  nextQuipuId = 1;
  totalKnotValue = 0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// QHAPAQ ÑAN MESH (Chasqui routing)
// ═══════════════════════════════════════════════════════════════════════════════

export type Substrate = 'ICP' | 'BLOCKCHAIN' | 'EDGE' | 'CLOUD' | 'PHANTOM';

export interface ChasquiMessage {
  id:            number;
  fromSubstrate: Substrate;
  toSubstrate:   Substrate;
  payload:       string;
  priority:      number;    // [0,1] — higher = more urgent
  ttlBeats:      number;    // 0 = no expiry
  status:        'STORED' | 'FORWARDED' | 'EXPIRED';
  storedAt:      number;    // beat when stored
  forwardedAt:   number;
  createdAt:     number;
}

// Substrate φ-multipliers (compute pricing tier)
const SUBSTRATE_MULTIPLIER: Record<Substrate, number> = {
  ICP:        1.0,
  BLOCKCHAIN: 1.0,
  EDGE:       PHI,
  CLOUD:      PHI * PHI,
  PHANTOM:    PHI * PHI * PHI,
};

const TAMBO_CAP = 512;
let tamboMessages: ChasquiMessage[] = [];
let nextMessageId = 1;
let currentBeat = 0;
let totalForwarded = 0;
let totalExpired = 0;

// Advance the beat counter (called by heartbeat)
export function meshAdvanceBeat(): void { currentBeat++; }

// Store a message at the tambo (when direct routing fails)
export function meshStore(
  fromSubstrate: Substrate,
  toSubstrate:   Substrate,
  payload:       string,
  priority       = 0.5,
  ttlBeats       = 0,
): ChasquiMessage | null {
  if (tamboMessages.length >= TAMBO_CAP) return null;
  const msg: ChasquiMessage = {
    id: nextMessageId++,
    fromSubstrate, toSubstrate, payload, priority, ttlBeats,
    status:      'STORED',
    storedAt:    currentBeat,
    forwardedAt: 0,
    createdAt:   Date.now(),
  };
  tamboMessages.push(msg);
  return msg;
}

// Forward a stored message (connectivity resumed)
export function meshForward(id: number): { success: boolean; reason: string } {
  const msg = tamboMessages.find(m => m.id === id);
  if (!msg) return { success: false, reason: 'NOT_FOUND' };
  if (msg.status !== 'STORED') return { success: false, reason: msg.status };
  if (msg.ttlBeats > 0 && currentBeat > msg.storedAt + msg.ttlBeats) {
    msg.status = 'EXPIRED';
    totalExpired++;
    return { success: false, reason: 'EXPIRED' };
  }
  msg.status = 'FORWARDED';
  msg.forwardedAt = currentBeat;
  totalForwarded++;
  return { success: true, reason: 'FORWARDED' };
}

// Route a message: attempt direct routing or store at tambo
export function meshRoute(
  fromSubstrate: Substrate,
  toSubstrate:   Substrate,
  payload:       string,
  directAvailable = true,
  priority = 0.5,
  ttlBeats = 0,
): { directRouted: boolean; tamboId?: number; cost: number } {
  const cost = Math.abs(SUBSTRATE_MULTIPLIER[toSubstrate] - SUBSTRATE_MULTIPLIER[fromSubstrate]) * PHI;
  if (directAvailable) {
    // Log the successful route to quipu
    quipuAppend('ROUTING', 'RELAY', 0, cost, toSubstrate, 'QHAPAQ_NAN',
      `Direct route ${fromSubstrate}→${toSubstrate} cost=${cost.toFixed(3)}`);
    return { directRouted: true, cost };
  }
  // Connectivity failed → store at tambo
  const msg = meshStore(fromSubstrate, toSubstrate, payload, priority, ttlBeats);
  if (msg) {
    quipuAppend('ROUTING', 'RELAY', 1, cost, toSubstrate, 'TAMBO',
      `Tambo buffered ${fromSubstrate}→${toSubstrate} msgId=${msg.id}`);
  }
  return { directRouted: false, tamboId: msg?.id, cost };
}

// Sweep expired tambos
export function meshSweepExpired(): number {
  let expired = 0;
  for (const msg of tamboMessages) {
    if (msg.status === 'STORED' && msg.ttlBeats > 0 && currentBeat > msg.storedAt + msg.ttlBeats) {
      msg.status = 'EXPIRED';
      totalExpired++;
      expired++;
    }
  }
  return expired;
}

// Get pending messages for a destination substrate (chasqui pickup)
export function meshGetPendingFor(toSubstrate: Substrate): ChasquiMessage[] {
  return tamboMessages.filter(m => m.toSubstrate === toSubstrate && m.status === 'STORED');
}

export function meshGetStatus(): {
  totalMessages: number;
  stored: number;
  forwarded: number;
  expired: number;
  currentBeat: number;
  substrateMultipliers: Record<Substrate, number>;
} {
  const stored = tamboMessages.filter(m => m.status === 'STORED').length;
  return {
    totalMessages: tamboMessages.length,
    stored, forwarded: totalForwarded, expired: totalExpired,
    currentBeat,
    substrateMultipliers: SUBSTRATE_MULTIPLIER,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAWANTINSUYU HUB (4-Suyu load partitioner)
// ═══════════════════════════════════════════════════════════════════════════════

export type Suyu = 'HANAN' | 'ANTI' | 'CUNTI' | 'QULLA';

export interface SuyuDomain {
  quechua:    string;
  compass:    string;
  organism:   string;
  domain:     string;
  mission:    string;
  keywords:   string[];  // query routing keywords
}

const SUYU_MAP: Record<Suyu, SuyuDomain> = {
  HANAN: {
    quechua:  'HANAN SUYU',
    compass:  'UPPER / NORTH',
    organism: 'CHRYSALIS',
    domain:   'GOLDEN MATHEMATICS',
    mission:  'φ-math, Fibonacci, spiral, sacred geometry — pure number',
    keywords: ['math','phi','fibonacci','golden','spiral','compute','calculate','number','ratio','geometry'],
  },
  ANTI: {
    quechua:  'ANTI SUYU',
    compass:  'EAST',
    organism: 'SCRIBE',
    domain:   'DATA AND RECORDS',
    mission:  'Document, classify, synthesize — eastern scribal domain',
    keywords: ['data','record','log','memory','store','document','archive','quipu','history','knowledge'],
  },
  CUNTI: {
    quechua:  'CUNTI SUYU',
    compass:  'WEST',
    organism: 'ARCHITECT',
    domain:   'BUILDING AND STRUCTURE',
    mission:  'Build, replicate, construct — western structural domain',
    keywords: ['build','create','deploy','structure','construct','architect','replicate','generate','design','forge'],
  },
  QULLA: {
    quechua:  'QULLA SUYU',
    compass:  'SOUTH',
    organism: 'NEXUS',
    domain:   'ROUTING AND PROPAGATION',
    mission:  'Route, relay, propagate — southern network domain',
    keywords: ['route','relay','network','propagate','substrate','edge','cloud','phantom','icp','message','connect'],
  },
};

// Classify a query into its natural suyu
export function hubClassify(query: string): { suyu: Suyu; domain: SuyuDomain; confidence: number } {
  const q = query.toLowerCase();
  const scores: Record<Suyu, number> = { HANAN: 0, ANTI: 0, CUNTI: 0, QULLA: 0 };

  for (const [suyu, domain] of Object.entries(SUYU_MAP) as [Suyu, SuyuDomain][]) {
    for (const kw of domain.keywords) {
      if (q.includes(kw)) scores[suyu] += 1;
    }
  }

  // Default to ANTI (data/records) if no match — the Scribe always knows
  let best: Suyu = 'ANTI';
  let bestScore = -1;
  for (const [suyu, score] of Object.entries(scores) as [Suyu, number][]) {
    if (score > bestScore) { bestScore = score; best = suyu; }
  }

  const total = Object.values(scores).reduce((a, b) => a + b, 0) || 1;
  const confidence = clamp(bestScore / total, 0, 1);

  return { suyu: best, domain: SUYU_MAP[best], confidence };
}

// Dispatch a query to the right suyu, return routing metadata
export function hubDispatch(query: string): {
  suyu:        Suyu;
  domain:      SuyuDomain;
  confidence:  number;
  cusco:       string;  // root anchor
  quipuRecord: QuipuRecord | null;
} {
  const { suyu, domain, confidence } = hubClassify(query);

  // Log the dispatch to quipu
  const qr = quipuAppend(
    'ROUTING', 'ACTION', 0,
    confidence, suyu, 'TAWANTINSUYU_HUB',
    `Dispatch to ${domain.quechua}: query="${query.slice(0, 64)}"`,
  );

  return {
    suyu, domain, confidence,
    cusco: 'SOVEREIGN::FUSION::MAGNA — sovereign_factory + agi_main',
    quipuRecord: qr,
  };
}

export function hubGetTopology(): {
  cusco: string;
  suyus: SuyuDomain[];
  phi:   number;
} {
  return {
    cusco: 'CUSCO — sovereign_factory + agi_main (root, the navel)',
    suyus: Object.values(SUYU_MAP),
    phi:   PHI,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// TERRACE BENCH (Isolated per-substrate experiment context)
// ═══════════════════════════════════════════════════════════════════════════════

export interface TerraceTier {
  substrate:    Substrate;
  multiplier:   number;     // φ-pricing tier
  description:  string;
  agents:       string[];   // which GOL-* agents run in this tier
  conditions:   Record<string, number>;  // parameterized env (latency, compute, etc.)
  yields:       number[];   // rolling 8 yield readings
  avgYield:     number;
  experiments:  number;
  active:       boolean;
}

const TERRACE_TIERS: Record<Substrate, TerraceTier> = {
  ICP: {
    substrate: 'ICP',       multiplier: 1.0,
    description: 'Native ICP substrate — baseline compute, sovereign-grade consensus',
    agents:      ['GOL-MEMORIA-001','GOL-COMPUTATIO-001','GOL-CUSTODIA-001'],
    conditions:  { latencyMs: 2000, computeUnits: 1.0, consensus: 1.0, privacy: 0.8 },
    yields: [], avgYield: 0, experiments: 0, active: true,
  },
  BLOCKCHAIN: {
    substrate: 'BLOCKCHAIN', multiplier: 1.0,
    description: 'General distributed ledger — baseline price, used as commodity',
    agents:      ['GOL-COMMERCIUM-001','GOL-GUBERNATIO-001'],
    conditions:  { latencyMs: 3000, computeUnits: 1.0, consensus: 0.9, privacy: 0.6 },
    yields: [], avgYield: 0, experiments: 0, active: true,
  },
  EDGE: {
    substrate: 'EDGE',       multiplier: PHI,
    description: 'NOVA-EDGE — periphery compute at φ¹ = 1.618×, low latency',
    agents:      ['GOL-TEMPUS-001','GOL-SPATIUM-001','GOL-COMMUNICATIO-001'],
    conditions:  { latencyMs: 50, computeUnits: PHI, consensus: 0.7, privacy: 0.7 },
    yields: [], avgYield: 0, experiments: 0, active: true,
  },
  CLOUD: {
    substrate: 'CLOUD',      multiplier: PHI * PHI,
    description: 'NOVA-CLOUD — cloud infrastructure at φ² = 2.618×, high capacity',
    agents:      ['GOL-ORACULUM-001','GOL-PROPHETIA-001','GOL-LUX-001','GOL-HARMONIA-001'],
    conditions:  { latencyMs: 200, computeUnits: PHI * PHI, consensus: 0.8, privacy: 0.5 },
    yields: [], avgYield: 0, experiments: 0, active: true,
  },
  PHANTOM: {
    substrate: 'PHANTOM',    multiplier: PHI * PHI * PHI,
    description: 'NOVA-PHANTOM — encrypted sovereign substrate at φ³ = 4.236×',
    agents:      ['GOL-QUANTUM-001','GOL-PHANTOMA-001','GOL-POTENTIA-001'],
    conditions:  { latencyMs: 500, computeUnits: PHI * PHI * PHI, consensus: 1.0, privacy: 1.0 },
    yields: [], avgYield: 0, experiments: 0, active: true,
  },
};

// Run an experiment on a specific substrate tier
export function terraceRunExperiment(
  substrate: Substrate,
  agent:     string,
  score:     number,
): { tier: TerraceTier; yieldDelta: number; quipuRecord: QuipuRecord | null } {
  const tier = TERRACE_TIERS[substrate];
  if (!tier) throw new Error(`Unknown substrate: ${substrate}`);

  // Yield = score × φ-multiplier × privacy bonus
  const yieldValue = clamp(score * tier.multiplier * (1 + tier.conditions['privacy'] * PHI_INV), 0, 10);

  // Rolling 8-yield buffer
  if (tier.yields.length >= 8) tier.yields.shift();
  tier.yields.push(yieldValue);
  tier.avgYield = tier.yields.reduce((a, b) => a + b, 0) / tier.yields.length;
  tier.experiments++;

  // Log to quipu
  const qr = quipuAppend(
    'PRODUCTION', 'ARTIFACT', 1,
    yieldValue, substrate, agent,
    `Terrace[${substrate}] exp#${tier.experiments} score=${score.toFixed(3)} yield=${yieldValue.toFixed(3)}`,
  );

  return { tier, yieldDelta: yieldValue, quipuRecord: qr };
}

// Get terrace metadata for all 5 substrates
export function terraceGetMetadata(): TerraceTier[] {
  return Object.values(TERRACE_TIERS);
}

// Get the highest-yield substrate (best micro-climate for this crop)
export function terraceGetBest(): { substrate: Substrate; tier: TerraceTier } {
  let best: Substrate = 'ICP';
  let bestYield = -1;
  for (const [sub, tier] of Object.entries(TERRACE_TIERS) as [Substrate, TerraceTier][]) {
    if (tier.avgYield > bestYield) { bestYield = tier.avgYield; best = sub; }
  }
  return { substrate: best, tier: TERRACE_TIERS[best] };
}
