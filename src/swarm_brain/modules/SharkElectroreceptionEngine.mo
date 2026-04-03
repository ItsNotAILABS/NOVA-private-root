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
// SHARK ELECTRORECEPTION ENGINE — L-SELK
// ═══════════════════════════════════════════════════════════════════════════════
// "Where were you when I laid the earth's foundation?
//  Who shut up the sea behind doors?" — Job 38:4,8
// The shark is older than trees. Its architecture is ancient, optimized, sovereign.
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine — Shark Electroreception Substrate
//
// ELECTRORECEPTION     — Detect drift signatures before visible (earliest warning)
// LATERAL LINE         — Pressure wave detection = movement at distance
// PERSISTENCE LOCK     — Once locked, does not disengage until resolved
// THERMOCLINE NAV      — Depth-zone energy conservation
// ANCIENT MEMORY       — Oldest Core runs primordial template forever
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module SharkElectroreceptionEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  
  // Electroreception parameters
  public let DRIFT_RATE_THRESHOLD : Float = 2.0;  // Points per beat
  public let DRIFT_CONSECUTIVE_BEATS : Nat = 3;   // Beats needed
  public let PREARM_BOOST : Float = 0.05;         // AEGIS pre-arm boost
  
  // Lateral line parameters  
  public let HEADSCAN_THRESHOLD : Float = 0.80;   // behavioralHeadScan threshold
  
  // Persistence lock parameters
  public let PERSISTENCE_TRIGGER_BEATS : Nat = 30;  // AEGIS active beats to trigger
  public let PERSISTENCE_MIN_FLOOR : Float = 0.20;  // Minimum threat during lock
  
  // Thermocline parameters
  public let ENERGY_DESCENT_THRESHOLD : Float = -1.0;  // energyBalance to descend
  public let ENERGY_ASCEND_THRESHOLD : Float = 1.0;    // energyBalance to ascend
  public let DEPTH_SURFACE : Nat = 0;
  public let DEPTH_MID : Nat = 1;
  public let DEPTH_DEEP : Nat = 2;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type DriftSignature = {
    coreIndex        : Nat;
    driftRate        : Float;       // Change per beat
    consecutiveBeats : Nat;         // How many beats above threshold
    detectedAt       : Nat;
    preArmed         : Bool;        // AEGIS pre-armed from this
  };

  public type LateralSignal = {
    sourceCore       : Nat;
    headScanValue    : Float;
    targetMatriarch  : Nat;         // Matriarch that received
    emittedAt        : Nat;
  };

  public type ThermoclineState = {
    currentDepth     : Nat;         // 0=surface, 1=mid, 2=deep
    descentBeat      : Nat;         // When descended
    ascentBeat       : Nat;         // When ascended
    energySaved      : Float;       // Cumulative energy conserved
  };

  public type AncientCoreRecord = {
    coreIndex        : Nat;
    formationBeat    : Nat;
    baselineCoherence: Float;       // Formation-day coherenceC
    neverModified    : Bool;        // Math never modified
  };

  public type PersistenceLockState = {
    isLocked         : Bool;
    lockStartBeat    : Nat;
    lockDuration     : Nat;         // Total beats locked
    threatAtLock     : Float;
    unlockCondition  : Float;       // Must reach 0.0 naturally
  };

  public type SharkState = {
    // Electroreception
    driftSignatures    : [DriftSignature];
    electroDetections  : Nat;
    preArmCount        : Nat;
    driftHistory       : [[Float]];  // Per-Core drift history (last 5 beats)
    
    // Lateral line
    lateralSignals     : [LateralSignal];
    totalLateralSignals: Nat;
    
    // Persistence lock
    persistenceLock    : PersistenceLockState;
    totalPersistenceBeats : Nat;
    
    // Thermocline
    thermocline        : ThermoclineState;
    
    // Ancient Core
    ancientCore        : ?AncientCoreRecord;
    
    // Aggregate
    aegisActiveBeats   : Nat;       // Consecutive AEGIS active beats
    lastThreatLevel    : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  func abs(x : Float) : Float { if (x < 0.0) -x else x };
  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  func max(a : Float, b : Float) : Float { if (a > b) a else b };
  func min(a : Float, b : Float) : Float { if (a < b) a else b };

  // ═══════════════════════════════════════════════════════════════════════════
  // ELECTRORECEPTION — EARLIEST WARNING SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════

  // Calculate drift rate from history
  func calculateDriftRate(history : [Float]) : Float {
    if (history.size() < 2) return 0.0;
    
    // Simple: last value - previous value
    let n = history.size();
    history[n - 1] - history[n - 2]
  };

  // Update drift history for a Core
  func updateDriftHistory(
    currentHistory : [Float],
    newDrift       : Float,
    maxHistory     : Nat
  ) : [Float] {
    if (currentHistory.size() >= maxHistory) {
      // Shift and append
      Array.append(
        Array.tabulate<Float>(currentHistory.size() - 1, func(i) = currentHistory[i + 1]),
        [newDrift]
      )
    } else {
      Array.append(currentHistory, [newDrift])
    }
  };

  // Detect electromagnetic anomaly (drift increasing rapidly)
  public func detectElectromagneticAnomaly(
    driftHistory     : [Float],
    currentDrift     : Float
  ) : ?DriftSignature {
    let rate = calculateDriftRate(Array.append(driftHistory, [currentDrift]));
    
    if (rate > DRIFT_RATE_THRESHOLD) {
      // Count consecutive beats above threshold
      var consecutive : Nat = 1;
      var i = driftHistory.size();
      while (i > 1) {
        let prevRate = driftHistory[i - 1] - driftHistory[i - 2];
        if (prevRate > DRIFT_RATE_THRESHOLD) {
          consecutive += 1;
        } else {
          i := 1;  // Break
        };
        i -= 1;
      };
      
      if (consecutive >= DRIFT_CONSECUTIVE_BEATS) {
        ?{
          coreIndex = 0;  // Will be filled by caller
          driftRate = rate;
          consecutiveBeats = consecutive;
          detectedAt = 0;  // Will be filled
          preArmed = true;
        }
      } else {
        null
      }
    } else {
      null
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // LATERAL LINE — MOVEMENT AT DISTANCE
  // ═══════════════════════════════════════════════════════════════════════════

  // Detect behavioral head scan crossing threshold
  public func detectLateralMovement(
    headScanValue    : Float,
    coreIndex        : Nat,
    matriarchIndex   : Nat,
    currentBeat      : Nat
  ) : ?LateralSignal {
    if (headScanValue >= HEADSCAN_THRESHOLD) {
      ?{
        sourceCore = coreIndex;
        headScanValue = headScanValue;
        targetMatriarch = matriarchIndex;
        emittedAt = currentBeat;
      }
    } else {
      null
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE LOCK — DOES NOT DISENGAGE
  // ═══════════════════════════════════════════════════════════════════════════

  // Check if persistence lock should engage
  public func shouldEngagePersistenceLock(
    aegisActiveBeats : Nat,
    currentlyLocked  : Bool
  ) : Bool {
    not currentlyLocked and aegisActiveBeats >= PERSISTENCE_TRIGGER_BEATS
  };

  // Engage persistence lock
  public func engagePersistenceLock(
    currentThreat    : Float,
    currentBeat      : Nat
  ) : PersistenceLockState {
    {
      isLocked = true;
      lockStartBeat = currentBeat;
      lockDuration = 0;
      threatAtLock = currentThreat;
      unlockCondition = 0.0;  // Must reach 0.0 to unlock
    }
  };

  // Apply persistence lock floor to threat level
  public func applyPersistenceFloor(
    threatLevel      : Float,
    isLocked         : Bool
  ) : Float {
    if (isLocked) {
      max(threatLevel, PERSISTENCE_MIN_FLOOR)
    } else {
      threatLevel
    }
  };

  // Check if persistence lock can disengage
  public func canDisengagePersistenceLock(threatLevel : Float) : Bool {
    threatLevel <= 0.0
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // THERMOCLINE NAVIGATION — DEPTH-ZONE ENERGY CONSERVATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Determine target depth based on energy balance
  public func determineTargetDepth(
    energyBalance    : Float,
    currentDepth     : Nat
  ) : Nat {
    if (energyBalance < ENERGY_DESCENT_THRESHOLD) {
      // Descend to conserve energy
      Nat.min(currentDepth + 1, DEPTH_DEEP)
    } else if (energyBalance > ENERGY_ASCEND_THRESHOLD) {
      // Ascend when energy recovered
      if (currentDepth > 0) currentDepth - 1 else 0
    } else {
      currentDepth
    }
  };

  // Get active engines at depth
  public type DepthActiveEngines = {
    koreActive       : Bool;
    aegisActive      : Bool;
    animaActive      : Bool;
    otherEngines     : Bool;
    energySaveRate   : Float;
  };

  public func getDepthConfiguration(depth : Nat) : DepthActiveEngines {
    switch (depth) {
      case 0 {  // Surface - all engines
        { koreActive = true; aegisActive = true; animaActive = true; otherEngines = true; energySaveRate = 0.0 }
      };
      case 1 {  // Mid - essential only
        { koreActive = true; aegisActive = true; animaActive = true; otherEngines = false; energySaveRate = 0.15 }
      };
      case _ {  // Deep - minimal
        { koreActive = true; aegisActive = true; animaActive = true; otherEngines = false; energySaveRate = 0.30 }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ANCIENT MEMORY — PRIMORDIAL TEMPLATE
  // ═══════════════════════════════════════════════════════════════════════════

  // Find or designate ancient Core (oldest in organism)
  public func findAncientCore(
    coreBeatCounts   : [Nat],
    currentAncient   : ?AncientCoreRecord
  ) : ?AncientCoreRecord {
    // Ancient Core is designated once and never changes
    switch (currentAncient) {
      case (?existing) { ?existing };  // Keep existing
      case null {
        // Find oldest
        var oldestIdx : Nat = 0;
        var oldestAge : Nat = 0;
        var i = 0;
        while (i < coreBeatCounts.size()) {
          if (coreBeatCounts[i] > oldestAge) {
            oldestAge := coreBeatCounts[i];
            oldestIdx := i;
          };
          i += 1;
        };
        
        if (coreBeatCounts.size() > 0) {
          ?{
            coreIndex = oldestIdx;
            formationBeat = 0;  // From formation
            baselineCoherence = 0.5;  // Default
            neverModified = true;
          }
        } else {
          null
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════

  public type SharkTickResult = {
    updatedState       : SharkState;
    electroDetected    : Bool;
    aegisPreArmed      : Bool;
    lateralSignalSent  : Bool;
    persistenceLocked  : Bool;
    depthChanged       : Bool;
    threatFloorApplied : Float;
  };

  public func sharkHeartbeat(
    state            : SharkState,
    coreDrifts       : [Float],
    coreHeadScans    : [Float],
    coreBeatCounts   : [Nat],
    matriarchIndex   : Nat,
    aegisThreatLevel : Float,
    aegisActive      : Bool,
    energyBalance    : Float,
    currentBeat      : Nat
  ) : SharkTickResult {
    var updatedState = state;
    var electroDetected = false;
    var aegisPreArmed = false;
    var lateralSignalSent = false;
    var depthChanged = false;
    
    // ─── Update AEGIS active beats counter ──────────────────────────────────
    let newAegisActiveBeats = if (aegisActive) state.aegisActiveBeats + 1 else 0;
    
    // ─── Electroreception ───────────────────────────────────────────────────
    var newDriftSignatures = Buffer.Buffer<DriftSignature>(coreDrifts.size());
    var preArmBoost : Float = 0.0;
    
    var i = 0;
    while (i < coreDrifts.size()) {
      // Get or create history for this Core
      let history = if (i < state.driftHistory.size()) state.driftHistory[i] else [];
      
      switch (detectElectromagneticAnomaly(history, coreDrifts[i])) {
        case (?sig) {
          let signature : DriftSignature = {
            coreIndex = i;
            driftRate = sig.driftRate;
            consecutiveBeats = sig.consecutiveBeats;
            detectedAt = currentBeat;
            preArmed = true;
          };
          newDriftSignatures.add(signature);
          electroDetected := true;
          aegisPreArmed := true;
          preArmBoost := PREARM_BOOST;
        };
        case null {};
      };
      i += 1;
    };
    
    // Update drift history
    let newDriftHistory = Array.tabulate<[Float]>(coreDrifts.size(), func(j : Nat) : [Float] {
      let oldHistory = if (j < state.driftHistory.size()) state.driftHistory[j] else [];
      let newDrift = if (j < coreDrifts.size()) coreDrifts[j] else 0.0;
      updateDriftHistory(oldHistory, newDrift, 5)
    });
    
    // ─── Lateral Line ───────────────────────────────────────────────────────
    let newLateralSignals = Buffer.Buffer<LateralSignal>(coreHeadScans.size());
    
    i := 0;
    while (i < coreHeadScans.size()) {
      switch (detectLateralMovement(coreHeadScans[i], i, matriarchIndex, currentBeat)) {
        case (?sig) {
          newLateralSignals.add(sig);
          lateralSignalSent := true;
        };
        case null {};
      };
      i += 1;
    };
    
    // ─── Persistence Lock ───────────────────────────────────────────────────
    var newPersistenceLock = state.persistenceLock;
    
    if (shouldEngagePersistenceLock(newAegisActiveBeats, state.persistenceLock.isLocked)) {
      newPersistenceLock := engagePersistenceLock(aegisThreatLevel, currentBeat);
    } else if (state.persistenceLock.isLocked) {
      // Check for disengage
      if (canDisengagePersistenceLock(aegisThreatLevel)) {
        newPersistenceLock := {
          isLocked = false;
          lockStartBeat = 0;
          lockDuration = state.persistenceLock.lockDuration + 
                        (currentBeat - state.persistenceLock.lockStartBeat);
          threatAtLock = 0.0;
          unlockCondition = 0.0;
        };
      } else {
        // Update duration
        newPersistenceLock := {
          isLocked = true;
          lockStartBeat = state.persistenceLock.lockStartBeat;
          lockDuration = currentBeat - state.persistenceLock.lockStartBeat;
          threatAtLock = state.persistenceLock.threatAtLock;
          unlockCondition = 0.0;
        };
      };
    };
    
    let threatFloor = applyPersistenceFloor(aegisThreatLevel, newPersistenceLock.isLocked);
    
    // ─── Thermocline ────────────────────────────────────────────────────────
    let targetDepth = determineTargetDepth(energyBalance, state.thermocline.currentDepth);
    depthChanged := targetDepth != state.thermocline.currentDepth;
    
    let depthConfig = getDepthConfiguration(targetDepth);
    let energySaved = state.thermocline.energySaved + depthConfig.energySaveRate;
    
    let newThermocline : ThermoclineState = {
      currentDepth = targetDepth;
      descentBeat = if (depthChanged and targetDepth > state.thermocline.currentDepth) 
                      currentBeat else state.thermocline.descentBeat;
      ascentBeat = if (depthChanged and targetDepth < state.thermocline.currentDepth)
                     currentBeat else state.thermocline.ascentBeat;
      energySaved = energySaved;
    };
    
    // ─── Ancient Core ───────────────────────────────────────────────────────
    let newAncientCore = findAncientCore(coreBeatCounts, state.ancientCore);
    
    // ─── Build updated state ────────────────────────────────────────────────
    updatedState := {
      driftSignatures = Buffer.toArray(newDriftSignatures);
      electroDetections = state.electroDetections + (if (electroDetected) 1 else 0);
      preArmCount = state.preArmCount + (if (aegisPreArmed) 1 else 0);
      driftHistory = newDriftHistory;
      lateralSignals = Buffer.toArray(newLateralSignals);
      totalLateralSignals = state.totalLateralSignals + newLateralSignals.size();
      persistenceLock = newPersistenceLock;
      totalPersistenceBeats = state.totalPersistenceBeats + 
                              (if (newPersistenceLock.isLocked) 1 else 0);
      thermocline = newThermocline;
      ancientCore = newAncientCore;
      aegisActiveBeats = newAegisActiveBeats;
      lastThreatLevel = aegisThreatLevel;
    };
    
    {
      updatedState = updatedState;
      electroDetected = electroDetected;
      aegisPreArmed = aegisPreArmed;
      lateralSignalSent = lateralSignalSent;
      persistenceLocked = newPersistenceLock.isLocked;
      depthChanged = depthChanged;
      threatFloorApplied = threatFloor;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initSharkState() : SharkState {
    {
      driftSignatures = [];
      electroDetections = 0;
      preArmCount = 0;
      driftHistory = [];
      lateralSignals = [];
      totalLateralSignals = 0;
      persistenceLock = {
        isLocked = false;
        lockStartBeat = 0;
        lockDuration = 0;
        threatAtLock = 0.0;
        unlockCondition = 0.0;
      };
      totalPersistenceBeats = 0;
      thermocline = {
        currentDepth = 0;
        descentBeat = 0;
        ascentBeat = 0;
        energySaved = 0.0;
      };
      ancientCore = null;
      aegisActiveBeats = 0;
      lastThreatLevel = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  public type SharkSummary = {
    electroDetections    : Nat;
    preArmCount          : Nat;
    totalLateralSignals  : Nat;
    persistenceLocked    : Bool;
    totalPersistenceBeats: Nat;
    currentDepth         : Nat;
    depthName            : Text;
    energySaved          : Float;
    ancientCoreIndex     : ?Nat;
  };

  public func summarize(state : SharkState) : SharkSummary {
    let depthName = switch (state.thermocline.currentDepth) {
      case 0 "SURFACE";
      case 1 "MID";
      case _ "DEEP";
    };
    
    let ancientIdx = switch (state.ancientCore) {
      case (?a) ?a.coreIndex;
      case null null;
    };
    
    {
      electroDetections = state.electroDetections;
      preArmCount = state.preArmCount;
      totalLateralSignals = state.totalLateralSignals;
      persistenceLocked = state.persistenceLock.isLocked;
      totalPersistenceBeats = state.totalPersistenceBeats;
      currentDepth = state.thermocline.currentDepth;
      depthName = depthName;
      energySaved = state.thermocline.energySaved;
      ancientCoreIndex = ancientIdx;
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

}
