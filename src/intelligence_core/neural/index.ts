// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA INTELLIGENCE CORE — NEURAL PILLAR
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// NEURAL INTELLIGENCE — Neurochemistry, synaptic plasticity, animal brains
// This is the biological substrate of intelligence — neurons, synapses, neurotransmitters
// 21-species neurochemical system with proper half-lives, Michaelis-Menten kinetics
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// NEUROCHEMISTRY — Full 21-species neurochemical system
// ══════════════════════════════════════════════════════════════════════════════

export {
  HALFLIFE,
  halfLifeToDecayRate,
  NEURO_BASELINES,
} from '../../frontend/src/math/neurochemistry';

export type {
  NeurochemFull,
  NeurochemStimuli,
} from '../../frontend/src/math/neurochemistry';

// ══════════════════════════════════════════════════════════════════════════════
// MODULE MANIFEST — 87+ neural modules
// ══════════════════════════════════════════════════════════════════════════════

export const NEURAL_MODULES = [
  // Frontend math modules
  'neurochemistry.ts',
  'neuro-emergence-engine.ts',
  
  // Backend canister modules (Motoko)
  'HebbianPlasticity.mo',
  'CrowCognition.mo',
  'OctopusBrain.mo',
  'ElephantMemory.mo',
  'BeeSwarmIntelligence.mo',
  'BeeNeuronModel.mo',
  'BeeNeuronPredictiveField.mo',
  'BeeHiveMindEngine.mo',
  'DolphinEcholocation.mo',
  'MantisShrimp.mo',
  'OwlAuditory.mo',
  'SharkAnimalEngine.mo',
  'SharkElectroreceptionEngine.mo',
  'OrcaPodEngine.mo',
  'SpiderWeb.mo',
  'CnidarianNerveNet.mo',
  'MedinaAnimalTraits.mo',
  'AnimalBrainOrchestrator.mo',
  'BasalGangliaEngine.mo',
  'CerebellarTimingEngine.mo',
  'HippocampalReplayEngine.mo',
  'CardioCerebralVectorEngine.mo',
  'CardioNeuralConversionOrgan.mo',
  'MedinaSharpWaveRipples.mo',
  'DeepNeuroscienceEngine.mo',
  'DeepNeuralIntegrationFabric.mo',
  'DeepLayerArchitectureEngine.mo',
  
  // Total: 87+ modules across layers
] as const;

export const NEURAL_PILLAR_ID = 'NEURAL' as const;
export const NEURAL_PILLAR_VERSION = '47.0.0';

// ══════════════════════════════════════════════════════════════════════════════
// ANIMAL INTELLIGENCE REGISTRY
// Bio-inspired neural architectures from nature's designs
// ══════════════════════════════════════════════════════════════════════════════

export const ANIMAL_INTELLIGENCE_REGISTRY = {
  CROW:     { module: 'CrowCognition.mo',       capability: 'Tool use, problem solving, future planning' },
  OCTOPUS:  { module: 'OctopusBrain.mo',        capability: 'Distributed neural processing, camouflage' },
  ELEPHANT: { module: 'ElephantMemory.mo',      capability: 'Long-term memory, social cognition' },
  BEE:      { module: 'BeeSwarmIntelligence.mo', capability: 'Collective decision making, navigation' },
  DOLPHIN:  { module: 'DolphinEcholocation.mo', capability: 'Sonar processing, social communication' },
  MANTIS:   { module: 'MantisShrimp.mo',        capability: 'Hyperspectral vision, polarization' },
  SPIDER:   { module: 'SpiderWeb.mo',           capability: 'Vibration sensing, web architecture' },
  OWL:      { module: 'OwlAuditory.mo',         capability: 'Sound localization, night vision' },
  SHARK:    { module: 'SharkElectroreceptionEngine.mo', capability: 'Electroreception, lateral line' },
  ORCA:     { module: 'OrcaPodEngine.mo',       capability: 'Pod coordination, hunting strategy' },
} as const;
