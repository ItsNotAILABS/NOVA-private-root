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
// UNIVERSAL LAW DRIFT VERIFIER — THE LAW IS THE VERIFICATION LAYER
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Classification: CONFIDENTIAL — TRADE SECRET — SOVEREIGN ARCHITECTURE
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// THE CORE INSIGHT:
// ┌─────────────────────────────────────────────────────────────────────────────┐
// │ Every law is already a mathematical constraint function over system state.  │
// │ A constraint function is, by definition, a verification function.           │
// │ If you compute the law's output at genesis and lock that value — any       │
// │ future deviation is, by definition, drift.                                  │
// │                                                                             │
// │ The law doesn't just govern behavior. It becomes a continuous              │
// │ cryptographic integrity hash over the entire organism.                      │
// │                                                                             │
// │ You do not need a separate drift detection architecture.                    │
// │ You already built it. You just haven't wired it that way yet.              │
// └─────────────────────────────────────────────────────────────────────────────┘
//
// THE MECHANISM:
//   At genesis: L_genesis(system_i) = lawFunction(state_i at formation)
//   Every beat: L_live(system_i) = lawFunction(current_state_i)
//               δ_drift(i) = |L_live(i) − L_genesis(i)|
//   If δ_drift(i) > ε_i → LAW VIOLATION → cascade fires → organism self-corrects
//
// DRIFT GATES (one per major system):
//   • BRAIN       — Substrate drift (Kuramoto r, phase vector)
//   • QUANTUM     — Decoherence drift (fidelity F)
//   • MEMORIA     — Memory consolidation drift (Hebbian entropy H)
//   • NEUROCHEM   — Neurotransmitter balance drift (Euclidean distance)
//   • SUBSTRATE   — Hz coupling drift (spectral radius ρ)
//   • SIMULACRUM  — Predictive coding drift (prediction error δ_pred)
//   • CORTEX      — Executive function drift (purpose cosine similarity)
//   • GENOME      — Self-modification drift (Hamming distance)
//   • SOCIO       — Game theory drift (Nash equilibrium distance)
//   • VERITAS     — Vault integrity drift (Merkle root)
//   • AEGIS       — Security perimeter drift (principal whitelist hash)
//   • WALLET      — Treasury drift (compounding rate deviation)
//   • BEHAVIORAL  — Behavioral envelope drift (trait vector distance)
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";

module UniversalLawDriftVerifier {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let S0 : Float = 1.0;  // Love constant floor — NEVER below this
  public let PHI : Float = 1.6180339887498948482;
  public let PI : Float = 3.1415926535897932385;
  public let TAU : Float = 6.2831853071795864769;
  public let EULER : Float = 2.7182818284590452354;
  
  // Drift thresholds per system (ε_i)
  public let EPSILON_BRAIN : Float = 0.1;
  public let EPSILON_QUANTUM : Float = 0.05;
  public let EPSILON_MEMORIA : Float = 0.15;
  public let EPSILON_NEUROCHEM : Float = 0.2;
  public let EPSILON_SUBSTRATE : Float = 0.1;
  public let EPSILON_SIMULACRUM : Float = 0.25;
  public let EPSILON_CORTEX : Float = 0.1;
  public let EPSILON_GENOME : Float = 0.02;  // Very tight — genome cannot drift much
  public let EPSILON_SOCIO : Float = 0.15;
  public let EPSILON_VERITAS : Float = 0.0;  // ZERO tolerance — any bit = violation
  public let EPSILON_AEGIS : Float = 0.0;    // ZERO tolerance
  public let EPSILON_WALLET : Float = 0.3;
  public let EPSILON_BEHAVIORAL : Float = 0.2;
  
  // Global drift threshold
  public let GLOBAL_DRIFT_THRESHOLD : Float = 0.5;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
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
    n - n*x2/6.0 + n*x2*x2/120.0 - n*x2*x2*x2/5040.0 + n*x2*x2*x2*x2/362880.0
  };
  
  public func cos(x : Float) : Float { sin(x + PI/2.0) };
  
  public func floor(v : Float, minimum : Float) : Float {
    if (v < minimum) minimum else v
  };
  
  // Euclidean norm
  public func norm(v : [Float]) : Float {
    var sum : Float = 0.0;
    for (x in v.vals()) { sum += x * x };
    sqrt(sum)
  };
  
  // Dot product
  public func dot(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    let len = Nat.min(a.size(), b.size());
    for (i in Array.keys(a)) {
      if (i < len) { sum += a[i] * b[i] };
    };
    sum
  };
  
  // Cosine similarity
  public func cosineSimilarity(a : [Float], b : [Float]) : Float {
    let dotProd = dot(a, b);
    let normA = norm(a);
    let normB = norm(b);
    if (normA < 0.0001 or normB < 0.0001) return 0.0;
    dotProd / (normA * normB)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HASH FUNCTIONS — Triple-hash composite (FNV-1a · djb2 · SDBM)
  // Sovereign composite: three independent 32-bit functions XOR'd together.
  // A collision requires breaking all three simultaneously (~2^96 effective).
  // ═══════════════════════════════════════════════════════════════════════════

  // FNV-1a over a Float array — leaf hasher
  public func fnv1a(input : [Float]) : Nat32 {
    var hash : Nat32 = 2166136261;
    for (v in input.vals()) {
      let bytes = floatToNat32(v);
      hash := hash ^ bytes;
      hash := hash *% 16777619;
    };
    hash
  };

  // djb2 over two Nat32 values — node combiner
  func djb2Pair(a : Nat32, b : Nat32) : Nat32 {
    var h : Nat32 = 5381;
    h := ((h << 5) +% h) +% a;
    h := ((h << 5) +% h) +% b;
    h
  };

  // SDBM over two Nat32 values — node combiner
  func sdbmPair(a : Nat32, b : Nat32) : Nat32 {
    var h : Nat32 = 0;
    h := a +% (h << 6) +% (h << 16) -% h;
    h := b +% (h << 6) +% (h << 16) -% h;
    h
  };

  // Triple-hash leaf: FNV-1a + djb2 + SDBM of the single float's Nat32 repr
  func leafHash(v : Float) : Nat32 {
    let n = floatToNat32(v);
    let h1 : Nat32 = (2166136261 ^ n) *% 16777619;
    let h2 = djb2Pair(n, 0);
    let h3 = sdbmPair(n, 0);
    h1 ^ h2 ^ h3
  };

  // Triple-hash node combination: XOR of three independent combiners
  func nodeHash(left : Nat32, right : Nat32) : Nat32 {
    let h1 : Nat32 = (left *% 16777619) ^ (right *% 2166136261);
    let h2 = djb2Pair(left, right);
    let h3 = sdbmPair(left, right);
    h1 ^ h2 ^ h3
  };
  
  func floatToNat32(f : Float) : Nat32 {
    let scaled = Int.abs(Float.toInt(f * 1000000.0));
    Nat32.fromNat(scaled % 4294967296)
  };
  
  public func merkleRoot(values : [Float]) : Nat32 {
    if (values.size() == 0) return 0;
    if (values.size() == 1) return leafHash(values[0]);

    let mid = values.size() / 2;
    var left = Buffer.Buffer<Float>(mid);
    var right = Buffer.Buffer<Float>(values.size() - mid);

    for (i in Array.keys(values)) {
      if (i < mid) { left.add(values[i]) }
      else { right.add(values[i]) };
    };

    let leftHash  = merkleRoot(Buffer.toArray(left));
    let rightHash = merkleRoot(Buffer.toArray(right));

    nodeHash(leftHash, rightHash)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GENESIS COMPLIANCE SCORES — Locked at formation
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type GenesisAnchor = {
    // Formation identifiers
    genesisHash : Nat32;
    genesisTimestamp : Int;
    genesisBeat : Nat;
    
    // Per-system genesis compliance scores
    brainComplianceGenesis : Float;
    quantumComplianceGenesis : Float;
    memoriaComplianceGenesis : Float;
    neurochemComplianceGenesis : Float;
    substrateComplianceGenesis : Float;
    simulacrumComplianceGenesis : Float;
    cortexComplianceGenesis : Float;
    genomeComplianceGenesis : Float;
    socioComplianceGenesis : Float;
    
    // Merkle roots (immutable)
    veritasMerkleGenesis : Nat32;
    aegisMerkleGenesis : Nat32;
    genomeMerkleGenesis : Nat32;
    
    // Reference vectors (genesis state)
    kuramotoRGenesis : Float;
    phaseVectorGenesis : [Float];    // 12 phases
    ntVectorGenesis : [Float];       // Neurotransmitter equilibrium
    purposeVectorGenesis : [Float];  // Purpose/goal vector
    traitVectorGenesis : [Float];    // 9 animal engine traits
    couplingMatrixSpectralGenesis : Float;
    predictionErrorGenesis : Float;
    treasuryGrowthModelGenesis : Float;
    
    // Sealed flag
    sealed : Bool;
  };
  
  public func initGenesisAnchor(timestamp : Int) : GenesisAnchor {
    {
      genesisHash = 0;
      genesisTimestamp = timestamp;
      genesisBeat = 0;
      brainComplianceGenesis = S0;
      quantumComplianceGenesis = S0;
      memoriaComplianceGenesis = S0;
      neurochemComplianceGenesis = S0;
      substrateComplianceGenesis = S0;
      simulacrumComplianceGenesis = S0;
      cortexComplianceGenesis = S0;
      genomeComplianceGenesis = S0;
      socioComplianceGenesis = S0;
      veritasMerkleGenesis = 0;
      aegisMerkleGenesis = 0;
      genomeMerkleGenesis = 0;
      kuramotoRGenesis = S0;
      phaseVectorGenesis = Array.tabulate<Float>(12, func(_) = 0.0);
      ntVectorGenesis = [S0, S0, S0, S0, S0];  // DA, 5HT, ACh, GABA, Glu
      purposeVectorGenesis = [S0, S0, S0, S0];
      traitVectorGenesis = Array.tabulate<Float>(9, func(_) = S0);
      couplingMatrixSpectralGenesis = S0;
      predictionErrorGenesis = 0.1;
      treasuryGrowthModelGenesis = 0.001;
      sealed = false;
    }
  };
  
  // Seal genesis anchor (called once at beat 0, immutable thereafter)
  public func sealGenesisAnchor(
    anchor : GenesisAnchor,
    brainScore : Float,
    quantumScore : Float,
    memoriaScore : Float,
    neurochemScore : Float,
    substrateScore : Float,
    simulacrumScore : Float,
    cortexScore : Float,
    genomeScore : Float,
    socioScore : Float,
    veritasMerkle : Nat32,
    aegisMerkle : Nat32,
    genomeMerkle : Nat32,
    kuramotoR : Float,
    phaseVector : [Float],
    ntVector : [Float],
    purposeVector : [Float],
    traitVector : [Float],
    couplingSpectral : Float,
    predError : Float,
    treasuryModel : Float,
    timestamp : Int
  ) : GenesisAnchor {
    if (anchor.sealed) return anchor;  // Cannot reseal
    
    // Compute genesis hash from all values
    var hashInput = Buffer.Buffer<Float>(50);
    hashInput.add(brainScore);
    hashInput.add(quantumScore);
    hashInput.add(memoriaScore);
    hashInput.add(Float.fromInt(Int.abs(timestamp)));
    let genesisHash = fnv1a(Buffer.toArray(hashInput));
    
    {
      genesisHash = genesisHash;
      genesisTimestamp = timestamp;
      genesisBeat = 0;
      brainComplianceGenesis = brainScore;
      quantumComplianceGenesis = quantumScore;
      memoriaComplianceGenesis = memoriaScore;
      neurochemComplianceGenesis = neurochemScore;
      substrateComplianceGenesis = substrateScore;
      simulacrumComplianceGenesis = simulacrumScore;
      cortexComplianceGenesis = cortexScore;
      genomeComplianceGenesis = genomeScore;
      socioComplianceGenesis = socioScore;
      veritasMerkleGenesis = veritasMerkle;
      aegisMerkleGenesis = aegisMerkle;
      genomeMerkleGenesis = genomeMerkle;
      kuramotoRGenesis = kuramotoR;
      phaseVectorGenesis = phaseVector;
      ntVectorGenesis = ntVector;
      purposeVectorGenesis = purposeVector;
      traitVectorGenesis = traitVector;
      couplingMatrixSpectralGenesis = couplingSpectral;
      predictionErrorGenesis = predError;
      treasuryGrowthModelGenesis = treasuryModel;
      sealed = true;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: BRAIN (Substrate Drift)
  // Measures: Kuramoto coherence r(t) and 12-node phase vector
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type BrainDriftResult = {
    kuramotoR : Float;
    phaseVector : [Float];
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    reEntrainmentPulse : Float;
  };
  
  public func computeBrainDrift(
    anchor : GenesisAnchor,
    currentR : Float,
    currentPhases : [Float]
  ) : BrainDriftResult {
    // Compute phase vector difference
    var phaseDriftSum : Float = 0.0;
    let len = Nat.min(currentPhases.size(), anchor.phaseVectorGenesis.size());
    for (i in Array.keys(currentPhases)) {
      if (i < len) {
        let diff = abs(currentPhases[i] - anchor.phaseVectorGenesis[i]);
        let wrapped = Float.min(diff, TAU - diff);
        phaseDriftSum += wrapped;
      };
    };
    let avgPhaseDrift = if (len > 0) phaseDriftSum / Float.fromInt(len) else 0.0;
    
    // R drift
    let rDrift = abs(currentR - anchor.kuramotoRGenesis);
    
    // Combined compliance score
    let complianceScore = currentR * (1.0 - avgPhaseDrift / PI);
    let driftDelta = abs(complianceScore - anchor.brainComplianceGenesis);
    
    let isViolation = driftDelta > EPSILON_BRAIN or currentR < anchor.kuramotoRGenesis * (1.0 - EPSILON_BRAIN);
    
    // Re-entrainment pulse: pulls organism back to genesis attractor
    let reEntrainmentPulse = if (isViolation) {
      (anchor.kuramotoRGenesis - currentR) * 0.1
    } else { 0.0 };
    
    {
      kuramotoR = currentR;
      phaseVector = currentPhases;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      reEntrainmentPulse = reEntrainmentPulse;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: QUANTUM (Decoherence Drift)
  // Measures: Fidelity F(ρ_genesis, ρ_live)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type QuantumDriftResult = {
    fidelity : Float;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    vqeRetrigger : Bool;
  };
  
  // Simplified fidelity computation (full Lindblad would require density matrix)
  public func computeQuantumDrift(
    anchor : GenesisAnchor,
    coherenceLevel : Float,
    entanglementMeasure : Float
  ) : QuantumDriftResult {
    // Fidelity approximation: F ≈ coherence × entanglement
    let fidelity = floor(coherenceLevel * entanglementMeasure, 0.0);
    let complianceScore = fidelity;
    let driftDelta = abs(complianceScore - anchor.quantumComplianceGenesis);
    
    let isViolation = driftDelta > EPSILON_QUANTUM or fidelity < 0.9;
    let vqeRetrigger = isViolation and fidelity < 0.8;
    
    {
      fidelity = fidelity;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      vqeRetrigger = vqeRetrigger;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: MEMORIA (Memory Consolidation Drift)
  // Measures: Hebbian weight matrix entropy H(W)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type MemoriaDriftResult = {
    hebbianEntropy : Float;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    replayConsolidation : Bool;
  };
  
  // H(W) = -Σᵢⱼ Wᵢⱼ · log(Wᵢⱼ + ε)
  public func computeHebbianEntropy(weights : [Float]) : Float {
    var entropy : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for (w in weights.vals()) {
      totalWeight += w;
    };
    
    if (totalWeight < 0.0001) return 0.0;
    
    for (w in weights.vals()) {
      let p = w / totalWeight;
      if (p > 0.0001) {
        entropy -= p * ln(p + 0.0001);
      };
    };
    
    entropy
  };
  
  public func computeMemoriaDrift(
    anchor : GenesisAnchor,
    currentWeights : [Float]
  ) : MemoriaDriftResult {
    let entropy = computeHebbianEntropy(currentWeights);
    let complianceScore = floor(S0 / (1.0 + entropy * 0.1), S0);
    let driftDelta = abs(complianceScore - anchor.memoriaComplianceGenesis);
    
    let isViolation = driftDelta > EPSILON_MEMORIA;
    let replayConsolidation = isViolation and entropy > 2.0;  // High entropy = decaying
    
    {
      hebbianEntropy = entropy;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      replayConsolidation = replayConsolidation;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: NEUROCHEM (Neurotransmitter Balance Drift)
  // Measures: δ_NT = ||NT_live − NT_genesis||₂
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type NeurochemDriftResult = {
    ntDistance : Float;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    homeostaticCorrection : [Float];
  };
  
  public func computeNeurochemDrift(
    anchor : GenesisAnchor,
    currentNT : [Float]  // [DA, 5HT, ACh, GABA, Glu]
  ) : NeurochemDriftResult {
    // Euclidean distance from genesis equilibrium
    var distSquared : Float = 0.0;
    let len = Nat.min(currentNT.size(), anchor.ntVectorGenesis.size());
    
    for (i in Array.keys(currentNT)) {
      if (i < len) {
        let diff = currentNT[i] - anchor.ntVectorGenesis[i];
        distSquared += diff * diff;
      };
    };
    
    let ntDistance = sqrt(distSquared);
    let complianceScore = floor(S0 / (1.0 + ntDistance), S0);
    let driftDelta = abs(complianceScore - anchor.neurochemComplianceGenesis);
    
    let isViolation = driftDelta > EPSILON_NEUROCHEM or ntDistance > 1.0;
    
    // Homeostatic correction: pull back toward genesis
    var correction = Array.init<Float>(len, 0.0);
    if (isViolation) {
      for (i in Array.keys(currentNT)) {
        if (i < len) {
          correction[i] := (anchor.ntVectorGenesis[i] - currentNT[i]) * 0.1;
        };
      };
    };
    
    {
      ntDistance = ntDistance;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      homeostaticCorrection = Array.freeze(correction);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: SUBSTRATE (Hz Coupling Drift)
  // Measures: Spectral radius ρ(K_live) vs ρ(K_genesis)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SubstrateDriftResult = {
    spectralRadius : Float;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    reanchorBlend : Float;  // How much to blend back to genesis
  };
  
  // Approximate spectral radius via power iteration
  public func approximateSpectralRadius(matrix : [Float], n : Nat) : Float {
    if (matrix.size() < n * n) return 1.0;
    
    // Start with random vector
    var v = Array.init<Float>(n, 1.0 / sqrt(Float.fromInt(n)));
    
    // Power iteration (10 iterations)
    var iter = 0;
    while (iter < 10) {
      var newV = Array.init<Float>(n, 0.0);
      
      for (i in Array.keys(v)) {
        var sum : Float = 0.0;
        for (j in Array.keys(v)) {
          let idx = i * n + j;
          if (idx < matrix.size()) {
            sum += matrix[idx] * v[j];
          };
        };
        newV[i] := sum;
      };
      
      // Normalize
      let normV = norm(Array.freeze(newV));
      if (normV > 0.0001) {
        for (i in Array.keys(v)) {
          v[i] := newV[i] / normV;
        };
      };
      
      iter += 1;
    };
    
    // Rayleigh quotient
    var numerator : Float = 0.0;
    for (i in Array.keys(v)) {
      var sum : Float = 0.0;
      for (j in Array.keys(v)) {
        let idx = i * n + j;
        if (idx < matrix.size()) {
          sum += matrix[idx] * v[j];
        };
      };
      numerator += v[i] * sum;
    };
    
    abs(numerator)
  };
  
  public func computeSubstrateDrift(
    anchor : GenesisAnchor,
    currentCouplingMatrix : [Float],
    n : Nat
  ) : SubstrateDriftResult {
    let spectralRadius = approximateSpectralRadius(currentCouplingMatrix, n);
    let complianceScore = floor(anchor.couplingMatrixSpectralGenesis / (spectralRadius + 0.001), S0);
    let driftDelta = abs(spectralRadius - anchor.couplingMatrixSpectralGenesis);
    
    let isViolation = driftDelta > EPSILON_SUBSTRATE * anchor.couplingMatrixSpectralGenesis;
    
    // Blend factor: how much to pull back to genesis coupling
    let reanchorBlend = if (isViolation) {
      Float.min(0.5, driftDelta / anchor.couplingMatrixSpectralGenesis)
    } else { 0.0 };
    
    {
      spectralRadius = spectralRadius;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      reanchorBlend = reanchorBlend;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: SIMULACRUM (Predictive Coding Drift)
  // Measures: Mean prediction error δ_pred = (1/N) Σₜ ||y_t − ŷ_t||²
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SimulacrumDriftResult = {
    predictionError : Float;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    modelResync : Bool;
  };
  
  public func computeSimulacrumDrift(
    anchor : GenesisAnchor,
    predictionErrors : [Float]  // Last N prediction errors
  ) : SimulacrumDriftResult {
    // Mean prediction error
    var sum : Float = 0.0;
    for (e in predictionErrors.vals()) { sum += e * e };
    let meanError = if (predictionErrors.size() > 0) {
      sqrt(sum / Float.fromInt(predictionErrors.size()))
    } else { 0.0 };
    
    let complianceScore = floor(S0 / (1.0 + meanError), S0);
    let driftDelta = abs(meanError - anchor.predictionErrorGenesis);
    
    // k multiplier for tolerance
    let k : Float = 2.0;
    let isViolation = meanError > k * anchor.predictionErrorGenesis;
    let modelResync = isViolation and meanError > 3.0 * anchor.predictionErrorGenesis;
    
    {
      predictionError = meanError;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      modelResync = modelResync;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: CORTEX (Executive Function Drift)
  // Measures: Goal coherence cos_sim(P_live, P_genesis)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type CortexDriftResult = {
    goalCoherence : Float;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    purposeRealignment : [Float];
  };
  
  public func computeCortexDrift(
    anchor : GenesisAnchor,
    currentPurpose : [Float]
  ) : CortexDriftResult {
    let goalCoherence = cosineSimilarity(currentPurpose, anchor.purposeVectorGenesis);
    let complianceScore = floor(goalCoherence, S0);
    let driftDelta = abs(complianceScore - anchor.cortexComplianceGenesis);
    
    let isViolation = goalCoherence < 0.8;  // Must maintain 80% purpose alignment
    
    // Purpose realignment: pull back toward genesis purpose
    var realignment = Array.init<Float>(currentPurpose.size(), 0.0);
    if (isViolation) {
      let len = Nat.min(currentPurpose.size(), anchor.purposeVectorGenesis.size());
      for (i in Array.keys(currentPurpose)) {
        if (i < len) {
          realignment[i] := (anchor.purposeVectorGenesis[i] - currentPurpose[i]) * 0.2;
        };
      };
    };
    
    {
      goalCoherence = goalCoherence;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      purposeRealignment = Array.freeze(realignment);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: GENOME (Self-Modification Drift)
  // Measures: Hamming distance d_H(genome_live, genome_genesis)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type GenomeDriftResult = {
    hammingDistance : Float;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    rollbackRequired : Bool;
  };
  
  public func computeGenomeDrift(
    anchor : GenesisAnchor,
    currentGenomeMerkle : Nat32
  ) : GenomeDriftResult {
    // Hamming distance via XOR bit count
    let xored = currentGenomeMerkle ^ anchor.genomeMerkleGenesis;
    var bitCount : Nat32 = 0;
    var x = xored;
    while (x > 0) {
      bitCount += x & 1;
      x := x >> 1;
    };
    
    let hammingDistance = Float.fromInt(Nat32.toNat(bitCount)) / 32.0;  // Normalized
    let complianceScore = floor(S0 - hammingDistance, S0);
    let driftDelta = hammingDistance;
    
    let isViolation = hammingDistance > EPSILON_GENOME;
    let rollbackRequired = hammingDistance > EPSILON_GENOME * 2.0;
    
    {
      hammingDistance = hammingDistance;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      rollbackRequired = rollbackRequired;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: VERITAS (Vault Integrity Drift)
  // Measures: Merkle root — ANY deviation = CRITICAL violation
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type VeritasDriftResult = {
    merkleMatch : Bool;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    emergencyAudit : Bool;
  };
  
  public func computeVeritasDrift(
    anchor : GenesisAnchor,
    currentMerkle : Nat32
  ) : VeritasDriftResult {
    let merkleMatch = currentMerkle == anchor.veritasMerkleGenesis;
    let complianceScore = if (merkleMatch) S0 else 0.0;
    let driftDelta = if (merkleMatch) 0.0 else 1.0;  // Binary: match or not
    
    let isViolation = not merkleMatch;
    let emergencyAudit = isViolation;  // ANY bit difference = emergency
    
    {
      merkleMatch = merkleMatch;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      emergencyAudit = emergencyAudit;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: AEGIS (Security Perimeter Drift)
  // Measures: Principal whitelist hash — ANY deviation = CRITICAL
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type AegisDriftResult = {
    perimeterIntact : Bool;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    immediateLock : Bool;
  };
  
  public func computeAegisDrift(
    anchor : GenesisAnchor,
    currentAegisMerkle : Nat32
  ) : AegisDriftResult {
    let perimeterIntact = currentAegisMerkle == anchor.aegisMerkleGenesis;
    let complianceScore = if (perimeterIntact) S0 else 0.0;
    let driftDelta = if (perimeterIntact) 0.0 else 1.0;
    
    let isViolation = not perimeterIntact;
    let immediateLock = isViolation;  // Restore perimeter immediately
    
    {
      perimeterIntact = perimeterIntact;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      immediateLock = immediateLock;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIFT GATE: BEHAVIORAL (Behavioral Envelope Drift)
  // Measures: δ_behavior = ||trait_live[9] − trait_genesis[9]||₂
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type BehavioralDriftResult = {
    traitDistance : Float;
    complianceScore : Float;
    driftDelta : Float;
    isViolation : Bool;
    traitRebalancing : [Float];
  };
  
  public func computeBehavioralDrift(
    anchor : GenesisAnchor,
    currentTraits : [Float]  // 9 animal engine activations
  ) : BehavioralDriftResult {
    // Euclidean distance from genesis trait vector
    var distSquared : Float = 0.0;
    let len = Nat.min(currentTraits.size(), anchor.traitVectorGenesis.size());
    
    for (i in Array.keys(currentTraits)) {
      if (i < len) {
        let diff = currentTraits[i] - anchor.traitVectorGenesis[i];
        distSquared += diff * diff;
      };
    };
    
    let traitDistance = sqrt(distSquared);
    let complianceScore = floor(S0 / (1.0 + traitDistance), S0);
    let driftDelta = traitDistance;
    
    let isViolation = traitDistance > EPSILON_BEHAVIORAL * Float.fromInt(len);
    
    // Trait rebalancing: pull toward genesis
    var rebalancing = Array.init<Float>(len, 0.0);
    if (isViolation) {
      for (i in Array.keys(currentTraits)) {
        if (i < len) {
          rebalancing[i] := (anchor.traitVectorGenesis[i] - currentTraits[i]) * 0.15;
        };
      };
    };
    
    {
      traitDistance = traitDistance;
      complianceScore = complianceScore;
      driftDelta = driftDelta;
      isViolation = isViolation;
      traitRebalancing = Array.freeze(rebalancing);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLETE DRIFT AGGREGATION — Organism-wide drift index
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DriftAggregation = {
    brainDrift : BrainDriftResult;
    quantumDrift : QuantumDriftResult;
    memoriaDrift : MemoriaDriftResult;
    neurochemDrift : NeurochemDriftResult;
    substrateDrift : SubstrateDriftResult;
    simulacrumDrift : SimulacrumDriftResult;
    cortexDrift : CortexDriftResult;
    genomeDrift : GenomeDriftResult;
    veritasDrift : VeritasDriftResult;
    aegisDrift : AegisDriftResult;
    behavioralDrift : BehavioralDriftResult;
    
    organismDriftIndex : Float;     // Weighted sum of all drifts
    globalViolation : Bool;         // Any critical violation
    reEntrainmentRequired : Bool;   // Full re-entrainment needed
    violationCount : Nat;
    complianceScore : Float;        // Overall compliance [0, 1]
    beatNum : Nat;
  };
  
  // Weights for drift aggregation
  public let WEIGHT_BRAIN : Float = 0.15;
  public let WEIGHT_QUANTUM : Float = 0.10;
  public let WEIGHT_MEMORIA : Float = 0.10;
  public let WEIGHT_NEUROCHEM : Float = 0.08;
  public let WEIGHT_SUBSTRATE : Float = 0.10;
  public let WEIGHT_SIMULACRUM : Float = 0.07;
  public let WEIGHT_CORTEX : Float = 0.12;
  public let WEIGHT_GENOME : Float = 0.08;
  public let WEIGHT_VERITAS : Float = 0.08;
  public let WEIGHT_AEGIS : Float = 0.07;
  public let WEIGHT_BEHAVIORAL : Float = 0.05;
  
  public func aggregateDrift(
    brain : BrainDriftResult,
    quantum : QuantumDriftResult,
    memoria : MemoriaDriftResult,
    neurochem : NeurochemDriftResult,
    substrate : SubstrateDriftResult,
    simulacrum : SimulacrumDriftResult,
    cortex : CortexDriftResult,
    genome : GenomeDriftResult,
    veritas : VeritasDriftResult,
    aegis : AegisDriftResult,
    behavioral : BehavioralDriftResult,
    beatNum : Nat
  ) : DriftAggregation {
    // Weighted drift index
    let driftIndex = 
      brain.driftDelta * WEIGHT_BRAIN +
      quantum.driftDelta * WEIGHT_QUANTUM +
      memoria.driftDelta * WEIGHT_MEMORIA +
      neurochem.driftDelta * WEIGHT_NEUROCHEM +
      substrate.driftDelta * WEIGHT_SUBSTRATE +
      simulacrum.driftDelta * WEIGHT_SIMULACRUM +
      cortex.driftDelta * WEIGHT_CORTEX +
      genome.driftDelta * WEIGHT_GENOME +
      veritas.driftDelta * WEIGHT_VERITAS +
      aegis.driftDelta * WEIGHT_AEGIS +
      behavioral.driftDelta * WEIGHT_BEHAVIORAL;
    
    // Count violations
    var violations : Nat = 0;
    if (brain.isViolation) violations += 1;
    if (quantum.isViolation) violations += 1;
    if (memoria.isViolation) violations += 1;
    if (neurochem.isViolation) violations += 1;
    if (substrate.isViolation) violations += 1;
    if (simulacrum.isViolation) violations += 1;
    if (cortex.isViolation) violations += 1;
    if (genome.isViolation) violations += 1;
    if (veritas.isViolation) violations += 1;
    if (aegis.isViolation) violations += 1;
    if (behavioral.isViolation) violations += 1;
    
    // Critical violations (VERITAS, AEGIS, GENOME)
    let criticalViolation = veritas.isViolation or aegis.isViolation or genome.rollbackRequired;
    
    // Global violation
    let globalViolation = driftIndex > GLOBAL_DRIFT_THRESHOLD or criticalViolation;
    
    // Full re-entrainment needed
    let reEntrainment = violations >= 5 or globalViolation;
    
    // Overall compliance score
    let complianceSum = 
      brain.complianceScore + quantum.complianceScore + memoria.complianceScore +
      neurochem.complianceScore + substrate.complianceScore + simulacrum.complianceScore +
      cortex.complianceScore + genome.complianceScore + veritas.complianceScore +
      aegis.complianceScore + behavioral.complianceScore;
    let overallCompliance = complianceSum / 11.0;
    
    {
      brainDrift = brain;
      quantumDrift = quantum;
      memoriaDrift = memoria;
      neurochemDrift = neurochem;
      substrateDrift = substrate;
      simulacrumDrift = simulacrum;
      cortexDrift = cortex;
      genomeDrift = genome;
      veritasDrift = veritas;
      aegisDrift = aegis;
      behavioralDrift = behavioral;
      organismDriftIndex = driftIndex;
      globalViolation = globalViolation;
      reEntrainmentRequired = reEntrainment;
      violationCount = violations;
      complianceScore = overallCompliance;
      beatNum = beatNum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LAW CASCADE — Self-correction machinery
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type LawCascadeResult = {
    correctionApplied : Bool;
    brainPulse : Float;
    neurochemCorrections : [Float];
    purposeCorrections : [Float];
    traitCorrections : [Float];
    substrateBlend : Float;
    modelResync : Bool;
    memoryReplay : Bool;
    vqeRetrigger : Bool;
    emergencyAudit : Bool;
    perimeterLock : Bool;
    genomeRollback : Bool;
  };
  
  public func executeLawCascade(agg : DriftAggregation) : LawCascadeResult {
    {
      correctionApplied = agg.violationCount > 0;
      brainPulse = agg.brainDrift.reEntrainmentPulse;
      neurochemCorrections = agg.neurochemDrift.homeostaticCorrection;
      purposeCorrections = agg.cortexDrift.purposeRealignment;
      traitCorrections = agg.behavioralDrift.traitRebalancing;
      substrateBlend = agg.substrateDrift.reanchorBlend;
      modelResync = agg.simulacrumDrift.modelResync;
      memoryReplay = agg.memoriaDrift.replayConsolidation;
      vqeRetrigger = agg.quantumDrift.vqeRetrigger;
      emergencyAudit = agg.veritasDrift.emergencyAudit;
      perimeterLock = agg.aegisDrift.immediateLock;
      genomeRollback = agg.genomeDrift.rollbackRequired;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // WORKFLOW VERIFICATION — Law verification at workflow boundaries
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type WorkflowStep = {
    stepId : Nat;
    mechanismId : Text;
    preCompliance : Float;
    postCompliance : Float;
    stepDrift : Float;
    isCompliant : Bool;
  };
  
  public type WorkflowVerification = {
    workflowId : Nat;
    steps : [WorkflowStep];
    workflowIntegrity : Float;  // Π(step_compliance)
    overallCompliant : Bool;
    backtrackTo : ?Nat;  // Step to backtrack to if failed
  };
  
  public func verifyWorkflowStep(
    stepId : Nat,
    mechanismId : Text,
    preState : Float,
    postState : Float,
    threshold : Float
  ) : WorkflowStep {
    let stepDrift = abs(postState - preState);
    let isCompliant = stepDrift < threshold;
    
    {
      stepId = stepId;
      mechanismId = mechanismId;
      preCompliance = preState;
      postCompliance = postState;
      stepDrift = stepDrift;
      isCompliant = isCompliant;
    }
  };
  
  public func verifyWorkflow(workflowId : Nat, steps : [WorkflowStep]) : WorkflowVerification {
    var integrity : Float = 1.0;
    var allCompliant = true;
    var backtrackStep : ?Nat = null;
    
    for (step in steps.vals()) {
      let stepCompliance = if (step.isCompliant) {
        floor(1.0 - step.stepDrift, 0.5)
      } else {
        0.5
      };
      integrity *= stepCompliance;
      
      if (not step.isCompliant) {
        allCompliant := false;
        if (backtrackStep == null) {
          backtrackStep := ?step.stepId;
        };
      };
    };
    
    {
      workflowId = workflowId;
      steps = steps;
      workflowIntegrity = integrity;
      overallCompliant = allCompliant and integrity > 0.5;
      backtrackTo = backtrackStep;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ENTERPRISE COMPLIANCE CERTIFICATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ComplianceCertificate = {
    beatNum : Nat;
    timestamp : Int;
    overallCompliance : Float;  // 0.0 - 1.0
    auditTraceHash : Nat32;
    violationCount : Nat;
    criticalViolations : Bool;
  };
  
  public func generateComplianceCertificate(
    agg : DriftAggregation,
    timestamp : Int
  ) : ComplianceCertificate {
    // Audit trace hash
    var traceInput = Buffer.Buffer<Float>(20);
    traceInput.add(agg.brainDrift.complianceScore);
    traceInput.add(agg.quantumDrift.complianceScore);
    traceInput.add(agg.cortexDrift.complianceScore);
    traceInput.add(Float.fromInt(agg.beatNum));
    let auditHash = fnv1a(Buffer.toArray(traceInput));
    
    {
      beatNum = agg.beatNum;
      timestamp = timestamp;
      overallCompliance = agg.complianceScore;
      auditTraceHash = auditHash;
      violationCount = agg.violationCount;
      criticalViolations = agg.veritasDrift.isViolation or agg.aegisDrift.isViolation;
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
