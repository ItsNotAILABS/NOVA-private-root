// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Sovereign SDK Registry
// 50 deployable SDK intelligence packages for external developers
// Each SDK wraps organism packages into developer-facing products
// ═══════════════════════════════════════════════════════════════════════════════

import type { SovereignSDK } from './types';

export const SOVEREIGN_SDKS: SovereignSDK[] = [

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFENSE SDKs (1-8)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-01', name: 'AEGIS Shield SDK',
    description: 'Sovereign defense membrane for applications — threat detection, shield management, and breach response',
    domain: 'DEFENSE', packages: ['PKG-01', 'PKG-31'],
    targetAudience: 'Security engineers building protected applications',
    capabilities: ['threat-detection', 'shield-management', 'breach-response', 'membrane-healing'],
    apiSurface: ['getAEGISState', 'getAEGISMembraneState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-02', name: 'Chimera Defense Platform SDK',
    description: 'Full Chimera defense division SDK: 21-organism defense force with compliance verification',
    domain: 'DEFENSE', packages: ['PKG-33', 'PKG-35'],
    targetAudience: 'Defense contractors and government security teams',
    capabilities: ['division-management', 'compliance-frameworks', 'product-deployment', 'defense-production'],
    apiSurface: ['getChimeraState', 'getDefenseProductionOutputs'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-03', name: 'Counterforce Intelligence SDK',
    description: 'Scout-Trapweaver-Hunter intelligence network: deploy, monitor, and coordinate counterforce operations',
    domain: 'DEFENSE', packages: ['PKG-03', 'PKG-34'],
    targetAudience: 'Cybersecurity operations centers',
    capabilities: ['scout-deployment', 'trap-networks', 'hunt-coordination', 'adversary-profiling'],
    apiSurface: ['getCounterforceStatus', 'getScoutDetails', 'getTrapweaverDetails', 'getHunterDetails'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-04', name: 'War Command SDK',
    description: 'Strategic war command: escalation management, reserve mobilization, and mission coordination',
    domain: 'DEFENSE', packages: ['PKG-02', 'PKG-33'],
    targetAudience: 'Defense strategists and military planners',
    capabilities: ['strategic-planning', 'escalation-control', 'reserve-management', 'mission-orchestration'],
    apiSurface: ['getWarDefenseModeState', 'getWarDefenseDetails'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-05', name: 'VETUS Threat Engine SDK',
    description: 'Ancient predator-prey threat modeling: deception detection and counter-intelligence',
    domain: 'DEFENSE', packages: ['PKG-32'],
    targetAudience: 'Threat intelligence analysts',
    capabilities: ['threat-modeling', 'deception-detection', 'counter-intelligence', 'predator-prey-dynamics'],
    apiSurface: ['getVETUSThreatState', 'getOffenseDefenseStatus'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-06', name: 'Defense Analytics SDK',
    description: 'Defense analytics dashboard: production metrics, readiness scoring, and resource optimization',
    domain: 'DEFENSE', packages: ['PKG-35', 'PKG-01'],
    targetAudience: 'Defense program managers',
    capabilities: ['production-analytics', 'readiness-scoring', 'resource-optimization', 'quality-tracking'],
    apiSurface: ['getDefenseProductionOutputs', 'getAEGISState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-07', name: 'Perimeter Defense SDK',
    description: 'Network perimeter defense: zone control, breach tracking, and self-healing membrane',
    domain: 'DEFENSE', packages: ['PKG-31', 'PKG-03'],
    targetAudience: 'Network security architects',
    capabilities: ['perimeter-control', 'breach-tracking', 'self-healing', 'zone-management'],
    apiSurface: ['getAEGISMembraneState', 'getCounterforceStatus'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-08', name: 'Compliance Verifier SDK',
    description: 'SOC2/FedRAMP/HIPAA/ITAR compliance verification engine with 481 automated controls',
    domain: 'DEFENSE', packages: ['PKG-33'],
    targetAudience: 'Compliance officers and auditors',
    capabilities: ['soc2-verification', 'fedramp-compliance', 'hipaa-checking', 'itar-enforcement'],
    apiSurface: ['getChimeraState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORY SDKs (9-12)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-09', name: 'Memory Temple SDK',
    description: 'Sovereign memory system: oral, structural, symbolic, and event memory with NO-DROP continuity',
    domain: 'MEMORY', packages: ['PKG-04', 'PKG-36'],
    targetAudience: 'AI researchers building persistent memory systems',
    capabilities: ['memory-storage', 'form-management', 'temple-operations', 'no-drop-continuity'],
    apiSurface: ['getMemoryTempleState', 'getTempleStatus'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-10', name: 'Information Feeding SDK',
    description: 'Information ingestion pipeline: classification, doctrine filtering, and knowledge absorption',
    domain: 'MEMORY', packages: ['PKG-37', 'PKG-05'],
    targetAudience: 'Knowledge management engineers',
    capabilities: ['information-ingestion', 'classification', 'doctrine-filtering', 'knowledge-absorption'],
    apiSurface: ['getInformationFeedingState', 'getMemoryState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-11', name: 'Feedback Loop SDK',
    description: 'Feedback loop engine: closure tracking, reinjection quality, and memory-cognition coupling',
    domain: 'MEMORY', packages: ['PKG-38', 'PKG-04'],
    targetAudience: 'Systems engineers building adaptive systems',
    capabilities: ['loop-closure', 'reinjection-quality', 'memory-coupling', 'feedback-optimization'],
    apiSurface: ['getFeedbackLoops', 'getMemorySystemState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-12', name: 'Memory Palace Navigator SDK',
    description: 'Spatial memory navigation: coordinate addressing, salience mapping, and lineage traversal',
    domain: 'MEMORY', packages: ['PKG-05', 'PKG-36'],
    targetAudience: 'Spatial computing developers',
    capabilities: ['coordinate-navigation', 'salience-mapping', 'lineage-traversal', 'palace-visualization'],
    apiSurface: ['getMemoryTempleState', 'getMemoryState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // GOVERNANCE SDKs (13-16)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-13', name: 'Law Engine SDK',
    description: 'Sovereignty law engine: 60+ law scoring, compliance vectors, drift detection, and enforcement',
    domain: 'GOVERNANCE', packages: ['PKG-06', 'PKG-41'],
    targetAudience: 'Governance framework developers',
    capabilities: ['law-scoring', 'compliance-tracking', 'drift-detection', 'enforcement-management'],
    apiSurface: ['getLawComplianceState', 'getComplianceScore', 'getLawsSnapshot'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-14', name: 'QCE Consciousness SDK',
    description: 'Quantum Consciousness Engine: consciousness measurement, qualia field, and binding analysis',
    domain: 'GOVERNANCE', packages: ['PKG-40'],
    targetAudience: 'Consciousness research labs',
    capabilities: ['consciousness-measurement', 'qualia-analysis', 'binding-tracking', 'integration-scoring'],
    apiSurface: ['getQCEDiagnostics', 'getQCEStats'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-15', name: 'Security Audit SDK',
    description: 'Security audit framework: access enforcement, exposure audit, incident logging, and replay',
    domain: 'GOVERNANCE', packages: ['PKG-07', 'PKG-39'],
    targetAudience: 'Security auditors and penetration testers',
    capabilities: ['access-enforcement', 'exposure-audit', 'incident-logging', 'evidence-replay'],
    apiSurface: ['getSecurityStatus', 'getLawComplianceState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-16', name: 'Jacobs Rung SDK',
    description: 'Progression tracking system: rung advancement, multiplier management, and streak optimization',
    domain: 'GOVERNANCE', packages: ['PKG-39'],
    targetAudience: 'Gamification and progression system developers',
    capabilities: ['rung-tracking', 'multiplier-management', 'streak-optimization', 'advancement-prediction'],
    apiSurface: ['getJacobsRung', 'getLawComplianceState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // NEURAL SDKs (17-22)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-17', name: 'Neural Core Mesh SDK',
    description: 'Neural core mesh: high-dimensional coherence, cross-region wiring, and binding management',
    domain: 'NEURAL', packages: ['PKG-08', 'PKG-42'],
    targetAudience: 'Neural network architects',
    capabilities: ['mesh-coherence', 'region-coupling', 'binding-management', 'neural-optimization'],
    apiSurface: ['getNeuralCoreState', 'getNeuralCoreSummary'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-18', name: 'Neurochemistry SDK',
    description: 'Full neurochemistry management: 21 transmitters, receptor states, and neuromodulation',
    domain: 'NEURAL', packages: ['PKG-09', 'PKG-43'],
    targetAudience: 'Computational neuroscience researchers',
    capabilities: ['transmitter-regulation', 'receptor-management', 'neuromodulation', 'emotional-field-tracking'],
    apiSurface: ['getNeurotransmitterState', 'getNeurochemicalDiagnostics', 'getEmotionalFieldState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-19', name: 'Brain Region Intelligence SDK',
    description: '96 brain regions: phase synchronization, functional connectivity, and region health scoring',
    domain: 'NEURAL', packages: ['PKG-10', 'PKG-45'],
    targetAudience: 'Brain-computer interface developers',
    capabilities: ['region-monitoring', 'functional-connectivity', 'phase-synchronization', 'visual-processing'],
    apiSurface: ['getBrainRegionStates', 'getVisualSystemState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-20', name: 'Behavioral Intelligence SDK',
    description: 'Behavioral substrate: action selection, behavioral repertoire, and drive state management',
    domain: 'NEURAL', packages: ['PKG-44'],
    targetAudience: 'Robotics and autonomous systems engineers',
    capabilities: ['action-selection', 'behavior-management', 'drive-regulation', 'repertoire-building'],
    apiSurface: ['getBehavioralSubstrateState', 'getNeurotransmitterState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-21', name: 'Animal Cognition SDK',
    description: 'Bio-inspired cognition: crow, octopus, elephant, bee, dolphin intelligence integration',
    domain: 'NEURAL', packages: ['PKG-46', 'PKG-10'],
    targetAudience: 'Bio-inspired AI researchers',
    capabilities: ['species-cognition', 'multi-species-fusion', 'bio-inspiration', 'cognition-blending'],
    apiSurface: ['getAnimalBrainState', 'getAnimalEngines'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-22', name: 'Emotion Engine SDK',
    description: 'Emotional intelligence: valence-arousal-dominance, emotional coherence, and affect management',
    domain: 'NEURAL', packages: ['PKG-43'],
    targetAudience: 'Affective computing developers',
    capabilities: ['emotion-tracking', 'valence-management', 'arousal-regulation', 'affect-modeling'],
    apiSurface: ['getEmotionalFieldState', 'getNeurochemicalState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM SDKs (23-28)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-23', name: 'Quantum Heartbeat SDK',
    description: 'Quantum heartbeat: phase coherence, cardiac coupling, Fibonacci beats, and quantum state',
    domain: 'QUANTUM', packages: ['PKG-11', 'PKG-50'],
    targetAudience: 'Quantum computing researchers',
    capabilities: ['quantum-phase', 'cardiac-coupling', 'fibonacci-sequencing', 'heart-brain-sync'],
    apiSurface: ['getQuantumHeartbeatState', 'getCardioCerebralState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-24', name: 'Quantum Shell Operator SDK',
    description: 'Shell quantum operators: eigenstates, shell coherence, entanglement, and operator evolution',
    domain: 'QUANTUM', packages: ['PKG-12', 'PKG-47'],
    targetAudience: 'Quantum algorithm developers',
    capabilities: ['eigenstate-management', 'shell-coherence', 'entanglement-coupling', 'gate-operations'],
    apiSurface: ['getQuantumOperatorStates', 'getQuantumOps'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-25', name: 'PARALLAX Decision SDK',
    description: 'Parallel universe decision engine: path integrals, decision fusion, and confidence mapping',
    domain: 'QUANTUM', packages: ['PKG-48'],
    targetAudience: 'Decision science engineers',
    capabilities: ['parallel-sampling', 'path-integration', 'decision-fusion', 'confidence-landscape'],
    apiSurface: ['getPARALLAXDecisionEngineState', 'getQuantumDecisionSocialSummary'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-26', name: 'ENTANGLA Social Binding SDK',
    description: 'Quantum social binding: entanglement networks, trust topologies, and quantum voting',
    domain: 'QUANTUM', packages: ['PKG-49'],
    targetAudience: 'Social network and trust system developers',
    capabilities: ['entanglement-networking', 'trust-topology', 'quantum-voting', 'social-coherence'],
    apiSurface: ['getENTANGLASocialBindingState', 'getCouncilQuantumVotingState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-27', name: 'Cardio-Neural Bridge SDK',
    description: 'Heart-brain integration: HRV neural drive, vagal tone, and cardio-neural conversion',
    domain: 'QUANTUM', packages: ['PKG-50'],
    targetAudience: 'Health tech and biofeedback developers',
    capabilities: ['heart-brain-sync', 'hrv-analysis', 'vagal-monitoring', 'cardio-conversion'],
    apiSurface: ['getCardioCerebralState', 'getCardioNeuralConversionOrganState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-28', name: 'Quantum Full Stack SDK',
    description: 'Complete quantum stack: heartbeat, operators, PARALLAX, ENTANGLA, and cardio-neural',
    domain: 'QUANTUM', packages: ['PKG-11', 'PKG-12', 'PKG-48', 'PKG-49', 'PKG-50'],
    targetAudience: 'Full-stack quantum application developers',
    capabilities: ['full-quantum', 'multi-system', 'quantum-social', 'cardio-quantum'],
    apiSurface: ['getQuantumHeartbeatState', 'getQuantumOperatorStates', 'getPARALLAXDecisionEngineState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ECONOMIC SDKs (29-33)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-29', name: 'FORMA Economics SDK',
    description: 'FORMA token economics: value routing, compound growth, ECAN flow, and yield optimization',
    domain: 'ECONOMIC', packages: ['PKG-13', 'PKG-53'],
    targetAudience: 'DeFi and tokenomics developers',
    capabilities: ['value-routing', 'compound-growth', 'ecan-flow', 'yield-optimization'],
    apiSurface: ['getEconomicState', 'getEconomicSystemState', 'getTokenBalances'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-30', name: 'Token Organism SDK',
    description: 'Multi-dimensional token field: 21 scale dimensions, 36 use dimensions, PHI resonance',
    domain: 'ECONOMIC', packages: ['PKG-14', 'PKG-51'],
    targetAudience: 'Token engineers and economic designers',
    capabilities: ['dimensional-tokens', 'scale-coherence', 'use-optimization', 'phi-coupling'],
    apiSurface: ['getTokenOrganismStats', 'getTokenPhiNodes', 'getTokenScaleCoherence'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-31', name: 'Token Analytics SDK',
    description: 'Token dimensional analytics: utilization tracking, flow analysis, and balance management',
    domain: 'ECONOMIC', packages: ['PKG-52', 'PKG-53'],
    targetAudience: 'Financial analysts and token portfolio managers',
    capabilities: ['utilization-tracking', 'flow-analysis', 'balance-management', 'velocity-tracking'],
    apiSurface: ['getTokenUseUtilization', 'getTokenBalances'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-32', name: 'Treasury Management SDK',
    description: 'Full treasury operations: balances, mint/burn control, velocity metrics, and compound growth',
    domain: 'ECONOMIC', packages: ['PKG-53', 'PKG-54'],
    targetAudience: 'Treasury managers and CFOs',
    capabilities: ['balance-tracking', 'mint-burn-control', 'velocity-monitoring', 'compound-growth'],
    apiSurface: ['getTokenBalances', 'getEconomicSystemState', 'getArchitectSignalLevel'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-33', name: 'Economic Full Stack SDK',
    description: 'Complete economic stack: FORMA, tokens, treasury, analytics, and architect signal',
    domain: 'ECONOMIC', packages: ['PKG-13', 'PKG-14', 'PKG-51', 'PKG-52', 'PKG-53'],
    targetAudience: 'Economic system architects',
    capabilities: ['full-economics', 'multi-token', 'treasury-management', 'economic-intelligence'],
    apiSurface: ['getEconomicState', 'getTokenOrganismStats', 'getTokenBalances'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SWARM SDKs (34-37)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-34', name: 'Swarm Coherence SDK',
    description: 'Kuramoto swarm coherence: phase synchronization, drift correction, and quantum convergence',
    domain: 'SWARM', packages: ['PKG-15', 'PKG-56'],
    targetAudience: 'Swarm robotics engineers',
    capabilities: ['phase-synchronization', 'drift-correction', 'team-coherence', 'swarm-analytics'],
    apiSurface: ['getSwarmSnapshot', 'getSwarmQMetrics', 'getTeamSnapshot'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-35', name: 'Drone Fleet SDK',
    description: 'Drone fleet management: positions, neurochemistry, sacrifice protocol, and fleet evolution',
    domain: 'SWARM', packages: ['PKG-16', 'PKG-55', 'PKG-57'],
    targetAudience: 'Drone fleet operators',
    capabilities: ['fleet-management', 'neurochemical-broadcast', 'sacrifice-protocol', 'fleet-evolution'],
    apiSurface: ['getSwarmSnapshot', 'getDroneFleetNeurochemProfile', 'getSacrificeEligible'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-36', name: 'Swarm Intelligence SDK',
    description: 'Swarm intelligence observer: OMNIS monitoring, frequency tracking, and module analytics',
    domain: 'SWARM', packages: ['PKG-17', 'PKG-58'],
    targetAudience: 'Swarm intelligence researchers',
    capabilities: ['omnis-monitoring', 'frequency-tracking', 'module-analytics', 'swarm-optimization'],
    apiSurface: ['getExtendedSnapshot', 'getModuleUsageStats'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-37', name: 'Swarm Full Stack SDK',
    description: 'Complete swarm stack: coherence, fleet, intelligence, teams, neurochemistry, and sacrifice',
    domain: 'SWARM', packages: ['PKG-15', 'PKG-16', 'PKG-17', 'PKG-55', 'PKG-56'],
    targetAudience: 'Full-stack swarm system architects',
    capabilities: ['full-swarm', 'multi-fleet', 'swarm-intelligence', 'collective-behavior'],
    apiSurface: ['getSwarmSnapshot', 'getSwarmQMetrics', 'getDroneFleetNeurochemProfile'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // COGNITIVE SDKs (38-41)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-38', name: 'Feedback Cognition SDK',
    description: 'Constant feedback cognition: closure loops, pattern mining, and fabric coherence',
    domain: 'COGNITIVE', packages: ['PKG-18', 'PKG-62'],
    targetAudience: 'Adaptive systems engineers',
    capabilities: ['feedback-closure', 'pattern-mining', 'fabric-weaving', 'attractor-analysis'],
    apiSurface: ['getConstantFeedbackCognitionState', 'getAttractorState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-39', name: 'Predictive Coding SDK',
    description: 'Predictive coding: free energy minimization, prediction error, Friston blankets, and active inference',
    domain: 'COGNITIVE', packages: ['PKG-19', 'PKG-61'],
    targetAudience: 'Predictive AI researchers',
    capabilities: ['prediction-error', 'free-energy', 'active-inference', 'blanket-analysis'],
    apiSurface: ['getPredictionSystemState', 'getFristonState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-40', name: 'Emergence Detection SDK',
    description: 'Emergence detection: novel patterns, phase transitions, symmetry breaking, and creativity',
    domain: 'COGNITIVE', packages: ['PKG-59', 'PKG-20'],
    targetAudience: 'Complexity science researchers',
    capabilities: ['emergence-detection', 'phase-monitoring', 'creativity-scoring', 'novelty-tracking'],
    apiSurface: ['getEmergenceCognitiveOutputs', 'getEmergenceState'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },
  {
    id: 'SDK-41', name: 'Cognitive Full Stack SDK',
    description: 'Complete cognitive stack: feedback, prediction, learning, emergence, attractors, and free energy',
    domain: 'COGNITIVE', packages: ['PKG-18', 'PKG-19', 'PKG-20', 'PKG-59', 'PKG-63'],
    targetAudience: 'Full-stack cognitive architects',
    capabilities: ['full-cognition', 'multi-layer', 'cognitive-health', 'intelligence-scoring'],
    apiSurface: ['getConstantFeedbackCognitionState', 'getPredictionSystemState', 'getLearningSystemState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SENSOR SDKs (42-43)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-42', name: 'Geo Resonance SDK',
    description: 'Geo-resonance field: geomagnetic alignment, Schumann coupling, and environmental sensing',
    domain: 'SENSOR', packages: ['PKG-64', 'PKG-21'],
    targetAudience: 'Environmental sensing developers',
    capabilities: ['geo-resonance', 'schumann-coupling', 'environmental-sensing', 'field-coherence'],
    apiSurface: ['getGeoResonanceProtectionState', 'getEcologicalState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-43', name: 'Organism Health SDK',
    description: 'Organism health monitoring: vital signs, regeneration, drive states, and recovery',
    domain: 'SENSOR', packages: ['PKG-22', 'PKG-65', 'PKG-66'],
    targetAudience: 'Health monitoring system developers',
    capabilities: ['vital-monitoring', 'regeneration-tracking', 'drive-management', 'health-scoring'],
    apiSurface: ['getOrganismHealthReport', 'getRegenerationDetails', 'getDriveStates'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // FREQUENCY SDKs (44-45)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-44', name: 'Frequency Spectrum SDK',
    description: 'Full frequency spectrum: Hz analysis, Kuramoto, Hebbian, entropy, Lyapunov, and circadian',
    domain: 'FREQUENCY', packages: ['PKG-23', 'PKG-70'],
    targetAudience: 'Signal processing and oscillator engineers',
    capabilities: ['spectrum-analysis', 'kuramoto-coupling', 'hebbian-plasticity', 'stability-analysis'],
    apiSurface: ['getHzSpectrumState', 'getKuramotoState', 'getHebbianState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-45', name: 'Chronobiology SDK',
    description: 'Chronobiology engine: circadian rhythm, sleep architecture, heartbeat kernel, and chronotype',
    domain: 'FREQUENCY', packages: ['PKG-24', 'PKG-67'],
    targetAudience: 'Sleep science and chronobiology researchers',
    capabilities: ['circadian-management', 'sleep-architecture', 'heartbeat-control', 'rhythm-coupling'],
    apiSurface: ['getCircadianState', 'getHeartbeatKernelStatus'],
    deploymentTarget: 'npm package', license: 'NOVA Developer',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGNTY SDKs (46-47)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-46', name: 'Sovereign Identity SDK',
    description: 'Sovereign identity: genesis, seal, architect bond, council governance, and agent workforce',
    domain: 'SOVEREIGNTY', packages: ['PKG-25', 'PKG-71', 'PKG-72'],
    targetAudience: 'Sovereign identity and governance developers',
    capabilities: ['identity-management', 'genesis-verification', 'agent-workforce', 'council-governance'],
    apiSurface: ['getSovereigntyState', 'getOrganismState', 'getAgentStates'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
  {
    id: 'SDK-47', name: 'Council Governance SDK',
    description: 'Council governance: Archon, Vector, Lumen voting, quantum consensus, and decision analytics',
    domain: 'SOVEREIGNTY', packages: ['PKG-26', 'PKG-73'],
    targetAudience: 'DAO and governance system developers',
    capabilities: ['council-voting', 'quantum-consensus', 'decision-analytics', 'quorum-management'],
    apiSurface: ['getCoreStates', 'getCouncilStates', 'getDoctrineFingerprint'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRATION SDKs (48)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-48', name: 'Integration Full Stack SDK',
    description: 'Full integration: shells, animal cognition, embodiment, and cross-system organism binding',
    domain: 'INTEGRATION', packages: ['PKG-27', 'PKG-28', 'PKG-76'],
    targetAudience: 'Systems integration architects',
    capabilities: ['shell-integration', 'animal-cognition', 'embodiment', 'organism-binding'],
    apiSurface: ['getShellIntegrationState', 'getAnimalIntelligenceOutputs', 'getIntegrationEmbodimentDetails'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTELLIGENCE SDKs (49)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-49', name: 'AI Workforce SDK',
    description: 'Internal AI workforce: labs, teams, HQ operations, and organism-wide intelligence',
    domain: 'INTELLIGENCE', packages: ['PKG-29', 'PKG-79'],
    targetAudience: 'AI operations and workforce management teams',
    capabilities: ['lab-management', 'team-orchestration', 'hq-operations', 'workforce-intelligence'],
    apiSurface: ['getAutonomousTeamStatus', 'getOrganismTeamsState', 'getInternalAILabsState'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH SDK (50)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'SDK-50', name: 'Sacred Mathematics SDK',
    description: 'Sacred mathematics: unified field theory, certified physics, Fibonacci resonance, and formal proofs',
    domain: 'MATH', packages: ['PKG-30', 'PKG-80'],
    targetAudience: 'Mathematical physics researchers',
    capabilities: ['field-equations', 'physics-certification', 'fibonacci-resonance', 'formal-verification'],
    apiSurface: ['getUnifiedFieldState', 'getCertifiedMathState', 'getCertifiedPhysicsConstants'],
    deploymentTarget: 'ICP canister', license: 'NOVA Sovereign',
  },
];

/** Get SDK by ID */
export function getSDKById(id: string): SovereignSDK | undefined {
  return SOVEREIGN_SDKS.find(s => s.id === id);
}

/** Get SDKs by domain */
export function getSDKsByDomain(domain: string): SovereignSDK[] {
  return SOVEREIGN_SDKS.filter(s => s.domain === domain);
}
