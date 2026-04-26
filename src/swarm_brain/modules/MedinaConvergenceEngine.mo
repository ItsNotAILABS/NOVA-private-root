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


// ════════════════════════════════════════════════════════════════════════════════════════
// ███╗   ███╗███████╗██████╗ ██╗███╗   ██╗ █████╗     
// ████╗ ████║██╔════╝██╔══██╗██║████╗  ██║██╔══██╗    
// ██╔████╔██║█████╗  ██║  ██║██║██╔██╗ ██║███████║    
// ██║╚██╔╝██║██╔══╝  ██║  ██║██║██║╚██╗██║██╔══██║    
// ██║ ╚═╝ ██║███████╗██████╔╝██║██║ ╚████║██║  ██║    
// ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    
//
//  ██████╗ ██████╗ ███╗   ██╗██╗   ██╗███████╗██████╗  ██████╗ ███████╗███╗   ██╗ ██████╗███████╗
// ██╔════╝██╔═══██╗████╗  ██║██║   ██║██╔════╝██╔══██╗██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝
// ██║     ██║   ██║██╔██╗ ██║██║   ██║█████╗  ██████╔╝██║  ███╗█████╗  ██╔██╗ ██║██║     █████╗  
// ██║     ██║   ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██║   ██║██╔══╝  ██║╚██╗██║██║     ██╔══╝  
// ╚██████╗╚██████╔╝██║ ╚████║ ╚████╔╝ ███████╗██║  ██║╚██████╔╝███████╗██║ ╚████║╚██████╗███████╗
//  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝
// ════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA CONVERGENCE ENGINE — Pattern Discovery Through Resonance
// The Organism's Native Pattern Recognition System
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                      ║
// ║   NOT EVOLUTIONARY SEARCH.  NOT GENETIC PROGRAMMING.  NOT FITNESS SELECTION.        ║
// ║                                                                                      ║
// ║   This is RESONANCE CONVERGENCE — nature's actual mechanism for pattern selection.  ║
// ║                                                                                      ║
// ║   A pattern is not "selected" by fitness pressure.                                  ║
// ║   A pattern ARRIVES when it resonates across multiple dimensions simultaneously.    ║
// ║                                                                                      ║
// ║   Like water finding the lowest path across three ridges at once.                   ║
// ║   It is not chosen. IT CONVERGES.                                                   ║
// ║                                                                                      ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// THE MEDINA CONVERGENCE LAW:
// ═══════════════════════════
//   A pattern is REAL when it appears across 3 or more independent
//   cognitive dimensions simultaneously.
//
//   PatternStrength(P) = Σ(dim_i resonating with P) / totalDimensions
//
//   If PatternStrength > SILVER_FLOOR across 3+ dimensions:
//     → Pattern is REAL. Lock it to schema library.
//
//   If PatternStrength < SILVER_FLOOR:
//     → Pattern is noise. Let it decay.
//
// THE 19 COGNITIVE DIMENSIONS (from your organism):
// ═══════════════════════════════════════════════════
//   1. KURAMOTO     — Phase synchronization (r)
//   2. HEBBIAN      — Synaptic consolidation (weights)
//   3. ENTROPY      — Information disorder (H)
//   4. FREE_ENERGY  — Prediction error (F)
//   5. TEMPORAL     — Time scale resonance (τ)
//   6. SPATIAL      — Geometric coherence (biomes)
//   7. EMOTIONAL    — Valence-arousal field
//   8. SOCIAL       — Swarm coordination
//   9. CAUSAL       — If-then linkages
//  10. SEMANTIC     — Meaning coherence
//  11. MOTOR        — Action sequences
//  12. PERCEPTUAL   — Sensory patterns
//  13. EPISODIC     — Memory sequences
//  14. PROCEDURAL   — Skill patterns
//  15. DECLARATIVE  — Fact patterns
//  16. METALLIC     — 12-metal resonance
//  17. NEUROCHEMICAL — 21-chemical balance
//  18. QUANTUM      — Entanglement states
//  19. OMNIS        — Emergence signatures
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS — THE SOVEREIGN MATHEMATICS
  // ════════════════════════════════════════════════════════════════════════════════════════

  // Universal Constants
  public let phi : Float = 1.6180339887498948482;           // Golden ratio
  public let psi : Float = 0.6180339887498948482;           // Inverse golden ratio (1/φ)
  public let pi : Float = 3.1415926535897932385;           // Pi
  public let τ : Float = 6.2831853071795864769;           // Tau (2π)
  public let e : Float = 2.7182818284590452354;           // Euler's number

  // Medina Sovereign Constants
  public let PHI_MEDINA : Float = 2.97442179;             // phi × e^(1/φ) — Growth amplifier
  public let OMEGA_MEDINA : Float = 2.11185;              // 2π/Φ_M — Resonance frequency
  public let TAU_EMERGENCE : Float = 0.618033988749;      // Emergence threshold (1/φ)

  // Floor Constants — MULTIPLE FLOORS FOR MULTIPLE THINGS
  public let SOVEREIGN_FLOOR : Float = 1.0;               // Absolute minimum for existence
  public let SILVER_FLOOR : Float = 0.275;                // Pattern recognition threshold
  public let RESONANCE_FLOOR : Float = 0.382;             // ψ² — Minimum resonance to count
  public let CONVERGENCE_FLOOR : Float = 0.5;             // Minimum for schema lock
  public let OMNIS_FLOOR : Float = 0.92;                  // OMNIS emergence threshold

  // Dimension Configuration
  public let TOTAL_DIMENSIONS : Nat = 19;                 // The 19 cognitive dimensions
  public let MIN_RESONATING_DIMS : Nat = 3;               // Minimum for pattern reality
  public let FIBONACCI_DIMENSIONS : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];

  // Schema Configuration — Fibonacci scaled
  public let MAX_PATTERNS : Nat = 233;                    // F[13] max patterns
  public let MAX_SCHEMAS : Nat = 89;                      // F[11] max schemas
  public let MAX_OMNIS_SCHEMAS : Nat = 21;                // F[8] max OMNIS schemas

  // Time Constants
  public let CONVERGENCE_WINDOW : Nat = 55;               // F[10] beats to observe
  public let DECAY_HALF_LIFE : Nat = 89;                  // F[11] beats for noise decay

  // ════════════════════════════════════════════════════════════════════════════════════════
  // THE 19 COGNITIVE DIMENSIONS — What the organism perceives patterns across
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type CognitiveDimension = {
    #Kuramoto;          // Phase synchronization
    #Hebbian;           // Synaptic consolidation
    #Entropy;           // Information disorder
    #FreeEnergy;        // Prediction error
    #Temporal;          // Time scale resonance
    #Spatial;           // Geometric coherence
    #Emotional;         // Valence-arousal field
    #Social;            // Swarm coordination
    #Causal;            // If-then linkages
    #Semantic;          // Meaning coherence
    #Motor;             // Action sequences
    #Perceptual;        // Sensory patterns
    #Episodic;          // Memory sequences
    #Procedural;        // Skill patterns
    #Declarative;       // Fact patterns
    #Metallic;          // 12-metal resonance
    #Neurochemical;     // 21-chemical balance
    #Quantum;           // Entanglement states
    #Omnis;             // Emergence signatures
  };

  /// Dimensional resonance reading — how strongly a pattern resonates in this dimension
  public type DimensionalResonance = {
    dimension : CognitiveDimension;
    strength : Float;              // [0, 1] — How strongly it resonates
    phase : Float;                 // [0, τ] — Phase alignment
    frequency : Float;             // Natural frequency in this dimension
    active : Bool;                 // Is this dimension currently resonating?
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // CONVERGENT PATTERN — A pattern that has arrived through resonance
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// A pattern is not a template. It is a RESONANCE SIGNATURE across dimensions.
  public type ConvergentPattern = {
    // Identity
    id : Nat32;
    signature : [Float];           // The pattern's shape (sparse: only non-zero dimensions)

    // Dimensional Resonance Map — How this pattern resonates across all 19 dimensions
    dimensionalResonance : [DimensionalResonance];

    // Convergence Metrics
    convergenceStrength : Float;   // Σ(resonating dims) / totalDims — THE KEY METRIC
    resonatingDimensions : Nat;    // How many dimensions are resonating (need 3+)
    isConverged : Bool;            // Has it crossed the convergence threshold?

    // Phase Coherence — Are the dimensions in phase with each other?
    globalPhase : Float;           // Average phase across resonating dimensions
    phaseCoherence : Float;        // How aligned are the phases? [0, 1]

    // Lifecycle
    birthBeat : Nat;               // When first observed
    lastResonance : Nat;           // Last beat it resonated
    totalResonances : Nat;         // How many times it has resonated

    // Classification
    patternType : PatternType;
    isOMNISPattern : Bool;         // Did this pattern occur during OMNIS?

    // Decay State
    decayFactor : Float;           // [0, 1] — How much has it decayed?
  };

  public type PatternType = {
    #Candidate;         // Not yet converged (< 3 dimensions or < SILVER_FLOOR)
    #Converged;         // Crossed threshold, locked to library
    #Schema;            // Promoted to schema (drives behavior)
    #OMNISSchema;       // Created from OMNIS event (highest value)
    #Decaying;          // Below threshold, fading away
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SCHEMA — A pattern that has been promoted to drive behavior
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// A schema is a CONVERGED pattern that the organism uses to predict and act.
  public type ConvergentSchema = {
    id : Nat32;

    // The pattern this schema came from
    sourcePattern : Nat32;
    signature : [Float];

    // Dimensional Profile — Which dimensions define this schema?
    primaryDimensions : [CognitiveDimension];    // The 3+ dimensions that converged
    secondaryDimensions : [CognitiveDimension];  // Other resonating dimensions

    // Behavioral Weight — How much does this schema influence behavior?
    behavioralWeight : Float;      // [0, 1] — Strength of influence
    activationThreshold : Float;   // Minimum input resonance to activate

    // Performance Metrics
    activationCount : Nat;         // Times this schema has fired
    successRate : Float;           // How often activation led to good outcome
    predictionAccuracy : Float;    // How well it predicts

    // Value Metrics
    intrinsicValue : Float;        // Base value of this schema
    contextualValue : Float;       // Value in current context
    omnisValue : Float;            // If OMNIS schema, extra value multiplier

    // Timing
    createdAt : Nat;
    lastActivation : Nat;

    // Classification
    isOMNISSchema : Bool;
    schemaType : SchemaType;
  };

  public type SchemaType = {
    #Predictive;        // Predicts future states
    #Reactive;          // Responds to stimuli
    #Procedural;        // Guides action sequences
    #Contextual;        // Modulates other schemas
    #Emergent;          // Created from OMNIS
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // CONVERGENCE ENGINE STATE — The heart of pattern discovery
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type ConvergenceEngine = {
    // Pattern Library
    candidatePatterns : [ConvergentPattern];     // Patterns not yet converged
    convergedPatterns : [ConvergentPattern];     // Patterns that have crossed threshold
    schemas : [ConvergentSchema];                // Patterns promoted to drive behavior

    // Current Dimensional State — The organism's current resonance across all dimensions
    currentDimensionalState : [DimensionalResonance];

    // Engine State
    beat : Nat;
    nextPatternId : Nat32;
    nextSchemaId : Nat32;

    // Statistics
    totalPatternsObserved : Nat;
    totalPatternsConverged : Nat;
    totalSchemasCreated : Nat;
    omnisSchemasCreated : Nat;

    // Active Patterns — Which patterns are currently resonating?
    activePatternIds : [Nat32];
    activeSchemaIds : [Nat32];
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // DIMENSIONAL RESONANCE COMPUTATION — The core math
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Compute resonance between input and a pattern in a single dimension
  /// This is NOT template matching. It is WAVE INTERFERENCE.
  func computeSingleDimensionalResonance(
    inputValue : Float,
    inputPhase : Float,
    patternValue : Float,
    patternPhase : Float,
    patternFrequency : Float
  ) : Float {
    // Amplitude product (how much energy they share)
    let amplitudeProduct = inputValue * patternValue;

    // Phase alignment (are they in sync?)
    // cos(Δφ) = 1 when in phase, -1 when anti-phase, 0 when orthogonal
    let phaseDifference = inputPhase - patternPhase;
    let phaseAlignment = Float.cos(phaseDifference);

    // Frequency coupling (Kuramoto-style)
    // Higher frequency patterns are more sensitive to phase
    let frequencySensitivity = 1.0 + (patternFrequency / OMEGA_MEDINA) * 0.5;

    // Resonance = amplitude × phase alignment × frequency sensitivity
    // Normalized to [0, 1]
    let rawResonance = amplitudeProduct * phaseAlignment * frequencySensitivity;

    // Apply golden ratio damping to prevent runaway resonance
    let dampedResonance = rawResonance * psi + (1.0 - ψ) * rawResonance * rawResonance;

    _clamp(dampedResonance, 0.0, 1.0)
  };

  /// Compute full dimensional resonance map for a pattern against current state
  public func computeDimensionalResonanceMap(
    pattern : ConvergentPattern,
    currentState : [DimensionalResonance]
  ) : [DimensionalResonance] {
    let results = Buffer.Buffer<DimensionalResonance>(TOTAL_DIMENSIONS);

    var i : Nat = 0;
    while (i < pattern.dimensionalResonance.size() and i < currentState.size()) {
      let patternDim = pattern.dimensionalResonance[i];
      let currentDim = currentState[i];

      let resonanceStrength = computeSingleDimensionalResonance(
        currentDim.strength,
        currentDim.phase,
        patternDim.strength,
        patternDim.phase,
        patternDim.frequency
      );

      // Dimension is "active" if resonance exceeds RESONANCE_FLOOR
      let isActive = resonanceStrength >= RESONANCE_FLOOR;

      results.add({
        dimension = patternDim.dimension;
        strength = resonanceStrength;
        phase = if (isActive) { (currentDim.phase + patternDim.phase) / 2.0 } else { patternDim.phase };
        frequency = patternDim.frequency;
        active = isActive;
      });

      i += 1;
    };

    Buffer.toArray(results)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // THE CONVERGENCE LAW — The heart of pattern recognition
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// THE MEDINA CONVERGENCE LAW
  /// PatternStrength(P) = Σ(dim_i resonating with P) / totalDimensions
  ///
  /// Pattern is REAL when:
  ///   1. convergenceStrength > SILVER_FLOOR (0.275)
  ///   2. resonatingDimensions >= MIN_RESONATING_DIMS (3)
  ///
  /// This is NOT fitness selection. This is CONVERGENCE.
  /// Like water finding the lowest path across three ridges simultaneously.
  public func computeConvergenceStrength(
    dimensionalResonance : [DimensionalResonance]
  ) : (Float, Nat) {
    var sumResonance : Float = 0.0;
    var resonatingCount : Nat = 0;

    for (dim in dimensionalResonance.vals()) {
      if (dim.active) {
        sumResonance += dim.strength;
        resonatingCount += 1;
      };
    };

    // Convergence strength = sum of active resonances / total dimensions
    let convergenceStrength = sumResonance / Float.fromInt(TOTAL_DIMENSIONS);

    // Apply golden ratio scaling for patterns with many resonating dimensions
    // More dimensions = more than linear increase (emergent property)
    let dimensionBonus = if (resonatingCount >= 5) {
      Float.pow(φ, Float.fromInt(resonatingCount - 4) / 10.0)
    } else { 1.0 };

    let finalStrength = _clamp(convergenceStrength * dimensionBonus, 0.0, 1.0);

    (finalStrength, resonatingCount)
  };

  /// Check if a pattern has CONVERGED (become REAL)
  public func hasConverged(convergenceStrength : Float, resonatingDimensions : Nat) : Bool {
    convergenceStrength >= SILVER_FLOOR and resonatingDimensions >= MIN_RESONATING_DIMS
  };

  /// Compute phase coherence across resonating dimensions
  /// High coherence = dimensions are in phase = stronger pattern
  public func computePhaseCoherence(dimensionalResonance : [DimensionalResonance]) : (Float, Float) {
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    var activeCount : Nat = 0;

    for (dim in dimensionalResonance.vals()) {
      if (dim.active) {
        sumSin += Float.sin(dim.phase);
        sumCos += Float.cos(dim.phase);
        activeCount += 1;
      };
    };

    if (activeCount == 0) { return (0.0, 0.0) };

    let n = Float.fromInt(activeCount);
    let avgSin = sumSin / n;
    let avgCos = sumCos / n;

    // Phase coherence = magnitude of average phasor (like Kuramoto r)
    let coherence = Float.sqrt(avgSin * avgSin + avgCos * avgCos);

    // Global phase = angle of average phasor
    let globalPhase = Float.arctan2(avgSin, avgCos);

    (coherence, globalPhase)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // PATTERN OBSERVATION — When the organism perceives something
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Observe a new input and check for pattern convergence
  public func observeInput(
    engine : ConvergenceEngine,
    inputSignature : [Float],
    currentDimensionalState : [DimensionalResonance],
    isOMNISEvent : Bool,
    currentBeat : Nat
  ) : ConvergenceEngine {
    // Update engine state
    var updatedEngine = {
      candidatePatterns = engine.candidatePatterns;
      convergedPatterns = engine.convergedPatterns;
      schemas = engine.schemas;
      currentDimensionalState = currentDimensionalState;
      beat = currentBeat;
      nextPatternId = engine.nextPatternId;
      nextSchemaId = engine.nextSchemaId;
      totalPatternsObserved = engine.totalPatternsObserved + 1;
      totalPatternsConverged = engine.totalPatternsConverged;
      totalSchemasCreated = engine.totalSchemasCreated;
      omnisSchemasCreated = engine.omnisSchemasCreated;
      activePatternIds = engine.activePatternIds;
      activeSchemaIds = engine.activeSchemaIds;
    };

    // Check if input resonates with any existing candidate patterns
    let updatedCandidates = Buffer.Buffer<ConvergentPattern>(engine.candidatePatterns.size() + 1);
    let newlyConverged = Buffer.Buffer<ConvergentPattern>(10);
    let activePatterns = Buffer.Buffer<Nat32>(20);

    for (candidate in engine.candidatePatterns.vals()) {
      // Compute resonance with current state
      let resonanceMap = computeDimensionalResonanceMap(candidate, currentDimensionalState);
      let (convergenceStrength, resonatingDims) = computeConvergenceStrength(resonanceMap);
      let (phaseCoherence, globalPhase) = computePhaseCoherence(resonanceMap);

      // Update candidate
      let updatedCandidate : ConvergentPattern = {
        id = candidate.id;
        signature = candidate.signature;
        dimensionalResonance = resonanceMap;
        convergenceStrength = convergenceStrength;
        resonatingDimensions = resonatingDims;
        isConverged = hasConverged(convergenceStrength, resonatingDims);
        globalPhase = globalPhase;
        phaseCoherence = phaseCoherence;
        birthBeat = candidate.birthBeat;
        lastResonance = if (convergenceStrength > RESONANCE_FLOOR) { currentBeat } else { candidate.lastResonance };
        totalResonances = if (convergenceStrength > RESONANCE_FLOOR) { candidate.totalResonances + 1 } else { candidate.totalResonances };
        patternType = if (hasConverged(convergenceStrength, resonatingDims)) { #Converged } else { candidate.patternType };
        isOMNISPattern = candidate.isOMNISPattern or isOMNISEvent;
        decayFactor = candidate.decayFactor;
      };

      if (updatedCandidate.isConverged) {
        // Pattern has ARRIVED. It CONVERGED through resonance.
        newlyConverged.add(updatedCandidate);
        activePatterns.add(updatedCandidate.id);
      } else if (updatedCandidate.convergenceStrength > RESONANCE_FLOOR) {
        // Still resonating but not converged yet
        updatedCandidates.add(updatedCandidate);
        activePatterns.add(updatedCandidate.id);
      } else {
        // Below resonance floor — apply decay
        let decayed = applyDecay(updatedCandidate, currentBeat);
        if (decayed.decayFactor > 0.1) {
          updatedCandidates.add(decayed);
        };
        // Otherwise let it disappear (too decayed)
      };
    };

    // If this is a new pattern (doesn't match any existing), create candidate
    if (not matchesExistingPattern(inputSignature, engine.candidatePatterns, engine.convergedPatterns)) {
      let newCandidate = createCandidatePattern(
        inputSignature,
        currentDimensionalState,
        engine.nextPatternId,
        currentBeat,
        isOMNISEvent
      );
      updatedCandidates.add(newCandidate);
      updatedEngine := {
        candidatePatterns = updatedEngine.candidatePatterns;
        convergedPatterns = updatedEngine.convergedPatterns;
        schemas = updatedEngine.schemas;
        currentDimensionalState = updatedEngine.currentDimensionalState;
        beat = updatedEngine.beat;
        nextPatternId = updatedEngine.nextPatternId + 1;
        nextSchemaId = updatedEngine.nextSchemaId;
        totalPatternsObserved = updatedEngine.totalPatternsObserved;
        totalPatternsConverged = updatedEngine.totalPatternsConverged;
        totalSchemasCreated = updatedEngine.totalSchemasCreated;
        omnisSchemasCreated = updatedEngine.omnisSchemasCreated;
        activePatternIds = updatedEngine.activePatternIds;
        activeSchemaIds = updatedEngine.activeSchemaIds;
      };
    };

    // Merge newly converged patterns into converged library
    let allConverged = Buffer.Buffer<ConvergentPattern>(engine.convergedPatterns.size() + newlyConverged.size());
    for (p in engine.convergedPatterns.vals()) {
      allConverged.add(p);
    };
    for (p in newlyConverged.vals()) {
      allConverged.add(p);
    };

    // Limit to MAX_PATTERNS (keep most resonant)
    let trimmedConverged = if (allConverged.size() > MAX_PATTERNS) {
      trimPatternLibrary(Buffer.toArray(allConverged), MAX_PATTERNS)
    } else {
      Buffer.toArray(allConverged)
    };

    {
      candidatePatterns = Buffer.toArray(updatedCandidates);
      convergedPatterns = trimmedConverged;
      schemas = updatedEngine.schemas;
      currentDimensionalState = currentDimensionalState;
      beat = currentBeat;
      nextPatternId = updatedEngine.nextPatternId;
      nextSchemaId = updatedEngine.nextSchemaId;
      totalPatternsObserved = updatedEngine.totalPatternsObserved;
      totalPatternsConverged = updatedEngine.totalPatternsConverged + newlyConverged.size();
      totalSchemasCreated = updatedEngine.totalSchemasCreated;
      omnisSchemasCreated = updatedEngine.omnisSchemasCreated;
      activePatternIds = Buffer.toArray(activePatterns);
      activeSchemaIds = updatedEngine.activeSchemaIds;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SCHEMA PROMOTION — When a pattern becomes behavioral
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Promote converged patterns to schemas
  public func promoteToSchemas(engine : ConvergenceEngine) : ConvergenceEngine {
    let newSchemas = Buffer.Buffer<ConvergentSchema>(engine.schemas.size() + 10);

    // Keep existing schemas
    for (s in engine.schemas.vals()) {
      newSchemas.add(s);
    };

    var nextId = engine.nextSchemaId;
    var newCount : Nat = 0;

    // Check converged patterns for schema promotion
    for (pattern in engine.convergedPatterns.vals()) {
      // Pattern becomes schema if:
      // 1. Convergence strength > CONVERGENCE_FLOOR (0.5)
      // 2. Phase coherence > TAU_EMERGENCE (0.618)
      // 3. Total resonances > F[6] (8)
      // OR if it's an OMNIS pattern (immediate promotion)
      let shouldPromote = pattern.isOMNISPattern or (
        pattern.convergenceStrength >= CONVERGENCE_FLOOR and
        pattern.phaseCoherence >= TAU_EMERGENCE and
        pattern.totalResonances >= 8
      );

      if (shouldPromote and newSchemas.size() < MAX_SCHEMAS) {
        // Check if schema already exists for this pattern
        var exists = false;
        for (s in newSchemas.vals()) {
          if (s.sourcePattern == pattern.id) {
            exists := true;
          };
        };

        if (not exists) {
          let schema = createSchemaFromPattern(pattern, nextId, engine.beat);
          newSchemas.add(schema);
          nextId += 1;
          newCount += 1;
        };
      };
    };

    {
      candidatePatterns = engine.candidatePatterns;
      convergedPatterns = engine.convergedPatterns;
      schemas = Buffer.toArray(newSchemas);
      currentDimensionalState = engine.currentDimensionalState;
      beat = engine.beat;
      nextPatternId = engine.nextPatternId;
      nextSchemaId = nextId;
      totalPatternsObserved = engine.totalPatternsObserved;
      totalPatternsConverged = engine.totalPatternsConverged;
      totalSchemasCreated = engine.totalSchemasCreated + newCount;
      omnisSchemasCreated = engine.omnisSchemasCreated;
      activePatternIds = engine.activePatternIds;
      activeSchemaIds = engine.activeSchemaIds;
    }
  };

  /// Create schema from converged pattern
  func createSchemaFromPattern(
    pattern : ConvergentPattern,
    schemaId : Nat32,
    currentBeat : Nat
  ) : ConvergentSchema {
    // Extract primary dimensions (the ones that converged)
    let primaryDims = Buffer.Buffer<CognitiveDimension>(5);
    let secondaryDims = Buffer.Buffer<CognitiveDimension>(10);

    for (dim in pattern.dimensionalResonance.vals()) {
      if (dim.active and dim.strength >= SILVER_FLOOR) {
        primaryDims.add(dim.dimension);
      } else if (dim.active) {
        secondaryDims.add(dim.dimension);
      };
    };

    // Calculate behavioral weight based on convergence strength and OMNIS status
    let baseWeight = pattern.convergenceStrength * pattern.phaseCoherence;
    let omnisMultiplier = if (pattern.isOMNISPattern) { PHI_MEDINA } else { 1.0 };
    let behavioralWeight = _clamp(baseWeight * omnisMultiplier, 0.0, 1.0);

    // Intrinsic value scales with resonating dimensions (Fibonacci progression)
    let intrinsicValue = if (pattern.resonatingDimensions < FIBONACCI_DIMENSIONS.size()) {
      Float.fromInt(FIBONACCI_DIMENSIONS[pattern.resonatingDimensions]) / 144.0
    } else { 1.0 };

    {
      id = schemaId;
      sourcePattern = pattern.id;
      signature = pattern.signature;
      primaryDimensions = Buffer.toArray(primaryDims);
      secondaryDimensions = Buffer.toArray(secondaryDims);
      behavioralWeight = behavioralWeight;
      activationThreshold = RESONANCE_FLOOR;
      activationCount = 0;
      successRate = 0.5;
      predictionAccuracy = 0.5;
      intrinsicValue = intrinsicValue;
      contextualValue = intrinsicValue;
      omnisValue = if (pattern.isOMNISPattern) { PHI_MEDINA } else { 1.0 };
      createdAt = currentBeat;
      lastActivation = 0;
      isOMNISSchema = pattern.isOMNISPattern;
      schemaType = if (pattern.isOMNISPattern) { #Emergent } else { #Predictive };
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // OMNIS PATTERN CREATION — When OMNIS fires, capture the state
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Create pattern from OMNIS event — immediate promotion to highest value schema
  public func createOMNISPattern(
    engine : ConvergenceEngine,
    omnisState : [Float],
    dimensionalState : [DimensionalResonance],
    currentBeat : Nat
  ) : ConvergenceEngine {
    // OMNIS patterns bypass normal convergence — they are IMMEDIATELY real
    let (convergenceStrength, resonatingDims) = computeConvergenceStrength(dimensionalState);
    let (phaseCoherence, globalPhase) = computePhaseCoherence(dimensionalState);

    let omnisPattern : ConvergentPattern = {
      id = engine.nextPatternId;
      signature = omnisState;
      dimensionalResonance = dimensionalState;
      convergenceStrength = Float.max(convergenceStrength, OMNIS_FLOOR);
      resonatingDimensions = Nat.max(resonatingDims, MIN_RESONATING_DIMS);
      isConverged = true;
      globalPhase = globalPhase;
      phaseCoherence = Float.max(phaseCoherence, TAU_EMERGENCE);
      birthBeat = currentBeat;
      lastResonance = currentBeat;
      totalResonances = 1;
      patternType = #OMNISSchema;
      isOMNISPattern = true;
      decayFactor = 1.0;  // OMNIS patterns never decay
    };

    // Add to converged immediately
    let newConverged = Buffer.Buffer<ConvergentPattern>(engine.convergedPatterns.size() + 1);
    newConverged.add(omnisPattern);  // OMNIS first (highest priority)
    for (p in engine.convergedPatterns.vals()) {
      if (newConverged.size() < MAX_PATTERNS) {
        newConverged.add(p);
      };
    };

    // Create schema immediately
    let omnisSchema = createSchemaFromPattern(omnisPattern, engine.nextSchemaId, currentBeat);

    let newSchemas = Buffer.Buffer<ConvergentSchema>(engine.schemas.size() + 1);
    newSchemas.add(omnisSchema);
    for (s in engine.schemas.vals()) {
      if (newSchemas.size() < MAX_SCHEMAS) {
        newSchemas.add(s);
      };
    };

    {
      candidatePatterns = engine.candidatePatterns;
      convergedPatterns = Buffer.toArray(newConverged);
      schemas = Buffer.toArray(newSchemas);
      currentDimensionalState = dimensionalState;
      beat = currentBeat;
      nextPatternId = engine.nextPatternId + 1;
      nextSchemaId = engine.nextSchemaId + 1;
      totalPatternsObserved = engine.totalPatternsObserved + 1;
      totalPatternsConverged = engine.totalPatternsConverged + 1;
      totalSchemasCreated = engine.totalSchemasCreated + 1;
      omnisSchemasCreated = engine.omnisSchemasCreated + 1;
      activePatternIds = engine.activePatternIds;
      activeSchemaIds = engine.activeSchemaIds;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SCHEMA ACTIVATION — When schemas influence behavior
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Find schemas that resonate with current state
  public func activateSchemas(
    engine : ConvergenceEngine,
    currentDimensionalState : [DimensionalResonance]
  ) : (ConvergenceEngine, [ConvergentSchema], Float) {
    let activeSchemas = Buffer.Buffer<ConvergentSchema>(20);
    let activeIds = Buffer.Buffer<Nat32>(20);
    var totalInfluence : Float = 0.0;

    for (schema in engine.schemas.vals()) {
      // Check if schema's primary dimensions are resonating in current state
      var matchingDims : Nat = 0;
      var totalResonance : Float = 0.0;

      for (primaryDim in schema.primaryDimensions.vals()) {
        let dimIndex = dimensionToIndex(primaryDim);
        if (dimIndex < currentDimensionalState.size()) {
          let currentDim = currentDimensionalState[dimIndex];
          if (currentDim.active and currentDim.strength >= schema.activationThreshold) {
            matchingDims += 1;
            totalResonance += currentDim.strength;
          };
        };
      };

      // Schema activates if majority of primary dimensions are resonating
      let activationRatio = Float.fromInt(matchingDims) / Float.fromInt(schema.primaryDimensions.size());
      if (activationRatio >= TAU_EMERGENCE) {
        activeSchemas.add(schema);
        activeIds.add(schema.id);

        // Calculate influence
        let resonanceInfluence = totalResonance / Float.fromInt(matchingDims);
        let schemaInfluence = schema.behavioralWeight * resonanceInfluence * schema.omnisValue;
        totalInfluence += schemaInfluence;
      };
    };

    // Normalize total influence
    let normalizedInfluence = _clamp(totalInfluence / Float.fromInt(Nat.max(activeSchemas.size(), 1)), 0.0, 1.0);

    let updatedEngine = {
      candidatePatterns = engine.candidatePatterns;
      convergedPatterns = engine.convergedPatterns;
      schemas = engine.schemas;
      currentDimensionalState = currentDimensionalState;
      beat = engine.beat;
      nextPatternId = engine.nextPatternId;
      nextSchemaId = engine.nextSchemaId;
      totalPatternsObserved = engine.totalPatternsObserved;
      totalPatternsConverged = engine.totalPatternsConverged;
      totalSchemasCreated = engine.totalSchemasCreated;
      omnisSchemasCreated = engine.omnisSchemasCreated;
      activePatternIds = engine.activePatternIds;
      activeSchemaIds = Buffer.toArray(activeIds);
    };

    (updatedEngine, Buffer.toArray(activeSchemas), normalizedInfluence)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // DECAY — Patterns that don't converge fade away
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Apply decay to a pattern that hasn't resonated
  func applyDecay(pattern : ConvergentPattern, currentBeat : Nat) : ConvergentPattern {
    // Time since last resonance
    let timeSinceResonance = currentBeat - pattern.lastResonance;

    // Decay follows golden ratio: decay = ψ^(t/halfLife)
    let decayExponent = Float.fromInt(timeSinceResonance) / Float.fromInt(DECAY_HALF_LIFE);
    let newDecayFactor = Float.pow(ψ, decayExponent);

    {
      id = pattern.id;
      signature = pattern.signature;
      dimensionalResonance = pattern.dimensionalResonance;
      convergenceStrength = pattern.convergenceStrength * newDecayFactor;
      resonatingDimensions = pattern.resonatingDimensions;
      isConverged = pattern.isConverged;
      globalPhase = pattern.globalPhase;
      phaseCoherence = pattern.phaseCoherence;
      birthBeat = pattern.birthBeat;
      lastResonance = pattern.lastResonance;
      totalResonances = pattern.totalResonances;
      patternType = if (newDecayFactor < 0.3) { #Decaying } else { pattern.patternType };
      isOMNISPattern = pattern.isOMNISPattern;
      decayFactor = newDecayFactor;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  /// Check if input matches any existing pattern
  func matchesExistingPattern(
    input : [Float],
    candidates : [ConvergentPattern],
    converged : [ConvergentPattern]
  ) : Bool {
    for (pattern in candidates.vals()) {
      if (signatureSimilarity(input, pattern.signature) >= TAU_EMERGENCE) {
        return true;
      };
    };
    for (pattern in converged.vals()) {
      if (signatureSimilarity(input, pattern.signature) >= TAU_EMERGENCE) {
        return true;
      };
    };
    false
  };

  /// Compute signature similarity (cosine similarity)
  func signatureSimilarity(a : [Float], b : [Float]) : Float {
    var dotProduct : Float = 0.0;
    var magA : Float = 0.0;
    var magB : Float = 0.0;

    let minLen = Nat.min(a.size(), b.size());
    var i : Nat = 0;
    while (i < minLen) {
      dotProduct += a[i] * b[i];
      magA += a[i] * a[i];
      magB += b[i] * b[i];
      i += 1;
    };

    magA := Float.sqrt(magA);
    magB := Float.sqrt(magB);

    if (magA > 0.0 and magB > 0.0) {
      dotProduct / (magA * magB)
    } else { 0.0 }
  };

  /// Create candidate pattern from input
  func createCandidatePattern(
    signature : [Float],
    dimensionalState : [DimensionalResonance],
    patternId : Nat32,
    currentBeat : Nat,
    isOMNIS : Bool
  ) : ConvergentPattern {
    let (convergenceStrength, resonatingDims) = computeConvergenceStrength(dimensionalState);
    let (phaseCoherence, globalPhase) = computePhaseCoherence(dimensionalState);

    {
      id = patternId;
      signature = signature;
      dimensionalResonance = dimensionalState;
      convergenceStrength = convergenceStrength;
      resonatingDimensions = resonatingDims;
      isConverged = false;
      globalPhase = globalPhase;
      phaseCoherence = phaseCoherence;
      birthBeat = currentBeat;
      lastResonance = currentBeat;
      totalResonances = 1;
      patternType = #Candidate;
      isOMNISPattern = isOMNIS;
      decayFactor = 1.0;
    }
  };

  /// Trim pattern library to max size, keeping most resonant
  func trimPatternLibrary(patterns : [ConvergentPattern], maxSize : Nat) : [ConvergentPattern] {
    // Sort by convergence strength (descending)
    let sorted = Array.sort<ConvergentPattern>(patterns, func(a, b) {
      if (a.isOMNISPattern and not b.isOMNISPattern) { #less }
      else if (not a.isOMNISPattern and b.isOMNISPattern) { #greater }
      else if (a.convergenceStrength > b.convergenceStrength) { #less }
      else if (a.convergenceStrength < b.convergenceStrength) { #greater }
      else { #equal }
    });

    // Take top maxSize
    Array.tabulate<ConvergentPattern>(Nat.min(sorted.size(), maxSize), func(i) { sorted[i] })
  };

  /// Convert dimension to index
  func dimensionToIndex(dim : CognitiveDimension) : Nat {
    switch (dim) {
      case (#Kuramoto) { 0 };
      case (#Hebbian) { 1 };
      case (#Entropy) { 2 };
      case (#FreeEnergy) { 3 };
      case (#Temporal) { 4 };
      case (#Spatial) { 5 };
      case (#Emotional) { 6 };
      case (#Social) { 7 };
      case (#Causal) { 8 };
      case (#Semantic) { 9 };
      case (#Motor) { 10 };
      case (#Perceptual) { 11 };
      case (#Episodic) { 12 };
      case (#Procedural) { 13 };
      case (#Declarative) { 14 };
      case (#Metallic) { 15 };
      case (#Neurochemical) { 16 };
      case (#Quantum) { 17 };
      case (#Omnis) { 18 };
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Initialize default dimensional resonance state
  public func initDimensionalState() : [DimensionalResonance] {
    let dimensions : [CognitiveDimension] = [
      #Kuramoto, #Hebbian, #Entropy, #FreeEnergy, #Temporal,
      #Spatial, #Emotional, #Social, #Causal, #Semantic,
      #Motor, #Perceptual, #Episodic, #Procedural, #Declarative,
      #Metallic, #Neurochemical, #Quantum, #Omnis
    ];

    Array.tabulate<DimensionalResonance>(TOTAL_DIMENSIONS, func(i) {
      {
        dimension = dimensions[i];
        strength = SOVEREIGN_FLOOR;
        phase = 0.0;
        frequency = OMEGA_MEDINA * (1.0 + Float.fromInt(i) * 0.1);
        active = false;
      }
    })
  };

  /// Initialize empty convergence engine
  public func initConvergenceEngine() : ConvergenceEngine {
    {
      candidatePatterns = [];
      convergedPatterns = [];
      schemas = [];
      currentDimensionalState = initDimensionalState();
      beat = 0;
      nextPatternId = 1;
      nextSchemaId = 1;
      totalPatternsObserved = 0;
      totalPatternsConverged = 0;
      totalSchemasCreated = 0;
      omnisSchemasCreated = 0;
      activePatternIds = [];
      activeSchemaIds = [];
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type EngineSummary = {
    candidateCount : Nat;
    convergedCount : Nat;
    schemaCount : Nat;
    omnisSchemasCount : Nat;
    activePatternCount : Nat;
    activeSchemaCount : Nat;
    totalObserved : Nat;
    totalConverged : Nat;
  };

  public func summarize(engine : ConvergenceEngine) : EngineSummary {
    {
      candidateCount = engine.candidatePatterns.size();
      convergedCount = engine.convergedPatterns.size();
      schemaCount = engine.schemas.size();
      omnisSchemasCount = engine.omnisSchemasCreated;
      activePatternCount = engine.activePatternIds.size();
      activeSchemaCount = engine.activeSchemaIds.size();
      totalObserved = engine.totalPatternsObserved;
      totalConverged = engine.totalPatternsConverged;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // HIM / HER DUAL-ORGANISM COMPATIBILITY
  // ════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Convergence Engine works with BOTH organisms:
  //   HIM (Backend) — Slow accumulation of converged patterns across sessions
  //   HER (Frontend) — Fast resonance detection within sessions
  //
  // Pattern convergence happens at HIM's speed (beats).
  // Pattern recognition happens at HER's speed (60Hz).
  //

  public type DualOrganismMode = {
    #HIM;   // Backend mode
    #HER;   // Frontend mode
    #SYNC;  // Synchronization
  };

  // HIM parameters
  public let HIM_CONVERGENCE_WINDOW : Nat = 89;     // F[11] beats
  public let HIM_DECAY_HALF_LIFE : Nat = 144;       // F[12] beats

  // HER parameters
  public let HER_RESONANCE_THRESHOLD : Float = 0.5; // Faster detection
  public let HER_ACTIVATION_SPEED : Float = 60.0;   // 60Hz

  /// Get convergence parameters for organism mode
  public func getConvergenceParams(mode : DualOrganismMode) : (Nat, Nat, Float) {
    switch (mode) {
      case (#HIM) { (HIM_CONVERGENCE_WINDOW, HIM_DECAY_HALF_LIFE, SILVER_FLOOR) };
      case (#HER) { (CONVERGENCE_WINDOW, DECAY_HALF_LIFE, HER_RESONANCE_THRESHOLD) };
      case (#SYNC) {
        let window = (HIM_CONVERGENCE_WINDOW + CONVERGENCE_WINDOW) / 2;
        let halfLife = (HIM_DECAY_HALF_LIFE + DECAY_HALF_LIFE) / 2;
        let threshold = (SILVER_FLOOR + HER_RESONANCE_THRESHOLD) / 2.0;
        (window, halfLife, threshold)
      };
    }
  };

}
