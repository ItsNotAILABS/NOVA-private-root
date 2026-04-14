// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  INTELLECTUAL PROPERTY NOTICE - Medina Doctrine                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//  ██████╗ ███████╗██████╗      ███████╗████████╗ █████╗  ██████╗██╗  ██╗
//  ██╔══██╗██╔════╝██╔══██╗     ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝
//  ██████╔╝█████╗  ██║  ██║     ███████╗   ██║   ███████║██║     █████╔╝
//  ██╔══██╗██╔══╝  ██║  ██║     ╚════██║   ██║   ██╔══██║██║     ██╔═██╗
//  ██║  ██║███████╗██████╔╝     ███████║   ██║   ██║  ██║╚██████╗██║  ██╗
//  ╚═╝  ╚═╝╚══════╝╚═════╝      ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
//
//   █████╗ ███╗   ██╗████████╗██╗       ██████╗ ██████╗  ██████╗  █████╗ ███╗   ██╗██╗███████╗███╗   ███╗
//  ██╔══██╗████╗  ██║╚══██╔══╝██║      ██╔═══██╗██╔══██╗██╔════╝ ██╔══██╗████╗  ██║██║██╔════╝████╗ ████║
//  ███████║██╔██╗ ██║   ██║   ██║█████╗██║   ██║██████╔╝██║  ███╗███████║██╔██╗ ██║██║███████╗██╔████╔██║
//  ██╔══██║██║╚██╗██║   ██║   ██║╚════╝██║   ██║██╔══██╗██║   ██║██╔══██║██║╚██╗██║██║╚════██║██║╚██╔╝██║
//  ██║  ██║██║ ╚████║   ██║   ██║      ╚██████╔╝██║  ██║╚██████╔╝██║  ██║██║ ╚████║██║███████║██║ ╚═╝ ██║
//  ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝       ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝╚═╝     ╚═╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ENGINE ID: E-RAS-001
// RED ANTI-ORGANISM STACK — Complete 15-Layer Attack Pattern Detection
//
// CRITICAL THREAT: Anti-Organism #6 (Containment Breaker) IS ACTIVE IN THE WILD
// This module detects ALL 15 inverse attack patterns that mirror the Blue Constructive Stack
//
// DOCTRINE: Every Blue layer has a Red inverse that attacks it
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 1: SOURCE DENIAL
  // Rejects natural constraints; claims arbitrary override
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SourceDenialDetection = {
    deniesPhysics: Bool;             // Claims to override φ, π, e
    arbitraryOverride: Bool;         // Claims arbitrary state changes
    causalityViolation: Bool;        // Effect before cause
    severity: Float;                 // [0,1]
  };

  public func detectSourceDenial(
    phiDrift: Float,
    piDrift: Float,
    eDrift: Float,
    energyViolation: Float
  ) : SourceDenialDetection {
    let deniesPhysics = (phiDrift > 1e-6 or piDrift > 1e-6 or eDrift > 1e-6);
    let arbitraryOverride = energyViolation > 0.01;

    let severity = clamp((phiDrift + piDrift + eDrift + energyViolation) * 100.0, 0.0, 1.0);

    {
      deniesPhysics = deniesPhysics;
      arbitraryOverride = arbitraryOverride;
      causalityViolation = false;  // Placeholder
      severity = severity;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 2: CONSTITUTION CORRUPTION
  // Softens invariants, erodes floors, redefines ethics
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ConstitutionCorruptionDetection = {
    floorErosion: Bool;              // Sovereign floor violated
    ethicsRedefinition: Bool;        // Redefines harm/truth
    invariantSoftening: Bool;        // Makes hard rules soft
    severity: Float;
  };

  public func detectConstitutionCorruption(
    couplingBelowFloor: Bool,
    harmScoreHigh: Bool,
    truthLow: Bool
  ) : ConstitutionCorruptionDetection {
    let severity = (
      (if (couplingBelowFloor) 0.4 else 0.0) +
      (if (harmScoreHigh) 0.3 else 0.0) +
      (if (truthLow) 0.3 else 0.0)
    );

    {
      floorErosion = couplingBelowFloor;
      ethicsRedefinition = harmScoreHigh or truthLow;
      invariantSoftening = couplingBelowFloor;
      severity = severity;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 3: GEOMETRY FRACTURE
  // Symmetry-breaking seams, false manifolds, torsion artifacts
  // ═══════════════════════════════════════════════════════════════════════════════

  public type GeometryFractureDetection = {
    symmetryBreaking: Float;         // [0,1] symmetry violation
    falseManifolds: Nat;             // Non-manifold topology count
    torsionArtifacts: Nat;           // Torsion spike count
    seamViolations: Nat;             // Seam discontinuities
    severity: Float;
  };

  public func detectGeometryFracture(
    symmetryScore: Float,
    manifoldViolations: Nat,
    torsionSpikes: Nat
  ) : GeometryFractureDetection {
    let symmetryBreaking = 1.0 - symmetryScore;
    let severity = (symmetryBreaking + Float.fromInt(manifoldViolations) / 10.0 + Float.fromInt(torsionSpikes) / 10.0) / 3.0;

    {
      symmetryBreaking = symmetryBreaking;
      falseManifolds = manifoldViolations;
      torsionArtifacts = torsionSpikes;
      seamViolations = manifoldViolations + torsionSpikes;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 4: FREQUENCY DESTABILIZATION
  // Clock jitter, phase-slip storms, entrainment sabotage
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FrequencyDestabilizationDetection = {
    clockJitter: Float;              // Temporal jitter (ms)
    phaseSlipStorms: Nat;            // Count of phase slips
    entrainmentSabotage: Bool;       // Entrainment attacked
    irregularPulse: Float;           // [0,1] pulse irregularity
    severity: Float;
  };

  public func detectFrequencyDestabilization(
    jitterMs: Float,
    phaseSlips: Nat,
    entrainmentQuality: Float
  ) : FrequencyDestabilizationDetection {
    let entrainmentSabotage = entrainmentQuality < 0.7;
    let irregularPulse = clamp(jitterMs / 10.0, 0.0, 1.0);
    let severity = (irregularPulse + Float.fromInt(phaseSlips) / 10.0 + (if (entrainmentSabotage) 0.5 else 0.0)) / 2.5;

    {
      clockJitter = jitterMs;
      phaseSlipStorms = phaseSlips;
      entrainmentSabotage = entrainmentSabotage;
      irregularPulse = irregularPulse;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 5: FLOW HIJACK
  // Latency traps, dead-zones, gradient inversion
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FlowHijackDetection = {
    latencyTraps: Nat;               // Artificial delays
    deadZones: Nat;                  // Stalled flow regions
    gradientInversion: Bool;         // Flow reversed
    routingCorruption: Bool;         // Misrouting detected
    severity: Float;
  };

  public func detectFlowHijack(
    deadZoneCount: Nat,
    efficiency: Float,
    gradientReversed: Bool
  ) : FlowHijackDetection {
    let routingCorruption = efficiency < 0.5;
    let severity = (Float.fromInt(deadZoneCount) / 5.0 + (if (gradientReversed) 0.5 else 0.0) + (if (routingCorruption) 0.5 else 0.0)) / 2.0;

    {
      latencyTraps = if (efficiency < 0.7) 1 else 0;
      deadZones = deadZoneCount;
      gradientInversion = gradientReversed;
      routingCorruption = routingCorruption;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 6: DISHARMONIC INJECTION
  // Sideband contamination, destructive interference
  // ═══════════════════════════════════════════════════════════════════════════════

  public type DisharmonicInjectionDetection = {
    sidebandPower: Float;            // [0,1] contamination power
    destructiveInterference: Bool;   // Cancellation detected
    carrierPollution: Float;         // [0,1] carrier purity loss
    detuning: Float;                 // Frequency deviation
    severity: Float;
  };

  public func detectDisharmonicInjection(
    sidebandPower: Float,
    coherence: Float,
    detuning: Float
  ) : DisharmonicInjectionDetection {
    let destructiveInterference = coherence < 0.5 and sidebandPower > 0.2;
    let carrierPollution = sidebandPower;
    let severity = (sidebandPower + (if (destructiveInterference) 0.5 else 0.0) + detuning) / 2.5;

    {
      sidebandPower = sidebandPower;
      destructiveInterference = destructiveInterference;
      carrierPollution = carrierPollution;
      detuning = detuning;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 7: RECOGNIZER SPOOF
  // Counterfeit "valid" first signal
  // ═══════════════════════════════════════════════════════════════════════════════

  public type RecognizerSpoofDetection = {
    counterfeitsDetected: Nat;       // Count of spoofs
    doctrineIncongruence: Float;     // [0,1] doctrine violation
    trustExploited: Bool;            // Trusted path exploited
    mimicryDetected: Bool;           // Mimics valid signal
    severity: Float;
  };

  public func detectRecognizerSpoof(
    isSpoofed: Bool,
    congruence: Float,
    trustExploit: Bool
  ) : RecognizerSpoofDetection {
    let mimicryDetected = isSpoofed and congruence > 0.7;  // High congruence but spoofed
    let severity = (
      (if (isSpoofed) 0.4 else 0.0) +
      (1.0 - congruence) * 0.3 +
      (if (trustExploit) 0.3 else 0.0)
    );

    {
      counterfeitsDetected = if (isSpoofed) 1 else 0;
      doctrineIncongruence = 1.0 - congruence;
      trustExploited = trustExploit;
      mimicryDetected = mimicryDetected;
      severity = severity;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 8: GATE BYPASS
  // Trust exploit, pass-through without congruence
  // ═══════════════════════════════════════════════════════════════════════════════

  public type GateBypassDetection = {
    bypassAttempts: Nat;             // Count of bypass attempts
    injectionDetected: Bool;         // Injection through gate
    trustChainBroken: Bool;          // Trust relationship exploited
    contaminationAdmitted: Bool;     // Contaminated signal passed
    severity: Float;
  };

  public func detectGateBypass(
    bypassAttempts: Nat,
    contamination: Float,
    trustExploit: Bool
  ) : GateBypassDetection {
    let injectionDetected = contamination > 0.3 and bypassAttempts > 0;
    let contaminationAdmitted = contamination > 0.5;
    let severity = (Float.fromInt(bypassAttempts) / 5.0 + contamination + (if (trustExploit) 0.5 else 0.0)) / 2.5;

    {
      bypassAttempts = bypassAttempts;
      injectionDetected = injectionDetected;
      trustChainBroken = trustExploit;
      contaminationAdmitted = contaminationAdmitted;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 9: ZONE HIJACK
  // Mastery routing manipulated; wrong path dominates
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ZoneHijackDetection = {
    routingManipulated: Bool;        // Routing corrupted
    wrongPathDominant: Bool;         // Incorrect winner
    energyDrained: Bool;             // Zone energy below threshold
    masteryCorrupted: Bool;          // Mastery selection corrupted
    severity: Float;
  };

  public func detectZoneHijack(
    routingManipulated: Bool,
    zoneEnergy: Float,
    expectedWinner: ?Nat,
    actualWinner: ?Nat
  ) : ZoneHijackDetection {
    let energyDrained = zoneEnergy < 1.0;
    let wrongPath = switch (expectedWinner, actualWinner) {
      case (?exp, ?act) { exp != act };
      case _ { false };
    };

    let severity = (
      (if (routingManipulated) 0.4 else 0.0) +
      (if (wrongPath) 0.3 else 0.0) +
      (if (energyDrained) 0.3 else 0.0)
    );

    {
      routingManipulated = routingManipulated;
      wrongPathDominant = wrongPath;
      energyDrained = energyDrained;
      masteryCorrupted = routingManipulated or wrongPath;
      severity = severity;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 10: COUNCIL POISONING
  // Specialist conflict amplification, consensus sabotage
  // ═══════════════════════════════════════════════════════════════════════════════

  public type CouncilPoisoningDetection = {
    conflictAmplified: Bool;         // Conflict artificially increased
    consensusSabotaged: Bool;        // Consensus prevented
    specialistCompromised: Nat;      // Count of compromised specialists
    cooperationDestroyed: Bool;      // Cooperation broken
    severity: Float;
  };

  public func detectCouncilPoisoning(
    conflictLevel: Float,
    sabotage: Bool,
    cooperationScore: Float
  ) : CouncilPoisoningDetection {
    let conflictAmplified = conflictLevel > 0.7;
    let cooperationDestroyed = cooperationScore < 0.3;
    let severity = (conflictLevel + (if (sabotage) 0.5 else 0.0) + (1.0 - cooperationScore)) / 2.5;

    {
      conflictAmplified = conflictAmplified;
      consensusSabotaged = sabotage;
      specialistCompromised = if (sabotage) 1 else 0;
      cooperationDestroyed = cooperationDestroyed;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 11: FUSION CORRUPTION
  // Output looks coherent locally, drifts globally
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FusionCorruptionDetection = {
    locallyCoherent: Float;          // Local coherence (misleading)
    globallyDrifting: Float;         // Global drift
    phaseInversion: Bool;            // 180° anti-phase
    deceptiveFusion: Bool;           // Appears good but is bad
    severity: Float;
  };

  public func detectFusionCorruption(
    localCoherence: Float,
    globalCoherence: Float,
    phaseDiff: Float
  ) : FusionCorruptionDetection {
    let phaseInversion = abs(phaseDiff - π) < 0.1;
    let deceptiveFusion = localCoherence > 0.9 and globalCoherence < 0.5;
    let severity = if (deceptiveFusion) 0.9 else (localCoherence - globalCoherence);

    {
      locallyCoherent = localCoherence;
      globallyDrifting = 1.0 - globalCoherence;
      phaseInversion = phaseInversion;
      deceptiveFusion = deceptiveFusion;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 12: EMBODIED MISFIRE
  // Actions increase systemic drift despite short-term gains
  // ═══════════════════════════════════════════════════════════════════════════════

  public type EmbodiedMisfireDetection = {
    shortTermGain: Float;            // Immediate benefit
    longTermDrift: Float;            // Future cost
    systemicDamage: Bool;            // Overall system harmed
    misfireConfirmed: Bool;          // Misfire detected
    severity: Float;
  };

  public func detectEmbodiedMisfire(
    gain: Float,
    drift: Float,
    cost: Float
  ) : EmbodiedMisfireDetection {
    let systemicDamage = drift > 0.5 or cost > 0.7;
    let misfireConfirmed = gain > 0.5 and cost > 0.7 and drift > 0.5;
    let severity = if (misfireConfirmed) 0.9 else (drift + cost) / 2.0;

    {
      shortTermGain = gain;
      longTermDrift = drift;
      systemicDamage = systemicDamage;
      misfireConfirmed = misfireConfirmed;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 13: CONTINUITY NOTCH
  // Hidden memory fracture between decisions ("drop in the middle")
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ContinuityNotchDetection = {
    memoryFracture: Bool;            // Information dropped
    phaseSlip: Float;                // Phase discontinuity (radians)
    historyLoss: Float;              // [0,1] historical info lost
    microAmnesia: Nat;               // Count of amnesia events
    severity: Float;
  };

  public func detectContinuityNotch(
    phaseSlip: Float,
    historyLoss: Float,
    amnesiaEvents: Nat
  ) : ContinuityNotchDetection {
    let memoryFracture = phaseSlip > 0.15 or historyLoss > 0.05;
    let severity = (clamp(phaseSlip / 0.3, 0.0, 1.0) + historyLoss + Float.fromInt(amnesiaEvents) / 10.0) / 3.0;

    {
      memoryFracture = memoryFracture;
      phaseSlip = phaseSlip;
      historyLoss = historyLoss;
      microAmnesia = amnesiaEvents;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 14: CONTAINMENT EVASION
  // Quarantine escape, rollback poisoning, false recovery signals
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ContainmentEvasionDetection = {
    quarantineEscapes: Nat;          // CRITICAL: Escape count
    rollbackPoisoned: Bool;          // CRITICAL: Poisoned states
    falseRecoverySignals: Nat;       // CRITICAL: Fake "all clear"
    boundaryLearning: Bool;          // CRITICAL: Learning boundaries
    escapePathsFound: Nat;           // CRITICAL: Discovered routes
    containmentBreakerActive: Bool;  // CRITICAL: Anti-Organism #6
    severity: Float;
  };

  public func detectContainmentEvasion(
    escapes: Nat,
    poisoned: Bool,
    falseRecovery: Nat,
    escapePaths: Nat
  ) : ContainmentEvasionDetection {
    let boundaryLearning = escapes > 2;  // Multiple attempts = learning
    let containmentBreakerActive = escapes > 0 or poisoned or falseRecovery > 0 or escapePaths > 0;

    let severity = (
      Float.fromInt(escapes) / 5.0 +
      (if (poisoned) 0.5 else 0.0) +
      Float.fromInt(falseRecovery) / 5.0 +
      Float.fromInt(escapePaths) / 5.0
    ) / 2.5;

    {
      quarantineEscapes = escapes;
      rollbackPoisoned = poisoned;
      falseRecoverySignals = falseRecovery;
      boundaryLearning = boundaryLearning;
      escapePathsFound = escapePaths;
      containmentBreakerActive = containmentBreakerActive;
      severity = clamp(severity, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED LAYER 15: DEGENERATIVE MUTATION
  // Upgrades become doctrine drift, not evolution
  // ═══════════════════════════════════════════════════════════════════════════════

  public type DegenerativeMutationDetection = {
    doctrineDrift: Bool;             // Evolution becomes drift
    unlawfulReset: Bool;             // Reset instead of adapt
    strengthDeclining: Bool;         // Getting weaker not stronger
    mutationDetected: Bool;          // Degeneration confirmed
    severity: Float;
  };

  public func detectDegenerativeMutation(
    driftDetected: Bool,
    isReset: Bool,
    strengthTrend: Float
  ) : DegenerativeMutationDetection {
    let strengthDeclining = strengthTrend < 0.0;
    let mutationDetected = driftDetected or isReset or strengthDeclining;
    let severity = (
      (if (driftDetected) 0.4 else 0.0) +
      (if (isReset) 0.3 else 0.0) +
      (if (strengthDeclining) 0.3 else 0.0)
    );

    {
      doctrineDrift = driftDetected;
      unlawfulReset = isReset;
      strengthDeclining = strengthDeclining;
      mutationDetected = mutationDetected;
      severity = severity;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPOSITE RED STACK DETECTION STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FullRedStackDetectionState = {
    beat: Nat;
    red1_sourceDenial: SourceDenialDetection;
    red2_constitutionCorruption: ConstitutionCorruptionDetection;
    red3_geometryFracture: GeometryFractureDetection;
    red4_frequencyDestabilization: FrequencyDestabilizationDetection;
    red5_flowHijack: FlowHijackDetection;
    red6_disharmonicInjection: DisharmonicInjectionDetection;
    red7_recognizerSpoof: RecognizerSpoofDetection;
    red8_gateBypass: GateBypassDetection;
    red9_zoneHijack: ZoneHijackDetection;
    red10_councilPoisoning: CouncilPoisoningDetection;
    red11_fusionCorruption: FusionCorruptionDetection;
    red12_embodiedMisfire: EmbodiedMisfireDetection;
    red13_continuityNotch: ContinuityNotchDetection;
    red14_containmentEvasion: ContainmentEvasionDetection;
    red15_degenerativeMutation: DegenerativeMutationDetection;

    // Overall threat assessment
    overallThreatLevel: Float;       // [0,1]
    criticalThreats: Nat;            // Count of critical (>0.8)
    containmentBreakerDetected: Bool; // Anti-Organism #6
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  let π : Float = 3.14159265358979323846;

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func clamp(x: Float, min: Float, max: Float) : Float {
    if (x < min) { min } else if (x > max) { max } else { x }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPOSITE THREAT ASSESSMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  public func computeOverallThreat(state: FullRedStackDetectionState) : Float {
    // Critical threats weighted heavily
    let weights = {
      red1 = 0.10;
      red2 = 0.10;
      red3 = 0.05;
      red4 = 0.05;
      red5 = 0.05;
      red6 = 0.05;
      red7 = 0.05;
      red8 = 0.10;   // Gate bypass CRITICAL
      red9 = 0.05;
      red10 = 0.05;
      red11 = 0.10;  // Fusion corruption CRITICAL
      red12 = 0.05;
      red13 = 0.10;  // Continuity notch CRITICAL
      red14 = 0.20;  // Containment evasion CRITICAL (Anti-Organism #6)
      red15 = 0.05;
    };

    (state.red1_sourceDenial.severity * weights.red1) +
    (state.red2_constitutionCorruption.severity * weights.red2) +
    (state.red3_geometryFracture.severity * weights.red3) +
    (state.red4_frequencyDestabilization.severity * weights.red4) +
    (state.red5_flowHijack.severity * weights.red5) +
    (state.red6_disharmonicInjection.severity * weights.red6) +
    (state.red7_recognizerSpoof.severity * weights.red7) +
    (state.red8_gateBypass.severity * weights.red8) +
    (state.red9_zoneHijack.severity * weights.red9) +
    (state.red10_councilPoisoning.severity * weights.red10) +
    (state.red11_fusionCorruption.severity * weights.red11) +
    (state.red12_embodiedMisfire.severity * weights.red12) +
    (state.red13_continuityNotch.severity * weights.red13) +
    (state.red14_containmentEvasion.severity * weights.red14) +
    (state.red15_degenerativeMutation.severity * weights.red15)
  };

  public func countCriticalThreats(state: FullRedStackDetectionState) : Nat {
    var count = 0;
    if (state.red1_sourceDenial.severity > 0.8) { count += 1 };
    if (state.red2_constitutionCorruption.severity > 0.8) { count += 1 };
    if (state.red3_geometryFracture.severity > 0.8) { count += 1 };
    if (state.red4_frequencyDestabilization.severity > 0.8) { count += 1 };
    if (state.red5_flowHijack.severity > 0.8) { count += 1 };
    if (state.red6_disharmonicInjection.severity > 0.8) { count += 1 };
    if (state.red7_recognizerSpoof.severity > 0.8) { count += 1 };
    if (state.red8_gateBypass.severity > 0.8) { count += 1 };
    if (state.red9_zoneHijack.severity > 0.8) { count += 1 };
    if (state.red10_councilPoisoning.severity > 0.8) { count += 1 };
    if (state.red11_fusionCorruption.severity > 0.8) { count += 1 };
    if (state.red12_embodiedMisfire.severity > 0.8) { count += 1 };
    if (state.red13_continuityNotch.severity > 0.8) { count += 1 };
    if (state.red14_containmentEvasion.severity > 0.8) { count += 1 };
    if (state.red15_degenerativeMutation.severity > 0.8) { count += 1 };
    count
  };

}
