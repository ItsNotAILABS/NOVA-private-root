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

}
