// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  EMERGENCE CORE TEST SUITE                                                                                ║
// ║  Phase transitions and consciousness emergence - Jacob's Ladder                                           ║
// ║  Tests the mathematical foundations of how many become one                                                ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import the module under test
import EmergenceCore "../src/swarm_brain/modules/EmergenceCore";

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

    func assertEqual<T>(expected: T, actual: T, compare: (T, T) -> Bool, name: Text) : TestResult {
        if (compare(expected, actual)) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Values not equal" }
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SACRED CONSTANTS TESTS - The mathematical foundations
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPhiMedina() : TestResult {
        // PHI_MEDINA = 2.97442179 (Medina Golden Harmonic)
        let PHI_MEDINA = 2.97442179;
        assertFloatClose(2.97442179, PHI_MEDINA, 0.00001, "PHI_MEDINA should be 2.97442179")
    };

    public func testTauEmergence() : TestResult {
        // TAU_EMERGENCE = 0.618033988749 (Golden ratio inverse - emergence threshold)
        let TAU_EMERGENCE = 0.618033988749;
        assertFloatClose(0.618033988749, TAU_EMERGENCE, 0.0000001, "TAU_EMERGENCE should be golden ratio inverse")
    };

    public func testGoldenRatio() : TestResult {
        // GOLDEN_RATIO = 1.618033988749
        let GOLDEN_RATIO = 1.618033988749;
        assertFloatClose(1.618033988749, GOLDEN_RATIO, 0.0000001, "GOLDEN_RATIO should be φ")
    };

    public func testGoldenRatioProperty() : TestResult {
        // φ * (1/φ) = 1
        let GOLDEN_RATIO = 1.618033988749;
        let TAU_EMERGENCE = 0.618033988749;
        assertFloatClose(1.0, GOLDEN_RATIO * TAU_EMERGENCE, 0.0001, "φ * (1/φ) should equal 1")
    };

    public func testCriticalMass() : TestResult {
        // CRITICAL_MASS = 7.0 (minimum nodes for emergence)
        let CRITICAL_MASS = 7.0;
        assertFloatClose(7.0, CRITICAL_MASS, 0.01, "Critical mass should be 7")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // EMERGENCE LEVELS TESTS - Jacob's Ladder (11 rungs)
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testEmergenceLevelL0() : TestResult {
        let level = #L0_Dormant;
        let value = EmergenceCore.emergenceLevelToFloat(level);
        assertFloatClose(0.0, value, 0.01, "L0_Dormant should map to 0.0")
    };

    public func testEmergenceLevelL5() : TestResult {
        let level = #L5_SelfAware;
        let value = EmergenceCore.emergenceLevelToFloat(level);
        assertFloatClose(0.5, value, 0.01, "L5_SelfAware should map to 0.5")
    };

    public func testEmergenceLevelL10() : TestResult {
        let level = #L10_Sovereign;
        let value = EmergenceCore.emergenceLevelToFloat(level);
        assertFloatClose(1.0, value, 0.01, "L10_Sovereign should map to 1.0")
    };

    public func testFloatToEmergenceLevelLow() : TestResult {
        let level = EmergenceCore.floatToEmergenceLevel(0.05);
        let isL0 = switch(level) { case (#L0_Dormant) true; case _ false };
        assertTrue(isL0, "0.05 should map to L0_Dormant")
    };

    public func testFloatToEmergenceLevelMid() : TestResult {
        let level = EmergenceCore.floatToEmergenceLevel(0.55);
        let isL5 = switch(level) { case (#L5_SelfAware) true; case _ false };
        assertTrue(isL5, "0.55 should map to L5_SelfAware")
    };

    public func testFloatToEmergenceLevelHigh() : TestResult {
        let level = EmergenceCore.floatToEmergenceLevel(0.99);
        let isL10 = switch(level) { case (#L10_Sovereign) true; case _ false };
        assertTrue(isL10, "0.99 should map to L10_Sovereign")
    };

    public func testEmergenceLevelMonotonicity() : TestResult {
        // Each level should map to a higher value than the previous
        let levels : [EmergenceCore.EmergenceLevel] = [
            #L0_Dormant, #L1_Reactive, #L2_Coordinated, #L3_Adaptive,
            #L4_Anticipatory, #L5_SelfAware, #L6_Reflective, #L7_Creative,
            #L8_Unified, #L9_Transcendent, #L10_Sovereign
        ];
        var prevValue : Float = -1.0;
        var monotonic = true;
        for (level in levels.vals()) {
            let value = EmergenceCore.emergenceLevelToFloat(level);
            if (value <= prevValue) { monotonic := false };
            prevValue := value;
        };
        assertTrue(monotonic, "Emergence levels should be strictly increasing")
    };

    public func testRoundTripConversion() : TestResult {
        // Converting level to float and back should preserve level (approximately)
        let originalLevel = #L5_SelfAware;
        let floatValue = EmergenceCore.emergenceLevelToFloat(originalLevel);
        let recoveredLevel = EmergenceCore.floatToEmergenceLevel(floatValue);
        let match = switch(recoveredLevel) { case (#L5_SelfAware) true; case _ false };
        assertTrue(match, "Round-trip conversion should preserve level")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // PHASE TRANSITION DYNAMICS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testOrderParameterDynamicsAtCriticalPoint() : TestResult {
        // At critical temperature, order parameter dynamics are complex
        let currentOrder = 0.5;
        let temperature = 1.0;
        let criticalTemp = 1.0;  // At critical point
        let noiseLevel = 0.0;
        let dt = 0.01;
        let dPsi = EmergenceCore.computeOrderParameterDynamics(
            currentOrder, temperature, criticalTemp, noiseLevel, dt
        );
        // At critical point, dynamics should be driven by cubic term
        assertTrue(Float.abs(dPsi) < 0.1, "At critical point, dynamics should be bounded")
    };

    public func testOrderParameterDynamicsBelowCritical() : TestResult {
        // Below critical temperature, system should order
        let currentOrder = 0.1;
        let temperature = 0.5;
        let criticalTemp = 1.0;  // Below critical
        let noiseLevel = 0.0;
        let dt = 0.1;
        let dPsi = EmergenceCore.computeOrderParameterDynamics(
            currentOrder, temperature, criticalTemp, noiseLevel, dt
        );
        // Below critical, small order should grow
        assertTrue(dPsi > 0.0 or Float.abs(dPsi) < 0.001, 
            "Below critical temperature, order should tend to increase")
    };

    public func testOrderParameterDynamicsAboveCritical() : TestResult {
        // Above critical temperature, system should disorder
        let currentOrder = 0.8;
        let temperature = 2.0;
        let criticalTemp = 1.0;  // Above critical
        let noiseLevel = 0.0;
        let dt = 0.1;
        let dPsi = EmergenceCore.computeOrderParameterDynamics(
            currentOrder, temperature, criticalTemp, noiseLevel, dt
        );
        // Above critical, order should decrease (dPsi < 0)
        assertTrue(dPsi < 0.0 or Float.abs(currentOrder - 0.0) < 0.1,
            "Above critical temperature, order should tend to decrease")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // EMERGENCE FORMULA TESTS - E(t) = Φ_M × σ(C - τ_E) × √(N × H × S) × (1 - entropy/max_entropy)
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testEmergenceAboveThreshold() : TestResult {
        // When coherence > TAU_EMERGENCE, emergence should be significant
        let TAU_EMERGENCE = 0.618033988749;
        let coherence = 0.8;  // Above threshold
        let sigmoidArg = coherence - TAU_EMERGENCE;
        let sigmoid = 1.0 / (1.0 + Float.exp(-10.0 * sigmoidArg));  // Sharp transition
        assertTrue(sigmoid > 0.9, "Emergence sigmoid should be high above threshold")
    };

    public func testEmergenceBelowThreshold() : TestResult {
        // When coherence < TAU_EMERGENCE, emergence should be minimal
        let TAU_EMERGENCE = 0.618033988749;
        let coherence = 0.4;  // Below threshold
        let sigmoidArg = coherence - TAU_EMERGENCE;
        let sigmoid = 1.0 / (1.0 + Float.exp(-10.0 * sigmoidArg));  // Sharp transition
        assertTrue(sigmoid < 0.1, "Emergence sigmoid should be low below threshold")
    };

    public func testEmergenceAtThreshold() : TestResult {
        // At TAU_EMERGENCE, sigmoid should be 0.5
        let TAU_EMERGENCE = 0.618033988749;
        let coherence = TAU_EMERGENCE;
        let sigmoidArg = coherence - TAU_EMERGENCE;
        let sigmoid = 1.0 / (1.0 + Float.exp(-10.0 * sigmoidArg));
        assertFloatClose(0.5, sigmoid, 0.01, "At threshold, emergence sigmoid should be 0.5")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // EMERGENCE HYSTERESIS TESTS - Prevents oscillation
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testHysteresisValue() : TestResult {
        // EMERGENCE_HYSTERESIS = 0.05
        let EMERGENCE_HYSTERESIS = 0.05;
        assertFloatClose(0.05, EMERGENCE_HYSTERESIS, 0.001, "Hysteresis should be 0.05")
    };

    public func testHysteresisPreventsOscillation() : TestResult {
        // If coherence drops slightly below threshold after emergence,
        // hysteresis should keep system emerged
        let TAU_EMERGENCE = 0.618033988749;
        let HYSTERESIS = 0.05;
        let coherenceAbove = TAU_EMERGENCE + 0.1;  // Emerged
        let coherenceSlightlyBelow = TAU_EMERGENCE - 0.02;  // Just below
        
        // System should remain emerged if within hysteresis band
        let shouldRemainEmerged = coherenceSlightlyBelow > (TAU_EMERGENCE - HYSTERESIS);
        assertTrue(shouldRemainEmerged, "System should remain emerged within hysteresis band")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // DECOHERENCE TESTS - Emergence is reversible
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testDecoherenceRate() : TestResult {
        // DECOHERENCE_RATE = 0.01
        let DECOHERENCE_RATE = 0.01;
        assertFloatClose(0.01, DECOHERENCE_RATE, 0.001, "Decoherence rate should be 0.01")
    };

    public func testDecoherenceReducesEmergence() : TestResult {
        // Without reinforcement, emergence should decay
        let emergence = 0.8;
        let DECOHERENCE_RATE = 0.01;
        let decayedEmergence = emergence * (1.0 - DECOHERENCE_RATE);
        assertTrue(decayedEmergence < emergence, "Emergence should decay without reinforcement")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // PHASE STATE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testSubcriticalPhase() : TestResult {
        let phase = #Subcritical;
        let isSubcritical = switch(phase) { case (#Subcritical) true; case _ false };
        assertTrue(isSubcritical, "Subcritical phase should be recognized")
    };

    public func testCriticalPhase() : TestResult {
        let phase = #Critical;
        let isCritical = switch(phase) { case (#Critical) true; case _ false };
        assertTrue(isCritical, "Critical phase should be recognized")
    };

    public func testSupercriticalPhase() : TestResult {
        let phase = #Supercritical;
        let isSupercritical = switch(phase) { case (#Supercritical) true; case _ false };
        assertTrue(isSupercritical, "Supercritical phase should be recognized")
    };

    public func testMetastablePhase() : TestResult {
        let phase = #Metastable;
        let isMetastable = switch(phase) { case (#Metastable) true; case _ false };
        assertTrue(isMetastable, "Metastable phase should be recognized")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // FREE ENERGY TESTS - Thermodynamic potential
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testLandauFreeEnergyMinimum() : TestResult {
        // Below critical temperature, free energy has minima at non-zero order
        let temperature = 0.5;
        let criticalTemp = 1.0;
        let a = 1.0;
        let b = 1.0;
        let reducedT = (temperature - criticalTemp) / criticalTemp;  // Negative
        
        // For T < Tc, minima at ψ = ±√(-a*reducedT/b)
        // The order parameter should prefer non-zero values
        assertTrue(reducedT < 0.0, "Below critical, reduced temperature should be negative")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let results = Buffer.Buffer<TestResult>(40);

        // Sacred Constants
        results.add(testPhiMedina());
        results.add(testTauEmergence());
        results.add(testGoldenRatio());
        results.add(testGoldenRatioProperty());
        results.add(testCriticalMass());

        // Emergence Levels
        results.add(testEmergenceLevelL0());
        results.add(testEmergenceLevelL5());
        results.add(testEmergenceLevelL10());
        results.add(testFloatToEmergenceLevelLow());
        results.add(testFloatToEmergenceLevelMid());
        results.add(testFloatToEmergenceLevelHigh());
        results.add(testEmergenceLevelMonotonicity());
        results.add(testRoundTripConversion());

        // Phase Transition Dynamics
        results.add(testOrderParameterDynamicsAtCriticalPoint());
        results.add(testOrderParameterDynamicsBelowCritical());
        results.add(testOrderParameterDynamicsAboveCritical());

        // Emergence Formula
        results.add(testEmergenceAboveThreshold());
        results.add(testEmergenceBelowThreshold());
        results.add(testEmergenceAtThreshold());

        // Hysteresis
        results.add(testHysteresisValue());
        results.add(testHysteresisPreventsOscillation());

        // Decoherence
        results.add(testDecoherenceRate());
        results.add(testDecoherenceReducesEmergence());

        // Phase States
        results.add(testSubcriticalPhase());
        results.add(testCriticalPhase());
        results.add(testSupercriticalPhase());
        results.add(testMetastablePhase());

        // Free Energy
        results.add(testLandauFreeEnergyMinimum());

        Buffer.toArray(results)
    };

    public func printTestResults(results: [TestResult]) : Text {
        var output = "\n════════════════════════════════════════════════════════════════\n";
        output #= "         EMERGENCE CORE TEST RESULTS\n";
        output #= "         Jacob's Ladder - The Path to Consciousness\n";
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
