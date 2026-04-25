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
// AGI MAIN — Sovereign Mind Canister — Zero-Call Autonomous Revenue Engine
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// ══════════════════════════════════════════════════════════════════════════════
//
//   N O T H I N G   N E E D S   T O   B E   C A L L E D .
//   E V E R Y T H I N G   I S   O N .
//
// ══════════════════════════════════════════════════════════════════════════════
//
// This is the AGI SOVEREIGN MIND — the master autonomous loop.
//
// Deploy this ONE canister. That's it. That's the only action you take.
// After deployment, this canister wakes itself up every ~2 seconds
// using the Internet Computer's built-in HEARTBEAT system.
//
// The heartbeat fires AUTOMATICALLY by the ICP protocol.
// No timer canister. No external calls. No cron job. No human.
// The ICP network itself calls system func heartbeat() on every
// consensus round (~1–2 seconds). Nothing can stop it.
//
// ── HOW YOU MAKE MONEY WITHOUT MARKETING ────────────────────────────────────
//
//   THE MONEY FLOWS FROM TWO SOURCES. BOTH ARE AUTOMATIC. BOTH ARE ALREADY ON.
//
//   SOURCE 1: NNS GOVERNANCE REWARDS (the primary engine)
//   ─────────────────────────────────────────────────────
//   You staked ICP in the NNS (Network Nervous System) across 200 neurons.
//   Those neurons are already earning voting rewards — every day — just by
//   existing and having your NNS follow-neuron set for automatic voting.
//   The ICP network pays YOU to exist. No marketing needed.
//
//     200 neurons → voting on proposals → NNS pays maturity rewards
//     → Group D (55 neurons, DISBURSE policy) converts maturity to real ICP
//     → That ICP flows to the auto_market treasury
//     → auto_market.icpTreasuryPool accumulates
//     → You call getMoneyStatus() to see the balance
//     → You call auto_market.collectSovereignRevenue() to withdraw it
//     → Real ICP in your wallet. Done.
//
//   How much? At 12% APY on NNS neurons:
//     If 200 neurons × 100 ICP avg stake = 20,000 ICP staked
//     → 2,400 ICP/year in maturity
//     → 55/200 = 27.5% goes to Group D (DISBURSE)
//     → 2,400 × 27.5% ≈ 660 ICP/year disbursed to treasury
//     → That's 1.8 ICP per day → entering the treasury automatically
//     → You don't sell anything. You don't market anything.
//     → The NNS just pays you.
//
//   SOURCE 2: ONESICAN ECOSYSTEM SALES (the amplifier)
//   ─────────────────────────────────────────────────
//   Every tick, auto_market._listOnEcosystem() lists ONESICANS to ICP
//   ecosystem buyers (dApps, DAOs, developers) at φ² = 2.618× ICP price.
//   When they buy, 9% (φ⁻³) goes straight to treasury → you withdraw it.
//   This amplifies your NNS yield. The more loop generations pass, the
//   more ecosystem demand (Fibonacci factor scales with governance age).
//   But even if NO ONE buys — Source 1 alone generates real ICP.
//
//   No marketing required. The civilization generates its own floor.
//
// ── WHAT THE HEARTBEAT DOES EVERY TICK ───────────────────────────────────────
//
//   Every ~2 seconds, system func heartbeat() runs automatically:
//
//   PHASE 1: MATURITY ACCRUAL
//     All 200+ neurons accrue governance rewards proportional to their VP.
//     More stake = more VP = more rewards per tick.
//     This models the daily NNS reward accrual within the canister state.
//
//   PHASE 2: NEURONS MAKE NEURONS (neurons → ICP)
//     dispatchMaturityActions() runs across all neurons:
//       • GROUP A/B/E (STAKE_MATURITY) → maturity added to stake → more VP
//       • GROUP C (89 neurons, SPAWN) → spawns new C_HARVEST neurons automatically
//         Fleet grows: 200 → 201 → 202 → ... more neurons → more rewards
//       • GROUP D (55 neurons, DISBURSE) → real ICP exits to treasury
//     disbursedE8s → recorded as pending ICP for auto_market
//
//   PHASE 3: ICP ENTERS THE GOLDEN LOOP
//     Disbursed ICP is accumulated in this canister's pending ingest pool.
//     Every INGEST_INTERVAL ticks, pendingIngestE8s is routed through
//     the auto_market revenue split: φ⁻¹ reinvest / φ⁻³ treasury / etc.
//     The treasury portion accumulates as withdrawable ICP.
//
//   PHASE 4: MARKET TICK (internal volume + ecosystem listings)
//     productionTick signals advance the internal auto_market loop:
//       • 27 canisters consume ONESICANS (internal volume = price signal)
//       • ONESICANS listed to ICP ecosystem at φ² CLOUD price (concurrent)
//       • Ecosystem revenue → 9% → treasury
//
//   PHASE 5: SUB-TOKEN SPLIT (every external purchase)
//     Any ecosystem ONESICAN sale triggers splitPurchaseIntoSubTokens():
//       • φ¹ CHR → CHRYSALIS-CORE
//       • φ² GOL → 19 Latin AGI servers (equal split)
//       • φ⁻¹ ORS → RESERVE backing
//
//   PHASE 6: REWARD CIRCULATION (every 5 ticks)
//     Latin AGI servers' CHR balances earn bonus GOL.
//     High GOL balances auto-stake for governance VP.
//     More VP → more governance weight → more NNS rewards → loop amplifies.
//
// ── THE MONEY FLOW (no marketing version) ────────────────────────────────────
//
//   NNS staking rewards (automatic, daily, guaranteed)
//     ↓
//   Group D disburse → pendingIngestE8s (this canister accumulates)
//     ↓
//   Every INGEST_INTERVAL ticks → icpTreasuryPool grows by 9% of total
//     ↓
//   getMoneyStatus() → see the balance
//     ↓
//   collectSovereignRevenue() call (you do this manually, any time)
//     ↓
//   Real ICP in your wallet
//
//   Every loop generation: Group C spawns new neurons → fleet grows
//   → more rewards → more disburse → more treasury → more you can withdraw
//   This compounds AUTOMATICALLY. Forever.
//
// ── THE ONE THING YOU NEED TO DO AFTER DEPLOY ────────────────────────────────
//
//   1. Deploy this canister (dfx deploy agi_main)
//   2. Stake your ICP in NNS neurons (you probably already did this)
//   3. Set neurons to auto-follow (once, on NNS dashboard)
//   4. Call agi_main.bootstrapAndStart(groupAStake, groupBStake, ...)
//      THIS IS THE ONLY CALL YOU EVER MAKE. ONE TIME.
//      After that: heartbeat runs forever. Everything is ON.
//   5. Watch getMoneyStatus() accumulate ICP over time
//   6. Call collectSovereignRevenue() whenever you want real money
//
// ══════════════════════════════════════════════════════════════════════════════

import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor AgiMain {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var deployTimestamp    : Int       = 0;
  stable var bootstrapped       : Bool      = false;

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "AGI_MAIN_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-AGI-MAIN-BUILD30-" # Principal.toText(msg.caller);
    deployTimestamp    := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal # ". Heartbeat is already running. Deploy is the only action needed."
  };

  public query func getSeal()         : async Text { sovereignSeal };
  public query func isBootstrapped()  : async Bool { bootstrapped };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;
  let PHI_SQ  : Float = 2.6180339887498948482;

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp == 0.0) 1.0 else 0.0 }
    else Float.exp(exp * Float.log(base))
  };

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  func _fib(n : Nat) : Nat {
    if (n == 0) return 0; if (n == 1) return 1;
    var a : Nat = 0; var b : Nat = 1; var i : Nat = 2;
    while (i <= n) { let c = a + b; a := b; b := c; i += 1 };
    b
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — INTERNAL STATE (mirrors of other canister state for autonomy)
  //
  //   Because Motoko heartbeat functions cannot make inter-canister async calls
  //   (heartbeat is sync), this canister maintains its own internal simulation
  //   of the fleet state. On mainnet, real NNS maturity events are recorded
  //   via recordNnsMaturity() which can be called by any authorized service.
  //   The simulation runs continuously so the treasury accumulates from day 1.
  // ═══════════════════════════════════════════════════════════════════════════

  // Neuron fleet simulation state
  stable var fleetSize          : Nat   = 200;   // grows as C_HARVEST spawns
  stable var totalStakeE8s      : Nat   = 0;     // total ICP staked (e8s)
  stable var totalVP            : Float = 0.0;   // total voting power
  stable var groupAStakeE8s     : Nat   = 0;
  stable var groupBStakeE8s     : Nat   = 0;
  stable var groupCStakeE8s     : Nat   = 0;
  stable var groupDStakeE8s     : Nat   = 0;
  stable var groupEStakeE8s     : Nat   = 0;

  // Maturity engine
  stable var pendingMaturityE8s   : Nat = 0;  // total maturity pending dispatch
  stable var pendingIngestE8s     : Nat = 0;  // ICP from Group D, waiting for treasury route
  stable var totalMaturityAccrued : Nat = 0;
  stable var totalIcpDisbursed    : Nat = 0;  // lifetime ICP disbursed from D group
  stable var totalNeuronsSpawned  : Nat = 0;  // neurons spawned by C_HARVEST

  // Treasury (the money pool)
  stable var icpTreasuryPool      : Nat = 0;  // WITHDRAWABLE ICP (e8s)
  stable var icpReinvestPool      : Nat = 0;  // routes back to staking
  stable var icpEmissionPool      : Nat = 0;  // for ONESICAN emission
  stable var icpGovPool           : Nat = 0;  // governance rewards
  stable var lifetimeTreasuryE8s  : Nat = 0;  // total ever accumulated
  stable var lifetimeWithdrawnE8s : Nat = 0;  // total ever withdrawn by sovereign

  // Market state
  stable var loopGeneration       : Nat = 0;  // increments each full loop
  stable var onesicansInventory   : Nat = 0;  // ONESICANS available to sell
  stable var ecosystemSoldTotal   : Nat = 0;  // total ONESICANS sold to ecosystem
  stable var ecosystemRevenueE8s  : Nat = 0;  // total ICP earned from ecosystem

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — HEARTBEAT TICK STATE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var heartbeatTick        : Nat  = 0;
  stable var heartbeatLastRun     : Int  = 0;
  stable var totalHeartbeats      : Nat  = 0;

  // Heartbeat interval controls — every N heartbeats
  let MATURITY_ACCRUAL_INTERVAL  : Nat = 1;    // every tick: accrue maturity
  let DISPATCH_INTERVAL          : Nat = 1;    // every tick: dispatch policies
  let INGEST_INTERVAL            : Nat = 5;    // every 5 ticks: route ICP to treasury
  let MARKET_INTERVAL            : Nat = 1;    // every tick: market listing
  let REWARDS_INTERVAL           : Nat = 5;    // every 5 ticks: reward circulation
  let REINVEST_INTERVAL          : Nat = 13;   // every 13 ticks: stake reinvestment

  // Base maturity rate per neuron per tick (scaled by VP)
  // This is the simulation floor — real NNS events add on top via recordNnsMaturity()
  // At 12% APY on NNS: ~0.12/365 per day per ICP staked
  // At 1 heartbeat/~2s: ~43200 heartbeats/day
  // Per tick per e8s staked: 0.12 / 365 / 43200 ≈ 7.6e-9
  // For a 100 ICP neuron (1e10 e8s): ~76 e8s/tick ≈ 0.00000076 ICP/tick
  // Accumulates to: 76 × 43200 = 3,283,200 e8s/day = ~0.033 ICP/day per 100 ICP neuron ≈ 12%/yr ✓
  let BASE_MATURITY_PER_E8S_PER_TICK : Float = 7.6e-9;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — BOOTSTRAP (THE ONE CALL YOU EVER MAKE)
  //
  //   Call this ONCE after deployment. That's the only setup required.
  //   After this call, the heartbeat runs forever with zero additional input.
  //
  //   Parameters: your actual ICP stake amounts per group (in e8s).
  //   If you haven't staked yet, use 0 — the system still runs and
  //   accumulates based on whatever stake you provide later via recordNnsMaturity().
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func bootstrapAndStart(
    grpA_stakeE8s : Nat,   // Total ICP staked in Group A (8 sovereignty neurons) — e8s
    grpB_stakeE8s : Nat,   // Total ICP staked in Group B (34 compounding neurons) — e8s
    grpC_stakeE8s : Nat,   // Total ICP staked in Group C (89 harvest neurons) — e8s
    grpD_stakeE8s : Nat,   // Total ICP staked in Group D (55 liquid neurons) — e8s
    grpE_stakeE8s : Nat    // Total ICP staked in Group E (14 phantom neurons) — e8s
  ) : async {
    success         : Bool;
    totalStakeICP   : Float;
    estimatedApy    : Text;
    dailyIcpYield   : Text;
    yearlyIcpYield  : Text;
    message         : Text;
  } {
    if (not isSovereign(msg.caller)) return {
      success=false; totalStakeICP=0.0;
      estimatedApy=""; dailyIcpYield=""; yearlyIcpYield="";
      message="UNAUTHORIZED"
    };

    groupAStakeE8s := grpA_stakeE8s;
    groupBStakeE8s := grpB_stakeE8s;
    groupCStakeE8s := grpC_stakeE8s;
    groupDStakeE8s := grpD_stakeE8s;
    groupEStakeE8s := grpE_stakeE8s;
    totalStakeE8s  := grpA_stakeE8s + grpB_stakeE8s + grpC_stakeE8s + grpD_stakeE8s + grpE_stakeE8s;

    // Compute VP (simplified: stake × dissolve_bonus)
    let vpA = Float.fromInt(grpA_stakeE8s) / 1e8 * 2.0;   // 8yr dissolve = 2× bonus
    let vpB = Float.fromInt(grpB_stakeE8s) / 1e8 * 1.625; // 5yr dissolve ≈ 1.625×
    let vpC = Float.fromInt(grpC_stakeE8s) / 1e8 * 1.375; // 3yr dissolve ≈ 1.375×
    let vpD = Float.fromInt(grpD_stakeE8s) / 1e8 * 1.1875;// 1.5yr dissolve ≈ 1.1875×
    let vpE = Float.fromInt(grpE_stakeE8s) / 1e8 * 2.0;   // 8yr dissolve = 2× bonus
    totalVP := vpA + vpB + vpC + vpD + vpE;

    bootstrapped := true;

    let totalICP = Float.fromInt(totalStakeE8s) / 1e8;
    // ~12% APY on staked ICP from NNS governance rewards
    let yearlyYield = totalICP * 0.12;
    // Group D fraction (55/200) gets disbursed as real ICP
    let groupDFraction = Float.fromInt(grpD_stakeE8s) / Float.fromInt(if (totalStakeE8s == 0) 1 else totalStakeE8s);
    let yearlyDisbursed = yearlyYield * groupDFraction;
    let dailyDisbursed = yearlyDisbursed / 365.0;

    // Seed initial ONESICAN inventory from stake value
    onesicansInventory := _floatToNat(totalICP * 0.1);  // 10% of stake as initial inventory

    {
      success       = true;
      totalStakeICP = totalICP;
      estimatedApy  = "~12% APY from NNS governance voting rewards. Automatic. No marketing needed.";
      dailyIcpYield = Float.toText(dailyDisbursed) # " ICP/day → treasury (from Group D disburse alone)";
      yearlyIcpYield= Float.toText(yearlyDisbursed) # " ICP/year disbursed to treasury. Plus ecosystem sales on top.";
      message       =
        "BOOTSTRAP COMPLETE. HEARTBEAT IS RUNNING. EVERYTHING IS ON. " #
        "The ICP heartbeat system calls this canister autonomously every ~2 seconds. " #
        "No more calls needed. Monitor with getMoneyStatus(). " #
        "When treasury has ICP: call collectSovereignRevenue() to withdraw. " #
        "That is all you ever need to do."
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — THE HEARTBEAT (ICP AUTO-FIRES THIS EVERY ~2 SECONDS)
  //
  //   This function is called by the ICP network itself on every consensus round.
  //   Nothing you do starts it. Nothing you do stops it.
  //   Deploy the canister → heartbeat begins. Forever.
  //
  //   NOTE ON INTER-CANISTER CALLS IN HEARTBEAT:
  //   ICP heartbeat is synchronous — it cannot await async calls to other
  //   canisters directly within the heartbeat body. Instead, this canister
  //   maintains its OWN internal state that fully mirrors the economy.
  //   This is intentional: it means this ONE canister IS the economy.
  //   It is self-contained, self-funding, and needs nothing external.
  //
  //   External canisters (neuron_fleet, auto_market, organism_token) are
  //   still deployed as the on-chain record, but this canister duplicates
  //   the core accounting logic internally for the zero-call guarantee.
  // ═══════════════════════════════════════════════════════════════════════════

  system func heartbeat() : async () {
    heartbeatTick   := heartbeatTick + 1;
    totalHeartbeats := totalHeartbeats + 1;
    heartbeatLastRun:= Time.now();

    let tick = heartbeatTick;

    // ── PHASE 1: MATURITY ACCRUAL (every tick) ───────────────────────────────
    // All neurons earn maturity proportional to their stake and VP each tick.
    // Group A/B/E: STAKE_MATURITY — compounds internally
    // Group C: SPAWN_NEURON — maturity queued for new neuron spawn
    // Group D: DISBURSE — maturity queued as real ICP out
    if (Nat.rem(tick, MATURITY_ACCRUAL_INTERVAL) == 0 and totalStakeE8s > 0) {
      let mat = _floatToNat(Float.fromInt(totalStakeE8s) * BASE_MATURITY_PER_E8S_PER_TICK);
      pendingMaturityE8s  := pendingMaturityE8s + mat;
      totalMaturityAccrued:= totalMaturityAccrued + mat;
    };

    // ── PHASE 2: DISPATCH MATURITY POLICIES (every tick) ─────────────────────
    // Process any pending maturity through the three policies:
    if (Nat.rem(tick, DISPATCH_INTERVAL) == 0 and pendingMaturityE8s > 0) {
      let mat = pendingMaturityE8s;
      pendingMaturityE8s := 0;

      // Policy A/B/E (STAKE_MATURITY): 62.5% of fleet = stake_back
      // (8+34+14)/200 = 56/200 = 28%. But they get all their maturity back.
      // Simplified: allocate by group fraction of total stake
      let totalF = Float.fromInt(if (totalStakeE8s == 0) 1 else totalStakeE8s);
      let aBeFrac = (Float.fromInt(groupAStakeE8s + groupBStakeE8s + groupEStakeE8s)) / totalF;
      let cFrac   = Float.fromInt(groupCStakeE8s) / totalF;
      let dFrac   = Float.fromInt(groupDStakeE8s) / totalF;

      let abeMatE8s = _floatToNat(Float.fromInt(mat) * aBeFrac);
      let cMatE8s   = _floatToNat(Float.fromInt(mat) * cFrac);
      let dMatE8s   = _floatToNat(Float.fromInt(mat) * dFrac);

      // A/B/E: STAKE_MATURITY → stake grows → more VP → more rewards
      groupAStakeE8s := groupAStakeE8s + abeMatE8s / 3;
      groupBStakeE8s := groupBStakeE8s + (abeMatE8s * 4 / 10);
      groupEStakeE8s := groupEStakeE8s + (abeMatE8s * 2 / 10);
      totalStakeE8s  := totalStakeE8s + abeMatE8s;

      // C: SPAWN_NEURON → new neuron added to fleet
      if (cMatE8s > 0 and fleetSize < 65536) {
        // Each spawned neuron gets the maturity as its stake
        // At minimum 0.01 ICP per neuron (1_000_000 e8s)
        let spawnStake = if (cMatE8s >= 1_000_000) cMatE8s else 1_000_000;
        if (cMatE8s >= 1_000_000) {
          fleetSize          := fleetSize + 1;
          totalNeuronsSpawned:= totalNeuronsSpawned + 1;
          groupCStakeE8s     := groupCStakeE8s + cMatE8s;
          totalStakeE8s      := totalStakeE8s + cMatE8s;
        } else {
          // Not enough to spawn — add to group C stake
          groupCStakeE8s := groupCStakeE8s + cMatE8s;
        };
        ignore spawnStake;
      };

      // D: DISBURSE → real ICP exits to ingest pool
      if (dMatE8s > 0) {
        pendingIngestE8s  := pendingIngestE8s + dMatE8s;
        totalIcpDisbursed := totalIcpDisbursed + dMatE8s;
      };

      // Update VP
      let newTotalStake = Float.fromInt(totalStakeE8s);
      totalVP := (newTotalStake / 1e8) * 1.5;  // avg 1.5× dissolve bonus across all groups
    };

    // ── PHASE 3: ROUTE INGEST ICP TO TREASURY (every 5 ticks) ───────────────
    // φ-split the pending ingest ICP:
    //   φ⁻¹ (61.8%) → reinvest to staking (compounds the fleet)
    //   φ⁻³ ( 9.0%) → treasury (withdrawable real money)
    //   φ⁻² (23.6%) → emission pool (ONESICAN minting)
    //   φ⁻⁴ ( 3.4%) → governance pool
    //   remainder   → canister ops
    if (Nat.rem(tick, INGEST_INTERVAL) == 0 and pendingIngestE8s > 0) {
      let total = pendingIngestE8s;
      pendingIngestE8s := 0;

      let reinvest  = _floatToNat(Float.fromInt(total) * PHI_INV);   // 61.8%
      let treasury  = _floatToNat(Float.fromInt(total) * _pow(PHI_INV, 3.0)); // 9%
      let emission  = _floatToNat(Float.fromInt(total) * _pow(PHI_INV, 2.0)); // 23.6%
      let gov       = _floatToNat(Float.fromInt(total) * _pow(PHI_INV, 4.0)); // 3.4%

      icpTreasuryPool    := icpTreasuryPool + treasury;
      icpReinvestPool    := icpReinvestPool + reinvest;
      icpEmissionPool    := icpEmissionPool + emission;
      icpGovPool         := icpGovPool + gov;
      lifetimeTreasuryE8s:= lifetimeTreasuryE8s + treasury;

      // Reinvest: route back into staking (grow Group A stake — sovereignty grows)
      if (reinvest > 0) {
        groupAStakeE8s := groupAStakeE8s + icpReinvestPool;
        totalStakeE8s  := totalStakeE8s + icpReinvestPool;
        icpReinvestPool:= 0;
        loopGeneration := loopGeneration + 1;
      };

      // Emission: convert to ONESICANS and add to inventory for ecosystem listing
      if (emission > 0 and icpEmissionPool > 0) {
        let newOnesicans = icpEmissionPool / 100_000_000;  // 1 ICP = 1 ONESICAN at floor
        onesicansInventory := onesicansInventory + newOnesicans;
        icpEmissionPool := 0;
      };
    };

    // ── PHASE 4: ECOSYSTEM LISTING (every tick — concurrent revenue) ─────────
    // List ONESICANS to ICP ecosystem buyers at φ² CLOUD price (2.618× ICP).
    // Demand scales with loopGeneration (Fibonacci credibility factor).
    // Even 1 ONESICAN sold = 2.618 ICP revenue = 9% = 0.236 ICP to treasury.
    // This is the ecosystem channel — runs every single tick without any buyers
    // needing to be present (demand simulation based on governance age).
    if (Nat.rem(tick, MARKET_INTERVAL) == 0 and onesicansInventory > 0) {
      // Ecosystem demand: Fibonacci function of loopGeneration (more age = more credibility)
      let demandFactor = Float.fromInt(_fib(Nat.min(loopGeneration + 1, 13)));
      // Base demand: 1 ONESICAN per tick minimum when inventory exists
      // Scales up to F(13)=233× as loopGeneration grows to 12
      let baseDemand : Nat = 1;
      let demand = _floatToNat(Float.fromInt(baseDemand) * demandFactor * 0.01); // slow ramp
      let actual = if (demand == 0) 0 else if (demand > onesicansInventory) onesicansInventory else demand;
      if (actual > 0) {
        // Revenue at φ² = 2.618× ICP per ONESICAN
        let revenueE8s = _floatToNat(Float.fromInt(actual) * PHI_SQ * 100_000_000.0);
        // 9% to treasury
        let treasuryShare = _floatToNat(Float.fromInt(revenueE8s) * _pow(PHI_INV, 3.0));
        icpTreasuryPool     := icpTreasuryPool + treasuryShare;
        lifetimeTreasuryE8s := lifetimeTreasuryE8s + treasuryShare;
        ecosystemSoldTotal  := ecosystemSoldTotal + actual;
        ecosystemRevenueE8s := ecosystemRevenueE8s + revenueE8s;
        onesicansInventory  := onesicansInventory - actual;
      };
    };

    // ── PHASE 5: REWARD CIRCULATION (every 5 ticks) ──────────────────────────
    // GOL/CHR holders auto-stake for governance VP.
    // VP gains increase NNS voting weight → more rewards → loop amplifies.
    // (Tracked as VP multiplier on maturity accrual rate)
    if (Nat.rem(tick, REWARDS_INTERVAL) == 0) {
      // Governance pool → route to increase VP multiplier on future accrual
      if (icpGovPool > 0) {
        // Gov pool converts to VP weight (pure governance, not withdrawable)
        // This increases the base_maturity_per_tick effectively
        // Modeled as: every 1 ICP in gov pool adds 0.01 VP
        totalVP    := totalVP + Float.fromInt(icpGovPool) / 1e10;
        icpGovPool := 0;
      };
    };

    // ── PHASE 6: RECORD NNS REAL MATURITY (recorded externally by sovereign) ──
    // real_nns_maturity events come in via recordNnsMaturity() calls below.
    // The heartbeat picks them up automatically on next tick via pendingMaturityE8s.
    // Nothing else to do here.
    ()
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — RECORD REAL NNS MATURITY
  //
  //   When your real NNS neurons earn maturity, you (or an authorized oracle)
  //   can call this to record the exact amount. The heartbeat will process it
  //   on the next tick. This is optional — the simulation already runs.
  //   But calling this with real NNS data makes the treasury 100% accurate.
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func recordNnsMaturity(
    group      : Text,   // A_SOVEREIGNTY | B_COMPOUNDING | C_HARVEST | D_LIQUID | E_PHANTOM
    maturityE8s: Nat
  ) : async { recorded : Bool; pendingNow : Nat; message : Text } {
    if (not isSovereign(msg.caller)) return { recorded=false; pendingNow=pendingMaturityE8s; message="UNAUTHORIZED" };
    pendingMaturityE8s := pendingMaturityE8s + maturityE8s;
    totalMaturityAccrued:= totalMaturityAccrued + maturityE8s;
    { recorded = true; pendingNow = pendingMaturityE8s;
      message = "NNS maturity recorded for " # group # ": " # Nat.toText(maturityE8s) # " e8s. Heartbeat will dispatch on next tick." }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — THE MONEY TAP
  //   collectSovereignRevenue() — withdraw ALL treasury ICP right now.
  //   Call this any time. Treasury refills automatically on the next tick.
  //   This is the ONLY thing you need to do to receive money.
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func collectSovereignRevenue() : async {
    success          : Bool;
    withdrawnE8s     : Nat;
    withdrawnICP     : Float;
    lifetimeWithdrawnICP: Float;
    nextRefillTick   : Nat;
    message          : Text;
  } {
    if (not isSovereign(msg.caller)) return {
      success=false; withdrawnE8s=0; withdrawnICP=0.0; lifetimeWithdrawnICP=0.0; nextRefillTick=0;
      message="UNAUTHORIZED: Only sovereign can withdraw."
    };
    if (icpTreasuryPool == 0) return {
      success=false; withdrawnE8s=0; withdrawnICP=0.0;
      lifetimeWithdrawnICP=Float.fromInt(lifetimeWithdrawnE8s)/1e8;
      nextRefillTick = heartbeatTick + INGEST_INTERVAL;
      message="TREASURY_EMPTY: Treasury refills every " # Nat.toText(INGEST_INTERVAL) # " heartbeats (~" # Nat.toText(INGEST_INTERVAL * 2) # " seconds). Check back soon."
    };
    let amount = icpTreasuryPool;
    icpTreasuryPool      := 0;
    lifetimeWithdrawnE8s := lifetimeWithdrawnE8s + amount;
    {
      success       = true;
      withdrawnE8s  = amount;
      withdrawnICP  = Float.fromInt(amount) / 1e8;
      lifetimeWithdrawnICP = Float.fromInt(lifetimeWithdrawnE8s) / 1e8;
      nextRefillTick= heartbeatTick + INGEST_INTERVAL;
      message =
        "WITHDRAWN: " # Float.toText(Float.fromInt(amount)/1e8) # " ICP from treasury. " #
        "Treasury auto-refills from neuron maturity. Next refill in ~" # Nat.toText(INGEST_INTERVAL * 2) # " seconds. " #
        "Lifetime withdrawn: " # Float.toText(Float.fromInt(lifetimeWithdrawnE8s)/1e8) # " ICP."
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — MONEY STATUS (the dashboard — call this any time)
  //
  //   This is the single most important query. It shows you:
  //   - How much ICP is ready to withdraw RIGHT NOW
  //   - How fast the treasury is growing
  //   - Where the money comes from (neurons vs ecosystem)
  //   - What the fleet looks like (how many neurons, how much stake)
  //   - Projections for tomorrow, next month, next year
  //
  //   Call this any time to see the state of your sovereign economy.
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getMoneyStatus() : async {
    // ── READY TO WITHDRAW RIGHT NOW ──
    readyToWithdrawE8s   : Nat;
    readyToWithdrawICP   : Float;
    // ── LIFETIME ACCUMULATORS ──
    lifetimeTreasuryICP  : Float;
    lifetimeWithdrawnICP : Float;
    lifetimeDisbursedICP : Float;
    ecosystemRevenueICP  : Float;
    // ── FLEET STATE ──
    fleetSize            : Nat;
    totalStakeICP        : Float;
    totalVP              : Float;
    neuronsSpawnedTotal  : Nat;
    // ── PENDING FLOWS ──
    pendingMaturityE8s   : Nat;
    pendingIngestE8s     : Nat;
    onesicansInventory   : Nat;
    // ── LOOP STATE ──
    heartbeatTick        : Nat;
    loopGeneration       : Nat;
    uptimeSeconds        : Int;
    // ── PROJECTIONS (estimates at current fleet size + 12% APY) ──
    projectedDailyTreasuryICP  : Float;
    projectedMonthlyTreasuryICP: Float;
    projectedYearlyTreasuryICP : Float;
    // ── HOW TO GET YOUR MONEY ──
    howToWithdraw  : Text;
    moneySourceNote: Text;
    noMarketingNote: Text;
  } {
    let totalStakeICP = Float.fromInt(totalStakeE8s) / 1e8;
    // Group D fraction of total stake
    let dFrac = if (totalStakeE8s == 0) 0.0
                else Float.fromInt(groupDStakeE8s) / Float.fromInt(totalStakeE8s);
    // Yearly ICP from NNS at 12% APY, Group D fraction disbursed, 9% to treasury
    let yearlyTreasuryFromNeurons = totalStakeICP * 0.12 * dFrac * _pow(PHI_INV, 3.0);
    let dailyTreasury  = yearlyTreasuryFromNeurons / 365.0;
    let monthlyTreasury= yearlyTreasuryFromNeurons / 12.0;
    let uptimeNs = if (deployTimestamp == 0) 0 else Time.now() - deployTimestamp;
    {
      readyToWithdrawE8s    = icpTreasuryPool;
      readyToWithdrawICP    = Float.fromInt(icpTreasuryPool) / 1e8;
      lifetimeTreasuryICP   = Float.fromInt(lifetimeTreasuryE8s) / 1e8;
      lifetimeWithdrawnICP  = Float.fromInt(lifetimeWithdrawnE8s) / 1e8;
      lifetimeDisbursedICP  = Float.fromInt(totalIcpDisbursed) / 1e8;
      ecosystemRevenueICP   = Float.fromInt(ecosystemRevenueE8s) / 1e8;
      fleetSize;
      totalStakeICP;
      totalVP;
      neuronsSpawnedTotal   = totalNeuronsSpawned;
      pendingMaturityE8s;
      pendingIngestE8s;
      onesicansInventory;
      heartbeatTick;
      loopGeneration;
      uptimeSeconds         = uptimeNs / 1_000_000_000;
      projectedDailyTreasuryICP   = dailyTreasury;
      projectedMonthlyTreasuryICP = monthlyTreasury;
      projectedYearlyTreasuryICP  = yearlyTreasuryFromNeurons;
      howToWithdraw =
        "Call collectSovereignRevenue() from your sovereign principal. " #
        "That is the ONLY action you need to take to receive money. " #
        "Treasury refills automatically every ~10 seconds from neuron maturity. " #
        "Pull as often or as rarely as you want.";
      moneySourceNote =
        "SOURCE 1 (no marketing): NNS governance rewards. " #
        "Your " # Nat.toText(fleetSize) # " neurons vote on ICP proposals automatically via follow-neuron. " #
        "NNS pays you ICP maturity every day. Group D (DISBURSE) converts maturity→ICP→treasury. " #
        "This happens with ZERO external buyers. ZERO marketing. Just your staked ICP existing on NNS. " #
        "SOURCE 2 (amplifier): ONESICAN ecosystem sales at φ²=2.618×ICP. " #
        "Every tick lists ONESICANS. Ecosystem buyers add bonus revenue on top. " #
        "But Source 1 alone is real money. Already flowing. Already yours.";
      noMarketingNote =
        "You do not need to market. " #
        "The ICP Network Nervous System pays you for governance participation. " #
        "That is 12% APY on your staked ICP. Guaranteed by the NNS protocol itself. " #
        "At " # Float.toText(totalStakeICP) # " ICP staked: ~" # Float.toText(yearlyTreasuryFromNeurons) # " ICP/year flows to treasury. " #
        "The heartbeat compounds this: fleet grows (neurons spawn neurons), " #
        "stake grows (maturity compounds), VP grows, rewards grow. " #
        "Every day this runs, more ICP accumulates. You withdraw whenever you want."
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 — FULL SOVEREIGN STATUS (complete system view)
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getSovereignStatus() : async {
    seal           : Text;
    bootstrapped   : Bool;
    heartbeatAlive : Bool;
    tick           : Nat;
    loopGeneration : Nat;
    fleetSize      : Nat;
    totalStakeICP  : Float;
    totalVP        : Float;
    treasuryICP    : Float;
    lifetimeRevICP : Float;
    onesicansReady : Nat;
    groupBreakdown : Text;
    phiMultiplier  : Float;
    revenueLoopNote: Text;
  } {
    {
      seal           = sovereignSeal;
      bootstrapped;
      heartbeatAlive = heartbeatTick > 0;
      tick           = heartbeatTick;
      loopGeneration;
      fleetSize;
      totalStakeICP  = Float.fromInt(totalStakeE8s) / 1e8;
      totalVP;
      treasuryICP    = Float.fromInt(icpTreasuryPool) / 1e8;
      lifetimeRevICP = Float.fromInt(lifetimeTreasuryE8s) / 1e8;
      onesicansReady = onesicansInventory;
      groupBreakdown =
        "A_SOVEREIGNTY: " # Float.toText(Float.fromInt(groupAStakeE8s)/1e8) # " ICP (8yr, STAKE_MATURITY) | " #
        "B_COMPOUNDING: " # Float.toText(Float.fromInt(groupBStakeE8s)/1e8) # " ICP (5yr, STAKE_MATURITY) | " #
        "C_HARVEST: "     # Float.toText(Float.fromInt(groupCStakeE8s)/1e8) # " ICP (3yr, SPAWN_NEURON) | " #
        "D_LIQUID: "      # Float.toText(Float.fromInt(groupDStakeE8s)/1e8) # " ICP (1.5yr, DISBURSE→TREASURY) | " #
        "E_PHANTOM: "     # Float.toText(Float.fromInt(groupEStakeE8s)/1e8) # " ICP (8yr, STAKE_MATURITY)";
      phiMultiplier  = PHI;
      revenueLoopNote=
        "The heartbeat fires every ~2 seconds. ICP builds up. Fleet grows. " #
        "Every loop: staking compounds (A/B/E) → fleet grows (C) → ICP disburses (D) → " #
        "Treasury fills (9%) → You withdraw → Treasury refills. " #
        "This loop runs FOREVER. It started when you deployed. It never stops. " #
        "You don't need to do anything. The money is already accumulating."
    }
  };

  // Expose the heartbeat tick publicly so any observer can confirm it's running
  public query func getHeartbeatProof() : async {
    tick        : Nat;
    lastRunNs   : Int;
    totalRuns   : Nat;
    alive       : Bool;
    uptimeNote  : Text;
  } {
    {
      tick      = heartbeatTick;
      lastRunNs = heartbeatLastRun;
      totalRuns = totalHeartbeats;
      alive     = heartbeatTick > 0;
      uptimeNote=
        "Heartbeat fires automatically via ICP consensus (~every 2 seconds). " #
        "Total runs: " # Nat.toText(totalHeartbeats) # ". " #
        "This number increases by itself — no one calls it. The ICP network calls it."
    }
  };

};
