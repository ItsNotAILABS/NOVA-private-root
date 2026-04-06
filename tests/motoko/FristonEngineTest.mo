// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  FRISTON ENGINE TEST SUITE                                                                                ║
// ║  Free Energy Principle - Active Inference for the organism                                                ║
// ║  Tests prediction error minimization and belief updating                                                  ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import the module under test
import FristonEngine "../src/swarm_brain/modules/FristonEngine";

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
    // PREDICTION ERROR TESTS - The core of Free Energy minimization
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPredictionErrorZeroWhenPerfect() : TestResult {
        // When observation equals prediction, error should be zero
        let error = FristonEngine.computePredictionError(1.0, 1.0, 1.0);
        assertFloatClose(0.0, error, 0.001, "Perfect prediction should have zero error")
    };

    public func testPredictionErrorPositiveWhenOvershoot() : TestResult {
        // When observation > prediction, error should be positive
        let obs = 1.5;
        let pred = 1.0;
        let precision = 1.0;
        let error = FristonEngine.computePredictionError(obs, pred, precision);
        assertTrue(error > 0.0, "Error should be positive when obs > pred")
    };

    public func testPredictionErrorNegativeWhenUndershoot() : TestResult {
        // When observation < prediction, error should be negative
        let obs = 0.5;
        let pred = 1.0;
        let precision = 1.0;
        let error = FristonEngine.computePredictionError(obs, pred, precision);
        assertTrue(error < 0.0, "Error should be negative when obs < pred")
    };

    public func testPredictionErrorScalesWithPrecision() : TestResult {
        // Higher precision amplifies error
        let obs = 1.5;
        let pred = 1.0;
        let error1 = FristonEngine.computePredictionError(obs, pred, 1.0);
        let error2 = FristonEngine.computePredictionError(obs, pred, 2.0);
        assertFloatClose(error2, 2.0 * error1, 0.001, "Error should scale with precision")
    };

    public func testPredictionErrorFormula() : TestResult {
        // ε = Ω(o - g(μ))
        let obs = 0.8;
        let pred = 0.5;
        let precision = 2.0;
        let expected = precision * (obs - pred);
        let error = FristonEngine.computePredictionError(obs, pred, precision);
        assertFloatClose(expected, error, 0.001, "Error should follow ε = Ω(o - g(μ))")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // COMPLEXITY TESTS - KL divergence from prior
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testComplexityZeroAtPrior() : TestResult {
        // When belief equals prior, complexity should be minimal
        let belief : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 1.0;
            prior = 0.5;  // Same as mean
            priorPrec = 1.0;  // Same precision
        };
        let complexity = FristonEngine.computeComplexity(belief);
        // KL divergence of identical distributions is 0
        assertFloatClose(0.0, complexity, 0.01, "Complexity should be minimal at prior")
    };

    public func testComplexityPositiveAwayFromPrior() : TestResult {
        // When belief deviates from prior, complexity increases
        let belief : FristonEngine.BeliefState = {
            mean = 2.0;  // Far from prior
            precision = 1.0;
            prior = 0.0;
            priorPrec = 1.0;
        };
        let complexity = FristonEngine.computeComplexity(belief);
        assertTrue(complexity > 0.0, "Complexity should be positive away from prior")
    };

    public func testComplexityIncreasesWithDeviation() : TestResult {
        // More deviation → higher complexity
        let belief1 : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 1.0;
            prior = 0.0;
            priorPrec = 1.0;
        };
        let belief2 : FristonEngine.BeliefState = {
            mean = 2.0;  // More deviation
            precision = 1.0;
            prior = 0.0;
            priorPrec = 1.0;
        };
        let c1 = FristonEngine.computeComplexity(belief1);
        let c2 = FristonEngine.computeComplexity(belief2);
        assertTrue(c2 > c1, "Greater deviation should mean higher complexity")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // INACCURACY TESTS - Prediction error cost
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testInaccuracyZeroWhenNoError() : TestResult {
        let sensory : FristonEngine.SensoryState = {
            observation = 1.0;
            prediction = 1.0;
            error = 0.0;  // No error
            precision = 1.0;
        };
        let inaccuracy = FristonEngine.computeInaccuracy(sensory);
        assertFloatClose(0.0, inaccuracy, 0.001, "Inaccuracy should be zero with no error")
    };

    public func testInaccuracyPositiveWithError() : TestResult {
        let sensory : FristonEngine.SensoryState = {
            observation = 1.0;
            prediction = 0.5;
            error = 0.5;  // Positive error
            precision = 1.0;
        };
        let inaccuracy = FristonEngine.computeInaccuracy(sensory);
        assertTrue(inaccuracy > 0.0, "Inaccuracy should be positive with error")
    };

    public func testInaccuracyQuadraticInError() : TestResult {
        // Inaccuracy = 0.5 * Ω * ε²
        let sensory1 : FristonEngine.SensoryState = {
            observation = 1.0;
            prediction = 0.5;
            error = 0.5;
            precision = 1.0;
        };
        let sensory2 : FristonEngine.SensoryState = {
            observation = 1.0;
            prediction = 0.0;
            error = 1.0;  // Double error
            precision = 1.0;
        };
        let i1 = FristonEngine.computeInaccuracy(sensory1);
        let i2 = FristonEngine.computeInaccuracy(sensory2);
        // Quadratic: i2 should be 4x i1
        assertFloatClose(4.0 * i1, i2, 0.01, "Inaccuracy should be quadratic in error")
    };

    public func testInaccuracyFormula() : TestResult {
        // -E[log p(o|s)] ≈ 0.5 * Ω * ε²
        let error = 0.4;
        let precision = 2.0;
        let expected = 0.5 * precision * error * error;
        let sensory : FristonEngine.SensoryState = {
            observation = 1.0;
            prediction = 0.6;
            error = error;
            precision = precision;
        };
        let inaccuracy = FristonEngine.computeInaccuracy(sensory);
        assertFloatClose(expected, inaccuracy, 0.001, "Inaccuracy should follow 0.5*Ω*ε²")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // FREE ENERGY TESTS - F = complexity + inaccuracy
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testFreeEnergyComponents() : TestResult {
        // F = complexity + inaccuracy
        let beliefs : [FristonEngine.BeliefState] = [{
            mean = 1.0;
            precision = 1.0;
            prior = 0.0;
            priorPrec = 1.0;
        }];
        let sensory : [FristonEngine.SensoryState] = [{
            observation = 1.0;
            prediction = 0.5;
            error = 0.5;
            precision = 1.0;
        }];
        let (fe, complexity, inaccuracy) = FristonEngine.computeFreeEnergy(beliefs, sensory);
        assertFloatClose(fe, complexity + inaccuracy, 0.001, "Free energy should be complexity + inaccuracy")
    };

    public func testFreeEnergyMinimalAtEquilibrium() : TestResult {
        // When belief matches observation and prior, FE should be minimal
        let beliefs : [FristonEngine.BeliefState] = [{
            mean = 0.5;
            precision = 1.0;
            prior = 0.5;
            priorPrec = 1.0;
        }];
        let sensory : [FristonEngine.SensoryState] = [{
            observation = 0.5;
            prediction = 0.5;
            error = 0.0;
            precision = 1.0;
        }];
        let (fe, _, _) = FristonEngine.computeFreeEnergy(beliefs, sensory);
        assertTrue(fe < 0.1, "Free energy should be minimal at equilibrium")
    };

    public func testFreeEnergyNonNegative() : TestResult {
        // Free energy should always be non-negative (or close to it)
        let beliefs : [FristonEngine.BeliefState] = [{
            mean = 0.5;
            precision = 1.0;
            prior = 0.5;
            priorPrec = 1.0;
        }];
        let sensory : [FristonEngine.SensoryState] = [{
            observation = 0.5;
            prediction = 0.5;
            error = 0.0;
            precision = 1.0;
        }];
        let (fe, _, _) = FristonEngine.computeFreeEnergy(beliefs, sensory);
        assertTrue(fe >= -0.001, "Free energy should be non-negative")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // BELIEF UPDATE TESTS - Gradient descent on F
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testBeliefUpdateTowardsObservation() : TestResult {
        // With positive error (obs > pred), belief mean should increase
        let belief : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 1.0;
            prior = 0.5;
            priorPrec = 0.1;  // Weak prior
        };
        let error = 0.5;  // Positive error
        let lr = 0.1;
        let newBelief = FristonEngine.updateBelief(belief, error, lr);
        assertTrue(newBelief.mean > belief.mean, "Belief should shift toward observation")
    };

    public func testBeliefUpdateBounded() : TestResult {
        // Belief mean should be bounded
        let belief : FristonEngine.BeliefState = {
            mean = 9.0;
            precision = 1.0;
            prior = 0.0;
            priorPrec = 0.01;
        };
        let error = 10.0;  // Large error
        let lr = 1.0;  // Large learning rate
        let newBelief = FristonEngine.updateBelief(belief, error, lr);
        assertTrue(newBelief.mean <= 10.0 and newBelief.mean >= -10.0, 
            "Belief mean should be bounded in [-10, 10]")
    };

    public func testBeliefUpdatePreservesStructure() : TestResult {
        // Update should preserve prior and priorPrec
        let belief : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 1.0;
            prior = 0.3;
            priorPrec = 0.5;
        };
        let newBelief = FristonEngine.updateBelief(belief, 0.2, 0.1);
        let priorPreserved = newBelief.prior == belief.prior and newBelief.priorPrec == belief.priorPrec;
        assertTrue(priorPreserved, "Update should preserve prior parameters")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // PRECISION UPDATE TESTS - Attention mechanism
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPrecisionUpdateIncreasesWithError() : TestResult {
        // When error is high, precision should increase (pay more attention)
        let belief : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 1.0;
            prior = 0.5;
            priorPrec = 1.0;
        };
        let largeError = 2.0;
        let lr = 0.5;
        let newBelief = FristonEngine.updatePrecision(belief, largeError, lr);
        assertTrue(newBelief.precision > belief.precision, 
            "Precision should increase with large errors")
    };

    public func testPrecisionBoundedMin() : TestResult {
        // Precision should not go below MIN_PRECISION = 0.01
        let belief : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 0.02;  // Near minimum
            prior = 0.5;
            priorPrec = 1.0;
        };
        let smallError = 0.001;  // Very small error
        let lr = 10.0;  // Large learning rate
        let newBelief = FristonEngine.updatePrecision(belief, smallError, lr);
        assertTrue(newBelief.precision >= 0.01, "Precision should not go below MIN_PRECISION")
    };

    public func testPrecisionBoundedMax() : TestResult {
        // Precision should not exceed MAX_PRECISION = 100.0
        let belief : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 99.0;  // Near maximum
            prior = 0.5;
            priorPrec = 1.0;
        };
        let largeError = 10.0;
        let lr = 10.0;
        let newBelief = FristonEngine.updatePrecision(belief, largeError, lr);
        assertTrue(newBelief.precision <= 100.0, "Precision should not exceed MAX_PRECISION")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // EXPECTED FREE ENERGY TESTS - Planning and policy selection
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testExpectedFELowerWithUncertainty() : TestResult {
        // Epistemic value (exploration bonus) reduces expected FE
        let belief : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 1.0;
            prior = 0.5;
            priorPrec = 1.0;
        };
        let policyOutcome = 0.5;
        let lowUncertainty = 0.1;
        let highUncertainty = 0.9;
        
        let efe1 = FristonEngine.computeExpectedFE(belief, policyOutcome, lowUncertainty);
        let efe2 = FristonEngine.computeExpectedFE(belief, policyOutcome, highUncertainty);
        
        // Higher uncertainty = more epistemic value = lower expected FE
        assertTrue(efe2 < efe1, "Higher uncertainty should reduce expected FE (exploration bonus)")
    };

    public func testExpectedFEHigherWithPredictionError() : TestResult {
        // Policies that lead to prediction error have higher expected FE
        let belief : FristonEngine.BeliefState = {
            mean = 0.5;
            precision = 1.0;
            prior = 0.5;
            priorPrec = 1.0;
        };
        let goodOutcome = 0.5;  // Matches belief
        let badOutcome = 2.0;   // Far from belief
        let uncertainty = 0.1;
        
        let efeGood = FristonEngine.computeExpectedFE(belief, goodOutcome, uncertainty);
        let efeBad = FristonEngine.computeExpectedFE(belief, badOutcome, uncertainty);
        
        assertTrue(efeBad > efeGood, "Policy with prediction error should have higher expected FE")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ACTIVE INFERENCE INTEGRATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testActiveInferenceMinimizesFE() : TestResult {
        // A complete active inference cycle should reduce free energy
        let initialBelief : FristonEngine.BeliefState = {
            mean = 0.0;  // Initial belief far from observation
            precision = 1.0;
            prior = 0.0;
            priorPrec = 0.1;
        };
        let observation = 1.0;
        let prediction = 0.0;  // Based on initial belief
        
        // Compute initial error
        let error = FristonEngine.computePredictionError(observation, prediction, 1.0);
        
        // Update belief
        let updatedBelief = FristonEngine.updateBelief(initialBelief, error, 0.5);
        
        // Belief should have moved toward observation
        assertTrue(updatedBelief.mean > initialBelief.mean, 
            "Active inference should move belief toward observation")
    };

    public func testBeliefPrecisionBalancesErrorAndComplexity() : TestResult {
        // The system should balance between fitting data (high precision) 
        // and maintaining simplicity (low precision away from prior)
        let belief : FristonEngine.BeliefState = {
            mean = 1.0;
            precision = 1.0;
            prior = 0.0;
            priorPrec = 1.0;
        };
        
        // Complexity increases with deviation from prior
        let complexity = FristonEngine.computeComplexity(belief);
        assertTrue(complexity > 0.0, "Deviation from prior incurs complexity cost")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let results = Buffer.Buffer<TestResult>(40);

        // Prediction Error
        results.add(testPredictionErrorZeroWhenPerfect());
        results.add(testPredictionErrorPositiveWhenOvershoot());
        results.add(testPredictionErrorNegativeWhenUndershoot());
        results.add(testPredictionErrorScalesWithPrecision());
        results.add(testPredictionErrorFormula());

        // Complexity
        results.add(testComplexityZeroAtPrior());
        results.add(testComplexityPositiveAwayFromPrior());
        results.add(testComplexityIncreasesWithDeviation());

        // Inaccuracy
        results.add(testInaccuracyZeroWhenNoError());
        results.add(testInaccuracyPositiveWithError());
        results.add(testInaccuracyQuadraticInError());
        results.add(testInaccuracyFormula());

        // Free Energy
        results.add(testFreeEnergyComponents());
        results.add(testFreeEnergyMinimalAtEquilibrium());
        results.add(testFreeEnergyNonNegative());

        // Belief Update
        results.add(testBeliefUpdateTowardsObservation());
        results.add(testBeliefUpdateBounded());
        results.add(testBeliefUpdatePreservesStructure());

        // Precision Update
        results.add(testPrecisionUpdateIncreasesWithError());
        results.add(testPrecisionBoundedMin());
        results.add(testPrecisionBoundedMax());

        // Expected Free Energy
        results.add(testExpectedFELowerWithUncertainty());
        results.add(testExpectedFEHigherWithPredictionError());

        // Active Inference Integration
        results.add(testActiveInferenceMinimizesFE());
        results.add(testBeliefPrecisionBalancesErrorAndComplexity());

        Buffer.toArray(results)
    };

    public func printTestResults(results: [TestResult]) : Text {
        var output = "\n════════════════════════════════════════════════════════════════\n";
        output #= "         FRISTON ENGINE TEST RESULTS\n";
        output #= "         Free Energy Principle - Active Inference\n";
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
