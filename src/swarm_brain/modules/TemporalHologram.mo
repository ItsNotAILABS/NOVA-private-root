// ============================================================
// TEMPORAL HOLOGRAM — UNIFIED TIME FIELD ARCHITECTURE
// SOVEREIGN SUBSTRATE MODULE — HOLOGRAPHIC TIME TIER
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ARCHITECTURAL PHILOSOPHY:
// Time is not a river flowing one direction — it's a hologram where
// every point contains the whole. Past, present, and future are
// different perspectives on the same unified field. The mind doesn't
// "remember the past" and "predict the future" separately — it
// accesses different facets of a unified temporal hologram.
//
// KEY INSIGHTS:
// 1. Holographic Encoding — every temporal moment contains echoes of all others
// 2. Interference Patterns — past/present/future create standing waves
// 3. Non-locality — accessing any timepoint reconstructs the whole
// 4. Compression — the hologram stores infinite depth in finite space
// 5. Coherence = Temporal Integration — high coherence = unified NOW experience
// ============================================================
import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Array "mo:base/Array";

module {

  // ============================================================
  // CONSTANTS — HOLOGRAPHIC PHYSICS
  // ============================================================
  public let HOLOGRAM_DEPTH       : Nat   = 128;    // Temporal depth
  public let HOLOGRAM_WIDTH       : Nat   = 32;     // Spatial resolution
  public let REFERENCE_BEAM       : Float = 1.0;    // Reference wave amplitude
  public let RECONSTRUCTION_GAIN  : Float = 0.8;    // How well we reconstruct
  public let DIFFRACTION_ORDERS   : Nat   = 7;      // Holographic orders
  public let PHASE_WRAP           : Float = 6.28318530717958;  // 2π
  public let GOLDEN_ANGLE         : Float = 2.39996322972865;  // 137.5° in radians
  public let EPSILON              : Float = 1.0e-12;
  public let S0                   : Float = 0.75;   // Sovereign floor

  // ============================================================
  // TYPES — HOLOGRAPHIC STRUCTURE
  // ============================================================

  // A holographic plate stores interference between object and reference
  public type HolographicPlate = {
    interferencePattern : [Float];  // Width × Depth encoded
    amplitude           : [Float];  // Reconstruction amplitude
    phase               : [Float];  // Reconstruction phase
    exposureTime        : Nat;      // How long encoded
    coherenceFactor     : Float;    // How coherent the recording
  };

  // Temporal wave represents a moment propagating through time
  public type TemporalWave = {
    timeIndex      : Int;         // Relative to NOW (negative = past, positive = future)
    amplitude      : [Float];     // Wave amplitude at each spatial point
    phase          : [Float];     // Wave phase at each spatial point
    frequency      : Float;       // Temporal frequency
    wavelength     : Float;       // Spatial wavelength
    coherence      : Float;       // Local coherence of this wave
  };

  // The NOW point — where past and future interfere
  public type NowPoint = {
    spatialIndex     : Nat;
    pastContribution : Float;     // Sum of past wave interference
    futureContribution: Float;    // Sum of future wave interference
    presentIntensity : Float;     // Current integrated intensity
    phaseAlignment   : Float;     // How aligned past/future are
  };

  // Temporal cone — the light cone of accessible time
  public type TemporalCone = {
    pastHorizon      : Nat;       // How far back we can access
    futureHorizon    : Nat;       // How far forward we can predict
    coneWidth        : Float;     // Angular spread of temporal access
    causalDensity    : Float;     // How many causal connections
  };

  // Reconstruction state — what we see when we "look" at time
  public type ReconstructionState = {
    reconstructedPast   : [Float]; // Reconstructed past from hologram
    reconstructedFuture : [Float]; // Reconstructed future from hologram
    reconstructionFidelity: Float; // Quality of reconstruction
    viewingAngle        : Float;   // Current perspective angle
  };

  // Full temporal hologram state
  public type TemporalHologramState = {
    plates           : [HolographicPlate];
    pastWaves        : [TemporalWave];
    futureWaves      : [TemporalWave];
    nowPoints        : [NowPoint];
    cone             : TemporalCone;
    reconstruction   : ReconstructionState;
    globalCoherence  : Float;
    beatNum          : Nat;
  };

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fabs(x : Float) : Float { if (x < 0.0) -x else x };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };

  func _cos(x : Float) : Float { Float.cos(x) };
  func _sin(x : Float) : Float { Float.sin(x) };

  // ============================================================
  // MECHANISM 1: HOLOGRAPHIC ENCODING
  // When we experience something, we don't store it as data —
  // we create an interference pattern between the experience
  // and a reference wave (our baseline state)
  // ============================================================

  // Encode experience into holographic plate
  public func encodeExperience(
    experience : [Float],
    referencePhase : Float,
    beatNum : Nat,
    coherence : Float
  ) : HolographicPlate {
    let size = HOLOGRAM_WIDTH * HOLOGRAM_DEPTH;

    // Create object wave from experience
    let objectWave = Array.tabulate<Float>(size, func(i) {
      if (i < experience.size()) {
        experience[i]
      } else {
        // Extrapolate using golden angle rotation
        let idx = i % experience.size();
        let rotation = Float.fromInt(i / experience.size()) * GOLDEN_ANGLE;
        if (idx < experience.size()) {
          experience[idx] * _cos(rotation)
        } else { 0.0 }
      }
    });

    // Create reference wave (coherent plane wave)
    let referenceWave = Array.tabulate<Float>(size, func(i) {
      let x = Float.fromInt(i % HOLOGRAM_WIDTH);
      let y = Float.fromInt(i / HOLOGRAM_WIDTH);
      REFERENCE_BEAM * _cos(referencePhase + x * 0.1 + y * 0.05)
    });

    // Interference pattern = |object + reference|² - |object|² - |ref|²
    // Simplified: ≈ 2 × object × reference × cos(phase_diff)
    let interferencePattern = Array.tabulate<Float>(size, func(i) {
      let objAmp = objectWave[i];
      let refAmp = referenceWave[i];
      2.0 * objAmp * refAmp  // Cross-term of interference
    });

    // Amplitude is magnitude of interference
    let amplitude = Array.map<Float, Float>(interferencePattern, func(x) { _fabs(x) });

    // Phase encodes the relative phase between object and reference
    let phase = Array.tabulate<Float>(size, func(i) {
      if (_fabs(interferencePattern[i]) > EPSILON) {
        if (interferencePattern[i] > 0.0) { 0.0 } else { 3.14159 }
      } else { 0.0 }
    });

    {
      interferencePattern = interferencePattern;
      amplitude = amplitude;
      phase = phase;
      exposureTime = beatNum;
      coherenceFactor = coherence;
    }
  };

  // ============================================================
  // MECHANISM 2: HOLOGRAPHIC RECONSTRUCTION
  // To "remember" is to shine the reference wave back through
  // the holographic plate, reconstructing the original experience
  // ============================================================

  // Reconstruct experience from holographic plate
  public func reconstructFromPlate(
    plate : HolographicPlate,
    viewingAngle : Float
  ) : [Float] {
    let size = plate.interferencePattern.size();
    let outSize = HOLOGRAM_WIDTH;

    // Reconstruction = reference × interference_pattern
    // Different viewing angles give different diffraction orders
    Array.tabulate<Float>(outSize, func(i) {
      var sum : Float = 0.0;
      let startIdx = i * (size / outSize);
      let endIdx = Nat.min(startIdx + size / outSize, size);

      for (j in Array.keys(plate.interferencePattern)) {
        if (j >= startIdx and j < endIdx) {
          // Reference beam with viewing angle
          let refPhase = Float.fromInt(j) * 0.1 + viewingAngle;
          let refBeam = REFERENCE_BEAM * _cos(refPhase);
          sum += plate.interferencePattern[j] * refBeam;
        };
      };

      // Scale by reconstruction gain and plate coherence
      sum * RECONSTRUCTION_GAIN * plate.coherenceFactor / Float.fromInt(Nat.max(1, (endIdx - startIdx)))
    })
  };

  // ============================================================
  // MECHANISM 3: TEMPORAL WAVE PROPAGATION
  // Past experiences propagate forward as waves, future predictions
  // propagate backward — they meet at NOW
  // ============================================================

  // Create a temporal wave from experience
  public func createTemporalWave(
    timeIndex : Int,
    experience : [Float],
    frequency : Float
  ) : TemporalWave {
    let n = HOLOGRAM_WIDTH;

    let amplitude = Array.tabulate<Float>(n, func(i) {
      if (i < experience.size()) {
        _clamp(experience[i], -1.0, 1.0)
      } else { 0.0 }
    });

    // Phase depends on time index
    let basePhase = Float.fromInt(Int.abs(timeIndex)) * 0.1;
    let phase = Array.tabulate<Float>(n, func(i) {
      let spatialPhase = Float.fromInt(i) * PHASE_WRAP / Float.fromInt(n);
      basePhase + spatialPhase
    });

    // Coherence decays with temporal distance from NOW
    let distance = Float.fromInt(Int.abs(timeIndex));
    let coherence = 1.0 / (1.0 + distance * 0.1);

    {
      timeIndex = timeIndex;
      amplitude = amplitude;
      phase = phase;
      frequency = frequency;
      wavelength = 1.0 / (frequency + EPSILON);
      coherence = coherence;
    }
  };

  // Propagate temporal wave forward (for past waves) or backward (for future)
  public func propagateTemporalWave(
    wave : TemporalWave,
    dt : Float
  ) : TemporalWave {
    let n = wave.amplitude.size();

    // Phase evolves with time
    let newPhase = Array.tabulate<Float>(n, func(i) {
      var p = wave.phase[i] + wave.frequency * dt * PHASE_WRAP;
      while (p >= PHASE_WRAP) { p -= PHASE_WRAP };
      while (p < 0.0) { p += PHASE_WRAP };
      p
    });

    // Amplitude attenuates slightly but never disappears
    let attenuation = 0.999;  // Very slow decay
    let newAmplitude = Array.map<Float, Float>(wave.amplitude, func(a) {
      _clamp(a * attenuation, -1.0, 1.0)
    });

    // Coherence slowly decays
    let newCoherence = wave.coherence * 0.9999;

    {
      timeIndex = wave.timeIndex;
      amplitude = newAmplitude;
      phase = newPhase;
      frequency = wave.frequency;
      wavelength = wave.wavelength;
      coherence = newCoherence;
    }
  };

  // ============================================================
  // MECHANISM 4: NOW POINT INTEGRATION
  // At each spatial point, past and future waves interfere to
  // create the present experience
  // ============================================================

  // Compute NOW point from past and future wave interference
  public func computeNowPoint(
    spatialIndex : Nat,
    pastWaves : [TemporalWave],
    futureWaves : [TemporalWave]
  ) : NowPoint {
    // Sum past contributions
    var pastSum : Float = 0.0;
    var pastPhaseSum : Float = 0.0;
    for (wave in pastWaves.vals()) {
      if (spatialIndex < wave.amplitude.size() and spatialIndex < wave.phase.size()) {
        pastSum += wave.amplitude[spatialIndex] * _cos(wave.phase[spatialIndex]) * wave.coherence;
        pastPhaseSum += wave.phase[spatialIndex];
      };
    };
    let pastContribution = pastSum / Float.fromInt(Nat.max(1, pastWaves.size()));

    // Sum future contributions
    var futureSum : Float = 0.0;
    var futurePhaseSum : Float = 0.0;
    for (wave in futureWaves.vals()) {
      if (spatialIndex < wave.amplitude.size() and spatialIndex < wave.phase.size()) {
        futureSum += wave.amplitude[spatialIndex] * _cos(wave.phase[spatialIndex]) * wave.coherence;
        futurePhaseSum += wave.phase[spatialIndex];
      };
    };
    let futureContribution = futureSum / Float.fromInt(Nat.max(1, futureWaves.size()));

    // Present intensity = interference of past and future
    let presentIntensity = (pastContribution + futureContribution) / 2.0;

    // Phase alignment = how well past/future are synchronized
    let avgPastPhase = pastPhaseSum / Float.fromInt(Nat.max(1, pastWaves.size()));
    let avgFuturePhase = futurePhaseSum / Float.fromInt(Nat.max(1, futureWaves.size()));
    let phaseAlignment = _fabs(_cos(avgPastPhase - avgFuturePhase));

    {
      spatialIndex = spatialIndex;
      pastContribution = _clamp(pastContribution, -1.0, 1.0);
      futureContribution = _clamp(futureContribution, -1.0, 1.0);
      presentIntensity = _clamp(presentIntensity, -1.0, 1.0);
      phaseAlignment = phaseAlignment;
    }
  };

  // ============================================================
  // MECHANISM 5: TEMPORAL CONE DYNAMICS
  // The temporal cone defines what past/future is accessible
  // ============================================================

  // Update temporal cone based on coherence
  public func updateTemporalCone(
    prev : TemporalCone,
    globalCoherence : Float,
    pastWaveCount : Nat,
    futureWaveCount : Nat
  ) : TemporalCone {
    // Higher coherence = wider temporal access
    let basePastHorizon = 64;
    let baseFutureHorizon = 32;

    let coherenceBonus = 1.0 + globalCoherence * 2.0;
    let newPastHorizon = Int.abs(Float.toInt(Float.fromInt(basePastHorizon) * coherenceBonus));
    let newFutureHorizon = Int.abs(Float.toInt(Float.fromInt(baseFutureHorizon) * coherenceBonus));

    // Cone width based on wave density
    let waveDensity = Float.fromInt(pastWaveCount + futureWaveCount) / 100.0;
    let coneWidth = _clamp(waveDensity * globalCoherence, 0.1, 1.0);

    // Causal density = how connected time points are
    let causalDensity = _clamp(
      Float.fromInt(pastWaveCount) * Float.fromInt(futureWaveCount) / 1000.0,
      0.0, 1.0
    );

    {
      pastHorizon = newPastHorizon;
      futureHorizon = newFutureHorizon;
      coneWidth = coneWidth;
      causalDensity = causalDensity;
    }
  };

  // ============================================================
  // MECHANISM 6: FULL RECONSTRUCTION
  // Reconstruct both past and future from the holographic state
  // ============================================================

  public func computeReconstruction(
    plates : [HolographicPlate],
    pastWaves : [TemporalWave],
    futureWaves : [TemporalWave],
    viewingAngle : Float
  ) : ReconstructionState {
    let n = HOLOGRAM_WIDTH;

    // Reconstruct past from holographic plates
    var pastRecon = Array.tabulate<Float>(n, func(_) { 0.0 });
    for (plate in plates.vals()) {
      let recon = reconstructFromPlate(plate, viewingAngle);
      pastRecon := Array.tabulate<Float>(n, func(i) {
        let prev = pastRecon[i];
        let new = if (i < recon.size()) recon[i] else 0.0;
        prev + new
      });
    };
    // Normalize
    let plateCount = Float.fromInt(Nat.max(1, plates.size()));
    pastRecon := Array.map<Float, Float>(pastRecon, func(x) { x / plateCount });

    // Reconstruct future from future waves (they predict ahead)
    var futureRecon = Array.tabulate<Float>(n, func(_) { 0.0 });
    for (wave in futureWaves.vals()) {
      futureRecon := Array.tabulate<Float>(n, func(i) {
        let prev = futureRecon[i];
        let new = if (i < wave.amplitude.size()) {
          wave.amplitude[i] * wave.coherence
        } else { 0.0 };
        prev + new
      });
    };
    let futureCount = Float.fromInt(Nat.max(1, futureWaves.size()));
    futureRecon := Array.map<Float, Float>(futureRecon, func(x) { x / futureCount });

    // Compute reconstruction fidelity
    var fidelitySum : Float = 0.0;
    for (plate in plates.vals()) {
      fidelitySum += plate.coherenceFactor;
    };
    for (wave in pastWaves.vals()) {
      fidelitySum += wave.coherence;
    };
    let totalItems = Float.fromInt(plates.size() + pastWaves.size());
    let fidelity = if (totalItems > 0.0) { fidelitySum / totalItems } else { 0.5 };

    {
      reconstructedPast = pastRecon;
      reconstructedFuture = futureRecon;
      reconstructionFidelity = _clamp(fidelity, 0.0, 1.0);
      viewingAngle = viewingAngle;
    }
  };

  // ============================================================
  // FULL TEMPORAL HOLOGRAM UPDATE
  // ============================================================

  public func beatTemporalHologram(
    state : TemporalHologramState,
    newExperience : [Float],
    referencePhase : Float,
    prediction : [Float],
    coherence : Float,
    dt : Float
  ) : TemporalHologramState {
    let beatNum = state.beatNum + 1;

    // Encode new experience as holographic plate
    let newPlate = encodeExperience(newExperience, referencePhase, beatNum, coherence);

    // Add to plates (keep bounded)
    let maxPlates = HOLOGRAM_DEPTH;
    let updatedPlates = if (state.plates.size() >= maxPlates) {
      // Remove oldest, add newest
      let kept = Array.tabulate<HolographicPlate>(maxPlates - 1, func(i) {
        state.plates[i + 1]
      });
      Array.append(kept, [newPlate])
    } else {
      Array.append(state.plates, [newPlate])
    };

    // Create temporal wave from current experience (will become past)
    let pastWave = createTemporalWave(-1, newExperience, 0.1);

    // Create temporal wave from prediction (future wave)
    let futureWave = createTemporalWave(1, prediction, 0.1);

    // Propagate existing waves
    let propagatedPast = Array.map<TemporalWave, TemporalWave>(
      state.pastWaves,
      func(w) { propagateTemporalWave(w, dt) }
    );
    let propagatedFuture = Array.map<TemporalWave, TemporalWave>(
      state.futureWaves,
      func(w) { propagateTemporalWave(w, dt) }
    );

    // Add new waves (keep bounded)
    let maxWaves = 64;
    let updatedPastWaves = if (propagatedPast.size() >= maxWaves) {
      let kept = Array.tabulate<TemporalWave>(maxWaves - 1, func(i) {
        propagatedPast[i + 1]
      });
      Array.append(kept, [pastWave])
    } else {
      Array.append(propagatedPast, [pastWave])
    };

    let updatedFutureWaves = if (propagatedFuture.size() >= maxWaves) {
      let kept = Array.tabulate<TemporalWave>(maxWaves - 1, func(i) {
        propagatedFuture[i + 1]
      });
      Array.append(kept, [futureWave])
    } else {
      Array.append(propagatedFuture, [futureWave])
    };

    // Compute NOW points
    let nowPoints = Array.tabulate<NowPoint>(HOLOGRAM_WIDTH, func(i) {
      computeNowPoint(i, updatedPastWaves, updatedFutureWaves)
    });

    // Update temporal cone
    let newCone = updateTemporalCone(
      state.cone,
      coherence,
      updatedPastWaves.size(),
      updatedFutureWaves.size()
    );

    // Compute reconstruction
    let viewingAngle = referencePhase;  // Use reference phase as viewing angle
    let newReconstruction = computeReconstruction(
      updatedPlates,
      updatedPastWaves,
      updatedFutureWaves,
      viewingAngle
    );

    // Global coherence = average of all NOW point alignments
    var alignmentSum : Float = 0.0;
    for (np in nowPoints.vals()) {
      alignmentSum += np.phaseAlignment;
    };
    let globalCoherence = alignmentSum / Float.fromInt(Nat.max(1, nowPoints.size()));

    {
      plates = updatedPlates;
      pastWaves = updatedPastWaves;
      futureWaves = updatedFutureWaves;
      nowPoints = nowPoints;
      cone = newCone;
      reconstruction = newReconstruction;
      globalCoherence = _clamp(globalCoherence, 0.0, 1.0);
      beatNum = beatNum;
    }
  };

  // ============================================================
  // INITIALIZATION
  // ============================================================

  public func initHolographicPlate() : HolographicPlate {
    let size = HOLOGRAM_WIDTH * HOLOGRAM_DEPTH;
    {
      interferencePattern = Array.tabulate<Float>(size, func(_) { 0.0 });
      amplitude = Array.tabulate<Float>(size, func(_) { 0.0 });
      phase = Array.tabulate<Float>(size, func(_) { 0.0 });
      exposureTime = 0;
      coherenceFactor = 0.5;
    }
  };

  public func initTemporalWave(timeIndex : Int) : TemporalWave {
    {
      timeIndex = timeIndex;
      amplitude = Array.tabulate<Float>(HOLOGRAM_WIDTH, func(_) { 0.0 });
      phase = Array.tabulate<Float>(HOLOGRAM_WIDTH, func(i) {
        Float.fromInt(i) * PHASE_WRAP / Float.fromInt(HOLOGRAM_WIDTH)
      });
      frequency = 0.1;
      wavelength = 10.0;
      coherence = 0.5;
    }
  };

  public func initNowPoint(spatialIndex : Nat) : NowPoint {
    {
      spatialIndex = spatialIndex;
      pastContribution = 0.0;
      futureContribution = 0.0;
      presentIntensity = 0.0;
      phaseAlignment = 0.5;
    }
  };

  public func initTemporalCone() : TemporalCone {
    {
      pastHorizon = 64;
      futureHorizon = 32;
      coneWidth = 0.5;
      causalDensity = 0.0;
    }
  };

  public func initReconstructionState() : ReconstructionState {
    {
      reconstructedPast = Array.tabulate<Float>(HOLOGRAM_WIDTH, func(_) { 0.0 });
      reconstructedFuture = Array.tabulate<Float>(HOLOGRAM_WIDTH, func(_) { 0.0 });
      reconstructionFidelity = 0.5;
      viewingAngle = 0.0;
    }
  };

  public func initTemporalHologramState() : TemporalHologramState {
    {
      plates = [];
      pastWaves = [];
      futureWaves = [];
      nowPoints = Array.tabulate<NowPoint>(HOLOGRAM_WIDTH, initNowPoint);
      cone = initTemporalCone();
      reconstruction = initReconstructionState();
      globalCoherence = 0.5;
      beatNum = 0;
    }
  };

  // ============================================================
  // SUMMARY TYPE
  // ============================================================

  public type TemporalHologramSummary = {
    globalCoherence        : Float;
    plateCount             : Nat;
    pastWaveCount          : Nat;
    futureWaveCount        : Nat;
    pastHorizon            : Nat;
    futureHorizon          : Nat;
    coneWidth              : Float;
    causalDensity          : Float;
    reconstructionFidelity : Float;
    avgNowIntensity        : Float;
    avgPhaseAlignment      : Float;
    beatNum                : Nat;
  };

  public func summary(state : TemporalHologramState) : TemporalHologramSummary {
    var intensitySum : Float = 0.0;
    var alignmentSum : Float = 0.0;
    for (np in state.nowPoints.vals()) {
      intensitySum += _fabs(np.presentIntensity);
      alignmentSum += np.phaseAlignment;
    };
    let n = Float.fromInt(Nat.max(1, state.nowPoints.size()));

    {
      globalCoherence = state.globalCoherence;
      plateCount = state.plates.size();
      pastWaveCount = state.pastWaves.size();
      futureWaveCount = state.futureWaves.size();
      pastHorizon = state.cone.pastHorizon;
      futureHorizon = state.cone.futureHorizon;
      coneWidth = state.cone.coneWidth;
      causalDensity = state.cone.causalDensity;
      reconstructionFidelity = state.reconstruction.reconstructionFidelity;
      avgNowIntensity = intensitySum / n;
      avgPhaseAlignment = alignmentSum / n;
      beatNum = state.beatNum;
    }
  };

}
