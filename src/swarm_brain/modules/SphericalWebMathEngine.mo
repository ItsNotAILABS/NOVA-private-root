// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: SphericalWebMathEngine — The Complete Spherical Web Mathematics
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              SPHERICAL WEB MATHEMATICAL FOUNDATION                       ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  NOT LINEAR: A → B → C                                                   ║
// ║  NOT PARALLEL: A ∥ B ∥ C                                                 ║
// ║  SPHERICAL WEB: Every node ↔ Every node on curved manifold              ║
// ║                                                                          ║
// ║  This engine implements:                                                 ║
// ║    • Spherical coordinate systems (θ, φ, r)                              ║
// ║    • Great circle geodesics                                              ║
// ║    • Spherical harmonics Y_l^m                                           ║
// ║    • Web connectivity matrices                                           ║
// ║    • Curvature tensors on S²                                             ║
// ║    • Parallel transport on curved manifolds                              ║
// ║    • Holonomy groups                                                     ║
// ║    • Fiber bundles over spheres                                          ║
// ║                                                                          ║
// ║  MULTIPLE RESPONSIBILITIES:                                              ║
// ║    1. Geometric computation                                              ║
// ║    2. Topological analysis                                               ║
// ║    3. Signal propagation                                                 ║
// ║    4. Coherence measurement                                              ║
// ║    5. Phase coupling                                                     ║
// ║    6. Energy flow                                                        ║
// ║    7. Information encoding                                               ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SACRED MATHEMATICAL CONSTANTS                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let phi : Float = 1.6180339887498948482;      // Golden ratio
  public let psi : Float = 0.6180339887498948482;      // Golden conjugate (1/φ)
  public let τ : Float = 6.2831853071795864769;      // 2π
  public let pi : Float = 3.1415926535897932385;      // π
  public let e : Float = 2.7182818284590452354;      // Euler's number
  public let S₀ : Float = 0.3819660112501051518;     // 1 - φ⁻¹ (silver ratio)
  public let √2 : Float = 1.4142135623730950488;     // Square root of 2
  public let √3 : Float = 1.7320508075688772935;     // Square root of 3
  public let √5 : Float = 2.2360679774997896964;     // Square root of 5
  
  // Fibonacci sequence (first 21)
  public let FIB : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946];
  
  // Lucas sequence (first 21)
  public let LUCAS : [Nat] = [2, 1, 3, 4, 7, 11, 18, 29, 47, 76, 123, 199, 322, 521, 843, 1364, 2207, 3571, 5778, 9349, 15127];

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     3D VECTOR MATHEMATICS                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type Vec3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  public type Vec4 = {
    x : Float;
    y : Float;
    z : Float;
    w : Float;
  };

  public func vec3Zero() : Vec3 {
    { x = 0.0; y = 0.0; z = 0.0 }
  };

  public func vec3One() : Vec3 {
    { x = 1.0; y = 1.0; z = 1.0 }
  };

  public func vec3Add(a : Vec3, b : Vec3) : Vec3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };

  public func vec3Sub(a : Vec3, b : Vec3) : Vec3 {
    { x = a.x - b.x; y = a.y - b.y; z = a.z - b.z }
  };

  public func vec3Scale(v : Vec3, s : Float) : Vec3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };

  public func vec3Dot(a : Vec3, b : Vec3) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };

  public func vec3Cross(a : Vec3, b : Vec3) : Vec3 {
    {
      x = a.y * b.z - a.z * b.y;
      y = a.z * b.x - a.x * b.z;
      z = a.x * b.y - a.y * b.x;
    }
  };

  public func vec3Length(v : Vec3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };

  public func vec3LengthSq(v : Vec3) : Float {
    v.x * v.x + v.y * v.y + v.z * v.z
  };

  public func vec3Normalize(v : Vec3) : Vec3 {
    let len = vec3Length(v);
    if (len < 1e-10) {
      { x = 0.0; y = 0.0; z = 1.0 }
    } else {
      { x = v.x / len; y = v.y / len; z = v.z / len }
    }
  };

  public func vec3Lerp(a : Vec3, b : Vec3, t : Float) : Vec3 {
    {
      x = a.x + (b.x - a.x) * t;
      y = a.y + (b.y - a.y) * t;
      z = a.z + (b.z - a.z) * t;
    }
  };

  public func vec3Slerp(a : Vec3, b : Vec3, t : Float) : Vec3 {
    let dot = vec3Dot(vec3Normalize(a), vec3Normalize(b));
    let clampedDot = Float.max(-1.0, Float.min(1.0, dot));
    let theta = Float.arccos(clampedDot);
    
    if (Float.abs(theta) < 1e-6) {
      return vec3Lerp(a, b, t);
    };
    
    let sinTheta = Float.sin(theta);
    let wa = Float.sin((1.0 - t) * theta) / sinTheta;
    let wb = Float.sin(t * theta) / sinTheta;
    
    vec3Add(vec3Scale(a, wa), vec3Scale(b, wb))
  };

  public func vec3Distance(a : Vec3, b : Vec3) : Float {
    vec3Length(vec3Sub(b, a))
  };

  public func vec3Reflect(v : Vec3, n : Vec3) : Vec3 {
    let d = 2.0 * vec3Dot(v, n);
    vec3Sub(v, vec3Scale(n, d))
  };

  public func vec3Project(v : Vec3, onto : Vec3) : Vec3 {
    let d = vec3Dot(v, onto) / vec3LengthSq(onto);
    vec3Scale(onto, d)
  };

  public func vec3Reject(v : Vec3, from : Vec3) : Vec3 {
    vec3Sub(v, vec3Project(v, from))
  };

  public func vec3Angle(a : Vec3, b : Vec3) : Float {
    let dot = vec3Dot(vec3Normalize(a), vec3Normalize(b));
    Float.arccos(Float.max(-1.0, Float.min(1.0, dot)))
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     QUATERNION MATHEMATICS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type Quaternion = {
    w : Float;  // Real/scalar part
    x : Float;  // i component
    y : Float;  // j component
    z : Float;  // k component
  };

  public func quatIdentity() : Quaternion {
    { w = 1.0; x = 0.0; y = 0.0; z = 0.0 }
  };

  public func quatFromAxisAngle(axis : Vec3, angle : Float) : Quaternion {
    let halfAngle = angle * 0.5;
    let s = Float.sin(halfAngle);
    let n = vec3Normalize(axis);
    {
      w = Float.cos(halfAngle);
      x = n.x * s;
      y = n.y * s;
      z = n.z * s;
    }
  };

  public func quatMul(a : Quaternion, b : Quaternion) : Quaternion {
    {
      w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z;
      x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y;
      y = a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x;
      z = a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w;
    }
  };

  public func quatConjugate(q : Quaternion) : Quaternion {
    { w = q.w; x = -q.x; y = -q.y; z = -q.z }
  };

  public func quatNorm(q : Quaternion) : Float {
    Float.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z)
  };

  public func quatNormalize(q : Quaternion) : Quaternion {
    let n = quatNorm(q);
    if (n < 1e-10) {
      quatIdentity()
    } else {
      { w = q.w / n; x = q.x / n; y = q.y / n; z = q.z / n }
    }
  };

  public func quatInverse(q : Quaternion) : Quaternion {
    let n2 = q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z;
    if (n2 < 1e-10) {
      quatIdentity()
    } else {
      { w = q.w / n2; x = -q.x / n2; y = -q.y / n2; z = -q.z / n2 }
    }
  };

  public func quatRotateVec3(q : Quaternion, v : Vec3) : Vec3 {
    let qv : Quaternion = { w = 0.0; x = v.x; y = v.y; z = v.z };
    let result = quatMul(quatMul(q, qv), quatConjugate(q));
    { x = result.x; y = result.y; z = result.z }
  };

  public func quatSlerp(a : Quaternion, b : Quaternion, t : Float) : Quaternion {
    var dot = a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z;
    
    var b2 = b;
    if (dot < 0.0) {
      b2 := { w = -b.w; x = -b.x; y = -b.y; z = -b.z };
      dot := -dot;
    };
    
    if (dot > 0.9995) {
      return quatNormalize({
        w = a.w + (b2.w - a.w) * t;
        x = a.x + (b2.x - a.x) * t;
        y = a.y + (b2.y - a.y) * t;
        z = a.z + (b2.z - a.z) * t;
      });
    };
    
    let theta = Float.arccos(dot);
    let sinTheta = Float.sin(theta);
    let wa = Float.sin((1.0 - t) * theta) / sinTheta;
    let wb = Float.sin(t * theta) / sinTheta;
    
    {
      w = a.w * wa + b2.w * wb;
      x = a.x * wa + b2.x * wb;
      y = a.y * wa + b2.y * wb;
      z = a.z * wa + b2.z * wb;
    }
  };

  public func quatToAxisAngle(q : Quaternion) : (Vec3, Float) {
    let qn = quatNormalize(q);
    let angle = 2.0 * Float.arccos(qn.w);
    let s = Float.sqrt(1.0 - qn.w * qn.w);
    
    if (s < 1e-6) {
      ({ x = 1.0; y = 0.0; z = 0.0 }, angle)
    } else {
      ({ x = qn.x / s; y = qn.y / s; z = qn.z / s }, angle)
    }
  };

  public func quatFromEuler(roll : Float, pitch : Float, yaw : Float) : Quaternion {
    let cr = Float.cos(roll * 0.5);
    let sr = Float.sin(roll * 0.5);
    let cp = Float.cos(pitch * 0.5);
    let sp = Float.sin(pitch * 0.5);
    let cy = Float.cos(yaw * 0.5);
    let sy = Float.sin(yaw * 0.5);
    
    {
      w = cr * cp * cy + sr * sp * sy;
      x = sr * cp * cy - cr * sp * sy;
      y = cr * sp * cy + sr * cp * sy;
      z = cr * cp * sy - sr * sp * cy;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPHERICAL COORDINATE SYSTEM                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type SphericalCoord = {
    r : Float;      // Radius (distance from origin)
    θ : Float;      // Theta (polar angle from z-axis, 0 to π)
    phi : Float;      // Phi (azimuthal angle in xy-plane, 0 to 2π)
  };

  public func cartesianToSpherical(v : Vec3) : SphericalCoord {
    let r = vec3Length(v);
    if (r < 1e-10) {
      return { r = 0.0; θ = 0.0; phi = 0.0 };
    };
    
    let theta = Float.arccos(v.z / r);
    let phi = Float.arctan2(v.y, v.x);
    
    { r = r; θ = theta; phi = if (phi < 0.0) { phi + τ } else { phi } }
  };

  public func sphericalToCartesian(s : SphericalCoord) : Vec3 {
    let sinTheta = Float.sin(s.θ);
    {
      x = s.r * sinTheta * Float.cos(s.phi);
      y = s.r * sinTheta * Float.sin(s.phi);
      z = s.r * Float.cos(s.θ);
    }
  };

  public func sphericalDistance(a : SphericalCoord, b : SphericalCoord) : Float {
    // Haversine formula for great circle distance
    let dTheta = b.θ - a.θ;
    let dPhi = b.phi - a.phi;
    
    let sinDTheta2 = Float.sin(dTheta / 2.0);
    let sinDPhi2 = Float.sin(dPhi / 2.0);
    
    let h = sinDTheta2 * sinDTheta2 + 
            Float.sin(a.θ) * Float.sin(b.θ) * sinDPhi2 * sinDPhi2;
    
    let r = (a.r + b.r) / 2.0;  // Average radius
    2.0 * r * Float.arcsin(Float.sqrt(h))
  };

  public func greatCircleArc(start : SphericalCoord, finish : SphericalCoord, t : Float) : SphericalCoord {
    let v1 = sphericalToCartesian(start);
    let v2 = sphericalToCartesian(finish);
    let v = vec3Slerp(v1, v2, t);
    cartesianToSpherical(v)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPHERICAL HARMONICS Y_l^m                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Associated Legendre polynomials P_l^m(x)
  public func legendreP(l : Nat, m : Int, x : Float) : Float {
    let absM = Int.abs(m);
    
    if (absM > l) { return 0.0 };
    
    // P_m^m(x) = (-1)^m * (2m-1)!! * (1-x²)^(m/2)
    var pmm : Float = 1.0;
    if (absM > 0) {
      let somx2 = Float.sqrt((1.0 - x) * (1.0 + x));
      var fact : Float = 1.0;
      for (i in Iter.range(1, absM)) {
        pmm *= -fact * somx2;
        fact += 2.0;
      };
    };
    
    if (l == absM) { return pmm };
    
    // P_{m+1}^m(x) = x * (2m+1) * P_m^m(x)
    var pmmp1 = x * Float.fromInt(2 * absM + 1) * pmm;
    if (l == absM + 1) { return pmmp1 };
    
    // Recurrence: (l-m) * P_l^m = x * (2l-1) * P_{l-1}^m - (l+m-1) * P_{l-2}^m
    var pll : Float = 0.0;
    for (ll in Iter.range(absM + 2, l)) {
      pll := (x * Float.fromInt(2 * ll - 1) * pmmp1 - Float.fromInt(ll + absM - 1) * pmm) / Float.fromInt(ll - absM);
      pmm := pmmp1;
      pmmp1 := pll;
    };
    
    pll
  };

  // Factorial helper
  public func factorial(n : Nat) : Float {
    var result : Float = 1.0;
    for (i in Iter.range(2, n)) {
      result *= Float.fromInt(i);
    };
    result
  };

  // Double factorial (n!!)
  public func doubleFactorial(n : Nat) : Float {
    if (n <= 1) { return 1.0 };
    var result : Float = 1.0;
    var k = n;
    while (k > 1) {
      result *= Float.fromInt(k);
      k -= 2;
    };
    result
  };

  // Real spherical harmonic Y_l^m(θ, φ)
  public func sphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let absM = Int.abs(m);
    
    // Normalization factor
    let norm = Float.sqrt(
      Float.fromInt(2 * l + 1) / (4.0 * π) *
      factorial(l - absM) / factorial(l + absM)
    );
    
    let plm = legendreP(l, m, Float.cos(theta));
    
    if (m > 0) {
      norm * √2 * Float.cos(Float.fromInt(m) * phi) * plm
    } else if (m < 0) {
      norm * √2 * Float.sin(Float.fromInt(-m) * phi) * plm
    } else {
      norm * plm
    }
  };

  // Complex spherical harmonic components
  public type ComplexNum = {
    re : Float;
    im : Float;
  };

  public func complexSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : ComplexNum {
    let absM = Int.abs(m);
    
    let norm = Float.sqrt(
      Float.fromInt(2 * l + 1) / (4.0 * π) *
      factorial(l - absM) / factorial(l + absM)
    );
    
    let plm = legendreP(l, m, Float.cos(theta));
    let mPhi = Float.fromInt(m) * phi;
    
    {
      re = norm * plm * Float.cos(mPhi);
      im = norm * plm * Float.sin(mPhi);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPHERICAL WEB NODE                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type SphericalWebNode = {
    id : Nat32;
    position : SphericalCoord;
    cartesian : Vec3;
    
    // Multiple responsibilities
    responsibilities : [Responsibility];
    
    // Connections to ALL other nodes (spherical web)
    connections : [WebConnection];
    
    // State
    activation : Float;
    phase : Float;
    coherence : Float;
    energy : Float;
    
    // Harmonic coefficients (up to l=4)
    harmonicCoeffs : [Float];  // 25 coefficients for l=0..4
    
    // Local curvature
    gaussianCurvature : Float;
    meanCurvature : Float;
  };

  public type Responsibility = {
    #Computation;
    #Topology;
    #SignalPropagation;
    #CoherenceMeasurement;
    #PhaseCoupling;
    #EnergyFlow;
    #InformationEncoding;
    #PatternRecognition;
    #MemoryStorage;
    #Prediction;
    #Defense;
    #Creation;
  };

  public type WebConnection = {
    targetId : Nat32;
    geodesicDistance : Float;
    signalStrength : Float;
    phaseOffset : Float;
    bandwidth : Float;
    bidirectional : Bool;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPHERICAL WEB FABRIC                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type SphericalWebFabric = {
    nodes : [SphericalWebNode];
    nodeCount : Nat;
    radius : Float;
    
    // Global state
    globalCoherence : Float;
    globalPhase : Float;
    totalEnergy : Float;
    
    // Topology
    eulerCharacteristic : Int;  // χ = V - E + F = 2 for sphere
    genus : Nat;                 // 0 for sphere
    
    // Harmonic decomposition of entire fabric
    fabricHarmonics : [[Float]];  // [l][m] coefficients
    
    // Connection matrix (adjacency weighted by geodesic distance)
    connectionMatrix : [[Float]];
    
    // Laplacian on the sphere
    laplacianMatrix : [[Float]];
  };

  // Create a spherical web with N nodes distributed via Fibonacci spiral
  public func createSphericalWeb(n : Nat, radius : Float) : SphericalWebFabric {
    let nodes = Buffer.Buffer<SphericalWebNode>(n);
    
    // Golden angle for Fibonacci spiral
    let goldenAngle = π * (3.0 - √5);
    
    for (i in Iter.range(0, n - 1)) {
      let theta = Float.arccos(1.0 - 2.0 * (Float.fromInt(i) + 0.5) / Float.fromInt(n));
      let phi = goldenAngle * Float.fromInt(i);
      
      let sphericalPos : SphericalCoord = { r = radius; θ = theta; phi = phi };
      let cartPos = sphericalToCartesian(sphericalPos);
      
      // Assign multiple responsibilities based on position
      let resps = assignResponsibilities(theta, phi);
      
      // Compute harmonic coefficients
      let harmonics = computeNodeHarmonics(theta, phi);
      
      nodes.add({
        id = Nat32.fromNat(i);
        position = sphericalPos;
        cartesian = cartPos;
        responsibilities = resps;
        connections = [];  // Will be filled after all nodes created
        activation = 0.5;
        phase = phi;
        coherence = 1.0;
        energy = 1.0;
        harmonicCoeffs = harmonics;
        gaussianCurvature = 1.0 / (radius * radius);  // Constant for sphere
        meanCurvature = 1.0 / radius;
      });
    };
    
    // Build connection matrix and connections
    let nodesArray = Buffer.toArray(nodes);
    let connMatrix = buildConnectionMatrix(nodesArray, radius);
    let laplacian = buildSphericalLaplacian(nodesArray, connMatrix, radius);
    
    // Update nodes with connections
    let updatedNodes = Buffer.Buffer<SphericalWebNode>(n);
    for (i in Iter.range(0, n - 1)) {
      let node = nodesArray[i];
      let conns = buildNodeConnections(i, nodesArray, connMatrix);
      updatedNodes.add({
        id = node.id;
        position = node.position;
        cartesian = node.cartesian;
        responsibilities = node.responsibilities;
        connections = conns;
        activation = node.activation;
        phase = node.phase;
        coherence = node.coherence;
        energy = node.energy;
        harmonicCoeffs = node.harmonicCoeffs;
        gaussianCurvature = node.gaussianCurvature;
        meanCurvature = node.meanCurvature;
      });
    };
    
    {
      nodes = Buffer.toArray(updatedNodes);
      nodeCount = n;
      radius = radius;
      globalCoherence = 1.0;
      globalPhase = 0.0;
      totalEnergy = Float.fromInt(n);
      eulerCharacteristic = 2;
      genus = 0;
      fabricHarmonics = computeFabricHarmonics(Buffer.toArray(updatedNodes));
      connectionMatrix = connMatrix;
      laplacianMatrix = laplacian;
    }
  };

  // Assign responsibilities based on spherical position
  func assignResponsibilities(theta : Float, phi : Float) : [Responsibility] {
    let resps = Buffer.Buffer<Responsibility>(4);
    
    // North pole region: Computation + Topology
    if (theta < π / 6.0) {
      resps.add(#Computation);
      resps.add(#Topology);
      resps.add(#Prediction);
    }
    // South pole region: Memory + Defense
    else if (theta > 5.0 * π / 6.0) {
      resps.add(#MemoryStorage);
      resps.add(#Defense);
      resps.add(#PatternRecognition);
    }
    // Equatorial band: All signal processing
    else if (theta > π / 3.0 and theta < 2.0 * π / 3.0) {
      resps.add(#SignalPropagation);
      resps.add(#PhaseCoupling);
      resps.add(#EnergyFlow);
      resps.add(#InformationEncoding);
    }
    // Middle latitudes: Mixed responsibilities
    else {
      resps.add(#CoherenceMeasurement);
      resps.add(#PatternRecognition);
      resps.add(#Creation);
    };
    
    // Phi-based additional responsibilities (golden sections)
    let phiNorm = phi / τ;
    if (phiNorm < ψ) {
      resps.add(#EnergyFlow);
    };
    if (phiNorm > psi and phiNorm < phi - 1.0) {
      resps.add(#InformationEncoding);
    };
    
    Buffer.toArray(resps)
  };

  // Compute harmonic coefficients for a node
  func computeNodeHarmonics(theta : Float, phi : Float) : [Float] {
    let coeffs = Buffer.Buffer<Float>(25);
    
    // For l = 0 to 4, m = -l to l
    for (l in Iter.range(0, 4)) {
      for (m in Iter.range(-l, l)) {
        let ylm = sphericalHarmonic(l, m, theta, phi);
        coeffs.add(ylm);
      };
    };
    
    Buffer.toArray(coeffs)
  };

  // Build connection matrix (all-to-all with geodesic distance weighting)
  func buildConnectionMatrix(nodes : [SphericalWebNode], radius : Float) : [[Float]] {
    let n = nodes.size();
    let matrix = Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { return 0.0 };
        
        let dist = sphericalDistance(nodes[i].position, nodes[j].position);
        
        // Weight by inverse geodesic distance (stronger connection when closer)
        // But ALL nodes are connected (spherical web)
        let maxDist = π * radius;  // Half circumference
        1.0 - (dist / maxDist)
      })
    });
    
    matrix
  };

  // Build Laplace-Beltrami operator approximation
  func buildSphericalLaplacian(nodes : [SphericalWebNode], connMatrix : [[Float]], radius : Float) : [[Float]] {
    let n = nodes.size();
    
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) {
          // Diagonal: negative sum of row
          var sum : Float = 0.0;
          for (k in Iter.range(0, n - 1)) {
            if (k != i) { sum += connMatrix[i][k] };
          };
          -sum / (radius * radius)
        } else {
          // Off-diagonal: connection weight
          connMatrix[i][j] / (radius * radius)
        }
      })
    })
  };

  // Build connections for a specific node
  func buildNodeConnections(nodeIdx : Nat, nodes : [SphericalWebNode], connMatrix : [[Float]]) : [WebConnection] {
    let n = nodes.size();
    let conns = Buffer.Buffer<WebConnection>(n - 1);
    
    for (j in Iter.range(0, n - 1)) {
      if (j != nodeIdx) {
        let weight = connMatrix[nodeIdx][j];
        let dist = sphericalDistance(nodes[nodeIdx].position, nodes[j].position);
        
        conns.add({
          targetId = Nat32.fromNat(j);
          geodesicDistance = dist;
          signalStrength = weight;
          phaseOffset = nodes[j].phase - nodes[nodeIdx].phase;
          bandwidth = weight * φ;  // Golden-scaled bandwidth
          bidirectional = true;
        });
      };
    };
    
    Buffer.toArray(conns)
  };

  // Compute fabric-level harmonic decomposition
  func computeFabricHarmonics(nodes : [SphericalWebNode]) : [[Float]] {
    // For l = 0 to 6
    Array.tabulate<[Float]>(7, func(l : Nat) : [Float] {
      // For m = -l to l
      Array.tabulate<Float>(2 * l + 1, func(mIdx : Nat) : Float {
        let m = Int.sub(mIdx, l);
        
        // Integrate over all nodes
        var sum : Float = 0.0;
        for (node in nodes.vals()) {
          let ylm = sphericalHarmonic(l, m, node.position.θ, node.position.phi);
          sum += node.activation * ylm;
        };
        
        sum / Float.fromInt(nodes.size())
      })
    })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPHERICAL WEB DYNAMICS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Propagate signal across the spherical web
  public func propagateSignal(fabric : SphericalWebFabric, sourceIdx : Nat, signal : Float) : SphericalWebFabric {
    let n = fabric.nodeCount;
    var nodes = fabric.nodes;
    
    // Signal propagates to ALL nodes (spherical web - not linear)
    let newNodes = Array.tabulate<SphericalWebNode>(n, func(i : Nat) : SphericalWebNode {
      let node = nodes[i];
      
      if (i == sourceIdx) {
        // Source node receives full signal
        {
          id = node.id;
          position = node.position;
          cartesian = node.cartesian;
          responsibilities = node.responsibilities;
          connections = node.connections;
          activation = Float.min(1.0, node.activation + signal);
          phase = node.phase;
          coherence = node.coherence;
          energy = node.energy + signal * signal;
          harmonicCoeffs = node.harmonicCoeffs;
          gaussianCurvature = node.gaussianCurvature;
          meanCurvature = node.meanCurvature;
        }
      } else {
        // Other nodes receive attenuated signal based on geodesic distance
        let weight = fabric.connectionMatrix[sourceIdx][i];
        let attenuatedSignal = signal * weight * ψ;  // Golden attenuation
        
        {
          id = node.id;
          position = node.position;
          cartesian = node.cartesian;
          responsibilities = node.responsibilities;
          connections = node.connections;
          activation = Float.min(1.0, node.activation + attenuatedSignal);
          phase = node.phase + attenuatedSignal * 0.1;  // Phase shift from signal
          coherence = node.coherence;
          energy = node.energy + attenuatedSignal * attenuatedSignal;
          harmonicCoeffs = node.harmonicCoeffs;
          gaussianCurvature = node.gaussianCurvature;
          meanCurvature = node.meanCurvature;
        }
      }
    });
    
    {
      nodes = newNodes;
      nodeCount = fabric.nodeCount;
      radius = fabric.radius;
      globalCoherence = computeGlobalCoherence(newNodes);
      globalPhase = computeGlobalPhase(newNodes);
      totalEnergy = computeTotalEnergy(newNodes);
      eulerCharacteristic = fabric.eulerCharacteristic;
      genus = fabric.genus;
      fabricHarmonics = computeFabricHarmonics(newNodes);
      connectionMatrix = fabric.connectionMatrix;
      laplacianMatrix = fabric.laplacianMatrix;
    }
  };

  // Kuramoto phase coupling on spherical web
  public func kuramotoCoupling(fabric : SphericalWebFabric, K : Float, dt : Float) : SphericalWebFabric {
    let n = fabric.nodeCount;
    let nodes = fabric.nodes;
    
    // Compute order parameter
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (node in nodes.vals()) {
      sumCos += Float.cos(node.phase);
      sumSin += Float.sin(node.phase);
    };
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    let psi = Float.arctan2(sumSin, sumCos);
    
    // Update phases
    let newNodes = Array.tabulate<SphericalWebNode>(n, func(i : Nat) : SphericalWebNode {
      let node = nodes[i];
      
      // Natural frequency (based on position)
      let omega = phi * Float.sin(node.position.θ);
      
      // Coupling term (mean-field approximation on sphere)
      let coupling = K * r * Float.sin(psi - node.phase);
      
      // Additional coupling from geodesic neighbors (spherical web effect)
      var neighborCoupling : Float = 0.0;
      for (conn in node.connections.vals()) {
        let j = Nat32.toNat(conn.targetId);
        let otherPhase = nodes[j].phase;
        neighborCoupling += conn.signalStrength * Float.sin(otherPhase - node.phase);
      };
      neighborCoupling /= Float.fromInt(n - 1);
      
      let dPhase = omega + coupling + K * psi * neighborCoupling;
      let newPhase = node.phase + dPhase * dt;
      
      {
        id = node.id;
        position = node.position;
        cartesian = node.cartesian;
        responsibilities = node.responsibilities;
        connections = node.connections;
        activation = node.activation;
        phase = newPhase;
        coherence = r;  // Local coherence tracks global
        energy = node.energy;
        harmonicCoeffs = node.harmonicCoeffs;
        gaussianCurvature = node.gaussianCurvature;
        meanCurvature = node.meanCurvature;
      }
    });
    
    {
      nodes = newNodes;
      nodeCount = fabric.nodeCount;
      radius = fabric.radius;
      globalCoherence = r;
      globalPhase = psi;
      totalEnergy = fabric.totalEnergy;
      eulerCharacteristic = fabric.eulerCharacteristic;
      genus = fabric.genus;
      fabricHarmonics = computeFabricHarmonics(newNodes);
      connectionMatrix = fabric.connectionMatrix;
      laplacianMatrix = fabric.laplacianMatrix;
    }
  };

  // Diffusion on the sphere using Laplace-Beltrami operator
  public func sphericalDiffusion(fabric : SphericalWebFabric, diffusionCoeff : Float, dt : Float) : SphericalWebFabric {
    let n = fabric.nodeCount;
    let nodes = fabric.nodes;
    
    // Apply discrete Laplacian
    let newActivations = Array.tabulate<Float>(n, func(i : Nat) : Float {
      var laplacian : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        laplacian += fabric.laplacianMatrix[i][j] * nodes[j].activation;
      };
      
      // Diffusion equation: ∂u/∂t = D * Δu
      nodes[i].activation + diffusionCoeff * laplacian * dt
    });
    
    let newNodes = Array.tabulate<SphericalWebNode>(n, func(i : Nat) : SphericalWebNode {
      let node = nodes[i];
      {
        id = node.id;
        position = node.position;
        cartesian = node.cartesian;
        responsibilities = node.responsibilities;
        connections = node.connections;
        activation = Float.max(0.0, Float.min(1.0, newActivations[i]));
        phase = node.phase;
        coherence = node.coherence;
        energy = node.energy;
        harmonicCoeffs = node.harmonicCoeffs;
        gaussianCurvature = node.gaussianCurvature;
        meanCurvature = node.meanCurvature;
      }
    });
    
    {
      nodes = newNodes;
      nodeCount = fabric.nodeCount;
      radius = fabric.radius;
      globalCoherence = computeGlobalCoherence(newNodes);
      globalPhase = fabric.globalPhase;
      totalEnergy = computeTotalEnergy(newNodes);
      eulerCharacteristic = fabric.eulerCharacteristic;
      genus = fabric.genus;
      fabricHarmonics = computeFabricHarmonics(newNodes);
      connectionMatrix = fabric.connectionMatrix;
      laplacianMatrix = fabric.laplacianMatrix;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PARALLEL TRANSPORT ON SPHERE                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Parallel transport a vector along a great circle
  public func parallelTransport(
    startPoint : SphericalCoord,
    endPoint : SphericalCoord,
    vector : Vec3,
    radius : Float
  ) : Vec3 {
    let p1 = sphericalToCartesian(startPoint);
    let p2 = sphericalToCartesian(endPoint);
    
    // Normalize to unit sphere
    let n1 = vec3Normalize(p1);
    let n2 = vec3Normalize(p2);
    
    // Rotation axis (normal to great circle)
    let axis = vec3Normalize(vec3Cross(n1, n2));
    
    // Rotation angle (geodesic distance)
    let angle = vec3Angle(n1, n2);
    
    // Create rotation quaternion
    let q = quatFromAxisAngle(axis, angle);
    
    // Rotate the vector
    quatRotateVec3(q, vector)
  };

  // Compute holonomy (rotation after parallel transport around a loop)
  public func computeHolonomy(loop : [SphericalCoord], radius : Float) : Float {
    // For a spherical triangle, holonomy = area / R²
    // This is the spherical excess formula
    
    if (loop.size() < 3) { return 0.0 };
    
    // Compute spherical polygon area using Girard's theorem
    var totalAngle : Float = 0.0;
    let n = loop.size();
    
    for (i in Iter.range(0, n - 1)) {
      let prev = loop[(i + n - 1) % n];
      let curr = loop[i];
      let next = loop[(i + 1) % n];
      
      let v1 = sphericalToCartesian(prev);
      let v2 = sphericalToCartesian(curr);
      let v3 = sphericalToCartesian(next);
      
      // Compute angle at vertex
      let e1 = vec3Normalize(vec3Sub(v1, v2));
      let e2 = vec3Normalize(vec3Sub(v3, v2));
      let angle = vec3Angle(e1, e2);
      
      totalAngle += angle;
    };
    
    // Spherical excess (holonomy angle)
    totalAngle - Float.fromInt(n - 2) * π
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     GEODESIC CALCULATIONS                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Generate points along a geodesic (great circle)
  public func geodesicPath(start : SphericalCoord, finish : SphericalCoord, numPoints : Nat) : [SphericalCoord] {
    Array.tabulate<SphericalCoord>(numPoints, func(i : Nat) : SphericalCoord {
      let t = Float.fromInt(i) / Float.fromInt(numPoints - 1);
      greatCircleArc(start, finish, t)
    })
  };

  // Compute geodesic curvature (zero for great circles on sphere)
  public func geodesicCurvature(path : [SphericalCoord], radius : Float) : [Float] {
    if (path.size() < 3) { return [] };
    
    Array.tabulate<Float>(path.size() - 2, func(i : Nat) : Float {
      let p0 = sphericalToCartesian(path[i]);
      let p1 = sphericalToCartesian(path[i + 1]);
      let p2 = sphericalToCartesian(path[i + 2]);
      
      // Tangent vectors
      let t1 = vec3Normalize(vec3Sub(p1, p0));
      let t2 = vec3Normalize(vec3Sub(p2, p1));
      
      // Normal to sphere at p1
      let n = vec3Normalize(p1);
      
      // Geodesic curvature = (dt/ds) · (n × t)
      let dt = vec3Sub(t2, t1);
      let nxt = vec3Cross(n, t1);
      
      vec3Dot(dt, nxt)
    })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  func computeGlobalCoherence(nodes : [SphericalWebNode]) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (node in nodes.vals()) {
      sumCos += Float.cos(node.phase);
      sumSin += Float.sin(node.phase);
    };
    
    let n = Float.fromInt(nodes.size());
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / n
  };

  func computeGlobalPhase(nodes : [SphericalWebNode]) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (node in nodes.vals()) {
      sumCos += Float.cos(node.phase);
      sumSin += Float.sin(node.phase);
    };
    
    Float.arctan2(sumSin, sumCos)
  };

  func computeTotalEnergy(nodes : [SphericalWebNode]) : Float {
    var sum : Float = 0.0;
    for (node in nodes.vals()) {
      sum += node.energy;
    };
    sum
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FIBER BUNDLE STRUCTURE                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type FiberBundle = {
    baseSpace : SphericalWebFabric;  // S² (the sphere)
    fiber : FiberType;                // F (the fiber over each point)
    totalSpace : [[Float]];           // E (base × fiber)
    connection : [[Float]];           // A (connection 1-form)
  };

  public type FiberType = {
    #Circle;       // S¹ - phase
    #Sphere;       // S² - direction
    #Complex;      // C - amplitude + phase
    #Quaternion;   // H - full rotation
  };

  // Create a principal U(1) bundle over the sphere (phase bundle)
  public func createU1Bundle(fabric : SphericalWebFabric) : FiberBundle {
    let n = fabric.nodeCount;
    
    // Total space: phase at each point
    let totalSpace = Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      [fabric.nodes[i].phase]
    });
    
    // Connection: describes how fiber twists
    let connection = Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      // A = cos(θ) dφ for magnetic monopole connection
      [Float.cos(fabric.nodes[i].position.θ)]
    });
    
    {
      baseSpace = fabric;
      fiber = #Circle;
      totalSpace = totalSpace;
      connection = connection;
    }
  };

  // Compute first Chern number (topological invariant)
  public func chernNumber(bundle : FiberBundle) : Float {
    // For S² with monopole connection, c₁ = 1
    // Integrate curvature over base
    
    let n = bundle.baseSpace.nodeCount;
    var integral : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let node = bundle.baseSpace.nodes[i];
      
      // Curvature F = dA
      // For monopole: F = sin(θ) dθ ∧ dφ
      let curvature = Float.sin(node.position.θ);
      
      // Area element: dΩ = sin(θ) dθ dφ
      let areaElement = Float.sin(node.position.θ) * (τ / Float.fromInt(n)) * (π / Float.fromInt(n));
      
      integral += curvature * areaElement;
    };
    
    integral / τ  // Normalize by 2π
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WEB TOPOLOGY ANALYSIS                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type TopologyMetrics = {
    betti0 : Nat;           // Connected components
    betti1 : Nat;           // 1-dimensional holes (cycles)
    betti2 : Nat;           // 2-dimensional holes (voids)
    eulerChar : Int;        // χ = β₀ - β₁ + β₂
    clustering : Float;     // Clustering coefficient
    avgPathLength : Float;  // Average geodesic path length
    diameter : Float;       // Maximum geodesic distance
    spectralGap : Float;    // Gap in Laplacian eigenvalues
  };

  public func analyzeTopology(fabric : SphericalWebFabric) : TopologyMetrics {
    let n = fabric.nodeCount;
    
    // Betti numbers for sphere: β₀=1, β₁=0, β₂=1
    let betti0 : Nat = 1;  // One connected component
    let betti1 : Nat = 0;  // No handles
    let betti2 : Nat = 1;  // One void (inside sphere)
    
    // Clustering coefficient
    var totalClustering : Float = 0.0;
    for (node in fabric.nodes.vals()) {
      var triangles : Float = 0.0;
      var triplets : Float = 0.0;
      
      for (conn1 in node.connections.vals()) {
        for (conn2 in node.connections.vals()) {
          if (conn1.targetId != conn2.targetId) {
            triplets += 1.0;
            
            // Check if conn1 and conn2 targets are connected
            let t1 = Nat32.toNat(conn1.targetId);
            let t2 = Nat32.toNat(conn2.targetId);
            if (fabric.connectionMatrix[t1][t2] > 0.5) {
              triangles += 1.0;
            };
          };
        };
      };
      
      if (triplets > 0.0) {
        totalClustering += triangles / triplets;
      };
    };
    let clustering = totalClustering / Float.fromInt(n);
    
    // Average path length (using geodesic distances)
    var totalPath : Float = 0.0;
    var maxPath : Float = 0.0;
    var pathCount : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        let dist = sphericalDistance(fabric.nodes[i].position, fabric.nodes[j].position);
        totalPath += dist;
        if (dist > maxPath) { maxPath := dist };
        pathCount += 1.0;
      };
    };
    
    let avgPathLength = if (pathCount > 0.0) { totalPath / pathCount } else { 0.0 };
    
    // Spectral gap (approximate)
    // For well-connected spherical web, gap is related to curvature
    let spectralGap = 2.0 / (fabric.radius * fabric.radius);
    
    {
      betti0 = betti0;
      betti1 = betti1;
      betti2 = betti2;
      eulerChar = betti0 - betti1 + betti2;
      clustering = clustering;
      avgPathLength = avgPathLength;
      diameter = maxPath;
      spectralGap = spectralGap;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MULTI-RESPONSIBILITY DISPATCH                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Execute all responsibilities of a node
  public func executeNodeResponsibilities(
    fabric : SphericalWebFabric,
    nodeIdx : Nat,
    input : Float
  ) : (SphericalWebFabric, [Float]) {
    let node = fabric.nodes[nodeIdx];
    let outputs = Buffer.Buffer<Float>(node.responsibilities.size());
    
    var currentFabric = fabric;
    
    for (resp in node.responsibilities.vals()) {
      let (newFabric, output) = executeResponsibility(currentFabric, nodeIdx, resp, input);
      currentFabric := newFabric;
      outputs.add(output);
    };
    
    (currentFabric, Buffer.toArray(outputs))
  };

  // Execute a single responsibility
  func executeResponsibility(
    fabric : SphericalWebFabric,
    nodeIdx : Nat,
    resp : Responsibility,
    input : Float
  ) : (SphericalWebFabric, Float) {
    switch (resp) {
      case (#Computation) {
        // Compute activation function
        let node = fabric.nodes[nodeIdx];
        let output = Float.tanh(input * node.coherence);
        (fabric, output)
      };
      case (#Topology) {
        // Compute local curvature contribution
        let node = fabric.nodes[nodeIdx];
        (fabric, node.gaussianCurvature * input)
      };
      case (#SignalPropagation) {
        // Propagate signal through web
        let newFabric = propagateSignal(fabric, nodeIdx, input * ψ);
        (newFabric, input * ψ)
      };
      case (#CoherenceMeasurement) {
        // Measure and return local coherence
        (fabric, fabric.nodes[nodeIdx].coherence)
      };
      case (#PhaseCoupling) {
        // Apply Kuramoto coupling step
        let newFabric = kuramotoCoupling(fabric, input, 0.01);
        (newFabric, newFabric.globalCoherence)
      };
      case (#EnergyFlow) {
        // Diffuse energy
        let newFabric = sphericalDiffusion(fabric, input * 0.1, 0.01);
        (newFabric, newFabric.totalEnergy)
      };
      case (#InformationEncoding) {
        // Encode in harmonics
        let node = fabric.nodes[nodeIdx];
        var encoded : Float = 0.0;
        for (coeff in node.harmonicCoeffs.vals()) {
          encoded += coeff * input;
        };
        (fabric, encoded / Float.fromInt(node.harmonicCoeffs.size()))
      };
      case (#PatternRecognition) {
        // Match against harmonic patterns
        let node = fabric.nodes[nodeIdx];
        var match : Float = 0.0;
        for (i in Iter.range(0, node.harmonicCoeffs.size() - 1)) {
          match += Float.abs(node.harmonicCoeffs[i] - input);
        };
        (fabric, 1.0 / (1.0 + match))
      };
      case (#MemoryStorage) {
        // Store in activation (simplified)
        let nodes = fabric.nodes;
        let newNodes = Array.tabulate<SphericalWebNode>(fabric.nodeCount, func(i : Nat) : SphericalWebNode {
          if (i == nodeIdx) {
            let node = nodes[i];
            {
              id = node.id;
              position = node.position;
              cartesian = node.cartesian;
              responsibilities = node.responsibilities;
              connections = node.connections;
              activation = input * psi + node.activation * φ;  // Golden blend
              phase = node.phase;
              coherence = node.coherence;
              energy = node.energy;
              harmonicCoeffs = node.harmonicCoeffs;
              gaussianCurvature = node.gaussianCurvature;
              meanCurvature = node.meanCurvature;
            }
          } else {
            nodes[i]
          }
        });
        
        ({
          nodes = newNodes;
          nodeCount = fabric.nodeCount;
          radius = fabric.radius;
          globalCoherence = fabric.globalCoherence;
          globalPhase = fabric.globalPhase;
          totalEnergy = fabric.totalEnergy;
          eulerCharacteristic = fabric.eulerCharacteristic;
          genus = fabric.genus;
          fabricHarmonics = fabric.fabricHarmonics;
          connectionMatrix = fabric.connectionMatrix;
          laplacianMatrix = fabric.laplacianMatrix;
        }, newNodes[nodeIdx].activation)
      };
      case (#Prediction) {
        // Predict next state based on harmonics
        let node = fabric.nodes[nodeIdx];
        var prediction : Float = 0.0;
        for (l in Iter.range(0, 4)) {
          for (m in Iter.range(-l, l)) {
            let idx = l * l + l + m;
            if (idx < node.harmonicCoeffs.size()) {
              prediction += node.harmonicCoeffs[idx] * Float.cos(Float.fromInt(l) * input);
            };
          };
        };
        (fabric, prediction)
      };
      case (#Defense) {
        // Check for anomalies
        let node = fabric.nodes[nodeIdx];
        let anomaly = Float.abs(input - node.activation) / (node.activation + 0.01);
        let defended = if (anomaly > 1.0) { 0.0 } else { input };
        (fabric, defended)
      };
      case (#Creation) {
        // Generate new pattern
        let node = fabric.nodes[nodeIdx];
        let created = input * Float.sin(node.phase) * node.coherence;
        (fabric, created)
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COMPLETE WEB TICK                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Execute one complete tick of the spherical web
  // ALL nodes fire, ALL responsibilities execute, ALL connections active
  public func webTick(fabric : SphericalWebFabric, inputs : [Float], dt : Float) : SphericalWebFabric {
    var currentFabric = fabric;
    
    // Phase 1: All nodes execute all responsibilities
    for (i in Iter.range(0, fabric.nodeCount - 1)) {
      let input = if (i < inputs.size()) { inputs[i] } else { 0.0 };
      let (newFabric, _outputs) = executeNodeResponsibilities(currentFabric, i, input);
      currentFabric := newFabric;
    };
    
    // Phase 2: Kuramoto coupling (global synchronization)
    currentFabric := kuramotoCoupling(currentFabric, φ, dt);
    
    // Phase 3: Diffusion (information spreading)
    currentFabric := sphericalDiffusion(currentFabric, ψ, dt);
    
    // Phase 4: Update fabric harmonics
    let newHarmonics = computeFabricHarmonics(currentFabric.nodes);
    
    {
      nodes = currentFabric.nodes;
      nodeCount = currentFabric.nodeCount;
      radius = currentFabric.radius;
      globalCoherence = currentFabric.globalCoherence;
      globalPhase = currentFabric.globalPhase;
      totalEnergy = currentFabric.totalEnergy;
      eulerCharacteristic = currentFabric.eulerCharacteristic;
      genus = currentFabric.genus;
      fabricHarmonics = newHarmonics;
      connectionMatrix = currentFabric.connectionMatrix;
      laplacianMatrix = currentFabric.laplacianMatrix;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MATRIX OPERATIONS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type Matrix = [[Float]];

  public func matrixZero(rows : Nat, cols : Nat) : Matrix {
    Array.tabulate<[Float]>(rows, func(_ : Nat) : [Float] {
      Array.tabulate<Float>(cols, func(_ : Nat) : Float { 0.0 })
    })
  };

  public func matrixIdentity(n : Nat) : Matrix {
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { 1.0 } else { 0.0 }
      })
    })
  };

  public func matrixAdd(a : Matrix, b : Matrix) : Matrix {
    Array.tabulate<[Float]>(a.size(), func(i : Nat) : [Float] {
      Array.tabulate<Float>(a[i].size(), func(j : Nat) : Float {
        a[i][j] + b[i][j]
      })
    })
  };

  public func matrixScale(m : Matrix, s : Float) : Matrix {
    Array.tabulate<[Float]>(m.size(), func(i : Nat) : [Float] {
      Array.tabulate<Float>(m[i].size(), func(j : Nat) : Float {
        m[i][j] * s
      })
    })
  };

  public func matrixMul(a : Matrix, b : Matrix) : Matrix {
    let rows = a.size();
    let cols = b[0].size();
    let inner = b.size();
    
    Array.tabulate<[Float]>(rows, func(i : Nat) : [Float] {
      Array.tabulate<Float>(cols, func(j : Nat) : Float {
        var sum : Float = 0.0;
        for (k in Iter.range(0, inner - 1)) {
          sum += a[i][k] * b[k][j];
        };
        sum
      })
    })
  };

  public func matrixTranspose(m : Matrix) : Matrix {
    let rows = m.size();
    let cols = m[0].size();
    
    Array.tabulate<[Float]>(cols, func(j : Nat) : [Float] {
      Array.tabulate<Float>(rows, func(i : Nat) : Float {
        m[i][j]
      })
    })
  };

  public func matrixTrace(m : Matrix) : Float {
    var sum : Float = 0.0;
    let n = Nat.min(m.size(), m[0].size());
    for (i in Iter.range(0, n - 1)) {
      sum += m[i][i];
    };
    sum
  };

  public func matrixFrobeniusNorm(m : Matrix) : Float {
    var sum : Float = 0.0;
    for (row in m.vals()) {
      for (val in row.vals()) {
        sum += val * val;
      };
    };
    Float.sqrt(sum)
  };

  // Power iteration for dominant eigenvalue
  public func powerIteration(m : Matrix, maxIter : Nat, tol : Float) : (Float, [Float]) {
    let n = m.size();
    
    // Initial vector
    var v = Array.tabulate<Float>(n, func(i : Nat) : Float {
      Float.sin(Float.fromInt(i) * φ)  // Golden-based initialization
    });
    
    // Normalize
    var norm : Float = 0.0;
    for (val in v.vals()) { norm += val * val };
    norm := Float.sqrt(norm);
    v := Array.tabulate<Float>(n, func(i : Nat) : Float { v[i] / norm });
    
    var eigenvalue : Float = 0.0;
    
    for (_iter in Iter.range(0, maxIter - 1)) {
      // Matrix-vector multiply
      let mv = Array.tabulate<Float>(n, func(i : Nat) : Float {
        var sum : Float = 0.0;
        for (j in Iter.range(0, n - 1)) {
          sum += m[i][j] * v[j];
        };
        sum
      });
      
      // Compute eigenvalue (Rayleigh quotient)
      var dot : Float = 0.0;
      for (i in Iter.range(0, n - 1)) {
        dot += v[i] * mv[i];
      };
      
      let newEigenvalue = dot;
      
      // Normalize
      norm := 0.0;
      for (val in mv.vals()) { norm += val * val };
      norm := Float.sqrt(norm);
      
      v := Array.tabulate<Float>(n, func(i : Nat) : Float { mv[i] / norm });
      
      // Check convergence
      if (Float.abs(newEigenvalue - eigenvalue) < tol) {
        return (newEigenvalue, v);
      };
      
      eigenvalue := newEigenvalue;
    };
    
    (eigenvalue, v)
  };

}
