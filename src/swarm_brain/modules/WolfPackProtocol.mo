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

}
