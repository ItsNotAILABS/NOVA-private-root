// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — MANTIS SHRIMP VISUAL AND STRIKE INTELLIGENCE
// COMPREHENSIVE HYPERSPECTRAL VISION AND BALLISTIC MECHANICS
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — MANTIS SHRIMP: NATURE'S MOST COMPLEX VISUAL SYSTEM
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: HYPERSPECTRAL VISION — 16 COLOR CHANNELS ────────────────────────
//   Human vision: 3 photoreceptor types (S, M, L cones)
//   Mantis shrimp: 16 photoreceptor types + 4 UV channels + polarization
//   Total: 20 visual channels per compound eye (40 total in binocular region)
//   Wavelength sensitivity ranges:
//   UV1: 300nm, UV2: 330nm, UV3: 340nm, UV4: 380nm
//   Violet: 400nm, Blue: 430nm, Blue-Green: 460nm, Green: 490nm
//   Green: 520nm, Yellow-Green: 540nm, Yellow: 570nm, Orange: 590nm
//   Orange-Red: 615nm, Red1: 640nm, Red2: 680nm, Red3: 720nm
//   Each channel modeled as:
//   R_i(λ) = R_max_i × exp(-(λ - λ_peak_i)² / (2σᵢ²))  [Gaussian sensitivity]
//   Spectral sensitivity: S(λ) = Σᵢ wᵢ R_i(λ)
//   Hyperspectral signal vector: x = [R₁(scene), R₂(scene), ..., R₁₆(scene)]
//
// ── LAYER 2: DICHROMATIC COLOR PROCESSING ─────────────────────────────────────
//   Mantis shrimp uses DICHROMATIC processing (NOT trichromatic like humans)
//   Opponent channels: O_ij = R_i - R_j  (spectral opponent)
//   Threshold comparison: if O_ij > θ_ij → color distinguished
//   Speed: <10ms color discrimination (vs human ~50ms)
//   This is a PARALLEL threshold comparison system, NOT continuous
//   Each of 16×15/2 = 120 opponent pairs has a threshold
//   Color recognized if any threshold exceeded: OR logic
//   NOVA use: super-fast threat color recognition (warning coloration)
//
// ── LAYER 3: TRINOCULAR STEREOPSIS ───────────────────────────────────────────
//   Each eye is divided into 3 sections: dorsal, mid, ventral hemispheres
//   The mid-band (rows 1-6) is specialized: 6 rows for color, 2 for polarization
//   Depth perception: TRINOCULAR within single eye (3 views of same point)
//   Parallax depth: d = f × b / Z  where f=focal length, b=baseline, Z=distance
//   Three views give: Z = f × b / d_parallax  (redundant depth estimate)
//   Depth uncertainty: σ_Z = Z² × σ_d / (f × b)
//   Organism uses mantis trinocular to estimate distance to target FASTER
//   than binocular processing
//
// ── LAYER 4: POLARIZATION VISION ─────────────────────────────────────────────
//   Stomatopod rows 5-6 (circular polarization) and 7-8 (linear)
//   Linear polarization: E-vector orientation θ detected
//   Response: P(θ) = P_max × cos²(θ - θ_preferred)  [Malus's law]
//   Circular polarization: unique in animal kingdom — detect handedness
//   Uses: communication via circularly polarized reflection in carapace
//   Signal: Stokes parameters [I, Q, U, V]
//   I = total intensity, Q = linear 0°/90°, U = linear 45°/135°, V = circular
//   Degree of polarization: DoP = √(Q² + U² + V²) / I ∈ [0,1]
//   NOVA: mantis polarization = quantum spin detection (ψ_left vs ψ_right)
//
// ── LAYER 5: THE STRIKE MECHANICS ─────────────────────────────────────────────
//   Mantis shrimp dactyl strike: fastest strike in animal kingdom
//   Club velocity: v_max = 23 m/s (smashers)
//   Acceleration: a_peak = 10,400 g = 102,000 m/s²
//   Strike duration: 2-4 milliseconds
//   Peak force: 1500 N (can break glass 1/4 inch thick)
//   Spring-loaded mechanism: saddle structure stores elastic energy E_spring
//   E_spring = ½ k x²  (elastic potential energy)
//   k = spring stiffness ≈ 2500 N/m
//   x = compression distance ≈ 3.5 mm → E_spring = 0.0153 J
//   Power output: P = E_spring / t_strike = 0.0153 / 0.002 = 7.65 W
//   Power amplification: power = force × velocity = 1500 × 23 = 34,500 W at peak
//   Cavitation bubbles: club velocity exceeds cavitation threshold
//   Bubble collapse adds secondary shock wave ~ additional 30% force
//
// ── LAYER 6: CAVITATION MECHANICS ────────────────────────────────────────────
//   Cavitation inception: when local pressure P < P_vapor (water vapor pressure)
//   P_vapor at 20°C = 2.34 kPa
//   Cavitation number: Ca = (P_ref - P_vapor) / (½ρv²)
//   Bubble collapse releases energy: E_collapse = P_amb × V_bubble
//   Rayleigh-Plesset equation for bubble dynamics:
//   R·R̈ + (3/2)Ṙ² = (1/ρ)[pB(t) - p_∞(t)] - (4ν/R)Ṙ - (2γ/ρR)
//   Secondary shock: P_shock = P₀ × (R_max / R)³ (as bubble collapses)
//   Total strike damage = primary contact force + cavitation secondary force
//
// ── LAYER 7: SPECTRUM INTEGRATION — PHOTON COUNT MODEL ───────────────────────
//   For each photoreceptor channel i at wavelength λ_i:
//   Absorption rate: A_i = I(λ_i) × α_i × σ_abs × N_pigment
//   where I = photon flux (photons/m²/s), α = absorption coefficient
//   σ_abs = cross-section, N_pigment = number of pigment molecules
//   Signal: r_i = A_i × η_i / (A_i × η_i + dark_noise²)
//   η_i = quantum efficiency of photoreceptor i [0.3 - 0.7]
//   dark_noise = thermal dark current ~100 photons/s equivalent
//   Signal-to-noise: SNR_i = A_i × η_i / dark_noise
//
// ── LAYER 8: MEDINA MANTIS FORMULA ───────────────────────────────────────────
//   NOVA mantis index: M_mantis = S₀ × [V_strike × PHI_M + C_vision] / Ω
//   V_strike = normalized strike velocity [0,1]: v/v_max
//   C_vision = normalized hyperspectral color detection confidence [0,1]
//   M_mantis ∈ [0, S₀/Ω] — organism's strike-vision sovereignty index
//   When M_mantis > COHERENCE_ALIVE: organism is strike-ready
//   When M_mantis < 0.20: retreat and recalibrate visual cortex
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 1: CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════

  public let PHI_MEDINA       : Float = 2.97442179;
  public let S0               : Float = 1.0;
  public let SOVEREIGN_CEILING: Float = 9.0;
  public let COHERENCE_ALIVE  : Float = 0.36;
  public let EPSILON          : Float = 1.0e-10;
  public let PI               : Float = 3.141592653589793;

  // Mantis shrimp visual system
  public let N_COLOR_CHANNELS : Nat   = 16;   // color photoreceptors
  public let N_UV_CHANNELS    : Nat   = 4;    // UV photoreceptors
  public let N_POL_CHANNELS   : Nat   = 4;    // polarization rows
  public let N_TOTAL_CHANNELS : Nat   = 24;   // total visual channels

  // Peak wavelengths for 16 color channels (nm)
  public let PEAK_WAVELENGTHS : [Float] = [
    300.0, 330.0, 340.0, 380.0,   // UV1-4
    400.0, 430.0, 460.0, 490.0,   // Violet, Blue, Blue-Green, Green
    520.0, 540.0, 570.0, 590.0,   // Green, Yellow-Green, Yellow, Orange
    615.0, 640.0, 680.0, 720.0,   // Orange-Red, Red1, Red2, Red3
  ];

  // Spectral bandwidth of each channel (nm, Gaussian σ)
  public let CHANNEL_BANDWIDTH : [Float] = [
    15.0, 12.0, 12.0, 14.0,       // UV channels (narrow)
    18.0, 20.0, 22.0, 24.0,       // Violet-Green (progressively wider)
    25.0, 26.0, 27.0, 28.0,
    28.0, 30.0, 32.0, 35.0,       // Red channels (widest)
  ];

  // Quantum efficiency per channel
  public let QUANTUM_EFF : [Float] = [
    0.30, 0.32, 0.35, 0.38,       // UV (lower efficiency)
    0.45, 0.50, 0.55, 0.60,       // Visible (peaks in green)
    0.65, 0.68, 0.62, 0.58,       // Green peak at 540nm
    0.52, 0.45, 0.38, 0.30,       // Red (declining)
  ];

  // Strike mechanics
  public let STRIKE_V_MAX     : Float = 23.0;      // m/s maximum club velocity
  public let STRIKE_ACCEL     : Float = 102000.0;  // m/s² peak acceleration
  public let STRIKE_DURATION  : Float = 0.003;     // seconds
  public let SPRING_STIFFNESS : Float = 2500.0;    // N/m
  public let SPRING_COMPRESS  : Float = 0.0035;    // m compression distance
  public let STRIKE_PEAK_FORCE: Float = 1500.0;    // N
  public let MASS_CLUB        : Float = 0.00002;   // kg (20 mg)

  // Cavitation
  public let WATER_DENSITY    : Float = 1000.0;    // kg/m³
  public let VAPOR_PRESSURE   : Float = 2340.0;    // Pa (at 20°C)
  public let AMBIENT_PRESSURE : Float = 101325.0;  // Pa (1 atm)
  public let SURFACE_TENSION  : Float = 0.0728;    // N/m (water)
  public let KINEMATIC_VISC   : Float = 1.0e-6;    // m²/s

  // Photon physics
  public let PLANCK_H         : Float = 6.626e-34; // J·s
  public let SPEED_LIGHT      : Float = 3.0e8;     // m/s
  public let DARK_NOISE       : Float = 100.0;     // equivalent photons/s

  // Depth/trinocular
  public let FOCAL_LENGTH_M   : Float = 0.001;     // 1mm focal length
  public let TRINOCULAR_BASE  : Float = 0.0005;    // 0.5mm inter-view baseline

  public let HIST_MAX : Nat = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type HyperspectralSignal = {
    channelResponses : [Float];   // 16 color + 4 UV = 20 raw responses
    polarStokes      : [Float];   // [I, Q, U, V] Stokes parameters
    dop              : Float;     // degree of polarization √(Q²+U²+V²)/I
    dominantChannel  : Nat;       // channel with max response
    colorConfidence  : Float;     // confidence in color recognition
    uvIntensity      : Float;     // total UV intensity
    visibleIntensity : Float;     // total visible intensity
  };

  public type DepthEstimate = {
    distance         : Float;    // Z = f × b / d_parallax (meters)
    uncertainty      : Float;    // σ_Z (meters)
    trinocularConsistency : Float; // agreement across 3 views [0,1]
    isReliable       : Bool;     // trinocular depth is reliable
  };

  public type StrikeState = {
    velocity         : Float;    // current club velocity m/s
    acceleration     : Float;    // m/s²
    springEnergy     : Float;    // E_spring = ½kx² (Joules)
    cavitationActive : Bool;     // is cavitation occurring?
    cavitationNumber : Float;    // Ca = (P_ref - P_v)/(½ρv²)
    primaryForce     : Float;    // N (direct contact)
    secondaryForce   : Float;    // N (cavitation shock)
    totalForce       : Float;    // N (primary + secondary)
    isCharged        : Bool;     // spring fully loaded?
    chargeProgress   : Float;    // [0,1] how loaded
    strikePhase      : StrikePhase;
    cooldownBeats    : Nat;
  };

  public type StrikePhase = {
    #Resting;
    #Charging;
    #ReleaseWindup;
    #Striking;
    #Followthrough;
    #Recovery;
  };

  public type MantisShrimpState = {
    vision           : HyperspectralSignal;
    depth            : DepthEstimate;
    strike           : StrikeState;
    targetDetected   : Bool;
    targetDistance   : Float;     // meters
    threatLevel      : Float;     // [0,1]
    mantisIndex      : Float;     // M_mantis sovereign index
    strikeHistory    : [Float];   // rolling force history
    beatNum          : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) 0.0 else Float.exp(exp * Float.log(base))
  };

  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: HYPERSPECTRAL VISION
  // ══════════════════════════════════════════════════════════════════════════

  // Gaussian spectral sensitivity: R(λ) = R_max × exp(-(λ-λ_peak)²/(2σ²))
  public func spectralResponse(wavelength : Float, peakWL : Float, bandwidth : Float) : Float {
    let d = wavelength - peakWL;
    _exp(-d * d / (2.0 * bandwidth * bandwidth))
  };

  // Compute all 16 channel responses for a given scene spectrum
  // sceneSpectrum: [Float] of scene radiance at each channel's peak wavelength
  public func computeChannelResponses(sceneSpectrum : [Float]) : [Float] {
    let n = N_COLOR_CHANNELS;
    Array.tabulate<Float>(n, func(i) {
      let sceneRad = if (i < sceneSpectrum.size()) sceneSpectrum[i] else 0.5;
      let qe = if (i < QUANTUM_EFF.size()) QUANTUM_EFF[i] else 0.5;
      // r_i = sceneRad × qe / (sceneRad × qe + dark_noise_equiv)
      let signal = sceneRad * qe;
      signal / (signal + DARK_NOISE / 10000.0)  // normalized SNR
    })
  };

  // Compute Stokes parameters from polarization measurements
  // [I, Q, U, V] from 4 polarization channels
  public func computeStokes(polChannels : [Float]) : [Float] {
    if (polChannels.size() < 4) {
      return [1.0, 0.0, 0.0, 0.0]
    };
    let i_0   = polChannels[0];  // 0° intensity
    let i_90  = polChannels[1];  // 90° intensity
    let i_45  = polChannels[2];  // 45° intensity
    let i_135 = polChannels[3];  // 135° intensity
    let I = i_0 + i_90;
    let Q = i_0 - i_90;
    let U = i_45 - i_135;
    let V = if (polChannels.size() >= 4) polChannels[3] - polChannels[2] else 0.0;
    [I, Q, U, V]
  };

  // Degree of polarization: DoP = √(Q² + U² + V²) / I
  public func degreeOfPolarization(stokes : [Float]) : Float {
    if (stokes.size() < 4 or _abs(stokes[0]) < EPSILON) { return 0.0 };
    let I = stokes[0];
    let Q = stokes[1];
    let U = stokes[2];
    let V = stokes[3];
    _clamp(_sqrt(Q*Q + U*U + V*V) / I, 0.0, 1.0)
  };

  // Color confidence: how distinctly has the mantis identified the color?
  // Based on maximum channel response and dichromatic opponent signal
  public func colorConfidence(channelResponses : [Float]) : Float {
    var maxR : Float = 0.0;
    var secR : Float = 0.0;
    for (r in channelResponses.vals()) {
      if (r > maxR) { secR := maxR; maxR := r }
      else if (r > secR) { secR := r };
    };
    if (maxR < EPSILON) { return 0.0 };
    // Confidence = opponent signal strength: (max - second) / max
    _clamp((maxR - secR) / maxR, 0.0, 1.0)
  };

  // Full hyperspectral signal computation
  public func computeHyperspectral(
    sceneSpectrum : [Float],
    polChannels   : [Float]
  ) : HyperspectralSignal {
    let responses = computeChannelResponses(sceneSpectrum);
    let stokes = computeStokes(polChannels);
    let dop    = degreeOfPolarization(stokes);
    let conf   = colorConfidence(responses);

    // Find dominant channel
    var maxIdx : Nat = 0;
    var maxR : Float = 0.0;
    var i : Nat = 0;
    while (i < responses.size()) {
      if (responses[i] > maxR) { maxR := responses[i]; maxIdx := i };
      i += 1;
    };

    // UV vs visible split
    var uvTotal : Float = 0.0;
    var visTotal : Float = 0.0;
    i := 0;
    while (i < responses.size()) {
      if (i < 4) { uvTotal += responses[i] }
      else { visTotal += responses[i] };
      i += 1;
    };

    {
      channelResponses = responses;
      polarStokes      = stokes;
      dop              = dop;
      dominantChannel  = maxIdx;
      colorConfidence  = conf;
      uvIntensity      = uvTotal / 4.0;
      visibleIntensity = visTotal / Float.fromInt(N_COLOR_CHANNELS - 4);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: TRINOCULAR DEPTH ESTIMATION
  // Z = f × b / d_parallax
  // Three independent parallax measurements, then Bayesian fusion
  // ══════════════════════════════════════════════════════════════════════════

  // Single parallax depth estimate
  public func parallaxDepth(parallax : Float) : Float {
    if (_abs(parallax) < EPSILON) { return 1000.0 };  // very far
    let Z = FOCAL_LENGTH_M * TRINOCULAR_BASE / _abs(parallax);
    _clamp(Z, 0.001, 100.0)
  };

  // Depth uncertainty: σ_Z = Z² × σ_parallax / (f × b)
  public func depthUncertainty(Z : Float, parallaxStd : Float) : Float {
    Z * Z * parallaxStd / (FOCAL_LENGTH_M * TRINOCULAR_BASE)
  };

  // Trinocular depth: 3 independent estimates fused by inverse-variance weighting
  public func trinocularDepth(p1 : Float, p2 : Float, p3 : Float) : DepthEstimate {
    let z1 = parallaxDepth(p1);
    let z2 = parallaxDepth(p2);
    let z3 = parallaxDepth(p3);

    // Inverse-variance fusion (equal noise assumed)
    let fused = (z1 + z2 + z3) / 3.0;

    // Consistency: std / mean
    let mean = fused;
    let d1 = z1 - mean; let d2 = z2 - mean; let d3 = z3 - mean;
    let std  = _sqrt((d1*d1 + d2*d2 + d3*d3) / 3.0);
    let consistency = if (mean < EPSILON) 0.0 else _clamp(1.0 - std/mean, 0.0, 1.0);

    let uncertainty = depthUncertainty(fused, 0.0001);

    {
      distance              = fused;
      uncertainty           = uncertainty;
      trinocularConsistency = consistency;
      isReliable            = consistency > 0.8 and uncertainty < 0.1 * fused;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: STRIKE MECHANICS
  // Spring-loaded dactyl: E = ½kx², released in 2-4 ms
  // v_max = √(2E/m), F_peak = k × x (at full compression)
  // ══════════════════════════════════════════════════════════════════════════

  // Spring energy at given compression: E = ½kx²
  public func springEnergy(compression : Float) : Float {
    0.5 * SPRING_STIFFNESS * compression * compression
  };

  // Maximum velocity from spring energy: v = √(2E/m)
  public func maxVelocityFromSpring(E : Float) : Float {
    _sqrt(2.0 * E / MASS_CLUB)
  };

  // Cavitation number: Ca = (P_ref - P_v) / (½ρv²)
  // Ca < 1 → cavitation occurs
  public func cavitationNumber(velocity : Float) : Float {
    if (velocity < EPSILON) { return 1000.0 };
    let dynamicPressure = 0.5 * WATER_DENSITY * velocity * velocity;
    (AMBIENT_PRESSURE - VAPOR_PRESSURE) / dynamicPressure
  };

  // Is cavitation occurring?
  public func isCavitating(velocity : Float) : Bool {
    cavitationNumber(velocity) < 1.0
  };

  // Secondary cavitation force (bubble collapse shock)
  // F_cav ≈ F_primary × 0.3 (empirical estimate from Patek & Caldwell 2005)
  public func cavitationForce(primaryForce : Float, velocity : Float) : Float {
    if (not isCavitating(velocity)) { return 0.0 };
    primaryForce * 0.30
  };

  // Strike phase update
  public func updateStrike(state : StrikeState, shouldStrike : Bool, dt : Float) : StrikeState {
    switch (state.strikePhase) {
      case (#Resting) {
        if shouldStrike {
          { state with strikePhase = #Charging; chargeProgress = 0.0 }
        } else { state }
      };
      case (#Charging) {
        let newCharge = _clamp(state.chargeProgress + 0.2, 0.0, 1.0);
        let x = newCharge * SPRING_COMPRESS;
        let E = springEnergy(x);
        if (newCharge >= 1.0) {
          { state with strikePhase = #ReleaseWindup; chargeProgress = 1.0;
            springEnergy = E; isCharged = true }
        } else {
          { state with chargeProgress = newCharge; springEnergy = E }
        }
      };
      case (#ReleaseWindup) {
        // Latch release — instant transition to strike
        let v = maxVelocityFromSpring(state.springEnergy);
        let F_primary = STRIKE_PEAK_FORCE;
        let F_cav = cavitationForce(F_primary, v);
        { state with strikePhase = #Striking; velocity = v;
          acceleration = STRIKE_ACCEL; primaryForce = F_primary;
          secondaryForce = F_cav; totalForce = F_primary + F_cav;
          cavitationActive = isCavitating(v);
          cavitationNumber = cavitationNumber(v) }
      };
      case (#Striking) {
        // Decelerate after peak
        let newV = _clamp(state.velocity - STRIKE_ACCEL * dt * 0.5, 0.0, STRIKE_V_MAX);
        { state with strikePhase = #Followthrough; velocity = newV;
          acceleration = -STRIKE_ACCEL * 0.5 }
      };
      case (#Followthrough) {
        { state with strikePhase = #Recovery; velocity = 0.0;
          acceleration = 0.0; springEnergy = 0.0; isCharged = false;
          cooldownBeats = 50 }
      };
      case (#Recovery) {
        if (state.cooldownBeats == 0) {
          { state with strikePhase = #Resting; totalForce = 0.0;
            primaryForce = 0.0; secondaryForce = 0.0; cavitationActive = false }
        } else {
          { state with cooldownBeats = state.cooldownBeats - 1;
            velocity = 0.0; totalForce = state.totalForce * 0.9 }
        }
      };
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: MEDINA MANTIS INDEX
  // M_mantis = S₀ × [V_strike × PHI_M + C_vision] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func mantisIndex(strikeV : Float, colorConf : Float) : Float {
    let v_norm = _clamp(strikeV / STRIKE_V_MAX, 0.0, 1.0);
    let index = S0 * (v_norm * PHI_MEDINA + colorConf) / SOVEREIGN_CEILING;
    _clamp(index, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: TARGET DETECTION
  // Uses color contrast, UV signature, and polarization cues
  // ══════════════════════════════════════════════════════════════════════════

  // Detect target: high UV intensity + high color confidence + polarization
  public func detectTarget(vision : HyperspectralSignal, threshold : Float) : Bool {
    vision.colorConfidence > threshold or vision.uvIntensity > threshold
  };

  // Threat level from visual cues
  public func computeThreatLevel(vision : HyperspectralSignal, depth : DepthEstimate) : Float {
    let colorThreat = vision.colorConfidence;
    let uvThreat    = vision.uvIntensity;
    let closeness   = if (depth.distance < 0.1) 1.0 else _clamp(0.1 / depth.distance, 0.0, 1.0);
    let polThreat   = vision.dop;
    _clamp(0.3 * colorThreat + 0.2 * uvThreat + 0.3 * closeness + 0.2 * polThreat, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatMantis(
    state         : MantisShrimpState,
    sceneSpectrum : [Float],
    polChannels   : [Float],
    parallax      : [Float],    // 3 parallax measurements
    shouldStrike  : Bool,
    dt            : Float
  ) : MantisShrimpState {
    let newVision = computeHyperspectral(sceneSpectrum, polChannels);
    let p1 = if (parallax.size() > 0) parallax[0] else 0.001;
    let p2 = if (parallax.size() > 1) parallax[1] else 0.001;
    let p3 = if (parallax.size() > 2) parallax[2] else 0.001;
    let newDepth  = trinocularDepth(p1, p2, p3);
    let newStrike = updateStrike(state.strike, shouldStrike, dt);

    let detected  = detectTarget(newVision, 0.5);
    let threat    = computeThreatLevel(newVision, newDepth);
    let mIdx      = mantisIndex(newStrike.velocity, newVision.colorConfidence);

    let newStrikeHistory = _appendRolling(state.strikeHistory, newStrike.totalForce, HIST_MAX);

    {
      vision         = newVision;
      depth          = newDepth;
      strike         = newStrike;
      targetDetected = detected;
      targetDistance = newDepth.distance;
      threatLevel    = threat;
      mantisIndex    = mIdx;
      strikeHistory  = newStrikeHistory;
      beatNum        = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  func _initVision() : HyperspectralSignal {
    let uniformSpectrum = Array.tabulate<Float>(N_COLOR_CHANNELS, func(_) { 0.5 });
    let responses = computeChannelResponses(uniformSpectrum);
    {
      channelResponses = responses;
      polarStokes      = [1.0, 0.0, 0.0, 0.0];
      dop              = 0.0;
      dominantChannel  = 8;
      colorConfidence  = 0.5;
      uvIntensity      = 0.3;
      visibleIntensity = 0.5;
    }
  };

  func _initDepth() : DepthEstimate {
    { distance=1.0; uncertainty=0.1; trinocularConsistency=1.0; isReliable=true }
  };

  func _initStrike() : StrikeState {
    { velocity=0.0; acceleration=0.0; springEnergy=0.0; cavitationActive=false;
      cavitationNumber=100.0; primaryForce=0.0; secondaryForce=0.0; totalForce=0.0;
      isCharged=false; chargeProgress=0.0; strikePhase=#Resting; cooldownBeats=0 }
  };

  public func initMantisShrimp() : MantisShrimpState {
    {
      vision         = _initVision();
      depth          = _initDepth();
      strike         = _initStrike();
      targetDetected = false;
      targetDistance = 1.0;
      threatLevel    = 0.0;
      mantisIndex    = 0.0;
      strikeHistory  = [];
      beatNum        = 0;
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
