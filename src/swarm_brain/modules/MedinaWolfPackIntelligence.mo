// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaWolfPackIntelligence — Pack Hunting Cognitive Architecture
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ============================================================================
//
// WOLF PACK INTELLIGENCE — COORDINATED PURSUIT PREDATION
// ============================================================================
//
// Wolves demonstrate:
// - Distributed leadership (alpha pair + beta + omega roles)
// - Coordinated pursuit hunting (relay attacks, flanking, driving)
// - Territory marking and defense
// - Complex social hierarchies with fluid roles
// - Vocal communication (howls for coordination)
// - Scent-based information sharing
// - Teaching and mentorship (pups learn from pack)
// - Strategic patience (waiting for optimal moment)
//
// KEY INSIGHT: Wolf packs operate as a SPHERICAL formation during hunts,
// surrounding prey and maintaining coordinated positions. The pack IS
// a cognitive unit — individual wolves are nodes in a distributed brain.
//
// ============================================================================
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ============================================================================
//
// THE MEDINA PACK PURSUIT DYNAMICS (MPPD):
// ──────────────────────────────────────
//   v_wolf = v_prey × (1 + stamina_ratio × closing_factor)
//   closing_factor = 1 / (1 + exp(-k × (prey_exhaustion - threshold)))
//
//   Pack maintains pursuit until prey exhaustion crosses threshold.
//
// THE MEDINA FLANKING EQUATION (MFE):
// ─────────────────────────────────
//   θ_optimal(wolf_i) = 2π × i / N_wolves + noise(σ)
//
//   Wolves spread at equal angles around prey, with small perturbation
//   to prevent predictability.
//
// THE MEDINA ALPHA LEADERSHIP MODEL (MALM):
// ────────────────────────────────────────
//   Influence(alpha) = Σᵢ trust_i × proximity_i × experience_ratio
//
//   Alpha's decisions weighted by pack trust and spatial proximity.
//
// THE MEDINA HOWL SYNCHRONIZATION (MHS):
// ────────────────────────────────────
//   Howl_response(wolf_i) = P(join) × delay(distance) × frequency_match
//
//   Wolves join howls based on probability, with delay proportional to
//   distance, matching frequency of initiator.
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";
import Iter  "mo:base/Iter";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let GOLDEN_RATIO : Float = 1.618033988749;
  let PI : Float = 3.14159265358979;
  
  // Wolf pack constants
  let MAX_PACK_SIZE : Nat = 15;
  let OPTIMAL_PACK_SIZE : Nat = 7;
  let TERRITORY_RADIUS : Float = 50.0;      // km equivalent
  let HOWL_RANGE : Float = 15.0;            // km
  let PURSUIT_MAX_DURATION : Nat = 300;     // beats
  let STAMINA_RECOVERY_RATE : Float = 0.01;
  let EXHAUSTION_THRESHOLD : Float = 0.3;

  // ==========================================================================
  // WOLF TYPES
  // ==========================================================================
  
  public type WolfRole = {
    #AlphaMale;
    #AlphaFemale;
    #Beta;
    #Hunter;
    #Scout;
    #Omega;
    #Pup;
  };

  public type WolfState = {
    #Resting;
    #Patrolling;
    #Hunting;
    #Pursuing;
    #Flanking;
    #Attacking;
    #Howling;
    #Defending;
    #Teaching;
    #Playing;
  };

  public type Wolf = {
    wolfId              : Nat;
    role                : WolfRole;
    state               : WolfState;
    
    // Position (spherical around pack center)
    position            : SphericalPosition;
    velocity            : Vector3D;
    
    // Physical state
    stamina             : Float;          // 0.0-1.0
    hunger              : Float;          // 0.0-1.0
    health              : Float;          // 0.0-1.0
    age                 : Nat;            // In beats
    
    // Social state
    dominance           : Float;          // 0.0-1.0 rank indicator
    trustInAlpha        : Float;          // 0.0-1.0
    packLoyalty         : Float;          // 0.0-1.0
    
    // Experience
    huntingExperience   : Float;          // Accumulated skill
    territoryKnowledge  : Float;          // Familiarity with territory
    
    // Communication
    lastHowlTime        : Nat;
    howlFrequency       : Float;          // Individual voice signature
    
    // Pursuit state
    targetDirection     : ?Float;         // Angle to assigned position
    assignedFlankAngle  : Float;
  };

  public type SphericalPosition = {
    r     : Float;    // Distance from pack center
    theta : Float;    // Polar angle
    phi   : Float;    // Azimuthal angle
  };

  public type Vector3D = {
    x : Float;
    y : Float;
    z : Float;
  };

  // ==========================================================================
  // PREY TYPES
  // ==========================================================================
  
  public type PreyType = {
    #Elk;
    #Deer;
    #Moose;
    #Caribou;
    #Bison;
  };

  public type Prey = {
    preyId              : Nat;
    preyType            : PreyType;
    position            : Vector3D;
    velocity            : Vector3D;
    stamina             : Float;
    health              : Float;
    flightSpeed         : Float;
    awareness           : Float;          // How alert
  };

  // ==========================================================================
  // PACK STRUCTURE
  // ==========================================================================
  
  public type WolfPack = {
    packId              : Nat;
    wolves              : [Wolf];
    alphaMale           : ?Nat;           // Wolf ID
    alphaFemale         : ?Nat;           // Wolf ID
    
    // Territory
    territoryCenter     : Vector3D;
    territoryRadius     : Float;
    markedBoundaries    : [Vector3D];
    
    // Pack state
    currentActivity     : PackActivity;
    huntTarget          : ?Prey;
    pursuitDuration     : Nat;
    
    // Communication
    lastPackHowl        : Nat;
    howlSynchronization : Float;
    
    // Metrics
    successfulHunts     : Nat;
    failedHunts         : Nat;
    totalMeatShared     : Float;
    
    beatNum             : Nat;
  };

  public type PackActivity = {
    #Resting;
    #Patrolling;
    #Hunting;
    #Defending;
    #Traveling;
    #Denning;
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initWolf(id: Nat, role: WolfRole) : Wolf {
    let dominance = switch(role) {
      case (#AlphaMale) { 1.0 };
      case (#AlphaFemale) { 0.95 };
      case (#Beta) { 0.7 };
      case (#Hunter) { 0.5 };
      case (#Scout) { 0.4 };
      case (#Omega) { 0.1 };
      case (#Pup) { 0.05 };
    };
    
    {
      wolfId = id;
      role = role;
      state = #Resting;
      position = { r = 5.0; theta = PI / 2.0; phi = Float.fromInt(id) * 0.5 };
      velocity = { x = 0.0; y = 0.0; z = 0.0 };
      stamina = 1.0;
      hunger = 0.3;
      health = 1.0;
      age = 0;
      dominance = dominance;
      trustInAlpha = 0.8;
      packLoyalty = 0.9;
      huntingExperience = 0.3;
      territoryKnowledge = 0.5;
      lastHowlTime = 0;
      howlFrequency = 150.0 + Float.fromInt(id % 50);  // Hz variation
      targetDirection = null;
      assignedFlankAngle = 0.0;
    }
  };

  public func initPack(packId: Nat, numWolves: Nat) : WolfPack {
    let actualSize = if (numWolves > MAX_PACK_SIZE) { MAX_PACK_SIZE } else { numWolves };
    
    let wolves = Array.tabulate<Wolf>(actualSize, func(i: Nat) : Wolf {
      let role = if (i == 0) { #AlphaMale }
                 else if (i == 1) { #AlphaFemale }
                 else if (i == 2) { #Beta }
                 else if (i < actualSize - 1) { #Hunter }
                 else { #Omega };
      initWolf(i, role)
    });
    
    {
      packId = packId;
      wolves = wolves;
      alphaMale = ?0;
      alphaFemale = if (actualSize > 1) { ?1 } else { null };
      territoryCenter = { x = 0.0; y = 0.0; z = 0.0 };
      territoryRadius = TERRITORY_RADIUS;
      markedBoundaries = [];
      currentActivity = #Resting;
      huntTarget = null;
      pursuitDuration = 0;
      lastPackHowl = 0;
      howlSynchronization = 0.5;
      successfulHunts = 0;
      failedHunts = 0;
      totalMeatShared = 0.0;
      beatNum = 0;
    }
  };

  // ==========================================================================
  // PURSUIT HUNTING DYNAMICS
  // ==========================================================================
  
  // Calculate optimal flanking positions (spherical formation around prey)
  public func calculateFlankingPositions(pack: WolfPack, prey: Prey) : [Float] {
    let numHunters = Array.filter<Wolf>(pack.wolves, func(w) { 
      switch(w.state) {
        case (#Hunting) { true };
        case (#Pursuing) { true };
        case (#Flanking) { true };
        case (_) { false };
      }
    }).size();
    
    if (numHunters == 0) { return [] };
    
    // Distribute angles evenly with small noise
    Array.tabulate<Float>(numHunters, func(i: Nat) : Float {
      let baseAngle = 2.0 * PI * Float.fromInt(i) / Float.fromInt(numHunters);
      let noise = Float.sin(Float.fromInt(i * 7)) * 0.1;  // Pseudo-random noise
      baseAngle + noise
    })
  };

  // Calculate wolf velocity during pursuit
  public func pursuitVelocity(wolf: Wolf, prey: Prey, flankAngle: Float) : Vector3D {
    // Target position is on circle around prey at flank angle
    let targetDistance = 10.0;  // Meters from prey
    let targetX = prey.position.x + targetDistance * Float.cos(flankAngle);
    let targetY = prey.position.y + targetDistance * Float.sin(flankAngle);
    
    // Convert wolf spherical to cartesian
    let wolfX = wolf.position.r * Float.sin(wolf.position.theta) * Float.cos(wolf.position.phi);
    let wolfY = wolf.position.r * Float.sin(wolf.position.theta) * Float.sin(wolf.position.phi);
    
    // Direction to target
    let dx = targetX - wolfX;
    let dy = targetY - wolfY;
    let dist = Float.sqrt(dx*dx + dy*dy);
    
    if (dist < 0.1) {
      { x = 0.0; y = 0.0; z = 0.0 }
    } else {
      // Speed based on stamina and prey exhaustion
      let baseSpeed = 15.0;  // m/s
      let staminaFactor = wolf.stamina;
      let closingFactor = 1.0 / (1.0 + Float.exp(-5.0 * (EXHAUSTION_THRESHOLD - prey.stamina)));
      let speed = baseSpeed * staminaFactor * (1.0 + closingFactor);
      
      {
        x = speed * dx / dist;
        y = speed * dy / dist;
        z = 0.0;
      }
    }
  };

  // Decide whether to attack (based on position and pack coordination)
  public func shouldAttack(wolf: Wolf, prey: Prey, packCoordination: Float) : Bool {
    // Convert positions
    let wolfX = wolf.position.r * Float.sin(wolf.position.theta) * Float.cos(wolf.position.phi);
    let wolfY = wolf.position.r * Float.sin(wolf.position.theta) * Float.sin(wolf.position.phi);
    
    let dx = prey.position.x - wolfX;
    let dy = prey.position.y - wolfY;
    let distance = Float.sqrt(dx*dx + dy*dy);
    
    // Attack if close enough, prey exhausted, and pack coordinated
    distance < 5.0 and 
    prey.stamina < EXHAUSTION_THRESHOLD and 
    packCoordination > 0.7 and
    wolf.stamina > 0.3
  };

  // ==========================================================================
  // HOWL COMMUNICATION
  // ==========================================================================
  
  public type Howl = {
    initiatorId         : Nat;
    frequency           : Float;
    startTime           : Nat;
    duration            : Nat;
    message             : HowlMessage;
  };

  public type HowlMessage = {
    #AssemblyCall;      // Gather the pack
    #TerritoryMark;     // This is our land
    #HuntInitiate;      // Prey spotted
    #Distress;          // Need help
    #Reunion;           // Greeting after separation
    #Mourning;          // Loss of pack member
  };

  // Calculate howl response probability
  public func howlResponseProbability(
    wolf: Wolf,
    howl: Howl,
    distance: Float,
    currentBeat: Nat
  ) : Float {
    // Base probability depends on message type
    let baseProbability = switch(howl.message) {
      case (#AssemblyCall) { 0.9 };
      case (#TerritoryMark) { 0.7 };
      case (#HuntInitiate) { 0.8 };
      case (#Distress) { 0.95 };
      case (#Reunion) { 0.85 };
      case (#Mourning) { 0.6 };
    };
    
    // Distance attenuation
    let distanceFactor = if (distance > HOWL_RANGE) { 0.0 }
                         else { 1.0 - distance / HOWL_RANGE };
    
    // Frequency matching (wolves prefer to match)
    let freqDiff = Float.abs(wolf.howlFrequency - howl.frequency);
    let freqMatch = Float.exp(-freqDiff / 50.0);
    
    // Recent howl cooldown
    let timeSinceLastHowl = currentBeat - wolf.lastHowlTime;
    let cooldownFactor = if (timeSinceLastHowl < 10) { 0.3 } else { 1.0 };
    
    baseProbability * distanceFactor * freqMatch * cooldownFactor * wolf.packLoyalty
  };

  // Calculate howl delay (based on distance)
  public func howlDelay(distance: Float) : Nat {
    // Sound travels at ~343 m/s, but wolves wait longer for dramatic effect
    let baseDelay = distance / 343.0 * 1000.0;  // ms
    let dramaticFactor = 2.0;  // Wolves wait
    Int.abs(Float.toInt(baseDelay * dramaticFactor / 100.0))  // Convert to beats
  };

  // Initiate pack howl
  public func initiatePackHowl(pack: WolfPack, initiatorId: Nat, message: HowlMessage) : (WolfPack, Howl) {
    let initiator = pack.wolves[initiatorId % pack.wolves.size()];
    
    let howl : Howl = {
      initiatorId = initiatorId;
      frequency = initiator.howlFrequency;
      startTime = pack.beatNum;
      duration = 30;  // Beats
      message = message;
    };
    
    // Update initiator state
    let updatedWolves = Array.tabulate<Wolf>(pack.wolves.size(), func(i: Nat) : Wolf {
      if (i == initiatorId) {
        { pack.wolves[i] with state = #Howling; lastHowlTime = pack.beatNum }
      } else {
        pack.wolves[i]
      }
    });
    
    ({ pack with wolves = updatedWolves; lastPackHowl = pack.beatNum }, howl)
  };

  // ==========================================================================
  // ALPHA LEADERSHIP
  // ==========================================================================
  
  // Calculate alpha's influence on pack decision
  public func alphaInfluence(pack: WolfPack) : Float {
    switch(pack.alphaMale) {
      case (?alphaId) {
        if (alphaId >= pack.wolves.size()) { return 0.5 };
        
        let alpha = pack.wolves[alphaId];
        
        // Sum trust from all pack members
        var totalTrust : Float = 0.0;
        var totalWeight : Float = 0.0;
        
        for (wolf in pack.wolves.vals()) {
          if (wolf.wolfId != alphaId) {
            // Proximity factor (closer wolves have more influence)
            let proximity = 1.0 / (1.0 + wolf.position.r / 10.0);
            totalTrust += wolf.trustInAlpha * proximity;
            totalWeight += proximity;
          };
        };
        
        let avgTrust = if (totalWeight > 0.0) { totalTrust / totalWeight } else { 0.5 };
        
        // Experience ratio
        let expRatio = alpha.huntingExperience / 
                       (alpha.huntingExperience + 0.5);
        
        avgTrust * expRatio
      };
      case null { 0.3 };  // Leaderless pack has low coordination
    }
  };

  // Alpha makes hunt decision
  public func alphaDecision(pack: WolfPack, preySpotted: ?Prey) : PackActivity {
    let influence = alphaInfluence(pack);
    
    switch(preySpotted) {
      case (?prey) {
        // Evaluate hunt viability
        let packStamina = averagePackStamina(pack);
        let preyDifficulty = preyDifficultyRating(prey);
        
        let huntViability = packStamina / preyDifficulty * influence;
        
        if (huntViability > 0.6) {
          #Hunting
        } else {
          #Patrolling  // Wait for better opportunity
        }
      };
      case null {
        // No prey - default behavior
        if (averagePackHunger(pack) > 0.6) {
          #Patrolling  // Search for prey
        } else {
          #Resting
        }
      };
    }
  };

  func preyDifficultyRating(prey: Prey) : Float {
    switch(prey.preyType) {
      case (#Elk) { 0.6 };
      case (#Deer) { 0.4 };
      case (#Moose) { 0.9 };
      case (#Caribou) { 0.5 };
      case (#Bison) { 1.0 };
    }
  };

  func averagePackStamina(pack: WolfPack) : Float {
    if (pack.wolves.size() == 0) { return 0.0 };
    var total : Float = 0.0;
    for (wolf in pack.wolves.vals()) {
      total += wolf.stamina;
    };
    total / Float.fromInt(pack.wolves.size())
  };

  func averagePackHunger(pack: WolfPack) : Float {
    if (pack.wolves.size() == 0) { return 0.0 };
    var total : Float = 0.0;
    for (wolf in pack.wolves.vals()) {
      total += wolf.hunger;
    };
    total / Float.fromInt(pack.wolves.size())
  };

  // ==========================================================================
  // TERRITORY MANAGEMENT
  // ==========================================================================
  
  public type TerritoryMark = {
    position            : Vector3D;
    markTime            : Nat;
    markerId            : Nat;
    strength            : Float;          // Scent strength
  };

  // Check if position is in territory
  public func inTerritory(pack: WolfPack, position: Vector3D) : Bool {
    let dx = position.x - pack.territoryCenter.x;
    let dy = position.y - pack.territoryCenter.y;
    let dz = position.z - pack.territoryCenter.z;
    let distance = Float.sqrt(dx*dx + dy*dy + dz*dz);
    distance <= pack.territoryRadius
  };

  // Calculate scent strength at position (from all marks)
  public func scentStrengthAt(marks: [TerritoryMark], position: Vector3D, currentBeat: Nat) : Float {
    var totalScent : Float = 0.0;
    
    for (mark in marks.vals()) {
      let dx = position.x - mark.position.x;
      let dy = position.y - mark.position.y;
      let dz = position.z - mark.position.z;
      let distance = Float.sqrt(dx*dx + dy*dy + dz*dz);
      
      // Scent decays with distance and time
      let distanceDecay = Float.exp(-distance / 5.0);
      let timeDecay = Float.exp(-Float.fromInt(currentBeat - mark.markTime) / 1000.0);
      
      totalScent += mark.strength * distanceDecay * timeDecay;
    };
    
    totalScent
  };

  // ==========================================================================
  // MAIN TICK
  // ==========================================================================
  
  public func tickPack(pack: WolfPack, prey: ?Prey, dt: Float) : WolfPack {
    // Update each wolf
    let updatedWolves = Array.tabulate<Wolf>(pack.wolves.size(), func(i: Nat) : Wolf {
      var wolf = pack.wolves[i];
      
      // Stamina recovery when resting
      switch(wolf.state) {
        case (#Resting) {
          wolf := { wolf with stamina = Float.min(1.0, wolf.stamina + STAMINA_RECOVERY_RATE) };
        };
        case (#Pursuing) {
          wolf := { wolf with stamina = Float.max(0.0, wolf.stamina - 0.005) };
        };
        case (#Attacking) {
          wolf := { wolf with stamina = Float.max(0.0, wolf.stamina - 0.02) };
        };
        case (_) {};
      };
      
      // Hunger increases over time
      wolf := { wolf with hunger = Float.min(1.0, wolf.hunger + 0.001) };
      
      // Age
      wolf := { wolf with age = wolf.age + 1 };
      
      wolf
    });
    
    // Update pursuit duration
    let newPursuitDuration = switch(pack.huntTarget) {
      case (?_) { pack.pursuitDuration + 1 };
      case null { 0 };
    };
    
    // Calculate pack coordination
    let coordination = alphaInfluence(pack);
    
    // Update howl synchronization
    let timeSinceHowl = pack.beatNum - pack.lastPackHowl;
    let newSync = if (timeSinceHowl < 50) {
      Float.min(1.0, pack.howlSynchronization + 0.02)
    } else {
      Float.max(0.0, pack.howlSynchronization - 0.001)
    };
    
    {
      pack with
      wolves = updatedWolves;
      pursuitDuration = newPursuitDuration;
      howlSynchronization = newSync;
      beatNum = pack.beatNum + 1;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getPackMetrics(pack: WolfPack) : {
    packSize: Nat;
    avgStamina: Float;
    avgHunger: Float;
    successRate: Float;
    alphaInfluence: Float;
    howlSync: Float;
    beatNum: Nat;
  } {
    let successRate = if (pack.successfulHunts + pack.failedHunts > 0) {
      Float.fromInt(pack.successfulHunts) / 
      Float.fromInt(pack.successfulHunts + pack.failedHunts)
    } else { 0.0 };
    
    {
      packSize = pack.wolves.size();
      avgStamina = averagePackStamina(pack);
      avgHunger = averagePackHunger(pack);
      successRate = successRate;
      alphaInfluence = alphaInfluence(pack);
      howlSync = pack.howlSynchronization;
      beatNum = pack.beatNum;
    }
  };

  public func getWolfRoleDistribution(pack: WolfPack) : [(WolfRole, Nat)] {
    var alpha : Nat = 0;
    var beta : Nat = 0;
    var hunter : Nat = 0;
    var scout : Nat = 0;
    var omega : Nat = 0;
    var pup : Nat = 0;
    
    for (wolf in pack.wolves.vals()) {
      switch(wolf.role) {
        case (#AlphaMale) { alpha += 1 };
        case (#AlphaFemale) { alpha += 1 };
        case (#Beta) { beta += 1 };
        case (#Hunter) { hunter += 1 };
        case (#Scout) { scout += 1 };
        case (#Omega) { omega += 1 };
        case (#Pup) { pup += 1 };
      };
    };
    
    [
      (#AlphaMale, alpha),
      (#Beta, beta),
      (#Hunter, hunter),
      (#Scout, scout),
      (#Omega, omega),
      (#Pup, pup)
    ]
  };

}
