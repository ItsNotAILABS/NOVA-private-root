// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Intelligence Module Exports
// 100 F-MODEL species + 30 Phantom Blockchain models + Sovereign Flip Engine
// ═══════════════════════════════════════════════════════════════════════════════

// Primitives — the 9 irreducible functions
export { PRIMITIVES, ALL_PRIMITIVES, getPrimitiveName } from './primitives';
export type { PrimitiveFunction, PrimitiveDefinition } from './primitives';

// F-MODEL Registry — 100 frontend intelligence species
export {
  FMODEL_REGISTRY,
  FMODEL_STATS,
  getFModel,
  getFModelsByCategory,
  getFModelsByPrimitive,
  getFModelsByRing,
  getFModelsBySovereignStatus,
  getFModelsByIntelligenceType,
  getSovereignStatusCounts,
  getPrimitiveCounts,
} from './FModelRegistry';
export type {
  FModel,
  FModelCategory,
  IntelligenceType,
  RingAffinity,
  SovereignStatus,
} from './FModelRegistry';

// Phantom Blockchain Registry — 30 phantom substrate models
export {
  PHANTOM_REGISTRY,
  PHANTOM_STATS,
  getPhantomModel,
  getPhantomsByFamily,
  getPhantomsByStealthClass,
  getPhantomsByEncryptionTier,
} from './PhantomBlockchainRegistry';
export type {
  PhantomModel,
  PhantomFamily,
  StealthClass,
  EncryptionTier,
} from './PhantomBlockchainRegistry';

// Sovereign Flip Engine — 4-phase conversion lifecycle
export {
  getFlipPhase,
  getSovereignOperator,
  getReinsertTargets,
  generateFlipRecord,
  getFlipProgress,
} from './sovereignFlip';
export type {
  FlipPhase,
  ReinsertTarget,
  SovereignFlipRecord,
} from './sovereignFlip';
