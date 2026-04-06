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


// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: AutonomousWarEngine — 6 Faction Brains, Territory, Persistent War
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
// SYSTEM 1 — AUTONOMOUS WAR ENGINE (Always Running)
// ============================================================================
//
// When no human players are present, the world does not pause. The 6 factions
// fight each other continuously — AI vs AI — driven entirely by the
// NeuroEmergence Core.
//
// WHAT DRIVES IT:
//   • Each faction has a living command brain — urgency, confidence, stress,
//     fatigue running every heartbeat
//   • Factions push into enemy territory when confidence is high, retreat
//     when fatigue peaks
//   • Artillery, vehicle spawns, ambushes, flanks — all generated from
//     internal state, never scripted
//   • Territory changes persist — if Ghost Protocol takes 3 districts
//     overnight while you sleep, they still hold them when you log in
//
// BACKEND REQUIREMENTS:
//   • autonomousWarTick() — called every heartbeat, advances all 6 faction
//     brains simultaneously
//   • factionTerritoryGrid[6][100] — persistent stable var, territory state
//     survives server cycles
//   • factionBrainState[6] — each faction's urgency/confidence/stress stored
//     on-chain
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
  // CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let PI : Float = 3.14159265358979;
  
  // War constants
  let FACTION_COUNT : Nat = 6;
  let TERRITORY_GRID_SIZE : Nat = 100;
  let FATIGUE_RECOVERY_RATE : Float = 0.01;
  let STRESS_DECAY_RATE : Float = 0.005;
  let CONFIDENCE_MOMENTUM : Float = 0.02;
  let URGENCY_BASE : Float = 0.3;

  // ==========================================================================
  // FACTION DEFINITIONS
  // ==========================================================================
  
  public type FactionId = {
    #GhostProtocol;       // Stealth, infiltration, sabotage
    #IronLegion;          // Heavy armor, direct assault
    #ShadowVanguard;      // Fast strikes, guerrilla warfare
    #CrimsonOrder;        // Religious zealots, suicide tactics
    #TechnoCore;          // Drones, automation, cyber warfare
    #WildHunt;            // Tribal, beast riders, nature warfare
  };

  public func factionToNat(f: FactionId) : Nat {
    switch (f) {
      case (#GhostProtocol) { 0 };
      case (#IronLegion) { 1 };
      case (#ShadowVanguard) { 2 };
      case (#CrimsonOrder) { 3 };
      case (#TechnoCore) { 4 };
      case (#WildHunt) { 5 };
    }
  };

  public func natToFaction(n: Nat) : FactionId {
    switch (n % 6) {
      case 0 { #GhostProtocol };
      case 1 { #IronLegion };
      case 2 { #ShadowVanguard };
      case 3 { #CrimsonOrder };
      case 4 { #TechnoCore };
      case _ { #WildHunt };
    }
  };

  // ==========================================================================
  // FACTION BRAIN STATE
  // ==========================================================================
  // Each faction has a living command brain with emotional/cognitive state
  
  public type FactionBrainState = {
    factionId           : FactionId;
    
    // Core cognitive state
    urgency             : Float;        // 0-1: pressure to act NOW
    confidence          : Float;        // 0-1: belief in victory
    stress              : Float;        // 0-1: accumulated pressure
    fatigue             : Float;        // 0-1: exhaustion level
    
    // Strategic state
    aggression          : Float;        // 0-1: willingness to attack
    defensiveness       : Float;        // 0-1: focus on defense
    opportunism         : Float;        // 0-1: willingness to exploit weakness
    
    // Emotional state
    rage                : Float;        // Builds from losses
    fear                : Float;        // From enemy strength
    pride               : Float;        // From victories
    desperation         : Float;        // When losing badly
    
    // Resource awareness
    manpower            : Float;        // Available troops (0-1 normalized)
    supplies            : Float;        // Logistics capacity
    morale              : Float;        // Troop willingness to fight
    
    // Combat metrics
    recentVictories     : Nat;
    recentDefeats       : Nat;
    killsThisCycle      : Nat;
    lossesThisCycle     : Nat;
    
    // Territory
    territoriesHeld     : Nat;
    territoriesLost     : Nat;          // This cycle
    territoriesGained   : Nat;          // This cycle
    
    // Strategic memory
    lastMajorAction     : Nat;          // Beat of last major offensive
    consecutiveDefenses : Nat;          // How long on defense
    
    beatNum             : Nat;
  };

  // ==========================================================================
  // TERRITORY SYSTEM
  // ==========================================================================
  
  public type TerritoryState = {
    territoryId         : Nat;
    position            : (Nat, Nat);   // Grid position
    controller          : ?FactionId;   // Who owns it (null = contested/neutral)
    controlStrength     : Float;        // How firmly controlled (0-1)
    
    // Strategic value
    resourceValue       : Float;        // Economic importance
    militaryValue       : Float;        // Strategic importance
    populationValue     : Float;        // Civilian density
    
    // Combat state
    isContested         : Bool;         // Active fighting here
    attackingFaction    : ?FactionId;
    defenseStrength     : Float;
    attackStrength      : Float;
    
    // Infrastructure
    fortificationLevel  : Float;        // Defensive structures
    supplyLineIntact    : Bool;
    
    // History
    lastChangeOfControl : Nat;          // Beat when ownership changed
    timesContestedTotal : Nat;
  };

  // ==========================================================================
  // MILITARY UNITS
  // ==========================================================================
  
  public type UnitType = {
    #Infantry;
    #Armor;
    #Artillery;
    #Aircraft;
    #SpecOps;
    #Drone;
    #Beast;              // WildHunt specific
    #Zealot;             // CrimsonOrder specific
  };

  public type MilitaryUnit = {
    unitId              : Nat;
    unitType            : UnitType;
    faction             : FactionId;
    position            : (Float, Float);
    strength            : Float;        // Combat power
    health              : Float;        // Damage taken
    morale              : Float;        // Will to fight
    fatigue             : Float;
    
    // Orders
    currentOrder        : UnitOrder;
    targetPosition      : ?(Float, Float);
    targetUnit          : ?Nat;
    
    // State
    isEngaged           : Bool;         // In combat
    isRetreating        : Bool;
    isAmbushing         : Bool;
  };

  public type UnitOrder = {
    #Hold;
    #Advance;
    #Attack;
    #Defend;
    #Retreat;
    #Flank;
    #Ambush;
    #Support;
  };

  // ==========================================================================
  // BATTLE STATE
  // ==========================================================================
  
  public type BattleState = {
    battleId            : Nat;
    location            : (Float, Float);
    territoryId         : Nat;
    
    // Combatants
    attackingFaction    : FactionId;
    defendingFaction    : FactionId;
    attackerStrength    : Float;
    defenderStrength    : Float;
    
    // Progress
    battlePhase         : BattlePhase;
    cyclesActive        : Nat;
    momentum            : Float;        // Positive = attacker winning
    
    // Casualties
    attackerLosses      : Float;
    defenderLosses      : Float;
    
    // Outcome
    isResolved          : Bool;
    outcome             : ?BattleOutcome;
  };

  public type BattlePhase = {
    #Opening;           // Initial engagement
    #Pitched;           // Full combat
    #Decisive;          // One side breaking
    #Rout;              // Loser fleeing
    #Siege;             // Prolonged standoff
  };

  public type BattleOutcome = {
    #AttackerVictory;
    #DefenderVictory;
    #Stalemate;
    #MutualWithdrawal;
  };

  // ==========================================================================
  // FACTION BRAIN TICK
  // ==========================================================================
  // The core AI that drives each faction's decisions
  
  public func tickFactionBrain(
    brain: FactionBrainState,
    territories: [TerritoryState],
    enemyBrains: [FactionBrainState],
    activeBattles: [BattleState]
  ) : FactionBrainState {
    let factionIdx = factionToNat(brain.factionId);
    
    // 1. Update fatigue (recovers over time, increases with action)
    let fatigueRecovery = FATIGUE_RECOVERY_RATE * (1.0 - brain.stress);
    let fatigueIncrease = Float.fromInt(brain.killsThisCycle + brain.lossesThisCycle) * 0.001;
    let newFatigue = clamp(brain.fatigue - fatigueRecovery + fatigueIncrease, 0.0, 1.0);
    
    // 2. Update stress (from losses and enemy pressure)
    let stressFromLosses = Float.fromInt(brain.lossesThisCycle) * 0.01;
    let stressFromTerritory = Float.fromInt(brain.territoriesLost) * 0.05;
    let stressDecay = STRESS_DECAY_RATE;
    let newStress = clamp(brain.stress + stressFromLosses + stressFromTerritory - stressDecay, 0.0, 1.0);
    
    // 3. Update confidence (from victories and territory)
    let confidenceFromVictories = Float.fromInt(brain.recentVictories) * 0.03;
    let confidenceLoss = Float.fromInt(brain.recentDefeats) * 0.05;
    let territoryRatio = Float.fromInt(brain.territoriesHeld) / Float.fromInt(TERRITORY_GRID_SIZE / FACTION_COUNT);
    let newConfidence = clamp(
      brain.confidence + confidenceFromVictories - confidenceLoss + (territoryRatio - 1.0) * 0.01,
      0.0, 1.0
    );
    
    // 4. Update urgency (pressure to act)
    let threatLevel = computeThreatLevel(brain.factionId, territories, enemyBrains);
    let opportunityLevel = computeOpportunityLevel(brain.factionId, territories, enemyBrains);
    let newUrgency = clamp(
      URGENCY_BASE + threatLevel * 0.3 + opportunityLevel * 0.2 - newFatigue * 0.2,
      0.0, 1.0
    );
    
    // 5. Update aggression (willingness to attack)
    let newAggression = if (newConfidence > 0.6 and newFatigue < 0.5) {
      clamp(brain.aggression + CONFIDENCE_MOMENTUM, 0.0, 1.0)
    } else if (newConfidence < 0.3) {
      clamp(brain.aggression - CONFIDENCE_MOMENTUM * 2.0, 0.0, 1.0)
    } else {
      brain.aggression
    };
    
    // 6. Update defensiveness (inverse of aggression when stressed)
    let newDefensiveness = clamp(
      brain.defensiveness + newStress * 0.02 - newConfidence * 0.01,
      0.0, 1.0
    );
    
    // 7. Update emotional states
    let newRage = clamp(
      brain.rage + Float.fromInt(brain.lossesThisCycle) * 0.02 - 0.005,
      0.0, 1.0
    );
    let newFear = clamp(
      brain.fear + threatLevel * 0.01 - newConfidence * 0.02,
      0.0, 1.0
    );
    let newPride = clamp(
      brain.pride + Float.fromInt(brain.recentVictories) * 0.02 - 0.003,
      0.0, 1.0
    );
    let newDesperation = if (brain.territoriesHeld < 5) {
      clamp(brain.desperation + 0.02, 0.0, 1.0)
    } else {
      clamp(brain.desperation - 0.01, 0.0, 1.0)
    };
    
    // 8. Update morale
    let moraleDelta = (newConfidence - newStress) * 0.01 + 
                      (newPride - newFear) * 0.005;
    let newMorale = clamp(brain.morale + moraleDelta, 0.0, 1.0);
    
    // 9. Update opportunism
    let newOpportunism = clamp(
      brain.opportunism + opportunityLevel * 0.01 - newFatigue * 0.005,
      0.0, 1.0
    );
    
    {
      factionId = brain.factionId;
      urgency = newUrgency;
      confidence = newConfidence;
      stress = newStress;
      fatigue = newFatigue;
      aggression = newAggression;
      defensiveness = newDefensiveness;
      opportunism = newOpportunism;
      rage = newRage;
      fear = newFear;
      pride = newPride;
      desperation = newDesperation;
      manpower = brain.manpower;
      supplies = brain.supplies;
      morale = newMorale;
      recentVictories = 0;        // Reset each cycle
      recentDefeats = 0;
      killsThisCycle = 0;
      lossesThisCycle = 0;
      territoriesHeld = brain.territoriesHeld;
      territoriesLost = 0;
      territoriesGained = 0;
      lastMajorAction = brain.lastMajorAction;
      consecutiveDefenses = if (newDefensiveness > newAggression) { 
        brain.consecutiveDefenses + 1 
      } else { 0 };
      beatNum = brain.beatNum + 1;
    }
  };

  func computeThreatLevel(
    faction: FactionId,
    territories: [TerritoryState],
    enemies: [FactionBrainState]
  ) : Float {
    var threat : Float = 0.0;
    let fIdx = factionToNat(faction);
    
    // Threat from enemy aggression
    for (enemy in enemies.vals()) {
      if (factionToNat(enemy.factionId) != fIdx) {
        threat += enemy.aggression * 0.1;
      };
    };
    
    // Threat from contested territories
    for (t in territories.vals()) {
      switch (t.controller) {
        case (?ctrl) {
          if (ctrl == faction and t.isContested) {
            threat += 0.05;
          };
        };
        case null {};
      };
    };
    
    clamp(threat, 0.0, 1.0)
  };

  func computeOpportunityLevel(
    faction: FactionId,
    territories: [TerritoryState],
    enemies: [FactionBrainState]
  ) : Float {
    var opportunity : Float = 0.0;
    let fIdx = factionToNat(faction);
    
    // Opportunity from weak enemies
    for (enemy in enemies.vals()) {
      if (factionToNat(enemy.factionId) != fIdx) {
        if (enemy.fatigue > 0.7 or enemy.stress > 0.7) {
          opportunity += 0.15;
        };
      };
    };
    
    // Opportunity from weakly held territories
    for (t in territories.vals()) {
      switch (t.controller) {
        case (?ctrl) {
          if (ctrl != faction and t.controlStrength < 0.3) {
            opportunity += 0.02;
          };
        };
        case null { opportunity += 0.01 };  // Neutral territory
      };
    };
    
    clamp(opportunity, 0.0, 1.0)
  };

  // ==========================================================================
  // STRATEGIC DECISION MAKING
  // ==========================================================================
  
  public type StrategicDecision = {
    #LaunchOffensive : { target: Nat; force: Float };
    #Defend : { territory: Nat; reinforcement: Float };
    #Retreat : { from: Nat; to: Nat };
    #Ambush : { location: (Float, Float) };
    #Resupply;
    #Rest;
    #Hold;
  };

  public func makeStrategicDecision(
    brain: FactionBrainState,
    territories: [TerritoryState],
    units: [MilitaryUnit]
  ) : StrategicDecision {
    // Decision tree based on brain state
    
    // If desperate and low on territory, launch desperate offensive
    if (brain.desperation > 0.7 and brain.territoriesHeld < 5) {
      let target = findWeakestEnemyTerritory(brain.factionId, territories);
      return #LaunchOffensive({ target = target; force = 0.8 });
    };
    
    // If highly fatigued, rest
    if (brain.fatigue > 0.8) {
      return #Rest;
    };
    
    // If high confidence and aggression, attack
    if (brain.confidence > 0.6 and brain.aggression > 0.5 and brain.fatigue < 0.5) {
      let target = findBestOffensiveTarget(brain.factionId, territories);
      let force = brain.aggression * brain.confidence;
      return #LaunchOffensive({ target = target; force = force });
    };
    
    // If high stress, defend
    if (brain.stress > 0.6 or brain.defensiveness > 0.6) {
      let weakest = findWeakestOwnTerritory(brain.factionId, territories);
      return #Defend({ territory = weakest; reinforcement = brain.defensiveness });
    };
    
    // If high opportunism and see weakness, ambush
    if (brain.opportunism > 0.6) {
      let location = findAmbushLocation(brain.factionId, territories);
      return #Ambush({ location = location });
    };
    
    // Default: hold current positions
    #Hold
  };

  func findWeakestEnemyTerritory(faction: FactionId, territories: [TerritoryState]) : Nat {
    var weakest : Nat = 0;
    var weakestStrength : Float = 2.0;
    
    for (t in territories.vals()) {
      switch (t.controller) {
        case (?ctrl) {
          if (ctrl != faction and t.controlStrength < weakestStrength) {
            weakest := t.territoryId;
            weakestStrength := t.controlStrength;
          };
        };
        case null {};
      };
    };
    weakest
  };

  func findBestOffensiveTarget(faction: FactionId, territories: [TerritoryState]) : Nat {
    var best : Nat = 0;
    var bestScore : Float = -1.0;
    
    for (t in territories.vals()) {
      switch (t.controller) {
        case (?ctrl) {
          if (ctrl != faction) {
            // Score = value / defense strength
            let score = (t.resourceValue + t.militaryValue) / (t.defenseStrength + 0.1);
            if (score > bestScore) {
              best := t.territoryId;
              bestScore := score;
            };
          };
        };
        case null {
          // Neutral territory - easy target
          let score = t.resourceValue + t.militaryValue;
          if (score > bestScore) {
            best := t.territoryId;
            bestScore := score;
          };
        };
      };
    };
    best
  };

  func findWeakestOwnTerritory(faction: FactionId, territories: [TerritoryState]) : Nat {
    var weakest : Nat = 0;
    var weakestStrength : Float = 2.0;
    
    for (t in territories.vals()) {
      switch (t.controller) {
        case (?ctrl) {
          if (ctrl == faction and t.controlStrength < weakestStrength) {
            weakest := t.territoryId;
            weakestStrength := t.controlStrength;
          };
        };
        case null {};
      };
    };
    weakest
  };

  func findAmbushLocation(faction: FactionId, territories: [TerritoryState]) : (Float, Float) {
    // Find border between own and enemy territory
    for (t in territories.vals()) {
      switch (t.controller) {
        case (?ctrl) {
          if (ctrl == faction and t.isContested) {
            return (Float.fromInt(t.position.0), Float.fromInt(t.position.1));
          };
        };
        case null {};
      };
    };
    (50.0, 50.0)  // Default center
  };

  // ==========================================================================
  // BATTLE RESOLUTION
  // ==========================================================================
  
  public func resolveBattle(battle: BattleState) : BattleState {
    // Compute battle momentum shift
    let strengthDiff = battle.attackerStrength - battle.defenderStrength;
    let momentumShift = strengthDiff * 0.1;
    let newMomentum = clamp(battle.momentum + momentumShift, -1.0, 1.0);
    
    // Compute casualties
    let attackerCasualties = battle.defenderStrength * 0.02 * (1.0 - newMomentum);
    let defenderCasualties = battle.attackerStrength * 0.02 * (1.0 + newMomentum);
    
    let newAttackerStrength = Float.max(0.0, battle.attackerStrength - attackerCasualties);
    let newDefenderStrength = Float.max(0.0, battle.defenderStrength - defenderCasualties);
    
    // Determine phase
    let newPhase = if (battle.cyclesActive < 5) { #Opening }
                   else if (Float.abs(newMomentum) < 0.3) { #Pitched }
                   else if (Float.abs(newMomentum) > 0.7) { #Decisive }
                   else if (newAttackerStrength < 0.1 or newDefenderStrength < 0.1) { #Rout }
                   else { battle.battlePhase };
    
    // Check for resolution
    let (isResolved, outcome) = if (newAttackerStrength < 0.1) {
      (true, ?#DefenderVictory)
    } else if (newDefenderStrength < 0.1) {
      (true, ?#AttackerVictory)
    } else if (battle.cyclesActive > 100 and Float.abs(newMomentum) < 0.2) {
      (true, ?#Stalemate)
    } else {
      (false, null)
    };
    
    {
      battleId = battle.battleId;
      location = battle.location;
      territoryId = battle.territoryId;
      attackingFaction = battle.attackingFaction;
      defendingFaction = battle.defendingFaction;
      attackerStrength = newAttackerStrength;
      defenderStrength = newDefenderStrength;
      battlePhase = newPhase;
      cyclesActive = battle.cyclesActive + 1;
      momentum = newMomentum;
      attackerLosses = battle.attackerLosses + attackerCasualties;
      defenderLosses = battle.defenderLosses + defenderCasualties;
      isResolved = isResolved;
      outcome = outcome;
    }
  };

  // ==========================================================================
  // AUTONOMOUS WAR ENGINE STATE
  // ==========================================================================
  
  public type AutonomousWarState = {
    // Faction brains (6 factions)
    factionBrains       : [FactionBrainState];
    
    // Territory grid (100 territories)
    territories         : [TerritoryState];
    
    // Active battles
    activeBattles       : [BattleState];
    resolvedBattles     : [BattleState];
    
    // Military units (simplified - just counts per faction)
    factionUnitCounts   : [Nat];
    
    // Global war state
    warIntensity        : Float;        // 0-1: how hot is the war
    dominantFaction     : ?FactionId;
    
    // History
    territoryChanges    : Nat;          // Total changes this session
    totalBattles        : Nat;
    
    // Timing
    lastMajorBattle     : Nat;
    peaceCycles         : Nat;          // Cycles without major action
    
    beatNum             : Nat;
  };

  // ==========================================================================
  // MAIN AUTONOMOUS WAR TICK
  // ==========================================================================
  // Called every heartbeat - advances ALL 6 faction brains simultaneously
  
  public func autonomousWarTick(state: AutonomousWarState) : AutonomousWarState {
    // 1. Tick all faction brains
    var newBrains : [FactionBrainState] = [];
    for (brain in state.factionBrains.vals()) {
      let otherBrains = Array.filter<FactionBrainState>(state.factionBrains, func(b) {
        factionToNat(b.factionId) != factionToNat(brain.factionId)
      });
      let updatedBrain = tickFactionBrain(brain, state.territories, otherBrains, state.activeBattles);
      newBrains := Array.append(newBrains, [updatedBrain]);
    };
    
    // 2. Make strategic decisions for each faction
    var newBattles : [BattleState] = [];
    var territoryUpdates : [(Nat, TerritoryState)] = [];
    
    for (brain in newBrains.vals()) {
      let decision = makeStrategicDecision(brain, state.territories, []);
      
      switch (decision) {
        case (#LaunchOffensive({ target; force })) {
          // Create new battle if not already one there
          let alreadyBattle = Array.find<BattleState>(state.activeBattles, func(b) {
            b.territoryId == target
          });
          switch (alreadyBattle) {
            case null {
              let territory = state.territories[target % state.territories.size()];
              switch (territory.controller) {
                case (?defender) {
                  if (defender != brain.factionId) {
                    let newBattle : BattleState = {
                      battleId = state.totalBattles + newBattles.size();
                      location = (Float.fromInt(territory.position.0), Float.fromInt(territory.position.1));
                      territoryId = target;
                      attackingFaction = brain.factionId;
                      defendingFaction = defender;
                      attackerStrength = force * brain.manpower;
                      defenderStrength = territory.defenseStrength;
                      battlePhase = #Opening;
                      cyclesActive = 0;
                      momentum = 0.0;
                      attackerLosses = 0.0;
                      defenderLosses = 0.0;
                      isResolved = false;
                      outcome = null;
                    };
                    newBattles := Array.append(newBattles, [newBattle]);
                  };
                };
                case null {
                  // Neutral territory - just take it
                  let updatedTerritory = { territory with 
                    controller = ?brain.factionId;
                    controlStrength = force;
                  };
                  territoryUpdates := Array.append(territoryUpdates, [(target, updatedTerritory)]);
                };
              };
            };
            case (?_) {};  // Already a battle there
          };
        };
        case (#Defend({ territory; reinforcement })) {
          if (territory < state.territories.size()) {
            let t = state.territories[territory];
            let updated = { t with 
              defenseStrength = clamp(t.defenseStrength + reinforcement * 0.1, 0.0, 1.0);
              fortificationLevel = clamp(t.fortificationLevel + 0.01, 0.0, 1.0);
            };
            territoryUpdates := Array.append(territoryUpdates, [(territory, updated)]);
          };
        };
        case _ {};
      };
    };
    
    // 3. Resolve active battles
    var updatedBattles : [BattleState] = [];
    var resolvedThisTick : [BattleState] = [];
    
    for (battle in state.activeBattles.vals()) {
      let resolved = resolveBattle(battle);
      if (resolved.isResolved) {
        resolvedThisTick := Array.append(resolvedThisTick, [resolved]);
        
        // Update territory ownership
        switch (resolved.outcome) {
          case (?#AttackerVictory) {
            if (resolved.territoryId < state.territories.size()) {
              let t = state.territories[resolved.territoryId];
              let updated = { t with 
                controller = ?resolved.attackingFaction;
                controlStrength = 0.5;
                isContested = false;
              };
              territoryUpdates := Array.append(territoryUpdates, [(resolved.territoryId, updated)]);
            };
          };
          case (?#DefenderVictory) {
            if (resolved.territoryId < state.territories.size()) {
              let t = state.territories[resolved.territoryId];
              let updated = { t with 
                isContested = false;
                controlStrength = clamp(t.controlStrength + 0.2, 0.0, 1.0);
              };
              territoryUpdates := Array.append(territoryUpdates, [(resolved.territoryId, updated)]);
            };
          };
          case _ {};
        };
      } else {
        updatedBattles := Array.append(updatedBattles, [resolved]);
      };
    };
    
    // Add new battles
    updatedBattles := Array.append(updatedBattles, newBattles);
    
    // 4. Apply territory updates
    var newTerritories = Array.thaw<TerritoryState>(state.territories);
    for ((idx, updated) in territoryUpdates.vals()) {
      if (idx < state.territories.size()) {
        newTerritories[idx] := updated;
      };
    };
    
    // 5. Compute war intensity
    let battleIntensity = Float.fromInt(updatedBattles.size()) / 10.0;
    var totalAggression : Float = 0.0;
    for (brain in newBrains.vals()) {
      totalAggression += brain.aggression;
    };
    let avgAggression = totalAggression / Float.fromInt(FACTION_COUNT);
    let newWarIntensity = clamp((battleIntensity + avgAggression) / 2.0, 0.0, 1.0);
    
    // 6. Find dominant faction
    var maxTerritories : Nat = 0;
    var dominant : ?FactionId = null;
    for (brain in newBrains.vals()) {
      if (brain.territoriesHeld > maxTerritories) {
        maxTerritories := brain.territoriesHeld;
        dominant := ?brain.factionId;
      };
    };
    
    // 7. Update peace cycles
    let newPeaceCycles = if (updatedBattles.size() == 0) {
      state.peaceCycles + 1
    } else { 0 };
    
    {
      factionBrains = newBrains;
      territories = Array.freeze(newTerritories);
      activeBattles = updatedBattles;
      resolvedBattles = Array.append(state.resolvedBattles, resolvedThisTick);
      factionUnitCounts = state.factionUnitCounts;
      warIntensity = newWarIntensity;
      dominantFaction = dominant;
      territoryChanges = state.territoryChanges + territoryUpdates.size();
      totalBattles = state.totalBattles + newBattles.size();
      lastMajorBattle = if (newBattles.size() > 0) { state.beatNum + 1 } else { state.lastMajorBattle };
      peaceCycles = newPeaceCycles;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // FACTION-SPECIFIC TRAITS
  // ==========================================================================
  
  public type FactionTraits = {
    stealthBonus        : Float;        // GhostProtocol
    armorBonus          : Float;        // IronLegion
    speedBonus          : Float;        // ShadowVanguard
    zealotryBonus       : Float;        // CrimsonOrder
    techBonus           : Float;        // TechnoCore
    beastBonus          : Float;        // WildHunt
  };

  public func getFactionTraits(faction: FactionId) : FactionTraits {
    switch (faction) {
      case (#GhostProtocol) {
        { stealthBonus = 0.5; armorBonus = 0.0; speedBonus = 0.2; zealotryBonus = 0.0; techBonus = 0.3; beastBonus = 0.0 }
      };
      case (#IronLegion) {
        { stealthBonus = 0.0; armorBonus = 0.6; speedBonus = 0.0; zealotryBonus = 0.1; techBonus = 0.2; beastBonus = 0.0 }
      };
      case (#ShadowVanguard) {
        { stealthBonus = 0.3; armorBonus = 0.0; speedBonus = 0.5; zealotryBonus = 0.0; techBonus = 0.1; beastBonus = 0.0 }
      };
      case (#CrimsonOrder) {
        { stealthBonus = 0.0; armorBonus = 0.1; speedBonus = 0.1; zealotryBonus = 0.7; techBonus = 0.0; beastBonus = 0.0 }
      };
      case (#TechnoCore) {
        { stealthBonus = 0.1; armorBonus = 0.2; speedBonus = 0.2; zealotryBonus = 0.0; techBonus = 0.6; beastBonus = 0.0 }
      };
      case (#WildHunt) {
        { stealthBonus = 0.2; armorBonus = 0.0; speedBonus = 0.3; zealotryBonus = 0.1; techBonus = 0.0; beastBonus = 0.5 }
      };
    }
  };

  // ==========================================================================
  // UTILITY FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initFactionBrain(faction: FactionId) : FactionBrainState {
    {
      factionId = faction;
      urgency = URGENCY_BASE;
      confidence = 0.5;
      stress = 0.0;
      fatigue = 0.0;
      aggression = 0.3;
      defensiveness = 0.3;
      opportunism = 0.3;
      rage = 0.0;
      fear = 0.0;
      pride = 0.0;
      desperation = 0.0;
      manpower = 0.7;
      supplies = 0.7;
      morale = 0.7;
      recentVictories = 0;
      recentDefeats = 0;
      killsThisCycle = 0;
      lossesThisCycle = 0;
      territoriesHeld = TERRITORY_GRID_SIZE / FACTION_COUNT;
      territoriesLost = 0;
      territoriesGained = 0;
      lastMajorAction = 0;
      consecutiveDefenses = 0;
      beatNum = 0;
    }
  };

  public func initTerritory(id: Nat) : TerritoryState {
    let x = id % 10;
    let y = id / 10;
    let initialController = if (id < TERRITORY_GRID_SIZE / FACTION_COUNT) { ?#GhostProtocol }
                            else if (id < 2 * TERRITORY_GRID_SIZE / FACTION_COUNT) { ?#IronLegion }
                            else if (id < 3 * TERRITORY_GRID_SIZE / FACTION_COUNT) { ?#ShadowVanguard }
                            else if (id < 4 * TERRITORY_GRID_SIZE / FACTION_COUNT) { ?#CrimsonOrder }
                            else if (id < 5 * TERRITORY_GRID_SIZE / FACTION_COUNT) { ?#TechnoCore }
                            else { ?#WildHunt };
    {
      territoryId = id;
      position = (x, y);
      controller = initialController;
      controlStrength = 0.7;
      resourceValue = Float.fromInt((id * 7) % 10) / 10.0;
      militaryValue = Float.fromInt((id * 13) % 10) / 10.0;
      populationValue = Float.fromInt((id * 17) % 10) / 10.0;
      isContested = false;
      attackingFaction = null;
      defenseStrength = 0.5;
      attackStrength = 0.0;
      fortificationLevel = 0.3;
      supplyLineIntact = true;
      lastChangeOfControl = 0;
      timesContestedTotal = 0;
    }
  };

  public func initAutonomousWar() : AutonomousWarState {
    let brains = [
      initFactionBrain(#GhostProtocol),
      initFactionBrain(#IronLegion),
      initFactionBrain(#ShadowVanguard),
      initFactionBrain(#CrimsonOrder),
      initFactionBrain(#TechnoCore),
      initFactionBrain(#WildHunt)
    ];
    
    let territories = Array.tabulate<TerritoryState>(TERRITORY_GRID_SIZE, func(i) {
      initTerritory(i)
    });
    
    {
      factionBrains = brains;
      territories = territories;
      activeBattles = [];
      resolvedBattles = [];
      factionUnitCounts = [100, 100, 100, 100, 100, 100];
      warIntensity = 0.3;
      dominantFaction = null;
      territoryChanges = 0;
      totalBattles = 0;
      lastMajorBattle = 0;
      peaceCycles = 0;
      beatNum = 0;
    }
  };

  // ============================================================
  // FACTION DOCTRINE — UNIQUE AI BEHAVIORS PER FACTION
  // Each faction has distinct tactics, strengths, weaknesses
  // ============================================================

  public type FactionDoctrine = {
    factionId        : FactionId;
    
    // Combat preferences
    preferredRange   : Float;     // Optimal engagement distance
    aggressionBias   : Float;     // How likely to attack vs defend
    flankerPref      : Float;     // Preference for flanking maneuvers
    directAssaultPref: Float;     // Preference for frontal attacks
    ambushPref       : Float;     // Preference for ambushes
    siegePref        : Float;     // Preference for siege warfare
    
    // Unit composition preferences
    infantryRatio    : Float;     // Preferred infantry percentage
    vehicleRatio     : Float;     // Preferred vehicle percentage
    artilleryRatio   : Float;     // Preferred artillery percentage
    airRatio         : Float;     // Preferred air unit percentage
    specialOpsRatio  : Float;     // Preferred special ops percentage
    
    // Economic priorities
    resourcePriority : Float;     // How much to prioritize resource territories
    militaryPriority : Float;     // How much to prioritize military territories
    populationPriority : Float;   // How much to prioritize population centers
    
    // Tactical modifiers
    retreatThreshold : Float;     // When to retreat (morale level)
    pursuitAggression: Float;     // How aggressively to pursue retreating enemies
    fortificationRate: Float;     // How fast to build fortifications
    
    // Special abilities
    stealthBonus     : Float;     // Bonus to stealth operations
    armorBonus       : Float;     // Bonus to armor effectiveness
    speedBonus       : Float;     // Bonus to movement speed
    moraleBonus      : Float;     // Bonus to morale
    accuracyBonus    : Float;     // Bonus to accuracy
  };

  // Get doctrine for each faction
  public func getFactionDoctrine(faction : FactionId) : FactionDoctrine {
    switch (faction) {
      case (#GhostProtocol) {
        // Stealth, infiltration, sabotage
        {
          factionId = #GhostProtocol;
          preferredRange = 100.0;
          aggressionBias = 0.4;
          flankerPref = 0.8;
          directAssaultPref = 0.1;
          ambushPref = 0.9;
          siegePref = 0.2;
          infantryRatio = 0.5;
          vehicleRatio = 0.1;
          artilleryRatio = 0.0;
          airRatio = 0.1;
          specialOpsRatio = 0.3;
          resourcePriority = 0.6;
          militaryPriority = 0.2;
          populationPriority = 0.2;
          retreatThreshold = 0.3;
          pursuitAggression = 0.4;
          fortificationRate = 0.2;
          stealthBonus = 0.5;
          armorBonus = 0.0;
          speedBonus = 0.2;
          moraleBonus = 0.0;
          accuracyBonus = 0.3;
        }
      };
      case (#IronLegion) {
        // Heavy armor, direct assault
        {
          factionId = #IronLegion;
          preferredRange = 50.0;
          aggressionBias = 0.8;
          flankerPref = 0.2;
          directAssaultPref = 0.9;
          ambushPref = 0.1;
          siegePref = 0.7;
          infantryRatio = 0.3;
          vehicleRatio = 0.4;
          artilleryRatio = 0.2;
          airRatio = 0.0;
          specialOpsRatio = 0.1;
          resourcePriority = 0.4;
          militaryPriority = 0.5;
          populationPriority = 0.1;
          retreatThreshold = 0.2;
          pursuitAggression = 0.7;
          fortificationRate = 0.6;
          stealthBonus = 0.0;
          armorBonus = 0.5;
          speedBonus = -0.1;
          moraleBonus = 0.2;
          accuracyBonus = 0.0;
        }
      };
      case (#ShadowVanguard) {
        // Fast strikes, guerrilla warfare
        {
          factionId = #ShadowVanguard;
          preferredRange = 80.0;
          aggressionBias = 0.6;
          flankerPref = 0.7;
          directAssaultPref = 0.3;
          ambushPref = 0.6;
          siegePref = 0.1;
          infantryRatio = 0.4;
          vehicleRatio = 0.3;
          artilleryRatio = 0.0;
          airRatio = 0.2;
          specialOpsRatio = 0.1;
          resourcePriority = 0.5;
          militaryPriority = 0.3;
          populationPriority = 0.2;
          retreatThreshold = 0.4;
          pursuitAggression = 0.6;
          fortificationRate = 0.1;
          stealthBonus = 0.2;
          armorBonus = 0.0;
          speedBonus = 0.4;
          moraleBonus = 0.1;
          accuracyBonus = 0.1;
        }
      };
      case (#CrimsonOrder) {
        // Religious zealots, suicide tactics
        {
          factionId = #CrimsonOrder;
          preferredRange = 30.0;
          aggressionBias = 0.9;
          flankerPref = 0.3;
          directAssaultPref = 0.8;
          ambushPref = 0.3;
          siegePref = 0.5;
          infantryRatio = 0.6;
          vehicleRatio = 0.2;
          artilleryRatio = 0.1;
          airRatio = 0.0;
          specialOpsRatio = 0.1;
          resourcePriority = 0.2;
          militaryPriority = 0.4;
          populationPriority = 0.4;
          retreatThreshold = 0.1;
          pursuitAggression = 0.9;
          fortificationRate = 0.3;
          stealthBonus = 0.0;
          armorBonus = 0.0;
          speedBonus = 0.1;
          moraleBonus = 0.5;
          accuracyBonus = -0.1;
        }
      };
      case (#TechnoCore) {
        // Drones, automation, cyber warfare
        {
          factionId = #TechnoCore;
          preferredRange = 150.0;
          aggressionBias = 0.5;
          flankerPref = 0.4;
          directAssaultPref = 0.4;
          ambushPref = 0.4;
          siegePref = 0.4;
          infantryRatio = 0.2;
          vehicleRatio = 0.2;
          artilleryRatio = 0.2;
          airRatio = 0.3;
          specialOpsRatio = 0.1;
          resourcePriority = 0.7;
          militaryPriority = 0.2;
          populationPriority = 0.1;
          retreatThreshold = 0.4;
          pursuitAggression = 0.5;
          fortificationRate = 0.5;
          stealthBonus = 0.1;
          armorBonus = 0.1;
          speedBonus = 0.1;
          moraleBonus = 0.0;
          accuracyBonus = 0.4;
        }
      };
      case (#WildHunt) {
        // Tribal, beast riders, nature warfare
        {
          factionId = #WildHunt;
          preferredRange = 60.0;
          aggressionBias = 0.7;
          flankerPref = 0.6;
          directAssaultPref = 0.5;
          ambushPref = 0.5;
          siegePref = 0.2;
          infantryRatio = 0.5;
          vehicleRatio = 0.3;
          artilleryRatio = 0.0;
          airRatio = 0.1;
          specialOpsRatio = 0.1;
          resourcePriority = 0.4;
          militaryPriority = 0.3;
          populationPriority = 0.3;
          retreatThreshold = 0.35;
          pursuitAggression = 0.8;
          fortificationRate = 0.2;
          stealthBonus = 0.3;
          armorBonus = 0.0;
          speedBonus = 0.3;
          moraleBonus = 0.3;
          accuracyBonus = 0.0;
        }
      };
    }
  };

  // ============================================================
  // STRATEGIC AI — DECISION MAKING
  // ============================================================

  public type StrategicDecision = {
    #Attack : { target : Nat; force : Float };
    #Defend : { territory : Nat; reinforcement : Float };
    #Retreat : { from : Nat; to : Nat };
    #Flank : { target : Nat; direction : Float };
    #Ambush : { at : Nat; waitTime : Nat };
    #Siege : { target : Nat };
    #Reinforce : { territory : Nat; units : Nat };
    #BuildFortification : { at : Nat };
    #Rest : { duration : Nat };
    #Resupply;
    #NoAction;
  };

  // Evaluate territory value for a faction
  public func evaluateTerritoryValue(
    territory : TerritoryState,
    brain : FactionBrainState,
    doctrine : FactionDoctrine
  ) : Float {
    let resourceValue = territory.resourceValue * doctrine.resourcePriority;
    let militaryValue = territory.militaryValue * doctrine.militaryPriority;
    let populationValue = territory.populationValue * doctrine.populationPriority;
    
    // Bonus for adjacent territories
    let adjacencyBonus = 0.0;  // Would calculate based on neighbors
    
    // Strategic value based on position
    let positionValue = 0.5;  // Center territories are more valuable
    
    resourceValue + militaryValue + populationValue + adjacencyBonus + positionValue
  };

  // Decide strategic action for a faction
  public func decideStrategicAction(
    brain : FactionBrainState,
    territories : [TerritoryState],
    doctrine : FactionDoctrine
  ) : StrategicDecision {
    // High fatigue → rest
    if (brain.fatigue > 0.8) {
      return #Rest({ duration = 10 });
    };
    
    // Low supplies → resupply
    if (brain.supplies < 0.3) {
      return #Resupply;
    };
    
    // High desperation → aggressive attack
    if (brain.desperation > 0.7 and brain.confidence > 0.3) {
      // Find enemy territory to attack
      var bestTarget : Nat = 0;
      var bestValue : Float = 0.0;
      var i = 0;
      for (t in territories.vals()) {
        switch (t.controller) {
          case (?ctrl) {
            if (factionToNat(ctrl) != factionToNat(brain.factionId)) {
              let value = evaluateTerritoryValue(t, brain, doctrine);
              if (value > bestValue) {
                bestValue := value;
                bestTarget := i;
              };
            };
          };
          case null {};
        };
        i += 1;
      };
      return #Attack({ target = bestTarget; force = 0.8 });
    };
    
    // High confidence + high aggression → attack
    if (brain.confidence > 0.7 and brain.aggression > 0.6) {
      // Find weak enemy territory
      var bestTarget : Nat = 0;
      var weakestDefense : Float = 10.0;
      var i = 0;
      for (t in territories.vals()) {
        switch (t.controller) {
          case (?ctrl) {
            if (factionToNat(ctrl) != factionToNat(brain.factionId)) {
              if (t.defenseStrength < weakestDefense) {
                weakestDefense := t.defenseStrength;
                bestTarget := i;
              };
            };
          };
          case null {};
        };
        i += 1;
      };
      return #Attack({ target = bestTarget; force = brain.confidence * 0.7 });
    };
    
    // High fear or low morale → defend
    if (brain.fear > 0.6 or brain.morale < 0.4) {
      // Find weakest own territory
      var weakestOwn : Nat = 0;
      var weakestDef : Float = 10.0;
      var i = 0;
      for (t in territories.vals()) {
        switch (t.controller) {
          case (?ctrl) {
            if (factionToNat(ctrl) == factionToNat(brain.factionId)) {
              if (t.defenseStrength < weakestDef) {
                weakestDef := t.defenseStrength;
                weakestOwn := i;
              };
            };
          };
          case null {};
        };
        i += 1;
      };
      return #Defend({ territory = weakestOwn; reinforcement = 0.5 });
    };
    
    // Opportunism check — look for easy targets
    if (brain.opportunism > 0.5) {
      var bestOpportunity : Nat = 0;
      var bestRatio : Float = 0.0;
      var i = 0;
      for (t in territories.vals()) {
        switch (t.controller) {
          case (?ctrl) {
            if (factionToNat(ctrl) != factionToNat(brain.factionId)) {
              let ratio = t.resourceValue / (t.defenseStrength + 0.1);
              if (ratio > bestRatio) {
                bestRatio := ratio;
                bestOpportunity := i;
              };
            };
          };
          case null {};
        };
        i += 1;
      };
      if (bestRatio > 1.0) {
        return #Attack({ target = bestOpportunity; force = 0.5 });
      };
    };
    
    #NoAction
  };

  // ============================================================
  // BATTLE RESOLUTION — COMBAT MATHEMATICS
  // ============================================================

  // Lanchester's laws for combat modeling
  // Linear law: dA/dt = -k_B × B (attrition proportional to enemy strength)
  // Square law: dA/dt = -k_B × B / A (modern combat)
  
  public func lanchesterLinear(
    attackerStrength : Float,
    defenderStrength : Float,
    attackerEfficiency : Float,
    defenderEfficiency : Float,
    dt : Float
  ) : (Float, Float) {
    let attackerLosses = defenderEfficiency * defenderStrength * dt;
    let defenderLosses = attackerEfficiency * attackerStrength * dt;
    
    (Float.max(0.0, attackerStrength - attackerLosses),
     Float.max(0.0, defenderStrength - defenderLosses))
  };

  public func lanchesterSquare(
    attackerStrength : Float,
    defenderStrength : Float,
    attackerEfficiency : Float,
    defenderEfficiency : Float,
    dt : Float
  ) : (Float, Float) {
    // dA/dt = -k_B × B² / (A + ε)
    let attackerLosses = defenderEfficiency * defenderStrength * defenderStrength / (attackerStrength + 0.01) * dt;
    let defenderLosses = attackerEfficiency * attackerStrength * attackerStrength / (defenderStrength + 0.01) * dt;
    
    (Float.max(0.0, attackerStrength - attackerLosses),
     Float.max(0.0, defenderStrength - defenderLosses))
  };

  // Resolve a single battle tick
  public func resolveBattleTick(battle : BattleState, dt : Float) : BattleState {
    // Get doctrines
    let attackerDoctrine = getFactionDoctrine(battle.attackerFaction);
    let defenderDoctrine = getFactionDoctrine(battle.defenderFaction);
    
    // Calculate efficiencies
    let attackerEfficiency = 0.1 * (1.0 + attackerDoctrine.accuracyBonus) * (1.0 + battle.attackerMorale * 0.5);
    let defenderEfficiency = 0.1 * (1.0 + defenderDoctrine.accuracyBonus + defenderDoctrine.armorBonus) * (1.0 + battle.defenderMorale * 0.5);
    
    // Apply terrain modifier
    let terrainMod = 1.0 + battle.terrainAdvantage * 0.3;
    
    // Resolve combat using Lanchester's square law
    let (newAttackerStrength, newDefenderStrength) = lanchesterSquare(
      battle.attackerStrength,
      battle.defenderStrength,
      attackerEfficiency,
      defenderEfficiency * terrainMod,
      dt
    );
    
    // Calculate casualties
    let attackerCasualties = battle.attackerStrength - newAttackerStrength;
    let defenderCasualties = battle.defenderStrength - newDefenderStrength;
    
    // Update morale based on casualties
    let attackerMoraleChange = -attackerCasualties / (battle.attackerStrength + 0.01) * 0.5 + 
                               defenderCasualties / (battle.defenderStrength + 0.01) * 0.3;
    let defenderMoraleChange = -defenderCasualties / (battle.defenderStrength + 0.01) * 0.5 +
                               attackerCasualties / (battle.attackerStrength + 0.01) * 0.3;
    
    let newAttackerMorale = Float.max(0.0, Float.min(1.0, battle.attackerMorale + attackerMoraleChange));
    let newDefenderMorale = Float.max(0.0, Float.min(1.0, battle.defenderMorale + defenderMoraleChange));
    
    // Check for battle end
    let isResolved = newAttackerStrength < 0.1 or newDefenderStrength < 0.1 or
                     newAttackerMorale < attackerDoctrine.retreatThreshold or
                     newDefenderMorale < defenderDoctrine.retreatThreshold;
    
    let winner = if (not isResolved) { null }
                 else if (newAttackerStrength > newDefenderStrength) { ?battle.attackerFaction }
                 else { ?battle.defenderFaction };
    
    {
      battle with
      attackerStrength = newAttackerStrength;
      defenderStrength = newDefenderStrength;
      attackerMorale = newAttackerMorale;
      defenderMorale = newDefenderMorale;
      attackerCasualties = battle.attackerCasualties + Nat.max(0, Float.toInt(Float.ceil(attackerCasualties)));
      defenderCasualties = battle.defenderCasualties + Nat.max(0, Float.toInt(Float.ceil(defenderCasualties)));
      duration = battle.duration + 1;
      isResolved = isResolved;
      winner = winner;
    }
  };

  // ============================================================
  // FACTION RELATIONSHIPS — DIPLOMACY
  // ============================================================

  public type DiplomaticRelation = {
    faction1     : FactionId;
    faction2     : FactionId;
    hostility    : Float;       // [0, 1] — 0 = friendly, 1 = war
    trustLevel   : Float;       // [0, 1]
    tradeActive  : Bool;
    nonAggressionPact : Bool;
    alliance     : Bool;
    warDeclared  : Bool;
    lastInteraction : Nat;
  };

  // 6×6 relationship matrix (15 unique pairs)
  public type DiplomacyState = {
    relations : [DiplomaticRelation];
    totalWars : Nat;
    totalAlliances : Nat;
    peaceTreaties : Nat;
  };

  // Initialize diplomacy between all factions
  public func initDiplomacy() : DiplomacyState {
    var relations = Buffer.Buffer<DiplomaticRelation>(15);
    
    // Create all unique pairs
    let factions = [#GhostProtocol, #IronLegion, #ShadowVanguard, #CrimsonOrder, #TechnoCore, #WildHunt];
    var i = 0;
    while (i < 6) {
      var j = i + 1;
      while (j < 6) {
        relations.add({
          faction1 = factions[i];
          faction2 = factions[j];
          hostility = 0.5;
          trustLevel = 0.3;
          tradeActive = false;
          nonAggressionPact = false;
          alliance = false;
          warDeclared = true;  // All at war by default
          lastInteraction = 0;
        });
        j += 1;
      };
      i += 1;
    };
    
    {
      relations = Buffer.toArray(relations);
      totalWars = 15;
      totalAlliances = 0;
      peaceTreaties = 0;
    }
  };

  // Update hostility based on combat and territory changes
  public func updateHostility(
    relation : DiplomaticRelation,
    combatIntensity : Float,
    territoryLost : Bool
  ) : DiplomaticRelation {
    var newHostility = relation.hostility;
    
    // Combat increases hostility
    newHostility += combatIntensity * 0.1;
    
    // Territory loss increases hostility significantly
    if (territoryLost) {
      newHostility += 0.2;
    };
    
    // Natural decay toward neutral
    newHostility := newHostility * 0.99;
    
    {
      relation with
      hostility = Float.max(0.0, Float.min(1.0, newHostility));
    }
  };

  // ============================================================
  // SUPPLY LINES AND LOGISTICS
  // ============================================================

  public type SupplyLine = {
    fromTerritory : Nat;
    toTerritory   : Nat;
    capacity      : Float;      // Units per beat
    currentFlow   : Float;
    isIntact      : Bool;
    threatLevel   : Float;      // Risk of interdiction
    length        : Nat;        // Path length in territories
    controller    : FactionId;
  };

  public type LogisticsState = {
    supplyLines      : [SupplyLine];
    totalSupplyFlow  : Float;
    interdictedLines : Nat;
    supplyEfficiency : Float;   // [0, 1]
  };

  // Calculate supply efficiency for a faction
  public func calculateSupplyEfficiency(
    lines : [SupplyLine],
    faction : FactionId
  ) : Float {
    var totalCapacity : Float = 0.0;
    var totalFlow : Float = 0.0;
    
    for (line in lines.vals()) {
      if (factionToNat(line.controller) == factionToNat(faction)) {
        totalCapacity += line.capacity;
        if (line.isIntact) {
          totalFlow += line.currentFlow;
        };
      };
    };
    
    if (totalCapacity < 0.01) { return 1.0 };
    totalFlow / totalCapacity
  };

  // ============================================================
  // FOG OF WAR — INFORMATION WARFARE
  // ============================================================

  public type IntelligenceReport = {
    aboutFaction : FactionId;
    reportingFaction : FactionId;
    estimatedStrength : Float;
    estimatedPosition : ?(Nat, Nat);
    confidence : Float;         // [0, 1] — how reliable
    age : Nat;                  // Beats since gathered
    source : IntelSource;
  };

  public type IntelSource = {
    #Scout;
    #Spy;
    #Satellite;
    #Intercept;
    #Defector;
    #Rumor;
  };

  public type FogOfWarState = {
    knownTerritories : [Bool];  // Which territories are visible
    lastSeen : [Nat];           // When each territory was last seen
    intelReports : [IntelligenceReport];
    intelAccuracy : Float;      // Overall intelligence quality
  };

  // Decay intelligence over time
  public func decayIntelligence(intel : IntelligenceReport, currentBeat : Nat) : IntelligenceReport {
    let age = currentBeat - intel.age;
    let decayFactor = Float.exp(-Float.fromInt(age) / 100.0);
    
    {
      intel with
      confidence = intel.confidence * decayFactor;
      age = age;
    }
  };

  // ============================================================
  // TERRAIN EFFECTS ON COMBAT
  // ============================================================

  public type TerrainEffect = {
    defenseBonus    : Float;
    movementPenalty : Float;
    coverBonus      : Float;
    visibilityMod   : Float;
    supplyPenalty   : Float;
  };

  public func getTerrainEffects(terrainType : Nat) : TerrainEffect {
    // 0 = plains, 1 = forest, 2 = mountain, 3 = urban, 4 = water, 5 = desert
    switch (terrainType % 6) {
      case 0 { { defenseBonus = 0.0; movementPenalty = 0.0; coverBonus = 0.1; visibilityMod = 1.0; supplyPenalty = 0.0 } };
      case 1 { { defenseBonus = 0.3; movementPenalty = 0.2; coverBonus = 0.5; visibilityMod = 0.5; supplyPenalty = 0.1 } };
      case 2 { { defenseBonus = 0.5; movementPenalty = 0.4; coverBonus = 0.6; visibilityMod = 0.7; supplyPenalty = 0.3 } };
      case 3 { { defenseBonus = 0.4; movementPenalty = 0.1; coverBonus = 0.7; visibilityMod = 0.3; supplyPenalty = 0.0 } };
      case 4 { { defenseBonus = 0.0; movementPenalty = 0.9; coverBonus = 0.0; visibilityMod = 1.0; supplyPenalty = 0.5 } };
      case _ { { defenseBonus = 0.0; movementPenalty = 0.1; coverBonus = 0.1; visibilityMod = 1.0; supplyPenalty = 0.0 } };
    }
  };

  // ============================================================
  // REINFORCEMENT AND UNIT PRODUCTION
  // ============================================================

  public type ProductionQueue = {
    factionId    : FactionId;
    queuedUnits  : [UnitOrder];
    totalCost    : Float;
    productionRate : Float;    // Units per beat
    resources    : Float;      // Available resources
  };

  public type UnitOrder = {
    unitType     : Nat;        // Type of unit to produce
    quantity     : Nat;
    priority     : Nat;
    turnsRemaining : Nat;
    destination  : Nat;        // Territory to deploy to
  };

  // Process production queue
  public func processProduction(queue : ProductionQueue, beat : Nat) : ProductionQueue {
    var remainingResources = queue.resources;
    var processed = Buffer.Buffer<UnitOrder>(queue.queuedUnits.size());
    
    for (order in queue.queuedUnits.vals()) {
      if (order.turnsRemaining > 0) {
        let costPerTurn = 10.0;  // Base cost
        if (remainingResources >= costPerTurn) {
          remainingResources -= costPerTurn;
          processed.add({ order with turnsRemaining = order.turnsRemaining - 1 });
        } else {
          processed.add(order);
        };
      };
    };
    
    {
      queue with
      queuedUnits = Buffer.toArray(processed);
      resources = remainingResources;
    }
  };

  // ============================================================
  // FULL WAR TICK — AUTONOMOUS UPDATE
  // ============================================================

  public func autonomousWarTick(state : AutonomousWarState) : AutonomousWarState {
    var newBrains = Array.thaw<FactionBrainState>(state.factionBrains);
    var newTerritories = Array.thaw<TerritoryState>(state.territories);
    var newBattles = Buffer.Buffer<BattleState>(state.activeBattles.size());
    
    // Update each faction's brain
    var factionIdx = 0;
    while (factionIdx < FACTION_COUNT) {
      let brain = state.factionBrains[factionIdx];
      let doctrine = getFactionDoctrine(brain.factionId);
      
      // Fatigue recovery
      let newFatigue = Float.max(0.0, brain.fatigue - FATIGUE_RECOVERY_RATE);
      
      // Stress decay
      let newStress = Float.max(0.0, brain.stress - STRESS_DECAY_RATE);
      
      // Update morale based on recent events
      let moraleChange = Float.fromInt(brain.recentVictories) * 0.05 - Float.fromInt(brain.recentDefeats) * 0.08;
      let newMorale = Float.max(0.1, Float.min(1.0, brain.morale + moraleChange));
      
      // Update confidence based on territory
      let territoryRatio = Float.fromInt(brain.territoriesHeld) / Float.fromInt(TERRITORY_GRID_SIZE);
      let newConfidence = territoryRatio * 0.5 + brain.morale * 0.3 + (1.0 - brain.fatigue) * 0.2;
      
      newBrains[factionIdx] := {
        brain with
        fatigue = newFatigue;
        stress = newStress;
        morale = newMorale;
        confidence = newConfidence;
        beatNum = state.beatNum + 1;
      };
      
      factionIdx += 1;
    };
    
    // Resolve active battles
    for (battle in state.activeBattles.vals()) {
      let resolved = resolveBattleTick(battle, 1.0);
      if (not resolved.isResolved) {
        newBattles.add(resolved);
      };
      // If resolved, update territory control
    };
    
    // Update war intensity
    let newIntensity = Float.fromInt(newBattles.size()) / 10.0;
    
    {
      state with
      factionBrains = Array.freeze(newBrains);
      territories = Array.freeze(newTerritories);
      activeBattles = Buffer.toArray(newBattles);
      warIntensity = Float.max(0.0, Float.min(1.0, newIntensity));
      beatNum = state.beatNum + 1;
    }
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
