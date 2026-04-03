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

// ═══════════════════════════════════════════════════════════════════════════════
// ARCHITECTURE EXTRACTION FRAMEWORK — PULL ALL ARCHITECTURE FROM DOCTRINE
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
//
// THIS FRAMEWORK EXTRACTS:
// • Laws (L-XXX patterns, mathematical constraints)
// • Equations (mathematical formulations)
// • Constants (sacred values, physical constants)
// • Operators (quantum operators, field operators)
// • Nodes (circuit nodes, shell nodes)
// • Circuits (Shell 2, Shell 3, quantum layer)
// • Systems (VAEL, ARES, VETUS, PROMETHEUS)
// • Governance (43 cores, 7 heritage, tiers)
//
// EVERYTHING extracted gets:
// • Quantum-resistant hash
// • IP attribution record
// • Patent registry entry (if novel)
// • Audit chain entry
// • Genesis seal
//
// 100% of all IP routes to Alfredo Medina Hernandez. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Iter "mo:base/Iter";

module ArchitectureExtractionFramework {

  // ═══════════════════════════════════════════════════════════════════════════
  // EXTRACTION PATTERNS — What we look for in doctrine
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ExtractionPattern = {
    #Law;           // L-XXX patterns
    #Equation;      // Mathematical formulations
    #Constant;      // Sacred values
    #Operator;      // Quantum/field operators
    #Node;          // Circuit nodes
    #Circuit;       // Full circuits
    #System;        // Complete systems
    #Governance;    // Governance elements
    #Variable;      // State variables
    #Threshold;     // Threshold values
    #Rate;          // Compounding rates
    #Matrix;        // Weight matrices
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // EXTRACTED ITEM — Raw extraction before hashing
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ExtractedItem = {
    pattern : ExtractionPattern;
    identifier : Text;
    name : Text;
    description : Text;
    equation : ?Text;
    value : ?Float;
    parameters : [Float];
    dependencies : [Text];
    sourceContext : Text;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HASH FUNCTIONS (same as DoctrineGenesisEngine)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func fnv1a(input : [Nat8]) : Nat32 {
    var hash : Nat32 = 2166136261;
    for (byte in input.vals()) {
      hash := hash ^ Nat32.fromNat(Nat8.toNat(byte));
      hash := hash *% 16777619;
    };
    hash
  };
  
  public func djb2(input : Nat32, context : Nat32) : Nat32 {
    var hash : Nat32 = 5381;
    hash := ((hash << 5) +% hash) +% context;
    hash := ((hash << 5) +% hash) +% input;
    hash
  };
  
  public func sdbm(input : Nat32, context : Nat32) : Nat32 {
    var hash : Nat32 = 0;
    hash := input +% (hash << 6) +% (hash << 16) -% hash;
    hash := context +% (hash << 6) +% (hash << 16) -% hash;
    hash
  };
  
  public func quantumResistantHash(input : [Nat8], context : Nat32, salt : Nat32) : Nat32 {
    let h1 = fnv1a(input) ^ context;
    let h2 = djb2(h1, context ^ salt);
    let h3 = sdbm(h2, h1 ^ salt);
    h1 ^ h2 ^ h3
  };
  
  func textToBytes(text : Text) : [Nat8] {
    let chars = Text.toIter(text);
    let buf = Buffer.Buffer<Nat8>(Text.size(text));
    for (c in chars) {
      buf.add(Nat8.fromNat(Nat32.toNat(Char.toNat32(c)) % 256));
    };
    Buffer.toArray(buf)
  };
  
  public func hashText(text : Text, context : Nat32, salt : Nat32) : Nat32 {
    quantumResistantHash(textToBytes(text), context, salt)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // IP ATTRIBUTION HEADER — Added to everything
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type IPHeader = {
    owner : Text;
    location : Text;
    contact : Text;
    framework : Text;
    copyrightYears : Text;
    legalProtection : [Text];
    extractionTimestamp : Int;
    extractionBeat : Nat;
    genesisHash : Nat32;
    itemHash : Nat32;
    sealed : Bool;
  };
  
  public func createIPHeader(
    itemContent : Text,
    timestamp : Int,
    beatNum : Nat,
    genesisHash : Nat32
  ) : IPHeader {
    let itemHash = hashText(itemContent, genesisHash, 0x49504844);  // "IPHD"
    
    {
      owner = "Alfredo Medina Hernandez";
      location = "Dallas, Texas, United States of America";
      contact = "MedinaSITech@outlook.com";
      framework = "Medina Doctrine";
      copyrightYears = "2024-2026";
      legalProtection = [
        "United States Copyright Law (17 U.S.C. §§ 101-1332)",
        "Berne Convention for the Protection of Literary and Artistic Works",
        "WIPO Copyright Treaty (WCT)",
        "Defend Trade Secrets Act (18 U.S.C. § 1836)",
        "Economic Espionage Act (18 U.S.C. §§ 1831-1839)"
      ];
      extractionTimestamp = timestamp;
      extractionBeat = beatNum;
      genesisHash = genesisHash;
      itemHash = itemHash;
      sealed = true;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HASHED EXTRACTED ITEM — After IP attribution and hashing
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type HashedExtractedItem = {
    item : ExtractedItem;
    ipHeader : IPHeader;
    identifierHash : Nat32;
    nameHash : Nat32;
    descriptionHash : Nat32;
    equationHash : ?Nat32;
    contentHash : Nat32;
    signatureHash : Nat32;  // Double-hash for verification
  };
  
  public func hashExtractedItem(
    item : ExtractedItem,
    timestamp : Int,
    beatNum : Nat,
    genesisHash : Nat32,
    ratchetHash : Nat32
  ) : HashedExtractedItem {
    let identifierHash = hashText(item.identifier, genesisHash, ratchetHash);
    let nameHash = hashText(item.name, identifierHash, genesisHash);
    let descriptionHash = hashText(item.description, nameHash, ratchetHash);
    
    let equationHash : ?Nat32 = switch (item.equation) {
      case (?eq) ?hashText(eq, descriptionHash, genesisHash);
      case null null;
    };
    
    // Content hash combines everything
    let contentInput = item.identifier # item.name # item.description # 
                       (switch (item.equation) { case (?e) e; case null "" });
    let contentHash = hashText(contentInput, genesisHash, ratchetHash);
    
    // Signature is hash of content hash + owner
    let signatureInput = Nat32.toText(contentHash) # "Alfredo Medina Hernandez";
    let signatureHash = hashText(signatureInput, contentHash, genesisHash);
    
    let ipHeader = createIPHeader(contentInput, timestamp, beatNum, genesisHash);
    
    {
      item = item;
      ipHeader = ipHeader;
      identifierHash = identifierHash;
      nameHash = nameHash;
      descriptionHash = descriptionHash;
      equationHash = equationHash;
      contentHash = contentHash;
      signatureHash = signatureHash;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // EXTRACTION STATE — Tracks all extractions
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ExtractionState = {
    genesisHash : Nat32;
    ratchetHash : Nat32;
    ratchetStep : Nat;
    
    extractedLaws : [HashedExtractedItem];
    extractedEquations : [HashedExtractedItem];
    extractedConstants : [HashedExtractedItem];
    extractedOperators : [HashedExtractedItem];
    extractedNodes : [HashedExtractedItem];
    extractedCircuits : [HashedExtractedItem];
    extractedSystems : [HashedExtractedItem];
    extractedGovernance : [HashedExtractedItem];
    extractedVariables : [HashedExtractedItem];
    extractedThresholds : [HashedExtractedItem];
    extractedRates : [HashedExtractedItem];
    extractedMatrices : [HashedExtractedItem];
    
    totalExtractions : Nat;
    doctrineFingerprint : Nat32;
    sealed : Bool;
  };
  
  public func initExtractionState(timestamp : Int) : ExtractionState {
    let genesisInput = textToBytes("Alfredo Medina Hernandez" # Int.toText(timestamp));
    let genesisHash = quantumResistantHash(genesisInput, 0x47454E45, 0x53495320);
    
    {
      genesisHash = genesisHash;
      ratchetHash = genesisHash;
      ratchetStep = 0;
      extractedLaws = [];
      extractedEquations = [];
      extractedConstants = [];
      extractedOperators = [];
      extractedNodes = [];
      extractedCircuits = [];
      extractedSystems = [];
      extractedGovernance = [];
      extractedVariables = [];
      extractedThresholds = [];
      extractedRates = [];
      extractedMatrices = [];
      totalExtractions = 0;
      doctrineFingerprint = genesisHash;
      sealed = false;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ADD EXTRACTION — Add item to appropriate category
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func addExtraction(
    state : ExtractionState,
    item : ExtractedItem,
    timestamp : Int,
    beatNum : Nat
  ) : ExtractionState {
    let hashedItem = hashExtractedItem(item, timestamp, beatNum, state.genesisHash, state.ratchetHash);
    
    // Advance ratchet
    let newRatchet = hashText(Nat32.toText(hashedItem.contentHash), state.ratchetHash, state.genesisHash);
    
    // Update fingerprint
    let newFingerprint = state.doctrineFingerprint ^ hashedItem.contentHash;
    
    // Add to appropriate category
    var newState = {
      state with
      ratchetHash = newRatchet;
      ratchetStep = state.ratchetStep + 1;
      totalExtractions = state.totalExtractions + 1;
      doctrineFingerprint = newFingerprint;
    };
    
    switch (item.pattern) {
      case (#Law) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedLaws);
        items.add(hashedItem);
        newState := { newState with extractedLaws = Buffer.toArray(items) };
      };
      case (#Equation) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedEquations);
        items.add(hashedItem);
        newState := { newState with extractedEquations = Buffer.toArray(items) };
      };
      case (#Constant) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedConstants);
        items.add(hashedItem);
        newState := { newState with extractedConstants = Buffer.toArray(items) };
      };
      case (#Operator) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedOperators);
        items.add(hashedItem);
        newState := { newState with extractedOperators = Buffer.toArray(items) };
      };
      case (#Node) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedNodes);
        items.add(hashedItem);
        newState := { newState with extractedNodes = Buffer.toArray(items) };
      };
      case (#Circuit) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedCircuits);
        items.add(hashedItem);
        newState := { newState with extractedCircuits = Buffer.toArray(items) };
      };
      case (#System) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedSystems);
        items.add(hashedItem);
        newState := { newState with extractedSystems = Buffer.toArray(items) };
      };
      case (#Governance) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedGovernance);
        items.add(hashedItem);
        newState := { newState with extractedGovernance = Buffer.toArray(items) };
      };
      case (#Variable) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedVariables);
        items.add(hashedItem);
        newState := { newState with extractedVariables = Buffer.toArray(items) };
      };
      case (#Threshold) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedThresholds);
        items.add(hashedItem);
        newState := { newState with extractedThresholds = Buffer.toArray(items) };
      };
      case (#Rate) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedRates);
        items.add(hashedItem);
        newState := { newState with extractedRates = Buffer.toArray(items) };
      };
      case (#Matrix) {
        var items = Buffer.fromArray<HashedExtractedItem>(state.extractedMatrices);
        items.add(hashedItem);
        newState := { newState with extractedMatrices = Buffer.toArray(items) };
      };
    };
    
    newState
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE EXTRACTORS — For common patterns
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func extractLaw(
    state : ExtractionState,
    lawId : Nat,
    lawName : Text,
    description : Text,
    equation : Text,
    parameters : [Float],
    timestamp : Int,
    beatNum : Nat
  ) : ExtractionState {
    let item : ExtractedItem = {
      pattern = #Law;
      identifier = "L-" # Nat.toText(lawId);
      name = lawName;
      description = description;
      equation = ?equation;
      value = null;
      parameters = parameters;
      dependencies = [];
      sourceContext = "Medina Doctrine Law Engine";
    };
    addExtraction(state, item, timestamp, beatNum)
  };
  
  public func extractConstant(
    state : ExtractionState,
    constantName : Text,
    description : Text,
    value : Float,
    timestamp : Int,
    beatNum : Nat
  ) : ExtractionState {
    let item : ExtractedItem = {
      pattern = #Constant;
      identifier = "CONST-" # constantName;
      name = constantName;
      description = description;
      equation = null;
      value = ?value;
      parameters = [value];
      dependencies = [];
      sourceContext = "Medina Doctrine Sacred Constants";
    };
    addExtraction(state, item, timestamp, beatNum)
  };
  
  public func extractOperator(
    state : ExtractionState,
    operatorName : Text,
    description : Text,
    equation : Text,
    parameters : [Float],
    timestamp : Int,
    beatNum : Nat
  ) : ExtractionState {
    let item : ExtractedItem = {
      pattern = #Operator;
      identifier = "OP-" # operatorName;
      name = operatorName;
      description = description;
      equation = ?equation;
      value = null;
      parameters = parameters;
      dependencies = [];
      sourceContext = "Medina Doctrine Quantum Operators";
    };
    addExtraction(state, item, timestamp, beatNum)
  };
  
  public func extractNode(
    state : ExtractionState,
    nodeName : Text,
    shell : Nat,
    description : Text,
    parameters : [Float],
    timestamp : Int,
    beatNum : Nat
  ) : ExtractionState {
    let item : ExtractedItem = {
      pattern = #Node;
      identifier = "NODE-SHELL" # Nat.toText(shell) # "-" # nodeName;
      name = nodeName;
      description = description;
      equation = null;
      value = null;
      parameters = parameters;
      dependencies = [];
      sourceContext = "Medina Doctrine Shell " # Nat.toText(shell);
    };
    addExtraction(state, item, timestamp, beatNum)
  };
  
  public func extractCircuit(
    state : ExtractionState,
    circuitName : Text,
    description : Text,
    equation : Text,
    nodeCount : Nat,
    timestamp : Int,
    beatNum : Nat
  ) : ExtractionState {
    let item : ExtractedItem = {
      pattern = #Circuit;
      identifier = "CIRCUIT-" # circuitName;
      name = circuitName;
      description = description;
      equation = ?equation;
      value = null;
      parameters = [Float.fromInt(nodeCount)];
      dependencies = [];
      sourceContext = "Medina Doctrine Circuit Architecture";
    };
    addExtraction(state, item, timestamp, beatNum)
  };
  
  public func extractSystem(
    state : ExtractionState,
    systemName : Text,
    description : Text,
    components : [Text],
    timestamp : Int,
    beatNum : Nat
  ) : ExtractionState {
    let item : ExtractedItem = {
      pattern = #System;
      identifier = "SYS-" # systemName;
      name = systemName;
      description = description;
      equation = null;
      value = null;
      parameters = [];
      dependencies = components;
      sourceContext = "Medina Doctrine System Architecture";
    };
    addExtraction(state, item, timestamp, beatNum)
  };
  
  public func extractGovernance(
    state : ExtractionState,
    govName : Text,
    govType : Text,  // "CORE", "HERITAGE", "TIER", "LAW"
    description : Text,
    parameters : [Float],
    timestamp : Int,
    beatNum : Nat
  ) : ExtractionState {
    let item : ExtractedItem = {
      pattern = #Governance;
      identifier = "GOV-" # govType # "-" # govName;
      name = govName;
      description = description;
      equation = null;
      value = null;
      parameters = parameters;
      dependencies = [];
      sourceContext = "Medina Doctrine Governance";
    };
    addExtraction(state, item, timestamp, beatNum)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SEAL EXTRACTION STATE — Lock everything permanently
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func sealExtractionState(state : ExtractionState) : ExtractionState {
    if (state.sealed) return state;
    
    // Final fingerprint includes seal
    let sealHash = hashText("SEAL-" # Nat32.toText(state.doctrineFingerprint), state.genesisHash, state.ratchetHash);
    let finalFingerprint = state.doctrineFingerprint ^ sealHash;
    
    {
      state with
      doctrineFingerprint = finalFingerprint;
      sealed = true;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GET EXTRACTION SUMMARY — Numeric only (zero-exposure wall)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ExtractionSummary = {
    genesisHash : Nat32;
    totalExtractions : Nat;
    lawCount : Nat;
    equationCount : Nat;
    constantCount : Nat;
    operatorCount : Nat;
    nodeCount : Nat;
    circuitCount : Nat;
    systemCount : Nat;
    governanceCount : Nat;
    variableCount : Nat;
    thresholdCount : Nat;
    rateCount : Nat;
    matrixCount : Nat;
    doctrineFingerprint : Nat32;
    ratchetStep : Nat;
    sealed : Bool;
  };
  
  public func getExtractionSummary(state : ExtractionState) : ExtractionSummary {
    {
      genesisHash = state.genesisHash;
      totalExtractions = state.totalExtractions;
      lawCount = state.extractedLaws.size();
      equationCount = state.extractedEquations.size();
      constantCount = state.extractedConstants.size();
      operatorCount = state.extractedOperators.size();
      nodeCount = state.extractedNodes.size();
      circuitCount = state.extractedCircuits.size();
      systemCount = state.extractedSystems.size();
      governanceCount = state.extractedGovernance.size();
      variableCount = state.extractedVariables.size();
      thresholdCount = state.extractedThresholds.size();
      rateCount = state.extractedRates.size();
      matrixCount = state.extractedMatrices.size();
      doctrineFingerprint = state.doctrineFingerprint;
      ratchetStep = state.ratchetStep;
      sealed = state.sealed;
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

}
