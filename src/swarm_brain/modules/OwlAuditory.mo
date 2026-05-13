// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — OWL AUDITORY SYSTEM
// COMPREHENSIVE BINAURAL SOUND LOCALIZATION AND SPECTRAL ANALYSIS
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — OWL HEARING: MOST PRECISE AUDITORY LOCALIZATION IN NATURE
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: INTERAURAL TIME DIFFERENCE (ITD) ─────────────────────────────────
//   The barn owl can detect sound source azimuth with ~1° precision
//   using ITD = τ = d × sin(θ) / c
//   where: d = inter-ear distance (cm), θ = azimuth angle, c = sound speed (m/s)
//   Barn owl ear separation: d = 1.4 cm (asymmetric skull for vertical resolution)
//   Maximum ITD: τ_max = d/c = 0.014 / 343 = 40.8 μs
//   Neural resolution: Δτ_min = 10 μs (detectable via phase-locking)
//   Angular resolution from ITD: Δθ = Δτ × c / (d × cos θ)
//   At θ=0°: Δθ = 10×10⁻⁶ × 343 / 0.014 ≈ 0.25° (incredible precision)
//   Jeffress model: coincidence detectors fire when signals arrive simultaneously
//   Delay line array: axons of different lengths create range of ITDs
//
// ── LAYER 2: INTERAURAL LEVEL DIFFERENCE (ILD) ─────────────────────────────────
//   ILD = 20 × log₁₀(A_left / A_right)  [decibels]
//   Encodes ELEVATION (vertical angle) in owls
//   Owl's asymmetric ears: left ear higher, right ear lower
//   ILD vs elevation: ILD = ILD_max × sin(φ)  where phi = elevation angle
//   Typical: ILD_max ≈ 30 dB (complete head shadow at high frequencies)
//   ILD increases with frequency: head shadow larger relative to wavelength
//   Neural computation: MSO → LSO → ICX (external nucleus of inferior colliculus)
//   Combined ITD+ILD → 2D sound map in ICX
//
// ── LAYER 3: HEAD-RELATED TRANSFER FUNCTION (HRTF) ────────────────────────────
//   HRTF_L(f, θ, φ) = |H_L(f, θ, φ)|² (power spectrum from left ear)
//   HRTF modifies incident sound based on pinna, head, body geometry
//   Pinna creates frequency-dependent peaks (notches) vs elevation
//   Key notches: first pinna notch at f_notch = c/(2l_pinna) ≈ 8-10 kHz
//   Owl's facial disc: parabolic reflector that focuses sound on ears
//   Gain from disc: G_disc ≈ 10 dB at 8-12 kHz
//   Total spatial sensitivity: S(θ, φ, f) = HRTF_L(f,θ,φ) × HRTF_R(f,θ,φ)
//
// ── LAYER 4: PHASE LOCKING AND COCHLEAR MECHANICS ─────────────────────────────
//   Phase locking: auditory nerve fires preferentially at specific phase of sound
//   Phase lock range: up to 9 kHz in owls (vs 4 kHz in mammals)
//   Vector strength: VS = |Σ exp(i × 2π × f × tₙ)| / N  ∈ [0,1]
//   VS = 1: perfect phase lock, VS = 0: random
//   Basilar membrane resonance: x_BM(f) = L × (1 - log(f/f_apex) / log(f_base/f_apex))
//   Place theory: position x encodes frequency f
//   Owl basilar membrane length: L = 8.5 mm, f_range = 200 Hz - 12 kHz
//   Traveling wave: ∂²y/∂t² = T/ρ × ∂²y/∂x² - b/ρ × ∂y/∂t
//   T = tension, ρ = mass density, b = damping
//
// ── LAYER 5: COINCIDENCE DETECTION — JEFFRESS MODEL ───────────────────────────
//   Binary model: two ears provide input, coincidence detector fires when both arrive
//   Delay line creates systematic ITD mapping:
//   For neuron at delay position Δd:
//   ITD_preferred(Δd) = Δd/v_axon  where v_axon = conduction velocity
//   Firing probability: P(fire) = exp(-|ITD - ITD_preferred|² / (2σ_ITD²))
//   σ_ITD = ITD tuning width ≈ half period of characteristic frequency
//   Population response: r(ITD) = Σᵢ P(fire_i | ITD) × w_i
//   The 2D ITD-ILD map in ICX creates a complete soundscape coordinate system
//
// ── LAYER 6: SPECTRAL ANALYSIS — SHORT-TIME FOURIER TRANSFORM ─────────────────
//   X(k, n) = Σ_{m=0}^{N-1} x(n-m) × w(m) × exp(-i2πkm/N)
//   x = input signal, w = window function, N = FFT size, k = frequency bin
//   Power spectrum: P(k,n) = |X(k,n)|² / N²
//   Mel filterbank: simulate cochlear frequency spacing
//   Mel scale: m = 2595 × log₁₀(1 + f/700)
//   f = 700 × (10^(m/2595) - 1)
//   Triangular filters spaced linearly on mel scale
//   Log power: L(k) = 10 × log₁₀(P(k) + ε)  [dB]
//   MFCC: DCT of log mel filterbank energies
//   c_n = Σ_{k=1}^{K} log(M_k) × cos(π n (k-0.5)/K)
//
// ── LAYER 7: NEURAL SOUND MAP ─────────────────────────────────────────────────
//   Inferior colliculus (ICX): 2D map of space (azimuth × elevation)
//   Each cell has receptive field: RF(θ, φ) = G × exp(-((θ-θ₀)²/2σ_θ² + (φ-φ₀)²/2σ_φ²))
//   G = peak response, θ₀, φ₀ = preferred location, σ = tuning width
//   Population vector code: estimated angle = Σᵢ θᵢ rᵢ / Σᵢ rᵢ
//   Optic tectum: audio-visual alignment
//   Visual RF matched to auditory RF for each cell
//   Alignment requires experience (Hebbian plasticity during development)
//   NOVA: auditory map integrates with visual map for prey localization
//
// ── LAYER 8: MEDINA OWL AUDITORY INDEX ───────────────────────────────────────
//   A_owl = S₀ × [ITD_precision × Φ_M + ILD_precision] / Ω
//   ITD_precision = 1 - Δτ/τ_max ∈ [0,1]  (low = high noise)
//   ILD_precision = 1 - ΔILD/ILD_max ∈ [0,1]
//   A_owl ∈ [0, S₀(Φ_M + 1)/Ω] = [0, 0.441]
//   When A_owl > COHERENCE_ALIVE: auditory sovereignty achieved
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

  // Owl auditory constants
  public let SOUND_SPEED_MS   : Float = 343.0;      // m/s sound speed in air
  public let EAR_SEPARATION_M : Float = 0.014;      // 1.4 cm inter-ear distance
  public let MAX_ITD_US       : Float = 40.8;       // μs maximum ITD
  public let MIN_ITD_US       : Float = 10.0;       // μs minimum detectable ITD
  public let MAX_ILD_DB       : Float = 30.0;       // dB maximum ILD
  public let DISC_GAIN_DB     : Float = 10.0;       // dB facial disc gain
  public let PHASE_LOCK_MAX_HZ: Float = 9000.0;     // Hz max phase locking freq
  public let BASILAR_LENGTH_M : Float = 0.0085;     // 8.5mm basilar membrane
  public let F_APEX_HZ        : Float = 200.0;      // Hz apex (low freq)
  public let F_BASE_HZ        : Float = 12000.0;    // Hz base (high freq)

  // Spectral analysis
  public let N_FFT            : Nat   = 512;        // FFT size
  public let N_MEL_FILTERS    : Nat   = 40;         // mel filterbank channels
  public let N_MFCC           : Nat   = 13;         // MFCC coefficients
  public let MEL_F_MIN        : Float = 200.0;      // Hz minimum mel frequency
  public let MEL_F_MAX        : Float = 12000.0;    // Hz maximum mel frequency

  // Neural map
  public let N_AZ_CELLS       : Nat   = 36;         // azimuth cells (10° spacing)
  public let N_EL_CELLS       : Nat   = 18;         // elevation cells (10° spacing)
  public let N_MAP_CELLS      : Nat   = 648;        // 36 × 18 total map cells
  public let AZ_TUNING_DEG    : Float = 8.0;        // azimuth tuning width σ
  public let EL_TUNING_DEG    : Float = 10.0;       // elevation tuning width σ

  // ITD delay line
  public let N_COINCIDENCE    : Nat   = 64;         // coincidence detector neurons
  public let ITD_SIGMA_US     : Float = 15.0;       // ITD tuning width μs

  public let HIST_MAX         : Nat   = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type BinauraSignal = {
    leftAmplitude  : Float;    // dB SPL
    rightAmplitude : Float;    // dB SPL
    leftPhase      : Float;    // radians (at characteristic frequency)
    rightPhase     : Float;
    frequency      : Float;    // Hz center frequency
    itd_us         : Float;    // interaural time difference μs
    ild_db         : Float;    // interaural level difference dB
  };

  public type SoundLocation = {
    azimuth_deg    : Float;    // θ horizontal angle (0=front, +right)
    elevation_deg  : Float;    // phi vertical angle (+up)
    distance_m     : Float;    // estimated distance
    confidence     : Float;    // [0,1] localization confidence
    itdEstimate    : Float;    // ITD used for azimuth
    ildEstimate    : Float;    // ILD used for elevation
  };

  public type SpectralAnalysis = {
    powerSpectrum  : [Float];  // N_FFT/2 power values (dB)
    melFilterbank  : [Float];  // N_MEL_FILTERS energies
    mfcc           : [Float];  // N_MFCC coefficients
    dominantFreq   : Float;    // Hz peak frequency
    spectralCentroid : Float;  // Hz spectral center of mass
    spectralFlux   : Float;    // frame-to-frame spectral change
    logEnergy      : Float;    // total log energy dB
  };

  public type NeuralAuditoryMap = {
    responses      : [Float];  // N_MAP_CELLS firing rates
    peakAzimuth    : Float;    // azimuth of peak activity (degrees)
    peakElevation  : Float;    // elevation of peak activity (degrees)
    mapEntropy     : Float;    // Shannon entropy of map (diffuse vs focal)
    spatialConfidence : Float; // how well-localized is the target
  };

  public type CoincidenceDetectors = {
    responses      : [Float];  // N_COINCIDENCE responses
    peakITD_us     : Float;    // ITD with maximum coincidence
    peakIdx        : Nat;      // index of peak coincidence neuron
    vectorStrength : Float;    // VS measure of phase locking
  };

  public type OwlAuditoryState = {
    left           : BinauraSignal;
    right          : BinauraSignal;
    location       : SoundLocation;
    spectrum       : SpectralAnalysis;
    neuralMap      : NeuralAuditoryMap;
    coincidence    : CoincidenceDetectors;
    owlAudIndex    : Float;   // A_owl sovereign index
    detectionFlag  : Bool;    // prey detected?
    alertLevel     : Float;   // [0,1]
    spectrumHistory : [Float];
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
  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };

  func _gaussianResponse(x : Float, x0 : Float, sigma : Float) : Float {
    if (sigma < EPSILON) { if (_abs(x - x0) < EPSILON) 1.0 else 0.0 }
    else { _exp(-((x - x0) * (x - x0)) / (2.0 * sigma * sigma)) }
  };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: ITD AND ILD COMPUTATION
  // ══════════════════════════════════════════════════════════════════════════

  // Theoretical ITD for given azimuth
  // τ = d × sin(θ) / c  [seconds → μs via ×10⁶]
  public func theoreticalITD_us(azimuth_deg : Float) : Float {
    let theta = azimuth_deg * PI / 180.0;
    EAR_SEPARATION_M * _sin(theta) / SOUND_SPEED_MS * 1.0e6
  };

  // Azimuth from measured ITD
  // θ = arcsin(τ × c / d)
  public func azimuthFromITD(itd_us : Float) : Float {
    let itd_s = itd_us * 1.0e-6;
    let sinTheta = itd_s * SOUND_SPEED_MS / EAR_SEPARATION_M;
    if (_abs(sinTheta) > 1.0) {
      if (sinTheta > 0.0) 90.0 else -90.0
    } else {
      Float.arctan2(sinTheta, _sqrt(1.0 - sinTheta * sinTheta)) * 180.0 / PI
    }
  };

  // ILD from amplitude difference
  // ILD = 20 log₁₀(A_L / A_R) [dB]
  public func computeILD_dB(ampLeft_dB : Float, ampRight_dB : Float) : Float {
    ampLeft_dB - ampRight_dB
  };

  // Elevation from ILD
  // phi = arcsin(ILD / ILD_max)
  public func elevationFromILD(ild_db : Float) : Float {
    let sinPhi = _clamp(ild_db / MAX_ILD_DB, -1.0, 1.0);
    Float.arctan2(sinPhi, _sqrt(1.0 - sinPhi * sinPhi)) * 180.0 / PI
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: COINCIDENCE DETECTION (JEFFRESS MODEL)
  // P(fire_i) = exp(-|ITD - ITD_pref_i|² / (2σ_ITD²))
  // ══════════════════════════════════════════════════════════════════════════

  // Preferred ITD for coincidence detector i (evenly spaced delay line)
  public func preferredITD(idx : Nat) : Float {
    let n = Float.fromInt(N_COINCIDENCE);
    let i = Float.fromInt(idx);
    -MAX_ITD_US + (2.0 * MAX_ITD_US * i / (n - 1.0))
  };

  // Compute coincidence detector population response
  public func computeCoincidenceDetectors(itd_us : Float, leftSignal : Float) : CoincidenceDetectors {
    let responses = Array.tabulate<Float>(N_COINCIDENCE, func(i) {
      let itdPref = preferredITD(i);
      leftSignal * _gaussianResponse(itd_us, itdPref, ITD_SIGMA_US)
    });

    // Find peak
    var maxR : Float = 0.0;
    var maxIdx : Nat = 0;
    var i : Nat = 0;
    while (i < responses.size()) {
      if (responses[i] > maxR) { maxR := responses[i]; maxIdx := i };
      i += 1;
    };

    // Vector strength (phase locking measure)
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var total  : Float = 0.0;
    i := 0;
    while (i < responses.size()) {
      let angle = TWO_PI * Float.fromInt(i) / Float.fromInt(N_COINCIDENCE);
      sumCos += responses[i] * _cos(angle);
      sumSin += responses[i] * _sin(angle);
      total  += responses[i];
      i += 1;
    };
    let vs = if (total < EPSILON) 0.0 else _sqrt(sumCos * sumCos + sumSin * sumSin) / total;

    {
      responses      = responses;
      peakITD_us     = preferredITD(maxIdx);
      peakIdx        = maxIdx;
      vectorStrength = _clamp(vs, 0.0, 1.0);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: SPECTRAL ANALYSIS
  // Mel filterbank and MFCC computation
  // ══════════════════════════════════════════════════════════════════════════

  // Frequency to mel scale: m = 2595 × log₁₀(1 + f/700)
  public func hzToMel(f_hz : Float) : Float {
    2595.0 * _log10(1.0 + f_hz / 700.0)
  };

  // Mel to frequency: f = 700 × (10^(m/2595) - 1)
  public func melToHz(m_mel : Float) : Float {
    700.0 * (_exp(m_mel / 1127.0) - 1.0)  // using natural log form
  };

  // Mel filterbank response for channel k at frequency f
  // Triangular filters spaced linearly on mel scale
  public func melFilterResponse(f_hz : Float, channelIdx : Nat) : Float {
    let n = Float.fromInt(N_MEL_FILTERS);
    let k = Float.fromInt(channelIdx);
    let mMin = hzToMel(MEL_F_MIN);
    let mMax = hzToMel(MEL_F_MAX);
    let dm   = (mMax - mMin) / (n + 1.0);
    let mk   = mMin + (k + 1.0) * dm;
    let mk_1 = mMin + k * dm;
    let mk1  = mMin + (k + 2.0) * dm;
    let m    = hzToMel(f_hz);
    if (m < mk_1 or m > mk1) { return 0.0 };
    if (m <= mk) {
      (m - mk_1) / (mk - mk_1)
    } else {
      (mk1 - m) / (mk1 - mk)
    }
  };

  // Spectral centroid: f_c = Σ f × P(f) / Σ P(f)
  public func spectralCentroid(powerSpec : [Float], freqBins : [Float]) : Float {
    var numSum : Float = 0.0;
    var denSum : Float = 0.0;
    let n = if (powerSpec.size() < freqBins.size()) powerSpec.size() else freqBins.size();
    var i : Nat = 0;
    while (i < n) {
      numSum += freqBins[i] * powerSpec[i];
      denSum += powerSpec[i];
      i += 1;
    };
    if (denSum < EPSILON) { return 0.0 };
    numSum / denSum
  };

  // Apply N mel filters to power spectrum (simplified: use filter center response)
  public func applyMelFilterbank(powerSpec : [Float]) : [Float] {
    let n_fft_half = powerSpec.size();
    Array.tabulate<Float>(N_MEL_FILTERS, func(k) {
      var energy : Float = 0.0;
      var i : Nat = 0;
      while (i < n_fft_half) {
        // Map FFT bin to frequency
        let f = MEL_F_MIN + (MEL_F_MAX - MEL_F_MIN) * Float.fromInt(i) / Float.fromInt(n_fft_half);
        let response = melFilterResponse(f, k);
        energy += powerSpec[i] * response;
        i += 1;
      };
      _clamp(_log10(energy + EPSILON) * 10.0, -100.0, 100.0)  // log energy dB
    })
  };

  // DCT for MFCC: c_n = Σ_{k=1}^{K} log(M_k) × cos(π n (k-0.5)/K)
  public func computeMFCC(melEnergies : [Float]) : [Float] {
    let K = Float.fromInt(melEnergies.size());
    Array.tabulate<Float>(N_MFCC, func(n) {
      let nf = Float.fromInt(n);
      var sum : Float = 0.0;
      var k : Nat = 0;
      while (k < melEnergies.size()) {
        let kf = Float.fromInt(k + 1);
        sum += melEnergies[k] * _cos(PI * nf * (kf - 0.5) / K);
        k += 1;
      };
      sum
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: NEURAL AUDITORY MAP
  // 36×18 cells in ICX (azimuth × elevation)
  // Each cell: Gaussian receptive field in azimuth and elevation
  // ══════════════════════════════════════════════════════════════════════════

  // Cell index from azimuth/elevation indices
  public func cellIndex(azIdx : Nat, elIdx : Nat) : Nat {
    azIdx * N_EL_CELLS + elIdx
  };

  // Preferred azimuth for cell at azimuth index i (10° spacing, -175 to +175)
  public func preferredAzimuth(azIdx : Nat) : Float {
    -175.0 + Float.fromInt(azIdx) * 10.0
  };

  // Preferred elevation for cell at elevation index i (10° spacing, -85 to +85)
  public func preferredElevation(elIdx : Nat) : Float {
    -85.0 + Float.fromInt(elIdx) * 10.0
  };

  // Neural map response for target at (az, el) degrees
  public func computeNeuralMap(az_deg : Float, el_deg : Float, signalStrength : Float) : NeuralAuditoryMap {
    let responses = Array.tabulate<Float>(N_MAP_CELLS, func(cellIdx) {
      let azIdx = cellIdx / N_EL_CELLS;
      let elIdx = cellIdx mod N_EL_CELLS;
      let prefAz = preferredAzimuth(azIdx);
      let prefEl = preferredElevation(elIdx);
      let azR = _gaussianResponse(az_deg, prefAz, AZ_TUNING_DEG);
      let elR = _gaussianResponse(el_deg, prefEl, EL_TUNING_DEG);
      signalStrength * azR * elR
    });

    // Find peak cell
    var maxR : Float = 0.0;
    var maxAzIdx : Nat = 0;
    var maxElIdx : Nat = 0;
    var i : Nat = 0;
    while (i < responses.size()) {
      if (responses[i] > maxR) {
        maxR := responses[i];
        maxAzIdx := i / N_EL_CELLS;
        maxElIdx := i mod N_EL_CELLS;
      };
      i += 1;
    };

    // Shannon entropy of map
    var totalR : Float = 0.0;
    for (r in responses.vals()) { totalR += r };
    var entropy : Float = 0.0;
    if (totalR > EPSILON) {
      for (r in responses.vals()) {
        let p = r / totalR;
        if (p > EPSILON) { entropy -= p * Float.log(p) };
      };
    };
    // Max possible entropy = ln(N_MAP_CELLS)
    let maxH = Float.log(Float.fromInt(N_MAP_CELLS));
    let spatialConf = if (maxH < EPSILON) 0.0 else 1.0 - entropy / maxH;

    {
      responses         = responses;
      peakAzimuth       = preferredAzimuth(maxAzIdx);
      peakElevation     = preferredElevation(maxElIdx);
      mapEntropy        = entropy;
      spatialConfidence = _clamp(spatialConf, 0.0, 1.0);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: SOUND LOCALIZATION
  // Combine ITD→azimuth and ILD→elevation
  // ══════════════════════════════════════════════════════════════════════════

  public func localizeSound(binaural : BinauraSignal) : SoundLocation {
    let az = azimuthFromITD(binaural.itd_us);
    let el = elevationFromILD(binaural.ild_db);
    // Distance estimated from amplitude (inverse square law)
    // I = P / (4πr²) → r = √(P / (4πI))
    let refAmplitude_dB = 94.0;  // reference at 1m
    let ampAvg = (binaural.leftAmplitude + binaural.rightAmplitude) / 2.0;
    let dist = Float.exp((refAmplitude_dB - ampAvg) * Float.log(10.0) / 20.0);

    // Confidence: how precise is each cue?
    let itdPrec = _clamp(1.0 - _abs(binaural.itd_us) / MAX_ITD_US, 0.0, 1.0);
    let ildPrec = _clamp(1.0 - _abs(binaural.ild_db) / MAX_ILD_DB, 0.0, 1.0);
    let conf    = (itdPrec + ildPrec) / 2.0;

    {
      azimuth_deg  = _clamp(az, -180.0, 180.0);
      elevation_deg = _clamp(el, -90.0, 90.0);
      distance_m   = _clamp(dist, 0.01, 1000.0);
      confidence   = conf;
      itdEstimate  = binaural.itd_us;
      ildEstimate  = binaural.ild_db;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: MEDINA OWL AUDITORY INDEX
  // A_owl = S₀ × [ITD_precision × Φ_M + ILD_precision] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func owlAudIndex(itd_us : Float, ild_db : Float) : Float {
    let itdPrec = _clamp(1.0 - _abs(itd_us) / MAX_ITD_US, 0.0, 1.0);
    let ildPrec = _clamp(1.0 - _abs(ild_db) / MAX_ILD_DB, 0.0, 1.0);
    let idx = S0 * (itdPrec * PHI_MEDINA + ildPrec) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatOwlAuditory(
    state         : OwlAuditoryState,
    leftAmp_dB    : Float,
    rightAmp_dB   : Float,
    leftPhase_rad : Float,
    rightPhase_rad: Float,
    frequency_hz  : Float,
    powerSpectrum : [Float]
  ) : OwlAuditoryState {
    let itd = (leftPhase_rad - rightPhase_rad) / (TWO_PI * frequency_hz) * 1.0e6;  // μs
    let ild = computeILD_dB(leftAmp_dB, rightAmp_dB);

    let newLeft : BinauraSignal = {
      leftAmplitude  = leftAmp_dB;
      rightAmplitude = rightAmp_dB;
      leftPhase      = leftPhase_rad;
      rightPhase     = rightPhase_rad;
      frequency      = frequency_hz;
      itd_us         = itd;
      ild_db         = ild;
    };

    let newLoc = localizeSound(newLeft);
    let avgAmp = (leftAmp_dB + rightAmp_dB) / 2.0;

    // Mel filterbank
    let melEnergy = applyMelFilterbank(powerSpectrum);
    let mfcc      = computeMFCC(melEnergy);

    // Dominant frequency
    var maxP : Float = 0.0;
    var maxBin : Nat = 0;
    var bi : Nat = 0;
    while (bi < powerSpectrum.size()) {
      if (powerSpectrum[bi] > maxP) { maxP := powerSpectrum[bi]; maxBin := bi };
      bi += 1;
    };
    let domFreq = MEL_F_MIN + (MEL_F_MAX - MEL_F_MIN) * Float.fromInt(maxBin) / Float.fromInt(powerSpectrum.size());

    let newSpec : SpectralAnalysis = {
      powerSpectrum    = powerSpectrum;
      melFilterbank    = melEnergy;
      mfcc             = mfcc;
      dominantFreq     = domFreq;
      spectralCentroid = domFreq;  // simplified
      spectralFlux     = 0.0;
      logEnergy        = _log10(maxP + EPSILON) * 10.0;
    };

    let newCoinc   = computeCoincidenceDetectors(itd, avgAmp / 100.0);
    let newMap     = computeNeuralMap(newLoc.azimuth_deg, newLoc.elevation_deg, avgAmp / 100.0);
    let newIdx     = owlAudIndex(itd, ild);
    let detected   = avgAmp > 40.0 and newLoc.confidence > 0.5;
    let alertLvl   = _clamp(avgAmp / 100.0, 0.0, 1.0);

    let newSpecHist = _appendRolling(state.spectrumHistory, newSpec.logEnergy, HIST_MAX);

    {
      left           = newLeft;
      right          = { newLeft with leftAmplitude = rightAmp_dB };
      location       = newLoc;
      spectrum       = newSpec;
      neuralMap      = newMap;
      coincidence    = newCoinc;
      owlAudIndex    = newIdx;
      detectionFlag  = detected;
      alertLevel     = alertLvl;
      spectrumHistory = newSpecHist;
      beatNum        = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  public func initOwlAuditory() : OwlAuditoryState {
    let initBin : BinauraSignal = {
      leftAmplitude=30.0; rightAmplitude=30.0; leftPhase=0.0; rightPhase=0.0;
      frequency=2000.0; itd_us=0.0; ild_db=0.0;
    };
    let flatSpec = Array.tabulate<Float>(N_FFT / 2, func(_) { 0.001 });
    let initLoc : SoundLocation = {
      azimuth_deg=0.0; elevation_deg=0.0; distance_m=10.0; confidence=0.5;
      itdEstimate=0.0; ildEstimate=0.0;
    };
    let initSpec : SpectralAnalysis = {
      powerSpectrum=flatSpec; melFilterbank=Array.tabulate<Float>(N_MEL_FILTERS, func(_) {0.0});
      mfcc=Array.tabulate<Float>(N_MFCC, func(_) {0.0});
      dominantFreq=2000.0; spectralCentroid=2000.0; spectralFlux=0.0; logEnergy=30.0;
    };
    let initMap : NeuralAuditoryMap = {
      responses=Array.tabulate<Float>(N_MAP_CELLS, func(_) {0.0});
      peakAzimuth=0.0; peakElevation=0.0; mapEntropy=6.0; spatialConfidence=0.5;
    };
    let initCoinc : CoincidenceDetectors = {
      responses=Array.tabulate<Float>(N_COINCIDENCE, func(_) {0.0});
      peakITD_us=0.0; peakIdx=N_COINCIDENCE/2; vectorStrength=0.5;
    };
    {
      left=initBin; right=initBin; location=initLoc; spectrum=initSpec;
      neuralMap=initMap; coincidence=initCoinc; owlAudIndex=0.0;
      detectionFlag=false; alertLevel=0.0; spectrumHistory=[]; beatNum=0;
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
  //  A N I M A L   I N T E L L I G E N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Biomimetic Cognitive Algorithms
  //  Full HIM/HER Integration with Animal Brain Dynamics
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SWARM INTELLIGENCE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reynolds flocking: Separation force
  public func animalSeparationForce(
    position : (Float, Float),
    neighbors : [(Float, Float)],
    separationRadius : Float
  ) : (Float, Float) {
    var forceX : Float = 0.0;
    var forceY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      let dx = position.0 - nx;
      let dy = position.1 - ny;
      let dist = Float.sqrt(dx * dx + dy * dy);
      if (dist > 0.0001 and dist < separationRadius) {
        let strength = (separationRadius - dist) / separationRadius;
        forceX += (dx / dist) * strength;
        forceY += (dy / dist) * strength;
      };
      i += 1;
    };
    (forceX, forceY)
  };

  /// Reynolds flocking: Alignment force
  public func animalAlignmentForce(
    velocity : (Float, Float),
    neighborVelocities : [(Float, Float)]
  ) : (Float, Float) {
    if (neighborVelocities.size() == 0) { return (0.0, 0.0) };
    var avgVx : Float = 0.0;
    var avgVy : Float = 0.0;
    var i = 0;
    while (i < neighborVelocities.size()) {
      let (vx, vy) = neighborVelocities[i];
      avgVx += vx;
      avgVy += vy;
      i += 1;
    };
    let n = Float.fromInt(neighborVelocities.size());
    avgVx /= n;
    avgVy /= n;
    (avgVx - velocity.0, avgVy - velocity.1)
  };

  /// Reynolds flocking: Cohesion force
  public func animalCohesionForce(
    position : (Float, Float),
    neighbors : [(Float, Float)]
  ) : (Float, Float) {
    if (neighbors.size() == 0) { return (0.0, 0.0) };
    var centerX : Float = 0.0;
    var centerY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      centerX += nx;
      centerY += ny;
      i += 1;
    };
    let n = Float.fromInt(neighbors.size());
    centerX /= n;
    centerY /= n;
    (centerX - position.0, centerY - position.1)
  };

  /// Ant colony pheromone update
  public func animalPheromoneUpdate(
    current : Float,
    deposit : Float,
    evaporationRate : Float,
    dt : Float
  ) : Float {
    (current + deposit) * (1.0 - evaporationRate * dt)
  };

  /// Ant path probability
  public func animalAntPathProbability(
    pheromone : Float,
    distance : Float,
    alpha : Float,
    beta : Float
  ) : Float {
    let pheromoneFactor = Float.pow(pheromone + 0.01, alpha);
    let distanceFactor = Float.pow(1.0 / (distance + 0.01), beta);
    pheromoneFactor * distanceFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ECHOLOCATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Doppler shift for moving target
  public func animalDopplerShift(
    emittedFreq : Float,
    targetVelocity : Float,
    soundSpeed : Float
  ) : Float {
    emittedFreq * (soundSpeed + targetVelocity) / soundSpeed
  };

  /// Echo time-of-flight to distance
  public func animalEchoDistance(timeOfFlight : Float, soundSpeed : Float) : Float {
    (timeOfFlight * soundSpeed) / 2.0
  };

  /// Echo intensity decay
  public func animalEchoIntensity(
    sourceIntensity : Float,
    distance : Float,
    attenuation : Float
  ) : Float {
    sourceIntensity * Float.exp(-attenuation * distance) / (distance * distance + 0.01)
  };

  /// Azimuth from interaural time difference
  public func animalAzimuthFromITD(itd : Float, headRadius : Float, soundSpeed : Float) : Float {
    Float.asin(itd * soundSpeed / headRadius)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VISUAL PROCESSING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Retinal ganglion cell receptive field (DoG)
  public func animalDoGReceptiveField(
    x : Float,
    y : Float,
    sigmaCenter : Float,
    sigmaSurround : Float,
    centerStrength : Float,
    surroundStrength : Float
  ) : Float {
    let rSquared = x * x + y * y;
    let center = centerStrength * Float.exp(-rSquared / (2.0 * sigmaCenter * sigmaCenter));
    let surround = surroundStrength * Float.exp(-rSquared / (2.0 * sigmaSurround * sigmaSurround));
    center - surround
  };

  /// Gabor filter response
  public func animalGaborResponse(
    x : Float,
    y : Float,
    wavelength : Float,
    orientation : Float,
    sigma : Float,
    aspectRatio : Float
  ) : Float {
    let xTheta = x * Float.cos(orientation) + y * Float.sin(orientation);
    let yTheta = -x * Float.sin(orientation) + y * Float.cos(orientation);
    let gaussian = Float.exp(-(xTheta * xTheta + aspectRatio * aspectRatio * yTheta * yTheta) / (2.0 * sigma * sigma));
    let sinusoid = Float.cos(2.0 * 3.14159265 * xTheta / wavelength);
    gaussian * sinusoid
  };

  /// Motion energy from V1 simple cells
  public func animalMotionEnergy(
    leftwardResponse : Float,
    rightwardResponse : Float
  ) : Float {
    leftwardResponse * leftwardResponse - rightwardResponse * rightwardResponse
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Magnetic field sensing (magnetoreception)
  public func animalMagneticHeading(
    fieldX : Float,
    fieldY : Float
  ) : Float {
    Float.atan2(fieldY, fieldX)
  };

  /// Polarized light sensing
  public func animalPolarizationAngle(
    intensity0 : Float,
    intensity45 : Float,
    intensity90 : Float
  ) : Float {
    0.5 * Float.atan2(intensity45 - intensity90, intensity0 - intensity90)
  };

  /// Path integration
  public func animalPathIntegration(
    currentX : Float,
    currentY : Float,
    velocity : Float,
    heading : Float,
    dt : Float
  ) : (Float, Float) {
    let dx = velocity * Float.cos(heading) * dt;
    let dy = velocity * Float.sin(heading) * dt;
    (currentX + dx, currentY + dy)
  };

  /// Grid cell firing pattern
  public func animalGridCellFiring(
    x : Float,
    y : Float,
    gridSpacing : Float,
    gridOrientation : Float
  ) : Float {
    let theta1 : Float = gridOrientation;
    let theta2 : Float = gridOrientation + 1.0472;  // +60 degrees
    let theta3 : Float = gridOrientation + 2.0944;  // +120 degrees
    let k = 4.0 * 3.14159265 / (gridSpacing * Float.sqrt(3.0));
    let u1 = Float.cos(k * (x * Float.cos(theta1) + y * Float.sin(theta1)));
    let u2 = Float.cos(k * (x * Float.cos(theta2) + y * Float.sin(theta2)));
    let u3 = Float.cos(k * (x * Float.cos(theta3) + y * Float.sin(theta3)));
    (u1 + u2 + u3) / 3.0
  };

  /// Place cell firing
  public func animalPlaceCellFiring(
    x : Float,
    y : Float,
    centerX : Float,
    centerY : Float,
    fieldRadius : Float
  ) : Float {
    let dx = x - centerX;
    let dy = y - centerY;
    let distSquared = dx * dx + dy * dy;
    Float.exp(-distSquared / (2.0 * fieldRadius * fieldRadius))
  };

  /// Head direction cell
  public func animalHeadDirectionFiring(
    currentHeading : Float,
    preferredHeading : Float,
    tuningWidth : Float
  ) : Float {
    let diff = currentHeading - preferredHeading;
    Float.exp(-diff * diff / (2.0 * tuningWidth * tuningWidth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DECISION MAKING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Drift-diffusion model
  public func animalDriftDiffusion(
    evidence : Float,
    drift : Float,
    noise : Float,
    threshold : Float,
    dt : Float
  ) : (Float, Bool) {
    let newEvidence = evidence + drift * dt + noise * Float.sqrt(dt);
    let decided = Float.abs(newEvidence) >= threshold;
    (newEvidence, decided)
  };

  /// Winner-take-all competition
  public func animalWinnerTakeAll(
    activities : [Float],
    inhibition : Float
  ) : [Float] {
    var maxActivity : Float = 0.0;
    var i = 0;
    while (i < activities.size()) {
      if (activities[i] > maxActivity) { maxActivity := activities[i] };
      i += 1;
    };
    Array.tabulate<Float>(activities.size(), func(j : Nat) : Float {
      let diff = activities[j] - maxActivity;
      if (diff < -inhibition) { 0.0 } else { activities[j] }
    })
  };

  /// Urgency signal
  public func animalUrgencySignal(time : Float, gain : Float, offset : Float) : Float {
    offset + gain * time
  };

}
