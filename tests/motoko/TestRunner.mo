// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  NOVA TEST RUNNER                                                                                         ║
// ║  Comprehensive test runner for all organism modules                                                       ║
// ║  Tests the spherical web architecture where everything serves multiple purposes                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Buffer "mo:base/Buffer";

// Import all test modules
import InternalAILabsTest "./InternalAILabsTest";
import SwarmOrganismTest "./SwarmOrganismTest";
import KuramotoEngineTest "./KuramotoEngineTest";
import HebbianPlasticityTest "./HebbianPlasticityTest";
import EmergenceCoreTest "./EmergenceCoreTest";
import FristonEngineTest "./FristonEngineTest";
import AnimalIntelligenceTest "./AnimalIntelligenceTest";
import DynamicalSystemsTest "./DynamicalSystemsTest";

actor TestRunner {

    // ═══════════════════════════════════════════════════════════════════════════════
    // TEST RESULT TYPES
    // ═══════════════════════════════════════════════════════════════════════════════

    public type TestResult = {
        name: Text;
        passed: Bool;
        message: Text;
    };

    public type TestSuiteResult = {
        suiteName: Text;
        results: [TestResult];
        passed: Nat;
        failed: Nat;
        total: Nat;
    };

    public type FullTestReport = {
        suites: [TestSuiteResult];
        totalPassed: Nat;
        totalFailed: Nat;
        totalTests: Nat;
        coverageAreas: [Text];
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN INDIVIDUAL TEST SUITES
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runInternalAILabsTests() : async TestSuiteResult {
        let results = InternalAILabsTest.runAllTests();
        var passed : Nat = 0;
        var failed : Nat = 0;
        
        for (result in results.vals()) {
            if (result.passed) { passed += 1 } else { failed += 1 };
        };
        
        {
            suiteName = "Internal AI Labs";
            results = results;
            passed = passed;
            failed = failed;
            total = results.size();
        }
    };

    public func runSwarmOrganismTests() : async TestSuiteResult {
        let results = SwarmOrganismTest.runAllTests();
        var passed : Nat = 0;
        var failed : Nat = 0;
        
        for (result in results.vals()) {
            if (result.passed) { passed += 1 } else { failed += 1 };
        };
        
        {
            suiteName = "Swarm Organism";
            results = results;
            passed = passed;
            failed = failed;
            total = results.size();
        }
    };

    public func runKuramotoEngineTests() : async TestSuiteResult {
        let results = KuramotoEngineTest.runAllTests();
        var passed : Nat = 0;
        var failed : Nat = 0;
        
        for (result in results.vals()) {
            if (result.passed) { passed += 1 } else { failed += 1 };
        };
        
        {
            suiteName = "Kuramoto Engine (Phase Synchronization)";
            results = results;
            passed = passed;
            failed = failed;
            total = results.size();
        }
    };

    public func runHebbianPlasticityTests() : async TestSuiteResult {
        let results = HebbianPlasticityTest.runAllTests();
        var passed : Nat = 0;
        var failed : Nat = 0;
        
        for (result in results.vals()) {
            if (result.passed) { passed += 1 } else { failed += 1 };
        };
        
        {
            suiteName = "Hebbian Plasticity (Synaptic Learning)";
            results = results;
            passed = passed;
            failed = failed;
            total = results.size();
        }
    };

    public func runEmergenceCoreTests() : async TestSuiteResult {
        let results = EmergenceCoreTest.runAllTests();
        var passed : Nat = 0;
        var failed : Nat = 0;
        
        for (result in results.vals()) {
            if (result.passed) { passed += 1 } else { failed += 1 };
        };
        
        {
            suiteName = "Emergence Core (Jacob's Ladder)";
            results = results;
            passed = passed;
            failed = failed;
            total = results.size();
        }
    };

    public func runFristonEngineTests() : async TestSuiteResult {
        let results = FristonEngineTest.runAllTests();
        var passed : Nat = 0;
        var failed : Nat = 0;
        
        for (result in results.vals()) {
            if (result.passed) { passed += 1 } else { failed += 1 };
        };
        
        {
            suiteName = "Friston Engine (Free Energy Principle)";
            results = results;
            passed = passed;
            failed = failed;
            total = results.size();
        }
    };

    public func runAnimalIntelligenceTests() : async TestSuiteResult {
        let results = AnimalIntelligenceTest.runAllTests();
        var passed : Nat = 0;
        var failed : Nat = 0;
        
        for (result in results.vals()) {
            if (result.passed) { passed += 1 } else { failed += 1 };
        };
        
        {
            suiteName = "Animal Intelligence (Crow, Octopus, Elephant)";
            results = results;
            passed = passed;
            failed = failed;
            total = results.size();
        }
    };

    public func runDynamicalSystemsTests() : async TestSuiteResult {
        let results = DynamicalSystemsTest.runAllTests();
        var passed : Nat = 0;
        var failed : Nat = 0;
        
        for (result in results.vals()) {
            if (result.passed) { passed += 1 } else { failed += 1 };
        };
        
        {
            suiteName = "Dynamical Systems (Attractor Dynamics, Lyapunov Stability)";
            results = results;
            passed = passed;
            failed = failed;
            total = results.size();
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : async FullTestReport {
        let aiLabsResults = await runInternalAILabsTests();
        let organismResults = await runSwarmOrganismTests();
        let kuramotoResults = await runKuramotoEngineTests();
        let hebbianResults = await runHebbianPlasticityTests();
        let emergenceResults = await runEmergenceCoreTests();
        let fristonResults = await runFristonEngineTests();
        let animalResults = await runAnimalIntelligenceTests();
        let dynamicalResults = await runDynamicalSystemsTests();
        
        let suites = [
            aiLabsResults, 
            organismResults, 
            kuramotoResults, 
            hebbianResults, 
            emergenceResults, 
            fristonResults,
            animalResults,
            dynamicalResults
        ];
        
        var totalPassed : Nat = 0;
        var totalFailed : Nat = 0;
        
        for (suite in suites.vals()) {
            totalPassed += suite.passed;
            totalFailed += suite.failed;
        };
        
        {
            suites = suites;
            totalPassed = totalPassed;
            totalFailed = totalFailed;
            totalTests = totalPassed + totalFailed;
            coverageAreas = [
                "═══ INTERNAL AI LABS ═══",
                "InternalAILabs: Sacred Constants",
                "InternalAILabs: Lab Initialization",
                "InternalAILabs: Agent Management",
                "InternalAILabs: Task Creation",
                "InternalAILabs: Lab Tick Functions",
                "InternalAILabs: Sovereign Council",
                "InternalAILabs: Main Tick",
                "InternalAILabs: Query Functions",
                
                "═══ SWARM ORGANISM ═══",
                "SwarmOrganism: Bee Hive Mind",
                "SwarmOrganism: Waggle Dance",
                "SwarmOrganism: Nectar Grid",
                "SwarmOrganism: Comb Roles",
                "SwarmOrganism: Ant Mind",
                "SwarmOrganism: ACO Algorithm",
                "SwarmOrganism: Threshold Model",
                "SwarmOrganism: Pheromone System",
                "SwarmOrganism: Organ Systems",
                
                "═══ KURAMOTO ENGINE ═══",
                "Kuramoto: Phase Constants",
                "Kuramoto: 18 Organ Frequencies",
                "Kuramoto: Order Parameter (r, ψ)",
                "Kuramoto: Beat Update",
                "Kuramoto: Adaptive Coupling",
                "Kuramoto: Phase Reset (ARES)",
                "Kuramoto: Convergence",
                
                "═══ HEBBIAN PLASTICITY ═══",
                "Hebbian: Basic Rule",
                "Hebbian: Oja's Normalization",
                "Hebbian: STDP (LTP/LTD)",
                "Hebbian: BCM Sliding Threshold",
                "Hebbian: Eligibility Traces",
                "Hebbian: Synapse Weight Bounds",
                
                "═══ EMERGENCE CORE ═══",
                "Emergence: Sacred Constants",
                "Emergence: Jacob's Ladder (11 levels)",
                "Emergence: Phase Transitions",
                "Emergence: Medina Emergence Formula",
                "Emergence: Hysteresis",
                "Emergence: Decoherence",
                "Emergence: Phase States",
                "Emergence: Landau Free Energy",
                
                "═══ FRISTON ENGINE ═══",
                "Friston: Prediction Error",
                "Friston: Complexity (KL Divergence)",
                "Friston: Inaccuracy",
                "Friston: Free Energy = Complexity + Inaccuracy",
                "Friston: Belief Update",
                "Friston: Precision (Attention)",
                "Friston: Expected Free Energy",
                "Friston: Active Inference",
                
                "═══ ANIMAL INTELLIGENCE ═══",
                "Octopus: Distributed Nervous System",
                "Octopus: Arm Dynamics",
                "Octopus: Chromatophores",
                "Octopus: Suckers & Chemoreception",
                "Elephant: Long-term Memory",
                "Elephant: Social Memory",
                "Elephant: Spatial Cognition",
                "Elephant: Infrasound Communication",
                "Crow: Meta-Learning",
                "Crow: Planning Horizon",
                "Crow: Tool Use",
                "Crow: Insight Emergence",
                
                "═══ DYNAMICAL SYSTEMS ═══",
                "Attractor: Point Attractor",
                "Attractor: Limit Cycle",
                "Attractor: Strange Attractor",
                "Attractor: Saddle Node",
                "Hopfield: Energy Function",
                "Lyapunov: Stability Certificate",
                "Lyapunov: NOVA 5D State",
                "Lyapunov: Exponents",
                "Sovereign: Stability Theorem",
                "Sovereign: Crisis Detection",
                "Basin: Region of Attraction",
                "Contraction: Analysis",
                "Barrier: Certificate"
            ];
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // GENERATE TEST REPORT
    // ═══════════════════════════════════════════════════════════════════════════════

    public func generateReport() : async Text {
        let report = await runAllTests();
        
        var output = "\n";
        output #= "╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗\n";
        output #= "║                                                                                                           ║\n";
        output #= "║                            NOVA ORGANISM TEST COVERAGE REPORT                                             ║\n";
        output #= "║                    Spherical Web Architecture - Everything Serves Multiple Purposes                       ║\n";
        output #= "║                                                                                                           ║\n";
        output #= "╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝\n\n";
        
        // Per-suite results
        for (suite in report.suites.vals()) {
            output #= "═══════════════════════════════════════════════════════════════\n";
            output #= "  " # suite.suiteName # "\n";
            output #= "═══════════════════════════════════════════════════════════════\n";
            output #= "  Passed: " # Nat.toText(suite.passed) # " / " # Nat.toText(suite.total) # "\n";
            output #= "  Failed: " # Nat.toText(suite.failed) # "\n\n";
            
            if (suite.failed > 0) {
                output #= "  Failed Tests:\n";
                for (result in suite.results.vals()) {
                    if (not result.passed) {
                        output #= "    ✗ " # result.name # ": " # result.message # "\n";
                    };
                };
                output #= "\n";
            };
        };
        
        // Summary
        output #= "═══════════════════════════════════════════════════════════════\n";
        output #= "  OVERALL SUMMARY\n";
        output #= "═══════════════════════════════════════════════════════════════\n";
        output #= "  Total Tests: " # Nat.toText(report.totalTests) # "\n";
        output #= "  Passed:      " # Nat.toText(report.totalPassed) # "\n";
        output #= "  Failed:      " # Nat.toText(report.totalFailed) # "\n";
        
        let passRate = if (report.totalTests > 0) {
            Float.fromInt(report.totalPassed) / Float.fromInt(report.totalTests) * 100.0
        } else { 0.0 };
        
        output #= "  Pass Rate:   " # Float.format(#fix 1, passRate) # "%\n\n";
        
        // Coverage areas
        output #= "═══════════════════════════════════════════════════════════════\n";
        output #= "  COVERAGE AREAS\n";
        output #= "═══════════════════════════════════════════════════════════════\n";
        for (area in report.coverageAreas.vals()) {
            if (Text.startsWith(area, #text "═══")) {
                output #= "\n" # area # "\n";
            } else {
                output #= "  ✓ " # area # "\n";
            };
        };
        
        output #= "\n╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗\n";
        output #= "║                                    END OF REPORT                                                          ║\n";
        output #= "║                      Medina Doctrine - Architecture Never Stops Extending                                 ║\n";
        output #= "╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝\n";
        
        output
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // QUICK CHECK
    // ═══════════════════════════════════════════════════════════════════════════════

    public query func ping() : async Text {
        "NOVA Organism Test Runner is operational - Testing the spherical web"
    };
}
