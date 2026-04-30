// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA INTELLIGENCE CORE — EMERGENCE PILLAR
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// EMERGENCE INTELLIGENCE — Phase transitions, Kuramoto synchronization, self-organization
// Landau free energy, Ising model, Lorenz system, reaction-diffusion, Bak-Tang-Wiesenfeld
// This is where individual components become greater than the sum of their parts
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// KURAMOTO OSCILLATOR ENGINE — Phase synchronization
// ══════════════════════════════════════════════════════════════════════════════

export {
  ORGAN_FREQS,
  ORGAN_FREQ_ARRAY,
  computeAmplitudeOrderParameter,
  computeOrderParameter,
} from '../../frontend/src/math/kuramoto';

export type {
  KuramotoOscillator,
  KuramotoOrderResult,
} from '../../frontend/src/math/kuramoto';

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE PHYSICS ENGINE — Phase transitions, Ising, Lorenz
// ══════════════════════════════════════════════════════════════════════════════

export {
  landauFreeEnergyFull,
  landauGradient,
  findEquilibriumPhi,
  landauSusceptibility,
  landauFromTemperature,
  initIsingState,
  isingEnergy,
} from '../../frontend/src/math/emergence';

export type {
  LandauParams,
  IsingState,
} from '../../frontend/src/math/emergence';

// ══════════════════════════════════════════════════════════════════════════════
// MODULE MANIFEST — 53+ emergence modules
// ══════════════════════════════════════════════════════════════════════════════

export const EMERGENCE_MODULES = [
  // Frontend math modules
  'emergence.ts',
  'kuramoto.ts',
  'neuro-emergence-engine.ts',
  
  // Frontend organism modules
  'NeuroEmergenceSubstrate.ts',
  'LivingWorldComputation.ts',
  
  // Backend canister modules (Motoko)
  'EmergencePhysicsEngine.mo',
  'EmergenceCore.mo',
  'KuramotoEngine.mo',
  'SwarmCoherenceMatrix.mo',
  'NeuralEmergenceCore.mo',
  'CoherenceMiningEngine.mo',
  'EmergentOrganismFabric.mo',
  'TriModalSwarmKernel.mo',
  'MedinaAntColonySpherical.mo',
  'TopologicalFieldEngine.mo',
  
  // Total: 53+ modules across layers
] as const;

export const EMERGENCE_PILLAR_ID = 'EMERGENCE' as const;
export const EMERGENCE_PILLAR_VERSION = '47.0.0';

// ══════════════════════════════════════════════════════════════════════════════
// EMERGENCE PHENOMENA REGISTRY
// ══════════════════════════════════════════════════════════════════════════════

export const EMERGENCE_PHENOMENA = {
  PHASE_TRANSITION: {
    description: 'Abrupt change in macroscopic behavior at critical point',
    math: 'Landau free energy F(φ) = a₂φ² + a₄φ⁴ − hφ',
    modules: ['emergence.ts', 'EmergencePhysicsEngine.mo'],
  },
  KURAMOTO_SYNC: {
    description: 'Phase synchronization of coupled oscillators',
    math: 'dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)',
    modules: ['kuramoto.ts', 'KuramotoEngine.mo'],
  },
  ISING_CRITICALITY: {
    description: '2D ferromagnet phase transition at T_c',
    math: 'H = −J Σ⟨ij⟩ sᵢsⱼ − B Σᵢ sᵢ',
    modules: ['emergence.ts', 'EmergencePhysicsEngine.mo'],
  },
  SELF_ORGANIZATION: {
    description: 'Spontaneous order from local interactions',
    math: 'Bak-Tang-Wiesenfeld sandpile, reaction-diffusion',
    modules: ['EmergenceCore.mo', 'CoherenceMiningEngine.mo'],
  },
} as const;
