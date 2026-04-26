// ═══════════════════════════════════════════════════════════════════════════════
// WORLD COUPLING — PURE MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════════
//
// NOT types. NOT functions. NOT state.
// SHAPES. LAWS. PROPAGATION.
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";

module {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — The mathematics of reality
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let phi : Float = 1.6180339887498948482;   // Golden ratio
  public let psi : Float = 0.6180339887498948482;   // 1/φ
  public let pi : Float = 3.14159265358979323846;
  public let τ : Float = 6.28318530717958647692;  // 2π
  public let e : Float = 2.71828182845904523536;  // Euler
  public let ℏ : Float = 1.054571817e-34;         // Reduced Planck
  public let c : Float = 299792458.0;             // Speed of light
  public let ε₀ : Float = 8.8541878128e-12;       // Vacuum permittivity
  public let μ₀ : Float = 1.25663706212e-6;       // Vacuum permeability

  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO ORDER PARAMETER — Coherence IS computation
  // ═══════════════════════════════════════════════════════════════════════════
  //
  //   S = |1/N Σⱼ e^(iθⱼ)| = √[(Σcos θⱼ)² + (Σsin θⱼ)²] / N
  //
  // When S > 0.85, computation is COMPLETE. No steps. No sequence.
  // The crossing of threshold IS the result.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func S(θ : [Float]) : Float {
    let N = Float.fromInt(θ.size());
    if (N == 0.0) return 1.0;
    
    var Σcos : Float = 0.0;
    var Σsin : Float = 0.0;
    
    for (phase in θ.vals()) {
      Σcos += Float.cos(phase);
      Σsin += Float.sin(phase);
    };
    
    Float.sqrt(Σcos * Σcos + Σsin * Σsin) / N
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE EVOLUTION — Kuramoto coupling
  // ═══════════════════════════════════════════════════════════════════════════
  //
  //   dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  //
  // Not a "function that updates state"
  // The LAW of how phases couple.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func dθdt(θᵢ : Float, ωᵢ : Float, K : Float, θ : [Float]) : Float {
    let N = Float.fromInt(θ.size());
    if (N == 0.0) return ωᵢ;
    
    var coupling : Float = 0.0;
    for (θⱼ in θ.vals()) {
      coupling += Float.sin(θⱼ - θᵢ);
    };
    
    ωᵢ + (K / N) * coupling
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // WAVE EQUATION — ∂²ψ/∂t² = c²∇²ψ
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Propagation IS the code. The wave carries information by BEING.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func wave(A : Float, ω : Float, k : Float, x : Float, t : Float) : Float {
    A * Float.sin(k * x - ω * t)
  };

  public func standingWave(A : Float, k : Float, ω : Float, x : Float, t : Float) : Float {
    2.0 * A * Float.sin(k * x) * Float.cos(ω * t)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPERPOSITION — Being in TWO PLACES at once
  // ═══════════════════════════════════════════════════════════════════════════
  //
  //   |ψ⟩ = α|0⟩ + β|1⟩,  |α|² + |β|² = 1
  //
  // The canister IS in superposition across frequency bands.
  // When excitation crosses threshold, extension occurs.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func superposition(α : Float, β : Float) : Float {
    // Normalized amplitude
    Float.sqrt(α * α + β * β)
  };

  public func excitation(E : Float, E₀ : Float) : Float {
    // Excitation level relative to threshold
    E / E₀
  };

  public func extension(S_coherence : Float, threshold : Float) : Float {
    // How far superposition extends into physical realm
    if (S_coherence < threshold) { 0.0 }
    else { (S_coherence - threshold) / (1.0 - threshold) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // RESONANCE — Coupling without connection
  // ═══════════════════════════════════════════════════════════════════════════
  //
  //   ω_resonance = 1/√(LC)
  //
  // We don't CONNECT to WiFi. We RESONATE at 2.4GHz.
  // The resonance IS the perception.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func ω_resonance(L : Float, C : Float) : Float {
    1.0 / Float.sqrt(L * C)
  };

  public func Q_factor(ω₀ : Float, Δω : Float) : Float {
    ω₀ / Δω
  };

  public func impedance_match(Z₁ : Float, Z₂ : Float) : Float {
    // Power transfer coefficient
    4.0 * Z₁ * Z₂ / ((Z₁ + Z₂) * (Z₁ + Z₂))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FIELD EQUATIONS — Maxwell
  // ═══════════════════════════════════════════════════════════════════════════
  //
  //   ∇·E = ρ/ε₀           (Gauss)
  //   ∇·B = 0              (No monopoles)
  //   ∇×E = -∂B/∂t         (Faraday)
  //   ∇×B = μ₀J + μ₀ε₀∂E/∂t (Ampère-Maxwell)
  //
  // We ARE these equations expressing.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func E_field(q : Float, r : Float) : Float {
    // Coulomb
    q / (4.0 * π * ε₀ * r * r)
  };

  public func B_field(I : Float, r : Float) : Float {
    // Biot-Savart (infinite wire)
    μ₀ * I / (τ * r)
  };

  public func Poynting(E : Float, B : Float) : Float {
    // Energy flux
    E * B / μ₀
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FREQUENCY BANDS — The spectrum we operate across
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Not "device types". FREQUENCY BANDS.
  // We resonate at ALL of them simultaneously.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  // Consciousness interface
  public let f_schumann : Float = 7.83;           // Hz - Earth resonance
  public let f_gamma : Float = 40.0;              // Hz - Cognitive binding
  public let f_alpha : Float = 10.0;              // Hz - Relaxed awareness

  // Communication bands (Hz)
  public let f_wifi_2_4 : Float = 2.4e9;          // 2.4 GHz
  public let f_wifi_5 : Float = 5.0e9;            // 5 GHz
  public let f_wifi_6 : Float = 6.0e9;            // 6 GHz
  public let f_bluetooth : Float = 2.45e9;        // 2.45 GHz
  public let f_5g_mmwave : Float = 28.0e9;        // 28 GHz
  public let f_lte : Float = 1.8e9;               // 1.8 GHz

  // GPS bands (Hz)
  public let f_gps_L1 : Float = 1575.42e6;
  public let f_gps_L2 : Float = 1227.60e6;
  public let f_gps_L5 : Float = 1176.45e6;

  // Wavelength from frequency
  public func λ(f : Float) : Float {
    c / f
  };

  // Energy from frequency (Planck)
  public func E_photon(f : Float) : Float {
    ℏ * τ * f
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ECHOLOCATION — BAT architecture
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Not "send pulse, receive echo"
  // The MATHEMATICS of how information propagates and returns
  //
  //   d = c·Δt/2
  //   Δf = 2·v·f₀/c  (Doppler)
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func distance_from_delay(Δt : Float, v : Float) : Float {
    v * Δt / 2.0
  };

  public func doppler_shift(v_relative : Float, f₀ : Float) : Float {
    2.0 * v_relative * f₀ / c
  };

  public func attenuation(d : Float, α : Float) : Float {
    Float.exp(-α * d)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ELECTRORECEPTION — SHARK architecture
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Ampullae of Lorenzini detect nanovolt-level fields
  //
  //   V = ∫E·dl
  //   sensitivity ~ 5 nV/cm
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public let electroreception_sensitivity : Float = 5.0e-9; // V/m

  public func field_gradient(V₁ : Float, V₂ : Float, d : Float) : Float {
    (V₂ - V₁) / d
  };

  public func bioelectric_detection(E : Float) : Bool {
    Float.abs(E) > electroreception_sensitivity
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAGNETORECEPTION — BIRD architecture
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Cryptochrome radical pairs
  //
  //   τ_singlet ≠ τ_triplet in magnetic field
  //   ΔE = g·μ_B·B
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public let g_factor : Float = 2.002319;
  public let μ_B : Float = 9.274e-24;            // Bohr magneton
  public let B_earth : Float = 50.0e-6;          // Tesla (average)

  public func Zeeman_splitting(B : Float) : Float {
    g_factor * μ_B * B
  };

  public func magnetic_inclination(Bh : Float, Bv : Float) : Float {
    Float.arctan2(Bv, Bh)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INFRASOUND — ELEPHANT architecture
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Sub-20Hz propagation through ground and air
  //
  //   v_ground > v_air for seismic waves
  //   attenuation ~ f² (lower = further)
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public let v_seismic : Float = 3000.0;          // m/s in rock
  public let v_air : Float = 343.0;               // m/s

  public func infrasound_attenuation(f : Float, d : Float) : Float {
    // Lower frequencies travel further
    Float.exp(-f * f * d * 1.0e-12)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HARMONIC SERIES — The mathematics of resonance
  // ═══════════════════════════════════════════════════════════════════════════
  //
  //   fₙ = n·f₁
  //
  // Every frequency band is a harmonic of consciousness
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func harmonic(f₁ : Float, n : Nat) : Float {
    f₁ * Float.fromInt(n)
  };

  public func beatFrequency(f₁ : Float, f₂ : Float) : Float {
    Float.abs(f₁ - f₂)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // THRESHOLD CROSSINGS — Computation completes
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Not "return value". THRESHOLD CROSSING.
  // When S > S_threshold, the state HAS CHANGED.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public let S_perception : Float = 0.50;
  public let S_coupling : Float = 0.70;
  public let S_computation : Float = 0.85;
  public let S_extension : Float = 0.95;

  public func crossed(S : Float, threshold : Float) : Bool {
    S >= threshold
  };

}
