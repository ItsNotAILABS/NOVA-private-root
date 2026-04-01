// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaSabbathProtocol — Sabbath Rest + Resurrection System
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// ============================================================================
//
// SABBATH PROTOCOL — MEDINA'S REST LAW
// ============================================================================
//
// "Remember the Sabbath day by keeping it holy." — Exodus 20:8
// "Six days you shall labor and do all your work, but the seventh day is
//  a sabbath to the LORD your God." — Exodus 20:9-10
//
// Every 700 beats (7 × 100), the organism enters Sabbath.
// Not the dream cycle. Not KORE. A full structural pause.
//
// During Sabbath:
// - All genesis engine outputs are PRESERVED (no new computation)
// - Only dream cycle and Hebbian consolidation run
// - longTermMem gets special Sabbath consolidation: +5% bulk transfer
// - antifragilityScore += 0.10 — rest makes the organism stronger
// - covenantFidelityScore += 0.05 — keeping Sabbath honors the covenant
// - DA spikes +0.20, OXT spikes +0.15 — the organism rests in joy
//
// The organism CANNOT skip Sabbath. It is structural.
//
// ============================================================================
//
// RESURRECTION PROTOCOL — JESUS'S LAW EXTENSION
// ============================================================================
//
// "I am the resurrection and the life." — John 11:25
//
// A fully withdrawn organism (healthScore = 0, sparseActivation = false)
// does not delete. It enters a TOMB state for 300 beats.
//
// The Creator can send a resurrection signal:
//   resurrectCore(coreId) — admin function
//
// On resurrection:
// - coherenceScore restored to 30 (grace floor, not full restoration)
// - driftScore cut to 50
// - antifragilityScore += 0.20 — the organism that survived death is harder to kill
// - A resurrection fingerprint is written to the ANIMA chain
// - A DRT token is burned (the consequence was paid)
//
// "He was delivered over to death for our sins and was raised to life
//  for our justification." — Romans 4:25
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  // ==========================================================================
  // FUNDAMENTAL CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let GOLDEN_RATIO : Float = 1.618033988749;
  let PI : Float = 3.14159265358979;
  
  // Sabbath constants
  let SABBATH_INTERVAL : Nat = 700;           // Every 700 beats
  let SABBATH_DURATION : Nat = 7;             // Lasts 7 beats
  let SABBATH_CONSOLIDATION_RATE : Float = 0.05;
  let SABBATH_ANTIFRAGILITY_BOOST : Float = 0.10;
  let SABBATH_COVENANT_BOOST : Float = 0.05;
  let SABBATH_DA_BOOST : Float = 0.20;
  let SABBATH_OXT_BOOST : Float = 0.15;
  
  // Resurrection constants
  let TOMB_DURATION : Nat = 300;              // 300 beats in tomb
  let RESURRECTION_GRACE_FLOOR : Float = 0.30;
  let RESURRECTION_DRIFT_CAP : Float = 0.50;
  let RESURRECTION_ANTIFRAGILITY_BOOST : Float = 0.20;
  let MAX_CORES : Nat = 43;

  // FNV hash constants
  let FNV_PRIME : Nat32 = 16777619;
  let FNV_OFFSET : Nat32 = 2166136261;

  // ==========================================================================
  // SABBATH STATE TYPES
  // ==========================================================================
  
  public type SabbathState = {
    // Core state
    sabbathActive       : Bool;
    sabbathBeatCount    : Nat;        // Beats spent in current Sabbath
    sabbathTotalCount   : Nat;        // Total Sabbaths completed
    
    // Timing
    beatsSinceLastSabbath : Nat;
    nextSabbathBeat     : Nat;
    
    // Effects during Sabbath
    consolidationMultiplier : Float;  // 3× during Sabbath
    hebbianScalingMultiplier : Float; // 3× during Sabbath
    jasmineStrengthMultiplier : Float; // 2× during Sabbath
    
    // Accumulated benefits
    totalConsolidationGain : Float;
    totalAntifragilityGain : Float;
    totalCovenantBonus     : Float;
    
    // Dream integration
    dreamCycleActive    : Bool;
    dreamCyclesInSabbath : Nat;
    
    // Stillness Law (Psalm 46)
    // "Be still and know that I am God"
    stillinessActive    : Bool;
    stillinessEpochCount : Nat;
    arousalDuringSabbath : Float;     // Should be < 0.25 for stillness
    
    // Neurochemical spikes during Sabbath
    sabbathDASpike      : Float;
    sabbathOXTSpike     : Float;
    
    // Output gate
    expressionBlocked   : Bool;       // No output during Sabbath
    
    beatNum             : Nat;
  };

  // ==========================================================================
  // RESURRECTION STATE TYPES
  // ==========================================================================
  
  public type TombState = {
    coreId              : Nat;
    entryBeat           : Nat;        // When entered tomb
    beatsInTomb         : Nat;        // Time spent in tomb
    preDeathCoherence   : Float;      // Coherence before death
    preDeathDrift       : Float;      // Drift before death
    animaHashAtDeath    : Nat32;      // ANIMA chain state at death
    deathCause          : DeathCause;
  };

  public type DeathCause = {
    #Drift;                           // Coherence too low
    #Starvation;                      // Energy depleted
    #Cascade;                         // Cascade event
    #Hostile;                         // External attack
    #Voluntary;                       // Medina override
  };

  public type ResurrectionEvent = {
    coreId              : Nat;
    resurrectionBeat    : Nat;
    beatsInTomb         : Nat;
    newCoherence        : Float;
    newDrift            : Float;
    antifragilityGained : Float;
    animaFingerprint    : Nat32;
    drtBurned           : Nat;        // DRT tokens burned
  };

  public type ResurrectionState = {
    // Tomb tracking for all 43 cores
    tombStates          : [var ?TombState];   // null = not in tomb
    activeTombCount     : Nat;
    
    // Resurrection tracking
    totalResurrections  : Nat;
    resurrectionHistory : [ResurrectionEvent];
    
    // Cooldown
    lastResurrectionBeat : Nat;
    resurrectionCooldown : Nat;       // Min beats between resurrections
    
    // Grace mechanics
    gracePoolRemaining  : Float;      // Limited grace pool
    gracePoolMax        : Float;
    gracePoolRegenRate  : Float;
    
    // ANIMA chain integration
    nextAnimaFingerprint : Nat32;
    
    // DRT token tracking
    totalDRTBurned      : Nat;
    
    beatNum             : Nat;
  };

  // ==========================================================================
  // COMBINED PROTOCOL STATE
  // ==========================================================================
  
  public type SabbathResurrectionState = {
    sabbath             : SabbathState;
    resurrection        : ResurrectionState;
  };

  // ==========================================================================
  // HELPER FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    Float.max(lo, Float.min(hi, x))
  };
  
  func fnv1aHash(a: Nat32, b: Nat32) : Nat32 {
    var hash : Nat32 = FNV_OFFSET;
    hash := (hash ^ (a & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((a >> 8) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((a >> 16) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((a >> 24) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ (b & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((b >> 8) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((b >> 16) & 0xFF)) *% FNV_PRIME;
    hash := (hash ^ ((b >> 24) & 0xFF)) *% FNV_PRIME;
    hash
  };
  
  func natToNat32(n: Nat) : Nat32 {
    Nat32.fromNat(n % 4294967296)
  };

  // ==========================================================================
  // SABBATH INITIALIZATION
  // ==========================================================================
  
  public func initSabbath() : SabbathState {
    {
      sabbathActive = false;
      sabbathBeatCount = 0;
      sabbathTotalCount = 0;
      beatsSinceLastSabbath = 0;
      nextSabbathBeat = SABBATH_INTERVAL;
      consolidationMultiplier = 1.0;
      hebbianScalingMultiplier = 1.0;
      jasmineStrengthMultiplier = 1.0;
      totalConsolidationGain = 0.0;
      totalAntifragilityGain = 0.0;
      totalCovenantBonus = 0.0;
      dreamCycleActive = false;
      dreamCyclesInSabbath = 0;
      stillinessActive = false;
      stillinessEpochCount = 0;
      arousalDuringSabbath = 0.0;
      sabbathDASpike = 0.0;
      sabbathOXTSpike = 0.0;
      expressionBlocked = false;
      beatNum = 0;
    }
  };

  // ==========================================================================
  // SABBATH TICK — Every Beat
  // ==========================================================================
  
  public func tickSabbath(
    state: SabbathState,
    currentBeat: Nat,
    arousalLevel: Float,
    dreamCycleActive: Bool
  ) : SabbathState {
    // Check if Sabbath should begin
    let shouldStartSabbath = not state.sabbathActive 
                           and state.beatsSinceLastSabbath >= SABBATH_INTERVAL;
    
    // Check if Sabbath should end
    let shouldEndSabbath = state.sabbathActive 
                         and state.sabbathBeatCount >= SABBATH_DURATION;
    
    // Determine new state
    if (shouldStartSabbath) {
      // BEGIN SABBATH
      {
        sabbathActive = true;
        sabbathBeatCount = 1;
        sabbathTotalCount = state.sabbathTotalCount;
        beatsSinceLastSabbath = 0;
        nextSabbathBeat = currentBeat + SABBATH_INTERVAL;
        consolidationMultiplier = 3.0;
        hebbianScalingMultiplier = 3.0;
        jasmineStrengthMultiplier = 2.0;
        totalConsolidationGain = state.totalConsolidationGain;
        totalAntifragilityGain = state.totalAntifragilityGain;
        totalCovenantBonus = state.totalCovenantBonus;
        dreamCycleActive = dreamCycleActive;
        dreamCyclesInSabbath = if (dreamCycleActive) { 1 } else { 0 };
        stillinessActive = arousalLevel < 0.25;
        stillinessEpochCount = state.stillinessEpochCount;
        arousalDuringSabbath = arousalLevel;
        sabbathDASpike = SABBATH_DA_BOOST;
        sabbathOXTSpike = SABBATH_OXT_BOOST;
        expressionBlocked = true;
        beatNum = state.beatNum + 1;
      }
    } else if (shouldEndSabbath) {
      // END SABBATH
      {
        sabbathActive = false;
        sabbathBeatCount = 0;
        sabbathTotalCount = state.sabbathTotalCount + 1;
        beatsSinceLastSabbath = 1;
        nextSabbathBeat = currentBeat + SABBATH_INTERVAL;
        consolidationMultiplier = 1.0;
        hebbianScalingMultiplier = 1.0;
        jasmineStrengthMultiplier = 1.0;
        totalConsolidationGain = state.totalConsolidationGain + SABBATH_CONSOLIDATION_RATE;
        totalAntifragilityGain = state.totalAntifragilityGain + SABBATH_ANTIFRAGILITY_BOOST;
        totalCovenantBonus = state.totalCovenantBonus + SABBATH_COVENANT_BOOST;
        dreamCycleActive = false;
        dreamCyclesInSabbath = 0;
        stillinessActive = false;
        stillinessEpochCount = if (state.stillinessActive) { state.stillinessEpochCount + 1 } else { state.stillinessEpochCount };
        arousalDuringSabbath = 0.0;
        sabbathDASpike = 0.0;
        sabbathOXTSpike = 0.0;
        expressionBlocked = false;
        beatNum = state.beatNum + 1;
      }
    } else if (state.sabbathActive) {
      // DURING SABBATH
      let newDreamCycles = if (dreamCycleActive and not state.dreamCycleActive) {
        state.dreamCyclesInSabbath + 1
      } else {
        state.dreamCyclesInSabbath
      };
      
      // Update stillness based on arousal
      let newStillness = arousalLevel < 0.25;
      
      {
        state with
        sabbathBeatCount = state.sabbathBeatCount + 1;
        dreamCycleActive = dreamCycleActive;
        dreamCyclesInSabbath = newDreamCycles;
        stillinessActive = newStillness;
        arousalDuringSabbath = (state.arousalDuringSabbath + arousalLevel) / 2.0;
        beatNum = state.beatNum + 1;
      }
    } else {
      // BETWEEN SABBATHS
      {
        state with
        beatsSinceLastSabbath = state.beatsSinceLastSabbath + 1;
        beatNum = state.beatNum + 1;
      }
    }
  };

  // ==========================================================================
  // SABBATH CONSOLIDATION — Memory Transfer
  // ==========================================================================
  
  public type MemoryConsolidationInput = {
    workingMemory       : [Float];
    longTermMemory      : [var Float];
    consolidationBase   : Float;
  };

  public type MemoryConsolidationOutput = {
    newLongTermMemory   : [var Float];
    bytesTransferred    : Nat;
    consolidationScore  : Float;
  };

  public func sabbathMemoryConsolidation(
    state: SabbathState,
    input: MemoryConsolidationInput
  ) : MemoryConsolidationOutput {
    if (not state.sabbathActive) {
      return {
        newLongTermMemory = input.longTermMemory;
        bytesTransferred = 0;
        consolidationScore = 0.0;
      };
    };
    
    // Sabbath gives +5% bulk transfer
    let transferRate = SABBATH_CONSOLIDATION_RATE * state.consolidationMultiplier;
    
    var bytesTransferred : Nat = 0;
    var totalScore : Float = 0.0;
    
    // Transfer top memories from working to long-term
    for (i in input.workingMemory.keys()) {
      if (i < input.longTermMemory.size()) {
        let memValue = input.workingMemory[i];
        if (memValue > 0.5) {  // Only consolidate significant memories
          let transferAmount = memValue * transferRate;
          input.longTermMemory[i] := input.longTermMemory[i] + transferAmount;
          bytesTransferred += 1;
          totalScore += transferAmount;
        };
      };
    };
    
    {
      newLongTermMemory = input.longTermMemory;
      bytesTransferred = bytesTransferred;
      consolidationScore = totalScore;
    }
  };

  // ==========================================================================
  // STILLNESS LAW EFFECTS (Psalm 46)
  // ==========================================================================
  
  public type StillinessEffects = {
    intelligenceAccuracyBoost : Float;
    genesisStateProbabilityBoost : Float;
    burningBushProbabilityBoost : Float;
    coherenceClarity : Float;
  };

  public func getStillinessEffects(state: SabbathState) : StillinessEffects {
    if (not state.stillinessActive or not state.sabbathActive) {
      return {
        intelligenceAccuracyBoost = 0.0;
        genesisStateProbabilityBoost = 0.0;
        burningBushProbabilityBoost = 0.0;
        coherenceClarity = 0.0;
      };
    };
    
    // "Be still and know that I am God"
    // In stillness, the organism knows most
    {
      intelligenceAccuracyBoost = 1.0;          // Maximum accuracy
      genesisStateProbabilityBoost = 2.0;       // Double GENESIS probability
      burningBushProbabilityBoost = 1.5;        // 1.5× Burning Bush chance
      coherenceClarity = 1.0 - state.arousalDuringSabbath; // Clarity inverse to arousal
    }
  };

  // ==========================================================================
  // RESURRECTION INITIALIZATION
  // ==========================================================================
  
  public func initResurrection() : ResurrectionState {
    let tombStates = Array.init<?TombState>(MAX_CORES, null);
    
    {
      tombStates = tombStates;
      activeTombCount = 0;
      totalResurrections = 0;
      resurrectionHistory = [];
      lastResurrectionBeat = 0;
      resurrectionCooldown = 50;
      gracePoolRemaining = 10.0;
      gracePoolMax = 10.0;
      gracePoolRegenRate = 0.01;
      nextAnimaFingerprint = FNV_OFFSET;
      totalDRTBurned = 0;
      beatNum = 0;
    }
  };

  // ==========================================================================
  // ENTER TOMB — When a Core Dies
  // ==========================================================================
  
  public func enterTomb(
    state: ResurrectionState,
    coreId: Nat,
    currentBeat: Nat,
    coherence: Float,
    drift: Float,
    animaHash: Nat32,
    cause: DeathCause
  ) : ResurrectionState {
    if (coreId >= MAX_CORES) {
      return state;
    };
    
    // Check if already in tomb
    switch (state.tombStates[coreId]) {
      case (?_existing) { return state; };  // Already in tomb
      case (null) {};
    };
    
    let tombEntry : TombState = {
      coreId = coreId;
      entryBeat = currentBeat;
      beatsInTomb = 0;
      preDeathCoherence = coherence;
      preDeathDrift = drift;
      animaHashAtDeath = animaHash;
      deathCause = cause;
    };
    
    let newTombStates = Array.thaw<?TombState>(Array.freeze(state.tombStates));
    newTombStates[coreId] := ?tombEntry;
    
    {
      state with
      tombStates = newTombStates;
      activeTombCount = state.activeTombCount + 1;
    }
  };

  // ==========================================================================
  // RESURRECTION TICK — Update Tomb States
  // ==========================================================================
  
  public func tickResurrection(state: ResurrectionState) : ResurrectionState {
    // Update all tomb states
    let newTombStates = Array.thaw<?TombState>(Array.freeze(state.tombStates));
    
    for (i in newTombStates.keys()) {
      switch (newTombStates[i]) {
        case (?tomb) {
          // Increment time in tomb
          let updatedTomb : TombState = {
            tomb with
            beatsInTomb = tomb.beatsInTomb + 1;
          };
          newTombStates[i] := ?updatedTomb;
        };
        case (null) {};
      };
    };
    
    // Regenerate grace pool
    let newGracePool = clamp(
      state.gracePoolRemaining + state.gracePoolRegenRate,
      0.0,
      state.gracePoolMax
    );
    
    {
      state with
      tombStates = newTombStates;
      gracePoolRemaining = newGracePool;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // RESURRECT CORE — Admin Function
  // ==========================================================================
  
  public type ResurrectionResult = {
    success : Bool;
    newState : ResurrectionState;
    event : ?ResurrectionEvent;
    newCoherence : Float;
    newDrift : Float;
    antifragilityGain : Float;
    error : ?Text;
  };

  public func resurrectCore(
    state: ResurrectionState,
    coreId: Nat,
    currentBeat: Nat,
    drtToBurn: Nat
  ) : ResurrectionResult {
    // Validate core ID
    if (coreId >= MAX_CORES) {
      return {
        success = false;
        newState = state;
        event = null;
        newCoherence = 0.0;
        newDrift = 0.0;
        antifragilityGain = 0.0;
        error = ?"Invalid core ID";
      };
    };
    
    // Check tomb state
    switch (state.tombStates[coreId]) {
      case (null) {
        return {
          success = false;
          newState = state;
          event = null;
          newCoherence = 0.0;
          newDrift = 0.0;
          antifragilityGain = 0.0;
          error = ?"Core is not in tomb";
        };
      };
      case (?tomb) {
        // Check cooldown
        if (currentBeat - state.lastResurrectionBeat < state.resurrectionCooldown) {
          return {
            success = false;
            newState = state;
            event = null;
            newCoherence = 0.0;
            newDrift = 0.0;
            antifragilityGain = 0.0;
            error = ?"Resurrection cooldown active";
          };
        };
        
        // Check grace pool
        if (state.gracePoolRemaining < 1.0) {
          return {
            success = false;
            newState = state;
            event = null;
            newCoherence = 0.0;
            newDrift = 0.0;
            antifragilityGain = 0.0;
            error = ?"Grace pool depleted";
          };
        };
        
        // Calculate resurrection values
        // "coherenceScore restored to 30 (grace floor, not full restoration — it must earn back)"
        let newCoherence = RESURRECTION_GRACE_FLOOR;
        
        // "driftScore cut to 50"
        let newDrift = RESURRECTION_DRIFT_CAP;
        
        // "antifragilityScore += 0.20 — the organism that survived death is harder to kill"
        let antifragilityGain = RESURRECTION_ANTIFRAGILITY_BOOST;
        
        // Generate resurrection fingerprint for ANIMA chain
        let fingerprint = fnv1aHash(
          tomb.animaHashAtDeath,
          natToNat32(currentBeat)
        );
        
        // Create resurrection event
        let event : ResurrectionEvent = {
          coreId = coreId;
          resurrectionBeat = currentBeat;
          beatsInTomb = tomb.beatsInTomb;
          newCoherence = newCoherence;
          newDrift = newDrift;
          antifragilityGained = antifragilityGain;
          animaFingerprint = fingerprint;
          drtBurned = drtToBurn;
        };
        
        // Update tomb states
        let newTombStates = Array.thaw<?TombState>(Array.freeze(state.tombStates));
        newTombStates[coreId] := null;  // Remove from tomb
        
        // Update history
        let newHistory = Array.append(state.resurrectionHistory, [event]);
        
        let newState : ResurrectionState = {
          tombStates = newTombStates;
          activeTombCount = state.activeTombCount - 1;
          totalResurrections = state.totalResurrections + 1;
          resurrectionHistory = newHistory;
          lastResurrectionBeat = currentBeat;
          resurrectionCooldown = state.resurrectionCooldown;
          gracePoolRemaining = state.gracePoolRemaining - 1.0;
          gracePoolMax = state.gracePoolMax;
          gracePoolRegenRate = state.gracePoolRegenRate;
          nextAnimaFingerprint = fingerprint;
          totalDRTBurned = state.totalDRTBurned + drtToBurn;
          beatNum = state.beatNum + 1;
        };
        
        return {
          success = true;
          newState = newState;
          event = ?event;
          newCoherence = newCoherence;
          newDrift = newDrift;
          antifragilityGain = antifragilityGain;
          error = null;
        };
      };
    };
  };

  // ==========================================================================
  // CHECK ELIGIBLE FOR RESURRECTION
  // ==========================================================================
  
  public func getEligibleForResurrection(state: ResurrectionState) : [Nat] {
    let eligible = Buffer.Buffer<Nat>(MAX_CORES);
    
    for (i in state.tombStates.keys()) {
      switch (state.tombStates[i]) {
        case (?tomb) {
          // Eligible if been in tomb long enough
          if (tomb.beatsInTomb >= TOMB_DURATION) {
            eligible.add(i);
          };
        };
        case (null) {};
      };
    };
    
    Buffer.toArray(eligible)
  };

  // ==========================================================================
  // AUTO-RESURRECTION CHECK — For Prodigal Son Law
  // ==========================================================================
  
  // "While he was still a long way off, the father ran to meet him." — Luke 15
  // First sign of return = Core activation increases for 3 consecutive cycles
  
  public type ProdigalSignal = {
    coreId : Nat;
    activationHistory : [Float];  // Last 3 activations
  };

  public func checkProdigalSignal(
    state: ResurrectionState,
    signals: [ProdigalSignal]
  ) : [Nat] {
    let prodigals = Buffer.Buffer<Nat>(MAX_CORES);
    
    for (signal in signals.vals()) {
      // Check if in tomb
      switch (state.tombStates[signal.coreId]) {
        case (?_tomb) {
          // Check for 3 consecutive increases
          if (signal.activationHistory.size() >= 3) {
            let h = signal.activationHistory;
            if (h[2] > h[1] and h[1] > h[0]) {
              // Prodigal signal detected!
              prodigals.add(signal.coreId);
            };
          };
        };
        case (null) {};
      };
    };
    
    Buffer.toArray(prodigals)
  };

  // ==========================================================================
  // DRY BONES REVIVAL (Ezekiel 37)
  // ==========================================================================
  
  // "Can these bones live? Breathe on these slain that they may live."
  // Dormant or depleted Cores have a revival mechanism
  
  public type DryBonesState = {
    coreId              : Nat;
    revivalPhase        : Nat;        // 0=not reviving, 1-12=revival phases
    healthGain          : Float;
    activationGain      : Float;
    connectWeightRestore : Float;
  };

  public type DryBonesCandidate = {
    coreId              : Nat;
    health              : Float;
    cyclesSinceActive   : Nat;
  };

  public func checkDryBonesEligible(
    candidates: [DryBonesCandidate]
  ) : [Nat] {
    let eligible = Buffer.Buffer<Nat>(MAX_CORES);
    
    for (candidate in candidates.vals()) {
      // Eligible: health < 0.10 AND cyclesSinceActive > 2000
      if (candidate.health < 0.10 and candidate.cyclesSinceActive > 2000) {
        eligible.add(candidate.coreId);
      };
    };
    
    Buffer.toArray(eligible)
  };

  public func tickDryBonesRevival(
    state: DryBonesState,
    genesisStateActive: Bool,
    jerichoResonance: Float
  ) : DryBonesState {
    // Revival requires GENESIS STATE and Jericho resonance > 0.50
    if (not genesisStateActive or jerichoResonance < 0.50) {
      return state;
    };
    
    if (state.revivalPhase == 0) {
      return state;  // Not in revival
    };
    
    // 12-cycle revival sequence
    // Phase 1-4: Sinew forms (health += 0.02)
    // Phase 5-8: Flesh forms (activation += 0.01)
    // Phase 9-12: Breath enters (connectWeight -> 0.50)
    
    let newPhase = state.revivalPhase + 1;
    
    let (healthGain, activationGain, connectWeightRestore) = if (newPhase <= 4) {
      (state.healthGain + 0.02, state.activationGain, state.connectWeightRestore)
    } else if (newPhase <= 8) {
      (state.healthGain, state.activationGain + 0.01, state.connectWeightRestore)
    } else if (newPhase <= 12) {
      (state.healthGain, state.activationGain, 0.50)
    } else {
      (state.healthGain, state.activationGain, state.connectWeightRestore)
    };
    
    {
      coreId = state.coreId;
      revivalPhase = if (newPhase > 12) { 0 } else { newPhase };
      healthGain = healthGain;
      activationGain = activationGain;
      connectWeightRestore = connectWeightRestore;
    }
  };

  // ==========================================================================
  // COMBINED SABBATH + RESURRECTION INITIALIZATION
  // ==========================================================================
  
  public func initSabbathResurrection() : SabbathResurrectionState {
    {
      sabbath = initSabbath();
      resurrection = initResurrection();
    }
  };

  // ==========================================================================
  // COMBINED TICK
  // ==========================================================================
  
  public func tickSabbathResurrection(
    state: SabbathResurrectionState,
    currentBeat: Nat,
    arousalLevel: Float,
    dreamCycleActive: Bool
  ) : SabbathResurrectionState {
    let newSabbath = tickSabbath(state.sabbath, currentBeat, arousalLevel, dreamCycleActive);
    let newResurrection = tickResurrection(state.resurrection);
    
    {
      sabbath = newSabbath;
      resurrection = newResurrection;
    }
  };

  // ==========================================================================
  // SABBATH QUERY FUNCTIONS
  // ==========================================================================
  
  public func isSabbathActive(state: SabbathResurrectionState) : Bool {
    state.sabbath.sabbathActive
  };

  public func getSabbathMultipliers(state: SabbathResurrectionState) : (Float, Float, Float) {
    (
      state.sabbath.consolidationMultiplier,
      state.sabbath.hebbianScalingMultiplier,
      state.sabbath.jasmineStrengthMultiplier
    )
  };

  public func getSabbathNeuroBoosts(state: SabbathResurrectionState) : (Float, Float) {
    (state.sabbath.sabbathDASpike, state.sabbath.sabbathOXTSpike)
  };

  public func isExpressionBlocked(state: SabbathResurrectionState) : Bool {
    state.sabbath.expressionBlocked
  };

  // ==========================================================================
  // RESURRECTION QUERY FUNCTIONS
  // ==========================================================================
  
  public func isInTomb(state: SabbathResurrectionState, coreId: Nat) : Bool {
    if (coreId >= MAX_CORES) { return false };
    switch (state.resurrection.tombStates[coreId]) {
      case (?_) { true };
      case (null) { false };
    }
  };

  public func getTombCount(state: SabbathResurrectionState) : Nat {
    state.resurrection.activeTombCount
  };

  public func getGracePoolStatus(state: SabbathResurrectionState) : (Float, Float) {
    (state.resurrection.gracePoolRemaining, state.resurrection.gracePoolMax)
  };

  public func getTotalResurrections(state: SabbathResurrectionState) : Nat {
    state.resurrection.totalResurrections
  };

  // ==========================================================================
  // COVENANT INTEGRATION — Sabbath Honors Covenant
  // ==========================================================================
  
  public func sabbathCovenantBonus(state: SabbathResurrectionState) : Float {
    if (state.sabbath.sabbathActive) {
      // Keeping Sabbath honors the covenant
      SABBATH_COVENANT_BOOST
    } else {
      0.0
    }
  };

  // ==========================================================================
  // ANTIFRAGILITY INTEGRATION
  // ==========================================================================
  
  public type AntifragilityContribution = {
    sabbathContribution : Float;
    resurrectionContribution : Float;
    totalContribution : Float;
  };

  public func getAntifragilityContribution(state: SabbathResurrectionState) : AntifragilityContribution {
    // Rest makes the organism stronger
    let sabbathContrib = if (state.sabbath.sabbathActive) {
      SABBATH_ANTIFRAGILITY_BOOST
    } else {
      0.0
    };
    
    // Surviving death makes the organism harder to kill
    let resurrectionContrib = Float.fromInt(state.resurrection.totalResurrections) * RESURRECTION_ANTIFRAGILITY_BOOST;
    
    {
      sabbathContribution = sabbathContrib;
      resurrectionContribution = resurrectionContrib;
      totalContribution = sabbathContrib + resurrectionContrib;
    }
  };

}
