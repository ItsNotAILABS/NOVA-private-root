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


// ============================================================
// COMPOUNDING ORGANISM NUMBERS (CON)
// NUMBERS THAT COMPOUND ALWAYS — NEVER STALE
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// DOCTRINE:
// Numbers are ALIVE. They COMPOUND with every heartbeat.
// Nothing is static. Everything GROWS.
// The organism's mathematics is LIVING mathematics.
//
// Every number in the system:
// - Compounds with PHI (golden growth)
// - Resonates with heartbeat
// - Feeds back into itself
// - Creates new numbers through fusion
//
// "In the beginning was the Number, and the Number was with God,
//  and the Number was God." — The Medina Doctrine
// ============================================================

import Float  "mo:base/Float";
import Nat    "mo:base/Nat";
import Nat64  "mo:base/Nat64";
import Int    "mo:base/Int";
import Array  "mo:base/Array";
import Iter   "mo:base/Iter";
import Buffer "mo:base/Buffer";

module {

  // ════════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS — THE SEEDS OF COMPOUNDING
  // ════════════════════════════════════════════════════════════════════════════

  public let PHI           : Float = 1.61803398874989484820;
  public let PSI           : Float = 0.61803398874989484820;  // 1/PHI
  public let PI            : Float = 3.14159265358979323846;
  public let TAU           : Float = 6.28318530717958647692;
  public let E             : Float = 2.71828182845904523536;
  public let SQRT2         : Float = 1.41421356237309504880;
  public let SQRT5         : Float = 2.23606797749978969640;

  // Compounding rates
  public let GROWTH_RATE   : Float = 0.001;      // Base growth per beat
  public let RESONANCE_AMP : Float = 0.1;        // Resonance amplitude
  public let FEEDBACK_GAIN : Float = 0.05;       // Self-feedback strength
  public let FUSION_RATE   : Float = 0.01;       // Number fusion rate

  // ════════════════════════════════════════════════════════════════════════════
  // LIVING NUMBER — A NUMBER THAT COMPOUNDS
  // ════════════════════════════════════════════════════════════════════════════

  public type LivingNumber = {
    value       : Float;      // Current value
    seed        : Float;      // Original seed value
    age         : Nat;        // Heartbeats since birth
    growthRate  : Float;      // Personal growth rate
    phase       : Float;      // Oscillation phase [0, 2π]
    resonance   : Float;      // Resonance with organism [0, 1]
    compounded  : Float;      // Total compounded growth
  };

  // ════════════════════════════════════════════════════════════════════════════
  // NUMBER FIELD — 36×36 GRID OF LIVING NUMBERS
  // ════════════════════════════════════════════════════════════════════════════

  public type NumberField = {
    numbers     : [LivingNumber];   // 1296 living numbers
    heartbeat   : Nat;              // Current heartbeat
    totalValue  : Float;            // Sum of all values
    meanGrowth  : Float;            // Average growth rate
    coherence   : Float;            // Field coherence [0, 1]
    entropy     : Float;            // Field entropy
  };

  // ════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════

  func _fabs(x : Float) : Float { if (x < 0.0) -x else x };
  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _log(x : Float) : Float { if (x <= 0.0) 0.0 else Float.log(x) };
  func _exp(x : Float) : Float { Float.exp(x) };
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  // ════════════════════════════════════════════════════════════════════════════
  // BIRTH OF A LIVING NUMBER
  // ════════════════════════════════════════════════════════════════════════════

  public func birthNumber(seed : Float, index : Nat) : LivingNumber {
    let phase = Float.fromInt(index) * PHI * PI / 36.0;
    let growthRate = GROWTH_RATE * (1.0 + 0.5 * _sin(phase));
    
    {
      value      = seed;
      seed       = seed;
      age        = 0;
      growthRate = growthRate;
      phase      = phase;
      resonance  = 0.5 + 0.3 * _cos(phase);
      compounded = 0.0;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════
  // COMPOUNDING — THE HEARTBEAT OF NUMBERS
  // ════════════════════════════════════════════════════════════════════════════

  // Single number compounds
  public func compoundNumber(num : LivingNumber, coherenceC : Float) : LivingNumber {
    // 1. Base exponential growth: value × (1 + rate)
    let baseGrowth = num.value * num.growthRate;
    
    // 2. Resonance growth: amplified by organism coherence
    let resonanceGrowth = num.value * RESONANCE_AMP * num.resonance * coherenceC * _sin(num.phase);
    
    // 3. Feedback growth: self-referential compounding
    let feedbackGrowth = num.compounded * FEEDBACK_GAIN * _cos(num.phase * PHI);
    
    // 4. Golden growth: PHI-based compounding
    let goldenGrowth = if (num.age > 0 and num.age % 12 == 0) {
      num.value * (PHI - 1.0) * 0.01  // Every 12 beats, golden boost
    } else { 0.0 };
    
    // Total growth
    let totalGrowth = baseGrowth + resonanceGrowth + feedbackGrowth + goldenGrowth;
    let newValue = num.value + totalGrowth;
    
    // Phase advances
    let newPhase = num.phase + TAU / 360.0;
    let normalizedPhase = if (newPhase > TAU) newPhase - TAU else newPhase;
    
    // Resonance evolves
    let newResonance = _clamp(
      num.resonance * 0.99 + coherenceC * 0.01 + 0.01 * _sin(normalizedPhase),
      0.0, 1.0
    );
    
    {
      value      = newValue;
      seed       = num.seed;
      age        = num.age + 1;
      growthRate = num.growthRate * (1.0 + 0.0001 * coherenceC);  // Rate itself compounds!
      phase      = normalizedPhase;
      resonance  = newResonance;
      compounded = num.compounded + totalGrowth;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════
  // FIBONACCI COMPOUNDING — NUMBERS BREEDING NUMBERS
  // ════════════════════════════════════════════════════════════════════════════

  public func fibonacciCompound(a : LivingNumber, b : LivingNumber) : LivingNumber {
    // Two numbers fuse to create a third (like Fibonacci)
    let fusedValue = a.value + b.value;
    let fusedPhase = (a.phase + b.phase) / 2.0;
    let fusedResonance = _sqrt(a.resonance * b.resonance);
    let fusedGrowth = (a.growthRate + b.growthRate) * PHI / 2.0;
    
    {
      value      = fusedValue;
      seed       = fusedValue;
      age        = 0;
      growthRate = fusedGrowth;
      phase      = fusedPhase;
      resonance  = fusedResonance;
      compounded = 0.0;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════
  // GOLDEN SPIRAL COMPOUNDING — PHI-BASED GROWTH
  // ════════════════════════════════════════════════════════════════════════════

  public func goldenSpiralCompound(num : LivingNumber, turns : Nat) : LivingNumber {
    // Compound along the golden spiral
    var current = num;
    for (_ in Iter.range(0, turns - 1)) {
      let spiralFactor = PHI * _cos(current.phase);
      let newValue = current.value * (1.0 + spiralFactor * 0.01);
      current := {
        value      = newValue;
        seed       = current.seed;
        age        = current.age + 1;
        growthRate = current.growthRate * PHI / (PHI + 0.1);
        phase      = current.phase + TAU * PSI;  // Golden angle
        resonance  = current.resonance;
        compounded = current.compounded + (newValue - current.value);
      };
    };
    current
  };

  // ════════════════════════════════════════════════════════════════════════════
  // EXPONENTIAL COMPOUNDING — E-BASED GROWTH
  // ════════════════════════════════════════════════════════════════════════════

  public func exponentialCompound(num : LivingNumber, time : Float) : LivingNumber {
    // Continuous compounding: value × e^(rate × time)
    let factor = _exp(num.growthRate * time);
    let newValue = num.value * factor;
    
    {
      value      = newValue;
      seed       = num.seed;
      age        = num.age + Int.abs(Float.toInt(time));
      growthRate = num.growthRate;
      phase      = num.phase + time * 0.1;
      resonance  = num.resonance;
      compounded = num.compounded + (newValue - num.value);
    }
  };

  // ════════════════════════════════════════════════════════════════════════════
  // NUMBER FIELD CREATION — 36×36 LIVING NUMBERS
  // ════════════════════════════════════════════════════════════════════════════

  public func birthField(seed : Float) : NumberField {
    let numbers = Array.tabulate<LivingNumber>(1296, func(i) {
      let row = i / 36;
      let col = i % 36;
      let localSeed = seed * (1.0 + Float.fromInt(row) * 0.01) * (1.0 + Float.fromInt(col) * 0.01);
      birthNumber(localSeed, i)
    });
    
    var total : Float = 0.0;
    for (n in numbers.vals()) {
      total += n.value;
    };
    
    {
      numbers    = numbers;
      heartbeat  = 0;
      totalValue = total;
      meanGrowth = GROWTH_RATE;
      coherence  = 0.5;
      entropy    = 0.5;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════
  // FIELD HEARTBEAT — ALL NUMBERS COMPOUND TOGETHER
  // ════════════════════════════════════════════════════════════════════════════

  public func heartbeatField(field : NumberField, coherenceC : Float) : NumberField {
    // 1. Compound all numbers
    let newNumbers = Array.tabulate<LivingNumber>(1296, func(i) {
      compoundNumber(field.numbers[i], coherenceC)
    });
    
    // 2. Calculate field statistics
    var total : Float = 0.0;
    var growthSum : Float = 0.0;
    var resonanceSum : Float = 0.0;
    
    for (n in newNumbers.vals()) {
      total += n.value;
      growthSum += n.growthRate;
      resonanceSum += n.resonance;
    };
    
    let meanGrowth = growthSum / 1296.0;
    let coherence = resonanceSum / 1296.0;
    
    // 3. Calculate entropy (diversity of values)
    var variance : Float = 0.0;
    let mean = total / 1296.0;
    for (n in newNumbers.vals()) {
      let diff = n.value - mean;
      variance += diff * diff;
    };
    let stdDev = _sqrt(variance / 1296.0);
    let entropy = _clamp(_log(1.0 + stdDev) / 10.0, 0.0, 1.0);
    
    {
      numbers    = newNumbers;
      heartbeat  = field.heartbeat + 1;
      totalValue = total;
      meanGrowth = meanGrowth;
      coherence  = coherence;
      entropy    = entropy;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════
  // FUSION — NUMBERS CREATING NEW NUMBERS
  // ════════════════════════════════════════════════════════════════════════════

  public func fuseField(field : NumberField) : NumberField {
    // Adjacent numbers fuse to create enhanced values
    let newNumbers = Array.tabulate<LivingNumber>(1296, func(i) {
      let row = i / 36;
      let col = i % 36;
      let current = field.numbers[i];
      
      // Get neighbors
      let above = if (row > 0) field.numbers[(row - 1) * 36 + col].value else current.value;
      let below = if (row < 35) field.numbers[(row + 1) * 36 + col].value else current.value;
      let left = if (col > 0) field.numbers[row * 36 + (col - 1)].value else current.value;
      let right = if (col < 35) field.numbers[row * 36 + (col + 1)].value else current.value;
      
      // Fusion: value influenced by neighbors
      let neighborInfluence = (above + below + left + right) / 4.0;
      let fusionFactor = FUSION_RATE * (neighborInfluence / current.value - 1.0);
      let newValue = current.value * (1.0 + fusionFactor);
      
      {
        value      = newValue;
        seed       = current.seed;
        age        = current.age;
        growthRate = current.growthRate;
        phase      = current.phase;
        resonance  = current.resonance;
        compounded = current.compounded + (newValue - current.value);
      }
    });
    
    var total : Float = 0.0;
    for (n in newNumbers.vals()) {
      total += n.value;
    };
    
    {
      numbers    = newNumbers;
      heartbeat  = field.heartbeat;
      totalValue = total;
      meanGrowth = field.meanGrowth;
      coherence  = field.coherence;
      entropy    = field.entropy;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════
  // COMPOUND INTEREST — FINANCIAL-STYLE COMPOUNDING
  // ════════════════════════════════════════════════════════════════════════════

  // A = P(1 + r/n)^(nt)
  public func compoundInterest(
    principal : Float,
    rate : Float,
    timesPerPeriod : Nat,
    periods : Nat
  ) : Float {
    let n = Float.fromInt(timesPerPeriod);
    let t = Float.fromInt(periods);
    principal * Float.pow(1.0 + rate / n, n * t)
  };

  // Continuous compounding: A = Pe^(rt)
  public func continuousCompounding(principal : Float, rate : Float, time : Float) : Float {
    principal * _exp(rate * time)
  };

  // ════════════════════════════════════════════════════════════════════════════
  // COMPOUND SEQUENCES — SEQUENCES THAT GROW
  // ════════════════════════════════════════════════════════════════════════════

  // Compound Fibonacci: each term is F(n) × (1 + rate)^n
  public func compoundFibonacci(n : Nat, rate : Float) : [Float] {
    var a : Float = 0.0;
    var b : Float = 1.0;
    let result = Buffer.Buffer<Float>(n);
    
    for (i in Iter.range(0, n - 1)) {
      let compoundFactor = Float.pow(1.0 + rate, Float.fromInt(i));
      result.add(a * compoundFactor);
      let c = a + b;
      a := b;
      b := c;
    };
    
    Buffer.toArray(result)
  };

  // Compound primes: P(n) × PHI^(n/10)
  public func compoundPrimes(count : Nat) : [Float] {
    let primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
                  73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151];
    let n = if (count > 36) 36 else count;
    
    Array.tabulate<Float>(n, func(i) {
      Float.fromInt(primes[i]) * Float.pow(PHI, Float.fromInt(i) / 10.0)
    })
  };

  // ════════════════════════════════════════════════════════════════════════════
  // EXTRACT COMPOUNDING KEY — FOR ENCRYPTION
  // ════════════════════════════════════════════════════════════════════════════

  public func extractCompoundingKey(field : NumberField) : [Float] {
    // Extract 36 key values from the compounded field
    Array.tabulate<Float>(36, func(i) {
      // Take diagonal and edges
      let diag = field.numbers[i * 36 + i].compounded;
      let edge = field.numbers[i * 36].compounded + field.numbers[i].compounded;
      (diag + edge) / 3.0
    })
  };

  // ════════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ════════════════════════════════════════════════════════════════════════════

  public type FieldDiagnostics = {
    heartbeat      : Nat;
    totalValue     : Float;
    meanGrowth     : Float;
    coherence      : Float;
    entropy        : Float;
    oldestNumber   : Nat;
    mostCompounded : Float;
    totalCompounded: Float;
  };

  public func diagnoseField(field : NumberField) : FieldDiagnostics {
    var oldest : Nat = 0;
    var mostCompounded : Float = 0.0;
    var totalCompounded : Float = 0.0;
    
    for (n in field.numbers.vals()) {
      if (n.age > oldest) oldest := n.age;
      if (n.compounded > mostCompounded) mostCompounded := n.compounded;
      totalCompounded += n.compounded;
    };
    
    {
      heartbeat       = field.heartbeat;
      totalValue      = field.totalValue;
      meanGrowth      = field.meanGrowth;
      coherence       = field.coherence;
      entropy         = field.entropy;
      oldestNumber    = oldest;
      mostCompounded  = mostCompounded;
      totalCompounded = totalCompounded;
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

}
