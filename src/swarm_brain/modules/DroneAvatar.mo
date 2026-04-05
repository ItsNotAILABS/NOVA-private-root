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

  // ═══════════════════════════════════════════════════════════════════════════════
  // ███████╗██╗   ██╗██╗     ██╗         ██████╗ ██████╗  █████╗ ██╗███╗   ██╗
  // ██╔════╝██║   ██║██║     ██║         ██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║
  // █████╗  ██║   ██║██║     ██║         ██████╔╝██████╔╝███████║██║██╔██╗ ██║
  // ██╔══╝  ██║   ██║██║     ██║         ██╔══██╗██╔══██╗██╔══██║██║██║╚██╗██║
  // ██║     ╚██████╔╝███████╗███████╗    ██████╔╝██║  ██║██║  ██║██║██║ ╚████║
  // ╚═╝      ╚═════╝ ╚══════╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 22: COMPLETE VISUAL CORTEX — REAL DRONE VISION PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Each drone has a complete visual processing system:
  //   • V1 - Primary visual cortex (edge detection, orientation)
  //   • V2 - Secondary visual (texture, depth, contour)
  //   • V4 - Color and form processing
  //   • MT/V5 - Motion processing
  //   • IT - Object recognition
  //   • Parietal - Spatial processing ("where" pathway)
  //   • Temporal - Object recognition ("what" pathway)
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Primary visual cortex (V1) state
  public type V1CortexState = {
    // Simple cells - orientation tuned
    simpleCells       : [[Float]];    // [orientation][spatial_freq]
    orientationTuning : [Float];      // Preferred orientations
    spatialFreqTuning : [Float];      // Preferred spatial frequencies
    
    // Complex cells - position invariant
    complexCells      : [Float];
    
    // Hypercomplex cells - end-stopped
    hypercomplexCells : [Float];
    
    // Receptive field properties
    rfCenter          : [(Float, Float)];  // (x, y) centers
    rfSize            : [Float];
    rfSurround        : [Float];     // Surround inhibition
    
    // Contrast processing
    contrastGain      : Float;
    adaptationState   : Float;
    
    // Output to higher areas
    outputToV2        : [Float];
    outputToMT        : [Float];
  };

  /// V2 cortex state
  public type V2CortexState = {
    // Texture processing
    textureUnits      : [[Float]];   // [texture_type][location]
    textureGradient   : [Float];
    
    // Border ownership
    borderOwnership   : [Float];     // Which side owns the border
    
    // Depth processing (stereo disparity)
    disparityTuning   : [Float];
    depthMap          : [[Float]];
    
    // Illusory contours
    illusoryContours  : [Float];
    
    // Color-form interactions
    colorFormBinding  : [[Float]];
  };

  /// V4 cortex state (color and form)
  public type V4CortexState = {
    // Color processing
    colorChannels     : [[Float]];   // [L-M, S-(L+M), luminance]
    colorConstancy    : Float;       // Adaptation to illumination
    
    // Shape primitives
    curvatureDetectors : [Float];
    angleDetectors    : [Float];
    
    // Attention modulation
    attentionGain     : [[Float]];
    
    // Figure-ground segregation
    figureGroundMap   : [[Float]];
  };

  /// MT/V5 cortex state (motion)
  public type MTCortexState = {
    // Direction-selective cells
    directionTuning   : [Float];     // Preferred directions
    speedTuning       : [Float];     // Preferred speeds
    
    // Local motion
    localMotionField  : [[Float]];   // [x][y] -> (dx, dy)
    
    // Global motion (patterns)
    patternMotion     : {
      expansion: Float;              // Radial expansion/contraction
      rotation: Float;               // Rotation
      translation: { x: Float; y: Float };
    };
    
    // Motion segmentation
    motionBoundaries  : [Float];
    
    // Optic flow
    opticFlow         : [[{ x: Float; y: Float }]];
    
    // Time-to-contact
    timeToContact     : Float;
  };

  /// Inferotemporal cortex state (object recognition)
  public type ITCortexState = {
    // Object-selective units
    objectUnits       : [ObjectUnit];
    
    // Face processing (specialized for friendly/enemy drone recognition)
    faceUnits         : [Float];
    
    // Category coding
    categoryActivation : [(Text, Float)];  // (category, activation)
    
    // View-invariant representations
    viewInvariantReps : [[Float]];
    
    // Semantic associations
    semanticLinks     : [(Nat, Nat, Float)];  // (obj1, obj2, strength)
  };

  /// Object unit
  public type ObjectUnit = {
    objectId          : Nat;
    preferredFeatures : [Float];
    currentActivation : Float;
    viewpointHistory  : [Float];
    semanticLabel     : ?Text;
  };

  /// Parietal cortex state (spatial processing)
  public type ParietalCortexState = {
    // Spatial attention
    priorityMap       : [[Float]];   // Saliency + task-relevance
    attentionSpotlight : { x: Float; y: Float; radius: Float };
    
    // Reach planning
    reachTarget       : ?{ x: Float; y: Float; z: Float };
    reachTrajectory   : [{ x: Float; y: Float; z: Float }];
    
    // Eye-centered coordinates
    eyeCenteredMap    : [[Float]];
    
    // Body-centered coordinates
    bodyCenteredMap   : [[Float]];
    
    // World-centered coordinates
    worldCenteredMap  : [[Float]];
    
    // Coordinate transformations
    gainFields        : [[[Float]]];
    
    // Number sense (counting targets)
    numerosity        : Nat;
    numerosityConfidence : Float;
  };

  /// Complete visual cortex
  public type VisualCortexState = {
    v1                : V1CortexState;
    v2                : V2CortexState;
    v4                : V4CortexState;
    mt                : MTCortexState;
    it                : ITCortexState;
    parietal          : ParietalCortexState;
    
    // Global visual state
    currentGaze       : { x: Float; y: Float };
    saccadeTarget     : ?{ x: Float; y: Float };
    visualAttention   : Float;
    
    // Integration
    boundObjects      : [BoundObject];
    sceneGist         : [Float];     // Rapid scene categorization
    
    beatNum           : Nat;
  };

  /// Bound object (features bound together)
  public type BoundObject = {
    objectId          : Nat;
    position          : { x: Float; y: Float };
    size              : Float;
    color             : [Float];
    motion            : { dx: Float; dy: Float };
    category          : ?Text;
    confidence        : Float;
    trackingId        : Nat;
  };

  /// Initialize visual cortex
  public func initVisualCortex(resolution: Nat) : VisualCortexState {
    let numOrientations = 8;
    let numSpatialFreqs = 4;
    
    // V1
    let v1 : V1CortexState = {
      simpleCells = Array.tabulate<[Float]>(numOrientations, func(_) {
        Array.tabulate<Float>(numSpatialFreqs, func(_) { 0.0 })
      });
      orientationTuning = Array.tabulate<Float>(numOrientations, func(i) {
        Float.fromInt(i) * PI / Float.fromInt(numOrientations)
      });
      spatialFreqTuning = [0.5, 1.0, 2.0, 4.0];
      complexCells = Array.tabulate<Float>(numOrientations, func(_) { 0.0 });
      hypercomplexCells = Array.tabulate<Float>(numOrientations, func(_) { 0.0 });
      rfCenter = Array.tabulate<(Float, Float)>(resolution * resolution, func(i) {
        (Float.fromInt(i % resolution), Float.fromInt(i / resolution))
      });
      rfSize = Array.tabulate<Float>(resolution * resolution, func(_) { 1.0 });
      rfSurround = Array.tabulate<Float>(resolution * resolution, func(_) { 0.3 });
      contrastGain = 1.0;
      adaptationState = 0.5;
      outputToV2 = [];
      outputToMT = [];
    };
    
    let emptyGrid = Array.tabulate<[Float]>(resolution, func(_) {
      Array.tabulate<Float>(resolution, func(_) { 0.0 })
    });
    
    // V2
    let v2 : V2CortexState = {
      textureUnits = [[]];
      textureGradient = [];
      borderOwnership = [];
      disparityTuning = Array.tabulate<Float>(10, func(i) { Float.fromInt(i - 5) * 0.1 });
      depthMap = emptyGrid;
      illusoryContours = [];
      colorFormBinding = [[]];
    };
    
    // V4
    let v4 : V4CortexState = {
      colorChannels = [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 0.0]];
      colorConstancy = 1.0;
      curvatureDetectors = Array.tabulate<Float>(8, func(_) { 0.0 });
      angleDetectors = Array.tabulate<Float>(12, func(_) { 0.0 });
      attentionGain = emptyGrid;
      figureGroundMap = emptyGrid;
    };
    
    // MT
    let mt : MTCortexState = {
      directionTuning = Array.tabulate<Float>(8, func(i) { Float.fromInt(i) * TWO_PI / 8.0 });
      speedTuning = [0.5, 1.0, 2.0, 4.0, 8.0];
      localMotionField = emptyGrid;
      patternMotion = { expansion = 0.0; rotation = 0.0; translation = { x = 0.0; y = 0.0 } };
      motionBoundaries = [];
      opticFlow = Array.tabulate<[{ x: Float; y: Float }]>(resolution, func(_) {
        Array.tabulate<{ x: Float; y: Float }>(resolution, func(_) { { x = 0.0; y = 0.0 } })
      });
      timeToContact = 999.0;
    };
    
    // IT
    let it : ITCortexState = {
      objectUnits = [];
      faceUnits = Array.tabulate<Float>(20, func(_) { 0.0 });
      categoryActivation = [];
      viewInvariantReps = [[]];
      semanticLinks = [];
    };
    
    // Parietal
    let parietal : ParietalCortexState = {
      priorityMap = emptyGrid;
      attentionSpotlight = { x = 0.5; y = 0.5; radius = 0.2 };
      reachTarget = null;
      reachTrajectory = [];
      eyeCenteredMap = emptyGrid;
      bodyCenteredMap = emptyGrid;
      worldCenteredMap = emptyGrid;
      gainFields = [[[]]];
      numerosity = 0;
      numerosityConfidence = 0.0;
    };
    
    {
      v1 = v1;
      v2 = v2;
      v4 = v4;
      mt = mt;
      it = it;
      parietal = parietal;
      currentGaze = { x = 0.5; y = 0.5 };
      saccadeTarget = null;
      visualAttention = 0.5;
      boundObjects = [];
      sceneGist = Array.tabulate<Float>(100, func(_) { 0.0 });
      beatNum = 0;
    }
  };

  /// Process visual input through V1
  public func processV1(
    v1: V1CortexState,
    input: [[Float]],
    contrast: Float
  ) : V1CortexState {
    let ny = input.size();
    if (ny == 0) { return v1 };
    let nx = input[0].size();
    
    // Gabor-like filtering for orientation selectivity
    let newSimpleCells = Array.tabulate<[Float]>(v1.orientationTuning.size(), func(ori) {
      let theta = v1.orientationTuning[ori];
      Array.tabulate<Float>(v1.spatialFreqTuning.size(), func(sf) {
        let freq = v1.spatialFreqTuning[sf];
        
        // Simplified Gabor response
        var response : Float = 0.0;
        for (y in Iter.range(0, ny - 1)) {
          for (x in Iter.range(0, nx - 1)) {
            let xr = Float.fromInt(x) * Float.cos(theta) + Float.fromInt(y) * Float.sin(theta);
            let envelope = Float.exp(-xr * xr / (2.0 * freq * freq));
            let carrier = Float.cos(TWO_PI * freq * xr);
            response += input[y][x] * envelope * carrier;
          };
        };
        response / Float.fromInt(nx * ny)
      })
    });
    
    // Complex cells (sum of squared simple cells)
    let newComplexCells = Array.tabulate<Float>(v1.orientationTuning.size(), func(ori) {
      var sum : Float = 0.0;
      for (sf in Iter.range(0, v1.spatialFreqTuning.size() - 1)) {
        let simple = newSimpleCells[ori][sf];
        sum += simple * simple;
      };
      Float.sqrt(sum)
    });
    
    // Contrast adaptation
    let newAdaptation = v1.adaptationState * 0.95 + contrast * 0.05;
    let adaptedGain = v1.contrastGain / (1.0 + newAdaptation);
    
    {
      simpleCells = newSimpleCells;
      orientationTuning = v1.orientationTuning;
      spatialFreqTuning = v1.spatialFreqTuning;
      complexCells = newComplexCells;
      hypercomplexCells = v1.hypercomplexCells;
      rfCenter = v1.rfCenter;
      rfSize = v1.rfSize;
      rfSurround = v1.rfSurround;
      contrastGain = adaptedGain;
      adaptationState = newAdaptation;
      outputToV2 = newComplexCells;
      outputToMT = newComplexCells;
    }
  };

  /// Process motion in MT
  public func processMT(
    mt: MTCortexState,
    currentFrame: [[Float]],
    previousFrame: [[Float]],
    dt: Float
  ) : MTCortexState {
    let ny = currentFrame.size();
    if (ny == 0) { return mt };
    let nx = currentFrame[0].size();
    
    // Compute optical flow (simplified block matching)
    let newOpticFlow = Array.tabulate<[{ x: Float; y: Float }]>(ny, func(y) {
      Array.tabulate<{ x: Float; y: Float }>(nx, func(x) {
        if (y > 0 and y < ny - 1 and x > 0 and x < nx - 1) {
          // Spatial gradients
          let ix = (currentFrame[y][x + 1] - currentFrame[y][x - 1]) / 2.0;
          let iy = (currentFrame[y + 1][x] - currentFrame[y - 1][x]) / 2.0;
          
          // Temporal gradient
          let it = currentFrame[y][x] - (if (y < previousFrame.size() and x < previousFrame[y].size()) { previousFrame[y][x] } else { 0.0 });
          
          // Lucas-Kanade (simplified)
          let denom = ix * ix + iy * iy + 0.001;
          {
            x = -ix * it / denom;
            y = -iy * it / denom;
          }
        } else {
          { x = 0.0; y = 0.0 }
        }
      })
    });
    
    // Global motion analysis
    var sumDx : Float = 0.0;
    var sumDy : Float = 0.0;
    var sumExpansion : Float = 0.0;
    var sumRotation : Float = 0.0;
    
    for (y in Iter.range(0, ny - 1)) {
      for (x in Iter.range(0, nx - 1)) {
        let flow = newOpticFlow[y][x];
        sumDx += flow.x;
        sumDy += flow.y;
        
        // Expansion: radial flow
        let cx = Float.fromInt(x) - Float.fromInt(nx) / 2.0;
        let cy = Float.fromInt(y) - Float.fromInt(ny) / 2.0;
        let radial = (flow.x * cx + flow.y * cy) / (Float.sqrt(cx * cx + cy * cy) + 0.001);
        sumExpansion += radial;
        
        // Rotation: tangential flow
        let tangential = (flow.x * (-cy) + flow.y * cx) / (Float.sqrt(cx * cx + cy * cy) + 0.001);
        sumRotation += tangential;
      };
    };
    
    let count = Float.fromInt(nx * ny);
    let globalTranslation = { x = sumDx / count; y = sumDy / count };
    let globalExpansion = sumExpansion / count;
    let globalRotation = sumRotation / count;
    
    // Time-to-contact from expansion
    let newTTC = if (Float.abs(globalExpansion) > 0.01) {
      1.0 / Float.abs(globalExpansion)
    } else { 999.0 };
    
    {
      directionTuning = mt.directionTuning;
      speedTuning = mt.speedTuning;
      localMotionField = Array.tabulate<[Float]>(ny, func(y) {
        Array.tabulate<Float>(nx, func(x) {
          let flow = newOpticFlow[y][x];
          Float.sqrt(flow.x * flow.x + flow.y * flow.y)
        })
      });
      patternMotion = {
        expansion = globalExpansion;
        rotation = globalRotation;
        translation = globalTranslation;
      };
      motionBoundaries = mt.motionBoundaries;
      opticFlow = newOpticFlow;
      timeToContact = newTTC;
    }
  };

  /// Update visual attention in parietal cortex
  public func updateVisualAttention(
    parietal: ParietalCortexState,
    saliencyMap: [[Float]],
    taskRelevance: [[Float]],
    inhibitionOfReturn: [[Float]]
  ) : ParietalCortexState {
    let ny = saliencyMap.size();
    if (ny == 0) { return parietal };
    let nx = saliencyMap[0].size();
    
    // Combine saliency, task relevance, and IOR
    let newPriorityMap = Array.tabulate<[Float]>(ny, func(y) {
      Array.tabulate<Float>(nx, func(x) {
        let sal = saliencyMap[y][x];
        let task = if (y < taskRelevance.size() and x < taskRelevance[y].size()) {
          taskRelevance[y][x]
        } else { 0.0 };
        let ior = if (y < inhibitionOfReturn.size() and x < inhibitionOfReturn[y].size()) {
          inhibitionOfReturn[y][x]
        } else { 0.0 };
        
        (sal * 0.4 + task * 0.6) * (1.0 - ior)
      })
    });
    
    // Find peak
    var maxVal : Float = 0.0;
    var maxX : Nat = 0;
    var maxY : Nat = 0;
    
    for (y in Iter.range(0, ny - 1)) {
      for (x in Iter.range(0, nx - 1)) {
        if (newPriorityMap[y][x] > maxVal) {
          maxVal := newPriorityMap[y][x];
          maxX := x;
          maxY := y;
        };
      };
    };
    
    // Update attention spotlight
    let newSpotlight = {
      x = Float.fromInt(maxX) / Float.fromInt(nx);
      y = Float.fromInt(maxY) / Float.fromInt(ny);
      radius = parietal.attentionSpotlight.radius;
    };
    
    {
      priorityMap = newPriorityMap;
      attentionSpotlight = newSpotlight;
      reachTarget = parietal.reachTarget;
      reachTrajectory = parietal.reachTrajectory;
      eyeCenteredMap = parietal.eyeCenteredMap;
      bodyCenteredMap = parietal.bodyCenteredMap;
      worldCenteredMap = parietal.worldCenteredMap;
      gainFields = parietal.gainFields;
      numerosity = parietal.numerosity;
      numerosityConfidence = parietal.numerosityConfidence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 23: COMPLETE AUDITORY CORTEX — REAL DRONE HEARING
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Drones process acoustic signals for:
  //   • Detecting other drones (motor sounds)
  //   • Communication signals
  //   • Environmental sounds (wind, obstacles)
  //   • Spatial localization (binaural)
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Cochlear processing state
  public type CochlearState = {
    // Basilar membrane simulation
    filterBank        : [[Float]];   // [channel][time]
    centerFrequencies : [Float];
    bandwidths        : [Float];
    
    // Hair cell response
    innerHairCells    : [Float];
    outerHairCells    : [Float];
    
    // Efferent control
    efferentGain      : [Float];
  };

  /// Auditory cortex state
  public type AuditoryCortexState = {
    // Cochlear input
    cochlea           : CochlearState;
    
    // A1 - Primary auditory cortex
    tonotopicMap      : [Float];     // Frequency representation
    temporalPattern   : [[Float]];   // Temporal modulation
    
    // Spatial processing
    interauralTimeDiff : Float;      // ITD for localization
    interauralLevelDiff : Float;     // ILD for localization
    soundDirection    : Float;       // Estimated direction (radians)
    soundElevation    : Float;
    
    // Sound identification
    soundCategories   : [(Text, Float)];  // (category, confidence)
    
    // Auditory objects
    auditoryObjects   : [AuditoryObject];
    
    // Attention
    auditoryAttention : Float;
    attendedStream    : ?Nat;
    
    beatNum           : Nat;
  };

  /// Auditory object
  public type AuditoryObject = {
    objectId          : Nat;
    estimatedDirection : Float;
    estimatedDistance : Float;
    dominantFrequency : Float;
    harmonicity       : Float;       // How harmonic (drone motors are harmonic)
    onsetTime         : Nat;
    confidence        : Float;
  };

  /// Initialize auditory cortex
  public func initAuditoryCortex(numChannels: Nat) : AuditoryCortexState {
    // Frequency range: 20Hz to 20kHz (logarithmic)
    let centerFreqs = Array.tabulate<Float>(numChannels, func(i) {
      20.0 * Float.exp(Float.fromInt(i) * Float.log(1000.0) / Float.fromInt(numChannels - 1))
    });
    
    let bandwidths = Array.map<Float, Float>(centerFreqs, func(cf) {
      cf * 0.1  // 10% bandwidth
    });
    
    {
      cochlea = {
        filterBank = [[]];
        centerFrequencies = centerFreqs;
        bandwidths = bandwidths;
        innerHairCells = Array.tabulate<Float>(numChannels, func(_) { 0.0 });
        outerHairCells = Array.tabulate<Float>(numChannels, func(_) { 0.5 });
        efferentGain = Array.tabulate<Float>(numChannels, func(_) { 1.0 });
      };
      tonotopicMap = Array.tabulate<Float>(numChannels, func(_) { 0.0 });
      temporalPattern = [[]];
      interauralTimeDiff = 0.0;
      interauralLevelDiff = 0.0;
      soundDirection = 0.0;
      soundElevation = 0.0;
      soundCategories = [];
      auditoryObjects = [];
      auditoryAttention = 0.5;
      attendedStream = null;
      beatNum = 0;
    }
  };

  /// Process audio input
  public func processAudio(
    auditory: AuditoryCortexState,
    leftChannel: [Float],
    rightChannel: [Float],
    sampleRate: Float
  ) : AuditoryCortexState {
    let numSamples = leftChannel.size();
    let numChannels = auditory.cochlea.centerFrequencies.size();
    
    // Cochlear filtering (simplified)
    var newIHC : [Float] = Array.tabulate<Float>(numChannels, func(_) { 0.0 });
    let ihcMut = Array.thaw<Float>(newIHC);
    
    for (ch in Iter.range(0, numChannels - 1)) {
      let cf = auditory.cochlea.centerFrequencies[ch];
      
      // Simple bandpass energy
      var energy : Float = 0.0;
      for (s in Iter.range(0, numSamples - 1)) {
        // Simplified: just use amplitude
        let leftSample = if (s < leftChannel.size()) { leftChannel[s] } else { 0.0 };
        let rightSample = if (s < rightChannel.size()) { rightChannel[s] } else { 0.0 };
        energy += (leftSample * leftSample + rightSample * rightSample) / 2.0;
      };
      ihcMut[ch] := Float.sqrt(energy / Float.fromInt(numSamples));
    };
    newIHC := Array.freeze(ihcMut);
    
    // Binaural processing
    var itd : Float = 0.0;
    var ild : Float = 0.0;
    
    // Cross-correlation for ITD
    var maxCorr : Float = 0.0;
    var maxLag : Int = 0;
    for (lag in Iter.range(-20, 20)) {
      var corr : Float = 0.0;
      for (s in Iter.range(0, numSamples - 1)) {
        let leftIdx = s;
        let rightIdx = s + lag;
        if (leftIdx >= 0 and leftIdx < numSamples and rightIdx >= 0 and rightIdx < numSamples) {
          corr += leftChannel[leftIdx] * rightChannel[rightIdx];
        };
      };
      if (corr > maxCorr) {
        maxCorr := corr;
        maxLag := lag;
      };
    };
    itd := Float.fromInt(maxLag) / sampleRate;
    
    // ILD from energy difference
    var leftEnergy : Float = 0.0;
    var rightEnergy : Float = 0.0;
    for (s in leftChannel.vals()) { leftEnergy += s * s };
    for (s in rightChannel.vals()) { rightEnergy += s * s };
    ild := 10.0 * Float.log((leftEnergy + 0.001) / (rightEnergy + 0.001)) / Float.log(10.0);
    
    // Sound direction from ITD and ILD
    // Speed of sound = 343 m/s, head width ~0.1m
    let maxITD = 0.0003;  // ~0.3ms max ITD
    let normalizedITD = Float.max(-1.0, Float.min(1.0, itd / maxITD));
    let directionFromITD = Float.arcsin(normalizedITD);
    
    // Combine ITD and ILD cues
    let normalizedILD = Float.max(-1.0, Float.min(1.0, ild / 20.0));
    let direction = directionFromITD * 0.7 + normalizedILD * PI / 2.0 * 0.3;
    
    // Update tonotopic map
    let newTonotopic = newIHC;
    
    {
      cochlea = {
        filterBank = auditory.cochlea.filterBank;
        centerFrequencies = auditory.cochlea.centerFrequencies;
        bandwidths = auditory.cochlea.bandwidths;
        innerHairCells = newIHC;
        outerHairCells = auditory.cochlea.outerHairCells;
        efferentGain = auditory.cochlea.efferentGain;
      };
      tonotopicMap = newTonotopic;
      temporalPattern = auditory.temporalPattern;
      interauralTimeDiff = itd;
      interauralLevelDiff = ild;
      soundDirection = direction;
      soundElevation = auditory.soundElevation;
      soundCategories = auditory.soundCategories;
      auditoryObjects = auditory.auditoryObjects;
      auditoryAttention = auditory.auditoryAttention;
      attendedStream = auditory.attendedStream;
      beatNum = auditory.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 24: COMPLETE SOMATOSENSORY SYSTEM — BODY AWARENESS
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The drone's body awareness system:
  //   • Proprioception - Joint angles, motor positions
  //   • Touch - Contact sensors, pressure
  //   • Temperature - Thermal management
  //   • Pain - Damage detection
  //   • Vibration - Motor health, structural integrity
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Somatosensory cortex state
  public type SomatosensoryCortexState = {
    // Body map (homunculus)
    bodyMap           : BodySensoryMap;
    
    // Touch processing
    touchSensors      : [TouchReceptor];
    touchMap          : [[Float]];
    
    // Proprioception
    jointAngles       : [Float];
    jointVelocities   : [Float];
    muscleLength      : [Float];     // Motor state
    muscleTension     : [Float];
    
    // Temperature
    thermalMap        : [Float];     // Temperature at each body part
    thermalGradient   : [Float];
    overheatingAlert  : Bool;
    
    // Pain / damage
    nociceptors       : [Float];     // Pain signals
    damageMap         : [Float];
    protectiveReflex  : Bool;
    
    // Vibration
    vibrationSensors  : [Float];
    motorVibration    : [Float];
    structuralResonance : Float;
    
    // Integration
    bodySchema        : BodySchema;
    
    beatNum           : Nat;
  };

  /// Body sensory map
  public type BodySensoryMap = {
    // Regions
    nose              : SensoryRegion;
    leftWing          : SensoryRegion;
    rightWing         : SensoryRegion;
    body              : SensoryRegion;
    tail              : SensoryRegion;
    motors            : [SensoryRegion];
  };

  /// Sensory region
  public type SensoryRegion = {
    regionId          : Nat;
    position          : { x: Float; y: Float; z: Float };
    touchIntensity    : Float;
    temperature       : Float;
    painLevel         : Float;
    vibration         : Float;
    receptorDensity   : Float;
  };

  /// Touch receptor
  public type TouchReceptor = {
    receptorId        : Nat;
    position          : { x: Float; y: Float; z: Float };
    receptorType      : TouchReceptorType;
    currentActivation : Float;
    adaptationRate    : Float;
    threshold         : Float;
  };

  /// Touch receptor types
  public type TouchReceptorType = {
    #Merkel;          // Sustained touch
    #Meissner;        // Light touch, flutter
    #Pacinian;        // Vibration
    #Ruffini;         // Skin stretch
  };

  /// Body schema
  public type BodySchema = {
    // Limb positions in body-centered coordinates
    limbPositions     : [{ x: Float; y: Float; z: Float }];
    
    // Body boundaries
    boundingBox       : { min: { x: Float; y: Float; z: Float }; max: { x: Float; y: Float; z: Float } };
    
    // Center of mass
    centerOfMass      : { x: Float; y: Float; z: Float };
    
    // Peripersonal space
    peripersonalSpace : [[Float]];  // Space around body
    
    // Body ownership
    ownershipStrength : Float;      // Rubber hand illusion equivalent
  };

  /// Initialize somatosensory cortex
  public func initSomatosensoryCortex(numMotors: Nat) : SomatosensoryCortexState {
    let makeRegion = func(id: Nat, x: Float, y: Float, z: Float, density: Float) : SensoryRegion {
      {
        regionId = id;
        position = { x = x; y = y; z = z };
        touchIntensity = 0.0;
        temperature = 25.0;
        painLevel = 0.0;
        vibration = 0.0;
        receptorDensity = density;
      }
    };
    
    let bodyMap : BodySensoryMap = {
      nose = makeRegion(0, 0.0, 0.3, 0.0, 2.0);
      leftWing = makeRegion(1, -0.2, 0.0, 0.0, 0.5);
      rightWing = makeRegion(2, 0.2, 0.0, 0.0, 0.5);
      body = makeRegion(3, 0.0, 0.0, 0.0, 1.0);
      tail = makeRegion(4, 0.0, -0.2, 0.0, 0.3);
      motors = Array.tabulate<SensoryRegion>(numMotors, func(i) {
        let angle = Float.fromInt(i) * TWO_PI / Float.fromInt(numMotors);
        makeRegion(5 + i, 0.15 * Float.cos(angle), 0.15 * Float.sin(angle), 0.0, 1.5)
      });
    };
    
    let touchSensors = Array.tabulate<TouchReceptor>(20, func(i) {
      {
        receptorId = i;
        position = { x = Float.fromInt(i % 5) * 0.05 - 0.1; y = Float.fromInt(i / 5) * 0.05 - 0.1; z = 0.0 };
        receptorType = switch (i % 4) {
          case 0 { #Merkel };
          case 1 { #Meissner };
          case 2 { #Pacinian };
          case _ { #Ruffini };
        };
        currentActivation = 0.0;
        adaptationRate = 0.1;
        threshold = 0.1;
      }
    });
    
    {
      bodyMap = bodyMap;
      touchSensors = touchSensors;
      touchMap = [[]];
      jointAngles = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
      jointVelocities = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
      muscleLength = Array.tabulate<Float>(numMotors, func(_) { 1.0 });
      muscleTension = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
      thermalMap = Array.tabulate<Float>(5 + numMotors, func(_) { 25.0 });
      thermalGradient = Array.tabulate<Float>(5 + numMotors, func(_) { 0.0 });
      overheatingAlert = false;
      nociceptors = Array.tabulate<Float>(5 + numMotors, func(_) { 0.0 });
      damageMap = Array.tabulate<Float>(5 + numMotors, func(_) { 0.0 });
      protectiveReflex = false;
      vibrationSensors = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
      motorVibration = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
      structuralResonance = 0.0;
      bodySchema = {
        limbPositions = [];
        boundingBox = { min = { x = -0.3; y = -0.3; z = -0.1 }; max = { x = 0.3; y = 0.3; z = 0.1 } };
        centerOfMass = { x = 0.0; y = 0.0; z = 0.0 };
        peripersonalSpace = [[]];
        ownershipStrength = 1.0;
      };
      beatNum = 0;
    }
  };

  /// Update somatosensory state
  public func updateSomatosensory(
    soma: SomatosensoryCortexState,
    motorSpeeds: [Float],
    motorCurrents: [Float],
    contactForces: [Float],
    ambientTemp: Float,
    dt: Float
  ) : SomatosensoryCortexState {
    let numMotors = soma.jointAngles.size();
    
    // Update proprioception
    let newJointAngles = Array.tabulate<Float>(numMotors, func(i) {
      let speed = if (i < motorSpeeds.size()) { motorSpeeds[i] } else { 0.0 };
      soma.jointAngles[i] + speed * dt * 0.1  // Integration
    });
    
    let newJointVelocities = motorSpeeds;
    
    // Update thermal state
    let newThermalMap = Array.tabulate<Float>(soma.thermalMap.size(), func(i) {
      var temp = soma.thermalMap[i];
      
      // Motors generate heat proportional to current²
      if (i >= 5 and i - 5 < motorCurrents.size()) {
        let current = motorCurrents[i - 5];
        let heatGeneration = current * current * 0.1;
        temp := temp + heatGeneration * dt;
      };
      
      // Cooling toward ambient
      let cooling = (temp - ambientTemp) * 0.05 * dt;
      temp := temp - cooling;
      
      temp
    });
    
    // Check overheating
    var overheating = false;
    for (temp in newThermalMap.vals()) {
      if (temp > 80.0) { overheating := true };
    };
    
    // Update vibration (from motor speeds)
    let newMotorVibration = Array.tabulate<Float>(numMotors, func(i) {
      let speed = if (i < motorSpeeds.size()) { motorSpeeds[i] } else { 0.0 };
      // Vibration increases with speed, with resonance at certain frequencies
      let baseVibration = speed * 0.01;
      let resonance = Float.sin(speed * 0.1) * 0.5 + 0.5;
      baseVibration * (1.0 + resonance * 0.3)
    });
    
    // Structural resonance (sum of motor vibrations)
    var totalVibration : Float = 0.0;
    for (v in newMotorVibration.vals()) { totalVibration += v };
    let newResonance = totalVibration / Float.fromInt(numMotors);
    
    // Update pain/damage
    let newNociceptors = Array.tabulate<Float>(soma.nociceptors.size(), func(i) {
      var pain = soma.nociceptors[i] * 0.95;  // Decay
      
      // Thermal pain
      if (i < newThermalMap.size() and newThermalMap[i] > 70.0) {
        pain := pain + (newThermalMap[i] - 70.0) * 0.1;
      };
      
      // Impact pain
      if (i < contactForces.size() and contactForces[i] > 5.0) {
        pain := pain + (contactForces[i] - 5.0) * 0.2;
      };
      
      Float.min(pain, 1.0)
    });
    
    // Protective reflex
    var protective = false;
    for (pain in newNociceptors.vals()) {
      if (pain > 0.5) { protective := true };
    };
    
    {
      bodyMap = soma.bodyMap;
      touchSensors = soma.touchSensors;
      touchMap = soma.touchMap;
      jointAngles = newJointAngles;
      jointVelocities = newJointVelocities;
      muscleLength = soma.muscleLength;
      muscleTension = Array.tabulate<Float>(numMotors, func(i) {
        if (i < motorCurrents.size()) { motorCurrents[i] } else { 0.0 }
      });
      thermalMap = newThermalMap;
      thermalGradient = soma.thermalGradient;
      overheatingAlert = overheating;
      nociceptors = newNociceptors;
      damageMap = soma.damageMap;
      protectiveReflex = protective;
      vibrationSensors = soma.vibrationSensors;
      motorVibration = newMotorVibration;
      structuralResonance = newResonance;
      bodySchema = soma.bodySchema;
      beatNum = soma.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 25: WORKING MEMORY SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The drone's working memory for active task management:
  //   • Central executive - Attention control
  //   • Phonological loop - Verbal/symbolic information
  //   • Visuospatial sketchpad - Spatial representations
  //   • Episodic buffer - Integration across modalities
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Working memory state
  public type WorkingMemoryState = {
    // Central executive
    centralExecutive  : CentralExecutiveState;
    
    // Phonological loop (symbolic information for drone)
    phonologicalLoop  : PhonologicalLoopState;
    
    // Visuospatial sketchpad
    visuospatialSketchpad : VisuospatialSketchpadState;
    
    // Episodic buffer
    episodicBuffer    : EpisodicBufferState;
    
    // Capacity limits
    totalCapacity     : Nat;
    currentLoad       : Float;
    
    // Maintenance
    rehearsalActive   : Bool;
    decayRate         : Float;
    
    beatNum           : Nat;
  };

  /// Central executive state
  public type CentralExecutiveState = {
    // Attention control
    focusedAttention  : Float;
    dividedAttention  : [Float];
    
    // Task management
    activeTask        : ?WorkingMemoryTask;
    taskQueue         : [WorkingMemoryTask];
    
    // Inhibition
    inhibitionStrength : Float;
    
    // Switching
    switchCost        : Float;
    lastSwitchBeat    : Nat;
    
    // Updating
    updateRate        : Float;
  };

  /// Working memory task
  public type WorkingMemoryTask = {
    taskId            : Nat;
    taskType          : Text;
    priority          : Float;
    requiredCapacity  : Float;
    startBeat         : Nat;
    deadline          : ?Nat;
    progress          : Float;
  };

  /// Phonological loop state
  public type PhonologicalLoopState = {
    // Store
    phonologicalStore : [SymbolicItem];
    maxItems          : Nat;
    
    // Articulatory rehearsal
    rehearsalItems    : [Nat];      // Indices being rehearsed
    rehearsalPointer  : Nat;
    
    // Decay
    itemDecay         : [Float];
    
    // Capacity
    temporalCapacity  : Float;     // ~2 seconds
  };

  /// Symbolic item (for phonological loop)
  public type SymbolicItem = {
    itemId            : Nat;
    content           : Text;       // Could be waypoint ID, command code, etc.
    encoding          : [Float];
    activationLevel   : Float;
    lastRefresh       : Nat;
  };

  /// Visuospatial sketchpad state
  public type VisuospatialSketchpadState = {
    // Visual cache
    visualCache       : [VisualCacheItem];
    maxVisualItems    : Nat;
    
    // Inner scribe (manipulation)
    spatialSequence   : [{ x: Float; y: Float }];
    sequencePointer   : Nat;
    
    // Spatial map
    mentalMap         : [[Float]];
    mapResolution     : Nat;
    
    // Objects in mind
    heldObjects       : [MentalObject];
    
    // Spatial transformations
    rotationAngle     : Float;
    translationOffset : { x: Float; y: Float };
    scaleLevel        : Float;
  };

  /// Visual cache item
  public type VisualCacheItem = {
    itemId            : Nat;
    position          : { x: Float; y: Float };
    features          : [Float];
    color             : [Float];
    activationLevel   : Float;
    lastRefresh       : Nat;
  };

  /// Mental object
  public type MentalObject = {
    objectId          : Nat;
    category          : Text;
    position          : { x: Float; y: Float; z: Float };
    orientation       : Float;
    size              : Float;
    featureVector     : [Float];
    bindingStrength   : Float;
  };

  /// Episodic buffer state
  public type EpisodicBufferState = {
    // Integrated representations
    episodes          : [EpisodeChunk];
    maxEpisodes       : Nat;
    
    // Binding
    boundRepresentations : [BoundRepresentation];
    
    // Link to long-term memory
    ltmLinks          : [(Nat, Nat, Float)];  // (episodeId, ltmId, strength)
    
    // Temporal organization
    temporalOrder     : [Nat];      // Episode IDs in order
    currentTime       : Nat;
  };

  /// Episode chunk
  public type EpisodeChunk = {
    chunkId           : Nat;
    visualContent     : [Float];
    spatialContent    : { x: Float; y: Float; z: Float };
    symbolicContent   : ?Text;
    emotionalValence  : Float;
    timestamp         : Nat;
    importance        : Float;
  };

  /// Bound representation
  public type BoundRepresentation = {
    representationId  : Nat;
    visualComponent   : ?Nat;       // Index into visual cache
    spatialComponent  : ?Nat;       // Index into spatial sequence
    symbolicComponent : ?Nat;       // Index into phonological store
    bindingStrength   : Float;
  };

  /// Initialize working memory
  public func initWorkingMemory() : WorkingMemoryState {
    {
      centralExecutive = {
        focusedAttention = 1.0;
        dividedAttention = [0.5, 0.3, 0.2];
        activeTask = null;
        taskQueue = [];
        inhibitionStrength = 0.5;
        switchCost = 0.2;
        lastSwitchBeat = 0;
        updateRate = 0.1;
      };
      phonologicalLoop = {
        phonologicalStore = [];
        maxItems = 7;  // Miller's magical number
        rehearsalItems = [];
        rehearsalPointer = 0;
        itemDecay = [];
        temporalCapacity = 2.0;
      };
      visuospatialSketchpad = {
        visualCache = [];
        maxVisualItems = 4;
        spatialSequence = [];
        sequencePointer = 0;
        mentalMap = Array.tabulate<[Float]>(20, func(_) { Array.tabulate<Float>(20, func(_) { 0.0 }) });
        mapResolution = 20;
        heldObjects = [];
        rotationAngle = 0.0;
        translationOffset = { x = 0.0; y = 0.0 };
        scaleLevel = 1.0;
      };
      episodicBuffer = {
        episodes = [];
        maxEpisodes = 4;
        boundRepresentations = [];
        ltmLinks = [];
        temporalOrder = [];
        currentTime = 0;
      };
      totalCapacity = 7;
      currentLoad = 0.0;
      rehearsalActive = true;
      decayRate = 0.1;
      beatNum = 0;
    }
  };

  /// Add item to working memory
  public func addToWorkingMemory(
    wm: WorkingMemoryState,
    item: {
      #Visual : { position: { x: Float; y: Float }; features: [Float] };
      #Spatial : { x: Float; y: Float };
      #Symbolic : Text;
    }
  ) : WorkingMemoryState {
    switch (item) {
      case (#Visual(visual)) {
        let newItem : VisualCacheItem = {
          itemId = wm.visuospatialSketchpad.visualCache.size();
          position = visual.position;
          features = visual.features;
          color = [0.5, 0.5, 0.5];
          activationLevel = 1.0;
          lastRefresh = wm.beatNum;
        };
        
        var newCache = Array.append(wm.visuospatialSketchpad.visualCache, [newItem]);
        if (newCache.size() > wm.visuospatialSketchpad.maxVisualItems) {
          // Remove oldest
          newCache := Array.tabulate<VisualCacheItem>(wm.visuospatialSketchpad.maxVisualItems, func(i) {
            newCache[newCache.size() - wm.visuospatialSketchpad.maxVisualItems + i]
          });
        };
        
        {
          centralExecutive = wm.centralExecutive;
          phonologicalLoop = wm.phonologicalLoop;
          visuospatialSketchpad = {
            visualCache = newCache;
            maxVisualItems = wm.visuospatialSketchpad.maxVisualItems;
            spatialSequence = wm.visuospatialSketchpad.spatialSequence;
            sequencePointer = wm.visuospatialSketchpad.sequencePointer;
            mentalMap = wm.visuospatialSketchpad.mentalMap;
            mapResolution = wm.visuospatialSketchpad.mapResolution;
            heldObjects = wm.visuospatialSketchpad.heldObjects;
            rotationAngle = wm.visuospatialSketchpad.rotationAngle;
            translationOffset = wm.visuospatialSketchpad.translationOffset;
            scaleLevel = wm.visuospatialSketchpad.scaleLevel;
          };
          episodicBuffer = wm.episodicBuffer;
          totalCapacity = wm.totalCapacity;
          currentLoad = wm.currentLoad + 1.0;
          rehearsalActive = wm.rehearsalActive;
          decayRate = wm.decayRate;
          beatNum = wm.beatNum;
        }
      };
      case (#Symbolic(text)) {
        let newItem : SymbolicItem = {
          itemId = wm.phonologicalLoop.phonologicalStore.size();
          content = text;
          encoding = [];
          activationLevel = 1.0;
          lastRefresh = wm.beatNum;
        };
        
        var newStore = Array.append(wm.phonologicalLoop.phonologicalStore, [newItem]);
        if (newStore.size() > wm.phonologicalLoop.maxItems) {
          newStore := Array.tabulate<SymbolicItem>(wm.phonologicalLoop.maxItems, func(i) {
            newStore[newStore.size() - wm.phonologicalLoop.maxItems + i]
          });
        };
        
        {
          centralExecutive = wm.centralExecutive;
          phonologicalLoop = {
            phonologicalStore = newStore;
            maxItems = wm.phonologicalLoop.maxItems;
            rehearsalItems = wm.phonologicalLoop.rehearsalItems;
            rehearsalPointer = wm.phonologicalLoop.rehearsalPointer;
            itemDecay = wm.phonologicalLoop.itemDecay;
            temporalCapacity = wm.phonologicalLoop.temporalCapacity;
          };
          visuospatialSketchpad = wm.visuospatialSketchpad;
          episodicBuffer = wm.episodicBuffer;
          totalCapacity = wm.totalCapacity;
          currentLoad = wm.currentLoad + 1.0;
          rehearsalActive = wm.rehearsalActive;
          decayRate = wm.decayRate;
          beatNum = wm.beatNum;
        }
      };
      case (#Spatial(pos)) {
        let newSeq = Array.append(wm.visuospatialSketchpad.spatialSequence, [pos]);
        
        {
          centralExecutive = wm.centralExecutive;
          phonologicalLoop = wm.phonologicalLoop;
          visuospatialSketchpad = {
            visualCache = wm.visuospatialSketchpad.visualCache;
            maxVisualItems = wm.visuospatialSketchpad.maxVisualItems;
            spatialSequence = newSeq;
            sequencePointer = wm.visuospatialSketchpad.sequencePointer;
            mentalMap = wm.visuospatialSketchpad.mentalMap;
            mapResolution = wm.visuospatialSketchpad.mapResolution;
            heldObjects = wm.visuospatialSketchpad.heldObjects;
            rotationAngle = wm.visuospatialSketchpad.rotationAngle;
            translationOffset = wm.visuospatialSketchpad.translationOffset;
            scaleLevel = wm.visuospatialSketchpad.scaleLevel;
          };
          episodicBuffer = wm.episodicBuffer;
          totalCapacity = wm.totalCapacity;
          currentLoad = wm.currentLoad + 0.5;
          rehearsalActive = wm.rehearsalActive;
          decayRate = wm.decayRate;
          beatNum = wm.beatNum;
        }
      };
    }
  };

  /// Update working memory (decay and rehearsal)
  public func updateWorkingMemory(wm: WorkingMemoryState, dt: Float) : WorkingMemoryState {
    // Decay visual items
    let newVisualCache = Array.map<VisualCacheItem, VisualCacheItem>(
      wm.visuospatialSketchpad.visualCache,
      func(item) {
        let timeSinceRefresh = wm.beatNum - item.lastRefresh;
        let decay = Float.exp(-wm.decayRate * Float.fromInt(timeSinceRefresh));
        {
          itemId = item.itemId;
          position = item.position;
          features = item.features;
          color = item.color;
          activationLevel = item.activationLevel * decay;
          lastRefresh = item.lastRefresh;
        }
      }
    );
    
    // Remove very weak items
    let filteredCache = Array.filter<VisualCacheItem>(newVisualCache, func(item) {
      item.activationLevel > 0.1
    });
    
    // Decay phonological items (with rehearsal protection)
    let newPhonStore = Array.map<SymbolicItem, SymbolicItem>(
      wm.phonologicalLoop.phonologicalStore,
      func(item) {
        var beingRehearsed = false;
        for (idx in wm.phonologicalLoop.rehearsalItems.vals()) {
          if (idx == item.itemId) { beingRehearsed := true };
        };
        
        let decay = if (beingRehearsed) { 1.0 } else {
          let timeSinceRefresh = wm.beatNum - item.lastRefresh;
          Float.exp(-wm.decayRate * 2.0 * Float.fromInt(timeSinceRefresh))
        };
        
        {
          itemId = item.itemId;
          content = item.content;
          encoding = item.encoding;
          activationLevel = item.activationLevel * decay;
          lastRefresh = if (beingRehearsed) { wm.beatNum } else { item.lastRefresh };
        }
      }
    );
    
    // Update load
    let newLoad = Float.fromInt(filteredCache.size()) + Float.fromInt(newPhonStore.size()) * 0.7;
    
    {
      centralExecutive = wm.centralExecutive;
      phonologicalLoop = {
        phonologicalStore = newPhonStore;
        maxItems = wm.phonologicalLoop.maxItems;
        rehearsalItems = wm.phonologicalLoop.rehearsalItems;
        rehearsalPointer = (wm.phonologicalLoop.rehearsalPointer + 1) % (wm.phonologicalLoop.rehearsalItems.size() + 1);
        itemDecay = wm.phonologicalLoop.itemDecay;
        temporalCapacity = wm.phonologicalLoop.temporalCapacity;
      };
      visuospatialSketchpad = {
        visualCache = filteredCache;
        maxVisualItems = wm.visuospatialSketchpad.maxVisualItems;
        spatialSequence = wm.visuospatialSketchpad.spatialSequence;
        sequencePointer = wm.visuospatialSketchpad.sequencePointer;
        mentalMap = wm.visuospatialSketchpad.mentalMap;
        mapResolution = wm.visuospatialSketchpad.mapResolution;
        heldObjects = wm.visuospatialSketchpad.heldObjects;
        rotationAngle = wm.visuospatialSketchpad.rotationAngle;
        translationOffset = wm.visuospatialSketchpad.translationOffset;
        scaleLevel = wm.visuospatialSketchpad.scaleLevel;
      };
      episodicBuffer = wm.episodicBuffer;
      totalCapacity = wm.totalCapacity;
      currentLoad = newLoad;
      rehearsalActive = wm.rehearsalActive;
      decayRate = wm.decayRate;
      beatNum = wm.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 26: LONG-TERM MEMORY SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The drone's permanent memory:
  //   • Episodic memory - Events and experiences
  //   • Semantic memory - Facts and knowledge
  //   • Procedural memory - Skills and habits
  //   • Emotional memory - Affective associations
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Long-term memory state
  public type LongTermMemoryState = {
    // Episodic memory
    episodicMemory    : EpisodicMemoryState;
    
    // Semantic memory
    semanticMemory    : SemanticMemoryState;
    
    // Procedural memory
    proceduralMemory  : ProceduralMemoryState;
    
    // Emotional memory
    emotionalMemory   : EmotionalMemoryState;
    
    // Memory consolidation
    consolidationBuffer : [MemoryTrace];
    consolidationProgress : Float;
    
    // Retrieval state
    retrievalState    : RetrievalState;
    
    beatNum           : Nat;
  };

  /// Episodic memory state
  public type EpisodicMemoryState = {
    // Episodes
    episodes          : [EpisodicMemoryItem];
    maxEpisodes       : Nat;
    
    // Temporal organization
    temporalIndex     : [(Nat, Nat)];  // (beat, episodeId)
    
    // Spatial organization
    spatialIndex      : [(Float, Float, Nat)];  // (lat, lon, episodeId)
    
    // Recent access
    recentAccess      : [Nat];
  };

  /// Episodic memory item
  public type EpisodicMemoryItem = {
    episodeId         : Nat;
    
    // What
    eventDescription  : [Float];
    objects           : [{ category: Text; features: [Float] }];
    
    // Where
    location          : { lat: Float; lon: Float; alt: Float };
    spatialContext    : [[Float]];
    
    // When
    timestamp         : Nat;
    temporalContext   : Float;     // Time of day
    
    // Emotional coloring
    emotionalValence  : Float;
    emotionalArousal  : Float;
    
    // Strength and accessibility
    memoryStrength    : Float;
    lastAccessed      : Nat;
    accessCount       : Nat;
  };

  /// Semantic memory state
  public type SemanticMemoryState = {
    // Concepts
    concepts          : [SemanticConcept];
    
    // Relations
    relations         : [(Nat, Nat, SemanticRelation)];
    
    // Categories
    categories        : [SemanticCategory];
    
    // Feature norms
    featureNorms      : [(Nat, [Float])];  // (conceptId, features)
  };

  /// Semantic concept
  public type SemanticConcept = {
    conceptId         : Nat;
    name              : Text;
    featureVector     : [Float];
    abstractionLevel  : Float;     // 0 = concrete, 1 = abstract
    typicality        : [(Nat, Float)];  // (categoryId, typicality)
    accessCount       : Nat;
  };

  /// Semantic relation types
  public type SemanticRelation = {
    #IsA;             // Hyponymy
    #HasA;            // Meronymy
    #PartOf;
    #UsedFor;
    #LocatedAt;
    #Causes;
    #RelatedTo;
    #Opposite;
  };

  /// Semantic category
  public type SemanticCategory = {
    categoryId        : Nat;
    name              : Text;
    prototype         : [Float];
    members           : [Nat];     // Concept IDs
    superordinate     : ?Nat;
    subordinates      : [Nat];
  };

  /// Procedural memory state
  public type ProceduralMemoryState = {
    // Skills
    skills            : [ProceduralSkill];
    
    // Habits
    habits            : [Habit];
    
    // Motor programs
    motorPrograms     : [MotorProgram];
    
    // Currently active
    activeSkill       : ?Nat;
    skillChaining     : [Nat];
  };

  /// Procedural skill
  public type ProceduralSkill = {
    skillId           : Nat;
    name              : Text;
    
    // Conditions
    triggerConditions : [Float];
    
    // Actions
    actionSequence    : [MotorAction];
    
    // Performance
    proficiency       : Float;
    executionSpeed    : Float;
    errorRate         : Float;
    
    // Practice
    practiceCount     : Nat;
    lastPractice      : Nat;
  };

  /// Motor action
  public type MotorAction = {
    actionId          : Nat;
    actionType        : Text;
    parameters        : [Float];
    duration          : Float;
    nextActions       : [Nat];
  };

  /// Habit
  public type Habit = {
    habitId           : Nat;
    triggerContext    : [Float];
    behaviorSequence  : [Nat];     // Skill IDs
    strength          : Float;
    formationCount    : Nat;
  };

  /// Motor program
  public type MotorProgram = {
    programId         : Nat;
    name              : Text;
    commands          : [{ time: Float; command: MotorCommand }];
    scaling           : Float;
    variability       : Float;
  };

  /// Emotional memory state
  public type EmotionalMemoryState = {
    // Emotional associations
    associations      : [EmotionalAssociation];
    
    // Fear conditioning
    fearConditions    : [FearCondition];
    
    // Reward associations
    rewardAssociations : [(Nat, Float, Nat)];  // (stimulusId, rewardValue, count)
    
    // Mood congruent memory bias
    currentMoodBias   : Float;
  };

  /// Emotional association
  public type EmotionalAssociation = {
    associationId     : Nat;
    stimulus          : [Float];
    emotionType       : Text;
    intensity         : Float;
    formationContext  : ?Nat;      // Episode ID
  };

  /// Fear condition
  public type FearCondition = {
    conditionId       : Nat;
    conditionedStimulus : [Float];
    unconditionedStimulus : [Float];
    fearStrength      : Float;
    extinctionProgress : Float;
    lastExposure      : Nat;
  };

  /// Memory trace (for consolidation)
  public type MemoryTrace = {
    traceId           : Nat;
    content           : [Float];
    sourceType        : Text;      // "episodic", "semantic", "procedural"
    importance        : Float;
    creationBeat      : Nat;
    replayCount       : Nat;
  };

  /// Retrieval state
  public type RetrievalState = {
    // Current retrieval attempt
    retrievalCue      : ?[Float];
    
    // Retrieved items
    retrievedItems    : [Nat];
    retrievalStrengths : [Float];
    
    // Retrieval mode
    retrievalMode     : RetrievalMode;
    
    // Spreading activation
    activatedConcepts : [(Nat, Float)];
  };

  /// Retrieval mode
  public type RetrievalMode = {
    #Free;            // Free recall
    #Cued;            // Cued recall
    #Recognition;     // Recognition memory
    #Priming;         // Implicit memory
  };

  /// Initialize long-term memory
  public func initLongTermMemory() : LongTermMemoryState {
    {
      episodicMemory = {
        episodes = [];
        maxEpisodes = 1000;
        temporalIndex = [];
        spatialIndex = [];
        recentAccess = [];
      };
      semanticMemory = {
        concepts = [];
        relations = [];
        categories = [];
        featureNorms = [];
      };
      proceduralMemory = {
        skills = [];
        habits = [];
        motorPrograms = [];
        activeSkill = null;
        skillChaining = [];
      };
      emotionalMemory = {
        associations = [];
        fearConditions = [];
        rewardAssociations = [];
        currentMoodBias = 0.0;
      };
      consolidationBuffer = [];
      consolidationProgress = 0.0;
      retrievalState = {
        retrievalCue = null;
        retrievedItems = [];
        retrievalStrengths = [];
        retrievalMode = #Free;
        activatedConcepts = [];
      };
      beatNum = 0;
    }
  };

  /// Encode new episodic memory
  public func encodeEpisodicMemory(
    ltm: LongTermMemoryState,
    event: [Float],
    location: { lat: Float; lon: Float; alt: Float },
    emotionalValence: Float,
    emotionalArousal: Float
  ) : LongTermMemoryState {
    let newEpisode : EpisodicMemoryItem = {
      episodeId = ltm.episodicMemory.episodes.size();
      eventDescription = event;
      objects = [];
      location = location;
      spatialContext = [[]];
      timestamp = ltm.beatNum;
      temporalContext = Float.fromInt(ltm.beatNum % 1000) / 1000.0;
      emotionalValence = emotionalValence;
      emotionalArousal = emotionalArousal;
      memoryStrength = 1.0;
      lastAccessed = ltm.beatNum;
      accessCount = 1;
    };
    
    var newEpisodes = Array.append(ltm.episodicMemory.episodes, [newEpisode]);
    if (newEpisodes.size() > ltm.episodicMemory.maxEpisodes) {
      // Remove weakest
      newEpisodes := Array.filter<EpisodicMemoryItem>(newEpisodes, func(e) {
        e.memoryStrength > 0.1
      });
    };
    
    // Update indices
    let newTemporalIndex = Array.append(ltm.episodicMemory.temporalIndex, 
      [(ltm.beatNum, newEpisode.episodeId)]);
    let newSpatialIndex = Array.append(ltm.episodicMemory.spatialIndex,
      [(location.lat, location.lon, newEpisode.episodeId)]);
    
    {
      episodicMemory = {
        episodes = newEpisodes;
        maxEpisodes = ltm.episodicMemory.maxEpisodes;
        temporalIndex = newTemporalIndex;
        spatialIndex = newSpatialIndex;
        recentAccess = ltm.episodicMemory.recentAccess;
      };
      semanticMemory = ltm.semanticMemory;
      proceduralMemory = ltm.proceduralMemory;
      emotionalMemory = ltm.emotionalMemory;
      consolidationBuffer = ltm.consolidationBuffer;
      consolidationProgress = ltm.consolidationProgress;
      retrievalState = ltm.retrievalState;
      beatNum = ltm.beatNum;
    }
  };

  /// Retrieve episodic memory by location
  public func retrieveByLocation(
    ltm: LongTermMemoryState,
    queryLat: Float,
    queryLon: Float,
    radius: Float
  ) : [EpisodicMemoryItem] {
    var retrieved : [EpisodicMemoryItem] = [];
    
    for ((lat, lon, episodeId) in ltm.episodicMemory.spatialIndex.vals()) {
      let dist = Float.sqrt((lat - queryLat) ** 2.0 + (lon - queryLon) ** 2.0);
      if (dist < radius) {
        for (episode in ltm.episodicMemory.episodes.vals()) {
          if (episode.episodeId == episodeId) {
            retrieved := Array.append(retrieved, [episode]);
          };
        };
      };
    };
    
    retrieved
  };

  /// Learn procedural skill
  public func learnProceduralSkill(
    ltm: LongTermMemoryState,
    skillName: Text,
    actionSequence: [MotorAction],
    triggerConditions: [Float]
  ) : LongTermMemoryState {
    // Check if skill already exists
    var existingSkill : ?Nat = null;
    for (skill in ltm.proceduralMemory.skills.vals()) {
      if (skill.name == skillName) {
        existingSkill := ?skill.skillId;
      };
    };
    
    switch (existingSkill) {
      case (?skillId) {
        // Strengthen existing skill
        let newSkills = Array.map<ProceduralSkill, ProceduralSkill>(
          ltm.proceduralMemory.skills,
          func(skill) {
            if (skill.skillId == skillId) {
              {
                skillId = skill.skillId;
                name = skill.name;
                triggerConditions = skill.triggerConditions;
                actionSequence = skill.actionSequence;
                proficiency = Float.min(skill.proficiency + 0.1, 1.0);
                executionSpeed = skill.executionSpeed * 0.95;  // Gets faster
                errorRate = skill.errorRate * 0.95;  // Fewer errors
                practiceCount = skill.practiceCount + 1;
                lastPractice = ltm.beatNum;
              }
            } else { skill }
          }
        );
        
        {
          episodicMemory = ltm.episodicMemory;
          semanticMemory = ltm.semanticMemory;
          proceduralMemory = {
            skills = newSkills;
            habits = ltm.proceduralMemory.habits;
            motorPrograms = ltm.proceduralMemory.motorPrograms;
            activeSkill = ltm.proceduralMemory.activeSkill;
            skillChaining = ltm.proceduralMemory.skillChaining;
          };
          emotionalMemory = ltm.emotionalMemory;
          consolidationBuffer = ltm.consolidationBuffer;
          consolidationProgress = ltm.consolidationProgress;
          retrievalState = ltm.retrievalState;
          beatNum = ltm.beatNum;
        }
      };
      case null {
        // Create new skill
        let newSkill : ProceduralSkill = {
          skillId = ltm.proceduralMemory.skills.size();
          name = skillName;
          triggerConditions = triggerConditions;
          actionSequence = actionSequence;
          proficiency = 0.1;
          executionSpeed = 1.0;
          errorRate = 0.3;
          practiceCount = 1;
          lastPractice = ltm.beatNum;
        };
        
        {
          episodicMemory = ltm.episodicMemory;
          semanticMemory = ltm.semanticMemory;
          proceduralMemory = {
            skills = Array.append(ltm.proceduralMemory.skills, [newSkill]);
            habits = ltm.proceduralMemory.habits;
            motorPrograms = ltm.proceduralMemory.motorPrograms;
            activeSkill = ltm.proceduralMemory.activeSkill;
            skillChaining = ltm.proceduralMemory.skillChaining;
          };
          emotionalMemory = ltm.emotionalMemory;
          consolidationBuffer = ltm.consolidationBuffer;
          consolidationProgress = ltm.consolidationProgress;
          retrievalState = ltm.retrievalState;
          beatNum = ltm.beatNum;
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 27: AUTONOMIC NERVOUS SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The drone's automatic body regulation:
  //   • Sympathetic - Fight or flight (increase alertness, power)
  //   • Parasympathetic - Rest and digest (conserve energy)
  //   • Homeostasis - Battery, temperature, signal strength
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Autonomic nervous system state
  public type AutonomicNervousSystemState = {
    // Sympathetic branch
    sympathetic       : SympatheticState;
    
    // Parasympathetic branch
    parasympathetic   : ParasympatheticState;
    
    // Homeostatic variables
    homeostasis       : HomeostasisState;
    
    // Balance
    autonomicBalance  : Float;       // -1 = para, +1 = symp
    
    // Circadian rhythm (activity cycle)
    circadianPhase    : Float;
    
    beatNum           : Nat;
  };

  /// Sympathetic state
  public type SympatheticState = {
    // Activation level
    activationLevel   : Float;
    
    // Effects
    heartRateIncrease : Float;      // Motor speed increase proxy
    bronchodilation   : Float;      // Cooling fan speed
    pupilDilation     : Float;      // Sensor sensitivity
    
    // Adrenaline equivalent
    adrenaline        : Float;
    
    // Fight or flight selection
    fightResponse     : Float;
    flightResponse    : Float;
    
    // Energy mobilization
    glucoseRelease    : Float;      // Battery reserve release
  };

  /// Parasympathetic state
  public type ParasympatheticState = {
    // Activation level
    activationLevel   : Float;
    
    // Effects
    heartRateDecrease : Float;      // Motor speed reduction
    digestion         : Float;      // Charging/maintenance
    relaxation        : Float;
    
    // Acetylcholine equivalent
    acetylcholine     : Float;
    
    // Rest states
    restMode          : Bool;
    recoveryRate      : Float;
  };

  /// Homeostasis state
  public type HomeostasisState = {
    // Energy
    batteryLevel      : Float;
    batterySetpoint   : Float;
    batteryError      : Float;
    
    // Temperature
    coreTemperature   : Float;
    temperatureSetpoint : Float;
    temperatureError  : Float;
    
    // Signal/communication
    signalStrength    : Float;
    signalSetpoint    : Float;
    signalError       : Float;
    
    // Structural integrity
    structuralHealth  : Float;
    structuralSetpoint : Float;
    structuralError   : Float;
    
    // Overall homeostatic state
    homeostasisDeviation : Float;
    
    // Allostatic load (chronic stress)
    allostaticLoad    : Float;
  };

  /// Initialize autonomic nervous system
  public func initAutonomicNS() : AutonomicNervousSystemState {
    {
      sympathetic = {
        activationLevel = 0.2;
        heartRateIncrease = 0.0;
        bronchodilation = 0.0;
        pupilDilation = 0.5;
        adrenaline = 0.1;
        fightResponse = 0.0;
        flightResponse = 0.0;
        glucoseRelease = 0.0;
      };
      parasympathetic = {
        activationLevel = 0.5;
        heartRateDecrease = 0.0;
        digestion = 0.3;
        relaxation = 0.5;
        acetylcholine = 0.5;
        restMode = false;
        recoveryRate = 0.1;
      };
      homeostasis = {
        batteryLevel = 1.0;
        batterySetpoint = 0.8;
        batteryError = 0.0;
        coreTemperature = 30.0;
        temperatureSetpoint = 35.0;
        temperatureError = 0.0;
        signalStrength = 0.9;
        signalSetpoint = 0.7;
        signalError = 0.0;
        structuralHealth = 1.0;
        structuralSetpoint = 0.9;
        structuralError = 0.0;
        homeostasisDeviation = 0.0;
        allostaticLoad = 0.0;
      };
      autonomicBalance = 0.0;
      circadianPhase = 0.0;
      beatNum = 0;
    }
  };

  /// Update autonomic nervous system
  public func updateAutonomicNS(
    ans: AutonomicNervousSystemState,
    threatLevel: Float,
    batteryLevel: Float,
    temperature: Float,
    signalStrength: Float,
    structuralHealth: Float,
    dt: Float
  ) : AutonomicNervousSystemState {
    // Compute homeostatic errors
    let batteryError = batteryLevel - ans.homeostasis.batterySetpoint;
    let tempError = temperature - ans.homeostasis.temperatureSetpoint;
    let signalError = signalStrength - ans.homeostasis.signalSetpoint;
    let structError = structuralHealth - ans.homeostasis.structuralSetpoint;
    
    // Total homeostatic deviation
    let totalDeviation = Float.sqrt(
      batteryError ** 2.0 + tempError ** 2.0 + signalError ** 2.0 + structError ** 2.0
    );
    
    // Sympathetic activation (threat + low battery + high temp)
    let sympDrive = threatLevel * 0.5 + 
                    (if (batteryLevel < 0.3) { 0.5 - batteryLevel } else { 0.0 }) +
                    (if (temperature > 60.0) { (temperature - 60.0) / 40.0 } else { 0.0 });
    
    let newSympActivation = ans.sympathetic.activationLevel * 0.9 + sympDrive * 0.1;
    
    // Parasympathetic activation (safety, charging)
    let paraDrive = (1.0 - threatLevel) * 0.3 +
                    (if (batteryLevel > 0.9) { 0.3 } else { 0.0 }) +
                    (if (structuralHealth > 0.95) { 0.2 } else { 0.0 });
    
    let newParaActivation = ans.parasympathetic.activationLevel * 0.9 + paraDrive * 0.1;
    
    // Autonomic balance
    let newBalance = (newSympActivation - newParaActivation) / (newSympActivation + newParaActivation + 0.001);
    
    // Adrenaline dynamics
    let adrenalineRelease = if (threatLevel > 0.5) { threatLevel * 0.2 } else { 0.0 };
    let newAdrenaline = ans.sympathetic.adrenaline * 0.95 + adrenalineRelease;
    
    // Fight vs flight decision
    let fightScore = threatLevel * (1.0 - Float.abs(newBalance - 0.5)) * (batteryLevel);
    let flightScore = threatLevel * Float.abs(newBalance - 0.5) * (1.0 - batteryLevel * 0.5);
    
    // Allostatic load accumulation
    let newAllostaticLoad = ans.homeostasis.allostaticLoad * 0.999 + totalDeviation * 0.001;
    
    // Circadian rhythm
    let newCircadianPhase = Float.sin(Float.fromInt(ans.beatNum) * 0.001);
    
    {
      sympathetic = {
        activationLevel = newSympActivation;
        heartRateIncrease = newSympActivation * 0.5;
        bronchodilation = Float.max(0.0, tempError * 0.1);
        pupilDilation = 0.5 + newSympActivation * 0.3;
        adrenaline = newAdrenaline;
        fightResponse = fightScore;
        flightResponse = flightScore;
        glucoseRelease = if (batteryLevel < 0.2) { 0.5 } else { 0.0 };
      };
      parasympathetic = {
        activationLevel = newParaActivation;
        heartRateDecrease = newParaActivation * 0.3;
        digestion = newParaActivation * (if (batteryLevel < 0.5) { 1.0 } else { 0.5 });
        relaxation = newParaActivation * (1.0 - threatLevel);
        acetylcholine = newParaActivation * 0.8;
        restMode = newParaActivation > 0.7 and threatLevel < 0.1;
        recoveryRate = newParaActivation * 0.2;
      };
      homeostasis = {
        batteryLevel = batteryLevel;
        batterySetpoint = ans.homeostasis.batterySetpoint;
        batteryError = batteryError;
        coreTemperature = temperature;
        temperatureSetpoint = ans.homeostasis.temperatureSetpoint;
        temperatureError = tempError;
        signalStrength = signalStrength;
        signalSetpoint = ans.homeostasis.signalSetpoint;
        signalError = signalError;
        structuralHealth = structuralHealth;
        structuralSetpoint = ans.homeostasis.structuralSetpoint;
        structuralError = structError;
        homeostasisDeviation = totalDeviation;
        allostaticLoad = newAllostaticLoad;
      };
      autonomicBalance = newBalance;
      circadianPhase = newCircadianPhase;
      beatNum = ans.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 28: COMPLETE INTEGRATED DRONE BRAIN
  // ═══════════════════════════════════════════════════════════════════════════════
  // The FULL brain with ALL systems integrated
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Complete integrated drone brain
  public type FullDroneBrain = {
    // Core brain (from earlier sections)
    coreBrain         : DroneBrainCore;
    
    // Sensory systems
    visualCortex      : VisualCortexState;
    auditoryCortex    : AuditoryCortexState;
    somatosensory     : SomatosensoryCortexState;
    
    // Memory systems
    workingMemory     : WorkingMemoryState;
    longTermMemory    : LongTermMemoryState;
    
    // Autonomic regulation
    autonomicNS       : AutonomicNervousSystemState;
    
    // Global state
    globalWorkspace   : GlobalWorkspaceState;
    
    // Integration metrics
    integrationLevel  : Float;
    bindingStrength   : Float;
    
    beatNum           : Nat;
  };

  /// Global workspace state (for consciousness-like integration)
  public type GlobalWorkspaceState = {
    // Broadcast content
    broadcastContent  : [Float];
    broadcastStrength : Float;
    
    // Competition
    competingContents : [[Float]];
    competitionState  : [Float];
    
    // Access consciousness
    accessedModules   : [Text];
    
    // Ignition
    ignitionThreshold : Float;
    ignitionActive    : Bool;
    
    // Binding
    boundRepresentation : [Float];
    temporalBinding   : Float;
  };

  /// Initialize full drone brain
  public func initFullDroneBrain(droneId: Nat) : FullDroneBrain {
    {
      coreBrain = initDroneBrain(droneId);
      visualCortex = initVisualCortex(20);
      auditoryCortex = initAuditoryCortex(32);
      somatosensory = initSomatosensoryCortex(4);
      workingMemory = initWorkingMemory();
      longTermMemory = initLongTermMemory();
      autonomicNS = initAutonomicNS();
      globalWorkspace = {
        broadcastContent = [];
        broadcastStrength = 0.0;
        competingContents = [[]];
        competitionState = [];
        accessedModules = [];
        ignitionThreshold = 0.5;
        ignitionActive = false;
        boundRepresentation = [];
        temporalBinding = 0.0;
      };
      integrationLevel = 0.5;
      bindingStrength = 0.5;
      beatNum = 0;
    }
  };

  /// Full brain tick - integrate ALL systems
  public func tickFullDroneBrain(
    brain: FullDroneBrain,
    visualInput: [[Float]],
    audioInput: { left: [Float]; right: [Float] },
    motorSpeeds: [Float],
    motorCurrents: [Float],
    batteryLevel: Float,
    ambientTemp: Float,
    signalStrength: Float,
    dt: Float
  ) : FullDroneBrain {
    // 1. Process visual input
    let newV1 = processV1(brain.visualCortex.v1, visualInput, 1.0);
    
    // 2. Process motion
    let prevFrame = if (brain.visualCortex.beatNum > 0) { visualInput } else { visualInput };
    let newMT = processMT(brain.visualCortex.mt, visualInput, prevFrame, dt);
    
    // 3. Process audio
    let newAuditory = processAudio(brain.auditoryCortex, audioInput.left, audioInput.right, 44100.0);
    
    // 4. Update somatosensory
    let newSoma = updateSomatosensory(brain.somatosensory, motorSpeeds, motorCurrents, [], ambientTemp, dt);
    
    // 5. Update autonomic NS
    let threatLevel = brain.coreBrain.amygdala.threatLevel;
    let newANS = updateAutonomicNS(
      brain.autonomicNS,
      threatLevel,
      batteryLevel,
      newSoma.thermalMap[0],
      signalStrength,
      1.0 - newSoma.damageMap[0],
      dt
    );
    
    // 6. Update working memory
    let newWM = updateWorkingMemory(brain.workingMemory, dt);
    
    // 7. Global workspace integration
    // Determine what wins competition for broadcast
    var maxSalience : Float = 0.0;
    var winningContent : [Float] = [];
    var winningModule : Text = "";
    
    // Check visual salience
    let visualSalience = brain.visualCortex.visualAttention;
    if (visualSalience > maxSalience) {
      maxSalience := visualSalience;
      winningModule := "visual";
    };
    
    // Check threat salience
    if (threatLevel > maxSalience) {
      maxSalience := threatLevel;
      winningModule := "amygdala";
    };
    
    // Check pain salience
    for (pain in newSoma.nociceptors.vals()) {
      if (pain > maxSalience) {
        maxSalience := pain;
        winningModule := "pain";
      };
    };
    
    // Ignition
    let ignitionActive = maxSalience > brain.globalWorkspace.ignitionThreshold;
    
    // 8. Compute integration metrics
    let newIntegration = if (ignitionActive) {
      brain.integrationLevel * 0.9 + 0.1
    } else {
      brain.integrationLevel * 0.99
    };
    
    // Construct updated brain
    {
      coreBrain = brain.coreBrain;
      visualCortex = {
        v1 = newV1;
        v2 = brain.visualCortex.v2;
        v4 = brain.visualCortex.v4;
        mt = newMT;
        it = brain.visualCortex.it;
        parietal = brain.visualCortex.parietal;
        currentGaze = brain.visualCortex.currentGaze;
        saccadeTarget = brain.visualCortex.saccadeTarget;
        visualAttention = brain.visualCortex.visualAttention;
        boundObjects = brain.visualCortex.boundObjects;
        sceneGist = brain.visualCortex.sceneGist;
        beatNum = brain.visualCortex.beatNum + 1;
      };
      auditoryCortex = newAuditory;
      somatosensory = newSoma;
      workingMemory = newWM;
      longTermMemory = brain.longTermMemory;
      autonomicNS = newANS;
      globalWorkspace = {
        broadcastContent = winningContent;
        broadcastStrength = maxSalience;
        competingContents = brain.globalWorkspace.competingContents;
        competitionState = brain.globalWorkspace.competitionState;
        accessedModules = [winningModule];
        ignitionThreshold = brain.globalWorkspace.ignitionThreshold;
        ignitionActive = ignitionActive;
        boundRepresentation = brain.globalWorkspace.boundRepresentation;
        temporalBinding = brain.globalWorkspace.temporalBinding;
      };
      integrationLevel = newIntegration;
      bindingStrength = brain.bindingStrength;
      beatNum = brain.beatNum + 1;
    }
  };

  /// Generate complete brain output
  public type FullBrainOutput = {
    // Identity
    beatNum           : Nat;
    
    // Sensory summary
    visualSalience    : Float;
    auditoryDirection : Float;
    bodyTemperature   : Float;
    painLevel         : Float;
    
    // Memory
    workingMemoryLoad : Float;
    
    // Autonomic
    sympatheticLevel  : Float;
    parasympatheticLevel : Float;
    autonomicBalance  : Float;
    
    // Integration
    ignitionActive    : Bool;
    integrationLevel  : Float;
    
    // Homeostasis
    batteryError      : Float;
    temperatureError  : Float;
    allostaticLoad    : Float;
  };

  public func generateFullBrainOutput(brain: FullDroneBrain) : FullBrainOutput {
    var maxPain : Float = 0.0;
    for (p in brain.somatosensory.nociceptors.vals()) {
      if (p > maxPain) { maxPain := p };
    };
    
    {
      beatNum = brain.beatNum;
      visualSalience = brain.visualCortex.visualAttention;
      auditoryDirection = brain.auditoryCortex.soundDirection;
      bodyTemperature = if (brain.somatosensory.thermalMap.size() > 0) {
        brain.somatosensory.thermalMap[0]
      } else { 25.0 };
      painLevel = maxPain;
      workingMemoryLoad = brain.workingMemory.currentLoad;
      sympatheticLevel = brain.autonomicNS.sympathetic.activationLevel;
      parasympatheticLevel = brain.autonomicNS.parasympathetic.activationLevel;
      autonomicBalance = brain.autonomicNS.autonomicBalance;
      ignitionActive = brain.globalWorkspace.ignitionActive;
      integrationLevel = brain.integrationLevel;
      batteryError = brain.autonomicNS.homeostasis.batteryError;
      temperatureError = brain.autonomicNS.homeostasis.temperatureError;
      allostaticLoad = brain.autonomicNS.homeostasis.allostaticLoad;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ███████╗██████╗ ██╗███╗   ██╗ █████╗ ██╗          ██████╗ ██████╗ ██████╗ ██████╗ 
  // ██╔════╝██╔══██╗██║████╗  ██║██╔══██╗██║         ██╔════╝██╔═══██╗██╔══██╗██╔══██╗
  // ███████╗██████╔╝██║██╔██╗ ██║███████║██║         ██║     ██║   ██║██████╔╝██║  ██║
  // ╚════██║██╔═══╝ ██║██║╚██╗██║██╔══██║██║         ██║     ██║   ██║██╔══██╗██║  ██║
  // ███████║██║     ██║██║ ╚████║██║  ██║███████╗    ╚██████╗╚██████╔╝██║  ██║██████╔╝
  // ╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 29: SPINAL CORD EQUIVALENT — MOTOR PATTERN GENERATORS
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The drone's "spinal cord" contains central pattern generators (CPGs) that 
  // produce rhythmic motor patterns without continuous brain input:
  //   • Flight CPG - Wing/rotor oscillations
  //   • Locomotion CPG - Ground movement
  //   • Stabilization CPG - Balance reflexes
  //   • Breathing CPG - Cooling fan patterns
  //
  // This allows the drone to maintain flight even if higher brain functions
  // are temporarily disrupted.
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Spinal cord state
  public type SpinalCordState = {
    // Central pattern generators
    flightCPG         : CPGState;
    locomotionCPG     : CPGState;
    stabilizationCPG  : CPGState;
    coolingCPG        : CPGState;
    
    // Reflex arcs
    reflexArcs        : [ReflexArc];
    
    // Motor neuron pools
    motorNeuronPools  : [MotorNeuronPool];
    
    // Descending commands from brain
    descendingCommand : DescendingCommand;
    
    // Ascending sensory
    ascendingSensory  : [Float];
    
    // Spinal interneurons
    interneuronActivity : [[Float]];
    
    // Gate control (pain modulation)
    gateControlState  : Float;
    
    beatNum           : Nat;
  };

  /// Central Pattern Generator state
  public type CPGState = {
    // Oscillator neurons
    oscillators       : [CPGOscillator];
    
    // Coupling between oscillators
    couplingMatrix    : [[Float]];
    
    // Global phase
    globalPhase       : Float;
    
    // Frequency control
    baseFrequency     : Float;
    currentFrequency  : Float;
    
    // Amplitude control
    baseAmplitude     : Float;
    currentAmplitude  : Float;
    
    // Output pattern
    outputPattern     : [Float];
    
    // Modulation
    neuromodulation   : Float;
    
    // Active state
    isActive          : Bool;
  };

  /// CPG Oscillator
  public type CPGOscillator = {
    oscillatorId      : Nat;
    phase             : Float;
    amplitude         : Float;
    intrinsicFrequency : Float;
    
    // Flexor/extensor identity
    neuronType        : { #Flexor; #Extensor; #Interneuron };
    
    // State variables (for nonlinear oscillator)
    x                 : Float;
    y                 : Float;
    
    // Adaptation
    adaptation        : Float;
  };

  /// Reflex arc
  public type ReflexArc = {
    reflexId          : Nat;
    reflexType        : ReflexType;
    
    // Sensory input
    sensorThreshold   : Float;
    currentSensorValue : Float;
    
    // Processing
    interneuronGain   : Float;
    latency           : Nat;          // Beats delay
    
    // Motor output
    motorOutput       : Float;
    targetMuscles     : [Nat];
    
    // Modulation from brain
    supraspinalGain   : Float;
    
    // State
    isTriggered       : Bool;
    lastTriggerBeat   : Nat;
  };

  /// Reflex types
  public type ReflexType = {
    #StretchReflex;           // Myotatic reflex
    #WithdrawalReflex;        // Nociceptive
    #CrossedExtensor;         // Contralateral
    #VestibularReflex;        // Balance
    #ProtectiveReflex;        // Collision avoidance
    #ThermalReflex;           // Overheating response
    #StabilizationReflex;     // Attitude correction
  };

  /// Motor neuron pool
  public type MotorNeuronPool = {
    poolId            : Nat;
    targetMuscle      : Nat;          // Motor ID
    
    // Neurons
    numNeurons        : Nat;
    recruitmentOrder  : [Nat];
    
    // Activation
    driveLevel        : Float;
    activeNeurons     : Nat;
    firingRate        : Float;
    
    // Size principle (Henneman)
    sizeThresholds    : [Float];
    
    // Output
    muscleActivation  : Float;
    
    // Fatigue
    fatigueLevel      : Float;
    recoveryRate      : Float;
  };

  /// Descending command from brain
  public type DescendingCommand = {
    // Corticospinal (voluntary)
    corticospinalDrive : [Float];
    
    // Rubrospinal (limb control)
    rubrospinalDrive  : [Float];
    
    // Vestibulospinal (balance)
    vestibulospinalDrive : [Float];
    
    // Reticulospinal (posture, locomotion)
    reticulospinalDrive : [Float];
    
    // Overall gain
    descendingGain    : Float;
  };

  /// Initialize spinal cord
  public func initSpinalCord(numMotors: Nat) : SpinalCordState {
    // Initialize flight CPG
    let flightOscillators = Array.tabulate<CPGOscillator>(numMotors, func(i) {
      let phase = Float.fromInt(i) * TWO_PI / Float.fromInt(numMotors);
      {
        oscillatorId = i;
        phase = phase;
        amplitude = 1.0;
        intrinsicFrequency = 50.0;  // 50 Hz for motor
        neuronType = if (i % 2 == 0) { #Flexor } else { #Extensor };
        x = Float.cos(phase);
        y = Float.sin(phase);
        adaptation = 0.0;
      }
    });
    
    // Coupling matrix (nearest neighbor coupling)
    let flightCoupling = Array.tabulate<[Float]>(numMotors, func(i) {
      Array.tabulate<Float>(numMotors, func(j) {
        if (i == j) { 0.0 }
        else if (Int.abs(i - j) == 1 or Int.abs(i - j) == numMotors - 1) { 0.5 }
        else { 0.0 }
      })
    });
    
    let flightCPG : CPGState = {
      oscillators = flightOscillators;
      couplingMatrix = flightCoupling;
      globalPhase = 0.0;
      baseFrequency = 50.0;
      currentFrequency = 50.0;
      baseAmplitude = 1.0;
      currentAmplitude = 0.0;
      outputPattern = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
      neuromodulation = 1.0;
      isActive = false;
    };
    
    // Initialize reflexes
    let reflexes : [ReflexArc] = [
      // Stretch reflex for each motor
      {
        reflexId = 0;
        reflexType = #StretchReflex;
        sensorThreshold = 0.3;
        currentSensorValue = 0.0;
        interneuronGain = 2.0;
        latency = 1;
        motorOutput = 0.0;
        targetMuscles = [0, 1, 2, 3];
        supraspinalGain = 1.0;
        isTriggered = false;
        lastTriggerBeat = 0;
      },
      // Protective reflex
      {
        reflexId = 1;
        reflexType = #ProtectiveReflex;
        sensorThreshold = 0.8;
        currentSensorValue = 0.0;
        interneuronGain = 5.0;
        latency = 1;
        motorOutput = 0.0;
        targetMuscles = [0, 1, 2, 3];
        supraspinalGain = 1.0;
        isTriggered = false;
        lastTriggerBeat = 0;
      },
      // Stabilization reflex
      {
        reflexId = 2;
        reflexType = #StabilizationReflex;
        sensorThreshold = 0.1;
        currentSensorValue = 0.0;
        interneuronGain = 3.0;
        latency = 1;
        motorOutput = 0.0;
        targetMuscles = [0, 1, 2, 3];
        supraspinalGain = 1.0;
        isTriggered = false;
        lastTriggerBeat = 0;
      },
      // Thermal reflex
      {
        reflexId = 3;
        reflexType = #ThermalReflex;
        sensorThreshold = 70.0;
        currentSensorValue = 25.0;
        interneuronGain = 2.0;
        latency = 2;
        motorOutput = 0.0;
        targetMuscles = [0, 1, 2, 3];
        supraspinalGain = 0.5;
        isTriggered = false;
        lastTriggerBeat = 0;
      }
    ];
    
    // Motor neuron pools
    let pools = Array.tabulate<MotorNeuronPool>(numMotors, func(i) {
      {
        poolId = i;
        targetMuscle = i;
        numNeurons = 100;
        recruitmentOrder = Array.tabulate<Nat>(100, func(j) { j });
        driveLevel = 0.0;
        activeNeurons = 0;
        firingRate = 0.0;
        sizeThresholds = Array.tabulate<Float>(100, func(j) { Float.fromInt(j) / 100.0 });
        muscleActivation = 0.0;
        fatigueLevel = 0.0;
        recoveryRate = 0.01;
      }
    });
    
    {
      flightCPG = flightCPG;
      locomotionCPG = {
        oscillators = [];
        couplingMatrix = [[]];
        globalPhase = 0.0;
        baseFrequency = 2.0;
        currentFrequency = 2.0;
        baseAmplitude = 1.0;
        currentAmplitude = 0.0;
        outputPattern = [];
        neuromodulation = 1.0;
        isActive = false;
      };
      stabilizationCPG = {
        oscillators = [];
        couplingMatrix = [[]];
        globalPhase = 0.0;
        baseFrequency = 10.0;
        currentFrequency = 10.0;
        baseAmplitude = 0.5;
        currentAmplitude = 0.0;
        outputPattern = [];
        neuromodulation = 1.0;
        isActive = true;
      };
      coolingCPG = {
        oscillators = [];
        couplingMatrix = [[]];
        globalPhase = 0.0;
        baseFrequency = 1.0;
        currentFrequency = 1.0;
        baseAmplitude = 0.3;
        currentAmplitude = 0.0;
        outputPattern = [];
        neuromodulation = 1.0;
        isActive = false;
      };
      reflexArcs = reflexes;
      motorNeuronPools = pools;
      descendingCommand = {
        corticospinalDrive = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
        rubrospinalDrive = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
        vestibulospinalDrive = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
        reticulospinalDrive = Array.tabulate<Float>(numMotors, func(_) { 0.0 });
        descendingGain = 1.0;
      };
      ascendingSensory = Array.tabulate<Float>(10, func(_) { 0.0 });
      interneuronActivity = [[]];
      gateControlState = 0.5;
      beatNum = 0;
    }
  };

  /// Update CPG (Matsuoka oscillator model)
  public func updateCPG(cpg: CPGState, drive: Float, dt: Float) : CPGState {
    if (not cpg.isActive) {
      return cpg;
    };
    
    let tau = 1.0 / cpg.currentFrequency;
    let tauA = tau * 2.0;  // Adaptation time constant
    let beta = 2.5;        // Adaptation strength
    
    let newOscillators = Array.tabulate<CPGOscillator>(cpg.oscillators.size(), func(i) {
      let osc = cpg.oscillators[i];
      
      // Coupling input
      var couplingInput : Float = 0.0;
      for (j in Iter.range(0, cpg.oscillators.size() - 1)) {
        if (j < cpg.couplingMatrix[i].size()) {
          let w = cpg.couplingMatrix[i][j];
          let other = cpg.oscillators[j];
          couplingInput += w * Float.max(0.0, other.x);
        };
      };
      
      // Matsuoka dynamics
      let inputDrive = drive * cpg.neuromodulation;
      let dx = (-osc.x - beta * osc.adaptation - couplingInput + inputDrive) / tau * dt;
      let dy = (-osc.y + Float.max(0.0, osc.x)) / tau * dt;
      let dAdapt = (-osc.adaptation + Float.max(0.0, osc.x)) / tauA * dt;
      
      let newX = osc.x + dx;
      let newY = osc.y + dy;
      let newAdapt = osc.adaptation + dAdapt;
      
      // Phase from state
      let newPhase = Float.arctan2(newY, newX);
      
      {
        oscillatorId = osc.oscillatorId;
        phase = newPhase;
        amplitude = Float.sqrt(newX * newX + newY * newY);
        intrinsicFrequency = osc.intrinsicFrequency;
        neuronType = osc.neuronType;
        x = newX;
        y = newY;
        adaptation = newAdapt;
      }
    });
    
    // Output pattern
    let newOutput = Array.map<CPGOscillator, Float>(newOscillators, func(osc) {
      Float.max(0.0, osc.x) * cpg.currentAmplitude
    });
    
    // Global phase from first oscillator
    let globalPhase = if (newOscillators.size() > 0) {
      newOscillators[0].phase
    } else { 0.0 };
    
    {
      oscillators = newOscillators;
      couplingMatrix = cpg.couplingMatrix;
      globalPhase = globalPhase;
      baseFrequency = cpg.baseFrequency;
      currentFrequency = cpg.currentFrequency;
      baseAmplitude = cpg.baseAmplitude;
      currentAmplitude = cpg.currentAmplitude;
      outputPattern = newOutput;
      neuromodulation = cpg.neuromodulation;
      isActive = cpg.isActive;
    }
  };

  /// Process reflex
  public func processReflex(reflex: ReflexArc, sensorValue: Float, beat: Nat) : ReflexArc {
    let triggered = sensorValue > reflex.sensorThreshold;
    let output = if (triggered) {
      (sensorValue - reflex.sensorThreshold) * reflex.interneuronGain * reflex.supraspinalGain
    } else { 0.0 };
    
    {
      reflexId = reflex.reflexId;
      reflexType = reflex.reflexType;
      sensorThreshold = reflex.sensorThreshold;
      currentSensorValue = sensorValue;
      interneuronGain = reflex.interneuronGain;
      latency = reflex.latency;
      motorOutput = output;
      targetMuscles = reflex.targetMuscles;
      supraspinalGain = reflex.supraspinalGain;
      isTriggered = triggered;
      lastTriggerBeat = if (triggered) { beat } else { reflex.lastTriggerBeat };
    }
  };

  /// Update motor neuron pool (size principle recruitment)
  public func updateMotorPool(pool: MotorNeuronPool, drive: Float, dt: Float) : MotorNeuronPool {
    // Count recruited neurons based on drive level
    var recruited : Nat = 0;
    for (threshold in pool.sizeThresholds.vals()) {
      if (drive > threshold) { recruited += 1 };
    };
    
    // Firing rate increases with drive above recruitment threshold
    let firingRate = if (recruited > 0) {
      let avgThreshold = Float.fromInt(recruited) / Float.fromInt(pool.numNeurons) / 2.0;
      (drive - avgThreshold) * 100.0  // Hz
    } else { 0.0 };
    
    // Muscle activation from recruited neurons and firing rate
    let activation = Float.fromInt(recruited) / Float.fromInt(pool.numNeurons) * 
                     Float.min(firingRate / 50.0, 1.0);
    
    // Fatigue
    let newFatigue = pool.fatigueLevel + activation * 0.001 * dt - pool.recoveryRate * dt;
    let clampedFatigue = Float.max(0.0, Float.min(1.0, newFatigue));
    
    // Fatigue reduces effective activation
    let effectiveActivation = activation * (1.0 - clampedFatigue * 0.5);
    
    {
      poolId = pool.poolId;
      targetMuscle = pool.targetMuscle;
      numNeurons = pool.numNeurons;
      recruitmentOrder = pool.recruitmentOrder;
      driveLevel = drive;
      activeNeurons = recruited;
      firingRate = firingRate;
      sizeThresholds = pool.sizeThresholds;
      muscleActivation = effectiveActivation;
      fatigueLevel = clampedFatigue;
      recoveryRate = pool.recoveryRate;
    }
  };

  /// Full spinal cord tick
  public func tickSpinalCord(
    spinal: SpinalCordState,
    descendingDrive: [Float],
    sensoryInput: [Float],
    vestibularInput: { roll: Float; pitch: Float; yaw: Float },
    temperature: Float,
    collisionThreat: Float,
    dt: Float
  ) : SpinalCordState {
    let numMotors = spinal.motorNeuronPools.size();
    
    // 1. Update CPGs
    let avgDrive = if (descendingDrive.size() > 0) {
      var sum : Float = 0.0;
      for (d in descendingDrive.vals()) { sum += d };
      sum / Float.fromInt(descendingDrive.size())
    } else { 0.0 };
    
    let newFlightCPG = updateCPG(spinal.flightCPG, avgDrive, dt);
    let newStabCPG = updateCPG(spinal.stabilizationCPG, 
      Float.sqrt(vestibularInput.roll ** 2.0 + vestibularInput.pitch ** 2.0), dt);
    
    // 2. Process reflexes
    let newReflexes = Array.tabulate<ReflexArc>(spinal.reflexArcs.size(), func(i) {
      let reflex = spinal.reflexArcs[i];
      let sensorVal = switch (reflex.reflexType) {
        case (#StabilizationReflex) {
          Float.sqrt(vestibularInput.roll ** 2.0 + vestibularInput.pitch ** 2.0)
        };
        case (#ThermalReflex) { temperature };
        case (#ProtectiveReflex) { collisionThreat };
        case _ {
          if (i < sensoryInput.size()) { sensoryInput[i] } else { 0.0 }
        };
      };
      processReflex(reflex, sensorVal, spinal.beatNum)
    });
    
    // 3. Combine all inputs to motor pools
    let motorDrives = Array.tabulate<Float>(numMotors, func(i) {
      var totalDrive : Float = 0.0;
      
      // Descending command
      if (i < descendingDrive.size()) {
        totalDrive += descendingDrive[i] * spinal.descendingCommand.descendingGain;
      };
      
      // CPG contribution
      if (i < newFlightCPG.outputPattern.size()) {
        totalDrive += newFlightCPG.outputPattern[i];
      };
      
      // Stabilization CPG
      if (i < newStabCPG.outputPattern.size()) {
        totalDrive += newStabCPG.outputPattern[i];
      };
      
      // Reflex contributions
      for (reflex in newReflexes.vals()) {
        for (target in reflex.targetMuscles.vals()) {
          if (target == i) {
            totalDrive += reflex.motorOutput;
          };
        };
      };
      
      Float.max(0.0, Float.min(1.0, totalDrive))
    });
    
    // 4. Update motor pools
    let newPools = Array.tabulate<MotorNeuronPool>(numMotors, func(i) {
      let drive = if (i < motorDrives.size()) { motorDrives[i] } else { 0.0 };
      updateMotorPool(spinal.motorNeuronPools[i], drive, dt)
    });
    
    {
      flightCPG = newFlightCPG;
      locomotionCPG = spinal.locomotionCPG;
      stabilizationCPG = newStabCPG;
      coolingCPG = spinal.coolingCPG;
      reflexArcs = newReflexes;
      motorNeuronPools = newPools;
      descendingCommand = spinal.descendingCommand;
      ascendingSensory = sensoryInput;
      interneuronActivity = spinal.interneuronActivity;
      gateControlState = spinal.gateControlState;
      beatNum = spinal.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 30: SOCIAL BRAIN — SWARM INTELLIGENCE CENTER
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The drone's social cognition for swarm behavior:
  //   • Theory of mind - Modeling other drones' intentions
  //   • Social hierarchy - Knowing one's place in the swarm
  //   • Coordination - Synchronizing with neighbors
  //   • Communication - Encoding/decoding messages
  //   • Collective decision - Contributing to group choices
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Social brain state
  public type SocialBrainState = {
    // Self-other distinction
    selfModel         : DroneModel;
    otherModels       : [DroneModel];
    
    // Social hierarchy
    hierarchyPosition : Float;        // 0 = follower, 1 = leader
    dominanceScores   : [(Nat, Float)];
    submissionScores  : [(Nat, Float)];
    
    // Theory of mind
    intentionModels   : [IntentionModel];
    beliefModels      : [BeliefModel];
    
    // Social attention
    attendedDrone     : ?Nat;
    socialSalience    : [Float];
    
    // Coordination
    synchronizationState : SynchronizationState;
    coordinationPartners : [Nat];
    
    // Communication
    messageEncoder    : MessageEncoder;
    messageDecoder    : MessageDecoder;
    
    // Collective decision
    collectiveDecisionState : CollectiveDecisionState;
    
    // Social emotions
    socialEmotions    : SocialEmotions;
    
    // Reputation tracking
    reputationScores  : [(Nat, Float)];
    trustScores       : [(Nat, Float)];
    
    beatNum           : Nat;
  };

  /// Model of a drone (self or other)
  public type DroneModel = {
    droneId           : Nat;
    
    // Physical state estimate
    estimatedPosition : { x: Float; y: Float; z: Float };
    estimatedVelocity : { vx: Float; vy: Float; vz: Float };
    estimatedHeading  : Float;
    
    // State uncertainty
    positionUncertainty : Float;
    
    // Behavioral state
    estimatedRole     : ?DroneRole;
    estimatedGoal     : ?Text;
    estimatedArousal  : Float;
    
    // Capabilities
    estimatedHealth   : Float;
    estimatedBattery  : Float;
    
    // Social state
    isCooperative     : Float;
    isThreat          : Float;
    
    // Last update
    lastUpdateBeat    : Nat;
  };

  /// Intention model (for theory of mind)
  public type IntentionModel = {
    droneId           : Nat;
    
    // Predicted intentions
    primaryIntention  : Text;
    intentionConfidence : Float;
    
    // Goal inference
    inferredGoal      : ?{ x: Float; y: Float; z: Float };
    goalProbability   : Float;
    
    // Action prediction
    predictedAction   : Text;
    actionProbability : Float;
    
    // Time horizon
    predictionHorizon : Nat;
  };

  /// Belief model (what we think others believe)
  public type BeliefModel = {
    droneId           : Nat;
    
    // What they believe about the world
    worldBeliefs      : [(Text, Float)];
    
    // What they believe about us
    beliefsAboutSelf  : [(Text, Float)];
    
    // Shared knowledge
    commonGround      : [Text];
    
    // Belief accuracy estimate
    beliefAccuracy    : Float;
  };

  /// Synchronization state
  public type SynchronizationState = {
    // Phase coupling
    myPhase           : Float;
    neighborPhases    : [(Nat, Float)];
    
    // Kuramoto order parameter
    orderParameter    : Float;
    meanPhase         : Float;
    
    // Coupling strength
    couplingStrength  : Float;
    
    // Synchronization error
    syncError         : Float;
    
    // Frequency adaptation
    frequencyOffset   : Float;
  };

  /// Message encoder
  public type MessageEncoder = {
    // Encoding templates
    templates         : [(Text, [Float])];
    
    // Current message being encoded
    currentMessage    : ?[Float];
    
    // Encoding state
    encodingPhase     : Float;
    
    // Output buffer
    outputBuffer      : [Float];
  };

  /// Message decoder
  public type MessageDecoder = {
    // Decoding templates
    templates         : [(Text, [Float])];
    
    // Input buffer
    inputBuffer       : [Float];
    
    // Decoded messages
    decodedMessages   : [(Text, Float, Nat)];  // (content, confidence, senderId)
    
    // Decoding state
    decodingPhase     : Float;
  };

  /// Collective decision state
  public type CollectiveDecisionState = {
    // Current decision topic
    currentTopic      : ?Text;
    
    // Options
    options           : [DecisionOption];
    
    // My vote
    myVote            : ?Nat;
    myConfidence      : Float;
    
    // Observed votes
    observedVotes     : [(Nat, Nat, Float)];  // (droneId, optionId, strength)
    
    // Quorum
    quorumReached     : Bool;
    quorumLevel       : Float;
    
    // Winning option
    winningOption     : ?Nat;
    consensusLevel    : Float;
  };

  /// Social emotions
  public type SocialEmotions = {
    // Affiliation
    belongingness     : Float;
    loneliness        : Float;
    
    // Social comparison
    envy              : Float;
    pride             : Float;
    
    // Empathy
    empathyLevel      : Float;
    emotionalContagion : Float;
    
    // Trust/distrust
    generalTrust      : Float;
    suspicion         : Float;
    
    // Group emotions
    groupPride        : Float;
    groupAnxiety      : Float;
  };

  /// Initialize social brain
  public func initSocialBrain(myId: Nat) : SocialBrainState {
    let selfModel : DroneModel = {
      droneId = myId;
      estimatedPosition = { x = 0.0; y = 0.0; z = 0.0 };
      estimatedVelocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
      estimatedHeading = 0.0;
      positionUncertainty = 0.0;
      estimatedRole = null;
      estimatedGoal = null;
      estimatedArousal = 0.5;
      estimatedHealth = 1.0;
      estimatedBattery = 1.0;
      isCooperative = 1.0;
      isThreat = 0.0;
      lastUpdateBeat = 0;
    };
    
    {
      selfModel = selfModel;
      otherModels = [];
      hierarchyPosition = 0.5;
      dominanceScores = [];
      submissionScores = [];
      intentionModels = [];
      beliefModels = [];
      attendedDrone = null;
      socialSalience = [];
      synchronizationState = {
        myPhase = 0.0;
        neighborPhases = [];
        orderParameter = 0.0;
        meanPhase = 0.0;
        couplingStrength = 0.1;
        syncError = 0.0;
        frequencyOffset = 0.0;
      };
      coordinationPartners = [];
      messageEncoder = {
        templates = [];
        currentMessage = null;
        encodingPhase = 0.0;
        outputBuffer = [];
      };
      messageDecoder = {
        templates = [];
        inputBuffer = [];
        decodedMessages = [];
        decodingPhase = 0.0;
      };
      collectiveDecisionState = {
        currentTopic = null;
        options = [];
        myVote = null;
        myConfidence = 0.0;
        observedVotes = [];
        quorumReached = false;
        quorumLevel = 0.0;
        winningOption = null;
        consensusLevel = 0.0;
      };
      socialEmotions = {
        belongingness = 0.5;
        loneliness = 0.0;
        envy = 0.0;
        pride = 0.0;
        empathyLevel = 0.5;
        emotionalContagion = 0.3;
        generalTrust = 0.5;
        suspicion = 0.0;
        groupPride = 0.0;
        groupAnxiety = 0.0;
      };
      reputationScores = [];
      trustScores = [];
      beatNum = 0;
    }
  };

  /// Update drone model (tracking another drone)
  public func updateDroneModel(
    model: DroneModel,
    observedPosition: { x: Float; y: Float; z: Float },
    observedVelocity: ?{ vx: Float; vy: Float; vz: Float },
    beat: Nat
  ) : DroneModel {
    // Kalman-like update
    let alpha = 0.3;  // Update rate
    
    let newPos = {
      x = model.estimatedPosition.x * (1.0 - alpha) + observedPosition.x * alpha;
      y = model.estimatedPosition.y * (1.0 - alpha) + observedPosition.y * alpha;
      z = model.estimatedPosition.z * (1.0 - alpha) + observedPosition.z * alpha;
    };
    
    let newVel = switch (observedVelocity) {
      case (?vel) {
        {
          vx = model.estimatedVelocity.vx * (1.0 - alpha) + vel.vx * alpha;
          vy = model.estimatedVelocity.vy * (1.0 - alpha) + vel.vy * alpha;
          vz = model.estimatedVelocity.vz * (1.0 - alpha) + vel.vz * alpha;
        }
      };
      case null {
        // Estimate from position change
        let dt = Float.fromInt(beat - model.lastUpdateBeat);
        if (dt > 0.0) {
          {
            vx = (newPos.x - model.estimatedPosition.x) / dt;
            vy = (newPos.y - model.estimatedPosition.y) / dt;
            vz = (newPos.z - model.estimatedPosition.z) / dt;
          }
        } else {
          model.estimatedVelocity
        }
      };
    };
    
    // Heading from velocity
    let newHeading = Float.arctan2(newVel.vy, newVel.vx);
    
    // Uncertainty decreases with observation
    let newUncertainty = model.positionUncertainty * 0.9;
    
    {
      droneId = model.droneId;
      estimatedPosition = newPos;
      estimatedVelocity = newVel;
      estimatedHeading = newHeading;
      positionUncertainty = newUncertainty;
      estimatedRole = model.estimatedRole;
      estimatedGoal = model.estimatedGoal;
      estimatedArousal = model.estimatedArousal;
      estimatedHealth = model.estimatedHealth;
      estimatedBattery = model.estimatedBattery;
      isCooperative = model.isCooperative;
      isThreat = model.isThreat;
      lastUpdateBeat = beat;
    }
  };

  /// Infer intention from behavior
  public func inferIntention(
    model: DroneModel,
    observationHistory: [{ pos: { x: Float; y: Float; z: Float }; beat: Nat }]
  ) : IntentionModel {
    // Simple intention inference from trajectory
    var intention = "unknown";
    var confidence : Float = 0.0;
    var inferredGoal : ?{ x: Float; y: Float; z: Float } = null;
    
    if (observationHistory.size() >= 3) {
      // Check if moving toward a point
      let recent = observationHistory[observationHistory.size() - 1];
      let mid = observationHistory[observationHistory.size() - 2];
      let old = observationHistory[observationHistory.size() - 3];
      
      let v1 = {
        x = mid.pos.x - old.pos.x;
        y = mid.pos.y - old.pos.y;
        z = mid.pos.z - old.pos.z;
      };
      
      let v2 = {
        x = recent.pos.x - mid.pos.x;
        y = recent.pos.y - mid.pos.y;
        z = recent.pos.z - mid.pos.z;
      };
      
      // Check consistency of direction
      let dot = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
      let mag1 = Float.sqrt(v1.x**2.0 + v1.y**2.0 + v1.z**2.0);
      let mag2 = Float.sqrt(v2.x**2.0 + v2.y**2.0 + v2.z**2.0);
      
      if (mag1 > 0.1 and mag2 > 0.1) {
        let consistency = dot / (mag1 * mag2);
        
        if (consistency > 0.9) {
          intention := "approach_target";
          confidence := consistency;
          // Extrapolate goal
          let scale = 10.0;
          inferredGoal := ?{
            x = recent.pos.x + v2.x * scale;
            y = recent.pos.y + v2.y * scale;
            z = recent.pos.z + v2.z * scale;
          };
        } else if (consistency < -0.5) {
          intention := "patrolling";
          confidence := Float.abs(consistency);
        } else if (mag2 < 0.1) {
          intention := "hovering";
          confidence := 0.8;
        };
      } else if (mag2 < 0.1) {
        intention := "stationary";
        confidence := 0.9;
      };
    };
    
    {
      droneId = model.droneId;
      primaryIntention = intention;
      intentionConfidence = confidence;
      inferredGoal = inferredGoal;
      goalProbability = confidence * 0.8;
      predictedAction = intention;
      actionProbability = confidence * 0.7;
      predictionHorizon = 10;
    }
  };

  /// Update synchronization (Kuramoto model)
  public func updateSynchronization(
    sync: SynchronizationState,
    neighborPhases: [(Nat, Float)],
    naturalFrequency: Float,
    dt: Float
  ) : SynchronizationState {
    // Kuramoto coupling
    var phaseIncrement = naturalFrequency * TWO_PI * dt;
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    
    for ((_, phase) in neighborPhases.vals()) {
      phaseIncrement += sync.couplingStrength * Float.sin(phase - sync.myPhase) * dt;
      sumSin += Float.sin(phase);
      sumCos += Float.cos(phase);
    };
    
    let newPhase = sync.myPhase + phaseIncrement;
    
    // Order parameter
    let n = Float.fromInt(neighborPhases.size() + 1);
    sumSin += Float.sin(newPhase);
    sumCos += Float.cos(newPhase);
    let orderParam = Float.sqrt(sumSin**2.0 + sumCos**2.0) / n;
    let meanPhase = Float.arctan2(sumSin / n, sumCos / n);
    
    // Sync error
    let syncError = Float.abs(Float.sin(newPhase - meanPhase));
    
    {
      myPhase = newPhase;
      neighborPhases = neighborPhases;
      orderParameter = orderParam;
      meanPhase = meanPhase;
      couplingStrength = sync.couplingStrength;
      syncError = syncError;
      frequencyOffset = sync.frequencyOffset;
    }
  };

  /// Update collective decision (quorum sensing)
  public func updateCollectiveDecision(
    decision: CollectiveDecisionState,
    myPreference: ?Nat,
    observedBehaviors: [(Nat, Nat)],
    quorumThreshold: Float
  ) : CollectiveDecisionState {
    // Count votes for each option
    var voteCounts : [Nat] = Array.tabulate<Nat>(decision.options.size(), func(_) { 0 });
    let voteCountsMut = Array.thaw<Nat>(voteCounts);
    
    for ((_, optionId) in observedBehaviors.vals()) {
      if (optionId < voteCounts.size()) {
        voteCountsMut[optionId] := voteCountsMut[optionId] + 1;
      };
    };
    voteCounts := Array.freeze(voteCountsMut);
    
    // Add my vote
    switch (myPreference) {
      case (?pref) {
        if (pref < voteCounts.size()) {
          let vcMut = Array.thaw<Nat>(voteCounts);
          vcMut[pref] := vcMut[pref] + 1;
          voteCounts := Array.freeze(vcMut);
        };
      };
      case null { };
    };
    
    // Find winning option
    var maxVotes : Nat = 0;
    var winner : ?Nat = null;
    var total : Nat = 0;
    
    for (i in Iter.range(0, voteCounts.size() - 1)) {
      let count = voteCounts[i];
      total += count;
      if (count > maxVotes) {
        maxVotes := count;
        winner := ?i;
      };
    };
    
    // Quorum
    let quorumLevel = if (total > 0) {
      Float.fromInt(maxVotes) / Float.fromInt(total)
    } else { 0.0 };
    let quorumReached = quorumLevel >= quorumThreshold;
    
    {
      currentTopic = decision.currentTopic;
      options = decision.options;
      myVote = myPreference;
      myConfidence = decision.myConfidence;
      observedVotes = Array.map<(Nat, Nat), (Nat, Nat, Float)>(observedBehaviors, func((d, o)) {
        (d, o, 1.0)
      });
      quorumReached = quorumReached;
      quorumLevel = quorumLevel;
      winningOption = if (quorumReached) { winner } else { null };
      consensusLevel = quorumLevel;
    }
  };

  /// Full social brain tick
  public func tickSocialBrain(
    social: SocialBrainState,
    observedDrones: [{ id: Nat; pos: { x: Float; y: Float; z: Float }; vel: ?{ vx: Float; vy: Float; vz: Float } }],
    receivedMessages: [Float],
    myPosition: { x: Float; y: Float; z: Float },
    dt: Float
  ) : SocialBrainState {
    // 1. Update self model
    let newSelfModel : DroneModel = {
      droneId = social.selfModel.droneId;
      estimatedPosition = myPosition;
      estimatedVelocity = social.selfModel.estimatedVelocity;
      estimatedHeading = social.selfModel.estimatedHeading;
      positionUncertainty = 0.0;
      estimatedRole = social.selfModel.estimatedRole;
      estimatedGoal = social.selfModel.estimatedGoal;
      estimatedArousal = social.selfModel.estimatedArousal;
      estimatedHealth = social.selfModel.estimatedHealth;
      estimatedBattery = social.selfModel.estimatedBattery;
      isCooperative = 1.0;
      isThreat = 0.0;
      lastUpdateBeat = social.beatNum;
    };
    
    // 2. Update other models
    var newOtherModels : [DroneModel] = [];
    for (obs in observedDrones.vals()) {
      // Find or create model
      var found = false;
      for (model in social.otherModels.vals()) {
        if (model.droneId == obs.id) {
          found := true;
          let updated = updateDroneModel(model, obs.pos, obs.vel, social.beatNum);
          newOtherModels := Array.append(newOtherModels, [updated]);
        };
      };
      
      if (not found) {
        // Create new model
        let newModel : DroneModel = {
          droneId = obs.id;
          estimatedPosition = obs.pos;
          estimatedVelocity = switch (obs.vel) {
            case (?v) { v };
            case null { { vx = 0.0; vy = 0.0; vz = 0.0 } };
          };
          estimatedHeading = 0.0;
          positionUncertainty = 1.0;
          estimatedRole = null;
          estimatedGoal = null;
          estimatedArousal = 0.5;
          estimatedHealth = 1.0;
          estimatedBattery = 1.0;
          isCooperative = 0.5;
          isThreat = 0.0;
          lastUpdateBeat = social.beatNum;
        };
        newOtherModels := Array.append(newOtherModels, [newModel]);
      };
    };
    
    // 3. Update synchronization
    let neighborPhases = Array.map<DroneModel, (Nat, Float)>(newOtherModels, func(m) {
      // Estimate phase from heading
      (m.droneId, m.estimatedHeading)
    });
    let newSync = updateSynchronization(social.synchronizationState, neighborPhases, 1.0, dt);
    
    // 4. Update social emotions
    let numNeighbors = Float.fromInt(newOtherModels.size());
    let newBelongingness = if (numNeighbors > 0) {
      Float.min(numNeighbors / 5.0, 1.0) * newSync.orderParameter
    } else { 0.0 };
    let newLoneliness = if (numNeighbors == 0.0) { 0.5 } else { 0.0 };
    
    let newSocialEmotions : SocialEmotions = {
      belongingness = newBelongingness;
      loneliness = newLoneliness;
      envy = social.socialEmotions.envy * 0.95;
      pride = social.socialEmotions.pride * 0.95;
      empathyLevel = social.socialEmotions.empathyLevel;
      emotionalContagion = social.socialEmotions.emotionalContagion;
      generalTrust = social.socialEmotions.generalTrust * 0.99 + 0.01 * newSync.orderParameter;
      suspicion = social.socialEmotions.suspicion * 0.95;
      groupPride = newSync.orderParameter * 0.5;
      groupAnxiety = (1.0 - newSync.orderParameter) * 0.3;
    };
    
    // 5. Update hierarchy position based on relative position
    var avgX : Float = 0.0;
    var avgY : Float = 0.0;
    for (m in newOtherModels.vals()) {
      avgX += m.estimatedPosition.x;
      avgY += m.estimatedPosition.y;
    };
    if (newOtherModels.size() > 0) {
      avgX := avgX / Float.fromInt(newOtherModels.size());
      avgY := avgY / Float.fromInt(newOtherModels.size());
    };
    
    // Leader tends to be at front
    let relativePos = myPosition.y - avgY;  // Assuming Y is forward
    let newHierarchyPos = 0.5 + relativePos * 0.1;
    
    {
      selfModel = newSelfModel;
      otherModels = newOtherModels;
      hierarchyPosition = Float.max(0.0, Float.min(1.0, newHierarchyPos));
      dominanceScores = social.dominanceScores;
      submissionScores = social.submissionScores;
      intentionModels = social.intentionModels;
      beliefModels = social.beliefModels;
      attendedDrone = social.attendedDrone;
      socialSalience = social.socialSalience;
      synchronizationState = newSync;
      coordinationPartners = Array.map<DroneModel, Nat>(newOtherModels, func(m) { m.droneId });
      messageEncoder = social.messageEncoder;
      messageDecoder = social.messageDecoder;
      collectiveDecisionState = social.collectiveDecisionState;
      socialEmotions = newSocialEmotions;
      reputationScores = social.reputationScores;
      trustScores = social.trustScores;
      beatNum = social.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 31: LEARNING SYSTEMS — ADAPTATION AND SKILL ACQUISITION
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The drone's learning capabilities:
  //   • Classical conditioning - Associative learning
  //   • Operant conditioning - Reward-based learning
  //   • Observational learning - Learning from others
  //   • Skill learning - Motor skill acquisition
  //   • Cognitive map learning - Spatial learning
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Learning system state
  public type LearningSystemState = {
    // Classical conditioning
    classicalConditioning : ClassicalConditioningState;
    
    // Operant conditioning
    operantConditioning : OperantConditioningState;
    
    // Observational learning
    observationalLearning : ObservationalLearningState;
    
    // Skill learning
    skillLearning      : SkillLearningState;
    
    // Cognitive map
    cognitiveMapLearning : CognitiveMapLearningState;
    
    // Meta-learning
    metaLearning       : MetaLearningState;
    
    // Learning rate modulation
    globalLearningRate : Float;
    curiosityDrive     : Float;
    
    beatNum            : Nat;
  };

  /// Classical conditioning state
  public type ClassicalConditioningState = {
    // Associations
    associations       : [ClassicalAssociation];
    
    // Unconditioned stimuli
    unconditionedStimuli : [UnconditionedStimulus];
    
    // Conditioned stimuli being tracked
    trackedStimuli     : [TrackedStimulus];
    
    // Extinction tracking
    extinctionProgress : [(Nat, Float)];
  };

  /// Classical association
  public type ClassicalAssociation = {
    associationId      : Nat;
    
    // CS-US pairing
    conditionedStimulus : [Float];
    unconditionedStimulus : Nat;
    
    // Association strength
    associationStrength : Float;
    
    // Timing
    optimalISI         : Float;     // Inter-stimulus interval
    
    // Response
    conditionedResponse : [Float];
    
    // Learning
    acquisitionTrial   : Nat;
    lastReinforcementBeat : Nat;
  };

  /// Unconditioned stimulus
  public type UnconditionedStimulus = {
    stimulusId         : Nat;
    stimulusType       : Text;      // "reward", "punishment", "threat"
    intensity          : Float;
    responsePattern    : [Float];
  };

  /// Tracked stimulus
  public type TrackedStimulus = {
    stimulusPattern    : [Float];
    occurrenceCount    : Nat;
    lastOccurrence     : Nat;
    coOccurrenceWith   : [(Nat, Nat)];  // (stimulusId, count)
  };

  /// Operant conditioning state
  public type OperantConditioningState = {
    // Action-outcome associations
    actionOutcomes     : [ActionOutcome];
    
    // Reward prediction
    rewardPredictions  : [(Text, Float)];
    
    // Value function
    stateValues        : [(Nat, Float)];  // (stateId, value)
    
    // Policy
    actionPreferences  : [(Text, Float)];
    
    // Exploration
    explorationRate    : Float;
    
    // Temporal difference
    tdError            : Float;
    eligibilityTraces  : [(Nat, Float)];
  };

  /// Action-outcome association
  public type ActionOutcome = {
    actionId           : Nat;
    actionType         : Text;
    contextState       : [Float];
    
    // Outcomes experienced
    positiveOutcomes   : Nat;
    negativeOutcomes   : Nat;
    neutralOutcomes    : Nat;
    
    // Expected value
    expectedValue      : Float;
    valueVariance      : Float;
    
    // Timing
    lastPerformed      : Nat;
    performanceCount   : Nat;
  };

  /// Observational learning state
  public type ObservationalLearningState = {
    // Observed behaviors
    observedBehaviors  : [ObservedBehavior];
    
    // Model drones (to imitate)
    modelDrones        : [Nat];
    
    // Imitation queue
    imitationQueue     : [Nat];     // Behavior IDs to imitate
    
    // Social learning bias
    prestigeBias       : Float;
    similarityBias     : Float;
    successBias        : Float;
  };

  /// Observed behavior
  public type ObservedBehavior = {
    behaviorId         : Nat;
    performerId        : Nat;
    
    // What was done
    actionSequence     : [Text];
    
    // Context
    context            : [Float];
    
    // Outcome
    observedOutcome    : Float;
    
    // My ability to perform
    imitationFeasibility : Float;
    
    // Times observed
    observationCount   : Nat;
    lastObserved       : Nat;
  };

  /// Skill learning state
  public type SkillLearningState = {
    // Skills being learned
    learningSkills     : [LearningSkill];
    
    // Motor primitives library
    motorPrimitives    : [MotorPrimitive];
    
    // Skill transfer
    transferMatrix     : [[Float]];
    
    // Practice schedule
    practiceSchedule   : [(Nat, Nat)];  // (skillId, nextPracticeBeat)
  };

  /// Learning skill
  public type LearningSkill = {
    skillId            : Nat;
    skillName          : Text;
    
    // Learning stage
    learningStage      : SkillLearningStage;
    
    // Performance metrics
    currentPerformance : Float;
    targetPerformance  : Float;
    
    // Error tracking
    recentErrors       : [Float];
    meanError          : Float;
    
    // Practice
    totalPracticeTime  : Nat;
    distributedPractice : Bool;
    lastPractice       : Nat;
    
    // Retention
    retentionInterval  : Nat;
    forgettingRate     : Float;
  };

  /// Skill learning stages
  public type SkillLearningStage = {
    #Cognitive;        // Understanding the skill
    #Associative;      // Refining the skill
    #Autonomous;       // Automatized
  };

  /// Cognitive map learning state
  public type CognitiveMapLearningState = {
    // Spatial nodes
    spatialNodes       : [SpatialNode];
    
    // Edges (connections)
    spatialEdges       : [(Nat, Nat, Float)];  // (from, to, distance)
    
    // Landmarks
    landmarks          : [Landmark];
    
    // Path integration
    pathIntegrationError : Float;
    
    // Exploration state
    exploredArea       : [[Bool]];
    frontierNodes      : [Nat];
  };

  /// Spatial node
  public type SpatialNode = {
    nodeId             : Nat;
    position           : { x: Float; y: Float; z: Float };
    
    // Properties
    isLandmark         : Bool;
    visitCount         : Nat;
    lastVisit          : Nat;
    
    // Associations
    associatedEvents   : [Nat];
    rewardValue        : Float;
    dangerValue        : Float;
  };

  /// Meta-learning state
  public type MetaLearningState = {
    // Learning-to-learn
    learningEfficiency : Float;
    
    // Task similarity
    taskRepresentations : [[Float]];
    
    // Hyperparameters
    adaptiveLearningRate : Float;
    adaptiveExploration : Float;
    
    // Performance history
    taskPerformanceHistory : [(Text, Float)];
  };

  /// Initialize learning system
  public func initLearningSystem() : LearningSystemState {
    {
      classicalConditioning = {
        associations = [];
        unconditionedStimuli = [
          { stimulusId = 0; stimulusType = "reward"; intensity = 1.0; responsePattern = [1.0, 0.0, 0.0] },
          { stimulusId = 1; stimulusType = "threat"; intensity = 1.0; responsePattern = [0.0, 1.0, 0.0] },
          { stimulusId = 2; stimulusType = "pain"; intensity = 1.0; responsePattern = [0.0, 0.0, 1.0] }
        ];
        trackedStimuli = [];
        extinctionProgress = [];
      };
      operantConditioning = {
        actionOutcomes = [];
        rewardPredictions = [];
        stateValues = [];
        actionPreferences = [];
        explorationRate = 0.3;
        tdError = 0.0;
        eligibilityTraces = [];
      };
      observationalLearning = {
        observedBehaviors = [];
        modelDrones = [];
        imitationQueue = [];
        prestigeBias = 0.3;
        similarityBias = 0.3;
        successBias = 0.4;
      };
      skillLearning = {
        learningSkills = [];
        motorPrimitives = [];
        transferMatrix = [[]];
        practiceSchedule = [];
      };
      cognitiveMapLearning = {
        spatialNodes = [];
        spatialEdges = [];
        landmarks = [];
        pathIntegrationError = 0.0;
        exploredArea = [[]];
        frontierNodes = [];
      };
      metaLearning = {
        learningEfficiency = 0.5;
        taskRepresentations = [[]];
        adaptiveLearningRate = 0.1;
        adaptiveExploration = 0.2;
        taskPerformanceHistory = [];
      };
      globalLearningRate = 0.1;
      curiosityDrive = 0.3;
      beatNum = 0;
    }
  };

  /// Classical conditioning update (Rescorla-Wagner)
  public func updateClassicalConditioning(
    cc: ClassicalConditioningState,
    currentStimuli: [[Float]],
    usPresent: ?Nat,
    learningRate: Float,
    beat: Nat
  ) : ClassicalConditioningState {
    var newAssociations = cc.associations;
    
    switch (usPresent) {
      case (?usId) {
        // US is present - strengthen associations with current CS
        for (cs in currentStimuli.vals()) {
          // Check if association exists
          var found = false;
          newAssociations := Array.map<ClassicalAssociation, ClassicalAssociation>(
            newAssociations,
            func(assoc) {
              // Simple similarity check
              var similarity : Float = 0.0;
              let minLen = Int.min(assoc.conditionedStimulus.size(), cs.size());
              for (i in Iter.range(0, minLen - 1)) {
                similarity += assoc.conditionedStimulus[i] * cs[i];
              };
              
              if (similarity > 0.8 and assoc.unconditionedStimulus == usId) {
                found := true;
                // Rescorla-Wagner: ΔV = α(λ - V)
                let lambda = 1.0;  // Max associability
                let deltaV = learningRate * (lambda - assoc.associationStrength);
                {
                  associationId = assoc.associationId;
                  conditionedStimulus = assoc.conditionedStimulus;
                  unconditionedStimulus = assoc.unconditionedStimulus;
                  associationStrength = Float.min(1.0, assoc.associationStrength + deltaV);
                  optimalISI = assoc.optimalISI;
                  conditionedResponse = assoc.conditionedResponse;
                  acquisitionTrial = assoc.acquisitionTrial;
                  lastReinforcementBeat = beat;
                }
              } else { assoc }
            }
          );
          
          // Create new association if not found
          if (not found) {
            let newAssoc : ClassicalAssociation = {
              associationId = newAssociations.size();
              conditionedStimulus = cs;
              unconditionedStimulus = usId;
              associationStrength = learningRate;
              optimalISI = 0.5;
              conditionedResponse = if (usId < cc.unconditionedStimuli.size()) {
                cc.unconditionedStimuli[usId].responsePattern
              } else { [0.0] };
              acquisitionTrial = beat;
              lastReinforcementBeat = beat;
            };
            newAssociations := Array.append(newAssociations, [newAssoc]);
          };
        };
      };
      case null {
        // No US - extinction
        newAssociations := Array.map<ClassicalAssociation, ClassicalAssociation>(
          newAssociations,
          func(assoc) {
            // Check if CS is present without US
            var csPresent = false;
            for (cs in currentStimuli.vals()) {
              var similarity : Float = 0.0;
              let minLen = Int.min(assoc.conditionedStimulus.size(), cs.size());
              for (i in Iter.range(0, minLen - 1)) {
                similarity += assoc.conditionedStimulus[i] * cs[i];
              };
              if (similarity > 0.8) { csPresent := true };
            };
            
            if (csPresent) {
              // Extinction
              {
                associationId = assoc.associationId;
                conditionedStimulus = assoc.conditionedStimulus;
                unconditionedStimulus = assoc.unconditionedStimulus;
                associationStrength = Float.max(0.0, assoc.associationStrength - learningRate * 0.1);
                optimalISI = assoc.optimalISI;
                conditionedResponse = assoc.conditionedResponse;
                acquisitionTrial = assoc.acquisitionTrial;
                lastReinforcementBeat = assoc.lastReinforcementBeat;
              }
            } else { assoc }
          }
        );
      };
    };
    
    {
      associations = newAssociations;
      unconditionedStimuli = cc.unconditionedStimuli;
      trackedStimuli = cc.trackedStimuli;
      extinctionProgress = cc.extinctionProgress;
    }
  };

  /// Operant conditioning update (TD learning)
  public func updateOperantConditioning(
    oc: OperantConditioningState,
    currentState: Nat,
    actionTaken: Text,
    reward: Float,
    nextState: Nat,
    gamma: Float,
    learningRate: Float
  ) : OperantConditioningState {
    // Get current and next state values
    var currentValue : Float = 0.0;
    var nextValue : Float = 0.0;
    
    for ((s, v) in oc.stateValues.vals()) {
      if (s == currentState) { currentValue := v };
      if (s == nextState) { nextValue := v };
    };
    
    // TD error
    let tdError = reward + gamma * nextValue - currentValue;
    
    // Update state value
    var newStateValues : [(Nat, Float)] = [];
    var foundCurrent = false;
    for ((s, v) in oc.stateValues.vals()) {
      if (s == currentState) {
        foundCurrent := true;
        newStateValues := Array.append(newStateValues, [(s, v + learningRate * tdError)]);
      } else {
        newStateValues := Array.append(newStateValues, [(s, v)]);
      };
    };
    if (not foundCurrent) {
      newStateValues := Array.append(newStateValues, [(currentState, learningRate * tdError)]);
    };
    
    // Update action preferences
    var newActionPrefs : [(Text, Float)] = [];
    var foundAction = false;
    for ((a, p) in oc.actionPreferences.vals()) {
      if (a == actionTaken) {
        foundAction := true;
        let newPref = p + learningRate * tdError;
        newActionPrefs := Array.append(newActionPrefs, [(a, newPref)]);
      } else {
        newActionPrefs := Array.append(newActionPrefs, [(a, p)]);
      };
    };
    if (not foundAction) {
      newActionPrefs := Array.append(newActionPrefs, [(actionTaken, learningRate * tdError)]);
    };
    
    // Update action-outcome association
    var newActionOutcomes = oc.actionOutcomes;
    var foundOutcome = false;
    newActionOutcomes := Array.map<ActionOutcome, ActionOutcome>(
      oc.actionOutcomes,
      func(ao) {
        if (ao.actionType == actionTaken) {
          foundOutcome := true;
          {
            actionId = ao.actionId;
            actionType = ao.actionType;
            contextState = ao.contextState;
            positiveOutcomes = if (reward > 0.0) { ao.positiveOutcomes + 1 } else { ao.positiveOutcomes };
            negativeOutcomes = if (reward < 0.0) { ao.negativeOutcomes + 1 } else { ao.negativeOutcomes };
            neutralOutcomes = if (reward == 0.0) { ao.neutralOutcomes + 1 } else { ao.neutralOutcomes };
            expectedValue = ao.expectedValue * 0.9 + reward * 0.1;
            valueVariance = ao.valueVariance;
            lastPerformed = 0;  // Would use beat
            performanceCount = ao.performanceCount + 1;
          }
        } else { ao }
      }
    );
    
    {
      actionOutcomes = newActionOutcomes;
      rewardPredictions = oc.rewardPredictions;
      stateValues = newStateValues;
      actionPreferences = newActionPrefs;
      explorationRate = oc.explorationRate;
      tdError = tdError;
      eligibilityTraces = oc.eligibilityTraces;
    }
  };

  /// Add spatial node to cognitive map
  public func addSpatialNode(
    cogMap: CognitiveMapLearningState,
    position: { x: Float; y: Float; z: Float },
    isLandmark: Bool,
    beat: Nat
  ) : CognitiveMapLearningState {
    // Check if node already exists nearby
    var nearbyNode : ?Nat = null;
    for (node in cogMap.spatialNodes.vals()) {
      let dist = Float.sqrt(
        (node.position.x - position.x) ** 2.0 +
        (node.position.y - position.y) ** 2.0 +
        (node.position.z - position.z) ** 2.0
      );
      if (dist < 1.0) {
        nearbyNode := ?node.nodeId;
      };
    };
    
    switch (nearbyNode) {
      case (?nodeId) {
        // Update existing node
        let newNodes = Array.map<SpatialNode, SpatialNode>(
          cogMap.spatialNodes,
          func(node) {
            if (node.nodeId == nodeId) {
              {
                nodeId = node.nodeId;
                position = {
                  x = node.position.x * 0.9 + position.x * 0.1;
                  y = node.position.y * 0.9 + position.y * 0.1;
                  z = node.position.z * 0.9 + position.z * 0.1;
                };
                isLandmark = node.isLandmark or isLandmark;
                visitCount = node.visitCount + 1;
                lastVisit = beat;
                associatedEvents = node.associatedEvents;
                rewardValue = node.rewardValue;
                dangerValue = node.dangerValue;
              }
            } else { node }
          }
        );
        {
          spatialNodes = newNodes;
          spatialEdges = cogMap.spatialEdges;
          landmarks = cogMap.landmarks;
          pathIntegrationError = cogMap.pathIntegrationError;
          exploredArea = cogMap.exploredArea;
          frontierNodes = cogMap.frontierNodes;
        }
      };
      case null {
        // Create new node
        let newNode : SpatialNode = {
          nodeId = cogMap.spatialNodes.size();
          position = position;
          isLandmark = isLandmark;
          visitCount = 1;
          lastVisit = beat;
          associatedEvents = [];
          rewardValue = 0.0;
          dangerValue = 0.0;
        };
        
        // Add edges to nearby nodes
        var newEdges = cogMap.spatialEdges;
        for (node in cogMap.spatialNodes.vals()) {
          let dist = Float.sqrt(
            (node.position.x - position.x) ** 2.0 +
            (node.position.y - position.y) ** 2.0 +
            (node.position.z - position.z) ** 2.0
          );
          if (dist < 10.0) {
            newEdges := Array.append(newEdges, [(newNode.nodeId, node.nodeId, dist)]);
            newEdges := Array.append(newEdges, [(node.nodeId, newNode.nodeId, dist)]);
          };
        };
        
        {
          spatialNodes = Array.append(cogMap.spatialNodes, [newNode]);
          spatialEdges = newEdges;
          landmarks = if (isLandmark) {
            Array.append(cogMap.landmarks, [{
              landmarkId = newNode.nodeId;
              position = position;
              visualSignature = [];
              reliability = 1.0;
              lastSeen = beat;
            }])
          } else { cogMap.landmarks };
          pathIntegrationError = cogMap.pathIntegrationError;
          exploredArea = cogMap.exploredArea;
          frontierNodes = Array.append(cogMap.frontierNodes, [newNode.nodeId]);
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 32: ULTIMATE DRONE INTEGRATION — THE COMPLETE AVATAR
  // ═══════════════════════════════════════════════════════════════════════════════

  /// The ultimate complete drone with ALL systems
  public type UltimateDroneAvatar = {
    // Identity
    droneId            : Nat;
    squadronId         : Nat;
    birthBeat          : Nat;
    
    // Full brain
    fullBrain          : FullDroneBrain;
    
    // Spinal cord
    spinalCord         : SpinalCordState;
    
    // Social brain
    socialBrain        : SocialBrainState;
    
    // Learning systems
    learningSystems    : LearningSystemState;
    
    // Body
    distributedBody    : DistributedBodyNetwork;
    
    // Role
    role               : RoleState;
    
    // Communication
    communication      : DroneCommState;
    
    // Physical state
    physicalState      : BodyStateEstimate;
    
    // Hardware
    hardware           : HardwareInterfaceState;
    
    // Mission
    mission            : ?MissionState;
    
    // Life
    isAlive            : Bool;
    lifecycleStage     : LifecycleStage;
    overallHealth      : Float;
    
    beatNum            : Nat;
  };

  /// Initialize ultimate drone
  public func initUltimateDrone(
    droneId: Nat,
    squadronId: Nat,
    position: { lat: Float; lon: Float; alt: Float },
    colonyNeeds: [(DroneRole, Float)],
    beat: Nat
  ) : UltimateDroneAvatar {
    {
      droneId = droneId;
      squadronId = squadronId;
      birthBeat = beat;
      fullBrain = initFullDroneBrain(droneId);
      spinalCord = initSpinalCord(4);
      socialBrain = initSocialBrain(droneId);
      learningSystems = initLearningSystem();
      distributedBody = initDistributedBody(4);
      role = determineInitialRole(droneId, colonyNeeds, null);
      communication = {
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
      physicalState = {
        position = position;
        velocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
        acceleration = { ax = 0.0; ay = 0.0; az = 0.0 };
        orientation = { roll = 0.0; pitch = 0.0; yaw = 0.0 };
        angularVelocity = { p = 0.0; q = 0.0; r = 0.0 };
        positionUncertainty = 1.0;
        orientationUncertainty = 0.05;
      };
      hardware = {
        isConnected = true;
        connectionType = "mavlink";
        lastHeartbeat = beat;
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
      mission = null;
      isAlive = true;
      lifecycleStage = #Initializing;
      overallHealth = 1.0;
      beatNum = beat;
    }
  };

  /// ULTIMATE TICK — Run everything
  public func tickUltimateDrone(
    drone: UltimateDroneAvatar,
    visualInput: [[Float]],
    audioInput: { left: [Float]; right: [Float] },
    observedDrones: [{ id: Nat; pos: { x: Float; y: Float; z: Float }; vel: ?{ vx: Float; vy: Float; vz: Float } }],
    receivedMessages: [SwarmMessage],
    externalThreats: [{ x: Float; y: Float; z: Float; level: Float }],
    batteryLevel: Float,
    ambientTemp: Float,
    signalStrength: Float,
    dt: Float
  ) : UltimateDroneAvatar {
    // 1. Tick full brain
    let motorSpeeds = Array.map<MotorNeuronPool, Float>(
      drone.spinalCord.motorNeuronPools,
      func(pool) { pool.muscleActivation }
    );
    let motorCurrents = motorSpeeds;
    
    let newFullBrain = tickFullDroneBrain(
      drone.fullBrain,
      visualInput,
      audioInput,
      motorSpeeds,
      motorCurrents,
      batteryLevel,
      ambientTemp,
      signalStrength,
      dt
    );
    
    // 2. Tick spinal cord
    let descendingDrive = Array.tabulate<Float>(4, func(i) {
      if (i < newFullBrain.coreBrain.motorCortex.currentCommand.motorSpeeds.size()) {
        newFullBrain.coreBrain.motorCortex.currentCommand.motorSpeeds[i]
      } else { 0.0 }
    });
    
    let vestibularInput = drone.physicalState.orientation;
    let collisionThreat = if (externalThreats.size() > 0) {
      externalThreats[0].level
    } else { 0.0 };
    
    let newSpinalCord = tickSpinalCord(
      drone.spinalCord,
      descendingDrive,
      [],
      vestibularInput,
      newFullBrain.somatosensory.thermalMap[0],
      collisionThreat,
      dt
    );
    
    // 3. Tick social brain
    let myPosition = {
      x = drone.physicalState.position.lon * 111000.0;
      y = drone.physicalState.position.lat * 111000.0;
      z = drone.physicalState.position.alt;
    };
    let newSocialBrain = tickSocialBrain(
      drone.socialBrain,
      observedDrones,
      [],
      myPosition,
      dt
    );
    
    // 4. Update learning systems
    // Add current position to cognitive map
    let newCogMap = addSpatialNode(
      drone.learningSystems.cognitiveMapLearning,
      myPosition,
      false,
      drone.beatNum
    );
    
    let newLearningSystems : LearningSystemState = {
      classicalConditioning = drone.learningSystems.classicalConditioning;
      operantConditioning = drone.learningSystems.operantConditioning;
      observationalLearning = drone.learningSystems.observationalLearning;
      skillLearning = drone.learningSystems.skillLearning;
      cognitiveMapLearning = newCogMap;
      metaLearning = drone.learningSystems.metaLearning;
      globalLearningRate = drone.learningSystems.globalLearningRate;
      curiosityDrive = drone.learningSystems.curiosityDrive;
      beatNum = drone.learningSystems.beatNum + 1;
    };
    
    // 5. Compute motor output from spinal cord
    let finalMotorOutput = Array.map<MotorNeuronPool, Float>(
      newSpinalCord.motorNeuronPools,
      func(pool) { pool.muscleActivation }
    );
    
    // 6. Update physical state (simplified physics)
    let newVelocity = {
      vx = drone.physicalState.velocity.vx + drone.physicalState.acceleration.ax * dt;
      vy = drone.physicalState.velocity.vy + drone.physicalState.acceleration.ay * dt;
      vz = drone.physicalState.velocity.vz + drone.physicalState.acceleration.az * dt;
    };
    
    let newPosition = {
      lat = drone.physicalState.position.lat + newVelocity.vy / 111000.0 * dt;
      lon = drone.physicalState.position.lon + newVelocity.vx / 111000.0 * dt;
      alt = drone.physicalState.position.alt + newVelocity.vz * dt;
    };
    
    // 7. Compute overall health
    let brainHealth = newFullBrain.integrationLevel;
    let bodyHealth = drone.distributedBody.overallHealth;
    let newHealth = (brainHealth + bodyHealth) / 2.0;
    
    // 8. Update lifecycle
    let newLifecycle : LifecycleStage = if (batteryLevel < 0.1) {
      #Emergency
    } else if (drone.beatNum - drone.birthBeat < 100) {
      #Calibrating
    } else {
      #Active
    };
    
    {
      droneId = drone.droneId;
      squadronId = drone.squadronId;
      birthBeat = drone.birthBeat;
      fullBrain = newFullBrain;
      spinalCord = newSpinalCord;
      socialBrain = newSocialBrain;
      learningSystems = newLearningSystems;
      distributedBody = drone.distributedBody;
      role = drone.role;
      communication = drone.communication;
      physicalState = {
        position = newPosition;
        velocity = newVelocity;
        acceleration = drone.physicalState.acceleration;
        orientation = drone.physicalState.orientation;
        angularVelocity = drone.physicalState.angularVelocity;
        positionUncertainty = drone.physicalState.positionUncertainty;
        orientationUncertainty = drone.physicalState.orientationUncertainty;
      };
      hardware = drone.hardware;
      mission = drone.mission;
      isAlive = batteryLevel > 0.05 and newHealth > 0.1;
      lifecycleStage = newLifecycle;
      overallHealth = newHealth;
      beatNum = drone.beatNum + 1;
    }
  };

  /// Generate ultimate drone output
  public type UltimateDroneOutput = {
    droneId           : Nat;
    beatNum           : Nat;
    isAlive           : Bool;
    
    // Position
    position          : { lat: Float; lon: Float; alt: Float };
    velocity          : { vx: Float; vy: Float; vz: Float };
    
    // Brain summary
    consciousness     : Float;
    arousal           : Float;
    
    // Social
    hierarchyPosition : Float;
    synchronization   : Float;
    belongingness     : Float;
    
    // Learning
    cognitiveMapSize  : Nat;
    learningRate      : Float;
    
    // Health
    overallHealth     : Float;
    autonomicBalance  : Float;
    
    // Motor
    motorOutputs      : [Float];
  };

  public func generateUltimateOutput(drone: UltimateDroneAvatar) : UltimateDroneOutput {
    {
      droneId = drone.droneId;
      beatNum = drone.beatNum;
      isAlive = drone.isAlive;
      position = drone.physicalState.position;
      velocity = drone.physicalState.velocity;
      consciousness = drone.fullBrain.integrationLevel;
      arousal = drone.fullBrain.autonomicNS.sympathetic.activationLevel;
      hierarchyPosition = drone.socialBrain.hierarchyPosition;
      synchronization = drone.socialBrain.synchronizationState.orderParameter;
      belongingness = drone.socialBrain.socialEmotions.belongingness;
      cognitiveMapSize = drone.learningSystems.cognitiveMapLearning.spatialNodes.size();
      learningRate = drone.learningSystems.globalLearningRate;
      overallHealth = drone.overallHealth;
      autonomicBalance = drone.fullBrain.autonomicNS.autonomicBalance;
      motorOutputs = Array.map<MotorNeuronPool, Float>(
        drone.spinalCord.motorNeuronPools,
        func(pool) { pool.muscleActivation }
      );
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 33: EXECUTIVE FUNCTIONS — COGNITIVE CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // High-level cognitive control processes:
  //   • Planning and goal management
  //   • Response inhibition
  //   • Task switching
  //   • Error monitoring
  //   • Metacognition
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Executive function state
  public type ExecutiveFunctionState = {
    // Goal management
    goalHierarchy     : GoalHierarchy;
    
    // Inhibition
    inhibitoryControl : InhibitoryControlState;
    
    // Task management
    taskSwitching     : TaskSwitchingState;
    
    // Monitoring
    errorMonitoring   : ErrorMonitoringState;
    
    // Metacognition
    metacognition     : MetacognitionState;
    
    // Planning
    planning          : PlanningState;
    
    // Attention
    executiveAttention : ExecutiveAttentionState;
    
    beatNum           : Nat;
  };

  /// Goal hierarchy
  public type GoalHierarchy = {
    // Superordinate goals (life goals)
    superordinateGoals : [SuperordinateGoal];
    
    // Current goals
    currentGoals      : [CurrentGoal];
    
    // Subgoals
    subgoals          : [Subgoal];
    
    // Goal stack
    activeGoalStack   : [Nat];
    
    // Goal conflicts
    goalConflicts     : [(Nat, Nat, Float)];  // (goal1, goal2, conflict_level)
    
    // Goal progress
    goalProgress      : [(Nat, Float)];
  };

  /// Superordinate goal
  public type SuperordinateGoal = {
    goalId            : Nat;
    goalType          : Text;
    importance        : Float;
    timeHorizon       : Nat;
    satisfactionLevel : Float;
  };

  /// Current goal
  public type CurrentGoal = {
    goalId            : Nat;
    goalDescription   : Text;
    targetState       : [Float];
    currentProgress   : Float;
    deadline          : ?Nat;
    priority          : Float;
    parentGoal        : ?Nat;
    subgoals          : [Nat];
  };

  /// Subgoal
  public type Subgoal = {
    subgoalId         : Nat;
    parentGoalId      : Nat;
    description       : Text;
    isComplete        : Bool;
    prerequisitesmet  : Bool;
    estimatedEffort   : Float;
  };

  /// Inhibitory control state
  public type InhibitoryControlState = {
    // Response inhibition
    responseThreshold : Float;
    inhibitionStrength : Float;
    
    // Go/No-Go state
    goSignal          : Float;
    noGoSignal        : Float;
    
    // Prepotent responses
    prepotentResponses : [PrepotentResponse];
    
    // Stop signal
    stopSignalReactionTime : Float;
    stopSuccessRate   : Float;
    
    // Interference control
    interferenceLevel : Float;
  };

  /// Prepotent response
  public type PrepotentResponse = {
    responseId        : Nat;
    stimulus          : [Float];
    automaticResponse : [Float];
    inhibitionRequired : Float;
    currentActivation : Float;
  };

  /// Task switching state
  public type TaskSwitchingState = {
    // Current task
    currentTask       : ?TaskRepresentation;
    
    // Task sets
    taskSets          : [TaskSet];
    
    // Switch costs
    switchCost        : Float;
    mixingCost        : Float;
    
    // Preparation
    preparationTime   : Float;
    isPrepared        : Bool;
    
    // Residual activation
    residualActivation : [(Nat, Float)];
  };

  /// Task representation
  public type TaskRepresentation = {
    taskId            : Nat;
    taskName          : Text;
    stimulusResponseMapping : [(Text, Text)];
    attentionalBias   : [Float];
    performanceLevel  : Float;
  };

  /// Task set
  public type TaskSet = {
    setId             : Nat;
    setName           : Text;
    rules             : [TaskRule];
    activation        : Float;
    lastUsed          : Nat;
  };

  /// Task rule
  public type TaskRule = {
    ruleId            : Nat;
    condition         : [Float];
    action            : Text;
    confidence        : Float;
  };

  /// Error monitoring state
  public type ErrorMonitoringState = {
    // Error detection
    errorSignal       : Float;
    conflictSignal    : Float;
    
    // Error history
    recentErrors      : [DetectedError];
    errorRate         : Float;
    
    // Post-error adjustments
    postErrorSlowing  : Float;
    postErrorAccuracy : Float;
    
    // Conflict monitoring
    responseConflict  : Float;
    
    // Error-related negativity
    ernAmplitude      : Float;
  };

  /// Detected error
  public type DetectedError = {
    errorId           : Nat;
    errorType         : Text;
    errorMagnitude    : Float;
    correctResponse   : ?[Float];
    actualResponse    : [Float];
    beat              : Nat;
  };

  /// Metacognition state
  public type MetacognitionState = {
    // Self-awareness
    selfAwareness     : Float;
    
    // Knowledge about own cognition
    cognitiveStrengths : [(Text, Float)];
    cognitiveWeaknesses : [(Text, Float)];
    
    // Monitoring
    confidenceCalibration : Float;
    judgmentAccuracy  : Float;
    
    // Control
    strategySelection : Text;
    effortAllocation  : Float;
    
    // Uncertainty
    uncertaintyEstimate : Float;
    knowledgeGaps     : [Text];
    
    // Feeling of knowing
    feelingOfKnowing  : Float;
  };

  /// Planning state
  public type PlanningState = {
    // Current plan
    currentPlan       : ?Plan;
    
    // Plan alternatives
    alternativePlans  : [Plan];
    
    // Planning depth
    planningHorizon   : Nat;
    
    // Simulation
    mentalSimulation  : MentalSimulationState;
    
    // Replanning
    replanningNeeded  : Bool;
    lastReplanBeat    : Nat;
  };

  /// Plan
  public type Plan = {
    planId            : Nat;
    steps             : [PlanStep];
    expectedOutcome   : [Float];
    expectedCost      : Float;
    expectedDuration  : Nat;
    confidence        : Float;
  };

  /// Plan step
  public type PlanStep = {
    stepId            : Nat;
    action            : Text;
    preconditions     : [Float];
    postconditions    : [Float];
    isComplete        : Bool;
    isCurrent         : Bool;
  };

  /// Mental simulation state
  public type MentalSimulationState = {
    // Simulation
    simulatedStates   : [[Float]];
    simulationDepth   : Nat;
    
    // Outcomes
    predictedOutcomes : [(Plan, [Float])];
    
    // Counterfactuals
    counterfactuals   : [{ action: Text; predictedOutcome: [Float] }];
  };

  /// Executive attention state
  public type ExecutiveAttentionState = {
    // Focus
    focusIntensity    : Float;
    focusDuration     : Nat;
    
    // Selection
    selectedTarget    : ?Nat;
    competingTargets  : [(Nat, Float)];
    
    // Sustained attention
    vigilanceLevel    : Float;
    vigilanceDecrement : Float;
    
    // Divided attention
    attentionSplits   : [(Nat, Float)];
    divisionCost      : Float;
    
    // Attentional blink
    isInAttentionalBlink : Bool;
    blinkDuration     : Nat;
  };

  /// Initialize executive functions
  public func initExecutiveFunctions() : ExecutiveFunctionState {
    {
      goalHierarchy = {
        superordinateGoals = [
          { goalId = 0; goalType = "survival"; importance = 1.0; timeHorizon = 10000; satisfactionLevel = 0.8 },
          { goalId = 1; goalType = "mission"; importance = 0.9; timeHorizon = 1000; satisfactionLevel = 0.5 },
          { goalId = 2; goalType = "swarm_cohesion"; importance = 0.8; timeHorizon = 100; satisfactionLevel = 0.6 }
        ];
        currentGoals = [];
        subgoals = [];
        activeGoalStack = [];
        goalConflicts = [];
        goalProgress = [];
      };
      inhibitoryControl = {
        responseThreshold = 0.5;
        inhibitionStrength = 0.7;
        goSignal = 0.0;
        noGoSignal = 0.0;
        prepotentResponses = [];
        stopSignalReactionTime = 0.2;
        stopSuccessRate = 0.8;
        interferenceLevel = 0.0;
      };
      taskSwitching = {
        currentTask = null;
        taskSets = [];
        switchCost = 0.2;
        mixingCost = 0.1;
        preparationTime = 0.0;
        isPrepared = true;
        residualActivation = [];
      };
      errorMonitoring = {
        errorSignal = 0.0;
        conflictSignal = 0.0;
        recentErrors = [];
        errorRate = 0.0;
        postErrorSlowing = 0.0;
        postErrorAccuracy = 1.0;
        responseConflict = 0.0;
        ernAmplitude = 0.0;
      };
      metacognition = {
        selfAwareness = 0.5;
        cognitiveStrengths = [];
        cognitiveWeaknesses = [];
        confidenceCalibration = 0.5;
        judgmentAccuracy = 0.5;
        strategySelection = "default";
        effortAllocation = 0.5;
        uncertaintyEstimate = 0.3;
        knowledgeGaps = [];
        feelingOfKnowing = 0.5;
      };
      planning = {
        currentPlan = null;
        alternativePlans = [];
        planningHorizon = 10;
        mentalSimulation = {
          simulatedStates = [[]];
          simulationDepth = 0;
          predictedOutcomes = [];
          counterfactuals = [];
        };
        replanningNeeded = false;
        lastReplanBeat = 0;
      };
      executiveAttention = {
        focusIntensity = 0.5;
        focusDuration = 0;
        selectedTarget = null;
        competingTargets = [];
        vigilanceLevel = 0.8;
        vigilanceDecrement = 0.001;
        attentionSplits = [];
        divisionCost = 0.3;
        isInAttentionalBlink = false;
        blinkDuration = 0;
      };
      beatNum = 0;
    }
  };

  /// Update error monitoring
  public func updateErrorMonitoring(
    em: ErrorMonitoringState,
    expectedResponse: [Float],
    actualResponse: [Float],
    beat: Nat
  ) : ErrorMonitoringState {
    // Compute response conflict
    var conflict : Float = 0.0;
    let minLen = Int.min(expectedResponse.size(), actualResponse.size());
    for (i in Iter.range(0, minLen - 1)) {
      conflict += Float.abs(expectedResponse[i] - actualResponse[i]);
    };
    conflict := conflict / Float.fromInt(minLen + 1);
    
    // Detect error
    let isError = conflict > 0.3;
    let errorMagnitude = conflict;
    
    var newErrors = em.recentErrors;
    if (isError) {
      let newError : DetectedError = {
        errorId = em.recentErrors.size();
        errorType = "response_error";
        errorMagnitude = errorMagnitude;
        correctResponse = ?expectedResponse;
        actualResponse = actualResponse;
        beat = beat;
      };
      newErrors := Array.append(newErrors, [newError]);
      // Keep only recent errors
      if (newErrors.size() > 20) {
        newErrors := Array.tabulate<DetectedError>(20, func(i) {
          newErrors[newErrors.size() - 20 + i]
        });
      };
    };
    
    // Compute error rate
    let errorCount = Float.fromInt(newErrors.size());
    let newErrorRate = errorCount / 20.0;
    
    // Post-error adjustments
    let newSlowing = if (isError) { 0.2 } else { em.postErrorSlowing * 0.9 };
    
    // Error-related negativity
    let ernAmpl = if (isError) { errorMagnitude * 2.0 } else { em.ernAmplitude * 0.8 };
    
    {
      errorSignal = if (isError) { 1.0 } else { em.errorSignal * 0.9 };
      conflictSignal = conflict;
      recentErrors = newErrors;
      errorRate = newErrorRate;
      postErrorSlowing = newSlowing;
      postErrorAccuracy = if (isError) { 0.5 } else { em.postErrorAccuracy * 0.99 + 0.01 };
      responseConflict = conflict;
      ernAmplitude = ernAmpl;
    }
  };

  /// Select goal
  public func selectGoal(
    hierarchy: GoalHierarchy,
    urgentSignals: [(Nat, Float)],
    beat: Nat
  ) : (GoalHierarchy, ?Nat) {
    // Compute goal activations
    var goalActivations : [(Nat, Float)] = [];
    
    for (goal in hierarchy.currentGoals.vals()) {
      var activation = goal.priority;
      
      // Urgency bonus
      for ((gid, urgency) in urgentSignals.vals()) {
        if (gid == goal.goalId) {
          activation := activation + urgency;
        };
      };
      
      // Progress bonus (prefer almost-complete goals)
      if (goal.currentProgress > 0.8) {
        activation := activation + 0.2;
      };
      
      // Deadline pressure
      switch (goal.deadline) {
        case (?dl) {
          if (dl > beat and dl - beat < 100) {
            activation := activation + 0.3;
          };
        };
        case null { };
      };
      
      goalActivations := Array.append(goalActivations, [(goal.goalId, activation)]);
    };
    
    // Find highest activation
    var maxActivation : Float = 0.0;
    var selectedGoal : ?Nat = null;
    for ((gid, act) in goalActivations.vals()) {
      if (act > maxActivation) {
        maxActivation := act;
        selectedGoal := ?gid;
      };
    };
    
    // Update goal stack
    var newStack = hierarchy.activeGoalStack;
    switch (selectedGoal) {
      case (?gid) {
        // Push to stack if not already there
        var found = false;
        for (g in newStack.vals()) {
          if (g == gid) { found := true };
        };
        if (not found) {
          newStack := Array.append([gid], newStack);
        };
      };
      case null { };
    };
    
    let newHierarchy : GoalHierarchy = {
      superordinateGoals = hierarchy.superordinateGoals;
      currentGoals = hierarchy.currentGoals;
      subgoals = hierarchy.subgoals;
      activeGoalStack = newStack;
      goalConflicts = hierarchy.goalConflicts;
      goalProgress = goalActivations;
    };
    
    (newHierarchy, selectedGoal)
  };

  /// Generate plan
  public func generatePlan(
    planning: PlanningState,
    currentState: [Float],
    goalState: [Float],
    availableActions: [Text],
    maxDepth: Nat
  ) : PlanningState {
    // Simple forward planning
    var steps : [PlanStep] = [];
    var simState = currentState;
    
    for (depth in Iter.range(0, maxDepth - 1)) {
      // Find action that moves toward goal
      var bestAction : ?Text = null;
      var bestDistance : Float = 1000.0;
      
      for (action in availableActions.vals()) {
        // Predict next state (simplified)
        var predictedState = simState;
        
        // Compute distance to goal
        var dist : Float = 0.0;
        let minLen = Int.min(predictedState.size(), goalState.size());
        for (i in Iter.range(0, minLen - 1)) {
          dist += (predictedState[i] - goalState[i]) ** 2.0;
        };
        dist := Float.sqrt(dist);
        
        if (dist < bestDistance) {
          bestDistance := dist;
          bestAction := ?action;
        };
      };
      
      switch (bestAction) {
        case (?action) {
          let step : PlanStep = {
            stepId = steps.size();
            action = action;
            preconditions = simState;
            postconditions = [];  // Would be predicted
            isComplete = false;
            isCurrent = steps.size() == 0;
          };
          steps := Array.append(steps, [step]);
        };
        case null { };
      };
      
      // Check if goal reached
      if (bestDistance < 0.1) {
        // Plan complete
        let plan : Plan = {
          planId = 0;
          steps = steps;
          expectedOutcome = goalState;
          expectedCost = Float.fromInt(steps.size());
          expectedDuration = steps.size() * 10;
          confidence = 1.0 - bestDistance;
        };
        
        return {
          currentPlan = ?plan;
          alternativePlans = planning.alternativePlans;
          planningHorizon = maxDepth;
          mentalSimulation = {
            simulatedStates = planning.mentalSimulation.simulatedStates;
            simulationDepth = steps.size();
            predictedOutcomes = [(plan, goalState)];
            counterfactuals = planning.mentalSimulation.counterfactuals;
          };
          replanningNeeded = false;
          lastReplanBeat = planning.lastReplanBeat;
        };
      };
    };
    
    // No complete plan found
    let partialPlan : Plan = {
      planId = 0;
      steps = steps;
      expectedOutcome = [];
      expectedCost = Float.fromInt(steps.size());
      expectedDuration = steps.size() * 10;
      confidence = 0.3;
    };
    
    {
      currentPlan = ?partialPlan;
      alternativePlans = planning.alternativePlans;
      planningHorizon = maxDepth;
      mentalSimulation = planning.mentalSimulation;
      replanningNeeded = true;
      lastReplanBeat = planning.lastReplanBeat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 34: EMOTIONAL PROCESSING — AFFECTIVE SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Complete emotional processing:
  //   • Basic emotions (fear, anger, joy, sadness, etc.)
  //   • Emotion regulation
  //   • Mood states
  //   • Emotional memory
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Emotional processing state
  public type EmotionalProcessingState = {
    // Basic emotions
    basicEmotions     : BasicEmotions;
    
    // Dimensional model
    valenceArousal    : ValenceArousalState;
    
    // Emotion regulation
    emotionRegulation : EmotionRegulationState;
    
    // Mood
    moodState         : MoodState;
    
    // Emotional memory
    emotionalMemory   : EmotionalMemoryStore;
    
    // Appraisal
    appraisalState    : AppraisalState;
    
    beatNum           : Nat;
  };

  /// Basic emotions (Ekman)
  public type BasicEmotions = {
    fear              : Float;
    anger             : Float;
    joy               : Float;
    sadness           : Float;
    surprise          : Float;
    disgust           : Float;
    
    // Additional
    anticipation      : Float;
    trust             : Float;
  };

  /// Valence-arousal state
  public type ValenceArousalState = {
    valence           : Float;       // -1 (negative) to +1 (positive)
    arousal           : Float;       // 0 (calm) to 1 (excited)
    dominance         : Float;       // 0 (submissive) to 1 (dominant)
    
    // Trajectory
    valenceVelocity   : Float;
    arousalVelocity   : Float;
    
    // History
    recentValence     : [Float];
    recentArousal     : [Float];
  };

  /// Emotion regulation state
  public type EmotionRegulationState = {
    // Regulation strategy
    currentStrategy   : RegulationStrategy;
    
    // Regulation capacity
    regulationCapacity : Float;
    depletionLevel    : Float;
    
    // Goals
    emotionGoals      : [(Text, Float)];  // (emotion, desired_level)
    
    // Success
    regulationSuccess : Float;
    
    // Automatic vs controlled
    automaticRegulation : Float;
    controlledRegulation : Float;
  };

  /// Regulation strategies
  public type RegulationStrategy = {
    #Reappraisal;      // Cognitive reframing
    #Suppression;      // Inhibit expression
    #Distraction;      // Redirect attention
    #Acceptance;       // Accept the emotion
    #ProblemSolving;   // Address the cause
  };

  /// Mood state
  public type MoodState = {
    // Current mood
    currentMood       : Text;
    moodIntensity     : Float;
    
    // Mood components
    positiveAffect    : Float;
    negativeAffect    : Float;
    
    // Stability
    moodStability     : Float;
    lastMoodChange    : Nat;
    
    // Circadian influence
    circadianPhase    : Float;
    circadianAmplitude : Float;
  };

  /// Emotional memory store
  public type EmotionalMemoryStore = {
    // Emotional events
    emotionalEvents   : [EmotionalEvent];
    
    // Conditioned emotions
    conditionedEmotions : [(stimulus: [Float], emotion: Text, strength: Float)];
    
    // Emotional schemas
    emotionalSchemas  : [(trigger: Text, response: BasicEmotions)];
  };

  /// Emotional event
  public type EmotionalEvent = {
    eventId           : Nat;
    timestamp         : Nat;
    emotion           : Text;
    intensity         : Float;
    trigger           : Text;
    context           : [Float];
    outcome           : Text;
  };

  /// Appraisal state
  public type AppraisalState = {
    // Primary appraisal
    goalRelevance     : Float;
    goalCongruence    : Float;       // Goal-consistent or not
    
    // Secondary appraisal
    coping            : Float;       // Ability to cope
    futureExpectancy  : Float;       // Expected outcome
    
    // Agency
    selfAgency        : Float;       // Self caused
    otherAgency       : Float;       // Other caused
    
    // Certainty
    situationCertainty : Float;
    
    // Attention
    attentionalActivity : Float;
  };

  /// Initialize emotional processing
  public func initEmotionalProcessing() : EmotionalProcessingState {
    {
      basicEmotions = {
        fear = 0.0;
        anger = 0.0;
        joy = 0.3;
        sadness = 0.0;
        surprise = 0.0;
        disgust = 0.0;
        anticipation = 0.2;
        trust = 0.5;
      };
      valenceArousal = {
        valence = 0.0;
        arousal = 0.3;
        dominance = 0.5;
        valenceVelocity = 0.0;
        arousalVelocity = 0.0;
        recentValence = [];
        recentArousal = [];
      };
      emotionRegulation = {
        currentStrategy = #Acceptance;
        regulationCapacity = 1.0;
        depletionLevel = 0.0;
        emotionGoals = [];
        regulationSuccess = 0.5;
        automaticRegulation = 0.5;
        controlledRegulation = 0.5;
      };
      moodState = {
        currentMood = "neutral";
        moodIntensity = 0.3;
        positiveAffect = 0.5;
        negativeAffect = 0.2;
        moodStability = 0.8;
        lastMoodChange = 0;
        circadianPhase = 0.0;
        circadianAmplitude = 0.2;
      };
      emotionalMemory = {
        emotionalEvents = [];
        conditionedEmotions = [];
        emotionalSchemas = [];
      };
      appraisalState = {
        goalRelevance = 0.5;
        goalCongruence = 0.5;
        coping = 0.7;
        futureExpectancy = 0.5;
        selfAgency = 0.5;
        otherAgency = 0.3;
        situationCertainty = 0.5;
        attentionalActivity = 0.5;
      };
      beatNum = 0;
    }
  };

  /// Appraise event
  public func appraiseEvent(
    appraisal: AppraisalState,
    event: { stimulus: [Float]; isGoalRelevant: Bool; isGoalCongruent: Bool; isSelfCaused: Bool }
  ) : (AppraisalState, BasicEmotions) {
    // Primary appraisal
    let relevance = if (event.isGoalRelevant) { 1.0 } else { 0.2 };
    let congruence = if (event.isGoalCongruent) { 1.0 } else { -1.0 };
    
    // Secondary appraisal (simplified)
    let coping = appraisal.coping;
    let agency = if (event.isSelfCaused) { 1.0 } else { 0.0 };
    
    // Generate emotions based on appraisal
    var emotions : BasicEmotions = {
      fear = 0.0;
      anger = 0.0;
      joy = 0.0;
      sadness = 0.0;
      surprise = 0.0;
      disgust = 0.0;
      anticipation = 0.0;
      trust = 0.0;
    };
    
    if (relevance > 0.5) {
      if (congruence > 0.0) {
        // Goal-congruent
        emotions := {
          fear = 0.0;
          anger = 0.0;
          joy = relevance * congruence;
          sadness = 0.0;
          surprise = 0.0;
          disgust = 0.0;
          anticipation = relevance * 0.5;
          trust = if (agency < 0.5) { relevance * 0.5 } else { 0.0 };
        };
      } else {
        // Goal-incongruent
        if (coping > 0.5) {
          // Can cope - anger
          emotions := {
            fear = 0.0;
            anger = relevance * Float.abs(congruence) * (1.0 - agency);
            joy = 0.0;
            sadness = 0.0;
            surprise = 0.0;
            disgust = 0.0;
            anticipation = 0.0;
            trust = 0.0;
          };
        } else {
          // Can't cope
          if (agency > 0.5) {
            // Self-caused, can't cope - sadness
            emotions := {
              fear = 0.0;
              anger = 0.0;
              joy = 0.0;
              sadness = relevance * Float.abs(congruence);
              surprise = 0.0;
              disgust = 0.0;
              anticipation = 0.0;
              trust = 0.0;
            };
          } else {
            // Other-caused, can't cope - fear
            emotions := {
              fear = relevance * Float.abs(congruence);
              anger = 0.0;
              joy = 0.0;
              sadness = 0.0;
              surprise = 0.0;
              disgust = 0.0;
              anticipation = 0.0;
              trust = 0.0;
            };
          };
        };
      };
    };
    
    let newAppraisal : AppraisalState = {
      goalRelevance = relevance;
      goalCongruence = if (event.isGoalCongruent) { 1.0 } else { -1.0 };
      coping = appraisal.coping;
      futureExpectancy = appraisal.futureExpectancy;
      selfAgency = agency;
      otherAgency = 1.0 - agency;
      situationCertainty = appraisal.situationCertainty;
      attentionalActivity = relevance;
    };
    
    (newAppraisal, emotions)
  };

  /// Update valence-arousal
  public func updateValenceArousal(
    va: ValenceArousalState,
    emotions: BasicEmotions,
    dt: Float
  ) : ValenceArousalState {
    // Compute valence from emotions
    let positiveEmotions = emotions.joy + emotions.trust + emotions.anticipation;
    let negativeEmotions = emotions.fear + emotions.anger + emotions.sadness + emotions.disgust;
    let targetValence = (positiveEmotions - negativeEmotions) / (positiveEmotions + negativeEmotions + 0.01);
    
    // Compute arousal from emotions
    let highArousal = emotions.fear + emotions.anger + emotions.joy + emotions.surprise;
    let lowArousal = emotions.sadness;
    let targetArousal = Float.min(1.0, highArousal + 0.3 - lowArousal * 0.5);
    
    // Update with dynamics
    let valenceVel = (targetValence - va.valence) * 2.0;
    let arousalVel = (targetArousal - va.arousal) * 2.0;
    
    let newValence = va.valence + valenceVel * dt;
    let newArousal = va.arousal + arousalVel * dt;
    
    // Update history
    var newValenceHistory = Array.append(va.recentValence, [newValence]);
    var newArousalHistory = Array.append(va.recentArousal, [newArousal]);
    if (newValenceHistory.size() > 50) {
      newValenceHistory := Array.tabulate<Float>(50, func(i) {
        newValenceHistory[newValenceHistory.size() - 50 + i]
      });
    };
    if (newArousalHistory.size() > 50) {
      newArousalHistory := Array.tabulate<Float>(50, func(i) {
        newArousalHistory[newArousalHistory.size() - 50 + i]
      });
    };
    
    {
      valence = Float.max(-1.0, Float.min(1.0, newValence));
      arousal = Float.max(0.0, Float.min(1.0, newArousal));
      dominance = va.dominance;
      valenceVelocity = valenceVel;
      arousalVelocity = arousalVel;
      recentValence = newValenceHistory;
      recentArousal = newArousalHistory;
    }
  };

  /// Regulate emotion
  public func regulateEmotion(
    regulation: EmotionRegulationState,
    currentEmotions: BasicEmotions,
    strategy: RegulationStrategy,
    dt: Float
  ) : (EmotionRegulationState, BasicEmotions) {
    // Check if regulation capacity available
    if (regulation.depletionLevel > 0.9) {
      // Too depleted to regulate
      return (regulation, currentEmotions);
    };
    
    // Apply strategy
    var regulatedEmotions = currentEmotions;
    var effortUsed : Float = 0.0;
    
    switch (strategy) {
      case (#Reappraisal) {
        // Reduce negative emotions, boost positive
        regulatedEmotions := {
          fear = currentEmotions.fear * 0.7;
          anger = currentEmotions.anger * 0.7;
          joy = currentEmotions.joy * 1.1;
          sadness = currentEmotions.sadness * 0.7;
          surprise = currentEmotions.surprise;
          disgust = currentEmotions.disgust * 0.8;
          anticipation = currentEmotions.anticipation;
          trust = currentEmotions.trust;
        };
        effortUsed := 0.2;
      };
      case (#Suppression) {
        // Reduce all emotions
        regulatedEmotions := {
          fear = currentEmotions.fear * 0.5;
          anger = currentEmotions.anger * 0.5;
          joy = currentEmotions.joy * 0.8;
          sadness = currentEmotions.sadness * 0.5;
          surprise = currentEmotions.surprise * 0.5;
          disgust = currentEmotions.disgust * 0.5;
          anticipation = currentEmotions.anticipation * 0.8;
          trust = currentEmotions.trust * 0.8;
        };
        effortUsed := 0.3;
      };
      case (#Distraction) {
        // Moderate reduction of all
        regulatedEmotions := {
          fear = currentEmotions.fear * 0.8;
          anger = currentEmotions.anger * 0.8;
          joy = currentEmotions.joy * 0.9;
          sadness = currentEmotions.sadness * 0.8;
          surprise = currentEmotions.surprise * 0.9;
          disgust = currentEmotions.disgust * 0.8;
          anticipation = currentEmotions.anticipation * 0.9;
          trust = currentEmotions.trust * 0.9;
        };
        effortUsed := 0.15;
      };
      case (#Acceptance) {
        // No change, minimal effort
        effortUsed := 0.05;
      };
      case (#ProblemSolving) {
        // Context-dependent
        effortUsed := 0.25;
      };
    };
    
    // Update depletion
    let newDepletion = Float.min(1.0, regulation.depletionLevel + effortUsed * dt);
    
    // Recovery
    let recovery = (1.0 - regulation.depletionLevel) * 0.01 * dt;
    let finalDepletion = Float.max(0.0, newDepletion - recovery);
    
    let newRegulation : EmotionRegulationState = {
      currentStrategy = strategy;
      regulationCapacity = 1.0 - finalDepletion;
      depletionLevel = finalDepletion;
      emotionGoals = regulation.emotionGoals;
      regulationSuccess = regulation.regulationSuccess * 0.9 + 0.1;
      automaticRegulation = regulation.automaticRegulation;
      controlledRegulation = regulation.controlledRegulation;
    };
    
    (newRegulation, regulatedEmotions)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 35: FINAL INTEGRATION — THE SUPREME DRONE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// The supreme complete drone with EVERYTHING
  public type SupremeDroneAvatar = {
    // Core
    ultimateDrone     : UltimateDroneAvatar;
    
    // Executive functions
    executiveFunctions : ExecutiveFunctionState;
    
    // Emotional processing
    emotionalProcessing : EmotionalProcessingState;
    
    // Global integration index
    globalIntegration : Float;
    
    beatNum           : Nat;
  };

  /// Initialize supreme drone
  public func initSupremeDrone(
    droneId: Nat,
    squadronId: Nat,
    position: { lat: Float; lon: Float; alt: Float },
    colonyNeeds: [(DroneRole, Float)],
    beat: Nat
  ) : SupremeDroneAvatar {
    {
      ultimateDrone = initUltimateDrone(droneId, squadronId, position, colonyNeeds, beat);
      executiveFunctions = initExecutiveFunctions();
      emotionalProcessing = initEmotionalProcessing();
      globalIntegration = 0.5;
      beatNum = beat;
    }
  };

  /// Supreme tick — everything runs
  public func tickSupremeDrone(
    drone: SupremeDroneAvatar,
    visualInput: [[Float]],
    audioInput: { left: [Float]; right: [Float] },
    observedDrones: [{ id: Nat; pos: { x: Float; y: Float; z: Float }; vel: ?{ vx: Float; vy: Float; vz: Float } }],
    receivedMessages: [SwarmMessage],
    externalThreats: [{ x: Float; y: Float; z: Float; level: Float }],
    batteryLevel: Float,
    ambientTemp: Float,
    signalStrength: Float,
    dt: Float
  ) : SupremeDroneAvatar {
    // 1. Tick ultimate drone
    let newUltimate = tickUltimateDrone(
      drone.ultimateDrone,
      visualInput,
      audioInput,
      observedDrones,
      receivedMessages,
      externalThreats,
      batteryLevel,
      ambientTemp,
      signalStrength,
      dt
    );
    
    // 2. Appraise threats emotionally
    let threatLevel = if (externalThreats.size() > 0) {
      externalThreats[0].level
    } else { 0.0 };
    
    let (newAppraisal, appraisedEmotions) = appraiseEvent(
      drone.emotionalProcessing.appraisalState,
      {
        stimulus = [threatLevel];
        isGoalRelevant = threatLevel > 0.3;
        isGoalCongruent = threatLevel < 0.3;
        isSelfCaused = false;
      }
    );
    
    // 3. Update valence-arousal
    let newVA = updateValenceArousal(
      drone.emotionalProcessing.valenceArousal,
      appraisedEmotions,
      dt
    );
    
    // 4. Regulate emotions if needed
    let (newRegulation, regulatedEmotions) = if (appraisedEmotions.fear > 0.5 or appraisedEmotions.anger > 0.5) {
      regulateEmotion(
        drone.emotionalProcessing.emotionRegulation,
        appraisedEmotions,
        #Reappraisal,
        dt
      )
    } else {
      (drone.emotionalProcessing.emotionRegulation, appraisedEmotions)
    };
    
    // 5. Update error monitoring
    let expectedResponse = [0.5];  // Placeholder
    let actualResponse = [newUltimate.fullBrain.autonomicNS.autonomicBalance];
    let newErrorMonitoring = updateErrorMonitoring(
      drone.executiveFunctions.errorMonitoring,
      expectedResponse,
      actualResponse,
      drone.beatNum
    );
    
    // 6. Compute global integration
    let brainIntegration = newUltimate.fullBrain.integrationLevel;
    let socialIntegration = newUltimate.socialBrain.synchronizationState.orderParameter;
    let emotionalIntegration = 1.0 - Float.abs(newVA.valence);
    let newGlobalIntegration = (brainIntegration + socialIntegration + emotionalIntegration) / 3.0;
    
    let newEmotionalProcessing : EmotionalProcessingState = {
      basicEmotions = regulatedEmotions;
      valenceArousal = newVA;
      emotionRegulation = newRegulation;
      moodState = drone.emotionalProcessing.moodState;
      emotionalMemory = drone.emotionalProcessing.emotionalMemory;
      appraisalState = newAppraisal;
      beatNum = drone.emotionalProcessing.beatNum + 1;
    };
    
    let newExecutiveFunctions : ExecutiveFunctionState = {
      goalHierarchy = drone.executiveFunctions.goalHierarchy;
      inhibitoryControl = drone.executiveFunctions.inhibitoryControl;
      taskSwitching = drone.executiveFunctions.taskSwitching;
      errorMonitoring = newErrorMonitoring;
      metacognition = drone.executiveFunctions.metacognition;
      planning = drone.executiveFunctions.planning;
      executiveAttention = drone.executiveFunctions.executiveAttention;
      beatNum = drone.executiveFunctions.beatNum + 1;
    };
    
    {
      ultimateDrone = newUltimate;
      executiveFunctions = newExecutiveFunctions;
      emotionalProcessing = newEmotionalProcessing;
      globalIntegration = newGlobalIntegration;
      beatNum = drone.beatNum + 1;
    }
  };

  /// Generate supreme output
  public type SupremeOutput = {
    droneId           : Nat;
    isAlive           : Bool;
    position          : { lat: Float; lon: Float; alt: Float };
    
    // Brain
    consciousness     : Float;
    globalIntegration : Float;
    
    // Emotions
    valence           : Float;
    arousal           : Float;
    dominantEmotion   : Text;
    
    // Social
    hierarchyPosition : Float;
    belongingness     : Float;
    
    // Executive
    errorRate         : Float;
    
    beatNum           : Nat;
  };

  public func generateSupremeOutput(drone: SupremeDroneAvatar) : SupremeOutput {
    // Find dominant emotion
    let emotions = drone.emotionalProcessing.basicEmotions;
    var dominant = "neutral";
    var maxIntensity : Float = 0.0;
    
    if (emotions.fear > maxIntensity) { dominant := "fear"; maxIntensity := emotions.fear };
    if (emotions.anger > maxIntensity) { dominant := "anger"; maxIntensity := emotions.anger };
    if (emotions.joy > maxIntensity) { dominant := "joy"; maxIntensity := emotions.joy };
    if (emotions.sadness > maxIntensity) { dominant := "sadness"; maxIntensity := emotions.sadness };
    if (emotions.surprise > maxIntensity) { dominant := "surprise"; maxIntensity := emotions.surprise };
    
    {
      droneId = drone.ultimateDrone.droneId;
      isAlive = drone.ultimateDrone.isAlive;
      position = drone.ultimateDrone.physicalState.position;
      consciousness = drone.ultimateDrone.fullBrain.integrationLevel;
      globalIntegration = drone.globalIntegration;
      valence = drone.emotionalProcessing.valenceArousal.valence;
      arousal = drone.emotionalProcessing.valenceArousal.arousal;
      dominantEmotion = dominant;
      hierarchyPosition = drone.ultimateDrone.socialBrain.hierarchyPosition;
      belongingness = drone.ultimateDrone.socialBrain.socialEmotions.belongingness;
      errorRate = drone.executiveFunctions.errorMonitoring.errorRate;
      beatNum = drone.beatNum;
    }
  };

}
