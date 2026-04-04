// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  NOVA TEST RUNNER                                                                                         ║
// ║  Main test runner canister for comprehensive test coverage                                                 ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Buffer "mo:base/Buffer";

// Import test modules
import InternalAILabsTest "./InternalAILabsTest";
import SwarmOrganismTest "./SwarmOrganismTest";

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

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : async FullTestReport {
        let aiLabsResults = await runInternalAILabsTests();
        let organismResults = await runSwarmOrganismTests();
        
        let suites = [aiLabsResults, organismResults];
        
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
                "InternalAILabs: Sacred Constants",
                "InternalAILabs: Lab Initialization",
                "InternalAILabs: Agent Management",
                "InternalAILabs: Task Creation",
                "InternalAILabs: Lab Tick Functions",
                "InternalAILabs: Sovereign Council",
                "InternalAILabs: Main Tick",
                "InternalAILabs: Query Functions",
                "SwarmOrganism: Bee Hive Mind",
                "SwarmOrganism: Waggle Dance",
                "SwarmOrganism: Nectar Grid",
                "SwarmOrganism: Comb Roles",
                "SwarmOrganism: Ant Mind",
                "SwarmOrganism: ACO Algorithm",
                "SwarmOrganism: Threshold Model",
                "SwarmOrganism: Pheromone System",
                "SwarmOrganism: Organ Systems"
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
        output #= "║                            NOVA TEST COVERAGE REPORT                                                      ║\n";
        output #= "║                                                                                                           ║\n";
        output #= "╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝\n\n";
        
        // Per-suite results
        for (suite in report.suites.vals()) {
            output #= "═══════════════════════════════════════════════════════════════\n";
            output #= "  " # suite.suiteName # " Tests\n";
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
            output #= "  ✓ " # area # "\n";
        };
        
        output #= "\n╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗\n";
        output #= "║                                    END OF REPORT                                                          ║\n";
        output #= "╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝\n";
        
        output
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // QUICK CHECK
    // ═══════════════════════════════════════════════════════════════════════════════

    public query func ping() : async Text {
        "NOVA Test Runner is operational"
    };
}
