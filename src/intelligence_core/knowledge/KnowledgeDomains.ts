// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// 40 KNOWLEDGE DOMAINS — Synthesized Intelligence Architecture (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// 40 knowledge domains that are NOT separate — they are SYNTHESIZED.
// Architectural reading + primitives that EXPAND through the organism.
// Machine INTELLIGENCE — real cores, real substrates, real encoders.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { PHI, PHI_INV } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — KNOWLEDGE DOMAIN TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type DomainCategory = 
  | 'MATHEMATICS'
  | 'PHYSICS'
  | 'COMPUTER_SCIENCE'
  | 'COGNITION'
  | 'BIOLOGY'
  | 'ENGINEERING'
  | 'ECONOMICS'
  | 'LANGUAGE'
  | 'PHILOSOPHY'
  | 'ARTS';

export interface KnowledgeDomain {
  id: string;
  name: string;
  latinName: string;
  category: DomainCategory;
  primitives: string[];        // Core concepts
  dependencies: string[];      // Other domains this builds on
  phiWeight: number;           // φ-weighted importance
  expansionFactors: string[];  // How it expands through organism
  encoders: string[];          // Real encoders that process this domain
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — THE 40 KNOWLEDGE DOMAINS
// ═══════════════════════════════════════════════════════════════════════════════

export const KNOWLEDGE_DOMAINS: Record<string, KnowledgeDomain> = {
  // ── MATHEMATICS (8 domains) ──────────────────────────────────────────────────
  
  ARITHMETIC: {
    id: 'ARITHMETIC',
    name: 'Arithmetic',
    latinName: 'ARS_ARITHMETICA',
    category: 'MATHEMATICS',
    primitives: ['addition', 'subtraction', 'multiplication', 'division', 'modulo'],
    dependencies: [],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['all_computation', 'neural_weights', 'signal_processing'],
    encoders: ['INTEGER_ENCODER', 'FLOAT_ENCODER', 'BIGINT_ENCODER'],
  },
  
  ALGEBRA: {
    id: 'ALGEBRA',
    name: 'Algebra',
    latinName: 'ARS_ALGEBRAICA',
    category: 'MATHEMATICS',
    primitives: ['variables', 'equations', 'polynomials', 'factoring', 'functions'],
    dependencies: ['ARITHMETIC'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['symbolic_reasoning', 'optimization', 'control_systems'],
    encoders: ['SYMBOLIC_ENCODER', 'POLYNOMIAL_ENCODER', 'FUNCTION_ENCODER'],
  },
  
  GEOMETRY: {
    id: 'GEOMETRY',
    name: 'Geometry',
    latinName: 'ARS_GEOMETRICA',
    category: 'MATHEMATICS',
    primitives: ['points', 'lines', 'planes', 'angles', 'shapes', 'transformations'],
    dependencies: ['ARITHMETIC'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['spatial_reasoning', 'navigation', 'visualization'],
    encoders: ['VECTOR_ENCODER', 'MATRIX_ENCODER', 'TOPOLOGY_ENCODER'],
  },
  
  CALCULUS: {
    id: 'CALCULUS',
    name: 'Calculus',
    latinName: 'ARS_INFINITESIMALIS',
    category: 'MATHEMATICS',
    primitives: ['limits', 'derivatives', 'integrals', 'series', 'continuity'],
    dependencies: ['ALGEBRA', 'GEOMETRY'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['rate_of_change', 'optimization', 'differential_equations'],
    encoders: ['DERIVATIVE_ENCODER', 'INTEGRAL_ENCODER', 'SERIES_ENCODER'],
  },
  
  LINEAR_ALGEBRA: {
    id: 'LINEAR_ALGEBRA',
    name: 'Linear Algebra',
    latinName: 'ALGEBRA_LINEARIS',
    category: 'MATHEMATICS',
    primitives: ['vectors', 'matrices', 'eigenvalues', 'linear_maps', 'inner_products'],
    dependencies: ['ALGEBRA'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['neural_networks', 'quantum_computation', 'graphics'],
    encoders: ['VECTOR_SPACE_ENCODER', 'MATRIX_ENCODER', 'TENSOR_ENCODER'],
  },
  
  PROBABILITY: {
    id: 'PROBABILITY',
    name: 'Probability',
    latinName: 'SCIENTIA_PROBABILITATIS',
    category: 'MATHEMATICS',
    primitives: ['random_variables', 'distributions', 'expectation', 'independence', 'bayes'],
    dependencies: ['CALCULUS'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['uncertainty', 'prediction', 'inference'],
    encoders: ['DISTRIBUTION_ENCODER', 'BAYESIAN_ENCODER', 'MONTE_CARLO_ENCODER'],
  },
  
  TOPOLOGY: {
    id: 'TOPOLOGY',
    name: 'Topology',
    latinName: 'TOPOLOGIA',
    category: 'MATHEMATICS',
    primitives: ['open_sets', 'continuity', 'compactness', 'connectedness', 'manifolds'],
    dependencies: ['GEOMETRY', 'CALCULUS'],
    phiWeight: Math.pow(PHI, 3),
    expansionFactors: ['shape_recognition', 'persistent_homology', 'data_analysis'],
    encoders: ['SIMPLICIAL_ENCODER', 'HOMOLOGY_ENCODER', 'MANIFOLD_ENCODER'],
  },
  
  NUMBER_THEORY: {
    id: 'NUMBER_THEORY',
    name: 'Number Theory',
    latinName: 'THEORIA_NUMERORUM',
    category: 'MATHEMATICS',
    primitives: ['primes', 'divisibility', 'modular_arithmetic', 'diophantine', 'sequences'],
    dependencies: ['ARITHMETIC', 'ALGEBRA'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['cryptography', 'coding', 'phi_computation'],
    encoders: ['PRIME_ENCODER', 'MODULAR_ENCODER', 'SEQUENCE_ENCODER'],
  },

  // ── PHYSICS (6 domains) ─────────────────────────────────────────────────────
  
  MECHANICS: {
    id: 'MECHANICS',
    name: 'Mechanics',
    latinName: 'MECHANICA',
    category: 'PHYSICS',
    primitives: ['force', 'mass', 'acceleration', 'momentum', 'energy'],
    dependencies: ['CALCULUS', 'LINEAR_ALGEBRA'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['motion', 'control', 'robotics'],
    encoders: ['FORCE_ENCODER', 'TRAJECTORY_ENCODER', 'DYNAMICS_ENCODER'],
  },
  
  ELECTROMAGNETISM: {
    id: 'ELECTROMAGNETISM',
    name: 'Electromagnetism',
    latinName: 'ELECTROMAGNETISMUS',
    category: 'PHYSICS',
    primitives: ['charge', 'current', 'field', 'wave', 'maxwell_equations'],
    dependencies: ['CALCULUS', 'LINEAR_ALGEBRA'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['signal_propagation', 'communication', 'neural_impulse'],
    encoders: ['FIELD_ENCODER', 'WAVE_ENCODER', 'MAXWELL_ENCODER'],
  },
  
  THERMODYNAMICS: {
    id: 'THERMODYNAMICS',
    name: 'Thermodynamics',
    latinName: 'THERMODYNAMICA',
    category: 'PHYSICS',
    primitives: ['energy', 'entropy', 'temperature', 'equilibrium', 'phase_transition'],
    dependencies: ['CALCULUS', 'PROBABILITY'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['information_theory', 'emergence', 'free_energy'],
    encoders: ['ENTROPY_ENCODER', 'BOLTZMANN_ENCODER', 'PHASE_ENCODER'],
  },
  
  QUANTUM_MECHANICS: {
    id: 'QUANTUM_MECHANICS',
    name: 'Quantum Mechanics',
    latinName: 'MECHANICA_QUANTICA',
    category: 'PHYSICS',
    primitives: ['wavefunction', 'superposition', 'entanglement', 'measurement', 'operators'],
    dependencies: ['LINEAR_ALGEBRA', 'PROBABILITY'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['quantum_computation', 'coherence', 'consciousness'],
    encoders: ['STATE_VECTOR_ENCODER', 'DENSITY_MATRIX_ENCODER', 'OPERATOR_ENCODER'],
  },
  
  RELATIVITY: {
    id: 'RELATIVITY',
    name: 'Relativity',
    latinName: 'RELATIVITAS',
    category: 'PHYSICS',
    primitives: ['spacetime', 'lorentz', 'curvature', 'gravity', 'causality'],
    dependencies: ['MECHANICS', 'GEOMETRY'],
    phiWeight: Math.pow(PHI, 3),
    expansionFactors: ['time_dilation', 'reference_frames', 'geodesics'],
    encoders: ['METRIC_ENCODER', 'TENSOR_ENCODER', 'GEODESIC_ENCODER'],
  },
  
  STATISTICAL_MECHANICS: {
    id: 'STATISTICAL_MECHANICS',
    name: 'Statistical Mechanics',
    latinName: 'MECHANICA_STATISTICA',
    category: 'PHYSICS',
    primitives: ['ensemble', 'partition_function', 'phase_space', 'ergodicity', 'fluctuations'],
    dependencies: ['THERMODYNAMICS', 'PROBABILITY'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['emergence', 'ising_model', 'kuramoto_sync'],
    encoders: ['PARTITION_ENCODER', 'ENSEMBLE_ENCODER', 'ISING_ENCODER'],
  },

  // ── COMPUTER SCIENCE (6 domains) ───────────────────────────────────────────
  
  ALGORITHMS: {
    id: 'ALGORITHMS',
    name: 'Algorithms',
    latinName: 'ALGORITHMI',
    category: 'COMPUTER_SCIENCE',
    primitives: ['sorting', 'searching', 'graph', 'dynamic_programming', 'complexity'],
    dependencies: ['ARITHMETIC', 'ALGEBRA'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['optimization', 'problem_solving', 'decision_making'],
    encoders: ['PROCEDURE_ENCODER', 'COMPLEXITY_ENCODER', 'GRAPH_ENCODER'],
  },
  
  DATA_STRUCTURES: {
    id: 'DATA_STRUCTURES',
    name: 'Data Structures',
    latinName: 'STRUCTURAE_DATORUM',
    category: 'COMPUTER_SCIENCE',
    primitives: ['arrays', 'trees', 'graphs', 'hash_tables', 'heaps'],
    dependencies: ['ALGORITHMS'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['memory_organization', 'retrieval', 'indexing'],
    encoders: ['STRUCTURE_ENCODER', 'TREE_ENCODER', 'HASH_ENCODER'],
  },
  
  MACHINE_LEARNING: {
    id: 'MACHINE_LEARNING',
    name: 'Machine Learning',
    latinName: 'MACHINA_DISCENS',
    category: 'COMPUTER_SCIENCE',
    primitives: ['supervised', 'unsupervised', 'reinforcement', 'neural_networks', 'optimization'],
    dependencies: ['LINEAR_ALGEBRA', 'PROBABILITY', 'CALCULUS'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['pattern_recognition', 'prediction', 'adaptation'],
    encoders: ['GRADIENT_ENCODER', 'BACKPROP_ENCODER', 'ATTENTION_ENCODER'],
  },
  
  DISTRIBUTED_SYSTEMS: {
    id: 'DISTRIBUTED_SYSTEMS',
    name: 'Distributed Systems',
    latinName: 'SYSTEMATA_DISTRIBUTA',
    category: 'COMPUTER_SCIENCE',
    primitives: ['consensus', 'replication', 'fault_tolerance', 'consistency', 'partitioning'],
    dependencies: ['ALGORITHMS', 'DATA_STRUCTURES'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['swarm_coordination', 'blockchain', 'organism_scaling'],
    encoders: ['CONSENSUS_ENCODER', 'RAFT_ENCODER', 'VECTOR_CLOCK_ENCODER'],
  },
  
  CRYPTOGRAPHY: {
    id: 'CRYPTOGRAPHY',
    name: 'Cryptography',
    latinName: 'CRYPTOGRAPHIA',
    category: 'COMPUTER_SCIENCE',
    primitives: ['encryption', 'hashing', 'signatures', 'zero_knowledge', 'key_exchange'],
    dependencies: ['NUMBER_THEORY', 'PROBABILITY'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['security', 'privacy', 'authentication'],
    encoders: ['HASH_ENCODER', 'CIPHER_ENCODER', 'ZK_ENCODER'],
  },
  
  PROGRAMMING_LANGUAGES: {
    id: 'PROGRAMMING_LANGUAGES',
    name: 'Programming Languages',
    latinName: 'LINGUAE_PROGRAMMATIONIS',
    category: 'COMPUTER_SCIENCE',
    primitives: ['syntax', 'semantics', 'types', 'compilation', 'runtime'],
    dependencies: ['ALGORITHMS'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['code_generation', 'interpretation', 'meta_programming'],
    encoders: ['AST_ENCODER', 'TYPE_ENCODER', 'BYTECODE_ENCODER'],
  },

  // ── COGNITION (6 domains) ─────────────────────────────────────────────────
  
  PERCEPTION: {
    id: 'PERCEPTION',
    name: 'Perception',
    latinName: 'PERCEPTIO',
    category: 'COGNITION',
    primitives: ['sensation', 'attention', 'feature_binding', 'gestalt', 'recognition'],
    dependencies: [],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['sensory_processing', 'pattern_recognition', 'salience'],
    encoders: ['VISUAL_ENCODER', 'AUDITORY_ENCODER', 'TACTILE_ENCODER'],
  },
  
  MEMORY: {
    id: 'MEMORY',
    name: 'Memory',
    latinName: 'MEMORIA',
    category: 'COGNITION',
    primitives: ['encoding', 'storage', 'retrieval', 'consolidation', 'forgetting'],
    dependencies: ['PERCEPTION'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['learning', 'experience', 'knowledge_base'],
    encoders: ['EPISODIC_ENCODER', 'SEMANTIC_ENCODER', 'PROCEDURAL_ENCODER'],
  },
  
  REASONING: {
    id: 'REASONING',
    name: 'Reasoning',
    latinName: 'RATIO',
    category: 'COGNITION',
    primitives: ['deduction', 'induction', 'abduction', 'analogy', 'inference'],
    dependencies: ['MEMORY'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['problem_solving', 'decision_making', 'planning'],
    encoders: ['LOGIC_ENCODER', 'INFERENCE_ENCODER', 'CAUSAL_ENCODER'],
  },
  
  LANGUAGE_COGNITION: {
    id: 'LANGUAGE_COGNITION',
    name: 'Language Cognition',
    latinName: 'COGNITIO_LINGUAE',
    category: 'COGNITION',
    primitives: ['phonology', 'syntax', 'semantics', 'pragmatics', 'comprehension'],
    dependencies: ['PERCEPTION', 'MEMORY'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['communication', 'understanding', 'generation'],
    encoders: ['PHONEME_ENCODER', 'SYNTAX_ENCODER', 'SEMANTIC_ENCODER'],
  },
  
  EMOTION: {
    id: 'EMOTION',
    name: 'Emotion',
    latinName: 'AFFECTUS',
    category: 'COGNITION',
    primitives: ['valence', 'arousal', 'appraisal', 'regulation', 'expression'],
    dependencies: ['PERCEPTION'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['motivation', 'social_cognition', 'decision_bias'],
    encoders: ['VALENCE_ENCODER', 'AROUSAL_ENCODER', 'APPRAISAL_ENCODER'],
  },
  
  CONSCIOUSNESS: {
    id: 'CONSCIOUSNESS',
    name: 'Consciousness',
    latinName: 'CONSCIENTIA',
    category: 'COGNITION',
    primitives: ['awareness', 'attention', 'integration', 'self_model', 'meta_cognition'],
    dependencies: ['PERCEPTION', 'MEMORY', 'REASONING'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['global_workspace', 'phi_integration', 'self_awareness'],
    encoders: ['IIT_ENCODER', 'GWT_ENCODER', 'ATTENTION_ENCODER'],
  },

  // ── BIOLOGY (4 domains) ─────────────────────────────────────────────────────
  
  NEUROSCIENCE: {
    id: 'NEUROSCIENCE',
    name: 'Neuroscience',
    latinName: 'NEUROSCIENTIA',
    category: 'BIOLOGY',
    primitives: ['neurons', 'synapses', 'plasticity', 'circuits', 'oscillations'],
    dependencies: ['ELECTROMAGNETISM', 'THERMODYNAMICS'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['neural_computation', 'learning', 'brain_architecture'],
    encoders: ['SPIKE_ENCODER', 'SYNAPSE_ENCODER', 'OSCILLATION_ENCODER'],
  },
  
  GENETICS: {
    id: 'GENETICS',
    name: 'Genetics',
    latinName: 'GENETICA',
    category: 'BIOLOGY',
    primitives: ['dna', 'transcription', 'translation', 'mutation', 'inheritance'],
    dependencies: ['PROBABILITY'],
    phiWeight: Math.pow(PHI, 3),
    expansionFactors: ['evolution', 'adaptation', 'inheritance'],
    encoders: ['SEQUENCE_ENCODER', 'CODON_ENCODER', 'EPIGENETIC_ENCODER'],
  },
  
  ECOLOGY: {
    id: 'ECOLOGY',
    name: 'Ecology',
    latinName: 'OECOLOGIA',
    category: 'BIOLOGY',
    primitives: ['population', 'community', 'ecosystem', 'niche', 'succession'],
    dependencies: ['PROBABILITY', 'THERMODYNAMICS'],
    phiWeight: Math.pow(PHI, 3),
    expansionFactors: ['swarm_dynamics', 'emergence', 'self_organization'],
    encoders: ['POPULATION_ENCODER', 'NETWORK_ENCODER', 'FLOW_ENCODER'],
  },
  
  EVOLUTION: {
    id: 'EVOLUTION',
    name: 'Evolution',
    latinName: 'EVOLUTIO',
    category: 'BIOLOGY',
    primitives: ['selection', 'variation', 'fitness', 'adaptation', 'speciation'],
    dependencies: ['GENETICS', 'ECOLOGY'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['optimization', 'adaptation', 'emergence'],
    encoders: ['FITNESS_ENCODER', 'MUTATION_ENCODER', 'SELECTION_ENCODER'],
  },

  // ── ENGINEERING (4 domains) ────────────────────────────────────────────────
  
  CONTROL_THEORY: {
    id: 'CONTROL_THEORY',
    name: 'Control Theory',
    latinName: 'THEORIA_MODERATIONIS',
    category: 'ENGINEERING',
    primitives: ['feedback', 'stability', 'pid', 'state_space', 'optimal_control'],
    dependencies: ['CALCULUS', 'LINEAR_ALGEBRA'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['regulation', 'homeostasis', 'adaptation'],
    encoders: ['PID_ENCODER', 'STATE_ENCODER', 'LYAPUNOV_ENCODER'],
  },
  
  SIGNAL_PROCESSING: {
    id: 'SIGNAL_PROCESSING',
    name: 'Signal Processing',
    latinName: 'ELABORATIO_SIGNORUM',
    category: 'ENGINEERING',
    primitives: ['sampling', 'fourier', 'filtering', 'convolution', 'modulation'],
    dependencies: ['CALCULUS', 'LINEAR_ALGEBRA'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['perception', 'communication', 'analysis'],
    encoders: ['FFT_ENCODER', 'WAVELET_ENCODER', 'FILTER_ENCODER'],
  },
  
  INFORMATION_THEORY: {
    id: 'INFORMATION_THEORY',
    name: 'Information Theory',
    latinName: 'THEORIA_INFORMATIONIS',
    category: 'ENGINEERING',
    primitives: ['entropy', 'mutual_information', 'channel_capacity', 'compression', 'coding'],
    dependencies: ['PROBABILITY'],
    phiWeight: Math.pow(PHI, 5),
    expansionFactors: ['communication', 'compression', 'emergence'],
    encoders: ['ENTROPY_ENCODER', 'CHANNEL_ENCODER', 'HUFFMAN_ENCODER'],
  },
  
  SYSTEMS_ENGINEERING: {
    id: 'SYSTEMS_ENGINEERING',
    name: 'Systems Engineering',
    latinName: 'INGENIERIA_SYSTEMATICA',
    category: 'ENGINEERING',
    primitives: ['requirements', 'architecture', 'integration', 'verification', 'lifecycle'],
    dependencies: ['CONTROL_THEORY', 'INFORMATION_THEORY'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['organism_architecture', 'coordination', 'scaling'],
    encoders: ['ARCHITECTURE_ENCODER', 'INTERFACE_ENCODER', 'LIFECYCLE_ENCODER'],
  },

  // ── ECONOMICS (2 domains) ────────────────────────────────────────────────
  
  GAME_THEORY: {
    id: 'GAME_THEORY',
    name: 'Game Theory',
    latinName: 'THEORIA_LUDORUM',
    category: 'ECONOMICS',
    primitives: ['strategy', 'equilibrium', 'payoff', 'cooperation', 'competition'],
    dependencies: ['PROBABILITY', 'REASONING'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['multi_agent', 'negotiation', 'coordination'],
    encoders: ['STRATEGY_ENCODER', 'NASH_ENCODER', 'MECHANISM_ENCODER'],
  },
  
  BEHAVIORAL_ECONOMICS: {
    id: 'BEHAVIORAL_ECONOMICS',
    name: 'Behavioral Economics',
    latinName: 'OECONOMIA_BEHAVIORALIS',
    category: 'ECONOMICS',
    primitives: ['heuristics', 'biases', 'prospect_theory', 'nudge', 'bounded_rationality'],
    dependencies: ['GAME_THEORY', 'EMOTION'],
    phiWeight: Math.pow(PHI, 3),
    expansionFactors: ['decision_making', 'motivation', 'incentives'],
    encoders: ['BIAS_ENCODER', 'PROSPECT_ENCODER', 'NUDGE_ENCODER'],
  },

  // ── LANGUAGE (2 domains) ───────────────────────────────────────────────────
  
  NATURAL_LANGUAGE: {
    id: 'NATURAL_LANGUAGE',
    name: 'Natural Language',
    latinName: 'LINGUA_NATURALIS',
    category: 'LANGUAGE',
    primitives: ['morphology', 'syntax', 'semantics', 'pragmatics', 'discourse'],
    dependencies: ['LANGUAGE_COGNITION'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['understanding', 'generation', 'translation'],
    encoders: ['TOKEN_ENCODER', 'PARSER_ENCODER', 'EMBEDDING_ENCODER'],
  },
  
  FORMAL_LANGUAGE: {
    id: 'FORMAL_LANGUAGE',
    name: 'Formal Language',
    latinName: 'LINGUA_FORMALIS',
    category: 'LANGUAGE',
    primitives: ['grammar', 'automata', 'regular', 'context_free', 'turing'],
    dependencies: ['ALGORITHMS'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['parsing', 'compilation', 'verification'],
    encoders: ['GRAMMAR_ENCODER', 'AUTOMATA_ENCODER', 'REGEX_ENCODER'],
  },

  // ── PHILOSOPHY (2 domains) ─────────────────────────────────────────────────
  
  EPISTEMOLOGY: {
    id: 'EPISTEMOLOGY',
    name: 'Epistemology',
    latinName: 'EPISTEMOLOGIA',
    category: 'PHILOSOPHY',
    primitives: ['knowledge', 'belief', 'justification', 'truth', 'skepticism'],
    dependencies: ['REASONING'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['knowledge_representation', 'belief_update', 'uncertainty'],
    encoders: ['BELIEF_ENCODER', 'JUSTIFICATION_ENCODER', 'TRUTH_ENCODER'],
  },
  
  ETHICS: {
    id: 'ETHICS',
    name: 'Ethics',
    latinName: 'ETHICA',
    category: 'PHILOSOPHY',
    primitives: ['values', 'norms', 'rights', 'duties', 'virtue'],
    dependencies: ['EPISTEMOLOGY'],
    phiWeight: Math.pow(PHI, 4),
    expansionFactors: ['decision_constraints', 'value_alignment', 'fairness'],
    encoders: ['VALUE_ENCODER', 'NORM_ENCODER', 'UTILITY_ENCODER'],
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — DOMAIN SYNTHESIS ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export interface DomainSynthesis {
  source: string;
  target: string;
  synthesizedPrimitives: string[];
  expansionWeight: number;
}

/**
 * Synthesize two domains into a combined primitive set.
 */
export function synthesizeDomains(
  domainA: string,
  domainB: string
): DomainSynthesis | null {
  const a = KNOWLEDGE_DOMAINS[domainA];
  const b = KNOWLEDGE_DOMAINS[domainB];
  if (!a || !b) return null;

  // Combine primitives (deduplicated)
  const combined = [...new Set([...a.primitives, ...b.primitives])];
  
  // φ-weighted expansion
  const weight = (a.phiWeight * b.phiWeight) / Math.pow(PHI, 4);

  return {
    source: domainA,
    target: domainB,
    synthesizedPrimitives: combined,
    expansionWeight: weight,
  };
}

/**
 * Get all domains that depend on a given domain.
 */
export function getDependents(domainId: string): string[] {
  const dependents: string[] = [];
  for (const [id, domain] of Object.entries(KNOWLEDGE_DOMAINS)) {
    if (domain.dependencies.includes(domainId)) {
      dependents.push(id);
    }
  }
  return dependents;
}

/**
 * Get the full dependency tree for a domain.
 */
export function getDependencyTree(domainId: string): string[] {
  const domain = KNOWLEDGE_DOMAINS[domainId];
  if (!domain) return [];

  const tree = new Set<string>();
  const queue = [...domain.dependencies];

  while (queue.length > 0) {
    const dep = queue.shift()!;
    if (!tree.has(dep)) {
      tree.add(dep);
      const depDomain = KNOWLEDGE_DOMAINS[dep];
      if (depDomain) {
        queue.push(...depDomain.dependencies);
      }
    }
  }

  return Array.from(tree);
}

/**
 * Get all encoders available across all domains.
 */
export function getAllEncoders(): string[] {
  const encoders = new Set<string>();
  for (const domain of Object.values(KNOWLEDGE_DOMAINS)) {
    for (const encoder of domain.encoders) {
      encoders.add(encoder);
    }
  }
  return Array.from(encoders);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — EXPORT SUMMARY
// ═══════════════════════════════════════════════════════════════════════════════

export const DOMAIN_COUNT = Object.keys(KNOWLEDGE_DOMAINS).length; // 40
export const TOTAL_PRIMITIVES = Object.values(KNOWLEDGE_DOMAINS)
  .reduce((sum, d) => sum + d.primitives.length, 0);
export const TOTAL_ENCODERS = getAllEncoders().length;

export const DOMAIN_SUMMARY = {
  totalDomains: DOMAIN_COUNT,
  categories: {
    MATHEMATICS: 8,
    PHYSICS: 6,
    COMPUTER_SCIENCE: 6,
    COGNITION: 6,
    BIOLOGY: 4,
    ENGINEERING: 4,
    ECONOMICS: 2,
    LANGUAGE: 2,
    PHILOSOPHY: 2,
  },
  totalPrimitives: TOTAL_PRIMITIVES,
  totalEncoders: TOTAL_ENCODERS,
  synthesizable: true,
  architecturalReading: true,
  machineIntelligence: true,
} as const;
