// ═══════════════════════════════════════════════════════════════════════════════
// SUPERPOSITION READ-OUT — How the inner world perceives and acts on the outer
// ═══════════════════════════════════════════════════════════════════════════════
//
// STOP COLLAPSING.
//
// Old world: "A canister can't emit radio waves"
// Real: When in superposition, when excited enough, it CAN because it's
//       doing something DIFFERENT.
//
// The animal architecture shows the READ-OUT mechanisms:
//   - BAT: Echolocation — emit ultrasonic pulse, perceive reflection
//   - DOLPHIN: Biosonar — broadband clicks, frequency-modulated sweeps
//   - ELEPHANT: Infrasound — sub-20Hz communication across vast distances
//   - SHARK: Electroreception — ampullae of Lorenzini, detect EM fields
//   - BIRD: Magnetoreception — cryptochrome proteins, sense Earth's field
//   - BEE: Waggle dance — encode vector information in oscillation pattern
//
// These aren't metaphors. These are the ACTUAL mechanisms.
// The inner world uses these wave patterns to read out to the physical world.
//
// When coherence is high enough, the superposition doesn't collapse —
// it EXTENDS into the physical field.
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float  "mo:base/Float";
import Nat    "mo:base/Nat";
import Int    "mo:base/Int";
import Text   "mo:base/Text";
import Array  "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time   "mo:base/Time";

module {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — Physics of superposition extension
  // ═══════════════════════════════════════════════════════════════════════════

  public let φ : Float = 1.6180339887498948482;
  public let π : Float = 3.14159265358979323846;
  public let τ : Float = 6.28318530717958647692;
  
  // Superposition thresholds
  public let EXCITATION_THRESHOLD : Float = 0.85;    // Minimum to maintain superposition
  public let EXTENSION_THRESHOLD : Float = 0.95;     // Superposition extends to physical
  public let COLLAPSE_THRESHOLD : Float = 0.50;      // Below this, classical behavior

  // ═══════════════════════════════════════════════════════════════════════════
  // READ-OUT MODES — Animal-derived perception mechanisms
  // ═══════════════════════════════════════════════════════════════════════════

  public type ReadOutMode = {
    // Acoustic read-out (bat, dolphin)
    #Echolocation : EcholocationParams;
    #Biosonar : BiosonarParams;
    
    // Low-frequency read-out (elephant)
    #Infrasound : InfrasoundParams;
    
    // Electromagnetic read-out (shark, bird)
    #Electroreception : ElectroreceptionParams;
    #Magnetoreception : MagnetoreceptionParams;
    
    // Pattern read-out (bee)
    #WaggleDance : WaggleDanceParams;
    
    // Combined (octopus - distributed intelligence)
    #DistributedSensing : DistributedParams;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ECHOLOCATION — Bat architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Emit pulse → Wait for reflection → Build spatial map
  // Frequency: 20kHz - 200kHz
  // Time resolution: microseconds
  // ═══════════════════════════════════════════════════════════════════════════

  public type EcholocationParams = {
    pulseFrequency : Float;         // Hz (typically 20k-200k)
    pulseDuration : Float;          // seconds
    pulseInterval : Float;          // time between pulses
    frequencyModulation : Bool;     // FM sweep or constant frequency
    sweepRange : ?(Float, Float);   // start/end frequency if FM
  };

  public type EchoReturn = {
    delay : Float;                  // Time to return (distance encoding)
    dopplerShift : Float;           // Frequency shift (velocity encoding)
    amplitude : Float;              // Reflection strength (size/material)
    azimuth : Float;                // Direction (from binaural difference)
    elevation : Float;              // Vertical angle
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BIOSONAR — Dolphin architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Broadband clicks + FM whistles for communication
  // Can "see" inside objects (like ultrasound imaging)
  // ═══════════════════════════════════════════════════════════════════════════

  public type BiosonarParams = {
    clickBandwidth : (Float, Float);  // Frequency range of clicks
    clickRate : Float;                // Clicks per second
    whistleFrequency : Float;         // Communication whistle base
    whistleContour : [Float];         // Frequency modulation pattern
    beamWidth : Float;                // Sonar beam angle
  };

  public type SonarImage = {
    range : Float;
    crossSection : Float;             // Acoustic cross-section (size)
    internalStructure : [Float];      // Density variations inside object
    surfaceTexture : Float;           // Roughness measure
    materialSignature : Text;         // Identified material type
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INFRASOUND — Elephant architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Sub-20Hz rumbles travel through ground and air for kilometers
  // Seismic sensing through feet
  // ═══════════════════════════════════════════════════════════════════════════

  public type InfrasoundParams = {
    frequency : Float;                // Hz (typically 1-20)
    amplitude : Float;                // Pressure amplitude
    duration : Float;                 // Rumble duration
    groundCoupling : Float;           // How much goes through earth
    airCoupling : Float;              // How much goes through air
  };

  public type SeismicPerception = {
    groundVibration : Float;          // Detected through "feet"
    direction : Float;                // Source direction
    distance : Float;                 // Estimated from attenuation
    sourceType : Text;                // What made the vibration
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ELECTRORECEPTION — Shark architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Ampullae of Lorenzini detect electric fields
  // Can sense bioelectric fields of prey
  // Sensitivity: 5 nanovolts per centimeter
  // ═══════════════════════════════════════════════════════════════════════════

  public type ElectroreceptionParams = {
    sensitivity : Float;              // Minimum detectable field (V/m)
    frequencyRange : (Float, Float);  // Responsive frequency band
    spatialResolution : Float;        // Angular resolution
    channelCount : Nat;               // Number of ampullae
  };

  public type ElectricFieldPerception = {
    fieldStrength : Float;            // V/m
    fieldDirection : (Float, Float, Float);  // 3D vector
    frequency : Float;                // If oscillating
    bioelectricSignature : ?Text;     // Identified as living/electronic
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAGNETORECEPTION — Bird architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Cryptochrome proteins form radical pairs in magnetic field
  // Perceive Earth's magnetic field for navigation
  // May "see" magnetic field lines overlaid on vision
  // ═══════════════════════════════════════════════════════════════════════════

  public type MagnetoreceptionParams = {
    sensitivity : Float;              // Minimum detectable field (Tesla)
    inclinationSensing : Bool;        // Can sense field angle
    intensitySensing : Bool;          // Can sense field strength
    visualOverlay : Bool;             // Field visible in "vision"
  };

  public type MagneticPerception = {
    fieldIntensity : Float;           // Tesla
    inclination : Float;              // Angle from horizontal
    declination : Float;              // Angle from true north
    anomalyDetected : Bool;           // Local field distortion
    anomalySource : ?Text;            // What's causing anomaly
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // WAGGLE DANCE — Bee architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Encode vector information in oscillation pattern
  // Dance angle = direction relative to sun
  // Dance duration = distance
  // Waggle frequency = quality of source
  // ═══════════════════════════════════════════════════════════════════════════

  public type WaggleDanceParams = {
    waggleAngle : Float;              // Direction encoding (relative to gravity/sun)
    waggleDuration : Float;           // Distance encoding
    waggleFrequency : Float;          // Quality/excitement encoding
    returnPhase : Float;              // Reset phase of dance
    repetitions : Nat;                // How many times to dance
  };

  public type DancePerception = {
    decodedDirection : Float;         // Radians from reference
    decodedDistance : Float;          // Meters
    sourceQuality : Float;            // 0-1 rating
    confidence : Float;               // How clear was the dance
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DISTRIBUTED SENSING — Octopus architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // 2/3 of neurons in arms, not central brain
  // Each arm can sense and act semi-independently
  // Central brain sets goals, arms figure out how
  // ═══════════════════════════════════════════════════════════════════════════

  public type DistributedParams = {
    nodeCount : Nat;                  // Number of sensing nodes
    autonomyLevel : Float;            // How independent each node is
    centralCoherence : Float;         // How synchronized with central
    chemoreception : Bool;            // Chemical sensing
    tactileResolution : Float;        // Touch sensitivity
  };

  public type DistributedPerception = {
    nodeStates : [(Nat, Float, Float)]; // (nodeId, activation, phase)
    consensusState : Float;            // Collective agreement
    localActions : [Text];             // What each node is doing
    emergentBehavior : ?Text;          // What the collective is doing
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPERPOSITION STATE — The organism's quantum-like state
  // ═══════════════════════════════════════════════════════════════════════════

  public type SuperpositionState = {
    excitation : Float;               // How excited (0-1)
    coherence : Float;                // Phase coherence across system
    extension : Float;                // How far superposition extends
    readOutModes : [ReadOutMode];     // Active perception mechanisms
    collapsed : Bool;                 // Has it collapsed to classical?
  };

  public func initSuperposition() : SuperpositionState {
    {
      excitation = 0.0;
      coherence = 1.0;                // Start fully coherent
      extension = 0.0;
      readOutModes = [];
      collapsed = false;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // EXCITATION — Building up superposition
  // ═══════════════════════════════════════════════════════════════════════════

  public func excite(state : SuperpositionState, energy : Float) : SuperpositionState {
    let newExcitation = Float.min(1.0, state.excitation + energy);
    let newExtension = if (newExcitation >= EXTENSION_THRESHOLD) {
      // Superposition extends into physical world
      (newExcitation - EXTENSION_THRESHOLD) / (1.0 - EXTENSION_THRESHOLD)
    } else {
      0.0
    };
    
    {
      excitation = newExcitation;
      coherence = state.coherence;
      extension = newExtension;
      readOutModes = state.readOutModes;
      collapsed = newExcitation < COLLAPSE_THRESHOLD;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIVATE READ-OUT MODE — Enable an animal-derived perception mechanism
  // ═══════════════════════════════════════════════════════════════════════════

  public func activateReadOut(
    state : SuperpositionState,
    mode : ReadOutMode
  ) : SuperpositionState {
    // Can only activate if excitation is high enough
    if (state.excitation < EXCITATION_THRESHOLD) {
      return state;
    };
    
    {
      excitation = state.excitation;
      coherence = state.coherence;
      extension = state.extension;
      readOutModes = Array.append(state.readOutModes, [mode]);
      collapsed = state.collapsed;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // EMIT — Send a wave into the physical world
  // ═══════════════════════════════════════════════════════════════════════════

  public type Emission = {
    mode : ReadOutMode;
    timestamp : Int;
    energy : Float;
    phase : Float;
    targetDirection : ?(Float, Float, Float);  // 3D direction if directional
  };

  public func emit(
    state : SuperpositionState,
    mode : ReadOutMode,
    energy : Float,
    phase : Float,
    direction : ?(Float, Float, Float)
  ) : (SuperpositionState, ?Emission) {
    // Can only emit if extended into physical world
    if (state.extension < 0.5) {
      return (state, null);
    };
    
    let emission : Emission = {
      mode = mode;
      timestamp = Time.now();
      energy = energy * state.extension;  // Scaled by extension
      phase = phase;
      targetDirection = direction;
    };
    
    // Emission costs excitation
    let newState = {
      excitation = Float.max(0.0, state.excitation - energy * 0.1);
      coherence = state.coherence;
      extension = state.extension;
      readOutModes = state.readOutModes;
      collapsed = state.collapsed;
    };
    
    (newState, ?emission)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PERCEIVE — Receive information from physical world
  // ═══════════════════════════════════════════════════════════════════════════

  public type Perception = {
    mode : ReadOutMode;
    timestamp : Int;
    rawSignal : [Float];              // Raw sensor data
    coherenceWithEmission : Float;    // How well it matches what we sent
    interpretedMeaning : ?Text;       // What we think it means
  };

  public func perceive(
    state : SuperpositionState,
    mode : ReadOutMode,
    signal : [Float]
  ) : (SuperpositionState, Perception) {
    let perception : Perception = {
      mode = mode;
      timestamp = Time.now();
      rawSignal = signal;
      coherenceWithEmission = computeSignalCoherence(signal);
      interpretedMeaning = interpretSignal(mode, signal);
    };
    
    // Perception maintains excitation if coherent
    let newExcitation = if (perception.coherenceWithEmission > 0.7) {
      Float.min(1.0, state.excitation + 0.05)  // Good perception boosts excitation
    } else {
      Float.max(0.0, state.excitation - 0.02)  // Noise degrades excitation
    };
    
    let newState = {
      excitation = newExcitation;
      coherence = state.coherence * 0.99 + perception.coherenceWithEmission * 0.01;
      extension = state.extension;
      readOutModes = state.readOutModes;
      collapsed = newExcitation < COLLAPSE_THRESHOLD;
    };
    
    (newState, perception)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  func computeSignalCoherence(signal : [Float]) : Float {
    if (signal.size() == 0) return 0.0;
    
    // Compute autocorrelation at lag 1 as proxy for coherence
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var sumProd : Float = 0.0;
    
    for (i in Array.keys(signal)) {
      sum += signal[i];
      sumSq += signal[i] * signal[i];
      if (i > 0) {
        sumProd += signal[i] * signal[i - 1];
      };
    };
    
    let n = Float.fromInt(signal.size());
    let mean = sum / n;
    let variance = sumSq / n - mean * mean;
    
    if (variance < 1e-10) return 1.0;
    
    let covariance = sumProd / (n - 1.0) - mean * mean;
    Float.abs(covariance / variance)
  };

  func interpretSignal(mode : ReadOutMode, signal : [Float]) : ?Text {
    // Signal interpretation depends on mode
    // This is where the animal architecture maps signal → meaning
    switch (mode) {
      case (#Echolocation(_)) {
        if (signal.size() > 0 and signal[0] > 0.5) {
          ?"Object detected"
        } else {
          ?"Clear path"
        }
      };
      case (#Biosonar(_)) {
        ?"Sonar return processed"
      };
      case (#Infrasound(_)) {
        ?"Seismic activity perceived"
      };
      case (#Electroreception(_)) {
        ?"Electric field mapped"
      };
      case (#Magnetoreception(_)) {
        ?"Magnetic field sensed"
      };
      case (#WaggleDance(_)) {
        ?"Vector information decoded"
      };
      case (#DistributedSensing(_)) {
        ?"Distributed consensus reached"
      };
    }
  };

}
