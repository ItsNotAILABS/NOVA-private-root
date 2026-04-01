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

}
