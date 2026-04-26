// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — GOVERNANCE                                                 ║
// ║  Proposal / approval / rejection / rollback lifecycle.                   ║
// ║  Four-register authority and replay evidence trail.                      ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import Array  "mo:base/Array";
import T      "./Types";
import LE     "./LawEngine";

module {

  // ── PROPOSAL CREATION ────────────────────────────────────────────────────

  /// Create a new pending proposal under the specified register.
  public func createProposal(
    id       : Nat,
    register : T.Register,
    content  : Text,
    epoch    : Nat
  ) : T.Proposal {
    {
      id       = id;
      register = register;
      content  = content;
      status   = #pending;
      epoch    = epoch;
      evidence = [];
    }
  };

  // ── APPROVAL ─────────────────────────────────────────────────────────────

  /// Approve a proposal when Core A authority is confirmed.
  /// Returns #ok with updated proposal, or #err with reason.
  public func approve(
    p        : T.Proposal,
    lawPass  : T.LawPass
  ) : { #ok : T.Proposal; #err : Text } {
    if (p.status != #pending) {
      return #err("Proposal " # debug_show(p.id) # " is not pending");
    };
    if (not LE.coreAAuthority(lawPass)) {
      return #err("Gate A closed or dual-read failed — approval denied");
    };
    #ok({
      p with
      status   = #approved;
      evidence = Array.append(p.evidence, ["approved-epoch:" # debug_show(lawPass.epoch)]);
    })
  };

  // ── REJECTION ─────────────────────────────────────────────────────────────

  /// Reject a pending proposal with an explicit reason.
  public func reject(
    p      : T.Proposal,
    reason : Text
  ) : { #ok : T.Proposal; #err : Text } {
    if (p.status != #pending) {
      return #err("Proposal " # debug_show(p.id) # " is not pending");
    };
    #ok({
      p with
      status   = #rejected;
      evidence = Array.append(p.evidence, ["rejected:" # reason]);
    })
  };

  // ── ROLLBACK ──────────────────────────────────────────────────────────────

  /// Roll back an approved proposal (Core A authority required).
  public func rollback(
    p       : T.Proposal,
    lawPass : T.LawPass,
    reason  : Text
  ) : { #ok : T.Proposal; #err : Text } {
    if (p.status != #approved) {
      return #err("Only approved proposals may be rolled back");
    };
    if (not LE.coreAAuthority(lawPass)) {
      return #err("Gate A closed — rollback denied");
    };
    #ok({
      p with
      status   = #rolled_back;
      evidence = Array.append(p.evidence, ["rolled-back:" # reason]);
    })
  };

  // ── STATUS SUMMARY ────────────────────────────────────────────────────────

  /// Count proposals in each status class.
  public type StatusSummary = {
    pending     : Nat;
    approved    : Nat;
    rejected    : Nat;
    rolledBack  : Nat;
  };

  public func statusSummary(proposals : [T.Proposal]) : StatusSummary {
    var pending    = 0;
    var approved   = 0;
    var rejected   = 0;
    var rolledBack = 0;
    for (p in proposals.vals()) {
      switch (p.status) {
        case (#pending)      { pending    += 1 };
        case (#approved)     { approved   += 1 };
        case (#rejected)     { rejected   += 1 };
        case (#rolled_back)  { rolledBack += 1 };
      }
    };
    { pending; approved; rejected; rolledBack }
  };

  // ── POLICY CHECK ──────────────────────────────────────────────────────────

  /// Check that the four-register matrix is satisfied:
  /// at least one proposal per register must be approved before a
  /// sovereignty state mutation is permitted.
  public func fourRegisterCheck(proposals : [T.Proposal]) : Bool {
    let approved = Array.filter<T.Proposal>(
      proposals,
      func(p) { p.status == #approved }
    );
    let hasFounder   = Array.find<T.Proposal>(approved, func(p) { p.register == #founder   }) != null;
    let hasBuilder   = Array.find<T.Proposal>(approved, func(p) { p.register == #builder   }) != null;
    let hasOrganism  = Array.find<T.Proposal>(approved, func(p) { p.register == #organism  }) != null;
    let hasExternal  = Array.find<T.Proposal>(approved, func(p) { p.register == #external  }) != null;
    hasFounder and hasBuilder and hasOrganism and hasExternal
  };

}
