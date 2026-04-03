// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// NOVA — METALS PIPELINE MODULE (Consolidated from swarm_metals)
// Medina Tech | Alfredo Medina Hernandez | Dallas TX | 2026
// Sovereign Cognitive Swarm Engine. All doctrine attributed herein.
//
// ─── METALS MODULE ────────────────────────────────────────────────────────────
// 12 metal transfer functions applied sequentially to any input signal vector.
// Each metal models a distinct physical/metaphysical property that modulates
// how organism signals flow, amplify, stabilise, and conduct.
//
// CONSOLIDATED: This was previously a separate canister (swarm_metals).
// Now a module within swarm_brain for 12 Hz heartbeat temporal coherence.

import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";
import Array     "mo:base/Array";

module {

  // ─── CONSTANTS ──────────────────────────────────────────────────────────────
  let SOVEREIGN_FLOOR : Float = 1.0;
  let PI              : Float = 3.14159265358979;
  let VECTOR_SIZE     : Nat   = 18;

  // ─── STATE CLASS ────────────────────────────────────────────────────────────
  
  public class MetalsState() {
    // Sovereign Seal — On-chain IP Attribution
    public var architectPrincipal   : Principal = Principal.fromText("aaaaa-aa");
    public var trustedCallerPrincipal: Principal = Principal.fromText("aaaaa-aa");
    public var genesisLocked         : Bool      = false;
    public var sovereignSeal         : Text      = "";
    public var genesisTimestamp      : Int       = 0;
    public var totalProcessedVectors : Nat       = 0;

    // 12 METAL RESONANCE CONSTANTS — MAXIMIZED VALUES
    public var metalGold     : Float = 10.0;
    public var metalSilver   : Float = 10.0;
    public var silverConductance : Float = 1.0;
    public var metalIron     : Float = 10.0;
    public var metalCopper   : Float = 10.0;
    public var metalPlatinum : Float = 10.0;
    public var metalTitanium : Float = 10.0;
    public var metalLithium  : Float = 10.0;
    public var metalCobalt   : Float = 0.0;
    public var metalMercury  : Float = 10.0;
    public var metalTungsten : Float = 10.0;
    public var metalZinc     : Float = 10.0;
    public var metalOsmium   : Float = 10.0;

    // Rolling previous-cycle output (silver conductor needs prior values)
    public var prevOutput : [var Float] = Array.init<Float>(VECTOR_SIZE, SOVEREIGN_FLOOR);
  };

  // ─── ACCESS CONTROL ─────────────────────────────────────────────────────────
  
  public func isAuthorized(state : MetalsState, caller : Principal) : Bool {
    if (not state.genesisLocked) return true;
    caller == state.architectPrincipal or caller == state.trustedCallerPrincipal
  };

  // ─── SINGLE-ELEMENT METAL PIPELINE ──────────────────────────────────────────
  
  func metalPipeline(
      state         : MetalsState,
      input         : Float,
      prevVal       : Float,
      threatDeflect : Float,
      formaMintRate : Float,
      rSwarm        : Float,
      beat          : Nat) : Float {
    var v = input;

    // 1. GOLD — amplifier
    v := v * (1.0 + state.metalGold * 0.1);

    // 2. SILVER — conductor
    v := v + state.metalSilver * prevVal * 0.05;

    // 3. IRON — hardener
    v := Float.max(SOVEREIGN_FLOOR, v * state.metalIron);

    // 4. COPPER — connector
    v := v * (1.0 + state.metalCopper * rSwarm);

    // 5. PLATINUM — catalyst
    let platExp = 1.0 + state.metalPlatinum * 0.01;
    v := Float.pow(Float.max(0.001, v), platExp);

    // 6. TITANIUM — shield
    v := v + state.metalTitanium * threatDeflect;

    // 7. LITHIUM — stabiliser
    v := 0.9 * v + 0.1 * state.metalLithium * SOVEREIGN_FLOOR;

    // 8. COBALT — magnetiser
    v := v * Float.cos(state.metalCobalt * PI / 180.0);

    // 9. MERCURY — transformer
    v := v * (1.0 + state.metalMercury * Float.sin(Float.fromInt(beat) * 0.001));

    // 10. TUNGSTEN — temperature
    v := v * (1.0 + state.metalTungsten * formaMintRate * 0.001);

    // 11. ZINC — healer
    v := v + state.metalZinc * (SOVEREIGN_FLOOR - Float.min(SOVEREIGN_FLOOR, prevVal));

    // 12. OSMIUM — density
    v := v * state.metalOsmium * rSwarm;

    // Sovereign floor clamp
    Float.max(SOVEREIGN_FLOOR, v)
  };

  // ─── PROCESS VECTOR — SYNC (no async!) ──────────────────────────────────────
  
  public func processVector(
      state        : MetalsState,
      organVector  : [Float],
      rSwarm       : Float,
      beat         : Nat,
      threatLevel  : Float,
      energyLevel  : Float) : [Float] {

    let n = Nat.min(organVector.size(), VECTOR_SIZE);
    let threatDeflect = Float.max(0.0, 1.0 - threatLevel);
    let formaMintRate = energyLevel * rSwarm;

    let result = Array.tabulate<Float>(VECTOR_SIZE, func(i) {
      let raw   = if (i < n) Float.max(SOVEREIGN_FLOOR, organVector[i]) else SOVEREIGN_FLOOR;
      let prev  = state.prevOutput[i];
      let out   = metalPipeline(state, raw, prev, threatDeflect, formaMintRate, rSwarm, beat);
      state.prevOutput[i] := raw;
      out
    });

    state.totalProcessedVectors += 1;
    result
  };

  // ─── QUERY — METAL STATE SNAPSHOT ───────────────────────────────────────────
  
  public func getMetalsSnapshot(state : MetalsState) : {
    resonances : [Float];
    names      : [Text];
    prevOutput : [Float];
    processedCount : Nat;
    seal       : Text;
  } {
    {
      resonances = [state.metalGold, state.metalSilver, state.metalIron, state.metalCopper,
                    state.metalPlatinum, state.metalTitanium, state.metalLithium, state.metalCobalt,
                    state.metalMercury, state.metalTungsten, state.metalZinc, state.metalOsmium];
      names      = ["GOLD","SILVER","IRON","COPPER","PLATINUM","TITANIUM",
                    "LITHIUM","COBALT","MERCURY","TUNGSTEN","ZINC","OSMIUM"];
      prevOutput = Array.tabulate<Float>(VECTOR_SIZE, func(i) { state.prevOutput[i] });
      processedCount = state.totalProcessedVectors;
      seal = state.sovereignSeal;
    }
  };

  // ─── SET METAL RESONANCE ─────────────────────────────────────────────────────
  
  public func setMetalResonance(state : MetalsState, metal : Text, value : Float) {
    switch metal {
      case "GOLD"     { state.metalGold     := Float.max(0.0, Float.min(10.0, value)) };
      case "SILVER"   { state.metalSilver   := Float.max(0.0, Float.min(10.0, value)) };
      case "IRON"     { state.metalIron     := Float.max(0.0, Float.min(10.0, value)) };
      case "COPPER"   { state.metalCopper   := Float.max(0.0, Float.min(10.0, value)) };
      case "PLATINUM" { state.metalPlatinum := Float.max(0.0, Float.min(10.0, value)) };
      case "TITANIUM" { state.metalTitanium := Float.max(0.0, Float.min(10.0, value)) };
      case "LITHIUM"  { state.metalLithium  := Float.max(0.0, Float.min(10.0, value)) };
      case "COBALT"   { state.metalCobalt   := Float.max(-360.0, Float.min(360.0, value)) };
      case "MERCURY"  { state.metalMercury  := Float.max(0.0, Float.min(10.0, value)) };
      case "TUNGSTEN" { state.metalTungsten := Float.max(0.0, Float.min(10.0, value)) };
      case "ZINC"     { state.metalZinc     := Float.max(0.0, Float.min(10.0, value)) };
      case "OSMIUM"   { state.metalOsmium   := Float.max(0.0, Float.min(10.0, value)) };
      case _          {};
    };
  };

  // ─── SET ALL RESONANCES AT ONCE ──────────────────────────────────────────────
  
  public func setAllResonances(state : MetalsState, vals : [Float]) {
    if (vals.size() < 12) return;
    state.metalGold     := Float.max(0.0, Float.min(10.0, vals[0]));
    state.metalSilver   := Float.max(0.0, Float.min(10.0, vals[1]));
    state.metalIron     := Float.max(0.0, Float.min(10.0, vals[2]));
    state.metalCopper   := Float.max(0.0, Float.min(10.0, vals[3]));
    state.metalPlatinum := Float.max(0.0, Float.min(10.0, vals[4]));
    state.metalTitanium := Float.max(0.0, Float.min(10.0, vals[5]));
    state.metalLithium  := Float.max(0.0, Float.min(10.0, vals[6]));
    state.metalCobalt   := Float.max(-360.0, Float.min(360.0, vals[7]));
    state.metalMercury  := Float.max(0.0, Float.min(10.0, vals[8]));
    state.metalTungsten := Float.max(0.0, Float.min(10.0, vals[9]));
    state.metalZinc     := Float.max(0.0, Float.min(10.0, vals[10]));
    state.metalOsmium   := Float.max(0.0, Float.min(10.0, vals[11]));
  };

  // ─── RESET PREVIOUS OUTPUT ───────────────────────────────────────────────────
  
  public func resetPrevOutput(state : MetalsState) {
    var i = 0;
    while (i < VECTOR_SIZE) { state.prevOutput[i] := SOVEREIGN_FLOOR; i += 1 };
  };

  // ─── SOVEREIGN GENESIS — one-time IP lock ────────────────────────────────────
  
  public func claimArchitect(state : MetalsState, caller : Principal) : Text {
    assert(not state.genesisLocked);
    state.architectPrincipal := caller;
    state.genesisLocked      := true;
    state.genesisTimestamp   := Time.now();
    state.sovereignSeal      :=
      "NOVA:METALS_PIPELINE:MEDINA_TECH"
      # ":Alfredo_Medina_Hernandez:Dallas_TX_2026"
      # ":architect=" # Principal.toText(caller)
      # ":genesis_ts=" # Int.toText(state.genesisTimestamp)
      # ":metals=12:pipeline=GOLD>SILVER>IRON>COPPER>PLATINUM"
      # ">TITANIUM>LITHIUM>COBALT>MERCURY>TUNGSTEN>ZINC>OSMIUM"
      # ":silver_anchor=1.0"
      # ":sovereign_floor=1.0"
      # ":ip_lock=METALS_PIPELINE_GENESIS"
      # ":blockchain=ICP_IMMUTABLE"
      # ":consolidated=true";
    state.sovereignSeal
  };

  public func setTrustedCaller(state : MetalsState, p : Principal) {
    state.trustedCallerPrincipal := p;
  };

  public func getSovereignSeal(state : MetalsState)      : Text      { state.sovereignSeal };
  public func getArchitectPrincipal(state : MetalsState) : Principal { state.architectPrincipal };
  public func isGenesisClaimed(state : MetalsState)      : Bool      { state.genesisLocked };
  public func getGenesisTimestamp(state : MetalsState)   : Int       { state.genesisTimestamp };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

}
