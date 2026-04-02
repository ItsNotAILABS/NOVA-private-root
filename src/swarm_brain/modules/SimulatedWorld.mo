// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: SimulatedWorld — Virtual Environment for Organism Testing
// Classification: CONFIDENTIAL — INTERNAL USE ONLY
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// Patent Pending: Simulation Environment for Distributed Cognitive Systems
// ============================================================================
//
// PURPOSE:
// The organism does not distinguish simulation from reality. This simulated
// world provides a safe environment for training, testing edge cases, and
// validating cognitive architectures before physical deployment.
//
// ARCHITECTURE:
// - Physics Engine: Gravity, drag, wind, collision detection
// - Terrain System: Height maps, obstacles, landing zones
// - Weather System: Wind vectors, visibility, precipitation
// - Entity System: Drones (with mini-minds), hostiles, neutrals
// - Sensor Simulation: Camera, LIDAR, radar, GPS (with denial zones)
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";
import Nat32 "mo:base/Nat32";

module {

  // ══════════════════════════════════════════════════════════════
  // PHYSICAL CONSTANTS
  // ══════════════════════════════════════════════════════════════
  let GRAVITY : Float = 9.81;           // m/s²
  let AIR_DENSITY : Float = 1.225;      // kg/m³ at sea level
  let DRAG_COEFF : Float = 0.5;         // Typical drone Cd
  let PI : Float = 3.14159265358979;

  // World dimensions
  public let WORLD_SIZE_X : Float = 2000.0;   // meters
  public let WORLD_SIZE_Y : Float = 500.0;    // altitude ceiling
  public let WORLD_SIZE_Z : Float = 2000.0;   // meters
  public let GRID_RESOLUTION : Nat = 100;     // Terrain grid cells per axis
  public let WORLD_CENTER : (Float, Float, Float) = (0.0, 50.0, 0.0);

  // ══════════════════════════════════════════════════════════════
  // 3D VECTOR TYPE
  // ══════════════════════════════════════════════════════════════
  public type Vec3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  public func vec3Add(a: Vec3, b: Vec3) : Vec3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };

  public func vec3Sub(a: Vec3, b: Vec3) : Vec3 {
    { x = a.x - b.x; y = a.y - b.y; z = a.z - b.z }
  };

  public func vec3Scale(v: Vec3, s: Float) : Vec3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };

  public func vec3Mag(v: Vec3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };

  public func vec3Normalize(v: Vec3) : Vec3 {
    let m = vec3Mag(v);
    if (m < 0.0001) { { x = 0.0; y = 0.0; z = 0.0 } }
    else { vec3Scale(v, 1.0 / m) }
  };

  public func vec3Dot(a: Vec3, b: Vec3) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };

  public func vec3Distance(a: Vec3, b: Vec3) : Float {
    vec3Mag(vec3Sub(a, b))
  };

  public let VEC3_ZERO : Vec3 = { x = 0.0; y = 0.0; z = 0.0 };
  public let VEC3_UP : Vec3 = { x = 0.0; y = 1.0; z = 0.0 };

  // ══════════════════════════════════════════════════════════════
  // TERRAIN SYSTEM
  // ══════════════════════════════════════════════════════════════
  public type TerrainType = {
    #Flat;
    #Hills;
    #Mountains;
    #Urban;
    #Water;
    #Forest;
  };

  public type TerrainCell = {
    height     : Float;       // Ground elevation
    terrainType: TerrainType;
    traversable: Bool;        // Can land here?
    coverLevel : Float;       // 0-1 concealment
    obstacles  : [Obstacle];
  };

  public type Obstacle = {
    position   : Vec3;
    radius     : Float;
    height     : Float;
    obstacleType: Text;       // "building", "tree", "tower", etc.
    destructible: Bool;
  };

  public type TerrainGrid = {
    cells      : [[TerrainCell]];
    cellSizeX  : Float;
    cellSizeZ  : Float;
  };

  // ══════════════════════════════════════════════════════════════
  // WEATHER SYSTEM
  // ══════════════════════════════════════════════════════════════
  public type WeatherCondition = {
    #Clear;
    #Cloudy;
    #Rain;
    #Storm;
    #Fog;
    #Snow;
  };

  public type WeatherState = {
    condition    : WeatherCondition;
    windVelocity : Vec3;        // Wind vector (m/s)
    windGusts    : Float;       // 0-1 gust intensity
    visibility   : Float;       // km (10 = clear, 0.1 = dense fog)
    precipitation: Float;       // 0-1 intensity
    temperature  : Float;       // Celsius
    pressure     : Float;       // hPa
    cloudCeiling : Float;       // meters AGL
    turbulence   : Float;       // 0-1 intensity
  };

  public func defaultWeather() : WeatherState {
    {
      condition = #Clear;
      windVelocity = { x = 2.0; y = 0.0; z = 1.0 };
      windGusts = 0.1;
      visibility = 10.0;
      precipitation = 0.0;
      temperature = 20.0;
      pressure = 1013.25;
      cloudCeiling = 3000.0;
      turbulence = 0.05;
    }
  };

  // Weather affects drone performance
  public func weatherPenalty(weather: WeatherState) : Float {
    let visibilityPenalty = if (weather.visibility < 1.0) { 0.5 } else { 0.0 };
    let windPenalty = Float.min(0.3, vec3Mag(weather.windVelocity) * 0.02);
    let turbulencePenalty = weather.turbulence * 0.2;
    let precipitationPenalty = weather.precipitation * 0.15;
    
    1.0 - (visibilityPenalty + windPenalty + turbulencePenalty + precipitationPenalty)
  };

  // ══════════════════════════════════════════════════════════════
  // ENTITY TYPES
  // ══════════════════════════════════════════════════════════════
  public type EntityType = {
    #FriendlyDrone;
    #HostileDrone;
    #GroundTarget;
    #AirTarget;
    #Civilian;
    #Structure;
    #Waypoint;
  };

  public type EntityState = {
    id           : Nat;
    entityType   : EntityType;
    position     : Vec3;
    velocity     : Vec3;
    orientation  : Vec3;        // Euler angles (pitch, yaw, roll)
    health       : Float;       // 0-1
    active       : Bool;
    detectable   : Bool;        // Can be sensed?
    threatLevel  : Float;       // 0-1 (for hostile entities)
    lastSeen     : Nat;         // Beat when last observed
  };

  // ══════════════════════════════════════════════════════════════
  // SENSOR SIMULATION
  // ══════════════════════════════════════════════════════════════
  public type SensorType = {
    #Camera;
    #LIDAR;
    #Radar;
    #Radio;
    #GPS;
    #IMU;
    #Ultrasonic;
  };

  public type SensorReading = {
    sensorType   : SensorType;
    timestamp    : Nat;         // Beat
    position     : Vec3;        // Sensor position
    detections   : [Detection];
    noiseLevel   : Float;       // 0-1 noise
    accuracy     : Float;       // 0-1 accuracy
  };

  public type Detection = {
    entityId     : Nat;
    bearing      : Float;       // Radians from north
    elevation    : Float;       // Radians
    range        : Float;       // Meters
    confidence   : Float;       // 0-1
    classification: ?EntityType;
  };

  // Simulate sensor detection
  public func simulateSensorDetection(
    sensorPos: Vec3,
    target: EntityState,
    sensorRange: Float,
    visibility: Float,
    noise: Float
  ) : ?Detection {
    let distance = vec3Distance(sensorPos, target.position);
    
    // Out of range
    if (distance > sensorRange) { return null };
    
    // Visibility affects detection
    let effectiveRange = sensorRange * visibility / 10.0;
    if (distance > effectiveRange) { return null };
    
    // Not detectable
    if (not target.detectable) { return null };
    
    // Compute bearing and elevation
    let dx = target.position.x - sensorPos.x;
    let dy = target.position.y - sensorPos.y;
    let dz = target.position.z - sensorPos.z;
    
    let bearing = Float.arctan2(dx, dz);
    let horizontalDist = Float.sqrt(dx * dx + dz * dz);
    let elevation = Float.arctan2(dy, horizontalDist);
    
    // Confidence decreases with range and increases noise
    let rangeConfidence = 1.0 - (distance / sensorRange);
    let confidence = rangeConfidence * (1.0 - noise * 0.5);
    
    ?{
      entityId = target.id;
      bearing = bearing;
      elevation = elevation;
      range = distance;
      confidence = confidence;
      classification = if (confidence > 0.7) { ?target.entityType } else { null };
    }
  };

  // ══════════════════════════════════════════════════════════════
  // GPS SIMULATION (with denial zones)
  // ══════════════════════════════════════════════════════════════
  public type GPSDenialZone = {
    center     : Vec3;
    radius     : Float;
    jamStrength: Float;       // 0-1 (1 = total denial)
  };

  public func computeGPSAccuracy(
    position: Vec3,
    denialZones: [GPSDenialZone],
    baseAccuracy: Float       // meters
  ) : (Float, Bool) {          // (accuracy, available)
    var maxJamming : Float = 0.0;
    
    for (zone in denialZones.vals()) {
      let dist = vec3Distance(position, zone.center);
      if (dist < zone.radius) {
        let jamLevel = zone.jamStrength * (1.0 - dist / zone.radius);
        if (jamLevel > maxJamming) { maxJamming := jamLevel };
      };
    };
    
    if (maxJamming > 0.95) {
      (1000.0, false)  // GPS denied
    } else {
      let degradedAccuracy = baseAccuracy / (1.0 - maxJamming);
      (degradedAccuracy, true)
    }
  };

  // ══════════════════════════════════════════════════════════════
  // PHYSICS SIMULATION
  // ══════════════════════════════════════════════════════════════
  public type DronePhysics = {
    mass        : Float;        // kg
    dragArea    : Float;        // m² (frontal area × Cd)
    maxThrust   : Float;        // Newtons
    batteryWh   : Float;        // Watt-hours capacity
    batteryLeft : Float;        // 0-1 remaining
    motorEfficiency: Float;     // 0-1
  };

  // Compute forces on drone
  public func computeForces(
    physics: DronePhysics,
    velocity: Vec3,
    thrust: Vec3,
    wind: Vec3
  ) : Vec3 {
    // Gravity
    let gravityForce = { x = 0.0; y = -GRAVITY * physics.mass; z = 0.0 };
    
    // Drag (opposes velocity relative to air)
    let relVel = vec3Sub(velocity, wind);
    let speed = vec3Mag(relVel);
    let dragMag = 0.5 * AIR_DENSITY * physics.dragArea * speed * speed;
    let dragDir = vec3Normalize(vec3Scale(relVel, -1.0));
    let dragForce = vec3Scale(dragDir, dragMag);
    
    // Total force
    vec3Add(vec3Add(vec3Add(gravityForce, dragForce), thrust), VEC3_ZERO)
  };

  // Battery drain based on thrust
  public func computeBatteryDrain(
    thrust: Vec3,
    physics: DronePhysics,
    dt: Float                   // Time step in seconds
  ) : Float {
    let thrustMag = vec3Mag(thrust);
    let power = thrustMag * 10.0 / physics.motorEfficiency;  // Watts (simplified)
    let energyUsed = power * dt / 3600.0;                    // Wh
    energyUsed / physics.batteryWh
  };

  // ══════════════════════════════════════════════════════════════
  // WORLD STATE
  // ══════════════════════════════════════════════════════════════
  public type SimulatedWorldState = {
    // Time
    beat         : Nat;
    realTimeMs   : Nat;
    timeScale    : Float;       // 1.0 = real-time, 10.0 = 10x speed
    
    // Environment
    terrain      : TerrainGrid;
    weather      : WeatherState;
    gpsDenialZones: [GPSDenialZone];
    
    // Entities
    entities     : [EntityState];
    entityCount  : Nat;
    
    // Global metrics
    totalDistance: Float;       // Cumulative drone travel
    collisions   : Nat;
    batteryWarnings: Nat;
    missionProgress: Float;
    
    // Scenario
    scenarioName : Text;
    scenarioPhase: Nat;
    scenarioComplete: Bool;
  };

  // ══════════════════════════════════════════════════════════════
  // WORLD TICK FUNCTION
  // ══════════════════════════════════════════════════════════════
  public func tickWorld(
    world: SimulatedWorldState,
    dt: Float                   // Delta time in seconds
  ) : SimulatedWorldState {
    // Update weather (slight random walk)
    let newWeather = {
      condition = world.weather.condition;
      windVelocity = {
        x = world.weather.windVelocity.x;
        y = world.weather.windVelocity.y;
        z = world.weather.windVelocity.z;
      };
      windGusts = world.weather.windGusts;
      visibility = world.weather.visibility;
      precipitation = world.weather.precipitation;
      temperature = world.weather.temperature;
      pressure = world.weather.pressure;
      cloudCeiling = world.weather.cloudCeiling;
      turbulence = world.weather.turbulence;
    };
    
    // Return updated state
    {
      beat = world.beat + 1;
      realTimeMs = world.realTimeMs + Int.abs(Float.toInt(dt * 1000.0));
      timeScale = world.timeScale;
      terrain = world.terrain;
      weather = newWeather;
      gpsDenialZones = world.gpsDenialZones;
      entities = world.entities;
      entityCount = world.entityCount;
      totalDistance = world.totalDistance;
      collisions = world.collisions;
      batteryWarnings = world.batteryWarnings;
      missionProgress = world.missionProgress;
      scenarioName = world.scenarioName;
      scenarioPhase = world.scenarioPhase;
      scenarioComplete = world.scenarioComplete;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SCENARIO DEFINITIONS
  // ══════════════════════════════════════════════════════════════
  public type Scenario = {
    name         : Text;
    description  : Text;
    duration     : Nat;         // Max beats
    objectives   : [Text];
    successCriteria: [Text];
    initialEntities: [EntityState];
    weatherPreset: WeatherState;
    difficulty   : Float;       // 0-1
  };

  public let SCENARIOS : [Scenario] = [
    {
      name = "Basic Formation";
      description = "Maintain V-formation for 100 beats";
      duration = 100;
      objectives = ["Form V-formation", "Maintain coherence > 0.8"];
      successCriteria = ["formation_coherence > 0.8 for 90% of time"];
      initialEntities = [];
      weatherPreset = defaultWeather();
      difficulty = 0.2;
    },
    {
      name = "Threat Response";
      description = "Detect and evade incoming hostile";
      duration = 200;
      objectives = ["Detect threat", "Coordinate evasion", "Survive"];
      successCriteria = ["all_drones_survive", "threat_detected_early"];
      initialEntities = [];
      weatherPreset = defaultWeather();
      difficulty = 0.5;
    },
    {
      name = "GPS Denied Navigation";
      description = "Navigate through GPS denial zone";
      duration = 300;
      objectives = ["Enter denial zone", "Navigate to waypoint", "Exit safely"];
      successCriteria = ["reached_waypoint", "no_collisions"];
      initialEntities = [];
      weatherPreset = defaultWeather();
      difficulty = 0.7;
    },
    {
      name = "Storm Operations";
      description = "Maintain mission in severe weather";
      duration = 150;
      objectives = ["Adapt to conditions", "Complete patrol", "Return home"];
      successCriteria = ["patrol_complete", "all_drones_landed"];
      initialEntities = [];
      weatherPreset = {
        condition = #Storm;
        windVelocity = { x = 15.0; y = 0.0; z = 10.0 };
        windGusts = 0.7;
        visibility = 2.0;
        precipitation = 0.8;
        temperature = 15.0;
        pressure = 990.0;
        cloudCeiling = 500.0;
        turbulence = 0.6;
      };
      difficulty = 0.8;
    }
  ];

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════
  func initTerrainCell(x: Nat, z: Nat, seed: Nat32) : TerrainCell {
    // Simplified terrain generation
    let xf = Float.fromInt(x);
    let zf = Float.fromInt(z);
    let baseHeight = Float.sin(xf * 0.1) * Float.cos(zf * 0.1) * 20.0 + 10.0;
    
    {
      height = baseHeight;
      terrainType = #Flat;
      traversable = true;
      coverLevel = 0.0;
      obstacles = [];
    }
  };

  public func initSimulatedWorld() : SimulatedWorldState {
    // Initialize terrain grid
    let cellSizeX = WORLD_SIZE_X / Float.fromInt(GRID_RESOLUTION);
    let cellSizeZ = WORLD_SIZE_Z / Float.fromInt(GRID_RESOLUTION);
    
    // Simple flat terrain for now
    let emptyCells : [[TerrainCell]] = [];
    
    {
      beat = 0;
      realTimeMs = 0;
      timeScale = 1.0;
      terrain = {
        cells = emptyCells;
        cellSizeX = cellSizeX;
        cellSizeZ = cellSizeZ;
      };
      weather = defaultWeather();
      gpsDenialZones = [];
      entities = [];
      entityCount = 0;
      totalDistance = 0.0;
      collisions = 0;
      batteryWarnings = 0;
      missionProgress = 0.0;
      scenarioName = "Default";
      scenarioPhase = 0;
      scenarioComplete = false;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA SIMULATION LAW
  // ══════════════════════════════════════════════════════════════
  // "To the cognitive system, simulation is indistinguishable from reality.
  //  The organism that learns in simulation carries that learning into
  //  the physical world unchanged, scaled by the fidelity of the model."
  //
  // FORMAL STATEMENT:
  //   L_real = L_sim × fidelity × Φ_M^(complexity_match)
  //
  // Where:
  //   L_real = Learning transferred to reality
  //   L_sim = Learning in simulation
  //   fidelity = Physics/sensor accuracy (0-1)
  //   complexity_match = How well sim complexity matches reality
  //
  // Original contribution by Alfredo Medina Hernandez

  public func computeLearningTransfer(
    learningInSim: Float,
    fidelity: Float,
    complexityMatch: Float
  ) : Float {
    let PHI_MEDINA : Float = 2.97442179;
    learningInSim * fidelity * Float.pow(PHI_MEDINA, complexityMatch - 1.0)
  };

}
