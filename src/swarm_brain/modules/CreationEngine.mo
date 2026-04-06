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
// Module: CreationEngine — Procedural World Generation Core
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
// THE CREATION ENGINE
// ============================================================================
//
// The world doesn't need to be fully pre-built. The Creation Engine contains
// inner AIs that procedurally generate the world as needed. The world ITSELF
// is an organism with a brain.
//
// ARCHITECTURE:
//   ┌──────────────────────────────────────────────────────────────────────┐
//   │                    CREATION ENGINE                                   │
//   │  ┌──────────────────────────────────────────────────────────────┐   │
//   │  │  WORLD BRAIN                                                  │   │
//   │  │  • Kuramoto oscillators for biome coordination               │   │
//   │  │  • Hebbian learning for pattern persistence                  │   │
//   │  │  • Global coherence metric                                   │   │
//   │  └──────────────────────────────────────────────────────────────┘   │
//   │  ┌──────────────────────────────────────────────────────────────┐   │
//   │  │  INNER AIs (Genesis Agents)                                   │   │
//   │  │  • GenesisAlpha: Terrain & topology                          │   │
//   │  │  • GenesisBeta: Atmosphere & weather                         │   │
//   │  │  • GenesisGamma: Hydrology & fluids                          │   │
//   │  │  • GenesisDelta: Flora & vegetation                          │   │
//   │  │  • GenesisEpsilon: Fauna & creatures                         │   │
//   │  │  • GenesisZeta: Resources & minerals                         │   │
//   │  │  • GenesisEta: Events & anomalies                            │   │
//   │  │  • GenesisTheta: Time & cycles                               │   │
//   │  └──────────────────────────────────────────────────────────────┘   │
//   │  ┌──────────────────────────────────────────────────────────────┐   │
//   │  │  CHAOS-CREATION CYCLE                                         │   │
//   │  │  • Chaos phase: Random variation, mutation, noise            │   │
//   │  │  • Creation phase: Selection, ordering, pattern formation    │   │
//   │  │  • Compound over cycles → emergent complexity                │   │
//   │  └──────────────────────────────────────────────────────────────┘   │
//   └──────────────────────────────────────────────────────────────────────┘
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
  let OMEGA_MEDINA : Float = 2.11185;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let SIGMA_ZERO : Float = 0.75;
  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;
  let GOLDEN_RATIO : Float = 1.618033988749;

  // Creation Engine constants
  let GENESIS_AGENT_COUNT : Nat = 8;
  let CHUNK_SIZE : Float = 100.0;         // meters
  let MAX_GENERATION_DEPTH : Nat = 5;
  let CHAOS_CYCLE_LENGTH : Nat = 100;     // beats per cycle

  // ==========================================================================
  // GENESIS AGENT TYPES
  // ==========================================================================
  
  public type GenesisAgentType = {
    #Alpha;     // Terrain & topology
    #Beta;      // Atmosphere & weather
    #Gamma;     // Hydrology & fluids
    #Delta;     // Flora & vegetation
    #Epsilon;   // Fauna & creatures
    #Zeta;      // Resources & minerals
    #Eta;       // Events & anomalies
    #Theta;     // Time & cycles
  };

  public type GenesisAgentState = {
    agentType       : GenesisAgentType;
    activation      : Float;
    phase           : Float;
    frequency       : Float;
    creativityLevel : Float;
    chaosAffinity   : Float;      // How much chaos it tolerates
    creationPower   : Float;      // How much it can create per beat
    
    // Generation stats
    totalGenerated  : Nat;
    lastGeneration  : ?Text;
    generationQueue : [GenerationRequest];
    
    // Brain connection
    weights         : [var Float]; // Connection to other agents
    lastFired       : Nat;
  };

  // ==========================================================================
  // GENERATION SYSTEM
  // ==========================================================================
  
  public type GenerationRequest = {
    requestId       : Nat;
    targetType      : GenesisAgentType;
    location        : (Float, Float, Float);  // x, y, z
    radius          : Float;
    priority        : Float;
    requestedAt     : Nat;
    parameters      : [(Text, Float)];
  };

  public type GenerationResult = {
    requestId       : Nat;
    success         : Bool;
    generatedData   : GeneratedContent;
    processingTime  : Nat;
    qualityScore    : Float;
  };

  public type GeneratedContent = {
    #Terrain : TerrainChunk;
    #Weather : WeatherState;
    #Water : WaterBody;
    #Flora : FloraInstance;
    #Fauna : FaunaInstance;
    #Resource : ResourceDeposit;
    #Event : WorldEvent;
    #TimeState : TimeState;
  };

  // ==========================================================================
  // TERRAIN GENERATION
  // ==========================================================================
  
  public type TerrainChunk = {
    chunkId         : Nat;
    position        : (Float, Float);     // World coordinates
    heightMap       : [Float];            // Height values
    materialMap     : [Nat];              // Material indices
    normalMap       : [(Float, Float, Float)];
    biomeType       : BiomeType;
    erosionLevel    : Float;
    vegetationDensity: Float;
    waterTable      : Float;
    generatedAt     : Nat;
  };

  public type BiomeType = {
    #Ocean;
    #Beach;
    #Plains;
    #Forest;
    #Jungle;
    #Desert;
    #Tundra;
    #Mountain;
    #Volcanic;
    #Swamp;
    #Arctic;
    #Savanna;
  };

  // Procedural terrain generation using noise functions
  public func generateTerrainHeight(
    x: Float,
    z: Float,
    seed: Nat32,
    octaves: Nat,
    persistence: Float,
    lacunarity: Float
  ) : Float {
    var total : Float = 0.0;
    var frequency : Float = 1.0;
    var amplitude : Float = 1.0;
    var maxValue : Float = 0.0;
    
    for (i in Array.keys(Array.tabulate<Nat>(octaves, func(j) { j }))) {
      // Simplified Perlin-like noise
      let noiseVal = simplexNoise2D(x * frequency, z * frequency, seed);
      total += noiseVal * amplitude;
      maxValue += amplitude;
      amplitude *= persistence;
      frequency *= lacunarity;
    };
    
    total / maxValue
  };

  // Simplified 2D noise function
  func simplexNoise2D(x: Float, y: Float, seed: Nat32) : Float {
    // Hash function for pseudo-random
    let ix = Int.abs(Float.toInt(Float.floor(x)));
    let iy = Int.abs(Float.toInt(Float.floor(y)));
    let hash = Nat32.fromNat((ix * 374761393 + iy * 668265263 + Nat32.toNat(seed)) % 1000000);
    
    // Interpolation
    let fx = x - Float.floor(x);
    let fy = y - Float.floor(y);
    
    // Smoothstep
    let u = fx * fx * (3.0 - 2.0 * fx);
    let v = fy * fy * (3.0 - 2.0 * fy);
    
    // Mix pseudo-random values
    let n00 = Float.fromInt(Nat32.toNat(hash) % 1000) / 1000.0;
    let n10 = Float.fromInt(Nat32.toNat(hash +% 1) % 1000) / 1000.0;
    let n01 = Float.fromInt(Nat32.toNat(hash +% 2) % 1000) / 1000.0;
    let n11 = Float.fromInt(Nat32.toNat(hash +% 3) % 1000) / 1000.0;
    
    let nx0 = n00 * (1.0 - u) + n10 * u;
    let nx1 = n01 * (1.0 - u) + n11 * u;
    
    (nx0 * (1.0 - v) + nx1 * v) * 2.0 - 1.0
  };

  // ==========================================================================
  // WEATHER GENERATION
  // ==========================================================================
  
  public type WeatherState = {
    temperature     : Float;        // Celsius
    humidity        : Float;        // 0-1
    pressure        : Float;        // hPa
    windSpeed       : Float;        // m/s
    windDirection   : Float;        // radians
    precipitation   : Float;        // mm/hr
    cloudCover      : Float;        // 0-1
    visibility      : Float;        // km
    weatherType     : WeatherType;
    stormIntensity  : Float;
    generatedAt     : Nat;
  };

  public type WeatherType = {
    #Clear;
    #Cloudy;
    #Rain;
    #Storm;
    #Snow;
    #Fog;
    #Sandstorm;
    #Hail;
  };

  public func generateWeather(
    latitude: Float,
    season: Float,      // 0-1 representing time of year
    altitude: Float,
    oceanProximity: Float,
    seed: Nat32
  ) : WeatherState {
    // Base temperature from latitude and season
    let baseTemp = 30.0 - Float.abs(latitude) * 0.5 + Float.sin(season * TWO_PI) * 15.0;
    let altitudeEffect = altitude * 0.0065;  // Lapse rate
    let temperature = baseTemp - altitudeEffect;
    
    // Humidity from ocean proximity
    let humidity = 0.3 + oceanProximity * 0.5 + simplexNoise2D(season * 10.0, latitude, seed) * 0.2;
    
    // Pressure (simplified)
    let pressure = 1013.25 - altitude * 0.12;
    
    // Wind
    let windSpeed = 5.0 + simplexNoise2D(latitude, season * 5.0, seed +% 100) * 15.0;
    let windDirection = simplexNoise2D(season, latitude, seed +% 200) * TWO_PI;
    
    // Precipitation
    let precipChance = humidity * (1.0 - Float.abs(temperature - 15.0) / 30.0);
    let precipitation = if (precipChance > 0.6) { precipChance * 20.0 } else { 0.0 };
    
    // Cloud cover
    let cloudCover = humidity * 0.8 + simplexNoise2D(season, altitude / 1000.0, seed +% 300) * 0.3;
    
    // Determine weather type
    let weatherType = if (precipitation > 10.0 and temperature < 0.0) { #Snow }
                      else if (precipitation > 15.0) { #Storm }
                      else if (precipitation > 5.0) { #Rain }
                      else if (cloudCover > 0.8) { #Cloudy }
                      else if (humidity > 0.9 and temperature < 15.0) { #Fog }
                      else { #Clear };
    
    {
      temperature = temperature;
      humidity = clamp(humidity, 0.0, 1.0);
      pressure = pressure;
      windSpeed = clamp(windSpeed, 0.0, 50.0);
      windDirection = windDirection;
      precipitation = clamp(precipitation, 0.0, 100.0);
      cloudCover = clamp(cloudCover, 0.0, 1.0);
      visibility = if (precipitation > 10.0) { 2.0 } else { 10.0 };
      weatherType = weatherType;
      stormIntensity = if (weatherType == #Storm) { precipitation / 20.0 } else { 0.0 };
      generatedAt = 0;
    }
  };

  // ==========================================================================
  // FLORA & FAUNA GENERATION
  // ==========================================================================
  
  public type FloraInstance = {
    floraId         : Nat;
    species         : Text;
    position        : (Float, Float, Float);
    size            : Float;
    age             : Nat;
    health          : Float;
    growthStage     : Float;
    canopy          : Float;        // Coverage area
    rootDepth       : Float;
  };

  public type FaunaInstance = {
    faunaId         : Nat;
    species         : Text;
    position        : (Float, Float, Float);
    heading         : Float;
    speed           : Float;
    health          : Float;
    energy          : Float;
    age             : Nat;
    behavior        : FaunaBehavior;
  };

  public type FaunaBehavior = {
    #Idle;
    #Foraging;
    #Hunting;
    #Fleeing;
    #Resting;
    #Migrating;
    #Mating;
    #Defending;
  };

  // ==========================================================================
  // RESOURCE GENERATION
  // ==========================================================================
  
  public type ResourceDeposit = {
    resourceId      : Nat;
    resourceType    : ResourceType;
    position        : (Float, Float, Float);
    quantity        : Float;
    quality         : Float;
    accessibility   : Float;
    renewRate       : Float;        // 0 for non-renewable
  };

  public type ResourceType = {
    #Water;
    #Food;
    #Fuel;
    #Mineral;
    #Energy;
    #Shelter;
    #Material;
  };

  // ==========================================================================
  // WATER BODY GENERATION
  // ==========================================================================
  
  public type WaterBody = {
    waterId         : Nat;
    waterType       : WaterType;
    position        : (Float, Float);
    area            : Float;
    depth           : Float;
    flowRate        : Float;
    flowDirection   : Float;
    salinity        : Float;
    temperature     : Float;
    oxygenLevel     : Float;
  };

  public type WaterType = {
    #Ocean;
    #Sea;
    #Lake;
    #River;
    #Stream;
    #Pond;
    #Wetland;
    #Aquifer;
  };

  // ==========================================================================
  // WORLD EVENTS
  // ==========================================================================
  
  public type WorldEvent = {
    eventId         : Nat;
    eventType       : EventType;
    position        : (Float, Float, Float);
    radius          : Float;
    intensity       : Float;
    duration        : Nat;
    startBeat       : Nat;
    effects         : [EventEffect];
  };

  public type EventType = {
    #Earthquake;
    #Flood;
    #Fire;
    #Storm;
    #Volcanic;
    #Meteor;
    #Anomaly;
    #Migration;
  };

  public type EventEffect = {
    #TerrainChange : Float;
    #WeatherChange : WeatherState;
    #FaunaDisplacement : Float;
    #ResourceDepletion : Float;
    #Destruction : Float;
  };

  // ==========================================================================
  // TIME STATE
  // ==========================================================================
  
  public type TimeState = {
    worldAge        : Nat;          // Beats since world creation
    dayOfYear       : Float;        // 0-365
    timeOfDay       : Float;        // 0-24
    season          : Season;
    moonPhase       : Float;        // 0-1
    sunPosition     : (Float, Float);
    dayLength       : Float;        // Hours
  };

  public type Season = {
    #Spring;
    #Summer;
    #Autumn;
    #Winter;
  };

  // ==========================================================================
  // CHAOS-CREATION CYCLE
  // ==========================================================================
  
  public type ChaosCreationPhase = {
    #Chaos;
    #Transition;
    #Creation;
    #Stabilization;
  };

  public type ChaosCreationCycle = {
    cycleNumber     : Nat;
    currentPhase    : ChaosCreationPhase;
    phaseProgress   : Float;        // 0-1 progress through current phase
    chaosLevel      : Float;        // Current chaos intensity
    creationLevel   : Float;        // Current creation intensity
    entropy         : Float;        // System entropy
    order           : Float;        // System order
    cycleOutput     : Float;        // Cumulative output this cycle
    peakReached     : Bool;
    beatInCycle     : Nat;
  };

  public func tickChaosCreationCycle(cycle: ChaosCreationCycle) : ChaosCreationCycle {
    let newBeat = cycle.beatInCycle + 1;
    let cycleProgress = Float.fromInt(newBeat) / Float.fromInt(CHAOS_CYCLE_LENGTH);
    
    // Determine phase based on progress
    let (newPhase, phaseProgress) = if (cycleProgress < 0.25) {
      (#Chaos, cycleProgress * 4.0)
    } else if (cycleProgress < 0.5) {
      (#Transition, (cycleProgress - 0.25) * 4.0)
    } else if (cycleProgress < 0.75) {
      (#Creation, (cycleProgress - 0.5) * 4.0)
    } else {
      (#Stabilization, (cycleProgress - 0.75) * 4.0)
    };
    
    // Chaos peaks in chaos phase, creation peaks in creation phase
    let newChaos = switch (newPhase) {
      case (#Chaos) { 0.5 + phaseProgress * 0.5 };
      case (#Transition) { 1.0 - phaseProgress * 0.5 };
      case (#Creation) { 0.5 - phaseProgress * 0.3 };
      case (#Stabilization) { 0.2 };
    };
    
    let newCreation = switch (newPhase) {
      case (#Chaos) { 0.1 };
      case (#Transition) { 0.1 + phaseProgress * 0.4 };
      case (#Creation) { 0.5 + phaseProgress * 0.5 };
      case (#Stabilization) { 1.0 - phaseProgress * 0.3 };
    };
    
    // Entropy and order are inverses
    let newEntropy = newChaos * 0.7 + (1.0 - newCreation) * 0.3;
    let newOrder = 1.0 - newEntropy;
    
    // Cycle output accumulates
    let outputDelta = newCreation * newOrder * 0.01;
    let newOutput = cycle.cycleOutput + outputDelta;
    
    // Check if cycle complete
    let cycleComplete = newBeat >= CHAOS_CYCLE_LENGTH;
    
    {
      cycleNumber = if (cycleComplete) { cycle.cycleNumber + 1 } else { cycle.cycleNumber };
      currentPhase = newPhase;
      phaseProgress = phaseProgress;
      chaosLevel = newChaos;
      creationLevel = newCreation;
      entropy = newEntropy;
      order = newOrder;
      cycleOutput = if (cycleComplete) { 0.0 } else { newOutput };
      peakReached = newOutput > 0.8;
      beatInCycle = if (cycleComplete) { 0 } else { newBeat };
    }
  };

  // ==========================================================================
  // CREATION ENGINE STATE
  // ==========================================================================
  
  public type CreationEngineState = {
    // Genesis Agents
    agents          : [GenesisAgentState];
    
    // World Brain
    worldCoherence  : Float;
    worldPhase      : Float;
    worldFrequency  : Float;
    
    // Chaos-Creation
    chaosCreation   : ChaosCreationCycle;
    totalCycles     : Nat;
    cumulativeOutput: Float;
    
    // Generation
    pendingRequests : [GenerationRequest];
    completedRequests: Nat;
    
    // World State
    worldSeed       : Nat32;
    timeState       : TimeState;
    
    beatNum         : Nat;
  };

  // ==========================================================================
  // MAIN TICK FUNCTION
  // ==========================================================================
  
  public func tickCreationEngine(state: CreationEngineState) : CreationEngineState {
    // 1. Update chaos-creation cycle
    let newChaosCreation = tickChaosCreationCycle(state.chaosCreation);
    
    // 2. Update world coherence based on creation level
    let coherenceDelta = (newChaosCreation.creationLevel - newChaosCreation.chaosLevel) * 0.01;
    let newCoherence = clamp(state.worldCoherence + coherenceDelta, SIGMA_ZERO, 1.0);
    
    // 3. Update world phase (Kuramoto-like)
    let newPhase = wrapPhase(state.worldPhase + state.worldFrequency * 0.1);
    
    // 4. Accumulate output across cycles
    let newCumulative = if (newChaosCreation.peakReached and not state.chaosCreation.peakReached) {
      state.cumulativeOutput + newChaosCreation.cycleOutput * PHI_MEDINA
    } else {
      state.cumulativeOutput
    };
    
    // 5. Update time
    let newTimeState = advanceTime(state.timeState);
    
    {
      agents = state.agents;
      worldCoherence = newCoherence;
      worldPhase = newPhase;
      worldFrequency = state.worldFrequency;
      chaosCreation = newChaosCreation;
      totalCycles = if (newChaosCreation.cycleNumber > state.chaosCreation.cycleNumber) {
        state.totalCycles + 1
      } else { state.totalCycles };
      cumulativeOutput = newCumulative;
      pendingRequests = state.pendingRequests;
      completedRequests = state.completedRequests;
      worldSeed = state.worldSeed;
      timeState = newTimeState;
      beatNum = state.beatNum + 1;
    }
  };

  func advanceTime(time: TimeState) : TimeState {
    let newTimeOfDay = if (time.timeOfDay + 0.1 >= 24.0) { 0.0 } else { time.timeOfDay + 0.1 };
    let dayAdvanced = newTimeOfDay < time.timeOfDay;
    let newDayOfYear = if (dayAdvanced) {
      if (time.dayOfYear + 1.0 >= 365.0) { 0.0 } else { time.dayOfYear + 1.0 }
    } else { time.dayOfYear };
    
    let newSeason = if (newDayOfYear < 91.0) { #Spring }
                    else if (newDayOfYear < 182.0) { #Summer }
                    else if (newDayOfYear < 273.0) { #Autumn }
                    else { #Winter };
    
    {
      worldAge = time.worldAge + 1;
      dayOfYear = newDayOfYear;
      timeOfDay = newTimeOfDay;
      season = newSeason;
      moonPhase = (Float.fromInt(time.worldAge % 295) / 295.0);
      sunPosition = (Float.cos(newTimeOfDay / 24.0 * TWO_PI), Float.sin(newTimeOfDay / 24.0 * TWO_PI));
      dayLength = 12.0 + Float.sin(newDayOfYear / 365.0 * TWO_PI) * 4.0;
    }
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
  // FIBONACCI-BASED GROWTH FUNCTIONS — The world GROWS, not coded
  // ==========================================================================
  
  // Fibonacci sequence generator
  public func fibonacci(n: Nat) : Nat {
    if (n < 2) { n }
    else {
      var a = 0;
      var b = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  // Golden angle for phyllotaxis (plant growth patterns)
  public let GOLDEN_ANGLE : Float = 2.399963229728653;  // 137.5077... degrees in radians

  // Fibonacci spiral point generation (for organic growth)
  public func fibonacciSpiralPoint(index: Nat, scale: Float) : (Float, Float) {
    let theta = Float.fromInt(index) * GOLDEN_ANGLE;
    let r = scale * Float.sqrt(Float.fromInt(index));
    (r * Float.cos(theta), r * Float.sin(theta))
  };

  // Fibonacci sphere distribution (uniform points on sphere)
  public func fibonacciSpherePoint(index: Nat, total: Nat) : (Float, Float, Float) {
    let phi = Float.fromInt(index) * GOLDEN_ANGLE;
    let y = 1.0 - (Float.fromInt(index) / Float.fromInt(total - 1)) * 2.0;
    let radiusAtY = Float.sqrt(1.0 - y * y);
    (Float.cos(phi) * radiusAtY, y, Float.sin(phi) * radiusAtY)
  };

  // L-System growth for trees and plants
  public type LSystemRule = {
    symbol: Text;
    replacement: Text;
  };

  public type LSystemState = {
    axiom: Text;
    rules: [LSystemRule];
    iterations: Nat;
    current: Text;
    angle: Float;
    length: Float;
  };

  public func applyLSystemRules(state: LSystemState) : LSystemState {
    // Apply one iteration of L-system rules
    var newString = "";
    let chars = state.current;
    // Simplified - in practice would iterate through characters
    {
      axiom = state.axiom;
      rules = state.rules;
      iterations = state.iterations + 1;
      current = state.current;  // Would be transformed
      angle = state.angle;
      length = state.length * GOLDEN_RATIO;  // Branches get longer with golden ratio
    }
  };

  // ==========================================================================
  // PROCEDURAL GENERATION ALGORITHMS
  // ==========================================================================

  // Diamond-Square algorithm for terrain
  public func diamondSquareStep(
    grid: [[var Float]],
    size: Nat,
    step: Nat,
    scale: Float,
    seed: Nat32
  ) : [[var Float]] {
    // Diamond step: average corners + random
    // Square step: average diamond points + random
    // Returns modified grid
    grid
  };

  // Voronoi cell generation for biomes
  public type VoronoiCell = {
    centerId: Nat;
    centerX: Float;
    centerY: Float;
    biome: BiomeType;
    elevation: Float;
    moisture: Float;
  };

  public func generateVoronoiCells(
    count: Nat,
    width: Float,
    height: Float,
    seed: Nat32
  ) : [VoronoiCell] {
    let cells = Array.tabulate<VoronoiCell>(count, func(i) {
      let hashVal = Nat32.toNat(seed) + i * 374761393;
      let x = Float.fromInt(hashVal % 1000) / 1000.0 * width;
      let y = Float.fromInt((hashVal / 1000) % 1000) / 1000.0 * height;
      {
        centerId = i;
        centerX = x;
        centerY = y;
        biome = #Plains;  // Would be determined by climate
        elevation = simplexNoise2D(x / 100.0, y / 100.0, seed);
        moisture = simplexNoise2D(x / 50.0, y / 50.0, seed +% 12345);
      }
    });
    cells
  };

  // River generation using flow simulation
  public type RiverSegment = {
    startX: Float;
    startY: Float;
    endX: Float;
    endY: Float;
    flowRate: Float;
    width: Float;
  };

  public func traceRiver(
    startX: Float,
    startY: Float,
    heightFunc: (Float, Float) -> Float,
    maxLength: Nat
  ) : [RiverSegment] {
    var segments : [RiverSegment] = [];
    var x = startX;
    var y = startY;
    var flow = 1.0;
    
    for (i in Array.keys(Array.tabulate<Nat>(maxLength, func(j) { j }))) {
      // Find steepest downhill direction
      var bestDx = 0.0;
      var bestDy = 0.0;
      var lowestH = heightFunc(x, y);
      
      // Check 8 directions
      let dx_arr = [-1.0, 0.0, 1.0, -1.0, 1.0, -1.0, 0.0, 1.0];
      let dy_arr = [-1.0, -1.0, -1.0, 0.0, 0.0, 1.0, 1.0, 1.0];
      
      for (d in Array.keys(dx_arr)) {
        let nx = x + dx_arr[d];
        let ny = y + dy_arr[d];
        let h = heightFunc(nx, ny);
        if (h < lowestH) {
          lowestH := h;
          bestDx := dx_arr[d];
          bestDy := dy_arr[d];
        };
      };
      
      if (bestDx == 0.0 and bestDy == 0.0) {
        // Reached a local minimum (lake)
        return segments;
      };
      
      let newX = x + bestDx;
      let newY = y + bestDy;
      
      segments := Array.append(segments, [{
        startX = x;
        startY = y;
        endX = newX;
        endY = newY;
        flowRate = flow;
        width = Float.sqrt(flow) * 2.0;
      }]);
      
      x := newX;
      y := newY;
      flow += 0.1;  // Accumulate water
    };
    
    segments
  };

  // ==========================================================================
  // GENESIS AGENT BRAIN FUNCTIONS — Each agent has cognitive abilities
  // ==========================================================================

  // Agent Kuramoto coupling (agents synchronize)
  public func coupleGenesisAgents(agents: [GenesisAgentState], couplingStrength: Float) : [GenesisAgentState] {
    let n = agents.size();
    if (n == 0) { return agents };
    
    // Calculate mean phase
    var sumCos = 0.0;
    var sumSin = 0.0;
    for (agent in agents.vals()) {
      sumCos += Float.cos(agent.phase);
      sumSin += Float.sin(agent.phase);
    };
    let meanPhase = Float.arctan2(sumSin, sumCos);
    
    // Calculate order parameter (coherence)
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    
    // Update each agent's phase with Kuramoto coupling
    Array.tabulate<GenesisAgentState>(n, func(i) {
      let agent = agents[i];
      let phaseDiff = meanPhase - agent.phase;
      let newPhase = wrapPhase(agent.phase + agent.frequency + couplingStrength * r * Float.sin(phaseDiff));
      {
        agentType = agent.agentType;
        activation = agent.activation * 0.95 + r * 0.05;  // Activation follows coherence
        phase = newPhase;
        frequency = agent.frequency;
        creativityLevel = agent.creativityLevel;
        chaosAffinity = agent.chaosAffinity;
        creationPower = agent.creationPower * (1.0 + r * 0.1);  // More power when coherent
        totalGenerated = agent.totalGenerated;
        lastGeneration = agent.lastGeneration;
        generationQueue = agent.generationQueue;
        weights = agent.weights;
        lastFired = agent.lastFired;
      }
    })
  };

  // Agent Hebbian learning (weights update based on co-activation)
  public func updateAgentWeights(agents: [GenesisAgentState], learningRate: Float) : [GenesisAgentState] {
    let n = agents.size();
    Array.tabulate<GenesisAgentState>(n, func(i) {
      let agent = agents[i];
      let newWeights = Array.tabulate<Float>(n, func(j) {
        if (i == j) { 0.0 }
        else {
          let otherAgent = agents[j];
          // Hebbian: "fire together, wire together"
          let coActivation = agent.activation * otherAgent.activation;
          let currentWeight = agent.weights[j];
          // Weight update with decay
          clamp(currentWeight + learningRate * coActivation - 0.001, 0.0, 1.0)
        }
      });
      {
        agentType = agent.agentType;
        activation = agent.activation;
        phase = agent.phase;
        frequency = agent.frequency;
        creativityLevel = agent.creativityLevel;
        chaosAffinity = agent.chaosAffinity;
        creationPower = agent.creationPower;
        totalGenerated = agent.totalGenerated;
        lastGeneration = agent.lastGeneration;
        generationQueue = agent.generationQueue;
        weights = Array.thaw(newWeights);
        lastFired = agent.lastFired;
      }
    })
  };

  // ==========================================================================
  // ECOLOGICAL SIMULATION — Fibonacci-based ecosystem dynamics
  // ==========================================================================

  public type EcosystemState = {
    populations: [PopulationState];
    totalBiomass: Float;
    biodiversity: Float;
    stability: Float;
  };

  public type PopulationState = {
    speciesId: Nat;
    speciesName: Text;
    population: Float;
    growthRate: Float;
    carryingCapacity: Float;
    trophicLevel: Nat;  // 1=producer, 2=herbivore, 3=carnivore
  };

  // Lotka-Volterra predator-prey dynamics
  public func updateEcosystem(eco: EcosystemState, dt: Float) : EcosystemState {
    let n = eco.populations.size();
    let newPops = Array.tabulate<PopulationState>(n, func(i) {
      let pop = eco.populations[i];
      var dN = pop.growthRate * pop.population * (1.0 - pop.population / pop.carryingCapacity);
      
      // Add predation effects
      for (j in Array.keys(eco.populations)) {
        if (j != i) {
          let otherPop = eco.populations[j];
          if (otherPop.trophicLevel > pop.trophicLevel) {
            // This species is prey
            dN -= 0.01 * pop.population * otherPop.population;
          } else if (otherPop.trophicLevel < pop.trophicLevel and pop.trophicLevel > 1) {
            // This species is predator
            dN += 0.005 * pop.population * otherPop.population;
          };
        };
      };
      
      let newPopulation = Float.max(0.0, pop.population + dN * dt);
      {
        speciesId = pop.speciesId;
        speciesName = pop.speciesName;
        population = newPopulation;
        growthRate = pop.growthRate;
        carryingCapacity = pop.carryingCapacity;
        trophicLevel = pop.trophicLevel;
      }
    });
    
    // Calculate ecosystem metrics
    var totalBio = 0.0;
    var diversity = 0.0;
    for (pop in newPops.vals()) {
      totalBio += pop.population;
      if (pop.population > 0.0) {
        let p = pop.population / totalBio;
        diversity -= p * Float.log(p);  // Shannon entropy
      };
    };
    
    {
      populations = newPops;
      totalBiomass = totalBio;
      biodiversity = diversity;
      stability = 1.0 - Float.abs(totalBio - eco.totalBiomass) / (eco.totalBiomass + 0.001);
    }
  };

  // ==========================================================================
  // WEATHER SYSTEM ORGANISM — Weather as a cognitive system
  // ==========================================================================

  public type WeatherOrganismState = {
    // Kuramoto oscillators for pressure systems
    pressureSystems: [PressureSystem];
    
    // Global weather coherence
    coherence: Float;
    
    // Neurochemistry analogs
    heat: Float;           // Energy = temperature
    moisture: Float;       // Water content
    instability: Float;    // Atmospheric instability
    
    // Hebbian learned patterns
    patternWeights: [Float];
  };

  public type PressureSystem = {
    id: Nat;
    systemType: { #High; #Low };
    centerX: Float;
    centerY: Float;
    phase: Float;
    omega: Float;
    strength: Float;
    radius: Float;
  };

  public func tickWeatherOrganism(state: WeatherOrganismState, worldHeat: Float) : WeatherOrganismState {
    let n = state.pressureSystems.size();
    if (n == 0) { return state };
    
    // Kuramoto coupling between pressure systems
    var sumCos = 0.0;
    var sumSin = 0.0;
    for (sys in state.pressureSystems.vals()) {
      sumCos += Float.cos(sys.phase);
      sumSin += Float.sin(sys.phase);
    };
    let meanPhase = Float.arctan2(sumSin, sumCos);
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    
    let K = 0.3;  // Coupling strength
    let newSystems = Array.tabulate<PressureSystem>(n, func(i) {
      let sys = state.pressureSystems[i];
      let phaseDiff = meanPhase - sys.phase;
      let newPhase = wrapPhase(sys.phase + sys.omega + K * r * Float.sin(phaseDiff));
      
      // Move pressure systems
      let moveSpeed = switch (sys.systemType) { case (#Low) { 0.001 }; case (#High) { 0.0005 } };
      let newX = sys.centerX + moveSpeed * Float.cos(sys.phase);
      let newY = sys.centerY + moveSpeed * Float.sin(sys.phase);
      
      {
        id = sys.id;
        systemType = sys.systemType;
        centerX = if (newX < 0.0) { newX + 1.0 } else if (newX > 1.0) { newX - 1.0 } else { newX };
        centerY = if (newY < 0.0) { newY + 1.0 } else if (newY > 1.0) { newY - 1.0 } else { newY };
        phase = newPhase;
        omega = sys.omega;
        strength = sys.strength * 0.999;  // Decay
        radius = sys.radius;
      }
    });
    
    {
      pressureSystems = newSystems;
      coherence = r;
      heat = state.heat * 0.99 + worldHeat * 0.01;
      moisture = state.moisture;
      instability = (1.0 - r) * 0.5 + state.heat * state.moisture * 0.5;
      patternWeights = state.patternWeights;
    }
  };

  // ==========================================================================
  // WORLD EVENT GENERATION — Macro scenarios emerge
  // ==========================================================================

  public type ScenarioOrganism = {
    tension: Float;
    creativity: Float;
    activeScenarios: [ActiveScenario];
    scenarioWeights: [Float];  // Hebbian weights for scenario types
  };

  public type ActiveScenario = {
    id: Nat;
    scenarioType: Text;
    position: (Float, Float, Float);
    intensity: Float;
    duration: Nat;
    elapsed: Nat;
    effects: [Text];
  };

  public func shouldGenerateScenario(organism: ScenarioOrganism, worldTension: Float) : Bool {
    // Generate scenarios when:
    // 1. Tension is low (need excitement)
    // 2. Creativity is high
    // 3. Fibonacci timing
    let tensionTrigger = worldTension < 0.3;
    let creativityTrigger = organism.creativity > 0.7;
    tensionTrigger or creativityTrigger
  };

  public func generateScenario(
    organism: ScenarioOrganism,
    position: (Float, Float, Float),
    seed: Nat32
  ) : ActiveScenario {
    // Select scenario type based on Hebbian weights
    let scenarioTypes = ["symmetric_warfare", "asymmetric_warfare", "natural_disaster", "resource_crisis", "migration"];
    let hash = Nat32.toNat(seed) % scenarioTypes.size();
    
    {
      id = Nat32.toNat(seed);
      scenarioType = scenarioTypes[hash];
      position = position;
      intensity = 0.5 + Float.fromInt(Nat32.toNat(seed) % 50) / 100.0;
      duration = 100 + Nat32.toNat(seed) % 900;  // 100-1000 beats
      elapsed = 0;
      effects = [];
    }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  func initGenesisAgent(agentType: GenesisAgentType, idx: Nat) : GenesisAgentState {
    let freq = 0.05 + Float.fromInt(idx) * 0.01;
    {
      agentType = agentType;
      activation = 0.5;
      phase = Float.fromInt(idx) * TWO_PI / 8.0;
      frequency = freq;
      creativityLevel = 0.7;
      chaosAffinity = 0.3 + Float.fromInt(idx % 4) * 0.1;
      creationPower = 0.5;
      totalGenerated = 0;
      lastGeneration = null;
      generationQueue = [];
      weights = Array.init<Float>(GENESIS_AGENT_COUNT, 0.1);
      lastFired = 0;
    }
  };

  public func initCreationEngine(seed: Nat32) : CreationEngineState {
    let agents = [
      initGenesisAgent(#Alpha, 0),
      initGenesisAgent(#Beta, 1),
      initGenesisAgent(#Gamma, 2),
      initGenesisAgent(#Delta, 3),
      initGenesisAgent(#Epsilon, 4),
      initGenesisAgent(#Zeta, 5),
      initGenesisAgent(#Eta, 6),
      initGenesisAgent(#Theta, 7)
    ];
    
    {
      agents = agents;
      worldCoherence = SIGMA_ZERO;
      worldPhase = 0.0;
      worldFrequency = 0.05;
      chaosCreation = {
        cycleNumber = 0;
        currentPhase = #Chaos;
        phaseProgress = 0.0;
        chaosLevel = 0.5;
        creationLevel = 0.1;
        entropy = 0.5;
        order = 0.5;
        cycleOutput = 0.0;
        peakReached = false;
        beatInCycle = 0;
      };
      totalCycles = 0;
      cumulativeOutput = 0.0;
      pendingRequests = [];
      completedRequests = 0;
      worldSeed = seed;
      timeState = {
        worldAge = 0;
        dayOfYear = 80.0;           // Start in spring
        timeOfDay = 6.0;            // Dawn
        season = #Spring;
        moonPhase = 0.0;
        sunPosition = (1.0, 0.0);
        dayLength = 12.0;
      };
      beatNum = 0;
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
  //  E C O N O M I C   &   G O V E R N A N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Economic and Governance Algorithms
  //  Full HIM/HER Dual-Organism Economic Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // TOKEN ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Token value from supply/demand
  public func economicTokenValue(
    demand : Float,
    supply : Float,
    baseValue : Float
  ) : Float {
    if (supply < 0.0001) { baseValue * 10.0 }
    else { baseValue * (demand / supply) }
  };

  /// Staking reward calculation
  public func economicStakingReward(
    stakedAmount : Float,
    stakingDuration : Nat,
    rewardRate : Float,
    bonusMultiplier : Float
  ) : Float {
    let durationBonus = Float.log(Float.fromInt(stakingDuration + 1));
    stakedAmount * rewardRate * (1.0 + durationBonus * bonusMultiplier)
  };

  /// Liquidity pool share
  public func economicLPShare(
    userLiquidity : Float,
    totalLiquidity : Float
  ) : Float {
    if (totalLiquidity < 0.0001) { 0.0 }
    else { userLiquidity / totalLiquidity }
  };

  /// Automated market maker price impact
  public func economicAMMPriceImpact(
    tradeSize : Float,
    poolSize : Float,
    k : Float
  ) : Float {
    let newPool = poolSize + tradeSize;
    let counterPool = k / newPool;
    Float.abs(counterPool - k / poolSize) / (k / poolSize)
  };

  /// Inflation rate calculation
  public func economicInflationRate(
    newSupply : Float,
    currentSupply : Float
  ) : Float {
    if (currentSupply < 0.0001) { 0.0 }
    else { (newSupply - currentSupply) / currentSupply }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GOVERNANCE MECHANICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quadratic voting power
  public func governanceQuadraticVotes(tokens : Float) : Float {
    Float.sqrt(tokens)
  };

  /// Conviction voting weight
  public func governanceConvictionWeight(
    tokens : Float,
    time : Float,
    halfLife : Float
  ) : Float {
    tokens * (1.0 - Float.exp(-time / halfLife))
  };

  /// Quorum calculation
  public func governanceQuorumReached(
    votesFor : Float,
    votesAgainst : Float,
    totalSupply : Float,
    quorumThreshold : Float
  ) : Bool {
    let totalVotes = votesFor + votesAgainst;
    totalVotes / totalSupply >= quorumThreshold
  };

  /// Proposal passing check
  public func governanceProposalPasses(
    votesFor : Float,
    votesAgainst : Float,
    passThreshold : Float
  ) : Bool {
    let total = votesFor + votesAgainst;
    if (total < 0.0001) { false }
    else { votesFor / total >= passThreshold }
  };

  /// Delegation weight calculation
  public func governanceDelegationWeight(
    directPower : Float,
    delegatedPower : Float,
    delegatorCount : Nat
  ) : Float {
    let delegationBonus = Float.log(Float.fromInt(delegatorCount + 1)) * 0.1;
    directPower + delegatedPower * (1.0 + delegationBonus)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BEHAVIORAL ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Prospect theory value function
  public func economicProspectValue(
    outcome : Float,
    reference : Float,
    lossAversion : Float
  ) : Float {
    let x = outcome - reference;
    if (x >= 0.0) {
      Float.pow(x, 0.88)
    } else {
      -lossAversion * Float.pow(-x, 0.88)
    }
  };

  /// Probability weighting
  public func economicProbabilityWeight(p : Float, delta : Float) : Float {
    let pDelta = Float.pow(p, delta);
    pDelta / Float.pow(pDelta + Float.pow(1.0 - p, delta), 1.0 / delta)
  };

  /// Hyperbolic discounting
  public func economicHyperbolicDiscount(
    value : Float,
    delay : Float,
    k : Float
  ) : Float {
    value / (1.0 + k * delay)
  };

  /// Social preference utility
  public func economicSocialUtility(
    ownPayoff : Float,
    otherPayoff : Float,
    altruism : Float,
    envy : Float
  ) : Float {
    let comparison = otherPayoff - ownPayoff;
    if (comparison > 0.0) {
      ownPayoff - envy * comparison
    } else {
      ownPayoff + altruism * (-comparison)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INSURANCE & RISK
  // ─────────────────────────────────────────────────────────────────────────────

  /// Expected loss calculation
  public func economicExpectedLoss(
    probability : Float,
    severity : Float
  ) : Float {
    probability * severity
  };

  /// Premium calculation
  public func economicPremium(
    expectedLoss : Float,
    loadingFactor : Float,
    expenses : Float
  ) : Float {
    expectedLoss * (1.0 + loadingFactor) + expenses
  };

  /// Risk pooling benefit
  public func economicRiskPoolingBenefit(
    individualVariance : Float,
    poolSize : Nat,
    correlation : Float
  ) : Float {
    let n = Float.fromInt(poolSize);
    let pooledVariance = individualVariance * (1.0 + (n - 1.0) * correlation) / n;
    individualVariance - pooledVariance
  };

  /// Value at Risk (simplified)
  public func economicVaR(
    mean : Float,
    stdDev : Float,
    confidenceMultiplier : Float
  ) : Float {
    mean - confidenceMultiplier * stdDev
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE ALLOCATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Cobb-Douglas production
  public func economicCobbDouglas(
    labor : Float,
    capital : Float,
    alpha : Float,
    productivity : Float
  ) : Float {
    productivity * Float.pow(labor, alpha) * Float.pow(capital, 1.0 - alpha)
  };

  /// Marginal utility
  public func economicMarginalUtility(
    quantity : Float,
    diminishingFactor : Float
  ) : Float {
    1.0 / Float.pow(quantity + 1.0, diminishingFactor)
  };

  /// Nash bargaining solution
  public func economicNashBargaining(
    u1 : Float,
    u2 : Float,
    d1 : Float,
    d2 : Float
  ) : Float {
    (u1 - d1) * (u2 - d2)
  };

  /// Shapley value contribution
  public func economicShapleyContribution(
    marginalContributions : [Float]
  ) : Float {
    if (marginalContributions.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < marginalContributions.size()) {
      sum += marginalContributions[i];
      i += 1;
    };
    sum / Float.fromInt(marginalContributions.size())
  };

}
