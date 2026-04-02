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
// VELA TIER SYSTEM — PREDICTIVE DIMENSION HIERARCHY
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — VELA Predictive Tiers
//
// VELA: World Model Accuracy + Prediction Confidence
// Tiers T10 → T50 with exponential rewards
//
// T10: Base tier         — 1.0x multiplier, basic access
// T20: Emerging tier     — 2.0x multiplier, enhanced feeds
// T30: Established tier  — 4.0x multiplier, priority routing
// T40: Elite tier        — 8.0x multiplier, governance weight
// T50: Sovereign tier    — 16.0x multiplier, full autonomy
//
// Each tier requires sustained performance across multiple dimensions:
// - Prediction accuracy over 60-step horizon
// - Free energy minimization streaks
// - Coherence maintenance
// - Quantum operator alignment
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";

module VELATierSystem {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — TIER THRESHOLDS & REWARDS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  public let EULER : Float = 2.7182818284590452354;
  
  // Tier thresholds (cumulative VELA score required)
  public let T10_THRESHOLD : Float = 0.50;    // Base tier
  public let T20_THRESHOLD : Float = 0.65;    // Emerging
  public let T30_THRESHOLD : Float = 0.78;    // Established
  public let T40_THRESHOLD : Float = 0.88;    // Elite
  public let T50_THRESHOLD : Float = 0.95;    // Sovereign
  
  // Tier reward multipliers (exponential)
  public let T10_MULTIPLIER : Float = 1.0;
  public let T20_MULTIPLIER : Float = 2.0;
  public let T30_MULTIPLIER : Float = 4.0;
  public let T40_MULTIPLIER : Float = 8.0;
  public let T50_MULTIPLIER : Float = 16.0;
  
  // Streak requirements for tier advancement
  public let STREAK_FOR_T20 : Nat = 50;     // 50 beats sustained
  public let STREAK_FOR_T30 : Nat = 100;    // 100 beats sustained
  public let STREAK_FOR_T40 : Nat = 200;    // 200 beats sustained
  public let STREAK_FOR_T50 : Nat = 500;    // 500 beats sustained

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — VELA STATE STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════

  public type VELATier = {
    #T10;  // Base
    #T20;  // Emerging
    #T30;  // Established
    #T40;  // Elite
    #T50;  // Sovereign
  };

  public type VELAScoreComponents = {
    predictionAccuracy    : Float;   // 60-step prediction vs actual
    freeEnergyDelta       : Float;   // Negative = good (minimizing)
    coherenceLevel        : Float;   // Shell 12 coherence
    quantumAlignment      : Float;   // QSOV score
    animalIntegration     : Float;   // Gen 3 animal contribution
    territoryControl      : Float;   // ATLAS sovereignty fraction
  };

  public type VELAState = {
    currentTier           : VELATier;
    compositeScore        : Float;     // Weighted average of components
    components            : VELAScoreComponents;
    streakAtCurrentTier   : Nat;       // Beats at current tier
    tierAdvancementReady  : Bool;      // Qualified for next tier
    historicalPeak        : Float;     // Highest score achieved
    tierMultiplier        : Float;     // Current reward multiplier
    lastEvaluation        : Nat;       // Beat of last evaluation
    tierHistory           : [VELATier]; // Last 10 tiers (for volatility)
  };

  public type VELAMetrics = {
    predictionBuffer      : [Float];   // 60-step prediction buffer
    actualBuffer          : [Float];   // 60-step actual values
    errorHistory          : [Float];   // Last 100 prediction errors
    confidenceInterval    : Float;     // 95% CI width
    trendSlope            : Float;     // Linear trend in score
    volatility            : Float;     // Standard deviation of score
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH: TIER EVALUATION
  // ═══════════════════════════════════════════════════════════════════════════

  func abs(x : Float) : Float {
    if (x < 0.0) -x else x
  };

  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 10) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };

  func exp(x : Float) : Float {
    let clamped = clamp(x, -20.0, 20.0);
    var result = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 20) {
      term := term * clamped / Float.fromInt(n);
      result := result + term;
      n += 1;
    };
    result
  };

  // Compute VELA composite score from components
  // Weighted geometric mean for multiplicative scaling
  public func computeCompositeScore(components : VELAScoreComponents) : Float {
    // Weights: Prediction accuracy weighted highest
    let w_pred = 0.30;    // 30% weight
    let w_fe   = 0.20;    // 20% weight (free energy)
    let w_coh  = 0.15;    // 15% weight (coherence)
    let w_qsov = 0.15;    // 15% weight (quantum alignment)
    let w_anim = 0.10;    // 10% weight (animal integration)
    let w_terr = 0.10;    // 10% weight (territory)
    
    // Normalize free energy delta to [0,1] (negative is better)
    // ΔF ∈ [-0.1, 0.1] → score ∈ [0, 1]
    let feScore = clamp(0.5 - 5.0 * components.freeEnergyDelta, 0.0, 1.0);
    
    // Clamp all components
    let pred = clamp(components.predictionAccuracy, 0.0, 1.0);
    let coh = clamp(components.coherenceLevel, 0.0, 1.0);
    let qsov = clamp(components.quantumAlignment, 0.0, 2.0) / 2.0; // QSOV max is 2.0
    let anim = clamp(components.animalIntegration, 0.0, 1.0);
    let terr = clamp(components.territoryControl, 0.0, 1.0);
    
    // Geometric mean: (∏ x_i^w_i)
    // Using log for stability: exp(Σ w_i × log(x_i + ε))
    let epsilon = 0.001;
    
    let logSum = w_pred * Float.log(pred + epsilon) +
                 w_fe * Float.log(feScore + epsilon) +
                 w_coh * Float.log(coh + epsilon) +
                 w_qsov * Float.log(qsov + epsilon) +
                 w_anim * Float.log(anim + epsilon) +
                 w_terr * Float.log(terr + epsilon);
    
    exp(logSum)
  };

  // Determine tier from composite score
  public func scoreToTier(score : Float) : VELATier {
    if (score >= T50_THRESHOLD) #T50
    else if (score >= T40_THRESHOLD) #T40
    else if (score >= T30_THRESHOLD) #T30
    else if (score >= T20_THRESHOLD) #T20
    else #T10
  };

  // Get multiplier for tier
  public func tierMultiplier(tier : VELATier) : Float {
    switch (tier) {
      case (#T10) T10_MULTIPLIER;
      case (#T20) T20_MULTIPLIER;
      case (#T30) T30_MULTIPLIER;
      case (#T40) T40_MULTIPLIER;
      case (#T50) T50_MULTIPLIER;
    }
  };

  // Get streak requirement for tier
  public func streakRequired(tier : VELATier) : Nat {
    switch (tier) {
      case (#T10) 0;
      case (#T20) STREAK_FOR_T20;
      case (#T30) STREAK_FOR_T30;
      case (#T40) STREAK_FOR_T40;
      case (#T50) STREAK_FOR_T50;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH: PREDICTION ACCURACY
  // ═══════════════════════════════════════════════════════════════════════════

  // Mean Absolute Error (MAE) of predictions
  public func computePredictionError(
    predictions : [Float],
    actuals     : [Float]
  ) : Float {
    let n = Nat.min(predictions.size(), actuals.size());
    if (n == 0) return 1.0;
    
    var sumError = 0.0;
    var i = 0;
    while (i < n) {
      sumError += abs(predictions[i] - actuals[i]);
      i += 1;
    };
    
    sumError / Float.fromInt(n)
  };

  // Convert error to accuracy [0, 1]
  // Using exponential decay: accuracy = exp(-k × MAE)
  public func errorToAccuracy(mae : Float) : Float {
    let k = 5.0; // Scaling factor
    exp(-k * mae)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH: VOLATILITY & CONFIDENCE
  // ═══════════════════════════════════════════════════════════════════════════

  // Compute rolling standard deviation
  public func computeVolatility(history : [Float]) : Float {
    let n = history.size();
    if (n < 2) return 0.0;
    
    // Mean
    var sum = 0.0;
    var i = 0;
    while (i < n) {
      sum += history[i];
      i += 1;
    };
    let mean = sum / Float.fromInt(n);
    
    // Variance
    var sumSq = 0.0;
    i := 0;
    while (i < n) {
      let d = history[i] - mean;
      sumSq += d * d;
      i += 1;
    };
    
    sqrt(sumSq / Float.fromInt(n - 1))
  };

  // Compute 95% confidence interval width
  // CI = ± 1.96 × σ / √n
  public func computeConfidenceInterval(history : [Float]) : Float {
    let n = history.size();
    if (n < 2) return 1.0;
    
    let sigma = computeVolatility(history);
    1.96 * sigma / sqrt(Float.fromInt(n))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  public func initVELAState() : VELAState {
    {
      currentTier = #T10;
      compositeScore = 0.5;
      components = {
        predictionAccuracy = 0.5;
        freeEnergyDelta = 0.0;
        coherenceLevel = 0.5;
        quantumAlignment = 1.0;
        animalIntegration = 0.5;
        territoryControl = 0.5;
      };
      streakAtCurrentTier = 0;
      tierAdvancementReady = false;
      historicalPeak = 0.5;
      tierMultiplier = 1.0;
      lastEvaluation = 0;
      tierHistory = [];
    }
  };

  public func initVELAMetrics() : VELAMetrics {
    {
      predictionBuffer = Array.freeze(Array.init<Float>(60, 0.5));
      actualBuffer = Array.freeze(Array.init<Float>(60, 0.5));
      errorHistory = [];
      confidenceInterval = 1.0;
      trendSlope = 0.0;
      volatility = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN EVALUATION FUNCTION
  // ═══════════════════════════════════════════════════════════════════════════

  public func evaluateVELA(
    state    : VELAState,
    metrics  : VELAMetrics,
    newComponents : VELAScoreComponents,
    currentBeat : Nat
  ) : (VELAState, VELAMetrics) {
    
    // Compute new composite score
    let newScore = computeCompositeScore(newComponents);
    
    // Determine tier from score
    let newTier = scoreToTier(newScore);
    
    // Update streak
    let (newStreak, advancementReady) = if (tierEqual(newTier, state.currentTier)) {
      let streak = state.streakAtCurrentTier + 1;
      (streak, streak >= streakRequired(nextTier(newTier)))
    } else if (tierGreater(newTier, state.currentTier)) {
      // Promoted to higher tier
      (1, false)
    } else {
      // Demoted (reset streak)
      (1, false)
    };
    
    // Update historical peak
    let newPeak = Float.max(state.historicalPeak, newScore);
    
    // Update tier history (keep last 10)
    let newHistory = if (state.tierHistory.size() >= 10) {
      let shifted = Array.tabulate<VELATier>(9, func(i) = state.tierHistory[i + 1]);
      Array.append(shifted, [newTier])
    } else {
      Array.append(state.tierHistory, [newTier])
    };
    
    // Compute new metrics
    let mae = computePredictionError(metrics.predictionBuffer, metrics.actualBuffer);
    let acc = errorToAccuracy(mae);
    
    // Update error history
    let newErrorHistory = if (metrics.errorHistory.size() >= 100) {
      let shifted = Array.tabulate<Float>(99, func(i) = metrics.errorHistory[i + 1]);
      Array.append(shifted, [mae])
    } else {
      Array.append(metrics.errorHistory, [mae])
    };
    
    let newState : VELAState = {
      currentTier = newTier;
      compositeScore = newScore;
      components = newComponents;
      streakAtCurrentTier = newStreak;
      tierAdvancementReady = advancementReady;
      historicalPeak = newPeak;
      tierMultiplier = tierMultiplier(newTier);
      lastEvaluation = currentBeat;
      tierHistory = newHistory;
    };
    
    let newMetrics : VELAMetrics = {
      predictionBuffer = metrics.predictionBuffer;
      actualBuffer = metrics.actualBuffer;
      errorHistory = newErrorHistory;
      confidenceInterval = computeConfidenceInterval(newErrorHistory);
      trendSlope = computeTrendSlope(newErrorHistory);
      volatility = computeVolatility(newErrorHistory);
    };
    
    (newState, newMetrics)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  func tierEqual(a : VELATier, b : VELATier) : Bool {
    switch (a, b) {
      case (#T10, #T10) true;
      case (#T20, #T20) true;
      case (#T30, #T30) true;
      case (#T40, #T40) true;
      case (#T50, #T50) true;
      case _ false;
    }
  };

  func tierGreater(a : VELATier, b : VELATier) : Bool {
    tierToNat(a) > tierToNat(b)
  };

  func tierToNat(t : VELATier) : Nat {
    switch (t) {
      case (#T10) 10;
      case (#T20) 20;
      case (#T30) 30;
      case (#T40) 40;
      case (#T50) 50;
    }
  };

  func nextTier(t : VELATier) : VELATier {
    switch (t) {
      case (#T10) #T20;
      case (#T20) #T30;
      case (#T30) #T40;
      case (#T40) #T50;
      case (#T50) #T50;
    }
  };

  // Linear trend slope using least squares
  func computeTrendSlope(history : [Float]) : Float {
    let n = history.size();
    if (n < 2) return 0.0;
    
    // Least squares: slope = (n×Σxy - Σx×Σy) / (n×Σx² - (Σx)²)
    var sumX = 0.0;
    var sumY = 0.0;
    var sumXY = 0.0;
    var sumX2 = 0.0;
    
    var i = 0;
    while (i < n) {
      let x = Float.fromInt(i);
      let y = history[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    
    let nf = Float.fromInt(n);
    let denom = nf * sumX2 - sumX * sumX;
    if (abs(denom) < 0.0001) return 0.0;
    
    (nf * sumXY - sumX * sumY) / denom
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // REWARD CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  // Calculate token reward based on tier
  public func calculateTierReward(
    baseReward : Float,
    tier       : VELATier,
    streak     : Nat
  ) : Float {
    let mult = tierMultiplier(tier);
    
    // Streak bonus: +1% per 10 beats, max +20%
    let streakBonus = Float.min(0.20, Float.fromInt(streak / 10) * 0.01);
    
    baseReward * mult * (1.0 + streakBonus)
  };

  // Calculate governance weight based on tier
  public func governanceWeight(tier : VELATier) : Float {
    switch (tier) {
      case (#T10) 0.1;    // Minimal voice
      case (#T20) 0.5;    // Emerging voice
      case (#T30) 1.0;    // Full voice
      case (#T40) 2.0;    // Enhanced voice
      case (#T50) 5.0;    // Sovereign voice
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TIER SUMMARY FOR EXTERNAL CONSUMPTION
  // ═══════════════════════════════════════════════════════════════════════════

  public type VELASummary = {
    tier        : Text;
    score       : Float;
    multiplier  : Float;
    streak      : Nat;
    confidence  : Float;
    nextTierIn  : Nat;     // Beats until next tier eligible
    peakScore   : Float;
  };

  public func summarize(state : VELAState, metrics : VELAMetrics) : VELASummary {
    let tierText = switch (state.currentTier) {
      case (#T10) "T10-BASE";
      case (#T20) "T20-EMERGING";
      case (#T30) "T30-ESTABLISHED";
      case (#T40) "T40-ELITE";
      case (#T50) "T50-SOVEREIGN";
    };
    
    let required = streakRequired(nextTier(state.currentTier));
    let remaining = if (state.streakAtCurrentTier >= required) 0
                    else required - state.streakAtCurrentTier;
    
    {
      tier = tierText;
      score = state.compositeScore;
      multiplier = state.tierMultiplier;
      streak = state.streakAtCurrentTier;
      confidence = 1.0 - metrics.confidenceInterval;
      nextTierIn = remaining;
      peakScore = state.historicalPeak;
    }
  };

}
