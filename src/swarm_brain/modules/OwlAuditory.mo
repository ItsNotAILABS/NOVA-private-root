// ============================================================
// OWL AUDITORY — 3D SOUND LOCALIZATION MODULE
// Asymmetric ears: left higher than right
// Microsecond timing resolution (10 microseconds)
// Facial disc as acoustic dish
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let SPEED_OF_SOUND : Float = 343.0;     // m/s in air
  let HEAD_WIDTH : Float = 0.1;           // meters (10cm)
  let MAX_ITD : Float = 0.0003;           // max interaural time difference (300 μs)
  let FREQUENCY_BANDS : Nat = 8;          // Frequency analysis bands

  // ── Types ─────────────────────────────────────────────────────
  public type AuditoryInput = {
    leftEar       : [Float];    // 8 frequency bands
    rightEar      : [Float];    // 8 frequency bands
    leftTiming    : Float;      // Arrival time (ms)
    rightTiming   : Float;      // Arrival time (ms)
  };

  public type SoundSource = {
    id            : Nat;
    azimuth       : Float;      // Horizontal angle (-180 to 180)
    elevation     : Float;      // Vertical angle (-90 to 90)
    distance      : Float;      // Estimated distance (meters)
    intensity     : Float;      // Sound level
    frequency     : Float;      // Dominant frequency
    confidence    : Float;      // Localization certainty
    velocity      : Float;      // Movement in space
    lastUpdate    : Nat;
  };

  public type AuditoryMap = {
    cells         : [Float];    // 32x16 azimuth-elevation grid (512 cells)
    peakAzimuth   : Float;
    peakElevation : Float;
    mapConfidence : Float;
  };

  public type HeadPosition = {
    azimuth       : Float;      // Head orientation horizontal
    elevation     : Float;      // Head orientation vertical
    facialDiscAngle: Float;     // Acoustic disc aim
  };

  public type OwlState = {
    // Ear processing
    leftSpectrum    : [Float];   // Current left frequency analysis
    rightSpectrum   : [Float];   // Current right frequency analysis
    interauralTime  : Float;     // ITD (interaural time difference)
    interauralLevel : Float;     // ILD (interaural level difference)

    // Sound localization
    trackedSources  : [SoundSource];
    primarySource   : ?Nat;
    auditoryMap     : AuditoryMap;

    // Head control
    headPosition    : HeadPosition;
    headTrackTarget : ?Nat;       // Source index being tracked
    headMovement    : Float;      // Recent head motion

    // Attention
    auditoryFocus   : Float;      // How much attention on hearing
    visualAuditory  : Float;      // Balance between modalities

    // Prey detection
    preyLikelihood  : Float;      // Probability sound is prey
    rustleDetection : Float;      // Leaf/grass rustle detection
    squeakDetection : Float;      // High-frequency squeak detection

    // Ambient noise
    noiseFloor      : Float;      // Background noise level
    snr             : Float;      // Signal to noise ratio

    beatNum         : Nat;
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  // ── Interaural Time Difference ────────────────────────────────
  // Convert ITD to azimuth angle
  public func itdToAzimuth(itd: Float) : Float {
    // ITD = d * sin(θ) / c, where d is head width
    // θ = arcsin(ITD * c / d)
    let ratio = _clamp(itd * SPEED_OF_SOUND / HEAD_WIDTH, -1.0, 1.0);
    // Approximate arcsin using polynomial
    let azimuth = ratio * 90.0;  // Simplified linear mapping
    azimuth
  };

  // ── Interaural Level Difference ───────────────────────────────
  // Higher frequencies have greater ILD (head shadow effect)
  public func computeILD(leftSpectrum: [Float], rightSpectrum: [Float]) : Float {
    var leftTotal : Float = 0.0;
    var rightTotal : Float = 0.0;

    // Weight higher frequencies more (head shadow is frequency-dependent)
    var i = 0;
    while (i < FREQUENCY_BANDS and i < leftSpectrum.size() and i < rightSpectrum.size()) {
      let weight = 1.0 + Float.fromInt(i) * 0.3;  // Higher bands weighted more
      leftTotal += leftSpectrum[i] * weight;
      rightTotal += rightSpectrum[i] * weight;
      i += 1;
    };

    if (leftTotal + rightTotal > 0.0) {
      (leftTotal - rightTotal) / (leftTotal + rightTotal)
    } else { 0.0 }
  };

  // ── Elevation from Asymmetric Ears ────────────────────────────
  // Owl ears are asymmetric: left ear points up, right ear points down
  // This creates elevation-dependent ILD patterns
  public func ildToElevation(ild: Float, highFreqRatio: Float) : Float {
    // Positive ILD (louder in left) = sound from above (left ear aims up)
    // Negative ILD (louder in right) = sound from below
    // High frequencies are more direction-sensitive
    let elevationSensitivity = highFreqRatio * 90.0;
    _clamp(ild * elevationSensitivity, -90.0, 90.0)
  };

  // ── Distance Estimation ───────────────────────────────────────
  public func estimateDistance(intensity: Float, frequency: Float) : Float {
    // Inverse square law: intensity ∝ 1/d²
    // Higher frequencies attenuate faster
    let freqAttenuation = 1.0 + frequency * 0.001;
    let distance = Float.sqrt(1.0 / (intensity * freqAttenuation + 0.01));
    _clamp(distance, 0.1, 100.0)
  };

  // ── Source Localization ───────────────────────────────────────
  public func localizeSoundSource(
    input: AuditoryInput, noiseFloor: Float
  ) : ?SoundSource {
    // Check if there's a significant sound above noise
    var leftEnergy : Float = 0.0;
    var rightEnergy : Float = 0.0;
    var peakFreq : Nat = 0;
    var peakEnergy : Float = 0.0;

    var i = 0;
    while (i < FREQUENCY_BANDS and i < input.leftEar.size()) {
      leftEnergy += input.leftEar[i];
      if (i < input.rightEar.size()) {
        rightEnergy += input.rightEar[i];
      };
      let bandEnergy = input.leftEar[i] + (if (i < input.rightEar.size()) { input.rightEar[i] } else { 0.0 });
      if (bandEnergy > peakEnergy) {
        peakEnergy := bandEnergy;
        peakFreq := i;
      };
      i += 1;
    };

    let totalEnergy = (leftEnergy + rightEnergy) / 2.0;
    if (totalEnergy < noiseFloor * 1.5) {
      return null;  // Below detection threshold
    };

    // Compute ITD (time difference)
    let itd = input.leftTiming - input.rightTiming;
    let azimuth = itdToAzimuth(itd);

    // Compute ILD
    let ild = computeILD(input.leftEar, input.rightEar);

    // Compute high frequency ratio for elevation
    let highFreqRatio = if (input.leftEar.size() >= 6 and input.rightEar.size() >= 6) {
      (input.leftEar[5] + input.leftEar[6] + input.leftEar[7] +
       input.rightEar[5] + input.rightEar[6] + input.rightEar[7]) /
      (totalEnergy * 2.0 + 0.01)
    } else { 0.5 };

    let elevation = ildToElevation(ild, highFreqRatio);

    // Estimate distance
    let frequency = Float.fromInt(peakFreq) * 1000.0 + 500.0;  // Map band to Hz
    let distance = estimateDistance(totalEnergy, frequency);

    // Confidence based on signal strength and ITD consistency
    let confidence = _clamp(
      (totalEnergy - noiseFloor) / noiseFloor * 0.5,
      0.0, 1.0
    );

    ?{
      id = 0;
      azimuth = azimuth;
      elevation = elevation;
      distance = distance;
      intensity = totalEnergy;
      frequency = frequency;
      confidence = confidence;
      velocity = 0.0;
      lastUpdate = 0;
    }
  };

  // ── Update Auditory Map ───────────────────────────────────────
  public func updateAuditoryMap(
    map: AuditoryMap, sources: [SoundSource]
  ) : AuditoryMap {
    var newCells = Array.thaw<Float>(map.cells);

    // Decay all cells
    var i = 0;
    while (i < 512) {
      newCells[i] := map.cells[i] * 0.9;
      i += 1;
    };

    // Add source contributions
    var peakVal : Float = 0.0;
    var peakAz : Float = 0.0;
    var peakEl : Float = 0.0;

    for (s in sources.vals()) {
      // Convert angles to grid indices
      // Azimuth: -180 to 180 → 0 to 31
      // Elevation: -90 to 90 → 0 to 15
      let azIdx = Nat.min(31, Int.abs(Float.toInt((s.azimuth + 180.0) / 11.25)));
      let elIdx = Nat.min(15, Int.abs(Float.toInt((s.elevation + 90.0) / 11.25)));
      let cellIdx = elIdx * 32 + azIdx;

      if (cellIdx < 512) {
        let newVal = _clamp(newCells[cellIdx] + s.confidence * s.intensity, 0.0, 1.0);
        newCells[cellIdx] := newVal;

        if (newVal > peakVal) {
          peakVal := newVal;
          peakAz := s.azimuth;
          peakEl := s.elevation;
        };
      };
    };

    {
      cells = Array.freeze(newCells);
      peakAzimuth = peakAz;
      peakElevation = peakEl;
      mapConfidence = peakVal;
    }
  };

  // ── Head Tracking ─────────────────────────────────────────────
  public func computeHeadMovement(
    current: HeadPosition, targetAz: Float, targetEl: Float
  ) : HeadPosition {
    // Smooth pursuit: move head toward target
    let azError = targetAz - current.azimuth;
    let elError = targetEl - current.elevation;

    let maxSpeed = 20.0;  // degrees per beat
    let newAz = current.azimuth + _clamp(azError * 0.3, -maxSpeed, maxSpeed);
    let newEl = current.elevation + _clamp(elError * 0.3, -maxSpeed, maxSpeed);

    {
      azimuth = _clamp(newAz, -180.0, 180.0);
      elevation = _clamp(newEl, -90.0, 90.0);
      facialDiscAngle = (newAz + newEl) * 0.1;  // Subtle disc adjustment
    }
  };

  // ── Prey Detection ────────────────────────────────────────────
  public func detectPrey(spectrum: [Float]) : (Float, Float) {
    // Rustle: low frequency broadband noise (bands 0-2)
    // Squeak: high frequency narrowband (bands 5-7)

    var rustleEnergy : Float = 0.0;
    var squeakEnergy : Float = 0.0;

    var i = 0;
    while (i < spectrum.size()) {
      if (i < 3) {
        rustleEnergy += spectrum[i];
      } else if (i >= 5) {
        squeakEnergy += spectrum[i];
      };
      i += 1;
    };

    (rustleEnergy / 3.0, squeakEnergy / 3.0)
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatOwl(
    state: OwlState,
    input: AuditoryInput
  ) : OwlState {
    // Update noise floor (slow adaptation)
    var avgEnergy : Float = 0.0;
    for (e in input.leftEar.vals()) { avgEnergy += e };
    for (e in input.rightEar.vals()) { avgEnergy += e };
    avgEnergy /= Float.fromInt(input.leftEar.size() + input.rightEar.size());

    let newNoiseFloor = 0.95 * state.noiseFloor + 0.05 * avgEnergy * 0.5;

    // Localize sound source
    let newSource = localizeSoundSource(input, newNoiseFloor);

    // Update tracked sources
    var newSources = state.trackedSources;
    var primaryIdx : ?Nat = null;

    switch (newSource) {
      case (null) {
        // Decay confidence of existing sources
        newSources := Array.map<SoundSource, SoundSource>(newSources, func(s) {
          { id = s.id; azimuth = s.azimuth; elevation = s.elevation;
            distance = s.distance; intensity = s.intensity * 0.9;
            frequency = s.frequency; confidence = s.confidence * 0.9;
            velocity = s.velocity; lastUpdate = s.lastUpdate; }
        });
      };
      case (?src) {
        // Add or update source
        let newSrc = {
          id = newSources.size();
          azimuth = src.azimuth;
          elevation = src.elevation;
          distance = src.distance;
          intensity = src.intensity;
          frequency = src.frequency;
          confidence = src.confidence;
          velocity = 0.0;
          lastUpdate = state.beatNum + 1;
        };

        // Simple: replace single tracked source
        newSources := [newSrc];
        primaryIdx := ?0;
      };
    };

    // Update auditory map
    let newMap = updateAuditoryMap(state.auditoryMap, newSources);

    // Head tracking
    let newHead = if (newSources.size() > 0) {
      computeHeadMovement(
        state.headPosition,
        newSources[0].azimuth,
        newSources[0].elevation
      )
    } else { state.headPosition };

    // Compute ITD and ILD
    let newITD = input.leftTiming - input.rightTiming;
    let newILD = computeILD(input.leftEar, input.rightEar);

    // Prey detection
    let combinedSpectrum = Array.tabulate<Float>(FREQUENCY_BANDS, func(i) {
      if (i < input.leftEar.size() and i < input.rightEar.size()) {
        (input.leftEar[i] + input.rightEar[i]) / 2.0
      } else { 0.0 }
    });
    let (rustle, squeak) = detectPrey(combinedSpectrum);

    // Prey likelihood
    let newPreyLikelihood = _clamp(
      state.preyLikelihood * 0.8 + (rustle + squeak) * 0.2,
      0.0, 1.0
    );

    // SNR
    let signalStrength = if (newSources.size() > 0) { newSources[0].intensity } else { 0.0 };
    let newSNR = if (newNoiseFloor > 0.01) { signalStrength / newNoiseFloor } else { 0.0 };

    {
      leftSpectrum = input.leftEar;
      rightSpectrum = input.rightEar;
      interauralTime = newITD;
      interauralLevel = newILD;
      trackedSources = newSources;
      primarySource = primaryIdx;
      auditoryMap = newMap;
      headPosition = newHead;
      headTrackTarget = primaryIdx;
      headMovement = abs(newHead.azimuth - state.headPosition.azimuth) +
                     abs(newHead.elevation - state.headPosition.elevation);
      auditoryFocus = _clamp(state.auditoryFocus + newPreyLikelihood * 0.1 - 0.02, 0.0, 1.0);
      visualAuditory = state.visualAuditory;
      preyLikelihood = newPreyLikelihood;
      rustleDetection = rustle;
      squeakDetection = squeak;
      noiseFloor = newNoiseFloor;
      snr = _clamp(newSNR, 0.0, 10.0);
      beatNum = state.beatNum + 1;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initOwl() : OwlState {
    {
      leftSpectrum = Array.tabulate<Float>(FREQUENCY_BANDS, func(_) { 0.0 });
      rightSpectrum = Array.tabulate<Float>(FREQUENCY_BANDS, func(_) { 0.0 });
      interauralTime = 0.0;
      interauralLevel = 0.0;
      trackedSources = [];
      primarySource = null;
      auditoryMap = {
        cells = Array.tabulate<Float>(512, func(_) { 0.0 });
        peakAzimuth = 0.0;
        peakElevation = 0.0;
        mapConfidence = 0.0;
      };
      headPosition = {
        azimuth = 0.0;
        elevation = 0.0;
        facialDiscAngle = 0.0;
      };
      headTrackTarget = null;
      headMovement = 0.0;
      auditoryFocus = 0.5;
      visualAuditory = 0.5;
      preyLikelihood = 0.0;
      rustleDetection = 0.0;
      squeakDetection = 0.0;
      noiseFloor = 0.1;
      snr = 1.0;
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type OwlSummary = {
    trackedSources  : Nat;
    primaryAzimuth  : Float;
    primaryElevation: Float;
    snr             : Float;
    preyLikelihood  : Float;
    headAzimuth     : Float;
  };

  public func summary(state: OwlState) : OwlSummary {
    let (az, el) = if (state.trackedSources.size() > 0) {
      (state.trackedSources[0].azimuth, state.trackedSources[0].elevation)
    } else { (0.0, 0.0) };

    {
      trackedSources = state.trackedSources.size();
      primaryAzimuth = az;
      primaryElevation = el;
      snr = state.snr;
      preyLikelihood = state.preyLikelihood;
      headAzimuth = state.headPosition.azimuth;
    }
  };

}
