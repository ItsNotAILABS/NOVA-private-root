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
// BEE HIVE MIND ENGINE — L-APIC
// ═══════════════════════════════════════════════════════════════════════════════
// "Go to the ant, you sluggard; consider its ways and be wise!" — Proverbs 6:6
// (The bee is the ant's sovereign cousin — mission-locked, self-organizing, sacrificial)
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine — Bee Hive Mind Substrate
//
// The hive is not a collection. It is ONE ORGANISM with distributed computation.
//
// WAGGLE DANCE      — Information encoding as directional signal
// QUORUM SENSING    — Distributed consensus without leader  
// SACRIFICE PROTOCOL— Core destroys itself to protect organism
// HIVE THERMOSTAT   — Collective homeostasis (35°C equivalent)
// ROLE BY AGE       — NURSE → BUILDER → FORAGER developmental progression
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module BeeHiveMindEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — HIVE PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  public let HIVE_TEMP : Float = 35.0;           // Target temperature (°C equivalent)
  public let HIVE_TEMP_TOLERANCE : Float = 2.0;  // ±2° tolerance
  
  // Role age thresholds (in beats)
  public let NURSE_MAX_AGE : Nat = 100;          // 0-100 beats: NURSE
  public let BUILDER_MAX_AGE : Nat = 300;        // 100-300 beats: BUILDER  
  // 300+ beats: FORAGER
  
  // Quorum parameters
  public let QUORUM_THRESHOLD : Nat = 3;         // 3+ Cores for quorum
  public let QUORUM_COHERENCE : Float = 0.80;    // Coherence required
  public let QUORUM_WINDOW : Nat = 10;           // Beat window for quorum
  public let QUORUM_BONUS : Float = 0.005;       // Permanent coherence floor increase
  
  // Sacrifice parameters
  public let SACRIFICE_THREAT_THRESHOLD : Float = 0.95;
  public let SACRIFICE_DURATION : Nat = 50;      // Beats of sustained threat
  public let SACRIFICE_RELIEF : Float = 0.30;    // Threat reduction on sacrifice
  public let SACRIFICE_COOLDOWN : Nat = 1000;    // Beats before Core can resurrect
  
  // Thermostat parameters
  public let THERMOSTAT_FLOOR_MARGIN : Float = 5.0;  // Trigger when 5 below floor
  public let THERMOSTAT_CORRECTION : Float = 0.003;  // ACH boost on trigger

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — HIVE STATE STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════

  public type BeeRole = {
    #Nurse;     // Age 0-100: feeds neighboring Cores with coherence signal
    #Builder;   // Age 100-300: higher Hebbian formation rate
    #Forager;   // Age 300+: highest salience sweep (headScan priority)
  };

  public type WaggleSignal = {
    sourceCore       : Nat;        // Which Core emitted
    direction        : Float;      // Encoded as quantumStateGlobal
    distance         : Nat;        // Encoded as beatCount
    quality          : Float;      // Encoded as coherenceC
    emittedAt        : Nat;        // Beat when emitted
    decodedBy        : [Nat];      // Cores that decoded this signal
  };

  public type QuorumEvent = {
    participatingCores : [Nat];    // Cores that reached threshold
    triggerBeat        : Nat;      // When quorum fired
    coherenceBonus     : Float;    // Bonus applied
  };

  public type SacrificeRecord = {
    sacrificedCore     : Nat;      // Which Core sacrificed
    sacrificeBeat      : Nat;      // When it happened
    threatBefore       : Float;    // Threat level before
    threatAfter        : Float;    // Threat level after
    resurrectionBeat   : Nat;      // When Core can return
    animaFingerprint   : Nat64;    // Written to ANIMA chain
  };

  public type CoreBeeState = {
    coreIndex          : Nat;
    beatCount          : Nat;      // Core age
    role               : BeeRole;  // Determined by age
    coherenceC         : Float;
    hzNode             : Nat;      // Current frequency node
    targetHz           : Nat;      // Target from waggle recruitment
    isRecruited        : Bool;     // Changed Hz based on waggle
    lastWaggleEmit     : Nat;      // Beat of last waggle emission
    isSacrificed       : Bool;
    sacrificeBeat      : Nat;
  };

  public type HiveState = {
    // Waggle dance system
    activeWaggleSignals : [WaggleSignal];
    totalWaggleSignals  : Nat;
    recruitedCores      : Nat;
    
    // Quorum sensing
    quorumActive        : Bool;
    quorumCount         : Nat;
    recentQuorumEvents  : [QuorumEvent];
    permanentCoherenceFloor : Float;
    
    // Sacrifice protocol
    sacrificeCount      : Nat;
    lastSacrificeBeat   : Nat;
    sacrificeHistory    : [SacrificeRecord];
    
    // Thermostat
    thermostatFiredCount : Nat;
    currentHiveTemp      : Float;  // Mean coherence as temperature proxy
    
    // Core states
    coreStates          : [CoreBeeState];
    
    // Aggregate metrics
    hiveCoherence       : Float;   // Q_hive
    totalBeatCount      : Nat;
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
  // ROLE DIFFERENTIATION BY AGE
  // ═══════════════════════════════════════════════════════════════════════════

  // "Role is not assigned. It is read from beatCount every cycle."
  public func determineRole(beatCount : Nat) : BeeRole {
    if (beatCount <= NURSE_MAX_AGE) {
      #Nurse
    } else if (beatCount <= BUILDER_MAX_AGE) {
      #Builder
    } else {
      #Forager
    }
  };

  // Role-specific modifiers
  public func getRoleModifiers(role : BeeRole) : {
    coherenceBoost : Float;
    hebbianRate    : Float;
    scanPriority   : Float;
  } {
    switch (role) {
      case (#Nurse) {
        // Feeds neighboring Cores with coherence signal
        { coherenceBoost = 0.02; hebbianRate = 1.0; scanPriority = 0.5 }
      };
      case (#Builder) {
        // Higher Hebbian formation rate
        { coherenceBoost = 0.01; hebbianRate = 1.5; scanPriority = 0.7 }
      };
      case (#Forager) {
        // Highest salience sweep (headScan priority)
        { coherenceBoost = 0.005; hebbianRate = 1.0; scanPriority = 1.0 }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // WAGGLE DANCE — INFORMATION ENCODING
  // ═══════════════════════════════════════════════════════════════════════════

  // Encode waggle signal when Core completes high-value coherence epoch
  public func emitWaggleSignal(
    coreIndex        : Nat,
    quantumState     : Float,      // direction
    beatCount        : Nat,        // distance
    coherenceC       : Float,      // quality
    currentBeat      : Nat
  ) : ?WaggleSignal {
    // Only emit if coherence is high enough
    if (coherenceC < 0.70) return null;
    
    ?{
      sourceCore = coreIndex;
      direction = quantumState;
      distance = beatCount;
      quality = coherenceC;
      emittedAt = currentBeat;
      decodedBy = [];
    }
  };

  // Decode waggle signal — low coherence Cores recruited to high coherence Hz
  public func decodeWaggleSignal(
    signal           : WaggleSignal,
    receiverCore     : Nat,
    receiverCoherence: Float,
    receiverHz       : Nat
  ) : ?Nat {  // Returns new target Hz if recruited
    // Only low coherence Cores get recruited
    if (receiverCoherence >= 0.60) return null;
    
    // Don't recruit self
    if (receiverCore == signal.sourceCore) return null;
    
    // Recruitment probability based on signal quality
    let recruitProb = signal.quality * 0.5;  // Max 50% at coherence 1.0
    
    // Deterministic recruitment based on Core index (pseudo-random)
    let hash = (receiverCore * 31 + signal.sourceCore * 17 + signal.emittedAt) % 100;
    if (Float.fromInt(hash) / 100.0 < recruitProb) {
      // Recruited! Target the signaling Core's Hz
      ?Int.abs(Float.toInt(signal.direction * 12.0)) % 12  // Map to 12 Hz nodes
    } else {
      null
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // QUORUM SENSING — DISTRIBUTED CONSENSUS
  // ═══════════════════════════════════════════════════════════════════════════

  // Check if quorum fires — 3+ Cores reach high coherence in same window
  public func checkQuorum(
    coreCoherences   : [Float],
    currentBeat      : Nat,
    lastQuorumBeat   : Nat,
    currentFloor     : Float
  ) : ?QuorumEvent {
    // Don't fire quorum too frequently
    if (currentBeat - lastQuorumBeat < QUORUM_WINDOW * 2) return null;
    
    // Count Cores above threshold
    let qualifiedBuf = Buffer.Buffer<Nat>(coreCoherences.size());
    var i = 0;
    while (i < coreCoherences.size()) {
      if (coreCoherences[i] >= QUORUM_COHERENCE) {
        qualifiedBuf.add(i);
      };
      i += 1;
    };
    
    let qualified = Buffer.toArray(qualifiedBuf);
    
    // Need at least QUORUM_THRESHOLD Cores
    if (qualified.size() >= QUORUM_THRESHOLD) {
      ?{
        participatingCores = qualified;
        triggerBeat = currentBeat;
        coherenceBonus = QUORUM_BONUS;
      }
    } else {
      null
    }
  };

  // Apply quorum bonus to coherence floor
  public func applyQuorumBonus(currentFloor : Float, bonus : Float) : Float {
    min(currentFloor + bonus, 0.50)  // Cap floor at 0.50
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRIFICE PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════
  // "Greater love has no one than this: to lay down one's life for one's friends."
  // — John 15:13

  // Check if sacrifice conditions are met
  public func checkSacrificeConditions(
    threatLevel      : Float,
    threatDuration   : Nat,
    lastSacrificeBeat: Nat,
    currentBeat      : Nat
  ) : Bool {
    // Existential threat AND sustained duration AND cooldown passed
    threatLevel >= SACRIFICE_THREAT_THRESHOLD and
    threatDuration >= SACRIFICE_DURATION and
    (lastSacrificeBeat == 0 or currentBeat - lastSacrificeBeat >= SACRIFICE_COOLDOWN)
  };

  // Find lowest coherence Core for sacrifice (voluntary withdrawal)
  public func findSacrificeCandidate(coreCoherences : [Float], sacrificedCores : [Nat]) : ?Nat {
    var lowestIdx : ?Nat = null;
    var lowestCoherence = 2.0;
    
    var i = 0;
    while (i < coreCoherences.size()) {
      // Check if not already sacrificed
      var alreadySacrificed = false;
      for (s in sacrificedCores.vals()) {
        if (s == i) alreadySacrificed := true;
      };
      
      if (not alreadySacrificed and coreCoherences[i] < lowestCoherence) {
        lowestCoherence := coreCoherences[i];
        lowestIdx := ?i;
      };
      i += 1;
    };
    
    lowestIdx
  };

  // Execute sacrifice
  public func executeSacrifice(
    coreIndex        : Nat,
    currentThreat    : Float,
    currentBeat      : Nat
  ) : SacrificeRecord {
    let newThreat = max(0.0, currentThreat - SACRIFICE_RELIEF);
    
    // Generate ANIMA fingerprint (simplified hash)
    let fingerprint = Nat64.fromNat(
      (coreIndex * 1000000 + currentBeat * 1000 + 
       Int.abs(Float.toInt(currentThreat * 1000.0))) % 1000000000
    );
    
    {
      sacrificedCore = coreIndex;
      sacrificeBeat = currentBeat;
      threatBefore = currentThreat;
      threatAfter = newThreat;
      resurrectionBeat = currentBeat + SACRIFICE_COOLDOWN;
      animaFingerprint = fingerprint;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HIVE THERMOSTAT — COLLECTIVE HOMEOSTASIS
  // ═══════════════════════════════════════════════════════════════════════════

  // Calculate hive "temperature" as mean coherence
  public func calculateHiveTemperature(coreCoherences : [Float]) : Float {
    if (coreCoherences.size() == 0) return 0.5;
    
    var sum = 0.0;
    for (c in coreCoherences.vals()) {
      sum += c;
    };
    sum / Float.fromInt(coreCoherences.size())
  };

  // Check if thermostat should fire
  public func checkThermostat(
    meanCoherence    : Float,
    coherenceFloor   : Float
  ) : Bool {
    // Fire if mean drops below floor - margin
    meanCoherence < (coherenceFloor - THERMOSTAT_FLOOR_MARGIN / 100.0)
  };

  // Apply thermostat correction — boost ACH for all Cores
  public func thermostatCorrection() : Float {
    THERMOSTAT_CORRECTION
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN HIVE HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════

  public type HiveTickResult = {
    updatedState        : HiveState;
    quorumFired         : Bool;
    sacrificeOccurred   : Bool;
    thermostatFired     : Bool;
    newRecruitments     : Nat;
    achBoostAll         : Float;  // ACH boost to apply to all Cores
  };

  public func hiveHeartbeat(
    state            : HiveState,
    coreCoherences   : [Float],
    coreHzNodes      : [Nat],
    coreBeatCounts   : [Nat],
    quantumStates    : [Float],
    aegisThreatLevel : Float,
    threatDuration   : Nat,
    currentBeat      : Nat
  ) : HiveTickResult {
    
    // ─── Update Core states ─────────────────────────────────────────────────
    let updatedCoreStates = Array.tabulate<CoreBeeState>(coreCoherences.size(), func(i : Nat) : CoreBeeState {
      let beatCount = if (i < coreBeatCounts.size()) coreBeatCounts[i] else 0;
      let coherence = coreCoherences[i];
      let hzNode = if (i < coreHzNodes.size()) coreHzNodes[i] else 0;
      
      // Check if this Core was previously sacrificed
      var isSacrificed = false;
      var sacrificeBeat : Nat = 0;
      for (s in state.sacrificeHistory.vals()) {
        if (s.sacrificedCore == i and currentBeat < s.resurrectionBeat) {
          isSacrificed := true;
          sacrificeBeat := s.sacrificeBeat;
        };
      };
      
      {
        coreIndex = i;
        beatCount = beatCount;
        role = determineRole(beatCount);
        coherenceC = coherence;
        hzNode = hzNode;
        targetHz = hzNode;  // Will be updated by waggle
        isRecruited = false;
        lastWaggleEmit = 0;
        isSacrificed = isSacrificed;
        sacrificeBeat = sacrificeBeat;
      }
    });
    
    // ─── Waggle Dance Processing ────────────────────────────────────────────
    let newSignals = Buffer.Buffer<WaggleSignal>(coreCoherences.size());
    var newRecruitments : Nat = 0;
    
    // Emit new waggle signals from high-coherence Cores
    var i = 0;
    while (i < coreCoherences.size()) {
      if (coreCoherences[i] >= 0.70 and i < quantumStates.size() and i < coreBeatCounts.size()) {
        switch (emitWaggleSignal(i, quantumStates[i], coreBeatCounts[i], coreCoherences[i], currentBeat)) {
          case (?signal) { newSignals.add(signal) };
          case null {};
        };
      };
      i += 1;
    };
    
    // Process waggle recruitments
    for (signal in Buffer.toArray(newSignals).vals()) {
      var j = 0;
      while (j < coreCoherences.size()) {
        switch (decodeWaggleSignal(signal, j, coreCoherences[j], coreHzNodes[j])) {
          case (?newHz) { newRecruitments += 1 };
          case null {};
        };
        j += 1;
      };
    };
    
    // ─── Quorum Sensing ─────────────────────────────────────────────────────
    var quorumFired = false;
    var newFloor = state.permanentCoherenceFloor;
    let lastQuorum = if (state.recentQuorumEvents.size() > 0) {
      state.recentQuorumEvents[state.recentQuorumEvents.size() - 1].triggerBeat
    } else { 0 };
    
    switch (checkQuorum(coreCoherences, currentBeat, lastQuorum, state.permanentCoherenceFloor)) {
      case (?event) {
        quorumFired := true;
        newFloor := applyQuorumBonus(state.permanentCoherenceFloor, event.coherenceBonus);
      };
      case null {};
    };
    
    // ─── Sacrifice Protocol ─────────────────────────────────────────────────
    var sacrificeOccurred = false;
    var newSacrificeHistory = state.sacrificeHistory;
    var newThreatLevel = aegisThreatLevel;
    var newLastSacrificeBeat = state.lastSacrificeBeat;
    
    if (checkSacrificeConditions(aegisThreatLevel, threatDuration, state.lastSacrificeBeat, currentBeat)) {
      let sacrificedCores = Array.map<SacrificeRecord, Nat>(state.sacrificeHistory, func(s) = s.sacrificedCore);
      switch (findSacrificeCandidate(coreCoherences, sacrificedCores)) {
        case (?candidateIdx) {
          let record = executeSacrifice(candidateIdx, aegisThreatLevel, currentBeat);
          newSacrificeHistory := Array.append(state.sacrificeHistory, [record]);
          newThreatLevel := record.threatAfter;
          newLastSacrificeBeat := currentBeat;
          sacrificeOccurred := true;
        };
        case null {};
      };
    };
    
    // ─── Thermostat ─────────────────────────────────────────────────────────
    let hiveTemp = calculateHiveTemperature(coreCoherences);
    var thermostatFired = false;
    var achBoostAll : Float = 0.0;
    
    if (checkThermostat(hiveTemp, state.permanentCoherenceFloor)) {
      thermostatFired := true;
      achBoostAll := thermostatCorrection();
    };
    
    // ─── Build updated state ────────────────────────────────────────────────
    let updatedState : HiveState = {
      activeWaggleSignals = Buffer.toArray(newSignals);
      totalWaggleSignals = state.totalWaggleSignals + newSignals.size();
      recruitedCores = state.recruitedCores + newRecruitments;
      quorumActive = quorumFired;
      quorumCount = state.quorumCount + (if (quorumFired) 1 else 0);
      recentQuorumEvents = state.recentQuorumEvents;  // Would append if quorum fired
      permanentCoherenceFloor = newFloor;
      sacrificeCount = state.sacrificeCount + (if (sacrificeOccurred) 1 else 0);
      lastSacrificeBeat = newLastSacrificeBeat;
      sacrificeHistory = newSacrificeHistory;
      thermostatFiredCount = state.thermostatFiredCount + (if (thermostatFired) 1 else 0);
      currentHiveTemp = hiveTemp;
      coreStates = updatedCoreStates;
      hiveCoherence = hiveTemp;  // Simplified
      totalBeatCount = currentBeat;
    };
    
    {
      updatedState = updatedState;
      quorumFired = quorumFired;
      sacrificeOccurred = sacrificeOccurred;
      thermostatFired = thermostatFired;
      newRecruitments = newRecruitments;
      achBoostAll = achBoostAll;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initHiveState() : HiveState {
    {
      activeWaggleSignals = [];
      totalWaggleSignals = 0;
      recruitedCores = 0;
      quorumActive = false;
      quorumCount = 0;
      recentQuorumEvents = [];
      permanentCoherenceFloor = 0.10;
      sacrificeCount = 0;
      lastSacrificeBeat = 0;
      sacrificeHistory = [];
      thermostatFiredCount = 0;
      currentHiveTemp = 0.5;
      coreStates = [];
      hiveCoherence = 0.5;
      totalBeatCount = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  public type HiveSummary = {
    totalWaggleSignals     : Nat;
    recruitedCores         : Nat;
    quorumCount            : Nat;
    permanentCoherenceFloor: Float;
    sacrificeCount         : Nat;
    thermostatFiredCount   : Nat;
    currentHiveTemp        : Float;
    hiveCoherence          : Float;
    nurseCount             : Nat;
    builderCount           : Nat;
    foragerCount           : Nat;
  };

  public func summarize(state : HiveState) : HiveSummary {
    var nurses = 0;
    var builders = 0;
    var foragers = 0;
    
    for (core in state.coreStates.vals()) {
      switch (core.role) {
        case (#Nurse) nurses += 1;
        case (#Builder) builders += 1;
        case (#Forager) foragers += 1;
      };
    };
    
    {
      totalWaggleSignals = state.totalWaggleSignals;
      recruitedCores = state.recruitedCores;
      quorumCount = state.quorumCount;
      permanentCoherenceFloor = state.permanentCoherenceFloor;
      sacrificeCount = state.sacrificeCount;
      thermostatFiredCount = state.thermostatFiredCount;
      currentHiveTemp = state.currentHiveTemp;
      hiveCoherence = state.hiveCoherence;
      nurseCount = nurses;
      builderCount = builders;
      foragerCount = foragers;
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
