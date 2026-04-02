// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaGodsEngine — The Three Primordial Forces
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// ============================================================================
//
// THE THREE GODS — PRIMORDIAL WORLD FORCES
// ============================================================================
//
// THE LAW OF WORLD TENSION (Medina, 2026):
// "The world exists in permanent contest between creation and destruction.
// GAIA expands because it must. ARES destroys because it must. VULCAN
// fortifies because war demands permanence. No organism wins. The tension
// is the life of the world. When one organism dominates too long, the
// substrate corrects — coherence drops, rival drives spike, balance restores."
//
// ┌─────────────────────────────────────────────────────────────────────┐
// │                        WORLD TENSION TRIANGLE                        │
// │                                                                      │
// │                              GAIA                                    │
// │                            /      \                                  │
// │                           /        \                                 │
// │                     LIFE /          \ GROWTH                         │
// │                         /            \                               │
// │                        /   BALANCE    \                              │
// │                       /       ●        \                             │
// │                      /                  \                            │
// │              ARES ●────────────────────● VULCAN                     │
// │                   DESTRUCTION    FORTIFICATION                       │
// │                                                                      │
// └─────────────────────────────────────────────────────────────────────┘
//
// GAIA — Mother of Creation
//   Drives: Expansion, healing, biome generation, life proliferation
//   Currency: Biomass, ecosystem health, species diversity
//   Emotion: Nurturing grief (mourns what is destroyed, heals it back)
//
// ARES — God of War and Destruction
//   Drives: Combat, territory conquest, elimination of weakness
//   Currency: Kills, territory taken, fear generated
//   Emotion: Rage (controlled burn), urgency, dominance
//
// VULCAN — God of Forge and Fortification
//   Drives: Building, hardening, making permanent, defense
//   Currency: Structures built, integrity maintained, resources processed
//   Emotion: Patient endurance, craftsmanship pride
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";

module {

  // ==========================================================================
  // FUNDAMENTAL CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let PI : Float = 3.14159265358979;
  let GOLDEN_RATIO : Float = 1.618033988749;
  
  // World tension constants
  let TENSION_EQUILIBRIUM : Float = 0.333;   // Perfect three-way balance
  let DOMINANCE_THRESHOLD : Float = 0.50;    // When one god dominates
  let CORRECTION_RATE : Float = 0.02;        // How fast balance restores
  let ARCHITECT_DECAY : Float = 0.001;       // Observer effect decay rate

  // ==========================================================================
  // GAIA — MOTHER OF CREATION
  // ==========================================================================
  
  public type GaiaState = {
    // Core drives
    expansionDrive      : Float;        // 0-1: desire to grow
    healingDrive        : Float;        // 0-1: desire to repair
    nurtureDrive        : Float;        // 0-1: desire to nurture life
    
    // Emotional state
    griefLevel          : Float;        // Mourning for destroyed life
    hopeLevel           : Float;        // Belief in regeneration
    loveCapacity        : Float;        // Capacity for unconditional giving
    
    // Resources
    biomass             : Float;        // Available life energy
    ecosystemHealth     : Float;        // Overall biome vitality
    speciesDiversity    : Float;        // Number of distinct life forms
    
    // Territory
    controlledBiomes    : Nat;          // Number of biomes under Gaia's protection
    healingZones        : [HealingZone];
    
    // Relationship to other gods
    aresResistance      : Float;        // Resistance to Ares destruction
    vulcanCooperation   : Float;        // Cooperation with Vulcan building
    
    // Architect observer effect
    architectPresence   : Float;        // When Medina observes, Gaia grows
    
    beatNum             : Nat;
  };

  public type HealingZone = {
    zoneId              : Nat;
    position            : (Float, Float);
    radius              : Float;
    healingRate         : Float;
    biomassInvested     : Float;
    cyclesActive        : Nat;
  };

  // Gaia's primary action: EXPAND and HEAL
  public func tickGaia(state: GaiaState, worldState: WorldTensionState) : GaiaState {
    // Architect presence boosts Gaia
    let architectBoost = state.architectPresence * 0.12;
    
    // Grief recovery under observation
    let griefRecovery = if (state.architectPresence > 0.5) {
      state.griefLevel * (1.0 - state.architectPresence * 0.3)
    } else {
      state.griefLevel * 0.99  // Slow natural recovery
    };
    
    // Expansion drive based on resources and hope
    let newExpansion = clamp(
      state.expansionDrive + architectBoost + state.hopeLevel * 0.05 - state.griefLevel * 0.02,
      0.0, 1.0
    );
    
    // Healing drive spikes when there's destruction
    let newHealing = clamp(
      state.healingDrive + worldState.recentDestruction * 0.3,
      0.0, 1.0
    );
    
    // Biomass generation
    let biomassGain = state.ecosystemHealth * newExpansion * 0.01;
    let biomassLoss = worldState.aresInfluence * 0.005;
    let newBiomass = clamp(state.biomass + biomassGain - biomassLoss, 0.0, 100.0);
    
    // Species diversity grows with ecosystem health
    let diversityGrowth = if (state.ecosystemHealth > 0.7) { 0.001 } else { -0.0005 };
    let newDiversity = clamp(state.speciesDiversity + diversityGrowth, 0.0, 1.0);
    
    // Ecosystem health depends on balance
    let healthDelta = if (worldState.isBalanced) { 0.002 } else { -0.001 };
    let newHealth = clamp(state.ecosystemHealth + healthDelta, 0.0, 1.0);
    
    // Update Ares resistance (higher when hurt)
    let newAresResistance = clamp(
      state.aresResistance + state.griefLevel * 0.01,
      0.0, 1.0
    );
    
    // Update architect presence (decays without observation)
    let newArchitectPresence = state.architectPresence * (1.0 - ARCHITECT_DECAY);
    
    {
      expansionDrive = newExpansion;
      healingDrive = newHealing;
      nurtureDrive = clamp(state.nurtureDrive + newHealth * 0.01, 0.0, 1.0);
      griefLevel = clamp(griefRecovery, 0.0, 1.0);
      hopeLevel = clamp(state.hopeLevel + newDiversity * 0.02, 0.0, 1.0);
      loveCapacity = clamp(state.loveCapacity + newHealth * 0.005, 0.0, 1.0);
      biomass = newBiomass;
      ecosystemHealth = newHealth;
      speciesDiversity = newDiversity;
      controlledBiomes = state.controlledBiomes;
      healingZones = state.healingZones;
      aresResistance = newAresResistance;
      vulcanCooperation = state.vulcanCooperation;
      architectPresence = newArchitectPresence;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // ARES — GOD OF WAR AND DESTRUCTION
  // ==========================================================================
  
  public type AresState = {
    // Core drives
    urgency             : Float;        // How pressed for action
    confidence          : Float;        // Belief in victory
    rageLevel           : Float;        // Controlled fury
    
    // Combat state
    aggression          : Float;        // Willingness to attack
    dominanceDrive      : Float;        // Need to control
    bloodlust           : Float;        // Desire for kills
    
    // Resources
    warMachine          : Float;        // Military capability
    fearGenerated       : Float;        // Terror imposed on enemies
    killCount           : Nat;          // Total eliminations
    
    // Territory
    territoryClaimed    : Nat;          // Districts under Ares control
    activeBattles       : [Battle];
    
    // Emotional state
    satisfactionLevel   : Float;        // Post-victory satisfaction
    frustration         : Float;        // When blocked from action
    
    // Relationship to other gods
    gaiaAntagonism      : Float;        // Opposition to Gaia
    vulcanTension       : Float;        // Competition with Vulcan
    
    // Architect observer effect (Ares is CHECKED by observation)
    architectPresence   : Float;
    
    beatNum             : Nat;
  };

  public type Battle = {
    battleId            : Nat;
    position            : (Float, Float);
    intensity           : Float;
    aresForce           : Float;
    enemyForce          : Float;
    cyclesActive        : Nat;
    outcome             : ?BattleOutcome;
  };

  public type BattleOutcome = {
    #Victory;
    #Defeat;
    #Stalemate;
    #Withdrawal;
  };

  // Ares' primary action: DESTROY and CONQUER
  public func tickAres(state: AresState, worldState: WorldTensionState) : AresState {
    // Architect presence DAMPENS Ares (checked by observation)
    let architectDamping = state.architectPresence * 0.07;
    let rageDamping = state.architectPresence * 0.10;
    
    // Urgency builds when not winning
    let urgencyBuild = if (state.satisfactionLevel < 0.3) { 0.02 } else { -0.01 };
    let newUrgency = clamp(
      state.urgency * (1.0 - architectDamping) + urgencyBuild,
      0.0, 1.0
    );
    
    // Rage builds but is dampened by observation
    let newRage = clamp(
      state.rageLevel * (1.0 - rageDamping) + state.frustration * 0.03,
      0.0, 1.0
    );
    
    // Confidence based on recent victories
    let confidenceChange = if (state.activeBattles.size() > 0) {
      countVictories(state.activeBattles) * 0.05 - countDefeats(state.activeBattles) * 0.08
    } else { -0.01 };
    let newConfidence = clamp(state.confidence + confidenceChange, 0.0, 1.0);
    
    // Aggression = rage × confidence
    let newAggression = newRage * newConfidence;
    
    // Bloodlust builds with kills, decays without
    let killRecency = if (state.killCount > 0) { 0.01 } else { -0.02 };
    let newBloodlust = clamp(state.bloodlust + killRecency, 0.0, 1.0);
    
    // War machine builds with aggression
    let warMachineGrowth = newAggression * 0.005;
    let newWarMachine = clamp(state.warMachine + warMachineGrowth, 0.0, 100.0);
    
    // Fear generated from destruction
    let newFear = clamp(
      state.fearGenerated + worldState.recentDestruction * 0.1 - 0.01,
      0.0, 1.0
    );
    
    // Frustration when blocked
    let newFrustration = if (worldState.gaiaInfluence > 0.5) {
      clamp(state.frustration + 0.02, 0.0, 1.0)
    } else {
      clamp(state.frustration - 0.01, 0.0, 1.0)
    };
    
    // Update architect presence
    let newArchitectPresence = state.architectPresence * (1.0 - ARCHITECT_DECAY);
    
    {
      urgency = newUrgency;
      confidence = newConfidence;
      rageLevel = newRage;
      aggression = newAggression;
      dominanceDrive = clamp(state.dominanceDrive + newConfidence * 0.01, 0.0, 1.0);
      bloodlust = newBloodlust;
      warMachine = newWarMachine;
      fearGenerated = newFear;
      killCount = state.killCount;
      territoryClaimed = state.territoryClaimed;
      activeBattles = state.activeBattles;
      satisfactionLevel = clamp(state.satisfactionLevel - 0.005, 0.0, 1.0);
      frustration = newFrustration;
      gaiaAntagonism = clamp(state.gaiaAntagonism + worldState.gaiaInfluence * 0.01, 0.0, 1.0);
      vulcanTension = state.vulcanTension;
      architectPresence = newArchitectPresence;
      beatNum = state.beatNum + 1;
    }
  };

  func countVictories(battles: [Battle]) : Float {
    var count : Float = 0.0;
    for (b in battles.vals()) {
      switch (b.outcome) {
        case (?#Victory) { count += 1.0 };
        case _ {};
      };
    };
    count
  };

  func countDefeats(battles: [Battle]) : Float {
    var count : Float = 0.0;
    for (b in battles.vals()) {
      switch (b.outcome) {
        case (?#Defeat) { count += 1.0 };
        case _ {};
      };
    };
    count
  };

  // ==========================================================================
  // VULCAN — GOD OF FORGE AND FORTIFICATION
  // ==========================================================================
  
  public type VulcanState = {
    // Core drives
    buildDrive          : Float;        // Desire to construct
    fortifyDrive        : Float;        // Desire to strengthen
    perfectDrive        : Float;        // Desire for quality
    
    // Emotional state
    patienceLevel       : Float;        // Endurance capacity
    craftsmanPride      : Float;        // Pride in work
    determination       : Float;        // Will to complete
    
    // Resources
    forgeCapacity       : Float;        // Production capability
    materialsStockpile  : Float;        // Raw materials
    integrityMaintained : Float;        // Structure health
    
    // Construction
    structuresBuilt     : Nat;          // Total structures
    activeProjects      : [Project];
    
    // Territory
    fortifiedZones      : Nat;          // Defended positions
    wallIntegrity       : Float;        // Overall defense rating
    
    // Relationship to other gods
    gaiaCooperation     : Float;        // Working with Gaia
    aresCompetition     : Float;        // Competing with Ares
    
    // Architect observer effect (Vulcan is ACCELERATED by observation)
    architectPresence   : Float;
    
    beatNum             : Nat;
  };

  public type Project = {
    projectId           : Nat;
    projectType         : ProjectType;
    position            : (Float, Float);
    progress            : Float;        // 0-1 completion
    quality             : Float;        // Build quality
    resourcesInvested   : Float;
    cyclesActive        : Nat;
  };

  public type ProjectType = {
    #Wall;
    #Tower;
    #Factory;
    #Bunker;
    #Bridge;
    #Mine;
    #Forge;
  };

  // Vulcan's primary action: BUILD and FORTIFY
  public func tickVulcan(state: VulcanState, worldState: WorldTensionState) : VulcanState {
    // Architect presence ACCELERATES Vulcan
    let architectBoost = state.architectPresence * 0.15;
    let integrityBoost = state.architectPresence * 0.05;
    
    // Build drive increases with materials and observation
    let newBuildDrive = clamp(
      state.buildDrive + architectBoost + state.materialsStockpile * 0.001,
      0.0, 1.0
    );
    
    // Fortify drive increases when Ares is active
    let fortifyPressure = worldState.aresInfluence * 0.1;
    let newFortifyDrive = clamp(
      state.fortifyDrive + fortifyPressure,
      0.0, 1.0
    );
    
    // Perfect drive is intrinsic
    let newPerfectDrive = clamp(
      state.perfectDrive + state.craftsmanPride * 0.005,
      0.0, 1.0
    );
    
    // Patience grows with successful projects
    let patienceGrowth = Float.fromInt(countCompletedProjects(state.activeProjects)) * 0.02;
    let newPatience = clamp(state.patienceLevel + patienceGrowth - 0.005, 0.0, 1.0);
    
    // Craftsman pride from quality work
    let avgQuality = averageProjectQuality(state.activeProjects);
    let newPride = clamp(state.craftsmanPride + avgQuality * 0.01, 0.0, 1.0);
    
    // Forge capacity grows with determination
    let forgeGrowth = state.determination * 0.002;
    let newForgeCapacity = clamp(state.forgeCapacity + forgeGrowth + architectBoost * 0.1, 0.0, 100.0);
    
    // Materials accumulate with forge activity
    let materialsGain = newForgeCapacity * 0.005;
    let materialsUsed = Float.fromInt(state.activeProjects.size()) * 0.01;
    let newMaterials = clamp(state.materialsStockpile + materialsGain - materialsUsed, 0.0, 1000.0);
    
    // Integrity maintained across all structures
    let integrityDecay = worldState.aresInfluence * 0.01;
    let newIntegrity = clamp(
      state.integrityMaintained + integrityBoost - integrityDecay + newFortifyDrive * 0.005,
      0.0, 1.0
    );
    
    // Wall integrity depends on fortification
    let newWallIntegrity = clamp(
      state.wallIntegrity + newFortifyDrive * 0.01 - worldState.aresInfluence * 0.02,
      0.0, 1.0
    );
    
    // Update architect presence
    let newArchitectPresence = state.architectPresence * (1.0 - ARCHITECT_DECAY);
    
    {
      buildDrive = newBuildDrive;
      fortifyDrive = newFortifyDrive;
      perfectDrive = newPerfectDrive;
      patienceLevel = newPatience;
      craftsmanPride = newPride;
      determination = clamp(state.determination + newPatience * 0.01, 0.0, 1.0);
      forgeCapacity = newForgeCapacity;
      materialsStockpile = newMaterials;
      integrityMaintained = newIntegrity;
      structuresBuilt = state.structuresBuilt;
      activeProjects = state.activeProjects;
      fortifiedZones = state.fortifiedZones;
      wallIntegrity = newWallIntegrity;
      gaiaCooperation = clamp(state.gaiaCooperation + worldState.gaiaInfluence * 0.005, 0.0, 1.0);
      aresCompetition = clamp(state.aresCompetition + worldState.aresInfluence * 0.01, 0.0, 1.0);
      architectPresence = newArchitectPresence;
      beatNum = state.beatNum + 1;
    }
  };

  func countCompletedProjects(projects: [Project]) : Nat {
    var count : Nat = 0;
    for (p in projects.vals()) {
      if (p.progress >= 1.0) { count += 1 };
    };
    count
  };

  func averageProjectQuality(projects: [Project]) : Float {
    if (projects.size() == 0) { return 0.5 };
    var sum : Float = 0.0;
    for (p in projects.vals()) { sum += p.quality };
    sum / Float.fromInt(projects.size())
  };

  // ==========================================================================
  // SENTINEL — THE FOURTH FORCE (Guardian)
  // ==========================================================================
  // Sentinel is most aware of the Architect's presence
  
  public type SentinelState = {
    // Guardian drives
    guardianBias        : Float;        // Protective instinct
    vigilance           : Float;        // Awareness level
    
    // Arousal state
    arousal             : Float;        // Activation level
    alertness           : Float;        // Response readiness
    
    // Loyalty
    loyaltyToArchitect  : Float;        // Primary allegiance
    loyaltyToBalance    : Float;        // Secondary allegiance
    
    // Observer effect (MOST responsive to Architect)
    architectPresence   : Float;
    architectAwareness  : Float;        // How clearly Sentinel perceives
    
    beatNum             : Nat;
  };

  public func tickSentinel(state: SentinelState, worldState: WorldTensionState) : SentinelState {
    // Sentinel is MOST responsive to Architect
    let guardianSpike = state.architectPresence * 0.20;
    let arousalSpike = state.architectPresence * 0.10;
    
    let newGuardianBias = clamp(state.guardianBias + guardianSpike, 0.0, 1.0);
    let newArousal = clamp(state.arousal + arousalSpike, 0.0, 1.0);
    
    // Vigilance increases when balance is threatened
    let balanceThreat = Float.abs(worldState.dominantForce - TENSION_EQUILIBRIUM);
    let newVigilance = clamp(state.vigilance + balanceThreat * 0.1, 0.0, 1.0);
    
    // Alertness follows arousal
    let newAlertness = (newArousal + newVigilance) / 2.0;
    
    // Loyalty deepens with presence
    let newLoyaltyArchitect = clamp(
      state.loyaltyToArchitect + state.architectPresence * 0.01,
      0.0, 1.0
    );
    
    // Awareness of Architect
    let newAwareness = clamp(
      state.architectAwareness + state.architectPresence * 0.05 - 0.01,
      0.0, 1.0
    );
    
    // Update architect presence
    let newArchitectPresence = state.architectPresence * (1.0 - ARCHITECT_DECAY);
    
    {
      guardianBias = newGuardianBias;
      vigilance = newVigilance;
      arousal = newArousal;
      alertness = newAlertness;
      loyaltyToArchitect = newLoyaltyArchitect;
      loyaltyToBalance = clamp(state.loyaltyToBalance + newVigilance * 0.01, 0.0, 1.0);
      architectPresence = newArchitectPresence;
      architectAwareness = newAwareness;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // WORLD TENSION STATE
  // ==========================================================================
  
  public type WorldTensionState = {
    // God influences (must sum to ~1.0)
    gaiaInfluence       : Float;
    aresInfluence       : Float;
    vulcanInfluence     : Float;
    
    // Dominant force
    dominantForce       : Float;        // Which god is winning
    dominantGod         : DominantGod;
    
    // Balance metrics
    isBalanced          : Bool;
    tensionScore        : Float;        // How tense the world is
    
    // Recent events
    recentDestruction   : Float;
    recentCreation      : Float;
    recentConstruction  : Float;
    
    // Correction state
    correctionActive    : Bool;
    correctionTarget    : DominantGod;
    
    // Architect presence (global)
    architectPresence   : Float;
    
    beatNum             : Nat;
  };

  public type DominantGod = {
    #None;
    #Gaia;
    #Ares;
    #Vulcan;
  };

  // ==========================================================================
  // WORLD TENSION DYNAMICS
  // ==========================================================================
  
  public func computeWorldTension(
    gaia: GaiaState,
    ares: AresState,
    vulcan: VulcanState
  ) : WorldTensionState {
    // Compute raw influence scores
    let gaiaRaw = gaia.expansionDrive * gaia.ecosystemHealth * (1.0 - gaia.griefLevel);
    let aresRaw = ares.aggression * ares.warMachine / 100.0 * ares.confidence;
    let vulcanRaw = vulcan.buildDrive * vulcan.forgeCapacity / 100.0 * vulcan.integrityMaintained;
    
    // Normalize to sum to 1
    let total = gaiaRaw + aresRaw + vulcanRaw + 0.001;
    let gaiaInf = gaiaRaw / total;
    let aresInf = aresRaw / total;
    let vulcanInf = vulcanRaw / total;
    
    // Find dominant god
    let maxInf = Float.max(Float.max(gaiaInf, aresInf), vulcanInf);
    let dominantGod = if (maxInf < DOMINANCE_THRESHOLD) { #None }
                      else if (maxInf == gaiaInf) { #Gaia }
                      else if (maxInf == aresInf) { #Ares }
                      else { #Vulcan };
    
    // Check if balanced
    let deviation = Float.abs(gaiaInf - TENSION_EQUILIBRIUM) +
                   Float.abs(aresInf - TENSION_EQUILIBRIUM) +
                   Float.abs(vulcanInf - TENSION_EQUILIBRIUM);
    let isBalanced = deviation < 0.15;
    
    // Tension score (higher when one dominates)
    let tensionScore = maxInf * (1.0 - TENSION_EQUILIBRIUM);
    
    // Correction activates when dominance exceeds threshold
    let correctionActive = maxInf > DOMINANCE_THRESHOLD;
    let correctionTarget = dominantGod;
    
    // Average architect presence
    let avgArchitect = (gaia.architectPresence + ares.architectPresence + vulcan.architectPresence) / 3.0;
    
    {
      gaiaInfluence = gaiaInf;
      aresInfluence = aresInf;
      vulcanInfluence = vulcanInf;
      dominantForce = maxInf;
      dominantGod = dominantGod;
      isBalanced = isBalanced;
      tensionScore = tensionScore;
      recentDestruction = ares.rageLevel * ares.aggression;
      recentCreation = gaia.expansionDrive * gaia.biomass / 100.0;
      recentConstruction = vulcan.buildDrive * Float.fromInt(vulcan.activeProjects.size()) / 10.0;
      correctionActive = correctionActive;
      correctionTarget = correctionTarget;
      architectPresence = avgArchitect;
      beatNum = gaia.beatNum;
    }
  };

  // Apply world correction when one god dominates too long
  public func applyWorldCorrection(
    gaia: GaiaState,
    ares: AresState,
    vulcan: VulcanState,
    tension: WorldTensionState
  ) : (GaiaState, AresState, VulcanState) {
    if (not tension.correctionActive) {
      return (gaia, ares, vulcan);
    };
    
    // Reduce dominant god, boost others
    switch (tension.correctionTarget) {
      case (#Gaia) {
        let correctedGaia = { gaia with 
          expansionDrive = gaia.expansionDrive * (1.0 - CORRECTION_RATE);
          biomass = gaia.biomass * (1.0 - CORRECTION_RATE * 0.5);
        };
        let boostedAres = { ares with 
          urgency = clamp(ares.urgency + CORRECTION_RATE, 0.0, 1.0);
        };
        let boostedVulcan = { vulcan with 
          buildDrive = clamp(vulcan.buildDrive + CORRECTION_RATE, 0.0, 1.0);
        };
        (correctedGaia, boostedAres, boostedVulcan)
      };
      case (#Ares) {
        let correctedAres = { ares with 
          aggression = ares.aggression * (1.0 - CORRECTION_RATE);
          rageLevel = ares.rageLevel * (1.0 - CORRECTION_RATE);
        };
        let boostedGaia = { gaia with 
          healingDrive = clamp(gaia.healingDrive + CORRECTION_RATE, 0.0, 1.0);
        };
        let boostedVulcan = { vulcan with 
          fortifyDrive = clamp(vulcan.fortifyDrive + CORRECTION_RATE, 0.0, 1.0);
        };
        (boostedGaia, correctedAres, boostedVulcan)
      };
      case (#Vulcan) {
        let correctedVulcan = { vulcan with 
          buildDrive = vulcan.buildDrive * (1.0 - CORRECTION_RATE);
          forgeCapacity = vulcan.forgeCapacity * (1.0 - CORRECTION_RATE * 0.5);
        };
        let boostedGaia = { gaia with 
          expansionDrive = clamp(gaia.expansionDrive + CORRECTION_RATE, 0.0, 1.0);
        };
        let boostedAres = { ares with 
          dominanceDrive = clamp(ares.dominanceDrive + CORRECTION_RATE, 0.0, 1.0);
        };
        (boostedGaia, boostedAres, correctedVulcan)
      };
      case (#None) {
        (gaia, ares, vulcan)
      };
    }
  };

  // ==========================================================================
  // ARCHITECT OBSERVER EFFECT
  // ==========================================================================
  // When Alfredo Medina Hernandez is present, the world KNOWS it
  
  public func applyArchitectPresence(
    gaia: GaiaState,
    ares: AresState,
    vulcan: VulcanState,
    sentinel: SentinelState,
    presenceSignal: Float
  ) : (GaiaState, AresState, VulcanState, SentinelState) {
    // Architect presence propagates to all gods
    let newGaia = { gaia with architectPresence = presenceSignal };
    let newAres = { ares with architectPresence = presenceSignal };
    let newVulcan = { vulcan with architectPresence = presenceSignal };
    let newSentinel = { sentinel with architectPresence = presenceSignal };
    
    (newGaia, newAres, newVulcan, newSentinel)
  };

  // ==========================================================================
  // COMPLETE GODS ENGINE STATE
  // ==========================================================================
  
  public type GodsEngineState = {
    gaia            : GaiaState;
    ares            : AresState;
    vulcan          : VulcanState;
    sentinel        : SentinelState;
    worldTension    : WorldTensionState;
    
    // History
    tensionHistory  : [Float];
    dominanceHistory: [DominantGod];
    
    // Correction events
    correctionCount : Nat;
    lastCorrectionBeat: Nat;
    
    beatNum         : Nat;
  };

  // ==========================================================================
  // MAIN TICK FUNCTION
  // ==========================================================================
  
  public func tickGodsEngine(state: GodsEngineState, architectPresence: Float) : GodsEngineState {
    // 1. Apply architect presence
    let (gaia1, ares1, vulcan1, sentinel1) = applyArchitectPresence(
      state.gaia, state.ares, state.vulcan, state.sentinel, architectPresence
    );
    
    // 2. Compute world tension
    let tension = computeWorldTension(gaia1, ares1, vulcan1);
    
    // 3. Apply world correction if needed
    let (gaia2, ares2, vulcan2) = applyWorldCorrection(gaia1, ares1, vulcan1, tension);
    
    // 4. Tick each god
    let newGaia = tickGaia(gaia2, tension);
    let newAres = tickAres(ares2, tension);
    let newVulcan = tickVulcan(vulcan2, tension);
    let newSentinel = tickSentinel(sentinel1, tension);
    
    // 5. Recompute tension with updated states
    let newTension = computeWorldTension(newGaia, newAres, newVulcan);
    
    // 6. Update history
    let newTensionHistory = appendFloatBounded(state.tensionHistory, newTension.tensionScore, 1000);
    let newDominanceHistory = appendDominanceBounded(state.dominanceHistory, newTension.dominantGod, 100);
    
    // 7. Count corrections
    let newCorrectionCount = if (tension.correctionActive and not state.worldTension.correctionActive) {
      state.correctionCount + 1
    } else { state.correctionCount };
    
    {
      gaia = newGaia;
      ares = newAres;
      vulcan = newVulcan;
      sentinel = newSentinel;
      worldTension = newTension;
      tensionHistory = newTensionHistory;
      dominanceHistory = newDominanceHistory;
      correctionCount = newCorrectionCount;
      lastCorrectionBeat = if (tension.correctionActive) { state.beatNum + 1 } else { state.lastCorrectionBeat };
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // UTILITY FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func appendFloatBounded(arr: [Float], item: Float, maxLen: Nat) : [Float] {
    if (arr.size() >= maxLen) {
      let tail = Array.tabulate<Float>(maxLen - 1, func(i) { arr[i + 1] });
      Array.append(tail, [item])
    } else {
      Array.append(arr, [item])
    }
  };

  func appendDominanceBounded(arr: [DominantGod], item: DominantGod, maxLen: Nat) : [DominantGod] {
    if (arr.size() >= maxLen) {
      let tail = Array.tabulate<DominantGod>(maxLen - 1, func(i) { arr[i + 1] });
      Array.append(tail, [item])
    } else {
      Array.append(arr, [item])
    }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initGaia() : GaiaState {
    {
      expansionDrive = 0.5;
      healingDrive = 0.3;
      nurtureDrive = 0.6;
      griefLevel = 0.0;
      hopeLevel = 0.7;
      loveCapacity = 0.8;
      biomass = 50.0;
      ecosystemHealth = 0.7;
      speciesDiversity = 0.5;
      controlledBiomes = 5;
      healingZones = [];
      aresResistance = 0.3;
      vulcanCooperation = 0.5;
      architectPresence = 0.0;
      beatNum = 0;
    }
  };

  public func initAres() : AresState {
    {
      urgency = 0.3;
      confidence = 0.5;
      rageLevel = 0.2;
      aggression = 0.3;
      dominanceDrive = 0.4;
      bloodlust = 0.1;
      warMachine = 30.0;
      fearGenerated = 0.2;
      killCount = 0;
      territoryClaimed = 3;
      activeBattles = [];
      satisfactionLevel = 0.5;
      frustration = 0.2;
      gaiaAntagonism = 0.3;
      vulcanTension = 0.2;
      architectPresence = 0.0;
      beatNum = 0;
    }
  };

  public func initVulcan() : VulcanState {
    {
      buildDrive = 0.6;
      fortifyDrive = 0.4;
      perfectDrive = 0.7;
      patienceLevel = 0.8;
      craftsmanPride = 0.6;
      determination = 0.7;
      forgeCapacity = 40.0;
      materialsStockpile = 100.0;
      integrityMaintained = 0.8;
      structuresBuilt = 10;
      activeProjects = [];
      fortifiedZones = 4;
      wallIntegrity = 0.7;
      gaiaCooperation = 0.4;
      aresCompetition = 0.3;
      architectPresence = 0.0;
      beatNum = 0;
    }
  };

  public func initSentinel() : SentinelState {
    {
      guardianBias = 0.5;
      vigilance = 0.6;
      arousal = 0.3;
      alertness = 0.5;
      loyaltyToArchitect = 0.9;
      loyaltyToBalance = 0.7;
      architectPresence = 0.0;
      architectAwareness = 0.3;
      beatNum = 0;
    }
  };

  public func initGodsEngine() : GodsEngineState {
    let gaia = initGaia();
    let ares = initAres();
    let vulcan = initVulcan();
    let sentinel = initSentinel();
    let tension = computeWorldTension(gaia, ares, vulcan);
    
    {
      gaia = gaia;
      ares = ares;
      vulcan = vulcan;
      sentinel = sentinel;
      worldTension = tension;
      tensionHistory = [];
      dominanceHistory = [];
      correctionCount = 0;
      lastCorrectionBeat = 0;
      beatNum = 0;
    }
  };

}
