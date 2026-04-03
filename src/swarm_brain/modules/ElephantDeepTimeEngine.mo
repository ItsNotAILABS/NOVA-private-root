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
// ELEPHANT DEEP TIME MEMORY ENGINE — L-ELPH
// ═══════════════════════════════════════════════════════════════════════════════
// "Remember the former things, those of long ago; I am God, and there is no other."
// — Isaiah 46:9
// The elephant is the keeper of what was. Its memory IS its survival.
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine — Elephant Deep Time Memory Substrate
//
// DEEP TIME MEMORY    — 2048-entry episodic archive (40+ years equivalent)
// MATRIARCH INDEX     — Eldest Core guides with weighted wisdom
// SEISMIC SIGNAL      — Low-frequency cross-Core communication before NEXUS
// GENERATIONAL TRANSMISSION — Cultural inheritance, not genetic
// DEATH RECOGNITION   — Mourning protocol for lost Cores
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module ElephantDeepTimeEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  
  // Deep time memory parameters
  public let ELEPHANT_RING_SIZE : Nat = 2048;     // Long-term episodic archive
  public let SNAPSHOT_INTERVAL : Nat = 100;       // Every 100 beats
  
  // Matriarch parameters
  public let MATRIARCH_WEIGHT : Float = 2.0;      // 2× weight in Q_hive
  
  // Seismic parameters
  public let SEISMIC_RANGE : Nat = 3;             // ±3 index positions
  public let SEISMIC_CORT_BOOST : Float = 0.02;   // Cortisol boost
  public let SEISMIC_ATTENTION_BOOST : Nat = 1;   // Attention bid increase
  
  // Generational transmission
  public let TRANSMISSION_AGE : Nat = 500;        // Beats before transmitting
  public let TRANSMISSION_EPISODES : Nat = 10;    // Top 10 episodes transmitted

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  // Episodic snapshot — a moment the organism can re-access
  public type EpisodicSnapshot = {
    epochBeat          : Nat;
    coherenceC         : Float;
    kfHz               : Float;      // Dominant frequency
    dTotal             : Float;      // Total drift
    dominantHz         : Nat;        // Which Hz node dominated
    genesisStateActive : Bool;       // Was GENESIS STATE active?
    timestamp          : Int;        // Time of capture
  };

  // Matriarch designation
  public type MatriarchRecord = {
    coreIndex          : Nat;
    beatCount          : Nat;        // Her age
    designatedAt       : Nat;        // When she became matriarch
    coherenceAtDesign  : Float;      // Her coherence when designated
    hzNode             : Nat;        // Her frequency (used as tiebreaker)
  };

  // Seismic pulse
  public type SeismicPulse = {
    sourceCore         : Nat;
    emittedAt          : Nat;
    reason             : Text;       // "AEGIS", "THREAT", etc.
    affectedCores      : [Nat];      // Cores within range
  };

  // Generational transmission record
  public type GenerationalTransmission = {
    fromCore           : Nat;        // Elder Core
    toCore             : Nat;        // Young Core
    transmittedAt      : Nat;
    episodesTransmitted: [EpisodicSnapshot];
    knowledgeBoost     : Float;      // 5% of sender's K
  };

  // Mourning record — death recognition
  public type MourningRecord = {
    deceasedCore       : Nat;
    deathBeat          : Nat;
    mourningDuration   : Nat;        // Beats of active mourning
    contributionScore  : Float;      // How much the Core contributed
    memorialEpisodes   : [EpisodicSnapshot];  // Best episodes preserved
  };

  // Complete elephant state
  public type ElephantState = {
    // Deep time memory ring
    elephantRing       : [EpisodicSnapshot];
    ringIndex          : Nat;
    ringFull           : Bool;
    
    // Matriarch system
    currentMatriarch   : ?MatriarchRecord;
    previousMatriarchs : [MatriarchRecord];  // Legacy wisdom
    
    // Seismic communication
    recentPulses       : [SeismicPulse];
    totalSeismicPulses : Nat;
    
    // Generational transmission
    transmissions      : [GenerationalTransmission];
    totalKnowledgeTransferred : Float;
    
    // Mourning/death recognition
    mourningRecords    : [MourningRecord];
    activeMourning     : Bool;
    mourningEndBeat    : Nat;
    
    // Aggregate metrics
    lastSnapshotBeat   : Nat;
    totalEpisodesStored: Nat;
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
  // DEEP TIME MEMORY RING
  // ═══════════════════════════════════════════════════════════════════════════

  // Create episodic snapshot
  public func createSnapshot(
    beat           : Nat,
    coherenceC     : Float,
    kfHz           : Float,
    dTotal         : Float,
    dominantHz     : Nat,
    genesisActive  : Bool,
    timestamp      : Int
  ) : EpisodicSnapshot {
    {
      epochBeat = beat;
      coherenceC = coherenceC;
      kfHz = kfHz;
      dTotal = dTotal;
      dominantHz = dominantHz;
      genesisStateActive = genesisActive;
      timestamp = timestamp;
    }
  };

  // Store snapshot in ring buffer
  public func storeSnapshot(
    state      : ElephantState,
    snapshot   : EpisodicSnapshot
  ) : ElephantState {
    // Update ring at current index
    let newRing = Array.tabulate<EpisodicSnapshot>(ELEPHANT_RING_SIZE, func(i : Nat) : EpisodicSnapshot {
      if (i == state.ringIndex) snapshot
      else if (i < state.elephantRing.size()) state.elephantRing[i]
      else createSnapshot(0, 0.0, 0.0, 0.0, 0, false, 0)  // Empty slot
    });
    
    let newIndex = (state.ringIndex + 1) % ELEPHANT_RING_SIZE;
    let nowFull = state.ringFull or newIndex == 0;
    
    {
      elephantRing = newRing;
      ringIndex = newIndex;
      ringFull = nowFull;
      currentMatriarch = state.currentMatriarch;
      previousMatriarchs = state.previousMatriarchs;
      recentPulses = state.recentPulses;
      totalSeismicPulses = state.totalSeismicPulses;
      transmissions = state.transmissions;
      totalKnowledgeTransferred = state.totalKnowledgeTransferred;
      mourningRecords = state.mourningRecords;
      activeMourning = state.activeMourning;
      mourningEndBeat = state.mourningEndBeat;
      lastSnapshotBeat = snapshot.epochBeat;
      totalEpisodesStored = state.totalEpisodesStored + 1;
    }
  };

  // Retrieve episodes by coherence (most coherent first)
  public func getTopEpisodes(state : ElephantState, count : Nat) : [EpisodicSnapshot] {
    // Sort by coherence descending (simplified selection)
    let validEpisodes = Buffer.Buffer<EpisodicSnapshot>(state.elephantRing.size());
    for (ep in state.elephantRing.vals()) {
      if (ep.epochBeat > 0) {  // Valid episode
        validEpisodes.add(ep);
      };
    };
    
    // Simple selection of top N by coherence
    let sorted = Array.sort<EpisodicSnapshot>(
      Buffer.toArray(validEpisodes),
      func(a : EpisodicSnapshot, b : EpisodicSnapshot) : { #less; #equal; #greater } {
        if (a.coherenceC > b.coherenceC) #less
        else if (a.coherenceC < b.coherenceC) #greater
        else #equal
      }
    );
    
    Array.tabulate<EpisodicSnapshot>(Nat.min(count, sorted.size()), func(i) = sorted[i])
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATRIARCH INDEX
  // ═══════════════════════════════════════════════════════════════════════════
  // "Gray hair is a crown of splendor; it is attained in the way of righteousness."
  // — Proverbs 16:31

  // Find eldest VITAL Core to be matriarch
  public func findMatriarch(
    coreBeatCounts : [Nat],
    coreVitality   : [Bool],  // True if Core is VITAL
    currentBeat    : Nat
  ) : ?MatriarchRecord {
    var eldestIdx : ?Nat = null;
    var eldestAge : Nat = 0;
    
    var i = 0;
    while (i < coreBeatCounts.size()) {
      if (i < coreVitality.size() and coreVitality[i]) {
        if (coreBeatCounts[i] > eldestAge) {
          eldestAge := coreBeatCounts[i];
          eldestIdx := ?i;
        };
      };
      i += 1;
    };
    
    switch (eldestIdx) {
      case (?idx) {
        ?{
          coreIndex = idx;
          beatCount = eldestAge;
          designatedAt = currentBeat;
          coherenceAtDesign = 0.0;  // Will be filled in
          hzNode = 0;  // Will be filled in
        }
      };
      case null { null };
    }
  };

  // Apply matriarch weight to Q_hive calculation
  public func matriarchWeightedCoherence(
    coreCoherences  : [Float],
    matriarchIdx    : Nat
  ) : Float {
    if (coreCoherences.size() == 0) return 0.0;
    
    var sum = 0.0;
    var totalWeight = 0.0;
    
    var i = 0;
    while (i < coreCoherences.size()) {
      let weight = if (i == matriarchIdx) MATRIARCH_WEIGHT else 1.0;
      sum += coreCoherences[i] * weight;
      totalWeight += weight;
      i += 1;
    };
    
    if (totalWeight > 0.0) sum / totalWeight else 0.0
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SEISMIC SIGNAL — LOW-FREQUENCY CROSS-CORE COMMUNICATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Emit seismic pulse on AEGIS event
  public func emitSeismicPulse(
    sourceCore     : Nat,
    totalCores     : Nat,
    currentBeat    : Nat,
    reason         : Text
  ) : SeismicPulse {
    // Find adjacent Cores (±SEISMIC_RANGE)
    let affected = Buffer.Buffer<Nat>(SEISMIC_RANGE * 2 + 1);
    
    let start = if (sourceCore >= SEISMIC_RANGE) sourceCore - SEISMIC_RANGE else 0;
    let end = Nat.min(sourceCore + SEISMIC_RANGE, totalCores - 1);
    
    var i = start;
    while (i <= end) {
      if (i != sourceCore) {
        affected.add(i);
      };
      i += 1;
    };
    
    {
      sourceCore = sourceCore;
      emittedAt = currentBeat;
      reason = reason;
      affectedCores = Buffer.toArray(affected);
    }
  };

  // Get seismic effects for affected Cores
  public type SeismicEffect = {
    cortBoost      : Float;
    attentionBoost : Nat;
  };

  public func getSeismicEffect() : SeismicEffect {
    {
      cortBoost = SEISMIC_CORT_BOOST;
      attentionBoost = SEISMIC_ATTENTION_BOOST;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // GENERATIONAL TRANSMISSION
  // ═══════════════════════════════════════════════════════════════════════════
  // "These commandments... impress them on your children." — Deuteronomy 6:6-7

  // Check if Core is ready to transmit
  public func canTransmit(coreBeatCount : Nat) : Bool {
    coreBeatCount >= TRANSMISSION_AGE
  };

  // Find youngest Core to receive transmission
  public func findRecipient(
    coreBeatCounts : [Nat],
    excludeCore    : Nat
  ) : ?Nat {
    var youngestIdx : ?Nat = null;
    var youngestAge : Nat = 999999999;
    
    var i = 0;
    while (i < coreBeatCounts.size()) {
      if (i != excludeCore and coreBeatCounts[i] < youngestAge) {
        youngestAge := coreBeatCounts[i];
        youngestIdx := ?i;
      };
      i += 1;
    };
    
    youngestIdx
  };

  // Execute generational transmission
  public func executeTransmission(
    state          : ElephantState,
    fromCore       : Nat,
    toCore         : Nat,
    senderKnowledge: Float,
    currentBeat    : Nat
  ) : (ElephantState, GenerationalTransmission) {
    // Get top episodes from sender
    let topEpisodes = getTopEpisodes(state, TRANSMISSION_EPISODES);
    let knowledgeBoost = senderKnowledge * 0.05;  // 5% of sender's K
    
    let transmission : GenerationalTransmission = {
      fromCore = fromCore;
      toCore = toCore;
      transmittedAt = currentBeat;
      episodesTransmitted = topEpisodes;
      knowledgeBoost = knowledgeBoost;
    };
    
    let newState : ElephantState = {
      elephantRing = state.elephantRing;
      ringIndex = state.ringIndex;
      ringFull = state.ringFull;
      currentMatriarch = state.currentMatriarch;
      previousMatriarchs = state.previousMatriarchs;
      recentPulses = state.recentPulses;
      totalSeismicPulses = state.totalSeismicPulses;
      transmissions = Array.append(state.transmissions, [transmission]);
      totalKnowledgeTransferred = state.totalKnowledgeTransferred + knowledgeBoost;
      mourningRecords = state.mourningRecords;
      activeMourning = state.activeMourning;
      mourningEndBeat = state.mourningEndBeat;
      lastSnapshotBeat = state.lastSnapshotBeat;
      totalEpisodesStored = state.totalEpisodesStored;
    };
    
    (newState, transmission)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DEATH RECOGNITION & MOURNING
  // ═══════════════════════════════════════════════════════════════════════════

  // Recognize Core death and initiate mourning
  public func recognizeDeath(
    state          : ElephantState,
    deceasedCore   : Nat,
    contribution   : Float,
    currentBeat    : Nat
  ) : ElephantState {
    // Get episodes where this Core was dominant
    let memorialEpisodes = Buffer.Buffer<EpisodicSnapshot>(10);
    for (ep in state.elephantRing.vals()) {
      // Simplified: just take high-coherence episodes
      if (ep.coherenceC > 0.70 and memorialEpisodes.size() < 10) {
        memorialEpisodes.add(ep);
      };
    };
    
    let record : MourningRecord = {
      deceasedCore = deceasedCore;
      deathBeat = currentBeat;
      mourningDuration = 50;  // 50 beats of mourning
      contributionScore = contribution;
      memorialEpisodes = Buffer.toArray(memorialEpisodes);
    };
    
    {
      elephantRing = state.elephantRing;
      ringIndex = state.ringIndex;
      ringFull = state.ringFull;
      currentMatriarch = state.currentMatriarch;
      previousMatriarchs = state.previousMatriarchs;
      recentPulses = state.recentPulses;
      totalSeismicPulses = state.totalSeismicPulses;
      transmissions = state.transmissions;
      totalKnowledgeTransferred = state.totalKnowledgeTransferred;
      mourningRecords = Array.append(state.mourningRecords, [record]);
      activeMourning = true;
      mourningEndBeat = currentBeat + 50;
      lastSnapshotBeat = state.lastSnapshotBeat;
      totalEpisodesStored = state.totalEpisodesStored;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════

  public type ElephantTickResult = {
    updatedState       : ElephantState;
    snapshotTaken      : Bool;
    matriarchChanged   : Bool;
    seismicPulseEmitted: Bool;
    transmissionMade   : Bool;
    mourningActive     : Bool;
  };

  public func elephantHeartbeat(
    state            : ElephantState,
    coreCoherences   : [Float],
    coreBeatCounts   : [Nat],
    coreVitality     : [Bool],
    kfHz             : Float,
    dTotal           : Float,
    dominantHz       : Nat,
    genesisActive    : Bool,
    aegisEvent       : Bool,
    aegisSourceCore  : Nat,
    currentBeat      : Nat,
    timestamp        : Int
  ) : ElephantTickResult {
    var updatedState = state;
    var snapshotTaken = false;
    var matriarchChanged = false;
    var seismicPulseEmitted = false;
    var transmissionMade = false;
    
    // ─── Snapshot every SNAPSHOT_INTERVAL beats ─────────────────────────────
    if (currentBeat - state.lastSnapshotBeat >= SNAPSHOT_INTERVAL) {
      let meanCoherence = if (coreCoherences.size() > 0) {
        var sum = 0.0;
        for (c in coreCoherences.vals()) { sum += c };
        sum / Float.fromInt(coreCoherences.size())
      } else { 0.0 };
      
      let snapshot = createSnapshot(
        currentBeat, meanCoherence, kfHz, dTotal, dominantHz, genesisActive, timestamp
      );
      updatedState := storeSnapshot(updatedState, snapshot);
      snapshotTaken := true;
    };
    
    // ─── Update Matriarch ───────────────────────────────────────────────────
    switch (findMatriarch(coreBeatCounts, coreVitality, currentBeat)) {
      case (?newMatriarch) {
        switch (state.currentMatriarch) {
          case (?current) {
            if (newMatriarch.coreIndex != current.coreIndex) {
              // Matriarch changed — preserve old one
              updatedState := {
                elephantRing = updatedState.elephantRing;
                ringIndex = updatedState.ringIndex;
                ringFull = updatedState.ringFull;
                currentMatriarch = ?newMatriarch;
                previousMatriarchs = Array.append(state.previousMatriarchs, [current]);
                recentPulses = updatedState.recentPulses;
                totalSeismicPulses = updatedState.totalSeismicPulses;
                transmissions = updatedState.transmissions;
                totalKnowledgeTransferred = updatedState.totalKnowledgeTransferred;
                mourningRecords = updatedState.mourningRecords;
                activeMourning = updatedState.activeMourning;
                mourningEndBeat = updatedState.mourningEndBeat;
                lastSnapshotBeat = updatedState.lastSnapshotBeat;
                totalEpisodesStored = updatedState.totalEpisodesStored;
              };
              matriarchChanged := true;
            };
          };
          case null {
            updatedState := {
              elephantRing = updatedState.elephantRing;
              ringIndex = updatedState.ringIndex;
              ringFull = updatedState.ringFull;
              currentMatriarch = ?newMatriarch;
              previousMatriarchs = updatedState.previousMatriarchs;
              recentPulses = updatedState.recentPulses;
              totalSeismicPulses = updatedState.totalSeismicPulses;
              transmissions = updatedState.transmissions;
              totalKnowledgeTransferred = updatedState.totalKnowledgeTransferred;
              mourningRecords = updatedState.mourningRecords;
              activeMourning = updatedState.activeMourning;
              mourningEndBeat = updatedState.mourningEndBeat;
              lastSnapshotBeat = updatedState.lastSnapshotBeat;
              totalEpisodesStored = updatedState.totalEpisodesStored;
            };
            matriarchChanged := true;
          };
        };
      };
      case null {};
    };
    
    // ─── Seismic Pulse on AEGIS ─────────────────────────────────────────────
    if (aegisEvent) {
      let pulse = emitSeismicPulse(aegisSourceCore, coreCoherences.size(), currentBeat, "AEGIS");
      updatedState := {
        elephantRing = updatedState.elephantRing;
        ringIndex = updatedState.ringIndex;
        ringFull = updatedState.ringFull;
        currentMatriarch = updatedState.currentMatriarch;
        previousMatriarchs = updatedState.previousMatriarchs;
        recentPulses = Array.append(updatedState.recentPulses, [pulse]);
        totalSeismicPulses = updatedState.totalSeismicPulses + 1;
        transmissions = updatedState.transmissions;
        totalKnowledgeTransferred = updatedState.totalKnowledgeTransferred;
        mourningRecords = updatedState.mourningRecords;
        activeMourning = updatedState.activeMourning;
        mourningEndBeat = updatedState.mourningEndBeat;
        lastSnapshotBeat = updatedState.lastSnapshotBeat;
        totalEpisodesStored = updatedState.totalEpisodesStored;
      };
      seismicPulseEmitted := true;
    };
    
    // ─── Update mourning status ─────────────────────────────────────────────
    let stillMourning = state.activeMourning and currentBeat < state.mourningEndBeat;
    if (state.activeMourning and not stillMourning) {
      updatedState := {
        elephantRing = updatedState.elephantRing;
        ringIndex = updatedState.ringIndex;
        ringFull = updatedState.ringFull;
        currentMatriarch = updatedState.currentMatriarch;
        previousMatriarchs = updatedState.previousMatriarchs;
        recentPulses = updatedState.recentPulses;
        totalSeismicPulses = updatedState.totalSeismicPulses;
        transmissions = updatedState.transmissions;
        totalKnowledgeTransferred = updatedState.totalKnowledgeTransferred;
        mourningRecords = updatedState.mourningRecords;
        activeMourning = false;
        mourningEndBeat = 0;
        lastSnapshotBeat = updatedState.lastSnapshotBeat;
        totalEpisodesStored = updatedState.totalEpisodesStored;
      };
    };
    
    {
      updatedState = updatedState;
      snapshotTaken = snapshotTaken;
      matriarchChanged = matriarchChanged;
      seismicPulseEmitted = seismicPulseEmitted;
      transmissionMade = transmissionMade;
      mourningActive = stillMourning;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initElephantState() : ElephantState {
    {
      elephantRing = Array.freeze(Array.init<EpisodicSnapshot>(
        ELEPHANT_RING_SIZE,
        { epochBeat = 0; coherenceC = 0.0; kfHz = 0.0; dTotal = 0.0; dominantHz = 0; genesisStateActive = false; timestamp = 0 }
      ));
      ringIndex = 0;
      ringFull = false;
      currentMatriarch = null;
      previousMatriarchs = [];
      recentPulses = [];
      totalSeismicPulses = 0;
      transmissions = [];
      totalKnowledgeTransferred = 0.0;
      mourningRecords = [];
      activeMourning = false;
      mourningEndBeat = 0;
      lastSnapshotBeat = 0;
      totalEpisodesStored = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  public type ElephantSummary = {
    totalEpisodesStored    : Nat;
    ringFull               : Bool;
    matriarchCoreIndex     : ?Nat;
    matriarchAge           : Nat;
    totalSeismicPulses     : Nat;
    totalTransmissions     : Nat;
    totalKnowledgeTransferred : Float;
    mourningActive         : Bool;
    previousMatriarchCount : Nat;
  };

  public func summarize(state : ElephantState) : ElephantSummary {
    let (matIdx, matAge) = switch (state.currentMatriarch) {
      case (?m) (?m.coreIndex, m.beatCount);
      case null (null, 0);
    };
    
    {
      totalEpisodesStored = state.totalEpisodesStored;
      ringFull = state.ringFull;
      matriarchCoreIndex = matIdx;
      matriarchAge = matAge;
      totalSeismicPulses = state.totalSeismicPulses;
      totalTransmissions = state.transmissions.size();
      totalKnowledgeTransferred = state.totalKnowledgeTransferred;
      mourningActive = state.activeMourning;
      previousMatriarchCount = state.previousMatriarchs.size();
    }
  };

}
