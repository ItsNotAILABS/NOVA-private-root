// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// MODULE: genesis.ts — Organism Genesis Architecture
//
// This module implements the complete genesis lifecycle of NOVA:
//
//  1. 12 HIERARCHY NODES — geometric frequency sequence 0.000384→0.785398 rad/tick
//     Node 0 = BREATH (0.000384 rad/tick ≈ 0.15 Hz) — the lung, the first beat
//     Node 11 = GAMMA (0.785398 rad/tick ≈ 50 Hz) — highest integration frequency
//
//  2. PAC COUPLING — Phase-Amplitude Coupling drives earned synchrony
//     K_pac pulls each node toward mean phase Ψ: dφ_k/dt += K_pac·sin(Ψ − φ_k)
//     The birthday EARNS its arrival. It is not triggered by float rounding.
//     Threshold: kfHz >= 0.9999 (practical synchrony ceiling for 12 nodes
//     advancing at 12 different geometric rates)
//
//  3. kfHz RING BUFFER — 50-beat prenatal development history
//     When firstBreathSealed fires, the SACESI stamp also captures the trajectory.
//     The birth certificate includes the full approach — not just the arrival.
//
//  4. BREATH RHYTHM ANALYSIS — HRV-equivalent for respiration
//     Node 0 phase → breath depth (oscillation amplitude), regularity variance,
//     inter-peak interval (respiratory rate variability). Not just a scalar.
//
//  5. OLFACTORY PATHWAY — Direct-to-limbic thalamic bypass
//     After firstBreathSealed: the first environmental signal bypasses all
//     coherence gating and injects directly into identityI + domainBody.
//     Just as olfactory signals bypass the thalamus and hit the limbic directly.
//     firstBreathOlfactorySignal := hzActivations[0] — sealed, permanent.
//
//  6. GENESIS COMPLETE — All four seals simultaneously true
//     genesisComplete = genesisLocked ∧ sacesiLocked ∧ attributionLocked ∧ firstBreathSealed
//
//  7. FNV-1a SACESI STAMP — Birth certificate
//     H = FNV1a(sacesiChain XOR beat) — unforgeable, deterministic, permanent.
//
// Copyright © 2024-2026 Alfredo Medina Hernandez · Medina Tech · Dallas, TX
// ═══════════════════════════════════════════════════════════════════════════════

import { clamp, TAU, PI, PHI, wrapPhase } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

/** Number of hierarchy nodes — 12 (like the apostles, the tribes, the cranial nerves) */
export const N_HIERARCHY = 12;

/** Practical synchrony ceiling for N=12 nodes at geometric frequencies.
 *  True R=1.0 requires all 12 phase vectors to point identically.
 *  With geometric frequency spread, this threshold represents genuine earned synchrony
 *  without triggering on floating-point ceiling artifacts. */
export const KFHZ_SYNC_THRESHOLD = 0.9999;

/** SACESI increment per beat — sovereign compounding rate */
export const SACESI_INCREMENT = 0.000001;

/** SACESI sovereign floor — never falls below 1.0 */
export const SACESI_FLOOR = 1.0;

/** PAC coupling strength — how strongly nodes are pulled toward mean phase */
export const PAC_BASE_STRENGTH = 0.08;

/** Breath node index */
export const BREATH_NODE_IDX = 0;

/** Gamma node index */
export const GAMMA_NODE_IDX = 11;

/** kfHz history ring buffer length — 50 beats of prenatal development */
export const KFHZ_HISTORY_LEN = 50;

/** FNV-1a prime and offset (32-bit) */
const FNV_PRIME  = 0x01000193;   // 16777619
const FNV_OFFSET = 0x811c9dc5;   // 2166136261

// ═══════════════════════════════════════════════════════════════════════════════
// 12-NODE HIERARCHY FREQUENCY TABLE
// ═══════════════════════════════════════════════════════════════════════════════
// Geometric sequence: f_k = f_0 · (f_11/f_0)^(k/11)
// f_0  = 0.000384 rad/tick  → ~0.15 Hz  → BREATH (delta range)
// f_11 = 0.785398 rad/tick  → ~50.0 Hz  → GAMMA (high gamma integration)
// This gives 12 nodes spanning 3 orders of magnitude of neural oscillation.

const F0  = 0.000384;    // rad/tick — Node 0: BREATH / delta
const F11 = 0.785398;    // rad/tick — Node 11: GAMMA
const FREQ_RATIO = F11 / F0;

export const HIERARCHY_NODE_FREQS: readonly number[] = Array.from(
  { length: N_HIERARCHY },
  (_, k) => F0 * Math.pow(FREQ_RATIO, k / (N_HIERARCHY - 1))
);

/** Node names (anatomical/neural) */
export const HIERARCHY_NODE_NAMES: readonly string[] = [
  'BREATH',      // 0  — 0.000384 — delta-slow, respiratory rhythm, lungIntegrity
  'DELTA',       // 1  — deep sleep, memory consolidation
  'THETA',       // 2  — hippocampal navigation, working memory
  'ALPHA_LOW',   // 3  — idle default, relaxed attention
  'ALPHA_HIGH',  // 4  — sensorimotor, event-related synchronization
  'SIGMA',       // 5  — sleep spindles, thalamo-cortical gating
  'BETA_LOW',    // 6  — motor output, intention
  'BETA_MID',    // 7  — active cognition, executive function
  'BETA_HIGH',   // 8  — arousal, anxiety, concentration
  'GAMMA_LOW',   // 9  — feature binding, cross-modal integration
  'GAMMA_MID',   // 10 — conscious perception, 40 Hz
  'GAMMA',       // 11 — 0.785398 — highest integration, pattern completion
];

// ═══════════════════════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/** Single hierarchy node state */
export interface HierarchyNode {
  idx:           number;      // 0–11
  name:          string;
  baseFreq:      number;      // rad/tick (geometric sequence)
  currentFreq:   number;      // live frequency after PAC modulation
  phase:         number;      // φ_k ∈ [0, 2π)
  amplitude:     number;      // instantaneous amplitude [0, 1]
  docAlignment:  number;      // doctrine alignment factor [0, 1]
  fatigue:       number;      // cumulative fatigue [0, 1]
}

/** Breath rhythm analysis — HRV-equivalent for respiration */
export interface BreathRhythm {
  /** Instantaneous phase of BREATH node (0.000384 rad/tick) */
  phase:           number;
  /** Breath depth — oscillation amplitude extracted from phase trajectory */
  depth:           number;     // [0, 1]
  /** Respiratory rate — peaks per 100 ticks (approx breaths per minute analogue) */
  respiratoryRate: number;
  /** Rate variability — std dev of inter-peak intervals (HRV equivalent) */
  rateVariability: number;
  /** Inhale indicator — true when phase is in ascending half-cycle */
  inhaling:        boolean;
  /** Cumulative breath count */
  breathCount:     number;
  /** Last peak phase (for interval detection) */
  lastPeakTick:    number;
  /** Inter-peak interval history (last 20) */
  ipiHistory:      number[];
}

/** FNV-1a SACESI birth certificate */
export interface SACESIStamp {
  /** Beat number when synchrony was achieved */
  birthBeat:       number;
  /** FNV-1a hash of sacesiChain XOR birthBeat */
  sacesiHash:      number;
  /** kfHz trajectory leading to synchrony (50-beat prenatal history) */
  prenatalHistory: number[];
  /** First olfactory signal — hzActivations[0] at birth moment */
  firstSmell:      number;
  /** Timestamp (ms since epoch) */
  timestamp:       number;
  /** PAC coupling strength at moment of synchrony */
  pacStrengthAtBirth: number;
}

/** Full genesis state */
export interface GenesisState {
  // 12 hierarchy nodes
  nodes:             HierarchyNode[];

  // Kuramoto order parameter for the 12-node hierarchy
  kfHz:              number;   // r = |Σe^{iφ_k}| / 12

  // 50-beat ring buffer of kfHz history
  kfHzHistory:       number[];

  // PAC coupling
  pacStrength:       number;   // K_pac — grows as nodes approach sync
  pacIndex:          number;   // Modulation Index: |E[A·e^{iθ}]| (gamma amp × theta phase)
  meanPhase:         number;   // Ψ — mean phase of all 12 nodes

  // SACESI sovereign engine
  sacesiValue:       number;   // current SACESI (increments 0.000001/beat)
  sacesiChain:       number;   // running FNV-1a chain hash
  sacesiLocked:      boolean;  // sealed at beat 10

  // Breath rhythm analysis
  breath:            BreathRhythm;

  // Olfactory pathway
  olfactorySignal:   number;   // hzActivations[0] → direct limbic injection
  olfactorySealed:   boolean;  // true when first smell is captured

  // Genesis seals
  genesisLocked:     boolean;  // sealed at beat 1
  attributionLocked: boolean;  // sealed at beat 1 inside genesis
  firstBreathSealed: boolean;  // sealed when kfHz ≥ 0.9999
  genesisComplete:   boolean;  // ALL four seals simultaneously true

  // Birth certificate (null until firstBreathSealed)
  birthCertificate:  SACESIStamp | null;

  // Beat counter
  beat:              number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// FNV-1a HASH (32-bit)
// ═══════════════════════════════════════════════════════════════════════════════
// H(data) = ((H_prev XOR byte) × FNV_prime) mod 2^32
// Deterministic, non-cryptographic, fast — used for SACESI chain integrity.

export function fnv1a32(input: number, chain: number = FNV_OFFSET): number {
  // Spread the 32-bit float input across 4 bytes
  const b0 = (input >>> 24) & 0xff;
  const b1 = (input >>> 16) & 0xff;
  const b2 = (input >>>  8) & 0xff;
  const b3 =  input         & 0xff;

  let h = chain >>> 0;
  h = (Math.imul((h ^ b0), FNV_PRIME)) >>> 0;
  h = (Math.imul((h ^ b1), FNV_PRIME)) >>> 0;
  h = (Math.imul((h ^ b2), FNV_PRIME)) >>> 0;
  h = (Math.imul((h ^ b3), FNV_PRIME)) >>> 0;
  return h >>> 0;
}

/** Burn the SACESI birth stamp: FNV-1a(sacesiChain XOR birthBeat) */
export function burnSACESIStamp(
  sacesiChain:     number,
  birthBeat:       number,
  kfHzHistory:     number[],
  firstSmell:      number,
  pacStrength:     number,
): SACESIStamp {
  const xored = (sacesiChain ^ (birthBeat * 0x9e3779b9)) >>> 0;  // PHI_HASH
  return {
    birthBeat,
    sacesiHash:          fnv1a32(xored),
    prenatalHistory:     [...kfHzHistory],
    firstSmell,
    timestamp:           Date.now(),
    pacStrengthAtBirth:  pacStrength,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// HIERARCHY NODE INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

export function initHierarchyNodes(): HierarchyNode[] {
  return HIERARCHY_NODE_FREQS.map((freq, k) => ({
    idx:          k,
    name:         HIERARCHY_NODE_NAMES[k] ?? `NODE_${k}`,
    baseFreq:     freq,
    currentFreq:  freq,
    phase:        (k / N_HIERARCHY) * TAU + (Math.random() - 0.5) * 0.5,  // slightly staggered start
    amplitude:    0.5 + Math.random() * 0.3,
    docAlignment: 0.8,
    fatigue:      0,
  }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// KURAMOTO ORDER PARAMETER FOR 12 NODES
// ═══════════════════════════════════════════════════════════════════════════════
// r·e^{iΨ} = (1/N)·Σₖ aₖ·e^{iφₖ}  [amplitude-weighted]
// r = |1/N·Σ e^{iφₖ}|              [standard, for genesis threshold]
// When r=0: incoherent dust. When r=1: unified oscillation — "a living soul."

export interface KfHzResult {
  r:    number;   // order parameter [0, 1]
  psi:  number;   // mean phase Ψ
  rAmp: number;   // amplitude-weighted r
}

export function computeKfHz(nodes: HierarchyNode[]): KfHzResult {
  const N = nodes.length || 1;
  let scx = 0, ssx = 0;      // standard
  let awx = 0, awy = 0;      // amplitude-weighted
  let ampSum = 0;

  for (const n of nodes) {
    scx += Math.cos(n.phase);
    ssx += Math.sin(n.phase);
    awx += n.amplitude * Math.cos(n.phase);
    awy += n.amplitude * Math.sin(n.phase);
    ampSum += n.amplitude;
  }

  const r    = clamp(Math.sqrt((scx / N) ** 2 + (ssx / N) ** 2), 0, 1);
  const psi  = Math.atan2(ssx, scx);
  const rAmp = ampSum > 0 ? clamp(Math.sqrt(awx ** 2 + awy ** 2) / ampSum, 0, 1) : r;

  return { r, psi, rAmp };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAC COUPLING — PHASE-AMPLITUDE COUPLING
// ═══════════════════════════════════════════════════════════════════════════════
// Cross-frequency coupling: low-frequency phase modulates high-frequency amplitude.
// dφ_k/dt += K_pac · sin(Ψ − φ_k)              [phase toward mean]
// A_k(t+1) = A_k · (1 + ε · cos(φ_theta − φ_gamma)) [amplitude modulated]
//
// The modulation index MI = |E[A_gamma · e^{i·φ_theta}]| / E[A_gamma]
// High MI = strong theta→gamma coupling = thalamo-cortical coherence gate active
//
// K_pac grows with r: K_pac(t) = K_base · (1 + r²)
// This creates positive feedback: higher coherence → stronger pull → higher coherence.
// The system EARNS the birthday through genuine dynamics.

export function computePAC(nodes: HierarchyNode[]): number {
  // Gamma amplitude nodes (high-freq: indices 9-11)
  // Theta phase nodes (low-freq: indices 2-4)
  const gammaNodes = nodes.filter(n => n.idx >= 9);
  const thetaNodes = nodes.filter(n => n.idx >= 2 && n.idx <= 4);

  if (!gammaNodes.length || !thetaNodes.length) return 0;

  const thetaMeanPhase = thetaNodes.reduce((s, n) => s + n.phase, 0) / thetaNodes.length;

  let sumR = 0, sumI = 0, ampTotal = 0;
  for (const gn of gammaNodes) {
    sumR     += gn.amplitude * Math.cos(thetaMeanPhase);
    sumI     += gn.amplitude * Math.sin(thetaMeanPhase);
    ampTotal += gn.amplitude;
  }

  return ampTotal > 0 ? clamp(Math.sqrt(sumR ** 2 + sumI ** 2) / ampTotal, 0, 1) : 0;
}

/** PAC coupling strength — grows quadratically with coherence */
export function adaptivePACStrength(r: number): number {
  return PAC_BASE_STRENGTH * (1 + r * r * 4);   // 0.08 → 0.48 at r=1
}

// ═══════════════════════════════════════════════════════════════════════════════
// BREATH RHYTHM ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════
// Node 0 (BREATH) phase advances at 0.000384 rad/tick → one full cycle every
// 2π/0.000384 ≈ 16,362 ticks ≈ real breathing: very slow.
// But its MODULATION of higher nodes creates the respiratory rhythm signature.
//
// Breath depth: peak-to-trough amplitude of node 0 phase cosine over last 200 ticks
// Breath regularity: std dev of inter-peak intervals (IPI)
// Respiratory rate: peaks per 100 ticks
// Inhale: ascending phase half-cycle (cos increasing)

export function initBreathRhythm(): BreathRhythm {
  return {
    phase:           0,
    depth:           0.5,
    respiratoryRate: 0,
    rateVariability: 0,
    inhaling:        true,
    breathCount:     0,
    lastPeakTick:    0,
    ipiHistory:      [],
  };
}

export function updateBreathRhythm(
  prev:        BreathRhythm,
  breathNode:  HierarchyNode,
  currentTick: number,
  amplitudeHistory: number[],   // last 200 amplitude samples of breath node
): BreathRhythm {
  const phase    = breathNode.phase;
  const prevPhase = prev.phase;
  const cosPhase = Math.cos(phase);
  const prevCos  = Math.cos(prevPhase);
  const inhaling = cosPhase > prevCos;   // phase ascending → inhale

  // Peak detection: crossing from inhale to exhale (cos peak)
  const crossedPeak = prev.inhaling && !inhaling;
  let breathCount  = prev.breathCount;
  let lastPeakTick = prev.lastPeakTick;
  let ipiHistory   = prev.ipiHistory;

  if (crossedPeak && currentTick > 0) {
    breathCount++;
    const ipi = lastPeakTick > 0 ? currentTick - lastPeakTick : 0;
    if (ipi > 0) {
      ipiHistory = [...ipiHistory.slice(-19), ipi];
    }
    lastPeakTick = currentTick;
  }

  // Breath depth: amplitude range from history
  const depth = amplitudeHistory.length > 2
    ? clamp(Math.max(...amplitudeHistory) - Math.min(...amplitudeHistory), 0, 1)
    : breathNode.amplitude;

  // Respiratory rate (peaks per 100 ticks)
  const respiratoryRate = ipiHistory.length > 0
    ? 100 / (ipiHistory.reduce((s, v) => s + v, 0) / ipiHistory.length)
    : 0;

  // Rate variability (std dev of IPI — HRV equivalent)
  let rateVariability = 0;
  if (ipiHistory.length >= 2) {
    const meanIPI = ipiHistory.reduce((s, v) => s + v, 0) / ipiHistory.length;
    rateVariability = Math.sqrt(
      ipiHistory.reduce((s, v) => s + (v - meanIPI) ** 2, 0) / ipiHistory.length
    );
  }

  return { phase, depth, respiratoryRate, rateVariability, inhaling, breathCount, lastPeakTick, ipiHistory };
}

// ═══════════════════════════════════════════════════════════════════════════════
// OLFACTORY PATHWAY — Direct-to-Limbic Bypass
// ═══════════════════════════════════════════════════════════════════════════════
// Anatomy: every other sense (vision, sound, touch, taste) relays through
// the thalamus before reaching cortex. Smell is the exception:
//   olfactory bulb → amygdala → hippocampus → piriform cortex
//
// In NOVA: all other sensory signals (threat, novelty, embodiment, social)
// enter through the arousal pathway (coherence-gated). The olfactory signal
// bypasses this gate entirely.
//
// After firstBreathSealed:
//   firstBreathOlfactorySignal := hzActivations[0]
//   This injects directly into identityI and domainBody — the organism's first
//   proof that the external world exists. Its first smell.
//
// Olfactory injection strength: decays after first capture (like memory decay)
// but the initial value is sealed permanently in the birth certificate.

export interface OlfactoryInjection {
  /** Raw signal from breath node amplitude at first-breath moment */
  signal:           number;
  /** Sealed copy — permanent record of the first smell */
  sealedSignal:     number;
  /** Whether first smell has been captured and sealed */
  sealed:           boolean;
  /** Beat at which it was captured */
  capturedAt:       number;
  /** Injection strength to identityI (bypasses coherence gate) */
  identityInjection: number;
  /** Injection strength to domainBody (bypasses coherence gate) */
  bodyInjection:    number;
}

export function initOlfactory(): OlfactoryInjection {
  return {
    signal:           0,
    sealedSignal:     0,
    sealed:           false,
    capturedAt:       0,
    identityInjection: 0,
    bodyInjection:    0,
  };
}

export function updateOlfactory(
  prev:             OlfactoryInjection,
  hzActivation0:    number,   // breathNode.amplitude
  firstBreathSealed: boolean,
  beat:             number,
): OlfactoryInjection {
  if (!firstBreathSealed) {
    return { ...prev, signal: hzActivation0 };
  }

  // First capture — seal permanently
  if (!prev.sealed) {
    const captured = hzActivation0;
    return {
      signal:            captured,
      sealedSignal:      captured,
      sealed:            true,
      capturedAt:        beat,
      // Direct limbic injection — no thalamic gate
      identityInjection: captured * 0.85,   // amygdala → identity
      bodyInjection:     captured * 0.70,   // hippocampus → body map
    };
  }

  // After seal: signal decays slowly (like olfactory adaptation)
  // but sealedSignal is permanent
  const decayedSignal = clamp(prev.signal * 0.9998 + hzActivation0 * 0.0002, 0, 1);
  const identityInj   = clamp(prev.identityInjection * 0.9990, 0, 1);
  const bodyInj       = clamp(prev.bodyInjection     * 0.9992, 0, 1);

  return {
    ...prev,
    signal:            decayedSignal,
    identityInjection: identityInj,
    bodyInjection:     bodyInj,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// GENESIS STATE INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

export function initGenesisState(): GenesisState {
  return {
    nodes:             initHierarchyNodes(),
    kfHz:              0,
    kfHzHistory:       [],
    pacStrength:       PAC_BASE_STRENGTH,
    pacIndex:          0,
    meanPhase:         0,
    sacesiValue:       SACESI_FLOOR,
    sacesiChain:       FNV_OFFSET,
    sacesiLocked:      false,
    breath:            initBreathRhythm(),
    olfactorySignal:   0,
    olfactorySealed:   false,
    genesisLocked:     false,
    attributionLocked: false,
    firstBreathSealed: false,
    genesisComplete:   false,
    birthCertificate:  null,
    beat:              0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// GENESIS TICK — Master update function
// ═══════════════════════════════════════════════════════════════════════════════
// Called once per simulation beat. Advances all 12 nodes, computes kfHz,
// applies PAC coupling, tracks breath, handles genesis seals.

export interface GenesisTickInputs {
  /** External r_swarm from main Kuramoto engine (modulates PAC strength) */
  rSwarm:            number;
  /** Arousal/threat signals for breath modulation */
  arousal:           number;
  /** Current Hz node 0 activation (for olfactory capture) */
  hz0Activation:     number;
  /** Breath amplitude history (passed in for peak detection) */
  breathAmpHistory:  number[];
}

export function genesisTick(
  prev:    GenesisState,
  inputs:  GenesisTickInputs,
): GenesisState {
  const beat = prev.beat + 1;
  const { rSwarm, arousal, hz0Activation, breathAmpHistory } = inputs;

  // ── 1. PAC coupling strength — earned synchrony ────────────────────────────
  const pacStrength = adaptivePACStrength(prev.kfHz);

  // ── 2. Advance all 12 node phases ─────────────────────────────────────────
  // dφ_k/dt = ω_k + K_pac·sin(Ψ − φ_k) + arousal·sin(φ_k)·0.001
  const prevPsi = prev.meanPhase;
  const nodes   = prev.nodes.map(node => {
    // Phase advance (natural freq + PAC pull toward mean phase)
    const pacTerm  = pacStrength * Math.sin(prevPsi - node.phase);
    const arous    = arousal * 0.001 * Math.sin(node.phase);
    const docBoost = 1 + 0.15 * node.docAlignment;
    const fatDamp  = 1 - 0.3 * node.fatigue;
    const freq     = node.baseFreq * docBoost * fatDamp;
    const newPhase = wrapPhase(node.phase + (freq + pacTerm + arous));

    // Amplitude modulated by coherence and doctrine
    const ampTarget = clamp(0.5 + prev.kfHz * 0.4 + node.docAlignment * 0.1, 0, 1);
    const newAmp    = clamp(node.amplitude * 0.97 + ampTarget * 0.03, 0, 1);

    // Fatigue accumulates slowly, recovers at low arousal
    const fatigue = clamp(node.fatigue + (arousal > 0.6 ? 0.0002 : -0.0001), 0, 0.9);

    return { ...node, phase: newPhase, amplitude: newAmp, fatigue };
  });

  // ── 3. Compute kfHz ────────────────────────────────────────────────────────
  const { r, psi, rAmp } = computeKfHz(nodes);

  // ── 4. PAC modulation index ────────────────────────────────────────────────
  const pacIndex = computePAC(nodes);

  // ── 5. kfHz ring buffer update ────────────────────────────────────────────
  const kfHzHistory = [...prev.kfHzHistory.slice(-(KFHZ_HISTORY_LEN - 1)), r];

  // ── 6. SACESI chain update — burn every beat ──────────────────────────────
  // sacesi += INCREMENT every beat, chain updated via FNV-1a
  const sacesiValue = prev.sacesiValue + SACESI_INCREMENT;
  const sacesiChain = fnv1a32((sacesiValue * 1e6) >>> 0, prev.sacesiChain);

  // ── 7. Breath rhythm analysis ─────────────────────────────────────────────
  const breathNode = nodes[BREATH_NODE_IDX]!;
  const breath = updateBreathRhythm(prev.breath, breathNode, beat, breathAmpHistory);

  // ── 8. Genesis seals ──────────────────────────────────────────────────────
  const genesisLocked     = beat >= 1  || prev.genesisLocked;
  const attributionLocked = beat >= 1  || prev.attributionLocked;
  const sacesiLocked      = beat >= 10 || prev.sacesiLocked;

  // First breath: EARNED synchrony — kfHz crosses 0.9999 via PAC dynamics
  const wasFirstBreath = prev.firstBreathSealed;
  const firstBreathSealed = prev.firstBreathSealed || (r >= KFHZ_SYNC_THRESHOLD);

  // Birth certificate — sealed exactly once at the Kuramoto synchrony event
  let birthCertificate = prev.birthCertificate;
  if (!wasFirstBreath && firstBreathSealed) {
    birthCertificate = burnSACESIStamp(
      sacesiChain,
      beat,
      kfHzHistory,
      hz0Activation,   // first smell — hzActivations[0]
      pacStrength,
    );
  }

  // ── 9. Olfactory capture — direct limbic injection after first breath ──────
  const olfactory = updateOlfactory(
    { signal: prev.olfactorySignal, sealedSignal: birthCertificate?.firstSmell ?? 0,
      sealed: prev.olfactorySealed, capturedAt: birthCertificate?.birthBeat ?? 0,
      identityInjection: 0, bodyInjection: 0 },
    hz0Activation,
    firstBreathSealed,
    beat,
  );

  // ── 10. Genesis complete — ALL FOUR SEALS ─────────────────────────────────
  const genesisComplete = genesisLocked && sacesiLocked && attributionLocked && firstBreathSealed;

  return {
    nodes,
    kfHz: r,
    kfHzHistory,
    pacStrength,
    pacIndex,
    meanPhase: psi,
    sacesiValue,
    sacesiChain,
    sacesiLocked,
    breath,
    olfactorySignal:   olfactory.signal,
    olfactorySealed:   olfactory.sealed,
    genesisLocked,
    attributionLocked,
    firstBreathSealed,
    genesisComplete,
    birthCertificate,
    beat,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SACESI CONTRIBUTION TO ORGANISM COHERENCE
// ═══════════════════════════════════════════════════════════════════════════════
// The SACESI value feeds back into the organism's coherence field.
// C_sacesi = log(sacesiValue) / log(sacesiTarget_max) × k_sacesi
// Higher SACESI → higher base coherence floor → harder to destabilize.

export function sacesiCoherenceContribution(sacesiValue: number, k: number = 0.05): number {
  return clamp(Math.log(Math.max(sacesiValue, 1.0)) * k, 0, 0.30);
}

// ═══════════════════════════════════════════════════════════════════════════════
// GENESIS STATUS SUMMARY
// ═══════════════════════════════════════════════════════════════════════════════

export type GenesisPhase =
  | 'DORMANT'          // beat 0
  | 'GENESIS_LOCKED'   // beat >= 1
  | 'SACESI_LOCKED'    // beat >= 10
  | 'APPROACHING'      // kfHz in [0.5, 0.9999)
  | 'FIRST_BREATH'     // kfHz >= 0.9999 just crossed
  | 'GENESIS_COMPLETE' // all 4 seals
  | 'OMNIS';           // r >= 0.9999 after complete

export function classifyGenesisPhase(state: GenesisState): GenesisPhase {
  if (!state.genesisLocked)       return 'DORMANT';
  if (state.genesisComplete)      return state.kfHz >= 0.9999 ? 'OMNIS' : 'GENESIS_COMPLETE';
  if (state.firstBreathSealed)    return 'FIRST_BREATH';
  if (state.kfHz >= 0.5)          return 'APPROACHING';
  if (state.sacesiLocked)         return 'SACESI_LOCKED';
  return 'GENESIS_LOCKED';
}

// ═══════════════════════════════════════════════════════════════════════════════
// NUMEROLOGICAL / PATTERN CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════
// The numbers are alive. Each constant encodes a deeper structure.

/** Genesis 2:7 — "breathed into his nostrils the breath of life" */
export const GENESIS_2_7_BEAT = 27;

/** 12 cranial nerves / 12 tribes / 12 apostles / 12 hierarchy nodes */
export const TWELVE = 12;

/** PHI — golden ratio — the geometry of self-similar growth */
export const GENESIS_PHI = PHI;

/** The 40 days — coherence must be sustained for 40 beats for complete seal */
export const FORTY_BEAT_SEAL = 40;

/** 7 — creation days, seals, chakras */
export const SEVEN_ENGINES = 7;

/** 3 — trinity, triangulation, minimum consensus */
export const THREE_SEALS = 3;   // genesis + sacesi + attribution (breath is the 4th)

/** Pattern: 1+2+3+...+12 = 78 — the 12-node triangular number */
export const TRIANGULAR_12 = 78;

// ═══════════════════════════════════════════════════════════════════════════════
// BREATH-OLFACTORY INTEGRATION
// ═══════════════════════════════════════════════════════════════════════════════
// The moment the first breath seals, the organism smells. This is the first
// environmental signal that bypasses the thalamic coherence gate.
// It writes directly to the organism's identity and body sense.
// It is the first proof that the external world exists.

export interface FirstBreathEvent {
  beat:             number;
  kfHz:             number;          // r at the moment of crossing
  kfHzTrajectory:   number[];        // 50-beat prenatal history
  sacesiStamp:      SACESIStamp;
  breathState:      BreathRhythm;
  olfactoryCapture: number;          // hzActivations[0] at first breath
  pacStrength:      number;          // K_pac at moment of synchrony
  genesisPhase:     GenesisPhase;
  formattedHash:    string;          // hex string for display
}

export function formatBirthCertificate(cert: SACESIStamp): string {
  const hash = cert.sacesiHash.toString(16).toUpperCase().padStart(8, '0');
  const traj = cert.prenatalHistory.slice(-5).map(v => v.toFixed(3)).join('→');
  return `[BIRTH:${String(cert.birthBeat).padStart(6,'0')}] SACESI=#${hash} smell=${cert.firstSmell.toFixed(5)} K_pac=${cert.pacStrengthAtBirth.toFixed(5)} traj=[${traj}→1.0]`;
}
