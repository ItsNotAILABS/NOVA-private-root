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


// NOVA — AUDIT LOG MODULE (Consolidated from swarm_audit)
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
//
// CONSOLIDATED: This was previously a separate canister (swarm_audit).
// Now a module within swarm_brain for 12 Hz heartbeat temporal coherence.

import Array  "mo:base/Array";
import Int    "mo:base/Int";
import Iter   "mo:base/Iter";
import Nat    "mo:base/Nat";
import Text   "mo:base/Text";
import Time   "mo:base/Time";
import Float  "mo:base/Float";

module {

  // ─── TYPES ──────────────────────────────────────────────────────────────────

  public type EventKind = {
    #DRONE_ADDED;
    #DRONE_SACRIFICED;
    #FORMATION_CHANGE;
    #HITL_APPROVED;
    #HITL_DENIED;
    #HITL_EXPIRED;
    #MISSION_START;
    #MISSION_SUCCESS;
    #MISSION_FAILURE;
    #SWARM_DISSOLVED;
    #OMNIS_STATE;
    #NOVEL_BEHAVIOR;
    #EMERGENCY_STOP;
    #ZONE_ENTRY;
    #TARGET_ENGAGE;
  };

  public type AuditEntry = {
    seq         : Nat;
    kind        : EventKind;
    beat        : Nat;
    timestamp   : Int;
    droneId     : ?Nat;
    description : Text;
    rSwarm      : Float;
    jDrift      : Float;
    cortisol    : Float;
    operator    : Text;
    metadata    : Text;
  };

  // ─── CONSTANTS ──────────────────────────────────────────────────────────────
  
  let LOG_CAP = 10_000;

  // ─── STATE CLASS ────────────────────────────────────────────────────────────

  public class AuditState() {
    public var nextSeq         : Nat = 0;
    public var seqArr          : [var Nat]   = [var];
    public var kindArr         : [var Text]  = [var];
    public var beatArr         : [var Nat]   = [var];
    public var tsArr           : [var Int]   = [var];
    public var droneIdArr      : [var Int]   = [var];
    public var descArr         : [var Text]  = [var];
    public var rSwarmArr       : [var Float] = [var];
    public var jDriftArr       : [var Float] = [var];
    public var cortArr         : [var Float] = [var];
    public var operatorArr     : [var Text]  = [var];
    public var metaArr         : [var Text]  = [var];
  };

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  public func kindToText(k : EventKind) : Text {
    switch k {
      case (#DRONE_ADDED)      "DRONE_ADDED";
      case (#DRONE_SACRIFICED) "DRONE_SACRIFICED";
      case (#FORMATION_CHANGE) "FORMATION_CHANGE";
      case (#HITL_APPROVED)    "HITL_APPROVED";
      case (#HITL_DENIED)      "HITL_DENIED";
      case (#HITL_EXPIRED)     "HITL_EXPIRED";
      case (#MISSION_START)    "MISSION_START";
      case (#MISSION_SUCCESS)  "MISSION_SUCCESS";
      case (#MISSION_FAILURE)  "MISSION_FAILURE";
      case (#SWARM_DISSOLVED)  "SWARM_DISSOLVED";
      case (#OMNIS_STATE)      "OMNIS_STATE";
      case (#NOVEL_BEHAVIOR)   "NOVEL_BEHAVIOR";
      case (#EMERGENCY_STOP)   "EMERGENCY_STOP";
      case (#ZONE_ENTRY)       "ZONE_ENTRY";
      case (#TARGET_ENGAGE)    "TARGET_ENGAGE";
    }
  };

  func growNat(old : [var Nat], cap : Nat, def : Nat) : [var Nat] {
    let n = Array.init<Nat>(cap, def);
    var i = 0;
    while (i < old.size() and i < cap) { n[i] := old[i]; i += 1 };
    n
  };
  func growInt(old : [var Int], cap : Nat, def : Int) : [var Int] {
    let n = Array.init<Int>(cap, def);
    var i = 0;
    while (i < old.size() and i < cap) { n[i] := old[i]; i += 1 };
    n
  };
  func growText(old : [var Text], cap : Nat, def : Text) : [var Text] {
    let n = Array.init<Text>(cap, def);
    var i = 0;
    while (i < old.size() and i < cap) { n[i] := old[i]; i += 1 };
    n
  };
  func growFloat(old : [var Float], cap : Nat, def : Float) : [var Float] {
    let n = Array.init<Float>(cap, def);
    var i = 0;
    while (i < old.size() and i < cap) { n[i] := old[i]; i += 1 };
    n
  };

  func ensureCap(state : AuditState, newSize : Nat) {
    if (state.seqArr.size() < newSize) {
      let cap = if (newSize < LOG_CAP) newSize else LOG_CAP;
      state.seqArr      := growNat(state.seqArr,      cap, 0);
      state.kindArr     := growText(state.kindArr,    cap, "");
      state.beatArr     := growNat(state.beatArr,     cap, 0);
      state.tsArr       := growInt(state.tsArr,       cap, 0);
      state.droneIdArr  := growInt(state.droneIdArr,  cap, -1);
      state.descArr     := growText(state.descArr,    cap, "");
      state.rSwarmArr   := growFloat(state.rSwarmArr, cap, 0.0);
      state.jDriftArr   := growFloat(state.jDriftArr, cap, 0.0);
      state.cortArr     := growFloat(state.cortArr,   cap, 0.0);
      state.operatorArr := growText(state.operatorArr,cap, "");
      state.metaArr     := growText(state.metaArr,    cap, "");
    };
  };

  // ─── APPEND LOG ENTRY — SYNC (no async!) ────────────────────────────────────

  public func log(
    state       : AuditState,
    kind        : EventKind,
    beat        : Nat,
    droneId     : ?Nat,
    description : Text,
    rSwarm      : Float,
    jDrift      : Float,
    cortisol    : Float,
    operator    : Text,
    metadata    : Text,
  ) : Nat {
    ensureCap(state, state.nextSeq + 1);
    let idx = state.nextSeq % LOG_CAP;
    state.seqArr[idx]      := state.nextSeq;
    state.kindArr[idx]     := kindToText(kind);
    state.beatArr[idx]     := beat;
    state.tsArr[idx]       := Time.now();
    state.droneIdArr[idx]  := switch droneId { case null -1; case (?d) Int.fromNat(d) };
    state.descArr[idx]     := description;
    state.rSwarmArr[idx]   := rSwarm;
    state.jDriftArr[idx]   := jDrift;
    state.cortArr[idx]     := cortisol;
    state.operatorArr[idx] := operator;
    state.metaArr[idx]     := metadata;
    let seq = state.nextSeq;
    state.nextSeq += 1;
    seq
  };

  // ─── QUERIES ─────────────────────────────────────────────────────────────────

  public func getEntryCount(state : AuditState) : Nat { state.nextSeq };

  public func getRecentEntries(state : AuditState, n : Nat) : [{
    seq         : Nat;
    kind        : Text;
    beat        : Nat;
    timestamp   : Int;
    droneId     : Int;
    description : Text;
    rSwarm      : Float;
    jDrift      : Float;
    cortisol    : Float;
    operator    : Text;
    metadata    : Text;
  }] {
    let total = if (state.nextSeq < LOG_CAP) state.nextSeq else LOG_CAP;
    let count = if (n < total) n else total;
    var results : [{
      seq : Nat; kind : Text; beat : Nat; timestamp : Int;
      droneId : Int; description : Text; rSwarm : Float;
      jDrift : Float; cortisol : Float; operator : Text; metadata : Text;
    }] = [];
    var i = 0;
    while (i < count) {
      let idx = if (state.nextSeq >= LOG_CAP) {
        (state.nextSeq - count + i) % LOG_CAP
      } else {
        state.nextSeq - count + i
      };
      results := Array.append(results, [{
        seq         = state.seqArr[idx];
        kind        = state.kindArr[idx];
        beat        = state.beatArr[idx];
        timestamp   = state.tsArr[idx];
        droneId     = state.droneIdArr[idx];
        description = state.descArr[idx];
        rSwarm      = state.rSwarmArr[idx];
        jDrift      = state.jDriftArr[idx];
        cortisol    = state.cortArr[idx];
        operator    = state.operatorArr[idx];
        metadata    = state.metaArr[idx];
      }]);
      i += 1;
    };
    results
  };

  public func getEntry(state : AuditState, seq : Nat) : ?{
    seq         : Nat;
    kind        : Text;
    beat        : Nat;
    timestamp   : Int;
    droneId     : Int;
    description : Text;
    rSwarm      : Float;
    jDrift      : Float;
    cortisol    : Float;
    operator    : Text;
    metadata    : Text;
  } {
    if (seq >= state.nextSeq) return null;
    let idx = seq % LOG_CAP;
    ?{
      seq         = state.seqArr[idx];
      kind        = state.kindArr[idx];
      beat        = state.beatArr[idx];
      timestamp   = state.tsArr[idx];
      droneId     = state.droneIdArr[idx];
      description = state.descArr[idx];
      rSwarm      = state.rSwarmArr[idx];
      jDrift      = state.jDriftArr[idx];
      cortisol    = state.cortArr[idx];
      operator    = state.operatorArr[idx];
      metadata    = state.metaArr[idx];
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
