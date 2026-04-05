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
// ██  MULTI-CHAIN ORACLE INTEGRATION — REAL BACKEND INTELLIGENCE                       ██
// ██                                                                                    ██
// ██  Real-time data feeds from multiple blockchain networks:                          ██
// ██                                                                                    ██
// ██  1. BITCOIN (BTC) — Price, hash rate, mempool, fees                               ██
// ██  2. ETHEREUM (ETH) — Price, gas, DeFi TVL, staking                                ██
// ██  3. SOLANA (SOL) — Price, TPS, validator health                                   ██
// ██  4. ICP — Price, cycles, canister metrics                                         ██
// ██  5. CROSS-CHAIN — Aggregated metrics, correlations                                ██
// ██                                                                                    ██
// ██  Oracle Features:                                                                  ██
// ██  - Multiple data source aggregation                                               ██
// ██  - Price feed validation                                                          ██
// ██  - Staleness detection                                                            ██
// ██  - Outlier filtering                                                              ██
// ██  - TWAP/VWAP calculation                                                          ██
// ██  - Heartbeat monitoring                                                           ██
// ██                                                                                    ██
// ████████████████████████████████████████████████████████████████████████████████████████
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════
  
  let PHI : Float = 1.6180339887498948;
  
  // Staleness thresholds (in nanoseconds)
  let PRICE_STALE_THRESHOLD : Int = 60_000_000_000;     // 60 seconds
  let BLOCK_STALE_THRESHOLD : Int = 600_000_000_000;    // 10 minutes
  let ORACLE_HEARTBEAT : Int = 30_000_000_000;          // 30 seconds
  
  // Outlier detection
  let OUTLIER_DEVIATION_THRESHOLD : Float = 3.0;        // 3 standard deviations
  let MIN_SOURCES_FOR_CONSENSUS : Nat = 3;              // Need at least 3 sources
  
  // TWAP/VWAP windows
  let TWAP_WINDOW_1H : Nat = 3600;                      // 1 hour in seconds
  let TWAP_WINDOW_24H : Nat = 86400;                    // 24 hours
  let VWAP_WINDOW : Nat = 3600;                         // 1 hour

  // ══════════════════════════════════════════════════════════════════════════
  // TYPES — CHAIN SPECIFIC
  // ══════════════════════════════════════════════════════════════════════════

  public type Chain = {
    #Bitcoin;
    #Ethereum;
    #Solana;
    #ICP;
  };

  public type PriceFeed = {
    chain : Chain;
    symbol : Text;
    price : Float;
    timestamp : Int;
    source : Text;
    confidence : Float;          // [0, 1]
    volume24h : Float;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // BITCOIN DATA
  // ─────────────────────────────────────────────────────────────────────────

  public type BitcoinData = {
    price : Float;
    priceChange24h : Float;
    marketCap : Float;
    volume24h : Float;
    dominance : Float;           // BTC dominance %
    
    // Network metrics
    blockHeight : Nat;
    hashRate : Float;            // EH/s
    difficulty : Float;
    mempoolSize : Nat;           // Pending transactions
    mempoolFees : Float;         // Total fees in mempool
    
    // Fee estimation
    fastFee : Float;             // sat/vB for next block
    mediumFee : Float;           // sat/vB for 3 blocks
    slowFee : Float;             // sat/vB for 6+ blocks
    
    // Supply metrics
    circulatingSupply : Float;
    inflationRate : Float;
    halvingBlocksRemaining : Nat;
    
    timestamp : Int;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // ETHEREUM DATA
  // ─────────────────────────────────────────────────────────────────────────

  public type EthereumData = {
    price : Float;
    priceChange24h : Float;
    marketCap : Float;
    volume24h : Float;
    
    // Network metrics
    blockNumber : Nat;
    gasPrice : Float;            // Gwei
    baseFee : Float;             // Gwei
    priorityFee : Float;         // Gwei
    pendingTxCount : Nat;
    
    // Staking metrics
    totalStaked : Float;         // ETH staked
    stakingAPR : Float;          // Annual percentage rate
    validatorCount : Nat;
    
    // DeFi metrics
    totalTVL : Float;            // Total value locked across DeFi
    dexVolume24h : Float;        // DEX trading volume
    lendingTVL : Float;
    
    // EIP-1559 metrics
    burnedEth24h : Float;
    netIssuance24h : Float;      // New ETH - Burned ETH
    
    timestamp : Int;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // SOLANA DATA
  // ─────────────────────────────────────────────────────────────────────────

  public type SolanaData = {
    price : Float;
    priceChange24h : Float;
    marketCap : Float;
    volume24h : Float;
    
    // Network metrics
    slot : Nat;
    epoch : Nat;
    tps : Float;                 // Transactions per second
    averageTps24h : Float;
    
    // Validator metrics
    activeValidators : Nat;
    totalStake : Float;          // SOL staked
    stakingAPY : Float;
    skipRate : Float;            // % of skipped slots
    
    // Fee metrics
    baseFee : Float;             // Lamports
    priorityFee : Float;
    
    // Health metrics
    clusterHealth : Float;       // [0, 1]
    voteSuccessRate : Float;
    
    timestamp : Int;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // ICP DATA
  // ─────────────────────────────────────────────────────────────────────────

  public type ICPData = {
    price : Float;
    priceChange24h : Float;
    marketCap : Float;
    volume24h : Float;
    
    // Network metrics
    totalCanisters : Nat;
    activeCanisters : Nat;
    totalSubnets : Nat;
    
    // Cycles metrics
    cyclesPerXDR : Float;
    cyclesBurnRate : Float;      // Cycles burned per second
    
    // Staking (Neurons)
    totalStakedICP : Float;
    stakingAPY : Float;
    totalNeurons : Nat;
    dissolvedNeurons24h : Nat;
    
    // Governance
    openProposals : Nat;
    totalProposals : Nat;
    participationRate : Float;
    
    // Performance
    messageRate : Float;         // Messages per second
    updateCallRate : Float;
    queryCallRate : Float;
    
    timestamp : Int;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // AGGREGATED TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type AggregatedPrice = {
    symbol : Text;
    price : Float;
    confidence : Float;
    sources : Nat;
    minPrice : Float;
    maxPrice : Float;
    stdDev : Float;
    twap1h : Float;
    twap24h : Float;
    vwap : Float;
    timestamp : Int;
  };

  public type CrossChainMetrics = {
    btcDominance : Float;
    ethDominance : Float;
    totalCryptoMarketCap : Float;
    
    // Correlations (rolling 30-day)
    btcEthCorrelation : Float;
    btcSolCorrelation : Float;
    btcIcpCorrelation : Float;
    ethSolCorrelation : Float;
    ethIcpCorrelation : Float;
    solIcpCorrelation : Float;
    
    // Fear & Greed
    fearGreedIndex : Float;      // 0 = extreme fear, 100 = extreme greed
    
    // Flow metrics
    exchangeInflows24h : Float;
    exchangeOutflows24h : Float;
    netFlow24h : Float;
    
    timestamp : Int;
  };

  public type OracleHealth = {
    chain : Chain;
    isHealthy : Bool;
    lastHeartbeat : Int;
    latency : Nat;               // Milliseconds
    errorCount : Nat;
    staleFeedCount : Nat;
    uptime : Float;              // [0, 1]
  };

  public type OracleState = {
    bitcoin : ?BitcoinData;
    ethereum : ?EthereumData;
    solana : ?SolanaData;
    icp : ?ICPData;
    priceFeeds : [PriceFeed];
    aggregatedPrices : [AggregatedPrice];
    crossChain : ?CrossChainMetrics;
    healthStatus : [OracleHealth];
    lastUpdate : Int;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
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

  func median(arr: [Float]) : Float {
    let n = arr.size();
    if (n == 0) { return 0.0 };
    
    // Simple bubble sort
    var sorted = Array.thaw<Float>(arr);
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
    
    if (n % 2 == 0) {
      (sorted[n / 2 - 1] + sorted[n / 2]) / 2.0
    } else {
      sorted[n / 2]
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 1. PRICE FEED VALIDATION
  // ══════════════════════════════════════════════════════════════════════════

  public func isPriceFeedStale(feed: PriceFeed, currentTime: Int) : Bool {
    currentTime - feed.timestamp > PRICE_STALE_THRESHOLD
  };

  public func validatePriceFeed(
    feed: PriceFeed,
    historicalPrices: [Float],
    currentTime: Int
  ) : (Bool, Float) {
    // Check staleness
    if (isPriceFeedStale(feed, currentTime)) {
      return (false, 0.0);
    };
    
    // Check for outliers
    if (historicalPrices.size() >= 10) {
      let avg = mean(historicalPrices);
      let std = stdDev(historicalPrices);
      
      if (std > 0.0001) {
        let zScore = _abs(feed.price - avg) / std;
        if (zScore > OUTLIER_DEVIATION_THRESHOLD) {
          return (false, 0.5);  // Outlier, low confidence
        };
      };
    };
    
    // Check for zero or negative
    if (feed.price <= 0.0) {
      return (false, 0.0);
    };
    
    // Valid feed
    (true, feed.confidence)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 2. MULTI-SOURCE AGGREGATION
  // ══════════════════════════════════════════════════════════════════════════

  public func aggregatePriceFeeds(
    feeds: [PriceFeed],
    symbol: Text,
    currentTime: Int
  ) : ?AggregatedPrice {
    // Filter for matching symbol and valid feeds
    var validPrices : [Float] = [];
    var validFeeds : [PriceFeed] = [];
    
    for (feed in feeds.vals()) {
      if (feed.symbol == symbol and not isPriceFeedStale(feed, currentTime)) {
        validPrices := Array.append(validPrices, [feed.price]);
        validFeeds := Array.append(validFeeds, [feed]);
      };
    };
    
    if (validPrices.size() < MIN_SOURCES_FOR_CONSENSUS) {
      return null;  // Not enough sources
    };
    
    let avg = mean(validPrices);
    let std = stdDev(validPrices);
    let med = median(validPrices);
    
    // Find min/max
    var minPrice = validPrices[0];
    var maxPrice = validPrices[0];
    for (p in validPrices.vals()) {
      if (p < minPrice) { minPrice := p };
      if (p > maxPrice) { maxPrice := p };
    };
    
    // Confidence based on spread
    let spread = if (avg > 0.001) { (maxPrice - minPrice) / avg } else { 1.0 };
    let confidence = _clamp(1.0 - spread * 10.0, 0.0, 1.0);
    
    // Use median for robustness against manipulation
    let consensusPrice = med;
    
    ?{
      symbol = symbol;
      price = consensusPrice;
      confidence = confidence;
      sources = validFeeds.size();
      minPrice = minPrice;
      maxPrice = maxPrice;
      stdDev = std;
      twap1h = consensusPrice;   // Would be calculated from history
      twap24h = consensusPrice;
      vwap = consensusPrice;
      timestamp = currentTime;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 3. TWAP CALCULATION
  // ══════════════════════════════════════════════════════════════════════════

  public type PricePoint = {
    price : Float;
    timestamp : Int;
  };

  public func calculateTWAP(
    priceHistory: [PricePoint],
    windowSeconds: Nat,
    currentTime: Int
  ) : Float {
    let windowNanos = Int.abs(windowSeconds) * 1_000_000_000;
    let windowStart = currentTime - windowNanos;
    
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    var i = 0;
    while (i < priceHistory.size()) {
      let point = priceHistory[i];
      
      if (point.timestamp >= windowStart) {
        // Weight by time in window
        let weight = Float.fromInt(point.timestamp - windowStart) / Float.fromInt(windowNanos);
        weightedSum += point.price * weight;
        totalWeight += weight;
      };
      
      i += 1;
    };
    
    if (totalWeight > 0.0001) {
      weightedSum / totalWeight
    } else {
      // Fallback to simple average
      if (priceHistory.size() > 0) {
        var sum : Float = 0.0;
        for (p in priceHistory.vals()) { sum += p.price };
        sum / Float.fromInt(priceHistory.size())
      } else { 0.0 }
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 4. VWAP CALCULATION
  // ══════════════════════════════════════════════════════════════════════════

  public type VolumePrice = {
    price : Float;
    volume : Float;
    timestamp : Int;
  };

  public func calculateVWAP(
    volumePrices: [VolumePrice],
    windowSeconds: Nat,
    currentTime: Int
  ) : Float {
    let windowNanos = Int.abs(windowSeconds) * 1_000_000_000;
    let windowStart = currentTime - windowNanos;
    
    var volumeWeightedSum : Float = 0.0;
    var totalVolume : Float = 0.0;
    
    for (vp in volumePrices.vals()) {
      if (vp.timestamp >= windowStart) {
        volumeWeightedSum += vp.price * vp.volume;
        totalVolume += vp.volume;
      };
    };
    
    if (totalVolume > 0.0001) {
      volumeWeightedSum / totalVolume
    } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 5. CORRELATION CALCULATION
  // ══════════════════════════════════════════════════════════════════════════

  public func calculateCorrelation(
    returns1: [Float],
    returns2: [Float]
  ) : Float {
    let n = if (returns1.size() < returns2.size()) { returns1.size() } else { returns2.size() };
    if (n < 10) { return 0.0 };  // Need minimum data points
    
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
    
    _clamp(cov / (std1 * std2), -1.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 6. FEAR & GREED INDEX
  // ══════════════════════════════════════════════════════════════════════════

  public func calculateFearGreedIndex(
    btcPriceChange24h: Float,
    btcVolume24h: Float,
    btcDominance: Float,
    socialSentiment: Float,      // [-1, 1]
    volatility: Float
  ) : Float {
    // Components (each normalized to [0, 100])
    
    // Price momentum (25%)
    let momentum = _clamp((btcPriceChange24h + 0.1) * 500.0, 0.0, 100.0);
    
    // Volume (25%)
    let volumeScore = _clamp(btcVolume24h / 50_000_000_000.0 * 100.0, 0.0, 100.0);
    
    // BTC dominance (15%) - higher dominance = more fear
    let dominanceScore = 100.0 - btcDominance;
    
    // Social sentiment (20%)
    let sentimentScore = (socialSentiment + 1.0) * 50.0;
    
    // Volatility (15%) - higher volatility = more fear
    let volatilityScore = _clamp(100.0 - volatility * 1000.0, 0.0, 100.0);
    
    // Weighted average
    let index = momentum * 0.25 + 
                volumeScore * 0.25 + 
                dominanceScore * 0.15 + 
                sentimentScore * 0.20 + 
                volatilityScore * 0.15;
    
    _clamp(index, 0.0, 100.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 7. ORACLE HEALTH MONITORING
  // ══════════════════════════════════════════════════════════════════════════

  public func checkOracleHealth(
    chain: Chain,
    lastHeartbeat: Int,
    currentTime: Int,
    errorCount: Nat,
    totalRequests: Nat
  ) : OracleHealth {
    let timeSinceHeartbeat = currentTime - lastHeartbeat;
    let isHealthy = timeSinceHeartbeat < ORACLE_HEARTBEAT * 2 and errorCount < 10;
    
    let uptime = if (totalRequests > 0) {
      1.0 - Float.fromInt(errorCount) / Float.fromInt(totalRequests)
    } else { 1.0 };
    
    {
      chain = chain;
      isHealthy = isHealthy;
      lastHeartbeat = lastHeartbeat;
      latency = 0;  // Would be measured
      errorCount = errorCount;
      staleFeedCount = 0;
      uptime = _clamp(uptime, 0.0, 1.0);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 8. BITCOIN-SPECIFIC METRICS
  // ══════════════════════════════════════════════════════════════════════════

  public func estimateBitcoinFee(
    mempoolSize: Nat,
    blockUtilization: Float,
    recentFees: [Float]
  ) : (Float, Float, Float) {
    // Base fee estimation from mempool congestion
    let congestionFactor = Float.fromInt(mempoolSize) / 100000.0;
    
    let baseFee = mean(recentFees);
    
    // Fast: next block (multiply by congestion)
    let fastFee = baseFee * (1.0 + congestionFactor * 2.0);
    
    // Medium: 3 blocks
    let mediumFee = baseFee * (1.0 + congestionFactor);
    
    // Slow: 6+ blocks
    let slowFee = baseFee * 0.5;
    
    (fastFee, mediumFee, slowFee)
  };

  public func calculateHalvingProgress(
    currentBlockHeight: Nat
  ) : (Nat, Float) {
    // Bitcoin halving occurs every 210,000 blocks
    let HALVING_INTERVAL : Nat = 210000;
    
    let blocksInCurrentEra = currentBlockHeight % HALVING_INTERVAL;
    let blocksRemaining = HALVING_INTERVAL - blocksInCurrentEra;
    let progress = Float.fromInt(blocksInCurrentEra) / Float.fromInt(HALVING_INTERVAL);
    
    (blocksRemaining, progress)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 9. ETHEREUM-SPECIFIC METRICS
  // ══════════════════════════════════════════════════════════════════════════

  public func estimateEthereumGas(
    baseFee: Float,
    pendingTxCount: Nat,
    recentPriorityFees: [Float]
  ) : (Float, Float, Float) {
    // Priority fee estimation
    let avgPriorityFee = mean(recentPriorityFees);
    let congestionFactor = Float.fromInt(pendingTxCount) / 200000.0;
    
    // Fast: next block
    let fastPriority = avgPriorityFee * (1.5 + congestionFactor);
    let fastTotal = baseFee + fastPriority;
    
    // Medium: few blocks
    let mediumPriority = avgPriorityFee * (1.0 + congestionFactor * 0.5);
    let mediumTotal = baseFee + mediumPriority;
    
    // Slow: when convenient
    let slowPriority = avgPriorityFee * 0.8;
    let slowTotal = baseFee + slowPriority;
    
    (fastTotal, mediumTotal, slowTotal)
  };

  public func calculateEthBurnRate(
    baseFee: Float,
    gasUsed: Float,
    blockTime: Float
  ) : Float {
    // ETH burned per second = baseFee (Gwei) × gasUsed / blockTime
    let burnedPerBlock = baseFee * gasUsed / 1_000_000_000.0;  // Convert Gwei to ETH
    burnedPerBlock / blockTime
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 10. CROSS-CHAIN ANALYTICS
  // ══════════════════════════════════════════════════════════════════════════

  public func calculateCrossChainMetrics(
    btcData: BitcoinData,
    ethData: EthereumData,
    solData: SolanaData,
    icpData: ICPData,
    btcReturns: [Float],
    ethReturns: [Float],
    solReturns: [Float],
    icpReturns: [Float],
    currentTime: Int
  ) : CrossChainMetrics {
    // Total market cap
    let totalMarketCap = btcData.marketCap + ethData.marketCap + 
                         solData.marketCap + icpData.marketCap;
    
    // Dominance
    let btcDominance = if (totalMarketCap > 0.0) {
      btcData.marketCap / totalMarketCap * 100.0
    } else { 0.0 };
    
    let ethDominance = if (totalMarketCap > 0.0) {
      ethData.marketCap / totalMarketCap * 100.0
    } else { 0.0 };
    
    // Correlations
    let btcEthCorr = calculateCorrelation(btcReturns, ethReturns);
    let btcSolCorr = calculateCorrelation(btcReturns, solReturns);
    let btcIcpCorr = calculateCorrelation(btcReturns, icpReturns);
    let ethSolCorr = calculateCorrelation(ethReturns, solReturns);
    let ethIcpCorr = calculateCorrelation(ethReturns, icpReturns);
    let solIcpCorr = calculateCorrelation(solReturns, icpReturns);
    
    // Fear & Greed (simplified)
    let avgVolatility = stdDev(btcReturns);
    let fearGreed = calculateFearGreedIndex(
      btcData.priceChange24h,
      btcData.volume24h,
      btcDominance,
      0.0,  // Would come from social data
      avgVolatility
    );
    
    {
      btcDominance = btcDominance;
      ethDominance = ethDominance;
      totalCryptoMarketCap = totalMarketCap;
      btcEthCorrelation = btcEthCorr;
      btcSolCorrelation = btcSolCorr;
      btcIcpCorrelation = btcIcpCorr;
      ethSolCorrelation = ethSolCorr;
      ethIcpCorrelation = ethIcpCorr;
      solIcpCorrelation = solIcpCorr;
      fearGreedIndex = fearGreed;
      exchangeInflows24h = 0.0;   // Would come from on-chain data
      exchangeOutflows24h = 0.0;
      netFlow24h = 0.0;
      timestamp = currentTime;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 11. INITIALIZE ORACLE STATE
  // ══════════════════════════════════════════════════════════════════════════

  public func initOracleState() : OracleState {
    {
      bitcoin = null;
      ethereum = null;
      solana = null;
      icp = null;
      priceFeeds = [];
      aggregatedPrices = [];
      crossChain = null;
      healthStatus = [];
      lastUpdate = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 12. UPDATE ORACLE STATE
  // ══════════════════════════════════════════════════════════════════════════

  public func updateOracleState(
    state: OracleState,
    newFeeds: [PriceFeed],
    currentTime: Int
  ) : OracleState {
    // Add new feeds
    var allFeeds = Array.append(state.priceFeeds, newFeeds);
    
    // Remove stale feeds
    allFeeds := Array.filter<PriceFeed>(allFeeds, func(f) {
      not isPriceFeedStale(f, currentTime)
    });
    
    // Aggregate prices
    var aggregated : [AggregatedPrice] = [];
    let symbols = ["BTC", "ETH", "SOL", "ICP"];
    for (symbol in symbols.vals()) {
      switch (aggregatePriceFeeds(allFeeds, symbol, currentTime)) {
        case (?agg) { aggregated := Array.append(aggregated, [agg]) };
        case (null) {};
      };
    };
    
    {
      bitcoin = state.bitcoin;
      ethereum = state.ethereum;
      solana = state.solana;
      icp = state.icp;
      priceFeeds = allFeeds;
      aggregatedPrices = aggregated;
      crossChain = state.crossChain;
      healthStatus = state.healthStatus;
      lastUpdate = currentTime;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 13. GET BEST PRICE
  // ══════════════════════════════════════════════════════════════════════════

  public func getBestPrice(
    state: OracleState,
    symbol: Text
  ) : ?Float {
    // First try aggregated prices
    for (agg in state.aggregatedPrices.vals()) {
      if (agg.symbol == symbol and agg.confidence > 0.5) {
        return ?agg.price;
      };
    };
    
    // Fallback to chain-specific data
    switch (symbol) {
      case ("BTC") {
        switch (state.bitcoin) {
          case (?btc) { ?btc.price };
          case (null) { null };
        }
      };
      case ("ETH") {
        switch (state.ethereum) {
          case (?eth) { ?eth.price };
          case (null) { null };
        }
      };
      case ("SOL") {
        switch (state.solana) {
          case (?sol) { ?sol.price };
          case (null) { null };
        }
      };
      case ("ICP") {
        switch (state.icp) {
          case (?icp) { ?icp.price };
          case (null) { null };
        }
      };
      case (_) { null };
    }
  };

}
