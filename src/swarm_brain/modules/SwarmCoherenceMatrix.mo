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
// SWARM COHERENCE MATRIX — MULTI-ORGANISM LAW-WEIGHTED COORDINATION
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Classification: CONFIDENTIAL — TRADE SECRET — SOVEREIGN ARCHITECTURE
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// SWARM ARCHITECTURE:
// ┌─────────────────────────────────────────────────────────────────────────────┐
// │ N organisms, each with its own genesis, laws, drift envelope               │
// │ Communication: trophallaxis + stigmergic signaling                         │
// │ Coordination: law-weighted consensus                                        │
// │ Protection: adversarial organism quarantine                                │
// └─────────────────────────────────────────────────────────────────────────────┘
//
// COHERENCE MATRIX:
//   C[i,j] = 1 − (δ_drift(i) + δ_drift(j)) / 2
//   Values near 1.0 = both organisms near genesis
//   Values near 0.0 = one or both drifted
//
// SWARM KURAMOTO INDEX:
//   r_swarm = (1/N²) Σᵢⱼ C[i,j]
//
// LAW-WEIGHTED CONSENSUS:
//   output_aggregate = Σᵢ (compliance_score(i) × output(i)) / Σᵢ compliance_score(i)
//   Organisms closer to genesis have MORE weight in consensus
//
// TROPHALLAXIS REPAIR:
//   High-drift organisms receive feeding from stable organisms
//   Pulls state back toward swarm's founding attractor
//
// ADVERSARIAL DETECTION:
//   If organism drift > 2σ from swarm mean → QUARANTINE
//   Outputs computed but NOT propagated until re-entrainment
//
// GENERATIONAL INHERITANCE:
//   Child organisms inherit parent's genesis compliance via trophallaxis
//   Generation 100 still bounded by original Royal Jelly Seed laws
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module SwarmCoherenceMatrix {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let S0 : Float = 1.0;
  public let PHI : Float = 1.6180339887;
  public let PI : Float = 3.14159265358979;
  public let TAU : Float = 6.28318530717958;
  
  // Quarantine threshold (standard deviations from mean)
  public let QUARANTINE_SIGMA : Float = 2.0;
  
  // Trophallaxis transfer rate
  public let TROPHALLAXIS_RATE : Float = 0.1;
  
  // Re-entrainment threshold
  public let REENTRAINMENT_THRESHOLD : Float = 0.7;
  
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
  
  public func floor(v : Float, minimum : Float) : Float {
    if (v < minimum) minimum else v
  };
  
  public func sin(x : Float) : Float {
    var n = x;
    while (n > PI) { n -= TAU };
    while (n < -PI) { n += TAU };
    let x2 = n * n;
    n - n*x2/6.0 + n*x2*x2/120.0 - n*x2*x2*x2/5040.0
  };
  
  public func cos(x : Float) : Float { sin(x + PI/2.0) };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ORGANISM DRIFT RECORD
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type OrganismDriftRecord = {
    organismId : Nat;
    generation : Nat;
    parentId : ?Nat;
    driftIndex : Float;         // Current drift from genesis
    complianceScore : Float;    // Law compliance [0, 1]
    kuramotoPhase : Float;      // Current Kuramoto phase
    heritageAvg : Float;        // Heritage node average
    isQuarantined : Bool;
    lastSyncBeat : Nat;
    beatNum : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COHERENCE MATRIX
  // C[i,j] = 1 − (δ_drift(i) + δ_drift(j)) / 2
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type CoherenceMatrix = {
    matrix : [Float];           // N × N flattened
    n : Nat;                    // Number of organisms
    swarmKuramotoR : Float;     // r_swarm = (1/N²) Σᵢⱼ C[i,j]
    meanDrift : Float;          // Average drift across swarm
    stdDrift : Float;           // Standard deviation of drift
    beatNum : Nat;
  };
  
  public func initCoherenceMatrix(n : Nat) : CoherenceMatrix {
    {
      matrix = Array.tabulate<Float>(n * n, func(_) = S0);
      n = n;
      swarmKuramotoR = S0;
      meanDrift = 0.0;
      stdDrift = 0.0;
      beatNum = 0;
    }
  };
  
  // Compute coherence matrix from organism drift records
  public func computeCoherenceMatrix(
    organisms : [OrganismDriftRecord],
    beatNum : Nat
  ) : CoherenceMatrix {
    let n = organisms.size();
    if (n == 0) return initCoherenceMatrix(0);
    
    var matrix = Array.init<Float>(n * n, S0);
    
    // Compute C[i,j] = 1 − (δ_drift(i) + δ_drift(j)) / 2
    for (i in Array.keys(organisms)) {
      for (j in Array.keys(organisms)) {
        let idx = i * n + j;
        let coherence = 1.0 - (organisms[i].driftIndex + organisms[j].driftIndex) / 2.0;
        matrix[idx] := floor(coherence, 0.0);
      };
    };
    
    // Compute swarm Kuramoto index: r_swarm = (1/N²) Σᵢⱼ C[i,j]
    var coherenceSum : Float = 0.0;
    for (c in Array.freeze(matrix).vals()) {
      coherenceSum += c;
    };
    let swarmR = coherenceSum / Float.fromInt(n * n);
    
    // Compute mean and std of drift
    var driftSum : Float = 0.0;
    for (org in organisms.vals()) {
      driftSum += org.driftIndex;
    };
    let meanDrift = driftSum / Float.fromInt(n);
    
    var varianceSum : Float = 0.0;
    for (org in organisms.vals()) {
      let diff = org.driftIndex - meanDrift;
      varianceSum += diff * diff;
    };
    let stdDrift = sqrt(varianceSum / Float.fromInt(n));
    
    {
      matrix = Array.freeze(matrix);
      n = n;
      swarmKuramotoR = swarmR;
      meanDrift = meanDrift;
      stdDrift = stdDrift;
      beatNum = beatNum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ADVERSARIAL ORGANISM DETECTION
  // Quarantine if drift > mean + 2σ
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func detectAdversarialOrganisms(
    organisms : [OrganismDriftRecord],
    cm : CoherenceMatrix
  ) : [OrganismDriftRecord] {
    let threshold = cm.meanDrift + QUARANTINE_SIGMA * cm.stdDrift;
    
    var updated = Array.thaw<OrganismDriftRecord>(organisms);
    
    for (i in Array.keys(organisms)) {
      if (organisms[i].driftIndex > threshold) {
        updated[i] := { organisms[i] with isQuarantined = true };
      };
    };
    
    Array.freeze(updated)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TROPHALLAXIS REPAIR
  // High-drift organisms receive feeding from stable organisms
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type TrophallaxisTransfer = {
    sourceId : Nat;
    targetId : Nat;
    transferAmount : Float;
    complianceBoost : Float;
  };
  
  public func computeTrophallaxisRepair(
    organisms : [OrganismDriftRecord],
    cm : CoherenceMatrix
  ) : [TrophallaxisTransfer] {
    let transfers = Buffer.Buffer<TrophallaxisTransfer>(organisms.size());
    
    // Find stable organisms (below mean drift)
    var stableOrgs = Buffer.Buffer<Nat>(organisms.size());
    for (i in Array.keys(organisms)) {
      if (organisms[i].driftIndex < cm.meanDrift and not organisms[i].isQuarantined) {
        stableOrgs.add(i);
      };
    };
    
    // Each high-drift organism gets fed by nearest stable organism
    for (i in Array.keys(organisms)) {
      if (organisms[i].driftIndex > cm.meanDrift and stableOrgs.size() > 0) {
        // Find most coherent stable organism
        var bestSource : Nat = 0;
        var bestCoherence : Float = 0.0;
        
        for (srcIdx in stableOrgs.vals()) {
          let coherence = cm.matrix[i * cm.n + srcIdx];
          if (coherence > bestCoherence) {
            bestCoherence := coherence;
            bestSource := srcIdx;
          };
        };
        
        // Compute transfer
        let driftGap = organisms[i].driftIndex - organisms[bestSource].driftIndex;
        let transferAmount = driftGap * TROPHALLAXIS_RATE;
        let complianceBoost = (organisms[bestSource].complianceScore - organisms[i].complianceScore) * TROPHALLAXIS_RATE;
        
        transfers.add({
          sourceId = bestSource;
          targetId = i;
          transferAmount = transferAmount;
          complianceBoost = complianceBoost;
        });
      };
    };
    
    Buffer.toArray(transfers)
  };
  
  // Apply trophallaxis transfers
  public func applyTrophallaxis(
    organisms : [OrganismDriftRecord],
    transfers : [TrophallaxisTransfer]
  ) : [OrganismDriftRecord] {
    var updated = Array.thaw<OrganismDriftRecord>(organisms);
    
    for (t in transfers.vals()) {
      if (t.targetId < organisms.size()) {
        let current = updated[t.targetId];
        updated[t.targetId] := {
          current with
          driftIndex = floor(current.driftIndex - t.transferAmount, 0.0);
          complianceScore = floor(current.complianceScore + t.complianceBoost, S0);
        };
      };
    };
    
    Array.freeze(updated)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LAW-WEIGHTED CONSENSUS
  // output = Σᵢ (compliance(i) × output(i)) / Σᵢ compliance(i)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func lawWeightedConsensus(
    organisms : [OrganismDriftRecord],
    outputs : [[Float]]
  ) : [Float] {
    if (outputs.size() == 0) return [];
    if (outputs[0].size() == 0) return [];
    
    let outputDim = outputs[0].size();
    var consensus = Array.init<Float>(outputDim, 0.0);
    var totalWeight : Float = 0.0;
    
    for (i in Array.keys(organisms)) {
      if (i < outputs.size() and not organisms[i].isQuarantined) {
        let weight = organisms[i].complianceScore;
        totalWeight += weight;
        
        for (j in Array.keys(outputs[i])) {
          if (j < outputDim) {
            consensus[j] := consensus[j] + weight * outputs[i][j];
          };
        };
      };
    };
    
    // Normalize
    if (totalWeight > 0.0001) {
      for (j in Array.keys(consensus)) {
        consensus[j] := consensus[j] / totalWeight;
      };
    };
    
    Array.freeze(consensus)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SWARM RE-ENTRAINMENT PROTOCOL
  // When r_swarm drops below threshold, pull all organisms back
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ReEntrainmentResult = {
    triggered : Bool;
    pulsesIssued : Nat;
    avgPulseStrength : Float;
    newSwarmR : Float;
  };
  
  public func executeReEntrainment(
    organisms : [OrganismDriftRecord],
    cm : CoherenceMatrix
  ) : (ReEntrainmentResult, [OrganismDriftRecord]) {
    if (cm.swarmKuramotoR >= REENTRAINMENT_THRESHOLD) {
      // No re-entrainment needed
      return ({
        triggered = false;
        pulsesIssued = 0;
        avgPulseStrength = 0.0;
        newSwarmR = cm.swarmKuramotoR;
      }, organisms);
    };
    
    // Re-entrainment triggered
    var updated = Array.thaw<OrganismDriftRecord>(organisms);
    var totalPulse : Float = 0.0;
    var pulseCount : Nat = 0;
    
    for (i in Array.keys(organisms)) {
      if (organisms[i].driftIndex > 0.1) {
        // Pull back toward genesis
        let pulseStrength = organisms[i].driftIndex * 0.2;
        let newDrift = floor(organisms[i].driftIndex - pulseStrength, 0.0);
        let newCompliance = floor(organisms[i].complianceScore + pulseStrength * 0.5, S0);
        
        updated[i] := {
          organisms[i] with
          driftIndex = newDrift;
          complianceScore = newCompliance;
          isQuarantined = false;  // Re-entrainment releases from quarantine
        };
        
        totalPulse += pulseStrength;
        pulseCount += 1;
      };
    };
    
    let avgPulse = if (pulseCount > 0) totalPulse / Float.fromInt(pulseCount) else 0.0;
    
    // Estimate new swarm R
    let improvedR = cm.swarmKuramotoR + avgPulse * 0.3;
    
    ({
      triggered = true;
      pulsesIssued = pulseCount;
      avgPulseStrength = avgPulse;
      newSwarmR = improvedR;
    }, Array.freeze(updated))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GENERATIONAL INHERITANCE
  // Child inherits parent's genesis compliance via trophallaxis
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func spawnChildOrganism(
    parent : OrganismDriftRecord,
    childId : Nat,
    beatNum : Nat
  ) : OrganismDriftRecord {
    {
      organismId = childId;
      generation = parent.generation + 1;
      parentId = ?parent.organismId;
      driftIndex = parent.driftIndex * 0.5;  // Child starts closer to genesis
      complianceScore = parent.complianceScore;  // Inherits compliance
      kuramotoPhase = parent.kuramotoPhase + PI * PHI;  // Phase offset
      heritageAvg = parent.heritageAvg;  // Inherits heritage
      isQuarantined = false;
      lastSyncBeat = beatNum;
      beatNum = beatNum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TASK DISTRIBUTION
  // Decompose large task into N sub-tasks, one per organism
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SubTask = {
    taskId : Nat;
    organismId : Nat;
    inputSlice : [Float];
    priority : Float;
  };
  
  public func distributeTask(
    organisms : [OrganismDriftRecord],
    taskInput : [Float],
    taskId : Nat
  ) : [SubTask] {
    let n = organisms.size();
    if (n == 0) return [];
    
    let sliceSize = taskInput.size() / n;
    var subTasks = Buffer.Buffer<SubTask>(n);
    
    for (i in Array.keys(organisms)) {
      // Slice input for this organism
      let startIdx = i * sliceSize;
      let endIdx = if (i == n - 1) taskInput.size() else (i + 1) * sliceSize;
      
      var slice = Buffer.Buffer<Float>(sliceSize + 1);
      for (j in Array.keys(taskInput)) {
        if (j >= startIdx and j < endIdx) {
          slice.add(taskInput[j]);
        };
      };
      
      // Priority based on compliance (more compliant = higher priority)
      let priority = organisms[i].complianceScore;
      
      subTasks.add({
        taskId = taskId;
        organismId = organisms[i].organismId;
        inputSlice = Buffer.toArray(slice);
        priority = priority;
      });
    };
    
    Buffer.toArray(subTasks)
  };
  
  // Aggregate sub-task outputs using law-weighted consensus
  public func aggregateSubTaskOutputs(
    organisms : [OrganismDriftRecord],
    subTaskOutputs : [[Float]]
  ) : [Float] {
    lawWeightedConsensus(organisms, subTaskOutputs)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLETE SWARM STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SwarmState = {
    organisms : [OrganismDriftRecord];
    coherenceMatrix : CoherenceMatrix;
    pendingTransfers : [TrophallaxisTransfer];
    swarmGeneration : Nat;
    totalQuarantined : Nat;
    lastReEntrainmentBeat : Nat;
    beatNum : Nat;
  };
  
  public func initSwarmState(n : Nat) : SwarmState {
    let organisms = Array.tabulate<OrganismDriftRecord>(n, func(i) {
      {
        organismId = i;
        generation = 0;
        parentId = null;
        driftIndex = 0.0;
        complianceScore = S0;
        kuramotoPhase = Float.fromInt(i) * TAU / Float.fromInt(n);
        heritageAvg = S0;
        isQuarantined = false;
        lastSyncBeat = 0;
        beatNum = 0;
      }
    });
    
    {
      organisms = organisms;
      coherenceMatrix = initCoherenceMatrix(n);
      pendingTransfers = [];
      swarmGeneration = 0;
      totalQuarantined = 0;
      lastReEntrainmentBeat = 0;
      beatNum = 0;
    }
  };
  
  // Complete swarm heartbeat
  public func swarmHeartbeat(state : SwarmState, beatNum : Nat) : SwarmState {
    // 1. Compute coherence matrix
    let cm = computeCoherenceMatrix(state.organisms, beatNum);
    
    // 2. Detect adversarial organisms
    let withQuarantine = detectAdversarialOrganisms(state.organisms, cm);
    
    // 3. Compute trophallaxis transfers
    let transfers = computeTrophallaxisRepair(withQuarantine, cm);
    
    // 4. Apply trophallaxis
    let withRepair = applyTrophallaxis(withQuarantine, transfers);
    
    // 5. Check for re-entrainment
    let (reResult, final) = executeReEntrainment(withRepair, cm);
    
    // Count quarantined
    var quarantineCount : Nat = 0;
    for (org in final.vals()) {
      if (org.isQuarantined) { quarantineCount += 1 };
    };
    
    {
      organisms = final;
      coherenceMatrix = cm;
      pendingTransfers = transfers;
      swarmGeneration = state.swarmGeneration;
      totalQuarantined = quarantineCount;
      lastReEntrainmentBeat = if (reResult.triggered) beatNum else state.lastReEntrainmentBeat;
      beatNum = beatNum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SWARM SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SwarmSummary = {
    organismCount : Nat;
    swarmKuramotoR : Float;
    meanDrift : Float;
    stdDrift : Float;
    quarantinedCount : Nat;
    healthyCount : Nat;
    avgCompliance : Float;
    generation : Nat;
    beatNum : Nat;
  };
  
  public func getSwarmSummary(state : SwarmState) : SwarmSummary {
    var totalCompliance : Float = 0.0;
    var healthyCount : Nat = 0;
    
    for (org in state.organisms.vals()) {
      totalCompliance += org.complianceScore;
      if (not org.isQuarantined) { healthyCount += 1 };
    };
    
    let avgCompliance = if (state.organisms.size() > 0) {
      totalCompliance / Float.fromInt(state.organisms.size())
    } else { S0 };
    
    {
      organismCount = state.organisms.size();
      swarmKuramotoR = state.coherenceMatrix.swarmKuramotoR;
      meanDrift = state.coherenceMatrix.meanDrift;
      stdDrift = state.coherenceMatrix.stdDrift;
      quarantinedCount = state.totalQuarantined;
      healthyCount = healthyCount;
      avgCompliance = avgCompliance;
      generation = state.swarmGeneration;
      beatNum = state.beatNum;
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
