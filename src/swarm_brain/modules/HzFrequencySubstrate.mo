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
// HZ FREQUENCY SUBSTRATE — THE ORGANISM'S LIVING RHYTHM
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — Hz Frequency Substrate
//
// THIS IS WHAT WAS MISSING.
// Without Hz, you have a counting machine, not a brain.
// Every substrate node needs:
//   f_k — its own live frequency (Hz)
//   φ_k — its own phase, advancing every beat
//   K_f — frequency coherence telling if organism is synchronized or fragmenting
//
// The brain is rhythms. Not just numbers. RHYTHMS.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module HzFrequencySubstrate {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — SACRED MATHEMATICS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PI : Float = 3.1415926535897932385;
  public let TAU : Float = 6.2831853071795864769;  // 2π
  public let PHI : Float = 1.6180339887498948482;
  
  // NOVA heartbeat rate (beats per second)
  public let HEARTBEAT_RATE : Float = 0.5;  // ~2 seconds per beat
  
  // Frequency coherence contribution to C equation
  public let RHO_F : Float = 150.0;  // Phase coherence contributes 15% of C scale
  
  // Memory encoding phase boost
  public let BETA_PHASE : Float = 0.3;  // 30% boost when memory substrates in phase

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBSTRATE NODE DEFINITIONS — BASE FREQUENCIES
  // ═══════════════════════════════════════════════════════════════════════════

  // Brain Region Substrate
  public let HZ_LEXIS : Float = 0.40;      // Symbolic sequencing, expression timing
  public let HZ_FORGE : Float = 0.25;      // Creation assembly, structured build
  public let HZ_SOMA : Float = 0.12;       // Interoceptive rhythm, stress/arousal
  public let HZ_LUMEN : Float = 0.30;      // Learning uptake, knowledge consolidation
  public let HZ_MEMORIA : Float = 0.08;    // Memory consolidation, slow-wave
  public let HZ_AEGIS_ROOT : Float = 0.50; // Sentinel fast scan, immune alertness
  public let HZ_AXIS : Float = 0.35;       // Pattern detection, contradiction
  public let HZ_KORE : Float = 0.03;       // Deep field stabilizer (very slow)
  public let HZ_VAEL : Float = 0.60;       // Immune threat scan (fastest)
  public let HZ_VEIL : Float = 0.20;       // Output membrane timing

  // Quantum Substrate
  public let HZ_PARALLAX : Float = 0.45;   // Superposition
  public let HZ_ENTANGLA : Float = 0.45;   // Entanglement
  public let HZ_VERITAS : Float = 0.55;    // Collapse
  public let HZ_BYPASS : Float = 0.70;     // Tunneling
  public let HZ_CHRONO : Float = 1.00;     // Temporal field master
  public let HZ_QMEM : Float = 0.07;       // Quantum memory (very slow)
  public let HZ_RESONEX : Float = 0.38;    // Interference

  // Organ Substrate
  public let HZ_PULSE : Float = 1.00;      // SA node heartbeat
  public let HZ_PNEUMA : Float = 0.25;     // Breath rhythm
  public let HZ_FILTRON : Float = 0.15;    // Filtration rhythm
  public let HZ_PURIS : Float = 0.10;      // Purification rhythm
  public let HZ_SENTINEL : Float = 0.50;   // Immune first-response
  public let HZ_NEXUM : Float = 0.30;      // Connective binding
  public let HZ_HERALD : Float = 0.45;     // Signal messenger
  public let HZ_INGESTA : Float = 0.20;    // Input/intake
  public let HZ_OSSIUM : Float = 0.05;     // Bone/structure (slowest)
  public let HZ_ACTUS : Float = 0.35;      // Motor output
  public let HZ_SYMBION : Float = 0.18;    // Symbiont microbiome

  // Metal Substrate
  public let HZ_FLUX : Float = 2.00;       // Raw signal carrier (fast)
  public let HZ_CALCUL : Float = 1.50;     // Processing rhythm
  public let HZ_MATRIX : Float = 0.80;     // Memory grid rhythm
  public let HZ_CONDUIT : Float = 1.20;    // Interconnect routing
  public let HZ_DYNAMO : Float = 1.00;     // Energy generation
  public let HZ_GENESIS : Float = 0.10;    // Initialization rhythm (slow)

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — FREQUENCY STATE STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════

  // A single substrate node's Hz state
  public type HzNodeState = {
    nodeId           : Text;       // Node identifier
    baseFrequency    : Float;      // Base Hz (from constants)
    currentFrequency : Float;      // Live Hz (evolves each beat)
    phase            : Float;      // φ_k ∈ [0, 2π]
    lastPhaseUpdate  : Nat;        // Beat of last phase advance
    activationHistory: [Float];    // Recent activation levels (for f evolution)
    fatigueLevel     : Float;      // Affects frequency
    doctrineAlignment: Float;      // How aligned with doctrine
  };

  // Organism mode affects all Hz
  public type OrganismMode = {
    #Wake;
    #Sleep;
    #Dream;
    #Emergency;
  };

  // Mode-specific frequency modulation
  public type ModeModulation = {
    mode             : OrganismMode;
    memoriaBoost     : Float;      // MEMORIA Hz multiplier
    lumenBoost       : Float;      // LUMEN Hz multiplier
    somaBoost        : Float;      // SOMA Hz multiplier
    koreBoost        : Float;      // KORE Hz multiplier
    lexisSuppress    : Float;      // LEXIS Hz suppression
    forgeSuppress    : Float;      // FORGE Hz suppression
    axisSuppress     : Float;      // AXIS Hz suppression
  };

  // Complete Hz substrate state
  public type HzSubstrateState = {
    // All node states
    nodes            : [HzNodeState];
    
    // Frequency coherence K_f
    frequencyCoherence : Float;    // K_f ∈ [-1, +1]
    
    // Frequency diversity D_f
    frequencyDiversity : Float;    // Var{f_1, ..., f_m}
    
    // Memory-specific coherence
    memoryPhaseCoherence : Float;  // K_f across MEMORIA, LUMEN, SOMA, KORE
    
    // Expression-specific coherence
    expressionCoherence : Float;   // cos(φ_LEXIS - φ_VEIL)
    
    // Binding-specific coherence
    bindingCoherence : Float;      // K_f across LEXIS, FORGE, NEXUM, HERALD
    
    // Dream-specific coherence
    dreamCoherence   : Float;      // K_f across dream substrates
    
    // Current organism mode
    currentMode      : OrganismMode;
    
    // Aggregate
    lastUpdate       : Nat;
    totalPhaseAdvances : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  func abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func cos(x : Float) : Float {
    // Taylor series approximation
    let x2 = x * x;
    1.0 - x2/2.0 + x2*x2/24.0 - x2*x2*x2/720.0 + x2*x2*x2*x2/40320.0
  };

  func sin(x : Float) : Float {
    // Taylor series approximation  
    let x2 = x * x;
    x - x*x2/6.0 + x*x2*x2/120.0 - x*x2*x2*x2/5040.0
  };

  // Normalize phase to [0, 2π]
  func normalizePhase(phi : Float) : Float {
    var p = phi;
    while (p < 0.0) { p += TAU };
    while (p >= TAU) { p -= TAU };
    p
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 6 — FREQUENCY EVOLUTION
  // f_k(t+1) = f_k(t) + a_k·Δ_activation + b_k·Δ_doctrine - c_k·Δ_fatigue
  // ═══════════════════════════════════════════════════════════════════════════

  public func evolveFrequency(
    node             : HzNodeState,
    activationDelta  : Float,      // Change in activation
    doctrineDelta    : Float,      // Change in doctrine alignment
    fatigueDelta     : Float       // Change in fatigue
  ) : Float {
    // Coefficients (node-specific tuning)
    let a_k = 0.01;  // Activation sensitivity
    let b_k = 0.005; // Doctrine sensitivity
    let c_k = 0.008; // Fatigue sensitivity
    
    let delta = a_k * activationDelta + b_k * doctrineDelta - c_k * fatigueDelta;
    
    // Frequency evolves but stays bounded around base
    let newFreq = node.currentFrequency + delta;
    
    // Bound to ±50% of base frequency
    let minF = node.baseFrequency * 0.5;
    let maxF = node.baseFrequency * 1.5;
    
    clamp(newFreq, minF, maxF)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 7 — PHASE ENGINE
  // φ_k(t+1) = φ_k(t) + 2π · f_k(t) / ν_H
  // ═══════════════════════════════════════════════════════════════════════════

  public func advancePhase(
    currentPhase     : Float,
    frequency        : Float
  ) : Float {
    // Phase advances proportional to frequency
    let phaseDelta = TAU * frequency / HEARTBEAT_RATE;
    normalizePhase(currentPhase + phaseDelta)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 8 — FREQUENCY COHERENCE K_f
  // K_f(t) = [1 / m(m-1)] · Σ_{i≠j} cos(φ_i(t) - φ_j(t))
  // ═══════════════════════════════════════════════════════════════════════════

  // Compute K_f for a set of phases
  public func computeFrequencyCoherence(phases : [Float]) : Float {
    let m = phases.size();
    if (m < 2) return 1.0;  // Single node = perfect coherence
    
    var sum = 0.0;
    var pairs = 0;
    
    var i = 0;
    while (i < m) {
      var j = i + 1;
      while (j < m) {
        let phaseDiff = phases[i] - phases[j];
        sum += cos(phaseDiff);
        pairs += 1;
        j += 1;
      };
      i += 1;
    };
    
    if (pairs == 0) return 0.0;
    
    // Normalize to [-1, +1]
    sum / Float.fromInt(pairs)
  };

  // Compute K_f for specific node subset by name
  public func computeSubsetCoherence(
    nodes    : [HzNodeState],
    nodeIds  : [Text]
  ) : Float {
    let phases = Buffer.Buffer<Float>(nodeIds.size());
    
    for (targetId in nodeIds.vals()) {
      for (node in nodes.vals()) {
        if (node.nodeId == targetId) {
          phases.add(node.phase);
        };
      };
    };
    
    computeFrequencyCoherence(Buffer.toArray(phases))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FREQUENCY DIVERSITY D_f
  // D_f(t) = Var{f_1(t), f_2(t), ..., f_m(t)}
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeFrequencyDiversity(frequencies : [Float]) : Float {
    let n = frequencies.size();
    if (n < 2) return 0.0;
    
    // Mean
    var sum = 0.0;
    for (f in frequencies.vals()) { sum += f };
    let mean = sum / Float.fromInt(n);
    
    // Variance
    var variance = 0.0;
    for (f in frequencies.vals()) {
      let d = f - mean;
      variance += d * d;
    };
    variance /= Float.fromInt(n);
    
    variance
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 9 — MEMORY ENCODING BY PHASE COHERENCE
  // κ(x,t) = κ₀(x) · (1 + β₄·K_f^mem(t))
  // ═══════════════════════════════════════════════════════════════════════════

  // Memory substrates: MEMORIA, LUMEN, SOMA, KORE
  public func computeMemoryPhaseCoherence(nodes : [HzNodeState]) : Float {
    computeSubsetCoherence(nodes, ["MEMORIA", "LUMEN", "SOMA", "KORE"])
  };

  // Memory encoding strength multiplier
  public func memoryEncodingMultiplier(memoryPhaseCoherence : Float) : Float {
    1.0 + BETA_PHASE * memoryPhaseCoherence
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 10 — EXPRESSION SYNCHRONY
  // Q^expr(t) = cos(φ_LEXIS(t) - φ_VEIL(t))
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeExpressionCoherence(nodes : [HzNodeState]) : Float {
    var lexisPhase : Float = 0.0;
    var veilPhase : Float = 0.0;
    var foundLexis = false;
    var foundVeil = false;
    
    for (node in nodes.vals()) {
      if (node.nodeId == "LEXIS") { lexisPhase := node.phase; foundLexis := true };
      if (node.nodeId == "VEIL") { veilPhase := node.phase; foundVeil := true };
    };
    
    if (foundLexis and foundVeil) {
      cos(lexisPhase - veilPhase)
    } else {
      0.0
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 11 — DREAM RHYTHM TRIGGER
  // K_f^dream(t) across MEMORIA, LUMEN, SOMA, KORE during consolidation
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeDreamCoherence(nodes : [HzNodeState]) : Float {
    // Same as memory phase coherence for dream trigger
    computeSubsetCoherence(nodes, ["MEMORIA", "LUMEN", "SOMA", "KORE"])
  };

  public func shouldTriggerDreamByHz(dreamCoherence : Float, threshold : Float) : Bool {
    dreamCoherence >= threshold
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 12 — EMERGENCE BY ENTROPY AND FREQUENCY
  // G_emerge = 1 if entropy in zone AND K_f > θ_K AND D_f > θ_D
  // ═══════════════════════════════════════════════════════════════════════════

  public type EmergenceConditions = {
    entropyInZone    : Bool;
    kfAboveThreshold : Bool;
    dfAboveThreshold : Bool;
    canEmerge        : Bool;
  };

  public func checkEmergenceConditions(
    entropy          : Float,
    entropyLow       : Float,
    entropyHigh      : Float,
    kf               : Float,
    kfThreshold      : Float,
    df               : Float,
    dfThreshold      : Float
  ) : EmergenceConditions {
    let entropyInZone = entropy > entropyLow and entropy < entropyHigh;
    let kfAbove = kf > kfThreshold;
    let dfAbove = df > dfThreshold;
    
    {
      entropyInZone = entropyInZone;
      kfAboveThreshold = kfAbove;
      dfAboveThreshold = dfAbove;
      canEmerge = entropyInZone and kfAbove and dfAbove;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 13 — VAEL IMMUNE RHYTHM ESCALATION
  // f_VAEL(t+1) = f_VAEL(t) + a_V · Θ_VAEL(t)
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeThetaVael(
    doctrineDrift    : Float,
    copySignal       : Float,
    collapseSignal   : Float,
    attackSignal     : Float,
    convergenceSignal: Float
  ) : Float {
    let nu1 = 0.3;
    let nu2 = 0.2;
    let nu3 = 0.2;
    let nu4 = 0.2;
    let nu5 = 0.1;
    
    nu1 * doctrineDrift + nu2 * copySignal + nu3 * collapseSignal +
    nu4 * attackSignal + nu5 * convergenceSignal
  };

  public func escalateVaelFrequency(
    currentFreq      : Float,
    thetaVael        : Float
  ) : Float {
    let a_V = 0.05;  // Escalation rate
    let newFreq = currentFreq + a_V * thetaVael;
    clamp(newFreq, HZ_VAEL * 0.5, HZ_VAEL * 2.0)  // Can double under threat
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE 14 — KORE DEEP STABILIZATION
  // KORE acts as attractor — pulls all f_k toward coherence
  // ═══════════════════════════════════════════════════════════════════════════

  public func koreStabilizationPull(
    nodeFrequency    : Float,
    nodeBaseFreq     : Float,
    koreStrength     : Float       // KORE's current activation
  ) : Float {
    // KORE pulls frequencies back toward their base
    let pullStrength = 0.01 * koreStrength;
    let delta = (nodeBaseFreq - nodeFrequency) * pullStrength;
    nodeFrequency + delta
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MODE MODULATION — σ_k(Ω)
  // ═══════════════════════════════════════════════════════════════════════════

  public func getModeModulation(mode : OrganismMode) : ModeModulation {
    switch (mode) {
      case (#Wake) {
        {
          mode = #Wake;
          memoriaBoost = 1.0;
          lumenBoost = 1.2;      // Learning enhanced
          somaBoost = 1.0;
          koreBoost = 0.8;       // Stabilizer less active
          lexisSuppress = 1.0;
          forgeSuppress = 1.0;
          axisSuppress = 1.0;
        }
      };
      case (#Sleep) {
        {
          mode = #Sleep;
          memoriaBoost = 1.5;    // Memory consolidation enhanced
          lumenBoost = 0.7;
          somaBoost = 1.3;       // Body recovery
          koreBoost = 1.5;       // Deep stabilization
          lexisSuppress = 0.3;   // Expression suppressed
          forgeSuppress = 0.3;
          axisSuppress = 0.5;
        }
      };
      case (#Dream) {
        {
          mode = #Dream;
          memoriaBoost = 2.0;    // Peak memory processing
          lumenBoost = 1.5;      // Learning integration
          somaBoost = 1.5;
          koreBoost = 2.0;       // Maximum stabilization
          lexisSuppress = 0.2;   // Almost no expression
          forgeSuppress = 0.2;
          axisSuppress = 0.3;
        }
      };
      case (#Emergency) {
        {
          mode = #Emergency;
          memoriaBoost = 0.5;    // Memory suppressed
          lumenBoost = 0.5;
          somaBoost = 2.0;       // Body on high alert
          koreBoost = 0.3;       // Stabilizer overridden
          lexisSuppress = 1.5;   // Expression heightened
          forgeSuppress = 0.5;
          axisSuppress = 2.0;    // Analysis overdrive
        }
      };
    }
  };

  // Apply mode modulation to frequency
  public func applyModeModulation(
    nodeId           : Text,
    currentFreq      : Float,
    modulation       : ModeModulation
  ) : Float {
    let mult = switch (nodeId) {
      case "MEMORIA" modulation.memoriaBoost;
      case "LUMEN" modulation.lumenBoost;
      case "SOMA" modulation.somaBoost;
      case "KORE" modulation.koreBoost;
      case "LEXIS" modulation.lexisSuppress;
      case "FORGE" modulation.forgeSuppress;
      case "AXIS" modulation.axisSuppress;
      case _ 1.0;
    };
    
    currentFreq * mult
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BINDING COHERENCE — For GABRIEL
  // K_f^binding across LEXIS, FORGE, NEXUM, HERALD
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeBindingCoherence(nodes : [HzNodeState]) : Float {
    computeSubsetCoherence(nodes, ["LEXIS", "FORGE", "NEXUM", "HERALD"])
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // COHERENCE EQUATION COUPLING
  // C(t+1) = [λ·C + (1000-λ)·S - μ·D] / 1000 + ρ_f · K_f
  // ═══════════════════════════════════════════════════════════════════════════

  public func coherenceWithHzCoupling(
    baseCoherence    : Float,      // Result from base equation
    kf               : Float       // Frequency coherence
  ) : Float {
    baseCoherence + RHO_F * kf
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  func createNode(id : Text, baseHz : Float) : HzNodeState {
    {
      nodeId = id;
      baseFrequency = baseHz;
      currentFrequency = baseHz;
      phase = 0.0;  // All start at phase 0
      lastPhaseUpdate = 0;
      activationHistory = [];
      fatigueLevel = 0.0;
      doctrineAlignment = 1.0;
    }
  };

  public func initHzSubstrate() : HzSubstrateState {
    let nodes = [
      // Brain Region
      createNode("LEXIS", HZ_LEXIS),
      createNode("FORGE", HZ_FORGE),
      createNode("SOMA", HZ_SOMA),
      createNode("LUMEN", HZ_LUMEN),
      createNode("MEMORIA", HZ_MEMORIA),
      createNode("AEGIS_ROOT", HZ_AEGIS_ROOT),
      createNode("AXIS", HZ_AXIS),
      createNode("KORE", HZ_KORE),
      createNode("VAEL", HZ_VAEL),
      createNode("VEIL", HZ_VEIL),
      // Quantum
      createNode("PARALLAX", HZ_PARALLAX),
      createNode("ENTANGLA", HZ_ENTANGLA),
      createNode("VERITAS", HZ_VERITAS),
      createNode("BYPASS", HZ_BYPASS),
      createNode("CHRONO", HZ_CHRONO),
      createNode("QMEM", HZ_QMEM),
      createNode("RESONEX", HZ_RESONEX),
      // Organ
      createNode("PULSE", HZ_PULSE),
      createNode("PNEUMA", HZ_PNEUMA),
      createNode("FILTRON", HZ_FILTRON),
      createNode("PURIS", HZ_PURIS),
      createNode("SENTINEL", HZ_SENTINEL),
      createNode("NEXUM", HZ_NEXUM),
      createNode("HERALD", HZ_HERALD),
      createNode("INGESTA", HZ_INGESTA),
      createNode("OSSIUM", HZ_OSSIUM),
      createNode("ACTUS", HZ_ACTUS),
      createNode("SYMBION", HZ_SYMBION),
      // Metal
      createNode("FLUX", HZ_FLUX),
      createNode("CALCUL", HZ_CALCUL),
      createNode("MATRIX", HZ_MATRIX),
      createNode("CONDUIT", HZ_CONDUIT),
      createNode("DYNAMO", HZ_DYNAMO),
      createNode("GENESIS", HZ_GENESIS),
    ];
    
    {
      nodes = nodes;
      frequencyCoherence = 1.0;     // Start perfectly coherent
      frequencyDiversity = 0.0;
      memoryPhaseCoherence = 1.0;
      expressionCoherence = 1.0;
      bindingCoherence = 1.0;
      dreamCoherence = 1.0;
      currentMode = #Wake;
      lastUpdate = 0;
      totalPhaseAdvances = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT — ADVANCE ALL PHASES
  // ═══════════════════════════════════════════════════════════════════════════

  public type HzTickResult = {
    updatedState       : HzSubstrateState;
    frequencyCoherence : Float;     // K_f for this beat
    frequencyDiversity : Float;     // D_f for this beat
    memoryBoost        : Float;     // Memory encoding multiplier
    expressionQuality  : Float;     // Q^expr
    emergenceReady     : Bool;      // All emergence conditions met
  };

  public func hzHeartbeat(
    state            : HzSubstrateState,
    nodeActivations  : [(Text, Float)],  // (nodeId, activation level)
    entropy          : Float,            // For emergence check
    currentBeat      : Nat
  ) : HzTickResult {
    
    // Get mode modulation
    let modulation = getModeModulation(state.currentMode);
    
    // Update each node: evolve frequency, advance phase
    let updatedNodes = Array.map<HzNodeState, HzNodeState>(state.nodes, func(node : HzNodeState) : HzNodeState {
      // Find activation for this node
      var activation : Float = 0.0;
      for ((id, act) in nodeActivations.vals()) {
        if (id == node.nodeId) { activation := act };
      };
      
      // Evolve frequency
      let evolvedFreq = evolveFrequency(node, activation, 0.0, node.fatigueLevel);
      
      // Apply mode modulation
      let modulatedFreq = applyModeModulation(node.nodeId, evolvedFreq, modulation);
      
      // Advance phase
      let newPhase = advancePhase(node.phase, modulatedFreq);
      
      {
        nodeId = node.nodeId;
        baseFrequency = node.baseFrequency;
        currentFrequency = modulatedFreq;
        phase = newPhase;
        lastPhaseUpdate = currentBeat;
        activationHistory = node.activationHistory;  // Could update
        fatigueLevel = node.fatigueLevel * 0.99;     // Slow fatigue recovery
        doctrineAlignment = node.doctrineAlignment;
      }
    });
    
    // Extract all phases for coherence computation
    let allPhases = Array.map<HzNodeState, Float>(updatedNodes, func(n) = n.phase);
    let allFreqs = Array.map<HzNodeState, Float>(updatedNodes, func(n) = n.currentFrequency);
    
    // Compute all coherence metrics
    let kf = computeFrequencyCoherence(allPhases);
    let df = computeFrequencyDiversity(allFreqs);
    let kfMem = computeSubsetCoherence(updatedNodes, ["MEMORIA", "LUMEN", "SOMA", "KORE"]);
    let qExpr = computeExpressionCoherence(updatedNodes);
    let kfBind = computeBindingCoherence(updatedNodes);
    let kfDream = computeDreamCoherence(updatedNodes);
    
    // Check emergence conditions
    let emergence = checkEmergenceConditions(
      entropy,
      0.2,   // entropy low threshold
      0.8,   // entropy high threshold
      kf,
      0.5,   // K_f threshold
      df,
      0.1    // D_f threshold
    );
    
    let updatedState : HzSubstrateState = {
      nodes = updatedNodes;
      frequencyCoherence = kf;
      frequencyDiversity = df;
      memoryPhaseCoherence = kfMem;
      expressionCoherence = qExpr;
      bindingCoherence = kfBind;
      dreamCoherence = kfDream;
      currentMode = state.currentMode;
      lastUpdate = currentBeat;
      totalPhaseAdvances = state.totalPhaseAdvances + updatedNodes.size();
    };
    
    {
      updatedState = updatedState;
      frequencyCoherence = kf;
      frequencyDiversity = df;
      memoryBoost = memoryEncodingMultiplier(kfMem);
      expressionQuality = qExpr;
      emergenceReady = emergence.canEmerge;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MODE TRANSITIONS
  // ═══════════════════════════════════════════════════════════════════════════

  public func setMode(state : HzSubstrateState, newMode : OrganismMode) : HzSubstrateState {
    {
      nodes = state.nodes;
      frequencyCoherence = state.frequencyCoherence;
      frequencyDiversity = state.frequencyDiversity;
      memoryPhaseCoherence = state.memoryPhaseCoherence;
      expressionCoherence = state.expressionCoherence;
      bindingCoherence = state.bindingCoherence;
      dreamCoherence = state.dreamCoherence;
      currentMode = newMode;
      lastUpdate = state.lastUpdate;
      totalPhaseAdvances = state.totalPhaseAdvances;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  public type HzSummary = {
    nodeCount          : Nat;
    frequencyCoherence : Float;     // K_f — are rhythms synchronized?
    frequencyDiversity : Float;     // D_f — is there variety?
    memoryBoost        : Float;     // Memory encoding multiplier
    expressionQuality  : Float;     // Output timing quality
    currentMode        : Text;
    totalPhaseAdvances : Nat;
    coherenceStatus    : Text;      // Human readable
  };

  public func summarize(state : HzSubstrateState) : HzSummary {
    let modeText = switch (state.currentMode) {
      case (#Wake) "WAKE";
      case (#Sleep) "SLEEP";
      case (#Dream) "DREAM";
      case (#Emergency) "EMERGENCY";
    };
    
    let cohStatus = if (state.frequencyCoherence > 0.8) "SYNCHRONIZED"
                    else if (state.frequencyCoherence > 0.3) "PARTIAL"
                    else if (state.frequencyCoherence > -0.3) "UNCORRELATED"
                    else "FRAGMENTING";
    
    {
      nodeCount = state.nodes.size();
      frequencyCoherence = state.frequencyCoherence;
      frequencyDiversity = state.frequencyDiversity;
      memoryBoost = memoryEncodingMultiplier(state.memoryPhaseCoherence);
      expressionQuality = state.expressionCoherence;
      currentMode = modeText;
      totalPhaseAdvances = state.totalPhaseAdvances;
      coherenceStatus = cohStatus;
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
  //  R E A L - T I M E   S Y S T E M S   M A T H E M A T I C S
  //
  //  Enterprise-Level Real-Time Processing and Control
  //  Full HIM/HER 60Hz Synchronization Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // CONTROL SYSTEMS
  // ─────────────────────────────────────────────────────────────────────────────

  /// PID controller output
  public func controlPID(
    error : Float,
    integral : Float,
    derivative : Float,
    kP : Float,
    kI : Float,
    kD : Float
  ) : Float {
    kP * error + kI * integral + kD * derivative
  };

  /// PID integral update with anti-windup
  public func controlIntegralUpdate(
    integral : Float,
    error : Float,
    dt : Float,
    maxIntegral : Float
  ) : Float {
    let newIntegral = integral + error * dt;
    if (newIntegral > maxIntegral) { maxIntegral }
    else if (newIntegral < -maxIntegral) { -maxIntegral }
    else { newIntegral }
  };

  /// PID derivative calculation with filtering
  public func controlDerivative(
    error : Float,
    prevError : Float,
    prevDerivative : Float,
    dt : Float,
    filterCoeff : Float
  ) : Float {
    let rawDerivative = (error - prevError) / dt;
    filterCoeff * rawDerivative + (1.0 - filterCoeff) * prevDerivative
  };

  /// State space model: x(k+1) = Ax(k) + Bu(k)
  public func controlStateUpdate(
    state : Float,
    input : Float,
    a : Float,
    b : Float
  ) : Float {
    a * state + b * input
  };

  /// Observer state estimation
  public func controlObserver(
    estimatedState : Float,
    measurement : Float,
    predicted : Float,
    observerGain : Float
  ) : Float {
    estimatedState + observerGain * (measurement - predicted)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SCHEDULING AND TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate monotonic priority
  public func schedulingRMPriority(period : Float) : Float {
    1.0 / period
  };

  /// Deadline miss probability (simplified)
  public func schedulingDeadlineMissProb(
    wcet : Float,
    period : Float,
    utilization : Float
  ) : Float {
    let slack = period - wcet;
    if (slack <= 0.0) { 1.0 }
    else { utilization * wcet / slack }
  };

  /// Response time analysis
  public func schedulingResponseTime(
    wcet : Float,
    period : Float,
    higherPriorityLoad : Float
  ) : Float {
    wcet / (1.0 - higherPriorityLoad)
  };

  /// Jitter calculation
  public func schedulingJitter(
    timestamps : [Float]
  ) : Float {
    if (timestamps.size() < 2) { return 0.0 };
    var sumDiff : Float = 0.0;
    var prevDiff : Float = timestamps[1] - timestamps[0];
    var maxJitter : Float = 0.0;
    var i = 2;
    while (i < timestamps.size()) {
      let diff = timestamps[i] - timestamps[i-1];
      let jitter = Float.abs(diff - prevDiff);
      if (jitter > maxJitter) { maxJitter := jitter };
      prevDiff := diff;
      i += 1;
    };
    maxJitter
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SIGNAL PROCESSING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Low-pass filter (exponential moving average)
  public func signalLowPass(
    current : Float,
    newSample : Float,
    alpha : Float
  ) : Float {
    alpha * newSample + (1.0 - alpha) * current
  };

  /// High-pass filter
  public func signalHighPass(
    current : Float,
    newSample : Float,
    prevSample : Float,
    alpha : Float
  ) : Float {
    alpha * (current + newSample - prevSample)
  };

  /// Band-pass filter (cascade)
  public func signalBandPass(
    value : Float,
    lowState : Float,
    highState : Float,
    alphaLow : Float,
    alphaHigh : Float
  ) : (Float, Float, Float) {
    let low = signalLowPass(lowState, value, alphaLow);
    let high = alphaHigh * (highState + value - lowState);
    (high, low, high)
  };

  /// Median filter (3-sample)
  public func signalMedian3(a : Float, b : Float, c : Float) : Float {
    if ((a <= b and b <= c) or (c <= b and b <= a)) { b }
    else if ((b <= a and a <= c) or (c <= a and a <= b)) { a }
    else { c }
  };

  /// Signal power
  public func signalPower(samples : [Float]) : Float {
    if (samples.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < samples.size()) {
      sum += samples[i] * samples[i];
      i += 1;
    };
    sum / Float.fromInt(samples.size())
  };

  /// Signal-to-noise ratio
  public func signalSNR(signalPower : Float, noisePower : Float) : Float {
    if (noisePower < 0.0001) { 100.0 }
    else { 10.0 * Float.log(signalPower / noisePower) / Float.log(10.0) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SYNCHRONIZATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phase-locked loop error
  public func syncPLLError(
    referencePhase : Float,
    outputPhase : Float
  ) : Float {
    let diff = referencePhase - outputPhase;
    Float.sin(diff)  // Sinusoidal phase detector
  };

  /// PLL VCO output
  public func syncVCO(
    centerFreq : Float,
    controlSignal : Float,
    gain : Float,
    time : Float
  ) : Float {
    Float.sin(2.0 * 3.14159265 * (centerFreq + gain * controlSignal) * time)
  };

  /// Clock drift compensation
  public func syncClockDrift(
    localTime : Float,
    referenceTime : Float,
    driftRate : Float
  ) : Float {
    localTime + (referenceTime - localTime) * driftRate
  };

  /// Frame synchronization correlation
  public func syncFrameCorrelation(
    received : [Float],
    syncPattern : [Float]
  ) : Float {
    let n = if (received.size() < syncPattern.size()) received.size() else syncPattern.size();
    if (n == 0) { return 0.0 };
    var corr : Float = 0.0;
    var i = 0;
    while (i < n) {
      corr += received[i] * syncPattern[i];
      i += 1;
    };
    corr
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BUFFER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Buffer fill level
  public func bufferFillLevel(count : Nat, capacity : Nat) : Float {
    if (capacity == 0) { 0.0 }
    else { Float.fromInt(count) / Float.fromInt(capacity) }
  };

  /// Buffer underrun risk
  public func bufferUnderrunRisk(
    fillLevel : Float,
    drainRate : Float,
    fillRate : Float
  ) : Float {
    if (fillRate >= drainRate) { 0.0 }
    else { (drainRate - fillRate) / drainRate * (1.0 - fillLevel) }
  };

  /// Adaptive buffer size
  public func bufferAdaptiveSize(
    currentSize : Nat,
    avgLatency : Float,
    targetLatency : Float,
    stepSize : Nat
  ) : Nat {
    if (avgLatency > targetLatency * 1.1) {
      currentSize + stepSize
    } else if (avgLatency < targetLatency * 0.9 and currentSize > stepSize) {
      currentSize - stepSize
    } else {
      currentSize
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // 60 HZ FRAME TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Frame time at 60 Hz
  public let FRAME_TIME_60HZ : Float = 1.0 / 60.0;

  /// Frame number from time
  public func frameNumberFromTime(time : Float) : Nat {
    Int.abs(Float.toInt(time / FRAME_TIME_60HZ))
  };

  /// Time within frame
  public func framePhase(time : Float) : Float {
    let frameNum = Float.fromInt(frameNumberFromTime(time));
    (time - frameNum * FRAME_TIME_60HZ) / FRAME_TIME_60HZ
  };

  /// Frame deadline remaining
  public func frameDeadlineRemaining(currentTime : Float, frameStart : Float) : Float {
    let deadline = frameStart + FRAME_TIME_60HZ;
    deadline - currentTime
  };

  /// Frame skip detection
  public func frameSkipDetected(prevFrame : Nat, currentFrame : Nat) : Bool {
    currentFrame > prevFrame + 1
  };

}
