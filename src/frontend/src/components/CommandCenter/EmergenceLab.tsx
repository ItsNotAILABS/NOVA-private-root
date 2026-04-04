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

export default EmergenceLab;
