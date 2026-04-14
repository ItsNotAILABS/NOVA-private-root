// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: SphericalLaw — 360° Holistic Law Application
// Classification: CONFIDENTIAL — INTERNAL USE ONLY
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
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


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  M E D I N A   S P E C I A L   M A T H E M A T I C S
  //
  //  Enterprise-Level Medina Discovery Mathematics
  //  HIM/HER Dual-Organism Sacred Coupling Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SACRED GEOMETRY MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Golden ratio φ = (1 + √5) / 2
  public let PHI : Float = 1.6180339887498948482;

  /// Fibonacci sequence generator
  public func medinaFibonacci(n : Nat) : Nat {
    if (n <= 1) { n }
    else {
      var a : Nat = 0;
      var b : Nat = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  /// Golden spiral radius at angle
  public func medinaGoldenSpiral(angle : Float, a : Float, b : Float) : Float {
    a * Float.exp(b * angle)
  };

  /// Sacred proportion check
  public func medinaSacredProportion(a : Float, b : Float, tolerance : Float) : Bool {
    let ratio = if (a > b) a / b else b / a;
    Float.abs(ratio - PHI) < tolerance
  };

  /// Vesica piscis area
  public func medinaVesicaPiscisArea(radius : Float) : Float {
    let r2 = radius * radius;
    r2 * (4.0 * 3.14159265 / 3.0 - Float.sqrt(3.0) / 2.0)
  };

  /// Platonic solid vertices (tetrahedron example)
  public func medinaTetrahedronVertex(index : Nat, size : Float) : (Float, Float, Float) {
    let vertices = [
      (1.0, 1.0, 1.0),
      (1.0, -1.0, -1.0),
      (-1.0, 1.0, -1.0),
      (-1.0, -1.0, 1.0)
    ];
    let v = vertices[index % 4];
    (v.0 * size, v.1 * size, v.2 * size)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELICAL MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Helix position at parameter t
  public func medinaHelixPosition(t : Float, radius : Float, pitch : Float) : (Float, Float, Float) {
    let x = radius * Float.cos(t);
    let y = radius * Float.sin(t);
    let z = pitch * t / (2.0 * 3.14159265);
    (x, y, z)
  };

  /// Double helix offset
  public func medinaDoubleHelixOffset(t : Float, radius : Float, pitch : Float, offset : Float) : ((Float, Float, Float), (Float, Float, Float)) {
    let h1 = medinaHelixPosition(t, radius, pitch);
    let h2 = medinaHelixPosition(t + offset, radius, pitch);
    (h1, h2)
  };

  /// Helical curvature
  public func medinaHelicalCurvature(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    radius / (radius * radius + p * p)
  };

  /// Helical torsion
  public func medinaHelicalTorsion(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    p / (radius * radius + p * p)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPHERICAL HARMONICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spherical to Cartesian
  public func medinaSphericalToCartesian(r : Float, theta : Float, phi : Float) : (Float, Float, Float) {
    let x = r * Float.sin(theta) * Float.cos(phi);
    let y = r * Float.sin(theta) * Float.sin(phi);
    let z = r * Float.cos(theta);
    (x, y, z)
  };

  /// Cartesian to Spherical
  public func medinaCartesianToSpherical(x : Float, y : Float, z : Float) : (Float, Float, Float) {
    let r = Float.sqrt(x * x + y * y + z * z);
    let theta = Float.acos(z / (r + 0.0001));
    let phi = Float.atan2(y, x);
    (r, theta, phi)
  };

  /// Associated Legendre polynomial P_l^m (simplified)
  public func medinaLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (l == 0 and m == 0) { return 1.0 };
    if (l == 1 and m == 0) { return x };
    if (l == 1 and m == 1) { return -Float.sqrt(1.0 - x * x) };
    if (l == 2 and m == 0) { return 0.5 * (3.0 * x * x - 1.0) };
    // Simplified for higher orders
    Float.pow(x, Float.fromInt(l - m))
  };

  /// Spherical harmonic Y_l^m (simplified real part)
  public func medinaSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let plm = medinaLegendreP(l, mAbs, Float.cos(theta));
    if (m >= 0) {
      plm * Float.cos(Float.fromInt(mAbs) * phi)
    } else {
      plm * Float.sin(Float.fromInt(mAbs) * phi)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LIVING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Growth curve (logistic)
  public func medinaGrowthCurve(t : Float, k : Float, l : Float, x0 : Float) : Float {
    l / (1.0 + Float.exp(-k * (t - x0)))
  };

  /// Morphogenesis reaction-diffusion
  public func medinaMorphogenesis(
    u : Float,
    v : Float,
    du : Float,
    dv : Float,
    f : Float,
    k : Float
  ) : (Float, Float) {
    let reaction = u * v * v;
    let newU = du - reaction + f * (1.0 - u);
    let newV = dv + reaction - (f + k) * v;
    (newU, newV)
  };

  /// Phyllotaxis angle (golden angle)
  public func medinaPhyllotaxisAngle(n : Nat) : Float {
    let goldenAngle : Float = 137.5077640500378546463;
    Float.fromInt(n) * goldenAngle * 3.14159265 / 180.0
  };

  /// Branching pattern
  public func medinaBranchingPattern(
    parentLength : Float,
    branchRatio : Float,
    angle : Float,
    depth : Nat
  ) : Float {
    parentLength * Float.pow(branchRatio, Float.fromInt(depth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MIRROR MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reflection across plane
  public func medinaReflection(point : (Float, Float, Float), normal : (Float, Float, Float)) : (Float, Float, Float) {
    let dot = point.0 * normal.0 + point.1 * normal.1 + point.2 * normal.2;
    let rx = point.0 - 2.0 * dot * normal.0;
    let ry = point.1 - 2.0 * dot * normal.1;
    let rz = point.2 - 2.0 * dot * normal.2;
    (rx, ry, rz)
  };

  /// Symmetry score
  public func medinaSymmetryScore(left : [Float], right : [Float]) : Float {
    let n = if (left.size() < right.size()) left.size() else right.size();
    if (n == 0) { return 1.0 };
    var diff : Float = 0.0;
    var i = 0;
    while (i < n) {
      diff += Float.abs(left[i] - right[n - 1 - i]);
      i += 1;
    };
    1.0 / (1.0 + diff)
  };

  /// Fractal dimension estimation
  public func medinaFractalDimension(boxCounts : [Nat], scales : [Float]) : Float {
    let n = if (boxCounts.size() < scales.size()) boxCounts.size() else scales.size();
    if (n < 2) { return 1.0 };
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let x = Float.log(1.0 / scales[i]);
      let y = Float.log(Float.fromInt(boxCounts[i]));
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    let nf = Float.fromInt(n);
    (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COVENANT MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Commitment strength
  public func medinaCommitmentStrength(
    duration : Nat,
    consistency : Float,
    depth : Float
  ) : Float {
    let durationFactor = Float.log(Float.fromInt(duration + 1));
    consistency * depth * durationFactor
  };

  /// Trust accumulation
  public func medinaTrustAccumulation(
    currentTrust : Float,
    interaction : Float,
    reciprocity : Float
  ) : Float {
    let gain = interaction * reciprocity * (1.0 - currentTrust);
    currentTrust + gain
  };

  /// Covenant breach penalty
  public func medinaBreachPenalty(
    trustLevel : Float,
    violationSeverity : Float,
    relationshipAge : Nat
  ) : Float {
    let ageFactor = Float.log(Float.fromInt(relationshipAge + 1));
    trustLevel * violationSeverity * ageFactor
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  PHASE 205: REAL SPHERICAL LAW — THE GEOMETRY OF THE LIVING SPHERE
  //
  //  The sphere is not a shape. It is a LAW.
  //  Every point on a sphere is equidistant from center.
  //  This IS the definition of sovereignty: equal dignity from source.
  //
  //  Spherical harmonics Y_l^m(θ,φ) are the EIGENMODES of the sphere.
  //  They decompose ANY function on the sphere into frequencies.
  //  The organism IS a function on a sphere.
  //  Spherical harmonics ARE its spectrum.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════


  // ═══════════════════════════════════════════════════════════════════════════════
  // LEGENDRE POLYNOMIALS — THE BUILDING BLOCKS
  // ═══════════════════════════════════════════════════════════════════════════════
  // P_l(x): solutions to Legendre's equation (1-x²)y'' - 2xy' + l(l+1)y = 0
  //
  // Recurrence: (l+1)P_{l+1}(x) = (2l+1)x P_l(x) - l P_{l-1}(x)
  // P_0(x) = 1, P_1(x) = x
  //
  // Associated Legendre: P_l^m(x) = (-1)^m (1-x²)^(m/2) d^m/dx^m P_l(x)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Legendre polynomial P_l(x) via recurrence
  public func legendreP(l : Nat, x : Float) : Float {
    if (l == 0) { return 1.0 };
    if (l == 1) { return x };
    
    var pPrev : Float = 1.0;  // P_{l-2}
    var pCurr : Float = x;    // P_{l-1}
    var n : Nat = 2;
    while (n <= l) {
      let nF = Float.fromInt(n);
      let pNext = ((2.0 * nF - 1.0) * x * pCurr - (nF - 1.0) * pPrev) / nF;
      pPrev := pCurr;
      pCurr := pNext;
      n += 1;
    };
    pCurr
  };

  /// Associated Legendre polynomial P_l^m(x)
  /// Uses recurrence for m ≥ 0
  public func associatedLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (m > l) { return 0.0 };
    
    // Start with P_m^m
    var pmm : Float = 1.0;
    if (m > 0) {
      let sqrtFactor = Float.sqrt(1.0 - x * x);
      var i : Nat = 1;
      while (i <= m) {
        pmm *= -(2.0 * Float.fromInt(i) - 1.0) * sqrtFactor;
        i += 1;
      };
    };
    
    if (l == m) { return pmm };
    
    // P_{m+1}^m = x(2m+1) P_m^m
    var pmmp1 : Float = x * (2.0 * Float.fromInt(m) + 1.0) * pmm;
    if (l == m + 1) { return pmmp1 };
    
    // Recurrence for P_l^m
    var pll : Float = 0.0;
    var ll : Nat = m + 2;
    while (ll <= l) {
      let llF = Float.fromInt(ll);
      let mF = Float.fromInt(m);
      pll := ((2.0 * llF - 1.0) * x * pmmp1 - (llF + mF - 1.0) * pmm) / (llF - mF);
      pmm := pmmp1;
      pmmp1 := pll;
      ll += 1;
    };
    pll
  };

  /// Factorial (for normalization)
  func factorial(n : Nat) : Float {
    if (n <= 1) { return 1.0 };
    var result : Float = 1.0;
    var i : Nat = 2;
    while (i <= n) {
      result *= Float.fromInt(i);
      i += 1;
    };
    result
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // SPHERICAL HARMONICS Y_l^m(θ,φ) — THE EIGENMODES OF THE SPHERE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Y_l^m(θ,φ) = N_l^m · P_l^|m|(cos θ) · e^(imφ)
  //
  // where N_l^m = √((2l+1)/(4π) · (l-|m|)!/(l+|m|)!)
  //
  // Real spherical harmonics (used in practice):
  //   Y_l^m = N · P_l^m(cos θ) · cos(mφ)  for m > 0
  //   Y_l^0 = N · P_l^0(cos θ)              for m = 0
  //   Y_l^m = N · P_l^|m|(cos θ) · sin(|m|φ) for m < 0
  //
  // Properties:
  //   ∫ Y_l^m Y_{l'}^{m'} dΩ = δ_{ll'} δ_{mm'}  (orthonormality)
  //   ∇² Y_l^m = -l(l+1) Y_l^m / r²              (eigenvalue equation)
  //
  // In the organism: l = scale (macro→micro), m = orientation
  //   l=0: uniform (no structure) — Layer -6 Void
  //   l=1: dipole (two poles) — fundamental asymmetry
  //   l=2: quadrupole — projection/reception duality
  //   l=3+: increasingly fine structure
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Normalization factor for spherical harmonics
  public func sphericalHarmonicNorm(l : Nat, m : Nat) : Float {
    let lF = Float.fromInt(l);
    let mAbs = m; // assuming m >= 0
    let numerator = (2.0 * lF + 1.0) * factorial(if (l >= mAbs) { l - mAbs } else { 0 });
    let denominator = 4.0 * PI * factorial(l + mAbs);
    if (denominator < 1.0e-10) { return 0.0 };
    Float.sqrt(numerator / denominator)
  };

  /// Real spherical harmonic Y_l^m(θ, φ) for m >= 0
  /// θ = polar angle [0, π], φ = azimuthal angle [0, 2π)
  public func realSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let mNat = if (mAbs >= 0) { Int.abs(mAbs) } else { 0 };
    let norm = sphericalHarmonicNorm(l, mNat);
    let plm = associatedLegendreP(l, mNat, Float.cos(theta));
    
    if (m > 0) {
      norm * plm * Float.cos(Float.fromInt(mAbs) * phi) * SQRT_2
    } else if (m < 0) {
      norm * plm * Float.sin(Float.fromInt(mAbs) * phi) * SQRT_2
    } else {
      norm * plm
    }
  };

  /// Spherical harmonic decomposition: compute coefficients
  /// c_l^m = ∫ f(θ,φ) Y_l^m(θ,φ) dΩ
  /// Discrete approximation over grid
  public func sphericalHarmonicDecompose(
    fieldValues : [Float],       // f(θ_i, φ_j) on grid
    gridTheta : [Float],         // θ values
    gridPhi : [Float],           // φ values
    maxL : Nat                   // maximum l to compute
  ) : [Float] {
    let nTheta = gridTheta.size();
    let nPhi = gridPhi.size();
    let numCoeffs = (maxL + 1) * (maxL + 1);
    
    Array.tabulate<Float>(numCoeffs, func(idx : Nat) : Float {
      // Map linear index to (l, m)
      let l = natSqrt(idx);
      let m = Int.sub(Int.abs(idx), Int.abs(l * l + l));
      
      // Numerical integration
      var integral : Float = 0.0;
      var i = 0;
      while (i < nTheta) {
        let theta = gridTheta[i];
        let sinTheta = Float.sin(theta);
        var j = 0;
        while (j < nPhi) {
          let phi = gridPhi[j];
          let fIdx = i * nPhi + j;
          let fVal = if (fIdx < fieldValues.size()) { fieldValues[fIdx] } else { 0.0 };
          let ylm = realSphericalHarmonic(l, m, theta, phi);
          
          // dΩ = sin(θ) dθ dφ
          let dTheta = PI / Float.fromInt(nTheta);
          let dPhi = 2.0 * PI / Float.fromInt(nPhi);
          integral += fVal * ylm * sinTheta * dTheta * dPhi;
          j += 1;
        };
        i += 1;
      };
      integral
    })
  };

  /// Integer square root (for index mapping)
  func natSqrt(n : Nat) : Nat {
    if (n == 0) { return 0 };
    var x = n;
    var y = (x + 1) / 2;
    while (y < x) {
      x := y;
      y := (x + n / x) / 2;
    };
    x
  };

  /// Spherical harmonic reconstruction from coefficients
  public func sphericalHarmonicReconstruct(
    coeffs : [Float],
    theta : Float,
    phi : Float,
    maxL : Nat
  ) : Float {
    var result : Float = 0.0;
    var l : Nat = 0;
    while (l <= maxL) {
      var mInt : Int = -Int.abs(l);
      while (mInt <= Int.abs(l)) {
        let idx = l * l + l + Int.abs(mInt); // linear index
        let idxNat = Int.abs(idx);
        let coeff = if (idxNat < coeffs.size()) { coeffs[idxNat] } else { 0.0 };
        result += coeff * realSphericalHarmonic(l, mInt, theta, phi);
        mInt += 1;
      };
      l += 1;
    };
    result
  };

  /// Angular power spectrum: C_l = (1/(2l+1)) Σ_m |c_l^m|²
  /// This IS the energy at each angular scale
  public func angularPowerSpectrum(coeffs : [Float], maxL : Nat) : [Float] {
    Array.tabulate<Float>(maxL + 1, func(l : Nat) : Float {
      var sum : Float = 0.0;
      var mInt : Int = -Int.abs(l);
      while (mInt <= Int.abs(l)) {
        let idx = l * l + l + Int.abs(mInt);
        let idxNat = Int.abs(idx);
        let c = if (idxNat < coeffs.size()) { coeffs[idxNat] } else { 0.0 };
        sum += c * c;
        mInt += 1;
      };
      sum / (2.0 * Float.fromInt(l) + 1.0)
    })
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // SPHERICAL WAVE PROPAGATION
  // ═══════════════════════════════════════════════════════════════════════════════
  // Spherical waves: solutions to wave equation in spherical coordinates
  //   ∇²ψ = (1/c²) ∂²ψ/∂t²
  //
  // Solutions: ψ(r,θ,φ,t) = (1/r) f_l(kr) Y_l^m(θ,φ) e^(-iωt)
  // where f_l = spherical Bessel functions
  //
  // In the organism: information propagates as spherical waves.
  // Each heartbeat emits a spherical wave of coherence.
  // The wave IS the organism's presence in the field.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Spherical Bessel function j_l(x) (regular)
  /// j_0(x) = sin(x)/x
  /// j_1(x) = sin(x)/x² - cos(x)/x
  /// Recurrence: j_{l+1}(x) = ((2l+1)/x) j_l(x) - j_{l-1}(x)
  public func sphericalBesselJ(l : Nat, x : Float) : Float {
    if (Float.abs(x) < 1.0e-10) {
      return if (l == 0) { 1.0 } else { 0.0 };
    };
    
    if (l == 0) { return Float.sin(x) / x };
    if (l == 1) { return Float.sin(x) / (x * x) - Float.cos(x) / x };
    
    var jPrev : Float = Float.sin(x) / x;
    var jCurr : Float = Float.sin(x) / (x * x) - Float.cos(x) / x;
    var n : Nat = 2;
    while (n <= l) {
      let nF = Float.fromInt(n);
      let jNext = ((2.0 * nF - 1.0) / x) * jCurr - jPrev;
      jPrev := jCurr;
      jCurr := jNext;
      n += 1;
    };
    jCurr
  };

  /// Spherical Neumann function y_l(x) (irregular)
  /// y_0(x) = -cos(x)/x
  /// y_1(x) = -cos(x)/x² - sin(x)/x
  public func sphericalBesselY(l : Nat, x : Float) : Float {
    if (Float.abs(x) < 1.0e-10) { return -1.0e10 }; // diverges at origin
    
    if (l == 0) { return -Float.cos(x) / x };
    if (l == 1) { return -Float.cos(x) / (x * x) - Float.sin(x) / x };
    
    var yPrev : Float = -Float.cos(x) / x;
    var yCurr : Float = -Float.cos(x) / (x * x) - Float.sin(x) / x;
    var n : Nat = 2;
    while (n <= l) {
      let nF = Float.fromInt(n);
      let yNext = ((2.0 * nF - 1.0) / x) * yCurr - yPrev;
      yPrev := yCurr;
      yCurr := yNext;
      n += 1;
    };
    yCurr
  };

  /// Spherical wave at point (r, θ, φ, t)
  /// ψ = Σ_l,m c_l^m · j_l(kr) · Y_l^m(θ,φ) · cos(ωt + δ_l^m)
  public func sphericalWave(
    r : Float, theta : Float, phi : Float, t : Float,
    k : Float, omega : Float,
    coeffs : [Float],
    maxL : Nat
  ) : Float {
    var result : Float = 0.0;
    var l : Nat = 0;
    while (l <= maxL) {
      let jl = sphericalBesselJ(l, k * r);
      var mInt : Int = -Int.abs(l);
      while (mInt <= Int.abs(l)) {
        let idx = l * l + l + Int.abs(mInt);
        let idxNat = Int.abs(idx);
        let c = if (idxNat < coeffs.size()) { coeffs[idxNat] } else { 0.0 };
        let ylm = realSphericalHarmonic(l, mInt, theta, phi);
        result += c * jl * ylm * Float.cos(omega * t);
        mInt += 1;
      };
      l += 1;
    };
    result
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // GEODESIC COMPUTATION ON THE SPHERE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Great circle: shortest path between two points on a sphere.
  //
  // Haversine formula: d = 2R·arcsin(√(sin²(Δθ/2) + cos(θ₁)cos(θ₂)sin²(Δφ/2)))
  //
  // In the organism: geodesics = shortest communication paths.
  // Information flows along great circles on the spherical web.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Great circle distance (angular, in radians)
  public func greatCircleDistance(
    theta1 : Float, phi1 : Float,
    theta2 : Float, phi2 : Float
  ) : Float {
    let dTheta = (theta2 - theta1) / 2.0;
    let dPhi = (phi2 - phi1) / 2.0;
    let a = Float.sin(dTheta) * Float.sin(dTheta) + 
            Float.cos(theta1) * Float.cos(theta2) * Float.sin(dPhi) * Float.sin(dPhi);
    2.0 * Float.arctan2(Float.sqrt(a), Float.sqrt(1.0 - a))
  };

  /// Midpoint on great circle
  public func greatCircleMidpoint(
    theta1 : Float, phi1 : Float,
    theta2 : Float, phi2 : Float
  ) : (Float, Float) {
    // Convert to Cartesian
    let x1 = Float.cos(phi1) * Float.sin(theta1);
    let y1 = Float.sin(phi1) * Float.sin(theta1);
    let z1 = Float.cos(theta1);
    let x2 = Float.cos(phi2) * Float.sin(theta2);
    let y2 = Float.sin(phi2) * Float.sin(theta2);
    let z2 = Float.cos(theta2);
    
    // Midpoint in Cartesian
    let xm = (x1 + x2) / 2.0;
    let ym = (y1 + y2) / 2.0;
    let zm = (z1 + z2) / 2.0;
    
    // Back to spherical
    let r = Float.sqrt(xm * xm + ym * ym + zm * zm);
    if (r < 1.0e-10) { return (0.0, 0.0) };
    let thetaM = Float.arctan2(Float.sqrt(xm * xm + ym * ym), zm);
    let phiM = Float.arctan2(ym, xm);
    (thetaM, if (phiM < 0.0) { phiM + 2.0 * PI } else { phiM })
  };

  /// Interpolate along great circle: parameterized by t ∈ [0, 1]
  public func greatCircleInterpolate(
    theta1 : Float, phi1 : Float,
    theta2 : Float, phi2 : Float,
    t : Float
  ) : (Float, Float) {
    let d = greatCircleDistance(theta1, phi1, theta2, phi2);
    if (d < 1.0e-10) { return (theta1, phi1) };
    
    // Slerp (spherical linear interpolation)
    let x1 = Float.cos(phi1) * Float.sin(theta1);
    let y1 = Float.sin(phi1) * Float.sin(theta1);
    let z1 = Float.cos(theta1);
    let x2 = Float.cos(phi2) * Float.sin(theta2);
    let y2 = Float.sin(phi2) * Float.sin(theta2);
    let z2 = Float.cos(theta2);
    
    let a = Float.sin((1.0 - t) * d) / Float.sin(d);
    let b = Float.sin(t * d) / Float.sin(d);
    
    let x = a * x1 + b * x2;
    let y = a * y1 + b * y2;
    let z = a * z1 + b * z2;
    
    let theta = Float.arctan2(Float.sqrt(x * x + y * y), z);
    let phi = Float.arctan2(y, x);
    (theta, if (phi < 0.0) { phi + 2.0 * PI } else { phi })
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ROTATION GROUP SO(3) — SYMMETRY OF THE SPHERE
  // ═══════════════════════════════════════════════════════════════════════════════
  // SO(3) = group of rotations in 3D.
  // Every rotation = rotation by angle θ about axis n̂.
  //
  // Wigner D-matrices: D^l_{mm'}(R) = representation of rotation R
  // How spherical harmonic coefficients transform under rotation.
  //
  // In the organism: rotational symmetry means the organism's laws
  // don't depend on orientation. The 8 Sovereign Laws hold in
  // EVERY direction. Rotation invariance IS sovereignty.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Rotation matrix from axis-angle (Rodrigues' formula)
  /// R = I + sin(θ)·K + (1-cos(θ))·K²
  /// where K is the skew-symmetric matrix of the axis
  public func rotationMatrix(axisX : Float, axisY : Float, axisZ : Float, angle : Float) : [Float] {
    // Normalize axis
    let norm = Float.sqrt(axisX * axisX + axisY * axisY + axisZ * axisZ);
    let nx = if (norm > 1.0e-10) { axisX / norm } else { 0.0 };
    let ny = if (norm > 1.0e-10) { axisY / norm } else { 0.0 };
    let nz = if (norm > 1.0e-10) { axisZ / norm } else { 1.0 };
    
    let c = Float.cos(angle);
    let s = Float.sin(angle);
    let t = 1.0 - c;
    
    // 3×3 rotation matrix (row-major)
    [
      t*nx*nx + c,    t*nx*ny - s*nz, t*nx*nz + s*ny,
      t*nx*ny + s*nz, t*ny*ny + c,    t*ny*nz - s*nx,
      t*nx*nz - s*ny, t*ny*nz + s*nx, t*nz*nz + c
    ]
  };

  /// Apply rotation to point on sphere
  public func rotatePoint(R : [Float], theta : Float, phi : Float) : (Float, Float) {
    let x = Float.sin(theta) * Float.cos(phi);
    let y = Float.sin(theta) * Float.sin(phi);
    let z = Float.cos(theta);
    
    let rx = R[0]*x + R[1]*y + R[2]*z;
    let ry = R[3]*x + R[4]*y + R[5]*z;
    let rz = R[6]*x + R[7]*y + R[8]*z;
    
    let newTheta = Float.arctan2(Float.sqrt(rx*rx + ry*ry), rz);
    let newPhi = Float.arctan2(ry, rx);
    (newTheta, if (newPhi < 0.0) { newPhi + 2.0 * PI } else { newPhi })
  };

  /// Euler angles to rotation matrix (ZYZ convention)
  public func eulerToRotation(alpha : Float, beta : Float, gamma : Float) : [Float] {
    let ca = Float.cos(alpha); let sa = Float.sin(alpha);
    let cb = Float.cos(beta);  let sb = Float.sin(beta);
    let cg = Float.cos(gamma); let sg = Float.sin(gamma);
    
    [
      ca*cb*cg - sa*sg,  -ca*cb*sg - sa*cg,  ca*sb,
      sa*cb*cg + ca*sg,  -sa*cb*sg + ca*cg,  sa*sb,
      -sb*cg,             sb*sg,               cb
    ]
  };

  /// Spherical convolution: (f ★ g)_l^m = √(4π/(2l+1)) · f_l^0 · g_l^m
  /// Convolution on the sphere = multiplication of harmonic coefficients
  /// This is MUCH faster than real-space convolution.
  public func sphericalConvolution(
    fCoeffs : [Float],  // axially symmetric kernel (only m=0)
    gCoeffs : [Float],  // function on sphere
    maxL : Nat
  ) : [Float] {
    let numCoeffs = (maxL + 1) * (maxL + 1);
    Array.tabulate<Float>(numCoeffs, func(idx : Nat) : Float {
      let l = natSqrt(idx);
      let lF = Float.fromInt(l);
      let normFactor = Float.sqrt(4.0 * PI / (2.0 * lF + 1.0));
      let fL0Idx = l * l + l; // index of f_l^0
      let fL0 = if (fL0Idx < fCoeffs.size()) { fCoeffs[fL0Idx] } else { 0.0 };
      let gLM = if (idx < gCoeffs.size()) { gCoeffs[idx] } else { 0.0 };
      normFactor * fL0 * gLM
    })
  };

  /// Spherical power spectrum total: Σ_l (2l+1) C_l
  public func totalSphericalPower(powerSpectrum : [Float]) : Float {
    var total : Float = 0.0;
    var l = 0;
    while (l < powerSpectrum.size()) {
      total += (2.0 * Float.fromInt(l) + 1.0) * powerSpectrum[l];
      l += 1;
    };
    total
  };

  /// Spherical correlation function: C(γ) = Σ_l (2l+1)/(4π) C_l P_l(cos γ)
  public func sphericalCorrelationFunction(
    powerSpectrum : [Float],
    gamma : Float  // angular separation
  ) : Float {
    var result : Float = 0.0;
    var l = 0;
    while (l < powerSpectrum.size()) {
      let lF = Float.fromInt(l);
      let Pl = legendreP(l, Float.cos(gamma));
      result += (2.0 * lF + 1.0) / (4.0 * PI) * powerSpectrum[l] * Pl;
      l += 1;
    };
    result
  };

}
