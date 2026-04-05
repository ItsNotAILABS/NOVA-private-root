// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  INTERNAL AI LABS TEST SUITE                                                                              ║
// ║  Comprehensive tests for Internal AI Labs organism functionality                                          ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Buffer "mo:base/Buffer";

// Import the module under test
import InternalAILabs "../src/swarm_brain/modules/InternalAILabs";

module {
    // ═══════════════════════════════════════════════════════════════════════════════
    // TEST UTILITIES
    // ═══════════════════════════════════════════════════════════════════════════════
    
    public type TestResult = {
        name: Text;
        passed: Bool;
        message: Text;
    };

    func assertEqual<T>(expected: T, actual: T, compare: (T, T) -> Bool, name: Text) : TestResult {
        if (compare(expected, actual)) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Values not equal" }
        }
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

    public func testGoldenRatio() : TestResult {
        assertFloatClose(1.6180339887498948482, InternalAILabs.φ, 0.0000001, "Golden Ratio φ should be correct")
    };

    public func testGoldenRatioInverse() : TestResult {
        assertFloatClose(0.6180339887498948482, InternalAILabs.ψ, 0.0000001, "Inverse Golden Ratio ψ should be correct")
    };

    public func testGoldenRatioRelationship() : TestResult {
        // φ * ψ should equal 1
        let product = InternalAILabs.φ * InternalAILabs.ψ;
        assertFloatClose(1.0, product, 0.0000001, "φ * ψ should equal 1")
    };

    public func testTau() : TestResult {
        assertFloatClose(6.2831853071795864769, InternalAILabs.τ, 0.0000001, "Tau τ should be 2π")
    };

    public func testPi() : TestResult {
        assertFloatClose(3.14159265358979323846, InternalAILabs.π, 0.0000001, "Pi π should be correct")
    };

    public func testTauIsTwoPi() : TestResult {
        assertFloatClose(InternalAILabs.τ, 2.0 * InternalAILabs.π, 0.0000001, "τ should equal 2π")
    };

    public func testEulerNumber() : TestResult {
        assertFloatClose(2.71828182845904523536, InternalAILabs.e, 0.0000001, "Euler's number e should be correct")
    };

    public func testSqrt5() : TestResult {
        assertFloatClose(2.2360679774997896964, InternalAILabs.√5, 0.0000001, "√5 should be correct")
    };

    public func testGoldenAngle() : TestResult {
        // Golden angle is 137.5077 degrees in radians
        assertFloatClose(2.399963229728653, InternalAILabs.GOLDEN_ANGLE, 0.0000001, "Golden angle should be correct")
    };

    public func testFibonacciSequence() : TestResult {
        let fib = InternalAILabs.FIB;
        // Check first few Fibonacci numbers
        let isCorrect = fib[0] == 1 and fib[1] == 1 and fib[2] == 2 and 
                       fib[3] == 3 and fib[4] == 5 and fib[5] == 8 and
                       fib[6] == 13 and fib[7] == 21;
        assertTrue(isCorrect, "Fibonacci sequence should be correct")
    };

    public func testFibonacciProperty() : TestResult {
        let fib = InternalAILabs.FIB;
        // Check Fibonacci property: F(n) = F(n-1) + F(n-2) for indices 2-15
        var allValid = true;
        var i = 2;
        while (i < 16 and allValid) {
            if (fib[i] != fib[i-1] + fib[i-2]) {
                allValid := false;
            };
            i += 1;
        };
        assertTrue(allValid, "Fibonacci property F(n) = F(n-1) + F(n-2) should hold")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // INITIALIZATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testInitInternalAILabs() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        // Check that all 12 labs are created
        assertTrue(state.labs.size() == 12, "Should initialize with 12 labs")
    };

    public func testInitLabsHaveAgents() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        var allHaveAgents = true;
        for (lab in state.labs.vals()) {
            if (lab.agents.size() == 0) {
                allHaveAgents := false;
            };
        };
        assertTrue(allHaveAgents, "All labs should have at least one agent")
    };

    public func testInitTotalAgents() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        // Total agents should be 73 (8+6+7+5+8+6+7+6+5+5+6+4)
        assertEqual(73, state.totalAgents, func(a: Nat, b: Nat) { a == b }, "Total agents should be 73")
    };

    public func testInitRootNodes() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        // Should have 49 root nodes (1 core + 48 generated)
        assertTrue(state.rootNodes.size() == 49, "Should have 49 root nodes")
    };

    public func testInitCoreNode() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let coreNode = state.rootNodes[0];
        let isCore = coreNode.position.radius == 0.0 and 
                    coreNode.isJunction == true and
                    coreNode.parentId == null;
        assertTrue(isCore, "Core node should be at center with no parent")
    };

    public func testInitRootConnections() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        // Should have at least 12 ring connections + 6 cross connections = 18
        assertTrue(state.rootConnections.size() >= 18, "Should have at least 18 root connections")
    };

    public func testInitGlobalCoherence() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        assertFloatClose(0.75, state.globalCoherence, 0.01, "Initial global coherence should be 0.75")
    };

    public func testInitGlobalEfficiency() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        assertFloatClose(0.8, state.globalEfficiency, 0.01, "Initial global efficiency should be 0.8")
    };

    public func testInitStrategicAlignment() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        assertFloatClose(0.8, state.strategicAlignment, 0.01, "Initial strategic alignment should be 0.8")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // AGENT TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testAgentInitialPhase() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let firstLab = state.labs[0];
        let firstAgent = firstLab.agents[0];
        
        // Phase should be initialized using golden angle
        let expectedPhase = Float.fromInt(firstAgent.id) * InternalAILabs.GOLDEN_ANGLE;
        assertFloatClose(expectedPhase, firstAgent.phase, 0.01, "Agent phase should be initialized with golden angle")
    };

    public func testAgentInitialWeights() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let firstLab = state.labs[0];
        let firstAgent = firstLab.agents[0];
        
        // Should have 36 weights (6x6 matrix)
        assertTrue(firstAgent.weights.size() == 36, "Agent should have 36 Hebbian weights")
    };

    public func testAgentInitialActivation() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let firstLab = state.labs[0];
        let firstAgent = firstLab.agents[0];
        
        // Should have 6 activation values
        assertTrue(firstAgent.activation.size() == 6, "Agent should have 6 activation nodes")
    };

    public func testAgentIsActive() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let firstLab = state.labs[0];
        
        var allActive = true;
        for (agent in firstLab.agents.vals()) {
            if (not agent.isActive) {
                allActive := false;
            };
        };
        assertTrue(allActive, "All agents should be initially active")
    };

    public func testAgentInitialCoherence() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let firstLab = state.labs[0];
        let firstAgent = firstLab.agents[0];
        
        assertFloatClose(0.7, firstAgent.coherence, 0.01, "Agent initial coherence should be 0.7")
    };

    public func testAgentInitialProductivity() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let firstLab = state.labs[0];
        let firstAgent = firstLab.agents[0];
        
        assertFloatClose(0.8, firstAgent.productivity, 0.01, "Agent initial productivity should be 0.8")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // TASK TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testCreateTask() : TestResult {
        let task = InternalAILabs.createTask(
            #ScenarioLab,
            "Test Task",
            "A test task description",
            #Medium,
            ?1000,
            []
        );
        
        let isCorrect = task.name == "Test Task" and
                       task.description == "A test task description" and
                       task.status == #Pending and
                       task.progress == 0.0;
        assertTrue(isCorrect, "Created task should have correct properties")
    };

    public func testTaskPendingStatus() : TestResult {
        let task = InternalAILabs.createTask(
            #AnalyticsLab,
            "Analysis Task",
            "Analyze data",
            #High,
            null,
            []
        );
        
        assertTrue(task.status == #Pending, "New task should have Pending status")
    };

    public func testTaskWithDependencies() : TestResult {
        let task = InternalAILabs.createTask(
            #ResearchLab,
            "Dependent Task",
            "Depends on other tasks",
            #Low,
            ?500,
            [1, 2, 3]
        );
        
        assertTrue(task.dependsOn.size() == 3, "Task should have 3 dependencies")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // LAB TICK TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testScenarioLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let scenarioLab = state.labs[0]; // ScenarioLab is first
        
        let worldState = { tension = 0.2; complexity = 0.5 };
        let (_, maybeTask) = InternalAILabs.scenarioLabTick(scenarioLab, worldState, 0);
        
        // With low tension, should create a scenario
        switch (maybeTask) {
            case (?task) { assertTrue(true, "ScenarioLab should create task when tension is low") };
            case (null) { assertTrue(false, "ScenarioLab should have created a task") };
        }
    };

    public func testBalanceLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let balanceLab = state.labs[1]; // BalanceLab is second
        
        let metrics = { novaPower = 10.0; enemyPower = 2.0; resources = 0.1 };
        let (_, maybeTask) = InternalAILabs.balanceLabTick(balanceLab, metrics, 0);
        
        // Power ratio > 2.0 or low resources should trigger balancing
        switch (maybeTask) {
            case (?task) { assertTrue(true, "BalanceLab should create task when imbalanced") };
            case (null) { assertTrue(false, "BalanceLab should have created a task") };
        }
    };

    public func testDoctrineLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let doctrineLab = state.labs[2]; // DoctrineLab is third
        
        let combatData = { successRate = 0.3; tacticsUsed = ["alpha", "beta"] };
        let (_, maybeTask) = InternalAILabs.doctrineLabTick(doctrineLab, combatData, 0);
        
        // Low success rate should trigger doctrine review
        switch (maybeTask) {
            case (?task) { assertTrue(true, "DoctrineLab should create task when success rate is low") };
            case (null) { assertTrue(false, "DoctrineLab should have created a task") };
        }
    };

    public func testHierarchyLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let hierarchyLab = state.labs[3]; // HierarchyLab is fourth
        
        let hierarchyMetrics = { span = 8.0; latency = 0.6; coherence = 0.4 };
        let (_, maybeTask) = InternalAILabs.hierarchyLabTick(hierarchyLab, hierarchyMetrics, 0);
        
        // Wide span, high latency, or low coherence should trigger optimization
        switch (maybeTask) {
            case (?task) { assertTrue(true, "HierarchyLab should create task when hierarchy needs optimization") };
            case (null) { assertTrue(false, "HierarchyLab should have created a task") };
        }
    };

    public func testWorldLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let worldLab = state.labs[4]; // WorldLab is fifth
        
        let worldMetrics = { stability = 0.4; entropy = 0.9 };
        let (_, maybeTask) = InternalAILabs.worldLabTick(worldLab, worldMetrics, 0);
        
        // Low stability or high entropy should trigger fix
        switch (maybeTask) {
            case (?task) { assertTrue(true, "WorldLab should create task when world is unstable") };
            case (null) { assertTrue(false, "WorldLab should have created a task") };
        }
    };

    public func testResearchLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let researchLab = state.labs[5]; // ResearchLab is sixth
        
        // Beat = FIB[11] = 89 should trigger research
        let (_, maybeTask) = InternalAILabs.researchLabTick(researchLab, 89);
        
        switch (maybeTask) {
            case (?task) { assertTrue(true, "ResearchLab should create task at Fibonacci interval") };
            case (null) { assertTrue(false, "ResearchLab should have created a task at beat 89") };
        }
    };

    public func testAnalyticsLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let analyticsLab = state.labs[7]; // AnalyticsLab is 8th
        
        let (_, maybeTask) = InternalAILabs.analyticsLabTick(analyticsLab, 0.8, 0);
        
        // High data volume should trigger analysis
        switch (maybeTask) {
            case (?task) { assertTrue(true, "AnalyticsLab should create task when data volume is high") };
            case (null) { assertTrue(false, "AnalyticsLab should have created a task") };
        }
    };

    public func testStrategyLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let strategyLab = state.labs[8]; // StrategyLab is 9th
        
        let strategicContext = { threats = 0.7; opportunities = 0.8 };
        let (_, maybeTask) = InternalAILabs.strategyLabTick(strategyLab, strategicContext, 0);
        
        // High threats or opportunities should trigger planning
        switch (maybeTask) {
            case (?task) { assertTrue(true, "StrategyLab should create task when strategic context changes") };
            case (null) { assertTrue(false, "StrategyLab should have created a task") };
        }
    };

    public func testOptimizeLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let optimizeLab = state.labs[9]; // OptimizeLab is 10th
        
        let perfMetrics = { efficiency = 0.5; throughput = 0.3 };
        let (_, maybeTask) = InternalAILabs.optimizeLabTick(optimizeLab, perfMetrics, 0);
        
        // Low efficiency or throughput should trigger optimization
        switch (maybeTask) {
            case (?task) { assertTrue(true, "OptimizeLab should create task when performance is low") };
            case (null) { assertTrue(false, "OptimizeLab should have created a task") };
        }
    };

    public func testEcosystemLabTick() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        let ecoLab = state.labs[10]; // EcosystemLab is 11th
        
        let ecoMetrics = { biodiversity = 0.3; stability = 0.4 };
        let (_, maybeTask) = InternalAILabs.ecosystemLabTick(ecoLab, ecoMetrics, 0);
        
        // Low biodiversity or stability should trigger intervention
        switch (maybeTask) {
            case (?task) { assertTrue(true, "EcosystemLab should create task when ecosystem needs intervention") };
            case (null) { assertTrue(false, "EcosystemLab should have created a task") };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SOVEREIGN COUNCIL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testSovereignCouncilCrisisMeeting() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let worldContext = { crisis = true; opportunity = false; stability = 0.3 };
        let (_, maybeDecision) = InternalAILabs.sovereignCouncilMeeting(state, worldContext, 0);
        
        switch (maybeDecision) {
            case (?decision) { 
                assertTrue(decision.decisionType == "CRISIS_RESPONSE", 
                          "Council should make CRISIS_RESPONSE decision during crisis") 
            };
            case (null) { assertTrue(false, "Council should have made a decision during crisis") };
        }
    };

    public func testSovereignCouncilOpportunityMeeting() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let worldContext = { crisis = false; opportunity = true; stability = 0.8 };
        let (_, maybeDecision) = InternalAILabs.sovereignCouncilMeeting(state, worldContext, 144);
        
        // Beat 144 is FIB[12], should trigger meeting
        switch (maybeDecision) {
            case (?decision) { 
                assertTrue(decision.decisionType == "OPPORTUNITY_CAPTURE", 
                          "Council should make OPPORTUNITY_CAPTURE decision when opportunity exists") 
            };
            case (null) { assertTrue(false, "Council should have made a decision at Fibonacci beat") };
        }
    };

    public func testSovereignCouncilStabilizationMeeting() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let worldContext = { crisis = false; opportunity = false; stability = 0.3 };
        let (_, maybeDecision) = InternalAILabs.sovereignCouncilMeeting(state, worldContext, 144);
        
        switch (maybeDecision) {
            case (?decision) { 
                assertTrue(decision.decisionType == "STABILIZATION", 
                          "Council should make STABILIZATION decision when stability is low") 
            };
            case (null) { assertTrue(false, "Council should have made a decision") };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // MAIN TICK TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testTickInternalAILabs() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let worldMetrics = {
            tension = 0.5;
            stability = 0.7;
            entropy = 0.3;
            novaPower = 5.0;
            enemyPower = 5.0;
            resources = 0.5;
            dataVolume = 0.5;
            threats = 0.3;
            opportunities = 0.3;
            crisis = false;
        };
        
        let newState = InternalAILabs.tickInternalAILabs(state, worldMetrics, 1, 0.1);
        
        assertTrue(newState.currentBeat == 1, "Tick should update current beat")
    };

    public func testTickUpdatesGlobalCoherence() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let worldMetrics = {
            tension = 0.5;
            stability = 0.7;
            entropy = 0.3;
            novaPower = 5.0;
            enemyPower = 5.0;
            resources = 0.5;
            dataVolume = 0.5;
            threats = 0.3;
            opportunities = 0.3;
            crisis = false;
        };
        
        let newState = InternalAILabs.tickInternalAILabs(state, worldMetrics, 1, 0.1);
        
        // Global coherence should be recalculated (0-1 range)
        assertTrue(newState.globalCoherence >= 0.0 and newState.globalCoherence <= 1.0, 
                  "Global coherence should be in valid range after tick")
    };

    public func testTickUpdatesGlobalEfficiency() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let worldMetrics = {
            tension = 0.5;
            stability = 0.7;
            entropy = 0.3;
            novaPower = 5.0;
            enemyPower = 5.0;
            resources = 0.5;
            dataVolume = 0.5;
            threats = 0.3;
            opportunities = 0.3;
            crisis = false;
        };
        
        let newState = InternalAILabs.tickInternalAILabs(state, worldMetrics, 1, 0.1);
        
        // Efficiency = 0.7 + coherence * 0.3, so should be in [0.7, 1.0]
        assertTrue(newState.globalEfficiency >= 0.7 and newState.globalEfficiency <= 1.0, 
                  "Global efficiency should be in valid range after tick")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // QUERY FUNCTION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testGetLabStatus() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let maybeStatus = InternalAILabs.getLabStatus(state, #ScenarioLab);
        
        switch (maybeStatus) {
            case (?status) { 
                assertTrue(Text.contains(status, #text "Scenario Lab"), 
                          "Lab status should contain lab name") 
            };
            case (null) { assertTrue(false, "Should return status for valid lab") };
        }
    };

    public func testGetLabStatusInvalidLab() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        // All lab IDs should be valid in initialized state
        let maybeStatus = InternalAILabs.getLabStatus(state, #InnovationLab);
        
        switch (maybeStatus) {
            case (?_) { assertTrue(true, "Should find InnovationLab") };
            case (null) { assertTrue(false, "Should find InnovationLab in initialized state") };
        }
    };

    public func testGetGlobalStatus() : TestResult {
        let state = InternalAILabs.initInternalAILabs();
        
        let status = InternalAILabs.getGlobalStatus(state);
        
        let containsLabs = Text.contains(status, #text "Total Labs: 12");
        let containsAgents = Text.contains(status, #text "Total Agents:");
        let containsCoherence = Text.contains(status, #text "Global Coherence:");
        
        assertTrue(containsLabs and containsAgents and containsCoherence, 
                  "Global status should contain key metrics")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // EDGE CASE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testMultipleTicks() : TestResult {
        var state = InternalAILabs.initInternalAILabs();
        
        let worldMetrics = {
            tension = 0.5;
            stability = 0.7;
            entropy = 0.3;
            novaPower = 5.0;
            enemyPower = 5.0;
            resources = 0.5;
            dataVolume = 0.5;
            threats = 0.3;
            opportunities = 0.3;
            crisis = false;
        };
        
        // Run 10 ticks
        var i = 0;
        while (i < 10) {
            state := InternalAILabs.tickInternalAILabs(state, worldMetrics, i, 0.1);
            i += 1;
        };
        
        assertTrue(state.currentBeat == 9, "After 10 ticks, beat should be 9")
    };

    public func testCrisisEscalation() : TestResult {
        var state = InternalAILabs.initInternalAILabs();
        
        let crisisMetrics = {
            tension = 0.9;
            stability = 0.2;
            entropy = 0.9;
            novaPower = 2.0;
            enemyPower = 8.0;
            resources = 0.1;
            dataVolume = 0.9;
            threats = 0.9;
            opportunities = 0.1;
            crisis = true;
        };
        
        state := InternalAILabs.tickInternalAILabs(state, crisisMetrics, 0, 0.1);
        
        // During crisis, council should have made a decision
        assertTrue(state.councilDecisions.size() >= 1, "Council should make decisions during crisis")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let results = Buffer.Buffer<TestResult>(60);
        
        // Sacred Constants Tests
        results.add(testGoldenRatio());
        results.add(testGoldenRatioInverse());
        results.add(testGoldenRatioRelationship());
        results.add(testTau());
        results.add(testPi());
        results.add(testTauIsTwoPi());
        results.add(testEulerNumber());
        results.add(testSqrt5());
        results.add(testGoldenAngle());
        results.add(testFibonacciSequence());
        results.add(testFibonacciProperty());
        
        // Initialization Tests
        results.add(testInitInternalAILabs());
        results.add(testInitLabsHaveAgents());
        results.add(testInitTotalAgents());
        results.add(testInitRootNodes());
        results.add(testInitCoreNode());
        results.add(testInitRootConnections());
        results.add(testInitGlobalCoherence());
        results.add(testInitGlobalEfficiency());
        results.add(testInitStrategicAlignment());
        
        // Agent Tests
        results.add(testAgentInitialPhase());
        results.add(testAgentInitialWeights());
        results.add(testAgentInitialActivation());
        results.add(testAgentIsActive());
        results.add(testAgentInitialCoherence());
        results.add(testAgentInitialProductivity());
        
        // Task Tests
        results.add(testCreateTask());
        results.add(testTaskPendingStatus());
        results.add(testTaskWithDependencies());
        
        // Lab Tick Tests
        results.add(testScenarioLabTick());
        results.add(testBalanceLabTick());
        results.add(testDoctrineLabTick());
        results.add(testHierarchyLabTick());
        results.add(testWorldLabTick());
        results.add(testResearchLabTick());
        results.add(testAnalyticsLabTick());
        results.add(testStrategyLabTick());
        results.add(testOptimizeLabTick());
        results.add(testEcosystemLabTick());
        
        // Sovereign Council Tests
        results.add(testSovereignCouncilCrisisMeeting());
        results.add(testSovereignCouncilOpportunityMeeting());
        results.add(testSovereignCouncilStabilizationMeeting());
        
        // Main Tick Tests
        results.add(testTickInternalAILabs());
        results.add(testTickUpdatesGlobalCoherence());
        results.add(testTickUpdatesGlobalEfficiency());
        
        // Query Function Tests
        results.add(testGetLabStatus());
        results.add(testGetLabStatusInvalidLab());
        results.add(testGetGlobalStatus());
        
        // Edge Case Tests
        results.add(testMultipleTicks());
        results.add(testCrisisEscalation());
        
        Buffer.toArray(results)
    };

    public func printTestResults(results: [TestResult]) : Text {
        var output = "\n════════════════════════════════════════════════════════════════\n";
        output #= "         INTERNAL AI LABS TEST RESULTS\n";
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
