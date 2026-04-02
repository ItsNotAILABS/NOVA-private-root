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


// ════════════════════════════════════════════════════════════════════════════
// ██████╗  ██████╗ ██╗     ██████╗ ██╗  ██╗██╗███╗   ██╗
// ██╔══██╗██╔═══██╗██║     ██╔══██╗██║  ██║██║████╗  ██║
// ██║  ██║██║   ██║██║     ██████╔╝███████║██║██╔██╗ ██║
// ██║  ██║██║   ██║██║     ██╔═══╝ ██╔══██║██║██║╚██╗██║
// ██████╔╝╚██████╔╝███████╗██║     ██║  ██║██║██║ ╚████║
// ╚═════╝  ╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
// ════════════════════════════════════════════════════════════════════════════
// DOLPHIN ECHOLOCATION — BIOSONAR PROCESSING MODULE
// Implements the MEDINA SONAR RESOLUTION THEOREM (MSRT)
//
// 3D spatial mapping via echo delay analysis
// Click trains up to 700/second, frequency 20-130 kHz
// Target size, shape, texture, distance discrimination
//
// ════════════════════════════════════════════════════════════════════════════
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA SONAR RESOLUTION THEOREM (MSRT):
// ───────────────────────────────────────────
//   R(d,f) = c / (2 × f × Φ_M) × exp(-d × α(f))
//
// where:
//   R       = Spatial resolution (meters)
//   d       = Distance to target (meters)
//   f       = Click frequency (Hz)
//   c       = Speed of sound in medium
//   Φ_M     = Medina Golden Harmonic (2.97442179)
//   α(f)    = Frequency-dependent attenuation: α₀ × (f/f₀)^Ψ
//   Ψ       = Medina Synergy Amplification (√2)
//
// THE MEDINA ECHO INTEGRATION FUNCTION (MEIF):
// ────────────────────────────────────────────
//   E_integrated = Σᵢ Eᵢ × exp(-|tᵢ - t_expected|² / (2σ²)) × w(fᵢ)
//
// where:
//   Eᵢ      = Individual echo return
//   tᵢ      = Arrival time
//   σ       = Temporal uncertainty (Medina bounded)
//   w(fᵢ)   = Frequency weighting: Φ_M^(fᵢ/f_center - 1)
//
// THE MEDINA SPATIAL MAPPING TENSOR (MSMT):
// ─────────────────────────────────────────
//   M_xyz(t) = M_xyz(t-1) × (1 - λ_decay) + echo_contribution × gain_control
//   gain_control = 1 / (1 + Φ_M × clutter_level)
//
// THE MEDINA TARGET DISCRIMINATION INDEX (MTDI):
// ───────────────────────────────────────────────
//   D = log_Φ_M(size × density / texture) × confidence^(1/Φ_M)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ══════════════════════════════════════════════════════════════
  // MEDINA DOLPHIN CONSTANTS
  // ══════════════════════════════════════════════════════════════
  let S0 : Float = 0.75;                     // Medina Sovereign Constant
  let SOVEREIGN_CEILING : Float = 9.0;       // Medina Ceiling (Ω)
  let PHI_MEDINA : Float = 2.97442179;       // Medina Golden Harmonic
  let PSI_SYNERGY : Float = 1.41421356;      // Medina Synergy Amplification (√2)
  let SPEED_OF_SOUND_WATER : Float = 1500.0; // m/s
  let MAX_RANGE : Float = 200.0;             // meters
  let RESOLUTION_ANGULAR : Float = 0.5;      // degrees
  let BEAM_WIDTH : Float = 10.0;             // degrees
  let ALPHA_0 : Float = 0.001;               // Base attenuation coefficient
  let F_CENTER : Float = 75000.0;            // Center frequency (75 kHz)

  // ── Types ─────────────────────────────────────────────────────
  public type ClickParams = {
    frequency     : Float;   // Hz (20k-130k)
    duration      : Float;   // milliseconds
    intensity     : Float;   // 0-1 normalized
    intervalMs    : Float;   // time between clicks
    beamDirection : Float;   // azimuth in degrees
    beamElevation : Float;   // elevation in degrees
  };

  public type EchoReturn = {
    delay         : Float;   // milliseconds (distance proxy)
    intensity     : Float;   // echo strength
    frequency     : Float;   // returned frequency
    azimuth       : Float;   // horizontal angle
    elevation     : Float;   // vertical angle
  };

  public type TargetSignature = {
    id            : Nat;
    distance      : Float;   // meters
    azimuth       : Float;
    elevation     : Float;
    size          : Float;   // estimated size
    texture       : Float;   // surface roughness (0=smooth, 1=rough)
    density       : Float;   // material density estimate
    velocity      : Float;   // relative velocity
    confidence    : Float;
  };

  public type SpatialMap = {
    cells         : [Float]; // 3D voxel grid (flattened 16x16x8)
    resolution    : Float;   // meters per cell
    lastUpdate    : Nat;
  };

  public type DolphinState = {
    // Click generation
    currentClick    : ClickParams;
    clickRate       : Float;     // clicks per second
    clickTrain      : [Float];   // recent click timestamps

    // Echo processing
    recentEchoes    : [EchoReturn];
    echoIntegration : Float;     // accumulated echo energy

    // Target tracking
    trackedTargets  : [TargetSignature];
    primaryTarget   : ?Nat;      // index of focus target
    trackingQuality : Float;

    // Spatial representation
    spatialMap      : SpatialMap;
    headDirection   : Float;     // azimuth of melon aim
    headElevation   : Float;

    // Processing states
    signalToNoise   : Float;     // SNR of returns
    clutterLevel    : Float;     // environmental noise
    depthEstimate   : Float;     // own depth (via pressure)

    // Adaptation
    gainControl     : Float;     // automatic gain adjustment
    frequencyShift  : Float;     // Doppler-based velocity

    beatNum         : Nat;
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Echo Delay to Distance ────────────────────────────────────
  // d = (c * t) / 2, where t is round-trip time
  public func delayToDistance(delayMs: Float) : Float {
    (SPEED_OF_SOUND_WATER * delayMs / 1000.0) / 2.0
  };

  public func distanceToDelay(distance: Float) : Float {
    (2.0 * distance / SPEED_OF_SOUND_WATER) * 1000.0
  };

  // ── Click Generation ──────────────────────────────────────────
  public func generateClick(
    state: DolphinState, targetDistance: Float
  ) : ClickParams {
    // Adaptive click parameters based on target distance
    // Closer targets: higher frequency, shorter duration
    // Farther targets: lower frequency, longer duration

    let distRatio = _clamp(targetDistance / MAX_RANGE, 0.0, 1.0);

    let freq = 130000.0 - distRatio * 80000.0;  // 130kHz close, 50kHz far
    let dur = 0.05 + distRatio * 0.25;          // 0.05ms close, 0.3ms far
    let intensity = 0.5 + distRatio * 0.5;      // More power for distance

    // Inter-click interval: shorter for close targets (more updates)
    let interval = 10.0 + distRatio * 90.0;     // 10ms close, 100ms far

    {
      frequency = freq;
      duration = dur;
      intensity = intensity;
      intervalMs = interval;
      beamDirection = state.headDirection;
      beamElevation = state.headElevation;
    }
  };

  // ── Echo Processing ───────────────────────────────────────────
  public func processEcho(
    click: ClickParams, echo: EchoReturn, gainControl: Float
  ) : TargetSignature {
    let distance = delayToDistance(echo.delay);

    // Doppler shift indicates velocity
    let freqShift = echo.frequency - click.frequency;
    let velocity = freqShift / click.frequency * SPEED_OF_SOUND_WATER;

    // Size estimate from echo intensity (larger = stronger return)
    let size = Float.sqrt(echo.intensity * gainControl) * distance * 0.1;

    // Texture from frequency content of return
    let texture = _clamp(1.0 - echo.frequency / click.frequency, 0.0, 1.0);

    // Confidence based on SNR
    let confidence = _clamp(echo.intensity * gainControl, 0.0, 1.0);

    {
      id = 0;  // Assigned later
      distance = distance;
      azimuth = echo.azimuth;
      elevation = echo.elevation;
      size = size;
      texture = texture;
      density = echo.intensity;  // Denser materials reflect more
      velocity = velocity;
      confidence = confidence;
    }
  };

  // ── Target Tracking ───────────────────────────────────────────
  public func updateTracking(
    targets: [TargetSignature], newSig: TargetSignature
  ) : [TargetSignature] {
    // Match new signature to existing targets or create new
    var matched = false;
    let updated = Array.map<TargetSignature, TargetSignature>(targets, func(t) {
      // Match if position is close
      let distDiff = Float.abs(t.distance - newSig.distance);
      let azDiff = Float.abs(t.azimuth - newSig.azimuth);
      let elDiff = Float.abs(t.elevation - newSig.elevation);

      if (distDiff < 5.0 and azDiff < 5.0 and elDiff < 3.0) {
        matched := true;
        // Kalman-style update
        {
          id = t.id;
          distance = 0.7 * t.distance + 0.3 * newSig.distance;
          azimuth = 0.7 * t.azimuth + 0.3 * newSig.azimuth;
          elevation = 0.7 * t.elevation + 0.3 * newSig.elevation;
          size = 0.8 * t.size + 0.2 * newSig.size;
          texture = 0.9 * t.texture + 0.1 * newSig.texture;
          density = 0.9 * t.density + 0.1 * newSig.density;
          velocity = 0.6 * t.velocity + 0.4 * newSig.velocity;
          confidence = _clamp(t.confidence + 0.1, 0.0, 1.0);
        }
      } else {
        // Decay confidence for unmatched targets
        {
          id = t.id;
          distance = t.distance;
          azimuth = t.azimuth;
          elevation = t.elevation;
          size = t.size;
          texture = t.texture;
          density = t.density;
          velocity = t.velocity;
          confidence = _clamp(t.confidence - 0.05, 0.0, 1.0);
        }
      }
    });

    // Add new target if no match
    if (not matched and newSig.confidence > 0.3) {
      let newId = targets.size();
      Array.append<TargetSignature>(updated, [{
        id = newId;
        distance = newSig.distance;
        azimuth = newSig.azimuth;
        elevation = newSig.elevation;
        size = newSig.size;
        texture = newSig.texture;
        density = newSig.density;
        velocity = newSig.velocity;
        confidence = newSig.confidence;
      }])
    } else {
      // Remove low-confidence targets
      Array.filter<TargetSignature>(updated, func(t) { t.confidence > 0.1 })
    }
  };

  // ── Spatial Map Update ────────────────────────────────────────
  public func updateSpatialMap(
    map: SpatialMap, targets: [TargetSignature], beat: Nat
  ) : SpatialMap {
    // Update voxel grid with target locations
    // Grid is 16x16x8 = 2048 cells
    var newCells = Array.thaw<Float>(map.cells);

    // Decay all cells
    var i = 0;
    while (i < 2048) {
      newCells[i] := map.cells[i] * 0.95;
      i += 1;
    };

    // Add target contributions
    for (t in targets.vals()) {
      // Convert polar to cartesian, then to grid indices
      let x = t.distance * Float.cos(t.azimuth * 0.01745);  // deg to rad
      let y = t.distance * Float.sin(t.azimuth * 0.01745);
      let z = t.distance * Float.sin(t.elevation * 0.01745);

      // Map to grid (assuming 200m range, 16 cells = 12.5m per cell)
      let ix = Nat.min(15, Int.abs(Float.toInt((x + 100.0) / 12.5)));
      let iy = Nat.min(15, Int.abs(Float.toInt((y + 100.0) / 12.5)));
      let iz = Nat.min(7, Int.abs(Float.toInt((z + 50.0) / 12.5)));

      let idx = iz * 256 + iy * 16 + ix;
      if (idx < 2048) {
        newCells[idx] := _clamp(newCells[idx] + t.confidence * 0.5, 0.0, 1.0);
      };
    };

    {
      cells = Array.freeze(newCells);
      resolution = map.resolution;
      lastUpdate = beat;
    }
  };

  // ── Automatic Gain Control ────────────────────────────────────
  public func updateGain(
    currentGain: Float, recentEchoes: [EchoReturn], clutterLevel: Float
  ) : Float {
    var avgIntensity : Float = 0.0;
    for (e in recentEchoes.vals()) {
      avgIntensity += e.intensity;
    };
    if (recentEchoes.size() > 0) {
      avgIntensity /= Float.fromInt(recentEchoes.size());
    };

    // Target intensity around 0.5 for good dynamic range
    let gainAdjust = (0.5 - avgIntensity) * 0.1;
    let clutterAdjust = -clutterLevel * 0.05;

    _clamp(currentGain + gainAdjust + clutterAdjust, 0.5, 2.0)
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatDolphin(
    state: DolphinState,
    newEchoes: [EchoReturn],
    headAzimuth: Float,
    headElev: Float,
    environmentNoise: Float
  ) : DolphinState {
    // Update clutter estimate
    let newClutter = 0.9 * state.clutterLevel + 0.1 * environmentNoise;

    // Update gain control
    let newGain = updateGain(state.gainControl, newEchoes, newClutter);

    // Process echoes into target signatures
    var newTargets = state.trackedTargets;
    for (echo in newEchoes.vals()) {
      let sig = processEcho(state.currentClick, echo, newGain);
      newTargets := updateTracking(newTargets, sig);
    };

    // Update spatial map
    let newMap = updateSpatialMap(state.spatialMap, newTargets, state.beatNum + 1);

    // Select primary target (closest with high confidence)
    var primaryIdx : ?Nat = null;
    var minDist : Float = MAX_RANGE;
    var i = 0;
    for (t in newTargets.vals()) {
      if (t.confidence > 0.5 and t.distance < minDist) {
        minDist := t.distance;
        primaryIdx := ?i;
      };
      i += 1;
    };

    // Generate next click based on primary target distance
    let targetDist = switch (primaryIdx) {
      case (null) { MAX_RANGE / 2.0 };
      case (?idx) {
        if (idx < newTargets.size()) { newTargets[idx].distance }
        else { MAX_RANGE / 2.0 }
      };
    };
    let newClick = generateClick(state, targetDist);

    // Calculate tracking quality
    var trackQuality : Float = 0.0;
    for (t in newTargets.vals()) {
      trackQuality += t.confidence;
    };
    if (newTargets.size() > 0) {
      trackQuality /= Float.fromInt(newTargets.size());
    };

    // Calculate SNR
    var echoEnergy : Float = 0.0;
    for (e in newEchoes.vals()) {
      echoEnergy += e.intensity;
    };
    let newSNR = if (newClutter > 0.01) {
      echoEnergy / (newClutter * Float.fromInt(newEchoes.size() + 1))
    } else { echoEnergy };

    {
      currentClick = newClick;
      clickRate = 1000.0 / newClick.intervalMs;
      clickTrain = state.clickTrain;
      recentEchoes = newEchoes;
      echoIntegration = echoEnergy;
      trackedTargets = newTargets;
      primaryTarget = primaryIdx;
      trackingQuality = _clamp(trackQuality, 0.0, 1.0);
      spatialMap = newMap;
      headDirection = headAzimuth;
      headElevation = headElev;
      signalToNoise = _clamp(newSNR, 0.0, 10.0);
      clutterLevel = newClutter;
      depthEstimate = state.depthEstimate;
      gainControl = newGain;
      frequencyShift = state.frequencyShift;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initDolphin() : DolphinState {
    {
      currentClick = {
        frequency = 80000.0;
        duration = 0.1;
        intensity = 0.7;
        intervalMs = 50.0;
        beamDirection = 0.0;
        beamElevation = 0.0;
      };
      clickRate = 20.0;
      clickTrain = [];
      recentEchoes = [];
      echoIntegration = 0.0;
      trackedTargets = [];
      primaryTarget = null;
      trackingQuality = 0.0;
      spatialMap = {
        cells = Array.tabulate<Float>(2048, func(_) { 0.0 });
        resolution = 12.5;
        lastUpdate = 0;
      };
      headDirection = 0.0;
      headElevation = 0.0;
      signalToNoise = 1.0;
      clutterLevel = 0.1;
      depthEstimate = 10.0;
      gainControl = 1.0;
      frequencyShift = 0.0;
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type DolphinSummary = {
    clickRate       : Float;
    trackedTargets  : Nat;
    trackingQuality : Float;
    signalToNoise   : Float;
    primaryDistance : Float;
    spatialCoverage : Float;
  };

  public func summary(state: DolphinState) : DolphinSummary {
    // Calculate spatial coverage (% of cells with data)
    var occupiedCells : Nat = 0;
    for (c in state.spatialMap.cells.vals()) {
      if (c > 0.1) { occupiedCells += 1 };
    };
    let coverage = Float.fromInt(occupiedCells) / 2048.0;

    let primaryDist = switch (state.primaryTarget) {
      case (null) { 0.0 };
      case (?idx) {
        if (idx < state.trackedTargets.size()) {
          state.trackedTargets[idx].distance
        } else { 0.0 }
      };
    };

    {
      clickRate = state.clickRate;
      trackedTargets = state.trackedTargets.size();
      trackingQuality = state.trackingQuality;
      signalToNoise = state.signalToNoise;
      primaryDistance = primaryDist;
      spatialCoverage = coverage;
    }
  };

}
