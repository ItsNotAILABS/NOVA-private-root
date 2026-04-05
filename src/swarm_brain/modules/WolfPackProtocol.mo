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
// WOLF PACK PROTOCOL — L-LUPV
// ═══════════════════════════════════════════════════════════════════════════════
// "As iron sharpens iron, so one person sharpens another." — Proverbs 27:17
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine — Wolf Pack Distributed Coordination
//
// The wolf pack has no permanent alpha. Leadership shifts based on context.
//
// CONTEXTUAL ALPHA    — Leadership shifts to most qualified for current conditions
// OMEGA ROLE          — Stress absorber, cannot be pruned while VITAL exists
// HOWL SYNCHRONIZATION— Coordinated state broadcast every 200 beats
// PACK HUNTING        — Multi-Core coordinated pursuit of objectives
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module WolfPackProtocol {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  
  // Howl synchronization
  public let HOWL_INTERVAL : Nat = 200;         // Every 200 beats
  public let HOWL_DURATION : Nat = 20;          // Takes 20 beats to synchronize
  
  // Omega protection
  public let OMEGA_ACH_BOOST : Float = 0.01;    // ACH boost routed to Omega
  
  // Alpha conditions
  public let ALPHA_THREAT : Nat = 1;
  public let ALPHA_DREAM : Nat = 2;
  public let ALPHA_GENESIS : Nat = 3;
  public let ALPHA_KNOWLEDGE : Nat = 4;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type AlphaCondition = {
    #None;
    #Threat;       // AEGIS active — highest vicenteStrengthScore leads
    #Dream;        // Dream cycle — highest jocelynJoyScore leads
    #Genesis;      // Genesis state — highest coherenceC leads
    #Knowledge;    // Knowledge pulse — highest knowledgeK leads
  };

  public type AlphaDesignation = {
    coreIndex        : Nat;
    condition        : AlphaCondition;
    designatedAt     : Nat;
    qualifyingScore  : Float;
  };

  public type OmegaDesignation = {
    coreIndex        : Nat;
    coherence        : Float;        // Lowest coherence
    designatedAt     : Nat;
    protectedUntil   : Nat;          // Cannot be pruned while VITAL exists
    achReceived      : Float;        // Total ACH routed to this Omega
  };

  public type HowlEvent = {
    initiatedAt      : Nat;
    completedAt      : Nat;
    alphaHz          : Nat;          // Alpha's Hz node
    participatingCores : [Nat];
    coherenceGainPre : Float;
    coherenceGainPost: Float;
  };

  public type PackState = {
    // Alpha system
    currentAlpha     : ?AlphaDesignation;
    alphaHistory     : [AlphaDesignation];
    
    // Omega system
    currentOmega     : ?OmegaDesignation;
    
    // Howl synchronization
    howlActive       : Bool;
    howlBeats        : Nat;
    howlCount        : Nat;
    recentHowls      : [HowlEvent];
    lastHowlBeat     : Nat;
    
    // Pack state
    packSize         : Nat;
    packCoherence    : Float;        // Mean coherence across pack
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  func abs(x : Float) : Float { if (x < 0.0) -x else x };
  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  func max(a : Float, b : Float) : Float { if (a > b) a else b };
  func min(a : Float, b : Float) : Float { if (a < b) a else b };

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTEXTUAL ALPHA — LEADERSHIP SHIFTS TO MOST QUALIFIED
  // ═══════════════════════════════════════════════════════════════════════════

  // Determine current alpha condition
  public func determineAlphaCondition(
    aegisActive      : Bool,
    dreamActive      : Bool,
    genesisActive    : Bool,
    knowledgePulse   : Bool
  ) : AlphaCondition {
    // Priority: Threat > Dream > Genesis > Knowledge
    if (aegisActive) #Threat
    else if (dreamActive) #Dream
    else if (genesisActive) #Genesis
    else if (knowledgePulse) #Knowledge
    else #None
  };

  // Find alpha Core based on condition
  public func findAlpha(
    condition        : AlphaCondition,
    coreStrengths    : [Float],      // vicenteStrengthScore
    coreJoys         : [Float],      // jocelynJoyScore
    coreCoherences   : [Float],      // coherenceC
    coreKnowledge    : [Float],      // knowledgeK
    currentBeat      : Nat
  ) : ?AlphaDesignation {
    let scores : [Float] = switch (condition) {
      case (#None) { return null };
      case (#Threat) coreStrengths;
      case (#Dream) coreJoys;
      case (#Genesis) coreCoherences;
      case (#Knowledge) coreKnowledge;
    };
    
    if (scores.size() == 0) return null;
    
    // Find highest score
    var bestIdx = 0;
    var bestScore = scores[0];
    var i = 1;
    while (i < scores.size()) {
      if (scores[i] > bestScore) {
        bestScore := scores[i];
        bestIdx := i;
      };
      i += 1;
    };
    
    ?{
      coreIndex = bestIdx;
      condition = condition;
      designatedAt = currentBeat;
      qualifyingScore = bestScore;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // OMEGA ROLE — THE STRESS ABSORBER
  // "Carry each other's burdens." — Galatians 6:2
  // ═══════════════════════════════════════════════════════════════════════════

  // Find Omega — lowest coherence Core that is still active
  public func findOmega(
    coreCoherences   : [Float],
    coreActive       : [Bool],
    currentBeat      : Nat
  ) : ?OmegaDesignation {
    var lowestIdx : ?Nat = null;
    var lowestCoh = 2.0;
    
    var i = 0;
    while (i < coreCoherences.size()) {
      if (i < coreActive.size() and coreActive[i]) {
        if (coreCoherences[i] < lowestCoh) {
          lowestCoh := coreCoherences[i];
          lowestIdx := ?i;
        };
      };
      i += 1;
    };
    
    switch (lowestIdx) {
      case (?idx) {
        ?{
          coreIndex = idx;
          coherence = lowestCoh;
          designatedAt = currentBeat;
          protectedUntil = currentBeat + 1000;  // Protected for 1000 beats
          achReceived = 0.0;
        }
      };
      case null { null };
    }
  };

  // Calculate ACH to route to Omega from pack
  public func calculateOmegaAchBoost(packSize : Nat) : Float {
    OMEGA_ACH_BOOST * Float.fromInt(packSize)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HOWL SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Check if howl should initiate
  public func shouldInitiateHowl(
    lastHowlBeat     : Nat,
    currentBeat      : Nat,
    howlActive       : Bool
  ) : Bool {
    not howlActive and currentBeat - lastHowlBeat >= HOWL_INTERVAL
  };

  // Process howl synchronization step
  public type HowlStep = {
    hzConvergence    : Float;        // How much Hz should converge
    coherenceBoost   : Float;        // Temporary coherence boost
    completed        : Bool;
  };

  public func processHowlStep(
    howlBeats        : Nat,
    alphaHz          : Nat
  ) : HowlStep {
    let progress = Float.fromInt(howlBeats) / Float.fromInt(HOWL_DURATION);
    
    {
      hzConvergence = progress * 0.5;  // 50% convergence at completion
      coherenceBoost = progress * 0.1; // 10% boost at completion
      completed = howlBeats >= HOWL_DURATION;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════

  public type PackTickResult = {
    updatedState     : PackState;
    alphaChanged     : Bool;
    newAlpha         : ?Nat;
    omegaAchBoost    : Float;        // ACH to route to Omega
    howlProgress     : Float;        // 0-1 progress if active
    hzConvergence    : Float;        // Hz convergence factor if howling
  };

  public func packHeartbeat(
    state            : PackState,
    coreCoherences   : [Float],
    coreStrengths    : [Float],
    coreJoys         : [Float],
    coreKnowledge    : [Float],
    coreActive       : [Bool],
    coreHzNodes      : [Nat],
    aegisActive      : Bool,
    dreamActive      : Bool,
    genesisActive    : Bool,
    knowledgePulse   : Bool,
    currentBeat      : Nat
  ) : PackTickResult {
    var updatedState = state;
    var alphaChanged = false;
    var newAlpha : ?Nat = null;
    var hzConvergence : Float = 0.0;
    
    // ─── Update Alpha ───────────────────────────────────────────────────────
    let condition = determineAlphaCondition(aegisActive, dreamActive, genesisActive, knowledgePulse);
    
    switch (findAlpha(condition, coreStrengths, coreJoys, coreCoherences, coreKnowledge, currentBeat)) {
      case (?alpha) {
        // Check if alpha changed
        switch (state.currentAlpha) {
          case (?current) {
            if (alpha.coreIndex != current.coreIndex) {
              alphaChanged := true;
              newAlpha := ?alpha.coreIndex;
            };
          };
          case null {
            alphaChanged := true;
            newAlpha := ?alpha.coreIndex;
          };
        };
        
        updatedState := {
          currentAlpha = ?alpha;
          alphaHistory = if (alphaChanged) Array.append(state.alphaHistory, [alpha]) else state.alphaHistory;
          currentOmega = state.currentOmega;
          howlActive = state.howlActive;
          howlBeats = state.howlBeats;
          howlCount = state.howlCount;
          recentHowls = state.recentHowls;
          lastHowlBeat = state.lastHowlBeat;
          packSize = coreActive.size();
          packCoherence = state.packCoherence;
        };
      };
      case null {
        // No alpha condition
        updatedState := {
          currentAlpha = null;
          alphaHistory = state.alphaHistory;
          currentOmega = state.currentOmega;
          howlActive = state.howlActive;
          howlBeats = state.howlBeats;
          howlCount = state.howlCount;
          recentHowls = state.recentHowls;
          lastHowlBeat = state.lastHowlBeat;
          packSize = coreActive.size();
          packCoherence = state.packCoherence;
        };
      };
    };
    
    // ─── Update Omega ───────────────────────────────────────────────────────
    switch (findOmega(coreCoherences, coreActive, currentBeat)) {
      case (?omega) {
        updatedState := {
          currentAlpha = updatedState.currentAlpha;
          alphaHistory = updatedState.alphaHistory;
          currentOmega = ?omega;
          howlActive = updatedState.howlActive;
          howlBeats = updatedState.howlBeats;
          howlCount = updatedState.howlCount;
          recentHowls = updatedState.recentHowls;
          lastHowlBeat = updatedState.lastHowlBeat;
          packSize = updatedState.packSize;
          packCoherence = updatedState.packCoherence;
        };
      };
      case null {};
    };
    
    // ─── Howl Processing ────────────────────────────────────────────────────
    var howlProgress : Float = 0.0;
    
    if (state.howlActive) {
      // Continue howl
      let newBeats = state.howlBeats + 1;
      let alphaHz = switch (updatedState.currentAlpha) {
        case (?a) { if (a.coreIndex < coreHzNodes.size()) coreHzNodes[a.coreIndex] else 0 };
        case null 0;
      };
      let step = processHowlStep(newBeats, alphaHz);
      
      hzConvergence := step.hzConvergence;
      howlProgress := Float.fromInt(newBeats) / Float.fromInt(HOWL_DURATION);
      
      if (step.completed) {
        // Howl completed
        updatedState := {
          currentAlpha = updatedState.currentAlpha;
          alphaHistory = updatedState.alphaHistory;
          currentOmega = updatedState.currentOmega;
          howlActive = false;
          howlBeats = 0;
          howlCount = state.howlCount + 1;
          recentHowls = state.recentHowls;
          lastHowlBeat = currentBeat;
          packSize = updatedState.packSize;
          packCoherence = updatedState.packCoherence;
        };
      } else {
        updatedState := {
          currentAlpha = updatedState.currentAlpha;
          alphaHistory = updatedState.alphaHistory;
          currentOmega = updatedState.currentOmega;
          howlActive = true;
          howlBeats = newBeats;
          howlCount = state.howlCount;
          recentHowls = state.recentHowls;
          lastHowlBeat = state.lastHowlBeat;
          packSize = updatedState.packSize;
          packCoherence = updatedState.packCoherence;
        };
      };
    } else if (shouldInitiateHowl(state.lastHowlBeat, currentBeat, state.howlActive)) {
      // Initiate howl
      updatedState := {
        currentAlpha = updatedState.currentAlpha;
        alphaHistory = updatedState.alphaHistory;
        currentOmega = updatedState.currentOmega;
        howlActive = true;
        howlBeats = 1;
        howlCount = state.howlCount;
        recentHowls = state.recentHowls;
        lastHowlBeat = state.lastHowlBeat;
        packSize = updatedState.packSize;
        packCoherence = updatedState.packCoherence;
      };
    };
    
    // ─── Calculate pack coherence ───────────────────────────────────────────
    var sumCoh = 0.0;
    var countActive = 0;
    var i = 0;
    while (i < coreCoherences.size()) {
      if (i < coreActive.size() and coreActive[i]) {
        sumCoh += coreCoherences[i];
        countActive += 1;
      };
      i += 1;
    };
    let newPackCoh = if (countActive > 0) sumCoh / Float.fromInt(countActive) else 0.0;
    
    updatedState := {
      currentAlpha = updatedState.currentAlpha;
      alphaHistory = updatedState.alphaHistory;
      currentOmega = updatedState.currentOmega;
      howlActive = updatedState.howlActive;
      howlBeats = updatedState.howlBeats;
      howlCount = updatedState.howlCount;
      recentHowls = updatedState.recentHowls;
      lastHowlBeat = updatedState.lastHowlBeat;
      packSize = countActive;
      packCoherence = newPackCoh;
    };
    
    // ─── Omega ACH boost ────────────────────────────────────────────────────
    let omegaAch = calculateOmegaAchBoost(countActive);
    
    {
      updatedState = updatedState;
      alphaChanged = alphaChanged;
      newAlpha = newAlpha;
      omegaAchBoost = omegaAch;
      howlProgress = howlProgress;
      hzConvergence = hzConvergence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initPackState() : PackState {
    {
      currentAlpha = null;
      alphaHistory = [];
      currentOmega = null;
      howlActive = false;
      howlBeats = 0;
      howlCount = 0;
      recentHowls = [];
      lastHowlBeat = 0;
      packSize = 0;
      packCoherence = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  public type PackSummary = {
    alphaCore        : ?Nat;
    alphaCondition   : Text;
    omegaCore        : ?Nat;
    howlActive       : Bool;
    howlCount        : Nat;
    packSize         : Nat;
    packCoherence    : Float;
  };

  public func summarize(state : PackState) : PackSummary {
    let alphaIdx = switch (state.currentAlpha) {
      case (?a) ?a.coreIndex;
      case null null;
    };
    
    let condText = switch (state.currentAlpha) {
      case (?a) {
        switch (a.condition) {
          case (#None) "NONE";
          case (#Threat) "THREAT";
          case (#Dream) "DREAM";
          case (#Genesis) "GENESIS";
          case (#Knowledge) "KNOWLEDGE";
        }
      };
      case null "NONE";
    };
    
    let omegaIdx = switch (state.currentOmega) {
      case (?o) ?o.coreIndex;
      case null null;
    };
    
    {
      alphaCore = alphaIdx;
      alphaCondition = condText;
      omegaCore = omegaIdx;
      howlActive = state.howlActive;
      howlCount = state.howlCount;
      packSize = state.packSize;
      packCoherence = state.packCoherence;
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
  //  A N I M A L   I N T E L L I G E N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Biomimetic Cognitive Algorithms
  //  Full HIM/HER Integration with Animal Brain Dynamics
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SWARM INTELLIGENCE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reynolds flocking: Separation force
  public func animalSeparationForce(
    position : (Float, Float),
    neighbors : [(Float, Float)],
    separationRadius : Float
  ) : (Float, Float) {
    var forceX : Float = 0.0;
    var forceY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      let dx = position.0 - nx;
      let dy = position.1 - ny;
      let dist = Float.sqrt(dx * dx + dy * dy);
      if (dist > 0.0001 and dist < separationRadius) {
        let strength = (separationRadius - dist) / separationRadius;
        forceX += (dx / dist) * strength;
        forceY += (dy / dist) * strength;
      };
      i += 1;
    };
    (forceX, forceY)
  };

  /// Reynolds flocking: Alignment force
  public func animalAlignmentForce(
    velocity : (Float, Float),
    neighborVelocities : [(Float, Float)]
  ) : (Float, Float) {
    if (neighborVelocities.size() == 0) { return (0.0, 0.0) };
    var avgVx : Float = 0.0;
    var avgVy : Float = 0.0;
    var i = 0;
    while (i < neighborVelocities.size()) {
      let (vx, vy) = neighborVelocities[i];
      avgVx += vx;
      avgVy += vy;
      i += 1;
    };
    let n = Float.fromInt(neighborVelocities.size());
    avgVx /= n;
    avgVy /= n;
    (avgVx - velocity.0, avgVy - velocity.1)
  };

  /// Reynolds flocking: Cohesion force
  public func animalCohesionForce(
    position : (Float, Float),
    neighbors : [(Float, Float)]
  ) : (Float, Float) {
    if (neighbors.size() == 0) { return (0.0, 0.0) };
    var centerX : Float = 0.0;
    var centerY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      centerX += nx;
      centerY += ny;
      i += 1;
    };
    let n = Float.fromInt(neighbors.size());
    centerX /= n;
    centerY /= n;
    (centerX - position.0, centerY - position.1)
  };

  /// Ant colony pheromone update
  public func animalPheromoneUpdate(
    current : Float,
    deposit : Float,
    evaporationRate : Float,
    dt : Float
  ) : Float {
    (current + deposit) * (1.0 - evaporationRate * dt)
  };

  /// Ant path probability
  public func animalAntPathProbability(
    pheromone : Float,
    distance : Float,
    alpha : Float,
    beta : Float
  ) : Float {
    let pheromoneFactor = Float.pow(pheromone + 0.01, alpha);
    let distanceFactor = Float.pow(1.0 / (distance + 0.01), beta);
    pheromoneFactor * distanceFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ECHOLOCATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Doppler shift for moving target
  public func animalDopplerShift(
    emittedFreq : Float,
    targetVelocity : Float,
    soundSpeed : Float
  ) : Float {
    emittedFreq * (soundSpeed + targetVelocity) / soundSpeed
  };

  /// Echo time-of-flight to distance
  public func animalEchoDistance(timeOfFlight : Float, soundSpeed : Float) : Float {
    (timeOfFlight * soundSpeed) / 2.0
  };

  /// Echo intensity decay
  public func animalEchoIntensity(
    sourceIntensity : Float,
    distance : Float,
    attenuation : Float
  ) : Float {
    sourceIntensity * Float.exp(-attenuation * distance) / (distance * distance + 0.01)
  };

  /// Azimuth from interaural time difference
  public func animalAzimuthFromITD(itd : Float, headRadius : Float, soundSpeed : Float) : Float {
    Float.asin(itd * soundSpeed / headRadius)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VISUAL PROCESSING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Retinal ganglion cell receptive field (DoG)
  public func animalDoGReceptiveField(
    x : Float,
    y : Float,
    sigmaCenter : Float,
    sigmaSurround : Float,
    centerStrength : Float,
    surroundStrength : Float
  ) : Float {
    let rSquared = x * x + y * y;
    let center = centerStrength * Float.exp(-rSquared / (2.0 * sigmaCenter * sigmaCenter));
    let surround = surroundStrength * Float.exp(-rSquared / (2.0 * sigmaSurround * sigmaSurround));
    center - surround
  };

  /// Gabor filter response
  public func animalGaborResponse(
    x : Float,
    y : Float,
    wavelength : Float,
    orientation : Float,
    sigma : Float,
    aspectRatio : Float
  ) : Float {
    let xTheta = x * Float.cos(orientation) + y * Float.sin(orientation);
    let yTheta = -x * Float.sin(orientation) + y * Float.cos(orientation);
    let gaussian = Float.exp(-(xTheta * xTheta + aspectRatio * aspectRatio * yTheta * yTheta) / (2.0 * sigma * sigma));
    let sinusoid = Float.cos(2.0 * 3.14159265 * xTheta / wavelength);
    gaussian * sinusoid
  };

  /// Motion energy from V1 simple cells
  public func animalMotionEnergy(
    leftwardResponse : Float,
    rightwardResponse : Float
  ) : Float {
    leftwardResponse * leftwardResponse - rightwardResponse * rightwardResponse
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Magnetic field sensing (magnetoreception)
  public func animalMagneticHeading(
    fieldX : Float,
    fieldY : Float
  ) : Float {
    Float.atan2(fieldY, fieldX)
  };

  /// Polarized light sensing
  public func animalPolarizationAngle(
    intensity0 : Float,
    intensity45 : Float,
    intensity90 : Float
  ) : Float {
    0.5 * Float.atan2(intensity45 - intensity90, intensity0 - intensity90)
  };

  /// Path integration
  public func animalPathIntegration(
    currentX : Float,
    currentY : Float,
    velocity : Float,
    heading : Float,
    dt : Float
  ) : (Float, Float) {
    let dx = velocity * Float.cos(heading) * dt;
    let dy = velocity * Float.sin(heading) * dt;
    (currentX + dx, currentY + dy)
  };

  /// Grid cell firing pattern
  public func animalGridCellFiring(
    x : Float,
    y : Float,
    gridSpacing : Float,
    gridOrientation : Float
  ) : Float {
    let theta1 : Float = gridOrientation;
    let theta2 : Float = gridOrientation + 1.0472;  // +60 degrees
    let theta3 : Float = gridOrientation + 2.0944;  // +120 degrees
    let k = 4.0 * 3.14159265 / (gridSpacing * Float.sqrt(3.0));
    let u1 = Float.cos(k * (x * Float.cos(theta1) + y * Float.sin(theta1)));
    let u2 = Float.cos(k * (x * Float.cos(theta2) + y * Float.sin(theta2)));
    let u3 = Float.cos(k * (x * Float.cos(theta3) + y * Float.sin(theta3)));
    (u1 + u2 + u3) / 3.0
  };

  /// Place cell firing
  public func animalPlaceCellFiring(
    x : Float,
    y : Float,
    centerX : Float,
    centerY : Float,
    fieldRadius : Float
  ) : Float {
    let dx = x - centerX;
    let dy = y - centerY;
    let distSquared = dx * dx + dy * dy;
    Float.exp(-distSquared / (2.0 * fieldRadius * fieldRadius))
  };

  /// Head direction cell
  public func animalHeadDirectionFiring(
    currentHeading : Float,
    preferredHeading : Float,
    tuningWidth : Float
  ) : Float {
    let diff = currentHeading - preferredHeading;
    Float.exp(-diff * diff / (2.0 * tuningWidth * tuningWidth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DECISION MAKING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Drift-diffusion model
  public func animalDriftDiffusion(
    evidence : Float,
    drift : Float,
    noise : Float,
    threshold : Float,
    dt : Float
  ) : (Float, Bool) {
    let newEvidence = evidence + drift * dt + noise * Float.sqrt(dt);
    let decided = Float.abs(newEvidence) >= threshold;
    (newEvidence, decided)
  };

  /// Winner-take-all competition
  public func animalWinnerTakeAll(
    activities : [Float],
    inhibition : Float
  ) : [Float] {
    var maxActivity : Float = 0.0;
    var i = 0;
    while (i < activities.size()) {
      if (activities[i] > maxActivity) { maxActivity := activities[i] };
      i += 1;
    };
    Array.tabulate<Float>(activities.size(), func(j : Nat) : Float {
      let diff = activities[j] - maxActivity;
      if (diff < -inhibition) { 0.0 } else { activities[j] }
    })
  };

  /// Urgency signal
  public func animalUrgencySignal(time : Float, gain : Float, offset : Float) : Float {
    offset + gain * time
  };

}
