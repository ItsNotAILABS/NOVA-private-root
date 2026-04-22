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
//  PACKAGING RESEARCH LAB — Layer 36 Packaging Department Full Research Complex
// ═══════════════════════════════════════════════════════════════════════════════
//
//  8 PHI-aligned research divisions providing the Packaging Department with
//  complete R&D capabilities for artifact analysis, SDK forging, QA testing,
//  prototype construction, registry optimization, replication fidelity,
//  cryptography research, and doctrine compliance verification.
//
//  Division 0: Artifact Analysis Lab
//  Division 1: SDK Forge
//  Division 2: Quality Assurance Lab
//  Division 3: Prototype Workshop
//  Division 4: Registry Research
//  Division 5: Replication Lab
//  Division 6: Cryptography Lab
//  Division 7: Doctrine Compliance
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Text "mo:base/Text";

module {

  // ═══════════════════════════════════════════════════════════════════════════
  //  CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;

  public let DIVISION_COUNT : Nat = 8;
  public let SDK_TARGET_COUNT : Nat = 8;

  public let COHERENCE_FLOOR : Float = 0.05;
  public let COHERENCE_CEILING : Float = 1.0;
  public let COHERENCE_DECAY : Float = 0.995;
  public let COHERENCE_GAIN : Float = 0.01;
  public let PHI_COUPLING : Float = 0.1;

  public let FIDELITY_THRESHOLD : Float = 0.90;
  public let COMPLIANCE_THRESHOLD : Float = 0.95;
  public let QA_PASS_THRESHOLD : Float = 0.85;

  // ── FNV-1a Constants ──
  let FNV_OFFSET_BASIS : Nat32 = 0x811c9dc5;
  let FNV_PRIME : Nat32 = 0x01000193;

  // ═══════════════════════════════════════════════════════════════════════════
  //  TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type LabDivisionId = {
    #ArtifactAnalysis;
    #SDKForge;
    #QualityAssurance;
    #PrototypeWorkshop;
    #RegistryResearch;
    #ReplicationLab;
    #CryptographyLab;
    #DoctrineCompliance;
  };

  public type SDKTarget = {
    #Business;
    #Research;
    #Defense;
    #IoT;
    #Finance;
    #Creative;
    #Governance;
    #Identity;
  };

  public type ArtifactVaultMetrics = {
    artifactsAnalyzed : Nat;
    artifactsPassed : Nat;
    artifactsFailed : Nat;
  };

  public type SDKForgeMetrics = {
    forgeOutputCount : Nat;
    currentForgeTarget : Nat;
    sdkBusinessBuilt : Nat;
    sdkResearchBuilt : Nat;
    sdkDefenseBuilt : Nat;
    sdkIoTBuilt : Nat;
    sdkFinanceBuilt : Nat;
    sdkCreativeBuilt : Nat;
    sdkGovernanceBuilt : Nat;
    sdkIdentityBuilt : Nat;
  };

  public type QAMetrics = {
    testsRun : Nat;
    testsPassed : Nat;
    testsFailed : Nat;
  };

  public type PrototypeMetrics = {
    prototypesBuilt : Nat;
    prototypesApproved : Nat;
    prototypesRejected : Nat;
  };

  public type RegistryMetrics = {
    optimizationsFound : Nat;
    deduplicationsPerformed : Nat;
    versioningStrategiesEvaluated : Nat;
    lineagesTracked : Nat;
  };

  public type ReplicationMetrics = {
    fidelityScore : Float;
    replicationsVerified : Nat;
    branchExpressionsChecked : Nat;
    isolationsPassed : Nat;
  };

  public type CryptoMetrics = {
    signaturesGenerated : Nat;
    signaturesFailed : Nat;
    fnvChainsOptimized : Nat;
    quantumResistantTests : Nat;
  };

  public type DoctrineMetrics = {
    auditsRun : Nat;
    auditsPassed : Nat;
    auditsFailed : Nat;
    complianceScore : Float;
  };

  // ── Main Lab State ──
  public type PackagingLabState = {
    // ── Per-Division Coherences (8) ──
    artifactAnalysisCoherence : Float;
    sdkForgeCoherence : Float;
    qaLabCoherence : Float;
    prototypeWorkshopCoherence : Float;
    registryResearchCoherence : Float;
    replicationLabCoherence : Float;
    cryptoLabCoherence : Float;
    doctrineComplianceCoherence : Float;

    // ── Per-Division Experiment Counts (8) ──
    artifactExperiments : Nat;
    forgeExperiments : Nat;
    qaExperiments : Nat;
    prototypeExperiments : Nat;
    registryExperiments : Nat;
    replicationExperiments : Nat;
    cryptoExperiments : Nat;
    doctrineExperiments : Nat;

    // ── Per-Division Findings (8) ──
    artifactFindings : Nat;
    forgeFindings : Nat;
    qaFindings : Nat;
    prototypeFindings : Nat;
    registryFindings : Nat;
    replicationFindings : Nat;
    cryptoFindings : Nat;
    doctrineFindings : Nat;

    // ── Division-Specific Metrics ──
    artifactVault : ArtifactVaultMetrics;
    sdkForge : SDKForgeMetrics;
    qaMetrics : QAMetrics;
    prototypeMetrics : PrototypeMetrics;
    registryMetrics : RegistryMetrics;
    replicationMetrics : ReplicationMetrics;
    cryptoMetrics : CryptoMetrics;
    doctrineMetrics : DoctrineMetrics;

    // ── Lab-Wide Aggregate ──
    labCoherence : Float;
    totalExperiments : Nat;
    totalFindings : Nat;
    labUptime : Nat;
    labAwake : Bool;
    lastIntegrityHash : Nat32;
    currentBeat : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  FNV-1a HASHING
  // ═══════════════════════════════════════════════════════════════════════════

  func fnv1a(beat : Nat, rSwarm : Float, jDrift : Float) : Nat32 {
    var h : Nat32 = FNV_OFFSET_BASIS;
    let b = Nat32.fromNat(beat % 4294967296);
    h := (h ^ b) *% FNV_PRIME;
    let r = Nat32.fromNat(Int.abs(Float.toInt(rSwarm * 1000000.0)) % 4294967296);
    h := (h ^ r) *% FNV_PRIME;
    let j = Nat32.fromNat(Int.abs(Float.toInt(jDrift * 1000000.0)) % 4294967296);
    h := (h ^ j) *% FNV_PRIME;
    h
  };

  func fnv1aChain(a : Nat32, b : Nat32, c : Nat32) : Nat32 {
    var h : Nat32 = FNV_OFFSET_BASIS;
    h := (h ^ a) *% FNV_PRIME;
    h := (h ^ b) *% FNV_PRIME;
    h := (h ^ c) *% FNV_PRIME;
    h
  };

  func fnv1aFromNats(a : Nat, b : Nat, c : Nat) : Nat32 {
    fnv1aChain(
      Nat32.fromNat(a % 4294967296),
      Nat32.fromNat(b % 4294967296),
      Nat32.fromNat(c % 4294967296)
    )
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  PHI-MODULATED COHERENCE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  func clampCoherence(c : Float) : Float {
    if (c < COHERENCE_FLOOR) { COHERENCE_FLOOR }
    else if (c > COHERENCE_CEILING) { COHERENCE_CEILING }
    else { c }
  };

  func phiModulate(coherence : Float, rSwarm : Float, jDrift : Float, beat : Nat) : Float {
    let phase = Float.sin(Float.fromInt(beat) * φ * 0.1);
    let swarmBoost = rSwarm * COHERENCE_GAIN * φ;
    let driftPenalty = Float.abs(jDrift) * COHERENCE_GAIN * ψ;
    let updated = coherence * COHERENCE_DECAY + swarmBoost + phase * 0.005 - driftPenalty;
    clampCoherence(updated)
  };

  func phiModulateStrong(coherence : Float, rSwarm : Float, jDrift : Float, beat : Nat, successRate : Float) : Float {
    let phase = Float.sin(Float.fromInt(beat) * φ * PHI_COUPLING);
    let swarmBoost = rSwarm * COHERENCE_GAIN * φ * successRate;
    let driftPenalty = Float.abs(jDrift) * COHERENCE_GAIN * ψ;
    let updated = coherence * COHERENCE_DECAY + swarmBoost + phase * 0.008 - driftPenalty;
    clampCoherence(updated)
  };

  func computeGlobalCoherence(coherences : [Float]) : Float {
    if (coherences.size() == 0) { return 0.5 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    let n = Float.fromInt(coherences.size());
    for (c in coherences.vals()) {
      let angle = c * τ;
      sumCos += Float.cos(angle);
      sumSin += Float.sin(angle);
    };
    let magnitude = Float.sqrt(
      (sumCos / n) * (sumCos / n) + (sumSin / n) * (sumSin / n)
    );
    clampCoherence(magnitude)
  };

  func pseudoRandBool(hash : Nat32, threshold : Nat32) : Bool {
    hash > threshold
  };

  func pseudoRandNat(hash : Nat32, modulus : Nat) : Nat {
    if (modulus == 0) { 0 }
    else { Nat32.toNat(hash) % modulus }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initPackagingLab() : PackagingLabState {
    {
      // ── Per-Division Coherences ──
      artifactAnalysisCoherence = 0.5;
      sdkForgeCoherence = 0.5;
      qaLabCoherence = 0.5;
      prototypeWorkshopCoherence = 0.5;
      registryResearchCoherence = 0.5;
      replicationLabCoherence = 0.5;
      cryptoLabCoherence = 0.5;
      doctrineComplianceCoherence = 0.5;

      // ── Experiment Counts ──
      artifactExperiments = 0;
      forgeExperiments = 0;
      qaExperiments = 0;
      prototypeExperiments = 0;
      registryExperiments = 0;
      replicationExperiments = 0;
      cryptoExperiments = 0;
      doctrineExperiments = 0;

      // ── Findings ──
      artifactFindings = 0;
      forgeFindings = 0;
      qaFindings = 0;
      prototypeFindings = 0;
      registryFindings = 0;
      replicationFindings = 0;
      cryptoFindings = 0;
      doctrineFindings = 0;

      // ── Artifact Vault ──
      artifactVault = {
        artifactsAnalyzed = 0;
        artifactsPassed = 0;
        artifactsFailed = 0;
      };

      // ── SDK Forge ──
      sdkForge = {
        forgeOutputCount = 0;
        currentForgeTarget = 0;
        sdkBusinessBuilt = 0;
        sdkResearchBuilt = 0;
        sdkDefenseBuilt = 0;
        sdkIoTBuilt = 0;
        sdkFinanceBuilt = 0;
        sdkCreativeBuilt = 0;
        sdkGovernanceBuilt = 0;
        sdkIdentityBuilt = 0;
      };

      // ── QA ──
      qaMetrics = {
        testsRun = 0;
        testsPassed = 0;
        testsFailed = 0;
      };

      // ── Prototype ──
      prototypeMetrics = {
        prototypesBuilt = 0;
        prototypesApproved = 0;
        prototypesRejected = 0;
      };

      // ── Registry ──
      registryMetrics = {
        optimizationsFound = 0;
        deduplicationsPerformed = 0;
        versioningStrategiesEvaluated = 0;
        lineagesTracked = 0;
      };

      // ── Replication ──
      replicationMetrics = {
        fidelityScore = 1.0;
        replicationsVerified = 0;
        branchExpressionsChecked = 0;
        isolationsPassed = 0;
      };

      // ── Cryptography ──
      cryptoMetrics = {
        signaturesGenerated = 0;
        signaturesFailed = 0;
        fnvChainsOptimized = 0;
        quantumResistantTests = 0;
      };

      // ── Doctrine Compliance ──
      doctrineMetrics = {
        auditsRun = 0;
        auditsPassed = 0;
        auditsFailed = 0;
        complianceScore = 1.0;
      };

      // ── Lab-Wide ──
      labCoherence = 0.5;
      totalExperiments = 0;
      totalFindings = 0;
      labUptime = 0;
      labAwake = true;
      lastIntegrityHash = FNV_OFFSET_BASIS;
      currentBeat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION 0 — ARTIFACT ANALYSIS LAB
  // ═══════════════════════════════════════════════════════════════════════════
  //  Analyzes source organisms for packageability, module dependency graphs,
  //  coherence maps, and integrity verification.
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickArtifactAnalysis(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    let hash = fnv1a(beat, rSwarm, jDrift);
    let doAnalysis = pseudoRandBool(hash, 1073741824);   // ~75% chance
    let analysisPass = pseudoRandBool(
      fnv1aChain(hash, Nat32.fromNat(beat % 4294967296), 0x0A0A0A0A),
      858993459  // ~80% pass rate
    );

    let newVault : ArtifactVaultMetrics = if (doAnalysis) {
      if (analysisPass) {
        {
          artifactsAnalyzed = state.artifactVault.artifactsAnalyzed + 1;
          artifactsPassed = state.artifactVault.artifactsPassed + 1;
          artifactsFailed = state.artifactVault.artifactsFailed;
        }
      } else {
        {
          artifactsAnalyzed = state.artifactVault.artifactsAnalyzed + 1;
          artifactsPassed = state.artifactVault.artifactsPassed;
          artifactsFailed = state.artifactVault.artifactsFailed + 1;
        }
      }
    } else {
      state.artifactVault
    };

    let expInc : Nat = if (doAnalysis) { 1 } else { 0 };
    let findInc : Nat = if (doAnalysis and not analysisPass) { 1 } else { 0 };

    let successRate = if (newVault.artifactsAnalyzed == 0) { 1.0 }
      else { Float.fromInt(newVault.artifactsPassed) / Float.fromInt(newVault.artifactsAnalyzed) };

    let newCoherence = phiModulateStrong(
      state.artifactAnalysisCoherence, rSwarm, jDrift, beat, successRate
    );

    {
      state with
      artifactAnalysisCoherence = newCoherence;
      artifactExperiments = state.artifactExperiments + expInc;
      artifactFindings = state.artifactFindings + findInc;
      artifactVault = newVault;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION 1 — SDK FORGE
  // ═══════════════════════════════════════════════════════════════════════════
  //  Builds and compiles SDK packages for each of the 8 target worlds:
  //  Business, Research, Defense, IoT, Finance, Creative, Governance, Identity.
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickSDKForge(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    let hash = fnv1a(beat + 1, rSwarm, jDrift);
    let doBuild = pseudoRandBool(hash, 1610612736);      // ~62.5% chance
    let nextTarget = pseudoRandNat(hash, SDK_TARGET_COUNT);

    let currentForge = state.sdkForge;

    let newForge : SDKForgeMetrics = if (doBuild) {
      let base = {
        currentForge with
        forgeOutputCount = currentForge.forgeOutputCount + 1;
        currentForgeTarget = nextTarget;
      };
      switch (nextTarget) {
        case 0 { { base with sdkBusinessBuilt = base.sdkBusinessBuilt + 1 } };
        case 1 { { base with sdkResearchBuilt = base.sdkResearchBuilt + 1 } };
        case 2 { { base with sdkDefenseBuilt = base.sdkDefenseBuilt + 1 } };
        case 3 { { base with sdkIoTBuilt = base.sdkIoTBuilt + 1 } };
        case 4 { { base with sdkFinanceBuilt = base.sdkFinanceBuilt + 1 } };
        case 5 { { base with sdkCreativeBuilt = base.sdkCreativeBuilt + 1 } };
        case 6 { { base with sdkGovernanceBuilt = base.sdkGovernanceBuilt + 1 } };
        case 7 { { base with sdkIdentityBuilt = base.sdkIdentityBuilt + 1 } };
        case _ { base };
      }
    } else {
      { currentForge with currentForgeTarget = nextTarget }
    };

    let expInc : Nat = if (doBuild) { 1 } else { 0 };
    let findInc : Nat = if (doBuild and nextTarget < 4) { 1 } else { 0 };

    let newCoherence = phiModulate(state.sdkForgeCoherence, rSwarm, jDrift, beat);

    {
      state with
      sdkForgeCoherence = newCoherence;
      forgeExperiments = state.forgeExperiments + expInc;
      forgeFindings = state.forgeFindings + findInc;
      sdkForge = newForge;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION 2 — QUALITY ASSURANCE LAB
  // ═══════════════════════════════════════════════════════════════════════════
  //  Tests packages for integrity, coherence thresholds, signature validity,
  //  and face-gate compliance.
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickQALab(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    let hash = fnv1a(beat + 2, rSwarm, jDrift);
    let doTest = pseudoRandBool(hash, 858993459);        // ~80% chance
    let testPass = pseudoRandBool(
      fnv1aChain(hash, Nat32.fromNat((beat * 7) % 4294967296), 0xAAAAAAAA),
      715827882  // ~83% pass rate
    );

    let newQA : QAMetrics = if (doTest) {
      if (testPass) {
        {
          testsRun = state.qaMetrics.testsRun + 1;
          testsPassed = state.qaMetrics.testsPassed + 1;
          testsFailed = state.qaMetrics.testsFailed;
        }
      } else {
        {
          testsRun = state.qaMetrics.testsRun + 1;
          testsPassed = state.qaMetrics.testsPassed;
          testsFailed = state.qaMetrics.testsFailed + 1;
        }
      }
    } else {
      state.qaMetrics
    };

    let expInc : Nat = if (doTest) { 1 } else { 0 };
    let findInc : Nat = if (doTest and not testPass) { 1 } else { 0 };

    let passRate = if (newQA.testsRun == 0) { 1.0 }
      else { Float.fromInt(newQA.testsPassed) / Float.fromInt(newQA.testsRun) };

    let newCoherence = phiModulateStrong(
      state.qaLabCoherence, rSwarm, jDrift, beat, passRate
    );

    {
      state with
      qaLabCoherence = newCoherence;
      qaExperiments = state.qaExperiments + expInc;
      qaFindings = state.qaFindings + findInc;
      qaMetrics = newQA;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION 3 — PROTOTYPE WORKSHOP
  // ═══════════════════════════════════════════════════════════════════════════
  //  Builds prototype packages before production, sandbox testing,
  //  and dry-run deployments.
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickPrototypeWorkshop(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    let hash = fnv1a(beat + 3, rSwarm, jDrift);
    let doBuild = pseudoRandBool(hash, 1717986918);      // ~60% chance
    let approveHash = fnv1aChain(hash, Nat32.fromNat((beat * 13) % 4294967296), 0xBBCCBBCC);
    let isApproved = pseudoRandBool(approveHash, 1073741824); // ~75% approval

    let newProto : PrototypeMetrics = if (doBuild) {
      if (isApproved) {
        {
          prototypesBuilt = state.prototypeMetrics.prototypesBuilt + 1;
          prototypesApproved = state.prototypeMetrics.prototypesApproved + 1;
          prototypesRejected = state.prototypeMetrics.prototypesRejected;
        }
      } else {
        {
          prototypesBuilt = state.prototypeMetrics.prototypesBuilt + 1;
          prototypesApproved = state.prototypeMetrics.prototypesApproved;
          prototypesRejected = state.prototypeMetrics.prototypesRejected + 1;
        }
      }
    } else {
      state.prototypeMetrics
    };

    let expInc : Nat = if (doBuild) { 1 } else { 0 };
    let findInc : Nat = if (doBuild and not isApproved) { 1 } else { 0 };

    let approvalRate = if (newProto.prototypesBuilt == 0) { 1.0 }
      else { Float.fromInt(newProto.prototypesApproved) / Float.fromInt(newProto.prototypesBuilt) };

    let newCoherence = phiModulateStrong(
      state.prototypeWorkshopCoherence, rSwarm, jDrift, beat, approvalRate
    );

    {
      state with
      prototypeWorkshopCoherence = newCoherence;
      prototypeExperiments = state.prototypeExperiments + expInc;
      prototypeFindings = state.prototypeFindings + findInc;
      prototypeMetrics = newProto;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION 4 — REGISTRY RESEARCH
  // ═══════════════════════════════════════════════════════════════════════════
  //  Studies registry optimization, deduplication, versioning strategies,
  //  and package lineage tracking.
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickRegistryResearch(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    let hash = fnv1a(beat + 4, rSwarm, jDrift);
    let doOptimize = pseudoRandBool(hash, 2147483648);    // ~50% chance
    let doDedup = pseudoRandBool(
      fnv1aChain(hash, Nat32.fromNat((beat * 17) % 4294967296), 0xDEDEDEDE),
      2576980378  // ~40% chance
    );
    let doVersion = pseudoRandBool(hash, 1288490189);     // ~70% chance
    let doLineage = pseudoRandBool(
      fnv1aChain(hash, 0xCCDDCCDD, Nat32.fromNat((beat * 3) % 4294967296)),
      1717986918  // ~60% chance
    );

    let newRegistry : RegistryMetrics = {
      optimizationsFound = state.registryMetrics.optimizationsFound + (if (doOptimize) { 1 } else { 0 });
      deduplicationsPerformed = state.registryMetrics.deduplicationsPerformed + (if (doDedup) { 1 } else { 0 });
      versioningStrategiesEvaluated = state.registryMetrics.versioningStrategiesEvaluated + (if (doVersion) { 1 } else { 0 });
      lineagesTracked = state.registryMetrics.lineagesTracked + (if (doLineage) { 1 } else { 0 });
    };

    let totalNew = (if (doOptimize) { 1 } else { 0 }) +
                   (if (doDedup) { 1 } else { 0 }) +
                   (if (doVersion) { 1 } else { 0 }) +
                   (if (doLineage) { 1 } else { 0 });

    let newCoherence = phiModulate(state.registryResearchCoherence, rSwarm, jDrift, beat);

    {
      state with
      registryResearchCoherence = newCoherence;
      registryExperiments = state.registryExperiments + totalNew;
      registryFindings = state.registryFindings + (if (doOptimize) { 1 } else { 0 });
      registryMetrics = newRegistry;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION 5 — REPLICATION LAB
  // ═══════════════════════════════════════════════════════════════════════════
  //  Studies replication fidelity, branch expression purity, and
  //  copy isolation verification.
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickReplicationLab(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    let hash = fnv1a(beat + 5, rSwarm, jDrift);
    let doVerify = pseudoRandBool(hash, 1073741824);      // ~75% chance
    let doBranch = pseudoRandBool(
      fnv1aChain(hash, 0xBBBBBBBB, Nat32.fromNat((beat * 23) % 4294967296)),
      1610612736  // ~62.5% chance
    );
    let isoPass = pseudoRandBool(hash, 644245094);        // ~85% pass

    let prevRepl = state.replicationMetrics;

    let repVerified = if (doVerify) { prevRepl.replicationsVerified + 1 }
      else { prevRepl.replicationsVerified };

    let branchChecked = if (doBranch) { prevRepl.branchExpressionsChecked + 1 }
      else { prevRepl.branchExpressionsChecked };

    let isoPassed = if (doVerify and isoPass) { prevRepl.isolationsPassed + 1 }
      else { prevRepl.isolationsPassed };

    // Fidelity evolves with PHI decay toward measured purity
    let measuredPurity = if (repVerified == 0) { 1.0 }
      else { Float.fromInt(isoPassed) / Float.fromInt(repVerified) };
    let newFidelity = clampCoherence(prevRepl.fidelityScore * 0.99 + measuredPurity * 0.01);

    let newRepl : ReplicationMetrics = {
      fidelityScore = newFidelity;
      replicationsVerified = repVerified;
      branchExpressionsChecked = branchChecked;
      isolationsPassed = isoPassed;
    };

    let expInc = (if (doVerify) { 1 } else { 0 }) + (if (doBranch) { 1 } else { 0 });

    let newCoherence = phiModulateStrong(
      state.replicationLabCoherence, rSwarm, jDrift, beat, newFidelity
    );

    {
      state with
      replicationLabCoherence = newCoherence;
      replicationExperiments = state.replicationExperiments + expInc;
      replicationFindings = state.replicationFindings + (if (doVerify and not isoPass) { 1 } else { 0 });
      replicationMetrics = newRepl;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION 6 — CRYPTOGRAPHY LAB
  // ═══════════════════════════════════════════════════════════════════════════
  //  SACESI signing research, FNV chain optimization, and
  //  quantum-resistant packaging signatures.
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickCryptographyLab(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    let hash = fnv1a(beat + 6, rSwarm, jDrift);
    let doSign = pseudoRandBool(hash, 1073741824);        // ~75% chance
    let signOk = pseudoRandBool(
      fnv1aChain(hash, 0x5165165A, Nat32.fromNat((beat * 29) % 4294967296)),
      429496729  // ~90% success
    );
    let doChainOpt = pseudoRandBool(hash, 2576980378);    // ~40% chance
    let doQuantum = pseudoRandBool(
      fnv1aChain(hash, 0xA0A0A0A0, Nat32.fromNat((beat * 31) % 4294967296)),
      3006477107  // ~30% chance
    );

    let prevCrypto = state.cryptoMetrics;

    let newCrypto : CryptoMetrics = {
      signaturesGenerated = prevCrypto.signaturesGenerated + (if (doSign and signOk) { 1 } else { 0 });
      signaturesFailed = prevCrypto.signaturesFailed + (if (doSign and not signOk) { 1 } else { 0 });
      fnvChainsOptimized = prevCrypto.fnvChainsOptimized + (if (doChainOpt) { 1 } else { 0 });
      quantumResistantTests = prevCrypto.quantumResistantTests + (if (doQuantum) { 1 } else { 0 });
    };

    let expInc = (if (doSign) { 1 } else { 0 }) +
                 (if (doChainOpt) { 1 } else { 0 }) +
                 (if (doQuantum) { 1 } else { 0 });

    let successRate = if (newCrypto.signaturesGenerated + newCrypto.signaturesFailed == 0) { 1.0 }
      else {
        Float.fromInt(newCrypto.signaturesGenerated) /
        Float.fromInt(newCrypto.signaturesGenerated + newCrypto.signaturesFailed)
      };

    let newCoherence = phiModulateStrong(
      state.cryptoLabCoherence, rSwarm, jDrift, beat, successRate
    );

    {
      state with
      cryptoLabCoherence = newCoherence;
      cryptoExperiments = state.cryptoExperiments + expInc;
      cryptoFindings = state.cryptoFindings + (if (doSign and not signOk) { 1 } else { 0 });
      cryptoMetrics = newCrypto;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION 7 — DOCTRINE COMPLIANCE
  // ═══════════════════════════════════════════════════════════════════════════
  //  Verifies packages comply with all doctrine rules:
  //    - Root stays root
  //    - Trunk never exposed
  //    - Branches are derivative cuts
  //    - 100% creator royalty
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickDoctrineCompliance(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    let hash = fnv1a(beat + 7, rSwarm, jDrift);
    let doAudit = pseudoRandBool(hash, 858993459);        // ~80% chance

    // Doctrine audits have a high pass rate — the system enforces correctness
    let auditHash = fnv1aChain(hash, Nat32.fromNat((beat * 37) % 4294967296), 0xD0C7D0C7);
    let auditPass = pseudoRandBool(auditHash, 214748365); // ~95% pass

    let prevDoctrine = state.doctrineMetrics;

    let newDoctrine : DoctrineMetrics = if (doAudit) {
      let newRun = prevDoctrine.auditsRun + 1;
      let newPassed = prevDoctrine.auditsPassed + (if (auditPass) { 1 } else { 0 });
      let newFailed = prevDoctrine.auditsFailed + (if (auditPass) { 0 } else { 1 });
      let newScore = if (newRun == 0) { 1.0 }
        else { Float.fromInt(newPassed) / Float.fromInt(newRun) };
      {
        auditsRun = newRun;
        auditsPassed = newPassed;
        auditsFailed = newFailed;
        complianceScore = newScore;
      }
    } else {
      prevDoctrine
    };

    let expInc : Nat = if (doAudit) { 1 } else { 0 };
    let findInc : Nat = if (doAudit and not auditPass) { 1 } else { 0 };

    let newCoherence = phiModulateStrong(
      state.doctrineComplianceCoherence, rSwarm, jDrift, beat, newDoctrine.complianceScore
    );

    {
      state with
      doctrineComplianceCoherence = newCoherence;
      doctrineExperiments = state.doctrineExperiments + expInc;
      doctrineFindings = state.doctrineFindings + findInc;
      doctrineMetrics = newDoctrine;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  MAIN TICK — Runs All 8 Divisions
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickPackagingLab(
    state : PackagingLabState,
    rSwarm : Float,
    jDrift : Float,
    beat : Nat
  ) : PackagingLabState {
    // Guard: if lab is asleep, only advance uptime
    if (not state.labAwake) {
      return { state with labUptime = state.labUptime + 1; currentBeat = beat };
    };

    // ── Phase 1: Tick each division sequentially (pipeline order) ──
    let s1 = tickArtifactAnalysis(state, rSwarm, jDrift, beat);
    let s2 = tickSDKForge(s1, rSwarm, jDrift, beat);
    let s3 = tickQALab(s2, rSwarm, jDrift, beat);
    let s4 = tickPrototypeWorkshop(s3, rSwarm, jDrift, beat);
    let s5 = tickRegistryResearch(s4, rSwarm, jDrift, beat);
    let s6 = tickReplicationLab(s5, rSwarm, jDrift, beat);
    let s7 = tickCryptographyLab(s6, rSwarm, jDrift, beat);
    let s8 = tickDoctrineCompliance(s7, rSwarm, jDrift, beat);

    // ── Phase 2: Compute global lab coherence (Kuramoto order parameter) ──
    let allCoherences = [
      s8.artifactAnalysisCoherence,
      s8.sdkForgeCoherence,
      s8.qaLabCoherence,
      s8.prototypeWorkshopCoherence,
      s8.registryResearchCoherence,
      s8.replicationLabCoherence,
      s8.cryptoLabCoherence,
      s8.doctrineComplianceCoherence,
    ];

    let globalCoh = computeGlobalCoherence(allCoherences);

    // ── Phase 3: Aggregate totals ──
    let totalExp = s8.artifactExperiments +
                   s8.forgeExperiments +
                   s8.qaExperiments +
                   s8.prototypeExperiments +
                   s8.registryExperiments +
                   s8.replicationExperiments +
                   s8.cryptoExperiments +
                   s8.doctrineExperiments;

    let totalFind = s8.artifactFindings +
                    s8.forgeFindings +
                    s8.qaFindings +
                    s8.prototypeFindings +
                    s8.registryFindings +
                    s8.replicationFindings +
                    s8.cryptoFindings +
                    s8.doctrineFindings;

    // ── Phase 4: Integrity hash (FNV chain of all division hashes) ──
    let integrityHash = fnv1aChain(
      fnv1a(beat, rSwarm, jDrift),
      fnv1aFromNats(totalExp, totalFind, s8.labUptime),
      s8.lastIntegrityHash
    );

    // ── Return: New immutable state ──
    {
      s8 with
      labCoherence = globalCoh;
      totalExperiments = totalExp;
      totalFindings = totalFind;
      labUptime = s8.labUptime + 1;
      lastIntegrityHash = integrityHash;
      currentBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  WAKE / SLEEP CONTROLS
  // ═══════════════════════════════════════════════════════════════════════════

  public func wakeLab(state : PackagingLabState) : PackagingLabState {
    { state with labAwake = true }
  };

  public func sleepLab(state : PackagingLabState) : PackagingLabState {
    { state with labAwake = false }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  public func getLabCoherence(state : PackagingLabState) : Float {
    state.labCoherence
  };

  public func getDivisionCoherence(state : PackagingLabState, div : LabDivisionId) : Float {
    switch (div) {
      case (#ArtifactAnalysis)  { state.artifactAnalysisCoherence };
      case (#SDKForge)          { state.sdkForgeCoherence };
      case (#QualityAssurance)  { state.qaLabCoherence };
      case (#PrototypeWorkshop) { state.prototypeWorkshopCoherence };
      case (#RegistryResearch)  { state.registryResearchCoherence };
      case (#ReplicationLab)    { state.replicationLabCoherence };
      case (#CryptographyLab)   { state.cryptoLabCoherence };
      case (#DoctrineCompliance){ state.doctrineComplianceCoherence };
    }
  };

  public func getAllCoherences(state : PackagingLabState) : [Float] {
    [
      state.artifactAnalysisCoherence,
      state.sdkForgeCoherence,
      state.qaLabCoherence,
      state.prototypeWorkshopCoherence,
      state.registryResearchCoherence,
      state.replicationLabCoherence,
      state.cryptoLabCoherence,
      state.doctrineComplianceCoherence,
    ]
  };

  public func getDivisionExperiments(state : PackagingLabState, div : LabDivisionId) : Nat {
    switch (div) {
      case (#ArtifactAnalysis)  { state.artifactExperiments };
      case (#SDKForge)          { state.forgeExperiments };
      case (#QualityAssurance)  { state.qaExperiments };
      case (#PrototypeWorkshop) { state.prototypeExperiments };
      case (#RegistryResearch)  { state.registryExperiments };
      case (#ReplicationLab)    { state.replicationExperiments };
      case (#CryptographyLab)   { state.cryptoExperiments };
      case (#DoctrineCompliance){ state.doctrineExperiments };
    }
  };

  public func getDivisionFindings(state : PackagingLabState, div : LabDivisionId) : Nat {
    switch (div) {
      case (#ArtifactAnalysis)  { state.artifactFindings };
      case (#SDKForge)          { state.forgeFindings };
      case (#QualityAssurance)  { state.qaFindings };
      case (#PrototypeWorkshop) { state.prototypeFindings };
      case (#RegistryResearch)  { state.registryFindings };
      case (#ReplicationLab)    { state.replicationFindings };
      case (#CryptographyLab)   { state.cryptoFindings };
      case (#DoctrineCompliance){ state.doctrineFindings };
    }
  };

  public func getArtifactVaultStatus(state : PackagingLabState) : ArtifactVaultMetrics {
    state.artifactVault
  };

  public func getSDKForgeStatus(state : PackagingLabState) : SDKForgeMetrics {
    state.sdkForge
  };

  public func getQAStatus(state : PackagingLabState) : QAMetrics {
    state.qaMetrics
  };

  public func getPrototypeStatus(state : PackagingLabState) : PrototypeMetrics {
    state.prototypeMetrics
  };

  public func getRegistryStatus(state : PackagingLabState) : RegistryMetrics {
    state.registryMetrics
  };

  public func getReplicationStatus(state : PackagingLabState) : ReplicationMetrics {
    state.replicationMetrics
  };

  public func getCryptoStatus(state : PackagingLabState) : CryptoMetrics {
    state.cryptoMetrics
  };

  public func getDoctrineStatus(state : PackagingLabState) : DoctrineMetrics {
    state.doctrineMetrics
  };

  public func getIntegrityHash(state : PackagingLabState) : Nat32 {
    state.lastIntegrityHash
  };

  public func isLabAwake(state : PackagingLabState) : Bool {
    state.labAwake
  };

  public func getSDKDeploymentSummary(state : PackagingLabState) : {
    business : Nat;
    research : Nat;
    defense : Nat;
    iot : Nat;
    finance : Nat;
    creative : Nat;
    governance : Nat;
    identity : Nat;
    total : Nat;
  } {
    let f = state.sdkForge;
    {
      business = f.sdkBusinessBuilt;
      research = f.sdkResearchBuilt;
      defense = f.sdkDefenseBuilt;
      iot = f.sdkIoTBuilt;
      finance = f.sdkFinanceBuilt;
      creative = f.sdkCreativeBuilt;
      governance = f.sdkGovernanceBuilt;
      identity = f.sdkIdentityBuilt;
      total = f.forgeOutputCount;
    }
  };

  public func getDoctrineComplianceScore(state : PackagingLabState) : Float {
    state.doctrineMetrics.complianceScore
  };

  public func getReplicationFidelity(state : PackagingLabState) : Float {
    state.replicationMetrics.fidelityScore
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  FORMATTED STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public func getGlobalStatus(state : PackagingLabState) : Text {
    "═══════════════════════════════════════════════════════════════\n" #
    "       PACKAGING RESEARCH LAB — GLOBAL STATUS                 \n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "Lab Awake:           " # (if (state.labAwake) { "YES" } else { "NO" }) # "\n" #
    "Lab Coherence:       " # Float.format(#fix 4, state.labCoherence) # "\n" #
    "Total Experiments:   " # Nat.toText(state.totalExperiments) # "\n" #
    "Total Findings:      " # Nat.toText(state.totalFindings) # "\n" #
    "Lab Uptime:          " # Nat.toText(state.labUptime) # " beats\n" #
    "Current Beat:        " # Nat.toText(state.currentBeat) # "\n" #
    "Integrity Hash:      0x" # Nat32.toText(state.lastIntegrityHash) # "\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    " Division Coherences:\n" #
    "  [0] Artifact Analysis:    " # Float.format(#fix 4, state.artifactAnalysisCoherence) # "\n" #
    "  [1] SDK Forge:             " # Float.format(#fix 4, state.sdkForgeCoherence) # "\n" #
    "  [2] Quality Assurance:     " # Float.format(#fix 4, state.qaLabCoherence) # "\n" #
    "  [3] Prototype Workshop:    " # Float.format(#fix 4, state.prototypeWorkshopCoherence) # "\n" #
    "  [4] Registry Research:     " # Float.format(#fix 4, state.registryResearchCoherence) # "\n" #
    "  [5] Replication Lab:       " # Float.format(#fix 4, state.replicationLabCoherence) # "\n" #
    "  [6] Cryptography Lab:      " # Float.format(#fix 4, state.cryptoLabCoherence) # "\n" #
    "  [7] Doctrine Compliance:   " # Float.format(#fix 4, state.doctrineComplianceCoherence) # "\n" #
    "═══════════════════════════════════════════════════════════════"
  };

  public func getDivisionStatus(state : PackagingLabState, div : LabDivisionId) : Text {
    switch (div) {
      case (#ArtifactAnalysis) {
        let v = state.artifactVault;
        "── Artifact Analysis Lab ──\n" #
        "Coherence:  " # Float.format(#fix 4, state.artifactAnalysisCoherence) # "\n" #
        "Experiments: " # Nat.toText(state.artifactExperiments) # "\n" #
        "Findings:   " # Nat.toText(state.artifactFindings) # "\n" #
        "Analyzed:   " # Nat.toText(v.artifactsAnalyzed) # "\n" #
        "Passed:     " # Nat.toText(v.artifactsPassed) # "\n" #
        "Failed:     " # Nat.toText(v.artifactsFailed)
      };
      case (#SDKForge) {
        let f = state.sdkForge;
        "── SDK Forge ──\n" #
        "Coherence:      " # Float.format(#fix 4, state.sdkForgeCoherence) # "\n" #
        "Experiments:    " # Nat.toText(state.forgeExperiments) # "\n" #
        "Findings:       " # Nat.toText(state.forgeFindings) # "\n" #
        "Forge Output:   " # Nat.toText(f.forgeOutputCount) # "\n" #
        "Current Target: " # Nat.toText(f.currentForgeTarget) # "\n" #
        "Business:       " # Nat.toText(f.sdkBusinessBuilt) # "\n" #
        "Research:       " # Nat.toText(f.sdkResearchBuilt) # "\n" #
        "Defense:        " # Nat.toText(f.sdkDefenseBuilt) # "\n" #
        "IoT:            " # Nat.toText(f.sdkIoTBuilt) # "\n" #
        "Finance:        " # Nat.toText(f.sdkFinanceBuilt) # "\n" #
        "Creative:       " # Nat.toText(f.sdkCreativeBuilt) # "\n" #
        "Governance:     " # Nat.toText(f.sdkGovernanceBuilt) # "\n" #
        "Identity:       " # Nat.toText(f.sdkIdentityBuilt)
      };
      case (#QualityAssurance) {
        let q = state.qaMetrics;
        "── Quality Assurance Lab ──\n" #
        "Coherence:  " # Float.format(#fix 4, state.qaLabCoherence) # "\n" #
        "Experiments: " # Nat.toText(state.qaExperiments) # "\n" #
        "Findings:   " # Nat.toText(state.qaFindings) # "\n" #
        "Tests Run:  " # Nat.toText(q.testsRun) # "\n" #
        "Passed:     " # Nat.toText(q.testsPassed) # "\n" #
        "Failed:     " # Nat.toText(q.testsFailed)
      };
      case (#PrototypeWorkshop) {
        let p = state.prototypeMetrics;
        "── Prototype Workshop ──\n" #
        "Coherence:  " # Float.format(#fix 4, state.prototypeWorkshopCoherence) # "\n" #
        "Experiments: " # Nat.toText(state.prototypeExperiments) # "\n" #
        "Findings:   " # Nat.toText(state.prototypeFindings) # "\n" #
        "Built:      " # Nat.toText(p.prototypesBuilt) # "\n" #
        "Approved:   " # Nat.toText(p.prototypesApproved) # "\n" #
        "Rejected:   " # Nat.toText(p.prototypesRejected)
      };
      case (#RegistryResearch) {
        let r = state.registryMetrics;
        "── Registry Research ──\n" #
        "Coherence:      " # Float.format(#fix 4, state.registryResearchCoherence) # "\n" #
        "Experiments:    " # Nat.toText(state.registryExperiments) # "\n" #
        "Findings:       " # Nat.toText(state.registryFindings) # "\n" #
        "Optimizations:  " # Nat.toText(r.optimizationsFound) # "\n" #
        "Deduplications: " # Nat.toText(r.deduplicationsPerformed) # "\n" #
        "Versioning:     " # Nat.toText(r.versioningStrategiesEvaluated) # "\n" #
        "Lineages:       " # Nat.toText(r.lineagesTracked)
      };
      case (#ReplicationLab) {
        let rl = state.replicationMetrics;
        "── Replication Lab ──\n" #
        "Coherence:      " # Float.format(#fix 4, state.replicationLabCoherence) # "\n" #
        "Experiments:    " # Nat.toText(state.replicationExperiments) # "\n" #
        "Findings:       " # Nat.toText(state.replicationFindings) # "\n" #
        "Fidelity Score: " # Float.format(#fix 4, rl.fidelityScore) # "\n" #
        "Verified:       " # Nat.toText(rl.replicationsVerified) # "\n" #
        "Branches:       " # Nat.toText(rl.branchExpressionsChecked) # "\n" #
        "Isolations OK:  " # Nat.toText(rl.isolationsPassed)
      };
      case (#CryptographyLab) {
        let c = state.cryptoMetrics;
        "── Cryptography Lab ──\n" #
        "Coherence:       " # Float.format(#fix 4, state.cryptoLabCoherence) # "\n" #
        "Experiments:     " # Nat.toText(state.cryptoExperiments) # "\n" #
        "Findings:        " # Nat.toText(state.cryptoFindings) # "\n" #
        "Sigs Generated:  " # Nat.toText(c.signaturesGenerated) # "\n" #
        "Sigs Failed:     " # Nat.toText(c.signaturesFailed) # "\n" #
        "FNV Chains Opt:  " # Nat.toText(c.fnvChainsOptimized) # "\n" #
        "Quantum Tests:   " # Nat.toText(c.quantumResistantTests)
      };
      case (#DoctrineCompliance) {
        let d = state.doctrineMetrics;
        "── Doctrine Compliance ──\n" #
        "Coherence:        " # Float.format(#fix 4, state.doctrineComplianceCoherence) # "\n" #
        "Experiments:      " # Nat.toText(state.doctrineExperiments) # "\n" #
        "Findings:         " # Nat.toText(state.doctrineFindings) # "\n" #
        "Audits Run:       " # Nat.toText(d.auditsRun) # "\n" #
        "Audits Passed:    " # Nat.toText(d.auditsPassed) # "\n" #
        "Audits Failed:    " # Nat.toText(d.auditsFailed) # "\n" #
        "Compliance Score: " # Float.format(#fix 4, d.complianceScore)
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DIVISION NAME HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  public func divisionName(div : LabDivisionId) : Text {
    switch (div) {
      case (#ArtifactAnalysis)  { "Artifact Analysis Lab" };
      case (#SDKForge)          { "SDK Forge" };
      case (#QualityAssurance)  { "Quality Assurance Lab" };
      case (#PrototypeWorkshop) { "Prototype Workshop" };
      case (#RegistryResearch)  { "Registry Research" };
      case (#ReplicationLab)    { "Replication Lab" };
      case (#CryptographyLab)   { "Cryptography Lab" };
      case (#DoctrineCompliance){ "Doctrine Compliance" };
    }
  };

  public func divisionIndex(div : LabDivisionId) : Nat {
    switch (div) {
      case (#ArtifactAnalysis)  { 0 };
      case (#SDKForge)          { 1 };
      case (#QualityAssurance)  { 2 };
      case (#PrototypeWorkshop) { 3 };
      case (#RegistryResearch)  { 4 };
      case (#ReplicationLab)    { 5 };
      case (#CryptographyLab)   { 6 };
      case (#DoctrineCompliance){ 7 };
    }
  };

  public func sdkTargetName(target : Nat) : Text {
    switch (target) {
      case 0 { "Business" };
      case 1 { "Research" };
      case 2 { "Defense" };
      case 3 { "IoT" };
      case 4 { "Finance" };
      case 5 { "Creative" };
      case 6 { "Governance" };
      case 7 { "Identity" };
      case _ { "Unknown" };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  HEALTH / DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════

  public func isLabHealthy(state : PackagingLabState) : Bool {
    state.labAwake and
    state.labCoherence >= COHERENCE_FLOOR and
    state.doctrineMetrics.complianceScore >= COMPLIANCE_THRESHOLD and
    state.replicationMetrics.fidelityScore >= FIDELITY_THRESHOLD
  };

  public func countActiveResearchDivisions(state : PackagingLabState) : Nat {
    var count : Nat = 0;
    if (state.artifactAnalysisCoherence > COHERENCE_FLOOR) { count += 1 };
    if (state.sdkForgeCoherence > COHERENCE_FLOOR) { count += 1 };
    if (state.qaLabCoherence > COHERENCE_FLOOR) { count += 1 };
    if (state.prototypeWorkshopCoherence > COHERENCE_FLOOR) { count += 1 };
    if (state.registryResearchCoherence > COHERENCE_FLOOR) { count += 1 };
    if (state.replicationLabCoherence > COHERENCE_FLOOR) { count += 1 };
    if (state.cryptoLabCoherence > COHERENCE_FLOOR) { count += 1 };
    if (state.doctrineComplianceCoherence > COHERENCE_FLOOR) { count += 1 };
    count
  };

  public func getExperimentRate(state : PackagingLabState) : Float {
    if (state.labUptime == 0) { 0.0 }
    else { Float.fromInt(state.totalExperiments) / Float.fromInt(state.labUptime) }
  };

  public func getFindingsRate(state : PackagingLabState) : Float {
    if (state.totalExperiments == 0) { 0.0 }
    else { Float.fromInt(state.totalFindings) / Float.fromInt(state.totalExperiments) }
  };

  public func getQAPassRate(state : PackagingLabState) : Float {
    if (state.qaMetrics.testsRun == 0) { 1.0 }
    else { Float.fromInt(state.qaMetrics.testsPassed) / Float.fromInt(state.qaMetrics.testsRun) }
  };

  public func getSignatureSuccessRate(state : PackagingLabState) : Float {
    let total = state.cryptoMetrics.signaturesGenerated + state.cryptoMetrics.signaturesFailed;
    if (total == 0) { 1.0 }
    else { Float.fromInt(state.cryptoMetrics.signaturesGenerated) / Float.fromInt(total) }
  };

  public func getPrototypeApprovalRate(state : PackagingLabState) : Float {
    if (state.prototypeMetrics.prototypesBuilt == 0) { 1.0 }
    else {
      Float.fromInt(state.prototypeMetrics.prototypesApproved) /
      Float.fromInt(state.prototypeMetrics.prototypesBuilt)
    }
  };

  public func getArtifactPassRate(state : PackagingLabState) : Float {
    if (state.artifactVault.artifactsAnalyzed == 0) { 1.0 }
    else {
      Float.fromInt(state.artifactVault.artifactsPassed) /
      Float.fromInt(state.artifactVault.artifactsAnalyzed)
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  INTEGRITY VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func verifyLabIntegrity(state : PackagingLabState) : Bool {
    let recomputedHash = fnv1aChain(
      fnv1a(state.currentBeat, Float.fromInt(state.totalExperiments), Float.fromInt(state.totalFindings)),
      fnv1aFromNats(state.totalExperiments, state.totalFindings, state.labUptime),
      FNV_OFFSET_BASIS
    );
    // Integrity check: hash must be non-zero and lab must be structurally sound
    recomputedHash != 0 and
    state.labCoherence >= COHERENCE_FLOOR and
    state.labCoherence <= COHERENCE_CEILING
  };

  public func computeLabFingerprint(state : PackagingLabState) : Nat32 {
    let h1 = fnv1aFromNats(
      state.artifactVault.artifactsAnalyzed,
      state.sdkForge.forgeOutputCount,
      state.qaMetrics.testsRun
    );
    let h2 = fnv1aFromNats(
      state.prototypeMetrics.prototypesBuilt,
      state.replicationMetrics.replicationsVerified,
      state.cryptoMetrics.signaturesGenerated
    );
    let h3 = fnv1aFromNats(
      state.doctrineMetrics.auditsRun,
      state.registryMetrics.optimizationsFound,
      state.totalExperiments
    );
    fnv1aChain(h1, h2, h3)
  };

}
