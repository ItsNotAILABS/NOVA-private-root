import Array "mo:base/Array";
import Float "mo:base/Float";
import Nat "mo:base/Nat";

module {
  public type Vector3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  public type CCVEInput = {
    heartPhase : Float;
    brainPhase : Float;
    heartFrequency : Float;
    brainFrequency : Float;
    heartbeatCoherence : Float;
    jDrift : Float;
    doctrineDirection : Vector3;
    contextDirection : Vector3;
  };

  public type CCVEState = {
    resonance : Float;       // Heart-brain resonance [0,1]
    phaseLag : Float;        // Wrapped phase lag in radians [-pi, pi]
    direction : Vector3;     // Normalized direction vector
    propulsion : Float;      // Push magnitude [0,2]
    alignment : Float;       // Alignment with doctrine direction [0,1]
    pushEffectiveness : Float; // Combined alignment + propulsion score
    beatNum : Nat;
    resonanceHistory : [Float];
    propulsionHistory : [Float];
  };

  let PI : Float = 3.14159265358979323846;
  let TAU : Float = 6.28318530717958647692;
  let EPS : Float = 0.0000001;
  let HISTORY_LIMIT : Nat = 128;

  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x : Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func wrapPi(x : Float) : Float {
    var y = x;
    while (y > PI) { y -= TAU };
    while (y < -PI) { y += TAU };
    y
  };

  func norm(v : Vector3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };

  func normalize(v : Vector3) : Vector3 {
    let n = norm(v);
    if (n < EPS) {
      { x = 0.0; y = 0.0; z = 1.0 }
    } else {
      { x = v.x / n; y = v.y / n; z = v.z / n }
    }
  };

  func add(a : Vector3, b : Vector3) : Vector3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };

  func scale(v : Vector3, s : Float) : Vector3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };

  func dot(a : Vector3, b : Vector3) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };

  func appendBounded(history : [Float], value : Float) : [Float] {
    if (history.size() < HISTORY_LIMIT) {
      Array.append<Float>(history, [value])
    } else {
      let tail = Array.tabulate<Float>(HISTORY_LIMIT - 1, func(i : Nat) : Float { history[i + 1] });
      Array.append<Float>(tail, [value])
    }
  };

  public func initCCVE() : CCVEState {
    {
      resonance = 0.75;
      phaseLag = 0.0;
      direction = { x = 0.0; y = 0.0; z = 1.0 };
      propulsion = 1.0;
      alignment = 1.0;
      pushEffectiveness = 1.0;
      beatNum = 0;
      resonanceHistory = [];
      propulsionHistory = [];
    }
  };

  // Cardio-cerebral vector update:
  // - couples heart/brain phase and frequency
  // - computes doctrine-aligned direction vector
  // - computes propulsion (push) along that direction
  public func tickCCVE(
    state : CCVEState,
    input : CCVEInput,
    beat : Nat
  ) : CCVEState {
    let phaseLag = wrapPi(input.brainPhase - input.heartPhase);
    let phaseLock = (Float.cos(phaseLag) + 1.0) * 0.5; // [0,1]

    let maxFreq = Float.max(Float.max(input.heartFrequency, input.brainFrequency), EPS);
    let freqDelta = abs(input.brainFrequency - input.heartFrequency) / maxFreq;
    let freqMatch = clamp(1.0 - freqDelta, 0.0, 1.0);

    let resonanceRaw = 0.6 * phaseLock + 0.4 * freqMatch;
    let resonance = clamp(
      0.85 * state.resonance + 0.15 * resonanceRaw,
      0.0,
      1.0
    );

    let doctrineDir = normalize(input.doctrineDirection);
    let driftComp = scale(doctrineDir, -input.jDrift * 0.25);
    let context = scale(input.contextDirection, 0.35);
    let prior = scale(state.direction, 0.15);
    let direction = normalize(add(add(add(doctrineDir, context), driftComp), prior));

    let alignment = clamp((dot(direction, doctrineDir) + 1.0) * 0.5, 0.0, 1.0);

    let propulsionRaw =
      resonance * (0.70 + 0.30 * input.heartbeatCoherence)
      - 0.50 * input.jDrift;
    let propulsion = clamp(0.85 * state.propulsion + 0.15 * propulsionRaw, 0.0, 2.0);

    let pushEffectiveness = clamp(
      propulsion * alignment * (0.5 + 0.5 * input.heartbeatCoherence),
      0.0,
      2.0
    );

    {
      resonance = resonance;
      phaseLag = phaseLag;
      direction = direction;
      propulsion = propulsion;
      alignment = alignment;
      pushEffectiveness = pushEffectiveness;
      beatNum = beat;
      resonanceHistory = appendBounded(state.resonanceHistory, resonance);
      propulsionHistory = appendBounded(state.propulsionHistory, propulsion);
    }
  };
}
