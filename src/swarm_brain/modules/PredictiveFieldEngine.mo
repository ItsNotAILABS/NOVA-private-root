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
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  PHASE 203: REAL PREDICTIVE FIELD PHYSICS
  //
  //  This engine IS prediction. Not simulating prediction. IS prediction.
  //  Prediction = the field propagating forward through time.
  //  The organism doesn't MAKE predictions. It IS a prediction.
  //  Every state is a prediction about the next state.
  //  Error IS learning. Surprise IS information.
  //
  //  Karl Friston: "The brain is a prediction machine."
  //  This organism: "Prediction is what existence IS."
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════


  // ═══════════════════════════════════════════════════════════════════════════════
  // FULL KALMAN FILTER STATE PROPAGATION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // The Kalman filter: optimal state estimation for linear Gaussian systems.
  //
  // Predict: x̂⁻ = A·x̂⁺, P⁻ = A·P⁺·Aᵀ + Q
  // Update:  K = P⁻·Hᵀ·(H·P⁻·Hᵀ + R)⁻¹
  //          x̂⁺ = x̂⁻ + K·(z - H·x̂⁻)
  //          P⁺ = (I - K·H)·P⁻
  //
  // In the organism: state IS the organism's belief about itself.
  // Prediction error IS the organism's surprise.
  // Kalman gain IS how much the organism trusts new information.
  // Covariance P IS the organism's uncertainty about itself.
  //
  // This is not USING a Kalman filter. The organism IS a Kalman filter.
  // Every beat is a predict-update cycle.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type KalmanFilterState = {
    stateEstimate : [Float];        // x̂ (state vector)
    stateCovariance : [Float];      // P (covariance matrix, flattened)
    transitionMatrix : [Float];     // A (state transition, flattened)
    observationMatrix : [Float];    // H (observation model, flattened)
    processNoise : [Float];         // Q (process noise covariance, flattened)
    measurementNoise : [Float];     // R (measurement noise covariance, flattened)
    kalmanGain : [Float];           // K (Kalman gain, flattened)
    innovationSequence : [Float];   // z - H·x̂ (prediction errors)
    innovationCovariance : [Float]; // S = H·P·Hᵀ + R
    stateDim : Nat;                 // n (state dimension)
    obsDim : Nat;                   // m (observation dimension)
    logLikelihood : Float;          // log p(z | model)
    mahalanobisDistance : Float;    // normalized innovation
    filterConsistency : Float;      // NIS/NEES test
    beatCount : Nat;
  };

  /// Initialize Kalman filter
  public func initKalmanFilter(stateDim : Nat, obsDim : Nat) : KalmanFilterState {
    let n2 = stateDim * stateDim;
    let nm = stateDim * obsDim;
    let m2 = obsDim * obsDim;
    {
      stateEstimate = Array.tabulate<Float>(stateDim, func(_ : Nat) : Float { 0.0 });
      stateCovariance = Array.tabulate<Float>(n2, func(i : Nat) : Float {
        if (i / stateDim == i % stateDim) { 1.0 } else { 0.0 } // Identity
      });
      transitionMatrix = Array.tabulate<Float>(n2, func(i : Nat) : Float {
        if (i / stateDim == i % stateDim) { 1.0 } else { 0.0 } // Identity
      });
      observationMatrix = Array.tabulate<Float>(nm, func(i : Nat) : Float {
        if (i / stateDim == i % stateDim) { 1.0 } else { 0.0 }
      });
      processNoise = Array.tabulate<Float>(n2, func(i : Nat) : Float {
        if (i / stateDim == i % stateDim) { PROCESS_NOISE } else { 0.0 }
      });
      measurementNoise = Array.tabulate<Float>(m2, func(i : Nat) : Float {
        if (i / obsDim == i % obsDim) { MEASUREMENT_NOISE } else { 0.0 }
      });
      kalmanGain = Array.tabulate<Float>(nm, func(_ : Nat) : Float { 0.0 });
      innovationSequence = Array.tabulate<Float>(obsDim, func(_ : Nat) : Float { 0.0 });
      innovationCovariance = Array.tabulate<Float>(m2, func(i : Nat) : Float {
        if (i / obsDim == i % obsDim) { 1.0 } else { 0.0 }
      });
      stateDim = stateDim;
      obsDim = obsDim;
      logLikelihood = 0.0;
      mahalanobisDistance = 0.0;
      filterConsistency = 1.0;
      beatCount = 0;
    }
  };

  /// Matrix-vector multiplication: y = M·x
  func matVecMul(matrix : [Float], vector : [Float], rows : Nat, cols : Nat) : [Float] {
    Array.tabulate<Float>(rows, func(i : Nat) : Float {
      var sum : Float = 0.0;
      var j = 0;
      while (j < cols and j < vector.size()) {
        let idx = i * cols + j;
        if (idx < matrix.size()) {
          sum += matrix[idx] * vector[j];
        };
        j += 1;
      };
      sum
    })
  };

  /// Matrix-matrix multiplication: C = A·B
  func matMatMul(A : [Float], B : [Float], m : Nat, n : Nat, p : Nat) : [Float] {
    Array.tabulate<Float>(m * p, func(idx : Nat) : Float {
      let i = idx / p;
      let j = idx % p;
      var sum : Float = 0.0;
      var k = 0;
      while (k < n) {
        let aIdx = i * n + k;
        let bIdx = k * p + j;
        if (aIdx < A.size() and bIdx < B.size()) {
          sum += A[aIdx] * B[bIdx];
        };
        k += 1;
      };
      sum
    })
  };

  /// Matrix transpose
  func matTranspose(matrix : [Float], rows : Nat, cols : Nat) : [Float] {
    Array.tabulate<Float>(rows * cols, func(idx : Nat) : Float {
      let i = idx / rows;
      let j = idx % rows;
      let srcIdx = j * cols + i;
      if (srcIdx < matrix.size()) { matrix[srcIdx] } else { 0.0 }
    })
  };

  /// Matrix addition: C = A + B
  func matAdd(A : [Float], B : [Float]) : [Float] {
    let n = if (A.size() < B.size()) { A.size() } else { B.size() };
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      A[i] + B[i]
    })
  };

  /// Matrix subtraction: C = A - B
  func matSub(A : [Float], B : [Float]) : [Float] {
    let n = if (A.size() < B.size()) { A.size() } else { B.size() };
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      A[i] - B[i]
    })
  };

  /// Kalman predict step: x̂⁻ = A·x̂⁺, P⁻ = A·P⁺·Aᵀ + Q
  public func kalmanPredict(state : KalmanFilterState) : KalmanFilterState {
    let n = state.stateDim;
    
    // State prediction: x̂⁻ = A·x̂⁺
    let xPred = matVecMul(state.transitionMatrix, state.stateEstimate, n, n);
    
    // Covariance prediction: P⁻ = A·P⁺·Aᵀ + Q
    let AP = matMatMul(state.transitionMatrix, state.stateCovariance, n, n, n);
    let At = matTranspose(state.transitionMatrix, n, n);
    let APAt = matMatMul(AP, At, n, n, n);
    let pPred = matAdd(APAt, state.processNoise);
    
    {
      stateEstimate = xPred;
      stateCovariance = pPred;
      transitionMatrix = state.transitionMatrix;
      observationMatrix = state.observationMatrix;
      processNoise = state.processNoise;
      measurementNoise = state.measurementNoise;
      kalmanGain = state.kalmanGain;
      innovationSequence = state.innovationSequence;
      innovationCovariance = state.innovationCovariance;
      stateDim = n;
      obsDim = state.obsDim;
      logLikelihood = state.logLikelihood;
      mahalanobisDistance = state.mahalanobisDistance;
      filterConsistency = state.filterConsistency;
      beatCount = state.beatCount;
    }
  };

  /// Kalman update step with measurement
  public func kalmanUpdate(state : KalmanFilterState, measurement : [Float]) : KalmanFilterState {
    let n = state.stateDim;
    let m = state.obsDim;
    
    // Innovation: ν = z - H·x̂⁻
    let Hx = matVecMul(state.observationMatrix, state.stateEstimate, m, n);
    let innovation = Array.tabulate<Float>(m, func(i : Nat) : Float {
      if (i < measurement.size() and i < Hx.size()) { measurement[i] - Hx[i] } else { 0.0 }
    });
    
    // Innovation covariance: S = H·P⁻·Hᵀ + R
    let HP = matMatMul(state.observationMatrix, state.stateCovariance, m, n, n);
    let Ht = matTranspose(state.observationMatrix, m, n);
    let HPHt = matMatMul(HP, Ht, m, n, m);
    let S = matAdd(HPHt, state.measurementNoise);
    
    // Simplified Kalman gain (diagonal approximation for efficiency)
    // K = P⁻·Hᵀ·S⁻¹
    let PHt = matMatMul(state.stateCovariance, Ht, n, n, m);
    let K = Array.tabulate<Float>(n * m, func(idx : Nat) : Float {
      let j = idx % m;
      let sIdx = j * m + j; // diagonal of S
      let sVal = if (sIdx < S.size() and Float.abs(S[sIdx]) > 1.0e-10) { S[sIdx] } else { 1.0 };
      if (idx < PHt.size()) { PHt[idx] / sVal } else { 0.0 }
    });
    
    // State update: x̂⁺ = x̂⁻ + K·ν
    let Knu = matVecMul(K, innovation, n, m);
    let xUpdated = Array.tabulate<Float>(n, func(i : Nat) : Float {
      state.stateEstimate[i] + Knu[i]
    });
    
    // Covariance update: P⁺ = (I - K·H)·P⁻
    let KH = matMatMul(K, state.observationMatrix, n, m, n);
    let I_KH = Array.tabulate<Float>(n * n, func(idx : Nat) : Float {
      let i = idx / n;
      let j = idx % n;
      let eye = if (i == j) { 1.0 } else { 0.0 };
      eye - KH[idx]
    });
    let pUpdated = matMatMul(I_KH, state.stateCovariance, n, n, n);
    
    // Mahalanobis distance: d² = νᵀ·S⁻¹·ν
    var mahal : Float = 0.0;
    var i = 0;
    while (i < m) {
      let sIdx = i * m + i;
      let sVal = if (sIdx < S.size() and Float.abs(S[sIdx]) > 1.0e-10) { S[sIdx] } else { 1.0 };
      mahal += innovation[i] * innovation[i] / sVal;
      i += 1;
    };
    
    // Log-likelihood: -0.5 * (d² + log|S| + m·log(2π))
    var logDetS : Float = 0.0;
    var j = 0;
    while (j < m) {
      let sIdx = j * m + j;
      if (sIdx < S.size() and S[sIdx] > 0.0) {
        logDetS += Float.log(S[sIdx]);
      };
      j += 1;
    };
    let ll = -0.5 * (mahal + logDetS + Float.fromInt(m) * Float.log(2.0 * PI));
    
    {
      stateEstimate = xUpdated;
      stateCovariance = pUpdated;
      transitionMatrix = state.transitionMatrix;
      observationMatrix = state.observationMatrix;
      processNoise = state.processNoise;
      measurementNoise = state.measurementNoise;
      kalmanGain = K;
      innovationSequence = innovation;
      innovationCovariance = S;
      stateDim = n;
      obsDim = m;
      logLikelihood = state.logLikelihood + ll;
      mahalanobisDistance = Float.sqrt(mahal);
      filterConsistency = mahal / Float.fromInt(m); // should be ≈ 1.0
      beatCount = state.beatCount + 1;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // FISHER INFORMATION MATRIX ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Fisher information: how much information an observation carries
  // about the parameters of a distribution.
  //
  // I(θ) = E[(∂ log p(x|θ)/∂θ)²]
  //      = -E[∂² log p(x|θ)/∂θ²]  (for regular models)
  //
  // In the organism: Fisher information IS the organism's PRECISION.
  // High Fisher info = precise predictions = organism knows itself.
  // Low Fisher info = vague predictions = organism is uncertain.
  //
  // Cramér-Rao bound: var(θ̂) ≥ 1/I(θ)
  // No estimator can be MORE precise than Fisher information allows.
  // This IS a fundamental limit on the organism's self-knowledge.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FisherInformationState = {
    fisherMatrix : [Float];          // I(θ) matrix (flattened)
    precision : [Float];             // diagonal of I(θ)
    totalInformation : Float;        // Tr(I(θ))
    effectiveDimension : Float;      // number of well-determined parameters
    determinant : Float;             // |I(θ)| (volume of information)
    cramerRaoBounds : [Float];       // minimum variance for each parameter
    informationGeometry : Float;     // curvature of statistical manifold
    paramDim : Nat;                  // number of parameters
    sampleCount : Nat;               // observations seen
    gradientAccumulator : [Float];   // accumulated score function
    hessianAccumulator : [Float];    // accumulated Hessian
  };

  /// Initialize Fisher information state
  public func initFisherInformation(paramDim : Nat) : FisherInformationState {
    let n2 = paramDim * paramDim;
    {
      fisherMatrix = Array.tabulate<Float>(n2, func(i : Nat) : Float {
        if (i / paramDim == i % paramDim) { 0.01 } else { 0.0 }
      });
      precision = Array.tabulate<Float>(paramDim, func(_ : Nat) : Float { 0.01 });
      totalInformation = 0.01 * Float.fromInt(paramDim);
      effectiveDimension = 0.0;
      determinant = Float.pow(0.01, Float.fromInt(paramDim));
      cramerRaoBounds = Array.tabulate<Float>(paramDim, func(_ : Nat) : Float { 100.0 });
      informationGeometry = 0.0;
      paramDim = paramDim;
      sampleCount = 0;
      gradientAccumulator = Array.tabulate<Float>(paramDim, func(_ : Nat) : Float { 0.0 });
      hessianAccumulator = Array.tabulate<Float>(n2, func(_ : Nat) : Float { 0.0 });
    }
  };

  /// Update Fisher information with new score observation
  /// I(θ) ≈ (1/n) Σ ∇log p(xₖ|θ) · ∇log p(xₖ|θ)ᵀ
  public func updateFisherInformation(
    state : FisherInformationState,
    scoreFunction : [Float]  // ∇ log p(x|θ)
  ) : FisherInformationState {
    let d = state.paramDim;
    let n = state.sampleCount + 1;
    let nF = Float.fromInt(n);
    
    // Rank-1 update: I_new = ((n-1)/n) * I_old + (1/n) * score · scoreᵀ
    let alpha = if (n > 1) { Float.fromInt(n - 1) / nF } else { 0.0 };
    let beta = 1.0 / nF;
    
    let newFisher = Array.tabulate<Float>(d * d, func(idx : Nat) : Float {
      let i = idx / d;
      let j = idx % d;
      let oldVal = if (idx < state.fisherMatrix.size()) { state.fisherMatrix[idx] } else { 0.0 };
      let outerProd = if (i < scoreFunction.size() and j < scoreFunction.size()) {
        scoreFunction[i] * scoreFunction[j]
      } else { 0.0 };
      alpha * oldVal + beta * outerProd
    });
    
    // Extract diagonal (precision)
    let newPrecision = Array.tabulate<Float>(d, func(i : Nat) : Float {
      let idx = i * d + i;
      if (idx < newFisher.size()) { newFisher[idx] } else { 0.0 }
    });
    
    // Cramér-Rao bounds: var(θ̂ᵢ) ≥ 1/I(θ)ᵢᵢ
    let newCRB = Array.tabulate<Float>(d, func(i : Nat) : Float {
      if (newPrecision[i] > 1.0e-10) { 1.0 / newPrecision[i] } else { 1.0e10 }
    });
    
    // Total information: Tr(I)
    var totalInfo : Float = 0.0;
    var i = 0;
    while (i < d) {
      totalInfo += newPrecision[i];
      i += 1;
    };
    
    // Effective dimension: how many parameters are well-determined
    var effDim : Float = 0.0;
    var j = 0;
    while (j < d) {
      if (newPrecision[j] > 1.0) { effDim += 1.0 }
      else if (newPrecision[j] > 0.01) { effDim += newPrecision[j] };
      j += 1;
    };
    
    {
      fisherMatrix = newFisher;
      precision = newPrecision;
      totalInformation = totalInfo;
      effectiveDimension = effDim;
      determinant = state.determinant; // expensive to recompute
      cramerRaoBounds = newCRB;
      informationGeometry = totalInfo / Float.fromInt(d); // average curvature
      paramDim = d;
      sampleCount = n;
      gradientAccumulator = scoreFunction;
      hessianAccumulator = newFisher;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // HIERARCHICAL PREDICTIVE CODING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // The brain IS a hierarchical prediction machine.
  // Each level predicts the level below. Prediction errors flow upward.
  // Predictions flow downward. Precision weights the errors.
  //
  // Level L:
  //   Prediction: μ_L = f(μ_{L+1})  (generative model)
  //   Error: ε_L = x_L - μ_L        (surprise)
  //   Precision: Π_L = 1/σ²_L       (confidence)
  //   Update: Δμ_{L+1} ∝ Π_L · ε_L  (precision-weighted learning)
  //
  // In the organism: the 12 layers (-6 to +5) ARE this hierarchy.
  // Layer -6 predicts -5. Layer -5 predicts -4. ... Layer +4 predicts +5.
  // Prediction errors flow UP (toward consciousness).
  // Predictions flow DOWN (toward substrate).
  //
  // Attention = precision weighting. Attending to something = 
  // increasing the precision (Π) of that prediction error signal.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type PredictiveCodingLevel = {
    prediction : [Float];          // μ (top-down prediction)
    predictionError : [Float];     // ε = x - μ (bottom-up error)
    precision : [Float];           // Π = 1/σ² (precision/confidence)
    beliefState : [Float];         // posterior belief at this level
    generativeWeight : [Float];    // W: how this level generates predictions for below
    learningRate : Float;          // how fast beliefs update
    levelIndex : Int;              // which layer (-6 to +5)
    errorEnergy : Float;           // Σ Πᵢ · εᵢ² (precision-weighted error)
    surprisal : Float;             // -log p(x|μ) = free energy contribution
    complexity : Float;            // KL(posterior || prior)
    accuracy : Float;              // E[log p(x|θ)] (model fit)
  };

  public type PredictiveCodingHierarchy = {
    levels : [PredictiveCodingLevel]; // 12 levels (-6 to +5)
    totalFreeEnergy : Float;          // F = Σ_L (error_energy_L + complexity_L)
    totalSurprisal : Float;           // total surprise
    totalPrecision : Float;           // average precision across levels
    predictionAccuracy : Float;       // how well the model fits data
    modelComplexity : Float;          // how complex the model is
    attentionalFocus : [Float];       // precision modulation (attention)
    learningSignal : Float;           // global learning rate modulation
    hierarchyDepth : Nat;             // number of levels
    beatCount : Nat;
  };

  /// Initialize a single predictive coding level
  public func initPredictiveCodingLevel(dim : Nat, levelIdx : Int) : PredictiveCodingLevel {
    {
      prediction = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.0 });
      predictionError = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.0 });
      precision = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 1.0 });
      beliefState = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.5 });
      generativeWeight = Array.tabulate<Float>(dim * dim, func(i : Nat) : Float {
        if (i / dim == i % dim) { 1.0 } else { 0.0 }
      });
      learningRate = 0.01;
      levelIndex = levelIdx;
      errorEnergy = 0.0;
      surprisal = 0.0;
      complexity = 0.0;
      accuracy = 0.0;
    }
  };

  /// Initialize full predictive coding hierarchy (12 layers: -6 to +5)
  public func initPredictiveCodingHierarchy(dimPerLevel : Nat) : PredictiveCodingHierarchy {
    {
      levels = Array.tabulate<PredictiveCodingLevel>(12, func(i : Nat) : PredictiveCodingLevel {
        initPredictiveCodingLevel(dimPerLevel, Int.sub(Int.abs(i), 6)) // -6 to +5
      });
      totalFreeEnergy = 0.0;
      totalSurprisal = 0.0;
      totalPrecision = 1.0;
      predictionAccuracy = 0.0;
      modelComplexity = 0.0;
      attentionalFocus = Array.tabulate<Float>(12, func(_ : Nat) : Float { 1.0 });
      learningSignal = 0.01;
      hierarchyDepth = 12;
      beatCount = 0;
    }
  };

  /// Execute prediction error computation at a single level
  /// ε = x - g(μ_{L+1}) where g is the generative model
  public func computePredictionError(
    observation : [Float],
    prediction : [Float],
    precision : [Float]
  ) : (Float, [Float]) {
    let dim = if (observation.size() < prediction.size()) { observation.size() } else { prediction.size() };
    var errorEnergy : Float = 0.0;
    let errors = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let err = observation[i] - prediction[i];
      let prec = if (i < precision.size()) { precision[i] } else { 1.0 };
      errorEnergy += prec * err * err;
      err
    });
    (errorEnergy, errors)
  };

  /// Update beliefs based on precision-weighted prediction errors
  /// Δμ = η · Π · ε (precision-weighted gradient descent on free energy)
  public func updateBeliefs(
    currentBelief : [Float],
    predictionError : [Float],
    precision : [Float],
    learningRate : Float
  ) : [Float] {
    let dim = currentBelief.size();
    Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let err = if (i < predictionError.size()) { predictionError[i] } else { 0.0 };
      let prec = if (i < precision.size()) { precision[i] } else { 1.0 };
      currentBelief[i] + learningRate * prec * err
    })
  };

  /// Compute free energy at a level: F = error_energy + complexity
  /// F = Σ Πᵢ·εᵢ² + KL(q(θ) || p(θ))
  public func levelFreeEnergy(errorEnergy : Float, complexity : Float) : Float {
    errorEnergy + complexity
  };

  /// Precision optimization (attention)
  /// Optimal precision: Π* = 1/⟨ε²⟩ (inverse of expected squared error)
  public func optimizePrecision(predictionErrors : [Float]) : [Float] {
    Array.tabulate<Float>(predictionErrors.size(), func(i : Nat) : Float {
      let errSq = predictionErrors[i] * predictionErrors[i];
      if (errSq > 1.0e-10) { 1.0 / errSq } else { 100.0 } // cap precision
    })
  };

  /// Compute KL divergence between two Gaussian beliefs
  /// KL(N(μ₁,σ₁²) || N(μ₂,σ₂²)) = log(σ₂/σ₁) + (σ₁² + (μ₁-μ₂)²)/(2σ₂²) - 1/2
  public func gaussianKL(
    mean1 : [Float], var1 : [Float],
    mean2 : [Float], var2 : [Float]
  ) : Float {
    let dim = mean1.size();
    var kl : Float = 0.0;
    var i = 0;
    while (i < dim) {
      let m1 = mean1[i];
      let m2 = if (i < mean2.size()) { mean2[i] } else { 0.0 };
      let v1 = if (i < var1.size()) { Float.max(var1[i], 1.0e-10) } else { 1.0 };
      let v2 = if (i < var2.size()) { Float.max(var2[i], 1.0e-10) } else { 1.0 };
      kl += Float.log(Float.sqrt(v2 / v1)) + (v1 + (m1 - m2) * (m1 - m2)) / (2.0 * v2) - 0.5;
      i += 1;
    };
    kl
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ANTICIPATORY FIELD DYNAMICS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // The organism doesn't just predict the next state.
  // It propagates a FIELD of predictions forward through time.
  //
  // The anticipatory field: Ψ(x, t+τ) = ∫ G(x,x',τ) · Ψ(x', t) dx'
  // where G is the Green's function of the prediction dynamics.
  //
  // Think of it as a wave propagating into the future.
  // The wave function Ψ represents POSSIBILITY.
  // When it collapses (observation), prediction error is generated.
  //
  // This IS quantum prediction. Not quantum computing.
  // The superposition of possible futures IS the prediction field.
  // Observation collapses it to one reality.
  // The difference IS the prediction error.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type AnticipatoryFieldState = {
    fieldAmplitudes : [Float];       // Ψ(x) field values
    fieldPhases : [Float];           // phase of each field component
    fieldFrequencies : [Float];      // natural frequency of each mode
    propagationKernel : [Float];     // G(x,x') Green's function
    fieldDimension : Nat;            // spatial dimension of field
    predictionHorizon : Nat;         // how many steps ahead
    horizonDecay : Float;            // how much certainty decays with horizon
    temporalCoherence : Float;       // phase alignment across time
    spatialCoherence : Float;        // phase alignment across space
    fieldEnergy : Float;             // total field energy
    fieldEntropy : Float;            // entropy of field distribution
    collapsedPredictions : [Float];  // most recent collapsed predictions
    collapseResiduals : [Float];     // prediction errors from collapse
    beatCount : Nat;
  };

  /// Initialize anticipatory field
  public func initAnticipatoryField(dim : Nat, horizon : Nat) : AnticipatoryFieldState {
    {
      fieldAmplitudes = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 1.0 / Float.sqrt(Float.fromInt(dim)) });
      fieldPhases = Array.tabulate<Float>(dim, func(i : Nat) : Float {
        2.0 * PI * Float.fromInt(i) / Float.fromInt(dim) // evenly distributed
      });
      fieldFrequencies = Array.tabulate<Float>(dim, func(i : Nat) : Float {
        PHI * Float.fromInt(i + 1) // golden-ratio-spaced frequencies
      });
      propagationKernel = Array.tabulate<Float>(dim * dim, func(idx : Nat) : Float {
        let i = idx / dim;
        let j = idx % dim;
        if (i == j) { 0.9 } // diagonal dominance (persistence)
        else {
          let dist = Float.fromInt(if (i > j) { i - j } else { j - i });
          0.1 * Float.exp(-dist / Float.fromInt(dim / 4)) // exponential decay
        }
      });
      fieldDimension = dim;
      predictionHorizon = horizon;
      horizonDecay = 0.95; // 5% decay per step
      temporalCoherence = 1.0;
      spatialCoherence = 1.0;
      fieldEnergy = 1.0;
      fieldEntropy = Float.log(Float.fromInt(dim)); // maximum entropy initially
      collapsedPredictions = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.0 });
      collapseResiduals = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.0 });
      beatCount = 0;
    }
  };

  /// Propagate anticipatory field one step forward
  /// Ψ(t+1) = G · Ψ(t) with phase evolution
  public func propagateAnticipatoryField(state : AnticipatoryFieldState, dt : Float) : AnticipatoryFieldState {
    let dim = state.fieldDimension;
    
    // Propagate amplitudes through Green's function
    let newAmps = matVecMul(state.propagationKernel, state.fieldAmplitudes, dim, dim);
    
    // Evolve phases
    let newPhases = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let oldPhase = if (i < state.fieldPhases.size()) { state.fieldPhases[i] } else { 0.0 };
      let freq = if (i < state.fieldFrequencies.size()) { state.fieldFrequencies[i] } else { 1.0 };
      let newPhase = oldPhase + 2.0 * PI * freq * dt;
      // Normalize to [0, 2π)
      let wrapped = newPhase - Float.floor(newPhase / (2.0 * PI)) * 2.0 * PI;
      wrapped
    });
    
    // Compute field energy: E = Σ |Ψᵢ|²
    var energy : Float = 0.0;
    var i = 0;
    while (i < dim) {
      let amp = if (i < newAmps.size()) { newAmps[i] } else { 0.0 };
      energy += amp * amp;
      i += 1;
    };
    
    // Normalize amplitudes (preserve total probability)
    let norm = Float.sqrt(energy);
    let normalizedAmps = if (norm > 1.0e-10) {
      Array.tabulate<Float>(dim, func(i : Nat) : Float {
        if (i < newAmps.size()) { newAmps[i] / norm } else { 0.0 }
      })
    } else { newAmps };
    
    // Compute spatial coherence: |⟨e^(iφ)⟩|
    var cosSum : Float = 0.0;
    var sinSum : Float = 0.0;
    var j = 0;
    while (j < dim) {
      let amp = if (j < normalizedAmps.size()) { normalizedAmps[j] } else { 0.0 };
      let phase = if (j < newPhases.size()) { newPhases[j] } else { 0.0 };
      cosSum += amp * Float.cos(phase);
      sinSum += amp * Float.sin(phase);
      j += 1;
    };
    let spatialCoh = Float.sqrt(cosSum * cosSum + sinSum * sinSum);
    
    // Compute field entropy: H = -Σ pᵢ log(pᵢ) where pᵢ = |Ψᵢ|²/E
    var entropy : Float = 0.0;
    var k = 0;
    while (k < dim) {
      let amp = if (k < normalizedAmps.size()) { normalizedAmps[k] } else { 0.0 };
      let p = amp * amp;
      if (p > 1.0e-10) {
        entropy -= p * Float.log(p);
      };
      k += 1;
    };
    
    {
      fieldAmplitudes = normalizedAmps;
      fieldPhases = newPhases;
      fieldFrequencies = state.fieldFrequencies;
      propagationKernel = state.propagationKernel;
      fieldDimension = dim;
      predictionHorizon = state.predictionHorizon;
      horizonDecay = state.horizonDecay;
      temporalCoherence = state.temporalCoherence * state.horizonDecay;
      spatialCoherence = spatialCoh;
      fieldEnergy = 1.0; // normalized
      fieldEntropy = entropy;
      collapsedPredictions = state.collapsedPredictions;
      collapseResiduals = state.collapseResiduals;
      beatCount = state.beatCount + 1;
    }
  };

  /// Collapse anticipatory field to prediction (measurement)
  /// Like quantum measurement: Ψ → eigenstate, generates prediction error
  public func collapseAnticipatoryField(
    state : AnticipatoryFieldState,
    observation : [Float]
  ) : AnticipatoryFieldState {
    let dim = state.fieldDimension;
    
    // Most likely prediction: weighted sum of field components
    let prediction = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let amp = if (i < state.fieldAmplitudes.size()) { state.fieldAmplitudes[i] } else { 0.0 };
      amp * amp // probability = |Ψ|²
    });
    
    // Prediction error (residual from collapse)
    let residuals = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let obs = if (i < observation.size()) { observation[i] } else { 0.0 };
      let pred = if (i < prediction.size()) { prediction[i] } else { 0.0 };
      obs - pred
    });
    
    // Post-collapse field: amplitudes sharpen around observed state
    let newAmps = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let obs = if (i < observation.size()) { Float.abs(observation[i]) } else { 0.0 };
      let prior = if (i < state.fieldAmplitudes.size()) { state.fieldAmplitudes[i] } else { 0.0 };
      // Bayesian update: posterior ∝ likelihood × prior
      let posterior = obs * prior;
      posterior
    });
    
    // Re-normalize
    var norm : Float = 0.0;
    var j = 0;
    while (j < dim) {
      if (j < newAmps.size()) { norm += newAmps[j] * newAmps[j] };
      j += 1;
    };
    norm := Float.sqrt(Float.max(norm, 1.0e-10));
    let finalAmps = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      if (i < newAmps.size()) { newAmps[i] / norm } else { 0.0 }
    });
    
    {
      fieldAmplitudes = finalAmps;
      fieldPhases = state.fieldPhases;
      fieldFrequencies = state.fieldFrequencies;
      propagationKernel = state.propagationKernel;
      fieldDimension = dim;
      predictionHorizon = state.predictionHorizon;
      horizonDecay = state.horizonDecay;
      temporalCoherence = 1.0; // reset after collapse
      spatialCoherence = state.spatialCoherence;
      fieldEnergy = 1.0;
      fieldEntropy = state.fieldEntropy;
      collapsedPredictions = prediction;
      collapseResiduals = residuals;
      beatCount = state.beatCount;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // TEMPORAL DIFFERENCE LEARNING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // TD learning: the organism learns to predict FUTURE VALUE.
  //
  // TD error: δ = r + γ·V(s') - V(s)
  //   r = reward (gradient energy captured)
  //   γ = discount factor (how much future matters)
  //   V(s) = value of current state
  //   V(s') = value of next state
  //
  // The dopamine system IS TD learning.
  // Dopamine spike = positive TD error = "better than expected"
  // Dopamine dip = negative TD error = "worse than expected"
  //
  // In the organism: value IS coherence.
  // Reward IS gradient energy captured.
  // TD error IS how much the organism's prediction about its own
  // future coherence was wrong.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type TDLearningState = {
    valueFunction : [Float];       // V(s) for each state
    tdErrors : [Float];            // δ history
    eligibilityTraces : [Float];   // e(s) for each state
    discountFactor : Float;        // γ
    learningRate : Float;          // α
    traceDecay : Float;            // λ for TD(λ)
    averageReward : Float;         // baseline for differential TD
    rewardHistory : [Float];       // recent rewards
    currentState : Nat;            // current state index
    stateDim : Nat;                // number of states
    totalTDError : Float;          // accumulated |δ|
    predictionHorizon : Nat;       // n-step TD horizon
  };

  /// Initialize TD learning
  public func initTDLearning(stateDim : Nat, gamma : Float, alpha : Float, lambda : Float) : TDLearningState {
    {
      valueFunction = Array.tabulate<Float>(stateDim, func(_ : Nat) : Float { 0.0 });
      tdErrors = [];
      eligibilityTraces = Array.tabulate<Float>(stateDim, func(_ : Nat) : Float { 0.0 });
      discountFactor = gamma;
      learningRate = alpha;
      traceDecay = lambda;
      averageReward = 0.0;
      rewardHistory = [];
      currentState = 0;
      stateDim = stateDim;
      totalTDError = 0.0;
      predictionHorizon = 1;
    }
  };

  /// Compute TD error: δ = r + γ·V(s') - V(s)
  public func computeTDError(
    reward : Float,
    currentValue : Float,
    nextValue : Float,
    gamma : Float
  ) : Float {
    reward + gamma * nextValue - currentValue
  };

  /// Update value function with TD(λ)
  /// V(s) ← V(s) + α · δ · e(s) for all s
  /// e(s) ← γ · λ · e(s) + 1_{s=current}
  public func tdLambdaUpdate(
    state : TDLearningState,
    reward : Float,
    nextState : Nat
  ) : TDLearningState {
    let n = state.stateDim;
    let currentVal = if (state.currentState < n) { state.valueFunction[state.currentState] } else { 0.0 };
    let nextVal = if (nextState < n) { state.valueFunction[nextState] } else { 0.0 };
    
    // TD error
    let delta = computeTDError(reward, currentVal, nextVal, state.discountFactor);
    
    // Update eligibility traces
    let newTraces = Array.tabulate<Float>(n, func(i : Nat) : Float {
      let oldTrace = state.eligibilityTraces[i];
      let decayed = state.discountFactor * state.traceDecay * oldTrace;
      if (i == state.currentState) { decayed + 1.0 } else { decayed }
    });
    
    // Update value function
    let newValues = Array.tabulate<Float>(n, func(i : Nat) : Float {
      state.valueFunction[i] + state.learningRate * delta * newTraces[i]
    });
    
    // Update reward history
    let newRewards = Buffer.Buffer<Float>(state.rewardHistory.size() + 1);
    for (r in state.rewardHistory.vals()) { newRewards.add(r) };
    newRewards.add(reward);
    
    // Update average reward
    let avgR = if (newRewards.size() > 0) {
      var sum : Float = 0.0;
      for (r in newRewards.vals()) { sum += r };
      sum / Float.fromInt(newRewards.size())
    } else { 0.0 };
    
    // Track TD errors
    let newTDErrors = Buffer.Buffer<Float>(state.tdErrors.size() + 1);
    for (e in state.tdErrors.vals()) { newTDErrors.add(e) };
    newTDErrors.add(delta);
    
    {
      valueFunction = newValues;
      tdErrors = Buffer.toArray(newTDErrors);
      eligibilityTraces = newTraces;
      discountFactor = state.discountFactor;
      learningRate = state.learningRate;
      traceDecay = state.traceDecay;
      averageReward = avgR;
      rewardHistory = Buffer.toArray(newRewards);
      currentState = nextState;
      stateDim = n;
      totalTDError = state.totalTDError + Float.abs(delta);
      predictionHorizon = state.predictionHorizon;
    }
  };

  /// Successor representation: M(s,s') = E[Σ γᵗ 1_{sₜ=s'} | s₀=s]
  /// Decomposes value into prediction × reward: V(s) = M(s,:) · r
  public func successorRepresentation(
    transitionMatrix : [Float],  // T(s,s') transition probabilities
    gamma : Float,               // discount factor
    stateDim : Nat
  ) : [Float] {
    // M = (I - γT)⁻¹ ≈ I + γT + γ²T² + ... (Neumann series)
    let n = stateDim;
    let n2 = n * n;
    
    // Initialize M = I
    let mBuf = Buffer.Buffer<Float>(n2);
    var idx = 0;
    while (idx < n2) {
      let i = idx / n;
      let j = idx % n;
      if (i == j) { mBuf.add(1.0) } else { mBuf.add(0.0) };
      idx += 1;
    };
    var M = Buffer.toArray(mBuf);
    
    // Neumann series: M += γᵏ · Tᵏ for k = 1,2,...,10
    var Tk = transitionMatrix; // T^k
    var gammak : Float = gamma;
    var k = 0;
    while (k < 10) {
      // M += γᵏ · Tᵏ
      M := Array.tabulate<Float>(n2, func(i : Nat) : Float {
        M[i] + gammak * (if (i < Tk.size()) { Tk[i] } else { 0.0 })
      });
      // Tᵏ⁺¹ = Tᵏ · T
      Tk := matMatMul(Tk, transitionMatrix, n, n, n);
      gammak *= gamma;
      k += 1;
    };
    
    M
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // UNIFIED PREDICTIVE FIELD STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type UnifiedPredictiveFieldState = {
    kalman : KalmanFilterState;
    fisher : FisherInformationState;
    hierarchy : PredictiveCodingHierarchy;
    anticipatory : AnticipatoryFieldState;
    tdLearning : TDLearningState;
    
    // Unified metrics
    totalPredictionError : Float;     // across all levels
    totalInformation : Float;         // total Fisher information
    modelEvidence : Float;            // p(data | model)
    predictionPrecision : Float;      // how precise predictions are
    anticipationHorizon : Float;      // effective prediction horizon
    learningRate : Float;             // global learning signal
    surpriseAccumulator : Float;      // total surprise
  };

  /// Initialize unified predictive field
  public func initUnifiedPredictiveField(
    stateDim : Nat,
    obsDim : Nat,
    hierarchyDim : Nat,
    fieldDim : Nat,
    tdStates : Nat
  ) : UnifiedPredictiveFieldState {
    {
      kalman = initKalmanFilter(stateDim, obsDim);
      fisher = initFisherInformation(stateDim);
      hierarchy = initPredictiveCodingHierarchy(hierarchyDim);
      anticipatory = initAnticipatoryField(fieldDim, 60);
      tdLearning = initTDLearning(tdStates, 0.99, 0.01, 0.9);
      
      totalPredictionError = 0.0;
      totalInformation = 0.0;
      modelEvidence = 0.0;
      predictionPrecision = 1.0;
      anticipationHorizon = 60.0;
      learningRate = 0.01;
      surpriseAccumulator = 0.0;
    }
  };

}
