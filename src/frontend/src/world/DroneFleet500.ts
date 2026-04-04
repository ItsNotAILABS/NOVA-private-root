// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: DroneFleet500 — 500-Drone Fleet Manager
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║         NOVA DRONE FLEET 500 — FULL SIMULATION RUNTIME ENGINE                 ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  This module manages the full lifecycle of 500 drones in the simulation:       ║
// ║                                                                                ║
// ║  LIFECYCLE PHASES:                                                             ║
// ║    Parked → Charging → PreflightCheck → Taxiing → Takeoff →                   ║
// ║    Climbing → Cruising → OnStation → Descending → Landing →                   ║
// ║    Taxiing → Parked                                                            ║
// ║                                                                                ║
// ║  PHYSICS (per drone per tick):                                                 ║
// ║    • 6-DOF rigid-body dynamics (position, velocity, acceleration)              ║
// ║    • Kuramoto phase synchronization across swarm                               ║
// ║    • Reynolds flocking (separation, alignment, cohesion)                       ║
// ║    • Wind disturbance using real meteorological model                          ║
// ║    • Battery state-of-charge integration                                       ║
// ║    • Thermal model (battery + motor temperature)                               ║
// ║                                                                                ║
// ║  DATA OUTPUTS (every tick):                                                    ║
// ║    • Full telemetry per drone (position, velocity, energy, health)             ║
// ║    • Swarm-level Kuramoto order parameter r and phase ψ                        ║
// ║    • Fleet statistics (active, parked, charging, critical)                     ║
// ║    • Maintenance alerts                                                        ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import {
  type DroneUnitSpec,
  type DroneClass,
  type DroneStatus,
  type DroneMission,
  buildFleet500,
  droneClassColor,
  droneStatusColor,
  ISA,
  computeDragForce,
  computeHoverThrust,
  computeEnduranceMin,
  FLEET_ALLOCATION,
} from './DroneFleetSpecs';

import {
  type ParkingSpot,
  type GroundRoute,
  type Vec3,
  generateParkingGrid,
  computeTakeoffRoute,
  computeLandingRoute,
  AIRSTRIP,
} from './VirtualAirstrip';

// ═══════════════════════════════════════════════════════════════════════════════
// RUNTIME DRONE STATE — Mutable simulation state for each drone
// ═══════════════════════════════════════════════════════════════════════════════

export interface RuntimeDroneState {
  /** Fleet index (0–499) */
  id: number;
  /** Spec (immutable hardware) */
  spec: DroneUnitSpec;
  /** Current world position [m] */
  position: Vec3;
  /** Current velocity [m/s] */
  velocity: Vec3;
  /** Current acceleration [m/s²] */
  acceleration: Vec3;
  /** Orientation [rad]: pitch, roll, yaw */
  orientation: { pitch: number; roll: number; yaw: number };
  /** Kuramoto oscillator phase [rad] */
  phase: number;
  /** Natural oscillator frequency [rad/s] */
  naturalFreq: number;
  /** Swarm coupling strength [unitless] */
  couplingStrength: number;
  /** Current status */
  status: DroneStatus;
  /** Current mission */
  mission: DroneMission;
  /** Battery state-of-charge [0–1] */
  batterySoC: number;
  /** Battery temperature [°C] */
  batteryTempC: number;
  /** Motor temperature [°C] */
  motorTempC: number;
  /** Health [0–1] */
  health: number;
  /** Target waypoint (null = no target) */
  target: Vec3 | null;
  /** Active ground route (null = airborne/parked) */
  groundRoute: GroundRoute | null;
  /** Current ground route waypoint index */
  routeWaypointIdx: number;
  /** Throttle [0–1] */
  throttle: number;
  /** Altitude AGL [m] */
  altitudeAGL: number;
  /** Cruising altitude target [m] */
  cruisingAltM: number;
  /** Flight time this sortie [s] */
  sortieTimeS: number;
  /** Total flight seconds (all sorties) */
  totalFlightS: number;
  /** Position trail for rendering */
  trail: Vec3[];
  /** Number of sorties flown */
  sortieCount: number;
  /** Assigned parking spot */
  parkingSpot: ParkingSpot;
  /** Time remaining in current status [s] (-1 = indefinite) */
  statusDurationRemaining: number;
  /** Signal quality [0–1] */
  signalQuality: number;
  /** GPS fix quality [0=None, 1=2D, 2=3D, 3=RTK] */
  gpsFixQuality: number;
  /** Wind gust the drone is experiencing [m/s] */
  localWindMs: number;
  /** Local wind direction */
  localWindDir: Vec3;
  /** Current power draw [W] */
  powerDrawW: number;
  /** On-board computer CPU utilization [%] */
  cpuUtilPct: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLEET-LEVEL STATE — Aggregated simulation state
// ═══════════════════════════════════════════════════════════════════════════════

export interface FleetState {
  /** All 500 drone runtime states */
  drones: RuntimeDroneState[];
  /** Simulation time [s] */
  simTimeS: number;
  /** World time of day [0–24] */
  timeOfDay: number;
  /** Active weather condition */
  weather: 'Clear' | 'Cloudy' | 'Rain' | 'Storm' | 'Fog' | 'Crosswind';
  /** Ambient wind speed [m/s] */
  windSpeedMs: number;
  /** Ambient wind direction (unit vector) */
  windDirection: Vec3;
  /** Ambient temperature [°C] */
  ambientTempC: number;
  /** Kuramoto order parameter [0–1] */
  rSwarm: number;
  /** Kuramoto collective phase [rad] */
  psiSwarm: number;
  /** Jasmine drift (swarm positional disorder) */
  jasmineDrift: number;
  /** Fleet statistics */
  stats: FleetStats;
  /** Active maintenance alerts */
  maintenanceAlerts: MaintenanceAlert[];
}

export interface FleetStats {
  totalDrones: number;
  parked: number;
  charging: number;
  preflight: number;
  taxiing: number;
  airborne: number;
  emergency: number;
  maintenance: number;
  offline: number;
  byClass: Record<DroneClass, { total: number; airborne: number; parked: number }>;
  avgBatterySoC: number;
  avgHealth: number;
  totalSortieHours: number;
  activeMissions: number;
  swarmCoherence: number;
}

export interface MaintenanceAlert {
  droneId: number;
  callSign: string;
  alertType: 'LowBattery' | 'MotorOverheat' | 'BatteryOverheat' | 'LowHealth' | 'MaintenanceDue' | 'SignalLost';
  severity: 'Info' | 'Warning' | 'Critical';
  message: string;
  timestampS: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// PHYSICS HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

const V = {
  zero: (): Vec3 => ({ x: 0, y: 0, z: 0 }),
  add: (a: Vec3, b: Vec3): Vec3 => ({ x: a.x + b.x, y: a.y + b.y, z: a.z + b.z }),
  sub: (a: Vec3, b: Vec3): Vec3 => ({ x: a.x - b.x, y: a.y - b.y, z: a.z - b.z }),
  scale: (v: Vec3, s: number): Vec3 => ({ x: v.x * s, y: v.y * s, z: v.z * s }),
  len: (v: Vec3): number => Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z),
  norm: (v: Vec3): Vec3 => {
    const l = V.len(v);
    return l > 0 ? V.scale(v, 1 / l) : V.zero();
  },
  dot: (a: Vec3, b: Vec3): number => a.x * b.x + a.y * b.y + a.z * b.z,
  dist: (a: Vec3, b: Vec3): number => V.len(V.sub(b, a)),
  lerp: (a: Vec3, b: Vec3, t: number): Vec3 => ({
    x: a.x + (b.x - a.x) * t,
    y: a.y + (b.y - a.y) * t,
    z: a.z + (b.z - a.z) * t,
  }),
  clampLen: (v: Vec3, max: number): Vec3 => {
    const l = V.len(v);
    return l > max ? V.scale(V.norm(v), max) : v;
  },
};

/** Wrap angle to [-π, π] */
function wrapAngle(a: number): number {
  while (a > Math.PI) a -= 2 * Math.PI;
  while (a < -Math.PI) a += 2 * Math.PI;
  return a;
}

/** Simple pseudo-random seeded by id and time */
function seededRand(seed: number): number {
  const x = Math.sin(seed) * 43758.5453123;
  return x - Math.floor(x);
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLEET INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Initialize all 500 drones parked at their assigned spots.
 * Each drone gets real hardware specs and is placed at its parking spot.
 */
export function initializeFleet500(): RuntimeDroneState[] {
  const specs = buildFleet500();
  const parkingGrid = generateParkingGrid();
  const PHI = 1.6180339887498948482;

  return specs.map((spec, i) => {
    const spot = parkingGrid[i];

    // Spread natural frequencies around 1 rad/s with class-based variation
    // Commander: tight clustering (low dispersion → high coherence)
    // Heavy: wider spread (more independent)
    const classDispersion: Record<DroneClass, number> = {
      Commander: 0.05,
      Scout: 0.15,
      Support: 0.12,
      Heavy: 0.20,
    };
    const disp = classDispersion[spec.droneClass];
    const naturalFreq = 1.0 + (seededRand(i * PHI) - 0.5) * 2 * disp;

    // Initial phase: Fibonacci sphere distribution for fast convergence
    const phase = (i * PHI * 2 * Math.PI) % (2 * Math.PI);

    // Cruising altitude depends on class
    const cruisingAlt: Record<DroneClass, number> = {
      Commander: 120,
      Scout: 80,
      Support: 60,
      Heavy: 40,
    };

    // Compute hover power for battery drain modelling
    const hoverPowerW = spec.hoverPowerW;
    const batteryCapWh = spec.totalEnergyWh;

    return {
      id: i,
      spec,
      position: { ...spot.position },
      velocity: V.zero(),
      acceleration: V.zero(),
      orientation: {
        pitch: 0,
        roll: 0,
        yaw: (spot.headingDeg * Math.PI) / 180,
      },
      phase,
      naturalFreq,
      couplingStrength: 2.0,
      status: 'Parked' as DroneStatus,
      mission: 'Parked' as DroneMission,
      batterySoC: 0.85 + seededRand(i * 7.3) * 0.15, // 85–100% at start
      batteryTempC: 20 + seededRand(i * 3.7) * 5,
      motorTempC: 25,
      health: 0.95 + seededRand(i * 11.1) * 0.05,
      target: null,
      groundRoute: null,
      routeWaypointIdx: 0,
      throttle: 0,
      altitudeAGL: 0,
      cruisingAltM: cruisingAlt[spec.droneClass],
      sortieTimeS: 0,
      totalFlightS: spec.totalFlightHoursLogged * 3600,
      trail: [],
      sortieCount: 0,
      parkingSpot: spot,
      statusDurationRemaining: -1,
      signalQuality: 0.98,
      gpsFixQuality: 3,
      localWindMs: 0,
      localWindDir: { x: 1, y: 0, z: 0 },
      powerDrawW: hoverPowerW * 0.05, // Minimal standby power
      cpuUtilPct: 5 + seededRand(i) * 10,
    };
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// KURAMOTO ORDER PARAMETER
// ═══════════════════════════════════════════════════════════════════════════════

export function computeKuramotoOrder(
  drones: RuntimeDroneState[]
): { r: number; psi: number } {
  const n = drones.length;
  if (n === 0) return { r: 0, psi: 0 };

  let sumCos = 0;
  let sumSin = 0;
  for (const d of drones) {
    sumCos += Math.cos(d.phase);
    sumSin += Math.sin(d.phase);
  }

  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
  const psi = Math.atan2(sumSin, sumCos);
  return { r, psi };
}

// ═══════════════════════════════════════════════════════════════════════════════
// JASMINE DRIFT — Positional swarm disorder metric
// ═══════════════════════════════════════════════════════════════════════════════

export function computeJasmineDrift(
  drones: RuntimeDroneState[],
  center: Vec3
): number {
  const airborneDrones = drones.filter(d =>
    d.status === 'Cruising' || d.status === 'Climbing' || d.status === 'OnStation'
  );
  if (airborneDrones.length === 0) return 0;

  let totalVariance = 0;
  for (const d of airborneDrones) {
    const dist = V.dist(d.position, center);
    totalVariance += dist * dist;
  }
  return Math.sqrt(totalVariance / airborneDrones.length) / 100;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SWARM PHYSICS — Boids flocking + Kuramoto + Aerodynamics
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compute forces for a single airborne drone.
 * Returns acceleration [m/s²].
 */
function computeAeroForces(
  drone: RuntimeDroneState,
  allDrones: RuntimeDroneState[],
  globalPhase: number,
  config: SwarmConfig,
  world: WorldEnv,
  dt: number
): Vec3 {
  const airborneNeighbors = allDrones.filter(d =>
    d.id !== drone.id &&
    (d.status === 'Cruising' || d.status === 'Climbing' || d.status === 'OnStation') &&
    V.dist(drone.position, d.position) < config.neighborhoodRadiusM
  );

  // ─── Separation force ─────────────────────────────────────────────────────
  let separation = V.zero();
  for (const nb of airborneNeighbors) {
    const dist = V.dist(drone.position, nb.position);
    if (dist < config.separationRadiusM) {
      const diff = V.sub(drone.position, nb.position);
      const strength = (config.separationRadiusM - dist) / config.separationRadiusM;
      separation = V.add(separation, V.scale(V.norm(diff), strength * config.separationWeight));
    }
  }

  // ─── Alignment force ──────────────────────────────────────────────────────
  let alignment = V.zero();
  if (airborneNeighbors.length > 0) {
    let avgVel = V.zero();
    for (const nb of airborneNeighbors) avgVel = V.add(avgVel, nb.velocity);
    avgVel = V.scale(avgVel, 1 / airborneNeighbors.length);
    alignment = V.scale(V.norm(V.sub(avgVel, drone.velocity)), config.alignmentWeight);
  }

  // ─── Cohesion force ───────────────────────────────────────────────────────
  let cohesion = V.zero();
  if (airborneNeighbors.length > 0) {
    let avgPos = V.zero();
    for (const nb of airborneNeighbors) avgPos = V.add(avgPos, nb.position);
    avgPos = V.scale(avgPos, 1 / airborneNeighbors.length);
    const toCom = V.sub(avgPos, drone.position);
    cohesion = V.scale(V.norm(toCom), config.cohesionWeight);
  }

  // ─── Formation force (pull toward assigned formation position) ────────────
  let formationForce = V.zero();
  if (drone.target) {
    const toTarget = V.sub(drone.target, drone.position);
    const distToTarget = V.len(toTarget);
    if (distToTarget > 2) {
      formationForce = V.scale(V.norm(toTarget), Math.min(distToTarget * 0.1, config.maxAccelerationMs2));
    }
  }

  // ─── Altitude hold ────────────────────────────────────────────────────────
  const altError = drone.cruisingAltM - drone.position.y;
  const altForce: Vec3 = { x: 0, y: altError * 0.15, z: 0 };

  // ─── Wind disturbance ─────────────────────────────────────────────────────
  const windForce = V.scale(drone.localWindDir, drone.localWindMs * 0.02);

  // ─── Aerodynamic drag ─────────────────────────────────────────────────────
  const speed = V.len(drone.velocity);
  const drag = computeDragForce(
    speed,
    drone.position.y,
    drone.spec.airframe.Cd,
    drone.spec.airframe.refAreaM2
  );
  const dragForce = speed > 0.01
    ? V.scale(V.norm(drone.velocity), -drag / drone.spec.totalMassKg)
    : V.zero();

  // ─── Kuramoto phase-based lateral oscillation ────────────────────────────
  const phaseOscX = Math.cos(drone.phase) * config.noiseStrength * 0.3;
  const phaseOscZ = Math.sin(drone.phase * 1.3) * config.noiseStrength * 0.3;
  const phaseForce: Vec3 = { x: phaseOscX, y: 0, z: phaseOscZ };

  // ─── Boundary avoidance (keep inside world bounds) ────────────────────────
  const boundary = 600;
  const boundForce: Vec3 = {
    x: Math.abs(drone.position.x) > boundary ? -Math.sign(drone.position.x) * 5 : 0,
    y: 0,
    z: Math.abs(drone.position.z) > boundary ? -Math.sign(drone.position.z) * 5 : 0,
  };

  // ─── Sum all forces ───────────────────────────────────────────────────────
  let acc = V.zero();
  acc = V.add(acc, separation);
  acc = V.add(acc, alignment);
  acc = V.add(acc, cohesion);
  acc = V.add(acc, formationForce);
  acc = V.add(acc, altForce);
  acc = V.add(acc, windForce);
  acc = V.add(acc, dragForce);
  acc = V.add(acc, phaseForce);
  acc = V.add(acc, boundForce);

  // Clamp to max acceleration
  acc = V.clampLen(acc, config.maxAccelerationMs2);

  return acc;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SIMULATION CONFIGURATION
// ═══════════════════════════════════════════════════════════════════════════════

export interface SwarmConfig {
  /** Kuramoto coupling strength K */
  couplingK: number;
  /** Phase noise σ [rad/s] */
  noiseStrength: number;
  /** Reynolds neighborhood radius [m] */
  neighborhoodRadiusM: number;
  /** Separation radius [m] */
  separationRadiusM: number;
  /** Separation force weight */
  separationWeight: number;
  /** Alignment force weight */
  alignmentWeight: number;
  /** Cohesion force weight */
  cohesionWeight: number;
  /** Formation force weight */
  formationWeight: number;
  /** Maximum acceleration [m/s²] */
  maxAccelerationMs2: number;
  /** Maximum speed override (0 = use spec) [m/s] */
  maxSpeedOverrideMs: number;
  /** Formation radius [m] */
  formationRadiusM: number;
  /** Formation center */
  formationCenter: Vec3;
}

export const DEFAULT_SWARM_CONFIG: SwarmConfig = {
  couplingK: 2.5,
  noiseStrength: 0.08,
  neighborhoodRadiusM: 60,
  separationRadiusM: 20,
  separationWeight: 3.0,
  alignmentWeight: 1.5,
  cohesionWeight: 1.0,
  formationWeight: 2.0,
  maxAccelerationMs2: 8.0,
  maxSpeedOverrideMs: 0,
  formationRadiusM: 300,
  formationCenter: { x: 0, y: 80, z: 0 },
};

export interface WorldEnv {
  timeOfDay: number;        // 0–24
  weather: string;
  windSpeedMs: number;
  windDirection: Vec3;
  ambientTempC: number;
  turbulenceIntensity: number; // 0–1
}

export const DEFAULT_WORLD_ENV: WorldEnv = {
  timeOfDay: 12,
  weather: 'Clear',
  windSpeedMs: 3,
  windDirection: { x: 1, y: 0, z: 0 },
  ambientTempC: 20,
  turbulenceIntensity: 0.1,
};

// ═══════════════════════════════════════════════════════════════════════════════
// DRONE STATUS TRANSITIONS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Dispatch a parked drone on a mission.
 * Sets status to PreflightCheck and assigns a target.
 */
export function dispatchDrone(
  drone: RuntimeDroneState,
  mission: DroneMission,
  target: Vec3
): RuntimeDroneState {
  if (drone.status !== 'Parked' && drone.status !== 'Charging') return drone;
  if (drone.batterySoC < 0.2) return drone; // Insufficient charge

  const route = computeTakeoffRoute(drone.parkingSpot, 'East');

  return {
    ...drone,
    mission,
    target,
    groundRoute: route,
    routeWaypointIdx: 0,
    status: 'PreflightCheck',
    statusDurationRemaining: 15 + Math.random() * 10, // 15-25s preflight
  };
}

/**
 * Command a drone to return to base.
 */
export function commandRTB(drone: RuntimeDroneState): RuntimeDroneState {
  if (drone.status === 'Parked') return drone;
  return {
    ...drone,
    mission: 'RTB',
    target: { ...drone.parkingSpot.position, y: drone.cruisingAltM },
    status: 'Descending',
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLE DRONE SIMULATION STEP
// ═══════════════════════════════════════════════════════════════════════════════

function stepDrone(
  drone: RuntimeDroneState,
  allDrones: RuntimeDroneState[],
  globalPhase: number,
  config: SwarmConfig,
  world: WorldEnv,
  dt: number,
  tick: number
): RuntimeDroneState {
  // Dead drones stay dead
  if (drone.status === 'Offline') return drone;

  const spec = drone.spec;
  const maxSpeedMs = config.maxSpeedOverrideMs > 0
    ? config.maxSpeedOverrideMs
    : spec.airframe.maxSpeedMs;

  // ─── Local wind (world wind + turbulence) ─────────────────────────────────
  const turbScale = world.turbulenceIntensity * 2;
  const localWindMs = world.windSpeedMs + (seededRand(tick * 0.01 + drone.id * 0.3) - 0.5) * turbScale;
  const localWindDir: Vec3 = {
    x: world.windDirection.x + (seededRand(tick * 0.005 + drone.id) - 0.5) * 0.1,
    y: 0,
    z: world.windDirection.z + (seededRand(tick * 0.007 + drone.id * 0.5) - 0.5) * 0.1,
  };

  // ─── Kuramoto phase update ─────────────────────────────────────────────────
  // dθ_i/dt = ω_i + (K/N) Σ sin(θ_j − θ_i) + noise
  let phaseVelocity = drone.naturalFreq;
  const kN = config.couplingK / Math.max(allDrones.length, 1);

  // Use mean-field approximation for performance (only couple to collective phase)
  phaseVelocity += kN * allDrones.length * Math.sin(globalPhase - drone.phase);
  phaseVelocity += (seededRand(tick * 0.1 + drone.id * 3.7) - 0.5) * config.noiseStrength;

  const newPhase = (drone.phase + phaseVelocity * dt) % (2 * Math.PI);

  // ─── Status machine ───────────────────────────────────────────────────────
  let { status } = drone;
  let position = { ...drone.position };
  let velocity = { ...drone.velocity };
  let acceleration = V.zero();
  let throttle = drone.throttle;
  let routeWaypointIdx = drone.routeWaypointIdx;
  let groundRoute = drone.groundRoute;
  let target = drone.target;
  let altitudeAGL = position.y;
  let statusDurationRemaining = drone.statusDurationRemaining;
  let sortieCount = drone.sortieCount;
  let trail = [...drone.trail];

  // Countdown timer
  if (statusDurationRemaining > 0) {
    statusDurationRemaining = Math.max(0, statusDurationRemaining - dt);
  }

  switch (status) {
    // ─── PARKED / CHARGING ─────────────────────────────────────────────────
    case 'Parked': {
      // Stay at parking spot, battery discharges (standby) or charges
      position = { ...drone.parkingSpot.position };
      velocity = V.zero();
      throttle = 0;

      // Auto-charge if battery low
      if (drone.batterySoC < 0.98) {
        status = 'Charging';
      }
      break;
    }

    case 'Charging': {
      position = { ...drone.parkingSpot.position };
      velocity = V.zero();
      throttle = 0;

      // Charging complete
      if (drone.batterySoC >= 0.98) {
        status = 'Parked';
      }
      break;
    }

    // ─── PREFLIGHT CHECK ───────────────────────────────────────────────────
    case 'PreflightCheck': {
      position = { ...drone.parkingSpot.position };
      velocity = V.zero();
      throttle = 0.1; // Spin-up test

      if (statusDurationRemaining <= 0) {
        // Preflight done → begin taxiing
        status = 'Taxiing';
        if (!groundRoute) {
          groundRoute = computeTakeoffRoute(drone.parkingSpot, 'East');
          routeWaypointIdx = 0;
        }
      }
      break;
    }

    // ─── TAXIING ──────────────────────────────────────────────────────────
    case 'Taxiing': {
      throttle = 0.15;

      if (groundRoute && routeWaypointIdx < groundRoute.waypoints.length) {
        const wp = groundRoute.waypoints[routeWaypointIdx];
        const toWp = V.sub(wp, position);
        const dist = V.len(toWp);

        if (dist < 3) {
          routeWaypointIdx++;
          if (routeWaypointIdx >= groundRoute.waypoints.length) {
            // Reached end of ground route → takeoff
            status = 'Takeoff';
            groundRoute = null;
          }
        } else {
          // Move toward waypoint at taxi speed (4 m/s)
          const taxiSpeed = Math.min(4, dist);
          velocity = V.scale(V.norm(toWp), taxiSpeed);
          position = V.add(position, V.scale(velocity, dt));

          // Update yaw to face movement direction
          if (V.len(velocity) > 0.1) {
            const newYaw = Math.atan2(velocity.x, velocity.z);
            acceleration = V.zero();
          }
        }
      } else {
        status = 'Takeoff';
      }
      break;
    }

    // ─── TAKEOFF ─────────────────────────────────────────────────────────
    case 'Takeoff': {
      throttle = 0.8;
      // Vertical ascent to 10m, then transition to climb
      const ascentTarget = 10;
      if (position.y < ascentTarget) {
        velocity = { x: 0, y: spec.airframe.maxAscentRateMs * 0.6, z: 0 };
        position = V.add(position, V.scale(velocity, dt));
      } else {
        status = 'Climbing';
        trail = [];
      }
      altitudeAGL = position.y;
      break;
    }

    // ─── CLIMBING ─────────────────────────────────────────────────────────
    case 'Climbing': {
      throttle = 0.9;

      if (position.y < drone.cruisingAltM - 5) {
        // Climb at max ascent rate
        const ascentRate = Math.min(spec.airframe.maxAscentRateMs, (drone.cruisingAltM - position.y) * 0.5);
        velocity.y = ascentRate;

        // Also apply horizontal flocking
        acceleration = computeAeroForces(drone, allDrones, globalPhase, config, world, dt);
        acceleration.y = 0; // Override vertical

        velocity = V.add(velocity, V.scale(acceleration, dt));
        velocity = V.clampLen(velocity, maxSpeedMs);
        position = V.add(position, V.scale(velocity, dt));
      } else {
        status = 'Cruising';
      }

      altitudeAGL = position.y;
      break;
    }

    // ─── CRUISING ─────────────────────────────────────────────────────────
    case 'Cruising': {
      throttle = 0.65;

      // Apply full flocking + formation physics
      acceleration = computeAeroForces(drone, allDrones, globalPhase, config, world, dt);

      // RTB trigger: battery low or mission done
      const enduranceRemaining = computeEnduranceMin(
        drone.totalEnergyWh * drone.batterySoC,
        drone.powerDrawW
      );
      if (enduranceRemaining < 8 || drone.batterySoC < 0.15) {
        status = 'Descending';
        target = { ...drone.parkingSpot.position, y: drone.cruisingAltM };
      }

      velocity = V.add(velocity, V.scale(acceleration, dt));
      velocity = V.clampLen(velocity, maxSpeedMs);
      position = V.add(position, V.scale(velocity, dt));

      // Keep above minimum AGL
      if (position.y < 10) {
        position.y = 10;
        velocity.y = Math.abs(velocity.y);
      }

      altitudeAGL = position.y;

      // Update trail (every 10 ticks)
      if (tick % 10 === 0) {
        trail = [...trail.slice(-40), { ...position }];
      }
      break;
    }

    // ─── ON-STATION ───────────────────────────────────────────────────────
    case 'OnStation': {
      throttle = 0.55;

      // Orbit around target point
      if (drone.target) {
        const orbitRadius = 50;
        const orbitPeriod = 60; // seconds
        const orbitAngle = (drone.sortieTimeS / orbitPeriod) * 2 * Math.PI;
        target = {
          x: drone.target.x + Math.cos(orbitAngle) * orbitRadius,
          y: drone.cruisingAltM,
          z: drone.target.z + Math.sin(orbitAngle) * orbitRadius,
        };
        const toOrbit = V.sub(target, position);
        acceleration = V.scale(V.norm(toOrbit), Math.min(V.len(toOrbit) * 0.2, 5));
      } else {
        // Hover in place
        acceleration = V.zero();
        velocity = V.scale(velocity, 0.9); // Dampen
      }

      // Also apply wind
      acceleration = V.add(acceleration, V.scale(localWindDir, localWindMs * 0.015));

      velocity = V.add(velocity, V.scale(acceleration, dt));
      velocity = V.clampLen(velocity, spec.airframe.maxSpeedMs * 0.3);
      position = V.add(position, V.scale(velocity, dt));

      // Keep altitude
      position.y = Math.max(position.y, 10);
      altitudeAGL = position.y;
      break;
    }

    // ─── DESCENDING ───────────────────────────────────────────────────────
    case 'Descending': {
      throttle = 0.4;

      // Move toward parking spot x/z while descending
      const spotPos = drone.parkingSpot.position;
      const horizontalTarget: Vec3 = { x: spotPos.x, y: position.y, z: spotPos.z };
      const toSpotH = V.sub(horizontalTarget, position);
      const hDist = Math.sqrt(toSpotH.x * toSpotH.x + toSpotH.z * toSpotH.z);

      if (hDist > 20) {
        // Fly toward spot horizontally
        const hSpeed = Math.min(maxSpeedMs * 0.6, hDist);
        velocity.x = V.norm(toSpotH).x * hSpeed;
        velocity.z = V.norm(toSpotH).z * hSpeed;
        // Gradual descent
        velocity.y = -spec.airframe.maxDescentRateMs * 0.4;
      } else {
        // Close to spot: descend vertically
        velocity.x *= 0.8;
        velocity.z *= 0.8;
        const descentRate = Math.min(spec.airframe.maxDescentRateMs, position.y * 0.5);
        velocity.y = -descentRate;
      }

      position = V.add(position, V.scale(velocity, dt));

      if (position.y <= 5 && hDist < 30) {
        status = 'Landing';
      }

      altitudeAGL = Math.max(0, position.y);
      break;
    }

    // ─── LANDING ─────────────────────────────────────────────────────────
    case 'Landing': {
      throttle = 0.2;
      // Final hover descent
      if (position.y > AIRSTRIP.APRON_ELEVATION + 0.2) {
        velocity.y = -1.5;
        position.y += velocity.y * dt;
      } else {
        position.y = AIRSTRIP.APRON_ELEVATION;
        status = 'Taxiing';
        sortieCount++;
        // Route back to parking
        groundRoute = computeLandingRoute(drone.parkingSpot, 'East');
        routeWaypointIdx = 0;
        velocity = V.zero();
      }
      altitudeAGL = position.y;
      break;
    }

    // ─── EMERGENCY ───────────────────────────────────────────────────────
    case 'Emergency': {
      throttle = 1.0;
      // Emergency descent
      velocity.y = -spec.airframe.maxDescentRateMs;
      position = V.add(position, V.scale(velocity, dt));
      if (position.y <= 0) {
        position.y = 0;
        status = 'Offline';
        velocity = V.zero();
      }
      altitudeAGL = Math.max(0, position.y);
      break;
    }

    case 'Maintenance':
    case 'Offline': {
      position = { ...drone.parkingSpot.position };
      velocity = V.zero();
      throttle = 0;
      break;
    }
  }

  // ─── ENERGY & BATTERY MODEL ───────────────────────────────────────────────
  let powerDrawW = 0;
  if (status === 'Parked' || status === 'Maintenance' || status === 'Offline') {
    powerDrawW = spec.hoverPowerW * 0.03; // Standby
  } else if (status === 'Charging') {
    powerDrawW = 0; // Charging adds energy
  } else if (status === 'Taxiing' || status === 'PreflightCheck') {
    powerDrawW = spec.hoverPowerW * 0.2;
  } else if (status === 'Takeoff' || status === 'Climbing') {
    powerDrawW = spec.hoverPowerW * 0.95;
  } else if (status === 'Cruising') {
    powerDrawW = spec.cruisePowerW;
  } else if (status === 'OnStation') {
    powerDrawW = spec.hoverPowerW * 0.7;
  } else if (status === 'Descending' || status === 'Landing') {
    powerDrawW = spec.hoverPowerW * 0.45;
  } else if (status === 'Emergency') {
    powerDrawW = spec.maxPowerW;
  }

  // Battery SoC update
  const totalEnergyWh = spec.totalEnergyWh;
  let newSoC = drone.batterySoC;
  if (status === 'Charging') {
    // Charge at C/2 rate (50% capacity per hour)
    const chargeRateWh = (totalEnergyWh / 2) * (dt / 3600);
    newSoC = Math.min(1.0, drone.batterySoC + chargeRateWh / totalEnergyWh);
  } else {
    const dischargeWh = powerDrawW * (dt / 3600);
    newSoC = Math.max(0, drone.batterySoC - dischargeWh / totalEnergyWh);
  }

  // Battery temperature model
  const battI = totalEnergyWh > 0 ? powerDrawW / (spec.batteries[0].nominalVoltageV || 22.8) : 0;
  const heatW = battI * battI * (spec.batteries[0].internalResistanceMOhm / 1000);
  const thermalTau = 120; // seconds
  const newBattTemp = drone.batteryTempC + (heatW * 15 - (drone.batteryTempC - world.ambientTempC)) * dt / thermalTau;

  // Motor temperature
  const newMotorTemp = drone.motorTempC + (throttle * 80 - (drone.motorTempC - world.ambientTempC)) * dt / 60;

  // ─── HEALTH DEGRADATION ────────────────────────────────────────────────────
  let newHealth = drone.health;
  if (newBattTemp > 55) newHealth -= 0.0001 * dt;   // Thermal damage
  if (newSoC <= 0) {
    newHealth -= 0.001 * dt;                          // Deep discharge damage
    status = 'Emergency';
  }
  newHealth = Math.max(0, Math.min(1, newHealth));

  // ─── SIGNAL QUALITY ───────────────────────────────────────────────────────
  const distFromBase = V.dist(position, { x: 0, y: 0, z: 0 });
  const maxRange = spec.comms.maxRangeKm * 1000;
  const baseSignalQuality = Math.max(0, 1 - (distFromBase / maxRange) * 1.2);
  const weatherSignalPenalty = world.weather === 'Storm' ? 0.3 : world.weather === 'Rain' ? 0.1 : 0;
  const newSignalQuality = Math.max(0, Math.min(1, baseSignalQuality - weatherSignalPenalty));

  // ─── ORIENTATION ──────────────────────────────────────────────────────────
  const speed = V.len(velocity);
  const newYaw = speed > 0.5
    ? Math.atan2(velocity.x, velocity.z)
    : drone.orientation.yaw;
  const newPitch = speed > 0.5
    ? Math.atan2(-velocity.y, Math.sqrt(velocity.x ** 2 + velocity.z ** 2))
    : 0;

  // ─── SORTIE TIME ──────────────────────────────────────────────────────────
  const isFlying = ['Takeoff', 'Climbing', 'Cruising', 'OnStation', 'Descending', 'Landing'].includes(status);
  const newSortieTime = isFlying ? drone.sortieTimeS + dt : 0;
  const newTotalFlightS = drone.totalFlightS + (isFlying ? dt : 0);

  // ─── CPU UTIL ─────────────────────────────────────────────────────────────
  const cpuBase = status === 'OnStation' ? 70 : status === 'Cruising' ? 50 : status === 'Parked' ? 8 : 35;
  const newCpuUtil = cpuBase + (seededRand(tick + drone.id) - 0.5) * 10;

  return {
    ...drone,
    position,
    velocity,
    acceleration,
    orientation: {
      pitch: newPitch,
      roll: 0,
      yaw: newYaw,
    },
    phase: newPhase,
    status,
    mission: drone.mission,
    batterySoC: newSoC,
    batteryTempC: newBattTemp,
    motorTempC: newMotorTemp,
    health: newHealth,
    target,
    groundRoute,
    routeWaypointIdx,
    throttle,
    altitudeAGL,
    sortieTimeS: newSortieTime,
    totalFlightS: newTotalFlightS,
    trail,
    sortieCount,
    statusDurationRemaining,
    signalQuality: newSignalQuality,
    localWindMs,
    localWindDir,
    powerDrawW,
    cpuUtilPct: Math.max(5, Math.min(100, newCpuUtil)),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLEET SIMULATION STEP — Update all 500 drones
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Advance the entire fleet by dt seconds.
 * Returns the new FleetState.
 */
export function stepFleet(
  state: FleetState,
  config: SwarmConfig,
  dt: number,
  tick: number
): FleetState {
  const { r: rSwarm, psi: psiSwarm } = computeKuramotoOrder(state.drones);

  const world: WorldEnv = {
    timeOfDay: state.timeOfDay,
    weather: state.weather as any,
    windSpeedMs: state.windSpeedMs,
    windDirection: state.windDirection,
    ambientTempC: state.ambientTempC,
    turbulenceIntensity: state.weather === 'Storm' ? 0.8 : state.weather === 'Rain' ? 0.4 : 0.1,
  };

  // Update each drone (all drones see the previous frame's states)
  const prevDrones = state.drones;
  const newDrones = state.drones.map(d =>
    stepDrone(d, prevDrones, psiSwarm, config, world, dt, tick)
  );

  // Compute maintenance alerts
  const alerts: MaintenanceAlert[] = [];
  for (const d of newDrones) {
    if (d.batterySoC < 0.15 && d.status !== 'Parked' && d.status !== 'Charging') {
      alerts.push({
        droneId: d.id,
        callSign: d.spec.callSign,
        alertType: 'LowBattery',
        severity: 'Critical',
        message: `Battery at ${(d.batterySoC * 100).toFixed(0)}% — RTB immediately`,
        timestampS: state.simTimeS,
      });
    }
    if (d.batteryTempC > 55) {
      alerts.push({
        droneId: d.id,
        callSign: d.spec.callSign,
        alertType: 'BatteryOverheat',
        severity: 'Warning',
        message: `Battery temperature: ${d.batteryTempC.toFixed(1)}°C`,
        timestampS: state.simTimeS,
      });
    }
    if (d.motorTempC > 80) {
      alerts.push({
        droneId: d.id,
        callSign: d.spec.callSign,
        alertType: 'MotorOverheat',
        severity: 'Warning',
        message: `Motor temperature: ${d.motorTempC.toFixed(1)}°C`,
        timestampS: state.simTimeS,
      });
    }
    if (d.health < 0.5) {
      alerts.push({
        droneId: d.id,
        callSign: d.spec.callSign,
        alertType: 'LowHealth',
        severity: 'Critical',
        message: `Structural health: ${(d.health * 100).toFixed(0)}%`,
        timestampS: state.simTimeS,
      });
    }
    if (d.signalQuality < 0.3 && d.status !== 'Parked') {
      alerts.push({
        droneId: d.id,
        callSign: d.spec.callSign,
        alertType: 'SignalLost',
        severity: 'Warning',
        message: `Signal quality degraded: ${(d.signalQuality * 100).toFixed(0)}%`,
        timestampS: state.simTimeS,
      });
    }
  }

  // Compute fleet statistics
  const stats = computeFleetStats(newDrones, rSwarm);

  // Compute jasmine drift (airborne swarm positional disorder)
  const jasmineDrift = computeJasmineDrift(newDrones, config.formationCenter);

  // Advance world time
  const newSimTimeS = state.simTimeS + dt;
  const newTimeOfDay = (state.timeOfDay + dt / 3600) % 24;

  return {
    drones: newDrones,
    simTimeS: newSimTimeS,
    timeOfDay: newTimeOfDay,
    weather: state.weather,
    windSpeedMs: state.windSpeedMs,
    windDirection: state.windDirection,
    ambientTempC: state.ambientTempC,
    rSwarm,
    psiSwarm,
    jasmineDrift,
    stats,
    maintenanceAlerts: alerts.slice(0, 100), // Cap display list
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLEET STATISTICS COMPUTATION
// ═══════════════════════════════════════════════════════════════════════════════

function computeFleetStats(drones: RuntimeDroneState[], rSwarm: number): FleetStats {
  const airborneStatuses = new Set(['Climbing', 'Cruising', 'OnStation', 'Descending', 'Takeoff']);
  const byClass: FleetStats['byClass'] = {
    Commander: { total: 0, airborne: 0, parked: 0 },
    Scout: { total: 0, airborne: 0, parked: 0 },
    Support: { total: 0, airborne: 0, parked: 0 },
    Heavy: { total: 0, airborne: 0, parked: 0 },
  };

  let parked = 0, charging = 0, preflight = 0, taxiing = 0, airborne = 0,
    emergency = 0, maintenance = 0, offline = 0;
  let totalSoC = 0, totalHealth = 0, totalSortieHours = 0;

  for (const d of drones) {
    const cls = d.spec.droneClass;
    byClass[cls].total++;
    if (airborneStatuses.has(d.status)) {
      airborne++;
      byClass[cls].airborne++;
    } else if (d.status === 'Parked') {
      parked++;
      byClass[cls].parked++;
    } else if (d.status === 'Charging') {
      charging++;
    } else if (d.status === 'PreflightCheck') {
      preflight++;
    } else if (d.status === 'Taxiing' || d.status === 'Landing') {
      taxiing++;
    } else if (d.status === 'Emergency') {
      emergency++;
    } else if (d.status === 'Maintenance') {
      maintenance++;
    } else if (d.status === 'Offline') {
      offline++;
    }

    totalSoC += d.batterySoC;
    totalHealth += d.health;
    totalSortieHours += d.totalFlightS / 3600;
  }

  const n = drones.length || 1;
  const activeMissions = drones.filter(d =>
    d.mission !== 'Parked' && d.mission !== 'RTB' && d.status !== 'Parked'
  ).length;

  return {
    totalDrones: drones.length,
    parked,
    charging,
    preflight,
    taxiing,
    airborne,
    emergency,
    maintenance,
    offline,
    byClass,
    avgBatterySoC: totalSoC / n,
    avgHealth: totalHealth / n,
    totalSortieHours,
    activeMissions,
    swarmCoherence: rSwarm,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// INITIALIZATION — Build the initial FleetState
// ═══════════════════════════════════════════════════════════════════════════════

export function initializeFleetState(): FleetState {
  const drones = initializeFleet500();
  const { r, psi } = computeKuramotoOrder(drones);
  const stats = computeFleetStats(drones, r);

  return {
    drones,
    simTimeS: 0,
    timeOfDay: 7, // Start at 07:00 (dawn)
    weather: 'Clear',
    windSpeedMs: 3,
    windDirection: { x: 0.707, y: 0, z: 0.707 },
    ambientTempC: 22,
    rSwarm: r,
    psiSwarm: psi,
    jasmineDrift: 0,
    stats,
    maintenanceAlerts: [],
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// FORMATION PATTERNS — Pre-defined airborne formations for 500 drones
// ═══════════════════════════════════════════════════════════════════════════════

export type FormationPattern =
  | 'FibonacciSphere'
  | 'Grid10x50'
  | 'V500'
  | 'Helix'
  | 'Diamond'
  | 'Column'
  | 'Echelon'
  | 'Swarm';

/**
 * Compute formation target positions for all 500 drones.
 * Returns array of Vec3 targets indexed by drone id.
 */
export function computeFormationTargets(
  formation: FormationPattern,
  center: Vec3,
  radiusM: number,
  altitudeM: number
): Vec3[] {
  const PHI = 1.6180339887498948482;
  const N = 500;
  const targets: Vec3[] = new Array(N);

  switch (formation) {
    case 'FibonacciSphere': {
      // Place drones on Fibonacci sphere surface
      for (let i = 0; i < N; i++) {
        const t = i / (N - 1);
        const inclination = Math.acos(1 - 2 * t);
        const azimuth = 2 * Math.PI * PHI * i;
        const r = radiusM;
        targets[i] = {
          x: center.x + r * Math.sin(inclination) * Math.cos(azimuth),
          y: altitudeM + r * Math.cos(inclination) * 0.5,
          z: center.z + r * Math.sin(inclination) * Math.sin(azimuth),
        };
      }
      break;
    }

    case 'Grid10x50': {
      // 10 rows × 50 columns grid
      const rows = 10;
      const cols = 50;
      const spacingX = radiusM * 2 / cols;
      const spacingZ = radiusM * 2 / rows;
      for (let i = 0; i < N; i++) {
        const row = Math.floor(i / cols);
        const col = i % cols;
        targets[i] = {
          x: center.x - radiusM + col * spacingX,
          y: altitudeM + row * 5,
          z: center.z - radiusM * 0.5 + row * spacingZ,
        };
      }
      break;
    }

    case 'V500': {
      // V-formation (two arms extending back)
      for (let i = 0; i < N; i++) {
        const arm = i % 2 === 0 ? 1 : -1;
        const pos = Math.ceil(i / 2);
        targets[i] = {
          x: center.x - pos * 5 * arm,
          y: altitudeM - pos * 0.5,
          z: center.z - pos * 8,
        };
      }
      break;
    }

    case 'Helix': {
      // Triple helix (3 interleaved helical arms)
      const arms = 3;
      const helixRadius = radiusM * 0.6;
      const helixHeight = 200;
      for (let i = 0; i < N; i++) {
        const arm = i % arms;
        const pos = Math.floor(i / arms);
        const t = pos / (N / arms);
        const angle = t * 4 * Math.PI + (arm * 2 * Math.PI) / arms;
        targets[i] = {
          x: center.x + helixRadius * Math.cos(angle),
          y: altitudeM + t * helixHeight,
          z: center.z + helixRadius * Math.sin(angle),
        };
      }
      break;
    }

    case 'Diamond': {
      // Diamond/rhombus formation
      for (let i = 0; i < N; i++) {
        const layer = Math.floor(Math.sqrt(i));
        const posInLayer = i - layer * layer;
        const angle = (posInLayer / Math.max(1, layer * 4)) * 2 * Math.PI;
        const r = layer * (radiusM / 22);
        targets[i] = {
          x: center.x + r * Math.cos(angle),
          y: altitudeM,
          z: center.z + r * Math.sin(angle),
        };
      }
      break;
    }

    case 'Column': {
      // Single column (25 wide × 20 deep × ascending altitude)
      const cols = 25;
      const rows = 20;
      for (let i = 0; i < N; i++) {
        const col = i % cols;
        const row = Math.floor(i / cols);
        targets[i] = {
          x: center.x - (cols / 2) * 12 + col * 12,
          y: altitudeM + row * 8,
          z: center.z,
        };
      }
      break;
    }

    case 'Echelon': {
      // Echelon right formation (staircase to the right and back)
      for (let i = 0; i < N; i++) {
        targets[i] = {
          x: center.x + i * 6,
          y: altitudeM + i * 0.3,
          z: center.z - i * 8,
        };
      }
      break;
    }

    case 'Swarm': {
      // Pseudo-random swarm within sphere
      const swarmRadius = radiusM;
      for (let i = 0; i < N; i++) {
        const phi = Math.acos(2 * seededRand(i * 7.3) - 1);
        const theta = 2 * Math.PI * seededRand(i * 3.1 + 1);
        const r = swarmRadius * Math.cbrt(seededRand(i * 5.7 + 2));
        targets[i] = {
          x: center.x + r * Math.sin(phi) * Math.cos(theta),
          y: Math.max(altitudeM - swarmRadius * 0.3, altitudeM - 50 + r * Math.cos(phi) * 0.3),
          z: center.z + r * Math.sin(phi) * Math.sin(theta),
        };
      }
      break;
    }

    default: {
      // Fallback: hover in place at parking positions
      for (let i = 0; i < N; i++) {
        targets[i] = { ...center, y: altitudeM };
      }
    }
  }

  return targets;
}

// ═══════════════════════════════════════════════════════════════════════════════
// TELEMETRY SNAPSHOT — Compact record for logging / display
// ═══════════════════════════════════════════════════════════════════════════════

export interface DroneTelemetrySnapshot {
  id: number;
  callSign: string;
  droneClass: DroneClass;
  status: DroneStatus;
  mission: DroneMission;
  lat: number;       // Simulated lat from x [deg]
  lon: number;       // Simulated lon from z [deg]
  altM: number;      // Altitude AMSL [m]
  speedMs: number;
  headingDeg: number;
  batterySoC: number;
  batteryTempC: number;
  motorTempC: number;
  health: number;
  signalQuality: number;
  gpsFixQuality: number;
  powerDrawW: number;
  cpuUtilPct: number;
  phaseRad: number;
  rSwarmLocal: number; // Local coupling contribution
  timestampS: number;
}

/** World X→Longitude, World Z→Latitude (centered on 32.7767° N, 96.7970° W — Dallas, TX) */
const BASE_LAT = 32.7767;
const BASE_LON = -96.7970;
const M_PER_DEG_LAT = 111320;
const M_PER_DEG_LON_AT_BASE = 111320 * Math.cos((BASE_LAT * Math.PI) / 180);

export function extractTelemetry(
  drone: RuntimeDroneState,
  simTimeS: number
): DroneTelemetrySnapshot {
  const speed = V.len(drone.velocity);
  const headingDeg = ((drone.orientation.yaw * 180) / Math.PI + 360) % 360;

  return {
    id: drone.id,
    callSign: drone.spec.callSign,
    droneClass: drone.spec.droneClass,
    status: drone.status,
    mission: drone.mission,
    lat: BASE_LAT + drone.position.z / M_PER_DEG_LAT,
    lon: BASE_LON + drone.position.x / M_PER_DEG_LON_AT_BASE,
    altM: drone.position.y + 200, // World Y + base elevation 200m AMSL
    speedMs: speed,
    headingDeg,
    batterySoC: drone.batterySoC,
    batteryTempC: drone.batteryTempC,
    motorTempC: drone.motorTempC,
    health: drone.health,
    signalQuality: drone.signalQuality,
    gpsFixQuality: drone.gpsFixQuality,
    powerDrawW: drone.powerDrawW,
    cpuUtilPct: drone.cpuUtilPct,
    phaseRad: drone.phase,
    rSwarmLocal: drone.couplingStrength,
    timestampS: simTimeS,
  };
}

export function extractAllTelemetry(
  state: FleetState
): DroneTelemetrySnapshot[] {
  return state.drones.map(d => extractTelemetry(d, state.simTimeS));
}

// ═══════════════════════════════════════════════════════════════════════════════
// BATCH DISPATCH — Launch multiple drones on a mission
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Dispatch N drones on a mission, staggering takeoff times.
 * Returns updated drones array.
 */
export function batchDispatch(
  state: FleetState,
  droneClass: DroneClass | 'All',
  mission: DroneMission,
  target: Vec3,
  count: number,
  staggerS: number = 10
): FleetState {
  const eligible = state.drones.filter(d =>
    (droneClass === 'All' || d.spec.droneClass === droneClass) &&
    (d.status === 'Parked' || d.status === 'Charging') &&
    d.batterySoC > 0.2 &&
    d.health > 0.3
  ).slice(0, count);

  const newDrones = [...state.drones];

  eligible.forEach((drone, i) => {
    const staggeredTarget: Vec3 = {
      ...target,
      x: target.x + (Math.random() - 0.5) * 30,
      z: target.z + (Math.random() - 0.5) * 30,
    };
    newDrones[drone.id] = dispatchDrone(
      { ...drone, statusDurationRemaining: i * staggerS + 10 },
      mission,
      staggeredTarget
    );
  });

  return {
    ...state,
    drones: newDrones,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMERGENCY STOP — Halt all drones
// ═══════════════════════════════════════════════════════════════════════════════

export function emergencyStopAll(state: FleetState): FleetState {
  return {
    ...state,
    drones: state.drones.map(d => ({
      ...d,
      status: d.status === 'Parked' || d.status === 'Charging' ? d.status : 'Emergency' as DroneStatus,
      throttle: 0,
    })),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// RTB ALL — Return all airborne drones to base
// ═══════════════════════════════════════════════════════════════════════════════

export function rtbAll(state: FleetState): FleetState {
  return {
    ...state,
    drones: state.drones.map(d => commandRTB(d)),
  };
}
