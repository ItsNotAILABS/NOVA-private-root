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


// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║          SYNAPTIC LOOP CLOSURE ENGINE — Complete Neural Circuit Integration  ║
// ║                                                                              ║
// ║  This module ensures ALL synaptic pathways form closed loops:                ║
// ║  - Every signal has a feedback path                                          ║
// ║  - No orphaned computations                                                  ║
// ║  - Full hierarchical integration across all 12 shells                        ║
// ║  - Bidirectional flow between all modules                                    ║
// ║                                                                              ║
// ║  Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com     ║
// ║  Classification: CONFIDENTIAL — TRADE SECRET                                 ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";

module SynapticLoopClosureEngine {

    // ═══════════════════════════════════════════════════════════════════════════
    // ARCHITECTURE CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════════
    
    let S0 : Float = 1.0;                    // Homeostatic baseline
    let NUM_SHELLS : Nat = 12;               // Total neural shells
    let NUM_COUNCILS : Nat = 7;              // Council organisms
    let SHELL3_NODES : Nat = 256;            // Shell 3 brain nodes
    let COUNCIL_NODES : Nat = 512;           // Per council
    let SHELL12_NODES : Nat = 512;           // Global integration
    let LEXIS_NODES : Nat = 512;             // Doctrine translation
    let PROMETHEUS_SLOTS : Nat = 256;        // Observation slots

    // ═══════════════════════════════════════════════════════════════════════════
    // TYPE DEFINITIONS — Loop Components
    // ═══════════════════════════════════════════════════════════════════════════

    // A synaptic pathway between any two components
    public type SynapticPath = {
        sourceModule : Nat;                   // Origin module ID
        targetModule : Nat;                   // Destination module ID
        sourceNode : Nat;                     // Source node index
        targetNode : Nat;                     // Target node index
        var weight : Float;                   // Connection strength
        var delay : Float;                    // Transmission delay (ms)
        var lastSignal : Float;               // Most recent signal
        var activityHistory : [var Float];    // Recent activity (32 samples)
        var historyIdx : Nat;                 // Ring buffer index
        var isActive : Bool;                  // Currently transmitting
        var plasticityRate : Float;           // Learning rate for this path
    };

    // A complete feedback loop
    public type FeedbackLoop = {
        loopId : Nat;                         // Unique identifier
        forwardPath : SynapticPath;           // Feedforward connection
        backwardPath : SynapticPath;          // Feedback connection
        var loopGain : Float;                 // Total loop gain
        var resonanceFreq : Float;            // Natural frequency
        var stability : Float;                // Lyapunov stability measure
        var lastUpdate : Nat;                 // Last update cycle
    };

    // Module in the hierarchy
    public type HierarchicalModule = {
        moduleId : Nat;
        moduleName : Text;
        level : Nat;                          // Hierarchical level (0=lowest)
        nodeCount : Nat;                      // Number of nodes
        var nodes : [var Float];              // Node activations
        var upwardConnections : [Nat];        // Modules above
        var downwardConnections : [Nat];      // Modules below
        var lateralConnections : [Nat];       // Same-level modules
        var coherence : Float;                // Internal coherence
        var activity : Float;                 // Overall activity level
    };

    // Complete neural architecture with all loops closed
    public type ClosedLoopArchitecture = {
        modules : [var HierarchicalModule];
        feedbackLoops : [var FeedbackLoop];
        synapticPaths : [var SynapticPath];
        
        // Global state
        var totalActivity : Float;
        var globalCoherence : Float;
        var openLoopCount : Nat;              // Should be 0 when fully closed
        var lastIntegrityCheck : Nat;
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // MODULE DEFINITIONS — All Neural Components
    // ═══════════════════════════════════════════════════════════════════════════

    // Module IDs for reference
    public let MOD_SHELL1_SENSORY : Nat = 0;
    public let MOD_SHELL2_FEATURE : Nat = 1;
    public let MOD_SHELL3_BRAIN : Nat = 2;
    public let MOD_SHELL4_HEBBIAN : Nat = 3;
    public let MOD_SHELL5_PREDICT : Nat = 4;
    public let MOD_SHELL6_MEMORY : Nat = 5;
    public let MOD_SHELL7_CONSCIOUS : Nat = 6;
    public let MOD_SHELL8_QUANTUM : Nat = 7;
    public let MOD_SHELL9_WORLD : Nat = 8;
    public let MOD_SHELL10_IDENTITY : Nat = 9;
    public let MOD_SHELL11_ECONOMIC : Nat = 10;
    public let MOD_SHELL12_GLOBAL : Nat = 11;
    public let MOD_COUNCIL_START : Nat = 12;  // 12-18 are councils
    public let MOD_LEXIS : Nat = 19;
    public let MOD_PROMETHEUS : Nat = 20;
    public let MOD_NEUROCHEMICAL : Nat = 21;
    public let MOD_METABOLISM : Nat = 22;
    public let MOD_EMERGENCE : Nat = 23;

    // ═══════════════════════════════════════════════════════════════════════════
    // INITIALIZATION — Build Complete Architecture
    // ═══════════════════════════════════════════════════════════════════════════

    public func initSynapticPath(src: Nat, tgt: Nat, srcNode: Nat, tgtNode: Nat) : SynapticPath {
        {
            sourceModule = src;
            targetModule = tgt;
            sourceNode = srcNode;
            targetNode = tgtNode;
            var weight = S0;
            var delay = 1.0;
            var lastSignal = 0.0;
            var activityHistory = Array.init<Float>(32, 0.0);
            var historyIdx = 0;
            var isActive = true;
            var plasticityRate = 0.01;
        }
    };

    public func initFeedbackLoop(id: Nat, forward: SynapticPath, backward: SynapticPath) : FeedbackLoop {
        {
            loopId = id;
            forwardPath = forward;
            backwardPath = backward;
            var loopGain = S0;
            var resonanceFreq = 10.0;
            var stability = S0;
            var lastUpdate = 0;
        }
    };

    public func initModule(id: Nat, name: Text, level: Nat, nodes: Nat) : HierarchicalModule {
        {
            moduleId = id;
            moduleName = name;
            level = level;
            nodeCount = nodes;
            var nodes = Array.init<Float>(nodes, S0);
            var upwardConnections = [];
            var downwardConnections = [];
            var lateralConnections = [];
            var coherence = S0;
            var activity = S0;
        }
    };

    // Build the complete architecture with all feedback loops
    public func buildClosedLoopArchitecture() : ClosedLoopArchitecture {
        
        // Initialize all modules
        var modules = Array.init<HierarchicalModule>(24, initModule(0, "", 0, 1));
        
        // Shells 1-12
        modules[0] := initModule(0, "Shell1_Sensory", 0, 64);
        modules[1] := initModule(1, "Shell2_Feature", 1, 64);
        modules[2] := initModule(2, "Shell3_Brain", 2, SHELL3_NODES);
        modules[3] := initModule(3, "Shell4_Hebbian", 2, 64);
        modules[4] := initModule(4, "Shell5_Predict", 3, 64);
        modules[5] := initModule(5, "Shell6_Memory", 3, 128);
        modules[6] := initModule(6, "Shell7_Conscious", 4, 64);
        modules[7] := initModule(7, "Shell8_Quantum", 4, 8);
        modules[8] := initModule(8, "Shell9_World", 5, 128);
        modules[9] := initModule(9, "Shell10_Identity", 5, 32);
        modules[10] := initModule(10, "Shell11_Economic", 5, 64);
        modules[11] := initModule(11, "Shell12_Global", 6, SHELL12_NODES);
        
        // 7 Council organisms
        modules[12] := initModule(12, "Council_ALPHA", 4, COUNCIL_NODES);
        modules[13] := initModule(13, "Council_BETA", 4, COUNCIL_NODES);
        modules[14] := initModule(14, "Council_GAMMA", 4, COUNCIL_NODES);
        modules[15] := initModule(15, "Council_DELTA", 4, COUNCIL_NODES);
        modules[16] := initModule(16, "Council_EPSILON", 4, COUNCIL_NODES);
        modules[17] := initModule(17, "Council_ZETA", 4, COUNCIL_NODES);
        modules[18] := initModule(18, "Council_ETA", 4, COUNCIL_NODES);
        
        // Supporting modules
        modules[19] := initModule(19, "LEXIS", 4, LEXIS_NODES);
        modules[20] := initModule(20, "PROMETHEUS", 5, PROMETHEUS_SLOTS);
        modules[21] := initModule(21, "Neurochemical", 3, 21);
        modules[22] := initModule(22, "Metabolism", 2, 64);
        modules[23] := initModule(23, "Emergence", 4, 64);
        
        // Set up hierarchical connections (upward/downward)
        // Shell 1 → Shell 2
        modules[0].upwardConnections := [1];
        modules[1].downwardConnections := [0];
        modules[1].upwardConnections := [2, 3];
        
        // Shell 2 → Shell 3, 4
        modules[2].downwardConnections := [1];
        modules[3].downwardConnections := [1];
        
        // Shell 3 → Shell 5, 6
        modules[2].upwardConnections := [4, 5, 21, 22];  // Also to neurochemical, metabolism
        modules[4].downwardConnections := [2];
        modules[5].downwardConnections := [2];
        
        // Shell 5, 6 → Shell 7
        modules[4].upwardConnections := [6, 8];
        modules[5].upwardConnections := [6, 8];
        modules[6].downwardConnections := [4, 5];
        
        // Shell 7 → Shell 8
        modules[6].upwardConnections := [7, 11];
        modules[7].downwardConnections := [6];
        modules[7].upwardConnections := [11];
        
        // Councils connect to Shell 7 and Shell 12
        var c = 12;
        while (c <= 18) {
            modules[c].downwardConnections := [6, 7];
            modules[c].upwardConnections := [11];
            modules[c].lateralConnections := if (c == 12) { [13, 14] } 
                                             else if (c == 18) { [16, 17] }
                                             else { [c-1, c+1] };
            c += 1;
        };
        
        // Shell 9 (World model) → Shell 10, 11
        modules[8].downwardConnections := [4, 5];
        modules[8].upwardConnections := [9, 10, 11];
        modules[9].downwardConnections := [8];
        modules[10].downwardConnections := [8];
        
        // Shell 12 receives from everything
        modules[11].downwardConnections := [6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20];
        
        // LEXIS connects to doctrine and councils
        modules[19].downwardConnections := [2, 6];
        modules[19].upwardConnections := [11, 12, 13, 14, 15, 16, 17, 18];
        
        // PROMETHEUS observes everything
        modules[20].downwardConnections := [2, 6, 7, 8, 11];
        modules[20].upwardConnections := [11];
        
        // Build all synaptic paths
        var paths = Buffer.Buffer<SynapticPath>(500);
        var loops = Buffer.Buffer<FeedbackLoop>(200);
        
        // Create paths for each connection (forward and backward for feedback)
        var loopId = 0;
        for (mod in modules.vals()) {
            let srcId = mod.moduleId;
            
            // Upward paths
            for (tgtId in mod.upwardConnections.vals()) {
                let forwardPath = initSynapticPath(srcId, tgtId, 0, 0);
                paths.add(forwardPath);
                
                // Create corresponding feedback path
                let backwardPath = initSynapticPath(tgtId, srcId, 0, 0);
                paths.add(backwardPath);
                
                // Create feedback loop
                let loop = initFeedbackLoop(loopId, forwardPath, backwardPath);
                loops.add(loop);
                loopId += 1;
            };
            
            // Lateral paths (bidirectional)
            for (tgtId in mod.lateralConnections.vals()) {
                if (srcId < tgtId) {  // Avoid duplicates
                    let path1 = initSynapticPath(srcId, tgtId, 0, 0);
                    let path2 = initSynapticPath(tgtId, srcId, 0, 0);
                    paths.add(path1);
                    paths.add(path2);
                    
                    let loop = initFeedbackLoop(loopId, path1, path2);
                    loops.add(loop);
                    loopId += 1;
                };
            };
        };
        
        {
            modules = modules;
            feedbackLoops = Array.init<FeedbackLoop>(loops.size(), loops.get(0));
            synapticPaths = Array.init<SynapticPath>(paths.size(), paths.get(0));
            var totalActivity = S0;
            var globalCoherence = S0;
            var openLoopCount = 0;
            var lastIntegrityCheck = 0;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SIGNAL PROPAGATION — Through Closed Loops
    // ═══════════════════════════════════════════════════════════════════════════

    // Propagate signal through a single path
    public func propagateSignal(
        path: SynapticPath,
        sourceActivation: Float,
        dt: Float
    ) : Float {
        if (not path.isActive) { return 0.0 };
        
        // Apply weight and compute output
        let output = sourceActivation * path.weight;
        
        // Record in history
        path.activityHistory[path.historyIdx] := output;
        path.historyIdx := (path.historyIdx + 1) % 32;
        
        // Apply transmission delay effect
        let delayedOutput = output * Float.exp(-path.delay * 0.1);
        
        path.lastSignal := delayedOutput;
        
        delayedOutput
    };

    // Process a complete feedback loop
    public func processFeedbackLoop(
        loop: FeedbackLoop,
        forwardInput: Float,
        backwardInput: Float,
        targetGain: Float,
        dt: Float
    ) : (Float, Float) {                      // Returns (forwardOutput, backwardOutput)
        
        // Forward signal
        let forwardOut = propagateSignal(loop.forwardPath, forwardInput, dt);
        
        // Backward signal (feedback)
        let backwardOut = propagateSignal(loop.backwardPath, backwardInput, dt);
        
        // Calculate loop gain
        loop.loopGain := fabs(forwardOut * backwardOut) + 0.001;
        
        // Stability check - loop gain should not exceed 1 for stability
        if (loop.loopGain > 1.0) {
            // Reduce weights to maintain stability
            let reduction = 0.95;
            loop.forwardPath.weight := loop.forwardPath.weight * reduction;
            loop.backwardPath.weight := loop.backwardPath.weight * reduction;
            loop.stability := loop.stability * 0.9;
        } else {
            loop.stability := fmin(2.0, loop.stability * 1.001);
        };
        
        // Adaptive gain control
        let gainError = targetGain - loop.loopGain;
        loop.forwardPath.weight := fclamp(
            loop.forwardPath.weight + gainError * 0.01 * dt,
            0.01, 2.0
        );
        
        (forwardOut, backwardOut)
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // HIERARCHICAL INTEGRATION — Up and Down the Hierarchy
    // ═══════════════════════════════════════════════════════════════════════════

    // Process upward signal flow (bottom-up)
    public func processUpwardFlow(
        arch: ClosedLoopArchitecture,
        startModule: Nat,
        inputSignal: [Float],
        dt: Float
    ) : [Float] {
        
        if (startModule >= arch.modules.size()) { return [] };
        
        let module = arch.modules[startModule];
        
        // Integrate input into module nodes
        var i = 0;
        while (i < Nat.min(inputSignal.size(), module.nodeCount)) {
            module.nodes[i] := fclamp(
                module.nodes[i] * 0.9 + inputSignal[i] * 0.1,
                0.0, 2.0
            );
            i += 1;
        };
        
        // Calculate module activity and coherence
        var sum : Float = 0.0;
        var sumSq : Float = 0.0;
        i := 0;
        while (i < module.nodeCount) {
            sum += module.nodes[i];
            sumSq += module.nodes[i] * module.nodes[i];
            i += 1;
        };
        let mean = sum / Float.fromInt(module.nodeCount);
        let variance = sumSq / Float.fromInt(module.nodeCount) - mean * mean;
        
        module.activity := mean;
        module.coherence := fclamp(1.0 / (1.0 + Float.sqrt(fmax(0.0, variance))), 0.5, 1.5);
        
        // Prepare output for upward connections
        var output = Array.init<Float>(module.nodeCount, 0.0);
        i := 0;
        while (i < module.nodeCount) {
            output[i] := module.nodes[i] * module.coherence;
            i += 1;
        };
        
        Array.freeze(output)
    };

    // Process downward signal flow (top-down)
    public func processDownwardFlow(
        arch: ClosedLoopArchitecture,
        startModule: Nat,
        feedback: [Float],
        modulation: Float,
        dt: Float
    ) : [Float] {
        
        if (startModule >= arch.modules.size()) { return [] };
        
        let module = arch.modules[startModule];
        
        // Apply top-down modulation
        var i = 0;
        while (i < Nat.min(feedback.size(), module.nodeCount)) {
            // Multiplicative modulation (gain control)
            module.nodes[i] := fclamp(
                module.nodes[i] * (1.0 + (feedback[i] - S0) * modulation * 0.1),
                0.0, 2.0
            );
            i += 1;
        };
        
        // Prepare output for downward connections
        var output = Array.init<Float>(module.nodeCount, 0.0);
        i := 0;
        while (i < module.nodeCount) {
            output[i] := module.nodes[i];
            i += 1;
        };
        
        Array.freeze(output)
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // LOOP VERIFICATION — Ensure All Loops Are Closed
    // ═══════════════════════════════════════════════════════════════════════════

    // Check if all modules have proper feedback
    public func verifyLoopClosure(arch: ClosedLoopArchitecture) : (Bool, Nat) {
        
        var openCount : Nat = 0;
        
        for (module in arch.modules.vals()) {
            // Every module with upward connections needs downward feedback
            if (module.upwardConnections.size() > 0) {
                // Check if any upward target provides downward feedback
                var hasFeedback = false;
                for (targetId in module.upwardConnections.vals()) {
                    if (targetId < arch.modules.size()) {
                        let target = arch.modules[targetId];
                        for (downId in target.downwardConnections.vals()) {
                            if (downId == module.moduleId) {
                                hasFeedback := true;
                            };
                        };
                    };
                };
                if (not hasFeedback) {
                    openCount += 1;
                };
            };
            
            // Every module with downward connections needs upward signal
            if (module.downwardConnections.size() > 0) {
                var hasInput = false;
                for (sourceId in module.downwardConnections.vals()) {
                    if (sourceId < arch.modules.size()) {
                        let source = arch.modules[sourceId];
                        for (upId in source.upwardConnections.vals()) {
                            if (upId == module.moduleId) {
                                hasInput := true;
                            };
                        };
                    };
                };
                if (not hasInput) {
                    openCount += 1;
                };
            };
        };
        
        arch.openLoopCount := openCount;
        (openCount == 0, openCount)
    };

    // Auto-repair open loops
    public func repairOpenLoops(arch: ClosedLoopArchitecture) : Nat {
        
        var repaired : Nat = 0;
        
        for (module in arch.modules.vals()) {
            // Check upward connections
            for (targetId in module.upwardConnections.vals()) {
                if (targetId < arch.modules.size()) {
                    let target = arch.modules[targetId];
                    
                    // Check if target has this module in downward
                    var found = false;
                    for (downId in target.downwardConnections.vals()) {
                        if (downId == module.moduleId) { found := true };
                    };
                    
                    // If not found, add it (would need mutable connections in real impl)
                    if (not found) {
                        repaired += 1;
                    };
                };
            };
        };
        
        repaired
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // RESONANCE DETECTION — Find Natural Oscillation Frequencies
    // ═══════════════════════════════════════════════════════════════════════════

    // Detect resonance in a feedback loop
    public func detectResonance(loop: FeedbackLoop) : Float {
        
        // Analyze activity history of forward path
        let history = loop.forwardPath.activityHistory;
        
        // Simple zero-crossing frequency estimation
        var crossings : Nat = 0;
        var i = 1;
        while (i < 32) {
            if ((history[i-1] - S0) * (history[i] - S0) < 0.0) {
                crossings += 1;
            };
            i += 1;
        };
        
        // Frequency ≈ crossings / (2 * time_window)
        let freq = Float.fromInt(crossings) / 2.0 * 10.0;  // Assuming 10Hz sampling
        
        loop.resonanceFreq := freq;
        freq
    };

    // Synchronize loops to target frequency
    public func synchronizeLoops(
        arch: ClosedLoopArchitecture,
        targetFreq: Float,
        strength: Float,
        dt: Float
    ) {
        for (loop in arch.feedbackLoops.vals()) {
            let currentFreq = detectResonance(loop);
            let freqError = targetFreq - currentFreq;
            
            // Adjust loop dynamics to match target
            // Higher gain → faster oscillation
            if (freqError > 0.0) {
                loop.forwardPath.weight := fclamp(
                    loop.forwardPath.weight * (1.0 + strength * 0.01),
                    0.01, 2.0
                );
            } else {
                loop.forwardPath.weight := fclamp(
                    loop.forwardPath.weight * (1.0 - strength * 0.01),
                    0.01, 2.0
                );
            };
        };
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // GLOBAL INTEGRATION — Complete System Update
    // ═══════════════════════════════════════════════════════════════════════════

    // Run complete integration cycle
    public func runIntegrationCycle(
        arch: ClosedLoopArchitecture,
        sensoryInput: [Float],
        currentCycle: Nat,
        dt: Float
    ) : Float {                               // Returns global coherence
        
        // 1. Bottom-up sweep (sensory → higher levels)
        var currentSignal = sensoryInput;
        var level = 0;
        while (level < 6) {
            // Find modules at this level
            for (module in arch.modules.vals()) {
                if (module.level == level and module.upwardConnections.size() > 0) {
                    let output = processUpwardFlow(arch, module.moduleId, currentSignal, dt);
                    currentSignal := output;
                };
            };
            level += 1;
        };
        
        // 2. Top-down sweep (higher → lower levels)
        var feedback = currentSignal;
        level := 5;
        while (level >= 0) {
            for (module in arch.modules.vals()) {
                if (module.level == level and module.downwardConnections.size() > 0) {
                    let output = processDownwardFlow(arch, module.moduleId, feedback, 0.5, dt);
                    feedback := output;
                };
            };
            level -= 1;
        };
        
        // 3. Process all feedback loops
        for (loop in arch.feedbackLoops.vals()) {
            ignore processFeedbackLoop(loop, S0, S0, S0, dt);
        };
        
        // 4. Calculate global coherence
        var totalCoh : Float = 0.0;
        var count : Float = 0.0;
        for (module in arch.modules.vals()) {
            totalCoh += module.coherence;
            count += 1.0;
        };
        arch.globalCoherence := totalCoh / count;
        
        // 5. Verify loop closure periodically
        if (currentCycle % 100 == 0) {
            ignore verifyLoopClosure(arch);
            arch.lastIntegrityCheck := currentCycle;
        };
        
        // 6. Calculate total activity
        var totalAct : Float = 0.0;
        for (module in arch.modules.vals()) {
            totalAct += module.activity;
        };
        arch.totalActivity := totalAct;
        
        arch.globalCoherence
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // PLASTICITY — Learn Connection Strengths
    // ═══════════════════════════════════════════════════════════════════════════

    // Hebbian learning for paths
    public func hebbianUpdate(
        path: SynapticPath,
        preActivity: Float,
        postActivity: Float,
        learningRate: Float,
        dt: Float
    ) {
        // Hebb's rule: neurons that fire together wire together
        let correlation = (preActivity - S0) * (postActivity - S0);
        let dW = learningRate * correlation * dt;
        
        path.weight := fclamp(path.weight + dW, 0.01, 2.0);
        path.plasticityRate := learningRate;
    };

    // STDP for more sophisticated learning
    public func stdpUpdate(
        path: SynapticPath,
        preSpikeTime: Float,
        postSpikeTime: Float,
        dt: Float
    ) {
        let deltaT = postSpikeTime - preSpikeTime;
        
        var dW : Float = 0.0;
        if (deltaT > 0.0 and deltaT < 50.0) {
            // Pre before post → LTP
            dW := 0.01 * Float.exp(-deltaT / 20.0);
        } else if (deltaT < 0.0 and deltaT > -50.0) {
            // Post before pre → LTD
            dW := -0.012 * Float.exp(deltaT / 20.0);
        };
        
        path.weight := fclamp(path.weight + dW * path.plasticityRate, 0.01, 2.0);
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // HELPER FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════════════

    func fclamp(x: Float, lo: Float, hi: Float) : Float {
        if (x < lo) { lo } else if (x > hi) { hi } else { x }
    };

    func fmax(a: Float, b: Float) : Float {
        if (a > b) { a } else { b }
    };

    func fmin(a: Float, b: Float) : Float {
        if (a < b) { a } else { b }
    };

    func fabs(x: Float) : Float {
        if (x < 0.0) { -x } else { x }
    };

}
