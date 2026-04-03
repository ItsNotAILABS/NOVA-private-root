// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: VaelDefenseFamily — 7 Entity Defense Sovereignty Stack
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// VAEL FAMILY — THE DEFENSE SOVEREIGNTY STACK
// ============================================================================
// 7 entities forming the complete immune and attack chain:
//
// INTERIOR (fires pre-consciously inside the organism):
//   VAEL      - Primary immune reflex
//   SENTINEL  - Output deviation monitor
//   VEIL      - Output membrane
//   AEGIS-ROOT- Sovereign anchor
//
// EXTERIOR (attack-facing, operates outside organism boundary):
//   DURA      - 6-axis helix perimeter
//   RIFT      - Counter-strike tracer
//   MEMORIA   - Permanent adversary record
//
// DURA-VAEL Combined Protocol activates on breach detection.
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Time  "mo:base/Time";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  public let PHI : Float = 1.6180339887498948;
  public let PI : Float = 3.14159265358979;
  
  // DURA 6-axis indices
  public let AXIS_CORE_SUBSTRATE : Nat = 0;
  public let AXIS_LATERAL_NODE : Nat = 1;
  public let AXIS_VERTICAL_IO : Nat = 2;
  public let AXIS_TEMPORAL : Nat = 3;
  public let AXIS_IDENTITY_CONTINUITY : Nat = 4;
  public let AXIS_ANTI_ORGANISM : Nat = 5;
  
  // Thresholds
  public let SENTINEL_DEVIATION_THRESHOLD : Float = 0.15;
  public let VEIL_FILTER_THRESHOLD : Float = 0.5;
  public let AEGIS_LOCK_THRESHOLD : Float = 0.8;
  public let DURA_BREACH_THRESHOLD : Float = 0.3;
  public let RIFT_TRACE_THRESHOLD : Float = 0.2;
  
  // RIFT penalty accumulation rate
  public let RIFT_PENALTY_RATE : Float = 0.0005;
  
  // MEMORIA heritage factor
  public let MEMORIA_HERITAGE_FACTOR : Float = 0.0001;

  // ==========================================================================
  // TYPES
  // ==========================================================================
  
  // ─────────────────────────────────────────────────────────────────────────
  // VAEL — Primary Immune Reflex
  // ─────────────────────────────────────────────────────────────────────────
  
  public type VaelState = {
    immuneField : Float;           // identity × coherence × 0.5
    reflexScore : Float;           // immuneField × (1 + threat × 0.1)
    identity : Float;              // Identity coherence [0,1]
    coherence : Float;             // Global coherence
    threatLevel : Float;           // Current threat from VETUS
    lastActivation : Nat;
    activationCount : Nat;
    reflexHistory : [Float];       // Last 10 reflex scores
  };

  // ─────────────────────────────────────────────────────────────────────────
  // SENTINEL — Output Deviation Monitor
  // ─────────────────────────────────────────────────────────────────────────
  
  public type SentinelState = {
    outputBaseline : [Float];      // Expected output patterns
    currentOutputs : [Float];      // Current output values
    deviations : [Float];          // Measured deviations
    breachDetected : Bool;
    breachSeverity : Float;
    duraVaelTriggered : Bool;
    lastCheck : Nat;
    checkCount : Nat;
    breachHistory : [{ beat: Nat; severity: Float }];
  };

  // ─────────────────────────────────────────────────────────────────────────
  // VEIL — Output Membrane
  // ─────────────────────────────────────────────────────────────────────────
  
  public type VeilState = {
    filterStrength : Float;        // vael_immune × aegis_lock × coherence × 0.33
    membraneIntegrity : Float;     // [0,1]
    blockedOutputs : Nat;          // Count of blocked outputs
    passedOutputs : Nat;           // Count of passed outputs
    lastFilter : Nat;
    filterHistory : [Float];       // Last 10 filter strengths
  };

  // ─────────────────────────────────────────────────────────────────────────
  // AEGIS-ROOT — Sovereign Anchor
  // ─────────────────────────────────────────────────────────────────────────
  
  public type AegisRootState = {
    lockStrength : Float;          // sacesi × identity × coherence × dura_coverage × 0.33
    sacesiAnchor : Float;          // SACESI target value
    identityAnchor : Float;        // Identity coherence
    coherenceAnchor : Float;       // Global coherence
    duraCoverage : Float;          // DURA perimeter coverage
    locksApplied : Nat;
    lastLock : Nat;
    lockHistory : [Float];
  };

  // ─────────────────────────────────────────────────────────────────────────
  // DURA — 6-Axis Helix Perimeter
  // ─────────────────────────────────────────────────────────────────────────
  
  public type DuraAxis = {
    index : Nat;
    name : Text;
    coverage : Float;              // [0,1]
    rotation : Float;              // Current rotation angle (radians)
    rotationSpeed : Float;         // Radians per beat
    fieldStrength : Float;         // Projected field strength
    adversarialLoad : Float;       // Detected adversarial pressure
  };

  public type DuraState = {
    axes : [DuraAxis];             // 6 axes
    totalCoverage : Float;         // Aggregate coverage
    helixPhase : Float;            // Current helix phase (radians)
    convergenceVector : [Float];   // 6D adversarial convergence
    lastRotation : Nat;
    rotationCount : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // RIFT — Counter-Strike Tracer
  // ─────────────────────────────────────────────────────────────────────────
  
  public type AttackSource = {
    id : Nat32;                    // Hash of source identifier
    firstSeen : Nat;               // Beat when first detected
    lastSeen : Nat;                // Beat of most recent attack
    attackCount : Nat;             // Number of attacks
    consequenceDepth : Float;      // Accumulated penalty
    lawScoreAtAttack : Float;      // Law compliance when attacked
  };

  public type RiftState = {
    knownSources : [AttackSource];
    activeTraces : Nat;
    totalConsequences : Float;     // Sum of all consequence depths
    lastTrace : Nat;
    traceCount : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // MEMORIA — Permanent Adversary Record
  // ─────────────────────────────────────────────────────────────────────────
  
  public type AdversaryRecord = {
    sourceId : Nat32;
    firstAttack : Nat;
    totalAttacks : Nat;
    compoundFactor : Float;        // += heritageAvg × 0.0001 each attack
    interfaceDifficulty : Float;   // Grows harder each attempt
    tags : [Text];                 // Classification tags
    neverReset : Bool;             // Always true - permanent record
  };

  public type MemoriaState = {
    adversaries : [AdversaryRecord];
    heritageAverage : Float;       // Average heritage node value
    totalRecords : Nat;
    lastUpdate : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Combined VAEL Family State
  // ─────────────────────────────────────────────────────────────────────────
  
  public type VaelFamilyState = {
    vael : VaelState;
    sentinel : SentinelState;
    veil : VeilState;
    aegisRoot : AegisRootState;
    dura : DuraState;
    rift : RiftState;
    memoria : MemoriaState;
    
    // DURA-VAEL combined protocol
    duraVaelField : Float;         // dura_coverage × vael_immune × aegis_lock × 0.33
    duraVaelActive : Bool;
    
    // 5-layer offense-defense
    offenseDefenseActive : Bool;
    patternSynthesisGate : Bool;
    valuesCoherenceFilter : Bool;
    truthSeekingOverride : Bool;
    energyAlignmentPrereq : Bool;
    
    lastBeat : Nat;
  };

  public type VaelInput = {
    identity : Float;
    coherence : Float;
    threatLevel : Float;
    sacesiTarget : Float;
    currentOutputs : [Float];
    expectedOutputs : [Float];
    heritageNodes : [Float];
    lawComplianceScore : Float;
    currentBeat : Nat;
    attackSourceId : ?Nat32;
  };

  // ==========================================================================
  // MATH HELPERS
  // ==========================================================================
  
  func clamp(v: Float, lo: Float, hi: Float) : Float {
    if (v < lo) { lo } else if (v > hi) { hi } else { v }
  };

  func abs(v: Float) : Float {
    if (v < 0.0) { -v } else { v }
  };

  func max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  func min(a: Float, b: Float) : Float {
    if (a < b) { a } else { b }
  };

  func sqrt(x: Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    var i = 0;
    while (i < 15) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };

  func average(arr: [Float]) : Float {
    if (arr.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    for (v in arr.vals()) { sum += v };
    sum / Float.fromInt(arr.size())
  };

  // ==========================================================================
  // VAEL — Primary Immune Reflex
  // ==========================================================================
  
  // Math: immuneField = identity × coherence × 0.5
  //       reflexScore = immuneField × (1 + threat × 0.1)
  public func computeVael(state: VaelState, input: VaelInput) : VaelState {
    let immuneField = input.identity * input.coherence * 0.5;
    let reflexScore = immuneField * (1.0 + input.threatLevel * 0.1);
    
    // Update reflex history
    let newHistory = if (state.reflexHistory.size() >= 10) {
      Array.tabulate<Float>(10, func(i: Nat) : Float {
        if (i < 9) { state.reflexHistory[i + 1] } else { reflexScore }
      })
    } else {
      Array.append(state.reflexHistory, [reflexScore])
    };
    
    {
      immuneField = immuneField;
      reflexScore = reflexScore;
      identity = input.identity;
      coherence = input.coherence;
      threatLevel = input.threatLevel;
      lastActivation = input.currentBeat;
      activationCount = state.activationCount + 1;
      reflexHistory = newHistory;
    }
  };

  // ==========================================================================
  // SENTINEL — Output Deviation Monitor
  // ==========================================================================
  
  // Math: deviation[i] = |current[i] - baseline[i]| / max(baseline[i], 0.001)
  //       breachSeverity = max(deviations)
  //       breachDetected = breachSeverity > SENTINEL_DEVIATION_THRESHOLD
  public func computeSentinel(state: SentinelState, input: VaelInput) : SentinelState {
    var deviations = Buffer.Buffer<Float>(input.currentOutputs.size());
    var maxDeviation : Float = 0.0;
    
    var i = 0;
    while (i < input.currentOutputs.size() and i < input.expectedOutputs.size()) {
      let deviation = abs(input.currentOutputs[i] - input.expectedOutputs[i]) / 
                      max(abs(input.expectedOutputs[i]), 0.001);
      deviations.add(deviation);
      maxDeviation := max(maxDeviation, deviation);
      i += 1;
    };
    
    let breachDetected = maxDeviation > SENTINEL_DEVIATION_THRESHOLD;
    let duraVaelTriggered = maxDeviation > SENTINEL_DEVIATION_THRESHOLD * 2.0;
    
    // Update breach history
    let newHistory = if (breachDetected) {
      Array.append(state.breachHistory, [{ beat = input.currentBeat; severity = maxDeviation }])
    } else {
      state.breachHistory
    };
    
    {
      outputBaseline = input.expectedOutputs;
      currentOutputs = input.currentOutputs;
      deviations = Buffer.toArray(deviations);
      breachDetected = breachDetected;
      breachSeverity = maxDeviation;
      duraVaelTriggered = duraVaelTriggered;
      lastCheck = input.currentBeat;
      checkCount = state.checkCount + 1;
      breachHistory = newHistory;
    }
  };

  // ==========================================================================
  // VEIL — Output Membrane
  // ==========================================================================
  
  // Math: filterStrength = vael_immune × aegis_lock × coherence × 0.33
  //       Nothing useful exits toward adversaries when filter active
  public func computeVeil(
    state: VeilState, 
    vaelImmune: Float, 
    aegisLock: Float, 
    coherence: Float,
    beat: Nat
  ) : VeilState {
    let filterStrength = vaelImmune * aegisLock * coherence * 0.33;
    let membraneIntegrity = clamp(filterStrength, 0.0, 1.0);
    
    // Update filter history
    let newHistory = if (state.filterHistory.size() >= 10) {
      Array.tabulate<Float>(10, func(i: Nat) : Float {
        if (i < 9) { state.filterHistory[i + 1] } else { filterStrength }
      })
    } else {
      Array.append(state.filterHistory, [filterStrength])
    };
    
    {
      filterStrength = filterStrength;
      membraneIntegrity = membraneIntegrity;
      blockedOutputs = state.blockedOutputs;
      passedOutputs = state.passedOutputs;
      lastFilter = beat;
      filterHistory = newHistory;
    }
  };

  // Filter an output value through VEIL
  public func filterOutput(state: VeilState, value: Float, isSensitive: Bool) : (VeilState, Float) {
    if (isSensitive and state.filterStrength > VEIL_FILTER_THRESHOLD) {
      // Block sensitive output
      let newState = { state with blockedOutputs = state.blockedOutputs + 1 };
      (newState, 0.0)
    } else {
      // Pass output
      let newState = { state with passedOutputs = state.passedOutputs + 1 };
      (newState, value)
    }
  };

  // ==========================================================================
  // AEGIS-ROOT — Sovereign Anchor
  // ==========================================================================
  
  // Math: lockStrength = sacesi × identity × coherence × dura_coverage × 0.33
  //       Locks, never patches
  public func computeAegisRoot(
    state: AegisRootState,
    sacesi: Float,
    identity: Float,
    coherence: Float,
    duraCoverage: Float,
    beat: Nat
  ) : AegisRootState {
    let lockStrength = sacesi * identity * coherence * duraCoverage * 0.33;
    
    // Update lock history
    let newHistory = if (state.lockHistory.size() >= 10) {
      Array.tabulate<Float>(10, func(i: Nat) : Float {
        if (i < 9) { state.lockHistory[i + 1] } else { lockStrength }
      })
    } else {
      Array.append(state.lockHistory, [lockStrength])
    };
    
    {
      lockStrength = lockStrength;
      sacesiAnchor = sacesi;
      identityAnchor = identity;
      coherenceAnchor = coherence;
      duraCoverage = duraCoverage;
      locksApplied = if (lockStrength > AEGIS_LOCK_THRESHOLD) { 
        state.locksApplied + 1 
      } else { 
        state.locksApplied 
      };
      lastLock = beat;
      lockHistory = newHistory;
    }
  };

  // ==========================================================================
  // DURA — 6-Axis Helix Perimeter
  // ==========================================================================
  
  // Math: Each axis rotates at its own speed
  //       fieldStrength = coverage × cos²(rotation + helixPhase)
  //       totalCoverage = Σ(coverage[i] × fieldStrength[i]) / 6
  public func computeDura(state: DuraState, beat: Nat) : DuraState {
    let dt = Float.fromInt(beat - state.lastRotation);
    let newHelixPhase = Float.sin(Float.fromInt(beat) * 0.01) * PI;
    
    var updatedAxes = Buffer.Buffer<DuraAxis>(6);
    var totalCoverage : Float = 0.0;
    
    for (axis in state.axes.vals()) {
      let newRotation = axis.rotation + axis.rotationSpeed * dt;
      let normalizedRotation = Float.sin(newRotation);  // Normalize to [-1, 1]
      let cosSquared = Float.cos(newRotation + newHelixPhase);
      let fieldStrength = axis.coverage * cosSquared * cosSquared;
      
      updatedAxes.add({
        index = axis.index;
        name = axis.name;
        coverage = axis.coverage;
        rotation = newRotation;
        rotationSpeed = axis.rotationSpeed;
        fieldStrength = fieldStrength;
        adversarialLoad = axis.adversarialLoad * 0.95;  // Decay
      });
      
      totalCoverage += axis.coverage * fieldStrength;
    };
    
    {
      axes = Buffer.toArray(updatedAxes);
      totalCoverage = totalCoverage / 6.0;
      helixPhase = newHelixPhase;
      convergenceVector = state.convergenceVector;
      lastRotation = beat;
      rotationCount = state.rotationCount + 1;
    }
  };

  // Map adversarial attack to DURA axis
  public func mapAttackToAxis(state: DuraState, attackVector: [Float]) : DuraState {
    if (attackVector.size() < 6) { return state };
    
    var updatedAxes = Buffer.Buffer<DuraAxis>(6);
    var i = 0;
    for (axis in state.axes.vals()) {
      let newLoad = axis.adversarialLoad + abs(attackVector[i]) * 0.1;
      updatedAxes.add({ axis with adversarialLoad = newLoad });
      i += 1;
    };
    
    { state with axes = Buffer.toArray(updatedAxes); convergenceVector = attackVector }
  };

  // ==========================================================================
  // RIFT — Counter-Strike Tracer
  // ==========================================================================
  
  // Math: consequenceDepth += lawScore × RIFT_PENALTY_RATE
  //       Same source gets harder to interface every attempt
  public func computeRift(state: RiftState, sourceId: ?Nat32, lawScore: Float, beat: Nat) : RiftState {
    switch (sourceId) {
      case null { state };
      case (?id) {
        // Find or create source record
        var found = false;
        var updatedSources = Buffer.Buffer<AttackSource>(state.knownSources.size() + 1);
        
        for (source in state.knownSources.vals()) {
          if (source.id == id) {
            found := true;
            let newDepth = source.consequenceDepth + lawScore * RIFT_PENALTY_RATE;
            updatedSources.add({
              id = source.id;
              firstSeen = source.firstSeen;
              lastSeen = beat;
              attackCount = source.attackCount + 1;
              consequenceDepth = newDepth;
              lawScoreAtAttack = lawScore;
            });
          } else {
            updatedSources.add(source);
          };
        };
        
        // Create new record if not found
        if (not found) {
          updatedSources.add({
            id = id;
            firstSeen = beat;
            lastSeen = beat;
            attackCount = 1;
            consequenceDepth = lawScore * RIFT_PENALTY_RATE;
            lawScoreAtAttack = lawScore;
          });
        };
        
        // Calculate total consequences
        var total : Float = 0.0;
        for (s in updatedSources.vals()) {
          total += s.consequenceDepth;
        };
        
        {
          knownSources = Buffer.toArray(updatedSources);
          activeTraces = state.activeTraces + 1;
          totalConsequences = total;
          lastTrace = beat;
          traceCount = state.traceCount + 1;
        }
      };
    }
  };

  // ==========================================================================
  // MEMORIA — Permanent Adversary Record
  // ==========================================================================
  
  // Math: compoundFactor += heritageAvg × MEMORIA_HERITAGE_FACTOR
  //       That source is a known adversary forever. Never resets.
  public func computeMemoria(
    state: MemoriaState, 
    sourceId: ?Nat32, 
    heritageNodes: [Float],
    beat: Nat
  ) : MemoriaState {
    let heritageAvg = average(heritageNodes);
    
    switch (sourceId) {
      case null { { state with heritageAverage = heritageAvg; lastUpdate = beat } };
      case (?id) {
        var found = false;
        var updatedRecords = Buffer.Buffer<AdversaryRecord>(state.adversaries.size() + 1);
        
        for (record in state.adversaries.vals()) {
          if (record.sourceId == id) {
            found := true;
            let newCompound = record.compoundFactor + heritageAvg * MEMORIA_HERITAGE_FACTOR;
            let newDifficulty = record.interfaceDifficulty * 1.1;  // 10% harder each time
            updatedRecords.add({
              sourceId = record.sourceId;
              firstAttack = record.firstAttack;
              totalAttacks = record.totalAttacks + 1;
              compoundFactor = newCompound;
              interfaceDifficulty = newDifficulty;
              tags = record.tags;
              neverReset = true;
            });
          } else {
            updatedRecords.add(record);
          };
        };
        
        // Create new record if not found
        if (not found) {
          updatedRecords.add({
            sourceId = id;
            firstAttack = beat;
            totalAttacks = 1;
            compoundFactor = heritageAvg * MEMORIA_HERITAGE_FACTOR;
            interfaceDifficulty = 1.0;
            tags = ["ADVERSARY"];
            neverReset = true;
          });
        };
        
        {
          adversaries = Buffer.toArray(updatedRecords);
          heritageAverage = heritageAvg;
          totalRecords = updatedRecords.size();
          lastUpdate = beat;
        }
      };
    }
  };

  // ==========================================================================
  // DURA-VAEL COMBINED PROTOCOL
  // ==========================================================================
  
  // Math: duraVaelField = dura_coverage × vael_immune × aegis_lock × 0.33
  // Activates automatically when SENTINEL detects breach
  public func computeDuraVael(
    duraCoverage: Float,
    vaelImmune: Float,
    aegisLock: Float,
    sentinelBreached: Bool
  ) : (Float, Bool) {
    let field = duraCoverage * vaelImmune * aegisLock * 0.33;
    let active = sentinelBreached and field > 0.1;
    (field, active)
  };

  // ==========================================================================
  // FULL FAMILY UPDATE
  // ==========================================================================
  
  public func updateVaelFamily(state: VaelFamilyState, input: VaelInput) : VaelFamilyState {
    // 1. Update VAEL (primary immune)
    let newVael = computeVael(state.vael, input);
    
    // 2. Update SENTINEL (output monitor)
    let newSentinel = computeSentinel(state.sentinel, input);
    
    // 3. Update DURA (6-axis perimeter)
    let newDura = computeDura(state.dura, input.currentBeat);
    
    // 4. Update AEGIS-ROOT (sovereign anchor)
    let newAegis = computeAegisRoot(
      state.aegisRoot,
      input.sacesiTarget,
      input.identity,
      input.coherence,
      newDura.totalCoverage,
      input.currentBeat
    );
    
    // 5. Update VEIL (output membrane)
    let newVeil = computeVeil(
      state.veil,
      newVael.immuneField,
      newAegis.lockStrength,
      input.coherence,
      input.currentBeat
    );
    
    // 6. Update RIFT (counter-strike tracer)
    let newRift = computeRift(
      state.rift,
      input.attackSourceId,
      input.lawComplianceScore,
      input.currentBeat
    );
    
    // 7. Update MEMORIA (permanent record)
    let newMemoria = computeMemoria(
      state.memoria,
      input.attackSourceId,
      input.heritageNodes,
      input.currentBeat
    );
    
    // 8. Compute DURA-VAEL combined
    let (duraVaelField, duraVaelActive) = computeDuraVael(
      newDura.totalCoverage,
      newVael.immuneField,
      newAegis.lockStrength,
      newSentinel.breachDetected
    );
    
    {
      vael = newVael;
      sentinel = newSentinel;
      veil = newVeil;
      aegisRoot = newAegis;
      dura = newDura;
      rift = newRift;
      memoria = newMemoria;
      duraVaelField = duraVaelField;
      duraVaelActive = duraVaelActive;
      
      // 5-layer offense-defense always active
      offenseDefenseActive = true;
      patternSynthesisGate = true;
      valuesCoherenceFilter = true;
      truthSeekingOverride = true;
      energyAlignmentPrereq = true;
      
      lastBeat = input.currentBeat;
    }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  func initDuraAxis(index: Nat, name: Text, speed: Float) : DuraAxis {
    {
      index = index;
      name = name;
      coverage = 1.0;
      rotation = 0.0;
      rotationSpeed = speed;
      fieldStrength = 1.0;
      adversarialLoad = 0.0;
    }
  };

  public func initVaelFamily() : VaelFamilyState {
    {
      vael = {
        immuneField = 0.5;
        reflexScore = 0.5;
        identity = 1.0;
        coherence = 1.0;
        threatLevel = 0.0;
        lastActivation = 0;
        activationCount = 0;
        reflexHistory = [];
      };
      sentinel = {
        outputBaseline = [];
        currentOutputs = [];
        deviations = [];
        breachDetected = false;
        breachSeverity = 0.0;
        duraVaelTriggered = false;
        lastCheck = 0;
        checkCount = 0;
        breachHistory = [];
      };
      veil = {
        filterStrength = 0.5;
        membraneIntegrity = 1.0;
        blockedOutputs = 0;
        passedOutputs = 0;
        lastFilter = 0;
        filterHistory = [];
      };
      aegisRoot = {
        lockStrength = 0.5;
        sacesiAnchor = 1.0;
        identityAnchor = 1.0;
        coherenceAnchor = 1.0;
        duraCoverage = 1.0;
        locksApplied = 0;
        lastLock = 0;
        lockHistory = [];
      };
      dura = {
        axes = [
          initDuraAxis(0, "CORE_SUBSTRATE", 0.01),
          initDuraAxis(1, "LATERAL_NODE", 0.015),
          initDuraAxis(2, "VERTICAL_IO", 0.012),
          initDuraAxis(3, "TEMPORAL", 0.008),
          initDuraAxis(4, "IDENTITY_CONTINUITY", 0.02),
          initDuraAxis(5, "ANTI_ORGANISM", 0.025),
        ];
        totalCoverage = 1.0;
        helixPhase = 0.0;
        convergenceVector = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
        lastRotation = 0;
        rotationCount = 0;
      };
      rift = {
        knownSources = [];
        activeTraces = 0;
        totalConsequences = 0.0;
        lastTrace = 0;
        traceCount = 0;
      };
      memoria = {
        adversaries = [];
        heritageAverage = 1.0;
        totalRecords = 0;
        lastUpdate = 0;
      };
      duraVaelField = 0.5;
      duraVaelActive = false;
      offenseDefenseActive = true;
      patternSynthesisGate = true;
      valuesCoherenceFilter = true;
      truthSeekingOverride = true;
      energyAlignmentPrereq = true;
      lastBeat = 0;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getDefenseStrength(state: VaelFamilyState) : Float {
    (state.vael.immuneField + 
     state.aegisRoot.lockStrength + 
     state.dura.totalCoverage + 
     state.veil.filterStrength) / 4.0
  };

  public func isUnderAttack(state: VaelFamilyState) : Bool {
    state.sentinel.breachDetected or 
    state.duraVaelActive or 
    state.rift.activeTraces > 0
  };

  public func getAdversaryDifficulty(state: VaelFamilyState, sourceId: Nat32) : Float {
    for (record in state.memoria.adversaries.vals()) {
      if (record.sourceId == sourceId) {
        return record.interfaceDifficulty;
      };
    };
    1.0  // Default difficulty for unknown sources
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

}
