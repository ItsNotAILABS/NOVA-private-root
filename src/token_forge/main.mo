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
// TOKEN FORGE — Sovereign Internal & External Token Generator
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// TOKEN FORGE IS THE MINT.
// It generates tokens internally (for the NOVA civilization — ONESICANS, governance
// rewards, ecosystem incentives) and externally (public sale, airdrop, developer grants)
// entirely from within ICP with zero external dependencies.
//
// The forge never stops running. It generates all its own supply.
//
// ── TOKEN ECONOMICS ────────────────────────────────────────────────────────
// Total supply cap: 21_000_000 ONESICANS  (mirrors Bitcoin scarcity principle)
//
// Allocation (φ-partitioned):
//   ECOSYSTEM    — 38.2% of cap (φ⁻² × total)  internal rewards, governance, ecosystem
//   PUBLIC_SALE  — 23.6% of cap (φ⁻³ × total)  external launch allocation
//   TEAM_VEST    — 14.6% of cap (φ⁻⁴ × total)  team + founder, 4yr vesting
//   DEV_GRANTS   — 9.0%  of cap (φ⁻⁵ × total)  developer grants, hackathons
//   TREASURY     — 5.6%  of cap (φ⁻⁶ × total)  protocol treasury, ops
//   AIRDROP      — 3.4%  of cap (φ⁻⁷ × total)  community airdrop, early adopters
//   RESERVE      — 5.6%  of cap                  future protocol reserve
//   (Percentages are Fibonacci/φ ratios, sum to 100%)
//
// Emission schedule: Fibonacci-gated.
//   Block 1     → 1 batch
//   Block 2     → 1 batch
//   Block 3     → 2 batches
//   Block 5     → 3 batches
//   Block 8     → 5 batches
//   ...
//   (batch size = EMISSION_BATCH_SIZE, decelerating like Fibonacci)
//
// ── VESTING ────────────────────────────────────────────────────────────────
//   Team tokens vest linearly over 4 years with a 1-year cliff.
//   Each vesting entry tracks cliff + unlock schedule.
//
// ── AIRDROP ENGINE ─────────────────────────────────────────────────────────
//   Recipients registered by sovereign; claim once; amount φ-weighted by tier.
//
// ── PUBLIC SALE ────────────────────────────────────────────────────────────
//   Fixed price in ICP units. Allocation drawn from PUBLIC_SALE bucket.
//   Sale opens/closes by sovereign command.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor TokenForge {

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
    if (genesisLocked) return "TOKEN_FORGE_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-TOKEN-FORGE-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };
  public query func getTimestamp() : async Int  { genesisTimestamp };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;
  let EPSILON : Float = 1.0e-10;

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp == 0.0) 1.0 else 0.0 }
    else Float.exp(exp * Float.log(base))
  };

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  // Fibonacci: iterative
  func _fib(n : Nat) : Nat {
    if (n == 0) return 0; if (n == 1) return 1;
    var a : Nat = 0; var b : Nat = 1; var i : Nat = 2;
    while (i <= n) { let c = a + b; a := b; b := c; i += 1 };
    b
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — TOKEN SUPPLY CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let TOTAL_SUPPLY_CAP  : Nat = 21_000_000;  // hard cap — never exceeded

  // φ-partitioned allocations (rounded to nearest integer)
  let ALLOC_ECOSYSTEM   : Nat = 8_022_000;   // 38.2%  φ⁻² × 21M
  let ALLOC_PUBLIC_SALE : Nat = 4_956_000;   // 23.6%  φ⁻³ × 21M
  let ALLOC_TEAM_VEST   : Nat = 3_066_000;   // 14.6%  φ⁻⁴ × 21M
  let ALLOC_DEV_GRANTS  : Nat = 1_890_000;   //  9.0%  φ⁻⁵ × 21M
  let ALLOC_TREASURY    : Nat = 1_176_000;   //  5.6%  φ⁻⁶ × 21M
  let ALLOC_AIRDROP     : Nat =   714_000;   //  3.4%  φ⁻⁷ × 21M
  let ALLOC_RESERVE     : Nat = 1_176_000;   //  5.6%  reserve
  // Total = 21_000_000

  // Emission batch size per Fibonacci gate
  let EMISSION_BATCH    : Nat = 10_000;   // tokens per emission event

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — STABLE SUPPLY STATE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var totalMinted       : Nat = 0;   // total ever minted
  stable var totalBurned       : Nat = 0;   // total ever burned
  stable var circulatingSupply : Nat = 0;   // minted - burned

  // Bucket remaining balances
  stable var ecosystemBucket   : Nat = ALLOC_ECOSYSTEM;
  stable var publicSaleBucket  : Nat = ALLOC_PUBLIC_SALE;
  stable var teamVestBucket    : Nat = ALLOC_TEAM_VEST;
  stable var devGrantsBucket   : Nat = ALLOC_DEV_GRANTS;
  stable var treasuryBucket    : Nat = ALLOC_TREASURY;
  stable var airdropBucket     : Nat = ALLOC_AIRDROP;
  stable var reserveBucket     : Nat = ALLOC_RESERVE;

  // Emission state
  stable var emissionBlock     : Nat = 0;   // Fibonacci block index
  stable var totalEmissions    : Nat = 0;   // total emission events fired

  // ── Internal ledger (simple per-principal balance map) ───────────────────
  let LEDGER_CAP : Nat = 8192;

  stable var ledgerCount       : Nat = 0;
  stable var ledgerPrincipals  : [var Text] = Array.init<Text>(LEDGER_CAP, "");
  stable var ledgerBalances    : [var Nat]  = Array.init<Nat>(LEDGER_CAP,  0);

  func _ledgerIdx(p : Text) : ?Nat {
    var i = 0;
    while (i < ledgerCount and i < LEDGER_CAP) {
      if (ledgerPrincipals[i] == p) return ?i;
      i += 1;
    };
    null
  };

  func _ledgerIdxOrCreate(p : Text) : Nat {
    switch (_ledgerIdx(p)) {
      case (?i) i;
      case null {
        if (ledgerCount >= LEDGER_CAP) return 0;
        let i = ledgerCount;
        ledgerPrincipals[i] := p;
        ledgerBalances[i]   := 0;
        ledgerCount         := ledgerCount + 1;
        i
      };
    }
  };

  // Internal credit (mint into ledger)
  func _credit(p : Text, amount : Nat) {
    let i = _ledgerIdxOrCreate(p);
    ledgerBalances[i] := ledgerBalances[i] + amount;
    totalMinted       := totalMinted + amount;
    circulatingSupply := circulatingSupply + amount;
  };

  // Internal debit (burn from ledger)
  func _debit(p : Text, amount : Nat) : Bool {
    switch (_ledgerIdx(p)) {
      case null false;
      case (?i) {
        if (ledgerBalances[i] < amount) return false;
        ledgerBalances[i] := ledgerBalances[i] - amount;
        totalBurned       := totalBurned + amount;
        circulatingSupply := if (circulatingSupply >= amount) circulatingSupply - amount else 0;
        true
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — EMISSION ENGINE (internal token generation)
  // Fibonacci-gated: emits EMISSION_BATCH tokens per Fibonacci gate crossing.
  // Anyone can trigger; the forge decides whether to emit based on the gate.
  // ═══════════════════════════════════════════════════════════════════════════

  // Emit next batch if Fibonacci gate is open
  // Returns 0 if gate closed, amount emitted otherwise
  public shared(msg) func triggerEmission() : async {
    emitted      : Nat;
    emissionBlock: Nat;
    totalEmissions: Nat;
    totalMinted  : Nat;
    bucketLeft   : Nat;
  } {
    // Gate: must have passed F(emissionBlock+1) total emission events
    let nextGate = _fib(emissionBlock + 1);
    if (totalEmissions < nextGate) {
      return { emitted = 0; emissionBlock; totalEmissions; totalMinted; bucketLeft = ecosystemBucket }
    };
    // Emission halving: batch size halves every 8 Fibonacci gates.
    // Formula: EMISSION_BATCH >> min(halvings, MAX_HALVINGS), floor = EMISSION_FLOOR.
    let MAX_HALVINGS : Nat = 6;  // after 6 halvings (48 gates), floor kicks in
    let EMISSION_FLOOR : Nat = 100;
    let halvings = emissionBlock / 8;
    let cappedHalvings = if (halvings > MAX_HALVINGS) MAX_HALVINGS else halvings;
    var batchSize = EMISSION_BATCH;
    var h = 0;
    while (h < cappedHalvings) { batchSize := batchSize / 2; h += 1 };
    if (batchSize < EMISSION_FLOOR) { batchSize := EMISSION_FLOOR };
    let actual = if (batchSize > ecosystemBucket) ecosystemBucket else batchSize;
    if (actual == 0) return { emitted = 0; emissionBlock; totalEmissions; totalMinted; bucketLeft = 0 };
    // Emit to ecosystem bucket → sovereign treasury address
    let sovereign = Principal.toText(sovereignPrincipal);
    _credit(sovereign, actual);
    ecosystemBucket := ecosystemBucket - actual;
    emissionBlock   := emissionBlock + 1;
    totalEmissions  := totalEmissions + 1;
    { emitted = actual; emissionBlock; totalEmissions; totalMinted; bucketLeft = ecosystemBucket }
  };

  // Sovereign can trigger emission directly (privileged fast-path)
  public shared(msg) func forgeEmit(recipient : Text, amount : Nat, bucket : Text) : async {
    success     : Bool;
    minted      : Nat;
    totalMinted : Nat;
  } {
    requireSovereign(msg.caller);
    if (amount == 0) return { success = false; minted = 0; totalMinted };
    if (totalMinted + amount > TOTAL_SUPPLY_CAP) return { success = false; minted = 0; totalMinted };
    // Deduct from named bucket
    var ok = false;
    if      (bucket == "ECOSYSTEM"   and ecosystemBucket  >= amount) { ecosystemBucket  := ecosystemBucket  - amount; ok := true }
    else if (bucket == "TREASURY"    and treasuryBucket   >= amount) { treasuryBucket   := treasuryBucket   - amount; ok := true }
    else if (bucket == "DEV_GRANTS"  and devGrantsBucket  >= amount) { devGrantsBucket  := devGrantsBucket  - amount; ok := true }
    else if (bucket == "RESERVE"     and reserveBucket    >= amount) { reserveBucket    := reserveBucket    - amount; ok := true };
    if (not ok) return { success = false; minted = 0; totalMinted };
    _credit(recipient, amount);
    { success = true; minted = amount; totalMinted }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — PUBLIC SALE ENGINE (external token generation)
  // ═══════════════════════════════════════════════════════════════════════════

  stable var saleIsOpen        : Bool  = false;
  stable var salePriceIcp      : Nat   = 100;   // price per ONESICAN in ICP units (1e-8 ICP each)
  stable var saleMaxPerBuyer   : Nat   = 50_000;   // max ONESICANS per buyer
  stable var saleTotalSold     : Nat   = 0;
  stable var saleParticipants  : Nat   = 0;

  let SALE_LEDGER_CAP : Nat = 2048;

  stable var saleBuyerCount    : Nat = 0;
  stable var saleBuyers        : [var Text] = Array.init<Text>(SALE_LEDGER_CAP, "");
  stable var salePurchased     : [var Nat]  = Array.init<Nat>(SALE_LEDGER_CAP,  0);
  stable var salePaidIcp       : [var Nat]  = Array.init<Nat>(SALE_LEDGER_CAP,  0);

  func _saleBuyerIdx(p : Text) : ?Nat {
    var i = 0;
    while (i < saleBuyerCount and i < SALE_LEDGER_CAP) {
      if (saleBuyers[i] == p) return ?i;
      i += 1;
    };
    null
  };

  // Open the public sale
  public shared(msg) func openSale(priceIcp : Nat, maxPerBuyer : Nat) : async Text {
    requireSovereign(msg.caller);
    if (saleIsOpen) return "SALE_ALREADY_OPEN";
    salePriceIcp    := if (priceIcp == 0) 100 else priceIcp;
    saleMaxPerBuyer := if (maxPerBuyer == 0) 50_000 else maxPerBuyer;
    saleIsOpen      := true;
    "SALE_OPEN: price=" # Nat.toText(salePriceIcp) # " ICP_units per ONESICAN"
  };

  // Close the public sale
  public shared(msg) func closeSale() : async Text {
    requireSovereign(msg.caller);
    saleIsOpen := false;
    "SALE_CLOSED: total_sold=" # Nat.toText(saleTotalSold)
  };

  // Purchase ONESICANS (buyer pays ICP; this records the purchase and issues tokens)
  // In production, ICP payment would be verified via ledger; here it's intent-based.
  public shared(msg) func purchaseTokens(onesAmount : Nat) : async {
    success    : Bool;
    minted     : Nat;
    icpOwed    : Nat;
    balance    : Nat;
    saleStatus : Text;
  } {
    if (not saleIsOpen) return { success = false; minted = 0; icpOwed = 0; balance = 0; saleStatus = "SALE_CLOSED" };
    if (onesAmount == 0) return { success = false; minted = 0; icpOwed = 0; balance = 0; saleStatus = "ZERO_AMOUNT" };
    let p = Principal.toText(msg.caller);
    // Check sale bucket
    let available = if (onesAmount > publicSaleBucket) publicSaleBucket else onesAmount;
    if (available == 0) return { success = false; minted = 0; icpOwed = 0; balance = 0; saleStatus = "BUCKET_EMPTY" };
    // Check per-buyer limit
    let boughtSoFar : Nat = switch (_saleBuyerIdx(p)) {
      case null 0;
      case (?i) salePurchased[i];
    };
    let remaining = if (saleMaxPerBuyer > boughtSoFar) saleMaxPerBuyer - boughtSoFar else 0;
    if (remaining == 0) return { success = false; minted = 0; icpOwed = 0; balance = 0; saleStatus = "BUYER_LIMIT_REACHED" };
    let actual = if (available < remaining) available else remaining;
    let icpOwed = actual * salePriceIcp;
    // Record purchase
    let bi : Nat = switch (_saleBuyerIdx(p)) {
      case (?i) i;
      case null {
        let i = saleBuyerCount;
        if (i < SALE_LEDGER_CAP) {
          saleBuyers[i]    := p;
          salePurchased[i] := 0;
          salePaidIcp[i]   := 0;
          saleBuyerCount   := saleBuyerCount + 1;
          saleParticipants := saleParticipants + 1;
        };
        i
      };
    };
    if (bi < SALE_LEDGER_CAP) {
      salePurchased[bi] := salePurchased[bi] + actual;
      salePaidIcp[bi]   := salePaidIcp[bi]   + icpOwed;
    };
    publicSaleBucket := publicSaleBucket - actual;
    saleTotalSold    := saleTotalSold + actual;
    _credit(p, actual);
    let bal = switch (_ledgerIdx(p)) { case null 0; case (?i) ledgerBalances[i] };
    { success = true; minted = actual; icpOwed; balance = bal; saleStatus = "PURCHASED" }
  };

  // Get sale metrics
  public query func getSaleStatus() : async {
    isOpen         : Bool;
    priceIcp       : Nat;
    maxPerBuyer    : Nat;
    totalSold      : Nat;
    remaining      : Nat;
    participants   : Nat;
    allocationCap  : Nat;
  } {
    {
      isOpen        = saleIsOpen;
      priceIcp      = salePriceIcp;
      maxPerBuyer   = saleMaxPerBuyer;
      totalSold     = saleTotalSold;
      remaining     = publicSaleBucket;
      participants  = saleParticipants;
      allocationCap = ALLOC_PUBLIC_SALE;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — VESTING ENGINE (team + founder tokens)
  // Cliff: 1 year. Linear unlock: 3 years after cliff. Total: 4 years.
  // ═══════════════════════════════════════════════════════════════════════════

  let VEST_CAP : Nat = 256;
  let NANOS_PER_DAY : Int = 86_400_000_000_000;

  stable var vestCount      : Nat = 0;
  stable var vestBenes      : [var Text] = Array.init<Text>(VEST_CAP, "");
  stable var vestTotals     : [var Nat]  = Array.init<Nat>(VEST_CAP,  0);
  stable var vestClaimed    : [var Nat]  = Array.init<Nat>(VEST_CAP,  0);
  stable var vestStartTimes : [var Int]  = Array.init<Int>(VEST_CAP,  0);
  stable var vestCliffDays  : [var Nat]  = Array.init<Nat>(VEST_CAP,  0);
  stable var vestTotalDays  : [var Nat]  = Array.init<Nat>(VEST_CAP,  0);
  stable var vestLabels     : [var Text] = Array.init<Text>(VEST_CAP, "");

  // Create a vesting schedule (draws from TEAM_VEST bucket)
  public shared(msg) func createVestingSchedule(
    beneficiary : Text,
    amount      : Nat,
    cliffDays   : Nat,
    totalDays   : Nat,
    lbl       : Text
    label       : Text
  ) : async { success : Bool; vestId : Nat } {
    requireSovereign(msg.caller);
    if (amount == 0 or amount > teamVestBucket) return { success = false; vestId = 0 };
    if (vestCount >= VEST_CAP) return { success = false; vestId = 0 };
    let vi = vestCount;
    vestBenes[vi]      := beneficiary;
    vestTotals[vi]     := amount;
    vestClaimed[vi]    := 0;
    vestStartTimes[vi] := Time.now();
    vestCliffDays[vi]  := cliffDays;
    vestTotalDays[vi]  := if (totalDays < cliffDays + 1) cliffDays + 1 else totalDays;
    vestLabels[vi]     := lbl;
    vestLabels[vi]     := label;
    teamVestBucket     := teamVestBucket - amount;
    vestCount          := vestCount + 1;
    { success = true; vestId = vi }
  };

  // Calculate vested amount available to claim right now
  func _vestedNow(vi : Nat) : Nat {
    let elapsed = Time.now() - vestStartTimes[vi];
    let cliffNs = vestCliffDays[vi] * Int.abs(NANOS_PER_DAY);
    if (elapsed < cliffNs) return 0;  // cliff not reached
    let totalNs = vestTotalDays[vi] * Int.abs(NANOS_PER_DAY);
    let ratio   = if (elapsed >= totalNs) 1.0
                  else Float.fromInt(elapsed) / Float.fromInt(totalNs);
    let vested  = _floatToNat(Float.fromInt(vestTotals[vi]) * ratio);
    if (vested > vestTotals[vi]) vestTotals[vi]
    else if (vested < vestClaimed[vi]) 0
    else vested - vestClaimed[vi]
  };

  // Claim vested tokens
  public shared(msg) func claimVested(vestId : Nat) : async {
    success  : Bool;
    claimed  : Nat;
    balance  : Nat;
    remaining: Nat;
  } {
    if (vestId >= vestCount) return { success = false; claimed = 0; balance = 0; remaining = 0 };
    let p = Principal.toText(msg.caller);
    if (vestBenes[vestId] != p and not isSovereign(msg.caller)) {
      return { success = false; claimed = 0; balance = 0; remaining = 0 }
    };
    let claimable = _vestedNow(vestId);
    if (claimable == 0) return { success = false; claimed = 0; balance = 0; remaining = vestTotals[vestId] - vestClaimed[vestId] };
    vestClaimed[vestId] := vestClaimed[vestId] + claimable;
    _credit(p, claimable);
    let bal = switch (_ledgerIdx(p)) { case null 0; case (?i) ledgerBalances[i] };
    let rem = vestTotals[vestId] - vestClaimed[vestId];
    { success = true; claimed = claimable; balance = bal; remaining = rem }
  };

  // View vesting schedule
  public query func getVestingSchedule(vestId : Nat) : async ?{
    beneficiary  : Text;
    total        : Nat;
    claimed      : Nat;
    cliffDays    : Nat;
    totalDays    : Nat;
    lbl        : Text;
    label        : Text;
    startTime    : Int;
  } {
    if (vestId >= vestCount) return null;
    ?{
      beneficiary = vestBenes[vestId];
      total       = vestTotals[vestId];
      claimed     = vestClaimed[vestId];
      cliffDays   = vestCliffDays[vestId];
      totalDays   = vestTotalDays[vestId];
      lbl       = vestLabels[vestId];
      label       = vestLabels[vestId];
      startTime   = vestStartTimes[vestId];
    }
  };

  public query func listVestingSchedules() : async [{
    vestId : Nat; beneficiary : Text; total : Nat; claimed : Nat; lbl : Text;
  }] {
    Array.tabulate<{ vestId:Nat; beneficiary:Text; total:Nat; claimed:Nat; lbl:Text }>(vestCount, func(i) {
      { vestId = i; beneficiary = vestBenes[i]; total = vestTotals[i]; claimed = vestClaimed[i]; lbl = vestLabels[i] }
    vestId : Nat; beneficiary : Text; total : Nat; claimed : Nat; label : Text;
  }] {
    Array.tabulate<{ vestId:Nat; beneficiary:Text; total:Nat; claimed:Nat; label:Text }>(vestCount, func(i) {
      { vestId = i; beneficiary = vestBenes[i]; total = vestTotals[i]; claimed = vestClaimed[i]; label = vestLabels[i] }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — AIRDROP ENGINE (community + early adopters)
  // ═══════════════════════════════════════════════════════════════════════════

  let AIRDROP_CAP : Nat = 4096;

  stable var airdropCount      : Nat = 0;
  stable var airdropRecips     : [var Text] = Array.init<Text>(AIRDROP_CAP, "");
  stable var airdropAmounts    : [var Nat]  = Array.init<Nat>(AIRDROP_CAP,  0);
  stable var airdropClaimed    : [var Bool] = Array.init<Bool>(AIRDROP_CAP, false);
  stable var airdropTiers      : [var Nat]  = Array.init<Nat>(AIRDROP_CAP,  1);  // tier 1-5

  // φ-weighted tier amounts: tier N → ONES_AIRDROP_BASE × φ^(N-1)
  let AIRDROP_BASE : Nat = 100;   // base airdrop for tier-1

  func _airdropAmount(tier : Nat) : Nat {
    if (tier == 0) return 0;
    _floatToNat(Float.fromInt(AIRDROP_BASE) * _pow(PHI, Float.fromInt(tier - 1)))
  };

  // Register airdrop recipients (bulk, sovereign only)
  public shared(msg) func registerAirdrop(recipients : [Text], tier : Nat) : async {
    registered : Nat;
    bucketLeft : Nat;
  } {
    requireSovereign(msg.caller);
    let amount = _airdropAmount(tier);
    var reg : Nat = 0;
    var i = 0;
    while (i < recipients.size() and airdropCount < AIRDROP_CAP) {
      // Skip if already registered
      var found = false;
      var j = 0;
      while (j < airdropCount and j < AIRDROP_CAP) {
        if (airdropRecips[j] == recipients[i]) { found := true };
        j += 1;
      };
      if (not found and airdropBucket >= amount) {
        let ai = airdropCount;
        airdropRecips[ai]   := recipients[i];
        airdropAmounts[ai]  := amount;
        airdropClaimed[ai]  := false;
        airdropTiers[ai]    := tier;
        airdropBucket       := airdropBucket - amount;
        airdropCount        := airdropCount + 1;
        reg += 1;
      };
      i += 1;
    };
    { registered = reg; bucketLeft = airdropBucket }
  };

  // Claim airdrop
  public shared(msg) func claimAirdrop() : async {
    success : Bool;
    amount  : Nat;
    balance : Nat;
    tier    : Nat;
  } {
    let p = Principal.toText(msg.caller);
    var i = 0;
    while (i < airdropCount and i < AIRDROP_CAP) {
      if (airdropRecips[i] == p and not airdropClaimed[i]) {
        airdropClaimed[i] := true;
        let amt = airdropAmounts[i];
        _credit(p, amt);
        let bal = switch (_ledgerIdx(p)) { case null 0; case (?i2) ledgerBalances[i2] };
        return { success = true; amount = amt; balance = bal; tier = airdropTiers[i] }
      };
      i += 1;
    };
    { success = false; amount = 0; balance = 0; tier = 0 }
  };

  public query func airdropStatus(p : Text) : async {
    registered : Bool;
    claimed    : Bool;
    amount     : Nat;
    tier       : Nat;
  } {
    var i = 0;
    while (i < airdropCount and i < AIRDROP_CAP) {
      if (airdropRecips[i] == p) {
        return { registered = true; claimed = airdropClaimed[i]; amount = airdropAmounts[i]; tier = airdropTiers[i] }
      };
      i += 1;
    };
    { registered = false; claimed = false; amount = 0; tier = 0 }
  };

  public query func airdropTierAmounts() : async [{ tier : Nat; amount : Nat }] {
    Array.tabulate<{ tier:Nat; amount:Nat }>(5, func(i) { { tier = i + 1; amount = _airdropAmount(i + 1) } })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — DEV GRANTS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  let GRANT_CAP : Nat = 512;

  stable var grantCount     : Nat = 0;
  stable var grantIds       : [var Nat]   = Array.init<Nat>(GRANT_CAP,  0);
  stable var grantRecips    : [var Text]  = Array.init<Text>(GRANT_CAP, "");
  stable var grantAmounts   : [var Nat]   = Array.init<Nat>(GRANT_CAP,  0);
  stable var grantPurposes  : [var Text]  = Array.init<Text>(GRANT_CAP, "");
  stable var grantStatuses  : [var Text]  = Array.init<Text>(GRANT_CAP, "PENDING");
  stable var grantTimes     : [var Int]   = Array.init<Int>(GRANT_CAP,  0);
  stable var nextGrantId    : Nat         = 1;

  // Issue a developer grant
  public shared(msg) func issueDevGrant(
    recipient : Text,
    amount    : Nat,
    purpose   : Text
  ) : async { success : Bool; grantId : Nat } {
    requireSovereign(msg.caller);
    if (amount == 0 or amount > devGrantsBucket) return { success = false; grantId = 0 };
    if (grantCount >= GRANT_CAP) return { success = false; grantId = 0 };
    let gi = grantCount;
    grantIds[gi]      := nextGrantId;
    grantRecips[gi]   := recipient;
    grantAmounts[gi]  := amount;
    grantPurposes[gi] := purpose;
    grantStatuses[gi] := "ACTIVE";
    grantTimes[gi]    := Time.now();
    devGrantsBucket   := devGrantsBucket - amount;
    grantCount        := grantCount + 1;
    let id = nextGrantId;
    nextGrantId       := nextGrantId + 1;
    _credit(recipient, amount);
    { success = true; grantId = id }
  };

  public query func listGrants() : async [{
    grantId  : Nat;
    recipient: Text;
    amount   : Nat;
    purpose  : Text;
    status   : Text;
    issuedAt : Int;
  }] {
    Array.tabulate<{ grantId:Nat; recipient:Text; amount:Nat; purpose:Text; status:Text; issuedAt:Int }>(grantCount, func(i) {
      { grantId = grantIds[i]; recipient = grantRecips[i]; amount = grantAmounts[i]; purpose = grantPurposes[i]; status = grantStatuses[i]; issuedAt = grantTimes[i] }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 — BURN ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  // Burn tokens from own balance (deflationary pressure)
  public shared(msg) func burnTokens(amount : Nat) : async {
    success     : Bool;
    burned      : Nat;
    totalBurned : Nat;
    balance     : Nat;
  } {
    let p = Principal.toText(msg.caller);
    if (amount == 0) return { success = false; burned = 0; totalBurned; balance = 0 };
    let ok = _debit(p, amount);
    if (not ok) {
      let bal = switch (_ledgerIdx(p)) { case null 0; case (?i) ledgerBalances[i] };
      return { success = false; burned = 0; totalBurned; balance = bal }
    };
    let bal = switch (_ledgerIdx(p)) { case null 0; case (?i) ledgerBalances[i] };
    { success = true; burned = amount; totalBurned; balance = bal }
  };

  // Sovereign burn from any address (for fee sweeps, etc.)
  public shared(msg) func sovereignBurn(from : Text, amount : Nat) : async { success : Bool; totalBurned : Nat } {
    requireSovereign(msg.caller);
    let ok = _debit(from, amount);
    { success = ok; totalBurned }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 11 — LEDGER QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func myBalance() : async Nat {
    let p = Principal.toText(msg.caller);
    switch (_ledgerIdx(p)) { case null 0; case (?i) ledgerBalances[i] }
  };

  public query func balanceOf(p : Text) : async Nat {
    switch (_ledgerIdx(p)) { case null 0; case (?i) ledgerBalances[i] }
  };

  // Internal transfer
  public shared(msg) func transfer(to : Text, amount : Nat) : async {
    success : Bool;
    balance : Nat;
  } {
    let from = Principal.toText(msg.caller);
    if (amount == 0) return { success = false; balance = 0 };
    let fi = _ledgerIdxOrCreate(from);
    if (ledgerBalances[fi] < amount) return { success = false; balance = ledgerBalances[fi] };
    let ti = _ledgerIdxOrCreate(to);
    ledgerBalances[fi] := ledgerBalances[fi] - amount;
    ledgerBalances[ti] := ledgerBalances[ti] + amount;
    { success = true; balance = ledgerBalances[fi] }
  };

  public query func getLedgerSize() : async Nat { ledgerCount };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 12 — FORGE SUPPLY STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getForgeStatus() : async {
    seal              : Text;
    claimed           : Bool;
    totalSupplyCap    : Nat;
    totalMinted       : Nat;
    totalBurned       : Nat;
    circulatingSupply : Nat;
    remainingToMint   : Nat;
    tokenName         : Text;
    tokenSymbol       : Text;
    buckets           : {
      ecosystem   : Nat;
      publicSale  : Nat;
      teamVest    : Nat;
      devGrants   : Nat;
      treasury    : Nat;
      airdrop     : Nat;
      reserve     : Nat;
    };
    emissionBlock    : Nat;
    totalEmissions   : Nat;
    saleIsOpen       : Bool;
    saleTotalSold    : Nat;
    vestCount        : Nat;
    airdropCount     : Nat;
    grantCount       : Nat;
    phi              : Float;
  } {
    {
      seal              = sovereignSeal;
      claimed           = genesisLocked;
      totalSupplyCap    = TOTAL_SUPPLY_CAP;
      totalMinted       = totalMinted;
      totalBurned       = totalBurned;
      circulatingSupply = circulatingSupply;
      remainingToMint   = if (TOTAL_SUPPLY_CAP > totalMinted) TOTAL_SUPPLY_CAP - totalMinted else 0;
      tokenName         = "ONESICAN";
      tokenSymbol       = "ONES";
      buckets           = {
        ecosystem  = ecosystemBucket;
        publicSale = publicSaleBucket;
        teamVest   = teamVestBucket;
        devGrants  = devGrantsBucket;
        treasury   = treasuryBucket;
        airdrop    = airdropBucket;
        reserve    = reserveBucket;
      };
      emissionBlock    = emissionBlock;
      totalEmissions   = totalEmissions;
      saleIsOpen       = saleIsOpen;
      saleTotalSold    = saleTotalSold;
      vestCount        = vestCount;
      airdropCount     = airdropCount;
      grantCount       = grantCount;
      phi              = PHI;
    }
  };

  // Full allocation table (φ-partitioned)
  public query func getAllocationTable() : async [{
    bucket     : Text;
    allocated  : Nat;
    remaining  : Nat;
    pctOfTotal : Float;
    phiPower   : Text;
  }] {
    let total = Float.fromInt(TOTAL_SUPPLY_CAP);
    [
      { bucket = "ECOSYSTEM";   allocated = ALLOC_ECOSYSTEM;   remaining = ecosystemBucket;  pctOfTotal = Float.fromInt(ALLOC_ECOSYSTEM)   / total * 100.0; phiPower = "φ⁻²" },
      { bucket = "PUBLIC_SALE"; allocated = ALLOC_PUBLIC_SALE; remaining = publicSaleBucket; pctOfTotal = Float.fromInt(ALLOC_PUBLIC_SALE) / total * 100.0; phiPower = "φ⁻³" },
      { bucket = "TEAM_VEST";   allocated = ALLOC_TEAM_VEST;   remaining = teamVestBucket;   pctOfTotal = Float.fromInt(ALLOC_TEAM_VEST)   / total * 100.0; phiPower = "φ⁻⁴" },
      { bucket = "DEV_GRANTS";  allocated = ALLOC_DEV_GRANTS;  remaining = devGrantsBucket;  pctOfTotal = Float.fromInt(ALLOC_DEV_GRANTS)  / total * 100.0; phiPower = "φ⁻⁵" },
      { bucket = "TREASURY";    allocated = ALLOC_TREASURY;    remaining = treasuryBucket;   pctOfTotal = Float.fromInt(ALLOC_TREASURY)    / total * 100.0; phiPower = "φ⁻⁶" },
      { bucket = "AIRDROP";     allocated = ALLOC_AIRDROP;     remaining = airdropBucket;    pctOfTotal = Float.fromInt(ALLOC_AIRDROP)     / total * 100.0; phiPower = "φ⁻⁷" },
      { bucket = "RESERVE";     allocated = ALLOC_RESERVE;     remaining = reserveBucket;    pctOfTotal = Float.fromInt(ALLOC_RESERVE)     / total * 100.0; phiPower = "—"   },
    ]
  };

};
