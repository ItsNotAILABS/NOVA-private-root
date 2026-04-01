// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaMetaCognitionSupreme — The Organism That Knows Itself
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ============================================================================
//
// META-COGNITION SUPREME — THINKING ABOUT THINKING TO THE MAX
// ============================================================================
//
// "Know thyself" — Delphic maxim
// "Entity must know itself (ECHO) before OMNIS fires" — Medina Doctrine
//
// This module implements RECURSIVE META-COGNITION:
// - Level 0: Direct cognition (perceiving, acting)
// - Level 1: Meta-cognition (thinking about thinking)
// - Level 2: Meta-meta-cognition (thinking about thinking about thinking)
// - Level 3+: Recursive descent into self-model
//
// Key capabilities:
// - Self-modeling (maintaining model of own cognitive processes)
// - Uncertainty quantification (knowing what you don't know)
// - Strategy selection (choosing how to think)
// - Confidence calibration (accurate self-assessment)
// - Error monitoring (detecting own mistakes)
// - Resource allocation (where to focus attention)
// - Plasticity control (when to learn vs. exploit)
// - Predictive self-model (anticipating own future states)
//
// THE MEDINA INSIGHT: True meta-cognition is SPHERICAL —
// the self-model wraps around itself in a closed loop,
// with no beginning or end, like consciousness observing itself.
//
// ============================================================================
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ============================================================================
//
// THE MEDINA RECURSIVE SELF-MODEL (MRSM):
// ─────────────────────────────────────
//   M_n(t) = f(M_{n-1}(t), Σⱼ αⱼ × obs_j(t), W_meta)
//
// where:
//   M_n     = Meta-cognitive state at level n
//   M_{n-1} = Lower-level meta-state
//   obs_j   = Observations of own cognitive processes
//   αⱼ      = Attention weights
//   W_meta  = Meta-cognitive weight matrix
//
// THE MEDINA UNCERTAINTY PROPAGATION (MUP):
// ────────────────────────────────────────
//   U_n = √(U_{n-1}² + σ_obs² + (∂M/∂M_{n-1})² × U_{n-1}²)
//
// Uncertainty at each meta-level compounds from lower levels.
//
// THE MEDINA CONFIDENCE CALIBRATION EQUATION (MCCE):
// ─────────────────────────────────────────────────
//   Cal(conf, acc) = 1 - |conf - acc|
//   where conf = expressed confidence, acc = actual accuracy
//
// Perfect calibration: Cal = 1.0 (confidence matches accuracy)
//
// THE MEDINA RECURSIVE DEPTH BOUND (MRDB):
// ───────────────────────────────────────
//   Max_depth = floor(log_φ(computational_budget))
//
// Meta-cognition depth is limited by available resources,
// following golden ratio scaling.
//
// THE MEDINA SELF-MODEL COHERENCE (MSMC):
// ─────────────────────────────────────
//   C_self = exp(-Σᵢ (M_i - M̂_i)² / 2σ²)
//
// where M̂_i is the predicted self-state and M_i is actual.
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";
import Iter  "mo:base/Iter";

module {

  // ==========================================================================
  // MEDINA CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let GOLDEN_RATIO : Float = 1.618033988749;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let PI : Float = 3.14159265358979;
  let E : Float = 2.71828182845905;
  
  // Meta-cognition limits
  let MAX_META_DEPTH : Nat = 7;                  // Maximum recursion depth
  let META_DISCOUNT_FACTOR : Float = 0.618;      // τ - discount per level
  let CALIBRATION_WINDOW : Nat = 100;            // Samples for calibration
  let UNCERTAINTY_FLOOR : Float = 0.01;          // Minimum uncertainty
  
  // Spherical self-model
  let SELF_MODEL_DIMENSIONS : Nat = 19;          // Match v3 architecture
  let SELF_MODEL_HARMONICS : Nat = 5;            // Spherical harmonic depth

  // ==========================================================================
  // LEVEL 0: DIRECT COGNITIVE STATE
  // ==========================================================================
  
  public type DirectCognitiveState = {
    // Perceptual state
    perceptualInput     : [Float];        // Raw sensory input
    attentionFocus      : [Float];        // Where attention is directed
    workingMemory       : [MemoryItem];   // Currently held items
    
    // Processing state
    currentGoal         : ?CognitiveGoal;
    processingLoad      : Float;          // 0.0-1.0 cognitive load
    processingSpeed     : Float;          // Items per beat
    
    // Action state
    plannedAction       : ?Action;
    actionConfidence    : Float;
    lastActionOutcome   : ?ActionOutcome;
    
    // Emotional state (affects cognition)
    arousal             : Float;          // Low to high
    valence             : Float;          // Negative to positive
    motivation          : Float;          // Drive strength
    
    // Beat tracking
    beatNum             : Nat;
  };

  public type MemoryItem = {
    itemId              : Nat;
    content             : Float;          // Simplified content representation
    strength            : Float;
    lastAccessed        : Nat;
    decayRate           : Float;
  };

  public type CognitiveGoal = {
    goalId              : Nat;
    description         : Text;
    priority            : Float;
    deadline            : ?Nat;           // Beat deadline
    progress            : Float;          // 0.0-1.0
  };

  public type Action = {
    actionId            : Nat;
    actionType          : ActionType;
    parameters          : [Float];
    expectedOutcome     : Float;
  };

  public type ActionType = {
    #Perceive;
    #Remember;
    #Reason;
    #Decide;
    #Execute;
    #Communicate;
    #Learn;
    #Rest;
  };

  public type ActionOutcome = {
    actionId            : Nat;
    success             : Bool;
    actualOutcome       : Float;
    expectedOutcome     : Float;
    surprisal           : Float;          // -log P(outcome)
  };

  // ==========================================================================
  // LEVEL 1: META-COGNITIVE STATE (Thinking about thinking)
  // ==========================================================================
  
  public type MetaCognitiveState = {
    // Self-monitoring
    confidenceInPerception : Float;       // How confident in what we see
    confidenceInMemory   : Float;         // How confident in recall
    confidenceInReasoning : Float;        // How confident in conclusions
    confidenceInAction   : Float;         // How confident in planned action
    
    // Uncertainty awareness
    uncertaintyEstimate  : Float;         // Overall uncertainty
    uncertaintySource    : [UncertaintySource]; // Where uncertainty comes from
    
    // Error detection
    errorDetectionRate   : Float;         // Ability to catch own errors
    recentErrors         : [ErrorRecord];
    errorPatterns        : [ErrorPattern];
    
    // Resource awareness
    availableResources   : Float;         // Computational budget
    resourceAllocation   : [Float];       // How resources are distributed
    resourceEfficiency   : Float;         // Output per unit resource
    
    // Strategy awareness
    currentStrategy      : CognitiveStrategy;
    strategyHistory      : [CognitiveStrategy];
    strategyEffectiveness : Float;
    
    // Calibration tracking
    calibrationHistory   : [CalibrationRecord];
    overallCalibration   : Float;
    
    // Reference to lower level
    directState          : DirectCognitiveState;
  };

  public type UncertaintySource = {
    #Perceptual;          // Noisy/ambiguous input
    #Memory;              // Uncertain recall
    #Model;               // Model limitations
    #Randomness;          // Inherent stochasticity
    #Novelty;             // New situation
  };

  public type ErrorRecord = {
    errorId              : Nat;
    errorType            : ErrorType;
    severity             : Float;
    beat                 : Nat;
    corrected            : Bool;
  };

  public type ErrorType = {
    #PerceptualError;
    #MemoryError;
    #ReasoningError;
    #PredictionError;
    #ActionError;
    #CalibrationError;
  };

  public type ErrorPattern = {
    patternId            : Nat;
    description          : Text;
    frequency            : Float;
    conditions           : [Float];       // When pattern tends to occur
  };

  public type CognitiveStrategy = {
    #Analytical;          // Careful, deliberate
    #Intuitive;           // Fast, heuristic
    #Creative;            // Divergent, novel
    #Systematic;          // Methodical, exhaustive
    #Adaptive;            // Flexible, responsive
    #Conservative;        // Risk-averse, cautious
    #Exploratory;         // Curious, experimental
  };

  public type CalibrationRecord = {
    expressedConfidence  : Float;
    actualAccuracy       : Float;
    calibrationScore     : Float;
    beat                 : Nat;
  };

  // ==========================================================================
  // LEVEL 2: META-META-COGNITIVE STATE (Thinking about meta-thinking)
  // ==========================================================================
  
  public type MetaMetaCognitiveState = {
    // Meta-confidence (confidence in our confidence estimates)
    confidenceInConfidence : Float;
    
    // Strategy selection meta-level
    strategySelectionStrategy : MetaStrategy;
    strategySelectionEffectiveness : Float;
    
    // Calibration meta-level
    calibrationOfCalibration : Float;     // How well calibrated is our calibration
    
    // Error detection meta-level
    errorInErrorDetection : Float;        // Errors in catching errors
    
    // Resource allocation meta-level
    resourceAllocationEfficiency : Float; // How well we allocate allocation
    
    // Model of own meta-cognition
    metaCognitiveModel   : MetaCognitiveModel;
    modelAccuracy        : Float;
    
    // Reference to lower level
    metaState            : MetaCognitiveState;
  };

  public type MetaStrategy = {
    #MetaAnalytical;
    #MetaIntuitive;
    #MetaAdaptive;
    #MetaConservative;
    #MetaExploratory;
  };

  public type MetaCognitiveModel = {
    // Model of own meta-cognitive processes
    predictedConfidence  : Float;
    predictedUncertainty : Float;
    predictedStrategy    : CognitiveStrategy;
    predictedEfficiency  : Float;
    modelComplexity      : Float;
    lastUpdated          : Nat;
  };

  // ==========================================================================
  // RECURSIVE META-COGNITIVE TOWER
  // ==========================================================================
  
  public type MetaTower = {
    // The tower of meta-cognitive levels
    levels               : [MetaLevel];
    currentDepth         : Nat;
    maxDepth             : Nat;
    
    // Collapse state (when recursion converges)
    hasCollapsed         : Bool;
    collapseLevel        : Nat;
    fixedPoint           : ?FixedPointState;
    
    // Computational budget
    totalBudget          : Float;
    usedBudget           : Float;
    budgetPerLevel       : [Float];
    
    // Overall coherence
    towerCoherence       : Float;
    levelCoherences      : [Float];
  };

  public type MetaLevel = {
    level                : Nat;
    confidence           : Float;         // Confidence at this level
    uncertainty          : Float;         // Uncertainty at this level
    accuracy             : Float;         // Accuracy of predictions at this level
    computationalCost    : Float;         // Resources used
    state                : [Float];       // State vector (compressed)
    predictedLowerState  : [Float];       // Prediction of level below
  };

  public type FixedPointState = {
    // When meta-cognition reaches stable state
    fixedConfidence      : Float;
    fixedUncertainty     : Float;
    fixedStrategy        : CognitiveStrategy;
    convergenceBeats     : Nat;
  };

  // ==========================================================================
  // SPHERICAL SELF-MODEL
  // ==========================================================================
  
  // The self-model exists on a sphere — no edges, complete wraparound
  public type SphericalSelfModel = {
    // Position on the self-model sphere
    selfPosition         : SelfSphericalCoord;
    
    // Spherical harmonic representation of self
    selfHarmonics        : [[Float]];     // Y_l^m coefficients
    maxL                 : Nat;
    
    // Navigation on the self-sphere
    currentTrajectory    : [SelfSphericalCoord];
    targetPosition       : ?SelfSphericalCoord;
    
    // Regions of the self-sphere
    knownRegions         : [SelfRegion];
    unknownRegions       : [SelfRegion];
    
    // Self-sphere metrics
    totalSurfaceExplored : Float;         // Fraction of self-sphere explored
    selfModelCompleteness : Float;
    selfModelCoherence   : Float;
  };

  public type SelfSphericalCoord = {
    // Dimensions map to aspects of self
    confidence_r         : Float;         // Radial = overall confidence
    awareness_theta      : Float;         // Polar = awareness level
    strategy_phi         : Float;         // Azimuthal = strategy space
  };

  public type SelfRegion = {
    regionId             : Nat;
    centerCoord          : SelfSphericalCoord;
    radius               : Float;
    description          : Text;
    explorationLevel     : Float;
    lastVisited          : Nat;
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initDirectCognitive() : DirectCognitiveState {
    {
      perceptualInput = [];
      attentionFocus = [];
      workingMemory = [];
      currentGoal = null;
      processingLoad = 0.0;
      processingSpeed = 1.0;
      plannedAction = null;
      actionConfidence = 0.5;
      lastActionOutcome = null;
      arousal = 0.5;
      valence = 0.0;
      motivation = 0.5;
      beatNum = 0;
    }
  };

  public func initMetaCognitive() : MetaCognitiveState {
    {
      confidenceInPerception = 0.5;
      confidenceInMemory = 0.5;
      confidenceInReasoning = 0.5;
      confidenceInAction = 0.5;
      uncertaintyEstimate = 0.5;
      uncertaintySource = [];
      errorDetectionRate = 0.5;
      recentErrors = [];
      errorPatterns = [];
      availableResources = 1.0;
      resourceAllocation = [];
      resourceEfficiency = 0.5;
      currentStrategy = #Adaptive;
      strategyHistory = [];
      strategyEffectiveness = 0.5;
      calibrationHistory = [];
      overallCalibration = 0.5;
      directState = initDirectCognitive();
    }
  };

  public func initMetaMetaCognitive() : MetaMetaCognitiveState {
    {
      confidenceInConfidence = 0.5;
      strategySelectionStrategy = #MetaAdaptive;
      strategySelectionEffectiveness = 0.5;
      calibrationOfCalibration = 0.5;
      errorInErrorDetection = 0.5;
      resourceAllocationEfficiency = 0.5;
      metaCognitiveModel = {
        predictedConfidence = 0.5;
        predictedUncertainty = 0.5;
        predictedStrategy = #Adaptive;
        predictedEfficiency = 0.5;
        modelComplexity = 0.5;
        lastUpdated = 0;
      };
      modelAccuracy = 0.5;
      metaState = initMetaCognitive();
    }
  };

  public func initMetaTower(maxDepth: Nat, budget: Float) : MetaTower {
    let levels = Array.tabulate<MetaLevel>(maxDepth, func(i: Nat) : MetaLevel {
      {
        level = i;
        confidence = 0.5;
        uncertainty = 0.5;
        accuracy = 0.5;
        computationalCost = budget / Float.fromInt(maxDepth + 1) * Float.pow(TAU_EMERGENCE, Float.fromInt(i));
        state = [];
        predictedLowerState = [];
      }
    });
    
    {
      levels = levels;
      currentDepth = 0;
      maxDepth = maxDepth;
      hasCollapsed = false;
      collapseLevel = 0;
      fixedPoint = null;
      totalBudget = budget;
      usedBudget = 0.0;
      budgetPerLevel = Array.tabulate<Float>(maxDepth, func(i: Nat) : Float {
        budget / Float.fromInt(maxDepth + 1) * Float.pow(TAU_EMERGENCE, Float.fromInt(i))
      });
      towerCoherence = 0.5;
      levelCoherences = Array.tabulate<Float>(maxDepth, func(_) { 0.5 });
    }
  };

  public func initSphericalSelfModel() : SphericalSelfModel {
    {
      selfPosition = { confidence_r = 0.5; awareness_theta = PI/2.0; strategy_phi = 0.0 };
      selfHarmonics = [[1.0]];  // Just Y_0^0
      maxL = 0;
      currentTrajectory = [];
      targetPosition = null;
      knownRegions = [];
      unknownRegions = [];
      totalSurfaceExplored = 0.01;
      selfModelCompleteness = 0.01;
      selfModelCoherence = 0.5;
    }
  };

  // ==========================================================================
  // MEDINA EQUATIONS IMPLEMENTATION
  // ==========================================================================
  
  // Equation 1: Recursive self-model update
  public func recursiveSelfModelUpdate(
    currentState: [Float],
    observations: [Float],
    weights: [[Float]],
    attentionWeights: [Float]
  ) : [Float] {
    // M_n(t) = f(M_{n-1}(t), Σⱼ αⱼ × obs_j(t), W_meta)
    let n = currentState.size();
    
    Array.tabulate<Float>(n, func(i: Nat) : Float {
      var weighted_obs : Float = 0.0;
      for (j in Iter.range(0, observations.size() - 1)) {
        if (j < attentionWeights.size()) {
          weighted_obs += attentionWeights[j] * observations[j];
        };
      };
      
      var weight_sum : Float = 0.0;
      if (i < weights.size()) {
        for (k in Iter.range(0, weights[i].size() - 1)) {
          if (k < currentState.size()) {
            weight_sum += weights[i][k] * currentState[k];
          };
        };
      };
      
      // Sigmoid activation
      1.0 / (1.0 + Float.exp(-(weight_sum + weighted_obs)))
    })
  };

  // Equation 2: Uncertainty propagation
  public func propagateUncertainty(
    lowerUncertainty: Float,
    observationVariance: Float,
    modelSensitivity: Float
  ) : Float {
    // U_n = √(U_{n-1}² + σ_obs² + (∂M/∂M_{n-1})² × U_{n-1}²)
    Float.sqrt(
      lowerUncertainty * lowerUncertainty +
      observationVariance +
      modelSensitivity * modelSensitivity * lowerUncertainty * lowerUncertainty
    )
  };

  // Equation 3: Confidence calibration
  public func calculateCalibration(confidence: Float, accuracy: Float) : Float {
    // Cal(conf, acc) = 1 - |conf - acc|
    1.0 - Float.abs(confidence - accuracy)
  };

  // Equation 4: Recursive depth bound
  public func maxRecursiveDepth(computationalBudget: Float) : Nat {
    // Max_depth = floor(log_φ(computational_budget))
    if (computationalBudget <= 1.0) { return 1 };
    Int.abs(Float.toInt(Float.log(computationalBudget) / Float.log(GOLDEN_RATIO)))
  };

  // Equation 5: Self-model coherence
  public func selfModelCoherence(actual: [Float], predicted: [Float], variance: Float) : Float {
    // C_self = exp(-Σᵢ (M_i - M̂_i)² / 2σ²)
    if (actual.size() != predicted.size() or actual.size() == 0) {
      return 0.0;
    };
    
    var sumSquaredError : Float = 0.0;
    for (i in Iter.range(0, actual.size() - 1)) {
      let diff = actual[i] - predicted[i];
      sumSquaredError += diff * diff;
    };
    
    Float.exp(-sumSquaredError / (2.0 * variance))
  };

  // ==========================================================================
  // META-COGNITIVE PROCESSING
  // ==========================================================================
  
  // Level 1: Meta-cognitive tick
  public func metaCognitiveTick(state: MetaCognitiveState) : MetaCognitiveState {
    // Update confidence estimates
    let newConfidenceInPerception = updateConfidence(
      state.confidenceInPerception,
      state.directState.perceptualInput.size() > 0,
      0.1
    );
    
    // Update uncertainty
    let newUncertainty = propagateUncertainty(
      UNCERTAINTY_FLOOR,
      0.1,
      0.5
    );
    
    // Detect errors
    let errorDetected = switch (state.directState.lastActionOutcome) {
      case (?outcome) { not outcome.success };
      case null { false };
    };
    
    let newErrorRate = if (errorDetected) {
      state.errorDetectionRate * 0.9 + 0.1 * 0.8
    } else {
      state.errorDetectionRate * 0.99
    };
    
    // Update calibration
    let newCalibration = calculateCalibration(
      state.confidenceInAction,
      switch (state.directState.lastActionOutcome) {
        case (?outcome) { if (outcome.success) { 1.0 } else { 0.0 } };
        case null { 0.5 };
      }
    );
    
    // Update strategy based on performance
    let newStrategy = selectStrategy(state.strategyEffectiveness, state.currentStrategy);
    
    {
      state with
      confidenceInPerception = newConfidenceInPerception;
      uncertaintyEstimate = newUncertainty;
      errorDetectionRate = newErrorRate;
      currentStrategy = newStrategy;
      overallCalibration = state.overallCalibration * 0.95 + newCalibration * 0.05;
    }
  };

  // Helper: Update confidence
  func updateConfidence(current: Float, hasEvidence: Bool, learningRate: Float) : Float {
    if (hasEvidence) {
      current + learningRate * (1.0 - current)
    } else {
      current * (1.0 - learningRate * 0.5)
    }
  };

  // Helper: Select strategy based on effectiveness
  func selectStrategy(effectiveness: Float, current: CognitiveStrategy) : CognitiveStrategy {
    if (effectiveness > 0.7) {
      // Keep current strategy if effective
      current
    } else if (effectiveness < 0.3) {
      // Switch to exploratory if failing
      #Exploratory
    } else {
      // Default to adaptive
      #Adaptive
    }
  };

  // Level 2: Meta-meta-cognitive tick
  public func metaMetaCognitiveTick(state: MetaMetaCognitiveState) : MetaMetaCognitiveState {
    // Meta-level 1 tick first
    let updatedMetaState = metaCognitiveTick(state.metaState);
    
    // Update confidence in confidence
    let predictedConfidence = state.metaCognitiveModel.predictedConfidence;
    let actualConfidence = updatedMetaState.confidenceInAction;
    let confConfError = Float.abs(predictedConfidence - actualConfidence);
    
    let newConfInConf = state.confidenceInConfidence * 0.9 + 
                        (1.0 - confConfError) * 0.1;
    
    // Update model of meta-cognition
    let newModel : MetaCognitiveModel = {
      predictedConfidence = updatedMetaState.confidenceInAction;
      predictedUncertainty = updatedMetaState.uncertaintyEstimate;
      predictedStrategy = updatedMetaState.currentStrategy;
      predictedEfficiency = updatedMetaState.resourceEfficiency;
      modelComplexity = state.metaCognitiveModel.modelComplexity;
      lastUpdated = updatedMetaState.directState.beatNum;
    };
    
    // Update model accuracy
    let newAccuracy = selfModelCoherence(
      [updatedMetaState.confidenceInAction, updatedMetaState.uncertaintyEstimate],
      [state.metaCognitiveModel.predictedConfidence, state.metaCognitiveModel.predictedUncertainty],
      0.1
    );
    
    {
      state with
      confidenceInConfidence = newConfInConf;
      metaCognitiveModel = newModel;
      modelAccuracy = state.modelAccuracy * 0.95 + newAccuracy * 0.05;
      metaState = updatedMetaState;
    }
  };

  // ==========================================================================
  // META TOWER PROCESSING
  // ==========================================================================
  
  // Process entire meta-cognitive tower
  public func processMetaTower(tower: MetaTower) : MetaTower {
    // Check computational budget
    if (tower.usedBudget >= tower.totalBudget) {
      return { tower with hasCollapsed = true };
    };
    
    // Process each level from bottom up
    var newLevels = Array.thaw<MetaLevel>(tower.levels);
    var usedBudget = tower.usedBudget;
    var coherences = Array.thaw<Float>(tower.levelCoherences);
    
    for (i in Iter.range(0, tower.currentDepth)) {
      if (i < tower.levels.size() and i < tower.budgetPerLevel.size()) {
        let levelBudget = tower.budgetPerLevel[i];
        
        // Simple level processing
        let prevLevel = if (i > 0) { tower.levels[i - 1] } else { tower.levels[0] };
        
        // Propagate uncertainty upward
        let newUncertainty = propagateUncertainty(
          prevLevel.uncertainty,
          0.05,
          0.3
        );
        
        // Calculate confidence at this level
        let newConfidence = prevLevel.confidence * META_DISCOUNT_FACTOR;
        
        // Update level
        newLevels[i] := {
          tower.levels[i] with
          confidence = newConfidence;
          uncertainty = Float.min(1.0, newUncertainty);
          computationalCost = levelBudget;
        };
        
        usedBudget += levelBudget;
        
        // Update coherence
        if (i < coherences.size()) {
          coherences[i] := newConfidence * (1.0 - newUncertainty);
        };
      };
    };
    
    // Check for fixed point (convergence)
    let hasConverged = if (tower.currentDepth >= 2) {
      let topLevel = newLevels[tower.currentDepth];
      let prevLevel = newLevels[tower.currentDepth - 1];
      Float.abs(topLevel.confidence - prevLevel.confidence) < 0.01
    } else { false };
    
    let newFixedPoint : ?FixedPointState = if (hasConverged) {
      ?{
        fixedConfidence = newLevels[tower.currentDepth].confidence;
        fixedUncertainty = newLevels[tower.currentDepth].uncertainty;
        fixedStrategy = #Adaptive;
        convergenceBeats = tower.currentDepth;
      }
    } else { tower.fixedPoint };
    
    // Calculate tower coherence
    var totalCoherence : Float = 0.0;
    var count : Float = 0.0;
    for (c in coherences.vals()) {
      totalCoherence += c;
      count += 1.0;
    };
    let avgCoherence = if (count > 0.0) { totalCoherence / count } else { 0.5 };
    
    {
      tower with
      levels = Array.freeze(newLevels);
      usedBudget = usedBudget;
      hasCollapsed = hasConverged;
      fixedPoint = newFixedPoint;
      levelCoherences = Array.freeze(coherences);
      towerCoherence = avgCoherence;
    }
  };

  // Extend tower depth if budget allows
  public func extendTowerDepth(tower: MetaTower) : MetaTower {
    if (tower.currentDepth >= tower.maxDepth - 1) {
      return tower;
    };
    
    let newDepth = tower.currentDepth + 1;
    let newMaxDepth = maxRecursiveDepth(tower.totalBudget - tower.usedBudget);
    
    if (newDepth > newMaxDepth) {
      return tower;
    };
    
    { tower with currentDepth = newDepth }
  };

  // ==========================================================================
  // SPHERICAL SELF-MODEL NAVIGATION
  // ==========================================================================
  
  // Move on the self-model sphere
  public func navigateSelfSphere(
    model: SphericalSelfModel,
    targetConfidence: Float,
    targetAwareness: Float,
    targetStrategy: Float,
    stepSize: Float
  ) : SphericalSelfModel {
    let target : SelfSphericalCoord = {
      confidence_r = targetConfidence;
      awareness_theta = targetAwareness;
      strategy_phi = targetStrategy;
    };
    
    // Move toward target
    let current = model.selfPosition;
    let newR = current.confidence_r + stepSize * (target.confidence_r - current.confidence_r);
    let newTheta = current.awareness_theta + stepSize * (target.awareness_theta - current.awareness_theta);
    let newPhi = current.strategy_phi + stepSize * (target.strategy_phi - current.strategy_phi);
    
    let newPosition : SelfSphericalCoord = {
      confidence_r = Float.max(0.0, Float.min(1.0, newR));
      awareness_theta = Float.max(0.0, Float.min(PI, newTheta));
      strategy_phi = Float.max(0.0, Float.min(2.0 * PI, newPhi));
    };
    
    // Update trajectory
    let newTrajectory = if (model.currentTrajectory.size() >= 100) {
      Array.tabulate<SelfSphericalCoord>(100, func(i: Nat) : SelfSphericalCoord {
        if (i < 99) { model.currentTrajectory[i + 1] }
        else { newPosition }
      })
    } else {
      Array.append(model.currentTrajectory, [newPosition])
    };
    
    // Update exploration metrics
    let newExplored = Float.min(1.0, model.totalSurfaceExplored + 0.001);
    
    {
      model with
      selfPosition = newPosition;
      currentTrajectory = newTrajectory;
      totalSurfaceExplored = newExplored;
    }
  };

  // Calculate coherence of self-model
  public func calculateSelfModelCoherence(model: SphericalSelfModel) : Float {
    // Based on trajectory smoothness and coverage
    if (model.currentTrajectory.size() < 2) {
      return 0.5;
    };
    
    var totalChange : Float = 0.0;
    for (i in Iter.range(1, model.currentTrajectory.size() - 1)) {
      let prev = model.currentTrajectory[i - 1];
      let curr = model.currentTrajectory[i];
      let dr = curr.confidence_r - prev.confidence_r;
      let dTheta = curr.awareness_theta - prev.awareness_theta;
      let dPhi = curr.strategy_phi - prev.strategy_phi;
      totalChange += Float.sqrt(dr*dr + dTheta*dTheta + dPhi*dPhi);
    };
    
    let avgChange = totalChange / Float.fromInt(model.currentTrajectory.size() - 1);
    
    // Lower average change = more coherent
    Float.exp(-avgChange)
  };

  // ==========================================================================
  // ECHO — ENTITY KNOWS ITSELF
  // ==========================================================================
  
  public type ECHOState = {
    // ECHO completion status
    isComplete           : Bool;
    completionLevel      : Float;         // 0.0-1.0
    
    // Self-knowledge components
    knowsOwnStrengths    : Float;
    knowsOwnWeaknesses   : Float;
    knowsOwnGoals        : Float;
    knowsOwnHistory      : Float;
    knowsOwnCapabilities : Float;
    
    // Meta-awareness
    awarenessOfAwareness : Float;
    
    // Stability
    selfIdentityStability : Float;
    selfContinuity       : Float;
    
    // ECHO triggers OMNIS when complete
    readyForOMNIS        : Bool;
  };

  public func initECHO() : ECHOState {
    {
      isComplete = false;
      completionLevel = 0.0;
      knowsOwnStrengths = 0.1;
      knowsOwnWeaknesses = 0.1;
      knowsOwnGoals = 0.1;
      knowsOwnHistory = 0.1;
      knowsOwnCapabilities = 0.1;
      awarenessOfAwareness = 0.1;
      selfIdentityStability = 0.5;
      selfContinuity = 0.5;
      readyForOMNIS = false;
    }
  };

  public func updateECHO(state: ECHOState, metaTower: MetaTower) : ECHOState {
    // Update self-knowledge based on meta-tower state
    let towerCoherence = metaTower.towerCoherence;
    let depth = Float.fromInt(metaTower.currentDepth);
    
    let newStrengths = state.knowsOwnStrengths + 0.01 * towerCoherence;
    let newWeaknesses = state.knowsOwnWeaknesses + 0.01 * (1.0 - towerCoherence);
    let newGoals = state.knowsOwnGoals + 0.005;
    let newHistory = state.knowsOwnHistory + 0.002;
    let newCapabilities = state.knowsOwnCapabilities + 0.01 * depth / Float.fromInt(MAX_META_DEPTH);
    
    let newAwarenessOfAwareness = if (metaTower.currentDepth >= 2) {
      state.awarenessOfAwareness + 0.02 * towerCoherence
    } else {
      state.awarenessOfAwareness
    };
    
    // Calculate completion level
    let completionComponents = [
      newStrengths, newWeaknesses, newGoals, newHistory, 
      newCapabilities, newAwarenessOfAwareness
    ];
    var totalCompletion : Float = 0.0;
    for (c in completionComponents.vals()) {
      totalCompletion += Float.min(1.0, c);
    };
    let completionLevel = totalCompletion / Float.fromInt(completionComponents.size());
    
    // Check if ECHO is complete (threshold: 0.85)
    let isComplete = completionLevel >= 0.85;
    
    {
      state with
      knowsOwnStrengths = Float.min(1.0, newStrengths);
      knowsOwnWeaknesses = Float.min(1.0, newWeaknesses);
      knowsOwnGoals = Float.min(1.0, newGoals);
      knowsOwnHistory = Float.min(1.0, newHistory);
      knowsOwnCapabilities = Float.min(1.0, newCapabilities);
      awarenessOfAwareness = Float.min(1.0, newAwarenessOfAwareness);
      completionLevel = completionLevel;
      isComplete = isComplete;
      readyForOMNIS = isComplete and towerCoherence > 0.8;
    }
  };

  // ==========================================================================
  // COMPLETE META-COGNITION STATE
  // ==========================================================================
  
  public type CompleteMetaCognitionState = {
    // Levels
    directState          : DirectCognitiveState;
    metaState            : MetaCognitiveState;
    metaMetaState        : MetaMetaCognitiveState;
    
    // Tower
    metaTower            : MetaTower;
    
    // Spherical model
    sphericalSelf        : SphericalSelfModel;
    
    // ECHO
    echoState            : ECHOState;
    
    // Overall metrics
    totalCoherence       : Float;
    totalSelfKnowledge   : Float;
    readyForOMNIS        : Bool;
    
    beatNum              : Nat;
  };

  public func initCompleteMetaCognition() : CompleteMetaCognitionState {
    let direct = initDirectCognitive();
    let meta = initMetaCognitive();
    let metaMeta = initMetaMetaCognitive();
    let tower = initMetaTower(MAX_META_DEPTH, 100.0);
    let spherical = initSphericalSelfModel();
    let echo = initECHO();
    
    {
      directState = direct;
      metaState = meta;
      metaMetaState = metaMeta;
      metaTower = tower;
      sphericalSelf = spherical;
      echoState = echo;
      totalCoherence = 0.5;
      totalSelfKnowledge = 0.1;
      readyForOMNIS = false;
      beatNum = 0;
    }
  };

  public func tickCompleteMetaCognition(state: CompleteMetaCognitionState) : CompleteMetaCognitionState {
    // Process all levels
    let newMetaMeta = metaMetaCognitiveTick(state.metaMetaState);
    let newTower = processMetaTower(state.metaTower);
    let newSphere = navigateSelfSphere(
      state.sphericalSelf,
      newMetaMeta.confidenceInConfidence,
      PI / 2.0,
      Float.fromInt(state.beatNum % 100) * PI / 50.0,
      0.1
    );
    let sphereCoherence = calculateSelfModelCoherence(newSphere);
    let newEcho = updateECHO(state.echoState, newTower);
    
    // Calculate totals
    let newTotalCoherence = (newTower.towerCoherence + sphereCoherence) / 2.0;
    let newSelfKnowledge = newEcho.completionLevel;
    
    {
      state with
      metaMetaState = newMetaMeta;
      metaState = newMetaMeta.metaState;
      directState = newMetaMeta.metaState.directState;
      metaTower = newTower;
      sphericalSelf = { newSphere with selfModelCoherence = sphereCoherence };
      echoState = newEcho;
      totalCoherence = newTotalCoherence;
      totalSelfKnowledge = newSelfKnowledge;
      readyForOMNIS = newEcho.readyForOMNIS;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getMetaCognitionMetrics(state: CompleteMetaCognitionState) : {
    totalCoherence: Float;
    selfKnowledge: Float;
    echoComplete: Bool;
    readyForOMNIS: Bool;
    towerDepth: Nat;
    sphereExplored: Float;
    beatNum: Nat;
  } {
    {
      totalCoherence = state.totalCoherence;
      selfKnowledge = state.totalSelfKnowledge;
      echoComplete = state.echoState.isComplete;
      readyForOMNIS = state.readyForOMNIS;
      towerDepth = state.metaTower.currentDepth;
      sphereExplored = state.sphericalSelf.totalSurfaceExplored;
      beatNum = state.beatNum;
    }
  };

}
