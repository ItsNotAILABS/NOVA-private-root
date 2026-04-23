import Array "mo:base/Array";
import Float "mo:base/Float";
import Int "mo:base/Int";
module {
  public type Vector3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  public type GRPEInput = {
    beat : Nat;
    rSwarm : Float;
    jDrift : Float;
    qsovScore : Float;
    cardioCerebralPush : Float;
    emotionalArousal : Float;
    emotionalCertainty : Float;
    magneticFlux : Float;
    rfIntensity : Float;
    hydrologyPotential : Float;
    infrastructureLoad : Float;
    anomalyScore : Float;
    doctrineDirection : Vector3;
    emotionalDirection : Vector3;
  };

  public type GRPEState = {
    beat : Nat;
    fieldEnergy : Float;
    hotspotScore : Float;
    protectionScore : Float;
    threatScore : Float;
    serviceReadiness : Float;
    fieldDirection : Vector3;
    sevenHeritageNodes : [Float];
    serviceOpportunity : [Float];
    defenseServiceOpportunity : [Float];
    memoryServiceOpportunity : [Float];
    worldServiceOpportunity : [Float];
    fieldHistory : [Float];
    hotspotHistory : [Float];
    protectionHistory : [Float];
  };

  let EPS : Float = 0.0000001;
  let TAU : Float = 6.28318530717958647692;
  let HISTORY_LIMIT : Nat = 128;
  let SERVICE_COUNT : Nat = 20;

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

  public func initGRPE() : GRPEState {
    {
      beat = 0;
      fieldEnergy = 0.7;
      hotspotScore = 0.25;
      protectionScore = 0.75;
      threatScore = 0.25;
      serviceReadiness = 0.7;
      fieldDirection = { x = 0.0; y = 0.0; z = 1.0 };
      sevenHeritageNodes = [0.72, 0.70, 0.68, 0.69, 0.74, 0.71, 0.73];
      serviceOpportunity = Array.init<Float>(SERVICE_COUNT, 0.65);
      defenseServiceOpportunity = Array.init<Float>(5, 0.7);
      memoryServiceOpportunity = Array.init<Float>(5, 0.7);
      worldServiceOpportunity = Array.init<Float>(5, 0.7);
      fieldHistory = [];
      hotspotHistory = [];
      protectionHistory = [];
    }
  };

  public func tickGRPE(state : GRPEState, input : GRPEInput) : GRPEState {
    let beatPhase = Float.fromInt(input.beat % 377) * (TAU / 377.0);
    let doctrineDir = normalize(input.doctrineDirection);
    let emotionalDir = normalize(input.emotionalDirection);

    let fieldRaw = clamp(
      0.22 * input.magneticFlux +
      0.14 * input.rfIntensity +
      0.10 * input.hydrologyPotential +
      0.12 * input.qsovScore +
      0.12 * input.rSwarm +
      0.10 * input.cardioCerebralPush +
      0.10 * input.emotionalCertainty +
      0.10 * (1.0 - abs(input.jDrift)),
      0.0,
      1.5
    );
    let fieldEnergy = clamp(state.fieldEnergy * 0.82 + fieldRaw * 0.18, 0.0, 1.5);

    let protectionRaw = clamp(
      0.35 * fieldEnergy +
      0.25 * input.qsovScore +
      0.20 * input.cardioCerebralPush +
      0.20 * (0.5 + 0.5 * dot(doctrineDir, emotionalDir)),
      0.0,
      1.5
    );
    let protectionScore = clamp(state.protectionScore * 0.80 + protectionRaw * 0.20, 0.0, 1.5);

    let hotspotRaw = clamp(
      0.40 * input.infrastructureLoad +
      0.25 * input.anomalyScore +
      0.20 * input.rfIntensity +
      0.15 * (1.0 - protectionScore),
      0.0,
      2.0
    );
    let hotspotScore = clamp(state.hotspotScore * 0.78 + hotspotRaw * 0.22, 0.0, 2.0);

    let threatRaw = clamp(
      0.55 * hotspotScore +
      0.25 * input.anomalyScore +
      0.20 * (1.0 - protectionScore),
      0.0,
      2.0
    );
    let threatScore = clamp(state.threatScore * 0.80 + threatRaw * 0.20, 0.0, 2.0);

    let readinessRaw = clamp(
      0.45 * protectionScore +
      0.25 * fieldEnergy +
      0.20 * (1.0 - hotspotScore * 0.5) +
      0.10 * input.hydrologyPotential,
      0.0,
      1.5
    );
    let serviceReadiness = clamp(state.serviceReadiness * 0.82 + readinessRaw * 0.18, 0.0, 1.5);

    let direction = normalize({
      x = doctrineDir.x * 0.55 + emotionalDir.x * 0.30 + (0.5 - input.anomalyScore) * 0.15;
      y = doctrineDir.y * 0.55 + emotionalDir.y * 0.30 + (input.hydrologyPotential - 0.5) * 0.15;
      z = doctrineDir.z * 0.65 + emotionalDir.z * 0.20 + protectionScore * 0.15;
    });

    let sevenHeritageNodes = Array.tabulate<Float>(
      7,
      func(i : Nat) : Float {
        let phase = beatPhase + Float.fromInt(i) * (TAU / 7.0);
        let harmonic = 0.5 + 0.5 * Float.sin(phase);
        clamp(
          0.45 * harmonic +
          0.25 * serviceReadiness +
          0.20 * protectionScore +
          0.10 * (1.0 - threatScore * 0.5),
          0.0,
          1.5
        )
      }
    );

    let serviceOpportunity = Array.tabulate<Float>(
      SERVICE_COUNT,
      func(i : Nat) : Float {
        let phase = beatPhase + Float.fromInt(i) * 0.17;
        let harmonic = 0.5 + 0.5 * Float.sin(phase);
        clamp(
          0.40 * serviceReadiness +
          0.25 * protectionScore +
          0.20 * harmonic +
          0.15 * (1.0 - hotspotScore * 0.5),
          0.0,
          1.5
        )
      }
    );

    let defenseServiceOpportunity = Array.tabulate<Float>(
      5,
      func(i : Nat) : Float {
        let base = if (i < serviceOpportunity.size()) { serviceOpportunity[i] } else { serviceReadiness };
        clamp(0.65 * base + 0.35 * protectionScore, 0.0, 1.5)
      }
    );
    let memoryServiceOpportunity = Array.tabulate<Float>(
      5,
      func(i : Nat) : Float {
        let idx = i + 5;
        let base = if (idx < serviceOpportunity.size()) { serviceOpportunity[idx] } else { serviceReadiness };
        clamp(0.60 * base + 0.40 * input.emotionalCertainty, 0.0, 1.5)
      }
    );
    let worldServiceOpportunity = Array.tabulate<Float>(
      5,
      func(i : Nat) : Float {
        let idx = i + 10;
        let base = if (idx < serviceOpportunity.size()) { serviceOpportunity[idx] } else { serviceReadiness };
        clamp(0.60 * base + 0.40 * input.hydrologyPotential, 0.0, 1.5)
      }
    );

    {
      beat = input.beat;
      fieldEnergy = fieldEnergy;
      hotspotScore = hotspotScore;
      protectionScore = protectionScore;
      threatScore = threatScore;
      serviceReadiness = serviceReadiness;
      fieldDirection = direction;
      sevenHeritageNodes = sevenHeritageNodes;
      serviceOpportunity = serviceOpportunity;
      defenseServiceOpportunity = defenseServiceOpportunity;
      memoryServiceOpportunity = memoryServiceOpportunity;
      worldServiceOpportunity = worldServiceOpportunity;
      fieldHistory = appendBounded(state.fieldHistory, fieldEnergy);
      hotspotHistory = appendBounded(state.hotspotHistory, hotspotScore);
      protectionHistory = appendBounded(state.protectionHistory, protectionScore);
    }
  };
}
