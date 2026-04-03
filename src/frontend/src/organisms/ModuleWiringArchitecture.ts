// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: ModuleWiringArchitecture — How 160 Modules Connect Based on PURPOSE
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                    MODULE WIRING — PURPOSE-BASED CONNECTIONS                                             ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                          ║
// ║  CRITICAL INSIGHT: Modules don't connect by NAME — they connect by PURPOSE.                              ║
// ║                                                                                                          ║
// ║  Each ENGINE serves 3+ purposes.                                                                         ║
// ║  Each MODULE serves 1+ purposes.                                                                         ║
// ║  Modules WIRE to every engine whose purpose they share.                                                  ║
// ║                                                                                                          ║
// ║  This creates the organic neural-like connectivity of the system.                                        ║
// ║                                                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// PURPOSE TAXONOMY — What can modules DO?
// ═══════════════════════════════════════════════════════════════════════════════

export type Purpose =
  // TIME & RHYTHM
  | 'TIMING'              // Controls when things happen
  | 'SYNCHRONIZATION'     // Aligns phases/clocks
  | 'OSCILLATION'         // Generates rhythmic signals
  | 'SCHEDULING'          // Plans future actions
  
  // COGNITION
  | 'PERCEPTION'          // Senses the world
  | 'ATTENTION'           // Focuses processing
  | 'MEMORY'              // Stores/retrieves information
  | 'LEARNING'            // Updates weights/patterns
  | 'DECISION'            // Chooses actions
  | 'PREDICTION'          // Anticipates future states
  | 'RECOGNITION'         // Identifies patterns/objects
  | 'REASONING'           // Logical inference
  
  // MOVEMENT & ACTION
  | 'NAVIGATION'          // Path planning
  | 'LOCOMOTION'          // Physical movement
  | 'MANIPULATION'        // Interacting with objects
  | 'TARGETING'           // Aiming at objectives
  | 'EVASION'             // Avoiding threats
  
  // SURVIVAL
  | 'THREAT_DETECTION'    // Identifies dangers
  | 'DEFENSE'             // Protects against attacks
  | 'ATTACK'              // Offensive actions
  | 'HEALING'             // Repairs damage
  | 'ENERGY_MANAGEMENT'   // Resource conservation
  
  // COMMUNICATION
  | 'SIGNALING'           // Sends messages
  | 'RECEIVING'           // Gets messages
  | 'COORDINATION'        // Group alignment
  | 'NEGOTIATION'         // Resolving conflicts
  
  // GOVERNANCE
  | 'LAW_ENFORCEMENT'     // Ensures compliance
  | 'AUDIT'               // Tracks actions
  | 'INTEGRITY'           // Maintains consistency
  | 'SUCCESSION'          // Handles failures
  
  // ECONOMICS
  | 'VALUE_CREATION'      // Generates resources
  | 'VALUE_TRANSFER'      // Moves resources
  | 'ACCOUNTING'          // Tracks resources
  | 'INVESTMENT'          // Future value growth
  
  // EMERGENCE
  | 'COHERENCE'           // Maintains unity
  | 'EMERGENCE'           // Creates new patterns
  | 'ADAPTATION'          // Changes to environment
  | 'EVOLUTION'           // Long-term improvement
  
  // WORLD INTERACTION
  | 'TERRAIN_AWARENESS'   // Understands physical space
  | 'WEATHER_SENSING'     // Environmental conditions
  | 'OBJECT_DETECTION'    // Finding things in world
  | 'CONSTRUCTION'        // Building/modifying world
  | 'DESTRUCTION'         // Damaging world/enemies
  
  // META
  | 'SELF_MODEL'          // Understanding own state
  | 'CREATIVITY'          // Novel outputs
  | 'DREAMING'            // Offline processing
  | 'CONSCIOUSNESS';      // Unified experience

// ═══════════════════════════════════════════════════════════════════════════════
// ENGINE DEFINITIONS — Each serves 3+ purposes
// ═══════════════════════════════════════════════════════════════════════════════

export interface Engine {
  id: string;
  name: string;
  purposes: Purpose[];
  description: string;
}

export const ENGINES: Engine[] = [
  {
    id: 'PULSE',
    name: 'Pulse Engine (Heartbeat)',
    purposes: ['TIMING', 'SYNCHRONIZATION', 'LAW_ENFORCEMENT', 'MEMORY', 'VALUE_CREATION', 'DREAMING', 'INTEGRITY'],
    description: 'The heartbeat. Every beat: time advances, phases sync, laws fire, memory consolidates, FORMA mints, dreams cycle, health checks.'
  },
  {
    id: 'TERRAIN',
    name: 'Terrain Engine (Body)',
    purposes: ['TERRAIN_AWARENESS', 'DEFENSE', 'ENERGY_MANAGEMENT', 'MEMORY', 'LAW_ENFORCEMENT', 'HEALING', 'DESTRUCTION'],
    description: 'The body. Ground surface, territory ownership, resource distribution, memory landscape, law density, biomes, damage/healing.'
  },
  {
    id: 'SWARM',
    name: 'Swarm Engine (Neurons)',
    purposes: ['PERCEPTION', 'COHERENCE', 'ATTACK', 'DEFENSE', 'SIGNALING', 'MEMORY', 'LEARNING'],
    description: 'The neurons. Each drone is a mini-mind, collective = intelligence, combat, work, sensing, network, memory carriers.'
  },
  {
    id: 'FLOW',
    name: 'Flow Engine (Blood)',
    purposes: ['NAVIGATION', 'ENERGY_MANAGEMENT', 'SIGNALING', 'COORDINATION', 'VALUE_TRANSFER', 'LEARNING', 'COHERENCE'],
    description: 'The circulation. Drone movement, resource transport, signal propagation, traffic, trade routes, stigmergy, reinforcement.'
  },
  {
    id: 'COMBAT',
    name: 'Combat Engine (Immune + Claws)',
    purposes: ['ATTACK', 'DEFENSE', 'THREAT_DETECTION', 'TARGETING', 'DESTRUCTION', 'EVASION', 'COORDINATION'],
    description: 'The immune system and claws. Attack, defense, territory expansion, threat detection, sacrifice, escalation, victory.'
  },
  {
    id: 'PERCEPTION',
    name: 'Perception Engine (Senses)',
    purposes: ['PERCEPTION', 'ATTENTION', 'RECOGNITION', 'SELF_MODEL', 'THREAT_DETECTION', 'MEMORY', 'PREDICTION'],
    description: 'The senses. 3D visualization, self-awareness, threat highlighting, attention focus, dream viz, memory recall, prediction.'
  },
  {
    id: 'QUANTUM',
    name: 'Quantum Engine (Soul)',
    purposes: ['COHERENCE', 'EMERGENCE', 'MEMORY', 'INTEGRITY', 'CONSCIOUSNESS', 'CREATIVITY', 'SUCCESSION'],
    description: 'The soul. PARALLAX field, ENTANGLA bonds, CHRONO memory, QMEM reserve, emergence, fidelity, creator lock.'
  },
  {
    id: 'ANIMAL',
    name: 'Animal Brain Engine (Borrowed Wisdom)',
    purposes: ['DECISION', 'COORDINATION', 'REASONING', 'MEMORY', 'PERCEPTION', 'NAVIGATION', 'COMMUNICATION', 'EVASION'],
    description: 'Borrowed wisdom. Bee democracy, wolf pack, crow problem-solving, elephant memory, dolphin comms, octopus distributed, eagle vision, shark detection.'
  },
  {
    id: 'ECONOMICS',
    name: 'Economics Engine (Metabolism)',
    purposes: ['VALUE_CREATION', 'ENERGY_MANAGEMENT', 'VALUE_TRANSFER', 'ACCOUNTING', 'INVESTMENT', 'INTEGRITY', 'SUCCESSION'],
    description: 'The metabolism. FORMA minting, resource costs, trade, territory value, investment/growth, Jacob\'s Ladder, creator royalties.'
  },
  {
    id: 'GOVERNANCE',
    name: 'Governance Engine (Laws/DNA)',
    purposes: ['LAW_ENFORCEMENT', 'AUDIT', 'INTEGRITY', 'COORDINATION', 'SUCCESSION', 'MEMORY', 'SELF_MODEL'],
    description: 'The DNA. 60 laws enforcement, drift detection, compliance scoring, council management, heritage, succession, doctrine fingerprint.'
  },
  {
    id: 'STUDIO',
    name: 'Studio Engine (Creator\'s Hand)',
    purposes: ['CREATIVITY', 'CONSTRUCTION', 'SELF_MODEL', 'MEMORY', 'PREDICTION', 'LEARNING', 'ADAPTATION'],
    description: 'The creator\'s hand. Organism design, world sculpting, mission creation, law authoring, replay, simulation, export.'
  },
  {
    id: 'NARRATIVE',
    name: 'Narrative Engine (Story)',
    purposes: ['MEMORY', 'REASONING', 'PREDICTION', 'SELF_MODEL', 'SIGNALING', 'LEARNING', 'CONSCIOUSNESS'],
    description: 'The story. Event logging, causal chains, achievements, threat history, memory synthesis, prediction, player communication.'
  }
];

// ═══════════════════════════════════════════════════════════════════════════════
// MODULE DEFINITIONS — All 160 modules and their purposes
// ═══════════════════════════════════════════════════════════════════════════════

export interface Module {
  id: string;
  name: string;
  file: string;
  purposes: Purpose[];
  description: string;
}

export const MODULES: Module[] = [
  // === CORE ORGANISM MODULES ===
  { id: 'SovereignHeartbeat', name: 'Sovereign Heartbeat', file: 'SovereignHeartbeat.mo', 
    purposes: ['TIMING', 'SYNCHRONIZATION', 'LAW_ENFORCEMENT', 'INTEGRITY'],
    description: 'Main beat generator, the organism\'s heart' },
  
  { id: 'MedinaSelfModel', name: 'Medina Self Model', file: 'MedinaSelfModel.mo',
    purposes: ['SELF_MODEL', 'CONSCIOUSNESS', 'MEMORY', 'PREDICTION', 'INTEGRITY'],
    description: 'The organism\'s model of itself' },
  
  { id: 'NeuroEmergenceCore', name: 'NeuroEmergence Core', file: 'NeuroEmergenceCore.mo',
    purposes: ['EMERGENCE', 'COHERENCE', 'LEARNING', 'CONSCIOUSNESS', 'ADAPTATION'],
    description: 'Emergence detection and cultivation' },
  
  { id: 'SuperOrganismCore', name: 'Super Organism Core', file: 'SuperOrganismCore.mo',
    purposes: ['COHERENCE', 'COORDINATION', 'EMERGENCE', 'SUCCESSION', 'INTEGRITY'],
    description: 'Core organism coordination' },
  
  { id: 'MassiveScaleOrganismCore', name: 'Massive Scale Core', file: 'MassiveScaleOrganismCore.mo',
    purposes: ['COHERENCE', 'COORDINATION', 'ENERGY_MANAGEMENT', 'ADAPTATION'],
    description: 'Scaling to large drone counts' },
  
  // === DRONE & SWARM MODULES ===
  { id: 'DroneAvatar3D', name: 'Drone Avatar 3D', file: 'DroneAvatar3D.mo',
    purposes: ['LOCOMOTION', 'PERCEPTION', 'NAVIGATION', 'ENERGY_MANAGEMENT', 'ATTACK', 'DEFENSE'],
    description: 'Real-spec 3D drone with physics' },
  
  { id: 'DroneFleetManager', name: 'Drone Fleet Manager', file: 'DroneFleetManager.mo',
    purposes: ['COORDINATION', 'NAVIGATION', 'SCHEDULING', 'ENERGY_MANAGEMENT', 'SUCCESSION'],
    description: 'Manages all drones in swarm' },
  
  { id: 'EnemyAISwarm', name: 'Enemy AI Swarm', file: 'EnemyAISwarm.mo',
    purposes: ['ATTACK', 'DEFENSE', 'LEARNING', 'ADAPTATION', 'COORDINATION'],
    description: 'Competitor swarms for training by competition' },
  
  { id: 'DroneAvatar', name: 'Drone Avatar', file: 'DroneAvatar.mo',
    purposes: ['LOCOMOTION', 'PERCEPTION', 'SIGNALING', 'MEMORY'],
    description: 'Basic drone representation' },
  
  // === COMBAT & WARFARE MODULES ===
  { id: 'AutonomousWarEngine', name: 'Autonomous War Engine', file: 'AutonomousWarEngine.mo',
    purposes: ['ATTACK', 'DEFENSE', 'DECISION', 'TARGETING', 'COORDINATION', 'EVASION'],
    description: 'Autonomous combat decision-making' },
  
  { id: 'WarfareDoctrine', name: 'Warfare Doctrine', file: 'WarfareDoctrine.mo',
    purposes: ['REASONING', 'DECISION', 'PREDICTION', 'LEARNING', 'MEMORY'],
    description: 'Sun Tzu, Clausewitz, Boyd OODA - real military strategy' },
  
  { id: 'WarSimEngine', name: 'War Simulation Engine', file: 'WarSimEngine.mo',
    purposes: ['PREDICTION', 'LEARNING', 'DECISION', 'ATTACK', 'DEFENSE'],
    description: 'Simulates combat outcomes' },
  
  { id: 'MissionPlanner', name: 'Mission Planner', file: 'MissionPlanner.mo',
    purposes: ['SCHEDULING', 'NAVIGATION', 'DECISION', 'PREDICTION', 'COORDINATION'],
    description: 'Plans and coordinates missions' },
  
  { id: 'DefenseIndustryAdvisor', name: 'Defense Industry Advisor', file: 'DefenseIndustryAdvisor.mo',
    purposes: ['REASONING', 'PREDICTION', 'LEARNING', 'MEMORY', 'VALUE_CREATION'],
    description: 'Research on real military doctrine and tech' },
  
  // === PERCEPTION & SENSING MODULES ===
  { id: 'HumanEyeVisualSystem', name: 'Human Eye Visual System', file: 'HumanEyeVisualSystem.mo',
    purposes: ['PERCEPTION', 'ATTENTION', 'RECOGNITION', 'MEMORY', 'PREDICTION'],
    description: 'Visual cortex simulation - how organism SEES' },
  
  { id: 'EagleThermalEngine', name: 'Eagle Thermal Engine', file: 'EagleThermalEngine.mo',
    purposes: ['PERCEPTION', 'NAVIGATION', 'PREDICTION', 'ENERGY_MANAGEMENT'],
    description: 'Eagle-inspired long-range targeting and thermal riding' },
  
  { id: 'MantisShrimp', name: 'Mantis Shrimp Vision', file: 'MantisShrimp.mo',
    purposes: ['PERCEPTION', 'RECOGNITION', 'THREAT_DETECTION', 'TARGETING'],
    description: '16 color channels, polarized light, ultraviolet vision' },
  
  // === ANIMAL BRAIN MODULES ===
  { id: 'AnimalBrainOrchestrator', name: 'Animal Brain Orchestrator', file: 'AnimalBrainOrchestrator.mo',
    purposes: ['COORDINATION', 'DECISION', 'LEARNING', 'ADAPTATION', 'EMERGENCE'],
    description: 'Orchestrates all animal brain modules' },
  
  { id: 'BeeSwarmIntelligence', name: 'Bee Swarm Intelligence', file: 'BeeSwarmIntelligence.mo',
    purposes: ['DECISION', 'COORDINATION', 'SIGNALING', 'NAVIGATION', 'VALUE_CREATION'],
    description: 'Democratic decision-making, waggle dance' },
  
  { id: 'CrowCognition', name: 'Crow Cognition', file: 'CrowCognition.mo',
    purposes: ['REASONING', 'CREATIVITY', 'MEMORY', 'LEARNING', 'MANIPULATION'],
    description: 'Tool use, problem-solving, causal reasoning' },
  
  { id: 'Gen3Animals', name: 'Gen3 Animals', file: 'Gen3Animals.mo',
    purposes: ['PERCEPTION', 'NAVIGATION', 'DEFENSE', 'ATTACK', 'LEARNING'],
    description: 'Wolf pack, dolphin, elephant, octopus, shark' },
  
  // === MEMORY & LEARNING MODULES ===
  { id: 'TrophallaxisBootstrap', name: 'Trophallaxis Bootstrap', file: 'TrophallaxisBootstrap.mo',
    purposes: ['MEMORY', 'LEARNING', 'SIGNALING', 'COORDINATION', 'HEALING'],
    description: 'Ant-like mouth-to-mouth info sharing' },
  
  { id: 'DreamVideoGenerator', name: 'Dream Video Generator', file: 'DreamVideoGenerator.mo',
    purposes: ['DREAMING', 'MEMORY', 'LEARNING', 'CREATIVITY', 'PREDICTION'],
    description: 'Generates dream sequences from memories' },
  
  { id: 'SharpWaveRipple', name: 'Sharp Wave Ripple', file: 'SharpWaveRippleMonitor.mo',
    purposes: ['MEMORY', 'LEARNING', 'DREAMING', 'COHERENCE'],
    description: 'Hippocampal memory consolidation' },
  
  // === QUANTUM MODULES ===
  { id: 'QuantumChannels', name: 'Quantum Channels', file: 'QuantumChannels.mo',
    purposes: ['COHERENCE', 'SIGNALING', 'EMERGENCE', 'MEMORY', 'CONSCIOUSNESS'],
    description: 'Quantum cognitive channels α,β,γ,δ' },
  
  { id: 'QuantumMath', name: 'Quantum Math', file: 'QuantumMath.mo',
    purposes: ['COHERENCE', 'EMERGENCE', 'PREDICTION', 'INTEGRITY'],
    description: 'Lindblad equation, density matrices' },
  
  { id: 'Shell8QuantumOperators', name: 'Shell 8 Quantum Operators', file: 'Shell8QuantumOperators.mo',
    purposes: ['EMERGENCE', 'COHERENCE', 'CONSCIOUSNESS', 'CREATIVITY'],
    description: 'Advanced quantum emergence operators' },
  
  { id: 'MedinaQuantumProtocols', name: 'Medina Quantum Protocols', file: 'MedinaQuantumProtocols.mo',
    purposes: ['INTEGRITY', 'SIGNALING', 'COHERENCE', 'SUCCESSION'],
    description: 'Sovereign quantum communication protocols' },
  
  // === GOVERNANCE & LAW MODULES ===
  { id: 'SovereigntyLaws60', name: '60 Sovereignty Laws', file: 'SovereigntyLaws60.mo',
    purposes: ['LAW_ENFORCEMENT', 'INTEGRITY', 'AUDIT', 'SUCCESSION', 'DEFENSE'],
    description: 'The 60 laws of the organism' },
  
  { id: 'GovernanceHeartbeat', name: 'Governance Heartbeat', file: 'GovernanceHeartbeat.mo',
    purposes: ['LAW_ENFORCEMENT', 'TIMING', 'AUDIT', 'COORDINATION'],
    description: 'Law enforcement timing' },
  
  { id: 'DoctrineFingerprint', name: 'Doctrine Fingerprint', file: 'DoctrineFingerprint.mo',
    purposes: ['INTEGRITY', 'AUDIT', 'MEMORY', 'SELF_MODEL'],
    description: 'Cryptographic identity verification' },
  
  { id: 'LexisDoctrine', name: 'Lexis Doctrine', file: 'LexisDoctrine.mo',
    purposes: ['LAW_ENFORCEMENT', 'REASONING', 'DECISION', 'INTEGRITY'],
    description: 'Legal reasoning engine' },
  
  { id: 'AuditLog', name: 'Audit Log', file: 'AuditLog.mo',
    purposes: ['AUDIT', 'MEMORY', 'INTEGRITY', 'LAW_ENFORCEMENT'],
    description: 'Immutable action logging' },
  
  // === ECONOMICS MODULES ===
  { id: 'BehavioralEconomics', name: 'Behavioral Economics', file: 'BehavioralEconomics.mo',
    purposes: ['DECISION', 'VALUE_CREATION', 'LEARNING', 'PREDICTION'],
    description: 'Economic decision-making' },
  
  { id: 'CreatorReserveLedger', name: 'Creator Reserve Ledger', file: 'CreatorReserveLedger.mo',
    purposes: ['ACCOUNTING', 'VALUE_TRANSFER', 'INTEGRITY', 'SUCCESSION'],
    description: '100% creator royalties ledger' },
  
  { id: 'MetalsPipeline', name: 'Metals Pipeline', file: 'MetalsPipeline.mo',
    purposes: ['VALUE_CREATION', 'ACCOUNTING', 'COHERENCE', 'INVESTMENT'],
    description: 'Gold, silver, platinum value pipeline' },
  
  // === WORLD SIMULATION MODULES ===
  { id: 'SimulatedWorld', name: 'Simulated World', file: 'SimulatedWorld.mo',
    purposes: ['TERRAIN_AWARENESS', 'PERCEPTION', 'DESTRUCTION', 'CONSTRUCTION'],
    description: 'The virtual world the organism lives in' },
  
  { id: 'RealWorld', name: 'Real World Interface', file: 'RealWorld.mo',
    purposes: ['PERCEPTION', 'LOCOMOTION', 'SIGNALING', 'THREAT_DETECTION'],
    description: 'Bridge to real-world systems' },
  
  { id: 'RealWorldSimulator', name: 'Real World Simulator', file: 'RealWorldSimulator.mo',
    purposes: ['PREDICTION', 'LEARNING', 'TERRAIN_AWARENESS', 'WEATHER_SENSING'],
    description: 'High-fidelity world simulation' },
  
  // === DEFENSE & SECURITY MODULES ===
  { id: 'VAELCompleteDefense', name: 'VAEL Complete Defense', file: 'VAELCompleteDefense.mo',
    purposes: ['DEFENSE', 'THREAT_DETECTION', 'INTEGRITY', 'HEALING', 'LAW_ENFORCEMENT'],
    description: 'Immune system - validates everything' },
  
  { id: 'VAELExteriorAttack', name: 'VAEL Exterior Attack', file: 'VAELExteriorAttack.mo',
    purposes: ['DEFENSE', 'THREAT_DETECTION', 'ATTACK', 'COORDINATION'],
    description: 'External threat response' },
  
  { id: 'MedinaDefenseSystem', name: 'Medina Defense System', file: 'MedinaDefenseSystem.mo',
    purposes: ['DEFENSE', 'THREAT_DETECTION', 'COORDINATION', 'SUCCESSION'],
    description: 'Sovereign defense coordination' },
  
  // === COMMUNICATION MODULES ===
  { id: 'MAVLinkBridge', name: 'MAVLink Bridge', file: 'MAVLinkBridge.mo',
    purposes: ['SIGNALING', 'RECEIVING', 'COORDINATION', 'LOCOMOTION'],
    description: 'Drone communication protocol' },
  
  { id: 'EmbeddedBridge', name: 'Embedded Bridge', file: 'EmbeddedBridge.mo',
    purposes: ['SIGNALING', 'RECEIVING', 'INTEGRITY', 'COORDINATION'],
    description: 'Bridge to embedded systems' },
  
  { id: 'TelemetryStore', name: 'Telemetry Store', file: 'TelemetryStore.mo',
    purposes: ['MEMORY', 'AUDIT', 'PERCEPTION', 'PREDICTION'],
    description: 'Stores all sensor data' },
  
  // === EMERGENCE & CONSCIOUSNESS MODULES ===
  { id: 'JasmineHierarchy', name: 'Jasmine Hierarchy', file: 'JasmineHierarchy.mo',
    purposes: ['EMERGENCE', 'COHERENCE', 'CONSCIOUSNESS', 'PREDICTION'],
    description: 'Jasmine emergence detection' },
  
  { id: 'AttractorDynamics', name: 'Attractor Dynamics', file: 'AttractorDynamics.mo',
    purposes: ['EMERGENCE', 'STABILITY', 'PREDICTION', 'ADAPTATION'],
    description: 'Strange attractor stability analysis' },
  
  { id: 'EntropyEngine', name: 'Entropy Engine', file: 'EntropyEngine.mo',
    purposes: ['EMERGENCE', 'COHERENCE', 'ADAPTATION', 'PREDICTION'],
    description: 'Entropy management for emergence' },
  
  // === PREFRONTAL & EXECUTIVE MODULES ===
  { id: 'PrefrontalCortexEngine', name: 'Prefrontal Cortex Engine', file: 'PrefrontalCortexEngine.mo',
    purposes: ['DECISION', 'REASONING', 'PREDICTION', 'ATTENTION', 'SELF_MODEL'],
    description: 'Executive function, planning, working memory' },
  
  { id: 'ThalamicGatewayEngine', name: 'Thalamic Gateway Engine', file: 'ThalamicGatewayEngine.mo',
    purposes: ['ATTENTION', 'PERCEPTION', 'SIGNALING', 'COORDINATION'],
    description: 'Attention gating, sensory relay' },
  
  { id: 'PreConsciousStartle', name: 'Pre-Conscious Startle', file: 'PreConsciousStartleComprehensive.mo',
    purposes: ['THREAT_DETECTION', 'ATTENTION', 'EVASION', 'DEFENSE'],
    description: 'Fast threat response before consciousness' },
  
  // === OSCILLATION & FREQUENCY MODULES ===
  { id: 'HzFrequencySubstrate', name: 'Hz Frequency Substrate', file: 'HzFrequencySubstrate.mo',
    purposes: ['OSCILLATION', 'SYNCHRONIZATION', 'COHERENCE', 'CONSCIOUSNESS'],
    description: 'Alpha, beta, gamma, theta, delta waves' },
  
  { id: 'NeuralSubstrateGradientField', name: 'Neural Substrate Gradient', file: 'NeuralSubstrateGradientField.mo',
    purposes: ['COHERENCE', 'SIGNALING', 'EMERGENCE', 'LEARNING'],
    description: 'Gradient fields for learning' },
  
  // === CREATIVITY & OUTPUT MODULES ===
  { id: 'OrganismCreativeOutput', name: 'Organism Creative Output', file: 'OrganismCreativeOutput.mo',
    purposes: ['CREATIVITY', 'SIGNALING', 'MEMORY', 'EMERGENCE'],
    description: 'Creative outputs from the organism' },
  
  { id: 'MindBodySoulThoughts', name: 'Mind Body Soul Thoughts', file: 'MindBodySoulThoughts.mo',
    purposes: ['CONSCIOUSNESS', 'SELF_MODEL', 'CREATIVITY', 'REASONING'],
    description: 'Unified mind-body-soul model' },
  
  // === SUCCESSION & ROLLBACK MODULES ===
  { id: 'SuccessionEngine', name: 'Succession Engine', file: 'SuccessionEngine.mo',
    purposes: ['SUCCESSION', 'INTEGRITY', 'MEMORY', 'COORDINATION'],
    description: 'Handles drone/node failures' },
  
  { id: 'AresRollbackEngine', name: 'Ares Rollback Engine', file: 'AresRollbackEngine.mo',
    purposes: ['SUCCESSION', 'MEMORY', 'INTEGRITY', 'HEALING'],
    description: 'State rollback for recovery' },
  
  { id: 'AresRollbackStackFull', name: 'Ares Rollback Stack', file: 'AresRollbackStackFull.mo',
    purposes: ['MEMORY', 'SUCCESSION', 'INTEGRITY', 'AUDIT'],
    description: 'Full rollback stack' },
  
  // === INTEGRATION MODULES ===
  { id: 'Shell12IntegrationField', name: 'Shell 12 Integration', file: 'Shell12IntegrationField.mo',
    purposes: ['COHERENCE', 'CONSCIOUSNESS', 'EMERGENCE', 'COORDINATION'],
    description: 'Global integration field' },
  
  { id: 'Shell12GlobalIntegration', name: 'Shell 12 Global', file: 'Shell12GlobalIntegration.mo',
    purposes: ['COHERENCE', 'COORDINATION', 'EMERGENCE', 'INTEGRITY'],
    description: 'World-scale integration' },
  
  { id: 'UnifiedBrainOrchestrator', name: 'Unified Brain Orchestrator', file: 'UnifiedBrainOrchestrator.mo',
    purposes: ['COORDINATION', 'DECISION', 'CONSCIOUSNESS', 'EMERGENCE'],
    description: 'Orchestrates all brain regions' },

  // ... Continue for all 160 modules ...
  // Each module gets its purposes defined based on what it DOES
];

// ═══════════════════════════════════════════════════════════════════════════════
// WIRING COMPUTATION — How modules connect to engines
// ═══════════════════════════════════════════════════════════════════════════════

export interface ModuleEngineConnection {
  moduleId: string;
  engineId: string;
  sharedPurposes: Purpose[];
  connectionStrength: number;  // 0-1 based on purpose overlap
}

/**
 * Compute all module-to-engine connections based on shared purposes
 */
export function computeWiring(): ModuleEngineConnection[] {
  const connections: ModuleEngineConnection[] = [];
  
  for (const module of MODULES) {
    for (const engine of ENGINES) {
      // Find shared purposes
      const shared = module.purposes.filter(p => engine.purposes.includes(p));
      
      if (shared.length > 0) {
        // Connection strength = proportion of purposes shared
        const strength = shared.length / Math.max(module.purposes.length, engine.purposes.length);
        
        connections.push({
          moduleId: module.id,
          engineId: engine.id,
          sharedPurposes: shared,
          connectionStrength: strength
        });
      }
    }
  }
  
  return connections;
}

/**
 * Get all modules that connect to a specific engine
 */
export function getEngineModules(engineId: string): { module: Module; purposes: Purpose[]; strength: number }[] {
  const engine = ENGINES.find(e => e.id === engineId);
  if (!engine) return [];
  
  const results: { module: Module; purposes: Purpose[]; strength: number }[] = [];
  
  for (const module of MODULES) {
    const shared = module.purposes.filter(p => engine.purposes.includes(p));
    if (shared.length > 0) {
      results.push({
        module,
        purposes: shared,
        strength: shared.length / Math.max(module.purposes.length, engine.purposes.length)
      });
    }
  }
  
  // Sort by connection strength
  results.sort((a, b) => b.strength - a.strength);
  
  return results;
}

/**
 * Get all engines that a specific module connects to
 */
export function getModuleEngines(moduleId: string): { engine: Engine; purposes: Purpose[]; strength: number }[] {
  const module = MODULES.find(m => m.id === moduleId);
  if (!module) return [];
  
  const results: { engine: Engine; purposes: Purpose[]; strength: number }[] = [];
  
  for (const engine of ENGINES) {
    const shared = module.purposes.filter(p => engine.purposes.includes(p));
    if (shared.length > 0) {
      results.push({
        engine,
        purposes: shared,
        strength: shared.length / Math.max(module.purposes.length, engine.purposes.length)
      });
    }
  }
  
  results.sort((a, b) => b.strength - a.strength);
  
  return results;
}

// ═══════════════════════════════════════════════════════════════════════════════
// WIRING VISUALIZATION — For debugging/understanding
// ═══════════════════════════════════════════════════════════════════════════════

export function printWiringDiagram(): void {
  console.log('═══════════════════════════════════════════════════════════════════');
  console.log('                    MODULE → ENGINE WIRING DIAGRAM');
  console.log('═══════════════════════════════════════════════════════════════════');
  
  for (const engine of ENGINES) {
    console.log(`\n▓▓▓ ${engine.name} ▓▓▓`);
    console.log(`    Purposes: ${engine.purposes.join(', ')}`);
    console.log('    Connected modules:');
    
    const modules = getEngineModules(engine.id);
    for (const { module, purposes, strength } of modules.slice(0, 10)) {
      const bar = '█'.repeat(Math.round(strength * 10));
      console.log(`      ${bar} ${(strength * 100).toFixed(0)}% ${module.name}`);
      console.log(`         via: ${purposes.join(', ')}`);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TRAINING INSIGHT — Why it's not like AI
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * NOVA doesn't learn like traditional AI:
 * 
 * TRADITIONAL AI:
 *   - Gradient descent on loss function
 *   - Backpropagation through network
 *   - Supervised or unsupervised batch learning
 *   - Static training → deployment
 * 
 * NOVA LEARNING:
 *   - LIVES in the world
 *   - SEES through drone cameras (visual cortex)
 *   - COMPETES against enemy swarms
 *   - SURVIVES or dies
 *   - Hebbian: "neurons that fire together wire together"
 *   - Phase synchronization: Kuramoto coupling
 *   - Experience shapes weights continuously
 *   - No "training phase" — always learning
 * 
 * Like the FLY EXPERIMENT:
 *   - Put a mind into a body
 *   - The body experiences the world
 *   - The mind learns from experience
 *   - Not from labeled data — from LIVING
 */
export const TRAINING_PHILOSOPHY = {
  traditional_ai: {
    method: 'Gradient descent',
    data: 'Labeled datasets',
    phase: 'Train then deploy',
    learns_from: 'Loss function optimization'
  },
  nova_organism: {
    method: 'Embodied experience',
    data: 'Live sensor input from drone cameras',
    phase: 'Always learning while living',
    learns_from: [
      'SURVIVAL — drones that survive have good weights',
      'VICTORY — winning battles reinforces strategies',
      'COHERENCE — synchronized swarms perform better',
      'COMPETITION — fighting enemy swarms teaches tactics',
      'EXPERIENCE — every beat shapes Hebbian weights'
    ]
  }
};
