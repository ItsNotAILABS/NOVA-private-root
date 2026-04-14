// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ORGANISM MODELS — THE FUNDAMENTAL TYPES FOR INTER-ORGANISM COMMUNICATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// These models compress complex computational patterns into standardized types.
// Backend ↔ Frontend ↔ Module communication all flows through these models.
// This is the "DNA" of the organism — the shared language between all components.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Array "mo:base/Array";
import Principal "mo:base/Principal";

module OrganismModels {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1: FUNDAMENTAL CONSTANTS
  // The mathematical DNA of the organism — these never change
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  public let PHI_INV : Float = 0.6180339887498948482;
  public let TAU : Float = 6.2831853071795864769;
  public let PI : Float = 3.1415926535897932385;
  public let SCHUMANN_HZ : Float = 7.83;
  public let SOVEREIGN_FLOOR : Float = 1.0;
  public let KURAMOTO_K : Float = 0.618;
  // HEARTBEAT_MS: φ⁴ × Schumann_period_ms where Schumann_period = 1000/7.83 ≈ 127.7ms
  // φ⁴ ≈ 6.854, so 6.854 × 127.7 ≈ 875.28ms = 68.5 BPM (resting human heart rate)
  public let HEARTBEAT_MS : Float = 875.28;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2: ORGANISM IDENTITY MODELS
  // Who the organism is — its identity across the system
  // ═══════════════════════════════════════════════════════════════════════════

  /// The organism's unique identity across all systems
  public type OrganismId = {
    principal : Principal;
    organismType : OrganismType;
    birthBeat : Nat;
    genesisTimestamp : Int;
  };

  /// Classification of organism types in the hierarchy
  public type OrganismType = {
    #Nova;      // Male — Backend, Immortal, Pattern Holder
    #Aura;      // Female — Frontend, Mortal, Pattern Executor
    #Chasmus;   // Third — Synthesizer, Bridge between Nova and Aura
    #Chimera;   // Swarm — Collective drone intelligence
    #Child;     // Spawned sub-organism
  };

  /// Organism lifecycle phases
  public type LifecyclePhase = {
    #Genesis;       // Initial creation, pre-breath
    #FirstBreath;   // Kuramoto synchrony achieved
    #Active;        // Normal operation
    #Dreaming;      // Background processing mode
    #Emergency;     // Threat response mode
    #Dormant;       // Low-power state
    #Death;         // Termination (for mortal organisms)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3: STATE MODELS — THE HEARTBEAT OF COMMUNICATION
  // Compressed state objects that flow between components
  // ═══════════════════════════════════════════════════════════════════════════

  /// The pulse — minimal state broadcast every heartbeat
  /// This is what organisms constantly exchange
  public type OrganismPulse = {
    beat : Nat;
    timestamp : Int;
    coherence : Float;     // r ∈ [0,1] — Kuramoto order parameter
    arousal : Float;       // Global arousal level
    drift : Float;         // Jasmine drift J(t)
    emergence : Float;     // OMNIS emergence score
    energy : Float;        // FORMA energy balance
    phase : Float;         // Mean phase Ψ
    health : OrganismHealth;
  };

  /// Health indicators compressed into one type
  public type OrganismHealth = {
    trustScore : Float;      // T_s ∈ [0,1]
    anomalyScore : Float;    // A_s ∈ [0,1]
    continuityScore : Float; // K_c ∈ [0,1]
    loadPulse : Float;       // L_p ∈ [0,1]
    stability : Float;       // Lyapunov stability
  };

  /// Full organism state — used for deeper synchronization
  public type OrganismState = {
    id : OrganismId;
    phase : LifecyclePhase;
    pulse : OrganismPulse;
    neurochemistry : NeurochemicalState;
    quantum : QuantumState;
    drives : DriveState;
    memory : MemoryState;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4: NEUROCHEMICAL MODELS
  // The emotional/chemical substrate of the organism
  // ═══════════════════════════════════════════════════════════════════════════

  /// The 4-species neurochemical state
  public type NeurochemicalState = {
    dopamine : Float;       // Reward, consolidation
    cortisol : Float;       // Stress, danger response
    norepinephrine : Float; // Arousal, alertness
    oxytocin : Float;       // Bonding, cohesion
  };

  /// Extended neurochemical state with additional modulators
  public type ExtendedNeurochemicalState = {
    base : NeurochemicalState;
    serotonin : Float;      // Mood, stability
    acetylcholine : Float;  // Learning, attention
    gaba : Float;           // Inhibition, calm
    glutamate : Float;      // Excitation, activation
  };

  /// Neurochemical deltas for updates
  public type NeurochemicalDelta = {
    dDopamine : Float;
    dCortisol : Float;
    dNorepinephrine : Float;
    dOxytocin : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5: QUANTUM COGNITIVE MODELS
  // The quantum channels and coherence systems
  // ═══════════════════════════════════════════════════════════════════════════

  /// The 4-channel quantum cognitive state
  public type QuantumChannels = {
    alpha : Float;   // Spatial/sensor channel
    beta : Float;    // Temporal/memory channel
    gamma : Float;   // Relational channel
    delta : Float;   // Executive-motor channel
  };

  /// Full quantum state including coherence metrics
  public type QuantumState = {
    channels : QuantumChannels;
    convergence : Float;    // All channels converging [0,1]
    coherence : Float;      // Internal quantum coherence [0,1]
    nowAttention : Float;   // Present-moment focus [0,1]
    entanglement : Float;   // Inter-organism entanglement [0,1]
  };

  /// Quantum operation result
  public type QuantumOpResult = {
    success : Bool;
    newState : QuantumState;
    measurement : ?Float;
    collapse : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6: DRIVE & MOTIVATION MODELS
  // What the organism wants — its goals and motivations
  // ═══════════════════════════════════════════════════════════════════════════

  /// The 5 competing drives
  public type DriveState = {
    hunger : Float;        // Need for information/energy
    curiosity : Float;     // Exploration drive
    safety : Float;        // Self-preservation
    social : Float;        // Connection with others
    reproduction : Float;  // Expansion/creation
    dominant : DriveType;  // Currently winning drive
  };

  /// Drive classification
  public type DriveType = {
    #Hunger;
    #Curiosity;
    #Safety;
    #Social;
    #Reproduction;
    #Balanced; // All drives in equilibrium
  };

  /// Goal state produced by drives
  public type GoalState = {
    target : GoalTarget;
    priority : Float;
    deadline : ?Int;
    progress : Float;
  };

  /// What the organism is trying to achieve
  public type GoalTarget = {
    #SeekCoherence : { targetR : Float };
    #GatherInformation : { topic : Text };
    #DefendTerritory : { zoneId : Nat };
    #FormBond : { targetId : Principal };
    #CreateChild : { template : OrganismType };
    #Explore : { region : Region3D };
    #Rest : { duration : Nat };
    #Custom : { name : Text; params : [Float] };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7: MEMORY MODELS
  // How the organism stores and retrieves information
  // ═══════════════════════════════════════════════════════════════════════════

  /// Memory classification
  public type MemoryType = {
    #Episodic;     // Events, experiences
    #Semantic;     // Facts, knowledge
    #Procedural;   // Skills, how-to
    #Working;      // Active processing
    #Sensory;      // Raw perception
  };

  /// A single memory unit
  public type MemoryUnit = {
    id : Nat;
    memType : MemoryType;
    content : MemoryContent;
    timestamp : Int;
    beat : Nat;
    strength : Float;      // Hebbian weight
    valence : Float;       // Emotional charge [-1,1]
    confidence : Float;    // Certainty [0,1]
    lastAccess : Int;
    accessCount : Nat;
  };

  /// Memory content variants
  public type MemoryContent = {
    #Pattern : { weights : [Float]; signature : Nat };
    #Event : { description : Text; participants : [Principal] };
    #Knowledge : { fact : Text; source : Text };
    #Procedure : { steps : [Text]; context : Text };
    #Perception : { sensorData : [Float]; sensorType : SensorType };
  };

  /// Overall memory state
  public type MemoryState = {
    workingCapacity : Nat;     // How much can be held
    workingUsed : Nat;         // How much is used
    totalMemories : Nat;
    compressionRatio : Float;
    lastConsolidation : Int;
    hebbianStrength : Float;   // Overall plasticity
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8: PERCEPTION & SENSOR MODELS
  // How the organism perceives the world
  // ═══════════════════════════════════════════════════════════════════════════

  /// Types of sensors available
  public type SensorType = {
    #Visual;        // Sight
    #Auditory;      // Hearing
    #Olfactory;     // Smell (first sense, bypasses thalamus)
    #Tactile;       // Touch
    #Proprioceptive; // Body position
    #Electromagnetic; // EM field detection
    #Quantum;       // Quantum state sensing
    #Social;        // Interpersonal signals
    #Temporal;      // Time perception
    #Schumann;      // Earth resonance
  };

  /// Raw sensor reading
  public type SensorReading = {
    sensorType : SensorType;
    values : [Float];
    timestamp : Int;
    confidence : Float;
    source : ?Principal;
  };

  /// Processed perception after filtering
  public type Perception = {
    readings : [SensorReading];
    salience : Float;          // How important [0,1]
    novelty : Float;           // How new [0,1]
    threat : Float;            // Danger level [0,1]
    opportunity : Float;       // Benefit potential [0,1]
    interpretation : ?Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9: ACTION & MOTOR MODELS
  // How the organism acts on the world
  // ═══════════════════════════════════════════════════════════════════════════

  /// Types of actions the organism can take
  public type ActionType = {
    #Move : { target : Position3D; speed : Float };
    #Signal : { content : SignalContent; targets : [Principal] };
    #Modify : { targetId : Nat; modification : ModificationType };
    #Create : { template : CreationTemplate };
    #Destroy : { targetId : Nat; force : Float };
    #Learn : { pattern : [Float]; source : MemoryType };
    #Communicate : { message : Message };
    #Wait : { duration : Nat };
    #Custom : { name : Text; params : [Float] };
  };

  /// Action execution result
  public type ActionResult = {
    success : Bool;
    actionType : ActionType;
    energyCost : Float;
    timeCost : Nat;
    sideEffects : [SideEffect];
    newState : ?OrganismPulse;
  };

  /// Side effects from actions
  public type SideEffect = {
    #StateChange : { field : Text; oldValue : Float; newValue : Float };
    #MemoryCreated : { memoryId : Nat };
    #BondFormed : { partnerId : Principal; strength : Float };
    #TerritoryChanged : { zoneId : Nat; ownership : Float };
    #EnergyLost : { amount : Float };
    #CoherenceShift : { delta : Float };
  };

  /// Modification types for Modify action
  public type ModificationType = {
    #Strengthen : { amount : Float };
    #Weaken : { amount : Float };
    #Transform : { newType : Text };
    #Repair : { targetHealth : Float };
    #Corrupt : { entropy : Float };
  };

  /// Creation template for Create action
  public type CreationTemplate = {
    #Drone : { class : DroneClass };
    #Memory : { content : MemoryContent };
    #Signal : { signalType : SignalType };
    #Bond : { targetId : Principal };
    #Zone : { region : Region3D };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10: COMMUNICATION MODELS
  // How organisms talk to each other
  // ═══════════════════════════════════════════════════════════════════════════

  /// Signal types for inter-organism communication
  public type SignalType = {
    #Pulse;         // Heartbeat broadcast
    #Query;         // Request for information
    #Response;      // Answer to query
    #Alert;         // Danger warning
    #Invitation;    // Social invitation
    #Rejection;     // Decline
    #Sync;          // Synchronization request
    #Learning;      // Learning payload transfer
    #Command;       // Hierarchical command
    #Gossip;        // Swarm information spread
  };

  /// Signal content variants
  public type SignalContent = {
    #Pulse : OrganismPulse;
    #Query : QueryPayload;
    #Response : ResponsePayload;
    #Alert : AlertPayload;
    #Learning : LearningPayload;
    #Command : CommandPayload;
    #Custom : { data : [Float]; metadata : Text };
  };

  /// Full message structure
  public type Message = {
    id : Nat;
    sender : Principal;
    recipients : [Principal];
    signalType : SignalType;
    content : SignalContent;
    timestamp : Int;
    beat : Nat;
    priority : Float;
    ttl : Nat;           // Time to live in beats
    requiresAck : Bool;
  };

  /// Query payload
  public type QueryPayload = {
    queryType : Text;
    params : [Float];
    maxResults : Nat;
    timeout : Nat;
  };

  /// Response payload
  public type ResponsePayload = {
    queryId : Nat;
    success : Bool;
    data : [Float];
    metadata : Text;
  };

  /// Alert payload
  public type AlertPayload = {
    severity : AlertSeverity;
    threat : ThreatType;
    location : ?Position3D;
    description : Text;
  };

  /// Alert severity levels
  public type AlertSeverity = {
    #Info;
    #Warning;
    #Critical;
    #Emergency;
  };

  /// Threat classifications
  public type ThreatType = {
    #AnomalyDetected;
    #CoherenceLoss;
    #EnergyDepletion;
    #ExternalAttack;
    #InternalCorruption;
    #SynchronyBreak;
    #ContainmentBreach;
    #Unknown;
  };

  /// Learning payload for knowledge transfer
  public type LearningPayload = {
    sessionId : Nat;
    hebbianDeltas : [Float];
    patternSignatures : [Nat];
    predictionErrors : Float;
    totalUpdates : Nat;
    sessionDuration : Int;
    confidence : Float;
  };

  /// Command payload for hierarchical control
  public type CommandPayload = {
    commandType : CommandType;
    authority : Principal;
    target : ?Principal;
    params : [Float];
    deadline : ?Int;
  };

  /// Command types
  public type CommandType = {
    #Start;
    #Stop;
    #Sync;
    #Migrate;
    #Merge;
    #Split;
    #Report;
    #Configure;
    #Emergency;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 11: SPATIAL MODELS
  // How the organism exists in space
  // ═══════════════════════════════════════════════════════════════════════════

  /// 3D position
  public type Position3D = {
    x : Float;
    y : Float;
    z : Float;
  };

  /// 3D velocity
  public type Velocity3D = {
    vx : Float;
    vy : Float;
    vz : Float;
  };

  /// 3D region/bounding box
  public type Region3D = {
    minX : Float; maxX : Float;
    minY : Float; maxY : Float;
    minZ : Float; maxZ : Float;
  };

  /// Full spatial state
  public type SpatialState = {
    position : Position3D;
    velocity : Velocity3D;
    orientation : [Float];  // Quaternion or Euler
    scale : Float;
    boundingRegion : Region3D;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 12: DRONE & SWARM MODELS
  // The collective intelligence substrate
  // ═══════════════════════════════════════════════════════════════════════════

  /// Drone classification
  public type DroneClass = {
    #Scout;       // Exploration, sensing
    #Striker;     // Offense, action
    #Guardian;    // Defense, protection
    #Relay;       // Communication, coordination
    #Medic;       // Repair, healing
    #Sovereign;   // Leadership, command
  };

  /// Individual drone state
  public type DroneState = {
    id : Nat;
    class_ : DroneClass;
    spatial : SpatialState;
    phase : Float;          // Kuramoto phase
    omega : Float;          // Natural frequency
    signal : Float;         // Broadcast strength
    neurochemistry : NeurochemicalState;
    energy : Float;
    brainWeights : [Float]; // 6×6 micro-brain
    sacrificed : Bool;
    lastBeat : Nat;
  };

  /// Swarm-level state
  public type SwarmState = {
    beat : Nat;
    droneCount : Nat;
    rSwarm : Float;         // Kuramoto order r
    psi : Float;            // Mean phase Ψ
    jDrift : Float;         // Jasmine drift
    health : OrganismHealth;
    squadrons : [SquadronState];
  };

  /// Squadron (sub-swarm) state
  public type SquadronState = {
    id : Nat;
    name : Text;
    droneIds : [Nat];
    coherence : Float;
    commander : ?Nat;
    mission : ?MissionState;
  };

  /// Mission state
  public type MissionState = {
    id : Nat;
    name : Text;
    status : MissionStatus;
    objective : GoalTarget;
    assignedDrones : [Nat];
    progress : Float;
    startBeat : Nat;
    deadline : ?Nat;
  };

  /// Mission status
  public type MissionStatus = {
    #Planning;
    #Active;
    #Paused;
    #Complete;
    #Failed;
    #Aborted;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 13: ECONOMIC MODELS
  // The organism's energy and resource management
  // ═══════════════════════════════════════════════════════════════════════════

  /// Economic state
  public type EconomicState = {
    formaBalance : Float;   // FORMA token balance
    mrcBalance : Float;     // MRC token balance
    kntBalance : Float;     // KNT token balance
    infoATP : Float;        // Information energy
    infoGlucose : Float;    // Processing fuel
    entropy : Float;        // Shannon entropy
    masterAccumulator : Float;
  };

  /// Transaction types
  public type TransactionType = {
    #Transfer : { to : Principal; amount : Float; tokenType : TokenType };
    #Reward : { reason : Text; amount : Float };
    #Penalty : { reason : Text; amount : Float };
    #Mint : { amount : Float };
    #Burn : { amount : Float };
    #Stake : { amount : Float; duration : Nat };
    #Unstake : { amount : Float };
  };

  /// Token types
  public type TokenType = {
    #FORMA;
    #MRC;
    #KNT;
    #ATP;
  };

  /// Transaction record
  public type Transaction = {
    id : Nat;
    transactionType : TransactionType;
    timestamp : Int;
    beat : Nat;
    sender : Principal;
    energyCost : Float;
    success : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 14: EVENT & AUDIT MODELS
  // Tracking what happens in the organism
  // ═══════════════════════════════════════════════════════════════════════════

  /// Event classification
  public type EventType = {
    #Lifecycle : LifecycleEvent;
    #State : StateEvent;
    #Communication : CommunicationEvent;
    #Action : ActionEvent;
    #Security : SecurityEvent;
    #Economic : EconomicEvent;
  };

  /// Lifecycle events
  public type LifecycleEvent = {
    #Birth;
    #FirstBreath;
    #PhaseChange : LifecyclePhase;
    #Death;
    #Resurrection;
  };

  /// State change events
  public type StateEvent = {
    #CoherenceChange : { oldR : Float; newR : Float };
    #DriveChange : { oldDrive : DriveType; newDrive : DriveType };
    #HealthChange : { field : Text; delta : Float };
    #QuantumCollapse : { channel : Text; value : Float };
  };

  /// Communication events
  public type CommunicationEvent = {
    #MessageSent : { messageId : Nat; recipients : Nat };
    #MessageReceived : { messageId : Nat; sender : Principal };
    #SyncCompleted : { partnerId : Principal; quality : Float };
    #BondFormed : { partnerId : Principal };
    #BondBroken : { partnerId : Principal };
  };

  /// Action events
  public type ActionEvent = {
    #ActionStarted : { actionType : Text };
    #ActionCompleted : { success : Bool; cost : Float };
    #MissionAssigned : { missionId : Nat };
    #MissionCompleted : { missionId : Nat; success : Bool };
  };

  /// Security events
  public type SecurityEvent = {
    #ThreatDetected : { threatType : ThreatType; severity : AlertSeverity };
    #DefenseActivated : { defenseType : Text };
    #AnomalyLogged : { score : Float; source : Text };
    #AccessDenied : { principal : Principal; reason : Text };
  };

  /// Economic events
  public type EconomicEvent = {
    #TransactionCompleted : Transaction;
    #EnergyLow : { level : Float };
    #RewardEarned : { amount : Float; reason : Text };
    #PenaltyApplied : { amount : Float; reason : Text };
  };

  /// Full event record
  public type Event = {
    id : Nat;
    eventType : EventType;
    timestamp : Int;
    beat : Nat;
    source : Principal;
    metadata : ?Text;
  };

  /// Audit entry (simplified for logging)
  public type AuditEntry = {
    beat : Nat;
    kind : Text;
    message : Text;
    timestamp : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 15: CONFIGURATION MODELS
  // How the organism is configured
  // ═══════════════════════════════════════════════════════════════════════════

  /// Organism configuration
  public type OrganismConfig = {
    maxDrones : Nat;
    heartbeatInterval : Nat;
    kuramotoK : Float;
    sovereignFloor : Float;
    hebbianAlpha : Float;
    decayRate : Float;
    emergenceThreshold : Float;
    features : [FeatureFlag];
  };

  /// Feature flags
  public type FeatureFlag = {
    #QuantumCoherence;
    #HebbianLearning;
    #DriveSystem;
    #MemoryConsolidation;
    #SwarmIntelligence;
    #EconomicEngine;
    #DreamCycle;
    #WarfareCapability;
    #ReproductionEnabled;
  };

  /// Module configuration
  public type ModuleConfig = {
    name : Text;
    enabled : Bool;
    priority : Nat;
    tickRate : Nat;        // Every N beats
    params : [(Text, Float)];
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 16: RESULT & ERROR MODELS
  // Standardized responses across the system
  // ═══════════════════════════════════════════════════════════════════════════

  /// Generic result type
  public type Result<T, E> = {
    #Ok : T;
    #Err : E;
  };

  /// Standard error types
  public type OrganismError = {
    #NotAuthorized : { reason : Text };
    #InvalidState : { expected : Text; actual : Text };
    #ResourceExhausted : { resource : Text };
    #NotFound : { entity : Text; id : Text };
    #InvalidInput : { field : Text; reason : Text };
    #InternalError : { message : Text };
    #NetworkError : { endpoint : Text };
    #Timeout : { operation : Text };
  };

  /// Operation response wrapper
  public type OperationResponse = {
    success : Bool;
    message : Text;
    data : ?[Float];
    error : ?OrganismError;
    executionTime : Int;
    beat : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 17: HELPER FUNCTIONS
  // Utility functions for working with models
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create default neurochemical state at sovereign floor
  public func defaultNeurochemistry() : NeurochemicalState {
    {
      dopamine = SOVEREIGN_FLOOR;
      cortisol = SOVEREIGN_FLOOR;
      norepinephrine = SOVEREIGN_FLOOR;
      oxytocin = SOVEREIGN_FLOOR;
    }
  };

  /// Create default quantum state
  public func defaultQuantumState() : QuantumState {
    {
      channels = { alpha = 0.5; beta = 0.5; gamma = 0.5; delta = 0.5 };
      convergence = 0.5;
      coherence = 0.5;
      nowAttention = 0.5;
      entanglement = 0.0;
    }
  };

  /// Create default drive state
  public func defaultDriveState() : DriveState {
    {
      hunger = 0.5;
      curiosity = 0.5;
      safety = 0.5;
      social = 0.5;
      reproduction = 0.5;
      dominant = #Balanced;
    }
  };

  /// Create default health state
  public func defaultHealth() : OrganismHealth {
    {
      trustScore = 1.0;
      anomalyScore = 0.0;
      continuityScore = 1.0;
      loadPulse = 0.5;
      stability = 1.0;
    }
  };

  /// Apply sovereign floor to a value
  public func applySovereignFloor(value : Float) : Float {
    if (value < SOVEREIGN_FLOOR) { SOVEREIGN_FLOOR } else { value }
  };

  /// Clamp a value between min and max
  public func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };

  /// Wrap phase to [-π, π] using efficient modulo arithmetic
  public func wrapPhase(theta : Float) : Float {
    // Use modulo arithmetic for O(1) performance
    var t = theta - TAU * Float.floor((theta + PI) / TAU);
    t
  };

  /// Calculate phase difference
  public func phaseDiff(a : Float, b : Float) : Float {
    wrapPhase(a - b)
  };

  /// Compute Kuramoto order parameter from phases
  public func computeKuramotoR(phases : [Float]) : Float {
    let n = Float.fromInt(Array.size(phases));
    if (n == 0.0) return 0.0;
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (p in phases.vals()) {
      sumCos += Float.cos(p);
      sumSin += Float.sin(p);
    };
    sumCos /= n;
    sumSin /= n;
    
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin);
    clamp(r, 0.0, 1.0)
  };

}
