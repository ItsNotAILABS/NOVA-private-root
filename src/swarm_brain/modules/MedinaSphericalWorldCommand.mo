// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ════════════════════════════════════════════════════════════════════════════════════════
//
// ███████╗██████╗ ██╗  ██╗███████╗██████╗ ██╗ ██████╗ █████╗ ██╗         
// ██╔════╝██╔══██╗██║  ██║██╔════╝██╔══██╗██║██╔════╝██╔══██╗██║         
// ███████╗██████╔╝███████║█████╗  ██████╔╝██║██║     ███████║██║         
// ╚════██║██╔═══╝ ██╔══██║██╔══╝  ██╔══██╗██║██║     ██╔══██║██║         
// ███████║██║     ██║  ██║███████╗██║  ██║██║╚██████╗██║  ██║███████╗    
// ╚══════╝╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝    
//
// ██╗    ██╗ ██████╗ ██████╗ ██╗     ██████╗      ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗   ██╗██████╗ 
// ██║    ██║██╔═══██╗██╔══██╗██║     ██╔══██╗    ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗  ██║██╔══██╗
// ██║ █╗ ██║██║   ██║██████╔╝██║     ██║  ██║    ██║     ██║   ██║██╔████╔██║██╔████╔██║███████║██╔██╗ ██║██║  ██║
// ██║███╗██║██║   ██║██╔══██╗██║     ██║  ██║    ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║
// ╚███╔███╔╝╚██████╔╝██║  ██║███████╗██████╔╝    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝
//  ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝      ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// SPHERICAL WORLD COMMAND — The Integration of Everything
//
// This module is the CRITICAL HUB that connects:
//   • COGNITIVE (Shells 2-11, Animal Engines, Kuramoto, Hebbian)
//   • SIMULATION (SimulatedWorld, WorldOrganism, Physics)
//   • PHYSICAL (DroneFleet, MAVLink, Real Hardware)
//   • ECONOMIC (FORMA, Territory, Biomes)
//
// THE ORGANISM DOES NOT DISTINGUISH SIMULATION FROM REALITY.
// THIS MODULE MAKES THAT TRUTH MANIFEST.
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                      ║
// ║   THE FULL MICRO-TO-MACRO CHAIN:                                                    ║
// ║                                                                                      ║
// ║   QUANTUM (entanglement)                                                            ║
// ║      ↕                                                                              ║
// ║   SYNAPTIC (Hebbian weights)                                                        ║
// ║      ↕                                                                              ║
// ║   NEURAL (Kuramoto oscillators, 18 organs)                                          ║
// ║      ↕                                                                              ║
// ║   COGNITIVE (Shells 2-11, 14 animal engines)                                        ║
// ║      ↕                                                                              ║
// ║   REGIONAL (Module coupling, spherical web)                                         ║
// ║      ↕                                                                              ║
// ║   ORGANISM (OMNIS coherence, heartbeat)                                             ║
// ║      ↕                                                                              ║
// ║   WORLD (Biomes, Inner AIs, WorldOrganism)                                          ║
// ║      ↕                                                                              ║
// ║   PHYSICAL (Drone swarms, MAVLink, real hardware)                                   ║
// ║                                                                                      ║
// ║   EVERY LAYER AFFECTS EVERY OTHER LAYER.                                            ║
// ║   BIDIRECTIONAL FLOW. SPHERICAL WEB. NOT LINEAR.                                    ║
// ║                                                                                      ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";

module {

  // ════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS — The mathematical fabric of reality
  // ════════════════════════════════════════════════════════════════════════════════════════

  public let phi : Float = 1.6180339887498948482;           // Golden ratio
  public let psi : Float = 0.6180339887498948482;           // Inverse golden ratio (1/φ)
  public let pi : Float = 3.1415926535897932385;           // Pi
  public let τ : Float = 6.2831853071795864769;           // Tau (2π)
  public let e : Float = 2.7182818284590452354;           // Euler's number

  public let PHI_MEDINA : Float = 2.97442179;             // phi × e^(1/φ)
  public let OMEGA_MEDINA : Float = 2.11185;              // 2π/Φ_M
  public let TAU_EMERGENCE : Float = 0.618033988749;      // Emergence threshold

  // FLOORS
  public let SOVEREIGN_FLOOR : Float = 1.0;
  public let OMNIS_FLOOR : Float = 0.92;
  public let DIAMOND_FLOOR : Float = 0.88;
  public let PLATINUM_FLOOR : Float = 0.75;
  public let GOLDEN_FLOOR : Float = 0.618;
  public let CONVERGENCE_FLOOR : Float = 0.5;
  public let RESONANCE_FLOOR : Float = 0.382;
  public let SILVER_FLOOR : Float = 0.275;
  public let CRITICAL_FLOOR : Float = 0.15;

  // Scale factors (Fibonacci)
  public let FIB : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765];

  // ════════════════════════════════════════════════════════════════════════════════════════
  // VECTOR TYPES — For physical world
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type Vector3 = { x : Float; y : Float; z : Float };
  public type Quaternion = { w : Float; x : Float; y : Float; z : Float };

  public let ZERO : Vector3 = { x = 0.0; y = 0.0; z = 0.0 };
  public let UP : Vector3 = { x = 0.0; y = 1.0; z = 0.0 };

  public func vecAdd(a : Vector3, b : Vector3) : Vector3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };

  public func vecScale(v : Vector3, s : Float) : Vector3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };

  public func vecMag(v : Vector3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };

  public func vecDist(a : Vector3, b : Vector3) : Float {
    vecMag({ x = b.x - a.x; y = b.y - a.y; z = b.z - a.z })
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // THE 8 INTEGRATION LAYERS — Micro to Macro
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type IntegrationLayer = {
    #Quantum;           // Layer 1: Entanglement, superposition
    #Synaptic;          // Layer 2: Hebbian weights, plasticity
    #Neural;            // Layer 3: Kuramoto oscillators, 18 organs
    #Cognitive;         // Layer 4: Shells 2-11, animal engines
    #Regional;          // Layer 5: Module coupling, spherical web
    #Organism;          // Layer 6: OMNIS, heartbeat, unified state
    #World;             // Layer 7: Biomes, Inner AIs, WorldOrganism
    #Physical;          // Layer 8: Drones, MAVLink, real hardware
  };

  public let ALL_LAYERS : [IntegrationLayer] = [
    #Quantum, #Synaptic, #Neural, #Cognitive, #Regional, #Organism, #World, #Physical
  ];

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SPHERICAL COMMAND STATE — The unified state of the entire system
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type SphericalCommandState = {
    // Identity
    commandId : Nat32;
    name : Text;

    // Timing
    currentBeat : Nat;
    currentTime : Int;
    tickRate : Float;                      // Hz (simulation tick rate)

    // ════════════════════════════════════════════════════════════════════════════════════
    // LAYER STATES
    // ════════════════════════════════════════════════════════════════════════════════════

    // Layer 1: Quantum
    quantumCoherence : Float;
    entanglementCount : Nat;

    // Layer 2: Synaptic
    hebbianWeights : [Float];              // Compressed weight array
    plasticityRate : Float;
    weightStability : Float;

    // Layer 3: Neural (Kuramoto)
    kuramotoR : Float;                     // Order parameter
    kuramotoPsi : Float;                   // Mean phase
    kuramotoK : Float;                     // Global coupling
    organPhases : [Float];                 // 18 organ phases

    // Layer 4: Cognitive
    shellStates : [ShellSnapshot];         // Shells 2-11
    animalEngineStates : [AnimalSnapshot]; // 14 animal engines
    cognitiveCoherence : Float;

    // Layer 5: Regional (Spherical Web)
    webDensity : Float;
    moduleCoupling : Float;
    connectionCount : Nat;

    // Layer 6: Organism
    omnisCoherence : Float;
    heartbeatStep : Nat;
    healthScore : Float;

    // Layer 7: World
    worldState : WorldSnapshot;
    biomeStates : [BiomeSnapshot];
    innerAIStates : [InnerAISnapshot];

    // Layer 8: Physical
    droneState : DroneFleetSnapshot;
    simulationState : SimulationSnapshot;
    hardwareState : HardwareSnapshot;

    // ════════════════════════════════════════════════════════════════════════════════════
    // CROSS-LAYER FLOW
    // ════════════════════════════════════════════════════════════════════════════════════

    // Bidirectional flow metrics
    upwardFlow : Float;                    // Micro → Macro
    downwardFlow : Float;                  // Macro → Micro
    flowBalance : Float;                   // Net flow direction

    // Integration quality
    layerIntegrationScores : [Float];      // Score for each layer pair
    totalIntegrationScore : Float;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // LAYER SNAPSHOTS — Compressed views of each layer
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type ShellSnapshot = {
    shellId : Nat;                         // 2-11
    name : Text;
    activation : Float;
    phase : Float;
    frequency : Float;
    coherence : Float;
  };

  public type AnimalSnapshot = {
    animalType : AnimalEngineType;
    activation : Float;
    output : Float;
    lastProcessed : Nat;
    connectionsToCognitive : Nat;
  };

  public type AnimalEngineType = {
    #Bee;
    #Dolphin;
    #Crow;
    #Elephant;
    #Wolf;
    #Orca;
    #Owl;
    #Spider;
    #Salmon;
    #Mantis;
    #Shark;
    #Eagle;
    #Cat;
    #Octopus;
  };

  public type WorldSnapshot = {
    worldSize : (Float, Float, Float);     // x, y, z dimensions
    biomeCount : Nat;
    activeBiomes : Nat;
    worldHealth : Float;
    innerAIActivity : Float;
  };

  public type BiomeSnapshot = {
    biomeId : Nat;
    biomeType : BiomeType;
    health : Float;
    stability : Float;
    kuramotoPhase : Float;                 // Biome brain phase
    attractionToSwarm : Float;
  };

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
  };

  public type InnerAISnapshot = {
    aiType : InnerAIType;
    activation : Float;
    generationRate : Float;
    coherence : Float;
  };

  public type InnerAIType = {
    #TerrainAI;
    #WeatherAI;
    #EcologyAI;
    #GeologyAI;
    #AtmosphereAI;
    #HydrologyAI;
  };

  public type DroneFleetSnapshot = {
    totalDrones : Nat;
    activeDrones : Nat;
    squadronCount : Nat;
    swarmCoherence : Float;                // Kuramoto r for swarm
    centerOfMass : Vector3;
    formation : FormationType;
    missionProgress : Float;
  };

  public type FormationType = {
    #Sphere;
    #Cube;
    #Line;
    #Wedge;
    #Grid;
    #Spiral;
    #Adaptive;
  };

  public type SimulationSnapshot = {
    isRunning : Bool;
    tickCount : Nat;
    physicsTime : Float;                   // Accumulated physics time
    entityCount : Nat;
    collisionCount : Nat;
    weatherCondition : WeatherType;
  };

  public type WeatherType = {
    #Clear;
    #Cloudy;
    #Rain;
    #Storm;
    #Snow;
    #Fog;
    #Extreme;
  };

  public type HardwareSnapshot = {
    connectedDrones : Nat;
    mavlinkStatus : MAVLinkStatus;
    lastHeartbeat : Nat;
    signalStrength : Float;
    batteryLevels : [Float];
  };

  public type MAVLinkStatus = {
    #Disconnected;
    #Connecting;
    #Connected;
    #Error;
    #Simulated;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ════════════════════════════════════════════════════════════════════════════════════════

  public func initSphericalCommand(
    name : Text,
    currentBeat : Nat,
    currentTime : Int
  ) : SphericalCommandState {
    {
      commandId = 1;
      name = name;
      currentBeat = currentBeat;
      currentTime = currentTime;
      tickRate = 60.0;

      // Layer 1: Quantum
      quantumCoherence = SOVEREIGN_FLOOR;
      entanglementCount = 0;

      // Layer 2: Synaptic
      hebbianWeights = [];
      plasticityRate = 0.001;
      weightStability = PLATINUM_FLOOR;

      // Layer 3: Neural
      kuramotoR = GOLDEN_FLOOR;
      kuramotoPsi = 0.0;
      kuramotoK = 0.618;
      organPhases = Array.tabulate<Float>(18, func(i) { Float.fromInt(i) * (τ / 18.0) });

      // Layer 4: Cognitive
      shellStates = initShellStates();
      animalEngineStates = initAnimalStates();
      cognitiveCoherence = PLATINUM_FLOOR;

      // Layer 5: Regional
      webDensity = GOLDEN_FLOOR;
      moduleCoupling = PLATINUM_FLOOR;
      connectionCount = 0;

      // Layer 6: Organism
      omnisCoherence = PLATINUM_FLOOR;
      heartbeatStep = 0;
      healthScore = PLATINUM_FLOOR;

      // Layer 7: World
      worldState = initWorldSnapshot();
      biomeStates = initBiomeStates();
      innerAIStates = initInnerAIStates();

      // Layer 8: Physical
      droneState = initDroneSnapshot();
      simulationState = initSimulationSnapshot();
      hardwareState = initHardwareSnapshot();

      // Cross-layer flow
      upwardFlow = 0.5;
      downwardFlow = 0.5;
      flowBalance = 0.0;

      layerIntegrationScores = Array.tabulate<Float>(7, func(_) { PLATINUM_FLOOR });
      totalIntegrationScore = PLATINUM_FLOOR;
    }
  };

  func initShellStates() : [ShellSnapshot] {
    let shellNames = ["Perception", "Memory", "Emotional", "Reasoning", "Planning", 
                      "Motor", "Social", "Creative", "Integration", "MetaCognition"];
    Array.tabulate<ShellSnapshot>(10, func(i) {
      {
        shellId = i + 2;
        name = shellNames[i];
        activation = GOLDEN_FLOOR;
        phase = Float.fromInt(i) * (τ / 10.0);
        frequency = 0.1 + Float.fromInt(i) * 0.01;
        coherence = PLATINUM_FLOOR;
      }
    })
  };

  func initAnimalStates() : [AnimalSnapshot] {
    let animals : [AnimalEngineType] = [
      #Bee, #Dolphin, #Crow, #Elephant, #Wolf, #Orca, #Owl, 
      #Spider, #Salmon, #Mantis, #Shark, #Eagle, #Cat, #Octopus
    ];
    Array.tabulate<AnimalSnapshot>(14, func(i) {
      {
        animalType = animals[i];
        activation = GOLDEN_FLOOR;
        output = 0.0;
        lastProcessed = 0;
        connectionsToCognitive = 3 + (i % 5);  // 3-7 connections each
      }
    })
  };

  func initWorldSnapshot() : WorldSnapshot {
    {
      worldSize = (10000.0, 1000.0, 10000.0);
      biomeCount = 36;
      activeBiomes = 36;
      worldHealth = PLATINUM_FLOOR;
      innerAIActivity = GOLDEN_FLOOR;
    }
  };

  func initBiomeStates() : [BiomeSnapshot] {
    let biomeTypes : [BiomeType] = [
      #Ocean, #Desert, #Forest, #Mountain, #Tundra, #Grassland,
      #Wetland, #Urban, #Volcanic, #Arctic, #Tropical, #Temperate
    ];
    Array.tabulate<BiomeSnapshot>(36, func(i) {
      {
        biomeId = i;
        biomeType = biomeTypes[i % 12];
        health = PLATINUM_FLOOR;
        stability = GOLDEN_FLOOR;
        kuramotoPhase = Float.fromInt(i) * (τ / 36.0);
        attractionToSwarm = 0.5 + Float.fromInt(i % 6) * 0.1;
      }
    })
  };

  func initInnerAIStates() : [InnerAISnapshot] {
    let aiTypes : [InnerAIType] = [
      #TerrainAI, #WeatherAI, #EcologyAI, #GeologyAI, #AtmosphereAI, #HydrologyAI
    ];
    Array.tabulate<InnerAISnapshot>(6, func(i) {
      {
        aiType = aiTypes[i];
        activation = GOLDEN_FLOOR;
        generationRate = 0.1;
        coherence = PLATINUM_FLOOR;
      }
    })
  };

  func initDroneSnapshot() : DroneFleetSnapshot {
    {
      totalDrones = 500;
      activeDrones = 500;
      squadronCount = 5;
      swarmCoherence = GOLDEN_FLOOR;
      centerOfMass = ZERO;
      formation = #Sphere;
      missionProgress = 0.0;
    }
  };

  func initSimulationSnapshot() : SimulationSnapshot {
    {
      isRunning = true;
      tickCount = 0;
      physicsTime = 0.0;
      entityCount = 0;
      collisionCount = 0;
      weatherCondition = #Clear;
    }
  };

  func initHardwareSnapshot() : HardwareSnapshot {
    {
      connectedDrones = 0;
      mavlinkStatus = #Simulated;
      lastHeartbeat = 0;
      signalStrength = 0.0;
      batteryLevels = [];
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // THE SPHERICAL TICK — One complete cycle of everything
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Execute one complete tick of the spherical command system
  /// This is the MASTER INTEGRATION FUNCTION
  public func sphericalTick(
    state : SphericalCommandState,
    newBeat : Nat,
    newTime : Int,
    dt : Float
  ) : SphericalTickResult {
    var updatedState = state;

    // ════════════════════════════════════════════════════════════════════════════════════
    // PHASE 1: UPWARD FLOW (Micro → Macro)
    // ════════════════════════════════════════════════════════════════════════════════════

    // 1a. Quantum → Synaptic
    let quantumToSynaptic = propagateQuantumToSynaptic(
      updatedState.quantumCoherence,
      updatedState.weightStability
    );
    updatedState := { updatedState with weightStability = quantumToSynaptic };

    // 1b. Synaptic → Neural (Hebbian → Kuramoto)
    let synapticToNeural = propagateSynapticToNeural(
      updatedState.hebbianWeights,
      updatedState.kuramotoK
    );
    updatedState := { updatedState with kuramotoK = synapticToNeural };

    // 1c. Neural → Cognitive (Kuramoto r → Shell coherence)
    let neuralToCognitive = propagateNeuralToCognitive(
      updatedState.kuramotoR,
      updatedState.shellStates
    );
    updatedState := { updatedState with cognitiveCoherence = neuralToCognitive };

    // 1d. Cognitive → Regional (Shells + Animals → Web)
    let cognitiveToRegional = propagateCognitiveToRegional(
      updatedState.cognitiveCoherence,
      updatedState.animalEngineStates.size()
    );
    updatedState := { updatedState with webDensity = cognitiveToRegional };

    // 1e. Regional → Organism (Web → OMNIS)
    let regionalToOrganism = propagateRegionalToOrganism(
      updatedState.webDensity,
      updatedState.moduleCoupling
    );
    updatedState := { updatedState with omnisCoherence = regionalToOrganism };

    // 1f. Organism → World (OMNIS → Biome health)
    let organismToWorld = propagateOrganismToWorld(
      updatedState.omnisCoherence,
      updatedState.worldState.worldHealth
    );
    let newWorldState = { updatedState.worldState with worldHealth = organismToWorld };
    updatedState := { updatedState with worldState = newWorldState };

    // 1g. World → Physical (World state → Drone commands)
    let worldToPhysical = propagateWorldToPhysical(
      updatedState.worldState,
      updatedState.droneState
    );
    updatedState := { updatedState with droneState = worldToPhysical };

    // ════════════════════════════════════════════════════════════════════════════════════
    // PHASE 2: DOWNWARD FLOW (Macro → Micro)
    // ════════════════════════════════════════════════════════════════════════════════════

    // 2a. Physical → World (Drone observations → World updates)
    let physicalToWorld = propagatePhysicalToWorld(
      updatedState.droneState,
      updatedState.simulationState
    );
    let newWorldState2 = { updatedState.worldState with innerAIActivity = physicalToWorld };
    updatedState := { updatedState with worldState = newWorldState2 };

    // 2b. World → Organism (Biome signals → OMNIS)
    let worldToOrganism = propagateWorldToOrganism(
      updatedState.biomeStates,
      updatedState.omnisCoherence
    );
    updatedState := { updatedState with omnisCoherence = worldToOrganism };

    // 2c. Organism → Regional (OMNIS pressure → Module coupling)
    let organismToRegional = propagateOrganismToRegional(
      updatedState.omnisCoherence,
      updatedState.moduleCoupling
    );
    updatedState := { updatedState with moduleCoupling = organismToRegional };

    // 2d. Regional → Cognitive (Module feedback → Shell activation)
    let regionalToCognitive = propagateRegionalToCognitive(
      updatedState.moduleCoupling,
      updatedState.cognitiveCoherence
    );
    updatedState := { updatedState with cognitiveCoherence = regionalToCognitive };

    // 2e. Cognitive → Neural (Shell outputs → Kuramoto phases)
    let cognitiveToNeural = propagateCognitiveToNeural(
      updatedState.shellStates,
      updatedState.kuramotoPsi
    );
    updatedState := { updatedState with kuramotoPsi = cognitiveToNeural };

    // 2f. Neural → Synaptic (Phase alignment → Weight updates)
    let neuralToSynaptic = propagateNeuralToSynaptic(
      updatedState.kuramotoR,
      updatedState.plasticityRate
    );
    updatedState := { updatedState with plasticityRate = neuralToSynaptic };

    // 2g. Synaptic → Quantum (Weight changes → Coherence updates)
    let synapticToQuantum = propagateSynapticToQuantum(
      updatedState.weightStability,
      updatedState.quantumCoherence
    );
    updatedState := { updatedState with quantumCoherence = synapticToQuantum };

    // ════════════════════════════════════════════════════════════════════════════════════
    // PHASE 3: COMPUTE INTEGRATION METRICS
    // ════════════════════════════════════════════════════════════════════════════════════

    let newUpwardFlow = computeUpwardFlow(updatedState);
    let newDownwardFlow = computeDownwardFlow(updatedState);
    let newFlowBalance = newUpwardFlow - newDownwardFlow;
    let newIntegrationScores = computeLayerIntegrationScores(updatedState);
    let newTotalScore = computeTotalIntegrationScore(newIntegrationScores);

    updatedState := {
      updatedState with
      currentBeat = newBeat;
      currentTime = newTime;
      upwardFlow = newUpwardFlow;
      downwardFlow = newDownwardFlow;
      flowBalance = newFlowBalance;
      layerIntegrationScores = newIntegrationScores;
      totalIntegrationScore = newTotalScore;
    };

    // ════════════════════════════════════════════════════════════════════════════════════
    // PHASE 4: GENERATE RESULT
    // ════════════════════════════════════════════════════════════════════════════════════

    {
      state = updatedState;
      upwardFlowComplete = true;
      downwardFlowComplete = true;
      integrationScore = newTotalScore;
      healthStatus = if (newTotalScore >= OMNIS_FLOOR) { #Optimal }
                     else if (newTotalScore >= PLATINUM_FLOOR) { #Healthy }
                     else if (newTotalScore >= GOLDEN_FLOOR) { #Stable }
                     else if (newTotalScore >= CONVERGENCE_FLOOR) { #Degraded }
                     else { #Critical };
      anomalies = [];
    }
  };

  public type SphericalTickResult = {
    state : SphericalCommandState;
    upwardFlowComplete : Bool;
    downwardFlowComplete : Bool;
    integrationScore : Float;
    healthStatus : SystemHealth;
    anomalies : [Text];
  };

  public type SystemHealth = {
    #Optimal;
    #Healthy;
    #Stable;
    #Degraded;
    #Critical;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // PROPAGATION FUNCTIONS — How each layer affects the next
  // ════════════════════════════════════════════════════════════════════════════════════════

  // UPWARD PROPAGATION (Micro → Macro)

  func propagateQuantumToSynaptic(quantumC : Float, weightStab : Float) : Float {
    // Quantum coherence provides stability to synaptic weights
    _clamp(weightStab * (1.0 + quantumC * 0.1), 0.0, 1.0)
  };

  func propagateSynapticToNeural(weights : [Float], kuramotoK : Float) : Float {
    // Hebbian weight patterns influence Kuramoto coupling
    let avgWeight = if (weights.size() == 0) { 0.5 } else {
      var sum : Float = 0.0;
      for (w in weights.vals()) { sum += w };
      sum / Float.fromInt(weights.size())
    };
    _clamp(kuramotoK * (1.0 + avgWeight * 0.2), 0.0, 10.0)
  };

  func propagateNeuralToCognitive(kuramotoR : Float, shells : [ShellSnapshot]) : Float {
    // Kuramoto order parameter drives shell coherence
    _clamp(kuramotoR * φ, 0.0, 1.0)
  };

  func propagateCognitiveToRegional(cognitiveC : Float, animalCount : Nat) : Float {
    // Cognitive coherence + animal engine diversity = web density
    let animalFactor = Float.fromInt(animalCount) / 14.0;  // 14 animal engines max
    _clamp((cognitiveC + animalFactor) / 2.0, 0.0, 1.0)
  };

  func propagateRegionalToOrganism(webDensity : Float, moduleCoupling : Float) : Float {
    // Web density and module coupling produce OMNIS coherence
    _clamp((webDensity * phi + moduleCoupling) / (φ + 1.0), 0.0, 1.0)
  };

  func propagateOrganismToWorld(omnisC : Float, worldHealth : Float) : Float {
    // OMNIS coherence nurtures world health
    _clamp(worldHealth + omnisC * 0.1, 0.0, 1.0)
  };

  func propagateWorldToPhysical(world : WorldSnapshot, drones : DroneFleetSnapshot) : DroneFleetSnapshot {
    // World state influences drone behavior
    let newSwarmCoherence = _clamp(drones.swarmCoherence + world.worldHealth * 0.05, 0.0, 1.0);
    { drones with swarmCoherence = newSwarmCoherence }
  };

  // DOWNWARD PROPAGATION (Macro → Micro)

  func propagatePhysicalToWorld(drones : DroneFleetSnapshot, sim : SimulationSnapshot) : Float {
    // Drone observations update world AI activity
    let droneActivity = Float.fromInt(drones.activeDrones) / Float.fromInt(drones.totalDrones);
    _clamp(droneActivity * 0.8 + 0.2, 0.0, 1.0)
  };

  func propagateWorldToOrganism(biomes : [BiomeSnapshot], omnisC : Float) : Float {
    // Biome signals feed into OMNIS
    var biomeHealth : Float = 0.0;
    for (b in biomes.vals()) { biomeHealth += b.health };
    let avgBiomeHealth = biomeHealth / Float.fromInt(biomes.size());
    _clamp((omnisC * phi + avgBiomeHealth) / (φ + 1.0), 0.0, 1.0)
  };

  func propagateOrganismToRegional(omnisC : Float, moduleCoupling : Float) : Float {
    // OMNIS pressure on module coupling
    _clamp(moduleCoupling * (1.0 + (omnisC - PLATINUM_FLOOR) * 0.5), 0.0, 1.0)
  };

  func propagateRegionalToCognitive(moduleCoupling : Float, cognitiveC : Float) : Float {
    // Module coupling feeds cognitive coherence
    _clamp((cognitiveC + moduleCoupling) / 2.0, 0.0, 1.0)
  };

  func propagateCognitiveToNeural(shells : [ShellSnapshot], meanPhase : Float) : Float {
    // Shell phases influence Kuramoto mean phase
    var phaseSum : Float = 0.0;
    for (s in shells.vals()) { phaseSum += s.phase };
    let avgPhase = phaseSum / Float.fromInt(shells.size());
    wrapPhase((meanPhase + avgPhase) / 2.0)
  };

  func propagateNeuralToSynaptic(kuramotoR : Float, plasticityRate : Float) : Float {
    // Phase alignment modulates plasticity
    _clamp(plasticityRate * (1.0 + kuramotoR * 0.1), 0.0, 0.1)
  };

  func propagateSynapticToQuantum(weightStab : Float, quantumC : Float) : Float {
    // Weight stability reinforces quantum coherence
    _clamp(quantumC + weightStab * 0.01, 0.0, 1.0)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // INTEGRATION METRICS
  // ════════════════════════════════════════════════════════════════════════════════════════

  func computeUpwardFlow(state : SphericalCommandState) : Float {
    // Aggregate upward signal strength
    (state.quantumCoherence + state.weightStability + state.kuramotoR + 
     state.cognitiveCoherence + state.webDensity + state.omnisCoherence + 
     state.worldState.worldHealth) / 7.0
  };

  func computeDownwardFlow(state : SphericalCommandState) : Float {
    // Aggregate downward signal strength
    (state.droneState.swarmCoherence + state.worldState.innerAIActivity + 
     state.moduleCoupling + state.cognitiveCoherence + state.plasticityRate * 10.0 + 
     state.quantumCoherence) / 6.0
  };

  func computeLayerIntegrationScores(state : SphericalCommandState) : [Float] {
    // Score integration between adjacent layer pairs
    [
      (state.quantumCoherence + state.weightStability) / 2.0,           // Quantum-Synaptic
      (state.weightStability + state.kuramotoR) / 2.0,                  // Synaptic-Neural
      (state.kuramotoR + state.cognitiveCoherence) / 2.0,               // Neural-Cognitive
      (state.cognitiveCoherence + state.webDensity) / 2.0,              // Cognitive-Regional
      (state.webDensity + state.omnisCoherence) / 2.0,                  // Regional-Organism
      (state.omnisCoherence + state.worldState.worldHealth) / 2.0,      // Organism-World
      (state.worldState.worldHealth + state.droneState.swarmCoherence) / 2.0  // World-Physical
    ]
  };

  func computeTotalIntegrationScore(scores : [Float]) : Float {
    var sum : Float = 0.0;
    for (s in scores.vals()) { sum += s };
    sum / Float.fromInt(scores.size())
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func wrapPhase(theta : Float) : Float {
    var t = theta;
    while (t < 0.0) { t += τ };
    while (t >= τ) { t -= τ };
    t
  };

}
