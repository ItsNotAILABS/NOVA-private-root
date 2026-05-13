// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: RealWorldSimulator — Complete Integrated 3D/4D World Simulation
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║            REAL WORLD SIMULATOR — INTEGRATED WORLD ENGINE                ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This is the MASTER ORCHESTRATOR for the entire 3D/4D world.             ║
// ║                                                                          ║
// ║  INTEGRATES:                                                             ║
// ║    - PhysicsEngine (3D rigid body physics)                               ║
// ║    - World3D (voxel terrain, materials)                                  ║
// ║    - DestructibleEnvironment (trees, buildings break)                    ║
// ║    - DroneAvatar3D (real drone physics)                                  ║
// ║    - WeatherSystem (atmospheric physics)                                 ║
// ║                                                                          ║
// ║  SIMULATION LOOP:                                                        ║
// ║    1. Update time (4D temporal dimension)                                ║
// ║    2. Update weather (affects everything)                                ║
// ║    3. Update physics (all rigid bodies)                                  ║
// ║    4. Update drones (flight physics)                                     ║
// ║    5. Detect collisions                                                  ║
// ║    6. Apply damage (destructibles)                                       ║
// ║    7. Update terrain (craters, erosion)                                  ║
// ║    8. Render state (visual output)                                       ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let phi : Float = 1.6180339887498948482;
  public let pi : Float = 3.1415926535897932385;
  public let GRAVITY : Float = 9.80665;
  
  // Simulation settings
  public let FIXED_TIMESTEP : Float = 0.016667;  // 60 Hz physics
  public let MAX_SUBSTEPS : Nat = 10;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VECTOR TYPES                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Vector3 = { x : Float; y : Float; z : Float };
  public type Quaternion = { w : Float; x : Float; y : Float; z : Float };
  
  public let ZERO : Vector3 = { x = 0.0; y = 0.0; z = 0.0 };
  public let UP : Vector3 = { x = 0.0; y = 1.0; z = 0.0 };
  
  public func add(a: Vector3, b: Vector3) : Vector3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };
  
  public func scale(v: Vector3, s: Float) : Vector3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };
  
  public func magnitude(v: Vector3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };
  
  public func distance(a: Vector3, b: Vector3) : Float {
    magnitude({ x = b.x - a.x; y = b.y - a.y; z = b.z - a.z })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENTITY TYPES                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type EntityType = {
    #Drone;
    #Tree;
    #Building;
    #Vehicle;
    #Projectile;
    #Debris;
    #Character;
    #Animal;
  };
  
  public type Entity = {
    id : Nat32;
    entityType : EntityType;
    position : Vector3;
    velocity : Vector3;
    rotation : Quaternion;
    mass : Float;
    health : Float;
    isActive : Bool;
    
    // Collision
    colliderRadius : Float;
    isCollidable : Bool;
    
    // Faction
    faction : Nat;
    isHostile : Bool;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BIOME TYPES                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BiomeType = {
    #Plains;
    #Forest;
    #Desert;
    #Mountain;
    #Swamp;
    #Tundra;
    #Ocean;
    #Urban;
    #Industrial;
  };
  
  public type Biome = {
    id : Nat;
    biomeType : BiomeType;
    center : (Float, Float);      // (x, z)
    radius : Float;
    
    // Properties
    temperature : Float;          // K
    humidity : Float;             // [0, 1]
    elevation : Float;            // Base elevation
    vegetation : Float;           // [0, 1] density
    
    // Entities in this biome
    entityCount : Nat;
    treeCount : Nat;
    buildingCount : Nat;
    
    // Faction control
    controllingFaction : Nat;
    contestLevel : Float;         // [0, 1]
    
    // GASVR Drives
    gaiaDrive : Float;
    aresDrive : Float;
    vulcanDrive : Float;
    solarisDrive : Float;
    resonexDrive : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COLLISION EVENT                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type CollisionEvent = {
    entityA : Nat32;
    entityB : Nat32;
    point : Vector3;
    normal : Vector3;
    penetration : Float;
    impulse : Float;
    timestamp : Float;
  };
  
  public type DamageEvent = {
    targetId : Nat32;
    sourceId : Nat32;
    damage : Float;
    damageType : DamageType;
    position : Vector3;
    timestamp : Float;
  };
  
  public type DamageType = {
    #Impact;
    #Explosion;
    #Fire;
    #Bullet;
    #Missile;
    #Melee;
    #Environmental;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD STATE                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type SimulationState = {
    // Time
    simulationTime : Float;       // Total seconds
    realTime : Float;             // Real-world time
    timeScale : Float;            // Speed multiplier
    isPaused : Bool;
    
    // Frame
    frameNumber : Nat;
    deltaTime : Float;
    accumulator : Float;          // For fixed timestep
    
    // World
    worldSizeX : Float;           // meters
    worldSizeZ : Float;
    
    // Entities
    entities : [Entity];
    nextEntityId : Nat32;
    
    // Biomes (36 total)
    biomes : [Biome];
    
    // Events
    collisions : [CollisionEvent];
    damages : [DamageEvent];
    
    // Statistics
    entityCount : Nat;
    activeCount : Nat;
    droneCount : Nat;
    
    // Environmental
    sunPosition : Vector3;
    ambientLight : Float;
    globalWeather : GlobalWeather;
  };
  
  public type GlobalWeather = {
    temperature : Float;
    humidity : Float;
    windSpeed : Float;
    windDirection : Float;
    precipitation : Float;
    visibility : Float;
    condition : Text;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PHYSICS STEP                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Single physics substep
  public func physicsSubstep(state: SimulationState, dt: Float) : SimulationState {
    // 1. Apply forces to all entities
    let entitiesWithForces = Array.map<Entity, Entity>(state.entities, func(e) {
      if (not e.isActive) { return e };
      
      // Gravity
      let gravityForce = { x = 0.0; y = -GRAVITY * e.mass; z = 0.0 };
      
      // Wind (from weather)
      let windForce = {
        x = state.globalWeather.windSpeed * Float.sin(state.globalWeather.windDirection * π / 180.0) * 0.1;
        y = 0.0;
        z = state.globalWeather.windSpeed * Float.cos(state.globalWeather.windDirection * π / 180.0) * 0.1;
      };
      
      // Calculate acceleration
      let accelX = (gravityForce.x + windForce.x) / e.mass;
      let accelY = (gravityForce.y + windForce.y) / e.mass;
      let accelZ = (gravityForce.z + windForce.z) / e.mass;
      
      // Integrate velocity
      let newVelX = e.velocity.x + accelX * dt;
      let newVelY = e.velocity.y + accelY * dt;
      let newVelZ = e.velocity.z + accelZ * dt;
      
      // Integrate position
      let newPosX = e.position.x + newVelX * dt;
      let newPosY = Float.max(0.0, e.position.y + newVelY * dt);  // Ground collision
      let newPosZ = e.position.z + newVelZ * dt;
      
      // Ground collision response
      let groundedVelY = if (newPosY <= 0.0 and newVelY < 0.0) {
        Float.abs(newVelY) * 0.3  // Bounce
      } else { newVelY };
      
      {
        e with
        position = { x = newPosX; y = newPosY; z = newPosZ };
        velocity = { x = newVelX; y = groundedVelY; z = newVelZ };
      }
    });
    
    { state with entities = entitiesWithForces }
  };
  
  /// Detect collisions between entities
  public func detectCollisions(state: SimulationState) : [CollisionEvent] {
    let collisions = Buffer.Buffer<CollisionEvent>(16);
    
    var i = 0;
    while (i < state.entities.size()) {
      let a = state.entities[i];
      if (a.isActive and a.isCollidable) {
        var j = i + 1;
        while (j < state.entities.size()) {
          let b = state.entities[j];
          if (b.isActive and b.isCollidable) {
            // Simple sphere-sphere collision
            let dist = distance(a.position, b.position);
            let minDist = a.colliderRadius + b.colliderRadius;
            
            if (dist < minDist) {
              // Collision detected
              let normal = {
                x = (b.position.x - a.position.x) / dist;
                y = (b.position.y - a.position.y) / dist;
                z = (b.position.z - a.position.z) / dist;
              };
              
              let contactPoint = {
                x = a.position.x + normal.x * a.colliderRadius;
                y = a.position.y + normal.y * a.colliderRadius;
                z = a.position.z + normal.z * a.colliderRadius;
              };
              
              // Impulse calculation
              let relVelX = b.velocity.x - a.velocity.x;
              let relVelY = b.velocity.y - a.velocity.y;
              let relVelZ = b.velocity.z - a.velocity.z;
              let relVelNormal = relVelX * normal.x + relVelY * normal.y + relVelZ * normal.z;
              
              if (relVelNormal < 0.0) {  // Approaching
                let restitution = 0.5;
                let impulseScalar = -(1.0 + restitution) * relVelNormal / (1.0/a.mass + 1.0/b.mass);
                
                collisions.add({
                  entityA = a.id;
                  entityB = b.id;
                  point = contactPoint;
                  normal = normal;
                  penetration = minDist - dist;
                  impulse = impulseScalar;
                  timestamp = state.simulationTime;
                });
              };
            };
          };
          j += 1;
        };
      };
      i += 1;
    };
    
    Buffer.toArray(collisions)
  };
  
  /// Resolve collisions
  public func resolveCollisions(
    state: SimulationState,
    collisions: [CollisionEvent]
  ) : SimulationState {
    var entities = state.entities;
    
    for (col in collisions.vals()) {
      // Find entities
      entities := Array.map<Entity, Entity>(entities, func(e) {
        if (e.id == col.entityA) {
          let impulseA = scale(col.normal, -col.impulse / e.mass);
          {
            e with
            velocity = add(e.velocity, impulseA);
            position = add(e.position, scale(col.normal, -col.penetration / 2.0));
          }
        } else if (e.id == col.entityB) {
          let impulseB = scale(col.normal, col.impulse / e.mass);
          {
            e with
            velocity = add(e.velocity, impulseB);
            position = add(e.position, scale(col.normal, col.penetration / 2.0));
          }
        } else { e }
      });
    };
    
    { state with 
      entities = entities;
      collisions = collisions;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MAIN SIMULATION LOOP                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Main simulation step
  public func step(state: SimulationState, dt: Float) : SimulationState {
    if (state.isPaused) { return state };
    
    let scaledDt = dt * state.timeScale;
    var newState = state;
    
    // Update time
    newState := {
      newState with
      simulationTime = state.simulationTime + scaledDt;
      deltaTime = scaledDt;
      frameNumber = state.frameNumber + 1;
    };
    
    // Fixed timestep physics
    var accumulator = state.accumulator + scaledDt;
    var substeps = 0;
    
    while (accumulator >= FIXED_TIMESTEP and substeps < MAX_SUBSTEPS) {
      newState := physicsSubstep(newState, FIXED_TIMESTEP);
      accumulator -= FIXED_TIMESTEP;
      substeps += 1;
    };
    
    newState := { newState with accumulator = accumulator };
    
    // Detect and resolve collisions
    let collisions = detectCollisions(newState);
    newState := resolveCollisions(newState, collisions);
    
    // Update sun position (day/night cycle)
    let dayProgress = (newState.simulationTime / 1200.0) - Float.floor(newState.simulationTime / 1200.0);
    let sunAngle = dayProgress * 2.0 * π;
    let sunY = Float.sin(sunAngle);
    let sunX = Float.cos(sunAngle);
    
    newState := {
      newState with
      sunPosition = { x = sunX; y = sunY; z = 0.0 };
      ambientLight = Float.max(0.1, (sunY + 1.0) / 2.0);
    };
    
    // Update statistics
    var activeCount = 0;
    var droneCount = 0;
    for (e in newState.entities.vals()) {
      if (e.isActive) { activeCount += 1 };
      switch (e.entityType) {
        case (#Drone) { droneCount += 1 };
        case (_) {};
      };
    };
    
    {
      newState with
      activeCount = activeCount;
      droneCount = droneCount;
      entityCount = newState.entities.size();
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENTITY MANAGEMENT                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Spawn new entity
  public func spawnEntity(
    state: SimulationState,
    entityType: EntityType,
    position: Vector3,
    mass: Float,
    faction: Nat
  ) : (SimulationState, Nat32) {
    let id = state.nextEntityId;
    
    let colliderRadius = switch (entityType) {
      case (#Drone) { 0.5 };
      case (#Tree) { 1.0 };
      case (#Building) { 5.0 };
      case (#Vehicle) { 2.0 };
      case (#Projectile) { 0.1 };
      case (#Debris) { 0.3 };
      case (#Character) { 0.5 };
      case (#Animal) { 0.3 };
    };
    
    let entity : Entity = {
      id = id;
      entityType = entityType;
      position = position;
      velocity = ZERO;
      rotation = { w = 1.0; x = 0.0; y = 0.0; z = 0.0 };
      mass = mass;
      health = 1.0;
      isActive = true;
      colliderRadius = colliderRadius;
      isCollidable = true;
      faction = faction;
      isHostile = false;
    };
    
    let newEntities = Array.append<Entity>(state.entities, [entity]);
    
    (
      {
        state with
        entities = newEntities;
        nextEntityId = id + 1;
        entityCount = newEntities.size();
      },
      id
    )
  };
  
  /// Destroy entity
  public func destroyEntity(state: SimulationState, id: Nat32) : SimulationState {
    let newEntities = Array.map<Entity, Entity>(state.entities, func(e) {
      if (e.id == id) { { e with isActive = false } } else { e }
    });
    
    { state with entities = newEntities }
  };
  
  /// Apply damage to entity
  public func applyDamage(
    state: SimulationState,
    targetId: Nat32,
    sourceId: Nat32,
    damage: Float,
    damageType: DamageType,
    position: Vector3
  ) : SimulationState {
    // Create damage event
    let event : DamageEvent = {
      targetId = targetId;
      sourceId = sourceId;
      damage = damage;
      damageType = damageType;
      position = position;
      timestamp = state.simulationTime;
    };
    
    // Apply damage to entity
    let newEntities = Array.map<Entity, Entity>(state.entities, func(e) {
      if (e.id == targetId) {
        let newHealth = Float.max(0.0, e.health - damage);
        { e with health = newHealth; isActive = newHealth > 0.0 }
      } else { e }
    });
    
    {
      state with
      entities = newEntities;
      damages = Array.append<DamageEvent>(state.damages, [event]);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Create initial biomes (20x20 grid = 400 biomes — 20× expansion)
  public func createBiomes() : [Biome] {
    let biomes = Buffer.Buffer<Biome>(400);
    let spacing = 3000.0;  // 3000m per biome (20× expansion: 60000m / 20 = 3000m)
    
    var id = 0;
    var row = 0;
    while (row < 20) {
      var col = 0;
      while (col < 20) {
        let centerX = Float.fromInt(col) * spacing + spacing / 2.0;
        let centerZ = Float.fromInt(row) * spacing + spacing / 2.0;
        
        // Determine biome type based on position
        let biomeType : BiomeType = if (row == 0 or row == 19 or col == 0 or col == 19) {
          #Ocean
        } else if (row == 1 or row == 18) {
          #Plains
        } else if (col == 8 or col == 9 or col == 10 or col == 11) {
          if (row >= 5 and row <= 14) { #Urban } else { #Forest }
        } else {
          #Mountain
        };
        
        biomes.add({
          id = id;
          biomeType = biomeType;
          center = (centerX, centerZ);
          radius = spacing / 2.0;
          temperature = 293.15;
          humidity = 0.5;
          elevation = if (biomeType == #Mountain) { 1000.0 } else { 100.0 };
          vegetation = switch (biomeType) {
            case (#Forest) { 0.9 };
            case (#Plains) { 0.5 };
            case (#Urban) { 0.1 };
            case (_) { 0.2 };
          };
          entityCount = 0;
          treeCount = 0;
          buildingCount = 0;
          controllingFaction = (id % 4);  // 4 factions
          contestLevel = 0.0;
          gaiaDrive = 1.0;
          aresDrive = 1.0;
          vulcanDrive = 1.0;
          solarisDrive = 1.0;
          resonexDrive = 1.0;
        });
        
        id += 1;
        col += 1;
      };
      row += 1;
    };
    
    Buffer.toArray(biomes)
  };
  
  /// Initialize simulation
  public func initSimulation() : SimulationState {
    {
      simulationTime = 0.0;
      realTime = 0.0;
      timeScale = 1.0;
      isPaused = false;
      frameNumber = 0;
      deltaTime = 0.0;
      accumulator = 0.0;
      worldSizeX = 60000.0;
      worldSizeZ = 60000.0;
      entities = [];
      nextEntityId = 1;
      biomes = createBiomes();
      collisions = [];
      damages = [];
      entityCount = 0;
      activeCount = 0;
      droneCount = 0;
      sunPosition = { x = 0.0; y = 1.0; z = 0.0 };
      ambientLight = 1.0;
      globalWeather = {
        temperature = 293.15;
        humidity = 0.5;
        windSpeed = 5.0;
        windDirection = 270.0;
        precipitation = 0.0;
        visibility = 20000.0;
        condition = "Clear";
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     QUERIES                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Get entity by ID
  public func getEntity(state: SimulationState, id: Nat32) : ?Entity {
    for (e in state.entities.vals()) {
      if (e.id == id) { return ?e };
    };
    null
  };
  
  /// Get entities in radius
  public func getEntitiesInRadius(
    state: SimulationState,
    center: Vector3,
    radius: Float
  ) : [Entity] {
    let result = Buffer.Buffer<Entity>(16);
    
    for (e in state.entities.vals()) {
      if (e.isActive and distance(center, e.position) <= radius) {
        result.add(e);
      };
    };
    
    Buffer.toArray(result)
  };
  
  /// Get biome at position
  public func getBiomeAtPosition(state: SimulationState, x: Float, z: Float) : ?Biome {
    for (b in state.biomes.vals()) {
      let dist = Float.sqrt(
        (x - b.center.0) * (x - b.center.0) +
        (z - b.center.1) * (z - b.center.1)
      );
      if (dist <= b.radius) { return ?b };
    };
    null
  };
  
  /// Get world statistics
  public type WorldStats = {
    totalEntities : Nat;
    activeEntities : Nat;
    droneCount : Nat;
    treeCount : Nat;
    buildingCount : Nat;
    collisionsThisFrame : Nat;
    damagesThisFrame : Nat;
    simulationTime : Float;
    frameNumber : Nat;
  };
  
  public func getWorldStats(state: SimulationState) : WorldStats {
    var trees = 0;
    var buildings = 0;
    
    for (e in state.entities.vals()) {
      switch (e.entityType) {
        case (#Tree) { trees += 1 };
        case (#Building) { buildings += 1 };
        case (_) {};
      };
    };
    
    {
      totalEntities = state.entityCount;
      activeEntities = state.activeCount;
      droneCount = state.droneCount;
      treeCount = trees;
      buildingCount = buildings;
      collisionsThisFrame = state.collisions.size();
      damagesThisFrame = state.damages.size();
      simulationTime = state.simulationTime;
      frameNumber = state.frameNumber;
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
