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

// ════════════════════════════════════════════════════════════════════════════════════════
// ████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                    ██
// ██  TRADING DECISION ENGINE — REAL BACKEND INTELLIGENCE                              ██
// ██                                                                                    ██
// ██  This module implements ACTUAL trading decision logic:                            ██
// ██                                                                                    ██
// ██  1. KELLY CRITERION — Optimal position sizing                                     ██
// ██     f* = (p × b - q) / b where p = win prob, b = win/loss ratio, q = 1-p         ██
// ██                                                                                    ██
// ██  2. ORDER FLOW IMBALANCE (OFI) — Market microstructure signal                     ██
// ██     OFI = ΔBid_qty + ΔAsk_qty weighted by price impact                           ██
// ██                                                                                    ██
// ██  3. VWCS (Volume Weighted Cost Spread) — Execution cost estimation                ██
// ██     VWCS = Σ(volume_i × spread_i) / Σ(volume_i)                                  ██
// ██                                                                                    ██
// ██  4. MARKET REGIME DETECTION — Trending vs Mean-Reverting                          ██
// ██     Hurst exponent, volatility regime, liquidity regime                          ██
// ██                                                                                    ██
// ██  5. COHERENCE GATE — Only execute when organism is synchronized                   ██
// ██     Requires coherenceC > threshold AND psychology score > threshold             ██
// ██                                                                                    ██
// ████████████████████████████████████████████████████████████████████████████████████████
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";

module {

  // ══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════
  
  let PHI : Float = 1.6180339887498948;
  let PHI_INV : Float = 0.6180339887498948;
  
  // Risk management constants
  let MAX_KELLY_FRACTION : Float = 0.25;     // Never bet more than 25% Kelly
  let MIN_COHERENCE_TO_TRADE : Float = 0.6;  // Minimum coherence to execute
  let MIN_PSYCHOLOGY_SCORE : Float = 0.5;    // Minimum psychological fitness
  let MAX_DAILY_DRAWDOWN : Float = 0.05;     // 5% max daily drawdown
  let MAX_POSITION_SIZE : Float = 0.10;      // 10% max per position
  
  // OFI constants
  let OFI_LOOKBACK : Nat = 20;               // Beats to look back for OFI
  let OFI_THRESHOLD_BUY : Float = 0.3;       // OFI > 0.3 = buy signal
  let OFI_THRESHOLD_SELL : Float = -0.3;     // OFI < -0.3 = sell signal
  
  // VWCS constants
  let MAX_ACCEPTABLE_VWCS : Float = 0.005;   // 0.5% max execution cost
  
  // Regime detection
  let HURST_TRENDING : Float = 0.55;         // H > 0.55 = trending
  let HURST_MEAN_REVERTING : Float = 0.45;   // H < 0.45 = mean reverting

  // ══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type OrderBook = {
    bidPrices : [Float];     // Best bid to worse
    bidSizes : [Float];      // Quantities at each level
    askPrices : [Float];     // Best ask to worse
    askSizes : [Float];      // Quantities at each level
    timestamp : Nat;
  };

  public type Trade = {
    price : Float;
    size : Float;
    side : TradeSide;
    timestamp : Nat;
  };

  public type TradeSide = {
    #Buy;
    #Sell;
  };

  public type MarketData = {
    symbol : Text;
    currentPrice : Float;
    priceHistory : [Float];        // Last N prices
    volumeHistory : [Float];       // Last N volumes
    orderBook : OrderBook;
    recentTrades : [Trade];
    timestamp : Nat;
  };

  public type KellyResult = {
    winProbability : Float;        // p
    winLossRatio : Float;          // b = avg_win / avg_loss
    optimalFraction : Float;       // f* = (pb - q) / b
    adjustedFraction : Float;      // Half-Kelly or capped
    positionSize : Float;          // Actual position to take
    confidence : Float;            // How confident in this calculation
  };

  public type OFIResult = {
    ofi : Float;                   // Order flow imbalance [-1, 1]
    bidPressure : Float;           // Buying pressure
    askPressure : Float;           // Selling pressure
    signal : OFISignal;            // Buy/Sell/Neutral
    strength : Float;              // Signal strength [0, 1]
  };

  public type OFISignal = {
    #StrongBuy;
    #Buy;
    #Neutral;
    #Sell;
    #StrongSell;
  };

  public type VWCSResult = {
    vwcs : Float;                  // Volume weighted cost spread
    bidLiquidity : Float;          // Total bid liquidity
    askLiquidity : Float;          // Total ask liquidity
    estimatedSlippage : Float;     // Expected slippage for target size
    executionQuality : Float;      // 1 = excellent, 0 = poor
  };

  public type MarketRegime = {
    hurstExponent : Float;         // H < 0.5 mean reverting, H > 0.5 trending
    regimeType : RegimeType;
    volatility : Float;            // Current volatility
    volatileRegime : VolatilityRegime;
    liquidityScore : Float;        // Market liquidity [0, 1]
  };

  public type RegimeType = {
    #Trending;
    #MeanReverting;
    #Random;
  };

  public type VolatilityRegime = {
    #Low;
    #Normal;
    #High;
    #Crisis;
  };

  public type TradeDecision = {
    action : TradeAction;
    symbol : Text;
    size : Float;                  // Position size (fraction of capital)
    entryPrice : Float;            // Target entry
    stopLoss : Float;              // Stop loss price
    takeProfit : Float;            // Take profit price
    confidence : Float;            // Decision confidence [0, 1]
    reasoning : [Text];            // Why this decision
    gates : GateStatus;            // Which gates passed/failed
  };

  public type TradeAction = {
    #Buy;
    #Sell;
    #Hold;
    #Close;
    #ScaleIn;
    #ScaleOut;
  };

  public type GateStatus = {
    coherenceGate : Bool;          // Organism coherent enough?
    psychologyGate : Bool;         // Psychologically fit?
    riskGate : Bool;               // Within risk limits?
    liquidityGate : Bool;          // Sufficient liquidity?
    regimeGate : Bool;             // Favorable market regime?
    allGatesPassed : Bool;
  };

  public type OrganismState = {
    coherence : Float;             // Global coherence [0, 1]
    psychologyScore : Float;       // From BehavioralEconomics
    fearLevel : Float;             // Current fear
    greedLevel : Float;            // Current greed
    disciplineLevel : Float;       // Rule adherence
    currentDrawdown : Float;       // Today's P&L
    capital : Float;               // Available capital
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 1. KELLY CRITERION — Optimal Position Sizing
  // ══════════════════════════════════════════════════════════════════════════
  //
  // The Kelly criterion maximizes long-term growth rate.
  // f* = (p × b - q) / b
  //
  // Where:
  //   p = probability of winning
  //   q = probability of losing = 1 - p
  //   b = ratio of average win to average loss
  //
  // Half-Kelly (f*/2) is often used to reduce variance.
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // Calculate Kelly fraction from historical trades
  public func calculateKelly(
    winningTrades : [Float],      // Array of winning trade P&Ls
    losingTrades : [Float],       // Array of losing trade P&Ls (positive values)
    currentCapital : Float
  ) : KellyResult {
    let totalTrades = winningTrades.size() + losingTrades.size();
    
    // Not enough data
    if (totalTrades < 10) {
      return {
        winProbability = 0.5;
        winLossRatio = 1.0;
        optimalFraction = 0.0;
        adjustedFraction = 0.0;
        positionSize = 0.0;
        confidence = 0.0;
      };
    };
    
    // Win probability
    let p = Float.fromInt(winningTrades.size()) / Float.fromInt(totalTrades);
    let q = 1.0 - p;
    
    // Average win and loss
    var avgWin : Float = 0.0;
    for (w in winningTrades.vals()) { avgWin += w; };
    avgWin := if (winningTrades.size() > 0) { 
      avgWin / Float.fromInt(winningTrades.size()) 
    } else { 0.0 };
    
    var avgLoss : Float = 0.0;
    for (l in losingTrades.vals()) { avgLoss += l; };
    avgLoss := if (losingTrades.size() > 0) { 
      avgLoss / Float.fromInt(losingTrades.size()) 
    } else { 1.0 };
    
    // Win/loss ratio
    let b = if (avgLoss > 0.001) { avgWin / avgLoss } else { 1.0 };
    
    // Kelly formula: f* = (pb - q) / b
    let fStar = if (b > 0.001) { (p * b - q) / b } else { 0.0 };
    
    // Apply half-Kelly and caps for safety
    let halfKelly = fStar / 2.0;
    let adjusted = _clamp(halfKelly, 0.0, MAX_KELLY_FRACTION);
    
    // Position size in capital terms
    let posSize = _clamp(adjusted, 0.0, MAX_POSITION_SIZE);
    
    // Confidence based on sample size and consistency
    let sampleConfidence = Float.min(1.0, Float.fromInt(totalTrades) / 100.0);
    let edgeConfidence = if (fStar > 0.0) { Float.min(1.0, fStar * 5.0) } else { 0.0 };
    let confidence = sampleConfidence * edgeConfidence;
    
    {
      winProbability = p;
      winLossRatio = b;
      optimalFraction = fStar;
      adjustedFraction = adjusted;
      positionSize = posSize;
      confidence = confidence;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 2. ORDER FLOW IMBALANCE (OFI) — Market Microstructure Signal
  // ══════════════════════════════════════════════════════════════════════════
  //
  // OFI measures the imbalance between buy and sell pressure in the order book.
  // Positive OFI = more buying pressure = price likely to rise
  // Negative OFI = more selling pressure = price likely to fall
  //
  // OFI = Σ(ΔBid_volume × sign(ΔBid_price)) - Σ(ΔAsk_volume × sign(ΔAsk_price))
  // ══════════════════════════════════════════════════════════════════════════

  public func calculateOFI(
    currentBook : OrderBook,
    previousBook : OrderBook
  ) : OFIResult {
    // Calculate bid pressure change
    var bidPressure : Float = 0.0;
    let bidLevels = Float.min(Float.fromInt(currentBook.bidPrices.size()), 5.0);
    var i = 0;
    while (i < Int.abs(Float.toInt(bidLevels))) {
      let currentBid = if (i < currentBook.bidSizes.size()) { currentBook.bidSizes[i] } else { 0.0 };
      let prevBid = if (i < previousBook.bidSizes.size()) { previousBook.bidSizes[i] } else { 0.0 };
      let deltaBid = currentBid - prevBid;
      
      // Weight by proximity to best bid (closer = more important)
      let weight = 1.0 / Float.fromInt(i + 1);
      bidPressure += deltaBid * weight;
      i += 1;
    };
    
    // Calculate ask pressure change
    var askPressure : Float = 0.0;
    let askLevels = Float.min(Float.fromInt(currentBook.askPrices.size()), 5.0);
    i := 0;
    while (i < Int.abs(Float.toInt(askLevels))) {
      let currentAsk = if (i < currentBook.askSizes.size()) { currentBook.askSizes[i] } else { 0.0 };
      let prevAsk = if (i < previousBook.askSizes.size()) { previousBook.askSizes[i] } else { 0.0 };
      let deltaAsk = currentAsk - prevAsk;
      
      let weight = 1.0 / Float.fromInt(i + 1);
      askPressure += deltaAsk * weight;
      i += 1;
    };
    
    // OFI = bid pressure - ask pressure (normalized)
    let totalPressure = Float.abs(bidPressure) + Float.abs(askPressure);
    let ofi = if (totalPressure > 0.001) {
      (bidPressure - askPressure) / totalPressure
    } else { 0.0 };
    
    // Determine signal
    let signal : OFISignal = if (ofi > 0.6) {
      #StrongBuy
    } else if (ofi > OFI_THRESHOLD_BUY) {
      #Buy
    } else if (ofi < -0.6) {
      #StrongSell
    } else if (ofi < OFI_THRESHOLD_SELL) {
      #Sell
    } else {
      #Neutral
    };
    
    let strength = Float.abs(ofi);
    
    {
      ofi = ofi;
      bidPressure = bidPressure;
      askPressure = askPressure;
      signal = signal;
      strength = strength;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 3. VWCS — Volume Weighted Cost Spread
  // ══════════════════════════════════════════════════════════════════════════
  //
  // VWCS estimates the cost of executing a trade of given size.
  // It accounts for:
  //   - Bid-ask spread
  //   - Market depth (slippage through the book)
  //   - Volume at each price level
  //
  // VWCS = Σ(volume_i × spread_i) / Σ(volume_i)
  // ══════════════════════════════════════════════════════════════════════════

  public func calculateVWCS(
    book : OrderBook,
    tradeSize : Float,
    side : TradeSide
  ) : VWCSResult {
    // Basic spread at top of book
    let bestBid = if (book.bidPrices.size() > 0) { book.bidPrices[0] } else { 0.0 };
    let bestAsk = if (book.askPrices.size() > 0) { book.askPrices[0] } else { 0.0 };
    let midPrice = (bestBid + bestAsk) / 2.0;
    
    if (midPrice < 0.001) {
      return {
        vwcs = 1.0;
        bidLiquidity = 0.0;
        askLiquidity = 0.0;
        estimatedSlippage = 1.0;
        executionQuality = 0.0;
      };
    };
    
    // Calculate total liquidity
    var bidLiq : Float = 0.0;
    for (size in book.bidSizes.vals()) { bidLiq += size; };
    var askLiq : Float = 0.0;
    for (size in book.askSizes.vals()) { askLiq += size; };
    
    // Estimate slippage by walking through the book
    var remainingSize = tradeSize;
    var totalCost : Float = 0.0;
    var filledSize : Float = 0.0;
    
    let (prices, sizes) = switch (side) {
      case (#Buy) { (book.askPrices, book.askSizes) };
      case (#Sell) { (book.bidPrices, book.bidSizes) };
    };
    
    var level = 0;
    while (level < prices.size() and remainingSize > 0.001) {
      let levelSize = if (level < sizes.size()) { sizes[level] } else { 0.0 };
      let fillAtLevel = Float.min(remainingSize, levelSize);
      let levelPrice = prices[level];
      
      totalCost += fillAtLevel * levelPrice;
      filledSize += fillAtLevel;
      remainingSize -= fillAtLevel;
      level += 1;
    };
    
    // Calculate VWAP (volume weighted average price)
    let vwap = if (filledSize > 0.001) { totalCost / filledSize } else { midPrice };
    
    // Slippage as percentage from mid price
    let slippage = Float.abs(vwap - midPrice) / midPrice;
    
    // VWCS includes spread + slippage
    let basicSpread = (bestAsk - bestBid) / midPrice;
    let vwcs = basicSpread + slippage;
    
    // Execution quality: 1 if vwcs < 0.001, 0 if vwcs > 0.01
    let execQuality = _clamp(1.0 - vwcs * 100.0, 0.0, 1.0);
    
    {
      vwcs = vwcs;
      bidLiquidity = bidLiq;
      askLiquidity = askLiq;
      estimatedSlippage = slippage;
      executionQuality = execQuality;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 4. MARKET REGIME DETECTION
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Detect current market regime to adjust strategy:
  //   - Trending (H > 0.5): Follow momentum
  //   - Mean-reverting (H < 0.5): Fade moves
  //   - Random (H ≈ 0.5): No edge, stay flat
  //
  // Uses simplified Hurst exponent approximation:
  //   H ≈ log(R/S) / log(n) where R/S is rescaled range
  // ══════════════════════════════════════════════════════════════════════════

  public func detectRegime(
    priceHistory : [Float],
    volumeHistory : [Float]
  ) : MarketRegime {
    let n = priceHistory.size();
    
    if (n < 20) {
      return {
        hurstExponent = 0.5;
        regimeType = #Random;
        volatility = 0.0;
        volatileRegime = #Normal;
        liquidityScore = 0.5;
      };
    };
    
    // Calculate returns
    var returns : [Float] = [];
    var i = 1;
    while (i < n) {
      let prevPrice = priceHistory[i - 1];
      let curPrice = priceHistory[i];
      if (prevPrice > 0.001) {
        returns := Array.append(returns, [(curPrice - prevPrice) / prevPrice]);
      };
      i += 1;
    };
    
    // Calculate mean and standard deviation of returns
    var mean : Float = 0.0;
    for (r in returns.vals()) { mean += r; };
    mean := mean / Float.fromInt(returns.size());
    
    var variance : Float = 0.0;
    for (r in returns.vals()) {
      variance += (r - mean) * (r - mean);
    };
    variance := variance / Float.fromInt(returns.size());
    let volatility = Float.sqrt(variance);
    
    // Simplified Hurst exponent (using variance ratio)
    // True Hurst would use R/S analysis, this is an approximation
    var autoCorr : Float = 0.0;
    if (returns.size() > 1) {
      var lag1 = 1;
      while (lag1 < returns.size()) {
        autoCorr += returns[lag1] * returns[lag1 - 1];
        lag1 += 1;
      };
      autoCorr := autoCorr / Float.fromInt(returns.size() - 1);
    };
    
    // Map autocorrelation to Hurst-like measure
    // Positive autocorr = trending (H > 0.5)
    // Negative autocorr = mean reverting (H < 0.5)
    let hurstApprox = 0.5 + autoCorr * 0.5;
    let hurst = _clamp(hurstApprox, 0.0, 1.0);
    
    // Determine regime type
    let regime : RegimeType = if (hurst > HURST_TRENDING) {
      #Trending
    } else if (hurst < HURST_MEAN_REVERTING) {
      #MeanReverting
    } else {
      #Random
    };
    
    // Volatility regime
    let volRegime : VolatilityRegime = if (volatility > 0.05) {
      #Crisis
    } else if (volatility > 0.02) {
      #High
    } else if (volatility > 0.005) {
      #Normal
    } else {
      #Low
    };
    
    // Liquidity score from volume
    var avgVolume : Float = 0.0;
    for (v in volumeHistory.vals()) { avgVolume += v; };
    avgVolume := avgVolume / Float.fromInt(volumeHistory.size());
    let liqScore = _clamp(avgVolume / 1000000.0, 0.0, 1.0);  // Normalize to millions
    
    {
      hurstExponent = hurst;
      regimeType = regime;
      volatility = volatility;
      volatileRegime = volRegime;
      liquidityScore = liqScore;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 5. COHERENCE GATE — Only trade when organism is synchronized
  // ══════════════════════════════════════════════════════════════════════════

  public func checkGates(
    organism : OrganismState,
    regime : MarketRegime,
    vwcs : VWCSResult,
    kelly : KellyResult
  ) : GateStatus {
    // Gate 1: Coherence must be above threshold
    let coherenceOK = organism.coherence >= MIN_COHERENCE_TO_TRADE;
    
    // Gate 2: Psychology score must be acceptable
    let psychOK = organism.psychologyScore >= MIN_PSYCHOLOGY_SCORE;
    
    // Gate 3: Risk limits not exceeded
    let riskOK = organism.currentDrawdown < MAX_DAILY_DRAWDOWN and
                 kelly.adjustedFraction <= MAX_KELLY_FRACTION;
    
    // Gate 4: Sufficient liquidity
    let liquidityOK = vwcs.executionQuality > 0.5 and
                      vwcs.vwcs < MAX_ACCEPTABLE_VWCS;
    
    // Gate 5: Favorable or neutral regime (not crisis)
    let regimeOK = switch (regime.volatileRegime) {
      case (#Crisis) { false };
      case (_) { true };
    };
    
    let allPassed = coherenceOK and psychOK and riskOK and liquidityOK and regimeOK;
    
    {
      coherenceGate = coherenceOK;
      psychologyGate = psychOK;
      riskGate = riskOK;
      liquidityGate = liquidityOK;
      regimeGate = regimeOK;
      allGatesPassed = allPassed;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 6. INTEGRATED TRADING DECISION
  // ══════════════════════════════════════════════════════════════════════════

  public func makeDecision(
    market : MarketData,
    previousBook : OrderBook,
    organism : OrganismState,
    winningTrades : [Float],
    losingTrades : [Float]
  ) : TradeDecision {
    // Calculate all signals
    let kelly = calculateKelly(winningTrades, losingTrades, organism.capital);
    let ofi = calculateOFI(market.orderBook, previousBook);
    let vwcs = calculateVWCS(market.orderBook, kelly.positionSize * organism.capital, #Buy);
    let regime = detectRegime(market.priceHistory, market.volumeHistory);
    
    // Check gates
    let gates = checkGates(organism, regime, vwcs, kelly);
    
    var reasons : [Text] = [];
    
    // If gates don't pass, hold
    if (not gates.allGatesPassed) {
      if (not gates.coherenceGate) { 
        reasons := Array.append(reasons, ["Coherence too low: " # Float.toText(organism.coherence)]); 
      };
      if (not gates.psychologyGate) { 
        reasons := Array.append(reasons, ["Psychology score too low"]); 
      };
      if (not gates.riskGate) { 
        reasons := Array.append(reasons, ["Risk limit exceeded"]); 
      };
      if (not gates.liquidityGate) { 
        reasons := Array.append(reasons, ["Insufficient liquidity"]); 
      };
      if (not gates.regimeGate) { 
        reasons := Array.append(reasons, ["Unfavorable market regime"]); 
      };
      
      return {
        action = #Hold;
        symbol = market.symbol;
        size = 0.0;
        entryPrice = market.currentPrice;
        stopLoss = 0.0;
        takeProfit = 0.0;
        confidence = 0.0;
        reasoning = reasons;
        gates = gates;
      };
    };
    
    // Gates passed — make decision based on signals
    let action : TradeAction = switch (ofi.signal) {
      case (#StrongBuy) { #Buy };
      case (#Buy) { #Buy };
      case (#StrongSell) { #Sell };
      case (#Sell) { #Sell };
      case (#Neutral) { #Hold };
    };
    
    // Adjust size based on regime
    let regimeMultiplier = switch (regime.regimeType) {
      case (#Trending) { 1.2 };      // Increase size in trends
      case (#MeanReverting) { 0.8 }; // Decrease size in choppy markets
      case (#Random) { 0.5 };        // Reduce significantly in random regime
    };
    
    // Adjust for fear/greed
    let psychMultiplier = 1.0 - organism.fearLevel * 0.3 + organism.greedLevel * 0.1;
    
    // Final position size
    let finalSize = _clamp(
      kelly.adjustedFraction * regimeMultiplier * psychMultiplier,
      0.0,
      MAX_POSITION_SIZE
    );
    
    // Calculate stop loss and take profit
    // Stop: 2 × ATR (approximated by volatility × price)
    let atr = regime.volatility * market.currentPrice * 14.0;  // 14-period approximation
    let stopDistance = atr * 2.0;
    let profitDistance = atr * 3.0;  // 1.5:1 risk/reward
    
    let (stopLoss, takeProfit) = switch (action) {
      case (#Buy) { 
        (market.currentPrice - stopDistance, market.currentPrice + profitDistance) 
      };
      case (#Sell) { 
        (market.currentPrice + stopDistance, market.currentPrice - profitDistance) 
      };
      case (_) { (0.0, 0.0) };
    };
    
    // Build reasoning
    reasons := Array.append(reasons, ["OFI signal: " # ofiSignalToText(ofi.signal)]);
    reasons := Array.append(reasons, ["Regime: " # regimeToText(regime.regimeType)]);
    reasons := Array.append(reasons, ["Kelly fraction: " # Float.toText(kelly.adjustedFraction)]);
    reasons := Array.append(reasons, ["Coherence: " # Float.toText(organism.coherence)]);
    
    // Confidence combines all signal confidences
    let confidence = (kelly.confidence + ofi.strength + vwcs.executionQuality + 
                     organism.coherence + organism.psychologyScore) / 5.0;
    
    {
      action = action;
      symbol = market.symbol;
      size = finalSize;
      entryPrice = market.currentPrice;
      stopLoss = stopLoss;
      takeProfit = takeProfit;
      confidence = confidence;
      reasoning = reasons;
      gates = gates;
    }
  };

  // Helper functions
  func ofiSignalToText(signal : OFISignal) : Text {
    switch (signal) {
      case (#StrongBuy) { "StrongBuy" };
      case (#Buy) { "Buy" };
      case (#Neutral) { "Neutral" };
      case (#Sell) { "Sell" };
      case (#StrongSell) { "StrongSell" };
    }
  };

  func regimeToText(regime : RegimeType) : Text {
    switch (regime) {
      case (#Trending) { "Trending" };
      case (#MeanReverting) { "MeanReverting" };
      case (#Random) { "Random" };
    }
  };

}
