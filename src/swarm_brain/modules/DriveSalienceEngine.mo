// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: DriveSalienceEngine — Bach Drive Competition System
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    DRIVE SALIENCE ENGINE — BACH UPGRADE                  ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  Based on Joscha Bach's Cognitive Architecture theory.                   ║
// ║  From MicroPsi and his work on drives, attention, and behavior.          ║
// ║                                                                          ║
// ║  CORE INSIGHT:                                                           ║
// ║    The organism is never told what to do. It FEELS what to do.           ║
// ║    Drives compete for control. The most SALIENT drive wins.              ║
// ║    Behavior emerges from drive competition, not scripting.               ║
// ║                                                                          ║
// ║  THE 5 CORE DRIVES (G/A/V/S/R):                                          ║
// ║    G — GAIA: Healing, restoration, harmony                               ║
// ║    A — ARES: Combat, defense, aggression                                 ║
// ║    V — VULCAN: Building, creation, construction                          ║
// ║    S — SATURN: Order, governance, structure                              ║
// ║    R — RESONEX: Connection, synchronization, communion                   ║
// ║                                                                          ║
// ║  SALIENCE FORMULA:                                                       ║
// ║    salience(drive) = intensity × recency × relevance                     ║
// ║                                                                          ║
// ║  BEHAVIOR SELECTION:                                                     ║
// ║    winning_drive = argmax(salience across G,A,V,S,R)                     ║
// ║    this_beat_behavior = winning_drive's behavior module                  ║
// ║                                                                          ║
// ║  NO SCRIPTING. The winning drive determines what happens.                ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let SOVEREIGN_FLOOR : Float = 1.0;
  
  // Salience decay rate (per beat)
  public let RECENCY_DECAY : Float = 0.95;        // 5% decay per beat
  public let INTENSITY_DECAY : Float = 0.98;      // 2% decay per beat
  
  // Drive activation thresholds
  public let ACTIVATION_THRESHOLD : Float = 0.3;  // Below this, drive is dormant
  public let DOMINANCE_THRESHOLD : Float = 0.7;   // Above this, drive dominates

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DRIVE TYPES                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DriveType = {
    #Gaia;        // G — Healing, restoration, harmony
    #Ares;        // A — Combat, defense, aggression
    #Vulcan;      // V — Building, creation, construction
    #Saturn;      // S — Order, governance, structure
    #Resonex;     // R — Connection, synchronization, communion
  };
  
  /// Get drive index (for array access)
  public func driveIndex(drive: DriveType) : Nat {
    switch (drive) {
      case (#Gaia) { 0 };
      case (#Ares) { 1 };
      case (#Vulcan) { 2 };
      case (#Saturn) { 3 };
      case (#Resonex) { 4 };
    }
  };
  
  /// Get drive from index
  public func driveFromIndex(index: Nat) : DriveType {
    switch (index) {
      case (0) { #Gaia };
      case (1) { #Ares };
      case (2) { #Vulcan };
      case (3) { #Saturn };
      case (4) { #Resonex };
      case (_) { #Gaia };  // Default
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DRIVE STATE                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DriveState = {
    driveType : DriveType;
    
    // Core metrics (all [0, ∞) with sovereign floor at 1.0)
    intensity : Float;          // How strong is the urge
    recency : Float;            // How recently was it activated [0, 1]
    relevance : Float;          // How relevant to current context [0, 1]
    
    // Computed
    salience : Float;           // intensity × recency × relevance
    
    // History
    lastActivation : Nat;       // Beat of last activation
    activationCount : Nat;      // Total activations
    totalSatisfaction : Float;  // Cumulative satisfaction gained
    
    // Behavior outcomes
    successRate : Float;        // [0, 1] how often drive achieves goals
    averageIntensity : Float;   // Running average intensity
  };
  
  /// Calculate salience for a drive
  public func calculateSalience(drive: DriveState) : Float {
    // Salience = intensity × recency × relevance
    // This determines which drive wins
    drive.intensity * drive.recency * drive.relevance
  };
  
  /// Update salience in drive state
  public func updateSalience(drive: DriveState) : DriveState {
    {
      driveType = drive.driveType;
      intensity = drive.intensity;
      recency = drive.recency;
      relevance = drive.relevance;
      salience = calculateSalience(drive);
      lastActivation = drive.lastActivation;
      activationCount = drive.activationCount;
      totalSatisfaction = drive.totalSatisfaction;
      successRate = drive.successRate;
      averageIntensity = drive.averageIntensity;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DRIVE SYSTEM (All 5 drives)                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DriveSystem = {
    drives : [DriveState];        // [G, A, V, S, R]
    
    // Current winner
    winningDrive : DriveType;
    winningIndex : Nat;
    dominanceStrength : Float;    // How dominant is the winner
    
    // Competition state
    lastCompetition : Nat;        // Beat of last competition
    competitionHistory : [DriveType];  // Last 13 winners
    
    // Drive balance
    driveEntropy : Float;         // High = balanced, Low = one-dominant
  };
  
  /// Run drive competition — returns winning drive
  public func compete(system: DriveSystem) : (DriveType, Float) {
    var maxSalience : Float = 0.0;
    var winnerIndex : Nat = 0;
    var totalSalience : Float = 0.0;
    
    var i = 0;
    while (i < system.drives.size()) {
      let salience = system.drives[i].salience;
      totalSalience += salience;
      
      if (salience > maxSalience) {
        maxSalience := salience;
        winnerIndex := i;
      };
      i += 1;
    };
    
    // Dominance = winner's share of total salience
    let dominance = if (totalSalience > 0.001) {
      maxSalience / totalSalience
    } else {
      0.2  // Equal split
    };
    
    (driveFromIndex(winnerIndex), dominance)
  };
  
  /// Calculate drive entropy (measure of balance)
  public func driveEntropy(system: DriveSystem) : Float {
    // Shannon entropy: H = -Σ p × log(p)
    // where p = salience / total_salience
    
    var totalSalience : Float = 0.0;
    for (drive in system.drives.vals()) {
      totalSalience += drive.salience;
    };
    
    if (totalSalience < 0.001) { return 1.0 };  // Max entropy if nothing
    
    var entropy : Float = 0.0;
    for (drive in system.drives.vals()) {
      let p = drive.salience / totalSalience;
      if (p > 0.001) {
        entropy -= p * Float.log(p);
      };
    };
    
    // Normalize to [0, 1] where log(5) ≈ 1.609 is max entropy for 5 drives
    _clamp(entropy / 1.609, 0.0, 1.0)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DRIVE ACTIVATION                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Activate a drive (increase intensity)
  public func activateDrive(
    drive: DriveState,
    amount: Float,
    currentBeat: Nat
  ) : DriveState {
    let newIntensity = Float.max(SOVEREIGN_FLOOR, drive.intensity + amount);
    let newAvg = drive.averageIntensity * 0.95 + newIntensity * 0.05;
    
    {
      driveType = drive.driveType;
      intensity = newIntensity;
      recency = 1.0;  // Just activated = full recency
      relevance = drive.relevance;
      salience = newIntensity * 1.0 * drive.relevance;
      lastActivation = currentBeat;
      activationCount = drive.activationCount + 1;
      totalSatisfaction = drive.totalSatisfaction;
      successRate = drive.successRate;
      averageIntensity = newAvg;
    }
  };
  
  /// Satisfy a drive (reduce intensity, increase satisfaction)
  public func satisfyDrive(
    drive: DriveState,
    satisfaction: Float,
    currentBeat: Nat
  ) : DriveState {
    // Satisfaction reduces intensity toward floor
    let reduction = satisfaction * (drive.intensity - SOVEREIGN_FLOOR);
    let newIntensity = Float.max(SOVEREIGN_FLOOR, drive.intensity - reduction);
    
    // Track success
    let newSuccess = drive.successRate * 0.9 + 0.1;  // Success increases rate
    
    {
      driveType = drive.driveType;
      intensity = newIntensity;
      recency = drive.recency;
      relevance = drive.relevance;
      salience = calculateSalience({ 
        driveType = drive.driveType;
        intensity = newIntensity;
        recency = drive.recency;
        relevance = drive.relevance;
        salience = 0.0;
        lastActivation = drive.lastActivation;
        activationCount = drive.activationCount;
        totalSatisfaction = drive.totalSatisfaction;
        successRate = drive.successRate;
        averageIntensity = drive.averageIntensity;
      });
      lastActivation = drive.lastActivation;
      activationCount = drive.activationCount;
      totalSatisfaction = drive.totalSatisfaction + satisfaction;
      successRate = newSuccess;
      averageIntensity = drive.averageIntensity;
    }
  };
  
  /// Decay drives over time
  public func decayDrive(drive: DriveState, beatsSinceActivation: Nat) : DriveState {
    // Recency decays exponentially
    let beatsFloat = Float.fromInt(beatsSinceActivation);
    let newRecency = _clamp(Float.pow(RECENCY_DECAY, beatsFloat), 0.0, 1.0);
    
    // Intensity decays slowly
    let newIntensity = Float.max(
      SOVEREIGN_FLOOR,
      SOVEREIGN_FLOOR + (drive.intensity - SOVEREIGN_FLOOR) * Float.pow(INTENSITY_DECAY, beatsFloat)
    );
    
    // Failure also decays
    let newSuccess = drive.successRate * 0.995;
    
    {
      driveType = drive.driveType;
      intensity = newIntensity;
      recency = newRecency;
      relevance = drive.relevance;
      salience = newIntensity * newRecency * drive.relevance;
      lastActivation = drive.lastActivation;
      activationCount = drive.activationCount;
      totalSatisfaction = drive.totalSatisfaction;
      successRate = newSuccess;
      averageIntensity = drive.averageIntensity;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RELEVANCE CALCULATION                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Relevance depends on context. What's relevant for a drive?
  //
  //   GAIA: High when damage exists, coherence is low
  //   ARES: High when threats exist, territory contested
  //   VULCAN: High when resources available, territory secure
  //   SATURN: High when laws violated, governance weak
  //   RESONEX: High when coherence dropping, isolation detected
  //
  
  public type ContextSignals = {
    damageLevel : Float;        // [0, 1] how damaged is territory
    threatLevel : Float;        // [0, 1] how threatened
    resourceAvailable : Float;  // [0, 1] resources for building
    lawViolations : Float;      // [0, 1] governance issues
    coherenceLevel : Float;     // [0, 1] swarm synchronization
    territorySecure : Float;    // [0, 1] territory control
    isolationLevel : Float;     // [0, 1] disconnection from swarm
  };
  
  /// Calculate relevance for each drive based on context
  public func calculateRelevance(drive: DriveType, context: ContextSignals) : Float {
    switch (drive) {
      case (#Gaia) {
        // GAIA relevant when damage exists or coherence is low
        let damageRelevance = context.damageLevel;
        let coherenceRelevance = 1.0 - context.coherenceLevel;
        (damageRelevance + coherenceRelevance) / 2.0
      };
      case (#Ares) {
        // ARES relevant when threats exist or territory contested
        let threatRelevance = context.threatLevel;
        let contestRelevance = 1.0 - context.territorySecure;
        (threatRelevance + contestRelevance) / 2.0
      };
      case (#Vulcan) {
        // VULCAN relevant when resources available and territory secure
        let resourceRelevance = context.resourceAvailable;
        let securityRelevance = context.territorySecure;
        resourceRelevance * securityRelevance
      };
      case (#Saturn) {
        // SATURN relevant when governance issues exist
        let lawRelevance = context.lawViolations;
        let orderNeed = 1.0 - context.coherenceLevel * 0.5;
        (lawRelevance + orderNeed) / 2.0
      };
      case (#Resonex) {
        // RESONEX relevant when coherence dropping or isolation
        let coherenceDrop = 1.0 - context.coherenceLevel;
        let isolationRelevance = context.isolationLevel;
        (coherenceDrop + isolationRelevance) / 2.0
      };
    }
  };
  
  /// Update all drives with current context
  public func updateDrivesWithContext(
    system: DriveSystem,
    context: ContextSignals,
    currentBeat: Nat
  ) : DriveSystem {
    let newDrives = Buffer.Buffer<DriveState>(5);
    
    var i = 0;
    while (i < system.drives.size()) {
      let drive = system.drives[i];
      let driveType = driveFromIndex(i);
      
      // Calculate new relevance
      let newRelevance = calculateRelevance(driveType, context);
      
      // Decay based on time since activation
      let beatsSince = if (currentBeat > drive.lastActivation) {
        currentBeat - drive.lastActivation
      } else { 0 };
      
      let decayed = decayDrive(drive, beatsSince);
      
      // Update with new relevance
      let updated : DriveState = {
        driveType = decayed.driveType;
        intensity = decayed.intensity;
        recency = decayed.recency;
        relevance = newRelevance;
        salience = decayed.intensity * decayed.recency * newRelevance;
        lastActivation = decayed.lastActivation;
        activationCount = decayed.activationCount;
        totalSatisfaction = decayed.totalSatisfaction;
        successRate = decayed.successRate;
        averageIntensity = decayed.averageIntensity;
      };
      
      newDrives.add(updated);
      i += 1;
    };
    
    let drives = Buffer.toArray(newDrives);
    
    // Run competition
    let tempSystem : DriveSystem = {
      drives = drives;
      winningDrive = system.winningDrive;
      winningIndex = system.winningIndex;
      dominanceStrength = system.dominanceStrength;
      lastCompetition = currentBeat;
      competitionHistory = system.competitionHistory;
      driveEntropy = 0.0;
    };
    
    let (winner, dominance) = compete(tempSystem);
    let entropy = driveEntropy(tempSystem);
    
    // Update history
    let newHistory = Buffer.Buffer<DriveType>(13);
    newHistory.add(winner);
    for (prev in system.competitionHistory.vals()) {
      if (newHistory.size() < 13) {
        newHistory.add(prev);
      };
    };
    
    {
      drives = drives;
      winningDrive = winner;
      winningIndex = driveIndex(winner);
      dominanceStrength = dominance;
      lastCompetition = currentBeat;
      competitionHistory = Buffer.toArray(newHistory);
      driveEntropy = entropy;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BEHAVIOR DETERMINATION                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BehaviorType = {
    #Heal;          // GAIA: Restore, repair, harmonize
    #Fight;         // ARES: Attack, defend, destroy
    #Build;         // VULCAN: Construct, create, expand
    #Govern;        // SATURN: Enforce, structure, organize
    #Connect;       // RESONEX: Synchronize, communicate, bond
    #Idle;          // No dominant drive
  };
  
  /// Get behavior for winning drive
  public func getBehavior(system: DriveSystem) : BehaviorType {
    if (system.dominanceStrength < ACTIVATION_THRESHOLD) {
      return #Idle;  // No clear winner
    };
    
    switch (system.winningDrive) {
      case (#Gaia) { #Heal };
      case (#Ares) { #Fight };
      case (#Vulcan) { #Build };
      case (#Saturn) { #Govern };
      case (#Resonex) { #Connect };
    }
  };
  
  /// Get behavior intensity (how strongly to execute)
  public func getBehaviorIntensity(system: DriveSystem) : Float {
    let winner = system.drives[system.winningIndex];
    winner.salience * system.dominanceStrength
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initDriveState(driveType: DriveType) : DriveState {
    {
      driveType = driveType;
      intensity = SOVEREIGN_FLOOR;
      recency = 0.5;
      relevance = 0.5;
      salience = SOVEREIGN_FLOOR * 0.5 * 0.5;
      lastActivation = 0;
      activationCount = 0;
      totalSatisfaction = 0.0;
      successRate = 0.5;
      averageIntensity = SOVEREIGN_FLOOR;
    }
  };
  
  public func initDriveSystem() : DriveSystem {
    {
      drives = [
        initDriveState(#Gaia),
        initDriveState(#Ares),
        initDriveState(#Vulcan),
        initDriveState(#Saturn),
        initDriveState(#Resonex)
      ];
      winningDrive = #Resonex;  // Default: connection
      winningIndex = 4;
      dominanceStrength = 0.2;
      lastCompetition = 0;
      competitionHistory = [];
      driveEntropy = 1.0;  // Balanced
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUMMARY                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DriveSummary = {
    winningDrive : DriveType;
    behavior : BehaviorType;
    dominance : Float;
    entropy : Float;
    driveSaliences : [Float];  // [G, A, V, S, R]
  };
  
  public func summarize(system: DriveSystem) : DriveSummary {
    let saliences = Array.tabulate<Float>(5, func(i) {
      if (i < system.drives.size()) { system.drives[i].salience } else { 0.0 }
    });
    
    {
      winningDrive = system.winningDrive;
      behavior = getBehavior(system);
      dominance = system.dominanceStrength;
      entropy = system.driveEntropy;
      driveSaliences = saliences;
    }
  };

}
