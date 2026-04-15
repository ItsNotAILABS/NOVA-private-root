// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — ORCHESTRATORS                                              ║
// ║  ORCH-01..08 registry, beat-gate evaluation, cadence classification.     ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import Array "mo:base/Array";
import Float "mo:base/Float";
import T     "./Types";

module {

  // ── CADENCE CLASSES ───────────────────────────────────────────────────────
  // Every beat, every N beats, or event-driven.
  // Used to enforce RUNTIME-CADENCE-PLAN (W5 hardening).

  public type Cadence = {
    #every_beat;
    #every_n  : Nat;   // run every N beats
    #event_driven;
  };

  // ── ORCHESTRATOR SPEC ─────────────────────────────────────────────────────

  public type OrchSpec = {
    id          : T.OrchId;
    name        : Text;
    description : Text;
    cadence     : Cadence;
    gateMin     : Float;  // minimum gate score to pass beat gate
  };

  // ── REGISTRY ──────────────────────────────────────────────────────────────

  public func spec(id : T.OrchId) : OrchSpec {
    switch id {
      case (#ORCH01_SOVEREIGN_TICK) {
        id;
        name        = "SOVEREIGN_TICK_ORCHESTRATOR";
        description = "Authorization lock, lifecycle sync, starts beat-level runtime flow";
        cadence     = #every_beat;
        gateMin     = 0.80;
      };
      case (#ORCH02_SPHERICAL_INTEGRATION) {
        id;
        name        = "SPHERICAL_INTEGRATION_ORCHESTRATOR";
        description = "Cardio-neural-memory-feedback macro spine each beat before tickCore";
        cadence     = #every_beat;
        gateMin     = 0.78;
      };
      case (#ORCH03_SWARM_CORE) {
        id;
        name        = "SWARM_CORE_ORCHESTRATOR";
        description = "Dense swarm physics + cognition + multi-layer module cascade";
        cadence     = #every_beat;
        gateMin     = 0.75;
      };
      case (#ORCH04_FULL_GOVERNANCE) {
        id;
        name        = "FULL_GOVERNANCE_ORCHESTRATOR";
        description = "Full governance/behavior add-ons: SACESI/OMNIS tiering/law pass";
        cadence     = #every_n(4);
        gateMin     = 0.80;
      };
      case (#ORCH05_CONSTITUTIONAL_LAW) {
        id;
        name        = "CONSTITUTIONAL_LAW_ORCHESTRATOR";
        description = "Computes law compliance lattice, updates sovereign legal state";
        cadence     = #every_n(4);
        gateMin     = 0.80;
      };
      case (#ORCH06_NEURAL_CORE_MESH) {
        id;
        name        = "NEURAL_CORE_MESH_ORCHESTRATOR";
        description = "High-dimensional core mesh coherence and wiring";
        cadence     = #every_n(8);
        gateMin     = 0.72;
      };
      case (#ORCH07_LIVING_DOCUMENT_MACRO) {
        id;
        name        = "LIVING_DOCUMENT_MACRO_ORCHESTRATOR";
        description = "Macro field: presence/autonomy/document vitality/chain integrity";
        cadence     = #every_n(52);
        gateMin     = 0.70;
      };
      case (#ORCH08_FRONTEND_COMMAND) {
        id;
        name        = "FRONTEND_COMMAND_ORCHESTRATOR";
        description = "Operational command UI over runtime state, 20 Hz loop";
        cadence     = #event_driven;
        gateMin     = 0.65;
      };
    }
  };

  // ── BEAT GATE EVALUATION ──────────────────────────────────────────────────

  /// Determine if an orchestrator should run on this beat.
  /// Returns an OrchBeat result with gate pass/fail.
  public func evalBeat(
    id         : T.OrchId,
    beat       : Nat,
    gateScore  : Float
  ) : T.OrchBeat {
    let s = spec(id);
    let shouldRun = switch s.cadence {
      case (#every_beat)  true;
      case (#every_n(n))  beat % n == 0;
      case (#event_driven) false;   // driven externally
    };
    let passed = shouldRun and gateScore >= s.gateMin;
    { orchId = id; beat; gateScore; passed }
  };

  // ── ALL ORCHESTRATORS LIST ────────────────────────────────────────────────

  public let all : [T.OrchId] = [
    #ORCH01_SOVEREIGN_TICK,
    #ORCH02_SPHERICAL_INTEGRATION,
    #ORCH03_SWARM_CORE,
    #ORCH04_FULL_GOVERNANCE,
    #ORCH05_CONSTITUTIONAL_LAW,
    #ORCH06_NEURAL_CORE_MESH,
    #ORCH07_LIVING_DOCUMENT_MACRO,
    #ORCH08_FRONTEND_COMMAND,
  ];

  /// Run beat-gate evaluation for every orchestrator and return results.
  public func evalAll(beat : Nat, gateScore : Float) : [T.OrchBeat] {
    Array.map<T.OrchId, T.OrchBeat>(all, func(id) {
      evalBeat(id, beat, gateScore)
    })
  };

}
