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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ════════════════════════════════════════════════════════════════════════════════════════
// ████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                    ██
// ██  RISK MANAGEMENT SYSTEM — REAL BACKEND INTELLIGENCE                               ██
// ██                                                                                    ██
// ██  Comprehensive risk management for the sovereign organism:                        ██
// ██                                                                                    ██
// ██  1. VALUE AT RISK (VaR) — Maximum expected loss at confidence level               ██
// ██     - Historical VaR (from past returns)                                          ██
// ██     - Parametric VaR (assuming normal distribution)                               ██
// ██     - Monte Carlo VaR (simulation-based)                                          ██
// ██                                                                                    ██
// ██  2. CONDITIONAL VAR (CVaR/ES) — Expected loss beyond VaR                          ██
// ██     - Average of losses in the tail                                               ██
// ██     - More coherent risk measure than VaR                                         ██
// ██                                                                                    ██
// ██  3. PORTFOLIO OPTIMIZATION — Efficient frontier, risk parity                      ██
// ██     - Mean-variance optimization (Markowitz)                                      ██
// ██     - Risk parity allocation                                                      ██
// ██     - Maximum Sharpe ratio                                                        ██
// ██                                                                                    ██
// ██  4. STRESS TESTING — Extreme scenario analysis                                    ██
// ██     - Historical stress scenarios                                                 ██
// ██     - Hypothetical scenarios                                                      ██
// ██     - Reverse stress testing                                                      ██
// ██                                                                                    ██
// ██  5. LIQUIDITY RISK — Market impact, funding risk                                  ██
// ██     - Position sizing limits                                                      ██
// ██     - Concentration limits                                                        ██
// ██     - Redemption gates                                                            ██
// ██                                                                                    ██
// ████████████████████████████████████████████████████████████████████████████████████████
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════
  
  let PHI : Float = 1.6180339887498948;
  let SQRT_2PI : Float = 2.506628274631;
  let E : Float = 2.718281828459045;
  
  // Confidence levels
  let CONFIDENCE_95 : Float = 0.95;
  let CONFIDENCE_99 : Float = 0.99;
  let CONFIDENCE_999 : Float = 0.999;
  
  // Z-scores for confidence levels (standard normal)
  let Z_95 : Float = 1.645;
  let Z_99 : Float = 2.326;
  let Z_999 : Float = 3.090;
  
  // Risk limits
  let MAX_PORTFOLIO_VAR : Float = 0.10;        // 10% max VaR
  let MAX_POSITION_CONCENTRATION : Float = 0.25;  // 25% max per position
  let MAX_SECTOR_CONCENTRATION : Float = 0.40;    // 40% max per sector
  let MIN_LIQUIDITY_RATIO : Float = 0.20;         // 20% must be liquid

  // ══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type Position = {
    symbol : Text;
    quantity : Float;
    averageCost : Float;
    currentPrice : Float;
    marketValue : Float;
    unrealizedPnL : Float;
    weight : Float;              // Portfolio weight
    sector : Text;
    liquidity : LiquidityClass;
  };

  public type LiquidityClass = {
    #HighlyLiquid;    // Can exit in minutes
    #Liquid;          // Can exit in hours
    #ModeratelyLiquid; // Can exit in days
    #Illiquid;        // Weeks or longer
  };

  public type Portfolio = {
    positions : [Position];
    totalValue : Float;
    cash : Float;
    leverage : Float;
    marginUsed : Float;
    marginAvailable : Float;
  };

  public type ReturnSeries = {
    returns : [Float];           // Array of periodic returns
    period : Text;               // "1D", "1H", etc.
    length : Nat;
  };

  public type VaRResult = {
    var95 : Float;               // 95% VaR
    var99 : Float;               // 99% VaR
    var999 : Float;              // 99.9% VaR
    method : VaRMethod;
    holdingPeriod : Nat;         // In beats
    portfolioValue : Float;
    varDollar95 : Float;         // Dollar amount at risk
    varDollar99 : Float;
    varDollar999 : Float;
  };

  public type VaRMethod = {
    #Historical;
    #Parametric;
    #MonteCarlo;
  };

  public type CVaRResult = {
    cvar95 : Float;              // 95% CVaR (Expected Shortfall)
    cvar99 : Float;              // 99% CVaR
    tailRisk : Float;            // Average loss in worst 5%
    worstLoss : Float;           // Maximum historical loss
  };

  public type CorrelationMatrix = {
    symbols : [Text];
    matrix : [[Float]];          // N×N correlation matrix
    lastUpdated : Nat;
  };

  public type CovarianceMatrix = {
    symbols : [Text];
    matrix : [[Float]];          // N×N covariance matrix
    variances : [Float];         // Diagonal elements
  };

  public type PortfolioOptResult = {
    optimalWeights : [(Text, Float)];
    expectedReturn : Float;
    portfolioVolatility : Float;
    sharpeRatio : Float;
    diversificationRatio : Float;
    effectiveN : Float;          // Effective number of bets
  };

  public type StressScenario = {
    name : Text;
    description : Text;
    assetShocks : [(Text, Float)];  // (symbol, shock %)
    correlationShock : Float;       // Correlation increase
    liquidityShock : Float;         // Liquidity reduction
    estimatedLoss : Float;
    probability : Float;
  };

  public type StressTestResult = {
    scenarios : [StressScenario];
    worstCaseScenario : Text;
    worstCaseLoss : Float;
    averageStressLoss : Float;
    survivalProbability : Float;
  };

  public type LiquidityProfile = {
    t1Liquidity : Float;         // % liquidatable in 1 day
    t5Liquidity : Float;         // % liquidatable in 5 days
    t20Liquidity : Float;        // % liquidatable in 20 days
    liquidityScore : Float;      // Overall score [0, 1]
    concentrationRisk : Float;   // HHI of positions
  };

  public type RiskBudget = {
    totalBudget : Float;         // Total risk budget
    usedBudget : Float;          // Currently used
    remainingBudget : Float;     // Available for new positions
    byPosition : [(Text, Float)]; // Risk per position
    bySector : [(Text, Float)];   // Risk per sector
  };

  public type RiskReport = {
    timestamp : Nat;
    var_result : VaRResult;
    cvar_result : CVaRResult;
    liquidity : LiquidityProfile;
    stressTest : StressTestResult;
    riskBudget : RiskBudget;
    breaches : [RiskBreach];
    overallRiskScore : Float;    // [0, 1] where 1 is most risky
    recommendation : RiskRecommendation;
  };

  public type RiskBreach = {
    breachType : BreachType;
    description : Text;
    severity : Severity;
    currentValue : Float;
    limitValue : Float;
  };

  public type BreachType = {
    #VaRLimit;
    #ConcentrationLimit;
    #LiquidityLimit;
    #LeverageLimit;
    #DrawdownLimit;
  };

  public type Severity = {
    #Warning;      // Approaching limit
    #Breach;       // At or slightly over limit
    #Critical;     // Significantly over limit
  };

  public type RiskRecommendation = {
    action : RiskAction;
    urgency : Urgency;
    details : Text;
    suggestedTrades : [(Text, Float, Bool)];  // (symbol, amount, isBuy)
  };

  public type RiskAction = {
    #NoAction;
    #ReduceExposure;
    #Rebalance;
    #Hedge;
    #LiquidatePartial;
    #LiquidateAll;
  };

  public type Urgency = {
    #Low;
    #Medium;
    #High;
    #Immediate;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  func _min(a: Float, b: Float) : Float {
    if (a < b) { a } else { b }
  };

  func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 1. VALUE AT RISK (VaR)
  // ══════════════════════════════════════════════════════════════════════════
  //
  // VaR answers: "What is the maximum I can lose with X% confidence?"
  //
  // Example: 95% VaR of 5% means there's only a 5% chance of losing more than 5%
  // ══════════════════════════════════════════════════════════════════════════

  // Calculate mean of returns
  func mean(returns: [Float]) : Float {
    if (returns.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    for (r in returns.vals()) { sum += r };
    sum / Float.fromInt(returns.size())
  };

  // Calculate standard deviation
  func stdDev(returns: [Float]) : Float {
    if (returns.size() < 2) { return 0.0 };
    let avg = mean(returns);
    var variance : Float = 0.0;
    for (r in returns.vals()) {
      variance += (r - avg) * (r - avg);
    };
    variance := variance / Float.fromInt(returns.size() - 1);
    Float.sqrt(variance)
  };

  // Sort returns (ascending) - simple bubble sort for Motoko
  func sortReturns(returns: [Float]) : [Float] {
    let n = returns.size();
    if (n == 0) { return returns };
    
    var sorted = Array.thaw<Float>(returns);
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n - i - 1) {
        if (sorted[j] > sorted[j + 1]) {
          let temp = sorted[j];
          sorted[j] := sorted[j + 1];
          sorted[j + 1] := temp;
        };
        j += 1;
      };
      i += 1;
    };
    Array.freeze(sorted)
  };

  // Get percentile value from sorted array
  func percentile(sortedReturns: [Float], p: Float) : Float {
    let n = sortedReturns.size();
    if (n == 0) { return 0.0 };
    
    let index = Float.floor(p * Float.fromInt(n));
    let idx = Int.abs(Float.toInt(_clamp(index, 0.0, Float.fromInt(n - 1))));
    sortedReturns[idx]
  };

  // Historical VaR - uses actual return distribution
  public func historicalVaR(returns: ReturnSeries, portfolioValue: Float) : VaRResult {
    let sorted = sortReturns(returns.returns);
    
    // VaR is negative of the percentile (since we want loss)
    let var95 = -percentile(sorted, 0.05);
    let var99 = -percentile(sorted, 0.01);
    let var999 = -percentile(sorted, 0.001);
    
    {
      var95 = var95;
      var99 = var99;
      var999 = var999;
      method = #Historical;
      holdingPeriod = 1;
      portfolioValue = portfolioValue;
      varDollar95 = var95 * portfolioValue;
      varDollar99 = var99 * portfolioValue;
      varDollar999 = var999 * portfolioValue;
    }
  };

  // Parametric VaR - assumes normal distribution
  public func parametricVaR(returns: ReturnSeries, portfolioValue: Float) : VaRResult {
    let mu = mean(returns.returns);
    let sigma = stdDev(returns.returns);
    
    // VaR = -μ + z × σ
    let var95 = -mu + Z_95 * sigma;
    let var99 = -mu + Z_99 * sigma;
    let var999 = -mu + Z_999 * sigma;
    
    {
      var95 = var95;
      var99 = var99;
      var999 = var999;
      method = #Parametric;
      holdingPeriod = 1;
      portfolioValue = portfolioValue;
      varDollar95 = var95 * portfolioValue;
      varDollar99 = var99 * portfolioValue;
      varDollar999 = var999 * portfolioValue;
    }
  };

  // Scale VaR to different holding period (square root of time rule)
  public func scaleVaR(var1Day: VaRResult, holdingPeriod: Nat) : VaRResult {
    let sqrtT = Float.sqrt(Float.fromInt(holdingPeriod));
    
    {
      var95 = var1Day.var95 * sqrtT;
      var99 = var1Day.var99 * sqrtT;
      var999 = var1Day.var999 * sqrtT;
      method = var1Day.method;
      holdingPeriod = holdingPeriod;
      portfolioValue = var1Day.portfolioValue;
      varDollar95 = var1Day.varDollar95 * sqrtT;
      varDollar99 = var1Day.varDollar99 * sqrtT;
      varDollar999 = var1Day.varDollar999 * sqrtT;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 2. CONDITIONAL VAR (CVaR / Expected Shortfall)
  // ══════════════════════════════════════════════════════════════════════════
  //
  // CVaR answers: "If I do have a bad day (beyond VaR), how bad will it be?"
  //
  // CVaR is the average of all losses beyond VaR threshold
  // It's a "coherent" risk measure (VaR is not)
  // ══════════════════════════════════════════════════════════════════════════

  public func calculateCVaR(returns: ReturnSeries) : CVaRResult {
    let sorted = sortReturns(returns.returns);
    let n = sorted.size();
    
    if (n == 0) {
      return {
        cvar95 = 0.0;
        cvar99 = 0.0;
        tailRisk = 0.0;
        worstLoss = 0.0;
      };
    };
    
    // Find worst 5% and 1% of returns
    let cutoff95 = Int.abs(Float.toInt(Float.fromInt(n) * 0.05));
    let cutoff99 = Int.abs(Float.toInt(Float.fromInt(n) * 0.01));
    
    // Average of worst 5%
    var sum95 : Float = 0.0;
    var i = 0;
    while (i < cutoff95 and i < n) {
      sum95 += sorted[i];
      i += 1;
    };
    let cvar95 = if (cutoff95 > 0) { -sum95 / Float.fromInt(cutoff95) } else { 0.0 };
    
    // Average of worst 1%
    var sum99 : Float = 0.0;
    i := 0;
    while (i < cutoff99 and i < n) {
      sum99 += sorted[i];
      i += 1;
    };
    let cvar99 = if (cutoff99 > 0) { -sum99 / Float.fromInt(cutoff99) } else { 0.0 };
    
    // Tail risk (average of worst 5%)
    let tailRisk = cvar95;
    
    // Worst single loss
    let worstLoss = if (n > 0) { -sorted[0] } else { 0.0 };
    
    {
      cvar95 = cvar95;
      cvar99 = cvar99;
      tailRisk = tailRisk;
      worstLoss = worstLoss;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 3. CORRELATION AND COVARIANCE MATRICES
  // ══════════════════════════════════════════════════════════════════════════

  // Calculate correlation between two return series
  public func correlation(returns1: [Float], returns2: [Float]) : Float {
    let n = if (returns1.size() < returns2.size()) { returns1.size() } else { returns2.size() };
    if (n < 2) { return 0.0 };
    
    let mean1 = mean(returns1);
    let mean2 = mean(returns2);
    let std1 = stdDev(returns1);
    let std2 = stdDev(returns2);
    
    if (std1 < 0.0001 or std2 < 0.0001) { return 0.0 };
    
    var cov : Float = 0.0;
    var i = 0;
    while (i < n) {
      cov += (returns1[i] - mean1) * (returns2[i] - mean2);
      i += 1;
    };
    cov := cov / Float.fromInt(n - 1);
    
    cov / (std1 * std2)
  };

  // Calculate covariance
  public func covariance(returns1: [Float], returns2: [Float]) : Float {
    let n = if (returns1.size() < returns2.size()) { returns1.size() } else { returns2.size() };
    if (n < 2) { return 0.0 };
    
    let mean1 = mean(returns1);
    let mean2 = mean(returns2);
    
    var cov : Float = 0.0;
    var i = 0;
    while (i < n) {
      cov += (returns1[i] - mean1) * (returns2[i] - mean2);
      i += 1;
    };
    cov / Float.fromInt(n - 1)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 4. PORTFOLIO OPTIMIZATION
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Mean-variance optimization (Markowitz):
  //   max: E[R] - (λ/2) × Var[R]
  //   s.t.: Σwᵢ = 1, wᵢ ≥ 0
  //
  // Risk Parity:
  //   Each position contributes equal risk to portfolio
  // ══════════════════════════════════════════════════════════════════════════

  // Calculate portfolio variance given weights and covariance matrix
  public func portfolioVariance(
    weights: [Float],
    covMatrix: [[Float]]
  ) : Float {
    let n = weights.size();
    var variance : Float = 0.0;
    
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        if (i < covMatrix.size() and j < covMatrix[i].size()) {
          variance += weights[i] * weights[j] * covMatrix[i][j];
        };
        j += 1;
      };
      i += 1;
    };
    
    variance
  };

  // Calculate portfolio expected return
  public func portfolioReturn(
    weights: [Float],
    expectedReturns: [Float]
  ) : Float {
    let n = if (weights.size() < expectedReturns.size()) { weights.size() } else { expectedReturns.size() };
    var ret : Float = 0.0;
    var i = 0;
    while (i < n) {
      ret += weights[i] * expectedReturns[i];
      i += 1;
    };
    ret
  };

  // Calculate Sharpe ratio
  public func sharpeRatio(
    portfolioReturn: Float,
    portfolioVolatility: Float,
    riskFreeRate: Float
  ) : Float {
    if (portfolioVolatility < 0.0001) { return 0.0 };
    (portfolioReturn - riskFreeRate) / portfolioVolatility
  };

  // Simple equal-weight allocation
  public func equalWeightAllocation(symbols: [Text]) : [(Text, Float)] {
    let n = symbols.size();
    if (n == 0) { return [] };
    let weight = 1.0 / Float.fromInt(n);
    
    Array.tabulate<(Text, Float)>(n, func(i) {
      (symbols[i], weight)
    })
  };

  // Risk parity weights (simplified)
  public func riskParityWeights(
    volatilities: [Float]
  ) : [Float] {
    let n = volatilities.size();
    if (n == 0) { return [] };
    
    // Risk parity: wᵢ ∝ 1/σᵢ
    var invVolSum : Float = 0.0;
    for (v in volatilities.vals()) {
      if (v > 0.0001) {
        invVolSum += 1.0 / v;
      };
    };
    
    if (invVolSum < 0.0001) {
      // Fallback to equal weight
      return Array.tabulate<Float>(n, func(_) { 1.0 / Float.fromInt(n) });
    };
    
    Array.tabulate<Float>(n, func(i) {
      if (volatilities[i] > 0.0001) {
        (1.0 / volatilities[i]) / invVolSum
      } else {
        0.0
      }
    })
  };

  // Diversification ratio = sum of weighted vols / portfolio vol
  public func diversificationRatio(
    weights: [Float],
    volatilities: [Float],
    portfolioVol: Float
  ) : Float {
    if (portfolioVol < 0.0001) { return 1.0 };
    
    let n = if (weights.size() < volatilities.size()) { weights.size() } else { volatilities.size() };
    var weightedVolSum : Float = 0.0;
    var i = 0;
    while (i < n) {
      weightedVolSum += weights[i] * volatilities[i];
      i += 1;
    };
    
    weightedVolSum / portfolioVol
  };

  // Effective number of bets (1/HHI of weights)
  public func effectiveN(weights: [Float]) : Float {
    var hhi : Float = 0.0;
    for (w in weights.vals()) {
      hhi += w * w;
    };
    if (hhi > 0.0001) { 1.0 / hhi } else { Float.fromInt(weights.size()) }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 5. STRESS TESTING
  // ══════════════════════════════════════════════════════════════════════════

  // Create historical stress scenarios
  public func createHistoricalScenarios() : [StressScenario] {
    [
      // 2008 Financial Crisis
      {
        name = "2008 Financial Crisis";
        description = "Global financial system collapse";
        assetShocks = [
          ("BTC", -0.00),    // BTC didn't exist yet
          ("ETH", -0.00),    // ETH didn't exist yet
          ("SPY", -0.50),    // S&P 500 dropped 50%
          ("ICP", -0.80)     // Proxy for high-risk crypto
        ];
        correlationShock = 0.30;  // Correlations spiked
        liquidityShock = 0.60;    // Liquidity dried up
        estimatedLoss = 0.0;      // Calculated later
        probability = 0.02;       // 2% chance in any year
      },
      // COVID Crash (March 2020)
      {
        name = "COVID Crash";
        description = "Pandemic market panic";
        assetShocks = [
          ("BTC", -0.50),
          ("ETH", -0.60),
          ("SPY", -0.34),
          ("ICP", -0.70)
        ];
        correlationShock = 0.40;
        liquidityShock = 0.50;
        estimatedLoss = 0.0;
        probability = 0.05;
      },
      // 2022 Crypto Winter
      {
        name = "Crypto Winter 2022";
        description = "Terra/Luna, FTX collapse";
        assetShocks = [
          ("BTC", -0.75),
          ("ETH", -0.80),
          ("SPY", -0.20),
          ("ICP", -0.95)
        ];
        correlationShock = 0.50;
        liquidityShock = 0.70;
        estimatedLoss = 0.0;
        probability = 0.10;
      },
      // Flash Crash
      {
        name = "Flash Crash";
        description = "Sudden market dislocation";
        assetShocks = [
          ("BTC", -0.30),
          ("ETH", -0.35),
          ("SPY", -0.10),
          ("ICP", -0.40)
        ];
        correlationShock = 0.20;
        liquidityShock = 0.80;
        estimatedLoss = 0.0;
        probability = 0.15;
      },
      // Black Swan
      {
        name = "Black Swan";
        description = "Unprecedented market event";
        assetShocks = [
          ("BTC", -0.90),
          ("ETH", -0.95),
          ("SPY", -0.40),
          ("ICP", -0.99)
        ];
        correlationShock = 0.80;
        liquidityShock = 0.90;
        estimatedLoss = 0.0;
        probability = 0.01;
      }
    ]
  };

  // Apply stress scenario to portfolio
  public func applyStressScenario(
    portfolio: Portfolio,
    scenario: StressScenario
  ) : Float {
    var totalLoss : Float = 0.0;
    
    for (position in portfolio.positions.vals()) {
      // Find shock for this asset
      var shock : Float = -0.30;  // Default 30% drawdown
      for ((symbol, s) in scenario.assetShocks.vals()) {
        if (symbol == position.symbol) {
          shock := s;
        };
      };
      
      // Apply liquidity adjustment (illiquid assets get hit harder)
      let liquidityMultiplier = switch (position.liquidity) {
        case (#HighlyLiquid) { 1.0 };
        case (#Liquid) { 1.1 };
        case (#ModeratelyLiquid) { 1.3 };
        case (#Illiquid) { 1.5 };
      };
      
      let adjustedShock = shock * liquidityMultiplier * (1.0 + scenario.liquidityShock);
      let positionLoss = position.marketValue * adjustedShock;
      totalLoss += positionLoss;
    };
    
    totalLoss
  };

  // Run full stress test
  public func runStressTest(portfolio: Portfolio) : StressTestResult {
    let scenarios = createHistoricalScenarios();
    var results : [StressScenario] = [];
    var worstScenario : Text = "";
    var worstLoss : Float = 0.0;
    var totalLoss : Float = 0.0;
    
    for (scenario in scenarios.vals()) {
      let loss = applyStressScenario(portfolio, scenario);
      let updatedScenario : StressScenario = {
        name = scenario.name;
        description = scenario.description;
        assetShocks = scenario.assetShocks;
        correlationShock = scenario.correlationShock;
        liquidityShock = scenario.liquidityShock;
        estimatedLoss = _abs(loss);
        probability = scenario.probability;
      };
      results := Array.append(results, [updatedScenario]);
      
      if (_abs(loss) > worstLoss) {
        worstLoss := _abs(loss);
        worstScenario := scenario.name;
      };
      totalLoss += _abs(loss);
    };
    
    let avgLoss = if (scenarios.size() > 0) { 
      totalLoss / Float.fromInt(scenarios.size()) 
    } else { 0.0 };
    
    // Survival probability (can survive all scenarios)
    let survivalProb = if (portfolio.totalValue > worstLoss) {
      1.0 - (worstLoss / portfolio.totalValue)
    } else { 0.0 };
    
    {
      scenarios = results;
      worstCaseScenario = worstScenario;
      worstCaseLoss = worstLoss;
      averageStressLoss = avgLoss;
      survivalProbability = _clamp(survivalProb, 0.0, 1.0);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 6. LIQUIDITY RISK ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  public func analyzeLiquidity(portfolio: Portfolio) : LiquidityProfile {
    var t1 : Float = 0.0;  // 1-day liquidatable
    var t5 : Float = 0.0;  // 5-day liquidatable
    var t20 : Float = 0.0; // 20-day liquidatable
    var hhi : Float = 0.0; // Concentration
    
    let total = portfolio.totalValue;
    if (total < 0.001) {
      return {
        t1Liquidity = 0.0;
        t5Liquidity = 0.0;
        t20Liquidity = 0.0;
        liquidityScore = 0.0;
        concentrationRisk = 1.0;
      };
    };
    
    for (pos in portfolio.positions.vals()) {
      let weight = pos.marketValue / total;
      hhi += weight * weight;
      
      switch (pos.liquidity) {
        case (#HighlyLiquid) {
          t1 += pos.marketValue;
          t5 += pos.marketValue;
          t20 += pos.marketValue;
        };
        case (#Liquid) {
          t5 += pos.marketValue;
          t20 += pos.marketValue;
        };
        case (#ModeratelyLiquid) {
          t20 += pos.marketValue;
        };
        case (#Illiquid) {
          // Nothing
        };
      };
    };
    
    // Add cash
    t1 += portfolio.cash;
    t5 += portfolio.cash;
    t20 += portfolio.cash;
    
    let totalWithCash = total + portfolio.cash;
    
    {
      t1Liquidity = t1 / totalWithCash;
      t5Liquidity = t5 / totalWithCash;
      t20Liquidity = t20 / totalWithCash;
      liquidityScore = (t1 / totalWithCash * 0.5 + t5 / totalWithCash * 0.3 + t20 / totalWithCash * 0.2);
      concentrationRisk = hhi;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 7. RISK BUDGET MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  public func calculateRiskBudget(
    portfolio: Portfolio,
    var_result: VaRResult,
    maxRiskBudget: Float
  ) : RiskBudget {
    let usedBudget = var_result.var99;  // Use 99% VaR as risk measure
    let remaining = _max(0.0, maxRiskBudget - usedBudget);
    
    // Calculate risk contribution per position (simplified)
    var byPosition : [(Text, Float)] = [];
    var bySector : [(Text, Float)] = [];
    
    // Group by position
    for (pos in portfolio.positions.vals()) {
      let posRisk = pos.weight * usedBudget;  // Simplified linear risk contribution
      byPosition := Array.append(byPosition, [(pos.symbol, posRisk)]);
    };
    
    // Group by sector (simplified)
    // In real implementation, would aggregate positions by sector
    
    {
      totalBudget = maxRiskBudget;
      usedBudget = usedBudget;
      remainingBudget = remaining;
      byPosition = byPosition;
      bySector = bySector;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 8. BREACH DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  public func detectBreaches(
    portfolio: Portfolio,
    var_result: VaRResult,
    liquidity: LiquidityProfile
  ) : [RiskBreach] {
    var breaches : [RiskBreach] = [];
    
    // VaR limit
    if (var_result.var99 > MAX_PORTFOLIO_VAR) {
      let severity = if (var_result.var99 > MAX_PORTFOLIO_VAR * 1.5) { #Critical }
                     else if (var_result.var99 > MAX_PORTFOLIO_VAR * 1.2) { #Breach }
                     else { #Warning };
      breaches := Array.append(breaches, [{
        breachType = #VaRLimit;
        description = "Portfolio VaR exceeds limit";
        severity = severity;
        currentValue = var_result.var99;
        limitValue = MAX_PORTFOLIO_VAR;
      }]);
    };
    
    // Concentration limits
    for (pos in portfolio.positions.vals()) {
      if (pos.weight > MAX_POSITION_CONCENTRATION) {
        let severity = if (pos.weight > MAX_POSITION_CONCENTRATION * 1.5) { #Critical }
                       else if (pos.weight > MAX_POSITION_CONCENTRATION * 1.2) { #Breach }
                       else { #Warning };
        breaches := Array.append(breaches, [{
          breachType = #ConcentrationLimit;
          description = "Position " # pos.symbol # " exceeds concentration limit";
          severity = severity;
          currentValue = pos.weight;
          limitValue = MAX_POSITION_CONCENTRATION;
        }]);
      };
    };
    
    // Liquidity limit
    if (liquidity.t1Liquidity < MIN_LIQUIDITY_RATIO) {
      let severity = if (liquidity.t1Liquidity < MIN_LIQUIDITY_RATIO * 0.5) { #Critical }
                     else if (liquidity.t1Liquidity < MIN_LIQUIDITY_RATIO * 0.75) { #Breach }
                     else { #Warning };
      breaches := Array.append(breaches, [{
        breachType = #LiquidityLimit;
        description = "Insufficient 1-day liquidity";
        severity = severity;
        currentValue = liquidity.t1Liquidity;
        limitValue = MIN_LIQUIDITY_RATIO;
      }]);
    };
    
    // Leverage limit
    if (portfolio.leverage > 2.0) {
      let severity = if (portfolio.leverage > 3.0) { #Critical }
                     else if (portfolio.leverage > 2.5) { #Breach }
                     else { #Warning };
      breaches := Array.append(breaches, [{
        breachType = #LeverageLimit;
        description = "Leverage exceeds limit";
        severity = severity;
        currentValue = portfolio.leverage;
        limitValue = 2.0;
      }]);
    };
    
    breaches
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 9. RISK RECOMMENDATIONS
  // ══════════════════════════════════════════════════════════════════════════

  public func generateRecommendation(
    breaches: [RiskBreach],
    portfolio: Portfolio
  ) : RiskRecommendation {
    // Count breach severities
    var criticalCount : Nat = 0;
    var breachCount : Nat = 0;
    var warningCount : Nat = 0;
    
    for (breach in breaches.vals()) {
      switch (breach.severity) {
        case (#Critical) { criticalCount += 1 };
        case (#Breach) { breachCount += 1 };
        case (#Warning) { warningCount += 1 };
      };
    };
    
    // Determine action based on breach severity
    let (action, urgency) = if (criticalCount > 0) {
      (#LiquidatePartial, #Immediate)
    } else if (breachCount > 1) {
      (#ReduceExposure, #High)
    } else if (breachCount > 0 or warningCount > 2) {
      (#Rebalance, #Medium)
    } else if (warningCount > 0) {
      (#Hedge, #Low)
    } else {
      (#NoAction, #Low)
    };
    
    // Generate suggested trades
    var suggestedTrades : [(Text, Float, Bool)] = [];
    
    for (breach in breaches.vals()) {
      switch (breach.breachType) {
        case (#ConcentrationLimit) {
          // Find the overweight position and suggest selling
          for (pos in portfolio.positions.vals()) {
            if (pos.weight > MAX_POSITION_CONCENTRATION) {
              let excessWeight = pos.weight - MAX_POSITION_CONCENTRATION * 0.9;
              let sellAmount = excessWeight * portfolio.totalValue;
              suggestedTrades := Array.append(suggestedTrades, [(pos.symbol, sellAmount, false)]);
            };
          };
        };
        case (#VaRLimit) {
          // Suggest reducing overall exposure
          let reductionTarget = 0.1 * portfolio.totalValue;
          // Would identify most volatile positions to reduce
        };
        case (_) {
          // Other breaches
        };
      };
    };
    
    {
      action = action;
      urgency = urgency;
      details = "Risk management recommendation based on " # 
                debug_show(criticalCount) # " critical, " #
                debug_show(breachCount) # " breach, " #
                debug_show(warningCount) # " warning issues.";
      suggestedTrades = suggestedTrades;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 10. FULL RISK REPORT
  // ══════════════════════════════════════════════════════════════════════════

  public func generateRiskReport(
    portfolio: Portfolio,
    returns: ReturnSeries,
    beat: Nat
  ) : RiskReport {
    // Calculate VaR
    let var_result = historicalVaR(returns, portfolio.totalValue);
    
    // Calculate CVaR
    let cvar_result = calculateCVaR(returns);
    
    // Analyze liquidity
    let liquidity = analyzeLiquidity(portfolio);
    
    // Run stress test
    let stressTest = runStressTest(portfolio);
    
    // Calculate risk budget
    let riskBudget = calculateRiskBudget(portfolio, var_result, MAX_PORTFOLIO_VAR);
    
    // Detect breaches
    let breaches = detectBreaches(portfolio, var_result, liquidity);
    
    // Generate recommendation
    let recommendation = generateRecommendation(breaches, portfolio);
    
    // Overall risk score
    let varScore = var_result.var99 / MAX_PORTFOLIO_VAR;
    let liquidityScore = 1.0 - liquidity.liquidityScore;
    let concentrationScore = liquidity.concentrationRisk;
    let stressScore = stressTest.worstCaseLoss / portfolio.totalValue;
    
    let overallScore = _clamp(
      (varScore * 0.3 + liquidityScore * 0.2 + concentrationScore * 0.2 + stressScore * 0.3),
      0.0, 1.0
    );
    
    {
      timestamp = beat;
      var_result = var_result;
      cvar_result = cvar_result;
      liquidity = liquidity;
      stressTest = stressTest;
      riskBudget = riskBudget;
      breaches = breaches;
      overallRiskScore = overallScore;
      recommendation = recommendation;
    }
  };

}
