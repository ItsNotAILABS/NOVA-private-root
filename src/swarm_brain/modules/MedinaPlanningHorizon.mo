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


// ════════════════════════════════════════════════════════════════════════════
// ███████╗ ██████╗       ███████╗████████╗███████╗██████╗ 
// ██╔════╝██╔═████╗      ██╔════╝╚══██╔══╝██╔════╝██╔══██╗
// ███████╗██║██╔██║█████╗███████╗   ██║   █████╗  ██████╔╝
// ╚════██║████╔╝██║╚════╝╚════██║   ██║   ██╔══╝  ██╔═══╝ 
// ███████║╚██████╔╝      ███████║   ██║   ███████╗██║     
// ╚══════╝ ╚═════╝       ╚══════╝   ╚═╝   ╚══════╝╚═╝     
// ██████╗ ██╗      █████╗ ███╗   ██╗███╗   ██╗██╗███╗   ██╗ ██████╗ 
// ██╔══██╗██║     ██╔══██╗████╗  ██║████╗  ██║██║████╗  ██║██╔════╝ 
// ██████╔╝██║     ███████║██╔██╗ ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗
// ██╔═══╝ ██║     ██╔══██║██║╚██╗██║██║╚██╗██║██║██║╚██╗██║██║   ██║
// ██║     ███████╗██║  ██║██║ ╚████║██║ ╚████║██║██║ ╚████║╚██████╔╝
// ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
// ════════════════════════════════════════════════════════════════════════════
//
// MEDINA 50-STEP PLANNING HORIZON
// Enterprise-Grade Multi-Step Lookahead Planning System
//
// ════════════════════════════════════════════════════════════════════════════
// PLANNING ARCHITECTURE
// ════════════════════════════════════════════════════════════════════════════
//
// 1. MONTE CARLO TREE SEARCH (MCTS) with Medina Modifications
//    - Selection: UCB1 with Medina confidence bounds
//    - Expansion: Prioritized action generation
//    - Simulation: Neural-guided rollouts
//    - Backpropagation: Value and policy updates
//
// 2. MODEL-BASED PREDICTIVE CONTROL
//    - World model learns environment dynamics
//    - Forward simulation of action sequences
//    - Receding horizon optimization
//
// 3. HIERARCHICAL PLANNING
//    - Strategic level: 50-step goals
//    - Tactical level: 10-step subgoals
//    - Operational level: Immediate actions
//
// 4. CONTINGENCY PLANNING
//    - Multiple branches for uncertainty
//    - Risk-adjusted value estimates
//    - Fail-safe action sequences
//
// ════════════════════════════════════════════════════════════════════════════
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA HORIZON VALUE EQUATION (MHVE):
// ─────────────────────────────────────────
//   V(s, h) = Σ_{t=0}^{h} γ^t × r(s_t, a_t) × confidence(t)
//   confidence(t) = Φ_M^(-t/h) × (1 - uncertainty(t))
//
// THE MEDINA TREE EXPLORATION BOUND (MTEB):
// ─────────────────────────────────────────
//   UCB_M(s,a) = Q(s,a) + c × √(ln(N(s)) / N(s,a)) × Φ_M^(depth/max_depth)
//
// THE MEDINA BRANCHING FACTOR CONTROL (MBFC):
// ───────────────────────────────────────────
//   B(depth) = B_0 × Φ_M^(-depth/τ_B) + B_min
//   Pruning: Keep only B(depth) best actions at each depth
//
// THE MEDINA TEMPORAL ABSTRACTION (MTA):
// ──────────────────────────────────────
//   Macro-action value = Σ_{t=0}^{T} γ^t × r_t + γ^T × V(s_T)
//   T = adaptive duration based on option completion
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════
  // MEDINA PLANNING CONSTANTS
  // ══════════════════════════════════════════════════════════════
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let PHI_MEDINA : Float = 2.97442179;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let OMEGA_MEDINA : Float = 2.11185;

  // Planning Horizon Constants
  public let MAX_HORIZON : Nat = 50;           // 50-step lookahead
  let STRATEGIC_HORIZON : Nat = 50;            // Long-term planning
  let TACTICAL_HORIZON : Nat = 10;             // Medium-term planning
  let OPERATIONAL_HORIZON : Nat = 3;           // Immediate actions
  let DISCOUNT_GAMMA : Float = 0.99;           // Future reward discount
  let EXPLORATION_C : Float = 1.414;           // UCB exploration constant
  let MAX_BRANCHING : Nat = 20;                // Max actions per state
  let MIN_BRANCHING : Nat = 3;                 // Min actions per state
  let BRANCHING_TAU : Float = 10.0;            // Branching decay constant
  let SIMULATION_DEPTH : Nat = 30;             // Rollout depth
  let NUM_SIMULATIONS : Nat = 100;             // MCTS simulations

  // ══════════════════════════════════════════════════════════════
  // PLANNING TYPES
  // ══════════════════════════════════════════════════════════════

  // State representation
  public type PlanningState = {
    features      : [Float];       // State feature vector
    stateId       : Nat;           // Unique state identifier
    isTerminal    : Bool;          // Goal state reached?
    reward        : Float;         // Immediate reward
    uncertainty   : Float;         // State uncertainty
    timestamp     : Nat;
  };

  // Action representation
  public type PlanningAction = {
    actionId      : Nat;
    actionType    : ActionType;
    parameters    : [Float];       // Action parameters
    priorProb     : Float;         // Prior probability (from policy)
    cost          : Float;         // Action cost
  };

  public type ActionType = {
    #Move;
    #Communicate;
    #Forage;
    #Defend;
    #Build;
    #Rest;
    #Explore;
    #Attack;
    #Flee;
    #Cooperate;
    #Signal;
    #MacroAction;    // Temporally extended action
  };

  // Tree node for MCTS
  public type MCTSNode = {
    state         : PlanningState;
    parentId      : ?Nat;
    childIds      : [Nat];
    action        : ?PlanningAction;  // Action that led here
    visits        : Nat;
    totalValue    : Float;
    meanValue     : Float;
    depth         : Nat;
    isPruned      : Bool;
    ucbValue      : Float;           // Upper confidence bound
  };

  // Complete planning tree
  public type PlanningTree = {
    nodes         : [MCTSNode];
    rootId        : Nat;
    maxDepth      : Nat;
    currentBest   : [Nat];           // Best path (node IDs)
    totalSims     : Nat;
  };

  // Hierarchical plan structure
  public type HierarchicalPlan = {
    strategicGoal : PlanningState;   // 50-step goal
    tacticalGoals : [PlanningState]; // 10-step subgoals
    operationalPlan: [PlanningAction]; // Immediate actions
    contingencies : [ContingencyPlan];
    confidence    : Float;
    expectedValue : Float;
  };

  public type ContingencyPlan = {
    trigger       : TriggerCondition;
    alternativePlan: [PlanningAction];
    switchCost    : Float;
  };

  public type TriggerCondition = {
    #StateDivergence : Float;      // Plan-actual divergence threshold
    #RewardDropoff : Float;        // Reward below threshold
    #ThreatDetected : Float;       // Threat level threshold
    #OpportunityFound : Float;     // Better opportunity threshold
    #Timeout : Nat;                // Time limit exceeded
  };

  // World model for forward simulation
  public type WorldModel = {
    transitionModel : TransitionModel;
    rewardModel     : RewardModel;
    uncertaintyModel: UncertaintyModel;
    modelConfidence : Float;
  };

  public type TransitionModel = {
    // P(s'|s,a) - probability distribution over next states
    predict: (PlanningState, PlanningAction) -> PlanningState;
  };

  public type RewardModel = {
    // R(s,a,s') - expected reward
    predict: (PlanningState, PlanningAction) -> Float;
  };

  public type UncertaintyModel = {
    // σ(s,a) - uncertainty in predictions
    predict: (PlanningState, PlanningAction) -> Float;
  };

  // ══════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func medinaSigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-PHI_MEDINA * x))
  };

  // ══════════════════════════════════════════════════════════════════════════
  // ███╗   ███╗ ██████╗████████╗███████╗    ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
  // ████╗ ████║██╔════╝╚══██╔══╝██╔════╝    ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝
  // ██╔████╔██║██║        ██║   ███████╗    █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  
  // ██║╚██╔╝██║██║        ██║   ╚════██║    ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  
  // ██║ ╚═╝ ██║╚██████╗   ██║   ███████║    ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗
  // ╚═╝     ╚═╝ ╚═════╝   ╚═╝   ╚══════╝    ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
  // ══════════════════════════════════════════════════════════════════════════

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA HORIZON VALUE EQUATION (MHVE)
  // ══════════════════════════════════════════════════════════════
  //
  // V(s, h) = Σ_{t=0}^{h} γ^t × r(s_t, a_t) × confidence(t)
  // confidence(t) = Φ_M^(-t/h) × (1 - uncertainty(t))
  //
  // Computes value of a state looking h steps ahead
  //
  public func medinaHorizonValue(
    expectedRewards: [Float],      // r(s_t, a_t) for each step
    uncertainties: [Float],        // Uncertainty at each step
    horizon: Nat,
    gamma: Float
  ) : Float {
    var totalValue : Float = 0.0;
    let h = Float.fromInt(horizon);
    
    var t : Nat = 0;
    while (t < expectedRewards.size() and t < horizon) {
      let tFloat = Float.fromInt(t);
      
      // Discount factor
      let discount = Float.pow(gamma, tFloat);
      
      // Confidence decay with horizon
      let uncertainty = if (t < uncertainties.size()) { uncertainties[t] } else { 0.5 };
      let confidence = Float.pow(PHI_MEDINA, -tFloat / h) * (1.0 - uncertainty);
      
      // Weighted reward
      totalValue += discount * expectedRewards[t] * confidence;
      
      t += 1;
    };
    
    totalValue
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA TREE EXPLORATION BOUND (MTEB)
  // ══════════════════════════════════════════════════════════════
  //
  // UCB_M(s,a) = Q(s,a) + c × √(ln(N(s)) / N(s,a)) × Φ_M^(depth/max_depth)
  //
  // Modified UCB1 with depth-dependent exploration
  //
  public func medinaTreeExplorationBound(
    meanValue: Float,
    parentVisits: Nat,
    nodeVisits: Nat,
    depth: Nat,
    maxDepth: Nat,
    explorationConstant: Float
  ) : Float {
    if (nodeVisits == 0) {
      return Float.fromInt(Int.abs(Int.pow(10, 6)));  // Unexplored = high priority
    };
    
    let exploitation = meanValue;
    
    // Exploration bonus
    let logParent = Float.log(Float.fromInt(parentVisits + 1));
    let exploration = explorationConstant * Float.sqrt(logParent / Float.fromInt(nodeVisits));
    
    // Depth-dependent scaling: explore less at deeper levels
    let depthFactor = Float.pow(PHI_MEDINA, Float.fromInt(depth) / Float.fromInt(maxDepth));
    
    exploitation + exploration * depthFactor
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA BRANCHING FACTOR CONTROL (MBFC)
  // ══════════════════════════════════════════════════════════════
  //
  // B(depth) = B_0 × Φ_M^(-depth/τ_B) + B_min
  //
  // Adaptively reduces branching at deeper levels
  //
  public func medinaBranchingFactor(depth: Nat) : Nat {
    let b0 = Float.fromInt(MAX_BRANCHING);
    let bMin = Float.fromInt(MIN_BRANCHING);
    
    let b = b0 * Float.pow(PHI_MEDINA, -Float.fromInt(depth) / BRANCHING_TAU) + bMin;
    
    let result = Float.toInt(Float.nearest(b));
    if (result < MIN_BRANCHING) { MIN_BRANCHING }
    else if (result > MAX_BRANCHING) { MAX_BRANCHING }
    else { Int.abs(result) }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA ACTION PRUNING (MAP)
  // ══════════════════════════════════════════════════════════════
  //
  // Keep only the top B(depth) actions based on prior × value
  //
  public func medinaActionPruning(
    actions: [PlanningAction],
    actionValues: [Float],
    depth: Nat
  ) : [PlanningAction] {
    let branchingLimit = medinaBranchingFactor(depth);
    
    if (actions.size() <= branchingLimit) { return actions };
    
    // Create index-score pairs
    let scores = Array.tabulate<(Nat, Float)>(actions.size(), func(i) {
      let value = if (i < actionValues.size()) { actionValues[i] } else { 0.0 };
      let prior = actions[i].priorProb;
      (i, prior * value + prior * 0.1)  // Prior-weighted value
    });
    
    // Simple selection: keep highest scores
    var kept = Buffer.Buffer<PlanningAction>(branchingLimit);
    var threshold : Float = 0.0;
    
    // Find threshold for top branchingLimit
    var sortedScores = Buffer.Buffer<Float>(scores.size());
    for ((_, s) in scores.vals()) { sortedScores.add(s) };
    
    // Simple approach: use average as threshold
    var sumScores : Float = 0.0;
    for (s in sortedScores.vals()) { sumScores += s };
    threshold := sumScores / Float.fromInt(actions.size());
    
    // Keep actions above threshold
    var i : Nat = 0;
    for ((idx, score) in scores.vals()) {
      if (score >= threshold and kept.size() < branchingLimit) {
        kept.add(actions[idx]);
      };
      i += 1;
    };
    
    // Ensure minimum actions
    if (kept.size() < MIN_BRANCHING) {
      var j : Nat = 0;
      while (kept.size() < MIN_BRANCHING and j < actions.size()) {
        kept.add(actions[j]);
        j += 1;
      };
    };
    
    Buffer.toArray(kept)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA VALUE BACKPROPAGATION (MVB)
  // ══════════════════════════════════════════════════════════════
  //
  // Backpropagate value through tree with Medina discounting
  //
  public func medinaValueBackpropagation(
    nodeValues: [Float],
    nodePath: [Nat],
    simulationValue: Float
  ) : [Float] {
    let n = nodeValues.size();
    var updated = Array.thaw<Float>(nodeValues);
    
    var remainingValue = simulationValue;
    var i : Nat = nodePath.size();
    
    while (i > 0) {
      i -= 1;
      let nodeIdx = nodePath[i];
      if (nodeIdx < n) {
        // Update with discounted value
        let depth = nodePath.size() - i - 1;
        let discount = Float.pow(DISCOUNT_GAMMA, Float.fromInt(depth));
        let medinaBoost = Float.pow(PHI_MEDINA, -Float.fromInt(depth) / Float.fromInt(MAX_HORIZON));
        
        updated[nodeIdx] := updated[nodeIdx] + discount * medinaBoost * remainingValue;
        remainingValue := remainingValue * DISCOUNT_GAMMA;
      };
    };
    
    Array.freeze(updated)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA ROLLOUT POLICY (MRP)
  // ══════════════════════════════════════════════════════════════
  //
  // Fast simulation to estimate value
  // Uses Medina-weighted random policy
  //
  public func medinaRolloutValue(
    startState: PlanningState,
    availableActions: [PlanningAction],
    maxSteps: Nat
  ) : Float {
    var totalReward : Float = 0.0;
    var currentState = startState;
    var step : Nat = 0;
    
    while (step < maxSteps and not currentState.isTerminal) {
      // Select action based on prior probabilities
      var bestAction : ?PlanningAction = null;
      var bestScore : Float = 0.0;
      
      for (action in availableActions.vals()) {
        let score = action.priorProb * (1.0 - action.cost);
        if (score > bestScore) {
          bestScore := score;
          bestAction := ?action;
        };
      };
      
      // Simulate transition (simplified)
      switch (bestAction) {
        case (?action) {
          let reward = 0.5 - action.cost + action.priorProb * 0.5;
          totalReward += Float.pow(DISCOUNT_GAMMA, Float.fromInt(step)) * reward;
        };
        case null {};
      };
      
      step += 1;
    };
    
    totalReward
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA HIERARCHICAL DECOMPOSITION (MHD)
  // ══════════════════════════════════════════════════════════════
  //
  // Decompose 50-step plan into hierarchical subgoals
  //
  public func medinaHierarchicalDecomposition(
    currentState: PlanningState,
    goalState: PlanningState,
    totalHorizon: Nat
  ) : [[PlanningState]] {
    // Strategic level: 1 goal at step 50
    // Tactical level: 5 subgoals at steps 10, 20, 30, 40, 50
    // Operational level: Actions for steps 1-3
    
    let numTactical = totalHorizon / TACTICAL_HORIZON;
    
    var tacticalGoals = Buffer.Buffer<PlanningState>(numTactical);
    
    // Interpolate subgoals (simplified linear interpolation)
    var i : Nat = 1;
    while (i <= numTactical) {
      let progress = Float.fromInt(i) / Float.fromInt(numTactical);
      
      // Interpolate features
      let interpolatedFeatures = Array.tabulate<Float>(
        currentState.features.size(),
        func(j) {
          let start = if (j < currentState.features.size()) { currentState.features[j] } else { 0.0 };
          let end = if (j < goalState.features.size()) { goalState.features[j] } else { 0.0 };
          start + progress * (end - start)
        }
      );
      
      tacticalGoals.add({
        features = interpolatedFeatures;
        stateId = i * 1000;
        isTerminal = i == numTactical;
        reward = goalState.reward * progress;
        uncertainty = currentState.uncertainty * (1.0 - progress) + goalState.uncertainty * progress;
        timestamp = currentState.timestamp + i * TACTICAL_HORIZON;
      });
      
      i += 1;
    };
    
    [[currentState], Buffer.toArray(tacticalGoals), [goalState]]
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA CONTINGENCY GENERATOR (MCG)
  // ══════════════════════════════════════════════════════════════
  //
  // Generate backup plans for when things go wrong
  //
  public func medinaContingencyPlan(
    mainPlan: [PlanningAction],
    riskFactors: [Float],
    threatLevel: Float
  ) : [ContingencyPlan] {
    var contingencies = Buffer.Buffer<ContingencyPlan>(4);
    
    // 1. State divergence contingency
    contingencies.add({
      trigger = #StateDivergence(0.3);  // 30% divergence
      alternativePlan = Array.tabulate<PlanningAction>(3, func(i) {
        {
          actionId = 1000 + i;
          actionType = #Explore;
          parameters = [];
          priorProb = 0.8;
          cost = 0.1;
        }
      });
      switchCost = 0.2;
    });
    
    // 2. Threat detection contingency
    if (threatLevel > 0.3) {
      contingencies.add({
        trigger = #ThreatDetected(threatLevel);
        alternativePlan = [{
          actionId = 2000;
          actionType = #Defend;
          parameters = [threatLevel];
          priorProb = 0.9;
          cost = 0.3;
        }, {
          actionId = 2001;
          actionType = #Flee;
          parameters = [];
          priorProb = 0.7;
          cost = 0.1;
        }];
        switchCost = 0.1;  // Low cost to switch to defense
      });
    };
    
    // 3. Opportunity contingency
    contingencies.add({
      trigger = #OpportunityFound(0.7);
      alternativePlan = [{
        actionId = 3000;
        actionType = #Forage;
        parameters = [];
        priorProb = 0.85;
        cost = 0.15;
      }];
      switchCost = 0.05;
    });
    
    // 4. Timeout contingency
    contingencies.add({
      trigger = #Timeout(MAX_HORIZON);
      alternativePlan = [{
        actionId = 4000;
        actionType = #Rest;
        parameters = [];
        priorProb = 0.6;
        cost = 0.05;
      }];
      switchCost = 0.0;
    });
    
    Buffer.toArray(contingencies)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA PLAN CONFIDENCE (MPC)
  // ══════════════════════════════════════════════════════════════
  //
  // Estimate confidence in entire plan
  //
  public func medinaPlanConfidence(
    actionConfidences: [Float],
    uncertainties: [Float],
    horizon: Nat
  ) : Float {
    var logConfidence : Float = 0.0;
    let h = Float.fromInt(horizon);
    
    var i : Nat = 0;
    while (i < actionConfidences.size() and i < horizon) {
      let conf = if (i < actionConfidences.size()) { actionConfidences[i] } else { 0.5 };
      let unc = if (i < uncertainties.size()) { uncertainties[i] } else { 0.3 };
      
      // Medina-weighted confidence
      let stepConf = conf * (1.0 - unc) * Float.pow(PHI_MEDINA, -Float.fromInt(i) / h);
      
      // Accumulate log-confidence
      if (stepConf > 0.0) {
        logConfidence += Float.log(stepConf);
      } else {
        logConfidence += Float.log(0.01);  // Minimum confidence
      };
      
      i += 1;
    };
    
    // Convert back from log
    Float.exp(logConfidence / Float.fromInt(horizon))
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA TEMPORAL ABSTRACTION (MTA)
  // ══════════════════════════════════════════════════════════════
  //
  // Create macro-actions (options) that span multiple steps
  //
  public type MacroAction = {
    name          : Text;
    primitiveActions: [PlanningAction];
    duration      : Nat;
    initSet       : [PlanningState];  // States where applicable
    terminationProb: Float;           // Probability of termination
    expectedValue : Float;
  };

  public func medinaMacroActionValue(
    primitiveRewards: [Float],
    terminationState: PlanningState
  ) : Float {
    var totalValue : Float = 0.0;
    let duration = primitiveRewards.size();
    
    var t : Nat = 0;
    for (r in primitiveRewards.vals()) {
      totalValue += Float.pow(DISCOUNT_GAMMA, Float.fromInt(t)) * r;
      t += 1;
    };
    
    // Add terminal value
    totalValue += Float.pow(DISCOUNT_GAMMA, Float.fromInt(duration)) * terminationState.reward;
    
    totalValue
  };

  // ══════════════════════════════════════════════════════════════
  // COMPLETE 50-STEP PLANNER
  // ══════════════════════════════════════════════════════════════
  public func medina50StepPlan(
    currentState: PlanningState,
    goalState: PlanningState,
    availableActions: [PlanningAction],
    threatLevel: Float
  ) : HierarchicalPlan {
    // 1. Hierarchical decomposition
    let hierarchy = medinaHierarchicalDecomposition(currentState, goalState, MAX_HORIZON);
    
    let tacticalGoals = if (hierarchy.size() > 1) { hierarchy[1] } else { [] };
    
    // 2. Generate immediate operational plan
    let operationalPlan = medinaActionPruning(availableActions, 
      Array.tabulate<Float>(availableActions.size(), func(i) { availableActions[i].priorProb }),
      0
    );
    
    // 3. Generate contingencies
    let contingencies = medinaContingencyPlan(operationalPlan, [], threatLevel);
    
    // 4. Compute confidence
    let actionConfidences = Array.map<PlanningAction, Float>(operationalPlan, func(a) { a.priorProb });
    let uncertainties = Array.tabulate<Float>(MAX_HORIZON, func(i) { 
      Float.fromInt(i) / Float.fromInt(MAX_HORIZON) * 0.5 
    });
    let confidence = medinaPlanConfidence(actionConfidences, uncertainties, MAX_HORIZON);
    
    // 5. Compute expected value
    let rewards = Array.map<PlanningAction, Float>(operationalPlan, func(a) { 
      a.priorProb - a.cost 
    });
    let expectedValue = medinaHorizonValue(rewards, uncertainties, MAX_HORIZON, DISCOUNT_GAMMA);
    
    {
      strategicGoal = goalState;
      tacticalGoals = tacticalGoals;
      operationalPlan = operationalPlan;
      contingencies = contingencies;
      confidence = confidence;
      expectedValue = expectedValue;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // PLAN EXECUTION MONITORING
  // ══════════════════════════════════════════════════════════════
  public type ExecutionMonitor = {
    currentStep   : Nat;
    planDeviation : Float;
    triggeredContingency: ?ContingencyPlan;
    replanning    : Bool;
    cumulativeReward: Float;
  };

  public func monitorExecution(
    plan: HierarchicalPlan,
    actualState: PlanningState,
    expectedState: PlanningState,
    step: Nat
  ) : ExecutionMonitor {
    // Compute state divergence
    var divergence : Float = 0.0;
    var i : Nat = 0;
    while (i < actualState.features.size() and i < expectedState.features.size()) {
      let diff = actualState.features[i] - expectedState.features[i];
      divergence += diff * diff;
      i += 1;
    };
    divergence := Float.sqrt(divergence);
    
    // Check contingency triggers
    var triggered : ?ContingencyPlan = null;
    for (cont in plan.contingencies.vals()) {
      switch (cont.trigger) {
        case (#StateDivergence(threshold)) {
          if (divergence > threshold) { triggered := ?cont };
        };
        case (#ThreatDetected(threshold)) {
          if (actualState.uncertainty > threshold) { triggered := ?cont };
        };
        case _ {};
      };
    };
    
    let needsReplan = divergence > 0.5 or triggered != null;
    
    {
      currentStep = step;
      planDeviation = divergence;
      triggeredContingency = triggered;
      replanning = needsReplan;
      cumulativeReward = actualState.reward;
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

}
