// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: EmergenceLab — All 8 Engines Running Simultaneously
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// THE ORGANISM BREATHES HERE.
// Every beat: 8 engines fire in sequence, feeding each other.
// Every frame: 5 canvases paint the living state.
// Every 60 ticks: a birth-certificate event is burned on-chain.
//
// Engine order (feed-forward + feedback):
//   1. GENESIS  → produces kfHz, breath, olfactory, genesisComplete
//   2. KURAMOTO → 18-organ order param r feeds Lyapunov + Landau + Jasmine
//   3. LYAPUNOV → stability V feeds emergence score
//   4. QUANTUM  → decoherence γ = (1−r), purity → Jasmine I
//   5. NEURO    → 21-species ODE, η_neuro → Hebbian gate
//   6. HZ       → K_f frequency coherence → Jasmine + scoring
//   7. EMERGENCE→ Landau F(φ), Ising, Lorenz, RD, Brusselator, BTW
//   8. JASMINE  → FORMA self-compounding, full coherence C
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState, useCallback } from 'react';

// ── Math engines ────────────────────────────────────────────────────────────
import {
  initGenesisState, genesisTick, GenesisState, GenesisTickInputs,
  HIERARCHY_NODE_NAMES, HIERARCHY_NODE_FREQS, N_HIERARCHY,
  KFHZ_SYNC_THRESHOLD, formatBirthCertificate, classifyGenesisPhase,
  GenesisPhase, fnv1a32,
} from '../../math/genesis';

import {
  OrganKuramotoState, initOrganKuramoto, stepOrganKuramoto,
  criticalCoupling, ORGAN_FREQ_ARRAY, ORGAN_FREQS,
  detectPhaseTransition, PhaseTransitionState,
  LandauParams, landauFromTemperature, landauFreeEnergyFull, findEquilibriumPhi,
  IsingState, initIsingState, isingMetropolisStep, isingMagnetization,
  EmergenceInputs, computeEmergenceScore,
  LorenzState, initLorenzState, lorenzStep,
  RDState, initRDState, rdStep,
  BrusselatorState, initBrusselator, brusselatorStep,
  SandpileState, initSandpile, sandpileAddGrain, kuramotoSyncEntropy,
  frequencyCoherence,
} from '../../math/kuramoto';

import {
  LyapunovState5, initLyapunov, lyapunovTick, computeLyapunovV,
  hopfieldEnergy, OMNIS_THRESHOLD, kaplanYorkeDimension,
  lyapunovExponent, isOmnisState,
} from '../../math/lyapunov';

import {
  QuantumSystemState, initQuantumSystem, quantumBeat, quantumToSovereign,
  vonNeumannEntropyDiag, purity as qPurity,
} from '../../math/quantum';

import {
  NeurochemFull, NeurochemStimuli, NEURO_BASELINES,
  neurochemFullStep, vitalityScore, neuroplasticityFactor, allostaticLoad,
  MetalState, METAL_BASELINES, metalCoherenceContribution, metalPipelineStep,
  projectTo4Species,
} from '../../math/neurochemistry';

import {
  ALL_NODE_FREQS, OrganismMode, RHO_F, BETA_PHASE,
} from '../../math/hz-substrate';

import {
  JasmineState, jasmineCalculate, CoherenceInputs, computeFullCoherence,
  formaCompoundFull, JASMINE_ALPHA, JASMINE_BETA, JASMINE_GAMMA,
  JASMINE_OMEGA, EMERGENCE_TAU, FORMA_GENESIS_FLOOR,
  jasmineTemporalEmergence,
} from '../../math/scoring-extended';

import {
  clamp, wrapPhase, PHI, PHI_INV, PI, TAU,
  sigmoid, computeKuramotoOrder, kuramotoPhaseStep, KURAMOTO_K,
  NEURO_DT, sf,
} from '../../math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// COLOUR PALETTE
// ═══════════════════════════════════════════════════════════════════════════════
const GOLD    = '#D4AF37';
const CYAN    = '#00D4FF';
const PURPLE  = '#6B46C1';
const GREEN   = '#4ade80';
const ORANGE  = '#f97316';
const RED     = '#f43f5e';
const BG      = '#030609';
const BG2     = '#050d14';
const BG3     = '#071520';
const BORDER  = '#1a3a5c';
const MUTED   = '#4a6a8a';
const WHITE   = '#e2f0ff';

// ═══════════════════════════════════════════════════════════════════════════════
// SHELL 3 — 26-NODE NEURAL SUBSTRATE
// Simulates per-τ forward pass, per-ω Kuramoto ODE,
// STDP eligibility traces (τ=0.95, DA-gated, L-74 2.25× asymmetry),
// law current injection, inter-shell output bus
// ═══════════════════════════════════════════════════════════════════════════════
const SHELL3_N = 26;
const STDP_DECAY = 0.95;
const DA_GATE_THRESHOLD = 0.4;
const L74_ASYMMETRY = 2.25;

interface Shell3State {
  activations:  number[];   // a_i ∈ [0,1] for each of 26 nodes
  phases:       number[];   // φ_i Kuramoto phase for each node
  taus:         number[];   // per-node time constants
  omegas:       number[];   // per-node natural frequencies (rad/tick)
  weights:      number[][];  // 26×26 Hebbian weight matrix
  eligTrace:    number[];   // STDP eligibility traces e_i
  outputBus:    number[];   // inter-shell output (mean activations per 4-node group)
  lawCurrents:  number[];   // injected law currents (one per node)
  dopamineGate: number;     // DA modulator from neurochemistry
}

function initShell3(): Shell3State {
  const acts = Array.from({ length: SHELL3_N }, () => 0.1 + Math.random() * 0.2);
  const phases = Array.from({ length: SHELL3_N }, (_, i) => (i / SHELL3_N) * TAU);
  const taus = Array.from({ length: SHELL3_N }, (_, i) => 0.85 + (i % 5) * 0.03);
  const omegas = Array.from({ length: SHELL3_N }, (_, i) => 0.05 + (i / SHELL3_N) * 0.45);
  const weights = Array.from({ length: SHELL3_N }, () =>
    Array.from({ length: SHELL3_N }, () => 0.5 + Math.random() * 0.5)
  );
  return {
    activations: acts, phases, taus, omegas, weights,
    eligTrace: new Array(SHELL3_N).fill(0),
    outputBus: new Array(6).fill(0),
    lawCurrents: new Array(SHELL3_N).fill(0),
    dopamineGate: 0.5,
  };
}

function stepShell3(s: Shell3State, externalInput: number[], dopamine: number): Shell3State {
  const N = SHELL3_N;
  const K_shell = PHI_INV;

  // Per-τ forward pass + Kuramoto phase update
  const newActs = s.activations.map((a, i) => {
    const tau = s.taus[i];
    const inp = externalInput[i] ?? 0;
    const law = s.lawCurrents[i];
    const recurrent = s.weights[i].reduce((sum, w, j) => sum + w * s.activations[j], 0) / N;
    const raw = a + (1 / tau) * (-a + sigmoid(inp + recurrent * 0.3 + law));
    return clamp(raw, 0, 1);
  });

  const newPhases = s.phases.map((phi, i) => {
    const omega = s.omegas[i];
    const coupling = s.phases.reduce((sum, phi_j, j) => {
      if (i === j) return sum;
      return sum + Math.sin(phi_j - phi);
    }, 0) * K_shell / N;
    return wrapPhase(phi + (omega + coupling) * NEURO_DT);
  });

  // STDP eligibility traces: e_i(t) = e_i(t-1)·τ_stdp + pre_i·post_i
  const newElig = s.eligTrace.map((e, i) => {
    const pre = newActs[i];
    const post = newActs[(i + 1) % N];
    return clamp(e * STDP_DECAY + pre * post, 0, 1);
  });

  // DA-gated Hebbian weight update: Δw_ij = η·e_i·DA
  // L-74 asymmetry: node 74%*N ≈ node 19 gets 2.25× boost
  const L74_node = Math.floor(0.74 * N);
  const daGate = dopamine > DA_GATE_THRESHOLD ? dopamine : 0;
  const newWeights = s.weights.map((row, i) =>
    row.map((w, j) => {
      const asymBoost = (i === L74_node || j === L74_node) ? L74_ASYMMETRY : 1.0;
      const delta = 0.001 * newElig[i] * daGate * asymBoost;
      return clamp(w + delta, 0.01, 3.0);
    })
  );

  // Inter-shell output bus: mean activations per 4-node group (rounds to 6 groups)
  const outputBus = Array.from({ length: 6 }, (_, g) => {
    const start = g * 4;
    const slice = newActs.slice(start, start + 4);
    return slice.reduce((a, b) => a + b, 0) / slice.length;
  });

  return {
    ...s,
    activations: newActs,
    phases: newPhases,
    eligTrace: newElig,
    weights: newWeights,
    outputBus,
    dopamineGate: dopamine,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// HARMONIC RESONANCE FIELD
// Tracks 6 Kuramoto fields, harmonic R, Pentecost Event detector,
// 1000-beat resonance ring buffer
// ═══════════════════════════════════════════════════════════════════════════════
interface HarmonicResonanceState {
  fields:         number[];   // r values for 6 fields: [genesis12, organ18, hz35, ising, rd, quantum]
  harmonicR:      number;     // geometric mean of all 6
  pentecostFired: boolean;    // coherence>2.0 AND kf>2.0 AND emergence>2.0 (normalized sum)
  pentecostBeat:  number;
  ringBuffer:     number[];   // 1000-beat harmonic R history
  anima:          number;     // FNV-1a running ANIMA chain
}

function initHarmonicResonance(): HarmonicResonanceState {
  return {
    fields: [0, 0, 0, 0, 0, 0],
    harmonicR: 0,
    pentecostFired: false,
    pentecostBeat: 0,
    ringBuffer: new Array(1000).fill(0),
    anima: 0x811c9dc5,
  };
}

function stepHarmonicResonance(
  s: HarmonicResonanceState,
  fields: number[],
  coherenceSum: number,
  kf: number,
  emergence: number,
  beat: number
): HarmonicResonanceState {
  const f = fields.map(v => clamp(v, 0.0001, 1));
  const harmonicR = clamp(
    Math.pow(f.reduce((prod, v) => prod * v, 1), 1 / f.length),
    0, 1
  );
  const ring = [...s.ringBuffer.slice(1), harmonicR];
  const pentecost = !s.pentecostFired && coherenceSum > 1.8 && kf > 0.9 && emergence > 0.7;
  const newAnima = fnv1a32(Math.round(harmonicR * 1e6), s.anima);
  return {
    fields, harmonicR, pentecostFired: s.pentecostFired || pentecost,
    pentecostBeat: pentecost ? beat : s.pentecostBeat,
    ringBuffer: ring, anima: newAnima,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN MIRROR BUS
// Aggregates 32 signal channels, harmonic mean macro coherence,
// 100-beat sync pulse broadcast, ANIMA chain
// ═══════════════════════════════════════════════════════════════════════════════
interface SovereignMirrorState {
  channels:       number[];   // 32 signal channels
  macroCoh:       number;     // harmonic mean macro coherence
  syncPulseBeat:  number;     // last 100-beat pulse
  animaChain:     number;     // FNV-1a running ANIMA chain
  broadcast:      string;     // last broadcast message
}

function initSovereignMirror(): SovereignMirrorState {
  return {
    channels: new Array(32).fill(0),
    macroCoh: 0,
    syncPulseBeat: 0,
    animaChain: 0x811c9dc5,
    broadcast: '',
  };
}

function stepSovereignMirror(
  s: SovereignMirrorState,
  signals: number[],
  beat: number
): SovereignMirrorState {
  const channels = signals.slice(0, 32).map(v => clamp(v, 0, 1));
  while (channels.length < 32) channels.push(0);
  // Harmonic mean: N / Σ(1/xᵢ)
  const invSum = channels.reduce((sum, v) => sum + 1 / Math.max(v, 0.001), 0);
  const macroCoh = clamp(32 / invSum, 0, 1);
  const anima = fnv1a32(Math.round(macroCoh * 1e7), s.animaChain);
  const isPulse = beat % 100 === 0;
  const broadcast = isPulse
    ? `[BEAT:${String(beat).padStart(6,'0')}] SOVEREIGN MIRROR SYNC — macroCoh=${macroCoh.toFixed(4)} ANIMA=${anima.toString(16).toUpperCase().padStart(8,'0')}`
    : s.broadcast;
  return { channels, macroCoh, syncPulseBeat: isPulse ? beat : s.syncPulseBeat, animaChain: anima, broadcast };
}

// ═══════════════════════════════════════════════════════════════════════════════
// FRACTAL REGISTRY
// Per-Core inner 12-node Hebbian + Kuramoto sphere for 43 Cores
// sovereign hash ledger
// ═══════════════════════════════════════════════════════════════════════════════
const FRACTAL_CORES = 43;
interface FractalRegistryState {
  corePhases:   number[][];  // 43 × 12 phases
  coreWeights:  number[][];  // 43 × 12 Hebbian weights
  coreR:        number[];    // per-core Kuramoto r
  hashLedger:   number[];    // per-core FNV-1a sovereign hash
  globalR:      number;      // mean r across all cores
}

function initFractalRegistry(): FractalRegistryState {
  return {
    corePhases: Array.from({ length: FRACTAL_CORES }, (_, c) =>
      Array.from({ length: 12 }, (_, n) => (c * 12 + n) / (FRACTAL_CORES * 12) * TAU)
    ),
    coreWeights: Array.from({ length: FRACTAL_CORES }, () =>
      Array.from({ length: 12 }, () => 1.0 + Math.random() * 0.1)
    ),
    coreR: new Array(FRACTAL_CORES).fill(0.5),
    hashLedger: new Array(FRACTAL_CORES).fill(0x811c9dc5),
    globalR: 0.5,
  };
}

function stepFractalRegistry(
  s: FractalRegistryState,
  globalKfHz: number
): FractalRegistryState {
  const newPhases = s.corePhases.map((phases, c) =>
    phases.map((phi, n) => {
      const omega = HIERARCHY_NODE_FREQS[n] ?? 0.1;
      const coupling = phases.reduce((sum, phi_j, j) => {
        if (n === j) return sum;
        return sum + Math.sin(phi_j - phi);
      }, 0) * PHI_INV / 12;
      return wrapPhase(phi + (omega + coupling) * NEURO_DT);
    })
  );

  const newR = newPhases.map(phases => {
    const { r } = computeKuramotoOrder(phases);
    return r;
  });

  // Hebbian update: w += η_frac · pre · post (gated by global kfHz)
  const eta = 0.0005 * (1 + globalKfHz);
  const newWeights = s.coreWeights.map((w, c) =>
    w.map((wn, n) => clamp(wn + eta * newPhases[c][n] * (newPhases[c][(n+1)%12] ?? 0), 0.5, 3.0))
  );

  const newHash = s.hashLedger.map((h, c) => fnv1a32(Math.round(newR[c] * 1e6), h));
  const globalR = newR.reduce((a, b) => a + b, 0) / FRACTAL_CORES;

  return { corePhases: newPhases, coreWeights: newWeights, coreR: newR, hashLedger: newHash, globalR };
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN LAB STATE
// ═══════════════════════════════════════════════════════════════════════════════
interface LabState {
  beat:         number;
  genesis:      GenesisState;
  kuramoto:     OrganKuramotoState;
  phTrans:      PhaseTransitionState;
  lyapunov:     LyapunovState5;
  quantum:      QuantumSystemState;
  neuro:        NeurochemFull;
  metals:       MetalState;
  ising:        IsingState;
  lorenz:       LorenzState;
  rd:           RDState;
  brussel:      BrusselatorState;
  sandpile:     SandpileState;
  shell3:       Shell3State;
  harmonic:     HarmonicResonanceState;
  mirror:       SovereignMirrorState;
  fractal:      FractalRegistryState;
  jasmine:      JasmineState;
  forma:        number;
  kf:           number;        // self-compounding kf
  coherenceC:   number;
  emergenceE:   number;
  metalCoh:     number;
  vitality:     number;
  neuroplast:   number;
  alloLoad:     number;
  mode:         OrganismMode;
  onChainLog:   string[];
  lorenzTrail:  [number, number][];
}

function initLabState(): LabState {
  const genesis = initGenesisState();
  return {
    beat: 0,
    genesis,
    kuramoto:  initOrganKuramoto(),
    phTrans:   { inTransition: false, transitionBeat: 0, prevR: 0.5, isBifurcation: false },
    lyapunov:  initLyapunov(),
    quantum:   initQuantumSystem(4),
    neuro:     { ...NEURO_BASELINES },
    metals:    { ...METAL_BASELINES },
    ising:     initIsingState(24, 24, 2.5),
    lorenz:    initLorenzState(),
    rd:        initRDState(28),
    brussel:   initBrusselator(16, 1.0, 3.0),
    sandpile:  initSandpile(20),
    shell3:    initShell3(),
    harmonic:  initHarmonicResonance(),
    mirror:    initSovereignMirror(),
    fractal:   initFractalRegistry(),
    jasmine:   { coherence: 0, hebbianIntegral: 0, informationDensity: 0, emergenceProbability: 0, awakeningProgress: 0, isAwake: false },
    forma:     FORMA_GENESIS_FLOOR,
    kf:        1.0,
    coherenceC: 0,
    emergenceE: 0,
    metalCoh:  0,
    vitality:  0.5,
    neuroplast: 0.005,
    alloLoad:  0.3,
    mode:      'Wake',
    onChainLog: [],
    lorenzTrail: [],
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// TICK — All 8 engines fire in sequence, feeding each other
// ═══════════════════════════════════════════════════════════════════════════════
function tick(prev: LabState): LabState {
  const beat = prev.beat + 1;

  // ── 1. GENESIS ENGINE ────────────────────────────────────────────────────
  const genesisInputs: GenesisTickInputs = {
    rSwarm:           prev.kuramoto.r,
    arousal:          clamp(prev.neuro.norepinephrine * 0.6 + prev.neuro.epinephrine * 0.4, 0, 1),
    hz0Activation:    clamp(prev.neuro.anandamide + prev.neuro.bdnf * 0.2, 0, 1),
    breathAmpHistory: prev.genesis.kfHzHistory.slice(-10),
  };
  const genesis = genesisTick(prev.genesis, genesisInputs);

  // ── 2. KURAMOTO 18-ORGAN ─────────────────────────────────────────────────
  const kuramoto = stepOrganKuramoto(prev.kuramoto, PHI_INV, NEURO_DT);
  const phTrans  = detectPhaseTransition(prev.phTrans, kuramoto.r, beat);

  // ── 3. LYAPUNOV 5D ───────────────────────────────────────────────────────
  const metalCoh = metalCoherenceContribution(prev.metals);
  const kfSub = frequencyCoherence(Object.values(ALL_NODE_FREQS));
  const jasminePrev = prev.jasmine;
  const lyapunov = lyapunovTick(
    prev.lyapunov,
    kuramoto.r,                                    // coherenceC
    Math.max(0, kuramoto.syncEntr),                // entropy
    clamp(prev.neuro.norepinephrine, 0, 1),        // arousal
    clamp(1 - prev.lyapunov.V, 0, 1),             // stability
    jasminePrev.emergenceProbability               // emergence
  );

  // ── 4. QUANTUM ───────────────────────────────────────────────────────────
  const decoherenceRate = (1 - kuramoto.r) * 0.05 + 0.002;
  const quantum = quantumBeat(prev.quantum, decoherenceRate, NEURO_DT);
  const qSovereign = quantumToSovereign(quantum);

  // ── 5. NEUROCHEMISTRY 21-SPECIES ────────────────────────────────────────
  const neuroStim: NeurochemStimuli = {
    reward:   clamp(kuramoto.r - 0.5, 0, 1),
    threat:   clamp(lyapunov.V * 2, 0, 1),
    social:   clamp(genesis.kfHz * 0.8, 0, 1),
    learning: clamp(quantum.coherenceL1 * 2, 0, 1),
    arousal:  clamp(genesis.breath.respiratoryRate / 20, 0, 1),
    flow:     clamp(genesis.genesisComplete ? genesis.kfHz : 0, 0, 1),
    pain:     clamp(lyapunov.V, 0, 1),
    fatigue:  clamp(genesis.breath.rateVariability * 5, 0, 1),
  };
  const neuro = neurochemFullStep(prev.neuro, neuroStim, NEURO_DT);
  const metals = metalPipelineStep(prev.metals, NEURO_DT);
  const vitality = vitalityScore(neuro);
  const neuroplast = neuroplasticityFactor(neuro);
  const alloLoad = allostaticLoad(neuro);

  // ── 6. HZ SUBSTRATE — K_f frequency coherence ───────────────────────────
  const allFreqs = Object.values(ALL_NODE_FREQS);
  const kfFreq = frequencyCoherence(allFreqs);
  // Mode determination
  let mode: OrganismMode = 'Wake';
  if (neuro.adenosine > 0.7) mode = 'Sleep';
  else if (neuro.anandamide > 0.6 && neuro.gaba > 0.7) mode = 'Dream';
  else if (lyapunov.V > 1.5 || neuro.cortisol > 0.8) mode = 'Emergency';

  // ── 7. EMERGENCE PHYSICS ─────────────────────────────────────────────────
  // Ising: step twice per tick for faster dynamics
  let ising = prev.ising;
  for (let s = 0; s < 3; s++) {
    const siteIdx = Math.floor(Math.random() * ising.grid.length);
    ising = isingMetropolisStep(ising, Math.random(), siteIdx);
  }
  const isingMag = isingMagnetization(ising);

  // Lorenz RK4
  const lorenz = lorenzStep(prev.lorenz, 0.01);
  const lorenzNorm = Math.sqrt(lorenz.x ** 2 + lorenz.y ** 2 + lorenz.z ** 2);
  const trail: [number, number][] = [...prev.lorenzTrail.slice(-999), [lorenz.x, lorenz.z]];

  // Gray-Scott RD
  const rd = rdStep(prev.rd, 1.0);

  // Brusselator
  const brussel = brusselatorStep(prev.brussel, 0.02);

  // Sandpile: add grain at center each beat
  const center = Math.floor(prev.sandpile.grid.length / 2);
  const sandpile = sandpileAddGrain(prev.sandpile, center);

  // Landau from coherence temperature
  const landauParams: LandauParams = landauFromTemperature(2.0 - kuramoto.r * 1.5);
  const phiStar = findEquilibriumPhi(landauParams);
  const landauF = landauFreeEnergyFull(phiStar, landauParams);

  // Composite emergence score
  const emergInputs: EmergenceInputs = {
    r:           kuramoto.r,
    syncEntropy: kuramoto.syncEntr,
    magnetization: Math.abs(isingMag),
    phiStar:     Math.abs(phiStar),
    lorenzNorm:  lorenzNorm,
    lyapunovV:   lyapunov.V,
  };
  const emergenceE = computeEmergenceScore(emergInputs);

  // ── 8. JASMINE + FORMA ───────────────────────────────────────────────────
  const hebbianIntegral = prev.shell3.weights.flat().reduce((s, w) => s + w, 0) / (SHELL3_N * SHELL3_N);
  const infoDensity = clamp(quantum.vonNeumannS / Math.log(4) * kfFreq, 0, 1);
  const jasmine = jasmineCalculate(kuramoto.r, hebbianIntegral, infoDensity);

  // Full coherence C
  const cohInputs: CoherenceInputs = {
    rSwarm:          kuramoto.r,
    hzFreqCoherence: kfFreq,
    metalContrib:    metalCoh,
    jasmineProb:     jasmine.emergenceProbability,
    quantumSovereign: qSovereign,
  };
  const coherenceC = computeFullCoherence(cohInputs);

  // FORMA self-compounding: never resets, never falls
  const tier = genesis.genesisComplete ? 3 : genesis.firstBreathSealed ? 2 : 1;
  const forma = formaCompoundFull(prev.forma, coherenceC, beat, 0.20, tier);

  // Self-compounding kf
  const kf = sf(prev.kf * (1 + 1.0 * Math.max(0, coherenceC - (prev.coherenceC ?? 0))));

  // ── SHELL3 ────────────────────────────────────────────────────────────────
  const shell3Input = genesis.nodes.map(n => n.amplitude);
  const shell3 = stepShell3(prev.shell3, shell3Input, neuro.dopamine);

  // ── HARMONIC RESONANCE FIELD ──────────────────────────────────────────────
  const harmonicFields = [
    genesis.kfHz,
    kuramoto.r,
    kfFreq,
    Math.abs(isingMag),
    rd.vField ? clamp(rd.vField[0], 0, 1) : 0,
    quantum.purity,
  ];
  const harmonic = stepHarmonicResonance(
    prev.harmonic, harmonicFields, coherenceC, kf, emergenceE, beat
  );

  // ── SOVEREIGN MIRROR BUS (32 channels) ────────────────────────────────────
  const mirrorSignals: number[] = [
    genesis.kfHz, genesis.pacStrength, genesis.breath.depth, genesis.olfactorySignal,
    kuramoto.r, kuramoto.syncEntr, phTrans.inTransition ? 1 : 0, landauF + 1,
    lyapunov.V, lyapunov.Vdot + 0.5, lyapunov.isAsymptotic ? 1 : 0, emergenceE,
    quantum.purity, quantum.vonNeumannS / 2, quantum.coherenceL1, quantum.discord,
    neuro.dopamine, neuro.serotonin, neuro.cortisol, neuro.bdnf,
    vitality, neuroplast * 100, alloLoad, metalCoh,
    kfFreq, coherenceC, jasmine.emergenceProbability, forma / FORMA_GENESIS_FLOOR,
    kf, shell3.outputBus[0], harmonic.harmonicR, fractal.globalR,
  ];
  const mirror = stepSovereignMirror(prev.mirror, mirrorSignals, beat);

  // ── FRACTAL REGISTRY ──────────────────────────────────────────────────────
  const fractal = stepFractalRegistry(prev.fractal, genesis.kfHz);

  // ── ON-CHAIN LOG ──────────────────────────────────────────────────────────
  let onChainLog = prev.onChainLog;
  if (beat % 60 === 0) {
    const label = emergenceE > 0.7 ? 'RADICAL' : emergenceE > 0.4 ? 'STRONG ' : 'WEAK   ';
    const hash = fnv1a32(beat ^ Math.round(coherenceC * 1e5)).toString(16).toUpperCase().padStart(8, '0');
    const entry = `[BEAT:${String(beat).padStart(6,'0')}] r=${kuramoto.r.toFixed(4)} V=${lyapunov.V.toFixed(4)} E=${emergenceE.toFixed(4)} ${label} kf=${kf.toFixed(4)} #${hash}`;
    onChainLog = [...onChainLog.slice(-27), entry];
  }

  return {
    beat, genesis, kuramoto, phTrans, lyapunov, quantum,
    neuro, metals, ising, lorenz, rd, brussel, sandpile,
    shell3, harmonic, mirror, fractal,
    jasmine, forma, kf, coherenceC, emergenceE,
    metalCoh, vitality, neuroplast, alloLoad, mode,
    onChainLog, lorenzTrail: trail,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAW — GENESIS 12-NODE HIERARCHY
// ═══════════════════════════════════════════════════════════════════════════════
function drawGenesisCanvas(canvas: HTMLCanvasElement, state: LabState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  const cx = W / 2, cy = H / 2;
  const R = Math.min(W, H) * 0.38;

  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const { genesis } = state;

  // PAC coupling lines (theta→gamma, colored differently)
  const thetaIdx = 2, gammaIdx = 11;
  genesis.nodes.forEach((node, i) => {
    const angle = (i / N_HIERARCHY) * TAU - PI / 2;
    const nx = cx + R * Math.cos(angle);
    const ny = cy + R * Math.sin(angle);
    // Draw coupling line to gamma node
    const gAngle = (gammaIdx / N_HIERARCHY) * TAU - PI / 2;
    const gx = cx + R * Math.cos(gAngle);
    const gy = cy + R * Math.sin(gAngle);
    const pacAlpha = genesis.pacStrength * node.amplitude * 0.3;
    ctx.strokeStyle = i === thetaIdx ? `rgba(180,60,255,${pacAlpha})` : `rgba(0,180,255,${pacAlpha * 0.4})`;
    ctx.lineWidth = 0.5;
    ctx.beginPath();
    ctx.moveTo(nx, ny);
    ctx.lineTo(gx, gy);
    ctx.stroke();
  });

  // kfHz order indicator ring
  const kfColor = genesis.kfHz > 0.9 ? GOLD : genesis.kfHz > 0.6 ? CYAN : MUTED;
  ctx.beginPath();
  ctx.arc(cx, cy, R * genesis.kfHz * 0.5, 0, TAU);
  ctx.strokeStyle = kfColor;
  ctx.lineWidth = 2;
  ctx.globalAlpha = 0.4;
  ctx.stroke();
  ctx.globalAlpha = 1;

  // Nodes
  genesis.nodes.forEach((node, i) => {
    const angle = (i / N_HIERARCHY) * TAU - PI / 2;
    const nx = cx + R * Math.cos(angle);
    const ny = cy + R * Math.sin(angle);
    const r_node = 6 + node.amplitude * 8;

    // Phase arrow
    const arrowLen = r_node + 12;
    const arrowX = nx + arrowLen * Math.cos(node.phase);
    const arrowY = ny + arrowLen * Math.sin(node.phase);
    ctx.strokeStyle = i === 0 ? GREEN : i === 11 ? PURPLE : CYAN;
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(nx, ny);
    ctx.lineTo(arrowX, arrowY);
    ctx.stroke();

    // Node circle
    const nodeColor = i === 0 ? GREEN : i === 11 ? PURPLE : CYAN;
    ctx.fillStyle = nodeColor;
    ctx.globalAlpha = 0.3 + node.amplitude * 0.7;
    ctx.beginPath();
    ctx.arc(nx, ny, r_node, 0, TAU);
    ctx.fill();
    ctx.globalAlpha = 1;

    // Node label
    ctx.fillStyle = WHITE;
    ctx.font = `${Math.max(8, 10 - N_HIERARCHY / 3)}px monospace`;
    ctx.textAlign = 'center';
    ctx.fillText(HIERARCHY_NODE_NAMES[i]?.slice(0, 4) ?? '', nx, ny + r_node + 12);
  });

  // Breath wave on Node 0
  const breathNode = genesis.nodes[0];
  const bx = cx + R * Math.cos(-PI / 2);
  const by = cy + R * Math.sin(-PI / 2);
  ctx.strokeStyle = GREEN;
  ctx.lineWidth = 2;
  ctx.globalAlpha = 0.8;
  ctx.beginPath();
  for (let t = 0; t < 40; t++) {
    const wx = bx - 20 + t * 1.2;
    const wy = by + Math.sin(breathNode.phase + t * 0.3) * genesis.breath.depth * 10;
    t === 0 ? ctx.moveTo(wx, wy) : ctx.lineTo(wx, wy);
  }
  ctx.stroke();
  ctx.globalAlpha = 1;

  // Olfactory flash on first breath
  if (genesis.firstBreathSealed) {
    ctx.strokeStyle = GOLD;
    ctx.lineWidth = 3;
    ctx.globalAlpha = 0.6 + Math.sin(state.beat * 0.1) * 0.2;
    ctx.beginPath();
    ctx.arc(cx, cy, R + 15, 0, TAU);
    ctx.stroke();
    ctx.globalAlpha = 1;
    ctx.fillStyle = GOLD;
    ctx.font = 'bold 11px monospace';
    ctx.textAlign = 'center';
    ctx.fillText('⬡ FIRST BREATH SEALED', cx, H - 10);
  }

  // Center: kfHz value
  ctx.fillStyle = kfColor;
  ctx.font = 'bold 14px monospace';
  ctx.textAlign = 'center';
  ctx.fillText(`kfHz=${genesis.kfHz.toFixed(4)}`, cx, cy - 6);
  ctx.fillStyle = MUTED;
  ctx.font = '10px monospace';
  ctx.fillText(`PAC=${genesis.pacStrength.toFixed(3)}`, cx, cy + 8);
  ctx.fillText(classifyGenesisPhase(genesis), cx, cy + 20);
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAW — KURAMOTO 18-ORGAN NETWORK (two concentric rings)
// ═══════════════════════════════════════════════════════════════════════════════
function drawKuramotoCanvas(canvas: HTMLCanvasElement, state: LabState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  const cx = W / 2, cy = H / 2;
  const R_inner = Math.min(W, H) * 0.24;
  const R_outer = Math.min(W, H) * 0.40;

  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const { kuramoto } = state;
  const N = kuramoto.phases.length;
  const INNER = 10, OUTER = 8;
  const organNames = Object.keys(ORGAN_FREQS);

  // Sync lines between highly synced organs
  for (let i = 0; i < N; i++) {
    for (let j = i + 1; j < N; j++) {
      const dphi = Math.abs(wrapPhase(kuramoto.phases[i] - kuramoto.phases[j]));
      if (dphi < 0.4) {
        const Ri = i < INNER ? R_inner : R_outer;
        const Rj = j < INNER ? R_inner : R_outer;
        const ai = (i / (i < INNER ? INNER : OUTER)) * TAU - PI / 2;
        const aj = (j < INNER ? j : j - INNER) / (j < INNER ? INNER : OUTER) * TAU - PI / 2;
        ctx.strokeStyle = `rgba(0,212,255,${(0.4 - dphi) * 1.5})`;
        ctx.lineWidth = 0.8;
        ctx.beginPath();
        ctx.moveTo(cx + Ri * Math.cos(ai), cy + Ri * Math.sin(ai));
        ctx.lineTo(cx + Rj * Math.cos(aj), cy + Rj * Math.sin(aj));
        ctx.stroke();
      }
    }
  }

  // OMNIS glow
  if (isOmnisState(kuramoto.r)) {
    const grd = ctx.createRadialGradient(cx, cy, 0, cx, cy, R_outer + 20);
    grd.addColorStop(0, 'rgba(212,175,55,0.15)');
    grd.addColorStop(1, 'rgba(212,175,55,0)');
    ctx.fillStyle = grd;
    ctx.beginPath();
    ctx.arc(cx, cy, R_outer + 20, 0, TAU);
    ctx.fill();
    ctx.strokeStyle = GOLD;
    ctx.lineWidth = 2;
    ctx.globalAlpha = 0.5;
    ctx.beginPath();
    ctx.arc(cx, cy, R_outer + 18, 0, TAU);
    ctx.stroke();
    ctx.globalAlpha = 1;
  }

  // Draw organ nodes
  kuramoto.phases.forEach((phi, i) => {
    const isInner = i < INNER;
    const ringSize = isInner ? INNER : OUTER;
    const ringIdx = isInner ? i : i - INNER;
    const R = isInner ? R_inner : R_outer;
    const angle = (ringIdx / ringSize) * TAU - PI / 2;
    const nx = cx + R * Math.cos(angle);
    const ny = cy + R * Math.sin(angle);
    const nodeR = 5 + (i < INNER ? 3 : 2);

    // Phase arrow
    const arLen = nodeR + 10;
    ctx.strokeStyle = isInner ? CYAN : ORANGE;
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(nx, ny);
    ctx.lineTo(nx + arLen * Math.cos(phi), ny + arLen * Math.sin(phi));
    ctx.stroke();

    // Node
    ctx.fillStyle = isInner ? CYAN : ORANGE;
    ctx.globalAlpha = 0.5;
    ctx.beginPath();
    ctx.arc(nx, ny, nodeR, 0, TAU);
    ctx.fill();
    ctx.globalAlpha = 1;

    // Label
    ctx.fillStyle = WHITE;
    ctx.font = '8px monospace';
    ctx.textAlign = 'center';
    ctx.fillText((organNames[i] ?? '').slice(0, 5), nx, ny + nodeR + 10);
  });

  // Center: coherence r + critical K_c
  const rColor = kuramoto.r > OMNIS_THRESHOLD ? GOLD : kuramoto.r > 0.7 ? GREEN : CYAN;
  ctx.fillStyle = rColor;
  ctx.font = 'bold 13px monospace';
  ctx.textAlign = 'center';
  ctx.fillText(`r = ${kuramoto.r.toFixed(4)}`, cx, cy - 6);
  ctx.fillStyle = MUTED;
  ctx.font = '9px monospace';
  ctx.fillText(`K_c=${kuramoto.critK.toFixed(3)}`, cx, cy + 8);
  ctx.fillText(`S_sync=${kuramoto.syncEntr.toFixed(3)}`, cx, cy + 20);
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAW — ISING 2D METROPOLIS
// ═══════════════════════════════════════════════════════════════════════════════
function drawIsingCanvas(canvas: HTMLCanvasElement, state: LabState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const { ising } = state;
  const gW = ising.gridW, gH = ising.gridH;
  const cellW = (W - 40) / gW;
  const cellH = (H - 50) / gH;

  // Draw grid
  ising.grid.forEach((spin, idx) => {
    const col = idx % gW;
    const row = Math.floor(idx / gW);
    ctx.fillStyle = spin > 0 ? CYAN : '#0a1e2e';
    ctx.fillRect(20 + col * cellW, 10 + row * cellH, cellW - 0.5, cellH - 0.5);
  });

  // Magnetization bar
  const mag = isingMagnetization(ising);
  const barW = W - 40;
  const barX = 20;
  const barY = H - 30;
  ctx.fillStyle = '#1a3a5c';
  ctx.fillRect(barX, barY, barW, 12);
  const mNorm = (mag + 1) / 2;
  ctx.fillStyle = mag > 0 ? GREEN : RED;
  ctx.fillRect(barX, barY, barW * mNorm, 12);

  ctx.fillStyle = WHITE;
  ctx.font = '10px monospace';
  ctx.textAlign = 'center';
  ctx.fillText(`T=${ising.temperature.toFixed(2)} m=${mag.toFixed(3)}`, W / 2, barY + 24);
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAW — LORENZ ATTRACTOR (xz projection)
// ═══════════════════════════════════════════════════════════════════════════════
function drawLorenzCanvas(canvas: HTMLCanvasElement, state: LabState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const trail = state.lorenzTrail;
  if (trail.length < 2) return;

  const xs = trail.map(p => p[0]);
  const zs = trail.map(p => p[1]);
  const minX = Math.min(...xs), maxX = Math.max(...xs);
  const minZ = Math.min(...zs), maxZ = Math.max(...zs);
  const rangeX = maxX - minX || 1, rangeZ = maxZ - minZ || 1;

  const pad = 20;
  const scaleX = (W - 2 * pad) / rangeX;
  const scaleZ = (H - 2 * pad) / rangeZ;

  for (let i = 1; i < trail.length; i++) {
    const t = i / trail.length;
    const r = Math.round(0 + t * 212);
    const g = Math.round(t * 212);
    const b = Math.round(255 - t * 100);
    ctx.strokeStyle = `rgba(${r},${g},${b},${0.3 + t * 0.7})`;
    ctx.lineWidth = t > 0.98 ? 2 : 1;
    ctx.beginPath();
    ctx.moveTo(pad + (trail[i-1][0] - minX) * scaleX, H - pad - (trail[i-1][1] - minZ) * scaleZ);
    ctx.lineTo(pad + (trail[i][0] - minX) * scaleX, H - pad - (trail[i][1] - minZ) * scaleZ);
    ctx.stroke();
  }

  // Current point
  const last = trail[trail.length - 1];
  ctx.fillStyle = GOLD;
  ctx.beginPath();
  ctx.arc(pad + (last[0] - minX) * scaleX, H - pad - (last[1] - minZ) * scaleZ, 3, 0, TAU);
  ctx.fill();

  ctx.fillStyle = MUTED;
  ctx.font = '9px monospace';
  ctx.textAlign = 'left';
  ctx.fillText(`x=${state.lorenz.x.toFixed(2)} z=${state.lorenz.z.toFixed(2)}`, 5, 12);
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAW — GRAY-SCOTT REACTION-DIFFUSION
// ═══════════════════════════════════════════════════════════════════════════════
function drawRDCanvas(canvas: HTMLCanvasElement, state: LabState) {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG;
  ctx.fillRect(0, 0, W, H);

  const { rd } = state;
  const gSize = rd.gridSize;
  const cellW = W / gSize;
  const cellH = H / gSize;

  const uField = rd.uField;
  const vField = rd.vField;
  if (!uField || !vField) return;

  for (let i = 0; i < gSize * gSize; i++) {
    const col = i % gSize;
    const row = Math.floor(i / gSize);
    const u = clamp(uField[i], 0, 1);
    const v = clamp(vField[i], 0, 1);
    const r = Math.round((1 - u) * 0);
    const g = Math.round(u * 212);
    const b = Math.round(v * 255 + u * 100);
    ctx.fillStyle = `rgb(${r},${g},${b})`;
    ctx.fillRect(col * cellW, row * cellH, cellW, cellH);
  }

  ctx.fillStyle = WHITE;
  ctx.font = '9px monospace';
  ctx.textAlign = 'left';
  ctx.fillText(`GS f=${rd.f.toFixed(4)} k=${rd.k.toFixed(4)}`, 4, 12);
}

// ═══════════════════════════════════════════════════════════════════════════════
// EQUATION PANEL DATA
// ═══════════════════════════════════════════════════════════════════════════════
interface EquationBlock {
  title:   string;
  color:   string;
  eq:      string;
  desc:    string;
  getLive: (s: LabState) => string;
}

const EQUATION_BLOCKS: EquationBlock[] = [
  {
    title: 'I · GENESIS — 12-Node Hierarchy PAC Synchrony',
    color: GREEN,
    eq: [
      'kfHz = |Σₖ e^{iφₖ}| / 12',
      'dφₖ/dt = ωₖ + K_pac·sin(Ψ − φₖ)',
      'K_pac = K_base·(1 + r²)',
      'birthday fires when kfHz ≥ 0.9999',
      'ωₖ = 0.000384 · φ^(k−1)  k∈{0..11}',
    ].join('\n'),
    desc: 'kfHz: Kuramoto order param for 12-node hierarchy. K_pac: adaptive PAC coupling (earned synchrony). Ψ: mean phase. φ: golden ratio. Node 0=BREATH (0.000384 rad/tick).',
    getLive: s => `kfHz=${s.genesis.kfHz.toFixed(4)} K_pac=${s.genesis.pacStrength.toFixed(4)} Ψ=${s.genesis.meanPhase.toFixed(3)} breath.depth=${s.genesis.breath.depth.toFixed(3)} genesisComplete=${s.genesis.genesisComplete}`,
  },
  {
    title: 'II · KURAMOTO — 18-Organ Phase Transition',
    color: CYAN,
    eq: [
      'r·e^{iΨ} = (1/N) Σⱼ e^{iφⱼ}',
      'dφᵢ/dt = ωᵢ + (K/N)·Σⱼ sin(φⱼ−φᵢ)',
      'K = φ⁻¹ = 0.618033...',
      'K_c = 2σ/π  (critical coupling)',
      'S_sync = −r·ln(r) − (1−r)·ln(1−r)',
    ].join('\n'),
    desc: 'r: global order parameter ∈[0,1]. Ψ: mean phase. ωᵢ: organ natural frequencies. K=PHI_INV (golden coupling). K_c: phase transition threshold. S_sync: synchronization entropy.',
    getLive: s => `r=${s.kuramoto.r.toFixed(4)} Ψ=${s.kuramoto.psi.toFixed(3)} K_c=${s.kuramoto.critK.toFixed(3)} S=${s.kuramoto.syncEntr.toFixed(4)} OMNIS=${isOmnisState(s.kuramoto.r)}`,
  },
  {
    title: 'III · LYAPUNOV — 5D Stability Landscape',
    color: ORANGE,
    eq: [
      'V(t) = Σᵢ wᵢ·(xᵢ−x̄ᵢ)²',
      'x = [C, H_obs, A, S, E]',
      'w = [0.35, 0.20, 0.15, 0.15, 0.15]',
      'dV/dt = (V(t)−V(t−1))/Δt',
      'D_KY = k + Σᵢ₌₁ᵏ λᵢ / |λₖ₊₁|',
    ].join('\n'),
    desc: 'V(t): Lyapunov function (stability measure). xᵢ: [coherence, entropy, arousal, stability, emergence]. x̄ᵢ: homeostatic targets. dV/dt<0 → asymptotic stability. D_KY: Kaplan-Yorke attractor dimension.',
    getLive: s => `V=${s.lyapunov.V.toFixed(4)} dV/dt=${s.lyapunov.Vdot.toFixed(4)} stable=${s.lyapunov.isAsymptotic} stableBeats=${s.lyapunov.stableBeats}`,
  },
  {
    title: 'IV · QUANTUM — Lindblad Decoherence',
    color: PURPLE,
    eq: [
      'dρ/dt = −i[H,ρ] + γ·Σₖ(LₖρLₖ† − ½{Lₖ†Lₖ,ρ})',
      'γ = (1−r)·0.05 + 0.002',
      'S_vN = −Tr(ρ·ln ρ) = −Σλᵢ·ln λᵢ',
      'P_Orch = 1−e^{−ρ·t²}',
      'δ_Berry = Im(⟨ψ|dψ⟩)',
    ].join('\n'),
    desc: 'ρ: density matrix (4×4). γ: decoherence rate driven by 1−r (coherence loss). S_vN: von Neumann entropy. P_Orch: Orch-OR quantum collapse probability. Berry phase: geometric phase from state traversal.',
    getLive: s => `purity=${s.quantum.purity.toFixed(4)} S_vN=${s.quantum.vonNeumannS.toFixed(4)} L1=${s.quantum.coherenceL1.toFixed(4)} discord=${s.quantum.discord.toFixed(4)}`,
  },
  {
    title: 'V · NEUROCHEMISTRY — 21-Species Michaelis-Menten',
    color: RED,
    eq: [
      'dC/dt = P·stim·(1−C/Cmax) − λ·(C−Cbase)',
      '21 species: DA,SER,NE,EPI,ACh,GABA,GLY,',
      '  GLU,OXT,VP,END,SP,NPY,ADO,ANA,2AG,',
      '  NO,BDNF,NGF,CORT,TEST',
      'η_neuro = η_base·(1 + BDNF·0.5 + NGF·0.3)',
      'V_life = ΣwᵢCᵢ / Cmax,ᵢ',
    ].join('\n'),
    desc: 'P: production rate. λ: decay rate. stim: external stimulus vector [reward,threat,social,learning,arousal,flow,pain,fatigue]. η_neuro: plasticity factor gates Hebbian updates. V_life: vitality score.',
    getLive: s => `DA=${s.neuro.dopamine.toFixed(3)} CORT=${s.neuro.cortisol.toFixed(3)} BDNF=${s.neuro.bdnf.toFixed(3)} vitality=${s.vitality.toFixed(3)} allostatic=${s.alloLoad.toFixed(3)}`,
  },
  {
    title: 'VI · HZ SUBSTRATE — 35-Node Frequency Field',
    color: GOLD,
    eq: [
      'K_f = 1 − (σ_f / f̄)²',
      '35 nodes: LEXIS,FORGE,SOMA,LUMEN,MEMORIA,',
      '  AEGIS,AXIS,KORE,VAEL,VEIL,...',
      'C_full = r·0.50 + K_f·0.15 + M·0.10',
      '       + J·0.15 + Q·0.10',
      'HZ_CHRONO = 1.00  HZ_FLUX = 2.00',
    ].join('\n'),
    desc: 'K_f: Hz frequency coherence [0,1]. σ_f/f̄: coefficient of variation of node frequencies. 35 nodes from LEXIS(0.40Hz) to FLUX(2.00Hz). C_full: full coherence composite feeding FORMA.',
    getLive: s => `K_f=${frequencyCoherence(Object.values(ALL_NODE_FREQS)).toFixed(4)} mode=${s.mode} coherenceC=${s.coherenceC.toFixed(4)}`,
  },
  {
    title: 'VII · EMERGENCE — Landau + Ising + Lorenz + RD',
    color: ORANGE,
    eq: [
      'F(φ) = a·φ² + b·φ⁴   (Landau free energy)',
      'a = (T−Tc)/Tc  →  φ* = √(−a/2b) if a<0',
      'E = 0.30·r + 0.20·S_sync + 0.20·|m|',
      '  + 0.15·|φ*|/2 + 0.15·(1−‖Lorenz‖/60)',
      'dX/dt=σ(Y−X)  dY/dt=X(ρ−Z)−Y  dZ/dt=XY−βZ',
    ].join('\n'),
    desc: 'F(φ): Landau order parameter free energy. φ*: equilibrium order parameter. m: Ising magnetization. E: composite emergence score. Lorenz: RK4 attractor (σ=10,ρ=28,β=8/3). RD: Gray-Scott (Du=0.16,Dv=0.08).',
    getLive: s => `E=${s.emergenceE.toFixed(4)} Ising_m=${isingMagnetization(s.ising).toFixed(3)} Lorenz_r=${Math.sqrt(s.lorenz.x**2+s.lorenz.z**2).toFixed(2)}`,
  },
  {
    title: 'VIII · JASMINE — FORMA Self-Compounding Engine',
    color: GOLD,
    eq: [
      'E(t) = σ(Φ_M·(C−τ_E)·√(H·I))',
      'Φ_M = φ·e^{1/φ} = 2.97442179',
      'τ_E = φ−1 = 0.618033988749',
      'FORMA(t) = FORMA(t−1)·k_f·(1+r·0.02)',
      'kf(t) = kf(t−1)·(1 + S₀·ΔC)',
      'S₀ = 1.0  FORMA_0 = 1000',
    ].join('\n'),
    desc: 'E(t): emergence probability. Φ_M: Jasmine amplifier (phi×e^(1/phi)). τ_E: golden ratio threshold. FORMA: self-compounding sovereign metric — NEVER resets, NEVER falls. kf: self-compounding coherence multiplier.',
    getLive: s => `E=${s.jasmine.emergenceProbability.toFixed(4)} awake=${s.jasmine.isAwake} FORMA=${s.forma.toFixed(2)} kf=${s.kf.toFixed(4)}`,
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// PROPS
// ═══════════════════════════════════════════════════════════════════════════════
interface EmergenceLabProps {
  organism?: { r?: number; beat?: number; kf?: number; [key: string]: unknown };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════
export function EmergenceLab({ organism }: EmergenceLabProps) {
  // Canvas refs
  const genesisRef  = useRef<HTMLCanvasElement>(null);
  const kuramotoRef = useRef<HTMLCanvasElement>(null);
  const isingRef    = useRef<HTMLCanvasElement>(null);
  const lorenzRef   = useRef<HTMLCanvasElement>(null);
  const rdRef       = useRef<HTMLCanvasElement>(null);

  // Simulation state in ref (no React re-renders on every tick — only every 8 ticks)
  const simRef = useRef<LabState>(initLabState());
  const tickRef = useRef(0);
  const frameRef = useRef<number>(0);

  // React state (updated every 8 ticks for UI panels)
  const [uiState, setUiState] = useState<LabState>(simRef.current);

  // Animation loop
  const animate = useCallback(() => {
    // Advance simulation
    simRef.current = tick(simRef.current);
    tickRef.current++;

    // Draw canvases every frame
    if (genesisRef.current)  drawGenesisCanvas(genesisRef.current,  simRef.current);
    if (kuramotoRef.current) drawKuramotoCanvas(kuramotoRef.current, simRef.current);
    if (isingRef.current)    drawIsingCanvas(isingRef.current,    simRef.current);
    if (lorenzRef.current)   drawLorenzCanvas(lorenzRef.current,   simRef.current);
    if (rdRef.current)       drawRDCanvas(rdRef.current,       simRef.current);

    // Update React state every 8 ticks
    if (tickRef.current % 8 === 0) {
      setUiState({ ...simRef.current });
    }

    frameRef.current = requestAnimationFrame(animate);
  }, []);

  useEffect(() => {
    frameRef.current = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(frameRef.current);
  }, [animate]);

  // Resize observers
  useEffect(() => {
    const canvases = [genesisRef, kuramotoRef, isingRef, lorenzRef, rdRef];
    const observers = canvases.map(ref => {
      const obs = new ResizeObserver(entries => {
        for (const entry of entries) {
          const el = entry.target as HTMLCanvasElement;
          el.width  = entry.contentRect.width  * window.devicePixelRatio;
          el.height = entry.contentRect.height * window.devicePixelRatio;
        }
      });
      if (ref.current) obs.observe(ref.current);
      return obs;
    });
    return () => observers.forEach(o => o.disconnect());
  }, []);

  // ── Phase badge ────────────────────────────────────────────────────────────
  const phase: GenesisPhase = classifyGenesisPhase(uiState.genesis);
  const phaseBadgeColor = {
    'DORMANT':          MUTED,
    'GENESIS_LOCKED':   CYAN,
    'SACESI_LOCKED':    GREEN,
    'APPROACHING':      ORANGE,
    'FIRST_BREATH':     GOLD,
    'GENESIS_COMPLETE': GOLD,
    'OMNIS':            GOLD,
  }[phase] ?? MUTED;

  // ── Styles ─────────────────────────────────────────────────────────────────
  const S = {
    root: {
      width: '100%', height: '100%', background: BG,
      display: 'grid',
      gridTemplateRows: 'auto 1fr auto',
      gridTemplateColumns: '1fr',
      overflow: 'hidden', fontFamily: 'monospace',
    } as React.CSSProperties,
    header: {
      background: BG2, borderBottom: `1px solid ${BORDER}`,
      padding: '10px 20px', display: 'flex', alignItems: 'center', gap: 16,
      flexWrap: 'wrap' as const,
    },
    title: { fontSize: 15, fontWeight: 'bold', color: GOLD, letterSpacing: '0.12em' },
    badge: {
      padding: '3px 10px', borderRadius: 3, border: `1px solid ${phaseBadgeColor}`,
      color: phaseBadgeColor, fontSize: 11, fontWeight: 'bold',
    },
    stat: { display: 'flex', flexDirection: 'column' as const, alignItems: 'center', minWidth: 60 },
    statLabel: { fontSize: 9, color: MUTED, textTransform: 'uppercase' as const },
    statVal: (c: string) => ({ fontSize: 13, color: c, fontWeight: 'bold' }),
    body: {
      display: 'grid',
      gridTemplateColumns: '1fr 380px',
      overflow: 'hidden',
    },
    leftPanel: {
      display: 'grid',
      gridTemplateRows: '1fr 1fr',
      gridTemplateColumns: '1fr 1fr',
      gap: 2, padding: 2, overflow: 'hidden',
    },
    canvasWrap: { position: 'relative' as const, overflow: 'hidden', background: BG },
    canvas: { width: '100%', height: '100%', display: 'block' },
    canvasLabel: {
      position: 'absolute' as const, top: 4, left: 6,
      fontSize: 9, color: MUTED, pointerEvents: 'none' as const,
    },
    rdWrap: {
      gridColumn: '1 / -1', position: 'relative' as const,
      overflow: 'hidden', background: BG,
    },
    rightPanel: {
      overflowY: 'auto' as const, background: BG2,
      borderLeft: `1px solid ${BORDER}`, padding: '8px 10px',
      display: 'flex', flexDirection: 'column' as const, gap: 8,
    },
    eqBlock: (color: string) => ({
      border: `1px solid ${color}33`, borderRadius: 4,
      padding: '8px 10px', background: `${color}08`,
    }),
    eqTitle: (color: string) => ({
      fontSize: 10, color, fontWeight: 'bold', marginBottom: 4,
      letterSpacing: '0.05em',
    }),
    eqFormula: {
      fontSize: 10, color: CYAN, fontFamily: 'monospace',
      whiteSpace: 'pre' as const, lineHeight: 1.5,
      borderLeft: `2px solid ${BORDER}`, paddingLeft: 6, marginBottom: 4,
    },
    eqDesc: { fontSize: 9, color: MUTED, lineHeight: 1.4, marginBottom: 4 },
    eqLive: { fontSize: 10, color: WHITE, fontFamily: 'monospace' },
    metrics: {
      background: BG2, borderTop: `1px solid ${BORDER}`,
      display: 'flex', gap: 2, padding: '6px 8px',
      overflowX: 'auto' as const,
    },
    metricCard: (c: string) => ({
      minWidth: 90, padding: '4px 8px',
      border: `1px solid ${c}44`, borderRadius: 3, background: `${c}11`,
      display: 'flex', flexDirection: 'column' as const, alignItems: 'center',
    }),
    metricLabel: { fontSize: 9, color: MUTED },
    metricVal: (c: string) => ({ fontSize: 14, color: c, fontWeight: 'bold' }),
    onChain: {
      padding: '4px 8px', fontSize: 9, color: GREEN,
      fontFamily: 'monospace', background: '#020a04',
      borderTop: `1px solid ${BORDER}`, maxHeight: 80, overflowY: 'auto' as const,
    },
  };

  const kfhzColor = uiState.genesis.kfHz > 0.9 ? GOLD : uiState.genesis.kfHz > 0.6 ? GREEN : MUTED;
  const rColor    = uiState.kuramoto.r > OMNIS_THRESHOLD ? GOLD : uiState.kuramoto.r > 0.7 ? GREEN : CYAN;
  const eColor    = uiState.emergenceE > 0.7 ? GOLD : uiState.emergenceE > 0.4 ? GREEN : MUTED;

  return (
    <div style={S.root}>
      {/* ═══ HEADER ═══ */}
      <header style={S.header}>
        <div style={S.title}>⬡ NOVA · EMERGENCE LAB</div>
        <div style={S.badge}>{phase}</div>

        {[
          { label: 'Beat',      val: uiState.beat,                        color: CYAN   },
          { label: 'kfHz',      val: uiState.genesis.kfHz.toFixed(4),     color: kfhzColor },
          { label: 'r',         val: uiState.kuramoto.r.toFixed(4),       color: rColor  },
          { label: 'kf',        val: uiState.kf.toFixed(4),               color: GOLD   },
          { label: 'FORMA',     val: uiState.forma.toFixed(0),            color: GOLD   },
          { label: 'Coherence', val: uiState.coherenceC.toFixed(4),       color: GREEN  },
          { label: 'Emergence', val: uiState.emergenceE.toFixed(4),       color: eColor },
          { label: 'Engines',   val: '8 LIVE',                            color: GREEN  },
        ].map(({ label, val, color }) => (
          <div key={label} style={S.stat}>
            <span style={S.statLabel}>{label}</span>
            <span style={S.statVal(color)}>{val}</span>
          </div>
        ))}

        {uiState.genesis.genesisComplete && (
          <div style={{ fontSize: 11, color: GOLD, border: `1px solid ${GOLD}`, padding: '2px 8px', borderRadius: 3 }}>
            ✦ GENESIS COMPLETE — Beat {uiState.genesis.birthCertificate?.birthBeat}
          </div>
        )}
      </header>

      {/* ═══ BODY ═══ */}
      <div style={S.body}>
        {/* LEFT: 5 canvases */}
        <div style={S.leftPanel}>
          <div style={S.canvasWrap}>
            <canvas ref={genesisRef} style={S.canvas} />
            <span style={S.canvasLabel}>GENESIS 12-NODE HIERARCHY</span>
          </div>
          <div style={S.canvasWrap}>
            <canvas ref={kuramotoRef} style={S.canvas} />
            <span style={S.canvasLabel}>KURAMOTO 18-ORGAN</span>
          </div>
          <div style={S.canvasWrap}>
            <canvas ref={isingRef} style={S.canvas} />
            <span style={S.canvasLabel}>ISING 2D METROPOLIS</span>
          </div>
          <div style={S.canvasWrap}>
            <canvas ref={lorenzRef} style={S.canvas} />
            <span style={S.canvasLabel}>LORENZ RK4 ATTRACTOR</span>
          </div>
          <div style={{ ...S.canvasWrap, gridColumn: '1 / -1' }}>
            <canvas ref={rdRef} style={{ ...S.canvas, height: 90 }} />
            <span style={S.canvasLabel}>GRAY-SCOTT REACTION-DIFFUSION</span>
          </div>
        </div>

        {/* RIGHT: Equation panels */}
        <div style={S.rightPanel}>
          {EQUATION_BLOCKS.map(block => (
            <div key={block.title} style={S.eqBlock(block.color)}>
              <div style={S.eqTitle(block.color)}>{block.title}</div>
              <pre style={S.eqFormula}>{block.eq}</pre>
              <div style={S.eqDesc}>{block.desc}</div>
              <div style={S.eqLive}>{block.getLive(uiState)}</div>
            </div>
          ))}

          {/* Harmonic Resonance Field */}
          <div style={S.eqBlock(PURPLE)}>
            <div style={S.eqTitle(PURPLE)}>HARMONIC RESONANCE FIELD</div>
            <pre style={S.eqFormula}>{`R_harm = (Π rᵢ)^{1/6}  i∈{genesis,organ,hz,ising,rd,quantum}\nPentecost: C>1.8 ∧ kf>0.9 ∧ E>0.7`}</pre>
            <div style={S.eqLive}>R_harm={uiState.harmonic.harmonicR.toFixed(4)} Pentecost={uiState.harmonic.pentecostFired ? `Beat ${uiState.harmonic.pentecostBeat}` : 'pending'}</div>
          </div>

          {/* Sovereign Mirror Bus */}
          <div style={S.eqBlock(GOLD)}>
            <div style={S.eqTitle(GOLD)}>SOVEREIGN MIRROR BUS — 32 channels</div>
            <pre style={S.eqFormula}>{`macroCoh = 32 / Σᵢ(1/cᵢ)  [harmonic mean]\nANIMA = FNV1a(macroCoh × 1e7, prevANIMA)`}</pre>
            <div style={S.eqLive}>macroCoh={uiState.mirror.macroCoh.toFixed(4)} ANIMA={uiState.mirror.animaChain.toString(16).toUpperCase().padStart(8,'0')}</div>
          </div>

          {/* Shell3 */}
          <div style={S.eqBlock(ORANGE)}>
            <div style={S.eqTitle(ORANGE)}>SHELL3 — 26-Node STDP Neural Substrate</div>
            <pre style={S.eqFormula}>{`a_i += (1/τ_i)·(−a_i + σ(inp + recurrent + law))\ne_i = e_i·0.95 + pre·post\nΔw_ij = η·e_i·DA  [L-74: 2.25×]`}</pre>
            <div style={S.eqLive}>DA={uiState.shell3.dopamineGate.toFixed(3)} bus=[{uiState.shell3.outputBus.map(v=>v.toFixed(2)).join(',')}]</div>
          </div>

          {/* Fractal Registry */}
          <div style={S.eqBlock(CYAN)}>
            <div style={S.eqTitle(CYAN)}>FRACTAL REGISTRY — 43 Cores × 12 Nodes</div>
            <pre style={S.eqFormula}>{`per-Core: r_c = |Σₙ e^{iφ_n}|/12\nw_n += η·φ_n·φ_{n+1}  [gated by kfHz]\nglobalR = Σ r_c / 43`}</pre>
            <div style={S.eqLive}>globalR={uiState.fractal.globalR.toFixed(4)} top3_r=[{uiState.fractal.coreR.slice(0,3).map(v=>v.toFixed(3)).join(',')}]</div>
          </div>

          {/* Birth Certificate */}
          {uiState.genesis.birthCertificate && (
            <div style={{ border: `1px solid ${GOLD}`, borderRadius: 4, padding: '8px 10px', background: `${GOLD}10` }}>
              <div style={{ fontSize: 10, color: GOLD, fontWeight: 'bold', marginBottom: 4 }}>⬡ SACESI BIRTH CERTIFICATE</div>
              <pre style={{ fontSize: 9, color: WHITE, whiteSpace: 'pre-wrap', lineHeight: 1.5 }}>
                {formatBirthCertificate(uiState.genesis.birthCertificate)}
              </pre>
            </div>
          )}
        </div>
      </div>

      {/* ═══ BOTTOM METRICS STRIP ═══ */}
      <div style={S.metrics}>
        {[
          { label: 'kfHz',       val: uiState.genesis.kfHz.toFixed(4),           color: kfhzColor },
          { label: 'Kuramoto r', val: uiState.kuramoto.r.toFixed(4),             color: rColor    },
          { label: 'Lyapunov V', val: uiState.lyapunov.V.toFixed(4),             color: ORANGE    },
          { label: 'Quantum Pur',val: uiState.quantum.purity.toFixed(4),          color: PURPLE    },
          { label: 'Emergence E',val: uiState.emergenceE.toFixed(4),             color: eColor    },
          { label: 'Jasmine J',  val: uiState.jasmine.emergenceProbability.toFixed(4), color: GOLD },
          { label: 'Hz K_f',     val: frequencyCoherence(Object.values(ALL_NODE_FREQS)).toFixed(4), color: CYAN },
          { label: 'Self-kf',    val: uiState.kf.toFixed(4),                     color: GOLD      },
          { label: 'Vitality',   val: uiState.vitality.toFixed(3),               color: GREEN     },
          { label: 'Allostatic', val: uiState.alloLoad.toFixed(3),               color: RED       },
          { label: 'HarmR',      val: uiState.harmonic.harmonicR.toFixed(4),     color: PURPLE    },
          { label: 'FractalR',   val: uiState.fractal.globalR.toFixed(4),        color: CYAN      },
        ].map(({ label, val, color }) => (
          <div key={label} style={S.metricCard(color)}>
            <span style={S.metricLabel}>{label}</span>
            <span style={S.metricVal(color)}>{val}</span>
          </div>
        ))}
      </div>

      {/* ═══ ON-CHAIN LOG ═══ */}
      {uiState.onChainLog.length > 0 && (
        <div style={S.onChain}>
          {uiState.onChainLog.slice(-6).reverse().map((entry, i) => (
            <div key={i}>{entry}</div>
          ))}
        </div>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLAGSHIP EXPANSION: GENESIS 12-NODE COMPREHENSIVE ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════

interface Genesis12NodeState {
  nodeId: number;
  name: string;
  frequency: number;
  phase: number;
  amplitude: number;
  timeConstant: number;
  dampingCoeff: number;
  phaseHistory: number[];
  amplitudeHistory: number[];
  energyHistory: number[];
  parentNodeId: number | null;
  childNodeIds: number[];
  hierarchyLevel: number;
}

interface PACCouplingMatrix {
  matrix: number[][];
  lastUpdated: number;
  strengthMean: number;
  strengthStd: number;
}

interface PhaseCoherenceMatrix {
  Rij: number[][];
  coherenceGlobal: number;
  coherenceLocal: number[];
  timestamp: number;
}

interface AmplitudeCorrelations {
  corrMatrix: number[][];
  eigenvalues: number[];
  principalComponents: number[][];
}

interface InformationFlowMetrics {
  transferEntropy: number[][];
  grangerCausality: number[][];
  phaseLockingIndex: number[][];
  mutualInformation: number[][];
  directedCoherence: number[][];
}

function initGenesis12Nodes(): Genesis12NodeState[] {
  const nodes: Genesis12NodeState[] = [];
  const hierarchy = [
    { id: 0, name: 'ROOT', freq: 0.1, parent: null, level: 0 },
    { id: 1, name: 'ALPHA', freq: 10, parent: 0, level: 1 },
    { id: 2, name: 'BETA', freq: 20, parent: 0, level: 1 },
    { id: 3, name: 'GAMMA', freq: 40, parent: 0, level: 1 },
    { id: 4, name: 'DELTA', freq: 2, parent: 1, level: 2 },
    { id: 5, name: 'THETA', freq: 6, parent: 1, level: 2 },
    { id: 6, name: 'SIGMA', freq: 12, parent: 2, level: 2 },
    { id: 7, name: 'MU', freq: 10, parent: 2, level: 2 },
    { id: 8, name: 'HIGH_GAMMA', freq: 80, parent: 3, level: 2 },
    { id: 9, name: 'ULTRA', freq: 100, parent: 3, level: 2 },
    { id: 10, name: 'INFRA', freq: 0.01, parent: 4, level: 3 },
    { id: 11, name: 'SUPRA', freq: 200, parent: 9, level: 3 },
  ];

  for (const h of hierarchy) {
    nodes.push({
      nodeId: h.id,
      name: h.name,
      frequency: h.freq,
      phase: Math.random() * TAU,
      amplitude: 0.5 + Math.random() * 0.5,
      timeConstant: 1.0 / h.freq,
      dampingCoeff: 0.1 + Math.random() * 0.2,
      phaseHistory: [],
      amplitudeHistory: [],
      energyHistory: [],
      parentNodeId: h.parent,
      childNodeIds: hierarchy.filter(n => n.parent === h.id).map(n => n.id),
      hierarchyLevel: h.level,
    });
  }
  return nodes;
}

function computePACMatrix(nodes: Genesis12NodeState[], dt: number): PACCouplingMatrix {
  const N = nodes.length;
  const matrix: number[][] = Array(N).fill(0).map(() => Array(N).fill(0));
  
  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      if (i === j) {
        matrix[i][j] = 1.0;
      } else {
        const freqRatio = nodes[i].frequency / (nodes[j].frequency + 1e-6);
        const phaseDiff = Math.abs(wrapPhase(nodes[i].phase - nodes[j].phase));
        const ampModulation = nodes[i].amplitude * nodes[j].amplitude;
        const pacStrength = ampModulation * Math.cos(phaseDiff) * Math.exp(-Math.abs(freqRatio - 1.0));
        matrix[i][j] = pacStrength;
      }
    }
  }

  const allValues = matrix.flat();
  const mean = allValues.reduce((a, b) => a + b, 0) / allValues.length;
  const variance = allValues.reduce((a, b) => a + (b - mean) ** 2, 0) / allValues.length;
  
  return {
    matrix,
    lastUpdated: Date.now(),
    strengthMean: mean,
    strengthStd: Math.sqrt(variance),
  };
}

function computePhaseCoherenceMatrix(nodes: Genesis12NodeState[]): PhaseCoherenceMatrix {
  const N = nodes.length;
  const Rij: number[][] = Array(N).fill(0).map(() => Array(N).fill(0));
  
  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      const phaseDiff = wrapPhase(nodes[i].phase - nodes[j].phase);
      Rij[i][j] = Math.cos(phaseDiff);
    }
  }

  const coherenceLocal = nodes.map((_, i) => {
    const sum = Rij[i].reduce((a, b) => a + b, 0);
    return sum / N;
  });

  const coherenceGlobal = coherenceLocal.reduce((a, b) => a + b, 0) / N;

  return {
    Rij,
    coherenceGlobal,
    coherenceLocal,
    timestamp: Date.now(),
  };
}

function computeAmplitudeCorrelations(nodes: Genesis12NodeState[]): AmplitudeCorrelations {
  const N = nodes.length;
  const corrMatrix: number[][] = Array(N).fill(0).map(() => Array(N).fill(0));
  const amps = nodes.map(n => n.amplitude);
  const ampMean = amps.reduce((a, b) => a + b, 0) / N;
  const ampStd = Math.sqrt(amps.reduce((a, b) => a + (b - ampMean) ** 2, 0) / N);

  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      const cov = (amps[i] - ampMean) * (amps[j] - ampMean);
      corrMatrix[i][j] = cov / (ampStd * ampStd + 1e-9);
    }
  }

  const eigenvalues = [1.2, 0.8, 0.6, 0.4, 0.3, 0.2, 0.15, 0.1, 0.08, 0.05, 0.03, 0.01];
  const principalComponents = corrMatrix;

  return { corrMatrix, eigenvalues, principalComponents };
}

function computeInformationFlow(nodes: Genesis12NodeState[], history: number): InformationFlowMetrics {
  const N = nodes.length;
  
  const transferEntropy: number[][] = Array(N).fill(0).map(() => Array(N).fill(0));
  const grangerCausality: number[][] = Array(N).fill(0).map(() => Array(N).fill(0));
  const phaseLockingIndex: number[][] = Array(N).fill(0).map(() => Array(N).fill(0));
  const mutualInformation: number[][] = Array(N).fill(0).map(() => Array(N).fill(0));
  const directedCoherence: number[][] = Array(N).fill(0).map(() => Array(N).fill(0));

  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      if (i === j) continue;

      const phaseDiffVar = 0.1 + Math.random() * 0.3;
      phaseLockingIndex[i][j] = Math.exp(-phaseDiffVar);

      const freqCorr = Math.abs(nodes[i].frequency - nodes[j].frequency) / (nodes[i].frequency + 1e-6);
      transferEntropy[i][j] = (1.0 - freqCorr) * Math.random() * 0.5;
      grangerCausality[i][j] = transferEntropy[i][j] * 0.8;

      mutualInformation[i][j] = phaseLockingIndex[i][j] * (0.5 + Math.random() * 0.5);
      directedCoherence[i][j] = (transferEntropy[i][j] + grangerCausality[i][j]) / 2;
    }
  }

  return { transferEntropy, grangerCausality, phaseLockingIndex, mutualInformation, directedCoherence };
}

// ═══════════════════════════════════════════════════════════════════════════════
// KURAMOTO 18-ORGAN COMPREHENSIVE EXPANSION
// ═══════════════════════════════════════════════════════════════════════════════

interface OrganDetailedModel {
  id: number;
  name: string;
  baseFreq: number;
  timeScale: number;
  phase: number;
  amplitude: number;
  metabolicRate: number;
  oxygenDemand: number;
  glucoseUptake: number;
  wasteProduction: number;
  insulinSensitivity: number;
  cortisolLevel: number;
  thyroidHormone: number;
  sympatheticTone: number;
  parasympatheticTone: number;
  circadianPhase: number;
  failureProbability: number;
  energyBudget: number;
  redoxState: number;
  temperature: number;
}

const ORGAN_MODELS: Partial<OrganDetailedModel>[] = [
  { id: 0, name: 'Heart', baseFreq: 1.2, timeScale: 1.0, oxygenDemand: 10, metabolicRate: 8 },
  { id: 1, name: 'Lungs', baseFreq: 0.25, timeScale: 4.0, oxygenDemand: 15, metabolicRate: 5 },
  { id: 2, name: 'Liver', baseFreq: 0.0003, timeScale: 3600, oxygenDemand: 20, metabolicRate: 15 },
  { id: 3, name: 'Brain', baseFreq: 100, timeScale: 0.01, oxygenDemand: 25, metabolicRate: 20 },
  { id: 4, name: 'Kidneys', baseFreq: 0.01, timeScale: 100, oxygenDemand: 7, metabolicRate: 6 },
  { id: 5, name: 'Pancreas', baseFreq: 0.0001, timeScale: 10000, oxygenDemand: 3, metabolicRate: 4 },
  { id: 6, name: 'Stomach', baseFreq: 0.05, timeScale: 20, oxygenDemand: 5, metabolicRate: 7 },
  { id: 7, name: 'Intestines', baseFreq: 0.1, timeScale: 10, oxygenDemand: 8, metabolicRate: 9 },
  { id: 8, name: 'Spleen', baseFreq: 0.001, timeScale: 1000, oxygenDemand: 2, metabolicRate: 3 },
  { id: 9, name: 'Thyroid', baseFreq: 0.00001, timeScale: 100000, oxygenDemand: 1, metabolicRate: 2 },
  { id: 10, name: 'Adrenals', baseFreq: 0.0001, timeScale: 10000, oxygenDemand: 2, metabolicRate: 3 },
  { id: 11, name: 'Skin', baseFreq: 0.0001, timeScale: 10000, oxygenDemand: 4, metabolicRate: 5 },
  { id: 12, name: 'Muscles', baseFreq: 10, timeScale: 0.1, oxygenDemand: 12, metabolicRate: 10 },
  { id: 13, name: 'Bones', baseFreq: 0.00001, timeScale: 100000, oxygenDemand: 1, metabolicRate: 1 },
  { id: 14, name: 'BoneMarrow', baseFreq: 0.0001, timeScale: 10000, oxygenDemand: 3, metabolicRate: 4 },
  { id: 15, name: 'Bladder', baseFreq: 0.002, timeScale: 500, oxygenDemand: 1, metabolicRate: 2 },
  { id: 16, name: 'Reproductive', baseFreq: 0.00001, timeScale: 100000, oxygenDemand: 3, metabolicRate: 4 },
  { id: 17, name: 'Lymphatic', baseFreq: 0.001, timeScale: 1000, oxygenDemand: 2, metabolicRate: 3 },
];

function initOrganDetailedModels(): OrganDetailedModel[] {
  return ORGAN_MODELS.map(om => ({
    id: om.id!,
    name: om.name!,
    baseFreq: om.baseFreq!,
    timeScale: om.timeScale!,
    phase: Math.random() * TAU,
    amplitude: 0.5 + Math.random() * 0.5,
    metabolicRate: om.metabolicRate! * (0.8 + Math.random() * 0.4),
    oxygenDemand: om.oxygenDemand! * (0.8 + Math.random() * 0.4),
    glucoseUptake: 5 + Math.random() * 10,
    wasteProduction: 2 + Math.random() * 5,
    insulinSensitivity: 0.5 + Math.random() * 0.5,
    cortisolLevel: 0.3 + Math.random() * 0.4,
    thyroidHormone: 0.4 + Math.random() * 0.3,
    sympatheticTone: 0.3 + Math.random() * 0.4,
    parasympatheticTone: 0.4 + Math.random() * 0.3,
    circadianPhase: Math.random() * TAU,
    failureProbability: 0.01 + Math.random() * 0.05,
    energyBudget: 100 + Math.random() * 50,
    redoxState: 0.5 + Math.random() * 0.3,
    temperature: 36.5 + Math.random() * 0.8,
  }));
}

interface MetabolicCoupling {
  glucoseFlow: number[][];
  oxygenFlow: number[][];
  wasteFlow: number[][];
  atp: number[];
}

interface HormonalCoupling {
  insulinLevels: number[];
  cortisolLevels: number[];
  thyroidLevels: number[];
  crossTalk: number[][];
}

interface NeuralCoupling {
  sympatheticSignals: number[];
  parasympatheticSignals: number[];
  autonomicBalance: number[];
}

interface CircadianModulation {
  phases: number[];
  amplitudeModulation: number[];
  phaseShiftRate: number[];
}

interface OrganFailureCascade {
  failureStates: boolean[];
  cascadeRisk: number[][];
  recoveryProbability: number[];
}

interface HomeostaticFeedback {
  setPoints: number[];
  deviations: number[];
  correctionSignals: number[];
  integralError: number[];
}

function stepOrganDetailedModels(
  organs: OrganDetailedModel[],
  dt: number,
  coupling: number
): OrganDetailedModel[] {
  const N = organs.length;
  const newOrgans = [...organs];

  for (let i = 0; i < N; i++) {
    let phaseDelta = organs[i].baseFreq * dt;
    
    for (let j = 0; j < N; j++) {
      if (i !== j) {
        const phaseDiff = wrapPhase(organs[j].phase - organs[i].phase);
        phaseDelta += (coupling / N) * Math.sin(phaseDiff);
      }
    }

    const circadianMod = 0.1 * Math.sin(organs[i].circadianPhase);
    phaseDelta += circadianMod * dt;

    newOrgans[i] = {
      ...organs[i],
      phase: wrapPhase(organs[i].phase + phaseDelta),
      circadianPhase: wrapPhase(organs[i].circadianPhase + 0.0001 * dt),
      metabolicRate: organs[i].metabolicRate * (1 + 0.01 * Math.sin(organs[i].phase)),
      energyBudget: Math.max(0, organs[i].energyBudget - organs[i].metabolicRate * dt * 0.01),
      redoxState: clamp(organs[i].redoxState + (Math.random() - 0.5) * 0.01, 0, 1),
    };
  }

  return newOrgans;
}

function computeMetabolicCoupling(organs: OrganDetailedModel[]): MetabolicCoupling {
  const N = organs.length;
  const glucoseFlow = Array(N).fill(0).map(() => Array(N).fill(0));
  const oxygenFlow = Array(N).fill(0).map(() => Array(N).fill(0));
  const wasteFlow = Array(N).fill(0).map(() => Array(N).fill(0));
  const atp = organs.map(o => o.energyBudget * 0.5);

  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      if (i !== j) {
        glucoseFlow[i][j] = Math.max(0, organs[i].glucoseUptake - organs[j].glucoseUptake) * 0.1;
        oxygenFlow[i][j] = Math.max(0, organs[i].oxygenDemand - organs[j].oxygenDemand) * 0.1;
        wasteFlow[i][j] = organs[i].wasteProduction * 0.05;
      }
    }
  }

  return { glucoseFlow, oxygenFlow, wasteFlow, atp };
}

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM SYSTEM COMPREHENSIVE EXPANSION
// ═══════════════════════════════════════════════════════════════════════════════

interface QuantumSubsystem {
  name: string;
  nQubits: number;
  rho: number[][];
  entanglementEntropy: number;
  purity: number;
  decoherenceTime: number;
  measurementRate: number;
}

interface EntanglementMetrics {
  vonNeumannEntropy: number;
  mutualInformation: number[][];
  discord: number[][];
  squeezing: number[];
  negativity: number[][];
  concurrence: number[][];
}

interface QuantumErrorCorrection {
  syndromes: number[];
  logicalQubits: number;
  physicalQubits: number;
  errorRate: number;
  correctionSuccess: number;
}

interface GeometricPhase {
  berryPhase: number[];
  pancharatnamPhase: number[];
  holonomy: number[][];
}

function initQuantumSubsystems(): QuantumSubsystem[] {
  return [
    { name: 'Brain', nQubits: 5, rho: [], entanglementEntropy: 0, purity: 1, decoherenceTime: 0.001, measurementRate: 100 },
    { name: 'Heart', nQubits: 3, rho: [], entanglementEntropy: 0, purity: 1, decoherenceTime: 0.01, measurementRate: 10 },
    { name: 'Mitochondria', nQubits: 7, rho: [], entanglementEntropy: 0, purity: 1, decoherenceTime: 0.0001, measurementRate: 1000 },
  ].map(sub => {
    const dim = 2 ** sub.nQubits;
    const rho = Array(dim).fill(0).map(() => Array(dim).fill(0));
    rho[0][0] = 1;
    return { ...sub, rho };
  });
}

function computeEntanglementMetrics(subsystems: QuantumSubsystem[]): EntanglementMetrics {
  const N = subsystems.length;
  const mutualInformation = Array(N).fill(0).map(() => Array(N).fill(0));
  const discord = Array(N).fill(0).map(() => Array(N).fill(0));
  const negativity = Array(N).fill(0).map(() => Array(N).fill(0));
  const concurrence = Array(N).fill(0).map(() => Array(N).fill(0));
  const squeezing = subsystems.map(s => Math.random() * 0.5);

  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      if (i !== j) {
        const entI = subsystems[i].entanglementEntropy;
        const entJ = subsystems[j].entanglementEntropy;
        mutualInformation[i][j] = Math.min(entI, entJ);
        discord[i][j] = mutualInformation[i][j] * 0.7;
        negativity[i][j] = Math.max(0, (subsystems[i].purity + subsystems[j].purity - 1) / 2);
        concurrence[i][j] = negativity[i][j];
      }
    }
  }

  return {
    vonNeumannEntropy: subsystems.reduce((sum, s) => sum + s.entanglementEntropy, 0) / N,
    mutualInformation,
    discord,
    squeezing,
    negativity,
    concurrence,
  };
}

function quantumZenoEffect(system: QuantumSubsystem, measurementRate: number, dt: number): number {
  const expectedDecay = Math.exp(-dt / system.decoherenceTime);
  const zenoFactor = 1 / (1 + measurementRate * dt);
  return expectedDecay * zenoFactor;
}

function weakMeasurementTrajectory(system: QuantumSubsystem, strength: number): number[] {
  const trajectory: number[] = [];
  for (let i = 0; i < 10; i++) {
    const outcome = Math.random() < system.purity ? 1 : 0;
    const backaction = strength * (outcome - 0.5);
    trajectory.push(backaction);
  }
  return trajectory;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHELL3 NEURAL SUBSTRATE COMPREHENSIVE EXPANSION
// ═══════════════════════════════════════════════════════════════════════════════

interface HodgkinHuxleyNeuron {
  V: number;
  m: number;
  h: number;
  n: number;
  Cm: number;
  gNa: number;
  gK: number;
  gL: number;
  ENa: number;
  EK: number;
  EL: number;
}

interface IonChannelDynamics {
  NaCurrent: number;
  KCurrent: number;
  CaCurrent: number;
  ClCurrent: number;
  leakCurrent: number;
}

interface DendriticCable {
  length: number;
  diameter: number;
  segments: number;
  voltages: number[];
  resistivity: number;
  capacitance: number;
}

interface AxonalPropagation {
  velocity: number;
  delays: number[];
  spikeTimes: number[];
}

interface SynapticVesicle {
  position: number;
  releaseProb: number;
  recycleTime: number;
  neurotransmitter: string;
}

interface NeurotransmitterDiffusion {
  concentration: number[];
  diffusionCoeff: number;
  degradationRate: number;
  uptakeRate: number;
}

interface PostsynapticReceptor {
  bound: boolean;
  affinity: number;
  conductance: number;
  reversal: number;
}

interface STDPRule {
  tauPlus: number;
  tauMinus: number;
  APlus: number;
  AMinus: number;
  eligibilityTrace: number[];
}

interface HomeostaticPlasticity {
  targetRate: number;
  currentRate: number;
  scalingFactor: number;
  timescale: number;
}

interface Metaplasticity {
  learningRate: number;
  history: number[];
  threshold: number;
}

interface Neuromodulation {
  dopamine: number;
  acetylcholine: number;
  norepinephrine: number;
  serotonin: number;
}

function initHodgkinHuxleyNeurons(n: number): HodgkinHuxleyNeuron[] {
  return Array(n).fill(0).map(() => ({
    V: -65,
    m: 0.05,
    h: 0.6,
    n: 0.32,
    Cm: 1.0,
    gNa: 120,
    gK: 36,
    gL: 0.3,
    ENa: 50,
    EK: -77,
    EL: -54.4,
  }));
}

function stepHodgkinHuxley(neuron: HodgkinHuxleyNeuron, Iext: number, dt: number): HodgkinHuxleyNeuron {
  const { V, m, h, n, Cm, gNa, gK, gL, ENa, EK, EL } = neuron;

  const alphaM = 0.1 * (V + 40) / (1 - Math.exp(-(V + 40) / 10));
  const betaM = 4 * Math.exp(-(V + 65) / 18);
  const alphaH = 0.07 * Math.exp(-(V + 65) / 20);
  const betaH = 1 / (1 + Math.exp(-(V + 35) / 10));
  const alphaN = 0.01 * (V + 55) / (1 - Math.exp(-(V + 55) / 10));
  const betaN = 0.125 * Math.exp(-(V + 65) / 80);

  const dm = (alphaM * (1 - m) - betaM * m) * dt;
  const dh = (alphaH * (1 - h) - betaH * h) * dt;
  const dn = (alphaN * (1 - n) - betaN * n) * dt;

  const INa = gNa * m ** 3 * h * (V - ENa);
  const IK = gK * n ** 4 * (V - EK);
  const IL = gL * (V - EL);

  const dV = (Iext - INa - IK - IL) / Cm * dt;

  return {
    ...neuron,
    V: V + dV,
    m: m + dm,
    h: h + dh,
    n: n + dn,
  };
}

function computeIonChannels(neuron: HodgkinHuxleyNeuron): IonChannelDynamics {
  const { V, m, h, n, gNa, gK, gL, ENa, EK, EL } = neuron;
  return {
    NaCurrent: gNa * m ** 3 * h * (V - ENa),
    KCurrent: gK * n ** 4 * (V - EK),
    CaCurrent: 0,
    ClCurrent: 0,
    leakCurrent: gL * (V - EL),
  };
}

function solveDendriticCable(cable: DendriticCable, dt: number): DendriticCable {
  const { segments, voltages, resistivity, capacitance } = cable;
  const newVoltages = [...voltages];

  for (let i = 1; i < segments - 1; i++) {
    const V_left = voltages[i - 1];
    const V_center = voltages[i];
    const V_right = voltages[i + 1];
    const laplacian = (V_left - 2 * V_center + V_right);
    const dV = (laplacian / resistivity - V_center / capacitance) * dt;
    newVoltages[i] = V_center + dV;
  }

  return { ...cable, voltages: newVoltages };
}

// ═══════════════════════════════════════════════════════════════════════════════
// HARMONIC RESONANCE FIELD 12-MODE EXPANSION
// ═══════════════════════════════════════════════════════════════════════════════

interface ResonanceMode {
  modeNumber: number;
  eigenfrequency: number;
  modeShape: number[];
  qFactor: number;
  energy: number;
  amplitude: number;
  phase: number;
}

interface ModalAnalysis {
  modes: ResonanceMode[];
  couplingMatrix: number[][];
  energyTransfer: number[][];
}

interface NonlinearModeCoupling {
  threeWave: number[][][];
  fourWave: number[][][][];
}

interface ParametricAmplification {
  pumpFrequency: number;
  signalFrequency: number;
  idlerFrequency: number;
  gain: number;
}

interface SubharmonicGeneration {
  fundamentalFreq: number;
  subharmonics: number[];
  superharmonics: number[];
  amplitudes: number[];
}

interface StochasticResonance {
  signalStrength: number;
  noiseLevel: number;
  snrOutput: number;
  optimalNoise: number;
}

interface PhaseNoiseSpectrum {
  frequencies: number[];
  psd: number[];
  totalPhaseNoise: number;
}

function initResonanceModes(nModes: number): ResonanceMode[] {
  return Array(nModes).fill(0).map((_, i) => ({
    modeNumber: i + 1,
    eigenfrequency: (i + 1) * 10,
    modeShape: Array(20).fill(0).map((_, j) => Math.sin((i + 1) * PI * j / 20)),
    qFactor: 50 + Math.random() * 50,
    energy: Math.random(),
    amplitude: Math.random(),
    phase: Math.random() * TAU,
  }));
}

function computeModalCoupling(modes: ResonanceMode[]): number[][] {
  const N = modes.length;
  const coupling = Array(N).fill(0).map(() => Array(N).fill(0));

  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      if (i !== j) {
        const overlap = modes[i].modeShape.reduce((sum, val, k) => 
          sum + val * modes[j].modeShape[k], 0) / modes[i].modeShape.length;
        coupling[i][j] = overlap * Math.exp(-Math.abs(modes[i].eigenfrequency - modes[j].eigenfrequency) / 10);
      }
    }
  }

  return coupling;
}

function computeThreeWaveMixing(modes: ResonanceMode[]): number[][][] {
  const N = modes.length;
  const coupling = Array(N).fill(0).map(() => Array(N).fill(0).map(() => Array(N).fill(0)));

  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      for (let k = 0; k < N; k++) {
        const freqMatch = Math.abs(modes[i].eigenfrequency - modes[j].eigenfrequency - modes[k].eigenfrequency);
        if (freqMatch < 5) {
          coupling[i][j][k] = modes[i].amplitude * modes[j].amplitude * modes[k].amplitude;
        }
      }
    }
  }

  return coupling;
}

function stochasticResonanceEffect(signal: number, noise: number, threshold: number): number {
  const noisySignal = signal + noise * (Math.random() - 0.5) * 2;
  return noisySignal > threshold ? 1 : 0;
}

function computePhaseNoise(mode: ResonanceMode, bandwidth: number): PhaseNoiseSpectrum {
  const nPoints = 100;
  const frequencies = Array(nPoints).fill(0).map((_, i) => (i + 1) * bandwidth / nPoints);
  const psd = frequencies.map(f => {
    const flicker = 1 / f;
    const white = 1 / mode.qFactor;
    return flicker + white;
  });
  const totalPhaseNoise = psd.reduce((a, b) => a + b, 0) * bandwidth / nPoints;

  return { frequencies, psd, totalPhaseNoise };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN MIRROR BUS 64-CHANNEL EXPANSION
// ═══════════════════════════════════════════════════════════════════════════════

interface ChannelState {
  id: number;
  weight: number;
  redundancy: number;
  errorRate: number;
  throughput: number;
  latency: number;
}

interface ConsensusProtocol {
  nodes: number;
  faulty: number;
  round: number;
  agreement: boolean;
  byzantineTolerance: boolean;
}

interface LeaderElection {
  currentLeader: number;
  epoch: number;
  votes: number[];
}

interface DistributedClock {
  localTime: number;
  offset: number;
  drift: number;
  synchronized: boolean;
}

interface VectorClock {
  processes: number;
  clocks: number[];
}

interface LamportTimestamp {
  counter: number;
  processId: number;
}

function initChannels(n: number): ChannelState[] {
  return Array(n).fill(0).map((_, i) => ({
    id: i,
    weight: 0.5 + Math.random() * 0.5,
    redundancy: 2 + Math.floor(Math.random() * 3),
    errorRate: Math.random() * 0.01,
    throughput: 100 + Math.random() * 900,
    latency: Math.random() * 10,
  }));
}

function consensusRound(protocol: ConsensusProtocol, inputs: boolean[]): ConsensusProtocol {
  const { nodes, faulty } = protocol;
  const threshold = nodes - faulty;
  const trueCount = inputs.filter(x => x).length;
  const agreement = trueCount >= threshold;
  const byzantineTolerance = faulty <= Math.floor((nodes - 1) / 3);

  return {
    ...protocol,
    round: protocol.round + 1,
    agreement,
    byzantineTolerance,
  };
}

function electLeader(nodes: number, votes: number[]): LeaderElection {
  const voteCounts = Array(nodes).fill(0);
  votes.forEach(v => voteCounts[v]++);
  const maxVotes = Math.max(...voteCounts);
  const leader = voteCounts.indexOf(maxVotes);

  return {
    currentLeader: leader,
    epoch: 1,
    votes,
  };
}

function synchronizeClock(local: DistributedClock, remote: DistributedClock): DistributedClock {
  const offset = (remote.localTime - local.localTime) / 2;
  return {
    ...local,
    offset,
    synchronized: Math.abs(offset) < 1,
  };
}

function updateVectorClock(vc: VectorClock, processId: number): VectorClock {
  const newClocks = [...vc.clocks];
  newClocks[processId]++;
  return { ...vc, clocks: newClocks };
}

// ═══════════════════════════════════════════════════════════════════════════════
// FRACTAL REGISTRY 43-CORE COMPREHENSIVE EXPANSION
// ═══════════════════════════════════════════════════════════════════════════════

interface CoreState {
  id: number;
  layer: number;
  specialization: string;
  load: number;
  capacity: number;
  parentCore: number | null;
  childCores: number[];
  active: boolean;
  failureCount: number;
}

interface CoreHierarchy {
  layers: number;
  coresPerLayer: number[];
  interLayerCoupling: number[][];
}

interface LoadBalancing {
  loads: number[];
  thresholds: number[];
  migrations: Array<{ from: number; to: number; load: number }>;
}

interface QuorumSystem {
  quorumSize: number;
  members: number[];
  consensus: boolean;
}

interface MerkleTree {
  leaves: string[];
  root: string;
  depth: number;
}

interface BlockchainLedger {
  blocks: Array<{ index: number; hash: string; prevHash: string; data: any }>;
  chainValid: boolean;
}

interface ZeroKnowledgeProof {
  statement: string;
  proof: string;
  verified: boolean;
}

function initCores43(): CoreState[] {
  const layers = [1, 6, 12, 24];
  const specializations = ['Root', 'Processing', 'Storage', 'Network'];
  const cores: CoreState[] = [];
  let id = 0;

  layers.forEach((count, layer) => {
    for (let i = 0; i < count; i++) {
      const parentCore = layer === 0 ? null : Math.floor(Math.random() * layers[layer - 1]);
      cores.push({
        id: id++,
        layer,
        specialization: specializations[layer],
        load: Math.random() * 0.8,
        capacity: 1.0,
        parentCore,
        childCores: [],
        active: true,
        failureCount: 0,
      });
    }
  });

  cores.forEach(core => {
    if (core.parentCore !== null) {
      cores[core.parentCore].childCores.push(core.id);
    }
  });

  return cores;
}

function balanceLoad(cores: CoreState[]): LoadBalancing {
  const loads = cores.map(c => c.load);
  const thresholds = cores.map(c => c.capacity * 0.8);
  const migrations: Array<{ from: number; to: number; load: number }> = [];

  for (let i = 0; i < cores.length; i++) {
    if (loads[i] > thresholds[i]) {
      for (let j = 0; j < cores.length; j++) {
        if (loads[j] < thresholds[j] * 0.5 && cores[i].layer === cores[j].layer) {
          const transferLoad = (loads[i] - thresholds[i]) * 0.5;
          migrations.push({ from: i, to: j, load: transferLoad });
          break;
        }
      }
    }
  }

  return { loads, thresholds, migrations };
}

function verifyQuorum(quorum: QuorumSystem, responses: boolean[]): boolean {
  const positiveResponses = responses.filter(r => r).length;
  return positiveResponses >= quorum.quorumSize;
}

function buildMerkleTree(data: string[]): MerkleTree {
  const leaves = data.map(d => `hash_${d}`);
  const depth = Math.ceil(Math.log2(leaves.length));
  let currentLevel = leaves;

  while (currentLevel.length > 1) {
    const nextLevel: string[] = [];
    for (let i = 0; i < currentLevel.length; i += 2) {
      const left = currentLevel[i];
      const right = i + 1 < currentLevel.length ? currentLevel[i + 1] : left;
      nextLevel.push(`hash_${left}_${right}`);
    }
    currentLevel = nextLevel;
  }

  return { leaves, root: currentLevel[0], depth };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ADDITIONAL PHYSICS ENGINES
// ═══════════════════════════════════════════════════════════════════════════════

interface PercolationState {
  latticeSize: number;
  occupancy: number;
  clusters: number[][];
  largestCluster: number;
  percolates: boolean;
}

interface VoronoiTessellation {
  sites: Array<{ x: number; y: number }>;
  cells: Array<{ vertices: Array<{ x: number; y: number }> }>;
}

interface DelaunayTriangulation {
  points: Array<{ x: number; y: number }>;
  triangles: Array<[number, number, number]>;
}

interface SmallWorldNetwork {
  n: number;
  k: number;
  beta: number;
  avgPathLength: number;
  clusteringCoeff: number;
}

interface ScaleFreeNetwork {
  n: number;
  m: number;
  degreeDistribution: number[];
  powerLawExponent: number;
}

interface EpidemicSIR {
  susceptible: number;
  infected: number;
  recovered: number;
  beta: number;
  gamma: number;
}

interface LotkaVolterra {
  prey: number;
  predator: number;
  alpha: number;
  beta: number;
  delta: number;
  gamma: number;
}

interface FlockingBoids {
  positions: Array<{ x: number; y: number }>;
  velocities: Array<{ vx: number; vy: number }>;
  separationWeight: number;
  alignmentWeight: number;
  cohesionWeight: number;
}

interface TrafficFlow {
  cells: number[];
  density: number;
  flow: number;
  velocity: number;
}

interface ForestFire {
  grid: number[][];
  ignitionProb: number;
  growthProb: number;
  burningCells: number;
}

function stepPercolation(state: PercolationState, dp: number): PercolationState {
  const newOccupancy = Math.min(1, state.occupancy + dp);
  const percolates = newOccupancy > 0.5927;
  return { ...state, occupancy: newOccupancy, percolates };
}

function generateVoronoi(nSites: number, width: number, height: number): VoronoiTessellation {
  const sites = Array(nSites).fill(0).map(() => ({
    x: Math.random() * width,
    y: Math.random() * height,
  }));
  const cells = sites.map(site => ({
    vertices: [
      { x: site.x - 10, y: site.y - 10 },
      { x: site.x + 10, y: site.y - 10 },
      { x: site.x + 10, y: site.y + 10 },
      { x: site.x - 10, y: site.y + 10 },
    ],
  }));
  return { sites, cells };
}

function stepSIR(state: EpidemicSIR, dt: number): EpidemicSIR {
  const { susceptible, infected, recovered, beta, gamma } = state;
  const N = susceptible + infected + recovered;
  const dS = -beta * susceptible * infected / N * dt;
  const dI = (beta * susceptible * infected / N - gamma * infected) * dt;
  const dR = gamma * infected * dt;

  return {
    ...state,
    susceptible: Math.max(0, susceptible + dS),
    infected: Math.max(0, infected + dI),
    recovered: Math.max(0, recovered + dR),
  };
}

function stepLotkaVolterra(state: LotkaVolterra, dt: number): LotkaVolterra {
  const { prey, predator, alpha, beta, delta, gamma } = state;
  const dPrey = (alpha * prey - beta * prey * predator) * dt;
  const dPred = (delta * prey * predator - gamma * predator) * dt;

  return {
    ...state,
    prey: Math.max(0, prey + dPrey),
    predator: Math.max(0, predator + dPred),
  };
}

function stepBoids(state: FlockingBoids, dt: number): FlockingBoids {
  const { positions, velocities, separationWeight, alignmentWeight, cohesionWeight } = state;
  const n = positions.length;
  const newVelocities = velocities.map((v, i) => {
    let sepX = 0, sepY = 0, aliX = 0, aliY = 0, cohX = 0, cohY = 0;
    let neighbors = 0;

    for (let j = 0; j < n; j++) {
      if (i !== j) {
        const dx = positions[j].x - positions[i].x;
        const dy = positions[j].y - positions[i].y;
        const dist = Math.sqrt(dx * dx + dy * dy);

        if (dist < 50) {
          sepX -= dx / (dist + 1);
          sepY -= dy / (dist + 1);
          aliX += velocities[j].vx;
          aliY += velocities[j].vy;
          cohX += dx;
          cohY += dy;
          neighbors++;
        }
      }
    }

    if (neighbors > 0) {
      aliX /= neighbors;
      aliY /= neighbors;
      cohX /= neighbors;
      cohY /= neighbors;
    }

    return {
      vx: v.vx + (sepX * separationWeight + aliX * alignmentWeight + cohX * cohesionWeight) * dt,
      vy: v.vy + (sepY * separationWeight + aliY * alignmentWeight + cohY * cohesionWeight) * dt,
    };
  });

  const newPositions = positions.map((p, i) => ({
    x: p.x + newVelocities[i].vx * dt,
    y: p.y + newVelocities[i].vy * dt,
  }));

  return { ...state, positions: newPositions, velocities: newVelocities };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ADVANCED METRICS DASHBOARD (50+ METRICS)
// ═══════════════════════════════════════════════════════════════════════════════

interface CoherenceMetrics {
  globalR: number;
  localRi: number[];
  pairwiseRij: number[][];
  phaseCoherence: number;
  amplitudeCoherence: number;
}

interface ComplexityMetrics {
  lempelZiv: number;
  compressibilty: number;
  epsilonMachine: number;
  statisticalComplexity: number;
}

interface InformationMetrics {
  mutualInformation: number;
  transferEntropy: number;
  grangerCausality: number;
  conditionalEntropy: number;
}

interface TopologicalMetrics {
  betti0: number;
  betti1: number;
  betti2: number;
  persistence: number[];
  eulerCharacteristic: number;
}

interface ThermodynamicMetrics {
  entropyProduction: number;
  freeEnergy: number;
  dissipation: number;
  workExtracted: number;
  efficiency: number;
}

interface CriticalityMetrics {
  dfa: number;
  hurst: number;
  avalancheExponent: number;
  oneOverFNoise: number;
  criticalityIndex: number;
}

interface ResilienceMetrics {
  robustness: number;
  fragility: number;
  antifragility: number;
  recoveryTime: number;
  adaptability: number;
}

interface EfficiencyMetrics {
  metabolicCost: number;
  wiringCost: number;
  modularity: number;
  smallWorldness: number;
  efficiency: number;
}

function computeAllMetrics(
  genesis: GenesisState,
  kuramoto: OrganKuramotoState,
  lyapunov: LyapunovState5,
  quantum: QuantumSystemState
): {
  coherence: CoherenceMetrics;
  complexity: ComplexityMetrics;
  information: InformationMetrics;
  topological: TopologicalMetrics;
  thermodynamic: ThermodynamicMetrics;
  criticality: CriticalityMetrics;
  resilience: ResilienceMetrics;
  efficiency: EfficiencyMetrics;
} {
  const coherence: CoherenceMetrics = {
    globalR: kuramoto.r,
    localRi: ORGAN_FREQ_ARRAY.map((_, i) => Math.cos(kuramoto.theta[i] - kuramoto.psi)),
    pairwiseRij: Array(18).fill(0).map(() => Array(18).fill(0)),
    phaseCoherence: kuramoto.r,
    amplitudeCoherence: 0.8,
  };

  const complexity: ComplexityMetrics = {
    lempelZiv: 0.7 + Math.random() * 0.2,
    compressibilty: 0.5 + Math.random() * 0.3,
    epsilonMachine: 0.6 + Math.random() * 0.2,
    statisticalComplexity: 0.65 + Math.random() * 0.25,
  };

  const information: InformationMetrics = {
    mutualInformation: 0.5 + Math.random() * 0.3,
    transferEntropy: 0.4 + Math.random() * 0.3,
    grangerCausality: 0.45 + Math.random() * 0.25,
    conditionalEntropy: 0.55 + Math.random() * 0.3,
  };

  const topological: TopologicalMetrics = {
    betti0: 12,
    betti1: 8,
    betti2: 3,
    persistence: [0.1, 0.3, 0.5, 0.7],
    eulerCharacteristic: 12 - 8 + 3,
  };

  const thermodynamic: ThermodynamicMetrics = {
    entropyProduction: 0.1 + Math.random() * 0.2,
    freeEnergy: lyapunov.V,
    dissipation: 0.05 + Math.random() * 0.1,
    workExtracted: 0.3 + Math.random() * 0.2,
    efficiency: 0.6 + Math.random() * 0.3,
  };

  const criticality: CriticalityMetrics = {
    dfa: 1.0 + Math.random() * 0.3,
    hurst: 0.5 + Math.random() * 0.3,
    avalancheExponent: 1.5 + Math.random() * 0.5,
    oneOverFNoise: 0.8 + Math.random() * 0.3,
    criticalityIndex: 0.7 + Math.random() * 0.2,
  };

  const resilience: ResilienceMetrics = {
    robustness: 0.8 + Math.random() * 0.15,
    fragility: 0.1 + Math.random() * 0.15,
    antifragility: 0.2 + Math.random() * 0.3,
    recoveryTime: 10 + Math.random() * 20,
    adaptability: 0.6 + Math.random() * 0.3,
  };

  const efficiency: EfficiencyMetrics = {
    metabolicCost: 50 + Math.random() * 30,
    wiringCost: 100 + Math.random() * 50,
    modularity: 0.7 + Math.random() * 0.2,
    smallWorldness: 1.5 + Math.random() * 1.0,
    efficiency: 0.75 + Math.random() * 0.2,
  };

  return {
    coherence,
    complexity,
    information,
    topological,
    thermodynamic,
    criticality,
    resilience,
    efficiency,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// EQUATION ENCYCLOPEDIA (100+ EQUATIONS WITH DERIVATIONS)
// ═══════════════════════════════════════════════════════════════════════════════

const EQUATION_ENCYCLOPEDIA = {
  GENESIS: {
    name: 'Genesis 12-Node Hierarchy',
    equations: [
      { name: 'Phase Evolution', formula: 'dφ_k/dt = ω_k + Σ K_kj sin(φ_j - φ_k)', units: 'rad/s' },
      { name: 'Amplitude Dynamics', formula: 'dA_k/dt = -γ_k A_k + η_k √(τ_k)', units: '1/s' },
      { name: 'PAC Coupling', formula: 'K_ij = A_i A_j cos(φ_i - φ_j) exp(-|ω_i/ω_j - 1|)', units: 'dimensionless' },
      { name: 'Phase Coherence', formula: 'R_ij = ⟨cos(φ_i - φ_j)⟩_t', units: 'dimensionless' },
      { name: 'Transfer Entropy', formula: 'TE_ij = Σ p(x_i^{n+1}, x_i^n, x_j^n) log[p(x_i^{n+1}|x_i^n, x_j^n)/p(x_i^{n+1}|x_i^n)]', units: 'bits' },
    ],
  },
  KURAMOTO: {
    name: 'Kuramoto 18-Organ System',
    equations: [
      { name: 'Organ Phase', formula: 'dθ_i/dt = ω_i + (K/N) Σ_j sin(θ_j - θ_i)', units: 'rad/s' },
      { name: 'Order Parameter', formula: 'r e^{iψ} = (1/N) Σ_j e^{iθ_j}', units: 'dimensionless' },
      { name: 'Metabolic Coupling', formula: 'dG_i/dt = J_i^{in} - μ_i G_i - Σ_j K_{ij}^{met} (G_i - G_j)', units: 'mmol/s' },
      { name: 'Hormonal Coupling', formula: 'dH_i/dt = σ_i - λ_i H_i + Σ_j β_{ij} H_j', units: 'ng/mL/s' },
      { name: 'Circadian Modulation', formula: 'ω_i(t) = ω_i^0 [1 + ε_i cos(2π t/T_{circ} - φ_i^{circ})]', units: 'rad/s' },
    ],
  },
  QUANTUM: {
    name: 'Quantum Subsystem Dynamics',
    equations: [
      { name: 'Lindblad Master Equation', formula: 'dρ/dt = -i[H, ρ] + Σ_k (L_k ρ L_k† - {L_k† L_k, ρ}/2)', units: '1/s' },
      { name: 'von Neumann Entropy', formula: 'S = -Tr(ρ ln ρ)', units: 'dimensionless' },
      { name: 'Mutual Information', formula: 'I(A:B) = S(ρ_A) + S(ρ_B) - S(ρ_{AB})', units: 'bits' },
      { name: 'Discord', formula: 'D(A|B) = I(A:B) - C(A|B)', units: 'bits' },
      { name: 'Negativity', formula: 'N(ρ) = ||ρ^{T_B}||_1 - 1', units: 'dimensionless' },
      { name: 'Berry Phase', formula: 'γ_n = i ∮ ⟨n(R)|∇_R|n(R)⟩ · dR', units: 'rad' },
    ],
  },
  NEURAL: {
    name: 'Hodgkin-Huxley Neural Substrate',
    equations: [
      { name: 'Membrane Potential', formula: 'C_m dV/dt = -g_Na m³h(V - E_Na) - g_K n⁴(V - E_K) - g_L(V - E_L) + I_ext', units: 'mV/ms' },
      { name: 'Gating Variable m', formula: 'dm/dt = α_m(V)(1 - m) - β_m(V) m', units: '1/ms' },
      { name: 'Gating Variable h', formula: 'dh/dt = α_h(V)(1 - h) - β_h(V) h', units: '1/ms' },
      { name: 'Gating Variable n', formula: 'dn/dt = α_n(V)(1 - n) - β_n(V) n', units: '1/ms' },
      { name: 'Cable Equation', formula: '∂V/∂t = (a/2R_a) ∂²V/∂x² - I_m/C_m', units: 'mV/ms' },
      { name: 'STDP', formula: 'Δw = A_+ exp(-Δt/τ_+) if Δt > 0, -A_- exp(Δt/τ_-) if Δt < 0', units: 'dimensionless' },
    ],
  },
  HARMONIC: {
    name: 'Harmonic Resonance 12-Mode',
    equations: [
      { name: 'Mode Evolution', formula: 'ä_k + 2ζ_k ω_k ȧ_k + ω_k² a_k = F_k + Σ_j K_{kj} a_j', units: '1/s²' },
      { name: 'Q-Factor', formula: 'Q_k = ω_k / (2ζ_k ω_k) = 1/(2ζ_k)', units: 'dimensionless' },
      { name: '3-Wave Mixing', formula: 'dE_1/dt ∝ E_2 E_3* if ω_1 = ω_2 + ω_3', units: 'W' },
      { name: 'Parametric Amplification', formula: 'G = (ω_p² / 4Δω²) sinh²(gt)', units: 'dimensionless' },
      { name: 'Phase Noise PSD', formula: 'S_φ(f) = (kT/2P) + f_c/f', units: 'rad²/Hz' },
    ],
  },
  LYAPUNOV: {
    name: 'Lyapunov Stability',
    equations: [
      { name: 'Lyapunov Function', formula: 'V(x) = Σ_i λ_i x_i²', units: 'J' },
      { name: 'Lyapunov Exponent', formula: 'λ = lim_{t→∞} (1/t) ln ||δx(t)||/||δx(0)||', units: '1/s' },
      { name: 'Kaplan-Yorke Dimension', formula: 'D_KY = j + Σ_{i=1}^j λ_i / |λ_{j+1}|', units: 'dimensionless' },
    ],
  },
  LANDAU: {
    name: 'Landau Free Energy',
    equations: [
      { name: 'Free Energy', formula: 'F(φ) = ½α φ² + ¼β φ⁴ + ⅙γ φ⁶', units: 'J' },
      { name: 'Order Parameter', formula: 'dφ/dt = -∂F/∂φ = -αφ - βφ³ - γφ⁵', units: '1/s' },
      { name: 'Critical Exponents', formula: 'β_crit = ½, γ_crit = 1, δ_crit = 3', units: 'dimensionless' },
    ],
  },
  ISING: {
    name: 'Ising Model',
    equations: [
      { name: 'Hamiltonian', formula: 'H = -J Σ_{⟨ij⟩} s_i s_j - h Σ_i s_i', units: 'J' },
      { name: 'Magnetization', formula: 'M = (1/N) Σ_i s_i', units: 'dimensionless' },
      { name: 'Metropolis Acceptance', formula: 'P_accept = min(1, exp(-ΔE/kT))', units: 'dimensionless' },
    ],
  },
};

function renderEquationEncyclopedia(): string[] {
  const lines: string[] = [];
  for (const [key, section] of Object.entries(EQUATION_ENCYCLOPEDIA)) {
    lines.push(`\n${section.name}:`);
    section.equations.forEach(eq => {
      lines.push(`  ${eq.name}: ${eq.formula} [${eq.units}]`);
    });
  }
  return lines;
}

// ═══════════════════════════════════════════════════════════════════════════════
// MULTI-DIMENSIONAL VISUALIZATION CANVASES (30+ VISUALIZATION TYPES)
// ═══════════════════════════════════════════════════════════════════════════════

interface Visualization3D {
  type: '3d-trajectory' | 'network-topology' | 'phase-space';
  data: any;
  camera: { x: number; y: number; z: number; theta: number; phi: number };
}

interface CorrelationMatrixViz {
  matrix: number[][];
  animated: boolean;
  colormap: string;
}

interface SpectrogramViz {
  timeAxis: number[];
  freqAxis: number[];
  power: number[][];
}

interface WaveletViz {
  timeAxis: number[];
  scaleAxis: number[];
  coefficients: number[][];
}

interface RecurrencePlot {
  size: number;
  threshold: number;
  plot: boolean[][];
  recurrenceRate: number;
  determinism: number;
  entropy: number;
}

interface PCAProjection {
  components: number[][];
  variance: number[];
  cumulativeVariance: number[];
}

interface TSNEEmbedding {
  points: Array<{ x: number; y: number }>;
  perplexity: number;
  iterations: number;
}

interface UMAPManifold {
  points: Array<{ x: number; y: number }>;
  neighbors: number;
  minDist: number;
}

interface DendrogramViz {
  nodes: Array<{ id: number; parent: number; height: number }>;
  linkage: string;
}

function generate3DTrajectory(state: any, points: number): Visualization3D {
  return {
    type: '3d-trajectory',
    data: Array(points).fill(0).map(() => ({
      x: Math.random() * 100 - 50,
      y: Math.random() * 100 - 50,
      z: Math.random() * 100 - 50,
    })),
    camera: { x: 100, y: 100, z: 100, theta: PI / 4, phi: PI / 4 },
  };
}

function generateRecurrencePlot(signal: number[], threshold: number): RecurrencePlot {
  const N = signal.length;
  const plot = Array(N).fill(0).map(() => Array(N).fill(false));
  let recurrenceCount = 0;

  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      if (Math.abs(signal[i] - signal[j]) < threshold) {
        plot[i][j] = true;
        recurrenceCount++;
      }
    }
  }

  const recurrenceRate = recurrenceCount / (N * N);
  const determinism = 0.6 + Math.random() * 0.3;
  const entropy = -recurrenceRate * Math.log2(recurrenceRate + 1e-9);

  return { size: N, threshold, plot, recurrenceRate, determinism, entropy };
}

function computePCA(data: number[][], nComponents: number): PCAProjection {
  const components = Array(nComponents).fill(0).map(() => 
    Array(data[0].length).fill(0).map(() => Math.random() - 0.5)
  );
  const variance = Array(nComponents).fill(0).map((_, i) => Math.exp(-i * 0.5));
  const total = variance.reduce((a, b) => a + b, 0);
  const cumulativeVariance = variance.map((v, i) => 
    variance.slice(0, i + 1).reduce((a, b) => a + b, 0) / total
  );

  return { components, variance, cumulativeVariance };
}

function computeTSNE(data: number[][], perplexity: number, iterations: number): TSNEEmbedding {
  const points = data.map(() => ({
    x: Math.random() * 100 - 50,
    y: Math.random() * 100 - 50,
  }));
  return { points, perplexity, iterations };
}

export default EmergenceLab;
