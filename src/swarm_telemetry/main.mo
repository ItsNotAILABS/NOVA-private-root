// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Owner: Alfredo Medina Hernandez · Dallas TX · MedinaSITech@outlook.com                                  ║
// ║  Framework: Medina Doctrine — Native Nova Protocol                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
//
// SWARM TELEMETRY — SOVEREIGN TELEMETRY INTELLIGENCE ENGINE (BUILD №46)
// EVERYTHING IS INTELLIGENCE — This is NOT simulation. This is REAL computation.
// Physics = REAL math and geometry. Golden numbers are REAL. No fake simulation.
//
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

actor SwarmTelemetry {

  // ─── TYPES ──────────────────────────────────────────────────────────────────

  // Telemetry snapshot for one drone
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

  // Episodic memory entry
  public type EpisodicEvent = {
    seq        : Nat;
    beat       : Nat;
    timestamp  : Int;
    kind       : Text;
    droneId    : Nat;
    rSwarm     : Float;
    jDrift     : Float;
    description: Text;
    sensorData : Text; // JSON
  };

  // Formation pattern (top coherence formations stored permanently)
  public type FormationPattern = {
    id          : Nat;
    beat        : Nat;
    rSwarm      : Float;
    name        : Text;
    droneCount  : Nat;
    posSnapshot : Text; // JSON positions
  };

  // MAVLink bridge stub
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

  // ─── STABLE STATE ───────────────────────────────────────────────────────────

  // Per-drone telemetry (flat arrays)
  stable var telPosX           : [var Float] = [var];
  stable var telPosY           : [var Float] = [var];
  stable var telPosZ           : [var Float] = [var];
  stable var telVelX           : [var Float] = [var];
  stable var telVelY           : [var Float] = [var];
  stable var telVelZ           : [var Float] = [var];
  stable var telHeading        : [var Float] = [var];
  stable var telAltitude       : [var Float] = [var];
  stable var telBattery        : [var Float] = [var];
  stable var telSignal         : [var Float] = [var];
  stable var telCortisol       : [var Float] = [var];
  stable var telDopamine       : [var Float] = [var];
  stable var telNorepi         : [var Float] = [var];
  stable var telOxytocin       : [var Float] = [var];
  stable var telPhase          : [var Float] = [var];
  stable var telActivation     : [var Float] = [var];
  stable var telSacrificed     : [var Bool]  = [var];
  stable var telClass          : [var Text]  = [var];
  stable var telBeat           : [var Nat]   = [var];
  stable var telTimestamp      : [var Int]   = [var];
  stable var droneCount        : Nat = 0;

  // Episodic memory: last 1000 significant events
  stable var episodicSeq       : [var Nat]   = [var];
  stable var episodicBeat      : [var Nat]   = [var];
  stable var episodicTs        : [var Int]   = [var];
  stable var episodicKind      : [var Text]  = [var];
  stable var episodicDroneId   : [var Nat]   = [var];
  stable var episodicRSwarm    : [var Float] = [var];
  stable var episodicJDrift    : [var Float] = [var];
  stable var episodicDesc      : [var Text]  = [var];
  stable var episodicSensor    : [var Text]  = [var];
  stable var episodicNextIdx   : Nat = 0;
  stable var episodicTotal     : Nat = 0;

  // Formation pattern library (top 10 highest-coherence formations)
  stable var patternId         : [var Nat]   = [var];
  stable var patternBeat       : [var Nat]   = [var];
  stable var patternRSwarm     : [var Float] = [var];
  stable var patternName       : [var Text]  = [var];
  stable var patternCount      : [var Nat]   = [var];
  stable var patternPos        : [var Text]  = [var];
  stable var patternLibSize    : Nat = 0;
  stable var nextPatternId     : Nat = 0;

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

  func ensureDroneCap(n : Nat) {
    if (telPosX.size() < n) {
      telPosX       := growFloat(telPosX,       n, 0.0);
      telPosY       := growFloat(telPosY,       n, 0.0);
      telPosZ       := growFloat(telPosZ,       n, 0.0);
      telVelX       := growFloat(telVelX,       n, 0.0);
      telVelY       := growFloat(telVelY,       n, 0.0);
      telVelZ       := growFloat(telVelZ,       n, 0.0);
      telHeading    := growFloat(telHeading,    n, 0.0);
      telAltitude   := growFloat(telAltitude,   n, 0.0);
      telBattery    := growFloat(telBattery,    n, 100.0);
      telSignal     := growFloat(telSignal,     n, 1.0);
      telCortisol   := growFloat(telCortisol,   n, 1.0);
      telDopamine   := growFloat(telDopamine,   n, 1.0);
      telNorepi     := growFloat(telNorepi,     n, 1.0);
      telOxytocin   := growFloat(telOxytocin,   n, 1.0);
      telPhase      := growFloat(telPhase,      n, 0.0);
      telActivation := growFloat(telActivation, n, 1.0);
      telSacrificed := growBool(telSacrificed,  n, false);
      telClass      := growText(telClass,       n, "SCOUT");
      telBeat       := growNat(telBeat,         n, 0);
      telTimestamp  := growInt(telTimestamp,    n, 0);
    };
  };

  func ensureEpisodicCap() {
    if (episodicSeq.size() < EPISODIC_CAP) {
      episodicSeq     := growNat(episodicSeq,     EPISODIC_CAP, 0);
      episodicBeat    := growNat(episodicBeat,    EPISODIC_CAP, 0);
      episodicTs      := growInt(episodicTs,      EPISODIC_CAP, 0);
      episodicKind    := growText(episodicKind,   EPISODIC_CAP, "");
      episodicDroneId := growNat(episodicDroneId, EPISODIC_CAP, 0);
      episodicRSwarm  := growFloat(episodicRSwarm,EPISODIC_CAP, 0.0);
      episodicJDrift  := growFloat(episodicJDrift,EPISODIC_CAP, 0.0);
      episodicDesc    := growText(episodicDesc,   EPISODIC_CAP, "");
      episodicSensor  := growText(episodicSensor, EPISODIC_CAP, "{}");
    };
  };

  func ensurePatternCap() {
    if (patternId.size() < PATTERN_CAP) {
      patternId     := growNat(patternId,     PATTERN_CAP, 0);
      patternBeat   := growNat(patternBeat,   PATTERN_CAP, 0);
      patternRSwarm := growFloat(patternRSwarm,PATTERN_CAP,0.0);
      patternName   := growText(patternName,  PATTERN_CAP, "");
      patternCount  := growNat(patternCount,  PATTERN_CAP, 0);
      patternPos    := growText(patternPos,   PATTERN_CAP, "[]");
    };
  };

  func formationName(rSwarm : Float) : Text {
    if      (rSwarm >= 0.98) "OMNIS_STATE"
    else if (rSwarm >= 0.95) "DIAMOND"
    else if (rSwarm >= 0.92) "FORMATION_LOCK"
    else if (rSwarm >= 0.90) "CONVERGING"
    else                     "LOOSE_PATROL"
  };

  // ─── REGISTER DRONE ─────────────────────────────────────────────────────────

  public func registerDrone(id : Nat, droneClass : Text) : async () {
    if (id >= MAX_DRONES) return;
    let newCount = if (id + 1 > droneCount) id + 1 else droneCount;
    ensureDroneCap(newCount);
    droneCount := newCount;
    telClass[id]     := droneClass;
    telBattery[id]   := 100.0;
    telSignal[id]    := 1.0;
    telActivation[id]:= 1.0;
    telTimestamp[id] := Time.now();
  };

  // ─── UPDATE TELEMETRY ────────────────────────────────────────────────────────

  public func updateTelemetry(
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
  ) : async () {
    if (id >= MAX_DRONES) return;
    ensureDroneCap(id + 1);
    if (id + 1 > droneCount) droneCount := id + 1;
    telPosX[id]       := posX;
    telPosY[id]       := posY;
    telPosZ[id]       := posZ;
    telVelX[id]       := velX;
    telVelY[id]       := velY;
    telVelZ[id]       := velZ;
    telHeading[id]    := heading;
    telAltitude[id]   := altitude;
    telBattery[id]    := batteryPct;
    telSignal[id]     := signalStrength;
    telCortisol[id]   := cortisol;
    telDopamine[id]   := dopamine;
    telNorepi[id]     := norepinephrine;
    telOxytocin[id]   := oxytocin;
    telPhase[id]      := phase;
    telActivation[id] := activation;
    telSacrificed[id] := sacrificed;
    telBeat[id]       := beat;
    telTimestamp[id]  := Time.now();
  };

  // ─── EPISODIC MEMORY ────────────────────────────────────────────────────────

  public func recordEvent(
    beat        : Nat,
    kind        : Text,
    droneId     : Nat,
    rSwarm      : Float,
    jDrift      : Float,
    description : Text,
    sensorData  : Text,) : async Nat {
    ensureEpisodicCap();
    let idx = episodicNextIdx % EPISODIC_CAP;
    episodicSeq[idx]     := episodicTotal;
    episodicBeat[idx]    := beat;
    episodicTs[idx]      := Time.now();
    episodicKind[idx]    := kind;
    episodicDroneId[idx] := droneId;
    episodicRSwarm[idx]  := rSwarm;
    episodicJDrift[idx]  := jDrift;
    episodicDesc[idx]    := description;
    episodicSensor[idx]  := sensorData;
    let seq = episodicTotal;
    episodicNextIdx      := (episodicNextIdx + 1) % EPISODIC_CAP;
    episodicTotal        += 1;
    seq
  };

  public query func getRecentEvents(n : Nat) : async [EpisodicEvent] {
    let total = if (episodicTotal < EPISODIC_CAP) episodicTotal else EPISODIC_CAP;
    let count = if (n < total) n else total;
    Array.tabulate<EpisodicEvent>(count, func(i) {
      let idx = if (episodicTotal >= EPISODIC_CAP) {
        (episodicNextIdx + EPISODIC_CAP - count + i) % EPISODIC_CAP
      } else {
        episodicTotal - count + i
      };
      {
        seq         = episodicSeq[idx];
        beat        = episodicBeat[idx];
        timestamp   = episodicTs[idx];
        kind        = episodicKind[idx];
        droneId     = episodicDroneId[idx];
        rSwarm      = episodicRSwarm[idx];
        jDrift      = episodicJDrift[idx];
        description = episodicDesc[idx];
        sensorData  = episodicSensor[idx];
      }
    })
  };

  // ─── FORMATION PATTERN LIBRARY ───────────────────────────────────────────────

  public func recordFormation(
    beat        : Nat,
    rSwarm      : Float,
    droneCount_ : Nat,
    posSnapshot : Text,
  ) : async () {
    ensurePatternCap();
    let name = formationName(rSwarm);
    // Only store if rSwarm is higher than the lowest stored pattern
    if (patternLibSize < PATTERN_CAP) {
      let idx = patternLibSize;
      patternId[idx]    := nextPatternId;
      patternBeat[idx]  := beat;
      patternRSwarm[idx]:= rSwarm;
      patternName[idx]  := name;
      patternCount[idx] := droneCount_;
      patternPos[idx]   := posSnapshot;
      patternLibSize    += 1;
      nextPatternId     += 1;
    } else {
      // Find the lowest rSwarm entry and replace if current is higher
      var minIdx = 0;
      var minR   = patternRSwarm[0];
      var i = 1;
      while (i < PATTERN_CAP) {
        if (patternRSwarm[i] < minR) {
          minR   := patternRSwarm[i];
          minIdx := i;
        };
        i += 1;
      };
      if (rSwarm > minR) {
        patternId[minIdx]    := nextPatternId;
        patternBeat[minIdx]  := beat;
        patternRSwarm[minIdx]:= rSwarm;
        patternName[minIdx]  := name;
        patternCount[minIdx] := droneCount_;
        patternPos[minIdx]   := posSnapshot;
        nextPatternId        += 1;
      };
    };
  };

  public query func getTopFormations() : async [FormationPattern] {
    Array.tabulate<FormationPattern>(patternLibSize, func(i) {
      {
        id          = patternId[i];
        beat        = patternBeat[i];
        rSwarm      = patternRSwarm[i];
        name        = patternName[i];
        droneCount  = patternCount[i];
        posSnapshot = patternPos[i];
      }
    })
  };

  // ─── FULL TELEMETRY QUERY ───────────────────────────────────────────────────

  public query func getAllTelemetry() : async [DroneTelemetry] {
    Array.tabulate<DroneTelemetry>(droneCount, func(i) {
      {
        droneId          = i;
        droneClass       = telClass[i];
        posX             = telPosX[i];
        posY             = telPosY[i];
        posZ             = telPosZ[i];
        velX             = telVelX[i];
        velY             = telVelY[i];
        velZ             = telVelZ[i];
        heading          = telHeading[i];
        altitude         = telAltitude[i];
        batteryPct       = telBattery[i];
        signalStrength   = telSignal[i];
        cortisol         = telCortisol[i];
        dopamine         = telDopamine[i];
        norepinephrine   = telNorepi[i];
        oxytocin         = telOxytocin[i];
        phase            = telPhase[i];
        activation       = telActivation[i];
        sacrificed       = telSacrificed[i];
        beat             = telBeat[i];
        timestamp        = telTimestamp[i];
      }
    })
  };

  public query func getDroneTelemetry(id : Nat) : async ?DroneTelemetry {
    if (id >= droneCount) return null;
    ?{
      droneId          = id;
      droneClass       = telClass[id];
      posX             = telPosX[id];
      posY             = telPosY[id];
      posZ             = telPosZ[id];
      velX             = telVelX[id];
      velY             = telVelY[id];
      velZ             = telVelZ[id];
      heading          = telHeading[id];
      altitude         = telAltitude[id];
      batteryPct       = telBattery[id];
      signalStrength   = telSignal[id];
      cortisol         = telCortisol[id];
      dopamine         = telDopamine[id];
      norepinephrine   = telNorepi[id];
      oxytocin         = telOxytocin[id];
      phase            = telPhase[id];
      activation       = telActivation[id];
      sacrificed       = telSacrificed[id];
      beat             = telBeat[id];
      timestamp        = telTimestamp[id];
    }
  };

  public query func getDroneCount() : async Nat { droneCount };

  // ─── RECOGNITION LAYER ───────────────────────────────────────────────────────
  // Memory is not just recalled chronologically — it actively RECOGNIZES the
  // present state by measuring similarity to stored episodes.
  // Recognition uses a 2D state signature from the fields stored per episode:
  //   rSwarm  — swarm coherence (most stable proxy for spatial state)
  //   jDrift  — Lyapunov stability (most stable proxy for temporal state)
  // Returns the stored episode whose state signature is most similar (cosine
  // similarity on the 2D vector) to the query, plus a recognition score in [0, 1].
  // The cortisol and phase parameters are accepted for API compatibility but are
  // used only to form the query norm, allowing callers to pass richer context
  // when episodic entries carry those fields in future expansions.

  public query func recognizePattern(
    rSwarm   : Float,
    jDrift   : Float,
    cortisol : Float,
    phase    : Float,
  ) : async {
    seq              : Nat;
    beat             : Nat;
    kind             : Text;
    description      : Text;
    recognitionScore : Float;
  } {
    let total = if (episodicTotal < EPISODIC_CAP) episodicTotal else EPISODIC_CAP;
    if (total == 0) return {
      seq = 0; beat = 0; kind = "NONE"; description = "no memories yet"; recognitionScore = 0.0
    };

    // 2D cosine similarity on the (rSwarm, jDrift) axes that are stored per episode.
    // The query norm uses all four dimensions provided by the caller; the stored
    // vector norm uses only the two stored axes.
    let qNorm = Float.sqrt(rSwarm*rSwarm + jDrift*jDrift + cortisol*cortisol + phase*phase) + 0.0001;

    var bestIdx   : Nat   = 0;
    var bestScore : Float = -1.0;
    var i = 0;
    while (i < total) {
      let sr = episodicRSwarm[i];
      let sj = episodicJDrift[i];
      let dot   = rSwarm * sr + jDrift * sj;
      let sNorm = Float.sqrt(sr*sr + sj*sj) + 0.0001;
      let sim   = dot / (qNorm * sNorm);
      if (sim > bestScore) { bestScore := sim; bestIdx := i };
      i += 1;
    };
    {
      seq              = episodicSeq[bestIdx];
      beat             = episodicBeat[bestIdx];
      kind             = episodicKind[bestIdx];
      description      = episodicDesc[bestIdx];
      recognitionScore = Float.max(0.0, Float.min(1.0, bestScore));
    }
  };

  // ─── MAVLINK BRIDGE STUB ─────────────────────────────────────────────────────

  // In simulation: log and return true.
  // In production: HTTP outcall to ground station via ICP HTTP outcalls.
  public func sendMAVLink(cmd : MAVLinkCommand) : async Bool {
    // Stub — in production replace with:
    // let response = await ic.http_request({...}) pointing to ground station
    true
  };

};
