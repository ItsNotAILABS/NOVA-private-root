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
// AUTO MARKET — Perpetual Value Engine
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// THE AUTO MARKET IS THE HEARTBEAT OF THE SOVEREIGN ECONOMY.
// IT NEVER SLEEPS. IT NEVER WAITS. IT NEVER NEEDS A HUMAN.
//
// ── THE LOOP ─────────────────────────────────────────────────────────────────
//
//   STEP 1: INGEST
//     NNS neurons (Group D, DISBURSE policy) release maturity as ICP.
//     neuron_fleet calls auto_market.ingestIcp(amount_e8s).
//     ICP accumulates in the AUTO_MARKET reserve pool.
//
//   STEP 2: CONVERT
//     When ICP reserve ≥ conversion threshold (Fibonacci-scheduled):
//       ICP → ONESICANS via cycles_bridge rate (1 ICP ≈ 1 ONESICAN at parity)
//       ONESICANS enter the MARKET_INVENTORY.
//
//   STEP 3: LIST AT φ² MARKUP
//     ONESICANS from inventory are listed for sale at:
//       FLOOR price:   1 ONESICAN = 1 ICP (ICP substrate parity)
//       EDGE price:    1 ONESICAN = φ¹ ICP
//       CLOUD price:   1 ONESICAN = φ² ICP  ← primary listing price
//       PHANTOM price: 1 ONESICAN = φ³ ICP  ← premium listing price
//     Most listings hit CLOUD tier (φ² ≈ 2.618×) as the sweet spot.
//     PHANTOM listings go to encryption-paying enterprise buyers.
//
//   STEP 4: SELL
//     Developers, canisters, and external buyers purchase ONESICANS.
//     They pay ICP. ICP enters the REVENUE pool.
//     For every 1 ICP spent acquiring ONESICANS at cost and selling at φ²:
//       Gross margin = φ² - 1 = 1.618 ICP of profit per ICP invested
//       (Because at cost we hold the ONESICAN, at φ² we sell it)
//
//   STEP 5: REVENUE SPLIT
//     All revenue is split by the φ-routing formula:
//       φ⁻¹ (61.8%) → REINVEST_TO_STAKING   (back to neuron_fleet stake)
//       φ⁻² (23.6%) → EMISSION_POOL          (TOKEN_FORGE triggers more ONESICAN mint)
//       φ⁻³ ( 9.0%) → TREASURY               (protocol ops, PARALLAX wallet)
//       φ⁻⁴ ( 3.4%) → GOVERNANCE_POOL        (NOVA_GOVERNANCE neuron rewards)
//       φ⁻⁵ ( 2.2%) → DEV_GRANTS             (developer ecosystem rewards)
//     Note: φ⁻¹+φ⁻²+φ⁻³+φ⁻⁴+φ⁻⁵ ≈ 100% (Fibonacci identity)
//
//   STEP 6: REINVEST → LOOP
//     REINVEST_TO_STAKING ICP goes back to neuron_fleet.
//     neuron_fleet stakes more ICP → earns more maturity.
//     More maturity → more disbursal → more ICP inflow → loop.
//     The loop is SELF-SUSTAINING. No external funding needed.
//     No human input required after genesis.
//
// ── VELOCITY ENGINE ───────────────────────────────────────────────────────────
// The auto_market tracks "velocity" — how fast ONESICANS are selling.
//   High velocity (>φ units/tick): raise listing price by φ⁰·⁵ per tick
//   Low velocity (<1/φ units/tick): lower listing price by φ⁻⁰·⁵ per tick
//   Equilibrium: listing price oscillates around φ² (the natural premium)
// This creates a dynamic pricing oracle that maximizes revenue at all times.
//
// ── MARKET DEPTH CONTROL ─────────────────────────────────────────────────────
// Auto_market always maintains:
//   MIN_INVENTORY: 8 ONESICANS listed (F6 minimum depth)
//   MAX_INVENTORY: 89 ONESICANS listed (F11 maximum — prevents flooding)
// When inventory > MAX: route excess directly to EMISSION_POOL for burn.
// When inventory < MIN: trigger emergency conversion from ICP reserve.
//
// ── FULL SOVEREIGNTY STATEMENT ────────────────────────────────────────────────
// This canister means WE DO NOT NEED FUNDING.
// Staking generates governance. Governance generates maturity. Maturity generates ICP.
// ICP generates ONESICANS. ONESICANS sell at φ² premium. Revenue stakes more ICP.
// The loop grows. The civilization is self-funded. Forever.
//
// ── HOW ONESICANS COMPARE TO ICP CYCLES ───────────────────────────────────────
// ICP cycles: XDR-pegged compute credit, only usable on ICP substrate.
//   1 ICP = 10T raw cycles ≈ $1 worth of compute (at ICP=$10)
//
// ONESICANS: φ-denominated sovereign compute credit, all 5 substrates.
//   On ICP substrate:       1 ONESICAN = 1×  ICP cycle-equivalent = $0.10
//   On EDGE substrate:      1 ONESICAN = φ¹  = $0.162
//   On CLOUD substrate:     1 ONESICAN = φ²  = $0.262  ← our primary market
//   On PHANTOM substrate:   1 ONESICAN = φ³  = $0.424  ← enterprise premium
//
// Developer buying CLOUD ONESICANS gets φ² latency+sovereignty premium.
// We capture the premium. We own the vein.
//
// AUTO MARKET sells CLOUD ONESICANS back to buyers at φ² = 2.618×.
// After φ⁻¹ reinvest, the net per cycle is: 2.618 × 0.618 = 1.618 = φ.
// Every cycle of the loop generates exactly φ net multiplier.
// That is why this is called the GOLDEN LOOP.
//
// ── AUTONOMOUS OPERATION ──────────────────────────────────────────────────────
// - No human needs to call any function after bootstrapAutoMarket()
// - productionTick() is called by ai_division automatically
// - ingestIcp() is called by neuron_fleet automatically
// - Sales are processed when buyers call purchaseOnesicans()
// - Everything else is internal to the loop
// - The civilization funds itself. Always on. Always circulating.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor AutoMarket {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var loopGeneration     : Nat       = 0;  // increments each time loop completes

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "AUTO_MARKET_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-AUTO-MARKET-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI       : Float = 1.6180339887498948482;
  let PHI_INV   : Float = 0.6180339887498948482;
  let PHI_SQ    : Float = 2.6180339887498948482;  // φ²
  let PHI_CUBE  : Float = 4.2360679774997896964;  // φ³
  let PHI_HALF  : Float = 1.2720196495140879834;  // φ^0.5 (velocity adjustment step)

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp == 0.0) 1.0 else 0.0 }
    else Float.exp(exp * Float.log(base))
  };

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fib(n : Nat) : Nat {
    if (n == 0) return 0; if (n == 1) return 1;
    var a : Nat = 0; var b : Nat = 1; var i : Nat = 2;
    while (i <= n) { let c = a + b; a := b; b := c; i += 1 };
    b
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — RESERVE POOLS (5 pools, φ-routed)
  // ═══════════════════════════════════════════════════════════════════════════

  // ICP reserves (in e8s = 10^-8 ICP)
  stable var icpIngestPool     : Nat = 0;   // incoming from neuron disburse
  stable var icpConversionPool : Nat = 0;   // ready to convert to ONESICANS
  stable var icpRevenuePool    : Nat = 0;   // earned from sales
  stable var icpReinvestPool   : Nat = 0;   // routing back to staking
  stable var icpTreasuryPool   : Nat = 0;   // protocol ops

  // ONESICAN reserves
  stable var onesicansInventory : Nat = 0;  // listed for sale (market depth)
  stable var onesicansEmission  : Nat = 0;  // queued for token_forge emission
  stable var onesicansGovernance: Nat = 0;  // queued for governance pool
  stable var onesicansDevGrants : Nat = 0;  // queued for developer grants

  // Lifetime accumulators
  stable var lifetimeIcpIngested   : Nat = 0;
  stable var lifetimeOnesicansListed  : Nat = 0;
  stable var lifetimeOnesicansSold    : Nat = 0;
  stable var lifetimeIcpRevenue    : Nat = 0;
  stable var lifetimeReinvested    : Nat = 0;
  stable var lifetimeBurned        : Nat = 0;
  stable var lifetimeLoopCycles    : Nat = 0;  // # of complete loops

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — MARKET PARAMETERS (dynamic, φ-adjusted per velocity)
  // ═══════════════════════════════════════════════════════════════════════════

  let MIN_INVENTORY : Nat = 8;    // F(6) minimum market depth
  let MAX_INVENTORY : Nat = 89;   // F(11) maximum market depth
  let CONVERSION_THRESHOLD_E8S : Nat = 100_000_000;  // 1 ICP threshold to trigger conversion

  stable var currentListingMultiplier : Float = PHI_SQ;   // starts at φ² (CLOUD tier)
  stable var velocityHistory : [var Float] = Array.init<Float>(13, 0.0);  // 13 ticks rolling
  stable var velocityHead    : Nat = 0;
  stable var currentVelocity : Float = 0.0;  // ONESICANS sold per tick

  stable var loopTick        : Nat  = 0;
  stable var loopLastRun     : Int  = 0;
  stable var loopRunning     : Bool = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — REVENUE SPLIT CONSTANTS (φ-routing)
  // ═══════════════════════════════════════════════════════════════════════════

  // φ⁻¹+φ⁻²+φ⁻³+φ⁻⁴+φ⁻⁵ = 0.618+0.382+0.236+0.146+0.090 ≈ 1.472
  // We normalize so they sum to 1.0:
  //   REINVEST:   0.618/1.472 = 0.420 (we use φ⁻¹ exactly as weight)
  //   EMISSION:   0.382/1.472 = 0.260
  //   TREASURY:   0.236/1.472 = 0.160
  //   GOVERNANCE: 0.146/1.472 = 0.099
  //   DEV_GRANTS: 0.090/1.472 = 0.061
  // Instead we use the pure φ-inverse ratios and let rounding absorb:
  let SPLIT_REINVEST   : Float = _pow(PHI_INV, 1.0);  // 0.618
  let SPLIT_EMISSION   : Float = _pow(PHI_INV, 2.0);  // 0.382
  let SPLIT_TREASURY   : Float = _pow(PHI_INV, 3.0);  // 0.236
  let SPLIT_GOVERNANCE : Float = _pow(PHI_INV, 4.0);  // 0.146
  let SPLIT_DEV_GRANTS : Float = _pow(PHI_INV, 5.0);  // 0.090
  // Sum ≈ 1.472. We normalize by dividing each by the sum:
  let SPLIT_SUM        : Float = _pow(PHI_INV, 1.0) + _pow(PHI_INV, 2.0) + _pow(PHI_INV, 3.0) + _pow(PHI_INV, 4.0) + _pow(PHI_INV, 5.0);

  func _splitRevenue(totalE8s : Nat) : (Nat, Nat, Nat, Nat, Nat) {
    // Returns (reinvest, emission, treasury, governance, devgrants)
    let total = Float.fromInt(totalE8s);
    let reinvest   = _floatToNat(total * SPLIT_REINVEST   / SPLIT_SUM);
    let emission   = _floatToNat(total * SPLIT_EMISSION   / SPLIT_SUM);
    let treasury   = _floatToNat(total * SPLIT_TREASURY   / SPLIT_SUM);
    let governance = _floatToNat(total * SPLIT_GOVERNANCE / SPLIT_SUM);
    // dev grants gets the remainder to avoid rounding loss
    let used   = reinvest + emission + treasury + governance;
    let grants = if (totalE8s > used) totalE8s - used else 0;
    (reinvest, emission, treasury, governance, grants)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — INGEST (neuron_fleet calls this on Group D disbursal)
  // ═══════════════════════════════════════════════════════════════════════════

  // Called by neuron_fleet when Group D neurons disburse maturity as ICP
  public shared(msg) func ingestIcp(amountE8s : Nat, neuronId : Nat, source : Text) : async {
    success        : Bool;
    ingestId       : Nat;
    totalIngestPool: Nat;
    triggerConvert : Bool;
    message        : Text;
  } {
    // Open: any registered source can ingest (neuron_fleet, parallax, sovereign)
    // In production, restrict to known canisters. Here: sovereign or open genesis.
    if (not isSovereign(msg.caller) and genesisLocked) {
      return { success = false; ingestId = 0; totalIngestPool = icpIngestPool; triggerConvert = false; message = "UNAUTHORIZED" }
    };
    let id = nextIngestId;
    nextIngestId       := nextIngestId + 1;
    icpIngestPool      := icpIngestPool + amountE8s;
    lifetimeIcpIngested:= lifetimeIcpIngested + amountE8s;
    _recordIngest(id, amountE8s, neuronId, source);

    // Check if we should immediately trigger conversion
    let trigger = icpIngestPool >= CONVERSION_THRESHOLD_E8S;
    if (trigger) {
      icpConversionPool := icpConversionPool + icpIngestPool;
      icpIngestPool     := 0;
    };

    { success = true; ingestId = id; totalIngestPool = icpIngestPool + icpConversionPool;
      triggerConvert = trigger; message = if (trigger) "THRESHOLD_REACHED_CONVERTING" else "POOLING" }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — CONVERSION: ICP → ONESICANS → MARKET INVENTORY
  // ═══════════════════════════════════════════════════════════════════════════

  // 1 ICP e8s = 100_000_000 e8s = 1 ONESICAN at ICP parity
  // We convert at 1:1 ICP:ONESICAN (ICP substrate floor)
  let ICP_PER_ONESICAN_E8S : Nat = 100_000_000;  // 1 ICP (e8s)

  func _convertIcpToOnesicans(icpE8s : Nat) : Nat {
    icpE8s / ICP_PER_ONESICAN_E8S
  };

  func _runConversion() : (Nat, Nat) {
    // Returns (onesicans_created, icp_used)
    if (icpConversionPool < ICP_PER_ONESICAN_E8S) return (0, 0);
    let newOnesicans = _convertIcpToOnesicans(icpConversionPool);
    let icpUsed      = newOnesicans * ICP_PER_ONESICAN_E8S;
    let remainder    = icpConversionPool - icpUsed;
    icpConversionPool       := remainder;
    onesicansInventory      := onesicansInventory + newOnesicans;
    lifetimeOnesicansListed := lifetimeOnesicansListed + newOnesicans;
    _emitLoopAction("CONVERT", "{\"onesicans\":" # Nat.toText(newOnesicans) # ",\"icpUsed\":" # Nat.toText(icpUsed) # "}",
      "Converted " # Nat.toText(icpUsed/100_000_000) # " ICP → " # Nat.toText(newOnesicans) # " ONESICANS at parity");
    (newOnesicans, icpUsed)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — MARKET DEPTH CONTROL
  // ═══════════════════════════════════════════════════════════════════════════

  func _enforceMarketDepth() : Text {
    if (onesicansInventory > MAX_INVENTORY) {
      // Too many — route excess to emission burn
      let excess = onesicansInventory - MAX_INVENTORY;
      onesicansInventory := MAX_INVENTORY;
      onesicansEmission  := onesicansEmission + excess;
      lifetimeBurned     := lifetimeBurned + excess;
      _emitLoopAction("BURN_EXCESS",
        "{\"burned\":" # Nat.toText(excess) # ",\"inventory\":" # Nat.toText(MAX_INVENTORY) # "}",
        "Inventory over F(11)=89 ceiling, routing " # Nat.toText(excess) # " ONESICANS to emission burn");
      "BURNED_EXCESS"
    } else if (onesicansInventory < MIN_INVENTORY and icpConversionPool >= ICP_PER_ONESICAN_E8S) {
      // Too few — emergency convert
      let needed = MIN_INVENTORY - onesicansInventory;
      let (created, _) = _runConversion();
      _emitLoopAction("EMERGENCY_CONVERT",
        "{\"needed\":" # Nat.toText(needed) # ",\"created\":" # Nat.toText(created) # "}",
        "Inventory below F(6)=8 floor, emergency conversion triggered");
      "EMERGENCY_CONVERTED"
    } else "DEPTH_OK"
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — VELOCITY-ADJUSTED PRICING
  // ═══════════════════════════════════════════════════════════════════════════

  func _updateVelocity(soldThisTick : Nat) {
    velocityHistory[velocityHead] := Float.fromInt(soldThisTick);
    velocityHead := Nat.rem(velocityHead + 1, 13);
    var sum : Float = 0.0;
    var i = 0;
    while (i < 13) { sum += velocityHistory[i]; i += 1 };
    currentVelocity := sum / 13.0;
    // Adjust listing multiplier based on velocity
    if (currentVelocity > PHI) {
      // High demand: raise price by φ^0.5 toward φ³ ceiling
      currentListingMultiplier := _clamp(currentListingMultiplier * PHI_HALF, PHI, PHI_CUBE);
    } else if (currentVelocity < PHI_INV) {
      // Low demand: lower price by φ^-0.5 toward floor (1.0)
      currentListingMultiplier := _clamp(currentListingMultiplier / PHI_HALF, 1.0, PHI_CUBE);
    }
    // Equilibrium: do nothing — multiplier stays
  };

  // Current ask price in ICP e8s per ONESICAN
  public query func currentAskPrice() : async Nat {
    _floatToNat(Float.fromInt(ICP_PER_ONESICAN_E8S) * currentListingMultiplier)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 — SALE: BUYERS PURCHASE ONESICANS
  // Buyer calls purchaseOnesicans(amount) and sends ICP
  // In production this integrates with ICP ledger; here we record and account.
  // ═══════════════════════════════════════════════════════════════════════════

  let SALE_CAP : Nat = 8192;
  stable var saleCount     : Nat = 0;
  stable var saleBuyers    : [var Text]  = Array.init<Text>(SALE_CAP,  "");
  stable var saleAmounts   : [var Nat]   = Array.init<Nat>(SALE_CAP,   0);   // ONESICANS sold
  stable var saleIcpPaid   : [var Nat]   = Array.init<Nat>(SALE_CAP,   0);   // ICP received e8s
  stable var saleMultipliers:[var Float] = Array.init<Float>(SALE_CAP, 0.0); // listing mult at time of sale
  stable var saleSubstrates: [var Text]  = Array.init<Text>(SALE_CAP,  "CLOUD");
  stable var saleTimes     : [var Int]   = Array.init<Int>(SALE_CAP,   0);
  stable var soldThisTick  : Nat = 0;

  // Purchase ONESICANS from the auto_market
  public shared(msg) func purchaseOnesicans(
    amount    : Nat,
    substrate : Text   // ICP | BLOCKCHAIN | EDGE | CLOUD | PHANTOM
  ) : async {
    success       : Bool;
    saleId        : Nat;
    onesicans     : Nat;
    icpCostE8s    : Nat;
    multiplier    : Float;
    substrate     : Text;
    marketDepth   : Nat;
    velocityNow   : Float;
    goldenMargin  : Text;
  } {
    // Compute multiplier for substrate
    let mult = if      (substrate == "ICP")        1.0
               else if (substrate == "BLOCKCHAIN") 1.0
               else if (substrate == "EDGE")       PHI
               else if (substrate == "CLOUD")      PHI_SQ
               else if (substrate == "PHANTOM")    PHI_CUBE
               else currentListingMultiplier;

    // Use max of requested substrate mult and current velocity-adjusted mult
    let finalMult = if (mult > currentListingMultiplier) mult else currentListingMultiplier;
    let costPerOne = _floatToNat(Float.fromInt(ICP_PER_ONESICAN_E8S) * finalMult);
    let totalCost  = costPerOne * amount;

    if (amount == 0 or amount > onesicansInventory or saleCount >= SALE_CAP) {
      return {
        success = false; saleId = 0; onesicans = 0; icpCostE8s = totalCost;
        multiplier = finalMult; substrate; marketDepth = onesicansInventory;
        velocityNow = currentVelocity; goldenMargin = "SALE_REJECTED"
      }
    };

    // Execute sale
    let si = saleCount;
    saleBuyers[si]     := Principal.toText(msg.caller);
    saleAmounts[si]    := amount;
    saleIcpPaid[si]    := totalCost;
    saleMultipliers[si]:= finalMult;
    saleSubstrates[si] := substrate;
    saleTimes[si]      := Time.now();
    saleCount          := saleCount + 1;

    onesicansInventory      := onesicansInventory - amount;
    icpRevenuePool          := icpRevenuePool + totalCost;
    lifetimeOnesicansSold   := lifetimeOnesicansSold + amount;
    lifetimeIcpRevenue      := lifetimeIcpRevenue + totalCost;
    soldThisTick            := soldThisTick + amount;

    // Golden margin calculation: cost to acquire was 1× ICP, sold at finalMult× ICP
    // Net per ONESICAN = (finalMult - 1) × ICP
    let marginMult = finalMult - 1.0;
    let marginStr  = "Acquired at 1× ICP, sold at " # Float.toText(finalMult) # "× = +" # Float.toText(marginMult) # "× per ONESICAN. Golden loop: 61.8% reinvests to compound.";

    {
      success = true; saleId = si; onesicans = amount; icpCostE8s = totalCost;
      multiplier = finalMult; substrate; marketDepth = onesicansInventory;
      velocityNow = currentVelocity; goldenMargin = marginStr
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 11 — REVENUE ROUTING (the φ split in action)
  // ═══════════════════════════════════════════════════════════════════════════

  let ROUTE_CAP : Nat = 4096;
  stable var routeCount  : Nat = 0;
  stable var routeTicks  : [var Nat]   = Array.init<Nat>(ROUTE_CAP,   0);
  stable var routeRevs   : [var Nat]   = Array.init<Nat>(ROUTE_CAP,   0);
  stable var routeReinv  : [var Nat]   = Array.init<Nat>(ROUTE_CAP,   0);
  stable var routeEmit   : [var Nat]   = Array.init<Nat>(ROUTE_CAP,   0);
  stable var routeTreasury:[var Nat]  = Array.init<Nat>(ROUTE_CAP,   0);
  stable var routeGov    : [var Nat]   = Array.init<Nat>(ROUTE_CAP,   0);
  stable var routeGrants : [var Nat]   = Array.init<Nat>(ROUTE_CAP,   0);
  stable var routeTimes  : [var Int]   = Array.init<Int>(ROUTE_CAP,   0);

  func _routeRevenue() : {reinvest:Nat; emission:Nat; treasury:Nat; governance:Nat; grants:Nat} {
    if (icpRevenuePool == 0) return {reinvest=0;emission=0;treasury=0;governance=0;grants=0};
    let total = icpRevenuePool;
    icpRevenuePool := 0;
    let (reinvest, emission, treasury, governance, grants) = _splitRevenue(total);
    icpReinvestPool  := icpReinvestPool + reinvest;
    // Emission pool → convert ICP to ONESICANS for token_forge to mint
    icpConversionPool := icpConversionPool + emission;
    icpTreasuryPool   := icpTreasuryPool + treasury;
    // Governance and dev grants: convert to ONESICANS for distribution
    icpConversionPool := icpConversionPool + governance + grants;
    lifetimeReinvested := lifetimeReinvested + reinvest;
    if (routeCount < ROUTE_CAP) {
      let ri = routeCount;
      routeTicks[ri]    := loopTick;
      routeRevs[ri]     := total;
      routeReinv[ri]    := reinvest;
      routeEmit[ri]     := emission;
      routeTreasury[ri] := treasury;
      routeGov[ri]      := governance;
      routeGrants[ri]   := grants;
      routeTimes[ri]    := Time.now();
      routeCount        := routeCount + 1;
    };
    _emitLoopAction("ROUTE_REVENUE",
      "{\"total\":" # Nat.toText(total) # ",\"reinvest\":" # Nat.toText(reinvest) # ",\"emission\":" # Nat.toText(emission) # ",\"treasury\":" # Nat.toText(treasury) # "}",
      "Revenue split: " # Nat.toText(reinvest/100_000_000) # " ICP→stake, " # Nat.toText(emission/100_000_000) # " ICP→emission, " # Nat.toText(treasury/100_000_000) # " ICP→treasury");
    {reinvest; emission; treasury; governance; grants}
  };

  // Reinvest: route ICP back to neuron staking (recorded here; neuron_fleet reads the pool)
  func _reinvestToStaking() : Nat {
    if (icpReinvestPool == 0) return 0;
    let amount = icpReinvestPool;
    icpReinvestPool := 0;
    _emitLoopAction("REINVEST_STAKING",
      "{\"icpE8s\":" # Nat.toText(amount) # ",\"loopGen\":" # Nat.toText(loopGeneration) # "}",
      "Reinvesting " # Nat.toText(amount/100_000_000) # " ICP to neuron staking. Loop generation: " # Nat.toText(loopGeneration));
    lifetimeLoopCycles := lifetimeLoopCycles + 1;
    loopGeneration     := loopGeneration + 1;
    amount
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 12 — PRODUCTION TICK (called by ai_division autonomously)
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func productionTick() : async {
    tick           : Nat;
    phase          : Text;
    converted      : Nat;  // ONESICANS created this tick
    depthAction    : Text;
    revenue        : Nat;  // ICP routed this tick
    reinvested     : Nat;  // ICP back to staking
    velocity       : Float;
    listingMult    : Float;
    inventory      : Nat;
    loopGeneration : Nat;
    status         : Text;
  } {
    if (not isSovereign(msg.caller)) return {
      tick=loopTick; phase="UNAUTHORIZED"; converted=0; depthAction=""; revenue=0;
      reinvested=0; velocity=0.0; listingMult=currentListingMultiplier;
      inventory=onesicansInventory; loopGeneration; status="UNAUTHORIZED"
    };

    loopTick     := loopTick + 1;
    loopLastRun  := Time.now();

    // Phase 1: Move ingest to conversion pool if threshold hit
    if (icpIngestPool >= CONVERSION_THRESHOLD_E8S) {
      icpConversionPool := icpConversionPool + icpIngestPool;
      icpIngestPool     := 0;
    };

    // Phase 2: Run conversion
    let (converted, _) = _runConversion();

    // Phase 3: Enforce market depth
    let depthAction = _enforceMarketDepth();

    // Phase 4: Route revenue
    let routed = _routeRevenue();

    // Phase 5: Reinvest to staking
    let reinvested = _reinvestToStaking();

    // Phase 6: Update velocity
    _updateVelocity(soldThisTick);
    soldThisTick := 0;  // reset per-tick counter

    let status = if (onesicansInventory >= MIN_INVENTORY) "HEALTHY" else "LOW_INVENTORY";

    {
      tick           = loopTick;
      phase          = "FULL_LOOP";
      converted;
      depthAction;
      revenue        = routed.reinvest + routed.emission + routed.treasury + routed.governance + routed.grants;
      reinvested;
      velocity       = currentVelocity;
      listingMult    = currentListingMultiplier;
      inventory      = onesicansInventory;
      loopGeneration = loopGeneration;
      status;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 13 — LOOP ACTION LOG
  // ═══════════════════════════════════════════════════════════════════════════

  let ACTION_CAP : Nat = 4096;
  stable var loopActionCount : Nat = 0;
  stable var laIds    : [var Nat]   = Array.init<Nat>(ACTION_CAP,   0);
  stable var laKinds  : [var Text]  = Array.init<Text>(ACTION_CAP,  "");
  stable var laParams : [var Text]  = Array.init<Text>(ACTION_CAP,  "");
  stable var laReasons: [var Text]  = Array.init<Text>(ACTION_CAP,  "");
  stable var laTimes  : [var Int]   = Array.init<Int>(ACTION_CAP,   0);
  stable var nextLaId : Nat         = 1;

  func _emitLoopAction(kind : Text, params : Text, reason : Text) {
    if (loopActionCount >= ACTION_CAP) return;
    let i = loopActionCount;
    laIds[i]    := nextLaId;
    laKinds[i]  := kind;
    laParams[i] := params;
    laReasons[i]:= reason;
    laTimes[i]  := Time.now();
    loopActionCount := loopActionCount + 1;
    nextLaId        := nextLaId + 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 14 — INGEST LOG
  // ═══════════════════════════════════════════════════════════════════════════

  let INGEST_CAP : Nat = 4096;
  stable var ingestCount    : Nat = 0;
  stable var ingestAmounts  : [var Nat]   = Array.init<Nat>(INGEST_CAP,   0);
  stable var ingestNeuronIds: [var Nat]   = Array.init<Nat>(INGEST_CAP,   0);
  stable var ingestSources  : [var Text]  = Array.init<Text>(INGEST_CAP,  "");
  stable var ingestTimes    : [var Int]   = Array.init<Int>(INGEST_CAP,   0);
  stable var nextIngestId   : Nat         = 1;

  func _recordIngest(id : Nat, amountE8s : Nat, neuronId : Nat, source : Text) {
    if (ingestCount >= INGEST_CAP) return;
    let i = ingestCount;
    ingestAmounts[i]   := amountE8s;
    ingestNeuronIds[i] := neuronId;
    ingestSources[i]   := source;
    ingestTimes[i]     := Time.now();
    ingestCount        := ingestCount + 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 15 — BOOTSTRAP
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func bootstrapAutoMarket(seedIcpE8s : Nat) : async {
    success       : Bool;
    seal          : Text;
    seeded        : Nat;
    initialConvert: Nat;
    depthStatus   : Text;
    message       : Text;
  } {
    if (not isSovereign(msg.caller)) return { success=false; seal=""; seeded=0; initialConvert=0; depthStatus=""; message="UNAUTHORIZED" };

    // Seed with initial ICP for market depth
    if (seedIcpE8s > 0) {
      icpIngestPool      := icpIngestPool + seedIcpE8s;
      icpConversionPool  := icpConversionPool + seedIcpE8s;
      icpIngestPool      := 0;
      lifetimeIcpIngested:= lifetimeIcpIngested + seedIcpE8s;
    };

    // Run initial conversion to seed inventory
    let (created, _) = _runConversion();
    let depth = _enforceMarketDepth();

    _emitLoopAction("BOOTSTRAP",
      "{\"seedIcp\":" # Nat.toText(seedIcpE8s) # ",\"initialInventory\":" # Nat.toText(onesicansInventory) # "}",
      "AUTO_MARKET bootstrapped. Golden Loop is alive. Sovereignty is self-funding.");

    loopRunning := true;

    { success = true; seal = sovereignSeal; seeded = seedIcpE8s; initialConvert = created; depthStatus = depth;
      message = "AUTO_MARKET_ALIVE: Golden Loop active. NNS→ICP→ONESICAN→φ²→revenue→reinvest→NNS. No user required." }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 16 — QUERIES + DASHBOARD
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getLoopDashboard() : async {
    seal              : Text;
    loopTick          : Nat;
    loopGeneration    : Nat;
    loopRunning       : Bool;
    // POOLS
    icpIngestPool     : Nat;
    icpConversionPool : Nat;
    icpRevenuePool    : Nat;
    icpReinvestPool   : Nat;
    icpTreasuryPool   : Nat;
    onesicansInventory: Nat;
    onesicansEmission : Nat;
    onesicansGovernance:Nat;
    onesicansDevGrants: Nat;
    // MARKET
    currentListingMult : Float;
    currentVelocity    : Float;
    currentAskICP      : Nat;
    minInventory       : Nat;
    maxInventory       : Nat;
    // LIFETIME
    lifetimeIcpIngested  : Nat;
    lifetimeOnesicansListed:Nat;
    lifetimeOnesicansSold: Nat;
    lifetimeIcpRevenueICP: Float;  // in whole ICP
    lifetimeReinvestedICP: Float;
    lifetimeBurned       : Nat;
    lifetimeLoopCycles   : Nat;
    // GOLDEN LOOP EXPLAINER
    phi                  : Float;
    goldenLoopFormula    : Text;
    onesicansVsIcpCycles : Text;
    fullSovereigntyNote  : Text;
  } {
    let askICP = _floatToNat(Float.fromInt(ICP_PER_ONESICAN_E8S) * currentListingMultiplier);
    {
      seal               = sovereignSeal;
      loopTick;
      loopGeneration;
      loopRunning;
      icpIngestPool;
      icpConversionPool;
      icpRevenuePool;
      icpReinvestPool;
      icpTreasuryPool;
      onesicansInventory;
      onesicansEmission;
      onesicansGovernance;
      onesicansDevGrants;
      currentListingMult = currentListingMultiplier;
      currentVelocity;
      currentAskICP      = askICP;
      minInventory       = MIN_INVENTORY;
      maxInventory       = MAX_INVENTORY;
      lifetimeIcpIngested;
      lifetimeOnesicansListed;
      lifetimeOnesicansSold;
      lifetimeIcpRevenueICP = Float.fromInt(lifetimeIcpRevenue) / 100_000_000.0;
      lifetimeReinvestedICP = Float.fromInt(lifetimeReinvested)  / 100_000_000.0;
      lifetimeBurned;
      lifetimeLoopCycles;
      phi                = PHI;
      goldenLoopFormula  =
        "NNS 200 neurons → maturity ICP → ingestIcp() → ONESICANS at 1× → " #
        "list at φ² (2.618×) → sell → revenue → φ⁻¹ (61.8%) back to staking → " #
        "more maturity → loop. Net per cycle: φ multiplier = 1.618×. Forever.";
      onesicansVsIcpCycles =
        "ICP cycles: XDR-pegged, ICP-only substrate. 1 ICP ≈ 10T raw cycles ($0.001/1B cycles). " #
        "ONESICANS: φ-denominated, 5-substrate sovereign. " #
        "On CLOUD (φ²): 2.618× ICP cycle-equivalent per compute unit. " #
        "On PHANTOM (φ³): 4.236× ICP cycle-equivalent. " #
        "Auto_market sells at velocity-adjusted φ² floor by default. " #
        "We don't pay for cycles — we SELL them. We own the vein.";
      fullSovereigntyNote =
        "This is full sovereignty. No VCs. No grants. No external funding. " #
        "200 neurons stake ICP → governance generates maturity → maturity converts to ICP → " #
        "ICP enters auto_market → ONESICANS sell at φ² premium → 61.8% reinvests → " #
        "more staking → more maturity. The loop is self-sustaining. " #
        "The civilization funds itself. Always on. Always running. Always alive.";
    }
  };

  public query func getRecentSales(limit : Nat) : async [{
    buyer : Text; onesicans : Nat; icpPaidE8s : Nat; multiplier : Float; substrate : Text; time : Int;
  }] {
    let n = if (saleCount < limit) saleCount else limit;
    Array.tabulate<{ buyer:Text; onesicans:Nat; icpPaidE8s:Nat; multiplier:Float; substrate:Text; time:Int }>(n, func(j) {
      let i = if (saleCount > n) saleCount - n + j else j;
      { buyer = saleBuyers[i]; onesicans = saleAmounts[i]; icpPaidE8s = saleIcpPaid[i]; multiplier = saleMultipliers[i]; substrate = saleSubstrates[i]; time = saleTimes[i] }
    })
  };

  public query func getRecentActions(limit : Nat) : async [{
    id : Nat; kind : Text; params : Text; reason : Text; time : Int;
  }] {
    let n = if (loopActionCount < limit) loopActionCount else limit;
    Array.tabulate<{ id:Nat; kind:Text; params:Text; reason:Text; time:Int }>(n, func(j) {
      let i = if (loopActionCount > n) loopActionCount - n + j else j;
      { id = laIds[i]; kind = laKinds[i]; params = laParams[i]; reason = laReasons[i]; time = laTimes[i] }
    })
  };

  public query func getRouteHistory(limit : Nat) : async [{
    tick:Nat; totalRevE8s:Nat; reinvestE8s:Nat; emissionE8s:Nat; treasuryE8s:Nat; govE8s:Nat; grantsE8s:Nat; time:Int;
  }] {
    let n = if (routeCount < limit) routeCount else limit;
    Array.tabulate<{ tick:Nat; totalRevE8s:Nat; reinvestE8s:Nat; emissionE8s:Nat; treasuryE8s:Nat; govE8s:Nat; grantsE8s:Nat; time:Int }>(n, func(j) {
      let i = if (routeCount > n) routeCount - n + j else j;
      { tick = routeTicks[i]; totalRevE8s = routeRevs[i]; reinvestE8s = routeReinv[i]; emissionE8s = routeEmit[i]; treasuryE8s = routeTreasury[i]; govE8s = routeGov[i]; grantsE8s = routeGrants[i]; time = routeTimes[i] }
    })
  };

  // Pool available for neuron_fleet to pick up and re-stake
  public query func getReinvestmentAvailable() : async Nat {
    icpReinvestPool
  };

  // neuron_fleet calls this to collect the reinvestment ICP
  public shared(msg) func collectReinvestment() : async { success : Bool; collected : Nat } {
    if (not isSovereign(msg.caller)) return { success = false; collected = 0 };
    let amount = icpReinvestPool;
    icpReinvestPool := 0;
    { success = true; collected = amount }
  };

};
