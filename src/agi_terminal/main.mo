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

// NATIVE NOVA PROTOCOL — BUILD №32
// AGI TERMINAL — Sovereign Pulse Canister — 873ms System Timer
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// The AGI Terminal is the heartbeat of the organism.
// It fires every NOVA heartbeat tick (873ms) via the system heartbeat.
// Every 50 ticks (~43 s) it calls organism_solver.solverTick(), driving the
// autonomous job queue without any human input.
//
// getSystemStatus() provides the HEART snapshot that SYN imprints locally:
//   booted, tick, neurons, stake, maturity, voteWeight,
//   parallaxTreasury, onesicans, circulating, spawnedNeurons
//
// After synBindHeart() runs once, the solver holds the heart of the brain
// in its own stable memory. Zero future cross-canister calls needed.

import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

persistent actor AgiTerminal {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  var genesisLocked      : Bool      = false;
  var sovereignSeal      : Text      = "";
  var deployTimestamp    : Int       = 0;
  var booted             : Bool      = false;

  // Registered organism_solver — receives solverTick() every 50 system ticks
  var solverPrincipal  : Principal = Principal.fromText("aaaaa-aa");
  var solverRegistered : Bool      = false;

  func _isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "AGI_TERMINAL_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-AGI-TERMINAL-BUILD32-" # Principal.toText(msg.caller);
    deployTimestamp    := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal() : async Text { sovereignSeal };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  // The HEART snapshot — imprinted into organism_solver stable memory via SYN
  type SystemStatus = {
    booted           : Bool;
    tick             : Nat;
    neurons          : Nat;
    stake            : Nat;     // total staked ICP (e8s)
    maturity         : Nat;     // pending maturity (e8s)
    voteWeight       : Float;   // total voting power
    parallaxTreasury : Nat;     // treasury ICP (e8s)
    onesicans        : Nat;     // ONESICAN inventory
    circulating      : Nat;     // OnesICANs in circulation
    spawnedNeurons   : Nat;     // neurons spawned by C_HARVEST
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — SYSTEM STATE
  // ═══════════════════════════════════════════════════════════════════════════

  var tick             : Nat   = 0;
  var neurons          : Nat   = 200;
  var stake            : Nat   = 0;
  var maturity         : Nat   = 0;
  var voteWeight       : Float = 0.0;
  var parallaxTreasury : Nat   = 0;
  var onesicans        : Nat   = 0;
  var circulating      : Nat   = 0;
  var spawnedNeurons   : Nat   = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — GOLDEN MATH
  // ═══════════════════════════════════════════════════════════════════════════

  transient let PHI_INV : Float = 0.6180339887498948482;

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp == 0.0) 1.0 else 0.0 }
    else Float.exp(exp * Float.log(base))
  };

  func _calcVoteWeight(stakeE8s : Nat) : Float {
    Float.fromInt(stakeE8s) / 1.0e8 * 1.5
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — SOLVER REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func registerSolver(p : Principal) : async { ok : Bool; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; message = "UNAUTHORIZED" };
    solverPrincipal  := p;
    solverRegistered := true;
    { ok = true; message = "SOLVER_REGISTERED: " # Principal.toText(p) }
  };

  public query func getSolverPrincipal() : async Text { Principal.toText(solverPrincipal) };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — BOOT
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func boot(
    initialStake     : Nat,
    initialNeurons   : Nat,
    initialOnesicans : Nat
  ) : async { ok : Bool; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; message = "UNAUTHORIZED" };
    if (booted) return { ok = false; message = "ALREADY_BOOTED" };
    stake      := initialStake;
    neurons    := if (initialNeurons > 0) initialNeurons else 200;
    onesicans  := initialOnesicans;
    voteWeight := _calcVoteWeight(initialStake);
    booted     := true;
    { ok = true; message = "AGI_TERMINAL_BOOTED. Heartbeat active. Solver triggers every 50 ticks." }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — SYSTEM HEARTBEAT (ICP fires every consensus round)
  //
  //   Target: 873ms. Actual: ~1-2s (ICP consensus round speed).
  //   Every tick: maturity accrues, VP updates, ONESICAN emission.
  //   Every 50 ticks (~43 s): organism_solver.solverTick() fires autonomously.
  //   Nothing calls this. The ICP network calls it. Always on.
  // ═══════════════════════════════════════════════════════════════════════════

  // 12% APY on NNS neurons modeled at ~2s/tick:
  //   0.12 / 365 / 43200 ≈ 7.6e-9 per e8s per tick
  transient let BASE_MAT_PER_E8S : Float = 7.6e-9;

  system func heartbeat() : async () {
    tick := tick + 1;

    // ── Maturity accrual ──────────────────────────────────────────────────────
    if (stake > 0) {
      let mat = _floatToNat(Float.fromInt(stake) * BASE_MAT_PER_E8S);
      maturity := maturity + mat;
      // Group D (27.5%) disburses: φ⁻³ (9%) fraction to treasury
      let dMat = _floatToNat(Float.fromInt(mat) * 0.275);
      parallaxTreasury := parallaxTreasury + _floatToNat(Float.fromInt(dMat) * _pow(PHI_INV, 3.0));
      // Group C (SPAWN) — new neuron every 89 ticks when maturity is sufficient
      if (mat > 1_000_000 and Nat.rem(tick, 89) == 0) {
        spawnedNeurons := spawnedNeurons + 1;
        neurons        := neurons + 1;
        stake          := stake + _floatToNat(Float.fromInt(mat) * 0.275);
      };
    };

    // ── Voting power update ───────────────────────────────────────────────────
    voteWeight := _calcVoteWeight(stake);

    // ── ONESICAN emission (every 13 ticks from treasury surplus) ─────────────
    if (parallaxTreasury > 100_000_000 and Nat.rem(tick, 13) == 0) {
      let newOnes  = parallaxTreasury / 100_000_000;
      onesicans   := onesicans   + newOnes;
      circulating := circulating + newOnes;
    };

    // ── Every 50 ticks: trigger organism_solver.solverTick() ─────────────────
    if (Nat.rem(tick, 50) == 0 and solverRegistered) {
      let solver : actor { solverTick : () -> async () } =
        actor(Principal.toText(solverPrincipal));
      await solver.solverTick();
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — PUBLIC STATUS API
  // ═══════════════════════════════════════════════════════════════════════════

  // getSystemStatus — the HEART snapshot queried by SYN once and imprinted forever
  public query func getSystemStatus() : async SystemStatus {
    {
      booted;
      tick;
      neurons;
      stake;
      maturity;
      voteWeight;
      parallaxTreasury;
      onesicans;
      circulating;
      spawnedNeurons;
    }
  };

  // Sovereign manual state update — seed from real NNS data
  public shared(msg) func updateState(
    newStake    : Nat,
    newMaturity : Nat,
    newNeurons  : Nat
  ) : async { ok : Bool } {
    if (not _isSovereign(msg.caller)) return { ok = false };
    stake      := newStake;
    maturity   := newMaturity;
    neurons    := newNeurons;
    voteWeight := _calcVoteWeight(newStake);
    { ok = true }
  };

  // Generic SYN data export — lets organism_solver bind generic data from this canister
  public query func synDataExport(key : Text) : async Text {
    if (key == "status") {
      "booted=" # (if booted "1" else "0") # "|" #
      "tick=" # Nat.toText(tick) # "|" #
      "neurons=" # Nat.toText(neurons) # "|" #
      "stake=" # Nat.toText(stake) # "|" #
      "treasury=" # Nat.toText(parallaxTreasury)
    } else {
      "AGI_TERMINAL:" # key # "=unsupported"
    }
  };

  public query func getTerminalReport() : async Text {
    "AGI TERMINAL REPORT — BUILD №32\n" #
    "Seal: " # sovereignSeal # "\n" #
    "Tick: "          # Nat.toText(tick)            # " | Booted: " # (if booted "YES" else "NO") # "\n" #
    "Neurons: "       # Nat.toText(neurons)          # " | Spawned: " # Nat.toText(spawnedNeurons) # "\n" #
    "Stake: "         # Nat.toText(stake)             # " e8s\n" #
    "Vote Weight: "   # Float.toText(voteWeight)      # " VP\n" #
    "Maturity: "      # Nat.toText(maturity)           # " e8s\n" #
    "Treasury: "      # Nat.toText(parallaxTreasury)  # " e8s\n" #
    "ONESICANS: "     # Nat.toText(onesicans)         # " | Circulating: " # Nat.toText(circulating) # "\n" #
    "Solver: " # (if solverRegistered "REGISTERED → " # Principal.toText(solverPrincipal) else "NOT REGISTERED")
  };

}
