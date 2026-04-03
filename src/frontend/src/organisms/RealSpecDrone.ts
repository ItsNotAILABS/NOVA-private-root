// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: RealSpecDrone — Virtual Drones with REAL WORLD Specifications
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                    REAL SPEC DRONE — LIKE THE FLY EXPERIMENT                                             ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                          ║
// ║  Just like putting a mind on a fly — the organism controls these drones.                                 ║
// ║                                                                                                          ║
// ║  Every drone has REAL specifications:                                                                    ║
// ║    - Real camera specs (resolution, FOV, framerate, sensor type)                                         ║
// ║    - Real flight characteristics (max speed, range, endurance)                                           ║
// ║    - Real sensors (GPS, IMU, LIDAR, radar, IR, thermal)                                                  ║
// ║    - Real weapons (if armed)                                                                             ║
// ║    - Real communication specs (range, bandwidth, latency)                                                ║
// ║                                                                                                          ║
// ║  The organism SEES through these cameras — they ARE its eyes.                                            ║
// ║  The organism CONTROLS these drones — they ARE its limbs.                                                ║
// ║                                                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { DroneMind } from './drone-mind';
import type { DroneState, DroneClass } from '../types/organism';

// ═══════════════════════════════════════════════════════════════════════════════
// REAL CAMERA SPECIFICATIONS — Based on actual drone camera hardware
// ═══════════════════════════════════════════════════════════════════════════════

export interface CameraSensorSpec {
  // Sensor hardware
  sensorType: 'CMOS' | 'CCD' | 'InGaAs' | 'MCT';  // MCT = HgCdTe for thermal
  sensorSize: { width: number; height: number };  // mm
  pixelSize: number;  // micrometers
  
  // Resolution
  resolution: { width: number; height: number };  // pixels
  effectiveMegapixels: number;
  
  // Frame rate
  maxFramerate: number;  // fps
  framerateModes: { resolution: [number, number]; fps: number }[];
  
  // Lens
  focalLength: number | [number, number];  // mm (fixed or zoom range)
  aperture: number | [number, number];  // f-stop
  fieldOfView: { horizontal: number; vertical: number; diagonal: number };  // degrees
  minimumFocusDistance: number;  // meters
  
  // Dynamic range
  dynamicRange: number;  // dB
  iso: [number, number];  // min/max ISO
  
  // Thermal (if applicable)
  isThermal: boolean;
  thermalResolution?: { width: number; height: number };
  thermalSensitivity?: number;  // NETD in mK
  spectralRange?: [number, number];  // micrometers
  
  // Night vision
  hasNightVision: boolean;
  nightVisionType?: 'IR' | 'LWIR' | 'MWIR' | 'SWIR' | 'ImageIntensifier';
  irIlluminator?: boolean;
  
  // Stabilization
  stabilization: 'None' | 'OIS' | 'EIS' | 'Hybrid' | 'Gyroscopic';
  
  // Recording
  videoCodecs: string[];
  photoBitDepth: number;
  colorSpace: 'sRGB' | 'AdobeRGB' | 'DCI-P3' | 'RAW';
  hasRAW: boolean;
  
  // Weight
  weight: number;  // grams
}

export interface GimbalSpec {
  axes: 2 | 3;
  
  // Range of motion
  pitchRange: [number, number];  // degrees
  rollRange: [number, number];
  yawRange: [number, number];
  
  // Speed
  maxAngularSpeed: number;  // degrees per second
  
  // Precision
  stabilizationPrecision: number;  // degrees
  
  // Control
  controlModes: ('Follow' | 'Lock' | 'FPV' | 'Track')[];
  trackingCapability: boolean;
  
  // Slip ring (for unlimited rotation)
  hasSlipRing: boolean;
}

export interface DroneCamera {
  id: string;
  name: string;
  mountPosition: 'Nose' | 'Belly' | 'Turret' | 'Wing' | 'Tail' | 'Multi';
  sensor: CameraSensorSpec;
  gimbal: GimbalSpec;
  
  // Current state
  isActive: boolean;
  currentZoom: number;
  currentPitch: number;
  currentYaw: number;
  currentFocus: number;
  exposure: number;
  gain: number;
  
  // Target tracking
  isTracking: boolean;
  trackingTarget?: { x: number; y: number; z: number };
  trackingConfidence: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// REAL DRONE SPECIFICATIONS — Based on actual military/commercial drones
// ═══════════════════════════════════════════════════════════════════════════════

export type DroneCategory = 
  | 'Nano'        // < 250g, hand-launched
  | 'Micro'       // < 2kg, backpackable
  | 'Small'       // < 25kg, vehicle-portable
  | 'Medium'      // < 150kg, tactical
  | 'Large'       // < 600kg, MALE class
  | 'Heavy';      // > 600kg, HALE class

export type PropulsionType = 
  | 'Electric'    // Battery powered
  | 'Gasoline'    // Piston engine
  | 'Diesel'      // Heavy fuel engine
  | 'Turboprop'   // Propeller turbine
  | 'Jet'         // Turbojet/turbofan
  | 'Hybrid';     // Electric + fuel

export interface FlightEnvelope {
  maxSpeed: number;           // m/s
  cruiseSpeed: number;        // m/s
  stallSpeed?: number;        // m/s (fixed-wing only)
  maxAltitude: number;        // meters MSL
  servicesCeiling: number;    // meters
  climbRate: number;          // m/s
  descentRate: number;        // m/s
  maxRange: number;           // km
  endurance: number;          // hours
  maxWindResistance: number;  // m/s
  operatingTemp: [number, number];  // °C
  ipRating: string;           // e.g., "IP54"
}

export interface CommunicationsSpec {
  primaryLink: 'Radio' | 'Satellite' | 'Cellular' | 'Mesh';
  frequency: number[];        // MHz
  bandwidth: number;          // Mbps
  range: number;              // km
  latency: number;            // ms
  encryption: string;
  linkMargin: number;         // dB
  antennaType: string;
  
  // Backup link
  hasBackupLink: boolean;
  backupLink?: 'Radio' | 'Satellite' | 'Cellular';
  
  // Video link
  videoDownlink: {
    bandwidth: number;        // Mbps
    latency: number;          // ms
    encryption: boolean;
  };
}

export interface SensorSuite {
  gps: {
    type: 'GPS' | 'GLONASS' | 'Galileo' | 'BeiDou' | 'Multi';
    accuracy: number;         // meters CEP
    updateRate: number;       // Hz
  };
  
  imu: {
    accelerometer: { range: number; resolution: number };  // g, mg
    gyroscope: { range: number; resolution: number };      // deg/s, deg/s
    updateRate: number;       // Hz
  };
  
  barometer: {
    range: [number, number];  // hPa
    accuracy: number;         // hPa
    resolution: number;       // cm
  };
  
  magnetometer?: {
    range: number;            // gauss
    resolution: number;       // μgauss
  };
  
  lidar?: {
    range: number;            // meters
    accuracy: number;         // cm
    pointsPerSecond: number;
    fieldOfView: number;      // degrees
    wavelength: number;       // nm
  };
  
  radar?: {
    type: 'FMCW' | 'Pulse' | 'SAR';
    range: number;            // km
    azimuthResolution: number;  // degrees
    rangeResolution: number;  // meters
  };
  
  irSensor?: {
    type: 'Active' | 'Passive';
    range: number;            // meters
  };
  
  ultrasonicSensor?: {
    range: number;            // meters
    accuracy: number;         // cm
  };
}

export interface WeaponSystem {
  id: string;
  name: string;
  type: 'Missile' | 'Bomb' | 'Gun' | 'Rocket' | 'Laser' | 'EMP' | 'Loitering';
  
  // Specifications
  weight: number;             // kg
  quantity: number;
  maxQuantity: number;
  
  // Performance
  range: number;              // meters
  accuracy: number;           // CEP meters
  warheadWeight?: number;     // kg
  damage: number;             // 0-100 effectiveness
  
  // Guidance
  guidance: 'Unguided' | 'GPS' | 'Laser' | 'IR' | 'Radar' | 'TV' | 'Wire';
  
  // Status
  isArmed: boolean;
  isReady: boolean;
  lastFired?: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// REAL SPEC DRONE — The complete virtual drone with real specs
// ═══════════════════════════════════════════════════════════════════════════════

export interface RealSpecDroneConfig {
  // Identity
  model: string;              // e.g., "MQ-9 Reaper", "DJI Mavic 3", etc.
  manufacturer: string;
  category: DroneCategory;
  airframe: 'QuadRotor' | 'HexaRotor' | 'OctoRotor' | 'FixedWing' | 'VTOL' | 'Helicopter';
  
  // Physical
  emptyWeight: number;        // kg
  maxTakeoffWeight: number;   // kg
  wingspan: number;           // meters
  length: number;             // meters
  height: number;             // meters
  
  // Propulsion
  propulsion: PropulsionType;
  motorCount: number;
  motorPower: number;         // watts each
  batteryCapacity?: number;   // mAh
  fuelCapacity?: number;      // liters
  
  // Performance
  flight: FlightEnvelope;
  
  // Sensors & Cameras
  cameras: DroneCamera[];
  sensors: SensorSuite;
  
  // Communications
  comms: CommunicationsSpec;
  
  // Payload
  maxPayload: number;         // kg
  payloadBays: number;
  weapons?: WeaponSystem[];
  
  // Cost (for game economy)
  unitCost: number;           // FORMA tokens
  operatingCostPerHour: number;
  
  // Stealth
  radarCrossSection: number;  // m²
  irSignature: number;        // relative 0-100
  acousticSignature: number;  // dB at 100m
}

// ═══════════════════════════════════════════════════════════════════════════════
// REAL SPEC DRONE STATE — Runtime state of a drone
// ═══════════════════════════════════════════════════════════════════════════════

export interface RealSpecDroneState {
  id: number;
  config: RealSpecDroneConfig;
  
  // Position & Motion
  position: { x: number; y: number; z: number };
  velocity: { x: number; y: number; z: number };
  acceleration: { x: number; y: number; z: number };
  orientation: { roll: number; pitch: number; yaw: number };  // degrees
  angularVelocity: { roll: number; pitch: number; yaw: number };
  
  // Flight state
  altitude: number;           // meters AGL
  altitudeMSL: number;        // meters MSL
  airspeed: number;           // m/s
  groundSpeed: number;        // m/s
  heading: number;            // degrees
  verticalSpeed: number;      // m/s
  
  // Systems
  batteryLevel: number;       // 0-1
  fuelLevel: number;          // 0-1
  signalStrength: number;     // 0-1
  gpsLock: boolean;
  gpsAccuracy: number;
  
  // Cameras — what the organism SEES through
  cameras: DroneCameraState[];
  
  // Health
  health: number;             // 0-1
  motorHealth: number[];      // 0-1 per motor
  sensorHealth: number;       // 0-1
  commsHealth: number;        // 0-1
  
  // Combat
  weaponsArmed: boolean;
  weaponsSafetyOff: boolean;
  targetsInRange: TargetInfo[];
  
  // Mission
  currentMission: MissionState;
  waypoints: Waypoint[];
  currentWaypointIndex: number;
  
  // Organism connection
  organismId: string;
  connectedToOrganism: boolean;
  brainControlSignal: number;  // How much the organism is controlling vs autopilot
  
  // The drone's mini-mind (for low-level autonomy)
  mind: DroneMind;
}

export interface DroneCameraState {
  cameraId: string;
  isActive: boolean;
  
  // Current view
  currentFOV: number;         // degrees
  currentZoom: number;        // 1x = optical, higher = digital
  currentPitch: number;       // gimbal
  currentYaw: number;         // gimbal
  
  // Frame buffer (what the organism "sees")
  currentFrame?: CameraFrame;
  frameRate: number;          // actual fps
  latency: number;            // ms from capture to organism
  
  // Detection results from CV
  detections: Detection[];
  
  // Recording
  isRecording: boolean;
  recordingPath?: string;
}

export interface CameraFrame {
  timestamp: number;
  width: number;
  height: number;
  format: 'RGB' | 'RGBA' | 'YUV' | 'IR' | 'Thermal';
  
  // In a real implementation, this would be actual pixel data
  // For simulation, we represent what's visible in the frame
  visibleObjects: VisibleObject[];
  lighting: number;           // 0-1 ambient light
  visibility: number;         // 0-1 (fog, rain, etc.)
  
  // Metadata
  exposureTime: number;       // ms
  iso: number;
  aperture: number;
}

export interface VisibleObject {
  id: string;
  type: 'Drone' | 'Vehicle' | 'Building' | 'Person' | 'Terrain' | 'Unknown';
  classification?: string;    // More specific classification
  
  // Position in frame
  boundingBox: { x: number; y: number; width: number; height: number };
  
  // 3D position estimate (from stereo, LIDAR, or ranging)
  worldPosition?: { x: number; y: number; z: number };
  distance: number;           // meters
  
  // Tracking
  trackingId?: string;
  confidence: number;         // 0-1
  
  // Threat assessment
  isThreat: boolean;
  threatLevel: number;        // 0-1
  isOwnSwarm: boolean;        // Is this one of our drones?
}

export interface Detection {
  timestamp: number;
  type: 'Visual' | 'Radar' | 'IR' | 'Acoustic' | 'RF';
  objectType: string;
  position: { x: number; y: number; z: number };
  velocity?: { x: number; y: number; z: number };
  confidence: number;
  classification: string;
  isThreat: boolean;
  isTracked: boolean;
  trackId?: string;
}

export interface TargetInfo {
  id: string;
  type: string;
  position: { x: number; y: number; z: number };
  velocity: { x: number; y: number; z: number };
  distance: number;
  bearing: number;            // degrees
  elevation: number;          // degrees
  threatLevel: number;
  isEngaged: boolean;
  timeToImpact?: number;      // seconds if engaged
}

export interface MissionState {
  id: string;
  type: 'Patrol' | 'Recon' | 'Strike' | 'CAS' | 'Escort' | 'Supply' | 'SAR';
  status: 'Planning' | 'Enroute' | 'OnStation' | 'Executing' | 'RTB' | 'Complete' | 'Aborted';
  priority: number;           // 1-10
  objectives: MissionObjective[];
  rules: RulesOfEngagement;
  startTime: number;
  estimatedEndTime: number;
}

export interface MissionObjective {
  id: string;
  type: 'Navigate' | 'Observe' | 'Track' | 'Engage' | 'Deliver' | 'Extract';
  target?: string;
  location?: { x: number; y: number; z: number };
  status: 'Pending' | 'InProgress' | 'Complete' | 'Failed';
  priority: number;
}

export interface RulesOfEngagement {
  canEngageAutonomously: boolean;
  requiresHITLForLethal: boolean;
  minimumConfidenceToEngage: number;  // 0-1
  prohibitedTargets: string[];
  collateralDamageLimit: number;
  weaponsHold: boolean;
  weaponsFree: boolean;
}

export interface Waypoint {
  position: { x: number; y: number; z: number };
  speed: number;              // m/s target speed
  action?: 'Loiter' | 'Scan' | 'Land' | 'RTB';
  loiterTime?: number;        // seconds
}

// ═══════════════════════════════════════════════════════════════════════════════
// DRONE CATALOG — Real world drone specs (for the game)
// ═══════════════════════════════════════════════════════════════════════════════

export const DRONE_CATALOG: Record<string, Partial<RealSpecDroneConfig>> = {
  // Small reconnaissance drone
  'SCOUT_MINI': {
    model: 'Scout Mini MK1',
    manufacturer: 'NOVA Industries',
    category: 'Nano',
    airframe: 'QuadRotor',
    emptyWeight: 0.18,
    maxTakeoffWeight: 0.25,
    wingspan: 0.15,
    length: 0.12,
    height: 0.05,
    propulsion: 'Electric',
    motorCount: 4,
    motorPower: 15,
    batteryCapacity: 1200,
    flight: {
      maxSpeed: 15,
      cruiseSpeed: 10,
      maxAltitude: 500,
      servicesCeiling: 400,
      climbRate: 3,
      descentRate: 2,
      maxRange: 2,
      endurance: 0.5,
      maxWindResistance: 8,
      operatingTemp: [-10, 40],
      ipRating: 'IP43'
    },
    unitCost: 100,
    operatingCostPerHour: 5,
    radarCrossSection: 0.001,
    irSignature: 10,
    acousticSignature: 45
  },
  
  // Medium tactical drone
  'STRIKER_FALCON': {
    model: 'Striker Falcon X2',
    manufacturer: 'NOVA Industries',
    category: 'Small',
    airframe: 'HexaRotor',
    emptyWeight: 8,
    maxTakeoffWeight: 15,
    wingspan: 1.2,
    length: 0.9,
    height: 0.4,
    propulsion: 'Electric',
    motorCount: 6,
    motorPower: 400,
    batteryCapacity: 22000,
    flight: {
      maxSpeed: 25,
      cruiseSpeed: 18,
      maxAltitude: 4000,
      servicesCeiling: 3500,
      climbRate: 8,
      descentRate: 5,
      maxRange: 15,
      endurance: 1.5,
      maxWindResistance: 15,
      operatingTemp: [-20, 45],
      ipRating: 'IP55'
    },
    unitCost: 5000,
    operatingCostPerHour: 100,
    radarCrossSection: 0.05,
    irSignature: 30,
    acousticSignature: 65
  },
  
  // Heavy strike drone
  'GUARDIAN_TITAN': {
    model: 'Guardian Titan UCAV',
    manufacturer: 'NOVA Industries',
    category: 'Medium',
    airframe: 'FixedWing',
    emptyWeight: 120,
    maxTakeoffWeight: 200,
    wingspan: 8,
    length: 6,
    height: 2,
    propulsion: 'Hybrid',
    motorCount: 1,
    motorPower: 75000,
    batteryCapacity: 50000,
    fuelCapacity: 80,
    flight: {
      maxSpeed: 80,
      cruiseSpeed: 50,
      stallSpeed: 25,
      maxAltitude: 10000,
      servicesCeiling: 8000,
      climbRate: 15,
      descentRate: 10,
      maxRange: 500,
      endurance: 24,
      maxWindResistance: 25,
      operatingTemp: [-40, 50],
      ipRating: 'IP67'
    },
    unitCost: 500000,
    operatingCostPerHour: 5000,
    radarCrossSection: 0.5,
    irSignature: 60,
    acousticSignature: 80
  },
  
  // Electronic warfare drone
  'RELAY_SPECTRE': {
    model: 'Relay Spectre EW',
    manufacturer: 'NOVA Industries',
    category: 'Small',
    airframe: 'VTOL',
    emptyWeight: 12,
    maxTakeoffWeight: 20,
    wingspan: 2,
    length: 1.5,
    height: 0.5,
    propulsion: 'Electric',
    motorCount: 4,
    motorPower: 600,
    batteryCapacity: 30000,
    flight: {
      maxSpeed: 30,
      cruiseSpeed: 22,
      maxAltitude: 5000,
      servicesCeiling: 4500,
      climbRate: 10,
      descentRate: 6,
      maxRange: 25,
      endurance: 2.5,
      maxWindResistance: 18,
      operatingTemp: [-25, 45],
      ipRating: 'IP54'
    },
    unitCost: 25000,
    operatingCostPerHour: 200,
    radarCrossSection: 0.03,
    irSignature: 25,
    acousticSignature: 55
  },
  
  // Medical/supply drone
  'MEDIC_ANGEL': {
    model: 'Medic Angel Supply',
    manufacturer: 'NOVA Industries',
    category: 'Small',
    airframe: 'OctoRotor',
    emptyWeight: 6,
    maxTakeoffWeight: 18,
    wingspan: 1.4,
    length: 1.0,
    height: 0.5,
    propulsion: 'Electric',
    motorCount: 8,
    motorPower: 350,
    batteryCapacity: 28000,
    flight: {
      maxSpeed: 20,
      cruiseSpeed: 15,
      maxAltitude: 3000,
      servicesCeiling: 2500,
      climbRate: 6,
      descentRate: 4,
      maxRange: 20,
      endurance: 2,
      maxWindResistance: 12,
      operatingTemp: [-15, 40],
      ipRating: 'IP56'
    },
    maxPayload: 12,
    payloadBays: 2,
    unitCost: 15000,
    operatingCostPerHour: 80,
    radarCrossSection: 0.08,
    irSignature: 20,
    acousticSignature: 58
  }
};

// ═══════════════════════════════════════════════════════════════════════════════
// REAL SPEC CAMERA CATALOG — Actual camera specs
// ═══════════════════════════════════════════════════════════════════════════════

export const CAMERA_CATALOG: Record<string, Partial<CameraSensorSpec>> = {
  // Small FPV camera
  'CAM_MICRO_FPV': {
    sensorType: 'CMOS',
    sensorSize: { width: 6.17, height: 4.55 },
    pixelSize: 1.55,
    resolution: { width: 1920, height: 1080 },
    effectiveMegapixels: 2.07,
    maxFramerate: 60,
    focalLength: 2.8,
    aperture: 2.8,
    fieldOfView: { horizontal: 120, vertical: 90, diagonal: 150 },
    minimumFocusDistance: 0.3,
    dynamicRange: 72,
    iso: [100, 3200],
    isThermal: false,
    hasNightVision: false,
    stabilization: 'EIS',
    weight: 15
  },
  
  // High-resolution reconnaissance camera
  'CAM_RECON_4K': {
    sensorType: 'CMOS',
    sensorSize: { width: 13.2, height: 8.8 },
    pixelSize: 2.4,
    resolution: { width: 4096, height: 2160 },
    effectiveMegapixels: 8.85,
    maxFramerate: 30,
    focalLength: [24, 200],  // 8x optical zoom
    aperture: [2.8, 5.6],
    fieldOfView: { horizontal: 84, vertical: 54, diagonal: 95 },
    minimumFocusDistance: 1.0,
    dynamicRange: 84,
    iso: [100, 12800],
    isThermal: false,
    hasNightVision: true,
    nightVisionType: 'LWIR',
    stabilization: 'Hybrid',
    hasRAW: true,
    weight: 320
  },
  
  // Dual EO/IR targeting camera
  'CAM_TARGETING_DUAL': {
    sensorType: 'CMOS',
    sensorSize: { width: 17.3, height: 13.0 },
    pixelSize: 3.45,
    resolution: { width: 5472, height: 3648 },
    effectiveMegapixels: 20,
    maxFramerate: 60,
    focalLength: [50, 1000],  // 20x optical zoom
    aperture: [2.8, 8.0],
    fieldOfView: { horizontal: 45, vertical: 35, diagonal: 55 },
    minimumFocusDistance: 5.0,
    dynamicRange: 90,
    iso: [100, 25600],
    isThermal: true,
    thermalResolution: { width: 640, height: 512 },
    thermalSensitivity: 30,  // 30mK NETD
    spectralRange: [8, 14],  // LWIR
    hasNightVision: true,
    nightVisionType: 'MWIR',
    irIlluminator: true,
    stabilization: 'Gyroscopic',
    hasRAW: true,
    weight: 2500
  },
  
  // 360-degree situational awareness camera
  'CAM_360_SA': {
    sensorType: 'CMOS',
    sensorSize: { width: 7.4, height: 5.55 },
    pixelSize: 1.4,
    resolution: { width: 5760, height: 2880 },
    effectiveMegapixels: 16.6,
    maxFramerate: 30,
    focalLength: 1.6,
    aperture: 2.0,
    fieldOfView: { horizontal: 360, vertical: 180, diagonal: 360 },
    minimumFocusDistance: 0.5,
    dynamicRange: 75,
    iso: [100, 6400],
    isThermal: false,
    hasNightVision: false,
    stabilization: 'EIS',
    weight: 150
  }
};

// ═══════════════════════════════════════════════════════════════════════════════
// FACTORY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Create a RealSpecDrone from a catalog entry
 */
export function createRealSpecDrone(
  droneType: keyof typeof DRONE_CATALOG,
  id: number,
  organismId: string
): RealSpecDroneState {
  const config = DRONE_CATALOG[droneType] as RealSpecDroneConfig;
  
  // Create the drone's mini-mind
  const droneClass: DroneClass = droneType.startsWith('SCOUT') ? 'SCOUT' :
                                  droneType.startsWith('STRIKER') ? 'STRIKER' :
                                  droneType.startsWith('GUARDIAN') ? 'GUARDIAN' :
                                  droneType.startsWith('RELAY') ? 'RELAY' :
                                  droneType.startsWith('MEDIC') ? 'MEDIC' : 'SCOUT';
  const mind = new DroneMind(id, droneClass);
  
  // Create appropriate cameras for this drone type
  const cameras: DroneCameraState[] = [];
  
  if (droneType === 'SCOUT_MINI') {
    cameras.push(createCameraState('CAM_MICRO_FPV', 'nose_cam'));
  } else if (droneType === 'STRIKER_FALCON') {
    cameras.push(createCameraState('CAM_RECON_4K', 'main_cam'));
    cameras.push(createCameraState('CAM_MICRO_FPV', 'fpv_cam'));
  } else if (droneType === 'GUARDIAN_TITAN') {
    cameras.push(createCameraState('CAM_TARGETING_DUAL', 'targeting_pod'));
    cameras.push(createCameraState('CAM_360_SA', 'sa_cam'));
  } else if (droneType === 'RELAY_SPECTRE') {
    cameras.push(createCameraState('CAM_RECON_4K', 'recon_cam'));
  } else if (droneType === 'MEDIC_ANGEL') {
    cameras.push(createCameraState('CAM_MICRO_FPV', 'nav_cam'));
    cameras.push(createCameraState('CAM_RECON_4K', 'search_cam'));
  }
  
  return {
    id,
    config,
    position: { x: 0, y: 10, z: 0 },
    velocity: { x: 0, y: 0, z: 0 },
    acceleration: { x: 0, y: 0, z: 0 },
    orientation: { roll: 0, pitch: 0, yaw: 0 },
    angularVelocity: { roll: 0, pitch: 0, yaw: 0 },
    altitude: 10,
    altitudeMSL: 10,
    airspeed: 0,
    groundSpeed: 0,
    heading: 0,
    verticalSpeed: 0,
    batteryLevel: 1.0,
    fuelLevel: config.fuelCapacity ? 1.0 : 0,
    signalStrength: 1.0,
    gpsLock: true,
    gpsAccuracy: 2.5,
    cameras,
    health: 1.0,
    motorHealth: Array(config.motorCount).fill(1.0),
    sensorHealth: 1.0,
    commsHealth: 1.0,
    weaponsArmed: false,
    weaponsSafetyOff: false,
    targetsInRange: [],
    currentMission: {
      id: `mission_${id}_init`,
      type: 'Patrol',
      status: 'Planning',
      priority: 5,
      objectives: [],
      rules: {
        canEngageAutonomously: false,
        requiresHITLForLethal: true,
        minimumConfidenceToEngage: 0.9,
        prohibitedTargets: ['Civilian', 'Friendly'],
        collateralDamageLimit: 0,
        weaponsHold: true,
        weaponsFree: false
      },
      startTime: Date.now(),
      estimatedEndTime: Date.now() + 3600000
    },
    waypoints: [],
    currentWaypointIndex: 0,
    organismId,
    connectedToOrganism: true,
    brainControlSignal: 0.8,
    mind
  };
}

function createCameraState(cameraType: keyof typeof CAMERA_CATALOG, cameraId: string): DroneCameraState {
  const spec = CAMERA_CATALOG[cameraType];
  
  return {
    cameraId,
    isActive: true,
    currentFOV: spec?.fieldOfView?.horizontal || 90,
    currentZoom: 1.0,
    currentPitch: 0,
    currentYaw: 0,
    currentFrame: undefined,
    frameRate: spec?.maxFramerate || 30,
    latency: 50,
    detections: [],
    isRecording: false
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLEET MANAGER — Manages all drones in the organism
// ═══════════════════════════════════════════════════════════════════════════════

export class RealSpecDroneFleet {
  private drones: Map<number, RealSpecDroneState> = new Map();
  private nextId: number = 1;
  private organismId: string;
  
  constructor(organismId: string) {
    this.organismId = organismId;
  }
  
  /**
   * Spawn a new drone and add it to the fleet
   */
  spawnDrone(type: keyof typeof DRONE_CATALOG, position: { x: number; y: number; z: number }): RealSpecDroneState {
    const id = this.nextId++;
    const drone = createRealSpecDrone(type, id, this.organismId);
    drone.position = position;
    this.drones.set(id, drone);
    return drone;
  }
  
  /**
   * Get all drones
   */
  getAllDrones(): RealSpecDroneState[] {
    return Array.from(this.drones.values());
  }
  
  /**
   * Get drone by ID
   */
  getDrone(id: number): RealSpecDroneState | undefined {
    return this.drones.get(id);
  }
  
  /**
   * Remove a drone (destroyed or RTB)
   */
  removeDrone(id: number): void {
    this.drones.delete(id);
  }
  
  /**
   * Get all active cameras across the fleet
   * This is what the organism's VISUAL CORTEX sees through
   */
  getAllCameras(): { droneId: number; camera: DroneCameraState }[] {
    const cameras: { droneId: number; camera: DroneCameraState }[] = [];
    
    for (const [droneId, drone] of this.drones) {
      for (const camera of drone.cameras) {
        if (camera.isActive) {
          cameras.push({ droneId, camera });
        }
      }
    }
    
    return cameras;
  }
  
  /**
   * Get combined visual field from all drones
   * This represents what the organism can "see"
   */
  getCombinedVisualField(): VisibleObject[] {
    const allObjects: VisibleObject[] = [];
    const seenIds = new Set<string>();
    
    for (const drone of this.drones.values()) {
      for (const camera of drone.cameras) {
        if (camera.currentFrame) {
          for (const obj of camera.currentFrame.visibleObjects) {
            // Avoid duplicates from multiple cameras seeing same object
            if (!seenIds.has(obj.id)) {
              seenIds.add(obj.id);
              allObjects.push(obj);
            }
          }
        }
      }
    }
    
    return allObjects;
  }
  
  /**
   * Get combined detection field from all sensors
   */
  getCombinedDetections(): Detection[] {
    const allDetections: Detection[] = [];
    
    for (const drone of this.drones.values()) {
      for (const camera of drone.cameras) {
        allDetections.push(...camera.detections);
      }
    }
    
    return allDetections;
  }
  
  /**
   * Update all drones' minds (cognitive tick)
   */
  tickMinds(beat: number, architectSignal: number): void {
    const drones = this.getAllDrones();
    const allPhases = drones.map(d => d.mind.snapshot.phase);
    const allSignals = drones.map(d => d.mind.snapshot.signal);
    const allCortisols = drones.map(d => d.mind.snapshot.cortisol);
    
    // Calculate swarm coherence
    const n = allPhases.length || 1;
    const sumCos = allPhases.reduce((s, p) => s + Math.cos(p), 0) / n;
    const sumSin = allPhases.reduce((s, p) => s + Math.sin(p), 0) / n;
    const rSwarm = Math.min(1, Math.max(0.5, Math.sqrt(sumCos ** 2 + sumSin ** 2)));
    
    // Jasmine drift calculation
    const jDrift = allPhases.reduce((sum, p, i) => {
      return sum + Math.abs(p - (allCortisols[i] || 1));
    }, 0) / n;
    
    // Tick each drone's mind
    for (const drone of drones) {
      const mindState = drone.mind.snapshot;
      const row = drones.map((_, j) => 1.0);  // Simplified Hebbian weights
      const meanHebb = row.reduce((s, w) => s + w, 0) / row.length;
      
      drone.mind.tick(
        beat,
        allPhases,
        allSignals,
        allCortisols,
        rSwarm,
        jDrift,
        meanHebb,
        architectSignal,
        null
      );
    }
  }
  
  /**
   * Get fleet statistics for organism awareness
   */
  getFleetStats(): FleetStatistics {
    const drones = this.getAllDrones();
    const n = drones.length || 1;
    
    return {
      totalDrones: drones.length,
      activeDrones: drones.filter(d => d.health > 0).length,
      totalCameras: drones.reduce((sum, d) => sum + d.cameras.filter(c => c.isActive).length, 0),
      avgHealth: drones.reduce((sum, d) => sum + d.health, 0) / n,
      avgBattery: drones.reduce((sum, d) => sum + d.batteryLevel, 0) / n,
      avgSignal: drones.reduce((sum, d) => sum + d.signalStrength, 0) / n,
      
      // Swarm coherence from minds
      swarmCoherence: (() => {
        const phases = drones.map(d => d.mind.snapshot.phase);
        const cos = phases.reduce((s, p) => s + Math.cos(p), 0) / n;
        const sin = phases.reduce((s, p) => s + Math.sin(p), 0) / n;
        return Math.sqrt(cos ** 2 + sin ** 2);
      })(),
      
      // Coverage
      coverageArea: this.calculateCoverageArea(),
      
      // Combat readiness
      armedCount: drones.filter(d => d.weaponsArmed).length,
      engagedCount: drones.filter(d => d.targetsInRange.length > 0).length
    };
  }
  
  private calculateCoverageArea(): number {
    // Simplified coverage calculation based on drone positions and camera FOV
    const drones = this.getAllDrones();
    if (drones.length === 0) return 0;
    
    let totalArea = 0;
    for (const drone of drones) {
      for (const camera of drone.cameras) {
        if (camera.isActive) {
          // Area covered by this camera at current altitude
          const fovRad = (camera.currentFOV / 2) * (Math.PI / 180);
          const radius = drone.altitude * Math.tan(fovRad);
          totalArea += Math.PI * radius * radius;
        }
      }
    }
    
    // Rough overlap correction (assume 30% overlap)
    return totalArea * 0.7;
  }
}

export interface FleetStatistics {
  totalDrones: number;
  activeDrones: number;
  totalCameras: number;
  avgHealth: number;
  avgBattery: number;
  avgSignal: number;
  swarmCoherence: number;
  coverageArea: number;  // square meters
  armedCount: number;
  engagedCount: number;
}
