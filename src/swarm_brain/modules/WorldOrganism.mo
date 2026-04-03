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
// Module: WorldOrganism — The Living World Architecture
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
// THE WORLD IS AN ORGANISM
// ============================================================================
//
// The simulated world is not a static backdrop. It is itself a cognitive
// entity with its own brain, its own heartbeat, and its own inner AIs
// that procedurally generate and maintain the environment.
//
// ARCHITECTURE:
//
//   ┌───────────────────────────────────────────────────────────────────┐
//   │                     WORLD ORGANISM                                │
//   │  ┌─────────────────────────────────────────────────────────────┐ │
//   │  │  WORLD BRAIN                                                 │ │
//   │  │  • Kuramoto sync for biome coordination                     │ │
//   │  │  • Hebbian learning for pattern development                 │ │
//   │  │  • World-level coherence metric                             │ │
//   │  └─────────────────────────────────────────────────────────────┘ │
//   │  ┌─────────────────────────────────────────────────────────────┐ │
//   │  │  INNER AIs (Procedural Generators)                          │ │
//   │  │  • TerrainAI — Generates and evolves terrain                │ │
//   │  │  • WeatherAI — Drives weather patterns                      │ │
//   │  │  • EcologyAI — Manages flora/fauna balance                  │ │
//   │  │  • GeologyAI — Tectonic and geological processes            │ │
//   │  │  • AtmosphereAI — Air currents, pressure systems            │ │
//   │  │  • HydrologyAI — Water cycles, rivers, oceans               │ │
//   │  └─────────────────────────────────────────────────────────────┘ │
//   │  ┌─────────────────────────────────────────────────────────────┐ │
//   │  │  BIOMES (Living Regions)                                    │ │
//   │  │  • Each biome has its own mini-brain                        │ │
//   │  │  • Biomes interact and influence each other                 │ │
//   │  │  • Emergent weather and ecology from biome interactions     │ │
//   │  └─────────────────────────────────────────────────────────────┘ │
//   └───────────────────────────────────────────────────────────────────┘
//
// The swarm organisms LIVE INSIDE this world organism.
// The world responds to the swarm. The swarm responds to the world.
// They co-evolve.
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Time  "mo:base/Time";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let OMEGA_MEDINA : Float = 2.11185;
  let SIGMA_ZERO : Float = 0.75;
  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;

  public let MAX_BIOMES : Nat = 16;
  public let INNER_AI_COUNT : Nat = 6;

  // ==========================================================================
  // INNER AI TYPES
  // ==========================================================================
  // These are the procedural generators that build the world from within
  
  public type InnerAIType = {
    #TerrainAI;
    #WeatherAI;
    #EcologyAI;
    #GeologyAI;
    #AtmosphereAI;
    #HydrologyAI;
  };

  public type InnerAIState = {
    aiType        : InnerAIType;
    activation    : Float;
    phase         : Float;
    frequency     : Float;
    output        : Float;
    lastProcessed : Nat;
    generationRate: Float;        // How fast it generates content
    coherence     : Float;
    creativityLevel: Float;       // 0-1 how novel its generations are
    
    // What this AI has generated
    totalGenerated: Nat;
    lastGeneration: ?Text;
  };

  // ==========================================================================
  // BIOME TYPES
  // ==========================================================================
  
  public type BiomeType = {
    #Ocean;
    #Desert;
    #Forest;
    #Mountain;
    #Tundra;
    #Grassland;
    #Wetland;
    #Urban;
    #Volcanic;
    #Arctic;
    #Tropical;
    #Temperate;
    #Savanna;
    #Taiga;
    #Chaparral;
    #Reef;
  };

  public type BiomeBrain = {
    phase         : Float;
    frequency     : Float;
    activation    : Float;
    coherence     : Float;
    weights       : [var Float];  // Connections to other biomes
  };

  public type BiomeState = {
    biomeId       : Nat;
    biomeType     : BiomeType;
    name          : Text;
    
    // Biome brain
    brain         : BiomeBrain;
    
    // Physical properties
    centerX       : Float;
    centerZ       : Float;
    radius        : Float;
    elevation     : Float;
    temperature   : Float;
    humidity      : Float;
    fertility     : Float;
    
    // Dynamic state
    health        : Float;        // 0-1 ecosystem health
    stability     : Float;        // 0-1 stability
    biodiversity  : Float;        // 0-1 species diversity
    resourceLevel : Float;        // 0-1 available resources
    
    // Influence on swarm
    swarmAttraction: Float;       // How attractive to swarm
    threatLevel   : Float;        // Danger level
    visibility    : Float;        // How easy to see through
    
    // Neighbors
    neighborBiomes: [Nat];        // Adjacent biome IDs
    
    lastUpdated   : Nat;
  };

  // ==========================================================================
  // WORLD BRAIN
  // ==========================================================================
  // The central cognitive system of the world organism
  
  public type WorldBrainNode = {
    activation    : Float;
    phase         : Float;
    frequency     : Float;
    potential     : Float;
  };

  public type WorldBrain = {
    // Core nodes (one per major world system)
    tectonicNode  : WorldBrainNode;   // Earth movement
    atmosphericNode: WorldBrainNode;  // Air systems
    hydrologicNode: WorldBrainNode;   // Water systems
    biologicNode  : WorldBrainNode;   // Life systems
    thermalNode   : WorldBrainNode;   // Heat/energy
    temporalNode  : WorldBrainNode;   // Time/cycles
    
    // Global state
    globalCoherence: Float;
    globalPhase   : Float;
    worldAge      : Nat;              // Beats since world creation
    
    // Hebbian weights between nodes (6x6 = 36)
    weights       : [var Float];
    
    // World-level metrics
    entropy       : Float;            // Disorder level
    complexity    : Float;            // Emergent complexity
    habitability  : Float;            // How livable for organisms
  };

  // ==========================================================================
  // PROCEDURAL GENERATION OUTPUTS
  // ==========================================================================
  
  public type TerrainGeneration = {
    chunkX        : Int;
    chunkZ        : Int;
    heightMap     : [Float];          // Heights for this chunk
    materialMap   : [Nat];            // Material types
    featureFlags  : [Bool];           // Special features
    generated     : Nat;              // Beat when generated
  };

  public type WeatherGeneration = {
    regionId      : Nat;
    temperature   : Float;
    pressure      : Float;
    humidity      : Float;
    windX         : Float;
    windZ         : Float;
    precipitation : Float;
    cloudCover    : Float;
    stormProbability: Float;
    generated     : Nat;
  };

  public type EcologyGeneration = {
    biomeId       : Nat;
    floraTypes    : [Text];
    faunaTypes    : [Text];
    populationLevels: [Float];
    foodChainState: Float;
    generated     : Nat;
  };

  // ==========================================================================
  // WORLD ORGANISM STATE
  // ==========================================================================
  
  public type WorldOrganismState = {
    // Identity
    worldId       : Nat;
    worldName     : Text;
    createdAt     : Nat;
    
    // World brain
    brain         : WorldBrain;
    
    // Inner AIs
    innerAIs      : [InnerAIState];
    
    // Biomes
    biomes        : [BiomeState];
    activeBiomes  : Nat;
    
    // Generated content cache
    terrainCache  : [TerrainGeneration];
    weatherCache  : [WeatherGeneration];
    ecologyCache  : [EcologyGeneration];
    
    // World metrics
    totalArea     : Float;            // Square meters
    landMass      : Float;            // Percentage land
    waterMass     : Float;            // Percentage water
    atmosphereDensity: Float;
    gravityStrength: Float;
    dayLength     : Nat;              // Beats per day cycle
    
    // Swarm interaction
    swarmPresent  : Bool;
    swarmInfluence: Float;            // How much swarm affects world
    worldInfluence: Float;            // How much world affects swarm
    
    // Co-evolution metrics
    coEvolutionLevel: Float;          // Mutual adaptation level
    symbiosisScore: Float;            // Beneficial interaction score
    
    beatNum       : Nat;
  };

  // ==========================================================================
  // UTILITY FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };

  // ==========================================================================
  // WORLD BRAIN FUNCTIONS
  // ==========================================================================
  
  public func computeWorldCoherence(brain: WorldBrain) : Float {
    let phases = [
      brain.tectonicNode.phase,
      brain.atmosphericNode.phase,
      brain.hydrologicNode.phase,
      brain.biologicNode.phase,
      brain.thermalNode.phase,
      brain.temporalNode.phase
    ];
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (p in phases.vals()) {
      sumCos += Float.cos(p);
      sumSin += Float.sin(p);
    };
    
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / 6.0;
    clamp(r, SIGMA_ZERO, 1.0)
  };

  public func updateWorldBrainPhases(brain: WorldBrain, dt: Float) : WorldBrain {
    // Compute mean phase
    let phases = [
      brain.tectonicNode.phase,
      brain.atmosphericNode.phase,
      brain.hydrologicNode.phase,
      brain.biologicNode.phase,
      brain.thermalNode.phase,
      brain.temporalNode.phase
    ];
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (p in phases.vals()) {
      sumCos += Float.cos(p);
      sumSin += Float.sin(p);
    };
    let meanPhase = Float.arctan2(sumSin, sumCos);
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / 6.0;
    
    // Update each node with Kuramoto coupling
    let K = 0.3;  // World coupling strength (slower than swarm)
    
    func updateNode(node: WorldBrainNode) : WorldBrainNode {
      let coupling = K * r * Float.sin(meanPhase - node.phase);
      let newPhase = wrapPhase(node.phase + (node.frequency + coupling) * dt);
      {
        activation = node.activation;
        phase = newPhase;
        frequency = node.frequency;
        potential = node.potential;
      }
    };
    
    let newCoherence = computeWorldCoherence(brain);
    
    {
      tectonicNode = updateNode(brain.tectonicNode);
      atmosphericNode = updateNode(brain.atmosphericNode);
      hydrologicNode = updateNode(brain.hydrologicNode);
      biologicNode = updateNode(brain.biologicNode);
      thermalNode = updateNode(brain.thermalNode);
      temporalNode = updateNode(brain.temporalNode);
      globalCoherence = newCoherence;
      globalPhase = meanPhase;
      worldAge = brain.worldAge + 1;
      weights = brain.weights;
      entropy = brain.entropy;
      complexity = brain.complexity;
      habitability = brain.habitability;
    }
  };

  // ==========================================================================
  // INNER AI FUNCTIONS
  // ==========================================================================
  
  public func tickInnerAI(ai: InnerAIState, worldCoherence: Float, beat: Nat) : InnerAIState {
    // Inner AIs generate more when world coherence is high
    let generationBoost = worldCoherence * ai.creativityLevel;
    let newOutput = clamp(ai.output + generationBoost * 0.1 - 0.05, 0.0, 1.0);
    
    // Update phase
    let newPhase = wrapPhase(ai.phase + ai.frequency * 0.1);
    
    // Update activation based on output
    let newActivation = clamp(ai.activation * 0.9 + newOutput * 0.1, 0.0, 1.0);
    
    {
      aiType = ai.aiType;
      activation = newActivation;
      phase = newPhase;
      frequency = ai.frequency;
      output = newOutput;
      lastProcessed = beat;
      generationRate = ai.generationRate;
      coherence = worldCoherence;
      creativityLevel = ai.creativityLevel;
      totalGenerated = ai.totalGenerated + (if (newOutput > 0.8) { 1 } else { 0 });
      lastGeneration = ai.lastGeneration;
    }
  };

  // ==========================================================================
  // BIOME FUNCTIONS
  // ==========================================================================
  
  public func tickBiome(biome: BiomeState, worldBrain: WorldBrain, beat: Nat) : BiomeState {
    // Biome responds to relevant world brain nodes
    let atmosphericInfluence = worldBrain.atmosphericNode.activation;
    let biologicInfluence = worldBrain.biologicNode.activation;
    let thermalInfluence = worldBrain.thermalNode.activation;
    
    // Update temperature based on thermal node
    let newTemp = biome.temperature * 0.95 + thermalInfluence * 20.0 * 0.05;
    
    // Update humidity based on atmospheric node
    let newHumidity = clamp(biome.humidity * 0.9 + atmosphericInfluence * 0.1, 0.0, 1.0);
    
    // Update health based on biologic node
    let newHealth = clamp(biome.health * 0.95 + biologicInfluence * 0.05, 0.0, 1.0);
    
    // Update biome brain phase
    let newPhase = wrapPhase(biome.brain.phase + biome.brain.frequency * 0.1);
    
    {
      biomeId = biome.biomeId;
      biomeType = biome.biomeType;
      name = biome.name;
      brain = {
        phase = newPhase;
        frequency = biome.brain.frequency;
        activation = biome.brain.activation;
        coherence = biome.brain.coherence;
        weights = biome.brain.weights;
      };
      centerX = biome.centerX;
      centerZ = biome.centerZ;
      radius = biome.radius;
      elevation = biome.elevation;
      temperature = newTemp;
      humidity = newHumidity;
      fertility = biome.fertility;
      health = newHealth;
      stability = biome.stability;
      biodiversity = biome.biodiversity;
      resourceLevel = biome.resourceLevel;
      swarmAttraction = biome.swarmAttraction;
      threatLevel = biome.threatLevel;
      visibility = biome.visibility;
      neighborBiomes = biome.neighborBiomes;
      lastUpdated = beat;
    }
  };

  // ==========================================================================
  // WORLD ORGANISM TICK
  // ==========================================================================
  
  public func tickWorldOrganism(state: WorldOrganismState, dt: Float) : WorldOrganismState {
    // 1. Update world brain
    let newBrain = updateWorldBrainPhases(state.brain, dt);
    
    // 2. Update inner AIs
    let newInnerAIs = Array.map<InnerAIState, InnerAIState>(
      state.innerAIs,
      func(ai) { tickInnerAI(ai, newBrain.globalCoherence, state.beatNum + 1) }
    );
    
    // 3. Update biomes
    let newBiomes = Array.map<BiomeState, BiomeState>(
      state.biomes,
      func(biome) { tickBiome(biome, newBrain, state.beatNum + 1) }
    );
    
    // 4. Compute co-evolution metrics
    let swarmInfluenceEffect = state.swarmInfluence * state.worldInfluence;
    let newCoEvolution = clamp(
      state.coEvolutionLevel * 0.99 + swarmInfluenceEffect * 0.01,
      0.0, 1.0
    );
    
    {
      worldId = state.worldId;
      worldName = state.worldName;
      createdAt = state.createdAt;
      brain = newBrain;
      innerAIs = newInnerAIs;
      biomes = newBiomes;
      activeBiomes = state.activeBiomes;
      terrainCache = state.terrainCache;
      weatherCache = state.weatherCache;
      ecologyCache = state.ecologyCache;
      totalArea = state.totalArea;
      landMass = state.landMass;
      waterMass = state.waterMass;
      atmosphereDensity = state.atmosphereDensity;
      gravityStrength = state.gravityStrength;
      dayLength = state.dayLength;
      swarmPresent = state.swarmPresent;
      swarmInfluence = state.swarmInfluence;
      worldInfluence = state.worldInfluence;
      coEvolutionLevel = newCoEvolution;
      symbiosisScore = state.symbiosisScore;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  func initWorldBrainNode(freq: Float) : WorldBrainNode {
    {
      activation = 0.5;
      phase = 0.0;
      frequency = freq;
      potential = 0.0;
    }
  };

  func initInnerAI(aiType: InnerAIType, freq: Float, creativity: Float) : InnerAIState {
    {
      aiType = aiType;
      activation = 0.5;
      phase = 0.0;
      frequency = freq;
      output = 0.0;
      lastProcessed = 0;
      generationRate = 0.1;
      coherence = SIGMA_ZERO;
      creativityLevel = creativity;
      totalGenerated = 0;
      lastGeneration = null;
    }
  };

  func initBiome(id: Nat, biomeType: BiomeType, name: Text, x: Float, z: Float) : BiomeState {
    {
      biomeId = id;
      biomeType = biomeType;
      name = name;
      brain = {
        phase = Float.fromInt(id) * PI / 8.0;
        frequency = 0.05 + Float.fromInt(id % 4) * 0.01;
        activation = 0.5;
        coherence = SIGMA_ZERO;
        weights = Array.init<Float>(MAX_BIOMES, 0.1);
      };
      centerX = x;
      centerZ = z;
      radius = 200.0;
      elevation = 50.0;
      temperature = 20.0;
      humidity = 0.5;
      fertility = 0.5;
      health = 0.8;
      stability = 0.7;
      biodiversity = 0.5;
      resourceLevel = 0.6;
      swarmAttraction = 0.5;
      threatLevel = 0.2;
      visibility = 0.8;
      neighborBiomes = [];
      lastUpdated = 0;
    }
  };

  public func initWorldOrganism() : WorldOrganismState {
    let brain : WorldBrain = {
      tectonicNode = initWorldBrainNode(0.001);    // Very slow
      atmosphericNode = initWorldBrainNode(0.05);  // Medium
      hydrologicNode = initWorldBrainNode(0.02);   // Slow
      biologicNode = initWorldBrainNode(0.03);     // Medium-slow
      thermalNode = initWorldBrainNode(0.04);      // Medium
      temporalNode = initWorldBrainNode(0.1);      // Fast (day/night)
      globalCoherence = SIGMA_ZERO;
      globalPhase = 0.0;
      worldAge = 0;
      weights = Array.init<Float>(36, 0.1);
      entropy = 0.3;
      complexity = 0.5;
      habitability = 0.7;
    };
    
    let innerAIs = [
      initInnerAI(#TerrainAI, 0.02, 0.6),
      initInnerAI(#WeatherAI, 0.08, 0.7),
      initInnerAI(#EcologyAI, 0.04, 0.8),
      initInnerAI(#GeologyAI, 0.01, 0.5),
      initInnerAI(#AtmosphereAI, 0.06, 0.6),
      initInnerAI(#HydrologyAI, 0.03, 0.7)
    ];
    
    let biomes = [
      initBiome(0, #Grassland, "Central Plains", 0.0, 0.0),
      initBiome(1, #Forest, "Eastern Woods", 500.0, 0.0),
      initBiome(2, #Mountain, "Northern Peaks", 0.0, 500.0),
      initBiome(3, #Desert, "Western Dunes", -500.0, 0.0),
      initBiome(4, #Ocean, "Southern Sea", 0.0, -500.0)
    ];
    
    {
      worldId = 0;
      worldName = "Genesis World";
      createdAt = 0;
      brain = brain;
      innerAIs = innerAIs;
      biomes = biomes;
      activeBiomes = 5;
      terrainCache = [];
      weatherCache = [];
      ecologyCache = [];
      totalArea = 4_000_000.0;  // 2km x 2km
      landMass = 0.7;
      waterMass = 0.3;
      atmosphereDensity = 1.0;
      gravityStrength = 9.81;
      dayLength = 1000;  // 1000 beats per day
      swarmPresent = false;
      swarmInfluence = 0.0;
      worldInfluence = 0.5;
      coEvolutionLevel = 0.0;
      symbiosisScore = 0.0;
      beatNum = 0;
    }
  };

  // ==========================================================================
  // CO-EVOLUTION FUNCTIONS
  // ==========================================================================
  // The swarm and world evolve together
  
  public func applySwarmToWorld(
    worldState: WorldOrganismState,
    swarmCoherence: Float,
    swarmActivity: Float
  ) : WorldOrganismState {
    // Swarm affects world habitability and complexity
    let habitabilityDelta = swarmCoherence * swarmActivity * 0.01;
    let complexityDelta = swarmActivity * 0.005;
    
    let newBrain = {
      tectonicNode = worldState.brain.tectonicNode;
      atmosphericNode = worldState.brain.atmosphericNode;
      hydrologicNode = worldState.brain.hydrologicNode;
      biologicNode = {
        activation = clamp(worldState.brain.biologicNode.activation + swarmActivity * 0.1, 0.0, 1.0);
        phase = worldState.brain.biologicNode.phase;
        frequency = worldState.brain.biologicNode.frequency;
        potential = worldState.brain.biologicNode.potential;
      };
      thermalNode = worldState.brain.thermalNode;
      temporalNode = worldState.brain.temporalNode;
      globalCoherence = worldState.brain.globalCoherence;
      globalPhase = worldState.brain.globalPhase;
      worldAge = worldState.brain.worldAge;
      weights = worldState.brain.weights;
      entropy = worldState.brain.entropy;
      complexity = clamp(worldState.brain.complexity + complexityDelta, 0.0, 1.0);
      habitability = clamp(worldState.brain.habitability + habitabilityDelta, 0.0, 1.0);
    };
    
    {
      worldId = worldState.worldId;
      worldName = worldState.worldName;
      createdAt = worldState.createdAt;
      brain = newBrain;
      innerAIs = worldState.innerAIs;
      biomes = worldState.biomes;
      activeBiomes = worldState.activeBiomes;
      terrainCache = worldState.terrainCache;
      weatherCache = worldState.weatherCache;
      ecologyCache = worldState.ecologyCache;
      totalArea = worldState.totalArea;
      landMass = worldState.landMass;
      waterMass = worldState.waterMass;
      atmosphereDensity = worldState.atmosphereDensity;
      gravityStrength = worldState.gravityStrength;
      dayLength = worldState.dayLength;
      swarmPresent = true;
      swarmInfluence = swarmActivity;
      worldInfluence = worldState.worldInfluence;
      coEvolutionLevel = worldState.coEvolutionLevel;
      symbiosisScore = worldState.symbiosisScore;
      beatNum = worldState.beatNum;
    }
  };

  public func applyWorldToSwarm(worldState: WorldOrganismState) : (Float, Float, Float) {
    // Returns (coherence_modifier, energy_modifier, threat_modifier)
    let coherenceMod = worldState.brain.habitability * 0.1;
    let energyMod = worldState.brain.globalCoherence * 0.05;
    let threatMod = worldState.brain.entropy * 0.2;
    
    (coherenceMod, energyMod, threatMod)
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

}
