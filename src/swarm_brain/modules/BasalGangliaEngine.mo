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
// NEUROEMERGENCE CORE — BASAL GANGLIA ENGINE
// Action selection, habit formation, and reinforcement learning
// 
// Architecture mirrors biological basal ganglia:
// - Striatum: D1 (Go) and D2 (NoGo) pathways
// - Substantia Nigra: Dopamine reward prediction error
// - Globus Pallidus: Inhibitory gating
// - Subthalamic Nucleus: Hyperdirect pathway (emergency stop)
// 
// Mathematical Framework:
// - Actor-Critic TD Learning: δ = r + γV(s') - V(s)
// - Go/NoGo competition: P(a) = softmax(Q_go - Q_nogo)
// - Habit formation: w_habit ← w_habit + α·(repetition - threshold)
// 
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ══════════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════════

  // Single action representation
  public type Action = {
    id           : Nat;
    name         : Text;
    goStrength   : Float;       // D1 pathway strength [0, 1]
    nogoStrength : Float;       // D2 pathway strength [0, 1]
    value        : Float;       // Q-value estimate
    habitStrength: Float;       // How habitual [0, 1]
    recency      : Nat;         // Beats since last execution
    count        : Nat;         // Total execution count
    avgReward    : Float;       // Running average reward
  };

  // Striatum - main input structure
  public type Striatum = {
    d1Neurons    : [Float];     // Go pathway activations
    d2Neurons    : [Float];     // NoGo pathway activations
    cholinergic  : Float;       // Acetylcholine modulation (pauses during learning)
    dopamine     : Float;       // Tonic dopamine level
    matrixPatch  : Float;       // Matrix vs patch ratio (goal-directed vs habitual)
  };

  // Substantia Nigra Pars Compacta (SNc) - dopamine source
  public type SubstantiaNigra = {
    dopamineTonic : Float;      // Baseline dopamine [0, 1]
    dopaminePhasic: Float;      // RPE-driven burst/dip [-1, 1]
    rpe           : Float;      // Reward prediction error
    valueEstimate : Float;      // Critic's V(s)
    rewardHistory : [Float];    // Recent rewards for averaging
  };

  // Globus Pallidus - inhibitory gating
  public type GlobusPallidus = {
    gpInternal   : [Float];     // GPi: final output (inhibits thalamus)
    gpExternal   : [Float];     // GPe: indirect pathway relay
    gatingThreshold: Float;     // Action release threshold
    inhibitionStrength: Float;  // Default inhibition level
  };

  // Subthalamic Nucleus - emergency brake
  public type SubthalamicNucleus = {
    activation   : Float;       // STN activity [0, 1]
    hyperdirect  : Float;       // Quick cortex → STN → GPi pathway
    conflictSignal: Float;      // High when multiple actions compete
    urgencySignal : Float;      // External urgency input
  };

  // Full basal ganglia state
  public type BasalGangliaState = {
    // Core structures
    striatum     : Striatum;
    snc          : SubstantiaNigra;
    pallidus     : GlobusPallidus;
    stn          : SubthalamicNucleus;
    
    // Action space
    actions      : [Action];
    selectedAction: Nat;
    actionProbs  : [Float];
    
    // Learning parameters
    learningRate : Float;       // α for TD learning
    discountFactor: Float;      // γ
    habitThreshold: Float;      // Repetitions to become habit
    explorationRate: Float;     // ε for exploration
    
    // Mode
    isHabitMode  : Bool;        // True = habitual, False = goal-directed
    conflictLevel: Float;       // Action selection conflict
    
    // Temporal
    beatNum      : Nat;
    lastReward   : Float;
    totalReward  : Float;
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let EPSILON : Float = 1e-10;
  let MAX_ACTIONS : Nat = 20;
  let HISTORY_SIZE : Nat = 50;

  // Default parameters
  let DEFAULT_LR : Float = 0.1;
  let DEFAULT_GAMMA : Float = 0.95;
  let DEFAULT_HABIT_THRESHOLD : Float = 20.0;
  let DEFAULT_EXPLORATION : Float = 0.1;
  let DEFAULT_TONIC_DA : Float = 0.5;

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

  func _min(a: Float, b: Float) : Float {
    if (a < b) { a } else { b }
  };

  // Softmax for action selection
  func softmax(values: [Float], temperature: Float) : [Float] {
    let n = values.size();
    if (n == 0) { return [] };
    
    var maxVal : Float = values[0];
    for (v in values.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    
    var sumExp : Float = 0.0;
    let exps = Array.tabulate<Float>(n, func(i) {
      let e = Float.exp((values[i] - maxVal) / (temperature + EPSILON));
      sumExp += e;
      e
    });
    
    Array.map<Float, Float>(exps, func(e) { e / (sumExp + EPSILON) })
  };

  // ══════════════════════════════════════════════════════════════
  // REWARD PREDICTION ERROR (Dopamine signal)
  // ══════════════════════════════════════════════════════════════

  // TD Error: δ = r + γV(s') - V(s)
  // This is the core learning signal from SNc
  public func computeRPE(
    reward: Float, 
    nextValue: Float, 
    currentValue: Float, 
    gamma: Float
  ) : Float {
    reward + gamma * nextValue - currentValue
  };

  // Update dopamine based on RPE
  // Positive RPE → phasic burst, Negative RPE → phasic dip
  public func updateDopamine(snc: SubstantiaNigra, rpe: Float) : SubstantiaNigra {
    // Phasic: directly proportional to RPE
    let phasic = _clamp(rpe, -1.0, 1.0);
    
    // Tonic: slowly drifts based on average rewards
    let avgReward = if (snc.rewardHistory.size() > 0) {
      var sum : Float = 0.0;
      for (r in snc.rewardHistory.vals()) { sum += r };
      sum / Float.fromInt(snc.rewardHistory.size())
    } else { 0.0 };
    
    let newTonic = _clamp(
      snc.dopamineTonic * 0.99 + avgReward * 0.01,
      0.2, 0.8
    );
    
    {
      dopamineTonic = newTonic;
      dopaminePhasic = phasic;
      rpe = rpe;
      valueEstimate = snc.valueEstimate;
      rewardHistory = snc.rewardHistory;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // GO/NOGO PATHWAY DYNAMICS
  // ══════════════════════════════════════════════════════════════

  // Update striatal D1 (Go) pathway
  // D1 strengthened by positive dopamine
  public func updateD1(
    d1: Float, actionValue: Float, dopamine: Float, lr: Float
  ) : Float {
    let delta = if (dopamine > 0.5) {
      // Positive DA → strengthen Go
      lr * actionValue * (dopamine - 0.5) * 2.0
    } else { 0.0 };
    
    _clamp(d1 + delta, 0.0, 1.0)
  };

  // Update striatal D2 (NoGo) pathway
  // D2 strengthened by negative dopamine (dips)
  public func updateD2(
    d2: Float, actionValue: Float, dopamine: Float, lr: Float
  ) : Float {
    let delta = if (dopamine < 0.5) {
      // Negative DA → strengthen NoGo
      lr * actionValue * (0.5 - dopamine) * 2.0
    } else { 0.0 };
    
    _clamp(d2 + delta, 0.0, 1.0)
  };

  // Compute Go-NoGo competition strength for an action
  public func goNogoStrength(go: Float, nogo: Float) : Float {
    go - nogo  // Can be negative (strong inhibition)
  };

  // ══════════════════════════════════════════════════════════════
  // HABIT FORMATION
  // ══════════════════════════════════════════════════════════════

  // Update habit strength based on repetition
  // Actions become habitual through consistent repetition
  public func updateHabitStrength(
    action: Action, wasSelected: Bool, threshold: Float
  ) : Float {
    if (wasSelected) {
      // Strengthen habit with each execution
      let increment = 1.0 / threshold;
      _clamp(action.habitStrength + increment, 0.0, 1.0)
    } else {
      // Slow decay when not used
      _clamp(action.habitStrength * 0.995, 0.0, 1.0)
    }
  };

  // Determine if system should be in habit mode
  // Matrix-dominant = goal-directed, Patch-dominant = habitual
  public func shouldBeHabitual(striatum: Striatum, uncertainty: Float) : Bool {
    // High uncertainty → goal-directed (matrix)
    // Low uncertainty + high patch → habitual
    striatum.matrixPatch < 0.5 and uncertainty < 0.3
  };

  // ══════════════════════════════════════════════════════════════
  // SUBTHALAMIC NUCLEUS (Emergency Stop)
  // ══════════════════════════════════════════════════════════════

  // STN activates during conflict to pause action selection
  public func updateSTN(
    stn: SubthalamicNucleus, 
    actionProbs: [Float], 
    corticalUrgency: Float
  ) : SubthalamicNucleus {
    // Compute conflict as entropy of action distribution
    var entropy : Float = 0.0;
    for (p in actionProbs.vals()) {
      if (p > EPSILON) {
        entropy -= p * Float.log(p) / Float.log(2.0);
      };
    };
    let maxEntropy = Float.log(Float.fromInt(actionProbs.size())) / Float.log(2.0);
    let normalizedConflict = if (maxEntropy > EPSILON) {
      entropy / maxEntropy
    } else { 0.0 };
    
    // STN activation: high conflict or urgent input
    let activation = _clamp(
      normalizedConflict * 0.7 + corticalUrgency * 0.3,
      0.0, 1.0
    );
    
    {
      activation = activation;
      hyperdirect = corticalUrgency;
      conflictSignal = normalizedConflict;
      urgencySignal = corticalUrgency;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // GLOBUS PALLIDUS (Gating)
  // ══════════════════════════════════════════════════════════════

  // GPi computes final inhibition of thalamus/action
  // Lower GPi = action released, Higher GPi = action blocked
  public func computeGPi(
    directPathway: Float,    // From striatum D1 (inhibits GPi)
    indirectPathway: Float,  // From GPe (excites GPi)
    stnInput: Float          // From STN (excites GPi)
  ) : Float {
    // GPi = baseline + indirect + STN - direct
    let gpi = 0.5 - directPathway * 0.4 + indirectPathway * 0.3 + stnInput * 0.3;
    _clamp(gpi, 0.0, 1.0)
  };

  // Action is released when GPi falls below threshold
  public func actionReleased(gpi: Float, threshold: Float) : Bool {
    gpi < threshold
  };

  // ══════════════════════════════════════════════════════════════
  // ACTION VALUE LEARNING
  // ══════════════════════════════════════════════════════════════

  // Update action Q-value with TD learning
  public func updateActionValue(
    action: Action, 
    reward: Float, 
    rpe: Float, 
    lr: Float
  ) : Action {
    // Q-learning update
    let newValue = action.value + lr * rpe;
    
    // Update average reward
    let newAvgReward = action.avgReward * 0.9 + reward * 0.1;
    
    {
      id = action.id;
      name = action.name;
      goStrength = action.goStrength;
      nogoStrength = action.nogoStrength;
      value = _clamp(newValue, -1.0, 1.0);
      habitStrength = action.habitStrength;
      recency = action.recency;
      count = action.count;
      avgReward = newAvgReward;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // ACTION SELECTION
  // ══════════════════════════════════════════════════════════════

  // Compute action probabilities based on Go-NoGo competition
  public func computeActionProbabilities(
    actions: [Action], 
    temperature: Float,
    dopamineTonic: Float,
    isHabitual: Bool
  ) : [Float] {
    let n = actions.size();
    if (n == 0) { return [] };
    
    // Compute effective value for each action
    let values = Array.tabulate<Float>(n, func(i) {
      let action = actions[i];
      
      // Go-NoGo competition
      let goNogo = goNogoStrength(action.goStrength, action.nogoStrength);
      
      // Combine Q-value with Go-NoGo, weighted by mode
      if (isHabitual) {
        // Habit mode: weight by habit strength
        goNogo + action.habitStrength * 0.5
      } else {
        // Goal-directed: weight by Q-value
        goNogo + action.value * dopamineTonic
      }
    });
    
    softmax(values, temperature)
  };

  // Select action based on probabilities (returns index)
  // Uses deterministic argmax with small epsilon exploration
  public func selectAction(
    probs: [Float], 
    exploration: Float, 
    beatNum: Nat
  ) : Nat {
    let n = probs.size();
    if (n == 0) { return 0 };
    
    // Pseudo-random for exploration (deterministic based on beat)
    let exploreCheck = Float.fromInt(beatNum * 17 % 100) / 100.0;
    
    if (exploreCheck < exploration) {
      // Explore: pseudo-random action
      beatNum % n
    } else {
      // Exploit: argmax
      var maxIdx : Nat = 0;
      var maxProb : Float = probs[0];
      var i : Nat = 1;
      while (i < n) {
        if (probs[i] > maxProb) {
          maxProb := probs[i];
          maxIdx := i;
        };
        i += 1;
      };
      maxIdx
    }
  };

  // ══════════════════════════════════════════════════════════════
  // CRITIC VALUE ESTIMATE
  // ══════════════════════════════════════════════════════════════

  // Update critic's state value estimate
  public func updateCriticValue(
    currentValue: Float, 
    rpe: Float, 
    lr: Float
  ) : Float {
    _clamp(currentValue + lr * rpe, -1.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type BGInput = {
    stateFeatures  : [Float];      // Current state representation
    reward         : Float;        // Reward received
    corticalInput  : [Float];      // Cortical drive for each action
    urgency        : Float;        // External urgency signal
    uncertainty    : Float;        // State uncertainty
    nextStateValue : Float;        // V(s') for TD
  };

  public func beatBasalGanglia(
    state: BasalGangliaState, 
    input: BGInput
  ) : BasalGangliaState {
    // 1. Compute RPE (dopamine signal)
    let rpe = computeRPE(
      input.reward,
      input.nextStateValue,
      state.snc.valueEstimate,
      state.discountFactor
    );
    
    // 2. Update dopamine system
    let newHistory = if (state.snc.rewardHistory.size() >= HISTORY_SIZE) {
      let tail = Array.tabulate<Float>(HISTORY_SIZE - 1, func(i) { 
        state.snc.rewardHistory[i + 1] 
      });
      Array.append<Float>(tail, [input.reward])
    } else {
      Array.append<Float>(state.snc.rewardHistory, [input.reward])
    };
    
    let sncWithHistory : SubstantiaNigra = {
      dopamineTonic = state.snc.dopamineTonic;
      dopaminePhasic = state.snc.dopaminePhasic;
      rpe = state.snc.rpe;
      valueEstimate = state.snc.valueEstimate;
      rewardHistory = newHistory;
    };
    
    var newSnc = updateDopamine(sncWithHistory, rpe);
    let criticValue = updateCriticValue(state.snc.valueEstimate, rpe, state.learningRate);
    newSnc := {
      dopamineTonic = newSnc.dopamineTonic;
      dopaminePhasic = newSnc.dopaminePhasic;
      rpe = rpe;
      valueEstimate = criticValue;
      rewardHistory = newSnc.rewardHistory;
    };
    
    // 3. Update actions with learning
    let totalDopamine = newSnc.dopamineTonic + newSnc.dopaminePhasic * 0.5;
    
    var newActions = Array.thaw<Action>(state.actions);
    var i : Nat = 0;
    while (i < state.actions.size()) {
      let action = state.actions[i];
      let wasSelected = i == state.selectedAction;
      
      // Update Go/NoGo pathways
      let newGo = if (wasSelected) {
        updateD1(action.goStrength, action.value, totalDopamine, state.learningRate)
      } else { action.goStrength };
      
      let newNogo = if (wasSelected) {
        updateD2(action.nogoStrength, action.value, totalDopamine, state.learningRate)
      } else { action.nogoStrength };
      
      // Update value if selected
      let updatedAction = if (wasSelected) {
        updateActionValue(action, input.reward, rpe, state.learningRate)
      } else { action };
      
      // Update habit strength
      let newHabit = updateHabitStrength(updatedAction, wasSelected, state.habitThreshold);
      
      // Update recency and count
      let newRecency = if (wasSelected) { 0 } else { action.recency + 1 };
      let newCount = if (wasSelected) { action.count + 1 } else { action.count };
      
      newActions[i] := {
        id = updatedAction.id;
        name = updatedAction.name;
        goStrength = newGo;
        nogoStrength = newNogo;
        value = updatedAction.value;
        habitStrength = newHabit;
        recency = newRecency;
        count = newCount;
        avgReward = updatedAction.avgReward;
      };
      
      i += 1;
    };
    
    // 4. Update striatum
    let newD1 = Array.tabulate<Float>(state.actions.size(), func(j) {
      newActions[j].goStrength
    });
    let newD2 = Array.tabulate<Float>(state.actions.size(), func(j) {
      newActions[j].nogoStrength
    });
    
    // Matrix/patch ratio shifts based on uncertainty
    let newMatrixPatch = _clamp(
      state.striatum.matrixPatch + (input.uncertainty - 0.5) * 0.05,
      0.0, 1.0
    );
    
    let newStriatum : Striatum = {
      d1Neurons = newD1;
      d2Neurons = newD2;
      cholinergic = if (rpe != 0.0) { 0.3 } else { 0.7 };  // Pauses during learning
      dopamine = totalDopamine;
      matrixPatch = newMatrixPatch;
    };
    
    // 5. Determine habit vs goal-directed mode
    let isHabitual = shouldBeHabitual(newStriatum, input.uncertainty);
    
    // 6. Compute action probabilities
    let temperature = 0.5 + input.uncertainty * 0.5;  // Higher temp with uncertainty
    let probs = computeActionProbabilities(
      Array.freeze(newActions),
      temperature,
      newSnc.dopamineTonic,
      isHabitual
    );
    
    // 7. Update STN (conflict detection)
    let newSTN = updateSTN(state.stn, probs, input.urgency);
    
    // 8. Update GPi for each action
    let newGPi = Array.tabulate<Float>(state.actions.size(), func(j) {
      computeGPi(
        newD1[j],
        newD2[j],
        newSTN.activation
      )
    });
    
    let newPallidus : GlobusPallidus = {
      gpInternal = newGPi;
      gpExternal = state.pallidus.gpExternal;  // Simplified
      gatingThreshold = state.pallidus.gatingThreshold;
      inhibitionStrength = state.pallidus.inhibitionStrength;
    };
    
    // 9. Select action (may be blocked by STN/GPi)
    let selectedIdx = if (newSTN.activation > 0.8) {
      // STN emergency stop - maintain current action
      state.selectedAction
    } else {
      selectAction(probs, state.explorationRate, state.beatNum)
    };
    
    // 10. Compute conflict level
    let conflict = newSTN.conflictSignal;
    
    {
      striatum = newStriatum;
      snc = newSnc;
      pallidus = newPallidus;
      stn = newSTN;
      actions = Array.freeze(newActions);
      selectedAction = selectedIdx;
      actionProbs = probs;
      learningRate = state.learningRate;
      discountFactor = state.discountFactor;
      habitThreshold = state.habitThreshold;
      explorationRate = state.explorationRate;
      isHabitMode = isHabitual;
      conflictLevel = conflict;
      beatNum = state.beatNum + 1;
      lastReward = input.reward;
      totalReward = state.totalReward + input.reward;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ══════════════════════════════════════════════════════════════

  // Get most habitual action
  public func getMostHabitual(state: BasalGangliaState) : ?Action {
    if (state.actions.size() == 0) { return null };
    var maxHabit : Float = 0.0;
    var maxIdx : Nat = 0;
    var i : Nat = 0;
    for (a in state.actions.vals()) {
      if (a.habitStrength > maxHabit) {
        maxHabit := a.habitStrength;
        maxIdx := i;
      };
      i += 1;
    };
    ?state.actions[maxIdx]
  };

  // Get highest value action
  public func getBestAction(state: BasalGangliaState) : ?Action {
    if (state.actions.size() == 0) { return null };
    var maxVal : Float = -10.0;
    var maxIdx : Nat = 0;
    var i : Nat = 0;
    for (a in state.actions.vals()) {
      if (a.value > maxVal) {
        maxVal := a.value;
        maxIdx := i;
      };
      i += 1;
    };
    ?state.actions[maxIdx]
  };

  // Create new action
  public func createAction(id: Nat, name: Text) : Action {
    {
      id = id;
      name = name;
      goStrength = 0.5;
      nogoStrength = 0.5;
      value = 0.0;
      habitStrength = 0.0;
      recency = 0;
      count = 0;
      avgReward = 0.0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initBasalGanglia(nActions: Nat) : BasalGangliaState {
    let actions = Array.tabulate<Action>(nActions, func(i) {
      createAction(i, "action_" # Nat.toText(i))
    });
    
    let zeros = Array.tabulate<Float>(nActions, func(_) { 0.5 });
    
    {
      striatum = {
        d1Neurons = zeros;
        d2Neurons = zeros;
        cholinergic = 0.7;
        dopamine = DEFAULT_TONIC_DA;
        matrixPatch = 0.5;
      };
      snc = {
        dopamineTonic = DEFAULT_TONIC_DA;
        dopaminePhasic = 0.0;
        rpe = 0.0;
        valueEstimate = 0.0;
        rewardHistory = [];
      };
      pallidus = {
        gpInternal = zeros;
        gpExternal = zeros;
        gatingThreshold = 0.5;
        inhibitionStrength = 0.5;
      };
      stn = {
        activation = 0.0;
        hyperdirect = 0.0;
        conflictSignal = 0.0;
        urgencySignal = 0.0;
      };
      actions = actions;
      selectedAction = 0;
      actionProbs = Array.tabulate<Float>(nActions, func(_) { 1.0 / Float.fromInt(nActions) });
      learningRate = DEFAULT_LR;
      discountFactor = DEFAULT_GAMMA;
      habitThreshold = DEFAULT_HABIT_THRESHOLD;
      explorationRate = DEFAULT_EXPLORATION;
      isHabitMode = false;
      conflictLevel = 0.0;
      beatNum = 0;
      lastReward = 0.0;
      totalReward = 0.0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type BGSummary = {
    selectedAction : Nat;
    actionValue    : Float;
    dopamineTonic  : Float;
    dopaminePhasic : Float;
    rpe            : Float;
    isHabitMode    : Bool;
    conflictLevel  : Float;
    stnActivation  : Float;
    totalReward    : Float;
    topActionName  : Text;
  };

  public func summary(state: BasalGangliaState) : BGSummary {
    let selectedAct = if (state.selectedAction < state.actions.size()) {
      state.actions[state.selectedAction]
    } else {
      createAction(0, "none")
    };
    
    {
      selectedAction = state.selectedAction;
      actionValue = selectedAct.value;
      dopamineTonic = state.snc.dopamineTonic;
      dopaminePhasic = state.snc.dopaminePhasic;
      rpe = state.snc.rpe;
      isHabitMode = state.isHabitMode;
      conflictLevel = state.conflictLevel;
      stnActivation = state.stn.activation;
      totalReward = state.totalReward;
      topActionName = selectedAct.name;
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
  //  R E A L - T I M E   S Y S T E M S   M A T H E M A T I C S
  //
  //  Enterprise-Level Real-Time Processing and Control
  //  Full HIM/HER 60Hz Synchronization Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // CONTROL SYSTEMS
  // ─────────────────────────────────────────────────────────────────────────────

  /// PID controller output
  public func controlPID(
    error : Float,
    integral : Float,
    derivative : Float,
    kP : Float,
    kI : Float,
    kD : Float
  ) : Float {
    kP * error + kI * integral + kD * derivative
  };

  /// PID integral update with anti-windup
  public func controlIntegralUpdate(
    integral : Float,
    error : Float,
    dt : Float,
    maxIntegral : Float
  ) : Float {
    let newIntegral = integral + error * dt;
    if (newIntegral > maxIntegral) { maxIntegral }
    else if (newIntegral < -maxIntegral) { -maxIntegral }
    else { newIntegral }
  };

  /// PID derivative calculation with filtering
  public func controlDerivative(
    error : Float,
    prevError : Float,
    prevDerivative : Float,
    dt : Float,
    filterCoeff : Float
  ) : Float {
    let rawDerivative = (error - prevError) / dt;
    filterCoeff * rawDerivative + (1.0 - filterCoeff) * prevDerivative
  };

  /// State space model: x(k+1) = Ax(k) + Bu(k)
  public func controlStateUpdate(
    state : Float,
    input : Float,
    a : Float,
    b : Float
  ) : Float {
    a * state + b * input
  };

  /// Observer state estimation
  public func controlObserver(
    estimatedState : Float,
    measurement : Float,
    predicted : Float,
    observerGain : Float
  ) : Float {
    estimatedState + observerGain * (measurement - predicted)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SCHEDULING AND TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate monotonic priority
  public func schedulingRMPriority(period : Float) : Float {
    1.0 / period
  };

  /// Deadline miss probability (simplified)
  public func schedulingDeadlineMissProb(
    wcet : Float,
    period : Float,
    utilization : Float
  ) : Float {
    let slack = period - wcet;
    if (slack <= 0.0) { 1.0 }
    else { utilization * wcet / slack }
  };

  /// Response time analysis
  public func schedulingResponseTime(
    wcet : Float,
    period : Float,
    higherPriorityLoad : Float
  ) : Float {
    wcet / (1.0 - higherPriorityLoad)
  };

  /// Jitter calculation
  public func schedulingJitter(
    timestamps : [Float]
  ) : Float {
    if (timestamps.size() < 2) { return 0.0 };
    var sumDiff : Float = 0.0;
    var prevDiff : Float = timestamps[1] - timestamps[0];
    var maxJitter : Float = 0.0;
    var i = 2;
    while (i < timestamps.size()) {
      let diff = timestamps[i] - timestamps[i-1];
      let jitter = Float.abs(diff - prevDiff);
      if (jitter > maxJitter) { maxJitter := jitter };
      prevDiff := diff;
      i += 1;
    };
    maxJitter
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SIGNAL PROCESSING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Low-pass filter (exponential moving average)
  public func signalLowPass(
    current : Float,
    newSample : Float,
    alpha : Float
  ) : Float {
    alpha * newSample + (1.0 - alpha) * current
  };

  /// High-pass filter
  public func signalHighPass(
    current : Float,
    newSample : Float,
    prevSample : Float,
    alpha : Float
  ) : Float {
    alpha * (current + newSample - prevSample)
  };

  /// Band-pass filter (cascade)
  public func signalBandPass(
    value : Float,
    lowState : Float,
    highState : Float,
    alphaLow : Float,
    alphaHigh : Float
  ) : (Float, Float, Float) {
    let low = signalLowPass(lowState, value, alphaLow);
    let high = alphaHigh * (highState + value - lowState);
    (high, low, high)
  };

  /// Median filter (3-sample)
  public func signalMedian3(a : Float, b : Float, c : Float) : Float {
    if ((a <= b and b <= c) or (c <= b and b <= a)) { b }
    else if ((b <= a and a <= c) or (c <= a and a <= b)) { a }
    else { c }
  };

  /// Signal power
  public func signalPower(samples : [Float]) : Float {
    if (samples.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < samples.size()) {
      sum += samples[i] * samples[i];
      i += 1;
    };
    sum / Float.fromInt(samples.size())
  };

  /// Signal-to-noise ratio
  public func signalSNR(signalPower : Float, noisePower : Float) : Float {
    if (noisePower < 0.0001) { 100.0 }
    else { 10.0 * Float.log(signalPower / noisePower) / Float.log(10.0) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SYNCHRONIZATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phase-locked loop error
  public func syncPLLError(
    referencePhase : Float,
    outputPhase : Float
  ) : Float {
    let diff = referencePhase - outputPhase;
    Float.sin(diff)  // Sinusoidal phase detector
  };

  /// PLL VCO output
  public func syncVCO(
    centerFreq : Float,
    controlSignal : Float,
    gain : Float,
    time : Float
  ) : Float {
    Float.sin(2.0 * 3.14159265 * (centerFreq + gain * controlSignal) * time)
  };

  /// Clock drift compensation
  public func syncClockDrift(
    localTime : Float,
    referenceTime : Float,
    driftRate : Float
  ) : Float {
    localTime + (referenceTime - localTime) * driftRate
  };

  /// Frame synchronization correlation
  public func syncFrameCorrelation(
    received : [Float],
    syncPattern : [Float]
  ) : Float {
    let n = if (received.size() < syncPattern.size()) received.size() else syncPattern.size();
    if (n == 0) { return 0.0 };
    var corr : Float = 0.0;
    var i = 0;
    while (i < n) {
      corr += received[i] * syncPattern[i];
      i += 1;
    };
    corr
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BUFFER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Buffer fill level
  public func bufferFillLevel(count : Nat, capacity : Nat) : Float {
    if (capacity == 0) { 0.0 }
    else { Float.fromInt(count) / Float.fromInt(capacity) }
  };

  /// Buffer underrun risk
  public func bufferUnderrunRisk(
    fillLevel : Float,
    drainRate : Float,
    fillRate : Float
  ) : Float {
    if (fillRate >= drainRate) { 0.0 }
    else { (drainRate - fillRate) / drainRate * (1.0 - fillLevel) }
  };

  /// Adaptive buffer size
  public func bufferAdaptiveSize(
    currentSize : Nat,
    avgLatency : Float,
    targetLatency : Float,
    stepSize : Nat
  ) : Nat {
    if (avgLatency > targetLatency * 1.1) {
      currentSize + stepSize
    } else if (avgLatency < targetLatency * 0.9 and currentSize > stepSize) {
      currentSize - stepSize
    } else {
      currentSize
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // 60 HZ FRAME TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Frame time at 60 Hz
  public let FRAME_TIME_60HZ : Float = 1.0 / 60.0;

  /// Frame number from time
  public func frameNumberFromTime(time : Float) : Nat {
    Int.abs(Float.toInt(time / FRAME_TIME_60HZ))
  };

  /// Time within frame
  public func framePhase(time : Float) : Float {
    let frameNum = Float.fromInt(frameNumberFromTime(time));
    (time - frameNum * FRAME_TIME_60HZ) / FRAME_TIME_60HZ
  };

  /// Frame deadline remaining
  public func frameDeadlineRemaining(currentTime : Float, frameStart : Float) : Float {
    let deadline = frameStart + FRAME_TIME_60HZ;
    deadline - currentTime
  };

  /// Frame skip detection
  public func frameSkipDetected(prevFrame : Nat, currentFrame : Nat) : Bool {
    currentFrame > prevFrame + 1
  };

}
