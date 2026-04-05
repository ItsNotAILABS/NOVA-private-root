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

}
