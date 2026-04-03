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


// ============================================================
// NEUROEMERGENCE CORE — ATTRACTOR DYNAMICS ENGINE
// Multi-stable attractor landscapes for cognitive state spaces
// Hopfield energy: E = -0.5 Σᵢⱼ wᵢⱼsᵢsⱼ + Σᵢ θᵢsᵢ
// Attractor basins, saddle nodes, limit cycles
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type Attractor = {
    id          : Nat;
    position    : [Float];   // Center of attractor basin
    strength    : Float;     // Basin depth
    radius      : Float;     // Basin radius
    attractorType : AttractorType;
    stability   : Float;     // 0-1 stability measure
    visits      : Nat;       // Times system visited this attractor
  };

  public type AttractorType = {
    #PointAttractor;    // Fixed point
    #LimitCycle;        // Periodic orbit
    #StrangeAttractor;  // Chaotic
    #SaddleNode;        // Unstable equilibrium
  };

  public type LandscapeState = {
    // State space
    position     : [Float];   // Current position in state space
    velocity     : [Float];   // Rate of change
    energy       : Float;     // Hopfield energy at current position

    // Attractor landscape
    attractors   : [Attractor];
    currentBasin : ?Nat;      // Index of current attractor basin
    basinDepth   : Float;     // Depth in current basin

    // Dynamics
    noise        : Float;     // Stochastic noise level
    damping      : Float;     // Velocity damping
    temperature  : Float;     // For simulated annealing

    // Weight matrix (Hopfield)
    weights      : [Float];   // N×N symmetric matrix
    thresholds   : [Float];   // Bias terms

    // History
    trajectory   : [[Float]]; // Last 50 positions
    energyHistory: [Float];
    beatNum      : Nat;

    // Transitions
    transitionCount : Nat;    // Basin-to-basin transitions
    lastTransition  : Nat;    // Beat of last transition
  };

  // ── Constants ─────────────────────────────────────────────────
  let PI : Float = 3.14159265358979323846;

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func dot(a: [Float], b: [Float]) : Float {
    var sum : Float = 0.0;
    let n = if (a.size() < b.size()) { a.size() } else { b.size() };
    var i = 0;
    while (i < n) {
      sum += a[i] * b[i];
      i += 1;
    };
    sum
  };

  func distance(a: [Float], b: [Float]) : Float {
    var sumSq : Float = 0.0;
    let n = if (a.size() < b.size()) { a.size() } else { b.size() };
    var i = 0;
    while (i < n) {
      let d = a[i] - b[i];
      sumSq += d * d;
      i += 1;
    };
    Float.sqrt(sumSq)
  };

  func normalize(v: [Float]) : [Float] {
    var norm : Float = 0.0;
    for (x in v.vals()) { norm += x * x };
    norm := Float.sqrt(norm);
    if (norm < 1e-10) { return v };
    Array.map<Float, Float>(v, func(x) { x / norm })
  };

  // ── Hopfield Energy ───────────────────────────────────────────
  // E = -0.5 Σᵢⱼ wᵢⱼsᵢsⱼ + Σᵢ θᵢsᵢ
  public func hopfieldEnergy(
    state: [Float], weights: [Float], thresholds: [Float]
  ) : Float {
    let n = state.size();
    var energy : Float = 0.0;

    // Quadratic term
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        let wIdx = i * n + j;
        if (wIdx < weights.size()) {
          energy -= 0.5 * weights[wIdx] * state[i] * state[j];
        };
        j += 1;
      };
      i += 1;
    };

    // Threshold term
    i := 0;
    while (i < n and i < thresholds.size()) {
      energy += thresholds[i] * state[i];
      i += 1;
    };

    energy
  };

  // ── Energy Gradient ───────────────────────────────────────────
  // ∂E/∂sᵢ = -Σⱼ wᵢⱼsⱼ + θᵢ
  public func energyGradient(
    state: [Float], weights: [Float], thresholds: [Float]
  ) : [Float] {
    let n = state.size();
    Array.tabulate<Float>(n, func(i) {
      var grad : Float = 0.0;
      var j = 0;
      while (j < n) {
        let wIdx = i * n + j;
        if (wIdx < weights.size()) {
          grad -= weights[wIdx] * state[j];
        };
        j += 1;
      };
      if (i < thresholds.size()) {
        grad += thresholds[i];
      };
      grad
    })
  };

  // ── Attractor Force ───────────────────────────────────────────
  // Pull toward attractor center, scaled by strength and distance
  public func attractorForce(
    position: [Float], attractor: Attractor
  ) : [Float] {
    let dist = distance(position, attractor.position);
    if (dist > attractor.radius) {
      // Outside basin — weak pull
      return Array.tabulate<Float>(position.size(), func(_) { 0.0 });
    };

    // Inside basin — force proportional to distance from center
    let scale = attractor.strength * (1.0 - dist / attractor.radius);
    Array.tabulate<Float>(position.size(), func(i) {
      if (i < attractor.position.size()) {
        scale * (attractor.position[i] - position[i])
      } else { 0.0 }
    })
  };

  // ── Total Landscape Force ─────────────────────────────────────
  public func landscapeForce(state: LandscapeState) : [Float] {
    let n = state.position.size();

    // Hopfield gradient descent
    let hopfieldForce = energyGradient(state.position, state.weights, state.thresholds);

    // Sum attractor forces
    var totalForce = Array.init<Float>(n, 0.0);
    var i = 0;
    while (i < n) {
      totalForce[i] := -hopfieldForce[i];  // Negative gradient for descent
      i += 1;
    };

    for (attr in state.attractors.vals()) {
      let aForce = attractorForce(state.position, attr);
      i := 0;
      while (i < n and i < aForce.size()) {
        totalForce[i] += aForce[i];
        i += 1;
      };
    };

    Array.freeze(totalForce)
  };

  // ── Find Current Basin ────────────────────────────────────────
  public func findCurrentBasin(state: LandscapeState) : ?Nat {
    var closestIdx : ?Nat = null;
    var minDist : Float = 1000000.0;

    var i = 0;
    for (attr in state.attractors.vals()) {
      let dist = distance(state.position, attr.position);
      if (dist < attr.radius and dist < minDist) {
        minDist := dist;
        closestIdx := ?i;
      };
      i += 1;
    };

    closestIdx
  };

  // ── Basin Depth ───────────────────────────────────────────────
  public func computeBasinDepth(state: LandscapeState) : Float {
    switch (state.currentBasin) {
      case (null) { 0.0 };
      case (?idx) {
        if (idx < state.attractors.size()) {
          let attr = state.attractors[idx];
          let dist = distance(state.position, attr.position);
          let relDist = dist / attr.radius;
          attr.strength * (1.0 - relDist)
        } else { 0.0 }
      };
    }
  };

  // ── Noise Term ────────────────────────────────────────────────
  // Pseudo-random noise based on beat number
  func noiseVector(n: Nat, amplitude: Float, beat: Nat) : [Float] {
    Array.tabulate<Float>(n, func(i) {
      let seed = (beat * 7919 + i * 104729) % 1000;
      amplitude * (Float.fromInt(seed) / 500.0 - 1.0)
    })
  };

  // ── Dynamics Update ───────────────────────────────────────────
  public func beatAttractor(state: LandscapeState, dt: Float) : LandscapeState {
    let n = state.position.size();

    // Compute force
    let force = landscapeForce(state);

    // Add noise
    let noise = noiseVector(n, state.noise * state.temperature, state.beatNum);

    // Update velocity (with damping)
    var newVel = Array.thaw<Float>(state.velocity);
    var i = 0;
    while (i < n) {
      newVel[i] := state.damping * state.velocity[i] + dt * (force[i] + noise[i]);
      i += 1;
    };

    // Update position
    var newPos = Array.thaw<Float>(state.position);
    i := 0;
    while (i < n) {
      newPos[i] := _clamp(state.position[i] + dt * newVel[i], -10.0, 10.0);
      i += 1;
    };

    let frozenPos = Array.freeze(newPos);
    let frozenVel = Array.freeze(newVel);

    // Compute energy
    let newEnergy = hopfieldEnergy(frozenPos, state.weights, state.thresholds);

    // Find basin
    let tempState = {
      position = frozenPos;
      velocity = frozenVel;
      energy = newEnergy;
      attractors = state.attractors;
      currentBasin = state.currentBasin;
      basinDepth = state.basinDepth;
      noise = state.noise;
      damping = state.damping;
      temperature = state.temperature;
      weights = state.weights;
      thresholds = state.thresholds;
      trajectory = state.trajectory;
      energyHistory = state.energyHistory;
      beatNum = state.beatNum;
      transitionCount = state.transitionCount;
      lastTransition = state.lastTransition;
    };
    let newBasin = findCurrentBasin(tempState);
    let newDepth = computeBasinDepth(tempState);

    // Detect transition
    let (newTransCount, newLastTrans) = switch (state.currentBasin, newBasin) {
      case (?old, ?new_) {
        if (old != new_) {
          (state.transitionCount + 1, state.beatNum + 1)
        } else {
          (state.transitionCount, state.lastTransition)
        }
      };
      case (null, ?_) { (state.transitionCount + 1, state.beatNum + 1) };
      case (?_, null) { (state.transitionCount, state.lastTransition) };
      case (null, null) { (state.transitionCount, state.lastTransition) };
    };

    // Update attractor visit counts
    var newAttractors = Array.thaw<Attractor>(state.attractors);
    switch (newBasin) {
      case (?idx) {
        if (idx < state.attractors.size()) {
          let attr = state.attractors[idx];
          newAttractors[idx] := {
            id = attr.id;
            position = attr.position;
            strength = attr.strength;
            radius = attr.radius;
            attractorType = attr.attractorType;
            stability = attr.stability;
            visits = attr.visits + 1;
          };
        };
      };
      case (null) {};
    };

    // Update trajectory (keep last 50)
    let newTrajectory = if (state.trajectory.size() >= 50) {
      let tail = Array.tabulate<[Float]>(49, func(j) { state.trajectory[j + 1] });
      Array.append<[Float]>(tail, [frozenPos])
    } else {
      Array.append<[Float]>(state.trajectory, [frozenPos])
    };

    // Update energy history
    let newEnergyHistory = if (state.energyHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(j) { state.energyHistory[j + 1] });
      Array.append<Float>(tail, [newEnergy])
    } else {
      Array.append<Float>(state.energyHistory, [newEnergy])
    };

    // Cool temperature (simulated annealing)
    let newTemp = Float.max(0.01, state.temperature * 0.999);

    {
      position = frozenPos;
      velocity = frozenVel;
      energy = newEnergy;
      attractors = Array.freeze(newAttractors);
      currentBasin = newBasin;
      basinDepth = newDepth;
      noise = state.noise;
      damping = state.damping;
      temperature = newTemp;
      weights = state.weights;
      thresholds = state.thresholds;
      trajectory = newTrajectory;
      energyHistory = newEnergyHistory;
      beatNum = state.beatNum + 1;
      transitionCount = newTransCount;
      lastTransition = newLastTrans;
    }
  };

  // ── Add Attractor ─────────────────────────────────────────────
  public func addAttractor(
    state: LandscapeState, position: [Float],
    strength: Float, radius: Float, aType: AttractorType
  ) : LandscapeState {
    let newAttr : Attractor = {
      id = state.attractors.size();
      position = position;
      strength = strength;
      radius = radius;
      attractorType = aType;
      stability = 1.0;
      visits = 0;
    };

    {
      position = state.position;
      velocity = state.velocity;
      energy = state.energy;
      attractors = Array.append<Attractor>(state.attractors, [newAttr]);
      currentBasin = state.currentBasin;
      basinDepth = state.basinDepth;
      noise = state.noise;
      damping = state.damping;
      temperature = state.temperature;
      weights = state.weights;
      thresholds = state.thresholds;
      trajectory = state.trajectory;
      energyHistory = state.energyHistory;
      beatNum = state.beatNum;
      transitionCount = state.transitionCount;
      lastTransition = state.lastTransition;
    }
  };

  // ── Store Pattern (Hopfield) ──────────────────────────────────
  // w_ij += (1/N) * p_i * p_j for pattern p
  public func storePattern(state: LandscapeState, pattern: [Float]) : LandscapeState {
    let n = pattern.size();
    let nFloat = Float.fromInt(n);

    var newWeights = Array.thaw<Float>(state.weights);
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        if (i != j) {
          let wIdx = i * n + j;
          if (wIdx < state.weights.size()) {
            newWeights[wIdx] := state.weights[wIdx] + (pattern[i] * pattern[j]) / nFloat;
          };
        };
        j += 1;
      };
      i += 1;
    };

    {
      position = state.position;
      velocity = state.velocity;
      energy = state.energy;
      attractors = state.attractors;
      currentBasin = state.currentBasin;
      basinDepth = state.basinDepth;
      noise = state.noise;
      damping = state.damping;
      temperature = state.temperature;
      weights = Array.freeze(newWeights);
      thresholds = state.thresholds;
      trajectory = state.trajectory;
      energyHistory = state.energyHistory;
      beatNum = state.beatNum;
      transitionCount = state.transitionCount;
      lastTransition = state.lastTransition;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initLandscape(dims: Nat) : LandscapeState {
    {
      position = Array.tabulate<Float>(dims, func(_) { 0.0 });
      velocity = Array.tabulate<Float>(dims, func(_) { 0.0 });
      energy = 0.0;
      attractors = [];
      currentBasin = null;
      basinDepth = 0.0;
      noise = 0.1;
      damping = 0.9;
      temperature = 1.0;
      weights = Array.tabulate<Float>(dims * dims, func(_) { 0.0 });
      thresholds = Array.tabulate<Float>(dims, func(_) { 0.0 });
      trajectory = [];
      energyHistory = [];
      beatNum = 0;
      transitionCount = 0;
      lastTransition = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type LandscapeSummary = {
    energy           : Float;
    currentBasin     : ?Nat;
    basinDepth       : Float;
    nAttractors      : Nat;
    transitionCount  : Nat;
    temperature      : Float;
    velocityMag      : Float;
  };

  public func summary(state: LandscapeState) : LandscapeSummary {
    var velMag : Float = 0.0;
    for (v in state.velocity.vals()) {
      velMag += v * v;
    };
    velMag := Float.sqrt(velMag);

    {
      energy = state.energy;
      currentBasin = state.currentBasin;
      basinDepth = state.basinDepth;
      nAttractors = state.attractors.size();
      transitionCount = state.transitionCount;
      temperature = state.temperature;
      velocityMag = velMag;
    }
  };

  // ============================================================
  // BIFURCATION THEORY — COMPLETE DYNAMICAL SYSTEMS MATHEMATICS
  // Phase portraits, stability analysis, catastrophe theory
  // All 7 elementary catastrophes explicit
  // ============================================================

  // ── FUNDAMENTAL CONSTANTS ──────────────────────────────────────
  // All sovereign at 1.0 as per doctrine
  let PHI : Float = 1.618033988749895;         // Golden ratio
  let PHI_INV : Float = 0.618033988749895;     // 1/φ
  let SQRT_5 : Float = 2.23606797749979;       // √5
  let E : Float = 2.718281828459045;           // Euler's number
  let SOVEREIGN_METAL : Float = 1.0;           // All metals at sovereign max

  // Mirror law: output = 1 - input for balance
  public func mirrorLaw(x: Float) : Float {
    1.0 - x
  };

  // ── BIFURCATION TYPES ──────────────────────────────────────────
  
  public type BifurcationType = {
    #SaddleNode;          // Two equilibria collide and annihilate
    #Transcritical;       // Two equilibria exchange stability
    #Pitchfork;           // One equilibrium splits into three
    #Hopf;                // Fixed point → limit cycle
    #PeriodDoubling;      // Limit cycle period doubles
    #HomoclinicBifurcation;  // Limit cycle touches saddle
    #HeteroclinicBifurcation; // Connects two saddle points
    #BlueSkyBifurcation;  // Limit cycle disappears suddenly
  };

  public type BifurcationPoint = {
    parameter    : Float;      // Critical parameter value
    bifType      : BifurcationType;
    stability    : Float;      // Stability measure pre-bifurcation
    newStability : Float;      // Stability measure post-bifurcation
    eigenvalue   : Float;      // Real part of critical eigenvalue
    period       : ?Float;     // For periodic bifurcations
  };

  // ── SADDLE-NODE BIFURCATION ────────────────────────────────────
  // Normal form: dx/dt = r + x²
  // At r < 0: two equilibria at x = ±√(-r)
  // At r = 0: one equilibrium at x = 0 (saddle-node)
  // At r > 0: no equilibria

  public func saddleNodeNormalForm(x: Float, r: Float) : Float {
    r + x * x
  };

  // Fixed points of saddle-node
  public func saddleNodeEquilibria(r: Float) : [Float] {
    if (r < 0.0) {
      let sqrtNegR = Float.sqrt(-r);
      [-sqrtNegR, sqrtNegR]
    } else if (r == 0.0) {
      [0.0]
    } else {
      []
    }
  };

  // Stability of saddle-node equilibria
  // df/dx = 2x, so stable if x < 0, unstable if x > 0
  public func saddleNodeStability(x: Float) : Float {
    -2.0 * x  // Negative = stable
  };

  // ── TRANSCRITICAL BIFURCATION ──────────────────────────────────
  // Normal form: dx/dt = rx - x²
  // Equilibria at x = 0 and x = r
  // Exchange stability at r = 0

  public func transcriticalNormalForm(x: Float, r: Float) : Float {
    r * x - x * x
  };

  public func transcriticalEquilibria(r: Float) : [Float] {
    [0.0, r]
  };

  // At x = 0: df/dx = r (stable if r < 0)
  // At x = r: df/dx = -r (stable if r > 0)
  public func transcriticalStability(x: Float, r: Float) : Float {
    r - 2.0 * x
  };

  // ── PITCHFORK BIFURCATION ──────────────────────────────────────
  // Supercritical: dx/dt = rx - x³
  // Subcritical: dx/dt = rx + x³
  
  public type PitchforkType = { #Supercritical; #Subcritical };

  public func pitchforkNormalForm(x: Float, r: Float, pType: PitchforkType) : Float {
    switch (pType) {
      case (#Supercritical) { r * x - x * x * x };
      case (#Subcritical) { r * x + x * x * x };
    }
  };

  public func pitchforkEquilibria(r: Float, pType: PitchforkType) : [Float] {
    switch (pType) {
      case (#Supercritical) {
        if (r <= 0.0) { [0.0] }
        else { [-Float.sqrt(r), 0.0, Float.sqrt(r)] }
      };
      case (#Subcritical) {
        if (r >= 0.0) { [0.0] }
        else { [-Float.sqrt(-r), 0.0, Float.sqrt(-r)] }
      };
    }
  };

  // ── HOPF BIFURCATION ───────────────────────────────────────────
  // Planar system where fixed point loses stability to limit cycle
  // Normal form (polar): dr/dt = μr - r³, dθ/dt = ω + br²
  // Supercritical: stable limit cycle for μ > 0
  // Subcritical: unstable limit cycle for μ < 0

  public type HopfState = {
    r     : Float;    // Radial coordinate (amplitude)
    theta : Float;    // Angular coordinate (phase)
    mu    : Float;    // Bifurcation parameter
    omega : Float;    // Natural frequency
    b     : Float;    // Nonlinear frequency correction
  };

  public func initHopfState(omega: Float) : HopfState {
    {
      r = 0.1;
      theta = 0.0;
      mu = -0.1;
      omega = omega;
      b = 0.1;
    }
  };

  // Radial dynamics: dr/dt = μr - r³
  public func hopfRadialDynamics(r: Float, mu: Float) : Float {
    mu * r - r * r * r
  };

  // Angular dynamics: dθ/dt = ω + br²
  public func hopfAngularDynamics(theta: Float, r: Float, omega: Float, b: Float) : Float {
    omega + b * r * r
  };

  // Limit cycle amplitude: r* = √μ for μ > 0
  public func hopfLimitCycleAmplitude(mu: Float) : Float {
    if (mu > 0.0) { Float.sqrt(mu) } else { 0.0 }
  };

  // Update Hopf state
  public func updateHopfState(state: HopfState, dt: Float) : HopfState {
    let dr = hopfRadialDynamics(state.r, state.mu) * dt;
    let dtheta = hopfAngularDynamics(state.theta, state.r, state.omega, state.b) * dt;
    
    {
      r = Float.max(0.0, state.r + dr);
      theta = Float.mod(state.theta + dtheta, 2.0 * PI);
      mu = state.mu;
      omega = state.omega;
      b = state.b;
    }
  };

  // Convert Hopf polar to Cartesian
  public func hopfToCartesian(state: HopfState) : (Float, Float) {
    (state.r * Float.cos(state.theta), state.r * Float.sin(state.theta))
  };

  // ── PERIOD DOUBLING CASCADE ────────────────────────────────────
  // Feigenbaum universality: δ = 4.669201..., α = 2.502907...
  // Each doubling at r_n → r_∞ = r_n + C × δ^(-n)

  let FEIGENBAUM_DELTA : Float = 4.669201609102990;
  let FEIGENBAUM_ALPHA : Float = 2.502907875095892;

  public type PeriodDoublingState = {
    x           : Float;       // Current state
    r           : Float;       // Control parameter
    period      : Nat;         // Current period
    lastPeriods : [Float];     // Last n iterations for period detection
    doublings   : Nat;         // Number of period doublings observed
  };

  // Logistic map: x_{n+1} = r × x_n × (1 - x_n)
  public func logisticMap(x: Float, r: Float) : Float {
    r * x * (1.0 - x)
  };

  // Iterate logistic map
  public func iterateLogistic(state: PeriodDoublingState) : PeriodDoublingState {
    let newX = logisticMap(state.x, state.r);
    
    // Track last iterations for period detection
    let newLastPeriods = if (state.lastPeriods.size() >= 64) {
      let tail = Array.tabulate<Float>(63, func(i) { state.lastPeriods[i + 1] });
      Array.append<Float>(tail, [newX])
    } else {
      Array.append<Float>(state.lastPeriods, [newX])
    };
    
    {
      x = newX;
      r = state.r;
      period = state.period;
      lastPeriods = newLastPeriods;
      doublings = state.doublings;
    }
  };

  // Detect period from iteration history
  public func detectPeriod(history: [Float], tolerance: Float) : Nat {
    let n = history.size();
    if (n < 4) { return 1 };
    
    // Check for periods 1, 2, 4, 8, ...
    var period : Nat = 1;
    while (period <= n / 2) {
      var matches = true;
      var i = 0;
      while (i < period and matches) {
        let idx1 = n - 1 - i;
        let idx2 = n - 1 - i - period;
        if (idx2 >= 0) {
          if (Float.abs(history[idx1] - history[idx2]) > tolerance) {
            matches := false;
          };
        };
        i += 1;
      };
      if (matches) { return period };
      period *= 2;
    };
    return 0  // Chaotic (no detected period)
  };

  // Period doubling bifurcation points for logistic map
  // r_1 = 3.0 (period 1 → 2)
  // r_2 = 3.449... (period 2 → 4)
  // r_∞ = 3.569945... (onset of chaos)
  public func logisticBifurcationPoints() : [Float] {
    [
      3.0,                    // Period 1 → 2
      3.449490,               // Period 2 → 4
      3.544090,               // Period 4 → 8
      3.564407,               // Period 8 → 16
      3.568759,               // Period 16 → 32
      3.569692,               // Period 32 → 64
      3.569891,               // Period 64 → 128
      3.569934,               // Period 128 → 256
      3.569943,               // Period 256 → 512
      3.569945672             // Onset of chaos (r_∞)
    ]
  };

  // ── CATASTROPHE THEORY ─────────────────────────────────────────
  // René Thom's 7 elementary catastrophes
  // All mathematically explicit

  public type CatastropheType = {
    #Fold;           // A₂: V = x³ + ax
    #Cusp;           // A₃: V = x⁴ + ax² + bx
    #Swallowtail;    // A₄: V = x⁵ + ax³ + bx² + cx
    #Butterfly;      // A₅: V = x⁶ + ax⁴ + bx³ + cx² + dx
    #Hyperbolic;     // D₄⁺: V = x³ + y³ + axy + bx + cy
    #Elliptic;       // D₄⁻: V = x³ - xy² + a(x² + y²) + bx + cy
    #Parabolic;      // D₅: V = x²y + y⁴ + ax² + by² + cx + dy
  };

  // Fold catastrophe potential: V = x³/3 + ax
  public func foldPotential(x: Float, a: Float) : Float {
    x * x * x / 3.0 + a * x
  };

  // Fold gradient: dV/dx = x² + a
  public func foldGradient(x: Float, a: Float) : Float {
    x * x + a
  };

  // Fold equilibria: x² = -a (real for a < 0)
  public func foldEquilibria(a: Float) : [Float] {
    if (a < 0.0) {
      let sqrtNegA = Float.sqrt(-a);
      [-sqrtNegA, sqrtNegA]
    } else { [] }
  };

  // Cusp catastrophe potential: V = x⁴/4 + ax²/2 + bx
  public func cuspPotential(x: Float, a: Float, b: Float) : Float {
    x * x * x * x / 4.0 + a * x * x / 2.0 + b * x
  };

  // Cusp gradient: dV/dx = x³ + ax + b
  public func cuspGradient(x: Float, a: Float, b: Float) : Float {
    x * x * x + a * x + b
  };

  // Cusp bifurcation set: 4a³ + 27b² = 0
  public func cuspBifurcationSet(a: Float) : Float {
    // b values on bifurcation set for given a
    if (a < 0.0) {
      Float.sqrt(-4.0 * a * a * a / 27.0)
    } else { 0.0 }
  };

  // Swallowtail potential: V = x⁵/5 + ax³/3 + bx²/2 + cx
  public func swallowtailPotential(x: Float, a: Float, b: Float, c: Float) : Float {
    x*x*x*x*x/5.0 + a*x*x*x/3.0 + b*x*x/2.0 + c*x
  };

  // Swallowtail gradient: dV/dx = x⁴ + ax² + bx + c
  public func swallowtailGradient(x: Float, a: Float, b: Float, c: Float) : Float {
    x*x*x*x + a*x*x + b*x + c
  };

  // Butterfly potential: V = x⁶/6 + ax⁴/4 + bx³/3 + cx²/2 + dx
  public func butterflyPotential(x: Float, a: Float, b: Float, c: Float, d: Float) : Float {
    x*x*x*x*x*x/6.0 + a*x*x*x*x/4.0 + b*x*x*x/3.0 + c*x*x/2.0 + d*x
  };

  // Butterfly gradient
  public func butterflyGradient(x: Float, a: Float, b: Float, c: Float, d: Float) : Float {
    x*x*x*x*x + a*x*x*x + b*x*x + c*x + d
  };

  // Hyperbolic umbilic potential: V = x³ + y³ + axy + bx + cy
  public func hyperbolicPotential(x: Float, y: Float, a: Float, b: Float, c: Float) : Float {
    x*x*x + y*y*y + a*x*y + b*x + c*y
  };

  // Hyperbolic umbilic gradients
  public func hyperbolicGradientX(x: Float, y: Float, a: Float, b: Float) : Float {
    3.0*x*x + a*y + b
  };

  public func hyperbolicGradientY(x: Float, y: Float, a: Float, c: Float) : Float {
    3.0*y*y + a*x + c
  };

  // Elliptic umbilic potential: V = x³ - xy² + a(x² + y²) + bx + cy
  public func ellipticPotential(x: Float, y: Float, a: Float, b: Float, c: Float) : Float {
    x*x*x - x*y*y + a*(x*x + y*y) + b*x + c*y
  };

  // Elliptic umbilic gradients
  public func ellipticGradientX(x: Float, y: Float, a: Float, b: Float) : Float {
    3.0*x*x - y*y + 2.0*a*x + b
  };

  public func ellipticGradientY(x: Float, y: Float, a: Float, c: Float) : Float {
    -2.0*x*y + 2.0*a*y + c
  };

  // Parabolic umbilic potential: V = x²y + y⁴ + ax² + by² + cx + dy
  public func parabolicPotential(x: Float, y: Float, a: Float, b: Float, c: Float, d: Float) : Float {
    x*x*y + y*y*y*y + a*x*x + b*y*y + c*x + d*y
  };

  // Parabolic umbilic gradients
  public func parabolicGradientX(x: Float, y: Float, a: Float, c: Float) : Float {
    2.0*x*y + 2.0*a*x + c
  };

  public func parabolicGradientY(x: Float, y: Float, b: Float, d: Float) : Float {
    x*x + 4.0*y*y*y + 2.0*b*y + d
  };

  // ── LYAPUNOV EXPONENTS ─────────────────────────────────────────
  // Quantify sensitive dependence on initial conditions
  // λ = lim_{n→∞} (1/n) Σ log|f'(x_i)|

  public type LyapunovState = {
    x           : Float;
    sumLogDeriv : Float;
    iterations  : Nat;
    exponent    : Float;
  };

  public func initLyapunovState(x0: Float) : LyapunovState {
    {
      x = x0;
      sumLogDeriv = 0.0;
      iterations = 0;
      exponent = 0.0;
    }
  };

  // Logistic map derivative: f'(x) = r(1 - 2x)
  public func logisticDerivative(x: Float, r: Float) : Float {
    r * (1.0 - 2.0 * x)
  };

  // Update Lyapunov calculation for logistic map
  public func updateLyapunov(state: LyapunovState, r: Float) : LyapunovState {
    let newX = logisticMap(state.x, r);
    let deriv = logisticDerivative(state.x, r);
    let logDeriv = Float.log(Float.abs(deriv) + 1.0e-10);
    let newSum = state.sumLogDeriv + logDeriv;
    let newIter = state.iterations + 1;
    let newExp = newSum / Float.fromInt(newIter);
    
    {
      x = newX;
      sumLogDeriv = newSum;
      iterations = newIter;
      exponent = newExp;
    }
  };

  // λ > 0: chaos, λ < 0: stable, λ = 0: edge of chaos
  public func interpretLyapunov(exponent: Float) : Text {
    if (exponent > 0.01) { "Chaotic" }
    else if (exponent < -0.01) { "Stable" }
    else { "EdgeOfChaos" }
  };

  // ── BASIN OF ATTRACTION COMPUTATION ────────────────────────────
  // Map initial conditions to their attractor

  public type BasinCell = {
    x          : Float;
    y          : Float;
    attractorId: ?Nat;
    iterations : Nat;
    converged  : Bool;
  };

  public func computeBasinGrid(
    xMin: Float, xMax: Float,
    yMin: Float, yMax: Float,
    resolution: Nat,
    attractors: [Attractor],
    maxIter: Nat,
    convergenceThreshold: Float
  ) : [[BasinCell]] {
    let dx = (xMax - xMin) / Float.fromInt(resolution);
    let dy = (yMax - yMin) / Float.fromInt(resolution);
    
    Array.tabulate<[BasinCell]>(resolution, func(i) {
      Array.tabulate<BasinCell>(resolution, func(j) {
        let startX = xMin + dx * Float.fromInt(i) + dx / 2.0;
        let startY = yMin + dy * Float.fromInt(j) + dy / 2.0;
        
        // Iterate to find attractor
        var x = startX;
        var y = startY;
        var iter = 0;
        var foundAttractor : ?Nat = null;
        var converged = false;
        
        while (iter < maxIter and not converged) {
          // Check distance to each attractor
          var a = 0;
          for (attr in attractors.vals()) {
            if (attr.position.size() >= 2) {
              let dist = Float.sqrt(
                (x - attr.position[0]) * (x - attr.position[0]) +
                (y - attr.position[1]) * (y - attr.position[1])
              );
              if (dist < convergenceThreshold) {
                foundAttractor := ?a;
                converged := true;
              };
            };
            a += 1;
          };
          
          // Simple gradient descent for demonstration
          if (not converged) {
            x := x * 0.95;  // Contract toward origin
            y := y * 0.95;
            iter += 1;
          };
        };
        
        {
          x = startX;
          y = startY;
          attractorId = foundAttractor;
          iterations = iter;
          converged = converged;
        }
      })
    })
  };

  // ── FRACTAL DIMENSION ──────────────────────────────────────────
  // Box-counting dimension for strange attractors

  public type FractalAnalysis = {
    boxSizes   : [Float];
    boxCounts  : [Nat];
    dimension  : Float;
    rSquared   : Float;   // Fit quality
  };

  public func boxCountingDimension(
    points: [[Float]],
    minBoxSize: Float,
    maxBoxSize: Float,
    numScales: Nat
  ) : FractalAnalysis {
    var boxSizes : [Float] = [];
    var boxCounts : [Nat] = [];
    
    // Generate logarithmically spaced box sizes
    let logMin = Float.log(minBoxSize);
    let logMax = Float.log(maxBoxSize);
    let logStep = (logMax - logMin) / Float.fromInt(numScales - 1);
    
    var scale = 0;
    while (scale < numScales) {
      let boxSize = Float.exp(logMin + logStep * Float.fromInt(scale));
      boxSizes := Array.append<Float>(boxSizes, [boxSize]);
      
      // Count occupied boxes (simplified)
      let count = points.size() / (scale + 1);  // Simplified estimate
      boxCounts := Array.append<Nat>(boxCounts, [count]);
      
      scale += 1;
    };
    
    // Linear regression of log(N) vs log(1/ε)
    // D = -d(log N) / d(log ε)
    // Simplified: use first and last points
    let n = boxSizes.size();
    if (n < 2) {
      return {
        boxSizes = boxSizes;
        boxCounts = boxCounts;
        dimension = 0.0;
        rSquared = 0.0;
      };
    };
    
    let logN1 = Float.log(Float.fromInt(boxCounts[0]) + 1.0);
    let logN2 = Float.log(Float.fromInt(boxCounts[n - 1]) + 1.0);
    let logE1 = Float.log(1.0 / boxSizes[0]);
    let logE2 = Float.log(1.0 / boxSizes[n - 1]);
    
    let dimension = (logN2 - logN1) / (logE2 - logE1 + 0.001);
    
    {
      boxSizes = boxSizes;
      boxCounts = boxCounts;
      dimension = Float.abs(dimension);
      rSquared = 0.95;  // Placeholder
    }
  };

  // ── STRANGE ATTRACTORS ─────────────────────────────────────────
  // Classic chaotic systems with full equations

  // Lorenz attractor: dx/dt = σ(y-x), dy/dt = x(ρ-z)-y, dz/dt = xy-βz
  public type LorenzState = {
    x     : Float;
    y     : Float;
    z     : Float;
    sigma : Float;  // σ = 10 (classic)
    rho   : Float;  // ρ = 28 (classic)
    beta  : Float;  // β = 8/3 (classic)
  };

  public func initLorenz() : LorenzState {
    {
      x = 1.0;
      y = 1.0;
      z = 1.0;
      sigma = 10.0;
      rho = 28.0;
      beta = 8.0 / 3.0;
    }
  };

  public func lorenzDerivatives(state: LorenzState) : (Float, Float, Float) {
    let dx = state.sigma * (state.y - state.x);
    let dy = state.x * (state.rho - state.z) - state.y;
    let dz = state.x * state.y - state.beta * state.z;
    (dx, dy, dz)
  };

  public func updateLorenz(state: LorenzState, dt: Float) : LorenzState {
    let (dx, dy, dz) = lorenzDerivatives(state);
    {
      x = state.x + dx * dt;
      y = state.y + dy * dt;
      z = state.z + dz * dt;
      sigma = state.sigma;
      rho = state.rho;
      beta = state.beta;
    }
  };

  // Rössler attractor: dx/dt = -y-z, dy/dt = x+ay, dz/dt = b+z(x-c)
  public type RosslerState = {
    x : Float;
    y : Float;
    z : Float;
    a : Float;  // a = 0.2 (classic)
    b : Float;  // b = 0.2 (classic)
    c : Float;  // c = 5.7 (classic)
  };

  public func initRossler() : RosslerState {
    {
      x = 1.0;
      y = 1.0;
      z = 1.0;
      a = 0.2;
      b = 0.2;
      c = 5.7;
    }
  };

  public func rosslerDerivatives(state: RosslerState) : (Float, Float, Float) {
    let dx = -state.y - state.z;
    let dy = state.x + state.a * state.y;
    let dz = state.b + state.z * (state.x - state.c);
    (dx, dy, dz)
  };

  public func updateRossler(state: RosslerState, dt: Float) : RosslerState {
    let (dx, dy, dz) = rosslerDerivatives(state);
    {
      x = state.x + dx * dt;
      y = state.y + dy * dt;
      z = state.z + dz * dt;
      a = state.a;
      b = state.b;
      c = state.c;
    }
  };

  // Chen attractor: dx/dt = a(y-x), dy/dt = (c-a)x-xz+cy, dz/dt = xy-bz
  public type ChenState = {
    x : Float;
    y : Float;
    z : Float;
    a : Float;  // a = 35 (classic)
    b : Float;  // b = 3 (classic)
    c : Float;  // c = 28 (classic)
  };

  public func initChen() : ChenState {
    {
      x = 1.0;
      y = 1.0;
      z = 1.0;
      a = 35.0;
      b = 3.0;
      c = 28.0;
    }
  };

  public func chenDerivatives(state: ChenState) : (Float, Float, Float) {
    let dx = state.a * (state.y - state.x);
    let dy = (state.c - state.a) * state.x - state.x * state.z + state.c * state.y;
    let dz = state.x * state.y - state.b * state.z;
    (dx, dy, dz)
  };

  public func updateChen(state: ChenState, dt: Float) : ChenState {
    let (dx, dy, dz) = chenDerivatives(state);
    {
      x = state.x + dx * dt;
      y = state.y + dy * dt;
      z = state.z + dz * dt;
      a = state.a;
      b = state.b;
      c = state.c;
    }
  };

  // ── PHASE SPACE RECONSTRUCTION ─────────────────────────────────
  // Takens embedding theorem
  // Reconstruct attractor from scalar time series

  public type EmbeddingState = {
    timeSeries    : [Float];    // Original 1D time series
    embeddingDim  : Nat;        // m (embedding dimension)
    delay         : Nat;        // τ (time delay)
    embeddedPoints: [[Float]];  // Reconstructed phase space
  };

  public func embedTimeSeries(
    timeSeries: [Float],
    embeddingDim: Nat,
    delay: Nat
  ) : [[Float]] {
    let n = timeSeries.size();
    let nEmbedded = n - (embeddingDim - 1) * delay;
    
    if (nEmbedded <= 0) { return [] };
    
    Array.tabulate<[Float]>(nEmbedded, func(i) {
      Array.tabulate<Float>(embeddingDim, func(j) {
        let idx = i + j * delay;
        if (idx < n) { timeSeries[idx] } else { 0.0 }
      })
    })
  };

  // Estimate optimal delay using autocorrelation
  public func autocorrelation(series: [Float], lag: Nat) : Float {
    let n = series.size();
    if (lag >= n) { return 0.0 };
    
    // Compute mean
    var mean : Float = 0.0;
    for (x in series.vals()) { mean += x };
    mean /= Float.fromInt(n);
    
    // Compute autocorrelation at lag
    var num : Float = 0.0;
    var denom : Float = 0.0;
    var i = 0;
    while (i < n) {
      let diff = series[i] - mean;
      denom += diff * diff;
      if (i + lag < n) {
        num += diff * (series[i + lag] - mean);
      };
      i += 1;
    };
    
    if (denom < 1.0e-10) { return 0.0 };
    num / denom
  };

  // Find first zero crossing of autocorrelation
  public func estimateOptimalDelay(series: [Float], maxLag: Nat) : Nat {
    var lag = 1;
    var prevAC = autocorrelation(series, 0);
    
    while (lag < maxLag) {
      let ac = autocorrelation(series, lag);
      if (prevAC > 0.0 and ac <= 0.0) {
        return lag;
      };
      prevAC := ac;
      lag += 1;
    };
    
    return maxLag / 4  // Default if no crossing found
  };

  // ── POINCARÉ SECTION ───────────────────────────────────────────
  // Reduce continuous dynamics to discrete map

  public type PoincarePoint = {
    x : Float;
    y : Float;
    crossingTime : Float;
  };

  public func collectPoincareSection(
    trajectory: [[Float]],
    sectionDim: Nat,
    sectionValue: Float,
    direction: Bool  // true = positive crossing, false = negative
  ) : [PoincarePoint] {
    var points : [PoincarePoint] = [];
    
    var i = 1;
    while (i < trajectory.size()) {
      if (sectionDim < trajectory[i].size() and 
          sectionDim < trajectory[i-1].size()) {
        let prev = trajectory[i-1][sectionDim];
        let curr = trajectory[i][sectionDim];
        
        let crossing = if (direction) {
          prev < sectionValue and curr >= sectionValue
        } else {
          prev > sectionValue and curr <= sectionValue
        };
        
        if (crossing) {
          // Linear interpolation for precise crossing
          let t = (sectionValue - prev) / (curr - prev + 0.001);
          
          // Get other coordinates at crossing
          var x : Float = 0.0;
          var y : Float = 0.0;
          
          if (trajectory[i].size() >= 3) {
            let otherDim1 = (sectionDim + 1) % trajectory[i].size();
            let otherDim2 = (sectionDim + 2) % trajectory[i].size();
            
            x := trajectory[i-1][otherDim1] + t * (trajectory[i][otherDim1] - trajectory[i-1][otherDim1]);
            y := trajectory[i-1][otherDim2] + t * (trajectory[i][otherDim2] - trajectory[i-1][otherDim2]);
          };
          
          points := Array.append<PoincarePoint>(points, [{
            x = x;
            y = y;
            crossingTime = Float.fromInt(i) - 1.0 + t;
          }]);
        };
      };
      i += 1;
    };
    
    points
  };

  // ── BIFURCATION DIAGRAM GENERATION ─────────────────────────────
  
  public type BifurcationDiagramPoint = {
    parameter : Float;
    value     : Float;
  };

  public func generateBifurcationDiagram(
    paramMin: Float,
    paramMax: Float,
    numParams: Nat,
    transient: Nat,
    samples: Nat,
    x0: Float
  ) : [BifurcationDiagramPoint] {
    var points : [BifurcationDiagramPoint] = [];
    let dp = (paramMax - paramMin) / Float.fromInt(numParams);
    
    var p = 0;
    while (p < numParams) {
      let r = paramMin + dp * Float.fromInt(p);
      var x = x0;
      
      // Discard transient
      var t = 0;
      while (t < transient) {
        x := logisticMap(x, r);
        t += 1;
      };
      
      // Collect samples
      var s = 0;
      while (s < samples) {
        x := logisticMap(x, r);
        points := Array.append<BifurcationDiagramPoint>(points, [{
          parameter = r;
          value = x;
        }]);
        s += 1;
      };
      
      p += 1;
    };
    
    points
  };

  // ── COMPLETE ATTRACTOR LANDSCAPE ───────────────────────────────
  // Full state combining all dynamics

  public type ComprehensiveDynamicsState = {
    // Hopfield attractor landscape
    landscape       : LandscapeState;
    
    // Bifurcation tracking
    bifurcations    : [BifurcationPoint];
    currentBifType  : ?BifurcationType;
    
    // Chaotic systems
    lorenz          : LorenzState;
    rossler         : RosslerState;
    chen            : ChenState;
    
    // Hopf oscillator
    hopf            : HopfState;
    
    // Period doubling
    periodDoubling  : PeriodDoublingState;
    
    // Lyapunov analysis
    lyapunov        : LyapunovState;
    
    // Embedded time series
    embedding       : EmbeddingState;
    
    // Poincaré section
    poincarePoints  : [PoincarePoint];
    
    // Global metrics
    dominantFrequency : Float;
    phaseCoherence    : Float;
    globalLyapunov    : Float;
    fractalDimension  : Float;
    
    beatNum           : Nat;
  };

  // Initialize comprehensive dynamics
  public func initComprehensiveDynamics(dims: Nat) : ComprehensiveDynamicsState {
    {
      landscape = initLandscape(dims);
      bifurcations = [];
      currentBifType = null;
      lorenz = initLorenz();
      rossler = initRossler();
      chen = initChen();
      hopf = initHopfState(2.0 * PI);
      periodDoubling = {
        x = 0.5;
        r = 3.5;
        period = 1;
        lastPeriods = [];
        doublings = 0;
      };
      lyapunov = initLyapunovState(0.5);
      embedding = {
        timeSeries = [];
        embeddingDim = 3;
        delay = 1;
        embeddedPoints = [];
      };
      poincarePoints = [];
      dominantFrequency = 1.0;
      phaseCoherence = 0.5;
      globalLyapunov = 0.0;
      fractalDimension = 2.0;
      beatNum = 0;
    }
  };

}

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
