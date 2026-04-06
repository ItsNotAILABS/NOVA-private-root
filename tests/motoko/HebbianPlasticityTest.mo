// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  HEBBIAN PLASTICITY TEST SUITE                                                                            ║
// ║  Synaptic learning - how the organism learns and adapts                                                   ║
// ║  Tests STDP, BCM, and TD learning rules                                                                   ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import the module under test
import HebbianPlasticity "../src/swarm_brain/modules/HebbianPlasticity";

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
    // BASIC HEBBIAN RULE TESTS - "Neurons that fire together wire together"
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testHebbianDeltaPositive() : TestResult {
        // When both pre and post are active, weight should increase
        let delta = HebbianPlasticity.hebbianDelta(1.0, 1.0, 0.1);
        assertTrue(delta > 0.0, "Hebbian delta should be positive when both neurons active")
    };

    public func testHebbianDeltaZeroWhenPreInactive() : TestResult {
        // When pre is inactive, no learning
        let delta = HebbianPlasticity.hebbianDelta(0.0, 1.0, 0.1);
        assertFloatClose(0.0, delta, 0.001, "Hebbian delta should be zero when pre inactive")
    };

    public func testHebbianDeltaZeroWhenPostInactive() : TestResult {
        // When post is inactive, no learning
        let delta = HebbianPlasticity.hebbianDelta(1.0, 0.0, 0.1);
        assertFloatClose(0.0, delta, 0.001, "Hebbian delta should be zero when post inactive")
    };

    public func testHebbianDeltaScalesWithLR() : TestResult {
        // Learning rate should scale the change
        let delta1 = HebbianPlasticity.hebbianDelta(1.0, 1.0, 0.1);
        let delta2 = HebbianPlasticity.hebbianDelta(1.0, 1.0, 0.2);
        assertFloatClose(delta2, 2.0 * delta1, 0.001, "Delta should scale linearly with learning rate")
    };

    public func testHebbianDeltaFormula() : TestResult {
        // Δw = η * pre * post
        let pre = 0.5;
        let post = 0.8;
        let lr = 0.1;
        let expected = lr * pre * post;
        let delta = HebbianPlasticity.hebbianDelta(pre, post, lr);
        assertFloatClose(expected, delta, 0.001, "Hebbian delta should follow η*pre*post")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // OJA'S RULE TESTS - Normalized Hebbian prevents unbounded growth
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testOjaDeltaFormula() : TestResult {
        // Δw = η * post * (pre - w * post)
        let pre = 0.8;
        let post = 0.6;
        let w = 0.5;
        let lr = 0.1;
        let expected = lr * post * (pre - w * post);
        let delta = HebbianPlasticity.ojaDelta(pre, post, w, lr);
        assertFloatClose(expected, delta, 0.001, "Oja delta should follow η*post*(pre - w*post)")
    };

    public func testOjaDeltaEquilibriumAtNormalized() : TestResult {
        // When w*post = pre, delta should be near zero (equilibrium)
        let post = 0.5;
        let pre = 0.5;  // w = 1.0, so w*post = pre
        let w = 1.0;
        let lr = 0.1;
        let delta = HebbianPlasticity.ojaDelta(pre, post, w, lr);
        assertFloatClose(0.0, delta, 0.01, "Oja should reach equilibrium when w*post = pre")
    };

    public func testOjaDeltaDecreaseWhenOverweight() : TestResult {
        // When w is too large, delta should be negative
        let pre = 0.5;
        let post = 0.8;
        let w = 2.0;  // w*post = 1.6 > pre = 0.5
        let lr = 0.1;
        let delta = HebbianPlasticity.ojaDelta(pre, post, w, lr);
        assertTrue(delta < 0.0, "Oja should decrease when weight is too large")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // STDP TESTS - Spike-Timing Dependent Plasticity
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testSTDPLTPWhenPreBeforePost() : TestResult {
        // Pre fires before post → Long Term Potentiation (LTP)
        let preSpikeTime : Nat = 10;
        let postSpikeTime : Nat = 15;  // Post fires after
        let delta = HebbianPlasticity.stdpDelta(
            preSpikeTime, postSpikeTime,
            0.1, 0.12,  // A+, A-
            20.0, 20.0  // τ+, τ-
        );
        assertTrue(delta > 0.0, "STDP should produce LTP when pre before post")
    };

    public func testSTDPLTDWhenPostBeforePre() : TestResult {
        // Post fires before pre → Long Term Depression (LTD)
        let preSpikeTime : Nat = 20;
        let postSpikeTime : Nat = 15;  // Post fires before
        let delta = HebbianPlasticity.stdpDelta(
            preSpikeTime, postSpikeTime,
            0.1, 0.12,  // A+, A-
            20.0, 20.0  // τ+, τ-
        );
        assertTrue(delta < 0.0, "STDP should produce LTD when post before pre")
    };

    public func testSTDPZeroWhenSimultaneous() : TestResult {
        // When spikes are simultaneous, delta should be near zero
        let spikeTime : Nat = 10;
        let delta = HebbianPlasticity.stdpDelta(
            spikeTime, spikeTime,
            0.1, 0.12,
            20.0, 20.0
        );
        assertFloatClose(0.0, delta, 0.01, "STDP should be near zero for simultaneous spikes")
    };

    public func testSTDPDecaysWithTimeDifference() : TestResult {
        // Larger time difference → smaller magnitude change
        let deltaSmall = HebbianPlasticity.stdpDelta(10, 12, 0.1, 0.12, 20.0, 20.0);
        let deltaLarge = HebbianPlasticity.stdpDelta(10, 30, 0.1, 0.12, 20.0, 20.0);
        assertTrue(Float.abs(deltaSmall) > Float.abs(deltaLarge), 
            "STDP magnitude should decay with time difference")
    };

    public func testSTDPAsymmetry() : TestResult {
        // LTD should be slightly stronger than LTP (A- > A+)
        let ltpDelta = HebbianPlasticity.stdpDelta(10, 15, 0.1, 0.12, 20.0, 20.0);
        let ltdDelta = HebbianPlasticity.stdpDelta(15, 10, 0.1, 0.12, 20.0, 20.0);
        // At same |Δt|, |LTD| should be larger
        assertTrue(Float.abs(ltdDelta) >= Float.abs(ltpDelta), 
            "LTD magnitude should be >= LTP magnitude (asymmetry)")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // BCM RULE TESTS - Bienenstock-Cooper-Munro sliding threshold
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testBCMPotentiationAboveThreshold() : TestResult {
        // When post > theta, potentiation
        let pre = 1.0;
        let post = 0.8;
        let theta = 0.5;  // post > theta
        let lr = 0.1;
        let delta = HebbianPlasticity.bcmDelta(pre, post, theta, lr);
        assertTrue(delta > 0.0, "BCM should potentiate when post > theta")
    };

    public func testBCMDepressionBelowThreshold() : TestResult {
        // When post < theta, depression
        let pre = 1.0;
        let post = 0.3;
        let theta = 0.5;  // post < theta
        let lr = 0.1;
        let delta = HebbianPlasticity.bcmDelta(pre, post, theta, lr);
        assertTrue(delta < 0.0, "BCM should depress when post < theta")
    };

    public func testBCMZeroAtThreshold() : TestResult {
        // When post = theta, no change
        let pre = 1.0;
        let post = 0.5;
        let theta = 0.5;
        let lr = 0.1;
        let delta = HebbianPlasticity.bcmDelta(pre, post, theta, lr);
        assertFloatClose(0.0, delta, 0.001, "BCM should be zero when post = theta")
    };

    public func testBCMFormula() : TestResult {
        // Δw = η * pre * post * (post - θ)
        let pre = 0.7;
        let post = 0.8;
        let theta = 0.4;
        let lr = 0.1;
        let expected = lr * pre * post * (post - theta);
        let delta = HebbianPlasticity.bcmDelta(pre, post, theta, lr);
        assertFloatClose(expected, delta, 0.001, "BCM should follow η*pre*post*(post-θ)")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // BCM THRESHOLD UPDATE TESTS - The sliding threshold adapts
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testBCMThresholdIncreasesWithHighActivity() : TestResult {
        let theta = 0.5;
        let post = 0.9;  // High activity
        let tau = 100.0;
        let newTheta = HebbianPlasticity.updateBCMThreshold(theta, post, tau);
        assertTrue(newTheta > theta, "Threshold should increase with high activity")
    };

    public func testBCMThresholdDecreasesWithLowActivity() : TestResult {
        let theta = 0.5;
        let post = 0.2;  // Low activity
        let tau = 100.0;
        let newTheta = HebbianPlasticity.updateBCMThreshold(theta, post, tau);
        assertTrue(newTheta < theta, "Threshold should decrease with low activity")
    };

    public func testBCMThresholdFormula() : TestResult {
        // θ_M(t+1) = θ_M(t) + (post² - θ_M(t)) / τ
        let theta = 0.5;
        let post = 0.7;
        let tau = 50.0;
        let expected = theta + (post * post - theta) / tau;
        let newTheta = HebbianPlasticity.updateBCMThreshold(theta, post, tau);
        assertFloatClose(expected, newTheta, 0.001, "BCM threshold update should follow formula")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ELIGIBILITY TRACE TESTS - For TD learning
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testEligibilityTraceFormula() : TestResult {
        // e(t+1) = γλe(t) + pre*post
        let e = 0.5;
        let pre = 0.8;
        let post = 0.6;
        let gamma = 0.99;
        let lambda = 0.9;
        let expected = gamma * lambda * e + pre * post;
        let newE = HebbianPlasticity.updateEligibility(e, pre, post, gamma, lambda);
        assertFloatClose(expected, newE, 0.001, "Eligibility trace should follow formula")
    };

    public func testEligibilityTraceDecays() : TestResult {
        // With no activity, trace should decay
        let e = 0.5;
        let gamma = 0.99;
        let lambda = 0.9;
        let newE = HebbianPlasticity.updateEligibility(e, 0.0, 0.0, gamma, lambda);
        assertTrue(newE < e, "Eligibility trace should decay without activity")
    };

    public func testEligibilityTraceGrowsWithActivity() : TestResult {
        // With activity, trace should grow
        let e = 0.1;
        let pre = 1.0;
        let post = 1.0;
        let gamma = 0.99;
        let lambda = 0.9;
        let newE = HebbianPlasticity.updateEligibility(e, pre, post, gamma, lambda);
        assertTrue(newE > e, "Eligibility trace should grow with activity")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SYNAPSE UPDATE INTEGRATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testSynapseWeightBoundedMax() : TestResult {
        // Weight should not exceed wMax
        let syn : HebbianPlasticity.Synapse = {
            weight = 1.9;
            preIdx = 0;
            postIdx = 1;
            lastPreSpike = 0;
            lastPostSpike = 0;
            eligibility = 0.0;
        };
        let state : HebbianPlasticity.HebbianState = {
            neurons = [];
            synapses = [syn];
            learningRate = 1.0;  // High LR
            stdpAPlus = 0.1;
            stdpAMinus = 0.12;
            stdpTauPlus = 20.0;
            stdpTauMinus = 20.0;
            wMax = 2.0;
            wMin = 0.0;
            bcmTau = 100.0;
            beatNum = 10;
            totalLTP = 0.0;
            totalLTD = 0.0;
        };
        let (newSyn, _, _) = HebbianPlasticity.updateSynapse(syn, 1.0, 1.0, 10, state);
        assertTrue(newSyn.weight <= 2.0, "Synapse weight should not exceed wMax")
    };

    public func testSynapseWeightBoundedMin() : TestResult {
        // Weight should not go below wMin
        let syn : HebbianPlasticity.Synapse = {
            weight = 0.1;
            preIdx = 0;
            postIdx = 1;
            lastPreSpike = 10;  // Post before pre → LTD
            lastPostSpike = 5;
            eligibility = 0.0;
        };
        let state : HebbianPlasticity.HebbianState = {
            neurons = [];
            synapses = [syn];
            learningRate = 1.0;
            stdpAPlus = 0.1;
            stdpAMinus = 0.5;  // Strong LTD
            stdpTauPlus = 20.0;
            stdpTauMinus = 20.0;
            wMax = 2.0;
            wMin = 0.0;
            bcmTau = 100.0;
            beatNum = 15;
            totalLTP = 0.0;
            totalLTD = 0.0;
        };
        let (newSyn, _, _) = HebbianPlasticity.updateSynapse(syn, 0.0, 0.0, 15, state);
        assertTrue(newSyn.weight >= 0.0, "Synapse weight should not go below wMin")
    };

    public func testSynapseTracksLTP() : TestResult {
        let syn : HebbianPlasticity.Synapse = {
            weight = 1.0;
            preIdx = 0;
            postIdx = 1;
            lastPreSpike = 5;  // Pre before post → LTP
            lastPostSpike = 10;
            eligibility = 0.0;
        };
        let state : HebbianPlasticity.HebbianState = {
            neurons = [];
            synapses = [syn];
            learningRate = 0.1;
            stdpAPlus = 0.1;
            stdpAMinus = 0.12;
            stdpTauPlus = 20.0;
            stdpTauMinus = 20.0;
            wMax = 2.0;
            wMin = 0.0;
            bcmTau = 100.0;
            beatNum = 15;
            totalLTP = 0.0;
            totalLTD = 0.0;
        };
        let (_, ltp, _) = HebbianPlasticity.updateSynapse(syn, 0.8, 0.8, 15, state);
        assertTrue(ltp >= 0.0, "LTP tracking should return non-negative value")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let results = Buffer.Buffer<TestResult>(40);

        // Basic Hebbian
        results.add(testHebbianDeltaPositive());
        results.add(testHebbianDeltaZeroWhenPreInactive());
        results.add(testHebbianDeltaZeroWhenPostInactive());
        results.add(testHebbianDeltaScalesWithLR());
        results.add(testHebbianDeltaFormula());

        // Oja's Rule
        results.add(testOjaDeltaFormula());
        results.add(testOjaDeltaEquilibriumAtNormalized());
        results.add(testOjaDeltaDecreaseWhenOverweight());

        // STDP
        results.add(testSTDPLTPWhenPreBeforePost());
        results.add(testSTDPLTDWhenPostBeforePre());
        results.add(testSTDPZeroWhenSimultaneous());
        results.add(testSTDPDecaysWithTimeDifference());
        results.add(testSTDPAsymmetry());

        // BCM
        results.add(testBCMPotentiationAboveThreshold());
        results.add(testBCMDepressionBelowThreshold());
        results.add(testBCMZeroAtThreshold());
        results.add(testBCMFormula());

        // BCM Threshold
        results.add(testBCMThresholdIncreasesWithHighActivity());
        results.add(testBCMThresholdDecreasesWithLowActivity());
        results.add(testBCMThresholdFormula());

        // Eligibility Trace
        results.add(testEligibilityTraceFormula());
        results.add(testEligibilityTraceDecays());
        results.add(testEligibilityTraceGrowsWithActivity());

        // Synapse Update
        results.add(testSynapseWeightBoundedMax());
        results.add(testSynapseWeightBoundedMin());
        results.add(testSynapseTracksLTP());

        Buffer.toArray(results)
    };

    public func printTestResults(results: [TestResult]) : Text {
        var output = "\n════════════════════════════════════════════════════════════════\n";
        output #= "         HEBBIAN PLASTICITY TEST RESULTS\n";
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
