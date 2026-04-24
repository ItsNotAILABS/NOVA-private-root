// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  LYAPUNOV STABILITY TEST SUITE                                                                            ║
// ║  Nonlinear stability certification - ensuring organism converges to sovereignty                           ║
// ║  Tests V function, gradient, barrier certificates, ISS analysis, and stability classification             ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import the module under test
import LyapunovStability "../../src/swarm_brain/modules/LyapunovStability";

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
    // CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPhiMedinaConstant() : TestResult {
        // PHI_MEDINA should be approximately 2.97442179
        assertFloatClose(2.97442179, LyapunovStability.PHI_MEDINA, 0.0001, "PHI_MEDINA should be ~2.97442179")
    };

    public func testSovereignFloor() : TestResult {
        // S0 should be 1.0
        assertFloatClose(1.0, LyapunovStability.S0, 0.001, "S0 (sovereign floor) should be 1.0")
    };

    public func testCoherenceAlive() : TestResult {
        // COHERENCE_ALIVE should be 0.36
        assertFloatClose(0.36, LyapunovStability.COHERENCE_ALIVE, 0.001, "COHERENCE_ALIVE should be 0.36")
    };

    public func testTargetValues() : TestResult {
        // Verify target state values from attractor
        let c = LyapunovStability.TARGET_COHERENCE;   // 0.75
        let h = LyapunovStability.TARGET_ENTROPY;     // 0.55
        let a = LyapunovStability.TARGET_AROUSAL;     // 0.50
        let s = LyapunovStability.TARGET_STABILITY;   // 0.85
        let e = LyapunovStability.TARGET_EMERGENCE;   // 0.70
        
        assertTrue(
            c == 0.75 and h == 0.55 and a == 0.50 and s == 0.85 and e == 0.70,
            "Target state values should match attractor"
        )
    };

    public func testWeightsSumToOne() : TestResult {
        // Lyapunov weights should sum to 1.0
        let sum = LyapunovStability.W_COHERENCE + LyapunovStability.W_ENTROPY + 
                  LyapunovStability.W_AROUSAL + LyapunovStability.W_STABILITY + 
                  LyapunovStability.W_EMERGENCE;
        assertFloatClose(1.0, sum, 0.001, "Lyapunov weights should sum to 1.0")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // LYAPUNOV FUNCTION V(x) TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testVAtAttractor() : TestResult {
        // V(attractor) = 0
        let attractor : LyapunovStability.StateVec5 = {
            coherence = 0.75;
            entropy = 0.55;
            arousal = 0.50;
            stability = 0.85;
            emergence = 0.70;
        };
        let v = LyapunovStability.computeV(attractor, attractor);
        assertFloatClose(0.0, v, 0.01, "V should be near 0 at attractor")
    };

    public func testVPositiveAway() : TestResult {
        // V(x) > 0 for x ≠ attractor
        let state : LyapunovStability.StateVec5 = {
            coherence = 0.50;  // Different from target
            entropy = 0.60;
            arousal = 0.30;
            stability = 0.70;
            emergence = 0.50;
        };
        let target : LyapunovStability.StateVec5 = {
            coherence = 0.75;
            entropy = 0.55;
            arousal = 0.50;
            stability = 0.85;
            emergence = 0.70;
        };
        let v = LyapunovStability.computeV(state, target);
        assertTrue(v > 0.0, "V should be positive away from attractor")
    };

    public func testVIncreasesWithDistance() : TestResult {
        // V increases as state moves farther from attractor
        let target : LyapunovStability.StateVec5 = {
            coherence = 0.75;
            entropy = 0.55;
            arousal = 0.50;
            stability = 0.85;
            emergence = 0.70;
        };
        let near : LyapunovStability.StateVec5 = {
            coherence = 0.70;  // Close to target
            entropy = 0.55;
            arousal = 0.50;
            stability = 0.85;
            emergence = 0.70;
        };
        let far : LyapunovStability.StateVec5 = {
            coherence = 0.40;  // Far from target
            entropy = 0.55;
            arousal = 0.50;
            stability = 0.85;
            emergence = 0.70;
        };
        let vNear = LyapunovStability.computeV(near, target);
        let vFar = LyapunovStability.computeV(far, target);
        assertTrue(vFar > vNear, "V should increase with distance from attractor")
    };

    public func testVCrossCouplePenalty() : TestResult {
        // Low coherence + high entropy should add penalty
        let target : LyapunovStability.StateVec5 = {
            coherence = 0.75; entropy = 0.55; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let lowCHighH : LyapunovStability.StateVec5 = {
            coherence = 0.20; entropy = 0.90; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let normalCH : LyapunovStability.StateVec5 = {
            coherence = 0.20; entropy = 0.20; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let vBad = LyapunovStability.computeV(lowCHighH, target);
        let vNormal = LyapunovStability.computeV(normalCH, target);
        // Low C + High H should have higher V due to cross-coupling penalty
        assertTrue(vBad > vNormal, "Low coherence + high entropy should increase V (cross-coupling)")
    };

    public func testVBounded() : TestResult {
        // V should be clamped between 0 and 10
        let extreme : LyapunovStability.StateVec5 = {
            coherence = 0.0; entropy = 1.0; arousal = 1.0; stability = 0.0; emergence = 0.0;
        };
        let target : LyapunovStability.StateVec5 = {
            coherence = 0.75; entropy = 0.55; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let v = LyapunovStability.computeV(extreme, target);
        assertTrue(v >= 0.0 and v <= 10.0, "V should be bounded in [0, 10]")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SOVEREIGN V AND MEDINA CERTIFICATE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testSovereignVScaling() : TestResult {
        // V_sov = S₀ × V / Ω = 1.0 × V / 9.0
        let v = 0.9;
        let vSov = LyapunovStability.sovereignV(v);
        assertFloatClose(0.1, vSov, 0.01, "V_sov should be V/9 (with S₀=1, Ω=9)")
    };

    public func testSovereignVBounded() : TestResult {
        // V_sov should be clamped between 0 and 1
        let vSmall = LyapunovStability.sovereignV(0.0);
        let vLarge = LyapunovStability.sovereignV(100.0);
        assertTrue(vSmall >= 0.0 and vLarge <= 1.0, "V_sov should be bounded in [0, 1]")
    };

    public func testMedinaCertificateAtAttractor() : TestResult {
        // SC = exp(-Φ_M × V_sov) = exp(0) = 1 at attractor
        let sc = LyapunovStability.medinaStabilityCertificate(0.0);
        assertFloatClose(1.0, sc, 0.01, "Medina certificate should be 1.0 at attractor (V=0)")
    };

    public func testMedinaCertificateDecreases() : TestResult {
        // SC decreases as V increases
        let sc1 = LyapunovStability.medinaStabilityCertificate(0.5);
        let sc2 = LyapunovStability.medinaStabilityCertificate(2.0);
        assertTrue(sc1 > sc2, "Medina certificate should decrease as V increases")
    };

    public func testMedinaCertificateBounded() : TestResult {
        // SC ∈ (0, 1]
        let scMin = LyapunovStability.medinaStabilityCertificate(100.0);
        let scMax = LyapunovStability.medinaStabilityCertificate(0.0);
        assertTrue(scMin > 0.0 and scMax <= 1.0, "Medina certificate should be in (0, 1]")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // GRADIENT TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testGradientAtAttractor() : TestResult {
        // Gradient should be approximately zero at attractor
        let attractor : LyapunovStability.StateVec5 = {
            coherence = 0.75; entropy = 0.55; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let grad = LyapunovStability.computeGradV(attractor, attractor);
        let mag = LyapunovStability.gradMagnitude(grad);
        assertTrue(mag < 0.5, "Gradient magnitude should be small at attractor")
    };

    public func testGradientPointsToAttractor() : TestResult {
        // When C is below target, ∂V/∂C should be negative (V decreases as C increases toward target)
        let target : LyapunovStability.StateVec5 = {
            coherence = 0.75; entropy = 0.55; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let lowC : LyapunovStability.StateVec5 = {
            coherence = 0.50; entropy = 0.55; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let grad = LyapunovStability.computeGradV(lowC, target);
        // dV/dC should be negative when C < C_target (to decrease V by increasing C)
        assertTrue(grad.dC < 0.0, "dV/dC should be negative when coherence is below target")
    };

    public func testHessianDiagonal() : TestResult {
        // Hessian diagonal should be 2*w_i for each dimension
        let hess = LyapunovStability.hessianDiag();
        let expected = 2.0 * LyapunovStability.W_COHERENCE;
        assertFloatClose(expected, hess[0], 0.001, "Hessian diagonal should be 2*w for coherence")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // CONTRACTION ANALYSIS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testContractionRateDecreasing() : TestResult {
        // When V is decreasing (vdot < 0), contraction rate should be positive
        let alpha = LyapunovStability.estimateContractionRate(0.5, -0.05);
        assertTrue(alpha > 0.0, "Contraction rate should be positive when V is decreasing")
    };

    public func testContractionRateIncreasing() : TestResult {
        // When V is increasing (vdot > 0), contraction rate should be negative
        let alpha = LyapunovStability.estimateContractionRate(0.5, 0.05);
        assertTrue(alpha < 0.0, "Contraction rate should be negative when V is increasing")
    };

    public func testContractionRateBounded() : TestResult {
        // Contraction rate should be bounded in [-1, 1]
        let alphaBig = LyapunovStability.estimateContractionRate(0.001, -1.0);
        assertTrue(alphaBig <= 1.0 and alphaBig >= -1.0, "Contraction rate should be bounded")
    };

    public func testExponentialDecayRateHistory() : TestResult {
        // Decaying V history should give positive decay rate
        let vHist = Array.tabulate<Float>(20, func(i : Nat) : Float {
            1.0 * Float.exp(-0.1 * Float.fromInt(i))  // Exponential decay
        });
        let alpha = LyapunovStability.exponentialDecayRate(vHist);
        assertTrue(alpha > 0.0, "Exponential decay rate should be positive for decaying history")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // BARRIER CERTIFICATE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testBarrierSafeState() : TestResult {
        // Safe state: high coherence, low entropy
        let safe : LyapunovStability.StateVec5 = {
            coherence = 0.80; entropy = 0.40; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let barrier = LyapunovStability.computeBarrier(safe);
        assertTrue(barrier.isSafe, "High coherence state should be safe")
    };

    public func testBarrierUnsafeLowCoherence() : TestResult {
        // Unsafe: coherence below COHERENCE_ALIVE (0.36)
        let unsafe : LyapunovStability.StateVec5 = {
            coherence = 0.20; entropy = 0.50; arousal = 0.50; stability = 0.50; emergence = 0.50;
        };
        let barrier = LyapunovStability.computeBarrier(unsafe);
        assertFalse(barrier.isSafe, "Low coherence state should be unsafe (below COHERENCE_ALIVE)")
    };

    public func testBarrierUnsafeHighEntropy() : TestResult {
        // Unsafe: entropy above H_CRIT (0.90)
        let unsafe : LyapunovStability.StateVec5 = {
            coherence = 0.80; entropy = 0.95; arousal = 0.50; stability = 0.50; emergence = 0.50;
        };
        let barrier = LyapunovStability.computeBarrier(unsafe);
        assertFalse(barrier.isSafe, "High entropy state should be unsafe (above H_CRIT)")
    };

    public func testBarrierMarginPositive() : TestResult {
        // Margin to unsafe should always be non-negative
        let state : LyapunovStability.StateVec5 = {
            coherence = 0.50; entropy = 0.60; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let barrier = LyapunovStability.computeBarrier(state);
        assertTrue(barrier.marginToUnsafe >= 0.0, "Margin to unsafe should be non-negative")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ISS (INPUT-TO-STATE STABILITY) TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testISSNoDisturbance() : TestResult {
        // With no disturbance, system should be ISS
        let state : LyapunovStability.StateVec5 = {
            coherence = 0.50; entropy = 0.60; arousal = 0.40; stability = 0.75; emergence = 0.60;
        };
        let target : LyapunovStability.StateVec5 = {
            coherence = 0.75; entropy = 0.55; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let iss = LyapunovStability.computeISS(state, target, 0.0);
        assertTrue(iss.isISS, "System should be ISS with no disturbance")
    };

    public func testISSSmallDisturbance() : TestResult {
        // Small disturbance should still be ISS
        let state : LyapunovStability.StateVec5 = {
            coherence = 0.60; entropy = 0.58; arousal = 0.45; stability = 0.80; emergence = 0.68;
        };
        let target : LyapunovStability.StateVec5 = {
            coherence = 0.75; entropy = 0.55; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let iss = LyapunovStability.computeISS(state, target, 0.1);
        assertTrue(iss.isISS, "System should be ISS with small disturbance")
    };

    public func testISSMarginDecreases() : TestResult {
        // ISS margin should decrease with larger disturbance
        let state : LyapunovStability.StateVec5 = {
            coherence = 0.60; entropy = 0.60; arousal = 0.50; stability = 0.80; emergence = 0.65;
        };
        let target : LyapunovStability.StateVec5 = {
            coherence = 0.75; entropy = 0.55; arousal = 0.50; stability = 0.85; emergence = 0.70;
        };
        let issSmall = LyapunovStability.computeISS(state, target, 0.1);
        let issLarge = LyapunovStability.computeISS(state, target, 0.5);
        assertTrue(issSmall.issMargin > issLarge.issMargin, "ISS margin should decrease with larger disturbance")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // STABILITY CLASSIFICATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testClassifyAsymptoticStable() : TestResult {
        // Low V, negative Vdot, many stable beats → asymptotic stable
        let vHist = Array.tabulate<Float>(25, func(i : Nat) : Float { 0.03 });
        let stability = LyapunovStability.classifyStability(0.03, -0.001, 15, 0, vHist);
        assertTrue(stability == #AsymptoticStable, "Should classify as asymptotically stable")
    };

    public func testClassifyExponentialStable() : TestResult {
        // Low V, strong negative Vdot, many stable beats → exponential stable
        let vHist = Array.tabulate<Float>(25, func(i : Nat) : Float { 0.02 });
        let stability = LyapunovStability.classifyStability(0.02, -0.01, 25, 0, vHist);
        assertTrue(stability == #ExponentialStable, "Should classify as exponentially stable")
    };

    public func testClassifyUnstable() : TestResult {
        // High V or many unstable beats → unstable
        let vHist = Array.tabulate<Float>(20, func(i : Nat) : Float { 0.5 });
        let stability = LyapunovStability.classifyStability(0.5, 0.01, 0, 20, vHist);
        assertTrue(stability == #Unstable, "Should classify as unstable")
    };

    public func testClassifySovereignCrisis() : TestResult {
        // V > V_CRISIS_THRESH (0.80) → sovereign crisis
        let vHist = Array.tabulate<Float>(5, func(i : Nat) : Float { 0.85 });
        let stability = LyapunovStability.classifyStability(0.85, 0.01, 0, 5, vHist);
        assertTrue(stability == #SovereignCrisis, "Should classify as sovereign crisis")
    };

    public func testClassifyMarginallyStable() : TestResult {
        // Default case
        let vHist = Array.tabulate<Float>(15, func(i : Nat) : Float { 0.10 });
        let stability = LyapunovStability.classifyStability(0.10, -0.0001, 5, 2, vHist);
        assertTrue(stability == #MarginallyStable, "Should classify as marginally stable")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let buffer = Buffer.Buffer<TestResult>(40);
        
        // Constants tests
        buffer.add(testPhiMedinaConstant());
        buffer.add(testSovereignFloor());
        buffer.add(testCoherenceAlive());
        buffer.add(testTargetValues());
        buffer.add(testWeightsSumToOne());
        
        // Lyapunov function V tests
        buffer.add(testVAtAttractor());
        buffer.add(testVPositiveAway());
        buffer.add(testVIncreasesWithDistance());
        buffer.add(testVCrossCouplePenalty());
        buffer.add(testVBounded());
        
        // Sovereign V and Medina certificate tests
        buffer.add(testSovereignVScaling());
        buffer.add(testSovereignVBounded());
        buffer.add(testMedinaCertificateAtAttractor());
        buffer.add(testMedinaCertificateDecreases());
        buffer.add(testMedinaCertificateBounded());
        
        // Gradient tests
        buffer.add(testGradientAtAttractor());
        buffer.add(testGradientPointsToAttractor());
        buffer.add(testHessianDiagonal());
        
        // Contraction analysis tests
        buffer.add(testContractionRateDecreasing());
        buffer.add(testContractionRateIncreasing());
        buffer.add(testContractionRateBounded());
        buffer.add(testExponentialDecayRateHistory());
        
        // Barrier certificate tests
        buffer.add(testBarrierSafeState());
        buffer.add(testBarrierUnsafeLowCoherence());
        buffer.add(testBarrierUnsafeHighEntropy());
        buffer.add(testBarrierMarginPositive());
        
        // ISS tests
        buffer.add(testISSNoDisturbance());
        buffer.add(testISSSmallDisturbance());
        buffer.add(testISSMarginDecreases());
        
        // Stability classification tests
        buffer.add(testClassifyAsymptoticStable());
        buffer.add(testClassifyExponentialStable());
        buffer.add(testClassifyUnstable());
        buffer.add(testClassifySovereignCrisis());
        buffer.add(testClassifyMarginallyStable());
        
        Buffer.toArray(buffer)
    };
}
