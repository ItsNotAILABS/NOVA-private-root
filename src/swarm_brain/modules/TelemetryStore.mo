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


// NOVA — TELEMETRY STORE MODULE (Consolidated from swarm_telemetry)
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
//
// CONSOLIDATED: This was previously a separate canister (swarm_telemetry).
// Now a module within swarm_brain for 12 Hz heartbeat temporal coherence.

import Array  "mo:base/Array";
import Float  "mo:base/Float";
import Int    "mo:base/Int";
import Nat    "mo:base/Nat";
import Text   "mo:base/Text";
import Time   "mo:base/Time";

module {

  // ─── TYPES ──────────────────────────────────────────────────────────────────

  public type DroneTelemetry = {
    droneId      : Nat;
    droneClass   : Text;
    posX         : Float;
    posY         : Float;
    posZ         : Float;
    velX         : Float;
    velY         : Float;
    velZ         : Float;
    heading      : Float;
    altitude     : Float;
    batteryPct   : Float;
    signalStrength : Float;
    cortisol     : Float;
    dopamine     : Float;
    norepinephrine : Float;
    oxytocin     : Float;
    phase        : Float;
    activation   : Float;
    sacrificed   : Bool;
    beat         : Nat;
    timestamp    : Int;
  };

  public type EpisodicEvent = {
    seq        : Nat;
    beat       : Nat;
    timestamp  : Int;
    kind       : Text;
    droneId    : Nat;
    rSwarm     : Float;
    jDrift     : Float;
    description: Text;
    sensorData : Text;
  };

  public type FormationPattern = {
    id          : Nat;
    beat        : Nat;
    rSwarm      : Float;
    name        : Text;
    droneCount  : Nat;
    posSnapshot : Text;
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

  let MAX_DRONES         : Nat = 50;
  let EPISODIC_CAP       : Nat = 1000;
  let PATTERN_CAP        : Nat = 10;

  // ─── STATE CLASS ────────────────────────────────────────────────────────────

  public class TelemetryState() {
    // Per-drone telemetry
    public var telPosX           : [var Float] = [var];
    public var telPosY           : [var Float] = [var];
    public var telPosZ           : [var Float] = [var];
    public var telVelX           : [var Float] = [var];
    public var telVelY           : [var Float] = [var];
    public var telVelZ           : [var Float] = [var];
    public var telHeading        : [var Float] = [var];
    public var telAltitude       : [var Float] = [var];
    public var telBattery        : [var Float] = [var];
    public var telSignal         : [var Float] = [var];
    public var telCortisol       : [var Float] = [var];
    public var telDopamine       : [var Float] = [var];
    public var telNorepi         : [var Float] = [var];
    public var telOxytocin       : [var Float] = [var];
    public var telPhase          : [var Float] = [var];
    public var telActivation     : [var Float] = [var];
    public var telSacrificed     : [var Bool]  = [var];
    public var telClass          : [var Text]  = [var];
    public var telBeat           : [var Nat]   = [var];
    public var telTimestamp      : [var Int]   = [var];
    public var droneCount        : Nat = 0;

    // Episodic memory
    public var episodicSeq       : [var Nat]   = [var];
    public var episodicBeat      : [var Nat]   = [var];
    public var episodicTs        : [var Int]   = [var];
    public var episodicKind      : [var Text]  = [var];
    public var episodicDroneId   : [var Nat]   = [var];
    public var episodicRSwarm    : [var Float] = [var];
    public var episodicJDrift    : [var Float] = [var];
    public var episodicDesc      : [var Text]  = [var];
    public var episodicSensor    : [var Text]  = [var];
    public var episodicNextIdx   : Nat = 0;
    public var episodicTotal     : Nat = 0;

    // Formation pattern library
    public var patternId         : [var Nat]   = [var];
    public var patternBeat       : [var Nat]   = [var];
    public var patternRSwarm     : [var Float] = [var];
    public var patternName       : [var Text]  = [var];
    public var patternCount      : [var Nat]   = [var];
    public var patternPos        : [var Text]  = [var];
    public var patternLibSize    : Nat = 0;
    public var nextPatternId     : Nat = 0;
  };

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  func growNat(old : [var Nat], cap : Nat, def : Nat) : [var Nat] {
    let a = Array.init<Nat>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };
  func growInt(old : [var Int], cap : Nat, def : Int) : [var Int] {
    let a = Array.init<Int>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };
  func growText(old : [var Text], cap : Nat, def : Text) : [var Text] {
    let a = Array.init<Text>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };
  func growFloat(old : [var Float], cap : Nat, def : Float) : [var Float] {
    let a = Array.init<Float>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };
  func growBool(old : [var Bool], cap : Nat, def : Bool) : [var Bool] {
    let a = Array.init<Bool>(cap, def); var i = 0;
    while (i < old.size() and i < cap) { a[i] := old[i]; i += 1 }; a
  };

  func ensureDroneCap(state : TelemetryState, n : Nat) {
    if (state.telPosX.size() < n) {
      state.telPosX       := growFloat(state.telPosX,       n, 0.0);
      state.telPosY       := growFloat(state.telPosY,       n, 0.0);
      state.telPosZ       := growFloat(state.telPosZ,       n, 0.0);
      state.telVelX       := growFloat(state.telVelX,       n, 0.0);
      state.telVelY       := growFloat(state.telVelY,       n, 0.0);
      state.telVelZ       := growFloat(state.telVelZ,       n, 0.0);
      state.telHeading    := growFloat(state.telHeading,    n, 0.0);
      state.telAltitude   := growFloat(state.telAltitude,   n, 0.0);
      state.telBattery    := growFloat(state.telBattery,    n, 100.0);
      state.telSignal     := growFloat(state.telSignal,     n, 1.0);
      state.telCortisol   := growFloat(state.telCortisol,   n, 1.0);
      state.telDopamine   := growFloat(state.telDopamine,   n, 1.0);
      state.telNorepi     := growFloat(state.telNorepi,     n, 1.0);
      state.telOxytocin   := growFloat(state.telOxytocin,   n, 1.0);
      state.telPhase      := growFloat(state.telPhase,      n, 0.0);
      state.telActivation := growFloat(state.telActivation, n, 1.0);
      state.telSacrificed := growBool(state.telSacrificed,  n, false);
      state.telClass      := growText(state.telClass,       n, "SCOUT");
      state.telBeat       := growNat(state.telBeat,         n, 0);
      state.telTimestamp  := growInt(state.telTimestamp,    n, 0);
    };
  };

  func ensureEpisodicCap(state : TelemetryState) {
    if (state.episodicSeq.size() < EPISODIC_CAP) {
      state.episodicSeq     := growNat(state.episodicSeq,     EPISODIC_CAP, 0);
      state.episodicBeat    := growNat(state.episodicBeat,    EPISODIC_CAP, 0);
      state.episodicTs      := growInt(state.episodicTs,      EPISODIC_CAP, 0);
      state.episodicKind    := growText(state.episodicKind,   EPISODIC_CAP, "");
      state.episodicDroneId := growNat(state.episodicDroneId, EPISODIC_CAP, 0);
      state.episodicRSwarm  := growFloat(state.episodicRSwarm,EPISODIC_CAP, 0.0);
      state.episodicJDrift  := growFloat(state.episodicJDrift,EPISODIC_CAP, 0.0);
      state.episodicDesc    := growText(state.episodicDesc,   EPISODIC_CAP, "");
      state.episodicSensor  := growText(state.episodicSensor, EPISODIC_CAP, "{}");
    };
  };

  func ensurePatternCap(state : TelemetryState) {
    if (state.patternId.size() < PATTERN_CAP) {
      state.patternId     := growNat(state.patternId,     PATTERN_CAP, 0);
      state.patternBeat   := growNat(state.patternBeat,   PATTERN_CAP, 0);
      state.patternRSwarm := growFloat(state.patternRSwarm,PATTERN_CAP,0.0);
      state.patternName   := growText(state.patternName,  PATTERN_CAP, "");
      state.patternCount  := growNat(state.patternCount,  PATTERN_CAP, 0);
      state.patternPos    := growText(state.patternPos,   PATTERN_CAP, "[]");
    };
  };

  func formationName(rSwarm : Float) : Text {
    if      (rSwarm >= 0.98) "OMNIS_STATE"
    else if (rSwarm >= 0.95) "DIAMOND"
    else if (rSwarm >= 0.92) "FORMATION_LOCK"
    else if (rSwarm >= 0.90) "CONVERGING"
    else                     "LOOSE_PATROL"
  };

  // ─── REGISTER DRONE — SYNC ─────────────────────────────────────────────────

  public func registerDrone(state : TelemetryState, id : Nat, droneClass : Text) {
    if (id >= MAX_DRONES) return;
    let newCount = if (id + 1 > state.droneCount) id + 1 else state.droneCount;
    ensureDroneCap(state, newCount);
    state.droneCount := newCount;
    state.telClass[id]     := droneClass;
    state.telBattery[id]   := 100.0;
    state.telSignal[id]    := 1.0;
    state.telActivation[id]:= 1.0;
    state.telTimestamp[id] := Time.now();
  };

  // ─── UPDATE TELEMETRY — SYNC ────────────────────────────────────────────────

  public func updateTelemetry(
    state         : TelemetryState,
    id            : Nat,
    posX          : Float,
    posY          : Float,
    posZ          : Float,
    velX          : Float,
    velY          : Float,
    velZ          : Float,
    heading       : Float,
    altitude      : Float,
    batteryPct    : Float,
    signalStrength: Float,
    cortisol      : Float,
    dopamine      : Float,
    norepinephrine: Float,
    oxytocin      : Float,
    phase         : Float,
    activation    : Float,
    sacrificed    : Bool,
    beat          : Nat,
  ) {
    if (id >= MAX_DRONES) return;
    ensureDroneCap(state, id + 1);
    if (id + 1 > state.droneCount) state.droneCount := id + 1;
    state.telPosX[id]       := posX;
    state.telPosY[id]       := posY;
    state.telPosZ[id]       := posZ;
    state.telVelX[id]       := velX;
    state.telVelY[id]       := velY;
    state.telVelZ[id]       := velZ;
    state.telHeading[id]    := heading;
    state.telAltitude[id]   := altitude;
    state.telBattery[id]    := batteryPct;
    state.telSignal[id]     := signalStrength;
    state.telCortisol[id]   := cortisol;
    state.telDopamine[id]   := dopamine;
    state.telNorepi[id]     := norepinephrine;
    state.telOxytocin[id]   := oxytocin;
    state.telPhase[id]      := phase;
    state.telActivation[id] := activation;
    state.telSacrificed[id] := sacrificed;
    state.telBeat[id]       := beat;
    state.telTimestamp[id]  := Time.now();
  };

  // ─── EPISODIC MEMORY — SYNC ────────────────────────────────────────────────

  public func recordEvent(
    state       : TelemetryState,
    beat        : Nat,
    kind        : Text,
    droneId     : Nat,
    rSwarm      : Float,
    jDrift      : Float,
    description : Text,
    sensorData  : Text,
  ) : Nat {
    ensureEpisodicCap(state);
    let idx = state.episodicNextIdx % EPISODIC_CAP;
    state.episodicSeq[idx]     := state.episodicTotal;
    state.episodicBeat[idx]    := beat;
    state.episodicTs[idx]      := Time.now();
    state.episodicKind[idx]    := kind;
    state.episodicDroneId[idx] := droneId;
    state.episodicRSwarm[idx]  := rSwarm;
    state.episodicJDrift[idx]  := jDrift;
    state.episodicDesc[idx]    := description;
    state.episodicSensor[idx]  := sensorData;
    let seq = state.episodicTotal;
    state.episodicNextIdx      := (state.episodicNextIdx + 1) % EPISODIC_CAP;
    state.episodicTotal        += 1;
    seq
  };

  public func getRecentEvents(state : TelemetryState, n : Nat) : [EpisodicEvent] {
    let total = if (state.episodicTotal < EPISODIC_CAP) state.episodicTotal else EPISODIC_CAP;
    let count = if (n < total) n else total;
    Array.tabulate<EpisodicEvent>(count, func(i) {
      let idx = if (state.episodicTotal >= EPISODIC_CAP) {
        (state.episodicNextIdx + EPISODIC_CAP - count + i) % EPISODIC_CAP
      } else {
        state.episodicTotal - count + i
      };
      {
        seq         = state.episodicSeq[idx];
        beat        = state.episodicBeat[idx];
        timestamp   = state.episodicTs[idx];
        kind        = state.episodicKind[idx];
        droneId     = state.episodicDroneId[idx];
        rSwarm      = state.episodicRSwarm[idx];
        jDrift      = state.episodicJDrift[idx];
        description = state.episodicDesc[idx];
        sensorData  = state.episodicSensor[idx];
      }
    })
  };

  // ─── FORMATION PATTERN LIBRARY — SYNC ───────────────────────────────────────

  public func recordFormation(
    state       : TelemetryState,
    beat        : Nat,
    rSwarm      : Float,
    droneCount_ : Nat,
    posSnapshot : Text,
  ) {
    ensurePatternCap(state);
    let name = formationName(rSwarm);
    if (state.patternLibSize < PATTERN_CAP) {
      let idx = state.patternLibSize;
      state.patternId[idx]    := state.nextPatternId;
      state.patternBeat[idx]  := beat;
      state.patternRSwarm[idx]:= rSwarm;
      state.patternName[idx]  := name;
      state.patternCount[idx] := droneCount_;
      state.patternPos[idx]   := posSnapshot;
      state.patternLibSize    += 1;
      state.nextPatternId     += 1;
    } else {
      var minIdx = 0;
      var minR   = state.patternRSwarm[0];
      var i = 1;
      while (i < PATTERN_CAP) {
        if (state.patternRSwarm[i] < minR) {
          minR   := state.patternRSwarm[i];
          minIdx := i;
        };
        i += 1;
      };
      if (rSwarm > minR) {
        state.patternId[minIdx]    := state.nextPatternId;
        state.patternBeat[minIdx]  := beat;
        state.patternRSwarm[minIdx]:= rSwarm;
        state.patternName[minIdx]  := name;
        state.patternCount[minIdx] := droneCount_;
        state.patternPos[minIdx]   := posSnapshot;
        state.nextPatternId        += 1;
      };
    };
  };

  public func getTopFormations(state : TelemetryState) : [FormationPattern] {
    Array.tabulate<FormationPattern>(state.patternLibSize, func(i) {
      {
        id          = state.patternId[i];
        beat        = state.patternBeat[i];
        rSwarm      = state.patternRSwarm[i];
        name        = state.patternName[i];
        droneCount  = state.patternCount[i];
        posSnapshot = state.patternPos[i];
      }
    })
  };

  // ─── FULL TELEMETRY QUERY ───────────────────────────────────────────────────

  public func getAllTelemetry(state : TelemetryState) : [DroneTelemetry] {
    Array.tabulate<DroneTelemetry>(state.droneCount, func(i) {
      {
        droneId          = i;
        droneClass       = state.telClass[i];
        posX             = state.telPosX[i];
        posY             = state.telPosY[i];
        posZ             = state.telPosZ[i];
        velX             = state.telVelX[i];
        velY             = state.telVelY[i];
        velZ             = state.telVelZ[i];
        heading          = state.telHeading[i];
        altitude         = state.telAltitude[i];
        batteryPct       = state.telBattery[i];
        signalStrength   = state.telSignal[i];
        cortisol         = state.telCortisol[i];
        dopamine         = state.telDopamine[i];
        norepinephrine   = state.telNorepi[i];
        oxytocin         = state.telOxytocin[i];
        phase            = state.telPhase[i];
        activation       = state.telActivation[i];
        sacrificed       = state.telSacrificed[i];
        beat             = state.telBeat[i];
        timestamp        = state.telTimestamp[i];
      }
    })
  };

  public func getDroneTelemetry(state : TelemetryState, id : Nat) : ?DroneTelemetry {
    if (id >= state.droneCount) return null;
    ?{
      droneId          = id;
      droneClass       = state.telClass[id];
      posX             = state.telPosX[id];
      posY             = state.telPosY[id];
      posZ             = state.telPosZ[id];
      velX             = state.telVelX[id];
      velY             = state.telVelY[id];
      velZ             = state.telVelZ[id];
      heading          = state.telHeading[id];
      altitude         = state.telAltitude[id];
      batteryPct       = state.telBattery[id];
      signalStrength   = state.telSignal[id];
      cortisol         = state.telCortisol[id];
      dopamine         = state.telDopamine[id];
      norepinephrine   = state.telNorepi[id];
      oxytocin         = state.telOxytocin[id];
      phase            = state.telPhase[id];
      activation       = state.telActivation[id];
      sacrificed       = state.telSacrificed[id];
      beat             = state.telBeat[id];
      timestamp        = state.telTimestamp[id];
    }
  };

  public func getDroneCount(state : TelemetryState) : Nat { state.droneCount };

  // ─── RECOGNITION LAYER ───────────────────────────────────────────────────────

  public func recognizePattern(
    state    : TelemetryState,
    rSwarm   : Float,
    jDrift   : Float,
    cortisol : Float,
    phase    : Float,
  ) : {
    seq              : Nat;
    beat             : Nat;
    kind             : Text;
    description      : Text;
    recognitionScore : Float;
  } {
    let total = if (state.episodicTotal < EPISODIC_CAP) state.episodicTotal else EPISODIC_CAP;
    if (total == 0) return {
      seq = 0; beat = 0; kind = "NONE"; description = "no memories yet"; recognitionScore = 0.0
    };

    let qNorm = Float.sqrt(rSwarm*rSwarm + jDrift*jDrift + cortisol*cortisol + phase*phase) + 0.0001;

    var bestIdx   : Nat   = 0;
    var bestScore : Float = -1.0;
    var i = 0;
    while (i < total) {
      let sr = state.episodicRSwarm[i];
      let sj = state.episodicJDrift[i];
      let dot   = rSwarm * sr + jDrift * sj;
      let sNorm = Float.sqrt(sr*sr + sj*sj) + 0.0001;
      let sim   = dot / (qNorm * sNorm);
      if (sim > bestScore) { bestScore := sim; bestIdx := i };
      i += 1;
    };
    {
      seq              = state.episodicSeq[bestIdx];
      beat             = state.episodicBeat[bestIdx];
      kind             = state.episodicKind[bestIdx];
      description      = state.episodicDesc[bestIdx];
      recognitionScore = Float.max(0.0, Float.min(1.0, bestScore));
    }
  };

  // ─── MAVLINK BRIDGE STUB ─────────────────────────────────────────────────────

  public func sendMAVLink(cmd : MAVLinkCommand) : Bool {
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
