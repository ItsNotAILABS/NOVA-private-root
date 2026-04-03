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
// NEUROEMERGENCE CORE — PREFRONTAL CORTEX ENGINE
// Executive function, working memory, and cognitive control
// 
// Biological basis:
// - dlPFC: Dorsolateral - working memory, planning
// - vmPFC: Ventromedial - value-based decisions, emotions
// - ACC: Anterior Cingulate - conflict monitoring, error detection
// - OFC: Orbitofrontal - reward expectation, behavioral flexibility
// 
// Mathematical Framework:
// - Working Memory: slot-based with decay W(t) = W₀ · e^(-t/τ)
// - Conflict: C = -Σᵢ pᵢ log(pᵢ) (entropy of competing responses)
// - Cognitive Control: u = K·(goal - state) + conflict_adjustment
// - Goal maintenance: g(t+1) = g(t)·(1-λ) + new_goal·λ
// 
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Option "mo:base/Option";

module {

  // ══════════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════════

  // Working memory slot
  public type WMSlot = {
    content     : [Float];        // Item stored in slot
    strength    : Float;          // Activation strength [0, 1]
    age         : Nat;            // Beats since encoding
    priority    : Float;          // Task relevance [0, 1]
    protected   : Bool;           // Is this slot protected from interference?
  };

  // Goal representation
  public type Goal = {
    id          : Nat;
    representation: [Float];      // Goal state encoding
    priority    : Float;          // Urgency [0, 1]
    progress    : Float;          // Completion progress [0, 1]
    subgoals    : [Nat];          // IDs of subgoals
    deadline    : ?Nat;           // Optional deadline (beat number)
    active      : Bool;
  };

  // Task set / Rule
  public type TaskSet = {
    id          : Nat;
    name        : Text;
    rules       : [[Float]];      // Stimulus-response mappings
    context     : [Float];        // Context that triggers this set
    strength    : Float;          // Current activation
    useCount    : Nat;            // Times activated
    lastUse     : Nat;            // Beat of last use
  };

  // Dorsolateral PFC state
  public type DLPFCState = {
    workingMemory     : [WMSlot]; // Working memory slots
    capacity          : Nat;      // Max slots (typically 4-7)
    maintenanceSignal : Float;    // Tonic dopamine for maintenance
    gatingSignal      : Float;    // Phasic dopamine for updating
    activeGoal        : ?Nat;     // Currently pursued goal ID
  };

  // Ventromedial PFC state  
  public type VMPFCState = {
    valueEstimates    : [Float];  // Value of current options
    emotionalState    : Float;    // Affective valence [-1, 1]
    riskTolerance     : Float;    // Risk preference [0, 1]
    somaticMarker     : Float;    // Bodily feeling signal
    socialValue       : Float;    // Value of social outcomes
  };

  // Anterior Cingulate Cortex state
  public type ACCState = {
    conflictSignal    : Float;    // Response conflict [0, 1]
    errorSignal       : Float;    // Error detection [0, 1]
    effortSignal      : Float;    // Cognitive effort required [0, 1]
    volatility        : Float;    // Environmental change rate
    controlDemand     : Float;    // Computed control need
    errorHistory      : [Float];  // Recent errors for learning
  };

  // Orbitofrontal Cortex state
  public type OFCState = {
    expectedReward    : Float;    // Current reward expectation
    rewardPredError   : Float;    // Prediction error
    outcomeHistory    : [Float];  // Recent outcomes
    reversalIndex     : Float;    // Flexibility measure [0, 1]
    stimulusValues    : [Float];  // Learned stimulus values
  };

  // Plan step
  public type PlanStep = {
    action      : Nat;            // Action to take
    expectedState: [Float];       // Expected resulting state
    contingency : ?Nat;           // Alternative if this fails
  };

  // Full prefrontal state
  public type PrefrontalState = {
    // Subregions
    dlpfc         : DLPFCState;
    vmpfc         : VMPFCState;
    acc           : ACCState;
    ofc           : OFCState;
    
    // Goal management
    goals         : [Goal];
    goalStack     : [Nat];        // Goal hierarchy (stack)
    
    // Task control
    taskSets      : [TaskSet];
    activeTaskSet : ?Nat;
    taskSwitchCost: Float;        // Cost of switching tasks
    
    // Planning
    currentPlan   : [PlanStep];
    planHorizon   : Nat;          // How far ahead to plan
    
    // Inhibition
    inhibitionStrength: Float;    // Ability to suppress responses
    impulsivity   : Float;        // Inverse of inhibition
    
    // Metacognition
    confidence    : Float;        // Confidence in current strategy
    uncertainty   : Float;        // Estimated uncertainty
    
    // Temporal
    beatNum       : Nat;
    lastUpdate    : Nat;
    
    // Learning
    controlLR     : Float;        // Learning rate for control
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let EPSILON : Float = 1e-10;
  let WM_CAPACITY : Nat = 4;        // Miller's 4±1
  let WM_DECAY_TAU : Float = 100.0; // Decay time constant
  let CONFLICT_THRESHOLD : Float = 0.5;
  let ERROR_THRESHOLD : Float = 0.3;

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func _max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  // Log base 2
  func _log2(x: Float) : Float {
    if (x <= EPSILON) { 0.0 } else { Float.log(x) / Float.log(2.0) }
  };

  // Entropy of distribution (conflict measure)
  func entropy(probs: [Float]) : Float {
    var h : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) {
        h -= p * _log2(p);
      };
    };
    h
  };

  // Softmax
  func softmax(values: [Float], temp: Float) : [Float] {
    let n = values.size();
    if (n == 0) { return [] };
    
    var maxVal : Float = values[0];
    for (v in values.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    
    var sumExp : Float = 0.0;
    let exps = Array.tabulate<Float>(n, func(i) {
      let e = Float.exp((values[i] - maxVal) / (temp + EPSILON));
      sumExp += e;
      e
    });
    
    Array.map<Float, Float>(exps, func(e) { e / (sumExp + EPSILON) })
  };

  // ══════════════════════════════════════════════════════════════
  // WORKING MEMORY (dlPFC)
  // ══════════════════════════════════════════════════════════════

  // Decay working memory over time
  // W(t) = W₀ · e^(-t/τ)
  public func decayWorkingMemory(slots: [WMSlot]) : [WMSlot] {
    Array.map<WMSlot, WMSlot>(slots, func(slot) {
      if (slot.protected) {
        // Protected slots don't decay
        { slot with age = slot.age + 1 }
      } else {
        let newStrength = slot.strength * Float.exp(-1.0 / WM_DECAY_TAU);
        { slot with strength = newStrength; age = slot.age + 1 }
      }
    })
  };

  // Should item be gated into WM?
  // Gating controlled by phasic dopamine
  public func shouldGate(
    gatingSignal: Float, 
    itemPriority: Float
  ) : Bool {
    gatingSignal * itemPriority > 0.5
  };

  // Add item to working memory
  public func addToWorkingMemory(
    slots: [WMSlot],
    content: [Float],
    priority: Float,
    capacity: Nat
  ) : [WMSlot] {
    let newSlot : WMSlot = {
      content = content;
      strength = 1.0;
      age = 0;
      priority = priority;
      protected = priority > 0.8;
    };
    
    if (slots.size() < capacity) {
      Array.append(slots, [newSlot])
    } else {
      // Replace weakest unprotected slot
      var weakestIdx : Nat = 0;
      var weakestStrength : Float = 2.0;
      var i : Nat = 0;
      for (slot in slots.vals()) {
        if (not slot.protected and slot.strength < weakestStrength) {
          weakestStrength := slot.strength;
          weakestIdx := i;
        };
        i += 1;
      };
      
      Array.tabulate<WMSlot>(slots.size(), func(j) {
        if (j == weakestIdx) { newSlot } else { slots[j] }
      })
    }
  };

  // Retrieve from working memory based on cue
  public func retrieveFromWM(
    slots: [WMSlot],
    cue: [Float]
  ) : ?[Float] {
    var bestMatch : Float = 0.0;
    var bestSlot : ?[Float] = null;
    
    for (slot in slots.vals()) {
      // Compute similarity (dot product)
      var sim : Float = 0.0;
      let minLen = Nat.min(slot.content.size(), cue.size());
      var i : Nat = 0;
      while (i < minLen) {
        sim += slot.content[i] * cue[i];
        i += 1;
      };
      
      let strength = sim * slot.strength;
      if (strength > bestMatch) {
        bestMatch := strength;
        bestSlot := ?slot.content;
      };
    };
    
    bestSlot
  };

  // ══════════════════════════════════════════════════════════════
  // CONFLICT MONITORING (ACC)
  // ══════════════════════════════════════════════════════════════

  // Compute response conflict
  // Conflict = entropy of competing response probabilities
  public func computeConflict(responseProbs: [Float]) : Float {
    let maxEntropy = _log2(Float.fromInt(responseProbs.size()));
    if (maxEntropy < EPSILON) { return 0.0 };
    
    let h = entropy(responseProbs);
    _clamp(h / maxEntropy, 0.0, 1.0)
  };

  // Compute error signal
  public func computeError(expected: Float, actual: Float) : Float {
    _abs(expected - actual)
  };

  // Update ACC based on response conflict and errors
  public func updateACC(
    acc: ACCState,
    responseProbs: [Float],
    reward: Float,
    expectedReward: Float
  ) : ACCState {
    // Conflict
    let conflict = computeConflict(responseProbs);
    
    // Error (reward prediction error)
    let error = computeError(expectedReward, reward);
    
    // Update error history
    let newHistory = if (acc.errorHistory.size() >= 50) {
      let tail = Array.tabulate<Float>(49, func(i) { acc.errorHistory[i + 1] });
      Array.append(tail, [error])
    } else {
      Array.append(acc.errorHistory, [error])
    };
    
    // Compute volatility (variance of recent errors)
    var sumSq : Float = 0.0;
    var sum : Float = 0.0;
    for (e in newHistory.vals()) {
      sum += e;
      sumSq += e * e;
    };
    let n = Float.fromInt(newHistory.size());
    let mean = sum / n;
    let variance = sumSq / n - mean * mean;
    let volatility = Float.sqrt(_abs(variance));
    
    // Effort: function of conflict and volatility
    let effort = conflict * 0.6 + volatility * 0.4;
    
    // Control demand: high conflict or error triggers more control
    let controlDemand = _clamp(conflict * 0.5 + error * 0.3 + volatility * 0.2, 0.0, 1.0);
    
    {
      conflictSignal = conflict;
      errorSignal = error;
      effortSignal = effort;
      volatility = volatility;
      controlDemand = controlDemand;
      errorHistory = newHistory;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // VALUE COMPUTATION (vmPFC)
  // ══════════════════════════════════════════════════════════════

  // Compute subjective value with emotional modulation
  public func computeSubjectiveValue(
    objectiveValue: Float,
    emotionalState: Float,
    riskTolerance: Float,
    somaticMarker: Float
  ) : Float {
    // Value = objective × emotional_bias × risk_adjustment × somatic_signal
    let emotionalBias = 1.0 + emotionalState * 0.3;  // Positive emotions increase value
    let riskAdjustment = if (objectiveValue < 0.0) {
      1.0 + (1.0 - riskTolerance) * 0.5  // Risk aversion amplifies losses
    } else {
      1.0 - (1.0 - riskTolerance) * 0.3  // Risk aversion diminishes gains
    };
    let somaticAdjustment = 1.0 + somaticMarker * 0.2;
    
    objectiveValue * emotionalBias * riskAdjustment * somaticAdjustment
  };

  // Update vmPFC based on outcomes and emotions
  public func updateVMPFC(
    vmpfc: VMPFCState,
    outcomes: [Float],
    currentEmotion: Float,
    socialOutcome: Float
  ) : VMPFCState {
    // Update value estimates
    let newValues = Array.tabulate<Float>(outcomes.size(), func(i) {
      computeSubjectiveValue(outcomes[i], currentEmotion, vmpfc.riskTolerance, vmpfc.somaticMarker)
    });
    
    // Update emotional state (slowly track outcomes)
    var avgOutcome : Float = 0.0;
    for (o in outcomes.vals()) { avgOutcome += o };
    avgOutcome /= Float.fromInt(Nat.max(outcomes.size(), 1));
    
    let newEmotion = vmpfc.emotionalState * 0.9 + avgOutcome * 0.1;
    
    // Update risk tolerance based on recent success/failure
    let newRisk = if (avgOutcome > 0.0) {
      _clamp(vmpfc.riskTolerance * 1.02, 0.0, 1.0)  // Success increases risk tolerance
    } else {
      _clamp(vmpfc.riskTolerance * 0.98, 0.0, 1.0)  // Failure decreases it
    };
    
    {
      valueEstimates = newValues;
      emotionalState = _clamp(newEmotion, -1.0, 1.0);
      riskTolerance = newRisk;
      somaticMarker = vmpfc.somaticMarker * 0.95 + avgOutcome * 0.05;
      socialValue = vmpfc.socialValue * 0.9 + socialOutcome * 0.1;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // REWARD LEARNING (OFC)
  // ══════════════════════════════════════════════════════════════

  // Update OFC with new outcome
  public func updateOFC(
    ofc: OFCState,
    actualReward: Float,
    stimulusIdx: Nat
  ) : OFCState {
    // Compute prediction error
    let rpe = actualReward - ofc.expectedReward;
    
    // Update expected reward
    let newExpected = ofc.expectedReward + 0.1 * rpe;
    
    // Update outcome history
    let newHistory = if (ofc.outcomeHistory.size() >= 50) {
      let tail = Array.tabulate<Float>(49, func(i) { ofc.outcomeHistory[i + 1] });
      Array.append(tail, [actualReward])
    } else {
      Array.append(ofc.outcomeHistory, [actualReward])
    };
    
    // Update stimulus values
    let newStimValues = Array.tabulate<Float>(
      Nat.max(ofc.stimulusValues.size(), stimulusIdx + 1),
      func(i) {
        if (i == stimulusIdx) {
          let old = if (i < ofc.stimulusValues.size()) { ofc.stimulusValues[i] } else { 0.0 };
          old + 0.1 * rpe
        } else {
          if (i < ofc.stimulusValues.size()) { ofc.stimulusValues[i] } else { 0.0 }
        }
      }
    );
    
    // Reversal index: ability to update when contingencies change
    let reversalIndex = if (_abs(rpe) > 0.5) {
      _clamp(ofc.reversalIndex + 0.05, 0.0, 1.0)
    } else {
      _clamp(ofc.reversalIndex - 0.01, 0.0, 1.0)
    };
    
    {
      expectedReward = _clamp(newExpected, -1.0, 1.0);
      rewardPredError = rpe;
      outcomeHistory = newHistory;
      reversalIndex = reversalIndex;
      stimulusValues = newStimValues;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // GOAL MANAGEMENT
  // ══════════════════════════════════════════════════════════════

  // Update goal progress
  public func updateGoal(
    goal: Goal,
    currentState: [Float],
    beatNum: Nat
  ) : Goal {
    // Compute distance to goal
    var dist : Float = 0.0;
    let minLen = Nat.min(goal.representation.size(), currentState.size());
    var i : Nat = 0;
    while (i < minLen) {
      let d = goal.representation[i] - currentState[i];
      dist += d * d;
      i += 1;
    };
    dist := Float.sqrt(dist);
    
    // Progress is inverse of distance
    let newProgress = _clamp(1.0 - dist, 0.0, 1.0);
    
    // Check deadline
    let stillActive = switch (goal.deadline) {
      case (?deadline) { beatNum < deadline };
      case (null) { true };
    };
    
    {
      id = goal.id;
      representation = goal.representation;
      priority = goal.priority;
      progress = newProgress;
      subgoals = goal.subgoals;
      deadline = goal.deadline;
      active = stillActive and newProgress < 0.95;
    }
  };

  // Select most important active goal
  public func selectActiveGoal(goals: [Goal]) : ?Nat {
    var bestPriority : Float = 0.0;
    var bestId : ?Nat = null;
    
    for (goal in goals.vals()) {
      if (goal.active) {
        let urgency = switch (goal.deadline) {
          case (?_) { 1.2 };  // Deadline adds urgency
          case (null) { 1.0 };
        };
        let effectivePriority = goal.priority * urgency * (1.0 - goal.progress);
        if (effectivePriority > bestPriority) {
          bestPriority := effectivePriority;
          bestId := ?goal.id;
        };
      };
    };
    
    bestId
  };

  // ══════════════════════════════════════════════════════════════
  // TASK SWITCHING
  // ══════════════════════════════════════════════════════════════

  // Find best matching task set for current context
  public func matchTaskSet(
    taskSets: [TaskSet],
    context: [Float]
  ) : ?Nat {
    var bestMatch : Float = 0.0;
    var bestId : ?Nat = null;
    
    var idx : Nat = 0;
    for (ts in taskSets.vals()) {
      // Compute context similarity
      var sim : Float = 0.0;
      let minLen = Nat.min(ts.context.size(), context.size());
      var i : Nat = 0;
      while (i < minLen) {
        sim += ts.context[i] * context[i];
        i += 1;
      };
      
      let match = sim * ts.strength;
      if (match > bestMatch) {
        bestMatch := match;
        bestId := ?idx;
      };
      idx += 1;
    };
    
    bestId
  };

  // Compute task switch cost
  public func computeSwitchCost(
    fromTask: ?Nat,
    toTask: Nat,
    taskSets: [TaskSet]
  ) : Float {
    switch (fromTask) {
      case (?from) {
        if (from == toTask) { 0.0 }
        else {
          // Cost proportional to difference in task strength
          let fromStrength = if (from < taskSets.size()) { taskSets[from].strength } else { 0.0 };
          let toStrength = if (toTask < taskSets.size()) { taskSets[toTask].strength } else { 0.0 };
          0.2 + _abs(fromStrength - toStrength) * 0.3
        }
      };
      case (null) { 0.1 };  // Small cost for initial task selection
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INHIBITION
  // ══════════════════════════════════════════════════════════════

  // Compute inhibition signal for prepotent response
  public func computeInhibition(
    prepotentStrength: Float,
    goalRelevance: Float,
    conflictSignal: Float,
    inhibitionStrength: Float
  ) : Float {
    // Strong inhibition when:
    // 1. Prepotent response is strong but not goal-relevant
    // 2. High conflict (multiple competing responses)
    let inhibitionNeed = prepotentStrength * (1.0 - goalRelevance) + conflictSignal * 0.3;
    _clamp(inhibitionStrength * inhibitionNeed, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // METACOGNITION
  // ══════════════════════════════════════════════════════════════

  // Update confidence based on recent performance
  public func updateConfidence(
    currentConfidence: Float,
    errorRate: Float,
    volatility: Float
  ) : Float {
    // Confidence decreases with errors and volatility
    let adjustment = -errorRate * 0.2 - volatility * 0.1;
    _clamp(currentConfidence + adjustment, 0.1, 0.95)
  };

  // Estimate uncertainty
  public func estimateUncertainty(
    conflictSignal: Float,
    volatility: Float,
    confidence: Float
  ) : Float {
    // Uncertainty increases with conflict and volatility, decreases with confidence
    _clamp(conflictSignal * 0.4 + volatility * 0.3 + (1.0 - confidence) * 0.3, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type PFCInput = {
    sensoryInput    : [Float];     // Current sensory state
    responseOptions : [Float];     // Response option activations
    reward          : Float;       // Reward received
    expectedReward  : Float;       // Expected reward
    emotionalInput  : Float;       // Emotional state
    socialInput     : Float;       // Social outcome
    context         : [Float];     // Current context
    newItem         : ?[Float];    // New item for WM
    itemPriority    : Float;       // Priority of new item
  };

  public func beatPrefrontal(
    state: PrefrontalState,
    input: PFCInput
  ) : PrefrontalState {
    
    // 1. Update dlPFC (working memory)
    var newWM = decayWorkingMemory(state.dlpfc.workingMemory);
    
    // Check if new item should be gated into WM
    switch (input.newItem) {
      case (?item) {
        if (shouldGate(state.dlpfc.gatingSignal, input.itemPriority)) {
          newWM := addToWorkingMemory(newWM, item, input.itemPriority, state.dlpfc.capacity);
        };
      };
      case (null) {};
    };
    
    // Update gating signal (based on reward)
    let newGating = if (input.reward > 0.0) {
      _clamp(state.dlpfc.gatingSignal + 0.1, 0.0, 1.0)
    } else {
      state.dlpfc.gatingSignal * 0.95
    };
    
    let newDLPFC : DLPFCState = {
      workingMemory = newWM;
      capacity = state.dlpfc.capacity;
      maintenanceSignal = state.dlpfc.maintenanceSignal;
      gatingSignal = newGating;
      activeGoal = state.dlpfc.activeGoal;
    };
    
    // 2. Update ACC (conflict and error monitoring)
    let responseProbs = softmax(input.responseOptions, 1.0);
    let newACC = updateACC(state.acc, responseProbs, input.reward, input.expectedReward);
    
    // 3. Update vmPFC (value computation)
    let newVMPFC = updateVMPFC(state.vmpfc, input.responseOptions, input.emotionalInput, input.socialInput);
    
    // 4. Update OFC (reward learning)
    let newOFC = updateOFC(state.ofc, input.reward, 0);  // Simplified: use idx 0
    
    // 5. Update goals
    let newGoals = Array.map<Goal, Goal>(state.goals, func(g) {
      updateGoal(g, input.sensoryInput, state.beatNum)
    });
    
    // Select active goal
    let newActiveGoal = selectActiveGoal(newGoals);
    
    // 6. Task switching
    let matchedTask = matchTaskSet(state.taskSets, input.context);
    let switchCost = computeSwitchCost(state.activeTaskSet, Option.get(matchedTask, 0), state.taskSets);
    
    // Only switch if benefit outweighs cost
    let newActiveTask = if (newACC.conflictSignal > switchCost) {
      matchedTask
    } else {
      state.activeTaskSet
    };
    
    // Update task set strengths
    let newTaskSets = Array.tabulate<TaskSet>(state.taskSets.size(), func(i) {
      let ts = state.taskSets[i];
      let isActive = switch (newActiveTask) {
        case (?idx) { idx == i };
        case (null) { false };
      };
      {
        id = ts.id;
        name = ts.name;
        rules = ts.rules;
        context = ts.context;
        strength = if (isActive) { _clamp(ts.strength + 0.05, 0.0, 1.0) } else { ts.strength * 0.99 };
        useCount = if (isActive) { ts.useCount + 1 } else { ts.useCount };
        lastUse = if (isActive) { state.beatNum } else { ts.lastUse };
      }
    });
    
    // 7. Inhibition
    let prepotent = if (input.responseOptions.size() > 0) {
      var maxR : Float = 0.0;
      for (r in input.responseOptions.vals()) { if (r > maxR) { maxR := r } };
      maxR
    } else { 0.0 };
    
    let goalRelevance = switch (newActiveGoal) {
      case (?_) { 0.8 };
      case (null) { 0.3 };
    };
    
    let inhibition = computeInhibition(prepotent, goalRelevance, newACC.conflictSignal, state.inhibitionStrength);
    
    // 8. Metacognition
    let avgError = if (state.acc.errorHistory.size() > 0) {
      var sum : Float = 0.0;
      for (e in state.acc.errorHistory.vals()) { sum += e };
      sum / Float.fromInt(state.acc.errorHistory.size())
    } else { 0.0 };
    
    let newConfidence = updateConfidence(state.confidence, avgError, newACC.volatility);
    let newUncertainty = estimateUncertainty(newACC.conflictSignal, newACC.volatility, newConfidence);
    
    // 9. Update inhibition strength based on successful inhibitions
    let newInhibitionStrength = if (newACC.conflictSignal > 0.5 and inhibition > 0.5) {
      _clamp(state.inhibitionStrength + 0.01, 0.0, 1.0)  // Strengthen with use
    } else {
      state.inhibitionStrength * 0.999  // Slow decay
    };
    
    {
      dlpfc = { newDLPFC with activeGoal = newActiveGoal };
      vmpfc = newVMPFC;
      acc = newACC;
      ofc = newOFC;
      goals = newGoals;
      goalStack = state.goalStack;
      taskSets = newTaskSets;
      activeTaskSet = newActiveTask;
      taskSwitchCost = switchCost;
      currentPlan = state.currentPlan;
      planHorizon = state.planHorizon;
      inhibitionStrength = newInhibitionStrength;
      impulsivity = 1.0 - newInhibitionStrength;
      confidence = newConfidence;
      uncertainty = newUncertainty;
      beatNum = state.beatNum + 1;
      lastUpdate = state.beatNum + 1;
      controlLR = state.controlLR;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ══════════════════════════════════════════════════════════════

  // Add new goal
  public func addGoal(
    state: PrefrontalState,
    representation: [Float],
    priority: Float,
    deadline: ?Nat
  ) : PrefrontalState {
    let newGoal : Goal = {
      id = state.goals.size();
      representation = representation;
      priority = priority;
      progress = 0.0;
      subgoals = [];
      deadline = deadline;
      active = true;
    };
    
    { state with goals = Array.append(state.goals, [newGoal]) }
  };

  // Get control signal (for downstream systems)
  public func getControlSignal(state: PrefrontalState) : Float {
    // Higher control when:
    // - High conflict
    // - Active goal with low progress
    // - High uncertainty
    
    let goalSignal = switch (state.dlpfc.activeGoal) {
      case (?id) {
        if (id < state.goals.size()) {
          (1.0 - state.goals[id].progress) * state.goals[id].priority
        } else { 0.0 }
      };
      case (null) { 0.0 };
    };
    
    _clamp(
      state.acc.controlDemand * 0.4 +
      goalSignal * 0.3 +
      state.uncertainty * 0.2 +
      (1.0 - state.confidence) * 0.1,
      0.0, 1.0
    )
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initPrefrontal() : PrefrontalState {
    {
      dlpfc = {
        workingMemory = [];
        capacity = WM_CAPACITY;
        maintenanceSignal = 0.5;
        gatingSignal = 0.5;
        activeGoal = null;
      };
      vmpfc = {
        valueEstimates = [];
        emotionalState = 0.0;
        riskTolerance = 0.5;
        somaticMarker = 0.0;
        socialValue = 0.0;
      };
      acc = {
        conflictSignal = 0.0;
        errorSignal = 0.0;
        effortSignal = 0.0;
        volatility = 0.0;
        controlDemand = 0.0;
        errorHistory = [];
      };
      ofc = {
        expectedReward = 0.0;
        rewardPredError = 0.0;
        outcomeHistory = [];
        reversalIndex = 0.5;
        stimulusValues = [];
      };
      goals = [];
      goalStack = [];
      taskSets = [];
      activeTaskSet = null;
      taskSwitchCost = 0.0;
      currentPlan = [];
      planHorizon = 5;
      inhibitionStrength = 0.5;
      impulsivity = 0.5;
      confidence = 0.5;
      uncertainty = 0.5;
      beatNum = 0;
      lastUpdate = 0;
      controlLR = 0.1;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type PFCSummary = {
    wmSlotsFilled   : Nat;
    conflictLevel   : Float;
    errorSignal     : Float;
    controlDemand   : Float;
    activeGoalCount : Nat;
    confidence      : Float;
    uncertainty     : Float;
    inhibitionStrength: Float;
    emotionalState  : Float;
    expectedReward  : Float;
  };

  public func summary(state: PrefrontalState) : PFCSummary {
    var activeGoals : Nat = 0;
    for (g in state.goals.vals()) {
      if (g.active) { activeGoals += 1 };
    };
    
    {
      wmSlotsFilled = state.dlpfc.workingMemory.size();
      conflictLevel = state.acc.conflictSignal;
      errorSignal = state.acc.errorSignal;
      controlDemand = state.acc.controlDemand;
      activeGoalCount = activeGoals;
      confidence = state.confidence;
      uncertainty = state.uncertainty;
      inhibitionStrength = state.inhibitionStrength;
      emotionalState = state.vmpfc.emotionalState;
      expectedReward = state.ofc.expectedReward;
    }
  };

}
