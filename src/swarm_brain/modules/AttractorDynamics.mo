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
  let PHI : Float = 1.6180339887498948;
  let PHI_INV : Float = 0.6180339887498948;

  // ══════════════════════════════════════════════════════════════════════════
  // 444 SACRED COGNITIVE GEOMETRY — 4×4×4 = 64 ATTRACTOR BASINS
  // ══════════════════════════════════════════════════════════════════════════
  //
  // 444 = The Builder's Number in angel numerology = foundation + structure
  // 4 × 4 × 4 = 64 = 2^6 = perfect power of 2 = cognitive cell count
  //
  // DIMENSION 1: 4 DOMAINS (what aspect of reality)
  //   0 = SELF (internal state, coherence, health)
  //   1 = MARKET (external financial state)
  //   2 = SOCIAL (relationships, trust, network)
  //   3 = TEMPORAL (time, urgency, deadlines)
  //
  // DIMENSION 2: 4 STATES (cognitive mode)
  //   0 = SCANNING (exploration, opportunity detection)
  //   1 = FOCUSING (attention narrowing, analysis)
  //   2 = EXECUTING (action, trade execution)
  //   3 = CONSOLIDATING (learning, memory formation)
  //
  // DIMENSION 3: 4 FORCES (motivational vector)
  //   0 = FEAR (loss aversion, risk avoidance)
  //   1 = GREED (gain seeking, opportunity pursuit)
  //   2 = HOPE (future projection, positive expectation)
  //   3 = DISCIPLINE (rule following, process adherence)
  //
  // Each combination (d, s, f) = one of 64 attractor basins
  // The organism navigates this 64-cell cognitive landscape
  // ══════════════════════════════════════════════════════════════════════════

  public type CognitiveDomain = {
    #Self;
    #Market;
    #Social;
    #Temporal;
  };

  public type CognitiveState = {
    #Scanning;
    #Focusing;
    #Executing;
    #Consolidating;
  };

  public type CognitiveForce = {
    #Fear;
    #Greed;
    #Hope;
    #Discipline;
  };

  // 444 Cell = one attractor basin in 64-cell landscape
  public type Cell444 = {
    domain      : CognitiveDomain;
    state       : CognitiveState;
    force       : CognitiveForce;
    cellIndex   : Nat;              // 0-63
    position    : [Float];          // 4D position in state space
    strength    : Float;            // Basin depth
    stability   : Float;            // How stable is this cell
    resonance   : Float;            // φ-resonance with neighboring cells
    visits      : Nat;              // How often organism visits this cell
    lastVisit   : Nat;              // Beat of last visit
  };

  // Full 444 landscape
  public type Landscape444 = {
    cells           : [Cell444];    // 64 cells
    currentCell     : Nat;          // Which cell is organism in (0-63)
    transitionMatrix: [Float];      // 64×64 = 4096 transition probabilities
    cellEnergies    : [Float];      // Energy at each cell
    sacredAlignment : Float;        // How aligned is landscape with φ-ratios
    coherenceByCell : [Float];      // Coherence contribution per cell
  };

  // Get cell index from domain, state, force
  public func cell444Index(domain: Nat, state: Nat, force: Nat) : Nat {
    // Index = domain * 16 + state * 4 + force
    // This gives 0-63 for all combinations
    domain * 16 + state * 4 + force
  };

  // Decode cell index back to domain, state, force
  public func cell444Decode(index: Nat) : (Nat, Nat, Nat) {
    let domain = index / 16;
    let remainder = index % 16;
    let state = remainder / 4;
    let force = remainder % 4;
    (domain, state, force)
  };

  // Create position in 4D state space from domain/state/force
  // Uses φ-based coordinates for sacred geometry alignment
  func cell444Position(domain: Nat, state: Nat, force: Nat) : [Float] {
    // Each dimension maps to [0, φ] range
    // Position = (domain/3 × φ, state/3 × φ, force/3 × φ, alignment)
    let d = Float.fromInt(domain) / 3.0 * PHI;
    let s = Float.fromInt(state) / 3.0 * PHI;
    let f = Float.fromInt(force) / 3.0 * PHI;
    // 4th dimension = φ-alignment (golden ratio of first 3)
    let alignment = (d + s * PHI_INV + f * PHI_INV * PHI_INV) / 3.0;
    [d, s, f, alignment]
  };

  // Calculate cell strength (basin depth) based on sacred geometry
  // Cells at φ-proportional positions have deeper basins
  func cell444Strength(domain: Nat, state: Nat, force: Nat) : Float {
    // Strength peaks at φ-proportional combinations
    // (1, 2, 3) ≈ φ ratios, so cells near these have higher strength
    let idealD = 1.0;  // φ^0
    let idealS = 2.0;  // near φ
    let idealF = 3.0;  // near φ²
    
    let devD = Float.abs(Float.fromInt(domain) - idealD) / 3.0;
    let devS = Float.abs(Float.fromInt(state) - idealS) / 3.0;
    let devF = Float.abs(Float.fromInt(force) - idealF) / 3.0;
    
    // Strength = 1 - deviation from ideal
    let deviation = (devD + devS + devF) / 3.0;
    _clamp(1.0 - deviation * 0.5, 0.3, 1.0)
  };

  // Calculate φ-resonance between two cells
  func cell444Resonance(cell1: Nat, cell2: Nat) : Float {
    let (d1, s1, f1) = cell444Decode(cell1);
    let (d2, s2, f2) = cell444Decode(cell2);
    
    // Resonance is high when cells differ by φ-proportional amounts
    // Adjacent cells (diff = 1) have resonance φ^(-1) = 0.618
    // Same cell has resonance 1.0
    // Opposite cells (diff = 3) have resonance φ^(-3) = 0.236
    
    let diffD = Float.abs(Float.fromInt(d1) - Float.fromInt(d2));
    let diffS = Float.abs(Float.fromInt(s1) - Float.fromInt(s2));
    let diffF = Float.abs(Float.fromInt(f1) - Float.fromInt(f2));
    
    let totalDiff = diffD + diffS + diffF;
    if (totalDiff < 0.001) { return 1.0 };  // Same cell
    
    // φ^(-totalDiff) for sacred resonance
    Float.pow(PHI_INV, totalDiff)
  };

  // Initialize 64-cell 444 landscape
  public func init444Landscape() : Landscape444 {
    var cells : [Cell444] = [];
    var energies : [Float] = [];
    var coherences : [Float] = [];
    
    // Create all 64 cells
    var idx : Nat = 0;
    var d = 0;
    while (d < 4) {
      var s = 0;
      while (s < 4) {
        var f = 0;
        while (f < 4) {
          let cell : Cell444 = {
            domain = switch (d) {
              case (0) { #Self };
              case (1) { #Market };
              case (2) { #Social };
              case (_) { #Temporal };
            };
            state = switch (s) {
              case (0) { #Scanning };
              case (1) { #Focusing };
              case (2) { #Executing };
              case (_) { #Consolidating };
            };
            force = switch (f) {
              case (0) { #Fear };
              case (1) { #Greed };
              case (2) { #Hope };
              case (_) { #Discipline };
            };
            cellIndex = idx;
            position = cell444Position(d, s, f);
            strength = cell444Strength(d, s, f);
            stability = 0.5;
            resonance = 1.0;
            visits = 0;
            lastVisit = 0;
          };
          cells := Array.append(cells, [cell]);
          energies := Array.append(energies, [0.0]);
          coherences := Array.append(coherences, [0.0]);
          idx += 1;
          f += 1;
        };
        s += 1;
      };
      d += 1;
    };
    
    // Build 64×64 transition matrix (initialized to uniform)
    let transitionMatrix = Array.tabulate<Float>(64 * 64, func(i) {
      let from = i / 64;
      let to = i % 64;
      cell444Resonance(from, to) / 64.0  // Normalized resonance
    });
    
    // Calculate sacred alignment (how φ-aligned is the whole landscape)
    var totalResonance : Float = 0.0;
    var pairs : Nat = 0;
    var i = 0;
    while (i < 64) {
      var j = i + 1;
      while (j < 64) {
        totalResonance += cell444Resonance(i, j);
        pairs += 1;
        j += 1;
      };
      i += 1;
    };
    let sacredAlign = totalResonance / Float.fromInt(pairs);
    
    {
      cells = cells;
      currentCell = 0;
      transitionMatrix = transitionMatrix;
      cellEnergies = energies;
      sacredAlignment = sacredAlign;
      coherenceByCell = coherences;
    }
  };

  // Determine which 444 cell organism should be in based on current state
  public func determine444Cell(
    selfCoherence: Float,       // Internal coherence
    marketVolatility: Float,    // External market state
    socialTrust: Float,         // Network state
    temporalUrgency: Float,     // Time pressure
    fearLevel: Float,           // From FearArchitecture
    greedLevel: Float,          // From reward signals
    hopeLevel: Float,           // From prediction confidence
    disciplineLevel: Float      // From law compliance
  ) : Nat {
    // Determine domain (which aspect dominates attention)
    let domains = [selfCoherence, marketVolatility, socialTrust, temporalUrgency];
    var maxDomain : Nat = 0;
    var maxDomainVal : Float = domains[0];
    var d = 1;
    while (d < 4) {
      if (domains[d] > maxDomainVal) {
        maxDomainVal := domains[d];
        maxDomain := d;
      };
      d += 1;
    };
    
    // Determine state (cognitive mode)
    // Scanning: low focus, exploring
    // Focusing: high attention, analyzing
    // Executing: taking action
    // Consolidating: learning, resting
    let state = if (selfCoherence < 0.4) {
      0  // Scanning (low coherence = exploring)
    } else if (fearLevel > 0.6 or greedLevel > 0.6) {
      2  // Executing (high emotion = action)
    } else if (disciplineLevel > 0.7) {
      3  // Consolidating (high discipline = learning)
    } else {
      1  // Focusing (default analytical mode)
    };
    
    // Determine force (dominant motivation)
    let forces = [fearLevel, greedLevel, hopeLevel, disciplineLevel];
    var maxForce : Nat = 0;
    var maxForceVal : Float = forces[0];
    var f = 1;
    while (f < 4) {
      if (forces[f] > maxForceVal) {
        maxForceVal := forces[f];
        maxForce := f;
      };
      f += 1;
    };
    
    cell444Index(maxDomain, state, maxForce)
  };

  // Update 444 landscape based on organism state
  public func tick444Landscape(
    landscape: Landscape444,
    newCell: Nat,
    beat: Nat
  ) : Landscape444 {
    // Update current cell
    var updatedCells = Array.tabulate<Cell444>(64, func(i) {
      if (i == newCell) {
        {
          domain = landscape.cells[i].domain;
          state = landscape.cells[i].state;
          force = landscape.cells[i].force;
          cellIndex = i;
          position = landscape.cells[i].position;
          strength = landscape.cells[i].strength;
          stability = _clamp(landscape.cells[i].stability + 0.01, 0.0, 1.0);
          resonance = landscape.cells[i].resonance;
          visits = landscape.cells[i].visits + 1;
          lastVisit = beat;
        }
      } else {
        // Decay stability of unvisited cells
        {
          domain = landscape.cells[i].domain;
          state = landscape.cells[i].state;
          force = landscape.cells[i].force;
          cellIndex = i;
          position = landscape.cells[i].position;
          strength = landscape.cells[i].strength;
          stability = _clamp(landscape.cells[i].stability - 0.001, 0.1, 1.0);
          resonance = landscape.cells[i].resonance;
          visits = landscape.cells[i].visits;
          lastVisit = landscape.cells[i].lastVisit;
        }
      }
    });
    
    // Update transition probabilities (Hebbian: strengthen used transitions)
    let oldCell = landscape.currentCell;
    var updatedTransitions = Array.thaw<Float>(landscape.transitionMatrix);
    let transIdx = oldCell * 64 + newCell;
    if (transIdx < updatedTransitions.size()) {
      updatedTransitions[transIdx] += 0.01;  // Strengthen used transition
    };
    
    {
      cells = updatedCells;
      currentCell = newCell;
      transitionMatrix = Array.freeze(updatedTransitions);
      cellEnergies = landscape.cellEnergies;
      sacredAlignment = landscape.sacredAlignment;
      coherenceByCell = landscape.coherenceByCell;
    }
  };

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


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  A D V A N C E D   M A T H E M A T I C A L   E X P A N S I O N
  //
  //  Enterprise-Level Neural Mathematics and Cognitive Dynamics
  //  Full Dual-Organism Coupling: HIM ↔ HER
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED KURAMOTO PHASE DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Kuramoto order parameter: r = |1/N Σⱼ eⁱθʲ|
  public func advancedKuramotoOrderParameter(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += Float.cos(phases[i]);
      sumSin += Float.sin(phases[i]);
      i += 1;
    };
    let nf = Float.fromInt(n);
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  /// Kuramoto phase update: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
  public func advancedKuramotoPhaseUpdate(
    phase : Float,
    omega : Float,
    k : Float,
    allPhases : [Float],
    dt : Float
  ) : Float {
    let n = allPhases.size();
    if (n == 0) { return phase };
    var coupling : Float = 0.0;
    var i = 0;
    while (i < n) {
      coupling += Float.sin(allPhases[i] - phase);
      i += 1;
    };
    let dTheta = omega + (k / Float.fromInt(n)) * coupling;
    let newPhase = phase + dTheta * dt;
    let TWO_PI = 6.28318530717958647692;
    if (newPhase >= TWO_PI) { newPhase - TWO_PI }
    else if (newPhase < 0.0) { newPhase + TWO_PI }
    else { newPhase }
  };

  /// Critical coupling K_c for synchronization
  public func advancedCriticalCoupling(omegaSpread : Float) : Float {
    2.0 * omegaSpread / 3.14159265358979323846
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED HEBBIAN PLASTICITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Basic Hebbian: Δw = η × pre × post
  public func advancedHebbianBasic(weight : Float, pre : Float, post : Float, eta : Float) : Float {
    let delta = eta * pre * post;
    let newWeight = weight + delta;
    if (newWeight > 5.0) { 5.0 } else if (newWeight < -5.0) { -5.0 } else { newWeight }
  };

  /// Oja's rule: Δw = α(y·x - y²·w)
  public func advancedOjaRule(weight : Float, pre : Float, post : Float, alpha : Float) : Float {
    let delta = alpha * (post * pre - post * post * weight);
    weight + delta
  };

  /// BCM sliding threshold: θ_M = E[post²]
  public func advancedBCMThreshold(activityHistory : [Float]) : Float {
    if (activityHistory.size() == 0) { return 0.5 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < activityHistory.size()) {
      sum += activityHistory[i] * activityHistory[i];
      i += 1;
    };
    sum / Float.fromInt(activityHistory.size())
  };

  /// BCM update: Δw = η × pre × post × (post - θ_M)
  public func advancedBCMUpdate(weight : Float, pre : Float, post : Float, threshold : Float, eta : Float) : Float {
    let delta = eta * pre * post * (post - threshold);
    weight + delta
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LYAPUNOV STABILITY ANALYSIS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Estimate Lyapunov exponent from time series
  public func advancedLyapunovExponent(timeSeries : [Float], embeddingDim : Nat, delay : Nat) : Float {
    let n = timeSeries.size();
    if (n < embeddingDim * delay + 10) { return 0.0 };
    var sumLog : Float = 0.0;
    var count = 0;
    var i = 0;
    while (i < n - embeddingDim * delay - 1) {
      let j = i + 1;
      var d0 : Float = 0.0;
      var k = 0;
      while (k < embeddingDim) {
        let diff = timeSeries[i + k * delay] - timeSeries[j + k * delay];
        d0 += diff * diff;
        k += 1;
      };
      d0 := Float.sqrt(d0);
      if (d0 > 0.0001) {
        var d1 : Float = 0.0;
        k := 0;
        while (k < embeddingDim) {
          let iNext = i + 1 + k * delay;
          let jNext = j + 1 + k * delay;
          if (iNext < n and jNext < n) {
            let diff = timeSeries[iNext] - timeSeries[jNext];
            d1 += diff * diff;
          };
          k += 1;
        };
        d1 := Float.sqrt(d1);
        if (d1 > 0.0001) {
          sumLog += Float.log(d1 / d0);
          count += 1;
        };
      };
      i += 1;
    };
    if (count == 0) { 0.0 } else { sumLog / Float.fromInt(count) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INFORMATION THEORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Shannon entropy H = -Σ pᵢ log(pᵢ)
  public func advancedEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    var i = 0;
    while (i < probs.size()) {
      let p = probs[i];
      if (p > 0.0001) { h -= p * Float.log(p) };
      i += 1;
    };
    h
  };

  /// Transfer entropy approximation
  public func advancedTransferEntropy(x : [Float], y : [Float], lag : Nat) : Float {
    let n = if (x.size() < y.size()) x.size() else y.size();
    if (n <= lag + 1) { return 0.0 };
    var correlation : Float = 0.0;
    var i = lag;
    while (i < n) {
      let xPast = x[i - lag];
      let yNow = y[i];
      correlation += xPast * yNow;
      i += 1;
    };
    Float.abs(correlation / Float.fromInt(n - lag))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // FREE ENERGY PRINCIPLE (FRISTON)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Free energy: F = D_KL(q||p) - log p(o)
  public func advancedFreeEnergy(predictionError : Float, complexity : Float) : Float {
    predictionError * predictionError + complexity
  };

  /// Precision-weighted prediction error
  public func advancedPrecisionWeightedError(prediction : Float, observation : Float, precision : Float) : Float {
    let error = observation - prediction;
    precision * error * error
  };

  /// Bayesian belief update
  public func advancedBayesianUpdate(prior : Float, likelihood : Float) : Float {
    let posterior = prior * likelihood;
    if (posterior > 1.0) { 1.0 } else if (posterior < 0.0) { 0.0 } else { posterior }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTRACTOR DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Point attractor: dx/dt = -α(x - x*)
  public func advancedPointAttractor(x : Float, xStar : Float, alpha : Float, dt : Float) : Float {
    x + (-alpha * (x - xStar)) * dt
  };

  /// Limit cycle: using Van der Pol oscillator
  public func advancedLimitCycle(x : Float, y : Float, mu : Float, dt : Float) : (Float, Float) {
    let dxdt = y;
    let dydt = mu * (1.0 - x * x) * y - x;
    (x + dxdt * dt, y + dydt * dt)
  };

  /// Chaotic attractor: Lorenz system
  public func advancedLorenzAttractor(x : Float, y : Float, z : Float, sigma : Float, rho : Float, beta : Float, dt : Float) : (Float, Float, Float) {
    let dxdt = sigma * (y - x);
    let dydt = x * (rho - z) - y;
    let dzdt = x * y - beta * z;
    (x + dxdt * dt, y + dydt * dt, z + dzdt * dt)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NEURAL OSCILLATION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wilson-Cowan neural mass model
  public func advancedWilsonCowan(e : Float, inh : Float, c1 : Float, c2 : Float, c3 : Float, c4 : Float, p : Float, q : Float, dt : Float) : (Float, Float) {
    func sigmoid(x : Float) : Float { 1.0 / (1.0 + Float.exp(-x)) };
    let dEdt = -e + sigmoid(c1 * e - c2 * inh + p);
    let dIdt = -inh + sigmoid(c3 * e - c4 * inh + q);
    (e + dEdt * dt, inh + dIdt * dt)
  };

  /// Izhikevich neuron model
  public func advancedIzhikevichNeuron(v : Float, u : Float, input : Float, a : Float, b : Float, dt : Float) : (Float, Float, Bool) {
    var fired = false;
    var newV = v;
    var newU = u;
    if (v >= 30.0) {
      newV := -65.0;
      newU := u + 8.0;
      fired := true;
    } else {
      let dvdt = 0.04 * v * v + 5.0 * v + 140.0 - u + input;
      let dudt = a * (b * v - u);
      newV := v + dvdt * dt;
      newU := u + dudt * dt;
    };
    (newV, newU, fired)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VECTOR AND MATRIX OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Dot product
  public func advancedDotProduct(v1 : [Float], v2 : [Float]) : Float {
    let n = if (v1.size() < v2.size()) v1.size() else v2.size();
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) { sum += v1[i] * v2[i]; i += 1 };
    sum
  };

  /// Vector magnitude
  public func advancedVectorMagnitude(v : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < v.size()) { sum += v[i] * v[i]; i += 1 };
    Float.sqrt(sum)
  };

  /// Cosine similarity
  public func advancedCosineSimilarity(v1 : [Float], v2 : [Float]) : Float {
    let dot = advancedDotProduct(v1, v2);
    let mag1 = advancedVectorMagnitude(v1);
    let mag2 = advancedVectorMagnitude(v2);
    if (mag1 < 0.0001 or mag2 < 0.0001) { 0.0 } else { dot / (mag1 * mag2) }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ║                                                                             ║
  // ║  ATTRACTOR DYNAMICS — EXTENDED ORGANISM ARCHITECTURE                        ║
  // ║  Full Energy Landscape Integration with All Organism Subsystems             ║
  // ║                                                                             ║
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─── ORGANISM ATTRACTOR LANDSCAPE ─────────────────────────────────────────────
  
  /// Extended state for full organism integration
  public type OrganismAttractorState = {
    // Core attractor dynamics
    coreState : AttractorState;
    
    // Multi-scale attractors
    cellularAttractors : [Attractor];
    organAttractors : [Attractor];
    systemAttractors : [Attractor];
    organismAttractors : [Attractor];
    
    // Energy landscape metrics
    totalPotentialEnergy : Float;
    kineticEnergy : Float;
    freeEnergy : Float;
    entropyProduction : Float;
    
    // Basin of attraction properties
    basinVolumes : [Float];
    basinDepths : [Float];
    basinStabilities : [Float];
    transitionProbabilities : [[Float]];
    
    // Bifurcation tracking
    bifurcationParameter : Float;
    nearBifurcation : Bool;
    bifurcationType : Text;
    criticalSlowing : Float;
    
    // Multistability
    activeAttractorIndex : Nat;
    attractorOccupancies : [Float];
    switchingRate : Float;
    dwellTimes : [Float];
    
    // Chaotic dynamics
    lyapunovExponent : Float;
    correlationDimension : Float;
    kaplanYorkeD : Float;
    isChaoticRegime : Bool;
  };

  /// Initialize organism attractor state
  public func initOrganismAttractor() : OrganismAttractorState {
    let defaultAttrs : [Attractor] = [];
    {
      coreState = defaultState();
      cellularAttractors = defaultAttrs;
      organAttractors = defaultAttrs;
      systemAttractors = defaultAttrs;
      organismAttractors = defaultAttrs;
      totalPotentialEnergy = 0.0;
      kineticEnergy = 0.0;
      freeEnergy = 0.0;
      entropyProduction = 0.0;
      basinVolumes = [];
      basinDepths = [];
      basinStabilities = [];
      transitionProbabilities = [];
      bifurcationParameter = 0.0;
      nearBifurcation = false;
      bifurcationType = "none";
      criticalSlowing = 0.0;
      activeAttractorIndex = 0;
      attractorOccupancies = [];
      switchingRate = 0.0;
      dwellTimes = [];
      lyapunovExponent = 0.0;
      correlationDimension = 0.0;
      kaplanYorkeD = 0.0;
      isChaoticRegime = false;
    }
  };

  // ─── HOPFIELD NETWORK DYNAMICS ────────────────────────────────────────────────
  
  /// Hopfield network state
  public type HopfieldState = {
    neurons : [Float];
    weights : [[Float]];
    patterns : [[Float]];
    energy : Float;
    temperature : Float;
    numPatterns : Nat;
    capacity : Float;
  };

  /// Initialize Hopfield network
  public func initHopfield(numNeurons : Nat, patterns : [[Float]]) : HopfieldState {
    // Compute Hebbian weights from patterns
    var weights : [[Float]] = [];
    var i : Nat = 0;
    while (i < numNeurons) {
      var row : [Float] = [];
      var j : Nat = 0;
      while (j < numNeurons) {
        if (i == j) {
          row := Array.append(row, [0.0]);
        } else {
          var wij : Float = 0.0;
          for (pattern in patterns.vals()) {
            if (i < pattern.size() and j < pattern.size()) {
              wij += pattern[i] * pattern[j];
            };
          };
          wij := wij / Float.fromInt(numNeurons);
          row := Array.append(row, [wij]);
        };
        j += 1;
      };
      weights := Array.append(weights, [row]);
      i += 1;
    };
    
    let neurons = Array.tabulate<Float>(numNeurons, func(_) { 0.0 });
    
    {
      neurons = neurons;
      weights = weights;
      patterns = patterns;
      energy = 0.0;
      temperature = 0.1;
      numPatterns = patterns.size();
      capacity = 0.138 * Float.fromInt(numNeurons);
    }
  };

  /// Compute Hopfield energy
  public func computeHopfieldEnergy(state : HopfieldState) : Float {
    let n = state.neurons.size();
    var energy : Float = 0.0;
    
    var i : Nat = 0;
    while (i < n) {
      var j : Nat = 0;
      while (j < n) {
        if (i < state.weights.size() and j < state.weights[i].size()) {
          energy -= state.weights[i][j] * state.neurons[i] * state.neurons[j];
        };
        j += 1;
      };
      i += 1;
    };
    energy / 2.0
  };

  /// Asynchronous Hopfield update
  public func updateHopfieldAsync(state : HopfieldState, neuronIdx : Nat) : HopfieldState {
    let n = state.neurons.size();
    if (neuronIdx >= n) { return state };
    
    // Compute local field
    var localField : Float = 0.0;
    var j : Nat = 0;
    while (j < n) {
      if (neuronIdx < state.weights.size() and j < state.weights[neuronIdx].size()) {
        localField += state.weights[neuronIdx][j] * state.neurons[j];
      };
      j += 1;
    };
    
    // Stochastic update with temperature
    let prob = 1.0 / (1.0 + Float.exp(-2.0 * localField / (state.temperature + 0.001)));
    let newValue = if (prob > 0.5) { 1.0 } else { -1.0 };
    
    let newNeurons = Array.tabulate<Float>(n, func(i) {
      if (i == neuronIdx) { newValue } else { state.neurons[i] }
    });
    
    {
      neurons = newNeurons;
      weights = state.weights;
      patterns = state.patterns;
      energy = computeHopfieldEnergy({ neurons = newNeurons; weights = state.weights; patterns = state.patterns; energy = 0.0; temperature = state.temperature; numPatterns = state.numPatterns; capacity = state.capacity });
      temperature = state.temperature;
      numPatterns = state.numPatterns;
      capacity = state.capacity;
    }
  };

  // ─── CROSS-MODULE INTEGRATION ─────────────────────────────────────────────────
  
  /// Integrate with Kuramoto oscillators
  public func integrateWithKuramoto(
    state : AttractorState,
    orderParameter : Float,
    meanPhase : Float
  ) : AttractorState {
    // High Kuramoto coherence strengthens attractor basins
    // Phase alignment creates phase-locked attractors
    let coherenceFactor = 1.0 + (orderParameter - 0.5) * 0.4;
    
    let newAttractors = Array.map<Attractor, Attractor>(state.attractors, func(attr) {
      {
        position = attr.position;
        strength = attr.strength * coherenceFactor;
        basin = attr.basin * coherenceFactor;
        attractorType = attr.attractorType;
      }
    });
    
    {
      attractors = newAttractors;
      currentPosition = state.currentPosition;
      velocity = state.velocity;
      energy = state.energy * (2.0 - coherenceFactor);
      damping = state.damping;
      noise = state.noise;
      beatNum = state.beatNum;
      convergenceRate = state.convergenceRate * coherenceFactor;
      stabilityIndex = state.stabilityIndex * coherenceFactor;
      transitionHistory = state.transitionHistory;
    }
  };

  /// Integrate with Friston free energy
  public func integrateWithFriston(
    state : AttractorState,
    freeEnergy : Float,
    predictionError : Float
  ) : AttractorState {
    // Free energy defines the energy landscape
    // Prediction error creates gradients toward attractors
    let energyContribution = freeEnergy * 0.3;
    let gradientStrength = predictionError * 0.2;
    
    {
      attractors = state.attractors;
      currentPosition = state.currentPosition;
      velocity = state.velocity;
      energy = state.energy + energyContribution;
      damping = state.damping;
      noise = state.noise;
      beatNum = state.beatNum;
      convergenceRate = _clamp(state.convergenceRate + gradientStrength, 0.0, 1.0);
      stabilityIndex = state.stabilityIndex;
      transitionHistory = state.transitionHistory;
    }
  };

  /// Integrate with Hebbian plasticity
  public func integrateWithHebbian(
    state : AttractorState,
    synapticWeights : [Float],
    plasticityRate : Float
  ) : AttractorState {
    // Synaptic weights define attractor positions
    // Plasticity modifies the attractor landscape
    let n = state.attractors.size();
    let wn = synapticWeights.size();
    
    let newAttractors = Array.tabulate<Attractor>(n, func(i) {
      let attr = state.attractors[i];
      let weightMod = if (i < wn) { synapticWeights[i] } else { 1.0 };
      {
        position = attr.position;
        strength = _clamp(attr.strength + weightMod * plasticityRate, 0.0, 10.0);
        basin = attr.basin;
        attractorType = attr.attractorType;
      }
    });
    
    {
      attractors = newAttractors;
      currentPosition = state.currentPosition;
      velocity = state.velocity;
      energy = state.energy;
      damping = state.damping;
      noise = state.noise;
      beatNum = state.beatNum;
      convergenceRate = state.convergenceRate;
      stabilityIndex = state.stabilityIndex;
      transitionHistory = state.transitionHistory;
    }
  };

  /// Integrate with Predictive Coding
  public func integrateWithPredictive(
    state : AttractorState,
    prediction : Float,
    confidence : Float
  ) : AttractorState {
    // Predictions create expected attractor positions
    // Confidence modulates attractor strength
    let predictionInfluence = (prediction - 0.5) * 0.3;
    let confidenceFactor = 1.0 + (confidence - 0.5) * 0.2;
    
    let newAttractors = Array.map<Attractor, Attractor>(state.attractors, func(attr) {
      {
        position = attr.position + predictionInfluence;
        strength = attr.strength * confidenceFactor;
        basin = attr.basin;
        attractorType = attr.attractorType;
      }
    });
    
    {
      attractors = newAttractors;
      currentPosition = state.currentPosition;
      velocity = state.velocity;
      energy = state.energy;
      damping = state.damping;
      noise = state.noise;
      beatNum = state.beatNum;
      convergenceRate = state.convergenceRate;
      stabilityIndex = state.stabilityIndex * confidenceFactor;
      transitionHistory = state.transitionHistory;
    }
  };

  /// Integrate with Quantum effects
  public func integrateWithQuantum(
    state : AttractorState,
    quantumCoherence : Float,
    superpositionWeight : Float
  ) : AttractorState {
    // Quantum coherence enables tunneling between attractors
    // Superposition allows being in multiple basins
    let tunnelingRate = quantumCoherence * 0.1;
    let noiseMod = 1.0 + superpositionWeight * 0.3;
    
    {
      attractors = state.attractors;
      currentPosition = state.currentPosition;
      velocity = state.velocity;
      energy = state.energy;
      damping = state.damping;
      noise = state.noise * noiseMod;
      beatNum = state.beatNum;
      convergenceRate = state.convergenceRate * (1.0 - tunnelingRate);
      stabilityIndex = state.stabilityIndex * (1.0 - tunnelingRate);
      transitionHistory = state.transitionHistory;
    }
  };

  // ─── BIFURCATION ANALYSIS ─────────────────────────────────────────────────────
  
  /// Bifurcation metrics
  public type BifurcationMetrics = {
    parameter : Float;
    bifurcationType : Text;
    isNearBifurcation : Bool;
    criticalSlowing : Float;
    fluctuationAmplitude : Float;
    asymmetry : Float;
  };

  /// Detect approaching bifurcation
  public func detectBifurcation(state : AttractorState) : BifurcationMetrics {
    // Critical slowing: time to return to equilibrium increases
    let relaxationTime = 1.0 / (state.convergenceRate + 0.01);
    let criticalSlowing = _clamp(relaxationTime / 10.0, 0.0, 1.0);
    
    // Fluctuation amplitude increases near bifurcation
    let fluctuation = state.noise * (1.0 + criticalSlowing * 2.0);
    
    // Asymmetry in potential wells
    var asymmetry : Float = 0.0;
    let n = state.attractors.size();
    if (n >= 2) {
      let strength1 = state.attractors[0].strength;
      let strength2 = state.attractors[1].strength;
      asymmetry := Float.abs(strength1 - strength2) / (strength1 + strength2 + 0.01);
    };
    
    // Determine bifurcation type
    let bifType = if (criticalSlowing > 0.7 and asymmetry < 0.2) {
      "pitchfork"
    } else if (criticalSlowing > 0.7 and asymmetry > 0.5) {
      "saddle-node"
    } else if (fluctuation > 0.5) {
      "Hopf"
    } else {
      "none"
    };
    
    {
      parameter = state.energy;
      bifurcationType = bifType;
      isNearBifurcation = criticalSlowing > 0.5;
      criticalSlowing = criticalSlowing;
      fluctuationAmplitude = _clamp(fluctuation, 0.0, 1.0);
      asymmetry = asymmetry;
    }
  };

  // ─── MULTISTABILITY ANALYSIS ──────────────────────────────────────────────────
  
  /// Multistability metrics
  public type MultistabilityMetrics = {
    numStableStates : Nat;
    activeStateIndex : Nat;
    occupancies : [Float];
    meanDwellTime : Float;
    switchingRate : Float;
    bistabilityIndex : Float;
  };

  /// Analyze multistability
  public func analyzeMultistability(state : AttractorState) : MultistabilityMetrics {
    let n = state.attractors.size();
    
    // Count stable states (attractors with sufficient strength)
    var numStable : Nat = 0;
    for (attr in state.attractors.vals()) {
      if (attr.strength > 0.3) {
        numStable += 1;
      };
    };
    
    // Find active state (closest attractor)
    var activeIdx : Nat = 0;
    var minDist : Float = 999999.0;
    var i : Nat = 0;
    while (i < n) {
      let dist = Float.abs(state.attractors[i].position - state.currentPosition);
      if (dist < minDist) {
        minDist := dist;
        activeIdx := i;
      };
      i += 1;
    };
    
    // Occupancy probabilities (Boltzmann distribution)
    var occupancies : [Float] = [];
    var totalBoltz : Float = 0.0;
    for (attr in state.attractors.vals()) {
      let boltz = Float.exp(-attr.strength / (state.noise + 0.01));
      occupancies := Array.append(occupancies, [boltz]);
      totalBoltz += boltz;
    };
    if (totalBoltz > 0.0) {
      occupancies := Array.map<Float, Float>(occupancies, func(o) { o / totalBoltz });
    };
    
    // Mean dwell time (Kramers rate)
    let barrierHeight = if (n > 0) { state.attractors[0].strength } else { 1.0 };
    let dwellTime = Float.exp(barrierHeight / (state.noise + 0.01));
    
    // Switching rate
    let switchRate = 1.0 / (dwellTime + 0.01);
    
    // Bistability index
    let bistability = if (numStable == 2) {
      Float.min(occupancies[0], occupancies[1]) / Float.max(occupancies[0], occupancies[1])
    } else { 0.0 };
    
    {
      numStableStates = numStable;
      activeStateIndex = activeIdx;
      occupancies = occupancies;
      meanDwellTime = _clamp(dwellTime, 0.0, 1000.0);
      switchingRate = _clamp(switchRate, 0.0, 1.0);
      bistabilityIndex = bistability;
    }
  };

  // ─── CHAOTIC DYNAMICS DETECTION ───────────────────────────────────────────────
  
  /// Chaos metrics
  public type ChaosMetrics = {
    lyapunovExponent : Float;
    correlationDimension : Float;
    isChaotic : Bool;
    sensitivityIndex : Float;
    predictabilityHorizon : Float;
  };

  /// Estimate Lyapunov exponent from trajectory
  public func estimateLyapunov(trajectory : [Float]) : Float {
    let n = trajectory.size();
    if (n < 10) { return 0.0 };
    
    var divergenceSum : Float = 0.0;
    var count : Nat = 0;
    
    var i : Nat = 1;
    while (i < n) {
      let diff = Float.abs(trajectory[i] - trajectory[i - 1]);
      if (diff > 0.0001) {
        divergenceSum += Float.log(diff + 0.0001);
        count += 1;
      };
      i += 1;
    };
    
    if (count == 0) { 0.0 } else { divergenceSum / Float.fromInt(count) }
  };

  /// Analyze chaotic dynamics
  public func analyzeChaoticDynamics(state : AttractorState) : ChaosMetrics {
    let lyap = estimateLyapunov(state.transitionHistory);
    let isChaotic = lyap > 0.0;
    
    // Sensitivity to initial conditions
    let sensitivity = if (lyap > 0.0) { Float.exp(lyap) - 1.0 } else { 0.0 };
    
    // Predictability horizon (how far we can forecast)
    let predictHorizon = if (lyap > 0.0) { 1.0 / lyap } else { 100.0 };
    
    // Correlation dimension estimate (simplified)
    let corrDim = if (isChaotic) { 2.0 + lyap } else { 1.0 };
    
    {
      lyapunovExponent = lyap;
      correlationDimension = _clamp(corrDim, 1.0, 10.0);
      isChaotic = isChaotic;
      sensitivityIndex = _clamp(sensitivity, 0.0, 10.0);
      predictabilityHorizon = _clamp(predictHorizon, 0.0, 100.0);
    }
  };

  // ─── ORGANISM OUTPUT INTEGRATION ──────────────────────────────────────────────
  
  /// Complete organism output
  public type AttractorOrganismOutput = {
    // Core metrics
    currentEnergy : Float;
    currentPosition : Float;
    velocity : Float;
    
    // Stability metrics
    convergenceRate : Float;
    stabilityIndex : Float;
    dominantAttractorStrength : Float;
    
    // Bifurcation metrics
    bifurcation : BifurcationMetrics;
    
    // Multistability metrics
    multistability : MultistabilityMetrics;
    
    // Chaos metrics
    chaos : ChaosMetrics;
    
    // Integration metrics
    kuramotoInfluence : Float;
    fristonInfluence : Float;
    hebbianInfluence : Float;
  };

  /// Generate organism output
  public func generateOrganismOutput(state : AttractorState) : AttractorOrganismOutput {
    let bifurcation = detectBifurcation(state);
    let multistability = analyzeMultistability(state);
    let chaos = analyzeChaoticDynamics(state);
    
    let dominantStrength = if (state.attractors.size() > 0) {
      state.attractors[0].strength
    } else { 0.0 };
    
    {
      currentEnergy = state.energy;
      currentPosition = state.currentPosition;
      velocity = state.velocity;
      convergenceRate = state.convergenceRate;
      stabilityIndex = state.stabilityIndex;
      dominantAttractorStrength = dominantStrength;
      bifurcation = bifurcation;
      multistability = multistability;
      chaos = chaos;
      kuramotoInfluence = 0.0;
      fristonInfluence = 0.0;
      hebbianInfluence = 0.0;
    }
  };

  // ─── OUTWARD EXTENSIONS ───────────────────────────────────────────────────────
  
  /// Output for Kuramoto
  public func outputToKuramoto(state : AttractorState) : { phaseBias : Float; couplingMod : Float } {
    let dominantPos = if (state.attractors.size() > 0) {
      state.attractors[0].position
    } else { 0.0 };
    {
      phaseBias = dominantPos * 6.28318;
      couplingMod = state.stabilityIndex;
    }
  };

  /// Output for Friston
  public func outputToFriston(state : AttractorState) : { energyLandscape : Float; basinDepth : Float } {
    let depth = if (state.attractors.size() > 0) {
      state.attractors[0].basin
    } else { 0.0 };
    {
      energyLandscape = state.energy;
      basinDepth = depth;
    }
  };

  /// Output for Hebbian
  public func outputToHebbian(state : AttractorState) : { consolidationSignal : Float; stabilitySignal : Float } {
    {
      consolidationSignal = state.stabilityIndex;
      stabilitySignal = state.convergenceRate;
    }
  };

  /// Output for Predictive
  public func outputToPredictive(state : AttractorState) : { expectedPosition : Float; certainty : Float } {
    let expected = if (state.attractors.size() > 0) {
      state.attractors[0].position
    } else { state.currentPosition };
    {
      expectedPosition = expected;
      certainty = state.stabilityIndex;
    }
  };

  /// Output for Defense
  public func outputToDefense(state : AttractorState) : { systemStability : Float; responseLatency : Float } {
    {
      systemStability = state.stabilityIndex;
      responseLatency = 1.0 / (state.convergenceRate + 0.01);
    }
  };

  /// Master output
  public func generateAllOutputs(state : AttractorState) : {
    kuramoto : { phaseBias : Float; couplingMod : Float };
    friston : { energyLandscape : Float; basinDepth : Float };
    hebbian : { consolidationSignal : Float; stabilitySignal : Float };
    predictive : { expectedPosition : Float; certainty : Float };
    defense : { systemStability : Float; responseLatency : Float };
    organism : AttractorOrganismOutput;
  } {
    {
      kuramoto = outputToKuramoto(state);
      friston = outputToFriston(state);
      hebbian = outputToHebbian(state);
      predictive = outputToPredictive(state);
      defense = outputToDefense(state);
      organism = generateOrganismOutput(state);
    }
  };

  // ─── FULL ORGANISM BEAT ───────────────────────────────────────────────────────
  
  /// Complete organism beat
  public func fullOrganismBeat(
    state : AttractorState,
    dt : Float,
    kuramotoOrder : Float,
    fristonEnergy : Float,
    hebbianWeights : [Float],
    quantumCoherence : Float
  ) : (AttractorState, AttractorOrganismOutput) {
    // Layer 1: Core attractor evolution
    var newState = evolveAttractors(state, dt);
    
    // Layer 2: Kuramoto integration
    newState := integrateWithKuramoto(newState, kuramotoOrder, 0.0);
    
    // Layer 3: Friston integration
    newState := integrateWithFriston(newState, fristonEnergy, 0.1);
    
    // Layer 4: Hebbian integration
    newState := integrateWithHebbian(newState, hebbianWeights, 0.01);
    
    // Layer 5: Quantum integration
    newState := integrateWithQuantum(newState, quantumCoherence, 0.2);
    
    let output = generateOrganismOutput(newState);
    (newState, output)
  };

}
