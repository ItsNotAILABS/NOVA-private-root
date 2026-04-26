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
// AEGIS SHIELD — Infrastructure Defense Canister
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// 10-tier threat classification system with autonomous shield regeneration.
// φ-scaled threat scoring and real-time integrity monitoring.

import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Text  "mo:base/Text";

persistent actor AegisShield {

  // ── Section 1: Sovereign Identity ────────────────────────────────────────────

  transient let CANISTER_ID : Text  = "aegis_shield";
  transient let PHI         : Float = 1.6180339887498948482;

  // ── Section 2: Types ─────────────────────────────────────────────────────────

  type ThreatLevel = {
    tier  : Nat;
    name  : Text;
    score : Float;
  };

  // ── Section 3: Stable State ───────────────────────────────────────────────────

  stable var activeThreat      : Nat   = 0;
  stable var totalThreatsBlocked: Nat  = 0;
  stable var shieldIntegrity   : Float = 1.0;
  stable var tick              : Nat   = 0;

  // ── Section 4: Threat Classification ─────────────────────────────────────────

  func _classifyTier(score : Float) : Nat {
    if (score < 0.1) return 0;
    if (score < 0.2) return 1;
    if (score < 0.3) return 2;
    if (score < 0.4) return 3;
    if (score < 0.5) return 4;
    if (score < 0.6) return 5;
    if (score < 0.7) return 6;
    if (score < 0.8) return 7;
    if (score < 0.9) return 8;
    9
  };

  func _tierName(tier : Nat) : Text {
    if (tier == 0) return "GHOST";
    if (tier == 1) return "TRACE";
    if (tier == 2) return "PROBE";
    if (tier == 3) return "SCOUT";
    if (tier == 4) return "THREAT";
    if (tier == 5) return "ASSAULT";
    if (tier == 6) return "BREACH";
    if (tier == 7) return "CRITICAL";
    if (tier == 8) return "SIEGE";
    "EXTINCTION"
  };

  // ── Section 5: Public Update Functions ───────────────────────────────────────

  public func ingestThreat(score : Float) : async Nat {
    let tier = _classifyTier(score);
    activeThreat := tier;
    totalThreatsBlocked += 1;
    // Shield takes damage proportional to tier
    let damage = Float.fromInt(tier) * 0.01;
    let newIntegrity = shieldIntegrity - damage;
    shieldIntegrity := if (newIntegrity < 0.0) 0.0 else newIntegrity;
    tier
  };

  public func raiseShield() : async () {
    shieldIntegrity := 1.0;
  };

  // ── Section 6: Public Query Functions ────────────────────────────────────────

  public query func getThreatStatus() : async { tier : Nat; integrity : Float; blocked : Nat } {
    { tier = activeThreat; integrity = shieldIntegrity; blocked = totalThreatsBlocked }
  };

  public query func getAegisReport() : async Text {
    "AEGIS SHIELD REPORT — φ=" # Float.toText(PHI) # "\n" #
    "Canister: " # CANISTER_ID # " | Tick: " # Nat.toText(tick) # "\n" #
    "Active Threat Tier: " # Nat.toText(activeThreat) #
      " (" # _tierName(activeThreat) # ")\n" #
    "Shield Integrity: " # Float.toText(shieldIntegrity) # "\n" #
    "Total Threats Blocked: " # Nat.toText(totalThreatsBlocked) # "\n"
  };

  // ── Section 7: System Heartbeat ──────────────────────────────────────────────

  system func heartbeat() : async () {
    tick += 1;
    // Slow shield regeneration
    if (shieldIntegrity < 1.0) {
      let regen = shieldIntegrity + 0.01;
      shieldIntegrity := if (regen > 1.0) 1.0 else regen;
    };
  };

};
