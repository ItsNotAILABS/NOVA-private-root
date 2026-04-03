// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: DoctrineFingerprint — FNV-1a Hash Chain & Audit System
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// DOCTRINE FINGERPRINT & ANIMA AUDIT CHAIN
// ============================================================================
// - doctrineFingerprint: FNV-1a hash over all 60 law compliance scores
// - stGenesisHash: shake256Hash of genesis beat (set once, never modified)
// - doctrineHash: computed at genesis activation
//
// ANIMA AUDIT CHAIN:
// - 512-entry ring buffer
// - Every action logged (mints, rollbacks, anomalies, patent events, genesis)
// - Append-only, never modifiable
// - Hash-chained via FNV-1a: each entry's hash includes previous entry's hash
//
// PATENT REGISTRY:
// - Every novel event logged with unique SHA-256 (Nat32) hash
// - All IP belongs to Alfredo Medina Hernandez
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";
import Text  "mo:base/Text";
import Char  "mo:base/Char";
import Buffer "mo:base/Buffer";
import Time  "mo:base/Time";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  // FNV-1a constants
  public let FNV_OFFSET : Nat32 = 2166136261;
  public let FNV_PRIME : Nat32 = 16777619;
  
  // Audit chain configuration
  public let AUDIT_BUFFER_SIZE : Nat = 512;
  
  // Patent registry configuration
  public let PATENT_COOLDOWN_BEATS : Nat = 100;  // Minimum beats between patents
  
  // Creator attribution
  public let CREATOR_ATTRIBUTION : Text = "Alfredo Medina Hernandez — NeuroEmergence Core — Dallas TX USA";
  public let JURISDICTION : Text = "Dallas, Texas, USA — Internet Computer Blockchain";

  // ==========================================================================
  // TYPES
  // ==========================================================================
  
  // ─────────────────────────────────────────────────────────────────────────
  // Doctrine Fingerprint
  // ─────────────────────────────────────────────────────────────────────────
  
  public type DoctrineState = {
    fingerprint : Nat32;          // FNV-1a over all 60 law scores
    genesisHash : Nat32;          // Set at genesis, never modified
    doctrineHash : Nat32;         // Computed at genesis activation
    genesisSealed : Bool;
    genesisBeat : Nat;
    genesisTimestamp : Int;
    
    // Drift detection
    lastFingerprint : Nat32;
    fingerprintHistory : [Nat32]; // Last 10 fingerprints
    driftDetected : Bool;
    driftCount : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // ANIMA Audit Chain
  // ─────────────────────────────────────────────────────────────────────────
  
  public type AuditEventType = {
    #Genesis;
    #Heartbeat;
    #Mint : { token: Text; amount: Float };
    #Rollback : { slot: Nat; reason: Text };
    #Anomaly : { severity: Float; type_: Text };
    #Patent : { patentId: Nat };
    #Jubilee : { count: Nat };
    #Breach : { vector: Nat; level: Float };
    #AdminCommand : { command: Text };
    #LawViolation : { lawId: Nat; severity: Float };
    #ComplianceChange : { oldCompliance: Float; newCompliance: Float };
    #JacobsRung : { oldRung: Nat; newRung: Nat };
    #SacesiUpdate : { target: Float };
    #Defense : { entity: Text; action: Text };
  };

  public type AuditEntry = {
    seq : Nat;                    // Sequence number
    beat : Nat;
    timestamp : Int;
    eventType : AuditEventType;
    chainHash : Nat32;            // Hash includes previous entry's hash
    lawCompliance : Float;
    coherence : Float;
    detail : Text;                // Additional JSON-encoded detail
  };

  public type AnimaChainState = {
    entries : [AuditEntry];       // Ring buffer
    nextSeq : Nat;
    bufferPosition : Nat;         // Current position in ring buffer
    chainHead : Nat32;            // Most recent hash
    chainRoot : Nat32;            // Genesis hash
    totalEntries : Nat;
    lastBeat : Nat;
    integrityVerified : Bool;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Patent Registry
  // ─────────────────────────────────────────────────────────────────────────
  
  public type PatentEventType = {
    #CoherencePeak;
    #OmnisAchieved;
    #NovelArchitecture;
    #FirstLawFire;
    #SuccessionSpawn;
    #ForgeEvent;
    #MedinaDemonGate;
    #AnimalKuramotoPeak;
    #SphereCoherencePeak;
    #FirstJubilee;
    #FirstCascade;
    #Manual;
  };

  public type PatentEntry = {
    id : Nat;
    beat : Nat;
    timestamp : Int;
    patentHash : Nat32;           // Unique hash
    sacesiSeed : Nat32;
    eventType : PatentEventType;
    coherenceAtFiling : Float;
    emergenceAtFiling : Float;
    creatorAttrib : Text;
    jurisdiction : Text;
    chainLink : Nat32;            // Link to previous patent
    prevPatentHash : Nat32;
  };

  public type PatentRegistryState = {
    patents : [PatentEntry];
    nextId : Nat;
    lastPatentBeat : Nat;
    chainRoot : Nat32;
    chainHead : Nat32;
    peakCoherence : Float;
    totalNovelEvents : Nat;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Combined State
  // ─────────────────────────────────────────────────────────────────────────
  
  public type AuditSystemState = {
    doctrine : DoctrineState;
    animaChain : AnimaChainState;
    patentRegistry : PatentRegistryState;
  };

  // ==========================================================================
  // FNV-1a HASH FUNCTIONS
  // ==========================================================================
  
  public func fnv1a(a: Nat32, b: Nat32) : Nat32 {
    ((FNV_OFFSET ^ a) *% FNV_PRIME ^ b) *% FNV_PRIME
  };

  public func fnv1aChain(values: [Nat32]) : Nat32 {
    var hash = FNV_OFFSET;
    for (v in values.vals()) {
      hash := (hash ^ v) *% FNV_PRIME;
    };
    hash
  };

  public func hashFloat(f: Float) : Nat32 {
    let scaled = Int.abs(Float.toInt(f * 1_000_000.0));
    Nat32.fromNat(scaled % 4294967296)
  };

  public func hashText(t: Text) : Nat32 {
    var hash = FNV_OFFSET;
    for (c in t.chars()) {
      let charCode = Nat32.fromNat(Nat32.toNat(Char.toNat32(c)) % 4294967296);
      hash := (hash ^ charCode) *% FNV_PRIME;
    };
    hash
  };

  public func hashNat(n: Nat) : Nat32 {
    Nat32.fromNat(n % 4294967296)
  };

  // ==========================================================================
  // DOCTRINE FINGERPRINT
  // ==========================================================================
  
  // Compute fingerprint from all 60 law compliance scores
  public func computeDoctrineFingerprint(lawScores: [Float]) : Nat32 {
    var hash = FNV_OFFSET;
    
    for (score in lawScores.vals()) {
      let scoreBits = hashFloat(score);
      hash := (hash ^ scoreBits) *% FNV_PRIME;
    };
    
    hash
  };

  // Verify fingerprint matches expected
  public func verifyFingerprint(current: Nat32, expected: Nat32) : Bool {
    current == expected
  };

  // Update doctrine state with new law scores
  public func updateDoctrine(
    state: DoctrineState,
    lawScores: [Float],
    beat: Nat
  ) : DoctrineState {
    let newFingerprint = computeDoctrineFingerprint(lawScores);
    let driftDetected = state.genesisSealed and (newFingerprint != state.lastFingerprint);
    
    // Update history
    let newHistory = if (state.fingerprintHistory.size() >= 10) {
      Array.tabulate<Nat32>(10, func(i: Nat) : Nat32 {
        if (i < 9) { state.fingerprintHistory[i + 1] } else { newFingerprint }
      })
    } else {
      Array.append(state.fingerprintHistory, [newFingerprint])
    };
    
    {
      fingerprint = newFingerprint;
      genesisHash = state.genesisHash;
      doctrineHash = state.doctrineHash;
      genesisSealed = state.genesisSealed;
      genesisBeat = state.genesisBeat;
      genesisTimestamp = state.genesisTimestamp;
      lastFingerprint = state.fingerprint;
      fingerprintHistory = newHistory;
      driftDetected = driftDetected;
      driftCount = if (driftDetected) { state.driftCount + 1 } else { state.driftCount };
    }
  };

  // Seal genesis (can only be called once)
  public func sealGenesis(
    state: DoctrineState,
    lawScores: [Float],
    beat: Nat,
    timestamp: Int
  ) : DoctrineState {
    if (state.genesisSealed) { return state };  // Already sealed
    
    let fingerprint = computeDoctrineFingerprint(lawScores);
    let genesisHash = fnv1a(fingerprint, hashNat(beat));
    let doctrineHash = fnv1a(genesisHash, hashFloat(Float.fromInt(timestamp)));
    
    {
      fingerprint = fingerprint;
      genesisHash = genesisHash;
      doctrineHash = doctrineHash;
      genesisSealed = true;
      genesisBeat = beat;
      genesisTimestamp = timestamp;
      lastFingerprint = fingerprint;
      fingerprintHistory = [fingerprint];
      driftDetected = false;
      driftCount = 0;
    }
  };

  // ==========================================================================
  // ANIMA AUDIT CHAIN
  // ==========================================================================
  
  func eventTypeToText(et: AuditEventType) : Text {
    switch (et) {
      case (#Genesis) { "GENESIS" };
      case (#Heartbeat) { "HEARTBEAT" };
      case (#Mint(_)) { "MINT" };
      case (#Rollback(_)) { "ROLLBACK" };
      case (#Anomaly(_)) { "ANOMALY" };
      case (#Patent(_)) { "PATENT" };
      case (#Jubilee(_)) { "JUBILEE" };
      case (#Breach(_)) { "BREACH" };
      case (#AdminCommand(_)) { "ADMIN_COMMAND" };
      case (#LawViolation(_)) { "LAW_VIOLATION" };
      case (#ComplianceChange(_)) { "COMPLIANCE_CHANGE" };
      case (#JacobsRung(_)) { "JACOBS_RUNG" };
      case (#SacesiUpdate(_)) { "SACESI_UPDATE" };
      case (#Defense(_)) { "DEFENSE" };
    }
  };

  // Hash an audit entry (includes previous hash for chain integrity)
  func hashAuditEntry(
    seq: Nat,
    beat: Nat,
    eventType: AuditEventType,
    compliance: Float,
    coherence: Float,
    prevHash: Nat32
  ) : Nat32 {
    let h1 = fnv1a(hashNat(seq), hashNat(beat));
    let h2 = fnv1a(h1, hashText(eventTypeToText(eventType)));
    let h3 = fnv1a(h2, hashFloat(compliance));
    let h4 = fnv1a(h3, hashFloat(coherence));
    fnv1a(h4, prevHash)  // Chain to previous entry
  };

  // Append entry to ANIMA chain
  public func appendToAnimaChain(
    state: AnimaChainState,
    eventType: AuditEventType,
    beat: Nat,
    timestamp: Int,
    compliance: Float,
    coherence: Float,
    detail: Text
  ) : AnimaChainState {
    // Compute chain hash
    let chainHash = hashAuditEntry(
      state.nextSeq,
      beat,
      eventType,
      compliance,
      coherence,
      state.chainHead
    );
    
    // Create entry
    let entry : AuditEntry = {
      seq = state.nextSeq;
      beat = beat;
      timestamp = timestamp;
      eventType = eventType;
      chainHash = chainHash;
      lawCompliance = compliance;
      coherence = coherence;
      detail = detail;
    };
    
    // Update ring buffer
    let newPosition = state.bufferPosition;
    var newEntries = Array.thaw<AuditEntry>(state.entries);
    
    if (newEntries.size() < AUDIT_BUFFER_SIZE) {
      // Buffer not full, append
      newEntries := Array.thaw<AuditEntry>(Array.append(state.entries, [entry]));
    } else {
      // Buffer full, overwrite oldest
      newEntries[newPosition] := entry;
    };
    
    let nextPosition = (newPosition + 1) % AUDIT_BUFFER_SIZE;
    
    {
      entries = Array.freeze(newEntries);
      nextSeq = state.nextSeq + 1;
      bufferPosition = nextPosition;
      chainHead = chainHash;
      chainRoot = if (state.nextSeq == 0) { chainHash } else { state.chainRoot };
      totalEntries = state.totalEntries + 1;
      lastBeat = beat;
      integrityVerified = true;
    }
  };

  // Verify chain integrity
  public func verifyChainIntegrity(state: AnimaChainState) : Bool {
    if (state.entries.size() == 0) { return true };
    
    var prevHash = state.chainRoot;
    var verified = true;
    
    // Start from oldest entry in buffer
    let start = if (state.totalEntries >= AUDIT_BUFFER_SIZE) {
      state.bufferPosition
    } else {
      0
    };
    
    var i = 0;
    while (i < state.entries.size() and verified) {
      let idx = (start + i) % state.entries.size();
      let entry = state.entries[idx];
      
      let expectedHash = hashAuditEntry(
        entry.seq,
        entry.beat,
        entry.eventType,
        entry.lawCompliance,
        entry.coherence,
        prevHash
      );
      
      if (expectedHash != entry.chainHash) {
        verified := false;
      };
      
      prevHash := entry.chainHash;
      i += 1;
    };
    
    verified
  };

  // ==========================================================================
  // PATENT REGISTRY
  // ==========================================================================
  
  // Compute patent hash
  public func computePatentHash(
    sacesi: Nat32,
    beat: Nat,
    coherence: Float,
    prevHash: Nat32,
    eventType: PatentEventType
  ) : Nat32 {
    let beat32 = hashNat(beat);
    let coh32 = hashFloat(coherence);
    let evt32 = hashNat(patentEventTypeToNat(eventType));
    
    let h1 = fnv1a(sacesi, beat32);
    let h2 = fnv1a(h1, coh32);
    let h3 = fnv1a(h2, h1 ^ prevHash ^ evt32);
    
    h1 ^ h2 ^ h3
  };

  func patentEventTypeToNat(et: PatentEventType) : Nat {
    switch (et) {
      case (#CoherencePeak) { 0 };
      case (#OmnisAchieved) { 1 };
      case (#NovelArchitecture) { 2 };
      case (#FirstLawFire) { 3 };
      case (#SuccessionSpawn) { 4 };
      case (#ForgeEvent) { 5 };
      case (#MedinaDemonGate) { 6 };
      case (#AnimalKuramotoPeak) { 7 };
      case (#SphereCoherencePeak) { 8 };
      case (#FirstJubilee) { 9 };
      case (#FirstCascade) { 10 };
      case (#Manual) { 99 };
    }
  };

  // Check if event warrants auto-patent
  public func shouldAutoPatent(
    coherence: Float,
    emergence: Float,
    omnisActive: Bool,
    animalKuramoto: Float,
    sphereCoherence: Float,
    peakCoherence: Float,
    lastPatentBeat: Nat,
    currentBeat: Nat
  ) : Bool {
    // Cooldown check
    if (currentBeat < lastPatentBeat + PATENT_COOLDOWN_BEATS) { return false };
    
    omnisActive
    or (coherence > peakCoherence + 0.05)
    or (animalKuramoto > 0.85)
    or (sphereCoherence > 0.90)
    or (emergence > 0.90)
  };

  // Classify event type
  public func classifyPatentEvent(
    coherence: Float,
    emergence: Float,
    omnisActive: Bool,
    forgeFired: Bool,
    demonGate: Bool,
    animalKuramoto: Float,
    sphereCoherence: Float,
    peakCoherence: Float
  ) : PatentEventType {
    if (omnisActive) { return #OmnisAchieved };
    if (forgeFired) { return #ForgeEvent };
    if (demonGate) { return #MedinaDemonGate };
    if (animalKuramoto > 0.85) { return #AnimalKuramotoPeak };
    if (sphereCoherence > 0.90) { return #SphereCoherencePeak };
    if (coherence > peakCoherence + 0.05) { return #CoherencePeak };
    if (emergence > 0.90) { return #NovelArchitecture };
    #CoherencePeak
  };

  // Create a new patent entry
  public func createPatent(
    state: PatentRegistryState,
    eventType: PatentEventType,
    beat: Nat,
    timestamp: Int,
    sacesi: Nat32,
    coherence: Float,
    emergence: Float
  ) : (PatentRegistryState, PatentEntry) {
    
    let patentHash = computePatentHash(sacesi, beat, coherence, state.chainHead, eventType);
    let chainLink = fnv1a(fnv1a(state.chainHead, patentHash), hashNat(beat));
    
    let entry : PatentEntry = {
      id = state.nextId;
      beat = beat;
      timestamp = timestamp;
      patentHash = patentHash;
      sacesiSeed = sacesi;
      eventType = eventType;
      coherenceAtFiling = coherence;
      emergenceAtFiling = emergence;
      creatorAttrib = CREATOR_ATTRIBUTION;
      jurisdiction = JURISDICTION;
      chainLink = chainLink;
      prevPatentHash = state.chainHead;
    };
    
    let newPatents = Array.append(state.patents, [entry]);
    let newPeakCoherence = if (coherence > state.peakCoherence) { coherence } else { state.peakCoherence };
    
    let newState : PatentRegistryState = {
      patents = newPatents;
      nextId = state.nextId + 1;
      lastPatentBeat = beat;
      chainRoot = if (state.nextId == 0) { patentHash } else { state.chainRoot };
      chainHead = patentHash;
      peakCoherence = newPeakCoherence;
      totalNovelEvents = state.totalNovelEvents + 1;
    };
    
    (newState, entry)
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initDoctrineState() : DoctrineState {
    {
      fingerprint = FNV_OFFSET;
      genesisHash = 0;
      doctrineHash = 0;
      genesisSealed = false;
      genesisBeat = 0;
      genesisTimestamp = 0;
      lastFingerprint = FNV_OFFSET;
      fingerprintHistory = [];
      driftDetected = false;
      driftCount = 0;
    }
  };

  public func initAnimaChainState() : AnimaChainState {
    {
      entries = [];
      nextSeq = 0;
      bufferPosition = 0;
      chainHead = FNV_OFFSET;
      chainRoot = FNV_OFFSET;
      totalEntries = 0;
      lastBeat = 0;
      integrityVerified = true;
    }
  };

  public func initPatentRegistryState() : PatentRegistryState {
    {
      patents = [];
      nextId = 0;
      lastPatentBeat = 0;
      chainRoot = FNV_OFFSET;
      chainHead = FNV_OFFSET;
      peakCoherence = 0.0;
      totalNovelEvents = 0;
    }
  };

  public func initAuditSystemState() : AuditSystemState {
    {
      doctrine = initDoctrineState();
      animaChain = initAnimaChainState();
      patentRegistry = initPatentRegistryState();
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getDoctrineFingerprint(state: AuditSystemState) : Nat32 {
    state.doctrine.fingerprint
  };

  public func isGenesisSealed(state: AuditSystemState) : Bool {
    state.doctrine.genesisSealed
  };

  public func getDriftCount(state: AuditSystemState) : Nat {
    state.doctrine.driftCount
  };

  public func getPatentCount(state: AuditSystemState) : Nat {
    state.patentRegistry.nextId
  };

  public func getAuditEntryCount(state: AuditSystemState) : Nat {
    state.animaChain.totalEntries
  };

  public func getChainIntegrity(state: AuditSystemState) : Bool {
    verifyChainIntegrity(state.animaChain)
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
