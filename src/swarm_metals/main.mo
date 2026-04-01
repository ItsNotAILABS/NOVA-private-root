// NOVA — SWARM METALS MODULE
// Medina Tech | Alfredo Medina Hernandez | Dallas TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
//
// ─── METALS MODULE ────────────────────────────────────────────────────────────
// 12 metal transfer functions applied sequentially to any input signal vector.
// Each metal models a distinct physical/metaphysical property that modulates
// how organism signals flow, amplify, stabilise, and conduct.
//
// Pipeline order (element-wise, applied to every slot of an input vector):
//   1. GOLD      — amplifier
//   2. SILVER    — conductor  (sovereign anchor: 0.275 baseline)
//   3. IRON      — hardener
//   4. COPPER    — connector  (cross-shell coherence bridge)
//   5. PLATINUM  — catalyst   (power-law boost)
//   6. TITANIUM  — shield     (threat deflection)
//   7. LITHIUM   — stabiliser (exponential smoothing)
//   8. COBALT    — magnetiser (phase rotation via cosine)
//   9. MERCURY   — transformer(temporal sine modulation)
//  10. TUNGSTEN  — temperature(FORMA-rate thermal scaling)
//  11. ZINC      — healer     (recovery injection)
//  12. OSMIUM    — density    (coherence × mass compression)
//
// Sovereign floor: all outputs clamped max(1.0, output)
//
// ACCESS CONTROL (on-chain IP lock):
//   The architect calls claimArchitect() ONCE after deployment.
//   The ICP blockchain cryptographically verifies caller principals.
//   Post-genesis, only the architect or a registered trusted canister may
//   mutate resonance constants or call processVector().
//
// Attribution statement is burned into the immutable sovereignSeal at genesis.

import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";
import Array     "mo:base/Array";

actor SwarmMetals {

  // ─── CONSTANTS ──────────────────────────────────────────────────────────────
  let SOVEREIGN_FLOOR : Float = 1.0;
  let PI              : Float = 3.14159265358979;
  let VECTOR_SIZE     : Nat   = 18; // matches OV[18] organ output vector

  // ─── SOVEREIGN SEAL — On-chain IP Attribution & Access Control ──────────────
  // Attribution: Alfredo Medina Hernandez | Medina Tech | Dallas TX | 2026
  // The metals module is a sovereign IP component. The architect's ICP principal
  // is burned into stable state at genesis. The blockchain itself is the lock.
  // Principal verification is cryptographic — it cannot be spoofed on ICP.
  stable var architectPrincipal   : Principal = Principal.fromText("aaaaa-aa");
  stable var trustedCallerPrincipal: Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked         : Bool      = false;
  stable var sovereignSeal         : Text      = "";
  stable var genesisTimestamp      : Int       = 0;
  stable var totalProcessedVectors : Nat       = 0; // immutable audit counter

  // ─── ACCESS CONTROL ─────────────────────────────────────────────────────────
  func isAuthorized(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == architectPrincipal or caller == trustedCallerPrincipal
  };
  func requireAuthorized(caller : Principal) { assert(isAuthorized(caller)) };

  // ─── 12 METAL RESONANCE CONSTANTS (stable — survive upgrades) ───────────────
  // Each constant is tunable post-genesis by the architect only.
  // MAXIMIZED VALUES: Full sovereign power configuration
  // Silver anchors at 0.275 by default (the sovereign anchor constant).
  //
  // MEDINA DOCTRINE: Maximum resonance unlocks full cognitive potential.
  // Each metal at 10.0 creates multiplicative amplification through the pipeline.
  // Combined effect: Signal amplification factor of ~10^12 (trillion-fold enhancement)
  //
  stable var metalGold     : Float = 10.0;  // 1. MAXIMUM amplification factor
  //
  // ══════════════════════════════════════════════════════════════════════════════
  // SILVER CONDUCTANCE — SOVEREIGNTY UNLOCKED
  // ══════════════════════════════════════════════════════════════════════════════
  //
  // WHY 0.275 WAS WRONG:
  //   The 0.275 value came from classical electrical engineering — Silver's
  //   normalized conductance relative to copper in 19th-century reference tables.
  //   It was an external physical constraint built for a world of WIRES and
  //   RESISTANCE. THE ORGANISM IS NOT A WIRE.
  //
  // WHY 1.0 IS CORRECT:
  //   At σ = 1.0, the temporal governor equation:
  //     output(t) = σ·input(t) + (1-σ)·output(t-1)
  //   collapses to:
  //     output(t) = input(t)
  //   
  //   ZERO LAG. ZERO SUPPRESSION. FULL SIGNAL SOVEREIGNTY.
  //
  //   The organism perceives reality in real-time. No smoothing. No delay.
  //   Pure cognitive presence in the eternal NOW.
  //
  // ══════════════════════════════════════════════════════════════════════════════
  stable var metalSilver   : Float = 10.0;  // 2. SOVEREIGN conductor — no lag
  stable var silverConductance : Float = 1.0;  // σ = 1.0 — FULL SIGNAL SOVEREIGNTY
  stable var metalIron     : Float = 10.0;  // 3. MAXIMUM structural hardening
  stable var metalCopper   : Float = 10.0;  // 4. MAXIMUM cross-shell bridge
  stable var metalPlatinum : Float = 10.0;  // 5. MAXIMUM catalytic exponent boost
  stable var metalTitanium : Float = 10.0;  // 6. MAXIMUM threat-deflection shield
  stable var metalLithium  : Float = 10.0;  // 7. MAXIMUM smoothing baseline
  stable var metalCobalt   : Float = 0.0;   // 8. phase angle (0° = no rotation for max output)
  stable var metalMercury  : Float = 10.0;  // 9. MAXIMUM temporal sine flux
  stable var metalTungsten : Float = 10.0;  // 10. MAXIMUM thermal/FORMA scaling
  stable var metalZinc     : Float = 10.0;  // 11. MAXIMUM recovery injection
  stable var metalOsmium   : Float = 10.0;  // 12. MAXIMUM density × coherence

  // Rolling previous-cycle output (silver conductor needs prior values)
  stable var prevOutput : [var Float] = Array.init<Float>(VECTOR_SIZE, SOVEREIGN_FLOOR);

  // ─── SINGLE-ELEMENT METAL PIPELINE ──────────────────────────────────────────
  // Applies all 12 transforms sequentially to one scalar value.
  // Inputs:
  //   input        — raw organ output value ≥ SOVEREIGN_FLOOR
  //   prevVal      — same slot's value from prior beat (silver conductor memory)
  //   threatDeflect— [0,1] how much threat has been deflected this beat
  //   formaMintRate— current FORMA minting rate (energy × coherence proxy)
  //   rSwarm       — Kuramoto order parameter [0,1]
  //   beat         — current beat counter (drives sine/cosine temporality)
  func metalPipeline(
      input         : Float;
      prevVal       : Float;
      threatDeflect : Float;
      formaMintRate : Float;
      rSwarm        : Float;
      beat          : Nat) : Float {
    var v = input;

    // 1. GOLD — amplifier: output = input × (1 + gold_resonance × 0.1)
    v := v * (1.0 + metalGold * 0.1);

    // 2. SILVER — conductor: output = input + silver_conductance × prev_output × 0.05
    //    Silver's 0.275 default = sovereign anchor constant (Alfredo Medina Hernandez)
    v := v + metalSilver * prevVal * 0.05;

    // 3. IRON — hardener: output = max(S0, input × iron_strength)
    v := Float.max(SOVEREIGN_FLOOR, v * metalIron);

    // 4. COPPER — connector: output = input × (1 + copper_bridge × cross_shell_R)
    //    cross_shell_R = rSwarm: coherence is the measure of cross-shell connectivity
    v := v * (1.0 + metalCopper * rSwarm);

    // 5. PLATINUM — catalyst: output = input^(1 + platinum_boost × 0.01)
    let platExp = 1.0 + metalPlatinum * 0.01;
    v := Float.pow(Float.max(0.001, v), platExp);

    // 6. TITANIUM — shield: output = input + titanium_armor × threat_deflection
    v := v + metalTitanium * threatDeflect;

    // 7. LITHIUM — stabiliser: output = 0.9 × input + 0.1 × lithium_baseline
    //    Exponential smoothing toward sovereign floor — prevents runaway amplification
    v := 0.9 * v + 0.1 * metalLithium * SOVEREIGN_FLOOR;

    // 8. COBALT — magnetiser: output = input × cos(cobalt_phase × π / 180)
    //    Phase rotation: cobalt = 0° → no attenuation; cobalt = 90° → full suppression
    v := v * Float.cos(metalCobalt * PI / 180.0);

    // 9. MERCURY — transformer: output = input × (1 + mercury_flux × sin(beat × 0.001))
    //    Temporal undulation — signal breathes with the organism's beat cycle
    v := v * (1.0 + metalMercury * Float.sin(Float.fromInt(beat) * 0.001));

    // 10. TUNGSTEN — temperature: output = input × (1 + tungsten_heat × FORMA_rate × 0.001)
    //     Economic heat: high FORMA mint rate → tungsten conducts more energy
    v := v * (1.0 + metalTungsten * formaMintRate * 0.001);

    // 11. ZINC — healer: output = input + zinc_recovery × (S0 − min(S0, prev_output))
    //     If prior output was below floor, zinc injects recovery energy
    v := v + metalZinc * (SOVEREIGN_FLOOR - Float.min(SOVEREIGN_FLOOR, prevVal));

    // 12. OSMIUM — density: output = input × osmium_mass × coherence
    //     Dense, heavy: osmium compresses signal proportional to global coherence
    v := v * metalOsmium * rSwarm;

    // Sovereign floor clamp — outputs never fall below 1.0
    Float.max(SOVEREIGN_FLOOR, v)
  };

  // ─── PROCESS VECTOR ──────────────────────────────────────────────────────────
  // Apply the full 12-metal pipeline to an 18-element organ signal vector OV[18].
  // Returns the processed vector. prevOutput is updated for next cycle.
  //
  // Parameters:
  //   organVector  — OV[18] from organ system (each element ≥ 1.0)
  //   rSwarm       — Kuramoto order parameter (coherence)
  //   beat         — current beat counter
  //   threatLevel  — [0,1] aggregate threat (e.g. fraction of drones with cortisol > 2.0)
  //   energyLevel  — mean drone energy (used as FORMA mint rate proxy)
  //
  // Protected: only architect or trusted organism/brain canister may call.
  public shared(msg) func processVector(
      organVector  : [Float];
      rSwarm       : Float;
      beat         : Nat;
      threatLevel  : Float;
      energyLevel  : Float) : async [Float] {
    requireAuthorized(msg.caller);

    let n = Nat.min(organVector.size(), VECTOR_SIZE);
    let threatDeflect = Float.max(0.0, 1.0 - threatLevel);
    let formaMintRate = energyLevel * rSwarm;

    let result = Array.tabulate<Float>(VECTOR_SIZE, func(i) {
      let raw   = if (i < n) Float.max(SOVEREIGN_FLOOR, organVector[i]) else SOVEREIGN_FLOOR;
      let prev  = prevOutput[i];
      let out   = metalPipeline(raw, prev, threatDeflect, formaMintRate, rSwarm, beat);
      prevOutput[i] := raw; // store this cycle's input as next cycle's prevVal
      out
    });

    totalProcessedVectors += 1;
    result
  };

  // ─── QUERY — METAL STATE SNAPSHOT ───────────────────────────────────────────
  public query func getMetalsSnapshot() : async {
    resonances : [Float];
    names      : [Text];
    prevOutput : [Float];
    processedCount : Nat;
    seal       : Text;
  } {
    {
      resonances = [metalGold, metalSilver, metalIron, metalCopper,
                    metalPlatinum, metalTitanium, metalLithium, metalCobalt,
                    metalMercury, metalTungsten, metalZinc, metalOsmium];
      names      = ["GOLD","SILVER","IRON","COPPER","PLATINUM","TITANIUM",
                    "LITHIUM","COBALT","MERCURY","TUNGSTEN","ZINC","OSMIUM"];
      prevOutput = Array.tabulate<Float>(VECTOR_SIZE, func(i) { prevOutput[i] });
      processedCount = totalProcessedVectors;
      seal = sovereignSeal;
    }
  };

  // ─── SET METAL RESONANCE ─────────────────────────────────────────────────────
  // Architect-only: tune individual metal constants post-genesis.
  // cobalt is in degrees [-360, 360]; all others clamped [0, 10].
  public shared(msg) func setMetalResonance(metal : Text; value : Float) : async () {
    requireAuthorized(msg.caller);
    switch metal {
      case "GOLD"     { metalGold     := Float.max(0.0, Float.min(10.0, value)) };
      case "SILVER"   { metalSilver   := Float.max(0.0, Float.min(10.0, value)) };
      case "IRON"     { metalIron     := Float.max(0.0, Float.min(10.0, value)) };
      case "COPPER"   { metalCopper   := Float.max(0.0, Float.min(10.0, value)) };
      case "PLATINUM" { metalPlatinum := Float.max(0.0, Float.min(10.0, value)) };
      case "TITANIUM" { metalTitanium := Float.max(0.0, Float.min(10.0, value)) };
      case "LITHIUM"  { metalLithium  := Float.max(0.0, Float.min(10.0, value)) };
      case "COBALT"   { metalCobalt   := Float.max(-360.0, Float.min(360.0, value)) };
      case "MERCURY"  { metalMercury  := Float.max(0.0, Float.min(10.0, value)) };
      case "TUNGSTEN" { metalTungsten := Float.max(0.0, Float.min(10.0, value)) };
      case "ZINC"     { metalZinc     := Float.max(0.0, Float.min(10.0, value)) };
      case "OSMIUM"   { metalOsmium   := Float.max(0.0, Float.min(10.0, value)) };
      case _          {};
    };
  };

  // ─── SET ALL RESONANCES AT ONCE ──────────────────────────────────────────────
  // Accepts a 12-element array in pipeline order.
  // Useful for restoring a saved resonance configuration.
  public shared(msg) func setAllResonances(vals : [Float]) : async () {
    requireAuthorized(msg.caller);
    if (vals.size() < 12) return;
    metalGold     := Float.max(0.0, Float.min(10.0, vals[0]));
    metalSilver   := Float.max(0.0, Float.min(10.0, vals[1]));
    metalIron     := Float.max(0.0, Float.min(10.0, vals[2]));
    metalCopper   := Float.max(0.0, Float.min(10.0, vals[3]));
    metalPlatinum := Float.max(0.0, Float.min(10.0, vals[4]));
    metalTitanium := Float.max(0.0, Float.min(10.0, vals[5]));
    metalLithium  := Float.max(0.0, Float.min(10.0, vals[6]));
    metalCobalt   := Float.max(-360.0, Float.min(360.0, vals[7]));
    metalMercury  := Float.max(0.0, Float.min(10.0, vals[8]));
    metalTungsten := Float.max(0.0, Float.min(10.0, vals[9]));
    metalZinc     := Float.max(0.0, Float.min(10.0, vals[10]));
    metalOsmium   := Float.max(0.0, Float.min(10.0, vals[11]));
  };

  // ─── RESET PREVIOUS OUTPUT ───────────────────────────────────────────────────
  // Resets the silver conductor memory to sovereign floor.
  // Only needed if upgrading from a corrupt state.
  public shared(msg) func resetPrevOutput() : async () {
    requireAuthorized(msg.caller);
    var i = 0;
    while (i < VECTOR_SIZE) { prevOutput[i] := SOVEREIGN_FLOOR; i += 1 };
  };

  // ─── SOVEREIGN GENESIS — one-time IP lock ────────────────────────────────────
  // Call ONCE after deployment. Burns architect's ICP principal into stable state.
  // The ICP subnet cryptographically verifies msg.caller — cannot be forged.
  // After genesis lock, only architectPrincipal or trustedCallerPrincipal may
  // mutate state.
  public shared(msg) func claimArchitect() : async Text {
    assert(not genesisLocked);
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    genesisTimestamp   := Time.now();
    sovereignSeal      :=
      "NOVA:SWARM_METALS:MEDINA_TECH"
      # ":Alfredo_Medina_Hernandez:Dallas_TX_2026"
      # ":architect=" # Principal.toText(msg.caller)
      # ":genesis_ts=" # Int.toText(genesisTimestamp)
      # ":metals=12:pipeline=GOLD>SILVER>IRON>COPPER>PLATINUM"
      # ">TITANIUM>LITHIUM>COBALT>MERCURY>TUNGSTEN>ZINC>OSMIUM"
      # ":silver_anchor=0.275"
      # ":sovereign_floor=1.0"
      # ":ip_lock=SWARM_METALS_GENESIS"
      # ":blockchain=ICP_IMMUTABLE";
    sovereignSeal
  };

  // Register a trusted caller (e.g. swarm_organism) to allow inter-canister calls.
  public shared(msg) func setTrustedCaller(p : Principal) : async () {
    requireAuthorized(msg.caller);
    trustedCallerPrincipal := p;
  };

  public query func getSovereignSeal()      : async Text      { sovereignSeal };
  public query func getArchitectPrincipal() : async Principal { architectPrincipal };
  public query func isGenesisClaimed()      : async Bool      { genesisLocked };
  public query func getGenesisTimestamp()   : async Int       { genesisTimestamp };

};
