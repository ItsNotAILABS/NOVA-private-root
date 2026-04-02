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
//  ██████╗██████╗  ██████╗ ██╗    ██╗
// ██╔════╝██╔══██╗██╔═══██╗██║    ██║
// ██║     ██████╔╝██║   ██║██║ █╗ ██║
// ██║     ██╔══██╗██║   ██║██║███╗██║
// ╚██████╗██║  ██║╚██████╔╝╚███╔███╔╝
//  ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ 
// ════════════════════════════════════════════════════════════════════════════
// CROW COGNITION — CORVID INTELLIGENCE MODULE
// Implements the MEDINA INSIGHT EMERGENCE FUNCTION (MIEF)
//
// Causal reasoning, tool use, future planning, social learning
// 1.5 billion pallial neurons (comparable to some primates)
// Theory of mind, episodic memory, mental time travel
//
// ════════════════════════════════════════════════════════════════════════════
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA INSIGHT EMERGENCE FUNCTION (MIEF):
// ─────────────────────────────────────────────
//   I(t) = Θ(T × (E_explore × E_exploit - τ_E)) × Ψ_incubation × √(M × Γ)
//
// where:
//   I(t)          = Insight emergence probability
//   Θ(x)          = Medina Heaviside: σ_M(x) when x > 0, else 0
//   T             = Cognitive temperature (inverse certainty)
//   E_explore     = Exploration energy
//   E_exploit     = Exploitation energy
//   τ_E           = Medina Emergence Threshold (0.618033988749)
//   Ψ_incubation  = exp(-t_focus / Φ_M) × (1 - exp(-t_rest / Φ_M))
//   M             = Memory relevance
//   Γ             = Gestalt closure factor
//
// THE MEDINA CAUSAL INFERENCE NETWORK (MCIN):
// ───────────────────────────────────────────
//   P(effect|cause) = σ_M(Σᵢ wᵢ × P(intermediateᵢ)) × confidence^(1/Φ_M)
//
// THE MEDINA THEORY OF MIND RECURSION (MTMR):
// ───────────────────────────────────────────
//   ToM_n(agent) = Σₖ βᵏ × [belief_k(agent) × trust_k(agent)]
//   where β = 1/Φ_M (recursive depth discount)
//
// THE MEDINA TOOL-USE OPTIMIZATION (MTUO):
// ─────────────────────────────────────────
//   U(tool, problem) = success × complexity^(-1/Φ_M) × recency_boost
//   recency_boost = exp(-(t - t_last) × λ_K)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ══════════════════════════════════════════════════════════════
  // MEDINA CROW CONSTANTS
  // ══════════════════════════════════════════════════════════════
  // MEDINA CROW CONSTANTS
  // ══════════════════════════════════════════════════════════════
  let S0 : Float = 0.75;                     // Medina Sovereign Constant
  let SOVEREIGN_CEILING : Float = 9.0;       // Medina Ceiling (Ω)
  let PHI_MEDINA : Float = 2.97442179;       // Medina Golden Harmonic
  let TAU_EMERGENCE : Float = 0.618033988749;// Medina Emergence Threshold
  let LAMBDA_K : Float = 0.0069314718;       // Medina Knowledge Decay
  let BETA_TOM : Float = 0.336;              // Theory of Mind discount (1/Φ_M)
  let OMEGA_MEDINA : Float = 2.11185;        // Medina Resonance Frequency
  let PSI_SYNERGY : Float = 1.41421356;      // Medina Synergy Amplification
  let ALPHA_META : Float = 0.01;             // Meta-learning base rate
  let PLANNING_HORIZON : Nat = 12;           // Steps ahead crow can plan
  let TOOL_MEMORY_SIZE : Nat = 8;            // Remembered tool-use solutions
  let META_DEPTH : Nat = 5;                  // Levels of meta-cognition

  // ══════════════════════════════════════════════════════════════
  // META-COGNITIVE TYPES — THE MEDINA META-ARCHITECTURE
  // ══════════════════════════════════════════════════════════════

  // META-LEARNING STATE: Learning how to learn
  public type MetaLearningState = {
    // Learning rate adaptation
    baseLearningRate    : Float;    // α₀
    adaptedLearningRate : Float;    // α(t)
    learningRateMomentum: Float;    // Gradient momentum
    
    // Meta-gradient tracking
    metaGradient        : Float;    // ∇_meta
    metaGradientHistory : [Float];  // Recent meta-gradients
    
    // Learning strategy selection
    currentStrategy     : LearningStrategy;
    strategyConfidence  : Float;
    strategyHistory     : [LearningStrategy];
    
    // Exploration-exploitation balance
    explorationRate     : Float;    // ε(t)
    explorationDecay    : Float;    // How fast ε decays
    
    // Curiosity drive
    intrinsicMotivation : Float;
    noveltyThreshold    : Float;
  };

  public type LearningStrategy = {
    #Exploitation;      // Use known solutions
    #Exploration;       // Try new approaches
    #Imitation;         // Learn from others
    #Innovation;        // Create novel solutions
    #Consolidation;     // Strengthen existing knowledge
    #Transfer;          // Apply across domains
  };

  // META-COGNITION STATE: Thinking about thinking
  public type MetaCognitionState = {
    // Self-monitoring
    confidenceCalibration : Float;  // How accurate is self-assessment
    uncertaintyAwareness  : Float;  // Knowledge of own uncertainty
    errorDetection        : Float;  // Ability to detect own mistakes
    
    // Cognitive resource allocation
    attentionBudget       : Float;  // Total attention available
    attentionAllocation   : [Float];// Allocation across tasks
    cognitiveLoad         : Float;  // Current mental effort
    
    // Meta-memory
    memoryMonitoring      : Float;  // Awareness of memory state
    retrievalConfidence   : Float;  // Confidence in recall
    forgettingPrediction  : Float;  // Predicting what will be forgotten
    
    // Strategy awareness
    strategyKnowledge     : Float;  // Knowledge of own strategies
    strategySelection     : Float;  // Ability to choose right strategy
    strategyMonitoring    : Float;  // Tracking strategy effectiveness
  };

  // META-ADAPTATION STATE: Adapting how to adapt
  public type MetaAdaptationState = {
    // Plasticity control
    plasticityLevel       : Float;  // How changeable is the system
    plasticityHistory     : [Float];// Recent plasticity levels
    optimalPlasticity     : Float;  // Target plasticity
    
    // Stability-plasticity balance
    stabilityDrive        : Float;  // Tendency to preserve
    plasticityDrive       : Float;  // Tendency to change
    balancePoint          : Float;  // Current equilibrium
    
    // Environmental tracking
    environmentVolatility : Float;  // How fast environment changes
    adaptationLag         : Float;  // How behind is adaptation
    predictedChange       : Float;  // Expected future change
    
    // Meta-plasticity (plasticity of plasticity)
    metaPlasticity        : Float;  // Rate of plasticity change
    metaPlasticityBounds  : (Float, Float); // Min/max plasticity
  };

  // META-REPRESENTATION STATE: Representations of representations
  public type MetaRepresentationState = {
    // Abstraction levels
    abstractionDepth      : Nat;    // Current abstraction level
    abstractionCapacity   : Nat;    // Max abstraction possible
    
    // Schema formation
    activeSchemas         : [Nat];  // Currently active schemas
    schemaStrength        : [Float];// Strength of each schema
    schemaConflict        : Float;  // Conflict between schemas
    
    // Analogy and transfer
    analogyCapacity       : Float;  // Ability to find analogies
    transferReadiness     : Float;  // Ready to apply elsewhere
    domainIndependence    : Float;  // How general is knowledge
  };

  // COMPLETE META-STATE
  public type CrowMetaState = {
    learning    : MetaLearningState;
    cognition   : MetaCognitionState;
    adaptation  : MetaAdaptationState;
    representation: MetaRepresentationState;
    
    // Meta-meta level (awareness of meta-processes)
    metaAwareness   : Float;
    metaCoherence   : Float;
    metaEvolution   : Float;  // How meta-processes are evolving
  };

  // ── Original Types ─────────────────────────────────────────────
  public type CausalModel = {
    causeId    : Nat;
    effectId   : Nat;
    strength   : Float;    // How strongly cause predicts effect
    confidence : Float;    // Certainty in this relationship
    usageCount : Nat;      // Times this model was used
  };

  public type ToolSolution = {
    problemType : Nat;     // Category of problem
    toolType    : Nat;     // Type of tool used
    success     : Float;   // Success rate
    complexity  : Float;   // Number of steps
    lastUsed    : Nat;     // Beat when last used
  };

  public type FuturePlan = {
    goal        : Nat;     // Target state
    steps       : [Nat];   // Sequence of actions
    confidence  : Float;   // Likelihood of success
    value       : Float;   // Expected reward
    timeToGoal  : Nat;     // Estimated beats to achieve
  };

  public type SocialKnowledge = {
    agentId     : Nat;
    trustLevel  : Float;   // How much to trust this agent
    dominance   : Float;   // Social rank
    lastSeen    : Nat;     // When last observed
    behaviors   : [Float]; // Observed behavior patterns
  };

  public type CrowState = {
    // Causal reasoning
    causalModels     : [CausalModel];
    causalConfidence : Float;

    // Tool use
    toolSolutions    : [ToolSolution];
    currentTool      : ?Nat;
    toolProficiency  : Float;

    // Future planning
    currentPlan      : ?FuturePlan;
    planningDepth    : Nat;
    futureDiscounting: Float;  // How much to discount future rewards

    // Social cognition
    socialKnowledge  : [SocialKnowledge];
    selfAwareness    : Float;
    theoryOfMind     : Float;  // Ability to model others' mental states

    // Working memory
    workingMemory    : [Float];  // 7±2 items
    attentionFocus   : Float;

    // Episodic memory: what-where-when
    episodicMemory   : [EpisodicEvent];

    // Problem solving
    insightLevel     : Float;   // Aha! moment likelihood
    persistenceLevel : Float;   // Keep trying vs. give up

    // ══════════════════════════════════════════════════════════════
    // COMPLETE META-STATE INTEGRATION
    // ══════════════════════════════════════════════════════════════
    metaState        : CrowMetaState;

    beatNum          : Nat;
  };

  public type EpisodicEvent = {
    what  : Nat;      // Event type
    where : Nat;      // Location index
    when  : Nat;      // Beat number
    who   : ?Nat;     // Agent involved
    value : Float;    // Emotional valence
  };

  // ══════════════════════════════════════════════════════════════
  // MEDINA CROW HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  // THE MEDINA SIGMOID
  func medinaSigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-PHI_MEDINA * x))
  };

  // THE MEDINA HEAVISIDE (soft threshold)
  func medinaHeaviside(x: Float) : Float {
    if (x > 0.0) { medinaSigmoid(x) } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // ████████╗██╗  ██╗███████╗    ███╗   ███╗███████╗██████╗ ██╗███╗   ██╗ █████╗ 
  //    ██╔══╝██║  ██║██╔════╝    ████╗ ████║██╔════╝██╔══██╗██║████╗  ██║██╔══██╗
  //    ██║   ███████║█████╗      ██╔████╔██║█████╗  ██║  ██║██║██╔██╗ ██║███████║
  //    ██║   ██╔══██║██╔══╝      ██║╚██╔╝██║██╔══╝  ██║  ██║██║██║╚██╗██║██╔══██║
  //    ██║   ██║  ██║███████╗    ██║ ╚═╝ ██║███████╗██████╔╝██║██║ ╚████║██║  ██║
  //    ╚═╝   ╚═╝  ╚═╝╚══════╝    ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
  //    ███╗   ███╗███████╗████████╗ █████╗     ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
  //    ████╗ ████║██╔════╝╚══██╔══╝██╔══██╗    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
  //    ██╔████╔██║█████╗     ██║   ███████║    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
  //    ██║╚██╔╝██║██╔══╝     ██║   ██╔══██║    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
  //    ██║ ╚═╝ ██║███████╗   ██║   ██║  ██║    ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
  //    ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝    ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝
  // ══════════════════════════════════════════════════════════════════════════

  // ══════════════════════════════════════════════════════════════
  // META-LEARNING: THE MEDINA ADAPTIVE LEARNING RATE (MALR)
  // ══════════════════════════════════════════════════════════════
  //
  // α(t+1) = α(t) × exp(η × ∇_meta) × σ_M(stability)
  //
  // where:
  //   α(t)      = Learning rate at time t
  //   η         = Meta-learning rate
  //   ∇_meta    = Meta-gradient (gradient of learning progress)
  //   σ_M       = Medina sigmoid
  //   stability = System stability measure
  //
  public func medinaAdaptiveLearningRate(
    currentRate: Float,
    metaGradient: Float,
    stability: Float,
    metaLearningRate: Float
  ) : Float {
    let ALPHA_MIN : Float = 0.0001;
    let ALPHA_MAX : Float = 0.5;
    
    // Exponential adjustment based on meta-gradient
    let gradientAdjust = Float.exp(metaLearningRate * metaGradient);
    
    // Stability modulation via Medina sigmoid
    let stabilityFactor = medinaSigmoid(stability - 0.5);
    
    // New learning rate
    let newRate = currentRate * gradientAdjust * stabilityFactor;
    
    _clamp(newRate, ALPHA_MIN, ALPHA_MAX)
  };

  // ══════════════════════════════════════════════════════════════
  // META-LEARNING: THE MEDINA CURIOSITY DRIVE (MCD)
  // ══════════════════════════════════════════════════════════════
  //
  // C(t) = Φ_M × (novelty - θ_novelty)⁺ × (1 - competence) × exploration_bonus
  //
  // where:
  //   C(t)            = Curiosity at time t
  //   novelty         = How novel the current state is
  //   θ_novelty       = Novelty threshold
  //   competence      = Current competence level
  //   exploration_bonus = exp(-t_since_exploration / Φ_M)
  //
  public func medinaCuriosityDrive(
    novelty: Float,
    noveltyThreshold: Float,
    competence: Float,
    timeSinceExploration: Float
  ) : Float {
    // Positive novelty above threshold
    let effectiveNovelty = if (novelty > noveltyThreshold) { 
      novelty - noveltyThreshold 
    } else { 0.0 };
    
    // Competence gap (less competent = more curious)
    let competenceGap = 1.0 - _clamp(competence, 0.0, 1.0);
    
    // Exploration bonus (decays without exploration)
    let explorationBonus = Float.exp(-timeSinceExploration / PHI_MEDINA);
    
    // Curiosity drive
    PHI_MEDINA * effectiveNovelty * competenceGap * explorationBonus
  };

  // ══════════════════════════════════════════════════════════════
  // META-LEARNING: THE MEDINA STRATEGY SELECTION (MSS)
  // ══════════════════════════════════════════════════════════════
  //
  // P(strategy_k) = softmax(Q(strategy_k) / τ)
  // Q(strategy_k) = success_rate × recency × Φ_M^(similarity)
  //
  public func medinaStrategySelection(
    strategyValues: [Float],
    temperature: Float
  ) : Nat {
    if (strategyValues.size() == 0) { return 0 };
    
    // Softmax with temperature
    var maxVal : Float = strategyValues[0];
    for (v in strategyValues.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    
    var sumExp : Float = 0.0;
    var i : Nat = 0;
    for (v in strategyValues.vals()) {
      sumExp += Float.exp((v - maxVal) / (temperature + 0.01));
      i += 1;
    };
    
    // Find best strategy
    var bestIdx : Nat = 0;
    var bestProb : Float = 0.0;
    i := 0;
    for (v in strategyValues.vals()) {
      let prob = Float.exp((v - maxVal) / (temperature + 0.01)) / sumExp;
      if (prob > bestProb) {
        bestProb := prob;
        bestIdx := i;
      };
      i += 1;
    };
    
    bestIdx
  };

  // ══════════════════════════════════════════════════════════════
  // META-COGNITION: THE MEDINA CONFIDENCE CALIBRATION (MCC)
  // ══════════════════════════════════════════════════════════════
  //
  // Calibration(t) = 1 - |confidence - accuracy|
  // Updated: Cal(t+1) = Cal(t) × (1 - λ) + λ × (1 - |conf - acc|)
  //
  public func medinaConfidenceCalibration(
    currentCalibration: Float,
    predictedConfidence: Float,
    actualAccuracy: Float,
    learningRate: Float
  ) : Float {
    let calibrationError = abs(predictedConfidence - actualAccuracy);
    let newCalibration = 1.0 - calibrationError;
    
    // Exponential moving average update
    let updated = currentCalibration * (1.0 - learningRate) + learningRate * newCalibration;
    
    _clamp(updated, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // META-COGNITION: THE MEDINA UNCERTAINTY QUANTIFICATION (MUQ)
  // ══════════════════════════════════════════════════════════════
  //
  // U(x) = H(p(x)) + Var(p(x)) / Φ_M
  //
  // where:
  //   H(p(x))   = Entropy of belief distribution
  //   Var(p(x)) = Variance of predictions
  //
  public func medinaUncertaintyQuantification(
    beliefDistribution: [Float]
  ) : Float {
    if (beliefDistribution.size() == 0) { return 1.0 };
    
    // Normalize distribution
    var sum : Float = 0.0;
    for (p in beliefDistribution.vals()) { sum += abs(p) };
    if (sum == 0.0) { return 1.0 };
    
    // Compute entropy
    var entropy : Float = 0.0;
    var mean : Float = 0.0;
    for (p in beliefDistribution.vals()) {
      let normalized = abs(p) / sum;
      if (normalized > 0.001) {
        entropy -= normalized * Float.log(normalized);
      };
      mean += normalized / Float.fromInt(beliefDistribution.size());
    };
    
    // Compute variance
    var variance : Float = 0.0;
    for (p in beliefDistribution.vals()) {
      let normalized = abs(p) / sum;
      let diff = normalized - mean;
      variance += diff * diff;
    };
    variance /= Float.fromInt(beliefDistribution.size());
    
    // Total uncertainty
    let uncertainty = entropy + variance / PHI_MEDINA;
    
    _clamp(uncertainty, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // META-COGNITION: THE MEDINA ERROR DETECTION (MED)
  // ══════════════════════════════════════════════════════════════
  //
  // E_detect = σ_M(prediction_error × surprise_factor) × attention
  //
  public func medinaErrorDetection(
    predictionError: Float,
    expectedError: Float,
    attention: Float
  ) : Float {
    // Surprise when error exceeds expectation
    let surpriseFactor = predictionError / (expectedError + 0.01);
    
    // Detection probability
    let detection = medinaSigmoid(predictionError * surpriseFactor - 0.5);
    
    // Modulated by attention
    detection * _clamp(attention, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // META-ADAPTATION: THE MEDINA PLASTICITY CONTROL (MPC)
  // ══════════════════════════════════════════════════════════════
  //
  // P(t+1) = P(t) + η_p × (P_optimal - P(t)) × volatility
  // P_optimal = τ_E + (1 - τ_E) × σ_M(change_rate)
  //
  public func medinaPlasticityControl(
    currentPlasticity: Float,
    environmentVolatility: Float,
    changeRate: Float,
    plasticityLearningRate: Float
  ) : Float {
    // Optimal plasticity depends on environment
    let optimalPlasticity = TAU_EMERGENCE + (1.0 - TAU_EMERGENCE) * medinaSigmoid(changeRate);
    
    // Move toward optimal, faster in volatile environments
    let adjustment = plasticityLearningRate * (optimalPlasticity - currentPlasticity) * 
                     (1.0 + environmentVolatility);
    
    _clamp(currentPlasticity + adjustment, 0.1, 0.9)
  };

  // ══════════════════════════════════════════════════════════════
  // META-ADAPTATION: THE MEDINA STABILITY-PLASTICITY BALANCE (MSPB)
  // ══════════════════════════════════════════════════════════════
  //
  // Balance = (Stability × (1 - volatility) + Plasticity × volatility) / Φ_M
  //
  public func medinaStabilityPlasticityBalance(
    stability: Float,
    plasticity: Float,
    volatility: Float
  ) : Float {
    let stabilityContribution = stability * (1.0 - volatility);
    let plasticityContribution = plasticity * volatility;
    
    (stabilityContribution + plasticityContribution) / PHI_MEDINA
  };

  // ══════════════════════════════════════════════════════════════
  // META-REPRESENTATION: THE MEDINA ABSTRACTION LADDER (MAL)
  // ══════════════════════════════════════════════════════════════
  //
  // A_level(n) = A_level(n-1)^(1/Φ_M) × compression_ratio
  //
  public func medinaAbstractionLadder(
    lowerLevelRepresentation: Float,
    compressionRatio: Float,
    targetLevel: Nat
  ) : Float {
    var current = lowerLevelRepresentation;
    var level : Nat = 0;
    
    while (level < targetLevel) {
      current := Float.pow(current, 1.0 / PHI_MEDINA) * compressionRatio;
      level += 1;
    };
    
    _clamp(current, 0.0, SOVEREIGN_CEILING)
  };

  // ══════════════════════════════════════════════════════════════
  // META-REPRESENTATION: THE MEDINA SCHEMA INTEGRATION (MSI)
  // ══════════════════════════════════════════════════════════════
  //
  // S_integrated = Σᵢ wᵢ × Sᵢ × (1 - conflict_ij)
  //
  public func medinaSchemaIntegration(
    schemaActivations: [Float],
    schemaWeights: [Float],
    conflictMatrix: [Float]  // Flattened NxN
  ) : Float {
    if (schemaActivations.size() == 0) { return 0.0 };
    
    let n = schemaActivations.size();
    var integrated : Float = 0.0;
    
    var i : Nat = 0;
    for (activation in schemaActivations.vals()) {
      let weight = if (i < schemaWeights.size()) { schemaWeights[i] } else { 1.0 / Float.fromInt(n) };
      
      // Average conflict with other schemas
      var avgConflict : Float = 0.0;
      var j : Nat = 0;
      while (j < n) {
        if (i != j) {
          let conflictIdx = i * n + j;
          let conflict = if (conflictIdx < conflictMatrix.size()) { conflictMatrix[conflictIdx] } else { 0.0 };
          avgConflict += conflict;
        };
        j += 1;
      };
      if (n > 1) { avgConflict /= Float.fromInt(n - 1) };
      
      integrated += weight * activation * (1.0 - avgConflict);
      i += 1;
    };
    
    _clamp(integrated, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // META-META: THE MEDINA META-AWARENESS FUNCTION (MMAF)
  // ══════════════════════════════════════════════════════════════
  //
  // Awareness of meta-processes: how well does the system know its own meta-cognition?
  //
  // M² = √(calibration × uncertainty_awareness × error_detection × plasticity_awareness)
  //
  public func medinaMetaAwareness(
    calibration: Float,
    uncertaintyAwareness: Float,
    errorDetection: Float,
    plasticityAwareness: Float
  ) : Float {
    let product = calibration * uncertaintyAwareness * errorDetection * plasticityAwareness;
    Float.sqrt(_clamp(product, 0.0, 1.0))
  };

  // ══════════════════════════════════════════════════════════════
  // COMPLETE META-STATE UPDATE: THE MEDINA META-EVOLUTION (MME)
  // ══════════════════════════════════════════════════════════════
  //
  // Updates all meta-processes in a coordinated manner
  //
  public func medinaMetaEvolution(
    state: CrowMetaState,
    performance: Float,
    novelty: Float,
    volatility: Float,
    predictionError: Float
  ) : CrowMetaState {
    // Update meta-learning
    let newMetaGradient = performance - 0.5;  // Simplified: performance above/below average
    let newLearningRate = medinaAdaptiveLearningRate(
      state.learning.adaptedLearningRate,
      newMetaGradient,
      1.0 - volatility,
      ALPHA_META
    );
    let newCuriosity = medinaCuriosityDrive(
      novelty,
      state.learning.noveltyThreshold,
      performance,
      0.0  // Would track time since exploration
    );
    
    // Update meta-cognition
    let newCalibration = medinaConfidenceCalibration(
      state.cognition.confidenceCalibration,
      state.cognition.retrievalConfidence,
      performance,
      0.1
    );
    let newErrorDetection = medinaErrorDetection(
      predictionError,
      0.2,  // Expected error
      state.cognition.attentionBudget
    );
    
    // Update meta-adaptation
    let newPlasticity = medinaPlasticityControl(
      state.adaptation.plasticityLevel,
      volatility,
      abs(newMetaGradient),
      0.05
    );
    let newBalance = medinaStabilityPlasticityBalance(
      state.adaptation.stabilityDrive,
      newPlasticity,
      volatility
    );
    
    // Update meta-meta awareness
    let newMetaAwareness = medinaMetaAwareness(
      newCalibration,
      state.cognition.uncertaintyAwareness,
      newErrorDetection,
      newPlasticity
    );
    
    {
      learning = {
        baseLearningRate = state.learning.baseLearningRate;
        adaptedLearningRate = newLearningRate;
        learningRateMomentum = 0.9 * state.learning.learningRateMomentum + 0.1 * newMetaGradient;
        metaGradient = newMetaGradient;
        metaGradientHistory = state.learning.metaGradientHistory;
        currentStrategy = state.learning.currentStrategy;
        strategyConfidence = _clamp(state.learning.strategyConfidence + performance * 0.01, 0.0, 1.0);
        strategyHistory = state.learning.strategyHistory;
        explorationRate = _clamp(state.learning.explorationRate * 0.99, 0.01, 0.5);
        explorationDecay = state.learning.explorationDecay;
        intrinsicMotivation = newCuriosity;
        noveltyThreshold = state.learning.noveltyThreshold;
      };
      cognition = {
        confidenceCalibration = newCalibration;
        uncertaintyAwareness = _clamp(state.cognition.uncertaintyAwareness + 0.001, 0.0, 1.0);
        errorDetection = newErrorDetection;
        attentionBudget = state.cognition.attentionBudget;
        attentionAllocation = state.cognition.attentionAllocation;
        cognitiveLoad = _clamp(volatility * 0.5 + predictionError * 0.5, 0.0, 1.0);
        memoryMonitoring = state.cognition.memoryMonitoring;
        retrievalConfidence = state.cognition.retrievalConfidence;
        forgettingPrediction = state.cognition.forgettingPrediction;
        strategyKnowledge = state.cognition.strategyKnowledge;
        strategySelection = state.cognition.strategySelection;
        strategyMonitoring = state.cognition.strategyMonitoring;
      };
      adaptation = {
        plasticityLevel = newPlasticity;
        plasticityHistory = state.adaptation.plasticityHistory;
        optimalPlasticity = TAU_EMERGENCE + volatility * (1.0 - TAU_EMERGENCE);
        stabilityDrive = 1.0 - newPlasticity;
        plasticityDrive = newPlasticity;
        balancePoint = newBalance;
        environmentVolatility = volatility;
        adaptationLag = abs(newPlasticity - state.adaptation.optimalPlasticity);
        predictedChange = volatility * newMetaGradient;
        metaPlasticity = state.adaptation.metaPlasticity;
        metaPlasticityBounds = state.adaptation.metaPlasticityBounds;
      };
      representation = state.representation;
      metaAwareness = newMetaAwareness;
      metaCoherence = (newCalibration + newMetaAwareness) / 2.0;
      metaEvolution = abs(newMetaGradient) * newPlasticity;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // META INITIALIZATION
  // ══════════════════════════════════════════════════════════════
  public func initCrowMetaState() : CrowMetaState {
    {
      learning = {
        baseLearningRate = 0.01;
        adaptedLearningRate = 0.01;
        learningRateMomentum = 0.0;
        metaGradient = 0.0;
        metaGradientHistory = [];
        currentStrategy = #Exploration;
        strategyConfidence = 0.5;
        strategyHistory = [];
        explorationRate = 0.3;
        explorationDecay = 0.99;
        intrinsicMotivation = 0.5;
        noveltyThreshold = 0.3;
      };
      cognition = {
        confidenceCalibration = 0.5;
        uncertaintyAwareness = 0.3;
        errorDetection = 0.3;
        attentionBudget = 1.0;
        attentionAllocation = [0.5, 0.5];
        cognitiveLoad = 0.0;
        memoryMonitoring = 0.5;
        retrievalConfidence = 0.5;
        forgettingPrediction = 0.3;
        strategyKnowledge = 0.3;
        strategySelection = 0.5;
        strategyMonitoring = 0.3;
      };
      adaptation = {
        plasticityLevel = 0.5;
        plasticityHistory = [];
        optimalPlasticity = 0.5;
        stabilityDrive = 0.5;
        plasticityDrive = 0.5;
        balancePoint = 0.5;
        environmentVolatility = 0.3;
        adaptationLag = 0.0;
        predictedChange = 0.0;
        metaPlasticity = 0.1;
        metaPlasticityBounds = (0.1, 0.9);
      };
      representation = {
        abstractionDepth = 1;
        abstractionCapacity = 5;
        activeSchemas = [];
        schemaStrength = [];
        schemaConflict = 0.0;
        analogyCapacity = 0.3;
        transferReadiness = 0.3;
        domainIndependence = 0.2;
      };
      metaAwareness = 0.3;
      metaCoherence = 0.5;
      metaEvolution = 0.0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA INSIGHT EMERGENCE FUNCTION (MIEF)
  // ══════════════════════════════════════════════════════════════
  // I(t) = Θ(T × (E_explore × E_exploit - τ_E)) × Ψ_incubation × √(M × Γ)
  public func medinaInsightEmergence(
    exploration: Float,
    exploitation: Float,
    temperature: Float,
    timeFocused: Float,
    timeRested: Float,
    memoryRelevance: Float,
    gestaltClosure: Float
  ) : Float {
    // Explore-exploit tension
    let tension = exploration * exploitation - TAU_EMERGENCE;
    
    // Heaviside activation
    let thetaActivation = medinaHeaviside(temperature * tension);
    
    // Incubation factor: needs both focus AND rest
    // Ψ = exp(-t_focus/Φ_M) × (1 - exp(-t_rest/Φ_M))
    let focusDecay = Float.exp(-timeFocused / PHI_MEDINA);
    let restBenefit = 1.0 - Float.exp(-timeRested / PHI_MEDINA);
    let incubation = focusDecay * restBenefit;
    
    // Memory and gestalt factor
    let experienceFactor = Float.sqrt(_clamp(memoryRelevance * gestaltClosure, 0.0, 1.0));
    
    // Insight probability
    _clamp(thetaActivation * incubation * experienceFactor, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA CAUSAL INFERENCE NETWORK (MCIN)
  // ══════════════════════════════════════════════════════════════
  // P(effect|cause) = σ_M(Σᵢ wᵢ × P(intermediateᵢ)) × confidence^(1/Φ_M)
  public func medinaCausalInference(
    intermediateProbs: [Float],
    weights: [Float],
    confidence: Float
  ) : Float {
    // Weighted sum of intermediate probabilities
    var weightedSum : Float = 0.0;
    var i : Nat = 0;
    for (p in intermediateProbs.vals()) {
      let w = if (i < weights.size()) { weights[i] } else { 1.0 / Float.fromInt(intermediateProbs.size()) };
      weightedSum += w * p;
      i += 1;
    };
    
    // Medina sigmoid of weighted sum
    let baseProbability = medinaSigmoid(weightedSum);
    
    // Confidence modulation (power of 1/Φ_M)
    let confidenceModulation = Float.pow(_clamp(confidence, 0.01, 1.0), BETA_TOM);
    
    baseProbability * confidenceModulation
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA THEORY OF MIND RECURSION (MTMR)
  // ══════════════════════════════════════════════════════════════
  // ToM_n(agent) = Σₖ βᵏ × [belief_k(agent) × trust_k(agent)]
  public func medinaTheoryOfMind(
    beliefs: [Float],
    trusts: [Float],
    maxDepth: Nat
  ) : Float {
    var tomScore : Float = 0.0;
    var betaPower : Float = 1.0;
    
    var k : Nat = 0;
    while (k < maxDepth and k < beliefs.size()) {
      let belief = if (k < beliefs.size()) { beliefs[k] } else { 0.5 };
      let trust = if (k < trusts.size()) { trusts[k] } else { 0.5 };
      
      tomScore += betaPower * belief * trust;
      betaPower *= BETA_TOM;  // Recursive discount
      k += 1;
    };
    
    _clamp(tomScore, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA TOOL-USE OPTIMIZATION (MTUO)
  // ══════════════════════════════════════════════════════════════
  // U(tool, problem) = success × complexity^(-1/Φ_M) × recency_boost
  public func medinaToolUseOptimization(
    successRate: Float,
    complexity: Float,
    timeSinceUse: Float
  ) : Float {
    // Complexity penalty (inverse power of Φ_M)
    let complexityPenalty = Float.pow(_clamp(complexity, 0.1, 10.0), -BETA_TOM);
    
    // Recency boost
    let recencyBoost = Float.exp(-timeSinceUse * LAMBDA_K);
    
    // Combined utility
    successRate * complexityPenalty * recencyBoost
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA EPISODIC BINDING FUNCTION (MEBF)
  // ══════════════════════════════════════════════════════════════
  // Binds what-where-when with emotional valence
  // B(e) = |valence| × exp(-age/Φ_M) × associationCount^(1/2)
  public func medinaEpisodicBinding(
    emotionalValence: Float,
    ageInBeats: Nat,
    associationCount: Nat
  ) : Float {
    let absValence = Float.abs(emotionalValence);
    let ageDecay = Float.exp(-Float.fromInt(ageInBeats) / (PHI_MEDINA * 1000.0));
    let associationBoost = Float.sqrt(Float.fromInt(associationCount + 1));
    
    _clamp(absValence * ageDecay * associationBoost, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA FUTURE PLANNING HORIZON (MFPH)
  // ══════════════════════════════════════════════════════════════
  // Discounts future rewards using Medina harmonic
  // V(t+n) = V_0 × (Φ_M)^(-n/horizon) × confidence
  public func medinaFuturePlanning(
    immediateValue: Float,
    stepsAhead: Nat,
    horizon: Nat,
    confidence: Float
  ) : Float {
    let effectiveHorizon = Float.fromInt(if (horizon == 0) { PLANNING_HORIZON } else { horizon });
    let discountExponent = Float.fromInt(stepsAhead) / effectiveHorizon;
    let discount = Float.pow(PHI_MEDINA, -discountExponent);
    
    immediateValue * discount * confidence
  };

  func sigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-4.0 * (x - 0.5)))
  };

  // ── Causal Reasoning ──────────────────────────────────────────
  // Corvids can infer cause-effect from observation
  public func updateCausalModel(
    models: [CausalModel], observedCause: Nat, observedEffect: Nat, success: Bool
  ) : [CausalModel] {
    Array.map<CausalModel, CausalModel>(models, func(m) {
      if (m.causeId == observedCause and m.effectId == observedEffect) {
        let delta = if (success) { 0.1 } else { -0.05 };
        {
          causeId = m.causeId;
          effectId = m.effectId;
          strength = _clamp(m.strength + delta, 0.0, 1.0);
          confidence = _clamp(m.confidence + 0.02, 0.0, 1.0);
          usageCount = m.usageCount + 1;
        }
      } else { m }
    })
  };

  // Predict effect given cause
  public func predictEffect(models: [CausalModel], causeId: Nat) : ?Nat {
    var bestEffect : ?Nat = null;
    var bestStrength : Float = 0.0;

    for (m in models.vals()) {
      if (m.causeId == causeId and m.strength > bestStrength) {
        bestStrength := m.strength;
        bestEffect := ?m.effectId;
      };
    };
    bestEffect
  };

  // ── Tool Use ──────────────────────────────────────────────────
  // Select best tool for current problem
  public func selectTool(
    solutions: [ToolSolution], problemType: Nat
  ) : ?ToolSolution {
    var bestSolution : ?ToolSolution = null;
    var bestScore : Float = 0.0;

    for (s in solutions.vals()) {
      if (s.problemType == problemType) {
        let score = s.success * (1.0 / (1.0 + s.complexity * 0.1));
        if (score > bestScore) {
          bestScore := score;
          bestSolution := ?s;
        };
      };
    };
    bestSolution
  };

  // Learn from tool use outcome
  public func learnToolUse(
    solutions: [ToolSolution], problemType: Nat, toolType: Nat,
    success: Bool, beat: Nat
  ) : [ToolSolution] {
    var found = false;
    let updated = Array.map<ToolSolution, ToolSolution>(solutions, func(s) {
      if (s.problemType == problemType and s.toolType == toolType) {
        found := true;
        let delta = if (success) { 0.1 } else { -0.05 };
        {
          problemType = s.problemType;
          toolType = s.toolType;
          success = _clamp(s.success + delta, 0.0, 1.0);
          complexity = s.complexity;
          lastUsed = beat;
        }
      } else { s }
    });

    if (not found and success) {
      // Add new solution
      Array.append<ToolSolution>(updated, [{
        problemType = problemType;
        toolType = toolType;
        success = 0.6;
        complexity = 1.0;
        lastUsed = beat;
      }])
    } else { updated }
  };

  // ── Future Planning ───────────────────────────────────────────
  // Corvids can plan multiple steps ahead
  public func generatePlan(
    state: CrowState, goal: Nat, currentState: Nat
  ) : FuturePlan {
    // Simple breadth-first style planning using causal models
    var steps : [Nat] = [];
    var current = currentState;
    var confidence : Float = 1.0;
    var totalValue : Float = 0.0;

    var depth = 0;
    while (depth < state.planningDepth and current != goal) {
      switch (predictEffect(state.causalModels, current)) {
        case (null) { depth := state.planningDepth }; // No path
        case (?next) {
          steps := Array.append<Nat>(steps, [next]);
          // Discount future values
          totalValue += Float.pow(state.futureDiscounting, Float.fromInt(depth));
          confidence *= 0.9;
          current := next;
          depth += 1;
        };
      };
    };

    {
      goal = goal;
      steps = steps;
      confidence = confidence;
      value = totalValue;
      timeToGoal = steps.size();
    }
  };

  // ── Social Cognition ──────────────────────────────────────────
  // Update knowledge about another agent
  public func observeAgent(
    knowledge: [SocialKnowledge], agentId: Nat, behavior: Float, beat: Nat
  ) : [SocialKnowledge] {
    var found = false;
    let updated = Array.map<SocialKnowledge, SocialKnowledge>(knowledge, func(k) {
      if (k.agentId == agentId) {
        found := true;
        // Update trust based on behavior consistency
        let behaviorHistory = Array.append<Float>(
          if (k.behaviors.size() > 10) {
            Array.tabulate<Float>(9, func(i) { k.behaviors[i + 1] })
          } else { k.behaviors },
          [behavior]
        );
        {
          agentId = k.agentId;
          trustLevel = _clamp(k.trustLevel + (behavior - 0.5) * 0.1, 0.0, 1.0);
          dominance = k.dominance;
          lastSeen = beat;
          behaviors = behaviorHistory;
        }
      } else { k }
    });

    if (not found) {
      Array.append<SocialKnowledge>(updated, [{
        agentId = agentId;
        trustLevel = 0.5;
        dominance = 0.5;
        lastSeen = beat;
        behaviors = [behavior];
      }])
    } else { updated }
  };

  // ── Theory of Mind ────────────────────────────────────────────
  // Model what another agent might know/want
  public func inferAgentState(
    knowledge: [SocialKnowledge], agentId: Nat, theoryOfMind: Float
  ) : (Float, Float) {
    // Returns (likely_goal, likely_knowledge_level)
    for (k in knowledge.vals()) {
      if (k.agentId == agentId) {
        // Use behavior history to infer state
        var avgBehavior : Float = 0.0;
        for (b in k.behaviors.vals()) { avgBehavior += b };
        avgBehavior /= Float.fromInt(k.behaviors.size());

        let inferredGoal = avgBehavior * theoryOfMind;
        let inferredKnowledge = k.trustLevel * theoryOfMind;
        return (inferredGoal, inferredKnowledge);
      };
    };
    (0.5, 0.5)
  };

  // ── Episodic Memory ───────────────────────────────────────────
  // Store what-where-when event
  public func storeEpisode(
    memory: [EpisodicEvent], what: Nat, where_: Nat, when_: Nat,
    who: ?Nat, value: Float
  ) : [EpisodicEvent] {
    let newEvent : EpisodicEvent = {
      what = what;
      where = where_;
      when = when_;
      who = who;
      value = value;
    };

    // Keep most recent 50 episodes
    let updated = Array.append<EpisodicEvent>(memory, [newEvent]);
    if (updated.size() > 50) {
      Array.tabulate<EpisodicEvent>(50, func(i) { updated[i + updated.size() - 50] })
    } else { updated }
  };

  // Recall episodes matching criteria
  public func recallEpisodes(
    memory: [EpisodicEvent], what: ?Nat, where_: ?Nat
  ) : [EpisodicEvent] {
    Array.filter<EpisodicEvent>(memory, func(e) {
      let whatMatch = switch (what) {
        case (null) { true };
        case (?w) { e.what == w };
      };
      let whereMatch = switch (where_) {
        case (null) { true };
        case (?w) { e.where == w };
      };
      whatMatch and whereMatch
    })
  };

  // ── Insight ───────────────────────────────────────────────────
  // Sudden problem-solving insight (Aha! moment)
  public func checkInsight(
    state: CrowState, problemComplexity: Float
  ) : (Bool, Float) {
    // Insight more likely with:
    // - High working memory capacity
    // - Low attention (incubation)
    // - Relevant episodic memories

    let memoryLoad = Float.fromInt(state.workingMemory.size()) / 7.0;
    let incubation = 1.0 - state.attentionFocus;

    let insightChance = state.insightLevel *
                        (1.0 - memoryLoad * 0.3) *
                        (incubation * 0.5 + 0.5) *
                        (1.0 / (problemComplexity + 0.1));

    let triggered = insightChance > 0.7;
    (triggered, insightChance)
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatCrow(
    state: CrowState,
    sensorInput: Float,
    problemSignal: Float,
    socialSignal: Float
  ) : CrowState {
    // Update attention
    let newAttention = _clamp(
      0.7 * state.attentionFocus + 0.3 * (problemSignal + socialSignal) / 2.0,
      0.0, 1.0
    );

    // Update persistence
    let newPersistence = if (problemSignal > 0.5) {
      _clamp(state.persistenceLevel + 0.02, 0.0, 1.0)
    } else {
      _clamp(state.persistenceLevel - 0.01, 0.0, 1.0)
    };

    // Update insight potential (increases during incubation)
    let newInsight = if (newAttention < 0.3) {
      _clamp(state.insightLevel + 0.05, 0.0, 1.0)
    } else {
      _clamp(state.insightLevel - 0.02, 0.0, 1.0)
    };

    // Update theory of mind (improves with social interaction)
    let newToM = _clamp(
      state.theoryOfMind + socialSignal * 0.01,
      0.0, 1.0
    );

    // Update self-awareness
    let newSelfAware = _clamp(
      0.95 * state.selfAwareness + 0.05 * newToM,
      0.0, 1.0
    );

    // Update causal confidence
    let newCausalConf = _clamp(
      0.9 * state.causalConfidence + 0.1 * (1.0 - problemSignal),
      0.0, 1.0
    );

    // Update tool proficiency (decays without use)
    let newToolProf = _clamp(
      state.toolProficiency * 0.995,
      0.0, 1.0
    );

    {
      causalModels = state.causalModels;
      causalConfidence = newCausalConf;
      toolSolutions = state.toolSolutions;
      currentTool = state.currentTool;
      toolProficiency = newToolProf;
      currentPlan = state.currentPlan;
      planningDepth = state.planningDepth;
      futureDiscounting = state.futureDiscounting;
      socialKnowledge = state.socialKnowledge;
      selfAwareness = newSelfAware;
      theoryOfMind = newToM;
      workingMemory = state.workingMemory;
      attentionFocus = newAttention;
      episodicMemory = state.episodicMemory;
      insightLevel = newInsight;
      persistenceLevel = newPersistence;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initCrow() : CrowState {
    {
      causalModels = [];
      causalConfidence = 0.5;
      toolSolutions = [];
      currentTool = null;
      toolProficiency = 0.3;
      currentPlan = null;
      planningDepth = 6;
      futureDiscounting = 0.9;
      socialKnowledge = [];
      selfAwareness = 0.5;
      theoryOfMind = 0.4;
      workingMemory = [];
      attentionFocus = 0.5;
      episodicMemory = [];
      insightLevel = 0.3;
      persistenceLevel = 0.5;
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type CrowSummary = {
    causalConfidence  : Float;
    toolProficiency   : Float;
    theoryOfMind      : Float;
    selfAwareness     : Float;
    insightLevel      : Float;
    planningDepth     : Nat;
    episodicMemorySize: Nat;
  };

  public func summary(state: CrowState) : CrowSummary {
    {
      causalConfidence = state.causalConfidence;
      toolProficiency = state.toolProficiency;
      theoryOfMind = state.theoryOfMind;
      selfAwareness = state.selfAwareness;
      insightLevel = state.insightLevel;
      planningDepth = state.planningDepth;
      episodicMemorySize = state.episodicMemory.size();
    }
  };

}
