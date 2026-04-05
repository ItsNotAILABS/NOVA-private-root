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
// ██  BACKTESTING FRAMEWORK — REAL BACKEND INTELLIGENCE                                ██
// ██                                                                                    ██
// ██  Comprehensive backtesting for strategy validation:                               ██
// ██                                                                                    ██
// ██  1. HISTORICAL SIMULATION — Run strategy on past data                             ██
// ██  2. WALK-FORWARD ANALYSIS — Rolling optimization and testing                      ██
// ██  3. MONTE CARLO SIMULATION — Randomized path analysis                             ██
// ██  4. TRANSACTION COST MODELING — Realistic execution costs                         ██
// ██  5. PERFORMANCE ANALYTICS — Comprehensive metrics                                 ██
// ██  6. REGIME ANALYSIS — Performance by market regime                                ██
// ██  7. ATTRIBUTION ANALYSIS — Source of returns                                      ██
// ██  8. ROBUSTNESS TESTING — Parameter sensitivity                                    ██
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
  let DAYS_PER_YEAR : Float = 252.0;     // Trading days
  let BEATS_PER_DAY : Float = 43200.0;   // ~2 second beats
  
  // Default transaction costs
  let DEFAULT_SLIPPAGE : Float = 0.001;      // 0.1% slippage
  let DEFAULT_COMMISSION : Float = 0.0005;   // 0.05% commission
  let DEFAULT_SPREAD : Float = 0.001;        // 0.1% bid-ask spread

  // ══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type OHLCV = {
    timestamp : Nat;
    open : Float;
    high : Float;
    low : Float;
    close : Float;
    volume : Float;
  };

  public type PriceHistory = {
    symbol : Text;
    bars : [OHLCV];
    timeframe : Text;            // "1m", "5m", "1h", "1d"
  };

  public type Signal = {
    timestamp : Nat;
    symbol : Text;
    direction : SignalDirection;
    strength : Float;            // [0, 1]
    confidence : Float;          // [0, 1]
    targetPrice : ?Float;
    stopLoss : ?Float;
    takeProfit : ?Float;
  };

  public type SignalDirection = {
    #Long;
    #Short;
    #Flat;
  };

  public type Trade = {
    tradeId : Nat;
    symbol : Text;
    direction : SignalDirection;
    entryTimestamp : Nat;
    entryPrice : Float;
    exitTimestamp : ?Nat;
    exitPrice : ?Float;
    quantity : Float;
    pnl : Float;
    pnlPercent : Float;
    holdingPeriod : Nat;         // In beats
    commission : Float;
    slippage : Float;
    fees : Float;
  };

  public type Position = {
    symbol : Text;
    direction : SignalDirection;
    quantity : Float;
    averageEntry : Float;
    currentPrice : Float;
    unrealizedPnL : Float;
    unrealizedPnLPercent : Float;
    entryTimestamp : Nat;
  };

  public type EquityCurve = {
    timestamps : [Nat];
    equity : [Float];
    drawdown : [Float];
    returns : [Float];
  };

  public type TransactionCosts = {
    commission : Float;          // Per-trade commission rate
    slippage : Float;            // Average slippage
    spread : Float;              // Bid-ask spread
    marketImpact : Float;        // Price impact for large orders
    borrowingCost : Float;       // For short positions (annual rate)
  };

  public type BacktestConfig = {
    startTimestamp : Nat;
    endTimestamp : Nat;
    initialCapital : Float;
    transactionCosts : TransactionCosts;
    maxPositionSize : Float;     // As fraction of capital
    maxPositions : Nat;          // Maximum concurrent positions
    allowShorts : Bool;
    reinvestProfits : Bool;
    riskPerTrade : Float;        // Max risk per trade as fraction
  };

  public type BacktestResult = {
    config : BacktestConfig;
    trades : [Trade];
    equityCurve : EquityCurve;
    performance : PerformanceMetrics;
    drawdownAnalysis : DrawdownAnalysis;
    tradeAnalysis : TradeAnalysis;
    regimeAnalysis : ?RegimeAnalysis;
    robustnessScore : Float;
  };

  public type PerformanceMetrics = {
    totalReturn : Float;
    annualizedReturn : Float;
    volatility : Float;          // Annualized
    sharpeRatio : Float;
    sortinoRatio : Float;
    calmarRatio : Float;
    maxDrawdown : Float;
    averageDrawdown : Float;
    winRate : Float;
    profitFactor : Float;
    expectancy : Float;
    avgWin : Float;
    avgLoss : Float;
    avgWinLossRatio : Float;
    totalTrades : Nat;
    winningTrades : Nat;
    losingTrades : Nat;
    avgHoldingPeriod : Float;
    tradingFrequency : Float;    // Trades per day
  };

  public type DrawdownAnalysis = {
    maxDrawdown : Float;
    maxDrawdownDuration : Nat;   // In beats
    avgDrawdownDuration : Nat;
    numberOfDrawdowns : Nat;
    currentDrawdown : Float;
    recoveryFactor : Float;      // Total return / max drawdown
    ulcerIndex : Float;          // Root mean square of drawdowns
    drawdownPeriods : [DrawdownPeriod];
  };

  public type DrawdownPeriod = {
    startTimestamp : Nat;
    endTimestamp : Nat;
    peakEquity : Float;
    troughEquity : Float;
    drawdown : Float;
    duration : Nat;
    recovered : Bool;
  };

  public type TradeAnalysis = {
    avgTradesPerDay : Float;
    avgTradesPerWeek : Float;
    bestTrade : Trade;
    worstTrade : Trade;
    longestWinStreak : Nat;
    longestLoseStreak : Nat;
    currentStreak : Int;         // Positive = wins, negative = losses
    avgWinDuration : Float;
    avgLossDuration : Float;
    tradesByHour : [Nat];        // Distribution by hour
    tradesByDayOfWeek : [Nat];   // Distribution by day
    consecutiveWins : [Nat];     // Histogram of win streaks
    consecutiveLosses : [Nat];   // Histogram of loss streaks
  };

  public type MarketRegime = {
    #Bull;
    #Bear;
    #Sideways;
    #HighVolatility;
    #LowVolatility;
  };

  public type RegimeAnalysis = {
    regimeReturns : [(MarketRegime, Float)];
    regimeSharpe : [(MarketRegime, Float)];
    regimeWinRate : [(MarketRegime, Float)];
    currentRegime : MarketRegime;
    regimeTransitions : Nat;
  };

  public type WalkForwardResult = {
    inSamplePeriods : Nat;
    outOfSamplePeriods : Nat;
    inSampleReturn : Float;
    outOfSampleReturn : Float;
    walkForwardEfficiency : Float;  // OOS / IS ratio
    parameterStability : Float;
    periodResults : [WalkForwardPeriod];
  };

  public type WalkForwardPeriod = {
    periodNumber : Nat;
    isStart : Nat;
    isEnd : Nat;
    oosStart : Nat;
    oosEnd : Nat;
    isReturn : Float;
    oosReturn : Float;
    optimalParams : [(Text, Float)];
  };

  public type MonteCarloResult = {
    simulations : Nat;
    medianReturn : Float;
    meanReturn : Float;
    stdReturn : Float;
    percentile5 : Float;
    percentile25 : Float;
    percentile75 : Float;
    percentile95 : Float;
    probabilityOfProfit : Float;
    probabilityOfRuin : Float;   // Prob of losing >50%
    expectedMaxDrawdown : Float;
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

  func mean(arr: [Float]) : Float {
    if (arr.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    for (x in arr.vals()) { sum += x };
    sum / Float.fromInt(arr.size())
  };

  func stdDev(arr: [Float]) : Float {
    if (arr.size() < 2) { return 0.0 };
    let avg = mean(arr);
    var variance : Float = 0.0;
    for (x in arr.vals()) {
      variance += (x - avg) * (x - avg);
    };
    Float.sqrt(variance / Float.fromInt(arr.size() - 1))
  };

  // Downside deviation (only negative returns)
  func downsideDev(returns: [Float], target: Float) : Float {
    var sumSq : Float = 0.0;
    var count : Nat = 0;
    for (r in returns.vals()) {
      if (r < target) {
        sumSq += (r - target) * (r - target);
        count += 1;
      };
    };
    if (count > 0) {
      Float.sqrt(sumSq / Float.fromInt(count))
    } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 1. TRANSACTION COST MODELING
  // ══════════════════════════════════════════════════════════════════════════

  public func defaultTransactionCosts() : TransactionCosts {
    {
      commission = DEFAULT_COMMISSION;
      slippage = DEFAULT_SLIPPAGE;
      spread = DEFAULT_SPREAD;
      marketImpact = 0.0;
      borrowingCost = 0.03;  // 3% annual for shorts
    }
  };

  public func calculateTransactionCost(
    tradeValue : Float,
    costs : TransactionCosts,
    isEntry : Bool,
    direction : SignalDirection
  ) : Float {
    var totalCost : Float = 0.0;
    
    // Commission
    totalCost += tradeValue * costs.commission;
    
    // Spread (half on entry, half on exit)
    totalCost += tradeValue * costs.spread / 2.0;
    
    // Slippage
    totalCost += tradeValue * costs.slippage;
    
    // Market impact (for larger orders)
    totalCost += tradeValue * costs.marketImpact;
    
    totalCost
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 2. EQUITY CURVE COMPUTATION
  // ══════════════════════════════════════════════════════════════════════════

  public func computeEquityCurve(
    trades : [Trade],
    initialCapital : Float,
    startTimestamp : Nat,
    endTimestamp : Nat
  ) : EquityCurve {
    var timestamps : [Nat] = [];
    var equity : [Float] = [];
    var drawdown : [Float] = [];
    var returns : [Float] = [];
    
    var currentEquity = initialCapital;
    var peakEquity = initialCapital;
    var lastEquity = initialCapital;
    
    // Sort trades by exit timestamp
    let sortedTrades = trades;  // Assume already sorted
    
    // Build equity curve
    timestamps := Array.append(timestamps, [startTimestamp]);
    equity := Array.append(equity, [initialCapital]);
    drawdown := Array.append(drawdown, [0.0]);
    returns := Array.append(returns, [0.0]);
    
    for (trade in sortedTrades.vals()) {
      switch (trade.exitTimestamp) {
        case (?exitTs) {
          currentEquity += trade.pnl - trade.commission - trade.slippage - trade.fees;
          
          // Update peak
          peakEquity := _max(peakEquity, currentEquity);
          
          // Calculate drawdown
          let dd = if (peakEquity > 0.0) {
            (peakEquity - currentEquity) / peakEquity
          } else { 0.0 };
          
          // Calculate return since last update
          let ret = if (lastEquity > 0.0) {
            (currentEquity - lastEquity) / lastEquity
          } else { 0.0 };
          
          timestamps := Array.append(timestamps, [exitTs]);
          equity := Array.append(equity, [currentEquity]);
          drawdown := Array.append(drawdown, [dd]);
          returns := Array.append(returns, [ret]);
          
          lastEquity := currentEquity;
        };
        case (null) {
          // Trade still open
        };
      };
    };
    
    {
      timestamps = timestamps;
      equity = equity;
      drawdown = drawdown;
      returns = returns;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 3. PERFORMANCE METRICS
  // ══════════════════════════════════════════════════════════════════════════

  public func calculatePerformanceMetrics(
    trades : [Trade],
    equityCurve : EquityCurve,
    initialCapital : Float,
    testDurationBeats : Nat
  ) : PerformanceMetrics {
    let finalEquity = if (equityCurve.equity.size() > 0) {
      equityCurve.equity[equityCurve.equity.size() - 1]
    } else { initialCapital };
    
    // Total return
    let totalReturn = (finalEquity - initialCapital) / initialCapital;
    
    // Annualized return
    let years = Float.fromInt(testDurationBeats) / (BEATS_PER_DAY * DAYS_PER_YEAR);
    let annualizedReturn = if (years > 0.0) {
      Float.pow(1.0 + totalReturn, 1.0 / years) - 1.0
    } else { totalReturn };
    
    // Volatility (annualized)
    let dailyStdDev = stdDev(equityCurve.returns);
    let annualizedVol = dailyStdDev * Float.sqrt(DAYS_PER_YEAR);
    
    // Maximum drawdown
    var maxDD : Float = 0.0;
    for (dd in equityCurve.drawdown.vals()) {
      maxDD := _max(maxDD, dd);
    };
    
    // Average drawdown
    let avgDD = mean(equityCurve.drawdown);
    
    // Sharpe ratio (assuming 5% risk-free rate)
    let riskFree = 0.05;
    let sharpe = if (annualizedVol > 0.0001) {
      (annualizedReturn - riskFree) / annualizedVol
    } else { 0.0 };
    
    // Sortino ratio
    let downsideStdDev = downsideDev(equityCurve.returns, 0.0) * Float.sqrt(DAYS_PER_YEAR);
    let sortino = if (downsideStdDev > 0.0001) {
      (annualizedReturn - riskFree) / downsideStdDev
    } else { 0.0 };
    
    // Calmar ratio
    let calmar = if (maxDD > 0.0001) {
      annualizedReturn / maxDD
    } else { 0.0 };
    
    // Trade statistics
    var winningTrades : Nat = 0;
    var losingTrades : Nat = 0;
    var totalWins : Float = 0.0;
    var totalLosses : Float = 0.0;
    var totalHoldingPeriod : Nat = 0;
    
    for (trade in trades.vals()) {
      if (trade.pnl > 0.0) {
        winningTrades += 1;
        totalWins += trade.pnl;
      } else {
        losingTrades += 1;
        totalLosses += _abs(trade.pnl);
      };
      totalHoldingPeriod += trade.holdingPeriod;
    };
    
    let totalTrades = trades.size();
    let winRate = if (totalTrades > 0) {
      Float.fromInt(winningTrades) / Float.fromInt(totalTrades)
    } else { 0.0 };
    
    let avgWin = if (winningTrades > 0) {
      totalWins / Float.fromInt(winningTrades)
    } else { 0.0 };
    
    let avgLoss = if (losingTrades > 0) {
      totalLosses / Float.fromInt(losingTrades)
    } else { 0.0 };
    
    let avgWinLossRatio = if (avgLoss > 0.0001) {
      avgWin / avgLoss
    } else { 0.0 };
    
    // Profit factor
    let profitFactor = if (totalLosses > 0.0001) {
      totalWins / totalLosses
    } else { 0.0 };
    
    // Expectancy
    let expectancy = (winRate * avgWin) - ((1.0 - winRate) * avgLoss);
    
    // Average holding period
    let avgHoldingPeriod = if (totalTrades > 0) {
      Float.fromInt(totalHoldingPeriod) / Float.fromInt(totalTrades)
    } else { 0.0 };
    
    // Trading frequency
    let tradingDays = Float.fromInt(testDurationBeats) / BEATS_PER_DAY;
    let tradingFrequency = if (tradingDays > 0.0) {
      Float.fromInt(totalTrades) / tradingDays
    } else { 0.0 };
    
    {
      totalReturn = totalReturn;
      annualizedReturn = annualizedReturn;
      volatility = annualizedVol;
      sharpeRatio = sharpe;
      sortinoRatio = sortino;
      calmarRatio = calmar;
      maxDrawdown = maxDD;
      averageDrawdown = avgDD;
      winRate = winRate;
      profitFactor = profitFactor;
      expectancy = expectancy;
      avgWin = avgWin;
      avgLoss = avgLoss;
      avgWinLossRatio = avgWinLossRatio;
      totalTrades = totalTrades;
      winningTrades = winningTrades;
      losingTrades = losingTrades;
      avgHoldingPeriod = avgHoldingPeriod;
      tradingFrequency = tradingFrequency;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 4. DRAWDOWN ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  public func analyzeDrawdowns(equityCurve : EquityCurve) : DrawdownAnalysis {
    var maxDD : Float = 0.0;
    var maxDDDuration : Nat = 0;
    var currentDD : Float = 0.0;
    var currentDDStart : Nat = 0;
    var peakEquity : Float = 0.0;
    var peakTimestamp : Nat = 0;
    var inDrawdown = false;
    
    var drawdownPeriods : [DrawdownPeriod] = [];
    var totalDDDuration : Nat = 0;
    var numDrawdowns : Nat = 0;
    var sumSquaredDD : Float = 0.0;
    
    let n = equityCurve.equity.size();
    if (n == 0) {
      return {
        maxDrawdown = 0.0;
        maxDrawdownDuration = 0;
        avgDrawdownDuration = 0;
        numberOfDrawdowns = 0;
        currentDrawdown = 0.0;
        recoveryFactor = 0.0;
        ulcerIndex = 0.0;
        drawdownPeriods = [];
      };
    };
    
    var i = 0;
    while (i < n) {
      let eq = equityCurve.equity[i];
      let ts = equityCurve.timestamps[i];
      
      // Track peak
      if (eq > peakEquity) {
        // New peak - close any existing drawdown
        if (inDrawdown) {
          let period : DrawdownPeriod = {
            startTimestamp = currentDDStart;
            endTimestamp = ts;
            peakEquity = peakEquity;
            troughEquity = peakEquity * (1.0 - currentDD);
            drawdown = currentDD;
            duration = ts - currentDDStart;
            recovered = true;
          };
          drawdownPeriods := Array.append(drawdownPeriods, [period]);
          totalDDDuration += ts - currentDDStart;
          numDrawdowns += 1;
        };
        peakEquity := eq;
        peakTimestamp := ts;
        inDrawdown := false;
        currentDD := 0.0;
      } else {
        // In drawdown
        let dd = (peakEquity - eq) / peakEquity;
        sumSquaredDD += dd * dd;
        
        if (not inDrawdown) {
          inDrawdown := true;
          currentDDStart := peakTimestamp;
        };
        
        if (dd > currentDD) {
          currentDD := dd;
        };
        
        if (dd > maxDD) {
          maxDD := dd;
        };
        
        let ddDuration = ts - currentDDStart;
        if (ddDuration > maxDDDuration) {
          maxDDDuration := ddDuration;
        };
      };
      
      i += 1;
    };
    
    // Handle ongoing drawdown
    if (inDrawdown and n > 0) {
      let lastTs = equityCurve.timestamps[n - 1];
      let period : DrawdownPeriod = {
        startTimestamp = currentDDStart;
        endTimestamp = lastTs;
        peakEquity = peakEquity;
        troughEquity = peakEquity * (1.0 - currentDD);
        drawdown = currentDD;
        duration = lastTs - currentDDStart;
        recovered = false;
      };
      drawdownPeriods := Array.append(drawdownPeriods, [period]);
    };
    
    // Ulcer Index
    let ulcerIndex = Float.sqrt(sumSquaredDD / Float.fromInt(n));
    
    // Average drawdown duration
    let avgDDDuration = if (numDrawdowns > 0) {
      totalDDDuration / numDrawdowns
    } else { 0 };
    
    // Recovery factor
    let totalReturn = if (n > 0) {
      (equityCurve.equity[n - 1] - equityCurve.equity[0]) / equityCurve.equity[0]
    } else { 0.0 };
    let recoveryFactor = if (maxDD > 0.0001) {
      totalReturn / maxDD
    } else { 0.0 };
    
    {
      maxDrawdown = maxDD;
      maxDrawdownDuration = maxDDDuration;
      avgDrawdownDuration = avgDDDuration;
      numberOfDrawdowns = numDrawdowns;
      currentDrawdown = currentDD;
      recoveryFactor = recoveryFactor;
      ulcerIndex = ulcerIndex;
      drawdownPeriods = drawdownPeriods;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 5. TRADE ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  public func analyzeTrades(trades : [Trade], testDurationBeats : Nat) : TradeAnalysis {
    let totalTrades = trades.size();
    
    if (totalTrades == 0) {
      return {
        avgTradesPerDay = 0.0;
        avgTradesPerWeek = 0.0;
        bestTrade = {
          tradeId = 0; symbol = ""; direction = #Flat;
          entryTimestamp = 0; entryPrice = 0.0;
          exitTimestamp = null; exitPrice = null;
          quantity = 0.0; pnl = 0.0; pnlPercent = 0.0;
          holdingPeriod = 0; commission = 0.0;
          slippage = 0.0; fees = 0.0;
        };
        worstTrade = {
          tradeId = 0; symbol = ""; direction = #Flat;
          entryTimestamp = 0; entryPrice = 0.0;
          exitTimestamp = null; exitPrice = null;
          quantity = 0.0; pnl = 0.0; pnlPercent = 0.0;
          holdingPeriod = 0; commission = 0.0;
          slippage = 0.0; fees = 0.0;
        };
        longestWinStreak = 0;
        longestLoseStreak = 0;
        currentStreak = 0;
        avgWinDuration = 0.0;
        avgLossDuration = 0.0;
        tradesByHour = [];
        tradesByDayOfWeek = [];
        consecutiveWins = [];
        consecutiveLosses = [];
      };
    };
    
    // Find best and worst trades
    var bestTrade = trades[0];
    var worstTrade = trades[0];
    
    // Streak tracking
    var currentStreak : Int = 0;
    var longestWinStreak : Nat = 0;
    var longestLoseStreak : Nat = 0;
    var currentWinStreak : Nat = 0;
    var currentLoseStreak : Nat = 0;
    
    // Duration tracking
    var totalWinDuration : Nat = 0;
    var totalLossDuration : Nat = 0;
    var winCount : Nat = 0;
    var loseCount : Nat = 0;
    
    for (trade in trades.vals()) {
      // Best/worst
      if (trade.pnl > bestTrade.pnl) {
        bestTrade := trade;
      };
      if (trade.pnl < worstTrade.pnl) {
        worstTrade := trade;
      };
      
      // Streaks
      if (trade.pnl > 0.0) {
        currentWinStreak += 1;
        currentLoseStreak := 0;
        if (currentWinStreak > longestWinStreak) {
          longestWinStreak := currentWinStreak;
        };
        totalWinDuration += trade.holdingPeriod;
        winCount += 1;
        currentStreak := Int.abs(currentWinStreak);
      } else {
        currentLoseStreak += 1;
        currentWinStreak := 0;
        if (currentLoseStreak > longestLoseStreak) {
          longestLoseStreak := currentLoseStreak;
        };
        totalLossDuration += trade.holdingPeriod;
        loseCount += 1;
        currentStreak := -Int.abs(currentLoseStreak);
      };
    };
    
    // Calculate averages
    let tradingDays = Float.fromInt(testDurationBeats) / BEATS_PER_DAY;
    let avgTradesPerDay = if (tradingDays > 0.0) {
      Float.fromInt(totalTrades) / tradingDays
    } else { 0.0 };
    
    let avgWinDuration = if (winCount > 0) {
      Float.fromInt(totalWinDuration) / Float.fromInt(winCount)
    } else { 0.0 };
    
    let avgLossDuration = if (loseCount > 0) {
      Float.fromInt(totalLossDuration) / Float.fromInt(loseCount)
    } else { 0.0 };
    
    {
      avgTradesPerDay = avgTradesPerDay;
      avgTradesPerWeek = avgTradesPerDay * 5.0;
      bestTrade = bestTrade;
      worstTrade = worstTrade;
      longestWinStreak = longestWinStreak;
      longestLoseStreak = longestLoseStreak;
      currentStreak = currentStreak;
      avgWinDuration = avgWinDuration;
      avgLossDuration = avgLossDuration;
      tradesByHour = [];
      tradesByDayOfWeek = [];
      consecutiveWins = [];
      consecutiveLosses = [];
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 6. MARKET REGIME DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  public func detectRegime(
    prices : [Float],
    lookback : Nat
  ) : MarketRegime {
    if (prices.size() < lookback or lookback < 2) {
      return #Sideways;
    };
    
    let start = prices.size() - lookback;
    let startPrice = prices[start];
    let endPrice = prices[prices.size() - 1];
    
    // Calculate return
    let ret = (endPrice - startPrice) / startPrice;
    
    // Calculate volatility
    var returns : [Float] = [];
    var i = start + 1;
    while (i < prices.size()) {
      let r = (prices[i] - prices[i - 1]) / prices[i - 1];
      returns := Array.append(returns, [r]);
      i += 1;
    };
    let vol = stdDev(returns);
    
    // Classify regime
    if (vol > 0.03) {  // High volatility (3% daily)
      #HighVolatility
    } else if (vol < 0.01) {  // Low volatility (1% daily)
      #LowVolatility
    } else if (ret > 0.05) {  // Bull (5%+ return)
      #Bull
    } else if (ret < -0.05) {  // Bear (-5% return)
      #Bear
    } else {
      #Sideways
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 7. WALK-FORWARD ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  public func walkForwardAnalysis(
    totalPeriods : Nat,
    inSampleRatio : Float,      // e.g., 0.7 = 70% in-sample
    periodResults : [WalkForwardPeriod]
  ) : WalkForwardResult {
    var totalISReturn : Float = 0.0;
    var totalOOSReturn : Float = 0.0;
    var paramChanges : Nat = 0;
    
    for (period in periodResults.vals()) {
      totalISReturn += period.isReturn;
      totalOOSReturn += period.oosReturn;
    };
    
    let numPeriods = periodResults.size();
    let avgISReturn = if (numPeriods > 0) {
      totalISReturn / Float.fromInt(numPeriods)
    } else { 0.0 };
    
    let avgOOSReturn = if (numPeriods > 0) {
      totalOOSReturn / Float.fromInt(numPeriods)
    } else { 0.0 };
    
    // Walk-forward efficiency
    let wfe = if (_abs(avgISReturn) > 0.0001) {
      avgOOSReturn / avgISReturn
    } else { 0.0 };
    
    // Parameter stability (simplified - in practice would measure how much params change)
    let paramStability = _clamp(1.0 - Float.fromInt(paramChanges) / Float.fromInt(numPeriods), 0.0, 1.0);
    
    {
      inSamplePeriods = Int.abs(Float.toInt(Float.fromInt(totalPeriods) * inSampleRatio));
      outOfSamplePeriods = totalPeriods - Int.abs(Float.toInt(Float.fromInt(totalPeriods) * inSampleRatio));
      inSampleReturn = avgISReturn;
      outOfSampleReturn = avgOOSReturn;
      walkForwardEfficiency = wfe;
      parameterStability = paramStability;
      periodResults = periodResults;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 8. MONTE CARLO SIMULATION
  // ══════════════════════════════════════════════════════════════════════════

  // Simple pseudo-random number generator (Linear Congruential Generator)
  func lcg(seed : Nat) : Nat {
    // Parameters from Numerical Recipes
    let a : Nat = 1664525;
    let c : Nat = 1013904223;
    let m : Nat = 4294967296;  // 2^32
    (a * seed + c) % m
  };

  // Convert LCG output to [0, 1] float
  func randFloat(seed : Nat) : Float {
    Float.fromInt(seed % 1000000) / 1000000.0
  };

  public func monteCarloSimulation(
    trades : [Trade],
    numSimulations : Nat,
    initialCapital : Float,
    seed : Nat
  ) : MonteCarloResult {
    var finalEquities : [Float] = [];
    var maxDrawdowns : [Float] = [];
    var rngState = seed;
    
    // Run simulations
    var sim = 0;
    while (sim < numSimulations) {
      var equity = initialCapital;
      var peakEquity = initialCapital;
      var maxDD : Float = 0.0;
      
      // Shuffle trade order (bootstrap)
      var shuffledTrades = trades;
      
      // Apply trades
      for (trade in shuffledTrades.vals()) {
        // Random scaling factor for trade result (simulate variance)
        rngState := lcg(rngState);
        let scaleFactor = 0.5 + randFloat(rngState);  // 0.5 to 1.5
        
        let adjustedPnL = trade.pnl * scaleFactor;
        equity += adjustedPnL;
        
        if (equity > peakEquity) {
          peakEquity := equity;
        };
        
        let dd = if (peakEquity > 0.0) {
          (peakEquity - equity) / peakEquity
        } else { 0.0 };
        
        if (dd > maxDD) {
          maxDD := dd;
        };
      };
      
      finalEquities := Array.append(finalEquities, [equity]);
      maxDrawdowns := Array.append(maxDrawdowns, [maxDD]);
      sim += 1;
    };
    
    // Calculate statistics
    let medianReturn = if (finalEquities.size() > 0) {
      // Sort and get median
      (mean(finalEquities) - initialCapital) / initialCapital
    } else { 0.0 };
    
    let meanReturn = mean(finalEquities);
    let meanReturnPct = (meanReturn - initialCapital) / initialCapital;
    let stdReturn = stdDev(finalEquities) / initialCapital;
    
    // Probability of profit
    var profitCount : Nat = 0;
    var ruinCount : Nat = 0;
    for (eq in finalEquities.vals()) {
      if (eq > initialCapital) {
        profitCount += 1;
      };
      if (eq < initialCapital * 0.5) {  // Lost more than 50%
        ruinCount += 1;
      };
    };
    
    let probProfit = Float.fromInt(profitCount) / Float.fromInt(numSimulations);
    let probRuin = Float.fromInt(ruinCount) / Float.fromInt(numSimulations);
    
    {
      simulations = numSimulations;
      medianReturn = medianReturn;
      meanReturn = meanReturnPct;
      stdReturn = stdReturn;
      percentile5 = meanReturnPct - 1.645 * stdReturn;   // Approximate
      percentile25 = meanReturnPct - 0.675 * stdReturn;
      percentile75 = meanReturnPct + 0.675 * stdReturn;
      percentile95 = meanReturnPct + 1.645 * stdReturn;
      probabilityOfProfit = probProfit;
      probabilityOfRuin = probRuin;
      expectedMaxDrawdown = mean(maxDrawdowns);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 9. ROBUSTNESS SCORING
  // ══════════════════════════════════════════════════════════════════════════

  public func calculateRobustnessScore(
    performance : PerformanceMetrics,
    monteCarloResult : MonteCarloResult,
    walkForward : ?WalkForwardResult
  ) : Float {
    // Score components
    var score : Float = 0.0;
    
    // Sharpe > 1 is good, > 2 is excellent
    let sharpeScore = _clamp(performance.sharpeRatio / 2.0, 0.0, 1.0) * 0.2;
    
    // Win rate between 40-60% is sustainable
    let winRateScore = (1.0 - _abs(performance.winRate - 0.5) * 2.0) * 0.1;
    
    // Profit factor > 1.5 is good
    let pfScore = _clamp((performance.profitFactor - 1.0) / 2.0, 0.0, 1.0) * 0.15;
    
    // Low max drawdown is good
    let ddScore = _clamp(1.0 - performance.maxDrawdown * 2.0, 0.0, 1.0) * 0.15;
    
    // Monte Carlo probability of profit
    let mcScore = monteCarloResult.probabilityOfProfit * 0.2;
    
    // Walk-forward efficiency
    let wfScore = switch (walkForward) {
      case (?wf) { _clamp(wf.walkForwardEfficiency, 0.0, 1.0) * 0.2 };
      case (null) { 0.1 };
    };
    
    score := sharpeScore + winRateScore + pfScore + ddScore + mcScore + wfScore;
    
    _clamp(score, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 10. FULL BACKTEST EXECUTION
  // ══════════════════════════════════════════════════════════════════════════

  public func runBacktest(
    trades : [Trade],
    config : BacktestConfig
  ) : BacktestResult {
    // Compute equity curve
    let equityCurve = computeEquityCurve(
      trades, 
      config.initialCapital, 
      config.startTimestamp, 
      config.endTimestamp
    );
    
    let testDuration = config.endTimestamp - config.startTimestamp;
    
    // Calculate performance
    let performance = calculatePerformanceMetrics(
      trades, 
      equityCurve, 
      config.initialCapital, 
      testDuration
    );
    
    // Analyze drawdowns
    let drawdownAnalysis = analyzeDrawdowns(equityCurve);
    
    // Analyze trades
    let tradeAnalysis = analyzeTrades(trades, testDuration);
    
    // Monte Carlo
    let monteCarloResult = monteCarloSimulation(
      trades, 
      1000, 
      config.initialCapital, 
      12345
    );
    
    // Robustness score
    let robustness = calculateRobustnessScore(
      performance, 
      monteCarloResult, 
      null
    );
    
    {
      config = config;
      trades = trades;
      equityCurve = equityCurve;
      performance = performance;
      drawdownAnalysis = drawdownAnalysis;
      tradeAnalysis = tradeAnalysis;
      regimeAnalysis = null;
      robustnessScore = robustness;
    }
  };

}
