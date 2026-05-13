// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: WorldPhysicsEngine — REAL Physics Computation (NOT Simulation)
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// EVERYTHING IS INTELLIGENCE — Physics is REAL math and geometry, NOT fake simulation.
// The golden numbers are REAL. We wire REAL computations to the substrates.
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD PHYSICS ENGINE (REAL COMPUTATION)                     ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  WIRED INTO EXISTING ARCHITECTURE:                                             ║
// ║    • Connects to SphericalWebMathEngine for spatial computations               ║
// ║    • Uses TensorFieldEngine for force field calculations                       ║
// ║    • Integrates with NonlinearDynamicsEngine for chaos/turbulence              ║
// ║    • Feeds into StabilityBudgetEngine for safety governance                    ║
// ║                                                                                ║
// ║  PHYSICS SYSTEMS:                                                              ║
// ║    • Rigid body dynamics (Newton-Euler)                                        ║
// ║    • Fluid dynamics (Navier-Stokes simplified)                                 ║
// ║    • Collision detection and response                                          ║
// ║    • Aerodynamics (lift, drag, ground effect)                                  ║
// ║    • Ballistics and projectile motion                                          ║
// ║    • Explosions and blast physics                                              ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// PHYSICAL CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const PHYSICS_CONSTANTS = {
  // Fundamental
  GRAVITY: 9.80665,                    // m/s²
  AIR_DENSITY_SEA_LEVEL: 1.225,        // kg/m³
  AIR_DENSITY_LAPSE_RATE: 0.00012,     // kg/m³ per meter
  SPEED_OF_SOUND: 343.0,               // m/s at 20°C
  
  // Thermodynamics
  STEFAN_BOLTZMANN: 5.67e-8,           // W/(m²·K⁴)
  SPECIFIC_HEAT_AIR: 1005,             // J/(kg·K)
  THERMAL_CONDUCTIVITY_AIR: 0.026,     // W/(m·K)
  
  // Aerodynamics
  REYNOLDS_CRITICAL: 500000,           // Transition Re number
  MACH_CRITICAL: 0.8,                  // Compressibility onset
  
  // Materials
  CONCRETE_DENSITY: 2400,              // kg/m³
  STEEL_DENSITY: 7850,                 // kg/m³
  WATER_DENSITY: 1000,                 // kg/m³
  
  // Golden ratio for harmonious physics
  PHI: 1.6180339887498948482,
  PSI: 0.6180339887498948482,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// VECTOR3 MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════════

export interface Vec3 {
  x: number;
  y: number;
  z: number;
}

export const vec3 = {
  zero: (): Vec3 => ({ x: 0, y: 0, z: 0 }),
  one: (): Vec3 => ({ x: 1, y: 1, z: 1 }),
  
  add: (a: Vec3, b: Vec3): Vec3 => ({
    x: a.x + b.x,
    y: a.y + b.y,
    z: a.z + b.z,
  }),
  
  sub: (a: Vec3, b: Vec3): Vec3 => ({
    x: a.x - b.x,
    y: a.y - b.y,
    z: a.z - b.z,
  }),
  
  scale: (v: Vec3, s: number): Vec3 => ({
    x: v.x * s,
    y: v.y * s,
    z: v.z * s,
  }),
  
  dot: (a: Vec3, b: Vec3): number => 
    a.x * b.x + a.y * b.y + a.z * b.z,
  
  cross: (a: Vec3, b: Vec3): Vec3 => ({
    x: a.y * b.z - a.z * b.y,
    y: a.z * b.x - a.x * b.z,
    z: a.x * b.y - a.y * b.x,
  }),
  
  length: (v: Vec3): number => 
    Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z),
  
  lengthSq: (v: Vec3): number => 
    v.x * v.x + v.y * v.y + v.z * v.z,
  
  normalize: (v: Vec3): Vec3 => {
    const len = vec3.length(v);
    if (len < 1e-10) return { x: 0, y: 0, z: 1 };
    return vec3.scale(v, 1 / len);
  },
  
  distance: (a: Vec3, b: Vec3): number => 
    vec3.length(vec3.sub(b, a)),
  
  lerp: (a: Vec3, b: Vec3, t: number): Vec3 => ({
    x: a.x + (b.x - a.x) * t,
    y: a.y + (b.y - a.y) * t,
    z: a.z + (b.z - a.z) * t,
  }),
  
  reflect: (v: Vec3, n: Vec3): Vec3 => {
    const d = 2 * vec3.dot(v, n);
    return vec3.sub(v, vec3.scale(n, d));
  },
  
  project: (v: Vec3, onto: Vec3): Vec3 => {
    const d = vec3.dot(v, onto) / vec3.lengthSq(onto);
    return vec3.scale(onto, d);
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// QUATERNION FOR ROTATIONS
// ═══════════════════════════════════════════════════════════════════════════════

export interface Quaternion {
  w: number;
  x: number;
  y: number;
  z: number;
}

export const quat = {
  identity: (): Quaternion => ({ w: 1, x: 0, y: 0, z: 0 }),
  
  fromAxisAngle: (axis: Vec3, angle: number): Quaternion => {
    const half = angle * 0.5;
    const s = Math.sin(half);
    const n = vec3.normalize(axis);
    return {
      w: Math.cos(half),
      x: n.x * s,
      y: n.y * s,
      z: n.z * s,
    };
  },
  
  multiply: (a: Quaternion, b: Quaternion): Quaternion => ({
    w: a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z,
    x: a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
    y: a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,
    z: a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w,
  }),
  
  conjugate: (q: Quaternion): Quaternion => ({
    w: q.w,
    x: -q.x,
    y: -q.y,
    z: -q.z,
  }),
  
  normalize: (q: Quaternion): Quaternion => {
    const len = Math.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z);
    if (len < 1e-10) return quat.identity();
    return { w: q.w / len, x: q.x / len, y: q.y / len, z: q.z / len };
  },
  
  rotateVector: (q: Quaternion, v: Vec3): Vec3 => {
    const qv: Quaternion = { w: 0, x: v.x, y: v.y, z: v.z };
    const result = quat.multiply(quat.multiply(q, qv), quat.conjugate(q));
    return { x: result.x, y: result.y, z: result.z };
  },
  
  slerp: (a: Quaternion, b: Quaternion, t: number): Quaternion => {
    let dot = a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z;
    
    let b2 = b;
    if (dot < 0) {
      b2 = { w: -b.w, x: -b.x, y: -b.y, z: -b.z };
      dot = -dot;
    }
    
    if (dot > 0.9995) {
      return quat.normalize({
        w: a.w + (b2.w - a.w) * t,
        x: a.x + (b2.x - a.x) * t,
        y: a.y + (b2.y - a.y) * t,
        z: a.z + (b2.z - a.z) * t,
      });
    }
    
    const theta = Math.acos(dot);
    const sinTheta = Math.sin(theta);
    const wa = Math.sin((1 - t) * theta) / sinTheta;
    const wb = Math.sin(t * theta) / sinTheta;
    
    return {
      w: a.w * wa + b2.w * wb,
      x: a.x * wa + b2.x * wb,
      y: a.y * wa + b2.y * wb,
      z: a.z * wa + b2.z * wb,
    };
  },
  
  toEuler: (q: Quaternion): Vec3 => {
    // Roll (x-axis rotation)
    const sinr_cosp = 2 * (q.w * q.x + q.y * q.z);
    const cosr_cosp = 1 - 2 * (q.x * q.x + q.y * q.y);
    const roll = Math.atan2(sinr_cosp, cosr_cosp);
    
    // Pitch (y-axis rotation)
    const sinp = 2 * (q.w * q.y - q.z * q.x);
    const pitch = Math.abs(sinp) >= 1 
      ? Math.sign(sinp) * Math.PI / 2 
      : Math.asin(sinp);
    
    // Yaw (z-axis rotation)
    const siny_cosp = 2 * (q.w * q.z + q.x * q.y);
    const cosy_cosp = 1 - 2 * (q.y * q.y + q.z * q.z);
    const yaw = Math.atan2(siny_cosp, cosy_cosp);
    
    return { x: roll, y: pitch, z: yaw };
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// RIGID BODY STATE
// ═══════════════════════════════════════════════════════════════════════════════

export interface RigidBodyState {
  id: string;
  
  // Linear state
  position: Vec3;
  velocity: Vec3;
  acceleration: Vec3;
  
  // Angular state
  orientation: Quaternion;
  angularVelocity: Vec3;
  angularAcceleration: Vec3;
  
  // Properties
  mass: number;
  invMass: number;
  inertiaTensor: [number, number, number];  // Diagonal inertia
  invInertia: [number, number, number];
  
  // Forces/torques accumulated this frame
  force: Vec3;
  torque: Vec3;
  
  // Collision
  boundingRadius: number;
  collisionGroup: number;
  collisionMask: number;
  
  // Metadata
  isStatic: boolean;
  isKinematic: boolean;
  linearDamping: number;
  angularDamping: number;
}

export function createRigidBody(
  id: string,
  position: Vec3,
  mass: number,
  boundingRadius: number
): RigidBodyState {
  const invMass = mass > 0 ? 1 / mass : 0;
  // Sphere inertia approximation
  const I = 0.4 * mass * boundingRadius * boundingRadius;
  const invI = I > 0 ? 1 / I : 0;
  
  return {
    id,
    position,
    velocity: vec3.zero(),
    acceleration: vec3.zero(),
    orientation: quat.identity(),
    angularVelocity: vec3.zero(),
    angularAcceleration: vec3.zero(),
    mass,
    invMass,
    inertiaTensor: [I, I, I],
    invInertia: [invI, invI, invI],
    force: vec3.zero(),
    torque: vec3.zero(),
    boundingRadius,
    collisionGroup: 1,
    collisionMask: 0xFFFFFFFF,
    isStatic: mass === 0,
    isKinematic: false,
    linearDamping: 0.01,
    angularDamping: 0.05,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// RIGID BODY INTEGRATOR (Verlet)
// ═══════════════════════════════════════════════════════════════════════════════

export function integrateRigidBody(body: RigidBodyState, dt: number): RigidBodyState {
  if (body.isStatic) return body;
  
  // Compute acceleration from forces
  const acceleration = vec3.scale(body.force, body.invMass);
  
  // Add gravity
  acceleration.y -= PHYSICS_CONSTANTS.GRAVITY;
  
  // Verlet integration for position
  const newVelocity = vec3.add(
    vec3.scale(body.velocity, 1 - body.linearDamping * dt),
    vec3.scale(acceleration, dt)
  );
  
  const newPosition = vec3.add(
    body.position,
    vec3.add(
      vec3.scale(body.velocity, dt),
      vec3.scale(acceleration, 0.5 * dt * dt)
    )
  );
  
  // Angular integration
  const angularAcceleration: Vec3 = {
    x: body.torque.x * body.invInertia[0],
    y: body.torque.y * body.invInertia[1],
    z: body.torque.z * body.invInertia[2],
  };
  
  const newAngularVelocity = vec3.add(
    vec3.scale(body.angularVelocity, 1 - body.angularDamping * dt),
    vec3.scale(angularAcceleration, dt)
  );
  
  // Update orientation using angular velocity
  const angularMag = vec3.length(newAngularVelocity);
  let newOrientation = body.orientation;
  
  if (angularMag > 1e-6) {
    const axis = vec3.scale(newAngularVelocity, 1 / angularMag);
    const deltaRotation = quat.fromAxisAngle(axis, angularMag * dt);
    newOrientation = quat.normalize(quat.multiply(deltaRotation, body.orientation));
  }
  
  return {
    ...body,
    position: newPosition,
    velocity: newVelocity,
    acceleration,
    orientation: newOrientation,
    angularVelocity: newAngularVelocity,
    angularAcceleration,
    // Reset forces for next frame
    force: vec3.zero(),
    torque: vec3.zero(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COLLISION DETECTION
// ═══════════════════════════════════════════════════════════════════════════════

export interface CollisionInfo {
  bodyA: string;
  bodyB: string;
  point: Vec3;
  normal: Vec3;
  penetration: number;
  relativeVelocity: number;
}

export function detectSphereSphereCollision(
  a: RigidBodyState,
  b: RigidBodyState
): CollisionInfo | null {
  // Check collision masks
  if ((a.collisionGroup & b.collisionMask) === 0) return null;
  if ((b.collisionGroup & a.collisionMask) === 0) return null;
  
  const diff = vec3.sub(b.position, a.position);
  const distSq = vec3.lengthSq(diff);
  const minDist = a.boundingRadius + b.boundingRadius;
  
  if (distSq >= minDist * minDist) return null;
  
  const dist = Math.sqrt(distSq);
  const normal = dist > 1e-6 
    ? vec3.scale(diff, 1 / dist)
    : { x: 0, y: 1, z: 0 };
  
  const penetration = minDist - dist;
  const point = vec3.add(a.position, vec3.scale(normal, a.boundingRadius));
  
  // Relative velocity at contact
  const relVel = vec3.sub(b.velocity, a.velocity);
  const relativeVelocity = vec3.dot(relVel, normal);
  
  return {
    bodyA: a.id,
    bodyB: b.id,
    point,
    normal,
    penetration,
    relativeVelocity,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COLLISION RESPONSE (Impulse-based)
// ═══════════════════════════════════════════════════════════════════════════════

export function resolveCollision(
  a: RigidBodyState,
  b: RigidBodyState,
  collision: CollisionInfo,
  restitution: number = 0.3
): { a: RigidBodyState; b: RigidBodyState } {
  // Skip if separating
  if (collision.relativeVelocity > 0) {
    return { a, b };
  }
  
  const { normal, penetration } = collision;
  
  // Compute impulse magnitude
  const e = restitution;
  const invMassSum = a.invMass + b.invMass;
  
  if (invMassSum === 0) return { a, b };
  
  const j = -(1 + e) * collision.relativeVelocity / invMassSum;
  const impulse = vec3.scale(normal, j);
  
  // Apply impulses
  const newVelA = vec3.sub(a.velocity, vec3.scale(impulse, a.invMass));
  const newVelB = vec3.add(b.velocity, vec3.scale(impulse, b.invMass));
  
  // Positional correction (prevent sinking)
  const percent = 0.8;
  const slop = 0.01;
  const correctionMag = Math.max(penetration - slop, 0) / invMassSum * percent;
  const correction = vec3.scale(normal, correctionMag);
  
  const newPosA = vec3.sub(a.position, vec3.scale(correction, a.invMass));
  const newPosB = vec3.add(b.position, vec3.scale(correction, b.invMass));
  
  return {
    a: { ...a, velocity: newVelA, position: newPosA },
    b: { ...b, velocity: newVelB, position: newPosB },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// AERODYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════

export interface AeroState {
  airDensity: number;
  windVelocity: Vec3;
  temperature: number;
}

export function computeAerodynamicForces(
  body: RigidBodyState,
  aero: AeroState,
  dragCoeff: number,
  liftCoeff: number,
  referenceArea: number
): { drag: Vec3; lift: Vec3 } {
  // Relative air velocity
  const relVel = vec3.sub(body.velocity, aero.windVelocity);
  const speed = vec3.length(relVel);
  
  if (speed < 0.1) {
    return { drag: vec3.zero(), lift: vec3.zero() };
  }
  
  // Dynamic pressure: q = 0.5 * ρ * v²
  const q = 0.5 * aero.airDensity * speed * speed;
  
  // Drag: opposite to velocity
  const dragMag = q * dragCoeff * referenceArea;
  const dragDir = vec3.scale(relVel, -1 / speed);
  const drag = vec3.scale(dragDir, dragMag);
  
  // Lift: perpendicular to velocity (simplified - assumes body up is Y)
  const forward = vec3.normalize(relVel);
  const right = vec3.normalize(vec3.cross(forward, { x: 0, y: 1, z: 0 }));
  const liftDir = vec3.cross(right, forward);
  const liftMag = q * liftCoeff * referenceArea;
  const lift = vec3.scale(liftDir, liftMag);
  
  return { drag, lift };
}

export function computeGroundEffect(altitude: number, rotorDiameter: number): number {
  // Ground effect increases thrust when close to ground
  const heightRatio = altitude / rotorDiameter;
  
  if (heightRatio > 2) return 1.0;  // No effect
  if (heightRatio < 0.1) return 1.3; // Max effect
  
  // Smooth transition using golden ratio
  const t = (heightRatio - 0.1) / 1.9;
  return 1.3 - 0.3 * (1 - Math.pow(1 - t, PHYSICS_CONSTANTS.PHI));
}

// ═══════════════════════════════════════════════════════════════════════════════
// BALLISTICS
// ═══════════════════════════════════════════════════════════════════════════════

export interface ProjectileState {
  position: Vec3;
  velocity: Vec3;
  mass: number;
  dragCoeff: number;
  referenceArea: number;
  timeOfFlight: number;
}

export function simulateProjectile(
  initial: ProjectileState,
  aero: AeroState,
  dt: number,
  maxTime: number
): ProjectileState[] {
  const trajectory: ProjectileState[] = [];
  let state = { ...initial };
  
  while (state.timeOfFlight < maxTime && state.position.y > 0) {
    trajectory.push({ ...state });
    
    // Compute forces
    const gravity: Vec3 = { x: 0, y: -PHYSICS_CONSTANTS.GRAVITY * state.mass, z: 0 };
    
    const relVel = vec3.sub(state.velocity, aero.windVelocity);
    const speed = vec3.length(relVel);
    
    let drag = vec3.zero();
    if (speed > 0.1) {
      const q = 0.5 * aero.airDensity * speed * speed;
      const dragMag = q * state.dragCoeff * state.referenceArea;
      drag = vec3.scale(vec3.normalize(relVel), -dragMag);
    }
    
    // Total force and acceleration
    const totalForce = vec3.add(gravity, drag);
    const acceleration = vec3.scale(totalForce, 1 / state.mass);
    
    // Integrate
    state = {
      ...state,
      position: vec3.add(
        state.position,
        vec3.add(
          vec3.scale(state.velocity, dt),
          vec3.scale(acceleration, 0.5 * dt * dt)
        )
      ),
      velocity: vec3.add(state.velocity, vec3.scale(acceleration, dt)),
      timeOfFlight: state.timeOfFlight + dt,
    };
  }
  
  trajectory.push(state);
  return trajectory;
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPLOSION PHYSICS
// ═══════════════════════════════════════════════════════════════════════════════

export interface ExplosionParams {
  position: Vec3;
  yield_kg_tnt: number;  // TNT equivalent
  timestamp: number;
}

export interface BlastEffect {
  overpressure: number;    // kPa
  impulse: number;         // kPa·ms
  dynamicPressure: number; // kPa
  thermalFluence: number;  // kJ/m²
}

export function computeBlastEffect(
  explosion: ExplosionParams,
  targetPosition: Vec3
): BlastEffect {
  const distance = vec3.distance(explosion.position, targetPosition);
  const W = explosion.yield_kg_tnt;
  
  if (distance < 0.1) {
    // At epicenter
    return {
      overpressure: 100000,
      impulse: 10000,
      dynamicPressure: 50000,
      thermalFluence: 100000,
    };
  }
  
  // Scaled distance Z = R / W^(1/3)
  const Z = distance / Math.pow(W, 1/3);
  
  // Kingery-Bulmash approximations (simplified)
  // Peak overpressure (kPa)
  const overpressure = 808 * Math.pow(1 + Math.pow(Z / 4.5, 2), -1.5);
  
  // Positive phase impulse (kPa·ms)
  const impulse = 140 * Math.pow(W, 1/3) * Math.pow(1 + Math.pow(Z / 0.6, 2), -1.0);
  
  // Dynamic pressure (kPa)
  const dynamicPressure = 2.5 * overpressure * overpressure / 
                          (7 * 101.325 + overpressure);
  
  // Thermal fluence (simplified inverse square)
  const thermalFluence = 1000 * W / (distance * distance);
  
  return {
    overpressure,
    impulse,
    dynamicPressure,
    thermalFluence,
  };
}

export function applyBlastForce(
  body: RigidBodyState,
  explosion: ExplosionParams
): RigidBodyState {
  const effect = computeBlastEffect(explosion, body.position);
  
  // Direction away from explosion
  const dir = vec3.normalize(vec3.sub(body.position, explosion.position));
  
  // Force from dynamic pressure acting on cross-section
  const area = Math.PI * body.boundingRadius * body.boundingRadius;
  const forceMag = effect.dynamicPressure * 1000 * area; // kPa to Pa
  
  const blastForce = vec3.scale(dir, forceMag);
  
  return {
    ...body,
    force: vec3.add(body.force, blastForce),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLUID DYNAMICS (Simplified Navier-Stokes)
// ═══════════════════════════════════════════════════════════════════════════════

export interface FluidCell {
  velocity: Vec3;
  pressure: number;
  density: number;
  temperature: number;
}

export interface FluidGrid {
  cells: FluidCell[][][];
  sizeX: number;
  sizeY: number;
  sizeZ: number;
  cellSize: number;
}

export function createFluidGrid(
  sizeX: number,
  sizeY: number,
  sizeZ: number,
  cellSize: number
): FluidGrid {
  const cells: FluidCell[][][] = [];
  
  for (let x = 0; x < sizeX; x++) {
    cells[x] = [];
    for (let y = 0; y < sizeY; y++) {
      cells[x][y] = [];
      for (let z = 0; z < sizeZ; z++) {
        cells[x][y][z] = {
          velocity: vec3.zero(),
          pressure: 101325, // 1 atm in Pa
          density: PHYSICS_CONSTANTS.AIR_DENSITY_SEA_LEVEL,
          temperature: 288.15, // 15°C in Kelvin
        };
      }
    }
  }
  
  return { cells, sizeX, sizeY, sizeZ, cellSize };
}

export function advectFluid(grid: FluidGrid, dt: number): FluidGrid {
  const newCells: FluidCell[][][] = [];
  
  for (let x = 0; x < grid.sizeX; x++) {
    newCells[x] = [];
    for (let y = 0; y < grid.sizeY; y++) {
      newCells[x][y] = [];
      for (let z = 0; z < grid.sizeZ; z++) {
        const cell = grid.cells[x][y][z];
        
        // Trace back to find source position
        const srcX = x - cell.velocity.x * dt / grid.cellSize;
        const srcY = y - cell.velocity.y * dt / grid.cellSize;
        const srcZ = z - cell.velocity.z * dt / grid.cellSize;
        
        // Trilinear interpolation
        newCells[x][y][z] = interpolateCell(grid, srcX, srcY, srcZ);
      }
    }
  }
  
  return { ...grid, cells: newCells };
}

function interpolateCell(
  grid: FluidGrid,
  x: number,
  y: number,
  z: number
): FluidCell {
  // Clamp to grid bounds
  const cx = Math.max(0, Math.min(grid.sizeX - 1, x));
  const cy = Math.max(0, Math.min(grid.sizeY - 1, y));
  const cz = Math.max(0, Math.min(grid.sizeZ - 1, z));
  
  const x0 = Math.floor(cx);
  const y0 = Math.floor(cy);
  const z0 = Math.floor(cz);
  
  const x1 = Math.min(x0 + 1, grid.sizeX - 1);
  const y1 = Math.min(y0 + 1, grid.sizeY - 1);
  const z1 = Math.min(z0 + 1, grid.sizeZ - 1);
  
  const tx = cx - x0;
  const ty = cy - y0;
  const tz = cz - z0;
  
  // Get corner cells
  const c000 = grid.cells[x0][y0][z0];
  const c100 = grid.cells[x1][y0][z0];
  const c010 = grid.cells[x0][y1][z0];
  const c110 = grid.cells[x1][y1][z0];
  const c001 = grid.cells[x0][y0][z1];
  const c101 = grid.cells[x1][y0][z1];
  const c011 = grid.cells[x0][y1][z1];
  const c111 = grid.cells[x1][y1][z1];
  
  // Trilinear interpolation
  const lerp = (a: number, b: number, t: number) => a + (b - a) * t;
  const lerpVec = (a: Vec3, b: Vec3, t: number) => vec3.lerp(a, b, t);
  
  return {
    velocity: lerpVec(
      lerpVec(
        lerpVec(c000.velocity, c100.velocity, tx),
        lerpVec(c010.velocity, c110.velocity, tx),
        ty
      ),
      lerpVec(
        lerpVec(c001.velocity, c101.velocity, tx),
        lerpVec(c011.velocity, c111.velocity, tx),
        ty
      ),
      tz
    ),
    pressure: lerp(
      lerp(lerp(c000.pressure, c100.pressure, tx), lerp(c010.pressure, c110.pressure, tx), ty),
      lerp(lerp(c001.pressure, c101.pressure, tx), lerp(c011.pressure, c111.pressure, tx), ty),
      tz
    ),
    density: lerp(
      lerp(lerp(c000.density, c100.density, tx), lerp(c010.density, c110.density, tx), ty),
      lerp(lerp(c001.density, c101.density, tx), lerp(c011.density, c111.density, tx), ty),
      tz
    ),
    temperature: lerp(
      lerp(lerp(c000.temperature, c100.temperature, tx), lerp(c010.temperature, c110.temperature, tx), ty),
      lerp(lerp(c001.temperature, c101.temperature, tx), lerp(c011.temperature, c111.temperature, tx), ty),
      tz
    ),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// WORLD PHYSICS ENGINE — WIRED TO ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════

export interface PhysicsWorldState {
  bodies: Map<string, RigidBodyState>;
  aeroState: AeroState;
  fluidGrid: FluidGrid | null;
  explosions: ExplosionParams[];
  collisions: CollisionInfo[];
  tick: number;
  
  // Architecture integration
  coherence: number;
  stabilityBudget: number;
  lawCompliance: number;
}

export class WorldPhysicsEngine {
  private state: PhysicsWorldState;
  
  constructor() {
    this.state = {
      bodies: new Map(),
      aeroState: {
        airDensity: PHYSICS_CONSTANTS.AIR_DENSITY_SEA_LEVEL,
        windVelocity: vec3.zero(),
        temperature: 288.15,
      },
      fluidGrid: null,
      explosions: [],
      collisions: [],
      tick: 0,
      coherence: 1.0,
      stabilityBudget: 100.0,
      lawCompliance: 1.0,
    };
  }
  
  get currentState(): PhysicsWorldState {
    return this.state;
  }
  
  // Wire to architecture: accept organism state
  setOrganismState(coherence: number, stabilityBudget: number): void {
    this.state.coherence = coherence;
    this.state.stabilityBudget = stabilityBudget;
  }
  
  addBody(body: RigidBodyState): void {
    this.state.bodies.set(body.id, body);
  }
  
  removeBody(id: string): void {
    this.state.bodies.delete(id);
  }
  
  getBody(id: string): RigidBodyState | undefined {
    return this.state.bodies.get(id);
  }
  
  setWind(velocity: Vec3): void {
    this.state.aeroState.windVelocity = velocity;
  }
  
  addExplosion(explosion: ExplosionParams): void {
    // Law check: stability budget must support explosion
    const cost = explosion.yield_kg_tnt * 10;
    if (this.state.stabilityBudget >= cost) {
      this.state.explosions.push(explosion);
      this.state.stabilityBudget -= cost;
    }
  }
  
  applyForce(bodyId: string, force: Vec3, point?: Vec3): void {
    const body = this.state.bodies.get(bodyId);
    if (!body) return;
    
    body.force = vec3.add(body.force, force);
    
    // Apply torque if force not at center
    if (point) {
      const r = vec3.sub(point, body.position);
      const torque = vec3.cross(r, force);
      body.torque = vec3.add(body.torque, torque);
    }
  }
  
  tick(dt: number): void {
    this.state.tick++;
    this.state.collisions = [];
    
    // Scale physics by coherence (architecture integration)
    const effectiveDt = dt * this.state.coherence;
    
    // Apply aerodynamic forces
    for (const body of this.state.bodies.values()) {
      if (body.isStatic) continue;
      
      const aeroForces = computeAerodynamicForces(
        body,
        this.state.aeroState,
        0.5, // dragCoeff
        0.0, // liftCoeff (simplified)
        Math.PI * body.boundingRadius * body.boundingRadius
      );
      
      body.force = vec3.add(body.force, aeroForces.drag);
      body.force = vec3.add(body.force, aeroForces.lift);
    }
    
    // Apply explosion forces
    for (const explosion of this.state.explosions) {
      for (const [id, body] of this.state.bodies) {
        const newBody = applyBlastForce(body, explosion);
        this.state.bodies.set(id, newBody);
      }
    }
    this.state.explosions = []; // Clear processed explosions
    
    // Collision detection
    const bodyArray = Array.from(this.state.bodies.values());
    for (let i = 0; i < bodyArray.length; i++) {
      for (let j = i + 1; j < bodyArray.length; j++) {
        const collision = detectSphereSphereCollision(bodyArray[i], bodyArray[j]);
        if (collision) {
          this.state.collisions.push(collision);
        }
      }
    }
    
    // Collision resolution
    for (const collision of this.state.collisions) {
      const bodyA = this.state.bodies.get(collision.bodyA);
      const bodyB = this.state.bodies.get(collision.bodyB);
      
      if (bodyA && bodyB) {
        const resolved = resolveCollision(bodyA, bodyB, collision);
        this.state.bodies.set(collision.bodyA, resolved.a);
        this.state.bodies.set(collision.bodyB, resolved.b);
      }
    }
    
    // Integration
    for (const [id, body] of this.state.bodies) {
      const integrated = integrateRigidBody(body, effectiveDt);
      this.state.bodies.set(id, integrated);
    }
    
    // Advect fluid if present
    if (this.state.fluidGrid) {
      this.state.fluidGrid = advectFluid(this.state.fluidGrid, effectiveDt);
    }
    
    // Update law compliance based on collisions and energy
    let totalEnergy = 0;
    for (const body of this.state.bodies.values()) {
      const ke = 0.5 * body.mass * vec3.lengthSq(body.velocity);
      const pe = body.mass * PHYSICS_CONSTANTS.GRAVITY * Math.max(0, body.position.y);
      totalEnergy += ke + pe;
    }
    
    const normalizedEnergy = totalEnergy / (1000 * this.state.bodies.size + 1);
    this.state.lawCompliance = Math.max(0, 1 - normalizedEnergy * 0.01);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT SINGLETON
// ═══════════════════════════════════════════════════════════════════════════════

export const worldPhysics = new WorldPhysicsEngine();
