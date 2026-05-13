// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: RealWorld — The Living Simulated Reality Engine
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    THE REAL WORLD ENGINE                                 ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  THIS IS NOT A SIMULATION. THIS IS REALITY.                              ║
// ║                                                                          ║
// ║  The organism exists in a REAL world with:                               ║
// ║    - Real territories to defend                                          ║
// ║    - Real threats to counter                                             ║
// ║    - Real resources to manage                                            ║
// ║    - Real adversaries to track                                           ║
// ║    - Real allies to coordinate with                                      ║
// ║    - Real markets to navigate                                            ║
// ║    - Real time passing                                                   ║
// ║                                                                          ║
// ║  DEFENSE BRANCHES:                                                       ║
// ║    - PERIMETER DEFENSE (DURA 6-axis helix)                              ║
// ║    - IMMUNE DEFENSE (VAEL primary reflex)                               ║
// ║    - COUNTER-STRIKE (RIFT consequence tracer)                           ║
// ║    - MEMORY DEFENSE (MEMORIA adversary record)                          ║
// ║    - OUTPUT DEFENSE (VEIL membrane filter)                              ║
// ║    - ANCHOR DEFENSE (AEGIS sovereign lock)                              ║
// ║    - MONITOR DEFENSE (SENTINEL deviation watch)                         ║
// ║    - ROLLBACK DEFENSE (ARES snapshot recovery)                          ║
// ║    - THREAT ASSESSMENT (VETUS 9 vectors)                                ║
// ║    - ANOMALY DETECTION (PROMETHEUS 128 slots)                           ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SACRED CONSTANTS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let phi : Float = 1.6180339887498948482;
  public let psi : Float = 0.6180339887498948482;
  public let pi : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;
  public let e : Float = 2.7182818284590452354;
  public let S₀ : Float = 0.3819660112501051518;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     THE ATLAS TERRITORY GRID                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // The organism controls a 64×64 = 4096 cell territory grid (ATLAS).
  // Each cell has sovereignty level, resource density, threat level.
  // Territory must be DEFENDED. Territory generates RESOURCES.
  //
  public let ATLAS_DIM : Nat = 64;
  public let ATLAS_CELLS : Nat = 4096;

  public type TerritoryCell = {
    // Position
    x : Nat;
    y : Nat;
    index : Nat;
    
    // Sovereignty
    sovereigntyLevel : Float;   // [0, 1] how controlled
    controlledSince : Nat;      // Beat when captured
    
    // Resources
    resourceDensity : Float;    // [0, 1] how rich
    resourceType : ResourceType;
    extractionRate : Float;     // Resources per beat
    
    // Defense
    fortificationLevel : Float; // [0, 1] how defended
    threatLevel : Float;        // [0, 1] current threat
    lastAttack : Nat;           // Beat of last attack
    
    // Pheromone (stigmergy)
    pheromoneLevel : Float;     // [0, 1] marking strength
    pheromoneDecay : Float;     // Decay rate (2% per beat default)
    
    // Neighbors
    neighborIndices : [Nat];    // 4 or 8 adjacent cells
  };

  public type ResourceType = {
    #Energy;                    // Computational energy
    #Data;                      // Information resource
    #Token;                     // Economic resource
    #Coherence;                 // Synchronization resource
    #Memory;                    // Storage resource
    #Bandwidth;                 // Communication resource
  };

  public type AtlasState = {
    cells : [TerritoryCell];
    totalSovereignty : Float;   // Sum of all sovereignty
    sovereigntyIndex : Float;   // Average sovereignty [0, 1]
    totalResources : Float;
    activeThreats : Nat;
    lastUpdate : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     REAL THREATS                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Threats are REAL. They attack. They persist. They adapt.
  //
  public type Threat = {
    id : Nat32;
    threatClass : ThreatClass;
    
    // Position (can target specific territory)
    targetCell : ?Nat;
    targetShell : ?Nat;
    targetEngine : ?Nat;
    
    // Strength
    intensity : Float;          // [0, ∞) attack strength
    persistence : Float;        // [0, 1] how long it lasts
    adaptability : Float;       // [0, 1] how it learns
    
    // History
    firstSeen : Nat;
    lastSeen : Nat;
    attackCount : Nat;
    successCount : Nat;         // Successful breaches
    
    // Source tracking (for RIFT)
    sourceSignature : Nat64;    // Unique source fingerprint
    sourceCategory : SourceCategory;
    
    // Status
    isActive : Bool;
    isNeutralized : Bool;
    consequenceApplied : Float; // RIFT penalty accumulated
  };

  public type ThreatClass = {
    #IdentityDrift;             // VTV-0: Trying to change who we are
    #CoherenceAttack;           // VTV-1: Disrupting synchronization
    #EconomicTheft;             // VTV-2: Stealing resources
    #DoctrineTampering;         // VTV-3: Altering core laws
    #PrincipalBreach;           // VTV-4: Unauthorized access attempt
    #NeurochemicalPoison;       // VTV-5: Corrupting internal chemistry
    #PredictionJamming;         // VTV-6: Feeding false data
    #WeightCorruption;          // VTV-7: Damaging synaptic weights
    #TerritoryInvasion;         // VTV-8: Taking our territory
    #SystemicAttack;            // VTV-9: Full system assault
    #Unknown;
  };

  public type SourceCategory = {
    #External;                  // Outside attacker
    #Internal;                  // Insider threat
    #Automated;                 // Bot/script attack
    #Coordinated;               // Multi-source attack
    #Persistent;                // APT-style
    #Opportunistic;             // Random probe
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     REAL ADVERSARIES                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // MEMORIA tracks adversaries FOREVER. They never reset.
  // Each attack makes it HARDER for that source to interface.
  //
  public type Adversary = {
    sourceSignature : Nat64;
    
    // History
    firstAttack : Nat;
    lastAttack : Nat;
    totalAttacks : Nat;
    
    // Consequence (RIFT)
    consequenceDepth : Float;   // Accumulated penalty
    interfaceDifficulty : Float;// Grows harder each time (×1.1)
    
    // Classification
    threatClasses : [ThreatClass];
    category : SourceCategory;
    dangerRating : Float;       // Composite danger score
    
    // Tags
    tags : [Text];
    
    // Status
    neverReset : Bool;          // ALWAYS true - permanent record
    banned : Bool;              // Completely blocked
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     REAL DEFENSE BRANCHES                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 1: PERIMETER DEFENSE (DURA)
  // ─────────────────────────────────────────────────────────────────────────
  // 6-axis rotating helix that projects outward
  // Maps adversarial convergence vectors
  //
  public type DuraDefense = {
    // 6 axes
    axes : [DuraAxis];
    
    // Helix state
    helixPhase : Float;         // Overall rotation
    helixSpeed : Float;         // Rotation rate
    
    // Coverage
    totalCoverage : Float;      // Aggregate coverage [0, 1]
    gapCount : Nat;             // Number of coverage gaps
    
    // Adversarial mapping
    convergenceVector : [Float];// 6D vector of attack direction
    
    // Response
    fieldStrength : Float;      // Projected field power
    lastRotation : Nat;
  };

  public type DuraAxis = {
    index : Nat;                // 0-5
    name : Text;                // Core/Lateral/Vertical/Temporal/Identity/Anti
    
    // State
    phase : Float;              // Current rotation angle
    speed : Float;              // Rotation speed (rad/beat)
    coverage : Float;           // [0, 1] how covered
    
    // Load
    adversarialLoad : Float;    // Detected attack pressure
    peakLoad : Float;           // Historical max
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 2: IMMUNE DEFENSE (VAEL)
  // ─────────────────────────────────────────────────────────────────────────
  // Primary immune reflex - fires pre-consciously
  //
  public type VaelDefense = {
    // Immune field
    immuneField : Float;        // identity × coherence × 0.5
    reflexScore : Float;        // immuneField × (1 + threat × 0.1)
    
    // State
    identity : Float;
    coherence : Float;
    threatLevel : Float;
    
    // Response
    lastActivation : Nat;
    activationCount : Nat;
    
    // History
    reflexHistory : [Float];    // Last 10 reflex scores
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 3: COUNTER-STRIKE (RIFT)
  // ─────────────────────────────────────────────────────────────────────────
  // Traces attack sources, applies compounding penalties
  // consequenceDepth += lawScore × 0.0005
  //
  public type RiftDefense = {
    // Traced sources
    tracedSources : [Adversary];
    
    // Active traces
    activeTraces : Nat;
    totalConsequences : Float;
    
    // Tracing state
    traceDepth : Float;         // How deep we trace
    traceSpeed : Float;         // How fast we trace
    
    // Stats
    lastTrace : Nat;
    totalTraces : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 4: MEMORY DEFENSE (MEMORIA)
  // ─────────────────────────────────────────────────────────────────────────
  // Permanent adversary record - NEVER resets
  // compoundFactor += heritageAvg × 0.0001
  //
  public type MemoriaDefense = {
    // Adversary records
    adversaries : [Adversary];
    
    // Heritage integration
    heritageAverage : Float;
    compoundFactor : Float;
    
    // Stats
    totalRecords : Nat;
    bannedCount : Nat;
    lastUpdate : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 5: OUTPUT DEFENSE (VEIL)
  // ─────────────────────────────────────────────────────────────────────────
  // Output membrane - filters what exits
  // filterStrength = vael_immune × aegis_lock × coherence × 0.33
  //
  public type VeilDefense = {
    // Filter
    filterStrength : Float;
    membraneIntegrity : Float;
    
    // Stats
    blockedOutputs : Nat;
    passedOutputs : Nat;
    
    // Zero-exposure enforcement
    zeroExposureActive : Bool;  // No doctrine names exit
    exposureAttempts : Nat;     // Attempted leaks blocked
    
    // History
    filterHistory : [Float];
    lastFilter : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 6: ANCHOR DEFENSE (AEGIS)
  // ─────────────────────────────────────────────────────────────────────────
  // Sovereign anchor - locks, never patches
  // lockStrength = sacesi × identity × coherence × dura_coverage × 0.33
  //
  public type AegisDefense = {
    // Lock
    lockStrength : Float;
    
    // Anchors
    sacesiAnchor : Float;
    identityAnchor : Float;
    coherenceAnchor : Float;
    duraCoverage : Float;
    
    // Stats
    locksApplied : Nat;
    lockAttempts : Nat;
    
    // History
    lockHistory : [Float];
    lastLock : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 7: MONITOR DEFENSE (SENTINEL)
  // ─────────────────────────────────────────────────────────────────────────
  // Output deviation monitor - triggers DURA-VAEL on breach
  //
  public type SentinelDefense = {
    // Monitoring
    outputBaseline : [Float];   // Expected outputs
    currentOutputs : [Float];   // Actual outputs
    deviations : [Float];       // Measured deviations
    
    // Breach detection
    breachDetected : Bool;
    breachSeverity : Float;
    breachThreshold : Float;    // φ^(-1) ≈ 0.618
    
    // DURA-VAEL trigger
    duraVaelTriggered : Bool;
    
    // Stats
    checkCount : Nat;
    breachCount : Nat;
    lastCheck : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 8: ROLLBACK DEFENSE (ARES)
  // ─────────────────────────────────────────────────────────────────────────
  // K=7 snapshot recovery system
  // Auto-triggers when VTV-9 > 1.5
  //
  public type AresDefense = {
    // Snapshots
    snapshots : [AresSnapshot];
    currentSlot : Nat;          // Ring buffer position
    
    // Trigger conditions
    armed : Bool;
    armingConditions : ArmingConditions;
    
    // Auto-rollback
    autoRollbackEnabled : Bool;
    lastAutoRollback : Nat;
    
    // Stats
    totalSnapshots : Nat;
    totalRollbacks : Nat;
    lastSnapshot : Nat;
  };

  public type AresSnapshot = {
    slot : Nat;                 // 0-6
    beat : Nat;                 // When taken
    
    // State captured (4096 weights)
    weightChecksum : Nat64;
    coherenceAtSnapshot : Float;
    
    // Validity
    valid : Bool;
  };

  public type ArmingConditions = {
    cortisolHigh : Bool;        // cortisol > 2.0
    adrenalineHigh : Bool;      // adrenaline > 1.5
    protectionActive : Bool;    // protectionBeats >= 10
    coherenceDropped : Bool;    // coherenceDrop > 0.2
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 9: THREAT ASSESSMENT (VETUS)
  // ─────────────────────────────────────────────────────────────────────────
  // 9 threat vectors continuously updated
  //
  public type VetusDefense = {
    // 9 vectors + critical
    vectors : [VetusVector];
    
    // Global threat
    globalThreatLevel : Float;
    protectionMode : Bool;
    protectionBeats : Nat;
    
    // Response history
    responseHistory : [VetusResponse];
    
    // Stats
    assessmentCount : Nat;
    lastAssessment : Nat;
  };

  public type VetusVector = {
    index : Nat;                // 0-9
    level : Float;              // Current threat level
    threshold : Float;          // Trigger threshold
    triggered : Bool;
    
    // History
    peakLevel : Float;
    triggerCount : Nat;
  };

  public type VetusResponse = {
    vectorIndex : Nat;
    responseType : Text;
    effectiveness : Float;
    beat : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH 10: ANOMALY DETECTION (PROMETHEUS)
  // ─────────────────────────────────────────────────────────────────────────
  // 128-slot observation field with Z-score detection
  //
  public type PrometheusDefense = {
    // Observation field
    observations : [Float];     // 128 slots
    baseline : [Float];         // Rolling baseline
    
    // Anomaly detection
    zScores : [Float];          // Z-scores for each slot
    anomalies : [PrometheusAnomaly];
    
    // Thresholds
    zThreshold : Float;         // e ≈ 2.718
    
    // Auto-recovery
    tier1Actions : Nat;         // Executed immediately
    tier2Actions : Nat;         // Executed with logging
    
    // Stats
    lastObservation : Nat;
    anomalyCount : Nat;
  };

  public type PrometheusAnomaly = {
    slotIndex : Nat;
    zScore : Float;
    severity : Float;
    detectedAt : Nat;
    resolved : Bool;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     REAL MARKETS                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // The organism operates in REAL markets with real prices
  //
  public type MarketState = {
    // Price signals (from oracles)
    btcPrice : Float;
    ethPrice : Float;
    icpPrice : Float;
    solPrice : Float;
    
    // Price history (last 100 beats)
    btcHistory : [Float];
    ethHistory : [Float];
    icpHistory : [Float];
    
    // Volatility
    btcVolatility : Float;
    ethVolatility : Float;
    icpVolatility : Float;
    
    // Last update
    lastOracleUpdate : Nat;
    oracleHealth : Float;       // [0, 1] oracle reliability
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     REAL TIME                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Time is REAL. It passes. Events happen IN time.
  //
  public type TimeState = {
    // Current
    currentBeat : Nat;
    currentTimestamp : Int;     // Nanoseconds since epoch
    
    // Calendar
    genesisTimestamp : Int;     // When organism was born
    ageInBeats : Nat;
    ageInSeconds : Nat;
    
    // Cycles
    jubileeCount : Nat;         // How many JUBILEEs
    beatsUntilJubilee : Nat;    // Countdown
    
    // Chrono dilation
    chronoDilation : Float;     // Subjective time rate
    
    // Historical markers
    firstOMNIS : ?Nat;          // Beat of first OMNIS
    firstCascade : ?Nat;        // Beat of first cascade
    peakCoherenceBeat : Nat;    // Beat of highest coherence
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     THE COMPLETE REAL WORLD                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type RealWorldState = {
    // Territory
    atlas : AtlasState;
    
    // Threats
    activeThreats : [Threat];
    threatHistory : [Threat];
    
    // Defense branches (all 10)
    dura : DuraDefense;
    vael : VaelDefense;
    rift : RiftDefense;
    memoria : MemoriaDefense;
    veil : VeilDefense;
    aegis : AegisDefense;
    sentinel : SentinelDefense;
    ares : AresDefense;
    vetus : VetusDefense;
    prometheus : PrometheusDefense;
    
    // Combined defense
    duraVaelField : Float;      // dura_coverage × vael_immune × aegis_lock × 0.33
    duraVaelActive : Bool;
    
    // 5-layer offense-defense
    offenseDefenseSimultaneous : Bool;
    patternSynthesisGate : Bool;
    valuesCoherenceFilter : Bool;
    truthSeekingOverride : Bool;
    energyAlignmentPrereq : Bool;
    
    // Markets
    markets : MarketState;
    
    // Time
    time : TimeState;
    
    // Global
    worldCoherence : Float;
    worldThreatLevel : Float;
    worldHealth : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initTerritoryCell(x : Nat, y : Nat) : TerritoryCell {
    let index = y * ATLAS_DIM + x;
    {
      x = x;
      y = y;
      index = index;
      sovereigntyLevel = 1.0;   // Start with full sovereignty
      controlledSince = 0;
      resourceDensity = ψ;      // Golden inverse
      resourceType = #Energy;
      extractionRate = 0.001;
      fortificationLevel = S₀;  // Sovereign floor
      threatLevel = 0.0;
      lastAttack = 0;
      pheromoneLevel = 0.0;
      pheromoneDecay = 0.02;    // 2% per beat
      neighborIndices = [];     // Computed separately
    }
  };

  public func initAtlas() : AtlasState {
    let cells = Array.tabulate<TerritoryCell>(ATLAS_CELLS, func(i : Nat) : TerritoryCell {
      initTerritoryCell(i % ATLAS_DIM, i / ATLAS_DIM)
    });
    
    {
      cells = cells;
      totalSovereignty = Float.fromInt(ATLAS_CELLS);
      sovereigntyIndex = 1.0;
      totalResources = Float.fromInt(ATLAS_CELLS) * ψ;
      activeThreats = 0;
      lastUpdate = 0;
    }
  };

  public func initDuraAxis(index : Nat, name : Text) : DuraAxis {
    {
      index = index;
      name = name;
      phase = τ * Float.fromInt(index) / 6.0;
      speed = 0.01 + Float.fromInt(index) * 0.005;
      coverage = 1.0;
      adversarialLoad = 0.0;
      peakLoad = 0.0;
    }
  };

  public func initDura() : DuraDefense {
    {
      axes = [
        initDuraAxis(0, "CORE_SUBSTRATE"),
        initDuraAxis(1, "LATERAL_NODE"),
        initDuraAxis(2, "VERTICAL_IO"),
        initDuraAxis(3, "TEMPORAL"),
        initDuraAxis(4, "IDENTITY_CONTINUITY"),
        initDuraAxis(5, "ANTI_ORGANISM"),
      ];
      helixPhase = 0.0;
      helixSpeed = 0.01;
      totalCoverage = 1.0;
      gapCount = 0;
      convergenceVector = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      fieldStrength = 1.0;
      lastRotation = 0;
    }
  };

  public func initVael() : VaelDefense {
    {
      immuneField = 0.5;
      reflexScore = 0.5;
      identity = 1.0;
      coherence = 1.0;
      threatLevel = 0.0;
      lastActivation = 0;
      activationCount = 0;
      reflexHistory = [];
    }
  };

  public func initRift() : RiftDefense {
    {
      tracedSources = [];
      activeTraces = 0;
      totalConsequences = 0.0;
      traceDepth = 1.0;
      traceSpeed = 1.0;
      lastTrace = 0;
      totalTraces = 0;
    }
  };

  public func initMemoria() : MemoriaDefense {
    {
      adversaries = [];
      heritageAverage = 1.0;
      compoundFactor = 0.0;
      totalRecords = 0;
      bannedCount = 0;
      lastUpdate = 0;
    }
  };

  public func initVeil() : VeilDefense {
    {
      filterStrength = 0.5;
      membraneIntegrity = 1.0;
      blockedOutputs = 0;
      passedOutputs = 0;
      zeroExposureActive = true;
      exposureAttempts = 0;
      filterHistory = [];
      lastFilter = 0;
    }
  };

  public func initAegis() : AegisDefense {
    {
      lockStrength = 0.5;
      sacesiAnchor = 1.0;
      identityAnchor = 1.0;
      coherenceAnchor = 1.0;
      duraCoverage = 1.0;
      locksApplied = 0;
      lockAttempts = 0;
      lockHistory = [];
      lastLock = 0;
    }
  };

  public func initSentinel() : SentinelDefense {
    {
      outputBaseline = [];
      currentOutputs = [];
      deviations = [];
      breachDetected = false;
      breachSeverity = 0.0;
      breachThreshold = ψ;
      duraVaelTriggered = false;
      checkCount = 0;
      breachCount = 0;
      lastCheck = 0;
    }
  };

  public func initAres() : AresDefense {
    {
      snapshots = Array.tabulate<AresSnapshot>(7, func(i : Nat) : AresSnapshot {
        { slot = i; beat = 0; weightChecksum = 0; coherenceAtSnapshot = 1.0; valid = false }
      });
      currentSlot = 0;
      armed = false;
      armingConditions = {
        cortisolHigh = false;
        adrenalineHigh = false;
        protectionActive = false;
        coherenceDropped = false;
      };
      autoRollbackEnabled = true;
      lastAutoRollback = 0;
      totalSnapshots = 0;
      totalRollbacks = 0;
      lastSnapshot = 0;
    }
  };

  public func initVetusVector(index : Nat) : VetusVector {
    let thresholds = [ψ, S₀, ψ, S₀, 1.0, S₀, φ, φ, ψ, φ];
    {
      index = index;
      level = 0.0;
      threshold = if (index < thresholds.size()) { thresholds[index] } else { psi };
      triggered = false;
      peakLevel = 0.0;
      triggerCount = 0;
    }
  };

  public func initVetus() : VetusDefense {
    {
      vectors = Array.tabulate<VetusVector>(10, initVetusVector);
      globalThreatLevel = 0.0;
      protectionMode = false;
      protectionBeats = 0;
      responseHistory = [];
      assessmentCount = 0;
      lastAssessment = 0;
    }
  };

  public func initPrometheus() : PrometheusDefense {
    {
      observations = Array.tabulate<Float>(128, func(_ : Nat) : Float { 1.0 });
      baseline = Array.tabulate<Float>(128, func(_ : Nat) : Float { 1.0 });
      zScores = Array.tabulate<Float>(128, func(_ : Nat) : Float { 0.0 });
      anomalies = [];
      zThreshold = e;
      tier1Actions = 0;
      tier2Actions = 0;
      lastObservation = 0;
      anomalyCount = 0;
    }
  };

  public func initMarkets() : MarketState {
    {
      btcPrice = 60000.0;
      ethPrice = 3000.0;
      icpPrice = 10.0;
      solPrice = 150.0;
      btcHistory = [];
      ethHistory = [];
      icpHistory = [];
      btcVolatility = 0.02;
      ethVolatility = 0.03;
      icpVolatility = 0.05;
      lastOracleUpdate = 0;
      oracleHealth = 1.0;
    }
  };

  public func initTime() : TimeState {
    {
      currentBeat = 0;
      currentTimestamp = Time.now();
      genesisTimestamp = Time.now();
      ageInBeats = 0;
      ageInSeconds = 0;
      jubileeCount = 0;
      beatsUntilJubilee = 987;
      chronoDilation = 1.0;
      firstOMNIS = null;
      firstCascade = null;
      peakCoherenceBeat = 0;
    }
  };

  public func initRealWorld() : RealWorldState {
    {
      atlas = initAtlas();
      activeThreats = [];
      threatHistory = [];
      dura = initDura();
      vael = initVael();
      rift = initRift();
      memoria = initMemoria();
      veil = initVeil();
      aegis = initAegis();
      sentinel = initSentinel();
      ares = initAres();
      vetus = initVetus();
      prometheus = initPrometheus();
      duraVaelField = 0.5;
      duraVaelActive = false;
      offenseDefenseSimultaneous = true;
      patternSynthesisGate = true;
      valuesCoherenceFilter = true;
      truthSeekingOverride = true;
      energyAlignmentPrereq = true;
      markets = initMarkets();
      time = initTime();
      worldCoherence = 1.0;
      worldThreatLevel = 0.0;
      worldHealth = 1.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD UPDATE                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func worldHeartbeat(state : RealWorldState, beat : Nat) : RealWorldState {
    // Update time
    let newTime : TimeState = {
      state.time with
      currentBeat = beat;
      ageInBeats = beat;
      beatsUntilJubilee = if (beat % 987 == 0) { 987 } else { 987 - (beat % 987) };
      jubileeCount = beat / 987;
    };
    
    // Update DURA rotation
    var newDura = state.dura;
    let newHelixPhase = state.dura.helixPhase + state.dura.helixSpeed;
    newDura := { newDura with helixPhase = if (newHelixPhase >= τ) { newHelixPhase - τ } else { newHelixPhase }; lastRotation = beat };
    
    // Compute DURA-VAEL field
    let newDuraVaelField = newDura.totalCoverage * state.vael.immuneField * state.aegis.lockStrength * 0.33;
    let newDuraVaelActive = state.sentinel.breachDetected and newDuraVaelField > 0.1;
    
    // Update world health
    let newWorldHealth = (state.worldCoherence + (1.0 - state.worldThreatLevel) + state.atlas.sovereigntyIndex) / 3.0;
    
    {
      state with
      time = newTime;
      dura = newDura;
      duraVaelField = newDuraVaelField;
      duraVaelActive = newDuraVaelActive;
      worldHealth = newWorldHealth;
    }
  };

  // ============================================================
  // PHYSICS ENGINE — FULL 3D WORLD SIMULATION
  // Position, velocity, acceleration, forces, collisions
  // ============================================================

  // 3D Vector type
  public type Vec3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  // 3D transform (position + rotation + scale)
  public type Transform = {
    position : Vec3;
    rotation : Vec3;   // Euler angles (radians)
    scale    : Vec3;
  };

  // Rigid body physics
  public type RigidBody = {
    id          : Nat32;
    transform   : Transform;
    velocity    : Vec3;
    angularVel  : Vec3;
    mass        : Float;
    inertia     : Vec3;     // Moment of inertia (diagonal)
    drag        : Float;    // Linear drag coefficient
    angularDrag : Float;    // Angular drag coefficient
    isKinematic : Bool;     // If true, not affected by physics
    isStatic    : Bool;     // If true, never moves
    collider    : ColliderType;
  };

  public type ColliderType = {
    #Sphere : { radius : Float };
    #Box : { halfExtents : Vec3 };
    #Capsule : { radius : Float; height : Float };
    #Mesh : { vertexCount : Nat };
  };

  // Vector operations
  public func vec3Add(a : Vec3, b : Vec3) : Vec3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };

  public func vec3Sub(a : Vec3, b : Vec3) : Vec3 {
    { x = a.x - b.x; y = a.y - b.y; z = a.z - b.z }
  };

  public func vec3Scale(v : Vec3, s : Float) : Vec3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };

  public func vec3Dot(a : Vec3, b : Vec3) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };

  public func vec3Cross(a : Vec3, b : Vec3) : Vec3 {
    {
      x = a.y * b.z - a.z * b.y;
      y = a.z * b.x - a.x * b.z;
      z = a.x * b.y - a.y * b.x;
    }
  };

  public func vec3Length(v : Vec3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };

  public func vec3Normalize(v : Vec3) : Vec3 {
    let len = vec3Length(v);
    if (len < 0.0001) { { x = 0.0; y = 0.0; z = 0.0 } }
    else { vec3Scale(v, 1.0 / len) }
  };

  public func vec3Distance(a : Vec3, b : Vec3) : Float {
    vec3Length(vec3Sub(a, b))
  };

  public func vec3Lerp(a : Vec3, b : Vec3, t : Float) : Vec3 {
    {
      x = a.x + (b.x - a.x) * t;
      y = a.y + (b.y - a.y) * t;
      z = a.z + (b.z - a.z) * t;
    }
  };

  public let VEC3_ZERO : Vec3 = { x = 0.0; y = 0.0; z = 0.0 };
  public let VEC3_ONE : Vec3 = { x = 1.0; y = 1.0; z = 1.0 };
  public let VEC3_UP : Vec3 = { x = 0.0; y = 1.0; z = 0.0 };
  public let VEC3_FORWARD : Vec3 = { x = 0.0; y = 0.0; z = 1.0 };
  public let VEC3_RIGHT : Vec3 = { x = 1.0; y = 0.0; z = 0.0 };

  // Physics constants
  public let GRAVITY : Float = 9.81;           // m/s²
  public let AIR_DENSITY : Float = 1.225;       // kg/m³
  public let SPEED_OF_SOUND : Float = 343.0;    // m/s at sea level
  public let TERMINAL_VELOCITY : Float = 53.0;  // m/s for human

  // Apply gravity to rigid body
  public func applyGravity(body : RigidBody, dt : Float) : RigidBody {
    if (body.isKinematic or body.isStatic) { return body };
    
    let gravityForce = { x = 0.0; y = -GRAVITY; z = 0.0 };
    let acceleration = vec3Scale(gravityForce, 1.0);  // F = ma, a = F/m (mass normalized)
    let newVelocity = vec3Add(body.velocity, vec3Scale(acceleration, dt));
    
    {
      body with
      velocity = newVelocity;
    }
  };

  // Apply drag to rigid body
  // F_drag = -0.5 × ρ × v² × C_d × A
  public func applyDrag(body : RigidBody, dt : Float) : RigidBody {
    if (body.isKinematic or body.isStatic) { return body };
    
    let speed = vec3Length(body.velocity);
    if (speed < 0.001) { return body };
    
    // Drag force opposes velocity
    let direction = vec3Normalize(body.velocity);
    let dragMagnitude = 0.5 * AIR_DENSITY * speed * speed * body.drag;
    let dragForce = vec3Scale(direction, -dragMagnitude);
    let acceleration = vec3Scale(dragForce, 1.0 / body.mass);
    
    let newVelocity = vec3Add(body.velocity, vec3Scale(acceleration, dt));
    
    // Apply angular drag
    let angularSpeed = vec3Length(body.angularVel);
    let angularDragMag = angularSpeed * body.angularDrag;
    let newAngularVel = if (angularSpeed < 0.001) {
      body.angularVel
    } else {
      let angDir = vec3Normalize(body.angularVel);
      vec3Add(body.angularVel, vec3Scale(angDir, -angularDragMag * dt))
    };
    
    {
      body with
      velocity = newVelocity;
      angularVel = newAngularVel;
    }
  };

  // Integrate rigid body motion
  public func integrateRigidBody(body : RigidBody, dt : Float) : RigidBody {
    if (body.isStatic) { return body };
    
    // Update position from velocity
    let newPosition = vec3Add(body.transform.position, vec3Scale(body.velocity, dt));
    
    // Update rotation from angular velocity
    let newRotation = vec3Add(body.transform.rotation, vec3Scale(body.angularVel, dt));
    
    let newTransform = {
      position = newPosition;
      rotation = newRotation;
      scale = body.transform.scale;
    };
    
    {
      body with
      transform = newTransform;
    }
  };

  // Full physics step
  public func physicsStep(body : RigidBody, dt : Float) : RigidBody {
    var b = body;
    b := applyGravity(b, dt);
    b := applyDrag(b, dt);
    b := integrateRigidBody(b, dt);
    b
  };

  // Sphere-sphere collision detection
  public func sphereCollision(
    posA : Vec3, radiusA : Float,
    posB : Vec3, radiusB : Float
  ) : Bool {
    let dist = vec3Distance(posA, posB);
    dist < (radiusA + radiusB)
  };

  // Sphere-sphere collision response
  public func sphereCollisionResponse(
    bodyA : RigidBody, radiusA : Float,
    bodyB : RigidBody, radiusB : Float,
    restitution : Float  // Bounciness [0, 1]
  ) : (RigidBody, RigidBody) {
    let posA = bodyA.transform.position;
    let posB = bodyB.transform.position;
    
    let normal = vec3Normalize(vec3Sub(posB, posA));
    let relativeVel = vec3Sub(bodyA.velocity, bodyB.velocity);
    let velAlongNormal = vec3Dot(relativeVel, normal);
    
    // Don't resolve if velocities are separating
    if (velAlongNormal > 0.0) { return (bodyA, bodyB) };
    
    // Impulse magnitude
    let totalMass = bodyA.mass + bodyB.mass;
    let j = -(1.0 + restitution) * velAlongNormal / totalMass;
    
    let impulse = vec3Scale(normal, j);
    
    let newVelA = if (bodyA.isKinematic or bodyA.isStatic) { bodyA.velocity } 
                  else { vec3Add(bodyA.velocity, vec3Scale(impulse, 1.0 / bodyA.mass)) };
    let newVelB = if (bodyB.isKinematic or bodyB.isStatic) { bodyB.velocity }
                  else { vec3Sub(bodyB.velocity, vec3Scale(impulse, 1.0 / bodyB.mass)) };
    
    ({ bodyA with velocity = newVelA }, { bodyB with velocity = newVelB })
  };

  // ============================================================
  // TERRAIN SYSTEM — HEIGHT MAPS, BIOMES, RESOURCES
  // ============================================================

  public type TerrainType = {
    #Plains;
    #Forest;
    #Mountain;
    #Desert;
    #Water;
    #Snow;
    #Swamp;
    #Urban;
    #Industrial;
    #Wasteland;
  };

  public type TerrainCell = {
    x           : Nat;
    y           : Nat;
    height      : Float;       // Height in meters
    terrainType : TerrainType;
    
    // Navigation
    walkable    : Bool;
    movementCost: Float;       // 1.0 = normal, higher = slower
    
    // Resources
    resourceType: ?ResourceType;
    resourceAmount: Float;
    
    // Cover (for combat)
    coverLevel  : Float;       // [0, 1] — protection from fire
    
    // Visibility
    visibilityRange : Float;   // How far can see from here
    isObstructed    : Bool;    // Blocks line of sight
    
    // Environmental
    temperature : Float;       // Celsius
    humidity    : Float;       // [0, 1]
    radiation   : Float;       // [0, 1] hazard level
  };

  public type TerrainGrid = {
    width    : Nat;
    height   : Nat;
    cells    : [TerrainCell];
    minHeight: Float;
    maxHeight: Float;
    seaLevel : Float;
  };

  // Generate procedural terrain height
  // Uses simple fractal noise approximation
  public func generateHeight(x : Nat, y : Nat, seed : Nat) : Float {
    // Pseudo-random based on position and seed
    let n1 = (x * 374761393 + y * 668265263 + seed) % 1000000;
    let n2 = (x * 1274126177 + y * 1572833513 + seed) % 1000000;
    let n3 = (x * 2174126177 + y * 2572833513 + seed) % 1000000;
    
    // Multi-octave noise
    let octave1 = Float.fromInt(n1) / 1000000.0;
    let octave2 = Float.fromInt(n2) / 1000000.0 * 0.5;
    let octave3 = Float.fromInt(n3) / 1000000.0 * 0.25;
    
    (octave1 + octave2 + octave3) / 1.75 * 100.0  // Height in meters
  };

  // Determine terrain type from height and position
  public func determineTerrainType(height : Float, humidity : Float) : TerrainType {
    if (height < 0.0) { #Water }
    else if (height > 80.0) { #Snow }
    else if (height > 60.0) { #Mountain }
    else if (humidity < 0.2) { #Desert }
    else if (humidity > 0.8) { #Swamp }
    else if (humidity > 0.5) { #Forest }
    else { #Plains }
  };

  // Initialize terrain cell
  public func initTerrainCell(x : Nat, y : Nat, seed : Nat) : TerrainCell {
    let height = generateHeight(x, y, seed);
    let humidity = Float.fromInt((x * 123 + y * 456 + seed) % 100) / 100.0;
    let terrainType = determineTerrainType(height, humidity);
    
    let (walkable, movementCost, coverLevel) = switch (terrainType) {
      case (#Plains) { (true, 1.0, 0.1) };
      case (#Forest) { (true, 1.5, 0.6) };
      case (#Mountain) { (true, 3.0, 0.8) };
      case (#Desert) { (true, 1.2, 0.0) };
      case (#Water) { (false, 10.0, 0.0) };
      case (#Snow) { (true, 2.0, 0.2) };
      case (#Swamp) { (true, 2.5, 0.3) };
      case (#Urban) { (true, 1.0, 0.7) };
      case (#Industrial) { (true, 1.0, 0.5) };
      case (#Wasteland) { (true, 1.3, 0.2) };
    };
    
    {
      x = x;
      y = y;
      height = height;
      terrainType = terrainType;
      walkable = walkable;
      movementCost = movementCost;
      resourceType = null;
      resourceAmount = 0.0;
      coverLevel = coverLevel;
      visibilityRange = 100.0 - coverLevel * 50.0;
      isObstructed = not walkable;
      temperature = 20.0 - height * 0.1;
      humidity = humidity;
      radiation = 0.0;
    }
  };

  // Initialize full terrain grid
  public func initTerrainGrid(width : Nat, height : Nat, seed : Nat) : TerrainGrid {
    let cells = Array.tabulate<TerrainCell>(width * height, func(i) {
      let x = i % width;
      let y = i / width;
      initTerrainCell(x, y, seed)
    });
    
    var minH : Float = 10000.0;
    var maxH : Float = -10000.0;
    for (cell in cells.vals()) {
      if (cell.height < minH) { minH := cell.height };
      if (cell.height > maxH) { maxH := cell.height };
    };
    
    {
      width = width;
      height = height;
      cells = cells;
      minHeight = minH;
      maxHeight = maxH;
      seaLevel = 0.0;
    }
  };

  // Get terrain cell at position
  public func getTerrainCell(grid : TerrainGrid, x : Nat, y : Nat) : ?TerrainCell {
    if (x >= grid.width or y >= grid.height) { return null };
    let idx = y * grid.width + x;
    if (idx >= grid.cells.size()) { return null };
    ?grid.cells[idx]
  };

  // ============================================================
  // WEATHER SYSTEM — FULL ATMOSPHERIC SIMULATION
  // ============================================================

  public type WeatherType = {
    #Clear;
    #Cloudy;
    #Overcast;
    #Rain;
    #HeavyRain;
    #Thunderstorm;
    #Snow;
    #Blizzard;
    #Fog;
    #Sandstorm;
  };

  public type WeatherState = {
    weatherType     : WeatherType;
    temperature     : Float;      // Celsius
    humidity        : Float;      // [0, 1]
    pressure        : Float;      // hPa
    windSpeed       : Float;      // m/s
    windDirection   : Float;      // Radians from north
    precipitation   : Float;      // mm/hour
    visibility      : Float;      // km
    cloudCover      : Float;      // [0, 1]
    uvIndex         : Float;      // [0, 11+]
    
    // Time of day
    sunAltitude     : Float;      // Degrees above horizon
    sunAzimuth      : Float;      // Degrees from north
    moonPhase       : Float;      // [0, 1] — 0 = new, 0.5 = full
    isDay           : Bool;
    
    // Forecast
    forecastType    : WeatherType;
    forecastHours   : Nat;
    
    // History
    lastUpdate      : Nat;
  };

  // Weather effects on gameplay
  public type WeatherEffects = {
    visibilityMultiplier : Float;    // How much visibility is reduced
    movementMultiplier   : Float;    // How much movement is slowed
    accuracyMultiplier   : Float;    // How much accuracy is reduced
    moralePenalty        : Float;    // Penalty to troop morale
    fuelConsumption      : Float;    // Extra fuel consumption
    communicationPenalty : Float;    // Radio/comm degradation
  };

  // Compute weather effects
  public func computeWeatherEffects(weather : WeatherState) : WeatherEffects {
    let (visMult, movMult, accMult, moralePen, fuelCons, commPen) = switch (weather.weatherType) {
      case (#Clear) { (1.0, 1.0, 1.0, 0.0, 1.0, 1.0) };
      case (#Cloudy) { (0.95, 1.0, 0.98, 0.0, 1.0, 1.0) };
      case (#Overcast) { (0.85, 1.0, 0.95, 0.02, 1.0, 0.98) };
      case (#Rain) { (0.6, 0.9, 0.85, 0.05, 1.1, 0.9) };
      case (#HeavyRain) { (0.3, 0.7, 0.6, 0.15, 1.3, 0.7) };
      case (#Thunderstorm) { (0.2, 0.5, 0.4, 0.25, 1.5, 0.3) };
      case (#Snow) { (0.5, 0.6, 0.7, 0.1, 1.4, 0.85) };
      case (#Blizzard) { (0.1, 0.3, 0.3, 0.3, 2.0, 0.2) };
      case (#Fog) { (0.15, 0.8, 0.5, 0.08, 1.0, 0.95) };
      case (#Sandstorm) { (0.1, 0.4, 0.3, 0.2, 1.8, 0.4) };
    };
    
    {
      visibilityMultiplier = visMult;
      movementMultiplier = movMult;
      accuracyMultiplier = accMult;
      moralePenalty = moralePen;
      fuelConsumption = fuelCons;
      communicationPenalty = commPen;
    }
  };

  // Initialize weather
  public func initWeather() : WeatherState {
    {
      weatherType = #Clear;
      temperature = 20.0;
      humidity = 0.5;
      pressure = 1013.25;
      windSpeed = 5.0;
      windDirection = 0.0;
      precipitation = 0.0;
      visibility = 10.0;
      cloudCover = 0.2;
      uvIndex = 5.0;
      sunAltitude = 45.0;
      sunAzimuth = 180.0;
      moonPhase = 0.5;
      isDay = true;
      forecastType = #Clear;
      forecastHours = 6;
      lastUpdate = 0;
    }
  };

  // Update weather based on time and season
  public func updateWeather(weather : WeatherState, beat : Nat, seed : Nat) : WeatherState {
    // Pseudo-random weather change
    let rand = (beat * 1274126177 + seed) % 1000;
    
    // Weather transitions based on random value
    let newType = if (rand < 400) { #Clear }
                  else if (rand < 600) { #Cloudy }
                  else if (rand < 750) { #Rain }
                  else if (rand < 850) { #Overcast }
                  else if (rand < 900) { #Fog }
                  else if (rand < 950) { #HeavyRain }
                  else if (rand < 980) { #Thunderstorm }
                  else { #Snow };
    
    // Update sun position based on beat (assume 1 beat = 1 minute, 1440 beats = 1 day)
    let minuteOfDay = beat % 1440;
    let hourFloat = Float.fromInt(minuteOfDay) / 60.0;
    let sunAlt = 45.0 * Float.sin((hourFloat - 6.0) * π / 12.0);
    let sunAz = 180.0 + (hourFloat - 12.0) * 15.0;
    let isDay = sunAlt > 0.0;
    
    // Moon phase cycles every ~30 days (43200 beats)
    let moonPhase = Float.fromInt(beat % 43200) / 43200.0;
    
    {
      weather with
      weatherType = newType;
      sunAltitude = sunAlt;
      sunAzimuth = sunAz;
      moonPhase = moonPhase;
      isDay = isDay;
      lastUpdate = beat;
    }
  };

  // ============================================================
  // PATHFINDING — A* ALGORITHM IMPLEMENTATION
  // ============================================================

  public type PathNode = {
    x        : Nat;
    y        : Nat;
    gCost    : Float;     // Cost from start
    hCost    : Float;     // Heuristic cost to end
    fCost    : Float;     // g + h
    parent   : ?(Nat, Nat);
  };

  // Manhattan distance heuristic
  public func manhattanDistance(x1 : Nat, y1 : Nat, x2 : Nat, y2 : Nat) : Float {
    let dx = if (x1 > x2) { x1 - x2 } else { x2 - x1 };
    let dy = if (y1 > y2) { y1 - y2 } else { y2 - y1 };
    Float.fromInt(dx + dy)
  };

  // Euclidean distance heuristic
  public func euclideanDistance(x1 : Nat, y1 : Nat, x2 : Nat, y2 : Nat) : Float {
    let dx = Float.fromInt(x1) - Float.fromInt(x2);
    let dy = Float.fromInt(y1) - Float.fromInt(y2);
    Float.sqrt(dx * dx + dy * dy)
  };

  // Get neighbors for pathfinding (8-directional)
  public func getNeighbors(x : Nat, y : Nat, width : Nat, height : Nat) : [(Nat, Nat)] {
    var neighbors = Buffer.Buffer<(Nat, Nat)>(8);
    
    // Cardinal directions
    if (x > 0) { neighbors.add((x - 1, y)) };
    if (x < width - 1) { neighbors.add((x + 1, y)) };
    if (y > 0) { neighbors.add((x, y - 1)) };
    if (y < height - 1) { neighbors.add((x, y + 1)) };
    
    // Diagonal directions
    if (x > 0 and y > 0) { neighbors.add((x - 1, y - 1)) };
    if (x > 0 and y < height - 1) { neighbors.add((x - 1, y + 1)) };
    if (x < width - 1 and y > 0) { neighbors.add((x + 1, y - 1)) };
    if (x < width - 1 and y < height - 1) { neighbors.add((x + 1, y + 1)) };
    
    Buffer.toArray(neighbors)
  };

  // ============================================================
  // LINE OF SIGHT — BRESENHAM'S LINE ALGORITHM
  // ============================================================

  // Check if there's a clear line of sight between two points
  public func hasLineOfSight(
    grid : TerrainGrid,
    x1 : Nat, y1 : Nat,
    x2 : Nat, y2 : Nat
  ) : Bool {
    // Bresenham's line algorithm
    var x = Int.abs(x1);
    var y = Int.abs(y1);
    let x2i = Int.abs(x2);
    let y2i = Int.abs(y2);
    
    let dx = Int.abs(x2i - x);
    let dy = Int.abs(y2i - y);
    let sx = if (x < x2i) { 1 } else { -1 };
    let sy = if (y < y2i) { 1 } else { -1 };
    var err = dx - dy;
    
    var blocked = false;
    var iterations = 0;
    let maxIterations = dx + dy + 1;
    
    while (not blocked and iterations < maxIterations) {
      // Check current cell
      let cellOpt = getTerrainCell(grid, Int.abs(x), Int.abs(y));
      switch (cellOpt) {
        case (?cell) {
          if (cell.isObstructed and (x != x1 or y != y1) and (x != x2i or y != y2i)) {
            blocked := true;
          };
        };
        case null { blocked := true };
      };
      
      if (x == x2i and y == y2i) { iterations := maxIterations }
      else {
        let e2 = 2 * err;
        if (e2 > -dy) { err -= dy; x += sx };
        if (e2 < dx) { err += dx; y += sy };
      };
      
      iterations += 1;
    };
    
    not blocked
  };

  // ============================================================
  // RESOURCE EXTRACTION AND ECONOMY
  // ============================================================

  public type ResourceNode = {
    id           : Nat32;
    resourceType : ResourceType;
    position     : (Nat, Nat);
    totalAmount  : Float;
    remainingAmount : Float;
    extractionRate : Float;    // Units per beat
    quality      : Float;      // [0, 1] — affects yield
    isActive     : Bool;
    controlledBy : ?Nat;       // Faction ID
  };

  // Extract resources from a node
  public func extractResource(node : ResourceNode, efficiency : Float) : (ResourceNode, Float) {
    if (not node.isActive or node.remainingAmount <= 0.0) {
      return (node, 0.0);
    };
    
    let extraction = Float.min(node.extractionRate * efficiency * node.quality, node.remainingAmount);
    let newRemaining = node.remainingAmount - extraction;
    let newNode = { node with remainingAmount = newRemaining; isActive = newRemaining > 0.0 };
    
    (newNode, extraction)
  };

  // ============================================================
  // UNIT SPAWNING AND MANAGEMENT
  // ============================================================

  public type UnitType = {
    #Infantry;
    #HeavyInfantry;
    #Sniper;
    #Medic;
    #Engineer;
    #LightVehicle;
    #HeavyVehicle;
    #Tank;
    #Artillery;
    #Helicopter;
    #Drone;
    #SpecOps;
  };

  public type UnitStats = {
    health       : Float;
    maxHealth    : Float;
    armor        : Float;      // Damage reduction [0, 1]
    speed        : Float;      // Movement speed
    attackPower  : Float;
    attackRange  : Float;
    fireRate     : Float;      // Attacks per beat
    accuracy     : Float;      // [0, 1]
    morale       : Float;      // [0, 1]
    fatigue      : Float;      // [0, 1]
    suppression  : Float;      // [0, 1] — reduces effectiveness
  };

  public type Unit = {
    id         : Nat32;
    unitType   : UnitType;
    factionId  : Nat;
    stats      : UnitStats;
    position   : Vec3;
    destination: ?Vec3;
    state      : UnitState;
    kills      : Nat;
    experience : Float;
  };

  public type UnitState = {
    #Idle;
    #Moving;
    #Attacking;
    #Defending;
    #Retreating;
    #Healing;
    #Dead;
  };

  // Base stats for each unit type
  public func getBaseStats(unitType : UnitType) : UnitStats {
    switch (unitType) {
      case (#Infantry) {
        { health = 100.0; maxHealth = 100.0; armor = 0.1; speed = 5.0; attackPower = 20.0; attackRange = 50.0; fireRate = 2.0; accuracy = 0.7; morale = 0.8; fatigue = 0.0; suppression = 0.0 }
      };
      case (#HeavyInfantry) {
        { health = 150.0; maxHealth = 150.0; armor = 0.3; speed = 4.0; attackPower = 30.0; attackRange = 40.0; fireRate = 1.5; accuracy = 0.65; morale = 0.85; fatigue = 0.0; suppression = 0.0 }
      };
      case (#Sniper) {
        { health = 80.0; maxHealth = 80.0; armor = 0.05; speed = 4.5; attackPower = 80.0; attackRange = 200.0; fireRate = 0.3; accuracy = 0.95; morale = 0.75; fatigue = 0.0; suppression = 0.0 }
      };
      case (#Medic) {
        { health = 90.0; maxHealth = 90.0; armor = 0.05; speed = 5.5; attackPower = 10.0; attackRange = 30.0; fireRate = 1.0; accuracy = 0.6; morale = 0.9; fatigue = 0.0; suppression = 0.0 }
      };
      case (#Engineer) {
        { health = 100.0; maxHealth = 100.0; armor = 0.15; speed = 4.5; attackPower = 15.0; attackRange = 30.0; fireRate = 1.5; accuracy = 0.65; morale = 0.8; fatigue = 0.0; suppression = 0.0 }
      };
      case (#LightVehicle) {
        { health = 200.0; maxHealth = 200.0; armor = 0.4; speed = 15.0; attackPower = 40.0; attackRange = 80.0; fireRate = 3.0; accuracy = 0.6; morale = 0.9; fatigue = 0.0; suppression = 0.0 }
      };
      case (#HeavyVehicle) {
        { health = 400.0; maxHealth = 400.0; armor = 0.6; speed = 8.0; attackPower = 60.0; attackRange = 100.0; fireRate = 2.0; accuracy = 0.7; morale = 0.95; fatigue = 0.0; suppression = 0.0 }
      };
      case (#Tank) {
        { health = 800.0; maxHealth = 800.0; armor = 0.8; speed = 10.0; attackPower = 150.0; attackRange = 150.0; fireRate = 0.5; accuracy = 0.75; morale = 0.95; fatigue = 0.0; suppression = 0.0 }
      };
      case (#Artillery) {
        { health = 300.0; maxHealth = 300.0; armor = 0.3; speed = 5.0; attackPower = 200.0; attackRange = 500.0; fireRate = 0.2; accuracy = 0.5; morale = 0.85; fatigue = 0.0; suppression = 0.0 }
      };
      case (#Helicopter) {
        { health = 250.0; maxHealth = 250.0; armor = 0.2; speed = 25.0; attackPower = 80.0; attackRange = 150.0; fireRate = 2.0; accuracy = 0.7; morale = 0.9; fatigue = 0.0; suppression = 0.0 }
      };
      case (#Drone) {
        { health = 50.0; maxHealth = 50.0; armor = 0.0; speed = 30.0; attackPower = 30.0; attackRange = 100.0; fireRate = 1.0; accuracy = 0.8; morale = 1.0; fatigue = 0.0; suppression = 0.0 }
      };
      case (#SpecOps) {
        { health = 120.0; maxHealth = 120.0; armor = 0.2; speed = 6.0; attackPower = 50.0; attackRange = 80.0; fireRate = 2.5; accuracy = 0.9; morale = 0.95; fatigue = 0.0; suppression = 0.0 }
      };
    }
  };

  // Combat damage calculation
  public func calculateDamage(
    attacker : Unit,
    defender : Unit,
    distance : Float,
    weather : WeatherState
  ) : Float {
    // Base damage
    var damage = attacker.stats.attackPower;
    
    // Range falloff
    let rangeFactor = if (distance > attacker.stats.attackRange) { 0.0 }
                      else { 1.0 - (distance / attacker.stats.attackRange) * 0.5 };
    damage *= rangeFactor;
    
    // Accuracy
    let weatherEffects = computeWeatherEffects(weather);
    let hitChance = attacker.stats.accuracy * weatherEffects.accuracyMultiplier * (1.0 - attacker.stats.suppression);
    damage *= hitChance;
    
    // Armor reduction
    damage *= (1.0 - defender.stats.armor);
    
    // Morale factor
    damage *= attacker.stats.morale;
    
    // Fatigue reduction
    damage *= (1.0 - attacker.stats.fatigue * 0.3);
    
    Float.max(0.0, damage)
  };

}

  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  W O R L D   S I M U L A T I O N   M A T H E M A T I C S
  //
  //  Enterprise-Level World Modeling and Physics
  //  Full HIM/HER Integration for Virtual Environments
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // PHYSICS SIMULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Newtonian mechanics: F = ma
  public func worldForceToAcceleration(force : Float, mass : Float) : Float {
    if (mass < 0.0001) { 0.0 } else { force / mass }
  };

  /// Velocity update: v = v0 + a*t
  public func worldVelocityUpdate(v0 : Float, acceleration : Float, dt : Float) : Float {
    v0 + acceleration * dt
  };

  /// Position update: x = x0 + v*t + 0.5*a*t²
  public func worldPositionUpdate(x0 : Float, velocity : Float, acceleration : Float, dt : Float) : Float {
    x0 + velocity * dt + 0.5 * acceleration * dt * dt
  };

  /// Gravitational force: F = G*m1*m2/r²
  public func worldGravitationalForce(m1 : Float, m2 : Float, distance : Float, g : Float) : Float {
    if (distance < 0.0001) { 0.0 }
    else { g * m1 * m2 / (distance * distance) }
  };

  /// Drag force: F = 0.5*rho*v²*Cd*A
  public func worldDragForce(density : Float, velocity : Float, dragCoeff : Float, area : Float) : Float {
    0.5 * density * velocity * velocity * dragCoeff * area
  };

  /// Spring force: F = -k*x
  public func worldSpringForce(springConstant : Float, displacement : Float) : Float {
    -springConstant * displacement
  };

  /// Friction force: F = μ*N
  public func worldFrictionForce(frictionCoeff : Float, normalForce : Float) : Float {
    frictionCoeff * normalForce
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COLLISION DETECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// AABB collision test
  public func worldAABBCollision(
    ax1 : Float, ay1 : Float, ax2 : Float, ay2 : Float,
    bx1 : Float, by1 : Float, bx2 : Float, by2 : Float
  ) : Bool {
    ax1 <= bx2 and ax2 >= bx1 and ay1 <= by2 and ay2 >= by1
  };

  /// Circle collision test
  public func worldCircleCollision(
    x1 : Float, y1 : Float, r1 : Float,
    x2 : Float, y2 : Float, r2 : Float
  ) : Bool {
    let dx = x2 - x1;
    let dy = y2 - y1;
    let dist = Float.sqrt(dx * dx + dy * dy);
    dist < (r1 + r2)
  };

  /// Point in triangle test
  public func worldPointInTriangle(
    px : Float, py : Float,
    ax : Float, ay : Float,
    bx : Float, by : Float,
    cx : Float, cy : Float
  ) : Bool {
    func sign(p1x : Float, p1y : Float, p2x : Float, p2y : Float, p3x : Float, p3y : Float) : Float {
      (p1x - p3x) * (p2y - p3y) - (p2x - p3x) * (p1y - p3y)
    };
    let d1 = sign(px, py, ax, ay, bx, by);
    let d2 = sign(px, py, bx, by, cx, cy);
    let d3 = sign(px, py, cx, cy, ax, ay);
    let hasNeg = (d1 < 0.0) or (d2 < 0.0) or (d3 < 0.0);
    let hasPos = (d1 > 0.0) or (d2 > 0.0) or (d3 > 0.0);
    not (hasNeg and hasPos)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TERRAIN GENERATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Simple noise function (pseudo-random)
  public func worldSimpleNoise(x : Nat, y : Nat, seed : Nat) : Float {
    let n = x + y * 57 + seed * 131;
    let m = ((n * (n * n * 15731 + 789221) + 1376312589) % 2147483648);
    Float.fromInt(m % 1000000) / 1000000.0
  };

  /// Linear interpolation
  public func worldLerp(a : Float, b : Float, t : Float) : Float {
    a + t * (b - a)
  };

  /// Smooth interpolation
  public func worldSmoothStep(t : Float) : Float {
    t * t * (3.0 - 2.0 * t)
  };

  /// Height map sample
  public func worldHeightMapSample(
    x : Float, y : Float,
    octaves : Nat,
    persistence : Float,
    lacunarity : Float,
    seed : Nat
  ) : Float {
    var total : Float = 0.0;
    var amplitude : Float = 1.0;
    var frequency : Float = 1.0;
    var maxVal : Float = 0.0;
    var i = 0;
    while (i < octaves) {
      let xi = Int.abs(Float.toInt(x * frequency));
      let yi = Int.abs(Float.toInt(y * frequency));
      total += worldSimpleNoise(xi, yi, seed + i) * amplitude;
      maxVal += amplitude;
      amplitude *= persistence;
      frequency *= lacunarity;
      i += 1;
    };
    total / maxVal
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // WEATHER SIMULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Temperature model
  public func worldTemperature(
    baseTemp : Float,
    latitude : Float,
    altitude : Float,
    timeOfDay : Float
  ) : Float {
    let latFactor = Float.cos(latitude * 3.14159265 / 180.0) * 30.0;
    let altFactor = -altitude * 0.0065;
    let diurnalFactor = 5.0 * Float.sin((timeOfDay - 6.0) * 3.14159265 / 12.0);
    baseTemp + latFactor + altFactor + diurnalFactor
  };

  /// Wind speed from pressure gradient
  public func worldWindSpeed(
    pressureGradient : Float,
    coriolisFactor : Float,
    friction : Float
  ) : Float {
    pressureGradient / (coriolisFactor + friction + 0.01)
  };

  /// Precipitation probability
  public func worldPrecipitationProb(
    humidity : Float,
    temperature : Float,
    pressure : Float
  ) : Float {
    let saturation = humidity / (1.0 + Float.exp(-0.1 * (temperature - 10.0)));
    let instability = 1.0 / (pressure + 0.01);
    Float.min(saturation * instability * 2.0, 1.0)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE DISTRIBUTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Resource density based on terrain
  public func worldResourceDensity(
    terrainType : Nat,
    height : Float,
    moisture : Float
  ) : Float {
    let baseDensity = Float.fromInt(terrainType % 10) / 10.0;
    let heightFactor = 1.0 - Float.abs(height - 0.5);
    let moistureFactor = moisture;
    baseDensity * heightFactor * moistureFactor
  };

  /// Population growth model
  public func worldPopulationGrowth(
    population : Float,
    resources : Float,
    capacity : Float,
    growthRate : Float
  ) : Float {
    let resourceFactor = resources / (resources + 1.0);
    let carryingFactor = 1.0 - population / capacity;
    population * growthRate * resourceFactor * carryingFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPATIAL INDEXING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Grid cell index from position
  public func worldGridIndex(x : Float, y : Float, cellSize : Float) : (Nat, Nat) {
    let ix = Int.abs(Float.toInt(x / cellSize));
    let iy = Int.abs(Float.toInt(y / cellSize));
    (ix, iy)
  };

  /// Distance between grid cells
  public func worldGridDistance(x1 : Nat, y1 : Nat, x2 : Nat, y2 : Nat) : Float {
    let dx = Float.fromInt(if (x1 > x2) x1 - x2 else x2 - x1);
    let dy = Float.fromInt(if (y1 > y2) y1 - y2 else y2 - y1);
    Float.sqrt(dx * dx + dy * dy)
  };

  /// Morton code for Z-order curve
  public func worldMortonCode(x : Nat, y : Nat) : Nat {
    var mx = x;
    var my = y;
    var code : Nat = 0;
    var bit : Nat = 0;
    while (bit < 16) {
      code += ((mx % 2) * 2 + (my % 2)) * (4 ** bit);
      mx /= 2;
      my /= 2;
      bit += 1;
    };
    code
  };

}
