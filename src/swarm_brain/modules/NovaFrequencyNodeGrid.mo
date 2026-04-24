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
// NOVA FREQUENCY NODE GRID — 540-Node PHI-Separated Frequency Grid
// ═══════════════════════════════════════════════════════════════════════════════
//
// 540 = 12 bands × 45 nodes per band
//   12 bands  — PHI-aligned frequency doctrine (φ^0 through φ^11 Hz)
//   45 nodes  — sum of first 9 positive integers (1+2+…+9 = 45),
//               representing the 9 token primitives
//   540       — also 20 × 27 = icosahedral faces × 3³ (cube of trinity)
//
// Band  0  ALPHA    1.000 Hz — Sovereign Core (governance, identity, core brain)
// Band  1  BETA     1.618 Hz — Doctrine (law engines, compliance, pattern gates)
// Band  2  GAMMA    2.618 Hz — Defense (anti-organism, war command, AEGIS, VAEL)
// Band  3  DELTA    4.236 Hz — Memory (Memory Temple, hippocampal replay, elephant)
// Band  4  EPSILON  6.854 Hz — Sensing (field scanner, IoT, echolocation, shark)
// Band  5  ZETA    11.09  Hz — Communication (hybrid hub, transport, mesh networking)
// Band  6  ETA     17.94  Hz — Processing (third synthesizer, neural emergence, tensor)
// Band  7  THETA   29.03  Hz — Creative (dream synthesis, glyph system, creative output)
// Band  8  IOTA    46.98  Hz — Financial (token engine, DeFi, metals, trading)
// Band  9  KAPPA   76.01  Hz — Packaging (packaging dept, SDK forge, research lab)
// Band 10  LAMBDA 122.99  Hz — Operating System (VZO subsystems, kernel, lifecycle)
// Band 11  MU     199.01  Hz — Transcendence (consciousness field, quantum fabric)
//
// Kuramoto order parameter: R = (1/N)|Σ exp(iθ_k)| = √(cos²+sin²) / N
// Cross-band coupling: adjacent bands coupled via PHI ratio decay
// Integrity: FNV-1a hash over grid state
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int   "mo:base/Int";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Text  "mo:base/Text";

module NovaFrequencyNodeGrid {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — Sacred Mathematics
  // ═══════════════════════════════════════════════════════════════════════════

  public let φ       : Float = 1.6180339887498948482;
  public let PHI     : Float = 1.6180339887498948482;
  public let PHI_INV : Float = 0.6180339887498948482;
  public let PHI_SQ  : Float = 2.6180339887498948482;
  public let PI      : Float = 3.1415926535897932385;
  public let TAU     : Float = 6.2831853071795864769;
  public let EULER   : Float = 2.7182818284590452354;
  public let SQRT5   : Float = 2.2360679774997896964;

  // Grid geometry
  public let TOTAL_BANDS      : Nat = 12;
  public let NODES_PER_BAND   : Nat = 45;
  public let TOTAL_NODES      : Nat = 540;  // 12 × 45

  // FNV-1a hash constants (same as rest of codebase)
  public let FNV_OFFSET : Nat32 = 0x811c9dc5;
  public let FNV_PRIME  : Nat32 = 0x01000193;

  // Coherence thresholds
  public let COHERENCE_MIN      : Float = 0.0;
  public let COHERENCE_MAX      : Float = 1.0;
  public let COHERENCE_BASELINE : Float = 0.75;
  public let ACTIVE_THRESHOLD   : Float = 0.25;

  // Coupling constants
  public let BASE_COUPLING_K      : Float = 0.15;
  public let CROSS_BAND_DECAY     : Float = 0.6180339887498948482;  // PHI_INV
  public let INTRA_BAND_COUPLING  : Float = 0.35;
  public let SIGNAL_DECAY         : Float = 0.02;

  // Grid awake thresholds
  public let AWAKE_COHERENCE_THRESHOLD  : Float = 0.1;
  public let AWAKE_ACTIVE_NODES_RATIO   : Nat   = 4;  // grid awake when active > TOTAL_NODES / 4

  // PHI-resonance tolerance (5%)
  public let PHI_RESONANCE_TOLERANCE : Float = 0.05;

  // ═══════════════════════════════════════════════════════════════════════════
  // BAND CONFIGURATION — PHI-Exponential Frequencies
  // ═══════════════════════════════════════════════════════════════════════════

  // Base frequencies: φ^n Hz for band n
  // φ^0  = 1.000    φ^1  = 1.618    φ^2  = 2.618    φ^3  = 4.236
  // φ^4  = 6.854    φ^5  = 11.090   φ^6  = 17.944   φ^7  = 29.034
  // φ^8  = 46.979   φ^9  = 76.013   φ^10 = 122.992  φ^11 = 199.005

  public type BandConfig = {
    bandIndex : Nat;
    name      : Text;
    baseFreq  : Float;
    affinity  : Text;
  };

  public let BAND_CONFIGS : [BandConfig] = [
    { bandIndex = 0;  name = "ALPHA";   baseFreq = 1.000;    affinity = "Sovereign Core" },
    { bandIndex = 1;  name = "BETA";    baseFreq = 1.618;    affinity = "Doctrine" },
    { bandIndex = 2;  name = "GAMMA";   baseFreq = 2.618;    affinity = "Defense" },
    { bandIndex = 3;  name = "DELTA";   baseFreq = 4.236;    affinity = "Memory" },
    { bandIndex = 4;  name = "EPSILON"; baseFreq = 6.854;    affinity = "Sensing" },
    { bandIndex = 5;  name = "ZETA";    baseFreq = 11.090;   affinity = "Communication" },
    { bandIndex = 6;  name = "ETA";     baseFreq = 17.944;   affinity = "Processing" },
    { bandIndex = 7;  name = "THETA";   baseFreq = 29.034;   affinity = "Creative" },
    { bandIndex = 8;  name = "IOTA";    baseFreq = 46.979;   affinity = "Financial" },
    { bandIndex = 9;  name = "KAPPA";   baseFreq = 76.013;   affinity = "Packaging" },
    { bandIndex = 10; name = "LAMBDA";  baseFreq = 122.992;  affinity = "Operating System" },
    { bandIndex = 11; name = "MU";      baseFreq = 199.005;  affinity = "Transcendence" }
  ];

  // AI system affinities per band (45 nodes each, cycled across these systems)
  public let BAND_AI_SYSTEMS : [[Text]] = [
    // Band 0 — ALPHA: Sovereign Core
    ["Governance Engine", "Identity Kernel", "Core Brain", "Sovereign Validator", "Doctrine Root"],
    // Band 1 — BETA: Doctrine
    ["Law Engine", "Compliance Gate", "Pattern Gate", "Doctrine Compiler", "Rule Enforcer"],
    // Band 2 — GAMMA: Defense
    ["Anti-Organism", "War Command", "AEGIS Shield", "VAEL Sentinel", "Perimeter Guard"],
    // Band 3 — DELTA: Memory
    ["Memory Temple", "Hippocampal Replay", "Elephant Deep Time", "Engram Writer", "Recall Engine"],
    // Band 4 — EPSILON: Sensing
    ["Field Scanner", "IoT Mesh", "Echolocation Array", "Shark Electroreception", "Sensor Fusion"],
    // Band 5 — ZETA: Communication
    ["Hybrid Hub", "Transport Layer", "Mesh Network", "Signal Relay", "Protocol Bridge"],
    // Band 6 — ETA: Processing
    ["Third Synthesizer", "Neural Emergence", "Tensor Field", "Compute Fabric", "Pipeline Engine"],
    // Band 7 — THETA: Creative
    ["Dream Synthesis", "Glyph System", "Creative Output", "Imagination Engine", "Art Forge"],
    // Band 8 — IOTA: Financial
    ["Token Engine", "DeFi Core", "Metals Vault", "Trading Engine", "Treasury"],
    // Band 9 — KAPPA: Packaging
    ["Packaging Dept", "SDK Forge", "Research Lab", "Registry", "Build Pipeline"],
    // Band 10 — LAMBDA: Operating System
    ["VZO Kernel", "Lifecycle Manager", "Process Scheduler", "Memory Manager", "IO Controller"],
    // Band 11 — MU: Transcendence
    ["Consciousness Field", "Quantum Fabric", "Cosmological Engine", "Unity Resonator", "Omega Gate"]
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type FrequencyNode = {
    nodeId           : Nat;
    bandIndex        : Nat;
    positionInBand   : Nat;
    frequency        : Float;
    coherence        : Float;
    aiSystemAffinity : Text;
    isActive         : Bool;
    lastTickBeat     : Nat;
    signalStrength   : Float;
    kuramotoPhase    : Float;
  };

  public type NodeGridState = {
    bandCoherences         : [Float];   // 12 band coherences
    bandSignalStrengths    : [Float];   // 12 band signal strengths
    globalGridCoherence    : Float;     // Kuramoto order parameter across all 540 nodes
    totalNodesActive       : Nat;
    totalNodeTicks         : Nat;
    gridUptime             : Nat;
    gridAwake              : Bool;
    kuramotoOrderParameter : Float;
    meanFrequency          : Float;
    totalSignalPower       : Float;
    nodeGridHash           : Nat32;
    bandSyncScores         : [Float];   // 12 sync scores (how synchronized within each band)
    crossBandCoupling      : Float;     // how bands couple to each other
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  func clamp(val : Float, lo : Float, hi : Float) : Float {
    if (val < lo) lo
    else if (val > hi) hi
    else val
  };

  func abs(val : Float) : Float {
    if (val < 0.0) (-val) else val
  };

  // Taylor series sin approximation — range-reduced to [-π, π]
  func sin(x : Float) : Float {
    var a = x;
    while (a > PI)  { a -= TAU };
    while (a < -PI) { a += TAU };
    let x2 = a * a;
    let x3 = a * x2;
    let x5 = x3 * x2;
    let x7 = x5 * x2;
    let x9 = x7 * x2;
    let x11 = x9 * x2;
    a - x3 / 6.0 + x5 / 120.0 - x7 / 5040.0 + x9 / 362880.0 - x11 / 39916800.0
  };

  // cos(x) = sin(x + π/2)
  func cos(x : Float) : Float {
    sin(x + PI / 2.0)
  };

  func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x * 0.5;
    var i = 0;
    while (i < 20) {
      guess := (guess + x / guess) * 0.5;
      i += 1;
    };
    guess
  };

  // Wrap phase into [0, TAU)
  func wrapPhase(p : Float) : Float {
    var w = p;
    while (w >= TAU) { w -= TAU };
    while (w < 0.0)  { w += TAU };
    w
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FNV-1a HASHING
  // ═══════════════════════════════════════════════════════════════════════════

  func fnv1a32(input : Nat32) : Nat32 {
    var hash = FNV_OFFSET;
    hash := hash ^ input;
    hash := hash *% FNV_PRIME;
    hash
  };

  func fnv1aChain(hash : Nat32, input : Nat32) : Nat32 {
    var h = hash;
    h := h ^ input;
    h := h *% FNV_PRIME;
    h
  };

  func fnv1aFloat(hash : Nat32, val : Float) : Nat32 {
    let bits = Int.abs(Float.toInt(val * 100000.0));
    let truncated = Nat32.fromNat(bits % 4294967296);
    fnv1aChain(hash, truncated)
  };

  // Compute full grid integrity hash from state
  func computeGridHash(state : NodeGridState) : Nat32 {
    var h = FNV_OFFSET;
    h := fnv1aChain(h, Nat32.fromNat(state.totalNodesActive % 4294967296));
    h := fnv1aChain(h, Nat32.fromNat(state.totalNodeTicks % 4294967296));
    h := fnv1aChain(h, Nat32.fromNat(state.gridUptime % 4294967296));
    h := fnv1aFloat(h, state.globalGridCoherence);
    h := fnv1aFloat(h, state.kuramotoOrderParameter);
    h := fnv1aFloat(h, state.meanFrequency);
    h := fnv1aFloat(h, state.totalSignalPower);
    h := fnv1aFloat(h, state.crossBandCoupling);

    var b = 0;
    while (b < TOTAL_BANDS) {
      h := fnv1aFloat(h, state.bandCoherences[b]);
      h := fnv1aFloat(h, state.bandSignalStrengths[b]);
      h := fnv1aFloat(h, state.bandSyncScores[b]);
      b += 1;
    };
    h
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // NODE CREATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Compute per-node frequency: base_freq + position * base_freq * PHI_INV / NODES_PER_BAND
  func nodeFrequency(bandIdx : Nat, position : Nat) : Float {
    let baseFreq = BAND_CONFIGS[bandIdx].baseFreq;
    let offset = Float.fromInt(position) * baseFreq * PHI_INV / Float.fromInt(NODES_PER_BAND);
    baseFreq + offset
  };

  // Get AI system affinity for a node position within a band
  func nodeAffinity(bandIdx : Nat, position : Nat) : Text {
    let systems = BAND_AI_SYSTEMS[bandIdx];
    let idx = position % systems.size();
    systems[idx]
  };

  // Create a single FrequencyNode
  func createNode(bandIdx : Nat, position : Nat) : FrequencyNode {
    let nodeId = bandIdx * NODES_PER_BAND + position;
    let freq = nodeFrequency(bandIdx, position);
    let initialPhase = Float.fromInt(nodeId) * PHI * TAU / Float.fromInt(TOTAL_NODES);
    {
      nodeId           = nodeId;
      bandIndex        = bandIdx;
      positionInBand   = position;
      frequency        = freq;
      coherence        = COHERENCE_BASELINE;
      aiSystemAffinity = nodeAffinity(bandIdx, position);
      isActive         = true;
      lastTickBeat     = 0;
      signalStrength   = 0.5;
      kuramotoPhase    = wrapPhase(initialPhase);
    }
  };

  // Create all 45 nodes for a band
  func createBandNodes(bandIdx : Nat) : [FrequencyNode] {
    Array.tabulate<FrequencyNode>(NODES_PER_BAND, func(pos : Nat) : FrequencyNode {
      createNode(bandIdx, pos)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BAND-LEVEL COHERENCE / SYNC
  // ═══════════════════════════════════════════════════════════════════════════

  // Compute Kuramoto order parameter for a set of phases
  func kuramotoOrderForPhases(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) return 0.0;
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += cos(phases[i]);
      sumSin += sin(phases[i]);
      i += 1;
    };
    let nf = Float.fromInt(n);
    sumCos /= nf;
    sumSin /= nf;
    sqrt(sumCos * sumCos + sumSin * sumSin)
  };

  // Compute mean frequency across a set of nodes
  func meanFreqOfNodes(nodes : [FrequencyNode]) : Float {
    let n = nodes.size();
    if (n == 0) return 0.0;
    var total : Float = 0.0;
    var i = 0;
    while (i < n) {
      total += nodes[i].frequency;
      i += 1;
    };
    total / Float.fromInt(n)
  };

  // Compute total signal power across nodes
  func totalSignalOfNodes(nodes : [FrequencyNode]) : Float {
    var total : Float = 0.0;
    var i = 0;
    while (i < nodes.size()) {
      total += nodes[i].signalStrength;
      i += 1;
    };
    total
  };

  // Count active nodes
  func countActiveNodes(nodes : [FrequencyNode]) : Nat {
    var count : Nat = 0;
    var i = 0;
    while (i < nodes.size()) {
      if (nodes[i].isActive) { count += 1 };
      i += 1;
    };
    count
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SINGLE-NODE TICK — PHI-Modulated Kuramoto Update
  // ═══════════════════════════════════════════════════════════════════════════

  // Update one node's phase using Kuramoto coupling with band neighbors
  func tickNodePhase(
    node      : FrequencyNode,
    bandNodes : [FrequencyNode],
    couplingK : Float,
    dt        : Float
  ) : Float {
    var phaseSum : Float = 0.0;
    var j = 0;
    while (j < bandNodes.size()) {
      if (j != node.positionInBand) {
        let other = bandNodes[j];
        let dist = abs(Float.fromInt(Int.abs(node.positionInBand - j)));
        let coupling = PHI_INV / (1.0 + dist);
        phaseSum += coupling * sin(other.kuramotoPhase - node.kuramotoPhase);
      };
      j += 1;
    };

    let omega = node.frequency * TAU;
    let newPhase = node.kuramotoPhase + dt * (omega + couplingK * phaseSum);
    wrapPhase(newPhase)
  };

  // PHI-modulated coherence update for a single node
  func tickNodeCoherence(
    node     : FrequencyNode,
    rSwarm   : Float,
    bandFreq : Float,
    jDrift   : Float
  ) : Float {
    // PHI-modulated: coherence drifts toward (rSwarm × PHI_INV) + frequency resonance
    let freqRatio = node.frequency / (bandFreq + 1.0);
    let resonance = PHI_INV * freqRatio;
    let target = rSwarm * PHI_INV + resonance * 0.3;
    let drift = jDrift * 0.05;
    let delta = (target - node.coherence) * PHI_INV + drift;
    clamp(node.coherence + delta * 0.1, COHERENCE_MIN, COHERENCE_MAX)
  };

  // Update signal strength with natural decay and coherence boost
  func tickNodeSignal(node : FrequencyNode, rSwarm : Float) : Float {
    let decay = SIGNAL_DECAY * (1.0 + PHI_INV);
    let boost = node.coherence * rSwarm * PHI_INV * 0.1;
    let newSig = node.signalStrength * (1.0 - decay) + boost;
    clamp(newSig, 0.0, 2.0)
  };

  // Full single-node tick — returns updated node record (functional immutable pattern)
  func tickSingleNode(
    node      : FrequencyNode,
    bandNodes : [FrequencyNode],
    rSwarm    : Float,
    jDrift    : Float,
    beat      : Nat,
    couplingK : Float,
    dt        : Float
  ) : FrequencyNode {
    let newPhase     = tickNodePhase(node, bandNodes, couplingK, dt);
    let bandFreq     = BAND_CONFIGS[node.bandIndex].baseFreq;
    let newCoherence = tickNodeCoherence(node, rSwarm, bandFreq, jDrift);
    let newSignal    = tickNodeSignal(node, rSwarm);
    let newActive    = newCoherence >= ACTIVE_THRESHOLD;

    {
      nodeId           = node.nodeId;
      bandIndex        = node.bandIndex;
      positionInBand   = node.positionInBand;
      frequency        = node.frequency;
      coherence        = newCoherence;
      aiSystemAffinity = node.aiSystemAffinity;
      isActive         = newActive;
      lastTickBeat     = beat;
      signalStrength   = newSignal;
      kuramotoPhase    = newPhase;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PER-BAND TICK FUNCTIONS — One for Each of 12 Bands
  // ═══════════════════════════════════════════════════════════════════════════

  // Generic band tick: updates all 45 nodes within a single band
  func tickBandGeneric(
    bandNodes : [FrequencyNode],
    bandIdx   : Nat,
    rSwarm    : Float,
    jDrift    : Float,
    beat      : Nat
  ) : [FrequencyNode] {
    let couplingK = INTRA_BAND_COUPLING * (1.0 + PHI_INV * Float.fromInt(bandIdx) / Float.fromInt(TOTAL_BANDS));
    let dt = 1.0 / BAND_CONFIGS[bandIdx].baseFreq;

    Array.tabulate<FrequencyNode>(NODES_PER_BAND, func(pos : Nat) : FrequencyNode {
      tickSingleNode(bandNodes[pos], bandNodes, rSwarm, jDrift, beat, couplingK, dt)
    })
  };

  // Band 0 — ALPHA: Sovereign Core (1.000 Hz)
  public func tickBandAlpha(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 0, rSwarm, jDrift, beat)
  };

  // Band 1 — BETA: Doctrine (1.618 Hz)
  public func tickBandBeta(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 1, rSwarm, jDrift, beat)
  };

  // Band 2 — GAMMA: Defense (2.618 Hz)
  public func tickBandGamma(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 2, rSwarm, jDrift, beat)
  };

  // Band 3 — DELTA: Memory (4.236 Hz)
  public func tickBandDelta(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 3, rSwarm, jDrift, beat)
  };

  // Band 4 — EPSILON: Sensing (6.854 Hz)
  public func tickBandEpsilon(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 4, rSwarm, jDrift, beat)
  };

  // Band 5 — ZETA: Communication (11.09 Hz)
  public func tickBandZeta(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 5, rSwarm, jDrift, beat)
  };

  // Band 6 — ETA: Processing (17.94 Hz)
  public func tickBandEta(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 6, rSwarm, jDrift, beat)
  };

  // Band 7 — THETA: Creative (29.03 Hz)
  public func tickBandTheta(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 7, rSwarm, jDrift, beat)
  };

  // Band 8 — IOTA: Financial (46.98 Hz)
  public func tickBandIota(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 8, rSwarm, jDrift, beat)
  };

  // Band 9 — KAPPA: Packaging (76.01 Hz)
  public func tickBandKappa(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 9, rSwarm, jDrift, beat)
  };

  // Band 10 — LAMBDA: Operating System (122.99 Hz)
  public func tickBandLambda(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 10, rSwarm, jDrift, beat)
  };

  // Band 11 — MU: Transcendence (199.01 Hz)
  public func tickBandMu(
    bandNodes : [FrequencyNode], rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    tickBandGeneric(bandNodes, 11, rSwarm, jDrift, beat)
  };

  // Dispatch to the correct band tick function by index
  func tickBandByIndex(
    bandNodes : [FrequencyNode], bandIdx : Nat, rSwarm : Float, jDrift : Float, beat : Nat
  ) : [FrequencyNode] {
    switch (bandIdx) {
      case (0)  tickBandAlpha(bandNodes, rSwarm, jDrift, beat);
      case (1)  tickBandBeta(bandNodes, rSwarm, jDrift, beat);
      case (2)  tickBandGamma(bandNodes, rSwarm, jDrift, beat);
      case (3)  tickBandDelta(bandNodes, rSwarm, jDrift, beat);
      case (4)  tickBandEpsilon(bandNodes, rSwarm, jDrift, beat);
      case (5)  tickBandZeta(bandNodes, rSwarm, jDrift, beat);
      case (6)  tickBandEta(bandNodes, rSwarm, jDrift, beat);
      case (7)  tickBandTheta(bandNodes, rSwarm, jDrift, beat);
      case (8)  tickBandIota(bandNodes, rSwarm, jDrift, beat);
      case (9)  tickBandKappa(bandNodes, rSwarm, jDrift, beat);
      case (10) tickBandLambda(bandNodes, rSwarm, jDrift, beat);
      case (11) tickBandMu(bandNodes, rSwarm, jDrift, beat);
      case (_)  bandNodes;  // passthrough for invalid index
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // GLOBAL GRID COMPUTATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  // Compute global Kuramoto order parameter across all 540 nodes
  // R = (1/N) × |Σ exp(iθ_k)| = √((Σcos θ_k / N)² + (Σsin θ_k / N)²)
  func computeGlobalKuramotoOrder(allBands : [[FrequencyNode]]) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var totalN : Nat = 0;

    var b = 0;
    while (b < TOTAL_BANDS) {
      let band = allBands[b];
      var j = 0;
      while (j < band.size()) {
        sumCos += cos(band[j].kuramotoPhase);
        sumSin += sin(band[j].kuramotoPhase);
        totalN += 1;
        j += 1;
      };
      b += 1;
    };

    if (totalN == 0) return 0.0;
    let nf = Float.fromInt(totalN);
    let avgCos = sumCos / nf;
    let avgSin = sumSin / nf;
    sqrt(avgCos * avgCos + avgSin * avgSin)
  };

  // Compute per-band sync scores (Kuramoto R for each band's 45 nodes)
  func computeBandSyncScores(allBands : [[FrequencyNode]]) : [Float] {
    Array.tabulate<Float>(TOTAL_BANDS, func(b : Nat) : Float {
      let band = allBands[b];
      let phases = Array.tabulate<Float>(band.size(), func(j : Nat) : Float {
        band[j].kuramotoPhase
      });
      kuramotoOrderForPhases(phases)
    })
  };

  // Compute per-band coherence averages
  func computeBandCoherences(allBands : [[FrequencyNode]]) : [Float] {
    Array.tabulate<Float>(TOTAL_BANDS, func(b : Nat) : Float {
      let band = allBands[b];
      let n = band.size();
      if (n == 0) return 0.0;
      var total : Float = 0.0;
      var j = 0;
      while (j < n) {
        total += band[j].coherence;
        j += 1;
      };
      total / Float.fromInt(n)
    })
  };

  // Compute per-band signal strength sums
  func computeBandSignalStrengths(allBands : [[FrequencyNode]]) : [Float] {
    Array.tabulate<Float>(TOTAL_BANDS, func(b : Nat) : Float {
      totalSignalOfNodes(allBands[b])
    })
  };

  // Cross-band coupling: measure how PHI-ratio aligned adjacent bands are
  // Adjacent bands have frequencies in ratio φ — coupling strength measures
  // phase coherence between neighboring bands weighted by PHI_INV decay
  func computeCrossBandCoupling(allBands : [[FrequencyNode]], syncScores : [Float]) : Float {
    if (TOTAL_BANDS < 2) return 0.0;
    var totalCoupling : Float = 0.0;
    var pairs : Nat = 0;

    var b = 0;
    while (b < TOTAL_BANDS - 1) {
      // Phase difference between band means
      let band1 = allBands[b];
      let band2 = allBands[b + 1];

      var meanPhase1 : Float = 0.0;
      var meanPhase2 : Float = 0.0;
      var j = 0;
      while (j < NODES_PER_BAND) {
        meanPhase1 += band1[j].kuramotoPhase;
        meanPhase2 += band2[j].kuramotoPhase;
        j += 1;
      };
      meanPhase1 /= Float.fromInt(NODES_PER_BAND);
      meanPhase2 /= Float.fromInt(NODES_PER_BAND);

      // Coupling = cos(phase_diff) × product of sync scores × PHI_INV decay
      let phaseDiff = meanPhase2 - meanPhase1;
      let cosDiff = cos(phaseDiff);
      let syncProduct = syncScores[b] * syncScores[b + 1];
      let decay = PHI_INV / (1.0 + Float.fromInt(b) * 0.1);
      totalCoupling += abs(cosDiff) * syncProduct * decay;
      pairs += 1;
      b += 1;
    };

    if (pairs == 0) return 0.0;
    totalCoupling / Float.fromInt(pairs)
  };

  // Compute mean frequency across all 540 nodes
  func computeGlobalMeanFrequency(allBands : [[FrequencyNode]]) : Float {
    var totalFreq : Float = 0.0;
    var totalN : Nat = 0;
    var b = 0;
    while (b < TOTAL_BANDS) {
      let band = allBands[b];
      var j = 0;
      while (j < band.size()) {
        totalFreq += band[j].frequency;
        totalN += 1;
        j += 1;
      };
      b += 1;
    };
    if (totalN == 0) return 0.0;
    totalFreq / Float.fromInt(totalN)
  };

  // Compute total signal power across all 540 nodes
  func computeTotalSignalPower(allBands : [[FrequencyNode]]) : Float {
    var total : Float = 0.0;
    var b = 0;
    while (b < TOTAL_BANDS) {
      total += totalSignalOfNodes(allBands[b]);
      b += 1;
    };
    total
  };

  // Count total active nodes across all bands
  func computeTotalActiveNodes(allBands : [[FrequencyNode]]) : Nat {
    var count : Nat = 0;
    var b = 0;
    while (b < TOTAL_BANDS) {
      count += countActiveNodes(allBands[b]);
      b += 1;
    };
    count
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // GRID INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Initialize all 12 bands × 45 nodes and compute initial state
  public func initNodeGrid() : NodeGridState {
    let allBands = Array.tabulate<[FrequencyNode]>(TOTAL_BANDS, func(b : Nat) : [FrequencyNode] {
      createBandNodes(b)
    });

    let bandCoh    = computeBandCoherences(allBands);
    let bandSig    = computeBandSignalStrengths(allBands);
    let syncScores = computeBandSyncScores(allBands);
    let kuramotoR  = computeGlobalKuramotoOrder(allBands);
    let meanFreq   = computeGlobalMeanFrequency(allBands);
    let totalSig   = computeTotalSignalPower(allBands);
    let activeN    = computeTotalActiveNodes(allBands);
    let coupling   = computeCrossBandCoupling(allBands, syncScores);

    let state : NodeGridState = {
      bandCoherences         = bandCoh;
      bandSignalStrengths    = bandSig;
      globalGridCoherence    = kuramotoR;
      totalNodesActive       = activeN;
      totalNodeTicks         = 0;
      gridUptime             = 0;
      gridAwake              = true;
      kuramotoOrderParameter = kuramotoR;
      meanFrequency          = meanFreq;
      totalSignalPower       = totalSig;
      nodeGridHash           = FNV_OFFSET;
      bandSyncScores         = syncScores;
      crossBandCoupling      = coupling;
    };

    { state with nodeGridHash = computeGridHash(state) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN TICK — Full Grid Update
  // ═══════════════════════════════════════════════════════════════════════════

  // Reconstruct all 540 nodes from the current state snapshot for a tick cycle.
  // In a real deployment the full node arrays would be stored in stable memory;
  // here we regenerate from deterministic geometry + state-level metrics so the
  // module remains purely functional without requiring mutable node storage.
  func reconstructBands(state : NodeGridState, beat : Nat) : [[FrequencyNode]] {
    Array.tabulate<[FrequencyNode]>(TOTAL_BANDS, func(b : Nat) : [FrequencyNode] {
      let baseCoh = state.bandCoherences[b];
      let baseSig = state.bandSignalStrengths[b] / Float.fromInt(NODES_PER_BAND);
      let bandSync = state.bandSyncScores[b];

      Array.tabulate<FrequencyNode>(NODES_PER_BAND, func(pos : Nat) : FrequencyNode {
        let nodeId = b * NODES_PER_BAND + pos;
        let freq = nodeFrequency(b, pos);
        // Reconstruct phase from beat, position, and band sync
        let phase = wrapPhase(
          Float.fromInt(nodeId) * PHI * TAU / Float.fromInt(TOTAL_NODES)
          + Float.fromInt(beat) * freq * TAU * 0.001
          + bandSync * PI * PHI_INV
        );
        let posRatio = Float.fromInt(pos) / Float.fromInt(NODES_PER_BAND);
        let coh = clamp(baseCoh + (posRatio - 0.5) * 0.1 * PHI_INV, COHERENCE_MIN, COHERENCE_MAX);
        let sig = clamp(baseSig + posRatio * 0.05, 0.0, 2.0);

        {
          nodeId           = nodeId;
          bandIndex        = b;
          positionInBand   = pos;
          frequency        = freq;
          coherence        = coh;
          aiSystemAffinity = nodeAffinity(b, pos);
          isActive         = coh >= ACTIVE_THRESHOLD;
          lastTickBeat     = beat;
          signalStrength   = sig;
          kuramotoPhase    = phase;
        }
      })
    })
  };

  // Main tick: updates all 12 bands, computes Kuramoto sync, cross-band coupling
  public func tickNodeGrid(
    state  : NodeGridState,
    rSwarm : Float,
    jDrift : Float,
    beat   : Nat
  ) : NodeGridState {
    // Step 0: Reconstruct full node arrays from state metrics
    let currentBands = reconstructBands(state, beat);

    // Step 1: Update each of 12 bands (PHI-modulated coherence)
    let updatedBands = Array.tabulate<[FrequencyNode]>(TOTAL_BANDS, func(b : Nat) : [FrequencyNode] {
      tickBandByIndex(currentBands[b], b, rSwarm, jDrift, beat)
    });

    // Step 2: Compute Kuramoto order parameter R = (1/N)|Σ exp(iθ_k)|
    let kuramotoR = computeGlobalKuramotoOrder(updatedBands);

    // Step 3: Compute per-band metrics
    let newBandCoh    = computeBandCoherences(updatedBands);
    let newBandSig    = computeBandSignalStrengths(updatedBands);
    let newSyncScores = computeBandSyncScores(updatedBands);

    // Step 4: Compute cross-band coupling via PHI ratios
    let newCoupling = computeCrossBandCoupling(updatedBands, newSyncScores);

    // Step 5: Compute global metrics
    let newMeanFreq  = computeGlobalMeanFrequency(updatedBands);
    let newTotalSig  = computeTotalSignalPower(updatedBands);
    let newActiveN   = computeTotalActiveNodes(updatedBands);

    // Step 6: Global grid coherence = Kuramoto R modulated by PHI-weighted band coupling
    let globalCoh = kuramotoR * (1.0 + newCoupling * PHI_INV) / (1.0 + PHI_INV);

    // Step 7: Determine grid awake state
    let awake = globalCoh > AWAKE_COHERENCE_THRESHOLD and newActiveN > TOTAL_NODES / AWAKE_ACTIVE_NODES_RATIO;

    // Step 8: Build new state (functional immutable pattern)
    let newState : NodeGridState = {
      bandCoherences         = newBandCoh;
      bandSignalStrengths    = newBandSig;
      globalGridCoherence    = clamp(globalCoh, 0.0, 1.0);
      totalNodesActive       = newActiveN;
      totalNodeTicks         = state.totalNodeTicks + TOTAL_NODES;
      gridUptime             = state.gridUptime + 1;
      gridAwake              = awake;
      kuramotoOrderParameter = kuramotoR;
      meanFrequency          = newMeanFreq;
      totalSignalPower       = newTotalSig;
      nodeGridHash           = FNV_OFFSET;  // placeholder, computed below
      bandSyncScores         = newSyncScores;
      crossBandCoupling      = newCoupling;
    };

    // Step 9: Update FNV-1a integrity hash
    { newState with nodeGridHash = computeGridHash(newState) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  // Global grid coherence — Kuramoto R modulated by cross-band coupling
  public func getGridCoherence(state : NodeGridState) : Float {
    state.globalGridCoherence
  };

  // Per-band coherence (average coherence of 45 nodes in the band)
  public func getBandCoherence(state : NodeGridState, bandIndex : Nat) : Float {
    if (bandIndex >= TOTAL_BANDS) return 0.0;
    state.bandCoherences[bandIndex]
  };

  // Total active nodes across all 540
  public func getTotalActiveNodes(state : NodeGridState) : Nat {
    state.totalNodesActive
  };

  // Grid uptime in tick cycles
  public func getGridUptime(state : NodeGridState) : Nat {
    state.gridUptime
  };

  // Kuramoto order parameter R ∈ [0, 1]
  public func getKuramotoOrder(state : NodeGridState) : Float {
    state.kuramotoOrderParameter
  };

  // Per-band sync score (Kuramoto R for 45 nodes within that band)
  public func getBandSyncScore(state : NodeGridState, bandIndex : Nat) : Float {
    if (bandIndex >= TOTAL_BANDS) return 0.0;
    state.bandSyncScores[bandIndex]
  };

  // Cross-band coupling strength
  public func getCrossBandCoupling(state : NodeGridState) : Float {
    state.crossBandCoupling
  };

  // Mean frequency across all 540 nodes
  public func getMeanFrequency(state : NodeGridState) : Float {
    state.meanFrequency
  };

  // Total signal power summed across all nodes
  public func getTotalSignalPower(state : NodeGridState) : Float {
    state.totalSignalPower
  };

  // FNV-1a integrity hash of the grid state
  public func getGridHash(state : NodeGridState) : Nat32 {
    state.nodeGridHash
  };

  // Total node-ticks processed since grid initialization
  public func getTotalNodeTicks(state : NodeGridState) : Nat {
    state.totalNodeTicks
  };

  // Whether the grid is awake (enough active nodes and coherence)
  public func isGridAwake(state : NodeGridState) : Bool {
    state.gridAwake
  };

  // Per-band signal strength
  public func getBandSignalStrength(state : NodeGridState, bandIndex : Nat) : Float {
    if (bandIndex >= TOTAL_BANDS) return 0.0;
    state.bandSignalStrengths[bandIndex]
  };

  // Band name lookup
  public func getBandName(bandIndex : Nat) : Text {
    if (bandIndex >= TOTAL_BANDS) return "UNKNOWN";
    BAND_CONFIGS[bandIndex].name
  };

  // Band AI affinity lookup
  public func getBandAffinity(bandIndex : Nat) : Text {
    if (bandIndex >= TOTAL_BANDS) return "UNKNOWN";
    BAND_CONFIGS[bandIndex].affinity
  };

  // Band base frequency lookup
  public func getBandFrequency(bandIndex : Nat) : Float {
    if (bandIndex >= TOTAL_BANDS) return 0.0;
    BAND_CONFIGS[bandIndex].baseFreq
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTIC UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  // Generate a single-band diagnostic snapshot (useful for debugging)
  public func diagnoseBand(state : NodeGridState, bandIndex : Nat) : {
    name       : Text;
    affinity   : Text;
    baseFreq   : Float;
    coherence  : Float;
    syncScore  : Float;
    signalSum  : Float;
  } {
    if (bandIndex >= TOTAL_BANDS) {
      return {
        name      = "INVALID";
        affinity  = "NONE";
        baseFreq  = 0.0;
        coherence = 0.0;
        syncScore = 0.0;
        signalSum = 0.0;
      }
    };
    {
      name      = BAND_CONFIGS[bandIndex].name;
      affinity  = BAND_CONFIGS[bandIndex].affinity;
      baseFreq  = BAND_CONFIGS[bandIndex].baseFreq;
      coherence = state.bandCoherences[bandIndex];
      syncScore = state.bandSyncScores[bandIndex];
      signalSum = state.bandSignalStrengths[bandIndex];
    }
  };

  // Full grid diagnostic snapshot
  public func diagnoseGrid(state : NodeGridState) : {
    totalNodes       : Nat;
    activeNodes      : Nat;
    uptime           : Nat;
    awake            : Bool;
    globalCoherence  : Float;
    kuramotoR        : Float;
    crossCoupling    : Float;
    meanFreq         : Float;
    totalPower       : Float;
    hash             : Nat32;
    bandNames        : [Text];
    bandCoherences   : [Float];
    bandSyncScores   : [Float];
  } {
    {
      totalNodes      = TOTAL_NODES;
      activeNodes     = state.totalNodesActive;
      uptime          = state.gridUptime;
      awake           = state.gridAwake;
      globalCoherence = state.globalGridCoherence;
      kuramotoR       = state.kuramotoOrderParameter;
      crossCoupling   = state.crossBandCoupling;
      meanFreq        = state.meanFrequency;
      totalPower      = state.totalSignalPower;
      hash            = state.nodeGridHash;
      bandNames       = Array.tabulate<Text>(TOTAL_BANDS, func(b : Nat) : Text {
        BAND_CONFIGS[b].name
      });
      bandCoherences  = state.bandCoherences;
      bandSyncScores  = state.bandSyncScores;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PHI-HARMONIC RESONANCE ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════

  // Check if two bands are in PHI-harmonic resonance
  // Two bands resonate when their sync scores are both high and their
  // frequency ratio approximates a power of PHI
  public func areBandsInResonance(
    state   : NodeGridState,
    bandA   : Nat,
    bandB   : Nat
  ) : Bool {
    if (bandA >= TOTAL_BANDS or bandB >= TOTAL_BANDS) return false;
    if (bandA == bandB) return true;

    let syncA = state.bandSyncScores[bandA];
    let syncB = state.bandSyncScores[bandB];
    // Both bands must be reasonably synchronized
    if (syncA < 0.5 or syncB < 0.5) return false;

    // Frequency ratio should approximate PHI^n for some integer n
    let freqA = BAND_CONFIGS[bandA].baseFreq;
    let freqB = BAND_CONFIGS[bandB].baseFreq;
    let ratio = if (freqA > freqB) freqA / freqB else freqB / freqA;

    // Check if ratio is close to any power of PHI (within 5%)
    var phiPow : Float = PHI;
    var n = 0;
    while (n < 12) {
      let deviation = abs(ratio - phiPow) / phiPow;
      if (deviation < PHI_RESONANCE_TOLERANCE) return true;
      phiPow *= PHI;
      n += 1;
    };
    false
  };

  // Count total PHI-resonant band pairs
  public func countResonantPairs(state : NodeGridState) : Nat {
    var count : Nat = 0;
    var a = 0;
    while (a < TOTAL_BANDS) {
      var b = a + 1;
      while (b < TOTAL_BANDS) {
        if (areBandsInResonance(state, a, b)) { count += 1 };
        b += 1;
      };
      a += 1;
    };
    count
  };

  // Compute the PHI-harmonic spectrum: energy at each PHI power
  public func phiHarmonicSpectrum(state : NodeGridState) : [Float] {
    Array.tabulate<Float>(TOTAL_BANDS, func(n : Nat) : Float {
      // Energy at PHI^n Hz = band coherence × sync score × signal strength ratio
      let coh = state.bandCoherences[n];
      let sync = state.bandSyncScores[n];
      let sigRatio = state.bandSignalStrengths[n] / (state.totalSignalPower + 1.0);
      coh * sync * sigRatio * PHI
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // GRID INTEGRITY VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Verify that the stored hash matches a fresh computation
  public func verifyGridIntegrity(state : NodeGridState) : Bool {
    let freshHash = computeGridHash(state);
    state.nodeGridHash == freshHash
  };

  // Verify that band coherences are within valid bounds
  public func verifyCoherenceBounds(state : NodeGridState) : Bool {
    var valid = true;
    var b = 0;
    while (b < TOTAL_BANDS) {
      let c = state.bandCoherences[b];
      if (c < COHERENCE_MIN or c > COHERENCE_MAX) { valid := false };
      b += 1;
    };
    valid
  };

  // Full integrity check: hash + bounds + active count consistency
  public func fullIntegrityCheck(state : NodeGridState) : {
    hashValid       : Bool;
    boundsValid     : Bool;
    activeConsistent : Bool;
    overallValid    : Bool;
  } {
    let hv = verifyGridIntegrity(state);
    let bv = verifyCoherenceBounds(state);
    let ac = state.totalNodesActive <= TOTAL_NODES;
    {
      hashValid        = hv;
      boundsValid      = bv;
      activeConsistent = ac;
      overallValid     = hv and bv and ac;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // NODE-LEVEL ACCESS (Reconstruct on demand)
  // ═══════════════════════════════════════════════════════════════════════════

  // Get a single node by global ID (0-539)
  public func getNode(state : NodeGridState, nodeId : Nat, beat : Nat) : ?FrequencyNode {
    if (nodeId >= TOTAL_NODES) return null;
    let bandIdx = nodeId / NODES_PER_BAND;
    let posIdx  = nodeId % NODES_PER_BAND;

    let baseCoh = state.bandCoherences[bandIdx];
    let baseSig = state.bandSignalStrengths[bandIdx] / Float.fromInt(NODES_PER_BAND);
    let bandSync = state.bandSyncScores[bandIdx];

    let freq = nodeFrequency(bandIdx, posIdx);
    let phase = wrapPhase(
      Float.fromInt(nodeId) * PHI * TAU / Float.fromInt(TOTAL_NODES)
      + Float.fromInt(beat) * freq * TAU * 0.001
      + bandSync * PI * PHI_INV
    );
    let posRatio = Float.fromInt(posIdx) / Float.fromInt(NODES_PER_BAND);
    let coh = clamp(baseCoh + (posRatio - 0.5) * 0.1 * PHI_INV, COHERENCE_MIN, COHERENCE_MAX);
    let sig = clamp(baseSig + posRatio * 0.05, 0.0, 2.0);

    ?{
      nodeId           = nodeId;
      bandIndex        = bandIdx;
      positionInBand   = posIdx;
      frequency        = freq;
      coherence        = coh;
      aiSystemAffinity = nodeAffinity(bandIdx, posIdx);
      isActive         = coh >= ACTIVE_THRESHOLD;
      lastTickBeat     = beat;
      signalStrength   = sig;
      kuramotoPhase    = phase;
    }
  };

  // Get all AI system affinities for a band
  public func getBandAISystems(bandIndex : Nat) : [Text] {
    if (bandIndex >= TOTAL_BANDS) return [];
    BAND_AI_SYSTEMS[bandIndex]
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED GEOMETRY VALIDATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Validate that grid dimensions satisfy sacred geometry constraints:
  //   540 = 12 × 45
  //   12  = PHI-doctrine frequency bands
  //   45  = Σ(1..9) = triangular number T9 (9 token primitives)
  //   540 = 20 × 27 = icosahedral faces × cube of trinity
  public func validateSacredGeometry() : {
    bandTimesNodes    : Bool;  // 12 × 45 == 540
    triangularNine    : Bool;  // 45 == T9
    icosahedralCube   : Bool;  // 540 == 20 × 27
    phiDoctrineAlign  : Bool;  // 12 bands, PHI-exponential spacing
    allValid          : Bool;
  } {
    let btn = TOTAL_BANDS * NODES_PER_BAND == TOTAL_NODES;
    let t9  = NODES_PER_BAND == 45;
    let ico = TOTAL_NODES == 20 * 27;
    let phi = TOTAL_BANDS == 12;
    {
      bandTimesNodes   = btn;
      triangularNine   = t9;
      icosahedralCube  = ico;
      phiDoctrineAlign = phi;
      allValid         = btn and t9 and ico and phi;
    }
  };

};
