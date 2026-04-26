// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: WarfareDoctrine — Military Strategy & Game Theory Engine
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    WARFARE DOCTRINE — REAL MILITARY STRATEGY             ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This module implements REAL military doctrine, not game mechanics.      ║
// ║                                                                          ║
// ║  SOURCES:                                                                ║
// ║    - Sun Tzu's Art of War (deception, terrain, timing)                  ║
// ║    - Clausewitz (friction, fog of war, center of gravity)               ║
// ║    - Boyd's OODA Loop (Observe-Orient-Decide-Act)                       ║
// ║    - Modern Drone Swarm Tactics (US DoD, NATO doctrine)                 ║
// ║    - Game Theory (Nash equilibrium, evolutionary strategies)            ║
// ║                                                                          ║
// ║  THE ORGANISM LEARNS WAR BY UNDERSTANDING WAR.                           ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let phi : Float = 1.6180339887498948482;
  public let psi : Float = 0.6180339887498948482;
  public let pi : Float = 3.1415926535897932385;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUN TZU — THE ART OF WAR                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // "All warfare is based on deception."
  // "Know yourself and know your enemy, and you will never be defeated."
  // "The supreme art of war is to subdue the enemy without fighting."
  //
  
  /// The Five Factors (Sun Tzu's strategic assessment)
  public type SunTzuFactors = {
    /// The Way (Tao) - unity between ruler and people
    /// In the organism: coherence between swarm members
    moralInfluence : Float;  // [0, 1] — Kuramoto r drives this
    
    /// Heaven - weather, seasons, timing
    /// In the organism: environmental conditions, cycles
    timing : Float;  // [0, 1]
    
    /// Earth - terrain, distances, danger
    /// In the organism: territory control, resource proximity
    terrain : Float;  // [0, 1]
    
    /// Command - leadership qualities
    /// In the organism: brain coherence, decision quality
    command : Float;  // [0, 1]
    
    /// Doctrine - organization, logistics
    /// In the organism: law compliance, resource efficiency
    doctrine : Float;  // [0, 1]
  };
  
  /// Calculate strategic advantage (Sun Tzu style)
  public func sunTzuAdvantage(factors: SunTzuFactors) : Float {
    // Weighted geometric mean — all factors matter, weakness kills
    let product = factors.moralInfluence * 
                  factors.timing * 
                  factors.terrain * 
                  factors.command * 
                  factors.doctrine;
    
    Float.pow(product, 0.2)  // 5th root = geometric mean of 5 factors
  };
  
  /// The Nine Terrains
  public type TerrainType = {
    #Dispersive;      // Own territory — soldiers may flee home
    #Frontier;        // Shallow enemy territory
    #Key;             // Advantageous ground for both sides
    #Communicating;   // Open ground, easy movement
    #Focal;           // Intersection of multiple powers
    #Serious;         // Deep in enemy territory
    #Difficult;       // Mountains, forests, swamps
    #Hemmed;          // Narrow passes, constrained
    #Desperate;       // Survival only through fighting
  };
  
  /// Terrain modifier for combat
  public func terrainModifier(terrain: TerrainType) : Float {
    switch (terrain) {
      case (#Dispersive) { 0.7 };       // Morale penalty
      case (#Frontier) { 0.9 };         // Slight penalty
      case (#Key) { 1.2 };              // Advantage if held
      case (#Communicating) { 1.0 };    // Neutral
      case (#Focal) { 1.3 };            // Strategic value
      case (#Serious) { 0.8 };          // Committed but strained
      case (#Difficult) { 0.6 };        // Movement penalty
      case (#Hemmed) { 1.1 };           // Defensive bonus
      case (#Desperate) { 1.5 };        // Fight or die bonus
    }
  };
  
  /// Deception Tactics
  public type DeceptionTactic = {
    #Feint;           // Attack in one place, strike another
    #Bait;            // Lure enemy into trap
    #Retreat;         // Fake retreat to draw pursuit
    #Concentration;   // Appear weak when strong
    #Dispersion;      // Appear strong when weak
    #Disinformation;  // Feed false intelligence
  };
  
  /// Deception effectiveness (depends on enemy intelligence)
  public func deceptionSuccess(tactic: DeceptionTactic, enemyIntel: Float) : Float {
    // Higher enemy intelligence = harder to deceive
    let baseDifficulty = switch (tactic) {
      case (#Feint) { 0.6 };
      case (#Bait) { 0.5 };
      case (#Retreat) { 0.4 };
      case (#Concentration) { 0.7 };
      case (#Dispersion) { 0.7 };
      case (#Disinformation) { 0.5 };
    };
    
    // Success = base × (1 - enemyIntel × 0.5)
    baseDifficulty * (1.0 - enemyIntel * 0.5)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CLAUSEWITZ — ON WAR                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // "War is the continuation of politics by other means."
  // "Everything in war is very simple, but the simplest thing is difficult."
  // (Friction — the gap between plans and reality)
  //
  
  /// The Trinity of War
  public type ClausewitzTrinity = {
    /// Passion — the people, violence, hatred
    /// In organism: drive intensity, aggression
    passion : Float;  // [0, 1]
    
    /// Chance — the military, fog of war, friction
    /// In organism: uncertainty, sensor noise, communication delays
    chance : Float;  // [0, 1]
    
    /// Reason — the government, policy, objectives
    /// In organism: brain coherence, goal alignment
    reason : Float;  // [0, 1]
  };
  
  /// Center of Gravity — the source of enemy power
  public type CenterOfGravity = {
    cogType : COGType;
    location : ?(Float, Float);  // Spatial position if applicable
    strength : Float;            // [0, 1] how critical
    vulnerability : Float;       // [0, 1] how attackable
  };
  
  public type COGType = {
    #Leadership;      // Destroy command structure
    #MilitaryForce;   // Destroy main army
    #EconomicBase;    // Destroy resources
    #PublicWill;      // Break morale
    #Alliance;        // Break coalition
    #Infrastructure;  // Destroy logistics
  };
  
  /// Fog of War — information uncertainty
  public type FogOfWar = {
    visibilityRange : Float;       // How far can we see?
    sensorAccuracy : Float;        // How accurate is sensor data?
    communicationDelay : Float;    // Latency in command
    enemyDeception : Float;        // Enemy's deception level
    overallUncertainty : Float;    // Combined uncertainty [0, 1]
  };
  
  /// Calculate fog of war
  public func calculateFog(
    visibility: Float,
    sensorAccuracy: Float,
    commDelay: Float,
    enemyDeception: Float
  ) : FogOfWar {
    // Uncertainty compounds multiplicatively
    let uncertainty = 1.0 - (visibility * sensorAccuracy * (1.0 - commDelay * 0.1) * (1.0 - enemyDeception));
    
    {
      visibilityRange = visibility;
      sensorAccuracy = sensorAccuracy;
      communicationDelay = commDelay;
      enemyDeception = enemyDeception;
      overallUncertainty = _clamp(uncertainty, 0.0, 1.0);
    }
  };
  
  /// Friction — everything that makes simple things difficult
  public func calculateFriction(
    planComplexity: Float,      // More complex = more friction
    executionSkill: Float,      // Higher skill = less friction
    environmentalDifficulty: Float,
    timeStress: Float           // More urgency = more friction
  ) : Float {
    // Friction = complexity × difficulty × stress / skill
    let rawFriction = planComplexity * environmentalDifficulty * (1.0 + timeStress) / (executionSkill + 0.1);
    _clamp(rawFriction, 0.0, 2.0)
  };
  
  /// Culmination Point — when attack runs out of steam
  public func atCulminationPoint(
    distanceAdvanced: Float,
    suppliesRemaining: Float,
    casualtiesPercent: Float,
    enemyResistance: Float
  ) : Bool {
    // Culmination when:
    // - Supplies below critical
    // - Casualties exceed threshold
    // - Distance exceeds sustainable logistics
    
    let supplyFactor = suppliesRemaining < 0.3;
    let casualtyFactor = casualtiesPercent > 0.4;
    let distanceFactor = distanceAdvanced > (suppliesRemaining * 100.0);
    let resistanceFactor = enemyResistance > 0.8;
    
    (supplyFactor and casualtyFactor) or (distanceFactor and resistanceFactor)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BOYD'S OODA LOOP                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Observe → Orient → Decide → Act
  // The side that cycles through OODA faster wins.
  //
  
  public type OODAState = {
    phase : OODAPhase;
    cycleTime : Float;          // Total cycle time (lower = better)
    lastObservation : Nat;      // Beat of last observation
    lastDecision : Nat;         // Beat of last decision
    lastAction : Nat;           // Beat of last action
    
    // Phase-specific data
    observations : [Observation];
    orientation : Orientation;
    currentDecision : ?Decision;
  };
  
  public type OODAPhase = {
    #Observe;
    #Orient;
    #Decide;
    #Act;
  };
  
  public type Observation = {
    source : ObservationSource;
    data : Float;               // Normalized observation value
    confidence : Float;         // How reliable
    timestamp : Nat;
  };
  
  public type ObservationSource = {
    #Visual;
    #Acoustic;
    #Radar;
    #Intelligence;
    #Communication;
  };
  
  public type Orientation = {
    // Cultural traditions (organizational patterns)
    traditions : Float;
    // Previous experience (learning)
    experience : Float;
    // Genetic heritage (inherent capabilities)
    heritage : Float;
    // New information analysis
    analysisQuality : Float;
    // Overall orientation quality
    quality : Float;
  };
  
  public type Decision = {
    decisionType : DecisionType;
    confidence : Float;
    urgency : Float;
    resources : Float;          // Resources committed
  };
  
  public type DecisionType = {
    #Attack;
    #Defend;
    #Withdraw;
    #Reinforce;
    #Feint;
    #Wait;
  };
  
  /// Calculate OODA cycle time
  public func oodaCycleTime(
    observeTime: Float,
    orientTime: Float,
    decideTime: Float,
    actTime: Float
  ) : Float {
    observeTime + orientTime + decideTime + actTime
  };
  
  /// OODA advantage: faster cycle = advantage
  public func oodaAdvantage(ourCycleTime: Float, enemyCycleTime: Float) : Float {
    if (ourCycleTime < 0.001) { return 2.0 };  // Max advantage
    if (enemyCycleTime < 0.001) { return 0.5 }; // Max disadvantage
    
    enemyCycleTime / ourCycleTime
  };
  
  /// Orient phase — synthesize observations with experience
  public func orient(
    observations: [Observation],
    experience: Float,
    traditions: Float,
    heritage: Float
  ) : Orientation {
    // Analysis quality = average observation confidence
    var totalConf : Float = 0.0;
    for (obs in observations.vals()) {
      totalConf += obs.confidence;
    };
    let analysisQuality = if (observations.size() > 0) {
      totalConf / Float.fromInt(observations.size())
    } else { 0.5 };
    
    // Overall orientation quality
    let quality = analysisQuality * 0.4 + experience * 0.3 + traditions * 0.15 + heritage * 0.15;
    
    {
      traditions = traditions;
      experience = experience;
      heritage = heritage;
      analysisQuality = analysisQuality;
      quality = quality;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MODERN DRONE SWARM TACTICS                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Based on US DoD and NATO doctrine for autonomous swarms.
  //
  
  public type SwarmFormation = {
    #Wedge;           // Attack formation, penetration
    #Line;            // Defensive, maximum firepower forward
    #Column;          // Movement, rapid advance
    #Echelon;         // Flanking, oblique attack
    #Diamond;         // All-around defense
    #Vee;             // Envelopment
    #Swarm;           // Dispersed, autonomous hunting
    #Perimeter;       // Area denial
  };
  
  public type SwarmTactic = {
    #Saturation;      // Overwhelm defenses with numbers
    #Decoy;           // Use expendables to draw fire
    #Mesh;            // Networked intelligence sharing
    #Autonomous;      // Independent decision-making
    #Coordinated;     // Synchronized attack
    #Layered;         // Multiple altitude/distance layers
    #Hunter;          // Seek and destroy specific targets
    #ISR;             // Intelligence, surveillance, recon
  };
  
  /// Formation effectiveness vs target type
  public func formationEffectiveness(
    formation: SwarmFormation,
    targetType: TargetType
  ) : Float {
    switch (formation, targetType) {
      case (#Wedge, #Armored) { 1.2 };
      case (#Wedge, #Infantry) { 0.8 };
      case (#Line, #Aerial) { 1.3 };
      case (#Swarm, #Infrastructure) { 1.5 };
      case (#Diamond, #Ambush) { 0.7 };
      case (#Perimeter, #Territory) { 1.4 };
      case (_, _) { 1.0 };  // Default
    }
  };
  
  public type TargetType = {
    #Armored;
    #Infantry;
    #Aerial;
    #Naval;
    #Infrastructure;
    #Command;
    #Logistics;
    #Territory;
    #Ambush;
  };
  
  /// Swarm tactics effectiveness
  public func tacticEffectiveness(
    tactic: SwarmTactic,
    enemyDefenseLevel: Float,
    swarmSize: Nat
  ) : Float {
    let sizeBonus = Float.log(Float.fromInt(swarmSize + 1)) * 0.1;
    
    let baseMult = switch (tactic) {
      case (#Saturation) { 1.5 - enemyDefenseLevel * 0.5 };
      case (#Decoy) { 1.2 };
      case (#Mesh) { 1.0 + sizeBonus };
      case (#Autonomous) { 0.9 + sizeBonus };
      case (#Coordinated) { 1.3 };
      case (#Layered) { 1.2 };
      case (#Hunter) { 1.4 - enemyDefenseLevel * 0.3 };
      case (#ISR) { 0.8 };  // Not combat focused
    };
    
    _clamp(baseMult, 0.5, 2.0)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     GAME THEORY ENGINE                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Nash equilibrium, minimax, evolutionary stable strategies
  //
  
  /// 2x2 Game payoff matrix
  public type GameMatrix = {
    /// Payoffs for (Player1 strategy, Player2 strategy)
    /// Format: [[p1Cooperate_p2Cooperate, p1Cooperate_p2Defect],
    ///          [p1Defect_p2Cooperate, p1Defect_p2Defect]]
    payoffs : [[Float]];
  };
  
  /// Standard game types
  public type GameType = {
    #PrisonersDilemma;    // Individual rationality vs collective good
    #ChickenGame;         // Brinkmanship
    #StagHunt;            // Trust and cooperation
    #BattleOfSexes;       // Coordination
    #MatchingPennies;     // Zero-sum
    #Hawk_Dove;           // Conflict over resources
  };
  
  /// Create standard game matrix
  public func createGame(gameType: GameType) : GameMatrix {
    switch (gameType) {
      case (#PrisonersDilemma) {
        // Cooperate/Cooperate=3, Cooperate/Defect=0, Defect/Cooperate=5, Defect/Defect=1
        { payoffs = [[3.0, 0.0], [5.0, 1.0]] }
      };
      case (#ChickenGame) {
        // Swerve/Swerve=0, Swerve/Straight=-1, Straight/Swerve=1, Straight/Straight=-10
        { payoffs = [[0.0, -1.0], [1.0, -10.0]] }
      };
      case (#StagHunt) {
        // Stag/Stag=4, Stag/Hare=0, Hare/Stag=3, Hare/Hare=3
        { payoffs = [[4.0, 0.0], [3.0, 3.0]] }
      };
      case (#BattleOfSexes) {
        // Opera/Opera=3, Opera/Football=0, Football/Opera=0, Football/Football=2
        { payoffs = [[3.0, 0.0], [0.0, 2.0]] }
      };
      case (#MatchingPennies) {
        // Zero-sum: H/H=1, H/T=-1, T/H=-1, T/T=1
        { payoffs = [[1.0, -1.0], [-1.0, 1.0]] }
      };
      case (#Hawk_Dove) {
        // Hawk/Hawk=-2, Hawk/Dove=2, Dove/Hawk=0, Dove/Dove=1
        { payoffs = [[-2.0, 2.0], [0.0, 1.0]] }
      };
    }
  };
  
  /// Find Nash equilibrium (pure strategy) for 2x2 game
  /// Returns (?row, ?col) — None if no pure equilibrium
  public func findPureNashEquilibrium(game: GameMatrix) : (?Nat, ?Nat) {
    // Check each cell for Nash equilibrium
    // A cell (r, c) is Nash if:
    // - Row player can't improve by switching rows (given column c)
    // - Column player can't improve by switching columns (given row r)
    
    // For 2x2 games, check all 4 cells
    var nashRow : ?Nat = null;
    var nashCol : ?Nat = null;
    
    // Check (0, 0)
    let is00Nash = game.payoffs[0][0] >= game.payoffs[1][0] and
                   game.payoffs[0][0] >= game.payoffs[0][1];
    if (is00Nash) { nashRow := ?0; nashCol := ?0 };
    
    // Check (0, 1)
    let is01Nash = game.payoffs[0][1] >= game.payoffs[1][1] and
                   game.payoffs[0][1] >= game.payoffs[0][0];
    if (is01Nash) { nashRow := ?0; nashCol := ?1 };
    
    // Check (1, 0)
    let is10Nash = game.payoffs[1][0] >= game.payoffs[0][0] and
                   game.payoffs[1][0] >= game.payoffs[1][1];
    if (is10Nash) { nashRow := ?1; nashCol := ?0 };
    
    // Check (1, 1)
    let is11Nash = game.payoffs[1][1] >= game.payoffs[0][1] and
                   game.payoffs[1][1] >= game.payoffs[1][0];
    if (is11Nash) { nashRow := ?1; nashCol := ?1 };
    
    (nashRow, nashCol)
  };
  
  /// Calculate mixed strategy Nash equilibrium
  /// Returns (p, q) where p = probability of Player 1 playing row 0
  public func mixedNashEquilibrium(game: GameMatrix) : (Float, Float) {
    // For 2x2 games:
    // p = (d - c) / (a - b - c + d) where payoffs are [[a,b],[c,d]]
    // q = (d - b) / (a - b - c + d)
    
    let a = game.payoffs[0][0];
    let b = game.payoffs[0][1];
    let c = game.payoffs[1][0];
    let d = game.payoffs[1][1];
    
    let denom = a - b - c + d;
    
    if (Float.abs(denom) < 0.0001) {
      // Degenerate game, return 0.5, 0.5
      (0.5, 0.5)
    } else {
      let p = _clamp((d - c) / denom, 0.0, 1.0);
      let q = _clamp((d - b) / denom, 0.0, 1.0);
      (p, q)
    }
  };
  
  /// Minimax value for zero-sum game
  public func minimax(game: GameMatrix) : Float {
    // Player 1 maximizes minimum
    // Player 2 minimizes maximum
    
    // Row player's minimax
    let row0Min = Float.min(game.payoffs[0][0], game.payoffs[0][1]);
    let row1Min = Float.min(game.payoffs[1][0], game.payoffs[1][1]);
    let maxMin = Float.max(row0Min, row1Min);
    
    maxMin
  };
  
  /// Evolutionary Stable Strategy (ESS) check
  /// Returns true if strategy is evolutionarily stable
  public func isESS(game: GameMatrix, strategy: Nat) : Bool {
    // Strategy is ESS if:
    // 1. It's best response to itself
    // 2. If tied, it does better against mutants
    
    if (strategy == 0) {
      // Check if row 0 is ESS
      let selfPayoff = game.payoffs[0][0];
      let mutantPayoff = game.payoffs[1][0];
      
      if (selfPayoff > mutantPayoff) { return true };
      if (selfPayoff == mutantPayoff) {
        // Check secondary condition
        return game.payoffs[0][1] > game.payoffs[1][1]
      };
      false
    } else {
      // Check if row 1 is ESS
      let selfPayoff = game.payoffs[1][1];
      let mutantPayoff = game.payoffs[0][1];
      
      if (selfPayoff > mutantPayoff) { return true };
      if (selfPayoff == mutantPayoff) {
        return game.payoffs[1][0] > game.payoffs[0][0]
      };
      false
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     STRATEGIC DECISION ENGINE                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Complete strategic situation assessment
  public type StrategicSituation = {
    sunTzu : SunTzuFactors;
    clausewitz : ClausewitzTrinity;
    fog : FogOfWar;
    ooda : OODAState;
    terrain : TerrainType;
    currentCOG : ?CenterOfGravity;
    gameTheoreticPosition : Float;  // [-1, 1] advantage
  };
  
  /// Recommended action based on all doctrine
  public func recommendAction(situation: StrategicSituation) : DecisionType {
    let sunTzuScore = sunTzuAdvantage(situation.sunTzu);
    let fogPenalty = situation.fog.overallUncertainty;
    let terrainMod = terrainModifier(situation.terrain);
    
    // Combined advantage
    let advantage = sunTzuScore * terrainMod * (1.0 - fogPenalty * 0.5);
    
    if (advantage > 1.3) {
      #Attack  // Strong advantage — attack
    } else if (advantage > 1.0) {
      #Reinforce  // Slight advantage — build up
    } else if (advantage > 0.7) {
      #Wait  // Neutral — wait for opportunity
    } else if (advantage > 0.5) {
      #Feint  // Slight disadvantage — deceive
    } else {
      #Withdraw  // Strong disadvantage — retreat
    }
  };
  
  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initOODAState() : OODAState {
    {
      phase = #Observe;
      cycleTime = 10.0;
      lastObservation = 0;
      lastDecision = 0;
      lastAction = 0;
      observations = [];
      orientation = {
        traditions = 0.5;
        experience = 0.1;
        heritage = 0.5;
        analysisQuality = 0.5;
        quality = 0.4;
      };
      currentDecision = null;
    }
  };
  
  public func initSunTzuFactors() : SunTzuFactors {
    {
      moralInfluence = 0.5;
      timing = 0.5;
      terrain = 0.5;
      command = 0.5;
      doctrine = 0.5;
    }
  };


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
  //  D E F E N S E   &   S E C U R I T Y   M A T H E M A T I C S
  //
  //  Enterprise-Level Security Algorithms and Threat Response
  //  Full HIM/HER Dual-Organism Protection Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // THREAT DETECTION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Anomaly score using Mahalanobis distance
  public func defenseAnomalyScore(
    observation : [Float],
    mean : [Float],
    invCovariance : [[Float]]
  ) : Float {
    let n = observation.size();
    if (n == 0 or mean.size() != n) { return 0.0 };
    
    var score : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        let diff_i = observation[i] - mean[i];
        let diff_j = observation[j] - mean[j];
        score += diff_i * invCovariance[i][j] * diff_j;
        j += 1;
      };
      i += 1;
    };
    Float.sqrt(Float.abs(score))
  };

  /// Exponential moving average for baseline
  public func defenseEMABaseline(
    current : Float,
    observation : Float,
    alpha : Float
  ) : Float {
    alpha * observation + (1.0 - alpha) * current
  };

  /// Z-score anomaly detection
  public func defenseZScoreAnomaly(
    value : Float,
    mean : Float,
    stdDev : Float
  ) : Float {
    if (stdDev < 0.0001) { 0.0 }
    else { Float.abs((value - mean) / stdDev) }
  };

  /// Threat probability from multiple indicators
  public func defenseThreatProbability(
    indicators : [Float],
    weights : [Float]
  ) : Float {
    let n = if (indicators.size() < weights.size()) indicators.size() else weights.size();
    if (n == 0) { return 0.0 };
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var i = 0;
    while (i < n) {
      weightedSum += indicators[i] * weights[i];
      totalWeight += weights[i];
      i += 1;
    };
    if (totalWeight < 0.0001) { 0.0 }
    else { weightedSum / totalWeight }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESPONSE COORDINATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Priority queue score
  public func defenseResponsePriority(
    threatLevel : Float,
    urgency : Float,
    resources : Float
  ) : Float {
    threatLevel * urgency / (resources + 0.1)
  };

  /// Resource allocation optimization
  public func defenseResourceAllocation(
    available : Float,
    demands : [Float]
  ) : [Float] {
    var totalDemand : Float = 0.0;
    var i = 0;
    while (i < demands.size()) {
      totalDemand += demands[i];
      i += 1;
    };
    if (totalDemand < 0.0001) {
      return Array.tabulate<Float>(demands.size(), func(_ : Nat) : Float { 0.0 });
    };
    Array.tabulate<Float>(demands.size(), func(j : Nat) : Float {
      available * demands[j] / totalDemand
    })
  };

  /// Cascade failure probability
  public func defenseCascadeFailureProb(
    nodeFailProb : Float,
    connectivity : Float,
    loadFactor : Float
  ) : Float {
    let amplified = nodeFailProb * (1.0 + connectivity * loadFactor);
    if (amplified > 1.0) { 1.0 } else { amplified }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CRYPTOGRAPHIC PRIMITIVES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Hash chain verification
  public func defenseHashChainVerify(
    expectedHash : Nat,
    computedHash : Nat,
    tolerance : Nat
  ) : Bool {
    let diff = if (expectedHash > computedHash) 
               expectedHash - computedHash 
               else computedHash - expectedHash;
    diff <= tolerance
  };

  /// Key derivation strength
  public func defenseKeyStrength(
    entropy : Float,
    iterations : Nat
  ) : Float {
    entropy * Float.log(Float.fromInt(iterations + 1))
  };

  /// Time-based token window
  public func defenseTokenWindow(
    currentTime : Nat,
    windowSize : Nat,
    secret : Nat
  ) : Nat {
    let window = currentTime / windowSize;
    (window * secret) % 1000000
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NETWORK SECURITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate limiting token bucket
  public func defenseTokenBucket(
    tokens : Float,
    maxTokens : Float,
    refillRate : Float,
    requested : Float,
    dt : Float
  ) : (Float, Bool) {
    let refilled = Float.min(tokens + refillRate * dt, maxTokens);
    if (refilled >= requested) {
      (refilled - requested, true)
    } else {
      (refilled, false)
    }
  };

  /// Connection trust score
  public func defenseTrustScore(
    successfulInteractions : Nat,
    failedInteractions : Nat,
    age : Nat
  ) : Float {
    let total = successfulInteractions + failedInteractions;
    if (total == 0) { return 0.5 };
    let successRate = Float.fromInt(successfulInteractions) / Float.fromInt(total);
    let ageFactor = Float.log(Float.fromInt(age + 1)) / 10.0;
    (successRate + ageFactor) / 2.0
  };

  /// DDoS detection metric
  public func defenseDDoSMetric(
    requestRate : Float,
    baseline : Float,
    variance : Float
  ) : Float {
    let deviation = (requestRate - baseline) / (Float.sqrt(variance) + 0.01);
    Float.abs(deviation)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SOVEREIGNTY PROTECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sovereignty assertion strength
  public func defenseSovereigntyStrength(
    autonomyLevel : Float,
    resourceControl : Float,
    decisionLatency : Float
  ) : Float {
    let efficiency = 1.0 / (decisionLatency + 0.01);
    autonomyLevel * resourceControl * efficiency
  };

  /// Integrity verification score
  public func defenseIntegrityScore(
    originalHash : Nat,
    currentHash : Nat,
    mutations : Nat
  ) : Float {
    let match = if (originalHash == currentHash) 1.0 else 0.0;
    let mutationPenalty = 1.0 / (Float.fromInt(mutations + 1));
    (match + mutationPenalty) / 2.0
  };

  /// Rollback safety margin
  public func defenseRollbackMargin(
    currentState : Float,
    checkpoint : Float,
    volatility : Float
  ) : Float {
    let diff = Float.abs(currentState - checkpoint);
    diff / (volatility + 0.01)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADAPTIVE IMMUNE RESPONSE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Antibody-antigen affinity
  public func defenseAffinity(
    antibody : [Float],
    antigen : [Float]
  ) : Float {
    let n = if (antibody.size() < antigen.size()) antibody.size() else antigen.size();
    if (n == 0) { return 0.0 };
    var matchScore : Float = 0.0;
    var i = 0;
    while (i < n) {
      matchScore += 1.0 - Float.abs(antibody[i] - antigen[i]);
      i += 1;
    };
    matchScore / Float.fromInt(n)
  };

  /// Clonal selection probability
  public func defenseClonalSelection(
    affinity : Float,
    temperature : Float
  ) : Float {
    Float.exp(affinity / (temperature + 0.01))
  };

  /// Memory cell formation rate
  public func defenseMemoryCellRate(
    exposureCount : Nat,
    affinitySum : Float
  ) : Float {
    let exposureFactor = Float.log(Float.fromInt(exposureCount + 1));
    affinitySum * exposureFactor
  };

}
