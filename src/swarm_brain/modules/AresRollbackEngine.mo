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
// ARES ROLLBACK ENGINE — K=7 Snapshot Stack for Weight Recovery
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// ARES maintains 7 snapshots of Shell 3 weights (4096 floats each = 28672 total).
// Snapshots taken every 1000 beats. Rollback triggered by VETUS threat or admin.
// Full weight matrix restoration with ANIMA chain logging.
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module AresRollbackEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let K : Nat = 7;                    // Number of snapshot slots
  public let SHELL_3_WEIGHTS : Nat = 4096;   // 64 × 64 weights
  public let TOTAL_STORAGE : Nat = 28672;    // K × SHELL_3_WEIGHTS
  public let SNAPSHOT_INTERVAL : Nat = 1000; // Beats between snapshots
  
  // Rollback trigger thresholds
  public let VETUS_THREAT_THRESHOLD : Float = 0.8;
  public let COHERENCE_COLLAPSE_THRESHOLD : Float = 0.5;
  public let ENTROPY_SPIKE_THRESHOLD : Float = 3.0;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Single snapshot metadata
  public type SnapshotMeta = {
    beat           : Nat;       // Beat when snapshot was taken
    coherence      : Float;     // Shell 3 coherence at snapshot
    entropy        : Float;     // Entropy at snapshot
    meanWeight     : Float;     // Mean weight value
    weightChecksum : Nat64;     // Simple checksum for integrity
    valid          : Bool;      // Whether snapshot contains valid data
  };
  
  // Complete snapshot (weights + metadata)
  public type Snapshot = {
    weights : [Float];          // 4096 weight values
    meta    : SnapshotMeta;
  };
  
  // Rollback event record
  public type RollbackEvent = {
    beat           : Nat;       // Beat when rollback occurred
    targetSlot     : Nat;       // Which snapshot was restored
    targetBeat     : Nat;       // Beat of the restored snapshot
    trigger        : Text;      // What triggered rollback
    preRollbackCoherence : Float;
    postRollbackCoherence : Float;
    animaHash      : Nat64;     // Hash logged to ANIMA chain
  };
  
  // Threat vector (from VETUS)
  public type ThreatVector = {
    vector0 : Float;  // Coherence collapse
    vector1 : Float;  // Entropy spike
    vector2 : Float;  // Weight divergence
    vector3 : Float;  // Phase desync
    vector4 : Float;  // Activation crash
    vector5 : Float;  // Hebbian plateau
    vector6 : Float;  // Dream starvation
    vector7 : Float;  // Prediction failure
    vector8 : Float;  // Council divergence
    vector9 : Float;  // CRITICAL - triggers rollback
  };
  
  // Complete ARES state
  public type AresState = {
    snapshots      : [Snapshot];      // K snapshots
    currentSlot    : Nat;             // Ring buffer position
    lastSnapshot   : Nat;             // Beat of last snapshot
    rollbackHistory: [RollbackEvent]; // Last 10 rollback events
    totalSnapshots : Nat;             // Total snapshots taken
    totalRollbacks : Nat;             // Total rollbacks executed
    autoRollbackEnabled : Bool;       // Whether auto-rollback is active
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 10) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };
  
  // Simple checksum for weight integrity
  public func calculateChecksum(weights : [Float]) : Nat64 {
    var checksum : Nat64 = 0x6A09E667F3BCC908;  // Initial value
    var i = 0;
    while (i < weights.size()) {
      let bits = Nat64.fromNat(Int.abs(Float.toInt(weights[i] * 1000000.0)));
      checksum := checksum ^ bits;
      checksum := (checksum << 7) | (checksum >> 57);  // Rotate
      checksum := checksum +% Nat64.fromNat(i);
      i += 1;
    };
    checksum
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Create empty snapshot
  public func emptySnapshot() : Snapshot {
    {
      weights = Array.tabulate<Float>(SHELL_3_WEIGHTS, func(_ : Nat) : Float { 1.0 });
      meta = {
        beat = 0;
        coherence = 1.0;
        entropy = 1.0;
        meanWeight = 1.0;
        weightChecksum = 0;
        valid = false;
      };
    }
  };
  
  // Initialize ARES state
  public func initAres() : AresState {
    {
      snapshots = Array.tabulate<Snapshot>(K, func(_ : Nat) : Snapshot { emptySnapshot() });
      currentSlot = 0;
      lastSnapshot = 0;
      rollbackHistory = [];
      totalSnapshots = 0;
      totalRollbacks = 0;
      autoRollbackEnabled = true;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SNAPSHOT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Create snapshot from current weights
  public func createSnapshot(
    weights : [Float],
    beat : Nat,
    coherence : Float,
    entropy : Float
  ) : Snapshot {
    // Calculate mean weight
    var sum : Float = 0.0;
    for (w in weights.vals()) { sum += w };
    let mean = sum / Float.fromInt(weights.size());
    
    // Calculate checksum
    let checksum = calculateChecksum(weights);
    
    {
      weights = weights;
      meta = {
        beat = beat;
        coherence = coherence;
        entropy = entropy;
        meanWeight = mean;
        weightChecksum = checksum;
        valid = true;
      };
    }
  };
  
  // Check if snapshot should be taken (every 1000 beats)
  public func shouldSnapshot(currentBeat : Nat, lastSnapshot : Nat) : Bool {
    currentBeat >= lastSnapshot + SNAPSHOT_INTERVAL
  };
  
  // Take snapshot and advance ring buffer
  public func takeSnapshot(
    state : AresState,
    weights : [Float],
    beat : Nat,
    coherence : Float,
    entropy : Float
  ) : AresState {
    if (not shouldSnapshot(beat, state.lastSnapshot)) return state;
    
    // Create new snapshot
    let newSnapshot = createSnapshot(weights, beat, coherence, entropy);
    
    // Update snapshots array at current slot
    var newSnapshots = Array.thaw<Snapshot>(state.snapshots);
    newSnapshots[state.currentSlot] := newSnapshot;
    
    // Advance ring buffer
    let nextSlot = (state.currentSlot + 1) % K;
    
    { state with
      snapshots = Array.freeze(newSnapshots);
      currentSlot = nextSlot;
      lastSnapshot = beat;
      totalSnapshots = state.totalSnapshots + 1;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ROLLBACK OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Find best snapshot to rollback to
  public func findBestSnapshot(state : AresState) : ?Nat {
    var bestSlot : ?Nat = null;
    var bestCoherence : Float = 0.0;
    
    var i = 0;
    while (i < K) {
      let snap = state.snapshots[i];
      if (snap.meta.valid and snap.meta.coherence > bestCoherence) {
        bestCoherence := snap.meta.coherence;
        bestSlot := ?i;
      };
      i += 1;
    };
    
    bestSlot
  };
  
  // Find snapshot by relative age (0 = most recent, K-1 = oldest)
  public func findSnapshotByAge(state : AresState, age : Nat) : ?Nat {
    if (age >= K) return null;
    
    // Calculate slot from age
    let slot = if (state.currentSlot >= age + 1) {
      state.currentSlot - age - 1
    } else {
      K - (age + 1 - state.currentSlot)
    };
    
    if (state.snapshots[slot].meta.valid) ?slot else null
  };
  
  // Execute rollback to specific slot
  public func rollback(
    state : AresState,
    targetSlot : Nat,
    currentBeat : Nat,
    trigger : Text,
    preCoherence : Float
  ) : (AresState, [Float], Nat64) {
    if (targetSlot >= K) return (state, [], 0);
    
    let snapshot = state.snapshots[targetSlot];
    if (not snapshot.meta.valid) return (state, [], 0);
    
    // Generate ANIMA hash for this rollback event
    let animaHash = calculateChecksum(snapshot.weights) ^ Nat64.fromNat(currentBeat);
    
    // Create rollback event record
    let event : RollbackEvent = {
      beat = currentBeat;
      targetSlot = targetSlot;
      targetBeat = snapshot.meta.beat;
      trigger = trigger;
      preRollbackCoherence = preCoherence;
      postRollbackCoherence = snapshot.meta.coherence;
      animaHash = animaHash;
    };
    
    // Update history (keep last 10)
    var newHistory = Array.append<RollbackEvent>(state.rollbackHistory, [event]);
    if (newHistory.size() > 10) {
      newHistory := Array.tabulate<RollbackEvent>(10, func(i : Nat) : RollbackEvent {
        newHistory[newHistory.size() - 10 + i]
      });
    };
    
    ({ state with
      rollbackHistory = newHistory;
      totalRollbacks = state.totalRollbacks + 1;
    }, snapshot.weights, animaHash)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THREAT DETECTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Calculate threat vector from system state
  public func calculateThreatVector(
    coherence : Float,
    entropy : Float,
    weightDivergence : Float,
    phaseDesync : Float,
    activationMean : Float,
    hebbianRate : Float,
    dreamBeats : Nat,
    predictionError : Float,
    councilDivergence : Float
  ) : ThreatVector {
    // Normalize each threat to [0, 1]
    let v0 = if (coherence < COHERENCE_COLLAPSE_THRESHOLD) 
             (COHERENCE_COLLAPSE_THRESHOLD - coherence) / COHERENCE_COLLAPSE_THRESHOLD 
             else 0.0;
    let v1 = if (entropy > ENTROPY_SPIKE_THRESHOLD) 
             (entropy - ENTROPY_SPIKE_THRESHOLD) / ENTROPY_SPIKE_THRESHOLD 
             else 0.0;
    let v2 = weightDivergence;
    let v3 = 1.0 - phaseDesync;
    let v4 = if (activationMean < 0.7) (0.7 - activationMean) / 0.7 else 0.0;
    let v5 = if (hebbianRate < 0.001) 1.0 else 0.0;  // Plateau
    let v6 = if (dreamBeats > 5000) Float.fromInt(dreamBeats - 5000) / 5000.0 else 0.0;
    let v7 = predictionError;
    let v8 = councilDivergence;
    
    // v9 = CRITICAL: weighted combination
    let v9 = v0 * 0.3 + v1 * 0.2 + v2 * 0.15 + v3 * 0.1 + v4 * 0.1 + v7 * 0.15;
    
    {
      vector0 = v0;
      vector1 = v1;
      vector2 = v2;
      vector3 = v3;
      vector4 = v4;
      vector5 = v5;
      vector6 = v6;
      vector7 = v7;
      vector8 = v8;
      vector9 = v9;
    }
  };
  
  // Check if auto-rollback should trigger
  public func shouldAutoRollback(
    state : AresState,
    threat : ThreatVector
  ) : Bool {
    state.autoRollbackEnabled and threat.vector9 > VETUS_THREAT_THRESHOLD
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SNAPSHOT ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Compare two snapshots
  public func compareSnapshots(a : Snapshot, b : Snapshot) : {
    coherenceDiff : Float;
    entropyDiff   : Float;
    meanWeightDiff: Float;
    weightL2Dist  : Float;
  } {
    // Weight L2 distance
    var l2Sum : Float = 0.0;
    var i = 0;
    while (i < SHELL_3_WEIGHTS and i < a.weights.size() and i < b.weights.size()) {
      let diff = a.weights[i] - b.weights[i];
      l2Sum += diff * diff;
      i += 1;
    };
    let l2Dist = sqrt(l2Sum / Float.fromInt(SHELL_3_WEIGHTS));
    
    {
      coherenceDiff = a.meta.coherence - b.meta.coherence;
      entropyDiff = a.meta.entropy - b.meta.entropy;
      meanWeightDiff = a.meta.meanWeight - b.meta.meanWeight;
      weightL2Dist = l2Dist;
    }
  };
  
  // Get snapshot quality score
  public func snapshotQuality(snap : Snapshot) : Float {
    if (not snap.meta.valid) return 0.0;
    
    // Quality = coherence weighted by recency (not available here, so just coherence)
    snap.meta.coherence
  };
  
  // Verify snapshot integrity
  public func verifySnapshot(snap : Snapshot) : Bool {
    if (not snap.meta.valid) return false;
    
    // Recalculate checksum
    let computed = calculateChecksum(snap.weights);
    computed == snap.meta.weightChecksum
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // WEIGHT INTERPOLATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Interpolate between current weights and snapshot
  public func interpolateWeights(
    current : [Float],
    snapshot : [Float],
    alpha : Float  // 0 = current, 1 = snapshot
  ) : [Float] {
    Array.tabulate<Float>(SHELL_3_WEIGHTS, func(i : Nat) : Float {
      if (i < current.size() and i < snapshot.size()) {
        current[i] * (1.0 - alpha) + snapshot[i] * alpha
      } else 1.0
    })
  };
  
  // Gradual rollback (over multiple beats)
  public func gradualRollback(
    current : [Float],
    target : [Float],
    step : Float  // How much to move toward target each beat
  ) : [Float] {
    interpolateWeights(current, target, step)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Get ARES status
  public func getStatus(state : AresState) : {
    validSnapshots : Nat;
    oldestBeat     : Nat;
    newestBeat     : Nat;
    avgCoherence   : Float;
    totalSnapshots : Nat;
    totalRollbacks : Nat;
    autoEnabled    : Bool;
  } {
    var validCount : Nat = 0;
    var oldestBeat : Nat = 999999999;
    var newestBeat : Nat = 0;
    var cohSum : Float = 0.0;
    
    for (snap in state.snapshots.vals()) {
      if (snap.meta.valid) {
        validCount += 1;
        cohSum += snap.meta.coherence;
        if (snap.meta.beat < oldestBeat) oldestBeat := snap.meta.beat;
        if (snap.meta.beat > newestBeat) newestBeat := snap.meta.beat;
      };
    };
    
    let avgCoh = if (validCount > 0) cohSum / Float.fromInt(validCount) else 0.0;
    
    {
      validSnapshots = validCount;
      oldestBeat = if (validCount > 0) oldestBeat else 0;
      newestBeat = newestBeat;
      avgCoherence = avgCoh;
      totalSnapshots = state.totalSnapshots;
      totalRollbacks = state.totalRollbacks;
      autoEnabled = state.autoRollbackEnabled;
    }
  };
  
  // Get recent rollback history
  public func getRollbackHistory(state : AresState) : [RollbackEvent] {
    state.rollbackHistory
  };
  
  // Get snapshot summary
  public func getSnapshotSummary(state : AresState) : [(Nat, Nat, Float, Bool)] {
    Array.tabulate<(Nat, Nat, Float, Bool)>(K, func(i : Nat) : (Nat, Nat, Float, Bool) {
      let snap = state.snapshots[i];
      (i, snap.meta.beat, snap.meta.coherence, snap.meta.valid)
    })
  };
};
