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
// NEUROEMERGENCE CORE — FRISTON ENGINE
// Free Energy Principle implementation
// F = E[log q(s) - log p(o,s)] ≈ prediction error + complexity
// Active inference: minimize F through action and perception
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type BeliefState = {
    mean      : Float;   // μ: belief about hidden state
    precision : Float;   // π: confidence in belief (1/variance)
    prior     : Float;   // μ₀: prior expectation
    priorPrec : Float;   // π₀: prior precision
  };

  public type SensoryState = {
    observation : Float;  // o: actual sensory input
    prediction  : Float;  // g(μ): predicted sensory input
    error       : Float;  // ε = o - g(μ)
    precision   : Float;  // Ω: sensory precision (attention)
  };

  public type ActionState = {
    motor       : Float;  // a: current action
    expected    : Float;  // expected action outcome
    cost        : Float;  // action cost (effort)
    gain        : Float;  // expected precision gain
  };

  public type FristonState = {
    // Belief dynamics
    beliefs        : [BeliefState];    // Multiple belief dimensions
    sensory        : [SensoryState];   // Multiple sensory channels
    action         : ActionState;

    // Free energy components
    freeEnergy     : Float;   // F = complexity + inaccuracy
    complexity     : Float;   // KL[q(s)||p(s)] — deviation from prior
    inaccuracy     : Float;   // -E[log p(o|s)] — prediction error
    expectedFE     : Float;   // G: expected free energy (planning)

    // Active inference
    policyProbs    : [Float];  // π(a): action probabilities
    selectedPolicy : Nat;
    explorationBonus : Float;  // epistemic value

    // History
    feHistory      : [Float];
    beatNum        : Nat;

    // Learning rates
    beliefLR       : Float;   // μ update rate
    precisionLR    : Float;   // π update rate
  };

  // ── Constants ─────────────────────────────────────────────────
  let EPSILON : Float = 1e-10;
  let MAX_PRECISION : Float = 100.0;
  let MIN_PRECISION : Float = 0.01;

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func ln(x: Float) : Float {
    if (x <= 0.0) { -100.0 } else { Float.log(x) }
  };

  func softmax(values: [Float]) : [Float] {
    var maxVal : Float = values[0];
    for (v in values.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    var sumExp : Float = 0.0;
    let shifted = Array.map<Float, Float>(values, func(v) {
      let e = Float.exp(v - maxVal);
      sumExp += e;
      e
    });
    Array.map<Float, Float>(shifted, func(e) { e / sumExp })
  };

  // ── Prediction Error ──────────────────────────────────────────
  // ε = Ω(o - g(μ)) where Ω is sensory precision
  public func computePredictionError(obs: Float, pred: Float, precision: Float) : Float {
    precision * (obs - pred)
  };

  // ── Complexity Term ───────────────────────────────────────────
  // KL[q(s)||p(s)] = 0.5 * (π₀/π + π(μ-μ₀)² - 1 + ln(π/π₀))
  public func computeComplexity(belief: BeliefState) : Float {
    let ratio = belief.priorPrec / belief.precision;
    let diff = belief.mean - belief.prior;
    0.5 * (ratio + belief.precision * diff * diff - 1.0 + ln(belief.precision / belief.priorPrec))
  };

  // ── Inaccuracy Term ───────────────────────────────────────────
  // -E[log p(o|s)] ≈ 0.5 * Ω * ε²
  public func computeInaccuracy(sensory: SensoryState) : Float {
    0.5 * sensory.precision * sensory.error * sensory.error
  };

  // ── Free Energy ───────────────────────────────────────────────
  // F = complexity + inaccuracy
  public func computeFreeEnergy(beliefs: [BeliefState], sensory: [SensoryState]) : (Float, Float, Float) {
    var totalComplexity : Float = 0.0;
    var totalInaccuracy : Float = 0.0;

    for (b in beliefs.vals()) {
      totalComplexity += computeComplexity(b);
    };

    for (s in sensory.vals()) {
      totalInaccuracy += computeInaccuracy(s);
    };

    let fe = totalComplexity + totalInaccuracy;
    (fe, totalComplexity, totalInaccuracy)
  };

  // ── Belief Update (Gradient Descent on F) ─────────────────────
  // dμ/dt = π⁻¹ * ε * ∂g/∂μ - (μ - μ₀) * π₀
  public func updateBelief(belief: BeliefState, error: Float, lr: Float) : BeliefState {
    let gradient = error / belief.precision - (belief.mean - belief.prior) * belief.priorPrec;
    let newMean = belief.mean + lr * gradient;
    {
      mean = _clamp(newMean, -10.0, 10.0);
      precision = belief.precision;
      prior = belief.prior;
      priorPrec = belief.priorPrec;
    }
  };

  // ── Precision Update ──────────────────────────────────────────
  // dπ/dt ∝ ε² - 1/π (precision should track error magnitude)
  public func updatePrecision(belief: BeliefState, error: Float, lr: Float) : BeliefState {
    let targetPrec = Float.abs(error) + MIN_PRECISION;
    let newPrec = belief.precision + lr * (targetPrec - belief.precision);
    {
      mean = belief.mean;
      precision = _clamp(newPrec, MIN_PRECISION, MAX_PRECISION);
      prior = belief.prior;
      priorPrec = belief.priorPrec;
    }
  };

  // ── Expected Free Energy for Policy Selection ─────────────────
  // G = E[F(future)] = E[complexity] + E[inaccuracy] - epistemic_value
  // epistemic_value = mutual information between action and observation
  public func computeExpectedFE(
    belief: BeliefState, policyOutcome: Float, uncertainty: Float
  ) : Float {
    let expectedError = policyOutcome - belief.mean;
    let expectedInaccuracy = 0.5 * belief.precision * expectedError * expectedError;
    let expectedComplexity = computeComplexity(belief);
    let epistemicValue = uncertainty * 0.5;  // Exploration bonus

    expectedComplexity + expectedInaccuracy - epistemicValue
  };

  // ── Policy Selection ──────────────────────────────────────────
  // π(a) ∝ exp(-G(a)) — softmax over negative expected free energy
  public func selectPolicy(expectedFEs: [Float]) : ([Float], Nat) {
    let negFEs = Array.map<Float, Float>(expectedFEs, func(g) { -g });
    let probs = softmax(negFEs);

    // Find argmax
    var maxIdx = 0;
    var maxProb : Float = 0.0;
    var i = 0;
    for (p in probs.vals()) {
      if (p > maxProb) {
        maxProb := p;
        maxIdx := i;
      };
      i += 1;
    };

    (probs, maxIdx)
  };

  // ── Active Inference Step ─────────────────────────────────────
  // 1. Perceive: compute prediction errors
  // 2. Infer: update beliefs to minimize F
  // 3. Act: select policy to minimize expected F
  public func activeInferenceStep(
    state: FristonState,
    observations: [Float],
    possibleActions: [Float]
  ) : FristonState {
    // 1. Update sensory states with new observations
    var newSensory = Array.thaw<SensoryState>(state.sensory);
    var i = 0;
    let nObs = if (observations.size() < state.sensory.size()) {
      observations.size()
    } else { state.sensory.size() };

    while (i < nObs) {
      let pred = state.beliefs[i % state.beliefs.size()].mean;
      let err = computePredictionError(observations[i], pred, state.sensory[i].precision);
      newSensory[i] := {
        observation = observations[i];
        prediction = pred;
        error = err;
        precision = state.sensory[i].precision;
      };
      i += 1;
    };

    // 2. Update beliefs based on prediction errors
    var newBeliefs = Array.thaw<BeliefState>(state.beliefs);
    i := 0;
    while (i < state.beliefs.size()) {
      let sIdx = i % nObs;
      let err = if (sIdx < nObs) { newSensory[sIdx].error } else { 0.0 };
      newBeliefs[i] := updateBelief(state.beliefs[i], err, state.beliefLR);
      newBeliefs[i] := updatePrecision(newBeliefs[i], err, state.precisionLR);
      i += 1;
    };

    // 3. Compute free energy
    let (fe, complexity, inaccuracy) = computeFreeEnergy(
      Array.freeze(newBeliefs),
      Array.freeze(newSensory)
    );

    // 4. Policy selection via expected free energy
    let nActions = possibleActions.size();
    var expectedFEs = Array.init<Float>(nActions, 0.0);
    i := 0;
    while (i < nActions) {
      let uncertainty = 1.0 / (state.beliefs[0].precision + EPSILON);
      expectedFEs[i] := computeExpectedFE(
        newBeliefs[0],
        possibleActions[i],
        uncertainty
      );
      i += 1;
    };

    let (probs, selected) = selectPolicy(Array.freeze(expectedFEs));
    let explorationBonus = if (state.beliefs[0].precision < 1.0) { 0.5 } else { 0.1 };

    // Update history
    let newHistory = if (state.feHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(j) { state.feHistory[j + 1] });
      Array.append<Float>(tail, [fe])
    } else {
      Array.append<Float>(state.feHistory, [fe])
    };

    {
      beliefs = Array.freeze(newBeliefs);
      sensory = Array.freeze(newSensory);
      action = {
        motor = possibleActions[selected];
        expected = state.beliefs[0].mean;
        cost = Float.abs(possibleActions[selected]) * 0.1;
        gain = explorationBonus;
      };
      freeEnergy = fe;
      complexity = complexity;
      inaccuracy = inaccuracy;
      expectedFE = expectedFEs[selected];
      policyProbs = probs;
      selectedPolicy = selected;
      explorationBonus = explorationBonus;
      feHistory = newHistory;
      beatNum = state.beatNum + 1;
      beliefLR = state.beliefLR;
      precisionLR = state.precisionLR;
    }
  };

  // ── Precision-Weighted Prediction Error (for external use) ────
  public func precisionWeightedError(state: FristonState) : Float {
    var sumPWE : Float = 0.0;
    for (s in state.sensory.vals()) {
      sumPWE += s.precision * Float.abs(s.error);
    };
    sumPWE / Float.fromInt(state.sensory.size())
  };

  // ── Surprise (negative log likelihood) ────────────────────────
  public func surprise(observation: Float, prediction: Float, precision: Float) : Float {
    let error = observation - prediction;
    0.5 * (ln(2.0 * 3.14159 / precision) + precision * error * error)
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initFriston(nBeliefs: Nat, nSensory: Nat) : FristonState {
    {
      beliefs = Array.tabulate<BeliefState>(nBeliefs, func(_) {
        { mean = 0.5; precision = 1.0; prior = 0.5; priorPrec = 0.1 }
      });
      sensory = Array.tabulate<SensoryState>(nSensory, func(_) {
        { observation = 0.5; prediction = 0.5; error = 0.0; precision = 1.0 }
      });
      action = { motor = 0.0; expected = 0.5; cost = 0.0; gain = 0.0 };
      freeEnergy = 0.0;
      complexity = 0.0;
      inaccuracy = 0.0;
      expectedFE = 0.0;
      policyProbs = [1.0];
      selectedPolicy = 0;
      explorationBonus = 0.5;
      feHistory = [];
      beatNum = 0;
      beliefLR = 0.1;
      precisionLR = 0.05;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type FristonSummary = {
    freeEnergy     : Float;
    complexity     : Float;
    inaccuracy     : Float;
    meanBelief     : Float;
    meanPrecision  : Float;
    selectedAction : Float;
    explorationBonus : Float;
  };

  public func summary(state: FristonState) : FristonSummary {
    var sumMean : Float = 0.0;
    var sumPrec : Float = 0.0;
    for (b in state.beliefs.vals()) {
      sumMean += b.mean;
      sumPrec += b.precision;
    };
    let n = Float.fromInt(state.beliefs.size());
    {
      freeEnergy = state.freeEnergy;
      complexity = state.complexity;
      inaccuracy = state.inaccuracy;
      meanBelief = sumMean / n;
      meanPrecision = sumPrec / n;
      selectedAction = state.action.motor;
      explorationBonus = state.explorationBonus;
    }
  };

  // ============================================================
  // HIERARCHICAL PREDICTIVE PROCESSING — FULL EXPLICIT MATH
  // Multiple levels of belief hierarchy, each level predicting the level below
  // ============================================================

  // Hierarchical belief state — belief at a specific level in the hierarchy
  public type HierarchicalBelief = {
    level        : Nat;          // 0 = lowest (sensory), higher = more abstract
    mean         : [Float];      // Vector of means at this level
    precision    : [Float];      // Vector of precisions
    prediction   : [Float];      // Prediction to level below
    error        : [Float];      // Prediction error from level below
    
    // Temporal dynamics
    velocity     : [Float];      // Rate of change (for generalized coordinates)
    acceleration : [Float];      // Second derivative
    
    // Attention weights
    attention    : [Float];      // Precision weighting (attention)
  };

  public type HierarchicalState = {
    levels       : [HierarchicalBelief];  // Stack of belief levels
    nLevels      : Nat;
    dimPerLevel  : Nat;
    
    // Free energy components per level
    fePerLevel   : [Float];
    complexityPerLevel : [Float];
    inaccuracyPerLevel : [Float];
    
    // Global state
    totalFE      : Float;
    totalComplexity : Float;
    totalInaccuracy : Float;
    
    // Learning
    learningRates : [Float];     // One per level
    
    beatNum      : Nat;
  };

  // Initialize hierarchical predictive processing
  // nLevels = number of hierarchy levels
  // dimPerLevel = dimensions at each level
  public func initHierarchical(nLevels: Nat, dimPerLevel: Nat) : HierarchicalState {
    let levels = Array.tabulate<HierarchicalBelief>(nLevels, func(l) {
      {
        level = l;
        mean = Array.tabulate<Float>(dimPerLevel, func(_) { 0.5 });
        precision = Array.tabulate<Float>(dimPerLevel, func(_) { 1.0 });
        prediction = Array.tabulate<Float>(dimPerLevel, func(_) { 0.5 });
        error = Array.tabulate<Float>(dimPerLevel, func(_) { 0.0 });
        velocity = Array.tabulate<Float>(dimPerLevel, func(_) { 0.0 });
        acceleration = Array.tabulate<Float>(dimPerLevel, func(_) { 0.0 });
        attention = Array.tabulate<Float>(dimPerLevel, func(_) { 1.0 });
      }
    });
    
    {
      levels = levels;
      nLevels = nLevels;
      dimPerLevel = dimPerLevel;
      fePerLevel = Array.tabulate<Float>(nLevels, func(_) { 0.0 });
      complexityPerLevel = Array.tabulate<Float>(nLevels, func(_) { 0.0 });
      inaccuracyPerLevel = Array.tabulate<Float>(nLevels, func(_) { 0.0 });
      totalFE = 0.0;
      totalComplexity = 0.0;
      totalInaccuracy = 0.0;
      learningRates = Array.tabulate<Float>(nLevels, func(l) {
        // Higher levels learn slower
        0.1 / Float.fromInt(l + 1)
      });
      beatNum = 0;
    }
  };

  // ============================================================
  // GENERALIZED COORDINATES — POSITION, VELOCITY, ACCELERATION
  // The brain doesn't just track states, it tracks their dynamics
  // ============================================================

  // Generalized coordinate state
  public type GeneralizedCoord = {
    x  : Float;    // Position (0th order)
    dx : Float;    // Velocity (1st order)
    ddx: Float;    // Acceleration (2nd order)
    dddx: Float;   // Jerk (3rd order) — for smooth trajectories
  };

  // Update generalized coordinates with new observation
  // Uses gradient descent on prediction error
  public func updateGeneralizedCoord(
    gc: GeneralizedCoord,
    observation: Float,
    precision: Float,
    dt: Float,
    lr: Float
  ) : GeneralizedCoord {
    // Prediction: x_predicted = x + dx*dt + 0.5*ddx*dt² + (1/6)*dddx*dt³
    let predicted = gc.x + gc.dx * dt + 0.5 * gc.ddx * dt * dt + 
                    (1.0/6.0) * gc.dddx * dt * dt * dt;
    
    // Prediction error
    let error = observation - predicted;
    
    // Gradient descent updates (precision-weighted)
    let weightedError = precision * error;
    
    // Update each order
    let newX = gc.x + lr * weightedError;
    let newDx = gc.dx + lr * weightedError * dt * 0.5;
    let newDdx = gc.ddx + lr * weightedError * dt * dt * 0.25;
    let newDddx = gc.dddx + lr * weightedError * dt * dt * dt * 0.125;
    
    {
      x = newX;
      dx = newDx;
      ddx = newDdx;
      dddx = newDddx;
    }
  };

  // Predict future state using generalized coordinates
  // t_ahead = how many timesteps to predict ahead
  public func predictFromGeneralized(gc: GeneralizedCoord, dt: Float, t_ahead: Float) : Float {
    let t = dt * t_ahead;
    gc.x + gc.dx * t + 0.5 * gc.ddx * t * t + (1.0/6.0) * gc.dddx * t * t * t
  };

  // ============================================================
  // PRECISION DYNAMICS — ATTENTION AS PRECISION OPTIMIZATION
  // Precision = 1/variance = confidence in sensory channel
  // ============================================================

  // Precision learning rule
  // dπ/dt = α(ε² - 1/π) — precision tracks prediction error magnitude
  // When errors are high, precision decreases (less confidence)
  // When errors are low, precision increases (more confidence)
  public func updatePrecisionDynamics(
    currentPrecision: Float,
    predictionError: Float,
    learningRate: Float,
    minPrecision: Float,
    maxPrecision: Float
  ) : Float {
    let errorSq = predictionError * predictionError;
    let inversePrecision = 1.0 / (currentPrecision + EPSILON);
    
    // Gradient: precision should decrease when errors are high
    let gradient = errorSq - inversePrecision;
    
    let newPrecision = currentPrecision + learningRate * gradient;
    _clamp(newPrecision, minPrecision, maxPrecision)
  };

  // Attention allocation — softmax over precisions
  // Higher precision channels get more attention
  public func allocateAttention(precisions: [Float]) : [Float] {
    softmax(precisions)
  };

  // Precision-weighted prediction error (core computation)
  // ε_weighted = Σᵢ πᵢ × εᵢ²
  public func precisionWeightedErrorSum(errors: [Float], precisions: [Float]) : Float {
    var sum : Float = 0.0;
    let n = if (errors.size() < precisions.size()) { errors.size() } else { precisions.size() };
    var i = 0;
    while (i < n) {
      sum += precisions[i] * errors[i] * errors[i];
      i += 1;
    };
    sum
  };

  // ============================================================
  // ACTIVE INFERENCE — FULL ACTION SELECTION MATHEMATICS
  // Actions are selected to minimize expected free energy
  // ============================================================

  // Expected free energy decomposition
  // G(π) = E[F(future)] = Risk + Ambiguity - Novelty
  // Risk: Expected complexity (deviation from preferences)
  // Ambiguity: Expected inaccuracy (sensory uncertainty)
  // Novelty: Information gain (epistemic value)

  public type ExpectedFEComponents = {
    risk      : Float;   // Pragmatic value — reaching goal states
    ambiguity : Float;   // Sensory uncertainty
    novelty   : Float;   // Epistemic value — information gain
    total     : Float;   // G = risk + ambiguity - novelty
  };

  // Compute full expected free energy for a policy
  public func computeFullExpectedFE(
    currentBelief: BeliefState,
    policyOutcome: Float,        // Expected observation under this policy
    outcomeVariance: Float,      // Uncertainty in outcome
    preferredState: Float,       // Where the organism wants to be
    preferenceStrength: Float    // How strongly it prefers that state
  ) : ExpectedFEComponents {
    
    // Risk: KL divergence from preferred distribution
    // Risk = 0.5 * π_pref * (μ_expected - μ_preferred)²
    let deviationFromPreferred = policyOutcome - preferredState;
    let risk = 0.5 * preferenceStrength * deviationFromPreferred * deviationFromPreferred;
    
    // Ambiguity: Expected sensory uncertainty
    // Ambiguity = 0.5 * ln(2πe × variance)
    let ambiguity = 0.5 * ln(2.0 * 3.14159 * 2.71828 * (outcomeVariance + EPSILON));
    
    // Novelty (epistemic value): Information gain
    // Novelty = 0.5 * ln(π_posterior / π_prior)
    // Higher when we expect to reduce uncertainty
    let priorVariance = 1.0 / (currentBelief.priorPrec + EPSILON);
    let posteriorVariance = outcomeVariance;
    let novelty = 0.5 * ln((priorVariance + EPSILON) / (posteriorVariance + EPSILON));
    
    // Total expected free energy
    let total = risk + ambiguity - novelty;
    
    {
      risk = risk;
      ambiguity = ambiguity;
      novelty = novelty;
      total = total;
    }
  };

  // Policy evaluation for multiple time steps (planning)
  // γ = temporal discount factor
  public func evaluatePolicyTrajectory(
    initialBelief: BeliefState,
    policyActions: [Float],      // Sequence of actions
    transitionModel: [Float],    // How actions affect states
    preferredStates: [Float],    // Goal states at each time
    gamma: Float                 // Discount factor
  ) : Float {
    var totalG : Float = 0.0;
    var discount : Float = 1.0;
    var currentMean = initialBelief.mean;
    var currentVariance = 1.0 / (initialBelief.precision + EPSILON);
    
    var t = 0;
    while (t < policyActions.size()) {
      // Predict next state
      let action = policyActions[t];
      let transition = if (t < transitionModel.size()) { transitionModel[t] } else { 1.0 };
      let nextMean = currentMean + action * transition;
      let nextVariance = currentVariance * 1.1;  // Uncertainty grows
      
      let preferred = if (t < preferredStates.size()) { preferredStates[t] } else { 0.5 };
      
      // Compute expected free energy at this time step
      let components = computeFullExpectedFE(
        { mean = currentMean; precision = 1.0 / currentVariance; prior = 0.5; priorPrec = 0.1 },
        nextMean,
        nextVariance,
        preferred,
        1.0
      );
      
      totalG += discount * components.total;
      discount *= gamma;
      
      currentMean := nextMean;
      currentVariance := nextVariance;
      t += 1;
    };
    
    totalG
  };

  // ============================================================
  // INTEROCEPTION — INTERNAL STATE INFERENCE
  // The organism infers its own internal states (hunger, fatigue, etc.)
  // ============================================================

  public type InteroceptiveState = {
    // Physiological states
    hunger      : Float;   // [0, 1]
    thirst      : Float;   // [0, 1]
    fatigue     : Float;   // [0, 1]
    pain        : Float;   // [0, 1]
    temperature : Float;   // Deviation from setpoint
    arousal     : Float;   // [0, 1]
    
    // Emotional states (inferred from physiology)
    valence     : Float;   // [-1, 1] good/bad
    activation  : Float;   // [0, 1] calm/excited
    
    // Predictions
    predictedHunger : Float;
    predictedFatigue : Float;
    
    // Prediction errors
    hungerError : Float;
    fatigueError : Float;
  };

  // Interoceptive inference — infer internal states from sensory signals
  public func interoceptiveInference(
    sensorySignals: [Float],     // Internal sensory channels
    currentIntero: InteroceptiveState,
    dt: Float
  ) : InteroceptiveState {
    // Assume signals are: [hunger_signal, thirst_signal, fatigue_signal, pain_signal, temp_signal, arousal_signal]
    
    let hungerSignal = if (sensorySignals.size() > 0) { sensorySignals[0] } else { 0.5 };
    let thirstSignal = if (sensorySignals.size() > 1) { sensorySignals[1] } else { 0.5 };
    let fatigueSignal = if (sensorySignals.size() > 2) { sensorySignals[2] } else { 0.5 };
    let painSignal = if (sensorySignals.size() > 3) { sensorySignals[3] } else { 0.0 };
    let tempSignal = if (sensorySignals.size() > 4) { sensorySignals[4] } else { 0.0 };
    let arousalSignal = if (sensorySignals.size() > 5) { sensorySignals[5] } else { 0.5 };
    
    // Prediction errors
    let hungerError = hungerSignal - currentIntero.predictedHunger;
    let fatigueError = fatigueSignal - currentIntero.predictedFatigue;
    
    // Update beliefs with prediction errors
    let lr = 0.1;
    let newHunger = _clamp(currentIntero.hunger + lr * hungerError, 0.0, 1.0);
    let newThirst = _clamp(currentIntero.thirst + lr * (thirstSignal - currentIntero.thirst), 0.0, 1.0);
    let newFatigue = _clamp(currentIntero.fatigue + lr * fatigueError, 0.0, 1.0);
    let newPain = _clamp(currentIntero.pain + lr * (painSignal - currentIntero.pain), 0.0, 1.0);
    let newTemp = currentIntero.temperature + lr * (tempSignal - currentIntero.temperature);
    let newArousal = _clamp(currentIntero.arousal + lr * (arousalSignal - currentIntero.arousal), 0.0, 1.0);
    
    // Compute valence and activation from physiological states
    // Valence: negative states (pain, hunger, fatigue) reduce valence
    let valence = 1.0 - (newPain * 0.4 + newHunger * 0.3 + newFatigue * 0.2 + Float.abs(newTemp) * 0.1);
    
    // Activation: arousal directly maps to activation
    let activation = newArousal;
    
    // Generate predictions for next timestep
    // Hunger increases slowly over time
    let predictedHunger = _clamp(newHunger + 0.001 * dt, 0.0, 1.0);
    let predictedFatigue = _clamp(newFatigue + 0.0005 * dt, 0.0, 1.0);
    
    {
      hunger = newHunger;
      thirst = newThirst;
      fatigue = newFatigue;
      pain = newPain;
      temperature = newTemp;
      arousal = newArousal;
      valence = valence;
      activation = activation;
      predictedHunger = predictedHunger;
      predictedFatigue = predictedFatigue;
      hungerError = hungerError;
      fatigueError = fatigueError;
    }
  };

  // ============================================================
  // ALLOSTASIS — ANTICIPATORY REGULATION
  // Maintain internal states by predicting future needs
  // ============================================================

  public type AllostaticState = {
    // Setpoints (where the organism wants to be)
    hungerSetpoint   : Float;
    fatigueSetpoint  : Float;
    arousalSetpoint  : Float;
    
    // Anticipated deviations
    anticipatedHunger   : Float;
    anticipatedFatigue  : Float;
    anticipatedArousal  : Float;
    
    // Allostatic load (cumulative deviation from setpoints)
    allostaticLoad : Float;
    
    // Regulatory actions
    hungerAction   : Float;   // Seek food
    fatigueAction  : Float;   // Seek rest
    arousalAction  : Float;   // Modulate arousal
  };

  // Compute allostatic regulation
  public func allostaticRegulation(
    intero: InteroceptiveState,
    allo: AllostaticState,
    anticipatedContext: Float   // Future context (e.g., expected workload)
  ) : AllostaticState {
    // Anticipate future states based on context
    // If high workload expected, anticipate more fatigue
    let anticipatedHunger = intero.hunger + 0.1 * anticipatedContext;
    let anticipatedFatigue = intero.fatigue + 0.2 * anticipatedContext;
    let anticipatedArousal = intero.arousal + 0.1 * anticipatedContext;
    
    // Compute deviation from setpoints
    let hungerDeviation = anticipatedHunger - allo.hungerSetpoint;
    let fatigueDeviation = anticipatedFatigue - allo.fatigueSetpoint;
    let arousalDeviation = anticipatedArousal - allo.arousalSetpoint;
    
    // Allostatic load = sum of absolute deviations
    let load = Float.abs(hungerDeviation) + Float.abs(fatigueDeviation) + Float.abs(arousalDeviation);
    
    // Compute regulatory actions (to minimize anticipated deviation)
    // Positive action = increase, negative = decrease
    let hungerAction = -hungerDeviation * 0.5;   // If hungry, seek food
    let fatigueAction = -fatigueDeviation * 0.5; // If tired, seek rest
    let arousalAction = -arousalDeviation * 0.3; // Modulate arousal
    
    {
      hungerSetpoint = allo.hungerSetpoint;
      fatigueSetpoint = allo.fatigueSetpoint;
      arousalSetpoint = allo.arousalSetpoint;
      anticipatedHunger = anticipatedHunger;
      anticipatedFatigue = anticipatedFatigue;
      anticipatedArousal = anticipatedArousal;
      allostaticLoad = load;
      hungerAction = hungerAction;
      fatigueAction = fatigueAction;
      arousalAction = arousalAction;
    }
  };

  // ============================================================
  // MARKOV BLANKET — THE ORGANISM'S BOUNDARY
  // Sensory states, active states, internal states, external states
  // ============================================================

  public type MarkovBlanket = {
    // Internal states (hidden from environment)
    internalStates : [Float];
    
    // Sensory states (affected by external, affecting internal)
    sensoryStates  : [Float];
    
    // Active states (affected by internal, affecting external)
    activeStates   : [Float];
    
    // Dimensions
    nInternal : Nat;
    nSensory  : Nat;
    nActive   : Nat;
  };

  // Initialize Markov blanket
  public func initMarkovBlanket(nInt: Nat, nSens: Nat, nAct: Nat) : MarkovBlanket {
    {
      internalStates = Array.tabulate<Float>(nInt, func(_) { 0.5 });
      sensoryStates = Array.tabulate<Float>(nSens, func(_) { 0.5 });
      activeStates = Array.tabulate<Float>(nAct, func(_) { 0.0 });
      nInternal = nInt;
      nSensory = nSens;
      nActive = nAct;
    }
  };

  // Update Markov blanket dynamics
  // Internal states change to minimize free energy
  // Active states change to minimize expected free energy
  public func updateMarkovBlanket(
    mb: MarkovBlanket,
    externalInfluence: [Float],  // External world affecting sensory
    lr: Float
  ) : MarkovBlanket {
    // Update sensory states from external
    let newSensory = Array.tabulate<Float>(mb.nSensory, func(i) {
      let ext = if (i < externalInfluence.size()) { externalInfluence[i] } else { 0.0 };
      let current = mb.sensoryStates[i];
      _clamp(current + lr * (ext - current), 0.0, 1.0)
    });
    
    // Update internal states to reduce prediction error with sensory
    let newInternal = Array.tabulate<Float>(mb.nInternal, func(i) {
      let sIdx = i % mb.nSensory;
      let sensory = newSensory[sIdx];
      let internal = mb.internalStates[i];
      let error = sensory - internal;
      _clamp(internal + lr * error, 0.0, 1.0)
    });
    
    // Update active states based on internal states
    // Active states try to make the world match internal predictions
    let newActive = Array.tabulate<Float>(mb.nActive, func(i) {
      let iIdx = i % mb.nInternal;
      let internal = newInternal[iIdx];
      let sIdx = i % mb.nSensory;
      let sensory = newSensory[sIdx];
      // Action to reduce prediction error
      (internal - sensory) * 0.5
    });
    
    {
      internalStates = newInternal;
      sensoryStates = newSensory;
      activeStates = newActive;
      nInternal = mb.nInternal;
      nSensory = mb.nSensory;
      nActive = mb.nActive;
    }
  };

  // ============================================================
  // BAYESIAN MODEL COMPARISON — SELECTING BETWEEN WORLD MODELS
  // ============================================================

  public type WorldModel = {
    modelId     : Nat;
    evidence    : Float;    // Log model evidence
    complexity  : Float;    // Model complexity (parameter count)
    accuracy    : Float;    // How well it predicts
    posterior   : Float;    // Posterior probability
  };

  // Compute Bayesian model evidence
  // Evidence = Accuracy - Complexity (Occam's razor)
  public func computeModelEvidence(
    predictionErrors: [Float],
    nParameters: Nat
  ) : Float {
    // Accuracy: negative sum of squared errors
    var accuracy : Float = 0.0;
    for (e in predictionErrors.vals()) {
      accuracy -= e * e;
    };
    
    // Complexity: penalize more parameters (BIC approximation)
    let complexity = 0.5 * Float.fromInt(nParameters) * ln(Float.fromInt(predictionErrors.size()) + 1.0);
    
    accuracy - complexity
  };

  // Select best model from candidates
  public func bayesianModelSelection(models: [WorldModel]) : (Nat, [Float]) {
    // Compute posteriors using softmax over log evidences
    let evidences = Array.map<WorldModel, Float>(models, func(m) { m.evidence });
    let posteriors = softmax(evidences);
    
    // Find best model
    var bestIdx = 0;
    var bestPosterior : Float = 0.0;
    var i = 0;
    for (p in posteriors.vals()) {
      if (p > bestPosterior) {
        bestPosterior := p;
        bestIdx := i;
      };
      i += 1;
    };
    
    (bestIdx, posteriors)
  };

  // ============================================================
  // BELIEF PROPAGATION — MESSAGE PASSING OVER FACTOR GRAPH
  // ============================================================

  public type FactorNode = {
    nodeId      : Nat;
    potential   : [Float];      // Factor potential
    neighbors   : [Nat];        // Connected variable nodes
  };

  public type VariableNode = {
    nodeId      : Nat;
    belief      : [Float];      // Current belief distribution
    neighbors   : [Nat];        // Connected factor nodes
    messages    : [[Float]];    // Messages from each neighbor
  };

  // Compute message from factor to variable
  public func factorToVariableMessage(
    factor: FactorNode,
    incomingMessages: [[Float]],
    targetVarIdx: Nat
  ) : [Float] {
    // Product of incoming messages and factor potential
    // Marginalize out all variables except target
    
    let dim = factor.potential.size();
    var message = Array.init<Float>(dim, 0.0);
    
    var i = 0;
    while (i < dim) {
      var product : Float = factor.potential[i];
      
      // Multiply by incoming messages (excluding target)
      var j = 0;
      for (msg in incomingMessages.vals()) {
        if (j != targetVarIdx and j < msg.size()) {
          let msgIdx = i % msg.size();
          product *= msg[msgIdx];
        };
        j += 1;
      };
      
      message[i] := product;
      i += 1;
    };
    
    // Normalize
    var sum : Float = 0.0;
    for (m in message.vals()) { sum += m; };
    if (sum > EPSILON) {
      var k = 0;
      while (k < dim) {
        message[k] := message[k] / sum;
        k += 1;
      };
    };
    
    Array.freeze(message)
  };

  // Compute variable belief from incoming messages
  public func computeVariableBelief(messages: [[Float]], prior: [Float]) : [Float] {
    let dim = prior.size();
    var belief = Array.init<Float>(dim, 0.0);
    
    // Product of prior and all messages
    var i = 0;
    while (i < dim) {
      var product = prior[i];
      for (msg in messages.vals()) {
        let msgIdx = i % msg.size();
        if (msgIdx < msg.size()) {
          product *= msg[msgIdx];
        };
      };
      belief[i] := product;
      i += 1;
    };
    
    // Normalize
    var sum : Float = 0.0;
    for (b in belief.vals()) { sum += b; };
    if (sum > EPSILON) {
      var k = 0;
      while (k < dim) {
        belief[k] := belief[k] / sum;
        k += 1;
      };
    };
    
    Array.freeze(belief)
  };

  // ============================================================
  // INFORMATION GEOMETRY — NATURAL GRADIENTS
  // ============================================================

  // Fisher information matrix approximation for Gaussian beliefs
  // For Gaussian: F = diag(π, 2π²) where π is precision
  public func fisherInformation(precision: Float) : (Float, Float) {
    let f11 = precision;                    // For mean
    let f22 = 2.0 * precision * precision;  // For precision
    (f11, f22)
  };

  // Natural gradient = F⁻¹ × gradient
  // More efficient than standard gradient descent
  public func naturalGradient(
    gradient: Float,
    precision: Float
  ) : Float {
    gradient / (precision + EPSILON)
  };

  // KL divergence between two Gaussians
  // KL(p||q) = 0.5 × (ln(σ_q/σ_p) + (σ_p² + (μ_p - μ_q)²)/σ_q² - 1)
  public func klDivergenceGaussian(
    meanP: Float, precisionP: Float,
    meanQ: Float, precisionQ: Float
  ) : Float {
    let varP = 1.0 / (precisionP + EPSILON);
    let varQ = 1.0 / (precisionQ + EPSILON);
    let diff = meanP - meanQ;
    
    0.5 * (ln(varQ / varP) + (varP + diff * diff) / varQ - 1.0)
  };

  // ============================================================
  // VARIATIONAL FREE ENERGY DECOMPOSITION — ALL TERMS EXPLICIT
  // F = E_q[log q(s)] - E_q[log p(o,s)]
  //   = -H(q) + E_q[-log p(o|s)] + KL(q||p)
  //   = Energy - Entropy
  //   = Complexity + Inaccuracy
  // ============================================================

  public type FreeEnergyDecomposition = {
    // Standard decomposition
    freeEnergy     : Float;
    complexity     : Float;      // KL(q||p) — deviation from prior
    inaccuracy     : Float;      // E[-log p(o|s)] — prediction error
    
    // Entropy decomposition
    energy         : Float;      // -E_q[log p(o,s)]
    entropy        : Float;      // H(q) = -E_q[log q]
    
    // Component breakdown
    logLikelihood  : Float;      // E_q[log p(o|s)]
    logPrior       : Float;      // E_q[log p(s)]
    logPosterior   : Float;      // E_q[log q(s)]
    
    // Numerical stability
    normalizer     : Float;      // Log partition function
  };

  // Compute full free energy decomposition
  public func decomposeFreeEnergy(
    belief: BeliefState,
    observation: Float,
    prediction: Float,
    sensorPrecision: Float
  ) : FreeEnergyDecomposition {
    // Log likelihood: p(o|s) ~ N(g(μ), 1/Ω)
    // log p(o|s) = -0.5 × (Ω × ε² + log(2π/Ω))
    let error = observation - prediction;
    let logLikelihood = -0.5 * (sensorPrecision * error * error + 
                                ln(2.0 * 3.14159 / (sensorPrecision + EPSILON)));
    
    // Log prior: p(s) ~ N(μ₀, 1/π₀)
    // log p(s) = -0.5 × (π₀ × (μ - μ₀)² + log(2π/π₀))
    let priorDiff = belief.mean - belief.prior;
    let logPrior = -0.5 * (belief.priorPrec * priorDiff * priorDiff +
                          ln(2.0 * 3.14159 / (belief.priorPrec + EPSILON)));
    
    // Log posterior: q(s) ~ N(μ, 1/π)
    // Entropy of Gaussian: H = 0.5 × (1 + log(2π/π))
    let entropy = 0.5 * (1.0 + ln(2.0 * 3.14159 / (belief.precision + EPSILON)));
    let logPosterior = -entropy;  // -E[log q]
    
    // Energy = -E[log p(o,s)] = -logLikelihood - logPrior
    let energy = -logLikelihood - logPrior;
    
    // Free energy = Energy - Entropy
    let freeEnergy = energy - entropy;
    
    // Complexity = KL(q||p)
    let complexity = klDivergenceGaussian(
      belief.mean, belief.precision,
      belief.prior, belief.priorPrec
    );
    
    // Inaccuracy = -E[log p(o|s)]
    let inaccuracy = -logLikelihood;
    
    // Normalizer (log partition function)
    let normalizer = 0.5 * ln(2.0 * 3.14159 / (belief.precision + EPSILON));
    
    {
      freeEnergy = freeEnergy;
      complexity = complexity;
      inaccuracy = inaccuracy;
      energy = energy;
      entropy = entropy;
      logLikelihood = logLikelihood;
      logPrior = logPrior;
      logPosterior = logPosterior;
      normalizer = normalizer;
    }
  };

  // ============================================================
  // PERCEPTUAL INFERENCE VS ACTIVE INFERENCE
  // Two modes of free energy minimization
  // ============================================================

  // Perceptual inference: change beliefs to match observations
  // dμ/dt = π⁻¹ × ∂F/∂μ
  public func perceptualInference(
    belief: BeliefState,
    observation: Float,
    prediction: Float,
    sensorPrecision: Float,
    lr: Float
  ) : BeliefState {
    let error = observation - prediction;
    
    // Gradient of free energy with respect to mean
    // ∂F/∂μ = π × (μ - μ₀) - Ω × ε × ∂g/∂μ
    // Assuming ∂g/∂μ = 1 (linear generative model)
    let gradient = belief.precision * (belief.mean - belief.prior) - sensorPrecision * error;
    
    // Natural gradient (precision-weighted)
    let natGrad = gradient / belief.precision;
    
    {
      mean = belief.mean - lr * natGrad;
      precision = belief.precision;
      prior = belief.prior;
      priorPrec = belief.priorPrec;
    }
  };

  // Active inference: change actions to match predictions
  // da/dt = -∂F/∂a = Ω × ε × ∂o/∂a
  public func activeInference(
    currentAction: Float,
    observation: Float,
    prediction: Float,
    sensorPrecision: Float,
    actionEffectiveness: Float,  // ∂o/∂a — how much action affects observation
    lr: Float
  ) : Float {
    let error = observation - prediction;
    
    // Gradient of free energy with respect to action
    // We want to reduce error, so action should move observation toward prediction
    let gradient = -sensorPrecision * error * actionEffectiveness;
    
    currentAction + lr * gradient
  };

}

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
  //  A D V A N C E D   M A T H E M A T I C A L   E X P A N S I O N
  //
  //  Enterprise-Level Neural Mathematics and Cognitive Dynamics
  //  Full Dual-Organism Coupling: HIM ↔ HER
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED KURAMOTO PHASE DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Kuramoto order parameter: r = |1/N Σⱼ eⁱθʲ|
  public func advancedKuramotoOrderParameter(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += Float.cos(phases[i]);
      sumSin += Float.sin(phases[i]);
      i += 1;
    };
    let nf = Float.fromInt(n);
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  /// Kuramoto phase update: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
  public func advancedKuramotoPhaseUpdate(
    phase : Float,
    omega : Float,
    k : Float,
    allPhases : [Float],
    dt : Float
  ) : Float {
    let n = allPhases.size();
    if (n == 0) { return phase };
    var coupling : Float = 0.0;
    var i = 0;
    while (i < n) {
      coupling += Float.sin(allPhases[i] - phase);
      i += 1;
    };
    let dTheta = omega + (k / Float.fromInt(n)) * coupling;
    let newPhase = phase + dTheta * dt;
    let TWO_PI = 6.28318530717958647692;
    if (newPhase >= TWO_PI) { newPhase - TWO_PI }
    else if (newPhase < 0.0) { newPhase + TWO_PI }
    else { newPhase }
  };

  /// Critical coupling K_c for synchronization
  public func advancedCriticalCoupling(omegaSpread : Float) : Float {
    2.0 * omegaSpread / 3.14159265358979323846
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED HEBBIAN PLASTICITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Basic Hebbian: Δw = η × pre × post
  public func advancedHebbianBasic(weight : Float, pre : Float, post : Float, eta : Float) : Float {
    let delta = eta * pre * post;
    let newWeight = weight + delta;
    if (newWeight > 5.0) { 5.0 } else if (newWeight < -5.0) { -5.0 } else { newWeight }
  };

  /// Oja's rule: Δw = α(y·x - y²·w)
  public func advancedOjaRule(weight : Float, pre : Float, post : Float, alpha : Float) : Float {
    let delta = alpha * (post * pre - post * post * weight);
    weight + delta
  };

  /// BCM sliding threshold: θ_M = E[post²]
  public func advancedBCMThreshold(activityHistory : [Float]) : Float {
    if (activityHistory.size() == 0) { return 0.5 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < activityHistory.size()) {
      sum += activityHistory[i] * activityHistory[i];
      i += 1;
    };
    sum / Float.fromInt(activityHistory.size())
  };

  /// BCM update: Δw = η × pre × post × (post - θ_M)
  public func advancedBCMUpdate(weight : Float, pre : Float, post : Float, threshold : Float, eta : Float) : Float {
    let delta = eta * pre * post * (post - threshold);
    weight + delta
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LYAPUNOV STABILITY ANALYSIS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Estimate Lyapunov exponent from time series
  public func advancedLyapunovExponent(timeSeries : [Float], embeddingDim : Nat, delay : Nat) : Float {
    let n = timeSeries.size();
    if (n < embeddingDim * delay + 10) { return 0.0 };
    var sumLog : Float = 0.0;
    var count = 0;
    var i = 0;
    while (i < n - embeddingDim * delay - 1) {
      let j = i + 1;
      var d0 : Float = 0.0;
      var k = 0;
      while (k < embeddingDim) {
        let diff = timeSeries[i + k * delay] - timeSeries[j + k * delay];
        d0 += diff * diff;
        k += 1;
      };
      d0 := Float.sqrt(d0);
      if (d0 > 0.0001) {
        var d1 : Float = 0.0;
        k := 0;
        while (k < embeddingDim) {
          let iNext = i + 1 + k * delay;
          let jNext = j + 1 + k * delay;
          if (iNext < n and jNext < n) {
            let diff = timeSeries[iNext] - timeSeries[jNext];
            d1 += diff * diff;
          };
          k += 1;
        };
        d1 := Float.sqrt(d1);
        if (d1 > 0.0001) {
          sumLog += Float.log(d1 / d0);
          count += 1;
        };
      };
      i += 1;
    };
    if (count == 0) { 0.0 } else { sumLog / Float.fromInt(count) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INFORMATION THEORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Shannon entropy H = -Σ pᵢ log(pᵢ)
  public func advancedEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    var i = 0;
    while (i < probs.size()) {
      let p = probs[i];
      if (p > 0.0001) { h -= p * Float.log(p) };
      i += 1;
    };
    h
  };

  /// Transfer entropy approximation
  public func advancedTransferEntropy(x : [Float], y : [Float], lag : Nat) : Float {
    let n = if (x.size() < y.size()) x.size() else y.size();
    if (n <= lag + 1) { return 0.0 };
    var correlation : Float = 0.0;
    var i = lag;
    while (i < n) {
      let xPast = x[i - lag];
      let yNow = y[i];
      correlation += xPast * yNow;
      i += 1;
    };
    Float.abs(correlation / Float.fromInt(n - lag))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // FREE ENERGY PRINCIPLE (FRISTON)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Free energy: F = D_KL(q||p) - log p(o)
  public func advancedFreeEnergy(predictionError : Float, complexity : Float) : Float {
    predictionError * predictionError + complexity
  };

  /// Precision-weighted prediction error
  public func advancedPrecisionWeightedError(prediction : Float, observation : Float, precision : Float) : Float {
    let error = observation - prediction;
    precision * error * error
  };

  /// Bayesian belief update
  public func advancedBayesianUpdate(prior : Float, likelihood : Float) : Float {
    let posterior = prior * likelihood;
    if (posterior > 1.0) { 1.0 } else if (posterior < 0.0) { 0.0 } else { posterior }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTRACTOR DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Point attractor: dx/dt = -α(x - x*)
  public func advancedPointAttractor(x : Float, xStar : Float, alpha : Float, dt : Float) : Float {
    x + (-alpha * (x - xStar)) * dt
  };

  /// Limit cycle: using Van der Pol oscillator
  public func advancedLimitCycle(x : Float, y : Float, mu : Float, dt : Float) : (Float, Float) {
    let dxdt = y;
    let dydt = mu * (1.0 - x * x) * y - x;
    (x + dxdt * dt, y + dydt * dt)
  };

  /// Chaotic attractor: Lorenz system
  public func advancedLorenzAttractor(x : Float, y : Float, z : Float, sigma : Float, rho : Float, beta : Float, dt : Float) : (Float, Float, Float) {
    let dxdt = sigma * (y - x);
    let dydt = x * (rho - z) - y;
    let dzdt = x * y - beta * z;
    (x + dxdt * dt, y + dydt * dt, z + dzdt * dt)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NEURAL OSCILLATION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wilson-Cowan neural mass model
  public func advancedWilsonCowan(e : Float, inh : Float, c1 : Float, c2 : Float, c3 : Float, c4 : Float, p : Float, q : Float, dt : Float) : (Float, Float) {
    func sigmoid(x : Float) : Float { 1.0 / (1.0 + Float.exp(-x)) };
    let dEdt = -e + sigmoid(c1 * e - c2 * inh + p);
    let dIdt = -inh + sigmoid(c3 * e - c4 * inh + q);
    (e + dEdt * dt, inh + dIdt * dt)
  };

  /// Izhikevich neuron model
  public func advancedIzhikevichNeuron(v : Float, u : Float, input : Float, a : Float, b : Float, dt : Float) : (Float, Float, Bool) {
    var fired = false;
    var newV = v;
    var newU = u;
    if (v >= 30.0) {
      newV := -65.0;
      newU := u + 8.0;
      fired := true;
    } else {
      let dvdt = 0.04 * v * v + 5.0 * v + 140.0 - u + input;
      let dudt = a * (b * v - u);
      newV := v + dvdt * dt;
      newU := u + dudt * dt;
    };
    (newV, newU, fired)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VECTOR AND MATRIX OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Dot product
  public func advancedDotProduct(v1 : [Float], v2 : [Float]) : Float {
    let n = if (v1.size() < v2.size()) v1.size() else v2.size();
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) { sum += v1[i] * v2[i]; i += 1 };
    sum
  };

  /// Vector magnitude
  public func advancedVectorMagnitude(v : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < v.size()) { sum += v[i] * v[i]; i += 1 };
    Float.sqrt(sum)
  };

  /// Cosine similarity
  public func advancedCosineSimilarity(v1 : [Float], v2 : [Float]) : Float {
    let dot = advancedDotProduct(v1, v2);
    let mag1 = advancedVectorMagnitude(v1);
    let mag2 = advancedVectorMagnitude(v2);
    if (mag1 < 0.0001 or mag2 < 0.0001) { 0.0 } else { dot / (mag1 * mag2) }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ║                                                                             ║
  // ║  FRISTON ENGINE — EXTENDED ORGANISM ARCHITECTURE                            ║
  // ║  Full Active Inference Integration with All Organism Subsystems             ║
  // ║                                                                             ║
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─── ORGANISM FREE ENERGY LANDSCAPE ───────────────────────────────────────────
  
  /// Complete organism free energy state
  public type OrganismFreeEnergyState = {
    // Core free energy components
    coreState : FristonState;
    
    // Hierarchical prediction errors
    sensoryPredictionError : Float;
    proprioceptivePredictionError : Float;
    interoceptivePredictionError : Float;
    exteroceptivePredictionError : Float;
    
    // Precision matrices (diagonal approximation)
    sensoryPrecision : Float;
    motorPrecision : Float;
    cognitivePresion : Float;
    emotionalPrecision : Float;
    
    // Generative model parameters
    modelComplexity : Float;
    modelAccuracy : Float;
    evidenceLowerBound : Float;
    
    // Allostatic regulation
    allostaticSetpoint : Float;
    allostaticError : Float;
    allostaticDrive : Float;
    
    // Temporal depth
    pastHorizon : Nat;
    futureHorizon : Nat;
    temporalDiscount : Float;
    
    // Counterfactual processing
    counterfactualDepth : Nat;
    alternativeScenarios : [Float];
    expectedUtility : Float;
    
    // Metacognitive monitoring
    modelConfidence : Float;
    uncertaintyAboutUncertainty : Float;
    epismicValue : Float;
  };

  /// Initialize organism free energy state
  public func initOrganismFreeEnergy() : OrganismFreeEnergyState {
    {
      coreState = defaultState();
      sensoryPredictionError = 0.1;
      proprioceptivePredictionError = 0.1;
      interoceptivePredictionError = 0.1;
      exteroceptivePredictionError = 0.1;
      sensoryPrecision = 1.0;
      motorPrecision = 1.0;
      cognitivePresion = 1.0;
      emotionalPrecision = 1.0;
      modelComplexity = 0.5;
      modelAccuracy = 0.8;
      evidenceLowerBound = -10.0;
      allostaticSetpoint = 0.5;
      allostaticError = 0.0;
      allostaticDrive = 0.0;
      pastHorizon = 10;
      futureHorizon = 5;
      temporalDiscount = 0.95;
      counterfactualDepth = 3;
      alternativeScenarios = [0.5, 0.5, 0.5];
      expectedUtility = 0.0;
      modelConfidence = 0.7;
      uncertaintyAboutUncertainty = 0.3;
      epismicValue = 0.2;
    }
  };

  // ─── ACTIVE INFERENCE ACTION SELECTION ────────────────────────────────────────
  
  /// Expected free energy for policy evaluation
  public type PolicyEvaluation = {
    policy : [Float];
    expectedFreeEnergy : Float;
    pragmaticValue : Float;
    epistemicValue : Float;
    riskSensitivity : Float;
  };

  /// Evaluate expected free energy of a policy
  public func evaluatePolicy(
    state : FristonState,
    policy : [Float],
    desiredOutcome : Float,
    ambiguity : Float
  ) : PolicyEvaluation {
    // Expected free energy = risk + ambiguity
    // Risk = KL[Q(o|π) || P(o)] - expected divergence from preferred outcomes
    // Ambiguity = expected entropy of observations given policy
    
    let n = policy.size();
    var pragmatic : Float = 0.0;
    var epistemic : Float = 0.0;
    
    var i : Nat = 0;
    while (i < n) {
      let action = policy[i];
      // Pragmatic value: How much does this reduce prediction error?
      let predError = Float.abs(action - desiredOutcome);
      pragmatic -= predError;
      
      // Epistemic value: How much information does this action provide?
      epistemic += ambiguity * action;
      i += 1;
    };
    
    // Expected free energy combines both
    let efe = -pragmatic + ambiguity - epistemic;
    
    {
      policy = policy;
      expectedFreeEnergy = efe;
      pragmaticValue = pragmatic;
      epistemicValue = epistemic;
      riskSensitivity = state.riskSensitivity;
    }
  };

  /// Select optimal action via active inference
  public func selectAction(
    state : FristonState,
    possibleActions : [Float],
    desiredOutcome : Float
  ) : Float {
    if (possibleActions.size() == 0) { return 0.0 };
    
    var bestAction = possibleActions[0];
    var bestEFE = 999999.0;
    
    for (action in possibleActions.vals()) {
      // Evaluate single-action policy
      let eval = evaluatePolicy(state, [action], desiredOutcome, state.ambiguity);
      if (eval.expectedFreeEnergy < bestEFE) {
        bestEFE := eval.expectedFreeEnergy;
        bestAction := action;
      };
    };
    
    bestAction
  };

  // ─── CROSS-MODULE INTEGRATION ─────────────────────────────────────────────────
  
  /// Integrate with Kuramoto oscillator coherence
  public func integrateWithKuramoto(
    state : FristonState,
    orderParameter : Float,
    meanPhase : Float,
    coupling : Float
  ) : FristonState {
    // High Kuramoto coherence → lower sensory precision (more certainty)
    // Phase alignment affects prediction timing
    let coherenceFactor = 1.0 + (orderParameter - 0.5) * 0.5;
    let phaseMod = Float.cos(meanPhase) * 0.1;
    
    let newPrecision = _clamp(state.sensoryPrecision * coherenceFactor, 0.1, 10.0);
    let newPrediction = state.prediction + phaseMod;
    
    {
      freeEnergy = state.freeEnergy;
      predictionError = state.predictionError;
      prediction = _clamp(newPrediction, 0.0, 1.0);
      observation = state.observation;
      precision = newPrecision;
      learningRate = state.learningRate;
      complexity = state.complexity;
      rSwarm = state.rSwarm;
      jDrift = state.jDrift;
      sensoryPrecision = newPrecision;
      motorPrecision = state.motorPrecision;
      beliefs = state.beliefs;
      ambiguity = state.ambiguity * (2.0 - orderParameter);
      surprisal = state.surprisal;
      riskSensitivity = state.riskSensitivity;
      explorationBias = state.explorationBias;
      beliefEntropy = state.beliefEntropy;
    }
  };

  /// Integrate with Hebbian plasticity
  public func integrateWithHebbian(
    state : FristonState,
    hebbianWeights : [Float],
    plasticityRate : Float
  ) : FristonState {
    // Hebbian learning modulates model complexity and learning rate
    var avgWeight : Float = 0.0;
    if (hebbianWeights.size() > 0) {
      for (w in hebbianWeights.vals()) { avgWeight += w };
      avgWeight := avgWeight / Float.fromInt(hebbianWeights.size());
    };
    
    let newLearningRate = _clamp(state.learningRate + plasticityRate * avgWeight, 0.001, 1.0);
    let newComplexity = _clamp(state.complexity + plasticityRate * 0.01, 0.0, 10.0);
    
    {
      freeEnergy = state.freeEnergy;
      predictionError = state.predictionError;
      prediction = state.prediction;
      observation = state.observation;
      precision = state.precision;
      learningRate = newLearningRate;
      complexity = newComplexity;
      rSwarm = state.rSwarm;
      jDrift = state.jDrift;
      sensoryPrecision = state.sensoryPrecision;
      motorPrecision = state.motorPrecision;
      beliefs = state.beliefs;
      ambiguity = state.ambiguity;
      surprisal = state.surprisal;
      riskSensitivity = state.riskSensitivity;
      explorationBias = state.explorationBias;
      beliefEntropy = state.beliefEntropy;
    }
  };

  /// Integrate with Attractor dynamics
  public func integrateWithAttractor(
    state : FristonState,
    attractorEnergy : Float,
    basinDepth : Float
  ) : FristonState {
    // Attractor basin depth affects free energy landscape
    // Deep basins → lower free energy, higher stability
    let energyMod = attractorEnergy * 0.1;
    let stabilityFactor = 1.0 / (1.0 + basinDepth);
    
    let newFreeEnergy = state.freeEnergy + energyMod;
    let newRisk = _clamp(state.riskSensitivity * stabilityFactor, 0.0, 2.0);
    
    {
      freeEnergy = newFreeEnergy;
      predictionError = state.predictionError;
      prediction = state.prediction;
      observation = state.observation;
      precision = state.precision;
      learningRate = state.learningRate;
      complexity = state.complexity;
      rSwarm = state.rSwarm;
      jDrift = state.jDrift;
      sensoryPrecision = state.sensoryPrecision;
      motorPrecision = state.motorPrecision;
      beliefs = state.beliefs;
      ambiguity = state.ambiguity;
      surprisal = state.surprisal;
      riskSensitivity = newRisk;
      explorationBias = state.explorationBias;
      beliefEntropy = state.beliefEntropy;
    }
  };

  /// Integrate with Predictive Coding
  public func integrateWithPredictive(
    state : FristonState,
    hierarchicalErrors : [Float],
    contextualPrior : Float
  ) : FristonState {
    // Hierarchical prediction errors sum into total free energy
    var totalError : Float = 0.0;
    for (err in hierarchicalErrors.vals()) {
      totalError += err * err;
    };
    
    // Contextual prior modulates beliefs
    let contextMod = (contextualPrior - 0.5) * 0.2;
    let newBeliefs = Array.tabulate<Float>(state.beliefs.size(), func(i) {
      _clamp(state.beliefs[i] + contextMod, 0.0, 1.0)
    });
    
    {
      freeEnergy = state.freeEnergy + totalError;
      predictionError = state.predictionError + Float.sqrt(totalError) * 0.1;
      prediction = state.prediction;
      observation = state.observation;
      precision = state.precision;
      learningRate = state.learningRate;
      complexity = state.complexity;
      rSwarm = state.rSwarm;
      jDrift = state.jDrift;
      sensoryPrecision = state.sensoryPrecision;
      motorPrecision = state.motorPrecision;
      beliefs = newBeliefs;
      ambiguity = state.ambiguity;
      surprisal = state.surprisal + Float.sqrt(totalError) * 0.05;
      riskSensitivity = state.riskSensitivity;
      explorationBias = state.explorationBias;
      beliefEntropy = state.beliefEntropy;
    }
  };

  /// Integrate with Quantum systems
  public func integrateWithQuantum(
    state : FristonState,
    quantumCoherence : Float,
    superpositionWeight : Float
  ) : FristonState {
    // Quantum coherence affects belief superposition
    // Higher coherence → more parallel hypothesis evaluation
    let coherenceFactor = 1.0 + quantumCoherence * 0.3;
    let newEntropy = _clamp(state.beliefEntropy * (1.0 + superpositionWeight * 0.2), 0.0, 10.0);
    let newExploration = _clamp(state.explorationBias + superpositionWeight * 0.1, 0.0, 1.0);
    
    {
      freeEnergy = state.freeEnergy;
      predictionError = state.predictionError;
      prediction = state.prediction;
      observation = state.observation;
      precision = state.precision * coherenceFactor;
      learningRate = state.learningRate;
      complexity = state.complexity;
      rSwarm = state.rSwarm;
      jDrift = state.jDrift;
      sensoryPrecision = state.sensoryPrecision;
      motorPrecision = state.motorPrecision;
      beliefs = state.beliefs;
      ambiguity = state.ambiguity;
      surprisal = state.surprisal;
      riskSensitivity = state.riskSensitivity;
      explorationBias = newExploration;
      beliefEntropy = newEntropy;
    }
  };

  // ─── ALLOSTATIC REGULATION ────────────────────────────────────────────────────
  
  /// Allostatic state for homeostatic predictive regulation
  public type AllostaticState = {
    setpoints : [Float];
    currentValues : [Float];
    errors : [Float];
    drives : [Float];
    totalDrive : Float;
    regulatoryCapacity : Float;
  };

  /// Compute allostatic error and drive
  public func computeAllostasis(
    setpoints : [Float],
    currentValues : [Float]
  ) : AllostaticState {
    let n = setpoints.size();
    let m = currentValues.size();
    let size = if (n < m) { n } else { m };
    
    var errors : [Float] = [];
    var drives : [Float] = [];
    var totalDrive : Float = 0.0;
    
    var i : Nat = 0;
    while (i < size) {
      let err = currentValues[i] - setpoints[i];
      let drive = Float.abs(err);
      errors := Array.append(errors, [err]);
      drives := Array.append(drives, [drive]);
      totalDrive += drive;
      i += 1;
    };
    
    let capacity = 1.0 / (1.0 + totalDrive);
    
    {
      setpoints = setpoints;
      currentValues = currentValues;
      errors = errors;
      drives = drives;
      totalDrive = totalDrive;
      regulatoryCapacity = _clamp(capacity, 0.0, 1.0);
    }
  };

  /// Update free energy with allostatic regulation
  public func updateWithAllostasis(
    state : FristonState,
    allostasis : AllostaticState
  ) : FristonState {
    // Allostatic error contributes to free energy
    let allostaticFreeEnergy = allostasis.totalDrive * 0.5;
    
    // High allostatic drive → increase motor precision (prioritize action)
    let newMotorPrecision = _clamp(
      state.motorPrecision + allostasis.totalDrive * 0.1,
      0.1, 5.0
    );
    
    {
      freeEnergy = state.freeEnergy + allostaticFreeEnergy;
      predictionError = state.predictionError;
      prediction = state.prediction;
      observation = state.observation;
      precision = state.precision;
      learningRate = state.learningRate;
      complexity = state.complexity;
      rSwarm = state.rSwarm;
      jDrift = state.jDrift;
      sensoryPrecision = state.sensoryPrecision;
      motorPrecision = newMotorPrecision;
      beliefs = state.beliefs;
      ambiguity = state.ambiguity;
      surprisal = state.surprisal;
      riskSensitivity = state.riskSensitivity + allostasis.totalDrive * 0.05;
      explorationBias = state.explorationBias;
      beliefEntropy = state.beliefEntropy;
    }
  };

  // ─── TEMPORAL DEEP INFERENCE ──────────────────────────────────────────────────
  
  /// Temporal inference state
  public type TemporalInferenceState = {
    pastBeliefs : [[Float]];
    currentBeliefs : [Float];
    futureBeliefs : [[Float]];
    temporalCoherence : Float;
    narrativeIntegration : Float;
  };

  /// Compute temporal depth inference
  public func temporalInference(
    state : FristonState,
    pastObservations : [Float],
    futureGoals : [Float],
    discount : Float
  ) : TemporalInferenceState {
    let pastSize = pastObservations.size();
    let futureSize = futureGoals.size();
    
    // Reconstruct past beliefs from observations
    var pastBeliefs : [[Float]] = [];
    var i : Nat = 0;
    while (i < pastSize) {
      let weight = Float.pow(discount, Float.fromInt(pastSize - i));
      let belief = [pastObservations[i] * weight];
      pastBeliefs := Array.append(pastBeliefs, [belief]);
      i += 1;
    };
    
    // Project future beliefs from goals
    var futureBeliefs : [[Float]] = [];
    var j : Nat = 0;
    while (j < futureSize) {
      let weight = Float.pow(discount, Float.fromInt(j + 1));
      let belief = [futureGoals[j] * weight];
      futureBeliefs := Array.append(futureBeliefs, [belief]);
      j += 1;
    };
    
    // Temporal coherence: how consistent are beliefs over time?
    var coherence : Float = 0.0;
    if (pastSize > 1) {
      var k : Nat = 1;
      while (k < pastSize) {
        let diff = Float.abs(pastObservations[k] - pastObservations[k - 1]);
        coherence += 1.0 - _clamp(diff, 0.0, 1.0);
        k += 1;
      };
      coherence := coherence / Float.fromInt(pastSize - 1);
    };
    
    // Narrative integration: connection between past and future
    var narrative : Float = 0.5;
    if (pastSize > 0 and futureSize > 0) {
      let pastMean = pastObservations[pastSize - 1];
      let futureMean = futureGoals[0];
      narrative := 1.0 - Float.abs(pastMean - futureMean);
    };
    
    {
      pastBeliefs = pastBeliefs;
      currentBeliefs = state.beliefs;
      futureBeliefs = futureBeliefs;
      temporalCoherence = _clamp(coherence, 0.0, 1.0);
      narrativeIntegration = _clamp(narrative, 0.0, 1.0);
    }
  };

  // ─── HIERARCHICAL MESSAGE PASSING ─────────────────────────────────────────────
  
  /// Hierarchical level state
  public type HierarchicalLevel = {
    level : Nat;
    predictions : [Float];
    errors : [Float];
    precision : Float;
    modelParameters : [Float];
  };

  /// Full hierarchical model
  public type HierarchicalModel = {
    levels : [HierarchicalLevel];
    totalFreeEnergy : Float;
    convergence : Float;
  };

  /// Perform hierarchical message passing
  public func hierarchicalMessagePassing(
    observations : [Float],
    numLevels : Nat,
    iterations : Nat
  ) : HierarchicalModel {
    // Initialize levels
    var levels : [HierarchicalLevel] = [];
    var currentInput = observations;
    
    var l : Nat = 0;
    while (l < numLevels) {
      // Each level predicts the level below
      var predictions : [Float] = [];
      var errors : [Float] = [];
      
      for (obs in currentInput.vals()) {
        let pred = obs * 0.9;  // Simple decay prediction
        predictions := Array.append(predictions, [pred]);
        errors := Array.append(errors, [obs - pred]);
      };
      
      levels := Array.append(levels, [{
        level = l;
        predictions = predictions;
        errors = errors;
        precision = 1.0 / Float.fromInt(l + 1);
        modelParameters = [0.9, 0.1];  // Simple params
      }]);
      
      // Higher level receives predictions from below
      currentInput := predictions;
      l += 1;
    };
    
    // Compute total free energy
    var totalFE : Float = 0.0;
    for (level in levels.vals()) {
      for (err in level.errors.vals()) {
        totalFE += level.precision * err * err;
      };
    };
    
    // Convergence metric (simplified)
    let convergence = 1.0 / (1.0 + totalFE);
    
    {
      levels = levels;
      totalFreeEnergy = totalFE;
      convergence = _clamp(convergence, 0.0, 1.0);
    }
  };

  // ─── ORGANISM OUTPUT INTEGRATION ──────────────────────────────────────────────
  
  /// Complete organism output from Friston engine
  public type FristonOrganismOutput = {
    // Core metrics
    totalFreeEnergy : Float;
    predictionError : Float;
    surprisal : Float;
    
    // Precision-weighted metrics
    sensoryPrecision : Float;
    motorPrecision : Float;
    
    // Active inference
    expectedFreeEnergy : Float;
    optimalAction : Float;
    explorationVsExploitation : Float;
    
    // Allostatic state
    allostaticDrive : Float;
    regulatoryCapacity : Float;
    
    // Temporal integration
    temporalCoherence : Float;
    narrativeIntegration : Float;
    
    // Model quality
    modelComplexity : Float;
    modelAccuracy : Float;
    evidenceLowerBound : Float;
  };

  /// Generate full organism output
  public func generateOrganismOutput(
    state : FristonState,
    allostaticSetpoints : [Float],
    currentValues : [Float]
  ) : FristonOrganismOutput {
    let allostasis = computeAllostasis(allostaticSetpoints, currentValues);
    
    // Compute expected free energy for default action
    let efe = state.freeEnergy + state.ambiguity - state.explorationBias;
    
    // Exploration vs exploitation balance
    let exploreExploit = state.explorationBias / (state.riskSensitivity + 0.01);
    
    // Model accuracy from prediction error
    let accuracy = 1.0 / (1.0 + state.predictionError);
    
    // Evidence lower bound approximation
    let elbo = -state.freeEnergy + state.complexity * 0.1;
    
    {
      totalFreeEnergy = state.freeEnergy;
      predictionError = state.predictionError;
      surprisal = state.surprisal;
      sensoryPrecision = state.sensoryPrecision;
      motorPrecision = state.motorPrecision;
      expectedFreeEnergy = efe;
      optimalAction = selectAction(state, [0.0, 0.25, 0.5, 0.75, 1.0], 0.5);
      explorationVsExploitation = _clamp(exploreExploit, 0.0, 1.0);
      allostaticDrive = allostasis.totalDrive;
      regulatoryCapacity = allostasis.regulatoryCapacity;
      temporalCoherence = 0.5;  // Would come from temporal inference
      narrativeIntegration = 0.5;
      modelComplexity = state.complexity;
      modelAccuracy = _clamp(accuracy, 0.0, 1.0);
      evidenceLowerBound = elbo;
    }
  };

  // ─── OUTWARD EXTENSIONS TO OTHER SYSTEMS ──────────────────────────────────────
  
  /// Output for Kuramoto
  public func outputToKuramoto(state : FristonState) : { couplingMod : Float; phaseBias : Float } {
    // Free energy modulates coupling strength
    let coupling = 1.0 / (1.0 + state.freeEnergy * 0.1);
    // Prediction bias affects phase preference
    let phase = state.prediction * 6.28318;
    {
      couplingMod = _clamp(coupling, 0.1, 2.0);
      phaseBias = phase;
    }
  };

  /// Output for Hebbian
  public func outputToHebbian(state : FristonState) : { learningSignal : Float; consolidationStrength : Float } {
    // Low free energy → high consolidation
    let consolidation = 1.0 / (1.0 + state.freeEnergy);
    // Surprisal drives learning
    let learning = state.surprisal * state.learningRate;
    {
      learningSignal = _clamp(learning, 0.0, 1.0);
      consolidationStrength = _clamp(consolidation, 0.0, 1.0);
    }
  };

  /// Output for Attractor
  public func outputToAttractor(state : FristonState) : { basinAttraction : Float; energyLandscape : Float } {
    // Beliefs define attractor basins
    var meanBelief : Float = 0.0;
    if (state.beliefs.size() > 0) {
      for (b in state.beliefs.vals()) { meanBelief += b };
      meanBelief := meanBelief / Float.fromInt(state.beliefs.size());
    };
    {
      basinAttraction = meanBelief;
      energyLandscape = state.freeEnergy;
    }
  };

  /// Output for Predictive Coding
  public func outputToPredictive(state : FristonState) : { topDownPrediction : Float; bottomUpError : Float } {
    {
      topDownPrediction = state.prediction;
      bottomUpError = state.predictionError;
    }
  };

  /// Output for Quantum
  public func outputToQuantum(state : FristonState) : { coherenceTarget : Float; measurementBasis : Float } {
    // Precision determines measurement basis
    {
      coherenceTarget = state.precision / (state.precision + 1.0);
      measurementBasis = state.beliefEntropy;
    }
  };

  /// Output for Defense
  public func outputToDefense(state : FristonState) : { threatAssessment : Float; responseUrgency : Float } {
    // High free energy = potential threat
    let threat = _clamp(state.freeEnergy / 10.0, 0.0, 1.0);
    // High surprisal = urgent response needed
    let urgency = _clamp(state.surprisal, 0.0, 1.0);
    {
      threatAssessment = threat;
      responseUrgency = urgency;
    }
  };

  /// Master output function
  public func generateAllOutputs(state : FristonState) : {
    kuramoto : { couplingMod : Float; phaseBias : Float };
    hebbian : { learningSignal : Float; consolidationStrength : Float };
    attractor : { basinAttraction : Float; energyLandscape : Float };
    predictive : { topDownPrediction : Float; bottomUpError : Float };
    quantum : { coherenceTarget : Float; measurementBasis : Float };
    defense : { threatAssessment : Float; responseUrgency : Float };
    organism : FristonOrganismOutput;
  } {
    {
      kuramoto = outputToKuramoto(state);
      hebbian = outputToHebbian(state);
      attractor = outputToAttractor(state);
      predictive = outputToPredictive(state);
      quantum = outputToQuantum(state);
      defense = outputToDefense(state);
      organism = generateOrganismOutput(state, [0.5, 0.5, 0.5], [0.5, 0.5, 0.5]);
    }
  };

  // ─── FULL ORGANISM BEAT ───────────────────────────────────────────────────────
  
  /// Complete organism integration beat
  public func fullOrganismBeat(
    state : FristonState,
    observation : Float,
    kuramotoOrder : Float,
    hebbianWeights : [Float],
    attractorEnergy : Float,
    quantumCoherence : Float
  ) : (FristonState, FristonOrganismOutput) {
    // Layer 1: Core free energy minimization
    var newState = minimizeFreeEnergy(state, observation, 1.0);
    
    // Layer 2: Kuramoto integration
    newState := integrateWithKuramoto(newState, kuramotoOrder, 0.0, 1.0);
    
    // Layer 3: Hebbian integration
    newState := integrateWithHebbian(newState, hebbianWeights, 0.01);
    
    // Layer 4: Attractor integration
    newState := integrateWithAttractor(newState, attractorEnergy, 0.5);
    
    // Layer 5: Quantum integration
    newState := integrateWithQuantum(newState, quantumCoherence, 0.3);
    
    // Generate organism output
    let output = generateOrganismOutput(newState, [0.5], [observation]);
    
    (newState, output)
  };

}
