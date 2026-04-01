// ============================================================
// MANTIS SHRIMP — HYPERSPECTRAL VISION & ULTRAFAST STRIKE
// 16 types of photoreceptors (humans have 3)
// Polarization vision, UV-IR spectrum
// Strike acceleration: 10,400g, cavitation bubbles
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let NUM_PHOTORECEPTORS : Nat = 16;
  let STRIKE_THRESHOLD : Float = 0.85;
  let MAX_STRIKE_SPEED : Float = 23.0;  // m/s

  // ── Types ─────────────────────────────────────────────────────
  public type SpectralChannel = {
    wavelength    : Float;   // nm (300-700)
    sensitivity   : Float;   // 0-1 response
    polarization  : Float;   // 0-1 polarization angle response
    activation    : Float;   // Current activation
  };

  public type VisualField = {
    leftEye       : [Float];  // 16 channel activations
    rightEye      : [Float];  // 16 channel activations
    stereopsis    : Float;    // Depth perception quality
    motionDetect  : Float;    // Motion sensitivity
    polarizationMap: [Float]; // 8 polarization angles
  };

  public type StrikeSystem = {
    cocked        : Bool;     // Ready to strike
    charge        : Float;    // Energy stored (0-1)
    targetLocked  : Bool;
    targetDistance: Float;    // mm
    targetSize    : Float;    // Estimated size
    strikeReady   : Float;    // Confidence to strike
    lastStrike    : Nat;      // Beat of last strike
    cooldown      : Float;    // Recovery state
  };

  public type PolarizationSignal = {
    angle         : Float;    // 0-180 degrees
    intensity     : Float;
    meaning       : SignalMeaning;
  };

  public type SignalMeaning = {
    #Threat;
    #Mate;
    #Territory;
    #Neutral;
  };

  public type MantisState = {
    // Vision system
    visualField   : VisualField;
    colorAnalysis : Float;     // How much color info extracted
    polarAnalysis : Float;     // Polarization processing

    // Strike apparatus
    strikeSystem  : StrikeSystem;
    strikeCount   : Nat;       // Lifetime strikes

    // Target tracking
    targetPresent : Bool;
    targetVelocity: Float;
    interceptPoint: Float;     // Predicted intercept

    // Communication
    bodyPattern   : [Float];   // Meral spot display (4 values)
    polarSignal   : PolarizationSignal;
    signalIntent  : SignalMeaning;

    // Territorial state
    territoryLevel: Float;
    aggressionLevel: Float;
    caution       : Float;

    beatNum       : Nat;
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Spectral Processing ───────────────────────────────────────
  // 16-channel color analysis (far beyond human RGB)
  public func processSpectrum(
    channels: [SpectralChannel], inputSpectrum: [Float]
  ) : [Float] {
    Array.tabulate<Float>(NUM_PHOTORECEPTORS, func(i) {
      if (i < channels.size() and i < inputSpectrum.size()) {
        let c = channels[i];
        _clamp(inputSpectrum[i] * c.sensitivity, 0.0, 1.0)
      } else { 0.0 }
    })
  };

  // ── Polarization Vision ───────────────────────────────────────
  // Detect polarized light patterns (invisible to most animals)
  public func analyzePolarization(
    polarInputs: [Float]
  ) : (Float, Float) {
    // Returns (dominant angle, confidence)
    var maxPol : Float = 0.0;
    var maxAngle : Nat = 0;

    var i = 0;
    while (i < 8 and i < polarInputs.size()) {
      if (polarInputs[i] > maxPol) {
        maxPol := polarInputs[i];
        maxAngle := i;
      };
      i += 1;
    };

    let angle = Float.fromInt(maxAngle) * 22.5;  // 8 angles = 22.5° each
    (angle, maxPol)
  };

  // ── Stereoscopic Depth ────────────────────────────────────────
  // Each eye has trinocular vision (3 focal regions)
  public func computeDepth(
    leftActivations: [Float], rightActivations: [Float]
  ) : Float {
    var disparity : Float = 0.0;
    let n = Nat.min(leftActivations.size(), rightActivations.size());

    var i = 0;
    while (i < n) {
      disparity += Float.abs(leftActivations[i] - rightActivations[i]);
      i += 1;
    };

    // Lower disparity = farther target
    _clamp(1.0 - disparity / Float.fromInt(n), 0.0, 1.0)
  };

  // ── Strike Decision ───────────────────────────────────────────
  public func evaluateStrike(
    system: StrikeSystem, targetPresent: Bool, targetDistance: Float
  ) : Float {
    if (not targetPresent) { return 0.0 };
    if (system.cooldown > 0.1) { return 0.0 };
    if (not system.cocked) { return 0.0 };

    // Optimal strike range: 10-50mm
    let rangeScore = if (targetDistance < 10.0) { 0.3 }
                     else if (targetDistance > 50.0) { 0.2 }
                     else { 1.0 };

    let chargeScore = system.charge;
    let lockScore = if (system.targetLocked) { 1.0 } else { 0.5 };

    _clamp(rangeScore * chargeScore * lockScore, 0.0, 1.0)
  };

  // ── Strike Execution ──────────────────────────────────────────
  public func executeStrike(system: StrikeSystem, beat: Nat) : StrikeSystem {
    // Release stored energy in ~3 milliseconds
    {
      cocked = false;
      charge = 0.0;
      targetLocked = false;
      targetDistance = system.targetDistance;
      targetSize = system.targetSize;
      strikeReady = 0.0;
      lastStrike = beat;
      cooldown = 1.0;  // Full cooldown needed
    }
  };

  // ── Strike Recharge ───────────────────────────────────────────
  public func rechargeStrike(system: StrikeSystem) : StrikeSystem {
    if (system.cocked) { return system };

    let newCharge = _clamp(system.charge + 0.05, 0.0, 1.0);
    let newCooldown = _clamp(system.cooldown - 0.02, 0.0, 1.0);
    let readyToCock = newCharge >= 0.9 and newCooldown < 0.1;

    {
      cocked = readyToCock;
      charge = newCharge;
      targetLocked = system.targetLocked;
      targetDistance = system.targetDistance;
      targetSize = system.targetSize;
      strikeReady = system.strikeReady;
      lastStrike = system.lastStrike;
      cooldown = newCooldown;
    }
  };

  // ── Body Pattern Display ──────────────────────────────────────
  // Meral spots for communication
  public func generateDisplay(
    aggression: Float, territory: Float
  ) : [Float] {
    // 4 display components: size, color intensity, flash rate, spread
    [
      _clamp(aggression * 0.8 + territory * 0.2, 0.0, 1.0),  // Size
      _clamp(aggression, 0.0, 1.0),                           // Color
      _clamp(aggression * 0.5, 0.0, 1.0),                     // Flash
      _clamp(territory, 0.0, 1.0)                             // Spread
    ]
  };

  // ── Polarization Signaling ────────────────────────────────────
  public func generatePolarSignal(intent: SignalMeaning) : PolarizationSignal {
    switch (intent) {
      case (#Threat) {
        { angle = 90.0; intensity = 0.9; meaning = #Threat }
      };
      case (#Mate) {
        { angle = 45.0; intensity = 0.7; meaning = #Mate }
      };
      case (#Territory) {
        { angle = 0.0; intensity = 0.8; meaning = #Territory }
      };
      case (#Neutral) {
        { angle = 135.0; intensity = 0.3; meaning = #Neutral }
      };
    }
  };

  // ── Motion Detection ──────────────────────────────────────────
  public func detectMotion(
    currentActivations: [Float], previousActivations: [Float]
  ) : Float {
    var totalMotion : Float = 0.0;
    let n = Nat.min(currentActivations.size(), previousActivations.size());

    var i = 0;
    while (i < n) {
      totalMotion += Float.abs(currentActivations[i] - previousActivations[i]);
      i += 1;
    };

    _clamp(totalMotion / Float.fromInt(n) * 5.0, 0.0, 1.0)
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatMantis(
    state: MantisState,
    leftInput: [Float],
    rightInput: [Float],
    polarInput: [Float],
    targetSignal: Float
  ) : MantisState {
    // Process visual input
    let leftAct = leftInput;
    let rightAct = rightInput;

    // Compute depth from stereo
    let depth = computeDepth(leftAct, rightAct);

    // Analyze polarization
    let (polAngle, polConf) = analyzePolarization(polarInput);

    // Motion detection
    let motion = detectMotion(leftAct, state.visualField.leftEye);

    // Update visual field
    let newVisual : VisualField = {
      leftEye = leftAct;
      rightEye = rightAct;
      stereopsis = depth;
      motionDetect = motion;
      polarizationMap = polarInput;
    };

    // Target tracking
    let targetPresent = targetSignal > 0.3;
    let targetDist = (1.0 - depth) * 100.0;  // Convert depth to mm estimate

    // Update strike system
    var newStrike = rechargeStrike(state.strikeSystem);
    newStrike := {
      cocked = newStrike.cocked;
      charge = newStrike.charge;
      targetLocked = targetPresent and motion < 0.3;  // Lock on still targets
      targetDistance = targetDist;
      targetSize = targetSignal;
      strikeReady = evaluateStrike(newStrike, targetPresent, targetDist);
      lastStrike = newStrike.lastStrike;
      cooldown = newStrike.cooldown;
    };

    // Execute strike if ready
    var strikeCount = state.strikeCount;
    if (newStrike.strikeReady > STRIKE_THRESHOLD) {
      newStrike := executeStrike(newStrike, state.beatNum + 1);
      strikeCount += 1;
    };

    // Predict intercept point for moving targets
    let intercept = if (motion > 0.5) {
      targetDist + state.targetVelocity * 10.0  // Predict 10 beat ahead
    } else { targetDist };

    // Update aggression based on territory and threats
    let newAggression = _clamp(
      state.aggressionLevel * 0.95 + motion * 0.1 + (1.0 - depth) * 0.05,
      0.0, 1.0
    );

    // Update caution
    let newCaution = _clamp(
      state.caution * 0.9 + motion * 0.2,
      0.0, 1.0
    );

    // Generate body display
    let newPattern = generateDisplay(newAggression, state.territoryLevel);

    // Determine signal intent
    let newIntent = if (newAggression > 0.7) { #Threat }
                    else if (state.territoryLevel > 0.8) { #Territory }
                    else { #Neutral };

    let newPolarSignal = generatePolarSignal(newIntent);

    // Color and polarization analysis quality
    let newColorAnalysis = _clamp(
      state.colorAnalysis * 0.95 + depth * 0.05,
      0.0, 1.0
    );
    let newPolarAnalysis = _clamp(
      state.polarAnalysis * 0.9 + polConf * 0.1,
      0.0, 1.0
    );

    {
      visualField = newVisual;
      colorAnalysis = newColorAnalysis;
      polarAnalysis = newPolarAnalysis;
      strikeSystem = newStrike;
      strikeCount = strikeCount;
      targetPresent = targetPresent;
      targetVelocity = motion * 10.0;  // Rough velocity estimate
      interceptPoint = intercept;
      bodyPattern = newPattern;
      polarSignal = newPolarSignal;
      signalIntent = newIntent;
      territoryLevel = state.territoryLevel;
      aggressionLevel = newAggression;
      caution = newCaution;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initMantis() : MantisState {
    {
      visualField = {
        leftEye = Array.tabulate<Float>(16, func(_) { 0.0 });
        rightEye = Array.tabulate<Float>(16, func(_) { 0.0 });
        stereopsis = 0.5;
        motionDetect = 0.0;
        polarizationMap = Array.tabulate<Float>(8, func(_) { 0.0 });
      };
      colorAnalysis = 0.5;
      polarAnalysis = 0.5;
      strikeSystem = {
        cocked = true;
        charge = 1.0;
        targetLocked = false;
        targetDistance = 0.0;
        targetSize = 0.0;
        strikeReady = 0.0;
        lastStrike = 0;
        cooldown = 0.0;
      };
      strikeCount = 0;
      targetPresent = false;
      targetVelocity = 0.0;
      interceptPoint = 0.0;
      bodyPattern = [0.0, 0.0, 0.0, 0.0];
      polarSignal = { angle = 0.0; intensity = 0.0; meaning = #Neutral };
      signalIntent = #Neutral;
      territoryLevel = 0.5;
      aggressionLevel = 0.0;
      caution = 0.0;
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type MantisSummary = {
    stereopsis      : Float;
    motionDetect    : Float;
    polarAnalysis   : Float;
    strikeReady     : Float;
    strikeCocked    : Bool;
    aggressionLevel : Float;
    strikeCount     : Nat;
  };

  public func summary(state: MantisState) : MantisSummary {
    {
      stereopsis = state.visualField.stereopsis;
      motionDetect = state.visualField.motionDetect;
      polarAnalysis = state.polarAnalysis;
      strikeReady = state.strikeSystem.strikeReady;
      strikeCocked = state.strikeSystem.cocked;
      aggressionLevel = state.aggressionLevel;
      strikeCount = state.strikeCount;
    }
  };

}
