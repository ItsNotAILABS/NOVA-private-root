// PARALLAX DRONE SWARM SIMULATION
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
// Kuramoto synchrony, Hebbian learning, Jasmine's Law, OMNIS emergence
// are Medina Tech sovereign intellectual property.

import Array  "mo:base/Array";
import Float  "mo:base/Float";
import Int    "mo:base/Int";
import Nat    "mo:base/Nat";
import Text   "mo:base/Text";
import Time   "mo:base/Time";

actor SwarmCommand {

  // ─── TYPES ──────────────────────────────────────────────────────────────────

  public type ActionKind = {
    #SACRIFICE;
    #ENGAGE;
    #DISSOLVE;
    #ENTER_ZONE;
    #FORMATION_CHANGE;
  };

  public type ApprovalStatus = {
    #PENDING;
    #APPROVED;
    #DENIED;
    #EXPIRED;
  };

  public type ApprovalRequest = {
    id       : Nat;
    droneId  : Nat;
    action   : Text;
    reason   : Text;
    cortisol : Float;
    jDrift   : Float;
    rSwarm   : Float;
    beat     : Nat;
    deadline : Int;
    status   : ApprovalStatus;
  };

  public type Waypoint = {
    x        : Float;
    y        : Float;
    z        : Float;
    lbl    : Text;
  };

  public type MissionStatus = {
    #IDLE;
    #ACTIVE;
    #PAUSED;
    #SUCCESS;
    #FAILURE;
    #EMERGENCY_STOP;
  };

  // ─── STABLE STATE ───────────────────────────────────────────────────────────

  // HITL approval queue — survives upgrades
  stable var nextRequestId     : Nat = 0;
  stable var reqIds            : [var Nat]   = [var];
  stable var reqDroneIds       : [var Nat]   = [var];
  stable var reqActions        : [var Text]  = [var];
  stable var reqReasons        : [var Text]  = [var];
  stable var reqCortisol       : [var Float] = [var];
  stable var reqJDrift         : [var Float] = [var];
  stable var reqRSwarm         : [var Float] = [var];
  stable var reqBeats          : [var Nat]   = [var];
  stable var reqDeadlines      : [var Int]   = [var];
  stable var reqStatuses       : [var Text]  = [var];

  let QUEUE_CAP = 256;

  // Mission state
  stable var missionStatus     : Text    = "IDLE";
  stable var missionName       : Text    = "";
  stable var missionBeat       : Nat     = 0;
  stable var emergencyActive   : Bool    = false;
  stable var architectSignal   : Float   = 1.0;

  // Waypoints
  stable var waypointX         : [var Float] = [var];
  stable var waypointY         : [var Float] = [var];
  stable var waypointZ         : [var Float] = [var];
  stable var waypointLabel     : [var Text]  = [var];
  stable var waypointCount     : Nat = 0;
  let WP_CAP = 64;

  // Observer Independence (Law 23) — mission continues if comms lost
  stable var lastHeartbeat     : Int  = 0;
  stable var commsLost         : Bool = false;
  let COMMS_TIMEOUT_NS : Int = 60_000_000_000; // 60 seconds in nanoseconds

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  func statusToText(s : ApprovalStatus) : Text {
    switch s {
      case (#PENDING)  "PENDING";
      case (#APPROVED) "APPROVED";
      case (#DENIED)   "DENIED";
      case (#EXPIRED)  "EXPIRED";
    }
  };

  func approvalWindowNs(action : Text) : Int {
    switch action {
      case "SACRIFICE"         30_000_000_000;
      case "ENGAGE"            60_000_000_000;
      case "DISSOLVE"          15_000_000_000;
      case "ENTER_ZONE"        20_000_000_000;
      case "FORMATION_CHANGE"  10_000_000_000;
      case _                   30_000_000_000;
    }
  };

  func growNat(old : [var Nat], cap : Nat, def : Nat) : [var Nat] {
    let n = Array.init<Nat>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { n[i] := old[i]; i += 1 }; n
  };
  func growInt(old : [var Int], cap : Nat, def : Int) : [var Int] {
    let n = Array.init<Int>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { n[i] := old[i]; i += 1 }; n
  };
  func growText(old : [var Text], cap : Nat, def : Text) : [var Text] {
    let n = Array.init<Text>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { n[i] := old[i]; i += 1 }; n
  };
  func growFloat(old : [var Float], cap : Nat, def : Float) : [var Float] {
    let n = Array.init<Float>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { n[i] := old[i]; i += 1 }; n
  };

  func ensureQueueCap() {
    if (reqIds.size() < QUEUE_CAP) {
      reqIds       := growNat(reqIds,       QUEUE_CAP, 0);
      reqDroneIds  := growNat(reqDroneIds,  QUEUE_CAP, 0);
      reqActions   := growText(reqActions,  QUEUE_CAP, "");
      reqReasons   := growText(reqReasons,  QUEUE_CAP, "");
      reqCortisol  := growFloat(reqCortisol,QUEUE_CAP, 0.0);
      reqJDrift    := growFloat(reqJDrift,  QUEUE_CAP, 0.0);
      reqRSwarm    := growFloat(reqRSwarm,  QUEUE_CAP, 0.0);
      reqBeats     := growNat(reqBeats,     QUEUE_CAP, 0);
      reqDeadlines := growInt(reqDeadlines, QUEUE_CAP, 0);
      reqStatuses  := growText(reqStatuses, QUEUE_CAP, "PENDING");
    };
  };

  func ensureWpCap() {
    if (waypointX.size() < WP_CAP) {
      waypointX     := growFloat(waypointX,    WP_CAP, 0.0);
      waypointY     := growFloat(waypointY,    WP_CAP, 0.0);
      waypointZ     := growFloat(waypointZ,    WP_CAP, 0.0);
      waypointLabel := growText(waypointLabel, WP_CAP, "");
    };
  };

  // Expire pending requests past their deadline
  func expirePending() {
    let now = Time.now();
    var i = 0;
    while (i < nextRequestId and i < QUEUE_CAP) {
      if (reqStatuses[i] == "PENDING" and reqDeadlines[i] < now) {
        reqStatuses[i] := "EXPIRED";
      };
      i += 1;
    };
  };

  // ─── MISSION CONTROL ─────────────────────────────────────────────────────────

  public func startMission(name : Text) : async Bool {
    if (emergencyActive) return false;
    missionStatus := "ACTIVE";
    missionName   := name;
    missionBeat   := 0;
    lastHeartbeat := Time.now();
    commsLost     := false;
    true
  };

  public func pauseMission() : async () {
    if (missionStatus == "ACTIVE") missionStatus := "PAUSED";
  };

  public func completeMission(success : Bool) : async () {
    missionStatus := if success "SUCCESS" else "FAILURE";
  };

  public func emergencyStop() : async () {
    emergencyActive := true;
    missionStatus   := "EMERGENCY_STOP";
  };

  public func resetEmergency() : async () {
    emergencyActive := false;
    missionStatus   := "IDLE";
  };

  // Heartbeat — operator pings to keep comms alive
  public func heartbeat() : async () {
    lastHeartbeat := Time.now();
    commsLost     := false;
  };

  // Check comms status (Law 23: Observer Independence)
  public func checkComms() : async Bool {
    let elapsed = Time.now() - lastHeartbeat;
    if (elapsed > COMMS_TIMEOUT_NS) {
      commsLost := true;
    };
    not commsLost
  };

  // ─── WAYPOINTS ───────────────────────────────────────────────────────────────

  public func addWaypoint(x : Float, y : Float, z : Float, lbl : Text) : async Nat {
    ensureWpCap();
    if (waypointCount >= WP_CAP) return 0;
    let idx = waypointCount;
    waypointX[idx]     := x;
    waypointY[idx]     := y;
    waypointZ[idx]     := z;
    waypointLabel[idx] := lbl;
    waypointCount += 1;
    idx
  };

  public query func getWaypoints() : async [{x:Float; y:Float; z:Float; lbl:Text}] {
    Array.tabulate<{x:Float; y:Float; z:Float; lbl:Text}>(waypointCount, func(i) {
      { x = waypointX[i]; y = waypointY[i]; z = waypointZ[i]; lbl = waypointLabel[i] }
    })
  };

  // ─── HITL APPROVAL GATE ──────────────────────────────────────────────────────

  public func queueAction(
    droneId  : Nat,
    action   : Text,
    reason   : Text,
    cortisol : Float,
    jDrift   : Float,
    rSwarm   : Float,
    beat     : Nat,) : async Nat {
    ensureQueueCap();
    expirePending();
    let id  = nextRequestId % QUEUE_CAP;
    let now = Time.now();
    reqIds[id]       := nextRequestId;
    reqDroneIds[id]  := droneId;
    reqActions[id]   := action;
    reqReasons[id]   := reason;
    reqCortisol[id]  := cortisol;
    reqJDrift[id]    := jDrift;
    reqRSwarm[id]    := rSwarm;
    reqBeats[id]     := beat;
    reqDeadlines[id] := now + approvalWindowNs(action);
    reqStatuses[id]  := "PENDING";
    let reqId = nextRequestId;
    nextRequestId += 1;
    reqId
  };

  // Human operator: approve an action
  public func approve(reqId : Nat) : async Bool {
    expirePending();
    let idx = reqId % QUEUE_CAP;
    if (reqIds[idx] != reqId) return false;
    if (reqStatuses[idx] != "PENDING") return false;
    if (emergencyActive) return false;
    reqStatuses[idx] := "APPROVED";
    true
  };

  // Human operator: deny an action
  public func deny(reqId : Nat) : async Bool {
    expirePending();
    let idx = reqId % QUEUE_CAP;
    if (reqIds[idx] != reqId) return false;
    if (reqStatuses[idx] != "PENDING") return false;
    reqStatuses[idx] := "DENIED";
    true
  };

  // Query the current status of a request
  public query func getRequestStatus(reqId : Nat) : async Text {
    let now = Time.now();
    let idx = reqId % QUEUE_CAP;
    if (reqIds[idx] != reqId) return "NOT_FOUND";
    if (reqStatuses[idx] == "PENDING" and reqDeadlines[idx] < now) return "EXPIRED";
    reqStatuses[idx]
  };

  // Get all pending requests (for frontend display)
  public query func getPendingRequests() : async [ApprovalRequest] {
    var results : [ApprovalRequest] = [];
    let now = Time.now();
    var i = 0;
    let total = if (nextRequestId < QUEUE_CAP) nextRequestId else QUEUE_CAP;
    while (i < total) {
      let status = if (reqStatuses[i] == "PENDING" and reqDeadlines[i] < now) "EXPIRED"
                   else reqStatuses[i];
      if (status == "PENDING") {
        let statusVariant : ApprovalStatus = #PENDING;
        results := Array.append(results, [{
          id       = reqIds[i];
          droneId  = reqDroneIds[i];
          action   = reqActions[i];
          reason   = reqReasons[i];
          cortisol = reqCortisol[i];
          jDrift   = reqJDrift[i];
          rSwarm   = reqRSwarm[i];
          beat     = reqBeats[i];
          deadline = reqDeadlines[i];
          status   = statusVariant;
        }]);
      };
      i += 1;
    };
    results
  };

  // Get all requests (for audit/frontend history)
  public query func getAllRequests() : async [{
    id       : Nat;
    droneId  : Nat;
    action   : Text;
    reason   : Text;
    cortisol : Float;
    jDrift   : Float;
    rSwarm   : Float;
    beat     : Nat;
    deadline : Int;
    status   : Text;
  }] {
    let total = if (nextRequestId < QUEUE_CAP) nextRequestId else QUEUE_CAP;
    Array.tabulate<{ id:Nat; droneId:Nat; action:Text; reason:Text; cortisol:Float; jDrift:Float; rSwarm:Float; beat:Nat; deadline:Int; status:Text }>(total, func(i : Nat) {
      {
        id       = reqIds[i];
        droneId  = reqDroneIds[i];
        action   = reqActions[i];
        reason   = reqReasons[i];
        cortisol = reqCortisol[i];
        jDrift   = reqJDrift[i];
        rSwarm   = reqRSwarm[i];
        beat     = reqBeats[i];
        deadline = reqDeadlines[i];
        status   = reqStatuses[i];
      }
    })
  };

  // ─── ARCHITECT SIGNAL ────────────────────────────────────────────────────────

  public func setArchitectSignal(level : Float) : async () {
    architectSignal := Float.max(0.0, Float.min(2.0, level));
  };

  public query func getArchitectSignal() : async Float { architectSignal };

  // ─── STATUS QUERIES ──────────────────────────────────────────────────────────

  public query func getMissionStatus() : async Text { missionStatus };
  public query func getMissionName()   : async Text { missionName };
  public query func isEmergencyActive() : async Bool { emergencyActive };
  public query func isCommsLost()       : async Bool { commsLost };

  public query func getCommandSnapshot() : async {
    missionStatus   : Text;
    missionName     : Text;
    emergencyActive : Bool;
    commsLost       : Bool;
    architectSignal : Float;
    pendingCount    : Nat;
  } {
    var pending = 0;
    let now = Time.now();
    var i = 0;
    let total = if (nextRequestId < QUEUE_CAP) nextRequestId else QUEUE_CAP;
    while (i < total) {
      if (reqStatuses[i] == "PENDING" and reqDeadlines[i] >= now) {
        pending += 1;
      };
      i += 1;
    };
    {
      missionStatus   = missionStatus;
      missionName     = missionName;
      emergencyActive = emergencyActive;
      commsLost       = commsLost;
      architectSignal = architectSignal;
      pendingCount    = pending;
    }
  };

  // ─── MAVLINK BRIDGE STUB ─────────────────────────────────────────────────────

  public type MAVLinkCommand = {
    droneId   : Nat;
    command   : Text;
    latitude  : Float;
    longitude : Float;
    altitude  : Float;
    speed     : Float;
  };

  // In simulation: log and return true.
  // In production: HTTP outcall to ground station via ICP HTTP outcalls.
  public func sendMAVLink(cmd : MAVLinkCommand) : async Bool {
    // Stub — in production replace with:
    // let response = await ic.http_request({...}) pointing to ground station
    true
  };

};
