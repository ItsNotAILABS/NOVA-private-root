// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA INTELLIGENCE CORE — ADAPTATION PILLAR
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ADAPTATION INTELLIGENCE — Antifragility, learning, attractor dynamics
// "That which does not kill the organism makes it stronger" — Taleb, NOVA edition
// Lyapunov stability, Free Energy Principle, compound learning
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// ANTIFRAGILITY ENGINE — Stress response and immune system
// ══════════════════════════════════════════════════════════════════════════════

export type {
  FragilityClass,
  StressResult,
  ImmuneRecord,
} from '../../frontend/src/math/antifragility';

// ══════════════════════════════════════════════════════════════════════════════
// LYAPUNOV STABILITY ENGINE — Attractor dynamics
// ══════════════════════════════════════════════════════════════════════════════

export {
  DEFAULT_LYAPUNOV_WEIGHTS,
  DEFAULT_LYAPUNOV_TARGETS,
  initLyapunov,
  computeLyapunovV,
} from '../../frontend/src/math/lyapunov';

export type {
  LyapunovState5,
} from '../../frontend/src/math/lyapunov';

// ══════════════════════════════════════════════════════════════════════════════
// MODULE MANIFEST — 71+ adaptation modules
// ══════════════════════════════════════════════════════════════════════════════

export const ADAPTATION_MODULES = [
  // Frontend math modules
  'antifragility.ts',
  'lyapunov.ts',
  'behavioral-economics.ts',
  
  // Backend canister modules (Motoko)
  'CompoundLearning.mo',
  'AttractorDynamics.mo',
  'LyapunovStability.mo',
  'FristonEngine.mo',
  'AdvancedAdaptiveEmergentOrganisms.mo',
  'AdaptiveResonanceTheory.mo',
  'OrganismBehavioralSubstrate.mo',
  'BehavioralEconomics.mo',
  'RiskManagementSystem.mo',
  'BacktestingFramework.mo',
  'AresRollbackEngine.mo',
  'AresRollbackStackFull.mo',
  'PersistenceMissionLock.mo',
  
  // Total: 71+ modules across layers
] as const;

export const ADAPTATION_PILLAR_ID = 'ADAPTATION' as const;
export const ADAPTATION_PILLAR_VERSION = '47.0.0';

// ══════════════════════════════════════════════════════════════════════════════
// ADAPTATION MECHANISMS REGISTRY
// ══════════════════════════════════════════════════════════════════════════════

export const ADAPTATION_MECHANISMS = {
  ANTIFRAGILITY: {
    description: 'Gains from randomness and stress',
    spectrum: ['FRAGILE', 'ROBUST', 'ANTIFRAGILE'],
    math: 'φ-weighted stress response with immune memory',
    modules: ['antifragility.ts'],
  },
  LYAPUNOV_STABILITY: {
    description: 'Convergence to attractor basin',
    math: 'V(t) = Σᵢ wᵢ(xᵢ − x̄ᵢ)², dV/dt < 0 ⟹ stable',
    modules: ['lyapunov.ts', 'LyapunovStability.mo'],
  },
  FREE_ENERGY_PRINCIPLE: {
    description: 'Minimize surprise, maintain homeostasis',
    math: 'F = KL[q(z|x) || p(z)] + ⟨log p(x|z)⟩',
    modules: ['FristonEngine.mo'],
  },
  COMPOUND_LEARNING: {
    description: 'Iterative improvement with memory',
    math: 'Knowledge compounds over time like interest',
    modules: ['CompoundLearning.mo'],
  },
  ATTRACTOR_DYNAMICS: {
    description: 'Basin of attraction navigation',
    math: 'Fixed points, limit cycles, strange attractors',
    modules: ['AttractorDynamics.mo'],
  },
} as const;
