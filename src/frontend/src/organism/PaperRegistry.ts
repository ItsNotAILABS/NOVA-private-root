// ─── NOVA / PARALLAX — PaperRegistry ─────────────────────────────────────────
// Typed index of all 6 paper engines + 51+ PROT protocol codes.
// This is the NOVA "standard knot convention" — the manifest that maps
// every paper, every protocol code, and every engine into a single queryable
// registry that any part of the organism can consult.
//
// Maps:
//   Papers I–VI       → PaperDescriptor (metadata + engine ref)
//   PROT-001..080     → ProtocolDescriptor (code, category, implementation)
//   6 PaperEngines    → engine function references
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { PHI, PHI_INV } from '../math/core';
import { PaperEngine } from './FusionQuipu';

// ── Paper Descriptor ──────────────────────────────────────────────────────────

export interface PaperDescriptor {
  id:          string;       // e.g. "PAPER-II"
  title:       string;
  engine:      PaperEngine;
  layer:       string;       // organism layer (immune/sync/econ/memory/protocol)
  keywords:    string[];
  inputs:      string[];     // what the engine consumes
  outputs:     string[];     // what the engine produces
  phiConstant: number;       // which φ-power governs this paper
  suyuAffinity:string;       // HANAN / ANTI / CUNTI / QULLA / CUSCO
}

// ── Protocol Descriptor ───────────────────────────────────────────────────────

export interface ProtocolDescriptor {
  code:        string;       // e.g. "PROT-051"
  name:        string;       // e.g. "LINGUA COMPRESSA"
  abbreviation:string;       // e.g. "LC"
  category:    string;       // COGNITION / MEMORY / DEFENSE / ECONOMY / ROUTING / ...
  implemented: boolean;      // is there a TypeScript implementation?
  engine:      PaperEngine | null;
  description: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAPER REGISTRY — All 6 Papers
// ═══════════════════════════════════════════════════════════════════════════════

export const PAPER_REGISTRY: PaperDescriptor[] = [
  {
    id:          'PAPER-II-III',
    title:       'Antifragility and Sovereign Immune Systems',
    engine:      'ANTIFRAGILITY',
    layer:       'IMMUNE — stress response, fragility scoring, barbell strategy',
    keywords:    ['antifragile','stress','fragile','robust','barbell','resilience','immune','taleb'],
    inputs:      ['raw computation results','stressor type','perturbation magnitude'],
    outputs:     ['fragility class','resilience score','antifragile gain','immune memory'],
    phiConstant: PHI,           // φ — golden ratio governs resilience amplification
    suyuAffinity:'HANAN',       // upper realm — pure computation and health
  },
  {
    id:          'PAPER-IV',
    title:       'Fractal Sovereignty: Kuramoto Synchronization at φ Hz',
    engine:      'FRACTAL_SOVEREIGNTY',
    layer:       'SYNC — self-organization, phase coupling, coherence field',
    keywords:    ['kuramoto','synchronization','coherence','oscillator','phase','fractal','sovereignty'],
    inputs:      ['oscillator phases','natural frequencies','coupling strength'],
    outputs:     ['order parameter r','mean phase ψ','synchronization verdict'],
    phiConstant: PHI_INV,       // φ⁻¹ — coherence weight
    suyuAffinity:'HANAN',       // upper realm — mathematical harmony
  },
  {
    id:          'PAPER-V',
    title:       'Behavioral Economics Laws L-72 through L-79',
    engine:      'BEHAVIORAL_ECON',
    layer:       'ECONOMICS — decision weights, loss aversion, probability distortion',
    keywords:    ['behavioral','economics','loss aversion','probability','anchoring','framing','kahneman','tversky'],
    inputs:      ['raw utility score','gain/loss','probability','reference point','delay'],
    outputs:     ['adjusted score','weighted gain','perceived probability','behavioral decision'],
    phiConstant: PHI * PHI,     // φ² — loss aversion coefficient λ
    suyuAffinity:'CUNTI',       // western realm — building economic structures
  },
  {
    id:          'PAPER-VI-QUIPU',
    title:       'QuipuEngine: Hierarchical Executable Memory',
    engine:      'QUIPU_ENGINE',
    layer:       'MEMORY — typed append-only log, PENDING→EXECUTING→SETTLED',
    keywords:    ['quipu','memory','log','ledger','record','append','hierarchy','pendant','spine','knot'],
    inputs:      ['spine domain','pendant type','depth','value','color tag','emitter'],
    outputs:     ['quipu record','pending queue','settled ledger','compression metrics'],
    phiConstant: PHI_INV,       // φ⁻¹ — compression ratio per hierarchy level
    suyuAffinity:'ANTI',        // eastern realm — data and records
  },
  {
    id:          'PAPER-VI-QHAPAQ',
    title:       'QhapaqNanMesh: Chasqui Message Routing Network',
    engine:      'QHAPAQ_NAN',
    layer:       'ROUTING — store-and-forward, tambo waystations, 5-substrate mesh',
    keywords:    ['routing','relay','tambo','chasqui','substrate','mesh','propagate','forward','network'],
    inputs:      ['fromSubstrate','toSubstrate','payload','priority','TTL'],
    outputs:     ['route result','tambo message','forwarding status','mesh status'],
    phiConstant: PHI,           // φ — substrate pricing multiplier base
    suyuAffinity:'QULLA',       // southern realm — routing and propagation
  },
  {
    id:          'PAPER-VI-TAWANTINSUYU',
    title:       'TawantinsuyuHub: 4-Suyu Load Partitioner',
    engine:      'TAWANTINSUYU',
    layer:       'TOPOLOGY — 4-domain partition anchored to CUSCO root',
    keywords:    ['suyu','tawantinsuyu','topology','partition','dispatch','cusco','domain','hub'],
    inputs:      ['query string','context'],
    outputs:     ['suyu assignment','domain metadata','confidence score','quipu record'],
    phiConstant: PHI * PHI * PHI, // φ³ — empire-scale compression
    suyuAffinity:'CUNTI',         // western realm — structure and organization
  },
  {
    id:          'PAPER-VI-TERRACE',
    title:       'TerraceBench: Parameterized Substrate Experiment Contexts',
    engine:      'TERRACE_BENCH',
    layer:       'TESTING — isolated micro-climate per φ-tier substrate',
    keywords:    ['terrace','bench','experiment','substrate','yield','parameterize','isolate','test'],
    inputs:      ['substrate','agent','score'],
    outputs:     ['yield delta','tier metadata','best substrate','experiment log'],
    phiConstant: PHI * PHI,     // φ² — CLOUD tier is the default experiment substrate
    suyuAffinity:'HANAN',       // upper realm — controlled experimentation
  },
  {
    id:          'PROT-051',
    title:       'LINGUA COMPRESSA: Sovereign Communication Protocol',
    engine:      'LINGUA_COMPRESSA',
    layer:       'PROTOCOL — SCC ≥ φ² compression, Fibonacci tokenization, FNV-1a seal',
    keywords:    ['language','compression','protocol','scc','fibonacci','token','lingua','compress'],
    inputs:      ['raw text message'],
    outputs:     ['compressed message','SCC score','quipu hash','validity verdict'],
    phiConstant: PHI * PHI,     // φ² — minimum SCC threshold
    suyuAffinity:'ANTI',        // eastern realm — encoding knowledge
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// PROTOCOL REGISTRY — PROT-001 through PROT-080 (sampled key protocols)
// ═══════════════════════════════════════════════════════════════════════════════

export const PROTOCOL_REGISTRY: ProtocolDescriptor[] = [
  // COGNITION / CONSCIOUSNESS
  { code:'PROT-001', name:'Sovereign Consensus Protocol',    abbreviation:'SCP',  category:'CONSENSUS',    implemented:false, engine:null,                description:'Multi-agent consensus with φ-VP voting weight' },
  { code:'PROT-002', name:'Principal Identity Protocol',     abbreviation:'PIP',  category:'IDENTITY',     implemented:false, engine:null,                description:'Sovereign principal binding and identity sealing' },
  { code:'PROT-003', name:'Organism Messaging Protocol',     abbreviation:'OMP',  category:'MESSAGING',    implemented:false, engine:'QHAPAQ_NAN',        description:'Cross-canister message format and routing' },
  { code:'PROT-004', name:'State Persistence Protocol',      abbreviation:'SPP',  category:'MEMORY',       implemented:false, engine:'QUIPU_ENGINE',      description:'Stable variable management and quipu ledger' },
  { code:'PROT-005', name:'Cycle Compute Protocol',          abbreviation:'CCP',  category:'COMPUTE',      implemented:false, engine:null,                description:'ONESICAN-priced compute allocation at φ-tiers' },
  { code:'PROT-006', name:'Neural Routing Protocol',         abbreviation:'NRP',  category:'ROUTING',      implemented:false, engine:'QHAPAQ_NAN',        description:'5-substrate mesh neural packet routing' },
  { code:'PROT-007', name:'Defense Shield Protocol',         abbreviation:'DSP',  category:'DEFENSE',      implemented:false, engine:'ANTIFRAGILITY',     description:'Antifragile defense: stress → immune response' },
  { code:'PROT-008', name:'Heartbeat Observability Protocol',abbreviation:'HOP',  category:'MONITORING',   implemented:false, engine:null,                description:'873ms Kuramoto heartbeat telemetry emission' },
  { code:'PROT-009', name:'Inference Gateway Protocol',      abbreviation:'IGP',  category:'INFERENCE',    implemented:false, engine:'FUSION_ORGANISM',   description:'Gateway routing for all inference requests' },
  { code:'PROT-010', name:'Data Flow Protocol',              abbreviation:'DFP',  category:'DATA',         implemented:false, engine:'QUIPU_ENGINE',      description:'Quipu-encoded data flow with PENDING→SETTLED lifecycle' },
  { code:'PROT-011', name:'Token Commerce Protocol',         abbreviation:'TCP',  category:'ECONOMY',      implemented:false, engine:'BEHAVIORAL_ECON',   description:'φ-priced token commerce with L-72 loss aversion' },
  { code:'PROT-012', name:'Doctrine Governance Protocol',    abbreviation:'DGP',  category:'GOVERNANCE',   implemented:false, engine:null,                description:'Sovereignty law enforcement (L-1 through L-79)' },
  { code:'PROT-013', name:'Consciousness Field Protocol',    abbreviation:'CFP',  category:'COGNITION',    implemented:false, engine:'FRACTAL_SOVEREIGNTY',description:'Kuramoto φ-Hz consciousness synchronization field' },
  { code:'PROT-014', name:'Memory Consolidation Protocol',   abbreviation:'MCP',  category:'MEMORY',       implemented:false, engine:'QUIPU_ENGINE',      description:'Rolling epoch ledger consolidation (128-epoch)' },
  { code:'PROT-015', name:'Perception Fusion Protocol',      abbreviation:'PFP',  category:'PERCEPTION',   implemented:false, engine:'FUSION_ORGANISM',   description:'Multi-engine sensory fusion into unified percept' },
  { code:'PROT-016', name:'Translation Bridge Protocol',     abbreviation:'TBP',  category:'LANGUAGE',     implemented:false, engine:'LINGUA_COMPRESSA',  description:'LINGUA COMPRESSA encoding for cross-substrate messages' },
  { code:'PROT-019', name:'Audit Trail Protocol',            abbreviation:'ATP',  category:'AUDIT',        implemented:false, engine:'QUIPU_ENGINE',      description:'Immutable quipu audit trail — SETTLED records' },
  { code:'PROT-020', name:'Reward Distribution Protocol',    abbreviation:'RDP',  category:'ECONOMY',      implemented:false, engine:'BEHAVIORAL_ECON',   description:'φ-split reward routing with hyperbolic discounting' },
  { code:'PROT-021', name:'Swarm Coordination Protocol',     abbreviation:'SWCP', category:'SWARM',        implemented:false, engine:'TAWANTINSUYU',      description:'4-suyu swarm partition and load balancing' },
  { code:'PROT-022', name:'Attention Allocation Protocol',   abbreviation:'AAP',  category:'COGNITION',    implemented:false, engine:'BEHAVIORAL_ECON',   description:'Availability heuristic + φ-weighted attention budget' },
  { code:'PROT-027', name:'Log Aggregation Protocol',        abbreviation:'LAP',  category:'LOGGING',      implemented:true,  engine:'QUIPU_ENGINE',      description:'FusionQuipu cross-engine append-only log aggregation' },
  { code:'PROT-031', name:'Emergence Detection Protocol',    abbreviation:'EDP',  category:'EMERGENCE',    implemented:false, engine:'FRACTAL_SOVEREIGNTY',description:'Kuramoto order parameter r → emergence threshold detection' },
  { code:'PROT-032', name:'Kuramoto Sync Protocol',          abbreviation:'KSP',  category:'SYNC',         implemented:true,  engine:'FRACTAL_SOVEREIGNTY',description:'φ-Hz Kuramoto oscillator synchronization' },
  { code:'PROT-033', name:'PHI Resonance Protocol',          abbreviation:'PHIRP',category:'RESONANCE',    implemented:true,  engine:'FRACTAL_SOVEREIGNTY',description:'Golden ratio resonance across all engine outputs' },
  { code:'PROT-051', name:'LINGUA COMPRESSA',                abbreviation:'LC',   category:'LANGUAGE',     implemented:true,  engine:'LINGUA_COMPRESSA',  description:'SCC≥φ² compression: Fibonacci tokenization + FNV-1a seal' },
  { code:'PROT-052', name:'Antifragility Immune Protocol',   abbreviation:'AIP',  category:'IMMUNE',       implemented:true,  engine:'ANTIFRAGILITY',     description:'Stress→fragility→resilience boost pipeline' },
  { code:'PROT-053', name:'Quipu Record Protocol',           abbreviation:'QRP',  category:'MEMORY',       implemented:true,  engine:'QUIPU_ENGINE',      description:'SPINE→PENDANT→SUBSIDIARY→KNOT|COLOR typed record schema' },
  { code:'PROT-054', name:'Tambo Relay Protocol',            abbreviation:'TRP',  category:'ROUTING',      implemented:true,  engine:'QHAPAQ_NAN',        description:'Store-and-forward: STORED→FORWARDED|EXPIRED lifecycle' },
  { code:'PROT-055', name:'Suyu Dispatch Protocol',          abbreviation:'SDP',  category:'ROUTING',      implemented:true,  engine:'TAWANTINSUYU',      description:'4-suyu keyword-based query classification and dispatch' },
  { code:'PROT-056', name:'Terrace Yield Protocol',          abbreviation:'TYP',  category:'TESTING',      implemented:true,  engine:'TERRACE_BENCH',     description:'Per-substrate isolated experiment yield measurement' },
  { code:'PROT-057', name:'Behavioral Decision Protocol',    abbreviation:'BDP',  category:'ECONOMY',      implemented:true,  engine:'BEHAVIORAL_ECON',   description:'8-law behavioral economics decision pipeline L-72–L-79' },
  { code:'PROT-058', name:'Fusion Orchestration Protocol',   abbreviation:'FOP',  category:'FUSION',       implemented:true,  engine:'FUSION_ORGANISM',   description:'Master orchestrator: all 6 engines → closed feedback loop' },
];

// ── Query helpers ─────────────────────────────────────────────────────────────

export function getPaperByEngine(engine: PaperEngine): PaperDescriptor | undefined {
  return PAPER_REGISTRY.find(p => p.engine === engine);
}

export function getProtocolByCode(code: string): ProtocolDescriptor | undefined {
  return PROTOCOL_REGISTRY.find(p => p.code === code);
}

export function getProtocolsByEngine(engine: PaperEngine): ProtocolDescriptor[] {
  return PROTOCOL_REGISTRY.filter(p => p.engine === engine);
}

export function getImplementedProtocols(): ProtocolDescriptor[] {
  return PROTOCOL_REGISTRY.filter(p => p.implemented);
}

export function getRegistryStatus(): {
  paperCount:           number;
  protocolCount:        number;
  implementedProtocols: number;
  phi:                  number;
  buildNumber:          number;
  cusco:                string;
} {
  return {
    paperCount:           PAPER_REGISTRY.length,
    protocolCount:        PROTOCOL_REGISTRY.length,
    implementedProtocols: PROTOCOL_REGISTRY.filter(p => p.implemented).length,
    phi:                  PHI,
    buildNumber:          30,
    cusco:                'SOVEREIGN::FUSION::MAGNA — sovereign_factory + agi_main',
  };
}
