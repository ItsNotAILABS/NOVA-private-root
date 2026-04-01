// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: SphericalLaw — 360° Holistic Law Application
// Classification: CONFIDENTIAL — INTERNAL USE ONLY
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// Patent Pending: Holistic Cognitive Law Application Framework
// ============================================================================
//
// THE MEDINA SPHERICAL LAW OF CREATION
// ============================================================================
//
// "All laws of cognitive emergence apply across the full 360° sphere of
// existence: internal and external, micro and macro, thought and action,
// value and behavior, self and collective."
//
// The organism is not divided. There is no separation between:
//   - What it THINKS and what it DOES
//   - What it VALUES and how it ACTS
//   - Its MICRO components and MACRO behavior
//   - Its INTERNAL state and EXTERNAL expression
//
// Every Medina Law applies simultaneously across all dimensions.
//
// FORMAL STATEMENT:
//   For any law L and any point P on the cognitive sphere S:
//   L(P) = L(P_internal) ≡ L(P_external) ≡ L(P_micro) ≡ L(P_macro)
//
// COROLLARY (Value Integrity):
//   An organism that violates its values internally will violate them
//   externally. An organism true to its values at the micro level will
//   be true at the macro level.
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let OMEGA_MEDINA : Float = 2.11185;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let SIGMA_ZERO : Float = 0.75;
  let PI : Float = 3.14159265358979;

  // ==========================================================================
  // SPHERE DIMENSIONS
  // ==========================================================================
  // The cognitive sphere has multiple orthogonal dimensions
  
  public type SphereDimension = {
    #Internal;      // Thoughts, values, beliefs, identity
    #External;      // Actions, reactions, behaviors, outputs
    #Micro;         // Individual neuron, single drone, atomic decision
    #Macro;         // Swarm behavior, emergent patterns, collective
    #Temporal;      // Past memory, present state, future prediction
    #Spatial;       // Local neighborhood, global field
    #Value;         // Ethical constraints, mission priorities
    #Operational;   // Task execution, resource allocation
  };

  public let ALL_DIMENSIONS : [SphereDimension] = [
    #Internal, #External, #Micro, #Macro,
    #Temporal, #Spatial, #Value, #Operational
  ];

  // ==========================================================================
  // SPHERICAL POINT
  // ==========================================================================
  // A point on the cognitive sphere, defined by coordinates in each dimension
  
  public type SphericalPoint = {
    internal    : Float;    // 0-1 internal relevance
    external    : Float;    // 0-1 external relevance
    micro       : Float;    // 0-1 micro scale
    macro       : Float;    // 0-1 macro scale
    temporal    : Float;    // -1 to 1 (past to future)
    spatial     : Float;    // 0-1 (local to global)
    value       : Float;    // 0-1 value relevance
    operational : Float;    // 0-1 operational relevance
  };

  public let SPHERE_CENTER : SphericalPoint = {
    internal = 0.5; external = 0.5;
    micro = 0.5; macro = 0.5;
    temporal = 0.0; spatial = 0.5;
    value = 0.5; operational = 0.5;
  };

  // ==========================================================================
  // LAW APPLICATION RESULT
  // ==========================================================================
  // When a law is applied, it produces results across all dimensions
  
  public type LawApplicationResult = {
    lawName         : Text;
    inputPoint      : SphericalPoint;
    
    // Results per dimension
    internalResult  : Float;
    externalResult  : Float;
    microResult     : Float;
    macroResult     : Float;
    temporalResult  : Float;
    spatialResult   : Float;
    valueResult     : Float;
    operationalResult: Float;
    
    // Coherence across dimensions (all should be equal for true law)
    sphericalCoherence : Float;
    
    // Violations detected
    violations      : [Text];
  };

  // ==========================================================================
  // UTILITY FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  // ==========================================================================
  // SPHERICAL COHERENCE COMPUTATION
  // ==========================================================================
  // Measures how consistent a law's application is across all dimensions
  // Perfect coherence = 1.0 (all dimensions give same result)
  
  public func computeSphericalCoherence(results: [Float]) : Float {
    if (results.size() < 2) { return 1.0 };
    
    // Compute mean
    var sum : Float = 0.0;
    for (r in results.vals()) { sum += r };
    let mean = sum / Float.fromInt(results.size());
    
    // Compute variance
    var varSum : Float = 0.0;
    for (r in results.vals()) {
      let diff = r - mean;
      varSum += diff * diff;
    };
    let variance = varSum / Float.fromInt(results.size());
    
    // Coherence = 1 - normalized std dev
    let stdDev = Float.sqrt(variance);
    clamp(1.0 - stdDev, 0.0, 1.0)
  };

  // ==========================================================================
  // JASMINE'S LAW — SPHERICAL APPLICATION
  // ==========================================================================
  // Jasmine's Law ensures value alignment across ALL dimensions
  // Internal values must match external behavior
  // Micro values must match macro behavior
  
  public type JasmineSphericalInput = {
    internalValues    : Float;    // How strongly values are held internally
    externalBehavior  : Float;    // How values manifest in actions
    microAlignment    : Float;    // Individual component value adherence
    macroAlignment    : Float;    // Collective value adherence
    coherenceLevel    : Float;    // Current system coherence
  };

  public func applyJasmineSpherical(input: JasmineSphericalInput) : LawApplicationResult {
    // Jasmine's Law: Values must be consistent across sphere
    // J_spherical = Φ_M × min(all_alignments) × coherence
    
    let minAlignment = Float.min(
      Float.min(input.internalValues, input.externalBehavior),
      Float.min(input.microAlignment, input.macroAlignment)
    );
    
    let jasmineScore = PHI_MEDINA * minAlignment * input.coherenceLevel / PHI_MEDINA;
    
    // Check for violations
    var violations : [Text] = [];
    
    let internalExternalGap = abs(input.internalValues - input.externalBehavior);
    if (internalExternalGap > 0.2) {
      violations := Array.append(violations, 
        ["Internal-External value gap: " # Float.toText(internalExternalGap)]);
    };
    
    let microMacroGap = abs(input.microAlignment - input.macroAlignment);
    if (microMacroGap > 0.2) {
      violations := Array.append(violations,
        ["Micro-Macro value gap: " # Float.toText(microMacroGap)]);
    };
    
    let results = [
      input.internalValues,
      input.externalBehavior,
      input.microAlignment,
      input.macroAlignment,
      jasmineScore,
      jasmineScore,
      minAlignment,
      jasmineScore
    ];
    
    {
      lawName = "Jasmine's Law (Spherical)";
      inputPoint = {
        internal = input.internalValues;
        external = input.externalBehavior;
        micro = input.microAlignment;
        macro = input.macroAlignment;
        temporal = 0.0;
        spatial = 0.5;
        value = minAlignment;
        operational = jasmineScore;
      };
      internalResult = input.internalValues * input.coherenceLevel;
      externalResult = input.externalBehavior * input.coherenceLevel;
      microResult = input.microAlignment * input.coherenceLevel;
      macroResult = input.macroAlignment * input.coherenceLevel;
      temporalResult = jasmineScore;
      spatialResult = jasmineScore;
      valueResult = minAlignment;
      operationalResult = jasmineScore;
      sphericalCoherence = computeSphericalCoherence(results);
      violations = violations;
    }
  };

  // ==========================================================================
  // FIRST MEDINA LAW — SPHERICAL APPLICATION
  // ==========================================================================
  // Distributed Sovereignty applies at all scales
  
  public type FirstLawSphericalInput = {
    microSynchronies  : [Float];  // Individual agent sync levels
    macroCoherence    : Float;    // Swarm-level coherence
    internalStates    : [Float];  // Internal node synchronies
    externalOutputs   : [Float];  // External action coherence
  };

  public func applyFirstLawSpherical(input: FirstLawSphericalInput) : LawApplicationResult {
    // Compute harmonic mean at micro level
    let microHarmonic = computeHarmonicMean(input.microSynchronies);
    
    // Compute harmonic mean at macro level (use coherence directly)
    let macroResult = input.macroCoherence;
    
    // Internal/external should match
    let internalHarmonic = computeHarmonicMean(input.internalStates);
    let externalHarmonic = computeHarmonicMean(input.externalOutputs);
    
    // First Law: C = Φ_M × harmonicMean × √geometricMean
    let firstLawMicro = PHI_MEDINA * microHarmonic / PHI_MEDINA;
    let firstLawMacro = PHI_MEDINA * macroResult / PHI_MEDINA;
    let firstLawInternal = PHI_MEDINA * internalHarmonic / PHI_MEDINA;
    let firstLawExternal = PHI_MEDINA * externalHarmonic / PHI_MEDINA;
    
    var violations : [Text] = [];
    if (abs(firstLawMicro - firstLawMacro) > 0.3) {
      violations := Array.append(violations,
        ["Micro-Macro sovereignty gap detected"]);
    };
    
    let results = [firstLawMicro, firstLawMacro, firstLawInternal, firstLawExternal];
    
    {
      lawName = "First Medina Law (Spherical)";
      inputPoint = SPHERE_CENTER;
      internalResult = firstLawInternal;
      externalResult = firstLawExternal;
      microResult = firstLawMicro;
      macroResult = firstLawMacro;
      temporalResult = (firstLawMicro + firstLawMacro) / 2.0;
      spatialResult = (firstLawInternal + firstLawExternal) / 2.0;
      valueResult = Float.min(firstLawMicro, firstLawMacro);
      operationalResult = (firstLawMicro + firstLawMacro + firstLawInternal + firstLawExternal) / 4.0;
      sphericalCoherence = computeSphericalCoherence(results);
      violations = violations;
    }
  };

  func computeHarmonicMean(values: [Float]) : Float {
    if (values.size() == 0) { return SIGMA_ZERO };
    
    var reciprocalSum : Float = 0.0;
    for (v in values.vals()) {
      let clamped = clamp(v, 0.001, 1.0);
      reciprocalSum += 1.0 / clamped;
    };
    
    Float.fromInt(values.size()) / reciprocalSum
  };

  // ==========================================================================
  // SPHERICAL INTEGRITY CHECK
  // ==========================================================================
  // Verifies that all laws are being applied consistently across sphere
  
  public type IntegrityReport = {
    overallIntegrity  : Float;
    dimensionScores   : [(SphereDimension, Float)];
    violations        : [Text];
    recommendations   : [Text];
  };

  public func checkSphericalIntegrity(
    jasmineResult: LawApplicationResult,
    firstLawResult: LawApplicationResult
  ) : IntegrityReport {
    var violations : [Text] = [];
    var recommendations : [Text] = [];
    
    // Collect all violations
    for (v in jasmineResult.violations.vals()) { violations := Array.append(violations, [v]) };
    for (v in firstLawResult.violations.vals()) { violations := Array.append(violations, [v]) };
    
    // Compute dimension scores
    let internalScore = (jasmineResult.internalResult + firstLawResult.internalResult) / 2.0;
    let externalScore = (jasmineResult.externalResult + firstLawResult.externalResult) / 2.0;
    let microScore = (jasmineResult.microResult + firstLawResult.microResult) / 2.0;
    let macroScore = (jasmineResult.macroResult + firstLawResult.macroResult) / 2.0;
    
    // Overall integrity
    let overallIntegrity = (
      jasmineResult.sphericalCoherence + 
      firstLawResult.sphericalCoherence
    ) / 2.0;
    
    // Generate recommendations
    if (abs(internalScore - externalScore) > 0.2) {
      recommendations := Array.append(recommendations,
        ["Align internal values with external behaviors"]);
    };
    if (abs(microScore - macroScore) > 0.2) {
      recommendations := Array.append(recommendations,
        ["Ensure micro-level adherence matches macro-level patterns"]);
    };
    
    {
      overallIntegrity = overallIntegrity;
      dimensionScores = [
        (#Internal, internalScore),
        (#External, externalScore),
        (#Micro, microScore),
        (#Macro, macroScore)
      ];
      violations = violations;
      recommendations = recommendations;
    }
  };

  // ==========================================================================
  // THE MISSING LINK LAW
  // ==========================================================================
  // "Evolution proceeds through cycles of chaos and creation. Each cycle
  // produces emergent order from disorder. The missing link is not a species
  // but a process — the phase transition between chaos and coherence."
  //
  // FORMAL STATEMENT:
  //   P(emergence) = Φ_M × Π(chaos_cycles) × √(creation_events)
  //
  // Each chaos→creation cycle increases the probability of the next
  // emergence event. This compounds over evolutionary time.
  
  public type MissingLinkInput = {
    chaosCycles       : Nat;      // Number of chaos→creation cycles
    creationEvents    : Nat;      // Successful creation events
    currentChaos      : Float;    // Current chaos level (0-1)
    currentOrder      : Float;    // Current order level (0-1)
  };

  public type MissingLinkOutput = {
    emergenceProbability : Float;
    phaseState          : Text;   // "CHAOS", "TRANSITION", "CREATION", "STABLE"
    cycleProgress       : Float;  // Progress through current cycle
    nextPeakEstimate    : Nat;    // Beats until next emergence peak
  };

  public func applyMissingLinkLaw(input: MissingLinkInput) : MissingLinkOutput {
    // Compound effect of cycles
    let cycleEffect = Float.pow(PHI_MEDINA, Float.fromInt(input.chaosCycles) * 0.1);
    
    // Creation event contribution
    let creationEffect = Float.sqrt(Float.fromInt(input.creationEvents + 1));
    
    // Current state contribution
    let transitionTension = input.currentChaos * input.currentOrder;
    
    // Emergence probability
    let emergenceProb = clamp(
      cycleEffect * creationEffect * transitionTension / (PHI_MEDINA * 10.0),
      0.0,
      0.99
    );
    
    // Determine phase state
    let phaseState = if (input.currentChaos > 0.7 and input.currentOrder < 0.3) {
      "CHAOS"
    } else if (input.currentOrder > 0.7 and input.currentChaos < 0.3) {
      "STABLE"
    } else if (transitionTension > 0.4) {
      "TRANSITION"
    } else {
      "CREATION"
    };
    
    // Cycle progress (simplified)
    let cycleProgress = (input.currentChaos + input.currentOrder) / 2.0;
    
    {
      emergenceProbability = emergenceProb;
      phaseState = phaseState;
      cycleProgress = cycleProgress;
      nextPeakEstimate = 100;
    }
  };

}
