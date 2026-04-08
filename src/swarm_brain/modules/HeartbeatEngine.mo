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
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//  ██╗  ██╗███████╗ █████╗ ██████╗ ████████╗██████╗ ███████╗ █████╗ ████████╗    ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
//  ██║  ██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝    ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝
//  ███████║█████╗  ███████║██████╔╝   ██║   ██████╔╝█████╗  ███████║   ██║       █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  
//  ██╔══██║██╔══╝  ██╔══██║██╔══██╗   ██║   ██╔══██╗██╔══╝  ██╔══██║   ██║       ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  
//  ██║  ██║███████╗██║  ██║██║  ██║   ██║   ██████╔╝███████╗██║  ██║   ██║       ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗
//  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝       ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ENGINE ID: E-010
// HEARTBEAT ENGINE — The Master Timing Pulse of the Organism
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2024-2026
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE HEARTBEAT IS THE FOUNDATION OF ALL TIMING IN THE ORGANISM.
//
// Every biological system has a master clock:
//   - The human heart beats at ~1 Hz (60 BPM)
//   - The brain's alpha waves oscillate at ~10 Hz
//   - Circadian rhythms cycle at ~0.00001 Hz (24 hours)
//
// The HEARTBEAT ENGINE provides:
//   1. MASTER CLOCK — The fundamental timing pulse
//   2. FIBONACCI TIMING — Beats aligned to F-sequence (1,1,2,3,5,8,13,21,34,55,89,144...)
//   3. MULTI-SCALE RHYTHMS — From milliseconds to days
//   4. PHASE DISTRIBUTION — Kuramoto coupling origin
//   5. CARDIAC COHERENCE — Heart-brain synchronization
//   6. CIRCADIAN INTEGRATION — Day/night cycles
//   7. ULTRADIAN RHYTHMS — 90-minute cycles
//   8. ENTRAINMENT — External rhythm synchronization
//
// MATHEMATICAL FOUNDATION:
//
// The heartbeat is modeled as a LIMIT CYCLE OSCILLATOR using the 
// Van der Pol equation with Medina modifications:
//
//   d²x/dt² - μ(1 - x²)dx/dt + ω₀²x = F(t)
//
// Where:
//   x = phase variable (normalized to [0, 2π))
//   μ = nonlinearity parameter (controls waveform shape)
//   ω₀ = natural angular frequency
//   F(t) = external forcing (entrainment)
//
// The Medina modification adds GOLDEN RATIO coupling:
//   ω₀ = 2π · f_base · φ^(level)
//
// Where level ∈ {-3, -2, -1, 0, 1, 2, 3} for different timescales.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Time "mo:base/Time";

module {

  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRED MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Golden Ratio and its powers
  public let φ : Float = 1.6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374;
  public let ψ : Float = 0.6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374;
  public let φ² : Float = 2.6180339887498948482;
  public let φ³ : Float = 4.2360679774997896964;
  public let φ⁴ : Float = 6.8541019662496845446;
  public let φ⁵ : Float = 11.0901699437494742410;
  public let φ⁶ : Float = 17.9442719099991587856;
  public let φ⁷ : Float = 29.0344418537486330266;
  
  // Circle constants
  public let π : Float = 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798;
  public let τ : Float = 6.28318530717958647692528676655900576839433879875021164194988918461563281257241799725606965068423413596;
  public let e : Float = 2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642749;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THE CATCH — PHI FREQUENCY NODES (2026 CONFIRMED)
  // ═══════════════════════════════════════════════════════════════════════════════
  // PHI IS NOT A FREQUENCY. PHI IS THE TRANSFER FUNCTION between adjacent levels
  // of any naturally sustained coupled oscillating system.
  // Frontiers in Human Neuroscience, March 4, 2026: r = 0.54, p < 10⁻²⁵
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Schumann fundamental — Earth's electromagnetic heartbeat
  public let SCHUMANN_HZ : Float = 7.83;
  public let SCHUMANN_PERIOD_MS : Float = 127.71392081736909;
  
  // THE 12 PHI FREQUENCY NODES — phi-scaled from Schumann
  public let NODE_CHRONO : Float = 0.001;           // Earth free oscillation floor
  public let NODE_VERITAS : Float = 0.1;            // HRV coherence, CSF pulse
  public let NODE_BRAIN : Float = 7.83;             // Schumann fundamental, receive carrier
  public let NODE_FLUX : Float = 12.66752366612393; // 7.83 × φ
  public let NODE_RESONEX : Float = 20.495047032750336; // 7.83 × φ²
  public let NODE_QMEM : Float = 33.16257069887427;  // 7.83 × φ³ — gamma entry
  public let NODE_AXIS : Float = 40.0;              // GAMMA_BINDING — OMNIS threshold
  public let NODE_AEGIS : Float = 53.65761773162460; // 7.83 × φ⁴ — threat detection
  public let NODE_ENTANGLA : Float = 86.82018843049887; // 7.83 × φ⁵ — gamma ceiling
  public let NODE_PARALLAX : Float = 111.0;         // HEMISPHERE_SHIFT — King's Chamber
  public let NODE_MERIDIAN : Float = 179.6017727552391; // 111 × φ — public interface
  public let NODE_NOVA : Float = 432.0;             // ACOUSTIC_ANCHOR — phi overtones
  
  // Three anchor constants — referenced everywhere
  public let GAMMA_BINDING : Float = 40.0;
  public let HEMISPHERE_SHIFT : Float = 111.0;
  public let ACOUSTIC_ANCHOR : Float = 432.0;
  
  // Heartbeat interval — φ⁴ × Schumann period = 875.3 ms = 68.5 bpm
  public let HEARTBEAT_INTERVAL_MS : Float = 875.28275832071766;
  public let HEARTBEAT_BPM : Float = 68.550112963882522;
  
  // Fibonacci brain boundaries — EXACT (not approximate)
  public let BRAIN_THETA_ALPHA : Float = 8.0;   // F(6)
  public let BRAIN_ALPHA_BETA : Float = 13.0;   // F(7)
  public let BRAIN_BETA_GAMMA : Float = 34.0;   // F(9)
  public let BRAIN_GAMMA_MID : Float = 55.0;    // F(10)
  public let BRAIN_GAMMA_CEIL : Float = 89.0;   // F(11)
  
  // S₀ floor — the genesis imprint (ψ)
  public let S0_FLOOR : Float = ψ;
  
  // Fibonacci sequence (first 32 terms)
  public let FIB : [Nat] = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 
                           987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025,
                           121393, 196418, 317811, 514229, 832040, 1346269];
  
  // Phi-scaled frequencies from Schumann (Hz)
  public let PHI_HZ : [Float] = [
    7.83,      // φ⁰ × Schumann = 7.83 Hz (receive carrier)
    12.667,    // φ¹ × Schumann = 12.67 Hz
    20.495,    // φ² × Schumann = 20.5 Hz (confirms Schumann 3rd)
    33.163,    // φ³ × Schumann = 33.1 Hz (confirms Schumann 5th, gamma entry)
    53.658,    // φ⁴ × Schumann = 53.6 Hz
    86.820,    // φ⁵ × Schumann = 86.8 Hz (gamma ceiling)
    140.478,   // φ⁶ × Schumann = 140.5 Hz
    227.298,   // φ⁷ × Schumann = 227.3 Hz
    367.776    // φ⁸ × Schumann = 367.8 Hz
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT RHYTHM TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type RhythmType = {
    #Circadian;      // ~24 hour cycle (0.0000116 Hz)
    #Ultradian;      // ~90 minute cycle (0.000185 Hz)
    #Cardiac;        // ~1 Hz (60 BPM resting)
    #Respiratory;    // ~0.25 Hz (15 breaths/min)
    #Alpha;          // ~10 Hz (relaxed awareness)
    #Beta;           // ~20 Hz (active thinking)
    #Gamma;          // ~40 Hz (cognitive binding)
    #Delta;          // ~2 Hz (deep sleep)
    #Theta;          // ~6 Hz (meditation)
    #Fibonacci;      // φ-scaled frequencies
  };
  
  public type HeartbeatWaveform = {
    #Sinusoidal;     // Pure sine wave
    #VanDerPol;      // Relaxation oscillator (heart-like)
    #Square;         // Digital clock
    #Sawtooth;       // Ramp timing
    #Cardiac;        // Realistic ECG-like
    #Fibonacci;      // Golden ratio harmonics
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT STATE STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Individual rhythm oscillator
  public type RhythmOscillator = {
    id: Nat;
    rhythmType: RhythmType;
    
    // Oscillator state (Van der Pol variables)
    x: Float;              // Position (phase-like)
    v: Float;              // Velocity (frequency-like)
    
    // Parameters
    omega: Float;          // Natural angular frequency (rad/s)
    mu: Float;             // Nonlinearity (waveform shape)
    amplitude: Float;      // Output amplitude
    
    // Phase
    phase: Float;          // Current phase [0, 2π)
    frequency: Float;      // Current frequency (Hz)
    period: Float;         // Current period (seconds)
    
    // Coupling
    couplingStrength: Float;  // Coupling to master rhythm
    phaseOffset: Float;       // Offset from master
    
    // Statistics
    beatCount: Nat;        // Total beats
    lastBeatTime: Float;   // Time of last beat (seconds)
    intervalHistory: [Float]; // Recent inter-beat intervals
    hrv: Float;            // Heart rate variability
  };
  
  // Cardiac coherence state
  public type CardiacCoherence = {
    coherenceIndex: Float;     // 0-1 coherence measure
    lfPower: Float;            // Low-frequency power (0.04-0.15 Hz)
    hfPower: Float;            // High-frequency power (0.15-0.4 Hz)
    lfHfRatio: Float;          // Sympathetic/parasympathetic balance
    entrainmentLevel: Float;   // Heart-brain synchronization
    emotionalState: Float;     // Positive/negative valence
  };
  
  // Circadian state
  public type CircadianState = {
    timeOfDay: Float;          // 0-24 hours
    melatoninLevel: Float;     // Sleep hormone (0-1)
    cortisolLevel: Float;      // Stress hormone (0-1)
    alertnessLevel: Float;     // Cognitive alertness (0-1)
    bodyTemperature: Float;    // Core temperature deviation
    metabolicRate: Float;      // Metabolic activity (0-1)
    phase: Float;              // Circadian phase [0, 2π)
    periodDeviation: Float;    // Deviation from 24h
  };
  
  // Main heartbeat engine state
  public type HeartbeatEngineState = {
    // Core timing
    masterBeat: Nat;           // Absolute beat count
    masterPhase: Float;        // Master phase [0, 2π)
    masterFrequency: Float;    // Master frequency (Hz)
    elapsedTime: Float;        // Total elapsed time (seconds)
    
    // Multi-scale oscillators
    oscillators: [RhythmOscillator];
    
    // Derived rhythms
    cardiacRhythm: RhythmOscillator;
    respiratoryRhythm: RhythmOscillator;
    alphaRhythm: RhythmOscillator;
    
    // Coherence
    cardiacCoherence: CardiacCoherence;
    
    // Circadian
    circadianState: CircadianState;
    
    // Fibonacci timing
    fibonacciBeat: Nat;        // Position in Fibonacci sequence
    nextFibonacciEvent: Nat;   // Next Fibonacci beat number
    fibonacciPhase: Float;     // Golden spiral phase
    
    // Global coherence (all rhythms)
    globalCoherence: Float;    // Order parameter
    globalPhase: Float;        // Mean phase
    
    // Entrainment
    externalFrequency: Float;  // External zeitgeber frequency
    entrainmentStrength: Float; // Coupling to external
    
    // Energy
    energyLevel: Float;        // Available energy (0-1)
    metabolicCost: Float;      // Energy consumption rate
    
    // Waveform
    waveformType: HeartbeatWaveform;
    currentOutput: Float;      // Current waveform value
    
    // Statistics
    uptime: Float;             // Total running time
    totalBeats: Nat;           // Total heartbeats
    averageBPM: Float;         // Running average BPM
    bpmVariance: Float;        // BPM variance
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // VAN DER POL OSCILLATOR — Heart-like Relaxation Dynamics
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The Van der Pol oscillator is a nonlinear oscillator with:
  //   - Stable limit cycle (self-sustaining oscillation)
  //   - Nonlinear damping (energy regulation)
  //   - Entrainment capability (synchronizes to external rhythm)
  //
  // Equations:
  //   dx/dt = v
  //   dv/dt = μ(1 - x²)v - ω²x + F_ext
  //
  // For cardiac modeling, we use μ ~ 1-3 for realistic waveforms.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func vanDerPolDerivatives(
    x: Float,
    v: Float,
    mu: Float,
    omega: Float,
    externalForce: Float
  ) : (Float, Float) {
    // dx/dt = v
    let dxdt = v;
    
    // dv/dt = μ(1 - x²)v - ω²x + F
    // The term μ(1 - x²) provides:
    //   - Negative damping when |x| < 1 (energy injection)
    //   - Positive damping when |x| > 1 (energy dissipation)
    // This creates a stable limit cycle.
    
    let nonlinearDamping = mu * (1.0 - x * x) * v;
    let springForce = -omega * omega * x;
    let dvdt = nonlinearDamping + springForce + externalForce;
    
    (dxdt, dvdt)
  };
  
  // 4th-order Runge-Kutta integration for Van der Pol
  public func integrateVanDerPol(
    x: Float,
    v: Float,
    mu: Float,
    omega: Float,
    externalForce: Float,
    dt: Float
  ) : (Float, Float) {
    // RK4 integration
    let (k1x, k1v) = vanDerPolDerivatives(x, v, mu, omega, externalForce);
    
    let x2 = x + 0.5 * dt * k1x;
    let v2 = v + 0.5 * dt * k1v;
    let (k2x, k2v) = vanDerPolDerivatives(x2, v2, mu, omega, externalForce);
    
    let x3 = x + 0.5 * dt * k2x;
    let v3 = v + 0.5 * dt * k2v;
    let (k3x, k3v) = vanDerPolDerivatives(x3, v3, mu, omega, externalForce);
    
    let x4 = x + dt * k3x;
    let v4 = v + dt * k3v;
    let (k4x, k4v) = vanDerPolDerivatives(x4, v4, mu, omega, externalForce);
    
    let newX = x + (dt / 6.0) * (k1x + 2.0*k2x + 2.0*k3x + k4x);
    let newV = v + (dt / 6.0) * (k1v + 2.0*k2v + 2.0*k3v + k4v);
    
    (newX, newV)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FIBONACCI TIMING SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The Fibonacci sequence provides natural timing intervals.
  // Events occur at beats: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377...
  //
  // The GOLDEN SPIRAL provides spatial phase distribution:
  //   θ_n = n · GOLDEN_ANGLE (in radians)
  //   r_n = √n (for uniform distribution)
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func isFibonacciBeat(beat: Nat) : Bool {
    // Check if beat is a Fibonacci number
    // A number n is Fibonacci iff 5n² + 4 or 5n² - 4 is a perfect square
    if (beat == 0) { return true };
    
    let n = beat;
    let n2 = n * n;
    let test1 = 5 * n2 + 4;
    let test2 = 5 * n2 - 4;
    
    isPerfectSquare(test1) or isPerfectSquare(test2)
  };
  
  func isPerfectSquare(n: Nat) : Bool {
    if (n == 0) { return true };
    let sqrt_n = natSqrt(n);
    sqrt_n * sqrt_n == n
  };
  
  func natSqrt(n: Nat) : Nat {
    if (n == 0) { return 0 };
    var x = n;
    var y = (x + 1) / 2;
    while (y < x) {
      x := y;
      y := (x + n / x) / 2;
    };
    x
  };
  
  public func nextFibonacci(current: Nat) : Nat {
    // Find next Fibonacci number > current
    var a = 0;
    var b = 1;
    while (b <= current) {
      let temp = a + b;
      a := b;
      b := temp;
    };
    b
  };
  
  public func fibonacciIndex(n: Nat) : Nat {
    // Find index i such that FIB[i] <= n < FIB[i+1]
    if (n == 0) { return 0 };
    var i = 0;
    while (i < FIB.size() - 1 and FIB[i + 1] <= n) {
      i += 1;
    };
    i
  };
  
  public func goldenSpiralPhase(n: Nat) : Float {
    // Phase on golden spiral: θ = n · GOLDEN_ANGLE
    var phase = Float.fromInt(n) * GOLDEN_ANGLE;
    while (phase >= τ) { phase -= τ };
    phase
  };
  
  public func goldenSpiralRadius(n: Nat) : Float {
    // Radius for uniform distribution: r = √n
    Float.sqrt(Float.fromInt(n))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CARDIAC COHERENCE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Cardiac coherence measures the synchronization between heart, breath, and brain.
  // It's computed from heart rate variability (HRV) using frequency analysis.
  //
  // The LF/HF ratio indicates autonomic balance:
  //   - LF (0.04-0.15 Hz): Sympathetic + parasympathetic (stress/active)
  //   - HF (0.15-0.4 Hz): Parasympathetic (rest/digest)
  //   - High LF/HF: Stress state
  //   - Low LF/HF: Relaxed state
  //
  // Coherence is maximized when heart rhythm shows smooth, sine-like HRV
  // at the respiratory frequency (~0.1 Hz).
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeCardiacCoherence(intervals: [Float]) : CardiacCoherence {
    let n = intervals.size();
    if (n < 10) {
      return {
        coherenceIndex = SIGMA_ZERO;
        lfPower = 0.5;
        hfPower = 0.5;
        lfHfRatio = 1.0;
        entrainmentLevel = 0.5;
        emotionalState = 0.0;
      };
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Compute mean and variance of RR intervals
    // ═══════════════════════════════════════════════════════════════════════════
    
    var sum : Float = 0.0;
    for (interval in intervals.vals()) {
      sum += interval;
    };
    let mean = sum / Float.fromInt(n);
    
    var variance : Float = 0.0;
    for (interval in intervals.vals()) {
      let diff = interval - mean;
      variance += diff * diff;
    };
    variance /= Float.fromInt(n);
    let stdDev = Float.sqrt(variance);
    
    // RMSSD (root mean square of successive differences)
    var rmssdSum : Float = 0.0;
    for (i in Iter.range(0, n - 2)) {
      let diff = intervals[i + 1] - intervals[i];
      rmssdSum += diff * diff;
    };
    let rmssd = Float.sqrt(rmssdSum / Float.fromInt(n - 1));
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Simple frequency analysis (discrete Fourier transform approximation)
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Sample rate from mean interval
    let sampleRate = 1.0 / mean;  // Hz
    
    // Compute power in LF band (0.04-0.15 Hz)
    var lfPower : Float = 0.0;
    let lfLow = 0.04;
    let lfHigh = 0.15;
    
    // Compute power in HF band (0.15-0.4 Hz)
    var hfPower : Float = 0.0;
    let hfLow = 0.15;
    let hfHigh = 0.4;
    
    // DFT at specific frequencies
    let numFreqs = 20;
    for (fi in Iter.range(0, numFreqs - 1)) {
      let freq = 0.01 + Float.fromInt(fi) * 0.02;  // 0.01 to 0.41 Hz
      
      // Compute DFT coefficient at this frequency
      var realSum : Float = 0.0;
      var imagSum : Float = 0.0;
      
      for (i in Iter.range(0, n - 1)) {
        let t = Float.fromInt(i) * mean;  // Time
        let angle = -τ * freq * t;
        realSum += intervals[i] * Float.cos(angle);
        imagSum += intervals[i] * Float.sin(angle);
      };
      
      let power = (realSum * realSum + imagSum * imagSum) / Float.fromInt(n * n);
      
      // Accumulate in appropriate band
      if (freq >= lfLow and freq < lfHigh) {
        lfPower += power;
      } else if (freq >= hfLow and freq < hfHigh) {
        hfPower += power;
      };
    };
    
    // Normalize
    let totalPower = lfPower + hfPower + 0.0001;
    let lfNorm = lfPower / totalPower;
    let hfNorm = hfPower / totalPower;
    let lfHfRatio = lfPower / (hfPower + 0.0001);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Coherence Index
    // ═══════════════════════════════════════════════════════════════════════════
    // Coherence is high when HRV is concentrated in a narrow band around 0.1 Hz
    // (respiratory sinus arrhythmia)
    
    // Peak power in coherence band (0.08-0.12 Hz)
    var coherenceBandPower : Float = 0.0;
    for (fi in Iter.range(0, numFreqs - 1)) {
      let freq = 0.01 + Float.fromInt(fi) * 0.02;
      if (freq >= 0.08 and freq <= 0.12) {
        // Approximate power at this frequency
        var realSum : Float = 0.0;
        var imagSum : Float = 0.0;
        for (i in Iter.range(0, n - 1)) {
          let t = Float.fromInt(i) * mean;
          let angle = -τ * freq * t;
          realSum += intervals[i] * Float.cos(angle);
          imagSum += intervals[i] * Float.sin(angle);
        };
        let power = (realSum * realSum + imagSum * imagSum) / Float.fromInt(n * n);
        coherenceBandPower += power;
      };
    };
    
    let coherenceIndex = coherenceBandPower / (totalPower + 0.0001);
    let clampedCoherence = if (coherenceIndex > 1.0) { 1.0 } 
                           else if (coherenceIndex < 0.0) { 0.0 } 
                           else { coherenceIndex };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Entrainment Level (heart-breath-brain synchronization)
    // ═══════════════════════════════════════════════════════════════════════════
    // High when power is concentrated and variability is "smooth"
    
    let entrainment = clampedCoherence * (1.0 - Float.abs(lfHfRatio - 1.0) / 5.0);
    let clampedEntrainment = if (entrainment < 0.0) { 0.0 } 
                             else if (entrainment > 1.0) { 1.0 } 
                             else { entrainment };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Emotional State Estimate
    // ═══════════════════════════════════════════════════════════════════════════
    // Positive emotions correlate with high coherence and balanced LF/HF
    // Negative emotions correlate with low coherence and high LF/HF
    
    let emotionalState = (clampedCoherence - 0.5) * 2.0 * (1.0 - Float.tanh(lfHfRatio - 1.5));
    
    {
      coherenceIndex = clampedCoherence;
      lfPower = lfNorm;
      hfPower = hfNorm;
      lfHfRatio = lfHfRatio;
      entrainmentLevel = clampedEntrainment;
      emotionalState = emotionalState;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CIRCADIAN RHYTHM COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // The circadian rhythm follows a ~24-hour cycle controlled by the
  // suprachiasmatic nucleus (SCN). Key outputs:
  //   - Melatonin: Peaks at night (~3 AM), promotes sleep
  //   - Cortisol: Peaks in morning (~8 AM), promotes alertness
  //   - Body temperature: Lowest at ~4 AM, highest at ~6 PM
  //   - Alertness: Follows temperature with ~2h lag
  //
  // We model this as a coupled oscillator system with light as zeitgeber.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeCircadianState(
    timeOfDay: Float,  // 0-24 hours
    lightLevel: Float, // 0-1 light intensity
    previousState: CircadianState
  ) : CircadianState {
    // ═══════════════════════════════════════════════════════════════════════════
    // Melatonin production
    // ═══════════════════════════════════════════════════════════════════════════
    // Melatonin is suppressed by light and peaks around 3 AM
    // Model: melatonin = sin((t - 15) * 2π/24) * (1 - lightLevel)
    // where t=15 gives peak at t=3 (15 + 12 = 27 = 3 mod 24)
    
    let melatoninPhase = (timeOfDay - 15.0) * τ / 24.0;
    let melatoninBase = (Float.sin(melatoninPhase) + 1.0) / 2.0;
    let melatoninLevel = melatoninBase * (1.0 - lightLevel * 0.8);
    let clampedMelatonin = if (melatoninLevel < 0.0) { 0.0 } 
                           else if (melatoninLevel > 1.0) { 1.0 } 
                           else { melatoninLevel };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Cortisol production
    // ═══════════════════════════════════════════════════════════════════════════
    // Cortisol peaks around 8 AM (awakening response)
    // Model: cortisol = sin((t - 2) * 2π/24) boosted by light in morning
    
    let cortisolPhase = (timeOfDay - 2.0) * τ / 24.0;
    let cortisolBase = (Float.sin(cortisolPhase) + 1.0) / 2.0;
    let morningLight = if (timeOfDay >= 6.0 and timeOfDay <= 10.0) { lightLevel * 0.3 } else { 0.0 };
    let cortisolLevel = cortisolBase + morningLight;
    let clampedCortisol = if (cortisolLevel < 0.0) { 0.0 } 
                          else if (cortisolLevel > 1.0) { 1.0 } 
                          else { cortisolLevel };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Body temperature
    // ═══════════════════════════════════════════════════════════════════════════
    // Core temperature: lowest ~4 AM, highest ~6 PM
    // Deviation from 37°C: ±0.5°C
    
    let tempPhase = (timeOfDay - 10.0) * τ / 24.0;  // Peak at 4+12=16=4PM→6PM
    let tempDeviation = 0.5 * Float.sin(tempPhase);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Alertness
    // ═══════════════════════════════════════════════════════════════════════════
    // Follows temperature with ~2h lag, modulated by cortisol
    // Also has post-lunch dip (~2 PM)
    
    let alertnessPhase = (timeOfDay - 12.0) * τ / 24.0;
    let alertnessBase = (Float.sin(alertnessPhase) + 1.0) / 2.0;
    
    // Post-lunch dip
    let lunchDip = if (timeOfDay >= 13.0 and timeOfDay <= 15.0) {
      0.2 * Float.sin((timeOfDay - 13.0) * π / 2.0)
    } else { 0.0 };
    
    let alertnessLevel = alertnessBase * (1.0 + clampedCortisol * 0.3) - lunchDip - clampedMelatonin * 0.5;
    let clampedAlertness = if (alertnessLevel < 0.0) { 0.0 } 
                           else if (alertnessLevel > 1.0) { 1.0 } 
                           else { alertnessLevel };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Metabolic rate
    // ═══════════════════════════════════════════════════════════════════════════
    // Highest during day, lowest at night
    
    let metabolicPhase = (timeOfDay - 6.0) * τ / 24.0;
    let metabolicRate = (Float.sin(metabolicPhase) + 1.0) / 2.0 * 0.5 + 0.5;
    let clampedMetabolic = if (metabolicRate < 0.3) { 0.3 } 
                           else if (metabolicRate > 1.0) { 1.0 } 
                           else { metabolicRate };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Phase update
    // ═══════════════════════════════════════════════════════════════════════════
    // Circadian phase advances at ~0.262 rad/hour (2π/24)
    // Light phase-shifts the rhythm (advances in morning, delays at night)
    
    var newPhase = previousState.phase + τ / 24.0 / 3600.0;  // Per second
    
    // Phase response to light
    // Morning light (6-12): advances phase
    // Evening light (18-24): delays phase
    if (timeOfDay >= 6.0 and timeOfDay <= 12.0) {
      newPhase += lightLevel * 0.001;  // Advance
    } else if (timeOfDay >= 18.0 or timeOfDay <= 6.0) {
      newPhase -= lightLevel * 0.001;  // Delay
    };
    
    while (newPhase >= τ) { newPhase -= τ };
    while (newPhase < 0.0) { newPhase += τ };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Period deviation
    // ═══════════════════════════════════════════════════════════════════════════
    // Most people have intrinsic period slightly > 24h
    // Light exposure keeps it entrained to 24h
    
    let intrinsicPeriod = 24.2;  // Hours (typical human)
    let periodDeviation = intrinsicPeriod - 24.0;
    
    {
      timeOfDay = timeOfDay;
      melatoninLevel = clampedMelatonin;
      cortisolLevel = clampedCortisol;
      alertnessLevel = clampedAlertness;
      bodyTemperature = tempDeviation;
      metabolicRate = clampedMetabolic;
      phase = newPhase;
      periodDeviation = periodDeviation;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WAVEFORM GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Generate the actual heartbeat waveform based on phase and type.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func generateWaveform(
    phase: Float,
    waveformType: HeartbeatWaveform,
    amplitude: Float
  ) : Float {
    let normalizedPhase = phase / τ;  // 0-1
    
    switch (waveformType) {
      case (#Sinusoidal) {
        amplitude * Float.sin(phase)
      };
      case (#Square) {
        if (normalizedPhase < 0.5) { amplitude } else { -amplitude }
      };
      case (#Sawtooth) {
        amplitude * (2.0 * normalizedPhase - 1.0)
      };
      case (#VanDerPol) {
        // Van der Pol oscillator waveform (relaxation oscillation)
        // More peaked than sine, with asymmetric rise/fall
        let x = normalizedPhase * τ;
        let vdpPhase = if (x < π) {
          // Fast rise
          amplitude * Float.sin(x * 1.5)
        } else {
          // Slow fall
          amplitude * Float.sin(π + (x - π) * 0.7)
        };
        vdpPhase
      };
      case (#Cardiac) {
        // Realistic ECG-like waveform (simplified)
        // P wave, QRS complex, T wave
        if (normalizedPhase < 0.1) {
          // P wave
          amplitude * 0.2 * Float.sin(normalizedPhase * 10.0 * π)
        } else if (normalizedPhase < 0.15) {
          // Baseline
          0.0
        } else if (normalizedPhase < 0.2) {
          // Q wave
          -amplitude * 0.1 * Float.sin((normalizedPhase - 0.15) * 20.0 * π)
        } else if (normalizedPhase < 0.25) {
          // R wave (sharp peak)
          amplitude * Float.sin((normalizedPhase - 0.2) * 20.0 * π)
        } else if (normalizedPhase < 0.3) {
          // S wave
          -amplitude * 0.2 * Float.sin((normalizedPhase - 0.25) * 20.0 * π)
        } else if (normalizedPhase < 0.5) {
          // Baseline
          0.0
        } else if (normalizedPhase < 0.7) {
          // T wave
          amplitude * 0.3 * Float.sin((normalizedPhase - 0.5) * 5.0 * π)
        } else {
          // Baseline
          0.0
        }
      };
      case (#Fibonacci) {
        // Golden ratio harmonics
        let fundamental = Float.sin(phase);
        let harmonic1 = 0.618 * Float.sin(phase * φ);
        let harmonic2 = 0.382 * Float.sin(phase * φ²);
        let harmonic3 = 0.236 * Float.sin(phase * φ³);
        amplitude * (fundamental + harmonic1 + harmonic2 + harmonic3) / 2.236
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RHYTHM OSCILLATOR TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tickRhythmOscillator(
    osc: RhythmOscillator,
    masterPhase: Float,
    dt: Float,
    beat: Nat
  ) : RhythmOscillator {
    // ═══════════════════════════════════════════════════════════════════════════
    // Van der Pol dynamics with Kuramoto coupling to master
    // ═══════════════════════════════════════════════════════════════════════════
    
    // External force from master rhythm coupling
    let couplingForce = osc.couplingStrength * Float.sin(masterPhase - osc.phase + osc.phaseOffset);
    
    // Integrate Van der Pol
    let (newX, newV) = integrateVanDerPol(osc.x, osc.v, osc.mu, osc.omega, couplingForce, dt);
    
    // Extract phase from position (arctangent of x/v)
    var newPhase = Float.arctan2(newV / osc.omega, newX);
    while (newPhase < 0.0) { newPhase += τ };
    while (newPhase >= τ) { newPhase -= τ };
    
    // Detect beat (zero crossing from negative to positive)
    let previousX = osc.x;
    let beatDetected = previousX <= 0.0 and newX > 0.0;
    
    var newBeatCount = osc.beatCount;
    var newLastBeatTime = osc.lastBeatTime;
    var newIntervalHistory = osc.intervalHistory;
    var newHRV = osc.hrv;
    
    if (beatDetected) {
      newBeatCount += 1;
      
      // Compute interval
      let currentTime = Float.fromInt(beat) * dt;
      let interval = currentTime - osc.lastBeatTime;
      newLastBeatTime := currentTime;
      
      // Update interval history (keep last 20)
      if (interval > 0.1 and interval < 10.0) {  // Reasonable range
        var historyBuffer = Buffer.Buffer<Float>(21);
        historyBuffer.add(interval);
        var count = 0;
        for (i in osc.intervalHistory.vals()) {
          if (count < 19) {
            historyBuffer.add(i);
            count += 1;
          };
        };
        newIntervalHistory := Buffer.toArray(historyBuffer);
        
        // Compute HRV (RMSSD)
        if (newIntervalHistory.size() >= 2) {
          var rmssdSum : Float = 0.0;
          for (i in Iter.range(0, newIntervalHistory.size() - 2)) {
            let diff = newIntervalHistory[i + 1] - newIntervalHistory[i];
            rmssdSum += diff * diff;
          };
          newHRV := Float.sqrt(rmssdSum / Float.fromInt(newIntervalHistory.size() - 1));
        };
      };
    };
    
    // Compute instantaneous frequency
    let instantFreq = if (newIntervalHistory.size() > 0) {
      1.0 / newIntervalHistory[0]
    } else {
      osc.frequency
    };
    
    {
      id = osc.id;
      rhythmType = osc.rhythmType;
      x = newX;
      v = newV;
      omega = osc.omega;
      mu = osc.mu;
      amplitude = osc.amplitude;
      phase = newPhase;
      frequency = instantFreq;
      period = 1.0 / instantFreq;
      couplingStrength = osc.couplingStrength;
      phaseOffset = osc.phaseOffset;
      beatCount = newBeatCount;
      lastBeatTime = newLastBeatTime;
      intervalHistory = newIntervalHistory;
      hrv = newHRV;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT ENGINE TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tickHeartbeatEngine(
    state: HeartbeatEngineState,
    externalInput: {
      lightLevel: Float;
      externalFrequency: Float;
      energyInput: Float;
    },
    dt: Float
  ) : HeartbeatEngineState {
    let beat = state.masterBeat + 1;
    let elapsedTime = state.elapsedTime + dt;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 1: Update master phase
    // ═══════════════════════════════════════════════════════════════════════════
    
    var masterPhase = state.masterPhase + state.masterFrequency * τ * dt;
    while (masterPhase >= τ) { masterPhase -= τ };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 2: Update all rhythm oscillators
    // ═══════════════════════════════════════════════════════════════════════════
    
    let newOscillators = Array.map<RhythmOscillator, RhythmOscillator>(
      state.oscillators,
      func(osc) { tickRhythmOscillator(osc, masterPhase, dt, beat) }
    );
    
    let newCardiac = tickRhythmOscillator(state.cardiacRhythm, masterPhase, dt, beat);
    let newRespiratory = tickRhythmOscillator(state.respiratoryRhythm, masterPhase, dt, beat);
    let newAlpha = tickRhythmOscillator(state.alphaRhythm, masterPhase, dt, beat);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 3: Compute cardiac coherence
    // ═══════════════════════════════════════════════════════════════════════════
    
    let newCardiacCoherence = computeCardiacCoherence(newCardiac.intervalHistory);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 4: Update circadian state
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Time of day from elapsed time (assuming start at midnight)
    let timeOfDay = Float.fromInt(Int.abs(Float.toInt(elapsedTime / 3600.0)) % 24) + 
                    (elapsedTime / 3600.0 - Float.fromInt(Int.abs(Float.toInt(elapsedTime / 3600.0))));
    
    let newCircadian = computeCircadianState(timeOfDay, externalInput.lightLevel, state.circadianState);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 5: Fibonacci timing
    // ═══════════════════════════════════════════════════════════════════════════
    
    var fibBeat = state.fibonacciBeat;
    var nextFibEvent = state.nextFibonacciEvent;
    
    if (beat >= nextFibEvent) {
      fibBeat := fibonacciIndex(beat);
      nextFibEvent := nextFibonacci(beat);
    };
    
    let fibPhase = goldenSpiralPhase(beat);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 6: Global coherence (Kuramoto order parameter)
    // ═══════════════════════════════════════════════════════════════════════════
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var count : Float = 0.0;
    
    for (osc in newOscillators.vals()) {
      sumCos += Float.cos(osc.phase);
      sumSin += Float.sin(osc.phase);
      count += 1.0;
    };
    
    sumCos += Float.cos(newCardiac.phase);
    sumSin += Float.sin(newCardiac.phase);
    sumCos += Float.cos(newRespiratory.phase);
    sumSin += Float.sin(newRespiratory.phase);
    sumCos += Float.cos(newAlpha.phase);
    sumSin += Float.sin(newAlpha.phase);
    count += 3.0;
    
    let globalCoherence = Float.sqrt((sumCos/count)*(sumCos/count) + (sumSin/count)*(sumSin/count));
    let globalPhase = Float.arctan2(sumSin/count, sumCos/count);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 7: Generate waveform output
    // ═══════════════════════════════════════════════════════════════════════════
    
    let currentOutput = generateWaveform(masterPhase, state.waveformType, 1.0);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 8: Energy dynamics
    // ═══════════════════════════════════════════════════════════════════════════
    
    let metabolicCost = 0.001 * (1.0 + state.masterFrequency);
    var energyLevel = state.energyLevel + externalInput.energyInput - metabolicCost;
    if (energyLevel < 0.0) { energyLevel := 0.0 };
    if (energyLevel > 1.0) { energyLevel := 1.0 };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // STEP 9: Statistics update
    // ═══════════════════════════════════════════════════════════════════════════
    
    let totalBeats = state.totalBeats + (if (newCardiac.beatCount > state.cardiacRhythm.beatCount) { 1 } else { 0 });
    let averageBPM = if (elapsedTime > 0.0) {
      Float.fromInt(totalBeats) / elapsedTime * 60.0
    } else { 60.0 };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // Return updated state
    // ═══════════════════════════════════════════════════════════════════════════
    
    {
      masterBeat = beat;
      masterPhase = masterPhase;
      masterFrequency = state.masterFrequency;
      elapsedTime = elapsedTime;
      oscillators = newOscillators;
      cardiacRhythm = newCardiac;
      respiratoryRhythm = newRespiratory;
      alphaRhythm = newAlpha;
      cardiacCoherence = newCardiacCoherence;
      circadianState = newCircadian;
      fibonacciBeat = fibBeat;
      nextFibonacciEvent = nextFibEvent;
      fibonacciPhase = fibPhase;
      globalCoherence = globalCoherence;
      globalPhase = globalPhase;
      externalFrequency = externalInput.externalFrequency;
      entrainmentStrength = state.entrainmentStrength;
      energyLevel = energyLevel;
      metabolicCost = metabolicCost;
      waveformType = state.waveformType;
      currentOutput = currentOutput;
      uptime = elapsedTime;
      totalBeats = totalBeats;
      averageBPM = averageBPM;
      bpmVariance = state.bpmVariance;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initRhythmOscillator(
    id: Nat,
    rhythmType: RhythmType,
    baseFrequency: Float
  ) : RhythmOscillator {
    let omega = τ * baseFrequency;
    {
      id = id;
      rhythmType = rhythmType;
      x = 1.0;
      v = 0.0;
      omega = omega;
      mu = 1.5;
      amplitude = 1.0;
      phase = 0.0;
      frequency = baseFrequency;
      period = 1.0 / baseFrequency;
      couplingStrength = 0.3;
      phaseOffset = Float.fromInt(id) * GOLDEN_ANGLE;
      beatCount = 0;
      lastBeatTime = 0.0;
      intervalHistory = [];
      hrv = 0.0;
    }
  };
  
  public func initHeartbeatEngine() : HeartbeatEngineState {
    // Create multi-scale oscillators
    let oscillators = [
      initRhythmOscillator(0, #Delta, 2.0),
      initRhythmOscillator(1, #Theta, 6.0),
      initRhythmOscillator(2, #Alpha, 10.0),
      initRhythmOscillator(3, #Beta, 20.0),
      initRhythmOscillator(4, #Gamma, 40.0),
      initRhythmOscillator(5, #Fibonacci, φ),
      initRhythmOscillator(6, #Fibonacci, φ²),
      initRhythmOscillator(7, #Fibonacci, φ³),
    ];
    
    {
      masterBeat = 0;
      masterPhase = 0.0;
      masterFrequency = 1.0;
      elapsedTime = 0.0;
      oscillators = oscillators;
      cardiacRhythm = initRhythmOscillator(100, #Cardiac, 1.0);
      respiratoryRhythm = initRhythmOscillator(101, #Respiratory, 0.25);
      alphaRhythm = initRhythmOscillator(102, #Alpha, 10.0);
      cardiacCoherence = {
        coherenceIndex = SIGMA_ZERO;
        lfPower = 0.5;
        hfPower = 0.5;
        lfHfRatio = 1.0;
        entrainmentLevel = 0.5;
        emotionalState = 0.0;
      };
      circadianState = {
        timeOfDay = 8.0;
        melatoninLevel = 0.1;
        cortisolLevel = 0.8;
        alertnessLevel = 0.7;
        bodyTemperature = 0.0;
        metabolicRate = 0.8;
        phase = 0.0;
        periodDeviation = 0.2;
      };
      fibonacciBeat = 0;
      nextFibonacciEvent = 1;
      fibonacciPhase = 0.0;
      globalCoherence = SIGMA_ZERO;
      globalPhase = 0.0;
      externalFrequency = 0.0;
      entrainmentStrength = 0.1;
      energyLevel = 1.0;
      metabolicCost = 0.001;
      waveformType = #Cardiac;
      currentOutput = 0.0;
      uptime = 0.0;
      totalBeats = 0;
      averageBPM = 60.0;
      bpmVariance = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getHeartbeatStatus(state: HeartbeatEngineState) : Text {
    "═══════════════════════════════════════════════════════════════\n" #
    "              HEARTBEAT ENGINE STATUS (E-010)                   \n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "Master Beat: " # Nat.toText(state.masterBeat) # "\n" #
    "Master Phase: " # Float.format(#fix 3, state.masterPhase) # " rad\n" #
    "Master Frequency: " # Float.format(#fix 2, state.masterFrequency) # " Hz\n" #
    "Elapsed Time: " # Float.format(#fix 1, state.elapsedTime) # " s\n" #
    "───────────────────────────────────────────────────────────────\n" #
    "Cardiac BPM: " # Float.format(#fix 1, state.averageBPM) # "\n" #
    "Cardiac Coherence: " # Float.format(#fix 2, state.cardiacCoherence.coherenceIndex * 100.0) # "%\n" #
    "LF/HF Ratio: " # Float.format(#fix 2, state.cardiacCoherence.lfHfRatio) # "\n" #
    "───────────────────────────────────────────────────────────────\n" #
    "Circadian Time: " # Float.format(#fix 1, state.circadianState.timeOfDay) # " h\n" #
    "Alertness: " # Float.format(#fix 2, state.circadianState.alertnessLevel * 100.0) # "%\n" #
    "Melatonin: " # Float.format(#fix 2, state.circadianState.melatoninLevel * 100.0) # "%\n" #
    "───────────────────────────────────────────────────────────────\n" #
    "Global Coherence: " # Float.format(#fix 2, state.globalCoherence * 100.0) # "%\n" #
    "Fibonacci Beat: F" # Nat.toText(state.fibonacciBeat) # "\n" #
    "Energy Level: " # Float.format(#fix 2, state.energyLevel * 100.0) # "%\n" #
    "═══════════════════════════════════════════════════════════════"
  };

}
