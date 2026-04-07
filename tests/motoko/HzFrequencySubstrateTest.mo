// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  HZ FREQUENCY SUBSTRATE TEST SUITE                                                                        ║
// ║  Tests for the organism's living rhythm - Hz frequencies and phase coherence                              ║
// ║  The brain is rhythms, not just numbers. RHYTHMS.                                                         ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import the module under test
import HzFrequencySubstrate "../../src/swarm_brain/modules/HzFrequencySubstrate";

module {

    // ═══════════════════════════════════════════════════════════════════════════════
    // TEST UTILITIES
    // ═══════════════════════════════════════════════════════════════════════════════

    public type TestResult = {
        name: Text;
        passed: Bool;
        message: Text;
    };

    func assertFloatClose(expected: Float, actual: Float, tolerance: Float, name: Text) : TestResult {
        let diff = Float.abs(expected - actual);
        if (diff <= tolerance) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Expected " # Float.toText(expected) # " but got " # Float.toText(actual) }
        }
    };

    func assertTrue(condition: Bool, name: Text) : TestResult {
        if (condition) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Condition was false" }
        }
    };

    func assertFalse(condition: Bool, name: Text) : TestResult {
        if (not condition) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Condition was true" }
        }
    };

    // Helper to create a test node
    func makeTestNode(nodeId: Text, baseFreq: Float, phase: Float) : HzFrequencySubstrate.HzNodeState {
        {
            nodeId = nodeId;
            baseFrequency = baseFreq;
            currentFrequency = baseFreq;
            phase = phase;
            lastPhaseUpdate = 0;
            activationHistory = [];
            fatigueLevel = 0.0;
            doctrineAlignment = 1.0;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // MATHEMATICAL CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPi() : TestResult {
        assertFloatClose(3.1415926535897932385, HzFrequencySubstrate.PI, 1e-10, "PI should be correct")
    };

    public func testTau() : TestResult {
        assertFloatClose(6.2831853071795864769, HzFrequencySubstrate.TAU, 1e-10, "TAU should be 2π")
    };

    public func testPhi() : TestResult {
        assertFloatClose(1.6180339887498948482, HzFrequencySubstrate.PHI, 1e-10, "PHI should be golden ratio")
    };

    public func testHeartbeatRate() : TestResult {
        assertFloatClose(0.5, HzFrequencySubstrate.HEARTBEAT_RATE, 0.01, "HEARTBEAT_RATE should be 0.5 Hz")
    };

    public func testRhoF() : TestResult {
        // RHO_F = 150.0 (Phase coherence contributes 15% of C scale)
        assertFloatClose(150.0, HzFrequencySubstrate.RHO_F, 0.1, "RHO_F should be 150.0")
    };

    public func testBetaPhase() : TestResult {
        // BETA_PHASE = 0.3 (30% boost when memory substrates in phase)
        assertFloatClose(0.3, HzFrequencySubstrate.BETA_PHASE, 0.01, "BETA_PHASE should be 0.3")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SUBSTRATE FREQUENCY CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testHzLexis() : TestResult {
        assertFloatClose(0.40, HzFrequencySubstrate.HZ_LEXIS, 0.01, "HZ_LEXIS should be 0.40 Hz")
    };

    public func testHzForge() : TestResult {
        assertFloatClose(0.25, HzFrequencySubstrate.HZ_FORGE, 0.01, "HZ_FORGE should be 0.25 Hz")
    };

    public func testHzMemoria() : TestResult {
        // Memory consolidation - slow wave
        assertFloatClose(0.08, HzFrequencySubstrate.HZ_MEMORIA, 0.01, "HZ_MEMORIA should be 0.08 Hz")
    };

    public func testHzPulse() : TestResult {
        // SA node heartbeat
        assertFloatClose(1.00, HzFrequencySubstrate.HZ_PULSE, 0.01, "HZ_PULSE should be 1.0 Hz")
    };

    public func testHzKore() : TestResult {
        // Deep field stabilizer - very slow
        assertFloatClose(0.03, HzFrequencySubstrate.HZ_KORE, 0.01, "HZ_KORE should be 0.03 Hz")
    };

    public func testHzVael() : TestResult {
        // Immune threat scan - fastest
        assertFloatClose(0.60, HzFrequencySubstrate.HZ_VAEL, 0.01, "HZ_VAEL should be 0.60 Hz")
    };

    public func testHzChrono() : TestResult {
        // Temporal field master
        assertFloatClose(1.00, HzFrequencySubstrate.HZ_CHRONO, 0.01, "HZ_CHRONO should be 1.0 Hz")
    };

    public func testHzFlux() : TestResult {
        // Raw signal carrier - fast
        assertFloatClose(2.00, HzFrequencySubstrate.HZ_FLUX, 0.01, "HZ_FLUX should be 2.0 Hz")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // FREQUENCY EVOLUTION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testEvolveFrequencyNoChange() : TestResult {
        let node = makeTestNode("TEST", 0.5, 0.0);
        let newFreq = HzFrequencySubstrate.evolveFrequency(node, 0.0, 0.0, 0.0);
        assertFloatClose(0.5, newFreq, 0.01, "Frequency should stay same with no deltas")
    };

    public func testEvolveFrequencyActivationIncrease() : TestResult {
        let node = makeTestNode("TEST", 0.5, 0.0);
        let newFreq = HzFrequencySubstrate.evolveFrequency(node, 1.0, 0.0, 0.0);
        assertTrue(newFreq > 0.5, "Frequency should increase with positive activation delta")
    };

    public func testEvolveFrequencyFatigueDecrease() : TestResult {
        let node = makeTestNode("TEST", 0.5, 0.0);
        let newFreq = HzFrequencySubstrate.evolveFrequency(node, 0.0, 0.0, 1.0);
        assertTrue(newFreq < 0.5, "Frequency should decrease with fatigue delta")
    };

    public func testEvolveFrequencyDoctrineIncrease() : TestResult {
        let node = makeTestNode("TEST", 0.5, 0.0);
        let newFreq = HzFrequencySubstrate.evolveFrequency(node, 0.0, 1.0, 0.0);
        assertTrue(newFreq > 0.5, "Frequency should increase with doctrine alignment delta")
    };

    public func testEvolveFrequencyBoundedMin() : TestResult {
        let node = makeTestNode("TEST", 0.5, 0.0);
        // Large fatigue delta should not go below 50% of base
        let newFreq = HzFrequencySubstrate.evolveFrequency(node, 0.0, 0.0, 100.0);
        assertTrue(newFreq >= 0.25, "Frequency should not go below 50% of base")
    };

    public func testEvolveFrequencyBoundedMax() : TestResult {
        let node = makeTestNode("TEST", 0.5, 0.0);
        // Large activation delta should not exceed 150% of base
        let newFreq = HzFrequencySubstrate.evolveFrequency(node, 100.0, 0.0, 0.0);
        assertTrue(newFreq <= 0.75, "Frequency should not exceed 150% of base")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // PHASE ENGINE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testAdvancePhaseBasic() : TestResult {
        let newPhase = HzFrequencySubstrate.advancePhase(0.0, 0.5);
        assertTrue(newPhase >= 0.0 and newPhase < HzFrequencySubstrate.TAU, 
            "Advanced phase should be in [0, 2π)")
    };

    public func testAdvancePhaseIncreases() : TestResult {
        let phase1 = HzFrequencySubstrate.advancePhase(0.0, 0.5);
        assertTrue(phase1 > 0.0, "Phase should increase with positive frequency")
    };

    public func testAdvancePhaseWraps() : TestResult {
        // Multiple advances should wrap around
        var phase : Float = 0.0;
        for (_ in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].vals()) {
            phase := HzFrequencySubstrate.advancePhase(phase, 0.5);
        };
        assertTrue(phase >= 0.0 and phase < HzFrequencySubstrate.TAU,
            "Phase should stay in [0, 2π) after multiple advances")
    };

    public func testAdvancePhaseHigherFreqFasterPhase() : TestResult {
        let slowPhase = HzFrequencySubstrate.advancePhase(0.0, 0.1);
        let fastPhase = HzFrequencySubstrate.advancePhase(0.0, 1.0);
        assertTrue(fastPhase > slowPhase, "Higher frequency should advance phase faster")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // FREQUENCY COHERENCE K_f TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testFrequencyCoherenceSingleNode() : TestResult {
        // Single node = perfect coherence (1.0)
        let kf = HzFrequencySubstrate.computeFrequencyCoherence([0.5]);
        assertFloatClose(1.0, kf, 0.01, "Single node should have coherence 1.0")
    };

    public func testFrequencyCoherencePerfectSync() : TestResult {
        // All same phase → K_f = 1.0
        let kf = HzFrequencySubstrate.computeFrequencyCoherence([0.0, 0.0, 0.0]);
        assertFloatClose(1.0, kf, 0.01, "Identical phases should have coherence 1.0")
    };

    public func testFrequencyCoherenceOppositePhases() : TestResult {
        // Two phases 180° apart → K_f = -1.0
        let kf = HzFrequencySubstrate.computeFrequencyCoherence([0.0, HzFrequencySubstrate.PI]);
        assertFloatClose(-1.0, kf, 0.1, "Opposite phases should have coherence -1.0")
    };

    public func testFrequencyCoherenceUniform() : TestResult {
        // 4 phases evenly distributed → K_f ≈ 0
        let tau = HzFrequencySubstrate.TAU;
        let kf = HzFrequencySubstrate.computeFrequencyCoherence([
            0.0, tau/4.0, tau/2.0, 3.0*tau/4.0
        ]);
        assertTrue(Float.abs(kf) < 0.3, "Uniformly distributed phases should have coherence ≈ 0")
    };

    public func testFrequencyCoherenceBounded() : TestResult {
        // K_f should always be in [-1, 1]
        let kf = HzFrequencySubstrate.computeFrequencyCoherence([0.1, 0.5, 1.2, 2.3, 4.5]);
        assertTrue(kf >= -1.0 and kf <= 1.0, "Coherence should be in [-1, 1]")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // FREQUENCY DIVERSITY D_f TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testFrequencyDiversitySingleNode() : TestResult {
        // Single node has no diversity
        let df = HzFrequencySubstrate.computeFrequencyDiversity([0.5]);
        assertFloatClose(0.0, df, 0.01, "Single node should have zero diversity")
    };

    public func testFrequencyDiversityIdentical() : TestResult {
        // Identical frequencies = zero diversity
        let df = HzFrequencySubstrate.computeFrequencyDiversity([0.5, 0.5, 0.5]);
        assertFloatClose(0.0, df, 0.01, "Identical frequencies should have zero diversity")
    };

    public func testFrequencyDiversityPositive() : TestResult {
        // Different frequencies = positive diversity
        let df = HzFrequencySubstrate.computeFrequencyDiversity([0.1, 0.5, 1.0]);
        assertTrue(df > 0.0, "Different frequencies should have positive diversity")
    };

    public func testFrequencyDiversityIncreases() : TestResult {
        // More spread = higher diversity
        let dfSmall = HzFrequencySubstrate.computeFrequencyDiversity([0.4, 0.5, 0.6]);
        let dfLarge = HzFrequencySubstrate.computeFrequencyDiversity([0.1, 0.5, 0.9]);
        assertTrue(dfLarge > dfSmall, "Higher spread should have higher diversity")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // MEMORY ENCODING TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testMemoryEncodingMultiplierBase() : TestResult {
        // Zero coherence: multiplier = 1.0
        let mult = HzFrequencySubstrate.memoryEncodingMultiplier(0.0);
        assertFloatClose(1.0, mult, 0.01, "Zero coherence should give multiplier 1.0")
    };

    public func testMemoryEncodingMultiplierBoost() : TestResult {
        // Perfect coherence: multiplier = 1.0 + BETA_PHASE = 1.3
        let mult = HzFrequencySubstrate.memoryEncodingMultiplier(1.0);
        assertFloatClose(1.3, mult, 0.01, "Perfect coherence should give 30% boost")
    };

    public func testMemoryEncodingMultiplierNegative() : TestResult {
        // Anti-coherence: multiplier = 1.0 - BETA_PHASE = 0.7
        let mult = HzFrequencySubstrate.memoryEncodingMultiplier(-1.0);
        assertFloatClose(0.7, mult, 0.01, "Anti-coherence should reduce multiplier")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // EXPRESSION COHERENCE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testExpressionCoherenceNoNodes() : TestResult {
        // Empty node list
        let ec = HzFrequencySubstrate.computeExpressionCoherence([]);
        assertFloatClose(0.0, ec, 0.01, "No nodes should give coherence 0.0")
    };

    public func testExpressionCoherenceInPhase() : TestResult {
        // LEXIS and VEIL in phase
        let nodes = [
            makeTestNode("LEXIS", 0.4, 0.5),
            makeTestNode("VEIL", 0.2, 0.5)
        ];
        let ec = HzFrequencySubstrate.computeExpressionCoherence(nodes);
        assertFloatClose(1.0, ec, 0.1, "Same phase should give coherence 1.0")
    };

    public func testExpressionCoherenceOutOfPhase() : TestResult {
        // LEXIS and VEIL 180° out of phase
        let nodes = [
            makeTestNode("LEXIS", 0.4, 0.0),
            makeTestNode("VEIL", 0.2, HzFrequencySubstrate.PI)
        ];
        let ec = HzFrequencySubstrate.computeExpressionCoherence(nodes);
        assertFloatClose(-1.0, ec, 0.1, "Opposite phase should give coherence -1.0")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // DREAM TRIGGER TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testDreamTriggerHighCoherence() : TestResult {
        let shouldTrigger = HzFrequencySubstrate.shouldTriggerDreamByHz(0.9, 0.8);
        assertTrue(shouldTrigger, "High coherence should trigger dream")
    };

    public func testDreamTriggerLowCoherence() : TestResult {
        let shouldTrigger = HzFrequencySubstrate.shouldTriggerDreamByHz(0.5, 0.8);
        assertFalse(shouldTrigger, "Low coherence should not trigger dream")
    };

    public func testDreamTriggerAtThreshold() : TestResult {
        let shouldTrigger = HzFrequencySubstrate.shouldTriggerDreamByHz(0.8, 0.8);
        assertTrue(shouldTrigger, "At-threshold coherence should trigger dream")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let buffer = Buffer.Buffer<TestResult>(60);
        
        // Mathematical constants
        buffer.add(testPi());
        buffer.add(testTau());
        buffer.add(testPhi());
        buffer.add(testHeartbeatRate());
        buffer.add(testRhoF());
        buffer.add(testBetaPhase());
        
        // Substrate frequency constants
        buffer.add(testHzLexis());
        buffer.add(testHzForge());
        buffer.add(testHzMemoria());
        buffer.add(testHzPulse());
        buffer.add(testHzKore());
        buffer.add(testHzVael());
        buffer.add(testHzChrono());
        buffer.add(testHzFlux());
        
        // Frequency evolution
        buffer.add(testEvolveFrequencyNoChange());
        buffer.add(testEvolveFrequencyActivationIncrease());
        buffer.add(testEvolveFrequencyFatigueDecrease());
        buffer.add(testEvolveFrequencyDoctrineIncrease());
        buffer.add(testEvolveFrequencyBoundedMin());
        buffer.add(testEvolveFrequencyBoundedMax());
        
        // Phase engine
        buffer.add(testAdvancePhaseBasic());
        buffer.add(testAdvancePhaseIncreases());
        buffer.add(testAdvancePhaseWraps());
        buffer.add(testAdvancePhaseHigherFreqFasterPhase());
        
        // Frequency coherence
        buffer.add(testFrequencyCoherenceSingleNode());
        buffer.add(testFrequencyCoherencePerfectSync());
        buffer.add(testFrequencyCoherenceOppositePhases());
        buffer.add(testFrequencyCoherenceUniform());
        buffer.add(testFrequencyCoherenceBounded());
        
        // Frequency diversity
        buffer.add(testFrequencyDiversitySingleNode());
        buffer.add(testFrequencyDiversityIdentical());
        buffer.add(testFrequencyDiversityPositive());
        buffer.add(testFrequencyDiversityIncreases());
        
        // Memory encoding
        buffer.add(testMemoryEncodingMultiplierBase());
        buffer.add(testMemoryEncodingMultiplierBoost());
        buffer.add(testMemoryEncodingMultiplierNegative());
        
        // Expression coherence
        buffer.add(testExpressionCoherenceNoNodes());
        buffer.add(testExpressionCoherenceInPhase());
        buffer.add(testExpressionCoherenceOutOfPhase());
        
        // Dream trigger
        buffer.add(testDreamTriggerHighCoherence());
        buffer.add(testDreamTriggerLowCoherence());
        buffer.add(testDreamTriggerAtThreshold());
        
        Buffer.toArray(buffer)
    };
}
