// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA INTELLIGENCE CORE — COMPUTING PILLAR
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// COMPUTING INTELLIGENCE — The mathematical substrate of NOVA
// Physics = REAL math and geometry — not fake simulation
// All numbers are computed to machine precision from first principles
// NO external dependencies. NOVA does its OWN computations.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// RE-EXPORT FROM MATH CORE — All sovereign computations
// ══════════════════════════════════════════════════════════════════════════════

// Core mathematical constants (REAL numbers, 19 decimal places)
export {
  PHI,
  PHI_INV,
  EULER_E,
  PI,
  TAU,
  SQRT2,
  SQRT3,
  SQRT5,
  LN2,
  ISING_2D_BETA,
  ISING_2D_TC,
  PERC_2D_PC,
  FEIGENBAUM_D,
  SOVEREIGN_FLOOR,
} from '../../frontend/src/math/core';

// Primitive computations
export {
  clamp,
  sf,
  sigmoid,
  tanh,
  softmax,
  relu,
  norm,
  dot,
  vadd,
  vscale,
  wrapPhase,
  phaseDiff,
  logisticStep,
  ema,
} from '../../frontend/src/math/core';

// ══════════════════════════════════════════════════════════════════════════════
// QUANTUM COMPUTING — Complex numbers, density matrices, quantum mechanics
// ══════════════════════════════════════════════════════════════════════════════

export type { Cplx } from '../../frontend/src/math/quantum';
export {
  C0, C1, Ci,
  cAdd, cSub, cMul, cDiv, cConj, cAbs, cAbsSq, cScale, cPhase, cExpI, cExp, cLog,
  innerProduct,
  stateNorm,
  normalizeState,
} from '../../frontend/src/math/quantum';

// ══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN GEOMETRY — φ-powers, Fibonacci, Platonic solids, sacred geometry
// ══════════════════════════════════════════════════════════════════════════════

export {
  PHI_POWERS,
  getPhiPower,
  FIBONACCI,
  FIBONACCI_CONVERGENTS,
  PLATONIC_SOLIDS,
  VESICA_PISCIS,
  THEODORUS_SPIRAL,
} from '../../frontend/src/math/sovereign-geometry';

// ══════════════════════════════════════════════════════════════════════════════
// FREQUENCY SUBSTRATE — Hz-based computation
// ══════════════════════════════════════════════════════════════════════════════

export {
  HEARTBEAT_RATE,
  HZ_LEXIS,
  HZ_FORGE,
  HZ_SOMA,
  HZ_MEMORIA,
  HZ_PULSE,
} from '../../frontend/src/math/hz-substrate';

// ══════════════════════════════════════════════════════════════════════════════
// MODULE MANIFEST — 89+ computing modules
// ══════════════════════════════════════════════════════════════════════════════

export const COMPUTING_MODULES = [
  // Core math (frontend/src/math/)
  'core.ts',
  'quantum.ts',
  'sovereign-geometry.ts',
  'hz-substrate.ts',
  'laws.ts',
  'genesis.ts',
  
  // Backend canisters (Motoko)
  'AdvancedMathematicalFoundations.mo',
  'TopologicalFieldEngine.mo',
  'ChronoTemporalPrecisionEngine.mo',
  'AncientFrequencyGeometry.mo',
  'PhiFrequencyNodes.mo',
  'CosmologicalCalendarSynthesis.mo',
  'UniversalCalendarSynthesis.mo',
  'PhaseLockCalendarEngine.mo',
  'MedinaQuantumProtocols.mo',
  'MedinaQuantumCovenantChain.mo',
  'DoctrineFingerprint.mo',
  'SphericalLaw.mo',
  'MedinaSphericalWeb.mo',
  
  // Total: 89+ modules across layers
] as const;

export const COMPUTING_PILLAR_ID = 'COMPUTING' as const;
export const COMPUTING_PILLAR_VERSION = '47.0.0';
