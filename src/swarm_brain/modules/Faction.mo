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
