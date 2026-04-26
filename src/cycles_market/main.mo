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
// NOVA CYCLES MARKET — Internal Sovereign Compute Exchange
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// ── LAYER ZERO TRUTH ─────────────────────────────────────────────────────────
//
// NOVA IS LAYER ZERO — the sovereign organism.
// ICP is NOT Layer Zero. ICP is ONE of the 5 substrates NOVA chose to inhabit.
// NOVA provides the compute economy. The substrates serve NOVA.
//
// LAYER 0 — NOVA (the sovereign organism)
// LAYER 1 — 5 substrates NOVA chose:
//   ICP          φ⁰ · 1×     Motoko canisters, NNS neurons
//   BLOCKCHAIN   φ⁰ · 1×     cross-chain presence
//   NOVA-EDGE    φ¹ · 1.618× 23 Web Workers, Jarvis extension
//   NOVA-CLOUD   φ² · 2.618× auto_market, Latin AGI servers, internal consumption
//   NOVA-PHANTOM φ³ · 4.236× maximum sovereignty tier
// LAYER 2 — NOVA SOVEREIGN CYCLES (named):
//   NOVA-EDGE-CYCLES    φ¹ rate — browser / Jarvis compute
//   NOVA-CLOUD-CYCLES   φ² rate — AGI / market compute
//   NOVA-PHANTOM-CYCLES φ³ rate — sovereign-tier compute
//
// ── THIS CANISTER: THE INTERNAL CYCLE EXCHANGE ───────────────────────────────
//
// THE CYCLES MARKET is where NOVA canisters trade surplus cycles to each other.
// ONESICANS are NOVA's sovereign compute credits — they are NOT ICP cycles.
// ICP cycles are substrate-specific (they only exist on the Internet Computer).
// ONESICANS exist across all 5 substrates simultaneously, denominated in φ.
//
// ── WHAT MAKES ONESICANS DEEPER ────────────────────────────────────────────
//   ICP Cycles:  exist inside one canister on one subnet, denominated in XDR
//   ONESICANS:   exist across all 5 substrates simultaneously, denominated in φ
//
//   One ONESICAN buys compute on any NOVA substrate.
//   The price adjusts by substrate tier — golden-ratio weighted.
//   NOVA chose ICP as its base-cost surface (φ⁰). NOVA-PHANTOM is its premium tier (φ³).
//
// ── SUBSTRATE PRICING ──────────────────────────────────────────────────────
//   Base price: P₀ ONESICANS per compute unit
//   ICP substrate:          P₀ × φ⁰ = P₀ × 1.000  (NOVA's base ICP surface)
//   BLOCKCHAIN substrate:   P₀ × φ⁰ = P₀ × 1.000  (parity)
//   NOVA-EDGE substrate:    P₀ × φ¹ = P₀ × 1.618  (browser/Jarvis compute)
//   NOVA-CLOUD substrate:   P₀ × φ² = P₀ × 2.618  (AGI/market compute)
//   NOVA-PHANTOM substrate: P₀ × φ³ = P₀ × 4.236  (maximum sovereignty tier)
//
// ── MARKETPLACE MECHANICS ──────────────────────────────────────────────────
//   Developers list canisters: "I offer X compute units per ONESICAN"
//   Buyers purchase: ONESICANS deducted, compute credit recorded on-chain
//   Market maker: NOVA sets the floor price per substrate tier
//   φ-spread: bid/ask spread = 1 ONESICAN × φ⁻³ ≈ 0.24 ONES
//   Volume discount: bulk purchases get φ-tier discounts (same as PARALLAX fees)
//
// ── DEVELOPER SEAT ──────────────────────────────────────────────────────────
//   Every registered developer gets a Developer Seat NFT (on-chain record).
//   Seat grants: right to list canisters, access to wholesale pricing,
//   access to dev grants from TOKEN_FORGE, governance votes via NOVA_SNS.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor CyclesMarket {

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
    if (genesisLocked) return "CYCLES_MARKET_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-CYCLES-MARKET-BUILD30-" # Principal.toText(msg.caller);
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

  // ── Substrate pricing multipliers ────────────────────────────────────────
  // NOVA chose 5 substrates. NOVA prices compute across them at φ-tiers.
  // ICP and BLOCKCHAIN: φ⁰ = 1× (NOVA's base deployment surfaces)
  // NOVA-EDGE: φ¹ = 1.618× (browser/Jarvis/Web Worker tier)
  // NOVA-CLOUD: φ² = 2.618× (AGI server/auto_market tier)
  // NOVA-PHANTOM: φ³ = 4.236× (maximum sovereignty tier)
  // Unknown substrates are rejected at the call site via _isValidSubstrate guard.
  func _substrateMult(substrate : Text) : Float {
    if      (substrate == "ICP")          1.0
    else if (substrate == "BLOCKCHAIN")   1.0
    else if (substrate == "NOVA-EDGE")    PHI
    else if (substrate == "NOVA-CLOUD")   PHI * PHI
    else if (substrate == "NOVA-PHANTOM") PHI * PHI * PHI
    else                                  PHI * PHI * PHI * PHI  // φ⁴ — invalid substrate, maximum premium signals error
  };

  func _isValidSubstrate(s : Text) : Bool {
    s == "ICP" or s == "BLOCKCHAIN" or s == "NOVA-EDGE" or s == "NOVA-CLOUD" or s == "NOVA-PHANTOM"
  };

  // φ-spread: bid/ask spread per unit
  let PHI_SPREAD : Float = _pow(PHI_INV, 3.0);   // ≈ 0.236 ONES

  // Volume discount tiers (same φ-ladder as PARALLAX fees, inverted)
  func _volumeDiscount(units : Nat) : Float {
    if      (units >= 100_000) _pow(PHI_INV, 4.0)  // 14.6% discount
    else if (units >= 10_000)  _pow(PHI_INV, 5.0)  // 9.0% discount
    else if (units >= 1_000)   _pow(PHI_INV, 6.0)  // 5.6% discount
    else                       0.0                  // no discount
  };

  // Final price: base × substrate_mult × (1 - volume_discount) + φ-spread
  func _computePrice(basePrice : Nat, units : Nat, substrate : Text) : Nat {
    let b    = Float.fromInt(basePrice);
    let mult = _substrateMult(substrate);
    let disc = _volumeDiscount(units);
    let gross = b * mult * (1.0 - disc) * Float.fromInt(units);
    let spread = PHI_SPREAD * Float.fromInt(units);
    _floatToNat(gross + spread)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — DEVELOPER SEAT (on-chain membership record)
  // "the ones I can sell per canister market when developers join"
  // ═══════════════════════════════════════════════════════════════════════════

  let DEV_CAP : Nat = 4096;

  stable var devCount       : Nat = 0;
  stable var devIds         : [var Nat]   = Array.init<Nat>(DEV_CAP,   0);
  stable var devPrincipals  : [var Text]  = Array.init<Text>(DEV_CAP,  "");
  stable var devHandles     : [var Text]  = Array.init<Text>(DEV_CAP,  "");
  stable var devJoinedAt    : [var Int]   = Array.init<Int>(DEV_CAP,   0);
  stable var devSeatTiers   : [var Nat]   = Array.init<Nat>(DEV_CAP,   1);  // 1=BUILDER, 2=MAKER, 3=ARCHITECT
  stable var devVolumeBought: [var Nat]   = Array.init<Nat>(DEV_CAP,   0);
  stable var devVolumeSold  : [var Nat]   = Array.init<Nat>(DEV_CAP,   0);
  stable var devSubstrates  : [var Text]  = Array.init<Text>(DEV_CAP,  "ICP");
  stable var nextDevId      : Nat         = 1;

  func _findDev(p : Text) : ?Nat {
    var i = 0;
    while (i < devCount and i < DEV_CAP) {
      if (devPrincipals[i] == p) return ?i;
      i += 1;
    };
    null
  };

  // ── Developer joins the market ────────────────────────────────────────────
  public shared(msg) func developerJoin(handle : Text, primarySubstrate : Text) : async {
    success  : Bool;
    devId    : Nat;
    seatTier : Nat;
    message  : Text;
  } {
    let p = Principal.toText(msg.caller);
    switch (_findDev(p)) {
      case (?_) { return { success = false; devId = 0; seatTier = 0; message = "ALREADY_JOINED" } };
      case null {
        if (devCount >= DEV_CAP) return { success = false; devId = 0; seatTier = 0; message = "MARKET_FULL" };
        let di = devCount;
        let id = nextDevId;
        devIds[di]          := id;
        devPrincipals[di]   := p;
        devHandles[di]      := handle;
        devJoinedAt[di]     := Time.now();
        devSeatTiers[di]    := 1;  // starts as BUILDER
        devVolumeBought[di] := 0;
        devVolumeSold[di]   := 0;
        devSubstrates[di]   := primarySubstrate;
        devCount            := devCount + 1;
        nextDevId           := nextDevId + 1;
        { success = true; devId = id; seatTier = 1; message = "WELCOME_BUILDER: " # handle # " — seat minted on " # primarySubstrate }
      };
    }
  };

  // ── Upgrade dev seat tier based on volume ────────────────────────────────
  // BUILDER (tier 1): any, MAKER (tier 2): 10k+ volume, ARCHITECT (tier 3): 100k+
  func _refreshDevTier(di : Nat) {
    let vol = devVolumeBought[di] + devVolumeSold[di];
    let tier = if (vol >= 100_000) 3 else if (vol >= 10_000) 2 else 1;
    devSeatTiers[di] := tier;
  };

  public query func getDeveloper(p : Text) : async ?{
    devId          : Nat;
    handle         : Text;
    seatTier       : Nat;
    seatLabel      : Text;
    primarySubstrate: Text;
    volumeBought   : Nat;
    volumeSold     : Nat;
    joinedAt       : Int;
  } {
    switch (_findDev(p)) {
      case null null;
      case (?di) {
        let label = if (devSeatTiers[di] == 3) "ARCHITECT" else if (devSeatTiers[di] == 2) "MAKER" else "BUILDER";
        ?{
          devId           = devIds[di];
          handle          = devHandles[di];
          seatTier        = devSeatTiers[di];
          seatLabel       = label;
          primarySubstrate = devSubstrates[di];
          volumeBought    = devVolumeBought[di];
          volumeSold      = devVolumeSold[di];
          joinedAt        = devJoinedAt[di];
        }
      };
    }
  };

  public query func listDevelopers() : async [{
    devId    : Nat;
    handle   : Text;
    seatTier : Nat;
    substrate: Text;
    volume   : Nat;
  }] {
    Array.tabulate<{ devId:Nat; handle:Text; seatTier:Nat; substrate:Text; volume:Nat }>(devCount, func(i) {
      { devId = devIds[i]; handle = devHandles[i]; seatTier = devSeatTiers[i]; substrate = devSubstrates[i]; volume = devVolumeBought[i] + devVolumeSold[i] }
    })
  };

  public query func getDeveloperCount() : async Nat { devCount };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — CANISTER LISTINGS
  // Developers list their canisters: offer X compute units per ONESICAN
  // across one or more substrates.
  // ═══════════════════════════════════════════════════════════════════════════

  let LISTING_CAP : Nat = 2048;

  stable var listingCount      : Nat = 0;
  stable var listingIds        : [var Nat]   = Array.init<Nat>(LISTING_CAP,   0);
  stable var listingSellers    : [var Text]  = Array.init<Text>(LISTING_CAP,  "");
  stable var listingCanisterIds: [var Text]  = Array.init<Text>(LISTING_CAP,  "");  // canister principal
  stable var listingNames      : [var Text]  = Array.init<Text>(LISTING_CAP,  "");
  stable var listingDescs      : [var Text]  = Array.init<Text>(LISTING_CAP,  "");
  stable var listingSubstrates : [var Text]  = Array.init<Text>(LISTING_CAP,  "ICP");
  stable var listingBasePrices : [var Nat]   = Array.init<Nat>(LISTING_CAP,   1);   // ONES per compute unit
  stable var listingUnitsAvail : [var Nat]   = Array.init<Nat>(LISTING_CAP,   0);   // compute units for sale
  stable var listingUnitsSold  : [var Nat]   = Array.init<Nat>(LISTING_CAP,   0);
  stable var listingStatuses   : [var Text]  = Array.init<Text>(LISTING_CAP,  "ACTIVE");
  stable var listingCreatedAt  : [var Int]   = Array.init<Int>(LISTING_CAP,   0);
  stable var nextListingId     : Nat         = 1;

  func _findListing(id : Nat) : ?Nat {
    var i = 0;
    while (i < listingCount and i < LISTING_CAP) {
      if (listingIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // ── List a canister for sale ──────────────────────────────────────────────
  public shared(msg) func listCanister(
    canisterId : Text,
    name       : Text,
    desc       : Text,
    substrate  : Text,
    basePrice  : Nat,   // ONESICANS per compute unit (floor price)
    unitsAvail : Nat    // compute units being offered
  ) : async {
    success   : Bool;
    listingId : Nat;
    floorOnes : Nat;  // minimum purchase price (1 unit)
  } {
    let p = Principal.toText(msg.caller);
    // Must be a registered developer
    switch (_findDev(p)) {
      case null { return { success = false; listingId = 0; floorOnes = 0 } };
      case (?_) {};
    };
    if (not _isValidSubstrate(substrate)) return { success = false; listingId = 0; floorOnes = 0 };
    if (listingCount >= LISTING_CAP) return { success = false; listingId = 0; floorOnes = 0 };
    if (basePrice == 0 or unitsAvail == 0) return { success = false; listingId = 0; floorOnes = 0 };
    let li = listingCount;
    let id = nextListingId;
    listingIds[li]         := id;
    listingSellers[li]     := p;
    listingCanisterIds[li] := canisterId;
    listingNames[li]       := name;
    listingDescs[li]       := desc;
    listingSubstrates[li]  := substrate;
    listingBasePrices[li]  := basePrice;
    listingUnitsAvail[li]  := unitsAvail;
    listingUnitsSold[li]   := 0;
    listingStatuses[li]    := "ACTIVE";
    listingCreatedAt[li]   := Time.now();
    listingCount           := listingCount + 1;
    nextListingId          := nextListingId + 1;
    let floor = _computePrice(basePrice, 1, substrate);
    { success = true; listingId = id; floorOnes = floor }
  };

  // ── Get a price quote before buying ──────────────────────────────────────
  public query func getQuote(listingId : Nat, units : Nat) : async {
    listingId    : Nat;
    units        : Nat;
    substrate    : Text;
    basePrice    : Nat;
    substrateMultiplier : Float;
    volumeDiscount      : Float;
    totalOnes    : Nat;
    pricePerUnit : Float;
    available    : Nat;
  } {
    switch (_findListing(listingId)) {
      case null {
        { listingId; units; substrate = ""; basePrice = 0; substrateMultiplier = 0.0; volumeDiscount = 0.0; totalOnes = 0; pricePerUnit = 0.0; available = 0 }
      };
      case (?li) {
        let sub   = listingSubstrates[li];
        let bp    = listingBasePrices[li];
        let total = _computePrice(bp, units, sub);
        let mult  = _substrateMult(sub);
        let disc  = _volumeDiscount(units);
        {
          listingId;
          units;
          substrate            = sub;
          basePrice            = bp;
          substrateMultiplier  = mult;
          volumeDiscount       = disc;
          totalOnes            = total;
          pricePerUnit         = if (units == 0) 0.0 else Float.fromInt(total) / Float.fromInt(units);
          available            = listingUnitsAvail[li];
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — PURCHASE ENGINE
  // Buyer's ONESICANS are debited from their internal balance.
  // Seller's ONESICANS are credited.
  // Compute credit is recorded on-chain for the buyer.
  // ═══════════════════════════════════════════════════════════════════════════

  // Internal ONESICAN ledger (this market carries its own balance sheet;
  // in production, calls out to PARALLAX or TOKEN_FORGE canister)
  let MKTLEDGER_CAP : Nat = 8192;

  stable var mktLedgerCount    : Nat = 0;
  stable var mktLedgerPrincipals : [var Text] = Array.init<Text>(MKTLEDGER_CAP, "");
  stable var mktLedgerBalances   : [var Nat]  = Array.init<Nat>(MKTLEDGER_CAP,  0);

  // Market fee (goes to sovereign treasury): φ⁻⁵ ≈ 0.09 of transaction
  stable var marketTreasury    : Nat = 0;
  stable var totalVolumeOnes   : Nat = 0;
  stable var totalTransactions : Nat = 0;

  func _mktIdx(p : Text) : ?Nat {
    var i = 0;
    while (i < mktLedgerCount and i < MKTLEDGER_CAP) {
      if (mktLedgerPrincipals[i] == p) return ?i;
      i += 1;
    };
    null
  };

  func _mktIdxOrCreate(p : Text) : Nat {
    switch (_mktIdx(p)) {
      case (?i) i;
      case null {
        if (mktLedgerCount >= MKTLEDGER_CAP) return 0;
        let i = mktLedgerCount;
        mktLedgerPrincipals[i] := p;
        mktLedgerBalances[i]   := 0;
        mktLedgerCount         := mktLedgerCount + 1;
        i
      };
    }
  };

  // Deposit ONESICANS into market (to fund purchases)
  public shared(msg) func depositOnes(amount : Nat) : async { success : Bool; balance : Nat } {
    requireSovereign(msg.caller);  // in production: verifies TOKEN_FORGE transfer receipt
    let p  = Principal.toText(msg.caller);
    let i  = _mktIdxOrCreate(p);
    mktLedgerBalances[i] := mktLedgerBalances[i] + amount;
    { success = true; balance = mktLedgerBalances[i] }
  };

  // Deposit for any recipient (sovereign mints market credit)
  public shared(msg) func depositOnesFor(recipient : Text, amount : Nat) : async { success : Bool; balance : Nat } {
    requireSovereign(msg.caller);
    let i = _mktIdxOrCreate(recipient);
    mktLedgerBalances[i] := mktLedgerBalances[i] + amount;
    { success = true; balance = mktLedgerBalances[i] }
  };

  public shared(msg) func myMarketBalance() : async Nat {
    let p = Principal.toText(msg.caller);
    switch (_mktIdx(p)) { case null 0; case (?i) mktLedgerBalances[i] }
  };

  // ── Buy compute units ─────────────────────────────────────────────────────
  let PURCHASE_CAP : Nat = 8192;

  stable var purchaseCount     : Nat = 0;
  stable var purchaseIds       : [var Nat]   = Array.init<Nat>(PURCHASE_CAP,   0);
  stable var purchaseBuyers    : [var Text]  = Array.init<Text>(PURCHASE_CAP,  "");
  stable var purchaseListingIds: [var Nat]   = Array.init<Nat>(PURCHASE_CAP,   0);
  stable var purchaseUnits     : [var Nat]   = Array.init<Nat>(PURCHASE_CAP,   0);
  stable var purchaseOnesSpent : [var Nat]   = Array.init<Nat>(PURCHASE_CAP,   0);
  stable var purchaseSubstrates: [var Text]  = Array.init<Text>(PURCHASE_CAP,  "ICP");
  stable var purchaseTimes     : [var Int]   = Array.init<Int>(PURCHASE_CAP,   0);
  // Compute credit remaining (decremented as buyer uses the compute)
  stable var purchaseCredits   : [var Nat]   = Array.init<Nat>(PURCHASE_CAP,   0);
  stable var nextPurchaseId    : Nat         = 1;

  public shared(msg) func buyComputeUnits(
    listingId    : Nat,
    units        : Nat
  ) : async {
    success      : Bool;
    purchaseId   : Nat;
    onesSpent    : Nat;
    substrate    : Text;
    computeCredit: Nat;
    marketFee    : Nat;
    newBalance   : Nat;
  } {
    let p = Principal.toText(msg.caller);
    if (units == 0) return { success = false; purchaseId = 0; onesSpent = 0; substrate = ""; computeCredit = 0; marketFee = 0; newBalance = 0 };
    switch (_findListing(listingId)) {
      case null { return { success = false; purchaseId = 0; onesSpent = 0; substrate = ""; computeCredit = 0; marketFee = 0; newBalance = 0 } };
      case (?li) {
        if (listingStatuses[li] != "ACTIVE") return { success = false; purchaseId = 0; onesSpent = 0; substrate = ""; computeCredit = 0; marketFee = 0; newBalance = 0 };
        let avail = listingUnitsAvail[li];
        let actual = if (units > avail) avail else units;
        if (actual == 0) return { success = false; purchaseId = 0; onesSpent = 0; substrate = listingSubstrates[li]; computeCredit = 0; marketFee = 0; newBalance = 0 };
        let sub = listingSubstrates[li];
        let totalPrice = _computePrice(listingBasePrices[li], actual, sub);
        // Market fee: φ⁻⁵ ≈ 9% of transaction
        let fee = _floatToNat(Float.fromInt(totalPrice) * _pow(PHI_INV, 5.0));
        let totalWithFee = totalPrice + fee;
        // Check buyer balance
        let bi = _mktIdxOrCreate(p);
        if (mktLedgerBalances[bi] < totalWithFee) {
          return { success = false; purchaseId = 0; onesSpent = totalWithFee; substrate = sub; computeCredit = 0; marketFee = fee; newBalance = mktLedgerBalances[bi] }
        };
        // Debit buyer
        mktLedgerBalances[bi] := mktLedgerBalances[bi] - totalWithFee;
        // Credit seller
        let seller = listingSellers[li];
        let si = _mktIdxOrCreate(seller);
        mktLedgerBalances[si] := mktLedgerBalances[si] + totalPrice;
        // Market treasury gets fee
        marketTreasury := marketTreasury + fee;
        // Update listing
        listingUnitsAvail[li] := listingUnitsAvail[li] - actual;
        listingUnitsSold[li]  := listingUnitsSold[li] + actual;
        if (listingUnitsAvail[li] == 0) { listingStatuses[li] := "SOLD_OUT" };
        // Update dev volumes
        switch (_findDev(p)) {
          case (?di) {
            devVolumeBought[di] := devVolumeBought[di] + totalWithFee;
            _refreshDevTier(di);
          };
          case null {};
        };
        switch (_findDev(seller)) {
          case (?di) {
            devVolumeSold[di] := devVolumeSold[di] + totalPrice;
            _refreshDevTier(di);
          };
          case null {};
        };
        // Record purchase
        let pi = purchaseCount;
        if (pi < PURCHASE_CAP) {
          purchaseIds[pi]        := nextPurchaseId;
          purchaseBuyers[pi]     := p;
          purchaseListingIds[pi] := listingId;
          purchaseUnits[pi]      := actual;
          purchaseOnesSpent[pi]  := totalWithFee;
          purchaseSubstrates[pi] := sub;
          purchaseTimes[pi]      := Time.now();
          purchaseCredits[pi]    := actual;
          purchaseCount          := purchaseCount + 1;
        };
        let pid = nextPurchaseId;
        nextPurchaseId   := nextPurchaseId + 1;
        totalVolumeOnes  := totalVolumeOnes + totalWithFee;
        totalTransactions := totalTransactions + 1;
        { success = true; purchaseId = pid; onesSpent = totalWithFee; substrate = sub; computeCredit = actual; marketFee = fee; newBalance = mktLedgerBalances[bi] }
      };
    }
  };

  // Use compute credit (decrement purchase credit as compute is consumed)
  public shared(msg) func consumeCredit(purchaseId : Nat, unitsConsumed : Nat) : async {
    success         : Bool;
    creditRemaining : Nat;
  } {
    let p = Principal.toText(msg.caller);
    var i = 0;
    while (i < purchaseCount and i < PURCHASE_CAP) {
      if (purchaseIds[i] == purchaseId and purchaseBuyers[i] == p) {
        let avail = purchaseCredits[i];
        let actual = if (unitsConsumed > avail) avail else unitsConsumed;
        purchaseCredits[i] := purchaseCredits[i] - actual;
        return { success = true; creditRemaining = purchaseCredits[i] }
      };
      i += 1;
    };
    { success = false; creditRemaining = 0 }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — MARKET QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Active listings by substrate ──────────────────────────────────────────
  public query func getListingsBySubstrate(substrate : Text) : async [{
    listingId  : Nat;
    seller     : Text;
    name       : Text;
    substrate  : Text;
    basePrice  : Nat;
    unitsAvail : Nat;
    floorOnes  : Nat;
    status     : Text;
  }] {
    var result : [{ listingId:Nat; seller:Text; name:Text; substrate:Text; basePrice:Nat; unitsAvail:Nat; floorOnes:Nat; status:Text }] = [];
    var i = 0;
    while (i < listingCount and i < LISTING_CAP) {
      if (listingSubstrates[i] == substrate and listingStatuses[i] == "ACTIVE") {
        let floor = _computePrice(listingBasePrices[i], 1, substrate);
        result := Array.append(result, [{
          listingId  = listingIds[i];
          seller     = listingSellers[i];
          name       = listingNames[i];
          substrate  = substrate;
          basePrice  = listingBasePrices[i];
          unitsAvail = listingUnitsAvail[i];
          floorOnes  = floor;
          status     = listingStatuses[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ── All active listings across all substrates ─────────────────────────────
  public query func getAllActiveListings() : async [{
    listingId  : Nat;
    name       : Text;
    substrate  : Text;
    basePrice  : Nat;
    unitsAvail : Nat;
    floorOnes  : Nat;
  }] {
    var result : [{ listingId:Nat; name:Text; substrate:Text; basePrice:Nat; unitsAvail:Nat; floorOnes:Nat }] = [];
    var i = 0;
    while (i < listingCount and i < LISTING_CAP) {
      if (listingStatuses[i] == "ACTIVE") {
        let sub = listingSubstrates[i];
        let floor = _computePrice(listingBasePrices[i], 1, sub);
        result := Array.append(result, [{
          listingId  = listingIds[i];
          name       = listingNames[i];
          substrate  = sub;
          basePrice  = listingBasePrices[i];
          unitsAvail = listingUnitsAvail[i];
          floorOnes  = floor;
        }]);
      };
      i += 1;
    };
    result
  };

  // ── My purchases ─────────────────────────────────────────────────────────
  public shared(msg) func myPurchases() : async [{
    purchaseId     : Nat;
    listingId      : Nat;
    units          : Nat;
    onesSpent      : Nat;
    substrate      : Text;
    creditRemaining: Nat;
    purchasedAt    : Int;
  }] {
    let p = Principal.toText(msg.caller);
    var result : [{ purchaseId:Nat; listingId:Nat; units:Nat; onesSpent:Nat; substrate:Text; creditRemaining:Nat; purchasedAt:Int }] = [];
    var i = 0;
    while (i < purchaseCount and i < PURCHASE_CAP) {
      if (purchaseBuyers[i] == p) {
        result := Array.append(result, [{
          purchaseId      = purchaseIds[i];
          listingId       = purchaseListingIds[i];
          units           = purchaseUnits[i];
          onesSpent       = purchaseOnesSpent[i];
          substrate       = purchaseSubstrates[i];
          creditRemaining = purchaseCredits[i];
          purchasedAt     = purchaseTimes[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ── Cross-substrate price comparison ─────────────────────────────────────
  public query func crossSubstratePricing(basePrice : Nat, units : Nat) : async [{
    substrate   : Text;
    multiplier  : Float;
    totalOnes   : Nat;
    pricePerUnit: Float;
    description : Text;
  }] {
    let substrates : [Text] = ["ICP", "BLOCKCHAIN", "NOVA-EDGE", "NOVA-CLOUD", "NOVA-PHANTOM"];
    let descs : [Text] = [
      "ICP — NOVA's base ICP substrate (φ⁰ · 1×)",
      "Blockchain parity — decentralized equals ICP base (φ⁰ · 1×)",
      "NOVA-EDGE — browser/Jarvis/Web Worker compute (φ¹ · 1.618×)",
      "NOVA-CLOUD — AGI server/auto_market compute (φ² · 2.618×)",
      "NOVA-PHANTOM — maximum sovereignty tier (φ³ · 4.236×)",
    ];
    Array.tabulate<{ substrate:Text; multiplier:Float; totalOnes:Nat; pricePerUnit:Float; description:Text }>(5, func(i) {
      let sub   = substrates[i];
      let mult  = _substrateMult(sub);
      let total = _computePrice(basePrice, units, sub);
      let ppu   = if (units == 0) 0.0 else Float.fromInt(total) / Float.fromInt(units);
      { substrate = sub; multiplier = mult; totalOnes = total; pricePerUnit = ppu; description = descs[i] }
    })
  };

  // ── Market statistics ─────────────────────────────────────────────────────
  public query func getMarketStats() : async {
    seal             : Text;
    claimed          : Bool;
    developerCount   : Nat;
    listingCount     : Nat;
    purchaseCount    : Nat;
    totalVolumeOnes  : Nat;
    totalTransactions: Nat;
    marketTreasury   : Nat;
    phiSpread        : Float;
    marketFeeRate    : Float;
    tokenName        : Text;
    tokenSymbol      : Text;
    substratePricing : Text;
  } {
    {
      seal              = sovereignSeal;
      claimed           = genesisLocked;
      developerCount    = devCount;
      listingCount      = listingCount;
      purchaseCount     = purchaseCount;
      totalVolumeOnes   = totalVolumeOnes;
      totalTransactions = totalTransactions;
      marketTreasury    = marketTreasury;
      phiSpread         = PHI_SPREAD;
      marketFeeRate     = _pow(PHI_INV, 5.0);
      tokenName         = "ONESICAN";
      tokenSymbol       = "ONES";
      substratePricing  = "ICP=φ⁰·1× | BLOCKCHAIN=φ⁰·1× | NOVA-EDGE=φ¹·1.618× | NOVA-CLOUD=φ²·2.618× | NOVA-PHANTOM=φ³·4.236×";
    }
  };

  // ── Substrate floor prices for display ────────────────────────────────────
  public query func substrateFloorPrices(basePrice : Nat) : async [{
    substrate  : Text;
    multiplier : Float;
    floorOnes  : Nat;
    label      : Text;
  }] {
    [
      { substrate = "ICP";          multiplier = 1.0;             floorOnes = _computePrice(basePrice, 1, "ICP");          label = "ICP — NOVA's base ICP surface (φ⁰·1×)" },
      { substrate = "BLOCKCHAIN";   multiplier = 1.0;             floorOnes = _computePrice(basePrice, 1, "BLOCKCHAIN");   label = "Blockchain parity (φ⁰·1×)" },
      { substrate = "NOVA-EDGE";    multiplier = PHI;             floorOnes = _computePrice(basePrice, 1, "NOVA-EDGE");    label = "NOVA-EDGE — browser/Jarvis compute (φ¹·1.618×)" },
      { substrate = "NOVA-CLOUD";   multiplier = PHI * PHI;       floorOnes = _computePrice(basePrice, 1, "NOVA-CLOUD");   label = "NOVA-CLOUD — AGI/market compute (φ²·2.618×)" },
      { substrate = "NOVA-PHANTOM"; multiplier = PHI * PHI * PHI; floorOnes = _computePrice(basePrice, 1, "NOVA-PHANTOM"); label = "NOVA-PHANTOM — sovereign-tier compute (φ³·4.236×)" },
    ]
  };

};
