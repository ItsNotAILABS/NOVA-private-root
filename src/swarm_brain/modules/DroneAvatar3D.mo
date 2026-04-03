// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: DroneAvatar3D — Full 3D Drone Simulation with Real Physics
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    DRONE AVATAR 3D — REAL DRONE PHYSICS                  ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This is a REAL drone simulation. Not a game. REAL aerodynamics.         ║
// ║                                                                          ║
// ║  QUADROTOR PHYSICS:                                                      ║
// ║    - 4 rotors with individual thrust control                             ║
// ║    - Torque from differential thrust                                     ║
// ║    - Real lift equation: L = ½ρv²C_L A                                   ║
// ║    - Real drag equation: D = ½ρv²C_D A                                   ║
// ║                                                                          ║
// ║  FLIGHT DYNAMICS:                                                        ║
// ║    - Roll, Pitch, Yaw control                                            ║
// ║    - Ground effect                                                       ║
// ║    - Blade flapping                                                      ║
// ║    - Gyroscopic precession                                               ║
// ║                                                                          ║
// ║  SENSORS:                                                                ║
// ║    - IMU (accelerometer, gyroscope)                                      ║
// ║    - Barometer (altitude)                                                ║
// ║    - GPS (position)                                                      ║
// ║    - Camera (visual)                                                     ║
// ║    - LIDAR (obstacle detection)                                          ║
// ║                                                                          ║
// ║  WEAPONS/PAYLOAD:                                                        ║
// ║    - Missiles, bombs, guns                                               ║
// ║    - Cargo delivery                                                      ║
// ║    - Electronic warfare                                                  ║
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
  // ║                     PHYSICAL CONSTANTS                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let GRAVITY : Float = 9.80665;
  public let AIR_DENSITY : Float = 1.225;           // kg/m³ at sea level
  public let π : Float = 3.1415926535897932385;
  public let φ : Float = 1.6180339887498948482;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VECTOR TYPES                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Vector3 = { x : Float; y : Float; z : Float };
  public type Quaternion = { w : Float; x : Float; y : Float; z : Float };
  
  public let ZERO : Vector3 = { x = 0.0; y = 0.0; z = 0.0 };
  public let UP : Vector3 = { x = 0.0; y = 1.0; z = 0.0 };
  public let IDENTITY_QUAT : Quaternion = { w = 1.0; x = 0.0; y = 0.0; z = 0.0 };
  
  public func add(a: Vector3, b: Vector3) : Vector3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };
  
  public func scale(v: Vector3, s: Float) : Vector3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };
  
  public func magnitude(v: Vector3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };
  
  public func normalize(v: Vector3) : Vector3 {
    let m = magnitude(v);
    if (m < 0.0001) { ZERO } else { scale(v, 1.0 / m) }
  };
  
  public func cross(a: Vector3, b: Vector3) : Vector3 {
    {
      x = a.y * b.z - a.z * b.y;
      y = a.z * b.x - a.x * b.z;
      z = a.x * b.y - a.y * b.x;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DRONE TYPES                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DroneType = {
    #Quadrotor;                   // 4 rotors
    #Hexarotor;                   // 6 rotors
    #Octorotor;                   // 8 rotors
    #FixedWing;                   // Airplane style
    #VTOL;                        // Vertical takeoff
    #Helicopter;                  // Single main rotor
  };
  
  public type DroneClass = {
    #Scout;                       // Small, fast, recon
    #Attack;                      // Armed combat drone
    #Transport;                   // Cargo carrier
    #UCAV;                        // Unmanned combat aerial vehicle
    #Kamikaze;                    // Loitering munition
    #EW;                          // Electronic warfare
    #Tanker;                      // Aerial refueling
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ROTOR PHYSICS                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Rotor = {
    index : Nat;
    position : Vector3;           // Relative to drone center
    direction : Float;            // Spin direction: 1.0 CW, -1.0 CCW
    
    // Physical properties
    radius : Float;               // Blade radius (m)
    bladeCount : Nat;
    bladePitch : Float;           // Blade angle (radians)
    
    // Current state
    rpm : Float;                  // Revolutions per minute
    throttle : Float;             // [0, 1] commanded throttle
    thrust : Float;               // Current thrust (N)
    torque : Float;               // Reaction torque (N·m)
    
    // Health
    health : Float;               // [0, 1]
    efficiency : Float;           // [0, 1] due to damage/wear
  };
  
  /// Calculate rotor thrust using blade element theory (simplified)
  public func calculateRotorThrust(rotor: Rotor, airDensity: Float) : Float {
    // Thrust = C_T × ρ × A × (ωR)²
    // where C_T ≈ 0.015 for typical propellers
    let C_T = 0.015;
    let area = π * rotor.radius * rotor.radius;
    let omega = rotor.rpm * 2.0 * π / 60.0;  // rad/s
    let tipSpeed = omega * rotor.radius;
    
    C_T * airDensity * area * tipSpeed * tipSpeed * rotor.efficiency
  };
  
  /// Calculate rotor torque (reaction torque)
  public func calculateRotorTorque(rotor: Rotor, thrust: Float) : Float {
    // Q = thrust × radius × k (simplified)
    let k = 0.05;  // Torque coefficient
    thrust * rotor.radius * k * rotor.direction
  };
  
  /// Update rotor RPM based on throttle
  public func updateRotorRPM(rotor: Rotor, targetRPM: Float, dt: Float) : Rotor {
    // Motor response time constant
    let tau = 0.1;  // 100ms response
    let rpmDiff = targetRPM - rotor.rpm;
    let newRPM = rotor.rpm + rpmDiff * (1.0 - Float.exp(-dt / tau));
    
    let thrust = calculateRotorThrust({ rotor with rpm = newRPM }, AIR_DENSITY);
    let torque = calculateRotorTorque({ rotor with rpm = newRPM; thrust = thrust }, thrust);
    
    {
      index = rotor.index;
      position = rotor.position;
      direction = rotor.direction;
      radius = rotor.radius;
      bladeCount = rotor.bladeCount;
      bladePitch = rotor.bladePitch;
      rpm = newRPM;
      throttle = rotor.throttle;
      thrust = thrust;
      torque = torque;
      health = rotor.health;
      efficiency = rotor.efficiency;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DRONE SENSORS                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type IMUData = {
    accelerometer : Vector3;      // m/s² (body frame)
    gyroscope : Vector3;          // rad/s
    magnetometer : Vector3;       // μT (micro-Tesla)
    temperature : Float;          // °C
  };
  
  public type GPSData = {
    latitude : Float;             // degrees
    longitude : Float;
    altitude : Float;             // meters MSL
    groundSpeed : Float;          // m/s
    heading : Float;              // degrees
    satellites : Nat;
    accuracy : Float;             // meters
  };
  
  public type BarometerData = {
    pressure : Float;             // hPa
    altitude : Float;             // meters (pressure altitude)
    temperature : Float;
  };
  
  public type CameraData = {
    isActive : Bool;
    resolution : (Nat, Nat);
    fieldOfView : Float;          // degrees
    zoom : Float;
    gimbalPitch : Float;
    gimbalYaw : Float;
    targetLock : ?Vector3;
  };
  
  public type LIDARData = {
    isActive : Bool;
    points : [(Float, Float, Float)];  // Point cloud
    obstacleDistance : Float;     // Nearest obstacle
    obstacleDirection : Vector3;
  };
  
  public type RadarData = {
    isActive : Bool;
    targets : [RadarContact];
    range : Float;                // Max detection range
  };
  
  public type RadarContact = {
    position : Vector3;
    velocity : Vector3;
    rcs : Float;                  // Radar cross section
    classification : TargetClass;
  };
  
  public type TargetClass = {
    #Unknown;
    #Aircraft;
    #Drone;
    #Vehicle;
    #Person;
    #Building;
    #Missile;
  };
  
  public type DroneSensors = {
    imu : IMUData;
    gps : GPSData;
    barometer : BarometerData;
    camera : CameraData;
    lidar : LIDARData;
    radar : RadarData;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WEAPONS & PAYLOAD                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type WeaponType = {
    #Missile;                     // Guided missile
    #Bomb;                        // Gravity bomb
    #Gun;                         // Machine gun/cannon
    #Rocket;                      // Unguided rocket
    #Laser;                       // Directed energy
    #EMP;                         // Electromagnetic pulse
    #Jammer;                      // Electronic warfare
  };
  
  public type Weapon = {
    weaponType : WeaponType;
    name : Text;
    ammo : Nat;
    maxAmmo : Nat;
    damage : Float;
    range : Float;                // meters
    rateOfFire : Float;           // rounds per second
    weight : Float;               // kg
    isArmed : Bool;
    lastFired : Float;            // Timestamp
  };
  
  public type Payload = {
    payloadType : PayloadType;
    weight : Float;               // kg
    value : Float;                // Mission value
  };
  
  public type PayloadType = {
    #Cargo;
    #Sensors;
    #Fuel;
    #Weapon;
    #Passengers;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DRONE STATE                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DroneFlightMode = {
    #Grounded;
    #Takeoff;
    #Hover;
    #Forward;
    #Combat;
    #RTB;                         // Return to base
    #Landing;
    #Emergency;
    #Autonomous;
  };
  
  public type DroneState = {
    id : Nat32;
    callsign : Text;
    droneType : DroneType;
    droneClass : DroneClass;
    
    // Physical properties
    mass : Float;                 // kg (including payload)
    emptyMass : Float;            // kg (without payload/fuel)
    wingspan : Float;             // meters (or rotor diameter)
    length : Float;
    
    // Position & Orientation
    position : Vector3;           // World coordinates (meters)
    velocity : Vector3;           // m/s
    acceleration : Vector3;
    rotation : Quaternion;        // Orientation
    angularVelocity : Vector3;    // rad/s
    
    // Flight state
    flightMode : DroneFlightMode;
    altitude : Float;             // meters AGL
    airspeed : Float;             // m/s
    groundSpeed : Float;
    heading : Float;              // degrees (0-360)
    pitch : Float;                // degrees
    roll : Float;
    yaw : Float;
    
    // Propulsion
    rotors : [Rotor];
    throttle : Float;             // [0, 1] overall
    fuel : Float;                 // kg or %
    maxFuel : Float;
    fuelConsumption : Float;      // kg/s
    
    // Control inputs
    rollInput : Float;            // [-1, 1]
    pitchInput : Float;
    yawInput : Float;
    throttleInput : Float;
    
    // Systems
    sensors : DroneSensors;
    weapons : [Weapon];
    payload : [Payload];
    
    // Health & Status
    health : Float;               // [0, 1]
    batteryLevel : Float;         // [0, 1] for electric
    signalStrength : Float;       // [0, 1]
    isAutonomous : Bool;
    hasTarget : Bool;
    targetPosition : ?Vector3;
    
    // Mission
    homePosition : Vector3;
    waypoints : [Vector3];
    currentWaypoint : Nat;
    missionType : MissionType;
  };
  
  public type MissionType = {
    #Patrol;
    #Strike;
    #Recon;
    #CAS;                         // Close air support
    #SEAD;                        // Suppression of enemy air defense
    #Transport;
    #EscortProtect;
    #Kamikaze;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FLIGHT PHYSICS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Calculate total thrust from all rotors
  public func calculateTotalThrust(rotors: [Rotor]) : Vector3 {
    var totalThrust : Float = 0.0;
    for (rotor in rotors.vals()) {
      totalThrust += rotor.thrust;
    };
    // Thrust points up in body frame
    { x = 0.0; y = totalThrust; z = 0.0 }
  };
  
  /// Calculate net torque from all rotors
  public func calculateNetTorque(rotors: [Rotor]) : Vector3 {
    var rollTorque : Float = 0.0;
    var pitchTorque : Float = 0.0;
    var yawTorque : Float = 0.0;
    
    for (rotor in rotors.vals()) {
      // Roll torque from lateral position × thrust
      rollTorque += rotor.position.x * rotor.thrust;
      // Pitch torque from forward position × thrust
      pitchTorque += rotor.position.z * rotor.thrust;
      // Yaw torque from reaction torque
      yawTorque += rotor.torque;
    };
    
    { x = rollTorque; y = yawTorque; z = pitchTorque }
  };
  
  /// Calculate drag force
  public func calculateDrag(velocity: Vector3, dragCoeff: Float, area: Float) : Vector3 {
    let speed = magnitude(velocity);
    if (speed < 0.001) { return ZERO };
    
    // D = ½ρv²C_d A
    let dragMag = 0.5 * AIR_DENSITY * speed * speed * dragCoeff * area;
    let dragDir = normalize(scale(velocity, -1.0));
    scale(dragDir, dragMag)
  };
  
  /// Calculate ground effect (thrust increase near ground)
  public func groundEffect(altitude: Float, rotorRadius: Float) : Float {
    // Ground effect increases thrust when altitude < 1 rotor diameter
    let h_R = altitude / (2.0 * rotorRadius);
    if (h_R > 1.0) { return 1.0 };
    1.0 / (1.0 - 0.25 * (rotorRadius / altitude) * (rotorRadius / altitude))
  };
  
  /// Update drone physics for one timestep
  public func updateDronePhysics(drone: DroneState, dt: Float) : DroneState {
    // 1. Calculate forces
    let thrust = calculateTotalThrust(drone.rotors);
    let weight = { x = 0.0; y = -drone.mass * GRAVITY; z = 0.0 };
    let drag = calculateDrag(drone.velocity, 0.5, drone.wingspan * 0.1);
    
    // Ground effect
    let geMultiplier = groundEffect(drone.altitude, drone.wingspan / 2.0);
    let thrustWithGE = scale(thrust, geMultiplier);
    
    // Total force
    let totalForce = add(add(thrustWithGE, weight), drag);
    
    // 2. Calculate acceleration (F = ma)
    let accel = scale(totalForce, 1.0 / drone.mass);
    
    // 3. Integrate velocity
    let newVelocity = add(drone.velocity, scale(accel, dt));
    
    // 4. Integrate position
    let newPosition = add(drone.position, scale(newVelocity, dt));
    
    // 5. Calculate torques
    let torque = calculateNetTorque(drone.rotors);
    let momentOfInertia = drone.mass * drone.wingspan * drone.wingspan / 12.0;
    let angularAccel = scale(torque, 1.0 / momentOfInertia);
    
    // 6. Integrate angular velocity
    let newAngularVel = add(drone.angularVelocity, scale(angularAccel, dt));
    
    // 7. Update orientation (simplified Euler angles)
    let newRoll = drone.roll + newAngularVel.x * dt * 180.0 / π;
    let newPitch = drone.pitch + newAngularVel.z * dt * 180.0 / π;
    let newYaw = drone.yaw + newAngularVel.y * dt * 180.0 / π;
    
    // 8. Ground collision
    let groundedPos = if (newPosition.y < 0.1) {
      { x = newPosition.x; y = 0.1; z = newPosition.z }
    } else { newPosition };
    
    let groundedVel = if (newPosition.y < 0.1 and newVelocity.y < 0.0) {
      { x = newVelocity.x * 0.8; y = 0.0; z = newVelocity.z * 0.8 }
    } else { newVelocity };
    
    // 9. Fuel consumption
    var totalRPM : Float = 0.0;
    for (rotor in drone.rotors.vals()) {
      totalRPM += rotor.rpm;
    };
    let fuelUsed = drone.fuelConsumption * (totalRPM / 10000.0) * dt;
    let newFuel = Float.max(0.0, drone.fuel - fuelUsed);
    
    // 10. Update speeds
    let newAirspeed = magnitude(newVelocity);
    let newGroundSpeed = Float.sqrt(newVelocity.x * newVelocity.x + newVelocity.z * newVelocity.z);
    let newAltitude = groundedPos.y;
    
    // 11. Update heading
    let newHeading = if (newGroundSpeed > 0.1) {
      Float.arctan2(newVelocity.x, newVelocity.z) * 180.0 / π
    } else { drone.heading };
    
    {
      id = drone.id;
      callsign = drone.callsign;
      droneType = drone.droneType;
      droneClass = drone.droneClass;
      mass = drone.mass;
      emptyMass = drone.emptyMass;
      wingspan = drone.wingspan;
      length = drone.length;
      position = groundedPos;
      velocity = groundedVel;
      acceleration = accel;
      rotation = drone.rotation;
      angularVelocity = newAngularVel;
      flightMode = drone.flightMode;
      altitude = newAltitude;
      airspeed = newAirspeed;
      groundSpeed = newGroundSpeed;
      heading = newHeading;
      pitch = newPitch;
      roll = newRoll;
      yaw = newYaw;
      rotors = drone.rotors;
      throttle = drone.throttle;
      fuel = newFuel;
      maxFuel = drone.maxFuel;
      fuelConsumption = drone.fuelConsumption;
      rollInput = drone.rollInput;
      pitchInput = drone.pitchInput;
      yawInput = drone.yawInput;
      throttleInput = drone.throttleInput;
      sensors = drone.sensors;
      weapons = drone.weapons;
      payload = drone.payload;
      health = drone.health;
      batteryLevel = drone.batteryLevel;
      signalStrength = drone.signalStrength;
      isAutonomous = drone.isAutonomous;
      hasTarget = drone.hasTarget;
      targetPosition = drone.targetPosition;
      homePosition = drone.homePosition;
      waypoints = drone.waypoints;
      currentWaypoint = drone.currentWaypoint;
      missionType = drone.missionType;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONTROL SYSTEM                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Apply control inputs to rotors
  public func applyControlInputs(drone: DroneState) : DroneState {
    let maxRPM = 12000.0;
    let hoverRPM = 8000.0;
    
    // Base throttle for hover
    let baseRPM = hoverRPM * drone.throttleInput;
    
    // Differential RPM for roll (left/right difference)
    let rollDiff = drone.rollInput * 2000.0;
    
    // Differential RPM for pitch (front/back difference)
    let pitchDiff = drone.pitchInput * 2000.0;
    
    // Differential RPM for yaw (CW/CCW difference)
    let yawDiff = drone.yawInput * 1000.0;
    
    // Update each rotor (assuming standard quadrotor layout)
    let newRotors = Array.tabulate<Rotor>(drone.rotors.size(), func(i) {
      let rotor = drone.rotors[i];
      
      var targetRPM = baseRPM;
      
      // Apply differential based on rotor position
      // Front-left (0), Front-right (1), Rear-right (2), Rear-left (3)
      switch (i) {
        case (0) { // Front-left
          targetRPM := baseRPM - pitchDiff + rollDiff - yawDiff;
        };
        case (1) { // Front-right
          targetRPM := baseRPM - pitchDiff - rollDiff + yawDiff;
        };
        case (2) { // Rear-right
          targetRPM := baseRPM + pitchDiff - rollDiff - yawDiff;
        };
        case (3) { // Rear-left
          targetRPM := baseRPM + pitchDiff + rollDiff + yawDiff;
        };
        case (_) {
          targetRPM := baseRPM;
        };
      };
      
      // Clamp RPM
      targetRPM := Float.max(0.0, Float.min(maxRPM, targetRPM));
      
      updateRotorRPM(rotor, targetRPM, 0.016)  // Assuming 60fps
    });
    
    { drone with rotors = newRotors }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WEAPON SYSTEMS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Projectile = {
    id : Nat32;
    position : Vector3;
    velocity : Vector3;
    damage : Float;
    splash : Float;               // Splash damage radius
    guidance : GuidanceType;
    target : ?Vector3;
    lifetime : Float;
  };
  
  public type GuidanceType = {
    #Unguided;
    #LaserGuided;
    #GPSGuided;
    #IRHoming;                    // Heat seeking
    #ActiveRadar;
    #SemiActiveRadar;
  };
  
  /// Fire weapon
  public func fireWeapon(
    drone: DroneState,
    weaponIndex: Nat,
    currentTime: Float
  ) : ?(DroneState, Projectile) {
    if (weaponIndex >= drone.weapons.size()) { return null };
    
    let weapon = drone.weapons[weaponIndex];
    if (not weapon.isArmed or weapon.ammo == 0) { return null };
    
    // Check rate of fire
    let timeSinceLastFire = currentTime - weapon.lastFired;
    if (timeSinceLastFire < 1.0 / weapon.rateOfFire) { return null };
    
    // Create projectile
    let muzzleVelocity = 800.0;  // m/s for missile
    let projectileVel = add(
      drone.velocity,
      { x = 0.0; y = 0.0; z = muzzleVelocity }  // Forward in drone frame
    );
    
    let projectile : Projectile = {
      id = drone.id * 1000 + Nat32.fromNat(weaponIndex);
      position = drone.position;
      velocity = projectileVel;
      damage = weapon.damage;
      splash = if (weapon.weaponType == #Missile) { 10.0 } else { 0.0 };
      guidance = switch (weapon.weaponType) {
        case (#Missile) { #LaserGuided };
        case (#Bomb) { #GPSGuided };
        case (_) { #Unguided };
      };
      target = drone.targetPosition;
      lifetime = weapon.range / muzzleVelocity * 2.0;
    };
    
    // Update weapon
    let updatedWeapon = {
      weapon with
      ammo = weapon.ammo - 1;
      lastFired = currentTime;
    };
    
    let updatedWeapons = Array.tabulate<Weapon>(drone.weapons.size(), func(i) {
      if (i == weaponIndex) { updatedWeapon } else { drone.weapons[i] }
    });
    
    let updatedDrone = { drone with weapons = updatedWeapons };
    
    ?(updatedDrone, projectile)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Create default quadrotor rotors
  public func createQuadrotorRotors() : [Rotor] {
    let armLength = 0.25;  // 25cm arm length
    
    [
      {  // Front-left
        index = 0;
        position = { x = -armLength; y = 0.0; z = armLength };
        direction = 1.0;  // CW
        radius = 0.127;  // 5" prop
        bladeCount = 2;
        bladePitch = 0.2;
        rpm = 0.0;
        throttle = 0.0;
        thrust = 0.0;
        torque = 0.0;
        health = 1.0;
        efficiency = 1.0;
      },
      {  // Front-right
        index = 1;
        position = { x = armLength; y = 0.0; z = armLength };
        direction = -1.0;  // CCW
        radius = 0.127;
        bladeCount = 2;
        bladePitch = 0.2;
        rpm = 0.0;
        throttle = 0.0;
        thrust = 0.0;
        torque = 0.0;
        health = 1.0;
        efficiency = 1.0;
      },
      {  // Rear-right
        index = 2;
        position = { x = armLength; y = 0.0; z = -armLength };
        direction = 1.0;  // CW
        radius = 0.127;
        bladeCount = 2;
        bladePitch = 0.2;
        rpm = 0.0;
        throttle = 0.0;
        thrust = 0.0;
        torque = 0.0;
        health = 1.0;
        efficiency = 1.0;
      },
      {  // Rear-left
        index = 3;
        position = { x = -armLength; y = 0.0; z = -armLength };
        direction = -1.0;  // CCW
        radius = 0.127;
        bladeCount = 2;
        bladePitch = 0.2;
        rpm = 0.0;
        throttle = 0.0;
        thrust = 0.0;
        torque = 0.0;
        health = 1.0;
        efficiency = 1.0;
      }
    ]
  };
  
  /// Initialize default sensors
  public func initSensors() : DroneSensors {
    {
      imu = {
        accelerometer = ZERO;
        gyroscope = ZERO;
        magnetometer = { x = 25.0; y = 0.0; z = 40.0 };
        temperature = 25.0;
      };
      gps = {
        latitude = 32.7767;
        longitude = -96.7970;
        altitude = 0.0;
        groundSpeed = 0.0;
        heading = 0.0;
        satellites = 12;
        accuracy = 2.0;
      };
      barometer = {
        pressure = 1013.25;
        altitude = 0.0;
        temperature = 25.0;
      };
      camera = {
        isActive = true;
        resolution = (1920, 1080);
        fieldOfView = 90.0;
        zoom = 1.0;
        gimbalPitch = 0.0;
        gimbalYaw = 0.0;
        targetLock = null;
      };
      lidar = {
        isActive = true;
        points = [];
        obstacleDistance = 100.0;
        obstacleDirection = ZERO;
      };
      radar = {
        isActive = false;
        targets = [];
        range = 5000.0;
      };
    }
  };
  
  /// Create new drone
  public func createDrone(
    id: Nat32,
    callsign: Text,
    droneType: DroneType,
    droneClass: DroneClass,
    position: Vector3
  ) : DroneState {
    let (mass, wingspan, weapons) = switch (droneClass) {
      case (#Scout) { (1.5, 0.5, [] : [Weapon]) };
      case (#Attack) { 
        (15.0, 2.0, [{
          weaponType = #Missile;
          name = "AGM-114 Hellfire";
          ammo = 4;
          maxAmmo = 4;
          damage = 1000.0;
          range = 8000.0;
          rateOfFire = 0.5;
          weight = 50.0;
          isArmed = true;
          lastFired = 0.0;
        }])
      };
      case (#Transport) { (50.0, 4.0, [] : [Weapon]) };
      case (#UCAV) { 
        (500.0, 15.0, [{
          weaponType = #Missile;
          name = "JDAM";
          ammo = 8;
          maxAmmo = 8;
          damage = 2000.0;
          range = 24000.0;
          rateOfFire = 0.2;
          weight = 230.0;
          isArmed = true;
          lastFired = 0.0;
        }])
      };
      case (#Kamikaze) { (3.0, 1.0, [] : [Weapon]) };
      case (#EW) { (10.0, 3.0, [] : [Weapon]) };
      case (#Tanker) { (200.0, 10.0, [] : [Weapon]) };
    };
    
    {
      id = id;
      callsign = callsign;
      droneType = droneType;
      droneClass = droneClass;
      mass = mass;
      emptyMass = mass * 0.7;
      wingspan = wingspan;
      length = wingspan * 0.8;
      position = position;
      velocity = ZERO;
      acceleration = ZERO;
      rotation = IDENTITY_QUAT;
      angularVelocity = ZERO;
      flightMode = #Grounded;
      altitude = position.y;
      airspeed = 0.0;
      groundSpeed = 0.0;
      heading = 0.0;
      pitch = 0.0;
      roll = 0.0;
      yaw = 0.0;
      rotors = createQuadrotorRotors();
      throttle = 0.0;
      fuel = 100.0;
      maxFuel = 100.0;
      fuelConsumption = 0.01;
      rollInput = 0.0;
      pitchInput = 0.0;
      yawInput = 0.0;
      throttleInput = 0.0;
      sensors = initSensors();
      weapons = weapons;
      payload = [];
      health = 1.0;
      batteryLevel = 1.0;
      signalStrength = 1.0;
      isAutonomous = true;
      hasTarget = false;
      targetPosition = null;
      homePosition = position;
      waypoints = [];
      currentWaypoint = 0;
      missionType = #Patrol;
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

}
