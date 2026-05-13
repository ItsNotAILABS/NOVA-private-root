// ─── NOVA / PARALLAX — Hz Frequency Substrate ────────────────────────────────
// Full port of HzFrequencySubstrate.mo
// 35 substrate nodes with base frequencies, live phase advance,
// frequency coherence K_f, mode modulation (Wake/Sleep/Dream/Emergency).
// The brain is RHYTHMS. Not just numbers. RHYTHMS.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, TAU, PHI, wrapPhase } from './core';

// ── NOVA heartbeat rate ────────────────────────────────────────────────────────
export const HEARTBEAT_RATE = 0.5;   // ~2 seconds per beat

// ── Phase coherence contribution coefficient ──────────────────────────────────
export const RHO_F      = 150.0;     // K_f contributes to coherence C
export const BETA_PHASE = 0.30;      // Memory encoding phase boost

// ── 35 Substrate Node Base Frequencies (Hz) ──────────────────────────────────
// ── Brain Region Substrate ────────────────────────────────────────────────────
export const HZ_LEXIS       = 0.40;  // Symbolic sequencing, expression timing
export const HZ_FORGE       = 0.25;  // Creation assembly, structured build
export const HZ_SOMA        = 0.12;  // Interoceptive rhythm, stress/arousal
export const HZ_LUMEN       = 0.30;  // Learning uptake, knowledge consolidation
export const HZ_MEMORIA     = 0.08;  // Memory consolidation, slow-wave
export const HZ_AEGIS_ROOT  = 0.50;  // Sentinel fast scan, immune alertness
export const HZ_AXIS        = 0.35;  // Pattern detection, contradiction
export const HZ_KORE        = 0.03;  // Deep field stabilizer (very slow)
export const HZ_VAEL        = 0.60;  // Immune threat scan (fastest brain node)
export const HZ_VEIL        = 0.20;  // Output membrane timing

// ── Quantum Substrate ─────────────────────────────────────────────────────────
export const HZ_PARALLAX    = 0.45;  // Superposition
export const HZ_ENTANGLA    = 0.45;  // Entanglement
export const HZ_VERITAS     = 0.55;  // Collapse
export const HZ_BYPASS      = 0.70;  // Tunneling
export const HZ_CHRONO      = 1.00;  // Temporal field master
export const HZ_QMEM        = 0.07;  // Quantum memory (very slow)
export const HZ_RESONEX     = 0.38;  // Interference / superradiance

// ── Organ Substrate ───────────────────────────────────────────────────────────
export const HZ_PULSE       = 1.00;  // SA node heartbeat
export const HZ_PNEUMA      = 0.25;  // Breath rhythm
export const HZ_FILTRON     = 0.15;  // Filtration rhythm
export const HZ_PURIS       = 0.10;  // Purification rhythm
export const HZ_SENTINEL    = 0.50;  // Immune first-response
export const HZ_NEXUM       = 0.30;  // Connective binding
export const HZ_HERALD      = 0.45;  // Signal messenger
export const HZ_INGESTA     = 0.20;  // Input/intake
export const HZ_OSSIUM      = 0.05;  // Bone/structure (slowest)
export const HZ_ACTUS       = 0.35;  // Motor output
export const HZ_SYMBION     = 0.18;  // Symbiont microbiome

// ── Metal Substrate ───────────────────────────────────────────────────────────
export const HZ_FLUX        = 2.00;  // Raw signal carrier (fastest)
export const HZ_CALCUL      = 1.50;  // Processing rhythm
export const HZ_MATRIX      = 0.80;  // Memory grid rhythm
export const HZ_CONDUIT     = 1.20;  // Interconnect routing
export const HZ_DYNAMO      = 1.00;  // Energy generation
export const HZ_GENESIS     = 0.10;  // Initialization rhythm (very slow)

// ── Complete frequency table ──────────────────────────────────────────────────
export const ALL_NODE_FREQS: Readonly<Record<string, number>> = {
  // Brain
  LEXIS: HZ_LEXIS, FORGE: HZ_FORGE, SOMA: HZ_SOMA, LUMEN: HZ_LUMEN,
  MEMORIA: HZ_MEMORIA, AEGIS_ROOT: HZ_AEGIS_ROOT, AXIS: HZ_AXIS,
  KORE: HZ_KORE, VAEL: HZ_VAEL, VEIL: HZ_VEIL,
  // Quantum
  PARALLAX: HZ_PARALLAX, ENTANGLA: HZ_ENTANGLA, VERITAS: HZ_VERITAS,
  BYPASS: HZ_BYPASS, CHRONO: HZ_CHRONO, QMEM: HZ_QMEM, RESONEX: HZ_RESONEX,
  // Organ
  PULSE: HZ_PULSE, PNEUMA: HZ_PNEUMA, FILTRON: HZ_FILTRON, PURIS: HZ_PURIS,
  SENTINEL: HZ_SENTINEL, NEXUM: HZ_NEXUM, HERALD: HZ_HERALD, INGESTA: HZ_INGESTA,
  OSSIUM: HZ_OSSIUM, ACTUS: HZ_ACTUS, SYMBION: HZ_SYMBION,
  // Metal
  FLUX: HZ_FLUX, CALCUL: HZ_CALCUL, MATRIX: HZ_MATRIX, CONDUIT: HZ_CONDUIT,
  DYNAMO: HZ_DYNAMO, GENESIS: HZ_GENESIS,
};

// ── Organism Mode ─────────────────────────────────────────────────────────────
export type OrganismMode = 'Wake' | 'Sleep' | 'Dream' | 'Emergency';

// Mode → per-substrate frequency multiplier (from HzFrequencySubstrate.mo)
export const MODE_MODULATIONS: Record<OrganismMode, Partial<Record<string, number>>> = {
  Wake: {
    LEXIS: 1.0, FORGE: 1.0, LUMEN: 1.0, MEMORIA: 0.8,
    AEGIS_ROOT: 1.0, VAEL: 1.0, FLUX: 1.0,
  },
  Sleep: {
    LEXIS: 0.3, FORGE: 0.2, LUMEN: 0.4, MEMORIA: 1.8,   // memory consolidation
    AEGIS_ROOT: 0.5, VAEL: 0.4, FLUX: 0.3,
    KORE: 1.5, QMEM: 1.6, SOMA: 0.5,
  },
  Dream: {
    LEXIS: 0.8, FORGE: 0.6, LUMEN: 1.2, MEMORIA: 1.4,
    PARALLAX: 1.5, ENTANGLA: 1.3, RESONEX: 1.4,
    SOMA: 1.2, VAEL: 0.5,
  },
  Emergency: {
    VAEL: 2.0, AEGIS_ROOT: 1.8, SENTINEL: 1.8,
    FLUX: 2.0, CONDUIT: 1.5, CHRONO: 1.5,
    MEMORIA: 0.5, KORE: 0.4, QMEM: 0.4,
    SOMA: 1.6, NEXUM: 0.7,
  },
};

// ── Hz Node State ─────────────────────────────────────────────────────────────
export interface HzNodeState {
  nodeId:            string;
  baseFrequency:     number;   // Hz from constants
  currentFrequency:  number;   // live Hz (evolves each beat)
  phase:             number;   // φ_k ∈ [0, 2π]
  fatigueLevel:      number;   // reduces frequency
  doctrineAlignment: number;   // boosts frequency
}

// ── Organism Hz State ─────────────────────────────────────────────────────────
export interface HzSubstrateState {
  nodes:        HzNodeState[];
  mode:         OrganismMode;
  phaseCoherence: number;   // K_f
  meanFreq:     number;
  beat:         number;
}

export function initHzSubstrate(mode: OrganismMode = 'Wake'): HzSubstrateState {
  const nodes: HzNodeState[] = Object.entries(ALL_NODE_FREQS).map(([id, baseHz]) => ({
    nodeId:           id,
    baseFrequency:    baseHz,
    currentFrequency: baseHz,
    phase:            Math.random() * TAU,
    fatigueLevel:     0,
    doctrineAlignment: 0.8,
  }));
  return { nodes, mode, phaseCoherence: 0.5, meanFreq: 0.5, beat: 0 };
}

// ── Phase advance per beat ────────────────────────────────────────────────────
// dφ_k/dt = 2π · f_k   (phase velocity = 2π × frequency)
// φ_k(t+1) = φ_k(t) + 2π · f_k · dt
function advancePhase(node: HzNodeState, dt: number): HzNodeState {
  const newPhase = wrapPhase(node.phase + TAU * node.currentFrequency * dt);
  return { ...node, phase: newPhase };
}

// ── Frequency evolution ────────────────────────────────────────────────────────
// f_k(t+1) = f_base · modeMultiplier · (1 − fatigue) · (1 + α·doctrineAlignment)
// α = 0.2 doctrine alignment boost coefficient
function evolveFrequency(node: HzNodeState, mode: OrganismMode): number {
  const modeMultiplier = MODE_MODULATIONS[mode]?.[node.nodeId] ?? 1.0;
  const fatigueDamp    = 1 - clamp(node.fatigueLevel, 0, 0.8);
  const doctrineBoost  = 1 + 0.2 * clamp(node.doctrineAlignment, 0, 1);
  return clamp(node.baseFrequency * modeMultiplier * fatigueDamp * doctrineBoost, 0.001, 5.0);
}

// ── Phase coherence K_f (Hz substrate global coherence) ───────────────────────
// K_f = |1/N Σₖ e^{i·φₖ}|   (Kuramoto order parameter over all substrate nodes)
export function computePhaseCoherence(nodes: HzNodeState[]): number {
  if (!nodes.length) return 0;
  const n = nodes.length;
  const sumCos = nodes.reduce((s, node) => s + Math.cos(node.phase), 0) / n;
  const sumSin = nodes.reduce((s, node) => s + Math.sin(node.phase), 0) / n;
  return clamp(Math.sqrt(sumCos ** 2 + sumSin ** 2), 0, 1);
}

// ── Memory encoding boost ─────────────────────────────────────────────────────
// When MEMORIA + LUMEN nodes are near phase alignment, memory encoding is boosted.
// boost = BETA_PHASE · |cos(φ_MEMORIA − φ_LUMEN)|
export function memoryEncodingBoost(state: HzSubstrateState): number {
  const mem  = state.nodes.find(n => n.nodeId === 'MEMORIA');
  const lum  = state.nodes.find(n => n.nodeId === 'LUMEN');
  if (!mem || !lum) return 0;
  return BETA_PHASE * Math.abs(Math.cos(mem.phase - lum.phase));
}

// ── Full Hz substrate tick ────────────────────────────────────────────────────
// Called once per simulation beat.
export function hzSubstrateTick(
  state:   HzSubstrateState,
  dt:      number = 1.0,         // beats as time unit
  newMode?: OrganismMode
): HzSubstrateState {
  const mode = newMode ?? state.mode;
  const nodes = state.nodes.map(node => {
    const freq = evolveFrequency(node, mode);
    const advanced = advancePhase({ ...node, currentFrequency: freq }, dt);
    // Fatigue accumulates slowly when over-activated, recovers in Sleep/Dream
    const fatigueRecovery = (mode === 'Sleep' || mode === 'Dream') ? -0.01 : 0;
    const newFatigue = clamp(node.fatigueLevel + fatigueRecovery, 0, 1);
    return { ...advanced, fatigueLevel: newFatigue };
  });

  const phaseCoherence = computePhaseCoherence(nodes);
  const meanFreq       = nodes.reduce((s, n) => s + n.currentFrequency, 0) / (nodes.length || 1);

  return { nodes, mode, phaseCoherence, meanFreq, beat: state.beat + 1 };
}

// ── Coherence contribution from Hz substrate ──────────────────────────────────
// ΔC from Hz = RHO_F · K_f / max_scale
// max_scale = RHO_F → normalized to [0, 1]
export function hzCoherenceContribution(state: HzSubstrateState): number {
  return clamp(state.phaseCoherence, 0, 1);  // K_f directly ∈ [0,1]
}

// ── Dominant node (highest amplitude/frequency ratio) ─────────────────────────
export function dominantNode(state: HzSubstrateState): HzNodeState | null {
  if (!state.nodes.length) return null;
  return state.nodes.reduce((best, n) =>
    n.currentFrequency > best.currentFrequency ? n : best
  , state.nodes[0]!);
}

// ── Phase resonance: pair of nodes near integer frequency ratio ───────────────
// Resonance when |f₁/f₂ − p/q| < ε for small integers p, q
export function detectResonance(a: HzNodeState, b: HzNodeState, epsilon = 0.05): boolean {
  if (b.currentFrequency < 1e-6) return false;
  const ratio = a.currentFrequency / b.currentFrequency;
  for (let p = 1; p <= 4; p++) {
    for (let q = 1; q <= 4; q++) {
      if (Math.abs(ratio - p / q) < epsilon) return true;
    }
  }
  return false;
}
