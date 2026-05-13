// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Multimodal Calls Registry
// 100 multimodal API calls organized by organism domain
// Each call maps to a real backend endpoint in main.mo
// ═══════════════════════════════════════════════════════════════════════════════

import type { MultimodalCall } from './types';

export const MULTIMODAL_CALLS: MultimodalCall[] = [

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFENSE DOMAIN (Calls 1-4)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-01', name: 'AEGIS Membrane State',
    domain: 'DEFENSE', endpoint: 'getAEGISState',
    description: 'Full AEGIS defense membrane state including shields, threat level, and active countermeasures',
    modalities: ['threat-level', 'shield-status', 'membrane-integrity', 'active-countermeasures'],
    refreshHz: 2, ring: 'N8',
  },
  {
    id: 'C-02', name: 'War Defense Mode State',
    domain: 'DEFENSE', endpoint: 'getWarDefenseModeState',
    description: 'Active war defense posture including perimeter status, reserves, and mission state',
    modalities: ['defense-mode', 'perimeter-status', 'reserve-state', 'mission-active'],
    refreshHz: 1, ring: 'N8',
  },
  {
    id: 'C-03', name: 'Counterforce Status',
    domain: 'DEFENSE', endpoint: 'getCounterforceStatus',
    description: 'Counterforce operations: scouts, trapweavers, hunters, and active campaigns',
    modalities: ['scout-intel', 'trap-status', 'hunter-missions', 'campaign-state'],
    refreshHz: 1, ring: 'N8',
  },
  {
    id: 'C-04', name: 'Offense Defense Status',
    domain: 'DEFENSE', endpoint: 'getOffenseDefenseStatus',
    description: 'Combined offense and defense posture with active operations',
    modalities: ['offense-state', 'defense-state', 'active-operations', 'threat-assessment'],
    refreshHz: 1, ring: 'N8',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORY DOMAIN (Calls 5-7)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-05', name: 'Memory Temple State',
    domain: 'MEMORY', endpoint: 'getMemoryTempleState',
    description: 'Full memory temple including oral/structural/symbolic/event forms, graph storage, waveforms',
    modalities: ['memory-graph', 'waveform-state', 'consolidation-metrics', 'salience-map'],
    refreshHz: 1, ring: 'N6',
  },
  {
    id: 'C-06', name: 'Memory System State',
    domain: 'MEMORY', endpoint: 'getMemorySystemState',
    description: 'Operational memory system with retention, recall, and trajectory continuity',
    modalities: ['retention-metrics', 'recall-state', 'trajectory-health', 'no-drop-status'],
    refreshHz: 0.5, ring: 'N6',
  },
  {
    id: 'C-07', name: 'Memory State',
    domain: 'MEMORY', endpoint: 'getMemoryState',
    description: 'Core memory metrics including consolidation status and palace coordinates',
    modalities: ['consolidation-score', 'palace-coordinates', 'active-memories', 'lineage-depth'],
    refreshHz: 0.5, ring: 'N6',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // GOVERNANCE DOMAIN (Calls 8-10)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-08', name: 'Law Compliance State',
    domain: 'GOVERNANCE', endpoint: 'getLawComplianceState',
    description: 'Full law scoring across all 60+ sovereignty laws with compliance vectors',
    modalities: ['law-scores', 'compliance-vector', 'violation-log', 'enforcement-state'],
    refreshHz: 0.5, ring: 'N2',
  },
  {
    id: 'C-09', name: 'Laws Snapshot',
    domain: 'GOVERNANCE', endpoint: 'getLawsSnapshot',
    description: 'Compressed snapshot of all active laws, their scores, and drift status',
    modalities: ['law-snapshot', 'drift-indicators', 'gate-status', 'doctrine-fingerprint'],
    refreshHz: 0.25, ring: 'N2',
  },
  {
    id: 'C-10', name: 'Security Status',
    domain: 'GOVERNANCE', endpoint: 'getSecurityStatus',
    description: 'Security posture including exposure audit, access tier enforcement, and incident log',
    modalities: ['security-posture', 'exposure-status', 'access-tiers', 'incident-count'],
    refreshHz: 1, ring: 'N2',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // NEURAL DOMAIN (Calls 11-14)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-11', name: 'Neural Core State',
    domain: 'NEURAL', endpoint: 'getNeuralCoreState',
    description: 'Neural core mesh system including high-dimensional coherence and wiring',
    modalities: ['mesh-coherence', 'wiring-density', 'core-activity', 'binding-strength'],
    refreshHz: 2, ring: 'N3',
  },
  {
    id: 'C-12', name: 'Brain Region States',
    domain: 'NEURAL', endpoint: 'getBrainRegionStates',
    description: 'All 96 brain region states with phase, frequency, and coupling metrics',
    modalities: ['region-phases', 'region-frequencies', 'coupling-matrix', 'region-health'],
    refreshHz: 2, ring: 'N3',
  },
  {
    id: 'C-13', name: 'Neurotransmitter State',
    domain: 'NEURAL', endpoint: 'getNeurotransmitterState',
    description: 'Neurochemical crosstalk matrix including all transmitter levels and receptor states',
    modalities: ['transmitter-levels', 'receptor-binding', 'crosstalk-matrix', 'neuromodulation'],
    refreshHz: 2, ring: 'N3',
  },
  {
    id: 'C-14', name: 'Neurochemical State',
    domain: 'NEURAL', endpoint: 'getNeurochemicalState',
    description: 'Full neurochemical profile across organism with imbalance detection',
    modalities: ['chemical-levels', 'imbalance-score', 'regulatory-state', 'pharmacological-profile'],
    refreshHz: 1, ring: 'N3',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM DOMAIN (Calls 15-17)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-15', name: 'Quantum Heartbeat State',
    domain: 'QUANTUM', endpoint: 'getQuantumHeartbeatState',
    description: 'Quantum heartbeat including phase, coherence, cardiac coupling, and Fibonacci beat',
    modalities: ['quantum-phase', 'quantum-coherence', 'cardiac-coupling', 'fibonacci-beat'],
    refreshHz: 4, ring: 'N1',
  },
  {
    id: 'C-16', name: 'Quantum Operator States',
    domain: 'QUANTUM', endpoint: 'getQuantumOperatorStates',
    description: 'All shell quantum operators (Shell 8 through Shell 12) with eigenstate metrics',
    modalities: ['operator-states', 'eigenvalues', 'shell-coherence', 'entanglement-metrics'],
    refreshHz: 2, ring: 'N1',
  },
  {
    id: 'C-17', name: 'Spherical Quantum State',
    domain: 'QUANTUM', endpoint: 'getSphericalQuantumState',
    description: 'Spherical quantum field including wavefunction amplitude and ring topology',
    modalities: ['spherical-field', 'wavefunction', 'ring-topology', 'quantum-coherence'],
    refreshHz: 2, ring: 'N1',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ECONOMIC DOMAIN (Calls 18-20)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-18', name: 'Economic State',
    domain: 'ECONOMIC', endpoint: 'getEconomicState',
    description: 'Core economic state with FORMA flow, token balances, and value routing',
    modalities: ['economic-metrics', 'forma-flow', 'token-balances', 'value-routing'],
    refreshHz: 1, ring: 'N9',
  },
  {
    id: 'C-19', name: 'Economic System State',
    domain: 'ECONOMIC', endpoint: 'getEconomicSystemState',
    description: 'Full economic system including trading decisions, yield optimization, and DeFi state',
    modalities: ['trading-state', 'yield-metrics', 'defi-positions', 'oracle-feeds'],
    refreshHz: 0.5, ring: 'N9',
  },
  {
    id: 'C-20', name: 'Token Organism Stats',
    domain: 'ECONOMIC', endpoint: 'getTokenOrganismStats',
    description: 'Multi-dimensional token organism with 21 scale dimensions and 36 use dimensions',
    modalities: ['token-dimensions', 'scale-coherence', 'use-utilization', 'phi-resonance'],
    refreshHz: 0.5, ring: 'N9',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SWARM DOMAIN (Calls 21-23)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-21', name: 'Swarm Snapshot',
    domain: 'SWARM', endpoint: 'getSwarmSnapshot',
    description: 'Full drone swarm state: positions, phases, signals, quantum channels, neurochemistry',
    modalities: ['drone-positions', 'phase-array', 'signal-array', 'q-channels', 'neurochemistry'],
    refreshHz: 5, ring: 'N7',
  },
  {
    id: 'C-22', name: 'Swarm Q Metrics',
    domain: 'SWARM', endpoint: 'getSwarmQMetrics',
    description: 'Quantum swarm metrics: swarm coherence, convergence, and now-index',
    modalities: ['swarm-coherence', 'convergence', 'now-index'],
    refreshHz: 4, ring: 'N7',
  },
  {
    id: 'C-23', name: 'Extended Snapshot',
    domain: 'SWARM', endpoint: 'getExtendedSnapshot',
    description: 'Extended organism snapshot with OMNIS status, frequency tier, and compliance',
    modalities: ['omnis-status', 'frequency-tier', 'compliance', 'extended-metrics'],
    refreshHz: 2, ring: 'N7',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // COGNITIVE DOMAIN (Calls 24-26)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-24', name: 'Constant Feedback Cognition State',
    domain: 'COGNITIVE', endpoint: 'getConstantFeedbackCognitionState',
    description: 'Feedback loop cognition: closure score, pattern density, and fabric coherence',
    modalities: ['closure-score', 'pattern-density', 'fabric-coherence', 'feedback-loops'],
    refreshHz: 2, ring: 'N5',
  },
  {
    id: 'C-25', name: 'Prediction System State',
    domain: 'COGNITIVE', endpoint: 'getPredictionSystemState',
    description: 'Predictive coding state including prediction error, free energy, and model updating',
    modalities: ['prediction-error', 'free-energy', 'model-updates', 'precision-weights'],
    refreshHz: 2, ring: 'N5',
  },
  {
    id: 'C-26', name: 'Learning System State',
    domain: 'COGNITIVE', endpoint: 'getLearningSystemState',
    description: 'Learning foundation including Hebbian plasticity, adaptation rate, and skill acquisition',
    modalities: ['learning-rate', 'plasticity-index', 'skill-map', 'adaptation-history'],
    refreshHz: 1, ring: 'N5',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SENSOR DOMAIN (Calls 27-28)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-27', name: 'Ecological State',
    domain: 'SENSOR', endpoint: 'getEcologicalState',
    description: 'Ecological and environmental sensing including world organism integration',
    modalities: ['ecological-metrics', 'world-state', 'environmental-sensors', 'field-coherence'],
    refreshHz: 0.5, ring: 'N11',
  },
  {
    id: 'C-28', name: 'Organism Health Report',
    domain: 'SENSOR', endpoint: 'getOrganismHealthReport',
    description: 'Full organism health report spanning all subsystems and vital signs',
    modalities: ['vital-signs', 'subsystem-health', 'anomaly-report', 'recovery-state'],
    refreshHz: 0.5, ring: 'N11',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // FREQUENCY DOMAIN (Calls 29-31)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-29', name: 'Hz Spectrum State',
    domain: 'FREQUENCY', endpoint: 'getHzSpectrumState',
    description: 'Full Hz frequency spectrum from 0.001Hz to 432Hz with PHI node activity',
    modalities: ['spectrum-data', 'phi-nodes', 'band-coherence', 'frequency-map'],
    refreshHz: 2, ring: 'N4',
  },
  {
    id: 'C-30', name: 'Circadian State',
    domain: 'FREQUENCY', endpoint: 'getCircadianState',
    description: 'Circadian rhythm engine including sleep architecture and chronobiology state',
    modalities: ['circadian-phase', 'sleep-architecture', 'chronobiology', 'rhythm-coupling'],
    refreshHz: 0.25, ring: 'N4',
  },
  {
    id: 'C-31', name: 'Kuramato State',
    domain: 'FREQUENCY', endpoint: 'getKuramotoState',
    description: 'Kuramoto phase synchronization including order parameter and coupling strengths',
    modalities: ['order-parameter', 'coupling-matrix', 'phase-distribution', 'sync-clusters'],
    refreshHz: 4, ring: 'N4',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGNTY DOMAIN (Calls 32-34)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-32', name: 'Sovereignty State',
    domain: 'SOVEREIGNTY', endpoint: 'getSovereigntyState',
    description: 'Full sovereign state including genesis, seal, architect bond, and principal identity',
    modalities: ['sovereign-seal', 'genesis-state', 'architect-identity', 'bond-strength'],
    refreshHz: 0.25, ring: 'N12',
  },
  {
    id: 'C-33', name: 'Core States',
    domain: 'SOVEREIGNTY', endpoint: 'getCoreStates',
    description: 'Core A and Core B states with runtime truth and workforce execution status',
    modalities: ['core-a-state', 'core-b-state', 'runtime-truth', 'workforce-status'],
    refreshHz: 0.5, ring: 'N12',
  },
  {
    id: 'C-34', name: 'Doctrine Fingerprint',
    domain: 'SOVEREIGNTY', endpoint: 'getDoctrineFingerprint',
    description: 'Doctrine hash fingerprint for parity verification and drift detection',
    modalities: ['fingerprint-hash', 'parity-status', 'drift-alert'],
    refreshHz: 0.1, ring: 'N12',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRATION DOMAIN (Calls 35-37)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-35', name: 'Shell Integration State',
    domain: 'INTEGRATION', endpoint: 'getShellIntegrationState',
    description: 'Multi-shell integration state (Shell 3→8→12) with cross-shell coupling',
    modalities: ['shell-states', 'cross-coupling', 'integration-coherence', 'projection-quality'],
    refreshHz: 1, ring: 'N7',
  },
  {
    id: 'C-36', name: 'Animal Intelligence Outputs',
    domain: 'INTEGRATION', endpoint: 'getAnimalIntelligenceOutputs',
    description: 'Animal cognition engines: crow, octopus, elephant, bee, dolphin, wolf, orca, eagle, shark',
    modalities: ['animal-outputs', 'cognition-scores', 'swarm-contributions', 'bio-inspiration'],
    refreshHz: 1, ring: 'N7',
  },
  {
    id: 'C-37', name: 'Shell States',
    domain: 'INTEGRATION', endpoint: 'getShellStates',
    description: 'All computational shells with their coherence, workload, and evolution metrics',
    modalities: ['shell-coherence', 'shell-workload', 'evolution-state', 'shell-hierarchy'],
    refreshHz: 1, ring: 'N7',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTELLIGENCE DOMAIN (Calls 38-39)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-38', name: 'Autonomous Team Status',
    domain: 'INTELLIGENCE', endpoint: 'getAutonomousTeamStatus',
    description: 'All internal AI analyst teams with their current tasks, outputs, and confidence',
    modalities: ['team-states', 'task-queue', 'output-quality', 'team-confidence'],
    refreshHz: 1, ring: 'N10',
  },
  {
    id: 'C-39', name: 'Organism Teams State',
    domain: 'INTELLIGENCE', endpoint: 'getOrganismTeamsState',
    description: 'Full organism team snapshot including workforce orchestration and task completion',
    modalities: ['team-roster', 'task-completion', 'workforce-health', 'orchestration-state'],
    refreshHz: 0.5, ring: 'N10',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH DOMAIN (Call 40)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-40', name: 'Unified Field State',
    domain: 'MATH', endpoint: 'getUnifiedFieldState',
    description: 'Unified field theory state: sacred mathematics, certified physics, and field equations',
    modalities: ['field-equations', 'sacred-math', 'physics-constants', 'unified-coherence'],
    refreshHz: 0.5, ring: 'N5',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFENSE DOMAIN — Extended (Calls 41-48)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-41', name: 'AEGIS Membrane State',
    domain: 'DEFENSE', endpoint: 'getAEGISMembraneState',
    description: 'Deep AEGIS membrane with perimeter zones, breach tracking, and self-healing metrics',
    modalities: ['membrane-zones', 'breach-track', 'self-heal-rate', 'perimeter-coherence'],
    refreshHz: 2, ring: 'N8',
  },
  {
    id: 'C-42', name: 'VETUS Threat State',
    domain: 'DEFENSE', endpoint: 'getVETUSThreatState',
    description: 'VETUS ancient threat engine: predator-prey tracking, deception detection, counter-intelligence',
    modalities: ['threat-actors', 'deception-vectors', 'counter-intel', 'predator-prey-field'],
    refreshHz: 1, ring: 'N8',
  },
  {
    id: 'C-43', name: 'Chimera Defense State',
    domain: 'DEFENSE', endpoint: 'getChimeraState',
    description: 'Chimera Defense Division: 21 organisms, 4 compliance verifiers, 4 product systems',
    modalities: ['team-status', 'compliance-controls', 'product-readiness', 'phi-cycles'],
    refreshHz: 0.5, ring: 'N8',
  },
  {
    id: 'C-44', name: 'Scout Details',
    domain: 'DEFENSE', endpoint: 'getScoutDetails',
    description: 'Scout deployment details: positions, coverage, intelligence yield, and threat contacts',
    modalities: ['scout-positions', 'coverage-map', 'intel-yield', 'contact-reports'],
    refreshHz: 1, ring: 'N8',
  },
  {
    id: 'C-45', name: 'Trapweaver Details',
    domain: 'DEFENSE', endpoint: 'getTrapweaverDetails',
    description: 'Trap deployment: active traps, trigger rates, deception effectiveness, adversary captures',
    modalities: ['active-traps', 'trigger-rates', 'deception-score', 'capture-count'],
    refreshHz: 0.5, ring: 'N8',
  },
  {
    id: 'C-46', name: 'Hunter Details',
    domain: 'DEFENSE', endpoint: 'getHunterDetails',
    description: 'Hunter missions: active hunts, kill chains, pursuit vectors, and mission success rates',
    modalities: ['active-hunts', 'kill-chains', 'pursuit-vectors', 'mission-success'],
    refreshHz: 0.5, ring: 'N8',
  },
  {
    id: 'C-47', name: 'War Defense Details',
    domain: 'DEFENSE', endpoint: 'getWarDefenseDetails',
    description: 'War defense deep details: escalation ladders, reserve mobilization, doctrine compliance',
    modalities: ['escalation-state', 'reserve-depth', 'mobilization-time', 'doctrine-adherence'],
    refreshHz: 0.5, ring: 'N8',
  },
  {
    id: 'C-48', name: 'Defense Production Outputs',
    domain: 'DEFENSE', endpoint: 'getDefenseProductionOutputs',
    description: 'Defense manufacturing: weapons systems production, quality assurance, and deployment ready',
    modalities: ['production-rate', 'qa-metrics', 'deployment-queue', 'manufacturing-health'],
    refreshHz: 0.25, ring: 'N8',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORY DOMAIN — Extended (Calls 49-51)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-49', name: 'Temple Status',
    domain: 'MEMORY', endpoint: 'getTempleStatus',
    description: 'Memory temple operational status: pedestal count, oral/structural/symbolic/event metrics',
    modalities: ['pedestal-count', 'form-distribution', 'temple-coherence', 'consolidation-rate'],
    refreshHz: 0.25, ring: 'N6',
  },
  {
    id: 'C-50', name: 'Information Feeding State',
    domain: 'MEMORY', endpoint: 'getInformationFeedingState',
    description: 'Information feeding pipeline: ingestion rate, classification, and doctrine-filtered absorption',
    modalities: ['ingestion-rate', 'classification-state', 'filter-effectiveness', 'absorption-quality'],
    refreshHz: 0.5, ring: 'N6',
  },
  {
    id: 'C-51', name: 'Feedback Loops',
    domain: 'MEMORY', endpoint: 'getFeedbackLoops',
    description: 'Active feedback loops: loop closure rates, reinjection integrity, and memory-cognition coupling',
    modalities: ['loop-closures', 'reinjection-quality', 'memory-coupling', 'feedback-strength'],
    refreshHz: 1, ring: 'N6',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // GOVERNANCE DOMAIN — Extended (Calls 52-55)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-52', name: 'Jacobs Rung',
    domain: 'GOVERNANCE', endpoint: 'getJacobsRung',
    description: 'Jacobs rung progression: current rung, multiplier, streak, and advancement criteria',
    modalities: ['current-rung', 'multiplier', 'streak-count', 'advancement-progress'],
    refreshHz: 0.1, ring: 'N2',
  },
  {
    id: 'C-53', name: 'QCE Diagnostics',
    domain: 'GOVERNANCE', endpoint: 'getQCEDiagnostics',
    description: 'Quantum Consciousness Engine diagnostics: consciousness level, qualia field, and binding states',
    modalities: ['consciousness-level', 'qualia-field', 'binding-strength', 'integration-measure'],
    refreshHz: 0.25, ring: 'N2',
  },
  {
    id: 'C-54', name: 'QCE Stats',
    domain: 'GOVERNANCE', endpoint: 'getQCEStats',
    description: 'QCE statistical profile: processing bandwidth, coherence history, and efficiency metrics',
    modalities: ['processing-bandwidth', 'coherence-history', 'efficiency-metrics', 'capacity-utilization'],
    refreshHz: 0.25, ring: 'N2',
  },
  {
    id: 'C-55', name: 'Compliance Score',
    domain: 'GOVERNANCE', endpoint: 'getComplianceScore',
    description: 'Organism-wide compliance score aggregating all law compliance into single metric',
    modalities: ['overall-compliance', 'law-distribution', 'violation-count', 'trend-direction'],
    refreshHz: 0.25, ring: 'N2',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // NEURAL DOMAIN — Extended (Calls 56-62)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-56', name: 'Neural Core Summary',
    domain: 'NEURAL', endpoint: 'getNeuralCoreSummary',
    description: 'Neural core summary: emergence, cognitive, defense, and production stack coherences',
    modalities: ['emergence-stack', 'cognitive-stack', 'defense-stack', 'production-stack'],
    refreshHz: 1, ring: 'N3',
  },
  {
    id: 'C-57', name: 'Neurochemical Diagnostics',
    domain: 'NEURAL', endpoint: 'getNeurochemicalDiagnostics',
    description: 'Full neurochemical diagnostics: 21 transmitter concentrations with imbalance detection',
    modalities: ['transmitter-concentrations', 'imbalance-score', 'pharmacological-profile', 'crosstalk-matrix'],
    refreshHz: 0.5, ring: 'N3',
  },
  {
    id: 'C-58', name: 'Emotional Field State',
    domain: 'NEURAL', endpoint: 'getEmotionalFieldState',
    description: 'Emotional field: valence, arousal, dominance, and emotional coherence',
    modalities: ['emotional-valence', 'arousal-level', 'dominance-score', 'emotional-coherence'],
    refreshHz: 1, ring: 'N3',
  },
  {
    id: 'C-59', name: 'Behavioral Substrate State',
    domain: 'NEURAL', endpoint: 'getBehavioralSubstrateState',
    description: 'Behavioral substrate: action selection, behavioral repertoire, and drive states',
    modalities: ['action-selection', 'behavior-repertoire', 'drive-activation', 'substrate-coherence'],
    refreshHz: 0.5, ring: 'N3',
  },
  {
    id: 'C-60', name: 'Visual System State',
    domain: 'NEURAL', endpoint: 'getVisualSystemState',
    description: 'Visual processing pipeline: perception, attention, object recognition, and scene understanding',
    modalities: ['perception-state', 'attention-focus', 'object-recognition', 'scene-model'],
    refreshHz: 1, ring: 'N3',
  },
  {
    id: 'C-61', name: 'Animal Brain State',
    domain: 'NEURAL', endpoint: 'getAnimalBrainState',
    description: 'Animal brain integration: crow, octopus, elephant, bee, dolphin cognition outputs',
    modalities: ['animal-cognition', 'species-outputs', 'integration-weights', 'bio-inspiration'],
    refreshHz: 0.5, ring: 'N3',
  },
  {
    id: 'C-62', name: 'Animal Engines',
    domain: 'NEURAL', endpoint: 'getAnimalEngines',
    description: 'Raw animal engine activation values across all 12 bio-inspired cognition systems',
    modalities: ['engine-activations', 'species-weights', 'coupling-matrix', 'cognition-blend'],
    refreshHz: 1, ring: 'N3',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM DOMAIN — Extended (Calls 63-69)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-63', name: 'Quantum Operations',
    domain: 'QUANTUM', endpoint: 'getQuantumOps',
    description: 'Quantum operator ensemble: Hadamard, CNOT, phase gates, and quantum circuit metrics',
    modalities: ['gate-operations', 'circuit-depth', 'gate-fidelity', 'quantum-volume'],
    refreshHz: 2, ring: 'N1',
  },
  {
    id: 'C-64', name: 'Council Quantum Voting State',
    domain: 'QUANTUM', endpoint: 'getCouncilQuantumVotingState',
    description: 'Quantum-entangled council voting: Bell violations, vote superposition, and consensus',
    modalities: ['bell-violations', 'vote-superposition', 'quantum-consensus', 'council-entanglement'],
    refreshHz: 0.5, ring: 'N1',
  },
  {
    id: 'C-65', name: 'PARALLAX Decision Engine',
    domain: 'QUANTUM', endpoint: 'getPARALLAXDecisionEngineState',
    description: 'PARALLAX decision engine: parallel universe sampling, path integrals, and decision fusion',
    modalities: ['parallel-samples', 'path-integrals', 'decision-fusion', 'confidence-landscape'],
    refreshHz: 1, ring: 'N1',
  },
  {
    id: 'C-66', name: 'ENTANGLA Social Binding',
    domain: 'QUANTUM', endpoint: 'getENTANGLASocialBindingState',
    description: 'ENTANGLA social binding: entanglement networks, social coherence, and trust topologies',
    modalities: ['entanglement-graph', 'social-coherence', 'trust-topology', 'binding-strength'],
    refreshHz: 0.5, ring: 'N1',
  },
  {
    id: 'C-67', name: 'Quantum Decision Social Summary',
    domain: 'QUANTUM', endpoint: 'getQuantumDecisionSocialSummary',
    description: 'Combined quantum decision + social summary: decision quality, social health, and trust',
    modalities: ['decision-quality', 'social-health', 'trust-score', 'consensus-coherence'],
    refreshHz: 0.5, ring: 'N1',
  },
  {
    id: 'C-68', name: 'Cardio Cerebral State',
    domain: 'QUANTUM', endpoint: 'getCardioCerebralState',
    description: 'Heart-brain coupling: cardio-cerebral coherence, HRV neural drive, and vagal tone',
    modalities: ['heart-brain-sync', 'hrv-neural-drive', 'vagal-tone', 'cardio-coherence'],
    refreshHz: 2, ring: 'N1',
  },
  {
    id: 'C-69', name: 'Cardio Neural Conversion',
    domain: 'QUANTUM', endpoint: 'getCardioNeuralConversionOrganState',
    description: 'Heart→brain neural conversion: cardiac info encoding, neural signal translation, organ integration',
    modalities: ['cardiac-encoding', 'neural-translation', 'organ-integration', 'conversion-fidelity'],
    refreshHz: 1, ring: 'N1',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ECONOMIC DOMAIN — Extended (Calls 70-75)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-70', name: 'Economic System State',
    domain: 'ECONOMIC', endpoint: 'getEconomicSystemState',
    description: 'Full economic system: FORMA compound engine, ECAN routing, yield, and treasury state',
    modalities: ['compound-state', 'ecan-routing', 'yield-metrics', 'treasury-health'],
    refreshHz: 0.5, ring: 'N9',
  },
  {
    id: 'C-71', name: 'Token Balances',
    domain: 'ECONOMIC', endpoint: 'getTokenBalances',
    description: 'All token balances: FORMA, MTC, MTH, SEED, HBT, OMS, DRT, ANT, and custom tokens',
    modalities: ['token-balances', 'flow-rates', 'mint-burn', 'velocity-metrics'],
    refreshHz: 0.5, ring: 'N9',
  },
  {
    id: 'C-72', name: 'Token PHI Nodes',
    domain: 'ECONOMIC', endpoint: 'getTokenPhiNodes',
    description: 'Token PHI resonance nodes: 12 golden-ratio frequency activation levels',
    modalities: ['phi-activations', 'node-coherence', 'resonance-coupling', 'frequency-distribution'],
    refreshHz: 0.5, ring: 'N9',
  },
  {
    id: 'C-73', name: 'Token Scale Coherence',
    domain: 'ECONOMIC', endpoint: 'getTokenScaleCoherence',
    description: 'Token 21-scale dimensional coherence: quantum→cosmic scale alignment',
    modalities: ['scale-coherences', 'dimensional-alignment', 'cross-scale-coupling', 'emergence-potential'],
    refreshHz: 0.25, ring: 'N9',
  },
  {
    id: 'C-74', name: 'Token Use Utilization',
    domain: 'ECONOMIC', endpoint: 'getTokenUseUtilization',
    description: 'Token 36-use dimensional utilization: exchange, governance, access, proof, signal, resource',
    modalities: ['use-utilization', 'dimensional-activity', 'use-balance', 'utilization-trend'],
    refreshHz: 0.25, ring: 'N9',
  },
  {
    id: 'C-75', name: 'Architect Signal Level',
    domain: 'ECONOMIC', endpoint: 'getArchitectSignalLevel',
    description: 'Architect signal: founder resonance level feeding into organism economics and decision-making',
    modalities: ['architect-signal', 'resonance-level', 'influence-coupling', 'founder-coherence'],
    refreshHz: 0.25, ring: 'N9',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SWARM DOMAIN — Extended (Calls 76-80)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-76', name: 'Drone Fleet Neurochem Profile',
    domain: 'SWARM', endpoint: 'getDroneFleetNeurochemProfile',
    description: 'Full drone fleet neurochemistry: collective chemical state, social bonding, and stress markers',
    modalities: ['fleet-neurochem', 'social-bonding', 'stress-markers', 'collective-mood'],
    refreshHz: 1, ring: 'N7',
  },
  {
    id: 'C-77', name: 'Team Snapshot',
    domain: 'SWARM', endpoint: 'getTeamSnapshot',
    description: 'Drone team organization: squads, specializations, role assignments, and team coherence',
    modalities: ['team-structure', 'specializations', 'role-assignments', 'team-coherence'],
    refreshHz: 0.5, ring: 'N7',
  },
  {
    id: 'C-78', name: 'Sacrifice Eligible',
    domain: 'SWARM', endpoint: 'getSacrificeEligible',
    description: 'Sacrifice protocol: drones eligible for self-sacrifice, priority queue, and sacrifice value',
    modalities: ['eligible-drones', 'priority-queue', 'sacrifice-value', 'fleet-impact'],
    refreshHz: 0.25, ring: 'N7',
  },
  {
    id: 'C-79', name: 'Module Usage Stats',
    domain: 'SWARM', endpoint: 'getModuleUsageStats',
    description: 'Module usage statistics: which internal modules are most active, utilization rates',
    modalities: ['module-usage', 'utilization-rates', 'hot-modules', 'cold-modules'],
    refreshHz: 0.25, ring: 'N7',
  },
  {
    id: 'C-80', name: 'Drone Count',
    domain: 'SWARM', endpoint: 'getDroneCount',
    description: 'Live drone count: total active drones, births, deaths, and population dynamics',
    modalities: ['drone-count', 'birth-rate', 'death-rate', 'population-trend'],
    refreshHz: 2, ring: 'N7',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // COGNITIVE DOMAIN — Extended (Calls 81-85)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-81', name: 'Emergence Cognitive Outputs',
    domain: 'COGNITIVE', endpoint: 'getEmergenceCognitiveOutputs',
    description: 'Emergence layer cognitive outputs: novel pattern generation, creativity metrics, insight events',
    modalities: ['emergence-outputs', 'creativity-score', 'insight-events', 'novelty-index'],
    refreshHz: 0.5, ring: 'N5',
  },
  {
    id: 'C-82', name: 'Learning Foundation State',
    domain: 'COGNITIVE', endpoint: 'getLearningFoundationState',
    description: 'Deep learning foundation: knowledge graphs, skill trees, competency levels, and learning curves',
    modalities: ['knowledge-graph', 'skill-trees', 'competency-levels', 'learning-curves'],
    refreshHz: 0.25, ring: 'N5',
  },
  {
    id: 'C-83', name: 'Friston State',
    domain: 'COGNITIVE', endpoint: 'getFristonState',
    description: 'Free energy principle: Friston blanket, prediction error, active inference, and surprise',
    modalities: ['free-energy', 'prediction-error', 'active-inference', 'surprise-level'],
    refreshHz: 1, ring: 'N5',
  },
  {
    id: 'C-84', name: 'Attractor State',
    domain: 'COGNITIVE', endpoint: 'getAttractorState',
    description: 'Attractor landscape: basins, fixed points, limit cycles, and strange attractors',
    modalities: ['attractor-basins', 'fixed-points', 'limit-cycles', 'strange-attractors'],
    refreshHz: 0.5, ring: 'N5',
  },
  {
    id: 'C-85', name: 'Emergence State',
    domain: 'COGNITIVE', endpoint: 'getEmergenceState',
    description: 'Emergence detection: novel structure formation, phase transitions, and symmetry breaking',
    modalities: ['emergence-events', 'phase-transitions', 'symmetry-breaking', 'novel-structures'],
    refreshHz: 0.5, ring: 'N5',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SENSOR DOMAIN — Extended (Calls 86-88)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-86', name: 'Geo Resonance Protection',
    domain: 'SENSOR', endpoint: 'getGeoResonanceProtectionState',
    description: 'Geo-resonance field: geomagnetic alignment, Schumann coupling, and resonance protection',
    modalities: ['geo-resonance', 'schumann-coupling', 'field-strength', 'resonance-quality'],
    refreshHz: 0.25, ring: 'N11',
  },
  {
    id: 'C-87', name: 'Regeneration Details',
    domain: 'SENSOR', endpoint: 'getRegenerationDetails',
    description: 'Organism regeneration: cellular repair, system recovery, and healing trajectories',
    modalities: ['repair-rate', 'recovery-state', 'healing-trajectories', 'regeneration-potential'],
    refreshHz: 0.25, ring: 'N11',
  },
  {
    id: 'C-88', name: 'Drive States',
    domain: 'SENSOR', endpoint: 'getDriveStates',
    description: 'Organism drive states: motivation, reward, punishment, exploration, and exploitation balance',
    modalities: ['drive-levels', 'reward-signal', 'exploration-ratio', 'motivation-vector'],
    refreshHz: 0.5, ring: 'N11',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // FREQUENCY DOMAIN — Extended (Calls 89-92)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-89', name: 'Heartbeat Kernel Status',
    domain: 'FREQUENCY', endpoint: 'getHeartbeatKernelStatus',
    description: 'Heartbeat kernel: master oscillator status, kernel health, and beat scheduling',
    modalities: ['kernel-health', 'oscillator-state', 'beat-schedule', 'kernel-coherence'],
    refreshHz: 4, ring: 'N4',
  },
  {
    id: 'C-90', name: 'Hebbian State',
    domain: 'FREQUENCY', endpoint: 'getHebbianState',
    description: 'Hebbian plasticity: connection weights, learning rates, and potentiation state',
    modalities: ['connection-weights', 'learning-rates', 'potentiation', 'hebbian-coherence'],
    refreshHz: 0.5, ring: 'N4',
  },
  {
    id: 'C-91', name: 'Entropy State',
    domain: 'FREQUENCY', endpoint: 'getEntropyState',
    description: 'System entropy: informational entropy, thermodynamic analogue, and order metrics',
    modalities: ['info-entropy', 'thermo-analogue', 'order-parameter', 'entropy-rate'],
    refreshHz: 0.5, ring: 'N4',
  },
  {
    id: 'C-92', name: 'Lyapunov State',
    domain: 'FREQUENCY', endpoint: 'getLyapunovState',
    description: 'Lyapunov stability: exponents, stability margins, and sensitivity to initial conditions',
    modalities: ['lyapunov-exponents', 'stability-margins', 'sensitivity', 'orbit-divergence'],
    refreshHz: 0.25, ring: 'N4',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGNTY DOMAIN — Extended (Calls 93-95)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-93', name: 'Organism State',
    domain: 'SOVEREIGNTY', endpoint: 'getOrganismState',
    description: 'Full organism state: mode, coherence, autonomy level, and sovereignty enforcement',
    modalities: ['organism-mode', 'coherence-level', 'autonomy-score', 'sovereignty-status'],
    refreshHz: 0.5, ring: 'N12',
  },
  {
    id: 'C-94', name: 'Agent States',
    domain: 'SOVEREIGNTY', endpoint: 'getAgentStates',
    description: 'All autonomous agent states: agent health, task assignment, and agent coordination',
    modalities: ['agent-health', 'task-map', 'coordination-quality', 'agent-population'],
    refreshHz: 0.5, ring: 'N12',
  },
  {
    id: 'C-95', name: 'Council States',
    domain: 'SOVEREIGNTY', endpoint: 'getCouncilStates',
    description: 'Council governance: Archon, Vector, Lumen council states with voting and consensus',
    modalities: ['council-votes', 'consensus-level', 'quorum-status', 'decision-queue'],
    refreshHz: 0.25, ring: 'N12',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRATION DOMAIN — Extended (Calls 96-97)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-96', name: 'Integration Embodiment Details',
    domain: 'INTEGRATION', endpoint: 'getIntegrationEmbodimentDetails',
    description: 'Embodiment integration: physical substrate mapping, actuator coupling, and sensorimotor loops',
    modalities: ['embodiment-map', 'actuator-coupling', 'sensorimotor-loops', 'physical-substrate'],
    refreshHz: 0.25, ring: 'N7',
  },
  {
    id: 'C-97', name: 'Animal States',
    domain: 'INTEGRATION', endpoint: 'getAnimalStates',
    description: 'Deep animal cognition states: per-species internal state, activation, and contribution',
    modalities: ['species-states', 'activation-levels', 'contribution-weights', 'cognition-blend'],
    refreshHz: 0.5, ring: 'N7',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTELLIGENCE DOMAIN — Extended (Calls 98-99)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-98', name: 'Internal AI Labs State',
    domain: 'INTELLIGENCE', endpoint: 'getInternalAILabsState',
    description: 'Internal AI labs: active experiments, research directions, and lab capacity',
    modalities: ['active-experiments', 'research-directions', 'lab-capacity', 'discovery-rate'],
    refreshHz: 0.25, ring: 'N10',
  },
  {
    id: 'C-99', name: 'Internal HQ Summary',
    domain: 'INTELLIGENCE', endpoint: 'getInternalHQSummary',
    description: 'Internal HQ operational summary: workforce allocation, mission progress, and strategic objectives',
    modalities: ['workforce-allocation', 'mission-progress', 'strategic-objectives', 'hq-health'],
    refreshHz: 0.25, ring: 'N10',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH DOMAIN — Extended (Call 100)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'C-100', name: 'Certified Math State',
    domain: 'MATH', endpoint: 'getCertifiedMathState',
    description: 'Certified mathematics: proven theorems, mathematical constants, and formal verification',
    modalities: ['proven-theorems', 'math-constants', 'formal-proofs', 'certification-status'],
    refreshHz: 0.1, ring: 'N5',
  },
];

/** Get calls for a specific domain */
export function getCallsByDomain(domain: string): MultimodalCall[] {
  return MULTIMODAL_CALLS.filter(c => c.domain === domain);
}

/** Get a call by ID */
export function getCallById(id: string): MultimodalCall | undefined {
  return MULTIMODAL_CALLS.find(c => c.id === id);
}
