// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — COMPANY                                                    ║
// ║  Connect / Internalize / Hybrid tenant onboarding primitives.            ║
// ║  Mutation evidence, replay trail, permission-gated actions.              ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import Array "mo:base/Array";
import T     "./Types";
import LE    "./LawEngine";

module {

  // ── ONBOARD ───────────────────────────────────────────────────────────────

  /// Create a new tenant record in the requested mode.
  /// Gate B (workforce activation) must be open.
  public func onboard(
    id      : Nat,
    name    : Text,
    mode    : T.OnboardMode,
    lawPass : T.LawPass,
    beat    : Nat
  ) : { #ok : T.TenantRecord; #err : Text } {
    if (not LE.coreBAuthority(lawPass)) {
      return #err("Gate B closed — onboarding denied for " # name);
    };
    let modeLabel = switch mode {
      case (#connect)     "CONNECT";
      case (#internalize) "INTERNALIZE";
      case (#hybrid)      "HYBRID";
    };
    #ok({
      id;
      name;
      mode;
      beat;
      evidence = ["onboard-mode:" # modeLabel # "@beat:" # debug_show(beat)];
      active   = true;
    })
  };

  // ── CONNECT MODE ──────────────────────────────────────────────────────────

  /// Register an external system connection for a CONNECT-mode tenant.
  /// Appends mutation evidence to the tenant record.
  public func connect(
    tenant    : T.TenantRecord,
    systemId  : Text,
    connector : Text,
    beat      : Nat
  ) : { #ok : T.TenantRecord; #err : Text } {
    if (tenant.mode != #connect and tenant.mode != #hybrid) {
      return #err("Tenant mode does not permit connect operation");
    };
    if (not tenant.active) {
      return #err("Tenant " # tenant.name # " is not active");
    };
    #ok({
      tenant with
      evidence = Array.append(
        tenant.evidence,
        ["connect:" # systemId # " via=" # connector # " @beat=" # debug_show(beat)]
      );
    })
  };

  // ── INTERNALIZE MODE ─────────────────────────────────────────────────────

  /// Replicate an external system into the NOVA substrate.
  /// Requires Gate B (Core B authority for memory mutation).
  public func internalize(
    tenant     : T.TenantRecord,
    assetId    : Text,
    assetType  : Text,
    lawPass    : T.LawPass,
    beat       : Nat
  ) : { #ok : T.TenantRecord; #err : Text } {
    if (tenant.mode != #internalize and tenant.mode != #hybrid) {
      return #err("Tenant mode does not permit internalize operation");
    };
    if (not LE.coreBAuthority(lawPass)) {
      return #err("Gate B closed — internalize denied");
    };
    #ok({
      tenant with
      evidence = Array.append(
        tenant.evidence,
        ["internalize:" # assetId # " type=" # assetType # " @beat=" # debug_show(beat)]
      );
    })
  };

  // ── HYBRID RECONCILE ──────────────────────────────────────────────────────

  /// Record a reconciliation event for a HYBRID-mode tenant.
  public func hybridReconcile(
    tenant    : T.TenantRecord,
    deltaKey  : Text,
    direction : Text,    // e.g. "edge→nova" or "nova→edge"
    beat      : Nat
  ) : { #ok : T.TenantRecord; #err : Text } {
    if (tenant.mode != #hybrid) {
      return #err("hybridReconcile only valid for HYBRID mode tenants");
    };
    #ok({
      tenant with
      evidence = Array.append(
        tenant.evidence,
        ["reconcile:" # deltaKey # " dir=" # direction # " @beat=" # debug_show(beat)]
      );
    })
  };

  // ── DEACTIVATE ────────────────────────────────────────────────────────────

  /// Deactivate a tenant (Core A required for sovereignty safety).
  public func deactivate(
    tenant  : T.TenantRecord,
    lawPass : T.LawPass,
    reason  : Text
  ) : { #ok : T.TenantRecord; #err : Text } {
    if (not LE.coreAAuthority(lawPass)) {
      return #err("Gate A closed — deactivation denied");
    };
    #ok({
      tenant with
      active   = false;
      evidence = Array.append(tenant.evidence, ["deactivated:" # reason]);
    })
  };

}
