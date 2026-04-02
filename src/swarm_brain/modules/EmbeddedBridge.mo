// ═══════════════════════════════════════════════════════════════════════════════
// EMBEDDED SYSTEMS BRIDGE — IoT, Hardware, and Sensor Integration
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// This module defines how the organism interfaces with real hardware:
//   • Cheap commercial drones ($100 quadcopters)
//   • IoT devices (cameras, sensors, actuators)
//   • Embedded computers (Raspberry Pi, ESP32, Jetson Nano)
//   • MAVLink protocol for drone control
//   • Camera feeds for POV (point of view)
//
// The brain is the same whether running in:
//   • Simulation (frontend visualizer)
//   • Single cheap drone
//   • Swarm of physical drones
//   • IoT sensor network
//
// Hardware abstraction layer makes the brain hardware-agnostic.
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Time "mo:base/Time";

module EmbeddedBridge {

  // ═══════════════════════════════════════════════════════════════════════════
  // HARDWARE PLATFORM TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type HardwarePlatform = {
    #Simulation;              // Pure software simulation
    #RaspberryPi;             // Raspberry Pi (any model)
    #ESP32;                   // ESP32 microcontroller
    #JetsonNano;              // NVIDIA Jetson Nano
    #ArduPilot;               // ArduPilot flight controller
    #PX4;                     // PX4 flight controller
    #BetaFlight;              // BetaFlight FC
    #CustomFC;                // Custom flight controller
    #GroundStation;           // Ground control station
    #IoTSensor;               // Generic IoT sensor
  };
  
  public type DroneHardware = {
    #ToyQuad;                 // Cheap $30-100 toy quadcopter
    #MiniQuad;                // FPV racing quad 
    #PhotoDrone;              // Camera drone (DJI style)
    #HexaCopter;              // 6-motor heavy lift
    #OctoCopter;              // 8-motor professional
    #FixedWing;               // Airplane style
    #VTOL;                    // Vertical takeoff + forward flight
    #GroundRover;             // Wheeled ground robot
    #Boat;                    // Water surface drone
    #Submarine;               // Underwater drone
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SENSOR TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SensorType = {
    #Camera;                  // Visual camera
    #ThermalCamera;           // Infrared thermal
    #LiDAR;                   // Laser distance scanning
    #Ultrasonic;              // Ultrasonic distance
    #GPS;                     // Global positioning
    #IMU;                     // Inertial measurement unit
    #Barometer;               // Altitude from pressure
    #Magnetometer;            // Compass
    #Rangefinder;             // Single-point distance
    #OpticalFlow;             // Visual velocity estimation
    #Microphone;              // Audio
    #GasSensor;               // Air quality / gas detection
    #RadiationSensor;         // Radiation detection
    #RFReceiver;              // Radio frequency detection
  };
  
  public type SensorData = {
    sensorType  : SensorType;
    timestamp   : Int;          // Nanoseconds
    dataBlob    : ?Blob;        // Raw data
    floatValue  : ?Float;       // Numeric reading
    vectorValue : ?(Float, Float, Float);  // 3D vector
    textValue   : ?Text;        // String data
    confidence  : Float;        // 0-1 confidence in reading
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CAMERA / POV SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type CameraResolution = {
    #R240p;     // 320x240
    #R480p;     // 640x480
    #R720p;     // 1280x720
    #R1080p;    // 1920x1080
    #R4K;       // 3840x2160
  };
  
  public type CameraMode = {
    #FPV;           // First-person view (forward)
    #Downward;      // Nadir view
    #Gimbal;        // Stabilized, can pan/tilt
    #Panoramic;     // 360 degree
    #Thermal;       // Infrared
    #NightVision;   // Low-light enhanced
  };
  
  public type POVState = {
    droneId         : Nat;
    cameraMode      : CameraMode;
    resolution      : CameraResolution;
    
    // Gimbal orientation (if applicable)
    gimbalPitch     : Float;    // -90 to +30 degrees
    gimbalYaw       : Float;    // -180 to +180 degrees
    gimbalRoll      : Float;    // Usually 0 (stabilized)
    
    // Field of view
    fovHorizontal   : Float;    // Degrees
    fovVertical     : Float;    // Degrees
    
    // Image processing
    objectsDetected : [DetectedObject];
    sceneClassification : Text;
    
    // Stream info
    streamActive    : Bool;
    frameRate       : Nat;      // FPS
    latencyMs       : Nat;      // Stream latency
    
    lastFrameTime   : Int;
  };
  
  public type DetectedObject = {
    objectClass     : Text;     // "person", "vehicle", "building", etc.
    confidence      : Float;    // 0-1
    boundingBox     : (Float, Float, Float, Float);  // x, y, width, height (normalized 0-1)
    distance        : ?Float;   // Estimated distance in meters
    velocity        : ?(Float, Float, Float);  // If tracking, estimated velocity
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DEVICE REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DeviceRegistration = {
    deviceId        : Nat;
    deviceName      : Text;
    platform        : HardwarePlatform;
    hardwareType    : ?DroneHardware;
    sensors         : [SensorType];
    hasCamera       : Bool;
    
    // Connection info
    connectionType  : { #WiFi; #Bluetooth; #LoRa; #Cellular; #Satellite; #USB; #Serial };
    ipAddress       : ?Text;
    macAddress      : ?Text;
    
    // Capabilities
    maxSpeed        : Float;    // m/s
    maxAltitude     : Float;    // meters
    maxRange        : Float;    // meters from base
    batteryCapacity : Float;    // mAh
    flightTime      : Float;    // minutes
    payloadCapacity : Float;    // grams
    
    // State
    registered      : Bool;
    lastHeartbeat   : Int;
    firmwareVersion : Text;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MAVLINK MESSAGE TYPES (subset)
  // ═══════════════════════════════════════════════════════════════════════════
  // MAVLink is the standard protocol for drone communication
  // We define the key message types we need
  
  public type MAVLinkMessage = {
    #Heartbeat : {
      systemId    : Nat8;
      componentId : Nat8;
      mavType     : Nat8;
      autopilot   : Nat8;
      baseMode    : Nat8;
      systemStatus: Nat8;
    };
    #GlobalPosition : {
      lat         : Int;        // Latitude (degE7)
      lon         : Int;        // Longitude (degE7)
      alt         : Int;        // Altitude (mm)
      relativeAlt : Int;        // Relative altitude (mm)
      vx          : Int;        // Ground X velocity (cm/s)
      vy          : Int;        // Ground Y velocity (cm/s)
      vz          : Int;        // Ground Z velocity (cm/s)
      hdg         : Nat;        // Heading (cdeg)
    };
    #Attitude : {
      roll        : Float;      // Radians
      pitch       : Float;      // Radians
      yaw         : Float;      // Radians
      rollSpeed   : Float;      // Rad/s
      pitchSpeed  : Float;      // Rad/s
      yawSpeed    : Float;      // Rad/s
    };
    #CommandLong : {
      command     : Nat;        // MAV_CMD
      param1      : Float;
      param2      : Float;
      param3      : Float;
      param4      : Float;
      param5      : Float;
      param6      : Float;
      param7      : Float;
    };
    #SetPositionTarget : {
      lat         : Int;
      lon         : Int;
      alt         : Float;
      vx          : Float;
      vy          : Float;
      vz          : Float;
      yaw         : Float;
      yawRate     : Float;
    };
    #RawSensor : {
      sensorId    : Nat;
      data        : Blob;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMMAND TRANSLATION — Organism decisions → Hardware commands
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type MotorCommand = {
    droneId     : Nat;
    throttle    : Float;    // 0-1
    pitch       : Float;    // -1 to +1
    roll        : Float;    // -1 to +1
    yaw         : Float;    // -1 to +1
    timestamp   : Int;
  };
  
  public type WaypointCommand = {
    droneId     : Nat;
    lat         : Float;    // Degrees
    lon         : Float;    // Degrees
    alt         : Float;    // Meters
    speed       : Float;    // m/s
    holdTime    : Float;    // Seconds to hover at waypoint
    action      : { #FlyTo; #Land; #Takeoff; #RTL; #Loiter };
  };
  
  // Translate organism motor outputs to hardware commands
  public func translateMotorCommand(
    droneId: Nat,
    motorNode: Float,      // From mini-brain motorNode activation
    decisionNode: Float,   // From mini-brain decisionNode
    targetVelX: Float,
    targetVelY: Float,
    targetVelZ: Float,
    currentYaw: Float
  ) : MotorCommand {
    // Map organism outputs to drone control axes
    // motorNode controls throttle intensity
    // decisionNode modulates responsiveness
    
    let responsiveness = 0.5 + decisionNode * 0.5;  // 0.5 to 1.0
    
    // Compute throttle (0.2 base + up to 0.6 from vertical velocity demand)
    let throttle = 0.2 + (targetVelY + 5.0) / 15.0 * 0.6 * motorNode;
    
    // Compute pitch/roll from horizontal velocity demands
    let maxTilt = 0.5;  // Max 50% tilt
    let pitch = (targetVelX / 10.0) * maxTilt * responsiveness;
    let roll = (targetVelZ / 10.0) * maxTilt * responsiveness;
    
    // Yaw is separate control (not velocity-based usually)
    let yaw = 0.0;  // Would come from heading error
    
    {
      droneId = droneId;
      throttle = clamp(throttle, 0.0, 1.0);
      pitch = clamp(pitch, -1.0, 1.0);
      roll = clamp(roll, -1.0, 1.0);
      yaw = clamp(yaw, -1.0, 1.0);
      timestamp = Time.now();
    }
  };
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TELEMETRY RECEPTION — Hardware data → Organism inputs
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type TelemetryPacket = {
    droneId         : Nat;
    timestamp       : Int;
    
    // Position
    posX            : Float;
    posY            : Float;
    posZ            : Float;
    
    // Velocity
    velX            : Float;
    velY            : Float;
    velZ            : Float;
    
    // Attitude
    roll            : Float;
    pitch           : Float;
    yaw             : Float;
    
    // Status
    batteryPercent  : Float;
    signalStrength  : Float;
    gpsLock         : Bool;
    armed           : Bool;
    inFlight        : Bool;
    
    // Sensors
    sensors         : [SensorData];
  };
  
  // Convert telemetry to organism sensory input
  public func telemetryToSensoryInput(
    telemetry: TelemetryPacket
  ) : [Float] {
    // Create 64-float sensory vector for organism
    var input : [Float] = [];
    
    // Position (normalized to ~1km range)
    input := Array.append(input, [telemetry.posX / 1000.0]);
    input := Array.append(input, [telemetry.posY / 100.0]);   // Altitude in 100m units
    input := Array.append(input, [telemetry.posZ / 1000.0]);
    
    // Velocity (normalized to ~20 m/s)
    input := Array.append(input, [telemetry.velX / 20.0]);
    input := Array.append(input, [telemetry.velY / 20.0]);
    input := Array.append(input, [telemetry.velZ / 20.0]);
    
    // Attitude (already in reasonable range)
    input := Array.append(input, [telemetry.roll]);
    input := Array.append(input, [telemetry.pitch]);
    input := Array.append(input, [telemetry.yaw / 3.14159]);  // Normalize to ±1
    
    // Status
    input := Array.append(input, [telemetry.batteryPercent]);
    input := Array.append(input, [telemetry.signalStrength]);
    input := Array.append(input, [if (telemetry.gpsLock) 1.0 else 0.0]);
    input := Array.append(input, [if (telemetry.armed) 1.0 else 0.0]);
    input := Array.append(input, [if (telemetry.inFlight) 1.0 else 0.0]);
    
    // Pad to 64 floats
    while (input.size() < 64) {
      input := Array.append(input, [0.0]);
    };
    
    input
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // EMBEDDED DEPLOYMENT CONFIGURATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DeploymentConfig = {
    platform        : HardwarePlatform;
    
    // Compute constraints
    maxMemoryMB     : Nat;
    maxCPUPercent   : Float;
    hasFPU          : Bool;      // Floating point unit
    hasGPU          : Bool;      // For Jetson, etc.
    
    // Network
    hasWiFi         : Bool;
    hasCellular     : Bool;
    hasLoRa         : Bool;
    canisterEndpoint: Text;     // IC canister URL
    
    // Timing
    localBeatRateHz : Float;    // Local heartbeat (may differ from master)
    syncIntervalMs  : Nat;      // How often to sync with master
    
    // Brain subset
    runFullBrain    : Bool;     // If false, run minimal subset
    brainSubset     : { #MiniMindOnly; #LocalDecisions; #FullOrganism };
  };
  
  // Configuration for cheap toy drone
  public func toyDroneConfig() : DeploymentConfig {
    {
      platform = #ESP32;
      maxMemoryMB = 4;          // ESP32 has ~4MB
      maxCPUPercent = 80.0;
      hasFPU = true;
      hasGPU = false;
      hasWiFi = true;
      hasCellular = false;
      hasLoRa = false;
      canisterEndpoint = "https://ic0.app";
      localBeatRateHz = 50.0;   // Run mini-mind at 50 Hz locally
      syncIntervalMs = 1000;    // Sync with master every 1 second
      runFullBrain = false;
      brainSubset = #MiniMindOnly;
    }
  };
  
  // Configuration for Raspberry Pi
  public func raspberryPiConfig() : DeploymentConfig {
    {
      platform = #RaspberryPi;
      maxMemoryMB = 1024;       // 1GB+
      maxCPUPercent = 70.0;
      hasFPU = true;
      hasGPU = false;
      hasWiFi = true;
      hasCellular = false;
      hasLoRa = true;
      canisterEndpoint = "https://ic0.app";
      localBeatRateHz = 100.0;  // 100 Hz local
      syncIntervalMs = 500;
      runFullBrain = false;
      brainSubset = #LocalDecisions;
    }
  };
  
  // Configuration for Jetson Nano
  public func jetsonNanoConfig() : DeploymentConfig {
    {
      platform = #JetsonNano;
      maxMemoryMB = 4096;       // 4GB
      maxCPUPercent = 80.0;
      hasFPU = true;
      hasGPU = true;            // CUDA cores!
      hasWiFi = true;
      hasCellular = true;
      hasLoRa = true;
      canisterEndpoint = "https://ic0.app";
      localBeatRateHz = 200.0;  // 200 Hz with GPU
      syncIntervalMs = 100;
      runFullBrain = true;
      brainSubset = #FullOrganism;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // POV INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initPOVState(droneId: Nat) : POVState {
    {
      droneId = droneId;
      cameraMode = #FPV;
      resolution = #R720p;
      gimbalPitch = 0.0;
      gimbalYaw = 0.0;
      gimbalRoll = 0.0;
      fovHorizontal = 90.0;
      fovVertical = 60.0;
      objectsDetected = [];
      sceneClassification = "unknown";
      streamActive = false;
      frameRate = 30;
      latencyMs = 50;
      lastFrameTime = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS REPORT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getDeviceStatus(device: DeviceRegistration) : Text {
    let platformText = switch (device.platform) {
      case (#Simulation) "SIMULATION";
      case (#RaspberryPi) "RASPBERRY PI";
      case (#ESP32) "ESP32";
      case (#JetsonNano) "JETSON NANO";
      case (#ArduPilot) "ARDUPILOT";
      case (#PX4) "PX4";
      case (#BetaFlight) "BETAFLIGHT";
      case (#CustomFC) "CUSTOM FC";
      case (#GroundStation) "GROUND STATION";
      case (#IoTSensor) "IoT SENSOR";
    };
    
    "DEVICE #" # Nat.toText(device.deviceId) # " — " # device.deviceName # "\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "Platform: " # platformText # "\n" #
    "Firmware: " # device.firmwareVersion # "\n" #
    "Sensors: " # Nat.toText(device.sensors.size()) # " attached\n" #
    "Camera: " # (if (device.hasCamera) "YES" else "NO") # "\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "CAPABILITIES:\n" #
    "  Max Speed: " # Float.format(#fix 1, device.maxSpeed) # " m/s\n" #
    "  Max Altitude: " # Float.format(#fix 0, device.maxAltitude) # " m\n" #
    "  Max Range: " # Float.format(#fix 0, device.maxRange) # " m\n" #
    "  Flight Time: " # Float.format(#fix 0, device.flightTime) # " min\n" #
    "  Payload: " # Float.format(#fix 0, device.payloadCapacity) # " g"
  };

}
