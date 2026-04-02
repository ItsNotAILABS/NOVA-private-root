// ═══════════════════════════════════════════════════════════════════════════════
// PREDICTIVE FIELD ENGINE — 60-Step Kalman Prediction + Error Analysis
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// 60-step predictive field using Kalman-like propagation:
// - State transition matrix A built from Hebbian correlations
// - Prediction error feeds CHRONO Fisher information
// - 10 consecutive low-error beats triggers KNT mint
// - Prediction error spikes increment VETUS threat vector 7
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module PredictiveFieldEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI           : Float = 1.6180339887498948482;
  public let PI            : Float = 3.1415926535897932385;
  
  // Prediction dimensions
  public let STATE_DIM     : Nat = 64;       // State vector dimension
  public let PRED_STEPS    : Nat = 60;       // Prediction horizon
  public let FIELD_SIZE    : Nat = 3840;     // 60 × 64
  public let MATRIX_SIZE   : Nat = 4096;     // 64 × 64 transition matrix
  
  // Error thresholds
  public let LOW_ERROR_THRESHOLD : Float = 0.1;
  public let HIGH_ERROR_THRESHOLD : Float = 0.5;
  public let KNT_STREAK_REQUIRED : Nat = 10;
  
  // Kalman parameters
  public let PROCESS_NOISE : Float = 0.01;
  public let MEASUREMENT_NOISE : Float = 0.1;
  public let LEARNING_RATE : Float = 0.001;
  
  // History buffer
  public let HISTORY_SIZE  : Nat = 1000;     // Beats to build correlation
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Single prediction step
  public type PredictionStep = {
    step         : Nat;         // Step number (1-60)
    predicted    : [Float];     // Predicted state (64 values)
    confidence   : Float;       // Confidence in this prediction [0, 1]
    uncertainty  : Float;       // Uncertainty (grows with step)
  };
  
  // Prediction error analysis
  public type ErrorAnalysis = {
    instantError : Float;       // Current beat error
    meanError    : Float;       // Rolling mean error
    errorVariance: Float;       // Variance of errors
    lowErrorStreak : Nat;       // Consecutive low-error beats
    highErrorCount : Nat;       // Recent high-error count
    kntMintReady : Bool;        // Ready to mint KNT
    threatIncrement : Bool;     // Should increment VETUS threat
  };
  
  // Transition matrix state
  public type TransitionMatrix = {
    weights      : [Float];     // 64×64 = 4096 weights
    correlation  : [Float];     // Running correlation accumulator
    updateCount  : Nat;         // Number of updates
    lastUpdate   : Nat;         // Beat of last update
  };
  
  // Kalman filter state
  public type KalmanState = {
    estimate     : [Float];     // Current state estimate
    covariance   : [Float];     // Error covariance (simplified diagonal)
    kalmanGain   : [Float];     // Kalman gain vector
  };
  
  // History buffer for correlation
  public type HistoryBuffer = {
    states       : [[Float]];   // Ring buffer of past states
    head         : Nat;         // Current position
    filled       : Bool;        // Whether buffer is full
  };
  
  // Complete predictive field state
  public type PredictiveFieldState = {
    field        : [Float];     // 60 × 64 = 3840 predicted values
    transitionMatrix : TransitionMatrix;
    kalman       : KalmanState;
    history      : HistoryBuffer;
    errorAnalysis: ErrorAnalysis;
    lastActual   : [Float];     // Last actual state (for comparison)
    beat         : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 10) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };
  
  public func exp(x : Float) : Float {
    let clamped = clamp(x, -20.0, 20.0);
    var sum = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 15) {
      term *= clamped / Float.fromInt(n);
      sum += term;
      n += 1;
    };
    sum
  };
  
  // Vector L2 norm
  public func vectorNorm(v : [Float]) : Float {
    var sumSq : Float = 0.0;
    for (x in v.vals()) { sumSq += x * x };
    sqrt(sumSq)
  };
  
  // Vector dot product
  public func dotProduct(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    let n = if (a.size() < b.size()) a.size() else b.size();
    while (i < n) {
      sum += a[i] * b[i];
      i += 1;
    };
    sum
  };
  
  // Matrix-vector multiply (matrix stored row-major)
  public func matVecMul(matrix : [Float], vec : [Float], dim : Nat) : [Float] {
    Array.tabulate<Float>(dim, func(i : Nat) : Float {
      var sum : Float = 0.0;
      var j = 0;
      while (j < dim) {
        let mIdx = i * dim + j;
        if (mIdx < matrix.size() and j < vec.size()) {
          sum += matrix[mIdx] * vec[j];
        };
        j += 1;
      };
      sum
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize transition matrix (identity + small perturbations)
  public func initTransitionMatrix() : TransitionMatrix {
    let weights = Array.tabulate<Float>(MATRIX_SIZE, func(i : Nat) : Float {
      let row = i / STATE_DIM;
      let col = i % STATE_DIM;
      if (row == col) {
        0.9  // Strong self-connection (persistence)
      } else {
        let dist = abs(Float.fromInt(Int.abs(row - col)));
        0.1 / (1.0 + dist)  // Weak cross-connections, decay with distance
      }
    });
    
    {
      weights = weights;
      correlation = Array.tabulate<Float>(MATRIX_SIZE, func(_ : Nat) : Float { 0.0 });
      updateCount = 0;
      lastUpdate = 0;
    }
  };
  
  // Initialize Kalman state
  public func initKalman() : KalmanState {
    {
      estimate = Array.tabulate<Float>(STATE_DIM, func(_ : Nat) : Float { 1.0 });
      covariance = Array.tabulate<Float>(STATE_DIM, func(_ : Nat) : Float { 1.0 });
      kalmanGain = Array.tabulate<Float>(STATE_DIM, func(_ : Nat) : Float { 0.5 });
    }
  };
  
  // Initialize history buffer
  public func initHistory() : HistoryBuffer {
    {
      states = [];
      head = 0;
      filled = false;
    }
  };
  
  // Initialize error analysis
  public func initErrorAnalysis() : ErrorAnalysis {
    {
      instantError = 0.0;
      meanError = 0.0;
      errorVariance = 0.0;
      lowErrorStreak = 0;
      highErrorCount = 0;
      kntMintReady = false;
      threatIncrement = false;
    }
  };
  
  // Initialize complete state
  public func initPredictiveField() : PredictiveFieldState {
    {
      field = Array.tabulate<Float>(FIELD_SIZE, func(_ : Nat) : Float { 1.0 });
      transitionMatrix = initTransitionMatrix();
      kalman = initKalman();
      history = initHistory();
      errorAnalysis = initErrorAnalysis();
      lastActual = Array.tabulate<Float>(STATE_DIM, func(_ : Nat) : Float { 1.0 });
      beat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // KALMAN FILTER
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Kalman predict step
  public func kalmanPredict(
    kalman : KalmanState,
    transitionMatrix : [Float]
  ) : KalmanState {
    // x̂ₖ|ₖ₋₁ = A × x̂ₖ₋₁|ₖ₋₁
    let predictedEstimate = matVecMul(transitionMatrix, kalman.estimate, STATE_DIM);
    
    // Pₖ|ₖ₋₁ = A × Pₖ₋₁|ₖ₋₁ × Aᵀ + Q (simplified: diagonal)
    let predictedCovariance = Array.tabulate<Float>(STATE_DIM, func(i : Nat) : Float {
      kalman.covariance[i] + PROCESS_NOISE
    });
    
    { kalman with
      estimate = predictedEstimate;
      covariance = predictedCovariance;
    }
  };
  
  // Kalman update step
  public func kalmanUpdate(
    kalman : KalmanState,
    measurement : [Float]
  ) : KalmanState {
    // Innovation: yₖ = zₖ - x̂ₖ|ₖ₋₁
    let innovation = Array.tabulate<Float>(STATE_DIM, func(i : Nat) : Float {
      if (i < measurement.size()) measurement[i] - kalman.estimate[i]
      else 0.0
    });
    
    // Kalman gain: Kₖ = Pₖ|ₖ₋₁ / (Pₖ|ₖ₋₁ + R)
    let gain = Array.tabulate<Float>(STATE_DIM, func(i : Nat) : Float {
      kalman.covariance[i] / (kalman.covariance[i] + MEASUREMENT_NOISE)
    });
    
    // Updated estimate: x̂ₖ|ₖ = x̂ₖ|ₖ₋₁ + Kₖ × yₖ
    let updatedEstimate = Array.tabulate<Float>(STATE_DIM, func(i : Nat) : Float {
      kalman.estimate[i] + gain[i] * innovation[i]
    });
    
    // Updated covariance: Pₖ|ₖ = (I - Kₖ) × Pₖ|ₖ₋₁
    let updatedCovariance = Array.tabulate<Float>(STATE_DIM, func(i : Nat) : Float {
      (1.0 - gain[i]) * kalman.covariance[i]
    });
    
    {
      estimate = updatedEstimate;
      covariance = updatedCovariance;
      kalmanGain = gain;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSITION MATRIX LEARNING
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update history buffer
  public func updateHistory(
    history : HistoryBuffer,
    newState : [Float]
  ) : HistoryBuffer {
    if (history.states.size() < HISTORY_SIZE) {
      // Still filling
      { history with
        states = Array.append(history.states, [newState]);
        head = history.states.size();
        filled = history.states.size() >= HISTORY_SIZE - 1;
      }
    } else {
      // Ring buffer update
      var newStates = Array.thaw<[Float]>(history.states);
      newStates[history.head] := newState;
      let newHead = (history.head + 1) % HISTORY_SIZE;
      { history with
        states = Array.freeze(newStates);
        head = newHead;
        filled = true;
      }
    }
  };
  
  // Learn transition matrix from history (Hebbian-style)
  public func learnTransitionMatrix(
    matrix : TransitionMatrix,
    prevState : [Float],
    currState : [Float],
    currentBeat : Nat
  ) : TransitionMatrix {
    // Outer product: ΔA = η × (current ⊗ prev)
    var newCorr = Array.init<Float>(MATRIX_SIZE, 0.0);
    var i = 0;
    while (i < STATE_DIM) {
      var j = 0;
      while (j < STATE_DIM) {
        let idx = i * STATE_DIM + j;
        let prevVal = if (j < prevState.size()) prevState[j] else 0.0;
        let currVal = if (i < currState.size()) currState[i] else 0.0;
        
        // Running correlation
        if (idx < matrix.correlation.size()) {
          newCorr[idx] := matrix.correlation[idx] * 0.999 + prevVal * currVal * 0.001;
        };
        j += 1;
      };
      i += 1;
    };
    
    // Update weights from correlation
    let newWeights = Array.tabulate<Float>(MATRIX_SIZE, func(k : Nat) : Float {
      let row = k / STATE_DIM;
      let col = k % STATE_DIM;
      
      // Base weight
      let base = if (row == col) 0.8 else 0.0;
      
      // Learned component
      let learned = newCorr[k] * LEARNING_RATE;
      
      clamp(base + learned, 0.0, 1.0)
    });
    
    { matrix with
      weights = newWeights;
      correlation = Array.freeze(newCorr);
      updateCount = matrix.updateCount + 1;
      lastUpdate = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PREDICTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Propagate state forward by 60 steps
  public func propagateField(
    initialState : [Float],
    transitionMatrix : [Float]
  ) : [Float] {
    var field = Array.init<Float>(FIELD_SIZE, 1.0);
    
    // Step 0: initial state
    var i = 0;
    while (i < STATE_DIM) {
      if (i < initialState.size()) {
        field[i] := initialState[i];
      };
      i += 1;
    };
    
    // Steps 1-59: propagate using transition matrix
    var step = 1;
    while (step < PRED_STEPS) {
      // Get previous step's state
      let prevStart = (step - 1) * STATE_DIM;
      let prevState = Array.tabulate<Float>(STATE_DIM, func(j : Nat) : Float {
        field[prevStart + j]
      });
      
      // Propagate
      let nextState = matVecMul(transitionMatrix, prevState, STATE_DIM);
      
      // Store in field with uncertainty growth
      let uncertaintyFactor = 1.0 + Float.fromInt(step) * 0.01;
      i := 0;
      while (i < STATE_DIM) {
        let fieldIdx = step * STATE_DIM + i;
        field[fieldIdx] := clamp(nextState[i] / uncertaintyFactor, 0.5, 2.0);
        i += 1;
      };
      
      step += 1;
    };
    
    Array.freeze(field)
  };
  
  // Get prediction for specific step
  public func getPredictionStep(field : [Float], step : Nat) : PredictionStep {
    let start = step * STATE_DIM;
    let predicted = Array.tabulate<Float>(STATE_DIM, func(i : Nat) : Float {
      if (start + i < field.size()) field[start + i] else 1.0
    });
    
    // Confidence decreases with step
    let confidence = 1.0 / (1.0 + Float.fromInt(step) * 0.05);
    let uncertainty = Float.fromInt(step) * 0.02;
    
    {
      step = step;
      predicted = predicted;
      confidence = confidence;
      uncertainty = uncertainty;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Calculate prediction error
  public func calculateError(predicted : [Float], actual : [Float]) : Float {
    var sumSq : Float = 0.0;
    var i = 0;
    while (i < STATE_DIM and i < predicted.size() and i < actual.size()) {
      let diff = predicted[i] - actual[i];
      sumSq += diff * diff;
      i += 1;
    };
    sqrt(sumSq / Float.fromInt(STATE_DIM))
  };
  
  // Update error analysis
  public func updateErrorAnalysis(
    analysis : ErrorAnalysis,
    predictedStep1 : [Float],
    actual : [Float]
  ) : ErrorAnalysis {
    let instantError = calculateError(predictedStep1, actual);
    
    // Rolling mean (EMA)
    let alpha = 0.05;
    let newMean = analysis.meanError * (1.0 - alpha) + instantError * alpha;
    
    // Variance update
    let diff = instantError - newMean;
    let newVariance = analysis.errorVariance * (1.0 - alpha) + diff * diff * alpha;
    
    // Low error streak
    let (newStreak, kntReady) = if (instantError < LOW_ERROR_THRESHOLD) {
      let streak = analysis.lowErrorStreak + 1;
      (streak, streak >= KNT_STREAK_REQUIRED)
    } else {
      (0, false)
    };
    
    // High error detection (threat increment)
    let (newHighCount, threat) = if (instantError > HIGH_ERROR_THRESHOLD) {
      (analysis.highErrorCount + 1, analysis.highErrorCount >= 3)
    } else {
      (0, false)
    };
    
    {
      instantError = instantError;
      meanError = newMean;
      errorVariance = newVariance;
      lowErrorStreak = newStreak;
      highErrorCount = newHighCount;
      kntMintReady = kntReady;
      threatIncrement = threat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FULL UPDATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Complete predictive field update
  public func updatePredictiveField(
    state : PredictiveFieldState,
    actualState : [Float],
    currentBeat : Nat
  ) : PredictiveFieldState {
    // Get step-1 prediction from previous field for error calculation
    let step1 = getPredictionStep(state.field, 1);
    
    // Update error analysis
    let newErrorAnalysis = updateErrorAnalysis(
      state.errorAnalysis,
      step1.predicted,
      actualState
    );
    
    // Kalman update with actual measurement
    var kalman = kalmanPredict(state.kalman, state.transitionMatrix.weights);
    kalman := kalmanUpdate(kalman, actualState);
    
    // Update history
    let newHistory = updateHistory(state.history, actualState);
    
    // Learn transition matrix
    let newMatrix = learnTransitionMatrix(
      state.transitionMatrix,
      state.lastActual,
      actualState,
      currentBeat
    );
    
    // Propagate new field from Kalman estimate
    let newField = propagateField(kalman.estimate, newMatrix.weights);
    
    {
      field = newField;
      transitionMatrix = newMatrix;
      kalman = kalman;
      history = newHistory;
      errorAnalysis = newErrorAnalysis;
      lastActual = actualState;
      beat = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Get prediction confidence at step
  public func getConfidence(step : Nat) : Float {
    1.0 / (1.0 + Float.fromInt(step) * 0.05)
  };
  
  // Get Fisher information contribution
  public func getFisherContribution(analysis : ErrorAnalysis) : Float {
    // Fisher info ∝ 1/variance of prediction error
    if (analysis.errorVariance > 0.001) {
      1.0 / analysis.errorVariance
    } else {
      1000.0  // High Fisher info when variance is low
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getDiagnostics(state : PredictiveFieldState) : {
    stateDim       : Nat;
    predSteps      : Nat;
    instantError   : Float;
    meanError      : Float;
    lowErrorStreak : Nat;
    kntMintReady   : Bool;
    threatIncrement: Bool;
    matrixUpdates  : Nat;
    historyFilled  : Bool;
    fisherContrib  : Float;
  } {
    {
      stateDim = STATE_DIM;
      predSteps = PRED_STEPS;
      instantError = state.errorAnalysis.instantError;
      meanError = state.errorAnalysis.meanError;
      lowErrorStreak = state.errorAnalysis.lowErrorStreak;
      kntMintReady = state.errorAnalysis.kntMintReady;
      threatIncrement = state.errorAnalysis.threatIncrement;
      matrixUpdates = state.transitionMatrix.updateCount;
      historyFilled = state.history.filled;
      fisherContrib = getFisherContribution(state.errorAnalysis);
    }
  };
};
