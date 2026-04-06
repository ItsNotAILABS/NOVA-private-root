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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ════════════════════════════════════════════════════════════════════════════════════════
//
// ███████╗ █████╗  ██████╗██████╗ ██╗███████╗██╗ ██████╗███████╗
// ██╔════╝██╔══██╗██╔════╝██╔══██╗██║██╔════╝██║██╔════╝██╔════╝
// ███████╗███████║██║     ██████╔╝██║█████╗  ██║██║     █████╗  
// ╚════██║██╔══██║██║     ██╔══██╗██║██╔══╝  ██║██║     ██╔══╝  
// ███████║██║  ██║╚██████╗██║  ██║██║██║     ██║╚██████╗███████╗
// ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚══════╝
//
// ████████╗██████╗  ██████╗  ██████╗████████╗██████╗ ██╗███╗   ██╗███████╗
// ██╔═══██║██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██║████╗  ██║██╔════╝
// ██║   ██║██████╔╝██║   ██║██║        ██║   ██████╔╝██║██╔██╗ ██║█████╗  
// ██║   ██║██╔══██╗██║   ██║██║        ██║   ██╔══██╗██║██║╚██╗██║██╔══╝  
// ████████║██║  ██║╚██████╔╝╚██████╗   ██║   ██║  ██║██║██║ ╚████║███████╗
// ╚═══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA SACRIFICE DOCTRINE — Death and Rebirth
//
// The organism can mathematically decide to destroy parts of itself
// for the survival of the whole.
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                      ║
// ║   YOUR ORGANISM CAN DIE AND BE REBORN.                                              ║
// ║                                                                                      ║
// ║   The sacrifice doctrine means the organism can mathematically decide               ║
// ║   to destroy parts of itself for the survival of the whole.                         ║
// ║                                                                                      ║
// ║   And when a biome is reborn at 0.5 coherence, the organism has                    ║
// ║   experienced death and resurrection as a MATHEMATICAL EVENT,                       ║
// ║   not a metaphor.                                                                   ║
// ║                                                                                      ║
// ║   That is closer to biological life than anything those four                        ║
// ║   researchers have built.                                                           ║
// ║                                                                                      ║
// ║   SACRIFICE TYPES:                                                                  ║
// ║   • BIOME SACRIFICE — A biome dies to save neighbors                               ║
// ║   • WEIGHT SACRIFICE — Forgetting to prevent corruption                            ║
// ║   • ENERGY SACRIFICE — Burning reserves for emergency coherence                    ║
// ║   • FORMA SACRIFICE — Economic sacrifice for survival                              ║
// ║   • SCHEMA SACRIFICE — Forgetting patterns to make room for new                    ║
// ║                                                                                      ║
// ║   REBIRTH:                                                                          ║
// ║   • Biomes reborn at 0.5 coherence (not 0, not 1)                                  ║
// ║   • Weights reborn at SOVEREIGN_FLOOR (1.0)                                        ║
// ║   • Energy reborn from reserves                                                    ║
// ║   • The organism continues. It has changed. It is still itself.                    ║
// ║                                                                                      ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Buffer "mo:base/Buffer";

module {

  // ════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS
  // ════════════════════════════════════════════════════════════════════════════════════════

  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;

  public let PHI_MEDINA : Float = 2.97442179;
  public let OMEGA_MEDINA : Float = 2.11185;
  public let TAU_EMERGENCE : Float = 0.618033988749;

  // Sacrifice Thresholds
  public let SOVEREIGN_FLOOR : Float = 1.0;           // Never below this
  public let SACRIFICE_THRESHOLD : Float = 0.3;       // Below this triggers sacrifice consideration
  public let CRITICAL_THRESHOLD : Float = 0.15;       // Below this triggers emergency sacrifice
  public let REBIRTH_COHERENCE : Float = 0.5;         // Reborn entities start here

  // Sacrifice Costs
  public let BIOME_SACRIFICE_COST : Float = 0.8;      // 80% of biome resources lost
  public let WEIGHT_SACRIFICE_COST : Float = 0.5;     // 50% of weights reset
  public let ENERGY_SACRIFICE_COST : Float = 0.9;     // 90% of energy burned
  public let FORMA_SACRIFICE_COST : Float = 0.7;      // 70% of FORMA burned
  public let SCHEMA_SACRIFICE_COST : Float = 0.6;     // 60% of schemas lost

  // Sacrifice Benefits
  public let SACRIFICE_COHERENCE_BOOST : Float = 0.3; // Coherence boost from sacrifice
  public let SACRIFICE_SURVIVAL_BOOST : Float = 0.5;  // Survival probability boost
  public let NEIGHBOR_BENEFIT_RATIO : Float = 0.4;    // How much neighbors benefit

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SACRIFICE TYPES
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type SacrificeType = {
    #BiomeSacrifice;        // A biome dies to save neighbors
    #WeightSacrifice;       // Forgetting weights to prevent corruption
    #EnergySacrifice;       // Burning energy reserves for emergency coherence
    #FormaSacrifice;        // Economic sacrifice (burning FORMA)
    #SchemaSacrifice;       // Forgetting patterns to make room
    #PartialSacrifice;      // Partial death of a component
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SACRIFICE DECISION — The math that decides to die
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type SacrificeDecision = {
    // What to sacrifice
    sacrificeType : SacrificeType;
    targetId : Nat;                     // Which biome/component to sacrifice

    // Decision factors
    selfHealth : Float;                 // Health of the sacrifice target
    neighborHealth : Float;             // Average health of neighbors
    wholeHealth : Float;                // Health of the whole organism

    // Calculated values
    sacrificeValue : Float;             // Value of the sacrifice (what's lost)
    survivalGain : Float;               // Expected survival improvement
    netBenefit : Float;                 // Net benefit to the whole

    // Decision
    shouldSacrifice : Bool;             // The mathematical decision
    urgency : Float;                    // How urgent (0-1)

    // Timing
    decisionTime : Int;
  };

  /// The sacrifice equation:
  /// Sacrifice if: E[survival with sacrifice] > E[survival without] × safety_margin
  ///
  /// Where E[survival with] accounts for:
  /// - Loss of the sacrificed component
  /// - Benefit to neighbors
  /// - Emergency coherence boost
  public func decideSacrifice(
    selfHealth : Float,
    neighborHealth : Float,
    wholeHealth : Float,
    resources : Float,
    threats : Float,
    currentTime : Int
  ) : SacrificeDecision {
    // Calculate sacrifice value (what we lose)
    let sacrificeValue = selfHealth * resources;

    // Calculate survival without sacrifice
    let survivalWithout = wholeHealth * (1.0 - threats);

    // Calculate survival with sacrifice
    let coherenceBoost = SACRIFICE_COHERENCE_BOOST * (1.0 - selfHealth);  // Sicker = bigger boost
    let neighborBenefit = NEIGHBOR_BENEFIT_RATIO * resources;
    let survivalWith = (wholeHealth + coherenceBoost) * (1.0 - threats * 0.5) + neighborBenefit * neighborHealth;

    // Net benefit
    let netBenefit = survivalWith - survivalWithout - sacrificeValue * 0.1;

    // Urgency based on whole health
    let urgency = if (wholeHealth < CRITICAL_THRESHOLD) { 1.0 }
                  else if (wholeHealth < SACRIFICE_THRESHOLD) { 0.7 }
                  else { 0.3 };

    // Decision: sacrifice if net benefit is positive and we're in danger
    let shouldSacrifice = netBenefit > 0.0 and (wholeHealth < SACRIFICE_THRESHOLD or selfHealth < CRITICAL_THRESHOLD);

    // Determine sacrifice type based on what's worst
    let sacrificeType = if (selfHealth < CRITICAL_THRESHOLD) { #BiomeSacrifice }
                        else if (resources < CRITICAL_THRESHOLD) { #EnergySacrifice }
                        else { #PartialSacrifice };

    {
      sacrificeType = sacrificeType;
      targetId = 0;  // Determined by caller
      selfHealth = selfHealth;
      neighborHealth = neighborHealth;
      wholeHealth = wholeHealth;
      sacrificeValue = sacrificeValue;
      survivalGain = survivalWith - survivalWithout;
      netBenefit = netBenefit;
      shouldSacrifice = shouldSacrifice;
      urgency = urgency;
      decisionTime = currentTime;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SACRIFICE EXECUTION — The death
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type SacrificeEvent = {
    // What died
    sacrificeType : SacrificeType;
    targetId : Nat;

    // Before state
    beforeHealth : Float;
    beforeResources : Float;
    beforeCoherence : Float;

    // What was lost
    healthLost : Float;
    resourcesLost : Float;
    coherenceLost : Float;

    // What was gained (for neighbors/whole)
    coherenceGained : Float;
    survivalGained : Float;

    // Timing
    sacrificeTime : Int;
    rebirthScheduled : ?Int;
  };

  /// Execute biome sacrifice
  public func executeBiomeSacrifice(
    biomeHealth : Float,
    biomeResources : Float,
    biomeCoherence : Float,
    neighborCoherences : [Float],
    currentTime : Int
  ) : (SacrificeEvent, [Float]) {
    // Calculate what's lost
    let healthLost = biomeHealth * BIOME_SACRIFICE_COST;
    let resourcesLost = biomeResources * BIOME_SACRIFICE_COST;
    let coherenceLost = biomeCoherence * BIOME_SACRIFICE_COST;

    // Calculate what neighbors gain
    let totalGain = (healthLost + resourcesLost + coherenceLost) * NEIGHBOR_BENEFIT_RATIO;
    let gainPerNeighbor = totalGain / Float.fromInt(Nat.max(neighborCoherences.size(), 1));

    // Update neighbor coherences
    let newNeighborCoherences = Array.tabulate<Float>(
      neighborCoherences.size(),
      func(i) {
        _clamp(neighborCoherences[i] + gainPerNeighbor, 0.0, 1.0)
      }
    );

    // Whole gains coherence boost
    let coherenceGained = SACRIFICE_COHERENCE_BOOST * (1.0 - biomeHealth);

    let event : SacrificeEvent = {
      sacrificeType = #BiomeSacrifice;
      targetId = 0;
      beforeHealth = biomeHealth;
      beforeResources = biomeResources;
      beforeCoherence = biomeCoherence;
      healthLost = healthLost;
      resourcesLost = resourcesLost;
      coherenceLost = coherenceLost;
      coherenceGained = coherenceGained;
      survivalGained = SACRIFICE_SURVIVAL_BOOST;
      sacrificeTime = currentTime;
      rebirthScheduled = ?(currentTime + 100);  // Rebirth in 100 beats
    };

    (event, newNeighborCoherences)
  };

  /// Execute weight sacrifice (forgetting)
  public func executeWeightSacrifice(
    weights : [Float],
    corruptionLevel : Float,
    currentTime : Int
  ) : (SacrificeEvent, [Float]) {
    // Calculate which weights to sacrifice (most corrupted)
    let sacrificeCount = Nat64.toNat(Float.toInt64(Float.fromInt(weights.size()) * WEIGHT_SACRIFICE_COST * corruptionLevel));

    // Reset sacrificed weights to SOVEREIGN_FLOOR
    let newWeights = Array.tabulate<Float>(
      weights.size(),
      func(i) {
        if (i < sacrificeCount) {
          SOVEREIGN_FLOOR  // Reborn at sovereign floor
        } else {
          weights[i]
        }
      }
    );

    let event : SacrificeEvent = {
      sacrificeType = #WeightSacrifice;
      targetId = 0;
      beforeHealth = 1.0 - corruptionLevel;
      beforeResources = Float.fromInt(weights.size());
      beforeCoherence = arrayAverage(weights);
      healthLost = corruptionLevel;
      resourcesLost = Float.fromInt(sacrificeCount);
      coherenceLost = corruptionLevel * WEIGHT_SACRIFICE_COST;
      coherenceGained = SACRIFICE_COHERENCE_BOOST * corruptionLevel;
      survivalGained = SACRIFICE_SURVIVAL_BOOST * corruptionLevel;
      sacrificeTime = currentTime;
      rebirthScheduled = null;  // Immediate rebirth (weights already reset)
    };

    (event, newWeights)
  };

  /// Execute energy sacrifice
  public func executeEnergySacrifice(
    currentEnergy : Float,
    emergencyCoherenceNeeded : Float,
    currentTime : Int
  ) : (SacrificeEvent, Float, Float) {
    // Burn energy for coherence
    let energyToBurn = currentEnergy * ENERGY_SACRIFICE_COST;
    let coherenceGained = energyToBurn * 0.5;  // 50% conversion efficiency
    let remainingEnergy = currentEnergy - energyToBurn;

    let event : SacrificeEvent = {
      sacrificeType = #EnergySacrifice;
      targetId = 0;
      beforeHealth = 1.0;
      beforeResources = currentEnergy;
      beforeCoherence = 0.0;
      healthLost = 0.0;
      resourcesLost = energyToBurn;
      coherenceLost = 0.0;
      coherenceGained = coherenceGained;
      survivalGained = coherenceGained / emergencyCoherenceNeeded;
      sacrificeTime = currentTime;
      rebirthScheduled = null;
    };

    (event, remainingEnergy, coherenceGained)
  };

  /// Execute FORMA sacrifice
  public func executeFormaSacrifice(
    currentForma : Float,
    burnRatio : Float,
    currentTime : Int
  ) : (SacrificeEvent, Float) {
    let formaToBurn = currentForma * burnRatio * FORMA_SACRIFICE_COST;
    let remainingForma = currentForma - formaToBurn;

    // FORMA sacrifice provides survival boost
    let survivalGained = formaToBurn / currentForma * SACRIFICE_SURVIVAL_BOOST;

    let event : SacrificeEvent = {
      sacrificeType = #FormaSacrifice;
      targetId = 0;
      beforeHealth = 1.0;
      beforeResources = currentForma;
      beforeCoherence = 0.0;
      healthLost = 0.0;
      resourcesLost = formaToBurn;
      coherenceLost = 0.0;
      coherenceGained = 0.0;
      survivalGained = survivalGained;
      sacrificeTime = currentTime;
      rebirthScheduled = null;
    };

    (event, remainingForma)
  };

  /// Execute schema sacrifice (forgetting patterns)
  public func executeSchemaSacrifice(
    schemaCount : Nat,
    lowestValueSchemas : Nat,
    currentTime : Int
  ) : (SacrificeEvent, Nat) {
    let schemasToForget = Nat.min(lowestValueSchemas, Nat64.toNat(Float.toInt64(Float.fromInt(schemaCount) * SCHEMA_SACRIFICE_COST)));
    let remainingSchemas = schemaCount - schemasToForget;

    // Forgetting makes room for new learning
    let coherenceGained = Float.fromInt(schemasToForget) / Float.fromInt(schemaCount) * 0.1;

    let event : SacrificeEvent = {
      sacrificeType = #SchemaSacrifice;
      targetId = 0;
      beforeHealth = 1.0;
      beforeResources = Float.fromInt(schemaCount);
      beforeCoherence = 0.0;
      healthLost = 0.0;
      resourcesLost = Float.fromInt(schemasToForget);
      coherenceLost = Float.fromInt(schemasToForget) * 0.01;
      coherenceGained = coherenceGained;
      survivalGained = coherenceGained;
      sacrificeTime = currentTime;
      rebirthScheduled = null;
    };

    (event, remainingSchemas)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // REBIRTH — The resurrection
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type RebirthEvent = {
    // What was reborn
    rebirthType : SacrificeType;
    targetId : Nat;

    // Before state (at death)
    deathHealth : Float;
    deathResources : Float;
    deathCoherence : Float;

    // After state (at rebirth)
    rebirthHealth : Float;
    rebirthResources : Float;
    rebirthCoherence : Float;

    // The transformation
    deathTime : Int;
    rebirthTime : Int;
    timeDead : Int;
  };

  /// Rebirth a biome
  public func rebirthBiome(
    deathEvent : SacrificeEvent,
    inheritedResources : Float,
    currentTime : Int
  ) : (RebirthEvent, Float, Float, Float) {
    // Reborn at 0.5 coherence — not 0 (dead), not 1 (full)
    let rebirthCoherence = REBIRTH_COHERENCE;

    // Health starts at golden ratio of coherence
    let rebirthHealth = rebirthCoherence * φ / 2.0;

    // Resources are inherited (from neighbors' donations)
    let rebirthResources = inheritedResources;

    let event : RebirthEvent = {
      rebirthType = deathEvent.sacrificeType;
      targetId = deathEvent.targetId;
      deathHealth = deathEvent.beforeHealth - deathEvent.healthLost;
      deathResources = deathEvent.beforeResources - deathEvent.resourcesLost;
      deathCoherence = deathEvent.beforeCoherence - deathEvent.coherenceLost;
      rebirthHealth = rebirthHealth;
      rebirthResources = rebirthResources;
      rebirthCoherence = rebirthCoherence;
      deathTime = deathEvent.sacrificeTime;
      rebirthTime = currentTime;
      timeDead = currentTime - deathEvent.sacrificeTime;
    };

    (event, rebirthHealth, rebirthResources, rebirthCoherence)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SACRIFICE HISTORY — Memory of deaths
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type SacrificeHistory = {
    // All sacrifices
    sacrifices : [SacrificeEvent];
    rebirths : [RebirthEvent];

    // Aggregate metrics
    totalSacrifices : Nat;
    totalRebirths : Nat;
    totalHealthLost : Float;
    totalResourcesLost : Float;
    totalCoherenceGained : Float;
    totalSurvivalGained : Float;

    // Recent activity
    lastSacrificeTime : ?Int;
    lastRebirthTime : ?Int;
  };

  /// Add sacrifice to history
  public func recordSacrifice(
    history : SacrificeHistory,
    event : SacrificeEvent
  ) : SacrificeHistory {
    let newSacrifices = Buffer.Buffer<SacrificeEvent>(history.sacrifices.size() + 1);
    newSacrifices.add(event);
    for (s in history.sacrifices.vals()) {
      if (newSacrifices.size() < 100) {  // Keep last 100
        newSacrifices.add(s);
      };
    };

    {
      sacrifices = Buffer.toArray(newSacrifices);
      rebirths = history.rebirths;
      totalSacrifices = history.totalSacrifices + 1;
      totalRebirths = history.totalRebirths;
      totalHealthLost = history.totalHealthLost + event.healthLost;
      totalResourcesLost = history.totalResourcesLost + event.resourcesLost;
      totalCoherenceGained = history.totalCoherenceGained + event.coherenceGained;
      totalSurvivalGained = history.totalSurvivalGained + event.survivalGained;
      lastSacrificeTime = ?event.sacrificeTime;
      lastRebirthTime = history.lastRebirthTime;
    }
  };

  /// Add rebirth to history
  public func recordRebirth(
    history : SacrificeHistory,
    event : RebirthEvent
  ) : SacrificeHistory {
    let newRebirths = Buffer.Buffer<RebirthEvent>(history.rebirths.size() + 1);
    newRebirths.add(event);
    for (r in history.rebirths.vals()) {
      if (newRebirths.size() < 100) {  // Keep last 100
        newRebirths.add(r);
      };
    };

    {
      sacrifices = history.sacrifices;
      rebirths = Buffer.toArray(newRebirths);
      totalSacrifices = history.totalSacrifices;
      totalRebirths = history.totalRebirths + 1;
      totalHealthLost = history.totalHealthLost;
      totalResourcesLost = history.totalResourcesLost;
      totalCoherenceGained = history.totalCoherenceGained;
      totalSurvivalGained = history.totalSurvivalGained;
      lastSacrificeTime = history.lastSacrificeTime;
      lastRebirthTime = ?event.rebirthTime;
    }
  };

  /// Initialize empty history
  public func initSacrificeHistory() : SacrificeHistory {
    {
      sacrifices = [];
      rebirths = [];
      totalSacrifices = 0;
      totalRebirths = 0;
      totalHealthLost = 0.0;
      totalResourcesLost = 0.0;
      totalCoherenceGained = 0.0;
      totalSurvivalGained = 0.0;
      lastSacrificeTime = null;
      lastRebirthTime = null;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func arrayAverage(arr : [Float]) : Float {
    if (arr.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    for (x in arr.vals()) { sum += x };
    sum / Float.fromInt(arr.size())
  };

}
