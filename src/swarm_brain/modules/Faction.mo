// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: Faction — 4 Factions with Trust Matrix & Alliance System
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    FACTIONS — THE FOUR POWERS                            ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  IRON_VEIL   — Industrial, defensive, methodical                         ║
// ║  EMBER_TIDE  — Aggressive, expansionist, volatile                        ║
// ║  CROWN_ORDER — Structured, governance-focused, lawful                    ║
// ║  ORIGIN_DEEP — Mysterious, adaptive, emergent                            ║
// ║                                                                          ║
// ║  TRUST MATRIX:                                                           ║
// ║    4×4 matrix where trust[i][j] = how much faction i trusts faction j    ║
// ║    Trust affects: trade, alliance, aggression thresholds                 ║
// ║                                                                          ║
// ║  ALLIANCE SYSTEM:                                                        ║
// ║    Factions can form alliances when trust > 0.7                          ║
// ║    Alliances share resources and coordinate defense                      ║
// ║    Betrayal drops trust to 0 and triggers ARES spike                     ║
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
  
  // Trust parameters
  public let ALLIANCE_THRESHOLD : Float = 0.70;
  public let HOSTILE_THRESHOLD : Float = 0.30;
  public let TRUST_DECAY : Float = 0.995;           // 0.5% decay per beat
  public let TRUST_RECOVERY : Float = 0.001;        // 0.1% recovery per beat
  
  // Betrayal impact
  public let BETRAYAL_PENALTY : Float = 0.8;        // Trust drops by 80%
  public let BETRAYAL_ARES_SPIKE : Float = 0.5;     // +50% ARES
  
  // Faction count
  public let FACTION_COUNT : Nat = 4;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FACTION IDENTITY                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type FactionId = {
    #IronVeil;
    #EmberTide;
    #CrownOrder;
    #OriginDeep;
  };
  
  public func factionIndex(faction: FactionId) : Nat {
    switch (faction) {
      case (#IronVeil) { 0 };
      case (#EmberTide) { 1 };
      case (#CrownOrder) { 2 };
      case (#OriginDeep) { 3 };
    }
  };
  
  public func factionFromIndex(index: Nat) : FactionId {
    switch (index) {
      case (0) { #IronVeil };
      case (1) { #EmberTide };
      case (2) { #CrownOrder };
      case (3) { #OriginDeep };
      case (_) { #IronVeil };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FACTION TRAITS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type FactionTraits = {
    // Core identity
    factionId : FactionId;
    name : Text;
    motto : Text;
    
    // Drive affinities (baseline multipliers for G/A/V/S/R)
    gaiaAffinity : Float;         // [0.5, 1.5]
    aresAffinity : Float;
    vulcanAffinity : Float;
    saturnAffinity : Float;
    resonexAffinity : Float;
    
    // Behavioral tendencies
    aggression : Float;           // [0, 1] tendency to attack
    expansion : Float;            // [0, 1] tendency to expand
    diplomacy : Float;            // [0, 1] tendency to ally
    adaptation : Float;           // [0, 1] ability to change
    
    // Combat modifiers
    offenseModifier : Float;      // Combat attack bonus
    defenseModifier : Float;      // Combat defense bonus
    
    // Economic modifiers
    productionModifier : Float;   // Resource production
    tradeModifier : Float;        // Trade efficiency
  };
  
  /// Get default traits for a faction
  public func getDefaultTraits(faction: FactionId) : FactionTraits {
    switch (faction) {
      case (#IronVeil) {
        {
          factionId = #IronVeil;
          name = "Iron Veil";
          motto = "Through steel, we endure";
          gaiaAffinity = 0.8;
          aresAffinity = 1.0;
          vulcanAffinity = 1.3;       // Building specialists
          saturnAffinity = 1.1;
          resonexAffinity = 0.8;
          aggression = 0.3;
          expansion = 0.5;
          diplomacy = 0.6;
          adaptation = 0.4;
          offenseModifier = 0.9;
          defenseModifier = 1.3;      // Defensive bonus
          productionModifier = 1.2;
          tradeModifier = 1.0;
        }
      };
      case (#EmberTide) {
        {
          factionId = #EmberTide;
          name = "Ember Tide";
          motto = "In fire, we forge destiny";
          gaiaAffinity = 0.7;
          aresAffinity = 1.4;         // Combat specialists
          vulcanAffinity = 0.9;
          saturnAffinity = 0.7;
          resonexAffinity = 0.9;
          aggression = 0.8;           // Very aggressive
          expansion = 0.9;            // Very expansionist
          diplomacy = 0.3;
          adaptation = 0.6;
          offenseModifier = 1.4;      // Offensive bonus
          defenseModifier = 0.8;
          productionModifier = 0.9;
          tradeModifier = 0.7;
        }
      };
      case (#CrownOrder) {
        {
          factionId = #CrownOrder;
          name = "Crown Order";
          motto = "Law above chaos";
          gaiaAffinity = 1.0;
          aresAffinity = 0.9;
          vulcanAffinity = 1.0;
          saturnAffinity = 1.4;       // Governance specialists
          resonexAffinity = 1.0;
          aggression = 0.4;
          expansion = 0.5;
          diplomacy = 0.8;            // Diplomatic
          adaptation = 0.3;
          offenseModifier = 1.0;
          defenseModifier = 1.1;
          productionModifier = 1.1;
          tradeModifier = 1.3;        // Trade bonus
        }
      };
      case (#OriginDeep) {
        {
          factionId = #OriginDeep;
          name = "Origin Deep";
          motto = "From the void, we emerge";
          gaiaAffinity = 1.1;
          aresAffinity = 0.8;
          vulcanAffinity = 0.9;
          saturnAffinity = 0.8;
          resonexAffinity = 1.5;      // Connection specialists
          aggression = 0.5;
          expansion = 0.6;
          diplomacy = 0.7;
          adaptation = 0.9;           // Highly adaptive
          offenseModifier = 1.0;
          defenseModifier = 1.0;
          productionModifier = 1.0;
          tradeModifier = 1.0;
        }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FACTION STATE                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type FactionState = {
    traits : FactionTraits;
    
    // Resources
    formaBalance : Float;
    resourceStockpile : Float;
    
    // Territory
    biomeCount : Nat;
    buildingCount : Nat;
    unitCount : Nat;
    
    // Military
    armyStrength : Float;
    warWeariness : Float;          // [0, 1] fatigue from conflict
    
    // Relations (indices into trust matrix)
    allies : [FactionId];
    enemies : [FactionId];
    
    // History
    conquests : Nat;
    defeats : Nat;
    alliancesFormed : Nat;
    betrayals : Nat;
    
    // Current activity
    isAtWar : Bool;
    warTarget : ?FactionId;
    lastAction : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TRUST MATRIX                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // 4×4 matrix where trust[i][j] = how much faction i trusts faction j
  // Diagonal is always 1.0 (factions trust themselves)
  //
  
  public type TrustMatrix = {
    values : [[Float]];           // 4×4 matrix
    lastUpdate : Nat;
  };
  
  /// Get trust between two factions
  public func getTrust(matrix: TrustMatrix, from: FactionId, to: FactionId) : Float {
    let i = factionIndex(from);
    let j = factionIndex(to);
    
    if (i < matrix.values.size() and j < matrix.values[i].size()) {
      matrix.values[i][j]
    } else {
      0.5  // Default neutral
    }
  };
  
  /// Update trust between factions
  public func updateTrust(
    matrix: TrustMatrix,
    from: FactionId,
    to: FactionId,
    delta: Float,
    currentBeat: Nat
  ) : TrustMatrix {
    let i = factionIndex(from);
    let j = factionIndex(to);
    
    let newValues = Array.tabulate<[Float]>(FACTION_COUNT, func(row) {
      Array.tabulate<Float>(FACTION_COUNT, func(col) {
        if (row == i and col == j) {
          _clamp(matrix.values[row][col] + delta, 0.0, 1.0)
        } else if (row < matrix.values.size() and col < matrix.values[row].size()) {
          matrix.values[row][col]
        } else {
          if (row == col) { 1.0 } else { 0.5 }
        }
      })
    });
    
    { values = newValues; lastUpdate = currentBeat }
  };
  
  /// Apply trust decay over time
  public func decayTrust(matrix: TrustMatrix, beats: Nat, currentBeat: Nat) : TrustMatrix {
    let decayFactor = Float.pow(TRUST_DECAY, Float.fromInt(beats));
    
    let newValues = Array.tabulate<[Float]>(FACTION_COUNT, func(row) {
      Array.tabulate<Float>(FACTION_COUNT, func(col) {
        if (row == col) {
          1.0  // Self-trust stays at 1.0
        } else {
          let current = if (row < matrix.values.size() and col < matrix.values[row].size()) {
            matrix.values[row][col]
          } else { 0.5 };
          
          // Decay toward 0.5 (neutral)
          0.5 + (current - 0.5) * decayFactor
        }
      })
    });
    
    { values = newValues; lastUpdate = currentBeat }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ALLIANCE SYSTEM                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Alliance = {
    members : [FactionId];
    formedAt : Nat;
    strength : Float;             // [0, 1] alliance cohesion
    agreements : [AllianceType];
  };
  
  public type AllianceType = {
    #DefensePact;                 // Help defend each other
    #TradeDeal;                   // Reduced trade costs
    #NonAggression;               // No attacking each other
    #MutualDefense;               // Attack one, attack all
    #ResourceSharing;             // Share production
  };
  
  /// Check if alliance is possible
  public func canFormAlliance(matrix: TrustMatrix, a: FactionId, b: FactionId) : Bool {
    let trustAtoB = getTrust(matrix, a, b);
    let trustBtoA = getTrust(matrix, b, a);
    
    trustAtoB >= ALLIANCE_THRESHOLD and trustBtoA >= ALLIANCE_THRESHOLD
  };
  
  /// Form alliance between factions
  public func formAlliance(
    factions: [FactionState],
    a: FactionId,
    b: FactionId,
    currentBeat: Nat
  ) : [FactionState] {
    Array.tabulate<FactionState>(factions.size(), func(i) {
      let faction = factions[i];
      let fid = factionFromIndex(i);
      
      if (fid == a) {
        let newAllies = Buffer.Buffer<FactionId>(faction.allies.size() + 1);
        for (ally in faction.allies.vals()) { newAllies.add(ally) };
        newAllies.add(b);
        
        {
          traits = faction.traits;
          formaBalance = faction.formaBalance;
          resourceStockpile = faction.resourceStockpile;
          biomeCount = faction.biomeCount;
          buildingCount = faction.buildingCount;
          unitCount = faction.unitCount;
          armyStrength = faction.armyStrength;
          warWeariness = faction.warWeariness;
          allies = Buffer.toArray(newAllies);
          enemies = faction.enemies;
          conquests = faction.conquests;
          defeats = faction.defeats;
          alliancesFormed = faction.alliancesFormed + 1;
          betrayals = faction.betrayals;
          isAtWar = faction.isAtWar;
          warTarget = faction.warTarget;
          lastAction = currentBeat;
        }
      } else if (fid == b) {
        let newAllies = Buffer.Buffer<FactionId>(faction.allies.size() + 1);
        for (ally in faction.allies.vals()) { newAllies.add(ally) };
        newAllies.add(a);
        
        {
          traits = faction.traits;
          formaBalance = faction.formaBalance;
          resourceStockpile = faction.resourceStockpile;
          biomeCount = faction.biomeCount;
          buildingCount = faction.buildingCount;
          unitCount = faction.unitCount;
          armyStrength = faction.armyStrength;
          warWeariness = faction.warWeariness;
          allies = Buffer.toArray(newAllies);
          enemies = faction.enemies;
          conquests = faction.conquests;
          defeats = faction.defeats;
          alliancesFormed = faction.alliancesFormed + 1;
          betrayals = faction.betrayals;
          isAtWar = faction.isAtWar;
          warTarget = faction.warTarget;
          lastAction = currentBeat;
        }
      } else {
        faction
      }
    })
  };
  
  /// Betray an ally
  public func betrayAlliance(
    matrix: TrustMatrix,
    factions: [FactionState],
    betrayer: FactionId,
    victim: FactionId,
    currentBeat: Nat
  ) : (TrustMatrix, [FactionState]) {
    // Massive trust drop
    let newMatrix = updateTrust(matrix, victim, betrayer, -BETRAYAL_PENALTY, currentBeat);
    
    // Update faction states
    let newFactions = Array.tabulate<FactionState>(factions.size(), func(i) {
      let faction = factions[i];
      let fid = factionFromIndex(i);
      
      if (fid == betrayer) {
        // Remove victim from allies, add to enemies
        let newAllies = Buffer.Buffer<FactionId>(faction.allies.size());
        for (ally in faction.allies.vals()) {
          if (ally != victim) { newAllies.add(ally) };
        };
        
        let newEnemies = Buffer.Buffer<FactionId>(faction.enemies.size() + 1);
        for (enemy in faction.enemies.vals()) { newEnemies.add(enemy) };
        newEnemies.add(victim);
        
        {
          traits = faction.traits;
          formaBalance = faction.formaBalance;
          resourceStockpile = faction.resourceStockpile;
          biomeCount = faction.biomeCount;
          buildingCount = faction.buildingCount;
          unitCount = faction.unitCount;
          armyStrength = faction.armyStrength;
          warWeariness = faction.warWeariness;
          allies = Buffer.toArray(newAllies);
          enemies = Buffer.toArray(newEnemies);
          conquests = faction.conquests;
          defeats = faction.defeats;
          alliancesFormed = faction.alliancesFormed;
          betrayals = faction.betrayals + 1;
          isAtWar = true;
          warTarget = ?victim;
          lastAction = currentBeat;
        }
      } else if (fid == victim) {
        // Remove betrayer from allies, add to enemies
        let newAllies = Buffer.Buffer<FactionId>(faction.allies.size());
        for (ally in faction.allies.vals()) {
          if (ally != betrayer) { newAllies.add(ally) };
        };
        
        let newEnemies = Buffer.Buffer<FactionId>(faction.enemies.size() + 1);
        for (enemy in faction.enemies.vals()) { newEnemies.add(enemy) };
        newEnemies.add(betrayer);
        
        {
          traits = faction.traits;
          formaBalance = faction.formaBalance;
          resourceStockpile = faction.resourceStockpile;
          biomeCount = faction.biomeCount;
          buildingCount = faction.buildingCount;
          unitCount = faction.unitCount;
          armyStrength = faction.armyStrength;
          warWeariness = faction.warWeariness;
          allies = Buffer.toArray(newAllies);
          enemies = Buffer.toArray(newEnemies);
          conquests = faction.conquests;
          defeats = faction.defeats;
          alliancesFormed = faction.alliancesFormed;
          betrayals = faction.betrayals;
          isAtWar = true;
          warTarget = ?betrayer;
          lastAction = currentBeat;
        }
      } else {
        faction
      }
    });
    
    (newMatrix, newFactions)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initFactionState(faction: FactionId) : FactionState {
    {
      traits = getDefaultTraits(faction);
      formaBalance = 100.0;
      resourceStockpile = 50.0;
      biomeCount = 0;
      buildingCount = 0;
      unitCount = 10;
      armyStrength = 1.0;
      warWeariness = 0.0;
      allies = [];
      enemies = [];
      conquests = 0;
      defeats = 0;
      alliancesFormed = 0;
      betrayals = 0;
      isAtWar = false;
      warTarget = null;
      lastAction = 0;
    }
  };
  
  public func initTrustMatrix() : TrustMatrix {
    // Start with neutral trust (0.5) between all, 1.0 for self
    let values = Array.tabulate<[Float]>(FACTION_COUNT, func(i) {
      Array.tabulate<Float>(FACTION_COUNT, func(j) {
        if (i == j) { 1.0 } else { 0.5 }
      })
    });
    
    { values = values; lastUpdate = 0 }
  };
  
  public func initAllFactions() : [FactionState] {
    [
      initFactionState(#IronVeil),
      initFactionState(#EmberTide),
      initFactionState(#CrownOrder),
      initFactionState(#OriginDeep)
    ]
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
  
  public type FactionSummary = {
    name : Text;
    biomeCount : Nat;
    armyStrength : Float;
    allyCount : Nat;
    enemyCount : Nat;
    isAtWar : Bool;
  };
  
  public func summarize(faction: FactionState) : FactionSummary {
    {
      name = faction.traits.name;
      biomeCount = faction.biomeCount;
      armyStrength = faction.armyStrength;
      allyCount = faction.allies.size();
      enemyCount = faction.enemies.size();
      isAtWar = faction.isAtWar;
    }
  };

}
