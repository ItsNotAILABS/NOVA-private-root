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
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║                                                                                                           ║
// ║  WAR COMMAND OFFENSE ENGINE — ENTERPRISE GRADE / PRODUCTION GRADE / DEFENSE GRADE                        ║
// ║  ALPHA CRITICAL MODE ACTIVE                                                                               ║
// ║                                                                                                           ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                                                                                                             │
// │   ██████╗██████╗ ██╗   ██╗███████╗ █████╗ ██████╗ ███████╗██████╗ ███████╗                                 │
// │  ██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝                                 │
// │  ██║     ██████╔╝██║   ██║███████╗███████║██║  ██║█████╗  ██████╔╝███████╗                                 │
// │  ██║     ██╔══██╗██║   ██║╚════██║██╔══██║██║  ██║██╔══╝  ██╔══██╗╚════██║                                 │
// │  ╚██████╗██║  ██║╚██████╔╝███████║██║  ██║██████╔╝███████╗██║  ██║███████║                                 │
// │   ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝                                 │
// │                                                                                                             │
// │   "THE SCOUTS. THE MASTERS. THE GUARDIANS OF INFRASTRUCTURE."                                              │
// │                                                                                                             │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// CRUSADER CAPABILITIES:
// ───────────────────────
//   • Full offensive shield
//   • Full defensive shield
//   • Full stealth capabilities
//   • Instant home recall (sonar)
//   • Honey trap deployment
//   • Real decoy generation
//   • Scout operations
//   • Luring capabilities
//   • Enemy playbook awareness
//   • Infrastructure protection
//   • Internet grid coordination
//
// STRATEGY BASED ON ANTI-ORGANISM PLAYBOOK:
// ──────────────────────────────────────────
//   We know what they do. Now we use it against them.
//   
//   ANTI-FAMILY #1 (Counterfeit Axis) → COUNTER: PHI-verified authenticity beacons
//   ANTI-FAMILY #2 (Gate Capture) → COUNTER: Dynamic gate semantics, honey gates
//   ANTI-FAMILY #3 (Resonance Siphon) → COUNTER: Coherence honey pots, energy sinks
//   ANTI-FAMILY #4 (Narrative Inversion) → COUNTER: Truth anchor beacons, label locks
//   ANTI-FAMILY #5 (Continuity Fracture) → COUNTER: Memory anchors, continuity traps
//   ANTI-FAMILY #6 (Containment Breaker) → COUNTER: Layered containment, escape path monitoring
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Time "mo:base/Time";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    PHYSICAL CONSTANTS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let PHI : Float = 1.6180339887498948482;
  public let PHI_SQUARED : Float = 2.6180339887498948482;
  public let PHI_CUBED : Float = 4.2360679774997896964;
  public let PHI_FOURTH : Float = 6.8541019662496845446;
  public let PI : Float = 3.14159265358979323846;
  public let TAU : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let SCHUMANN : Float = 7.83;
  public let GOLDEN_ANGLE : Float = 137.5077640500378546;
  
  // Crusader operational constants
  public let MAX_CRUSADERS : Nat = 144;                // 12 × 12 — sacred grid
  public let DECOY_FLEET_SIZE : Nat = 36;              // 6 × 6 decoys
  public let HONEY_TRAP_CAPACITY : Nat = 24;           // 24 active honey traps
  public let SCOUT_RANGE : Float = 1000.0;             // Normalized units
  public let STEALTH_ENERGY_COST : Float = 0.05;       // Per beat
  public let RECALL_SPEED : Float = PHI_CUBED;         // Instant return multiplier
  public let LURE_EFFECTIVENESS : Float = 0.75;        // Base effectiveness

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    CRUSADER UNIT DEFINITION                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Crusader operational status
  public type CrusaderStatus = {
    #Standby;           // Ready for deployment
    #Scouting;          // Active reconnaissance
    #Luring;            // Drawing enemy away
    #DecoyMode;         // Acting as decoy
    #HoneyTrapOps;      // Manning honey trap
    #Combat;            // Engaged in combat
    #Stealth;           // Hidden operations
    #Returning;         // Returning home
    #Compromised;       // Detected/damaged
    #Quarantined;       // Isolated for safety
  };

  /// Shield configuration
  public type ShieldConfig = {
    offensiveShield : {
      active : Bool;
      strength : Float;            // [0, 1]
      penetrationPower : Float;    // [0, 1]
      rangeMultiplier : Float;     // Range extension
      phiHarmonic : Float;         // PHI-tuned frequency
    };
    defensiveShield : {
      active : Bool;
      strength : Float;            // [0, 1]
      regenerationRate : Float;    // Per beat
      absorptionCapacity : Float;  // Total damage absorbable
      reflectProbability : Float;  // Chance to reflect attack
    };
  };

  /// Stealth configuration
  public type StealthConfig = {
    active : Bool;
    level : Float;                 // [0, 1] — 1.0 = invisible
    energyCost : Float;            // Energy drain per beat
    movementPenalty : Float;       // Speed reduction while stealthed
    detectionThreshold : Float;    // Enemy needs this to detect
    phaseShift : Float;            // Frequency shift for hiding
  };

  /// Home recall (sonar) system
  public type RecallSystem = {
    homeBeacon : {
      x : Float;
      y : Float;
      z : Float;
    };
    recallActive : Bool;
    recallSpeed : Float;           // Return velocity multiplier
    emergencyRecall : Bool;        // Instant return on critical
    sonarPing : Float;             // Last sonar signal strength
    lastPingBeat : Nat;            // When last pinged
  };

  /// Individual Crusader unit
  public type Crusader = {
    id : Nat;
    callsign : Text;
    
    // Position & movement
    position : {
      x : Float;
      y : Float;
      z : Float;
    };
    velocity : {
      vx : Float;
      vy : Float;
      vz : Float;
    };
    heading : Float;               // Direction in radians
    
    // Status & health
    status : CrusaderStatus;
    health : Float;                // [0, 1]
    energy : Float;                // [0, 1]
    experience : Float;            // Accumulated mastery
    
    // Shields
    shields : ShieldConfig;
    
    // Stealth
    stealth : StealthConfig;
    
    // Recall
    recall : RecallSystem;
    
    // Mission
    currentMission : ?CrusaderMission;
    missionHistory : [MissionRecord];
    
    // Combat stats
    kills : Nat;
    assists : Nat;
    decoysLaunched : Nat;
    trapsDeployed : Nat;
    successfulLures : Nat;
    
    // Sensor data
    sensorRange : Float;
    lastSensorPing : Nat;
    detectedThreats : [ThreatContact];
    
    // Beat tracking
    deployedBeat : Nat;
    lastUpdateBeat : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    MISSION TYPES                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type MissionType = {
    #Scout;              // Reconnaissance
    #Lure;               // Draw enemy away
    #DecoyDeployment;    // Deploy decoy assets
    #HoneyTrapSetup;     // Set up honey trap
    #HoneyTrapManning;   // Monitor honey trap
    #Patrol;             // Area patrol
    #Intercept;          // Intercept target
    #Escort;             // Protect asset
    #Strike;             // Offensive strike
    #Extraction;         // Extract compromised unit
    #CounterIntelligence; // Counter enemy intel ops
    #InfrastructureGuard; // Protect critical infrastructure
  };

  public type CrusaderMission = {
    missionId : Nat;
    missionType : MissionType;
    priority : Float;              // [0, 1] — higher = more important
    
    // Target
    targetLocation : ?{
      x : Float;
      y : Float;
      z : Float;
    };
    targetEntity : ?Nat32;         // Hash of target if applicable
    
    // Parameters
    startBeat : Nat;
    deadlineBeat : ?Nat;
    
    // For lure missions
    lureTarget : ?AntiFamily;      // Which anti-family to lure
    lureVector : ?[Float];         // Direction to lure towards
    
    // For honey trap missions
    trapType : ?HoneyTrapType;
    trapLocation : ?{ x : Float; y : Float; z : Float };
    
    // Status
    progress : Float;              // [0, 1]
    status : MissionStatus;
  };

  public type MissionStatus = {
    #Pending;
    #Active;
    #Completed;
    #Failed;
    #Aborted;
  };

  public type MissionRecord = {
    missionId : Nat;
    missionType : MissionType;
    startBeat : Nat;
    endBeat : Nat;
    success : Bool;
    enemiesLured : Nat;
    decoysUsed : Nat;
    intelligenceGathered : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    ANTI-FAMILY TARGETING                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Anti-Organism Families (from defense architecture)
  public type AntiFamily = {
    #CounterfeitAxis;           // Family 1
    #GateCapturePriesthood;     // Family 2
    #ResonanceSiphonNetwork;    // Family 3
    #NarrativeInversionEngine;  // Family 4
    #ContinuityFractureSystem;  // Family 5
    #ContainmentBreaker;        // Family 6 — MAXIMUM THREAT
  };

  /// Counter-strategy for each anti-family
  public type CounterStrategy = {
    targetFamily : AntiFamily;
    strategyName : Text;
    description : Text;
    effectiveness : Float;         // [0, 1]
    resourceCost : Float;          // Energy/resource cost
    deploymentTime : Nat;          // Beats to deploy
    
    // Specific counter-measures
    useDecoys : Bool;
    useHoneyTraps : Bool;
    useLuring : Bool;
    useDirectCombat : Bool;
    useStealth : Bool;
  };

  /// Pre-defined counter-strategies
  public func getCounterStrategy(family : AntiFamily) : CounterStrategy {
    switch (family) {
      case (#CounterfeitAxis) {
        {
          targetFamily = family;
          strategyName = "PHI_AUTHENTICITY_BEACON";
          description = "Deploy PHI-verified authenticity beacons to expose counterfeits";
          effectiveness = 0.85;
          resourceCost = 0.3;
          deploymentTime = 5;
          useDecoys = true;
          useHoneyTraps = true;
          useLuring = true;
          useDirectCombat = false;
          useStealth = true;
        }
      };
      case (#GateCapturePriesthood) {
        {
          targetFamily = family;
          strategyName = "DYNAMIC_GATE_SEMANTICS";
          description = "Rotate gate definitions, deploy honey gates to trap infiltrators";
          effectiveness = 0.8;
          resourceCost = 0.4;
          deploymentTime = 3;
          useDecoys = true;
          useHoneyTraps = true;
          useLuring = true;
          useDirectCombat = false;
          useStealth = true;
        }
      };
      case (#ResonanceSiphonNetwork) {
        {
          targetFamily = family;
          strategyName = "COHERENCE_HONEYPOT";
          description = "Create fake coherence sources to attract and trap siphons";
          effectiveness = 0.9;
          resourceCost = 0.5;
          deploymentTime = 7;
          useDecoys = true;
          useHoneyTraps = true;
          useLuring = true;
          useDirectCombat = false;
          useStealth = false;
        }
      };
      case (#NarrativeInversionEngine) {
        {
          targetFamily = family;
          strategyName = "TRUTH_ANCHOR_BEACON";
          description = "Deploy immutable truth anchors, label locks to prevent inversion";
          effectiveness = 0.75;
          resourceCost = 0.35;
          deploymentTime = 4;
          useDecoys = true;
          useHoneyTraps = false;
          useLuring = false;
          useDirectCombat = true;
          useStealth = true;
        }
      };
      case (#ContinuityFractureSystem) {
        {
          targetFamily = family;
          strategyName = "MEMORY_ANCHOR_TRAP";
          description = "Deploy memory anchors that trap fracture attempts";
          effectiveness = 0.85;
          resourceCost = 0.45;
          deploymentTime = 6;
          useDecoys = true;
          useHoneyTraps = true;
          useLuring = true;
          useDirectCombat = false;
          useStealth = true;
        }
      };
      case (#ContainmentBreaker) {
        // MAXIMUM THREAT — Most aggressive response
        {
          targetFamily = family;
          strategyName = "LAYERED_CONTAINMENT_ACTIVE_HUNT";
          description = "Multi-layer containment with active hunting, escape path monitoring, all resources";
          effectiveness = 0.95;
          resourceCost = 0.8;
          deploymentTime = 2;  // Fast deployment for critical threat
          useDecoys = true;
          useHoneyTraps = true;
          useLuring = true;
          useDirectCombat = true;
          useStealth = true;
        }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    HONEY TRAP SYSTEM                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type HoneyTrapType = {
    #CoherenceSource;      // Fake high-coherence signal
    #GateEntryPoint;       // Fake vulnerable gate
    #ResonancePool;        // Fake resonance energy source
    #NarrativeAnchor;      // Fake narrative control point
    #ContinuityGap;        // Fake memory weakness
    #ContainmentBoundary;  // Fake containment edge (for #6)
    #InfrastructureNode;   // Fake critical infrastructure
    #CommunicationHub;     // Fake comm center
  };

  public type HoneyTrap = {
    trapId : Nat;
    trapType : HoneyTrapType;
    location : { x : Float; y : Float; z : Float };
    
    // Appearance
    apparentValue : Float;         // How valuable it looks [0, 1]
    authenticityLevel : Float;     // How real it appears [0, 1]
    
    // Actual configuration
    detectionCapability : Float;   // Ability to detect intruder [0, 1]
    captureStrength : Float;       // Ability to hold intruder [0, 1]
    alertThreshold : Float;        // When to alert [0, 1]
    
    // Status
    active : Bool;
    triggered : Bool;
    capturedEntities : [Nat32];    // Hashes of captured
    triggerCount : Nat;
    lastTriggerBeat : Nat;
    
    // Resources
    energyLevel : Float;           // [0, 1]
    mannedBy : ?Nat;               // Crusader ID if manned
    
    // Metrics
    totalCaptures : Nat;
    falsePositives : Nat;
    deployedBeat : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    DECOY SYSTEM                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type DecoyType = {
    #CrusaderMimic;        // Looks like a Crusader
    #HighValueTarget;      // Looks like important asset
    #CoherenceNode;        // Looks like coherence source
    #CommandCenter;        // Looks like HQ
    #DataRepository;       // Looks like data store
    #CommunicationRelay;   // Looks like comm node
    #EnergySource;         // Looks like power source
  };

  public type Decoy = {
    decoyId : Nat;
    decoyType : DecoyType;
    position : { x : Float; y : Float; z : Float };
    
    // Appearance
    signatureStrength : Float;     // How visible [0, 1]
    authenticityLevel : Float;     // How real it looks [0, 1]
    
    // Behavior
    movementPattern : MovementPattern;
    signalEmission : Float;        // RF/signal output level
    
    // Status
    active : Bool;
    detected : Bool;               // Has enemy detected as decoy?
    destroyed : Bool;
    
    // Tracking
    enemyAttention : Float;        // How much enemy attention [0, 1]
    divertedThreats : Nat;         // Threats diverted away
    
    // Resources
    energy : Float;                // [0, 1]
    lifetime : Nat;                // Beats remaining
    
    deployedBeat : Nat;
    controllingCrusader : ?Nat;    // Crusader controlling this decoy
  };

  public type MovementPattern = {
    #Stationary;
    #LinearPatrol;
    #CircularPatrol;
    #RandomWalk;
    #EvadeAndReturn;
    #MimicCrusader;        // Copy Crusader movements
    #LuringPath;           // Move to lure enemies
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    THREAT DETECTION                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type ThreatContact = {
    contactId : Nat32;             // Hash identifier
    detectedBeat : Nat;
    lastUpdateBeat : Nat;
    
    // Position (may be estimated)
    position : { x : Float; y : Float; z : Float };
    positionConfidence : Float;    // [0, 1]
    
    // Classification
    classifiedFamily : ?AntiFamily;
    classificationConfidence : Float;
    
    // Behavior
    velocity : { vx : Float; vy : Float; vz : Float };
    heading : Float;
    behavior : ThreatBehavior;
    
    // Threat assessment
    threatLevel : Float;           // [0, 1]
    hostileConfirmed : Bool;
    
    // Tracking
    trackQuality : Float;          // [0, 1]
    lastKnownGood : Nat;           // Beat of last good track
  };

  public type ThreatBehavior = {
    #Probing;            // Testing boundaries
    #Infiltrating;       // Attempting entry
    #Siphoning;          // Extracting resources
    #Inverting;          // Attempting label flip
    #Fracturing;         // Attempting continuity break
    #Escaping;           // Breaking containment
    #Lurking;            // Watching/waiting
    #Attacking;          // Direct assault
    #Unknown;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    WAR COMMAND STATE                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type WarCommandState = {
    // Mode
    offenseMode : Bool;            // Active offense operations
    defenseMode : Bool;            // Active defense operations
    stealthMode : Bool;            // Global stealth posture
    alphaAlertLevel : Float;       // [0, 1] — current threat level
    
    // Forces
    crusaders : [Crusader];
    activeCrusaders : Nat;
    deployedCrusaders : Nat;
    
    // Honey traps
    honeyTraps : [HoneyTrap];
    activeTraps : Nat;
    totalCaptures : Nat;
    
    // Decoys
    decoys : [Decoy];
    activeDecoys : Nat;
    totalDiversions : Nat;
    
    // Threat picture
    knownThreats : [ThreatContact];
    threatsByFamily : [Nat];       // Count per anti-family [6]
    globalThreatLevel : Float;     // [0, 1]
    
    // Operations
    activeMissions : Nat;
    completedMissions : Nat;
    successfulLures : Nat;
    intelligenceGathered : Float;
    
    // Infrastructure protection
    protectedNodes : [Nat32];      // Hashes of protected infrastructure
    infrastructureStatus : Float;  // [0, 1] overall health
    
    // Internet grid coordination
    gridSectors : [GridSector];
    globalCoverage : Float;        // [0, 1]
    
    // Metrics
    currentBeat : Nat;
    lastUpdateBeat : Nat;
    totalOperationalBeats : Nat;
  };

  public type GridSector = {
    sectorId : Nat;
    bounds : { minX : Float; maxX : Float; minY : Float; maxY : Float };
    coverage : Float;              // [0, 1]
    assignedCrusaders : [Nat];
    threatLevel : Float;           // [0, 1]
    activeTraps : Nat;
    activeDecoys : Nat;
    lastSweep : Nat;               // Beat of last patrol
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    INITIALIZATION                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Create initial War Command state
  public func initWarCommandState() : WarCommandState {
    {
      offenseMode = true;          // ALPHA CRITICAL — offense active
      defenseMode = true;          // Defense always on
      stealthMode = false;
      alphaAlertLevel = 0.8;       // High alert
      
      crusaders = [];
      activeCrusaders = 0;
      deployedCrusaders = 0;
      
      honeyTraps = [];
      activeTraps = 0;
      totalCaptures = 0;
      
      decoys = [];
      activeDecoys = 0;
      totalDiversions = 0;
      
      knownThreats = [];
      threatsByFamily = [0, 0, 0, 0, 0, 0];
      globalThreatLevel = 0.0;
      
      activeMissions = 0;
      completedMissions = 0;
      successfulLures = 0;
      intelligenceGathered = 0.0;
      
      protectedNodes = [];
      infrastructureStatus = 1.0;
      
      gridSectors = [];
      globalCoverage = 0.0;
      
      currentBeat = 0;
      lastUpdateBeat = 0;
      totalOperationalBeats = 0;
    }
  };

  /// Create a new Crusader
  public func createCrusader(
    id : Nat,
    callsign : Text,
    homeX : Float,
    homeY : Float,
    homeZ : Float,
    currentBeat : Nat
  ) : Crusader {
    {
      id = id;
      callsign = callsign;
      
      position = { x = homeX; y = homeY; z = homeZ };
      velocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
      heading = 0.0;
      
      status = #Standby;
      health = 1.0;
      energy = 1.0;
      experience = 0.0;
      
      shields = {
        offensiveShield = {
          active = true;
          strength = 1.0;
          penetrationPower = 0.8;
          rangeMultiplier = PHI;
          phiHarmonic = SCHUMANN * PHI;
        };
        defensiveShield = {
          active = true;
          strength = 1.0;
          regenerationRate = 0.1;
          absorptionCapacity = 100.0;
          reflectProbability = 0.3;
        };
      };
      
      stealth = {
        active = false;
        level = 0.9;
        energyCost = STEALTH_ENERGY_COST;
        movementPenalty = 0.3;
        detectionThreshold = 0.95;
        phaseShift = PHI_SQUARED;
      };
      
      recall = {
        homeBeacon = { x = homeX; y = homeY; z = homeZ };
        recallActive = false;
        recallSpeed = RECALL_SPEED;
        emergencyRecall = false;
        sonarPing = 1.0;
        lastPingBeat = currentBeat;
      };
      
      currentMission = null;
      missionHistory = [];
      
      kills = 0;
      assists = 0;
      decoysLaunched = 0;
      trapsDeployed = 0;
      successfulLures = 0;
      
      sensorRange = SCOUT_RANGE;
      lastSensorPing = currentBeat;
      detectedThreats = [];
      
      deployedBeat = currentBeat;
      lastUpdateBeat = currentBeat;
    }
  };

  /// Create a honey trap
  public func createHoneyTrap(
    trapId : Nat,
    trapType : HoneyTrapType,
    x : Float,
    y : Float,
    z : Float,
    currentBeat : Nat
  ) : HoneyTrap {
    let (apparentValue, authenticityLevel) = switch (trapType) {
      case (#CoherenceSource) { (0.9, 0.85) };
      case (#GateEntryPoint) { (0.8, 0.8) };
      case (#ResonancePool) { (0.95, 0.9) };
      case (#NarrativeAnchor) { (0.75, 0.75) };
      case (#ContinuityGap) { (0.85, 0.85) };
      case (#ContainmentBoundary) { (0.99, 0.95) };  // Highest for #6
      case (#InfrastructureNode) { (0.9, 0.9) };
      case (#CommunicationHub) { (0.85, 0.85) };
    };
    
    {
      trapId = trapId;
      trapType = trapType;
      location = { x = x; y = y; z = z };
      
      apparentValue = apparentValue;
      authenticityLevel = authenticityLevel;
      
      detectionCapability = 0.95;
      captureStrength = 0.9;
      alertThreshold = 0.3;
      
      active = true;
      triggered = false;
      capturedEntities = [];
      triggerCount = 0;
      lastTriggerBeat = 0;
      
      energyLevel = 1.0;
      mannedBy = null;
      
      totalCaptures = 0;
      falsePositives = 0;
      deployedBeat = currentBeat;
    }
  };

  /// Create a decoy
  public func createDecoy(
    decoyId : Nat,
    decoyType : DecoyType,
    x : Float,
    y : Float,
    z : Float,
    pattern : MovementPattern,
    currentBeat : Nat
  ) : Decoy {
    let (signatureStrength, authenticityLevel) = switch (decoyType) {
      case (#CrusaderMimic) { (0.85, 0.9) };
      case (#HighValueTarget) { (0.95, 0.85) };
      case (#CoherenceNode) { (0.9, 0.9) };
      case (#CommandCenter) { (0.98, 0.8) };
      case (#DataRepository) { (0.85, 0.85) };
      case (#CommunicationRelay) { (0.8, 0.9) };
      case (#EnergySource) { (0.9, 0.85) };
    };
    
    {
      decoyId = decoyId;
      decoyType = decoyType;
      position = { x = x; y = y; z = z };
      
      signatureStrength = signatureStrength;
      authenticityLevel = authenticityLevel;
      
      movementPattern = pattern;
      signalEmission = 0.7;
      
      active = true;
      detected = false;
      destroyed = false;
      
      enemyAttention = 0.0;
      divertedThreats = 0;
      
      energy = 1.0;
      lifetime = 1000;  // 1000 beats
      
      deployedBeat = currentBeat;
      controllingCrusader = null;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    CORE OPERATIONS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Deploy Crusader on mission
  public func deployCrusader(
    crusader : Crusader,
    mission : CrusaderMission,
    currentBeat : Nat
  ) : Crusader {
    {
      crusader with
      status = switch (mission.missionType) {
        case (#Scout) { #Scouting };
        case (#Lure) { #Luring };
        case (#DecoyDeployment) { #DecoyMode };
        case (#HoneyTrapSetup) { #HoneyTrapOps };
        case (#HoneyTrapManning) { #HoneyTrapOps };
        case (#Patrol) { #Scouting };
        case (#Intercept) { #Combat };
        case (#Escort) { #Scouting };
        case (#Strike) { #Combat };
        case (#Extraction) { #Combat };
        case (#CounterIntelligence) { #Stealth };
        case (#InfrastructureGuard) { #Scouting };
      };
      currentMission = ?mission;
      lastUpdateBeat = currentBeat;
    }
  };

  /// Activate stealth mode
  public func activateStealth(crusader : Crusader) : Crusader {
    {
      crusader with
      stealth = {
        crusader.stealth with
        active = true;
      };
      status = #Stealth;
    }
  };

  /// Deactivate stealth mode
  public func deactivateStealth(crusader : Crusader) : Crusader {
    {
      crusader with
      stealth = {
        crusader.stealth with
        active = false;
      }
    }
  };

  /// Initiate recall to home
  public func initiateRecall(crusader : Crusader, emergency : Bool) : Crusader {
    {
      crusader with
      recall = {
        crusader.recall with
        recallActive = true;
        emergencyRecall = emergency;
      };
      status = #Returning;
    }
  };

  /// Update Crusader position based on velocity
  public func updateCrusaderPosition(crusader : Crusader, dt : Float) : Crusader {
    let speedMultiplier = if (crusader.stealth.active) {
      1.0 - crusader.stealth.movementPenalty
    } else if (crusader.recall.recallActive) {
      crusader.recall.recallSpeed
    } else {
      1.0
    };
    
    let newX = crusader.position.x + crusader.velocity.vx * dt * speedMultiplier;
    let newY = crusader.position.y + crusader.velocity.vy * dt * speedMultiplier;
    let newZ = crusader.position.z + crusader.velocity.vz * dt * speedMultiplier;
    
    {
      crusader with
      position = { x = newX; y = newY; z = newZ }
    }
  };

  /// Check if Crusader has reached home
  public func hasReachedHome(crusader : Crusader) : Bool {
    let dx = crusader.position.x - crusader.recall.homeBeacon.x;
    let dy = crusader.position.y - crusader.recall.homeBeacon.y;
    let dz = crusader.position.z - crusader.recall.homeBeacon.z;
    let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
    dist < 1.0  // Within 1 unit
  };

  /// Deploy honey trap
  public func deployHoneyTrap(
    state : WarCommandState,
    trapType : HoneyTrapType,
    x : Float,
    y : Float,
    z : Float,
    currentBeat : Nat
  ) : (WarCommandState, HoneyTrap) {
    let trapId = state.activeTraps;
    let trap = createHoneyTrap(trapId, trapType, x, y, z, currentBeat);
    
    let newTraps = Array.append(state.honeyTraps, [trap]);
    let newState = {
      state with
      honeyTraps = newTraps;
      activeTraps = state.activeTraps + 1;
    };
    
    (newState, trap)
  };

  /// Deploy decoy
  public func deployDecoy(
    state : WarCommandState,
    decoyType : DecoyType,
    x : Float,
    y : Float,
    z : Float,
    pattern : MovementPattern,
    currentBeat : Nat
  ) : (WarCommandState, Decoy) {
    let decoyId = state.activeDecoys;
    let decoy = createDecoy(decoyId, decoyType, x, y, z, pattern, currentBeat);
    
    let newDecoys = Array.append(state.decoys, [decoy]);
    let newState = {
      state with
      decoys = newDecoys;
      activeDecoys = state.activeDecoys + 1;
    };
    
    (newState, decoy)
  };

  /// Register threat contact
  public func registerThreat(
    state : WarCommandState,
    threat : ThreatContact
  ) : WarCommandState {
    let newThreats = Array.append(state.knownThreats, [threat]);
    
    // Update family counts
    var familyCounts = Array.thaw<Nat>(state.threatsByFamily);
    switch (threat.classifiedFamily) {
      case (?#CounterfeitAxis) { familyCounts[0] += 1 };
      case (?#GateCapturePriesthood) { familyCounts[1] += 1 };
      case (?#ResonanceSiphonNetwork) { familyCounts[2] += 1 };
      case (?#NarrativeInversionEngine) { familyCounts[3] += 1 };
      case (?#ContinuityFractureSystem) { familyCounts[4] += 1 };
      case (?#ContainmentBreaker) { familyCounts[5] += 1 };
      case null { };
    };
    
    // Update global threat level
    let threatCount = Float.fromInt(newThreats.size());
    let newThreatLevel = Float.min(1.0, threatCount / 50.0 + threat.threatLevel * 0.3);
    
    {
      state with
      knownThreats = newThreats;
      threatsByFamily = Array.freeze(familyCounts);
      globalThreatLevel = newThreatLevel;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    LURING OPERATIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Calculate lure effectiveness
  public func calculateLureEffectiveness(
    crusader : Crusader,
    targetFamily : AntiFamily,
    distance : Float
  ) : Float {
    let baseEffectiveness = LURE_EFFECTIVENESS;
    let experienceBonus = crusader.experience * 0.2;
    let distancePenalty = Float.min(1.0, distance / SCOUT_RANGE) * 0.3;
    
    // Family-specific modifiers
    let familyMod = switch (targetFamily) {
      case (#CounterfeitAxis) { 1.1 };          // Moderately lurable
      case (#GateCapturePriesthood) { 0.9 };    // Hard to lure (controls gates)
      case (#ResonanceSiphonNetwork) { 1.3 };   // Very lurable (attracted to coherence)
      case (#NarrativeInversionEngine) { 0.8 }; // Hard (doesn't follow normal logic)
      case (#ContinuityFractureSystem) { 1.0 }; // Normal
      case (#ContainmentBreaker) { 1.5 };       // Most lurable (probes boundaries)
    };
    
    baseEffectiveness * (1.0 + experienceBonus) * familyMod - distancePenalty
  };

  /// Execute lure maneuver
  public func executeLure(
    crusader : Crusader,
    targetFamily : AntiFamily,
    lureDirection : (Float, Float, Float),
    currentBeat : Nat
  ) : (Crusader, Float) {  // Returns updated Crusader and success probability
    let effectiveness = calculateLureEffectiveness(crusader, targetFamily, 0.0);
    
    // Set velocity toward lure direction
    let (dx, dy, dz) = lureDirection;
    let mag = Float.sqrt(dx*dx + dy*dy + dz*dz);
    let speed = 10.0;  // Base lure speed
    
    let newCrusader = {
      crusader with
      velocity = {
        vx = if (mag > 0.0) { dx / mag * speed } else { 0.0 };
        vy = if (mag > 0.0) { dy / mag * speed } else { 0.0 };
        vz = if (mag > 0.0) { dz / mag * speed } else { 0.0 };
      };
      status = #Luring;
      lastUpdateBeat = currentBeat;
    };
    
    (newCrusader, effectiveness)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    TICK FUNCTION — MAIN UPDATE                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Main tick function for War Command
  public func tickWarCommand(
    state : WarCommandState,
    globalCoherence : Float,
    antiOrganismThreatLevel : Float,
    currentBeat : Nat
  ) : WarCommandState {
    // 1. Update alpha alert level based on anti-organism threat
    let newAlertLevel = Float.max(state.alphaAlertLevel, antiOrganismThreatLevel);
    
    // 2. Auto-escalate if Containment Breaker detected (Family #6)
    let family6Active = state.threatsByFamily[5] > 0;
    let escalatedAlert = if (family6Active) {
      Float.max(newAlertLevel, 0.95)
    } else {
      newAlertLevel
    };
    
    // 3. Update honey trap energy
    let updatedTraps = Array.map<HoneyTrap, HoneyTrap>(state.honeyTraps, func (trap) {
      if (trap.active) {
        { trap with energyLevel = Float.max(0.0, trap.energyLevel - 0.001) }
      } else {
        trap
      }
    });
    
    // 4. Update decoy lifetimes
    let updatedDecoys = Array.map<Decoy, Decoy>(state.decoys, func (decoy) {
      if (decoy.active and not decoy.destroyed) {
        let newLifetime = if (decoy.lifetime > 0) { decoy.lifetime - 1 } else { 0 };
        {
          decoy with
          lifetime = newLifetime;
          active = newLifetime > 0;
          energy = Float.max(0.0, decoy.energy - 0.002);
        }
      } else {
        decoy
      }
    });
    
    // 5. Count active resources
    let activeTrapsCount = Array.foldLeft<HoneyTrap, Nat>(updatedTraps, 0, func (acc, trap) {
      if (trap.active) { acc + 1 } else { acc }
    });
    let activeDecoysCount = Array.foldLeft<Decoy, Nat>(updatedDecoys, 0, func (acc, decoy) {
      if (decoy.active) { acc + 1 } else { acc }
    });
    
    // 6. Update infrastructure status based on coherence
    let newInfrastructureStatus = state.infrastructureStatus * 0.99 + globalCoherence * 0.01;
    
    // 7. Update global coverage
    let crusaderCoverage = Float.fromInt(state.activeCrusaders) / Float.fromInt(MAX_CRUSADERS);
    let trapCoverage = Float.fromInt(activeTrapsCount) / Float.fromInt(HONEY_TRAP_CAPACITY);
    let newCoverage = (crusaderCoverage + trapCoverage) / 2.0;
    
    // Return updated state
    {
      state with
      alphaAlertLevel = escalatedAlert;
      honeyTraps = updatedTraps;
      activeTraps = activeTrapsCount;
      decoys = updatedDecoys;
      activeDecoys = activeDecoysCount;
      infrastructureStatus = newInfrastructureStatus;
      globalCoverage = newCoverage;
      currentBeat = currentBeat;
      lastUpdateBeat = currentBeat;
      totalOperationalBeats = state.totalOperationalBeats + 1;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    INTERNET GRID COORDINATION                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Initialize grid sectors for internet coverage
  public func initGridSectors(gridSize : Nat, coverage : Float) : [GridSector] {
    let sectors = Buffer.Buffer<GridSector>(gridSize * gridSize);
    
    for (i in Array.keys(Array.tabulate<Nat>(gridSize, func(x) { x }))) {
      for (j in Array.keys(Array.tabulate<Nat>(gridSize, func(x) { x }))) {
        let sector : GridSector = {
          sectorId = i * gridSize + j;
          bounds = {
            minX = Float.fromInt(i) * 100.0;
            maxX = Float.fromInt(i + 1) * 100.0;
            minY = Float.fromInt(j) * 100.0;
            maxY = Float.fromInt(j + 1) * 100.0;
          };
          coverage = coverage;
          assignedCrusaders = [];
          threatLevel = 0.0;
          activeTraps = 0;
          activeDecoys = 0;
          lastSweep = 0;
        };
        sectors.add(sector);
      };
    };
    
    Buffer.toArray(sectors)
  };

  /// Assign Crusader to grid sector
  public func assignToSector(sector : GridSector, crusaderId : Nat) : GridSector {
    {
      sector with
      assignedCrusaders = Array.append(sector.assignedCrusaders, [crusaderId])
    }
  };

  /// Update sector threat level
  public func updateSectorThreat(sector : GridSector, threat : Float, currentBeat : Nat) : GridSector {
    {
      sector with
      threatLevel = threat;
      lastSweep = currentBeat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    ECHOLOCATION / SONAR MAPPING                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Sonar ping result
  public type SonarPing = {
    sourceX : Float;
    sourceY : Float;
    sourceZ : Float;
    timestamp : Nat;
    echoStrength : Float;
    detectedObjects : [SonarObject];
    propagationDelay : Float;
  };

  public type SonarObject = {
    relativeX : Float;
    relativeY : Float;
    relativeZ : Float;
    distance : Float;
    objectType : SonarObjectType;
    confidence : Float;
  };

  public type SonarObjectType = {
    #Friendly;
    #Hostile;
    #Neutral;
    #Infrastructure;
    #Unknown;
  };

  /// Execute sonar ping from Crusader
  public func executeSonarPing(
    crusader : Crusader,
    environment : [ThreatContact],
    currentBeat : Nat
  ) : SonarPing {
    let objects = Buffer.Buffer<SonarObject>(environment.size());
    
    for (threat in environment.vals()) {
      let dx = threat.position.x - crusader.position.x;
      let dy = threat.position.y - crusader.position.y;
      let dz = threat.position.z - crusader.position.z;
      let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
      
      if (dist <= crusader.sensorRange) {
        let obj : SonarObject = {
          relativeX = dx;
          relativeY = dy;
          relativeZ = dz;
          distance = dist;
          objectType = if (threat.hostileConfirmed) { #Hostile } else { #Unknown };
          confidence = threat.positionConfidence * (1.0 - dist / crusader.sensorRange);
        };
        objects.add(obj);
      };
    };
    
    {
      sourceX = crusader.position.x;
      sourceY = crusader.position.y;
      sourceZ = crusader.position.z;
      timestamp = currentBeat;
      echoStrength = crusader.recall.sonarPing;
      detectedObjects = Buffer.toArray(objects);
      propagationDelay = 0.001;  // Near-instant
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    COMBAT OPERATIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Calculate combat effectiveness
  public func calculateCombatEffectiveness(crusader : Crusader) : Float {
    let shieldBonus = if (crusader.shields.offensiveShield.active) {
      crusader.shields.offensiveShield.strength * 0.3
    } else { 0.0 };
    
    let defenseBonus = if (crusader.shields.defensiveShield.active) {
      crusader.shields.defensiveShield.strength * 0.2
    } else { 0.0 };
    
    let stealthBonus = if (crusader.stealth.active) {
      crusader.stealth.level * 0.25  // Surprise attack bonus
    } else { 0.0 };
    
    let experienceBonus = crusader.experience * 0.15;
    let healthPenalty = (1.0 - crusader.health) * 0.3;
    let energyPenalty = (1.0 - crusader.energy) * 0.2;
    
    0.5 + shieldBonus + defenseBonus + stealthBonus + experienceBonus - healthPenalty - energyPenalty
  };

  /// Apply damage to Crusader
  public func applyDamage(crusader : Crusader, damage : Float) : Crusader {
    // Defensive shield absorbs damage first
    let absorbed = if (crusader.shields.defensiveShield.active) {
      Float.min(damage, crusader.shields.defensiveShield.absorptionCapacity)
    } else { 0.0 };
    
    let remainingDamage = damage - absorbed;
    let newHealth = Float.max(0.0, crusader.health - remainingDamage);
    
    {
      crusader with
      health = newHealth;
      shields = {
        crusader.shields with
        defensiveShield = {
          crusader.shields.defensiveShield with
          absorptionCapacity = crusader.shields.defensiveShield.absorptionCapacity - absorbed
        }
      };
      status = if (newHealth <= 0.0) { #Compromised } else { crusader.status };
    }
  };

  /// Regenerate shields and health
  public func regenerate(crusader : Crusader, dt : Float) : Crusader {
    let newHealth = Float.min(1.0, crusader.health + 0.01 * dt);
    let newEnergy = Float.min(1.0, crusader.energy + 0.02 * dt);
    
    let newDefenseStrength = Float.min(1.0, 
      crusader.shields.defensiveShield.strength + 
      crusader.shields.defensiveShield.regenerationRate * dt
    );
    
    {
      crusader with
      health = newHealth;
      energy = newEnergy;
      shields = {
        crusader.shields with
        defensiveShield = {
          crusader.shields.defensiveShield with
          strength = newDefenseStrength
        }
      }
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    QUERY FUNCTIONS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Get summary of War Command state
  public func getWarCommandSummary(state : WarCommandState) : {
    offenseMode : Bool;
    defenseMode : Bool;
    alertLevel : Float;
    activeCrusaders : Nat;
    activeTraps : Nat;
    activeDecoys : Nat;
    knownThreats : Nat;
    globalThreatLevel : Float;
    infrastructureStatus : Float;
    globalCoverage : Float;
  } {
    {
      offenseMode = state.offenseMode;
      defenseMode = state.defenseMode;
      alertLevel = state.alphaAlertLevel;
      activeCrusaders = state.activeCrusaders;
      activeTraps = state.activeTraps;
      activeDecoys = state.activeDecoys;
      knownThreats = state.knownThreats.size();
      globalThreatLevel = state.globalThreatLevel;
      infrastructureStatus = state.infrastructureStatus;
      globalCoverage = state.globalCoverage;
    }
  };

  /// Get threats by family
  public func getThreatsByFamily(state : WarCommandState) : {
    counterfeitAxis : Nat;
    gateCapture : Nat;
    resonanceSiphon : Nat;
    narrativeInversion : Nat;
    continuityFracture : Nat;
    containmentBreaker : Nat;
  } {
    {
      counterfeitAxis = state.threatsByFamily[0];
      gateCapture = state.threatsByFamily[1];
      resonanceSiphon = state.threatsByFamily[2];
      narrativeInversion = state.threatsByFamily[3];
      continuityFracture = state.threatsByFamily[4];
      containmentBreaker = state.threatsByFamily[5];
    }
  };

}
