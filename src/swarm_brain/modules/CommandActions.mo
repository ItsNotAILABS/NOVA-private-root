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


// NOVA — COMMAND ACTIONS MODULE (Consolidated from swarm_command)
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
//
// CONSOLIDATED: This was previously a separate canister (swarm_command).
// Now a module within swarm_brain for 12 Hz heartbeat temporal coherence.

import Array  "mo:base/Array";
import Float  "mo:base/Float";
import Int    "mo:base/Int";
import Nat    "mo:base/Nat";
import Text   "mo:base/Text";
import Time   "mo:base/Time";

module {

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
    label    : Text;
  };

  public type MissionStatus = {
    #IDLE;
    #ACTIVE;
    #PAUSED;
    #SUCCESS;
    #FAILURE;
    #EMERGENCY_STOP;
  };

  public type MAVLinkCommand = {
    droneId   : Nat;
    command   : Text;
    latitude  : Float;
    longitude : Float;
    altitude  : Float;
    speed     : Float;
  };

  // ─── CONSTANTS ──────────────────────────────────────────────────────────────
  
  let QUEUE_CAP = 256;
  let WP_CAP = 64;
  let COMMS_TIMEOUT_NS : Int = 60_000_000_000;

  // ─── STATE CLASS ────────────────────────────────────────────────────────────

  public class CommandState() {
    // HITL approval queue
    public var nextRequestId     : Nat = 0;
    public var reqIds            : [var Nat]   = [var];
    public var reqDroneIds       : [var Nat]   = [var];
    public var reqActions        : [var Text]  = [var];
    public var reqReasons        : [var Text]  = [var];
    public var reqCortisol       : [var Float] = [var];
    public var reqJDrift         : [var Float] = [var];
    public var reqRSwarm         : [var Float] = [var];
    public var reqBeats          : [var Nat]   = [var];
    public var reqDeadlines      : [var Int]   = [var];
    public var reqStatuses       : [var Text]  = [var];

    // Mission state
    public var missionStatus     : Text    = "IDLE";
    public var missionName       : Text    = "";
    public var missionBeat       : Nat     = 0;
    public var emergencyActive   : Bool    = false;
    public var architectSignal   : Float   = 1.0;

    // Waypoints
    public var waypointX         : [var Float] = [var];
    public var waypointY         : [var Float] = [var];
    public var waypointZ         : [var Float] = [var];
    public var waypointLabel     : [var Text]  = [var];
    public var waypointCount     : Nat = 0;

    // Observer Independence (Law 23)
    public var lastHeartbeat     : Int  = 0;
    public var commsLost         : Bool = false;
  };

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

  func ensureQueueCap(state : CommandState) {
    if (state.reqIds.size() < QUEUE_CAP) {
      state.reqIds       := growNat(state.reqIds,       QUEUE_CAP, 0);
      state.reqDroneIds  := growNat(state.reqDroneIds,  QUEUE_CAP, 0);
      state.reqActions   := growText(state.reqActions,  QUEUE_CAP, "");
      state.reqReasons   := growText(state.reqReasons,  QUEUE_CAP, "");
      state.reqCortisol  := growFloat(state.reqCortisol,QUEUE_CAP, 0.0);
      state.reqJDrift    := growFloat(state.reqJDrift,  QUEUE_CAP, 0.0);
      state.reqRSwarm    := growFloat(state.reqRSwarm,  QUEUE_CAP, 0.0);
      state.reqBeats     := growNat(state.reqBeats,     QUEUE_CAP, 0);
      state.reqDeadlines := growInt(state.reqDeadlines, QUEUE_CAP, 0);
      state.reqStatuses  := growText(state.reqStatuses, QUEUE_CAP, "PENDING");
    };
  };

  func ensureWpCap(state : CommandState) {
    if (state.waypointX.size() < WP_CAP) {
      state.waypointX     := growFloat(state.waypointX,    WP_CAP, 0.0);
      state.waypointY     := growFloat(state.waypointY,    WP_CAP, 0.0);
      state.waypointZ     := growFloat(state.waypointZ,    WP_CAP, 0.0);
      state.waypointLabel := growText(state.waypointLabel, WP_CAP, "");
    };
  };

  func expirePending(state : CommandState) {
    let now = Time.now();
    var i = 0;
    while (i < state.nextRequestId and i < QUEUE_CAP) {
      if (state.reqStatuses[i] == "PENDING" and state.reqDeadlines[i] < now) {
        state.reqStatuses[i] := "EXPIRED";
      };
      i += 1;
    };
  };

  // ─── MISSION CONTROL — SYNC (no async!) ─────────────────────────────────────

  public func startMission(state : CommandState, name : Text) : Bool {
    if (state.emergencyActive) return false;
    state.missionStatus := "ACTIVE";
    state.missionName   := name;
    state.missionBeat   := 0;
    state.lastHeartbeat := Time.now();
    state.commsLost     := false;
    true
  };

  public func pauseMission(state : CommandState) {
    if (state.missionStatus == "ACTIVE") state.missionStatus := "PAUSED";
  };

  public func completeMission(state : CommandState, success : Bool) {
    state.missionStatus := if success "SUCCESS" else "FAILURE";
  };

  public func emergencyStop(state : CommandState) {
    state.emergencyActive := true;
    state.missionStatus   := "EMERGENCY_STOP";
  };

  public func resetEmergency(state : CommandState) {
    state.emergencyActive := false;
    state.missionStatus   := "IDLE";
  };

  public func heartbeat(state : CommandState) {
    state.lastHeartbeat := Time.now();
    state.commsLost     := false;
  };

  public func checkComms(state : CommandState) : Bool {
    let elapsed = Time.now() - state.lastHeartbeat;
    if (elapsed > COMMS_TIMEOUT_NS) {
      state.commsLost := true;
    };
    not state.commsLost
  };

  // ─── WAYPOINTS ───────────────────────────────────────────────────────────────

  public func addWaypoint(state : CommandState, x : Float, y : Float, z : Float, label : Text) : Nat {
    ensureWpCap(state);
    if (state.waypointCount >= WP_CAP) return 0;
    let idx = state.waypointCount;
    state.waypointX[idx]     := x;
    state.waypointY[idx]     := y;
    state.waypointZ[idx]     := z;
    state.waypointLabel[idx] := label;
    state.waypointCount += 1;
    idx
  };

  public func getWaypoints(state : CommandState) : [{x:Float; y:Float; z:Float; label:Text}] {
    Array.tabulate<{x:Float; y:Float; z:Float; label:Text}>(state.waypointCount, func(i) {
      { x = state.waypointX[i]; y = state.waypointY[i]; z = state.waypointZ[i]; label = state.waypointLabel[i] }
    })
  };

  // ─── HITL APPROVAL GATE ──────────────────────────────────────────────────────

  public func queueAction(
    state    : CommandState,
    droneId  : Nat,
    action   : Text,
    reason   : Text,
    cortisol : Float,
    jDrift   : Float,
    rSwarm   : Float,
    beat     : Nat,
  ) : Nat {
    ensureQueueCap(state);
    expirePending(state);
    let id  = state.nextRequestId % QUEUE_CAP;
    let now = Time.now();
    state.reqIds[id]       := state.nextRequestId;
    state.reqDroneIds[id]  := droneId;
    state.reqActions[id]   := action;
    state.reqReasons[id]   := reason;
    state.reqCortisol[id]  := cortisol;
    state.reqJDrift[id]    := jDrift;
    state.reqRSwarm[id]    := rSwarm;
    state.reqBeats[id]     := beat;
    state.reqDeadlines[id] := now + approvalWindowNs(action);
    state.reqStatuses[id]  := "PENDING";
    let reqId = state.nextRequestId;
    state.nextRequestId += 1;
    reqId
  };

  public func approve(state : CommandState, reqId : Nat) : Bool {
    expirePending(state);
    let idx = reqId % QUEUE_CAP;
    if (state.reqIds[idx] != reqId) return false;
    if (state.reqStatuses[idx] != "PENDING") return false;
    if (state.emergencyActive) return false;
    state.reqStatuses[idx] := "APPROVED";
    true
  };

  public func deny(state : CommandState, reqId : Nat) : Bool {
    expirePending(state);
    let idx = reqId % QUEUE_CAP;
    if (state.reqIds[idx] != reqId) return false;
    if (state.reqStatuses[idx] != "PENDING") return false;
    state.reqStatuses[idx] := "DENIED";
    true
  };

  public func getRequestStatus(state : CommandState, reqId : Nat) : Text {
    let now = Time.now();
    let idx = reqId % QUEUE_CAP;
    if (state.reqIds[idx] != reqId) return "NOT_FOUND";
    if (state.reqStatuses[idx] == "PENDING" and state.reqDeadlines[idx] < now) return "EXPIRED";
    state.reqStatuses[idx]
  };

  public func getPendingRequests(state : CommandState) : [ApprovalRequest] {
    var results : [ApprovalRequest] = [];
    let now = Time.now();
    var i = 0;
    let total = if (state.nextRequestId < QUEUE_CAP) state.nextRequestId else QUEUE_CAP;
    while (i < total) {
      let status = if (state.reqStatuses[i] == "PENDING" and state.reqDeadlines[i] < now) "EXPIRED"
                   else state.reqStatuses[i];
      if (status == "PENDING") {
        let statusVariant : ApprovalStatus = #PENDING;
        results := Array.append(results, [{
          id       = state.reqIds[i];
          droneId  = state.reqDroneIds[i];
          action   = state.reqActions[i];
          reason   = state.reqReasons[i];
          cortisol = state.reqCortisol[i];
          jDrift   = state.reqJDrift[i];
          rSwarm   = state.reqRSwarm[i];
          beat     = state.reqBeats[i];
          deadline = state.reqDeadlines[i];
          status   = statusVariant;
        }]);
      };
      i += 1;
    };
    results
  };

  public func getAllRequests(state : CommandState) : [{
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
    let total = if (state.nextRequestId < QUEUE_CAP) state.nextRequestId else QUEUE_CAP;
    Array.tabulate(total, func(i : Nat) {
      {
        id       = state.reqIds[i];
        droneId  = state.reqDroneIds[i];
        action   = state.reqActions[i];
        reason   = state.reqReasons[i];
        cortisol = state.reqCortisol[i];
        jDrift   = state.reqJDrift[i];
        rSwarm   = state.reqRSwarm[i];
        beat     = state.reqBeats[i];
        deadline = state.reqDeadlines[i];
        status   = state.reqStatuses[i];
      }
    })
  };

  // ─── ARCHITECT SIGNAL ────────────────────────────────────────────────────────

  public func setArchitectSignal(state : CommandState, level : Float) {
    state.architectSignal := Float.max(0.0, Float.min(2.0, level));
  };

  public func getArchitectSignal(state : CommandState) : Float { state.architectSignal };

  // ─── STATUS QUERIES ──────────────────────────────────────────────────────────

  public func getMissionStatus(state : CommandState)   : Text { state.missionStatus };
  public func getMissionName(state : CommandState)     : Text { state.missionName };
  public func isEmergencyActive(state : CommandState)  : Bool { state.emergencyActive };
  public func isCommsLost(state : CommandState)        : Bool { state.commsLost };

  public func getCommandSnapshot(state : CommandState) : {
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
    let total = if (state.nextRequestId < QUEUE_CAP) state.nextRequestId else QUEUE_CAP;
    while (i < total) {
      if (state.reqStatuses[i] == "PENDING" and state.reqDeadlines[i] >= now) {
        pending += 1;
      };
      i += 1;
    };
    {
      missionStatus   = state.missionStatus;
      missionName     = state.missionName;
      emergencyActive = state.emergencyActive;
      commsLost       = state.commsLost;
      architectSignal = state.architectSignal;
      pendingCount    = pending;
    }
  };

  // ─── MAVLINK BRIDGE STUB ─────────────────────────────────────────────────────

  public func sendMAVLink(cmd : MAVLinkCommand) : Bool {
    // Stub — in production replace with HTTP outcall
    true
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
