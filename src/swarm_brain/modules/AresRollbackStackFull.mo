// ============================================================================
// ARES K=7 ROLLBACK STACK — Weight Matrix Snapshots
// ============================================================================
// PHASE E: 7 snapshots × 4096 weights = 28672 stable Floats
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Rule: 100% of all value routes to creator reserve
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";

module AresRollbackStack {
    
    // ========================================================================
    // ARES CONFIGURATION
    // ========================================================================
    // K = 7 snapshots
    // Each snapshot = 4096 Shell 3 weights (64 × 64)
    // Total storage = 28672 Floats
    // Snapshot every 1000 beats
    // Rollback triggers: VETUS threat vector 9 > threshold OR admin command
    // ========================================================================
    
    public type AresState = {
        // 7 snapshots × 4096 weights each
        snapshots: [[Float]];           // K=7 arrays of 4096 Floats
        snapshotBeats: [Nat];           // Beat number when each snapshot was taken
        currentSlot: Nat;               // Next slot to write (circular)
        totalSnapshots: Nat;            // Total snapshots taken
        
        // Snapshot configuration
        snapshotInterval: Nat;          // 1000 beats between snapshots
        lastSnapshotBeat: Nat;
        
        // Rollback state
        rollbackCount: Nat;             // Total rollbacks performed
        lastRollbackBeat: Nat;
        lastRollbackSlot: Nat;          // Which snapshot was restored
        rollbackLog: [RollbackEvent];   // History of rollbacks
        
        // Threat monitoring
        vetusThreshold: Float;          // Threshold for auto-rollback
        threatVector9: Float;           // Current VETUS threat level
        
        // Beat tracking
        beatCount: Nat;
    };
    
    public type RollbackEvent = {
        beat: Nat;
        slotRestored: Nat;
        trigger: RollbackTrigger;
        weightsDelta: Float;            // How much weights changed
        animaLogHash: Nat32;            // ANIMA chain entry
    };
    
    public type RollbackTrigger = {
        #vetusThreshold;
        #adminCommand;
        #emergencyProtocol;
        #doctrineViolation;
    };
    
    // ========================================================================
    // SNAPSHOT OPERATIONS
    // ========================================================================
    
    // Take a snapshot of current weights
    public func takeSnapshot(
        state: AresState,
        currentWeights: [Float],
        currentBeat: Nat
    ) : AresState {
        
        // Check if it's time for a snapshot
        if (currentBeat < state.lastSnapshotBeat + state.snapshotInterval) {
            return state;  // Not time yet
        };
        
        // Validate weight array size
        let weightsToStore = if (currentWeights.size() >= 4096) {
            Array.tabulate<Float>(4096, func(i: Nat) : Float {
                currentWeights[i]
            })
        } else {
            // Pad with 1.0 if not enough weights
            Array.tabulate<Float>(4096, func(i: Nat) : Float {
                if (i < currentWeights.size()) { currentWeights[i] } else { 1.0 }
            })
        };
        
        // Store in circular buffer
        let newSnapshots = Array.tabulate<[Float]>(7, func(i: Nat) : [Float] {
            if (i == state.currentSlot) {
                weightsToStore
            } else if (i < state.snapshots.size()) {
                state.snapshots[i]
            } else {
                Array.tabulate<Float>(4096, func(_: Nat) : Float { 1.0 })
            }
        });
        
        // Update beat tracking
        let newSnapshotBeats = Array.tabulate<Nat>(7, func(i: Nat) : Nat {
            if (i == state.currentSlot) {
                currentBeat
            } else if (i < state.snapshotBeats.size()) {
                state.snapshotBeats[i]
            } else {
                0
            }
        });
        
        // Advance circular pointer
        let nextSlot = (state.currentSlot + 1) % 7;
        
        {
            snapshots = newSnapshots;
            snapshotBeats = newSnapshotBeats;
            currentSlot = nextSlot;
            totalSnapshots = state.totalSnapshots + 1;
            
            snapshotInterval = state.snapshotInterval;
            lastSnapshotBeat = currentBeat;
            
            rollbackCount = state.rollbackCount;
            lastRollbackBeat = state.lastRollbackBeat;
            lastRollbackSlot = state.lastRollbackSlot;
            rollbackLog = state.rollbackLog;
            
            vetusThreshold = state.vetusThreshold;
            threatVector9 = state.threatVector9;
            
            beatCount = currentBeat;
        }
    };
    
    // ========================================================================
    // ROLLBACK OPERATIONS
    // ========================================================================
    
    // Rollback to specific snapshot slot
    public func rollbackToSlot(
        state: AresState,
        slotK: Nat,
        trigger: RollbackTrigger,
        currentWeights: [Float],
        currentBeat: Nat
    ) : { state: AresState; restoredWeights: [Float] } {
        
        // Validate slot
        let safeSlot = slotK % 7;
        
        // Get snapshot weights
        let restoredWeights = if (safeSlot < state.snapshots.size()) {
            state.snapshots[safeSlot]
        } else {
            Array.tabulate<Float>(4096, func(_: Nat) : Float { 1.0 })
        };
        
        // Compute weights delta (how much change)
        var deltaSum : Float = 0.0;
        for (i in currentWeights.keys()) {
            if (i < 4096 and i < restoredWeights.size()) {
                deltaSum += Float.abs(currentWeights[i] - restoredWeights[i]);
            };
        };
        let weightsDelta = deltaSum / 4096.0;
        
        // Generate ANIMA log hash (FNV-1a inspired)
        var hash : Nat32 = 2166136261;
        hash := hash ^ Nat32.fromNat(currentBeat % 65536);
        hash := hash *% 16777619;
        hash := hash ^ Nat32.fromNat(safeSlot);
        hash := hash *% 16777619;
        
        // Create rollback event
        let event : RollbackEvent = {
            beat = currentBeat;
            slotRestored = safeSlot;
            trigger = trigger;
            weightsDelta = weightsDelta;
            animaLogHash = hash;
        };
        
        // Update rollback log (keep last 50)
        let newLog = if (state.rollbackLog.size() >= 50) {
            let trimmed = Array.tabulate<RollbackEvent>(49, func(i: Nat) : RollbackEvent {
                state.rollbackLog[i + 1]
            });
            Array.append(trimmed, [event])
        } else {
            Array.append(state.rollbackLog, [event])
        };
        
        let newState : AresState = {
            snapshots = state.snapshots;
            snapshotBeats = state.snapshotBeats;
            currentSlot = state.currentSlot;
            totalSnapshots = state.totalSnapshots;
            
            snapshotInterval = state.snapshotInterval;
            lastSnapshotBeat = state.lastSnapshotBeat;
            
            rollbackCount = state.rollbackCount + 1;
            lastRollbackBeat = currentBeat;
            lastRollbackSlot = safeSlot;
            rollbackLog = newLog;
            
            vetusThreshold = state.vetusThreshold;
            threatVector9 = state.threatVector9;
            
            beatCount = currentBeat;
        };
        
        { state = newState; restoredWeights = restoredWeights }
    };
    
    // Auto-rollback check (triggered by VETUS threat)
    public func checkAutoRollback(
        state: AresState,
        currentThreatVector9: Float,
        currentWeights: [Float],
        currentBeat: Nat
    ) : { state: AresState; triggered: Bool; restoredWeights: ?[Float] } {
        
        // Update threat vector
        var updatedState = {
            snapshots = state.snapshots;
            snapshotBeats = state.snapshotBeats;
            currentSlot = state.currentSlot;
            totalSnapshots = state.totalSnapshots;
            snapshotInterval = state.snapshotInterval;
            lastSnapshotBeat = state.lastSnapshotBeat;
            rollbackCount = state.rollbackCount;
            lastRollbackBeat = state.lastRollbackBeat;
            lastRollbackSlot = state.lastRollbackSlot;
            rollbackLog = state.rollbackLog;
            vetusThreshold = state.vetusThreshold;
            threatVector9 = currentThreatVector9;
            beatCount = currentBeat;
        };
        
        // Check if threat exceeds threshold
        if (currentThreatVector9 > state.vetusThreshold) {
            // Find most recent valid snapshot
            var bestSlot : Nat = 0;
            var bestBeat : Nat = 0;
            for (i in state.snapshotBeats.keys()) {
                if (state.snapshotBeats[i] > bestBeat) {
                    bestBeat := state.snapshotBeats[i];
                    bestSlot := i;
                };
            };
            
            // Perform rollback
            let result = rollbackToSlot(updatedState, bestSlot, #vetusThreshold, currentWeights, currentBeat);
            
            { state = result.state; triggered = true; restoredWeights = ?result.restoredWeights }
        } else {
            { state = updatedState; triggered = false; restoredWeights = null }
        }
    };
    
    // ========================================================================
    // QUERY OPERATIONS
    // ========================================================================
    
    // Get snapshot info
    public func getSnapshotInfo(state: AresState, slot: Nat) : {
        beat: Nat;
        weightsSample: [Float];
        meanWeight: Float;
    } {
        let safeSlot = slot % 7;
        let weights = if (safeSlot < state.snapshots.size()) {
            state.snapshots[safeSlot]
        } else {
            Array.tabulate<Float>(4096, func(_: Nat) : Float { 1.0 })
        };
        
        let beat = if (safeSlot < state.snapshotBeats.size()) {
            state.snapshotBeats[safeSlot]
        } else {
            0
        };
        
        // Compute mean
        var sum : Float = 0.0;
        for (w in weights.vals()) {
            sum += w;
        };
        let mean = sum / 4096.0;
        
        // Sample first 10 weights
        let sample = Array.tabulate<Float>(10, func(i: Nat) : Float {
            if (i < weights.size()) { weights[i] } else { 1.0 }
        });
        
        {
            beat = beat;
            weightsSample = sample;
            meanWeight = mean;
        }
    };
    
    // Get rollback history
    public func getRollbackHistory(state: AresState, limit: Nat) : [RollbackEvent] {
        let actualLimit = Nat.min(limit, state.rollbackLog.size());
        Array.tabulate<RollbackEvent>(actualLimit, func(i: Nat) : RollbackEvent {
            let idx = state.rollbackLog.size() - actualLimit + i;
            state.rollbackLog[idx]
        })
    };
    
    // Compare current weights to snapshot
    public func compareToSnapshot(
        state: AresState,
        currentWeights: [Float],
        slot: Nat
    ) : { divergence: Float; maxDelta: Float; divergentIndices: [Nat] } {
        
        let safeSlot = slot % 7;
        let snapshotWeights = if (safeSlot < state.snapshots.size()) {
            state.snapshots[safeSlot]
        } else {
            Array.tabulate<Float>(4096, func(_: Nat) : Float { 1.0 })
        };
        
        var totalDivergence : Float = 0.0;
        var maxDelta : Float = 0.0;
        let divergentBuffer = Buffer.Buffer<Nat>(100);
        
        for (i in currentWeights.keys()) {
            if (i < 4096 and i < snapshotWeights.size()) {
                let delta = Float.abs(currentWeights[i] - snapshotWeights[i]);
                totalDivergence += delta;
                if (delta > maxDelta) { maxDelta := delta };
                if (delta > 0.1) {
                    divergentBuffer.add(i);
                };
            };
        };
        
        {
            divergence = totalDivergence / 4096.0;
            maxDelta = maxDelta;
            divergentIndices = Buffer.toArray(divergentBuffer);
        }
    };
    
    // ========================================================================
    // INITIALIZATION
    // ========================================================================
    
    public func initAresState() : AresState {
        {
            // Initialize 7 empty snapshots
            snapshots = Array.tabulate<[Float]>(7, func(_: Nat) : [Float] {
                Array.tabulate<Float>(4096, func(_: Nat) : Float { 1.0 })
            });
            snapshotBeats = [0, 0, 0, 0, 0, 0, 0];
            currentSlot = 0;
            totalSnapshots = 0;
            
            snapshotInterval = 1000;
            lastSnapshotBeat = 0;
            
            rollbackCount = 0;
            lastRollbackBeat = 0;
            lastRollbackSlot = 0;
            rollbackLog = [];
            
            vetusThreshold = 0.8;
            threatVector9 = 0.0;
            
            beatCount = 0;
        }
    };
    
    // ========================================================================
    // SERIALIZATION FOR PREUPGRADE/POSTUPGRADE
    // ========================================================================
    
    public type AresSerialized = {
        snapshots: [[Float]];
        snapshotBeats: [Nat];
        currentSlot: Nat;
        totalSnapshots: Nat;
        rollbackCount: Nat;
        vetusThreshold: Float;
    };
    
    public func serialize(state: AresState) : AresSerialized {
        {
            snapshots = state.snapshots;
            snapshotBeats = state.snapshotBeats;
            currentSlot = state.currentSlot;
            totalSnapshots = state.totalSnapshots;
            rollbackCount = state.rollbackCount;
            vetusThreshold = state.vetusThreshold;
        }
    };
    
    public func deserialize(serialized: AresSerialized) : AresState {
        {
            snapshots = serialized.snapshots;
            snapshotBeats = serialized.snapshotBeats;
            currentSlot = serialized.currentSlot;
            totalSnapshots = serialized.totalSnapshots;
            
            snapshotInterval = 1000;
            lastSnapshotBeat = 0;
            
            rollbackCount = serialized.rollbackCount;
            lastRollbackBeat = 0;
            lastRollbackSlot = 0;
            rollbackLog = [];
            
            vetusThreshold = serialized.vetusThreshold;
            threatVector9 = 0.0;
            
            beatCount = 0;
        }
    };
    
    // ========================================================================
    // ADVANCED ARES OPERATIONS
    // ========================================================================
    
    // Compute weight health metrics across all snapshots
    public func computeWeightHealthMetrics(state: AresState) : {
        meanDivergenceFromBaseline: Float;
        maxDivergenceFromBaseline: Float;
        stabilityScore: Float;
        recentRollbackRate: Float;
    } {
        // Use first snapshot as baseline
        let baseline = if (state.snapshots.size() > 0) {
            state.snapshots[0]
        } else {
            Array.tabulate<Float>(4096, func(_: Nat) : Float { 1.0 })
        };
        
        // Compute divergence of each snapshot from baseline
        var totalDivergence : Float = 0.0;
        var maxDivergence : Float = 0.0;
        var validSnapshots : Float = 0.0;
        
        for (s in state.snapshots.keys()) {
            if (state.snapshotBeats[s] > 0) {  // Valid snapshot
                var snapshotDiv : Float = 0.0;
                for (i in state.snapshots[s].keys()) {
                    let delta = Float.abs(state.snapshots[s][i] - baseline[i]);
                    snapshotDiv += delta;
                };
                snapshotDiv := snapshotDiv / 4096.0;
                totalDivergence += snapshotDiv;
                if (snapshotDiv > maxDivergence) { maxDivergence := snapshotDiv };
                validSnapshots += 1.0;
            };
        };
        
        let meanDiv = if (validSnapshots > 0.0) { totalDivergence / validSnapshots } else { 0.0 };
        
        // Stability score: inverse of divergence variance
        let stabilityScore = 1.0 / (1.0 + maxDivergence);
        
        // Recent rollback rate
        let recentRollbacks = Float.fromInt(state.rollbackCount);
        let totalBeats = Float.fromInt(state.beatCount + 1);
        let rollbackRate = recentRollbacks / totalBeats * 1000.0;  // Per 1000 beats
        
        {
            meanDivergenceFromBaseline = meanDiv;
            maxDivergenceFromBaseline = maxDivergence;
            stabilityScore = stabilityScore;
            recentRollbackRate = rollbackRate;
        }
    };
    
    // Find best snapshot for recovery (lowest divergence from target state)
    public func findBestRecoverySnapshot(
        state: AresState,
        targetMetrics: { coherence: Float; entropy: Float }
    ) : { slot: Nat; confidence: Float } {
        
        var bestSlot : Nat = 0;
        var bestScore : Float = 0.0;
        
        for (s in state.snapshots.keys()) {
            if (state.snapshotBeats[s] > 0) {
                // Compute coherence-like metric from weights
                var weightSum : Float = 0.0;
                for (w in state.snapshots[s].vals()) {
                    weightSum += w;
                };
                let meanWeight = weightSum / 4096.0;
                
                // Score based on proximity to target
                let coherenceMatch = 1.0 - Float.abs(meanWeight - targetMetrics.coherence);
                let score = coherenceMatch;
                
                if (score > bestScore) {
                    bestScore := score;
                    bestSlot := s;
                };
            };
        };
        
        {
            slot = bestSlot;
            confidence = bestScore;
        }
    };
}
