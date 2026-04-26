// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine — Native Nova Protocol                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// NATIVE NOVA PROTOCOL — BUILD №30
// ARCHITECT — Alpha Organism №3 — The Meta-Builder
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// ARCHITECT CREATES MORE ARCHITECTURE.
// He spawns organism blueprints using phyllotaxis positioning —
// each new organism is placed at the next golden-angle position in the
// civilization field, ensuring optimal non-overlapping distribution.
// Organisms are scaled by φ^generation and tracked through a living registry.
//
// Sub-model hosted:
//   REPLICATOR — Blueprint spawning and lifecycle management
//
// Placement law: angle_n = n × 137.508°,  radius_n = √n × φ^generation
// Scaling law:   scale_n = φ^generation
//
// Blueprint lifecycle: SEED → GERMINATING → ACTIVE → MATURE → LEGACY → ARCHIVED

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor Architect {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  func isAuthorized(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == architectPrincipal
  };

  func requireAuthorized(caller : Principal) { assert(isAuthorized(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "ARCHITECT_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-ARCHITECT-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };
  public query func getTimestamp() : async Int  { genesisTimestamp };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH CONSTANTS (embedded)
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI              : Float = 1.6180339887498948482;
  let PHI_INV          : Float = 0.6180339887498948482;
  let GOLDEN_ANGLE_RAD : Float = 2.39996322972865332;
  let GOLDEN_ANGLE_DEG : Float = 137.50776405003785;
  let PI               : Float = 3.14159265358979323846;
  let TWO_PI           : Float = 6.28318530717958647692;
  let EPSILON          : Float = 1.0e-10;

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) {
      if (exp == 0.0) 1.0 else 0.0
    } else Float.exp(exp * Float.log(base))
  };

  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _sin(x : Float)  : Float { Float.sin(x) };
  func _cos(x : Float)  : Float { Float.cos(x) };

  func _mod(a : Float, b : Float) : Float {
    if (b < EPSILON) 0.0
    else a - Float.fromInt(Int.abs(Float.toInt(a / b))) * b
  };

  // Generation thresholds: 1,2,3,5,8,13,21,34,55,89 → generations 1-10
  let GEN_THRESHOLDS : [Nat] = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

  func _generationFromCount(count : Nat) : Nat {
    var gen : Nat = 0;
    var i   : Nat = 0;
    while (i < GEN_THRESHOLDS.size()) {
      if (count >= GEN_THRESHOLDS[i]) { gen := i + 1 };
      i += 1;
    };
    if (gen == 0 and count > 0) gen := 1;
    gen
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type BlueprintStatus = {
    #SEED;
    #GERMINATING;
    #ACTIVE;
    #MATURE;
    #LEGACY;
    #ARCHIVED;
  };

  public type Blueprint = {
    id          : Nat;
    name        : Text;
    kind        : Text;      // organism type (e.g., "COGNITIVE", "ECONOMIC", "PHYSICAL")
    generation  : Nat;       // generation at spawning
    scaleFactor : Float;     // φ^generation
    posAngle    : Float;     // phyllotaxis angle (radians)
    posAngleDeg : Float;     // degrees
    posRadius   : Float;     // phyllotaxis radius
    posX        : Float;
    posY        : Float;
    status      : Text;      // blueprint lifecycle status
    spawnedAt   : Int;
    spawnBeat   : Nat;
    parentId    : ?Nat;      // parent blueprint id (if spawned from another)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — STABLE STATE
  // ═══════════════════════════════════════════════════════════════════════════

  let BLUEPRINT_CAP : Nat = 1024;

  stable var blueprintCount    : Nat = 0;
  stable var bpIds             : [var Nat]   = Array.init<Nat>(BLUEPRINT_CAP,   0);
  stable var bpNames           : [var Text]  = Array.init<Text>(BLUEPRINT_CAP,  "");
  stable var bpKinds           : [var Text]  = Array.init<Text>(BLUEPRINT_CAP,  "COGNITIVE");
  stable var bpGenerations     : [var Nat]   = Array.init<Nat>(BLUEPRINT_CAP,   0);
  stable var bpScaleFactors    : [var Float] = Array.init<Float>(BLUEPRINT_CAP, 1.0);
  stable var bpAngles          : [var Float] = Array.init<Float>(BLUEPRINT_CAP, 0.0);
  stable var bpAnglesDeg       : [var Float] = Array.init<Float>(BLUEPRINT_CAP, 0.0);
  stable var bpRadii           : [var Float] = Array.init<Float>(BLUEPRINT_CAP, 0.0);
  stable var bpPosX            : [var Float] = Array.init<Float>(BLUEPRINT_CAP, 0.0);
  stable var bpPosY            : [var Float] = Array.init<Float>(BLUEPRINT_CAP, 0.0);
  stable var bpStatuses        : [var Text]  = Array.init<Text>(BLUEPRINT_CAP,  "SEED");
  stable var bpSpawnedAt       : [var Int]   = Array.init<Int>(BLUEPRINT_CAP,   0);
  stable var bpSpawnBeats      : [var Nat]   = Array.init<Nat>(BLUEPRINT_CAP,   0);
  stable var bpParentIds       : [var Int]   = Array.init<Int>(BLUEPRINT_CAP,   -1);  // -1 = no parent
  stable var nextBlueprintId   : Nat         = 0;

  // Civilization beat counter
  stable var archBeat          : Nat = 0;

  // Base scale for phyllotaxis radius
  let BASE_SCALE : Float = 10.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  func _currentGeneration() : Nat { _generationFromCount(blueprintCount) };

  // Compute phyllotaxis position for the nth blueprint at a given generation
  func _phyllotaxisPos(n : Nat, generation : Nat) : (Float, Float, Float, Float, Float) {
    let nf     = Float.fromInt(n);
    let angle  = _mod(nf * GOLDEN_ANGLE_RAD, TWO_PI);
    let scale  = _pow(PHI, Float.fromInt(generation));
    let radius = _sqrt(nf) * scale * BASE_SCALE;
    let x      = radius * _cos(angle);
    let y      = radius * _sin(angle);
    (angle, _mod(nf * GOLDEN_ANGLE_DEG, 360.0), radius, x, y)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUB-MODEL: REPLICATOR — Blueprint spawning and lifecycle management
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Spawn a new organism blueprint ───────────────────────────────────────
  public shared(msg) func spawnBlueprint(
    name     : Text,
    kind     : Text,
    parentId : ?Nat
  ) : async {
    id          : Nat;
    name        : Text;
    generation  : Nat;
    scaleFactor : Float;
    posAngleDeg : Float;
    posRadius   : Float;
    posX        : Float;
    posY        : Float;
  } {
    requireAuthorized(msg.caller);
    if (blueprintCount >= BLUEPRINT_CAP) {
      return {
        id = 0; name = "ERROR_REGISTRY_FULL"; generation = 0;
        scaleFactor = 0.0; posAngleDeg = 0.0; posRadius = 0.0; posX = 0.0; posY = 0.0;
      }
    };
    let idx = blueprintCount;
    let id  = nextBlueprintId;
    let pid : Int = switch (parentId) { case null -1; case (?p) Int.fromNat(p) };

    bpIds[idx]       := id;
    bpNames[idx]     := name;
    bpKinds[idx]     := kind;
    bpSpawnedAt[idx] := Time.now();
    bpSpawnBeats[idx]:= archBeat;
    bpParentIds[idx] := pid;
    bpStatuses[idx]  := "SEED";

    blueprintCount  := blueprintCount + 1;
    nextBlueprintId := nextBlueprintId + 1;
    archBeat        := archBeat + 1;

    // Compute generation after incrementing count so Fibonacci threshold drives the tier
    let gen   = _currentGeneration();
    let (angle, angleDeg, radius, x, y) = _phyllotaxisPos(idx, gen);
    let scale = _pow(PHI, Float.fromInt(gen));

    bpGenerations[idx]  := gen;
    bpScaleFactors[idx] := scale;
    bpAngles[idx]       := angle;
    bpAnglesDeg[idx]    := angleDeg;
    bpRadii[idx]        := radius;
    bpPosX[idx]         := x;
    bpPosY[idx]         := y;

    { id; name; generation = gen; scaleFactor = scale; posAngleDeg = angleDeg; posRadius = radius; posX = x; posY = y }
  };

  // ── Advance a blueprint's lifecycle status ────────────────────────────────
  public shared(msg) func advanceLifecycle(id : Nat) : async Text {
    requireAuthorized(msg.caller);
    var i = 0;
    while (i < blueprintCount and i < BLUEPRINT_CAP) {
      if (bpIds[i] == id) {
        let next = switch (bpStatuses[i]) {
          case "SEED"        "GERMINATING";
          case "GERMINATING" "ACTIVE";
          case "ACTIVE"      "MATURE";
          case "MATURE"      "LEGACY";
          case "LEGACY"      "ARCHIVED";
          case _             "ARCHIVED";
        };
        bpStatuses[i] := next;
        archBeat := archBeat + 1;
        return "STATUS_ADVANCED: " # bpNames[i] # " → " # next;
      };
      i += 1;
    };
    "NOT_FOUND"
  };

  // ── Get blueprint by id ───────────────────────────────────────────────────
  public query func getBlueprint(id : Nat) : async ?{
    id          : Nat;
    name        : Text;
    kind        : Text;
    generation  : Nat;
    scaleFactor : Float;
    posAngleDeg : Float;
    posRadius   : Float;
    posX        : Float;
    posY        : Float;
    status      : Text;
    spawnedAt   : Int;
    parentId    : Int;
  } {
    var i = 0;
    while (i < blueprintCount and i < BLUEPRINT_CAP) {
      if (bpIds[i] == id) {
        return ?{
          id          = bpIds[i];
          name        = bpNames[i];
          kind        = bpKinds[i];
          generation  = bpGenerations[i];
          scaleFactor = bpScaleFactors[i];
          posAngleDeg = bpAnglesDeg[i];
          posRadius   = bpRadii[i];
          posX        = bpPosX[i];
          posY        = bpPosY[i];
          status      = bpStatuses[i];
          spawnedAt   = bpSpawnedAt[i];
          parentId    = bpParentIds[i];
        };
      };
      i += 1;
    };
    null
  };

  // ── Get all blueprints (living registry) ──────────────────────────────────
  public query func getRegistry() : async [{
    id          : Nat;
    name        : Text;
    kind        : Text;
    generation  : Nat;
    scaleFactor : Float;
    posAngleDeg : Float;
    posX        : Float;
    posY        : Float;
    status      : Text;
  }] {
    Array.tabulate<{ id:Nat; name:Text; kind:Text; generation:Nat; scaleFactor:Float; posAngleDeg:Float; posX:Float; posY:Float; status:Text }>(blueprintCount, func(i) {
      {
        id          = bpIds[i];
        name        = bpNames[i];
        kind        = bpKinds[i];
        generation  = bpGenerations[i];
        scaleFactor = bpScaleFactors[i];
        posAngleDeg = bpAnglesDeg[i];
        posX        = bpPosX[i];
        posY        = bpPosY[i];
        status      = bpStatuses[i];
      }
    })
  };

  // ── Get active blueprints only ─────────────────────────────────────────────
  public query func getActiveBlueprints() : async [{
    id : Nat; name : Text; kind : Text; generation : Nat; scaleFactor : Float;
    posAngleDeg : Float; posX : Float; posY : Float;
  }] {
    var result : [{ id:Nat; name:Text; kind:Text; generation:Nat; scaleFactor:Float; posAngleDeg:Float; posX:Float; posY:Float }] = [];
    var i = 0;
    while (i < blueprintCount and i < BLUEPRINT_CAP) {
      if (bpStatuses[i] == "ACTIVE" or bpStatuses[i] == "GERMINATING" or bpStatuses[i] == "MATURE") {
        result := Array.append(result, [{
          id = bpIds[i]; name = bpNames[i]; kind = bpKinds[i];
          generation = bpGenerations[i]; scaleFactor = bpScaleFactors[i];
          posAngleDeg = bpAnglesDeg[i]; posX = bpPosX[i]; posY = bpPosY[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ── Preview next phyllotaxis position ────────────────────────────────────
  public query func getNextPosition() : async {
    n           : Nat;
    generation  : Nat;
    posAngleDeg : Float;
    posRadius   : Float;
    posX        : Float;
    posY        : Float;
    scaleFactor : Float;
  } {
    let nextN = blueprintCount;
    let gen   = _generationFromCount(nextN + 1);
    let (angle, angleDeg, radius, x, y) = _phyllotaxisPos(nextN, gen);
    let scale = _pow(PHI, Float.fromInt(gen));
    {
      n = nextN; generation = gen;
      posAngleDeg = angleDeg; posRadius = radius; posX = x; posY = y;
      scaleFactor = scale;
    }
  };

  // ── Blueprint count by status ─────────────────────────────────────────────
  public query func countByStatus() : async [{
    status : Text;
    count  : Nat;
  }] {
    let statuses : [Text] = ["SEED","GERMINATING","ACTIVE","MATURE","LEGACY","ARCHIVED"];
    Array.tabulate<{ status:Text; count:Nat }>(6, func(si) {
      let st = statuses[si];
      var cnt : Nat = 0;
      var i = 0;
      while (i < blueprintCount and i < BLUEPRINT_CAP) {
        if (bpStatuses[i] == st) { cnt += 1 };
        i += 1;
      };
      { status = st; count = cnt }
    })
  };

  // ── Blueprint count by generation ─────────────────────────────────────────
  public query func countByGeneration() : async [{
    generation  : Nat;
    count       : Nat;
    scaleFactor : Float;
  }] {
    Array.tabulate<{ generation:Nat; count:Nat; scaleFactor:Float }>(11, func(g) {
      var cnt : Nat = 0;
      var i = 0;
      while (i < blueprintCount and i < BLUEPRINT_CAP) {
        if (bpGenerations[i] == g) { cnt += 1 };
        i += 1;
      };
      { generation = g; count = cnt; scaleFactor = _pow(PHI, Float.fromInt(g)) }
    })
  };

  // ── Civilization field view: all positions plotted ────────────────────────
  public query func getCivilizationField() : async {
    blueprintCount : Nat;
    civilizationGen: Nat;
    civilizationScale : Float;
    positions      : [{
      id : Nat; name : Text; posAngleDeg : Float; posX : Float; posY : Float;
    }];
  } {
    let civGen   = _currentGeneration();
    let civScale = _pow(PHI, Float.fromInt(civGen));
    {
      blueprintCount   = blueprintCount;
      civilizationGen  = civGen;
      civilizationScale = civScale;
      positions = Array.tabulate<{ id:Nat; name:Text; posAngleDeg:Float; posX:Float; posY:Float }>(blueprintCount, func(i) {
        { id = bpIds[i]; name = bpNames[i]; posAngleDeg = bpAnglesDeg[i]; posX = bpPosX[i]; posY = bpPosY[i] }
      });
    }
  };

  // ── Current generation and count ─────────────────────────────────────────
  public query func getBlueprintCount()  : async Nat   { blueprintCount };
  public query func getCurrentGeneration(): async Nat  { _currentGeneration() };
  public query func getArchBeat()         : async Nat  { archBeat };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — ARCHITECT STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getArchitectStatus() : async {
    seal           : Text;
    claimed        : Bool;
    blueprintCount : Nat;
    currentGen     : Nat;
    nextGenAt      : Nat;
    civilizationScale : Float;
    archBeat       : Nat;
    subModels      : [Text];
  } {
    let curGen  = _currentGeneration();
    let nextAt  = if (curGen >= GEN_THRESHOLDS.size()) 144 else GEN_THRESHOLDS[curGen];
    {
      seal              = sovereignSeal;
      claimed           = genesisLocked;
      blueprintCount    = blueprintCount;
      currentGen        = curGen;
      nextGenAt         = nextAt;
      civilizationScale = _pow(PHI, Float.fromInt(curGen));
      archBeat          = archBeat;
      subModels         = ["REPLICATOR"];
    }
  };

};
