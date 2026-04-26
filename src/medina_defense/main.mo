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
// MEDINA DEFENSE — Biologically-Accurate Fear Circuit Canister
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// Models the Amygdala fear circuit with three nuclei:
//   LA  — Lateral Amygdala (sensory input gate)
//   BA  — Basal Amygdala   (contextual integration)
//   CeA — Central Amygdala (fear output / behavioral response)
// Prefrontal suppression via suppressFear(). Passive decay on heartbeat.

import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Text  "mo:base/Text";

persistent actor MedinaDefense {

  // ── Section 1: Sovereign Identity ────────────────────────────────────────────

  transient let CANISTER_ID : Text  = "medina_defense";
  transient let PHI         : Float = 1.6180339887498948482;

  // ── Section 2: Stable State ───────────────────────────────────────────────────

  stable var laActivation    : Float = 0.0;
  stable var baActivation    : Float = 0.0;
  stable var ceaActivation   : Float = 0.0;
  stable var fearResponse    : Float = 0.0;
  stable var threatsProcessed: Nat   = 0;
  stable var tick            : Nat   = 0;

  // ── Section 3: Threat Processing ─────────────────────────────────────────────

  public func ingestSensoryThreat(intensity : Float) : async () {
    // LA receives input
    laActivation := laActivation + intensity * 0.618;
    // BA integrates contextual signal
    baActivation := (baActivation + laActivation) / 2.0;
    // CeA triggers behavioral fear response
    ceaActivation := baActivation * PHI;
    fearResponse  := ceaActivation;
    threatsProcessed += 1;
  };

  // Prefrontal cortex override — suppresses fear circuit
  public func suppressFear() : async () {
    laActivation  := laActivation  * 0.382;
    baActivation  := baActivation  * 0.382;
    ceaActivation := ceaActivation * 0.382;
    fearResponse  := fearResponse  * 0.382;
  };

  // ── Section 4: Query Interface ────────────────────────────────────────────────

  public query func getFearState() : async { la : Float; ba : Float; cea : Float; fear : Float; processed : Nat } {
    {
      la        = laActivation;
      ba        = baActivation;
      cea       = ceaActivation;
      fear      = fearResponse;
      processed = threatsProcessed;
    }
  };

  public query func getMedinaReport() : async Text {
    "MEDINA DEFENSE REPORT — φ=" # Float.toText(PHI) # "\n" #
    "Canister: " # CANISTER_ID # " | Tick: " # Nat.toText(tick) # "\n" #
    "Amygdala Nuclei:\n" #
    "  LA  (Lateral):  " # Float.toText(laActivation)  # "\n" #
    "  BA  (Basal):    " # Float.toText(baActivation)   # "\n" #
    "  CeA (Central):  " # Float.toText(ceaActivation)  # "\n" #
    "Fear Response:    " # Float.toText(fearResponse)   # "\n" #
    "Threats Processed: " # Nat.toText(threatsProcessed) # "\n"
  };

  // ── Section 5: System Heartbeat ──────────────────────────────────────────────

  system func heartbeat() : async () {
    tick += 1;
    // Passive decay: fear signals dissipate over time
    laActivation  := laActivation  * 0.99;
    baActivation  := baActivation  * 0.99;
    ceaActivation := ceaActivation * 0.99;
  };

};
