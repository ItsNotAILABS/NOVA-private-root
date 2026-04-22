// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Multimodal Calls Registry
// 40 multimodal API calls organized by organism domain
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
];

/** Get calls for a specific domain */
export function getCallsByDomain(domain: string): MultimodalCall[] {
  return MULTIMODAL_CALLS.filter(c => c.domain === domain);
}

/** Get a call by ID */
export function getCallById(id: string): MultimodalCall | undefined {
  return MULTIMODAL_CALLS.find(c => c.id === id);
}
