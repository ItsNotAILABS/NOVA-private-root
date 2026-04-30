// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA EMERGENCE LAB — PURE INTELLIGENCE ENGINE (BUILD №47)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THIS IS NOT A UI COMPONENT. THIS IS A LIVING INTELLIGENCE ENGINE.
// NO React. NO visualization. PURE COMPUTATION.
//
// The Emergence Lab is the INTELLIGENCE that studies phase transitions, synchronization,
// self-organization, and emergence phenomena. It does its OWN computations using NOVA math.
//
// ARCHITECTURE:
//   - Kuramoto oscillator engine (phase synchronization)
//   - Landau free energy engine (phase transitions)
//   - Ising model engine (statistical mechanics)
//   - Lorenz system engine (chaos theory)
//   - Reaction-diffusion engine (Turing patterns)
//   - Sandpile engine (self-organized criticality)
//   - Brusselator engine (chemical oscillations)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// CORE IMPORTS — All sovereign math from NOVA's own computation
// ══════════════════════════════════════════════════════════════════════════════

import {
  type KuramotoOscillator,
  type KuramotoOrderResult,
  type PhaseTransitionState,
  type OrganKuramotoState,
  ORGAN_FREQS,
  ORGAN_FREQ_ARRAY,
  computeOrderParameter,
  computeAmplitudeOrderParameter,
  kuramotoStep,
  criticalCoupling,
  kuramotoSyncEntropy,
  detectPhaseTransition,
  reEntrain,
  initOrganKuramoto,
  stepOrganKuramoto,
  frequencyCoherence,
} from '../../frontend/src/math/kuramoto';

import {
  type LandauParams,
  type IsingState,
  type LorenzState,
  type RDState,
  type SandpileState,
  type EmergenceInputs,
  type BrusselatorState,
  landauFreeEnergyFull,
  landauGradient,
  findEquilibriumPhi,
  landauSusceptibility,
  landauFromTemperature,
  initIsingState,
  isingEnergy,
  isingMagnetization,
  isingMetropolisStep,
  initLorenzState,
  lorenzStep,
  initRDState,
  rdStep,
  isTuringUnstable,
  initSandpile,
  sandpileAddGrain,
  computeEmergenceScore,
  classifyEmergence,
  initBrusselator,
  brusselatorStep,
  brusselatorOscillates,
} from '../../frontend/src/math/emergence';

import {
  type LyapunovState5,
  initLyapunov,
  lyapunovTick,
  lyapunovExponent,
  isOmnisState,
  OMNIS_THRESHOLD,
  EMERGENCE_TAU,
} from '../../frontend/src/math/lyapunov';

import {
  clamp,
  TAU,
  PI,
  PHI,
  PHI_INV,
  ISING_2D_BETA,
  ISING_2D_TC,
  FEIGENBAUM_D,
} from '../../frontend/src/math/core';

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE LAB STATE — The complete state of the emergence intelligence
// ══════════════════════════════════════════════════════════════════════════════

export interface EmergenceLabState {
  // Kuramoto oscillator system
  kuramoto: {
    oscillators: KuramotoOscillator[];
    order: KuramotoOrderResult;
    globalCoupling: number;
    phaseTransition: PhaseTransitionState | null;
  };
  
  // Landau phase transition
  landau: {
    params: LandauParams;
    equilibriumPhi: number;
    freeEnergy: number;
    susceptibility: number;
  };
  
  // Ising model
  ising: IsingState;
  
  // Lorenz system (chaos)
  lorenz: LorenzState;
  
  // Reaction-diffusion (Turing patterns)
  reactionDiffusion: RDState;
  
  // Sandpile (self-organized criticality)
  sandpile: SandpileState;
  
  // Brusselator (chemical oscillations)
  brusselator: BrusselatorState;
  
  // Lyapunov stability
  lyapunov: LyapunovState5;
  
  // Aggregate emergence metrics
  emergenceScore: number;
  emergenceClass: string;
  isOmnis: boolean;
  
  // Timing
  beatCount: number;
  lastTickMs: number;
}

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE LAB INITIALIZATION — Create fresh intelligence state
// ══════════════════════════════════════════════════════════════════════════════

export function initEmergenceLab(): EmergenceLabState {
  // Initialize Kuramoto oscillators (18 organs)
  const oscillators: KuramotoOscillator[] = ORGAN_FREQ_ARRAY.map((freq, i) => ({
    phase: Math.random() * TAU,
    naturalFreq: freq,
    coupling: 0.1,
    amplitude: 0.8 + Math.random() * 0.2,
  }));
  
  const order = computeAmplitudeOrderParameter(oscillators);
  
  // Initialize Landau (near critical point)
  const landauParams = landauFromTemperature(ISING_2D_TC, ISING_2D_TC, 1, 1, 0.1, 0);
  const equilibriumPhi = findEquilibriumPhi(landauParams);
  
  // Initialize Ising (16x16 grid)
  const ising = initIsingState(16, 16, ISING_2D_TC);
  
  // Initialize Lorenz
  const lorenz = initLorenzState();
  
  // Initialize reaction-diffusion (32x32)
  const rd = initRDState(32, 32);
  
  // Initialize sandpile (16x16)
  const sandpile = initSandpile(16, 16);
  
  // Initialize Brusselator
  const brusselator = initBrusselator();
  
  // Initialize Lyapunov
  const lyapunov = initLyapunov();
  
  return {
    kuramoto: {
      oscillators,
      order,
      globalCoupling: 0.1,
      phaseTransition: null,
    },
    landau: {
      params: landauParams,
      equilibriumPhi,
      freeEnergy: landauFreeEnergyFull(equilibriumPhi, landauParams),
      susceptibility: landauSusceptibility(equilibriumPhi, landauParams),
    },
    ising,
    lorenz,
    reactionDiffusion: rd,
    sandpile,
    brusselator,
    lyapunov,
    emergenceScore: 0,
    emergenceClass: 'DORMANT',
    isOmnis: false,
    beatCount: 0,
    lastTickMs: Date.now(),
  };
}

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE LAB TICK — One 873ms heartbeat of intelligence
// ══════════════════════════════════════════════════════════════════════════════

export function tickEmergenceLab(state: EmergenceLabState, dt: number = 0.05): EmergenceLabState {
  // Update Kuramoto oscillators
  const newOscillators = kuramotoStep(
    state.kuramoto.oscillators,
    state.kuramoto.globalCoupling,
    dt
  );
  const newOrder = computeAmplitudeOrderParameter(newOscillators);
  const phaseTransition = detectPhaseTransition(state.kuramoto.order.r, newOrder.r);
  
  // Update Ising (100 Metropolis steps per tick)
  let newIsing = { ...state.ising };
  for (let i = 0; i < 100; i++) {
    newIsing = isingMetropolisStep(newIsing);
  }
  
  // Update Lorenz
  const newLorenz = lorenzStep(state.lorenz, dt);
  
  // Update reaction-diffusion
  const newRD = rdStep(state.reactionDiffusion, dt);
  
  // Update Brusselator
  const newBrusselator = brusselatorStep(state.brusselator, dt);
  
  // Update Lyapunov
  const newLyapunov = lyapunovTick(state.lyapunov, {
    coherenceC: newOrder.r,
    entropy: kuramotoSyncEntropy(newOscillators),
    arousal: Math.abs(newLorenz.x) / 20,
    stability: state.lyapunov.stability,
    emergence: 0,
  });
  
  // Compute aggregate emergence
  const emergenceInputs: EmergenceInputs = {
    kuramotoR: newOrder.r,
    isingM: Math.abs(isingMagnetization(newIsing)),
    lorenzDistance: Math.sqrt(newLorenz.x ** 2 + newLorenz.y ** 2 + newLorenz.z ** 2),
    rdPatternStrength: isTuringUnstable(newRD) ? 1 : 0,
    sandpileAvalanches: 0,
    brusselatorAmplitude: brusselatorOscillates(newBrusselator) ? 1 : 0,
    lyapunovStability: newLyapunov.isAsymptotic ? 1 : 0,
  };
  
  const emergenceScore = computeEmergenceScore(emergenceInputs);
  const emergenceClass = classifyEmergence(emergenceScore);
  const isOmnis = isOmnisState(newLyapunov);
  
  return {
    kuramoto: {
      oscillators: newOscillators,
      order: newOrder,
      globalCoupling: state.kuramoto.globalCoupling,
      phaseTransition,
    },
    landau: state.landau, // Landau is static unless temperature changes
    ising: newIsing,
    lorenz: newLorenz,
    reactionDiffusion: newRD,
    sandpile: state.sandpile,
    brusselator: newBrusselator,
    lyapunov: newLyapunov,
    emergenceScore,
    emergenceClass,
    isOmnis,
    beatCount: state.beatCount + 1,
    lastTickMs: Date.now(),
  };
}

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE LAB QUERIES — Read intelligence state
// ══════════════════════════════════════════════════════════════════════════════

export function getKuramotoCoherence(state: EmergenceLabState): number {
  return state.kuramoto.order.r;
}

export function getKuramotoMeanPhase(state: EmergenceLabState): number {
  return state.kuramoto.order.psi;
}

export function getIsingMagnetization(state: EmergenceLabState): number {
  return isingMagnetization(state.ising);
}

export function getIsingEnergy(state: EmergenceLabState): number {
  return isingEnergy(state.ising);
}

export function getLorenzPosition(state: EmergenceLabState): { x: number; y: number; z: number } {
  return { x: state.lorenz.x, y: state.lorenz.y, z: state.lorenz.z };
}

export function getLyapunovV(state: EmergenceLabState): number {
  return state.lyapunov.V;
}

export function getLyapunovVdot(state: EmergenceLabState): number {
  return state.lyapunov.Vdot;
}

export function isStable(state: EmergenceLabState): boolean {
  return state.lyapunov.isAsymptotic;
}

export function getEmergenceScore(state: EmergenceLabState): number {
  return state.emergenceScore;
}

export function getEmergenceClass(state: EmergenceLabState): string {
  return state.emergenceClass;
}

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE LAB CONTROLS — Modify intelligence parameters
// ══════════════════════════════════════════════════════════════════════════════

export function setKuramotoCoupling(state: EmergenceLabState, coupling: number): EmergenceLabState {
  return {
    ...state,
    kuramoto: {
      ...state.kuramoto,
      globalCoupling: clamp(coupling, 0, 2),
    },
  };
}

export function setIsingTemperature(state: EmergenceLabState, temperature: number): EmergenceLabState {
  return {
    ...state,
    ising: {
      ...state.ising,
      temperature: clamp(temperature, 0.1, 10),
    },
  };
}

export function perturbLorenz(state: EmergenceLabState, dx: number, dy: number, dz: number): EmergenceLabState {
  return {
    ...state,
    lorenz: {
      ...state.lorenz,
      x: state.lorenz.x + dx,
      y: state.lorenz.y + dy,
      z: state.lorenz.z + dz,
    },
  };
}

export function addSandpileGrain(state: EmergenceLabState, x: number, y: number): EmergenceLabState {
  const result = sandpileAddGrain(state.sandpile, x, y);
  return {
    ...state,
    sandpile: result.state,
    // Could track avalanche size here
  };
}

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE LAB EXPORT
// ══════════════════════════════════════════════════════════════════════════════

export const EMERGENCE_LAB_ID = 'EMERGENCE_LAB' as const;
export const EMERGENCE_LAB_VERSION = '47.0.0';

export const EMERGENCE_LAB_CAPABILITIES = [
  'KURAMOTO_SYNC',
  'LANDAU_PHASE_TRANSITION',
  'ISING_CRITICALITY',
  'LORENZ_CHAOS',
  'TURING_PATTERNS',
  'SELF_ORGANIZED_CRITICALITY',
  'CHEMICAL_OSCILLATIONS',
  'LYAPUNOV_STABILITY',
] as const;
