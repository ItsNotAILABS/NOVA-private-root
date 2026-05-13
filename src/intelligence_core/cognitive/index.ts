// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA INTELLIGENCE CORE — COGNITIVE PILLAR
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// COGNITIVE INTELLIGENCE — Meta-cognition, world models, reasoning
// This is the thinking substrate — awareness of awareness, internal models, inference
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// RE-EXPORT FROM INTELLIGENCE MODULES
// ══════════════════════════════════════════════════════════════════════════════

export * from '../../frontend/src/intelligence/primitives';
export * from '../../frontend/src/intelligence/FModelRegistry';

// ══════════════════════════════════════════════════════════════════════════════
// MODULE MANIFEST — 64+ cognitive modules
// ══════════════════════════════════════════════════════════════════════════════

export const COGNITIVE_MODULES = [
  // Frontend intelligence modules
  'primitives.ts',
  'FModelRegistry.ts',
  'sovereignFlip.ts',
  'PhantomBlockchainRegistry.ts',
  
  // Backend canister modules (Motoko)
  'MedinaMetaCognitionSupreme.mo',
  'CognitiveScienceAdvisor.mo',
  'WorldModelSystem.mo',
  'AttentionSchemaEngine.mo',
  'MedinaConsciousnessField.mo',
  'MedinaQuantumBrain.mo',
  'TemporalHologram.mo',
  'CognitiveMemorySystems.mo',
  'MembraneMemory.mo',
  'MedinaSharpWaveRipples.mo',
  'MedinaPlanningHorizon.mo',
  'MedinaMasterIntertwining.mo',
  'InformationMetabolismSystem.mo',
  'PreConsciousStartleComprehensive.mo',
  'SovereignDualCircuit.mo',
  
  // Total: 64+ modules across layers
] as const;

export const COGNITIVE_PILLAR_ID = 'COGNITIVE' as const;
export const COGNITIVE_PILLAR_VERSION = '47.0.0';

// ══════════════════════════════════════════════════════════════════════════════
// COGNITIVE ARCHITECTURE REGISTRY
// ══════════════════════════════════════════════════════════════════════════════

export const COGNITIVE_ARCHITECTURE = {
  META_COGNITION: {
    description: 'Awareness of cognitive processes',
    modules: ['MedinaMetaCognitionSupreme.mo'],
    capability: 'Self-reflection, monitoring, control',
  },
  WORLD_MODEL: {
    description: 'Internal representation of reality',
    modules: ['WorldModelSystem.mo', 'SimulatedWorld.mo'],
    capability: 'Prediction, counterfactual reasoning',
  },
  ATTENTION: {
    description: 'Selective processing of information',
    modules: ['AttentionSchemaEngine.mo'],
    capability: 'Focus, filtering, prioritization',
  },
  CONSCIOUSNESS: {
    description: 'Integrated awareness field',
    modules: ['MedinaConsciousnessField.mo', 'PreConsciousStartleComprehensive.mo'],
    capability: 'Global workspace, binding, unity',
  },
  TEMPORAL_COGNITION: {
    description: 'Time representation and planning',
    modules: ['TemporalHologram.mo', 'MedinaPlanningHorizon.mo'],
    capability: 'Past reconstruction, future projection',
  },
  MEMORY_SYSTEMS: {
    description: 'Storage and retrieval architectures',
    modules: ['CognitiveMemorySystems.mo', 'MembraneMemory.mo'],
    capability: 'Encoding, consolidation, recall',
  },
} as const;
