import Array "mo:base/Array";
import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {
  public type ConstantFeedbackInput = {
    beat : Nat;
    rSwarm : Float;
    jDrift : Float;
    heartbeatCoherence : Float;
    qsovScore : Float;
    doctrineCompliance : Float;
    continuityScore : Float;
    trustScore : Float;
    anomalyScore : Float;
    predictionError : Float;
    cardioCerebralPush : Float;
    cardioNeuralCoupling : Float;
    cardioNeuralThroughput : Float;
    memoryTempleCoupling : Float;
    memoryTempleContinuity : Float;
    analystLearningScore : Float;
    analystAdaptationScore : Float;
    analystEmergencySignal : Float;
    geoProtectionScore : Float;
    geoThreatScore : Float;
    emotionalStability : Float;
    emotionalComplexity : Float;
    multiGroupCount : Nat;
    multiOrganismCount : Nat;
    feedbackSignalCount : Nat;
    lawViolationRate : Float;
    lawReEntrainmentRate : Float;
    defenseReadiness : Float;
    defenseThreatLoad : Float;
    economicBalance : Float;
    economicReserve : Float;
    entropyLoad : Float;
    hungerDrive : Float;
    workforceLoad : Float;
    workforceFocus : Float;
    artifactReadiness : Float;
    meshResonance : Float;
    meshActive : Bool;
    meshNodeCount : Nat;
    emergencyActive : Bool;
  };

  public type ConstantFeedbackState = {
    beat : Nat;
    cognitivePressure : Float;
    loopClosureScore : Float;
    reinjectionIntegrity : Float;
    multiGroupCoherence : Float;
    multiOrganismCoherence : Float;
    cognitionReadiness : Float;
    arbitrationReadiness : Float;
    governanceStability : Float;
    recommendationPriority : Float;
    lawContinuityScore : Float;
    defensePostureScore : Float;
    economicResilienceScore : Float;
    workforceCoherenceScore : Float;
    memoryIntegrityScore : Float;
    meshResonanceScore : Float;
    sovereignAlignmentScore : Float;
    riskContainmentScore : Float;
    narrativeSummary : Text;
    topActions : [Text];
    pressureHistory : [Float];
    closureHistory : [Float];
    reinjectionHistory : [Float];
    multiGroupHistory : [Float];
    multiOrganismHistory : [Float];
    lawHistory : [Float];
    defenseHistory : [Float];
    economyHistory : [Float];
    workforceHistory : [Float];
    meshHistory : [Float];
    sovereignHistory : [Float];
  };

  let HISTORY_LIMIT : Nat = 192;
  let ACTION_COUNT : Nat = 6;

  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x : Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func appendBounded(history : [Float], value : Float) : [Float] {
    if (history.size() < HISTORY_LIMIT) {
      Array.append<Float>(history, [value])
    } else {
      let tail = Array.tabulate<Float>(HISTORY_LIMIT - 1, func(i : Nat) : Float { history[i + 1] });
      Array.append<Float>(tail, [value])
    }
  };

  public func initConstantFeedback() : ConstantFeedbackState {
    {
      beat = 0;
      cognitivePressure = 0.30;
      loopClosureScore = 0.74;
      reinjectionIntegrity = 0.76;
      multiGroupCoherence = 0.70;
      multiOrganismCoherence = 0.70;
      cognitionReadiness = 0.72;
      arbitrationReadiness = 0.71;
      governanceStability = 0.74;
      recommendationPriority = 0.30;
      lawContinuityScore = 0.76;
      defensePostureScore = 0.74;
      economicResilienceScore = 0.72;
      workforceCoherenceScore = 0.73;
      memoryIntegrityScore = 0.76;
      meshResonanceScore = 0.70;
      sovereignAlignmentScore = 0.75;
      riskContainmentScore = 0.74;
      narrativeSummary = "Constant feedback cognition initialized.";
      topActions = Array.init<Text>(ACTION_COUNT, "");
      pressureHistory = [];
      closureHistory = [];
      reinjectionHistory = [];
      multiGroupHistory = [];
      multiOrganismHistory = [];
      lawHistory = [];
      defenseHistory = [];
      economyHistory = [];
      workforceHistory = [];
      meshHistory = [];
      sovereignHistory = [];
    }
  };

  public func tickConstantFeedback(state : ConstantFeedbackState, input : ConstantFeedbackInput) : ConstantFeedbackState {
    let driftAbs = clamp(abs(input.jDrift), 0.0, 1.0);
    let groupDensity = clamp(Float.fromInt(input.multiGroupCount) / 24.0, 0.0, 1.5);
    let organismDensity = clamp(Float.fromInt(input.multiOrganismCount) / 12.0, 0.0, 1.5);
    let signalDensity = clamp(Float.fromInt(input.feedbackSignalCount) / 4096.0, 0.0, 1.5);
    let meshDensity = clamp(Float.fromInt(input.meshNodeCount) / 64.0, 0.0, 1.5);

    let cognitivePressureRaw = clamp(
      0.24 * input.anomalyScore +
      0.18 * input.predictionError +
      0.16 * input.analystEmergencySignal +
      0.14 * input.geoThreatScore +
      0.08 * input.defenseThreatLoad +
      0.06 * input.entropyLoad +
      0.08 * driftAbs +
      0.06 * (1.0 - input.trustScore) +
      (if (input.emergencyActive) { 0.08 } else { 0.0 }),
      0.0,
      1.5
    );
    let cognitivePressure = clamp(state.cognitivePressure * 0.80 + cognitivePressureRaw * 0.20, 0.0, 1.5);

    let closureRaw = clamp(
      0.20 * input.memoryTempleContinuity +
      0.16 * input.memoryTempleCoupling +
      0.14 * input.continuityScore +
      0.14 * input.heartbeatCoherence +
      0.12 * input.cardioNeuralCoupling +
      0.12 * input.cardioNeuralThroughput +
      0.12 * input.doctrineCompliance,
      0.0,
      1.5
    );
    let loopClosureScore = clamp(state.loopClosureScore * 0.82 + closureRaw * 0.18, 0.0, 1.5);

    let reinjectionRaw = clamp(
      0.26 * loopClosureScore +
      0.16 * input.memoryTempleCoupling +
      0.14 * input.analystAdaptationScore +
      0.14 * input.geoProtectionScore +
      0.14 * input.qsovScore +
      0.16 * (1.0 - cognitivePressure * 0.5),
      0.0,
      1.5
    );
    let reinjectionIntegrity = clamp(state.reinjectionIntegrity * 0.84 + reinjectionRaw * 0.16, 0.0, 1.5);

    let multiGroupRaw = clamp(
      0.28 * input.rSwarm +
      0.20 * input.cardioCerebralPush +
      0.18 * input.analystLearningScore +
      0.16 * input.emotionalStability +
      0.10 * groupDensity +
      0.08 * signalDensity,
      0.0,
      1.5
    );
    let multiGroupCoherence = clamp(state.multiGroupCoherence * 0.82 + multiGroupRaw * 0.18, 0.0, 1.5);

    let multiOrganismRaw = clamp(
      0.22 * multiGroupCoherence +
      0.18 * input.qsovScore +
      0.16 * input.doctrineCompliance +
      0.14 * input.geoProtectionScore +
      0.14 * input.analystAdaptationScore +
      0.10 * organismDensity +
      0.06 * input.emotionalComplexity,
      0.0,
      1.5
    );
    let multiOrganismCoherence = clamp(state.multiOrganismCoherence * 0.84 + multiOrganismRaw * 0.16, 0.0, 1.5);

    let cognitionReadinessRaw = clamp(
      0.20 * loopClosureScore +
      0.18 * reinjectionIntegrity +
      0.16 * input.cardioNeuralThroughput +
      0.14 * input.analystLearningScore +
      0.14 * input.memoryTempleCoupling +
      0.10 * input.trustScore +
      0.08 * (1.0 - cognitivePressure * 0.5),
      0.0,
      1.5
    );
    let cognitionReadiness = clamp(state.cognitionReadiness * 0.82 + cognitionReadinessRaw * 0.18, 0.0, 1.5);

    let arbitrationRaw = clamp(
      0.22 * cognitionReadiness +
      0.20 * input.doctrineCompliance +
      0.18 * input.qsovScore +
      0.14 * input.analystAdaptationScore +
      0.14 * input.geoProtectionScore +
      0.12 * (1.0 - cognitivePressure * 0.5),
      0.0,
      1.5
    );
    let arbitrationReadiness = clamp(state.arbitrationReadiness * 0.84 + arbitrationRaw * 0.16, 0.0, 1.5);

    let governanceRaw = clamp(
      0.24 * arbitrationReadiness +
      0.18 * reinjectionIntegrity +
      0.16 * input.continuityScore +
      0.16 * input.trustScore +
      0.14 * input.doctrineCompliance +
      0.12 * (1.0 - driftAbs),
      0.0,
      1.5
    );
    let governanceStability = clamp(state.governanceStability * 0.84 + governanceRaw * 0.16, 0.0, 1.5);

    let lawContinuityRaw = clamp(
      0.30 * input.doctrineCompliance +
      0.18 * loopClosureScore +
      0.16 * (1.0 - input.lawViolationRate) +
      0.16 * (1.0 - input.lawReEntrainmentRate) +
      0.10 * governanceStability +
      0.10 * input.qsovScore,
      0.0,
      1.5
    );
    let lawContinuityScore = clamp(state.lawContinuityScore * 0.84 + lawContinuityRaw * 0.16, 0.0, 1.5);

    let defensePostureRaw = clamp(
      0.24 * input.defenseReadiness +
      0.20 * input.geoProtectionScore +
      0.18 * (1.0 - input.defenseThreatLoad) +
      0.12 * riskContainment(input.geoThreatScore, cognitivePressure, governanceStability) +
      0.14 * governanceStability +
      0.12 * lawContinuityScore,
      0.0,
      1.5
    );
    let defensePostureScore = clamp(state.defensePostureScore * 0.84 + defensePostureRaw * 0.16, 0.0, 1.5);

    let economicResilienceRaw = clamp(
      0.26 * input.economicBalance +
      0.20 * input.economicReserve +
      0.14 * (1.0 - input.entropyLoad) +
      0.12 * (1.0 - input.hungerDrive * 0.6) +
      0.14 * governanceStability +
      0.14 * lawContinuityScore,
      0.0,
      1.5
    );
    let economicResilienceScore = clamp(state.economicResilienceScore * 0.84 + economicResilienceRaw * 0.16, 0.0, 1.5);

    let workforceCoherenceRaw = clamp(
      0.24 * multiGroupCoherence +
      0.20 * input.workforceFocus +
      0.16 * (1.0 - input.workforceLoad) +
      0.14 * input.analystAdaptationScore +
      0.14 * input.artifactReadiness +
      0.12 * cognitionReadiness,
      0.0,
      1.5
    );
    let workforceCoherenceScore = clamp(state.workforceCoherenceScore * 0.84 + workforceCoherenceRaw * 0.16, 0.0, 1.5);

    let memoryIntegrityRaw = clamp(
      0.32 * reinjectionIntegrity +
      0.22 * input.memoryTempleContinuity +
      0.16 * input.memoryTempleCoupling +
      0.16 * loopClosureScore +
      0.14 * lawContinuityScore,
      0.0,
      1.5
    );
    let memoryIntegrityScore = clamp(state.memoryIntegrityScore * 0.84 + memoryIntegrityRaw * 0.16, 0.0, 1.5);

    let meshResonanceRaw = clamp(
      0.30 * multiOrganismCoherence +
      0.20 * input.meshResonance +
      0.14 * meshDensity +
      0.12 * organismDensity +
      0.12 * input.qsovScore +
      0.12 * (if (input.meshActive) { 1.0 } else { 0.45 }),
      0.0,
      1.5
    );
    let meshResonanceScore = clamp(state.meshResonanceScore * 0.84 + meshResonanceRaw * 0.16, 0.0, 1.5);

    let riskContainmentScore = clamp(
      0.28 * defensePostureScore +
      0.20 * (1.0 - cognitivePressure) +
      0.16 * governanceStability +
      0.14 * lawContinuityScore +
      0.12 * memoryIntegrityScore +
      0.10 * (1.0 - input.geoThreatScore),
      0.0,
      1.5
    );

    let sovereignAlignmentRaw = clamp(
      0.18 * lawContinuityScore +
      0.16 * defensePostureScore +
      0.14 * economicResilienceScore +
      0.12 * workforceCoherenceScore +
      0.12 * memoryIntegrityScore +
      0.12 * meshResonanceScore +
      0.08 * governanceStability +
      0.08 * input.qsovScore,
      0.0,
      1.5
    );
    let sovereignAlignmentScore = clamp(state.sovereignAlignmentScore * 0.84 + sovereignAlignmentRaw * 0.16, 0.0, 1.5);

    let recommendationPriority = clamp(
      0.28 * cognitivePressure +
      0.18 * (1.0 - reinjectionIntegrity) +
      0.16 * (1.0 - governanceStability) +
      0.12 * input.analystEmergencySignal +
      0.10 * (1.0 - defensePostureScore) +
      0.08 * (1.0 - lawContinuityScore) +
      0.08 * (if (input.emergencyActive) { 1.0 } else { 0.0 }),
      0.0,
      1.5
    );

    let narrativeSummary =
      "Constant feedback beat " # Nat.toText(input.beat) #
      ": pressure=" # Float.toText(cognitivePressure) #
      ", closure=" # Float.toText(loopClosureScore) #
      ", reinjection=" # Float.toText(reinjectionIntegrity) #
      ", groups=" # Float.toText(multiGroupCoherence) #
      ", organisms=" # Float.toText(multiOrganismCoherence) #
      ", law=" # Float.toText(lawContinuityScore) #
      ", defense=" # Float.toText(defensePostureScore) #
      ", economy=" # Float.toText(economicResilienceScore) #
      ", workforce=" # Float.toText(workforceCoherenceScore) #
      ", sovereign=" # Float.toText(sovereignAlignmentScore) # ".";

    let action0 =
      if (cognitivePressure > 0.75)
      { "Raise protection-first routing for all active groups until pressure normalizes." }
      else
      { "Pressure stable: keep balanced cognition-defense routing." };
    let action1 =
      if (loopClosureScore < 0.70)
      { "Increase loop closure: force memory-temple reinjection hooks on every beat transition." }
      else
      { "Loop closure healthy: preserve current closure cadence across groups." };
    let action2 =
      if (reinjectionIntegrity < 0.72)
      { "Reinjection gap detected: elevate replay+continuity audits for next 24 beats." }
      else
      { "Reinjection integrity acceptable: continue no-drop continuity discipline." };
    let action3 =
      if (multiGroupCoherence < 0.70)
      { "Run cross-group synchronization pulse: stabilize trust and doctrine alignment in all councils." }
      else
      { "Group coherence stable: expand shared workload between internal groups." };
    let action4 =
      if (multiOrganismCoherence < 0.70)
      { "Multi-organism coupling weak: prioritize sovereign arbitration contracts before external projection." }
      else
      { "Multi-organism coherence strong: safely increase federated task throughput." };
    let action5 =
      "Keep constant feedback cognition always-on: every output must be scored and reinjected into next beat governance.";

    {
      beat = input.beat;
      cognitivePressure = cognitivePressure;
      loopClosureScore = loopClosureScore;
      reinjectionIntegrity = reinjectionIntegrity;
      multiGroupCoherence = multiGroupCoherence;
      multiOrganismCoherence = multiOrganismCoherence;
      cognitionReadiness = cognitionReadiness;
      arbitrationReadiness = arbitrationReadiness;
      governanceStability = governanceStability;
      recommendationPriority = recommendationPriority;
      lawContinuityScore = lawContinuityScore;
      defensePostureScore = defensePostureScore;
      economicResilienceScore = economicResilienceScore;
      workforceCoherenceScore = workforceCoherenceScore;
      memoryIntegrityScore = memoryIntegrityScore;
      meshResonanceScore = meshResonanceScore;
      sovereignAlignmentScore = sovereignAlignmentScore;
      riskContainmentScore = riskContainmentScore;
      narrativeSummary = narrativeSummary;
      topActions = [action0, action1, action2, action3, action4, action5];
      pressureHistory = appendBounded(state.pressureHistory, cognitivePressure);
      closureHistory = appendBounded(state.closureHistory, loopClosureScore);
      reinjectionHistory = appendBounded(state.reinjectionHistory, reinjectionIntegrity);
      multiGroupHistory = appendBounded(state.multiGroupHistory, multiGroupCoherence);
      multiOrganismHistory = appendBounded(state.multiOrganismHistory, multiOrganismCoherence);
      lawHistory = appendBounded(state.lawHistory, lawContinuityScore);
      defenseHistory = appendBounded(state.defenseHistory, defensePostureScore);
      economyHistory = appendBounded(state.economyHistory, economicResilienceScore);
      workforceHistory = appendBounded(state.workforceHistory, workforceCoherenceScore);
      meshHistory = appendBounded(state.meshHistory, meshResonanceScore);
      sovereignHistory = appendBounded(state.sovereignHistory, sovereignAlignmentScore);
    }
  };

  func riskContainment(threat : Float, pressure : Float, governance : Float) : Float {
    clamp((1.0 - threat) * 0.40 + (1.0 - pressure) * 0.35 + governance * 0.25, 0.0, 1.5)
  };
}
