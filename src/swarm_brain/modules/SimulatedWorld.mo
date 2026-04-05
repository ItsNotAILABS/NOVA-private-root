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
