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

}
