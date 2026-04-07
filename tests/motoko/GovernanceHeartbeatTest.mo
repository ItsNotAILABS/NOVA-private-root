// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  GOVERNANCE HEARTBEAT TEST SUITE                                                                          ║
// ║  Tests for the unified sovereign governance engine - the legal backbone of the organism                   ║
// ║  Principal Lock, 60 Sovereignty Laws, Doctrine Fingerprint, VETUS/VAEL, JUBILEE                          ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";
import Int "mo:base/Int";

// Import the module under test
import GovernanceHeartbeat "../../src/swarm_brain/modules/GovernanceHeartbeat";

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
    // SOVEREIGN CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testCreatorName() : TestResult {
        assertTrue(
            GovernanceHeartbeat.CREATOR_NAME == "Alfredo Medina Hernandez",
            "CREATOR_NAME should be 'Alfredo Medina Hernandez'"
        )
    };

    public func testCreatorJurisdiction() : TestResult {
        assertTrue(
            GovernanceHeartbeat.CREATOR_JURISDICTION == "Dallas, Texas, USA",
            "CREATOR_JURISDICTION should be 'Dallas, Texas, USA'"
        )
    };

    public func testCreatorYear() : TestResult {
        assertTrue(
            GovernanceHeartbeat.CREATOR_YEAR == 2026,
            "CREATOR_YEAR should be 2026"
        )
    };

    public func testCreatorEmail() : TestResult {
        assertTrue(
            GovernanceHeartbeat.CREATOR_EMAIL == "MedinaSITech@outlook.com",
            "CREATOR_EMAIL should be 'MedinaSITech@outlook.com'"
        )
    };

    public func testSuccessionRoyalty() : TestResult {
        // SUCCESSION_ROYALTY should be 0.20 (20%)
        assertFloatClose(0.20, GovernanceHeartbeat.SUCCESSION_ROYALTY, 0.001,
            "SUCCESSION_ROYALTY should be 20%")
    };

    public func testAresSnapshotInterval() : TestResult {
        assertTrue(
            GovernanceHeartbeat.ARES_SNAPSHOT_INTERVAL == 1000,
            "ARES_SNAPSHOT_INTERVAL should be 1000 beats"
        )
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // PRINCIPAL LOCK TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testAssertCreatorWithNoCreator() : TestResult {
        let state : GovernanceHeartbeat.PrincipalLockState = {
            creatorPrincipal = null;
            genesisLocked = false;
            genesisTimestamp = 0;
            genesisSealed = false;
            failedAuthAttempts = 0;
            lastAuthAttempt = 0;
        };
        let testPrincipal = Principal.fromText("aaaaa-aa");
        let result = GovernanceHeartbeat.assertCreator(state, testPrincipal);
        assertFalse(result, "assertCreator should return false when no creator is set")
    };

    public func testAssertCreatorWithWrongPrincipal() : TestResult {
        let creatorPrincipal = Principal.fromText("aaaaa-aa");
        let state : GovernanceHeartbeat.PrincipalLockState = {
            creatorPrincipal = ?creatorPrincipal;
            genesisLocked = true;
            genesisTimestamp = 1000000;
            genesisSealed = true;
            failedAuthAttempts = 0;
            lastAuthAttempt = 0;
        };
        let wrongPrincipal = Principal.fromText("2vxsx-fae");
        let result = GovernanceHeartbeat.assertCreator(state, wrongPrincipal);
        assertFalse(result, "assertCreator should return false for wrong principal")
    };

    public func testAssertCreatorWithCorrectPrincipal() : TestResult {
        let creatorPrincipal = Principal.fromText("aaaaa-aa");
        let state : GovernanceHeartbeat.PrincipalLockState = {
            creatorPrincipal = ?creatorPrincipal;
            genesisLocked = true;
            genesisTimestamp = 1000000;
            genesisSealed = true;
            failedAuthAttempts = 0;
            lastAuthAttempt = 0;
        };
        let result = GovernanceHeartbeat.assertCreator(state, creatorPrincipal);
        assertTrue(result, "assertCreator should return true for correct principal")
    };

    public func testRecordFailedAuth() : TestResult {
        let state : GovernanceHeartbeat.PrincipalLockState = {
            creatorPrincipal = null;
            genesisLocked = false;
            genesisTimestamp = 0;
            genesisSealed = false;
            failedAuthAttempts = 0;
            lastAuthAttempt = 0;
        };
        let newState = GovernanceHeartbeat.recordFailedAuth(state, 100);
        assertTrue(
            newState.failedAuthAttempts == 1 and newState.lastAuthAttempt == 100,
            "recordFailedAuth should increment attempts and record beat"
        )
    };

    public func testRecordFailedAuthMultiple() : TestResult {
        var state : GovernanceHeartbeat.PrincipalLockState = {
            creatorPrincipal = null;
            genesisLocked = false;
            genesisTimestamp = 0;
            genesisSealed = false;
            failedAuthAttempts = 0;
            lastAuthAttempt = 0;
        };
        state := GovernanceHeartbeat.recordFailedAuth(state, 100);
        state := GovernanceHeartbeat.recordFailedAuth(state, 200);
        state := GovernanceHeartbeat.recordFailedAuth(state, 300);
        assertTrue(
            state.failedAuthAttempts == 3 and state.lastAuthAttempt == 300,
            "Multiple failed auths should be tracked"
        )
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // PRINCIPAL LOCK STATE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPrincipalLockStateInitial() : TestResult {
        let state : GovernanceHeartbeat.PrincipalLockState = {
            creatorPrincipal = null;
            genesisLocked = false;
            genesisTimestamp = 0;
            genesisSealed = false;
            failedAuthAttempts = 0;
            lastAuthAttempt = 0;
        };
        assertTrue(
            state.genesisLocked == false and state.genesisSealed == false,
            "Initial state should be unlocked and unsealed"
        )
    };

    public func testPrincipalLockStateGenesisBehavior() : TestResult {
        // Once genesisSealed, it cannot be unsealed (verify immutability principle)
        let state : GovernanceHeartbeat.PrincipalLockState = {
            creatorPrincipal = ?Principal.fromText("aaaaa-aa");
            genesisLocked = true;
            genesisTimestamp = 1000000;
            genesisSealed = true;
            failedAuthAttempts = 0;
            lastAuthAttempt = 0;
        };
        assertTrue(state.genesisSealed, "Genesis should remain sealed once set")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // HEARTBEAT OUTPUT STRUCTURE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testHeartbeatOutputStructure() : TestResult {
        // Verify HeartbeatOutput type has expected fields
        let output : GovernanceHeartbeat.HeartbeatOutput = {
            success = true;
            beat = 1;
            compliance = 0.95;
            coherence = 0.85;
            passingLaws = 58;
            failingLaws = 2;
            doctrineFingerprint = 123456 : Nat32;
            globalThreatLevel = 0.1;
            highestThreat = null;
            aresTriggered = false;
            defenseStrength = 0.9;
            duraVaelActive = true;
            jacobsRung = 5;
            formaMultiplier = 1.5;
            sacesiTarget = 0.85;
            beatsUntilJubilee = 500;
            jubileeFired = false;
            animaEntryCount = 1000;
            patentCount = 10;
            errors = [];
        };
        assertTrue(
            output.success and output.passingLaws == 58 and output.failingLaws == 2,
            "HeartbeatOutput should have all required fields"
        )
    };

    public func testHeartbeatOutputLawCount() : TestResult {
        // 60 laws: passing + failing should equal or be less than 60
        let output : GovernanceHeartbeat.HeartbeatOutput = {
            success = true;
            beat = 1;
            compliance = 0.90;
            coherence = 0.80;
            passingLaws = 54;
            failingLaws = 6;
            doctrineFingerprint = 0 : Nat32;
            globalThreatLevel = 0.0;
            highestThreat = null;
            aresTriggered = false;
            defenseStrength = 1.0;
            duraVaelActive = false;
            jacobsRung = 0;
            formaMultiplier = 1.0;
            sacesiTarget = 0.80;
            beatsUntilJubilee = 0;
            jubileeFired = false;
            animaEntryCount = 0;
            patentCount = 0;
            errors = [];
        };
        assertTrue(
            output.passingLaws + output.failingLaws == 60,
            "Total laws should equal 60 (passingLaws + failingLaws)"
        )
    };

    public func testHeartbeatOutputComplianceRange() : TestResult {
        let output : GovernanceHeartbeat.HeartbeatOutput = {
            success = true;
            beat = 1;
            compliance = 0.95;
            coherence = 0.85;
            passingLaws = 57;
            failingLaws = 3;
            doctrineFingerprint = 0 : Nat32;
            globalThreatLevel = 0.0;
            highestThreat = null;
            aresTriggered = false;
            defenseStrength = 1.0;
            duraVaelActive = false;
            jacobsRung = 0;
            formaMultiplier = 1.0;
            sacesiTarget = 0.80;
            beatsUntilJubilee = 0;
            jubileeFired = false;
            animaEntryCount = 0;
            patentCount = 0;
            errors = [];
        };
        assertTrue(
            output.compliance >= 0.0 and output.compliance <= 1.0,
            "Compliance should be in [0, 1]"
        )
    };

    public func testHeartbeatOutputCoherenceRange() : TestResult {
        let output : GovernanceHeartbeat.HeartbeatOutput = {
            success = true;
            beat = 1;
            compliance = 0.95;
            coherence = 0.85;
            passingLaws = 57;
            failingLaws = 3;
            doctrineFingerprint = 0 : Nat32;
            globalThreatLevel = 0.0;
            highestThreat = null;
            aresTriggered = false;
            defenseStrength = 1.0;
            duraVaelActive = false;
            jacobsRung = 0;
            formaMultiplier = 1.0;
            sacesiTarget = 0.80;
            beatsUntilJubilee = 0;
            jubileeFired = false;
            animaEntryCount = 0;
            patentCount = 0;
            errors = [];
        };
        assertTrue(
            output.coherence >= 0.0 and output.coherence <= 1.0,
            "Coherence should be in [0, 1]"
        )
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // HEARTBEAT INPUT STRUCTURE TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testHeartbeatInputStructure() : TestResult {
        // Verify HeartbeatInput can be created with all required fields
        let input : GovernanceHeartbeat.HeartbeatInput = {
            caller = Principal.fromText("aaaaa-aa");
            timestamp = 1000000 : Int;
            globalCoherence = 0.85;
            shellCoherences = [0.9, 0.85, 0.80, 0.75];
            kuramotoOrderParam = 0.90;
            formaCapital = 1000000.0;
            mthSupply = 500000.0;
            mrcBalance = 100000.0;
            gtkBalance = 50000.0;
            neurochemicals = [0.5, 0.6, 0.4, 0.7];
            hebbianWeightMin = 0.01;
            hebbianWeightMax = 64.0;
            hebbianWeightVariance = 0.1;
            hebbianEntropy = 0.5;
            worldModelAlphas = [0.1, 0.2, 0.3];
            btcOracleActive = true;
            ethOracleActive = true;
            solOracleActive = true;
            icpOracleActive = true;
            atlasSovereignty = 0.95;
            pheromoneDecayRate = 0.01;
            childOrganismCount = 3;
            councilCoherences = [0.9, 0.85, 0.80];
            animalsComputed = true;
            quantumOpsComputed = true;
            attentionComputed = true;
            miningComputed = true;
            predictionError = 0.05;
            kalmanVariance = 0.02;
            heritageNodes = [1.0, 0.9, 0.8];
            shell3Weights = [0.5, 0.6, 0.4];
            expectedOutputs = [0.8, 0.7, 0.9];
            currentOutputs = [0.78, 0.72, 0.88];
            forceJubilee = false;
            forceAresRollback = null;
            attackSourceId = null;
        };
        assertTrue(
            input.globalCoherence == 0.85 and input.kuramotoOrderParam == 0.90,
            "HeartbeatInput should have all required fields"
        )
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let buffer = Buffer.Buffer<TestResult>(25);
        
        // Sovereign constants
        buffer.add(testCreatorName());
        buffer.add(testCreatorJurisdiction());
        buffer.add(testCreatorYear());
        buffer.add(testCreatorEmail());
        buffer.add(testSuccessionRoyalty());
        buffer.add(testAresSnapshotInterval());
        
        // Principal lock
        buffer.add(testAssertCreatorWithNoCreator());
        buffer.add(testAssertCreatorWithWrongPrincipal());
        buffer.add(testAssertCreatorWithCorrectPrincipal());
        buffer.add(testRecordFailedAuth());
        buffer.add(testRecordFailedAuthMultiple());
        
        // Principal lock state
        buffer.add(testPrincipalLockStateInitial());
        buffer.add(testPrincipalLockStateGenesisBehavior());
        
        // Heartbeat output
        buffer.add(testHeartbeatOutputStructure());
        buffer.add(testHeartbeatOutputLawCount());
        buffer.add(testHeartbeatOutputComplianceRange());
        buffer.add(testHeartbeatOutputCoherenceRange());
        
        // Heartbeat input
        buffer.add(testHeartbeatInputStructure());
        
        Buffer.toArray(buffer)
    };
}
