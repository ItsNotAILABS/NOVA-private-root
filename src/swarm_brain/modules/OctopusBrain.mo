// ============================================================
// OCTOPUS BRAIN — DISTRIBUTED INTELLIGENCE MODULE
// 9 semi-autonomous ganglia (1 central + 8 arm brains)
// 500 million neurons, 2/3 in arms — local decision making
// Chromatophore control, texture/color camouflage
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let NUM_ARMS : Nat = 8;
  let CENTRAL_WEIGHT : Float = 0.4;  // Central brain influence
  let ARM_AUTONOMY : Float = 0.6;    // Arm-level autonomy

  // ── Types ─────────────────────────────────────────────────────
  public type ArmGanglion = {
    activation     : Float;       // Local arm activation
    motorCommand   : Float;       // Local motor output
    sensorInput    : Float;       // Chemotactile input
    suckerDensity  : Float;       // Sucker sensory density
    autonomyLevel  : Float;       // How independent this arm is
    lastCommand    : Float;       // Previous central command
    localMemory    : [Float];     // Short-term arm memory (10 beats)
  };

  public type ChromatophoreState = {
    red       : Float;
    yellow    : Float;
    brown     : Float;
    iridophore: Float;   // Reflective layer
    leucophore: Float;   // White scatter layer
    papillae  : Float;   // Skin texture (0=smooth, 1=spiky)
  };

  public type OctopusState = {
    // Central brain
    centralActivation : Float;
    centralCoherence  : Float;
    decisionConfidence: Float;

    // 8 arm ganglia
    arms : [ArmGanglion];

    // Camouflage system
    chromatophores : ChromatophoreState;
    camoMode       : CamoMode;

    // Coordination
    armSynchrony   : Float;    // How synchronized are arms
    explorationDrive: Float;   // Curiosity/exploration
    escapeUrgency  : Float;    // Threat response

    // Memory
    spatialMap     : [Float];  // 64-cell environment map
    objectMemory   : [Float];  // 16 remembered objects

    beatNum        : Nat;
  };

  public type CamoMode = {
    #Transparent;     // Background matching
    #Mottle;          // Disruptive pattern
    #Uniform;         // Solid color
    #Countershading;  // Light below, dark above
    #Deimatic;        // Startle display
    #Mimicry;         // Imitate another species
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func sigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-5.0 * (x - 0.5)))
  };

  // ── Arm Ganglion Update ───────────────────────────────────────
  // Each arm processes locally, with limited central override
  public func updateArm(
    arm: ArmGanglion, centralCommand: Float, sensorInput: Float
  ) : ArmGanglion {
    // Local processing: arm decides based on sensors + central hint
    let localDecision = sigmoid(sensorInput * 1.5 + arm.activation * 0.3);

    // Blend local decision with central command based on autonomy
    let blendedCommand = arm.autonomyLevel * localDecision +
                         (1.0 - arm.autonomyLevel) * centralCommand;

    // Update motor output with momentum
    let newMotor = 0.7 * arm.motorCommand + 0.3 * blendedCommand;

    // Shift memory buffer
    let memSize = arm.localMemory.size();
    let newMemory = Array.tabulate<Float>(memSize, func(i) {
      if (i == 0) { sensorInput }
      else if (i < memSize) { arm.localMemory[i - 1] }
      else { S0 }
    });

    {
      activation = _clamp(localDecision, S0, 1.0);
      motorCommand = _clamp(newMotor, 0.0, 1.0);
      sensorInput = sensorInput;
      suckerDensity = arm.suckerDensity;
      autonomyLevel = arm.autonomyLevel;
      lastCommand = centralCommand;
      localMemory = newMemory;
    }
  };

  // ── Arm Synchrony ─────────────────────────────────────────────
  // Measure how coordinated the 8 arms are
  public func computeArmSynchrony(arms: [ArmGanglion]) : Float {
    var sumPhase : Float = 0.0;
    var sumAct : Float = 0.0;

    for (arm in arms.vals()) {
      sumAct += arm.activation;
    };
    let meanAct = sumAct / 8.0;

    var variance : Float = 0.0;
    for (arm in arms.vals()) {
      let diff = arm.activation - meanAct;
      variance += diff * diff;
    };
    variance /= 8.0;

    // Low variance = high synchrony
    _clamp(1.0 - Float.sqrt(variance) * 2.0, 0.0, 1.0)
  };

  // ── Chromatophore Control ─────────────────────────────────────
  // Neural control of skin color/texture
  public func updateChromatophores(
    state: ChromatophoreState, threatLevel: Float, backgroundColors: [Float]
  ) : ChromatophoreState {
    // Background has 3 values: luminance, warmth, complexity
    let bgLum = if (backgroundColors.size() > 0) { backgroundColors[0] } else { 0.5 };
    let bgWarmth = if (backgroundColors.size() > 1) { backgroundColors[1] } else { 0.5 };
    let bgComplex = if (backgroundColors.size() > 2) { backgroundColors[2] } else { 0.5 };

    // If threatened, go deimatic (flash bright warning)
    if (threatLevel > 0.8) {
      return {
        red = 0.9;
        yellow = 0.8;
        brown = 0.1;
        iridophore = 0.9;
        leucophore = 0.2;
        papillae = 0.8;  // Spiky texture
      };
    };

    // Otherwise, match background
    {
      red = _clamp(bgWarmth * 0.6, 0.0, 1.0);
      yellow = _clamp(bgWarmth * 0.4 + bgLum * 0.2, 0.0, 1.0);
      brown = _clamp((1.0 - bgLum) * 0.7, 0.0, 1.0);
      iridophore = _clamp(bgLum * 0.5, 0.0, 1.0);
      leucophore = _clamp(bgLum * 0.3, 0.0, 1.0);
      papillae = _clamp(bgComplex * 0.8, 0.0, 1.0);
    }
  };

  // ── Central Decision Making ───────────────────────────────────
  public func centralDecision(
    state: OctopusState, environmentSignal: Float, threatSignal: Float
  ) : (Float, Float) {
    // Integrate arm feedback
    var armFeedback : Float = 0.0;
    for (arm in state.arms.vals()) {
      armFeedback += arm.activation * arm.sensorInput;
    };
    armFeedback /= 8.0;

    // Central activation integrates arm feedback + environment
    let newCentralAct = 0.6 * state.centralActivation +
                        0.2 * armFeedback +
                        0.1 * environmentSignal +
                        0.1 * (1.0 - threatSignal);

    // Decision confidence based on arm agreement
    let confidence = state.armSynchrony * 0.5 + (1.0 - threatSignal) * 0.5;

    (_clamp(newCentralAct, S0, 1.0), _clamp(confidence, 0.0, 1.0))
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatOctopus(
    state: OctopusState,
    armInputs: [Float],          // 8 sensory inputs for arms
    environmentSignal: Float,
    threatSignal: Float,
    backgroundColors: [Float]
  ) : OctopusState {
    // Update central brain
    let (newCentralAct, newConfidence) = centralDecision(
      state, environmentSignal, threatSignal
    );

    // Generate central command for arms
    let centralCommand = newCentralAct * newConfidence;

    // Update each arm
    let newArms = Array.tabulate<ArmGanglion>(NUM_ARMS, func(i) {
      let input = if (i < armInputs.size()) { armInputs[i] } else { S0 };
      updateArm(state.arms[i], centralCommand, input)
    });

    // Compute synchrony
    let newSynchrony = computeArmSynchrony(newArms);

    // Update chromatophores
    let newChroma = updateChromatophores(
      state.chromatophores, threatSignal, backgroundColors
    );

    // Determine camo mode
    let newCamoMode = if (threatSignal > 0.8) { #Deimatic }
                      else if (threatSignal > 0.5) { #Countershading }
                      else if (newSynchrony > 0.8) { #Uniform }
                      else { #Mottle };

    // Update exploration/escape drives
    let newExploration = _clamp(
      0.9 * state.explorationDrive + 0.1 * (1.0 - threatSignal) * newConfidence,
      0.0, 1.0
    );
    let newEscape = _clamp(
      0.7 * state.escapeUrgency + 0.3 * threatSignal,
      0.0, 1.0
    );

    // Central coherence: how well central brain is coordinating
    let newCoherence = _clamp(
      newSynchrony * 0.4 + newConfidence * 0.4 + newCentralAct * 0.2,
      S0, 1.0
    );

    {
      centralActivation = newCentralAct;
      centralCoherence = newCoherence;
      decisionConfidence = newConfidence;
      arms = newArms;
      chromatophores = newChroma;
      camoMode = newCamoMode;
      armSynchrony = newSynchrony;
      explorationDrive = newExploration;
      escapeUrgency = newEscape;
      spatialMap = state.spatialMap;
      objectMemory = state.objectMemory;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Jet Propulsion Decision ───────────────────────────────────
  // Escape mechanism: coordinate all arms for jet propulsion
  public func jetEscape(state: OctopusState) : Float {
    if (state.escapeUrgency < 0.7) { return 0.0 };

    // All arms must contract synchronously
    let jetPower = state.armSynchrony * state.escapeUrgency;
    _clamp(jetPower, 0.0, 1.0)
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initOctopus() : OctopusState {
    let defaultArm : ArmGanglion = {
      activation = S0;
      motorCommand = 0.0;
      sensorInput = S0;
      suckerDensity = 0.8;
      autonomyLevel = ARM_AUTONOMY;
      lastCommand = 0.0;
      localMemory = Array.tabulate<Float>(10, func(_) { S0 });
    };

    {
      centralActivation = S0;
      centralCoherence = S0;
      decisionConfidence = 0.5;
      arms = Array.tabulate<ArmGanglion>(8, func(i) {
        // Each arm has slightly different autonomy
        {
          activation = S0;
          motorCommand = 0.0;
          sensorInput = S0;
          suckerDensity = 0.7 + Float.fromInt(i) * 0.02;
          autonomyLevel = ARM_AUTONOMY + Float.fromInt(i % 3) * 0.05;
          lastCommand = 0.0;
          localMemory = Array.tabulate<Float>(10, func(_) { S0 });
        }
      });
      chromatophores = {
        red = 0.3;
        yellow = 0.3;
        brown = 0.4;
        iridophore = 0.2;
        leucophore = 0.2;
        papillae = 0.0;
      };
      camoMode = #Mottle;
      armSynchrony = 0.5;
      explorationDrive = 0.5;
      escapeUrgency = 0.0;
      spatialMap = Array.tabulate<Float>(64, func(_) { 0.0 });
      objectMemory = Array.tabulate<Float>(16, func(_) { 0.0 });
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type OctopusSummary = {
    centralCoherence   : Float;
    armSynchrony       : Float;
    decisionConfidence : Float;
    camoMode           : CamoMode;
    explorationDrive   : Float;
    escapeUrgency      : Float;
    jetPower           : Float;
  };

  public func summary(state: OctopusState) : OctopusSummary {
    {
      centralCoherence = state.centralCoherence;
      armSynchrony = state.armSynchrony;
      decisionConfidence = state.decisionConfidence;
      camoMode = state.camoMode;
      explorationDrive = state.explorationDrive;
      escapeUrgency = state.escapeUrgency;
      jetPower = jetEscape(state);
    }
  };

}
