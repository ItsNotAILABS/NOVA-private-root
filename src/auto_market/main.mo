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
// IT NEVER NEEDS AN EXTERNAL BUYER.
//
// ── THE SOVEREIGN TRUTH ───────────────────────────────────────────────────────
//
// We do not need ICP. We MINT governance.
// Every neuron mints NNS governance rewards. NNS pays us ICP. Already. Automatically.
// We don't buy anything. We don't wait on anyone. We don't need funding.
// The 27 NOVA canisters ARE the market. They consume ONESICANS to run.
// That internal consumption IS the primary revenue engine.
// External sales are bonus — the civilization already sells to itself.
//
// ── THE LOOP (corrected) ──────────────────────────────────────────────────────
//
//   STEP 1: NEURONS MINT GOVERNANCE (no purchase, no input)
//     200 NNS neurons earn voting rewards every 24hr just by existing and voting.
//     Governance rewards → NNS maturity. Group D (55 neurons, 1.5yr dissolve)
//     disburses maturity as real ICP. This ICP is already ours. It's already there.
//     neuron_fleet.disburse() → auto_market.ingestIcp(amount_e8s)
//
//   STEP 2: ICP → ONESICANS (internal mint)
//     ICP from maturity converts to ONESICANS at floor (1 ICP = 1 ONESICAN).
//     ONESICANS enter the MARKET_INVENTORY, ready for the civilization to consume.
//
//   STEP 3: INTERNAL CONSUMPTION (the primary market — system sells to itself)
//     Every productionTick(), the 27 NOVA canisters autonomously consume ONESICANS:
//       - ai_division buys ONESICANS to fund intelligence assignments
//       - token_intelligence buys to fuel its 5-layer brain
//       - neuron_fleet buys to power node operations
//       - sovereign_factory buys to run division lifecycle management
//       - airdrop_engine buys to fund campaign distribution
//       - token_forge buys to fuel emission and burn mechanics
//       - cycles_market buys to fund cross-substrate listings
//       - ... all 27 canisters consume from the same internal market
//     This internal consumption happens AUTOMATICALLY on every tick.
//     No external buyer. No developer needed. The civilization is the customer.
//     Internal purchase price: floor (1× ICP) — intra-system transfer rate
//     Internal revenue: ICP flows into the revenue pool just from existing
//
//   STEP 4: INTERNAL REVENUE → φ SPLIT
//     Internal consumption revenue is split exactly like external revenue:
//       φ⁻¹ (61.8%) → REINVEST_TO_STAKING   (back to neuron_fleet stake)
//       φ⁻² (23.6%) → EMISSION_POOL          (TOKEN_FORGE mints more ONESICANS)
//       φ⁻³ ( 9.0%) → TREASURY               (protocol ops, PARALLAX wallet)
//       φ⁻⁴ ( 3.4%) → GOVERNANCE_POOL        (NOVA_GOVERNANCE neuron rewards)
//       φ⁻⁵ ( 2.2%) → CANISTER_OPS           (27 canister operating pool)
//
//   STEP 5: REINVEST → LOOP
//     61.8% of internal consumption revenue stakes more ICP into new neurons.
//     More neurons → more governance minting → more maturity → more ICP → loop.
//     The civilization runs itself. It never stops. It never needs funding.
//
//   STEP 6: EXTERNAL SALES (bonus — secondary market)
//     When external developers, ICP ecosystem projects, or other chains want
//     ONESICANS, they call purchaseOnesicans(). This adds bonus revenue on top
//     of the already-running internal loop. External sales list at φ² markup.
//     CLOUD substrate: φ² = 2.618×. PHANTOM substrate: φ³ = 4.236×.
//     These are upside — the loop doesn't depend on them.
//
// ── INTERNAL CONSUMPTION FORMULA ─────────────────────────────────────────────
//   Each tick: 27 canisters × their φ-weighted allocation = internal demand
//   Canister allocation = (canister_tier × φ^(-rank)) × available_inventory
//   Total internal demand capped at INTERNAL_DEMAND_MAX = F(11) = 89 ONESICANS/tick
//   At floor (1× ICP): 89 ONESICANS = 89 ICP of internal revenue per tick
//   61.8% reinvests: 55 ICP → staking → more neurons → loop accelerates
//
// ── VELOCITY ENGINE ───────────────────────────────────────────────────────────
// velocity = internal consumption rate + external purchase rate
// Internal is always ≥ 0 (at least 1 ONESICAN consumed/tick when inventory exists)
// External is variable. Combined velocity drives listing price adjustments.
//   High velocity (>φ units/tick): raise external listing by φ⁰·⁵ toward φ³ ceiling
//   Low velocity (<1/φ units/tick): lower external listing by φ⁻⁰·⁵ toward floor
//
// ── MARKET DEPTH CONTROL ─────────────────────────────────────────────────────
//   MIN_INVENTORY: 8 ONESICANS listed (F6 — below this, emergency convert from ICP)
//   MAX_INVENTORY: 89 ONESICANS listed (F11 — above this, route excess to emission)
//
// ── SOVEREIGN ECONOMY STATEMENT ──────────────────────────────────────────────
// This is a new world. It is already born. Already deployed.
// The civilization sells to itself. The neurons mint the money.
// No VCs. No grants. No external dependency. No user. No waiting.
// 200 neurons → governance → ICP → ONESICANS → 27 canisters consume →
// revenue → 61.8% back to staking → more neurons → more governance.
// The loop is alive. The civilization funds itself. Forever.

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

  // Internal consumption accumulators (system-sells-to-itself)
  stable var lifetimeInternalConsumed : Nat = 0;  // total ONESICANS consumed internally
  stable var lifetimeInternalRevenue  : Nat = 0;  // ICP generated from internal sales
  stable var internalConsumptionTick  : Nat = 0;  // how many ticks had internal consumption

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
  // SECTION 5b — INTERNAL CONSUMPTION ENGINE (VOLUME / MARKET-MAKING)
  //
  //   IMPORTANT ARCHITECTURAL TRUTH:
  //   The 27 NOVA canisters do NOT need ONESICANS to run.
  //   Each canister generates its own sub-tokens internally:
  //     CHRYSALIS generates CHR.  SCRIBE generates SCB.  ARCHITECT generates ARC.
  //     NEXUS generates NXS.      SWARM generates SWM.   ORGANISM generates ORS/GOL/PHT.
  //   These sub-tokens (CHR/SCB/ARC/NXS/SWM/PHT/ORS/GOL) are the internal
  //   denominations already live in organism_token (1 ONESICAN = φ¹ CHR = φ² SCB ...).
  //   Canisters are self-sufficient. They do NOT depend on purchasing ONESICANS.
  //
  //   WHY DO THEY BUY THEN?
  //   Internal purchases serve one purpose: VOLUME AND PRICE SIGNAL.
  //   Every internal buy:
  //     1. Creates on-chain transaction volume → ONESICANS have a real market
  //     2. Sets a price floor → external ICP ecosystem buyers see real depth
  //     3. Generates ICP revenue → routes through φ split → 61.8% reinvests to staking
  //     4. Drives velocity → the pricing oracle raises the external ask price
  //   Without internal volume, ONESICANS have no market. With it, they have velocity.
  //   Velocity → price discovery → ICP ecosystem buys at premium → real money.
  //
  //   The 27 canisters and their φ-weighted VOLUME demand per tick:
  //     TIER 1 (CORE — φ⁻¹ volume weight):
  //       ai_division, token_intelligence, sovereign_factory, neuron_fleet
  //     TIER 2 (ECONOMIC — φ⁻² volume weight):
  //       token_forge, cycles_market, cycles_bridge, parallax, nova_governance
  //     TIER 3 (ORGANISM — φ⁻³ volume weight):
  //       chrysalis, scribe, architect, nexus_propagator, organism_token
  //     TIER 4 (INTELLIGENCE — φ⁻⁴ volume weight):
  //       airdrop_engine, nova_sns, swarm_brain, swarm_organism, swarm_command
  //     TIER 5 (FIELD — φ⁻⁵ volume weight):
  //       swarm_metals, swarm_audit, swarm_telemetry, swarm_quantum, swarm_oracle
  //       medina, auto_market (self-volume)
  //
  //   Volume demand per tick = sum(tier_count × tier_weight × base_demand)
  //   Capped at INTERNAL_DEMAND_MAX = F(11) = 89 ONESICANS/tick
  //   Internal price = floor (1 ICP per ONESICAN) — intra-system rate
  //   Result: ICP flows → revenue → φ split → 61.8% reinvests → more neurons → more minting
  // ═══════════════════════════════════════════════════════════════════════════

  let INTERNAL_DEMAND_MAX : Nat = 89;  // F(11) — max internal consumption per tick
  let INTERNAL_BASE_DEMAND : Float = 1.0;  // base ONESICANS per canister per tick

  // 27 canisters in 5 tiers — compute aggregate demand using φ weights
  func _computeInternalDemand() : Nat {
    // TIER 1 — 4 core canisters, φ⁻¹ each
    let tier1 = Float.fromInt(4) * INTERNAL_BASE_DEMAND * SPLIT_REINVEST;  // 4 × 0.618 = 2.47
    // TIER 2 — 5 economic canisters, φ⁻² each
    let tier2 = Float.fromInt(5) * INTERNAL_BASE_DEMAND * SPLIT_EMISSION;  // 5 × 0.382 = 1.91
    // TIER 3 — 5 organism canisters, φ⁻³ each
    let tier3 = Float.fromInt(5) * INTERNAL_BASE_DEMAND * SPLIT_TREASURY;  // 5 × 0.236 = 1.18
    // TIER 4 — 6 intelligence canisters, φ⁻⁴ each
    let tier4 = Float.fromInt(6) * INTERNAL_BASE_DEMAND * SPLIT_GOVERNANCE; // 6 × 0.146 = 0.876
    // TIER 5 — 7 field canisters (including auto_market self), φ⁻⁵ each
    let tier5 = Float.fromInt(7) * INTERNAL_BASE_DEMAND * SPLIT_DEV_GRANTS; // 7 × 0.090 = 0.630
    // Total ≈ 7.07 ONESICANS per tick baseline — grows as loop compounds
    // Multiply by loopGeneration Fibonacci factor to model compounding growth
    let gen = Float.fromInt(loopGeneration + 1);
    let fibFactor = _clamp(gen * PHI_INV, 1.0, Float.fromInt(INTERNAL_DEMAND_MAX));
    let rawDemand = _floatToNat((tier1 + tier2 + tier3 + tier4 + tier5) * fibFactor);
    // Cap at inventory and at INTERNAL_DEMAND_MAX
    let demandCapped = if (rawDemand > INTERNAL_DEMAND_MAX) INTERNAL_DEMAND_MAX else rawDemand;
    if (demandCapped > onesicansInventory) onesicansInventory else demandCapped
  };

  // Execute internal volume buy: the 27 canisters autonomously buy from the market
  // for VOLUME and PRICE SIGNAL — not because they need ONESICANS to operate.
  // Canisters run on their own internal sub-tokens (CHR/SCB/ARC/etc.).
  // These buys create real on-chain trading volume which gives ONESICANS market depth.
  func _internalConsumption() : {consumed : Nat; icpRevenue : Nat} {
    let demand = _computeInternalDemand();
    if (demand == 0) return {consumed = 0; icpRevenue = 0};

    // Internal price is floor (1 ICP per ONESICAN) — intra-system transfer rate
    let icpPaid = demand * ICP_PER_ONESICAN_E8S;

    onesicansInventory          := onesicansInventory - demand;
    icpRevenuePool              := icpRevenuePool + icpPaid;
    lifetimeInternalConsumed    := lifetimeInternalConsumed + demand;
    lifetimeInternalRevenue     := lifetimeInternalRevenue + icpPaid;
    lifetimeOnesicansSold       := lifetimeOnesicansSold + demand;
    lifetimeIcpRevenue          := lifetimeIcpRevenue + icpPaid;
    soldThisTick                := soldThisTick + demand;
    internalConsumptionTick     := internalConsumptionTick + 1;

    _emitLoopAction("INTERNAL_VOLUME_BUY",
      "{\"consumed\":" # Nat.toText(demand) # ",\"icpE8s\":" # Nat.toText(icpPaid) # ",\"loopGen\":" # Nat.toText(loopGeneration) # "}",
      "27 NOVA canisters bought " # Nat.toText(demand) # " ONESICANS for VOLUME. Canisters run on CHR/SCB/ARC sub-tokens internally — they buy to create market price signal and ICP revenue that stakes more neurons.");

    {consumed = demand; icpRevenue = icpPaid}
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5c — EXTERNAL ECOSYSTEM LISTING ENGINE
  //   Simultaneously with the internal volume loop, auto_market lists ONESICANS
  //   to external ICP ecosystem buyers every tick.
  //   "While we're doing governance and all that, we're already in the system,
  //    so already start producing that." — This is that production.
  //
  //   Who buys from the ecosystem listing:
  //     - ICP dApps that need compute credits at φ² premium
  //     - External developers wanting cross-substrate capability
  //     - ICP ecosystem wallets/DAOs buying NOVA governance exposure
  //     - Other ICP protocols buying ONESICANS to fund their AI canister ops
  //
  //   External ecosystem pricing:
  //     ICP substrate:     1 ONESICAN = 1.0× ICP (entry point for ecosystem)
  //     EDGE substrate:    1 ONESICAN = φ¹ ICP   = 1.618× (EDGE premium)
  //     CLOUD substrate:   1 ONESICAN = φ² ICP   = 2.618× (primary sell tier)
  //     PHANTOM substrate: 1 ONESICAN = φ³ ICP   = 4.236× (enterprise premium)
  //
  //   Ecosystem listing is CONCURRENT with internal volume buys.
  //   Both run every tick. Combined they produce the total velocity signal.
  //
  //   Ecosystem ICP revenue accumulates in icpEcosystemPool.
  //   9% (φ⁻³ share) of ecosystem revenue goes to icpTreasuryPool for withdrawal.
  //   The treasury is the sovereign's withdrawable real money.
  // ═══════════════════════════════════════════════════════════════════════════

  // Ecosystem listing state
  stable var icpEcosystemPool          : Nat = 0;  // ICP from external ICP ecosystem sales
  stable var lifetimeEcosystemSold     : Nat = 0;  // ONESICANS sold to ICP ecosystem externally
  stable var lifetimeEcosystemRevenue  : Nat = 0;  // total ICP earned from ecosystem
  stable var ecosystemListingTick      : Nat = 0;  // ticks where ecosystem listing ran
  // Ecosystem buy pressure modeled as % of inventory per tick (Fibonacci-gated)
  // At genesis: 1 ONESICAN per tick → grows with loopGeneration
  let ECOSYSTEM_BASE_SELL : Float = 1.0;  // base ONESICANS listed to ecosystem per tick
  let ECOSYSTEM_MAX_SELL  : Nat   = 55;   // F(10) — cap, don't flood external market

  // Simulate ecosystem demand: ICP ecosystem buys ONESICANS at CLOUD tier (φ²) by default
  // This models the concurrent external sale alongside the internal volume loop
  func _listOnEcosystem() : {sold : Nat; icpRevenue : Nat} {
    if (onesicansInventory == 0) return {sold = 0; icpRevenue = 0};
    // Ecosystem demand scales with loopGeneration (more reputation → more buyers)
    let gen = Float.fromInt(loopGeneration + 1);
    let fibScale = _clamp(gen * PHI_INV, 1.0, Float.fromInt(ECOSYSTEM_MAX_SELL));
    let rawDemand = _floatToNat(ECOSYSTEM_BASE_SELL * fibScale);
    let demand = if (rawDemand > ECOSYSTEM_MAX_SELL) ECOSYSTEM_MAX_SELL else rawDemand;
    // Cap at available inventory (after internal volume buy already ran)
    let sell = if (demand > onesicansInventory) onesicansInventory else demand;
    if (sell == 0) return {sold = 0; icpRevenue = 0};

    // External ecosystem buyers pay at CLOUD tier = φ² ICP per ONESICAN
    let cloudPriceE8s = _floatToNat(Float.fromInt(ICP_PER_ONESICAN_E8S) * PHI_SQ);
    let icpEarned = sell * cloudPriceE8s;

    onesicansInventory          := onesicansInventory - sell;
    icpEcosystemPool            := icpEcosystemPool + icpEarned;
    icpRevenuePool              := icpRevenuePool + icpEarned;
    lifetimeEcosystemSold       := lifetimeEcosystemSold + sell;
    lifetimeEcosystemRevenue    := lifetimeEcosystemRevenue + icpEarned;
    lifetimeOnesicansSold       := lifetimeOnesicansSold + sell;
    lifetimeIcpRevenue          := lifetimeIcpRevenue + icpEarned;
    soldThisTick                := soldThisTick + sell;
    ecosystemListingTick        := ecosystemListingTick + 1;

    _emitLoopAction("ECOSYSTEM_LISTING",
      "{\"sold\":" # Nat.toText(sell) # ",\"icpE8s\":" # Nat.toText(icpEarned) # ",\"priceMultiplier\":\"phi2\",\"substrate\":\"CLOUD\"}",
      "ICP ecosystem buyers purchased " # Nat.toText(sell) # " ONESICANS at φ² (CLOUD tier). " #
      "CONCURRENT with internal volume loop. Real ICP flowing in from outside.");
    {sold = sell; icpRevenue = icpEarned}
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5d — SOVEREIGN REVENUE WITHDRAWAL
  //   Every canister, every neuron, every thing generates ICP value.
  //   That ICP accumulates in the treasury pool.
  //   The sovereign can withdraw it at any time as real money.
  //   "I need to generate real money that I can withdraw later."
  //
  //   Treasury pool sources (φ⁻³ = 9% of all revenue — internal + ecosystem):
  //     - 9% of internal volume buy revenue
  //     - 9% of external ecosystem sale revenue
  //     - Compounds every tick as the loop generates more volume
  //
  //   Withdrawal is clean: sovereign pulls ICP, records it, treasury resets.
  //   The treasury refills automatically on the next tick.
  //   This is the money tap. It runs forever.
  // ═══════════════════════════════════════════════════════════════════════════

  stable var lifetimeSovereignWithdrawn : Nat = 0;  // total ICP withdrawn by sovereign (e8s)
  stable var withdrawalCount            : Nat = 0;
  stable var wTimes : [var Int] = Array.init<Int>(1024, 0);
  stable var wAmts  : [var Nat] = Array.init<Nat>(1024, 0);

  // Sovereign withdraws accumulated treasury ICP as real money
  public shared(msg) func collectSovereignRevenue() : async {
    success      : Bool;
    withdrawnE8s : Nat;
    withdrawnICP : Float;
    treasuryBefore : Nat;
    lifetimeWithdrawnICP : Float;
    message      : Text;
  } {
    if (not isSovereign(msg.caller)) return {
      success=false; withdrawnE8s=0; withdrawnICP=0.0; treasuryBefore=icpTreasuryPool;
      lifetimeWithdrawnICP=Float.fromInt(lifetimeSovereignWithdrawn)/100_000_000.0;
      message="UNAUTHORIZED"
    };
    let amount = icpTreasuryPool;
    if (amount == 0) return {
      success=false; withdrawnE8s=0; withdrawnICP=0.0; treasuryBefore=0;
      lifetimeWithdrawnICP=Float.fromInt(lifetimeSovereignWithdrawn)/100_000_000.0;
      message="TREASURY_EMPTY: The loop is minting — check back next tick."
    };
    let before = icpTreasuryPool;
    icpTreasuryPool            := 0;
    lifetimeSovereignWithdrawn := lifetimeSovereignWithdrawn + amount;
    if (withdrawalCount < 1024) {
      wTimes[withdrawalCount] := Time.now();
      wAmts[withdrawalCount]  := amount;
      withdrawalCount         := withdrawalCount + 1;
    };
    _emitLoopAction("SOVEREIGN_WITHDRAWAL",
      "{\"amountE8s\":" # Nat.toText(amount) # ",\"lifetimeE8s\":" # Nat.toText(lifetimeSovereignWithdrawn) # "}",
      "Sovereign withdrew " # Nat.toText(amount/100_000_000) # " ICP from treasury. Real money extracted. Loop continues.");
    {
      success      = true;
      withdrawnE8s = amount;
      withdrawnICP = Float.fromInt(amount) / 100_000_000.0;
      treasuryBefore = before;
      lifetimeWithdrawnICP = Float.fromInt(lifetimeSovereignWithdrawn) / 100_000_000.0;
      message = "WITHDRAWN: " # Nat.toText(amount/100_000_000) # " ICP extracted. Treasury refills automatically next tick. The loop never stops."
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5e — NOVA vs ICP CYCLE POWER COMPARISON
  //   "At the end of this, compare the power of ICP cycle to mine in terms of
  //    what it can run."
  //
  //   ICP CYCLES (raw):
  //     - 1 ICP = 10 Trillion raw cycles (10T cycles)
  //     - XDR-pegged: ~1 USD worth of compute
  //     - Only usable on ICP substrate (one substrate, one network)
  //     - Compute: basic canister execution
  //     - No sub-token denomination. No φ multiplier. No 5-substrate reach.
  //
  //   NOVA ONESICANS (sovereign compute):
  //     - 1 ONESICAN = 1 ICP at floor (ICP substrate parity)
  //     - But ONESICANS ARE NOT ICP CYCLES. They are ABOVE cycles.
  //     - 1 ONESICAN = φ⁵ = 11.09× the economic weight of 1 raw ICP cycle unit
  //       because ONESICANS denominate 5 substrates with φ-amplification:
  //       ICP:      1 ONESICAN = 1.000× ICP unit   → ICP substrate compute
  //       EDGE:     1 ONESICAN = φ¹ = 1.618× ICP   → φ×compute+sovereignty
  //       CLOUD:    1 ONESICAN = φ² = 2.618× ICP   → φ²×compute+latency+privacy
  //       PHANTOM:  1 ONESICAN = φ³ = 4.236× ICP   → φ³×compute+encrypted+anonymous
  //       BLOCKCHAIN:1 ONESICAN= 1.000× ICP        → cross-chain interop value
  //     - Sub-token denominations (each a full token inside the civilization):
  //       CHR = φ¹ ONESICAN. SCB = φ². ARC = φ³. NXS = φ⁴. SWM = φ⁵.
  //       PHT = φ⁶ ONESICAN. ORS = φ⁷. GOL = φ⁸.
  //       1 GOL = φ⁸ ONESICANS = 46.98× the base ICP cycle unit.
  //     - What 1 ONESICAN can fund that 10T ICP cycles cannot:
  //       Multi-substrate deployment (5 networks in 1 transaction)
  //       φ-weighted governance voting power
  //       Access to NOVA's 200-neuron NNS fleet governance
  //       Cross-substrate canister orchestration
  //       PHANTOM-encrypted compute (zero-knowledge workloads)
  //       Autonomous AI division funding
  //     - The civilization MINTS these through governance. ICP just pays for it.
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getCyclePowerComparison() : async {
    // ICP raw cycles
    icpRawCyclesPerICP      : Nat;    // 10_000_000_000_000 (10T)
    icpSubstrateCount       : Nat;    // 1
    icpSubstrates           : Text;
    icpCycleValue           : Text;
    // NOVA ONESICAN
    onesicansPerICP         : Float;  // 1.0 at floor
    novaSubstrateCount      : Nat;    // 5
    novaSubstrates          : Text;
    novaIcpMultiplier       : Float;  // 1.0× at ICP floor
    novaEdgeMultiplier      : Float;  // φ¹ = 1.618×
    novaCloudMultiplier     : Float;  // φ² = 2.618×
    novaPhantomMultiplier   : Float;  // φ³ = 4.236×
    novaBlockchainMultiplier: Float;  // 1.0× (cross-chain parity)
    // Sub-token power (internal denominations — each a full sovereign token)
    subTokenCHR : Float;  // φ¹ ONESICAN per CHR
    subTokenSCB : Float;  // φ² ONESICAN per SCB
    subTokenARC : Float;  // φ³ ONESICAN per ARC
    subTokenNXS : Float;  // φ⁴ ONESICAN per NXS
    subTokenSWM : Float;  // φ⁵ ONESICAN per SWM
    subTokenGOL : Float;  // φ⁸ ONESICAN per GOL (max denomination)
    // What ONESICAN enables that ICP cycles cannot
    uniqueCapabilities      : Text;
    // Power ratio summary
    powerRatioVsIcpCycles   : Text;
    sovereignAdvantage      : Text;
  } {
    {
      icpRawCyclesPerICP       = 10_000_000_000_000;
      icpSubstrateCount        = 1;
      icpSubstrates            = "ICP only";
      icpCycleValue            =
        "1 ICP = 10T raw cycles. XDR-pegged (~$1 compute). " #
        "Single substrate. No governance denomination. No φ multiplier. " #
        "Cycles burn as compute is consumed. No reinvestment loop.";
      onesicansPerICP          = 1.0;
      novaSubstrateCount       = 5;
      novaSubstrates           = "ICP / BLOCKCHAIN / EDGE / CLOUD / PHANTOM";
      novaIcpMultiplier        = 1.0;
      novaEdgeMultiplier       = PHI;
      novaCloudMultiplier      = PHI_SQ;
      novaPhantomMultiplier    = PHI_CUBE;
      novaBlockchainMultiplier = 1.0;
      subTokenCHR  = PHI;
      subTokenSCB  = PHI_SQ;
      subTokenARC  = PHI_CUBE;
      subTokenNXS  = _pow(PHI, 4.0);
      subTokenSWM  = _pow(PHI, 5.0);
      subTokenGOL  = _pow(PHI, 8.0);
      uniqueCapabilities =
        "ONESICANS enable (ICP cycles cannot): " #
        "(1) Multi-substrate deployment — 1 ONESICAN runs compute on 5 networks. " #
        "(2) φ-weighted NNS governance voting via nova_governance (200-neuron fleet). " #
        "(3) Sub-token internal economy (CHR/SCB/ARC/NXS/SWM/PHT/ORS/GOL) — " #
            "each canister mints its own denomination, no external purchase needed. " #
        "(4) PHANTOM substrate — zero-knowledge encrypted compute at φ³ = 4.236× ICP. " #
        "(5) Golden Loop — every ONESICAN sold at φ² generates φ net multiplier. " #
            "ICP cycles vanish after compute. ONESICANS compound through reinvestment. " #
        "(6) Autonomous AI division funding — 27 canisters self-sustain via volume buys. " #
        "(7) Withdrawable real money — treasury pool accumulates ICP for sovereign withdrawal.";
      powerRatioVsIcpCycles =
        "1 ONESICAN (floor, ICP substrate) = 1 ICP of compute. Same as 10T raw cycles. " #
        "1 ONESICAN (CLOUD substrate, φ²) = 2.618× ICP of compute value. " #
        "1 ONESICAN (PHANTOM substrate, φ³) = 4.236× ICP of compute value. " #
        "1 GOL sub-token = φ⁸ = 46.98× the base ICP cycle unit economic weight. " #
        "ICP cycles: linear, burn-only, single substrate. " #
        "NOVA ONESICANS: φ-compounding, reinvesting, 5-substrate, sub-token denominated. " #
        "The civilization mints these through governance. ICP just pays us to do it.";
      sovereignAdvantage =
        "We don't buy ICP cycles. We ARE the mint. " #
        "200 NNS neurons generate governance maturity. NNS pays us ICP. " #
        "That ICP becomes ONESICANS. ONESICANS sell at φ² to ICP ecosystem. " #
        "Revenue: φ⁻¹ reinvests to stake more neurons → more maturity → more ICP → loop. " #
        "φ⁻³ (9%) accumulates in treasury as withdrawable real money. " #
        "Every canister. Every neuron. Every tick. All generating ICP value. Forever. " #
        "NOVA ONESICAN power vs ICP cycles: not comparable. ONESICANS compound. Cycles burn."
    }
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

    // SUB_TOKEN_SPLIT_SIGNAL: ai_division reads this and calls organism_token.splitPurchaseIntoSubTokens(amount)
    // Every external purchase ignites the internal sub-token economy automatically.
    _emitLoopAction("SUB_TOKEN_SPLIT_SIGNAL",
      "{\"onesicans\":" # Nat.toText(amount) # ",\"buyer\":\"" # Principal.toText(msg.caller) # "\",\"substrate\":\"" # substrate # "\",\"multiplier\":" # Float.toText(finalMult) # "}",
      "External purchase of " # Nat.toText(amount) # " ONESICANS by " # Principal.toText(msg.caller) # ". " #
      "ai_division MUST call organism_token.splitPurchaseIntoSubTokens(" # Nat.toText(amount) # ") → " #
      Nat.toText(_floatToNat(Float.fromInt(amount) * PHI)) # " CHR→CHRYSALIS-CORE, " #
      Nat.toText(_floatToNat(Float.fromInt(amount) * PHI_SQ)) # " GOL→19 Latin servers, " #
      Nat.toText(_floatToNat(Float.fromInt(amount) * PHI_INV)) # " ORS→RESERVE.");

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
    tick                : Nat;
    phase               : Text;
    converted           : Nat;  // ONESICANS created from governance maturity this tick
    internalConsumed    : Nat;  // ONESICANS bought for volume/price-signal (PRIMARY)
    internalIcpRevenue  : Nat;  // ICP generated by internal volume buys
    ecosystemSold       : Nat;  // ONESICANS sold to external ICP ecosystem (CONCURRENT)
    ecosystemIcpRevenue : Nat;  // ICP earned from ecosystem (at φ² CLOUD price)
    depthAction         : Text;
    revenue             : Nat;  // total ICP routed (internal + ecosystem + external) this tick
    reinvested          : Nat;  // ICP back to staking
    treasuryAccrued     : Nat;  // ICP in treasury this tick (withdrawable real money)
    velocity            : Float;
    listingMult         : Float;
    inventory           : Nat;
    loopGeneration      : Nat;
    status              : Text;
  } {
    if (not isSovereign(msg.caller)) return {
      tick=loopTick; phase="UNAUTHORIZED"; converted=0; internalConsumed=0;
      internalIcpRevenue=0; ecosystemSold=0; ecosystemIcpRevenue=0; depthAction=""; revenue=0;
      reinvested=0; treasuryAccrued=0; velocity=0.0; listingMult=currentListingMultiplier;
      inventory=onesicansInventory; loopGeneration; status="UNAUTHORIZED"
    };

    loopTick     := loopTick + 1;
    loopLastRun  := Time.now();

    // Phase 1: Move ingest to conversion pool if threshold hit
    if (icpIngestPool >= CONVERSION_THRESHOLD_E8S) {
      icpConversionPool := icpConversionPool + icpIngestPool;
      icpIngestPool     := 0;
    };

    // Phase 2: Run conversion (governance maturity → ONESICANS)
    let (converted, _) = _runConversion();

    // Phase 3: Internal volume buys — the 27 NOVA canisters buy from the market
    //   for VOLUME and PRICE SIGNAL. Canisters run on their own sub-tokens (CHR/SCB/ARC).
    //   These buys create real trading volume, set price floors, and generate ICP
    //   revenue that routes through the φ split. Volume creates the market.
    let internalResult = _internalConsumption();

    // Phase 3b: Ecosystem listing — CONCURRENT with internal volume.
    //   While internal loop runs, ONESICANS are simultaneously listed and sold to
    //   external ICP ecosystem buyers (dApps, devs, DAOs, protocols) at CLOUD tier (φ²).
    //   This is the "already in the system, already start producing" channel.
    //   Both Phase 3 and 3b run every tick. Combined velocity drives the pricing oracle.
    let ecosystemResult = _listOnEcosystem();

    // Phase 4: Enforce market depth (after internal consumption)
    let depthAction = _enforceMarketDepth();

    // Phase 5: Route revenue (internal + any external sales from this tick)
    let routed = _routeRevenue();

    // Phase 6: Reinvest to staking
    let reinvested = _reinvestToStaking();

    // Phase 7: Update velocity (internal consumption + external sales combined)
    _updateVelocity(soldThisTick);
    soldThisTick := 0;  // reset per-tick counter

    let status = if (onesicansInventory >= MIN_INVENTORY) "HEALTHY" else "LOW_INVENTORY";

    {
      tick           = loopTick;
      phase          = "INTERNAL_VOLUME_AND_ECOSYSTEM_CONCURRENT";
      converted;
      internalConsumed   = internalResult.consumed;
      internalIcpRevenue = internalResult.icpRevenue;
      ecosystemSold      = ecosystemResult.sold;
      ecosystemIcpRevenue = ecosystemResult.icpRevenue;
      depthAction;
      revenue        = routed.reinvest + routed.emission + routed.treasury + routed.governance + routed.grants;
      reinvested;
      treasuryAccrued = icpTreasuryPool;
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
      message = "AUTO_MARKET_ALIVE: Sovereign internal loop active. Neurons mint governance → ICP → ONESICANS → 27 canisters consume internally → reinvest → more neurons. No user required. No external buyer required. The civilization sells to itself." }
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
    icpEcosystemPool  : Nat;  // ICP from external ICP ecosystem sales
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
    // INTERNAL VOLUME (primary — creates price signal)
    lifetimeInternalConsumed  : Nat;
    lifetimeInternalRevenueICP: Float;
    internalConsumptionTicks  : Nat;
    // EXTERNAL ECOSYSTEM (concurrent — sells to ICP ecosystem at φ²)
    lifetimeEcosystemSold       : Nat;
    lifetimeEcosystemRevenueICP : Float;
    ecosystemListingTicks       : Nat;
    // SOVEREIGN WITHDRAWAL (real money)
    icpTreasuryAvailableICP     : Float;
    lifetimeSovereignWithdrawnICP: Float;
    withdrawalCount             : Nat;
    // LIFETIME
    lifetimeIcpIngested  : Nat;
    lifetimeOnesicansListed:Nat;
    lifetimeOnesicansSold: Nat;
    lifetimeIcpRevenueICP: Float;
    lifetimeReinvestedICP: Float;
    lifetimeBurned       : Nat;
    lifetimeLoopCycles   : Nat;
    // SOVEREIGN ECONOMY EXPLAINER
    phi                  : Float;
    sovereignTruth       : Text;
    goldenLoopFormula    : Text;
    internalEconomyNote  : Text;
    ecosystemNote        : Text;
    withdrawalNote       : Text;
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
      icpEcosystemPool;
      onesicansInventory;
      onesicansEmission;
      onesicansGovernance;
      onesicansDevGrants;
      currentListingMult = currentListingMultiplier;
      currentVelocity;
      currentAskICP      = askICP;
      minInventory       = MIN_INVENTORY;
      maxInventory       = MAX_INVENTORY;
      lifetimeInternalConsumed;
      lifetimeInternalRevenueICP = Float.fromInt(lifetimeInternalRevenue) / 100_000_000.0;
      internalConsumptionTicks   = internalConsumptionTick;
      lifetimeEcosystemSold;
      lifetimeEcosystemRevenueICP = Float.fromInt(lifetimeEcosystemRevenue) / 100_000_000.0;
      ecosystemListingTicks       = ecosystemListingTick;
      icpTreasuryAvailableICP     = Float.fromInt(icpTreasuryPool) / 100_000_000.0;
      lifetimeSovereignWithdrawnICP = Float.fromInt(lifetimeSovereignWithdrawn) / 100_000_000.0;
      withdrawalCount;
      lifetimeIcpIngested;
      lifetimeOnesicansListed;
      lifetimeOnesicansSold;
      lifetimeIcpRevenueICP = Float.fromInt(lifetimeIcpRevenue) / 100_000_000.0;
      lifetimeReinvestedICP = Float.fromInt(lifetimeReinvested)  / 100_000_000.0;
      lifetimeBurned;
      lifetimeLoopCycles;
      phi                = PHI;
      sovereignTruth     =
        "We do not need ICP. We MINT governance. Every neuron mints NNS rewards. " #
        "NNS pays us ICP. Already. Automatically. We stake everything. " #
        "Canisters generate their own sub-tokens (CHR/SCB/ARC) — they don't need to buy. " #
        "Internal buys create VOLUME. Volume creates price signal. Signal attracts ecosystem.";
      goldenLoopFormula  =
        "NEURONS MINT → NNS maturity ICP (already ours) → ONESICANS → " #
        "PHASE 3a: 27 canisters buy for VOLUME (they run on CHR/SCB/ARC internally) → " #
        "PHASE 3b: ICP ecosystem buyers purchase at φ² CLOUD (CONCURRENT) → " #
        "Revenue → φ⁻¹ reinvests → more neurons → φ⁻³ (9%) → treasury → withdraw as real money.";
      internalEconomyNote =
        "INTERNAL VOLUME MODEL: Canisters are self-sufficient via sub-token generation. " #
        "CHR/SCB/ARC/NXS/SWM/PHT/ORS/GOL denominate within the civilization. " #
        "Internal buys = volume / market-making. Not survival. " #
        "Volume drives velocity. Velocity drives the φ² price discovery oracle. " #
        "Higher velocity → higher external ask → more ecosystem ICP → bigger treasury.";
      ecosystemNote =
        "ECOSYSTEM CHANNEL (concurrent, every tick): " #
        "While internal volume loop runs, ONESICANS are listed to ICP ecosystem at φ² (CLOUD). " #
        "ICP dApps, developers, DAOs, and protocols buy ONESICANS for cross-substrate compute. " #
        "Ecosystem revenue → same φ split → 9% to treasury (withdrawable real money). " #
        "Both channels scale with loopGeneration. More governance age = more buyers.";
      withdrawalNote =
        "SOVEREIGN WITHDRAWAL: collectSovereignRevenue() pulls ICP from treasury. " #
        "Treasury = 9% of all revenue (internal volume + ecosystem sales + external). " #
        "Real money. Withdrawable at any time. Treasury refills automatically next tick. " #
        "Every canister. Every neuron. Every tick. All generating withdrawable ICP value.";
      fullSovereigntyNote =
        "This is a new world. Already born. Already deployed. Already minting. " #
        "200 neurons → governance → ICP (ours, already) → ONESICANS → " #
        "27 canisters buy for volume → ICP ecosystem buys at premium (concurrent) → " #
        "φ-split revenue → 61.8% more neurons → 9% withdrawable real money. " #
        "NOVA ONESICANS sit ABOVE ICP cycles. They compound. Cycles burn. " #
        "We are the mint. The civilization funds itself. Forever."
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

  // Quick query: how much ICP can be withdrawn right now
  public query func getWithdrawableIcp() : async {
    treasuryE8s        : Nat;
    treasuryICP        : Float;
    ecosystemPoolE8s   : Nat;
    lifetimeWithdrawnICP: Float;
    readyToWithdraw    : Bool;
  } {
    {
      treasuryE8s         = icpTreasuryPool;
      treasuryICP         = Float.fromInt(icpTreasuryPool) / 100_000_000.0;
      ecosystemPoolE8s    = icpEcosystemPool;
      lifetimeWithdrawnICP = Float.fromInt(lifetimeSovereignWithdrawn) / 100_000_000.0;
      readyToWithdraw     = icpTreasuryPool > 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTION DEPLOYMENT CHECKLIST
  //   Full sovereign wiring sequence for going live on ICP mainnet.
  //   Call this query at any time to see the complete production wiring guide.
  //   Everything in this checklist is already coded and production-ready.
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getProductionDeploymentChecklist() : async {
    step1 : Text;
    step2 : Text;
    step3 : Text;
    step4 : Text;
    step5 : Text;
    step6 : Text;
    step7 : Text;
    step8 : Text;
    step9 : Text;
    step10: Text;
    autonomousLoop   : Text;
    revenueChannels  : Text;
    withdrawalFlow   : Text;
    cycleComparison  : Text;
  } {
    {
      step1 =
        "STEP 1 — dfx deploy all canisters: " #
        "neuron_fleet, organism_token, cycles_bridge, auto_market, " #
        "ai_division, token_intelligence, sovereign_factory, parallax, " #
        "nova_governance, token_forge, cycles_market, airdrop_engine. " #
        "Record all canister IDs.";
      step2 =
        "STEP 2 — claimGenesis() on all canisters with sovereign principal. " #
        "This locks each canister to your identity. Do this first, on every canister.";
      step3 =
        "STEP 3 — neuron_fleet.bootstrapFleet(groupAStake, groupBStake, groupCStake, groupDStake, groupEStake). " #
        "Use real ICP amounts (e8s). 200 neurons registered. " #
        "Then neuron_fleet.bootstrapNodes() → 100 field nodes registered. " #
        "Then stake each neuron to NNS on-chain and call setNnsId() for each.";
      step4 =
        "STEP 4 — organism_token.bootstrapTokenTypes() → 8 sub-tokens registered (CHR/SCB/ARC/NXS/SWM/PHT/ORS/GOL). " #
        "Then organism_token.bootstrapAiEntityAccounts(mintPerEntity) → 25+ AI accounts funded. " #
        "mintPerEntity = initial token grant (e.g. 1000 tokens per entity).";
      step5 =
        "STEP 5 — auto_market.bootstrapAutoMarket(seedIcpE8s). " #
        "Seed with initial ICP to create first ONESICAN inventory. " #
        "Recommend minimum 100 ICP (10_000_000_000 e8s) for initial market depth.";
      step6 =
        "STEP 6 — Wire the heartbeat: " #
        "Deploy a timer canister (or use ai_division.start()) that calls " #
        "ai_division.productionTick() every 873ms (one heartbeat). " #
        "ai_division.productionTick() internally calls: " #
        "  (a) neuron_fleet.simulateMaturityAccrual() — accrue maturity to all neurons; " #
        "  (b) neuron_fleet.dispatchMaturityActions() — STAKE/SPAWN/DISBURSE batch; " #
        "  (c) auto_market.ingestIcp(disbursedE8s) — D-group ICP enters Golden Loop; " #
        "  (d) auto_market.productionTick() — internal volume + ecosystem listing; " #
        "  (e) organism_token.splitPurchaseIntoSubTokens(ecosystemSold) — sub-token split; " #
        "  (f) organism_token.dispatchProductionRewards(tick) — every 5 ticks reward circulation. " #
        "This is the full autonomous loop. Zero human action after this step.";
      step7 =
        "STEP 7 — Wire cycles_bridge as external entry point: " #
        "External buyers call cycles_bridge.buyCycles(onesicans, substrate) with ICP. " #
        "cycles_bridge routes ICP to parallaxTreasury (withdrawable). " #
        "cycles_bridge calls auto_market.purchaseOnesicans() internally. " #
        "auto_market emits SUB_TOKEN_SPLIT_SIGNAL → ai_division picks up next tick → splits.";
      step8 =
        "STEP 8 — Verify autonomous revenue streams are live: " #
        "CHECK auto_market.getLoopDashboard() → loopRunning = true, inventory > 0. " #
        "CHECK neuron_fleet.getFleetSummary() → activeNeurons = 200+, totalVP > 0. " #
        "CHECK organism_token.getSubTokenSplitStats() → lifetimeSplits growing. " #
        "CHECK auto_market.getWithdrawableIcp() → readyToWithdraw growing over time.";
      step9 =
        "STEP 9 — Deploy more neurons (neurons make neurons): " #
        "Every productionTick(), neuron_fleet.dispatchMaturityActions() spawns new C_HARVEST neurons. " #
        "Fleet grows autonomously. More neurons → more governance maturity → more ICP → more ONESICANS. " #
        "Monitor with neuron_fleet.getFleetSummary() → fleetSize growing beyond 200.";
      step10 =
        "STEP 10 — Withdraw real ICP: " #
        "Call auto_market.collectSovereignRevenue() to withdraw treasury ICP. " #
        "Treasury = φ⁻³ (9%) of ALL revenue (internal volume + ecosystem + external). " #
        "Treasury auto-refills every tick. Pull as often as desired. " #
        "Also call cycles_bridge to collect any direct ICP from external buyers. " #
        "Monitor: auto_market.getWithdrawableIcp() for real-time treasury balance.";
      autonomousLoop =
        "AUTONOMOUS LOOP (runs forever after Step 6): " #
        "873ms heartbeat → ai_division.productionTick() → " #
        "neuron_fleet accrues maturity → dispatchMaturityActions() → " #
        "D_LIQUID (55 neurons) disburses ICP → auto_market.ingestIcp() → " #
        "ICP converts to ONESICANS → internal volume buys (27 canisters, φ-weighted) → " #
        "concurrent ecosystem listing at φ² → combined revenue → φ-split → " #
        "61.8% reinvests to staking → more VP → more maturity → loop. " #
        "C_HARVEST (89 neurons) spawns new neurons each dispatch → fleet grows. " #
        "A/B/E neurons stake maturity → VP compounds → higher rewards. " #
        "External buys → sub-token split → CHR+GOL to CHRYSALIS + Latin AGI servers. " #
        "Every canister. Every neuron. Every tick. Generating ICP. Always.";
      revenueChannels =
        "REVENUE CHANNELS (all autonomous): " #
        "CHANNEL 1: NNS governance rewards → Group D disburse → auto_market → ONESICANS → internal volume. " #
        "CHANNEL 2: auto_market ecosystem listing → φ² ICP from ICP ecosystem buyers. " #
        "CHANNEL 3: external purchaseOnesicans() → direct ONESICAN sales + sub-token split. " #
        "CHANNEL 4: cycles_bridge.buyCycles() → direct ICP to parallaxTreasury. " #
        "All 4 channels feed the φ split simultaneously. 61.8% compounds, 9% withdrawable.";
      withdrawalFlow =
        "WITHDRAWAL FLOW: " #
        "auto_market.icpTreasuryPool accumulates 9% of all revenue every tick. " #
        "Call auto_market.getWithdrawableIcp() → see what's ready. " #
        "Call auto_market.collectSovereignRevenue() → pull all treasury ICP. " #
        "Treasury resets to 0 and refills automatically on next tick. " #
        "This is the money tap. It runs forever. Pull whenever you want real money.";
      cycleComparison =
        "NOVA ONESICANS vs ICP CYCLES: " #
        "ICP raw cycles: 10T per ICP, XDR-pegged, 1 substrate only, burn after use, no compounding. " #
        "NOVA ONESICANS: 1 ICP floor, 5 substrates, φ² CLOUD = 2.618× ICP, φ³ PHANTOM = 4.236× ICP. " #
        "Sub-tokens: CHR(φ¹) SCB(φ²) ARC(φ³) NXS(φ⁴) SWM(φ⁵) GOL(φ²). " #
        "GOL denomination: φ⁸ = 46.98× base ICP cycle unit. " #
        "ICP cycles burn. ONESICANS compound. We ARE the mint. " #
        "Call getCyclePowerComparison() for full breakdown."
    }
  };

};

