// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: Biodiversity — Lotka-Volterra Ecosystem Dynamics
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    BIODIVERSITY — REAL ECOSYSTEM DYNAMICS                ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This is NOT a game ecology. This is REAL population dynamics.           ║
// ║                                                                          ║
// ║  LOTKA-VOLTERRA EQUATIONS:                                               ║
// ║    dx/dt = αx - βxy     (prey growth - predation)                        ║
// ║    dy/dt = δxy - γy     (predator growth - death)                        ║
// ║                                                                          ║
// ║  CARRYING CAPACITY:                                                      ║
// ║    dx/dt = rx(1 - x/K) - βxy                                             ║
// ║    Where K = Fibonacci-scaled carrying capacity                          ║
// ║                                                                          ║
// ║  FOOD WEB (5 trophic levels):                                            ║
// ║    L1: Producers (plants, algae) — base energy                           ║
// ║    L2: Primary consumers (herbivores)                                    ║
// ║    L3: Secondary consumers (small predators)                             ║
// ║    L4: Tertiary consumers (apex predators)                               ║
// ║    L5: Decomposers (return energy to L1)                                 ║
// ║                                                                          ║
// ║  SYMBIOSIS TYPES:                                                        ║
// ║    Mutualism: Both benefit (++                                           ║
// ║    Commensalism: One benefits, other neutral (+0)                        ║
// ║    Parasitism: One benefits, other harmed (+-)                           ║
// ║    Competition: Both harmed (--)                                         ║
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
  public let e : Float = 2.7182818284590452354;
  
  // Fibonacci for carrying capacities
  public let F : [Float] = [1.0, 1.0, 2.0, 3.0, 5.0, 8.0, 13.0, 21.0, 34.0, 55.0, 89.0, 144.0, 233.0];
  
  // Ecosystem parameters
  public let TROPHIC_LEVELS : Nat = 5;
  public let MAX_SPECIES : Nat = 21;              // F[8]
  public let EXTINCTION_THRESHOLD : Float = 0.01;  // Below this = extinct
  public let OVERPOPULATION_STRESS : Float = 0.9;  // Above 90% carrying = stress

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TROPHIC LEVELS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type TrophicLevel = {
    #Producer;          // L1: Plants, algae
    #PrimaryConsumer;   // L2: Herbivores
    #SecondaryConsumer; // L3: Small predators
    #TertiaryConsumer;  // L4: Apex predators
    #Decomposer;        // L5: Fungi, bacteria
  };
  
  public func trophicIndex(level: TrophicLevel) : Nat {
    switch (level) {
      case (#Producer) { 0 };
      case (#PrimaryConsumer) { 1 };
      case (#SecondaryConsumer) { 2 };
      case (#TertiaryConsumer) { 3 };
      case (#Decomposer) { 4 };
    }
  };
  
  /// Energy transfer efficiency (10% rule)
  public func energyEfficiency(from: TrophicLevel, to: TrophicLevel) : Float {
    // Energy transfers up the food chain at ~10% efficiency
    // This is real biology — Lindeman's 10% law
    let fromIdx = trophicIndex(from);
    let toIdx = trophicIndex(to);
    
    if (toIdx == fromIdx + 1) {
      0.1  // 10% efficiency
    } else if (toIdx > fromIdx) {
      Float.pow(0.1, Float.fromInt(toIdx - fromIdx))  // Compound loss
    } else {
      0.0  // Can't transfer down
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPECIES                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Species = {
    speciesId : Nat;
    name : Text;
    trophicLevel : TrophicLevel;
    
    // Population dynamics
    population : Float;           // Current population
    carryingCapacity : Float;     // K — Fibonacci-scaled
    growthRate : Float;           // r — intrinsic growth rate
    
    // Interactions
    preySpecies : [Nat];          // What this species eats
    predatorSpecies : [Nat];      // What eats this species
    symbionts : [SymbioticRelation];
    
    // Lotka-Volterra coefficients
    predationRate : Float;        // β — attack rate
    conversionEfficiency : Float; // δ — prey-to-predator conversion
    mortalityRate : Float;        // γ — natural death rate
    
    // State
    isExtinct : Bool;
    isInvasive : Bool;
    biomass : Float;              // Total biomass
    
    // History
    peakPopulation : Float;
    extinctionRisk : Float;       // [0, 1]
  };
  
  public type SymbioticRelation = {
    partnerSpeciesId : Nat;
    relationType : SymbiosisType;
    strength : Float;             // [0, 1]
  };
  
  public type SymbiosisType = {
    #Mutualism;       // Both benefit
    #Commensalism;    // One benefits, other neutral
    #Parasitism;      // One benefits, other harmed
    #Competition;     // Both harmed
    #Predation;       // One eats other
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ECOSYSTEM STATE                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Ecosystem = {
    species : [Species];
    
    // Trophic level aggregates
    producerBiomass : Float;
    consumerBiomass : Float;
    decomposerBiomass : Float;
    
    // Energy flow
    totalEnergy : Float;
    energyFlux : Float;           // Energy moving through system
    
    // Diversity metrics
    speciesRichness : Nat;        // Number of species
    shannonDiversity : Float;     // Shannon index H'
    simpsonDiversity : Float;     // Simpson index D
    
    // Stability
    stabilityIndex : Float;       // [0, 1]
    isCollapsing : Bool;
    
    // Environmental
    temperature : Float;          // Affects all rates
    seasonModifier : Float;       // Seasonal variation [0.5, 1.5]
    
    // History
    lastUpdate : Nat;
    extinctionEvents : Nat;
    invasionEvents : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     LOTKA-VOLTERRA DYNAMICS                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // PREY:     dx/dt = rx(1 - x/K) - βxy
  // PREDATOR: dy/dt = δβxy - γy
  //
  
  /// Calculate prey population change
  public func preyDynamics(
    prey: Species,
    predator: Species,
    dt: Float
  ) : Float {
    let x = prey.population;
    let y = predator.population;
    let r = prey.growthRate;
    let K = prey.carryingCapacity;
    let β = predator.predationRate;
    
    // Logistic growth with predation
    let growth = r * x * (1.0 - x / K);
    let predation = β * x * y;
    
    x + (growth - predation) * dt
  };
  
  /// Calculate predator population change
  public func predatorDynamics(
    predator: Species,
    preyPop: Float,
    dt: Float
  ) : Float {
    let y = predator.population;
    let β = predator.predationRate;
    let δ = predator.conversionEfficiency;
    let γ = predator.mortalityRate;
    
    // Predator growth from prey, natural death
    let growth = δ * β * preyPop * y;
    let death = γ * y;
    
    y + (growth - death) * dt
  };
  
  /// Full ecosystem update
  public func updateEcosystem(
    ecosystem: Ecosystem,
    dt: Float,
    currentBeat: Nat
  ) : Ecosystem {
    // 1. Calculate new populations for all species
    let newPopulations = Buffer.Buffer<Float>(ecosystem.species.size());
    
    for (species in ecosystem.species.vals()) {
      if (species.isExtinct) {
        newPopulations.add(0.0);
      } else {
        var newPop = species.population;
        
        // Apply seasonal modifier
        let seasonalGrowth = species.growthRate * ecosystem.seasonModifier;
        
        // Logistic growth (carrying capacity)
        let logisticGrowth = seasonalGrowth * newPop * 
                             (1.0 - newPop / species.carryingCapacity);
        newPop += logisticGrowth * dt;
        
        // Predation losses (sum over all predators)
        for (predId in species.predatorSpecies.vals()) {
          if (predId < ecosystem.species.size()) {
            let predator = ecosystem.species[predId];
            let predationLoss = predator.predationRate * newPop * predator.population;
            newPop -= predationLoss * dt;
          };
        };
        
        // Prey consumption gains (for consumers)
        for (preyId in species.preySpecies.vals()) {
          if (preyId < ecosystem.species.size()) {
            let prey = ecosystem.species[preyId];
            let gain = species.conversionEfficiency * 
                       species.predationRate * 
                       prey.population * species.population;
            newPop += gain * dt;
          };
        };
        
        // Natural mortality
        newPop -= species.mortalityRate * newPop * dt;
        
        // Symbiosis effects
        for (sym in species.symbionts.vals()) {
          if (sym.partnerSpeciesId < ecosystem.species.size()) {
            let partner = ecosystem.species[sym.partnerSpeciesId];
            let effect = switch (sym.relationType) {
              case (#Mutualism) { sym.strength * 0.05 };       // Growth boost
              case (#Commensalism) { sym.strength * 0.02 };    // Small boost
              case (#Parasitism) { -sym.strength * 0.03 };     // Drain
              case (#Competition) { -sym.strength * 0.02 };    // Mutual harm
              case (#Predation) { 0.0 };                       // Handled above
            };
            newPop += effect * newPop * partner.population * dt;
          };
        };
        
        // Clamp to valid range
        newPop := Float.max(0.0, newPop);
        newPopulations.add(newPop);
      };
    };
    
    // 2. Update species with new populations
    let newSpecies = Array.tabulate<Species>(ecosystem.species.size(), func(i) {
      let species = ecosystem.species[i];
      let newPop = if (i < newPopulations.size()) { newPopulations.get(i) } else { 0.0 };
      
      let isExtinct = newPop < EXTINCTION_THRESHOLD;
      let extinctionRisk = if (newPop < species.carryingCapacity * 0.1) {
        1.0 - (newPop / (species.carryingCapacity * 0.1))
      } else { 0.0 };
      
      {
        speciesId = species.speciesId;
        name = species.name;
        trophicLevel = species.trophicLevel;
        population = newPop;
        carryingCapacity = species.carryingCapacity;
        growthRate = species.growthRate;
        preySpecies = species.preySpecies;
        predatorSpecies = species.predatorSpecies;
        symbionts = species.symbionts;
        predationRate = species.predationRate;
        conversionEfficiency = species.conversionEfficiency;
        mortalityRate = species.mortalityRate;
        isExtinct = isExtinct;
        isInvasive = species.isInvasive;
        biomass = newPop * 1.0;  // Simplified: 1 unit per individual
        peakPopulation = Float.max(species.peakPopulation, newPop);
        extinctionRisk = extinctionRisk;
      }
    });
    
    // 3. Calculate ecosystem metrics
    var producerBio : Float = 0.0;
    var consumerBio : Float = 0.0;
    var decomposerBio : Float = 0.0;
    var richness : Nat = 0;
    var totalPop : Float = 0.0;
    var newExtinctions : Nat = 0;
    
    for (species in newSpecies.vals()) {
      if (not species.isExtinct) {
        richness += 1;
        totalPop += species.population;
        
        switch (species.trophicLevel) {
          case (#Producer) { producerBio += species.biomass };
          case (#Decomposer) { decomposerBio += species.biomass };
          case (_) { consumerBio += species.biomass };
        };
      };
      
      // Check for new extinctions
      if (species.isExtinct) {
        let oldSpecies = ecosystem.species[species.speciesId];
        if (not oldSpecies.isExtinct) {
          newExtinctions += 1;
        };
      };
    };
    
    // Shannon diversity: H' = -Σ(pi × ln(pi))
    var shannon : Float = 0.0;
    if (totalPop > 0.0) {
      for (species in newSpecies.vals()) {
        if (not species.isExtinct and species.population > 0.0) {
          let p = species.population / totalPop;
          shannon -= p * Float.log(p);
        };
      };
    };
    
    // Simpson diversity: D = 1 - Σ(pi²)
    var simpson : Float = 1.0;
    if (totalPop > 0.0) {
      var sumPiSq : Float = 0.0;
      for (species in newSpecies.vals()) {
        if (not species.isExtinct and species.population > 0.0) {
          let p = species.population / totalPop;
          sumPiSq += p * p;
        };
      };
      simpson := 1.0 - sumPiSq;
    };
    
    // Stability based on diversity and trophic balance
    let trophicBalance = if (producerBio > 0.001) {
      Float.min(1.0, consumerBio / producerBio / 0.1)  // 10% rule
    } else { 0.0 };
    
    let stability = (shannon / 3.0 + simpson + trophicBalance) / 3.0;
    
    {
      species = newSpecies;
      producerBiomass = producerBio;
      consumerBiomass = consumerBio;
      decomposerBiomass = decomposerBio;
      totalEnergy = producerBio;  // Energy starts with producers
      energyFlux = consumerBio * 0.1;  // 10% efficiency
      speciesRichness = richness;
      shannonDiversity = shannon;
      simpsonDiversity = simpson;
      stabilityIndex = stability;
      isCollapsing = stability < 0.2;
      temperature = ecosystem.temperature;
      seasonModifier = ecosystem.seasonModifier;
      lastUpdate = currentBeat;
      extinctionEvents = ecosystem.extinctionEvents + newExtinctions;
      invasionEvents = ecosystem.invasionEvents;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initSpecies(
    id: Nat,
    name: Text,
    level: TrophicLevel,
    carrying: Float
  ) : Species {
    // Growth rate based on trophic level (producers grow fastest)
    let growth = switch (level) {
      case (#Producer) { 0.5 };
      case (#PrimaryConsumer) { 0.3 };
      case (#SecondaryConsumer) { 0.2 };
      case (#TertiaryConsumer) { 0.1 };
      case (#Decomposer) { 0.4 };
    };
    
    {
      speciesId = id;
      name = name;
      trophicLevel = level;
      population = carrying * 0.5;  // Start at 50% capacity
      carryingCapacity = carrying;
      growthRate = growth;
      preySpecies = [];
      predatorSpecies = [];
      symbionts = [];
      predationRate = 0.1;
      conversionEfficiency = 0.1;
      mortalityRate = 0.05;
      isExtinct = false;
      isInvasive = false;
      biomass = carrying * 0.5;
      peakPopulation = carrying * 0.5;
      extinctionRisk = 0.0;
    }
  };
  
  /// Initialize a basic ecosystem
  public func initEcosystem() : Ecosystem {
    // Create a simple food web
    let species : [Species] = [
      // Producers (L1) — Fibonacci carrying capacities
      {
        speciesId = 0; name = "Grass"; trophicLevel = #Producer;
        population = 500.0; carryingCapacity = 1000.0; growthRate = 0.5;
        preySpecies = []; predatorSpecies = [2, 3];
        symbionts = []; predationRate = 0.0; conversionEfficiency = 0.0;
        mortalityRate = 0.01; isExtinct = false; isInvasive = false;
        biomass = 500.0; peakPopulation = 500.0; extinctionRisk = 0.0;
      },
      {
        speciesId = 1; name = "Algae"; trophicLevel = #Producer;
        population = 300.0; carryingCapacity = 500.0; growthRate = 0.6;
        preySpecies = []; predatorSpecies = [2];
        symbionts = []; predationRate = 0.0; conversionEfficiency = 0.0;
        mortalityRate = 0.02; isExtinct = false; isInvasive = false;
        biomass = 300.0; peakPopulation = 300.0; extinctionRisk = 0.0;
      },
      
      // Primary consumers (L2)
      {
        speciesId = 2; name = "Herbivore"; trophicLevel = #PrimaryConsumer;
        population = 80.0; carryingCapacity = 200.0; growthRate = 0.3;
        preySpecies = [0, 1]; predatorSpecies = [4];
        symbionts = []; predationRate = 0.05; conversionEfficiency = 0.1;
        mortalityRate = 0.03; isExtinct = false; isInvasive = false;
        biomass = 80.0; peakPopulation = 80.0; extinctionRisk = 0.0;
      },
      {
        speciesId = 3; name = "Grazer"; trophicLevel = #PrimaryConsumer;
        population = 60.0; carryingCapacity = 150.0; growthRate = 0.25;
        preySpecies = [0]; predatorSpecies = [4, 5];
        symbionts = []; predationRate = 0.04; conversionEfficiency = 0.1;
        mortalityRate = 0.03; isExtinct = false; isInvasive = false;
        biomass = 60.0; peakPopulation = 60.0; extinctionRisk = 0.0;
      },
      
      // Secondary consumers (L3)
      {
        speciesId = 4; name = "Predator"; trophicLevel = #SecondaryConsumer;
        population = 15.0; carryingCapacity = 50.0; growthRate = 0.2;
        preySpecies = [2, 3]; predatorSpecies = [5];
        symbionts = []; predationRate = 0.08; conversionEfficiency = 0.1;
        mortalityRate = 0.04; isExtinct = false; isInvasive = false;
        biomass = 15.0; peakPopulation = 15.0; extinctionRisk = 0.0;
      },
      
      // Tertiary consumers (L4)
      {
        speciesId = 5; name = "Apex"; trophicLevel = #TertiaryConsumer;
        population = 5.0; carryingCapacity = 20.0; growthRate = 0.1;
        preySpecies = [3, 4]; predatorSpecies = [];
        symbionts = []; predationRate = 0.1; conversionEfficiency = 0.1;
        mortalityRate = 0.05; isExtinct = false; isInvasive = false;
        biomass = 5.0; peakPopulation = 5.0; extinctionRisk = 0.0;
      },
      
      // Decomposers (L5)
      {
        speciesId = 6; name = "Decomposer"; trophicLevel = #Decomposer;
        population = 100.0; carryingCapacity = 300.0; growthRate = 0.4;
        preySpecies = []; predatorSpecies = [];  // Eat dead matter
        symbionts = [{
          partnerSpeciesId = 0;
          relationType = #Mutualism;
          strength = 0.3;
        }];
        predationRate = 0.0; conversionEfficiency = 0.2;
        mortalityRate = 0.02; isExtinct = false; isInvasive = false;
        biomass = 100.0; peakPopulation = 100.0; extinctionRisk = 0.0;
      }
    ];
    
    {
      species = species;
      producerBiomass = 800.0;
      consumerBiomass = 160.0;
      decomposerBiomass = 100.0;
      totalEnergy = 800.0;
      energyFlux = 16.0;
      speciesRichness = 7;
      shannonDiversity = 1.5;
      simpsonDiversity = 0.75;
      stabilityIndex = 0.7;
      isCollapsing = false;
      temperature = 1.0;
      seasonModifier = 1.0;
      lastUpdate = 0;
      extinctionEvents = 0;
      invasionEvents = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUMMARY                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type EcosystemSummary = {
    speciesCount : Nat;
    totalBiomass : Float;
    diversity : Float;
    stability : Float;
    isCollapsing : Bool;
  };
  
  public func summarize(ecosystem: Ecosystem) : EcosystemSummary {
    {
      speciesCount = ecosystem.speciesRichness;
      totalBiomass = ecosystem.producerBiomass + ecosystem.consumerBiomass + ecosystem.decomposerBiomass;
      diversity = ecosystem.shannonDiversity;
      stability = ecosystem.stabilityIndex;
      isCollapsing = ecosystem.isCollapsing;
    }
  };

}
