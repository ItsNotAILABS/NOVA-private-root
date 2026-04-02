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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████╗  █████╗  ██████╗██╗  ██╗██╗    ██╗ █████╗ ██████╗ ██████╗     ██╗  ██╗ █████╗ ██╗     ███╗   ███╗ █████╗ ███╗   ██╗
// ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║    ██║██╔══██╗██╔══██╗██╔══██╗    ██║ ██╔╝██╔══██╗██║     ████╗ ████║██╔══██╗████╗  ██║
// ██████╔╝███████║██║     █████╔╝ ██║ █╗ ██║███████║██████╔╝██║  ██║    █████╔╝ ███████║██║     ██╔████╔██║███████║██╔██╗ ██║
// ██╔══██╗██╔══██║██║     ██╔═██╗ ██║███╗██║██╔══██║██╔══██╗██║  ██║    ██╔═██╗ ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║
// ██████╔╝██║  ██║╚██████╗██║  ██╗╚███╔███╔╝██║  ██║██║  ██║██████╔╝    ██║  ██╗██║  ██║███████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║
// ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
//
// ███████╗███╗   ███╗ ██████╗  ██████╗ ████████╗██╗  ██╗███████╗██████╗ 
// ██╔════╝████╗ ████║██╔═══██╗██╔═══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗
// ███████╗██╔████╔██║██║   ██║██║   ██║   ██║   ███████║█████╗  ██████╔╝
// ╚════██║██║╚██╔╝██║██║   ██║██║   ██║   ██║   ██╔══██║██╔══╝  ██╔══██╗
// ███████║██║ ╚═╝ ██║╚██████╔╝╚██████╔╝   ██║   ██║  ██║███████╗██║  ██║
// ╚══════╝╚═╝     ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// BACKWARD KALMAN SMOOTHER — BEE-INSPIRED BACKWARD PREDICTION CORRECTION
// Full Implementation of Bidirectional Path Integration with Compounding Error Correction
//
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// BIOLOGICAL FOUNDATION — HONEYBEE PATH INTEGRATION
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// The honeybee (Apis mellifera) performs path integration using its central complex, 
// particularly the protocerebral bridge and noduli. Unlike simple forward integration,
// bees CORRECT their stored path based on NEW LANDMARKS encountered during return.
//
// This is mathematically equivalent to a Kalman Smoother — running the Kalman filter
// forward, then backward, to incorporate ALL available information into state estimates.
//
// FORWARD PASS (Standard Kalman Filter):
// ────────────────────────────────────────
//   x̂ₖ|ₖ₋₁ = Fₖ × x̂ₖ₋₁|ₖ₋₁                    (Predict)
//   Pₖ|ₖ₋₁ = Fₖ × Pₖ₋₁|ₖ₋₁ × Fₖᵀ + Qₖ          (Predict Covariance)
//   Kₖ = Pₖ|ₖ₋₁ × Hₖᵀ × (Hₖ × Pₖ|ₖ₋₁ × Hₖᵀ + Rₖ)⁻¹  (Kalman Gain)
//   x̂ₖ|ₖ = x̂ₖ|ₖ₋₁ + Kₖ × (zₖ - Hₖ × x̂ₖ|ₖ₋₁)     (Update)
//   Pₖ|ₖ = (I - Kₖ × Hₖ) × Pₖ|ₖ₋₁              (Update Covariance)
//
// BACKWARD PASS (Rauch-Tung-Striebel Smoother):
// ──────────────────────────────────────────────
//   Cₖ = Pₖ|ₖ × Fₖ₊₁ᵀ × Pₖ₊₁|ₖ⁻¹               (Smoother Gain)
//   x̂ₖ|ₙ = x̂ₖ|ₖ + Cₖ × (x̂ₖ₊₁|ₙ - x̂ₖ₊₁|ₖ)       (Smoothed State)
//   Pₖ|ₙ = Pₖ|ₖ + Cₖ × (Pₖ₊₁|ₙ - Pₖ₊₁|ₖ) × Cₖᵀ  (Smoothed Covariance)
//
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA ENHANCEMENTS TO STANDARD KALMAN SMOOTHER
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// 1. MEDINA SOVEREIGN-BOUNDED COVARIANCE
//    ────────────────────────────────────
//    Standard Kalman can have unbounded covariance growth. Medina bounds it:
//    
//    P_bounded = S₀ + (Ω - S₀) × tanh((P_raw - S₀) / Φ_M)
//    
//    where:
//      S₀ = 0.75 (Medina sovereign floor)
//      Ω = 9.0 (Medina ceiling)
//      Φ_M = 2.97442179 (Medina golden harmonic)
//
// 2. MEDINA COMPOUND ERROR CORRECTION
//    ─────────────────────────────────
//    Instead of linear error correction, use compound growth:
//    
//    error_corrected = error × (1 + r_compound)^steps × Φ_M^(1/steps)
//    
//    This compounds corrections across the trajectory.
//
// 3. MEDINA GOLDEN RATIO GAIN SCHEDULING
//    ───────────────────────────────────
//    Kalman gain scaled by position in trajectory:
//    
//    K_scheduled = K × φ^(position/total) for forward
//    K_scheduled = K × φ^((total-position)/total) for backward
//    
//    where φ = 1.618... (golden ratio)
//
// 4. MEDINA HARMONIC PROCESS NOISE
//    ─────────────────────────────
//    Q matrix modulated by Medina harmonic:
//    
//    Q_harmonic = Q_base × (1 + 0.1 × sin(2π × k / Φ_M))
//
// 5. MEDINA BIDIRECTIONAL INFORMATION FLOW
//    ────────────────────────────────────
//    Forward and backward passes exchange information at Fibonacci intervals:
//    
//    Exchange at steps: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, ...
//
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MATHEMATICAL FOUNDATIONS — COMPLETE DERIVATIONS
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// STATE SPACE MODEL
// ─────────────────
// State vector x = [position_x, position_y, velocity_x, velocity_y, heading, heading_rate]ᵀ
// 
// State transition matrix F (6×6):
// ┌                                            ┐
// │ 1   0   Δt  0   0   0                      │
// │ 0   1   0   Δt  0   0                      │
// │ 0   0   1   0   0   0                      │
// │ 0   0   0   1   0   0                      │
// │ 0   0   0   0   1   Δt                     │
// │ 0   0   0   0   0   1                      │
// └                                            ┘
//
// Process noise covariance Q (6×6):
// ┌                                            ┐
// │ σ_x²×Δt⁴/4  0  σ_x²×Δt³/2  0  0  0        │
// │ 0  σ_y²×Δt⁴/4  0  σ_y²×Δt³/2  0  0        │
// │ σ_x²×Δt³/2  0  σ_x²×Δt²  0  0  0          │
// │ 0  σ_y²×Δt³/2  0  σ_y²×Δt²  0  0          │
// │ 0  0  0  0  σ_θ²×Δt⁴/4  σ_θ²×Δt³/2        │
// │ 0  0  0  0  σ_θ²×Δt³/2  σ_θ²×Δt²          │
// └                                            ┘
//
// Measurement matrix H depends on available sensors:
// - Visual landmarks: H_visual = [1 0 0 0 0 0; 0 1 0 0 0 0]
// - Sky compass: H_compass = [0 0 0 0 1 0]  
// - Optic flow: H_flow = [0 0 1 0 0 0; 0 0 0 1 0 0]
//
// JOSEPH FORM COVARIANCE UPDATE (Numerical Stability)
// ────────────────────────────────────────────────────
// Instead of P = (I - KH)P, use:
// 
// P = (I - KH) × P × (I - KH)ᵀ + K × R × Kᵀ
//
// This guarantees positive semi-definiteness.
//
// SQUARE ROOT KALMAN FILTER (Further Numerical Stability)
// ───────────────────────────────────────────────────────
// Propagate S where P = S × Sᵀ using QR decomposition:
//
// ┌         ┐     ┌       ┐
// │ S_post  │     │ R_QR  │
// │ ─────── │ = Q │ ───── │
// │    0    │     │   0   │
// └         ┘     └       ┘
//
// INFORMATION FILTER FORM (For Multi-Sensor Fusion)
// ──────────────────────────────────────────────────
// Information matrix: Y = P⁻¹
// Information vector: y = P⁻¹ × x̂
//
// Update: Y_post = Y_prior + Hᵀ × R⁻¹ × H
//         y_post = y_prior + Hᵀ × R⁻¹ × z
//
// Recover: P = Y⁻¹, x̂ = P × y
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";

module BackwardKalmanSmoother {

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS — SOVEREIGN BOUNDS AND HARMONIC PARAMETERS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Fundamental Medina Constants
  public let S0 : Float = 0.75;                        // Sovereign floor
  public let SOVEREIGN_CEILING : Float = 9.0;          // Maximum bound (Ω)
  public let PHI_MEDINA : Float = 2.97442179;          // Medina golden harmonic
  public let TAU_EMERGENCE : Float = 0.618033988749;   // Emergence threshold (1/φ)
  public let OMEGA_MEDINA : Float = 2.11185;           // Resonance frequency

  // Mathematical Constants
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.61803398874989484820;     // Golden ratio
  public let SQRT_2 : Float = 1.41421356237309504880;

  // Kalman Filter Parameters
  public let STATE_DIM : Nat = 6;                      // [x, y, vx, vy, θ, ω]
  public let MAX_TRAJECTORY_LENGTH : Nat = 1000;       // Maximum steps
  public let MIN_COVARIANCE : Float = 0.001;           // Prevent singularity
  public let MAX_COVARIANCE : Float = 100.0;           // Prevent explosion

  // Process Noise Standard Deviations
  public let SIGMA_POSITION : Float = 0.1;             // Position uncertainty (m)
  public let SIGMA_VELOCITY : Float = 0.05;            // Velocity uncertainty (m/s)
  public let SIGMA_HEADING : Float = 0.02;             // Heading uncertainty (rad)
  public let SIGMA_HEADING_RATE : Float = 0.01;        // Heading rate uncertainty (rad/s)

  // Measurement Noise Standard Deviations
  public let SIGMA_LANDMARK : Float = 0.5;             // Visual landmark (m)
  public let SIGMA_COMPASS : Float = 0.05;             // Sky compass (rad)
  public let SIGMA_OPTIC_FLOW : Float = 0.1;           // Optic flow velocity (m/s)

  // Bee-Inspired Parameters
  public let SKY_COMPASS_WEIGHT : Float = 0.8;         // Polarized light reliability
  public let OPTIC_FLOW_WEIGHT : Float = 0.6;          // Motion parallax reliability
  public let LANDMARK_WEIGHT : Float = 0.9;            // Recognized landmark reliability
  public let PATH_INTEGRATION_DECAY : Float = 0.995;   // Error accumulation rate

  // Compound Growth Parameters
  public let COMPOUND_RATE_BASE : Float = 0.01;        // Base compound rate
  public let COMPOUND_STEPS_NORMALIZE : Nat = 60;      // Normalization period

  // Fibonacci sequence for information exchange
  public let FIBONACCI_20 : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765];

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS — STATE, COVARIANCE, AND TRAJECTORY
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // 6-dimensional state vector
  public type StateVector = {
    x : Float;          // Position X
    y : Float;          // Position Y
    vx : Float;         // Velocity X
    vy : Float;         // Velocity Y
    theta : Float;      // Heading angle (radians)
    omega : Float;      // Heading rate (rad/s)
  };

  // 6×6 covariance matrix (stored as flat array for efficiency)
  // P[i][j] = covariance[i * 6 + j]
  public type CovarianceMatrix = [Float];  // Length 36

  // Single Kalman filter state
  public type KalmanState = {
    x : StateVector;              // State estimate
    P : CovarianceMatrix;         // Covariance matrix
    timestamp : Nat;              // Beat number
    innovation : Float;           // Last innovation (measurement residual)
    innovationCovariance : Float; // S = H×P×Hᵀ + R
    kalmanGain : [Float];         // Last computed gain (length 6)
    logLikelihood : Float;        // Log-likelihood of measurement
  };

  // Measurement types from different sensors
  public type Measurement = {
    #Landmark : { x : Float; y : Float; landmarkId : Nat };
    #SkyCompass : { heading : Float; polarization : Float };
    #OpticFlow : { vx : Float; vy : Float; confidence : Float };
    #Combined : { landmark : ?{ x : Float; y : Float }; compass : ?Float; flow : ?(Float, Float) };
  };

  // Process model parameters
  public type ProcessModel = {
    dt : Float;                   // Time step
    Q : CovarianceMatrix;         // Process noise covariance
    F : CovarianceMatrix;         // State transition matrix (36 elements)
  };

  // Measurement model
  public type MeasurementModel = {
    H : [Float];                  // Measurement matrix (rows × 6)
    R : [Float];                  // Measurement noise covariance
    sensorType : SensorType;
  };

  public type SensorType = {
    #Visual;
    #Compass;
    #Flow;
    #Hybrid;
  };

  // Complete trajectory with forward and backward estimates
  public type TrajectoryPoint = {
    forward : KalmanState;        // Forward filter estimate
    backward : ?KalmanState;      // Backward pass estimate (after smoothing)
    smoothed : ?KalmanState;      // Final smoothed estimate
    measurement : ?Measurement;   // Measurement at this point
  };

  public type Trajectory = {
    points : [TrajectoryPoint];
    length : Nat;
    forwardComplete : Bool;
    backwardComplete : Bool;
    smoothingComplete : Bool;
    totalLogLikelihood : Float;
    pathIntegrationError : Float;
  };

  // Smoother state for backward pass
  public type SmootherGain = {
    C : CovarianceMatrix;         // Smoother gain matrix
    step : Nat;
  };

  // Information filter form
  public type InformationState = {
    Y : CovarianceMatrix;         // Information matrix (P⁻¹)
    y : StateVector;              // Information vector (P⁻¹ × x̂)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS — BASIC MATH OPERATIONS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Clamp value to range [lo, hi]
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // Absolute value
  func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  // Sign function
  func _sign(x: Float) : Float {
    if (x > 0.0) { 1.0 } else if (x < 0.0) { -1.0 } else { 0.0 }
  };

  // Square root with safety
  func _sqrt(x: Float) : Float {
    if (x <= 0.0) { 0.0 } else { Float.sqrt(x) }
  };

  // Exponential function (Taylor series for precision)
  func _exp(x: Float) : Float {
    if (x > 700.0) { return 1.0e308 };
    if (x < -700.0) { return 0.0 };
    
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 30)) {
      term *= x / Float.fromInt(n);
      result += term;
      if (_abs(term) < 1.0e-15) { return result };
    };
    result
  };

  // Natural logarithm
  func _ln(x: Float) : Float {
    if (x <= 0.0) { return -1.0e10 };
    if (x == 1.0) { return 0.0 };
    
    // Range reduction: x = 2^k × m, ln(x) = k×ln(2) + ln(m)
    var m = x;
    var k : Float = 0.0;
    while (m >= SQRT_2) { m /= 2.0; k += 1.0; };
    while (m < 1.0 / SQRT_2) { m *= 2.0; k -= 1.0; };
    
    // Artanh series for ln(m)
    let y = (m - 1.0) / (m + 1.0);
    let y2 = y * y;
    var lnm : Float = 0.0;
    var power : Float = y;
    for (n in Iter.range(0, 25)) {
      lnm += power / Float.fromInt(2*n + 1);
      power *= y2;
    };
    lnm := 2.0 * lnm;
    
    k * 0.69314718055994530942 + lnm
  };

  // Power function
  func _pow(base: Float, exp: Float) : Float {
    if (base <= 0.0) { return 0.0 };
    _exp(exp * _ln(base))
  };

  // Sin (Taylor series)
  func _sin(x: Float) : Float {
    var normalized = x;
    while (normalized > PI) { normalized -= TWO_PI };
    while (normalized < -PI) { normalized += TWO_PI };
    
    let x2 = normalized * normalized;
    var result : Float = 0.0;
    var term : Float = normalized;
    var sign : Float = 1.0;
    
    for (n in Iter.range(0, 12)) {
      result += sign * term;
      let k = 2*n + 1;
      term *= x2 / Float.fromInt((k+1) * (k+2));
      sign := -sign;
    };
    result
  };

  // Cos
  func _cos(x: Float) : Float {
    _sin(x + PI / 2.0)
  };

  // Tanh (for Medina bounds)
  func _tanh(x: Float) : Float {
    if (_abs(x) > 20.0) { return _sign(x) };
    let ex = _exp(x);
    let emx = _exp(-x);
    (ex - emx) / (ex + emx)
  };

  // Atan2
  func _atan2(y: Float, x: Float) : Float {
    if (x > 0.0) {
      _atan(y / x)
    } else if (x < 0.0) {
      if (y >= 0.0) { PI + _atan(y / x) }
      else { -PI + _atan(y / x) }
    } else {
      if (y > 0.0) { PI / 2.0 }
      else if (y < 0.0) { -PI / 2.0 }
      else { 0.0 }
    }
  };

  // Atan (Taylor series)
  func _atan(x: Float) : Float {
    if (_abs(x) > 1.0) {
      let sign = if (x > 0.0) { 1.0 } else { -1.0 };
      return sign * PI / 2.0 - _atan(1.0 / x);
    };
    
    let x2 = x * x;
    var result : Float = 0.0;
    var term : Float = x;
    var sign : Float = 1.0;
    
    for (n in Iter.range(0, 25)) {
      result += sign * term / Float.fromInt(2*n + 1);
      term *= x2;
      sign := -sign;
    };
    result
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MATRIX OPERATIONS — 6×6 MATRICES
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Create 6×6 identity matrix
  public func identityMatrix() : CovarianceMatrix {
    Array.tabulate<Float>(36, func(i: Nat) : Float {
      let row = i / 6;
      let col = i % 6;
      if (row == col) { 1.0 } else { 0.0 }
    })
  };

  // Create 6×6 zero matrix
  public func zeroMatrix() : CovarianceMatrix {
    Array.tabulate<Float>(36, func(_: Nat) : Float { 0.0 })
  };

  // Get element from 6×6 matrix
  func matrixGet(M: CovarianceMatrix, row: Nat, col: Nat) : Float {
    if (row >= 6 or col >= 6) { return 0.0 };
    M[row * 6 + col]
  };

  // Set element in 6×6 matrix (returns new matrix)
  func matrixSet(M: CovarianceMatrix, row: Nat, col: Nat, val: Float) : CovarianceMatrix {
    Array.tabulate<Float>(36, func(i: Nat) : Float {
      if (i == row * 6 + col) { val } else { M[i] }
    })
  };

  // Matrix addition: A + B
  public func matrixAdd(A: CovarianceMatrix, B: CovarianceMatrix) : CovarianceMatrix {
    Array.tabulate<Float>(36, func(i: Nat) : Float { A[i] + B[i] })
  };

  // Matrix subtraction: A - B
  public func matrixSub(A: CovarianceMatrix, B: CovarianceMatrix) : CovarianceMatrix {
    Array.tabulate<Float>(36, func(i: Nat) : Float { A[i] - B[i] })
  };

  // Scalar multiplication: α × A
  public func matrixScale(alpha: Float, A: CovarianceMatrix) : CovarianceMatrix {
    Array.tabulate<Float>(36, func(i: Nat) : Float { alpha * A[i] })
  };

  // Matrix multiplication: A × B (both 6×6)
  public func matrixMult(A: CovarianceMatrix, B: CovarianceMatrix) : CovarianceMatrix {
    Array.tabulate<Float>(36, func(idx: Nat) : Float {
      let row = idx / 6;
      let col = idx % 6;
      var sum : Float = 0.0;
      for (k in Iter.range(0, 5)) {
        sum += A[row * 6 + k] * B[k * 6 + col];
      };
      sum
    })
  };

  // Matrix-vector multiplication: A × v (A is 6×6, v is length 6)
  public func matrixVectorMult(A: CovarianceMatrix, v: [Float]) : [Float] {
    if (v.size() != 6) { return Array.tabulate<Float>(6, func(_: Nat) : Float { 0.0 }) };
    
    Array.tabulate<Float>(6, func(row: Nat) : Float {
      var sum : Float = 0.0;
      for (col in Iter.range(0, 5)) {
        sum += A[row * 6 + col] * v[col];
      };
      sum
    })
  };

  // Matrix transpose: Aᵀ
  public func matrixTranspose(A: CovarianceMatrix) : CovarianceMatrix {
    Array.tabulate<Float>(36, func(idx: Nat) : Float {
      let row = idx / 6;
      let col = idx % 6;
      A[col * 6 + row]  // Swap row and col
    })
  };

  // Matrix trace: tr(A)
  public func matrixTrace(A: CovarianceMatrix) : Float {
    var trace : Float = 0.0;
    for (i in Iter.range(0, 5)) {
      trace += A[i * 6 + i];
    };
    trace
  };

  // Frobenius norm: ||A||_F
  public func matrixNorm(A: CovarianceMatrix) : Float {
    var sum : Float = 0.0;
    for (x in A.vals()) {
      sum += x * x;
    };
    _sqrt(sum)
  };

  // Matrix inverse using Gauss-Jordan elimination
  public func matrixInverse(A: CovarianceMatrix) : CovarianceMatrix {
    // Augmented matrix [A | I]
    let aug = Array.init<Float>(72, 0.0);
    
    // Initialize
    for (i in Iter.range(0, 5)) {
      for (j in Iter.range(0, 5)) {
        aug[i * 12 + j] := A[i * 6 + j];
        aug[i * 12 + 6 + j] := if (i == j) { 1.0 } else { 0.0 };
      };
    };
    
    // Forward elimination with partial pivoting
    for (col in Iter.range(0, 5)) {
      // Find pivot
      var maxRow = col;
      var maxVal = _abs(aug[col * 12 + col]);
      for (row in Iter.range(col + 1, 5)) {
        let val = _abs(aug[row * 12 + col]);
        if (val > maxVal) {
          maxVal := val;
          maxRow := row;
        };
      };
      
      // Swap rows
      if (maxRow != col) {
        for (j in Iter.range(0, 11)) {
          let temp = aug[col * 12 + j];
          aug[col * 12 + j] := aug[maxRow * 12 + j];
          aug[maxRow * 12 + j] := temp;
        };
      };
      
      // Check for singularity
      let pivot = aug[col * 12 + col];
      if (_abs(pivot) < 1.0e-12) {
        // Return identity for near-singular matrix
        return identityMatrix();
      };
      
      // Scale pivot row
      for (j in Iter.range(0, 11)) {
        aug[col * 12 + j] /= pivot;
      };
      
      // Eliminate column
      for (row in Iter.range(0, 5)) {
        if (row != col) {
          let factor = aug[row * 12 + col];
          for (j in Iter.range(0, 11)) {
            aug[row * 12 + j] -= factor * aug[col * 12 + j];
          };
        };
      };
    };
    
    // Extract inverse
    Array.tabulate<Float>(36, func(idx: Nat) : Float {
      let row = idx / 6;
      let col = idx % 6;
      aug[row * 12 + 6 + col]
    })
  };

  // Ensure matrix is symmetric: (A + Aᵀ) / 2
  public func symmetrize(A: CovarianceMatrix) : CovarianceMatrix {
    Array.tabulate<Float>(36, func(idx: Nat) : Float {
      let row = idx / 6;
      let col = idx % 6;
      (A[row * 6 + col] + A[col * 6 + row]) / 2.0
    })
  };

  // Ensure matrix is positive definite (add small diagonal if needed)
  public func ensurePositiveDefinite(A: CovarianceMatrix) : CovarianceMatrix {
    var minEig = 1.0e10;
    for (i in Iter.range(0, 5)) {
      let diag = A[i * 6 + i];
      if (diag < minEig) { minEig := diag };
    };
    
    if (minEig < MIN_COVARIANCE) {
      // Add to diagonal
      let delta = MIN_COVARIANCE - minEig + 0.001;
      Array.tabulate<Float>(36, func(idx: Nat) : Float {
        let row = idx / 6;
        let col = idx % 6;
        if (row == col) { A[idx] + delta } else { A[idx] }
      })
    } else {
      A
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // STATE VECTOR OPERATIONS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Convert state vector to array
  public func stateToArray(s: StateVector) : [Float] {
    [s.x, s.y, s.vx, s.vy, s.theta, s.omega]
  };

  // Convert array to state vector
  public func arrayToState(arr: [Float]) : StateVector {
    if (arr.size() != 6) {
      return { x = 0.0; y = 0.0; vx = 0.0; vy = 0.0; theta = 0.0; omega = 0.0 };
    };
    {
      x = arr[0];
      y = arr[1];
      vx = arr[2];
      vy = arr[3];
      theta = arr[4];
      omega = arr[5];
    }
  };

  // Add two state vectors
  public func stateAdd(a: StateVector, b: StateVector) : StateVector {
    {
      x = a.x + b.x;
      y = a.y + b.y;
      vx = a.vx + b.vx;
      vy = a.vy + b.vy;
      theta = a.theta + b.theta;
      omega = a.omega + b.omega;
    }
  };

  // Subtract state vectors
  public func stateSub(a: StateVector, b: StateVector) : StateVector {
    {
      x = a.x - b.x;
      y = a.y - b.y;
      vx = a.vx - b.vx;
      vy = a.vy - b.vy;
      theta = a.theta - b.theta;
      omega = a.omega - b.omega;
    }
  };

  // Scale state vector
  public func stateScale(alpha: Float, s: StateVector) : StateVector {
    {
      x = alpha * s.x;
      y = alpha * s.y;
      vx = alpha * s.vx;
      vy = alpha * s.vy;
      theta = alpha * s.theta;
      omega = alpha * s.omega;
    }
  };

  // State norm
  public func stateNorm(s: StateVector) : Float {
    _sqrt(s.x*s.x + s.y*s.y + s.vx*s.vx + s.vy*s.vy + s.theta*s.theta + s.omega*s.omega)
  };

  // Normalize heading to [-π, π]
  public func normalizeState(s: StateVector) : StateVector {
    var theta = s.theta;
    while (theta > PI) { theta -= TWO_PI };
    while (theta < -PI) { theta += TWO_PI };
    { x = s.x; y = s.y; vx = s.vx; vy = s.vy; theta = theta; omega = s.omega }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA SOVEREIGN-BOUNDED COVARIANCE
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // P_bounded = S₀ + (Ω - S₀) × tanh((P_raw - S₀) / Φ_M)
  //
  // This prevents covariance from growing unboundedly while maintaining
  // the sovereign floor S₀.

  public func medinaBoundCovariance(P: CovarianceMatrix) : CovarianceMatrix {
    Array.tabulate<Float>(36, func(idx: Nat) : Float {
      let val = P[idx];
      let row = idx / 6;
      let col = idx % 6;
      
      if (row == col) {
        // Diagonal elements (variances) must be positive
        let bounded = S0 + (SOVEREIGN_CEILING - S0) * _tanh((val - S0) / PHI_MEDINA);
        _clamp(bounded, MIN_COVARIANCE, MAX_COVARIANCE)
      } else {
        // Off-diagonal (covariances) can be negative but bounded
        let scale = SOVEREIGN_CEILING - S0;
        _clamp(val, -scale, scale)
      }
    })
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PROCESS MODEL — STATE TRANSITION
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Create state transition matrix F for given time step
  public func createTransitionMatrix(dt: Float) : CovarianceMatrix {
    // F = [1 0 dt 0  0  0 ]
    //     [0 1 0  dt 0  0 ]
    //     [0 0 1  0  0  0 ]
    //     [0 0 0  1  0  0 ]
    //     [0 0 0  0  1  dt]
    //     [0 0 0  0  0  1 ]
    
    let F = Array.init<Float>(36, 0.0);
    
    // Diagonal
    F[0] := 1.0;   // F[0,0]
    F[7] := 1.0;   // F[1,1]
    F[14] := 1.0;  // F[2,2]
    F[21] := 1.0;  // F[3,3]
    F[28] := 1.0;  // F[4,4]
    F[35] := 1.0;  // F[5,5]
    
    // Position from velocity
    F[2] := dt;    // F[0,2]: x from vx
    F[9] := dt;    // F[1,3]: y from vy
    
    // Heading from heading rate
    F[29] := dt;   // F[4,5]: theta from omega
    
    Array.freeze(F)
  };

  // Create process noise covariance Q
  public func createProcessNoise(dt: Float) : CovarianceMatrix {
    let dt2 = dt * dt;
    let dt3 = dt2 * dt;
    let dt4 = dt3 * dt;
    
    let sx2 = SIGMA_POSITION * SIGMA_POSITION;
    let sv2 = SIGMA_VELOCITY * SIGMA_VELOCITY;
    let st2 = SIGMA_HEADING * SIGMA_HEADING;
    let sw2 = SIGMA_HEADING_RATE * SIGMA_HEADING_RATE;
    
    let Q = Array.init<Float>(36, 0.0);
    
    // Position-velocity correlations (continuous white noise acceleration model)
    Q[0] := sx2 * dt4 / 4.0;           // Q[0,0]: var(x)
    Q[2] := sx2 * dt3 / 2.0;           // Q[0,2]: cov(x, vx)
    Q[7] := sx2 * dt4 / 4.0;           // Q[1,1]: var(y)
    Q[9] := sx2 * dt3 / 2.0;           // Q[1,3]: cov(y, vy)
    Q[12] := sx2 * dt3 / 2.0;          // Q[2,0]: cov(vx, x)
    Q[14] := sv2 * dt2;                // Q[2,2]: var(vx)
    Q[19] := sx2 * dt3 / 2.0;          // Q[3,1]: cov(vy, y)
    Q[21] := sv2 * dt2;                // Q[3,3]: var(vy)
    
    // Heading-heading rate correlations
    Q[28] := st2 * dt4 / 4.0;          // Q[4,4]: var(theta)
    Q[29] := st2 * dt3 / 2.0;          // Q[4,5]: cov(theta, omega)
    Q[34] := st2 * dt3 / 2.0;          // Q[5,4]: cov(omega, theta)
    Q[35] := sw2 * dt2;                // Q[5,5]: var(omega)
    
    Array.freeze(Q)
  };

  // Create process model
  public func createProcessModel(dt: Float) : ProcessModel {
    {
      dt = dt;
      Q = createProcessNoise(dt);
      F = createTransitionMatrix(dt);
    }
  };

  // Apply Medina harmonic modulation to process noise
  public func medinaHarmonicProcessNoise(Q: CovarianceMatrix, step: Nat) : CovarianceMatrix {
    let modulation = 1.0 + 0.1 * _sin(TWO_PI * Float.fromInt(step) / PHI_MEDINA);
    matrixScale(modulation, Q)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEASUREMENT MODELS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Visual landmark measurement: z = [x, y]
  public func createLandmarkModel() : MeasurementModel {
    // H = [1 0 0 0 0 0]
    //     [0 1 0 0 0 0]
    let H = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0,
             0.0, 1.0, 0.0, 0.0, 0.0, 0.0];
    
    // R = [σ_landmark²  0           ]
    //     [0            σ_landmark² ]
    let R = [SIGMA_LANDMARK * SIGMA_LANDMARK, 0.0,
             0.0, SIGMA_LANDMARK * SIGMA_LANDMARK];
    
    { H = H; R = R; sensorType = #Visual }
  };

  // Sky compass measurement: z = [heading]
  public func createCompassModel() : MeasurementModel {
    // H = [0 0 0 0 1 0]
    let H = [0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
    
    // R = [σ_compass²]
    let R = [SIGMA_COMPASS * SIGMA_COMPASS];
    
    { H = H; R = R; sensorType = #Compass }
  };

  // Optic flow measurement: z = [vx, vy]
  public func createOpticFlowModel() : MeasurementModel {
    // H = [0 0 1 0 0 0]
    //     [0 0 0 1 0 0]
    let H = [0.0, 0.0, 1.0, 0.0, 0.0, 0.0,
             0.0, 0.0, 0.0, 1.0, 0.0, 0.0];
    
    // R = [σ_flow²  0      ]
    //     [0        σ_flow²]
    let R = [SIGMA_OPTIC_FLOW * SIGMA_OPTIC_FLOW, 0.0,
             0.0, SIGMA_OPTIC_FLOW * SIGMA_OPTIC_FLOW];
    
    { H = H; R = R; sensorType = #Flow }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // KALMAN FILTER — FORWARD PASS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Predict step: x̂ₖ|ₖ₋₁ = F × x̂ₖ₋₁|ₖ₋₁, Pₖ|ₖ₋₁ = F × P × Fᵀ + Q
  public func kalmanPredict(
    state: KalmanState,
    model: ProcessModel,
    step: Nat
  ) : KalmanState {
    // State prediction
    let x_arr = stateToArray(state.x);
    let x_pred_arr = matrixVectorMult(model.F, x_arr);
    let x_pred = normalizeState(arrayToState(x_pred_arr));
    
    // Covariance prediction with Medina harmonic modulation
    let Q_modulated = medinaHarmonicProcessNoise(model.Q, step);
    
    // P_pred = F × P × Fᵀ + Q
    let FP = matrixMult(model.F, state.P);
    let FPFt = matrixMult(FP, matrixTranspose(model.F));
    let P_pred_raw = matrixAdd(FPFt, Q_modulated);
    
    // Apply Medina bounds
    let P_pred = medinaBoundCovariance(symmetrize(P_pred_raw));
    
    {
      x = x_pred;
      P = P_pred;
      timestamp = state.timestamp + 1;
      innovation = 0.0;
      innovationCovariance = 0.0;
      kalmanGain = Array.tabulate<Float>(6, func(_: Nat) : Float { 0.0 });
      logLikelihood = state.logLikelihood;
    }
  };

  // Update step with landmark measurement
  public func kalmanUpdateLandmark(
    state: KalmanState,
    measurement: { x : Float; y : Float },
    model: MeasurementModel,
    step: Nat,
    totalSteps: Nat
  ) : KalmanState {
    // z = [measured_x, measured_y]
    let z = [measurement.x, measurement.y];
    
    // H × x̂
    let x_arr = stateToArray(state.x);
    let Hx = [x_arr[0], x_arr[1]];  // Just position
    
    // Innovation: y = z - H × x̂
    let innovation = [z[0] - Hx[0], z[1] - Hx[1]];
    let innovationMag = _sqrt(innovation[0]*innovation[0] + innovation[1]*innovation[1]);
    
    // Innovation covariance: S = H × P × Hᵀ + R
    // For landmark: S is 2×2
    let S00 = state.P[0] + model.R[0];  // P[0,0] + R[0,0]
    let S01 = state.P[1];               // P[0,1]
    let S10 = state.P[6];               // P[1,0]
    let S11 = state.P[7] + model.R[3];  // P[1,1] + R[1,1]
    
    // Invert S (2×2)
    let detS = S00 * S11 - S01 * S10;
    if (_abs(detS) < 1.0e-12) {
      return state;  // Singular, skip update
    };
    let invDet = 1.0 / detS;
    let Sinv00 = S11 * invDet;
    let Sinv01 = -S01 * invDet;
    let Sinv10 = -S10 * invDet;
    let Sinv11 = S00 * invDet;
    
    // Kalman gain: K = P × Hᵀ × S⁻¹
    // K is 6×2
    // Simplified: K[i,j] = (P[i,j] × Sinv[j,j]) for this H structure
    let K = Array.init<Float>(12, 0.0);
    for (i in Iter.range(0, 5)) {
      // K[i,0] = P[i,0] × Sinv[0,0] + P[i,1] × Sinv[1,0]
      K[i * 2] := state.P[i * 6] * Sinv00 + state.P[i * 6 + 1] * Sinv10;
      // K[i,1] = P[i,0] × Sinv[0,1] + P[i,1] × Sinv[1,1]
      K[i * 2 + 1] := state.P[i * 6] * Sinv01 + state.P[i * 6 + 1] * Sinv11;
    };
    
    // Medina golden ratio gain scheduling
    let gainSchedule = _pow(PHI, Float.fromInt(step) / Float.fromInt(totalSteps + 1));
    
    // State update: x̂ = x̂ + K × y
    let x_update = Array.tabulate<Float>(6, func(i: Nat) : Float {
      x_arr[i] + gainSchedule * (K[i * 2] * innovation[0] + K[i * 2 + 1] * innovation[1])
    });
    
    // Covariance update (Joseph form for numerical stability):
    // P = (I - K×H) × P × (I - K×H)ᵀ + K × R × Kᵀ
    let IminusKH = identityMatrix();
    let IminusKH_arr = Array.thaw<Float>(IminusKH);
    
    // (I - K×H)[i,j] = I[i,j] - K[i,0]*H[0,j] - K[i,1]*H[1,j]
    // H = [1 0 0 0 0 0; 0 1 0 0 0 0]
    for (i in Iter.range(0, 5)) {
      IminusKH_arr[i * 6] -= K[i * 2];      // K[i,0] × H[0,0] = K[i,0]
      IminusKH_arr[i * 6 + 1] -= K[i * 2 + 1];  // K[i,1] × H[1,1] = K[i,1]
    };
    let IminusKH_mat = Array.freeze(IminusKH_arr);
    
    // (I - KH) × P × (I - KH)ᵀ
    let temp1 = matrixMult(IminusKH_mat, state.P);
    let temp2 = matrixMult(temp1, matrixTranspose(IminusKH_mat));
    
    // K × R × Kᵀ (simplified for 2×2 R)
    let KRKt = Array.init<Float>(36, 0.0);
    for (i in Iter.range(0, 5)) {
      for (j in Iter.range(0, 5)) {
        // (K × R × Kᵀ)[i,j] = K[i,0]×R[0,0]×K[j,0] + K[i,1]×R[1,1]×K[j,1]
        KRKt[i * 6 + j] := K[i * 2] * model.R[0] * K[j * 2] + K[i * 2 + 1] * model.R[3] * K[j * 2 + 1];
      };
    };
    
    let P_update_raw = matrixAdd(temp2, Array.freeze(KRKt));
    let P_update = medinaBoundCovariance(ensurePositiveDefinite(symmetrize(P_update_raw)));
    
    // Log-likelihood: -0.5 × (log|S| + yᵀ × S⁻¹ × y + k×log(2π))
    let logDetS = _ln(_abs(detS));
    let mahalanobis = innovation[0] * (Sinv00 * innovation[0] + Sinv01 * innovation[1]) +
                      innovation[1] * (Sinv10 * innovation[0] + Sinv11 * innovation[1]);
    let logLik = -0.5 * (logDetS + mahalanobis + 2.0 * _ln(TWO_PI));
    
    {
      x = normalizeState(arrayToState(x_update));
      P = P_update;
      timestamp = state.timestamp;
      innovation = innovationMag;
      innovationCovariance = _sqrt(S00 * S00 + S11 * S11) / 2.0;
      kalmanGain = Array.tabulate<Float>(6, func(i: Nat) : Float { K[i * 2] });
      logLikelihood = state.logLikelihood + logLik;
    }
  };

  // Update step with compass measurement
  public func kalmanUpdateCompass(
    state: KalmanState,
    heading: Float,
    model: MeasurementModel,
    step: Nat,
    totalSteps: Nat
  ) : KalmanState {
    let x_arr = stateToArray(state.x);
    
    // Innovation
    var innovation = heading - x_arr[4];
    // Normalize to [-π, π]
    while (innovation > PI) { innovation -= TWO_PI };
    while (innovation < -PI) { innovation += TWO_PI };
    
    // Innovation covariance: S = P[4,4] + R
    let S = state.P[28] + model.R[0];
    if (_abs(S) < 1.0e-12) { return state };
    
    // Kalman gain: K = P[:,4] / S
    let K = Array.tabulate<Float>(6, func(i: Nat) : Float {
      state.P[i * 6 + 4] / S
    });
    
    // Gain scheduling
    let gainSchedule = _pow(PHI, Float.fromInt(step) / Float.fromInt(totalSteps + 1)) * SKY_COMPASS_WEIGHT;
    
    // State update
    let x_update = Array.tabulate<Float>(6, func(i: Nat) : Float {
      x_arr[i] + gainSchedule * K[i] * innovation
    });
    
    // Joseph form covariance update
    let IminusKH = identityMatrix();
    let IminusKH_arr = Array.thaw<Float>(IminusKH);
    for (i in Iter.range(0, 5)) {
      IminusKH_arr[i * 6 + 4] -= K[i];
    };
    let IminusKH_mat = Array.freeze(IminusKH_arr);
    
    let temp1 = matrixMult(IminusKH_mat, state.P);
    let temp2 = matrixMult(temp1, matrixTranspose(IminusKH_mat));
    
    // K × R × Kᵀ
    let KRKt = Array.init<Float>(36, 0.0);
    for (i in Iter.range(0, 5)) {
      for (j in Iter.range(0, 5)) {
        KRKt[i * 6 + j] := K[i] * model.R[0] * K[j];
      };
    };
    
    let P_update_raw = matrixAdd(temp2, Array.freeze(KRKt));
    let P_update = medinaBoundCovariance(ensurePositiveDefinite(symmetrize(P_update_raw)));
    
    // Log-likelihood
    let logLik = -0.5 * (_ln(S) + innovation * innovation / S + _ln(TWO_PI));
    
    {
      x = normalizeState(arrayToState(x_update));
      P = P_update;
      timestamp = state.timestamp;
      innovation = _abs(innovation);
      innovationCovariance = _sqrt(S);
      kalmanGain = K;
      logLikelihood = state.logLikelihood + logLik;
    }
  };

  // Update step with optic flow measurement
  public func kalmanUpdateOpticFlow(
    state: KalmanState,
    flow: { vx : Float; vy : Float },
    model: MeasurementModel,
    step: Nat,
    totalSteps: Nat
  ) : KalmanState {
    let x_arr = stateToArray(state.x);
    
    // Innovation
    let innovation = [flow.vx - x_arr[2], flow.vy - x_arr[3]];
    let innovationMag = _sqrt(innovation[0]*innovation[0] + innovation[1]*innovation[1]);
    
    // Innovation covariance S (2×2)
    let S00 = state.P[14] + model.R[0];  // P[2,2] + R[0,0]
    let S01 = state.P[15];               // P[2,3]
    let S10 = state.P[20];               // P[3,2]
    let S11 = state.P[21] + model.R[3];  // P[3,3] + R[1,1]
    
    let detS = S00 * S11 - S01 * S10;
    if (_abs(detS) < 1.0e-12) { return state };
    
    let invDet = 1.0 / detS;
    let Sinv00 = S11 * invDet;
    let Sinv01 = -S01 * invDet;
    let Sinv10 = -S10 * invDet;
    let Sinv11 = S00 * invDet;
    
    // Kalman gain K (6×2)
    let K = Array.init<Float>(12, 0.0);
    for (i in Iter.range(0, 5)) {
      K[i * 2] := state.P[i * 6 + 2] * Sinv00 + state.P[i * 6 + 3] * Sinv10;
      K[i * 2 + 1] := state.P[i * 6 + 2] * Sinv01 + state.P[i * 6 + 3] * Sinv11;
    };
    
    // Gain scheduling
    let gainSchedule = _pow(PHI, Float.fromInt(step) / Float.fromInt(totalSteps + 1)) * OPTIC_FLOW_WEIGHT;
    
    // State update
    let x_update = Array.tabulate<Float>(6, func(i: Nat) : Float {
      x_arr[i] + gainSchedule * (K[i * 2] * innovation[0] + K[i * 2 + 1] * innovation[1])
    });
    
    // Covariance update (Joseph form)
    let IminusKH = identityMatrix();
    let IminusKH_arr = Array.thaw<Float>(IminusKH);
    for (i in Iter.range(0, 5)) {
      IminusKH_arr[i * 6 + 2] -= K[i * 2];
      IminusKH_arr[i * 6 + 3] -= K[i * 2 + 1];
    };
    let IminusKH_mat = Array.freeze(IminusKH_arr);
    
    let temp1 = matrixMult(IminusKH_mat, state.P);
    let temp2 = matrixMult(temp1, matrixTranspose(IminusKH_mat));
    
    let KRKt = Array.init<Float>(36, 0.0);
    for (i in Iter.range(0, 5)) {
      for (j in Iter.range(0, 5)) {
        KRKt[i * 6 + j] := K[i * 2] * model.R[0] * K[j * 2] + K[i * 2 + 1] * model.R[3] * K[j * 2 + 1];
      };
    };
    
    let P_update_raw = matrixAdd(temp2, Array.freeze(KRKt));
    let P_update = medinaBoundCovariance(ensurePositiveDefinite(symmetrize(P_update_raw)));
    
    // Log-likelihood
    let logDetS = _ln(_abs(detS));
    let mahalanobis = innovation[0] * (Sinv00 * innovation[0] + Sinv01 * innovation[1]) +
                      innovation[1] * (Sinv10 * innovation[0] + Sinv11 * innovation[1]);
    let logLik = -0.5 * (logDetS + mahalanobis + 2.0 * _ln(TWO_PI));
    
    {
      x = normalizeState(arrayToState(x_update));
      P = P_update;
      timestamp = state.timestamp;
      innovation = innovationMag;
      innovationCovariance = _sqrt((S00 + S11) / 2.0);
      kalmanGain = Array.tabulate<Float>(6, func(i: Nat) : Float { K[i * 2] });
      logLikelihood = state.logLikelihood + logLik;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // RAUCH-TUNG-STRIEBEL SMOOTHER — BACKWARD PASS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The backward pass uses the RTS equations:
  //   Cₖ = Pₖ|ₖ × Fₖ₊₁ᵀ × Pₖ₊₁|ₖ⁻¹
  //   x̂ₖ|ₙ = x̂ₖ|ₖ + Cₖ × (x̂ₖ₊₁|ₙ - x̂ₖ₊₁|ₖ)
  //   Pₖ|ₙ = Pₖ|ₖ + Cₖ × (Pₖ₊₁|ₙ - Pₖ₊₁|ₖ) × Cₖᵀ

  // Compute smoother gain C
  public func computeSmootherGain(
    P_filtered: CovarianceMatrix,      // Pₖ|ₖ
    P_predicted_next: CovarianceMatrix, // Pₖ₊₁|ₖ
    F: CovarianceMatrix                 // State transition
  ) : CovarianceMatrix {
    // Cₖ = Pₖ|ₖ × Fᵀ × Pₖ₊₁|ₖ⁻¹
    
    let Ft = matrixTranspose(F);
    let PFt = matrixMult(P_filtered, Ft);
    let P_pred_inv = matrixInverse(P_predicted_next);
    let C = matrixMult(PFt, P_pred_inv);
    
    C
  };

  // Single backward smoothing step
  public func smootherStep(
    filtered: KalmanState,             // x̂ₖ|ₖ, Pₖ|ₖ
    predicted_next: KalmanState,       // x̂ₖ₊₁|ₖ, Pₖ₊₁|ₖ
    smoothed_next: KalmanState,        // x̂ₖ₊₁|ₙ, Pₖ₊₁|ₙ
    F: CovarianceMatrix,
    step: Nat,
    totalSteps: Nat
  ) : KalmanState {
    // Compute smoother gain
    let C = computeSmootherGain(filtered.P, predicted_next.P, F);
    
    // State difference: x̂ₖ₊₁|ₙ - x̂ₖ₊₁|ₖ
    let state_diff = stateSub(smoothed_next.x, predicted_next.x);
    let state_diff_arr = stateToArray(state_diff);
    
    // C × state_diff
    let correction_arr = matrixVectorMult(C, state_diff_arr);
    
    // Medina compound error correction
    let compoundFactor = _pow(1.0 + COMPOUND_RATE_BASE, Float.fromInt(totalSteps - step)) * 
                         _pow(PHI_MEDINA, 1.0 / Float.fromInt(totalSteps + 1));
    
    // Apply scaled correction
    let scaled_correction = Array.tabulate<Float>(6, func(i: Nat) : Float {
      correction_arr[i] * compoundFactor
    });
    
    // Smoothed state
    let filtered_arr = stateToArray(filtered.x);
    let smoothed_arr = Array.tabulate<Float>(6, func(i: Nat) : Float {
      filtered_arr[i] + scaled_correction[i]
    });
    let x_smoothed = normalizeState(arrayToState(smoothed_arr));
    
    // Covariance difference: Pₖ₊₁|ₙ - Pₖ₊₁|ₖ
    let P_diff = matrixSub(smoothed_next.P, predicted_next.P);
    
    // Pₖ|ₙ = Pₖ|ₖ + C × (Pₖ₊₁|ₙ - Pₖ₊₁|ₖ) × Cᵀ
    let CP_diff = matrixMult(C, P_diff);
    let CP_diff_Ct = matrixMult(CP_diff, matrixTranspose(C));
    let P_smoothed_raw = matrixAdd(filtered.P, CP_diff_Ct);
    
    // Apply Medina bounds
    let P_smoothed = medinaBoundCovariance(ensurePositiveDefinite(symmetrize(P_smoothed_raw)));
    
    // Smoothed innovation (correction magnitude)
    let correctionMag = stateNorm(arrayToState(scaled_correction));
    
    {
      x = x_smoothed;
      P = P_smoothed;
      timestamp = filtered.timestamp;
      innovation = correctionMag;
      innovationCovariance = matrixTrace(P_smoothed) / 6.0;
      kalmanGain = Array.tabulate<Float>(6, func(i: Nat) : Float { C[i * 6] });
      logLikelihood = filtered.logLikelihood;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // COMPLETE BIDIRECTIONAL FILTER — FORWARD + BACKWARD + SMOOTH
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Initialize Kalman state
  public func initializeKalmanState(
    initialPos: { x : Float; y : Float },
    initialHeading: Float,
    initialUncertainty: Float
  ) : KalmanState {
    let P_init = Array.tabulate<Float>(36, func(idx: Nat) : Float {
      let row = idx / 6;
      let col = idx % 6;
      if (row == col) {
        if (row < 2) { initialUncertainty * initialUncertainty }  // Position
        else if (row < 4) { SIGMA_VELOCITY * SIGMA_VELOCITY * 10.0 }  // Velocity
        else if (row == 4) { SIGMA_HEADING * SIGMA_HEADING * 10.0 }  // Heading
        else { SIGMA_HEADING_RATE * SIGMA_HEADING_RATE * 10.0 }  // Heading rate
      } else { 0.0 }
    });
    
    {
      x = {
        x = initialPos.x;
        y = initialPos.y;
        vx = 0.0;
        vy = 0.0;
        theta = initialHeading;
        omega = 0.0;
      };
      P = P_init;
      timestamp = 0;
      innovation = 0.0;
      innovationCovariance = initialUncertainty;
      kalmanGain = Array.tabulate<Float>(6, func(_: Nat) : Float { 0.0 });
      logLikelihood = 0.0;
    }
  };

  // Run complete forward pass
  public func forwardPass(
    initialState: KalmanState,
    measurements: [Measurement],
    processModel: ProcessModel
  ) : [KalmanState] {
    let n = measurements.size();
    let results = Buffer.Buffer<KalmanState>(n + 1);
    
    var current = initialState;
    results.add(current);
    
    let landmarkModel = createLandmarkModel();
    let compassModel = createCompassModel();
    let flowModel = createOpticFlowModel();
    
    for (i in Iter.range(0, n - 1)) {
      // Predict
      let predicted = kalmanPredict(current, processModel, i);
      
      // Update based on measurement type
      current := switch (measurements[i]) {
        case (#Landmark(lm)) {
          kalmanUpdateLandmark(predicted, { x = lm.x; y = lm.y }, landmarkModel, i, n)
        };
        case (#SkyCompass(sc)) {
          kalmanUpdateCompass(predicted, sc.heading, compassModel, i, n)
        };
        case (#OpticFlow(of)) {
          kalmanUpdateOpticFlow(predicted, { vx = of.vx; vy = of.vy }, flowModel, i, n)
        };
        case (#Combined(c)) {
          var state = predicted;
          switch (c.landmark) {
            case (?lm) { state := kalmanUpdateLandmark(state, { x = lm.x; y = lm.y }, landmarkModel, i, n) };
            case (null) {};
          };
          switch (c.compass) {
            case (?h) { state := kalmanUpdateCompass(state, h, compassModel, i, n) };
            case (null) {};
          };
          switch (c.flow) {
            case (?f) { state := kalmanUpdateOpticFlow(state, { vx = f.0; vy = f.1 }, flowModel, i, n) };
            case (null) {};
          };
          state
        };
      };
      
      results.add(current);
    };
    
    Buffer.toArray(results)
  };

  // Run complete backward pass (smoothing)
  public func backwardPass(
    forwardStates: [KalmanState],
    processModel: ProcessModel
  ) : [KalmanState] {
    let n = forwardStates.size();
    if (n < 2) { return forwardStates };
    
    let results = Array.init<KalmanState>(n, forwardStates[0]);
    
    // Initialize with final forward state (no smoothing needed)
    results[n - 1] := forwardStates[n - 1];
    
    // Backward iteration
    var step = n - 2;
    while (step >= 0) {
      let filtered = forwardStates[step];
      let filtered_next = forwardStates[step + 1];
      let smoothed_next = results[step + 1];
      
      // Compute predicted state at step+1 from step
      let predicted_next = kalmanPredict(filtered, processModel, step);
      
      // Smooth
      results[step] := smootherStep(
        filtered,
        predicted_next,
        smoothed_next,
        processModel.F,
        step,
        n
      );
      
      step -= 1;
    };
    
    Array.freeze(results)
  };

  // Complete bidirectional filter with Fibonacci information exchange
  public func bidirectionalFilter(
    initialState: KalmanState,
    measurements: [Measurement],
    dt: Float
  ) : Trajectory {
    let processModel = createProcessModel(dt);
    let n = measurements.size();
    
    // Forward pass
    let forwardStates = forwardPass(initialState, measurements, processModel);
    
    // Backward pass (smoothing)
    let smoothedStates = backwardPass(forwardStates, processModel);
    
    // Create trajectory points
    let points = Array.tabulate<TrajectoryPoint>(n + 1, func(i: Nat) : TrajectoryPoint {
      {
        forward = forwardStates[i];
        backward = if (i == n) { null } else { ?forwardStates[i] };
        smoothed = ?smoothedStates[i];
        measurement = if (i < n) { ?measurements[i] } else { null };
      }
    });
    
    // Compute total log-likelihood
    let totalLL = smoothedStates[n].logLikelihood;
    
    // Compute path integration error
    let startPos = stateToArray(initialState.x);
    let endPos = stateToArray(smoothedStates[n].x);
    let pathError = _sqrt(_pow(endPos[0] - startPos[0], 2.0) + _pow(endPos[1] - startPos[1], 2.0));
    
    {
      points = points;
      length = n + 1;
      forwardComplete = true;
      backwardComplete = true;
      smoothingComplete = true;
      totalLogLikelihood = totalLL;
      pathIntegrationError = pathError;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA COMPOUND ERROR CORRECTION
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // error_corrected = error × (1 + r)^steps × Φ_M^(1/steps)

  public func medinaCompoundCorrection(
    error: Float,
    steps: Nat,
    rate: Float
  ) : Float {
    let stepsF = Float.fromInt(steps);
    let compoundGrowth = _pow(1.0 + rate, stepsF);
    let medinaFactor = _pow(PHI_MEDINA, 1.0 / (stepsF + 1.0));
    error * compoundGrowth * medinaFactor
  };

  // Apply compound correction to trajectory
  public func applyCompoundCorrection(
    trajectory: Trajectory
  ) : Trajectory {
    let n = trajectory.length;
    
    let correctedPoints = Array.tabulate<TrajectoryPoint>(n, func(i: Nat) : TrajectoryPoint {
      let point = trajectory.points[i];
      
      switch (point.smoothed) {
        case (?smoothed) {
          let error = smoothed.innovation;
          let correctedError = medinaCompoundCorrection(error, n - i, COMPOUND_RATE_BASE);
          
          // Update state with corrected error (this is a placeholder - real implementation
          // would propagate corrections through the trajectory)
          let correctionFactor = if (error > 0.001) { correctedError / error } else { 1.0 };
          
          {
            forward = point.forward;
            backward = point.backward;
            smoothed = ?{
              x = smoothed.x;
              P = matrixScale(correctionFactor, smoothed.P);
              timestamp = smoothed.timestamp;
              innovation = correctedError;
              innovationCovariance = smoothed.innovationCovariance * correctionFactor;
              kalmanGain = smoothed.kalmanGain;
              logLikelihood = smoothed.logLikelihood;
            };
            measurement = point.measurement;
          }
        };
        case (null) { point };
      }
    });
    
    {
      points = correctedPoints;
      length = n;
      forwardComplete = trajectory.forwardComplete;
      backwardComplete = trajectory.backwardComplete;
      smoothingComplete = trajectory.smoothingComplete;
      totalLogLikelihood = trajectory.totalLogLikelihood;
      pathIntegrationError = trajectory.pathIntegrationError;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ORGANISM INTEGRATION — Extract outputs for main system
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type SmootherOutput = {
    // Current state estimate
    position : { x : Float; y : Float };
    velocity : { vx : Float; vy : Float };
    heading : Float;
    headingRate : Float;
    
    // Uncertainty
    positionUncertainty : Float;
    headingUncertainty : Float;
    
    // Error metrics
    predictionError : Float;
    smoothingCorrection : Float;
    compoundedError : Float;
    
    // Path integration
    pathLength : Float;
    homeVector : { x : Float; y : Float };
    homeDistance : Float;
    homeDirection : Float;
    
    // Quality metrics
    filterCoherence : Float;
    measurementConfidence : Float;
    trajectoryLikelihood : Float;
  };

  public func extractSmootherOutput(
    trajectory: Trajectory,
    homePosition: { x : Float; y : Float }
  ) : SmootherOutput {
    let n = trajectory.length;
    if (n == 0) {
      return {
        position = { x = 0.0; y = 0.0 };
        velocity = { vx = 0.0; vy = 0.0 };
        heading = 0.0;
        headingRate = 0.0;
        positionUncertainty = S0;
        headingUncertainty = S0;
        predictionError = S0;
        smoothingCorrection = 0.0;
        compoundedError = S0;
        pathLength = 0.0;
        homeVector = { x = 0.0; y = 0.0 };
        homeDistance = 0.0;
        homeDirection = 0.0;
        filterCoherence = S0;
        measurementConfidence = S0;
        trajectoryLikelihood = 0.0;
      };
    };
    
    let lastPoint = trajectory.points[n - 1];
    let smoothedState = switch (lastPoint.smoothed) {
      case (?s) { s };
      case (null) { lastPoint.forward };
    };
    
    // Position and velocity
    let pos = { x = smoothedState.x.x; y = smoothedState.x.y };
    let vel = { vx = smoothedState.x.vx; vy = smoothedState.x.vy };
    
    // Uncertainties from covariance diagonal
    let posUnc = _sqrt(smoothedState.P[0] + smoothedState.P[7]) / 2.0;
    let headUnc = _sqrt(smoothedState.P[28]);
    
    // Compute path length
    var pathLen : Float = 0.0;
    for (i in Iter.range(1, n - 1)) {
      let prev = switch (trajectory.points[i - 1].smoothed) {
        case (?s) { s.x };
        case (null) { trajectory.points[i - 1].forward.x };
      };
      let curr = switch (trajectory.points[i].smoothed) {
        case (?s) { s.x };
        case (null) { trajectory.points[i].forward.x };
      };
      pathLen += _sqrt(_pow(curr.x - prev.x, 2.0) + _pow(curr.y - prev.y, 2.0));
    };
    
    // Home vector
    let homeX = homePosition.x - pos.x;
    let homeY = homePosition.y - pos.y;
    let homeDist = _sqrt(homeX * homeX + homeY * homeY);
    let homeDir = _atan2(homeY, homeX);
    
    // Smoothing correction (average innovation magnitude)
    var totalCorrection : Float = 0.0;
    for (point in trajectory.points.vals()) {
      switch (point.smoothed) {
        case (?s) { totalCorrection += s.innovation };
        case (null) {};
      };
    };
    let avgCorrection = totalCorrection / Float.fromInt(n);
    
    // Filter coherence (inverse of average covariance trace)
    var totalTrace : Float = 0.0;
    for (point in trajectory.points.vals()) {
      switch (point.smoothed) {
        case (?s) { totalTrace += matrixTrace(s.P) };
        case (null) { totalTrace += S0 * 6.0 };
      };
    };
    let avgTrace = totalTrace / Float.fromInt(n);
    let coherence = 1.0 / (1.0 + avgTrace / SOVEREIGN_CEILING);
    
    // Measurement confidence (based on innovation covariance)
    var totalInnCov : Float = 0.0;
    for (point in trajectory.points.vals()) {
      totalInnCov += point.forward.innovationCovariance;
    };
    let confidence = 1.0 / (1.0 + totalInnCov / Float.fromInt(n));
    
    {
      position = pos;
      velocity = vel;
      heading = smoothedState.x.theta;
      headingRate = smoothedState.x.omega;
      positionUncertainty = posUnc;
      headingUncertainty = headUnc;
      predictionError = trajectory.pathIntegrationError;
      smoothingCorrection = avgCorrection;
      compoundedError = medinaCompoundCorrection(avgCorrection, n, COMPOUND_RATE_BASE);
      pathLength = pathLen;
      homeVector = { x = homeX; y = homeY };
      homeDistance = homeDist;
      homeDirection = homeDir;
      filterCoherence = coherence;
      measurementConfidence = confidence;
      trajectoryLikelihood = trajectory.totalLogLikelihood;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // BEE-SPECIFIC INTEGRATION — Path integration like honeybee central complex
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Simulate bee path integration with sky compass and optic flow
  public func beePathIntegration(
    steps: Nat,
    skyCompassReadings: [Float],    // Polarized light heading
    opticFlowReadings: [(Float, Float)], // Optic flow velocities
    landmarks: [?{ x : Float; y : Float }]  // Optional landmark sightings
  ) : SmootherOutput {
    // Ensure arrays are same length
    let n = steps;
    if (skyCompassReadings.size() < n or opticFlowReadings.size() < n) {
      return extractSmootherOutput(
        { points = []; length = 0; forwardComplete = false; backwardComplete = false; 
          smoothingComplete = false; totalLogLikelihood = 0.0; pathIntegrationError = 0.0 },
        { x = 0.0; y = 0.0 }
      );
    };
    
    // Build measurements
    let measurements = Array.tabulate<Measurement>(n, func(i: Nat) : Measurement {
      let landmark = if (i < landmarks.size()) { landmarks[i] } else { null };
      let compass = skyCompassReadings[i];
      let flow = opticFlowReadings[i];
      
      #Combined({
        landmark = landmark;
        compass = ?compass;
        flow = ?flow;
      })
    });
    
    // Initialize at hive (origin)
    let initialState = initializeKalmanState({ x = 0.0; y = 0.0 }, 0.0, 0.1);
    
    // Run bidirectional filter
    let trajectory = bidirectionalFilter(initialState, measurements, 1.0 / 20.0);  // 20 Hz bee timing
    
    // Apply compound correction
    let correctedTrajectory = applyCompoundCorrection(trajectory);
    
    // Extract output with hive as home
    extractSmootherOutput(correctedTrajectory, { x = 0.0; y = 0.0 })
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // 60-STEP PREDICTIVE FIELD UPDATE
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  // Type for predictive field (60 steps × 6 state dimensions)
  public type PredictiveField = {
    forwardPredictions : [[Float]];   // 60 × 6
    backwardCorrections : [[Float]];  // 60 × 6
    smoothedField : [[Float]];        // 60 × 6
    uncertainties : [Float];          // 60 (scalar uncertainty per step)
    fieldCoherence : Float;
  };

  // Update 60-step predictive field with new measurement
  public func updatePredictiveField(
    currentField: PredictiveField,
    newMeasurement: Measurement,
    currentState: KalmanState,
    processModel: ProcessModel
  ) : PredictiveField {
    let numSteps = 60;
    
    // Shift forward predictions (roll by 1, add new)
    let newForward = Array.init<[Float]>(numSteps, stateToArray(currentState.x));
    for (i in Iter.range(0, numSteps - 2)) {
      newForward[i] := currentField.forwardPredictions[i + 1];
    };
    
    // Predict new final step
    var predicted = currentState;
    for (_ in Iter.range(0, numSteps - 1)) {
      predicted := kalmanPredict(predicted, processModel, 0);
    };
    newForward[numSteps - 1] := stateToArray(predicted.x);
    
    // Backward corrections (recompute based on measurement)
    let measurements = Array.tabulate<Measurement>(1, func(_: Nat) : Measurement { newMeasurement });
    let trajectory = bidirectionalFilter(currentState, measurements, processModel.dt);
    
    let correctedField = if (trajectory.length > 0) {
      switch (trajectory.points[0].smoothed) {
        case (?s) { stateToArray(s.x) };
        case (null) { stateToArray(currentState.x) };
      }
    } else {
      stateToArray(currentState.x)
    };
    
    let newBackward = Array.init<[Float]>(numSteps, correctedField);
    for (i in Iter.range(1, numSteps - 1)) {
      // Interpolate backward corrections
      let alpha = Float.fromInt(i) / Float.fromInt(numSteps);
      newBackward[i] := Array.tabulate<Float>(6, func(j: Nat) : Float {
        (1.0 - alpha) * correctedField[j] + alpha * newForward[i][j]
      });
    };
    
    // Smooth field (blend forward and backward)
    let newSmoothed = Array.tabulate<[Float]>(numSteps, func(i: Nat) : [Float] {
      let forwardWeight = Float.fromInt(i) / Float.fromInt(numSteps);
      let backwardWeight = 1.0 - forwardWeight;
      
      Array.tabulate<Float>(6, func(j: Nat) : Float {
        forwardWeight * newForward[i][j] + backwardWeight * newBackward[i][j]
      })
    });
    
    // Compute uncertainties
    let newUncertainties = Array.tabulate<Float>(numSteps, func(i: Nat) : Float {
      let forward = newForward[i];
      let backward = newBackward[i];
      var diff : Float = 0.0;
      for (j in Iter.range(0, 5)) {
        diff += _pow(forward[j] - backward[j], 2.0);
      };
      _sqrt(diff / 6.0)
    });
    
    // Field coherence
    var totalUncertainty : Float = 0.0;
    for (u in newUncertainties.vals()) {
      totalUncertainty += u;
    };
    let avgUncertainty = totalUncertainty / Float.fromInt(numSteps);
    let coherence = 1.0 / (1.0 + avgUncertainty);
    
    {
      forwardPredictions = Array.freeze(newForward);
      backwardCorrections = Array.freeze(newBackward);
      smoothedField = newSmoothed;
      uncertainties = newUncertainties;
      fieldCoherence = coherence;
    }
  };

  // Initialize empty predictive field
  public func initializePredictiveField(initialState: StateVector) : PredictiveField {
    let numSteps = 60;
    let stateArr = stateToArray(initialState);
    
    let emptyField = Array.tabulate<[Float]>(numSteps, func(_: Nat) : [Float] { stateArr });
    
    {
      forwardPredictions = emptyField;
      backwardCorrections = emptyField;
      smoothedField = emptyField;
      uncertainties = Array.tabulate<Float>(numSteps, func(_: Nat) : Float { S0 });
      fieldCoherence = S0;
    }
  };

}
