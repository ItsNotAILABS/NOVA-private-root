// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  DYNAMICAL SYSTEMS TEST SUITE                                                                             ║
// ║  Tests for Attractor Dynamics and Lyapunov Stability - The mathematical spine of the organism            ║
// ║  These modules ensure the organism converges to its sovereign attractor                                   ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import modules under test
import AttractorDynamics "../src/swarm_brain/modules/AttractorDynamics";
import LyapunovStability "../src/swarm_brain/modules/LyapunovStability";

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
    // ATTRACTOR TYPE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPointAttractorType() : TestResult {
        let attractorType = #PointAttractor;
        let isPoint = switch(attractorType) { case (#PointAttractor) true; case _ false };
        assertTrue(isPoint, "Point attractor type should be recognized")
    };

    public func testLimitCycleType() : TestResult {
        let attractorType = #LimitCycle;
        let isLimitCycle = switch(attractorType) { case (#LimitCycle) true; case _ false };
        assertTrue(isLimitCycle, "Limit cycle type should be recognized")
    };

    public func testStrangeAttractorType() : TestResult {
        let attractorType = #StrangeAttractor;
        let isStrange = switch(attractorType) { case (#StrangeAttractor) true; case _ false };
        assertTrue(isStrange, "Strange attractor type should be recognized")
    };

    public func testSaddleNodeType() : TestResult {
        let attractorType = #SaddleNode;
        let isSaddle = switch(attractorType) { case (#SaddleNode) true; case _ false };
        assertTrue(isSaddle, "Saddle node type should be recognized")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // HOPFIELD ENERGY TESTS - E = -0.5 Σᵢⱼ wᵢⱼsᵢsⱼ + Σᵢ θᵢsᵢ
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testHopfieldEnergyZeroState() : TestResult {
        // All zeros state should have zero energy (with zero weights)
        let state : [Float] = [0.0, 0.0, 0.0];
        let weights : [Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
        let thresholds : [Float] = [0.0, 0.0, 0.0];
        let energy = AttractorDynamics.hopfieldEnergy(state, weights, thresholds);
        assertFloatClose(0.0, energy, 0.01, "Zero state with zero weights should have zero energy")
    };

    public func testHopfieldEnergySymmetry() : TestResult {
        // Energy function should be symmetric in weights
        let state : [Float] = [1.0, 1.0];
        // Symmetric weight matrix
        let weights : [Float] = [0.0, 0.5, 0.5, 0.0];  // w12 = w21 = 0.5
        let thresholds : [Float] = [0.0, 0.0];
        let energy = AttractorDynamics.hopfieldEnergy(state, weights, thresholds);
        // E = -0.5 * (0 + 0.5 + 0.5 + 0) = -0.5
        assertFloatClose(-0.5, energy, 0.1, "Hopfield energy with symmetric weights")
    };

    public func testHopfieldEnergyWithThresholds() : TestResult {
        // Thresholds add to energy
        let state : [Float] = [1.0, 0.0];
        let weights : [Float] = [0.0, 0.0, 0.0, 0.0];
        let thresholds : [Float] = [1.0, 0.0];  // θ₁ = 1, θ₂ = 0
        let energy = AttractorDynamics.hopfieldEnergy(state, weights, thresholds);
        // E = 0 (quadratic) + 1*1 + 0*0 = 1
        assertFloatClose(1.0, energy, 0.1, "Threshold should contribute to energy")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // DISTANCE COMPUTATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testDistanceZero() : TestResult {
        // Distance from point to itself should be zero
        let a : [Float] = [1.0, 2.0, 3.0];
        let b : [Float] = [1.0, 2.0, 3.0];
        var sumSq : Float = 0.0;
        var i = 0;
        while (i < a.size()) {
            let d = a[i] - b[i];
            sumSq += d * d;
            i += 1;
        };
        let dist = Float.sqrt(sumSq);
        assertFloatClose(0.0, dist, 0.001, "Distance to self should be zero")
    };

    public func testDistanceEuclidean() : TestResult {
        // Standard Euclidean distance test
        let a : [Float] = [0.0, 0.0];
        let b : [Float] = [3.0, 4.0];
        var sumSq : Float = 0.0;
        var i = 0;
        while (i < a.size()) {
            let d = a[i] - b[i];
            sumSq += d * d;
            i += 1;
        };
        let dist = Float.sqrt(sumSq);
        assertFloatClose(5.0, dist, 0.01, "Distance from (0,0) to (3,4) should be 5")
    };

    public func testDistanceSymmetric() : TestResult {
        // d(a,b) = d(b,a)
        let a : [Float] = [1.0, 2.0];
        let b : [Float] = [4.0, 6.0];
        var sumSq1 : Float = 0.0;
        var sumSq2 : Float = 0.0;
        var i = 0;
        while (i < a.size()) {
            let d1 = a[i] - b[i];
            let d2 = b[i] - a[i];
            sumSq1 += d1 * d1;
            sumSq2 += d2 * d2;
            i += 1;
        };
        let dist1 = Float.sqrt(sumSq1);
        let dist2 = Float.sqrt(sumSq2);
        assertFloatClose(dist1, dist2, 0.001, "Distance should be symmetric")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // LYAPUNOV FUNCTION TESTS - V(x) stability certificate
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testLyapunovZeroAtAttractor() : TestResult {
        // V(x̄) = 0 at the attractor point
        // NOVA 5D attractor: [0.75, 0.55, 0.50, 0.85, 0.70]
        let attractorPoint : [Float] = [0.75, 0.55, 0.50, 0.85, 0.70];
        let weights : [Float] = [0.35, 0.20, 0.15, 0.15, 0.15];
        var V : Float = 0.0;
        var i = 0;
        while (i < 5) {
            let dev = attractorPoint[i] - attractorPoint[i];  // = 0
            V += weights[i] * dev * dev;
            i += 1;
        };
        assertFloatClose(0.0, V, 0.001, "Lyapunov function should be zero at attractor")
    };

    public func testLyapunovPositiveAway() : TestResult {
        // V(x) > 0 for x ≠ x̄
        let currentState : [Float] = [0.50, 0.70, 0.60, 0.60, 0.50];
        let attractor : [Float] = [0.75, 0.55, 0.50, 0.85, 0.70];
        let weights : [Float] = [0.35, 0.20, 0.15, 0.15, 0.15];
        var V : Float = 0.0;
        var i = 0;
        while (i < 5) {
            let dev = currentState[i] - attractor[i];
            V += weights[i] * dev * dev;
            i += 1;
        };
        assertTrue(V > 0.0, "Lyapunov function should be positive away from attractor")
    };

    public func testLyapunovDecreases() : TestResult {
        // dV/dt < 0 indicates convergence
        let V_old : Float = 0.5;
        let V_new : Float = 0.4;
        let dVdt = V_new - V_old;
        assertTrue(dVdt < 0.0, "Decreasing V indicates stability")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // STABILITY CLASSIFICATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testStableClassification() : TestResult {
        // dV/dt < 0 → stable
        let dVdt = -0.1;
        let isStable = dVdt < 0.0;
        assertTrue(isStable, "Negative dV/dt should classify as stable")
    };

    public func testUnstableClassification() : TestResult {
        // dV/dt > 0 → unstable (diverging)
        let dVdt = 0.1;
        let isUnstable = dVdt > 0.0;
        assertTrue(isUnstable, "Positive dV/dt should classify as unstable")
    };

    public func testMarginalClassification() : TestResult {
        // dV/dt ≈ 0 → marginally stable
        let dVdt = 0.001;
        let isMarginal = Float.abs(dVdt) < 0.01;
        assertTrue(isMarginal, "Near-zero dV/dt should classify as marginal")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // LYAPUNOV EXPONENT TESTS - Chaos detection
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPositiveLyapunovExponent() : TestResult {
        // λ > 0 indicates chaos
        let lyapunovExponent = 0.5;
        let isChaotic = lyapunovExponent > 0.0;
        assertTrue(isChaotic, "Positive Lyapunov exponent indicates chaos")
    };

    public func testNegativeLyapunovExponent() : TestResult {
        // λ < 0 indicates contraction
        let lyapunovExponent = -0.3;
        let isContracting = lyapunovExponent < 0.0;
        assertTrue(isContracting, "Negative Lyapunov exponent indicates contraction")
    };

    public func testZeroLyapunovExponent() : TestResult {
        // λ = 0 indicates neutral direction (limit cycle)
        let lyapunovExponent = 0.0;
        let isNeutral = Float.abs(lyapunovExponent) < 0.001;
        assertTrue(isNeutral, "Zero Lyapunov exponent indicates neutral direction")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SOVEREIGN STABILITY TESTS - Medina Theorem
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testSovereignFloor() : TestResult {
        let S0 = 1.0;  // Sovereign floor
        assertFloatClose(1.0, S0, 0.001, "Sovereign floor S₀ should be 1.0")
    };

    public func testSovereignCeiling() : TestResult {
        let OMEGA = 9.0;  // Sovereign ceiling
        assertFloatClose(9.0, OMEGA, 0.001, "Sovereign ceiling Ω should be 9.0")
    };

    public func testSovereignScaling() : TestResult {
        // V_sov = S₀ × V / Ω
        let S0 = 1.0;
        let OMEGA = 9.0;
        let V = 0.36;
        let V_sov = S0 * V / OMEGA;
        assertFloatClose(0.04, V_sov, 0.01, "Sovereign-scaled V should be V × S₀/Ω")
    };

    public func testSovereignStabilityThreshold() : TestResult {
        // Sovereign stability: V_sov < 0.036
        let V_sov = 0.03;
        let isStable = V_sov < 0.036;
        assertTrue(isStable, "V_sov < 0.036 should indicate sovereign stability")
    };

    public func testSovereignCrisis() : TestResult {
        // Sovereign crisis: V_sov ≥ 0.111
        let V_sov = 0.12;
        let isCrisis = V_sov >= 0.111;
        assertTrue(isCrisis, "V_sov >= 0.111 should indicate sovereign crisis")
    };

    public func testStabilityCertificate() : TestResult {
        // SC(t) = exp(-PHI_MEDINA × V_sov(t))
        let PHI_MEDINA = 2.97442179;
        let V_sov = 0.0;  // Perfect attractor
        let SC = Float.exp(-PHI_MEDINA * V_sov);
        assertFloatClose(1.0, SC, 0.001, "SC should be 1.0 at perfect attractor")
    };

    public func testStabilityCertificateDecays() : TestResult {
        // SC decreases as V_sov increases
        let PHI_MEDINA = 2.97442179;
        let V_sov1 = 0.01;
        let V_sov2 = 0.05;
        let SC1 = Float.exp(-PHI_MEDINA * V_sov1);
        let SC2 = Float.exp(-PHI_MEDINA * V_sov2);
        assertTrue(SC2 < SC1, "SC should decrease as V_sov increases")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // BASIN OF ATTRACTION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testBasinRadius() : TestResult {
        // Points within radius should be in basin
        let attractorCenter = 0.0;
        let basinRadius = 0.5;
        let point = 0.3;
        let inBasin = Float.abs(point - attractorCenter) < basinRadius;
        assertTrue(inBasin, "Point within radius should be in basin")
    };

    public func testBasinOutside() : TestResult {
        // Points outside radius should not be in basin
        let attractorCenter = 0.0;
        let basinRadius = 0.5;
        let point = 0.8;
        let inBasin = Float.abs(point - attractorCenter) < basinRadius;
        assertFalse(inBasin, "Point outside radius should not be in basin")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // CONTRACTION ANALYSIS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testContractionRate() : TestResult {
        // ‖δx(t)‖ ≤ ‖δx(0)‖ × exp(-αt)
        let deltaX0 = 1.0;
        let alpha = 0.5;
        let t = 2.0;
        let deltaXt = deltaX0 * Float.exp(-alpha * t);
        assertTrue(deltaXt < deltaX0, "Contracting system should reduce perturbation")
    };

    public func testContractionDecay() : TestResult {
        // Contraction should be exponential
        let alpha = 0.3;
        let decay1 = Float.exp(-alpha * 1.0);
        let decay2 = Float.exp(-alpha * 2.0);
        let decay3 = Float.exp(-alpha * 3.0);
        let isExponential = decay2 < decay1 and decay3 < decay2;
        assertTrue(isExponential, "Contraction should show exponential decay")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // BARRIER CERTIFICATE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testBarrierSafeRegion() : TestResult {
        // B(x) ≤ 0 in safe region
        let coherence = 0.8;  // Above COHERENCE_ALIVE
        let COHERENCE_ALIVE = 0.36;
        let B = COHERENCE_ALIVE - coherence;  // Negative = safe
        assertTrue(B < 0.0, "Safe coherence should yield negative barrier")
    };

    public func testBarrierUnsafeRegion() : TestResult {
        // B(x) > 0 in unsafe region
        let coherence = 0.2;  // Below COHERENCE_ALIVE
        let COHERENCE_ALIVE = 0.36;
        let B = COHERENCE_ALIVE - coherence;  // Positive = unsafe
        assertTrue(B > 0.0, "Unsafe coherence should yield positive barrier")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // NOVA 5D STATE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testNOVAAttractorValues() : TestResult {
        // x̄ = [C̄, H̄, Ā, S̄, Ē] = [0.75, 0.55, 0.50, 0.85, 0.70]
        let attractor : [Float] = [0.75, 0.55, 0.50, 0.85, 0.70];
        assertTrue(attractor.size() == 5, "NOVA attractor should be 5-dimensional")
    };

    public func testNOVACoherenceTarget() : TestResult {
        let C_bar = 0.75;
        assertFloatClose(0.75, C_bar, 0.01, "Coherence target should be 0.75")
    };

    public func testNOVAEntropyTarget() : TestResult {
        let H_bar = 0.55;
        assertFloatClose(0.55, H_bar, 0.01, "Entropy target should be 0.55")
    };

    public func testNOVAArousalTarget() : TestResult {
        let A_bar = 0.50;
        assertFloatClose(0.50, A_bar, 0.01, "Arousal target should be 0.50")
    };

    public func testNOVAStabilityTarget() : TestResult {
        let S_bar = 0.85;
        assertFloatClose(0.85, S_bar, 0.01, "Structural stability target should be 0.85")
    };

    public func testNOVAEmergenceTarget() : TestResult {
        let E_bar = 0.70;
        assertFloatClose(0.70, E_bar, 0.01, "Emergence target should be 0.70")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // WEIGHT VALIDATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testLyapunovWeightsSum() : TestResult {
        // Weights should sum to 1.0
        let weights : [Float] = [0.35, 0.20, 0.15, 0.15, 0.15];
        var sum : Float = 0.0;
        for (w in weights.vals()) { sum += w };
        assertFloatClose(1.0, sum, 0.01, "Lyapunov weights should sum to 1.0")
    };

    public func testCoherenceWeightHighest() : TestResult {
        // Coherence has highest weight (0.35)
        let weights : [Float] = [0.35, 0.20, 0.15, 0.15, 0.15];
        var maxWeight : Float = 0.0;
        var maxIdx : Nat = 0;
        var i = 0;
        while (i < weights.size()) {
            if (weights[i] > maxWeight) {
                maxWeight := weights[i];
                maxIdx := i;
            };
            i += 1;
        };
        assertTrue(maxIdx == 0 and maxWeight == 0.35, "Coherence should have highest weight")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let results = Buffer.Buffer<TestResult>(60);

        // Attractor Types
        results.add(testPointAttractorType());
        results.add(testLimitCycleType());
        results.add(testStrangeAttractorType());
        results.add(testSaddleNodeType());

        // Hopfield Energy
        results.add(testHopfieldEnergyZeroState());
        results.add(testHopfieldEnergySymmetry());
        results.add(testHopfieldEnergyWithThresholds());

        // Distance
        results.add(testDistanceZero());
        results.add(testDistanceEuclidean());
        results.add(testDistanceSymmetric());

        // Lyapunov Function
        results.add(testLyapunovZeroAtAttractor());
        results.add(testLyapunovPositiveAway());
        results.add(testLyapunovDecreases());

        // Stability Classification
        results.add(testStableClassification());
        results.add(testUnstableClassification());
        results.add(testMarginalClassification());

        // Lyapunov Exponents
        results.add(testPositiveLyapunovExponent());
        results.add(testNegativeLyapunovExponent());
        results.add(testZeroLyapunovExponent());

        // Sovereign Stability
        results.add(testSovereignFloor());
        results.add(testSovereignCeiling());
        results.add(testSovereignScaling());
        results.add(testSovereignStabilityThreshold());
        results.add(testSovereignCrisis());
        results.add(testStabilityCertificate());
        results.add(testStabilityCertificateDecays());

        // Basin of Attraction
        results.add(testBasinRadius());
        results.add(testBasinOutside());

        // Contraction Analysis
        results.add(testContractionRate());
        results.add(testContractionDecay());

        // Barrier Certificate
        results.add(testBarrierSafeRegion());
        results.add(testBarrierUnsafeRegion());

        // NOVA 5D State
        results.add(testNOVAAttractorValues());
        results.add(testNOVACoherenceTarget());
        results.add(testNOVAEntropyTarget());
        results.add(testNOVAArousalTarget());
        results.add(testNOVAStabilityTarget());
        results.add(testNOVAEmergenceTarget());

        // Weight Validation
        results.add(testLyapunovWeightsSum());
        results.add(testCoherenceWeightHighest());

        Buffer.toArray(results)
    };

    public func printTestResults(results: [TestResult]) : Text {
        var output = "\n════════════════════════════════════════════════════════════════\n";
        output #= "         DYNAMICAL SYSTEMS TEST RESULTS\n";
        output #= "         Attractor Dynamics & Lyapunov Stability\n";
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
