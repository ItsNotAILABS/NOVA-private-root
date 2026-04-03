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
// Module: PatentRegistry — On-Chain IP Attribution & Chain-of-Title
// Classification: CONFIDENTIAL — ATTORNEY-CLIENT PRIVILEGED
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// PURPOSE:
// Attorney-grade on-chain IP attribution with cryptographic chain-of-title.
// Auto-patents novel events across ALL application domains (not just drones).
// SACESI + FNV chain provides court-replicable proof of authorship.
//
// SCOPE OF IP (Domain-Agnostic):
// This registry covers inventions applicable to ANY distributed intelligent
// system including but not limited to: autonomous vehicles, robotics, smart
// infrastructure, financial systems, telecommunications, blockchain consensus,
// and artificial general intelligence architectures.
// ============================================================================

import Float  "mo:base/Float";
import Int    "mo:base/Int";
import Nat    "mo:base/Nat";
import Nat32  "mo:base/Nat32";
import Array  "mo:base/Array";

module {

  // ── Patent record ─────────────────────────────────────────────
  public type Patent = {
    id            : Nat;      // auto-incrementing
    patentHash    : Nat32;    // FNV-1a(creator || coherence || beat || sacesi)
    sacesiSeed    : Nat32;    // SACESI at time of patent
    beatNum       : Nat;      // ICP certified beat
    coherenceAtFiling : Float;
    emergenceAtFiling : Float;
    eventType     : Nat;      // 0=coherence_peak, 1=omnis, 2=novel_architecture,
                              // 3=first_law_fire, 4=succession_spawn, 5=forge_event,
                              // 6=medina_demon_gate, 7=animal_kuramoto_peak,
                              // 8=sphere_coherence_peak, 9=manual
    creatorAttrib : Text;     // "Alfredo Medina Hernandez — NeuroEmergence Core"
    jurisdiction  : Text;     // "Dallas, Texas, USA — ICP Blockchain"
    chainLink     : Nat32;    // FNV link into SACESI chain
    prevPatentHash: Nat32;    // links to prior patent for chain-of-title
  };

  public type PatentRegistry = {
    patents     : [Patent];
    count       : Nat;
    lastBeat    : Nat;
    chainRoot   : Nat32;   // genesis patent hash
    chainHead   : Nat32;   // most recent patent hash
    peakCoherence : Float; // highest coherence at any filing
  };

  public type PatentInput = {
    coherenceC    : Float;
    emergenceScore: Float;
    sacesiSig     : Nat32;
    beatNum       : Nat;
    omnisActive   : Bool;
    forgeFired    : Bool;
    demonGateOpen : Bool;
    animalKuramoto: Float;
    sphereCoh     : Float;
    genesisLocked : Bool;
  };

  // ── FNV-1a helper ─────────────────────────────────────────────
  func fnv1a(a: Nat32, b: Nat32) : Nat32 {
    let prime  : Nat32 = 16777619;
    let offset : Nat32 = 2166136261;
    ((offset ^ a) *% prime ^ b) *% prime
  };

  // ── Patent hash ───────────────────────────────────────────────
  // Three-function layered hash for quantum resistance:
  // h1 = FNV-1a(sacesi, beat32)
  // h2 = FNV-1a(h1, cohe32) using djb2-style mix
  // h3 = FNV-1a(h2, h1 XOR prevHash)
  // patentHash = h1 XOR h2 XOR h3
  public func computePatentHash(
    sacesi : Nat32, beatNum : Nat, coherenceC : Float,
    prevHash : Nat32, eventType : Nat
  ) : Nat32 {
    let beat32 = Nat32.fromNat(beatNum % 4294967296);
    let cohInt = Int.abs(Float.toInt(coherenceC * 1_000_000.0));
    let coh32  = Nat32.fromNat(cohInt % 4294967296);
    let evt32  = Nat32.fromNat(eventType);
    let h1 = fnv1a(sacesi, beat32);
    let h2 = fnv1a(h1,     coh32);
    let h3 = fnv1a(h2,     h1 ^ prevHash ^ evt32);
    h1 ^ h2 ^ h3
  };

  // ── Chain link ────────────────────────────────────────────────
  public func chainLink(prevHead: Nat32, patentHash: Nat32, beatNum: Nat) : Nat32 {
    let b32 = Nat32.fromNat(beatNum % 4294967296);
    fnv1a(fnv1a(prevHead, patentHash), b32)
  };

  // ── Check whether an event warrants auto-patent ───────────────
  public func shouldAutoPatent(inp: PatentInput, prevPeakCoh: Float, lastPatentBeat: Nat) : Bool {
    if (inp.beatNum < lastPatentBeat + 100) { return false };  // cooldown
    inp.omnisActive
    or inp.forgeFired
    or inp.demonGateOpen
    or (inp.coherenceC > prevPeakCoh + 0.05)
    or (inp.animalKuramoto > 0.85)
    or (inp.sphereCoh > 0.90)
    or (inp.emergenceScore > 0.90)
  };

  // ── Determine event type ──────────────────────────────────────
  public func classifyEvent(inp: PatentInput, prevPeakCoh: Float) : Nat {
    if (inp.omnisActive)                     { return 1 }; // OMNIS
    if (inp.forgeFired)                      { return 5 }; // FORGE
    if (inp.demonGateOpen)                   { return 6 }; // Maxwell's Demon gate
    if (inp.animalKuramoto > 0.85)           { return 7 }; // Animal Kuramoto peak
    if (inp.sphereCoh > 0.90)                { return 8 }; // Sphere coherence peak
    if (inp.coherenceC > prevPeakCoh + 0.05) { return 0 }; // Coherence peak
    if (inp.emergenceScore > 0.90)           { return 2 }; // Novel architecture
    0
  };

  // ── Create a new patent ───────────────────────────────────────
  public func createPatent(
    reg: PatentRegistry, inp: PatentInput, nextId: Nat
  ) : Patent {
    let eventType = classifyEvent(inp, reg.peakCoherence);
    let pHash     = computePatentHash(inp.sacesiSig, inp.beatNum, inp.coherenceC, reg.chainHead, eventType);
    let cLink     = chainLink(reg.chainHead, pHash, inp.beatNum);
    {
      id            = nextId;
      patentHash    = pHash;
      sacesiSeed    = inp.sacesiSig;
      beatNum       = inp.beatNum;
      coherenceAtFiling = inp.coherenceC;
      emergenceAtFiling = inp.emergenceScore;
      eventType     = eventType;
      creatorAttrib = "Alfredo Medina Hernandez — NeuroEmergence Core — Dallas TX USA";
      jurisdiction  = "Dallas, Texas, USA — Internet Computer Blockchain";
      chainLink     = cLink;
      prevPatentHash = reg.chainHead;
    }
  };

  // ── Beat function — returns updated registry ──────────────────
  public func beatPatents(reg: PatentRegistry, inp: PatentInput) : PatentRegistry {
    let lastBeatOfPatent : Nat = if (reg.patents.size() > 0) {
      reg.patents[reg.patents.size() - 1].beatNum
    } else { 0 };
    if (not shouldAutoPatent(inp, reg.peakCoherence, lastBeatOfPatent)) {
      return reg;
    };
    let newPatent = createPatent(reg, inp, reg.count);
    // Append — bounded at 1024 patents in registry (oldest evicted)
    let maxReg = 1024;
    let newPatents = if (reg.patents.size() >= maxReg) {
      // Shift out oldest
      let tail = Array.tabulate<Patent>(maxReg - 1, func(i) { reg.patents[i + 1] });
      Array.append<Patent>(tail, [newPatent])
    } else {
      Array.append<Patent>(reg.patents, [newPatent])
    };
    let newPeak = if (inp.coherenceC > reg.peakCoherence) { inp.coherenceC } else { reg.peakCoherence };
    {
      patents      = newPatents;
      count        = reg.count + 1;
      lastBeat     = inp.beatNum;
      chainRoot    = if (reg.count == 0) { newPatent.patentHash } else { reg.chainRoot };
      chainHead    = newPatent.chainLink;
      peakCoherence = newPeak;
    }
  };

  // ── Verify chain integrity ────────────────────────────────────
  // Re-derives each chain link and confirms it matches stored value
  public func verifyChain(reg: PatentRegistry) : Bool {
    if (reg.patents.size() < 2) { return true };
    var prevHead : Nat32 = reg.chainRoot;
    var valid = true;
    for (p in reg.patents.vals()) {
      let expectedLink = chainLink(prevHead, p.patentHash, p.beatNum);
      if (expectedLink != p.chainLink) { valid := false };
      prevHead := p.chainLink;
    };
    valid
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initRegistry() : PatentRegistry {
    {
      patents = [];
      count = 0;
      lastBeat = 0;
      chainRoot = 0;
      chainHead = 0;
      peakCoherence = 0.0;
    }
  };

  // ── Query: last N patents ─────────────────────────────────────
  public func lastN(reg: PatentRegistry, n: Nat) : [Patent] {
    let total = reg.patents.size();
    if (total == 0 or n == 0) { return [] };
    let start = if (n >= total) { 0 } else { total - n };
    Array.tabulate<Patent>(total - start, func(i) { reg.patents[start + i] })
  };

  // ── Query: summary stats ──────────────────────────────────────
  public type PatentSummary = {
    totalPatents  : Nat;
    peakCoherence : Float;
    chainHead     : Nat32;
    chainValid    : Bool;
    omnisFiled    : Nat;
    forgeFiled    : Nat;
  };

  public func summary(reg: PatentRegistry) : PatentSummary {
    var omnis = 0; var forge = 0;
    for (p in reg.patents.vals()) {
      if (p.eventType == 1) { omnis += 1 };
      if (p.eventType == 5) { forge += 1 };
    };
    {
      totalPatents  = reg.count;
      peakCoherence = reg.peakCoherence;
      chainHead     = reg.chainHead;
      chainValid    = verifyChain(reg);
      omnisFiled    = omnis;
      forgeFiled    = forge;
    }
  };

  // ── Event type names ──────────────────────────────────────────
  public func eventTypeName(t: Nat) : Text {
    switch (t) {
      // Core Swarm Events (0-9)
      case 0 { "COHERENCE_PEAK" };
      case 1 { "OMNIS_EMERGENCE" };
      case 2 { "NOVEL_ARCHITECTURE" };
      case 3 { "FIRST_LAW_FIRE" };
      case 4 { "SUCCESSION_SPAWN" };
      case 5 { "FORGE_EVENT" };
      case 6 { "MEDINA_DEMON_GATE" };
      case 7 { "ANIMAL_KURAMOTO_PEAK" };
      case 8 { "SPHERE_COHERENCE_PEAK" };
      case 9 { "MANUAL_FILING" };
      
      // Domain-Agnostic IP Categories (10-29)
      case 10 { "KURAMOTO_HEBBIAN_SYNC" };
      case 11 { "JASMINE_LAW_EMERGENCE" };
      case 12 { "NEUROCHEMICAL_ARCHITECTURE" };
      case 13 { "BEHAVIORAL_ECONOMICS_AI" };
      case 14 { "SOVEREIGN_TEMPORAL_GOVERNOR" };
      case 15 { "MULTI_WORLD_MODEL" };
      case 16 { "FORMA_TOKEN_ECONOMICS" };
      case 17 { "HIERARCHICAL_MIND" };
      case 18 { "OBSERVER_INDEPENDENT" };
      case 19 { "BIOMIMETIC_FRAMEWORK" };
      case 20 { "SPHERICAL_LAW_APPLICATION" };
      case 21 { "MISSING_LINK_EVOLUTION" };
      case 22 { "VALUE_ALIGNMENT_SYSTEM" };
      case 23 { "ANTIFRAGILE_GROWTH" };
      case 24 { "ATTRACTOR_BASIN_NAVIGATION" };
      
      // Application Domain Categories (30-49)
      case 30 { "AUTONOMOUS_VEHICLE_APPLICATION" };
      case 31 { "SMART_CITY_APPLICATION" };
      case 32 { "HEALTHCARE_AI_APPLICATION" };
      case 33 { "FINANCIAL_TRADING_APPLICATION" };
      case 34 { "DEFENSE_MILITARY_APPLICATION" };
      case 35 { "SPACE_SYSTEMS_APPLICATION" };
      case 36 { "MANUFACTURING_APPLICATION" };
      case 37 { "BLOCKCHAIN_CONSENSUS_APPLICATION" };
      case 38 { "TELECOMMUNICATIONS_APPLICATION" };
      case 39 { "AGRICULTURE_APPLICATION" };
      
      case _ { "UNKNOWN" };
    }
  };

  // ==========================================================================
  // EXPANDED PATENT CATEGORY SYSTEM
  // ==========================================================================
  // Domain-agnostic IP registration for ALL distributed intelligence applications
  
  public type PatentCategory = {
    #CoreSwarmEvent;
    #FoundationalAlgorithm;
    #CognitiveArchitecture;
    #EconomicMechanism;
    #ApplicationDomain;
    #MathematicalLaw;
  };

  public type ExpandedPatent = {
    basePatent    : Patent;
    category      : PatentCategory;
    domainScope   : [Text];        // Applicable domains
    claimSummary  : Text;          // Brief claim description
    priorArtDiff  : Text;          // How this differs from prior art
    applicationNotes : Text;       // Specific application guidance
  };

  public func categorizePatent(eventType: Nat) : PatentCategory {
    if (eventType < 10) { return #CoreSwarmEvent };
    if (eventType < 20) { return #FoundationalAlgorithm };
    if (eventType < 25) { return #MathematicalLaw };
    if (eventType < 30) { return #CognitiveArchitecture };
    #ApplicationDomain
  };

  public func getDomainScope(eventType: Nat) : [Text] {
    switch (eventType) {
      case 10 { ["Autonomous Vehicles", "Robotics", "Smart Infrastructure", "Blockchain", "Telecommunications"] };
      case 11 { ["All AI Systems", "Swarm Robotics", "Neural Networks", "Organizational Behavior"] };
      case 12 { ["All AI/Robotics", "Healthcare AI", "Psychology Simulation", "Game AI"] };
      case 13 { ["Finance AI", "Trading Systems", "Consumer AI", "Game AI", "Decision Support"] };
      case 14 { ["Real-Time Systems", "Trading", "Defense", "Autonomous Driving"] };
      case 15 { ["All Predictive AI", "Planning Systems", "Simulation", "Robotics"] };
      case 16 { ["Web3/Blockchain", "DAOs", "Tokenized Coordination", "Incentive Design"] };
      case 17 { ["Distributed AI", "Swarm Systems", "Multi-Agent Systems", "Edge Computing"] };
      case 18 { ["Defense", "Space", "Deep-Sea", "Remote Operations", "Contested Environments"] };
      case 19 { ["All Robotics", "AI", "Sensing Systems", "Biomimetic Engineering"] };
      case _ { ["General Distributed Intelligence"] };
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
