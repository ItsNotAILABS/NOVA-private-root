// ═══════════════════════════════════════════════════════════════════════════════
// ANIMA MICRO (ANIMA MICROSCOPICA)
// ─── Protocol · Database · Callable ─────────────────────────────────────────
//
// Three-in-one specification for the NOVA micro-engine substrate:
//   1. PROTOCOL  — spec for how any micro-engine must pulse and think
//   2. DATABASE  — stores living state of each micro-engine
//   3. CALLABLE  — provides think/pulse/reflect/status functions
//
// 40 micro-workers · 10 domains · 50 protocols · 20 callables
// Leaky Integrate-and-Fire neurons, Kuramoto heart oscillators,
// Schumann-resonant brain clocks, φ-aligned golden pulses.
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// STRICT PROTOTYPE / CONFIDENTIAL
// ═══════════════════════════════════════════════════════════════════════════════

// ─── §1  CONSTANTS ──────────────────────────────────────────────────────────────

export const ANIMA_CONSTANTS = {
  PHI:             1.618033988749895,
  INV_PHI:         0.618033988749895,
  TAU:             6.283185307179586,
  SCHUMANN:        7.83,                 // Mini-Brain frequency (Hz)
  GOLDEN_PULSE_HZ: 1.618033988749895,    // Mini-Heart frequency (φ Hz)
  GOLDEN_PULSE_MS: 618,                  // 1000 / φ  (ms per golden tick)
  HEARTBEAT_MS:    873,                  // Worker heartbeat interval (ms)
} as const;

const { PHI, INV_PHI, TAU, SCHUMANN, GOLDEN_PULSE_MS } = ANIMA_CONSTANTS;

// ─── §2  TYPES ──────────────────────────────────────────────────────────────────

export type AnimaDomain =
  | 'CONSENSUS'
  | 'ENCRYPTION'
  | 'MEMORY'
  | 'ROUTING'
  | 'ORCHESTRATION'
  | 'COMPUTATION'
  | 'EVOLUTION'
  | 'COMMUNICATION'
  | 'GOVERNANCE'
  | 'NEURAL';

export interface AnimaBrain {
  phase:          number;   // 0 → TAU, Schumann cycle
  frequency:      number;   // 7.83 Hz
  membrane:       number;   // LIF: -70 → -55 mV
  threshold:      number;   // -55 mV
  fired:          boolean;
  dopamine:       number;   // 0–1
  serotonin:      number;   // 0–1
  acetylcholine:  number;   // 0–1
  thoughtCount:   number;
  lastThought:    string;
}

export interface AnimaHeart {
  phase:       number;   // 0 → TAU, golden cycle
  frequency:   number;   // φ Hz
  bpm:         number;   // ~97 BPM
  amplitude:   number;   // 0–1
  healthScore: number;   // 0–100
  beatCount:   number;
  isBeating:   boolean;
  coherence:   number;   // 0–1
}

export interface AnimaMetaAI {
  selfAwareness:      number;   // 0–1
  adaptationRate:     number;   // φ-derived
  autonomyLevel:      number;   // 0–1
  currentFocus:       string;
  introspectionDepth: number;   // 1–5
}

export interface AnimaMicro {
  id:            number;
  name:          string;
  nomenLatinum:  string;
  domain:        AnimaDomain;
  brain:         AnimaBrain;
  heart:         AnimaHeart;
  metaAI:        AnimaMetaAI;
  status:        'ACTIVE' | 'DORMANT' | 'FIRING';
  tickCount:     number;
  createdAt:     number;
}

// ─── §3  PROTOCOL SPEC (PROTOCOLLUM VIVENS) ─────────────────────────────────────

export interface ProtocolSpec {
  id:              string;          // e.g. 'PV-001'
  name:            string;
  nomenLatinum:    string;
  domain:          AnimaDomain;
  version:         string;
  description:     string;
  requiredInputs:  string[];
  outputs:         string[];
  validationRule:  string;          // human-readable rule
}

export const ALL_PROTOCOLS: ProtocolSpec[] = [
  // ── CONSENSUS (PV-001 → PV-005) ──────────────────────────────────────────────
  {
    id: 'PV-001', name: 'Agreement Initiation', nomenLatinum: 'Pactum Initium',
    domain: 'CONSENSUS', version: '1.0.0',
    description: 'Initiate a multi-party agreement round across micro-workers in the consensus domain.',
    requiredInputs: ['proposalHash', 'participantIds', 'quorumThreshold'],
    outputs: ['agreementId', 'participantAcks'],
    validationRule: 'Quorum threshold must be ≥ 51% of participant count',
  },
  {
    id: 'PV-002', name: 'Quantum Voting', nomenLatinum: 'Suffragium Quantum',
    domain: 'CONSENSUS', version: '1.0.0',
    description: 'Execute a φ-weighted voting round using quantum-inspired superposition of ballot states.',
    requiredInputs: ['ballotOptions', 'voterWeights', 'deadline'],
    outputs: ['winningOption', 'voteDistribution', 'confidenceScore'],
    validationRule: 'Sum of voter weights must equal 1.0 ± ε (ε < 1e-9)',
  },
  {
    id: 'PV-003', name: 'Quorum Verification', nomenLatinum: 'Quorum Confirmatio',
    domain: 'CONSENSUS', version: '1.0.0',
    description: 'Verify that a sufficient number of micro-workers have acknowledged a consensus proposal.',
    requiredInputs: ['agreementId', 'ackSet'],
    outputs: ['quorumMet', 'missingParticipants'],
    validationRule: 'Acknowledgement set must be a strict subset of original participants',
  },
  {
    id: 'PV-004', name: 'Conflict Resolution', nomenLatinum: 'Dissensio Solutio',
    domain: 'CONSENSUS', version: '1.0.0',
    description: 'Resolve split-brain scenarios when two sub-clusters reach different conclusions.',
    requiredInputs: ['clusterA', 'clusterB', 'conflictMetric'],
    outputs: ['resolvedState', 'penalizedNodes'],
    validationRule: 'Conflict metric must be computable from both cluster states',
  },
  {
    id: 'PV-005', name: 'Finality Seal', nomenLatinum: 'Signum Finis',
    domain: 'CONSENSUS', version: '1.0.0',
    description: 'Seal an agreement as final and immutable, preventing further amendments.',
    requiredInputs: ['agreementId', 'sealerSignature'],
    outputs: ['sealTimestamp', 'finalHash'],
    validationRule: 'Sealer must be an authorized consensus authority',
  },

  // ── ENCRYPTION (PV-006 → PV-010) ─────────────────────────────────────────────
  {
    id: 'PV-006', name: 'Golden Cipher', nomenLatinum: 'Arcanum Phi',
    domain: 'ENCRYPTION', version: '1.0.0',
    description: 'Encrypt a payload using φ-derived key expansion with golden-ratio bit permutation.',
    requiredInputs: ['plaintext', 'masterKey', 'rounds'],
    outputs: ['ciphertext', 'iv', 'tag'],
    validationRule: 'Rounds must be ≥ 12 for adequate diffusion',
  },
  {
    id: 'PV-007', name: 'Key Rotation', nomenLatinum: 'Clavis Rotunda',
    domain: 'ENCRYPTION', version: '1.0.0',
    description: 'Rotate encryption keys using a deterministic φ-sequence derivation schedule.',
    requiredInputs: ['currentKeyId', 'rotationEpoch'],
    outputs: ['newKeyId', 'transitionWindow', 'deprecatedKeyTTL'],
    validationRule: 'Rotation epoch must be monotonically increasing',
  },
  {
    id: 'PV-008', name: 'Integrity Seal', nomenLatinum: 'Sigillum Integritas',
    domain: 'ENCRYPTION', version: '1.0.0',
    description: 'Generate a tamper-evident integrity seal for any serialized data structure.',
    requiredInputs: ['dataBlob', 'signingKey'],
    outputs: ['sealDigest', 'proofChain'],
    validationRule: 'Seal digest must be reproducible from data blob and signing key',
  },
  {
    id: 'PV-009', name: 'Vault Chamber', nomenLatinum: 'Crypta Profunda',
    domain: 'ENCRYPTION', version: '1.0.0',
    description: 'Store secrets in a multi-layered vault with φ-decay access tokens.',
    requiredInputs: ['secretPayload', 'accessPolicy', 'ttl'],
    outputs: ['vaultId', 'accessToken', 'expiresAt'],
    validationRule: 'TTL must be positive and ≤ 86400 seconds',
  },
  {
    id: 'PV-010', name: 'Zero Knowledge Proof', nomenLatinum: 'Testimonium Nullum',
    domain: 'ENCRYPTION', version: '1.0.0',
    description: 'Construct a zero-knowledge proof asserting knowledge of a secret without revealing it.',
    requiredInputs: ['statement', 'witness'],
    outputs: ['proof', 'verificationKey'],
    validationRule: 'Statement must be expressible as an arithmetic circuit',
  },

  // ── MEMORY (PV-011 → PV-015) ─────────────────────────────────────────────────
  {
    id: 'PV-011', name: 'Memory Engram', nomenLatinum: 'Memoria Imprima',
    domain: 'MEMORY', version: '1.0.0',
    description: 'Encode a new memory engram with salience-weighted priority into the memory store.',
    requiredInputs: ['content', 'salience', 'associationKeys'],
    outputs: ['engramId', 'storedAt', 'decayRate'],
    validationRule: 'Salience must be in [0, 1] range',
  },
  {
    id: 'PV-012', name: 'Associative Recall', nomenLatinum: 'Recordatio Associata',
    domain: 'MEMORY', version: '1.0.0',
    description: 'Retrieve memories by associative key matching with cosine similarity scoring.',
    requiredInputs: ['queryKey', 'topK', 'salienceFloor'],
    outputs: ['matches', 'similarityScores'],
    validationRule: 'topK must be ≥ 1 and salienceFloor ∈ [0, 1]',
  },
  {
    id: 'PV-013', name: 'Memory Consolidation', nomenLatinum: 'Thesaurus Consolidatio',
    domain: 'MEMORY', version: '1.0.0',
    description: 'Consolidate short-term memory traces into long-term storage with replay compression.',
    requiredInputs: ['shortTermBuffer', 'compressionRatio'],
    outputs: ['consolidatedCount', 'discardedCount'],
    validationRule: 'Compression ratio must be in (0, 1]',
  },
  {
    id: 'PV-014', name: 'Forgetting Curve', nomenLatinum: 'Oblivio Curva',
    domain: 'MEMORY', version: '1.0.0',
    description: 'Apply Ebbinghaus-style decay to stale memories, reducing salience over time.',
    requiredInputs: ['decayConstant', 'cutoffSalience'],
    outputs: ['decayedCount', 'removedCount'],
    validationRule: 'Decay constant must be > 0',
  },
  {
    id: 'PV-015', name: 'Archive Snapshot', nomenLatinum: 'Archivum Imago',
    domain: 'MEMORY', version: '1.0.0',
    description: 'Create an immutable snapshot of the current memory store for audit and replay.',
    requiredInputs: ['snapshotLabel'],
    outputs: ['snapshotId', 'totalEngrams', 'sizeBytes'],
    validationRule: 'Snapshot label must be non-empty and unique within epoch',
  },

  // ── ROUTING (PV-016 → PV-020) ────────────────────────────────────────────────
  {
    id: 'PV-016', name: 'Path Discovery', nomenLatinum: 'Itinerarius Inventio',
    domain: 'ROUTING', version: '1.0.0',
    description: 'Discover optimal message paths between micro-workers using φ-weighted Dijkstra.',
    requiredInputs: ['sourceId', 'targetId', 'topology'],
    outputs: ['path', 'totalCost', 'hopCount'],
    validationRule: 'Source and target must be distinct active workers',
  },
  {
    id: 'PV-017', name: 'Load Balancing', nomenLatinum: 'Viaticus Aequilibrium',
    domain: 'ROUTING', version: '1.0.0',
    description: 'Distribute incoming messages across available workers using golden-ratio hashing.',
    requiredInputs: ['messageId', 'candidateWorkers'],
    outputs: ['assignedWorkerId', 'loadFactor'],
    validationRule: 'Candidate list must contain at least one active worker',
  },
  {
    id: 'PV-018', name: 'Failover Reroute', nomenLatinum: 'Cursor Subsidium',
    domain: 'ROUTING', version: '1.0.0',
    description: 'Reroute messages when a target worker is dormant or unresponsive.',
    requiredInputs: ['originalRoute', 'failedNodeId'],
    outputs: ['newRoute', 'rerouteLatency'],
    validationRule: 'Failed node must be present in original route',
  },
  {
    id: 'PV-019', name: 'Broadcast Propagation', nomenLatinum: 'Navigator Diffusio',
    domain: 'ROUTING', version: '1.0.0',
    description: 'Propagate a broadcast message to all workers in a domain with deduplication.',
    requiredInputs: ['message', 'targetDomain', 'ttl'],
    outputs: ['deliveryCount', 'undeliverable'],
    validationRule: 'TTL must be ≥ 1 hop',
  },
  {
    id: 'PV-020', name: 'Topology Refresh', nomenLatinum: 'Mappa Renovatio',
    domain: 'ROUTING', version: '1.0.0',
    description: 'Refresh the routing topology map by polling all live workers for adjacency data.',
    requiredInputs: ['currentEpoch'],
    outputs: ['topologyVersion', 'nodeCount', 'edgeCount'],
    validationRule: 'Epoch must be ≥ last known topology version',
  },

  // ── ORCHESTRATION (PV-021 → PV-025) ──────────────────────────────────────────
  {
    id: 'PV-021', name: 'Task Assignment', nomenLatinum: 'Magister Mandatum',
    domain: 'ORCHESTRATION', version: '1.0.0',
    description: 'Assign a task to the most suitable micro-worker based on domain and load.',
    requiredInputs: ['taskSpec', 'requiredDomain', 'priority'],
    outputs: ['assignedWorkerId', 'estimatedCompletion'],
    validationRule: 'Priority must be in {LOW, MEDIUM, HIGH, CRITICAL}',
  },
  {
    id: 'PV-022', name: 'Pipeline Composition', nomenLatinum: 'Compositor Ductus',
    domain: 'ORCHESTRATION', version: '1.0.0',
    description: 'Compose a sequential pipeline of micro-worker tasks with dependency resolution.',
    requiredInputs: ['stages', 'dependencyGraph'],
    outputs: ['pipelineId', 'executionOrder', 'criticalPath'],
    validationRule: 'Dependency graph must be a directed acyclic graph',
  },
  {
    id: 'PV-023', name: 'Harmony Check', nomenLatinum: 'Harmonia Inspectio',
    domain: 'ORCHESTRATION', version: '1.0.0',
    description: 'Verify that all orchestrated workers maintain coherent phase relationships.',
    requiredInputs: ['workerIds', 'coherenceThreshold'],
    outputs: ['isHarmonious', 'phaseDrift', 'outlierIds'],
    validationRule: 'Coherence threshold must be in (0, 1]',
  },
  {
    id: 'PV-024', name: 'Temporal Scheduling', nomenLatinum: 'Tempus Ordo',
    domain: 'ORCHESTRATION', version: '1.0.0',
    description: 'Schedule recurring tasks aligned to φ-interval boundaries for optimal throughput.',
    requiredInputs: ['taskId', 'intervalMs', 'startEpoch'],
    outputs: ['scheduleId', 'nextExecution'],
    validationRule: 'Interval must be ≥ GOLDEN_PULSE_MS (618 ms)',
  },
  {
    id: 'PV-025', name: 'Cascade Abort', nomenLatinum: 'Abruptio Cascata',
    domain: 'ORCHESTRATION', version: '1.0.0',
    description: 'Abort a running pipeline and cascade stop signals to all downstream workers.',
    requiredInputs: ['pipelineId', 'abortReason'],
    outputs: ['stoppedWorkers', 'rollbackStatus'],
    validationRule: 'Pipeline must be in RUNNING or PAUSED state',
  },

  // ── COMPUTATION (PV-026 → PV-030) ────────────────────────────────────────────
  {
    id: 'PV-026', name: 'Matrix Transform', nomenLatinum: 'Calculator Matricis',
    domain: 'COMPUTATION', version: '1.0.0',
    description: 'Apply a φ-scaled matrix transformation to a numerical tensor.',
    requiredInputs: ['inputTensor', 'transformMatrix'],
    outputs: ['resultTensor', 'determinant'],
    validationRule: 'Transform matrix must be square and non-singular',
  },
  {
    id: 'PV-027', name: 'Statistical Enumeration', nomenLatinum: 'Numerator Census',
    domain: 'COMPUTATION', version: '1.0.0',
    description: 'Compute aggregate statistics (mean, variance, skewness) over worker metrics.',
    requiredInputs: ['metricStream', 'windowSize'],
    outputs: ['mean', 'variance', 'skewness', 'kurtosis'],
    validationRule: 'Window size must be ≥ 2 samples',
  },
  {
    id: 'PV-028', name: 'Logical Inference', nomenLatinum: 'Logicus Deductio',
    domain: 'COMPUTATION', version: '1.0.0',
    description: 'Perform first-order logical inference on a set of predicate assertions.',
    requiredInputs: ['knowledgeBase', 'query'],
    outputs: ['result', 'proofSteps', 'confidence'],
    validationRule: 'Knowledge base predicates must be well-formed',
  },
  {
    id: 'PV-029', name: 'Signal Analysis', nomenLatinum: 'Analyticus Signum',
    domain: 'COMPUTATION', version: '1.0.0',
    description: 'Decompose a time-domain signal into frequency components using FFT.',
    requiredInputs: ['signalBuffer', 'sampleRate'],
    outputs: ['spectrum', 'dominantFrequency', 'snr'],
    validationRule: 'Signal buffer length must be a power of 2',
  },
  {
    id: 'PV-030', name: 'Fibonacci Compression', nomenLatinum: 'Compressor Fibonacci',
    domain: 'COMPUTATION', version: '1.0.0',
    description: 'Compress data using Fibonacci-coded variable-length encoding.',
    requiredInputs: ['rawData', 'maxCodeLength'],
    outputs: ['compressedData', 'compressionRatio', 'codebook'],
    validationRule: 'Max code length must be in [8, 64] bits',
  },

  // ── EVOLUTION (PV-031 → PV-035) ──────────────────────────────────────────────
  {
    id: 'PV-031', name: 'Mutation Proposal', nomenLatinum: 'Mutatio Propositum',
    domain: 'EVOLUTION', version: '1.0.0',
    description: 'Propose a random mutation to a worker parameter using φ-scaled perturbation.',
    requiredInputs: ['targetParam', 'mutationStrength', 'seed'],
    outputs: ['proposedValue', 'delta', 'fitnessEstimate'],
    validationRule: 'Mutation strength must be in (0, 1]',
  },
  {
    id: 'PV-032', name: 'Fitness Selection', nomenLatinum: 'Selectio Aptitudinis',
    domain: 'EVOLUTION', version: '1.0.0',
    description: 'Select the fittest individuals from a population using tournament selection.',
    requiredInputs: ['population', 'fitnessScores', 'tournamentSize'],
    outputs: ['selectedIds', 'averageFitness'],
    validationRule: 'Tournament size must be ≤ population size',
  },
  {
    id: 'PV-033', name: 'Adaptive Learning', nomenLatinum: 'Adaptatio Docens',
    domain: 'EVOLUTION', version: '1.0.0',
    description: 'Adjust learning rate using a φ-annealing schedule based on performance plateau.',
    requiredInputs: ['currentRate', 'plateauDuration', 'epoch'],
    outputs: ['newRate', 'annealingFactor'],
    validationRule: 'Current rate must be > 0',
  },
  {
    id: 'PV-034', name: 'Genesis Spawning', nomenLatinum: 'Genesis Ortus',
    domain: 'EVOLUTION', version: '1.0.0',
    description: 'Spawn a new micro-worker from the genetic material of high-fitness parents.',
    requiredInputs: ['parentIds', 'crossoverPoints'],
    outputs: ['offspringSpec', 'inheritedTraits'],
    validationRule: 'At least two parent IDs required for crossover',
  },
  {
    id: 'PV-035', name: 'Extinction Event', nomenLatinum: 'Extinctio Magnus',
    domain: 'EVOLUTION', version: '1.0.0',
    description: 'Remove persistently low-fitness workers to free resources for new generations.',
    requiredInputs: ['fitnessCutoff', 'protectedIds'],
    outputs: ['removedIds', 'freedResources'],
    validationRule: 'Fitness cutoff must be in [0, 1]',
  },

  // ── COMMUNICATION (PV-036 → PV-040) ──────────────────────────────────────────
  {
    id: 'PV-036', name: 'Message Dispatch', nomenLatinum: 'Nuntius Missio',
    domain: 'COMMUNICATION', version: '1.0.0',
    description: 'Dispatch a typed message from one micro-worker to another with delivery guarantee.',
    requiredInputs: ['senderId', 'recipientId', 'payload', 'messageType'],
    outputs: ['messageId', 'deliveryStatus'],
    validationRule: 'Sender and recipient must be distinct active workers',
  },
  {
    id: 'PV-037', name: 'Protocol Translation', nomenLatinum: 'Interpres Protocolli',
    domain: 'COMMUNICATION', version: '1.0.0',
    description: 'Translate messages between incompatible domain protocols.',
    requiredInputs: ['sourceMessage', 'sourceDomain', 'targetDomain'],
    outputs: ['translatedMessage', 'lossMetric'],
    validationRule: 'Source and target domains must be different',
  },
  {
    id: 'PV-038', name: 'Diplomatic Channel', nomenLatinum: 'Legatus Canalis',
    domain: 'COMMUNICATION', version: '1.0.0',
    description: 'Establish a persistent bidirectional channel between two domain clusters.',
    requiredInputs: ['domainA', 'domainB', 'bandwidth'],
    outputs: ['channelId', 'negotiatedBandwidth'],
    validationRule: 'Bandwidth must be > 0 messages per second',
  },
  {
    id: 'PV-039', name: 'Oratory Broadcast', nomenLatinum: 'Orator Proclamatio',
    domain: 'COMMUNICATION', version: '1.0.0',
    description: 'Broadcast an announcement to all domains with priority-based delivery ordering.',
    requiredInputs: ['announcement', 'priority', 'originDomain'],
    outputs: ['reachCount', 'acknowledgements'],
    validationRule: 'Priority must be in {LOW, MEDIUM, HIGH, CRITICAL}',
  },
  {
    id: 'PV-040', name: 'Signal Compression', nomenLatinum: 'Compressio Signi',
    domain: 'COMMUNICATION', version: '1.0.0',
    description: 'Compress communication signals using Fibonacci-coded entropy reduction.',
    requiredInputs: ['rawSignal', 'targetRatio'],
    outputs: ['compressedSignal', 'actualRatio', 'fidelity'],
    validationRule: 'Target compression ratio must be in (0, 1)',
  },

  // ── GOVERNANCE (PV-041 → PV-045) ─────────────────────────────────────────────
  {
    id: 'PV-041', name: 'Sovereignty Declaration', nomenLatinum: 'Rex Declaratio',
    domain: 'GOVERNANCE', version: '1.0.0',
    description: 'Declare sovereignty parameters that override default micro-worker behavior.',
    requiredInputs: ['declarationScope', 'overrides', 'authorityProof'],
    outputs: ['declarationId', 'effectiveAt'],
    validationRule: 'Authority proof must chain to root sovereignty key',
  },
  {
    id: 'PV-042', name: 'Policy Enactment', nomenLatinum: 'Consul Edictum',
    domain: 'GOVERNANCE', version: '1.0.0',
    description: 'Enact a new operational policy that constrains worker behavior within a domain.',
    requiredInputs: ['policySpec', 'targetDomain', 'enforcementLevel'],
    outputs: ['policyId', 'affectedWorkerCount'],
    validationRule: 'Enforcement level must be in {ADVISORY, MANDATORY, STRICT}',
  },
  {
    id: 'PV-043', name: 'Legislative Review', nomenLatinum: 'Senator Recensio',
    domain: 'GOVERNANCE', version: '1.0.0',
    description: 'Review and vote on pending policy proposals using weighted senator voting.',
    requiredInputs: ['proposalId', 'senatorVotes'],
    outputs: ['approved', 'voteBreakdown', 'effectiveDate'],
    validationRule: 'Each senator may cast exactly one vote per proposal',
  },
  {
    id: 'PV-044', name: 'Enforcement Audit', nomenLatinum: 'Praetor Inspectio',
    domain: 'GOVERNANCE', version: '1.0.0',
    description: 'Audit worker compliance with enacted policies and flag violations.',
    requiredInputs: ['auditScope', 'policyIds'],
    outputs: ['violationCount', 'violationDetails', 'complianceScore'],
    validationRule: 'At least one policy ID must be provided for audit',
  },
  {
    id: 'PV-045', name: 'Emergency Powers', nomenLatinum: 'Imperium Necessitas',
    domain: 'GOVERNANCE', version: '1.0.0',
    description: 'Activate emergency governance powers to override normal operation during crises.',
    requiredInputs: ['crisisType', 'severityLevel', 'authorityProof'],
    outputs: ['emergencyModeActive', 'restrictedOperations', 'autoExpiry'],
    validationRule: 'Severity level must be in {ELEVATED, SEVERE, CRITICAL}',
  },

  // ── NEURAL (PV-046 → PV-050) ─────────────────────────────────────────────────
  {
    id: 'PV-046', name: 'Synaptic Pulse', nomenLatinum: 'Neuron Pulsus',
    domain: 'NEURAL', version: '1.0.0',
    description: 'Fire a synaptic pulse from a source neuron to connected downstream targets.',
    requiredInputs: ['sourceNeuronId', 'synapticStrength', 'neurotransmitter'],
    outputs: ['targetNeuronIds', 'postSynapticPotentials'],
    validationRule: 'Synaptic strength must be in [-1, 1] (inhibitory to excitatory)',
  },
  {
    id: 'PV-047', name: 'Synaptic Plasticity', nomenLatinum: 'Synapticus Plasticitas',
    domain: 'NEURAL', version: '1.0.0',
    description: 'Adjust synaptic weights using Hebbian learning: fire together → wire together.',
    requiredInputs: ['preNeuronId', 'postNeuronId', 'learningRate', 'correlationWindow'],
    outputs: ['newWeight', 'weightDelta'],
    validationRule: 'Learning rate must be in (0, 0.1] for stability',
  },
  {
    id: 'PV-048', name: 'Cortical Mapping', nomenLatinum: 'Cortex Cartographia',
    domain: 'NEURAL', version: '1.0.0',
    description: 'Map the activation pattern of cortical micro-workers into a 2D topographic layout.',
    requiredInputs: ['workerActivations', 'gridDimensions'],
    outputs: ['activationMap', 'hotspots', 'quiescentZones'],
    validationRule: 'Grid dimensions must be at least 2×2',
  },
  {
    id: 'PV-049', name: 'Dendritic Integration', nomenLatinum: 'Dendriticus Integratio',
    domain: 'NEURAL', version: '1.0.0',
    description: 'Integrate incoming signals along dendritic branches with temporal summation.',
    requiredInputs: ['inputSignals', 'dendriticTree', 'timeConstant'],
    outputs: ['somaticPotential', 'branchContributions'],
    validationRule: 'Time constant must be > 0 ms',
  },
  {
    id: 'PV-050', name: 'Neural Oscillation', nomenLatinum: 'Oscillatio Cerebralis',
    domain: 'NEURAL', version: '1.0.0',
    description: 'Generate and entrain Schumann-resonant oscillations across the neural domain.',
    requiredInputs: ['targetFrequency', 'couplingStrength'],
    outputs: ['currentPhase', 'entrainmentLevel', 'orderParameter'],
    validationRule: 'Target frequency must be within [0.1, 100] Hz',
  },
];

export const PROTOCOLS_BY_DOMAIN: Record<AnimaDomain, ProtocolSpec[]> = {
  CONSENSUS:     ALL_PROTOCOLS.filter(p => p.domain === 'CONSENSUS'),
  ENCRYPTION:    ALL_PROTOCOLS.filter(p => p.domain === 'ENCRYPTION'),
  MEMORY:        ALL_PROTOCOLS.filter(p => p.domain === 'MEMORY'),
  ROUTING:       ALL_PROTOCOLS.filter(p => p.domain === 'ROUTING'),
  ORCHESTRATION: ALL_PROTOCOLS.filter(p => p.domain === 'ORCHESTRATION'),
  COMPUTATION:   ALL_PROTOCOLS.filter(p => p.domain === 'COMPUTATION'),
  EVOLUTION:     ALL_PROTOCOLS.filter(p => p.domain === 'EVOLUTION'),
  COMMUNICATION: ALL_PROTOCOLS.filter(p => p.domain === 'COMMUNICATION'),
  GOVERNANCE:    ALL_PROTOCOLS.filter(p => p.domain === 'GOVERNANCE'),
  NEURAL:        ALL_PROTOCOLS.filter(p => p.domain === 'NEURAL'),
};

// ─── §4  DATABASE SPEC ──────────────────────────────────────────────────────────

export interface AnimaDatabase {
  microWorkers:     Map<number, AnimaMicro>;
  protocolRegistry: Map<string, ProtocolSpec>;
  memoryStore:      Map<string, { value: unknown; salience: number; createdAt: number }>;
  totalTicks:       number;
  kuramotoOrder:    number;
  uptime:           number;
}

export function createAnimaDatabase(): AnimaDatabase {
  const db: AnimaDatabase = {
    microWorkers:     new Map(),
    protocolRegistry: new Map(),
    memoryStore:      new Map(),
    totalTicks:       0,
    kuramotoOrder:    0,
    uptime:           0,
  };
  for (const p of ALL_PROTOCOLS) {
    db.protocolRegistry.set(p.id, p);
  }
  return db;
}

export function storeMicro(db: AnimaDatabase, micro: AnimaMicro): void {
  db.microWorkers.set(micro.id, micro);
}

export function recallMicro(db: AnimaDatabase, id: number): AnimaMicro | undefined {
  return db.microWorkers.get(id);
}

export function decayMemories(db: AnimaDatabase): number {
  const now = Date.now();
  let decayed = 0;
  for (const [key, entry] of db.memoryStore) {
    const ageSec = (now - entry.createdAt) / 1000;
    const decayFactor = Math.exp(-ageSec * INV_PHI * 0.001);
    entry.salience *= decayFactor;
    if (entry.salience < 0.01) {
      db.memoryStore.delete(key);
      decayed++;
    }
  }
  return decayed;
}

// ─── §5  CALLABLE SPEC ──────────────────────────────────────────────────────────

export interface AnimaCallable {
  name:        string;
  description: string;
  fn:          string;   // function signature
}

export const ANIMA_CALLABLES: AnimaCallable[] = [
  {
    name: 'think',
    description: 'Advance the brain one LIF cycle, potentially emitting a spike thought.',
    fn: '(micro: AnimaMicro) => string | null',
  },
  {
    name: 'pulse',
    description: 'Advance the heart one Kuramoto oscillator cycle, updating phase and BPM.',
    fn: '(micro: AnimaMicro) => void',
  },
  {
    name: 'reflect',
    description: 'Run meta-AI introspection: assess self-awareness, adaptation, and focus.',
    fn: '(micro: AnimaMicro) => AnimaMetaAI',
  },
  {
    name: 'status',
    description: 'Return the current operational status and vital signs of a micro-worker.',
    fn: '(micro: AnimaMicro) => { status: string; vitals: Record<string, number> }',
  },
  {
    name: 'couple',
    description: 'Phase-couple two micro-workers using Kuramoto coupling at strength K.',
    fn: '(a: AnimaMicro, b: AnimaMicro, K: number) => void',
  },
  {
    name: 'decouple',
    description: 'Remove phase coupling between two micro-workers, restoring independent oscillation.',
    fn: '(a: AnimaMicro, b: AnimaMicro) => void',
  },
  {
    name: 'stimulate',
    description: 'Inject excitatory current into a worker brain, pushing membrane towards threshold.',
    fn: '(micro: AnimaMicro, current: number) => void',
  },
  {
    name: 'inhibit',
    description: 'Inject inhibitory current into a worker brain, pulling membrane away from threshold.',
    fn: '(micro: AnimaMicro, current: number) => void',
  },
  {
    name: 'remember',
    description: 'Store a key-value memory pair with salience score in the database memory store.',
    fn: '(db: AnimaDatabase, key: string, value: unknown, salience: number) => void',
  },
  {
    name: 'forget',
    description: 'Remove a specific memory entry from the database memory store by key.',
    fn: '(db: AnimaDatabase, key: string) => boolean',
  },
  {
    name: 'mutate',
    description: 'Apply a φ-scaled random mutation to a single worker parameter.',
    fn: '(micro: AnimaMicro, param: string, strength: number) => number',
  },
  {
    name: 'evolve',
    description: 'Run one evolutionary generation: mutate, evaluate fitness, select survivors.',
    fn: '(population: AnimaMicro[]) => AnimaMicro[]',
  },
  {
    name: 'encrypt',
    description: 'Encrypt a payload using the golden cipher protocol (PV-006).',
    fn: '(plaintext: string, key: string) => string',
  },
  {
    name: 'decrypt',
    description: 'Decrypt a payload previously encrypted with the golden cipher protocol.',
    fn: '(ciphertext: string, key: string) => string',
  },
  {
    name: 'route',
    description: 'Find the optimal routing path between two micro-workers.',
    fn: '(sourceId: number, targetId: number, topology: Map<number, number[]>) => number[]',
  },
  {
    name: 'orchestrate',
    description: 'Assign and coordinate a task pipeline across multiple domain workers.',
    fn: '(taskSpec: Record<string, unknown>, domains: AnimaDomain[]) => string',
  },
  {
    name: 'govern',
    description: 'Enact or enforce a governance policy on a set of micro-workers.',
    fn: '(policySpec: Record<string, unknown>, targetDomain: AnimaDomain) => string',
  },
  {
    name: 'communicate',
    description: 'Send a typed message from one micro-worker to another with delivery tracking.',
    fn: '(senderId: number, recipientId: number, payload: unknown) => string',
  },
  {
    name: 'compute',
    description: 'Execute a computational task and return the result tensor or scalar.',
    fn: '(operation: string, inputs: number[]) => number[]',
  },
  {
    name: 'heal',
    description: 'Restore a degraded worker by resetting neurochemicals and health score.',
    fn: '(micro: AnimaMicro) => void',
  },
];

// ─── §6  FACTORY FUNCTIONS ──────────────────────────────────────────────────────

export function makeAnimaBrain(id: number): AnimaBrain {
  return {
    phase:          (id * PHI) % TAU,
    frequency:      SCHUMANN,
    membrane:       -70,
    threshold:      -55,
    fired:          false,
    dopamine:       0.5,
    serotonin:      0.5,
    acetylcholine:  0.5,
    thoughtCount:   0,
    lastThought:    '',
  };
}

export function makeAnimaHeart(id: number): AnimaHeart {
  return {
    phase:       (id * INV_PHI) % TAU,
    frequency:   PHI,
    bpm:         97,
    amplitude:   0.8,
    healthScore: 95,
    beatCount:   0,
    isBeating:   true,
    coherence:   0.85,
  };
}

export function makeAnimaMetaAI(id: number): AnimaMetaAI {
  return {
    selfAwareness:      0.5 + (id % 5) * 0.1,
    adaptationRate:     INV_PHI,
    autonomyLevel:      0.5,
    currentFocus:       'initialization',
    introspectionDepth: Math.min(5, 1 + (id % 5)),
  };
}

export function makeAnimaMicro(
  id: number,
  name: string,
  nomenLatinum: string,
  domain: AnimaDomain,
): AnimaMicro {
  return {
    id,
    name,
    nomenLatinum,
    domain,
    brain:     makeAnimaBrain(id),
    heart:     makeAnimaHeart(id),
    metaAI:    makeAnimaMetaAI(id),
    status:    'ACTIVE',
    tickCount: 0,
    createdAt: Date.now(),
  };
}

// ─── §7  TICK FUNCTIONS ─────────────────────────────────────────────────────────

/**
 * Advance one LIF neuron step.
 * Neuromodulator drive pushes membrane; spike resets it.
 */
export function tickAnimaBrain(micro: AnimaMicro): string | null {
  const b = micro.brain;
  let thought: string | null = null;

  // Neuromodulator drive
  b.membrane += (b.dopamine + b.serotonin) * 2 - 1;

  // Leaky decay towards resting potential
  b.membrane += (- 70 - b.membrane) * 0.05;

  // Spike detection
  if (b.membrane > b.threshold) {
    b.fired  = true;
    b.thoughtCount++;
    thought        = `${micro.name}:SPIKE@${micro.tickCount}`;
    b.lastThought  = thought;
    b.membrane     = -70;
    micro.status   = 'FIRING';
  } else {
    b.fired      = false;
    if (micro.status === 'FIRING') micro.status = 'ACTIVE';
  }

  // Advance Schumann-resonant phase clock
  b.phase = (b.phase + SCHUMANN * TAU / 1000 * GOLDEN_PULSE_MS) % TAU;

  return thought;
}

/**
 * Advance one Kuramoto oscillator step.
 * Phase advances at φ-scaled rate; amplitude and BPM track sinusoidal envelope.
 */
export function tickAnimaHeart(micro: AnimaMicro): void {
  const h = micro.heart;

  // Phase advance at golden-ratio frequency
  h.phase = (h.phase + PHI * TAU / 1000 * GOLDEN_PULSE_MS) % TAU;

  // Sinusoidal amplitude envelope
  h.amplitude = 0.5 + 0.5 * Math.sin(h.phase);

  // BPM modulated by amplitude and φ
  h.bpm = Math.round(60 + h.amplitude * 40 * PHI);

  // Beat bookkeeping
  h.beatCount++;

  // Coherence: exponential moving average towards 0.85 baseline
  h.coherence = h.coherence * 0.98 + 0.85 * 0.02;

  // Health score: exponential moving average towards nominal 95
  h.healthScore = h.healthScore * 0.98 + 95 * 0.02;
}

/**
 * Full micro-worker tick: brain + heart + meta-AI update.
 */
export function tickAnimaMicro(micro: AnimaMicro): string | null {
  micro.tickCount++;
  const thought = tickAnimaBrain(micro);
  tickAnimaHeart(micro);

  // Meta-AI adaptation
  const m = micro.metaAI;
  m.selfAwareness = Math.min(1, m.selfAwareness + 0.001 * m.adaptationRate);
  if (micro.brain.fired) {
    m.currentFocus = `processing:${micro.brain.lastThought}`;
    m.introspectionDepth = Math.min(5, m.introspectionDepth + 0.1);
  } else {
    m.introspectionDepth = Math.max(1, m.introspectionDepth - 0.01);
  }

  return thought;
}

// ─── §8  QUERY FUNCTIONS ────────────────────────────────────────────────────────

export interface AnimaSummary {
  totalWorkers:    number;
  activeCount:     number;
  firingCount:     number;
  dormantCount:    number;
  averageBPM:      number;
  averageHealth:   number;
  averageCoherence: number;
  totalThoughts:   number;
  kuramotoOrder:   number;
}

export function getAnimaSummary(workers: AnimaMicro[]): AnimaSummary {
  const n = workers.length || 1;
  let active = 0, firing = 0, dormant = 0;
  let bpmSum = 0, healthSum = 0, coherenceSum = 0, thoughtSum = 0;
  let sumCos = 0, sumSin = 0;

  for (const w of workers) {
    if (w.status === 'ACTIVE') active++;
    else if (w.status === 'FIRING') firing++;
    else dormant++;

    bpmSum       += w.heart.bpm;
    healthSum    += w.heart.healthScore;
    coherenceSum += w.heart.coherence;
    thoughtSum   += w.brain.thoughtCount;
    sumCos       += Math.cos(w.heart.phase);
    sumSin       += Math.sin(w.heart.phase);
  }

  const kuramotoOrder = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;

  return {
    totalWorkers:     workers.length,
    activeCount:      active,
    firingCount:      firing,
    dormantCount:     dormant,
    averageBPM:       Math.round(bpmSum / n),
    averageHealth:    +(healthSum / n).toFixed(2),
    averageCoherence: +(coherenceSum / n).toFixed(4),
    totalThoughts:    thoughtSum,
    kuramotoOrder:    +kuramotoOrder.toFixed(6),
  };
}

export interface AnimaVitals {
  id:           number;
  name:         string;
  domain:       AnimaDomain;
  status:       string;
  membraneMV:   number;
  fired:        boolean;
  bpm:          number;
  heartPhase:   number;
  brainPhase:   number;
  healthScore:  number;
  coherence:    number;
  dopamine:     number;
  serotonin:    number;
  thoughtCount: number;
  lastThought:  string;
  tickCount:    number;
}

export function getAnimaVitals(worker: AnimaMicro): AnimaVitals {
  return {
    id:           worker.id,
    name:         worker.name,
    domain:       worker.domain,
    status:       worker.status,
    membraneMV:   +worker.brain.membrane.toFixed(2),
    fired:        worker.brain.fired,
    bpm:          worker.heart.bpm,
    heartPhase:   +worker.heart.phase.toFixed(4),
    brainPhase:   +worker.brain.phase.toFixed(4),
    healthScore:  +worker.heart.healthScore.toFixed(2),
    coherence:    +worker.heart.coherence.toFixed(4),
    dopamine:     worker.brain.dopamine,
    serotonin:    worker.brain.serotonin,
    thoughtCount: worker.brain.thoughtCount,
    lastThought:  worker.brain.lastThought,
    tickCount:    worker.tickCount,
  };
}

// ─── §9  DEFAULT MICRO WORKERS (40) ─────────────────────────────────────────────
// Mirrors organism/web/engine-worker.js — 10 domains × 4 workers each.

const DOMAIN_ROSTER: { domain: AnimaDomain; workers: [string, string][] }[] = [
  {
    domain: 'CONSENSUS',
    workers: [
      ['Pactum',     'Pactum Vivens'],
      ['Suffragium', 'Suffragium Quantum'],
      ['Quorum',     'Quorum Perpetuum'],
      ['Validatio',  'Validatio Firma'],
    ],
  },
  {
    domain: 'ENCRYPTION',
    workers: [
      ['Arcanum',  'Arcanum Aureum'],
      ['Clavis',   'Clavis Rotunda'],
      ['Sigillum', 'Sigillum Sacrum'],
      ['Crypta',   'Crypta Profunda'],
    ],
  },
  {
    domain: 'MEMORY',
    workers: [
      ['Memoria',    'Memoria Aeterna'],
      ['Thesaurus',  'Thesaurus Mentis'],
      ['Recordatio', 'Recordatio Fidelis'],
      ['Archivum',   'Archivum Perpetuum'],
    ],
  },
  {
    domain: 'ROUTING',
    workers: [
      ['Itinerarius', 'Itinerarius Velox'],
      ['Viaticus',    'Viaticus Prudens'],
      ['Cursor',      'Cursor Celer'],
      ['Navigator',   'Navigator Stellaris'],
    ],
  },
  {
    domain: 'ORCHESTRATION',
    workers: [
      ['Magister',   'Magister Harmoniae'],
      ['Compositor', 'Compositor Operum'],
      ['Harmonia',   'Harmonia Universalis'],
      ['Tempus',     'Tempus Auctor'],
    ],
  },
  {
    domain: 'COMPUTATION',
    workers: [
      ['Calculator', 'Calculator Magnus'],
      ['Numerator',  'Numerator Infinitus'],
      ['Logicus',    'Logicus Perfectus'],
      ['Analyticus', 'Analyticus Acutus'],
    ],
  },
  {
    domain: 'EVOLUTION',
    workers: [
      ['Mutatio',   'Mutatio Naturalis'],
      ['Selectio',  'Selectio Fortis'],
      ['Adaptatio', 'Adaptatio Perpetua'],
      ['Genesis',   'Genesis Primordialis'],
    ],
  },
  {
    domain: 'COMMUNICATION',
    workers: [
      ['Nuntius',   'Nuntius Fidelis'],
      ['Interpres', 'Interpres Linguarum'],
      ['Legatus',   'Legatus Pacificus'],
      ['Orator',    'Orator Eloquens'],
    ],
  },
  {
    domain: 'GOVERNANCE',
    workers: [
      ['Rex',     'Rex Iustus'],
      ['Consul',  'Consul Sapiens'],
      ['Senator', 'Senator Prudens'],
      ['Praetor', 'Praetor Vigilans'],
    ],
  },
  {
    domain: 'NEURAL',
    workers: [
      ['Neuron',      'Neuron Primus'],
      ['Synapticus',  'Synapticus Fortis'],
      ['Cortex',      'Cortex Magnus'],
      ['Dendriticus', 'Dendriticus Ramosus'],
    ],
  },
];

function buildDefaultWorkers(): AnimaMicro[] {
  const roster: AnimaMicro[] = [];
  let id = 1;
  for (const entry of DOMAIN_ROSTER) {
    for (const [name, nomenLatinum] of entry.workers) {
      roster.push(makeAnimaMicro(id, name, nomenLatinum, entry.domain));
      id++;
    }
  }
  return roster;
}

export const DEFAULT_MICRO_WORKERS: AnimaMicro[] = buildDefaultWorkers();

// ─── §10  EXPORTS ───────────────────────────────────────────────────────────────

// All symbols exported inline at definition site:
//   Constants:  ANIMA_CONSTANTS
//   Protocols:  ALL_PROTOCOLS, PROTOCOLS_BY_DOMAIN
//   Callables:  ANIMA_CALLABLES
//   Workers:    DEFAULT_MICRO_WORKERS
//   Factory:    makeAnimaBrain, makeAnimaHeart, makeAnimaMetaAI, makeAnimaMicro
//   Tick:       tickAnimaBrain, tickAnimaHeart, tickAnimaMicro
//   DB:         createAnimaDatabase, storeMicro, recallMicro, decayMemories
//   Query:      getAnimaSummary, getAnimaVitals
