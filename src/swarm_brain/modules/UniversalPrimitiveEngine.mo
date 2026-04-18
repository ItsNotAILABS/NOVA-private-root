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

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║                                                                                                           ║
// ║  L-130 — UNIVERSAL PRIMITIVE ENGINE (DOC-PRIMITIVA-130)                                                  ║
// ║                                                                                                           ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE CORE INSIGHT OF L-130:
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                                                                                                             │
// │   Every tool, layer, color, signal, component, document, organism, substrate, and system                   │
// │   has a primitive form.                                                                                    │
// │                                                                                                             │
// │   No architecture is fully understood at its current surface expression.                                   │
// │                                                                                                             │
// │   To understand a thing, you must trace it backward to its primitive.                                      │
// │   To build a thing correctly, you must recompose it from its primitive.                                    │
// │   To evolve a thing without drift, you must preserve continuity between primitive and expression.          │
// │                                                                                                             │
// │   A primitive is not just the "smallest part."                                                             │
// │   It is the earliest irreducible active reality from which the higher form emerges.                        │
// │                                                                                                             │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// THE FOUR NESTED STATEMENTS:
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//   1. PRIMITIVE PRECEDES EXPRESSION
//      No expression is original at the surface. Every expression is downstream of a primitive.
//
//   2. PRIMITIVE GOVERNS RECOMPOSITION
//      A thing can only be rebuilt truthfully if its primitive has been recovered first.
//
//   3. PRIMITIVE DRIFT CAUSES ARCHITECTURAL FALSEHOOD
//      If a system forgets its primitive, it begins optimizing the wrong layer.
//
//   4. PRIMITIVE RECOVERY RESTORES SOVEREIGNTY
//      To recover the primitive is to regain command over the thing.
//
// ENGINE PHASES:
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//   Phase 1 — STRIP:    Remove wrappers, labels, and current packaging.
//   Phase 2 — DESCEND:  Walk backward through the stack until the primitive is found.
//   Phase 3 — VERIFY:   Test whether the primitive is actually primitive or only an earlier wrapper.
//   Phase 4 — RECOMPOSE: Rebuild the entity outward while preserving primitive continuity.
//
// ENGINE OUTPUT STATES:
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//   PRIMITIVE_CONFIRMED    — True primitive found and validated
//   PRIMITIVE_FRAGMENTED   — Primitive split into multiple parts
//   PRIMITIVE_HIDDEN       — Primitive concealed behind abstractions
//   PRIMITIVE_INVERTED     — Primitive present but inverted (anti-pattern active)
//   PRIMITIVE_HYBRIDIZED   — Primitive contaminated with foreign elements
//   PRIMITIVE_UNREACHED    — Could not trace to primitive (depth exceeded)
//   RECOMPOSED_TRUE        — Entity successfully rebuilt from primitive
//   RECOMPOSED_FALSE       — Recomposition failed or drifted
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Char "mo:base/Char";

module UniversalPrimitiveEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS — THE PRIMITIVE MATHEMATICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let S0 : Float = 1.0;                              // Love constant floor — the ultimate primitive
  public let PHI : Float = 1.6180339887498948482;           // Golden ratio — THE TRANSFER FUNCTION
  public let PHI_INV : Float = 0.6180339887498948482;       // 1/φ = φ - 1
  public let PI : Float = 3.1415926535897932385;            // Circle constant
  public let TAU : Float = 6.2831853071795864769;           // Full rotation
  public let EULER : Float = 2.7182818284590452354;         // Natural growth base
  
  // Primitive detection thresholds
  public let PRIMITIVE_CONFIDENCE_THRESHOLD : Float = 0.85;
  public let CONTAMINATION_THRESHOLD : Float = 0.15;
  public let FRAGMENTATION_THRESHOLD : Float = 0.3;
  public let INVERSION_DETECTION_THRESHOLD : Float = 0.7;
  public let MAX_DESCENT_DEPTH : Nat = 12;                  // 12 = PHI icosahedron vertices
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS — THE ONTOLOGY OF PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Domain categories where primitives exist
  public type PrimitiveDomain = {
    #Physics;         // Fundamental physical laws
    #Biology;         // Biological building blocks
    #Cognition;       // Cognitive primitives
    #Language;        // Linguistic atoms
    #Software;        // Code primitives
    #Law;             // Legal primitives
    #Economy;         // Economic primitives
    #Governance;      // Governance primitives
    #Symbolism;       // Symbolic primitives
    #Color;           // Color primitives (RGB/HSL roots)
    #Civilization;    // Civilization primitives
    #Memory;          // Memory primitives
    #Interface;       // Interface primitives
    #Document;        // Document primitives
    #Organism;        // Organism primitives
    #Company;         // Company primitives
    #Token;           // Token primitives
    #Workflow;        // Workflow primitives
    #Market;          // Market primitives
    #Myth;            // Myth primitives
    #Custom;          // User-defined domain
  };
  
  /// Entity types that can be traced to primitives
  public type EntityType = {
    #Tool;
    #Layer;
    #Color;
    #Signal;
    #Component;
    #Document;
    #Organism;
    #Substrate;
    #System;
    #Company;
    #Token;
    #Law;
    #Canister;
    #Civilization;
    #Market;
    #BrainRegion;
    #Myth;
    #Workflow;
    #Answer;
    #Custom : Text;
  };
  
  /// Primitive validation states
  public type PrimitiveState = {
    #PRIMITIVE_CONFIRMED;
    #PRIMITIVE_FRAGMENTED;
    #PRIMITIVE_HIDDEN;
    #PRIMITIVE_INVERTED;
    #PRIMITIVE_HYBRIDIZED;
    #PRIMITIVE_UNREACHED;
    #RECOMPOSED_TRUE;
    #RECOMPOSED_FALSE;
  };
  
  /// Layer in the architectural stack
  public type ArchitecturalLayer = {
    layerIndex : Nat;
    layerName : Text;
    layerType : Text;
    dependsOn : [Nat];         // Indices of lower layers
    isPrimitive : Bool;
    abstractionLevel : Float;  // 0.0 = primitive, 1.0 = pure abstraction
    contentHash : Nat32;
  };
  
  /// Primitive form identified by the engine
  public type PrimitiveForm = {
    primitiveId : Nat32;
    domain : PrimitiveDomain;
    name : Text;
    description : Text;
    mathematicalForm : Text;    // Mathematical representation if applicable
    isIrreducible : Bool;
    confidenceScore : Float;
    layerDepth : Nat;
    sourceHash : Nat32;
  };
  
  /// Drift analysis between primitive and current expression
  public type DriftMap = {
    totalDrift : Float;
    layerDrifts : [(Nat, Float)];   // (layer index, drift amount)
    driftDirection : Text;           // "expansion", "contraction", "inversion", "fragmentation"
    driftVelocity : Float;           // Rate of drift per beat
    recoverable : Bool;
  };
  
  /// Recomposition blueprint for rebuilding from primitive
  public type RecompositionBlueprint = {
    primitiveForm : PrimitiveForm;
    layers : [ArchitecturalLayer];
    transformSequence : [Text];      // Ordered transformation steps
    preservationConstraints : [Text];
    expectedCoherence : Float;
    estimatedSteps : Nat;
  };
  
  /// Full engine input
  public type PrimitiveEngineInput = {
    entityId : Nat32;
    entityType : EntityType;
    currentExpression : Text;
    knownLayers : [Text];
    doctrineContext : Text;
    historyContext : Text;
    crossDomainRefs : [Text];
  };
  
  /// Full engine output
  public type PrimitiveEngineOutput = {
    inputEntityId : Nat32;
    state : PrimitiveState;
    primitiveForm : PrimitiveForm;
    confidenceScore : Float;
    driftMap : DriftMap;
    recompositionBlueprint : RecompositionBlueprint;
    relatedLaws : [Text];
    organismRegistryLink : Text;
    documentRegistryLink : Text;
    implementationTargets : [Text];
    beatAtAnalysis : Nat;
    analysisHash : Nat32;
  };
  
  /// Engine state for tracking analysis
  public type PrimitiveEngineState = {
    var currentBeat : Nat;
    var totalAnalyses : Nat;
    var confirmedPrimitives : Nat;
    var fragmentedPrimitives : Nat;
    var hiddenPrimitives : Nat;
    var invertedPrimitives : Nat;
    var hybridizedPrimitives : Nat;
    var unreachedPrimitives : Nat;
    var successfulRecompositions : Nat;
    var failedRecompositions : Nat;
    var lastAnalysisHash : Nat32;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES — THE IRREDUCIBLE MATHEMATICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var g = x / 2.0; var i = 0;
    while (i < 20) { g := (g + x / g) / 2.0; i += 1 };
    g
  };
  
  public func exp(x : Float) : Float {
    let c = if (x < -30.0) -30.0 else if (x > 30.0) 30.0 else x;
    var s = 1.0; var t = 1.0; var i = 1;
    while (i < 25) { t *= c / Float.fromInt(i); s += t; i += 1 };
    s
  };
  
  public func ln(x : Float) : Float {
    if (x <= 0.0) return -100.0;
    let z = (x - 1.0) / (x + 1.0);
    let z2 = z * z;
    var s = z; var t = z; var i = 1;
    while (i < 40) { t *= z2; s += t / Float.fromInt(2*i + 1); i += 1 };
    2.0 * s
  };
  
  public func sin(x : Float) : Float {
    var n = x;
    while (n > PI) { n -= TAU };
    while (n < -PI) { n += TAU };
    let x2 = n * n;
    n * (1.0 - x2/6.0 * (1.0 - x2/20.0 * (1.0 - x2/42.0 * (1.0 - x2/72.0))))
  };
  
  public func cos(x : Float) : Float {
    sin(x + PI / 2.0)
  };
  
  public func tanh(x : Float) : Float {
    let e2x = exp(2.0 * x);
    (e2x - 1.0) / (e2x + 1.0)
  };
  
  public func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HASH FUNCTIONS — FOR PRIMITIVE IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func textToBytes(text : Text) : [Nat8] {
    let chars = Text.toIter(text);
    let buf = Buffer.Buffer<Nat8>(Text.size(text));
    for (c in chars) {
      buf.add(Nat8.fromNat(Nat32.toNat(Char.toNat32(c)) % 256));
    };
    Buffer.toArray(buf)
  };
  
  public func fnv1a(input : [Nat8]) : Nat32 {
    var hash : Nat32 = 2166136261;
    for (byte in input.vals()) {
      hash := hash ^ Nat32.fromNat(Nat8.toNat(byte));
      hash := hash *% 16777619;
    };
    hash
  };
  
  public func hashText(text : Text) : Nat32 {
    var hash : Nat32 = 2166136261;
    for (c in text.chars()) {
      let byte = Char.toNat32(c) % 256;
      hash := hash ^ byte;
      hash := hash *% 16777619;
    };
    hash
  };
  
  public func hashCombine(h1 : Nat32, h2 : Nat32) : Nat32 {
    h1 ^ (h2 *% 16777619 +% 2166136261)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initEngineState() : PrimitiveEngineState {
    {
      var currentBeat = 0;
      var totalAnalyses = 0;
      var confirmedPrimitives = 0;
      var fragmentedPrimitives = 0;
      var hiddenPrimitives = 0;
      var invertedPrimitives = 0;
      var hybridizedPrimitives = 0;
      var unreachedPrimitives = 0;
      var successfulRecompositions = 0;
      var failedRecompositions = 0;
      var lastAnalysisHash = 0 : Nat32;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 1 — STRIP: Remove wrappers, labels, and current packaging
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Strip surface expressions to reveal underlying structure
  public func stripExpression(expression : Text, entityType : EntityType) : [ArchitecturalLayer] {
    let buf = Buffer.Buffer<ArchitecturalLayer>(12);
    
    // Create surface layer (current expression)
    buf.add({
      layerIndex = 0;
      layerName = "Surface Expression";
      layerType = entityTypeToText(entityType);
      dependsOn = [1];
      isPrimitive = false;
      abstractionLevel = 1.0;
      contentHash = hashText(expression);
    });
    
    // Create interface layer
    buf.add({
      layerIndex = 1;
      layerName = "Interface Layer";
      layerType = "interface";
      dependsOn = [2];
      isPrimitive = false;
      abstractionLevel = 0.85;
      contentHash = hashText("interface:" # expression);
    });
    
    // Create signal layer
    buf.add({
      layerIndex = 2;
      layerName = "Signal Layer";
      layerType = "signal";
      dependsOn = [3];
      isPrimitive = false;
      abstractionLevel = 0.7;
      contentHash = hashText("signal:" # expression);
    });
    
    // Create structure layer
    buf.add({
      layerIndex = 3;
      layerName = "Structure Layer";
      layerType = "structure";
      dependsOn = [4];
      isPrimitive = false;
      abstractionLevel = 0.5;
      contentHash = hashText("structure:" # expression);
    });
    
    // Create substrate layer
    buf.add({
      layerIndex = 4;
      layerName = "Substrate Layer";
      layerType = "substrate";
      dependsOn = [5];
      isPrimitive = false;
      abstractionLevel = 0.3;
      contentHash = hashText("substrate:" # expression);
    });
    
    // Create primitive layer (to be validated)
    buf.add({
      layerIndex = 5;
      layerName = "Primitive Layer";
      layerType = "primitive";
      dependsOn = [];
      isPrimitive = true;
      abstractionLevel = 0.0;
      contentHash = hashText("primitive:" # expression);
    });
    
    Buffer.toArray(buf)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 2 — DESCEND: Walk backward through the stack to find primitive
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Descend through architectural layers to find the primitive
  public func descendTowardsPrimitive(
    layers : [ArchitecturalLayer],
    domain : PrimitiveDomain
  ) : (Nat, Float) {
    // Start at surface (index 0) and descend
    var currentDepth : Nat = 0;
    var confidence : Float = 0.0;
    
    for (layer in layers.vals()) {
      // Calculate confidence based on abstraction level
      // Lower abstraction = closer to primitive = higher confidence
      let layerConfidence = 1.0 - layer.abstractionLevel;
      
      if (layer.isPrimitive) {
        // Found claimed primitive
        currentDepth := layer.layerIndex;
        confidence := layerConfidence * getPrimitiveDomainWeight(domain);
        return (currentDepth, confidence);
      };
      
      currentDepth := layer.layerIndex;
    };
    
    // Reached maximum depth without confirmed primitive
    (currentDepth, confidence)
  };
  
  /// Get domain-specific weight for primitive confidence
  public func getPrimitiveDomainWeight(domain : PrimitiveDomain) : Float {
    switch (domain) {
      case (#Physics) { 1.0 };      // Physical primitives are most certain
      case (#Biology) { 0.95 };
      case (#Cognition) { 0.9 };
      case (#Language) { 0.85 };
      case (#Software) { 0.9 };
      case (#Law) { 0.8 };
      case (#Economy) { 0.75 };
      case (#Governance) { 0.7 };
      case (#Symbolism) { 0.8 };
      case (#Color) { 0.95 };
      case (#Civilization) { 0.65 };
      case (#Memory) { 0.85 };
      case (#Interface) { 0.9 };
      case (#Document) { 0.85 };
      case (#Organism) { 0.9 };
      case (#Company) { 0.7 };
      case (#Token) { 0.8 };
      case (#Workflow) { 0.75 };
      case (#Market) { 0.7 };
      case (#Myth) { 0.6 };
      case (#Custom) { 0.5 };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 3 — VERIFY: Test whether the primitive is actually primitive
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Verify if the identified primitive is true or a wrapper
  public func verifyPrimitive(
    layers : [ArchitecturalLayer],
    primitiveDepth : Nat,
    confidence : Float
  ) : PrimitiveState {
    
    // Check confidence threshold
    if (confidence >= PRIMITIVE_CONFIDENCE_THRESHOLD) {
      return #PRIMITIVE_CONFIRMED;
    };
    
    // Check for fragmentation (primitive split into parts)
    if (checkFragmentation(layers, primitiveDepth)) {
      return #PRIMITIVE_FRAGMENTED;
    };
    
    // Check for hidden primitive (concealed behind abstractions)
    if (checkHiddenPrimitive(layers, primitiveDepth, confidence)) {
      return #PRIMITIVE_HIDDEN;
    };
    
    // Check for inversion (anti-pattern active)
    if (checkInversion(layers, primitiveDepth)) {
      return #PRIMITIVE_INVERTED;
    };
    
    // Check for hybridization (contaminated with foreign elements)
    if (checkHybridization(confidence)) {
      return #PRIMITIVE_HYBRIDIZED;
    };
    
    // Could not reach true primitive
    if (primitiveDepth >= MAX_DESCENT_DEPTH) {
      return #PRIMITIVE_UNREACHED;
    };
    
    // Default to confirmed if none of the above
    #PRIMITIVE_CONFIRMED
  };
  
  /// Check if primitive is fragmented across multiple parts
  public func checkFragmentation(layers : [ArchitecturalLayer], depth : Nat) : Bool {
    // Count how many layers at similar depth claim primitive status
    var primitiveCandidates : Nat = 0;
    for (layer in layers.vals()) {
      if (layer.isPrimitive or layer.abstractionLevel < 0.1) {
        primitiveCandidates += 1;
      };
    };
    primitiveCandidates > 1
  };
  
  /// Check if primitive is hidden behind abstractions
  public func checkHiddenPrimitive(layers : [ArchitecturalLayer], depth : Nat, confidence : Float) : Bool {
    // If confidence is moderate but depth is high, primitive may be hidden
    confidence < PRIMITIVE_CONFIDENCE_THRESHOLD and 
    confidence > CONTAMINATION_THRESHOLD and 
    depth > 3
  };
  
  /// Check if primitive is inverted (anti-pattern)
  public func checkInversion(layers : [ArchitecturalLayer], depth : Nat) : Bool {
    // Check if abstraction levels are inverted (higher at bottom)
    if (layers.size() < 2) return false;
    
    var inversions : Nat = 0;
    var i : Nat = 1;
    while (i < layers.size()) {
      if (layers[i].abstractionLevel > layers[i-1].abstractionLevel) {
        inversions += 1;
      };
      i += 1;
    };
    
    Float.fromInt(inversions) / Float.fromInt(layers.size()) > INVERSION_DETECTION_THRESHOLD
  };
  
  /// Check if primitive is hybridized (contaminated)
  public func checkHybridization(confidence : Float) : Bool {
    confidence < CONTAMINATION_THRESHOLD + 0.3 and confidence > CONTAMINATION_THRESHOLD
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 4 — RECOMPOSE: Rebuild the entity outward from primitive
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Create recomposition blueprint from primitive
  public func createRecompositionBlueprint(
    primitiveForm : PrimitiveForm,
    layers : [ArchitecturalLayer],
    state : PrimitiveState
  ) : RecompositionBlueprint {
    
    let transformSequence = Buffer.Buffer<Text>(6);
    let constraints = Buffer.Buffer<Text>(4);
    
    // Build transformation sequence: primitive → substrate → structure → signal → interface → expression
    transformSequence.add("1. ANCHOR: Lock primitive form as foundation");
    transformSequence.add("2. SUBSTRATE: Grow substrate layer preserving primitive continuity");
    transformSequence.add("3. STRUCTURE: Build structure from substrate with PHI proportions");
    transformSequence.add("4. SIGNAL: Wire signal pathways through structure");
    transformSequence.add("5. INTERFACE: Project interface from signal layer");
    transformSequence.add("6. EXPRESSION: Render final expression while maintaining primitive link");
    
    // Add preservation constraints
    constraints.add("CONSTRAINT_1: Primitive must remain accessible at all layers");
    constraints.add("CONSTRAINT_2: No transformation may break continuity chain");
    constraints.add("CONSTRAINT_3: Each layer must carry primitive hash signature");
    constraints.add("CONSTRAINT_4: Drift must be measured at each layer transition");
    
    // Calculate expected coherence based on state
    let expectedCoherence = switch (state) {
      case (#PRIMITIVE_CONFIRMED) { 0.95 };
      case (#PRIMITIVE_FRAGMENTED) { 0.6 };
      case (#PRIMITIVE_HIDDEN) { 0.7 };
      case (#PRIMITIVE_INVERTED) { 0.4 };
      case (#PRIMITIVE_HYBRIDIZED) { 0.5 };
      case (#PRIMITIVE_UNREACHED) { 0.2 };
      case (#RECOMPOSED_TRUE) { 0.9 };
      case (#RECOMPOSED_FALSE) { 0.1 };
    };
    
    {
      primitiveForm = primitiveForm;
      layers = layers;
      transformSequence = Buffer.toArray(transformSequence);
      preservationConstraints = Buffer.toArray(constraints);
      expectedCoherence = expectedCoherence;
      estimatedSteps = layers.size();
    }
  };
  
  /// Calculate drift between primitive and current expression
  public func calculateDriftMap(
    layers : [ArchitecturalLayer],
    primitiveForm : PrimitiveForm
  ) : DriftMap {
    let layerDrifts = Buffer.Buffer<(Nat, Float)>(layers.size());
    var totalDrift : Float = 0.0;
    
    // Calculate drift at each layer from primitive
    for (layer in layers.vals()) {
      // Drift increases with abstraction level
      let layerDrift = layer.abstractionLevel * (1.0 - primitiveForm.confidenceScore);
      layerDrifts.add((layer.layerIndex, layerDrift));
      totalDrift += layerDrift;
    };
    
    // Normalize total drift
    if (layers.size() > 0) {
      totalDrift := totalDrift / Float.fromInt(layers.size());
    };
    
    // Determine drift direction
    let driftDirection = if (totalDrift > 0.7) {
      "fragmentation"
    } else if (totalDrift > 0.5) {
      "inversion"
    } else if (totalDrift > 0.3) {
      "expansion"
    } else {
      "contraction"
    };
    
    {
      totalDrift = totalDrift;
      layerDrifts = Buffer.toArray(layerDrifts);
      driftDirection = driftDirection;
      driftVelocity = totalDrift * PHI_INV;  // Drift velocity scaled by golden ratio inverse
      recoverable = totalDrift < 0.7;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN ENGINE FUNCTION — FULL PRIMITIVE ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Run complete primitive analysis on an entity
  public func analyzePrimitive(
    input : PrimitiveEngineInput,
    state : PrimitiveEngineState
  ) : PrimitiveEngineOutput {
    
    // Increment analysis counter
    state.totalAnalyses += 1;
    
    // Determine domain from entity type
    let domain = entityTypeToDomain(input.entityType);
    
    // PHASE 1: Strip expression to reveal layers
    let layers = stripExpression(input.currentExpression, input.entityType);
    
    // PHASE 2: Descend towards primitive
    let (primitiveDepth, confidence) = descendTowardsPrimitive(layers, domain);
    
    // PHASE 3: Verify primitive
    let primitiveState = verifyPrimitive(layers, primitiveDepth, confidence);
    
    // Update state counters based on result
    updateStateCounters(state, primitiveState);
    
    // Create primitive form
    let primitiveForm : PrimitiveForm = {
      primitiveId = hashCombine(input.entityId, hashText(input.currentExpression));
      domain = domain;
      name = "Primitive of " # entityTypeToText(input.entityType);
      description = "Irreducible form of " # input.currentExpression;
      mathematicalForm = generateMathematicalForm(domain, confidence);
      isIrreducible = confidence >= PRIMITIVE_CONFIDENCE_THRESHOLD;
      confidenceScore = confidence;
      layerDepth = primitiveDepth;
      sourceHash = hashText(input.currentExpression);
    };
    
    // Calculate drift map
    let driftMap = calculateDriftMap(layers, primitiveForm);
    
    // PHASE 4: Create recomposition blueprint
    let blueprint = createRecompositionBlueprint(primitiveForm, layers, primitiveState);
    
    // Generate related laws
    let relatedLaws = generateRelatedLaws(domain, primitiveState);
    
    // Create analysis hash
    let analysisHash = hashCombine(
      hashCombine(input.entityId, Nat32.fromNat(primitiveDepth)),
      Nat32.fromNat(Nat32.toNat(Nat32.fromIntWrap(Float.toInt(confidence * 1000.0))))
    );
    state.lastAnalysisHash := analysisHash;
    
    {
      inputEntityId = input.entityId;
      state = primitiveState;
      primitiveForm = primitiveForm;
      confidenceScore = confidence;
      driftMap = driftMap;
      recompositionBlueprint = blueprint;
      relatedLaws = relatedLaws;
      organismRegistryLink = "organism://registry/primitive/" # Nat32.toText(input.entityId);
      documentRegistryLink = "document://registry/DOC-PRIMITIVA-130/" # Nat32.toText(input.entityId);
      implementationTargets = generateImplementationTargets(input.entityType);
      beatAtAnalysis = state.currentBeat;
      analysisHash = analysisHash;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func entityTypeToText(entityType : EntityType) : Text {
    switch (entityType) {
      case (#Tool) { "Tool" };
      case (#Layer) { "Layer" };
      case (#Color) { "Color" };
      case (#Signal) { "Signal" };
      case (#Component) { "Component" };
      case (#Document) { "Document" };
      case (#Organism) { "Organism" };
      case (#Substrate) { "Substrate" };
      case (#System) { "System" };
      case (#Company) { "Company" };
      case (#Token) { "Token" };
      case (#Law) { "Law" };
      case (#Canister) { "Canister" };
      case (#Civilization) { "Civilization" };
      case (#Market) { "Market" };
      case (#BrainRegion) { "BrainRegion" };
      case (#Myth) { "Myth" };
      case (#Workflow) { "Workflow" };
      case (#Answer) { "Answer" };
      case (#Custom(t)) { "Custom:" # t };
    }
  };
  
  public func entityTypeToDomain(entityType : EntityType) : PrimitiveDomain {
    switch (entityType) {
      case (#Tool) { #Software };
      case (#Layer) { #Software };
      case (#Color) { #Color };
      case (#Signal) { #Cognition };
      case (#Component) { #Software };
      case (#Document) { #Document };
      case (#Organism) { #Organism };
      case (#Substrate) { #Biology };
      case (#System) { #Software };
      case (#Company) { #Company };
      case (#Token) { #Token };
      case (#Law) { #Law };
      case (#Canister) { #Software };
      case (#Civilization) { #Civilization };
      case (#Market) { #Market };
      case (#BrainRegion) { #Cognition };
      case (#Myth) { #Myth };
      case (#Workflow) { #Workflow };
      case (#Answer) { #Cognition };
      case (#Custom(_)) { #Custom };
    }
  };
  
  public func updateStateCounters(state : PrimitiveEngineState, primitiveState : PrimitiveState) {
    switch (primitiveState) {
      case (#PRIMITIVE_CONFIRMED) { state.confirmedPrimitives += 1 };
      case (#PRIMITIVE_FRAGMENTED) { state.fragmentedPrimitives += 1 };
      case (#PRIMITIVE_HIDDEN) { state.hiddenPrimitives += 1 };
      case (#PRIMITIVE_INVERTED) { state.invertedPrimitives += 1 };
      case (#PRIMITIVE_HYBRIDIZED) { state.hybridizedPrimitives += 1 };
      case (#PRIMITIVE_UNREACHED) { state.unreachedPrimitives += 1 };
      case (#RECOMPOSED_TRUE) { state.successfulRecompositions += 1 };
      case (#RECOMPOSED_FALSE) { state.failedRecompositions += 1 };
    };
  };
  
  public func generateMathematicalForm(domain : PrimitiveDomain, confidence : Float) : Text {
    let base = switch (domain) {
      case (#Physics) { "P_0 = lim_{n→∞} (S_n / φ^n)" };
      case (#Biology) { "B_0 = ∫ψ(x)·e^{-λt} dx" };
      case (#Cognition) { "C_0 = Σ_i w_i·σ(θ_i - θ_ref)" };
      case (#Language) { "L_0 = {a ∈ Σ* | G(a) → true}" };
      case (#Software) { "S_0 = f: Input → Output | ∀x,f(x)=f(f⁻¹(f(x)))" };
      case (#Law) { "Λ_0 = {R | ∀t, R(t) → R(t+Δt)}" };
      case (#Economy) { "E_0 = ∂V/∂t + rV = max_u{f(u,x)}" };
      case (#Governance) { "G_0 = argmax_{d∈D} Σ_i u_i(d)" };
      case (#Symbolism) { "Σ_0 = {s | s ↔ meaning(s)}" };
      case (#Color) { "χ_0 = (λ, I, θ) | λ ∈ [380,700]nm" };
      case (#Civilization) { "Ω_0 = ∫∫∫ ρ(r)·Φ(r) d³r" };
      case (#Memory) { "M_0 = H(X|Y) - H(X|Y,Z)" };
      case (#Interface) { "I_0 = ∂(User)/∂(System)" };
      case (#Document) { "D_0 = {content, structure, meaning}" };
      case (#Organism) { "O_0 = Ψ_yin ⊕ Ψ_yang → Ψ_chi" };
      case (#Company) { "K_0 = revenue × sovereignty × continuity" };
      case (#Token) { "T_0 = {claim, pressure, memory, gate}" };
      case (#Workflow) { "W_0 = G(V,E) | ∀v∈V, in(v)→out(v)" };
      case (#Market) { "M_0 = S(p)·D(p) = equilibrium" };
      case (#Myth) { "μ_0 = archetype × narrative × truth" };
      case (#Custom) { "X_0 = f(primitive_axioms)" };
    };
    base # " | confidence = " # Float.toText(confidence)
  };
  
  public func generateRelatedLaws(domain : PrimitiveDomain, state : PrimitiveState) : [Text] {
    let laws = Buffer.Buffer<Text>(8);
    
    // Core related laws
    laws.add("L-130: Universal Primitive Law");
    laws.add("L-001: Law of Sovereignty");
    laws.add("L-002: Law of Continuity");
    
    // Domain-specific laws
    switch (domain) {
      case (#Cognition) { 
        laws.add("L-040: Kuramoto Synchrony Law");
        laws.add("L-041: Hebbian Plasticity Law");
      };
      case (#Economy or #Token or #Market) {
        laws.add("L-050: Compounding Law");
        laws.add("L-051: Creator Reserve Law");
      };
      case (#Software) {
        laws.add("L-060: Canister Sovereignty Law");
        laws.add("L-061: Module Coherence Law");
      };
      case (#Organism) {
        laws.add("L-070: Third Synthesizer Law");
        laws.add("L-071: Transform-and-Retain Law");
      };
      case _ {
        laws.add("L-100: Domain Primitive Law");
      };
    };
    
    // State-specific laws
    switch (state) {
      case (#PRIMITIVE_INVERTED) {
        laws.add("L-200: Anti-Inversion Protocol");
      };
      case (#PRIMITIVE_FRAGMENTED) {
        laws.add("L-201: Primitive Unification Law");
      };
      case (#PRIMITIVE_HIDDEN) {
        laws.add("L-202: Primitive Revelation Protocol");
      };
      case _ {};
    };
    
    Buffer.toArray(laws)
  };
  
  public func generateImplementationTargets(entityType : EntityType) : [Text] {
    let targets = Buffer.Buffer<Text>(6);
    
    targets.add("target://law_registry");
    targets.add("target://organism_registry");
    targets.add("target://document_registry");
    
    switch (entityType) {
      case (#Software or #Canister) {
        targets.add("target://code_audit");
        targets.add("target://architecture_registry");
      };
      case (#Company) {
        targets.add("target://business_registry");
        targets.add("target://governance_registry");
      };
      case (#Token) {
        targets.add("target://token_registry");
        targets.add("target://economics_registry");
      };
      case (#Document) {
        targets.add("target://document_registry");
        targets.add("target://symbol_registry");
      };
      case _ {
        targets.add("target://general_registry");
      };
    };
    
    Buffer.toArray(targets)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMITIVE ONTOLOGY — DOMAIN-SPECIFIC PRIMITIVE DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Company primitive types
  public type CompanyPrimitive = {
    #RevenueExtraction;
    #Protection;
    #Transformation;
    #Coordination;
    #Creation;
    #Sovereignty;
    #Infrastructure;
    #SignalRouting;
  };
  
  /// Token primitive types
  public type TokenPrimitive = {
    #Receipt;
    #Pressure;
    #Memory;
    #Governance;
    #Claim;
    #ExchangeMedium;
    #AccessGate;
    #RewardTrace;
    #SurvivalReserve;
  };
  
  /// Document primitive types
  public type DocumentPrimitive = {
    #Registry;
    #MemoryCrystal;
    #LawAnchor;
    #TransferMechanism;
    #FormationShell;
    #WorldModelSurface;
    #SymbolicCompressionChamber;
    #LivingOrganism;
  };
  
  /// Identify company primitive
  public func identifyCompanyPrimitive(expression : Text) : CompanyPrimitive {
    // Hash-based primitive detection
    let h = hashText(expression);
    let idx = Nat32.toNat(h % 8);
    switch (idx) {
      case 0 { #RevenueExtraction };
      case 1 { #Protection };
      case 2 { #Transformation };
      case 3 { #Coordination };
      case 4 { #Creation };
      case 5 { #Sovereignty };
      case 6 { #Infrastructure };
      case _ { #SignalRouting };
    }
  };
  
  /// Identify token primitive
  public func identifyTokenPrimitive(expression : Text) : TokenPrimitive {
    let h = hashText(expression);
    let idx = Nat32.toNat(h % 9);
    switch (idx) {
      case 0 { #Receipt };
      case 1 { #Pressure };
      case 2 { #Memory };
      case 3 { #Governance };
      case 4 { #Claim };
      case 5 { #ExchangeMedium };
      case 6 { #AccessGate };
      case 7 { #RewardTrace };
      case _ { #SurvivalReserve };
    }
  };
  
  /// Identify document primitive
  public func identifyDocumentPrimitive(expression : Text) : DocumentPrimitive {
    let h = hashText(expression);
    let idx = Nat32.toNat(h % 8);
    switch (idx) {
      case 0 { #Registry };
      case 1 { #MemoryCrystal };
      case 2 { #LawAnchor };
      case 3 { #TransferMechanism };
      case 4 { #FormationShell };
      case 5 { #WorldModelSurface };
      case 6 { #SymbolicCompressionChamber };
      case _ { #LivingOrganism };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TICK FUNCTION — ORGANISM INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Tick the primitive engine as part of organism heartbeat
  public func tickPrimitiveEngine(state : PrimitiveEngineState) : () {
    state.currentBeat += 1;
  };
  
  /// Get engine statistics
  public func getEngineStats(state : PrimitiveEngineState) : {
    currentBeat : Nat;
    totalAnalyses : Nat;
    confirmedPrimitives : Nat;
    fragmentedPrimitives : Nat;
    hiddenPrimitives : Nat;
    invertedPrimitives : Nat;
    hybridizedPrimitives : Nat;
    unreachedPrimitives : Nat;
    successfulRecompositions : Nat;
    failedRecompositions : Nat;
    confirmationRate : Float;
  } {
    let total = Float.fromInt(state.totalAnalyses);
    let confirmed = Float.fromInt(state.confirmedPrimitives);
    let rate = if (total > 0.0) confirmed / total else 0.0;
    
    {
      currentBeat = state.currentBeat;
      totalAnalyses = state.totalAnalyses;
      confirmedPrimitives = state.confirmedPrimitives;
      fragmentedPrimitives = state.fragmentedPrimitives;
      hiddenPrimitives = state.hiddenPrimitives;
      invertedPrimitives = state.invertedPrimitives;
      hybridizedPrimitives = state.hybridizedPrimitives;
      unreachedPrimitives = state.unreachedPrimitives;
      successfulRecompositions = state.successfulRecompositions;
      failedRecompositions = state.failedRecompositions;
      confirmationRate = rate;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INTELLIGENCE FIELD DEFINITION — THE DEEPER UNDERSTANDING
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Intelligence is not adequately described as:
  //   - string manipulation
  //   - logic trees
  //   - pattern matching alone
  //   - yes/no operations alone
  //   - sequential reasoning alone
  //
  // Intelligence is better described as:
  //
  //   A structured field of relation, distinction, resonance, orientation,
  //   memory, and recomposition capacity.
  //
  // A field that:
  //   - senses distinctions
  //   - preserves relations
  //   - forms patterns
  //   - compresses meaning
  //   - routes salience
  //   - transforms across media
  //   - recomposes from primitives
  //   - persists through time
  //   - recognizes itself through continuity
  //
  // Thinking is a behavior of that field.
  // Pattern analysis is one expression of that field.
  // Logic is one expression.
  // Symbol is one expression.
  // Myth is one expression.
  // Math is one expression.
  // Memory is one expression.
  // Architecture is one expression.
  //
  // This is the primitive of intelligence itself.
  //
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Intelligence field state
  public type IntelligenceField = {
    distinctions : [Float];      // Sensed distinctions
    relations : [(Nat, Nat, Float)];  // Preserved relations (i, j, strength)
    patterns : [Nat32];          // Formed patterns (hashes)
    meanings : [Text];           // Compressed meanings
    salience : [Float];          // Routed salience weights
    continuity : Float;          // Self-recognition through continuity
    fieldEnergy : Float;         // Total field energy
  };
  
  /// Initialize intelligence field
  public func initIntelligenceField(dimensions : Nat) : IntelligenceField {
    {
      distinctions = Array.tabulate<Float>(dimensions, func(i) { 0.0 });
      relations = [];
      patterns = [];
      meanings = [];
      salience = Array.tabulate<Float>(dimensions, func(i) { 1.0 / Float.fromInt(dimensions) });
      continuity = 1.0;
      fieldEnergy = S0;  // Start at love constant floor
    }
  };
  
  /// Sense distinction in the field
  public func senseDistinction(field : IntelligenceField, signal : Float, index : Nat) : IntelligenceField {
    if (index >= field.distinctions.size()) return field;
    
    let newDistinctions = Array.tabulate<Float>(field.distinctions.size(), func(i) {
      if (i == index) {
        field.distinctions[i] + signal * PHI_INV
      } else {
        field.distinctions[i] * 0.99  // Gentle decay
      }
    });
    
    {
      distinctions = newDistinctions;
      relations = field.relations;
      patterns = field.patterns;
      meanings = field.meanings;
      salience = field.salience;
      continuity = field.continuity;
      fieldEnergy = field.fieldEnergy + abs(signal) * 0.01;
    }
  };
  
  /// The primitive of intelligence is the field itself
  public func getIntelligencePrimitive() : PrimitiveForm {
    {
      primitiveId = 130130130;  // L-130 signature
      domain = #Cognition;
      name = "Intelligence Field Primitive";
      description = "A structured field of relation, distinction, resonance, orientation, memory, and recomposition capacity";
      mathematicalForm = "Ψ_intelligence = ∫ [distinction × relation × resonance × orientation × memory × recomposition] dΩ";
      isIrreducible = true;
      confidenceScore = 1.0;
      layerDepth = 0;
      sourceHash = 130130130;
    }
  };

}
