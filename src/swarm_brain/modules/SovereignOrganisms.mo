// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN ORGANISMS — MERIDIAN, LEXIS, PROMETHEUS PRIME
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// Three sovereign specialized organisms integrated into the substrate:
// - MERIDIAN PRIME: Admin/Command Interface with Zero-Exposure Wall
// - LEXIS PRIME: Natural Language to Substrate Mapping
// - PROMETHEUS PRIME: Autonomous Anomaly Detection & Response
//
// Each inherits full Creator Doctrine Block. Each runs its own heartbeat.
// Each is registered in NOVA registry at genesis.
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

module SovereignOrganisms {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI           : Float = 1.6180339887498948482;
  
  // MERIDIAN
  public let CHALLENGE_ROTATION : Nat = 1000;  // Beats between depth challenge rotation
  public let COMMAND_HISTORY_SIZE : Nat = 10;
  public let SURFACE_COUNT : Nat = 12;
  
  // LEXIS
  public let VOCAB_SIZE    : Nat = 500;
  public let EPISODIC_SIZE : Nat = 50;
  public let PATTERN_THRESHOLD : Float = 0.5;
  
  // PROMETHEUS
  public let OBSERVATION_SLOTS : Nat = 128;
  public let BASELINE_WINDOW : Nat = 1000;
  public let ANOMALY_CLASSES : Nat = 7;
  public let Z_SCORE_THRESHOLD : Float = 2.5;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — MERIDIAN PRIME
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Command types MERIDIAN can dispatch
  public type MeridianCommand = {
    #ForceJUBILEE;
    #ARESRollback : Nat;        // Target slot
    #QueryVar : Nat;            // Var index
    #SpawnChild;
    #EmergencyPause;
    #QMEMReset;
    #Shell3Inject : Float;      // Stimulus amount
    #SetThreshold : (Text, Float);
  };
  
  // Command execution result
  public type CommandResult = {
    command      : Text;
    success      : Bool;
    timestamp    : Nat;
    result       : Text;
  };
  
  // Shell A: State compression
  public type MeridianShellA = {
    compressedState : [Float];  // All values normalized 0-1
    compressionMap  : [(Text, Nat)];  // Name -> index
    zeroExposureActive : Bool;
    lastCompression : Nat;
  };
  
  // Shell B: Principal gate
  public type MeridianShellB = {
    depthChallenge   : Nat64;   // Current challenge hash
    challengeSalt    : Nat64;
    lastRotation     : Nat;
    authAttempts     : Nat;
    lockedOut        : Bool;
    lockoutUntil     : Nat;
  };
  
  // Shell C: Command dispatch
  public type MeridianShellC = {
    pendingCommand   : ?MeridianCommand;
    commandHistory   : [CommandResult];
    dispatchCount    : Nat;
    lastDispatch     : Nat;
  };
  
  // Surface exposures
  public type MeridianSurfaces = {
    coherence        : Float;
    qsov             : Float;
    councilStates    : [Float];
    heartbeat        : Nat;
    cycleHealth      : Float;
    jubileeCountdown : Nat;
    animaIntegrity   : Float;
    treasuryIndices  : [Float];
    lastAuditEvents  : [Text];
    predictionConfidence : Float;
    beeActivationRate : Float;
    aresStatus       : Text;
  };
  
  // Complete MERIDIAN PRIME state
  public type MeridianPrimeState = {
    shellA           : MeridianShellA;
    shellB           : MeridianShellB;
    shellC           : MeridianShellC;
    surfaces         : MeridianSurfaces;
    genesisHash      : Nat64;
    doctrineHash     : Nat64;
    registeredInNova : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — LEXIS PRIME
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Concept mapping
  public type ConceptMapping = {
    concept      : Text;        // Natural language concept
    substrateAddr: Text;        // Substrate address (e.g., "shell3.node[5]")
    mathFormula  : Text;        // Associated math formula
    doctrineScore: Float;       // Alignment with doctrine [0, 1]
    useCount     : Nat;         // How often used
  };
  
  // Query result
  public type LexisQueryResult = {
    query        : Text;
    matchedConcepts : [Text];
    substrateAddresses : [Text];
    mathFormulas : [Text];
    implementationSpec : Text;
    doctrineAlignment : Float;
    confidence   : Float;
  };
  
  // Shell A: Vocabulary engine
  public type LexisShellA = {
    conceptMappings : [ConceptMapping];
    tokenizer       : [(Text, Nat)];  // Word -> token ID
    inverseIndex    : [(Nat, [Nat])]; // Token -> concept indices
  };
  
  // Shell B: Context memory
  public type LexisShellB = {
    episodicBuffer  : [Text];   // Last 50 exchanges
    hebbianStrengths: [Float];  // Concept reinforcement
    contextVector   : [Float];  // Current context embedding
    lastContext     : Text;
  };
  
  // Shell C: Architecture synthesis
  public type LexisShellC = {
    lastQuery       : Text;
    lastResult      : ?LexisQueryResult;
    synthesisCount  : Nat;
    avgDoctrineScore: Float;
  };
  
  // Complete LEXIS PRIME state
  public type LexisPrimeState = {
    shellA           : LexisShellA;
    shellB           : LexisShellB;
    shellC           : LexisShellC;
    genesisHash      : Nat64;
    doctrineHash     : Nat64;
    registeredInNova : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — PROMETHEUS PRIME
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Anomaly class
  public type AnomalyClass = {
    #CoherenceCollapse;
    #CouncilDivergence;
    #QSOVDrift;
    #HebbianPlateau;
    #DreamStarvation;
    #NeurochemicalBreach;
    #PredictionConfidenceCollapse;
  };
  
  // Detected anomaly
  public type DetectedAnomaly = {
    class_       : AnomalyClass;
    severity     : Float;       // [0, 1]
    zScore       : Float;
    timestamp    : Nat;
    affectedVars : [Text];
  };
  
  // Action tier
  public type ActionTier = {
    #Tier1Auto;    // Execute immediately
    #Tier2Auto;    // Execute with logging
    #Tier3Gated;   // Log for admin review
    #Tier4Gated;   // Requires explicit approval
    #Tier5Gated;   // Critical - multi-sig required
  };
  
  // Recommended action
  public type RecommendedAction = {
    trigger      : DetectedAnomaly;
    action       : Text;
    tier         : ActionTier;
    executed     : Bool;
    executedAt   : ?Nat;
  };
  
  // Shell A: Observation field
  public type PrometheusShellA = {
    observationField : [Float];  // 128 slot projection
    lastObservation  : Nat;
    observationCount : Nat;
  };
  
  // Shell B: Anomaly detection
  public type PrometheusShellB = {
    baseline         : [Float];  // Rolling 1000-beat baseline
    baselineVariance : [Float];
    zScores          : [Float];
    detectedAnomalies: [DetectedAnomaly];
    anomalyHistory   : [[DetectedAnomaly]];  // Last 10 beats
  };
  
  // Shell C: Recommendation engine
  public type PrometheusShellC = {
    actionLibrary    : [(AnomalyClass, Text, ActionTier)];
    recommendations  : [RecommendedAction];
  };
  
  // Shell D: Dispatch
  public type PrometheusShellD = {
    tier1Executed    : Nat;
    tier2Executed    : Nat;
    tier3Pending     : [RecommendedAction];
    tier4Pending     : [RecommendedAction];
    tier5Pending     : [RecommendedAction];
    lastDispatch     : Nat;
  };
  
  // Complete PROMETHEUS PRIME state
  public type PrometheusPrimeState = {
    shellA           : PrometheusShellA;
    shellB           : PrometheusShellB;
    shellC           : PrometheusShellC;
    shellD           : PrometheusShellD;
    genesisHash      : Nat64;
    doctrineHash     : Nat64;
    registeredInNova : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 10) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };
  
  // Simple hash function
  public func simpleHash(input : Nat64, salt : Nat64) : Nat64 {
    let a : Nat64 = 6364136223846793005;
    let c : Nat64 = 1442695040888963407;
    let mixed = Nat64.add(Nat64.mul(a, input ^ salt), c);
    let rotated = (mixed << 17) | (mixed >> 47);
    mixed ^ rotated
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MERIDIAN PRIME OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize MERIDIAN PRIME
  public func initMeridianPrime(genesisHash : Nat64, doctrineHash : Nat64) : MeridianPrimeState {
    {
      shellA = {
        compressedState = Array.tabulate<Float>(64, func(_ : Nat) : Float { 0.5 });
        compressionMap = [];
        zeroExposureActive = true;
        lastCompression = 0;
      };
      shellB = {
        depthChallenge = simpleHash(genesisHash, doctrineHash);
        challengeSalt = doctrineHash;
        lastRotation = 0;
        authAttempts = 0;
        lockedOut = false;
        lockoutUntil = 0;
      };
      shellC = {
        pendingCommand = null;
        commandHistory = [];
        dispatchCount = 0;
        lastDispatch = 0;
      };
      surfaces = {
        coherence = 1.0;
        qsov = 1.0;
        councilStates = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
        heartbeat = 0;
        cycleHealth = 1.0;
        jubileeCountdown = 0;
        animaIntegrity = 1.0;
        treasuryIndices = [];
        lastAuditEvents = [];
        predictionConfidence = 1.0;
        beeActivationRate = 0.05;
        aresStatus = "NOMINAL";
      };
      genesisHash = genesisHash;
      doctrineHash = doctrineHash;
      registeredInNova = false;
    }
  };
  
  // Compress state to normalized values
  public func compressState(
    shellA : MeridianShellA,
    rawValues : [(Text, Float)],
    currentBeat : Nat
  ) : MeridianShellA {
    var compressed = Array.init<Float>(64, 0.5);
    var mapping = Buffer.Buffer<(Text, Nat)>(64);
    
    var i = 0;
    for ((name, value) in rawValues.vals()) {
      if (i < 64) {
        // Normalize to [0, 1]
        let normalized = clamp((value - 0.5) / 2.0 + 0.5, 0.0, 1.0);
        compressed[i] := normalized;
        mapping.add((name, i));
      };
      i += 1;
    };
    
    { shellA with
      compressedState = Array.freeze(compressed);
      compressionMap = Buffer.toArray(mapping);
      lastCompression = currentBeat;
    }
  };
  
  // Rotate depth challenge
  public func rotateChallenge(
    shellB : MeridianShellB,
    currentBeat : Nat
  ) : MeridianShellB {
    if (currentBeat < shellB.lastRotation + CHALLENGE_ROTATION) return shellB;
    
    let newChallenge = simpleHash(shellB.depthChallenge, Nat64.fromNat(currentBeat));
    
    { shellB with
      depthChallenge = newChallenge;
      lastRotation = currentBeat;
      authAttempts = 0;
    }
  };
  
  // Validate authentication
  public func validateAuth(
    shellB : MeridianShellB,
    response : Nat64,
    currentBeat : Nat
  ) : (MeridianShellB, Bool) {
    if (shellB.lockedOut and currentBeat < shellB.lockoutUntil) {
      return (shellB, false);
    };
    
    let expected = simpleHash(shellB.depthChallenge, shellB.challengeSalt);
    let valid = response == expected;
    
    if (valid) {
      ({ shellB with authAttempts = 0; lockedOut = false }, true)
    } else {
      let attempts = shellB.authAttempts + 1;
      let locked = attempts >= 3;
      ({ shellB with 
        authAttempts = attempts;
        lockedOut = locked;
        lockoutUntil = if (locked) currentBeat + 1000 else 0;
      }, false)
    }
  };
  
  // Queue command
  public func queueCommand(
    shellC : MeridianShellC,
    command : MeridianCommand
  ) : MeridianShellC {
    { shellC with pendingCommand = ?command }
  };
  
  // Execute pending command
  public func executeCommand(
    shellC : MeridianShellC,
    currentBeat : Nat
  ) : (MeridianShellC, ?CommandResult) {
    switch (shellC.pendingCommand) {
      case null { (shellC, null) };
      case (?cmd) {
        let cmdText = switch (cmd) {
          case (#ForceJUBILEE) "ForceJUBILEE";
          case (#ARESRollback(_)) "ARESRollback";
          case (#QueryVar(_)) "QueryVar";
          case (#SpawnChild) "SpawnChild";
          case (#EmergencyPause) "EmergencyPause";
          case (#QMEMReset) "QMEMReset";
          case (#Shell3Inject(_)) "Shell3Inject";
          case (#SetThreshold(_)) "SetThreshold";
        };
        
        let result : CommandResult = {
          command = cmdText;
          success = true;
          timestamp = currentBeat;
          result = "Executed";
        };
        
        // Update history
        var newHistory = Array.append(shellC.commandHistory, [result]);
        if (newHistory.size() > COMMAND_HISTORY_SIZE) {
          newHistory := Array.tabulate<CommandResult>(COMMAND_HISTORY_SIZE, func(i : Nat) : CommandResult {
            newHistory[newHistory.size() - COMMAND_HISTORY_SIZE + i]
          });
        };
        
        ({ shellC with
          pendingCommand = null;
          commandHistory = newHistory;
          dispatchCount = shellC.dispatchCount + 1;
          lastDispatch = currentBeat;
        }, ?result)
      };
    }
  };
  
  // Update surfaces
  public func updateSurfaces(
    surfaces : MeridianSurfaces,
    coherence : Float,
    qsov : Float,
    councils : [Float],
    beat : Nat,
    health : Float,
    jubilee : Nat,
    anima : Float,
    treasury : [Float],
    predConf : Float,
    beeRate : Float,
    ares : Text
  ) : MeridianSurfaces {
    { surfaces with
      coherence = coherence;
      qsov = qsov;
      councilStates = councils;
      heartbeat = beat;
      cycleHealth = health;
      jubileeCountdown = jubilee;
      animaIntegrity = anima;
      treasuryIndices = treasury;
      predictionConfidence = predConf;
      beeActivationRate = beeRate;
      aresStatus = ares;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LEXIS PRIME OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize LEXIS PRIME
  public func initLexisPrime(genesisHash : Nat64, doctrineHash : Nat64) : LexisPrimeState {
    // Initialize with 500 default concept mappings
    let defaultMappings = Array.tabulate<ConceptMapping>(VOCAB_SIZE, func(i : Nat) : ConceptMapping {
      {
        concept = "concept_" # Nat.toText(i);
        substrateAddr = "shell3.node[" # Nat.toText(i % 64) # "]";
        mathFormula = "activation[" # Nat.toText(i) # "]";
        doctrineScore = 0.8;
        useCount = 0;
      }
    });
    
    {
      shellA = {
        conceptMappings = defaultMappings;
        tokenizer = [];
        inverseIndex = [];
      };
      shellB = {
        episodicBuffer = [];
        hebbianStrengths = Array.tabulate<Float>(VOCAB_SIZE, func(_ : Nat) : Float { 1.0 });
        contextVector = Array.tabulate<Float>(64, func(_ : Nat) : Float { 0.0 });
        lastContext = "";
      };
      shellC = {
        lastQuery = "";
        lastResult = null;
        synthesisCount = 0;
        avgDoctrineScore = 0.8;
      };
      genesisHash = genesisHash;
      doctrineHash = doctrineHash;
      registeredInNova = false;
    }
  };
  
  // Tokenize query
  public func tokenizeQuery(query : Text) : [Text] {
    // Simple word splitting (in production, would be more sophisticated)
    let chars = Text.toArray(query);
    let buf = Buffer.Buffer<Text>(10);
    var current = "";
    
    for (c in chars.vals()) {
      if (c == ' ' or c == ',' or c == '.') {
        if (current != "") {
          buf.add(current);
          current := "";
        };
      } else {
        current := current # Text.fromChar(c);
      };
    };
    if (current != "") buf.add(current);
    
    Buffer.toArray(buf)
  };
  
  // Find matching concepts
  public func findMatchingConcepts(
    shellA : LexisShellA,
    tokens : [Text]
  ) : [ConceptMapping] {
    let buf = Buffer.Buffer<ConceptMapping>(10);
    
    for (token in tokens.vals()) {
      for (mapping in shellA.conceptMappings.vals()) {
        if (Text.contains(mapping.concept, #text token)) {
          buf.add(mapping);
        };
      };
    };
    
    Buffer.toArray(buf)
  };
  
  // Process query through LEXIS
  public func processLexisQuery(
    state : LexisPrimeState,
    query : Text
  ) : (LexisPrimeState, LexisQueryResult) {
    let tokens = tokenizeQuery(query);
    let matches = findMatchingConcepts(state.shellA, tokens);
    
    // Extract results
    let addresses = Array.map<ConceptMapping, Text>(matches, func(m : ConceptMapping) : Text { m.substrateAddr });
    let formulas = Array.map<ConceptMapping, Text>(matches, func(m : ConceptMapping) : Text { m.mathFormula });
    let concepts = Array.map<ConceptMapping, Text>(matches, func(m : ConceptMapping) : Text { m.concept });
    
    // Calculate doctrine alignment
    var docSum : Float = 0.0;
    for (m in matches.vals()) { docSum += m.doctrineScore };
    let avgDoc = if (matches.size() > 0) docSum / Float.fromInt(matches.size()) else 0.5;
    
    let result : LexisQueryResult = {
      query = query;
      matchedConcepts = concepts;
      substrateAddresses = addresses;
      mathFormulas = formulas;
      implementationSpec = "See matched addresses";
      doctrineAlignment = avgDoc;
      confidence = Float.fromInt(matches.size()) / 10.0;
    };
    
    // Update episodic buffer
    var newBuffer = Array.append(state.shellB.episodicBuffer, [query]);
    if (newBuffer.size() > EPISODIC_SIZE) {
      newBuffer := Array.tabulate<Text>(EPISODIC_SIZE, func(i : Nat) : Text {
        newBuffer[newBuffer.size() - EPISODIC_SIZE + i]
      });
    };
    
    let newShellB = { state.shellB with
      episodicBuffer = newBuffer;
      lastContext = query;
    };
    
    let newShellC = { state.shellC with
      lastQuery = query;
      lastResult = ?result;
      synthesisCount = state.shellC.synthesisCount + 1;
      avgDoctrineScore = (state.shellC.avgDoctrineScore * 0.99 + avgDoc * 0.01);
    };
    
    ({ state with shellB = newShellB; shellC = newShellC }, result)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PROMETHEUS PRIME OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize PROMETHEUS PRIME
  public func initPrometheusPrime(genesisHash : Nat64, doctrineHash : Nat64) : PrometheusPrimeState {
    let defaultLibrary : [(AnomalyClass, Text, ActionTier)] = [
      (#CoherenceCollapse, "Early JUBILEE", #Tier1Auto),
      (#CouncilDivergence, "Council Rebalance", #Tier3Gated),
      (#QSOVDrift, "QSOV Correction", #Tier2Auto),
      (#HebbianPlateau, "Shell3 Stimulus", #Tier2Auto),
      (#DreamStarvation, "Force Dream Cycle", #Tier1Auto),
      (#NeurochemicalBreach, "Neurochemical Escalation", #Tier2Auto),
      (#PredictionConfidenceCollapse, "QMEM Reset", #Tier2Auto),
    ];
    
    {
      shellA = {
        observationField = Array.tabulate<Float>(OBSERVATION_SLOTS, func(_ : Nat) : Float { 1.0 });
        lastObservation = 0;
        observationCount = 0;
      };
      shellB = {
        baseline = Array.tabulate<Float>(OBSERVATION_SLOTS, func(_ : Nat) : Float { 1.0 });
        baselineVariance = Array.tabulate<Float>(OBSERVATION_SLOTS, func(_ : Nat) : Float { 0.1 });
        zScores = Array.tabulate<Float>(OBSERVATION_SLOTS, func(_ : Nat) : Float { 0.0 });
        detectedAnomalies = [];
        anomalyHistory = [];
      };
      shellC = {
        actionLibrary = defaultLibrary;
        recommendations = [];
      };
      shellD = {
        tier1Executed = 0;
        tier2Executed = 0;
        tier3Pending = [];
        tier4Pending = [];
        tier5Pending = [];
        lastDispatch = 0;
      };
      genesisHash = genesisHash;
      doctrineHash = doctrineHash;
      registeredInNova = false;
    }
  };
  
  // Update observation field
  public func updateObservation(
    shellA : PrometheusShellA,
    newObservations : [Float],
    currentBeat : Nat
  ) : PrometheusShellA {
    var field = Array.init<Float>(OBSERVATION_SLOTS, 1.0);
    var i = 0;
    while (i < OBSERVATION_SLOTS and i < newObservations.size()) {
      field[i] := newObservations[i];
      i += 1;
    };
    
    { shellA with
      observationField = Array.freeze(field);
      lastObservation = currentBeat;
      observationCount = shellA.observationCount + 1;
    }
  };
  
  // Calculate z-scores
  public func calculateZScores(
    observations : [Float],
    baseline : [Float],
    variance : [Float]
  ) : [Float] {
    Array.tabulate<Float>(OBSERVATION_SLOTS, func(i : Nat) : Float {
      if (i < observations.size() and i < baseline.size() and i < variance.size()) {
        let stdDev = sqrt(variance[i] + 0.001);  // Prevent division by zero
        (observations[i] - baseline[i]) / stdDev
      } else 0.0
    })
  };
  
  // Update baseline (rolling average)
  public func updateBaseline(
    baseline : [Float],
    variance : [Float],
    observations : [Float]
  ) : ([Float], [Float]) {
    let alpha = 0.001;  // Slow adaptation
    
    let newBaseline = Array.tabulate<Float>(OBSERVATION_SLOTS, func(i : Nat) : Float {
      if (i < baseline.size() and i < observations.size()) {
        baseline[i] * (1.0 - alpha) + observations[i] * alpha
      } else 1.0
    });
    
    let newVariance = Array.tabulate<Float>(OBSERVATION_SLOTS, func(i : Nat) : Float {
      if (i < variance.size() and i < observations.size() and i < newBaseline.size()) {
        let diff = observations[i] - newBaseline[i];
        variance[i] * (1.0 - alpha) + diff * diff * alpha
      } else 0.1
    });
    
    (newBaseline, newVariance)
  };
  
  // Detect anomalies from z-scores
  public func detectAnomalies(
    zScores : [Float],
    currentBeat : Nat
  ) : [DetectedAnomaly] {
    let buf = Buffer.Buffer<DetectedAnomaly>(ANOMALY_CLASSES);
    
    // Check each anomaly class
    // Index 0: Coherence
    if (zScores.size() > 0 and abs(zScores[0]) > Z_SCORE_THRESHOLD) {
      buf.add({
        class_ = #CoherenceCollapse;
        severity = clamp(abs(zScores[0]) / 5.0, 0.0, 1.0);
        zScore = zScores[0];
        timestamp = currentBeat;
        affectedVars = ["coherence"];
      });
    };
    
    // Index 1: Council divergence
    if (zScores.size() > 1 and abs(zScores[1]) > Z_SCORE_THRESHOLD) {
      buf.add({
        class_ = #CouncilDivergence;
        severity = clamp(abs(zScores[1]) / 5.0, 0.0, 1.0);
        zScore = zScores[1];
        timestamp = currentBeat;
        affectedVars = ["council"];
      });
    };
    
    // Index 2: QSOV
    if (zScores.size() > 2 and abs(zScores[2]) > Z_SCORE_THRESHOLD) {
      buf.add({
        class_ = #QSOVDrift;
        severity = clamp(abs(zScores[2]) / 5.0, 0.0, 1.0);
        zScore = zScores[2];
        timestamp = currentBeat;
        affectedVars = ["qsov"];
      });
    };
    
    // Index 3: Hebbian
    if (zScores.size() > 3 and zScores[3] < -Z_SCORE_THRESHOLD) {  // Plateau = low activity
      buf.add({
        class_ = #HebbianPlateau;
        severity = clamp(abs(zScores[3]) / 5.0, 0.0, 1.0);
        zScore = zScores[3];
        timestamp = currentBeat;
        affectedVars = ["hebbian"];
      });
    };
    
    // Index 4: Dream
    if (zScores.size() > 4 and zScores[4] > Z_SCORE_THRESHOLD) {
      buf.add({
        class_ = #DreamStarvation;
        severity = clamp(abs(zScores[4]) / 5.0, 0.0, 1.0);
        zScore = zScores[4];
        timestamp = currentBeat;
        affectedVars = ["dream"];
      });
    };
    
    // Index 5: Neurochemical
    if (zScores.size() > 5 and abs(zScores[5]) > Z_SCORE_THRESHOLD) {
      buf.add({
        class_ = #NeurochemicalBreach;
        severity = clamp(abs(zScores[5]) / 5.0, 0.0, 1.0);
        zScore = zScores[5];
        timestamp = currentBeat;
        affectedVars = ["neurochemical"];
      });
    };
    
    // Index 6: Prediction
    if (zScores.size() > 6 and zScores[6] < -Z_SCORE_THRESHOLD) {
      buf.add({
        class_ = #PredictionConfidenceCollapse;
        severity = clamp(abs(zScores[6]) / 5.0, 0.0, 1.0);
        zScore = zScores[6];
        timestamp = currentBeat;
        affectedVars = ["prediction"];
      });
    };
    
    Buffer.toArray(buf)
  };
  
  // Generate recommendations from anomalies
  public func generateRecommendations(
    shellC : PrometheusShellC,
    anomalies : [DetectedAnomaly]
  ) : [RecommendedAction] {
    let buf = Buffer.Buffer<RecommendedAction>(anomalies.size());
    
    for (anomaly in anomalies.vals()) {
      for ((class_, action, tier) in shellC.actionLibrary.vals()) {
        if (anomalyClassEquals(anomaly.class_, class_)) {
          buf.add({
            trigger = anomaly;
            action = action;
            tier = tier;
            executed = false;
            executedAt = null;
          });
        };
      };
    };
    
    Buffer.toArray(buf)
  };
  
  // Helper: compare anomaly classes
  public func anomalyClassEquals(a : AnomalyClass, b : AnomalyClass) : Bool {
    switch (a, b) {
      case (#CoherenceCollapse, #CoherenceCollapse) true;
      case (#CouncilDivergence, #CouncilDivergence) true;
      case (#QSOVDrift, #QSOVDrift) true;
      case (#HebbianPlateau, #HebbianPlateau) true;
      case (#DreamStarvation, #DreamStarvation) true;
      case (#NeurochemicalBreach, #NeurochemicalBreach) true;
      case (#PredictionConfidenceCollapse, #PredictionConfidenceCollapse) true;
      case _ false;
    }
  };
  
  // Dispatch actions by tier
  public func dispatchActions(
    shellD : PrometheusShellD,
    recommendations : [RecommendedAction],
    currentBeat : Nat
  ) : PrometheusShellD {
    var tier1 = shellD.tier1Executed;
    var tier2 = shellD.tier2Executed;
    var tier3 = shellD.tier3Pending;
    var tier4 = shellD.tier4Pending;
    var tier5 = shellD.tier5Pending;
    
    for (rec in recommendations.vals()) {
      switch (rec.tier) {
        case (#Tier1Auto) { tier1 += 1 };
        case (#Tier2Auto) { tier2 += 1 };
        case (#Tier3Gated) { tier3 := Array.append(tier3, [rec]) };
        case (#Tier4Gated) { tier4 := Array.append(tier4, [rec]) };
        case (#Tier5Gated) { tier5 := Array.append(tier5, [rec]) };
      };
    };
    
    { shellD with
      tier1Executed = tier1;
      tier2Executed = tier2;
      tier3Pending = tier3;
      tier4Pending = tier4;
      tier5Pending = tier5;
      lastDispatch = currentBeat;
    }
  };
  
  // Full PROMETHEUS update
  public func updatePrometheusPrime(
    state : PrometheusPrimeState,
    observations : [Float],
    currentBeat : Nat
  ) : PrometheusPrimeState {
    // Update observations
    let newShellA = updateObservation(state.shellA, observations, currentBeat);
    
    // Update baseline
    let (newBaseline, newVariance) = updateBaseline(
      state.shellB.baseline,
      state.shellB.baselineVariance,
      observations
    );
    
    // Calculate z-scores
    let zScores = calculateZScores(observations, newBaseline, newVariance);
    
    // Detect anomalies
    let anomalies = detectAnomalies(zScores, currentBeat);
    
    let newShellB = { state.shellB with
      baseline = newBaseline;
      baselineVariance = newVariance;
      zScores = zScores;
      detectedAnomalies = anomalies;
    };
    
    // Generate recommendations
    let recommendations = generateRecommendations(state.shellC, anomalies);
    let newShellC = { state.shellC with recommendations = recommendations };
    
    // Dispatch actions
    let newShellD = dispatchActions(state.shellD, recommendations, currentBeat);
    
    { state with
      shellA = newShellA;
      shellB = newShellB;
      shellC = newShellC;
      shellD = newShellD;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getMeridianDiagnostics(state : MeridianPrimeState) : {
    challengeAge : Nat;
    commandCount : Nat;
    zeroExposure : Bool;
    lockedOut : Bool;
    surfaceCoherence : Float;
  } {
    {
      challengeAge = state.surfaces.heartbeat - state.shellB.lastRotation;
      commandCount = state.shellC.dispatchCount;
      zeroExposure = state.shellA.zeroExposureActive;
      lockedOut = state.shellB.lockedOut;
      surfaceCoherence = state.surfaces.coherence;
    }
  };
  
  public func getLexisDiagnostics(state : LexisPrimeState) : {
    vocabSize : Nat;
    episodicCount : Nat;
    synthesisCount : Nat;
    avgDoctrine : Float;
  } {
    {
      vocabSize = state.shellA.conceptMappings.size();
      episodicCount = state.shellB.episodicBuffer.size();
      synthesisCount = state.shellC.synthesisCount;
      avgDoctrine = state.shellC.avgDoctrineScore;
    }
  };
  
  public func getPrometheusDiagnostics(state : PrometheusPrimeState) : {
    observationCount : Nat;
    activeAnomalies : Nat;
    tier1Executed : Nat;
    tier2Executed : Nat;
    pendingActions : Nat;
  } {
    {
      observationCount = state.shellA.observationCount;
      activeAnomalies = state.shellB.detectedAnomalies.size();
      tier1Executed = state.shellD.tier1Executed;
      tier2Executed = state.shellD.tier2Executed;
      pendingActions = state.shellD.tier3Pending.size() + 
                      state.shellD.tier4Pending.size() + 
                      state.shellD.tier5Pending.size();
    }
  };
};
