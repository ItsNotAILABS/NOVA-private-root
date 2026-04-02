// ============================================================================
// BEE NEURON MODEL + 60-STEP PREDICTIVE FIELD
// ============================================================================
// PHASE H: Bee neuron model wired into Shell 3, 60-step Kalman prediction
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Rule: 100% of all value routes to creator reserve
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";

module BeeNeuronPredictiveField {
    
    // ========================================================================
    // BEE NEURON MODEL — Sparse Activation, 20Hz Anchor, Waggle Compression
    // ========================================================================
    // Based on honeybee mushroom body neural architecture:
    // - Sparse coding: only top 5% of nodes activate
    // - 20Hz oscillation: all nodes phase-locked to central oscillator
    // - Waggle dance compression: 8-bit directional output every 20 beats
    // ========================================================================
    
    public type BeeNeuronState = {
        // Sparse activation state
        sparseActivations: [Float];    // Post-GABA suppression activations
        activeNodeMask: [Bool];        // Which nodes are in top 5%
        activeNodeCount: Nat;          // Number of active nodes
        sparseThreshold: Float;        // Current 95th percentile threshold
        
        // 20Hz oscillation anchor
        oscillatorPhase: Float;        // Central oscillator phase [0, 2π]
        oscillatorFrequency: Float;    // 20 Hz base frequency
        nodePhases: [Float];           // Phase offset per node
        phaseCoherence: Float;         // How synchronized nodes are
        
        // Waggle compression
        waggleVector: [Nat8];          // 8-bit directional encoding
        waggleAngle: Float;            // Direction in radians
        waggleMagnitude: Float;        // Distance/intensity encoding
        waggleBeatCounter: Nat;        // Beats since last waggle
        
        // GABA suppression state
        gabaLevel: Float;              // Global inhibitory tone
        gabaAdaptation: Float;         // Adaptation rate
        
        // Beat tracking
        beatCount: Nat;
        lastWaggleBeat: Nat;
    };
    
    // ========================================================================
    // SPARSE ACTIVATION GATE — Top 5% Only
    // ========================================================================
    
    public func applySparseActivation(
        shell3Nodes: [Float],
        gabaLevel: Float
    ) : { sparseActivations: [Float]; activeMask: [Bool]; threshold: Float } {
        
        // Find 95th percentile threshold
        let sorted = Array.sort<Float>(shell3Nodes, Float.compare);
        let percentileIdx = (shell3Nodes.size() * 95) / 100;
        let threshold = if (percentileIdx < sorted.size()) { 
            sorted[percentileIdx] 
        } else { 
            1.0 
        };
        
        // Apply sparse gate: only nodes above threshold activate
        let sparseActivations = Array.tabulate<Float>(shell3Nodes.size(), func(i: Nat) : Float {
            let nodeValue = shell3Nodes[i];
            if (nodeValue >= threshold) {
                // Active: full activation minus GABA inhibition
                Float.max(0.1, nodeValue - gabaLevel * 0.2)
            } else {
                // Suppressed: minimal baseline activity
                0.1
            }
        });
        
        // Create activation mask
        let activeMask = Array.tabulate<Bool>(shell3Nodes.size(), func(i: Nat) : Bool {
            shell3Nodes[i] >= threshold
        });
        
        {
            sparseActivations = sparseActivations;
            activeMask = activeMask;
            threshold = threshold;
        }
    };
    
    // ========================================================================
    // 20Hz OSCILLATION ANCHOR — Phase Synchronization
    // ========================================================================
    
    public func updateOscillator(
        currentPhase: Float,
        frequency: Float,
        nodePhases: [Float],
        shell3Activations: [Float]
    ) : { newPhase: Float; updatedNodePhases: [Float]; coherence: Float } {
        
        // Advance central oscillator phase
        // 20 Hz = 20 cycles per second, assume ~10 beats per second
        // Phase increment = 2π × frequency / beats_per_second
        let phaseIncrement = 2.0 * 3.14159265 * frequency / 10.0;
        var newPhase = currentPhase + phaseIncrement;
        if (newPhase > 2.0 * 3.14159265) {
            newPhase -= 2.0 * 3.14159265;
        };
        
        // Update node phases to track central oscillator
        // Kuramoto coupling: dθ_i/dt = ω_i + K/N × Σ sin(θ_j - θ_i)
        let couplingStrength = 0.1;
        let updatedNodePhases = Array.tabulate<Float>(nodePhases.size(), func(i: Nat) : Float {
            let nodePhase = if (i < nodePhases.size()) { nodePhases[i] } else { 0.0 };
            let activation = if (i < shell3Activations.size()) { shell3Activations[i] } else { 1.0 };
            
            // Phase coupling toward central oscillator
            let phaseDiff = newPhase - nodePhase;
            let coupling = couplingStrength * Float.sin(phaseDiff) * activation;
            
            var updatedPhase = nodePhase + phaseIncrement + coupling;
            if (updatedPhase > 2.0 * 3.14159265) {
                updatedPhase -= 2.0 * 3.14159265;
            };
            if (updatedPhase < 0.0) {
                updatedPhase += 2.0 * 3.14159265;
            };
            updatedPhase
        });
        
        // Compute phase coherence: Kuramoto order parameter R
        // R = |1/N × Σ exp(i×θ_j)| = sqrt((Σcos(θ))² + (Σsin(θ))²) / N
        var cosSum : Float = 0.0;
        var sinSum : Float = 0.0;
        for (phase in updatedNodePhases.vals()) {
            cosSum += Float.cos(phase);
            sinSum += Float.sin(phase);
        };
        let n = Float.fromInt(updatedNodePhases.size());
        let coherence = Float.sqrt(cosSum * cosSum + sinSum * sinSum) / n;
        
        {
            newPhase = newPhase;
            updatedNodePhases = updatedNodePhases;
            coherence = coherence;
        }
    };
    
    // ========================================================================
    // WAGGLE COMPRESSION — 8-bit Directional Vector Every 20 Beats
    // ========================================================================
    
    public func computeWaggleCompression(
        shell3Activations: [Float],
        beatsSinceLastWaggle: Nat
    ) : { vector: [Nat8]; angle: Float; magnitude: Float; shouldOutput: Bool } {
        
        // Only output every 20 beats
        let shouldOutput = beatsSinceLastWaggle >= 20;
        
        if (not shouldOutput) {
            return {
                vector = [0, 0, 0, 0, 0, 0, 0, 0];
                angle = 0.0;
                magnitude = 0.0;
                shouldOutput = false;
            };
        };
        
        // Compute center of mass of activations
        var xSum : Float = 0.0;
        var ySum : Float = 0.0;
        var totalWeight : Float = 0.0;
        
        for (i in shell3Activations.keys()) {
            let activation = shell3Activations[i];
            // Map node index to 2D position (8×8 grid for 64 nodes)
            let x = Float.fromInt(i % 8);
            let y = Float.fromInt(i / 8);
            
            xSum += x * activation;
            ySum += y * activation;
            totalWeight += activation;
        };
        
        // Center of mass
        let comX = if (totalWeight > 0.0) { xSum / totalWeight } else { 4.0 };
        let comY = if (totalWeight > 0.0) { ySum / totalWeight } else { 4.0 };
        
        // Direction from center (4,4) to center of mass
        let dx = comX - 4.0;
        let dy = comY - 4.0;
        
        // Angle and magnitude
        let angle = Float.arctan2(dy, dx);
        let magnitude = Float.sqrt(dx * dx + dy * dy);
        
        // Compress to 8-bit vector
        // Bits 0-2: angle (8 directions)
        // Bits 3-5: magnitude (8 levels)
        // Bits 6-7: confidence (4 levels)
        let angleQuant = Int.abs(Float.toInt((angle + 3.14159265) / (2.0 * 3.14159265) * 8.0)) % 8;
        let magQuant = Int.abs(Float.toInt(Float.min(1.0, magnitude / 4.0) * 8.0)) % 8;
        let confQuant = Int.abs(Float.toInt(Float.min(1.0, totalWeight / 64.0) * 4.0)) % 4;
        
        let vector : [Nat8] = [
            Nat8.fromNat(angleQuant),
            Nat8.fromNat(magQuant),
            Nat8.fromNat(confQuant),
            0, 0, 0, 0, 0  // Reserved
        ];
        
        {
            vector = vector;
            angle = angle;
            magnitude = magnitude;
            shouldOutput = true;
        }
    };
    
    // ========================================================================
    // 60-STEP PREDICTIVE FIELD — Kalman Filter Projection
    // ========================================================================
    // stPredField: [var 3840]Float (60 steps × 64 nodes)
    // Kalman filter propagates state 60 steps forward
    // Prediction error feeds CHRONO Fisher information
    // ========================================================================
    
    public type PredictiveFieldState = {
        // 60 × 64 = 3840 prediction values
        predictions: [Float];          // Future state predictions
        
        // Kalman filter state
        stateEstimate: [Float];        // Current state estimate (64 nodes)
        errorCovariance: [Float];      // Estimation error covariance
        transitionMatrix: [Float];     // State transition A (simplified: 64 values)
        processNoise: Float;           // Q: process noise
        measurementNoise: Float;       // R: measurement noise
        
        // Prediction metrics
        predictionError: Float;        // Norm of actual - predicted
        consecutiveLowError: Nat;      // Consecutive beats with low error
        errorThreshold: Float;         // Threshold for "low" error
        
        // KNT minting
        kntMintTrigger: Bool;          // 10 consecutive low error → mint
        
        // VETUS threat detection
        vetusIncrementTrigger: Bool;   // Error spike → threat vector 7
        
        // Beat tracking
        beatCount: Nat;
        lastPredictionBeat: Nat;
    };
    
    // ========================================================================
    // KALMAN FILTER UPDATE
    // ========================================================================
    
    public func kalmanUpdate(
        state: PredictiveFieldState,
        actualObservation: [Float]
    ) : { newEstimate: [Float]; newCovariance: [Float]; innovationError: Float } {
        
        // Predict step: x_pred = A × x_est
        let predicted = Array.tabulate<Float>(64, func(i: Nat) : Float {
            let estimate = if (i < state.stateEstimate.size()) { state.stateEstimate[i] } else { 1.0 };
            let transition = if (i < state.transitionMatrix.size()) { state.transitionMatrix[i] } else { 1.0 };
            estimate * transition
        });
        
        // Predicted covariance: P_pred = A × P × A' + Q
        let predictedCov = Array.tabulate<Float>(64, func(i: Nat) : Float {
            let cov = if (i < state.errorCovariance.size()) { state.errorCovariance[i] } else { 0.1 };
            let transition = if (i < state.transitionMatrix.size()) { state.transitionMatrix[i] } else { 1.0 };
            transition * cov * transition + state.processNoise
        });
        
        // Innovation: y = z - H × x_pred (H = I for direct observation)
        var innovationError : Float = 0.0;
        let innovation = Array.tabulate<Float>(64, func(i: Nat) : Float {
            let actual = if (i < actualObservation.size()) { actualObservation[i] } else { 1.0 };
            let pred = predicted[i];
            let diff = actual - pred;
            innovationError += diff * diff;
            diff
        });
        innovationError := Float.sqrt(innovationError / 64.0);
        
        // Kalman gain: K = P_pred / (P_pred + R)
        let kalmanGain = Array.tabulate<Float>(64, func(i: Nat) : Float {
            let pPred = predictedCov[i];
            pPred / (pPred + state.measurementNoise)
        });
        
        // Update estimate: x_est = x_pred + K × innovation
        let newEstimate = Array.tabulate<Float>(64, func(i: Nat) : Float {
            predicted[i] + kalmanGain[i] * innovation[i]
        });
        
        // Update covariance: P = (I - K) × P_pred
        let newCovariance = Array.tabulate<Float>(64, func(i: Nat) : Float {
            (1.0 - kalmanGain[i]) * predictedCov[i]
        });
        
        {
            newEstimate = newEstimate;
            newCovariance = newCovariance;
            innovationError = innovationError;
        }
    };
    
    // ========================================================================
    // 60-STEP FORWARD PROJECTION
    // ========================================================================
    
    public func projectForward60(
        currentState: [Float],
        transitionMatrix: [Float]
    ) : [Float] {
        
        // Project state 60 steps forward using transition matrix
        // predictions[step * 64 + node] = predicted value
        var state = currentState;
        
        let predictions = Array.init<Float>(3840, 1.0);
        
        for (step in Array.keys(Array.tabulate<Nat>(60, func(i: Nat) : Nat { i }))) {
            // Apply transition: state_next = A × state_current
            let nextState = Array.tabulate<Float>(64, func(i: Nat) : Float {
                let current = if (i < state.size()) { state[i] } else { 1.0 };
                let transition = if (i < transitionMatrix.size()) { transitionMatrix[i] } else { 1.0 };
                // Add some decay to prevent explosion
                current * transition * 0.995
            });
            
            // Store in predictions array
            for (node in nextState.keys()) {
                let idx = step * 64 + node;
                if (idx < 3840) {
                    predictions[idx] := nextState[node];
                };
            };
            
            state := Array.freeze(Array.thaw<Float>(nextState));
        };
        
        Array.freeze(predictions)
    };
    
    // ========================================================================
    // BUILD TRANSITION MATRIX FROM HEBBIAN CORRELATIONS
    // ========================================================================
    
    public func buildTransitionMatrix(
        hebbianWeights: [Float],    // Last 1000-beat weight correlations
        defaultTransition: Float
    ) : [Float] {
        // Simplified: diagonal matrix with Hebbian-derived values
        // Full version would use SVD or similar decomposition
        
        if (hebbianWeights.size() < 64) {
            return Array.tabulate<Float>(64, func(_: Nat) : Float { defaultTransition });
        };
        
        // Extract diagonal elements (self-connections) from weight matrix
        Array.tabulate<Float>(64, func(i: Nat) : Float {
            let idx = i * 64 + i;  // Diagonal element
            if (idx < hebbianWeights.size()) {
                // Normalize to reasonable transition value
                let weight = hebbianWeights[idx];
                Float.max(0.9, Float.min(1.1, weight))
            } else {
                defaultTransition
            }
        })
    };
    
    // ========================================================================
    // FULL BEE NEURON + PREDICTIVE TICK
    // ========================================================================
    
    public func tickBeeNeuronPredictive(
        beeState: BeeNeuronState,
        predState: PredictiveFieldState,
        shell3Input: [Float],
        hebbianWeights: [Float]
    ) : { beeState: BeeNeuronState; predState: PredictiveFieldState } {
        
        // 1. Apply sparse activation
        let sparse = applySparseActivation(shell3Input, beeState.gabaLevel);
        
        // 2. Update oscillator
        let osc = updateOscillator(
            beeState.oscillatorPhase,
            beeState.oscillatorFrequency,
            beeState.nodePhases,
            sparse.sparseActivations
        );
        
        // 3. Compute waggle compression
        let waggle = computeWaggleCompression(
            sparse.sparseActivations,
            beeState.waggleBeatCounter
        );
        
        // 4. Update GABA level (homeostatic adaptation)
        var activeCount : Nat = 0;
        for (active in sparse.activeMask.vals()) {
            if (active) { activeCount += 1 };
        };
        let targetActiveRate = 0.05;  // 5%
        let actualActiveRate = Float.fromInt(activeCount) / Float.fromInt(sparse.activeMask.size());
        let gabaAdjustment = (actualActiveRate - targetActiveRate) * beeState.gabaAdaptation;
        let newGaba = Float.max(0.0, Float.min(1.0, beeState.gabaLevel + gabaAdjustment));
        
        // 5. Kalman update
        let kalman = kalmanUpdate(predState, shell3Input);
        
        // 6. Build/update transition matrix
        let transitionMatrix = buildTransitionMatrix(hebbianWeights, 1.0);
        
        // 7. Project forward 60 steps
        let predictions = projectForward60(kalman.newEstimate, transitionMatrix);
        
        // 8. Check for KNT mint (10 consecutive low error)
        var newConsecutiveLow = predState.consecutiveLowError;
        var kntTrigger = false;
        if (kalman.innovationError < predState.errorThreshold) {
            newConsecutiveLow += 1;
            if (newConsecutiveLow >= 10) {
                kntTrigger := true;
                newConsecutiveLow := 0;  // Reset counter
            };
        } else {
            newConsecutiveLow := 0;
        };
        
        // 9. Check for VETUS threat (error spike)
        let vetusIncrement = kalman.innovationError > predState.errorThreshold * 3.0;
        
        // Update states
        let newBeeState : BeeNeuronState = {
            sparseActivations = sparse.sparseActivations;
            activeNodeMask = sparse.activeMask;
            activeNodeCount = activeCount;
            sparseThreshold = sparse.threshold;
            
            oscillatorPhase = osc.newPhase;
            oscillatorFrequency = beeState.oscillatorFrequency;
            nodePhases = osc.updatedNodePhases;
            phaseCoherence = osc.coherence;
            
            waggleVector = if (waggle.shouldOutput) { waggle.vector } else { beeState.waggleVector };
            waggleAngle = if (waggle.shouldOutput) { waggle.angle } else { beeState.waggleAngle };
            waggleMagnitude = if (waggle.shouldOutput) { waggle.magnitude } else { beeState.waggleMagnitude };
            waggleBeatCounter = if (waggle.shouldOutput) { 0 } else { beeState.waggleBeatCounter + 1 };
            
            gabaLevel = newGaba;
            gabaAdaptation = beeState.gabaAdaptation;
            
            beatCount = beeState.beatCount + 1;
            lastWaggleBeat = if (waggle.shouldOutput) { beeState.beatCount + 1 } else { beeState.lastWaggleBeat };
        };
        
        let newPredState : PredictiveFieldState = {
            predictions = predictions;
            
            stateEstimate = kalman.newEstimate;
            errorCovariance = kalman.newCovariance;
            transitionMatrix = transitionMatrix;
            processNoise = predState.processNoise;
            measurementNoise = predState.measurementNoise;
            
            predictionError = kalman.innovationError;
            consecutiveLowError = newConsecutiveLow;
            errorThreshold = predState.errorThreshold;
            
            kntMintTrigger = kntTrigger;
            vetusIncrementTrigger = vetusIncrement;
            
            beatCount = predState.beatCount + 1;
            lastPredictionBeat = predState.beatCount + 1;
        };
        
        { beeState = newBeeState; predState = newPredState }
    };
    
    // ========================================================================
    // INITIALIZATION
    // ========================================================================
    
    public func initBeeNeuronState() : BeeNeuronState {
        {
            sparseActivations = Array.tabulate<Float>(64, func(_: Nat) : Float { 1.0 });
            activeNodeMask = Array.tabulate<Bool>(64, func(_: Nat) : Bool { false });
            activeNodeCount = 0;
            sparseThreshold = 1.0;
            
            oscillatorPhase = 0.0;
            oscillatorFrequency = 20.0;  // 20 Hz
            nodePhases = Array.tabulate<Float>(64, func(_: Nat) : Float { 0.0 });
            phaseCoherence = 1.0;
            
            waggleVector = [0, 0, 0, 0, 0, 0, 0, 0];
            waggleAngle = 0.0;
            waggleMagnitude = 0.0;
            waggleBeatCounter = 0;
            
            gabaLevel = 0.5;
            gabaAdaptation = 0.01;
            
            beatCount = 0;
            lastWaggleBeat = 0;
        }
    };
    
    public func initPredictiveFieldState() : PredictiveFieldState {
        {
            predictions = Array.tabulate<Float>(3840, func(_: Nat) : Float { 1.0 });
            
            stateEstimate = Array.tabulate<Float>(64, func(_: Nat) : Float { 1.0 });
            errorCovariance = Array.tabulate<Float>(64, func(_: Nat) : Float { 0.1 });
            transitionMatrix = Array.tabulate<Float>(64, func(_: Nat) : Float { 1.0 });
            processNoise = 0.01;
            measurementNoise = 0.1;
            
            predictionError = 0.0;
            consecutiveLowError = 0;
            errorThreshold = 0.1;
            
            kntMintTrigger = false;
            vetusIncrementTrigger = false;
            
            beatCount = 0;
            lastPredictionBeat = 0;
        }
    };
    
    // ========================================================================
    // QUERY FUNCTIONS
    // ========================================================================
    
    // Get prediction for specific step and node
    public func getPrediction(state: PredictiveFieldState, step: Nat, node: Nat) : Float {
        if (step < 60 and node < 64) {
            let idx = step * 64 + node;
            if (idx < state.predictions.size()) {
                state.predictions[idx]
            } else {
                1.0
            }
        } else {
            1.0
        }
    };
    
    // Get all predictions for specific step
    public func getStepPredictions(state: PredictiveFieldState, step: Nat) : [Float] {
        if (step < 60) {
            Array.tabulate<Float>(64, func(node: Nat) : Float {
                getPrediction(state, step, node)
            })
        } else {
            Array.tabulate<Float>(64, func(_: Nat) : Float { 1.0 })
        }
    };
    
    // Compute prediction confidence for specific step
    public func getStepConfidence(state: PredictiveFieldState, step: Nat) : Float {
        // Confidence decays with prediction horizon
        let baseConfidence = 1.0 - state.predictionError;
        let horizonDecay = Float.pow(0.98, Float.fromInt(step));
        Float.max(0.0, baseConfidence * horizonDecay)
    };
    
    // Get sparse activation rate
    public func getSparseActivationRate(state: BeeNeuronState) : Float {
        Float.fromInt(state.activeNodeCount) / Float.fromInt(state.activeNodeMask.size())
    };
}
