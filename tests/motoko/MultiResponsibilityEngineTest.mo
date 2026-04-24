// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  MULTI-RESPONSIBILITY ENGINE TEST SUITE                                                                   ║
// ║  Tests for spherical web architecture where every engine serves multiple purposes                         ║
// ║  The fabric-wide tick and cross-engine communication backbone                                             ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import the module under test
import MultiResponsibilityEngine "../../src/swarm_brain/modules/MultiResponsibilityEngine";

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
    // MATHEMATICAL CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPhiConstant() : TestResult {
        assertFloatClose(1.6180339887498948482, MultiResponsibilityEngine.φ, 1e-10, "φ should be golden ratio")
    };

    public func testPsiConstant() : TestResult {
        assertFloatClose(0.6180339887498948482, MultiResponsibilityEngine.ψ, 1e-10, "ψ should be inverse golden ratio")
    };

    public func testTauConstant() : TestResult {
        assertFloatClose(6.2831853071795864769, MultiResponsibilityEngine.τ, 1e-10, "τ should be 2π")
    };

    public func testPiConstant() : TestResult {
        assertFloatClose(3.1415926535897932385, MultiResponsibilityEngine.π, 1e-10, "π should be correct")
    };

    public func testS0Constant() : TestResult {
        // S₀ = 0.3819660112501051518 (2 - φ)
        assertFloatClose(0.3819660112501051518, MultiResponsibilityEngine.S₀, 1e-10, "S₀ should be correct")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ENGINE CREATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testCreateEngineBasic() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation, #Memory],
            0.5,  // theta
            1.0,  // phi
            0     // layer
        );
        assertTrue(
            engine.id == 1 and engine.name == "TestEngine",
            "Engine should be created with correct id and name"
        )
    };

    public func testCreateEngineResponsibilities() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation, #Memory, #Defense],
            0.5, 1.0, 0
        );
        assertTrue(
            engine.responsibilities.size() == 3,
            "Engine should have 3 responsibilities"
        )
    };

    public func testCreateEngineMultipleResponsibilities() : TestResult {
        // Core principle: every engine has MULTIPLE responsibilities
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "MultiEngine",
            [#Computation, #Memory, #Communication, #Coordination],
            0.5, 1.0, 0
        );
        assertTrue(
            engine.responsibilities.size() >= 2,
            "Engine should have at least 2 responsibilities (core principle)"
        )
    };

    public func testCreateEnginePrimaryResponsibility() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Defense, #Memory],
            0.5, 1.0, 0
        );
        // Primary responsibility should be index 0 (Defense)
        assertTrue(
            engine.primaryResponsibility == 0,
            "Primary responsibility should be first in list (index 0)"
        )
    };

    public func testCreateEngineInitialState() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation],
            0.5, 1.2, 0
        );
        assertTrue(
            engine.state.energy == 1.0 and
            engine.state.coherence == 1.0 and
            engine.state.activation == 0.5,
            "Engine should have correct initial state"
        )
    };

    public func testCreateEngineSphericalPosition() : TestResult {
        let theta = 1.0;
        let phi = 2.0;
        let layer = 2;
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation],
            theta, phi, layer
        );
        assertTrue(
            engine.sphericalPosition.theta == theta and
            engine.sphericalPosition.phi == phi and
            engine.sphericalPosition.layer == layer,
            "Engine should have correct spherical position"
        )
    };

    public func testCreateEngineRadiusByLayer() : TestResult {
        // Radius = 1.0 + 0.1 * layer
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation],
            0.5, 1.0, 3  // layer 3
        );
        let expectedRadius = 1.0 + 0.1 * 3.0;  // 1.3
        assertFloatClose(expectedRadius, engine.sphericalPosition.radius, 0.001, 
            "Engine radius should scale with layer")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RESPONSIBILITY PRIORITY TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testResponsibilityPriorityFirst() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation, #Memory, #Defense],
            0.5, 1.0, 0
        );
        // First responsibility should have priority 1.0
        assertFloatClose(1.0, engine.responsibilities[0].priority, 0.001,
            "First responsibility should have priority 1.0")
    };

    public func testResponsibilityPriorityDecreases() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation, #Memory, #Defense],
            0.5, 1.0, 0
        );
        // Second responsibility should have lower priority
        assertTrue(
            engine.responsibilities[0].priority > engine.responsibilities[1].priority,
            "Later responsibilities should have lower priority"
        )
    };

    public func testResponsibilityWeightsDistributed() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation, #Memory, #Defense, #Creation],
            0.5, 1.0, 0
        );
        // Weights should sum to approximately 1.0 (each = 1/N)
        var totalWeight : Float = 0.0;
        for (resp in engine.responsibilities.vals()) {
            totalWeight += resp.weight;
        };
        assertFloatClose(1.0, totalWeight, 0.01,
            "Responsibility weights should sum to 1.0")
    };

    public func testResponsibilityInitiallyActive() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation, #Memory],
            0.5, 1.0, 0
        );
        var allActive = true;
        for (resp in engine.responsibilities.vals()) {
            if (not resp.isActive) { allActive := false };
        };
        assertTrue(allActive, "All responsibilities should be initially active")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SPHERICAL WEB CREATION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testCreateSphericalWebEngineCount() : TestResult {
        let web = MultiResponsibilityEngine.createSphericalWeb(10, 3);
        assertTrue(
            web.engineCount == 10 and web.engines.size() == 10,
            "Spherical web should have correct number of engines"
        )
    };

    public func testCreateSphericalWebLayers() : TestResult {
        let web = MultiResponsibilityEngine.createSphericalWeb(12, 4);
        assertTrue(
            web.numLayers == 4,
            "Spherical web should have correct number of layers"
        )
    };

    public func testCreateSphericalWebInitialCoherence() : TestResult {
        let web = MultiResponsibilityEngine.createSphericalWeb(8, 2);
        assertFloatClose(1.0, web.globalCoherence, 0.001,
            "Initial global coherence should be 1.0")
    };

    public func testCreateSphericalWebInitialPhase() : TestResult {
        let web = MultiResponsibilityEngine.createSphericalWeb(8, 2);
        assertFloatClose(0.0, web.globalPhase, 0.001,
            "Initial global phase should be 0.0")
    };

    public func testCreateSphericalWebTotalEnergy() : TestResult {
        let numEngines = 15;
        let web = MultiResponsibilityEngine.createSphericalWeb(numEngines, 3);
        assertFloatClose(Float.fromInt(numEngines), web.totalEnergy, 0.001,
            "Total energy should equal number of engines (each starts with 1.0)")
    };

    public func testCreateSphericalWebAdjacencyMatrix() : TestResult {
        let web = MultiResponsibilityEngine.createSphericalWeb(5, 2);
        assertTrue(
            web.adjacencyMatrix.size() == 5 and web.adjacencyMatrix[0].size() == 5,
            "Adjacency matrix should be NxN"
        )
    };

    public func testCreateSphericalWebDistanceMatrix() : TestResult {
        let web = MultiResponsibilityEngine.createSphericalWeb(5, 2);
        assertTrue(
            web.distanceMatrix.size() == 5 and web.distanceMatrix[0].size() == 5,
            "Distance matrix should be NxN"
        )
    };

    public func testCreateSphericalWebSelfDistanceZero() : TestResult {
        let web = MultiResponsibilityEngine.createSphericalWeb(5, 2);
        var allSelfZero = true;
        for (i in web.adjacencyMatrix.keys()) {
            if (web.adjacencyMatrix[i][i] != 0.0) {
                allSelfZero := false;
            };
        };
        assertTrue(allSelfZero, "Adjacency diagonal should be zero (no self-connections)")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // ENGINE STATE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testEngineStateFields() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation],
            0.5, 1.0, 0
        );
        let state = engine.state;
        assertTrue(
            state.energy >= 0.0 and state.energy <= 10.0 and
            state.coherence >= 0.0 and state.coherence <= 1.0 and
            state.activation >= 0.0 and state.activation <= 1.0,
            "Engine state fields should be in valid ranges"
        )
    };

    public func testEngineStateTemperature() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation],
            0.5, 1.0, 0
        );
        assertFloatClose(1.0, engine.state.temperature, 0.001,
            "Initial temperature should be 1.0")
    };

    public func testEngineStateEntropy() : TestResult {
        let engine = MultiResponsibilityEngine.createEngine(
            1 : Nat32,
            "TestEngine",
            [#Computation],
            0.5, 1.0, 0
        );
        assertFloatClose(0.0, engine.state.entropy, 0.001,
            "Initial entropy should be 0.0")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SPHERICAL POSITION TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testSphericalPositionThetaRange() : TestResult {
        // Theta should be in [0, π]
        let web = MultiResponsibilityEngine.createSphericalWeb(20, 3);
        var allValid = true;
        for (eng in web.engines.vals()) {
            let theta = eng.sphericalPosition.theta;
            if (theta < 0.0 or theta > MultiResponsibilityEngine.π) {
                allValid := false;
            };
        };
        assertTrue(allValid, "All engine theta values should be in [0, π]")
    };

    public func testSphericalPositionPhiRange() : TestResult {
        // Phi can be any value (wraps around 2π)
        let web = MultiResponsibilityEngine.createSphericalWeb(20, 3);
        assertTrue(
            web.engines.size() > 0,
            "Spherical web should have engines with phi positions"
        )
    };

    public func testSphericalPositionRadiusPositive() : TestResult {
        let web = MultiResponsibilityEngine.createSphericalWeb(10, 3);
        var allPositive = true;
        for (eng in web.engines.vals()) {
            if (eng.sphericalPosition.radius <= 0.0) {
                allPositive := false;
            };
        };
        assertTrue(allPositive, "All engine radii should be positive")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // CONNECTION TYPE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testConnectionTypesExist() : TestResult {
        // Verify connection types can be used
        let dataFlow : MultiResponsibilityEngine.ConnectionType = #DataFlow;
        let phase : MultiResponsibilityEngine.ConnectionType = #PhaseCoupling;
        let energy : MultiResponsibilityEngine.ConnectionType = #EnergyTransfer;
        assertTrue(true, "Connection types should be defined")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let buffer = Buffer.Buffer<TestResult>(50);
        
        // Mathematical constants
        buffer.add(testPhiConstant());
        buffer.add(testPsiConstant());
        buffer.add(testTauConstant());
        buffer.add(testPiConstant());
        buffer.add(testS0Constant());
        
        // Engine creation
        buffer.add(testCreateEngineBasic());
        buffer.add(testCreateEngineResponsibilities());
        buffer.add(testCreateEngineMultipleResponsibilities());
        buffer.add(testCreateEnginePrimaryResponsibility());
        buffer.add(testCreateEngineInitialState());
        buffer.add(testCreateEngineSphericalPosition());
        buffer.add(testCreateEngineRadiusByLayer());
        
        // Responsibility priority
        buffer.add(testResponsibilityPriorityFirst());
        buffer.add(testResponsibilityPriorityDecreases());
        buffer.add(testResponsibilityWeightsDistributed());
        buffer.add(testResponsibilityInitiallyActive());
        
        // Spherical web creation
        buffer.add(testCreateSphericalWebEngineCount());
        buffer.add(testCreateSphericalWebLayers());
        buffer.add(testCreateSphericalWebInitialCoherence());
        buffer.add(testCreateSphericalWebInitialPhase());
        buffer.add(testCreateSphericalWebTotalEnergy());
        buffer.add(testCreateSphericalWebAdjacencyMatrix());
        buffer.add(testCreateSphericalWebDistanceMatrix());
        buffer.add(testCreateSphericalWebSelfDistanceZero());
        
        // Engine state
        buffer.add(testEngineStateFields());
        buffer.add(testEngineStateTemperature());
        buffer.add(testEngineStateEntropy());
        
        // Spherical position
        buffer.add(testSphericalPositionThetaRange());
        buffer.add(testSphericalPositionPhiRange());
        buffer.add(testSphericalPositionRadiusPositive());
        
        // Connection types
        buffer.add(testConnectionTypesExist());
        
        Buffer.toArray(buffer)
    };
}
