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

}
