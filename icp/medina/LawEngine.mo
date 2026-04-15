// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — LAW ENGINE                                                 ║
// ║  RECITAL_PLUS_ONE sequencing, dual-read enforcement, Gate A/B/C.         ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import T     "./Types";

module {

  // ── CONSTANTS ─────────────────────────────────────────────────────────────

  let SEMANTIC_THRESHOLD  : Float = 0.70;
  let RESONANCE_THRESHOLD : Float = 0.65;
  let GATE_A_MIN          : Float = 0.80; // runtime readiness
  let GATE_B_MIN          : Float = 0.75; // workforce activation
  let GATE_C_MIN          : Float = 0.70; // projection safety

  // ── DUAL-READ ─────────────────────────────────────────────────────────────

  /// Evaluate both semantic and resonance read modes.
  /// Both must exceed their threshold for `ok = true`.
  public func dualRead(
    semanticScore  : Float,
    resonanceScore : Float
  ) : T.DualReadResult {
    {
      semanticScore;
      resonanceScore;
      ok = semanticScore  >= SEMANTIC_THRESHOLD
        and resonanceScore >= RESONANCE_THRESHOLD;
    }
  };

  // ── GATE EVALUATION ───────────────────────────────────────────────────────

  /// Evaluate a single gate against a score.
  public func evalGate(gate : T.GateId, score : Float) : T.GateState {
    let threshold = switch gate {
      case (#A) GATE_A_MIN;
      case (#B) GATE_B_MIN;
      case (#C) GATE_C_MIN;
    };
    if (score >= threshold)       #open
    else if (score >= threshold * 0.85) #soft_lock
    else                          #hard_lock
  };

  // ── RECITAL_PLUS_ONE ──────────────────────────────────────────────────────

  /// Produce the next lawful law-pass epoch.
  /// state(n+1) = recital(validated_state_n) + one_lawful_expansion
  public func recitalPlusOne(
    epoch          : Nat,
    recital        : Text,
    expansion      : Text,
    gateAScore     : Float,
    gateBScore     : Float,
    gateCScore     : Float,
    dualReadResult : T.DualReadResult
  ) : T.LawPass {
    {
      epoch      = epoch + 1;
      recital;
      expansion;
      gateA      = evalGate(#A, gateAScore);
      gateB      = evalGate(#B, gateBScore);
      gateC      = evalGate(#C, gateCScore);
      dualReadOk = dualReadResult.ok;
    }
  };

  // ── GATE AGGREGATE PASS ───────────────────────────────────────────────────

  /// All three gates must be #open and dual-read must be ok
  /// for a full law-pass to be considered authoritative.
  public func allGatesOpen(pass : T.LawPass) : Bool {
    pass.gateA == #open
    and pass.gateB == #open
    and pass.gateC == #open
    and pass.dualReadOk
  };

  // ── CORE AUTHORITY CHECKS ─────────────────────────────────────────────────

  /// Core A authority: approve or rollback runtime truth modifications.
  /// Returns true when gate A is open and dual-read is ok.
  public func coreAAuthority(pass : T.LawPass) : Bool {
    pass.gateA == #open and pass.dualReadOk
  };

  /// Core B authority: workforce execution and memory mutation roles.
  /// Returns true when gate B is open.
  public func coreBAuthority(pass : T.LawPass) : Bool {
    pass.gateB == #open
  };

}
