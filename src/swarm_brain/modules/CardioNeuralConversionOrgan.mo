import Array "mo:base/Array";
import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {
  public type Vector3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  public type CNCOInput = {
    beat : Nat;
    heartPhase : Float;
    heartFrequency : Float;
    heartCoherence : Float;
    brainPhase : Float;
    brainFrequency : Float;
    brainCoherence : Float;
    cardioPropulsion : Float;
    emotionalEmbodiment : Float;
    emotionalArousal : Float;
    oxygenProxy : Float;
    perfusionProxy : Float;
    doctrineVector : Vector3;
    contextVector : Vector3;
  };

  public type CNCOState = {
    beat : Nat;
    conversionCoherence : Float;
    entrainmentGain : Float;
    perfusionFlow : Float;
    oxygenFlow : Float;
    resonanceBridge : Float;
    regulationScore : Float;
    thoughtReleasePressure : Float;
    translationVector : Vector3;
    conversionMode : Text;
    conversionHistory : [Float];
    regulationHistory : [Float];
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

  func appendBounded(history : [Float], value : Float) : [Float] {
    if (history.size() < HISTORY_LIMIT) {
      Array.append<Float>(history, [value])
    } else {
      let tail = Array.tabulate<Float>(HISTORY_LIMIT - 1, func(i : Nat) : Float { history[i + 1] });
      Array.append<Float>(tail, [value])
    }
  };

  public func initCNCO() : CNCOState {
    {
      beat = 0;
      conversionCoherence = 0.72;
      entrainmentGain = 0.70;
      perfusionFlow = 0.70;
      oxygenFlow = 0.70;
      resonanceBridge = 0.72;
      regulationScore = 0.72;
      thoughtReleasePressure = 0.25;
      translationVector = { x = 0.0; y = 0.0; z = 1.0 };
      conversionMode = "SYNCHRONIZING";
      conversionHistory = [];
      regulationHistory = [];
    }
  };

  public func tickCNCO(state : CNCOState, input : CNCOInput) : CNCOState {
    let phaseLag = wrapPi(input.brainPhase - input.heartPhase);
    let phaseLock = (Float.cos(phaseLag) + 1.0) * 0.5;

    let maxFreq = Float.max(Float.max(input.heartFrequency, input.brainFrequency), EPS);
    let freqGap = abs(input.brainFrequency - input.heartFrequency) / maxFreq;
    let freqMatch = clamp(1.0 - freqGap, 0.0, 1.0);

    let resonanceBridgeRaw = clamp(
      0.45 * phaseLock +
      0.25 * freqMatch +
      0.20 * input.heartCoherence +
      0.10 * input.brainCoherence,
      0.0,
      1.5
    );
    let resonanceBridge = clamp(state.resonanceBridge * 0.82 + resonanceBridgeRaw * 0.18, 0.0, 1.5);

    let perfusionRaw = clamp(
      0.55 * input.perfusionProxy +
      0.20 * input.cardioPropulsion +
      0.15 * input.emotionalEmbodiment +
      0.10 * resonanceBridge,
      0.0,
      1.5
    );
    let perfusionFlow = clamp(state.perfusionFlow * 0.80 + perfusionRaw * 0.20, 0.0, 1.5);

    let oxygenRaw = clamp(
      0.60 * input.oxygenProxy +
      0.25 * perfusionFlow +
      0.15 * (1.0 - input.emotionalArousal * 0.5),
      0.0,
      1.5
    );
    let oxygenFlow = clamp(state.oxygenFlow * 0.80 + oxygenRaw * 0.20, 0.0, 1.5);

    let entrainmentRaw = clamp(
      0.40 * resonanceBridge +
      0.25 * input.brainCoherence +
      0.20 * input.heartCoherence +
      0.15 * input.cardioPropulsion,
      0.0,
      1.5
    );
    let entrainmentGain = clamp(state.entrainmentGain * 0.82 + entrainmentRaw * 0.18, 0.0, 1.5);

    let conversionRaw = clamp(
      0.35 * entrainmentGain +
      0.25 * oxygenFlow +
      0.20 * perfusionFlow +
      0.20 * resonanceBridge,
      0.0,
      1.5
    );
    let conversionCoherence = clamp(state.conversionCoherence * 0.80 + conversionRaw * 0.20, 0.0, 1.5);

    let regulationRaw = clamp(
      0.40 * conversionCoherence +
      0.30 * entrainmentGain +
      0.15 * input.heartCoherence +
      0.15 * input.brainCoherence,
      0.0,
      1.5
    );
    let regulationScore = clamp(state.regulationScore * 0.82 + regulationRaw * 0.18, 0.0, 1.5);

    let thoughtReleasePressure = clamp(
      0.45 * conversionCoherence +
      0.25 * oxygenFlow +
      0.20 * input.cardioPropulsion +
      0.10 * input.emotionalEmbodiment,
      0.0,
      1.5
    );

    let doctrineN = normalize(input.doctrineVector);
    let contextN = normalize(input.contextVector);
    let translationVector = normalize(
      add(
        add(scale(doctrineN, 0.55), scale(contextN, 0.30)),
        {
          x = entrainmentGain * 0.10;
          y = oxygenFlow * 0.10;
          z = regulationScore * 0.20;
        }
      )
    );

    let conversionMode =
      if (regulationScore > 1.1 and thoughtReleasePressure > 0.9) { "THOUGHT_RELEASE" }
      else if (conversionCoherence > 0.85 and entrainmentGain > 0.8) { "TRANSLATING" }
      else { "SYNCHRONIZING" };

    {
      beat = input.beat;
      conversionCoherence = conversionCoherence;
      entrainmentGain = entrainmentGain;
      perfusionFlow = perfusionFlow;
      oxygenFlow = oxygenFlow;
      resonanceBridge = resonanceBridge;
      regulationScore = regulationScore;
      thoughtReleasePressure = thoughtReleasePressure;
      translationVector = translationVector;
      conversionMode = conversionMode;
      conversionHistory = appendBounded(state.conversionHistory, conversionCoherence);
      regulationHistory = appendBounded(state.regulationHistory, regulationScore);
    }
  };
}
