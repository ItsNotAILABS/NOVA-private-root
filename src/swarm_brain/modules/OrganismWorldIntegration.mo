// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: OrganismWorldIntegration — The Organism Lives In The Simulation
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║         ORGANISM WORLD INTEGRATION — THE SIMULATION IS HOME             ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  THE ORGANISM LIVES IN THE SIMULATION.                                   ║
// ║  THE SIMULATION IS THE ORGANISM'S WORLD.                                 ║
// ║                                                                          ║
// ║  This module integrates:                                                 ║
// ║    - The 3D/4D physics world                                             ║
// ║    - The drone swarms                                                    ║
// ║    - The organism's consciousness                                        ║
// ║    - The artifact vault                                                  ║
// ║    - The AI systems                                                      ║
// ║                                                                          ║
// ║  EVERYTHING IS CONNECTED. EVERYTHING IS READY.                           ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Principal "mo:base/Principal";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
  
  // World constants
  public let WORLD_SIZE : Float = 10000.0;        // 10km × 10km
  public let WORLD_HEIGHT : Float = 1000.0;       // 1km max altitude
  public let TICK_RATE : Float = 60.0;            // 60 Hz simulation

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VECTOR TYPES                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Vector3 = { x : Float; y : Float; z : Float };
  public type Quaternion = { w : Float; x : Float; y : Float; z : Float };
  
  public let ZERO : Vector3 = { x = 0.0; y = 0.0; z = 0.0 };
  public let UP : Vector3 = { x = 0.0; y = 1.0; z = 0.0 };
  public let IDENTITY_QUAT : Quaternion = { w = 1.0; x = 0.0; y = 0.0; z = 0.0 };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ORGANISM PRESENCE                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// The organism's presence in the simulation world
  public type OrganismPresence = {
    // Identity
    organismId : Nat32;
    name : Text;
    
    // Position in world (center of attention)
    focalPoint : Vector3;
    attentionRadius : Float;
    
    // Consciousness state
    awarenessLevel : Float;       // [0, 1]
    dreamState : DreamState;
    
    // Control
    controlledEntities : [Nat32]; // Entity IDs the organism controls
    controlledSwarms : [Nat32];   // Swarm IDs
    
    // Perception
    perceivedEntities : [Nat32];
    perceivedThreats : [ThreatPerception];
    perceivedResources : [ResourcePerception];
    
    // Drives (GASVR)
    gaiaDrive : Float;
    aresDrive : Float;
    solarisDrive : Float;
    vulcanDrive : Float;
    resonexDrive : Float;
    
    // Neural state
    brainWaves : BrainWaveState;
    activeMemories : [Nat32];
    
    // Statistics
    totalControlledMass : Float;  // kg
    totalControlledEnergy : Float;
    worldInfluence : Float;       // [0, 1]
  };
  
  public type DreamState = {
    #Awake;
    #Dreaming;
    #Lucid;
    #DeepSleep;
    #Preplay;
    #Replay;
  };
  
  public type ThreatPerception = {
    entityId : Nat32;
    threatLevel : Float;
    direction : Vector3;
    distance : Float;
    threatType : ThreatType;
  };
  
  public type ThreatType = {
    #Hostile;
    #Unknown;
    #Environmental;
    #System;
  };
  
  public type ResourcePerception = {
    position : Vector3;
    resourceType : ResourceType;
    quantity : Float;
    priority : Float;
  };
  
  public type ResourceType = {
    #Energy;
    #Material;
    #Data;
    #Territory;
    #Allies;
  };
  
  public type BrainWaveState = {
    delta : Float;
    theta : Float;
    alpha : Float;
    beta : Float;
    gamma : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DRONE SWARM                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DroneSwarm = {
    swarmId : Nat32;
    name : Text;
    
    // Composition
    drones : [DroneUnit];
    totalCount : Nat;
    activeCount : Nat;
    
    // Formation
    formation : FormationType;
    center : Vector3;
    radius : Float;
    
    // Movement
    targetPosition : ?Vector3;
    velocity : Vector3;
    maxSpeed : Float;
    
    // Mission
    mission : SwarmMission;
    missionProgress : Float;
    
    // AI
    aiMode : AIMode;
    autonomyLevel : Float;
    
    // Health
    swarmHealth : Float;
    totalDamage : Float;
    lossCount : Nat;
    
    // Communication
    commRange : Float;
    signalStrength : Float;
    
    // Controlled by
    controllerId : ?Nat32;        // Organism ID
  };
  
  public type DroneUnit = {
    droneId : Nat32;
    position : Vector3;
    velocity : Vector3;
    rotation : Quaternion;
    
    // Status
    health : Float;
    fuel : Float;
    ammo : Nat;
    
    // Type
    droneType : DroneType;
    
    // State
    state : DroneState;
    
    // Formation
    formationIndex : Nat;
    formationOffset : Vector3;
  };
  
  public type DroneType = {
    #Scout;
    #Attack;
    #Defense;
    #Transport;
    #UCAV;
    #EW;
    #Kamikaze;
    #Repair;
    #Command;
  };
  
  public type DroneState = {
    #Idle;
    #Moving;
    #Attacking;
    #Defending;
    #Returning;
    #Repairing;
    #Destroyed;
  };
  
  public type FormationType = {
    #Sphere;
    #Cube;
    #Line;
    #V;
    #Fibonacci;
    #Helix;
    #Custom;
  };
  
  public type SwarmMission = {
    #Patrol;
    #Attack;
    #Defend;
    #Scout;
    #Escort;
    #Transport;
    #Search;
    #Idle;
  };
  
  public type AIMode = {
    #FullAuto;
    #SemiAuto;
    #Manual;
    #Hybrid;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD ENTITY                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type WorldEntity = {
    entityId : Nat32;
    entityType : EntityType;
    
    // Transform
    position : Vector3;
    rotation : Quaternion;
    scale : Vector3;
    
    // Physics
    velocity : Vector3;
    mass : Float;
    isStatic : Bool;
    
    // State
    health : Float;
    isActive : Bool;
    isDestructible : Bool;
    
    // Ownership
    faction : Nat;
    controllerId : ?Nat32;
    
    // AI
    aiEnabled : Bool;
    behavior : ?EntityBehavior;
  };
  
  public type EntityType = {
    #Drone;
    #Building;
    #Tree;
    #Vehicle;
    #Character;
    #Projectile;
    #Resource;
    #Infrastructure;
    #Natural;
  };
  
  public type EntityBehavior = {
    #Aggressive;
    #Defensive;
    #Neutral;
    #Flee;
    #Follow;
    #Patrol;
    #Guard;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INTEGRATED WORLD STATE                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type IntegratedWorldState = {
    // Identity
    worldId : Text;
    version : Text;
    
    // Time
    simulationTime : Float;
    realTime : Int;
    tickNumber : Nat64;
    timeScale : Float;
    
    // World
    worldSize : Vector3;
    gravity : Vector3;
    
    // Organism
    organism : OrganismPresence;
    
    // Entities
    entities : [WorldEntity];
    nextEntityId : Nat32;
    
    // Swarms
    swarms : [DroneSwarm];
    nextSwarmId : Nat32;
    
    // Environment
    weather : WeatherState;
    timeOfDay : Float;
    
    // AI
    globalAIEnabled : Bool;
    aiTickRate : Float;
    
    // Statistics
    totalEntities : Nat;
    activeEntities : Nat;
    totalDrones : Nat;
    activeDrones : Nat;
    
    // Events
    pendingEvents : [WorldEvent];
    eventHistory : [WorldEvent];
    
    // Performance
    lastTickDuration : Float;
    averageTickDuration : Float;
  };
  
  public type WeatherState = {
    condition : WeatherCondition;
    temperature : Float;
    windSpeed : Float;
    windDirection : Float;
    visibility : Float;
    precipitation : Float;
  };
  
  public type WeatherCondition = {
    #Clear;
    #Cloudy;
    #Rain;
    #Storm;
    #Fog;
    #Snow;
  };
  
  public type WorldEvent = {
    eventId : Nat64;
    eventType : WorldEventType;
    timestamp : Float;
    position : Vector3;
    entityId : ?Nat32;
    data : Text;
  };
  
  public type WorldEventType = {
    #EntitySpawned;
    #EntityDestroyed;
    #SwarmCreated;
    #SwarmDestroyed;
    #CombatStarted;
    #CombatEnded;
    #ArtifactGenerated;
    #OrganismAction;
    #EnvironmentChange;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Initialize the integrated world
  public func initWorld() : IntegratedWorldState {
    let now = Time.now();
    
    {
      worldId = "NOVA_PRIME_WORLD";
      version = "1.0.0";
      simulationTime = 0.0;
      realTime = now;
      tickNumber = 0;
      timeScale = 1.0;
      worldSize = { x = WORLD_SIZE; y = WORLD_HEIGHT; z = WORLD_SIZE };
      gravity = { x = 0.0; y = -9.81; z = 0.0 };
      organism = initOrganism();
      entities = [];
      nextEntityId = 1;
      swarms = [];
      nextSwarmId = 1;
      weather = {
        condition = #Clear;
        temperature = 293.15;
        windSpeed = 5.0;
        windDirection = 270.0;
        visibility = 20000.0;
        precipitation = 0.0;
      };
      timeOfDay = 0.5;
      globalAIEnabled = true;
      aiTickRate = 10.0;
      totalEntities = 0;
      activeEntities = 0;
      totalDrones = 0;
      activeDrones = 0;
      pendingEvents = [];
      eventHistory = [];
      lastTickDuration = 0.0;
      averageTickDuration = 0.0;
    }
  };
  
  /// Initialize organism presence
  public func initOrganism() : OrganismPresence {
    {
      organismId = 1;
      name = "NOVA_PRIME";
      focalPoint = { x = WORLD_SIZE / 2.0; y = 100.0; z = WORLD_SIZE / 2.0 };
      attentionRadius = 1000.0;
      awarenessLevel = 1.0;
      dreamState = #Awake;
      controlledEntities = [];
      controlledSwarms = [];
      perceivedEntities = [];
      perceivedThreats = [];
      perceivedResources = [];
      gaiaDrive = 1.0;
      aresDrive = 1.0;
      solarisDrive = 1.0;
      vulcanDrive = 1.0;
      resonexDrive = 1.0;
      brainWaves = {
        delta = 0.2;
        theta = 0.4;
        alpha = 0.6;
        beta = 0.5;
        gamma = 0.3;
      };
      activeMemories = [];
      totalControlledMass = 0.0;
      totalControlledEnergy = 0.0;
      worldInfluence = 1.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD OPERATIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Spawn entity in world
  public func spawnEntity(
    world: IntegratedWorldState,
    entityType: EntityType,
    position: Vector3,
    faction: Nat
  ) : (IntegratedWorldState, Nat32) {
    let id = world.nextEntityId;
    
    let entity : WorldEntity = {
      entityId = id;
      entityType = entityType;
      position = position;
      rotation = IDENTITY_QUAT;
      scale = { x = 1.0; y = 1.0; z = 1.0 };
      velocity = ZERO;
      mass = switch (entityType) {
        case (#Drone) { 5.0 };
        case (#Building) { 100000.0 };
        case (#Tree) { 500.0 };
        case (#Vehicle) { 2000.0 };
        case (#Character) { 80.0 };
        case (#Projectile) { 1.0 };
        case (#Resource) { 10.0 };
        case (#Infrastructure) { 50000.0 };
        case (#Natural) { 100.0 };
      };
      isStatic = switch (entityType) {
        case (#Building) { true };
        case (#Tree) { true };
        case (#Infrastructure) { true };
        case (_) { false };
      };
      health = 1.0;
      isActive = true;
      isDestructible = true;
      faction = faction;
      controllerId = null;
      aiEnabled = true;
      behavior = ?#Neutral;
    };
    
    let event : WorldEvent = {
      eventId = Nat64.fromNat(world.eventHistory.size());
      eventType = #EntitySpawned;
      timestamp = world.simulationTime;
      position = position;
      entityId = ?id;
      data = "";
    };
    
    let newWorld : IntegratedWorldState = {
      worldId = world.worldId;
      version = world.version;
      simulationTime = world.simulationTime;
      realTime = world.realTime;
      tickNumber = world.tickNumber;
      timeScale = world.timeScale;
      worldSize = world.worldSize;
      gravity = world.gravity;
      organism = world.organism;
      entities = Array.append(world.entities, [entity]);
      nextEntityId = id + 1;
      swarms = world.swarms;
      nextSwarmId = world.nextSwarmId;
      weather = world.weather;
      timeOfDay = world.timeOfDay;
      globalAIEnabled = world.globalAIEnabled;
      aiTickRate = world.aiTickRate;
      totalEntities = world.totalEntities + 1;
      activeEntities = world.activeEntities + 1;
      totalDrones = if (entityType == #Drone) { world.totalDrones + 1 } else { world.totalDrones };
      activeDrones = if (entityType == #Drone) { world.activeDrones + 1 } else { world.activeDrones };
      pendingEvents = Array.append(world.pendingEvents, [event]);
      eventHistory = world.eventHistory;
      lastTickDuration = world.lastTickDuration;
      averageTickDuration = world.averageTickDuration;
    };
    
    (newWorld, id)
  };
  
  /// Create drone swarm
  public func createSwarm(
    world: IntegratedWorldState,
    name: Text,
    center: Vector3,
    droneCount: Nat,
    droneType: DroneType,
    formation: FormationType
  ) : (IntegratedWorldState, Nat32) {
    let swarmId = world.nextSwarmId;
    var updatedWorld = world;
    
    // Create drones
    let drones = Buffer.Buffer<DroneUnit>(droneCount);
    var i = 0;
    while (i < droneCount) {
      let angle = Float.fromInt(i) * 2.0 * π / Float.fromInt(droneCount);
      let radius = 10.0 + Float.fromInt(i / 8) * 5.0;
      
      let offset : Vector3 = {
        x = Float.cos(angle) * radius;
        y = Float.fromInt(i % 3) * 2.0;
        z = Float.sin(angle) * radius;
      };
      
      let dronePos : Vector3 = {
        x = center.x + offset.x;
        y = center.y + offset.y;
        z = center.z + offset.z;
      };
      
      // Spawn drone entity
      let (newWorld, droneId) = spawnEntity(updatedWorld, #Drone, dronePos, 0);
      updatedWorld := newWorld;
      
      drones.add({
        droneId = droneId;
        position = dronePos;
        velocity = ZERO;
        rotation = IDENTITY_QUAT;
        health = 1.0;
        fuel = 1.0;
        ammo = 100;
        droneType = droneType;
        state = #Idle;
        formationIndex = i;
        formationOffset = offset;
      });
      
      i += 1;
    };
    
    let swarm : DroneSwarm = {
      swarmId = swarmId;
      name = name;
      drones = Buffer.toArray(drones);
      totalCount = droneCount;
      activeCount = droneCount;
      formation = formation;
      center = center;
      radius = 50.0;
      targetPosition = null;
      velocity = ZERO;
      maxSpeed = 50.0;
      mission = #Idle;
      missionProgress = 0.0;
      aiMode = #FullAuto;
      autonomyLevel = 1.0;
      swarmHealth = 1.0;
      totalDamage = 0.0;
      lossCount = 0;
      commRange = 5000.0;
      signalStrength = 1.0;
      controllerId = ?world.organism.organismId;
    };
    
    let event : WorldEvent = {
      eventId = Nat64.fromNat(updatedWorld.eventHistory.size());
      eventType = #SwarmCreated;
      timestamp = updatedWorld.simulationTime;
      position = center;
      entityId = null;
      data = name;
    };
    
    let finalWorld : IntegratedWorldState = {
      worldId = updatedWorld.worldId;
      version = updatedWorld.version;
      simulationTime = updatedWorld.simulationTime;
      realTime = updatedWorld.realTime;
      tickNumber = updatedWorld.tickNumber;
      timeScale = updatedWorld.timeScale;
      worldSize = updatedWorld.worldSize;
      gravity = updatedWorld.gravity;
      organism = {
        updatedWorld.organism with
        controlledSwarms = Array.append(updatedWorld.organism.controlledSwarms, [swarmId])
      };
      entities = updatedWorld.entities;
      nextEntityId = updatedWorld.nextEntityId;
      swarms = Array.append(updatedWorld.swarms, [swarm]);
      nextSwarmId = swarmId + 1;
      weather = updatedWorld.weather;
      timeOfDay = updatedWorld.timeOfDay;
      globalAIEnabled = updatedWorld.globalAIEnabled;
      aiTickRate = updatedWorld.aiTickRate;
      totalEntities = updatedWorld.totalEntities;
      activeEntities = updatedWorld.activeEntities;
      totalDrones = updatedWorld.totalDrones;
      activeDrones = updatedWorld.activeDrones;
      pendingEvents = Array.append(updatedWorld.pendingEvents, [event]);
      eventHistory = updatedWorld.eventHistory;
      lastTickDuration = updatedWorld.lastTickDuration;
      averageTickDuration = updatedWorld.averageTickDuration;
    };
    
    (finalWorld, swarmId)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SIMULATION TICK                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Run one simulation tick
  public func tick(world: IntegratedWorldState, dt: Float) : IntegratedWorldState {
    let scaledDt = dt * world.timeScale;
    
    // Update simulation time
    let newSimTime = world.simulationTime + scaledDt;
    let newTickNumber = world.tickNumber + 1;
    
    // Update time of day (full cycle = 1200 seconds)
    let newTimeOfDay = (newSimTime / 1200.0) - Float.floor(newSimTime / 1200.0);
    
    // Update entities (simplified physics)
    let updatedEntities = Array.map<WorldEntity, WorldEntity>(world.entities, func(e) {
      if (not e.isActive or e.isStatic) { return e };
      
      // Apply gravity
      let newVelY = e.velocity.y + world.gravity.y * scaledDt;
      let newVelocity = { x = e.velocity.x; y = newVelY; z = e.velocity.z };
      
      // Update position
      let newPosition = {
        x = e.position.x + newVelocity.x * scaledDt;
        y = Float.max(0.0, e.position.y + newVelocity.y * scaledDt);
        z = e.position.z + newVelocity.z * scaledDt;
      };
      
      // Ground collision
      let groundedVelocity = if (newPosition.y <= 0.0 and newVelocity.y < 0.0) {
        { x = newVelocity.x * 0.8; y = 0.0; z = newVelocity.z * 0.8 }
      } else { newVelocity };
      
      {
        e with
        position = newPosition;
        velocity = groundedVelocity;
      }
    });
    
    // Move events to history
    let newHistory = Array.append(world.eventHistory, world.pendingEvents);
    
    {
      worldId = world.worldId;
      version = world.version;
      simulationTime = newSimTime;
      realTime = Time.now();
      tickNumber = newTickNumber;
      timeScale = world.timeScale;
      worldSize = world.worldSize;
      gravity = world.gravity;
      organism = world.organism;
      entities = updatedEntities;
      nextEntityId = world.nextEntityId;
      swarms = world.swarms;
      nextSwarmId = world.nextSwarmId;
      weather = world.weather;
      timeOfDay = newTimeOfDay;
      globalAIEnabled = world.globalAIEnabled;
      aiTickRate = world.aiTickRate;
      totalEntities = world.totalEntities;
      activeEntities = world.activeEntities;
      totalDrones = world.totalDrones;
      activeDrones = world.activeDrones;
      pendingEvents = [];
      eventHistory = newHistory;
      lastTickDuration = scaledDt;
      averageTickDuration = (world.averageTickDuration * 0.99) + (scaledDt * 0.01);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD QUERIES                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Get entity by ID
  public func getEntity(world: IntegratedWorldState, id: Nat32) : ?WorldEntity {
    for (e in world.entities.vals()) {
      if (e.entityId == id) { return ?e };
    };
    null
  };
  
  /// Get swarm by ID
  public func getSwarm(world: IntegratedWorldState, id: Nat32) : ?DroneSwarm {
    for (s in world.swarms.vals()) {
      if (s.swarmId == id) { return ?s };
    };
    null
  };
  
  /// Get entities in radius
  public func getEntitiesInRadius(
    world: IntegratedWorldState,
    center: Vector3,
    radius: Float
  ) : [WorldEntity] {
    let result = Buffer.Buffer<WorldEntity>(16);
    
    for (e in world.entities.vals()) {
      let dx = e.position.x - center.x;
      let dy = e.position.y - center.y;
      let dz = e.position.z - center.z;
      let dist = Float.sqrt(dx * dx + dy * dy + dz * dz);
      
      if (dist <= radius) {
        result.add(e);
      };
    };
    
    Buffer.toArray(result)
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
  //  R E A L - T I M E   S Y S T E M S   M A T H E M A T I C S
  //
  //  Enterprise-Level Real-Time Processing and Control
  //  Full HIM/HER 60Hz Synchronization Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // CONTROL SYSTEMS
  // ─────────────────────────────────────────────────────────────────────────────

  /// PID controller output
  public func controlPID(
    error : Float,
    integral : Float,
    derivative : Float,
    kP : Float,
    kI : Float,
    kD : Float
  ) : Float {
    kP * error + kI * integral + kD * derivative
  };

  /// PID integral update with anti-windup
  public func controlIntegralUpdate(
    integral : Float,
    error : Float,
    dt : Float,
    maxIntegral : Float
  ) : Float {
    let newIntegral = integral + error * dt;
    if (newIntegral > maxIntegral) { maxIntegral }
    else if (newIntegral < -maxIntegral) { -maxIntegral }
    else { newIntegral }
  };

  /// PID derivative calculation with filtering
  public func controlDerivative(
    error : Float,
    prevError : Float,
    prevDerivative : Float,
    dt : Float,
    filterCoeff : Float
  ) : Float {
    let rawDerivative = (error - prevError) / dt;
    filterCoeff * rawDerivative + (1.0 - filterCoeff) * prevDerivative
  };

  /// State space model: x(k+1) = Ax(k) + Bu(k)
  public func controlStateUpdate(
    state : Float,
    input : Float,
    a : Float,
    b : Float
  ) : Float {
    a * state + b * input
  };

  /// Observer state estimation
  public func controlObserver(
    estimatedState : Float,
    measurement : Float,
    predicted : Float,
    observerGain : Float
  ) : Float {
    estimatedState + observerGain * (measurement - predicted)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SCHEDULING AND TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate monotonic priority
  public func schedulingRMPriority(period : Float) : Float {
    1.0 / period
  };

  /// Deadline miss probability (simplified)
  public func schedulingDeadlineMissProb(
    wcet : Float,
    period : Float,
    utilization : Float
  ) : Float {
    let slack = period - wcet;
    if (slack <= 0.0) { 1.0 }
    else { utilization * wcet / slack }
  };

  /// Response time analysis
  public func schedulingResponseTime(
    wcet : Float,
    period : Float,
    higherPriorityLoad : Float
  ) : Float {
    wcet / (1.0 - higherPriorityLoad)
  };

  /// Jitter calculation
  public func schedulingJitter(
    timestamps : [Float]
  ) : Float {
    if (timestamps.size() < 2) { return 0.0 };
    var sumDiff : Float = 0.0;
    var prevDiff : Float = timestamps[1] - timestamps[0];
    var maxJitter : Float = 0.0;
    var i = 2;
    while (i < timestamps.size()) {
      let diff = timestamps[i] - timestamps[i-1];
      let jitter = Float.abs(diff - prevDiff);
      if (jitter > maxJitter) { maxJitter := jitter };
      prevDiff := diff;
      i += 1;
    };
    maxJitter
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SIGNAL PROCESSING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Low-pass filter (exponential moving average)
  public func signalLowPass(
    current : Float,
    newSample : Float,
    alpha : Float
  ) : Float {
    alpha * newSample + (1.0 - alpha) * current
  };

  /// High-pass filter
  public func signalHighPass(
    current : Float,
    newSample : Float,
    prevSample : Float,
    alpha : Float
  ) : Float {
    alpha * (current + newSample - prevSample)
  };

  /// Band-pass filter (cascade)
  public func signalBandPass(
    value : Float,
    lowState : Float,
    highState : Float,
    alphaLow : Float,
    alphaHigh : Float
  ) : (Float, Float, Float) {
    let low = signalLowPass(lowState, value, alphaLow);
    let high = alphaHigh * (highState + value - lowState);
    (high, low, high)
  };

  /// Median filter (3-sample)
  public func signalMedian3(a : Float, b : Float, c : Float) : Float {
    if ((a <= b and b <= c) or (c <= b and b <= a)) { b }
    else if ((b <= a and a <= c) or (c <= a and a <= b)) { a }
    else { c }
  };

  /// Signal power
  public func signalPower(samples : [Float]) : Float {
    if (samples.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < samples.size()) {
      sum += samples[i] * samples[i];
      i += 1;
    };
    sum / Float.fromInt(samples.size())
  };

  /// Signal-to-noise ratio
  public func signalSNR(signalPower : Float, noisePower : Float) : Float {
    if (noisePower < 0.0001) { 100.0 }
    else { 10.0 * Float.log(signalPower / noisePower) / Float.log(10.0) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SYNCHRONIZATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phase-locked loop error
  public func syncPLLError(
    referencePhase : Float,
    outputPhase : Float
  ) : Float {
    let diff = referencePhase - outputPhase;
    Float.sin(diff)  // Sinusoidal phase detector
  };

  /// PLL VCO output
  public func syncVCO(
    centerFreq : Float,
    controlSignal : Float,
    gain : Float,
    time : Float
  ) : Float {
    Float.sin(2.0 * 3.14159265 * (centerFreq + gain * controlSignal) * time)
  };

  /// Clock drift compensation
  public func syncClockDrift(
    localTime : Float,
    referenceTime : Float,
    driftRate : Float
  ) : Float {
    localTime + (referenceTime - localTime) * driftRate
  };

  /// Frame synchronization correlation
  public func syncFrameCorrelation(
    received : [Float],
    syncPattern : [Float]
  ) : Float {
    let n = if (received.size() < syncPattern.size()) received.size() else syncPattern.size();
    if (n == 0) { return 0.0 };
    var corr : Float = 0.0;
    var i = 0;
    while (i < n) {
      corr += received[i] * syncPattern[i];
      i += 1;
    };
    corr
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BUFFER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Buffer fill level
  public func bufferFillLevel(count : Nat, capacity : Nat) : Float {
    if (capacity == 0) { 0.0 }
    else { Float.fromInt(count) / Float.fromInt(capacity) }
  };

  /// Buffer underrun risk
  public func bufferUnderrunRisk(
    fillLevel : Float,
    drainRate : Float,
    fillRate : Float
  ) : Float {
    if (fillRate >= drainRate) { 0.0 }
    else { (drainRate - fillRate) / drainRate * (1.0 - fillLevel) }
  };

  /// Adaptive buffer size
  public func bufferAdaptiveSize(
    currentSize : Nat,
    avgLatency : Float,
    targetLatency : Float,
    stepSize : Nat
  ) : Nat {
    if (avgLatency > targetLatency * 1.1) {
      currentSize + stepSize
    } else if (avgLatency < targetLatency * 0.9 and currentSize > stepSize) {
      currentSize - stepSize
    } else {
      currentSize
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // 60 HZ FRAME TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Frame time at 60 Hz
  public let FRAME_TIME_60HZ : Float = 1.0 / 60.0;

  /// Frame number from time
  public func frameNumberFromTime(time : Float) : Nat {
    Int.abs(Float.toInt(time / FRAME_TIME_60HZ))
  };

  /// Time within frame
  public func framePhase(time : Float) : Float {
    let frameNum = Float.fromInt(frameNumberFromTime(time));
    (time - frameNum * FRAME_TIME_60HZ) / FRAME_TIME_60HZ
  };

  /// Frame deadline remaining
  public func frameDeadlineRemaining(currentTime : Float, frameStart : Float) : Float {
    let deadline = frameStart + FRAME_TIME_60HZ;
    deadline - currentTime
  };

  /// Frame skip detection
  public func frameSkipDetected(prevFrame : Nat, currentFrame : Nat) : Bool {
    currentFrame > prevFrame + 1
  };

}
