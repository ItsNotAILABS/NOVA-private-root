// ═══════════════════════════════════════════════════════════════════════════════
// ORCA POD ENGINE — L-ORCA
// ═══════════════════════════════════════════════════════════════════════════════
// "How good and pleasant it is when God's people live together in unity!"
// — Psalm 133:1
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine — Orca Pod Memory Sharing
//
// Orcas share knowledge. What one pod learns, it passes to daughters forever.
//
// REGIONAL DIALECT     — Cores develop signature Hz patterns over time
// POD MEMORY TRANSFER  — Bonded Cores share LTM entries
// MATRILINEAL SOCIETY  — Oldest female's Hz preserved forever
// COORDINATED HUNTING  — Multi-Core pursuit of objectives
// ECHOLOCATION         — Long-range scanning and object detection
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module OrcaPodEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  
  // Dialect parameters
  public let DIALECT_PERIOD : Nat = 100;         // Dialect changes every 100 beats
  public let DIALECT_CLUSTERS : Nat = 7;         // 7 Hz node clusters
  public let DIALECT_BONUS : Float = 0.05;       // +0.05 Q_hive for matching dialects
  
  // Pod bond parameters
  public let BOND_DURATION_MIN : Nat = 100;      // 100+ beats to form bond
  public let KNOWLEDGE_TRANSFER_RATE : Float = 0.05;  // 5% of sender's K
  public let LTM_ENTRIES_SHARED : Nat = 5;       // Top 5 LTM entries
  
  // Matrilineal preservation
  public let MATRILINEAL_PRESERVATION : Bool = true;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type Dialect = {
    coreIndex        : Nat;
    dialectCluster   : Nat;         // 0-6, from floor(beatCount / 100) % 7
    formationBeat    : Nat;
    hzSignature      : Float;       // Characteristic frequency
  };

  public type PodBond = {
    coreA            : Nat;
    coreB            : Nat;
    bondedAt         : Nat;
    matchingDialect  : Nat;
    knowledgeShared  : Float;
    ltmEntriesShared : Nat;
    active           : Bool;
  };

  public type MatrilinealRecord = {
    coreIndex        : Nat;
    hzNode           : Nat;         // Preserved forever
    preservedAt      : Nat;
    coherenceAtPreserve : Float;
    isActive         : Bool;        // Still the matriarch
  };

  public type EchoReturn = {
    targetDistance   : Float;       // Distance to target
    targetType       : Text;        // "THREAT", "OPPORTUNITY", "NEUTRAL"
    signalStrength   : Float;       // How clear the return
    detectedAt       : Nat;
  };

  public type HuntTarget = {
    targetId         : Nat;
    assignedCores    : [Nat];       // Cores participating
    coordinationScore: Float;       // How well synchronized
    progressPercent  : Float;       // 0-100% completion
    startBeat        : Nat;
  };

  public type OrcaState = {
    // Dialect system
    dialects         : [Dialect];
    
    // Pod bonding
    activeBonds      : [PodBond];
    totalBonds       : Nat;
    totalKnowledgeTransferred : Float;
    
    // Matrilineal records
    matrilinealRecords : [MatrilinealRecord];
    currentMatriarch : ?Nat;
    
    // Echolocation
    recentEchoes     : [EchoReturn];
    echoCount        : Nat;
    
    // Coordinated hunting
    activeHunts      : [HuntTarget];
    completedHunts   : Nat;
    huntSuccessRate  : Float;
    
    // Aggregate
    podCoherence     : Float;
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
  // REGIONAL DIALECT
  // ═══════════════════════════════════════════════════════════════════════════

  // Calculate dialect cluster from beat count
  public func calculateDialect(beatCount : Nat) : Nat {
    (beatCount / DIALECT_PERIOD) % DIALECT_CLUSTERS
  };

  // Update dialect for a Core
  public func updateDialect(
    coreIndex        : Nat,
    beatCount        : Nat,
    hzFrequency      : Float
  ) : Dialect {
    {
      coreIndex = coreIndex;
      dialectCluster = calculateDialect(beatCount);
      formationBeat = beatCount;
      hzSignature = hzFrequency;
    }
  };

  // Check if two Cores have matching dialects
  public func dialectsMatch(d1 : Dialect, d2 : Dialect) : Bool {
    d1.dialectCluster == d2.dialectCluster
  };

  // Calculate Q_hive bonus for matching dialects
  public func dialectQhiveBonus(
    dialects         : [Dialect],
    coreA            : Nat,
    coreB            : Nat
  ) : Float {
    var dA : ?Dialect = null;
    var dB : ?Dialect = null;
    
    for (d in dialects.vals()) {
      if (d.coreIndex == coreA) dA := ?d;
      if (d.coreIndex == coreB) dB := ?d;
    };
    
    switch (dA, dB) {
      case (?a, ?b) { if (dialectsMatch(a, b)) DIALECT_BONUS else 0.0 };
      case _ 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // POD MEMORY TRANSFER
  // ═══════════════════════════════════════════════════════════════════════════

  // Check if bond can form
  public func canFormBond(
    dialects         : [Dialect],
    coreA            : Nat,
    coreB            : Nat,
    sharedDuration   : Nat
  ) : Bool {
    if (sharedDuration < BOND_DURATION_MIN) return false;
    
    // Find dialects
    var dA : ?Dialect = null;
    var dB : ?Dialect = null;
    for (d in dialects.vals()) {
      if (d.coreIndex == coreA) dA := ?d;
      if (d.coreIndex == coreB) dB := ?d;
    };
    
    switch (dA, dB) {
      case (?a, ?b) dialectsMatch(a, b);
      case _ false;
    }
  };

  // Form pod bond
  public func formBond(
    coreA            : Nat,
    coreB            : Nat,
    matchingDialect  : Nat,
    currentBeat      : Nat
  ) : PodBond {
    {
      coreA = coreA;
      coreB = coreB;
      bondedAt = currentBeat;
      matchingDialect = matchingDialect;
      knowledgeShared = 0.0;
      ltmEntriesShared = 0;
      active = true;
    }
  };

  // Transfer knowledge through bond
  public func transferKnowledge(
    bond             : PodBond,
    senderKnowledge  : Float
  ) : (PodBond, Float) {
    let transfer = senderKnowledge * KNOWLEDGE_TRANSFER_RATE;
    
    let updatedBond : PodBond = {
      coreA = bond.coreA;
      coreB = bond.coreB;
      bondedAt = bond.bondedAt;
      matchingDialect = bond.matchingDialect;
      knowledgeShared = bond.knowledgeShared + transfer;
      ltmEntriesShared = bond.ltmEntriesShared + LTM_ENTRIES_SHARED;
      active = bond.active;
    };
    
    (updatedBond, transfer)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATRILINEAL SOCIETY
  // ═══════════════════════════════════════════════════════════════════════════

  // Preserve matriarch's Hz node forever
  public func preserveMatriarch(
    coreIndex        : Nat,
    hzNode           : Nat,
    coherence        : Float,
    currentBeat      : Nat
  ) : MatrilinealRecord {
    {
      coreIndex = coreIndex;
      hzNode = hzNode;
      preservedAt = currentBeat;
      coherenceAtPreserve = coherence;
      isActive = true;
    }
  };

  // Check if Hz node should be preserved (was previous matriarch)
  public func isPreservedHz(
    records          : [MatrilinealRecord],
    hzNode           : Nat
  ) : Bool {
    for (r in records.vals()) {
      if (r.hzNode == hzNode) return true;
    };
    false
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ECHOLOCATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Emit echo pulse and get return
  public func emitEcho(
    targetDistance   : Float,
    targetType       : Text,
    signalQuality    : Float,
    currentBeat      : Nat
  ) : EchoReturn {
    // Signal strength decays with distance squared
    let strength = signalQuality / (1.0 + targetDistance * targetDistance / 100.0);
    
    {
      targetDistance = targetDistance;
      targetType = targetType;
      signalStrength = strength;
      detectedAt = currentBeat;
    }
  };

  // Analyze echo returns for threats
  public func analyzeEchoes(echoes : [EchoReturn]) : {
    threatCount : Nat;
    nearestThreat : Float;
    opportunityCount : Nat;
  } {
    var threats = 0;
    var nearest = 1000.0;
    var opportunities = 0;
    
    for (e in echoes.vals()) {
      if (e.targetType == "THREAT") {
        threats += 1;
        if (e.targetDistance < nearest) {
          nearest := e.targetDistance;
        };
      } else if (e.targetType == "OPPORTUNITY") {
        opportunities += 1;
      };
    };
    
    { threatCount = threats; nearestThreat = nearest; opportunityCount = opportunities }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // COORDINATED HUNTING
  // ═══════════════════════════════════════════════════════════════════════════

  // Initiate coordinated hunt
  public func initiateHunt(
    targetId         : Nat,
    assignedCores    : [Nat],
    currentBeat      : Nat
  ) : HuntTarget {
    {
      targetId = targetId;
      assignedCores = assignedCores;
      coordinationScore = 0.0;
      progressPercent = 0.0;
      startBeat = currentBeat;
    }
  };

  // Update hunt progress based on Core coordination
  public func updateHunt(
    hunt             : HuntTarget,
    coreCoherences   : [Float],
    currentBeat      : Nat
  ) : HuntTarget {
    // Coordination score = mean coherence of assigned Cores
    var sumCoh = 0.0;
    var count = 0;
    
    for (coreIdx in hunt.assignedCores.vals()) {
      if (coreIdx < coreCoherences.size()) {
        sumCoh += coreCoherences[coreIdx];
        count += 1;
      };
    };
    
    let coordination = if (count > 0) sumCoh / Float.fromInt(count) else 0.0;
    
    // Progress increases based on coordination
    let progressDelta = coordination * 5.0;  // 5% per beat at max coordination
    let newProgress = min(100.0, hunt.progressPercent + progressDelta);
    
    {
      targetId = hunt.targetId;
      assignedCores = hunt.assignedCores;
      coordinationScore = coordination;
      progressPercent = newProgress;
      startBeat = hunt.startBeat;
    }
  };

  // Check if hunt completed
  public func isHuntComplete(hunt : HuntTarget) : Bool {
    hunt.progressPercent >= 100.0
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════

  public type OrcaTickResult = {
    updatedState     : OrcaState;
    newBondsFormed   : Nat;
    knowledgeTransferred : Float;
    huntsCompleted   : Nat;
    dialectBonuses   : Float;       // Total Q_hive bonus from dialects
  };

  public func orcaHeartbeat(
    state            : OrcaState,
    coreBeatCounts   : [Nat],
    coreCoherences   : [Float],
    coreKnowledge    : [Float],
    coreHzNodes      : [Nat],
    coreHzFreqs      : [Float],
    matriarchIndex   : Nat,
    currentBeat      : Nat
  ) : OrcaTickResult {
    var updatedState = state;
    var newBondsFormed : Nat = 0;
    var totalKnowledgeTransferred : Float = 0.0;
    var huntsCompleted : Nat = 0;
    
    // ─── Update Dialects ────────────────────────────────────────────────────
    let newDialects = Array.tabulate<Dialect>(coreBeatCounts.size(), func(i : Nat) : Dialect {
      let beatCount = coreBeatCounts[i];
      let freq = if (i < coreHzFreqs.size()) coreHzFreqs[i] else 0.0;
      updateDialect(i, beatCount, freq)
    });
    
    // ─── Calculate Dialect Bonuses ──────────────────────────────────────────
    var dialectBonuses : Float = 0.0;
    var i = 0;
    while (i < newDialects.size()) {
      var j = i + 1;
      while (j < newDialects.size()) {
        dialectBonuses += dialectQhiveBonus(newDialects, i, j);
        j += 1;
      };
      i += 1;
    };
    
    // ─── Process Bonds ──────────────────────────────────────────────────────
    let bondBuffer = Buffer.Buffer<PodBond>(state.activeBonds.size());
    
    // Check existing bonds for knowledge transfer
    for (bond in state.activeBonds.vals()) {
      if (bond.active) {
        // Transfer knowledge
        let senderK = if (bond.coreA < coreKnowledge.size()) coreKnowledge[bond.coreA] else 0.0;
        let (updatedBond, transferred) = transferKnowledge(bond, senderK);
        bondBuffer.add(updatedBond);
        totalKnowledgeTransferred += transferred;
      };
    };
    
    // Check for new bonds
    i := 0;
    while (i < coreBeatCounts.size()) {
      var j = i + 1;
      while (j < coreBeatCounts.size()) {
        // Simplified: check if matching dialects and not already bonded
        if (newDialects[i].dialectCluster == newDialects[j].dialectCluster) {
          var alreadyBonded = false;
          for (b in state.activeBonds.vals()) {
            if ((b.coreA == i and b.coreB == j) or (b.coreA == j and b.coreB == i)) {
              alreadyBonded := true;
            };
          };
          
          if (not alreadyBonded and coreBeatCounts[i] >= BOND_DURATION_MIN and coreBeatCounts[j] >= BOND_DURATION_MIN) {
            let newBond = formBond(i, j, newDialects[i].dialectCluster, currentBeat);
            bondBuffer.add(newBond);
            newBondsFormed += 1;
          };
        };
        j += 1;
      };
      i += 1;
    };
    
    // ─── Update Matrilineal Records ─────────────────────────────────────────
    var newMatrilineal = state.matrilinealRecords;
    
    // Check if matriarch changed
    switch (state.currentMatriarch) {
      case (?currentMat) {
        if (currentMat != matriarchIndex) {
          // Preserve old matriarch's Hz
          let hzNode = if (currentMat < coreHzNodes.size()) coreHzNodes[currentMat] else 0;
          let coh = if (currentMat < coreCoherences.size()) coreCoherences[currentMat] else 0.0;
          
          // Mark old as inactive, add new
          let oldRecord = preserveMatriarch(currentMat, hzNode, coh, currentBeat);
          let updatedOld = { oldRecord with isActive = false };
          newMatrilineal := Array.append(newMatrilineal, [updatedOld]);
        };
      };
      case null {};
    };
    
    // ─── Update Hunts ───────────────────────────────────────────────────────
    let huntBuffer = Buffer.Buffer<HuntTarget>(state.activeHunts.size());
    
    for (hunt in state.activeHunts.vals()) {
      let updatedHunt = updateHunt(hunt, coreCoherences, currentBeat);
      if (isHuntComplete(updatedHunt)) {
        huntsCompleted += 1;
      } else {
        huntBuffer.add(updatedHunt);
      };
    };
    
    // ─── Calculate Pod Coherence ────────────────────────────────────────────
    var sumCoh = 0.0;
    for (c in coreCoherences.vals()) {
      sumCoh += c;
    };
    let podCoh = if (coreCoherences.size() > 0) sumCoh / Float.fromInt(coreCoherences.size()) else 0.0;
    
    // ─── Build Updated State ────────────────────────────────────────────────
    updatedState := {
      dialects = newDialects;
      activeBonds = Buffer.toArray(bondBuffer);
      totalBonds = state.totalBonds + newBondsFormed;
      totalKnowledgeTransferred = state.totalKnowledgeTransferred + totalKnowledgeTransferred;
      matrilinealRecords = newMatrilineal;
      currentMatriarch = ?matriarchIndex;
      recentEchoes = state.recentEchoes;  // Would be updated from external
      echoCount = state.echoCount;
      activeHunts = Buffer.toArray(huntBuffer);
      completedHunts = state.completedHunts + huntsCompleted;
      huntSuccessRate = if (state.completedHunts + huntsCompleted > 0)
        Float.fromInt(state.completedHunts + huntsCompleted) / 
        Float.fromInt(state.completedHunts + huntsCompleted + huntBuffer.size())
        else 0.0;
      podCoherence = podCoh;
    };
    
    {
      updatedState = updatedState;
      newBondsFormed = newBondsFormed;
      knowledgeTransferred = totalKnowledgeTransferred;
      huntsCompleted = huntsCompleted;
      dialectBonuses = dialectBonuses;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initOrcaState() : OrcaState {
    {
      dialects = [];
      activeBonds = [];
      totalBonds = 0;
      totalKnowledgeTransferred = 0.0;
      matrilinealRecords = [];
      currentMatriarch = null;
      recentEchoes = [];
      echoCount = 0;
      activeHunts = [];
      completedHunts = 0;
      huntSuccessRate = 0.0;
      podCoherence = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  public type OrcaSummary = {
    dialectClusters  : Nat;
    activeBonds      : Nat;
    totalKnowledgeTransferred : Float;
    matrilinealCount : Nat;
    activeHunts      : Nat;
    completedHunts   : Nat;
    huntSuccessRate  : Float;
    podCoherence     : Float;
  };

  public func summarize(state : OrcaState) : OrcaSummary {
    // Count unique dialect clusters
    var clusters = 0;
    var seen : [Nat] = [];
    for (d in state.dialects.vals()) {
      var found = false;
      for (s in seen.vals()) {
        if (s == d.dialectCluster) found := true;
      };
      if (not found) {
        seen := Array.append(seen, [d.dialectCluster]);
        clusters += 1;
      };
    };
    
    {
      dialectClusters = clusters;
      activeBonds = state.activeBonds.size();
      totalKnowledgeTransferred = state.totalKnowledgeTransferred;
      matrilinealCount = state.matrilinealRecords.size();
      activeHunts = state.activeHunts.size();
      completedHunts = state.completedHunts;
      huntSuccessRate = state.huntSuccessRate;
      podCoherence = state.podCoherence;
    }
  };

}
