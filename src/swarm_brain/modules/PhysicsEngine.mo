// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: PhysicsEngine — Real 3D Physics Simulation Core
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    PHYSICS ENGINE — REAL 3D WORLD PHYSICS                ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This is REAL physics. Not game physics. REAL.                           ║
// ║                                                                          ║
// ║  NEWTONIAN MECHANICS:                                                    ║
// ║    F = ma (force = mass × acceleration)                                  ║
// ║    p = mv (momentum = mass × velocity)                                   ║
// ║    E = ½mv² (kinetic energy)                                             ║
// ║    U = mgh (potential energy)                                            ║
// ║                                                                          ║
// ║  GRAVITY: g = 9.81 m/s² (Earth standard)                                 ║
// ║                                                                          ║
// ║  COLLISIONS:                                                             ║
// ║    Elastic: kinetic energy conserved                                     ║
// ║    Inelastic: energy lost to deformation/heat                            ║
// ║    Coefficient of restitution: [0, 1]                                    ║
// ║                                                                          ║
// ║  RIGID BODY DYNAMICS:                                                    ║
// ║    Torque τ = r × F                                                      ║
// ║    Angular momentum L = Iω                                               ║
// ║    Moment of inertia I                                                   ║
// ║                                                                          ║
// ║  FLUID DYNAMICS (for air/water):                                         ║
// ║    Drag F_d = ½ρv²C_dA                                                   ║
// ║    Lift F_l = ½ρv²C_lA                                                   ║
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
  
  /// Gravitational acceleration (m/s²)
  public let GRAVITY : Float = 9.80665;
  
  /// Speed of light (m/s) — for relativistic calculations
  public let SPEED_OF_LIGHT : Float = 299792458.0;
  
  /// Air density at sea level (kg/m³)
  public let AIR_DENSITY_SEA_LEVEL : Float = 1.225;
  
  /// Water density (kg/m³)
  public let WATER_DENSITY : Float = 1000.0;
  
  /// Golden ratio (for Fibonacci physics)
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  
  /// Pi
  public let π : Float = 3.1415926535897932385;
  
  /// Boltzmann constant (J/K)
  public let BOLTZMANN : Float = 1.380649e-23;
  
  /// Planck constant (J·s)
  public let PLANCK : Float = 6.62607015e-34;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     3D VECTOR MATHEMATICS                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// 3D Vector type
  public type Vector3 = {
    x : Float;
    y : Float;
    z : Float;
  };
  
  /// Zero vector
  public let ZERO_VECTOR : Vector3 = { x = 0.0; y = 0.0; z = 0.0 };
  
  /// Unit vectors
  public let UNIT_X : Vector3 = { x = 1.0; y = 0.0; z = 0.0 };
  public let UNIT_Y : Vector3 = { x = 0.0; y = 1.0; z = 0.0 };
  public let UNIT_Z : Vector3 = { x = 0.0; y = 0.0; z = 1.0 };
  
  /// Gravity vector (pointing down)
  public let GRAVITY_VECTOR : Vector3 = { x = 0.0; y = -GRAVITY; z = 0.0 };
  
  /// Vector addition
  public func add(a: Vector3, b: Vector3) : Vector3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };
  
  /// Vector subtraction
  public func subtract(a: Vector3, b: Vector3) : Vector3 {
    { x = a.x - b.x; y = a.y - b.y; z = a.z - b.z }
  };
  
  /// Scalar multiplication
  public func scale(v: Vector3, s: Float) : Vector3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };
  
  /// Dot product
  public func dot(a: Vector3, b: Vector3) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };
  
  /// Cross product
  public func cross(a: Vector3, b: Vector3) : Vector3 {
    {
      x = a.y * b.z - a.z * b.y;
      y = a.z * b.x - a.x * b.z;
      z = a.x * b.y - a.y * b.x;
    }
  };
  
  /// Magnitude (length)
  public func magnitude(v: Vector3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };
  
  /// Magnitude squared (faster, no sqrt)
  public func magnitudeSquared(v: Vector3) : Float {
    v.x * v.x + v.y * v.y + v.z * v.z
  };
  
  /// Normalize (unit vector)
  public func normalize(v: Vector3) : Vector3 {
    let mag = magnitude(v);
    if (mag < 0.0001) { return ZERO_VECTOR };
    scale(v, 1.0 / mag)
  };
  
  /// Distance between two points
  public func distance(a: Vector3, b: Vector3) : Float {
    magnitude(subtract(b, a))
  };
  
  /// Linear interpolation
  public func lerp(a: Vector3, b: Vector3, t: Float) : Vector3 {
    add(scale(a, 1.0 - t), scale(b, t))
  };
  
  /// Reflect vector off surface with normal
  public func reflect(v: Vector3, normal: Vector3) : Vector3 {
    subtract(v, scale(normal, 2.0 * dot(v, normal)))
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     QUATERNION (3D Rotation)                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Quaternion = {
    w : Float;
    x : Float;
    y : Float;
    z : Float;
  };
  
  /// Identity quaternion (no rotation)
  public let IDENTITY_QUAT : Quaternion = { w = 1.0; x = 0.0; y = 0.0; z = 0.0 };
  
  /// Create quaternion from axis-angle
  public func quaternionFromAxisAngle(axis: Vector3, angle: Float) : Quaternion {
    let halfAngle = angle / 2.0;
    let s = Float.sin(halfAngle);
    let normalAxis = normalize(axis);
    {
      w = Float.cos(halfAngle);
      x = normalAxis.x * s;
      y = normalAxis.y * s;
      z = normalAxis.z * s;
    }
  };
  
  /// Quaternion multiplication
  public func quaternionMultiply(a: Quaternion, b: Quaternion) : Quaternion {
    {
      w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z;
      x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y;
      y = a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x;
      z = a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w;
    }
  };
  
  /// Rotate vector by quaternion
  public func rotateVector(v: Vector3, q: Quaternion) : Vector3 {
    // p' = q * p * q^-1
    let qv : Quaternion = { w = 0.0; x = v.x; y = v.y; z = v.z };
    let qConj : Quaternion = { w = q.w; x = -q.x; y = -q.y; z = -q.z };
    let result = quaternionMultiply(quaternionMultiply(q, qv), qConj);
    { x = result.x; y = result.y; z = result.z }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RIGID BODY PHYSICS                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type RigidBody = {
    id : Nat32;
    
    // Mass properties
    mass : Float;                 // kg
    inverseMass : Float;          // 1/mass (0 for infinite mass/static)
    momentOfInertia : Float;      // kg·m² (simplified scalar)
    
    // Linear motion
    position : Vector3;           // m
    velocity : Vector3;           // m/s
    acceleration : Vector3;       // m/s²
    
    // Angular motion
    rotation : Quaternion;
    angularVelocity : Vector3;    // rad/s
    angularAcceleration : Vector3;
    
    // Forces accumulated this frame
    forceAccumulator : Vector3;
    torqueAccumulator : Vector3;
    
    // Material properties
    restitution : Float;          // Bounciness [0, 1]
    friction : Float;             // Static friction coefficient
    dragCoefficient : Float;      // Air resistance
    
    // State
    isStatic : Bool;              // Immovable (infinite mass)
    isAwake : Bool;               // Physics active
    isTrigger : Bool;             // No collision response, just detection
  };
  
  /// Create a rigid body
  public func createRigidBody(
    id: Nat32,
    mass: Float,
    position: Vector3
  ) : RigidBody {
    let invMass = if (mass > 0.0001) { 1.0 / mass } else { 0.0 };
    
    {
      id = id;
      mass = mass;
      inverseMass = invMass;
      momentOfInertia = mass * 0.4;  // Simplified: sphere approximation
      position = position;
      velocity = ZERO_VECTOR;
      acceleration = ZERO_VECTOR;
      rotation = IDENTITY_QUAT;
      angularVelocity = ZERO_VECTOR;
      angularAcceleration = ZERO_VECTOR;
      forceAccumulator = ZERO_VECTOR;
      torqueAccumulator = ZERO_VECTOR;
      restitution = 0.3;
      friction = 0.5;
      dragCoefficient = 0.47;  // Sphere
      isStatic = mass < 0.0001;
      isAwake = true;
      isTrigger = false;
    }
  };
  
  /// Apply force to rigid body
  public func applyForce(body: RigidBody, force: Vector3) : RigidBody {
    if (body.isStatic) { return body };
    
    {
      id = body.id;
      mass = body.mass;
      inverseMass = body.inverseMass;
      momentOfInertia = body.momentOfInertia;
      position = body.position;
      velocity = body.velocity;
      acceleration = body.acceleration;
      rotation = body.rotation;
      angularVelocity = body.angularVelocity;
      angularAcceleration = body.angularAcceleration;
      forceAccumulator = add(body.forceAccumulator, force);
      torqueAccumulator = body.torqueAccumulator;
      restitution = body.restitution;
      friction = body.friction;
      dragCoefficient = body.dragCoefficient;
      isStatic = body.isStatic;
      isAwake = true;
      isTrigger = body.isTrigger;
    }
  };
  
  /// Apply force at point (creates torque)
  public func applyForceAtPoint(
    body: RigidBody,
    force: Vector3,
    point: Vector3
  ) : RigidBody {
    if (body.isStatic) { return body };
    
    // r = point - center of mass
    let r = subtract(point, body.position);
    // τ = r × F
    let torque = cross(r, force);
    
    {
      id = body.id;
      mass = body.mass;
      inverseMass = body.inverseMass;
      momentOfInertia = body.momentOfInertia;
      position = body.position;
      velocity = body.velocity;
      acceleration = body.acceleration;
      rotation = body.rotation;
      angularVelocity = body.angularVelocity;
      angularAcceleration = body.angularAcceleration;
      forceAccumulator = add(body.forceAccumulator, force);
      torqueAccumulator = add(body.torqueAccumulator, torque);
      restitution = body.restitution;
      friction = body.friction;
      dragCoefficient = body.dragCoefficient;
      isStatic = body.isStatic;
      isAwake = true;
      isTrigger = body.isTrigger;
    }
  };
  
  /// Apply impulse (instantaneous velocity change)
  public func applyImpulse(body: RigidBody, impulse: Vector3) : RigidBody {
    if (body.isStatic) { return body };
    
    // Δv = J/m
    let deltaV = scale(impulse, body.inverseMass);
    
    {
      id = body.id;
      mass = body.mass;
      inverseMass = body.inverseMass;
      momentOfInertia = body.momentOfInertia;
      position = body.position;
      velocity = add(body.velocity, deltaV);
      acceleration = body.acceleration;
      rotation = body.rotation;
      angularVelocity = body.angularVelocity;
      angularAcceleration = body.angularAcceleration;
      forceAccumulator = body.forceAccumulator;
      torqueAccumulator = body.torqueAccumulator;
      restitution = body.restitution;
      friction = body.friction;
      dragCoefficient = body.dragCoefficient;
      isStatic = body.isStatic;
      isAwake = true;
      isTrigger = body.isTrigger;
    }
  };
  
  /// Integrate physics (Euler integration for one timestep)
  public func integrate(body: RigidBody, dt: Float) : RigidBody {
    if (body.isStatic or not body.isAwake) { return body };
    
    // Linear motion: F = ma → a = F/m
    let linearAccel = add(
      scale(body.forceAccumulator, body.inverseMass),
      GRAVITY_VECTOR  // Always apply gravity
    );
    
    // Add air drag: F_d = -½ρv²C_dA * v_normalized
    let speed = magnitude(body.velocity);
    let dragForce = if (speed > 0.001) {
      let dragMag = 0.5 * AIR_DENSITY_SEA_LEVEL * speed * speed * body.dragCoefficient * 0.1;
      scale(normalize(body.velocity), -dragMag * body.inverseMass)
    } else { ZERO_VECTOR };
    
    let totalAccel = add(linearAccel, dragForce);
    
    // v = v₀ + a*dt
    let newVelocity = add(body.velocity, scale(totalAccel, dt));
    
    // x = x₀ + v*dt
    let newPosition = add(body.position, scale(newVelocity, dt));
    
    // Angular motion: τ = Iα → α = τ/I
    let angularAccel = if (body.momentOfInertia > 0.0001) {
      scale(body.torqueAccumulator, 1.0 / body.momentOfInertia)
    } else { ZERO_VECTOR };
    
    // ω = ω₀ + α*dt
    let newAngularVelocity = add(body.angularVelocity, scale(angularAccel, dt));
    
    // Update rotation quaternion
    let angSpeed = magnitude(newAngularVelocity);
    let newRotation = if (angSpeed > 0.0001) {
      let axis = normalize(newAngularVelocity);
      let deltaQuat = quaternionFromAxisAngle(axis, angSpeed * dt);
      quaternionMultiply(deltaQuat, body.rotation)
    } else { body.rotation };
    
    // Check if should sleep (very low velocity)
    let isAwake = speed > 0.01 or angSpeed > 0.01;
    
    {
      id = body.id;
      mass = body.mass;
      inverseMass = body.inverseMass;
      momentOfInertia = body.momentOfInertia;
      position = newPosition;
      velocity = newVelocity;
      acceleration = totalAccel;
      rotation = newRotation;
      angularVelocity = newAngularVelocity;
      angularAcceleration = angularAccel;
      forceAccumulator = ZERO_VECTOR;  // Clear after integration
      torqueAccumulator = ZERO_VECTOR;
      restitution = body.restitution;
      friction = body.friction;
      dragCoefficient = body.dragCoefficient;
      isStatic = body.isStatic;
      isAwake = isAwake;
      isTrigger = body.isTrigger;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COLLISION DETECTION                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Axis-Aligned Bounding Box
  public type AABB = {
    min : Vector3;
    max : Vector3;
  };
  
  /// Sphere collider
  public type SphereCollider = {
    center : Vector3;
    radius : Float;
  };
  
  /// Box collider (axis-aligned)
  public type BoxCollider = {
    center : Vector3;
    halfExtents : Vector3;  // Half-size in each dimension
  };
  
  /// Collision result
  public type CollisionResult = {
    isColliding : Bool;
    penetrationDepth : Float;
    contactNormal : Vector3;
    contactPoint : Vector3;
  };
  
  /// No collision constant
  public let NO_COLLISION : CollisionResult = {
    isColliding = false;
    penetrationDepth = 0.0;
    contactNormal = ZERO_VECTOR;
    contactPoint = ZERO_VECTOR;
  };
  
  /// AABB vs AABB collision
  public func aabbVsAabb(a: AABB, b: AABB) : Bool {
    a.min.x <= b.max.x and a.max.x >= b.min.x and
    a.min.y <= b.max.y and a.max.y >= b.min.y and
    a.min.z <= b.max.z and a.max.z >= b.min.z
  };
  
  /// Sphere vs Sphere collision
  public func sphereVsSphere(a: SphereCollider, b: SphereCollider) : CollisionResult {
    let diff = subtract(b.center, a.center);
    let distSq = magnitudeSquared(diff);
    let radiusSum = a.radius + b.radius;
    
    if (distSq > radiusSum * radiusSum) {
      return NO_COLLISION;
    };
    
    let dist = Float.sqrt(distSq);
    let normal = if (dist > 0.0001) { scale(diff, 1.0 / dist) } else { UNIT_Y };
    
    {
      isColliding = true;
      penetrationDepth = radiusSum - dist;
      contactNormal = normal;
      contactPoint = add(a.center, scale(normal, a.radius));
    }
  };
  
  /// Sphere vs Ground (y = 0 plane)
  public func sphereVsGround(sphere: SphereCollider) : CollisionResult {
    let groundY = sphere.center.y - sphere.radius;
    
    if (groundY > 0.0) {
      return NO_COLLISION;
    };
    
    {
      isColliding = true;
      penetrationDepth = -groundY;
      contactNormal = UNIT_Y;
      contactPoint = { x = sphere.center.x; y = 0.0; z = sphere.center.z };
    }
  };
  
  /// Ray cast result
  public type RaycastResult = {
    hit : Bool;
    distance : Float;
    point : Vector3;
    normal : Vector3;
  };
  
  /// Ray vs Sphere
  public func rayVsSphere(
    rayOrigin: Vector3,
    rayDirection: Vector3,
    sphere: SphereCollider
  ) : RaycastResult {
    let oc = subtract(rayOrigin, sphere.center);
    let a = dot(rayDirection, rayDirection);
    let b = 2.0 * dot(oc, rayDirection);
    let c = dot(oc, oc) - sphere.radius * sphere.radius;
    let discriminant = b * b - 4.0 * a * c;
    
    if (discriminant < 0.0) {
      return { hit = false; distance = 0.0; point = ZERO_VECTOR; normal = ZERO_VECTOR };
    };
    
    let t = (-b - Float.sqrt(discriminant)) / (2.0 * a);
    
    if (t < 0.0) {
      return { hit = false; distance = 0.0; point = ZERO_VECTOR; normal = ZERO_VECTOR };
    };
    
    let hitPoint = add(rayOrigin, scale(rayDirection, t));
    let normal = normalize(subtract(hitPoint, sphere.center));
    
    { hit = true; distance = t; point = hitPoint; normal = normal }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COLLISION RESPONSE                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Resolve collision between two rigid bodies
  public func resolveCollision(
    a: RigidBody,
    b: RigidBody,
    collision: CollisionResult
  ) : (RigidBody, RigidBody) {
    if (not collision.isColliding) { return (a, b) };
    if (a.isStatic and b.isStatic) { return (a, b) };
    
    // Relative velocity
    let relVel = subtract(b.velocity, a.velocity);
    let relVelAlongNormal = dot(relVel, collision.contactNormal);
    
    // Don't resolve if velocities are separating
    if (relVelAlongNormal > 0.0) { return (a, b) };
    
    // Coefficient of restitution (use minimum)
    let e = Float.min(a.restitution, b.restitution);
    
    // Impulse scalar
    let j = -(1.0 + e) * relVelAlongNormal / (a.inverseMass + b.inverseMass);
    
    // Apply impulse
    let impulse = scale(collision.contactNormal, j);
    
    let newA = if (not a.isStatic) {
      applyImpulse(a, scale(impulse, -1.0))
    } else { a };
    
    let newB = if (not b.isStatic) {
      applyImpulse(b, impulse)
    } else { b };
    
    // Positional correction (prevent sinking)
    let percent = 0.8;  // Correction percentage
    let slop = 0.01;    // Penetration allowance
    let correctionMag = Float.max(collision.penetrationDepth - slop, 0.0) /
                        (a.inverseMass + b.inverseMass) * percent;
    let correction = scale(collision.contactNormal, correctionMag);
    
    let correctedA = if (not a.isStatic) {
      {
        id = newA.id;
        mass = newA.mass;
        inverseMass = newA.inverseMass;
        momentOfInertia = newA.momentOfInertia;
        position = subtract(newA.position, scale(correction, a.inverseMass));
        velocity = newA.velocity;
        acceleration = newA.acceleration;
        rotation = newA.rotation;
        angularVelocity = newA.angularVelocity;
        angularAcceleration = newA.angularAcceleration;
        forceAccumulator = newA.forceAccumulator;
        torqueAccumulator = newA.torqueAccumulator;
        restitution = newA.restitution;
        friction = newA.friction;
        dragCoefficient = newA.dragCoefficient;
        isStatic = newA.isStatic;
        isAwake = newA.isAwake;
        isTrigger = newA.isTrigger;
      }
    } else { newA };
    
    let correctedB = if (not b.isStatic) {
      {
        id = newB.id;
        mass = newB.mass;
        inverseMass = newB.inverseMass;
        momentOfInertia = newB.momentOfInertia;
        position = add(newB.position, scale(correction, b.inverseMass));
        velocity = newB.velocity;
        acceleration = newB.acceleration;
        rotation = newB.rotation;
        angularVelocity = newB.angularVelocity;
        angularAcceleration = newB.angularAcceleration;
        forceAccumulator = newB.forceAccumulator;
        torqueAccumulator = newB.torqueAccumulator;
        restitution = newB.restitution;
        friction = newB.friction;
        dragCoefficient = newB.dragCoefficient;
        isStatic = newB.isStatic;
        isAwake = newB.isAwake;
        isTrigger = newB.isTrigger;
      }
    } else { newB };
    
    (correctedA, correctedB)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENERGY CALCULATIONS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Kinetic energy: KE = ½mv²
  public func kineticEnergy(body: RigidBody) : Float {
    0.5 * body.mass * magnitudeSquared(body.velocity)
  };
  
  /// Potential energy: PE = mgh
  public func potentialEnergy(body: RigidBody) : Float {
    body.mass * GRAVITY * body.position.y
  };
  
  /// Total mechanical energy
  public func totalEnergy(body: RigidBody) : Float {
    kineticEnergy(body) + potentialEnergy(body)
  };
  
  /// Momentum: p = mv
  public func momentum(body: RigidBody) : Vector3 {
    scale(body.velocity, body.mass)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PHYSICS WORLD                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type PhysicsWorld = {
    bodies : [RigidBody];
    gravity : Vector3;
    timeScale : Float;
    simulationTime : Float;
  };
  
  /// Create physics world
  public func createPhysicsWorld() : PhysicsWorld {
    {
      bodies = [];
      gravity = GRAVITY_VECTOR;
      timeScale = 1.0;
      simulationTime = 0.0;
    }
  };
  
  /// Step physics world
  public func stepWorld(world: PhysicsWorld, dt: Float) : PhysicsWorld {
    let scaledDt = dt * world.timeScale;
    
    // Integrate all bodies
    let integratedBodies = Array.map<RigidBody, RigidBody>(
      world.bodies,
      func(body) { integrate(body, scaledDt) }
    );
    
    {
      bodies = integratedBodies;
      gravity = world.gravity;
      timeScale = world.timeScale;
      simulationTime = world.simulationTime + scaledDt;
    }
  };

}
