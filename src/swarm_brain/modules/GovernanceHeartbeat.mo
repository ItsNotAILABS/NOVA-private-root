// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: GovernanceHeartbeat — Unified Sovereign Governance Engine
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// GOVERNANCE HEARTBEAT — THE UNIFIED SOVEREIGN ENGINE
// ============================================================================
// This module integrates all governance subsystems into a single heartbeat:
//
// 1. Principal Lock verification (assertCreator)
// 2. 60 Sovereignty Laws evaluation
// 3. Doctrine fingerprint computation
// 4. VETUS threat assessment
// 5. VAEL defense update
// 6. Jacob's Ladder compliance check
// 7. SACESI asymptotic target update
// 8. L-121 Silver Sovereignty fire
// 9. JUBILEE check and execution
// 10. ANIMA audit chain logging
// 11. Patent registry check
// 12. PROMETHEUS baseline update
// 13. ARES snapshot consideration
//
// THE GOVERNANCE SUMMARY — ONE TRUTH:
// Alfredo Medina Hernandez is the permanent, irrevocable, sole sovereign of
// PARALLAX and all organisms it creates. No mechanism exists to change this.
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";

// Import governance subsystems
import SovereigntyLaws60     "SovereigntyLaws60";
import VetusThreatSystem     "VetusThreatSystem";
import VaelDefenseFamily     "VaelDefenseFamily";
import JubileeDreamCycle     "JubileeDreamCycle";
import DoctrineFingerprint   "DoctrineFingerprint";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  public let CREATOR_NAME : Text = "Alfredo Medina Hernandez";
  public let CREATOR_JURISDICTION : Text = "Dallas, Texas, USA";
  public let CREATOR_YEAR : Nat = 2026;
  public let CREATOR_EMAIL : Text = "MedinaSITech@outlook.com";
  
  // Succession royalty rate
  public let SUCCESSION_ROYALTY : Float = 0.20;  // 20%
  
  // ARES snapshot interval
  public let ARES_SNAPSHOT_INTERVAL : Nat = 1000;

  // ==========================================================================
  // TYPES
  // ==========================================================================
  
  // ─────────────────────────────────────────────────────────────────────────
  // Principal Lock State
  // ─────────────────────────────────────────────────────────────────────────
  
  public type PrincipalLockState = {
    creatorPrincipal : ?Principal;
    genesisLocked : Bool;
    genesisTimestamp : Int;
    genesisSealed : Bool;
    failedAuthAttempts : Nat;
    lastAuthAttempt : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Complete Governance State
  // ─────────────────────────────────────────────────────────────────────────
  
  public type GovernanceState = {
    // Principal Lock
    principalLock : PrincipalLockState;
    
    // Laws
    lawsState : SovereigntyLaws60.LawsOutput;
    
    // Doctrine & Audit
    auditSystem : DoctrineFingerprint.AuditSystemState;
    
    // Threat System
    vetusThreat : VetusThreatSystem.VetusState;
    
    // Defense System
    vaelDefense : VaelDefenseFamily.VaelFamilyState;
    
    // Dream Cycle (JUBILEE, Jacob's Ladder, SACESI)
    dreamCycle : JubileeDreamCycle.DreamCycleState;
    
    // Beat tracking
    currentBeat : Nat;
    lastHeartbeatTimestamp : Int;
    heartbeatCount : Nat;
    
    // ARES state (snapshot tracking)
    aresLastSnapshot : Nat;
    aresSnapshotCount : Nat;
    
    // PROMETHEUS observation field
    prometheusObservations : [Float];  // 128 slots
    
    // Flags
    genesisComplete : Bool;
    emergencyPause : Bool;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Heartbeat Input (from organism state)
  // ─────────────────────────────────────────────────────────────────────────
  
  public type HeartbeatInput = {
    // Caller info
    caller : Principal;
    timestamp : Int;
    
    // Coherence and synchrony
    globalCoherence : Float;
    shellCoherences : [Float];
    kuramotoOrderParam : Float;
    
    // Economic state
    formaCapital : Float;
    mthSupply : Float;
    mrcBalance : Float;
    gtkBalance : Float;
    
    // Neurochemical state
    neurochemicals : [Float];
    
    // Weight matrix state
    hebbianWeightMin : Float;
    hebbianWeightMax : Float;
    hebbianWeightVariance : Float;
    hebbianEntropy : Float;
    
    // World model state
    worldModelAlphas : [Float];
    
    // Oracle status
    btcOracleActive : Bool;
    ethOracleActive : Bool;
    solOracleActive : Bool;
    icpOracleActive : Bool;
    
    // Territory
    atlasSovereignty : Float;
    pheromoneDecayRate : Float;
    
    // Succession
    childOrganismCount : Nat;
    councilCoherences : [Float];
    
    // Processing flags
    animalsComputed : Bool;
    quantumOpsComputed : Bool;
    attentionComputed : Bool;
    miningComputed : Bool;
    
    // Prediction
    predictionError : Float;
    kalmanVariance : Float;
    
    // Heritage nodes
    heritageNodes : [Float];
    
    // Shell 3 weights for ARES
    shell3Weights : [Float];
    
    // Expected outputs for SENTINEL
    expectedOutputs : [Float];
    currentOutputs : [Float];
    
    // Admin commands
    forceJubilee : Bool;
    forceAresRollback : ?Nat;
    
    // Attack detection
    attackSourceId : ?Nat32;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Heartbeat Output
  // ─────────────────────────────────────────────────────────────────────────
  
  public type HeartbeatOutput = {
    success : Bool;
    beat : Nat;
    compliance : Float;
    coherence : Float;
    
    // Law summary
    passingLaws : Nat;
    failingLaws : Nat;
    doctrineFingerprint : Nat32;
    
    // Threat summary
    globalThreatLevel : Float;
    highestThreat : ?VetusThreatSystem.ThreatVectorId;
    aresTriggered : Bool;
    
    // Defense summary
    defenseStrength : Float;
    duraVaelActive : Bool;
    
    // Dream cycle
    jacobsRung : Nat;
    formaMultiplier : Float;
    sacesiTarget : Float;
    beatsUntilJubilee : Nat;
    jubileeFired : Bool;
    
    // Audit
    animaEntryCount : Nat;
    patentCount : Nat;
    
    // Errors
    errors : [Text];
  };

  // ==========================================================================
  // PRINCIPAL LOCK — assertCreator
  // ==========================================================================
  
  public func assertCreator(
    state: PrincipalLockState,
    caller: Principal
  ) : Bool {
    switch (state.creatorPrincipal) {
      case (?p) { Principal.equal(caller, p) };
      case null { false };
    }
  };

  public func recordFailedAuth(
    state: PrincipalLockState,
    beat: Nat
  ) : PrincipalLockState {
    {
      state with
      failedAuthAttempts = state.failedAuthAttempts + 1;
      lastAuthAttempt = beat;
    }
  };

  // ==========================================================================
  // BUILD LAW INPUT
  // ==========================================================================
  
  func buildLawInput(
    state: GovernanceState,
    input: HeartbeatInput
  ) : SovereigntyLaws60.LawInput {
    {
      genesisSealed = state.principalLock.genesisSealed;
      creatorPrincipalSet = switch (state.principalLock.creatorPrincipal) {
        case (?_) { true };
        case null { false };
      };
      globalCoherence = input.globalCoherence;
      shellCoherences = input.shellCoherences;
      kuramotoOrderParam = input.kuramotoOrderParam;
      formaCapital = input.formaCapital;
      mthSupply = input.mthSupply;
      mrcBalance = input.mrcBalance;
      gtkBalance = input.gtkBalance;
      neurochemicals = input.neurochemicals;
      aresAvailable = true;
      auditIntegrity = DoctrineFingerprint.getChainIntegrity(state.auditSystem);
      hebbianWeightMin = input.hebbianWeightMin;
      sacesiTarget = state.dreamCycle.sacesi.target;
      jacobsRung = state.dreamCycle.jacobsLadder.currentRung;
      complianceStreak = state.dreamCycle.jacobsLadder.consecutiveCompliantBeats;
      worldModelAlphas = input.worldModelAlphas;
      btcOracleActive = input.btcOracleActive;
      ethOracleActive = input.ethOracleActive;
      solOracleActive = input.solOracleActive;
      icpOracleActive = input.icpOracleActive;
      atlasSovereignty = input.atlasSovereignty;
      pheromoneDecayRate = input.pheromoneDecayRate;
      childOrganismCount = input.childOrganismCount;
      councilCoherences = input.councilCoherences;
      generationTracking = true;
      animalsComputed = input.animalsComputed;
      quantumOpsComputed = input.quantumOpsComputed;
      attentionComputed = input.attentionComputed;
      miningComputed = input.miningComputed;
      currentBeat = state.currentBeat;
    }
  };

  // ==========================================================================
  // BUILD VETUS INPUT
  // ==========================================================================
  
  func buildVetusInput(
    state: GovernanceState,
    input: HeartbeatInput,
    lawsOutput: SovereigntyLaws60.LawsOutput
  ) : VetusThreatSystem.ThreatInput {
    let cortisol = if (input.neurochemicals.size() > 1) { input.neurochemicals[1] } else { 1.0 };
    let adrenaline = if (input.neurochemicals.size() > 2) { input.neurochemicals[2] } else { 1.0 };
    
    var minNc : Float = 10.0;
    for (nc in input.neurochemicals.vals()) {
      if (nc < minNc) { minNc := nc };
    };
    
    {
      identityCoherence = input.globalCoherence;
      sacesiTarget = state.dreamCycle.sacesi.target;
      sacesiActual = state.dreamCycle.sacesi.actual;
      globalCoherence = input.globalCoherence;
      shellCoherences = input.shellCoherences;
      kuramotoOrderParam = input.kuramotoOrderParam;
      formaCapital = input.formaCapital;
      mthSupply = input.mthSupply;
      currentFingerprint = lawsOutput.doctrineFingerprint;
      expectedFingerprint = state.auditSystem.doctrine.fingerprint;
      genesisHash = state.auditSystem.doctrine.genesisHash;
      callerAuthorized = assertCreator(state.principalLock, input.caller);
      failedAuthAttempts = state.principalLock.failedAuthAttempts;
      neurochemicals = input.neurochemicals;
      minNeurochemical = minNc;
      predictionError = input.predictionError;
      kalmanVariance = input.kalmanVariance;
      maxWeight = input.hebbianWeightMax;
      weightVariance = input.hebbianWeightVariance;
      hebbianEntropy = input.hebbianEntropy;
      atlasSovereignty = input.atlasSovereignty;
      territoryLossRate = 0.0;  // Calculate from previous state if needed
      cortisol = cortisol;
      adrenaline = adrenaline;
      previousCoherence = state.lawsState.compliance;
      currentBeat = state.currentBeat;
    }
  };

  // ==========================================================================
  // BUILD VAEL INPUT
  // ==========================================================================
  
  func buildVaelInput(
    state: GovernanceState,
    input: HeartbeatInput,
    threatLevel: Float
  ) : VaelDefenseFamily.VaelInput {
    {
      identity = input.globalCoherence;
      coherence = input.globalCoherence;
      threatLevel = threatLevel;
      sacesiTarget = state.dreamCycle.sacesi.target;
      currentOutputs = input.currentOutputs;
      expectedOutputs = input.expectedOutputs;
      heritageNodes = input.heritageNodes;
      lawComplianceScore = state.lawsState.compliance;
      currentBeat = state.currentBeat;
      attackSourceId = input.attackSourceId;
    }
  };

  // ==========================================================================
  // BUILD DREAM CYCLE INPUT
  // ==========================================================================
  
  func buildDreamCycleInput(
    state: GovernanceState,
    input: HeartbeatInput,
    compliance: Float
  ) : JubileeDreamCycle.DreamCycleInput {
    {
      currentBeat = state.currentBeat;
      timestamp = input.timestamp;
      coherence = input.globalCoherence;
      compliance = compliance;
      formaCapital = input.formaCapital;
      prometheusObservations = state.prometheusObservations;
      forceJubilee = input.forceJubilee;
    }
  };

  // ==========================================================================
  // UPDATE PROMETHEUS OBSERVATIONS
  // ==========================================================================
  
  func updatePrometheusObservations(
    current: [Float],
    input: HeartbeatInput
  ) : [Float] {
    var obs = Buffer.Buffer<Float>(128);
    
    // Slots 0-63: Shell 3 activations (from weights or coherences)
    var i = 0;
    while (i < 64) {
      if (i < input.shellCoherences.size()) {
        obs.add(input.shellCoherences[i]);
      } else {
        obs.add(1.0);
      };
      i += 1;
    };
    
    // Slots 64-70: 7 council organism states
    i := 0;
    while (i < 7) {
      if (i < input.councilCoherences.size()) {
        obs.add(input.councilCoherences[i]);
      } else {
        obs.add(1.0);
      };
      i += 1;
    };
    
    // Slots 71-78: 8 quantum operator scores (use neurochemicals as proxy)
    i := 0;
    while (i < 8) {
      if (i < input.neurochemicals.size()) {
        obs.add(input.neurochemicals[i]);
      } else {
        obs.add(1.0);
      };
      i += 1;
    };
    
    // Slots 79-106: substrate variables (use world model alphas + padding)
    i := 0;
    while (i < 28) {
      if (i < input.worldModelAlphas.size()) {
        obs.add(input.worldModelAlphas[i]);
      } else {
        obs.add(1.0);
      };
      i += 1;
    };
    
    // Slots 107-127: padding
    i := 0;
    while (i < 21) {
      obs.add(1.0);
      i += 1;
    };
    
    Buffer.toArray(obs)
  };

  // ==========================================================================
  // MAIN HEARTBEAT FUNCTION
  // ==========================================================================
  
  public func executeHeartbeat(
    state: GovernanceState,
    input: HeartbeatInput
  ) : (GovernanceState, HeartbeatOutput) {
    var errors = Buffer.Buffer<Text>(10);
    var newState = state;
    
    // Increment beat counter
    let currentBeat = state.currentBeat + 1;
    newState := { newState with currentBeat = currentBeat };
    
    // 1. PRINCIPAL LOCK VERIFICATION
    let isCreator = assertCreator(state.principalLock, input.caller);
    if (not isCreator and state.genesisComplete) {
      // Record failed auth but continue for query-only operations
      let newPrincipalLock = recordFailedAuth(state.principalLock, currentBeat);
      newState := { newState with principalLock = newPrincipalLock };
    };
    
    // 2. EVALUATE 60 SOVEREIGNTY LAWS
    let lawInput = buildLawInput(newState, input);
    let lawsOutput = SovereigntyLaws60.evaluateAllLaws(lawInput);
    newState := { newState with lawsState = lawsOutput };
    
    // 3. UPDATE DOCTRINE FINGERPRINT
    let lawScores = Array.map<SovereigntyLaws60.LawResult, Float>(
      lawsOutput.results,
      func(r: SovereigntyLaws60.LawResult) : Float { r.score }
    );
    var newAuditSystem = DoctrineFingerprint.updateDoctrine(
      newState.auditSystem.doctrine,
      lawScores,
      currentBeat
    );
    newState := { newState with 
      auditSystem = { newState.auditSystem with doctrine = newAuditSystem }
    };
    
    // 4. VETUS THREAT ASSESSMENT
    let vetusInput = buildVetusInput(newState, input, lawsOutput);
    let newVetus = VetusThreatSystem.assessThreats(newState.vetusThreat, vetusInput);
    newState := { newState with vetusThreat = newVetus };
    
    // Check for ARES auto-rollback trigger
    let aresTriggered = VetusThreatSystem.isAresTriggered(newVetus);
    if (aresTriggered) {
      errors.add("ARES AUTO-ROLLBACK TRIGGERED: VTV-9 exceeded threshold");
    };
    
    // 5. VAEL DEFENSE UPDATE
    let vaelInput = buildVaelInput(newState, input, newVetus.globalThreatLevel);
    let newVael = VaelDefenseFamily.updateVaelFamily(newState.vaelDefense, vaelInput);
    newState := { newState with vaelDefense = newVael };
    
    // 6. DREAM CYCLE UPDATE (JUBILEE, Jacob's Ladder, SACESI, L-121)
    let dreamInput = buildDreamCycleInput(newState, input, lawsOutput.compliance);
    let (newDreamCycle, jubileeEvent) = JubileeDreamCycle.updateDreamCycle(
      newState.dreamCycle,
      dreamInput
    );
    newState := { newState with dreamCycle = newDreamCycle };
    
    let jubileeFired = switch (jubileeEvent) {
      case (?_) { true };
      case null { false };
    };
    
    // 7. LOG TO ANIMA CHAIN
    let eventType : DoctrineFingerprint.AuditEventType = if (jubileeFired) {
      #Jubilee({ count = newDreamCycle.jubilee.jubileeCount })
    } else if (aresTriggered) {
      #Breach({ vector = 9; level = newVetus.globalThreatLevel })
    } else {
      #Heartbeat
    };
    
    let newAnimaChain = DoctrineFingerprint.appendToAnimaChain(
      newState.auditSystem.animaChain,
      eventType,
      currentBeat,
      input.timestamp,
      lawsOutput.compliance,
      input.globalCoherence,
      ""
    );
    newState := { newState with 
      auditSystem = { newState.auditSystem with animaChain = newAnimaChain }
    };
    
    // 8. UPDATE PROMETHEUS OBSERVATIONS
    let newPrometheus = updatePrometheusObservations(newState.prometheusObservations, input);
    newState := { newState with prometheusObservations = newPrometheus };
    
    // 9. CHECK FOR ARES SNAPSHOT
    if (currentBeat >= newState.aresLastSnapshot + ARES_SNAPSHOT_INTERVAL) {
      newState := { newState with 
        aresLastSnapshot = currentBeat;
        aresSnapshotCount = newState.aresSnapshotCount + 1;
      };
    };
    
    // 10. UPDATE TIMESTAMPS
    newState := { newState with 
      lastHeartbeatTimestamp = input.timestamp;
      heartbeatCount = state.heartbeatCount + 1;
    };
    
    // Get highest threat for output
    let highestThreat = switch (VetusThreatSystem.getHighestThreat(newVetus)) {
      case (?v) { ?v.id };
      case null { null };
    };
    
    // Build output
    let output : HeartbeatOutput = {
      success = true;
      beat = currentBeat;
      compliance = lawsOutput.compliance;
      coherence = input.globalCoherence;
      passingLaws = lawsOutput.passingCount;
      failingLaws = SovereigntyLaws60.TOTAL_LAWS - lawsOutput.passingCount;
      doctrineFingerprint = lawsOutput.doctrineFingerprint;
      globalThreatLevel = newVetus.globalThreatLevel;
      highestThreat = highestThreat;
      aresTriggered = aresTriggered;
      defenseStrength = VaelDefenseFamily.getDefenseStrength(newVael);
      duraVaelActive = newVael.duraVaelActive;
      jacobsRung = newDreamCycle.jacobsLadder.currentRung;
      formaMultiplier = newDreamCycle.jacobsLadder.formaMultiplier;
      sacesiTarget = newDreamCycle.sacesi.target;
      beatsUntilJubilee = JubileeDreamCycle.getBeatsUntilJubilee(newDreamCycle);
      jubileeFired = jubileeFired;
      animaEntryCount = newAnimaChain.totalEntries;
      patentCount = newState.auditSystem.patentRegistry.nextId;
      errors = Buffer.toArray(errors);
    };
    
    (newState, output)
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initGovernanceState(creatorPrincipal: ?Principal) : GovernanceState {
    let defaultLawInput = SovereigntyLaws60.defaultLawInput();
    let initialLaws = SovereigntyLaws60.evaluateAllLaws(defaultLawInput);
    
    {
      principalLock = {
        creatorPrincipal = creatorPrincipal;
        genesisLocked = switch (creatorPrincipal) { case (?_) true; case null false };
        genesisTimestamp = Time.now();
        genesisSealed = false;
        failedAuthAttempts = 0;
        lastAuthAttempt = 0;
      };
      lawsState = initialLaws;
      auditSystem = DoctrineFingerprint.initAuditSystemState();
      vetusThreat = VetusThreatSystem.initVetusState();
      vaelDefense = VaelDefenseFamily.initVaelFamily();
      dreamCycle = JubileeDreamCycle.initDreamCycleState();
      currentBeat = 0;
      lastHeartbeatTimestamp = Time.now();
      heartbeatCount = 0;
      aresLastSnapshot = 0;
      aresSnapshotCount = 0;
      prometheusObservations = Array.tabulate<Float>(128, func(_: Nat) : Float { 1.0 });
      genesisComplete = false;
      emergencyPause = false;
    }
  };

  // ==========================================================================
  // SEAL GENESIS
  // ==========================================================================
  
  public func sealGenesis(
    state: GovernanceState,
    lawScores: [Float],
    timestamp: Int
  ) : GovernanceState {
    if (state.principalLock.genesisSealed) { return state };
    
    let sealedDoctrine = DoctrineFingerprint.sealGenesis(
      state.auditSystem.doctrine,
      lawScores,
      state.currentBeat,
      timestamp
    );
    
    {
      state with
      principalLock = { state.principalLock with genesisSealed = true };
      auditSystem = { state.auditSystem with doctrine = sealedDoctrine };
      genesisComplete = true;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getCompliance(state: GovernanceState) : Float {
    state.lawsState.compliance
  };

  public func getDoctrineFingerprint(state: GovernanceState) : Nat32 {
    state.lawsState.doctrineFingerprint
  };

  public func getJacobsRung(state: GovernanceState) : Nat {
    state.dreamCycle.jacobsLadder.currentRung
  };

  public func getFormaMultiplier(state: GovernanceState) : Float {
    state.dreamCycle.jacobsLadder.formaMultiplier
  };

  public func getSacesiTarget(state: GovernanceState) : Float {
    state.dreamCycle.sacesi.target
  };

  public func getThreatLevel(state: GovernanceState) : Float {
    state.vetusThreat.globalThreatLevel
  };

  public func getDefenseStrength(state: GovernanceState) : Float {
    VaelDefenseFamily.getDefenseStrength(state.vaelDefense)
  };

  public func isGenesisSealed(state: GovernanceState) : Bool {
    state.principalLock.genesisSealed
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
  //  E C O N O M I C   &   G O V E R N A N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Economic and Governance Algorithms
  //  Full HIM/HER Dual-Organism Economic Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // TOKEN ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Token value from supply/demand
  public func economicTokenValue(
    demand : Float,
    supply : Float,
    baseValue : Float
  ) : Float {
    if (supply < 0.0001) { baseValue * 10.0 }
    else { baseValue * (demand / supply) }
  };

  /// Staking reward calculation
  public func economicStakingReward(
    stakedAmount : Float,
    stakingDuration : Nat,
    rewardRate : Float,
    bonusMultiplier : Float
  ) : Float {
    let durationBonus = Float.log(Float.fromInt(stakingDuration + 1));
    stakedAmount * rewardRate * (1.0 + durationBonus * bonusMultiplier)
  };

  /// Liquidity pool share
  public func economicLPShare(
    userLiquidity : Float,
    totalLiquidity : Float
  ) : Float {
    if (totalLiquidity < 0.0001) { 0.0 }
    else { userLiquidity / totalLiquidity }
  };

  /// Automated market maker price impact
  public func economicAMMPriceImpact(
    tradeSize : Float,
    poolSize : Float,
    k : Float
  ) : Float {
    let newPool = poolSize + tradeSize;
    let counterPool = k / newPool;
    Float.abs(counterPool - k / poolSize) / (k / poolSize)
  };

  /// Inflation rate calculation
  public func economicInflationRate(
    newSupply : Float,
    currentSupply : Float
  ) : Float {
    if (currentSupply < 0.0001) { 0.0 }
    else { (newSupply - currentSupply) / currentSupply }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GOVERNANCE MECHANICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quadratic voting power
  public func governanceQuadraticVotes(tokens : Float) : Float {
    Float.sqrt(tokens)
  };

  /// Conviction voting weight
  public func governanceConvictionWeight(
    tokens : Float,
    time : Float,
    halfLife : Float
  ) : Float {
    tokens * (1.0 - Float.exp(-time / halfLife))
  };

  /// Quorum calculation
  public func governanceQuorumReached(
    votesFor : Float,
    votesAgainst : Float,
    totalSupply : Float,
    quorumThreshold : Float
  ) : Bool {
    let totalVotes = votesFor + votesAgainst;
    totalVotes / totalSupply >= quorumThreshold
  };

  /// Proposal passing check
  public func governanceProposalPasses(
    votesFor : Float,
    votesAgainst : Float,
    passThreshold : Float
  ) : Bool {
    let total = votesFor + votesAgainst;
    if (total < 0.0001) { false }
    else { votesFor / total >= passThreshold }
  };

  /// Delegation weight calculation
  public func governanceDelegationWeight(
    directPower : Float,
    delegatedPower : Float,
    delegatorCount : Nat
  ) : Float {
    let delegationBonus = Float.log(Float.fromInt(delegatorCount + 1)) * 0.1;
    directPower + delegatedPower * (1.0 + delegationBonus)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BEHAVIORAL ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Prospect theory value function
  public func economicProspectValue(
    outcome : Float,
    reference : Float,
    lossAversion : Float
  ) : Float {
    let x = outcome - reference;
    if (x >= 0.0) {
      Float.pow(x, 0.88)
    } else {
      -lossAversion * Float.pow(-x, 0.88)
    }
  };

  /// Probability weighting
  public func economicProbabilityWeight(p : Float, delta : Float) : Float {
    let pDelta = Float.pow(p, delta);
    pDelta / Float.pow(pDelta + Float.pow(1.0 - p, delta), 1.0 / delta)
  };

  /// Hyperbolic discounting
  public func economicHyperbolicDiscount(
    value : Float,
    delay : Float,
    k : Float
  ) : Float {
    value / (1.0 + k * delay)
  };

  /// Social preference utility
  public func economicSocialUtility(
    ownPayoff : Float,
    otherPayoff : Float,
    altruism : Float,
    envy : Float
  ) : Float {
    let comparison = otherPayoff - ownPayoff;
    if (comparison > 0.0) {
      ownPayoff - envy * comparison
    } else {
      ownPayoff + altruism * (-comparison)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INSURANCE & RISK
  // ─────────────────────────────────────────────────────────────────────────────

  /// Expected loss calculation
  public func economicExpectedLoss(
    probability : Float,
    severity : Float
  ) : Float {
    probability * severity
  };

  /// Premium calculation
  public func economicPremium(
    expectedLoss : Float,
    loadingFactor : Float,
    expenses : Float
  ) : Float {
    expectedLoss * (1.0 + loadingFactor) + expenses
  };

  /// Risk pooling benefit
  public func economicRiskPoolingBenefit(
    individualVariance : Float,
    poolSize : Nat,
    correlation : Float
  ) : Float {
    let n = Float.fromInt(poolSize);
    let pooledVariance = individualVariance * (1.0 + (n - 1.0) * correlation) / n;
    individualVariance - pooledVariance
  };

  /// Value at Risk (simplified)
  public func economicVaR(
    mean : Float,
    stdDev : Float,
    confidenceMultiplier : Float
  ) : Float {
    mean - confidenceMultiplier * stdDev
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE ALLOCATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Cobb-Douglas production
  public func economicCobbDouglas(
    labor : Float,
    capital : Float,
    alpha : Float,
    productivity : Float
  ) : Float {
    productivity * Float.pow(labor, alpha) * Float.pow(capital, 1.0 - alpha)
  };

  /// Marginal utility
  public func economicMarginalUtility(
    quantity : Float,
    diminishingFactor : Float
  ) : Float {
    1.0 / Float.pow(quantity + 1.0, diminishingFactor)
  };

  /// Nash bargaining solution
  public func economicNashBargaining(
    u1 : Float,
    u2 : Float,
    d1 : Float,
    d2 : Float
  ) : Float {
    (u1 - d1) * (u2 - d2)
  };

  /// Shapley value contribution
  public func economicShapleyContribution(
    marginalContributions : [Float]
  ) : Float {
    if (marginalContributions.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < marginalContributions.size()) {
      sum += marginalContributions[i];
      i += 1;
    };
    sum / Float.fromInt(marginalContributions.size())
  };

}
