// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA INTELLIGENCE CORE — SCALABILITY PILLAR
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// SCALABILITY INTELLIGENCE — Massive-scale systems, super-organisms, hierarchical coordination
// How intelligence scales from neurons to civilizations
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// MODULE MANIFEST — 42+ scalability modules
// ══════════════════════════════════════════════════════════════════════════════

export const SCALABILITY_MODULES = [
  // Backend canister modules (Motoko)
  'SuperScaleOrganism.mo',
  'SuperOrganismCore.mo',
  'MassiveScaleOrganismCore.mo',
  'ProductionSuperOrganismCore.mo',
  'UnifiedHierarchicalOrganism.mo',
  'Complete32ArchitectureOrchestrator.mo',
  'CompleteAutonomousOrganismCore.mo',
  'CompleteOrganismWorkflows.mo',
  'EndToEndOrganismWorkflows.mo',
  'MED1019UnifiedOrganismIntegration.mo',
  'Shell12GlobalIntegration.mo',
  'FullConstructiveStack.mo',
  'AutonomousOrganismWiring.mo',
  'MedinaOrganismTeams.mo',
  'AutonomousInternalTeam.mo',
  
  // Total: 42+ modules across layers
] as const;

export const SCALABILITY_PILLAR_ID = 'SCALABILITY' as const;
export const SCALABILITY_PILLAR_VERSION = '47.0.0';

// ══════════════════════════════════════════════════════════════════════════════
// SCALE LEVELS REGISTRY
// ══════════════════════════════════════════════════════════════════════════════

export const SCALE_LEVELS = {
  NEURON: {
    count: '1',
    description: 'Individual neural unit',
    modules: ['HebbianPlasticity.mo'],
  },
  CIRCUIT: {
    count: '10²',
    description: 'Local neural circuit',
    modules: ['BasalGangliaEngine.mo', 'CerebellarTimingEngine.mo'],
  },
  REGION: {
    count: '10⁵',
    description: 'Brain region',
    modules: ['HippocampalReplayEngine.mo'],
  },
  BRAIN: {
    count: '10⁸',
    description: 'Full brain',
    modules: ['swarm_brain/main.mo'],
  },
  ORGANISM: {
    count: '10¹¹',
    description: 'Complete organism',
    modules: ['SuperOrganismCore.mo'],
  },
  SUPER_ORGANISM: {
    count: '10¹⁵',
    description: 'Colony/society level',
    modules: ['SuperScaleOrganism.mo', 'MassiveScaleOrganismCore.mo'],
  },
  CIVILIZATION: {
    count: '10²⁰+',
    description: 'Civilization scale',
    modules: ['UnifiedHierarchicalOrganism.mo'],
  },
} as const;

// ══════════════════════════════════════════════════════════════════════════════
// HIERARCHICAL ARCHITECTURE
// ══════════════════════════════════════════════════════════════════════════════

export const HIERARCHICAL_ARCHITECTURE = {
  description: 'Multi-level coordination from micro to macro',
  levels: Object.keys(SCALE_LEVELS),
  principle: 'Each level exhibits emergent properties not present at lower levels',
  wiring: 'Wave routing connects all levels via 873ms heartbeat',
} as const;
