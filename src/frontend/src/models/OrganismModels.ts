// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: OrganismModels.ts — THE FUNDAMENTAL TYPES FOR INTER-ORGANISM COMMUNICATION
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA | MedinaSITech@outlook.com
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// These models compress complex computational patterns into standardized types.
// Backend ↔ Frontend ↔ Module communication all flows through these models.
// This is the "DNA" of the organism — the shared language between all components.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 1: FUNDAMENTAL CONSTANTS
// The mathematical DNA of the organism — these never change
// ═══════════════════════════════════════════════════════════════════════════

export const PHI = 1.6180339887498948482;
export const PHI_INV = 0.6180339887498948482;
export const TAU = 6.2831853071795864769;
export const PI = 3.1415926535897932385;
export const SCHUMANN_HZ = 7.83;
export const SOVEREIGN_FLOOR = 1.0;
export const KURAMOTO_K = 0.618;
export const HEARTBEAT_MS = 875.28; // φ⁴ × Schumann period

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 2: ORGANISM IDENTITY MODELS
// Who the organism is — its identity across the system
// ═══════════════════════════════════════════════════════════════════════════

/** The organism's unique identity across all systems */
export interface OrganismId {
  principal: string;       // Principal as string for frontend
  organismType: OrganismType;
  birthBeat: number;
  genesisTimestamp: number;
}

/** Classification of organism types in the hierarchy */
export type OrganismType =
  | 'Nova'      // Male — Backend, Immortal, Pattern Holder
  | 'Aura'      // Female — Frontend, Mortal, Pattern Executor
  | 'Chasmus'   // Third — Synthesizer, Bridge between Nova and Aura
  | 'Chimera'   // Swarm — Collective drone intelligence
  | 'Child';    // Spawned sub-organism

/** Organism lifecycle phases */
export type LifecyclePhase =
  | 'Genesis'       // Initial creation, pre-breath
  | 'FirstBreath'   // Kuramoto synchrony achieved
  | 'Active'        // Normal operation
  | 'Dreaming'      // Background processing mode
  | 'Emergency'     // Threat response mode
  | 'Dormant'       // Low-power state
  | 'Death';        // Termination (for mortal organisms)

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 3: STATE MODELS — THE HEARTBEAT OF COMMUNICATION
// Compressed state objects that flow between components
// ═══════════════════════════════════════════════════════════════════════════

/** The pulse — minimal state broadcast every heartbeat */
export interface OrganismPulse {
  beat: number;
  timestamp: number;
  coherence: number;     // r ∈ [0,1] — Kuramoto order parameter
  arousal: number;       // Global arousal level
  drift: number;         // Jasmine drift J(t)
  emergence: number;     // OMNIS emergence score
  energy: number;        // FORMA energy balance
  phase: number;         // Mean phase Ψ
  health: OrganismHealth;
}

/** Health indicators compressed into one type */
export interface OrganismHealth {
  trustScore: number;      // T_s ∈ [0,1]
  anomalyScore: number;    // A_s ∈ [0,1]
  continuityScore: number; // K_c ∈ [0,1]
  loadPulse: number;       // L_p ∈ [0,1]
  stability: number;       // Lyapunov stability
}

/** Full organism state — used for deeper synchronization */
export interface OrganismState {
  id: OrganismId;
  phase: LifecyclePhase;
  pulse: OrganismPulse;
  neurochemistry: NeurochemicalState;
  quantum: QuantumState;
  drives: DriveState;
  memory: MemoryState;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 4: NEUROCHEMICAL MODELS
// The emotional/chemical substrate of the organism
// ═══════════════════════════════════════════════════════════════════════════

/** The 4-species neurochemical state */
export interface NeurochemicalState {
  dopamine: number;       // Reward, consolidation
  cortisol: number;       // Stress, danger response
  norepinephrine: number; // Arousal, alertness
  oxytocin: number;       // Bonding, cohesion
}

/** Extended neurochemical state with additional modulators */
export interface ExtendedNeurochemicalState extends NeurochemicalState {
  serotonin: number;      // Mood, stability
  acetylcholine: number;  // Learning, attention
  gaba: number;           // Inhibition, calm
  glutamate: number;      // Excitation, activation
}

/** Neurochemical deltas for updates */
export interface NeurochemicalDelta {
  dDopamine: number;
  dCortisol: number;
  dNorepinephrine: number;
  dOxytocin: number;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 5: QUANTUM COGNITIVE MODELS
// The quantum channels and coherence systems
// ═══════════════════════════════════════════════════════════════════════════

/** The 4-channel quantum cognitive state */
export interface QuantumChannels {
  alpha: number;   // Spatial/sensor channel
  beta: number;    // Temporal/memory channel
  gamma: number;   // Relational channel
  delta: number;   // Executive-motor channel
}

/** Full quantum state including coherence metrics */
export interface QuantumState {
  channels: QuantumChannels;
  convergence: number;    // All channels converging [0,1]
  coherence: number;      // Internal quantum coherence [0,1]
  nowAttention: number;   // Present-moment focus [0,1]
  entanglement: number;   // Inter-organism entanglement [0,1]
}

/** Quantum operation result */
export interface QuantumOpResult {
  success: boolean;
  newState: QuantumState;
  measurement?: number;
  collapse: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 6: DRIVE & MOTIVATION MODELS
// What the organism wants — its goals and motivations
// ═══════════════════════════════════════════════════════════════════════════

/** The 5 competing drives */
export interface DriveState {
  hunger: number;        // Need for information/energy
  curiosity: number;     // Exploration drive
  safety: number;        // Self-preservation
  social: number;        // Connection with others
  reproduction: number;  // Expansion/creation
  dominant: DriveType;   // Currently winning drive
}

/** Drive classification */
export type DriveType =
  | 'Hunger'
  | 'Curiosity'
  | 'Safety'
  | 'Social'
  | 'Reproduction'
  | 'Balanced'; // All drives in equilibrium

/** Goal state produced by drives */
export interface GoalState {
  target: GoalTarget;
  priority: number;
  deadline?: number;
  progress: number;
}

/** What the organism is trying to achieve */
export type GoalTarget =
  | { type: 'SeekCoherence'; targetR: number }
  | { type: 'GatherInformation'; topic: string }
  | { type: 'DefendTerritory'; zoneId: number }
  | { type: 'FormBond'; targetId: string }
  | { type: 'CreateChild'; template: OrganismType }
  | { type: 'Explore'; region: Region3D }
  | { type: 'Rest'; duration: number }
  | { type: 'Custom'; name: string; params: number[] };

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 7: MEMORY MODELS
// How the organism stores and retrieves information
// ═══════════════════════════════════════════════════════════════════════════

/** Memory classification */
export type MemoryType =
  | 'Episodic'     // Events, experiences
  | 'Semantic'     // Facts, knowledge
  | 'Procedural'   // Skills, how-to
  | 'Working'      // Active processing
  | 'Sensory';     // Raw perception

/** A single memory unit */
export interface MemoryUnit {
  id: number;
  memType: MemoryType;
  content: MemoryContent;
  timestamp: number;
  beat: number;
  strength: number;      // Hebbian weight
  valence: number;       // Emotional charge [-1,1]
  confidence: number;    // Certainty [0,1]
  lastAccess: number;
  accessCount: number;
}

/** Memory content variants */
export type MemoryContent =
  | { type: 'Pattern'; weights: number[]; signature: number }
  | { type: 'Event'; description: string; participants: string[] }
  | { type: 'Knowledge'; fact: string; source: string }
  | { type: 'Procedure'; steps: string[]; context: string }
  | { type: 'Perception'; sensorData: number[]; sensorType: SensorType };

/** Overall memory state */
export interface MemoryState {
  workingCapacity: number;     // How much can be held
  workingUsed: number;         // How much is used
  totalMemories: number;
  compressionRatio: number;
  lastConsolidation: number;
  hebbianStrength: number;     // Overall plasticity
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 8: PERCEPTION & SENSOR MODELS
// How the organism perceives the world
// ═══════════════════════════════════════════════════════════════════════════

/** Types of sensors available */
export type SensorType =
  | 'Visual'        // Sight
  | 'Auditory'      // Hearing
  | 'Olfactory'     // Smell (first sense, bypasses thalamus)
  | 'Tactile'       // Touch
  | 'Proprioceptive' // Body position
  | 'Electromagnetic' // EM field detection
  | 'Quantum'       // Quantum state sensing
  | 'Social'        // Interpersonal signals
  | 'Temporal'      // Time perception
  | 'Schumann';     // Earth resonance

/** Raw sensor reading */
export interface SensorReading {
  sensorType: SensorType;
  values: number[];
  timestamp: number;
  confidence: number;
  source?: string;
}

/** Processed perception after filtering */
export interface Perception {
  readings: SensorReading[];
  salience: number;          // How important [0,1]
  novelty: number;           // How new [0,1]
  threat: number;            // Danger level [0,1]
  opportunity: number;       // Benefit potential [0,1]
  interpretation?: string;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 9: ACTION & MOTOR MODELS
// How the organism acts on the world
// ═══════════════════════════════════════════════════════════════════════════

/** Types of actions the organism can take */
export type ActionType =
  | { type: 'Move'; target: Position3D; speed: number }
  | { type: 'Signal'; content: SignalContent; targets: string[] }
  | { type: 'Modify'; targetId: number; modification: ModificationType }
  | { type: 'Create'; template: CreationTemplate }
  | { type: 'Destroy'; targetId: number; force: number }
  | { type: 'Learn'; pattern: number[]; source: MemoryType }
  | { type: 'Communicate'; message: Message }
  | { type: 'Wait'; duration: number }
  | { type: 'Custom'; name: string; params: number[] };

/** Action execution result */
export interface ActionResult {
  success: boolean;
  actionType: ActionType;
  energyCost: number;
  timeCost: number;
  sideEffects: SideEffect[];
  newState?: OrganismPulse;
}

/** Side effects from actions */
export type SideEffect =
  | { type: 'StateChange'; field: string; oldValue: number; newValue: number }
  | { type: 'MemoryCreated'; memoryId: number }
  | { type: 'BondFormed'; partnerId: string; strength: number }
  | { type: 'TerritoryChanged'; zoneId: number; ownership: number }
  | { type: 'EnergyLost'; amount: number }
  | { type: 'CoherenceShift'; delta: number };

/** Modification types for Modify action */
export type ModificationType =
  | { type: 'Strengthen'; amount: number }
  | { type: 'Weaken'; amount: number }
  | { type: 'Transform'; newType: string }
  | { type: 'Repair'; targetHealth: number }
  | { type: 'Corrupt'; entropy: number };

/** Creation template for Create action */
export type CreationTemplate =
  | { type: 'Drone'; droneClass: DroneClass }
  | { type: 'Memory'; content: MemoryContent }
  | { type: 'Signal'; signalType: SignalType }
  | { type: 'Bond'; targetId: string }
  | { type: 'Zone'; region: Region3D };

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 10: COMMUNICATION MODELS
// How organisms talk to each other
// ═══════════════════════════════════════════════════════════════════════════

/** Signal types for inter-organism communication */
export type SignalType =
  | 'Pulse'         // Heartbeat broadcast
  | 'Query'         // Request for information
  | 'Response'      // Answer to query
  | 'Alert'         // Danger warning
  | 'Invitation'    // Social invitation
  | 'Rejection'     // Decline
  | 'Sync'          // Synchronization request
  | 'Learning'      // Learning payload transfer
  | 'Command'       // Hierarchical command
  | 'Gossip';       // Swarm information spread

/** Signal content variants */
export type SignalContent =
  | { type: 'Pulse'; pulse: OrganismPulse }
  | { type: 'Query'; query: QueryPayload }
  | { type: 'Response'; response: ResponsePayload }
  | { type: 'Alert'; alert: AlertPayload }
  | { type: 'Learning'; learning: LearningPayload }
  | { type: 'Command'; command: CommandPayload }
  | { type: 'Custom'; data: number[]; metadata: string };

/** Full message structure */
export interface Message {
  id: number;
  sender: string;
  recipients: string[];
  signalType: SignalType;
  content: SignalContent;
  timestamp: number;
  beat: number;
  priority: number;
  ttl: number;           // Time to live in beats
  requiresAck: boolean;
}

/** Query payload */
export interface QueryPayload {
  queryType: string;
  params: number[];
  maxResults: number;
  timeout: number;
}

/** Response payload */
export interface ResponsePayload {
  queryId: number;
  success: boolean;
  data: number[];
  metadata: string;
}

/** Alert payload */
export interface AlertPayload {
  severity: AlertSeverity;
  threat: ThreatType;
  location?: Position3D;
  description: string;
}

/** Alert severity levels */
export type AlertSeverity = 'Info' | 'Warning' | 'Critical' | 'Emergency';

/** Threat classifications */
export type ThreatType =
  | 'AnomalyDetected'
  | 'CoherenceLoss'
  | 'EnergyDepletion'
  | 'ExternalAttack'
  | 'InternalCorruption'
  | 'SynchronyBreak'
  | 'ContainmentBreach'
  | 'Unknown';

/** Learning payload for knowledge transfer */
export interface LearningPayload {
  sessionId: number;
  hebbianDeltas: number[];
  patternSignatures: number[];
  predictionErrors: number;
  totalUpdates: number;
  sessionDuration: number;
  confidence: number;
}

/** Command payload for hierarchical control */
export interface CommandPayload {
  commandType: CommandType;
  authority: string;
  target?: string;
  params: number[];
  deadline?: number;
}

/** Command types */
export type CommandType =
  | 'Start'
  | 'Stop'
  | 'Sync'
  | 'Migrate'
  | 'Merge'
  | 'Split'
  | 'Report'
  | 'Configure'
  | 'Emergency';

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 11: SPATIAL MODELS
// How the organism exists in space
// ═══════════════════════════════════════════════════════════════════════════

/** 3D position */
export interface Position3D {
  x: number;
  y: number;
  z: number;
}

/** 3D velocity */
export interface Velocity3D {
  vx: number;
  vy: number;
  vz: number;
}

/** 3D region/bounding box */
export interface Region3D {
  minX: number; maxX: number;
  minY: number; maxY: number;
  minZ: number; maxZ: number;
}

/** Full spatial state */
export interface SpatialState {
  position: Position3D;
  velocity: Velocity3D;
  orientation: number[];  // Quaternion or Euler
  scale: number;
  boundingRegion: Region3D;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 12: DRONE & SWARM MODELS
// The collective intelligence substrate
// ═══════════════════════════════════════════════════════════════════════════

/** Drone classification */
export type DroneClass =
  | 'Scout'       // Exploration, sensing
  | 'Striker'     // Offense, action
  | 'Guardian'    // Defense, protection
  | 'Relay'       // Communication, coordination
  | 'Medic'       // Repair, healing
  | 'Sovereign';  // Leadership, command

/** Individual drone state */
export interface DroneState {
  id: number;
  droneClass: DroneClass;
  spatial: SpatialState;
  phase: number;          // Kuramoto phase
  omega: number;          // Natural frequency
  signal: number;         // Broadcast strength
  neurochemistry: NeurochemicalState;
  energy: number;
  brainWeights: number[]; // 6×6 micro-brain
  sacrificed: boolean;
  lastBeat: number;
}

/** Swarm-level state */
export interface SwarmState {
  beat: number;
  droneCount: number;
  rSwarm: number;         // Kuramoto order r
  psi: number;            // Mean phase Ψ
  jDrift: number;         // Jasmine drift
  health: OrganismHealth;
  squadrons: SquadronState[];
}

/** Squadron (sub-swarm) state */
export interface SquadronState {
  id: number;
  name: string;
  droneIds: number[];
  coherence: number;
  commander?: number;
  mission?: MissionState;
}

/** Mission state */
export interface MissionState {
  id: number;
  name: string;
  status: MissionStatus;
  objective: GoalTarget;
  assignedDrones: number[];
  progress: number;
  startBeat: number;
  deadline?: number;
}

/** Mission status */
export type MissionStatus =
  | 'Planning'
  | 'Active'
  | 'Paused'
  | 'Complete'
  | 'Failed'
  | 'Aborted';

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 13: ECONOMIC MODELS
// The organism's energy and resource management
// ═══════════════════════════════════════════════════════════════════════════

/** Economic state */
export interface EconomicState {
  formaBalance: number;   // FORMA token balance
  mrcBalance: number;     // MRC token balance
  kntBalance: number;     // KNT token balance
  infoATP: number;        // Information energy
  infoGlucose: number;    // Processing fuel
  entropy: number;        // Shannon entropy
  masterAccumulator: number;
}

/** Transaction types */
export type TransactionType =
  | { type: 'Transfer'; to: string; amount: number; tokenType: TokenType }
  | { type: 'Reward'; reason: string; amount: number }
  | { type: 'Penalty'; reason: string; amount: number }
  | { type: 'Mint'; amount: number }
  | { type: 'Burn'; amount: number }
  | { type: 'Stake'; amount: number; duration: number }
  | { type: 'Unstake'; amount: number };

/** Token types */
export type TokenType = 'FORMA' | 'MRC' | 'KNT' | 'ATP';

/** Transaction record */
export interface Transaction {
  id: number;
  transactionType: TransactionType;
  timestamp: number;
  beat: number;
  sender: string;
  energyCost: number;
  success: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 14: EVENT & AUDIT MODELS
// Tracking what happens in the organism
// ═══════════════════════════════════════════════════════════════════════════

/** Event classification */
export type EventType =
  | { type: 'Lifecycle'; event: LifecycleEvent }
  | { type: 'State'; event: StateEvent }
  | { type: 'Communication'; event: CommunicationEvent }
  | { type: 'Action'; event: ActionEvent }
  | { type: 'Security'; event: SecurityEvent }
  | { type: 'Economic'; event: EconomicEvent };

/** Lifecycle events */
export type LifecycleEvent =
  | { type: 'Birth' }
  | { type: 'FirstBreath' }
  | { type: 'PhaseChange'; phase: LifecyclePhase }
  | { type: 'Death' }
  | { type: 'Resurrection' };

/** State change events */
export type StateEvent =
  | { type: 'CoherenceChange'; oldR: number; newR: number }
  | { type: 'DriveChange'; oldDrive: DriveType; newDrive: DriveType }
  | { type: 'HealthChange'; field: string; delta: number }
  | { type: 'QuantumCollapse'; channel: string; value: number };

/** Communication events */
export type CommunicationEvent =
  | { type: 'MessageSent'; messageId: number; recipients: number }
  | { type: 'MessageReceived'; messageId: number; sender: string }
  | { type: 'SyncCompleted'; partnerId: string; quality: number }
  | { type: 'BondFormed'; partnerId: string }
  | { type: 'BondBroken'; partnerId: string };

/** Action events */
export type ActionEvent =
  | { type: 'ActionStarted'; actionType: string }
  | { type: 'ActionCompleted'; success: boolean; cost: number }
  | { type: 'MissionAssigned'; missionId: number }
  | { type: 'MissionCompleted'; missionId: number; success: boolean };

/** Security events */
export type SecurityEvent =
  | { type: 'ThreatDetected'; threatType: ThreatType; severity: AlertSeverity }
  | { type: 'DefenseActivated'; defenseType: string }
  | { type: 'AnomalyLogged'; score: number; source: string }
  | { type: 'AccessDenied'; principal: string; reason: string };

/** Economic events */
export type EconomicEvent =
  | { type: 'TransactionCompleted'; transaction: Transaction }
  | { type: 'EnergyLow'; level: number }
  | { type: 'RewardEarned'; amount: number; reason: string }
  | { type: 'PenaltyApplied'; amount: number; reason: string };

/** Full event record */
export interface Event {
  id: number;
  eventType: EventType;
  timestamp: number;
  beat: number;
  source: string;
  metadata?: string;
}

/** Audit entry (simplified for logging) */
export interface AuditEntry {
  beat: number;
  kind: string;
  message: string;
  timestamp: number;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 15: CONFIGURATION MODELS
// How the organism is configured
// ═══════════════════════════════════════════════════════════════════════════

/** Organism configuration */
export interface OrganismConfig {
  maxDrones: number;
  heartbeatInterval: number;
  kuramotoK: number;
  sovereignFloor: number;
  hebbianAlpha: number;
  decayRate: number;
  emergenceThreshold: number;
  features: FeatureFlag[];
}

/** Feature flags */
export type FeatureFlag =
  | 'QuantumCoherence'
  | 'HebbianLearning'
  | 'DriveSystem'
  | 'MemoryConsolidation'
  | 'SwarmIntelligence'
  | 'EconomicEngine'
  | 'DreamCycle'
  | 'WarfareCapability'
  | 'ReproductionEnabled';

/** Module configuration */
export interface ModuleConfig {
  name: string;
  enabled: boolean;
  priority: number;
  tickRate: number;        // Every N beats
  params: Map<string, number>;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 16: RESULT & ERROR MODELS
// Standardized responses across the system
// ═══════════════════════════════════════════════════════════════════════════

/** Generic result type */
export type Result<T, E> = 
  | { ok: true; value: T }
  | { ok: false; error: E };

/** Standard error types */
export type OrganismError =
  | { type: 'NotAuthorized'; reason: string }
  | { type: 'InvalidState'; expected: string; actual: string }
  | { type: 'ResourceExhausted'; resource: string }
  | { type: 'NotFound'; entity: string; id: string }
  | { type: 'InvalidInput'; field: string; reason: string }
  | { type: 'InternalError'; message: string }
  | { type: 'NetworkError'; endpoint: string }
  | { type: 'Timeout'; operation: string };

/** Operation response wrapper */
export interface OperationResponse {
  success: boolean;
  message: string;
  data?: number[];
  error?: OrganismError;
  executionTime: number;
  beat: number;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 17: HELPER FUNCTIONS
// Utility functions for working with models
// ═══════════════════════════════════════════════════════════════════════════

/** Create default neurochemical state at sovereign floor */
export function defaultNeurochemistry(): NeurochemicalState {
  return {
    dopamine: SOVEREIGN_FLOOR,
    cortisol: SOVEREIGN_FLOOR,
    norepinephrine: SOVEREIGN_FLOOR,
    oxytocin: SOVEREIGN_FLOOR,
  };
}

/** Create default quantum state */
export function defaultQuantumState(): QuantumState {
  return {
    channels: { alpha: 0.5, beta: 0.5, gamma: 0.5, delta: 0.5 },
    convergence: 0.5,
    coherence: 0.5,
    nowAttention: 0.5,
    entanglement: 0.0,
  };
}

/** Create default drive state */
export function defaultDriveState(): DriveState {
  return {
    hunger: 0.5,
    curiosity: 0.5,
    safety: 0.5,
    social: 0.5,
    reproduction: 0.5,
    dominant: 'Balanced',
  };
}

/** Create default health state */
export function defaultHealth(): OrganismHealth {
  return {
    trustScore: 1.0,
    anomalyScore: 0.0,
    continuityScore: 1.0,
    loadPulse: 0.5,
    stability: 1.0,
  };
}

/** Apply sovereign floor to a value */
export function applySovereignFloor(value: number): number {
  return value < SOVEREIGN_FLOOR ? SOVEREIGN_FLOOR : value;
}

/** Clamp a value between min and max */
export function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

/** Wrap phase to [-π, π] */
export function wrapPhase(theta: number): number {
  let t = theta % TAU;
  if (t > PI) t -= TAU;
  if (t < -PI) t += TAU;
  return t;
}

/** Calculate phase difference */
export function phaseDiff(a: number, b: number): number {
  return wrapPhase(a - b);
}

/** Compute Kuramoto order parameter from phases */
export function computeKuramotoR(phases: number[]): number {
  const n = phases.length;
  if (n === 0) return 0;
  
  let sumCos = 0;
  let sumSin = 0;
  for (const p of phases) {
    sumCos += Math.cos(p);
    sumSin += Math.sin(p);
  }
  sumCos /= n;
  sumSin /= n;
  
  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin);
  return clamp(r, 0, 1);
}

/** Create an empty pulse */
export function emptyPulse(beat: number = 0): OrganismPulse {
  return {
    beat,
    timestamp: Date.now(),
    coherence: 0.5,
    arousal: 0.5,
    drift: 0,
    emergence: 0,
    energy: 100,
    phase: 0,
    health: defaultHealth(),
  };
}

/** Create an empty organism state */
export function emptyOrganismState(id: OrganismId): OrganismState {
  return {
    id,
    phase: 'Genesis',
    pulse: emptyPulse(),
    neurochemistry: defaultNeurochemistry(),
    quantum: defaultQuantumState(),
    drives: defaultDriveState(),
    memory: {
      workingCapacity: 100,
      workingUsed: 0,
      totalMemories: 0,
      compressionRatio: 1.0,
      lastConsolidation: 0,
      hebbianStrength: 1.0,
    },
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 18: TYPE GUARDS
// Runtime type checking utilities
// ═══════════════════════════════════════════════════════════════════════════

/** Check if value is a valid OrganismType */
export function isOrganismType(value: unknown): value is OrganismType {
  return typeof value === 'string' && 
    ['Nova', 'Aura', 'Chasmus', 'Chimera', 'Child'].includes(value);
}

/** Check if value is a valid LifecyclePhase */
export function isLifecyclePhase(value: unknown): value is LifecyclePhase {
  return typeof value === 'string' &&
    ['Genesis', 'FirstBreath', 'Active', 'Dreaming', 'Emergency', 'Dormant', 'Death'].includes(value);
}

/** Check if value is a valid DroneClass */
export function isDroneClass(value: unknown): value is DroneClass {
  return typeof value === 'string' &&
    ['Scout', 'Striker', 'Guardian', 'Relay', 'Medic', 'Sovereign'].includes(value);
}

/** Check if value has OrganismPulse structure */
export function isOrganismPulse(value: unknown): value is OrganismPulse {
  if (typeof value !== 'object' || value === null) return false;
  const pulse = value as Partial<OrganismPulse>;
  return (
    typeof pulse.beat === 'number' &&
    typeof pulse.timestamp === 'number' &&
    typeof pulse.coherence === 'number' &&
    typeof pulse.arousal === 'number' &&
    typeof pulse.drift === 'number' &&
    typeof pulse.emergence === 'number' &&
    typeof pulse.energy === 'number' &&
    typeof pulse.phase === 'number' &&
    typeof pulse.health === 'object'
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 19: SERIALIZATION HELPERS
// For backend ↔ frontend communication
// ═══════════════════════════════════════════════════════════════════════════

/** Serialize pulse to compact array format for transmission */
export function serializePulse(pulse: OrganismPulse): number[] {
  return [
    pulse.beat,
    pulse.timestamp,
    pulse.coherence,
    pulse.arousal,
    pulse.drift,
    pulse.emergence,
    pulse.energy,
    pulse.phase,
    pulse.health.trustScore,
    pulse.health.anomalyScore,
    pulse.health.continuityScore,
    pulse.health.loadPulse,
    pulse.health.stability,
  ];
}

/** Deserialize pulse from compact array format */
export function deserializePulse(data: number[]): OrganismPulse {
  return {
    beat: data[0] ?? 0,
    timestamp: data[1] ?? Date.now(),
    coherence: data[2] ?? 0.5,
    arousal: data[3] ?? 0.5,
    drift: data[4] ?? 0,
    emergence: data[5] ?? 0,
    energy: data[6] ?? 100,
    phase: data[7] ?? 0,
    health: {
      trustScore: data[8] ?? 1.0,
      anomalyScore: data[9] ?? 0,
      continuityScore: data[10] ?? 1.0,
      loadPulse: data[11] ?? 0.5,
      stability: data[12] ?? 1.0,
    },
  };
}

/** Serialize neurochemistry to compact array */
export function serializeNeurochemistry(neuro: NeurochemicalState): number[] {
  return [neuro.dopamine, neuro.cortisol, neuro.norepinephrine, neuro.oxytocin];
}

/** Deserialize neurochemistry from compact array */
export function deserializeNeurochemistry(data: number[]): NeurochemicalState {
  return {
    dopamine: data[0] ?? SOVEREIGN_FLOOR,
    cortisol: data[1] ?? SOVEREIGN_FLOOR,
    norepinephrine: data[2] ?? SOVEREIGN_FLOOR,
    oxytocin: data[3] ?? SOVEREIGN_FLOOR,
  };
}

/** Serialize quantum state to compact array */
export function serializeQuantumState(q: QuantumState): number[] {
  return [
    q.channels.alpha,
    q.channels.beta,
    q.channels.gamma,
    q.channels.delta,
    q.convergence,
    q.coherence,
    q.nowAttention,
    q.entanglement,
  ];
}

/** Deserialize quantum state from compact array */
export function deserializeQuantumState(data: number[]): QuantumState {
  return {
    channels: {
      alpha: data[0] ?? 0.5,
      beta: data[1] ?? 0.5,
      gamma: data[2] ?? 0.5,
      delta: data[3] ?? 0.5,
    },
    convergence: data[4] ?? 0.5,
    coherence: data[5] ?? 0.5,
    nowAttention: data[6] ?? 0.5,
    entanglement: data[7] ?? 0,
  };
}
