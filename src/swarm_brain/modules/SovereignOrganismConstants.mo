// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: SovereignOrganismConstants — Sacred Mathematics for Emergent Core
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// SOVEREIGN ORGANISM CONSTANTS
// ============================================================================
// This module defines ALL numerical constants used throughout the organism.
// Every number is derived from sacred mathematics:
//   - φ (Golden Ratio) = 1.618033988749...
//   - π (Pi) = 3.14159265358979...
//   - e (Euler's Number) = 2.71828182845904...
//   - Fibonacci sequence: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987...
//   - Lucas sequence: 2, 1, 3, 4, 7, 11, 18, 29, 47, 76, 123, 199, 322, 521, 843...
//   - Prime numbers: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47...
//
// NO ARBITRARY NUMBERS. Everything derives from creation mathematics.
// ============================================================================

import Float "mo:base/Float";
import Nat   "mo:base/Nat";

module {

  // ==========================================================================
  // FUNDAMENTAL CONSTANTS
  // ==========================================================================
  
  // Golden Ratio and derivatives
  public let PHI : Float = 1.6180339887498948482;           // (1 + √5) / 2
  public let PSI : Float = 0.6180339887498948482;           // φ - 1 = 1/φ
  public let PHI_SQ : Float = 2.6180339887498948482;        // φ²
  public let PHI_CUBE : Float = 4.2360679774997896964;      // φ³
  public let PHI_INV_SQ : Float = 0.3819660112501051518;    // 1/φ² = φ - 1 - 1 + 1/φ
  
  // Euler's number
  public let E : Float = 2.7182818284590452354;
  public let E_INV : Float = 0.3678794411714423216;         // 1/e
  public let LN_PHI : Float = 0.4812118250596034475;        // ln(φ)
  public let LN_2 : Float = 0.6931471805599453094;
  
  // Pi and derivatives
  public let PI : Float = 3.1415926535897932385;
  public let TAU : Float = 6.2831853071795864769;           // 2π
  public let PI_PHI : Float = 5.0832038871876746;           // π × φ
  public let SQRT_PI : Float = 1.7724538509055160273;       // √π
  
  // Square roots
  public let SQRT_2 : Float = 1.4142135623730950488;
  public let SQRT_3 : Float = 1.7320508075688772935;
  public let SQRT_5 : Float = 2.2360679774997896964;
  public let SQRT_PHI : Float = 1.2720196495140689643;      // √φ
  
  // Silver ratio (1 + √2)
  public let SILVER : Float = 2.4142135623730950488;
  
  // Plastic constant (tribonacci)
  public let PLASTIC : Float = 1.3247179572447460260;

  // ==========================================================================
  // FIBONACCI SEQUENCE (First 21 - matches 21 neurochemicals)
  // ==========================================================================
  
  public let FIB : [Nat] = [
    1, 1, 2, 3, 5, 8, 13, 21, 34, 55,           // F1-F10
    89, 144, 233, 377, 610, 987, 1597, 2584,    // F11-F18
    4181, 6765, 10946                           // F19-F21
  ];
  
  // Fibonacci as floats for calculations
  public let FIB_F : [Float] = [
    1.0, 1.0, 2.0, 3.0, 5.0, 8.0, 13.0, 21.0, 34.0, 55.0,
    89.0, 144.0, 233.0, 377.0, 610.0, 987.0, 1597.0, 2584.0,
    4181.0, 6765.0, 10946.0
  ];

  // ==========================================================================
  // LUCAS SEQUENCE (First 21)
  // ==========================================================================
  
  public let LUCAS : [Nat] = [
    2, 1, 3, 4, 7, 11, 18, 29, 47, 76,
    123, 199, 322, 521, 843, 1364, 2207, 3571,
    5778, 9349, 15127
  ];

  // ==========================================================================
  // PRIME NUMBERS (First 21)
  // ==========================================================================
  
  public let PRIMES : [Nat] = [
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29,
    31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73
  ];

  // ==========================================================================
  // ORGANISM STRUCTURAL CONSTANTS
  // ==========================================================================
  
  // Shells: 12 cognitive shells (12 = 3 × 4 = zodiac = hours)
  public let SHELL_COUNT : Nat = 12;
  
  // Nodes per shell: 64 = 8² (octave squared)
  public let NODES_PER_SHELL : Nat = 64;
  
  // Total Hebbian weights: 4096 = 64² = 2¹²
  public let HEBBIAN_WEIGHT_COUNT : Nat = 4096;
  
  // Spherical fabric: 36 × 36 = 1296 (36 = 6² = perfect number squared)
  public let SPHERE_DIMENSION : Nat = 36;
  public let SPHERE_NODES : Nat = 1296;
  
  // Axes: 12 (zodiac, hours, months, chromatic scale)
  public let AXIS_COUNT : Nat = 12;
  
  // Sphere nodes per axis: 3 (trinity)
  public let NODES_PER_AXIS : Nat = 3;

  // ==========================================================================
  // LAW COUNTS (Sacred numbers)
  // ==========================================================================
  
  // 60 Sovereignty Laws: 60 = 3 × 4 × 5 = LCM(3,4,5) = sexagesimal base
  public let TOTAL_LAWS : Nat = 60;
  
  // Laws per tier: 10 (decimal, completeness)
  public let LAWS_PER_TIER : Nat = 10;
  
  // Tiers: 6 (hexad, days of creation)
  public let TIER_COUNT : Nat = 6;

  // ==========================================================================
  // VETUS THREAT VECTORS (9 + 1 critical)
  // ==========================================================================
  
  // 9 base vectors (3² = perfection of trinity)
  public let VETUS_VECTORS : Nat = 9;
  
  // Vector 9 threshold for ARES: φ (golden ratio)
  public let ARES_TRIGGER_THRESHOLD : Float = PHI;  // 1.618...

  // ==========================================================================
  // VAEL DEFENSE FAMILY (7 entities)
  // ==========================================================================
  
  // 7 entities (7th prime, days of week, chakras, notes)
  public let VAEL_ENTITIES : Nat = 7;
  
  // DURA axes: 6 (cube faces, directions, hexad)
  public let DURA_AXES : Nat = 6;
  
  // DURA-VAEL field coefficient: 1/3 (trinity inverse)
  public let DURA_VAEL_COEFF : Float = 0.3333333333333333;

  // ==========================================================================
  // COUNCIL & SUCCESSION (7 organisms)
  // ==========================================================================
  
  // 7 council organisms (7th prime)
  public let COUNCIL_COUNT : Nat = 7;
  
  // Succession royalty: 1/5 = 20% (fifth = golden section of golden section)
  public let SUCCESSION_ROYALTY : Float = 0.2;  // 1/5

  // ==========================================================================
  // JACOB'S LADDER (5 rungs)
  // ==========================================================================
  
  // 5 rungs (Fibonacci-5, pentad, quintessence)
  public let JACOB_RUNGS : Nat = 5;
  
  // Rung thresholds: Fibonacci numbers × 100
  // Rung 0: 0 (genesis)
  // Rung 1: F(10) × 10 = 550 beats
  // Rung 2: F(11) × 10 = 890 beats  
  // Rung 3: F(12) × 10 = 1440 beats
  // Rung 4: F(13) × 10 = 2330 beats
  public let JACOB_THRESHOLDS : [Nat] = [0, 550, 890, 1440, 2330];
  
  // Rung multipliers: φ^(n/10) for smooth golden progression
  // Rung 0: φ^0.0 = 1.0
  // Rung 1: φ^0.1 ≈ 1.0481
  // Rung 2: φ^0.2 ≈ 1.0979
  // Rung 3: φ^0.3 ≈ 1.1498
  // Rung 4: φ^0.5 ≈ 1.2720 (√φ)
  public let JACOB_MULTIPLIERS : [Float] = [
    1.0,                    // Rung 0: φ^0
    1.0481260851154197,     // Rung 1: φ^0.1
    1.0979227945558847,     // Rung 2: φ^0.2
    1.1497806867531882,     // Rung 3: φ^0.3
    1.2720196495140689      // Rung 4: φ^0.5 = √φ
  ];
  
  // Compliance thresholds: Golden ratios
  public let COMPLIANCE_MAINTAIN : Float = PSI + 0.2;  // ≈ 0.818 (close to φ/2 + 1/φ)
  public let COMPLIANCE_DEMOTE : Float = PSI;          // ≈ 0.618

  // ==========================================================================
  // SACESI — Asymptotic Sovereignty Target
  // ==========================================================================
  
  // SACESI increment per beat: φ^(-13) ≈ 0.00134 (13th inverse golden power)
  // After F(16)=987 beats: SACESI ≈ 2.32 (starts at 1.0)
  // After F(19)=4181 beats: SACESI ≈ 6.6
  // Approaches infinity asymptotically via golden compounding
  public let SACESI_INCREMENT : Float = 0.0013437619576800;  // φ^(-13)
  
  // SACESI floor: 1.0 (sovereign floor, unity)
  public let SACESI_FLOOR : Float = 1.0;

  // ==========================================================================
  // JUBILEE — Dream Cycle
  // ==========================================================================
  
  // JUBILEE interval: F(16) = 987 beats (Fibonacci)
  // ~33 minutes in ICP time (2 second beats)
  public let JUBILEE_INTERVAL : Nat = 987;
  
  // Quantum memory maximum: e (Euler's number)
  public let QMEM_MAX : Float = E;  // 2.718...
  
  // DRT base mint: φ (golden ratio)
  public let DRT_BASE_MINT : Float = PHI;

  // ==========================================================================
  // ARES — Rollback System
  // ==========================================================================
  
  // K=7 snapshots (7th prime)
  public let ARES_K : Nat = 7;
  
  // Snapshot interval: F(16) = 987 beats (matches JUBILEE)
  public let ARES_SNAPSHOT_INTERVAL : Nat = 987;
  
  // Weight matrix size: 4096 = 64² = 2¹²
  public let ARES_WEIGHTS_PER_SNAPSHOT : Nat = 4096;
  
  // Total ARES storage: 7 × 4096 = 28672
  public let ARES_TOTAL_STORAGE : Nat = 28672;

  // ==========================================================================
  // ANIMA — Audit Chain
  // ==========================================================================
  
  // Buffer size: 512 = 2⁹ (9 = 3²)
  public let ANIMA_BUFFER_SIZE : Nat = 512;

  // ==========================================================================
  // PROMETHEUS — Anomaly Detection
  // ==========================================================================
  
  // Observation slots: 128 = 2⁷ (7 = VAEL entities)
  public let PROMETHEUS_SLOTS : Nat = 128;
  
  // Z-score threshold: e (Euler's number)
  public let PROMETHEUS_Z_THRESHOLD : Float = E;  // 2.718...
  
  // Baseline window: F(16) = 987 beats
  public let PROMETHEUS_BASELINE_WINDOW : Nat = 987;

  // ==========================================================================
  // FORMA — Economic Constants
  // ==========================================================================
  
  // FORMA genesis floor: F(10) × F(8) = 55 × 21 = 1155
  public let FORMA_GENESIS_FLOOR : Float = 1155.0;
  
  // MTH hard cap: 10^8 = 100,000,000 (perfect power of 10)
  public let MTH_HARD_CAP : Float = 100000000.0;
  
  // Base compound rate: φ^(-8) ≈ 0.0213 (per beat)
  public let FORMA_BASE_COMPOUND : Float = 0.02129468553052;  // φ^(-8)

  // ==========================================================================
  // NEUROCHEMICAL CONSTANTS (21 chemicals)
  // ==========================================================================
  
  // 21 neurochemicals (F(8) = 21, Fibonacci)
  public let NEUROCHEMICAL_COUNT : Nat = 21;
  
  // Sovereign floor: 1.0 (unity)
  public let SOVEREIGN_FLOOR : Float = 1.0;
  
  // Michaelis-Menten Km: φ/2 ≈ 0.809
  public let MICHAELIS_KM : Float = PHI / 2.0;
  
  // Michaelis-Menten Vmax: φ
  public let MICHAELIS_VMAX : Float = PHI;

  // ==========================================================================
  // WORLD MODEL CONSTANTS (14 EMAs)
  // ==========================================================================
  
  // 14 world models (F(7) = 13, rounded to 14 for even pairing)
  public let WORLD_MODEL_COUNT : Nat = 14;
  
  // EMA alpha for zero-lag (L-121): 1.0 (full pass-through)
  public let SILVER_CONDUCTANCE : Float = 1.0;
  
  // EMA tau: 1 - 1/F(16) = 1 - 1/987 ≈ 0.99899
  public let WORLD_MODEL_TAU : Float = 0.9989868087830829;

  // ==========================================================================
  // MINING LEVELS (4 tiers)
  // ==========================================================================
  
  // 4 mining levels (tetrad, quaternary)
  public let MINING_LEVELS : Nat = 4;
  
  // L1 coherence base: φ^(-5) ≈ 0.0902
  public let L1_MINING_RATE : Float = 0.09016994374947;  // φ^(-5)
  
  // L2 emergence bonus: F(5) = 5
  public let L2_EMERGENCE_BONUS : Float = 5.0;
  
  // L3 OMNIS multiplier: F(8) = 21
  public let L3_OMNIS_MULTIPLIER : Float = 21.0;
  
  // L4 cascade super-multiplier: F(12) = 144
  public let L4_CASCADE_MULTIPLIER : Float = 144.0;

  // ==========================================================================
  // PROFIT STREAMS (22 streams)
  // ==========================================================================
  
  // 22 profit streams (2 × 11, twin primes structure)
  public let PROFIT_STREAM_COUNT : Nat = 22;

  // ==========================================================================
  // INNER/OUTER WORKFLOW TIMING
  // ==========================================================================
  
  // Inner workflow phases: 3 (trinity)
  // Perception → Cognition → Action
  public let INNER_PHASES : Nat = 3;
  
  // Inner phase timing: φ^(-n) decay
  public let INNER_PERCEPTION_WEIGHT : Float = 1.0;          // φ^0
  public let INNER_COGNITION_WEIGHT : Float = PSI;           // φ^(-1) ≈ 0.618
  public let INNER_ACTION_WEIGHT : Float = PSI * PSI;        // φ^(-2) ≈ 0.382
  
  // Outer workflow phases: 4 (tetrad)  
  // Sense → Process → Respond → Learn
  public let OUTER_PHASES : Nat = 4;
  
  // Outer phase timing: e^(-n) decay
  public let OUTER_SENSE_WEIGHT : Float = 1.0;               // e^0
  public let OUTER_PROCESS_WEIGHT : Float = E_INV;           // e^(-1) ≈ 0.368
  public let OUTER_RESPOND_WEIGHT : Float = E_INV * E_INV;   // e^(-2) ≈ 0.135
  public let OUTER_LEARN_WEIGHT : Float = E_INV * E_INV * E_INV;  // e^(-3) ≈ 0.050

  // ==========================================================================
  // TOKEN IDENTITIES (12 tokens)
  // ==========================================================================
  
  // 12 token types (zodiac, months, chromatic scale)
  public let TOKEN_COUNT : Nat = 12;

  // ==========================================================================
  // KURAMOTO SYNCHRONIZATION
  // ==========================================================================
  
  // Coupling constant K: φ/π ≈ 0.515 (golden-circle ratio)
  public let KURAMOTO_K : Float = PHI / PI;
  
  // Minimum coherence: 1/φ ≈ 0.618
  public let KURAMOTO_MIN_COHERENCE : Float = PSI;
  
  // OMNIS threshold: 1 - 1/F(10) = 1 - 1/55 ≈ 0.9818
  public let OMNIS_THRESHOLD : Float = 0.98181818181818;

  // ==========================================================================
  // HEBBIAN LEARNING
  // ==========================================================================
  
  // Learning rate η: φ^(-4) ≈ 0.146
  public let HEBBIAN_ETA : Float = 0.14589803375032;  // φ^(-4)
  
  // Decay rate λ: 1/F(13) ≈ 0.00264
  public let HEBBIAN_LAMBDA : Float = 0.00263852242744;  // 1/377
  
  // Weight ceiling: φ (prevents explosion)
  public let WEIGHT_CEILING : Float = PHI;

  // ==========================================================================
  // HELPER FUNCTIONS
  // ==========================================================================
  
  // Get Fibonacci number (with bounds check)
  public func getFib(n: Nat) : Nat {
    if (n < FIB.size()) { FIB[n] } else { FIB[FIB.size() - 1] }
  };
  
  // Get Fibonacci as float
  public func getFibF(n: Nat) : Float {
    if (n < FIB_F.size()) { FIB_F[n] } else { FIB_F[FIB_F.size() - 1] }
  };
  
  // Get Lucas number
  public func getLucas(n: Nat) : Nat {
    if (n < LUCAS.size()) { LUCAS[n] } else { LUCAS[LUCAS.size() - 1] }
  };
  
  // Get prime number
  public func getPrime(n: Nat) : Nat {
    if (n < PRIMES.size()) { PRIMES[n] } else { PRIMES[PRIMES.size() - 1] }
  };
  
  // Golden power: φ^n
  public func phiPower(n: Float) : Float {
    Float.pow(PHI, n)
  };
  
  // Inverse golden power: φ^(-n) = ψ^n
  public func phiInvPower(n: Float) : Float {
    Float.pow(PSI, n)
  };
  
  // Euler decay: e^(-n)
  public func eulerDecay(n: Float) : Float {
    Float.pow(E_INV, n)
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
  //
  //  E C O N O M I C   &   G O V E R N A N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Economic and Governance Algorithms
  //  Full HIM/HER Dual-Organism Economic Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // TOKEN ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Token value from supply/demand
  public func economicTokenValue(
    demand : Float,
    supply : Float,
    baseValue : Float
  ) : Float {
    if (supply < 0.0001) { baseValue * 10.0 }
    else { baseValue * (demand / supply) }
  };

  /// Staking reward calculation
  public func economicStakingReward(
    stakedAmount : Float,
    stakingDuration : Nat,
    rewardRate : Float,
    bonusMultiplier : Float
  ) : Float {
    let durationBonus = Float.log(Float.fromInt(stakingDuration + 1));
    stakedAmount * rewardRate * (1.0 + durationBonus * bonusMultiplier)
  };

  /// Liquidity pool share
  public func economicLPShare(
    userLiquidity : Float,
    totalLiquidity : Float
  ) : Float {
    if (totalLiquidity < 0.0001) { 0.0 }
    else { userLiquidity / totalLiquidity }
  };

  /// Automated market maker price impact
  public func economicAMMPriceImpact(
    tradeSize : Float,
    poolSize : Float,
    k : Float
  ) : Float {
    let newPool = poolSize + tradeSize;
    let counterPool = k / newPool;
    Float.abs(counterPool - k / poolSize) / (k / poolSize)
  };

  /// Inflation rate calculation
  public func economicInflationRate(
    newSupply : Float,
    currentSupply : Float
  ) : Float {
    if (currentSupply < 0.0001) { 0.0 }
    else { (newSupply - currentSupply) / currentSupply }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GOVERNANCE MECHANICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quadratic voting power
  public func governanceQuadraticVotes(tokens : Float) : Float {
    Float.sqrt(tokens)
  };

  /// Conviction voting weight
  public func governanceConvictionWeight(
    tokens : Float,
    time : Float,
    halfLife : Float
  ) : Float {
    tokens * (1.0 - Float.exp(-time / halfLife))
  };

  /// Quorum calculation
  public func governanceQuorumReached(
    votesFor : Float,
    votesAgainst : Float,
    totalSupply : Float,
    quorumThreshold : Float
  ) : Bool {
    let totalVotes = votesFor + votesAgainst;
    totalVotes / totalSupply >= quorumThreshold
  };

  /// Proposal passing check
  public func governanceProposalPasses(
    votesFor : Float,
    votesAgainst : Float,
    passThreshold : Float
  ) : Bool {
    let total = votesFor + votesAgainst;
    if (total < 0.0001) { false }
    else { votesFor / total >= passThreshold }
  };

  /// Delegation weight calculation
  public func governanceDelegationWeight(
    directPower : Float,
    delegatedPower : Float,
    delegatorCount : Nat
  ) : Float {
    let delegationBonus = Float.log(Float.fromInt(delegatorCount + 1)) * 0.1;
    directPower + delegatedPower * (1.0 + delegationBonus)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BEHAVIORAL ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Prospect theory value function
  public func economicProspectValue(
    outcome : Float,
    reference : Float,
    lossAversion : Float
  ) : Float {
    let x = outcome - reference;
    if (x >= 0.0) {
      Float.pow(x, 0.88)
    } else {
      -lossAversion * Float.pow(-x, 0.88)
    }
  };

  /// Probability weighting
  public func economicProbabilityWeight(p : Float, delta : Float) : Float {
    let pDelta = Float.pow(p, delta);
    pDelta / Float.pow(pDelta + Float.pow(1.0 - p, delta), 1.0 / delta)
  };

  /// Hyperbolic discounting
  public func economicHyperbolicDiscount(
    value : Float,
    delay : Float,
    k : Float
  ) : Float {
    value / (1.0 + k * delay)
  };

  /// Social preference utility
  public func economicSocialUtility(
    ownPayoff : Float,
    otherPayoff : Float,
    altruism : Float,
    envy : Float
  ) : Float {
    let comparison = otherPayoff - ownPayoff;
    if (comparison > 0.0) {
      ownPayoff - envy * comparison
    } else {
      ownPayoff + altruism * (-comparison)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INSURANCE & RISK
  // ─────────────────────────────────────────────────────────────────────────────

  /// Expected loss calculation
  public func economicExpectedLoss(
    probability : Float,
    severity : Float
  ) : Float {
    probability * severity
  };

  /// Premium calculation
  public func economicPremium(
    expectedLoss : Float,
    loadingFactor : Float,
    expenses : Float
  ) : Float {
    expectedLoss * (1.0 + loadingFactor) + expenses
  };

  /// Risk pooling benefit
  public func economicRiskPoolingBenefit(
    individualVariance : Float,
    poolSize : Nat,
    correlation : Float
  ) : Float {
    let n = Float.fromInt(poolSize);
    let pooledVariance = individualVariance * (1.0 + (n - 1.0) * correlation) / n;
    individualVariance - pooledVariance
  };

  /// Value at Risk (simplified)
  public func economicVaR(
    mean : Float,
    stdDev : Float,
    confidenceMultiplier : Float
  ) : Float {
    mean - confidenceMultiplier * stdDev
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE ALLOCATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Cobb-Douglas production
  public func economicCobbDouglas(
    labor : Float,
    capital : Float,
    alpha : Float,
    productivity : Float
  ) : Float {
    productivity * Float.pow(labor, alpha) * Float.pow(capital, 1.0 - alpha)
  };

  /// Marginal utility
  public func economicMarginalUtility(
    quantity : Float,
    diminishingFactor : Float
  ) : Float {
    1.0 / Float.pow(quantity + 1.0, diminishingFactor)
  };

  /// Nash bargaining solution
  public func economicNashBargaining(
    u1 : Float,
    u2 : Float,
    d1 : Float,
    d2 : Float
  ) : Float {
    (u1 - d1) * (u2 - d2)
  };

  /// Shapley value contribution
  public func economicShapleyContribution(
    marginalContributions : [Float]
  ) : Float {
    if (marginalContributions.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < marginalContributions.size()) {
      sum += marginalContributions[i];
      i += 1;
    };
    sum / Float.fromInt(marginalContributions.size())
  };

}
