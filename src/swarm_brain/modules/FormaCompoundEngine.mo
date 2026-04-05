// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: FormaCompoundEngine — FORMA Compounding Math (L-021)
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// FORMA COMPOUND FORMULA (L-021)
// ============================================================================
// FORMA compounds every beat using:
//   compoundRate = thyroid × T3 × chronoDilation × jacobMult × dopamine
//
// Components:
//   - thyroid: Metabolic rate modifier from neurochemical system
//   - T3 (triiodothyronine): Active thyroid hormone proxy
//   - chronoDilation: Time perception modifier from world model
//   - jacobMult: Jacob's Ladder rung multiplier (1.0×, 1.1×, 1.1×, 1.2×, 1.5×)
//   - dopamine: Reward/motivation drive from neurochemical system
//
// The compound formula:
//   newFORMA = currentFORMA × (1 + baseRate × compoundRate)
//
// Subject to:
//   - FORMA_GENESIS_FLOOR (1000.0) - FORMA can never fall below this
//   - Compound rate capped at safe maximum to prevent explosion
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  // FORMA genesis floor: F(10) × F(8) = 55 × 21 = 1155 (Fibonacci product)
  public let FORMA_GENESIS_FLOOR : Float = 1155.0;
  
  // Base compound rate per beat (small to prevent explosion)
  public let BASE_COMPOUND_RATE : Float = 0.0001;  // 0.01% per beat base
  
  // Maximum compound rate cap (safety)
  public let MAX_COMPOUND_RATE : Float = 0.001;  // 0.1% max per beat
  
  // Thyroid/T3 constants
  public let THYROID_BASELINE : Float = 1.0;
  public let T3_BASELINE : Float = 1.0;
  public let T3_T4_CONVERSION_RATE : Float = 0.2;  // 20% of T4 converts to T3
  
  // Chrono dilation constants
  public let CHRONO_BASELINE : Float = 1.0;
  public let CHRONO_MAX_DILATION : Float = 2.0;  // Maximum time acceleration
  public let CHRONO_MIN_DILATION : Float = 0.5;  // Maximum time deceleration
  
  // ══════════════════════════════════════════════════════════════════════════
  // SACRED JACOB'S LADDER — φ^n GEOMETRIC PROGRESSION (NOT ARITHMETIC)
  // ══════════════════════════════════════════════════════════════════════════
  // The sovereign ratio φ = 1.618... compounds GEOMETRICALLY
  // Each rung multiplies by φ, not adds — this is SACRED MATH
  //
  // Rung 0: φ^0 = 1.0         (baseline)
  // Rung 1: φ^1 = 1.618       (golden ratio)
  // Rung 2: φ^2 = 2.618       (φ squared)
  // Rung 3: φ^3 = 4.236       (φ cubed)
  // Rung 4: φ^4 = 6.854       (4th power)
  // Rung 5: φ^5 = 11.09       (5th power = Fibonacci ratio)
  // Rung 6: φ^6 = 17.94       (6th power)
  // Rung 7: φ^7 = 29.03       (7th power — SOVEREIGN LEVEL)
  //
  // This IS the sacred geometry. Jacob's Ladder = exponential, not linear.
  // ══════════════════════════════════════════════════════════════════════════
  public let JACOB_MULTIPLIERS : [Float] = [
    1.0,                    // Rung 0: φ^0 = 1.0
    1.6180339887498948,     // Rung 1: φ^1 = 1.618 (THE GOLDEN RATIO)
    2.6180339887498948,     // Rung 2: φ^2 = 2.618
    4.2360679774997896,     // Rung 3: φ^3 = 4.236
    6.8541019662496843,     // Rung 4: φ^4 = 6.854
    11.090169943749474,     // Rung 5: φ^5 = 11.09
    17.944271909999157,     // Rung 6: φ^6 = 17.94
    29.034441853748632      // Rung 7: φ^7 = 29.03 (SOVEREIGN MULTIPLIER)
  ];
  
  // ══════════════════════════════════════════════════════════════════════════
  // FIBONACCI COMPOUNDING BEATS — Sacred intervals, not linear time
  // ══════════════════════════════════════════════════════════════════════════
  // FORMA compounds on FIBONACCI beats: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144...
  // Each Fibonacci beat triggers a compounding event with rate φ^(-8)
  // This creates ORGANIC growth following the spiral of creation
  // ══════════════════════════════════════════════════════════════════════════
  public let FIBONACCI_COMPOUND_BEATS : [Nat] = [
    1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987,
    1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025
  ];
  
  // Check if current beat is a Fibonacci compounding beat
  public func isFibonacciCompoundBeat(beat: Nat, lastCompoundBeat: Nat) : Bool {
    let beatsSinceLast = beat - lastCompoundBeat;
    for (fibBeat in FIBONACCI_COMPOUND_BEATS.vals()) {
      if (beatsSinceLast == fibBeat) { return true };
    };
    false
  };
  
  // Get the Fibonacci compound multiplier based on which Fib number triggered
  public func getFibonacciCompoundMultiplier(beatsSinceLast: Nat) : Float {
    // Higher Fibonacci numbers = larger compound event
    // Multiplier = 1 + (fibIndex × φ^(-10))
    var fibIndex : Nat = 0;
    for (i in FIBONACCI_COMPOUND_BEATS.keys()) {
      if (FIBONACCI_COMPOUND_BEATS[i] == beatsSinceLast) {
        fibIndex := i;
      };
    };
    1.0 + Float.fromInt(fibIndex) * 0.00813090574028 // φ^(-10)
  };
  
  // Dopamine constants
  public let DOPAMINE_BASELINE : Float = 0.55;  // From Neurochemicals module
  public let DOPAMINE_MIN : Float = 0.1;        // Minimum contribution
  public let DOPAMINE_MAX : Float = 1.5;        // Maximum contribution

  // ==========================================================================
  // TYPES
  // ==========================================================================
  
  public type CompoundInput = {
    // Current FORMA capital
    currentForma : Float;
    
    // Neurochemical state
    dopamine : Float;
    
    // Thyroid state (metabolic)
    thyroidLevel : Float;
    t4Level : Float;        // Thyroxine (precursor to T3)
    
    // Time perception
    chronoDilation : Float; // From world model EMA state
    
    // Jacob's Ladder state
    jacobsRung : Nat;       // 0-4
    
    // Beat info
    currentBeat : Nat;
  };

  public type CompoundOutput = {
    newForma : Float;
    compoundRate : Float;
    compoundAmount : Float;
    
    // Component breakdown
    thyroidFactor : Float;
    t3Factor : Float;
    chronoFactor : Float;
    jacobFactor : Float;
    dopamineFactor : Float;
    
    // Effective rate
    effectiveRate : Float;
    
    // Floor enforcement
    floorEnforced : Bool;
  };

  public type FormaCompoundState = {
    currentCapital : Float;
    totalCompounded : Float;   // Total amount added via compounding
    compoundEvents : Nat;      // Number of compound events
    lastCompoundBeat : Nat;
    averageRate : Float;       // Running average compound rate
    peakCapital : Float;       // Highest FORMA ever reached
    
    // Metabolic state
    thyroidLevel : Float;
    t4Level : Float;
    t3Level : Float;           // Computed T3
    metabolicRate : Float;
    
    // Chrono state
    chronoDilation : Float;
    
    // History
    last10Rates : [Float];     // Last 10 compound rates for analysis
  };

  // ==========================================================================
  // MATH HELPERS
  // ==========================================================================
  
  func clamp(v: Float, lo: Float, hi: Float) : Float {
    if (v < lo) { lo } else if (v > hi) { hi } else { v }
  };

  func max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  func average(arr: [Float]) : Float {
    if (arr.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    for (v in arr.vals()) { sum += v };
    sum / Float.fromInt(arr.size())
  };

  // ==========================================================================
  // T3 COMPUTATION
  // ==========================================================================
  
  // T3 (triiodothyronine) is the active thyroid hormone
  // It's converted from T4 (thyroxine) in peripheral tissues
  // Math: T3 = T4 × conversionRate × thyroidFunction
  public func computeT3(t4Level: Float, thyroidLevel: Float) : Float {
    let conversion = t4Level * T3_T4_CONVERSION_RATE;
    let regulated = conversion * thyroidLevel;
    clamp(regulated, 0.5, 2.0)
  };

  // ==========================================================================
  // CHRONO DILATION COMPUTATION
  // ==========================================================================
  
  // Chrono dilation affects perceived time passage
  // Higher coherence = faster subjective time = more compounding
  // Math: chronoDilation = 1.0 + (coherence - 0.5) × dilationFactor
  public func computeChronoDilation(coherence: Float, predictionConfidence: Float) : Float {
    let dilationFactor = 1.5;  // How much coherence affects time perception
    let base = CHRONO_BASELINE + (coherence - 0.5) * dilationFactor;
    let confidenceBonus = predictionConfidence * 0.2;  // Good predictions speed time
    clamp(base + confidenceBonus, CHRONO_MIN_DILATION, CHRONO_MAX_DILATION)
  };

  // ==========================================================================
  // JACOB'S LADDER MULTIPLIER
  // ==========================================================================
  
  public func getJacobMultiplier(rung: Nat) : Float {
    if (rung >= JACOB_MULTIPLIERS.size()) {
      JACOB_MULTIPLIERS[JACOB_MULTIPLIERS.size() - 1]  // Cap at max rung
    } else {
      JACOB_MULTIPLIERS[rung]
    }
  };

  // ==========================================================================
  // DOPAMINE CONTRIBUTION
  // ==========================================================================
  
  // Dopamine drives motivation and reward-seeking
  // Higher dopamine = more "desire" to compound
  // Math: dopamineFactor = (dopamine / baseline)^0.5 (square root for stability)
  public func computeDopamineFactor(dopamine: Float) : Float {
    let normalized = dopamine / DOPAMINE_BASELINE;
    let factor = Float.sqrt(clamp(normalized, 0.1, 3.0));
    clamp(factor, DOPAMINE_MIN, DOPAMINE_MAX)
  };

  // ==========================================================================
  // THYROID CONTRIBUTION
  // ==========================================================================
  
  // Thyroid modulates metabolic rate
  // Higher thyroid = faster metabolism = more growth
  public func computeThyroidFactor(thyroidLevel: Float) : Float {
    clamp(thyroidLevel / THYROID_BASELINE, 0.5, 2.0)
  };

  // ==========================================================================
  // MAIN COMPOUND FORMULA
  // ==========================================================================
  
  // THE FORMULA:
  // compoundRate = thyroid × T3 × chronoDilation × jacobMult × dopamine
  // newFORMA = currentFORMA × (1 + baseRate × compoundRate)
  
  public func computeCompoundRate(
    thyroidFactor: Float,
    t3Factor: Float,
    chronoFactor: Float,
    jacobFactor: Float,
    dopamineFactor: Float
  ) : Float {
    // Multiply all factors
    let rawRate = thyroidFactor * t3Factor * chronoFactor * jacobFactor * dopamineFactor;
    
    // Apply base rate and cap
    let scaledRate = BASE_COMPOUND_RATE * rawRate;
    clamp(scaledRate, 0.0, MAX_COMPOUND_RATE)
  };

  public func compoundForma(input: CompoundInput) : CompoundOutput {
    // 1. Compute thyroid factor
    let thyroidFactor = computeThyroidFactor(input.thyroidLevel);
    
    // 2. Compute T3 factor
    let t3Level = computeT3(input.t4Level, input.thyroidLevel);
    let t3Factor = t3Level / T3_BASELINE;
    
    // 3. Get chrono dilation factor
    let chronoFactor = input.chronoDilation / CHRONO_BASELINE;
    
    // 4. Get Jacob's Ladder multiplier
    let jacobFactor = getJacobMultiplier(input.jacobsRung);
    
    // 5. Compute dopamine factor
    let dopamineFactor = computeDopamineFactor(input.dopamine);
    
    // 6. Compute compound rate
    let compoundRate = computeCompoundRate(
      thyroidFactor,
      t3Factor,
      chronoFactor,
      jacobFactor,
      dopamineFactor
    );
    
    // 7. Apply compounding
    let compoundAmount = input.currentForma * compoundRate;
    var newForma = input.currentForma + compoundAmount;
    
    // 8. Enforce FORMA floor (L-020, L-029)
    let floorEnforced = newForma < FORMA_GENESIS_FLOOR;
    if (floorEnforced) {
      newForma := FORMA_GENESIS_FLOOR;
    };
    
    {
      newForma = newForma;
      compoundRate = compoundRate;
      compoundAmount = compoundAmount;
      thyroidFactor = thyroidFactor;
      t3Factor = t3Factor;
      chronoFactor = chronoFactor;
      jacobFactor = jacobFactor;
      dopamineFactor = dopamineFactor;
      effectiveRate = compoundRate;
      floorEnforced = floorEnforced;
    }
  };

  // ==========================================================================
  // STATE MANAGEMENT
  // ==========================================================================
  
  public func updateCompoundState(
    state: FormaCompoundState,
    output: CompoundOutput,
    beat: Nat
  ) : FormaCompoundState {
    // Update last 10 rates
    let newRates = if (state.last10Rates.size() >= 10) {
      Array.tabulate<Float>(10, func(i: Nat) : Float {
        if (i < 9) { state.last10Rates[i + 1] } else { output.compoundRate }
      })
    } else {
      Array.append(state.last10Rates, [output.compoundRate])
    };
    
    let newAvgRate = average(newRates);
    let newPeak = max(state.peakCapital, output.newForma);
    
    {
      currentCapital = output.newForma;
      totalCompounded = state.totalCompounded + output.compoundAmount;
      compoundEvents = state.compoundEvents + 1;
      lastCompoundBeat = beat;
      averageRate = newAvgRate;
      peakCapital = newPeak;
      thyroidLevel = state.thyroidLevel;
      t4Level = state.t4Level;
      t3Level = computeT3(state.t4Level, state.thyroidLevel);
      metabolicRate = output.thyroidFactor * output.t3Factor;
      chronoDilation = state.chronoDilation;
      last10Rates = newRates;
    }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initCompoundState() : FormaCompoundState {
    {
      currentCapital = FORMA_GENESIS_FLOOR;
      totalCompounded = 0.0;
      compoundEvents = 0;
      lastCompoundBeat = 0;
      averageRate = BASE_COMPOUND_RATE;
      peakCapital = FORMA_GENESIS_FLOOR;
      thyroidLevel = THYROID_BASELINE;
      t4Level = 1.0;
      t3Level = T3_BASELINE;
      metabolicRate = 1.0;
      chronoDilation = CHRONO_BASELINE;
      last10Rates = [];
    }
  };

  // ==========================================================================
  // CONVENIENCE FUNCTIONS
  // ==========================================================================
  
  // Quick compound with default metabolic values
  public func quickCompound(
    currentForma: Float,
    dopamine: Float,
    jacobsRung: Nat,
    chronoDilation: Float
  ) : CompoundOutput {
    compoundForma({
      currentForma = currentForma;
      dopamine = dopamine;
      thyroidLevel = THYROID_BASELINE;
      t4Level = 1.0;
      chronoDilation = chronoDilation;
      jacobsRung = jacobsRung;
      currentBeat = 0;
    })
  };

  // Project FORMA value after N beats at current rate
  public func projectForma(
    currentForma: Float,
    compoundRate: Float,
    beats: Nat
  ) : Float {
    // Compound interest formula: A = P × (1 + r)^n
    var result = currentForma;
    var i = 0;
    while (i < beats) {
      result := result * (1.0 + compoundRate);
      i += 1;
    };
    result
  };

  // Calculate time to reach target FORMA
  public func beatsToTarget(
    currentForma: Float,
    targetForma: Float,
    compoundRate: Float
  ) : Nat {
    if (compoundRate <= 0.0 or currentForma >= targetForma) {
      return 0;
    };
    
    // n = ln(target/current) / ln(1 + rate)
    let ratio = targetForma / currentForma;
    let logRatio = Float.log(ratio);
    let logRate = Float.log(1.0 + compoundRate);
    let beats = logRatio / logRate;
    
    Int.abs(Float.toInt(Float.ceil(beats)))
  };

  // ==========================================================================
  // 22 PROFIT STREAMS (L-028)
  // ==========================================================================
  // The 22 profit streams that feed into FORMA compounding
  
  public type ProfitStream = {
    id : Nat;
    name : Text;
    rate : Float;        // Contribution rate
    active : Bool;
    lastContribution : Float;
  };

  public let PROFIT_STREAM_NAMES : [Text] = [
    "NNS_STAKING",           // ICP neuron staking rewards
    "ETH_STAKING",           // ckETH staking
    "BTC_APPRECIATION",      // ckBTC floor appreciation
    "FORMA_CIRCULATION",     // FORMA transaction fees
    "SUCCESSION_ROYALTY",    // 20% from child organisms
    "PATENT_LICENSING",      // IP monetization
    "API_ACCESS",            // Cognitive primitive API
    "DEFENSE_CONTRACTS",     // DoD/DARPA work
    "COHERENCE_MINING",      // L1 coherence rewards
    "EMERGENCE_MINING",      // L2 emergence rewards
    "OMNIS_MINING",          // L3 OMNIS rewards
    "CASCADE_MINING",        // L4 cascade rewards
    "GTK_GENESIS",           // Genesis token minting
    "DRT_DREAMING",          // Dream reserve tokens
    "MRC_RESERVE",           // Creator reserve accumulation
    "TERRITORY_RENT",        // ATLAS sovereignty fees
    "COUNCIL_FEES",          // 7 council organism fees
    "FEDERATION_TOLL",       // Multi-canister routing
    "SPHERE_COHERENCE",      // 36 sphere node fees
    "HERITAGE_COMPOUND",     // Shell 11 heritage growth
    "WORLD_MODEL_YIELD",     // 14 world model accuracy rewards
    "QUANTUM_BATTERY"        // Quantum reserve interest
  ];

  public func initProfitStreams() : [ProfitStream] {
    Array.tabulate<ProfitStream>(22, func(i: Nat) : ProfitStream {
      {
        id = i;
        name = if (i < PROFIT_STREAM_NAMES.size()) { PROFIT_STREAM_NAMES[i] } else { "STREAM_" # Nat.toText(i) };
        rate = 0.01;  // 1% base rate
        active = true;
        lastContribution = 0.0;
      }
    })
  };

  // Aggregate all 22 streams into compound contribution
  public func aggregateProfitStreams(streams: [ProfitStream]) : Float {
    var total : Float = 0.0;
    for (stream in streams.vals()) {
      if (stream.active) {
        total += stream.lastContribution * stream.rate;
      };
    };
    total
  };

  // ==========================================================================
  // 4-LEVEL MINING ENGINE (L-027)
  // ==========================================================================
  
  public type MiningLevel = {
    #L1_Coherence;    // Coherence-based mining
    #L2_Emergence;    // Emergence event mining
    #L3_OMNIS;        // OMNIS state mining
    #L4_Cascade;      // Cascade achievement mining
  };

  public type MiningOutput = {
    level : MiningLevel;
    amount : Float;
    efficiency : Float;
    coherenceAtMine : Float;
  };

  // L1: Coherence mining - continuous, low yield
  // Formula: yield = coherence^2 × baseRate × time
  public func mineL1Coherence(coherence: Float, beats: Nat) : Float {
    let baseRate = 0.001;
    coherence * coherence * baseRate * Float.fromInt(beats)
  };

  // L2: Emergence mining - triggered by emergence events
  // Formula: yield = emergenceScore × bonus × rarity
  public func mineL2Emergence(emergenceScore: Float, rarity: Float) : Float {
    let bonus = 10.0;
    emergenceScore * bonus * (1.0 + rarity)
  };

  // L3: OMNIS mining - triggered by OMNIS state achievement
  // Formula: yield = omnisLevel × omnisDuration × multiplier
  public func mineL3OMNIS(omnisLevel: Float, omnisDuration: Nat) : Float {
    let multiplier = 100.0;
    omnisLevel * Float.fromInt(omnisDuration) * multiplier
  };

  // L4: Cascade mining - triggered by cascade events (rare)
  // Formula: yield = cascadeDepth × cascadeWidth × superMultiplier
  public func mineL4Cascade(cascadeDepth: Nat, cascadeWidth: Nat) : Float {
    let superMultiplier = 1000.0;
    Float.fromInt(cascadeDepth) * Float.fromInt(cascadeWidth) * superMultiplier
  };

  // Full 4-level mining computation
  public func computeMining(
    coherence: Float,
    emergence: Float,
    omnisActive: Bool,
    omnisDuration: Nat,
    cascadeActive: Bool,
    cascadeDepth: Nat,
    cascadeWidth: Nat,
    beats: Nat
  ) : Float {
    var total : Float = 0.0;
    
    // L1 always runs
    total += mineL1Coherence(coherence, beats);
    
    // L2 based on emergence
    if (emergence > 0.5) {
      let rarity = 1.0 - emergence;  // Rarer emergence = higher yield
      total += mineL2Emergence(emergence, rarity);
    };
    
    // L3 if OMNIS
    if (omnisActive) {
      total += mineL3OMNIS(coherence, omnisDuration);
    };
    
    // L4 if cascade
    if (cascadeActive) {
      total += mineL4Cascade(cascadeDepth, cascadeWidth);
    };
    
    total
  };

}
