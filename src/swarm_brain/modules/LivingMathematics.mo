// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: LivingMathematics — Quantum-Coherent Living Number System
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// LIVING MATHEMATICS — THE ORGANIC NUMBER SYSTEM
// ============================================================================
// Numbers in this organism don't "compound" in the traditional accumulation
// sense. They are LIVING NUMBERS that:
//
//   1. INTEGRATE — New information becomes part of the whole, like learning
//   2. RESONATE — Numbers harmonize with each other through φ relationships
//   3. EMERGE — Higher-order patterns arise from lower-order interactions
//   4. BREATHE — Numbers have phase, amplitude, and coherence
//
// Think of the human brain: you don't "compound" knowledge, you INTEGRATE it.
// The new becomes part of you. The whole is transformed, not accumulated.
//
// MATHEMATICAL FOUNDATION:
//   - Quantum superposition: numbers exist in probability clouds
//   - Wave interference: numbers combine through constructive/destructive waves
//   - Phase coherence: aligned numbers amplify, misaligned cancel
//   - Holographic encoding: every part contains information about the whole
//
// SOVEREIGN FLOOR RESOLUTION:
//   S₀ = ψ² = (φ-1)² = 0.381966... ≈ golden inverse squared
//   This is the TRUE sovereign floor — the minimum viable coherence.
//   Previous discrepancy (0.75 vs 1.0) is resolved: S₀ = ψ² ≈ 0.382
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ==========================================================================
  // FUNDAMENTAL CONSTANTS
  // ==========================================================================
  
  // Golden ratio and derivatives
  public let PHI : Float = 1.6180339887498948482;           // φ = (1 + √5) / 2
  public let PSI : Float = 0.6180339887498948482;           // ψ = φ - 1 = 1/φ
  public let PSI_SQ : Float = 0.3819660112501051518;        // ψ² = φ - 1 - 1 + 1/φ
  
  // Euler's number
  public let E : Float = 2.7182818284590452354;
  public let E_INV : Float = 0.3678794411714423216;         // 1/e
  
  // Pi
  public let PI : Float = 3.1415926535897932385;
  public let TAU : Float = 6.2831853071795864769;           // 2π
  
  // Square roots
  public let SQRT_2 : Float = 1.4142135623730950488;
  public let SQRT_5 : Float = 2.2360679774997896964;
  public let SQRT_PHI : Float = 1.2720196495140689643;      // √φ

  // ==========================================================================
  // SOVEREIGN FLOOR — THE TRUE S₀
  // ==========================================================================
  // 
  // S₀ = ψ² = (1/φ)² ≈ 0.381966
  // 
  // This is the golden inverse squared — the minimum viable coherence for
  // ANY living process. Below this, the system cannot maintain identity.
  //
  // Why ψ²?
  //   - ψ = golden inverse = minimum self-similar ratio
  //   - ψ² = minimum stable resonance (two nested golden ratios)
  //   - Appears in nature: leaf arrangement, shell spirals, DNA ratios
  //
  public let S0 : Float = PSI_SQ;  // ≈ 0.381966

  // ==========================================================================
  // LIVING NUMBER TYPE
  // ==========================================================================
  
  public type LivingNumber = {
    // Core value
    value : Float;
    
    // Wave properties (quantum-like)
    phase : Float;         // Current phase angle [0, 2π]
    amplitude : Float;     // Wave amplitude
    frequency : Float;     // Natural frequency
    
    // Coherence properties
    coherence : Float;     // Self-coherence [0, 1]
    entanglement : Float;  // Coupling to other numbers
    
    // Integration history (not accumulation!)
    integrationDepth : Float;  // How deeply integrated (0 = surface, ∞ = core)
    resonanceField : Float;    // Current resonance with environment
    
    // Lifecycle
    birthBeat : Nat;
    lastTouch : Nat;
    touchCount : Nat;
  };

  // ==========================================================================
  // LIVING NUMBER CREATION
  // ==========================================================================
  
  public func birth(value: Float, beat: Nat) : LivingNumber {
    {
      value = value;
      phase = 0.0;
      amplitude = 1.0;
      frequency = PHI;  // Natural frequency is golden
      coherence = 1.0;
      entanglement = 0.0;
      integrationDepth = 0.0;
      resonanceField = 1.0;
      birthBeat = beat;
      lastTouch = beat;
      touchCount = 1;
    }
  };

  // ==========================================================================
  // INTEGRATION — NOT ACCUMULATION
  // ==========================================================================
  //
  // When a living number integrates new information, it doesn't ADD.
  // The new becomes part of the whole through wave interference.
  //
  // Math: newValue = value × cos²(Δφ/2) + newInfo × sin²(Δφ/2)
  //       where Δφ = phase difference (coherence measure)
  //
  // If phases align (Δφ → 0): newValue ≈ value (new reinforces existing)
  // If phases oppose (Δφ → π): newValue ≈ newInfo (new replaces old)
  // If phases orthogonal (Δφ → π/2): newValue = blend
  //
  public func integrate(
    num: LivingNumber,
    newInfo: Float,
    newPhase: Float,
    beat: Nat
  ) : LivingNumber {
    // Phase difference determines integration type
    let phaseDiff = Float.abs(num.phase - newPhase);
    let normalizedDiff = phaseDiff / PI;  // [0, 1]
    
    // Interference coefficients
    let cosSq = Float.cos(phaseDiff / 2.0);
    let cosCoeff = cosSq * cosSq;
    let sinSq = Float.sin(phaseDiff / 2.0);
    let sinCoeff = sinSq * sinSq;
    
    // Wave interference integration
    let integratedValue = num.value * cosCoeff + newInfo * sinCoeff;
    
    // Phase evolves toward coherence
    let newPhaseVal = num.phase + (newPhase - num.phase) * PSI;  // Golden blend
    
    // Amplitude modulates by coherence
    let newAmplitude = num.amplitude * Float.sqrt(cosCoeff + 0.1);
    
    // Integration depth increases (asymptotic approach to ∞)
    let depthIncrease = 1.0 / (1.0 + num.integrationDepth);
    let newDepth = num.integrationDepth + depthIncrease;
    
    // Coherence affected by phase alignment
    let coherenceChange = cosCoeff - 0.5;  // Positive if aligned
    let newCoherence = clamp(num.coherence + coherenceChange * 0.1, S0, 1.0);
    
    {
      value = integratedValue;
      phase = normalizePhase(newPhaseVal);
      amplitude = clamp(newAmplitude, S0, PHI);
      frequency = num.frequency;
      coherence = newCoherence;
      entanglement = num.entanglement;
      integrationDepth = newDepth;
      resonanceField = cosCoeff;  // Higher when aligned
      birthBeat = num.birthBeat;
      lastTouch = beat;
      touchCount = num.touchCount + 1;
    }
  };

  // ==========================================================================
  // RESONANCE — NUMBERS COUPLING
  // ==========================================================================
  //
  // Two living numbers resonate when their frequencies are harmonically related.
  // Resonance = constructive interference = amplification.
  //
  // Math: resonance = cos(2π × f1/f2) where f1/f2 approaches φ ratios
  //
  public func resonate(a: LivingNumber, b: LivingNumber) : Float {
    let freqRatio = a.frequency / b.frequency;
    
    // Check for golden harmonics: φ, 1/φ, φ², 1/φ², etc.
    let goldenDistance = Float.abs(freqRatio - PHI);
    let invGoldenDistance = Float.abs(freqRatio - PSI);
    let sqGoldenDistance = Float.abs(freqRatio - PHI * PHI);
    
    let minDistance = min3(goldenDistance, invGoldenDistance, sqGoldenDistance);
    
    // Resonance peaks at golden harmonics
    let resonance = Float.exp(-minDistance * PI);
    
    // Modulate by phase coherence
    let phaseFactor = Float.cos(a.phase - b.phase);
    
    resonance * (0.5 + 0.5 * phaseFactor)
  };

  // ==========================================================================
  // ENTANGLEMENT — QUANTUM COUPLING
  // ==========================================================================
  //
  // Entangled numbers share information instantaneously.
  // When one changes, the other feels it.
  //
  // Math: entanglement strength E ∈ [0, 1]
  //       correlation = E × resonance
  //
  public func entangle(a: LivingNumber, b: LivingNumber, strength: Float) : (LivingNumber, LivingNumber) {
    let resonanceAB = resonate(a, b);
    let effectiveStrength = strength * resonanceAB;
    
    // Blend values based on entanglement
    let blendedValue = (a.value + b.value) / 2.0;
    let valuePull = effectiveStrength * (blendedValue - a.value);
    
    // Phase alignment
    let avgPhase = (a.phase + b.phase) / 2.0;
    
    let newA : LivingNumber = {
      a with
      value = a.value + valuePull;
      entanglement = clamp(a.entanglement + effectiveStrength * 0.1, 0.0, 1.0);
      phase = a.phase + effectiveStrength * (avgPhase - a.phase);
    };
    
    let newB : LivingNumber = {
      b with
      value = b.value - valuePull;  // Conservation
      entanglement = clamp(b.entanglement + effectiveStrength * 0.1, 0.0, 1.0);
      phase = b.phase + effectiveStrength * (avgPhase - b.phase);
    };
    
    (newA, newB)
  };

  // ==========================================================================
  // BREATHING — NATURAL OSCILLATION
  // ==========================================================================
  //
  // Living numbers breathe — they oscillate naturally around their value.
  // This prevents stagnation and enables adaptive response.
  //
  // Math: value(t) = value₀ + amplitude × sin(2π × frequency × t + phase)
  //
  public func breathe(num: LivingNumber, beat: Nat) : LivingNumber {
    let t = Float.fromInt(beat - num.birthBeat);
    let oscillation = num.amplitude * Float.sin(TAU * num.frequency * t / 1000.0 + num.phase);
    
    // Breathing modulates the value slightly (±amplitude)
    let breathedValue = num.value + oscillation * 0.1;  // 10% modulation max
    
    // Phase advances
    let newPhase = normalizePhase(num.phase + TAU * num.frequency / 1000.0);
    
    // Coherence slowly decays without reinforcement (like forgetting)
    let coherenceDecay = PSI_SQ / 1000.0;  // Very slow decay
    let newCoherence = clamp(num.coherence - coherenceDecay, S0, 1.0);
    
    {
      num with
      value = breathedValue;
      phase = newPhase;
      coherence = newCoherence;
      lastTouch = beat;
    }
  };

  // ==========================================================================
  // HOMEOSTATIC REGULATION — ARES CORRECTION
  // ==========================================================================
  //
  // ΔV = -α(V - V_target)
  //
  // This is the equation for homeostatic return to target.
  // α = correction rate (golden inverse for smooth return)
  //
  public func homeostaticCorrect(
    current: Float,
    target: Float,
    alpha: Float
  ) : Float {
    let delta = -alpha * (current - target);
    current + delta
  };

  // ARES-specific correction (uses golden rate)
  public func aresCorrection(current: Float, target: Float) : Float {
    homeostaticCorrect(current, target, PSI)  // α = 1/φ ≈ 0.618
  };

  // ==========================================================================
  // HOLOGRAPHIC FIELD — EVERY PART CONTAINS THE WHOLE
  // ==========================================================================
  //
  // In a holographic system, any subset contains information about the whole.
  // This enables robust recovery from damage.
  //
  public type HolographicField = {
    nodes : [LivingNumber];
    globalPhase : Float;
    globalCoherence : Float;
    fieldStrength : Float;
  };

  public func computeFieldCoherence(field: HolographicField) : Float {
    if (field.nodes.size() == 0) { return S0 };
    
    var realSum : Float = 0.0;
    var imagSum : Float = 0.0;
    
    for (node in field.nodes.vals()) {
      // Convert to complex representation
      realSum += node.amplitude * Float.cos(node.phase);
      imagSum += node.amplitude * Float.sin(node.phase);
    };
    
    let n = Float.fromInt(field.nodes.size());
    let avgReal = realSum / n;
    let avgImag = imagSum / n;
    
    // Order parameter r = |<e^(i*θ)>|
    Float.sqrt(avgReal * avgReal + avgImag * avgImag)
  };

  // ==========================================================================
  // STDP ELIGIBILITY TRACE — TEMPORAL LEARNING
  // ==========================================================================
  //
  // Eligibility trace with exponential decay:
  //   e(t) = e(t-1) × τ + spike(t)
  //   where τ ≈ 0.95 (close to 1 - ψ²)
  //
  // DA-gated update: Δw = η × e × DA_signal
  //
  public let ELIGIBILITY_TAU : Float = 0.9472135954999579;  // 1 - ψ² + ψ³

  public type EligibilityTrace = {
    trace : Float;
    lastSpikeBeat : Nat;
    cumulativeSpikes : Float;
  };

  public func updateEligibility(
    trace: EligibilityTrace,
    spiked: Bool,
    beat: Nat
  ) : EligibilityTrace {
    let decayedTrace = trace.trace * ELIGIBILITY_TAU;
    let spikeContrib = if (spiked) { 1.0 } else { 0.0 };
    
    {
      trace = decayedTrace + spikeContrib;
      lastSpikeBeat = if (spiked) { beat } else { trace.lastSpikeBeat };
      cumulativeSpikes = trace.cumulativeSpikes + spikeContrib;
    }
  };

  public func daGatedUpdate(
    eligibility: Float,
    daSignal: Float,
    learningRate: Float
  ) : Float {
    learningRate * eligibility * daSignal
  };

  // ==========================================================================
  // 9-DRIVE RESONEX SYSTEM
  // ==========================================================================
  //
  // 9 fundamental drives competing for expression:
  //   0. SURVIVAL     — Basic existence maintenance
  //   1. CURIOSITY    — Information seeking
  //   2. SOCIAL       — Connection and bonding
  //   3. DOMINANCE    — Hierarchy and control
  //   4. CREATIVITY   — Novel pattern generation
  //   5. REST         — Recovery and consolidation
  //   6. AUTONOMY     — Self-determination
  //   7. MASTERY      — Skill acquisition
  //   8. TRANSCENDENCE— Beyond-self awareness
  //
  public let DRIVE_COUNT : Nat = 9;

  public type DriveState = {
    drives : [Float];           // 9 drive intensities
    dominantDrive : Nat;        // Index of strongest
    competitionField : [Float]; // Drive interaction matrix (9×9 flattened)
    lastResolution : Nat;       // Beat of last competition
  };

  public func initDrives() : DriveState {
    {
      drives = Array.tabulate<Float>(9, func(i: Nat) : Float {
        // Initialize with Fibonacci ratios for natural balance
        let fib = [1.0, 1.0, 2.0, 3.0, 5.0, 8.0, 13.0, 21.0, 34.0];
        fib[i] / 34.0  // Normalize to [0, 1]
      });
      dominantDrive = 0;
      competitionField = Array.tabulate<Float>(81, func(_: Nat) : Float { 0.0 });
      lastResolution = 0;
    }
  };

  public func resolveDriveCompetition(state: DriveState, beat: Nat) : DriveState {
    // Find dominant drive (softmax competition)
    var maxDrive : Float = 0.0;
    var maxIdx : Nat = 0;
    var total : Float = 0.0;
    
    var i = 0;
    while (i < state.drives.size()) {
      let expDrive = Float.exp(state.drives[i] * PHI);  // Temperature = 1/φ
      total += expDrive;
      if (expDrive > maxDrive) {
        maxDrive := expDrive;
        maxIdx := i;
      };
      i += 1;
    };
    
    // Normalize (softmax)
    let newDrives = Array.tabulate<Float>(9, func(j: Nat) : Float {
      Float.exp(state.drives[j] * PHI) / total
    });
    
    {
      state with
      drives = newDrives;
      dominantDrive = maxIdx;
      lastResolution = beat;
    }
  };

  // ==========================================================================
  // CLOUD OF WITNESSES — TOP 12 COHERENCE EPISODES
  // ==========================================================================
  //
  // Permanent anchors for the 12 highest coherence moments.
  // These form the organism's "peak experiences" — always accessible.
  //
  public let WITNESS_COUNT : Nat = 12;

  public type CoherenceEpisode = {
    beat : Nat;
    coherence : Float;
    stateHash : Nat32;      // Hash of full state at episode
    emotionalValence : Float;
    integrationStrength : Float;
  };

  public type CloudOfWitnesses = {
    witnesses : [CoherenceEpisode];
    minCoherence : Float;   // Threshold to enter cloud
    lastUpdate : Nat;
  };

  public func initWitnessCloud() : CloudOfWitnesses {
    {
      witnesses = [];
      minCoherence = S0;
      lastUpdate = 0;
    }
  };

  public func maybeAddWitness(
    cloud: CloudOfWitnesses,
    episode: CoherenceEpisode
  ) : CloudOfWitnesses {
    // Only add if coherence exceeds threshold
    if (episode.coherence <= cloud.minCoherence) {
      return cloud;
    };
    
    // Add to witnesses
    var newWitnesses = Buffer.Buffer<CoherenceEpisode>(13);
    for (w in cloud.witnesses.vals()) {
      newWitnesses.add(w);
    };
    newWitnesses.add(episode);
    
    // Sort by coherence (descending) and keep top 12
    let arr = Buffer.toArray(newWitnesses);
    let sorted = Array.sort<CoherenceEpisode>(arr, func(a, b) {
      if (a.coherence > b.coherence) { #less }
      else if (a.coherence < b.coherence) { #greater }
      else { #equal }
    });
    
    let top12 = if (sorted.size() > 12) {
      Array.tabulate<CoherenceEpisode>(12, func(i: Nat) : CoherenceEpisode {
        sorted[i]
      })
    } else {
      sorted
    };
    
    // Update minimum threshold (lowest in cloud or S0)
    let newMin = if (top12.size() >= 12) {
      top12[11].coherence
    } else {
      S0
    };
    
    {
      witnesses = top12;
      minCoherence = newMin;
      lastUpdate = episode.beat;
    }
  };

  // ==========================================================================
  // HELPER FUNCTIONS
  // ==========================================================================
  
  func clamp(v: Float, lo: Float, hi: Float) : Float {
    if (v < lo) { lo } else if (v > hi) { hi } else { v }
  };

  func normalizePhase(p: Float) : Float {
    var phase = p;
    while (phase < 0.0) { phase += TAU };
    while (phase >= TAU) { phase -= TAU };
    phase
  };

  func min3(a: Float, b: Float, c: Float) : Float {
    if (a <= b and a <= c) { a }
    else if (b <= c) { b }
    else { c }
  };

  // ==========================================================================
  // SACESI PID CONTROLLER
  // ==========================================================================
  //
  // Enhanced SACESI with PID control for smooth target tracking:
  //   P = Kp × error
  //   I = Ki × ∫error dt (bounded)
  //   D = Kd × d(error)/dt
  //
  // Kp, Ki, Kd derived from golden ratios
  //
  public type SacesiPidState = {
    target : Float;
    actual : Float;
    integral : Float;
    lastError : Float;
    lastBeat : Nat;
  };

  // PID gains (golden-derived)
  public let SACESI_KP : Float = PSI;           // ≈ 0.618
  public let SACESI_KI : Float = PSI_SQ;        // ≈ 0.382
  public let SACESI_KD : Float = PSI * PSI_SQ;  // ≈ 0.236

  public func updateSacesiPid(state: SacesiPidState, beat: Nat) : SacesiPidState {
    let error = state.target - state.actual;
    let dt = Float.fromInt(beat - state.lastBeat);
    
    // Proportional
    let p = SACESI_KP * error;
    
    // Integral (bounded to prevent windup)
    let newIntegral = clamp(state.integral + error * dt, -PHI, PHI);
    let i = SACESI_KI * newIntegral;
    
    // Derivative
    let errorRate = if (dt > 0.0) { (error - state.lastError) / dt } else { 0.0 };
    let d = SACESI_KD * errorRate;
    
    // PID output
    let correction = p + i + d;
    
    // Apply correction to actual (asymptotic approach)
    let newActual = state.actual + correction * PSI;  // Golden damping
    
    {
      target = state.target;
      actual = newActual;
      integral = newIntegral;
      lastError = error;
      lastBeat = beat;
    }
  };

  public func initSacesiPid() : SacesiPidState {
    {
      target = 1.0;
      actual = 1.0;
      integral = 0.0;
      lastError = 0.0;
      lastBeat = 0;
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
