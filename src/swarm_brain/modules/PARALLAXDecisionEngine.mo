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

// ============================================================================
// PARALLAX DECISION ENGINE — 5-PATH QUANTUM INTERFERENCE DECISION SYSTEM
// ============================================================================
// Implements multi-path quantum amplitude interference for decision-making.
// Each decision has 5 possible paths with complex amplitudes (I + iQ).
// The winner path is selected via amplitude-squared probability distribution.
//
// REAL QUANTUM MECHANICS:
// - Path amplitude: ψ_n = I_n + i*Q_n (complex number)
// - Probability: P_n = |ψ_n|² = I_n² + Q_n²
// - Interference: Total amplitude can constructively/destructively interfere
// - Decoherence: Environmental noise causes path decay
//
// NEUROCHEMICAL COUPLING:
// - Dopamine → Path 0 (reward-seeking)
// - Serotonin → Path 1 (stability/patience)
// - Norepinephrine → Path 2 (alertness/urgency)
// - Acetylcholine → Path 3 (learning/exploration)
// - GABA → Path 4 (inhibition/caution)
//
// DECISION DOMAINS:
// - Behavior selection (FORAGE, DEFEND, ENGAGE, RETREAT, etc.)
// - Council voting (LEXIS, PARALLAX-SWARM, VETUS, AEGIS, FORMA)
// - Economic routing (which revenue stream to prioritize)
// - Memory consolidation (which memories to strengthen)
// - Learning pathway (which connections to reinforce)
//
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Rule: 100% of all value routes to creator reserve
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";

module PARALLAXDecisionEngine {
    
    // Mathematical constants
    public let π : Float = 3.14159265358979323846;
    public let φ : Float = 1.618033988749895;  // Golden ratio
    public let e : Float = 2.718281828459045;  // Euler's number
    
    // ========================================================================
    // SECTION 1: CORE DATA STRUCTURES
    // ========================================================================
    
    // Individual decision path with quantum amplitude
    public type DecisionPath = {
        id: Nat;                      // Path index (0-4)
        name: Text;                   // Human-readable path name
        iComponent: Float;            // Real part of complex amplitude
        qComponent: Float;            // Imaginary part of complex amplitude
        amplitudeSquared: Float;      // |ψ|² = I² + Q²
        probability: Float;           // Normalized probability
        neurochemicalAffinity: Float; // How strongly neurochemicals bias this path
        decayRate: Float;             // Decoherence rate
        rewardHistory: Float;         // EMA of past rewards from choosing this path
        confidenceScore: Float;       // Meta-cognitive confidence in this path
    };
    
    // Complete decision state for a single decision
    public type DecisionState = {
        decisionId: Nat;              // Unique decision identifier
        domain: Text;                 // Decision domain (behavior, council, economic, etc.)
        paths: [DecisionPath];        // 5 possible paths
        winnerIndex: Nat;             // Index of selected path
        winnerProbability: Float;     // Probability of winner path
        interferenceScore: Float;     // How much paths interfered with each other
        coherenceLevel: Float;        // Overall quantum coherence of decision
        entropyScore: Float;          // Decision entropy (uncertainty)
        timestampBeat: Nat;           // Beat number when decision was made
        neurochemicalModulation: [Float]; // 21 neurochemical modulators
    };
    
    // Engine-wide state
    public type PARALLAXEngineState = {
        // Decision tracking
        var totalDecisions: Nat;
        var activeDecisions: [DecisionState];
        var decisionHistory: Buffer.Buffer<DecisionState>;
        
        // Path statistics (aggregate across all decisions)
        var pathSelectionCounts: [var Nat];     // How often each path was selected
        var pathRewardHistory: [var Float];     // Cumulative rewards per path
        var pathConfidenceEMA: [var Float];     // Confidence EMA per path
        
        // Neurochemical integration
        var neurochemicalWeights: [var Float];  // 21 neurochemical → 5 path weights
        var dopaminePathBias: Float;
        var serotoninPathBias: Float;
        var norepinephrinePathBias: Float;
        var acetylcholinePathBias: Float;
        var gabaPathBias: Float;
        
        // Quantum state
        var globalPhase: Float;                 // Master phase for all decisions
        var decoherenceRate: Float;             // Global decoherence rate
        var interferenceStrength: Float;        // How strongly paths interfere
        var quantumNoiseLevel: Float;           // Environmental quantum noise
        
        // Performance metrics
        var averageDecisionTime: Float;         // Beats to reach decision
        var averageConfidence: Float;           // Average confidence in decisions
        var decisionQuality: Float;             // Quality metric based on outcomes
        var regretAccumulator: Float;           // Accumulated regret for exploration
        
        // Integration with other systems
        var lastQuantumHeartbeatPhase: Float;
        var lastNeurochemicalSnapshot: [Float];
        var councilDecisionPending: Bool;
        var economicDecisionPending: Bool;
        var behaviorDecisionPending: Bool;
    };
    
    // ========================================================================
    // SECTION 2: INITIALIZATION
    // ========================================================================
    
    public func initializeEngine() : PARALLAXEngineState {
        {
            var totalDecisions = 0;
            var activeDecisions = [];
            var decisionHistory = Buffer.Buffer<DecisionState>(100);
            
            var pathSelectionCounts = Array.init<Nat>(5, 0);
            var pathRewardHistory = Array.init<Float>(5, 0.5);
            var pathConfidenceEMA = Array.init<Float>(5, 0.5);
            
            var neurochemicalWeights = Array.init<Float>(21 * 5, 0.0);
            var dopaminePathBias = 1.0;
            var serotoninPathBias = 1.0;
            var norepinephrinePathBias = 1.0;
            var acetylcholinePathBias = 1.0;
            var gabaPathBias = 1.0;
            
            var globalPhase = 0.0;
            var decoherenceRate = 0.05;
            var interferenceStrength = 0.3;
            var quantumNoiseLevel = 0.1;
            
            var averageDecisionTime = 1.0;
            var averageConfidence = 0.5;
            var decisionQuality = 0.5;
            var regretAccumulator = 0.0;
            
            var lastQuantumHeartbeatPhase = 0.0;
            var lastNeurochemicalSnapshot = Array.freeze(Array.init<Float>(21, 0.5));
            var councilDecisionPending = false;
            var economicDecisionPending = false;
            var behaviorDecisionPending = false;
        }
    };
    
    // Initialize default path templates
    public func initializeDecisionPaths(domain: Text) : [DecisionPath] {
        let pathNames = switch (domain) {
            case "behavior" { ["FORAGE", "DEFEND", "ENGAGE", "RETREAT", "RELAY"] };
            case "council" { ["LEXIS", "PARALLAX-SWARM", "VETUS", "AEGIS", "FORMA"] };
            case "economic" { ["SOVEREIGN", "COMPOUND", "HARVEST", "RESERVE", "DISTRIBUTE"] };
            case "memory" { ["CONSOLIDATE", "FORGET", "STRENGTHEN", "WEAKEN", "TRANSFER"] };
            case "learning" { ["HEBBIAN", "STDP", "REWARD", "EXPLORATION", "EXPLOITATION"] };
            case _ { ["PATH0", "PATH1", "PATH2", "PATH3", "PATH4"] };
        };
        
        Array.tabulate<DecisionPath>(5, func(i: Nat) : DecisionPath {
            {
                id = i;
                name = pathNames[i];
                iComponent = 0.5;
                qComponent = 0.0;
                amplitudeSquared = 0.25;
                probability = 0.2;
                neurochemicalAffinity = 1.0;
                decayRate = 0.01;
                rewardHistory = 0.5;
                confidenceScore = 0.5;
            }
        })
    };
    
    // ========================================================================
    // SECTION 3: CORE QUANTUM MECHANICS — AMPLITUDE COMPUTATION
    // ========================================================================
    
    // Compute complex amplitude evolution for all 5 paths
    public func evolvePathAmplitudes(
        paths: [DecisionPath],
        neurochemicals: [Float],  // 21 neurochemical concentrations
        globalPhase: Float,
        dt: Float
    ) : [DecisionPath] {
        
        // Neurochemical → Path affinity mapping
        // Path 0 (reward): Dopamine-driven
        // Path 1 (stability): Serotonin-driven
        // Path 2 (urgency): Norepinephrine + Adrenaline
        // Path 3 (learning): Acetylcholine + BDNF
        // Path 4 (inhibition): GABA + Adenosine
        
        let dopamine = if (neurochemicals.size() > 0) { neurochemicals[0] } else { 0.5 };
        let serotonin = if (neurochemicals.size() > 1) { neurochemicals[1] } else { 0.5 };
        let norepinephrine = if (neurochemicals.size() > 2) { neurochemicals[2] } else { 0.5 };
        let acetylcholine = if (neurochemicals.size() > 3) { neurochemicals[3] } else { 0.5 };
        let gaba = if (neurochemicals.size() > 4) { neurochemicals[4] } else { 0.5 };
        let adrenaline = if (neurochemicals.size() > 9) { neurochemicals[9] } else { 0.5 };
        let bdnf = if (neurochemicals.size() > 19) { neurochemicals[19] } else { 0.5 };
        let adenosine = if (neurochemicals.size() > 13) { neurochemicals[13] } else { 0.5 };
        
        // Compute affinity factors for each path
        let affinities = [
            dopamine * 1.5,                          // Path 0: Reward
            serotonin * 1.3,                         // Path 1: Stability
            (norepinephrine + adrenaline) * 0.75,    // Path 2: Urgency
            (acetylcholine + bdnf) * 0.65,           // Path 3: Learning
            (gaba + adenosine) * 0.65                // Path 4: Inhibition
        ];
        
        Array.tabulate<DecisionPath>(5, func(i: Nat) : DecisionPath {
            let path = paths[i];
            let affinity = affinities[i];
            
            // Schrödinger-like amplitude evolution
            // dψ/dt = -i*H*ψ - γ*ψ + noise
            // Here we evolve I and Q components separately
            
            // Phase rotation based on path energy (affinity)
            let omega = π * affinity;  // Angular frequency proportional to affinity
            let cos_θ = Float.cos(omega * dt);
            let sin_θ = Float.sin(omega * dt);
            
            // Rotate amplitude
            let newI = path.iComponent * cos_θ - path.qComponent * sin_θ;
            let newQ = path.iComponent * sin_θ + path.qComponent * cos_θ;
            
            // Apply decay (decoherence)
            let decayFactor = Float.exp(-path.decayRate * dt);
            let decayedI = newI * decayFactor;
            let decayedQ = newQ * decayFactor;
            
            // Add neurochemical bias
            let biasedI = decayedI + affinity * 0.1 * dt;
            
            // Compute amplitude squared
            let ampSq = biasedI * biasedI + decayedQ * decayedQ;
            
            {
                id = path.id;
                name = path.name;
                iComponent = biasedI;
                qComponent = decayedQ;
                amplitudeSquared = ampSq;
                probability = path.probability;  // Will be normalized later
                neurochemicalAffinity = affinity;
                decayRate = path.decayRate;
                rewardHistory = path.rewardHistory;
                confidenceScore = path.confidenceScore;
            }
        })
    };
    
    // Normalize probabilities from amplitude squared
    public func normalizeProbabilities(paths: [DecisionPath]) : [DecisionPath] {
        // Compute total amplitude squared
        var totalAmpSq : Float = 0.0;
        for (path in paths.vals()) {
            totalAmpSq += path.amplitudeSquared;
        };
        
        // Avoid division by zero
        if (totalAmpSq < 0.0001) {
            totalAmpSq := 1.0;
        };
        
        // Normalize each path's probability
        Array.tabulate<DecisionPath>(5, func(i: Nat) : DecisionPath {
            let path = paths[i];
            let normalizedProb = path.amplitudeSquared / totalAmpSq;
            
            {
                id = path.id;
                name = path.name;
                iComponent = path.iComponent;
                qComponent = path.qComponent;
                amplitudeSquared = path.amplitudeSquared;
                probability = normalizedProb;
                neurochemicalAffinity = path.neurochemicalAffinity;
                decayRate = path.decayRate;
                rewardHistory = path.rewardHistory;
                confidenceScore = path.confidenceScore;
            }
        })
    };
    
    // ========================================================================
    // SECTION 4: PATH INTERFERENCE — QUANTUM SUPERPOSITION
    // ========================================================================
    
    // Compute interference between paths
    public func computePathInterference(
        paths: [DecisionPath],
        interferenceStrength: Float
    ) : { paths: [DecisionPath]; interferenceScore: Float } {
        
        // Cross-path interference: each pair of paths can interfere
        // Interference term: 2 * Re(ψ_i* × ψ_j) = 2 * (I_i*I_j + Q_i*Q_j)
        
        var totalInterference : Float = 0.0;
        let buffer = Buffer.Buffer<DecisionPath>(5);
        
        for (i in paths.keys()) {
            var pathI = paths[i].iComponent;
            var pathQ = paths[i].qComponent;
            
            // Compute interference contribution from all other paths
            for (j in paths.keys()) {
                if (i != j) {
                    let otherI = paths[j].iComponent;
                    let otherQ = paths[j].qComponent;
                    
                    // Interference term
                    let interference = 2.0 * (pathI * otherI + pathQ * otherQ) * interferenceStrength;
                    totalInterference += Float.abs(interference);
                    
                    // Add interference to amplitude (constructive or destructive)
                    pathI += interference * 0.1;
                };
            };
            
            // Rebuild path with interference
            let ampSq = pathI * pathI + pathQ * pathQ;
            buffer.add({
                id = paths[i].id;
                name = paths[i].name;
                iComponent = pathI;
                qComponent = pathQ;
                amplitudeSquared = ampSq;
                probability = paths[i].probability;
                neurochemicalAffinity = paths[i].neurochemicalAffinity;
                decayRate = paths[i].decayRate;
                rewardHistory = paths[i].rewardHistory;
                confidenceScore = paths[i].confidenceScore;
            });
        };
        
        // Normalize interference score to [0,1]
        let normalizedInterference = totalInterference / 10.0;
        let clampedInterference = if (normalizedInterference > 1.0) { 1.0 } 
                                  else if (normalizedInterference < 0.0) { 0.0 } 
                                  else { normalizedInterference };
        
        { 
            paths = Buffer.toArray(buffer); 
            interferenceScore = clampedInterference 
        }
    };
    
    // ========================================================================
    // SECTION 5: PATH SELECTION — QUANTUM MEASUREMENT
    // ========================================================================
    
    // Select winning path based on probability distribution
    // Uses pseudo-random noise to collapse the quantum state
    public func selectWinningPath(
        paths: [DecisionPath],
        noise: Float  // Random value 0-1 for path selection
    ) : { winnerIndex: Nat; winnerProbability: Float } {
        
        // Build cumulative distribution
        var cumulative : Float = 0.0;
        var winner : Nat = 0;
        var winnerProb : Float = 0.0;
        
        // Use noise as quantum measurement outcome
        let measurementPoint = noise;
        
        for (i in paths.keys()) {
            cumulative += paths[i].probability;
            if (measurementPoint <= cumulative and winnerProb == 0.0) {
                winner := i;
                winnerProb := paths[i].probability;
            };
        };
        
        // Edge case: if noise > cumulative, select last path
        if (winnerProb == 0.0) {
            winner := 4;
            winnerProb := paths[4].probability;
        };
        
        { winnerIndex = winner; winnerProbability = winnerProb }
    };
    
    // Deterministic selection (highest amplitude)
    public func selectHighestAmplitude(paths: [DecisionPath]) : { winnerIndex: Nat; winnerProbability: Float } {
        var maxAmp : Float = 0.0;
        var winner : Nat = 0;
        
        for (i in paths.keys()) {
            if (paths[i].amplitudeSquared > maxAmp) {
                maxAmp := paths[i].amplitudeSquared;
                winner := i;
            };
        };
        
        { winnerIndex = winner; winnerProbability = paths[winner].probability }
    };
    
    // ========================================================================
    // SECTION 6: DECISION ENTROPY & CONFIDENCE
    // ========================================================================
    
    // Compute Shannon entropy of decision
    public func computeDecisionEntropy(paths: [DecisionPath]) : Float {
        var entropy : Float = 0.0;
        
        for (path in paths.vals()) {
            if (path.probability > 0.001) {
                entropy -= path.probability * Float.log(path.probability);
            };
        };
        
        // Normalize by max entropy (log(5) for 5 paths)
        let maxEntropy = Float.log(5.0);
        entropy / maxEntropy
    };
    
    // Compute decision coherence (inverse of entropy, sort of)
    public func computeDecisionCoherence(paths: [DecisionPath]) : Float {
        // Coherence is high when one path dominates
        var maxProb : Float = 0.0;
        for (path in paths.vals()) {
            if (path.probability > maxProb) {
                maxProb := path.probability;
            };
        };
        
        // If max probability is high, coherence is high
        // Perfect coherence = 1.0 when one path has 100% probability
        maxProb
    };
    
    // Compute meta-cognitive confidence
    public func computeConfidence(
        paths: [DecisionPath],
        winnerIndex: Nat,
        rewardHistory: Float
    ) : Float {
        let winnerProb = paths[winnerIndex].probability;
        let winnerReward = paths[winnerIndex].rewardHistory;
        
        // Confidence = (probability × reward_history × global_reward) ^ 1/3
        let rawConfidence = winnerProb * winnerReward * rewardHistory;
        Float.pow(rawConfidence, 1.0/3.0)
    };
    
    // ========================================================================
    // SECTION 7: FULL DECISION CYCLE
    // ========================================================================
    
    // Execute a complete decision cycle
    public func makeDecision(
        state: PARALLAXEngineState,
        domain: Text,
        neurochemicals: [Float],
        quantumPhase: Float,
        noise: Float,
        beatNumber: Nat
    ) : DecisionState {
        let dt = 1.0 / 12.0;  // 12 Hz heartbeat
        
        // Initialize paths for this domain
        var paths = initializeDecisionPaths(domain);
        
        // Apply prior knowledge from path history
        paths := Array.tabulate<DecisionPath>(5, func(i: Nat) : DecisionPath {
            let path = paths[i];
            let historyBias = Array.freeze(state.pathRewardHistory)[i];
            {
                id = path.id;
                name = path.name;
                iComponent = path.iComponent + historyBias * 0.2;
                qComponent = path.qComponent;
                amplitudeSquared = path.amplitudeSquared;
                probability = path.probability;
                neurochemicalAffinity = path.neurochemicalAffinity;
                decayRate = path.decayRate;
                rewardHistory = historyBias;
                confidenceScore = Array.freeze(state.pathConfidenceEMA)[i];
            }
        });
        
        // Evolve amplitudes based on neurochemical state
        paths := evolvePathAmplitudes(paths, neurochemicals, quantumPhase, dt);
        
        // Compute path interference
        let interferenceResult = computePathInterference(paths, state.interferenceStrength);
        paths := interferenceResult.paths;
        
        // Normalize probabilities
        paths := normalizeProbabilities(paths);
        
        // Select winning path (quantum measurement)
        let selection = selectWinningPath(paths, noise);
        
        // Compute metrics
        let entropy = computeDecisionEntropy(paths);
        let coherence = computeDecisionCoherence(paths);
        let confidence = computeConfidence(paths, selection.winnerIndex, state.decisionQuality);
        
        // Build decision state
        {
            decisionId = state.totalDecisions;
            domain = domain;
            paths = paths;
            winnerIndex = selection.winnerIndex;
            winnerProbability = selection.winnerProbability;
            interferenceScore = interferenceResult.interferenceScore;
            coherenceLevel = coherence;
            entropyScore = entropy;
            timestampBeat = beatNumber;
            neurochemicalModulation = neurochemicals;
        }
    };
    
    // ========================================================================
    // SECTION 8: BEHAVIOR DECISION INTEGRATION
    // ========================================================================
    
    // Map decision to behavior index (0-8: FORAGE, DEFEND, ENGAGE, RETREAT, RELAY, HEAL, SCOUT, AMBUSH, FORM)
    public func mapDecisionToBehavior(decision: DecisionState) : Nat {
        let winner = decision.winnerIndex;
        let confidence = decision.coherenceLevel;
        
        // High confidence → direct mapping
        // Low confidence → fallback to FORAGE (0)
        if (confidence > 0.5) {
            // Map 5 paths to 9 behaviors
            // FORAGE=0, DEFEND=1, ENGAGE=2, RETREAT=3, RELAY=4, HEAL=5, SCOUT=6, AMBUSH=7, FORM=8
            switch (winner) {
                case 0 { 0 };  // FORAGE (reward-seeking)
                case 1 { 1 };  // DEFEND (stability)
                case 2 { 2 };  // ENGAGE (urgency)
                case 3 { 6 };  // SCOUT (learning/exploration)
                case 4 { 3 };  // RETREAT (inhibition)
                case _ { 0 };
            }
        } else {
            // Low confidence → default to SCOUT (exploration)
            6
        }
    };
    
    // ========================================================================
    // SECTION 9: COUNCIL DECISION INTEGRATION
    // ========================================================================
    
    // Map decision to council voting weight
    public func computeCouncilVoteWeights(decision: DecisionState) : [Float] {
        // 5 councils: LEXIS, PARALLAX-SWARM, VETUS, AEGIS, FORMA
        // Each path contributes to a council's voting weight
        
        Array.tabulate<Float>(5, func(i: Nat) : Float {
            let path = decision.paths[i];
            // Weight = probability × confidence
            path.probability * path.confidenceScore
        })
    };
    
    // ========================================================================
    // SECTION 10: ECONOMIC DECISION INTEGRATION
    // ========================================================================
    
    // Compute economic routing weights
    public func computeEconomicRouting(decision: DecisionState) : [Float] {
        // 5 streams: SOVEREIGN, COMPOUND, HARVEST, RESERVE, DISTRIBUTE
        // Higher amplitude → more allocation to that stream
        
        Array.tabulate<Float>(5, func(i: Nat) : Float {
            decision.paths[i].probability
        })
    };
    
    // ========================================================================
    // SECTION 11: ENGINE UPDATE — CALLED EVERY BEAT
    // ========================================================================
    
    // Update engine state with new decision outcome
    public func updateEngine(
        state: PARALLAXEngineState,
        decision: DecisionState,
        reward: Float  // Reward received from chosen path
    ) : PARALLAXEngineState {
        // Update path selection counts
        let counts = Array.thaw<Nat>(Array.freeze(state.pathSelectionCounts));
        counts[decision.winnerIndex] += 1;
        
        // Update path reward history with EMA
        let rewards = Array.thaw<Float>(Array.freeze(state.pathRewardHistory));
        let alpha = 0.1;  // EMA smoothing factor
        rewards[decision.winnerIndex] := rewards[decision.winnerIndex] * (1.0 - alpha) + reward * alpha;
        
        // Update path confidence
        let confidences = Array.thaw<Float>(Array.freeze(state.pathConfidenceEMA));
        confidences[decision.winnerIndex] := confidences[decision.winnerIndex] * 0.95 + decision.coherenceLevel * 0.05;
        
        // Update global metrics
        let newDecisionQuality = state.decisionQuality * 0.99 + reward * 0.01;
        let newAverageConfidence = state.averageConfidence * 0.99 + decision.coherenceLevel * 0.01;
        
        // Compute regret for non-selected paths
        var maxOtherReward : Float = 0.0;
        for (i in decision.paths.keys()) {
            if (i != decision.winnerIndex) {
                let expectedReward = decision.paths[i].probability * decision.paths[i].rewardHistory;
                if (expectedReward > maxOtherReward) {
                    maxOtherReward := expectedReward;
                };
            };
        };
        let regret = maxOtherReward - reward;
        let newRegret = state.regretAccumulator + (if (regret > 0.0) { regret } else { 0.0 });
        
        // Add to history
        state.decisionHistory.add(decision);
        
        {
            var totalDecisions = state.totalDecisions + 1;
            var activeDecisions = [];
            var decisionHistory = state.decisionHistory;
            
            var pathSelectionCounts = counts;
            var pathRewardHistory = rewards;
            var pathConfidenceEMA = confidences;
            
            var neurochemicalWeights = state.neurochemicalWeights;
            var dopaminePathBias = state.dopaminePathBias;
            var serotoninPathBias = state.serotoninPathBias;
            var norepinephrinePathBias = state.norepinephrinePathBias;
            var acetylcholinePathBias = state.acetylcholinePathBias;
            var gabaPathBias = state.gabaPathBias;
            
            var globalPhase = state.globalPhase + π / 100.0;
            var decoherenceRate = state.decoherenceRate;
            var interferenceStrength = state.interferenceStrength;
            var quantumNoiseLevel = state.quantumNoiseLevel;
            
            var averageDecisionTime = state.averageDecisionTime;
            var averageConfidence = newAverageConfidence;
            var decisionQuality = newDecisionQuality;
            var regretAccumulator = newRegret;
            
            var lastQuantumHeartbeatPhase = state.lastQuantumHeartbeatPhase;
            var lastNeurochemicalSnapshot = state.lastNeurochemicalSnapshot;
            var councilDecisionPending = state.councilDecisionPending;
            var economicDecisionPending = state.economicDecisionPending;
            var behaviorDecisionPending = state.behaviorDecisionPending;
        }
    };
    
    // ========================================================================
    // SECTION 12: DIAGNOSTIC QUERIES
    // ========================================================================
    
    // Get engine statistics
    public func getEngineStats(state: PARALLAXEngineState) : {
        totalDecisions: Nat;
        pathSelectionCounts: [Nat];
        averageConfidence: Float;
        decisionQuality: Float;
        regretAccumulator: Float;
        globalPhase: Float;
    } {
        {
            totalDecisions = state.totalDecisions;
            pathSelectionCounts = Array.freeze(state.pathSelectionCounts);
            averageConfidence = state.averageConfidence;
            decisionQuality = state.decisionQuality;
            regretAccumulator = state.regretAccumulator;
            globalPhase = state.globalPhase;
        }
    };
    
    // Get path probabilities for visualization
    public func getPathProbabilities(decision: DecisionState) : [Float] {
        Array.tabulate<Float>(5, func(i: Nat) : Float {
            decision.paths[i].probability
        })
    };
    
    // Get decision summary
    public func getDecisionSummary(decision: DecisionState) : Text {
        let winnerName = decision.paths[decision.winnerIndex].name;
        "PARALLAX Decision: " # winnerName # 
        " (p=" # Float.toText(decision.winnerProbability) # 
        ", coherence=" # Float.toText(decision.coherenceLevel) # 
        ", entropy=" # Float.toText(decision.entropyScore) # ")"
    };
};
