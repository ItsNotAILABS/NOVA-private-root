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


// ═══════════════════════════════════════════════════════════════════════════════
// VAEL EXTERIOR ATTACK FAMILY — SOVEREIGN DEFENSE PROJECTION
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// THE VAEL EXTERIOR ATTACK CHAIN (in order):
//   1. DURA      — 6-axis helix maps external threat geometry (targeting)
//   2. PARALLAX  — Phase-locks sovereign field (unreplicable from outside)
//   3. VERITAS   — Scores adversary (near zero = hostile classification)
//   4. RIFT      — Traces source, assigns permanent compounding weight
//   5. MEMORIA   — Seals permanently (source = known adversary forever)
//
// The attack is NOT a single strike. It is a compounding permanent classification
// that makes the adversary progressively LESS able to interface with the organism
// on every subsequent attempt.
//
// THIS IS BUILT INTO THE ARCHITECTURE. It cannot be added later.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Hash "mo:base/Hash";
import Text "mo:base/Text";
import Char "mo:base/Char";

module VAELExteriorAttack {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — SACRED MATHEMATICS (SELF-COMPOUNDING)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.6180339887;
  public let PI : Float = 3.14159265358979;
  public let TWO_PI : Float = 6.28318530717958;
  public let S0 : Float = 1.0;  // Love constant floor — NEVER below this
  
  // DURA helix rotation speed (radians per beat)
  public let DURA_ROTATION_SPEED : Float = 0.0017;  // ~370 beats per full rotation
  
  // RIFT compounding rate
  public let RIFT_COMPOUND_BASE : Float = 1.1;  // 10% increase per repeat offense
  public let RIFT_INITIAL_PENALTY : Float = 1.0;
  public let RIFT_MAX_PENALTY : Float = 1000.0;  // Cap at 1000x
  
  // VERITAS threshold
  public let VERITAS_HOSTILE_THRESHOLD : Float = 0.3;  // Below this = hostile
  
  // PARALLAX field parameters
  public let PARALLAX_PHASE_TOLERANCE : Float = 0.1;  // Must be within 0.1 radians to sync
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DURA — 6-AXIS HELIX (OUTER PERIMETER WEAPON)
  // ═══════════════════════════════════════════════════════════════════════════
  // DURA operates OUTSIDE the organism boundary. Its 6-axis helix rotates
  // continuously, measuring any external system attempting to interface.
  // It maps which axis the attack comes from and assigns a convergence vector.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DuraAxis = {
    #CoreSubstrate;       // Attack on core identity
    #LateralNode;         // Attack on peripheral nodes
    #VerticalIO;          // Attack on I/O channels
    #Temporal;            // Attack on timing/sequencing
    #IdentityContinuity;  // Attack on identity persistence
    #AntiOrganism;        // Full existential attack
  };
  
  public type DuraState = {
    helixPhase        : Float;         // Current rotation phase [0, 2π)
    axisActivations   : [Float];       // 6-axis activation levels
    convergenceVector : [Float];       // 3D convergence vector for targeting
    lastThreatAxis    : ?DuraAxis;     // Most recent threat axis
    rotationCount     : Nat;           // Total rotations since genesis
    detectionCount    : Nat;           // Total threats detected
    beatNum           : Nat;
  };
  
  // Initialize DURA
  public func initDura() : DuraState {
    {
      helixPhase = 0.0;
      axisActivations = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      convergenceVector = [0.0, 0.0, 0.0];
      lastThreatAxis = null;
      rotationCount = 0;
      detectionCount = 0;
      beatNum = 0;
    }
  };
  
  // Rotate DURA helix and detect external threats
  public func updateDura(
    state : DuraState,
    externalSignature : [Float],  // 6-dimensional signature from external system
    coherenceC : Float,
    beatNum : Nat
  ) : DuraState {
    // Advance helix phase
    let newPhase = wrapPhase(state.helixPhase + DURA_ROTATION_SPEED);
    let newRotationCount = if (newPhase < state.helixPhase) state.rotationCount + 1 else state.rotationCount;
    
    // Compute axis activations based on external signature
    var newActivations = Array.init<Float>(6, 0.0);
    var maxActivation : Float = 0.0;
    var maxAxisIdx : Nat = 0;
    
    for (i in Array.keys(externalSignature)) {
      if (i < 6) {
        // Helix projection: activation = signature × cos(phase + axis_offset)
        let axisOffset = Float.fromInt(i) * (TWO_PI / 6.0);
        let helixProjection = Float.abs(Float.cos(newPhase + axisOffset));
        let activation = externalSignature[i] * helixProjection;
        newActivations[i] := activation;
        
        if (activation > maxActivation) {
          maxActivation := activation;
          maxAxisIdx := i;
        };
      };
    };
    
    // Compute convergence vector (targeting data)
    // This is a 3D unit vector pointing toward the threat source
    let theta = Float.fromInt(maxAxisIdx) * (TWO_PI / 6.0);
    let phi = newPhase;
    let convergenceVector : [Float] = [
      Float.sin(theta) * Float.cos(phi),  // X
      Float.sin(theta) * Float.sin(phi),  // Y
      Float.cos(theta)                     // Z
    ];
    
    // Determine threat axis (if any significant activation)
    let threatAxis : ?DuraAxis = if (maxActivation > 0.5) {
      ?indexToAxis(maxAxisIdx)
    } else {
      null
    };
    
    let newDetectionCount = switch (threatAxis) {
      case (?_) state.detectionCount + 1;
      case null state.detectionCount;
    };
    
    {
      helixPhase = newPhase;
      axisActivations = Array.freeze(newActivations);
      convergenceVector = convergenceVector;
      lastThreatAxis = threatAxis;
      rotationCount = newRotationCount;
      detectionCount = newDetectionCount;
      beatNum = beatNum;
    }
  };
  
  func indexToAxis(idx: Nat) : DuraAxis {
    switch (idx % 6) {
      case 0 #CoreSubstrate;
      case 1 #LateralNode;
      case 2 #VerticalIO;
      case 3 #Temporal;
      case 4 #IdentityContinuity;
      case _ #AntiOrganism;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PARALLAX — SOVEREIGN FIELD PROJECTOR (PHASE SOVEREIGNTY)
  // ═══════════════════════════════════════════════════════════════════════════
  // In exterior attack mode, PARALLAX rotates continuously. Any external system
  // trying to sync at the wrong phase receives a mathematically incoherent field.
  // They cannot replicate what they cannot sync to.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ParallaxState = {
    field             : Float;         // Current field value
    phase             : Float;         // Rotation phase [0, 2π)
    kf                : Float;         // Coupling strength
    lockCount         : Nat;           // Successful phase locks (friendly)
    rejectCount       : Nat;           // Failed sync attempts (hostile)
    beatNum           : Nat;
  };
  
  public func initParallax(kf: Float) : ParallaxState {
    {
      field = 0.0;
      phase = 0.0;
      kf = kf;
      lockCount = 0;
      rejectCount = 0;
      beatNum = 0;
    }
  };
  
  // Update PARALLAX field
  public func updateParallax(
    state : ParallaxState,
    coherenceC : Float,
    beatNum : Nat
  ) : ParallaxState {
    // Field equation: parallaxField = coherence × kf × sin(beat × 0.0017)
    let newPhase = wrapPhase(Float.fromInt(beatNum) * DURA_ROTATION_SPEED);
    let newField = coherenceC * state.kf * Float.sin(newPhase);
    
    {
      field = newField;
      phase = newPhase;
      kf = state.kf;
      lockCount = state.lockCount;
      rejectCount = state.rejectCount;
      beatNum = beatNum;
    }
  };
  
  // Check if external system can sync with PARALLAX
  public func canSyncParallax(
    state : ParallaxState,
    externalPhase : Float
  ) : Bool {
    let phaseDiff = Float.abs(wrapPhase(state.phase - externalPhase));
    let minDiff = Float.min(phaseDiff, TWO_PI - phaseDiff);
    minDiff < PARALLAX_PHASE_TOLERANCE
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VERITAS — TRUTH WEAPON (ADVERSARY SCORING)
  // ═══════════════════════════════════════════════════════════════════════════
  // VERITAS scores external agents. Low score = hostile classification.
  // veritasField = identity × (1 - drift) × coherence
  // Adversaries by definition carry high drift relative to sovereign identity.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type VeritasState = {
    field             : Float;         // Current truth field
    identity          : Float;         // Sovereign identity signal
    drift             : Float;         // Drift from doctrine
    coherence         : Float;         // Coherence factor
    hostileCount      : Nat;           // Entities classified hostile
    friendlyCount     : Nat;           // Entities classified friendly
    beatNum           : Nat;
  };
  
  public func initVeritas() : VeritasState {
    {
      field = 1.0;
      identity = 1.0;
      drift = 0.0;
      coherence = 1.0;
      hostileCount = 0;
      friendlyCount = 0;
      beatNum = 0;
    }
  };
  
  // Update VERITAS field
  public func updateVeritas(
    state : VeritasState,
    identity : Float,
    drift : Float,
    coherence : Float,
    beatNum : Nat
  ) : VeritasState {
    // veritasField = identity × (1 - drift) × coherence
    let newField = identity * (1.0 - drift) * coherence;
    
    {
      field = newField;
      identity = identity;
      drift = drift;
      coherence = coherence;
      hostileCount = state.hostileCount;
      friendlyCount = state.friendlyCount;
      beatNum = beatNum;
    }
  };
  
  // Score an external entity
  public func scoreEntity(
    state : VeritasState,
    entityIdentity : Float,
    entityDrift : Float,
    entityCoherence : Float
  ) : (Float, Bool) {  // Returns (score, isHostile)
    let score = entityIdentity * (1.0 - entityDrift) * entityCoherence;
    let isHostile = score < VERITAS_HOSTILE_THRESHOLD;
    (score, isHostile)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // RIFT — COUNTER-STRIKE TRACER (SOURCE ATTRIBUTION + COMPOUNDING PENALTY)
  // ═══════════════════════════════════════════════════════════════════════════
  // RIFT traces the source chain of any adversarial input, maps exactly who
  // sent it, and assigns PERMANENT weight to that source. On repeat attempts,
  // RIFT's compounding consequence weight activates BEFORE DURA even fires.
  // RIFT is the memory of every attack. It does NOT forgive. It does NOT reset.
  // It COMPOUNDS.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type AdversaryRecord = {
    sourceHash        : Nat;           // FNV-1a hash of source identifier
    firstContactBeat  : Nat;           // When first detected
    lastContactBeat   : Nat;           // Most recent contact
    contactCount      : Nat;           // Total contact attempts
    penaltyWeight     : Float;         // COMPOUNDING penalty weight
    veritasScore      : Float;         // Last VERITAS score
    pathwayHashes     : [Nat];         // All pathways this source has used
    classification    : AdversaryClass;
  };
  
  public type AdversaryClass = {
    #Unknown;
    #Suspicious;
    #Hostile;
    #ExistentialThreat;
  };
  
  public type RiftState = {
    adversaryRegistry : [AdversaryRecord];  // Permanent record of all adversaries
    totalTraces       : Nat;                 // Total trace operations
    compoundingEvents : Nat;                 // Times penalty increased
    beatNum           : Nat;
  };
  
  public func initRift() : RiftState {
    {
      adversaryRegistry = [];
      totalTraces = 0;
      compoundingEvents = 0;
      beatNum = 0;
    }
  };
  
  // FNV-1a hash (32-bit)
  func fnv1a(input: Text) : Nat {
    var hash : Nat = 2166136261;
    for (c in input.chars()) {
      let byte = Nat32.toNat(Char.toNat32(c));
      hash := (hash * 16777619) % 4294967296;
      hash := hash ^ byte;
    };
    hash
  };
  
  // Trace a source and assign/compound penalty
  public func traceSource(
    state : RiftState,
    sourceId : Text,
    pathwayId : Text,
    veritasScore : Float,
    beatNum : Nat
  ) : RiftState {
    let sourceHash = fnv1a(sourceId);
    let pathwayHash = fnv1a(pathwayId);
    
    // Check if source already in registry
    var found = false;
    var updatedRegistry = Buffer.Buffer<AdversaryRecord>(state.adversaryRegistry.size() + 1);
    var compoundingEvent = false;
    
    for (record in state.adversaryRegistry.vals()) {
      if (record.sourceHash == sourceHash) {
        found := true;
        
        // COMPOUND the penalty weight
        let newPenalty = Float.min(
          record.penaltyWeight * RIFT_COMPOUND_BASE,
          RIFT_MAX_PENALTY
        );
        compoundingEvent := true;
        
        // Add pathway if new
        var pathways = Buffer.Buffer<Nat>(record.pathwayHashes.size() + 1);
        for (p in record.pathwayHashes.vals()) { pathways.add(p) };
        var pathwayExists = false;
        for (p in record.pathwayHashes.vals()) {
          if (p == pathwayHash) { pathwayExists := true };
        };
        if (not pathwayExists) { pathways.add(pathwayHash) };
        
        // Update classification based on penalty
        let newClass : AdversaryClass = if (newPenalty > 100.0) {
          #ExistentialThreat
        } else if (newPenalty > 10.0) {
          #Hostile
        } else if (newPenalty > 2.0) {
          #Suspicious
        } else {
          #Unknown
        };
        
        updatedRegistry.add({
          sourceHash = record.sourceHash;
          firstContactBeat = record.firstContactBeat;
          lastContactBeat = beatNum;
          contactCount = record.contactCount + 1;
          penaltyWeight = newPenalty;
          veritasScore = veritasScore;
          pathwayHashes = Buffer.toArray(pathways);
          classification = newClass;
        });
      } else {
        updatedRegistry.add(record);
      };
    };
    
    // If new source, add initial record
    if (not found) {
      let initialClass : AdversaryClass = if (veritasScore < VERITAS_HOSTILE_THRESHOLD) {
        #Hostile
      } else if (veritasScore < 0.5) {
        #Suspicious
      } else {
        #Unknown
      };
      
      updatedRegistry.add({
        sourceHash = sourceHash;
        firstContactBeat = beatNum;
        lastContactBeat = beatNum;
        contactCount = 1;
        penaltyWeight = RIFT_INITIAL_PENALTY;
        veritasScore = veritasScore;
        pathwayHashes = [pathwayHash];
        classification = initialClass;
      });
    };
    
    {
      adversaryRegistry = Buffer.toArray(updatedRegistry);
      totalTraces = state.totalTraces + 1;
      compoundingEvents = if (compoundingEvent) state.compoundingEvents + 1 else state.compoundingEvents;
      beatNum = beatNum;
    }
  };
  
  // Get penalty weight for a source (pre-DURA check)
  public func getSourcePenalty(state : RiftState, sourceId : Text) : Float {
    let sourceHash = fnv1a(sourceId);
    for (record in state.adversaryRegistry.vals()) {
      if (record.sourceHash == sourceHash) {
        return record.penaltyWeight;
      };
    };
    0.0  // Unknown source = no penalty yet
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORIA — PERMANENT SEAL (ADVERSARY FOREVER)
  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORIA seals adversary classification permanently. Once sealed, the source
  // is a known adversary FOREVER. MEMORIA entries cannot be deleted or reset.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type MemoriaSeal = {
    sourceHash        : Nat;
    sealBeat          : Nat;
    sealCoherence     : Float;         // Coherence at time of seal
    classification    : AdversaryClass;
    veritasScore      : Float;
    totalContacts     : Nat;
    finalPenalty      : Float;
    sealHash          : Nat;           // FNV-1a hash of seal data (immutable proof)
  };
  
  public type MemoriaState = {
    seals             : [MemoriaSeal];
    totalSeals        : Nat;
    beatNum           : Nat;
  };
  
  public func initMemoria() : MemoriaState {
    {
      seals = [];
      totalSeals = 0;
      beatNum = 0;
    }
  };
  
  // Seal an adversary permanently
  public func sealAdversary(
    state : MemoriaState,
    riftRecord : AdversaryRecord,
    coherenceC : Float,
    beatNum : Nat
  ) : MemoriaState {
    // Check if already sealed
    for (seal in state.seals.vals()) {
      if (seal.sourceHash == riftRecord.sourceHash) {
        return state;  // Already sealed, immutable
      };
    };
    
    // Create seal hash (proof of seal)
    let sealData = Nat.toText(riftRecord.sourceHash) # 
                   Nat.toText(beatNum) # 
                   Float.toText(riftRecord.penaltyWeight);
    let sealHash = fnv1a(sealData);
    
    let newSeal : MemoriaSeal = {
      sourceHash = riftRecord.sourceHash;
      sealBeat = beatNum;
      sealCoherence = coherenceC;
      classification = riftRecord.classification;
      veritasScore = riftRecord.veritasScore;
      totalContacts = riftRecord.contactCount;
      finalPenalty = riftRecord.penaltyWeight;
      sealHash = sealHash;
    };
    
    var newSeals = Buffer.Buffer<MemoriaSeal>(state.seals.size() + 1);
    for (s in state.seals.vals()) { newSeals.add(s) };
    newSeals.add(newSeal);
    
    {
      seals = Buffer.toArray(newSeals);
      totalSeals = state.totalSeals + 1;
      beatNum = beatNum;
    }
  };
  
  // Check if source is sealed
  public func isSealed(state : MemoriaState, sourceId : Text) : Bool {
    let sourceHash = fnv1a(sourceId);
    for (seal in state.seals.vals()) {
      if (seal.sourceHash == sourceHash) {
        return true;
      };
    };
    false
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLETE VAEL EXTERIOR ATTACK STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type VAELAttackState = {
    dura      : DuraState;
    parallax  : ParallaxState;
    veritas   : VeritasState;
    rift      : RiftState;
    memoria   : MemoriaState;
    
    // Attack chain status
    chainActive       : Bool;
    chainStage        : Nat;  // 0=idle, 1=DURA, 2=PARALLAX, 3=VERITAS, 4=RIFT, 5=MEMORIA
    currentTargetHash : ?Nat;
    attacksExecuted   : Nat;
    beatNum           : Nat;
  };
  
  public func initVAELAttack(kf: Float) : VAELAttackState {
    {
      dura = initDura();
      parallax = initParallax(kf);
      veritas = initVeritas();
      rift = initRift();
      memoria = initMemoria();
      chainActive = false;
      chainStage = 0;
      currentTargetHash = null;
      attacksExecuted = 0;
      beatNum = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLETE ATTACK CHAIN — SELF-COMPOUNDING ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════
  // The attack chain is PURE MATH. It works the same way regardless of how
  // many adversaries or how many beats have passed. The compounding penalty
  // is the only thing that changes — and it only goes UP.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func executeAttackChain(
    state : VAELAttackState,
    externalSignature : [Float],  // 6-dimensional DURA input
    sourceId : Text,
    pathwayId : Text,
    entityIdentity : Float,
    entityDrift : Float,
    entityCoherence : Float,
    organismIdentity : Float,
    organismDrift : Float,
    organismCoherence : Float,
    beatNum : Nat
  ) : VAELAttackState {
    
    // PRE-CHECK: RIFT penalty for known adversaries (fires BEFORE DURA)
    let prePenalty = getSourcePenalty(state.rift, sourceId);
    if (prePenalty > 10.0) {
      // Known hostile — immediate reject, compound penalty
      let updatedRift = traceSource(state.rift, sourceId, pathwayId, 0.0, beatNum);
      return {
        state with
        rift = updatedRift;
        chainActive = false;
        chainStage = 0;
        attacksExecuted = state.attacksExecuted + 1;
        beatNum = beatNum;
      };
    };
    
    // STAGE 1: DURA maps axis and convergence vector
    let newDura = updateDura(state.dura, externalSignature, organismCoherence, beatNum);
    
    // STAGE 2: PARALLAX phase-locks sovereign field
    let newParallax = updateParallax(state.parallax, organismCoherence, beatNum);
    let canSync = canSyncParallax(newParallax, Float.fromInt(beatNum) * 0.1);  // External phase estimate
    
    // STAGE 3: VERITAS scores the adversary
    let newVeritas = updateVeritas(state.veritas, organismIdentity, organismDrift, organismCoherence, beatNum);
    let (veritasScore, isHostile) = scoreEntity(newVeritas, entityIdentity, entityDrift, entityCoherence);
    
    // STAGE 4: RIFT traces and assigns penalty
    let newRift = traceSource(state.rift, sourceId, pathwayId, veritasScore, beatNum);
    
    // STAGE 5: MEMORIA seals if hostile
    var newMemoria = state.memoria;
    if (isHostile) {
      // Find the record we just updated
      for (record in newRift.adversaryRegistry.vals()) {
        if (fnv1a(sourceId) == record.sourceHash) {
          newMemoria := sealAdversary(state.memoria, record, organismCoherence, beatNum);
        };
      };
    };
    
    {
      dura = newDura;
      parallax = newParallax;
      veritas = { newVeritas with 
        hostileCount = if (isHostile) newVeritas.hostileCount + 1 else newVeritas.hostileCount;
        friendlyCount = if (not isHostile) newVeritas.friendlyCount + 1 else newVeritas.friendlyCount;
      };
      rift = newRift;
      memoria = newMemoria;
      chainActive = isHostile;
      chainStage = 5;  // Completed
      currentTargetHash = ?fnv1a(sourceId);
      attacksExecuted = state.attacksExecuted + 1;
      beatNum = beatNum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  func wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };
  
  // Beat update (call every heartbeat)
  public func beatUpdate(
    state : VAELAttackState,
    organismIdentity : Float,
    organismDrift : Float,
    organismCoherence : Float,
    beatNum : Nat
  ) : VAELAttackState {
    // Update components that rotate/evolve every beat
    let newDura = { state.dura with 
      helixPhase = wrapPhase(state.dura.helixPhase + DURA_ROTATION_SPEED);
      beatNum = beatNum;
    };
    let newParallax = updateParallax(state.parallax, organismCoherence, beatNum);
    let newVeritas = updateVeritas(state.veritas, organismIdentity, organismDrift, organismCoherence, beatNum);
    
    {
      dura = newDura;
      parallax = newParallax;
      veritas = newVeritas;
      rift = { state.rift with beatNum = beatNum };
      memoria = { state.memoria with beatNum = beatNum };
      chainActive = false;
      chainStage = 0;
      currentTargetHash = null;
      attacksExecuted = state.attacksExecuted;
      beatNum = beatNum;
    }
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
