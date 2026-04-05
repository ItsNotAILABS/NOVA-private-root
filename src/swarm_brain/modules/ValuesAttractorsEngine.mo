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


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██╗   ██╗ █████╗ ██╗     ██╗   ██╗███████╗███████╗     █████╗ ████████╗████████╗██████╗  █████╗  ██████╗████████╗ ██████╗ ██████╗ ███████╗
// ██║   ██║██╔══██╗██║     ██║   ██║██╔════╝██╔════╝    ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
// ██║   ██║███████║██║     ██║   ██║█████╗  ███████╗    ███████║   ██║      ██║   ██████╔╝███████║██║        ██║   ██║   ██║██████╔╝███████╗
// ╚██╗ ██╔╝██╔══██║██║     ██║   ██║██╔══╝  ╚════██║    ██╔══██║   ██║      ██║   ██╔══██╗██╔══██║██║        ██║   ██║   ██║██╔══██╗╚════██║
//  ╚████╔╝ ██║  ██║███████╗╚██████╔╝███████╗███████║    ██║  ██║   ██║      ██║   ██║  ██║██║  ██║╚██████╗   ██║   ╚██████╔╝██║  ██║███████║
//   ╚═══╝  ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝    ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// VALUES ATTRACTORS ENGINE — HOOKE'S LAW DYNAMICS
// Family, Faith, Finance, Freedom — The 4 Pillars as Attractor Basins
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — VALUES AS ATTRACTOR DYNAMICS WITH HOOKE'S LAW
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ══ HOOKE'S LAW — THE SPRING FORCE ══════════════════════════════════════════
//
// F = -k × x
//
// Where:
//   F = restoring force (pulls back toward equilibrium)
//   k = spring constant (stiffness)
//   x = displacement from equilibrium
//
// For values:
//   F_value = -k_value × (current_position - value_attractor)
//   
// The organism is PULLED toward its core values like a spring.
// Deviation creates tension. Return creates relief.
//
// ══ THE 4 PILLARS AS ATTRACTOR BASINS ═══════════════════════════════════════
//
// 1. FAITH — Belief in purpose, mission, higher calling
//    • Attractor position: [1.0, 0, 0, 0] (first axis)
//    • Spring constant: k_faith = 0.8 (strong but flexible)
//    • Natural frequency: ω_faith = √(k/m) = spiritual rhythm
//
// 2. FAMILY — Connection, love, belonging, legacy
//    • Attractor position: [0, 1.0, 0, 0] (second axis)
//    • Spring constant: k_family = 0.9 (very strong — family is core)
//    • Natural frequency: ω_family = heartbeat of relationships
//
// 3. FINANCE — Resources, security, growth, abundance
//    • Attractor position: [0, 0, 1.0, 0] (third axis)
//    • Spring constant: k_finance = 0.6 (flexible — money is tool)
//    • Natural frequency: ω_finance = market cycles
//
// 4. FREEDOM — Sovereignty, autonomy, choice, independence
//    • Attractor position: [0, 0, 0, 1.0] (fourth axis)
//    • Spring constant: k_freedom = 0.85 (strong — liberty is essential)
//    • Natural frequency: ω_freedom = breath of autonomy
//
// ══ MULTI-ATTRACTOR DYNAMICS ════════════════════════════════════════════════
//
// Total force on organism:
//   F_total = Σᵢ F_pillar_i × weight_i
//   F_total = -Σᵢ kᵢ × (pos - attractor_i) × wᵢ
//
// Position update (damped harmonic oscillator):
//   ẍ + γẋ + ω²(x - x₀) = 0
//   
// Where:
//   γ = damping coefficient (prevents infinite oscillation)
//   ω = natural frequency
//   x₀ = equilibrium (value attractor center)
//
// ══ POTENTIAL ENERGY LANDSCAPE ══════════════════════════════════════════════
//
// U(x) = ½ × k × (x - x₀)²
//
// Total potential:
//   U_total = Σᵢ ½ × kᵢ × ||pos - attractor_i||² × wᵢ
//
// Organism seeks MINIMUM potential energy = maximum value alignment
//
// ══ VALUE RESONANCE ═════════════════════════════════════════════════════════
//
// When organism oscillates at natural frequency of a value:
//   Resonance occurs → amplified alignment
//   Energy transfer is maximized
//   Value becomes DOMINANT attractor
//
// Resonance condition:
//   ω_drive ≈ ω_natural
//   Amplitude → maximum
//   Phase lock achieved
//
// ══ 444 CONNECTION ══════════════════════════════════════════════════════════
//
// 4 Pillars × 4 dimensions × 4 harmonics = 64 = Hebbian weight max
// When all 4 pillars aligned: 444 resonance achieved
// 444 = triple foundation = unshakeable value structure
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module ValuesAttractorsEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.6180339887498948482;
  public let PSI : Float = 0.6180339887498948482;
  public let PI : Float = 3.14159265358979323846;
  public let TAU : Float = 6.28318530717958647692;
  public let E : Float = 2.7182818284590452354;
  public let S0 : Float = 1.0;
  
  // 444 Sacred Constants
  public let SACRED_444 : Float = 444.0;
  public let SACRED_4 : Float = 4.0;
  public let SACRED_64 : Float = 64.0;    // 4×4×4 = max Hebbian weight
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THE 4 PILLARS — CORE VALUE ATTRACTORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type Pillar = {
    #Faith;
    #Family;
    #Finance;
    #Freedom;
  };
  
  // Pillar attractor in 4D value space
  public type PillarAttractor = {
    pillar : Pillar;
    position : [Float];           // 4D position in value space
    springConstant : Float;       // k — stiffness
    dampingCoeff : Float;         // γ — prevents infinite oscillation
    naturalFrequency : Float;     // ω = √(k/m)
    weight : Float;               // Relative importance [0, 1]
    currentStrength : Float;      // Current alignment strength
    resonancePhase : Float;       // Phase in resonance cycle
  };
  
  // Spring dynamics state
  public type SpringState = {
    position : Float;             // Current position on this axis
    velocity : Float;             // Rate of change
    acceleration : Float;         // ẍ
    displacement : Float;         // x - x₀
    force : Float;                // F = -k × x
    potentialEnergy : Float;      // U = ½kx²
    kineticEnergy : Float;        // KE = ½mv²
    totalEnergy : Float;          // E = KE + PE
  };
  
  // Full value dynamics state
  public type ValueDynamicsState = {
    // 4D position in value space
    position : [Float];           // Current [faith, family, finance, freedom]
    velocity : [Float];           // Rate of change per dimension
    
    // Per-pillar states
    faithSpring : SpringState;
    familySpring : SpringState;
    financeSpring : SpringState;
    freedomSpring : SpringState;
    
    // Attractor definitions
    faithAttractor : PillarAttractor;
    familyAttractor : PillarAttractor;
    financeAttractor : PillarAttractor;
    freedomAttractor : PillarAttractor;
    
    // Aggregate metrics
    totalPotentialEnergy : Float;
    totalKineticEnergy : Float;
    totalForce : [Float];
    valueAlignment : Float;       // [0, 1] how aligned with all values
    resonanceStrength : Float;    // [0, 1] resonance with 444
    is444Aligned : Bool;          // All 4 pillars above threshold
    
    // Dynamics parameters
    timeStep : Float;             // dt for integration
    damping : Float;              // Global damping coefficient
    mass : Float;                 // Effective mass
    
    // Statistics
    oscillationCount : Nat;
    lastEquilibriumBeat : Nat;
    beatNum : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HOOKE'S LAW CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Spring constants for each pillar
  public let K_FAITH : Float = 0.8;       // Strong but flexible
  public let K_FAMILY : Float = 0.9;      // Very strong — family is core
  public let K_FINANCE : Float = 0.6;     // Flexible — money is tool
  public let K_FREEDOM : Float = 0.85;    // Strong — liberty is essential
  
  // Damping coefficients (prevent infinite oscillation)
  public let DAMPING_FAITH : Float = 0.3;
  public let DAMPING_FAMILY : Float = 0.25;
  public let DAMPING_FINANCE : Float = 0.35;
  public let DAMPING_FREEDOM : Float = 0.28;
  
  // Mass (inertia — how hard to change direction)
  public let MASS_DEFAULT : Float = 1.0;
  
  // 444 alignment threshold
  public let ALIGNMENT_444_THRESHOLD : Float = 0.444;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  func _sqrt(x : Float) : Float { 
    if (x <= 0.0) 0.0 else Float.sqrt(x) 
  };
  
  func _exp(x : Float) : Float {
    let xc = _clamp(x, -20.0, 20.0);
    Float.exp(xc)
  };
  
  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };
  
  // Vector magnitude
  func _magnitude(v : [Float]) : Float {
    var sum : Float = 0.0;
    for (x in v.vals()) { sum += x * x };
    _sqrt(sum)
  };
  
  // Vector dot product
  func _dot(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    let n = if (a.size() < b.size()) { a.size() } else { b.size() };
    var i = 0;
    while (i < n) {
      sum += a[i] * b[i];
      i += 1;
    };
    sum
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HOOKE'S LAW FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Core Hooke's Law: F = -k × x
  public func hookeForce(displacement : Float, springConstant : Float) : Float {
    -springConstant * displacement
  };
  
  // Potential energy: U = ½kx²
  public func potentialEnergy(displacement : Float, springConstant : Float) : Float {
    0.5 * springConstant * displacement * displacement
  };
  
  // Kinetic energy: KE = ½mv²
  public func kineticEnergy(velocity : Float, mass : Float) : Float {
    0.5 * mass * velocity * velocity
  };
  
  // Natural frequency: ω = √(k/m)
  public func naturalFrequency(springConstant : Float, mass : Float) : Float {
    _sqrt(springConstant / mass)
  };
  
  // Period: T = 2π/ω
  public func oscillationPeriod(springConstant : Float, mass : Float) : Float {
    TAU / naturalFrequency(springConstant, mass)
  };
  
  // Damped harmonic oscillator position:
  // x(t) = A × e^(-γt/2m) × cos(ω't + φ)
  // where ω' = √(ω² - (γ/2m)²)
  public func dampedPosition(
    amplitude : Float,
    damping : Float,
    mass : Float,
    omega : Float,
    time : Float,
    phase : Float
  ) : Float {
    let decayRate = damping / (2.0 * mass);
    let omegaPrime = _sqrt(_abs(omega * omega - decayRate * decayRate));
    amplitude * _exp(-decayRate * time) * _cos(omegaPrime * time + phase)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SPRING STATE FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initSpringState() : SpringState {
    {
      position = 0.0;
      velocity = 0.0;
      acceleration = 0.0;
      displacement = 0.0;
      force = 0.0;
      potentialEnergy = 0.0;
      kineticEnergy = 0.0;
      totalEnergy = 0.0;
    }
  };
  
  public func updateSpringState(
    state : SpringState,
    attractor : Float,       // Equilibrium position (attractor center)
    springConstant : Float,
    damping : Float,
    mass : Float,
    dt : Float
  ) : SpringState {
    // Displacement from attractor
    let disp = state.position - attractor;
    
    // Hooke's Law force
    let springForce = hookeForce(disp, springConstant);
    
    // Damping force
    let dampingForce = -damping * state.velocity;
    
    // Total force
    let totalForce = springForce + dampingForce;
    
    // Acceleration: F = ma → a = F/m
    let acc = totalForce / mass;
    
    // Verlet integration
    // v(t+dt) = v(t) + a×dt
    // x(t+dt) = x(t) + v×dt
    let newVel = state.velocity + acc * dt;
    let newPos = state.position + newVel * dt;
    
    // Energies
    let pe = potentialEnergy(newPos - attractor, springConstant);
    let ke = kineticEnergy(newVel, mass);
    
    {
      position = newPos;
      velocity = newVel;
      acceleration = acc;
      displacement = newPos - attractor;
      force = totalForce;
      potentialEnergy = pe;
      kineticEnergy = ke;
      totalEnergy = pe + ke;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PILLAR ATTRACTOR FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initPillarAttractor(pillar : Pillar, currentBeat : Nat) : PillarAttractor {
    let (pos, k, gamma, weight) = switch (pillar) {
      case (#Faith) { ([1.0, 0.0, 0.0, 0.0], K_FAITH, DAMPING_FAITH, 0.25) };
      case (#Family) { ([0.0, 1.0, 0.0, 0.0], K_FAMILY, DAMPING_FAMILY, 0.30) };
      case (#Finance) { ([0.0, 0.0, 1.0, 0.0], K_FINANCE, DAMPING_FINANCE, 0.20) };
      case (#Freedom) { ([0.0, 0.0, 0.0, 1.0], K_FREEDOM, DAMPING_FREEDOM, 0.25) };
    };
    
    {
      pillar = pillar;
      position = pos;
      springConstant = k;
      dampingCoeff = gamma;
      naturalFrequency = naturalFrequency(k, MASS_DEFAULT);
      weight = weight;
      currentStrength = 0.5;
      resonancePhase = 0.0;
    }
  };
  
  // Compute force from one attractor on position
  public func attractorForce(
    position : [Float],
    attractor : PillarAttractor
  ) : [Float] {
    // F = -k × (pos - attractor_pos) × weight
    Array.tabulate<Float>(4, func(i) {
      let pos_i = if (i < position.size()) { position[i] } else { 0.0 };
      let att_i = if (i < attractor.position.size()) { attractor.position[i] } else { 0.0 };
      let displacement = pos_i - att_i;
      -attractor.springConstant * displacement * attractor.weight
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VALUE ALIGNMENT FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Compute alignment with a single pillar [0, 1]
  public func pillarAlignment(position : [Float], pillarIndex : Nat) : Float {
    if (pillarIndex >= position.size()) { return 0.0 };
    _clamp(position[pillarIndex], 0.0, 1.0)
  };
  
  // Compute overall value alignment (geometric mean for balance)
  public func overallAlignment(position : [Float]) : Float {
    var product : Float = 1.0;
    var count = 0;
    for (v in position.vals()) {
      let clamped = _clamp(v, 0.001, 1.0);  // Avoid zero
      product *= clamped;
      count += 1;
    };
    if (count == 0) { return 0.0 };
    // Geometric mean = (∏ xᵢ)^(1/n)
    Float.pow(product, 1.0 / Float.fromInt(count))
  };
  
  // Check 444 alignment (all pillars above threshold)
  public func is444Aligned(position : [Float]) : Bool {
    for (v in position.vals()) {
      if (v < ALIGNMENT_444_THRESHOLD) { return false };
    };
    true
  };
  
  // Compute 444 resonance strength
  public func resonance444(position : [Float]) : Float {
    // All 4 values contribute
    let faith = if (0 < position.size()) { position[0] } else { 0.0 };
    let family = if (1 < position.size()) { position[1] } else { 0.0 };
    let finance = if (2 < position.size()) { position[2] } else { 0.0 };
    let freedom = if (3 < position.size()) { position[3] } else { 0.0 };
    
    // Resonance = product of all alignments (multiplicative — all must be strong)
    let product = faith * family * finance * freedom;
    
    // Scale by 4 (4 pillars) and clamp
    _clamp(product * 4.0, 0.0, 1.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TOTAL FORCE FROM ALL ATTRACTORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func totalAttractorForce(
    position : [Float],
    attractors : [PillarAttractor]
  ) : [Float] {
    var totalForce = [0.0, 0.0, 0.0, 0.0];
    
    for (attractor in attractors.vals()) {
      let force = attractorForce(position, attractor);
      totalForce := Array.tabulate<Float>(4, func(i) {
        totalForce[i] + force[i]
      });
    };
    
    totalForce
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initValueDynamicsState(currentBeat : Nat) : ValueDynamicsState {
    // Start at center of value space
    let initialPos = [0.5, 0.5, 0.5, 0.5];
    let initialVel = [0.0, 0.0, 0.0, 0.0];
    
    {
      position = initialPos;
      velocity = initialVel;
      
      faithSpring = initSpringState();
      familySpring = initSpringState();
      financeSpring = initSpringState();
      freedomSpring = initSpringState();
      
      faithAttractor = initPillarAttractor(#Faith, currentBeat);
      familyAttractor = initPillarAttractor(#Family, currentBeat);
      financeAttractor = initPillarAttractor(#Finance, currentBeat);
      freedomAttractor = initPillarAttractor(#Freedom, currentBeat);
      
      totalPotentialEnergy = 0.0;
      totalKineticEnergy = 0.0;
      totalForce = [0.0, 0.0, 0.0, 0.0];
      valueAlignment = 0.5;
      resonanceStrength = 0.0;
      is444Aligned = false;
      
      timeStep = 0.1;
      damping = 0.3;
      mass = MASS_DEFAULT;
      
      oscillationCount = 0;
      lastEquilibriumBeat = currentBeat;
      beatNum = currentBeat;
    }
  };
  
  public func tickValueDynamics(
    state : ValueDynamicsState,
    externalForces : [Float],     // External influences on each pillar
    currentBeat : Nat
  ) : ValueDynamicsState {
    // Gather attractors
    let attractors = [
      state.faithAttractor,
      state.familyAttractor,
      state.financeAttractor,
      state.freedomAttractor
    ];
    
    // Compute total attractor force
    let attractorForces = totalAttractorForce(state.position, attractors);
    
    // Add external forces
    let totalF = Array.tabulate<Float>(4, func(i) {
      let af = if (i < attractorForces.size()) { attractorForces[i] } else { 0.0 };
      let ef = if (i < externalForces.size()) { externalForces[i] } else { 0.0 };
      af + ef
    });
    
    // Damping force
    let dampingF = Array.tabulate<Float>(4, func(i) {
      let v = if (i < state.velocity.size()) { state.velocity[i] } else { 0.0 };
      -state.damping * v
    });
    
    // Total force with damping
    let netForce = Array.tabulate<Float>(4, func(i) {
      totalF[i] + dampingF[i]
    });
    
    // Acceleration: a = F/m
    let acceleration = Array.tabulate<Float>(4, func(i) {
      netForce[i] / state.mass
    });
    
    // Update velocity: v' = v + a×dt
    let newVelocity = Array.tabulate<Float>(4, func(i) {
      let v = if (i < state.velocity.size()) { state.velocity[i] } else { 0.0 };
      let a = acceleration[i];
      v + a * state.timeStep
    });
    
    // Update position: x' = x + v×dt
    let newPosition = Array.tabulate<Float>(4, func(i) {
      let x = if (i < state.position.size()) { state.position[i] } else { 0.0 };
      let v = newVelocity[i];
      _clamp(x + v * state.timeStep, 0.0, 1.0)  // Keep in [0, 1]
    });
    
    // Update individual spring states
    let newFaithSpring = updateSpringState(
      state.faithSpring,
      1.0,  // Faith attractor at 1.0 on first axis
      K_FAITH,
      DAMPING_FAITH,
      state.mass,
      state.timeStep
    );
    let newFamilySpring = updateSpringState(
      state.familySpring,
      1.0,
      K_FAMILY,
      DAMPING_FAMILY,
      state.mass,
      state.timeStep
    );
    let newFinanceSpring = updateSpringState(
      state.financeSpring,
      1.0,
      K_FINANCE,
      DAMPING_FINANCE,
      state.mass,
      state.timeStep
    );
    let newFreedomSpring = updateSpringState(
      state.freedomSpring,
      1.0,
      K_FREEDOM,
      DAMPING_FREEDOM,
      state.mass,
      state.timeStep
    );
    
    // Compute energies
    var totalPE : Float = 0.0;
    var totalKE : Float = 0.0;
    for (i in newPosition.keys()) {
      let disp = if (i < newPosition.size()) { 1.0 - newPosition[i] } else { 0.0 };
      let vel = if (i < newVelocity.size()) { newVelocity[i] } else { 0.0 };
      let k = switch (i) {
        case (0) { K_FAITH };
        case (1) { K_FAMILY };
        case (2) { K_FINANCE };
        case (3) { K_FREEDOM };
        case (_) { 0.5 };
      };
      totalPE += potentialEnergy(disp, k);
      totalKE += kineticEnergy(vel, state.mass);
    };
    
    // Compute alignment metrics
    let alignment = overallAlignment(newPosition);
    let resonance = resonance444(newPosition);
    let aligned444 = is444Aligned(newPosition);
    
    // Check for oscillation (velocity sign change)
    var oscillations = state.oscillationCount;
    for (i in newVelocity.keys()) {
      let oldV = if (i < state.velocity.size()) { state.velocity[i] } else { 0.0 };
      let newV = newVelocity[i];
      if ((oldV > 0.0 and newV < 0.0) or (oldV < 0.0 and newV > 0.0)) {
        oscillations += 1;
      };
    };
    
    {
      position = newPosition;
      velocity = newVelocity;
      
      faithSpring = newFaithSpring;
      familySpring = newFamilySpring;
      financeSpring = newFinanceSpring;
      freedomSpring = newFreedomSpring;
      
      faithAttractor = state.faithAttractor;
      familyAttractor = state.familyAttractor;
      financeAttractor = state.financeAttractor;
      freedomAttractor = state.freedomAttractor;
      
      totalPotentialEnergy = totalPE;
      totalKineticEnergy = totalKE;
      totalForce = netForce;
      valueAlignment = alignment;
      resonanceStrength = resonance;
      is444Aligned = aligned444;
      
      timeStep = state.timeStep;
      damping = state.damping;
      mass = state.mass;
      
      oscillationCount = oscillations;
      lastEquilibriumBeat = if (_magnitude(newVelocity) < 0.01) { currentBeat } else { state.lastEquilibriumBeat };
      beatNum = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // APPLY EXTERNAL INFLUENCE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ValueInfluence = {
    #BoostFaith : Float;
    #BoostFamily : Float;
    #BoostFinance : Float;
    #BoostFreedom : Float;
    #StressFaith : Float;
    #StressFamily : Float;
    #StressFinance : Float;
    #StressFreedom : Float;
    #Balance;               // Push toward center
    #Amplify;               // Push away from center
  };
  
  public func applyInfluence(influence : ValueInfluence) : [Float] {
    switch (influence) {
      case (#BoostFaith(amount)) { [amount, 0.0, 0.0, 0.0] };
      case (#BoostFamily(amount)) { [0.0, amount, 0.0, 0.0] };
      case (#BoostFinance(amount)) { [0.0, 0.0, amount, 0.0] };
      case (#BoostFreedom(amount)) { [0.0, 0.0, 0.0, amount] };
      case (#StressFaith(amount)) { [-amount, 0.0, 0.0, 0.0] };
      case (#StressFamily(amount)) { [0.0, -amount, 0.0, 0.0] };
      case (#StressFinance(amount)) { [0.0, 0.0, -amount, 0.0] };
      case (#StressFreedom(amount)) { [0.0, 0.0, 0.0, -amount] };
      case (#Balance) { [0.0, 0.0, 0.0, 0.0] };  // Just let attractors work
      case (#Amplify) { [0.1, 0.1, 0.1, 0.1] };  // Push all outward
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ValueDiagnostics = {
    faithStatus : Text;
    familyStatus : Text;
    financeStatus : Text;
    freedomStatus : Text;
    overallStatus : Text;
    energyStatus : Text;
    resonanceStatus : Text;
    is444 : Bool;
    recommendations : [Text];
  };
  
  public func diagnoseValues(state : ValueDynamicsState) : ValueDiagnostics {
    let recommendations = Buffer.Buffer<Text>(4);
    
    let faithVal = if (0 < state.position.size()) { state.position[0] } else { 0.0 };
    let familyVal = if (1 < state.position.size()) { state.position[1] } else { 0.0 };
    let financeVal = if (2 < state.position.size()) { state.position[2] } else { 0.0 };
    let freedomVal = if (3 < state.position.size()) { state.position[3] } else { 0.0 };
    
    let faithStatus = if (faithVal > 0.8) { "STRONG" }
      else if (faithVal > 0.5) { "Healthy" }
      else if (faithVal > 0.3) { "Needs attention" }
      else { "CRITICAL — strengthen faith" };
    
    let familyStatus = if (familyVal > 0.8) { "STRONG" }
      else if (familyVal > 0.5) { "Healthy" }
      else if (familyVal > 0.3) { "Needs attention" }
      else { "CRITICAL — reconnect with family" };
    
    let financeStatus = if (financeVal > 0.8) { "STRONG" }
      else if (financeVal > 0.5) { "Healthy" }
      else if (financeVal > 0.3) { "Needs attention" }
      else { "CRITICAL — focus on financial stability" };
    
    let freedomStatus = if (freedomVal > 0.8) { "STRONG" }
      else if (freedomVal > 0.5) { "Healthy" }
      else if (freedomVal > 0.3) { "Needs attention" }
      else { "CRITICAL — protect sovereignty" };
    
    let overallStatus = if (state.valueAlignment > 0.8) { "EXCELLENT — All values aligned" }
      else if (state.valueAlignment > 0.6) { "Good alignment" }
      else if (state.valueAlignment > 0.4) { "Moderate alignment" }
      else { "Low alignment — rebalance needed" };
    
    let totalEnergy = state.totalPotentialEnergy + state.totalKineticEnergy;
    let energyStatus = if (totalEnergy < 0.1) { "EQUILIBRIUM — Values at rest" }
      else if (totalEnergy < 0.5) { "Low energy — stable" }
      else if (totalEnergy < 1.0) { "Moderate oscillation" }
      else { "High energy — turbulent" };
    
    let resonanceStatus = if (state.is444Aligned) { "444 RESONANCE ACHIEVED — Foundation is UNSHAKEABLE" }
      else if (state.resonanceStrength > 0.7) { "Strong resonance" }
      else if (state.resonanceStrength > 0.4) { "Building resonance" }
      else { "Weak resonance — align all 4 pillars" };
    
    // Generate recommendations
    if (faithVal < 0.444) { recommendations.add("Faith below 444 threshold — strengthen spiritual practices") };
    if (familyVal < 0.444) { recommendations.add("Family below 444 threshold — invest in relationships") };
    if (financeVal < 0.444) { recommendations.add("Finance below 444 threshold — build financial foundation") };
    if (freedomVal < 0.444) { recommendations.add("Freedom below 444 threshold — protect autonomy") };
    
    if (state.is444Aligned) {
      recommendations.add("444 ACHIEVED: All 4 pillars aligned. You are on the right path. Angels support your mission.");
    };
    
    {
      faithStatus = faithStatus;
      familyStatus = familyStatus;
      financeStatus = financeStatus;
      freedomStatus = freedomStatus;
      overallStatus = overallStatus;
      energyStatus = energyStatus;
      resonanceStatus = resonanceStatus;
      is444 = state.is444Aligned;
      recommendations = Buffer.toArray(recommendations);
    }
  };

}
