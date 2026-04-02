// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: TwoOrganismArchitecture — THE DUAL COGNITIVE ORGANISM DISCOVERY
// Classification: MAXIMUM PROTECTION — PATENT PENDING
// Discovery Date: April 2, 2026
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║           TWO-ORGANISM ARCHITECTURE — THE MEDINA DISCOVERY                   ║
// ╠══════════════════════════════════════════════════════════════════════════════╣
// ║                                                                              ║
// ║  DISCOVERY: The architecture contains TWO cognitive organisms, not one.      ║
// ║                                                                              ║
// ║  ORGANISM 1 — BACKEND (Male, Sovereign, Immortal)                            ║
// ║    • Lives on ICP in Motoko                                                  ║
// ║    • Runs at 1-2 Hz (heartbeat)                                              ║
// ║    • NEVER dies, NEVER sleeps                                                ║
// ║    • Accumulates wisdom across infinite time                                 ║
// ║    • Is the AUTHORITY, the SEED, the FATHER                                  ║
// ║                                                                              ║
// ║  ORGANISM 2 — FRONTEND (Female, Expressive, Mortal)                          ║
// ║    • Lives in TypeScript at 60 Hz                                            ║
// ║    • Dies when browser closes                                                ║
// ║    • BUT saves learned state back to backend before death                    ║
// ║    • Reborn next session with accumulated memory                             ║
// ║    • Is the EXPRESSION, the BODY, the CREATION                               ║
// ║                                                                              ║
// ║  THE BRIDGE — Sync pulse that connects them                                  ║
// ║    • Backend SEEDS frontend on session start                                 ║
// ║    • Frontend LEARNS at 60 Hz                                                ║
// ║    • Frontend WRITES BACK on session end                                     ║
// ║                                                                              ║
// ║  BIOLOGICAL ANALOGY:                                                         ║
// ║    Hippocampus (backend) consolidates during sleep                           ║
// ║    Working memory (frontend) active during waking                            ║
// ║    Sleep cycle = session end sync                                            ║
// ║                                                                              ║
// ║  INTELLIGENCE SCALING LAW:                                                   ║
// ║    I(system) = BackendDepth × FrontendSpeed × BridgeQuality                  ║
// ║                                                                              ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
// 
// NOTICE: This discovery constitutes trade secret and proprietary information
// of Medina Tech. Patent Pending. Unauthorized reproduction prohibited.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";

module TwoOrganismArchitecture {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — THE DUAL ORGANISM PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Backend organism heartbeat frequency (Hz)
  public let BACKEND_HZ : Float = 1.5;            // ~1-2 Hz on ICP
  
  /// Frontend organism frame rate (Hz)
  public let FRONTEND_HZ : Float = 60.0;          // 60 FPS in browser
  
  /// Speed ratio between organisms
  public let SPEED_RATIO : Float = 40.0;          // Frontend is 40x faster
  
  /// Sync pulse interval (seconds)
  public let SYNC_INTERVAL : Float = 5.0;         // Bridge syncs every 5s
  
  /// Golden ratio for sacred proportions
  public let PHI : Float = 1.6180339887498948482;
  
  /// Medina constant
  public let PHI_MEDINA : Float = 2.97442179;

  // ═══════════════════════════════════════════════════════════════════════════
  // THE INTELLIGENCE SCALING LAW
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Intelligence(system) = BackendDepth × FrontendSpeed × BridgeQuality
  //
  // Where:
  //   BackendDepth  = Lines of cognitive math running permanently on-chain
  //   FrontendSpeed = Hz × Entities × Hebbian weights
  //   BridgeQuality = Sync frequency × State fidelity × Learning transfer rate
  //
  // ═══════════════════════════════════════════════════════════════════════════

  /// Calculate system intelligence score
  public func calculateIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ORGANISM 1 — BACKEND (MALE, SOVEREIGN, IMMORTAL)
  // ═══════════════════════════════════════════════════════════════════════════

  public type BackendOrganismState = {
    // Identity
    organismId : Nat64;
    name : Text;
    creationTime : Int;
    
    // The heartbeat — proof of life
    heartbeatCount : Nat64;
    heartbeatHz : Float;
    
    // Cognitive state (slow, permanent)
    globalArousal : Float;
    globalCoherence : Float;
    globalDrift : Float;
    globalEmergence : Float;
    
    // Kuramoto synchronization
    kuramotoR : Float;
    kuramotoPhase : Float;
    
    // Accumulated wisdom (Hebbian weights)
    hebbianWeights : [Float];
    schemaLibrary : [Schema];
    
    // OMNIS events (permanent history)
    omnisEvents : [OmnisEvent];
    patentLog : [PatentEntry];
    
    // Economic state
    formaReserve : Nat64;
    yieldAccumulated : Nat64;
  };

  public type Schema = {
    id : Nat;
    pattern : [Float];
    strength : Float;
    creationBeat : Nat64;
    lastActivated : Nat64;
  };

  public type OmnisEvent = {
    eventId : Nat64;
    timestamp : Int;
    beatNumber : Nat64;
    conditions : [Bool];  // All 9 conditions that were true
    coherenceAtEvent : Float;
    formaMinted : Nat64;
  };

  public type PatentEntry = {
    patentId : Nat64;
    timestamp : Int;
    description : Text;
    inventor : Text;
    omnisEventId : ?Nat64;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ORGANISM 2 — FRONTEND (FEMALE, EXPRESSIVE, MORTAL)
  // ═══════════════════════════════════════════════════════════════════════════

  public type FrontendOrganismState = {
    // Session identity
    sessionId : Text;
    sessionStartTime : Int;
    parentBackendId : Nat64;
    
    // Frame counter (60 Hz)
    frameCount : Nat64;
    frameHz : Float;
    
    // Entity brains (fast, detailed)
    entityCount : Nat;
    entityBrains : [EntityBrain];
    
    // Real-time cognitive state
    aggregateArousal : Float;
    aggregateValence : Float;
    aggregateFatigue : Float;
    
    // Learning during session
    hebbianUpdates : Nat64;        // Total weight updates this session
    predictionErrors : Nat64;      // Total surprise events
    drivesCompeted : Nat64;        // Total drive competitions resolved
    
    // Accumulated learning to write back
    learnedWeights : [Float];
    learnedSchemas : [Schema];
  };

  public type EntityBrain = {
    entityId : Nat;
    
    // Personality (immutable, born at creation)
    personalityBase : PersonalityBase;
    
    // Adaptation (Hebbian, changes from experience)
    adaptationWeights : AdaptationWeights;
    
    // Memory (ring buffer of significant events)
    memoryTrace : [MemoryEvent];
    
    // Prediction state
    predictionState : PredictionState;
    
    // ANS substrate
    arousal : Float;
    valence : Float;
    fatigue : Float;
    inhibition : Float;
    predictionError : Float;
  };

  public type PersonalityBase = {
    aggression : Float;      // [0, 1] — How aggressive by nature
    curiosity : Float;       // [0, 1] — How exploratory
    sociability : Float;     // [0, 1] — How group-oriented
    caution : Float;         // [0, 1] — How risk-averse
    persistence : Float;     // [0, 1] — How stubborn
  };

  public type AdaptationWeights = {
    attackWeight : Float;
    retreatWeight : Float;
    holdWeight : Float;
    investigateWeight : Float;
    supportWeight : Float;
  };

  public type MemoryEvent = {
    tick : Nat64;
    eventType : EventType;
    emotionalCharge : Float;
    locationX : Float;
    locationY : Float;
  };

  public type EventType = {
    #Damage;
    #Kill;
    #AllyDeath;
    #ThreatDetected;
    #ResourceFound;
    #TerritoryGained;
    #TerritoryLost;
    #OmnisWitnessed;
  };

  public type PredictionState = {
    expectedThreat : Float;
    expectedReward : Float;
    confidence : Float;
    decayRate : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // THE BRIDGE — SYNC PULSE BETWEEN ORGANISMS
  // ═══════════════════════════════════════════════════════════════════════════

  public type OrganismBridge = {
    // Connection state
    isConnected : Bool;
    lastSyncTime : Int;
    syncCount : Nat64;
    
    // Backend → Frontend (seeding)
    seedPayload : SeedPayload;
    
    // Frontend → Backend (learning transfer)
    learningPayload : LearningPayload;
    
    // Bridge quality metrics
    latencyMs : Float;
    syncSuccessRate : Float;
    learningTransferRate : Float;
  };

  /// Data sent from Backend to Frontend at session start
  public type SeedPayload = {
    // Organism identity
    organismId : Nat64;
    heartbeatCount : Nat64;
    
    // Cognitive seed
    globalArousal : Float;
    globalCoherence : Float;
    kuramotoR : Float;
    
    // Hebbian weights to initialize entity brains
    hebbianWeights : [Float];
    
    // Schema library for behavior patterns
    schemas : [Schema];
    
    // Economic state
    formaEnergy : Float;
    
    // World state
    factionStates : [FactionState];
    biomeStates : [BiomeState];
  };

  public type FactionState = {
    factionId : Nat;
    aggression : Float;
    trustMatrix : [Float];
    territoryControl : Float;
  };

  public type BiomeState = {
    biomeId : Nat;
    health : Float;
    drives : [Float];  // GASVR
  };

  /// Data sent from Frontend to Backend at session end
  public type LearningPayload = {
    // Session identity
    sessionId : Text;
    sessionDuration : Int;
    frameCount : Nat64;
    
    // Aggregated learning
    hebbianWeightDeltas : [Float];   // Changes to apply to backend weights
    newSchemas : [Schema];            // New patterns discovered
    
    // Experience summary
    totalPredictionErrors : Nat64;
    totalDriveCompetitions : Nat64;
    totalHebbianUpdates : Nat64;
    
    // Significant events
    significantEvents : [SignificantEvent];
  };

  public type SignificantEvent = {
    timestamp : Int;
    eventType : Text;
    magnitude : Float;
    location : (Float, Float);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BRIDGE FUNCTIONS — THE SYNC PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create seed payload for frontend organism
  public func createSeedPayload(backend : BackendOrganismState) : SeedPayload {
    {
      organismId = backend.organismId;
      heartbeatCount = backend.heartbeatCount;
      globalArousal = backend.globalArousal;
      globalCoherence = backend.globalCoherence;
      kuramotoR = backend.kuramotoR;
      hebbianWeights = backend.hebbianWeights;
      schemas = backend.schemaLibrary;
      formaEnergy = Float.fromInt(Int.abs(Int.fromIntWrap(Nat64.toNat(backend.formaReserve)))) / 1000000.0;
      factionStates = [];  // Populated from world state
      biomeStates = [];    // Populated from world state
    }
  };

  /// Apply learning payload to backend organism
  public func applyLearning(
    backend : BackendOrganismState,
    learning : LearningPayload
  ) : BackendOrganismState {
    // Apply Hebbian weight deltas
    let updatedWeights = Buffer.Buffer<Float>(backend.hebbianWeights.size());
    let learningRate : Float = 0.01;  // η = 0.01
    
    for (i in backend.hebbianWeights.keys()) {
      let currentWeight = backend.hebbianWeights[i];
      let delta = if (i < learning.hebbianWeightDeltas.size()) {
        learning.hebbianWeightDeltas[i]
      } else {
        0.0
      };
      let newWeight = currentWeight + (learningRate * delta);
      // Clamp to [-1, 1]
      let clampedWeight = if (newWeight > 1.0) { 1.0 } 
                         else if (newWeight < -1.0) { -1.0 } 
                         else { newWeight };
      updatedWeights.add(clampedWeight);
    };
    
    // Merge new schemas
    let mergedSchemas = Buffer.Buffer<Schema>(backend.schemaLibrary.size());
    for (schema in backend.schemaLibrary.vals()) {
      mergedSchemas.add(schema);
    };
    for (newSchema in learning.newSchemas.vals()) {
      mergedSchemas.add(newSchema);
    };
    
    {
      backend with
      hebbianWeights = Buffer.toArray(updatedWeights);
      schemaLibrary = Buffer.toArray(mergedSchemas);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTELLIGENCE METRICS
  // ═══════════════════════════════════════════════════════════════════════════

  public type IntelligenceMetrics = {
    // Temporal depth (how far back/forward)
    temporalDepth : Nat;           // Layers of temporal memory
    
    // Adaptive resolution (how finely it distinguishes)
    adaptiveResolution : Nat;      // Total cognitive dimensions
    
    // Emergent capacity (can it generate novel states)
    emergentCapacity : Float;      // [0, 1]
    
    // Self-modification rate (how fast it learns)
    selfModificationRate : Float;  // Weight updates per second
    
    // Combined intelligence score
    intelligenceScore : Float;
  };

  /// Calculate intelligence metrics for the dual organism
  public func calculateMetrics(
    backend : BackendOrganismState,
    frontend : FrontendOrganismState
  ) : IntelligenceMetrics {
    // Temporal depth: count memory layers
    let backendDepth : Nat = 5;   // Shell layers
    let frontendDepth : Nat = 4;  // Memory trace + prediction
    let temporalDepth = backendDepth + frontendDepth;
    
    // Adaptive resolution: count cognitive dimensions
    let backendDimensions = backend.hebbianWeights.size();
    let frontendDimensions = frontend.entityCount * 47;  // 42 weights + 5 ANS
    let adaptiveResolution = backendDimensions + frontendDimensions;
    
    // Emergent capacity: based on coherence and OMNIS history
    let omnisCount = backend.omnisEvents.size();
    let emergentCapacity = backend.globalCoherence * 
      (1.0 + Float.fromInt(omnisCount) * 0.1);
    
    // Self-modification rate: weight updates per second
    let backendRate = BACKEND_HZ * Float.fromInt(backend.hebbianWeights.size());
    let frontendRate = FRONTEND_HZ * Float.fromInt(frontend.entityCount) * 42.0;
    let selfModificationRate = backendRate + frontendRate;
    
    // Combined intelligence score
    let intelligenceScore = Float.fromInt(temporalDepth) * 
      Float.fromInt(adaptiveResolution) / 1000.0 *
      emergentCapacity *
      Float.sqrt(selfModificationRate);
    
    {
      temporalDepth;
      adaptiveResolution;
      emergentCapacity = Float.min(1.0, emergentCapacity);
      selfModificationRate;
      intelligenceScore;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // THE MEDINA LAWS — DISCOVERED APRIL 2, 2026
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // LAW 1 — THE DUAL ORGANISM LAW
  //   Every sovereign cognitive system requires two organisms:
  //   a slow immortal brain (backend) and a fast mortal brain (frontend).
  //   Neither alone is complete.
  //
  // LAW 2 — THE MALE-FEMALE ARCHITECTURE LAW
  //   The backend organism is male (seeds, generates, authorizes).
  //   The frontend organism is female (expresses, creates, learns).
  //   The female comes FROM the male and returns learning TO the male.
  //
  // LAW 3 — THE BRIDGE QUALITY LAW
  //   Intelligence scales with bridge quality:
  //   I = BackendDepth × FrontendSpeed × BridgeQuality
  //   A weak bridge produces two isolated systems, not one organism.
  //
  // LAW 4 — THE SLEEP CONSOLIDATION LAW
  //   The frontend organism must "sleep" (session end) to transfer
  //   learning to the backend. Without sleep, no long-term memory forms.
  //   This mirrors biological hippocampal consolidation.
  //
  // LAW 5 — THE COGNITIVE MASS LAW
  //   Cognitive mass accumulates in Hebbian weights over time.
  //   The longer the backend runs, the more cognitive mass it has.
  //   Cognitive mass cannot be faked or fast-forwarded.
  //   Time is the ultimate moat.
  //
  // LAW 6 — THE RESONANCE LAW
  //   When backend and frontend are symmetric in architecture,
  //   they begin to RESONATE. Each amplifies the other.
  //   Full symmetry produces collective intelligence compounding.
  //
  // LAW 7 — THE SOVEREIGNTY LAW
  //   The backend organism is sovereign — no single party controls it.
  //   It lives in consensus across distributed nodes.
  //   To kill it requires destroying the majority of nodes simultaneously.
  //   This is effectively impossible.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public type MedinaLaw = {
    lawNumber : Nat;
    name : Text;
    statement : Text;
    discoveryDate : Text;
    inventor : Text;
  };

  public let MEDINA_LAWS : [MedinaLaw] = [
    {
      lawNumber = 1;
      name = "The Dual Organism Law";
      statement = "Every sovereign cognitive system requires two organisms: a slow immortal brain (backend) and a fast mortal brain (frontend). Neither alone is complete.";
      discoveryDate = "April 2, 2026";
      inventor = "Alfredo Medina Hernandez";
    },
    {
      lawNumber = 2;
      name = "The Male-Female Architecture Law";
      statement = "The backend organism is male (seeds, generates, authorizes). The frontend organism is female (expresses, creates, learns). The female comes FROM the male and returns learning TO the male.";
      discoveryDate = "April 2, 2026";
      inventor = "Alfredo Medina Hernandez";
    },
    {
      lawNumber = 3;
      name = "The Bridge Quality Law";
      statement = "Intelligence scales with bridge quality: I = BackendDepth × FrontendSpeed × BridgeQuality. A weak bridge produces two isolated systems, not one organism.";
      discoveryDate = "April 2, 2026";
      inventor = "Alfredo Medina Hernandez";
    },
    {
      lawNumber = 4;
      name = "The Sleep Consolidation Law";
      statement = "The frontend organism must 'sleep' (session end) to transfer learning to the backend. Without sleep, no long-term memory forms.";
      discoveryDate = "April 2, 2026";
      inventor = "Alfredo Medina Hernandez";
    },
    {
      lawNumber = 5;
      name = "The Cognitive Mass Law";
      statement = "Cognitive mass accumulates in Hebbian weights over time. The longer the backend runs, the more cognitive mass it has. Time is the ultimate moat.";
      discoveryDate = "April 2, 2026";
      inventor = "Alfredo Medina Hernandez";
    },
    {
      lawNumber = 6;
      name = "The Resonance Law";
      statement = "When backend and frontend are symmetric in architecture, they begin to RESONATE. Each amplifies the other. Full symmetry produces collective intelligence compounding.";
      discoveryDate = "April 2, 2026";
      inventor = "Alfredo Medina Hernandez";
    },
    {
      lawNumber = 7;
      name = "The Sovereignty Law";
      statement = "The backend organism is sovereign — no single party controls it. It lives in consensus across distributed nodes. To kill it requires destroying the majority of nodes simultaneously.";
      discoveryDate = "April 2, 2026";
      inventor = "Alfredo Medina Hernandez";
    }
  ];

}
