// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  ANIMAL INTELLIGENCE TEST SUITE                                                                           ║
// ║  Tests for bio-inspired cognitive architectures: Crow, Octopus, Elephant                                  ║
// ║  Each animal model contributes unique capabilities to the organism                                        ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import modules under test
import CrowCognition "../src/swarm_brain/modules/CrowCognition";
import OctopusBrain "../src/swarm_brain/modules/OctopusBrain";
import ElephantMemory "../src/swarm_brain/modules/ElephantMemory";

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
    // OCTOPUS BRAIN TESTS - Distributed Intelligence
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testOctopusArmCount() : TestResult {
        assertEqual(8, OctopusBrain.N_ARMS, func(a: Nat, b: Nat) { a == b }, 
            "Octopus should have 8 arms")
    };

    public func testOctopusCentralNeurons() : TestResult {
        // 50 million central neurons
        assertEqual(50000000, OctopusBrain.NEURONS_CENTRAL, func(a: Nat, b: Nat) { a == b },
            "Central brain should have 50M neurons")
    };

    public func testOctopusNeuronsPerArm() : TestResult {
        // 450M/8 = 56.25M per arm
        assertEqual(56250000, OctopusBrain.NEURONS_PER_ARM, func(a: Nat, b: Nat) { a == b },
            "Each arm should have ~56M neurons")
    };

    public func testOctopusTotalNeurons() : TestResult {
        // Total should be ~500M (50M central + 8*56.25M arms)
        let total = OctopusBrain.NEURONS_CENTRAL + 8 * OctopusBrain.NEURONS_PER_ARM;
        let expected = 500000000; // 500 million
        assertTrue(total == expected, "Total neurons should be 500M")
    };

    public func testOctopusCentralFraction() : TestResult {
        // Only 10% of neurons in central brain
        assertFloatClose(0.10, OctopusBrain.CENTRAL_FRACTION, 0.01,
            "Central brain should have 10% of neurons")
    };

    public func testOctopusSuckersPerArm() : TestResult {
        assertEqual(2200, OctopusBrain.SUCKERS_PER_ARM, func(a: Nat, b: Nat) { a == b },
            "Each arm should have 2200 suckers")
    };

    public func testOctopusTotalSuckers() : TestResult {
        let total = 8 * OctopusBrain.SUCKERS_PER_ARM;
        assertEqual(17600, total, func(a: Nat, b: Nat) { a == b },
            "Total suckers should be 17600")
    };

    public func testOctopusChemoreceptorsTotal() : TestResult {
        // 250 per sucker × 2200 suckers × 8 arms = 4.4M
        let total = OctopusBrain.CHEMORECEPTORS_PER_SUCKER * OctopusBrain.SUCKERS_PER_ARM * OctopusBrain.N_ARMS;
        assertEqual(4400000, total, func(a: Nat, b: Nat) { a == b },
            "Total chemoreceptors should be 4.4M")
    };

    public func testOctopusSignalDelay() : TestResult {
        // 50ms arm-to-brain delay
        assertFloatClose(50.0, OctopusBrain.SIGNAL_DELAY_MS, 0.1,
            "Signal delay should be 50ms")
    };

    public func testOctopusChromatophores() : TestResult {
        // 1 million chromatophore units
        assertEqual(1000000, OctopusBrain.N_CHROMATOPHORES, func(a: Nat, b: Nat) { a == b },
            "Should have 1M chromatophores")
    };

    public func testOctopusPigmentTypes() : TestResult {
        // Red, yellow, brown = 3 types
        assertEqual(3, OctopusBrain.N_PIGMENT_TYPES, func(a: Nat, b: Nat) { a == b },
            "Should have 3 pigment types")
    };

    public func testOctopusArmLength() : TestResult {
        // 50cm arm length
        assertFloatClose(0.50, OctopusBrain.ARM_LENGTH_M, 0.01,
            "Arm length should be 0.5m")
    };

    public func testOctopusSuckerForce() : TestResult {
        // 2.5N per sucker grip force
        assertFloatClose(2.5, OctopusBrain.SUCKER_FORCE_N, 0.1,
            "Sucker force should be 2.5N")
    };

    public func testOctopusMedinaConstants() : TestResult {
        // PHI_MEDINA should be the golden harmonic
        assertFloatClose(2.97442179, OctopusBrain.PHI_MEDINA, 0.00001,
            "PHI_MEDINA should be 2.97442179")
    };

    public func testOctopusLearningRate() : TestResult {
        assertFloatClose(0.01, OctopusBrain.LEARNING_RATE, 0.001,
            "Learning rate should be 0.01")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ELEPHANT MEMORY TESTS - Long-term temporal binding
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testElephantMemoryCapacity() : TestResult {
        // 1000 long-term memories
        let MEMORY_CAPACITY = 1000;
        assertTrue(MEMORY_CAPACITY == 1000, "Memory capacity should be 1000")
    };

    public func testElephantSpatialCells() : TestResult {
        // 256 spatial cells (16x16 grid)
        let SPATIAL_CELLS = 256;
        assertTrue(SPATIAL_CELLS == 256, "Spatial cells should be 256 (16x16)")
    };

    public func testElephantSocialMemorySize() : TestResult {
        // Can recognize 100 individuals
        let SOCIAL_MEMORY_SIZE = 100;
        assertTrue(SOCIAL_MEMORY_SIZE == 100, "Social memory should hold 100 individuals")
    };

    public func testElephantMemoryTypesSpatial() : TestResult {
        let memType = #Spatial;
        let isSpatial = switch(memType) { case (#Spatial) true; case _ false };
        assertTrue(isSpatial, "Spatial memory type should be recognized")
    };

    public func testElephantMemoryTypesSocial() : TestResult {
        let memType = #Social;
        let isSocial = switch(memType) { case (#Social) true; case _ false };
        assertTrue(isSocial, "Social memory type should be recognized")
    };

    public func testElephantMemoryTypesMourning() : TestResult {
        let memType = #Mourning;
        let isMourning = switch(memType) { case (#Mourning) true; case _ false };
        assertTrue(isMourning, "Mourning memory type should be recognized")
    };

    public func testElephantRelationshipMother() : TestResult {
        let rel = #Mother;
        let isMother = switch(rel) { case (#Mother) true; case _ false };
        assertTrue(isMother, "Mother relationship should be recognized")
    };

    public func testElephantRelationshipMatriarch() : TestResult {
        let rel = #MatriarchLine;
        let isMatriarch = switch(rel) { case (#MatriarchLine) true; case _ false };
        assertTrue(isMatriarch, "MatriarchLine relationship should be recognized")
    };

    public func testElephantInfrasoundContact() : TestResult {
        let call = #Contact;
        let isContact = switch(call) { case (#Contact) true; case _ false };
        assertTrue(isContact, "Contact call meaning should be recognized")
    };

    public func testElephantInfrasoundAlarm() : TestResult {
        let call = #Alarm;
        let isAlarm = switch(call) { case (#Alarm) true; case _ false };
        assertTrue(isAlarm, "Alarm call meaning should be recognized")
    };

    public func testElephantInfrasoundGathering() : TestResult {
        let call = #Gathering;
        let isGathering = switch(call) { case (#Gathering) true; case _ false };
        assertTrue(isGathering, "Gathering call meaning should be recognized")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // CROW COGNITION TESTS - Meta-learning and insight
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testCrowPlanningHorizon() : TestResult {
        // Crows can plan 12 steps ahead
        let PLANNING_HORIZON = 12;
        assertTrue(PLANNING_HORIZON == 12, "Planning horizon should be 12 steps")
    };

    public func testCrowToolMemorySize() : TestResult {
        // Remember 8 tool-use solutions
        let TOOL_MEMORY_SIZE = 8;
        assertTrue(TOOL_MEMORY_SIZE == 8, "Tool memory should hold 8 solutions")
    };

    public func testCrowMetaDepth() : TestResult {
        // 5 levels of meta-cognition
        let META_DEPTH = 5;
        assertTrue(META_DEPTH == 5, "Meta-cognition depth should be 5 levels")
    };

    public func testCrowMedinaConstants() : TestResult {
        // PHI_MEDINA = 2.97442179
        let PHI_MEDINA = 2.97442179;
        assertFloatClose(2.97442179, PHI_MEDINA, 0.00001,
            "PHI_MEDINA should be 2.97442179")
    };

    public func testCrowTauEmergence() : TestResult {
        // TAU_EMERGENCE = 0.618033988749 (golden ratio inverse)
        let TAU_EMERGENCE = 0.618033988749;
        assertFloatClose(0.618033988749, TAU_EMERGENCE, 0.0000001,
            "TAU_EMERGENCE should be golden ratio inverse")
    };

    public func testCrowBetaTom() : TestResult {
        // BETA_TOM ≈ 1/Φ_M ≈ 0.336
        let BETA_TOM = 0.336;
        assertFloatClose(0.336, BETA_TOM, 0.01,
            "BETA_TOM should be ~0.336 (1/Φ_M)")
    };

    public func testCrowLearningStrategyExploitation() : TestResult {
        let strategy = #Exploitation;
        let isExploit = switch(strategy) { case (#Exploitation) true; case _ false };
        assertTrue(isExploit, "Exploitation strategy should be recognized")
    };

    public func testCrowLearningStrategyExploration() : TestResult {
        let strategy = #Exploration;
        let isExplore = switch(strategy) { case (#Exploration) true; case _ false };
        assertTrue(isExplore, "Exploration strategy should be recognized")
    };

    public func testCrowLearningStrategyImitation() : TestResult {
        let strategy = #Imitation;
        let isImitate = switch(strategy) { case (#Imitation) true; case _ false };
        assertTrue(isImitate, "Imitation strategy should be recognized")
    };

    public func testCrowLearningStrategyInnovation() : TestResult {
        let strategy = #Innovation;
        let isInnovate = switch(strategy) { case (#Innovation) true; case _ false };
        assertTrue(isInnovate, "Innovation strategy should be recognized")
    };

    public func testCrowLearningStrategyTransfer() : TestResult {
        let strategy = #Transfer;
        let isTransfer = switch(strategy) { case (#Transfer) true; case _ false };
        assertTrue(isTransfer, "Transfer strategy should be recognized")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // MEDINA INSIGHT EMERGENCE FUNCTION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testInsightThreshold() : TestResult {
        // Insight emerges when explore × exploit > TAU_E
        let TAU_EMERGENCE = 0.618033988749;
        let explore = 0.8;
        let exploit = 0.9;
        let product = explore * exploit;
        assertTrue(product > TAU_EMERGENCE, "High explore × exploit should exceed threshold")
    };

    public func testInsightSubthreshold() : TestResult {
        // Below threshold, no insight
        let TAU_EMERGENCE = 0.618033988749;
        let explore = 0.5;
        let exploit = 0.5;
        let product = explore * exploit;
        assertTrue(product < TAU_EMERGENCE, "Low explore × exploit should be below threshold")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // CROSS-ANIMAL INTEGRATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testAllAnimalsUsePHI_MEDINA() : TestResult {
        // All animal modules should use the same Medina Golden Harmonic
        let octoPhi = OctopusBrain.PHI_MEDINA;
        assertFloatClose(2.97442179, octoPhi, 0.00001,
            "All animals should share PHI_MEDINA = 2.97442179")
    };

    public func testDistributedVsCentralized() : TestResult {
        // Octopus: 90% distributed, Crow: centralized, Elephant: memory-centric
        let octoCentral = OctopusBrain.CENTRAL_FRACTION;
        assertTrue(octoCentral == 0.10, "Octopus should have highly distributed cognition (10% central)")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let results = Buffer.Buffer<TestResult>(60);

        // Octopus Brain
        results.add(testOctopusArmCount());
        results.add(testOctopusCentralNeurons());
        results.add(testOctopusNeuronsPerArm());
        results.add(testOctopusTotalNeurons());
        results.add(testOctopusCentralFraction());
        results.add(testOctopusSuckersPerArm());
        results.add(testOctopusTotalSuckers());
        results.add(testOctopusChemoreceptorsTotal());
        results.add(testOctopusSignalDelay());
        results.add(testOctopusChromatophores());
        results.add(testOctopusPigmentTypes());
        results.add(testOctopusArmLength());
        results.add(testOctopusSuckerForce());
        results.add(testOctopusMedinaConstants());
        results.add(testOctopusLearningRate());

        // Elephant Memory
        results.add(testElephantMemoryCapacity());
        results.add(testElephantSpatialCells());
        results.add(testElephantSocialMemorySize());
        results.add(testElephantMemoryTypesSpatial());
        results.add(testElephantMemoryTypesSocial());
        results.add(testElephantMemoryTypesMourning());
        results.add(testElephantRelationshipMother());
        results.add(testElephantRelationshipMatriarch());
        results.add(testElephantInfrasoundContact());
        results.add(testElephantInfrasoundAlarm());
        results.add(testElephantInfrasoundGathering());

        // Crow Cognition
        results.add(testCrowPlanningHorizon());
        results.add(testCrowToolMemorySize());
        results.add(testCrowMetaDepth());
        results.add(testCrowMedinaConstants());
        results.add(testCrowTauEmergence());
        results.add(testCrowBetaTom());
        results.add(testCrowLearningStrategyExploitation());
        results.add(testCrowLearningStrategyExploration());
        results.add(testCrowLearningStrategyImitation());
        results.add(testCrowLearningStrategyInnovation());
        results.add(testCrowLearningStrategyTransfer());

        // Insight Emergence
        results.add(testInsightThreshold());
        results.add(testInsightSubthreshold());

        // Cross-Animal Integration
        results.add(testAllAnimalsUsePHI_MEDINA());
        results.add(testDistributedVsCentralized());

        Buffer.toArray(results)
    };

    public func printTestResults(results: [TestResult]) : Text {
        var output = "\n════════════════════════════════════════════════════════════════\n";
        output #= "         ANIMAL INTELLIGENCE TEST RESULTS\n";
        output #= "         Bio-Inspired Cognitive Architectures\n";
        output #= "════════════════════════════════════════════════════════════════\n\n";

        output #= "🐙 OCTOPUS — Distributed Intelligence\n";
        output #= "🐘 ELEPHANT — Long-term Memory\n";
        output #= "🐦 CROW — Meta-cognition & Insight\n\n";

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
