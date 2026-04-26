// ─── NOVA / PARALLAX — FusionOrganism ────────────────────────────────────────
// Master orchestrator: wires all 6 paper engines into one callable organism.
// Phase 1 of the Grand Fusion Plan — the "mod organism" that holds all
// knowledge simultaneously.
//
// The FusionOrganism closes the feedback loop:
//
//   1. QuipuEngine     logs everything (memory)
//   2. QhapaqNanMesh   routes all queries (bandwidth)
//   3. TawantinsuyuHub partitions load across 4 domains (topology)
//   4. BehavioralEcon  weights all decisions (economics L-72–79)
//   5. Antifragility   stress-tests all outputs (resilience)
//   6. FractalSov      synchronizes all engines at φ Hz (coherence)
//   7. LinguaCompressa compresses all communication at SCC≥φ² (efficiency)
//   8. TerraceBench    isolates experiments per substrate (testing)
//
// That loop is self-sustaining. The organism reads its own quipu,
// routes via its own roads, decides via its own economic laws, survives
// stress via its own antifragility, and speaks its own compressed language.
//
// Operations exposed:
//   fuse()          — run a query through all engines in sequence
//   synthesize()    — produce a synthesis report from a set of inputs
//   route()         — route a message through QhapaqNanMesh
//   audit()         — return full quipu audit trail
//   quipuLog()      — manually append a quipu record
//   terraceTest()   — run an isolated substrate experiment
//   suyuDispatch()  — classify and dispatch a query to the right suyu
//   manifest()      — return full organism manifest and status
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { PHI, PHI_INV, clamp } from '../math/core';

// Paper engines
import { stressTest, scoreResult, applyResilienceBoost, getImmuneStatus } from '../math/antifragility';
import { applyBehavioralLaws, DecisionInput }                               from '../math/behavioral-economics';
import {
  quipuGetMetrics,
  hubDispatch, hubGetTopology,
  meshRoute, meshGetStatus, meshAdvanceBeat,
  terraceRunExperiment, terraceGetMetadata, terraceGetBest,
  Substrate, Suyu,
} from '../math/quipu-engine';
import { compress, validateSCC, getLinguaStatus }                           from '../math/lingua-compressa';
import { computeAmplitudeOrderParameter, KuramotoOscillator }               from '../math/kuramoto';

// Fusion orchestration
import {
  fusionLog, fusionExecutive, fusionClaim, fusionSettle, fusionGetStatus,
  fusionGetPending, fusionGetByEngine, fusionGetBySpine, fusionQuipuReset,
  PaperEngine,
} from './FusionQuipu';
import { PAPER_REGISTRY, PROTOCOL_REGISTRY, getRegistryStatus, PaperDescriptor } from './PaperRegistry';

// ── Types ─────────────────────────────────────────────────────────────────────

export interface FuseRequest {
  query:          string;
  context?:       Record<string, unknown>;
  substrate?:     Substrate;
  priority?:      number;      // [0,1]
  delay?:         number;      // periods for hyperbolic discounting
  gainLoss?:      number;      // signed: + gain, - loss
}

export interface FuseResult {
  query:            string;
  suyu:             Suyu;
  suyuDomain:       string;
  rawScore:         number;
  behavioralScore:  number;
  antifragileClass: string;
  antifragileGain:  number;
  compressedQuery:  { scc: number; valid: boolean; tokens: string[] };
  kuramotoR:        number;      // coherence field (order parameter)
  terraceYield:     number;
  quipuIds:         number[];    // IDs of records written to quipu
  fusionTimestampMs:number;
  phi:              number;
}

export interface SynthesisReport {
  inputs:          FuseResult[];
  avgBehavioral:   number;
  avgAntifragile:  number;
  avgKuramotoR:    number;
  dominantSuyu:    string;
  sovereignVerdict:string;
  quipuHash:       string;     // FNV-1a of all input queries
  phi:             number;
}

// ── Internal oscillator pool (drives FractalSovereignty sync) ─────────────────

const OSCILLATOR_POOL: KuramotoOscillator[] = [
  { phase: 0.0, naturalFreq: 0.12, coupling: PHI_INV, amplitude: 1.0 },  // BRAIN
  { phase: 1.0, naturalFreq: 0.08, coupling: PHI_INV, amplitude: 0.9 },  // HEART
  { phase: 2.0, naturalFreq: 0.05, coupling: PHI_INV, amplitude: 0.8 },  // LUNGS
  { phase: 3.0, naturalFreq: 0.10, coupling: PHI_INV, amplitude: 0.85 }, // GUT
  { phase: 4.0, naturalFreq: 0.13, coupling: PHI_INV, amplitude: 0.95 }, // SPINE
  { phase: 5.0, naturalFreq: 0.09, coupling: PHI_INV, amplitude: 0.75 }, // THYMUS
];

let fusionBeat = 0;

// Step oscillators by one φ-tick (NEURO_DT ≈ 873ms equivalent)
function tickOscillators(): number {
  const K = PHI_INV;     // coupling coefficient
  const dt = 0.01;       // integration step
  const { r: rPrev, psi } = computeAmplitudeOrderParameter(OSCILLATOR_POOL);

  for (const osc of OSCILLATOR_POOL) {
    const coupling = K * rPrev * Math.sin(psi - osc.phase);
    osc.phase += (osc.naturalFreq + coupling) * dt;
    osc.phase %= 2 * Math.PI;
  }
  fusionBeat++;
  meshAdvanceBeat();

  const { r } = computeAmplitudeOrderParameter(OSCILLATOR_POOL);
  return r;
}

// ── Core: fuse() — run a query through all engines ───────────────────────────

export async function fuse(request: FuseRequest): Promise<FuseResult> {
  const start = Date.now();
  const quipuIds: number[] = [];

  // 1. TAWANTINSUYU: Classify and dispatch to the right suyu
  const dispatch = hubDispatch(request.query);
  if (dispatch.quipuRecord) quipuIds.push(dispatch.quipuRecord.id);

  // 2. LINGUA COMPRESSA: Compress the query (SCC ≥ φ²)
  const compressed = compress(request.query);
  const { valid: sccValid } = validateSCC(compressed);

  // 3. FRACTAL SOVEREIGNTY: Tick oscillators to get current coherence
  const kuramotoR = tickOscillators();

  // 4. Raw score: composite of coherence + dispatch confidence + SCC validity
  const rawScore = clamp(
    kuramotoR * PHI_INV
    + dispatch.confidence * (1 - PHI_INV) * PHI_INV
    + (sccValid ? PHI_INV * PHI_INV : 0),
    0, 1
  );

  // 5. BEHAVIORAL ECONOMICS: Apply laws L-72–79
  const decisionInput: DecisionInput = {
    rawScore,
    gainLoss:       request.gainLoss    ?? 0,
    probability:    clamp(rawScore, 0.01, 0.99),
    referencePoint: PHI_INV,             // φ⁻¹ is the sovereign reference
    currentState:   rawScore,
    frameValence:   (request.gainLoss ?? 0) >= 0 ? 1 : -1,
    recencyBias:    kuramotoR,            // recent coherence = recency signal
    delay:          request.delay        ?? 0,
    sunkCost:       0,                   // sovereign organisms resist sunk cost
  };
  const behavioral = applyBehavioralLaws(decisionInput);

  // 6. ANTIFRAGILITY: Stress-test the behavioral score
  const stressResult = stressTest(behavioral.adjustedScore);
  const boosted = applyResilienceBoost(behavioral.adjustedScore, stressResult);

  // 7. TERRACE BENCH: Run on the appropriate substrate
  const substrate = request.substrate ?? 'ICP';
  const terraceResult = terraceRunExperiment(substrate, 'FUSION_ORGANISM', behavioral.adjustedScore);
  if (terraceResult.quipuRecord) quipuIds.push(terraceResult.quipuRecord.id);

  // 8. FUSION QUIPU: Log the full fusion result
  const qr = fusionLog(
    'FUSION_ORGANISM', 'PRODUCTION', 'ACTION', 0,
    boosted, dispatch.suyu,
    `fuse(): suyu=${dispatch.suyu} score=${boosted.toFixed(4)} fragility=${stressResult.fragClass} scc=${compressed.scc.toFixed(2)}`,
  );
  if (qr) quipuIds.push(qr.quipu.id);

  return {
    query:            request.query,
    suyu:             dispatch.suyu,
    suyuDomain:       dispatch.domain.quechua,
    rawScore,
    behavioralScore:  behavioral.adjustedScore,
    antifragileClass: stressResult.fragClass,
    antifragileGain:  stressResult.antifragileGain,
    compressedQuery:  { scc: compressed.scc, valid: sccValid, tokens: compressed.tokens },
    kuramotoR,
    terraceYield:     terraceResult.yieldDelta,
    quipuIds,
    fusionTimestampMs: Date.now() - start,
    phi:              PHI,
  };
}

// ── Synthesize: produce a synthesis report from multiple fuse results ─────────

export function synthesize(results: FuseResult[]): SynthesisReport {
  if (!results.length) {
    return {
      inputs: [], avgBehavioral: 0, avgAntifragile: 0, avgKuramotoR: 0,
      dominantSuyu: 'ANTI', sovereignVerdict: 'NO_DATA',
      quipuHash: '00000000', phi: PHI,
    };
  }

  const avgBehavioral  = results.reduce((s, r) => s + r.behavioralScore, 0)  / results.length;
  const avgAntifragile = results.reduce((s, r) => s + r.antifragileGain, 0)  / results.length;
  const avgKuramotoR   = results.reduce((s, r) => s + r.kuramotoR, 0)        / results.length;

  // Dominant suyu: most frequent
  const suyuCounts: Record<string, number> = {};
  for (const r of results) suyuCounts[r.suyu] = (suyuCounts[r.suyu] || 0) + 1;
  const dominantSuyu = Object.entries(suyuCounts).sort((a, b) => b[1] - a[1])[0][0];

  const sovereignVerdict = avgKuramotoR > PHI_INV
    ? 'SOVEREIGN_COHERENT'
    : avgKuramotoR > 0.3
    ? 'PARTIALLY_SYNCHRONIZED'
    : 'DESYNCHRONIZED';

  // Quipu hash: FNV-1a over all query strings
  let h = 0x811c9dc5;
  for (const r of results) {
    for (let i = 0; i < r.query.length; i++) {
      h ^= r.query.charCodeAt(i);
      h = Math.imul(h, 0x01000193) >>> 0;
    }
  }
  const quipuHash = h.toString(16).padStart(8, '0');

  // Log synthesis to fusion quipu
  fusionLog('FUSION_ORGANISM', 'GOVERNANCE', 'TELEMETRY', 0,
    avgBehavioral, dominantSuyu,
    `synthesize(): n=${results.length} avgBeh=${avgBehavioral.toFixed(3)} r=${avgKuramotoR.toFixed(3)} verdict=${sovereignVerdict}`,
  );

  return {
    inputs: results, avgBehavioral, avgAntifragile, avgKuramotoR,
    dominantSuyu, sovereignVerdict, quipuHash, phi: PHI,
  };
}

// ── Route: send a message through QhapaqNanMesh ───────────────────────────────

export function route(
  fromSubstrate: Substrate,
  toSubstrate:   Substrate,
  payload:       string,
  directAvailable = true,
): ReturnType<typeof meshRoute> {
  const result = meshRoute(fromSubstrate, toSubstrate, payload, directAvailable);
  fusionLog('QHAPAQ_NAN', 'ROUTING', 'RELAY', 0,
    result.cost, toSubstrate,
    `route(): ${fromSubstrate}→${toSubstrate} direct=${result.directRouted} cost=${result.cost.toFixed(3)}`,
  );
  return result;
}

// ── Audit: return quipu audit trail ──────────────────────────────────────────

export function audit(): {
  fusionStatus:  ReturnType<typeof fusionGetStatus>;
  pending:       ReturnType<typeof fusionGetPending>;
  meshStatus:    ReturnType<typeof meshGetStatus>;
  immuneStatus:  ReturnType<typeof getImmuneStatus>;
  quipuMetrics:  ReturnType<typeof quipuGetMetrics>;
  registryStatus:ReturnType<typeof getRegistryStatus>;
  fusionBeat:    number;
} {
  return {
    fusionStatus:   fusionGetStatus(),
    pending:        fusionGetPending(10),
    meshStatus:     meshGetStatus(),
    immuneStatus:   getImmuneStatus(),
    quipuMetrics:   quipuGetMetrics(),
    registryStatus: getRegistryStatus(),
    fusionBeat,
  };
}

// ── quipuLog: manually append a record ───────────────────────────────────────

export { fusionLog as quipuLog, fusionGetByEngine, fusionGetBySpine, fusionGetPending };

// ── terraceTest: run isolated substrate experiment ────────────────────────────

export function terraceTest(substrate: Substrate, score: number): {
  tier:      ReturnType<typeof terraceGetBest>['tier'];
  yield:     number;
  substrate: Substrate;
  bestTier:  ReturnType<typeof terraceGetBest>;
} {
  const result = terraceRunExperiment(substrate, 'FUSION_ORGANISM', score);
  fusionLog('TERRACE_BENCH', 'PRODUCTION', 'ARTIFACT', 1,
    result.yieldDelta, substrate,
    `terraceTest(${substrate}): score=${score.toFixed(3)} yield=${result.yieldDelta.toFixed(3)}`,
  );
  return {
    tier:      result.tier,
    yield:     result.yieldDelta,
    substrate,
    bestTier:  terraceGetBest(),
  };
}

// ── suyuDispatch: classify and dispatch ───────────────────────────────────────

export function suyuDispatch(query: string): ReturnType<typeof hubDispatch> {
  const result = hubDispatch(query);
  fusionLog('TAWANTINSUYU', 'ROUTING', 'ACTION', 0,
    result.confidence, result.suyu,
    `suyuDispatch(): suyu=${result.suyu} conf=${result.confidence.toFixed(3)}`,
  );
  return result;
}

// ── manifest: full organism manifest ─────────────────────────────────────────

export function manifest(): {
  identity:       string;
  buildNumber:    number;
  fusionBeat:     number;
  papers:         PaperDescriptor[];
  protocolCount:  number;
  implementedProtocols: number;
  topology:       ReturnType<typeof hubGetTopology>;
  terraces:       ReturnType<typeof terraceGetMetadata>;
  lingua:         ReturnType<typeof getLinguaStatus>;
  phi:            number;
  cusco:          string;
  architecture:   string;
} {
  const reg = getRegistryStatus();
  return {
    identity:             'NOVA FUSION ORGANISM — All Papers, One Living System',
    buildNumber:          30,
    fusionBeat,
    papers:               PAPER_REGISTRY,
    protocolCount:        reg.protocolCount,
    implementedProtocols: reg.implementedProtocols,
    topology:             hubGetTopology(),
    terraces:             terraceGetMetadata(),
    lingua:               getLinguaStatus(),
    phi:                  PHI,
    cusco:                'SOVEREIGN::FUSION::MAGNA — sovereign_factory + agi_main',
    architecture:
      'QuipuEngine(memory)→QhapaqNan(routing)→Tawantinsuyu(topology)→' +
      'BehavioralEcon(decisions)→Antifragility(resilience)→' +
      'FractalSov(coherence)→LinguaCompressa(compression)→TerraceBench(testing)',
  };
}

// ── reset (for test isolation) ────────────────────────────────────────────────

export function fusionReset(): void {
  fusionQuipuReset();
  fusionBeat = 0;
}
