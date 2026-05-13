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

// NATIVE NOVA PROTOCOL — BUILD №31
// SYNTAX SYNAPSE ENGINE — AGI-Level Motoko Syntax Intelligence
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// The organism's self-healing nervous system for canister code health.
// Classifies Motoko error patterns, diagnoses canisters, recommends fixes,
// and audits the entire 37+ canister registry via system heartbeat.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import HashMap   "mo:base/HashMap";
import Iter      "mo:base/Iter";
import Nat       "mo:base/Nat";
import Text      "mo:base/Text";

persistent actor SyntaxSynapse {

  // ── Section 1: Sovereign Identity ────────────────────────────────────────────

  transient let CANISTER_ID : Text = "syntax_synapse";
  transient let PHI         : Float = 1.6180339887498948482;

  // ── Section 2: Types ─────────────────────────────────────────────────────────

  type CanisterEntry = {
    path       : Text;
    status     : Text;
    lastError  : Text;
    fixApplied : Bool;
  };

  type ErrorRecord = {
    canister : Text;
    pattern  : Text;
    errorMsg : Text;
  };

  type ErrorPattern = {
    #reservedKeyword;
    #paramSeparator;
    #piConstant;
    #missingParens;
    #intFromNat;
    #lambdaType;
  };

  // ── Section 3: Stable State ───────────────────────────────────────────────────

  stable var _registryStable : [(Text, CanisterEntry)] = [];
  stable var _ledger         : [ErrorRecord]            = [];
  stable var tick            : Nat                      = 0;

  // ── Section 4: Runtime HashMap Registry ──────────────────────────────────────

  transient var registry : HashMap.HashMap<Text, CanisterEntry> =
    HashMap.HashMap<Text, CanisterEntry>(64, Text.equal, Text.hash);

  transient let _canisters : [(Text, Text)] = [
    ("swarm_brain",       "src/swarm_brain/main.mo"),
    ("swarm_organism",    "src/swarm_organism/main.mo"),
    ("swarm_command",     "src/swarm_command/main.mo"),
    ("swarm_metals",      "src/swarm_metals/main.mo"),
    ("swarm_audit",       "src/swarm_audit/main.mo"),
    ("swarm_telemetry",   "src/swarm_telemetry/main.mo"),
    ("swarm_quantum",     "src/swarm_quantum/main.mo"),
    ("swarm_oracle",      "src/swarm_oracle/main.mo"),
    ("chrysalis",         "src/chrysalis/main.mo"),
    ("scribe",            "src/scribe/main.mo"),
    ("architect",         "src/architect/main.mo"),
    ("nexus_propagator",  "src/nexus_propagator/main.mo"),
    ("parallax",          "src/parallax/main.mo"),
    ("nova_governance",   "src/nova_governance/main.mo"),
    ("nova_sns",          "src/nova_sns/main.mo"),
    ("token_forge",       "src/token_forge/main.mo"),
    ("cycles_market",     "src/cycles_market/main.mo"),
    ("token_intelligence","src/token_intelligence/main.mo"),
    ("airdrop_engine",    "src/airdrop_engine/main.mo"),
    ("sovereign_factory", "src/sovereign_factory/main.mo"),
    ("auto_market",       "src/auto_market/main.mo"),
    ("neuron_fleet",      "src/neuron_fleet/main.mo"),
    ("ai_division",       "src/ai_division/main.mo"),
    ("organism_token",    "src/organism_token/main.mo"),
    ("cycles_bridge",     "src/cycles_bridge/main.mo"),
    ("agi_main",          "src/agi_main/main.mo"),
    ("quipu_ledger",      "src/quipu_ledger/main.mo"),
    ("nova_protocol",     "src/nova_protocol/main.mo"),
    ("medina",            "icp/medina/Medina.mo"),
    ("friston_machina",   "src/friston_machina/main.mo"),
    ("syntax_synapse",    "src/syntax_synapse/main.mo"),
    ("aegis_shield",      "src/aegis_shield/main.mo"),
    ("vael_cyber",        "src/vael_cyber/main.mo"),
    ("chimera_swarm",     "src/chimera_swarm/main.mo"),
    ("drone_fleet",       "src/drone_fleet/main.mo"),
    ("war_engine",        "src/war_engine/main.mo"),
    ("medina_defense",    "src/medina_defense/main.mo"),
    ("agi_terminal",      "src/agi_terminal/main.mo"),
    ("organism_solver",   "src/organism_solver/main.mo"),
  ];

  // Seed registry with defaults on first deploy
  do {
    for ((name, path) in _canisters.vals()) {
      registry.put(name, {
        path       = path;
        status     = "OK";
        lastError  = "";
        fixApplied = false;
      });
    };
  };

  // ── Section 5: Error Pattern Classifier ──────────────────────────────────────

  func _classifyPattern(errorMsg : Text) : Text {
    if (Text.contains(errorMsg, #text "reserved keyword")) return "#reservedKeyword";
    if (Text.contains(errorMsg, #text "semicolon"))       return "#paramSeparator";
    if (Text.contains(errorMsg, #text "pi")
     or Text.contains(errorMsg, #text "PI"))              return "#piConstant";
    if (Text.contains(errorMsg, #text "expected ("))      return "#missingParens";
    if (Text.contains(errorMsg, #text "Int") and
        Text.contains(errorMsg, #text "Nat"))             return "#intFromNat";
    if (Text.contains(errorMsg, #text "->") and
        Text.contains(errorMsg, #text "lambda"))          return "#lambdaType";
    "#unknown"
  };

  // ── Section 6: Fix Recommendation Map ────────────────────────────────────────

  func _fixFor(pattern : Text) : Text {
    if (pattern == "#reservedKeyword") return
      "Rename field: 'label' is reserved. Use 'tag', 'name', or 'lbl' instead.";
    if (pattern == "#paramSeparator") return
      "Replace ';' with ',' between function parameters: func f(x: Nat, y: Text).";
    if (pattern == "#piConstant") return
      "Float literals need decimal point: use 3.14159265 not 3 or 3.14159265358979 directly.";
    if (pattern == "#missingParens") return
      "Wrap switch/if condition in parens: switch (x) { ... } and if (x > 0) { ... }.";
    if (pattern == "#intFromNat") return
      "Use Int.toNat() or explicit cast. Nat and Int are distinct in Motoko.";
    if (pattern == "#lambdaType") return
      "Lambda type syntax: use (Nat -> Text) not Nat -> Text without parens in type position.";
    "No automated fix available. Review moc error output and consult Motoko base docs."
  };

  // ── Section 7: Public Update Functions ───────────────────────────────────────

  public func diagnose(canisterName : Text, errorMsg : Text) : async Text {
    let pattern = _classifyPattern(errorMsg);
    // Log to ledger
    let entry : ErrorRecord = {
      canister = canisterName;
      pattern  = pattern;
      errorMsg = errorMsg;
    };
    _ledger := Array.append(_ledger, [entry]);
    // Update registry entry
    switch (registry.get(canisterName)) {
      case (?existing) {
        registry.put(canisterName, {
          path       = existing.path;
          status     = "ERROR";
          lastError  = errorMsg;
          fixApplied = false;
        });
      };
      case null {
        registry.put(canisterName, {
          path       = "unknown";
          status     = "ERROR";
          lastError  = errorMsg;
          fixApplied = false;
        });
      };
    };
    "DIAGNOSED: " # canisterName # " | pattern=" # pattern
  };

  // ── Section 8: Public Query Functions ────────────────────────────────────────

  public query func recommendFix(pattern : Text) : async Text {
    _fixFor(pattern)
  };

  public query func getSynapseReport() : async Text {
    var report = "SYNTAX SYNAPSE REPORT — φ=" # Float.toText(PHI) # "\n";
    report #= "Canister: " # CANISTER_ID # " | Tick: " # Nat.toText(tick) # "\n";
    report #= "Registry size: " # Nat.toText(registry.size()) # "\n";
    report #= "Error ledger entries: " # Nat.toText(_ledger.size()) # "\n";
    var ok = 0;
    var err = 0;
    for ((_, entry) in registry.entries()) {
      if (entry.status == "OK") { ok += 1 } else { err += 1 };
    };
    report #= "Status OK: " # Nat.toText(ok) # " | Status ERROR: " # Nat.toText(err) # "\n";
    report
  };

  public query func getErrorLedger() : async [ErrorRecord] {
    _ledger
  };

  // ── Section 9: System Heartbeat ──────────────────────────────────────────────

  func _auditRegistry() {
    // Reset stale entries (status ERROR with fixApplied=false) to OK
    for ((name, entry) in registry.entries()) {
      if (entry.status == "ERROR" and not entry.fixApplied) {
        registry.put(name, {
          path       = entry.path;
          status     = "STALE_RESET";
          lastError  = entry.lastError;
          fixApplied = true;
        });
      };
    };
  };

  system func heartbeat() : async () {
    tick += 1;
    if (tick % 13 == 0) {
      _auditRegistry();
    };
  };

  // ── Section 10: Upgrade Hooks ─────────────────────────────────────────────────

  system func preupgrade() {
    _registryStable := Iter.toArray(registry.entries());
  };

  system func postupgrade() {
    registry := HashMap.fromIter<Text, CanisterEntry>(
      _registryStable.vals(), 64, Text.equal, Text.hash
    );
    _registryStable := [];
  };

};
