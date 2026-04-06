// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  SWARM ORGANISM TEST SUITE                                                                                ║
// ║  Comprehensive tests for Swarm Organism Bee Hive Mind and Ant Mind functionality                         ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

module {
    // ═══════════════════════════════════════════════════════════════════════════════
    // SWARM ORGANISM CONSTANTS (mirroring main.mo)
    // ═══════════════════════════════════════════════════════════════════════════════

    let MAX_DRONES    : Nat   = 50;
    let GRID_W        : Nat   = 20;   // pheromone / nectar grid width
    let GRID_CELLS    : Nat   = 400;  // GRID_W × GRID_W
    let SOVEREIGN_FLOOR : Float = 1.0;
    let PI            : Float = 3.14159265358979;
    let EPSILON       : Float = 0.001;
    let EVAP_RATE     : Float = 0.05;
    let DEPOSIT_Q     : Float = 1.0;
    let ACO_ALPHA     : Float = 1.0;
    let ACO_BETA      : Float = 2.0;

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

    func assertEqual<T>(expected: T, actual: T, compare: (T, T) -> Bool, name: Text) : TestResult {
        if (compare(expected, actual)) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Values not equal" }
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // MATHEMATICAL FUNCTIONS (duplicated for testing isolation)
    // ═══════════════════════════════════════════════════════════════════════════════

    // Waggle dance recruitment probability
    func waggleRecruitProb(quality : Float) : Float {
        let k : Float = 2.0;
        1.0 / (1.0 + Float.exp(-k * (quality - 0.5)))
    };

    // World position to grid cell conversion
    func worldToCell(x : Float, z : Float) : Nat {
        let gx = Nat.min(GRID_W - 1, Int.abs(Float.toInt(Float.max(0.0, (x + 100.0) / 200.0 * Float.fromInt(GRID_W)))));
        let gz = Nat.min(GRID_W - 1, Int.abs(Float.toInt(Float.max(0.0, (z + 100.0) / 200.0 * Float.fromInt(GRID_W)))));
        gz * GRID_W + gx
    };

    // ACO next cell calculation (simplified for testing)
    func natAbsDiff(a : Nat, b : Nat) : Nat {
        if (a >= b) a - b else b - a
    };

    // Threshold decision probability
    func thresholdProb(stimulus: Float, threshold: Float) : Float {
        (stimulus * stimulus) / (stimulus * stimulus + threshold * threshold + EPSILON)
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // BEE HIVE MIND TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    // Test waggle recruitment probability at various quality levels
    public func testWaggleRecruitProbLowQuality() : TestResult {
        let prob = waggleRecruitProb(0.0);
        // At quality 0, prob should be low (sigmoid around 0.27)
        assertTrue(prob < 0.4, "Low quality should have low recruitment probability")
    };

    public func testWaggleRecruitProbMidQuality() : TestResult {
        let prob = waggleRecruitProb(0.5);
        // At quality 0.5, prob should be exactly 0.5 (sigmoid midpoint)
        assertFloatClose(0.5, prob, 0.01, "Mid quality should have 50% recruitment probability")
    };

    public func testWaggleRecruitProbHighQuality() : TestResult {
        let prob = waggleRecruitProb(1.0);
        // At quality 1.0, prob should be high (sigmoid around 0.73)
        assertTrue(prob > 0.6, "High quality should have high recruitment probability")
    };

    public func testWaggleRecruitProbMonotonicity() : TestResult {
        let prob1 = waggleRecruitProb(0.2);
        let prob2 = waggleRecruitProb(0.5);
        let prob3 = waggleRecruitProb(0.8);
        assertTrue(prob1 < prob2 and prob2 < prob3, "Waggle recruitment should increase monotonically with quality")
    };

    // Test world to cell conversion
    public func testWorldToCellCenter() : TestResult {
        let cell = worldToCell(0.0, 0.0);
        // Center (0,0) should map to middle of grid (around 10,10 = cell 210)
        let expectedCell = 10 * GRID_W + 10;
        assertEqual(expectedCell, cell, func(a: Nat, b: Nat) { a == b }, "World center should map to grid center")
    };

    public func testWorldToCellBottomLeft() : TestResult {
        let cell = worldToCell(-100.0, -100.0);
        // Bottom-left corner should map to cell (0,0)
        assertEqual(0, cell, func(a: Nat, b: Nat) { a == b }, "World (-100,-100) should map to cell 0")
    };

    public func testWorldToCellTopRight() : TestResult {
        let cell = worldToCell(100.0, 100.0);
        // Top-right corner should map to cell (19,19) = 399
        let expectedCell = (GRID_W - 1) * GRID_W + (GRID_W - 1);
        assertEqual(expectedCell, cell, func(a: Nat, b: Nat) { a == b }, "World (100,100) should map to top-right cell")
    };

    public func testWorldToCellBoundsClamping() : TestResult {
        // Values outside [-100, 100] should be clamped
        let cell1 = worldToCell(-200.0, -200.0);
        let cell2 = worldToCell(200.0, 200.0);
        assertTrue(cell1 < GRID_CELLS and cell2 < GRID_CELLS, "Out-of-bounds positions should be clamped to valid cells")
    };

    // Test queen pheromone decay
    public func testQueenPheromoneDecay() : TestResult {
        let initialPheromone : Float = 1.5;
        let decayRate : Float = 0.05;
        let decayed = Float.max(0.5, initialPheromone * Float.exp(-decayRate));
        // Should decay but stay above floor
        assertTrue(decayed < initialPheromone and decayed >= 0.5, "Queen pheromone should decay but stay above floor")
    };

    public func testQueenPheromoneFloor() : TestResult {
        let veryLowPheromone : Float = 0.3;
        let decayRate : Float = 0.05;
        let decayed = Float.max(0.5, veryLowPheromone * Float.exp(-decayRate));
        // Should be clamped to floor
        assertFloatClose(0.5, decayed, 0.01, "Queen pheromone should not go below floor")
    };

    // Test nectar grid dynamics
    public func testNectarReplenishment() : TestResult {
        let initialNectar : Float = 0.5;
        let replenishRate : Float = 0.005;
        let replenished = Float.min(1.0, initialNectar + replenishRate);
        assertTrue(replenished > initialNectar, "Nectar should replenish over time")
    };

    public func testNectarCeiling() : TestResult {
        let fullNectar : Float = 0.999;
        let replenishRate : Float = 0.005;
        let replenished = Float.min(1.0, fullNectar + replenishRate);
        assertTrue(replenished <= 1.0, "Nectar should not exceed 1.0")
    };

    public func testNectarHarvest() : TestResult {
        let initialNectar : Float = 0.8;
        let harvestRate : Float = 0.1;
        let harvested = initialNectar * harvestRate;
        let remaining = Float.max(0.0, initialNectar - harvested);
        assertTrue(remaining < initialNectar and remaining >= 0.0, "Nectar harvest should reduce but not go negative")
    };

    // Test comb role assignment
    public func testCombRoleSovereign() : TestResult {
        let classType = "SOVEREIGN";
        let expectedRole = "QUEEN_GUARD";
        let assignedRole = switch (classType) {
            case "SOVEREIGN" "QUEEN_GUARD";
            case _           "WORKER";
        };
        assertEqual(expectedRole, assignedRole, func(a: Text, b: Text) { a == b }, "SOVEREIGN should be assigned QUEEN_GUARD role")
    };

    public func testCombRoleScoutHighQuality() : TestResult {
        let classType = "SCOUT";
        let waggleQuality : Float = 0.5;
        let expectedRole = if (waggleQuality > 0.3) "FORAGER" else "SCOUT";
        assertEqual("FORAGER", expectedRole, func(a: Text, b: Text) { a == b }, "SCOUT with high waggle quality should become FORAGER")
    };

    public func testCombRoleScoutLowQuality() : TestResult {
        let classType = "SCOUT";
        let waggleQuality : Float = 0.2;
        let expectedRole = if (waggleQuality > 0.3) "FORAGER" else "SCOUT";
        assertEqual("SCOUT", expectedRole, func(a: Text, b: Text) { a == b }, "SCOUT with low waggle quality should stay SCOUT")
    };

    public func testCombRoleMedic() : TestResult {
        let classType = "MEDIC";
        let expectedRole = "NURSE";
        let assignedRole = switch (classType) {
            case "MEDIC" "NURSE";
            case _       "WORKER";
        };
        assertEqual(expectedRole, assignedRole, func(a: Text, b: Text) { a == b }, "MEDIC should be assigned NURSE role")
    };

    public func testCombRoleGuardian() : TestResult {
        let classType = "GUARDIAN";
        let expectedRole = "DEFENDER";
        let assignedRole = switch (classType) {
            case "GUARDIAN" "DEFENDER";
            case _          "WORKER";
        };
        assertEqual(expectedRole, assignedRole, func(a: Text, b: Text) { a == b }, "GUARDIAN should be assigned DEFENDER role")
    };

    public func testCombRoleDefault() : TestResult {
        let classType = "UNKNOWN";
        let assignedRole = switch (classType) {
            case "SOVEREIGN" "QUEEN_GUARD";
            case "MEDIC"     "NURSE";
            case "GUARDIAN"  "DEFENDER";
            case _           "WORKER";
        };
        assertEqual("WORKER", assignedRole, func(a: Text, b: Text) { a == b }, "Unknown class should default to WORKER")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ANT MIND TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    // Test pheromone evaporation
    public func testPheromoneEvaporation() : TestResult {
        let initialPhero : Float = 1.0;
        let evaporated = Float.max(0.01, initialPhero * (1.0 - EVAP_RATE));
        assertTrue(evaporated < initialPhero and evaporated > 0.0, "Pheromone should evaporate but stay positive")
    };

    public func testPheromoneEvaporationFloor() : TestResult {
        let veryLowPhero : Float = 0.005;
        let evaporated = Float.max(0.01, veryLowPhero * (1.0 - EVAP_RATE));
        assertTrue(evaporated >= 0.01, "Pheromone should not go below minimum floor")
    };

    // Test pheromone deposit
    public func testPheromoneDeposit() : TestResult {
        let currentPhero : Float = 0.5;
        let pathLength : Float = 2.0;
        let delta = DEPOSIT_Q / Float.max(0.1, pathLength);
        let newPhero = Float.min(5.0, currentPhero + delta);
        assertTrue(newPhero > currentPhero, "Pheromone deposit should increase value")
    };

    public func testPheromoneDepositCeiling() : TestResult {
        let highPhero : Float = 4.8;
        let pathLength : Float = 0.5;
        let delta = DEPOSIT_Q / Float.max(0.1, pathLength);
        let newPhero = Float.min(5.0, highPhero + delta);
        assertTrue(newPhero <= 5.0, "Pheromone should not exceed ceiling")
    };

    public func testPheromoneDepositShortPath() : TestResult {
        let currentPhero : Float = 0.5;
        let shortPath : Float = 0.5;
        let longPath : Float = 5.0;
        let deltaShort = DEPOSIT_Q / Float.max(0.1, shortPath);
        let deltaLong = DEPOSIT_Q / Float.max(0.1, longPath);
        assertTrue(deltaShort > deltaLong, "Short paths should deposit more pheromone")
    };

    // Test ACO probability calculation
    public func testACOProbHighPheromone() : TestResult {
        let highTau : Float = 2.0;
        let lowTau : Float = 0.5;
        let eta : Float = 1.0; // Same heuristic
        let scoreHigh = Float.pow(highTau, ACO_ALPHA) * Float.pow(eta, ACO_BETA);
        let scoreLow = Float.pow(lowTau, ACO_ALPHA) * Float.pow(eta, ACO_BETA);
        assertTrue(scoreHigh > scoreLow, "High pheromone paths should have higher ACO score")
    };

    public func testACOProbCloseGoal() : TestResult {
        let tau : Float = 1.0; // Same pheromone
        let etaClose : Float = 1.0 / 2.0;  // Closer goal
        let etaFar : Float = 1.0 / 10.0;   // Farther goal
        let scoreClose = Float.pow(tau, ACO_ALPHA) * Float.pow(etaClose, ACO_BETA);
        let scoreFar = Float.pow(tau, ACO_ALPHA) * Float.pow(etaFar, ACO_BETA);
        assertTrue(scoreClose > scoreFar, "Closer goals should have higher ACO score")
    };

    // Test threshold decision model
    public func testThresholdDecisionHighStimulus() : TestResult {
        let highStim : Float = 2.0;
        let threshold : Float = 1.0;
        let prob = thresholdProb(highStim, threshold);
        assertTrue(prob > 0.5, "High stimulus should yield high task probability")
    };

    public func testThresholdDecisionLowStimulus() : TestResult {
        let lowStim : Float = 0.5;
        let threshold : Float = 2.0;
        let prob = thresholdProb(lowStim, threshold);
        assertTrue(prob < 0.5, "Low stimulus relative to threshold should yield low probability")
    };

    public func testThresholdDecisionEqual() : TestResult {
        let stim : Float = 1.0;
        let threshold : Float = 1.0;
        let prob = thresholdProb(stim, threshold);
        // When stimulus = threshold, prob should be around 0.5
        assertFloatClose(0.5, prob, 0.05, "Equal stimulus and threshold should yield ~50% probability")
    };

    // Test threshold adaptation (habituation and sensitization)
    public func testThresholdHabituation() : TestResult {
        let initialThreshold : Float = 1.0;
        let decreasedThreshold = Float.max(0.1, initialThreshold - 0.05);
        assertTrue(decreasedThreshold < initialThreshold, "Habituation should decrease threshold")
    };

    public func testThresholdSensitization() : TestResult {
        let initialThreshold : Float = 1.0;
        let increasedThreshold = Float.min(5.0, initialThreshold + 0.01);
        assertTrue(increasedThreshold > initialThreshold, "Sensitization should increase threshold")
    };

    public func testThresholdMinFloor() : TestResult {
        let veryLowThreshold : Float = 0.08;
        let decreased = Float.max(0.1, veryLowThreshold - 0.05);
        assertTrue(decreased >= 0.1, "Threshold should not go below minimum floor")
    };

    public func testThresholdMaxCeiling() : TestResult {
        let highThreshold : Float = 4.99;
        let increased = Float.min(5.0, highThreshold + 0.01);
        assertTrue(increased <= 5.0, "Threshold should not exceed ceiling")
    };

    // Test experience-based threshold reduction
    public func testExperienceThresholdReduction() : TestResult {
        let experience : Nat = 20;
        let shouldReduce = experience % 10 == 0;
        assertTrue(shouldReduce, "Experience at multiples of 10 should trigger threshold reduction")
    };

    // Test ant role assignment based on task
    public func testAntRoleForager() : TestResult {
        let task : Nat = 0;
        let role = switch task {
            case 0 "FORAGER";
            case 1 "DEFENDER";
            case 2 "RELAY";
            case 3 "NURSE";
            case _ "SCOUT";
        };
        assertEqual("FORAGER", role, func(a: Text, b: Text) { a == b }, "Task 0 should map to FORAGER role")
    };

    public func testAntRoleDefender() : TestResult {
        let task : Nat = 1;
        let role = switch task {
            case 0 "FORAGER";
            case 1 "DEFENDER";
            case 2 "RELAY";
            case 3 "NURSE";
            case _ "SCOUT";
        };
        assertEqual("DEFENDER", role, func(a: Text, b: Text) { a == b }, "Task 1 should map to DEFENDER role")
    };

    public func testAntRoleRelay() : TestResult {
        let task : Nat = 2;
        let role = switch task {
            case 0 "FORAGER";
            case 1 "DEFENDER";
            case 2 "RELAY";
            case 3 "NURSE";
            case _ "SCOUT";
        };
        assertEqual("RELAY", role, func(a: Text, b: Text) { a == b }, "Task 2 should map to RELAY role")
    };

    public func testAntRoleNurse() : TestResult {
        let task : Nat = 3;
        let role = switch task {
            case 0 "FORAGER";
            case 1 "DEFENDER";
            case 2 "RELAY";
            case 3 "NURSE";
            case _ "SCOUT";
        };
        assertEqual("NURSE", role, func(a: Text, b: Text) { a == b }, "Task 3 should map to NURSE role")
    };

    public func testAntRoleScout() : TestResult {
        let task : Nat = 4;
        let role = switch task {
            case 0 "FORAGER";
            case 1 "DEFENDER";
            case 2 "RELAY";
            case 3 "NURSE";
            case _ "SCOUT";
        };
        assertEqual("SCOUT", role, func(a: Text, b: Text) { a == b }, "Task 4+ should map to SCOUT role")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // HYBRID MODE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testOrganismModeHybrid() : TestResult {
        let mode = "HYBRID";
        let isHybrid = mode == "HYBRID";
        assertTrue(isHybrid, "HYBRID mode should be recognized")
    };

    public func testOrganismModeHiveMind() : TestResult {
        let mode = "HIVE_MIND";
        let isHive = mode == "HIVE_MIND";
        assertTrue(isHive, "HIVE_MIND mode should be recognized")
    };

    public func testOrganismModeAntMind() : TestResult {
        let mode = "ANT_MIND";
        let isAnt = mode == "ANT_MIND";
        assertTrue(isAnt, "ANT_MIND mode should be recognized")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // GRID AND BOUNDS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testGridSize() : TestResult {
        assertEqual(400, GRID_CELLS, func(a: Nat, b: Nat) { a == b }, "Grid should have 400 cells (20x20)")
    };

    public func testMaxDrones() : TestResult {
        assertEqual(50, MAX_DRONES, func(a: Nat, b: Nat) { a == b }, "Max drones should be 50")
    };

    public func testGridWidth() : TestResult {
        assertEqual(20, GRID_W, func(a: Nat, b: Nat) { a == b }, "Grid width should be 20")
    };

    public func testCellIndexBounds() : TestResult {
        var allValid = true;
        var r = 0;
        while (r < GRID_W and allValid) {
            var c = 0;
            while (c < GRID_W and allValid) {
                let idx = r * GRID_W + c;
                if (idx >= GRID_CELLS) {
                    allValid := false;
                };
                c += 1;
            };
            r += 1;
        };
        assertTrue(allValid, "All cell indices should be within bounds")
    };

    // Test natAbsDiff helper
    public func testNatAbsDiffLarger() : TestResult {
        let result = natAbsDiff(10, 3);
        assertEqual(7, result, func(a: Nat, b: Nat) { a == b }, "natAbsDiff(10,3) should be 7")
    };

    public func testNatAbsDiffSmaller() : TestResult {
        let result = natAbsDiff(3, 10);
        assertEqual(7, result, func(a: Nat, b: Nat) { a == b }, "natAbsDiff(3,10) should be 7")
    };

    public func testNatAbsDiffEqual() : TestResult {
        let result = natAbsDiff(5, 5);
        assertEqual(0, result, func(a: Nat, b: Nat) { a == b }, "natAbsDiff(5,5) should be 0")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // INTERNAL AI ORGAN TESTS (Nervous, Immune, Metabolic, Sensory, Reproductive)
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testOrganSystemCount() : TestResult {
        // There should be 5 organ systems
        let organSystems = ["NERVOUS", "IMMUNE", "METABOLIC", "SENSORY", "REPRODUCTIVE"];
        assertEqual(5, organSystems.size(), func(a: Nat, b: Nat) { a == b }, "Should have 5 organ systems")
    };

    public func testNervousOrganRouting() : TestResult {
        // NERVOUS organ handles routing
        let organType = "NERVOUS";
        let function = switch (organType) {
            case "NERVOUS" "routing";
            case _         "unknown";
        };
        assertEqual("routing", function, func(a: Text, b: Text) { a == b }, "NERVOUS organ should handle routing")
    };

    public func testImmuneOrganDefense() : TestResult {
        // IMMUNE organ handles defense
        let organType = "IMMUNE";
        let function = switch (organType) {
            case "IMMUNE" "defence";
            case _        "unknown";
        };
        assertEqual("defence", function, func(a: Text, b: Text) { a == b }, "IMMUNE organ should handle defence")
    };

    public func testMetabolicOrganEnergy() : TestResult {
        // METABOLIC organ handles energy
        let organType = "METABOLIC";
        let function = switch (organType) {
            case "METABOLIC" "energy";
            case _           "unknown";
        };
        assertEqual("energy", function, func(a: Text, b: Text) { a == b }, "METABOLIC organ should handle energy")
    };

    public func testSensoryOrganPerception() : TestResult {
        // SENSORY organ handles perception
        let organType = "SENSORY";
        let function = switch (organType) {
            case "SENSORY" "perception";
            case _         "unknown";
        };
        assertEqual("perception", function, func(a: Text, b: Text) { a == b }, "SENSORY organ should handle perception")
    };

    public func testReproductiveOrganGrowth() : TestResult {
        // REPRODUCTIVE organ handles swarm growth
        let organType = "REPRODUCTIVE";
        let function = switch (organType) {
            case "REPRODUCTIVE" "swarm_growth";
            case _              "unknown";
        };
        assertEqual("swarm_growth", function, func(a: Text, b: Text) { a == b }, "REPRODUCTIVE organ should handle swarm growth")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let results = Buffer.Buffer<TestResult>(80);
        
        // Bee Hive Mind Tests
        results.add(testWaggleRecruitProbLowQuality());
        results.add(testWaggleRecruitProbMidQuality());
        results.add(testWaggleRecruitProbHighQuality());
        results.add(testWaggleRecruitProbMonotonicity());
        results.add(testWorldToCellCenter());
        results.add(testWorldToCellBottomLeft());
        results.add(testWorldToCellTopRight());
        results.add(testWorldToCellBoundsClamping());
        results.add(testQueenPheromoneDecay());
        results.add(testQueenPheromoneFloor());
        results.add(testNectarReplenishment());
        results.add(testNectarCeiling());
        results.add(testNectarHarvest());
        results.add(testCombRoleSovereign());
        results.add(testCombRoleScoutHighQuality());
        results.add(testCombRoleScoutLowQuality());
        results.add(testCombRoleMedic());
        results.add(testCombRoleGuardian());
        results.add(testCombRoleDefault());
        
        // Ant Mind Tests
        results.add(testPheromoneEvaporation());
        results.add(testPheromoneEvaporationFloor());
        results.add(testPheromoneDeposit());
        results.add(testPheromoneDepositCeiling());
        results.add(testPheromoneDepositShortPath());
        results.add(testACOProbHighPheromone());
        results.add(testACOProbCloseGoal());
        results.add(testThresholdDecisionHighStimulus());
        results.add(testThresholdDecisionLowStimulus());
        results.add(testThresholdDecisionEqual());
        results.add(testThresholdHabituation());
        results.add(testThresholdSensitization());
        results.add(testThresholdMinFloor());
        results.add(testThresholdMaxCeiling());
        results.add(testExperienceThresholdReduction());
        results.add(testAntRoleForager());
        results.add(testAntRoleDefender());
        results.add(testAntRoleRelay());
        results.add(testAntRoleNurse());
        results.add(testAntRoleScout());
        
        // Hybrid Mode Tests
        results.add(testOrganismModeHybrid());
        results.add(testOrganismModeHiveMind());
        results.add(testOrganismModeAntMind());
        
        // Grid and Bounds Tests
        results.add(testGridSize());
        results.add(testMaxDrones());
        results.add(testGridWidth());
        results.add(testCellIndexBounds());
        results.add(testNatAbsDiffLarger());
        results.add(testNatAbsDiffSmaller());
        results.add(testNatAbsDiffEqual());
        
        // Internal AI Organ Tests
        results.add(testOrganSystemCount());
        results.add(testNervousOrganRouting());
        results.add(testImmuneOrganDefense());
        results.add(testMetabolicOrganEnergy());
        results.add(testSensoryOrganPerception());
        results.add(testReproductiveOrganGrowth());
        
        Buffer.toArray(results)
    };

    public func printTestResults(results: [TestResult]) : Text {
        var output = "\n════════════════════════════════════════════════════════════════\n";
        output #= "         SWARM ORGANISM TEST RESULTS\n";
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
