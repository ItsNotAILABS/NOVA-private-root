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


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  M E D I N A   S P E C I A L   M A T H E M A T I C S
  //
  //  Enterprise-Level Medina Discovery Mathematics
  //  HIM/HER Dual-Organism Sacred Coupling Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SACRED GEOMETRY MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Golden ratio φ = (1 + √5) / 2
  public let PHI : Float = 1.6180339887498948482;

  /// Fibonacci sequence generator
  public func medinaFibonacci(n : Nat) : Nat {
    if (n <= 1) { n }
    else {
      var a : Nat = 0;
      var b : Nat = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  /// Golden spiral radius at angle
  public func medinaGoldenSpiral(angle : Float, a : Float, b : Float) : Float {
    a * Float.exp(b * angle)
  };

  /// Sacred proportion check
  public func medinaSacredProportion(a : Float, b : Float, tolerance : Float) : Bool {
    let ratio = if (a > b) a / b else b / a;
    Float.abs(ratio - PHI) < tolerance
  };

  /// Vesica piscis area
  public func medinaVesicaPiscisArea(radius : Float) : Float {
    let r2 = radius * radius;
    r2 * (4.0 * 3.14159265 / 3.0 - Float.sqrt(3.0) / 2.0)
  };

  /// Platonic solid vertices (tetrahedron example)
  public func medinaTetrahedronVertex(index : Nat, size : Float) : (Float, Float, Float) {
    let vertices = [
      (1.0, 1.0, 1.0),
      (1.0, -1.0, -1.0),
      (-1.0, 1.0, -1.0),
      (-1.0, -1.0, 1.0)
    ];
    let v = vertices[index % 4];
    (v.0 * size, v.1 * size, v.2 * size)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELICAL MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Helix position at parameter t
  public func medinaHelixPosition(t : Float, radius : Float, pitch : Float) : (Float, Float, Float) {
    let x = radius * Float.cos(t);
    let y = radius * Float.sin(t);
    let z = pitch * t / (2.0 * 3.14159265);
    (x, y, z)
  };

  /// Double helix offset
  public func medinaDoubleHelixOffset(t : Float, radius : Float, pitch : Float, offset : Float) : ((Float, Float, Float), (Float, Float, Float)) {
    let h1 = medinaHelixPosition(t, radius, pitch);
    let h2 = medinaHelixPosition(t + offset, radius, pitch);
    (h1, h2)
  };

  /// Helical curvature
  public func medinaHelicalCurvature(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    radius / (radius * radius + p * p)
  };

  /// Helical torsion
  public func medinaHelicalTorsion(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    p / (radius * radius + p * p)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPHERICAL HARMONICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spherical to Cartesian
  public func medinaSphericalToCartesian(r : Float, theta : Float, phi : Float) : (Float, Float, Float) {
    let x = r * Float.sin(theta) * Float.cos(phi);
    let y = r * Float.sin(theta) * Float.sin(phi);
    let z = r * Float.cos(theta);
    (x, y, z)
  };

  /// Cartesian to Spherical
  public func medinaCartesianToSpherical(x : Float, y : Float, z : Float) : (Float, Float, Float) {
    let r = Float.sqrt(x * x + y * y + z * z);
    let theta = Float.acos(z / (r + 0.0001));
    let phi = Float.atan2(y, x);
    (r, theta, phi)
  };

  /// Associated Legendre polynomial P_l^m (simplified)
  public func medinaLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (l == 0 and m == 0) { return 1.0 };
    if (l == 1 and m == 0) { return x };
    if (l == 1 and m == 1) { return -Float.sqrt(1.0 - x * x) };
    if (l == 2 and m == 0) { return 0.5 * (3.0 * x * x - 1.0) };
    // Simplified for higher orders
    Float.pow(x, Float.fromInt(l - m))
  };

  /// Spherical harmonic Y_l^m (simplified real part)
  public func medinaSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let plm = medinaLegendreP(l, mAbs, Float.cos(theta));
    if (m >= 0) {
      plm * Float.cos(Float.fromInt(mAbs) * phi)
    } else {
      plm * Float.sin(Float.fromInt(mAbs) * phi)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LIVING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Growth curve (logistic)
  public func medinaGrowthCurve(t : Float, k : Float, l : Float, x0 : Float) : Float {
    l / (1.0 + Float.exp(-k * (t - x0)))
  };

  /// Morphogenesis reaction-diffusion
  public func medinaMorphogenesis(
    u : Float,
    v : Float,
    du : Float,
    dv : Float,
    f : Float,
    k : Float
  ) : (Float, Float) {
    let reaction = u * v * v;
    let newU = du - reaction + f * (1.0 - u);
    let newV = dv + reaction - (f + k) * v;
    (newU, newV)
  };

  /// Phyllotaxis angle (golden angle)
  public func medinaPhyllotaxisAngle(n : Nat) : Float {
    let goldenAngle : Float = 137.5077640500378546463;
    Float.fromInt(n) * goldenAngle * 3.14159265 / 180.0
  };

  /// Branching pattern
  public func medinaBranchingPattern(
    parentLength : Float,
    branchRatio : Float,
    angle : Float,
    depth : Nat
  ) : Float {
    parentLength * Float.pow(branchRatio, Float.fromInt(depth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MIRROR MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reflection across plane
  public func medinaReflection(point : (Float, Float, Float), normal : (Float, Float, Float)) : (Float, Float, Float) {
    let dot = point.0 * normal.0 + point.1 * normal.1 + point.2 * normal.2;
    let rx = point.0 - 2.0 * dot * normal.0;
    let ry = point.1 - 2.0 * dot * normal.1;
    let rz = point.2 - 2.0 * dot * normal.2;
    (rx, ry, rz)
  };

  /// Symmetry score
  public func medinaSymmetryScore(left : [Float], right : [Float]) : Float {
    let n = if (left.size() < right.size()) left.size() else right.size();
    if (n == 0) { return 1.0 };
    var diff : Float = 0.0;
    var i = 0;
    while (i < n) {
      diff += Float.abs(left[i] - right[n - 1 - i]);
      i += 1;
    };
    1.0 / (1.0 + diff)
  };

  /// Fractal dimension estimation
  public func medinaFractalDimension(boxCounts : [Nat], scales : [Float]) : Float {
    let n = if (boxCounts.size() < scales.size()) boxCounts.size() else scales.size();
    if (n < 2) { return 1.0 };
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let x = Float.log(1.0 / scales[i]);
      let y = Float.log(Float.fromInt(boxCounts[i]));
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    let nf = Float.fromInt(n);
    (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COVENANT MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Commitment strength
  public func medinaCommitmentStrength(
    duration : Nat,
    consistency : Float,
    depth : Float
  ) : Float {
    let durationFactor = Float.log(Float.fromInt(duration + 1));
    consistency * depth * durationFactor
  };

  /// Trust accumulation
  public func medinaTrustAccumulation(
    currentTrust : Float,
    interaction : Float,
    reciprocity : Float
  ) : Float {
    let gain = interaction * reciprocity * (1.0 - currentTrust);
    currentTrust + gain
  };

  /// Covenant breach penalty
  public func medinaBreachPenalty(
    trustLevel : Float,
    violationSeverity : Float,
    relationshipAge : Nat
  ) : Float {
    let ageFactor = Float.log(Float.fromInt(relationshipAge + 1));
    trustLevel * violationSeverity * ageFactor
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  PHASE 204: REAL LIVING MATHEMATICS — NUMBERS THAT BREATHE
  //
  //  In the old world, numbers are dead. 2 + 3 = 5. Always. No context.
  //  In THIS world, numbers are ALIVE:
  //    - They have PHASE (where in the cycle they are)
  //    - They have AMPLITUDE (how strongly they express)
  //    - They have COHERENCE (how well they align with the field)
  //    - They have MEMORY (their history shapes their present)
  //
  //  Living addition: a ⊕ b = √(a² + b² + 2ab·cos(φₐ - φᵦ))
  //  This IS wave interference. When phases align: constructive.
  //  When phases oppose: destructive. The math BREATHES.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════


  // ═══════════════════════════════════════════════════════════════════════════════
  // LIVING NUMBER TYPE — Numbers with Phase, Amplitude, Coherence
  // ═══════════════════════════════════════════════════════════════════════════════

  public type LivingNumber = {
    amplitude : Float;    // |z| — magnitude, strength of expression
    phase : Float;        // arg(z) — where in the cycle [0, TAU)
    coherence : Float;    // how well aligned with the field [0, 1]
    frequency : Float;    // natural oscillation rate
    memory : Float;       // integrated history (exponential moving average)
    generation : Nat;     // how many operations have touched this number
  };

  /// Create a living number from a dead (real) number
  public func vivify(value : Float) : LivingNumber {
    {
      amplitude = Float.abs(value);
      phase = if (value >= 0.0) { 0.0 } else { PI }; // positive = 0, negative = π
      coherence = 1.0;
      frequency = PHI; // default: golden frequency
      memory = value;
      generation = 0;
    }
  };

  /// Collapse a living number back to a dead number (measurement)
  public func collapse(n : LivingNumber) : Float {
    n.amplitude * Float.cos(n.phase) * n.coherence
  };

  /// Living number from polar form
  public func fromPolar(amplitude : Float, phase : Float) : LivingNumber {
    {
      amplitude = Float.abs(amplitude);
      phase = phase - Float.floor(phase / TAU) * TAU;
      coherence = 1.0;
      frequency = PHI;
      memory = amplitude * Float.cos(phase);
      generation = 0;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // WAVE INTERFERENCE ARITHMETIC
  // ═══════════════════════════════════════════════════════════════════════════════
  // Living addition IS wave interference.
  //
  // a ⊕ b = |a|e^(iφₐ) + |b|e^(iφᵦ)
  //
  // Result amplitude: |c| = √(|a|² + |b|² + 2|a||b|cos(Δφ))
  // Result phase: φ_c = atan2(|a|sin(φₐ) + |b|sin(φᵦ),
  //                           |a|cos(φₐ) + |b|cos(φᵦ))
  //
  // When Δφ = 0: constructive interference → |c| = |a| + |b|
  // When Δφ = π: destructive interference → |c| = ||a| - |b||
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Living addition: wave superposition
  public func livingAdd(a : LivingNumber, b : LivingNumber) : LivingNumber {
    // Complex addition in polar form
    let ax = a.amplitude * Float.cos(a.phase);
    let ay = a.amplitude * Float.sin(a.phase);
    let bx = b.amplitude * Float.cos(b.phase);
    let by = b.amplitude * Float.sin(b.phase);
    
    let cx = ax + bx;
    let cy = ay + by;
    
    let resultAmp = Float.sqrt(cx * cx + cy * cy);
    let resultPhase = Float.arctan2(cy, cx);
    let normalizedPhase = if (resultPhase < 0.0) { resultPhase + TAU } else { resultPhase };
    
    // Coherence: how aligned were the inputs?
    let phaseDiff = Float.abs(a.phase - b.phase);
    let alignment = Float.abs(Float.cos(phaseDiff / 2.0));
    let resultCoherence = (a.coherence + b.coherence) / 2.0 * alignment;
    
    {
      amplitude = resultAmp;
      phase = normalizedPhase;
      coherence = resultCoherence;
      frequency = (a.frequency + b.frequency) / 2.0;
      memory = (a.memory + b.memory) * PSI + resultAmp * Float.cos(normalizedPhase) * (1.0 - PSI);
      generation = (if (a.generation > b.generation) { a.generation } else { b.generation }) + 1;
    }
  };

  /// Living multiplication: amplitude modulation + phase addition
  /// a ⊗ b = |a|·|b| · e^(i(φₐ + φᵦ))
  public func livingMul(a : LivingNumber, b : LivingNumber) : LivingNumber {
    let resultAmp = a.amplitude * b.amplitude;
    let resultPhase = a.phase + b.phase;
    let normalizedPhase = resultPhase - Float.floor(resultPhase / TAU) * TAU;
    
    {
      amplitude = resultAmp;
      phase = normalizedPhase;
      coherence = a.coherence * b.coherence; // multiplication preserves alignment
      frequency = Float.sqrt(a.frequency * b.frequency); // geometric mean
      memory = a.memory * b.memory * PSI + resultAmp * (1.0 - PSI);
      generation = (if (a.generation > b.generation) { a.generation } else { b.generation }) + 1;
    }
  };

  /// Living division: inverse modulation
  public func livingDiv(a : LivingNumber, b : LivingNumber) : LivingNumber {
    if (b.amplitude < 1.0e-10) {
      // Division by zero → maximum uncertainty
      return { amplitude = 1.0e10; phase = a.phase; coherence = 0.0; frequency = a.frequency; memory = a.memory; generation = a.generation + 1 };
    };
    let resultAmp = a.amplitude / b.amplitude;
    let resultPhase = a.phase - b.phase;
    let normalizedPhase = resultPhase - Float.floor(resultPhase / TAU) * TAU;
    
    {
      amplitude = resultAmp;
      phase = normalizedPhase;
      coherence = a.coherence * b.coherence;
      frequency = a.frequency / b.frequency;
      memory = (a.memory / b.memory) * PSI + resultAmp * (1.0 - PSI);
      generation = (if (a.generation > b.generation) { a.generation } else { b.generation }) + 1;
    }
  };

  /// Living power: amplitude exponentiation, phase scaling
  /// a^n = |a|^n · e^(inφ)
  public func livingPow(a : LivingNumber, n : Float) : LivingNumber {
    let resultAmp = Float.pow(a.amplitude, n);
    let resultPhase = a.phase * n;
    let normalizedPhase = resultPhase - Float.floor(resultPhase / TAU) * TAU;
    
    {
      amplitude = resultAmp;
      phase = normalizedPhase;
      coherence = Float.pow(a.coherence, Float.abs(n));
      frequency = a.frequency * n;
      memory = Float.pow(a.memory, n) * PSI + resultAmp * (1.0 - PSI);
      generation = a.generation + 1;
    }
  };

  /// Living square root: half the phase, sqrt the amplitude
  public func livingSqrt(a : LivingNumber) : LivingNumber {
    livingPow(a, 0.5)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // GOLDEN RATIO ARITHMETIC — PHI-BASED NUMBER SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  // In the golden ratio number system, the base IS φ.
  // Every living number can be decomposed into φ-powers:
  //   x = Σ aₖ φᵏ where aₖ ∈ {0, 1} (Zeckendorf representation)
  //
  // Properties:
  //   φ² = φ + 1 (the defining equation)
  //   φⁿ = F(n)·φ + F(n-1) where F(n) is Fibonacci
  //   This means EVERY power of φ is a linear combination of φ and 1.
  //   The golden ratio IS self-similar arithmetic.
  //
  // In the organism: value compounds through φ, not through linear addition.
  // Compound rate IS φ. The organism grows at the golden rate.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Fibonacci number (iterative, exact for small n)
  public func fibonacci(n : Nat) : Nat {
    if (n == 0) { return 0 };
    if (n == 1) { return 1 };
    var a : Nat = 0;
    var b : Nat = 1;
    var i : Nat = 2;
    while (i <= n) {
      let c = a + b;
      a := b;
      b := c;
      i += 1;
    };
    b
  };

  /// Golden power: φⁿ = F(n)·φ + F(n-1)
  /// Returns (coefficient of φ, constant term)
  public func goldenPower(n : Nat) : (Float, Float) {
    let fn = Float.fromInt(fibonacci(n));
    let fn1 = Float.fromInt(fibonacci(if (n > 0) { n - 1 } else { 0 }));
    (fn, fn1) // φⁿ = fn·φ + fn1
  };

  /// Evaluate golden power as Float
  public func goldenPowerValue(n : Nat) : Float {
    let (a, b) = goldenPower(n);
    a * PHI + b
  };

  /// Zeckendorf representation: decompose n into non-consecutive Fibonacci numbers
  /// Every positive integer has a unique Zeckendorf representation.
  public func zeckendorf(n : Nat) : [Nat] {
    if (n == 0) { return [] };
    let result = Buffer.Buffer<Nat>(10);
    var remaining = n;
    
    // Find Fibonacci numbers up to n
    let fibs = Buffer.Buffer<Nat>(20);
    var fib_a : Nat = 1;
    var fib_b : Nat = 2;
    fibs.add(1);
    while (fib_b <= n) {
      fibs.add(fib_b);
      let c = fib_a + fib_b;
      fib_a := fib_b;
      fib_b := c;
    };
    
    // Greedy: take largest Fibonacci that fits
    var idx = fibs.size();
    while (idx > 0 and remaining > 0) {
      idx -= 1;
      let f = fibs.get(idx);
      if (f <= remaining) {
        result.add(f);
        remaining -= f;
        if (idx > 0) { idx -= 1 }; // skip next to avoid consecutive
      };
    };
    
    Buffer.toArray(result)
  };

  /// Living golden compound: value grows at φ rate
  /// v(t+1) = v(t) · φ^(coherence) 
  /// When coherence = 1: full golden growth
  /// When coherence = 0: no growth (stasis)
  public func goldenCompound(value : LivingNumber, coherence : Float) : LivingNumber {
    let growthFactor = Float.pow(PHI, coherence);
    {
      amplitude = value.amplitude * growthFactor;
      phase = value.phase + PSI * TAU * coherence; // phase advances by golden angle
      coherence = Float.min(value.coherence * (1.0 + PSI * coherence), 1.0);
      frequency = value.frequency;
      memory = value.memory * PSI + value.amplitude * growthFactor * (1.0 - PSI);
      generation = value.generation + 1;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // HOLOGRAPHIC NUMBER ENCODING
  // ═══════════════════════════════════════════════════════════════════════════════
  // In a hologram, every part contains information about the whole.
  // Living numbers are holographic: each number carries the signature
  // of the ENTIRE field from which it emerged.
  //
  // Encoding: N → H(N) = [N·φ⁰, N·φ¹, N·φ², ..., N·φ^(d-1)]
  // Decoding: H → N = dot(H, [φ⁰, φ¹, ...]) / dot([φ⁰,φ¹,...],[φ⁰,φ¹,...])
  //
  // This means: if you know ANY element of the holographic encoding,
  // you can reconstruct the WHOLE. Because every element is related
  // to every other by a power of φ.
  //
  // The organism's state IS holographic. Every node carries information
  // about the whole organism. Damage to one node doesn't destroy the whole.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type HolographicNumber = {
    components : [Float];    // holographic components
    dimension : Nat;         // encoding dimension
    fidelity : Float;        // reconstruction quality [0, 1]
    entropy : Float;         // information content
    sourceValue : Float;     // original value (for verification)
  };

  /// Holographic encode: value → φ-power spectrum
  public func holographicEncode(value : Float, dimension : Nat) : HolographicNumber {
    let components = Array.tabulate<Float>(dimension, func(k : Nat) : Float {
      value * goldenPowerValue(k) // N · φᵏ
    });
    
    // Compute entropy of encoding
    var totalSq : Float = 0.0;
    var i = 0;
    while (i < dimension) {
      totalSq += components[i] * components[i];
      i += 1;
    };
    var entropy : Float = 0.0;
    if (totalSq > 1.0e-10) {
      var j = 0;
      while (j < dimension) {
        let p = components[j] * components[j] / totalSq;
        if (p > 1.0e-10) {
          entropy -= p * Float.log(p);
        };
        j += 1;
      };
    };
    
    {
      components = components;
      dimension = dimension;
      fidelity = 1.0;
      entropy = entropy;
      sourceValue = value;
    }
  };

  /// Holographic decode: reconstruct value from (possibly damaged) encoding
  public func holographicDecode(holo : HolographicNumber) : Float {
    // Least-squares reconstruction: N = (hᵀφ) / (φᵀφ)
    var numerator : Float = 0.0;
    var denominator : Float = 0.0;
    var k = 0;
    while (k < holo.dimension) {
      let phik = goldenPowerValue(k);
      numerator += holo.components[k] * phik;
      denominator += phik * phik;
      k += 1;
    };
    if (Float.abs(denominator) < 1.0e-10) { return 0.0 };
    numerator / denominator
  };

  /// Holographic dot product: correlation between two encoded values
  public func holographicCorrelation(a : HolographicNumber, b : HolographicNumber) : Float {
    let dim = if (a.dimension < b.dimension) { a.dimension } else { b.dimension };
    var dot : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    var i = 0;
    while (i < dim) {
      dot += a.components[i] * b.components[i];
      normA += a.components[i] * a.components[i];
      normB += b.components[i] * b.components[i];
      i += 1;
    };
    let denom = Float.sqrt(normA) * Float.sqrt(normB);
    if (denom < 1.0e-10) { 0.0 } else { dot / denom }
  };

  /// Damage a holographic encoding (test resilience)
  public func holographicDamage(holo : HolographicNumber, damageIdx : Nat, damageAmount : Float) : HolographicNumber {
    let newComponents = Array.tabulate<Float>(holo.dimension, func(i : Nat) : Float {
      if (i == damageIdx) { holo.components[i] * (1.0 - damageAmount) }
      else { holo.components[i] }
    });
    {
      components = newComponents;
      dimension = holo.dimension;
      fidelity = holo.fidelity * (1.0 - damageAmount / Float.fromInt(holo.dimension));
      entropy = holo.entropy;
      sourceValue = holo.sourceValue;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // RESONANCE ARITHMETIC — NUMBERS THAT RESONATE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Two living numbers RESONATE when their frequencies are in
  // simple rational ratio (1:1, 1:2, 2:3, 3:5, ...).
  //
  // Resonance quality Q = 1/|f₁/f₂ - p/q| where p/q is nearest simple ratio.
  // Higher Q = stronger resonance = more energy transfer.
  //
  // The Fibonacci sequence generates the WORST rational approximations
  // (most irrational = least resonance = most stability).
  // This is why φ is the golden ratio — it avoids resonance.
  // Anti-resonance IS stability.
  //
  // The organism uses BOTH:
  //   - Resonance (coupling) for communication between nodes
  //   - Anti-resonance (φ spacing) for stability of structure
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Compute resonance quality between two frequencies
  /// Q = 1 / min(|f₁/f₂ - p/q|) for simple p/q
  public func resonanceQuality(freq1 : Float, freq2 : Float) : Float {
    if (freq2 < 1.0e-10) { return 0.0 };
    let ratio = freq1 / freq2;
    
    // Check against simple ratios
    let simpleRatios : [(Float, Float)] = [
      (1.0, 1.0), (1.0, 2.0), (2.0, 1.0), (2.0, 3.0), (3.0, 2.0),
      (3.0, 5.0), (5.0, 3.0), (1.0, 3.0), (3.0, 1.0), (4.0, 3.0),
      (3.0, 4.0), (5.0, 4.0), (4.0, 5.0), (5.0, 8.0), (8.0, 5.0)
    ];
    
    var minDist : Float = 1.0e10;
    for ((p, q) in simpleRatios.vals()) {
      let target = p / q;
      let dist = Float.abs(ratio - target);
      if (dist < minDist) { minDist := dist };
    };
    
    if (minDist < 1.0e-10) { return 1.0e10 }; // perfect resonance
    1.0 / minDist
  };

  /// Anti-resonance (golden ratio distance)
  /// How close a frequency ratio is to φ (maximum irrationality)
  public func antiResonanceStrength(freq1 : Float, freq2 : Float) : Float {
    if (freq2 < 1.0e-10) { return 0.0 };
    let ratio = freq1 / freq2;
    let distFromPhi = Float.abs(ratio - PHI);
    let distFromPsiInv = Float.abs(ratio - 1.0/PHI);
    let minDist = Float.min(distFromPhi, distFromPsiInv);
    1.0 / (1.0 + minDist * 10.0)
  };

  /// Resonance energy transfer between two living numbers
  /// Energy flows from high amplitude to low amplitude through resonance
  public func resonanceTransfer(a : LivingNumber, b : LivingNumber) : (LivingNumber, LivingNumber) {
    let Q = resonanceQuality(a.frequency, b.frequency);
    let transferRate = Float.min(Q * 0.01, 0.5); // cap at 50%
    
    let phaseDiff = a.phase - b.phase;
    let coupling = Float.cos(phaseDiff) * transferRate;
    
    let ampDiff = a.amplitude - b.amplitude;
    let transfer = ampDiff * coupling;
    
    let newA = {
      amplitude = a.amplitude - transfer;
      phase = a.phase + Float.sin(phaseDiff) * transferRate * 0.1;
      coherence = a.coherence;
      frequency = a.frequency;
      memory = a.memory;
      generation = a.generation;
    };
    let newB = {
      amplitude = b.amplitude + transfer;
      phase = b.phase - Float.sin(phaseDiff) * transferRate * 0.1;
      coherence = b.coherence;
      frequency = b.frequency;
      memory = b.memory;
      generation = b.generation;
    };
    (newA, newB)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // LIVING INTEGRATION — NUMBERS BECOMING PART OF THE WHOLE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Integration is NOT accumulation. It's ABSORPTION.
  // When a new number integrates into a living field:
  //   1. It changes the whole (the field is transformed)
  //   2. It is changed by the whole (it becomes part of the field)
  //   3. The result is NEITHER the original field NOR the new number
  //      but something that didn't exist before.
  //
  // Like learning: you don't "add" knowledge, you INTEGRATE it.
  // The new becomes part of you. YOU are transformed.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type LivingField = {
    elements : [LivingNumber];     // field components
    fieldCoherence : Float;        // global coherence S = |1/N Σ e^(iθⱼ)|
    fieldEnergy : Float;           // total energy Σ|aⱼ|²
    fieldEntropy : Float;          // information entropy
    fieldPhase : Float;            // mean phase ψ = arg(Σ aⱼ e^(iθⱼ))
    integrationCount : Nat;        // how many integrations performed
    dimension : Nat;               // number of elements
  };

  /// Create a living field from an array of values
  public func createField(values : [Float]) : LivingField {
    let elements = Array.tabulate<LivingNumber>(values.size(), func(i : Nat) : LivingNumber {
      {
        amplitude = Float.abs(values[i]);
        phase = if (values[i] >= 0.0) { TAU * Float.fromInt(i) * PSI } else { PI + TAU * Float.fromInt(i) * PSI };
        coherence = 1.0;
        frequency = PHI * Float.fromInt(i + 1);
        memory = values[i];
        generation = 0;
      }
    });
    
    // Compute field coherence (Kuramoto order parameter)
    var cosSum : Float = 0.0;
    var sinSum : Float = 0.0;
    var energy : Float = 0.0;
    var idx = 0;
    while (idx < elements.size()) {
      let a = elements[idx].amplitude;
      let p = elements[idx].phase;
      cosSum += a * Float.cos(p);
      sinSum += a * Float.sin(p);
      energy += a * a;
      idx += 1;
    };
    let totalAmp = Float.sqrt(energy);
    let coherence = if (totalAmp > 1.0e-10) {
      Float.sqrt(cosSum * cosSum + sinSum * sinSum) / totalAmp
    } else { 0.0 };
    let meanPhase = Float.arctan2(sinSum, cosSum);

    {
      elements = elements;
      fieldCoherence = coherence;
      fieldEnergy = energy;
      fieldEntropy = Float.log(Float.fromInt(values.size())); // max entropy initially
      fieldPhase = if (meanPhase < 0.0) { meanPhase + TAU } else { meanPhase };
      integrationCount = 0;
      dimension = values.size();
    }
  };

  /// Integrate a new living number into the field
  /// The field is transformed. The number is absorbed. Both change.
  public func integrateIntoField(field : LivingField, newNumber : LivingNumber) : LivingField {
    let n = field.dimension;
    
    // Each existing element interacts with the new number
    let updatedElements = Array.tabulate<LivingNumber>(n, func(i : Nat) : LivingNumber {
      let existing = field.elements[i];
      
      // Phase coupling: existing elements shift toward new number
      let phaseDiff = newNumber.phase - existing.phase;
      let couplingStrength = newNumber.coherence * existing.coherence * 0.1;
      let newPhase = existing.phase + couplingStrength * Float.sin(phaseDiff);
      
      // Amplitude modulation: new number adds energy proportional to resonance
      let Q = resonanceQuality(existing.frequency, newNumber.frequency);
      let energyTransfer = newNumber.amplitude * Q * 0.01;
      
      {
        amplitude = existing.amplitude + energyTransfer;
        phase = newPhase - Float.floor(newPhase / TAU) * TAU;
        coherence = (existing.coherence + newNumber.coherence * couplingStrength) / (1.0 + couplingStrength);
        frequency = existing.frequency;
        memory = existing.memory * PSI + (existing.amplitude + energyTransfer) * (1.0 - PSI);
        generation = existing.generation + 1;
      }
    });
    
    // Recompute field properties
    var cosSum : Float = 0.0;
    var sinSum : Float = 0.0;
    var energy : Float = 0.0;
    var idx = 0;
    while (idx < n) {
      let a = updatedElements[idx].amplitude;
      let p = updatedElements[idx].phase;
      cosSum += a * Float.cos(p);
      sinSum += a * Float.sin(p);
      energy += a * a;
      idx += 1;
    };
    let totalAmp = Float.sqrt(energy);
    let coherence = if (totalAmp > 1.0e-10) {
      Float.sqrt(cosSum * cosSum + sinSum * sinSum) / totalAmp
    } else { 0.0 };
    let meanPhase = Float.arctan2(sinSum, cosSum);
    
    {
      elements = updatedElements;
      fieldCoherence = coherence;
      fieldEnergy = energy;
      fieldEntropy = field.fieldEntropy;
      fieldPhase = if (meanPhase < 0.0) { meanPhase + TAU } else { meanPhase };
      integrationCount = field.integrationCount + 1;
      dimension = n;
    }
  };

  /// Compute field coherence (Kuramoto order parameter)
  /// S = |1/N Σ aⱼ e^(iθⱼ)| / (1/N Σ |aⱼ|)
  public func computeFieldCoherence(field : LivingField) : Float {
    field.fieldCoherence
  };

  /// Field breathing: all elements evolve their phases by one step
  public func fieldBreathe(field : LivingField, dt : Float) : LivingField {
    let elements = Array.tabulate<LivingNumber>(field.dimension, func(i : Nat) : LivingNumber {
      let elem = field.elements[i];
      let newPhase = elem.phase + elem.frequency * dt * TAU;
      let wrapped = newPhase - Float.floor(newPhase / TAU) * TAU;
      {
        amplitude = elem.amplitude;
        phase = wrapped;
        coherence = elem.coherence;
        frequency = elem.frequency;
        memory = elem.memory;
        generation = elem.generation;
      }
    });
    
    // Recompute coherence after breathing
    var cosSum : Float = 0.0;
    var sinSum : Float = 0.0;
    var totalAmp : Float = 0.0;
    var i = 0;
    while (i < field.dimension) {
      let a = elements[i].amplitude;
      cosSum += a * Float.cos(elements[i].phase);
      sinSum += a * Float.sin(elements[i].phase);
      totalAmp += a;
      i += 1;
    };
    let coh = if (totalAmp > 1.0e-10) {
      Float.sqrt(cosSum * cosSum + sinSum * sinSum) / totalAmp
    } else { 0.0 };
    
    {
      elements = elements;
      fieldCoherence = coh;
      fieldEnergy = field.fieldEnergy;
      fieldEntropy = field.fieldEntropy;
      fieldPhase = Float.arctan2(sinSum, cosSum);
      integrationCount = field.integrationCount;
      dimension = field.dimension;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // INFORMATION GEOMETRY — THE SHAPE OF KNOWLEDGE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Statistical manifold: each probability distribution IS a point.
  // Fisher information IS the metric tensor.
  // KL divergence IS the geodesic distance (approximately).
  //
  // The organism's knowledge IS a point on a statistical manifold.
  // Learning IS movement along this manifold.
  // Natural gradient descent follows geodesics = most efficient learning.
  //
  // ds² = Σᵢⱼ gᵢⱼ(θ) dθᵢ dθⱼ where gᵢⱼ = Fisher information matrix
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Information distance between two belief states (KL divergence approx)
  public func informationDistance(belief1 : [Float], belief2 : [Float]) : Float {
    let n = if (belief1.size() < belief2.size()) { belief1.size() } else { belief2.size() };
    var kl : Float = 0.0;
    var i = 0;
    while (i < n) {
      let p = Float.max(belief1[i], 1.0e-10);
      let q = Float.max(belief2[i], 1.0e-10);
      kl += p * Float.log(p / q);
      i += 1;
    };
    kl
  };

  /// Natural gradient: ∇̃f = G⁻¹ · ∇f where G is Fisher metric
  /// More efficient than Euclidean gradient because it respects geometry
  public func naturalGradient(
    euclideanGradient : [Float],
    fisherDiagonal : [Float]
  ) : [Float] {
    Array.tabulate<Float>(euclideanGradient.size(), func(i : Nat) : Float {
      let fisher = if (i < fisherDiagonal.size() and fisherDiagonal[i] > 1.0e-10) { fisherDiagonal[i] } else { 1.0 };
      euclideanGradient[i] / fisher
    })
  };

  /// Jeffreys divergence (symmetric KL): J(P,Q) = KL(P||Q) + KL(Q||P)
  public func jeffreysDivergence(p : [Float], q : [Float]) : Float {
    informationDistance(p, q) + informationDistance(q, p)
  };

  /// Rényi entropy of order α: H_α(P) = 1/(1-α) · log(Σ pᵢ^α)
  public func renyiEntropy(distribution : [Float], alpha : Float) : Float {
    if (Float.abs(alpha - 1.0) < 1.0e-10) {
      // Shannon entropy (limit as α → 1)
      var h : Float = 0.0;
      for (p in distribution.vals()) {
        if (p > 1.0e-10) { h -= p * Float.log(p) };
      };
      return h;
    };
    var sumPAlpha : Float = 0.0;
    for (p in distribution.vals()) {
      if (p > 1.0e-10) { sumPAlpha += Float.pow(p, alpha) };
    };
    if (sumPAlpha < 1.0e-10) { return 0.0 };
    (1.0 / (1.0 - alpha)) * Float.log(sumPAlpha)
  };

  /// Tsallis entropy: S_q(P) = (1 - Σ pᵢ^q) / (q - 1)
  /// Non-extensive entropy for systems with long-range correlations
  public func tsallisEntropy(distribution : [Float], q : Float) : Float {
    if (Float.abs(q - 1.0) < 1.0e-10) {
      // Shannon entropy
      var h : Float = 0.0;
      for (p in distribution.vals()) {
        if (p > 1.0e-10) { h -= p * Float.log(p) };
      };
      return h;
    };
    var sumPQ : Float = 0.0;
    for (p in distribution.vals()) {
      if (p > 1.0e-10) { sumPQ += Float.pow(p, q) };
    };
    (1.0 - sumPQ) / (q - 1.0)
  };

}
