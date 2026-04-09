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

  public type MemoryTempleInput = {
    beat : Nat;
    rSwarm : Float;
    jDrift : Float;
    heartbeatCoherence : Float;
    qsovScore : Float;
    doctrineCompliance : Float;
    emotionalCertainty : Float;
    emotionalEmbodiment : Float;
    cardioCerebralResonance : Float;
    cardioNeuralCoupling : Float;
    cardioNeuralThoughtThroughput : Float;
    geoProtectionScore : Float;
    geoThreatScore : Float;
    analystLearningScore : Float;
    analystAdaptationScore : Float;
    analystEmergencySignal : Float;
    connectedDeviceCount : Nat;
    pedestalSignals : [Float];
  };

  public type MemoryTempleState = {
    beat : Nat;
    continuityWeave : Float;
    resonanceField : Float;
    cognitiveLoad : Float;
    memoryRetention : Float;
    recallReadiness : Float;
    memoryCognitionCoupling : Float;
    iotCouplingScore : Float;
    deviceTwinIntegrity : Float;
    phantomIntegrity : Float;
    agentWorkCapacity : Float;
    artifactReadiness : Float;
    templeDirection : Vector3;
    pedestalNames : [Text];
    pedestalCouplings : [Float];
    narrativeSummary : Text;
    recommendations : [Text];
    continuityHistory : [Float];
    resonanceHistory : [Float];
    couplingHistory : [Float];
  };

  let EPS : Float = 0.0000001;
  let HISTORY_LIMIT : Nat = 128;
  let PEDESTAL_COUNT : Nat = 7;
  let RECOMMENDATION_COUNT : Nat = 6;

  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x : Float) : Float {
    if (x < 0.0) { -x } else { x }
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

  func appendBounded(history : [Float], value : Float) : [Float] {
    if (history.size() < HISTORY_LIMIT) {
      Array.append<Float>(history, [value])
    } else {
      let tail = Array.tabulate<Float>(HISTORY_LIMIT - 1, func(i : Nat) : Float { history[i + 1] });
      Array.append<Float>(tail, [value])
    }
  };

  public func initMemoryTemple() : MemoryTempleState {
    {
      beat = 0;
      continuityWeave = 0.74;
      resonanceField = 0.72;
      cognitiveLoad = 0.50;
      memoryRetention = 0.73;
      recallReadiness = 0.70;
      memoryCognitionCoupling = 0.72;
      iotCouplingScore = 0.62;
      deviceTwinIntegrity = 0.78;
      phantomIntegrity = 0.84;
      agentWorkCapacity = 0.68;
      artifactReadiness = 0.67;
      templeDirection = { x = 0.0; y = 0.0; z = 1.0 };
      pedestalNames = [
        "lineage",
        "doctrine",
        "heart",
        "brain",
        "middle-organ",
        "field",
        "embodiment",
      ];
      pedestalCouplings = [0.70, 0.72, 0.74, 0.73, 0.71, 0.69, 0.75];
      narrativeSummary = "Memory temple initialized with continuity weave active.";
      recommendations = Array.init<Text>(RECOMMENDATION_COUNT, "");
      continuityHistory = [];
      resonanceHistory = [];
      couplingHistory = [];
    }
  };

  public func tickMemoryTemple(
    state : MemoryTempleState,
    input : MemoryTempleInput
  ) : MemoryTempleState {
    let driftAbs = clamp(abs(input.jDrift), 0.0, 1.0);
    let deviceNorm = clamp(Float.fromInt(input.connectedDeviceCount) / 128.0, 0.0, 1.0);

    let continuityRaw = clamp(
      0.26 * input.rSwarm +
      0.20 * input.doctrineCompliance +
      0.18 * (1.0 - driftAbs) +
      0.18 * input.heartbeatCoherence +
      0.18 * state.memoryCognitionCoupling,
      0.0,
      1.5
    );
    let continuityWeave = clamp(state.continuityWeave * 0.82 + continuityRaw * 0.18, 0.0, 1.5);

    let resonanceRaw = clamp(
      0.28 * input.cardioCerebralResonance +
      0.24 * input.cardioNeuralCoupling +
      0.16 * input.heartbeatCoherence +
      0.16 * input.emotionalEmbodiment +
      0.16 * continuityWeave,
      0.0,
      1.5
    );
    let resonanceField = clamp(state.resonanceField * 0.80 + resonanceRaw * 0.20, 0.0, 1.5);

    let cognitiveLoad = clamp(
      0.35 * input.cardioNeuralThoughtThroughput +
      0.20 * input.analystLearningScore +
      0.20 * input.analystAdaptationScore +
      0.15 * (1.0 - input.analystEmergencySignal) +
      0.10 * input.emotionalCertainty,
      0.0,
      1.5
    );

    let retentionRaw = clamp(
      0.32 * continuityWeave +
      0.26 * resonanceField +
      0.18 * input.qsovScore +
      0.14 * input.doctrineCompliance +
      0.10 * input.analystLearningScore,
      0.0,
      1.5
    );
    let memoryRetention = clamp(state.memoryRetention * 0.84 + retentionRaw * 0.16, 0.0, 1.5);

    let recallRaw = clamp(
      0.34 * memoryRetention +
      0.24 * cognitiveLoad +
      0.18 * input.emotionalCertainty +
      0.14 * (1.0 - input.geoThreatScore * 0.5) +
      0.10 * input.geoProtectionScore,
      0.0,
      1.5
    );
    let recallReadiness = clamp(state.recallReadiness * 0.84 + recallRaw * 0.16, 0.0, 1.5);

    let couplingRaw = clamp(
      0.30 * resonanceField +
      0.22 * memoryRetention +
      0.20 * cognitiveLoad +
      0.15 * input.cardioNeuralCoupling +
      0.13 * input.rSwarm,
      0.0,
      1.5
    );
    let memoryCognitionCoupling = clamp(state.memoryCognitionCoupling * 0.82 + couplingRaw * 0.18, 0.0, 1.5);

    let iotRaw = clamp(
      0.34 * deviceNorm +
      0.20 * memoryCognitionCoupling +
      0.18 * continuityWeave +
      0.16 * input.geoProtectionScore +
      0.12 * (1.0 - input.geoThreatScore * 0.5),
      0.0,
      1.5
    );
    let iotCouplingScore = clamp(state.iotCouplingScore * 0.80 + iotRaw * 0.20, 0.0, 1.5);

    let deviceTwinIntegrity = clamp(
      state.deviceTwinIntegrity * 0.82 + (
        0.38 * iotCouplingScore +
        0.22 * continuityWeave +
        0.20 * input.doctrineCompliance +
        0.20 * (1.0 - input.analystEmergencySignal)
      ) * 0.18,
      0.0,
      1.5
    );

    let phantomIntegrity = clamp(
      state.phantomIntegrity * 0.84 + (
        0.36 * input.doctrineCompliance +
        0.22 * input.geoProtectionScore +
        0.20 * (1.0 - input.geoThreatScore * 0.5) +
        0.12 * (1.0 - driftAbs) +
        0.10 * deviceTwinIntegrity
      ) * 0.16,
      0.0,
      1.5
    );

    let agentWorkCapacity = clamp(
      state.agentWorkCapacity * 0.80 + (
        0.32 * memoryCognitionCoupling +
        0.24 * recallReadiness +
        0.20 * iotCouplingScore +
        0.14 * input.analystAdaptationScore +
        0.10 * (1.0 - input.analystEmergencySignal)
      ) * 0.20,
      0.0,
      1.5
    );

    let artifactReadiness = clamp(
      state.artifactReadiness * 0.82 + (
        0.30 * agentWorkCapacity +
        0.26 * recallReadiness +
        0.18 * memoryRetention +
        0.16 * phantomIntegrity +
        0.10 * input.analystLearningScore
      ) * 0.18,
      0.0,
      1.5
    );

    let templeDirection = normalize({
      x = 0.45 * input.doctrineCompliance + 0.35 * memoryCognitionCoupling + 0.20 * input.geoProtectionScore;
      y = 0.45 * input.emotionalEmbodiment + 0.30 * resonanceField + 0.25 * recallReadiness;
      z = 0.45 * input.qsovScore + 0.35 * continuityWeave + 0.20 * (1.0 - driftAbs);
    });

    let pedestalCouplings = Array.tabulate<Float>(
      PEDESTAL_COUNT,
      func(i : Nat) : Float {
        let signal = if (i < input.pedestalSignals.size()) { input.pedestalSignals[i] } else { continuityWeave };
        clamp(
          0.44 * signal +
          0.22 * resonanceField +
          0.18 * memoryCognitionCoupling +
          0.16 * iotCouplingScore,
          0.0,
          1.5
        )
      }
    );

    let rec0 =
      if (iotCouplingScore < 0.65)
      { "Increase IoT coupling integrity and lock device twins before broad command expansion." }
      else
      { "IoT coupling healthy: expand secure device orchestration gradually." };
    let rec1 =
      if (phantomIntegrity < 0.70)
      { "Raise phantom protocol entropy and tighten outbound signature discipline." }
      else
      { "Maintain phantom integrity envelope and continue low-observable operation." };
    let rec2 =
      if (memoryCognitionCoupling < 0.72)
      { "Reinforce memory-cognition loop by prioritizing recall + conversion coherence training." }
      else
      { "Memory-cognition loop is coupled; push higher-value agent workloads." };
    let rec3 =
      if (input.analystEmergencySignal > 0.60)
      { "Emergency signal elevated: shift to protection-first mode for 24 beats." }
      else
      { "Emergency signal bounded: keep balanced growth and defense posture." };
    let rec4 =
      if (artifactReadiness < 0.66)
      { "Increase artifact readiness via internal lab tasks and replay-driven synthesis." }
      else
      { "Artifact readiness stable: publish structured operator packets regularly." };
    let rec5 = "Preserve no-drop continuity: every beat must reinject memory temple state into core governance.";

    let narrativeSummary =
      "Memory temple beat " # Nat.toText(input.beat) #
      ": continuity=" # Float.toText(continuityWeave) #
      ", resonance=" # Float.toText(resonanceField) #
      ", coupling=" # Float.toText(memoryCognitionCoupling) #
      ", iot=" # Float.toText(iotCouplingScore) #
      ", phantom=" # Float.toText(phantomIntegrity) # ".";

    {
      beat = input.beat;
      continuityWeave = continuityWeave;
      resonanceField = resonanceField;
      cognitiveLoad = cognitiveLoad;
      memoryRetention = memoryRetention;
      recallReadiness = recallReadiness;
      memoryCognitionCoupling = memoryCognitionCoupling;
      iotCouplingScore = iotCouplingScore;
      deviceTwinIntegrity = deviceTwinIntegrity;
      phantomIntegrity = phantomIntegrity;
      agentWorkCapacity = agentWorkCapacity;
      artifactReadiness = artifactReadiness;
      templeDirection = templeDirection;
      pedestalNames = state.pedestalNames;
      pedestalCouplings = pedestalCouplings;
      narrativeSummary = narrativeSummary;
      recommendations = [rec0, rec1, rec2, rec3, rec4, rec5];
      continuityHistory = appendBounded(state.continuityHistory, continuityWeave);
      resonanceHistory = appendBounded(state.resonanceHistory, resonanceField);
      couplingHistory = appendBounded(state.couplingHistory, memoryCognitionCoupling);
    }
  };
}
