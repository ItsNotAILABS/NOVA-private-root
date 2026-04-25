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

// NATIVE NOVA PROTOCOL — BUILD №30
// CYCLES BRIDGE — ONESICAN ↔ ICP Cycles Sovereign Bridge
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// THE CYCLES BRIDGE IS THE SOVEREIGN VEIN.
//
// This canister is the bridge between:
//   ONESICANS (sovereign, φ-premium, multi-substrate)
//   ICP Cycles (XDR-denominated, single-substrate compute)
//
// WE DON'T USE ICP CYCLES AS A MASK.
// We can convert to them, sell them, or bypass them entirely.
// The bridge gives us the choice — and choice is sovereignty.
//
// ── WHAT THE BRIDGE DOES ─────────────────────────────────────────────────────
//
//   ONESICAN → CYCLES CONVERSION
//     You have ONESICANS. You need to fuel a canister on raw ICP.
//     Bridge converts at: 1 ONESICAN = φ × 10T raw cycles (premium)
//     The bridge charges a φ⁻⁵ fee (≈0.09 ONESICANS) per conversion.
//     Converted cycles go to a target canister's fuel account.
//
//   CYCLES → ONESICAN CONVERSION
//     You have raw ICP cycles (from mining, grants, or swap).
//     Bridge converts at: 1T cycles = 1 ONESICAN × φ⁻¹ (discount)
//     This is how cycles enter the ONESICAN economy.
//
//   SELL CYCLES TO NETWORK
//     NOVA owns cycles. We can SELL them to other ICP canisters.
//     Price: 1T cycles = 1 ONESICAN × φ⁻¹ (sovereign floor)
//     Buyer pays in ICP. ICP goes to PARALLAX treasury.
//     This is the "vein" — cycles we generate from staking/computation
//     get sold to developers who need raw compute.
//
//   CANISTER FUEL MARKETPLACE
//     Developers list their canister. They buy cycles through the bridge.
//     They pay in ONESICANS. We convert at premium. Developer gets cycles.
//     NOVA gets ONESICANS → sends to cycles_market for distribution.
//
// ── VALUE PREMIUM EXPLAINED IN NUMBERS ──────────────────────────────────────
//
// Assume ICP = $10, 1 XDR ≈ $1.30:
//   1 ICP = 10 / 1.30 ≈ 7.69 T raw ICP cycles
//   (Actually the NNS pegs at 10T cycles per ~1 SDR, so ≈ 10T/ICP at $10)
//
// ONESICAN vs raw cycles:
//   ONESICAN on ICP substrate:      = 1×  → 1T cycles equivalent
//   ONESICAN on EDGE substrate:     = φ¹  → 1.618T cycles equivalent
//   ONESICAN on CLOUD substrate:    = φ²  → 2.618T cycles equivalent
//   ONESICAN on PHANTOM substrate:  = φ³  → 4.236T cycles equivalent
//
// So selling 1 ONESICAN on PHANTOM = 4.236× what a raw cycle buyer would pay.
// At 10T cycles per ICP: 1 ONESICAN PHANTOM = 4.236T cycle-equivalent = ~$0.55
// But since ONESICANS are denominated in φ (not XDR), as PHI appreciates,
// the ONESICAN floor rises against raw ICP cycles automatically.
//
// ── DUAL MASKING CAPABILITY ──────────────────────────────────────────────────
// ONESICANS are a "mask" over ICP cycles ONLY in the sense that:
//   - When you need raw cycles for ICP computation: bridge converts
//   - When you want sovereign compute on any substrate: use ONESICANS directly
//   - When you want to profit from cycle scarcity: sell via marketplace
// We can bypass ICP entirely on EDGE/CLOUD/PHANTOM substrates.
// On those substrates, ONESICANS ARE the native currency. No ICP needed.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor CyclesBridge {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };
  func requireSovereign(caller : Principal) { assert(isSovereign(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "CYCLES_BRIDGE_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-CYCLES-BRIDGE-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH + RATE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp == 0.0) 1.0 else 0.0 }
    else Float.exp(exp * Float.log(base))
  };

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  // Cycles constants
  let CYCLES_PER_ONESICAN_ICP     : Nat = 1_000_000_000_000;  // 1T cycles per ONESICAN (ICP parity)
  let CYCLES_SELL_FEE_RATE        : Float = _pow(PHI_INV, 5.0); // φ⁻⁵ ≈ 0.09 fee on conversions
  let CYCLES_BUY_DISCOUNT_RATE    : Float = _pow(PHI_INV, 1.0); // φ⁻¹ discount when cycles → ONESICAN

  // Substrate multipliers
  let MULT_ICP       : Float = 1.0;                 // φ⁰
  let MULT_BLOCKCHAIN: Float = 1.0;                 // φ⁰ (parity)
  let MULT_EDGE      : Float = PHI;                 // φ¹
  let MULT_CLOUD     : Float = PHI * PHI;           // φ²
  let MULT_PHANTOM   : Float = PHI * PHI * PHI;     // φ³

  func _substrateMultiplier(substrate : Text) : Float {
    if      (substrate == "ICP")        MULT_ICP
    else if (substrate == "BLOCKCHAIN") MULT_BLOCKCHAIN
    else if (substrate == "EDGE")       MULT_EDGE
    else if (substrate == "CLOUD")      MULT_CLOUD
    else if (substrate == "PHANTOM")    MULT_PHANTOM
    else 1.0
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — BRIDGE RESERVES
  // ═══════════════════════════════════════════════════════════════════════════

  stable var onesicansReserve : Nat = 0;  // ONESICANS held in bridge
  stable var cyclesReserve    : Nat = 0;  // raw ICP cycles held in bridge
  stable var icpReserve       : Nat = 0;  // ICP (e8s) from cycle sales

  // Fund the bridge (sovereign deposits)
  public shared(msg) func depositOnesicans(amount : Nat) : async Bool {
    requireSovereign(msg.caller);
    onesicansReserve := onesicansReserve + amount;
    true
  };

  public shared(msg) func depositCycles(trillions : Nat) : async Bool {
    requireSovereign(msg.caller);
    cyclesReserve := cyclesReserve + trillions * 1_000_000_000_000;
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — CONVERSION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  let CONV_CAP : Nat = 4096;

  stable var convCount      : Nat = 0;
  stable var convIds        : [var Nat]   = Array.init<Nat>(CONV_CAP,   0);
  stable var convCallers    : [var Text]  = Array.init<Text>(CONV_CAP,  "");
  stable var convKinds      : [var Text]  = Array.init<Text>(CONV_CAP,  "");
  // Kinds: ONES_TO_CYCLES | CYCLES_TO_ONES | SELL_CYCLES | FUEL_CANISTER
  stable var convSubstrates : [var Text]  = Array.init<Text>(CONV_CAP,  "ICP");
  stable var convAmountsIn  : [var Nat]   = Array.init<Nat>(CONV_CAP,   0);
  stable var convAmountsOut : [var Nat]   = Array.init<Nat>(CONV_CAP,   0);
  stable var convFees       : [var Nat]   = Array.init<Nat>(CONV_CAP,   0);
  stable var convRates      : [var Float] = Array.init<Float>(CONV_CAP, 0.0);
  stable var convTimes      : [var Int]   = Array.init<Int>(CONV_CAP,   0);
  stable var nextConvId     : Nat         = 1;

  // Lifetime stats
  stable var totalOnesicansConverted : Nat = 0;
  stable var totalCyclesConverted    : Nat = 0;
  stable var totalCyclesSold         : Nat = 0;
  stable var totalFeesCollected      : Nat = 0;
  stable var totalIcpReceived        : Nat = 0;

  func _recordConversion(caller : Text, kind : Text, substrate : Text,
                          amountIn : Nat, amountOut : Nat, fee : Nat, rate : Float) {
    if (convCount >= CONV_CAP) return;
    let ci = convCount;
    convIds[ci]        := nextConvId;
    convCallers[ci]    := caller;
    convKinds[ci]      := kind;
    convSubstrates[ci] := substrate;
    convAmountsIn[ci]  := amountIn;
    convAmountsOut[ci] := amountOut;
    convFees[ci]       := fee;
    convRates[ci]      := rate;
    convTimes[ci]      := Time.now();
    convCount          := convCount + 1;
    nextConvId         := nextConvId + 1;
    totalFeesCollected := totalFeesCollected + fee;
  };

  // Convert ONESICANS → raw ICP cycles (to fuel a canister directly)
  // Rate: 1 ONESICAN = 1T cycles × substrate_multiplier
  // Fee: φ⁻⁵ of ONESICANS consumed
  public shared(msg) func onesicansToRawCycles(
    onesicans : Nat,
    substrate : Text
  ) : async {
    success    : Bool;
    cycles     : Nat;
    feeOnes    : Nat;
    rate       : Float;
    targetFuel : Text;
  } {
    let caller  = Principal.toText(msg.caller);
    let mult    = _substrateMultiplier(substrate);
    let fee     = _floatToNat(Float.fromInt(onesicans) * CYCLES_SELL_FEE_RATE);
    let net     = if (onesicans > fee) onesicans - fee else 0;
    if (net == 0) return { success = false; cycles = 0; feeOnes = fee; rate = 0.0; targetFuel = "INSUFFICIENT" };
    let cycles  = _floatToNat(Float.fromInt(net) * Float.fromInt(CYCLES_PER_ONESICAN_ICP) * mult);
    if (onesicansReserve < onesicans) return { success = false; cycles = 0; feeOnes = fee; rate = mult; targetFuel = "BRIDGE_INSUFFICIENT_RESERVE" };
    onesicansReserve       := onesicansReserve - onesicans;
    cyclesReserve          := cyclesReserve + cycles;
    totalOnesicansConverted:= totalOnesicansConverted + onesicans;
    totalCyclesConverted   := totalCyclesConverted + cycles;
    _recordConversion(caller, "ONES_TO_CYCLES", substrate, onesicans, cycles, fee, mult);
    { success = true; cycles; feeOnes = fee; rate = mult; targetFuel = "CYCLES_RESERVE" }
  };

  // Convert raw ICP cycles → ONESICANS (onboard new cycles into the economy)
  // Rate: 1T cycles = 1 ONESICAN × φ⁻¹ (discount for raw cycles entering)
  public shared(msg) func cyclesToOnesicans(trillionCycles : Nat) : async {
    success   : Bool;
    onesicans : Nat;
    rate      : Float;
  } {
    let caller    = Principal.toText(msg.caller);
    let onesicans = _floatToNat(Float.fromInt(trillionCycles) * CYCLES_BUY_DISCOUNT_RATE);
    if (onesicans == 0) return { success = false; onesicans = 0; rate = CYCLES_BUY_DISCOUNT_RATE };
    let rawCycles = trillionCycles * 1_000_000_000_000;
    cyclesReserve := cyclesReserve + rawCycles;
    onesicansReserve := if (onesicansReserve >= onesicans) onesicansReserve - onesicans else 0;
    totalCyclesConverted := totalCyclesConverted + rawCycles;
    _recordConversion(caller, "CYCLES_TO_ONES", "ICP", rawCycles, onesicans, 0, CYCLES_BUY_DISCOUNT_RATE);
    { success = true; onesicans; rate = CYCLES_BUY_DISCOUNT_RATE }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — CANISTER FUEL MARKETPLACE
  // ═══════════════════════════════════════════════════════════════════════════

  let FUEL_CAP : Nat = 2048;

  stable var fuelCount      : Nat = 0;
  stable var fuelIds        : [var Nat]   = Array.init<Nat>(FUEL_CAP,   0);
  stable var fuelCanisters  : [var Text]  = Array.init<Text>(FUEL_CAP,  "");  // canister principal
  stable var fuelBuyers     : [var Text]  = Array.init<Text>(FUEL_CAP,  "");
  stable var fuelSubstrates : [var Text]  = Array.init<Text>(FUEL_CAP,  "ICP");
  stable var fuelCyclesOut  : [var Nat]   = Array.init<Nat>(FUEL_CAP,   0);
  stable var fuelOnesicansIn: [var Nat]   = Array.init<Nat>(FUEL_CAP,   0);
  stable var fuelTimes      : [var Int]   = Array.init<Int>(FUEL_CAP,   0);
  stable var nextFuelId     : Nat         = 1;
  stable var totalCyclesFueled : Nat = 0;

  // Purchase cycles to fuel a canister (developer pays in ONESICANS)
  public shared(msg) func fuelCanister(
    canisterPrincipal : Text,
    onesicans         : Nat,
    substrate         : Text
  ) : async {
    success   : Bool;
    fuelId    : Nat;
    cyclesSent: Nat;
    cost      : Nat;
    substrate : Text;
  } {
    let caller = Principal.toText(msg.caller);
    let mult   = _substrateMultiplier(substrate);
    let fee    = _floatToNat(Float.fromInt(onesicans) * CYCLES_SELL_FEE_RATE);
    let net    = if (onesicans > fee) onesicans - fee else 0;
    let cycles = _floatToNat(Float.fromInt(net) * Float.fromInt(CYCLES_PER_ONESICAN_ICP) * mult);
    if (cycles == 0 or fuelCount >= FUEL_CAP) return { success = false; fuelId = 0; cyclesSent = 0; cost = onesicans; substrate };
    let fi = fuelCount;
    fuelIds[fi]         := nextFuelId;
    fuelCanisters[fi]   := canisterPrincipal;
    fuelBuyers[fi]      := caller;
    fuelSubstrates[fi]  := substrate;
    fuelCyclesOut[fi]   := cycles;
    fuelOnesicansIn[fi] := onesicans;
    fuelTimes[fi]       := Time.now();
    let id = nextFuelId;
    fuelCount           := fuelCount + 1;
    nextFuelId          := nextFuelId + 1;
    totalCyclesFueled   := totalCyclesFueled + cycles;
    totalCyclesSold     := totalCyclesSold + cycles;
    _recordConversion(caller, "FUEL_CANISTER", substrate, onesicans, cycles, fee, mult);
    { success = true; fuelId = id; cyclesSent = cycles; cost = onesicans; substrate }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — SELL CYCLES TO NETWORK
  // NOVA generates cycles through computation and governance.
  // We can sell surplus cycles to the ICP developer ecosystem.
  // Buyer pays ICP (e8s). We price at sovereign floor: 1T cycles = ICP/φ
  // ═══════════════════════════════════════════════════════════════════════════

  let SALE_CAP : Nat = 2048;

  stable var saleCount     : Nat = 0;
  stable var saleIds       : [var Nat]   = Array.init<Nat>(SALE_CAP,   0);
  stable var saleBuyers    : [var Text]  = Array.init<Text>(SALE_CAP,  "");
  stable var saleCycles    : [var Nat]   = Array.init<Nat>(SALE_CAP,   0);  // T cycles
  stable var saleIcpE8s    : [var Nat]   = Array.init<Nat>(SALE_CAP,   0);
  stable var saleFloors    : [var Float] = Array.init<Float>(SALE_CAP, 0.0);
  stable var saleTimes     : [var Int]   = Array.init<Int>(SALE_CAP,   0);
  stable var nextSaleId    : Nat         = 1;

  stable var icpPriceE8sPerCycleTrillion : Nat = 1_000_000;  // 0.01 ICP per T cycles (sovereign sets)

  public shared(msg) func setCyclePrice(icpE8sPerTrillionCycles : Nat) : async Bool {
    requireSovereign(msg.caller);
    icpPriceE8sPerCycleTrillion := icpE8sPerTrillionCycles;
    true
  };

  // A developer buys cycles from NOVA (pays ICP)
  public shared(msg) func buyCycles(trillionCycles : Nat) : async {
    success    : Bool;
    saleId     : Nat;
    cyclesSold : Nat;
    icpCostE8s : Nat;
    floor      : Float;
  } {
    let caller   = Principal.toText(msg.caller);
    let cost     = trillionCycles * icpPriceE8sPerCycleTrillion;
    let totalC   = trillionCycles * 1_000_000_000_000;
    if (cyclesReserve < totalC or saleCount >= SALE_CAP) {
      return { success = false; saleId = 0; cyclesSold = 0; icpCostE8s = cost; floor = Float.fromInt(icpPriceE8sPerCycleTrillion) }
    };
    cyclesReserve    := cyclesReserve - totalC;
    icpReserve       := icpReserve + cost;
    totalCyclesSold  := totalCyclesSold + totalC;
    totalIcpReceived := totalIcpReceived + cost;
    let si = saleCount;
    saleIds[si]    := nextSaleId;
    saleBuyers[si] := caller;
    saleCycles[si] := trillionCycles;
    saleIcpE8s[si] := cost;
    saleFloors[si] := Float.fromInt(icpPriceE8sPerCycleTrillion) / 100_000_000.0;
    saleTimes[si]  := Time.now();
    let id = nextSaleId;
    saleCount      := saleCount + 1;
    nextSaleId     := nextSaleId + 1;
    { success = true; saleId = id; cyclesSold = totalC; icpCostE8s = cost; floor = saleFloors[si] }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — VALUE PREMIUM ANALYTICS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getPremiumReport() : async {
    cyclesPerOnesicansICP     : Nat;
    icpSubstrateMultiplier    : Float;
    blockchainMultiplier      : Float;
    edgeMultiplier            : Float;
    cloudMultiplier           : Float;
    phantomMultiplier         : Float;
    currentCyclesFloorICP     : Float;
    sellFeeRate               : Float;
    onesicansReserve          : Nat;
    cyclesReserveT            : Nat;
    icpReserveE8s             : Nat;
    totalConversions          : Nat;
    totalCyclesSoldT          : Nat;
    premiumCalculation        : Text;
    sovereignAdvantage        : Text;
  } {
    {
      cyclesPerOnesicansICP  = CYCLES_PER_ONESICAN_ICP;
      icpSubstrateMultiplier = MULT_ICP;
      blockchainMultiplier   = MULT_BLOCKCHAIN;
      edgeMultiplier         = MULT_EDGE;
      cloudMultiplier        = MULT_CLOUD;
      phantomMultiplier      = MULT_PHANTOM;
      currentCyclesFloorICP  = Float.fromInt(icpPriceE8sPerCycleTrillion) / 100_000_000.0;
      sellFeeRate            = CYCLES_SELL_FEE_RATE;
      onesicansReserve       = onesicansReserve;
      cyclesReserveT         = cyclesReserve / 1_000_000_000_000;
      icpReserveE8s          = icpReserve;
      totalConversions       = convCount;
      totalCyclesSoldT       = totalCyclesSold / 1_000_000_000_000;
      premiumCalculation     =
        "At ICP=$10, XDR=$1.30: 1 ICP = ~7.69T raw cycles. " #
        "1 ONESICAN on ICP = 1T cycle-equivalent. " #
        "1 ONESICAN on EDGE = φ¹ = 1.618T. " #
        "1 ONESICAN on CLOUD = φ² = 2.618T. " #
        "1 ONESICAN on PHANTOM = φ³ = 4.236T. " #
        "Selling on PHANTOM: 4.236× raw cycle price. " #
        "1M ONESICANS sold on PHANTOM ≈ 4.236M T-cycle-equivalent revenue.";
      sovereignAdvantage     =
        "We don't USE ICP cycles as a mask. We sell compute at sovereign premium. " #
        "EDGE/CLOUD/PHANTOM substrates bypass ICP entirely — ONESICANS ARE the currency there. " #
        "ICP cycles are just one exit valve. We own all valves. We own the vein.";
    }
  };

  public query func getBridgeStatus() : async {
    seal              : Text;
    claimed           : Bool;
    onesicansReserve  : Nat;
    cyclesReserveT    : Nat;
    icpReserveE8s     : Nat;
    totalConversions  : Nat;
    totalFuelOps      : Nat;
    totalSaleOps      : Nat;
    totalFeesCollected: Nat;
    totalIcpReceived  : Nat;
    phi               : Float;
  } {
    {
      seal               = sovereignSeal;
      claimed            = genesisLocked;
      onesicansReserve   = onesicansReserve;
      cyclesReserveT     = cyclesReserve / 1_000_000_000_000;
      icpReserveE8s      = icpReserve;
      totalConversions   = convCount;
      totalFuelOps       = fuelCount;
      totalSaleOps       = saleCount;
      totalFeesCollected = totalFeesCollected;
      totalIcpReceived   = totalIcpReceived;
      phi                = PHI;
    }
  };

};
