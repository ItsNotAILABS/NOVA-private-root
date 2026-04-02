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

}
