// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  KURAMOTO ENGINE TEST SUITE                                                                               ║
// ║  Phase oscillator synchronization - the heartbeat of the organism                                         ║
// ║  Tests the mathematical foundations of swarm coherence                                                    ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import the module under test
import KuramotoEngine "../src/swarm_brain/modules/KuramotoEngine";

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

    // ═══════════════════════════════════════════════════════════════════════════════
    // PHASE CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPiConstant() : TestResult {
        // PI should be approximately 3.14159...
        let PI = 3.14159265358979323846;
        assertFloatClose(PI, 3.14159265, 0.0000001, "PI constant should be correct")
    };

    public func testTwoPiConstant() : TestResult {
        // TWO_PI should be 2 * PI
        let TWO_PI = 6.28318530717958647692;
        let PI = 3.14159265358979323846;
        assertFloatClose(TWO_PI, 2.0 * PI, 0.0000001, "TWO_PI should equal 2*PI")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ORGAN FREQUENCIES TESTS - The 18 organs that form the living system
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testOrganFrequenciesCount() : TestResult {
        // Should have exactly 18 organ frequencies (from biological model)
        let freqs = KuramotoEngine.ORGAN_FREQS;
        assertTrue(freqs.size() == 18, "Should have 18 organ frequencies")
    };

    public func testOrganFrequenciesPositive() : TestResult {
        // All frequencies must be positive
        let freqs = KuramotoEngine.ORGAN_FREQS;
        var allPositive = true;
        for (f in freqs.vals()) {
            if (f <= 0.0) { allPositive := false };
        };
        assertTrue(allPositive, "All organ frequencies should be positive")
    };

    public func testHeartFrequency() : TestResult {
        // Heart (index 0) = 0.08 Hz
        let freqs = KuramotoEngine.ORGAN_FREQS;
        assertFloatClose(0.08, freqs[0], 0.001, "Heart frequency should be 0.08 Hz")
    };

    public func testBrainFrequency() : TestResult {
        // Brain (index 2) = 0.12 Hz
        let freqs = KuramotoEngine.ORGAN_FREQS;
        assertFloatClose(0.12, freqs[2], 0.001, "Brain frequency should be 0.12 Hz")
    };

    public func testSpineFrequency() : TestResult {
        // Spine (index 17) = 0.13 Hz
        let freqs = KuramotoEngine.ORGAN_FREQS;
        assertFloatClose(0.13, freqs[17], 0.001, "Spine frequency should be 0.13 Hz")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ORDER PARAMETER TESTS - Global synchronization measure
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testOrderParameterPerfectSync() : TestResult {
        // When all oscillators have same phase, r should be 1.0
        let oscs : [KuramotoEngine.Oscillator] = [
            { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
        ];
        let (r, _) = KuramotoEngine.computeOrderParameter(oscs);
        assertFloatClose(1.0, r, 0.01, "Perfect sync should have r = 1.0")
    };

    public func testOrderParameterOppositePhases() : TestResult {
        // When oscillators are 180° apart, r should be near 0
        let PI = 3.14159265358979323846;
        let oscs : [KuramotoEngine.Oscillator] = [
            { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = PI; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
        ];
        let (r, _) = KuramotoEngine.computeOrderParameter(oscs);
        assertFloatClose(0.0, r, 0.1, "Opposite phases should have r ≈ 0")
    };

    public func testOrderParameterUniformDistribution() : TestResult {
        // When phases are uniformly distributed, r should be near 0
        let TWO_PI = 6.28318530717958647692;
        let oscs : [KuramotoEngine.Oscillator] = [
            { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = TWO_PI / 4.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = TWO_PI / 2.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = 3.0 * TWO_PI / 4.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
        ];
        let (r, _) = KuramotoEngine.computeOrderParameter(oscs);
        assertFloatClose(0.0, r, 0.1, "Uniform distribution should have r ≈ 0")
    };

    public func testOrderParameterEmpty() : TestResult {
        // Empty array should return (0, 0)
        let oscs : [KuramotoEngine.Oscillator] = [];
        let (r, psi) = KuramotoEngine.computeOrderParameter(oscs);
        assertTrue(r == 0.0 and psi == 0.0, "Empty oscillators should return (0, 0)")
    };

    public func testOrderParameterRange() : TestResult {
        // Order parameter should always be in [0, 1]
        let TWO_PI = 6.28318530717958647692;
        let oscs : [KuramotoEngine.Oscillator] = [
            { phase = 0.5; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = 1.2; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = 3.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            { phase = 5.5; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
        ];
        let (r, _) = KuramotoEngine.computeOrderParameter(oscs);
        assertTrue(r >= 0.0 and r <= 1.0, "Order parameter should be in [0, 1]")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // BEAT UPDATE TESTS - Evolution of the system
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testBeatKuramotoIncrementsBeat() : TestResult {
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [
                { phase = 0.0; naturalFreq = 0.1; coupling = 1.0; amplitude = 1.0 },
            ];
            globalCoupling = 1.0;
            orderParam = 1.0;
            meanPhase = 0.0;
            beatNum = 0;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.beatKuramoto(state, 0.1);
        assertTrue(newState.beatNum == 1, "Beat number should increment")
    };

    public func testBeatKuramotoUpdatesPhase() : TestResult {
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [
                { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            ];
            globalCoupling = 1.0;
            orderParam = 1.0;
            meanPhase = 0.0;
            beatNum = 0;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.beatKuramoto(state, 1.0);
        let newPhase = newState.oscillators[0].phase;
        assertTrue(newPhase > 0.0, "Phase should increase with positive frequency")
    };

    public func testBeatKuramotoUpdatesSyncHistory() : TestResult {
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [
                { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            ];
            globalCoupling = 1.0;
            orderParam = 0.5;
            meanPhase = 0.0;
            beatNum = 0;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.beatKuramoto(state, 0.1);
        assertTrue(newState.syncHistory.size() == 1, "Sync history should grow")
    };

    public func testSyncHistoryMaxSize() : TestResult {
        // History should be capped at 100
        var history = Buffer.Buffer<Float>(100);
        var i = 0;
        while (i < 100) {
            history.add(0.5);
            i += 1;
        };
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [
                { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            ];
            globalCoupling = 1.0;
            orderParam = 0.5;
            meanPhase = 0.0;
            beatNum = 100;
            syncHistory = Buffer.toArray(history);
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.beatKuramoto(state, 0.1);
        assertTrue(newState.syncHistory.size() == 100, "Sync history should cap at 100")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ADAPTIVE COUPLING TESTS - The organism learns optimal K
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testAdaptCouplingIncreases() : TestResult {
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [];
            globalCoupling = 1.0;
            orderParam = 0.5;  // Below target
            meanPhase = 0.0;
            beatNum = 0;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.adaptCoupling(state, 0.8, 0.1); // Target 0.8
        assertTrue(newState.globalCoupling > state.globalCoupling, "Coupling should increase when r < target")
    };

    public func testAdaptCouplingDecreases() : TestResult {
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [];
            globalCoupling = 5.0;
            orderParam = 0.9;  // Above target
            meanPhase = 0.0;
            beatNum = 0;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.adaptCoupling(state, 0.6, 0.1); // Target 0.6
        assertTrue(newState.globalCoupling < state.globalCoupling, "Coupling should decrease when r > target")
    };

    public func testAdaptCouplingBounds() : TestResult {
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [];
            globalCoupling = 9.5;
            orderParam = 0.1;  // Way below target
            meanPhase = 0.0;
            beatNum = 0;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.adaptCoupling(state, 1.0, 10.0); // Large adaptation
        assertTrue(newState.globalCoupling <= 10.0, "Coupling should be bounded at 10.0")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // PHASE RESET TESTS - ARES emergency synchronization
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPhaseResetSetsAllPhases() : TestResult {
        let PI = 3.14159265358979323846;
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [
                { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
                { phase = 1.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
                { phase = 2.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            ];
            globalCoupling = 1.0;
            orderParam = 0.3;
            meanPhase = 0.5;
            beatNum = 50;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.phaseReset(state, PI);
        var allReset = true;
        for (osc in newState.oscillators.vals()) {
            if (osc.phase != PI) { allReset := false };
        };
        assertTrue(allReset, "All phases should be reset to target")
    };

    public func testPhaseResetPerfectSync() : TestResult {
        let PI = 3.14159265358979323846;
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [
                { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
                { phase = 1.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            ];
            globalCoupling = 1.0;
            orderParam = 0.3;
            meanPhase = 0.5;
            beatNum = 50;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.phaseReset(state, PI);
        assertFloatClose(1.0, newState.orderParam, 0.01, "Order parameter should be 1.0 after reset")
    };

    public func testPhaseResetUpdatesMeanPhase() : TestResult {
        let PI = 3.14159265358979323846;
        let state : KuramotoEngine.KuramotoState = {
            oscillators = [
                { phase = 0.0; naturalFreq = 1.0; coupling = 1.0; amplitude = 1.0 },
            ];
            globalCoupling = 1.0;
            orderParam = 0.3;
            meanPhase = 0.5;
            beatNum = 50;
            syncHistory = [];
            criticalK = 0.5;
        };
        let newState = KuramotoEngine.phaseReset(state, PI);
        assertFloatClose(PI, newState.meanPhase, 0.001, "Mean phase should be reset to target")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // CONVERGENCE TESTS - Does the system synchronize?
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testConvergenceWithHighCoupling() : TestResult {
        // With high coupling K, oscillators should synchronize
        let TWO_PI = 6.28318530717958647692;
        var state : KuramotoEngine.KuramotoState = {
            oscillators = [
                { phase = 0.0; naturalFreq = 0.1; coupling = 1.0; amplitude = 1.0 },
                { phase = TWO_PI * 0.25; naturalFreq = 0.1; coupling = 1.0; amplitude = 1.0 },
                { phase = TWO_PI * 0.5; naturalFreq = 0.1; coupling = 1.0; amplitude = 1.0 },
                { phase = TWO_PI * 0.75; naturalFreq = 0.1; coupling = 1.0; amplitude = 1.0 },
            ];
            globalCoupling = 5.0;  // High coupling
            orderParam = 0.0;
            meanPhase = 0.0;
            beatNum = 0;
            syncHistory = [];
            criticalK = 0.5;
        };
        // Run many beats
        var i = 0;
        while (i < 100) {
            state := KuramotoEngine.beatKuramoto(state, 0.1);
            i += 1;
        };
        assertTrue(state.orderParam > 0.7, "High coupling should lead to synchronization")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let results = Buffer.Buffer<TestResult>(30);

        // Phase Constants
        results.add(testPiConstant());
        results.add(testTwoPiConstant());

        // Organ Frequencies
        results.add(testOrganFrequenciesCount());
        results.add(testOrganFrequenciesPositive());
        results.add(testHeartFrequency());
        results.add(testBrainFrequency());
        results.add(testSpineFrequency());

        // Order Parameter
        results.add(testOrderParameterPerfectSync());
        results.add(testOrderParameterOppositePhases());
        results.add(testOrderParameterUniformDistribution());
        results.add(testOrderParameterEmpty());
        results.add(testOrderParameterRange());

        // Beat Update
        results.add(testBeatKuramotoIncrementsBeat());
        results.add(testBeatKuramotoUpdatesPhase());
        results.add(testBeatKuramotoUpdatesSyncHistory());
        results.add(testSyncHistoryMaxSize());

        // Adaptive Coupling
        results.add(testAdaptCouplingIncreases());
        results.add(testAdaptCouplingDecreases());
        results.add(testAdaptCouplingBounds());

        // Phase Reset
        results.add(testPhaseResetSetsAllPhases());
        results.add(testPhaseResetPerfectSync());
        results.add(testPhaseResetUpdatesMeanPhase());

        // Convergence
        results.add(testConvergenceWithHighCoupling());

        Buffer.toArray(results)
    };

    public func printTestResults(results: [TestResult]) : Text {
        var output = "\n════════════════════════════════════════════════════════════════\n";
        output #= "         KURAMOTO ENGINE TEST RESULTS\n";
        output #= "════════════════════════════════════════════════════════════════\n\n";

        var passed = 0;
        var failed = 0;

        for (result in results.vals()) {
            if (result.passed) {
                passed += 1;
                output #= "✓ " # result.name # "\n";
            } else {
                failed += 1;
                output #= "✗ " # result.name # " - " # result.message # "\n";
            };
        };

        output #= "\n════════════════════════════════════════════════════════════════\n";
        output #= "SUMMARY: " # Nat.toText(passed) # " passed, " # Nat.toText(failed) # " failed\n";
        output #= "════════════════════════════════════════════════════════════════\n";

        output
    };
}
