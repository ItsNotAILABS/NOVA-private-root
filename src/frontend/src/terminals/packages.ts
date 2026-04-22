// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Multimodal Packages Registry
// 30 multimodal packages — grouped calls forming AI organism models
// Each package is a living AI organism with its own terminal surface
// ═══════════════════════════════════════════════════════════════════════════════

import type { MultimodalPackage } from './types';

export const MULTIMODAL_PACKAGES: MultimodalPackage[] = [

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFENSE DOMAIN — Packages 1-3
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-01', name: 'AEGIS Shield Organism',
    domain: 'DEFENSE',
    description: 'Autonomous defense membrane organism managing shields, threat detection, and active countermeasures',
    calls: ['C-01', 'C-04'],
    aiModel: 'R-MODEL-AEGIS-SHIELD',
    capabilities: ['threat-detection', 'shield-management', 'countermeasure-deployment', 'membrane-integrity'],
    outputFormat: 'defense-posture-report',
  },
  {
    id: 'PKG-02', name: 'War Command Organism',
    domain: 'DEFENSE',
    description: 'Strategic war command organism directing perimeter, reserves, missions, and escalation posture',
    calls: ['C-02', 'C-04'],
    aiModel: 'R-MODEL-WAR-COMMAND',
    capabilities: ['strategic-planning', 'mission-coordination', 'reserve-mobilization', 'escalation-control'],
    outputFormat: 'war-situation-report',
  },
  {
    id: 'PKG-03', name: 'Counterforce Intelligence Organism',
    domain: 'DEFENSE',
    description: 'Active counterforce organism managing scouts, traps, hunters, and intelligence campaigns',
    calls: ['C-03', 'C-04'],
    aiModel: 'R-MODEL-COUNTERFORCE-INTEL',
    capabilities: ['scout-deployment', 'trap-weaving', 'hunt-coordination', 'adversary-profiling'],
    outputFormat: 'counterforce-intelligence-brief',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORY DOMAIN — Packages 4-5
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-04', name: 'Memory Temple Organism',
    domain: 'MEMORY',
    description: 'Memory temple organism managing oral, structural, symbolic, and event memory forms with no-drop continuity',
    calls: ['C-05', 'C-06', 'C-07'],
    aiModel: 'R-MODEL-MEMORY-TEMPLE-STATE',
    capabilities: ['memory-storage', 'consolidation', 'recall', 'lineage-traversal', 'palace-navigation'],
    outputFormat: 'memory-temple-status',
  },
  {
    id: 'PKG-05', name: 'Memory Palace Navigator',
    domain: 'MEMORY',
    description: 'Spatial memory palace navigation organism with coordinate addressing and salience mapping',
    calls: ['C-05', 'C-07'],
    aiModel: 'U-MODEL-MEMORY-NAVIGATION',
    capabilities: ['coordinate-addressing', 'salience-overlay', 'lineage-pathing', 'consolidation-markers'],
    outputFormat: 'palace-navigation-map',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // GOVERNANCE DOMAIN — Packages 6-7
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-06', name: 'Law Enforcement Organism',
    domain: 'GOVERNANCE',
    description: 'Sovereignty law enforcement organism scoring all 60+ laws with drift detection and gate compliance',
    calls: ['C-08', 'C-09'],
    aiModel: 'R-MODEL-GOVERNANCE-HEARTBEAT',
    capabilities: ['law-scoring', 'drift-detection', 'gate-compliance', 'doctrine-verification'],
    outputFormat: 'law-compliance-report',
  },
  {
    id: 'PKG-07', name: 'Security Audit Organism',
    domain: 'GOVERNANCE',
    description: 'Security audit organism enforcing access tiers, exposure policies, and incident logging',
    calls: ['C-10', 'C-08'],
    aiModel: 'R-MODEL-AUDIT-REPLAY',
    capabilities: ['access-enforcement', 'exposure-audit', 'incident-logging', 'replay-evidence'],
    outputFormat: 'security-audit-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // NEURAL DOMAIN — Packages 8-10
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-08', name: 'Neural Core Mesh Organism',
    domain: 'NEURAL',
    description: 'High-dimensional neural core mesh organism managing coherence and cross-region wiring',
    calls: ['C-11', 'C-12'],
    aiModel: 'R-MODEL-NEURAL-CORE-MESH',
    capabilities: ['mesh-coherence', 'region-coupling', 'wiring-optimization', 'binding-management'],
    outputFormat: 'neural-mesh-report',
  },
  {
    id: 'PKG-09', name: 'Neurochemical Crosstalk Organism',
    domain: 'NEURAL',
    description: 'Neurochemical crosstalk organism managing transmitter levels, receptor states, and neuromodulation',
    calls: ['C-13', 'C-14'],
    aiModel: 'R-MODEL-NEUROCHEM-CROSSTALK',
    capabilities: ['neurotransmitter-regulation', 'receptor-management', 'crosstalk-balancing', 'pharmacological-modeling'],
    outputFormat: 'neurochemical-report',
  },
  {
    id: 'PKG-10', name: 'Brain Region Intelligence',
    domain: 'NEURAL',
    description: 'All 96 brain region organism with phase synchronization and functional connectivity',
    calls: ['C-12', 'C-13'],
    aiModel: 'R-MODEL-BRAIN-REGION-INTEL',
    capabilities: ['region-monitoring', 'functional-connectivity', 'phase-sync-analysis', 'region-health-scoring'],
    outputFormat: 'brain-region-atlas',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM DOMAIN — Packages 11-12
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-11', name: 'Quantum Heartbeat Organism',
    domain: 'QUANTUM',
    description: 'Quantum heartbeat organism managing phase coherence, cardiac coupling, and Fibonacci beats',
    calls: ['C-15', 'C-17'],
    aiModel: 'R-MODEL-HEARTBEAT-CORE',
    capabilities: ['quantum-phase-management', 'cardiac-coupling', 'fibonacci-sequencing', 'coherence-sustaining'],
    outputFormat: 'quantum-heartbeat-report',
  },
  {
    id: 'PKG-12', name: 'Quantum Shell Operator Organism',
    domain: 'QUANTUM',
    description: 'Shell quantum operator organism managing eigenstates across Shell 8 through Shell 12',
    calls: ['C-16', 'C-17'],
    aiModel: 'R-MODEL-QUANTUM-SHELL-OPS',
    capabilities: ['eigenstate-management', 'shell-coherence', 'entanglement-coupling', 'operator-evolution'],
    outputFormat: 'quantum-operator-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ECONOMIC DOMAIN — Packages 13-14
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-13', name: 'FORMA Economics Organism',
    domain: 'ECONOMIC',
    description: 'FORMA token economics organism managing value flows, compound engines, and ECAN routing',
    calls: ['C-18', 'C-19'],
    aiModel: 'R-MODEL-FORMA-ECONOMICS',
    capabilities: ['value-routing', 'compound-growth', 'ecan-flow', 'yield-optimization'],
    outputFormat: 'economic-flow-report',
  },
  {
    id: 'PKG-14', name: 'Token Organism Intelligence',
    domain: 'ECONOMIC',
    description: 'Multi-dimensional token organism with 21 scale dimensions and 36 use dimensions',
    calls: ['C-20', 'C-18'],
    aiModel: 'R-MODEL-TOKEN-ORGANISM',
    capabilities: ['dimensional-token-management', 'scale-coherence', 'use-optimization', 'phi-resonance-coupling'],
    outputFormat: 'token-organism-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SWARM DOMAIN — Packages 15-17
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-15', name: 'Swarm Coherence Organism',
    domain: 'SWARM',
    description: 'Kuramoto swarm coherence organism managing phase sync, drift, and quantum convergence',
    calls: ['C-21', 'C-22'],
    aiModel: 'R-MODEL-SWARM-COHERENCE',
    capabilities: ['phase-synchronization', 'drift-correction', 'quantum-convergence', 'coherence-sustaining'],
    outputFormat: 'swarm-coherence-report',
  },
  {
    id: 'PKG-16', name: 'Drone Fleet Commander',
    domain: 'SWARM',
    description: 'Drone fleet command organism managing positions, neurochemistry, sacrifice protocol, and fleet evolution',
    calls: ['C-21', 'C-23'],
    aiModel: 'R-MODEL-DRONE-FLEET',
    capabilities: ['fleet-management', 'position-control', 'sacrifice-protocol', 'neurochemical-broadcast'],
    outputFormat: 'fleet-status-report',
  },
  {
    id: 'PKG-17', name: 'Swarm Intelligence Observer',
    domain: 'SWARM',
    description: 'Extended swarm intelligence observer combining OMNIS, frequency tier, and compliance monitoring',
    calls: ['C-22', 'C-23'],
    aiModel: 'R-MODEL-SWARM-INTEL',
    capabilities: ['omnis-monitoring', 'frequency-tracking', 'compliance-scoring', 'swarm-analytics'],
    outputFormat: 'swarm-intelligence-brief',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // COGNITIVE DOMAIN — Packages 18-20
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-18', name: 'Feedback Cognition Organism',
    domain: 'COGNITIVE',
    description: 'Constant feedback cognition organism managing closure loops, pattern mining, and fabric coherence',
    calls: ['C-24', 'C-26'],
    aiModel: 'R-MODEL-CONSTANT-FEEDBACK',
    capabilities: ['feedback-closure', 'pattern-mining', 'fabric-weaving', 'loop-optimization'],
    outputFormat: 'feedback-cognition-report',
  },
  {
    id: 'PKG-19', name: 'Predictive Coding Organism',
    domain: 'COGNITIVE',
    description: 'Predictive coding organism managing free energy minimization, prediction error, and model updating',
    calls: ['C-25', 'C-24'],
    aiModel: 'R-MODEL-PREDICTIVE-CODING',
    capabilities: ['prediction-error-tracking', 'free-energy-minimization', 'model-updating', 'precision-weighting'],
    outputFormat: 'prediction-system-report',
  },
  {
    id: 'PKG-20', name: 'Learning Foundation Organism',
    domain: 'COGNITIVE',
    description: 'Learning foundation organism with Hebbian plasticity, adaptation tracking, and skill acquisition',
    calls: ['C-26', 'C-25'],
    aiModel: 'R-MODEL-LEARNING-FOUNDATION',
    capabilities: ['hebbian-learning', 'adaptation-tracking', 'skill-acquisition', 'plasticity-management'],
    outputFormat: 'learning-progress-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SENSOR DOMAIN — Packages 21-22
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-21', name: 'World Organism Bridge',
    domain: 'SENSOR',
    description: 'World organism integration bridge managing ecological sensing and environmental coupling',
    calls: ['C-27', 'C-28'],
    aiModel: 'R-MODEL-WORLD-ORGANISM-BRIDGE',
    capabilities: ['ecological-sensing', 'world-integration', 'environmental-coupling', 'field-coherence-monitoring'],
    outputFormat: 'world-organism-report',
  },
  {
    id: 'PKG-22', name: 'Health Monitor Organism',
    domain: 'SENSOR',
    description: 'Organism-wide health monitoring with vital signs, subsystem health, and recovery management',
    calls: ['C-28', 'C-27'],
    aiModel: 'R-MODEL-HEALTH-MONITOR',
    capabilities: ['vital-monitoring', 'subsystem-health', 'anomaly-detection', 'recovery-management'],
    outputFormat: 'health-monitoring-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // FREQUENCY DOMAIN — Packages 23-24
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-23', name: 'PHI Frequency Organism',
    domain: 'FREQUENCY',
    description: 'PHI-scaled frequency organism managing 12 frequency nodes from 0.001Hz to 432Hz',
    calls: ['C-29', 'C-31'],
    aiModel: 'R-MODEL-PHI-FREQUENCY',
    capabilities: ['frequency-management', 'phi-node-coupling', 'band-coherence', 'spectrum-analysis'],
    outputFormat: 'frequency-spectrum-report',
  },
  {
    id: 'PKG-24', name: 'Chronobiology Organism',
    domain: 'FREQUENCY',
    description: 'Chronobiology organism managing circadian rhythm, sleep architecture, and rhythm coupling',
    calls: ['C-30', 'C-31'],
    aiModel: 'R-MODEL-CHRONOBIOLOGY',
    capabilities: ['circadian-management', 'sleep-architecture', 'rhythm-coupling', 'chronotype-optimization'],
    outputFormat: 'chronobiology-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGNTY DOMAIN — Packages 25-26
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-25', name: 'Sovereign Identity Organism',
    domain: 'SOVEREIGNTY',
    description: 'Sovereign identity organism managing genesis state, seal, architect bond, and principal identity',
    calls: ['C-32', 'C-34'],
    aiModel: 'R-MODEL-SOVEREIGN-IDENTITY',
    capabilities: ['identity-management', 'genesis-verification', 'seal-integrity', 'bond-sustaining'],
    outputFormat: 'sovereignty-identity-report',
  },
  {
    id: 'PKG-26', name: 'Core Authority Organism',
    domain: 'SOVEREIGNTY',
    description: 'Core A/B authority organism managing runtime truth, workforce execution, and doctrine parity',
    calls: ['C-33', 'C-34'],
    aiModel: 'R-MODEL-CORE-AUTHORITY',
    capabilities: ['core-a-management', 'core-b-orchestration', 'truth-verification', 'parity-enforcement'],
    outputFormat: 'core-authority-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRATION DOMAIN — Packages 27-28
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-27', name: 'Shell Integration Organism',
    domain: 'INTEGRATION',
    description: 'Multi-shell integration organism managing cross-shell coupling and projection quality',
    calls: ['C-35', 'C-37'],
    aiModel: 'R-MODEL-SHELL-INTEGRATION',
    capabilities: ['shell-coupling', 'projection-management', 'integration-coherence', 'hierarchy-enforcement'],
    outputFormat: 'shell-integration-report',
  },
  {
    id: 'PKG-28', name: 'Animal Intelligence Organism',
    domain: 'INTEGRATION',
    description: 'Bio-inspired animal intelligence organism with crow, octopus, elephant, bee, dolphin, wolf, orca, eagle, shark cognition',
    calls: ['C-36', 'C-35'],
    aiModel: 'R-MODEL-ANIMAL-COGNITION-SWARM',
    capabilities: ['bio-inspired-cognition', 'multi-species-intelligence', 'swarm-contribution', 'cognition-fusion'],
    outputFormat: 'animal-intelligence-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTELLIGENCE DOMAIN — Package 29
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-29', name: 'Internal AI Workforce Organism',
    domain: 'INTELLIGENCE',
    description: 'Internal AI analyst workforce organism managing teams, task orchestration, and output quality',
    calls: ['C-38', 'C-39'],
    aiModel: 'R-MODEL-AUTONOMOUS-ANALYST',
    capabilities: ['team-orchestration', 'task-management', 'output-quality-control', 'workforce-health-monitoring'],
    outputFormat: 'workforce-intelligence-report',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH DOMAIN — Package 30
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'PKG-30', name: 'Sacred Mathematics Organism',
    domain: 'MATH',
    description: 'Sacred mathematics organism managing unified field equations, certified physics, and Fibonacci resonance',
    calls: ['C-40'],
    aiModel: 'R-MODEL-SACRED-MATHEMATICS',
    capabilities: ['field-equation-solving', 'physics-certification', 'fibonacci-resonance', 'unified-field-theory'],
    outputFormat: 'sacred-mathematics-report',
  },
];

/** Get packages for a specific domain */
export function getPackagesByDomain(domain: string): MultimodalPackage[] {
  return MULTIMODAL_PACKAGES.filter(p => p.domain === domain);
}

/** Get a package by ID */
export function getPackageById(id: string): MultimodalPackage | undefined {
  return MULTIMODAL_PACKAGES.find(p => p.id === id);
}
