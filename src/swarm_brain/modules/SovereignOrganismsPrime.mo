// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ============================================================================
// THREE SOVEREIGN ORGANISMS — MERIDIAN PRIME, LEXIS PRIME, PROMETHEUS PRIME
// ============================================================================
// PHASE I: Sovereign specialized organisms integrated into main substrate
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Rule: 100% of all value routes to creator reserve
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Hash "mo:base/Hash";

module SovereignOrganismsPrime {
    
    // ========================================================================
    // CREATOR DOCTRINE BLOCK — Inherited by all organisms
    // ========================================================================
    
    public type CreatorDoctrineBlock = {
        creatorName: Text;              // "Alfredo Medina Hernandez"
        creatorJurisdiction: Text;      // "Dallas, Texas, USA"
        creatorYear: Nat;               // 2026
        creatorEmail: Text;             // "MedinaSITech@outlook.com"
        doctrineHash: Nat32;            // FNV-1a hash of doctrine
        sacesiSignature: Text;          // SACESI verification
        creatorReserveRule: Float;      // 1.0 = 100%
        genesisLocked: Bool;            // Immutable after lock
    };
    
    public func initCreatorDoctrineBlock() : CreatorDoctrineBlock {
        {
            creatorName = "Alfredo Medina Hernandez";
            creatorJurisdiction = "Dallas, Texas, USA";
            creatorYear = 2026;
            creatorEmail = "MedinaSITech@outlook.com";
            doctrineHash = 2166136261;  // FNV-1a offset basis
            sacesiSignature = "SOVEREIGN-AUTONOMOUS-COGNITIVE-EMERGENT-SELF-IMPROVING";
            creatorReserveRule = 1.0;   // 100% to creator
            genesisLocked = true;
        }
    };
    
    // ========================================================================
    // MERIDIAN PRIME — Admin Interface Organism
    // ========================================================================
    // Shell A: State compression (Zero-Exposure Wall)
    // Shell B: Principal gate (creator-only, rotating challenge)
    // Shell C: Command dispatch
    // ========================================================================
    
    public type MeridianPrimeState = {
        // Shell A: State Compression
        compressedState: [Float];       // All values normalized 0-1
        stateIndices: [Nat];            // Mapping to original locations
        zeroExposureWallActive: Bool;   // Privacy protection
        lastCompressionBeat: Nat;
        
        // Shell B: Principal Gate
        principalChallenge: Nat32;      // Rotating challenge
        challengeRotationBeat: Nat;     // Beat of last rotation
        rotationInterval: Nat;          // 1000 beats
        authenticationState: Bool;      // Is creator authenticated?
        failedAttempts: Nat;
        
        // Shell C: Command Dispatch
        pendingCommands: [MeridianCommand];
        lastCommandBeat: Nat;
        commandHistory: [Nat];          // Beat numbers of executed commands
        
        // Surfaced values (read-only outputs)
        surfaces: MeridianSurfaces;
        
        // Doctrine and tracking
        doctrine: CreatorDoctrineBlock;
        beatCount: Nat;
        registeredInNova: Bool;
    };
    
    public type MeridianCommand = {
        #forceJubilee;
        #aresRollbackToK: Nat;
        #queryStableVar: Nat;
        #spawnChild: Text;
        #emergencyPause;
        #qmemReset;
        #shell3StimulusInject: [Float];
    };
    
    public type MeridianSurfaces = {
        shell3Coherence: Float;
        qsov: Float;
        councilStates: [Float];         // 7 council states
        heartbeatCount: Nat;
        cycleHealth: Float;
        jubileeCountdown: Nat;
        animaIntegrity: Float;
        treasuryIndices: [Float];       // 4 treasury indices
        last10AuditEvents: [Nat];
        predictionConfidence60: Float;
        beeSparseActivationRate: Float;
    };
    
    // State compression: normalize all values to 0-1
    public func compressState(
        shell3: [Float],
        shell12: [Float],
        councilStates: [Float],
        quantumOps: [Float]
    ) : [Float] {
        let buffer = Buffer.Buffer<Float>(200);
        
        // Normalize and add Shell 3
        for (v in shell3.vals()) {
            buffer.add(Float.min(1.0, Float.max(0.0, (v - 0.5) / 2.0)));
        };
        
        // Normalize and add Shell 12 (sample 64 values)
        for (i in shell12.keys()) {
            if (i < 64) {
                buffer.add(Float.min(1.0, Float.max(0.0, (shell12[i] - 0.5) / 2.0)));
            };
        };
        
        // Add council states
        for (v in councilStates.vals()) {
            buffer.add(Float.min(1.0, Float.max(0.0, v)));
        };
        
        // Add quantum operators
        for (v in quantumOps.vals()) {
            buffer.add(Float.min(1.0, Float.max(0.0, v / 2.0)));
        };
        
        Buffer.toArray(buffer)
    };
    
    // Principal gate: verify creator authentication
    public func verifyPrincipalGate(
        state: MeridianPrimeState,
        providedChallenge: Nat32,
        currentBeat: Nat
    ) : Bool {
        // Check if challenge matches
        if (providedChallenge != state.principalChallenge) {
            return false;
        };
        
        // Check if challenge hasn't expired
        if (currentBeat > state.challengeRotationBeat + state.rotationInterval) {
            return false;
        };
        
        true
    };
    
    // Rotate challenge
    public func rotateChallenge(state: MeridianPrimeState, currentBeat: Nat) : MeridianPrimeState {
        // Simple LCG for challenge rotation
        let newChallenge = (state.principalChallenge *% 1103515245 +% 12345) & 0x7fffffff;
        
        {
            compressedState = state.compressedState;
            stateIndices = state.stateIndices;
            zeroExposureWallActive = state.zeroExposureWallActive;
            lastCompressionBeat = state.lastCompressionBeat;
            
            principalChallenge = newChallenge;
            challengeRotationBeat = currentBeat;
            rotationInterval = state.rotationInterval;
            authenticationState = false;  // Reset auth on rotation
            failedAttempts = 0;
            
            pendingCommands = state.pendingCommands;
            lastCommandBeat = state.lastCommandBeat;
            commandHistory = state.commandHistory;
            
            surfaces = state.surfaces;
            doctrine = state.doctrine;
            beatCount = state.beatCount;
            registeredInNova = state.registeredInNova;
        }
    };
    
    // Command dispatch
    public func dispatchCommand(
        state: MeridianPrimeState,
        command: MeridianCommand,
        currentBeat: Nat
    ) : { state: MeridianPrimeState; result: Text } {
        
        // All commands require authentication
        if (not state.authenticationState) {
            return { state = state; result = "ERROR: Not authenticated" };
        };
        
        let result = switch(command) {
            case (#forceJubilee) { "JUBILEE: Forced reset initiated" };
            case (#aresRollbackToK(k)) { "ARES: Rollback to snapshot " # Nat.toText(k) };
            case (#queryStableVar(idx)) { "QUERY: Variable " # Nat.toText(idx) };
            case (#spawnChild(name)) { "SPAWN: Child organism " # name };
            case (#emergencyPause) { "PAUSE: Emergency pause activated" };
            case (#qmemReset) { "QMEM: Memory reset initiated" };
            case (#shell3StimulusInject(_)) { "INJECT: Shell 3 stimulus applied" };
        };
        
        // Add to history
        let newHistory = Array.append(state.commandHistory, [currentBeat]);
        
        {
            state = {
                compressedState = state.compressedState;
                stateIndices = state.stateIndices;
                zeroExposureWallActive = state.zeroExposureWallActive;
                lastCompressionBeat = state.lastCompressionBeat;
                principalChallenge = state.principalChallenge;
                challengeRotationBeat = state.challengeRotationBeat;
                rotationInterval = state.rotationInterval;
                authenticationState = state.authenticationState;
                failedAttempts = state.failedAttempts;
                pendingCommands = state.pendingCommands;
                lastCommandBeat = currentBeat;
                commandHistory = newHistory;
                surfaces = state.surfaces;
                doctrine = state.doctrine;
                beatCount = state.beatCount;
                registeredInNova = state.registeredInNova;
            };
            result = result;
        }
    };
    
    public func initMeridianPrime() : MeridianPrimeState {
        {
            compressedState = [];
            stateIndices = [];
            zeroExposureWallActive = true;
            lastCompressionBeat = 0;
            
            principalChallenge = 2166136261;
            challengeRotationBeat = 0;
            rotationInterval = 1000;
            authenticationState = false;
            failedAttempts = 0;
            
            pendingCommands = [];
            lastCommandBeat = 0;
            commandHistory = [];
            
            surfaces = {
                shell3Coherence = 1.0;
                qsov = 1.0;
                councilStates = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
                heartbeatCount = 0;
                cycleHealth = 1.0;
                jubileeCountdown = 1000;
                animaIntegrity = 1.0;
                treasuryIndices = [1.0, 1.0, 1.0, 1.0];
                last10AuditEvents = [];
                predictionConfidence60 = 1.0;
                beeSparseActivationRate = 0.05;
            };
            
            doctrine = initCreatorDoctrineBlock();
            beatCount = 0;
            registeredInNova = false;
        }
    };
    
    // ========================================================================
    // LEXIS PRIME — Language/Concept Processing Organism
    // ========================================================================
    // Shell A: Vocabulary engine (500 concept mappings)
    // Shell B: Context memory (50-exchange episodic buffer)
    // Shell C: Architecture synthesis
    // ========================================================================
    
    public type LexisPrimeState = {
        // Shell A: Vocabulary Engine
        vocabulary: [ConceptMapping];   // 500 concept-to-substrate mappings
        tokenizer: TokenizerState;
        patternMatcher: PatternMatchState;
        
        // Shell B: Context Memory
        episodicBuffer: [ExchangeRecord]; // Last 50 exchanges
        hebbianReinforcement: [Float];  // Reinforcement weights
        contextWindow: Nat;             // Current context size
        
        // Shell C: Architecture Synthesis
        lastSynthesisResult: SynthesisResult;
        synthesisHistory: [Nat];        // Beat numbers of syntheses
        
        // Doctrine and tracking
        doctrine: CreatorDoctrineBlock;
        beatCount: Nat;
        registeredInNova: Bool;
    };
    
    public type ConceptMapping = {
        concept: Text;                  // Plain text concept
        substrateAddress: Nat;          // Address in substrate
        mathFormula: Text;              // Mathematical representation
        implementationSpec: Text;       // How to implement
        doctrineAlignment: Float;       // 0-1 alignment score
    };
    
    public type TokenizerState = {
        tokens: [Text];
        tokenWeights: [Float];
        lastTokenizationBeat: Nat;
    };
    
    public type PatternMatchState = {
        matchedConcepts: [Nat];         // Indices into vocabulary
        matchConfidence: [Float];
        lastMatchBeat: Nat;
    };
    
    public type ExchangeRecord = {
        inputText: Text;
        matchedConcepts: [Nat];
        outputSynthesis: Text;
        beat: Nat;
    };
    
    public type SynthesisResult = {
        substrateAddress: Nat;
        mathFormula: Text;
        implementationSpec: Text;
        doctrineAlignmentScore: Float;
    };
    
    // Tokenize input text
    public func tokenize(input: Text) : [Text] {
        // Simple space-based tokenization
        let chars = Text.toArray(input);
        let buffer = Buffer.Buffer<Text>(50);
        var currentToken = "";
        
        for (c in chars.vals()) {
            if (c == ' ' or c == ',' or c == '.') {
                if (Text.size(currentToken) > 0) {
                    buffer.add(currentToken);
                    currentToken := "";
                };
            } else {
                currentToken := currentToken # Text.fromChar(c);
            };
        };
        
        if (Text.size(currentToken) > 0) {
            buffer.add(currentToken);
        };
        
        Buffer.toArray(buffer)
    };
    
    // Match tokens against vocabulary
    public func matchPatterns(
        tokens: [Text],
        vocabulary: [ConceptMapping]
    ) : { matches: [Nat]; confidences: [Float] } {
        let matchBuffer = Buffer.Buffer<Nat>(20);
        let confBuffer = Buffer.Buffer<Float>(20);
        
        for (token in tokens.vals()) {
            let lowerToken = Text.toLowercase(token);
            for (i in vocabulary.keys()) {
                let concept = vocabulary[i];
                if (Text.contains(Text.toLowercase(concept.concept), #text lowerToken)) {
                    matchBuffer.add(i);
                    confBuffer.add(concept.doctrineAlignment);
                };
            };
        };
        
        {
            matches = Buffer.toArray(matchBuffer);
            confidences = Buffer.toArray(confBuffer);
        }
    };
    
    // Synthesize architecture from matched concepts
    public func synthesizeArchitecture(
        matchedConcepts: [Nat],
        vocabulary: [ConceptMapping]
    ) : SynthesisResult {
        
        if (matchedConcepts.size() == 0) {
            return {
                substrateAddress = 0;
                mathFormula = "∅";
                implementationSpec = "No concepts matched";
                doctrineAlignmentScore = 0.0;
            };
        };
        
        // Aggregate matched concepts
        var totalAlignment : Float = 0.0;
        var primaryAddress : Nat = 0;
        var formulaBuffer = "";
        var specBuffer = "";
        
        for (idx in matchedConcepts.vals()) {
            if (idx < vocabulary.size()) {
                let concept = vocabulary[idx];
                totalAlignment += concept.doctrineAlignment;
                if (primaryAddress == 0) {
                    primaryAddress := concept.substrateAddress;
                };
                formulaBuffer := formulaBuffer # concept.mathFormula # " ∧ ";
                specBuffer := specBuffer # concept.implementationSpec # "; ";
            };
        };
        
        let avgAlignment = totalAlignment / Float.fromInt(matchedConcepts.size());
        
        {
            substrateAddress = primaryAddress;
            mathFormula = formulaBuffer;
            implementationSpec = specBuffer;
            doctrineAlignmentScore = avgAlignment;
        }
    };
    
    // Process creator text input
    public func processCreatorInput(
        state: LexisPrimeState,
        inputText: Text,
        currentBeat: Nat
    ) : { state: LexisPrimeState; result: SynthesisResult } {
        
        // Tokenize
        let tokens = tokenize(inputText);
        
        // Match patterns
        let matches = matchPatterns(tokens, state.vocabulary);
        
        // Synthesize
        let synthesis = synthesizeArchitecture(matches.matches, state.vocabulary);
        
        // Create exchange record
        let exchange : ExchangeRecord = {
            inputText = inputText;
            matchedConcepts = matches.matches;
            outputSynthesis = synthesis.implementationSpec;
            beat = currentBeat;
        };
        
        // Update episodic buffer (keep last 50)
        let newBuffer = if (state.episodicBuffer.size() >= 50) {
            let trimmed = Array.tabulate<ExchangeRecord>(49, func(i: Nat) : ExchangeRecord {
                state.episodicBuffer[i + 1]
            });
            Array.append(trimmed, [exchange])
        } else {
            Array.append(state.episodicBuffer, [exchange])
        };
        
        // Hebbian reinforcement on matched concepts
        let newReinforcement = Array.tabulate<Float>(state.hebbianReinforcement.size(), func(i: Nat) : Float {
            var r = state.hebbianReinforcement[i];
            for (matchIdx in matches.matches.vals()) {
                if (matchIdx == i) {
                    r := Float.min(2.0, r + 0.01);  // Strengthen matched
                };
            };
            r * 0.999  // Decay
        });
        
        {
            state = {
                vocabulary = state.vocabulary;
                tokenizer = {
                    tokens = tokens;
                    tokenWeights = state.tokenizer.tokenWeights;
                    lastTokenizationBeat = currentBeat;
                };
                patternMatcher = {
                    matchedConcepts = matches.matches;
                    matchConfidence = matches.confidences;
                    lastMatchBeat = currentBeat;
                };
                episodicBuffer = newBuffer;
                hebbianReinforcement = newReinforcement;
                contextWindow = state.contextWindow;
                lastSynthesisResult = synthesis;
                synthesisHistory = Array.append(state.synthesisHistory, [currentBeat]);
                doctrine = state.doctrine;
                beatCount = currentBeat;
                registeredInNova = state.registeredInNova;
            };
            result = synthesis;
        }
    };
    
    public func initLexisPrime() : LexisPrimeState {
        // Initialize with base vocabulary
        let baseVocabulary : [ConceptMapping] = [
            { concept = "coherence"; substrateAddress = 1; mathFormula = "Σ(w_ij × x_i × x_j)"; implementationSpec = "Shell 3 mean activation"; doctrineAlignment = 1.0 },
            { concept = "entropy"; substrateAddress = 2; mathFormula = "-Σ(p × log(p))"; implementationSpec = "Shannon entropy over activations"; doctrineAlignment = 1.0 },
            { concept = "emergence"; substrateAddress = 3; mathFormula = "dC/dt > θ"; implementationSpec = "Coherence derivative threshold"; doctrineAlignment = 1.0 },
            { concept = "sovereignty"; substrateAddress = 4; mathFormula = "QSOV = ∏(Q_i)^(1/n)"; implementationSpec = "Geometric mean of quantum operators"; doctrineAlignment = 1.0 },
            { concept = "doctrine"; substrateAddress = 5; mathFormula = "H(D)"; implementationSpec = "FNV-1a hash of doctrine text"; doctrineAlignment = 1.0 },
            { concept = "token"; substrateAddress = 6; mathFormula = "mint(T, 100%)"; implementationSpec = "ICRC-1 token mint to creator"; doctrineAlignment = 1.0 },
            { concept = "treasury"; substrateAddress = 7; mathFormula = "Σ(reserve_i)"; implementationSpec = "Sum of all creator reserves"; doctrineAlignment = 1.0 },
            { concept = "heartbeat"; substrateAddress = 8; mathFormula = "t += 1"; implementationSpec = "Increment beat counter"; doctrineAlignment = 1.0 },
            { concept = "shell"; substrateAddress = 9; mathFormula = "S_n = f(S_{n-1}, I)"; implementationSpec = "Layer state transition"; doctrineAlignment = 1.0 },
            { concept = "quantum"; substrateAddress = 10; mathFormula = "|ψ⟩ = Σ(α_i|i⟩)"; implementationSpec = "Quantum state superposition"; doctrineAlignment = 1.0 }
        ];
        
        {
            vocabulary = baseVocabulary;
            tokenizer = {
                tokens = [];
                tokenWeights = [];
                lastTokenizationBeat = 0;
            };
            patternMatcher = {
                matchedConcepts = [];
                matchConfidence = [];
                lastMatchBeat = 0;
            };
            episodicBuffer = [];
            hebbianReinforcement = Array.tabulate<Float>(10, func(_: Nat) : Float { 1.0 });
            contextWindow = 10;
            lastSynthesisResult = {
                substrateAddress = 0;
                mathFormula = "";
                implementationSpec = "";
                doctrineAlignmentScore = 0.0;
            };
            synthesisHistory = [];
            doctrine = initCreatorDoctrineBlock();
            beatCount = 0;
            registeredInNova = false;
        }
    };
    
    // ========================================================================
    // PROMETHEUS PRIME — Autonomous Monitoring/Recommendation Organism
    // ========================================================================
    // Shell A: Observation field (128-slot projection)
    // Shell B: Anomaly detection (z-score SPC)
    // Shell C: Recommendation engine
    // Shell D: Dispatch (tier-based execution)
    // ========================================================================
    
    public type PrometheusPrimeState = {
        // Shell A: Observation Field
        observationField: [Float];      // 128-slot projection
        rollingBaseline: [Float];       // 1000-beat rolling baseline
        baselineCount: Nat;
        
        // Shell B: Anomaly Detection
        anomalyScores: [Float];         // Z-scores per observation
        activeAnomalies: [AnomalyClass];
        anomalyThreshold: Float;        // Z > 2.0 = anomaly
        
        // Shell C: Recommendation Engine
        recommendations: [Recommendation];
        actionLibrary: [PreApprovedAction];
        
        // Shell D: Dispatch
        executedActions: [Nat];         // Beat numbers of executions
        pendingTier3Plus: [Recommendation]; // Awaiting admin approval
        
        // Doctrine and tracking
        doctrine: CreatorDoctrineBlock;
        beatCount: Nat;
        registeredInNova: Bool;
    };
    
    public type AnomalyClass = {
        #coherenceCollapse;
        #councilDivergence;
        #qsovDrift;
        #hebbianPlateau;
        #dreamStarvation;
        #neurochemicalFloorBreach;
        #predictionConfidenceCollapse;
    };
    
    public type Recommendation = {
        anomaly: AnomalyClass;
        action: PreApprovedAction;
        tier: Nat;                      // 1-5
        confidence: Float;
        beat: Nat;
    };
    
    public type PreApprovedAction = {
        #earlyJubilee;
        #shell3Stimulus;
        #qmemReset;
        #neurochemicalEscalation;
        #aresRollback;
        #councilRebalance;
        #doctrineCorrection;
        #spawn;
    };
    
    // Build 128-slot observation field
    public func buildObservationField(
        shell3: [Float],
        shell12: [Float],
        councils: [Float],
        quantumOps: [Float],
        neurochemicals: [Float]
    ) : [Float] {
        let field = Array.init<Float>(128, 1.0);
        
        // Slots 0-63: Shell 3
        for (i in shell3.keys()) {
            if (i < 64) { field[i] := shell3[i] };
        };
        
        // Slots 64-95: Shell 12 (sampled)
        for (i in shell12.keys()) {
            if (i < 32 and 64 + i < 128) { field[64 + i] := shell12[i] };
        };
        
        // Slots 96-102: Councils
        for (i in councils.keys()) {
            if (i < 7 and 96 + i < 128) { field[96 + i] := councils[i] };
        };
        
        // Slots 103-110: Quantum ops
        for (i in quantumOps.keys()) {
            if (i < 8 and 103 + i < 128) { field[103 + i] := quantumOps[i] };
        };
        
        // Slots 111-127: Neurochemicals
        for (i in neurochemicals.keys()) {
            if (i < 17 and 111 + i < 128) { field[111 + i] := neurochemicals[i] };
        };
        
        Array.freeze(field)
    };
    
    // Update rolling baseline
    public func updateBaseline(
        currentBaseline: [Float],
        newObservation: [Float],
        count: Nat
    ) : [Float] {
        // Incremental mean update
        let n = Float.fromInt(count + 1);
        Array.tabulate<Float>(128, func(i: Nat) : Float {
            let current = if (i < currentBaseline.size()) { currentBaseline[i] } else { 1.0 };
            let obs = if (i < newObservation.size()) { newObservation[i] } else { 1.0 };
            current + (obs - current) / n
        })
    };
    
    // Compute z-scores for anomaly detection
    public func computeZScores(
        observation: [Float],
        baseline: [Float],
        stdDev: Float
    ) : [Float] {
        let safeStd = Float.max(0.01, stdDev);
        Array.tabulate<Float>(128, func(i: Nat) : Float {
            let obs = if (i < observation.size()) { observation[i] } else { 1.0 };
            let base = if (i < baseline.size()) { baseline[i] } else { 1.0 };
            Float.abs(obs - base) / safeStd
        })
    };
    
    // Classify anomalies from z-scores
    public func classifyAnomalies(
        zScores: [Float],
        threshold: Float
    ) : [AnomalyClass] {
        let buffer = Buffer.Buffer<AnomalyClass>(10);
        
        // Check Shell 3 coherence (slots 0-63)
        var shell3AnomalyCount : Nat = 0;
        for (i in zScores.keys()) {
            if (i < 64 and zScores[i] > threshold) {
                shell3AnomalyCount += 1;
            };
        };
        if (shell3AnomalyCount > 10) {
            buffer.add(#coherenceCollapse);
        };
        
        // Check council divergence (slots 96-102)
        var councilDivergence : Float = 0.0;
        for (i in zScores.keys()) {
            if (i >= 96 and i < 103) {
                councilDivergence += zScores[i];
            };
        };
        if (councilDivergence > threshold * 5.0) {
            buffer.add(#councilDivergence);
        };
        
        // Check QSOV (slot 103 typically)
        if (zScores.size() > 103 and zScores[103] > threshold) {
            buffer.add(#qsovDrift);
        };
        
        Buffer.toArray(buffer)
    };
    
    // Map anomaly to recommended action
    public func mapAnomalyToAction(anomaly: AnomalyClass) : { action: PreApprovedAction; tier: Nat } {
        switch(anomaly) {
            case (#coherenceCollapse) { { action = #shell3Stimulus; tier = 1 } };
            case (#councilDivergence) { { action = #councilRebalance; tier = 3 } };
            case (#qsovDrift) { { action = #doctrineCorrection; tier = 4 } };
            case (#hebbianPlateau) { { action = #earlyJubilee; tier = 2 } };
            case (#dreamStarvation) { { action = #qmemReset; tier = 1 } };
            case (#neurochemicalFloorBreach) { { action = #neurochemicalEscalation; tier = 2 } };
            case (#predictionConfidenceCollapse) { { action = #aresRollback; tier = 3 } };
        }
    };
    
    // Run full Prometheus cycle
    public func tickPrometheus(
        state: PrometheusPrimeState,
        shell3: [Float],
        shell12: [Float],
        councils: [Float],
        quantumOps: [Float],
        neurochemicals: [Float],
        currentBeat: Nat
    ) : PrometheusPrimeState {
        
        // Build observation field
        let observation = buildObservationField(shell3, shell12, councils, quantumOps, neurochemicals);
        
        // Update baseline
        let newBaseline = updateBaseline(state.rollingBaseline, observation, state.baselineCount);
        
        // Compute standard deviation estimate
        var variance : Float = 0.0;
        for (i in observation.keys()) {
            let diff = observation[i] - newBaseline[i];
            variance += diff * diff;
        };
        let stdDev = Float.sqrt(variance / 128.0);
        
        // Compute z-scores
        let zScores = computeZScores(observation, newBaseline, stdDev);
        
        // Classify anomalies
        let anomalies = classifyAnomalies(zScores, state.anomalyThreshold);
        
        // Generate recommendations
        let recBuffer = Buffer.Buffer<Recommendation>(10);
        for (anomaly in anomalies.vals()) {
            let mapping = mapAnomalyToAction(anomaly);
            recBuffer.add({
                anomaly = anomaly;
                action = mapping.action;
                tier = mapping.tier;
                confidence = 0.8;  // Default confidence
                beat = currentBeat;
            });
        };
        let recommendations = Buffer.toArray(recBuffer);
        
        // Dispatch tier 1-2 autonomously, queue tier 3+
        let execBuffer = Buffer.Buffer<Nat>(10);
        let pendingBuffer = Buffer.Buffer<Recommendation>(10);
        
        for (rec in recommendations.vals()) {
            if (rec.tier <= 2) {
                execBuffer.add(currentBeat);
            } else {
                pendingBuffer.add(rec);
            };
        };
        
        {
            observationField = observation;
            rollingBaseline = newBaseline;
            baselineCount = state.baselineCount + 1;
            
            anomalyScores = zScores;
            activeAnomalies = anomalies;
            anomalyThreshold = state.anomalyThreshold;
            
            recommendations = recommendations;
            actionLibrary = state.actionLibrary;
            
            executedActions = Array.append(state.executedActions, Buffer.toArray(execBuffer));
            pendingTier3Plus = Array.append(state.pendingTier3Plus, Buffer.toArray(pendingBuffer));
            
            doctrine = state.doctrine;
            beatCount = currentBeat;
            registeredInNova = state.registeredInNova;
        }
    };
    
    public func initPrometheusPrime() : PrometheusPrimeState {
        {
            observationField = Array.tabulate<Float>(128, func(_: Nat) : Float { 1.0 });
            rollingBaseline = Array.tabulate<Float>(128, func(_: Nat) : Float { 1.0 });
            baselineCount = 0;
            
            anomalyScores = Array.tabulate<Float>(128, func(_: Nat) : Float { 0.0 });
            activeAnomalies = [];
            anomalyThreshold = 2.0;
            
            recommendations = [];
            actionLibrary = [
                #earlyJubilee,
                #shell3Stimulus,
                #qmemReset,
                #neurochemicalEscalation,
                #aresRollback,
                #councilRebalance,
                #doctrineCorrection,
                #spawn
            ];
            
            executedActions = [];
            pendingTier3Plus = [];
            
            doctrine = initCreatorDoctrineBlock();
            beatCount = 0;
            registeredInNova = false;
        }
    };
    
    // ========================================================================
    // NOVA REGISTRY — Tracks all organisms
    // ========================================================================
    
    public type NovaRegistryEntry = {
        organismName: Text;
        organismType: Text;             // "MERIDIAN", "LEXIS", "PROMETHEUS"
        genesisBeat: Nat;
        doctrineHash: Nat32;
        lastHeartbeat: Nat;
        isActive: Bool;
    };
    
    public func registerInNova(
        registry: [NovaRegistryEntry],
        name: Text,
        orgType: Text,
        currentBeat: Nat,
        doctrineHash: Nat32
    ) : [NovaRegistryEntry] {
        let entry : NovaRegistryEntry = {
            organismName = name;
            organismType = orgType;
            genesisBeat = currentBeat;
            doctrineHash = doctrineHash;
            lastHeartbeat = currentBeat;
            isActive = true;
        };
        Array.append(registry, [entry])
    };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  D E F E N S E   &   S E C U R I T Y   M A T H E M A T I C S
  //
  //  Enterprise-Level Security Algorithms and Threat Response
  //  Full HIM/HER Dual-Organism Protection Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // THREAT DETECTION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Anomaly score using Mahalanobis distance
  public func defenseAnomalyScore(
    observation : [Float],
    mean : [Float],
    invCovariance : [[Float]]
  ) : Float {
    let n = observation.size();
    if (n == 0 or mean.size() != n) { return 0.0 };
    
    var score : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        let diff_i = observation[i] - mean[i];
        let diff_j = observation[j] - mean[j];
        score += diff_i * invCovariance[i][j] * diff_j;
        j += 1;
      };
      i += 1;
    };
    Float.sqrt(Float.abs(score))
  };

  /// Exponential moving average for baseline
  public func defenseEMABaseline(
    current : Float,
    observation : Float,
    alpha : Float
  ) : Float {
    alpha * observation + (1.0 - alpha) * current
  };

  /// Z-score anomaly detection
  public func defenseZScoreAnomaly(
    value : Float,
    mean : Float,
    stdDev : Float
  ) : Float {
    if (stdDev < 0.0001) { 0.0 }
    else { Float.abs((value - mean) / stdDev) }
  };

  /// Threat probability from multiple indicators
  public func defenseThreatProbability(
    indicators : [Float],
    weights : [Float]
  ) : Float {
    let n = if (indicators.size() < weights.size()) indicators.size() else weights.size();
    if (n == 0) { return 0.0 };
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var i = 0;
    while (i < n) {
      weightedSum += indicators[i] * weights[i];
      totalWeight += weights[i];
      i += 1;
    };
    if (totalWeight < 0.0001) { 0.0 }
    else { weightedSum / totalWeight }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESPONSE COORDINATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Priority queue score
  public func defenseResponsePriority(
    threatLevel : Float,
    urgency : Float,
    resources : Float
  ) : Float {
    threatLevel * urgency / (resources + 0.1)
  };

  /// Resource allocation optimization
  public func defenseResourceAllocation(
    available : Float,
    demands : [Float]
  ) : [Float] {
    var totalDemand : Float = 0.0;
    var i = 0;
    while (i < demands.size()) {
      totalDemand += demands[i];
      i += 1;
    };
    if (totalDemand < 0.0001) {
      return Array.tabulate<Float>(demands.size(), func(_ : Nat) : Float { 0.0 });
    };
    Array.tabulate<Float>(demands.size(), func(j : Nat) : Float {
      available * demands[j] / totalDemand
    })
  };

  /// Cascade failure probability
  public func defenseCascadeFailureProb(
    nodeFailProb : Float,
    connectivity : Float,
    loadFactor : Float
  ) : Float {
    let amplified = nodeFailProb * (1.0 + connectivity * loadFactor);
    if (amplified > 1.0) { 1.0 } else { amplified }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CRYPTOGRAPHIC PRIMITIVES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Hash chain verification
  public func defenseHashChainVerify(
    expectedHash : Nat,
    computedHash : Nat,
    tolerance : Nat
  ) : Bool {
    let diff = if (expectedHash > computedHash) 
               expectedHash - computedHash 
               else computedHash - expectedHash;
    diff <= tolerance
  };

  /// Key derivation strength
  public func defenseKeyStrength(
    entropy : Float,
    iterations : Nat
  ) : Float {
    entropy * Float.log(Float.fromInt(iterations + 1))
  };

  /// Time-based token window
  public func defenseTokenWindow(
    currentTime : Nat,
    windowSize : Nat,
    secret : Nat
  ) : Nat {
    let window = currentTime / windowSize;
    (window * secret) % 1000000
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NETWORK SECURITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate limiting token bucket
  public func defenseTokenBucket(
    tokens : Float,
    maxTokens : Float,
    refillRate : Float,
    requested : Float,
    dt : Float
  ) : (Float, Bool) {
    let refilled = Float.min(tokens + refillRate * dt, maxTokens);
    if (refilled >= requested) {
      (refilled - requested, true)
    } else {
      (refilled, false)
    }
  };

  /// Connection trust score
  public func defenseTrustScore(
    successfulInteractions : Nat,
    failedInteractions : Nat,
    age : Nat
  ) : Float {
    let total = successfulInteractions + failedInteractions;
    if (total == 0) { return 0.5 };
    let successRate = Float.fromInt(successfulInteractions) / Float.fromInt(total);
    let ageFactor = Float.log(Float.fromInt(age + 1)) / 10.0;
    (successRate + ageFactor) / 2.0
  };

  /// DDoS detection metric
  public func defenseDDoSMetric(
    requestRate : Float,
    baseline : Float,
    variance : Float
  ) : Float {
    let deviation = (requestRate - baseline) / (Float.sqrt(variance) + 0.01);
    Float.abs(deviation)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SOVEREIGNTY PROTECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sovereignty assertion strength
  public func defenseSovereigntyStrength(
    autonomyLevel : Float,
    resourceControl : Float,
    decisionLatency : Float
  ) : Float {
    let efficiency = 1.0 / (decisionLatency + 0.01);
    autonomyLevel * resourceControl * efficiency
  };

  /// Integrity verification score
  public func defenseIntegrityScore(
    originalHash : Nat,
    currentHash : Nat,
    mutations : Nat
  ) : Float {
    let match = if (originalHash == currentHash) 1.0 else 0.0;
    let mutationPenalty = 1.0 / (Float.fromInt(mutations + 1));
    (match + mutationPenalty) / 2.0
  };

  /// Rollback safety margin
  public func defenseRollbackMargin(
    currentState : Float,
    checkpoint : Float,
    volatility : Float
  ) : Float {
    let diff = Float.abs(currentState - checkpoint);
    diff / (volatility + 0.01)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADAPTIVE IMMUNE RESPONSE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Antibody-antigen affinity
  public func defenseAffinity(
    antibody : [Float],
    antigen : [Float]
  ) : Float {
    let n = if (antibody.size() < antigen.size()) antibody.size() else antigen.size();
    if (n == 0) { return 0.0 };
    var matchScore : Float = 0.0;
    var i = 0;
    while (i < n) {
      matchScore += 1.0 - Float.abs(antibody[i] - antigen[i]);
      i += 1;
    };
    matchScore / Float.fromInt(n)
  };

  /// Clonal selection probability
  public func defenseClonalSelection(
    affinity : Float,
    temperature : Float
  ) : Float {
    Float.exp(affinity / (temperature + 0.01))
  };

  /// Memory cell formation rate
  public func defenseMemoryCellRate(
    exposureCount : Nat,
    affinitySum : Float
  ) : Float {
    let exposureFactor = Float.log(Float.fromInt(exposureCount + 1));
    affinitySum * exposureFactor
  };

}
