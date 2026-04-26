// PARALLAX DRONE SWARM SIMULATION
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
// Kuramoto synchrony, Hebbian learning, Jasmine's Law, OMNIS emergence
// are Medina Tech sovereign intellectual property.

import Array  "mo:base/Array";
import Int    "mo:base/Int";
import Iter   "mo:base/Iter";
import Nat    "mo:base/Nat";
import Text   "mo:base/Text";
import Time   "mo:base/Time";
import Float  "mo:base/Float";

actor SwarmAudit {

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
    #NOVEL_BEHAVIOR;     // Patent trigger
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
    operator    : Text;     // principal or "SYSTEM"
    metadata    : Text;     // JSON-encoded extra data
  };

  // ─── STABLE STATE ───────────────────────────────────────────────────────────

  stable var nextSeq         : Nat = 0;
  // Immutable append-only log — stored as parallel stable arrays
  stable var seqArr          : [var Nat]   = [var];
  stable var kindArr         : [var Text]  = [var];
  stable var beatArr         : [var Nat]   = [var];
  stable var tsArr           : [var Int]   = [var];
  stable var droneIdArr      : [var Int]   = [var]; // -1 = none
  stable var descArr         : [var Text]  = [var];
  stable var rSwarmArr       : [var Float] = [var];
  stable var jDriftArr       : [var Float] = [var];
  stable var cortArr         : [var Float] = [var];
  stable var operatorArr     : [var Text]  = [var];
  stable var metaArr         : [var Text]  = [var];

  let LOG_CAP = 10_000; // max entries kept in rolling buffer

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  func kindToText(k : EventKind) : Text {
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

  func ensureCap(newSize : Nat) {
    if (seqArr.size() < newSize) {
      let cap = if (newSize < LOG_CAP) newSize else LOG_CAP;
      seqArr      := growNat(seqArr,      cap, 0);
      kindArr     := growText(kindArr,    cap, "");
      beatArr     := growNat(beatArr,     cap, 0);
      tsArr       := growInt(tsArr,       cap, 0);
      droneIdArr  := growInt(droneIdArr,  cap, -1);
      descArr     := growText(descArr,    cap, "");
      rSwarmArr   := growFloat(rSwarmArr, cap, 0.0);
      jDriftArr   := growFloat(jDriftArr, cap, 0.0);
      cortArr     := growFloat(cortArr,   cap, 0.0);
      operatorArr := growText(operatorArr,cap, "");
      metaArr     := growText(metaArr,    cap, "");
    };
  };

  // ─── APPEND LOG ENTRY ────────────────────────────────────────────────────────

  public func log(
    kind        : EventKind,
    beat        : Nat,
    droneId     : ?Nat,
    description : Text,
    rSwarm      : Float,
    jDrift      : Float,
    cortisol    : Float,
    operator    : Text,
    metadata    : Text,
  ) : async Nat {
    ensureCap(nextSeq + 1);
    let idx = nextSeq % LOG_CAP;
    seqArr[idx]      := nextSeq;
    kindArr[idx]     := kindToText(kind);
    beatArr[idx]     := beat;
    tsArr[idx]       := Time.now();
    droneIdArr[idx]  := switch droneId { case null -1; case (?d) d };
    descArr[idx]     := description;
    rSwarmArr[idx]   := rSwarm;
    jDriftArr[idx]   := jDrift;
    cortArr[idx]     := cortisol;
    operatorArr[idx] := operator;
    metaArr[idx]     := metadata;
    let seq = nextSeq;
    nextSeq += 1;
    seq
  };

  // ─── QUERIES ─────────────────────────────────────────────────────────────────

  public query func getEntryCount() : async Nat { nextSeq };

  // Returns last N entries (up to cap)
  public query func getRecentEntries(n : Nat) : async [{
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
    let total = if (nextSeq < LOG_CAP) nextSeq else LOG_CAP;
    let count = if (n < total) n else total;
    var results : [{
      seq : Nat; kind : Text; beat : Nat; timestamp : Int;
      droneId : Int; description : Text; rSwarm : Float;
      jDrift : Float; cortisol : Float; operator : Text; metadata : Text;
    }] = [];
    var i = 0;
    while (i < count) {
      let idx = if (nextSeq >= LOG_CAP) {
        (nextSeq - count + i) % LOG_CAP
      } else {
        nextSeq - count + i
      };
      results := Array.append(results, [{
        seq         = seqArr[idx];
        kind        = kindArr[idx];
        beat        = beatArr[idx];
        timestamp   = tsArr[idx];
        droneId     = droneIdArr[idx];
        description = descArr[idx];
        rSwarm      = rSwarmArr[idx];
        jDrift      = jDriftArr[idx];
        cortisol    = cortArr[idx];
        operator    = operatorArr[idx];
        metadata    = metaArr[idx];
      }]);
      i += 1;
    };
    results
  };

  // Get a specific entry by sequence number
  public query func getEntry(seq : Nat) : async ?{
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
    if (seq >= nextSeq) return null;
    let idx = seq % LOG_CAP;
    ?{
      seq         = seqArr[idx];
      kind        = kindArr[idx];
      beat        = beatArr[idx];
      timestamp   = tsArr[idx];
      droneId     = droneIdArr[idx];
      description = descArr[idx];
      rSwarm      = rSwarmArr[idx];
      jDrift      = jDriftArr[idx];
      cortisol    = cortArr[idx];
      operator    = operatorArr[idx];
      metadata    = metaArr[idx];
    }
  };

};
