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

}
