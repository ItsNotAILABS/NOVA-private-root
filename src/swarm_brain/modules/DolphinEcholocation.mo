// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — DOLPHIN ECHOLOCATION ENGINE
// COMPREHENSIVE BIOSONAR PHYSICS AND NEURAL SIGNAL PROCESSING
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — DOLPHIN SONAR: MOST SOPHISTICATED BIOSONAR ON EARTH
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: SONAR RANGE EQUATION ────────────────────────────────────────────
//   Received echo level: RL = SL - 2TL + TS
//   SL = source level (dB re 1 μPa at 1m) — dolphin peak: 228 dB
//   TL = transmission loss over range r
//   TS = target strength = 10 log₁₀(σ/4π)  where σ = backscatter cross-section
//   Transmission loss (spherical spreading + absorption):
//   TL = 20 log₁₀(r) + α_water × r / 1000
//   α_water = absorption coefficient dB/km (frequency-dependent)
//   At 100 kHz: α = 40 dB/km in seawater
//   Maximum range: r_max = 10^((SL - DT - TS) / (40 + 2×20)) / (4π)
//   DT = detection threshold (signal-to-noise requirement)
//
// ── LAYER 2: CLICK WAVEFORM PHYSICS ──────────────────────────────────────────
//   Dolphin sonar click: broadband pulse, peak frequency 40-130 kHz
//   Waveform: p(t) = A × sin(2πf_c t) × exp(-t²/(2σ_t²)) × [t ≥ 0]
//   where f_c = center frequency, σ_t = temporal envelope width
//   Click duration: τ = 50-200 μs
//   Bandwidth: BW = 1/τ  (time-bandwidth product ≈ 1 for Gaussian pulse)
//   Peak pressure: A_peak ≈ 10^((SL-120)/20) Pa at 1m
//   Repetition rate: up to 2000 clicks/second (scan mode)
//   Inter-click interval (ICI): ICI = 2r/c + t_process  (range-locked)
//   c_water = 1500 m/s (vs 343 m/s air)
//
// ── LAYER 3: MELON FOCUSING SYSTEM ───────────────────────────────────────────
//   Melon: fatty acoustic lens that focuses click into forward beam
//   Beam width (3dB): θ₃dB = λ/D  (diffraction limit)
//   where λ = c/f = 1500/100000 = 0.015 m, D = melon aperture ≈ 0.15 m
//   θ₃dB ≈ 0.1 rad ≈ 5.7°  (very focused beam)
//   Directivity index: DI = 10 log₁₀(2πA/λ²)  where A = melon aperture area
//   For circular aperture: DI ≈ 20 log₁₀(πD/λ) = 20 log₁₀(π×0.15/0.015) ≈ 20 dB
//   Beam steering: melon muscles can shift beam ±20° horizontally
//   Click train pattern: foraging clicks form forward-directed search beam
//
// ── LAYER 4: ECHO ANALYSIS — TIME DOMAIN ─────────────────────────────────────
//   Range from echo: r = c × τ_echo / 2  where τ_echo = echo travel time
//   Range resolution: δr = c × τ_pulse / 2  (Rayleigh criterion)
//   At τ_pulse = 50 μs: δr = 1500 × 50×10⁻⁶ / 2 = 37.5 mm
//   Cross-range resolution: δx = r × θ₃dB  (beam width × range)
//   Velocity (Doppler): Δf = 2 × v × f_c / c
//   For v = 1 m/s, f_c = 100 kHz: Δf = 133 Hz (detectable)
//   Two-way Doppler: Δt_echo = 2r/c + 2r'/c where r' changes due to motion
//
// ── LAYER 5: MATCHED FILTER DETECTION ────────────────────────────────────────
//   Matched filter: cross-correlate received signal with template click
//   output: y(t) = x(t) ★ h(-t) = ∫ x(τ) h(τ-t) dτ
//   SNR improvement: gain = 2E/N₀ = 2 × BW × T (processing gain)
//   For BW = 100 kHz, T = 100 μs: gain = 2×10⁵×10⁻⁴ = 20 (13 dB)
//   Ambiguity function: χ(τ, f) = |∫ u(t) u*(t-τ) exp(i2πft) dt|²
//   χ(0,0) = energy E (peak at correct range and velocity)
//   Range-Doppler coupling: broadband pulses have thumbtack ambiguity
//
// ── LAYER 6: MULTIPATH AND INTERFERENCE ──────────────────────────────────────
//   Multiple echoes from: direct return + bottom + surface reflections
//   Bottom reflection: r_bottom = r × 2 + Δr_depth  (longer path)
//   Interference pattern: I(r) = |A₁ exp(iφ₁) + A₂ exp(iφ₂)|²
//                                = A₁² + A₂² + 2A₁A₂cos(Δφ)
//   Δφ = 2π Δr / λ  (phase difference from path length difference)
//   Constructive: Δφ = 2nπ → 4× amplitude
//   Destructive: Δφ = (2n+1)π → 0 amplitude
//   Dolphin SEPARATES multipath via temporal processing and broadband pulse
//
// ── LAYER 7: TARGET CLASSIFICATION ──────────────────────────────────────────
//   Target strength depends on geometry: sphere, cylinder, flat plate
//   Sphere: TS = 10 log₁₀(a²/4)  where a = radius (m)
//   Cylinder: TS = 10 log₁₀(aL/2λ) (side aspect)
//   Fish swim bladder: TS ≈ -50 to -30 dB (resonance at 100-1000 Hz)
//   Highlight structure: complex targets produce multiple echoes
//   Each internal highlight: TH_i = TS_i at delay τᵢ from leading edge
//   Classification vector: [TS₁, τ₁, TS₂, τ₂, ..., TS_N, τ_N]
//   Neural template matching: compare with known prey signatures
//
// ── LAYER 8: MEDINA DOLPHIN SONAR INDEX ──────────────────────────────────────
//   D_sonar = S₀ × [range_inv × Φ_M + target_confidence] / Ω
//   range_inv = 1 - r/r_max  (normalized proximity)
//   target_confidence = echo classification confidence [0,1]
//   D_sonar ∈ [0, S₀(Φ_M+1)/Ω]
//   High D_sonar → prey within range and identified → hunt mode
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  public let PHI_MEDINA       : Float = 2.97442179;
  public let S0               : Float = 1.0;
  public let SOVEREIGN_CEILING: Float = 9.0;
  public let COHERENCE_ALIVE  : Float = 0.36;
  public let EPSILON          : Float = 1.0e-10;
  public let PI               : Float = 3.141592653589793;
  public let TWO_PI           : Float = 6.283185307179586;

  // Sonar constants
  public let SOUND_SPEED_WATER  : Float = 1500.0;   // m/s
  public let SOUND_SPEED_AIR    : Float = 343.0;    // m/s
  public let SOURCE_LEVEL_DB    : Float = 228.0;    // dB re 1μPa @ 1m
  public let CLICK_FREQ_HZ      : Float = 100000.0; // Hz center frequency
  public let CLICK_DURATION_US  : Float = 100.0;    // μs
  public let CLICK_BANDWIDTH_KHZ: Float = 100.0;    // kHz
  public let MELON_DIAMETER_M   : Float = 0.15;     // m melon aperture
  public let BEAM_WIDTH_RAD     : Float = 0.1;      // radians 3dB beamwidth
  public let BEAM_STEER_MAX_DEG : Float = 20.0;     // degrees max steering
  public let ALPHA_ABSORPTION   : Float = 40.0;     // dB/km at 100kHz
  public let DETECTION_THRESH   : Float = 15.0;     // dB SNR requirement
  public let MAX_CLICK_RATE_HZ  : Float = 2000.0;   // clicks/second max
  public let R_MAX_M            : Float = 500.0;    // m maximum useful range
  public let RANGE_RESOLUTION_M : Float = 0.0375;   // m range resolution

  // Transmission loss constants
  public let GEOMETRIC_SPREADING : Float = 20.0;   // dB per decade of range

  public let HIST_MAX : Nat = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type SonarClick = {
    sourceLevel_dB   : Float;
    frequency_hz     : Float;
    duration_us      : Float;
    bandwidth_hz     : Float;
    beamAzimuth_deg  : Float;
    beamElev_deg     : Float;
    clickNumber      : Nat;
  };

  public type EchoReturn = {
    travelTime_us    : Float;    // round-trip travel time
    range_m          : Float;    // r = c × t / 2
    amplitude_dB     : Float;    // received level
    targetStrength_dB: Float;    // TS = RL - SL + 2TL
    dopplerShift_hz  : Float;    // frequency shift from target motion
    targetVelocity   : Float;    // m/s radial velocity
    highlightPattern : [Float];  // multiple highlights from complex target
    confidence       : Float;    // detection confidence [0,1]
  };

  public type TargetClassification = {
    targetType    : TargetType;
    probability   : Float;      // classification probability
    estimatedSize : Float;       // m estimated target length
    swimBladder   : Bool;        // has swim bladder? (resonance detection)
    targetStrength : Float;      // dB
  };

  public type TargetType = {
    #Fish; #Squid; #Crab; #Rock; #Vegetation; #Unknown;
  };

  public type SonarScanState = {
    currentBeamAz  : Float;      // current beam azimuth degrees
    currentBeamEl  : Float;      // current beam elevation degrees
    scanPattern    : ScanPattern;
    clickRate      : Float;       // Hz
    iciMs          : Float;       // inter-click interval ms
    scanComplete   : Bool;
  };

  public type ScanPattern = {
    #Foraging;   // rapid scanning ±30° horizontal
    #Tracking;   // locked on target, 2000 Hz
    #Social;     // lower rate, wider beam
    #Passive;    // no clicks, listening only
  };

  public type EcholocationState = {
    lastClick      : SonarClick;
    echoReturns    : [EchoReturn];
    classification : TargetClassification;
    scanState      : SonarScanState;
    targetDetected : Bool;
    targetRange    : Float;      // m
    targetBearing  : Float;      // degrees
    sonarIndex     : Float;      // D_sonar sovereign index
    clickHistory   : [Float];    // rolling range history
    snrHistory     : [Float];
    beatNum        : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _log10(x : Float) : Float { if (x <= 0.0) -100.0 else Float.log(x) / 2.302585092994046 };
  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) 0.0 else Float.exp(exp * Float.log(base))
  };
  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: SONAR RANGE EQUATION
  // RL = SL - 2TL + TS
  // TL = 20 log₁₀(r) + α × r / 1000
  // ══════════════════════════════════════════════════════════════════════════

  // One-way transmission loss: TL = 20 log₁₀(r) + α r/1000
  public func transmissionLoss(range_m : Float) : Float {
    if (range_m < 0.1) { return 0.0 };
    GEOMETRIC_SPREADING * _log10(range_m) + ALPHA_ABSORPTION * range_m / 1000.0
  };

  // Received level: RL = SL - 2TL + TS
  public func receivedLevel_dB(range_m : Float, targetStrength_dB : Float) : Float {
    SOURCE_LEVEL_DB - 2.0 * transmissionLoss(range_m) + targetStrength_dB
  };

  // SNR at given range and target strength
  // Assume ocean noise N₀ = 60 dB re 1μPa (ambient shipping noise)
  public func signalToNoise_dB(range_m : Float, targetStrength_dB : Float) : Float {
    let oceanNoise = 60.0;
    receivedLevel_dB(range_m, targetStrength_dB) - oceanNoise
  };

  // Maximum detection range for given target strength
  // Solve SL - 2TL + TS = DT for r
  // 2×20×log₁₀(r) + 2×α×r/1000 = SL + TS - DT
  // Simplified: use geometric spreading dominance
  public func maxDetectionRange_m(targetStrength_dB : Float) : Float {
    let budget = SOURCE_LEVEL_DB + targetStrength_dB - DETECTION_THRESH - 60.0;
    // 40 log₁₀(r) = budget → r = 10^(budget/40)
    let r = _pow(10.0, budget / 40.0);
    _clamp(r, 0.1, R_MAX_M)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: CLICK WAVEFORM
  // p(t) = A × sin(2πf_c t) × exp(-t²/(2σ_t²))
  // ══════════════════════════════════════════════════════════════════════════

  // Click amplitude at time t (normalized Gaussian-modulated sinusoid)
  public func clickAmplitude(t_us : Float, freq_hz : Float, duration_us : Float) : Float {
    let sigma = duration_us / 4.0;  // σ_t ≈ τ/4 for Gaussian envelope
    let carrier = _sin(TWO_PI * freq_hz * t_us * 1.0e-6);
    let envelope = _exp(-(t_us * t_us) / (2.0 * sigma * sigma));
    carrier * envelope
  };

  // Inter-click interval: ICI = 2r/c + t_process (range-adaptive)
  // Dolphin waits for echo before sending next click (range-locking)
  public func interClickInterval_ms(range_m : Float) : Float {
    let travelTime_ms = 2.0 * range_m / SOUND_SPEED_WATER * 1000.0;
    let processingTime_ms = 5.0;  // neural processing overhead
    _clamp(travelTime_ms + processingTime_ms, 0.5, 500.0)
  };

  // Melon beam directivity index: DI = 20 log₁₀(πD/λ)
  public func directivityIndex_dB(freq_hz : Float) : Float {
    let wavelength = SOUND_SPEED_WATER / freq_hz;
    20.0 * _log10(PI * MELON_DIAMETER_M / wavelength)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: ECHO PROCESSING
  // Range from travel time, Doppler from frequency shift
  // ══════════════════════════════════════════════════════════════════════════

  // Range from echo travel time
  // r = c × τ_echo / 2
  public func rangeFromTravelTime(travelTime_us : Float) : Float {
    SOUND_SPEED_WATER * travelTime_us * 1.0e-6 / 2.0
  };

  // Travel time from range
  public func travelTimeFromRange_us(range_m : Float) : Float {
    2.0 * range_m / SOUND_SPEED_WATER * 1.0e6
  };

  // Doppler shift: Δf = 2 × v × f_c / c
  // v = radial velocity (positive = approaching)
  public func dopplerShift_hz(velocity_ms : Float, freq_hz : Float) : Float {
    2.0 * velocity_ms * freq_hz / SOUND_SPEED_WATER
  };

  // Radial velocity from Doppler
  public func velocityFromDoppler(dopplerShift_hz : Float, freq_hz : Float) : Float {
    dopplerShift_hz * SOUND_SPEED_WATER / (2.0 * freq_hz)
  };

  // Target strength for sphere of radius a
  // TS = 10 log₁₀(a²/4)
  public func sphereTargetStrength_dB(radius_m : Float) : Float {
    10.0 * _log10(radius_m * radius_m / 4.0)
  };

  // Target strength for cylinder (broadside aspect)
  // TS = 10 log₁₀(a × L / (2λ))
  public func cylinderTargetStrength_dB(radius_m : Float, length_m : Float, freq_hz : Float) : Float {
    let lambda = SOUND_SPEED_WATER / freq_hz;
    10.0 * _log10(radius_m * length_m / (2.0 * lambda))
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: MATCHED FILTER
  // Cross-correlation: y(τ) = ∫ x(t) h(t-τ) dt
  // Simplified: correlation at one lag τ = itcproduct of windowed signals
  // ══════════════════════════════════════════════════════════════════════════

  // Cross-correlation at lag τ (discrete, on sampled signals)
  public func crossCorrelation(signal : [Float], template : [Float], lag : Int) : Float {
    var sum : Float = 0.0;
    let n = signal.size();
    var t : Int = 0;
    while (t < n) {
      let tLag = t + lag;
      if (tLag >= 0 and tLag < n) {
        sum += signal[Int.abs(t)] * template[Int.abs(tLag)];
      };
      t += 1;
    };
    sum
  };

  // Matched filter SNR gain: G = 2E/N₀ ≈ 2 × BW × τ
  public func matchedFilterGain_dB(bandwidth_hz : Float, duration_us : Float) : Float {
    let gain = 2.0 * bandwidth_hz * duration_us * 1.0e-6;
    10.0 * _log10(gain + 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: TARGET CLASSIFICATION
  // Identify target from echo highlight pattern and TS
  // ══════════════════════════════════════════════════════════════════════════

  public func classifyTarget(
    targetStrength_dB : Float,
    highlightPattern  : [Float],
    dopplerVelocity   : Float
  ) : TargetClassification {
    // Fish with swim bladder: TS around -40 to -30 dB, resonance features
    // Fish without swim bladder: TS around -50 to -45 dB
    // Squid: TS around -45 to -35 dB, rapid mantle movement
    // Crab: TS around -30 to -20 dB (hard shell)

    let hasSwimBladder = targetStrength_dB > -40.0 and targetStrength_dB < -25.0;

    let (targetType, prob, estimatedSize) = if (targetStrength_dB > -25.0) {
      (#Crab, 0.7, 0.15)
    } else if (targetStrength_dB > -40.0) {
      (#Fish, 0.8, 0.30)
    } else if (targetStrength_dB > -50.0) {
      (if (_abs(dopplerVelocity) > 1.5) (#Squid : TargetType) else #Fish, 0.6, 0.20)
    } else {
      (#Unknown, 0.4, 0.0)
    };

    {
      targetType    = targetType;
      probability   = prob;
      estimatedSize = estimatedSize;
      swimBladder   = hasSwimBladder;
      targetStrength = targetStrength_dB;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: SCAN PATTERN CONTROL
  // ══════════════════════════════════════════════════════════════════════════

  public func updateScanState(
    scan        : SonarScanState,
    targetDetected : Bool,
    targetRange : Float
  ) : SonarScanState {
    let newPattern : ScanPattern = if (targetDetected and targetRange < 10.0) {
      #Tracking
    } else if (targetDetected) {
      #Foraging
    } else {
      #Foraging
    };

    let newRate = switch newPattern {
      case (#Tracking) { 2000.0 };
      case (#Foraging) { 500.0 };
      case (#Social)   { 100.0 };
      case (#Passive)  { 0.0 };
    };

    let newICI = if (newRate < EPSILON) 1000.0 else 1000.0 / newRate;
    let newAz  = (scan.currentBeamAz + 5.0) mod 360.0;  // scan rotation

    {
      currentBeamAz = newAz;
      currentBeamEl = scan.currentBeamEl;
      scanPattern   = newPattern;
      clickRate     = newRate;
      iciMs         = interClickInterval_ms(targetRange);
      scanComplete  = newAz < 5.0;  // completed one full rotation
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: MEDINA SONAR INDEX
  // D_sonar = S₀ × [range_inv × Φ_M + target_confidence] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func dolphinSonarIndex(range_m : Float, confidence : Float) : Float {
    let rangeInv = _clamp(1.0 - range_m / R_MAX_M, 0.0, 1.0);
    let idx = S0 * (rangeInv * PHI_MEDINA + confidence) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: PROCESS ECHO RETURN
  // Full echo processing pipeline
  // ══════════════════════════════════════════════════════════════════════════

  public func processEchoReturn(
    click         : SonarClick,
    travelTime_us : Float,
    receivedAmp_dB : Float,
    dopplerHz      : Float
  ) : EchoReturn {
    let range = rangeFromTravelTime(travelTime_us);
    let tl    = transmissionLoss(range);
    let ts    = receivedAmp_dB - click.sourceLevel_dB + 2.0 * tl;
    let vel   = velocityFromDoppler(dopplerHz, click.frequency_hz);
    let snr   = signalToNoise_dB(range, ts);
    let conf  = _clamp(snr / 30.0, 0.0, 1.0);  // 30dB → full confidence

    // Highlight pattern (simplified: single highlight for point target)
    let highlights : [Float] = [ts, 0.0, 0.0, 0.0];  // [TS₁, τ₁, TS₂, τ₂]

    {
      travelTime_us    = travelTime_us;
      range_m          = range;
      amplitude_dB     = receivedAmp_dB;
      targetStrength_dB = ts;
      dopplerShift_hz  = dopplerHz;
      targetVelocity   = vel;
      highlightPattern = highlights;
      confidence       = conf;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatDolphin(
    state        : EcholocationState,
    travelTime_us : Float,
    receivedAmp_dB : Float,
    dopplerHz     : Float,
    beamAz_deg    : Float
  ) : EcholocationState {
    let newClick : SonarClick = {
      sourceLevel_dB  = SOURCE_LEVEL_DB;
      frequency_hz    = CLICK_FREQ_HZ;
      duration_us     = CLICK_DURATION_US;
      bandwidth_hz    = CLICK_BANDWIDTH_KHZ * 1000.0;
      beamAzimuth_deg = beamAz_deg;
      beamElev_deg    = 0.0;
      clickNumber     = state.beatNum;
    };

    let echo = processEchoReturn(newClick, travelTime_us, receivedAmp_dB, dopplerHz);
    let classification = classifyTarget(echo.targetStrength_dB, echo.highlightPattern, echo.targetVelocity);
    let detected = echo.confidence > 0.5;
    let sonarIdx = dolphinSonarIndex(echo.range_m, echo.confidence);
    let newScan  = updateScanState(state.scanState, detected, echo.range_m);

    let newRangeH = _appendRolling(state.clickHistory, echo.range_m, HIST_MAX);
    let snr = signalToNoise_dB(echo.range_m, echo.targetStrength_dB);
    let newSnrH = _appendRolling(state.snrHistory, snr, HIST_MAX);

    {
      lastClick      = newClick;
      echoReturns    = [echo];
      classification = classification;
      scanState      = newScan;
      targetDetected = detected;
      targetRange    = echo.range_m;
      targetBearing  = beamAz_deg;
      sonarIndex     = sonarIdx;
      clickHistory   = newRangeH;
      snrHistory     = newSnrH;
      beatNum        = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 13: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  public func initDolphin() : EcholocationState {
    let initClick : SonarClick = {
      sourceLevel_dB=SOURCE_LEVEL_DB; frequency_hz=CLICK_FREQ_HZ;
      duration_us=CLICK_DURATION_US; bandwidth_hz=CLICK_BANDWIDTH_KHZ*1000.0;
      beamAzimuth_deg=0.0; beamElev_deg=0.0; clickNumber=0;
    };
    let initEcho : EchoReturn = {
      travelTime_us=133.0; range_m=100.0; amplitude_dB=60.0;
      targetStrength_dB=(-35.0); dopplerShift_hz=0.0; targetVelocity=0.0;
      highlightPattern=[-35.0,0.0,0.0,0.0]; confidence=0.5;
    };
    let initClass : TargetClassification = {
      targetType=#Fish; probability=0.6; estimatedSize=0.3;
      swimBladder=true; targetStrength=(-35.0);
    };
    let initScan : SonarScanState = {
      currentBeamAz=0.0; currentBeamEl=0.0; scanPattern=#Foraging;
      clickRate=500.0; iciMs=5.0; scanComplete=false;
    };
    {
      lastClick=initClick; echoReturns=[initEcho]; classification=initClass;
      scanState=initScan; targetDetected=false; targetRange=100.0;
      targetBearing=0.0; sonarIndex=0.0; clickHistory=[]; snrHistory=[];
      beatNum=0;
    }
  };

}
