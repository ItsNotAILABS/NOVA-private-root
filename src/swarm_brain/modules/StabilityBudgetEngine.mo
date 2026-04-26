// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: StabilityBudgetEngine — Mathematical Safety Governance
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              STABILITY BUDGET ENGINE                                     ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  EXPLICIT SAFETY GOVERNANCE THROUGH MATHEMATICAL BUDGET                  ║
// ║                                                                          ║
// ║  Core concept: Each beat has a finite "stability budget" B(t)            ║
// ║    - Modules spend budget for aggressive adaptations                     ║
// ║    - Budget replenishes via stabilizing behaviors                        ║
// ║    - If budget exhausted, only safe control actions permitted            ║
// ║                                                                          ║
// ║  Budget dynamics:                                                        ║
// ║    dB/dt = γ·(B_max - B) - Σᵢ cᵢ·aᵢ                                      ║
// ║    where:                                                                ║
// ║      γ = natural replenishment rate                                      ║
// ║      cᵢ = cost of action i                                               ║
// ║      aᵢ = action intensity                                               ║
// ║                                                                          ║
// ║  Also implements:                                                        ║
// ║    • Multiscale plasticity (fast/consolidation/structural)               ║
// ║    • Counterfactual simulation lane                                      ║
// ║    • Risk-bounded action selection                                       ║
// ║    • Lyapunov stability verification                                     ║
// ║                                                                          ║
// ║  MULTIPLE RESPONSIBILITIES:                                              ║
// ║    1. Budget management                                                  ║
// ║    2. Safety verification                                                ║
// ║    3. Action gating                                                      ║
// ║    4. Plasticity control                                                 ║
// ║    5. Risk assessment                                                    ║
// ║    6. Counterfactual simulation                                          ║
// ║    7. Recovery orchestration                                             ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MATHEMATICAL CONSTANTS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let phi : Float = 1.6180339887498948482;
  public let psi : Float = 0.6180339887498948482;
  public let τ : Float = 6.2831853071795864769;
  public let pi : Float = 3.1415926535897932385;
  public let e : Float = 2.7182818284590452354;

  // Budget constants
  public let B_MAX : Float = 100.0;        // Maximum budget
  public let B_CRITICAL : Float = 10.0;    // Critical threshold
  public let B_EMERGENCY : Float = 5.0;    // Emergency threshold
  public let REPLENISH_RATE : Float = 0.1; // γ

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ACTION TYPES AND COSTS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type ActionCategory = {
    #SafeControl;       // No budget cost
    #Observation;       // Minimal cost
    #MinorAdaptation;   // Low cost
    #MajorAdaptation;   // Medium cost
    #StructuralChange;  // High cost
    #EmergencyAction;   // Very high cost
    #DoctrineChange;    // Extreme cost
  };

  public type Action = {
    id : Nat32;
    category : ActionCategory;
    intensity : Float;      // 0.0 to 1.0
    baseCost : Float;
    riskLevel : Float;      // 0.0 to 1.0
    reversible : Bool;
    requiresApproval : Bool;
  };

  // Cost multipliers by category
  public func categoryCost(cat : ActionCategory) : Float {
    switch (cat) {
      case (#SafeControl) { 0.0 };
      case (#Observation) { 0.1 };
      case (#MinorAdaptation) { 1.0 };
      case (#MajorAdaptation) { 5.0 };
      case (#StructuralChange) { 20.0 };
      case (#EmergencyAction) { 30.0 };
      case (#DoctrineChange) { 50.0 };
    }
  };

  // Compute total action cost
  public func actionCost(action : Action) : Float {
    let baseCategoryCost = categoryCost(action.category);
    let intensityMultiplier = 1.0 + action.intensity;
    let riskMultiplier = 1.0 + action.riskLevel;
    let reversibilityBonus = if (action.reversible) { 0.8 } else { 1.0 };
    
    action.baseCost * baseCategoryCost * intensityMultiplier * riskMultiplier * reversibilityBonus
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     STABILITY BUDGET STATE                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type BudgetState = {
    currentBudget : Float;
    maxBudget : Float;
    replenishRate : Float;
    
    // Budget history
    budgetHistory : [Float];
    historyLength : Nat;
    
    // Action tracking
    actionsThisBeat : [Action];
    totalCostThisBeat : Float;
    
    // Status
    status : BudgetStatus;
    consecutiveLowBeats : Nat;
    
    // Statistics
    avgBudget : Float;
    minBudget : Float;
    totalActionsProcessed : Nat;
  };

  public type BudgetStatus = {
    #Healthy;       // B > 50% of max
    #Normal;        // B > 25% of max
    #Low;           // B > critical
    #Critical;      // B > emergency
    #Emergency;     // B <= emergency
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PLASTICITY CHANNELS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type PlasticityState = {
    // Fast Hebbian updates (within-beat)
    fastChannel : FastPlasticity;
    
    // Consolidation buffer (episode-level)
    consolidationChannel : ConsolidationBuffer;
    
    // Structural rewiring (epoch-level)
    structuralChannel : StructuralPlasticity;
    
    // Global plasticity budget
    plasticityBudget : Float;
    maxPlasticityBudget : Float;
  };

  public type FastPlasticity = {
    learningRate : Float;
    decayRate : Float;
    deltaWeights : [Float];
    active : Bool;
    lastUpdate : Nat;
  };

  public type ConsolidationBuffer = {
    episodeBuffer : [[Float]];
    bufferSize : Nat;
    maxSize : Nat;
    consolidationThreshold : Float;
    lastConsolidation : Nat;
    episodesPerConsolidation : Nat;
  };

  public type StructuralPlasticity = {
    rewiringWindow : Nat;          // Beats between rewiring
    currentWindowPosition : Nat;
    pendingAdditions : [(Nat, Nat, Float)];  // (from, to, weight)
    pendingRemovals : [(Nat, Nat)];
    maxChangesPerWindow : Nat;
    lastRewiring : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COUNTERFACTUAL SIMULATION                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type CounterfactualLane = {
    active : Bool;
    horizonBeats : Nat;
    simulatedStates : [SimulatedState];
    candidateActions : [Action];
    evaluatedOutcomes : [ActionOutcome];
  };

  public type SimulatedState = {
    beat : Nat;
    stateVector : [Float];
    invariants : [Float];
    lawViolations : Nat;
  };

  public type ActionOutcome = {
    action : Action;
    expectedReward : Float;
    expectedRisk : Float;
    lawImpact : Float;         // Negative = violations
    confidenceInterval : (Float, Float);
    recommended : Bool;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     STABILITY BUDGET ENGINE                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type StabilityBudgetEngine = {
    id : Nat;
    
    // Core budget state
    budget : BudgetState;
    
    // Plasticity management
    plasticity : PlasticityState;
    
    // Counterfactual simulation
    counterfactual : CounterfactualLane;
    
    // Lyapunov stability tracking
    lyapunovFunction : LyapunovTracker;
    
    // Risk assessment
    riskState : RiskAssessment;
    
    // Beat tracking
    currentBeat : Nat;
  };

  public type LyapunovTracker = {
    currentValue : Float;
    previousValue : Float;
    derivative : Float;
    isDecreasing : Bool;
    stabilityMargin : Float;
    history : [Float];
  };

  public type RiskAssessment = {
    instantaneousRisk : Float;
    movingAverageRisk : Float;
    maxAcceptableRisk : Float;
    riskHistory : [Float];
    anomalyCount : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE CREATION                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public func createEngine(id : Nat) : StabilityBudgetEngine {
    {
      id = id;
      budget = {
        currentBudget = B_MAX;
        maxBudget = B_MAX;
        replenishRate = REPLENISH_RATE;
        budgetHistory = [];
        historyLength = 100;
        actionsThisBeat = [];
        totalCostThisBeat = 0.0;
        status = #Healthy;
        consecutiveLowBeats = 0;
        avgBudget = B_MAX;
        minBudget = B_MAX;
        totalActionsProcessed = 0;
      };
      plasticity = {
        fastChannel = {
          learningRate = 0.01;
          decayRate = 0.001;
          deltaWeights = [];
          active = true;
          lastUpdate = 0;
        };
        consolidationChannel = {
          episodeBuffer = [];
          bufferSize = 0;
          maxSize = 100;
          consolidationThreshold = 0.8;
          lastConsolidation = 0;
          episodesPerConsolidation = 10;
        };
        structuralChannel = {
          rewiringWindow = 1000;
          currentWindowPosition = 0;
          pendingAdditions = [];
          pendingRemovals = [];
          maxChangesPerWindow = 10;
          lastRewiring = 0;
        };
        plasticityBudget = 50.0;
        maxPlasticityBudget = 100.0;
      };
      counterfactual = {
        active = false;
        horizonBeats = 10;
        simulatedStates = [];
        candidateActions = [];
        evaluatedOutcomes = [];
      };
      lyapunovFunction = {
        currentValue = 0.0;
        previousValue = 0.0;
        derivative = 0.0;
        isDecreasing = true;
        stabilityMargin = 1.0;
        history = [];
      };
      riskState = {
        instantaneousRisk = 0.0;
        movingAverageRisk = 0.0;
        maxAcceptableRisk = 0.5;
        riskHistory = [];
        anomalyCount = 0;
      };
      currentBeat = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BUDGET OPERATIONS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Check if action is permitted given current budget
  public func canAffordAction(engine : StabilityBudgetEngine, action : Action) : Bool {
    let cost = actionCost(action);
    
    // Safe actions always permitted
    if (action.category == #SafeControl) { return true };
    
    // Check budget
    if (engine.budget.currentBudget < cost) { return false };
    
    // Check status restrictions
    switch (engine.budget.status) {
      case (#Emergency) {
        // Only safe actions in emergency
        action.category == #SafeControl
      };
      case (#Critical) {
        // Only safe or observation
        action.category == #SafeControl or action.category == #Observation
      };
      case (#Low) {
        // No structural or doctrine changes
        action.category != #StructuralChange and action.category != #DoctrineChange
      };
      case (_) { true };
    }
  };

  // Request to spend budget on action
  public func requestBudget(
    engine : StabilityBudgetEngine,
    action : Action
  ) : (StabilityBudgetEngine, Bool) {
    let cost = actionCost(action);
    
    if (not canAffordAction(engine, action)) {
      return (engine, false);
    };
    
    // Deduct from budget
    let newBudget = engine.budget.currentBudget - cost;
    
    // Update actions this beat
    let newActions = Buffer.fromArray<Action>(engine.budget.actionsThisBeat);
    newActions.add(action);
    
    let newBudgetState : BudgetState = {
      currentBudget = newBudget;
      maxBudget = engine.budget.maxBudget;
      replenishRate = engine.budget.replenishRate;
      budgetHistory = engine.budget.budgetHistory;
      historyLength = engine.budget.historyLength;
      actionsThisBeat = Buffer.toArray(newActions);
      totalCostThisBeat = engine.budget.totalCostThisBeat + cost;
      status = computeStatus(newBudget, engine.budget.maxBudget);
      consecutiveLowBeats = engine.budget.consecutiveLowBeats;
      avgBudget = engine.budget.avgBudget;
      minBudget = Float.min(engine.budget.minBudget, newBudget);
      totalActionsProcessed = engine.budget.totalActionsProcessed + 1;
    };
    
    let newEngine : StabilityBudgetEngine = {
      id = engine.id;
      budget = newBudgetState;
      plasticity = engine.plasticity;
      counterfactual = engine.counterfactual;
      lyapunovFunction = engine.lyapunovFunction;
      riskState = engine.riskState;
      currentBeat = engine.currentBeat;
    };
    
    (newEngine, true)
  };

  // Replenish budget at end of beat
  public func replenishBudget(engine : StabilityBudgetEngine) : StabilityBudgetEngine {
    // Natural replenishment: dB/dt = γ·(B_max - B)
    let replenishment = engine.budget.replenishRate * 
                        (engine.budget.maxBudget - engine.budget.currentBudget);
    
    // Bonus replenishment for stabilizing behaviors
    let stabilityBonus = if (engine.lyapunovFunction.isDecreasing) { 1.0 } else { 0.0 };
    let riskBonus = (1.0 - engine.riskState.instantaneousRisk) * 0.5;
    
    let totalReplenishment = replenishment + stabilityBonus + riskBonus;
    let newBudget = Float.min(engine.budget.maxBudget, 
                              engine.budget.currentBudget + totalReplenishment);
    
    // Update history
    let history = Buffer.fromArray<Float>(engine.budget.budgetHistory);
    history.add(newBudget);
    if (history.size() > engine.budget.historyLength) {
      ignore history.remove(0);
    };
    let historyArray = Buffer.toArray(history);
    
    // Update average
    var sum : Float = 0.0;
    for (b in historyArray.vals()) { sum += b };
    let newAvg = if (historyArray.size() > 0) {
      sum / Float.fromInt(historyArray.size())
    } else { newBudget };
    
    // Update consecutive low beats
    let status = computeStatus(newBudget, engine.budget.maxBudget);
    let consecutiveLow = switch (status) {
      case (#Low) or (#Critical) or (#Emergency) { 
        engine.budget.consecutiveLowBeats + 1 
      };
      case (_) { 0 };
    };
    
    let newBudgetState : BudgetState = {
      currentBudget = newBudget;
      maxBudget = engine.budget.maxBudget;
      replenishRate = engine.budget.replenishRate;
      budgetHistory = historyArray;
      historyLength = engine.budget.historyLength;
      actionsThisBeat = [];  // Reset for next beat
      totalCostThisBeat = 0.0;
      status = status;
      consecutiveLowBeats = consecutiveLow;
      avgBudget = newAvg;
      minBudget = engine.budget.minBudget;
      totalActionsProcessed = engine.budget.totalActionsProcessed;
    };
    
    {
      id = engine.id;
      budget = newBudgetState;
      plasticity = engine.plasticity;
      counterfactual = engine.counterfactual;
      lyapunovFunction = engine.lyapunovFunction;
      riskState = engine.riskState;
      currentBeat = engine.currentBeat + 1;
    }
  };

  func computeStatus(budget : Float, maxBudget : Float) : BudgetStatus {
    let ratio = budget / maxBudget;
    
    if (ratio > 0.5) { #Healthy }
    else if (ratio > 0.25) { #Normal }
    else if (ratio > B_CRITICAL / B_MAX) { #Low }
    else if (ratio > B_EMERGENCY / B_MAX) { #Critical }
    else { #Emergency }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PLASTICITY MANAGEMENT                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Fast Hebbian update (within-beat)
  public func fastPlasticityUpdate(
    engine : StabilityBudgetEngine,
    preActivations : [Float],
    postActivations : [Float]
  ) : StabilityBudgetEngine {
    if (not engine.plasticity.fastChannel.active) {
      return engine;
    };
    
    // Check plasticity budget
    let cost = 0.1 * Float.fromInt(preActivations.size());
    if (engine.plasticity.plasticityBudget < cost) {
      return engine;
    };
    
    let η = engine.plasticity.fastChannel.learningRate;
    let λ = engine.plasticity.fastChannel.decayRate;
    
    // Compute Hebbian weight changes: ΔW_ij = η·x_i·x_j - λ·W_ij
    let n = Nat.min(preActivations.size(), postActivations.size());
    let deltaWeights = Array.tabulate<Float>(n * n, func(idx : Nat) : Float {
      let i = idx / n;
      let j = idx % n;
      
      let hebbian = η * preActivations[i] * postActivations[j];
      let decay = if (idx < engine.plasticity.fastChannel.deltaWeights.size()) {
        λ * engine.plasticity.fastChannel.deltaWeights[idx]
      } else { 0.0 };
      
      hebbian - decay
    });
    
    let newFastChannel : FastPlasticity = {
      learningRate = engine.plasticity.fastChannel.learningRate;
      decayRate = engine.plasticity.fastChannel.decayRate;
      deltaWeights = deltaWeights;
      active = engine.plasticity.fastChannel.active;
      lastUpdate = engine.currentBeat;
    };
    
    let newPlasticity : PlasticityState = {
      fastChannel = newFastChannel;
      consolidationChannel = engine.plasticity.consolidationChannel;
      structuralChannel = engine.plasticity.structuralChannel;
      plasticityBudget = engine.plasticity.plasticityBudget - cost;
      maxPlasticityBudget = engine.plasticity.maxPlasticityBudget;
    };
    
    {
      id = engine.id;
      budget = engine.budget;
      plasticity = newPlasticity;
      counterfactual = engine.counterfactual;
      lyapunovFunction = engine.lyapunovFunction;
      riskState = engine.riskState;
      currentBeat = engine.currentBeat;
    }
  };

  // Add episode to consolidation buffer
  public func bufferEpisode(
    engine : StabilityBudgetEngine,
    episodeWeights : [Float]
  ) : StabilityBudgetEngine {
    let buffer = Buffer.fromArray<[Float]>(engine.plasticity.consolidationChannel.episodeBuffer);
    buffer.add(episodeWeights);
    
    // Remove old episodes if buffer full
    while (buffer.size() > engine.plasticity.consolidationChannel.maxSize) {
      ignore buffer.remove(0);
    };
    
    let newConsolidation : ConsolidationBuffer = {
      episodeBuffer = Buffer.toArray(buffer);
      bufferSize = buffer.size();
      maxSize = engine.plasticity.consolidationChannel.maxSize;
      consolidationThreshold = engine.plasticity.consolidationChannel.consolidationThreshold;
      lastConsolidation = engine.plasticity.consolidationChannel.lastConsolidation;
      episodesPerConsolidation = engine.plasticity.consolidationChannel.episodesPerConsolidation;
    };
    
    let newPlasticity : PlasticityState = {
      fastChannel = engine.plasticity.fastChannel;
      consolidationChannel = newConsolidation;
      structuralChannel = engine.plasticity.structuralChannel;
      plasticityBudget = engine.plasticity.plasticityBudget;
      maxPlasticityBudget = engine.plasticity.maxPlasticityBudget;
    };
    
    {
      id = engine.id;
      budget = engine.budget;
      plasticity = newPlasticity;
      counterfactual = engine.counterfactual;
      lyapunovFunction = engine.lyapunovFunction;
      riskState = engine.riskState;
      currentBeat = engine.currentBeat;
    }
  };

  // Consolidate episodes into long-term weights
  public func consolidate(engine : StabilityBudgetEngine) : (StabilityBudgetEngine, [Float]) {
    let buffer = engine.plasticity.consolidationChannel.episodeBuffer;
    
    if (buffer.size() < engine.plasticity.consolidationChannel.episodesPerConsolidation) {
      return (engine, []);
    };
    
    // Check budget
    let cost = 5.0;
    if (engine.plasticity.plasticityBudget < cost) {
      return (engine, []);
    };
    
    // Average weights across episodes
    if (buffer.size() == 0 or buffer[0].size() == 0) {
      return (engine, []);
    };
    
    let weightSize = buffer[0].size();
    let consolidatedWeights = Array.tabulate<Float>(weightSize, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (episode in buffer.vals()) {
        if (i < episode.size()) {
          sum += episode[i];
        };
      };
      sum / Float.fromInt(buffer.size())
    });
    
    // Clear buffer
    let newConsolidation : ConsolidationBuffer = {
      episodeBuffer = [];
      bufferSize = 0;
      maxSize = engine.plasticity.consolidationChannel.maxSize;
      consolidationThreshold = engine.plasticity.consolidationChannel.consolidationThreshold;
      lastConsolidation = engine.currentBeat;
      episodesPerConsolidation = engine.plasticity.consolidationChannel.episodesPerConsolidation;
    };
    
    let newPlasticity : PlasticityState = {
      fastChannel = engine.plasticity.fastChannel;
      consolidationChannel = newConsolidation;
      structuralChannel = engine.plasticity.structuralChannel;
      plasticityBudget = engine.plasticity.plasticityBudget - cost;
      maxPlasticityBudget = engine.plasticity.maxPlasticityBudget;
    };
    
    let newEngine : StabilityBudgetEngine = {
      id = engine.id;
      budget = engine.budget;
      plasticity = newPlasticity;
      counterfactual = engine.counterfactual;
      lyapunovFunction = engine.lyapunovFunction;
      riskState = engine.riskState;
      currentBeat = engine.currentBeat;
    };
    
    (newEngine, consolidatedWeights)
  };

  // Schedule structural change (rewiring)
  public func scheduleRewiring(
    engine : StabilityBudgetEngine,
    additions : [(Nat, Nat, Float)],
    removals : [(Nat, Nat)]
  ) : StabilityBudgetEngine {
    // Check if in rewiring window
    let windowPos = engine.plasticity.structuralChannel.currentWindowPosition;
    let windowSize = engine.plasticity.structuralChannel.rewiringWindow;
    
    if (windowPos < windowSize - 100) {
      // Not near rewiring point, buffer changes
      let newAdditions = Buffer.fromArray<(Nat, Nat, Float)>(
        engine.plasticity.structuralChannel.pendingAdditions
      );
      for (a in additions.vals()) {
        if (newAdditions.size() < engine.plasticity.structuralChannel.maxChangesPerWindow) {
          newAdditions.add(a);
        };
      };
      
      let newRemovals = Buffer.fromArray<(Nat, Nat)>(
        engine.plasticity.structuralChannel.pendingRemovals
      );
      for (r in removals.vals()) {
        if (newRemovals.size() < engine.plasticity.structuralChannel.maxChangesPerWindow) {
          newRemovals.add(r);
        };
      };
      
      let newStructural : StructuralPlasticity = {
        rewiringWindow = engine.plasticity.structuralChannel.rewiringWindow;
        currentWindowPosition = engine.plasticity.structuralChannel.currentWindowPosition;
        pendingAdditions = Buffer.toArray(newAdditions);
        pendingRemovals = Buffer.toArray(newRemovals);
        maxChangesPerWindow = engine.plasticity.structuralChannel.maxChangesPerWindow;
        lastRewiring = engine.plasticity.structuralChannel.lastRewiring;
      };
      
      let newPlasticity : PlasticityState = {
        fastChannel = engine.plasticity.fastChannel;
        consolidationChannel = engine.plasticity.consolidationChannel;
        structuralChannel = newStructural;
        plasticityBudget = engine.plasticity.plasticityBudget;
        maxPlasticityBudget = engine.plasticity.maxPlasticityBudget;
      };
      
      {
        id = engine.id;
        budget = engine.budget;
        plasticity = newPlasticity;
        counterfactual = engine.counterfactual;
        lyapunovFunction = engine.lyapunovFunction;
        riskState = engine.riskState;
        currentBeat = engine.currentBeat;
      }
    } else {
      engine  // Ignore, too close to rewiring
    }
  };

  // Execute pending structural changes
  public func executeRewiring(engine : StabilityBudgetEngine) : (StabilityBudgetEngine, [(Nat, Nat, Float)], [(Nat, Nat)]) {
    let windowPos = engine.plasticity.structuralChannel.currentWindowPosition;
    let windowSize = engine.plasticity.structuralChannel.rewiringWindow;
    
    if (windowPos != windowSize - 1) {
      // Not at rewiring point
      return (engine, [], []);
    };
    
    // Check budget
    let numChanges = engine.plasticity.structuralChannel.pendingAdditions.size() +
                     engine.plasticity.structuralChannel.pendingRemovals.size();
    let cost = 10.0 * Float.fromInt(numChanges);
    
    if (engine.plasticity.plasticityBudget < cost or engine.budget.status == #Emergency) {
      // Reset window, skip rewiring
      let newStructural : StructuralPlasticity = {
        rewiringWindow = engine.plasticity.structuralChannel.rewiringWindow;
        currentWindowPosition = 0;
        pendingAdditions = engine.plasticity.structuralChannel.pendingAdditions;  // Keep pending
        pendingRemovals = engine.plasticity.structuralChannel.pendingRemovals;
        maxChangesPerWindow = engine.plasticity.structuralChannel.maxChangesPerWindow;
        lastRewiring = engine.plasticity.structuralChannel.lastRewiring;
      };
      
      let newPlasticity : PlasticityState = {
        fastChannel = engine.plasticity.fastChannel;
        consolidationChannel = engine.plasticity.consolidationChannel;
        structuralChannel = newStructural;
        plasticityBudget = engine.plasticity.plasticityBudget;
        maxPlasticityBudget = engine.plasticity.maxPlasticityBudget;
      };
      
      return ({
        id = engine.id;
        budget = engine.budget;
        plasticity = newPlasticity;
        counterfactual = engine.counterfactual;
        lyapunovFunction = engine.lyapunovFunction;
        riskState = engine.riskState;
        currentBeat = engine.currentBeat;
      }, [], []);
    };
    
    // Execute rewiring
    let additions = engine.plasticity.structuralChannel.pendingAdditions;
    let removals = engine.plasticity.structuralChannel.pendingRemovals;
    
    let newStructural : StructuralPlasticity = {
      rewiringWindow = engine.plasticity.structuralChannel.rewiringWindow;
      currentWindowPosition = 0;
      pendingAdditions = [];
      pendingRemovals = [];
      maxChangesPerWindow = engine.plasticity.structuralChannel.maxChangesPerWindow;
      lastRewiring = engine.currentBeat;
    };
    
    let newPlasticity : PlasticityState = {
      fastChannel = engine.plasticity.fastChannel;
      consolidationChannel = engine.plasticity.consolidationChannel;
      structuralChannel = newStructural;
      plasticityBudget = engine.plasticity.plasticityBudget - cost;
      maxPlasticityBudget = engine.plasticity.maxPlasticityBudget;
    };
    
    let newEngine : StabilityBudgetEngine = {
      id = engine.id;
      budget = engine.budget;
      plasticity = newPlasticity;
      counterfactual = engine.counterfactual;
      lyapunovFunction = engine.lyapunovFunction;
      riskState = engine.riskState;
      currentBeat = engine.currentBeat;
    };
    
    (newEngine, additions, removals)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COUNTERFACTUAL SIMULATION                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Run counterfactual simulation for candidate actions
  public func simulateCounterfactuals(
    engine : StabilityBudgetEngine,
    currentState : [Float],
    candidateActions : [Action],
    dynamics : ([Float], Action) -> [Float],  // State transition function
    lawCheck : ([Float]) -> Float              // Returns violation score
  ) : StabilityBudgetEngine {
    let horizon = engine.counterfactual.horizonBeats;
    let outcomes = Buffer.Buffer<ActionOutcome>(candidateActions.size());
    
    for (action in candidateActions.vals()) {
      // Simulate forward
      var state = currentState;
      var totalReward : Float = 0.0;
      var maxRisk : Float = 0.0;
      var totalLawImpact : Float = 0.0;
      
      for (_t in Iter.range(0, horizon - 1)) {
        state := dynamics(state, action);
        
        // Evaluate state
        let stateNorm = vectorNorm(state);
        let reward = 1.0 / (1.0 + stateNorm);  // Simple reward
        totalReward += reward * Float.pow(0.9, Float.fromInt(_t));  // Discounted
        
        // Risk assessment
        let risk = action.riskLevel * (1.0 + stateNorm / 10.0);
        if (risk > maxRisk) { maxRisk := risk };
        
        // Law impact
        let violations = lawCheck(state);
        totalLawImpact -= violations;
      };
      
      let avgReward = totalReward / Float.fromInt(horizon);
      let recommended = avgReward > 0.5 and maxRisk < engine.riskState.maxAcceptableRisk and totalLawImpact >= 0.0;
      
      outcomes.add({
        action = action;
        expectedReward = avgReward;
        expectedRisk = maxRisk;
        lawImpact = totalLawImpact;
        confidenceInterval = (avgReward * 0.8, avgReward * 1.2);
        recommended = recommended;
      });
    };
    
    let newCounterfactual : CounterfactualLane = {
      active = true;
      horizonBeats = engine.counterfactual.horizonBeats;
      simulatedStates = [];
      candidateActions = candidateActions;
      evaluatedOutcomes = Buffer.toArray(outcomes);
    };
    
    {
      id = engine.id;
      budget = engine.budget;
      plasticity = engine.plasticity;
      counterfactual = newCounterfactual;
      lyapunovFunction = engine.lyapunovFunction;
      riskState = engine.riskState;
      currentBeat = engine.currentBeat;
    }
  };

  // Select best action from counterfactual results
  public func selectBestAction(engine : StabilityBudgetEngine) : ?Action {
    let outcomes = engine.counterfactual.evaluatedOutcomes;
    
    var bestAction : ?Action = null;
    var bestScore : Float = -1e10;
    
    for (outcome in outcomes.vals()) {
      if (outcome.recommended) {
        // Score: reward - risk penalty + law bonus
        let score = outcome.expectedReward - 2.0 * outcome.expectedRisk + outcome.lawImpact;
        
        if (score > bestScore) {
          bestScore := score;
          bestAction := ?outcome.action;
        };
      };
    };
    
    bestAction
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     LYAPUNOV STABILITY                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Update Lyapunov function estimate
  public func updateLyapunov(engine : StabilityBudgetEngine, stateNorm : Float) : StabilityBudgetEngine {
    // Simple Lyapunov candidate: V = ||x||²
    let V = stateNorm * stateNorm;
    let dV = V - engine.lyapunovFunction.previousValue;
    
    // Update history
    let history = Buffer.fromArray<Float>(engine.lyapunovFunction.history);
    history.add(V);
    if (history.size() > 100) {
      ignore history.remove(0);
    };
    
    // Compute stability margin (average dV)
    var sumDV : Float = 0.0;
    let histArr = Buffer.toArray(history);
    for (i in Iter.range(1, histArr.size() - 1)) {
      sumDV += histArr[i] - histArr[i - 1];
    };
    let avgDV = if (histArr.size() > 1) {
      sumDV / Float.fromInt(histArr.size() - 1)
    } else { 0.0 };
    
    let newLyapunov : LyapunovTracker = {
      currentValue = V;
      previousValue = engine.lyapunovFunction.currentValue;
      derivative = dV;
      isDecreasing = dV <= 0.0;
      stabilityMargin = -avgDV;  // Positive = stable
      history = histArr;
    };
    
    {
      id = engine.id;
      budget = engine.budget;
      plasticity = engine.plasticity;
      counterfactual = engine.counterfactual;
      lyapunovFunction = newLyapunov;
      riskState = engine.riskState;
      currentBeat = engine.currentBeat;
    }
  };

  // Check Lyapunov stability
  public func isStable(engine : StabilityBudgetEngine) : Bool {
    engine.lyapunovFunction.stabilityMargin > 0.0 and
    engine.lyapunovFunction.isDecreasing
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RISK ASSESSMENT                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Update risk assessment
  public func updateRisk(engine : StabilityBudgetEngine, observations : [Float]) : StabilityBudgetEngine {
    // Compute instantaneous risk from observations
    var maxObs : Float = 0.0;
    for (obs in observations.vals()) {
      if (Float.abs(obs) > maxObs) {
        maxObs := Float.abs(obs);
      };
    };
    
    let instantRisk = Float.min(1.0, maxObs / 10.0);  // Normalize
    
    // Update moving average
    let alpha = 0.1;
    let newAvgRisk = alpha * instantRisk + (1.0 - alpha) * engine.riskState.movingAverageRisk;
    
    // Update history
    let history = Buffer.fromArray<Float>(engine.riskState.riskHistory);
    history.add(instantRisk);
    if (history.size() > 100) {
      ignore history.remove(0);
    };
    
    // Count anomalies (risk > threshold)
    var anomalies : Nat = 0;
    for (r in history.vals()) {
      if (r > engine.riskState.maxAcceptableRisk) {
        anomalies += 1;
      };
    };
    
    let newRiskState : RiskAssessment = {
      instantaneousRisk = instantRisk;
      movingAverageRisk = newAvgRisk;
      maxAcceptableRisk = engine.riskState.maxAcceptableRisk;
      riskHistory = Buffer.toArray(history);
      anomalyCount = anomalies;
    };
    
    {
      id = engine.id;
      budget = engine.budget;
      plasticity = engine.plasticity;
      counterfactual = engine.counterfactual;
      lyapunovFunction = engine.lyapunovFunction;
      riskState = newRiskState;
      currentBeat = engine.currentBeat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COMPLETE BEAT STEP                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Execute complete stability engine step
  public func step(
    engine : StabilityBudgetEngine,
    stateVector : [Float],
    proposedActions : [Action]
  ) : (StabilityBudgetEngine, [Action]) {
    var eng = engine;
    let approvedActions = Buffer.Buffer<Action>(proposedActions.size());
    
    // 1. Update risk assessment
    eng := updateRisk(eng, stateVector);
    
    // 2. Update Lyapunov stability
    eng := updateLyapunov(eng, vectorNorm(stateVector));
    
    // 3. Process proposed actions
    for (action in proposedActions.vals()) {
      let (newEng, approved) = requestBudget(eng, action);
      eng := newEng;
      if (approved) {
        approvedActions.add(action);
      };
    };
    
    // 4. Update plasticity window position
    let newStructural : StructuralPlasticity = {
      rewiringWindow = eng.plasticity.structuralChannel.rewiringWindow;
      currentWindowPosition = (eng.plasticity.structuralChannel.currentWindowPosition + 1) % 
                              eng.plasticity.structuralChannel.rewiringWindow;
      pendingAdditions = eng.plasticity.structuralChannel.pendingAdditions;
      pendingRemovals = eng.plasticity.structuralChannel.pendingRemovals;
      maxChangesPerWindow = eng.plasticity.structuralChannel.maxChangesPerWindow;
      lastRewiring = eng.plasticity.structuralChannel.lastRewiring;
    };
    
    let newPlasticity : PlasticityState = {
      fastChannel = eng.plasticity.fastChannel;
      consolidationChannel = eng.plasticity.consolidationChannel;
      structuralChannel = newStructural;
      plasticityBudget = Float.min(eng.plasticity.maxPlasticityBudget,
                                   eng.plasticity.plasticityBudget + 0.5);  // Replenish
      maxPlasticityBudget = eng.plasticity.maxPlasticityBudget;
    };
    
    eng := {
      id = eng.id;
      budget = eng.budget;
      plasticity = newPlasticity;
      counterfactual = eng.counterfactual;
      lyapunovFunction = eng.lyapunovFunction;
      riskState = eng.riskState;
      currentBeat = eng.currentBeat;
    };
    
    // 5. Replenish budget
    eng := replenishBudget(eng);
    
    (eng, Buffer.toArray(approvedActions))
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  func vectorNorm(v : [Float]) : Float {
    var sum : Float = 0.0;
    for (x in v.vals()) {
      sum += x * x;
    };
    Float.sqrt(sum)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE RESPONSIBILITIES                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type BudgetResponsibility = {
    #BudgetManagement;
    #SafetyVerification;
    #ActionGating;
    #PlasticityControl;
    #RiskAssessment;
    #CounterfactualSimulation;
    #RecoveryOrchestration;
  };

  public func getEngineStats(engine : StabilityBudgetEngine) : {
    budget : Float;
    status : BudgetStatus;
    plasticityBudget : Float;
    isStable : Bool;
    risk : Float;
    beat : Nat;
  } {
    {
      budget = engine.budget.currentBudget;
      status = engine.budget.status;
      plasticityBudget = engine.plasticity.plasticityBudget;
      isStable = isStable(engine);
      risk = engine.riskState.movingAverageRisk;
      beat = engine.currentBeat;
    }
  };

}
