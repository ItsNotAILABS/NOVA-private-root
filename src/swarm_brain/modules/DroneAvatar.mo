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


// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: DroneAvatar — Hierarchical Mini-Mind Architecture
// Classification: CONFIDENTIAL — INTERNAL USE ONLY
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// Patent Pending: Hierarchical Cognitive Architecture for Autonomous Agents
// ============================================================================
//
// ARCHITECTURE OVERVIEW
// ============================================================================
//
// Each drone operates as an AVATAR — a physical embodiment of a portion of
// the collective organism mind. The hierarchy is:
//
//   ORGANISM MIND (Central)
//       │
//       ├── MINI-MIND (Drone 0) ←→ Physical Avatar
//       ├── MINI-MIND (Drone 1) ←→ Physical Avatar
//       ├── MINI-MIND (Drone 2) ←→ Physical Avatar
//       └── ...
//
// Each mini-mind contains:
//   - Local decision capability (autonomous operation)
//   - Synchronized values from organism (inherited beliefs)
//   - Bidirectional sync with central mind (Kuramoto coupling)
//   - Local sensor processing
//   - Motor control output
//
// The mini-mind IS the drone. The drone IS the mini-mind.
// There is no separation between body and cognition.
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let OMEGA_MEDINA : Float = 2.11185;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let SIGMA_ZERO : Float = 0.75;
  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;

  // Mini-mind architecture
  let MINI_BRAIN_NODES : Nat = 6;
  let SYNC_COUPLING : Float = 0.618;
  let VALUE_INHERITANCE_RATE : Float = 0.95;

  // ==========================================================================
  // CORE VALUE SYSTEM
  // ==========================================================================
  // Values inherited from organism, maintained locally
  
  public type CoreValues = {
    survivalDrive     : Float;    // Self-preservation weight
    missionCommitment : Float;    // Task completion weight
    swarmLoyalty      : Float;    // Collective over individual
    ethicalBound      : Float;    // Constraint on harmful actions
    learningDrive     : Float;    // Knowledge acquisition weight
    truthSeeking      : Float;    // Accuracy over convenience
  };

  public let DEFAULT_VALUES : CoreValues = {
    survivalDrive = 0.7;
    missionCommitment = 0.85;
    swarmLoyalty = 0.9;
    ethicalBound = 1.0;
    learningDrive = 0.8;
    truthSeeking = 0.9;
  };

  // ==========================================================================
  // MINI-BRAIN ARCHITECTURE
  // ==========================================================================
  // 6-node cognitive architecture per drone
  
  public type MiniBrainNode = {
    activation : Float;
    potential  : Float;
    threshold  : Float;
    lastFired  : Nat;
  };

  public type MiniBrain = {
    sensorNode    : MiniBrainNode;    // Processes sensory input
    memoryNode    : MiniBrainNode;    // Short-term memory
    decisionNode  : MiniBrainNode;    // Action selection
    emotionNode   : MiniBrainNode;    // Affective state
    motorNode     : MiniBrainNode;    // Movement commands
    syncNode      : MiniBrainNode;    // Organism synchronization
    
    weights       : [var Float];      // 6x6 = 36 Hebbian weights
    phase         : Float;            // Kuramoto phase
    frequency     : Float;            // Natural oscillation
    coherence     : Float;            // Local coherence measure
  };

  // ==========================================================================
  // MINI-MIND STATE
  // ==========================================================================
  
  public type MiniMindState = {
    droneId         : Nat;
    generation      : Nat;
    birthBeat       : Nat;
    
    brain           : MiniBrain;
    values          : CoreValues;
    
    // Synchronization with organism
    organismPhase   : Float;          // Phase received from central mind
    syncStrength    : Float;          // Coupling strength to organism
    lastSyncBeat    : Nat;
    syncDrift       : Float;          // Accumulated phase drift
    
    // Local state
    position        : (Float, Float, Float);
    velocity        : (Float, Float, Float);
    orientation     : (Float, Float, Float);
    energy          : Float;
    health          : Float;
    
    // Behavioral state
    currentTask     : ?Text;
    taskProgress    : Float;
    alertLevel      : Float;
    stressLevel     : Float;
    
    // Value alignment metrics
    valueAlignment  : Float;          // How aligned with organism values
    valueViolations : Nat;            // Count of value boundary hits
    
    beatNum         : Nat;
  };

  // ==========================================================================
  // UTILITY FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };

  // ==========================================================================
  // KURAMOTO SYNCHRONIZATION
  // ==========================================================================
  // Mini-mind syncs its phase with the organism's central phase
  
  public func syncWithOrganism(
    localPhase: Float,
    organismPhase: Float,
    coupling: Float,
    frequency: Float,
    dt: Float
  ) : Float {
    let phaseDiff = Float.sin(organismPhase - localPhase);
    let newPhase = localPhase + (frequency + coupling * phaseDiff) * dt;
    wrapPhase(newPhase)
  };

  public func computePhaseDrift(localPhase: Float, organismPhase: Float) : Float {
    var diff = localPhase - organismPhase;
    while (diff > PI) { diff -= TWO_PI };
    while (diff < -PI) { diff += TWO_PI };
    Float.abs(diff)
  };

  // ==========================================================================
  // VALUE ALIGNMENT
  // ==========================================================================
  // Jasmine's Law extension: values must remain aligned at all levels
  
  public func computeValueAlignment(local: CoreValues, organism: CoreValues) : Float {
    let diffs = [
      Float.abs(local.survivalDrive - organism.survivalDrive),
      Float.abs(local.missionCommitment - organism.missionCommitment),
      Float.abs(local.swarmLoyalty - organism.swarmLoyalty),
      Float.abs(local.ethicalBound - organism.ethicalBound),
      Float.abs(local.learningDrive - organism.learningDrive),
      Float.abs(local.truthSeeking - organism.truthSeeking)
    ];
    
    var totalDiff : Float = 0.0;
    for (d in diffs.vals()) { totalDiff += d };
    
    clamp(1.0 - totalDiff / 6.0, 0.0, 1.0)
  };

  public func inheritValues(
    local: CoreValues,
    organism: CoreValues,
    inheritanceRate: Float
  ) : CoreValues {
    let r = inheritanceRate;
    let l = 1.0 - r;
    {
      survivalDrive = local.survivalDrive * l + organism.survivalDrive * r;
      missionCommitment = local.missionCommitment * l + organism.missionCommitment * r;
      swarmLoyalty = local.swarmLoyalty * l + organism.swarmLoyalty * r;
      ethicalBound = Float.max(local.ethicalBound, organism.ethicalBound);
      learningDrive = local.learningDrive * l + organism.learningDrive * r;
      truthSeeking = local.truthSeeking * l + organism.truthSeeking * r;
    }
  };

  // ==========================================================================
  // DECISION MAKING WITH VALUE CONSTRAINTS
  // ==========================================================================
  // All actions filtered through value system (Jasmine's Law application)
  
  public type ProposedAction = {
    actionType : Text;
    target     : ?Nat;
    intensity  : Float;
    urgency    : Float;
  };

  public type ActionEvaluation = {
    action     : ProposedAction;
    permitted  : Bool;
    valueScore : Float;
    reasoning  : Text;
  };

  public func evaluateAction(
    action: ProposedAction,
    values: CoreValues,
    swarmCoherence: Float
  ) : ActionEvaluation {
    var score : Float = 1.0;
    var reasoning : Text = "";
    var permitted : Bool = true;
    
    // Ethical bound is absolute
    if (action.intensity > values.ethicalBound) {
      permitted := false;
      reasoning := "Action exceeds ethical bound";
      score := 0.0;
    };
    
    // Swarm loyalty check
    if (permitted and swarmCoherence < 0.5 and action.urgency < 0.8) {
      score *= values.swarmLoyalty;
      reasoning := "Swarm coherence low, action weighted by loyalty";
    };
    
    // Mission commitment
    if (permitted) {
      score *= values.missionCommitment;
    };
    
    {
      action = action;
      permitted = permitted;
      valueScore = score;
      reasoning = reasoning;
    }
  };

  // ==========================================================================
  // HEBBIAN LEARNING (LOCAL)
  // ==========================================================================
  
  public func localHebbianUpdate(
    weights: [var Float],
    activations: [Float],
    learningRate: Float
  ) : () {
    let n = activations.size();
    if (n * n != weights.size()) { return };
    
    let eta = learningRate;
    let decay = 0.01;
    
    for (i in activations.keys()) {
      for (j in activations.keys()) {
        let idx = i * n + j;
        let delta = eta * activations[i] * activations[j] - decay * weights[idx];
        weights[idx] := clamp(weights[idx] + delta, -2.0, 2.0);
      };
    };
  };

  // ==========================================================================
  // BEAT FUNCTION
  // ==========================================================================
  
  public func beatMiniMind(
    state: MiniMindState,
    organismPhase: Float,
    organismValues: CoreValues,
    dt: Float
  ) : MiniMindState {
    // 1. Sync phase with organism
    let newPhase = syncWithOrganism(
      state.brain.phase,
      organismPhase,
      state.syncStrength,
      state.brain.frequency,
      dt
    );
    
    // 2. Compute drift
    let drift = computePhaseDrift(newPhase, organismPhase);
    
    // 3. Inherit values (gradual alignment)
    let newValues = inheritValues(
      state.values,
      organismValues,
      VALUE_INHERITANCE_RATE * dt
    );
    
    // 4. Compute value alignment
    let alignment = computeValueAlignment(newValues, organismValues);
    
    // 5. Update local coherence
    let newCoherence = clamp(
      state.brain.coherence * 0.9 + (1.0 - drift / PI) * 0.1,
      SIGMA_ZERO,
      1.0
    );
    
    // 6. Get activations for Hebbian update
    let activations = [
      state.brain.sensorNode.activation,
      state.brain.memoryNode.activation,
      state.brain.decisionNode.activation,
      state.brain.emotionNode.activation,
      state.brain.motorNode.activation,
      state.brain.syncNode.activation
    ];
    
    // 7. Hebbian learning
    localHebbianUpdate(
      state.brain.weights,
      activations,
      newValues.learningDrive * 0.1
    );
    
    // Return updated state
    {
      droneId = state.droneId;
      generation = state.generation;
      birthBeat = state.birthBeat;
      brain = {
        sensorNode = state.brain.sensorNode;
        memoryNode = state.brain.memoryNode;
        decisionNode = state.brain.decisionNode;
        emotionNode = state.brain.emotionNode;
        motorNode = state.brain.motorNode;
        syncNode = state.brain.syncNode;
        weights = state.brain.weights;
        phase = newPhase;
        frequency = state.brain.frequency;
        coherence = newCoherence;
      };
      values = newValues;
      organismPhase = organismPhase;
      syncStrength = state.syncStrength;
      lastSyncBeat = state.beatNum + 1;
      syncDrift = drift;
      position = state.position;
      velocity = state.velocity;
      orientation = state.orientation;
      energy = state.energy;
      health = state.health;
      currentTask = state.currentTask;
      taskProgress = state.taskProgress;
      alertLevel = state.alertLevel;
      stressLevel = state.stressLevel;
      valueAlignment = alignment;
      valueViolations = state.valueViolations;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  func initNode() : MiniBrainNode {
    {
      activation = 0.5;
      potential = 0.0;
      threshold = 0.7;
      lastFired = 0;
    }
  };

  public func initMiniMind(droneId: Nat, initialPhase: Float) : MiniMindState {
    let weights = Array.init<Float>(36, 0.1);
    
    {
      droneId = droneId;
      generation = 0;
      birthBeat = 0;
      brain = {
        sensorNode = initNode();
        memoryNode = initNode();
        decisionNode = initNode();
        emotionNode = initNode();
        motorNode = initNode();
        syncNode = initNode();
        weights = weights;
        phase = initialPhase;
        frequency = 0.1 + Float.fromInt(droneId % 10) * 0.01;
        coherence = SIGMA_ZERO;
      };
      values = DEFAULT_VALUES;
      organismPhase = 0.0;
      syncStrength = SYNC_COUPLING;
      lastSyncBeat = 0;
      syncDrift = 0.0;
      position = (0.0, 50.0, 0.0);
      velocity = (0.0, 0.0, 0.0);
      orientation = (0.0, 0.0, 0.0);
      energy = 1.0;
      health = 1.0;
      currentTask = null;
      taskProgress = 0.0;
      alertLevel = 0.0;
      stressLevel = 0.0;
      valueAlignment = 1.0;
      valueViolations = 0;
      beatNum = 0;
    }
  };


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
  //  W O R L D   S I M U L A T I O N   M A T H E M A T I C S
  //
  //  Enterprise-Level World Modeling and Physics
  //  Full HIM/HER Integration for Virtual Environments
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // PHYSICS SIMULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Newtonian mechanics: F = ma
  public func worldForceToAcceleration(force : Float, mass : Float) : Float {
    if (mass < 0.0001) { 0.0 } else { force / mass }
  };

  /// Velocity update: v = v0 + a*t
  public func worldVelocityUpdate(v0 : Float, acceleration : Float, dt : Float) : Float {
    v0 + acceleration * dt
  };

  /// Position update: x = x0 + v*t + 0.5*a*t²
  public func worldPositionUpdate(x0 : Float, velocity : Float, acceleration : Float, dt : Float) : Float {
    x0 + velocity * dt + 0.5 * acceleration * dt * dt
  };

  /// Gravitational force: F = G*m1*m2/r²
  public func worldGravitationalForce(m1 : Float, m2 : Float, distance : Float, g : Float) : Float {
    if (distance < 0.0001) { 0.0 }
    else { g * m1 * m2 / (distance * distance) }
  };

  /// Drag force: F = 0.5*rho*v²*Cd*A
  public func worldDragForce(density : Float, velocity : Float, dragCoeff : Float, area : Float) : Float {
    0.5 * density * velocity * velocity * dragCoeff * area
  };

  /// Spring force: F = -k*x
  public func worldSpringForce(springConstant : Float, displacement : Float) : Float {
    -springConstant * displacement
  };

  /// Friction force: F = μ*N
  public func worldFrictionForce(frictionCoeff : Float, normalForce : Float) : Float {
    frictionCoeff * normalForce
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COLLISION DETECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// AABB collision test
  public func worldAABBCollision(
    ax1 : Float, ay1 : Float, ax2 : Float, ay2 : Float,
    bx1 : Float, by1 : Float, bx2 : Float, by2 : Float
  ) : Bool {
    ax1 <= bx2 and ax2 >= bx1 and ay1 <= by2 and ay2 >= by1
  };

  /// Circle collision test
  public func worldCircleCollision(
    x1 : Float, y1 : Float, r1 : Float,
    x2 : Float, y2 : Float, r2 : Float
  ) : Bool {
    let dx = x2 - x1;
    let dy = y2 - y1;
    let dist = Float.sqrt(dx * dx + dy * dy);
    dist < (r1 + r2)
  };

  /// Point in triangle test
  public func worldPointInTriangle(
    px : Float, py : Float,
    ax : Float, ay : Float,
    bx : Float, by : Float,
    cx : Float, cy : Float
  ) : Bool {
    func sign(p1x : Float, p1y : Float, p2x : Float, p2y : Float, p3x : Float, p3y : Float) : Float {
      (p1x - p3x) * (p2y - p3y) - (p2x - p3x) * (p1y - p3y)
    };
    let d1 = sign(px, py, ax, ay, bx, by);
    let d2 = sign(px, py, bx, by, cx, cy);
    let d3 = sign(px, py, cx, cy, ax, ay);
    let hasNeg = (d1 < 0.0) or (d2 < 0.0) or (d3 < 0.0);
    let hasPos = (d1 > 0.0) or (d2 > 0.0) or (d3 > 0.0);
    not (hasNeg and hasPos)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TERRAIN GENERATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Simple noise function (pseudo-random)
  public func worldSimpleNoise(x : Nat, y : Nat, seed : Nat) : Float {
    let n = x + y * 57 + seed * 131;
    let m = ((n * (n * n * 15731 + 789221) + 1376312589) % 2147483648);
    Float.fromInt(m % 1000000) / 1000000.0
  };

  /// Linear interpolation
  public func worldLerp(a : Float, b : Float, t : Float) : Float {
    a + t * (b - a)
  };

  /// Smooth interpolation
  public func worldSmoothStep(t : Float) : Float {
    t * t * (3.0 - 2.0 * t)
  };

  /// Height map sample
  public func worldHeightMapSample(
    x : Float, y : Float,
    octaves : Nat,
    persistence : Float,
    lacunarity : Float,
    seed : Nat
  ) : Float {
    var total : Float = 0.0;
    var amplitude : Float = 1.0;
    var frequency : Float = 1.0;
    var maxVal : Float = 0.0;
    var i = 0;
    while (i < octaves) {
      let xi = Int.abs(Float.toInt(x * frequency));
      let yi = Int.abs(Float.toInt(y * frequency));
      total += worldSimpleNoise(xi, yi, seed + i) * amplitude;
      maxVal += amplitude;
      amplitude *= persistence;
      frequency *= lacunarity;
      i += 1;
    };
    total / maxVal
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // WEATHER SIMULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Temperature model
  public func worldTemperature(
    baseTemp : Float,
    latitude : Float,
    altitude : Float,
    timeOfDay : Float
  ) : Float {
    let latFactor = Float.cos(latitude * 3.14159265 / 180.0) * 30.0;
    let altFactor = -altitude * 0.0065;
    let diurnalFactor = 5.0 * Float.sin((timeOfDay - 6.0) * 3.14159265 / 12.0);
    baseTemp + latFactor + altFactor + diurnalFactor
  };

  /// Wind speed from pressure gradient
  public func worldWindSpeed(
    pressureGradient : Float,
    coriolisFactor : Float,
    friction : Float
  ) : Float {
    pressureGradient / (coriolisFactor + friction + 0.01)
  };

  /// Precipitation probability
  public func worldPrecipitationProb(
    humidity : Float,
    temperature : Float,
    pressure : Float
  ) : Float {
    let saturation = humidity / (1.0 + Float.exp(-0.1 * (temperature - 10.0)));
    let instability = 1.0 / (pressure + 0.01);
    Float.min(saturation * instability * 2.0, 1.0)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE DISTRIBUTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Resource density based on terrain
  public func worldResourceDensity(
    terrainType : Nat,
    height : Float,
    moisture : Float
  ) : Float {
    let baseDensity = Float.fromInt(terrainType % 10) / 10.0;
    let heightFactor = 1.0 - Float.abs(height - 0.5);
    let moistureFactor = moisture;
    baseDensity * heightFactor * moistureFactor
  };

  /// Population growth model
  public func worldPopulationGrowth(
    population : Float,
    resources : Float,
    capacity : Float,
    growthRate : Float
  ) : Float {
    let resourceFactor = resources / (resources + 1.0);
    let carryingFactor = 1.0 - population / capacity;
    population * growthRate * resourceFactor * carryingFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPATIAL INDEXING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Grid cell index from position
  public func worldGridIndex(x : Float, y : Float, cellSize : Float) : (Nat, Nat) {
    let ix = Int.abs(Float.toInt(x / cellSize));
    let iy = Int.abs(Float.toInt(y / cellSize));
    (ix, iy)
  };

  /// Distance between grid cells
  public func worldGridDistance(x1 : Nat, y1 : Nat, x2 : Nat, y2 : Nat) : Float {
    let dx = Float.fromInt(if (x1 > x2) x1 - x2 else x2 - x1);
    let dy = Float.fromInt(if (y1 > y2) y1 - y2 else y2 - y1);
    Float.sqrt(dx * dx + dy * dy)
  };

  /// Morton code for Z-order curve
  public func worldMortonCode(x : Nat, y : Nat) : Nat {
    var mx = x;
    var my = y;
    var code : Nat = 0;
    var bit : Nat = 0;
    while (bit < 16) {
      code += ((mx % 2) * 2 + (my % 2)) * (4 ** bit);
      mx /= 2;
      my /= 2;
      bit += 1;
    };
    code
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ██████╗ ██████╗  ██████╗ ███╗   ██╗███████╗    ██████╗ ██████╗  █████╗ ██╗███╗   ██╗
  // ██╔══██╗██╔══██╗██╔═══██╗████╗  ██║██╔════╝    ██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║
  // ██║  ██║██████╔╝██║   ██║██╔██╗ ██║█████╗      ██████╔╝██████╔╝███████║██║██╔██╗ ██║
  // ██║  ██║██╔══██╗██║   ██║██║╚██╗██║██╔══╝      ██╔══██╗██╔══██╗██╔══██║██║██║╚██╗██║
  // ██████╔╝██║  ██║╚██████╔╝██║ ╚████║███████╗    ██████╔╝██║  ██║██║  ██║██║██║ ╚████║
  // ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: CENTRAL BRAIN CORE — THE COMPLETE DRONE MIND
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Each drone has a COMPLETE BRAIN - not a simplified controller.
  // The brain contains ALL cognitive systems from the organism, scaled down.
  //
  // BRAIN REGIONS:
  //   • PREFRONTAL CORTEX - Decision making, planning, goal selection
  //   • MOTOR CORTEX - Movement generation, trajectory planning
  //   • SENSORY CORTEX - Sensor fusion, world modeling
  //   • HIPPOCAMPUS - Spatial memory, navigation
  //   • AMYGDALA - Threat assessment, emotional valence
  //   • CEREBELLUM - Motor coordination, timing
  //   • BASAL GANGLIA - Action selection, habit formation
  //   • THALAMUS - Information routing, attention gating
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Complete drone brain state
  public type DroneBrainCore = {
    // Identity
    droneId         : Nat;
    squadronId      : Nat;
    birthBeat       : Nat;
    age             : Nat;
    
    // Brain regions
    prefrontalCortex : PrefrontalCortexState;
    motorCortex     : MotorCortexState;
    sensoryCortex   : SensoryCortexState;
    hippocampus     : HippocampusState;
    amygdala        : AmygdalaState;
    cerebellum      : CerebellumState;
    basalGanglia    : BasalGangliaState;
    thalamus        : ThalamusState;
    
    // Global brain state
    globalWorkspace : [Float];      // Global neuronal workspace
    consciousnessLevel : Float;     // Phi-like integrated information
    arousalLevel    : Float;        // General activation
    vigilanceLevel  : Float;        // Threat alertness
    
    // Neuromodulators (drone's "hormones")
    dopamine        : Float;        // Reward, motivation
    norepinephrine  : Float;        // Arousal, attention
    serotonin       : Float;        // Mood, inhibition
    acetylcholine   : Float;        // Learning, memory
    
    // Energy management
    metabolicEnergy : Float;        // Brain energy (battery proxy)
    oxygenLevel     : Float;        // Cooling efficiency proxy
    
    // Learning state
    learningRate    : Float;
    plasticity      : Float;
    
    // Current beat
    beatNum         : Nat;
  };

  /// Prefrontal cortex - executive function, planning
  public type PrefrontalCortexState = {
    // Goals and intentions
    currentGoal     : GoalState;
    goalStack       : [GoalState];
    intentionStrength : Float;
    
    // Working memory
    workingMemory   : [Float];
    wmCapacity      : Nat;
    
    // Planning
    currentPlan     : [PlannedAction];
    planHorizon     : Nat;
    planConfidence  : Float;
    
    // Decision making
    decisionOptions : [DecisionOption];
    currentDecision : ?Nat;
    decisionCertainty : Float;
    
    // Cognitive control
    inhibitionStrength : Float;
    flexibilityScore : Float;
    taskSwitchCost  : Float;
  };

  /// Goal representation
  public type GoalState = {
    goalType        : Text;         // "explore", "forage", "return", "defend", "recruit"
    targetLocation  : ?{ lat: Float; lon: Float; alt: Float };
    priority        : Float;
    urgency         : Float;
    progress        : Float;
    timeLimit       : ?Nat;
  };

  /// Planned action
  public type PlannedAction = {
    actionType      : Text;
    parameters      : [Float];
    expectedOutcome : Float;
    duration        : Nat;
    prerequisites   : [Nat];
  };

  /// Decision option
  public type DecisionOption = {
    optionId        : Nat;
    description     : Text;
    expectedValue   : Float;
    riskLevel       : Float;
    confidence      : Float;
  };

  /// Motor cortex - movement generation
  public type MotorCortexState = {
    // Motor commands
    currentCommand  : MotorCommand;
    commandQueue    : [MotorCommand];
    
    // Trajectory
    plannedTrajectory : [{ x: Float; y: Float; z: Float; t: Float }];
    trajectoryProgress : Float;
    
    // Motor primitives
    activePrimitives : [MotorPrimitive];
    
    // Coordination
    motorCoordination : Float;
    movementSmoothing : Float;
    
    // Feedback
    proprioceptiveFeedback : [Float];
    motorErrorSignal : Float;
  };

  /// Motor command
  public type MotorCommand = {
    // Thrust commands (for quadcopter)
    thrust          : Float;        // Total thrust 0-1
    roll            : Float;        // Roll angle target
    pitch           : Float;        // Pitch angle target
    yaw             : Float;        // Yaw rate target
    
    // Alternative: individual motor speeds
    motorSpeeds     : [Float];      // 4-8 motors
    
    // Command metadata
    timestamp       : Nat;
    duration        : Nat;
    priority        : Float;
  };

  /// Motor primitive (basic movement pattern)
  public type MotorPrimitive = {
    primitiveType   : Text;         // "hover", "forward", "turn", "climb", "descend"
    intensity       : Float;
    duration        : Nat;
    phase           : Float;
  };

  /// Sensory cortex - perception and fusion
  public type SensoryCortexState = {
    // Visual processing
    visualField     : [[Float]];    // Simplified visual representation
    visualSalience  : [[Float]];    // Attention map
    objectDetections : [DetectedObject];
    
    // Spatial processing
    spatialMap      : [[Float]];    // Local occupancy grid
    obstacleMap     : [[Float]];
    
    // Auditory processing (if equipped)
    auditoryInput   : [Float];
    soundDirection  : ?Float;
    
    // Proprioception
    bodyState       : BodyStateEstimate;
    
    // Sensor fusion
    fusedWorldState : FusedWorldState;
    sensorReliability : [Float];
    
    // Attention
    attentionFocus  : { x: Float; y: Float; z: Float };
    attentionRadius : Float;
  };

  /// Detected object
  public type DetectedObject = {
    objectType      : Text;         // "drone", "obstacle", "target", "threat"
    position        : { x: Float; y: Float; z: Float };
    velocity        : ?{ vx: Float; vy: Float; vz: Float };
    size            : Float;
    confidence      : Float;
    lastSeen        : Nat;
    trackId         : Nat;
  };

  /// Body state estimate
  public type BodyStateEstimate = {
    position        : { lat: Float; lon: Float; alt: Float };
    velocity        : { vx: Float; vy: Float; vz: Float };
    acceleration    : { ax: Float; ay: Float; az: Float };
    orientation     : { roll: Float; pitch: Float; yaw: Float };
    angularVelocity : { p: Float; q: Float; r: Float };
    
    // Uncertainties
    positionUncertainty : Float;
    orientationUncertainty : Float;
  };

  /// Fused world state
  public type FusedWorldState = {
    timestamp       : Nat;
    selfState       : BodyStateEstimate;
    nearbyDrones    : [{ id: Nat; pos: { x: Float; y: Float; z: Float }; vel: { x: Float; y: Float; z: Float } }];
    obstacles       : [{ pos: { x: Float; y: Float; z: Float }; radius: Float }];
    targets         : [{ id: Nat; pos: { x: Float; y: Float; z: Float }; value: Float }];
    threats         : [{ pos: { x: Float; y: Float; z: Float }; level: Float }];
    weatherConditions : { wind: { x: Float; y: Float; z: Float }; visibility: Float };
  };

  /// Hippocampus - spatial memory and navigation
  public type HippocampusState = {
    // Place cells
    placeCells      : [PlaceCell];
    currentPlaceCell : ?Nat;
    
    // Grid cells
    gridCells       : [GridCell];
    gridPhase       : [Float];
    
    // Head direction cells
    headDirectionCells : [Float];
    currentHeading  : Float;
    
    // Path integration
    homeVector      : { distance: Float; direction: Float };
    pathIntegrationError : Float;
    
    // Spatial memory
    exploredAreas   : [[Bool]];
    landmarkMemory  : [Landmark];
    routeMemory     : [Route];
    
    // Replay for planning
    replayActive    : Bool;
    replaySequence  : [Nat];
  };

  /// Place cell
  public type PlaceCell = {
    cellId          : Nat;
    preferredLocation : { lat: Float; lon: Float };
    firingRate      : Float;
    fieldRadius     : Float;
    lastActivation  : Nat;
  };

  /// Grid cell
  public type GridCell = {
    cellId          : Nat;
    gridSpacing     : Float;
    gridOrientation : Float;
    currentPhase    : { x: Float; y: Float };
    firingRate      : Float;
  };

  /// Landmark
  public type Landmark = {
    landmarkId      : Nat;
    position        : { lat: Float; lon: Float; alt: Float };
    visualSignature : [Float];
    reliability     : Float;
    lastSeen        : Nat;
  };

  /// Route
  public type Route = {
    routeId         : Nat;
    waypoints       : [{ lat: Float; lon: Float; alt: Float }];
    totalDistance   : Float;
    estimatedTime   : Nat;
    reliability     : Float;
    timesUsed       : Nat;
  };

  /// Amygdala - threat assessment and emotional valence
  public type AmygdalaState = {
    // Fear/threat processing
    threatLevel     : Float;
    threatSource    : ?{ x: Float; y: Float; z: Float };
    fearMemories    : [FearMemory];
    
    // Reward processing
    rewardLevel     : Float;
    rewardPrediction : Float;
    rewardPredictionError : Float;
    
    // Emotional valence
    currentValence  : Float;        // -1 (negative) to +1 (positive)
    arousal         : Float;        // 0 (calm) to 1 (highly aroused)
    
    // Approach/avoidance
    approachDrive   : Float;
    avoidanceDrive  : Float;
    
    // Stress response
    stressLevel     : Float;
    cortisol        : Float;        // Stress hormone proxy
    stressRecoveryRate : Float;
  };

  /// Fear memory
  public type FearMemory = {
    memoryId        : Nat;
    location        : ?{ lat: Float; lon: Float };
    triggerType     : Text;
    intensity       : Float;
    formationBeat   : Nat;
    extinctionProgress : Float;
  };

  /// Cerebellum - motor coordination and timing
  public type CerebellumState = {
    // Motor learning
    forwardModels   : [ForwardModel];
    inverseModels   : [InverseModel];
    
    // Timing
    internalClock   : Float;
    timingPrecision : Float;
    rhythmPhase     : Float;
    
    // Coordination
    coordinationMatrix : [[Float]];
    smoothingFactor : Float;
    
    // Error correction
    motorErrorHistory : [Float];
    adaptationRate  : Float;
    
    // Predicted sensory consequences
    predictedSensory : [Float];
    sensoryPredictionError : Float;
  };

  /// Forward model (predict sensory consequences of action)
  public type ForwardModel = {
    modelId         : Nat;
    actionType      : Text;
    stateTransition : [[Float]];
    predictionAccuracy : Float;
  };

  /// Inverse model (action to achieve desired state)
  public type InverseModel = {
    modelId         : Nat;
    targetType      : Text;
    controlMapping  : [[Float]];
    controlAccuracy : Float;
  };

  /// Basal ganglia - action selection and habits
  public type BasalGangliaState = {
    // Action selection
    actionCandidates : [ActionCandidate];
    selectedAction  : ?Nat;
    selectionThreshold : Float;
    
    // Direct pathway (GO)
    directPathwayActivity : [Float];
    
    // Indirect pathway (NO-GO)
    indirectPathwayActivity : [Float];
    
    // Hyperdirect pathway (STOP)
    hyperdirectActivity : Float;
    
    // Dopamine modulation
    dopamineLevel   : Float;
    rewardPredictionError : Float;
    
    // Habit formation
    habitStrength   : [Float];
    explorationRate : Float;
  };

  /// Action candidate
  public type ActionCandidate = {
    actionId        : Nat;
    actionType      : Text;
    expectedReward  : Float;
    effort          : Float;
    saliency        : Float;
    goSignal        : Float;
    nogoSignal      : Float;
  };

  /// Thalamus - information routing and attention gating
  public type ThalamusState = {
    // Nuclei activity
    nucleiActivity  : [Float];
    
    // Gating
    gatingMatrix    : [[Float]];
    attentionGates  : [Float];
    
    // Relay functions
    sensoryRelay    : [Float];
    motorRelay      : [Float];
    
    // Cortico-thalamic loops
    loopActivity    : [Float];
    
    // Arousal regulation
    arousalSignal   : Float;
    sleepPressure   : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: DISTRIBUTED BODY NODES — NEURAL NETWORK THROUGHOUT DRONE
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Like a real organism, the drone has neural nodes distributed throughout its body.
  // Each node controls local functions and communicates with the central brain.
  //
  // NODE LOCATIONS:
  //   • Motor nodes (one per motor/actuator)
  //   • Sensor nodes (one per sensor cluster)
  //   • Wing nodes (if applicable)
  //   • Tail node (stability)
  //   • Landing gear nodes
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Distributed body node
  public type BodyNode = {
    nodeId          : Nat;
    nodeType        : BodyNodeType;
    position        : { x: Float; y: Float; z: Float };  // Relative to drone center
    
    // Local processing
    localActivation : Float;
    localMemory     : [Float];
    
    // Sensors at this node
    localSensors    : [LocalSensor];
    
    // Actuators at this node
    localActuators  : [LocalActuator];
    
    // Communication with brain
    afferentSignal  : Float;        // To brain
    efferentSignal  : Float;        // From brain
    signalDelay     : Float;        // Neural conduction delay
    
    // Local reflexes (can act without brain)
    localReflex     : ?LocalReflex;
    
    // Health
    nodeHealth      : Float;
    temperature     : Float;
  };

  /// Body node types
  public type BodyNodeType = {
    #MotorNode : { motorId: Nat };
    #SensorNode : { sensorType: Text };
    #WingNode : { wingId: Nat };
    #TailNode;
    #LandingGearNode : { gearId: Nat };
    #PayloadNode;
    #CommunicationNode;
    #PowerNode;
  };

  /// Local sensor
  public type LocalSensor = {
    sensorId        : Nat;
    sensorType      : Text;         // "imu", "gps", "camera", "lidar", "ultrasonic", "temperature", "current"
    currentReading  : [Float];
    lastUpdate      : Nat;
    reliability     : Float;
    noiseLevel      : Float;
  };

  /// Local actuator
  public type LocalActuator = {
    actuatorId      : Nat;
    actuatorType    : Text;         // "motor", "servo", "led", "speaker"
    currentCommand  : Float;
    actualState     : Float;
    responsiveness  : Float;
    health          : Float;
  };

  /// Local reflex (bypasses brain for speed)
  public type LocalReflex = {
    reflexType      : Text;         // "collision_avoid", "stabilize", "thermal_protect"
    triggerCondition : Float;
    response        : Float;
    isActive        : Bool;
    lastTrigger     : Nat;
  };

  /// Complete distributed body network
  public type DistributedBodyNetwork = {
    nodes           : [BodyNode];
    connections     : [(Nat, Nat, Float)];  // (from, to, strength)
    
    // Network state
    networkActivity : Float;
    synchronization : Float;
    
    // Health
    overallHealth   : Float;
    faultyNodes     : [Nat];
    
    // Power distribution
    powerDistribution : [Float];
    totalPowerDraw  : Float;
  };

  /// Initialize distributed body network
  public func initDistributedBody(numMotors: Nat) : DistributedBodyNetwork {
    var nodes : [BodyNode] = [];
    var nodeId : Nat = 0;
    
    // Motor nodes (one per motor)
    for (m in Iter.range(0, numMotors - 1)) {
      let angle = Float.fromInt(m) * TWO_PI / Float.fromInt(numMotors);
      let radius = 0.2;  // 20cm from center
      nodes := Array.append(nodes, [{
        nodeId = nodeId;
        nodeType = #MotorNode({ motorId = m });
        position = { 
          x = radius * Float.cos(angle); 
          y = radius * Float.sin(angle); 
          z = 0.0 
        };
        localActivation = 0.0;
        localMemory = [0.0, 0.0, 0.0];
        localSensors = [{
          sensorId = nodeId * 10;
          sensorType = "current";
          currentReading = [0.0];
          lastUpdate = 0;
          reliability = 0.95;
          noiseLevel = 0.02;
        }, {
          sensorId = nodeId * 10 + 1;
          sensorType = "temperature";
          currentReading = [25.0];
          lastUpdate = 0;
          reliability = 0.98;
          noiseLevel = 0.5;
        }];
        localActuators = [{
          actuatorId = m;
          actuatorType = "motor";
          currentCommand = 0.0;
          actualState = 0.0;
          responsiveness = 0.95;
          health = 1.0;
        }];
        localReflex = ?{
          reflexType = "thermal_protect";
          triggerCondition = 80.0;  // Degrees C
          response = 0.0;           // Reduce power
          isActive = false;
          lastTrigger = 0;
        };
        nodeHealth = 1.0;
        temperature = 25.0;
      }]);
      nodeId += 1;
    };
    
    // Central sensor node (IMU, GPS, etc.)
    nodes := Array.append(nodes, [{
      nodeId = nodeId;
      nodeType = #SensorNode({ sensorType = "central" });
      position = { x = 0.0; y = 0.0; z = 0.0 };
      localActivation = 0.0;
      localMemory = Array.tabulate<Float>(10, func(_) { 0.0 });
      localSensors = [{
        sensorId = nodeId * 10;
        sensorType = "imu";
        currentReading = [0.0, 0.0, -9.81, 0.0, 0.0, 0.0];  // accel + gyro
        lastUpdate = 0;
        reliability = 0.99;
        noiseLevel = 0.01;
      }, {
        sensorId = nodeId * 10 + 1;
        sensorType = "gps";
        currentReading = [32.7767, -96.7970, 100.0];  // lat, lon, alt
        lastUpdate = 0;
        reliability = 0.95;
        noiseLevel = 2.0;  // meters
      }, {
        sensorId = nodeId * 10 + 2;
        sensorType = "barometer";
        currentReading = [101325.0];  // Pa
        lastUpdate = 0;
        reliability = 0.98;
        noiseLevel = 10.0;
      }, {
        sensorId = nodeId * 10 + 3;
        sensorType = "magnetometer";
        currentReading = [0.3, 0.0, 0.5];  // Gauss
        lastUpdate = 0;
        reliability = 0.90;
        noiseLevel = 0.05;
      }];
      localActuators = [];
      localReflex = null;
      nodeHealth = 1.0;
      temperature = 30.0;
    }]);
    nodeId += 1;
    
    // Communication node
    nodes := Array.append(nodes, [{
      nodeId = nodeId;
      nodeType = #CommunicationNode;
      position = { x = 0.0; y = 0.0; z = 0.05 };  // Top of drone
      localActivation = 0.0;
      localMemory = Array.tabulate<Float>(20, func(_) { 0.0 });  // Message buffer
      localSensors = [{
        sensorId = nodeId * 10;
        sensorType = "rssi";
        currentReading = [-50.0];  // dBm
        lastUpdate = 0;
        reliability = 0.9;
        noiseLevel = 5.0;
      }];
      localActuators = [{
        actuatorId = 100;
        actuatorType = "radio";
        currentCommand = 1.0;  // On
        actualState = 1.0;
        responsiveness = 0.99;
        health = 1.0;
      }];
      localReflex = null;
      nodeHealth = 1.0;
      temperature = 35.0;
    }]);
    nodeId += 1;
    
    // Power node (battery management)
    nodes := Array.append(nodes, [{
      nodeId = nodeId;
      nodeType = #PowerNode;
      position = { x = 0.0; y = 0.0; z = -0.03 };  // Bottom center
      localActivation = 0.0;
      localMemory = [100.0, 16.8, 0.0];  // SOC, voltage, current
      localSensors = [{
        sensorId = nodeId * 10;
        sensorType = "battery";
        currentReading = [100.0, 16.8, 0.0];  // SOC%, voltage, current
        lastUpdate = 0;
        reliability = 0.99;
        noiseLevel = 0.5;
      }];
      localActuators = [];
      localReflex = ?{
        reflexType = "low_battery_protect";
        triggerCondition = 15.0;  // 15% SOC
        response = 0.5;           // Reduce power to 50%
        isActive = false;
        lastTrigger = 0;
      };
      nodeHealth = 1.0;
      temperature = 30.0;
    }]);
    
    // Build connections
    var connections : [(Nat, Nat, Float)] = [];
    // Connect all motor nodes to central sensor node
    for (m in Iter.range(0, numMotors - 1)) {
      connections := Array.append(connections, [(m, numMotors, 1.0)]);
      connections := Array.append(connections, [(numMotors, m, 1.0)]);
    };
    // Connect communication node to all
    for (n in Iter.range(0, Int.abs(nodeId - 1))) {
      if (n != numMotors + 1) {
        connections := Array.append(connections, [(numMotors + 1, n, 0.8)]);
      };
    };
    
    {
      nodes = nodes;
      connections = connections;
      networkActivity = 0.5;
      synchronization = 0.8;
      overallHealth = 1.0;
      faultyNodes = [];
      powerDistribution = Array.tabulate<Float>(nodes.size(), func(_) { 0.0 });
      totalPowerDraw = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: DRONE ROLE SYSTEM — BORN WITH PURPOSE
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Like bees, each drone is born with a role that it naturally fulfills.
  // Roles can change with age and colony needs, but there's an innate tendency.
  //
  // ROLES (inspired by bee colony):
  //   • SCOUT - Explore unknown territory, find resources
  //   • FORAGER - Collect resources from known locations
  //   • GUARD - Defend the hive/base
  //   • NURSE - Care for young drones, maintenance
  //   • BUILDER - Construct/repair structures
  //   • QUEEN ESCORT - Protect high-value targets
  //   • DANCER - Communicate information to colony
  //   • UNDERTAKER - Handle failed/damaged drones
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Drone role
  public type DroneRole = {
    #Scout;
    #Forager;
    #Guard;
    #Nurse;
    #Builder;
    #QueenEscort;
    #Dancer;
    #Undertaker;
  };

  /// Role state and history
  public type RoleState = {
    // Current role
    currentRole     : DroneRole;
    roleConfidence  : Float;
    timeInRole      : Nat;
    
    // Innate tendencies (set at birth)
    innateTendencies : [(DroneRole, Float)];
    
    // Role proficiency (improves with experience)
    roleProficiency : [(DroneRole, Float)];
    
    // Role switching
    switchCooldown  : Nat;
    lastSwitch      : Nat;
    
    // Colony needs (from hive mind)
    colonyNeeds     : [(DroneRole, Float)];
    
    // Role history
    roleHistory     : [(DroneRole, Nat, Nat)];  // (role, startBeat, endBeat)
  };

  /// Determine role at birth based on colony state and genetics
  public func determineInitialRole(
    droneId: Nat,
    colonyNeeds: [(DroneRole, Float)],
    parentRole: ?DroneRole
  ) : RoleState {
    // Generate innate tendencies based on ID (pseudo-genetic)
    let seed = droneId * 12345 + 67890;
    
    var tendencies : [(DroneRole, Float)] = [];
    let roles : [DroneRole] = [#Scout, #Forager, #Guard, #Nurse, #Builder, #QueenEscort, #Dancer, #Undertaker];
    
    for (i in Iter.range(0, 7)) {
      let hash = (seed + i * 31337) % 1000;
      let tendency = Float.fromInt(hash) / 1000.0;
      tendencies := Array.append(tendencies, [(roles[i], tendency)]);
    };
    
    // Boost tendency based on parent role (inheritance)
    switch (parentRole) {
      case (?pRole) {
        let newTendencies = Array.map<(DroneRole, Float), (DroneRole, Float)>(tendencies, func((r, t)) {
          switch (r, pRole) {
            case (#Scout, #Scout) { (r, t * 1.3) };
            case (#Forager, #Forager) { (r, t * 1.3) };
            case (#Guard, #Guard) { (r, t * 1.3) };
            case _ { (r, t) };
          }
        });
        tendencies := newTendencies;
      };
      case null { };
    };
    
    // Select initial role based on tendencies and colony needs
    var bestRole : DroneRole = #Forager;
    var bestScore : Float = 0.0;
    
    for ((role, tendency) in tendencies.vals()) {
      var need : Float = 0.5;
      for ((r, n) in colonyNeeds.vals()) {
        switch (r, role) {
          case (#Scout, #Scout) { need := n };
          case (#Forager, #Forager) { need := n };
          case (#Guard, #Guard) { need := n };
          case (#Nurse, #Nurse) { need := n };
          case (#Builder, #Builder) { need := n };
          case (#QueenEscort, #QueenEscort) { need := n };
          case (#Dancer, #Dancer) { need := n };
          case (#Undertaker, #Undertaker) { need := n };
          case _ { };
        };
      };
      
      let score = tendency * 0.6 + need * 0.4;
      if (score > bestScore) {
        bestScore := score;
        bestRole := role;
      };
    };
    
    {
      currentRole = bestRole;
      roleConfidence = bestScore;
      timeInRole = 0;
      innateTendencies = tendencies;
      roleProficiency = Array.map<DroneRole, (DroneRole, Float)>(roles, func(r) { (r, 0.1) });
      switchCooldown = 100;
      lastSwitch = 0;
      colonyNeeds = colonyNeeds;
      roleHistory = [];
    }
  };

  /// Role-specific behaviors
  public func getRoleBehaviors(role: DroneRole) : {
    explorationRadius: Float;
    maxDistanceFromHive: Float;
    communicationPriority: Float;
    riskTolerance: Float;
    energyReserve: Float;
    returnThreshold: Float;
  } {
    switch (role) {
      case (#Scout) {
        {
          explorationRadius = 1000.0;      // 1km exploration
          maxDistanceFromHive = 5000.0;    // Can go 5km away
          communicationPriority = 0.9;     // Must report findings
          riskTolerance = 0.7;             // Accept moderate risk
          energyReserve = 0.3;             // Return at 30% battery
          returnThreshold = 0.4;           // Return trigger
        }
      };
      case (#Forager) {
        {
          explorationRadius = 200.0;       // Focused area
          maxDistanceFromHive = 3000.0;
          communicationPriority = 0.5;
          riskTolerance = 0.4;
          energyReserve = 0.25;
          returnThreshold = 0.3;
        }
      };
      case (#Guard) {
        {
          explorationRadius = 100.0;       // Patrol zone
          maxDistanceFromHive = 500.0;     // Stay close
          communicationPriority = 0.95;    // Alert priority
          riskTolerance = 0.9;             // Will engage threats
          energyReserve = 0.5;             // Stay ready
          returnThreshold = 0.6;
        }
      };
      case (#Nurse) {
        {
          explorationRadius = 50.0;
          maxDistanceFromHive = 100.0;     // Stay at base
          communicationPriority = 0.6;
          riskTolerance = 0.2;
          energyReserve = 0.4;
          returnThreshold = 0.5;
        }
      };
      case (#Builder) {
        {
          explorationRadius = 150.0;
          maxDistanceFromHive = 200.0;
          communicationPriority = 0.4;
          riskTolerance = 0.3;
          energyReserve = 0.35;
          returnThreshold = 0.4;
        }
      };
      case (#QueenEscort) {
        {
          explorationRadius = 50.0;        // Stay with queen
          maxDistanceFromHive = 10000.0;   // Follow anywhere
          communicationPriority = 1.0;     // Highest priority
          riskTolerance = 1.0;             // Will sacrifice self
          energyReserve = 0.2;
          returnThreshold = 0.25;
        }
      };
      case (#Dancer) {
        {
          explorationRadius = 500.0;
          maxDistanceFromHive = 1000.0;
          communicationPriority = 1.0;     // Communication is primary role
          riskTolerance = 0.3;
          energyReserve = 0.4;
          returnThreshold = 0.5;
        }
      };
      case (#Undertaker) {
        {
          explorationRadius = 300.0;
          maxDistanceFromHive = 2000.0;
          communicationPriority = 0.7;
          riskTolerance = 0.5;
          energyReserve = 0.35;
          returnThreshold = 0.4;
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 18: SWARM COMMUNICATION — WAGGLE DANCE & PHEROMONES
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Drones communicate like bees using:
  //   • Waggle dance - Encode direction and distance to targets
  //   • Pheromone trails - Mark paths, warn of danger, recruit help
  //   • Trophallaxis - Direct information exchange between drones
  //   • Quorum sensing - Collective decision making
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Communication message types
  public type SwarmMessage = {
    #WaggleDance : WaggleDanceMessage;
    #Pheromone : PheromoneMessage;
    #Trophallaxis : TrophallaxisMessage;
    #QuorumVote : QuorumVoteMessage;
    #Alert : AlertMessage;
    #Heartbeat : HeartbeatMessage;
  };

  /// Waggle dance message (direction and distance to target)
  public type WaggleDanceMessage = {
    senderId        : Nat;
    timestamp       : Nat;
    targetType      : Text;         // "food", "nest_site", "threat", "interesting"
    
    // Direction encoding (angle from sun/reference)
    direction       : Float;        // Radians
    directionConfidence : Float;
    
    // Distance encoding (duration of waggle)
    distance        : Float;        // Meters
    distanceConfidence : Float;
    
    // Quality assessment
    quality         : Float;        // 0-1
    urgency         : Float;        // 0-1
    
    // Dance parameters (how energetic)
    waggleDuration  : Float;
    waggleFrequency : Float;
    returnRunDuration : Float;
    
    // Recruitment strength
    recruitmentStrength : Float;
  };

  /// Pheromone message (chemical trail equivalent)
  public type PheromoneMessage = {
    senderId        : Nat;
    timestamp       : Nat;
    
    // Location of pheromone
    position        : { lat: Float; lon: Float; alt: Float };
    
    // Pheromone type
    pheromoneType   : PheromoneType;
    
    // Strength (decays over time)
    strength        : Float;
    decayRate       : Float;
    
    // Message content depends on type
    payload         : [Float];
  };

  /// Pheromone types
  public type PheromoneType = {
    #Trail;           // Path marking
    #Alarm;           // Danger warning
    #Recruitment;     // Call for help
    #Home;            // Nest entrance marker
    #Food;            // Food source marker
    #Queen;           // Queen presence
    #Aggregation;     // Gathering signal
  };

  /// Trophallaxis (direct information exchange)
  public type TrophallaxisMessage = {
    senderId        : Nat;
    receiverId      : Nat;
    timestamp       : Nat;
    
    // Information type
    infoType        : Text;         // "map_data", "threat_info", "resource_info", "state_sync"
    
    // Data payload
    data            : [Float];
    
    // Priority
    priority        : Float;
    
    // Acknowledgment required
    requiresAck     : Bool;
  };

  /// Quorum vote
  public type QuorumVoteMessage = {
    senderId        : Nat;
    timestamp       : Nat;
    
    // Decision topic
    topic           : Text;
    options         : [Text];
    
    // Vote
    vote            : Nat;          // Index of chosen option
    voteStrength    : Float;        // How strongly held
    
    // Context
    reasoning       : [Float];      // Encoded reasoning
  };

  /// Alert message
  public type AlertMessage = {
    senderId        : Nat;
    timestamp       : Nat;
    
    // Alert type
    alertType       : Text;         // "threat", "lost", "low_battery", "malfunction", "opportunity"
    severity        : Float;        // 0-1
    
    // Location
    location        : ?{ lat: Float; lon: Float; alt: Float };
    
    // Details
    details         : [Float];
    
    // Response requested
    responseNeeded  : Bool;
  };

  /// Heartbeat message
  public type HeartbeatMessage = {
    senderId        : Nat;
    timestamp       : Nat;
    
    // State summary
    position        : { lat: Float; lon: Float; alt: Float };
    battery         : Float;
    health          : Float;
    currentRole     : DroneRole;
    currentActivity : Text;
    
    // Neighbors known
    knownNeighbors  : [Nat];
  };

  /// Communication state for a drone
  public type DroneCommState = {
    // Message queues
    inboxWaggle     : [WaggleDanceMessage];
    inboxPheromone  : [PheromoneMessage];
    inboxTrophallaxis : [TrophallaxisMessage];
    inboxQuorum     : [QuorumVoteMessage];
    inboxAlert      : [AlertMessage];
    
    // Outbox
    pendingMessages : [SwarmMessage];
    
    // Known colony members
    knownDrones     : [{ id: Nat; lastHeard: Nat; position: ?{ lat: Float; lon: Float; alt: Float } }];
    
    // Pheromone map (local cache)
    localPheromoneMap : [[PheromoneMessage]];
    
    // Communication metrics
    messagesReceived : Nat;
    messagesSent    : Nat;
    failedTransmissions : Nat;
    
    // Signal quality
    signalStrength  : Float;
    noiseLevel      : Float;
  };

  /// Encode waggle dance from target location
  public func encodeWaggleDance(
    senderPosition: { lat: Float; lon: Float; alt: Float },
    targetPosition: { lat: Float; lon: Float; alt: Float },
    sunAzimuth: Float,
    targetQuality: Float,
    senderId: Nat,
    timestamp: Nat
  ) : WaggleDanceMessage {
    // Calculate direction relative to sun
    let dx = targetPosition.lon - senderPosition.lon;
    let dy = targetPosition.lat - senderPosition.lat;
    let targetAzimuth = Float.arctan2(dx, dy);
    let relativeDirection = targetAzimuth - sunAzimuth;
    
    // Calculate distance
    let latDiff = (targetPosition.lat - senderPosition.lat) * 111000.0;  // Approx meters per degree
    let lonDiff = (targetPosition.lon - senderPosition.lon) * 111000.0 * Float.cos(senderPosition.lat * PI / 180.0);
    let distance = Float.sqrt(latDiff * latDiff + lonDiff * lonDiff);
    
    // Dance parameters scale with distance and quality
    let waggleDuration = distance / 1000.0;  // 1 second per km
    let waggleFrequency = 10.0 + targetQuality * 5.0;  // 10-15 Hz
    let returnRunDuration = 0.5 + distance / 5000.0;
    
    {
      senderId = senderId;
      timestamp = timestamp;
      targetType = "resource";
      direction = relativeDirection;
      directionConfidence = 0.9;
      distance = distance;
      distanceConfidence = 0.85;
      quality = targetQuality;
      urgency = targetQuality * 0.8;
      waggleDuration = waggleDuration;
      waggleFrequency = waggleFrequency;
      returnRunDuration = returnRunDuration;
      recruitmentStrength = targetQuality * 0.7;
    }
  };

  /// Decode waggle dance to target location
  public func decodeWaggleDance(
    dance: WaggleDanceMessage,
    receiverPosition: { lat: Float; lon: Float; alt: Float },
    sunAzimuth: Float
  ) : { lat: Float; lon: Float; alt: Float; confidence: Float } {
    // Reconstruct absolute direction
    let targetAzimuth = dance.direction + sunAzimuth;
    
    // Reconstruct distance
    let distance = dance.distance;
    
    // Calculate target position
    let dy = distance * Float.cos(targetAzimuth) / 111000.0;
    let dx = distance * Float.sin(targetAzimuth) / (111000.0 * Float.cos(receiverPosition.lat * PI / 180.0));
    
    {
      lat = receiverPosition.lat + dy;
      lon = receiverPosition.lon + dx;
      alt = receiverPosition.alt;  // Assume same altitude
      confidence = dance.directionConfidence * dance.distanceConfidence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 19: COMPLETE DRONE AVATAR — FULL INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  // The complete drone as a living entity with brain, body, and social nature
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Complete drone avatar state
  public type CompleteDroneAvatar = {
    // Identity
    droneId         : Nat;
    squadronId      : Nat;
    name            : Text;
    birthBeat       : Nat;
    
    // Brain (central processing)
    brain           : DroneBrainCore;
    
    // Body (distributed nodes)
    body            : DistributedBodyNetwork;
    
    // Role and social
    role            : RoleState;
    communication   : DroneCommState;
    
    // Physical state (from sensors)
    physicalState   : BodyStateEstimate;
    
    // Hardware interface
    hardwareInterface : HardwareInterfaceState;
    
    // Mission state
    currentMission  : ?MissionState;
    missionHistory  : [MissionRecord];
    
    // Lifecycle
    isActive        : Bool;
    lifecycleStage  : LifecycleStage;
    
    // Global metrics
    overallHealth   : Float;
    performance     : Float;
    trustScore      : Float;
    
    // Timing
    beatNum         : Nat;
  };

  /// Hardware interface state
  public type HardwareInterfaceState = {
    // Connection status
    isConnected     : Bool;
    connectionType  : Text;         // "mavlink", "ros", "custom"
    lastHeartbeat   : Nat;
    
    // Autopilot state
    autopilotType   : Text;         // "ardupilot", "px4", "betaflight"
    armed           : Bool;
    flightMode      : Text;
    
    // Telemetry rates
    telemetryRate   : Float;
    commandRate     : Float;
    
    // Buffer states
    txBufferUsage   : Float;
    rxBufferUsage   : Float;
    
    // Error tracking
    errorCount      : Nat;
    lastError       : ?Text;
  };

  /// Mission state
  public type MissionState = {
    missionId       : Nat;
    missionType     : Text;
    objectives      : [MissionObjective];
    currentObjective : Nat;
    progress        : Float;
    startBeat       : Nat;
    estimatedCompletion : Nat;
    priority        : Float;
  };

  /// Mission objective
  public type MissionObjective = {
    objectiveId     : Nat;
    objectiveType   : Text;
    targetLocation  : ?{ lat: Float; lon: Float; alt: Float };
    parameters      : [Float];
    completed       : Bool;
    completionTime  : ?Nat;
  };

  /// Mission record (history)
  public type MissionRecord = {
    missionId       : Nat;
    missionType     : Text;
    startBeat       : Nat;
    endBeat         : Nat;
    success         : Bool;
    performance     : Float;
    notes           : Text;
  };

  /// Lifecycle stage
  public type LifecycleStage = {
    #Initializing;
    #Calibrating;
    #Ready;
    #Active;
    #Returning;
    #Charging;
    #Maintenance;
    #Standby;
    #Emergency;
    #Decommissioned;
  };

  /// Initialize complete drone avatar
  public func initCompleteDroneAvatar(
    droneId: Nat,
    squadronId: Nat,
    position: { lat: Float; lon: Float; alt: Float },
    colonyNeeds: [(DroneRole, Float)]
  ) : CompleteDroneAvatar {
    // Initialize brain
    let brain = initDroneBrain(droneId);
    
    // Initialize body
    let body = initDistributedBody(4);  // Quadcopter
    
    // Determine role
    let role = determineInitialRole(droneId, colonyNeeds, null);
    
    // Initialize communication
    let comm : DroneCommState = {
      inboxWaggle = [];
      inboxPheromone = [];
      inboxTrophallaxis = [];
      inboxQuorum = [];
      inboxAlert = [];
      pendingMessages = [];
      knownDrones = [];
      localPheromoneMap = [[]];
      messagesReceived = 0;
      messagesSent = 0;
      failedTransmissions = 0;
      signalStrength = 1.0;
      noiseLevel = 0.1;
    };
    
    // Physical state
    let physState : BodyStateEstimate = {
      position = position;
      velocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
      acceleration = { ax = 0.0; ay = 0.0; az = 0.0 };
      orientation = { roll = 0.0; pitch = 0.0; yaw = 0.0 };
      angularVelocity = { p = 0.0; q = 0.0; r = 0.0 };
      positionUncertainty = 2.0;
      orientationUncertainty = 0.1;
    };
    
    // Hardware interface
    let hw : HardwareInterfaceState = {
      isConnected = true;
      connectionType = "mavlink";
      lastHeartbeat = 0;
      autopilotType = "ardupilot";
      armed = false;
      flightMode = "STABILIZE";
      telemetryRate = 10.0;
      commandRate = 50.0;
      txBufferUsage = 0.0;
      rxBufferUsage = 0.0;
      errorCount = 0;
      lastError = null;
    };
    
    {
      droneId = droneId;
      squadronId = squadronId;
      name = "Drone_" # Nat.toText(droneId);
      birthBeat = 0;
      brain = brain;
      body = body;
      role = role;
      communication = comm;
      physicalState = physState;
      hardwareInterface = hw;
      currentMission = null;
      missionHistory = [];
      isActive = true;
      lifecycleStage = #Initializing;
      overallHealth = 1.0;
      performance = 0.5;
      trustScore = 0.5;
      beatNum = 0;
    }
  };

  /// Initialize drone brain
  func initDroneBrain(droneId: Nat) : DroneBrainCore {
    {
      droneId = droneId;
      squadronId = droneId / 10;
      birthBeat = 0;
      age = 0;
      prefrontalCortex = initPrefrontalCortex();
      motorCortex = initMotorCortex();
      sensoryCortex = initSensoryCortex();
      hippocampus = initHippocampus();
      amygdala = initAmygdala();
      cerebellum = initCerebellum();
      basalGanglia = initBasalGanglia();
      thalamus = initThalamus();
      globalWorkspace = Array.tabulate<Float>(50, func(_) { 0.0 });
      consciousnessLevel = 0.5;
      arousalLevel = 0.5;
      vigilanceLevel = 0.5;
      dopamine = 0.5;
      norepinephrine = 0.5;
      serotonin = 0.5;
      acetylcholine = 0.5;
      metabolicEnergy = 1.0;
      oxygenLevel = 1.0;
      learningRate = 0.1;
      plasticity = 0.5;
      beatNum = 0;
    }
  };

  func initPrefrontalCortex() : PrefrontalCortexState {
    {
      currentGoal = {
        goalType = "idle";
        targetLocation = null;
        priority = 0.0;
        urgency = 0.0;
        progress = 0.0;
        timeLimit = null;
      };
      goalStack = [];
      intentionStrength = 0.0;
      workingMemory = Array.tabulate<Float>(7, func(_) { 0.0 });  // 7±2 items
      wmCapacity = 7;
      currentPlan = [];
      planHorizon = 10;
      planConfidence = 0.0;
      decisionOptions = [];
      currentDecision = null;
      decisionCertainty = 0.0;
      inhibitionStrength = 0.5;
      flexibilityScore = 0.5;
      taskSwitchCost = 0.2;
    }
  };

  func initMotorCortex() : MotorCortexState {
    {
      currentCommand = {
        thrust = 0.0;
        roll = 0.0;
        pitch = 0.0;
        yaw = 0.0;
        motorSpeeds = [0.0, 0.0, 0.0, 0.0];
        timestamp = 0;
        duration = 0;
        priority = 0.0;
      };
      commandQueue = [];
      plannedTrajectory = [];
      trajectoryProgress = 0.0;
      activePrimitives = [];
      motorCoordination = 0.8;
      movementSmoothing = 0.9;
      proprioceptiveFeedback = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      motorErrorSignal = 0.0;
    }
  };

  func initSensoryCortex() : SensoryCortexState {
    let emptyGrid : [[Float]] = Array.tabulate<[Float]>(10, func(_) {
      Array.tabulate<Float>(10, func(_) { 0.0 })
    });
    {
      visualField = emptyGrid;
      visualSalience = emptyGrid;
      objectDetections = [];
      spatialMap = emptyGrid;
      obstacleMap = emptyGrid;
      auditoryInput = [];
      soundDirection = null;
      bodyState = {
        position = { lat = 0.0; lon = 0.0; alt = 0.0 };
        velocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
        acceleration = { ax = 0.0; ay = 0.0; az = -9.81 };
        orientation = { roll = 0.0; pitch = 0.0; yaw = 0.0 };
        angularVelocity = { p = 0.0; q = 0.0; r = 0.0 };
        positionUncertainty = 2.0;
        orientationUncertainty = 0.1;
      };
      fusedWorldState = {
        timestamp = 0;
        selfState = {
          position = { lat = 0.0; lon = 0.0; alt = 0.0 };
          velocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
          acceleration = { ax = 0.0; ay = 0.0; az = 0.0 };
          orientation = { roll = 0.0; pitch = 0.0; yaw = 0.0 };
          angularVelocity = { p = 0.0; q = 0.0; r = 0.0 };
          positionUncertainty = 2.0;
          orientationUncertainty = 0.1;
        };
        nearbyDrones = [];
        obstacles = [];
        targets = [];
        threats = [];
        weatherConditions = { wind = { x = 0.0; y = 0.0; z = 0.0 }; visibility = 1.0 };
      };
      sensorReliability = [0.95, 0.95, 0.9, 0.9];
      attentionFocus = { x = 0.0; y = 0.0; z = 0.0 };
      attentionRadius = 10.0;
    }
  };

  func initHippocampus() : HippocampusState {
    {
      placeCells = [];
      currentPlaceCell = null;
      gridCells = [];
      gridPhase = [0.0, 0.0, 0.0];
      headDirectionCells = Array.tabulate<Float>(36, func(_) { 0.0 });  // 10 degree resolution
      currentHeading = 0.0;
      homeVector = { distance = 0.0; direction = 0.0 };
      pathIntegrationError = 0.0;
      exploredAreas = [[]];
      landmarkMemory = [];
      routeMemory = [];
      replayActive = false;
      replaySequence = [];
    }
  };

  func initAmygdala() : AmygdalaState {
    {
      threatLevel = 0.0;
      threatSource = null;
      fearMemories = [];
      rewardLevel = 0.5;
      rewardPrediction = 0.5;
      rewardPredictionError = 0.0;
      currentValence = 0.0;
      arousal = 0.3;
      approachDrive = 0.5;
      avoidanceDrive = 0.2;
      stressLevel = 0.1;
      cortisol = 0.1;
      stressRecoveryRate = 0.05;
    }
  };

  func initCerebellum() : CerebellumState {
    {
      forwardModels = [];
      inverseModels = [];
      internalClock = 0.0;
      timingPrecision = 0.95;
      rhythmPhase = 0.0;
      coordinationMatrix = [[]];
      smoothingFactor = 0.9;
      motorErrorHistory = [];
      adaptationRate = 0.1;
      predictedSensory = [];
      sensoryPredictionError = 0.0;
    }
  };

  func initBasalGanglia() : BasalGangliaState {
    {
      actionCandidates = [];
      selectedAction = null;
      selectionThreshold = 0.5;
      directPathwayActivity = [0.5, 0.5, 0.5, 0.5, 0.5];
      indirectPathwayActivity = [0.5, 0.5, 0.5, 0.5, 0.5];
      hyperdirectActivity = 0.0;
      dopamineLevel = 0.5;
      rewardPredictionError = 0.0;
      habitStrength = [0.1, 0.1, 0.1, 0.1, 0.1];
      explorationRate = 0.3;
    }
  };

  func initThalamus() : ThalamusState {
    {
      nucleiActivity = Array.tabulate<Float>(8, func(_) { 0.5 });
      gatingMatrix = [[]];
      attentionGates = Array.tabulate<Float>(5, func(_) { 1.0 });
      sensoryRelay = [];
      motorRelay = [];
      loopActivity = [];
      arousalSignal = 0.5;
      sleepPressure = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 20: DRONE BRAIN TICK — COMPLETE COGNITIVE CYCLE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Execute one cognitive cycle of the drone brain
  public func tickDroneBrain(
    avatar: CompleteDroneAvatar,
    sensorInputs: [Float],
    swarmMessages: [SwarmMessage],
    dt: Float
  ) : CompleteDroneAvatar {
    var newAvatar = avatar;
    
    // 1. Process sensory input
    newAvatar := processSensoryInput(newAvatar, sensorInputs);
    
    // 2. Update emotional state (amygdala)
    newAvatar := updateEmotionalState(newAvatar);
    
    // 3. Update spatial memory (hippocampus)
    newAvatar := updateSpatialMemory(newAvatar);
    
    // 4. Process swarm messages
    newAvatar := processSwarmMessages(newAvatar, swarmMessages);
    
    // 5. Make decisions (prefrontal cortex + basal ganglia)
    newAvatar := makeDecisions(newAvatar);
    
    // 6. Generate motor commands (motor cortex + cerebellum)
    newAvatar := generateMotorCommands(newAvatar, dt);
    
    // 7. Update neuromodulators
    newAvatar := updateNeuromodulators(newAvatar, dt);
    
    // 8. Update body nodes
    newAvatar := updateBodyNodes(newAvatar, dt);
    
    // 9. Generate outgoing messages
    newAvatar := generateSwarmMessages(newAvatar);
    
    // 10. Update lifecycle and metrics
    newAvatar := updateLifecycle(newAvatar);
    
    // Update beat counter
    {
      droneId = newAvatar.droneId;
      squadronId = newAvatar.squadronId;
      name = newAvatar.name;
      birthBeat = newAvatar.birthBeat;
      brain = {
        droneId = newAvatar.brain.droneId;
        squadronId = newAvatar.brain.squadronId;
        birthBeat = newAvatar.brain.birthBeat;
        age = newAvatar.brain.age + 1;
        prefrontalCortex = newAvatar.brain.prefrontalCortex;
        motorCortex = newAvatar.brain.motorCortex;
        sensoryCortex = newAvatar.brain.sensoryCortex;
        hippocampus = newAvatar.brain.hippocampus;
        amygdala = newAvatar.brain.amygdala;
        cerebellum = newAvatar.brain.cerebellum;
        basalGanglia = newAvatar.brain.basalGanglia;
        thalamus = newAvatar.brain.thalamus;
        globalWorkspace = newAvatar.brain.globalWorkspace;
        consciousnessLevel = newAvatar.brain.consciousnessLevel;
        arousalLevel = newAvatar.brain.arousalLevel;
        vigilanceLevel = newAvatar.brain.vigilanceLevel;
        dopamine = newAvatar.brain.dopamine;
        norepinephrine = newAvatar.brain.norepinephrine;
        serotonin = newAvatar.brain.serotonin;
        acetylcholine = newAvatar.brain.acetylcholine;
        metabolicEnergy = newAvatar.brain.metabolicEnergy;
        oxygenLevel = newAvatar.brain.oxygenLevel;
        learningRate = newAvatar.brain.learningRate;
        plasticity = newAvatar.brain.plasticity;
        beatNum = newAvatar.brain.beatNum + 1;
      };
      body = newAvatar.body;
      role = {
        currentRole = newAvatar.role.currentRole;
        roleConfidence = newAvatar.role.roleConfidence;
        timeInRole = newAvatar.role.timeInRole + 1;
        innateTendencies = newAvatar.role.innateTendencies;
        roleProficiency = newAvatar.role.roleProficiency;
        switchCooldown = newAvatar.role.switchCooldown;
        lastSwitch = newAvatar.role.lastSwitch;
        colonyNeeds = newAvatar.role.colonyNeeds;
        roleHistory = newAvatar.role.roleHistory;
      };
      communication = newAvatar.communication;
      physicalState = newAvatar.physicalState;
      hardwareInterface = newAvatar.hardwareInterface;
      currentMission = newAvatar.currentMission;
      missionHistory = newAvatar.missionHistory;
      isActive = newAvatar.isActive;
      lifecycleStage = newAvatar.lifecycleStage;
      overallHealth = newAvatar.overallHealth;
      performance = newAvatar.performance;
      trustScore = newAvatar.trustScore;
      beatNum = newAvatar.beatNum + 1;
    }
  };

  /// Process sensory input
  func processSensoryInput(avatar: CompleteDroneAvatar, inputs: [Float]) : CompleteDroneAvatar {
    // Update body state from sensors
    let newBodyState : BodyStateEstimate = if (inputs.size() >= 12) {
      {
        position = { 
          lat = inputs[0]; 
          lon = inputs[1]; 
          alt = inputs[2] 
        };
        velocity = { 
          vx = inputs[3]; 
          vy = inputs[4]; 
          vz = inputs[5] 
        };
        acceleration = { 
          ax = inputs[6]; 
          ay = inputs[7]; 
          az = inputs[8] 
        };
        orientation = { 
          roll = inputs[9]; 
          pitch = inputs[10]; 
          yaw = inputs[11] 
        };
        angularVelocity = avatar.physicalState.angularVelocity;
        positionUncertainty = avatar.physicalState.positionUncertainty;
        orientationUncertainty = avatar.physicalState.orientationUncertainty;
      }
    } else {
      avatar.physicalState
    };
    
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      name = avatar.name;
      birthBeat = avatar.birthBeat;
      brain = avatar.brain;
      body = avatar.body;
      role = avatar.role;
      communication = avatar.communication;
      physicalState = newBodyState;
      hardwareInterface = avatar.hardwareInterface;
      currentMission = avatar.currentMission;
      missionHistory = avatar.missionHistory;
      isActive = avatar.isActive;
      lifecycleStage = avatar.lifecycleStage;
      overallHealth = avatar.overallHealth;
      performance = avatar.performance;
      trustScore = avatar.trustScore;
      beatNum = avatar.beatNum;
    }
  };

  /// Update emotional state
  func updateEmotionalState(avatar: CompleteDroneAvatar) : CompleteDroneAvatar {
    let amyg = avatar.brain.amygdala;
    
    // Compute threat level from nearby threats
    var threatLevel = amyg.threatLevel * 0.9;  // Decay
    for (threat in avatar.brain.sensoryCortex.fusedWorldState.threats.vals()) {
      let dist = Float.sqrt(threat.pos.x**2.0 + threat.pos.y**2.0 + threat.pos.z**2.0);
      let threatContrib = threat.level / (1.0 + dist / 10.0);
      threatLevel := Float.min(threatLevel + threatContrib * 0.2, 1.0);
    };
    
    // Update valence based on rewards and threats
    let newValence = (amyg.rewardLevel - threatLevel) * 0.5;
    
    // Update arousal
    let newArousal = Float.min(amyg.arousal * 0.95 + threatLevel * 0.1, 1.0);
    
    // Update approach/avoidance drives
    let newApproach = Float.max(amyg.rewardPrediction - threatLevel * 0.5, 0.0);
    let newAvoidance = Float.min(threatLevel * 1.5, 1.0);
    
    let newAmygdala : AmygdalaState = {
      threatLevel = threatLevel;
      threatSource = amyg.threatSource;
      fearMemories = amyg.fearMemories;
      rewardLevel = amyg.rewardLevel;
      rewardPrediction = amyg.rewardPrediction;
      rewardPredictionError = amyg.rewardPredictionError;
      currentValence = newValence;
      arousal = newArousal;
      approachDrive = newApproach;
      avoidanceDrive = newAvoidance;
      stressLevel = amyg.stressLevel * 0.99 + threatLevel * 0.01;
      cortisol = amyg.cortisol * 0.99 + amyg.stressLevel * 0.01;
      stressRecoveryRate = amyg.stressRecoveryRate;
    };
    
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      name = avatar.name;
      birthBeat = avatar.birthBeat;
      brain = {
        droneId = avatar.brain.droneId;
        squadronId = avatar.brain.squadronId;
        birthBeat = avatar.brain.birthBeat;
        age = avatar.brain.age;
        prefrontalCortex = avatar.brain.prefrontalCortex;
        motorCortex = avatar.brain.motorCortex;
        sensoryCortex = avatar.brain.sensoryCortex;
        hippocampus = avatar.brain.hippocampus;
        amygdala = newAmygdala;
        cerebellum = avatar.brain.cerebellum;
        basalGanglia = avatar.brain.basalGanglia;
        thalamus = avatar.brain.thalamus;
        globalWorkspace = avatar.brain.globalWorkspace;
        consciousnessLevel = avatar.brain.consciousnessLevel;
        arousalLevel = newArousal;
        vigilanceLevel = Float.min(avatar.brain.vigilanceLevel * 0.9 + threatLevel * 0.2, 1.0);
        dopamine = avatar.brain.dopamine;
        norepinephrine = avatar.brain.norepinephrine;
        serotonin = avatar.brain.serotonin;
        acetylcholine = avatar.brain.acetylcholine;
        metabolicEnergy = avatar.brain.metabolicEnergy;
        oxygenLevel = avatar.brain.oxygenLevel;
        learningRate = avatar.brain.learningRate;
        plasticity = avatar.brain.plasticity;
        beatNum = avatar.brain.beatNum;
      };
      body = avatar.body;
      role = avatar.role;
      communication = avatar.communication;
      physicalState = avatar.physicalState;
      hardwareInterface = avatar.hardwareInterface;
      currentMission = avatar.currentMission;
      missionHistory = avatar.missionHistory;
      isActive = avatar.isActive;
      lifecycleStage = avatar.lifecycleStage;
      overallHealth = avatar.overallHealth;
      performance = avatar.performance;
      trustScore = avatar.trustScore;
      beatNum = avatar.beatNum;
    }
  };

  /// Update spatial memory (simplified)
  func updateSpatialMemory(avatar: CompleteDroneAvatar) : CompleteDroneAvatar {
    let hipp = avatar.brain.hippocampus;
    let pos = avatar.physicalState.position;
    let vel = avatar.physicalState.velocity;
    
    // Update path integration
    let speed = Float.sqrt(vel.vx**2.0 + vel.vy**2.0 + vel.vz**2.0);
    let newHomeDistance = Float.sqrt(
      (pos.lat - 32.7767)**2.0 + (pos.lon + 96.7970)**2.0
    ) * 111000.0;  // Approx meters
    
    let newHomeDirection = Float.arctan2(
      32.7767 - pos.lat,
      -96.7970 - pos.lon
    );
    
    // Update head direction cells
    let currentHeading = avatar.physicalState.orientation.yaw;
    let newHDCells = Array.tabulate<Float>(36, func(i) {
      let preferred = Float.fromInt(i) * 10.0 * PI / 180.0;
      let diff = currentHeading - preferred;
      Float.exp(2.0 * Float.cos(diff)) / Float.exp(2.0)
    });
    
    let newHippocampus : HippocampusState = {
      placeCells = hipp.placeCells;
      currentPlaceCell = hipp.currentPlaceCell;
      gridCells = hipp.gridCells;
      gridPhase = [
        hipp.gridPhase[0] + vel.vx * 0.01,
        hipp.gridPhase[1] + vel.vy * 0.01,
        hipp.gridPhase[2] + vel.vz * 0.01
      ];
      headDirectionCells = newHDCells;
      currentHeading = currentHeading;
      homeVector = { distance = newHomeDistance; direction = newHomeDirection };
      pathIntegrationError = hipp.pathIntegrationError * 1.001;  // Error accumulates
      exploredAreas = hipp.exploredAreas;
      landmarkMemory = hipp.landmarkMemory;
      routeMemory = hipp.routeMemory;
      replayActive = hipp.replayActive;
      replaySequence = hipp.replaySequence;
    };
    
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      name = avatar.name;
      birthBeat = avatar.birthBeat;
      brain = {
        droneId = avatar.brain.droneId;
        squadronId = avatar.brain.squadronId;
        birthBeat = avatar.brain.birthBeat;
        age = avatar.brain.age;
        prefrontalCortex = avatar.brain.prefrontalCortex;
        motorCortex = avatar.brain.motorCortex;
        sensoryCortex = avatar.brain.sensoryCortex;
        hippocampus = newHippocampus;
        amygdala = avatar.brain.amygdala;
        cerebellum = avatar.brain.cerebellum;
        basalGanglia = avatar.brain.basalGanglia;
        thalamus = avatar.brain.thalamus;
        globalWorkspace = avatar.brain.globalWorkspace;
        consciousnessLevel = avatar.brain.consciousnessLevel;
        arousalLevel = avatar.brain.arousalLevel;
        vigilanceLevel = avatar.brain.vigilanceLevel;
        dopamine = avatar.brain.dopamine;
        norepinephrine = avatar.brain.norepinephrine;
        serotonin = avatar.brain.serotonin;
        acetylcholine = avatar.brain.acetylcholine;
        metabolicEnergy = avatar.brain.metabolicEnergy;
        oxygenLevel = avatar.brain.oxygenLevel;
        learningRate = avatar.brain.learningRate;
        plasticity = avatar.brain.plasticity;
        beatNum = avatar.brain.beatNum;
      };
      body = avatar.body;
      role = avatar.role;
      communication = avatar.communication;
      physicalState = avatar.physicalState;
      hardwareInterface = avatar.hardwareInterface;
      currentMission = avatar.currentMission;
      missionHistory = avatar.missionHistory;
      isActive = avatar.isActive;
      lifecycleStage = avatar.lifecycleStage;
      overallHealth = avatar.overallHealth;
      performance = avatar.performance;
      trustScore = avatar.trustScore;
      beatNum = avatar.beatNum;
    }
  };

  /// Process swarm messages
  func processSwarmMessages(avatar: CompleteDroneAvatar, messages: [SwarmMessage]) : CompleteDroneAvatar {
    var newComm = avatar.communication;
    
    for (msg in messages.vals()) {
      switch (msg) {
        case (#WaggleDance(dance)) {
          newComm := {
            inboxWaggle = Array.append(newComm.inboxWaggle, [dance]);
            inboxPheromone = newComm.inboxPheromone;
            inboxTrophallaxis = newComm.inboxTrophallaxis;
            inboxQuorum = newComm.inboxQuorum;
            inboxAlert = newComm.inboxAlert;
            pendingMessages = newComm.pendingMessages;
            knownDrones = newComm.knownDrones;
            localPheromoneMap = newComm.localPheromoneMap;
            messagesReceived = newComm.messagesReceived + 1;
            messagesSent = newComm.messagesSent;
            failedTransmissions = newComm.failedTransmissions;
            signalStrength = newComm.signalStrength;
            noiseLevel = newComm.noiseLevel;
          };
        };
        case (#Alert(alert)) {
          newComm := {
            inboxWaggle = newComm.inboxWaggle;
            inboxPheromone = newComm.inboxPheromone;
            inboxTrophallaxis = newComm.inboxTrophallaxis;
            inboxQuorum = newComm.inboxQuorum;
            inboxAlert = Array.append(newComm.inboxAlert, [alert]);
            pendingMessages = newComm.pendingMessages;
            knownDrones = newComm.knownDrones;
            localPheromoneMap = newComm.localPheromoneMap;
            messagesReceived = newComm.messagesReceived + 1;
            messagesSent = newComm.messagesSent;
            failedTransmissions = newComm.failedTransmissions;
            signalStrength = newComm.signalStrength;
            noiseLevel = newComm.noiseLevel;
          };
        };
        case _ { };
      };
    };
    
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      name = avatar.name;
      birthBeat = avatar.birthBeat;
      brain = avatar.brain;
      body = avatar.body;
      role = avatar.role;
      communication = newComm;
      physicalState = avatar.physicalState;
      hardwareInterface = avatar.hardwareInterface;
      currentMission = avatar.currentMission;
      missionHistory = avatar.missionHistory;
      isActive = avatar.isActive;
      lifecycleStage = avatar.lifecycleStage;
      overallHealth = avatar.overallHealth;
      performance = avatar.performance;
      trustScore = avatar.trustScore;
      beatNum = avatar.beatNum;
    }
  };

  /// Make decisions (simplified)
  func makeDecisions(avatar: CompleteDroneAvatar) : CompleteDroneAvatar {
    // For now, return unchanged - full implementation would use basal ganglia selection
    avatar
  };

  /// Generate motor commands (simplified)
  func generateMotorCommands(avatar: CompleteDroneAvatar, dt: Float) : CompleteDroneAvatar {
    // Generate commands based on current goal
    let goal = avatar.brain.prefrontalCortex.currentGoal;
    
    var thrust : Float = 0.5;  // Hover
    var roll : Float = 0.0;
    var pitch : Float = 0.0;
    var yaw : Float = 0.0;
    
    switch (goal.targetLocation) {
      case (?target) {
        // Simple proportional control toward target
        let dx = target.lon - avatar.physicalState.position.lon;
        let dy = target.lat - avatar.physicalState.position.lat;
        let dz = target.alt - avatar.physicalState.position.alt;
        
        pitch := Float.min(Float.max(dy * 10.0, -0.3), 0.3);
        roll := Float.min(Float.max(-dx * 10.0, -0.3), 0.3);
        thrust := 0.5 + Float.min(Float.max(dz * 0.1, -0.2), 0.2);
      };
      case null { };
    };
    
    let newCommand : MotorCommand = {
      thrust = thrust;
      roll = roll;
      pitch = pitch;
      yaw = yaw;
      motorSpeeds = [
        thrust + roll + pitch,
        thrust - roll + pitch,
        thrust - roll - pitch,
        thrust + roll - pitch
      ];
      timestamp = avatar.beatNum;
      duration = 1;
      priority = 0.5;
    };
    
    let newMotorCortex : MotorCortexState = {
      currentCommand = newCommand;
      commandQueue = avatar.brain.motorCortex.commandQueue;
      plannedTrajectory = avatar.brain.motorCortex.plannedTrajectory;
      trajectoryProgress = avatar.brain.motorCortex.trajectoryProgress;
      activePrimitives = avatar.brain.motorCortex.activePrimitives;
      motorCoordination = avatar.brain.motorCortex.motorCoordination;
      movementSmoothing = avatar.brain.motorCortex.movementSmoothing;
      proprioceptiveFeedback = avatar.brain.motorCortex.proprioceptiveFeedback;
      motorErrorSignal = avatar.brain.motorCortex.motorErrorSignal;
    };
    
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      name = avatar.name;
      birthBeat = avatar.birthBeat;
      brain = {
        droneId = avatar.brain.droneId;
        squadronId = avatar.brain.squadronId;
        birthBeat = avatar.brain.birthBeat;
        age = avatar.brain.age;
        prefrontalCortex = avatar.brain.prefrontalCortex;
        motorCortex = newMotorCortex;
        sensoryCortex = avatar.brain.sensoryCortex;
        hippocampus = avatar.brain.hippocampus;
        amygdala = avatar.brain.amygdala;
        cerebellum = avatar.brain.cerebellum;
        basalGanglia = avatar.brain.basalGanglia;
        thalamus = avatar.brain.thalamus;
        globalWorkspace = avatar.brain.globalWorkspace;
        consciousnessLevel = avatar.brain.consciousnessLevel;
        arousalLevel = avatar.brain.arousalLevel;
        vigilanceLevel = avatar.brain.vigilanceLevel;
        dopamine = avatar.brain.dopamine;
        norepinephrine = avatar.brain.norepinephrine;
        serotonin = avatar.brain.serotonin;
        acetylcholine = avatar.brain.acetylcholine;
        metabolicEnergy = avatar.brain.metabolicEnergy - 0.001;  // Energy consumption
        oxygenLevel = avatar.brain.oxygenLevel;
        learningRate = avatar.brain.learningRate;
        plasticity = avatar.brain.plasticity;
        beatNum = avatar.brain.beatNum;
      };
      body = avatar.body;
      role = avatar.role;
      communication = avatar.communication;
      physicalState = avatar.physicalState;
      hardwareInterface = avatar.hardwareInterface;
      currentMission = avatar.currentMission;
      missionHistory = avatar.missionHistory;
      isActive = avatar.isActive;
      lifecycleStage = avatar.lifecycleStage;
      overallHealth = avatar.overallHealth;
      performance = avatar.performance;
      trustScore = avatar.trustScore;
      beatNum = avatar.beatNum;
    }
  };

  /// Update neuromodulators
  func updateNeuromodulators(avatar: CompleteDroneAvatar, dt: Float) : CompleteDroneAvatar {
    let brain = avatar.brain;
    
    // Dopamine increases with reward prediction error
    let newDopamine = Float.min(Float.max(
      brain.dopamine * 0.95 + brain.basalGanglia.rewardPredictionError * 0.1,
      0.0), 1.0);
    
    // Norepinephrine increases with arousal
    let newNE = Float.min(Float.max(
      brain.norepinephrine * 0.95 + brain.arousalLevel * 0.1,
      0.0), 1.0);
    
    // Serotonin decreases with stress
    let newSerotonin = Float.min(Float.max(
      brain.serotonin * 0.99 - brain.amygdala.stressLevel * 0.01,
      0.0), 1.0);
    
    // Acetylcholine increases with learning demands
    let newACh = Float.min(Float.max(
      brain.acetylcholine * 0.95 + brain.plasticity * 0.1,
      0.0), 1.0);
    
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      name = avatar.name;
      birthBeat = avatar.birthBeat;
      brain = {
        droneId = brain.droneId;
        squadronId = brain.squadronId;
        birthBeat = brain.birthBeat;
        age = brain.age;
        prefrontalCortex = brain.prefrontalCortex;
        motorCortex = brain.motorCortex;
        sensoryCortex = brain.sensoryCortex;
        hippocampus = brain.hippocampus;
        amygdala = brain.amygdala;
        cerebellum = brain.cerebellum;
        basalGanglia = brain.basalGanglia;
        thalamus = brain.thalamus;
        globalWorkspace = brain.globalWorkspace;
        consciousnessLevel = brain.consciousnessLevel;
        arousalLevel = brain.arousalLevel;
        vigilanceLevel = brain.vigilanceLevel;
        dopamine = newDopamine;
        norepinephrine = newNE;
        serotonin = newSerotonin;
        acetylcholine = newACh;
        metabolicEnergy = brain.metabolicEnergy;
        oxygenLevel = brain.oxygenLevel;
        learningRate = brain.learningRate * (0.9 + newACh * 0.2);
        plasticity = brain.plasticity;
        beatNum = brain.beatNum;
      };
      body = avatar.body;
      role = avatar.role;
      communication = avatar.communication;
      physicalState = avatar.physicalState;
      hardwareInterface = avatar.hardwareInterface;
      currentMission = avatar.currentMission;
      missionHistory = avatar.missionHistory;
      isActive = avatar.isActive;
      lifecycleStage = avatar.lifecycleStage;
      overallHealth = avatar.overallHealth;
      performance = avatar.performance;
      trustScore = avatar.trustScore;
      beatNum = avatar.beatNum;
    }
  };

  /// Update body nodes
  func updateBodyNodes(avatar: CompleteDroneAvatar, dt: Float) : CompleteDroneAvatar {
    // Update each body node based on motor commands and sensor readings
    let motorCmd = avatar.brain.motorCortex.currentCommand;
    
    var newNodes : [BodyNode] = [];
    var totalPower : Float = 0.0;
    
    for (node in avatar.body.nodes.vals()) {
      switch (node.nodeType) {
        case (#MotorNode({ motorId })) {
          // Update motor speed based on command
          let targetSpeed = if (motorId < motorCmd.motorSpeeds.size()) {
            motorCmd.motorSpeeds[motorId]
          } else { 0.0 };
          
          var newActuators : [LocalActuator] = [];
          for (act in node.localActuators.vals()) {
            let newState = act.actualState * 0.8 + targetSpeed * 0.2;  // Smooth transition
            totalPower += newState * newState * 10.0;  // Power ∝ speed²
            newActuators := Array.append(newActuators, [{
              actuatorId = act.actuatorId;
              actuatorType = act.actuatorType;
              currentCommand = targetSpeed;
              actualState = newState;
              responsiveness = act.responsiveness;
              health = act.health;
            }]);
          };
          
          newNodes := Array.append(newNodes, [{
            nodeId = node.nodeId;
            nodeType = node.nodeType;
            position = node.position;
            localActivation = targetSpeed;
            localMemory = node.localMemory;
            localSensors = node.localSensors;
            localActuators = newActuators;
            localReflex = node.localReflex;
            nodeHealth = node.nodeHealth;
            temperature = node.temperature + targetSpeed * 0.5 - 0.1;  // Heating/cooling
          }]);
        };
        case _ {
          newNodes := Array.append(newNodes, [node]);
        };
      };
    };
    
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      name = avatar.name;
      birthBeat = avatar.birthBeat;
      brain = avatar.brain;
      body = {
        nodes = newNodes;
        connections = avatar.body.connections;
        networkActivity = avatar.body.networkActivity;
        synchronization = avatar.body.synchronization;
        overallHealth = avatar.body.overallHealth;
        faultyNodes = avatar.body.faultyNodes;
        powerDistribution = avatar.body.powerDistribution;
        totalPowerDraw = totalPower;
      };
      role = avatar.role;
      communication = avatar.communication;
      physicalState = avatar.physicalState;
      hardwareInterface = avatar.hardwareInterface;
      currentMission = avatar.currentMission;
      missionHistory = avatar.missionHistory;
      isActive = avatar.isActive;
      lifecycleStage = avatar.lifecycleStage;
      overallHealth = avatar.overallHealth;
      performance = avatar.performance;
      trustScore = avatar.trustScore;
      beatNum = avatar.beatNum;
    }
  };

  /// Generate outgoing swarm messages
  func generateSwarmMessages(avatar: CompleteDroneAvatar) : CompleteDroneAvatar {
    // Generate heartbeat every 10 beats
    if (avatar.beatNum % 10 == 0) {
      let heartbeat : HeartbeatMessage = {
        senderId = avatar.droneId;
        timestamp = avatar.beatNum;
        position = avatar.physicalState.position;
        battery = avatar.brain.metabolicEnergy;
        health = avatar.overallHealth;
        currentRole = avatar.role.currentRole;
        currentActivity = avatar.brain.prefrontalCortex.currentGoal.goalType;
        knownNeighbors = [];
      };
      
      let newPending = Array.append(avatar.communication.pendingMessages, [#Heartbeat(heartbeat)]);
      
      return {
        droneId = avatar.droneId;
        squadronId = avatar.squadronId;
        name = avatar.name;
        birthBeat = avatar.birthBeat;
        brain = avatar.brain;
        body = avatar.body;
        role = avatar.role;
        communication = {
          inboxWaggle = avatar.communication.inboxWaggle;
          inboxPheromone = avatar.communication.inboxPheromone;
          inboxTrophallaxis = avatar.communication.inboxTrophallaxis;
          inboxQuorum = avatar.communication.inboxQuorum;
          inboxAlert = avatar.communication.inboxAlert;
          pendingMessages = newPending;
          knownDrones = avatar.communication.knownDrones;
          localPheromoneMap = avatar.communication.localPheromoneMap;
          messagesReceived = avatar.communication.messagesReceived;
          messagesSent = avatar.communication.messagesSent + 1;
          failedTransmissions = avatar.communication.failedTransmissions;
          signalStrength = avatar.communication.signalStrength;
          noiseLevel = avatar.communication.noiseLevel;
        };
        physicalState = avatar.physicalState;
        hardwareInterface = avatar.hardwareInterface;
        currentMission = avatar.currentMission;
        missionHistory = avatar.missionHistory;
        isActive = avatar.isActive;
        lifecycleStage = avatar.lifecycleStage;
        overallHealth = avatar.overallHealth;
        performance = avatar.performance;
        trustScore = avatar.trustScore;
        beatNum = avatar.beatNum;
      };
    };
    
    avatar
  };

  /// Update lifecycle
  func updateLifecycle(avatar: CompleteDroneAvatar) : CompleteDroneAvatar {
    // Compute overall health from body nodes
    var totalHealth : Float = 0.0;
    for (node in avatar.body.nodes.vals()) {
      totalHealth += node.nodeHealth;
    };
    let avgHealth = totalHealth / Float.fromInt(avatar.body.nodes.size());
    
    // Update lifecycle stage based on state
    let newStage : LifecycleStage = if (avatar.brain.metabolicEnergy < 0.15) {
      #Emergency
    } else if (avatar.brain.metabolicEnergy < 0.25) {
      #Returning
    } else if (avgHealth < 0.5) {
      #Maintenance
    } else {
      switch (avatar.lifecycleStage) {
        case (#Initializing) { 
          if (avatar.beatNum > 10) { #Calibrating } else { #Initializing }
        };
        case (#Calibrating) {
          if (avatar.beatNum > 50) { #Ready } else { #Calibrating }
        };
        case (#Ready) { #Active };
        case _ { avatar.lifecycleStage };
      }
    };
    
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      name = avatar.name;
      birthBeat = avatar.birthBeat;
      brain = avatar.brain;
      body = avatar.body;
      role = avatar.role;
      communication = avatar.communication;
      physicalState = avatar.physicalState;
      hardwareInterface = avatar.hardwareInterface;
      currentMission = avatar.currentMission;
      missionHistory = avatar.missionHistory;
      isActive = avatar.isActive and avgHealth > 0.1;
      lifecycleStage = newStage;
      overallHealth = avgHealth;
      performance = avatar.performance * 0.99 + avgHealth * 0.01;
      trustScore = avatar.trustScore;
      beatNum = avatar.beatNum;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 21: MASTER OUTPUT — DRONE AVATAR OUTPUT FOR ORGANISM
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Complete drone avatar output
  public type DroneAvatarOutput = {
    // Identity
    droneId         : Nat;
    squadronId      : Nat;
    role            : DroneRole;
    lifecycleStage  : LifecycleStage;
    
    // Physical
    position        : { lat: Float; lon: Float; alt: Float };
    velocity        : { vx: Float; vy: Float; vz: Float };
    orientation     : { roll: Float; pitch: Float; yaw: Float };
    
    // Brain state summary
    arousalLevel    : Float;
    vigilanceLevel  : Float;
    consciousnessLevel : Float;
    currentGoal     : Text;
    
    // Neuromodulators
    dopamine        : Float;
    norepinephrine  : Float;
    serotonin       : Float;
    acetylcholine   : Float;
    
    // Emotional state
    threatLevel     : Float;
    rewardLevel     : Float;
    valence         : Float;
    
    // Motor output
    motorCommand    : MotorCommand;
    
    // Health
    metabolicEnergy : Float;
    overallHealth   : Float;
    
    // Communication
    pendingMessageCount : Nat;
    receivedMessageCount : Nat;
    
    // Beat
    beatNum         : Nat;
  };

  public func generateDroneAvatarOutput(avatar: CompleteDroneAvatar) : DroneAvatarOutput {
    {
      droneId = avatar.droneId;
      squadronId = avatar.squadronId;
      role = avatar.role.currentRole;
      lifecycleStage = avatar.lifecycleStage;
      position = avatar.physicalState.position;
      velocity = avatar.physicalState.velocity;
      orientation = avatar.physicalState.orientation;
      arousalLevel = avatar.brain.arousalLevel;
      vigilanceLevel = avatar.brain.vigilanceLevel;
      consciousnessLevel = avatar.brain.consciousnessLevel;
      currentGoal = avatar.brain.prefrontalCortex.currentGoal.goalType;
      dopamine = avatar.brain.dopamine;
      norepinephrine = avatar.brain.norepinephrine;
      serotonin = avatar.brain.serotonin;
      acetylcholine = avatar.brain.acetylcholine;
      threatLevel = avatar.brain.amygdala.threatLevel;
      rewardLevel = avatar.brain.amygdala.rewardLevel;
      valence = avatar.brain.amygdala.currentValence;
      motorCommand = avatar.brain.motorCortex.currentCommand;
      metabolicEnergy = avatar.brain.metabolicEnergy;
      overallHealth = avatar.overallHealth;
      pendingMessageCount = avatar.communication.pendingMessages.size();
      receivedMessageCount = avatar.communication.messagesReceived;
      beatNum = avatar.beatNum;
    }
  };

}
