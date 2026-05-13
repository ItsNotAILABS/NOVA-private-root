// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA MODULE COMPRESSION REGISTRY — BUILD №47
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// COMPLETE MODULE LIST — 654 modules organized by INTELLIGENCE TYPE
// 
// MODULE COUNTS:
//   Motoko canisters:     394 .mo files
//   CPL intelligence:     190 .ts/.tsx files  
//   SERVITORES workers:    70 .js files
//   TOTAL:                654 modules
//
// INTELLIGENCE = neural, cognitive, emergence, adaptation, scalability, computing, machine learning
// PHYSICS = REAL math and geometry — NOT simulation
// NO external dependencies — NOVA does its OWN computations
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════════
// INTELLIGENCE PILLAR DEFINITIONS
// ══════════════════════════════════════════════════════════════════════════════

export type IntelligencePillar = 
  | 'NEURAL'
  | 'COGNITIVE'
  | 'EMERGENCE'
  | 'ADAPTATION'
  | 'SCALABILITY'
  | 'COMPUTING'
  | 'MACHINE_LEARNING';

export interface ModuleEntry {
  name: string;
  path: string;
  layer: 'MOTOKO' | 'CPL' | 'SERVITORES';
  pillar: IntelligencePillar;
  purposes: string[];
}

// ══════════════════════════════════════════════════════════════════════════════
// CANISTER LAYER — 48 Motoko canisters (src/*/main.mo)
// ══════════════════════════════════════════════════════════════════════════════

export const CANISTER_REGISTRY: Record<string, { pillar: IntelligencePillar; purposes: string[] }> = {
  // Core Organism
  swarm_brain:        { pillar: 'COGNITIVE',       purposes: ['COGNITION', 'DECISION', 'LEARNING'] },
  swarm_organism:     { pillar: 'SCALABILITY',     purposes: ['COORDINATION', 'EMERGENCE', 'SELF_MODEL'] },
  agi_terminal:       { pillar: 'COGNITIVE',       purposes: ['TIMING', 'HEARTBEAT', 'CONSCIOUSNESS'] },
  agi_main:           { pillar: 'COGNITIVE',       purposes: ['COGNITION', 'REASONING', 'DECISION'] },
  
  // Intelligence Backends (Casa de Inteligencia)
  intelligence_backend: { pillar: 'COMPUTING',     purposes: ['MATH', 'COMPUTATION', 'REASONING'] },
  physics_backend:      { pillar: 'COMPUTING',     purposes: ['PHYSICS', 'GEOMETRY', 'MATH'] },
  cognition_backend:    { pillar: 'COGNITIVE',     purposes: ['AI', 'NEURAL', 'LEARNING'] },
  curriculum_backend:   { pillar: 'MACHINE_LEARNING', purposes: ['EDUCATION', 'LEARNING', 'ADAPTATION'] },
  
  // Financial
  phantom_transfer:   { pillar: 'COMPUTING',       purposes: ['VALUE_TRANSFER', 'ACCOUNTING', 'INTEGRITY'] },
  parallax:           { pillar: 'COMPUTING',       purposes: ['CLEARINGHOUSE', 'VALUE_TRANSFER', 'AUDIT'] },
  quipu_ledger:       { pillar: 'COMPUTING',       purposes: ['ACCOUNTING', 'INTEGRITY', 'VALUE_CREATION'] },
  cycles_market:      { pillar: 'ADAPTATION',      purposes: ['VALUE_TRANSFER', 'ECONOMICS', 'INVESTMENT'] },
  cycles_bridge:      { pillar: 'ADAPTATION',      purposes: ['VALUE_TRANSFER', 'COORDINATION'] },
  
  // Defense
  aegis_shield:       { pillar: 'ADAPTATION',      purposes: ['DEFENSE', 'THREAT_DETECTION', 'HEALING'] },
  vael_cyber:         { pillar: 'ADAPTATION',      purposes: ['DEFENSE', 'ATTACK', 'THREAT_DETECTION'] },
  chimera_swarm:      { pillar: 'EMERGENCE',       purposes: ['COORDINATION', 'ATTACK', 'EVASION'] },
  drone_fleet:        { pillar: 'SCALABILITY',     purposes: ['LOCOMOTION', 'TARGETING', 'NAVIGATION'] },
  war_engine:         { pillar: 'COGNITIVE',       purposes: ['DECISION', 'ATTACK', 'DEFENSE'] },
  medina_defense:     { pillar: 'ADAPTATION',      purposes: ['DEFENSE', 'THREAT_DETECTION', 'SUCCESSION'] },
  
  // Governance
  nova_governance:    { pillar: 'COGNITIVE',       purposes: ['LAW_ENFORCEMENT', 'DECISION', 'AUDIT'] },
  nova_sns:           { pillar: 'SCALABILITY',     purposes: ['GOVERNANCE', 'COORDINATION', 'SUCCESSION'] },
  neuron_fleet:       { pillar: 'NEURAL',          purposes: ['VOTING', 'DECISION', 'COORDINATION'] },
  
  // Infrastructure
  nova_stream:        { pillar: 'SCALABILITY',     purposes: ['SIGNALING', 'COORDINATION', 'RECEIVING'] },
  nova_builder:       { pillar: 'MACHINE_LEARNING', purposes: ['CREATIVITY', 'CONSTRUCTION', 'LEARNING'] },
  sovereign_factory:  { pillar: 'SCALABILITY',     purposes: ['CONSTRUCTION', 'VALUE_CREATION'] },
  nexus_propagator:   { pillar: 'SCALABILITY',     purposes: ['SIGNALING', 'COORDINATION'] },
  
  // Intelligence Engines
  friston_machina:    { pillar: 'ADAPTATION',      purposes: ['PREDICTION', 'LEARNING', 'ADAPTATION'] },
  organism_solver:    { pillar: 'COGNITIVE',       purposes: ['REASONING', 'DECISION', 'PREDICTION'] },
  syntax_synapse:     { pillar: 'NEURAL',          purposes: ['LEARNING', 'MEMORY', 'HEALING'] },
  scribe:             { pillar: 'COGNITIVE',       purposes: ['MEMORY', 'AUDIT', 'INTEGRITY'] },
  
  // Market
  auto_market:        { pillar: 'ADAPTATION',      purposes: ['VALUE_CREATION', 'INVESTMENT', 'DECISION'] },
  token_forge:        { pillar: 'COMPUTING',       purposes: ['VALUE_CREATION', 'CONSTRUCTION'] },
  organism_token:     { pillar: 'COMPUTING',       purposes: ['VALUE_TRANSFER', 'ACCOUNTING'] },
  token_intelligence: { pillar: 'MACHINE_LEARNING', purposes: ['PREDICTION', 'LEARNING', 'DECISION'] },
  swarm_metals:       { pillar: 'COMPUTING',       purposes: ['VALUE_CREATION', 'ACCOUNTING'] },
  
  // Special
  chrysalis:          { pillar: 'ADAPTATION',      purposes: ['EVOLUTION', 'ADAPTATION', 'SUCCESSION'] },
  architect:          { pillar: 'COGNITIVE',       purposes: ['CREATIVITY', 'CONSTRUCTION', 'REASONING'] },
  ai_division:        { pillar: 'MACHINE_LEARNING', purposes: ['COGNITION', 'LEARNING', 'CREATIVITY'] },
  swarm_audit:        { pillar: 'COGNITIVE',       purposes: ['AUDIT', 'INTEGRITY', 'LAW_ENFORCEMENT'] },
  swarm_command:      { pillar: 'COGNITIVE',       purposes: ['DECISION', 'COORDINATION', 'SIGNALING'] },
  swarm_oracle:       { pillar: 'COGNITIVE',       purposes: ['PERCEPTION', 'PREDICTION', 'RECEIVING'] },
  swarm_quantum:      { pillar: 'COMPUTING',       purposes: ['COMPUTATION', 'EMERGENCE', 'COHERENCE'] },
  swarm_telemetry:    { pillar: 'SCALABILITY',     purposes: ['PERCEPTION', 'SELF_MODEL', 'AUDIT'] },
  airdrop_engine:     { pillar: 'SCALABILITY',     purposes: ['VALUE_TRANSFER', 'COORDINATION'] },
  nova_protocol:      { pillar: 'COMPUTING',       purposes: ['INTEGRITY', 'LAW_ENFORCEMENT', 'COMPUTATION'] },
  nova_student:       { pillar: 'MACHINE_LEARNING', purposes: ['LEARNING', 'MEMORY', 'ADAPTATION'] },
  dallas_isd:         { pillar: 'MACHINE_LEARNING', purposes: ['EDUCATION', 'LEARNING', 'ADAPTATION'] },
};

// ══════════════════════════════════════════════════════════════════════════════
// SWARM_BRAIN MODULES — 345 .mo files organized by intelligence type
// ══════════════════════════════════════════════════════════════════════════════

export const SWARM_BRAIN_MODULES_BY_PILLAR: Record<IntelligencePillar, string[]> = {
  NEURAL: [
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
    // ... 60+ more neural modules
  ],
  
  COGNITIVE: [
    'MedinaMetaCognitionSupreme.mo',
    'CognitiveScienceAdvisor.mo',
    'WorldModelSystem.mo',
    'AttentionSchemaEngine.mo',
    'MedinaConsciousnessField.mo',
    'MedinaQuantumBrain.mo',
    'TemporalHologram.mo',
    'CognitiveMemorySystems.mo',
    'MembraneMemory.mo',
    'MedinaPlanningHorizon.mo',
    'MedinaMasterIntertwining.mo',
    'InformationMetabolismSystem.mo',
    'PreConsciousStartleComprehensive.mo',
    'SovereignDualCircuit.mo',
    'SimulatedWorld.mo',
    // ... 45+ more cognitive modules
  ],
  
  EMERGENCE: [
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
    // ... 40+ more emergence modules
  ],
  
  ADAPTATION: [
    'CompoundLearning.mo',
    'AttractorDynamics.mo',
    'LyapunovStability.mo',
    'FristonEngine.mo',
    'AdvancedAdaptiveEmergentOrganisms.mo',
    'OrganismBehavioralSubstrate.mo',
    'BehavioralEconomics.mo',
    'RiskManagementSystem.mo',
    'BacktestingFramework.mo',
    'AresRollbackEngine.mo',
    'AresRollbackStackFull.mo',
    'PersistenceMissionLock.mo',
    'AntiOrganismDefense.mo',
    'AntiOrganismDefenseArchitecture.mo',
    'VetusThreatSystem.mo',
    // ... 55+ more adaptation modules
  ],
  
  SCALABILITY: [
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
    // ... 30+ more scalability modules
  ],
  
  COMPUTING: [
    'AdvancedMathematicalFoundations.mo',
    'MedinaMathFoundation.mo',
    'MedinaEngine.mo',
    'MedinaLaws.mo',
    'SphericalLaw.mo',
    'PhiFrequencyNodes.mo',
    'ChronoTemporalPrecisionEngine.mo',
    'AncientFrequencyGeometry.mo',
    'CosmologicalCalendarSynthesis.mo',
    'UniversalCalendarSynthesis.mo',
    'PhaseLockCalendarEngine.mo',
    'MedinaQuantumProtocols.mo',
    'MedinaQuantumCovenantChain.mo',
    'DoctrineFingerprint.mo',
    'MedinaSphericalWeb.mo',
    'GovernanceLaws.mo',
    // ... 70+ more computing modules
  ],
  
  MACHINE_LEARNING: [
    'PatternMiner.mo',
    'PatternFabric.mo',
    'BackwardKalmanSmoother.mo',
    'ArchitectureExtractionFramework.mo',
    'DeepNeuralIntegrationFabric.mo',
    'DeepLayerArchitectureEngine.mo',
    'InternalAILabs.mo',
    'AIToolMarketplace.mo',
    'AgentIncentiveService.mo',
    'AutoGenerateCallsEngine.mo',
    'BitcoinPuzzleSolver.mo',
    'MED1019BitcoinMiner.mo',
    'MED1019CoherenceHash.mo',
    'MED1019OrganismMining.mo',
    // ... 35+ more ML modules
  ],
};

// ══════════════════════════════════════════════════════════════════════════════
// CPL INTELLIGENCE MODULES — 119 pure .ts files (no React)
// ══════════════════════════════════════════════════════════════════════════════

export const CPL_INTELLIGENCE_MODULES: Record<IntelligencePillar, string[]> = {
  NEURAL: [
    'math/neurochemistry.ts',
    'math/neuro-emergence-engine.ts',
  ],
  
  COGNITIVE: [
    'intelligence/primitives.ts',
    'intelligence/FModelRegistry.ts',
    'intelligence/sovereignFlip.ts',
    'intelligence/PhantomBlockchainRegistry.ts',
    'sdk/voice-to-interface/IntentParser.ts',
    'sdk/voice-to-interface/NativeNovaAIs.ts',
    'sdk/voice-to-interface/LanguageAIWorkers.ts',
    'sdk/voice-to-interface/AIWorkforceOrchestrator.ts',
  ],
  
  EMERGENCE: [
    'math/emergence.ts',
    'math/kuramoto.ts',
    'organisms/NeuroEmergenceSubstrate.ts',
    'organisms/LivingWorldComputation.ts',
  ],
  
  ADAPTATION: [
    'math/antifragility.ts',
    'math/lyapunov.ts',
    'math/behavioral-economics.ts',
  ],
  
  SCALABILITY: [
    'organisms/ModuleWiringArchitecture.ts',
    'organism/FusionOrganism.ts',
    'organism/OrganismBridge.ts',
    'organism/FrontendOrganism.ts',
  ],
  
  COMPUTING: [
    'math/core.ts',
    'math/quantum.ts',
    'math/sovereign-geometry.ts',
    'math/hz-substrate.ts',
    'math/laws.ts',
    'math/genesis.ts',
    'math/quipu-engine.ts',
    'math/lingua-compressa.ts',
  ],
  
  MACHINE_LEARNING: [
    'math/scoring-extended.ts',
    'math/anima-micro.ts',
    'sdk/voice-to-interface/VoiceRecognitionEngine.ts',
  ],
};

// ══════════════════════════════════════════════════════════════════════════════
// SERVITORES FLEET — 70 .js workers organized by intelligence type
// ══════════════════════════════════════════════════════════════════════════════

export const SERVITORES_BY_PILLAR: Record<IntelligencePillar, string[]> = {
  NEURAL: [
    'agr-solver-worker.js',        // GOL-AGR-001 AMOR_PERPETUA
    'species-research-solver-worker.js', // GOL-SPECIES-001 SPECIES_AETERNA
  ],
  
  COGNITIVE: [
    'cognition-worker.js',
    'reasoning-worker.js',
  ],
  
  EMERGENCE: [
    'fusion-worker.js',            // GOL-FUSIO-001 FUSIO_AETERNA
    'coherence-worker.js',
  ],
  
  ADAPTATION: [
    'civ-repair-solver-worker.js', // GOL-CIVREPAIR-001 SANATIO_AETERNA
    'defense-canister-solver-worker.js', // GOL-DEFPROM-001 DEFENSIO_AETERNA
  ],
  
  SCALABILITY: [
    'orchestrator-worker.js',
    'coordinator-worker.js',
  ],
  
  COMPUTING: [
    'math-worker.js',
    'quantum-worker.js',
  ],
  
  MACHINE_LEARNING: [
    'pattern-worker.js',
    'learning-worker.js',
  ],
};

// ══════════════════════════════════════════════════════════════════════════════
// TOTAL MODULE COUNTS BY PILLAR
// ══════════════════════════════════════════════════════════════════════════════

export const MODULE_COUNTS: Record<IntelligencePillar, number> = {
  NEURAL:           87,
  COGNITIVE:        64,
  EMERGENCE:        53,
  ADAPTATION:       71,
  SCALABILITY:      42,
  COMPUTING:        89,
  MACHINE_LEARNING: 47,
};

export const TOTAL_MODULES = 654;

// ══════════════════════════════════════════════════════════════════════════════
// MODULE COMPRESSION COMPLETE
// ══════════════════════════════════════════════════════════════════════════════

export const MODULE_REGISTRY_VERSION = '47.0.0';
export const MODULE_REGISTRY_BUILD = 47;
