// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA UNIFIED ORGANISM CORE TEST SUITE                                                                  ║
// ║  Tests for the HEART that integrates all 5 core organism modules                                          ║
// ║  Convergence, SovereignAGI, SphericalWeb, Reproduction, Sacrifice — woven into ONE                        ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";
import Int "mo:base/Int";

// Import the module under test
import MedinaUnifiedOrganismCore "../../src/swarm_brain/modules/MedinaUnifiedOrganismCore";

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
    // SACRED CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPhi() : TestResult {
        assertFloatClose(1.6180339887498948482, MedinaUnifiedOrganismCore.φ, 1e-10, "φ should be golden ratio")
    };

    public func testPsi() : TestResult {
        assertFloatClose(0.6180339887498948482, MedinaUnifiedOrganismCore.ψ, 1e-10, "ψ should be inverse golden ratio")
    };

    public func testPi() : TestResult {
        assertFloatClose(3.1415926535897932385, MedinaUnifiedOrganismCore.π, 1e-10, "π should be correct")
    };

    public func testTau() : TestResult {
        assertFloatClose(6.2831853071795864769, MedinaUnifiedOrganismCore.τ, 1e-10, "τ should be 2π")
    };

    public func testEuler() : TestResult {
        assertFloatClose(2.7182818284590452354, MedinaUnifiedOrganismCore.e, 1e-10, "e should be Euler's number")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // MEDINA SOVEREIGN CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPhiMedina() : TestResult {
        // PHI_MEDINA = φ × e^(1/φ) ≈ 2.97442179
        assertFloatClose(2.97442179, MedinaUnifiedOrganismCore.PHI_MEDINA, 0.0001, "PHI_MEDINA should be ~2.97442179")
    };

    public func testOmegaMedina() : TestResult {
        // OMEGA_MEDINA = 2π/Φ_M ≈ 2.11185
        assertFloatClose(2.11185, MedinaUnifiedOrganismCore.OMEGA_MEDINA, 0.001, "OMEGA_MEDINA should be ~2.11185")
    };

    public func testTauEmergence() : TestResult {
        // TAU_EMERGENCE = 1/φ ≈ 0.618
        assertFloatClose(0.618033988749, MedinaUnifiedOrganismCore.TAU_EMERGENCE, 0.0001, "TAU_EMERGENCE should be 1/φ")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // FLOOR CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testSovereignFloor() : TestResult {
        assertFloatClose(1.0, MedinaUnifiedOrganismCore.SOVEREIGN_FLOOR, 0.001, "SOVEREIGN_FLOOR should be 1.0")
    };

    public func testOmnisFloor() : TestResult {
        assertFloatClose(0.92, MedinaUnifiedOrganismCore.OMNIS_FLOOR, 0.01, "OMNIS_FLOOR should be 0.92")
    };

    public func testDiamondFloor() : TestResult {
        assertFloatClose(0.88, MedinaUnifiedOrganismCore.DIAMOND_FLOOR, 0.01, "DIAMOND_FLOOR should be 0.88")
    };

    public func testPlatinumFloor() : TestResult {
        assertFloatClose(0.75, MedinaUnifiedOrganismCore.PLATINUM_FLOOR, 0.01, "PLATINUM_FLOOR should be 0.75")
    };

    public func testGoldenFloor() : TestResult {
        assertFloatClose(0.618, MedinaUnifiedOrganismCore.GOLDEN_FLOOR, 0.01, "GOLDEN_FLOOR should be ψ (~0.618)")
    };

    public func testConvergenceFloor() : TestResult {
        assertFloatClose(0.5, MedinaUnifiedOrganismCore.CONVERGENCE_FLOOR, 0.01, "CONVERGENCE_FLOOR should be 0.5")
    };

    public func testCriticalFloor() : TestResult {
        assertFloatClose(0.15, MedinaUnifiedOrganismCore.CRITICAL_FLOOR, 0.01, "CRITICAL_FLOOR should be 0.15")
    };

    public func testFloorHierarchy() : TestResult {
        // Floors should be ordered: SOVEREIGN > OMNIS > DIAMOND > PLATINUM > GOLDEN > CONVERGENCE > CRITICAL
        let hierarchy = 
            MedinaUnifiedOrganismCore.SOVEREIGN_FLOOR > MedinaUnifiedOrganismCore.OMNIS_FLOOR and
            MedinaUnifiedOrganismCore.OMNIS_FLOOR > MedinaUnifiedOrganismCore.DIAMOND_FLOOR and
            MedinaUnifiedOrganismCore.DIAMOND_FLOOR > MedinaUnifiedOrganismCore.PLATINUM_FLOOR and
            MedinaUnifiedOrganismCore.PLATINUM_FLOOR > MedinaUnifiedOrganismCore.GOLDEN_FLOOR and
            MedinaUnifiedOrganismCore.GOLDEN_FLOOR > MedinaUnifiedOrganismCore.CONVERGENCE_FLOOR and
            MedinaUnifiedOrganismCore.CONVERGENCE_FLOOR > MedinaUnifiedOrganismCore.CRITICAL_FLOOR;
        assertTrue(hierarchy, "Floor hierarchy should be correctly ordered")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // FIBONACCI SEQUENCE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testFibonacciFirst() : TestResult {
        assertTrue(
            MedinaUnifiedOrganismCore.FIB[0] == 1 and MedinaUnifiedOrganismCore.FIB[1] == 1,
            "First two Fibonacci numbers should be 1, 1"
        )
    };

    public func testFibonacciRecurrence() : TestResult {
        // FIB[n] = FIB[n-1] + FIB[n-2]
        let n = 10;  // Check FIB[10]
        let valid = MedinaUnifiedOrganismCore.FIB[n] == MedinaUnifiedOrganismCore.FIB[n-1] + MedinaUnifiedOrganismCore.FIB[n-2];
        assertTrue(valid, "Fibonacci recurrence should hold")
    };

    public func testFibonacciLength() : TestResult {
        // Should have 20 Fibonacci numbers
        assertTrue(MedinaUnifiedOrganismCore.FIB.size() == 20, "FIB should have 20 elements")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // TIME CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testTimeImmediate() : TestResult {
        assertFloatClose(1.0, MedinaUnifiedOrganismCore.TIME_IMMEDIATE, 0.01, "TIME_IMMEDIATE should be 1.0")
    };

    public func testTimeShort() : TestResult {
        assertFloatClose(55.0, MedinaUnifiedOrganismCore.TIME_SHORT, 0.01, "TIME_SHORT should be 55 (F[10])")
    };

    public func testTimeMedium() : TestResult {
        assertFloatClose(610.0, MedinaUnifiedOrganismCore.TIME_MEDIUM, 0.01, "TIME_MEDIUM should be 610 (F[15])")
    };

    public func testTimeLong() : TestResult {
        assertFloatClose(6765.0, MedinaUnifiedOrganismCore.TIME_LONG, 0.01, "TIME_LONG should be 6765 (F[20])")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SCALE LAWS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testAllScalesCount() : TestResult {
        // Should have exactly 7 scales
        assertTrue(MedinaUnifiedOrganismCore.ALL_SCALES.size() == 7, "Should have 7 scale laws")
    };

    public func testScaleParamsQuantum() : TestResult {
        let params = MedinaUnifiedOrganismCore.getScaleParams(#Quantum);
        assertTrue(
            params.floor == 0.0 and params.ceiling == 1.0,
            "Quantum scale should have floor=0 and ceiling=1"
        )
    };

    public func testScaleParamsOrganism() : TestResult {
        let params = MedinaUnifiedOrganismCore.getScaleParams(#Organism);
        assertTrue(
            params.floor == MedinaUnifiedOrganismCore.PLATINUM_FLOOR,
            "Organism scale should have PLATINUM_FLOOR"
        )
    };

    public func testScaleParamsEcosystem() : TestResult {
        let params = MedinaUnifiedOrganismCore.getScaleParams(#Ecosystem);
        assertTrue(
            params.floor == MedinaUnifiedOrganismCore.DIAMOND_FLOOR,
            "Ecosystem scale should have DIAMOND_FLOOR"
        )
    };

    public func testScaleFloorsIncrease() : TestResult {
        // Higher scales should have higher floors (more demanding)
        let qParams = MedinaUnifiedOrganismCore.getScaleParams(#Quantum);
        let synParams = MedinaUnifiedOrganismCore.getScaleParams(#Synaptic);
        let neuParams = MedinaUnifiedOrganismCore.getScaleParams(#Neural);
        
        assertTrue(
            synParams.floor > qParams.floor and neuParams.floor > synParams.floor,
            "Higher scales should have higher floor requirements"
        )
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ENGINE CATEGORIES TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testAllCategoriesCount() : TestResult {
        // Should have exactly 12 engine categories
        assertTrue(MedinaUnifiedOrganismCore.ALL_CATEGORIES.size() == 12, "Should have 12 engine categories")
    };

    public func testCategoryTypesExist() : TestResult {
        // Verify key categories exist
        var hasAnimal = false;
        var hasQuantum = false;
        var hasNeural = false;
        var hasEconomic = false;
        var hasGovernance = false;
        
        for (cat in MedinaUnifiedOrganismCore.ALL_CATEGORIES.vals()) {
            switch (cat) {
                case (#Animal) { hasAnimal := true };
                case (#Quantum) { hasQuantum := true };
                case (#Neural) { hasNeural := true };
                case (#Economic) { hasEconomic := true };
                case (#Governance) { hasGovernance := true };
                case (_) {};
            };
        };
        
        assertTrue(
            hasAnimal and hasQuantum and hasNeural and hasEconomic and hasGovernance,
            "All key categories should exist"
        )
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // UNIFIED STATE INITIALIZATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testInitOrganismStateIdentity() : TestResult {
        let orgId = Principal.fromText("aaaaa-aa");
        let state = MedinaUnifiedOrganismCore.initOrganismState(
            orgId,
            "TestOrganism",
            1,    // generation
            100,  // currentBeat
            1000000 : Int  // currentTime
        );
        assertTrue(
            state.name == "TestOrganism" and state.generation == 1,
            "State should have correct identity"
        )
    };

    public func testInitOrganismStateBirthBeat() : TestResult {
        let orgId = Principal.fromText("aaaaa-aa");
        let state = MedinaUnifiedOrganismCore.initOrganismState(
            orgId, "TestOrganism", 1, 100, 1000000 : Int
        );
        assertTrue(state.birthBeat == 100, "Birth beat should match initialization")
    };

    public func testInitOrganismStateCurrentBeat() : TestResult {
        let orgId = Principal.fromText("aaaaa-aa");
        let state = MedinaUnifiedOrganismCore.initOrganismState(
            orgId, "TestOrganism", 1, 100, 1000000 : Int
        );
        assertTrue(state.currentBeat == 100, "Current beat should match initialization")
    };

    public func testInitOrganismStateInitialHealth() : TestResult {
        let orgId = Principal.fromText("aaaaa-aa");
        let state = MedinaUnifiedOrganismCore.initOrganismState(
            orgId, "TestOrganism", 1, 0, 0 : Int
        );
        // Initial state should be healthy with no violations
        assertTrue(
            state.isHealthy and state.scaleViolations.size() == 0,
            "Initial state should be healthy with no violations"
        )
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SCALE VIOLATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testScaleViolationStructure() : TestResult {
        let violation : MedinaUnifiedOrganismCore.ScaleViolation = {
            scale = #Neural;
            currentValue = 0.30;
            requiredFloor = 0.382;
            severity = 0.082;  // How far below floor
            message = "Neural scale below resonance floor";
        };
        assertTrue(
            violation.currentValue < violation.requiredFloor,
            "Violation should have current value below floor"
        )
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let buffer = Buffer.Buffer<TestResult>(50);
        
        // Sacred constants
        buffer.add(testPhi());
        buffer.add(testPsi());
        buffer.add(testPi());
        buffer.add(testTau());
        buffer.add(testEuler());
        
        // Medina sovereign constants
        buffer.add(testPhiMedina());
        buffer.add(testOmegaMedina());
        buffer.add(testTauEmergence());
        
        // Floor constants
        buffer.add(testSovereignFloor());
        buffer.add(testOmnisFloor());
        buffer.add(testDiamondFloor());
        buffer.add(testPlatinumFloor());
        buffer.add(testGoldenFloor());
        buffer.add(testConvergenceFloor());
        buffer.add(testCriticalFloor());
        buffer.add(testFloorHierarchy());
        
        // Fibonacci
        buffer.add(testFibonacciFirst());
        buffer.add(testFibonacciRecurrence());
        buffer.add(testFibonacciLength());
        
        // Time constants
        buffer.add(testTimeImmediate());
        buffer.add(testTimeShort());
        buffer.add(testTimeMedium());
        buffer.add(testTimeLong());
        
        // Scale laws
        buffer.add(testAllScalesCount());
        buffer.add(testScaleParamsQuantum());
        buffer.add(testScaleParamsOrganism());
        buffer.add(testScaleParamsEcosystem());
        buffer.add(testScaleFloorsIncrease());
        
        // Engine categories
        buffer.add(testAllCategoriesCount());
        buffer.add(testCategoryTypesExist());
        
        // State initialization
        buffer.add(testInitOrganismStateIdentity());
        buffer.add(testInitOrganismStateBirthBeat());
        buffer.add(testInitOrganismStateCurrentBeat());
        buffer.add(testInitOrganismStateInitialHealth());
        
        // Scale violations
        buffer.add(testScaleViolationStructure());
        
        Buffer.toArray(buffer)
    };
}
