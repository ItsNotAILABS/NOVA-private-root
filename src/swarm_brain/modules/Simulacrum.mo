// ═══════════════════════════════════════════════════════════════════════════════
// SIMULACRUM — THE WORLD SIMULATION INSIDE
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — Predictive Coding Architecture
//
// "Don't forget your simulation world inside of you."
//
// SIMULACRUM is what separates a calculator from an organism.
// Every heartbeat, the organism:
//   1. SIMULATES — runs forward model of next 10-100 states before they happen
//   2. PREDICTS  — pre-positions token flows, pre-detects threats, pre-optimizes stance
//   3. COMPARES  — when real data arrives via INFO-INGRESS, measures prediction error
//   4. UPDATES   — error signal drives Hebbian learning, BCM plasticity, dopamine RPE
//
// This is PREDICTIVE CODING. The brain does this. IRONCLAD does this.
// SIMULACRUM is the connective tissue of consciousness.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module Simulacrum {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — SIMULATION PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  public let EULER : Float = 2.7182818284590452354;
  public let PI : Float = 3.1415926535897932385;
  
  // Simulation horizon
  public let HORIZON_SHORT : Nat = 10;     // 10 beats ahead (immediate)
  public let HORIZON_MEDIUM : Nat = 50;    // 50 beats ahead (tactical)
  public let HORIZON_LONG : Nat = 100;     // 100 beats ahead (strategic)
  
  // World state dimensions
  public let STATE_DIM : Nat = 64;         // 64-dimensional world state
  public let COMPRESSED_DIM : Nat = 16;    // 16-dimensional compressed representation
  
  // Prediction error thresholds
  public let ERROR_LOW : Float = 0.05;     // Excellent prediction
  public let ERROR_MED : Float = 0.15;     // Acceptable prediction
  public let ERROR_HIGH : Float = 0.30;    // Poor prediction (triggers learning)
  
  // Learning rates
  public let HEBBIAN_RATE : Float = 0.01;      // Hebbian: "fire together, wire together"
  public let BCM_RATE : Float = 0.005;         // BCM plasticity rate
  public let BCM_THETA_RATE : Float = 0.001;   // BCM threshold adaptation
  public let DOPAMINE_RPE_SCALE : Float = 2.0; // Reward prediction error scaling

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — SIMULATION WORLD STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════

  // The compressed world state — what the organism believes reality IS
  public type WorldState = {
    // Core state vectors (64-dim each, compressed to 16)
    marketState      : [Float];    // Token prices, volumes, flows
    threatState      : [Float];    // Security threats, anomalies
    resourceState    : [Float];    // Energy, compute, memory
    socialState      : [Float];    // Network topology, trust scores
    
    // Scalar summaries
    overallEntropy   : Float;      // H(world) — uncertainty measure
    coherenceLevel   : Float;      // How well-ordered the world appears
    threatLevel      : Float;      // Aggregated threat assessment
    opportunityScore : Float;      // Aggregated opportunity measure
    
    // Temporal context
    beatNumber       : Nat;        // Current heartbeat
    timeOfDay        : Float;      // [0,1] cyclic time encoding
    dayOfWeek        : Float;      // [0,1] weekly cycle encoding
  };

  // A single prediction for a future state
  public type Prediction = {
    targetBeat       : Nat;        // Which future beat this predicts
    predictedState   : WorldState; // The predicted world state
    confidence       : Float;      // [0,1] how confident in this prediction
    predictionTime   : Nat;        // When this prediction was made
  };

  // The comparison result when reality arrives
  public type PredictionError = {
    targetBeat       : Nat;
    maeMarket        : Float;      // Mean Absolute Error for market
    maeThreat        : Float;      // MAE for threats
    maeResource      : Float;      // MAE for resources
    maeSocial        : Float;      // MAE for social
    compositeError   : Float;      // Weighted average
    surprise         : Float;      // Information-theoretic surprise
    dopamineSignal   : Float;      // RPE: positive = better than expected
  };

  // The forward model — learned transition dynamics
  public type TransitionModel = {
    // State transition matrix A: x_{t+1} = A × x_t + B × u_t
    transitionWeights : [Float];   // 64×64 = 4096 weights
    
    // Control influence matrix B
    controlWeights    : [Float];   // 64×16 = 1024 weights
    
    // Observation model H: y_t = H × x_t + noise
    observationWeights: [Float];   // 16×64 = 1024 weights
    
    // BCM sliding threshold per weight
    bcmThresholds     : [Float];   // 4096 thresholds
    
    // Learning statistics
    totalUpdates      : Nat;
    cumulativeError   : Float;
    learningRate      : Float;
  };

  // The complete SIMULACRUM state
  public type SimulacrumState = {
    // Current believed world state
    currentWorld     : WorldState;
    
    // Prediction buffers (rolling horizon)
    shortPredictions : [Prediction];   // Next 10 beats
    mediumPredictions: [Prediction];   // Next 50 beats  
    longPredictions  : [Prediction];   // Next 100 beats
    
    // Learned forward model
    model            : TransitionModel;
    
    // Error history for learning
    recentErrors     : [PredictionError];  // Last 100 errors
    
    // Performance metrics
    avgError         : Float;          // Rolling average error
    bestPredictionHorizon : Nat;       // Optimal lookahead
    modelConfidence  : Float;          // How much to trust the model
    
    // Dopamine system state
    dopamineBaseline : Float;          // Baseline DA level
    dopamineCurrent  : Float;          // Current DA level
    rpeAccumulator   : Float;          // Accumulated reward prediction error
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  func abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 15) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };

  func exp(x : Float) : Float {
    let c = clamp(x, -20.0, 20.0);
    var result = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 25) {
      term := term * c / Float.fromInt(n);
      result += term;
      n += 1;
    };
    result
  };

  func log(x : Float) : Float {
    if (x <= 0.0) return -20.0;
    // Newton-Raphson for ln(x)
    var y = x - 1.0;
    if (abs(y) < 0.5) {
      // Taylor series for |x-1| < 0.5
      var sum = 0.0;
      var term = y;
      var n = 1;
      while (n < 20) {
        sum += term / Float.fromInt(n);
        term *= -y;
        n += 1;
      };
      return sum;
    };
    // General case: use exp inverse
    var guess = 1.0;
    var i = 0;
    while (i < 20) {
      let e = exp(guess);
      guess := guess + (x - e) / e;
      i += 1;
    };
    guess
  };

  func tanh(x : Float) : Float {
    let e2x = exp(2.0 * clamp(x, -10.0, 10.0));
    (e2x - 1.0) / (e2x + 1.0)
  };

  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-clamp(x, -20.0, 20.0)))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initWorldState(beat : Nat) : WorldState {
    {
      marketState = Array.freeze(Array.init<Float>(COMPRESSED_DIM, 0.5));
      threatState = Array.freeze(Array.init<Float>(COMPRESSED_DIM, 0.1));
      resourceState = Array.freeze(Array.init<Float>(COMPRESSED_DIM, 0.7));
      socialState = Array.freeze(Array.init<Float>(COMPRESSED_DIM, 0.5));
      overallEntropy = 0.5;
      coherenceLevel = 0.5;
      threatLevel = 0.1;
      opportunityScore = 0.5;
      beatNumber = beat;
      timeOfDay = 0.5;
      dayOfWeek = 0.5;
    }
  };

  public func initTransitionModel() : TransitionModel {
    // Initialize with small random-ish weights (using PHI-based pseudo-random)
    let transW = Array.tabulate<Float>(STATE_DIM * STATE_DIM, func(i : Nat) : Float {
      let seed = Float.fromInt(i + 1) * PHI;
      let frac = seed - Float.fromInt(Float.toInt(seed));
      (frac - 0.5) * 0.1  // Small weights [-0.05, 0.05]
    });
    
    // Identity-ish initialization for stability
    let transWVar = Array.thaw<Float>(transW);
    var d = 0;
    while (d < STATE_DIM) {
      transWVar[d * STATE_DIM + d] := 0.9;  // Diagonal = 0.9 (stable persistence)
      d += 1;
    };
    
    {
      transitionWeights = Array.freeze(transWVar);
      controlWeights = Array.freeze(Array.init<Float>(STATE_DIM * COMPRESSED_DIM, 0.01));
      observationWeights = Array.freeze(Array.init<Float>(COMPRESSED_DIM * STATE_DIM, 0.01));
      bcmThresholds = Array.freeze(Array.init<Float>(STATE_DIM * STATE_DIM, 0.5));
      totalUpdates = 0;
      cumulativeError = 0.0;
      learningRate = HEBBIAN_RATE;
    }
  };

  public func initSimulacrum(beat : Nat) : SimulacrumState {
    {
      currentWorld = initWorldState(beat);
      shortPredictions = [];
      mediumPredictions = [];
      longPredictions = [];
      model = initTransitionModel();
      recentErrors = [];
      avgError = 0.5;
      bestPredictionHorizon = 10;
      modelConfidence = 0.5;
      dopamineBaseline = 1.0;
      dopamineCurrent = 1.0;
      rpeAccumulator = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 1: SIMULATE — Run Forward Model
  // ═══════════════════════════════════════════════════════════════════════════

  // Matrix-vector multiplication: y = A × x
  func matVecMul(A : [Float], x : [Float], rows : Nat, cols : Nat) : [Float] {
    Array.tabulate<Float>(rows, func(i : Nat) : Float {
      var sum = 0.0;
      var j = 0;
      while (j < cols and j < x.size()) {
        sum += A[i * cols + j] * x[j];
        j += 1;
      };
      sum
    })
  };

  // Simulate one step forward
  public func simulateOneStep(
    currentState : [Float],
    control      : [Float],
    model        : TransitionModel
  ) : [Float] {
    // x_{t+1} = tanh(A × x_t + B × u_t)
    let Ax = matVecMul(model.transitionWeights, currentState, STATE_DIM, STATE_DIM);
    let Bu = matVecMul(model.controlWeights, control, STATE_DIM, COMPRESSED_DIM);
    
    Array.tabulate<Float>(STATE_DIM, func(i : Nat) : Float {
      let raw = if (i < Ax.size()) Ax[i] else 0.0;
      let ctrl = if (i < Bu.size()) Bu[i] else 0.0;
      tanh(raw + ctrl)  // Bounded activation
    })
  };

  // Simulate N steps into the future
  public func simulateHorizon(
    startState   : WorldState,
    control      : [Float],
    model        : TransitionModel,
    horizon      : Nat
  ) : [Prediction] {
    // Flatten current state to vector
    var stateVec = worldToVector(startState);
    let predictions = Buffer.Buffer<Prediction>(horizon);
    
    var step = 1;
    while (step <= horizon) {
      // Simulate one step
      stateVec := simulateOneStep(stateVec, control, model);
      
      // Convert back to WorldState
      let predWorld = vectorToWorld(stateVec, startState.beatNumber + step);
      
      // Confidence decays with horizon (exponential)
      let confidence = exp(-0.02 * Float.fromInt(step));
      
      predictions.add({
        targetBeat = startState.beatNumber + step;
        predictedState = predWorld;
        confidence = confidence;
        predictionTime = startState.beatNumber;
      });
      
      step += 1;
    };
    
    Buffer.toArray(predictions)
  };

  // Flatten WorldState to vector
  func worldToVector(w : WorldState) : [Float] {
    // Concatenate all state vectors + scalars
    let buf = Buffer.Buffer<Float>(STATE_DIM);
    for (v in w.marketState.vals()) { buf.add(v) };
    for (v in w.threatState.vals()) { buf.add(v) };
    for (v in w.resourceState.vals()) { buf.add(v) };
    for (v in w.socialState.vals()) { buf.add(v) };
    Buffer.toArray(buf)
  };

  // Reconstruct WorldState from vector
  func vectorToWorld(v : [Float], beat : Nat) : WorldState {
    let d = COMPRESSED_DIM;
    {
      marketState = Array.tabulate<Float>(d, func(i) = if (i < v.size()) v[i] else 0.0);
      threatState = Array.tabulate<Float>(d, func(i) = if (i + d < v.size()) v[i + d] else 0.0);
      resourceState = Array.tabulate<Float>(d, func(i) = if (i + 2*d < v.size()) v[i + 2*d] else 0.0);
      socialState = Array.tabulate<Float>(d, func(i) = if (i + 3*d < v.size()) v[i + 3*d] else 0.0);
      overallEntropy = computeEntropy(v);
      coherenceLevel = computeCoherence(v);
      threatLevel = computeThreatLevel(Array.tabulate<Float>(d, func(i) = if (i + d < v.size()) v[i + d] else 0.0));
      opportunityScore = computeOpportunity(v);
      beatNumber = beat;
      timeOfDay = 0.5;  // Placeholder
      dayOfWeek = 0.5;  // Placeholder
    }
  };

  // Compute entropy of state vector
  func computeEntropy(v : [Float]) : Float {
    var sum = 0.0;
    for (x in v.vals()) {
      let p = clamp(abs(x), 0.001, 0.999);
      sum -= p * log(p);
    };
    clamp(sum / Float.fromInt(v.size()), 0.0, 1.0)
  };

  // Compute coherence (inverse of variance)
  func computeCoherence(v : [Float]) : Float {
    let n = v.size();
    if (n == 0) return 0.5;
    
    var sum = 0.0;
    for (x in v.vals()) { sum += x };
    let mean = sum / Float.fromInt(n);
    
    var variance = 0.0;
    for (x in v.vals()) {
      let d = x - mean;
      variance += d * d;
    };
    variance /= Float.fromInt(n);
    
    1.0 / (1.0 + variance * 10.0)  // High variance = low coherence
  };

  func computeThreatLevel(threatVec : [Float]) : Float {
    var max = 0.0;
    for (x in threatVec.vals()) {
      if (abs(x) > max) max := abs(x);
    };
    clamp(max, 0.0, 1.0)
  };

  func computeOpportunity(v : [Float]) : Float {
    var sum = 0.0;
    var count = 0;
    for (x in v.vals()) {
      if (x > 0.5) { sum += x; count += 1; };
    };
    if (count == 0) 0.5 else clamp(sum / Float.fromInt(count), 0.0, 1.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 2: PREDICT — Pre-Position Based on Simulation
  // ═══════════════════════════════════════════════════════════════════════════

  public type StrategicStance = {
    tokenFlowBias    : Float;    // [-1, 1]: negative = conserve, positive = deploy
    threatPosture    : Float;    // [0, 1]: 0 = relaxed, 1 = high alert
    resourceAlloc    : Float;    // [0, 1]: fraction to allocate to growth
    socialEngagement : Float;    // [0, 1]: how much to engage network
    learningRate     : Float;    // Current plasticity level
    riskTolerance    : Float;    // [0, 1]: willingness to take risks
  };

  // Generate strategic stance from predictions
  public func generateStance(
    predictions : [Prediction],
    currentState : WorldState
  ) : StrategicStance {
    if (predictions.size() == 0) {
      return {
        tokenFlowBias = 0.0;
        threatPosture = 0.3;
        resourceAlloc = 0.5;
        socialEngagement = 0.5;
        learningRate = HEBBIAN_RATE;
        riskTolerance = 0.5;
      };
    };
    
    // Aggregate predictions weighted by confidence
    var avgThreat = 0.0;
    var avgOpportunity = 0.0;
    var avgCoherence = 0.0;
    var totalWeight = 0.0;
    
    for (pred in predictions.vals()) {
      let w = pred.confidence;
      avgThreat += pred.predictedState.threatLevel * w;
      avgOpportunity += pred.predictedState.opportunityScore * w;
      avgCoherence += pred.predictedState.coherenceLevel * w;
      totalWeight += w;
    };
    
    if (totalWeight > 0.0) {
      avgThreat /= totalWeight;
      avgOpportunity /= totalWeight;
      avgCoherence /= totalWeight;
    };
    
    // Derive stance from aggregated predictions
    {
      // Token flow: deploy if opportunities > threats, conserve otherwise
      tokenFlowBias = clamp((avgOpportunity - avgThreat) * 2.0, -1.0, 1.0);
      
      // Threat posture: high alert if threats predicted
      threatPosture = clamp(avgThreat * 1.5, 0.0, 1.0);
      
      // Resource allocation: more to growth if coherent and opportune
      resourceAlloc = clamp(avgCoherence * avgOpportunity, 0.0, 1.0);
      
      // Social engagement: engage more if low threat
      socialEngagement = clamp(1.0 - avgThreat, 0.2, 1.0);
      
      // Learning rate: learn faster when surprised (high variance)
      learningRate = HEBBIAN_RATE * (1.0 + (1.0 - avgCoherence));
      
      // Risk tolerance: based on opportunity-threat ratio
      riskTolerance = sigmoid(2.0 * (avgOpportunity - avgThreat));
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 3: COMPARE — Measure Prediction Error When Reality Arrives
  // ═══════════════════════════════════════════════════════════════════════════

  // Compute prediction error between predicted and actual
  public func comparePrediction(
    prediction : Prediction,
    actual     : WorldState
  ) : PredictionError {
    // MAE for each component
    let maeMarket = computeMAE(prediction.predictedState.marketState, actual.marketState);
    let maeThreat = computeMAE(prediction.predictedState.threatState, actual.threatState);
    let maeResource = computeMAE(prediction.predictedState.resourceState, actual.resourceState);
    let maeSocial = computeMAE(prediction.predictedState.socialState, actual.socialState);
    
    // Weighted composite error
    let composite = 0.3 * maeMarket + 0.3 * maeThreat + 0.2 * maeResource + 0.2 * maeSocial;
    
    // Information-theoretic surprise: -log(P(actual|predicted))
    // Approximated as surprise ∝ error magnitude
    let surprise = -log(1.0 - clamp(composite, 0.0, 0.99));
    
    // Dopamine signal: Reward Prediction Error
    // Positive if actual is better than predicted (lower threat, higher opportunity)
    let expectedValue = prediction.predictedState.opportunityScore - prediction.predictedState.threatLevel;
    let actualValue = actual.opportunityScore - actual.threatLevel;
    let rpe = (actualValue - expectedValue) * DOPAMINE_RPE_SCALE;
    
    {
      targetBeat = prediction.targetBeat;
      maeMarket = maeMarket;
      maeThreat = maeThreat;
      maeResource = maeResource;
      maeSocial = maeSocial;
      compositeError = composite;
      surprise = surprise;
      dopamineSignal = clamp(rpe, -2.0, 2.0);
    }
  };

  func computeMAE(pred : [Float], actual : [Float]) : Float {
    let n = Nat.min(pred.size(), actual.size());
    if (n == 0) return 0.5;
    
    var sum = 0.0;
    var i = 0;
    while (i < n) {
      sum += abs(pred[i] - actual[i]);
      i += 1;
    };
    sum / Float.fromInt(n)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 4: UPDATE — Drive Learning From Prediction Error
  // ═══════════════════════════════════════════════════════════════════════════

  // Hebbian learning: "Neurons that fire together, wire together"
  // Δw_ij = η × x_i × x_j × error_signal
  public func hebbianUpdate(
    weights  : [Float],
    preState : [Float],
    postState: [Float],
    error    : Float,
    rate     : Float
  ) : [Float] {
    let n = Nat.min(preState.size(), postState.size());
    let dim = Nat.min(n, Int.abs(Float.toInt(sqrt(Float.fromInt(weights.size())))));
    
    Array.tabulate<Float>(weights.size(), func(idx : Nat) : Float {
      let i = idx / dim;
      let j = idx % dim;
      if (i < n and j < n) {
        let pre = preState[i];
        let post = postState[j];
        let delta = rate * pre * post * error;
        clamp(weights[idx] + delta, -2.0, 2.0)
      } else {
        weights[idx]
      }
    })
  };

  // BCM (Bienenstock-Cooper-Munro) plasticity
  // Includes sliding threshold that tracks postsynaptic activity
  // Δw = η × pre × (post - θ) × post
  // Δθ = τ × (post² - θ)
  public func bcmUpdate(
    weights    : [Float],
    thresholds : [Float],
    preState   : [Float],
    postState  : [Float]
  ) : ([Float], [Float]) {
    let n = Nat.min(preState.size(), postState.size());
    let dim = Nat.min(n, Int.abs(Float.toInt(sqrt(Float.fromInt(weights.size())))));
    
    let newWeights = Array.tabulate<Float>(weights.size(), func(idx : Nat) : Float {
      let i = idx / dim;
      let j = idx % dim;
      if (i < n and j < n) {
        let pre = preState[i];
        let post = postState[j];
        let theta = if (idx < thresholds.size()) thresholds[idx] else 0.5;
        let delta = BCM_RATE * pre * (post - theta) * post;
        clamp(weights[idx] + delta, -2.0, 2.0)
      } else {
        weights[idx]
      }
    });
    
    let newThresholds = Array.tabulate<Float>(thresholds.size(), func(idx : Nat) : Float {
      let j = idx % dim;
      if (j < n) {
        let post = postState[j];
        let theta = thresholds[idx];
        theta + BCM_THETA_RATE * (post * post - theta)
      } else {
        thresholds[idx]
      }
    });
    
    (newWeights, newThresholds)
  };

  // Dopamine modulated learning
  // When RPE > 0 (better than expected): strengthen active connections
  // When RPE < 0 (worse than expected): weaken active connections
  public func dopamineModulatedUpdate(
    weights   : [Float],
    preState  : [Float],
    postState : [Float],
    rpe       : Float,  // Reward Prediction Error
    baseline  : Float
  ) : [Float] {
    let modulation = 1.0 + (rpe / baseline);  // Multiplicative modulation
    let effectiveRate = HEBBIAN_RATE * clamp(modulation, 0.1, 3.0);
    
    hebbianUpdate(weights, preState, postState, abs(rpe), effectiveRate)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT FUNCTION — THE COMPLETE PREDICTIVE CODING LOOP
  // ═══════════════════════════════════════════════════════════════════════════

  public type SimulacrumTick = {
    updatedState     : SimulacrumState;
    stance           : StrategicStance;
    predictionErrors : [PredictionError];
    dopamineLevel    : Float;
    learningOccurred : Bool;
    modelImproved    : Bool;
  };

  public func heartbeat(
    state         : SimulacrumState,
    realWorldData : WorldState,      // From INFO-INGRESS
    controlSignal : [Float]          // Current control input
  ) : SimulacrumTick {
    
    // ─── PHASE 3: COMPARE ───────────────────────────────────────────────────
    // Check predictions made for this beat against reality
    let errors = Buffer.Buffer<PredictionError>(10);
    var totalRPE = 0.0;
    var errorCount = 0;
    
    // Check short-term predictions
    for (pred in state.shortPredictions.vals()) {
      if (pred.targetBeat == realWorldData.beatNumber) {
        let err = comparePrediction(pred, realWorldData);
        errors.add(err);
        totalRPE += err.dopamineSignal;
        errorCount += 1;
      };
    };
    
    let avgRPE = if (errorCount > 0) totalRPE / Float.fromInt(errorCount) else 0.0;
    
    // ─── PHASE 4: UPDATE ────────────────────────────────────────────────────
    // Learn from prediction errors
    let preState = worldToVector(state.currentWorld);
    let postState = worldToVector(realWorldData);
    
    // Apply all three plasticity rules
    let hebbianWeights = hebbianUpdate(
      state.model.transitionWeights,
      preState,
      postState,
      if (errors.size() > 0) errors.get(0).compositeError else 0.1,
      state.model.learningRate
    );
    
    let (bcmWeights, bcmThresh) = bcmUpdate(
      hebbianWeights,
      state.model.bcmThresholds,
      preState,
      postState
    );
    
    let finalWeights = dopamineModulatedUpdate(
      bcmWeights,
      preState,
      postState,
      avgRPE,
      state.dopamineBaseline
    );
    
    // Update dopamine system
    let newDopamine = clamp(
      state.dopamineBaseline + avgRPE * 0.1,
      0.5,
      2.0
    );
    
    // Update model
    let newModel : TransitionModel = {
      transitionWeights = finalWeights;
      controlWeights = state.model.controlWeights;
      observationWeights = state.model.observationWeights;
      bcmThresholds = bcmThresh;
      totalUpdates = state.model.totalUpdates + 1;
      cumulativeError = state.model.cumulativeError + 
        (if (errors.size() > 0) errors.get(0).compositeError else 0.0);
      learningRate = state.model.learningRate;
    };
    
    // ─── PHASE 1: SIMULATE ──────────────────────────────────────────────────
    // Run forward model to generate new predictions
    let shortPreds = simulateHorizon(realWorldData, controlSignal, newModel, HORIZON_SHORT);
    let mediumPreds = simulateHorizon(realWorldData, controlSignal, newModel, HORIZON_MEDIUM);
    let longPreds = simulateHorizon(realWorldData, controlSignal, newModel, HORIZON_LONG);
    
    // ─── PHASE 2: PREDICT ───────────────────────────────────────────────────
    // Generate strategic stance from predictions
    let allPreds = Array.append(shortPreds, Array.append(mediumPreds, longPreds));
    let stance = generateStance(allPreds, realWorldData);
    
    // Update recent errors history
    let newRecentErrors = if (state.recentErrors.size() >= 100) {
      let shifted = Array.tabulate<PredictionError>(
        state.recentErrors.size() - 1,
        func(i) = state.recentErrors[i + 1]
      );
      Array.append(shifted, Buffer.toArray(errors))
    } else {
      Array.append(state.recentErrors, Buffer.toArray(errors))
    };
    
    // Compute rolling average error
    var sumError = 0.0;
    for (e in newRecentErrors.vals()) {
      sumError += e.compositeError;
    };
    let newAvgError = if (newRecentErrors.size() > 0) 
      sumError / Float.fromInt(newRecentErrors.size())
      else state.avgError;
    
    // Model improved if error decreased
    let modelImproved = newAvgError < state.avgError;
    
    // Update confidence based on error trend
    let newConfidence = clamp(
      state.modelConfidence + (if (modelImproved) 0.01 else -0.005),
      0.1,
      0.99
    );
    
    let newState : SimulacrumState = {
      currentWorld = realWorldData;
      shortPredictions = shortPreds;
      mediumPredictions = mediumPreds;
      longPredictions = longPreds;
      model = newModel;
      recentErrors = newRecentErrors;
      avgError = newAvgError;
      bestPredictionHorizon = state.bestPredictionHorizon;  // Could adapt
      modelConfidence = newConfidence;
      dopamineBaseline = state.dopamineBaseline;
      dopamineCurrent = newDopamine;
      rpeAccumulator = state.rpeAccumulator + avgRPE;
    };
    
    {
      updatedState = newState;
      stance = stance;
      predictionErrors = Buffer.toArray(errors);
      dopamineLevel = newDopamine;
      learningOccurred = errors.size() > 0;
      modelImproved = modelImproved;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY & DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════

  public type SimulacrumSummary = {
    currentBeat        : Nat;
    avgPredictionError : Float;
    modelConfidence    : Float;
    dopamineLevel      : Float;
    shortHorizonAccuracy : Float;
    mediumHorizonAccuracy: Float;
    longHorizonAccuracy  : Float;
    totalLearningUpdates : Nat;
    stanceDescription    : Text;
  };

  public func summarize(state : SimulacrumState) : SimulacrumSummary {
    let stanceDesc = if (state.rpeAccumulator > 0.5) "EXPANSIVE"
                     else if (state.rpeAccumulator < -0.5) "DEFENSIVE"
                     else "BALANCED";
    
    {
      currentBeat = state.currentWorld.beatNumber;
      avgPredictionError = state.avgError;
      modelConfidence = state.modelConfidence;
      dopamineLevel = state.dopamineCurrent;
      shortHorizonAccuracy = 1.0 - state.avgError;
      mediumHorizonAccuracy = 1.0 - state.avgError * 1.5;
      longHorizonAccuracy = 1.0 - state.avgError * 2.0;
      totalLearningUpdates = state.model.totalUpdates;
      stanceDescription = stanceDesc;
    }
  };

}
