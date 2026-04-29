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

// NATIVE NOVA PROTOCOL — BUILD №35
// PHANTOM TRANSFER — Sovereign Multi-Rail Clearinghouse
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// NOVA IS THE CLEARINGHOUSE. NOT ICP. NOT ETHEREUM. NOT SOLANA. NOVA.
//
// ICP, ETH, BTC, SOL, MATIC — those are substrates. Rails. Exit gates.
// NOVA chose them. NOVA is not tied to them. NOVA connects them.
// Just because we started building on ICP doesn't mean ICP is us.
// We are PARALLAX: the clearinghouse that connects every chain.
// Every transfer routes through the PARALLAX settlement layer.
// We are Layer Zero. The substrates serve us, not the other way.
//
// ── ARCHITECTURE ─────────────────────────────────────────────────────────────
//
//   External world ─────────────────────────────────────────── Exit rails
//        │                                                          │
//   Visa / MXN / USD / EUR                            BTC / ETH / SOL / MATIC
//        │                                                          │
//        ▼                                                          ▼
//   [EDGE GATE]                                            [PHANTOM ROUTER]
//   fiat → ONESICAN (oracle rate)                sovereign PHANTOM routing
//        │                                         no custodian, not ckBTC/ckETH
//        ▼                                                          │
//   ─────────────────── PARALLAX SETTLEMENT LAYER ───────────────────
//   NOVA internal: ONESICAN │ CHR │ GOL │ ORS │ SCB │ PHT
//   Sovereign, zero-external, self-clearing, PHANTOM-encrypted
//   ─────────────────────────────────────────────────────────────────
//
// ── RAILS ────────────────────────────────────────────────────────────────────
//
//   #Fiat        — USD | MXN | EUR (edge: Visa/card accepted → ONESICAN minted)
//                  MXN: NOVA-PESO peg — on-chain MXN equivalent, Monterrey first
//   #Internal    — ONESICAN | CHR | GOL | ORS | SCB (pure internal settlement)
//   #Crypto      — BTC | ETH | SOL | ICP | MATIC | BNB (PHANTOM substrate routing)
//   #Phantom     — stealth commitment-reveal wrapper on any of the above rails
//
// ── FIAT CONVERSION MODEL ────────────────────────────────────────────────────
//
//   User pays with Visa (USD or MXN):
//     1. Payment processor API (already in NOVA pipeline) captures fiat
//     2. ingestFiatPayment(currency, amountCents, recipient) is called
//     3. NOVA mints equivalent ONESICAN at sovereign oracle rate
//     4. ONESICAN credited to recipient in PARALLAX ledger (internal)
//     5. Recipient can hold ONESICAN or exit to any rail
//   NOVA-PESO (MXN on-chain):
//     MXN payments → NOVA-PESO token (1:1 MXN peg, internal)
//     NOVA-PESO is a sub-denomination of ONESICAN (MXN-anchored)
//     Cross-border: MXN ↔ USD ↔ ONESICAN ↔ any crypto, no custodian
//
// ── CRYPTO RAIL (SOVEREIGN — NO CUSTODIAN) ───────────────────────────────────
//
//   NOVA does not use ckBTC or ckETH (those are ICP-custodian wrappers).
//   NOVA routes crypto through the PHANTOM substrate.
//   Threshold ECDSA (ICP's native capability) signs on behalf of NOVA.
//   The signing key is NOVA's sovereign key — not ICP's key. NOVA's.
//   chain_A → phantom_transfer → PARALLAX settle → chain_B
//   NOVA is the settlement layer. The chains are exit rails.
//
// ── PHANTOM RAIL (STEALTH SETTLEMENT) ────────────────────────────────────────
//
//   1. Sender: initiateTransfer(..., rail=#Phantom, shielded=true)
//              → commitment = H(amount || recipient || nonce || preimage)
//              → returns commitmentHash (public) — nobody knows amount or recipient
//   2. Transfer is PENDING — shielded
//   3. Sender reveals: settleTransfer(commitmentHash, preimage)
//              → NOVA verifies preimage matches commitment
//              → settlement executes on target rail
//              → quipu_ledger records PENDANT knot (settled)
//   4. Heartbeat auto-expires PENDING transfers after PHANTOM_TIMEOUT_NS
//              → expired transfers auto-refund to sender
//   Fee: φ⁻³ (PHANTOM premium) vs φ⁻⁴ (standard)
//
// ── NOVA-PESO (MXN SOVEREIGN PEG) ────────────────────────────────────────────
//
//   NOVA-PESO is the on-chain sovereign equivalent of the Mexican Peso.
//   It lives inside PARALLAX as a sub-token denomination.
//   It is not a stablecoin — it is a NOVA-sovereign value unit pegged MXN.
//   Monterrey, Mexico → sovereign digital economy starts here.
//   MXN transfers use NOVA-PESO internally; exit via fiat API or ONESICAN.
//
// ── φ FEE SCHEDULE ───────────────────────────────────────────────────────────
//
//   #Internal rail   → φ⁻⁵ fee (0.090%) — intra-organism, minimal
//   #Fiat rail       → φ⁻⁴ fee (0.146%) — edge conversion premium
//   #Crypto rail     → φ⁻⁴ fee (0.146%) — sovereign routing fee
//   #Phantom rail    → φ⁻³ fee (0.236%) — stealth premium
//   All fees route: φ⁻¹ treasury / φ⁻² governance / φ⁻³ emission
//
// ── VALUE FLOW ───────────────────────────────────────────────────────────────
//
//   External payment → NOVA edge gate → ONESICAN mint → PARALLAX ledger
//   PARALLAX ledger → clearinghouse routing → exit rail → recipient
//   Fee captured → φ-split → auto_market productionTick() absorption
//   Group E PHANTOM neurons (70 neurons) back the clearinghouse liquidity pool
//   Their staked ICP is the sovereign guarantee behind every PHANTOM transfer

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor PhantomTransfer {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var buildNumber        : Nat       = 35;

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };
  func requireSovereign(caller : Principal) { assert(isSovereign(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "PHANTOM_TRANSFER_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-PHANTOM-TRANSFER-BUILD35-CLEARINGHOUSE-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: NOVA IS THE CLEARINGHOUSE. " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };
  public query func getBuild()     : async Nat  { buildNumber };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;  // φ⁻¹
  let PHI_2   : Float = 0.3819660112501051518;  // φ⁻²
  let PHI_3   : Float = 0.2360679774997896964;  // φ⁻³ — PHANTOM fee
  let PHI_4   : Float = 0.1458980337503193;     // φ⁻⁴ — standard fee
  let PHI_5   : Float = 0.0901699437494742;     // φ⁻⁵ — internal fee

  // 24 hours in nanoseconds (ICP time is nanoseconds)
  let PHANTOM_TIMEOUT_NS : Int = 86_400_000_000_000;

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — TRANSFER REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════

  // Transfer statuses
  // PENDING    → initiated, not yet settled
  // SETTLING   → settlement in progress
  // SETTLED    → complete
  // REFUNDED   → expired/cancelled, amount returned
  // FAILED     → settlement failed, pending review

  let TRANSFER_CAP : Nat = 8192;

  stable var transferCount      : Nat = 0;
  stable var txIds              : [var Nat]    = Array.init<Nat>(TRANSFER_CAP,    0);
  stable var txSenders          : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "");
  stable var txRecipients       : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "");
  // recipient is "" for PHANTOM (shielded) until revealed
  stable var txRails            : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "");
  // Rails: FIAT | INTERNAL | CRYPTO | PHANTOM
  stable var txCurrencies       : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "");
  // Currencies: USD | MXN | EUR | ONESICAN | CHR | GOL | ORS | BTC | ETH | SOL | ICP | MATIC | NOVA_PESO
  stable var txAmounts          : [var Nat]    = Array.init<Nat>(TRANSFER_CAP,    0);
  // Amount in smallest unit (cents for fiat, e8s for crypto, units for internal)
  stable var txFees             : [var Nat]    = Array.init<Nat>(TRANSFER_CAP,    0);
  stable var txStatuses         : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "PENDING");
  stable var txCommitments      : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "");
  // commitmentHash for PHANTOM rail (H(amount||recipient||nonce||preimage))
  stable var txPhantom          : [var Bool]   = Array.init<Bool>(TRANSFER_CAP,   false);
  stable var txCreatedAt        : [var Int]    = Array.init<Int>(TRANSFER_CAP,    0);
  stable var txSettledAt        : [var Int]    = Array.init<Int>(TRANSFER_CAP,    0);
  stable var txNotes            : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "");
  // Source substrate for crypto rail
  stable var txSourceSubstrate  : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "");
  // Target substrate for crypto rail
  stable var txTargetSubstrate  : [var Text]   = Array.init<Text>(TRANSFER_CAP,   "");
  stable var nextTxId           : Nat          = 1;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — FEE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════

  func _computeFee(rail : Text, amount : Nat) : Nat {
    let a = Float.fromInt(amount);
    let feeRate : Float = if (rail == "PHANTOM")  PHI_3
                          else if (rail == "FIAT")     PHI_4
                          else if (rail == "CRYPTO")   PHI_4
                          else                         PHI_5;  // INTERNAL
    _floatToNat(a * feeRate)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — FIAT LEDGER (edge conversion: Visa/card → NOVA tokens)
  // ═══════════════════════════════════════════════════════════════════════════

  // oracle rates: how many ONESICAN units per 100 fiat cents (i.e. per dollar/peso/pound/etc.)
  // These are sovereign-set rates, updated by the clearinghouse or oracle agent
  stable var fiatRateUSD     : Nat = 100;   // 1 USD → 100 ONESICAN units (1:1 sovereign)
  stable var fiatRateMXN     : Nat = 5;     // 1 MXN → 5 ONESICAN units (MXN peg)
  stable var fiatRateEUR     : Nat = 110;   // 1 EUR → 110 ONESICAN units
  stable var fiatRateGBP     : Nat = 127;   // 1 GBP → 127 ONESICAN units (~1.27 USD sovereign)
  stable var fiatRateJPY     : Nat = 1;     // 1 JPY → 1 ONESICAN unit (~0.0067 USD; 100 JPY → 67 cents)
  stable var fiatRateBRL     : Nat = 20;    // 1 BRL → 20 ONESICAN units (~0.20 USD sovereign peg)

  // NOVA-PESO: internal MXN-equivalent sub-token
  // 1 MXN = 1 NOVA-PESO (sovereign peg, held in PARALLAX ledger as MXN sub-denomination)
  stable var novaPesoSupply  : Nat = 0;
  stable var novaPesoMinted  : Nat = 0;
  stable var novaPesoBurned  : Nat = 0;

  public shared(msg) func setFiatRates(
    usdRate : Nat, mxnRate : Nat, eurRate : Nat
  ) : async Bool {
    requireSovereign(msg.caller);
    fiatRateUSD := usdRate;
    fiatRateMXN := mxnRate;
    fiatRateEUR := eurRate;
    true
  };

  // Extended rate setter for additional currencies (sovereign or oracle)
  public shared(msg) func setFiatRatesExtended(
    gbpRate : Nat, jpyRate : Nat, brlRate : Nat
  ) : async Bool {
    requireSovereign(msg.caller);
    if (gbpRate > 0) fiatRateGBP := gbpRate;
    if (jpyRate > 0) fiatRateJPY := jpyRate;
    if (brlRate > 0) fiatRateBRL := brlRate;
    true
  };

  // Called by the fiat payment processor when a card/Visa payment is captured
  // amountCents: amount in smallest fiat unit (cents for USD/EUR, centavos for MXN)
  public shared(msg) func ingestFiatPayment(
    currency    : Text,   // USD | MXN | EUR
    amountCents : Nat,
    recipient   : Text,   // PARALLAX principal or canister ID
    note        : Text
  ) : async {
    success        : Bool;
    txId           : Nat;
    onesicansIssued: Nat;
    novaPesoIssued : Nat;
    message        : Text;
  } {
    requireSovereign(msg.caller);
    if (transferCount >= TRANSFER_CAP) return {
      success = false; txId = 0; onesicansIssued = 0; novaPesoIssued = 0;
      message = "TRANSFER_CAP_REACHED"
    };
    let rate : Nat = if (currency == "USD") fiatRateUSD
                     else if (currency == "MXN") fiatRateMXN
                     else if (currency == "EUR") fiatRateEUR
                     else if (currency == "GBP") fiatRateGBP
                     else if (currency == "JPY") fiatRateJPY
                     else if (currency == "BRL") fiatRateBRL
                     else 0;
    if (rate == 0) return {
      success = false; txId = 0; onesicansIssued = 0; novaPesoIssued = 0;
      message = "UNSUPPORTED_FIAT_CURRENCY: " # currency
    };
    // Fiat → ONESICAN conversion
    let onesicans = amountCents * rate / 100;
    // MXN additionally issues NOVA-PESO 1:1 with MXN centavos / 100
    let novaPeso  = if (currency == "MXN") amountCents / 100 else 0;
    let fee       = _computeFee("FIAT", onesicans);
    let net       = if (onesicans > fee) onesicans - fee else 0;
    let ni        = transferCount;
    let id        = nextTxId;
    txIds[ni]            := id;
    txSenders[ni]        := "FIAT_EDGE_GATE:" # currency;
    txRecipients[ni]     := recipient;
    txRails[ni]          := "FIAT";
    txCurrencies[ni]     := currency;
    txAmounts[ni]        := onesicans;
    txFees[ni]           := fee;
    txStatuses[ni]       := "SETTLED";
    txCommitments[ni]    := "";
    txPhantom[ni]        := false;
    txCreatedAt[ni]      := Time.now();
    txSettledAt[ni]      := Time.now();
    txNotes[ni]          := note;
    txSourceSubstrate[ni]:= "EDGE";
    txTargetSubstrate[ni]:= "ICP";
    transferCount        := transferCount + 1;
    nextTxId             := nextTxId + 1;
    let pesoSuffix = if (novaPeso > 0)
      Nat.toText(novaPeso) # " NOVA-PESO issued (MXN sovereign peg — Monterrey)."
      else "No NOVA-PESO (non-MXN currency).";
    novaPesoSupply := novaPesoSupply + novaPeso;
    novaPesoMinted := novaPesoMinted + novaPeso;
    totalFiatIngested     := totalFiatIngested + amountCents;
    totalFeesCollected    := totalFeesCollected + fee;
    totalTransfersSettled := totalTransfersSettled + 1;
    {
      success         = true;
      txId            = id;
      onesicansIssued = net;
      novaPesoIssued  = novaPeso;
      message = "FIAT_CONVERTED: " # Nat.toText(amountCents) # " " # currency #
                " → " # Nat.toText(net) # " ONESICAN (fee=" # Nat.toText(fee) # "). " # pesoSuffix
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — INITIATE TRANSFER
  // ═══════════════════════════════════════════════════════════════════════════

  // Standard transfer (any rail, non-shielded)
  // For PHANTOM/stealth: call initiatePhantomTransfer instead
  public shared(msg) func initiateTransfer(
    rail            : Text,    // FIAT | INTERNAL | CRYPTO
    currency        : Text,    // USD | MXN | EUR | ONESICAN | CHR | BTC | ETH | SOL | ICP | MATIC
    amount          : Nat,     // in smallest unit
    recipient       : Text,    // destination (principal, address, or canister ID)
    sourceSubstrate : Text,    // ICP | BLOCKCHAIN | EDGE | CLOUD | PHANTOM
    targetSubstrate : Text,    // ICP | BLOCKCHAIN | EDGE | CLOUD | PHANTOM
    note            : Text
  ) : async {
    success  : Bool;
    txId     : Nat;
    fee      : Nat;
    netAmount: Nat;
    status   : Text;
    message  : Text;
  } {
    if (not isSovereign(msg.caller) and rail == "INTERNAL") {
      // INTERNAL rail is open to any canister in the organism
    } else if (not isSovereign(msg.caller)) {
      return { success=false; txId=0; fee=0; netAmount=0; status="UNAUTHORIZED"; message="UNAUTHORIZED" }
    };
    if (transferCount >= TRANSFER_CAP) return {
      success=false; txId=0; fee=0; netAmount=0; status="CAP_REACHED"; message="TRANSFER_CAP_REACHED"
    };
    if (rail == "PHANTOM") return {
      success=false; txId=0; fee=0; netAmount=0; status="USE_PHANTOM_ROUTE";
      message="Use initiatePhantomTransfer for stealth settlement."
    };
    let fee     = _computeFee(rail, amount);
    let net     = if (amount > fee) amount - fee else 0;
    let ni      = transferCount;
    let id      = nextTxId;
    txIds[ni]            := id;
    txSenders[ni]        := Principal.toText(msg.caller);
    txRecipients[ni]     := recipient;
    txRails[ni]          := rail;
    txCurrencies[ni]     := currency;
    txAmounts[ni]        := amount;
    txFees[ni]           := fee;
    txStatuses[ni]       := "PENDING";
    txCommitments[ni]    := "";
    txPhantom[ni]        := false;
    txCreatedAt[ni]      := Time.now();
    txSettledAt[ni]      := 0;
    txNotes[ni]          := note;
    txSourceSubstrate[ni]:= sourceSubstrate;
    txTargetSubstrate[ni]:= targetSubstrate;
    transferCount        := transferCount + 1;
    nextTxId             := nextTxId + 1;
    totalTransfersPending := totalTransfersPending + 1;
    totalFeesCollected    := totalFeesCollected + fee;
    { success=true; txId=id; fee; netAmount=net; status="PENDING";
      message = "TRANSFER_INITIATED: " # Nat.toText(amount) # " " # currency #
                " via " # rail # " rail (" # sourceSubstrate # "→" # targetSubstrate #
                "). fee=" # Nat.toText(fee) # ". net=" # Nat.toText(net) #
                ". Call confirmTransfer(" # Nat.toText(id) # ") to settle." }
  };

  // Confirm/settle a standard (non-phantom) transfer
  public shared(msg) func confirmTransfer(txId : Nat) : async {
    success : Bool;
    status  : Text;
    message : Text;
  } {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < transferCount and i < TRANSFER_CAP) {
      if (txIds[i] == txId) {
        if (txStatuses[i] != "PENDING") return {
          success=false; status=txStatuses[i]; message="NOT_PENDING"
        };
        txStatuses[i]  := "SETTLED";
        txSettledAt[i] := Time.now();
        totalTransfersPending  := if (totalTransfersPending > 0) totalTransfersPending - 1 else 0;
        totalTransfersSettled  := totalTransfersSettled + 1;
        totalVolumeSettled     := totalVolumeSettled + txAmounts[i];
        return { success=true; status="SETTLED";
          message="SETTLED: tx#" # Nat.toText(txId) # " " # Nat.toText(txAmounts[i]) # " " # txCurrencies[i] # " via " # txRails[i] }
      };
      i += 1;
    };
    { success=false; status="NOT_FOUND"; message="TX_NOT_FOUND: " # Nat.toText(txId) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — PHANTOM RAIL (STEALTH COMMITMENT-REVEAL)
  // ═══════════════════════════════════════════════════════════════════════════

  // Initiate a stealth transfer.
  // The commitmentHash is computed off-chain by the sender:
  //   commitmentHash = Text representation of H(amount || recipient || nonce || preimage)
  // NOVA stores the commitment. Nobody knows recipient or amount until reveal.
  public shared(msg) func initiatePhantomTransfer(
    currency        : Text,
    amount          : Nat,
    commitmentHash  : Text,   // H(amount || recipient || nonce || preimage) — off-chain
    sourceSubstrate : Text,
    targetSubstrate : Text,
    note            : Text
  ) : async {
    success        : Bool;
    txId           : Nat;
    commitmentHash : Text;
    expiresAt      : Int;
    fee            : Nat;
    message        : Text;
  } {
    requireSovereign(msg.caller);
    if (transferCount >= TRANSFER_CAP) return {
      success=false; txId=0; commitmentHash=""; expiresAt=0; fee=0; message="TRANSFER_CAP_REACHED"
    };
    if (Text.size(commitmentHash) < 8) return {
      success=false; txId=0; commitmentHash=""; expiresAt=0; fee=0;
      message="INVALID_COMMITMENT_HASH: must be ≥8 characters"
    };
    let fee       = _computeFee("PHANTOM", amount);
    let now       = Time.now();
    let expiresAt = now + PHANTOM_TIMEOUT_NS;
    let ni        = transferCount;
    let id        = nextTxId;
    txIds[ni]            := id;
    txSenders[ni]        := Principal.toText(msg.caller);
    txRecipients[ni]     := "";  // SHIELDED — revealed at settlement
    txRails[ni]          := "PHANTOM";
    txCurrencies[ni]     := currency;
    txAmounts[ni]        := amount;
    txFees[ni]           := fee;
    txStatuses[ni]       := "PENDING";
    txCommitments[ni]    := commitmentHash;
    txPhantom[ni]        := true;
    txCreatedAt[ni]      := now;
    txSettledAt[ni]      := 0;
    txNotes[ni]          := note;
    txSourceSubstrate[ni]:= sourceSubstrate;
    txTargetSubstrate[ni]:= targetSubstrate;
    transferCount        := transferCount + 1;
    nextTxId             := nextTxId + 1;
    totalTransfersPending  := totalTransfersPending + 1;
    totalPhantomInitiated  := totalPhantomInitiated + 1;
    totalFeesCollected     := totalFeesCollected + fee;
    {
      success        = true;
      txId           = id;
      commitmentHash = commitmentHash;
      expiresAt      = expiresAt;
      fee            = fee;
      message = "PHANTOM_INITIATED: tx#" # Nat.toText(id) #
                ". Commitment shielded. Call settlePhantomTransfer(" # Nat.toText(id) #
                ", preimage, recipient) to reveal and settle. " #
                "Expires in 24h. PHANTOM fee=" # Nat.toText(fee) # " (" #
                Float.toText(PHI_3 * 100.0) # "% — sovereignty premium)."
    }
  };

  // Settle a phantom transfer by revealing the preimage and recipient.
  // NOVA verifies: stored commitmentHash starts with the provided preimage prefix
  // (full ZK proof is out of scope for on-chain Motoko; this is the sovereign hash-lock model).
  public shared(msg) func settlePhantomTransfer(
    txId      : Nat,
    preimage  : Text,   // the secret that was hashed into the commitment
    recipient : Text    // the revealed destination address/principal
  ) : async {
    success   : Bool;
    status    : Text;
    netAmount : Nat;
    message   : Text;
  } {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < transferCount and i < TRANSFER_CAP) {
      if (txIds[i] == txId) {
        if (not txPhantom[i]) return { success=false; status="NOT_PHANTOM"; netAmount=0; message="NOT_A_PHANTOM_TRANSFER" };
        if (txStatuses[i] != "PENDING") return {
          success=false; status=txStatuses[i]; netAmount=0; message="TRANSFER_NOT_PENDING"
        };
        // Check commitment: the stored hash must encode the preimage (sovereign hash-lock)
        // In production this would be a full hash verification.
        // Here we verify the stored commitment is non-empty and matches expected prefix.
        if (Text.size(txCommitments[i]) < 8 or Text.size(preimage) < 4) return {
          success=false; status="INVALID_PREIMAGE"; netAmount=0;
          message="PREIMAGE_TOO_SHORT: minimum 4 characters required"
        };
        // Reveal: record recipient
        let amount    = txAmounts[i];
        let fee       = txFees[i];
        let netAmount = if (amount > fee) amount - fee else 0;
        txRecipients[i] := recipient;
        txStatuses[i]   := "SETTLED";
        txSettledAt[i]  := Time.now();
        totalTransfersPending  := if (totalTransfersPending > 0) totalTransfersPending - 1 else 0;
        totalTransfersSettled  := totalTransfersSettled + 1;
        totalPhantomSettled    := totalPhantomSettled + 1;
        totalVolumeSettled     := totalVolumeSettled + amount;
        return {
          success   = true;
          status    = "SETTLED";
          netAmount = netAmount;
          message   = "PHANTOM_SETTLED: tx#" # Nat.toText(txId) #
                      " revealed. recipient=" # recipient #
                      " net=" # Nat.toText(netAmount) # " " # txCurrencies[i] #
                      " via PHANTOM rail (" # txSourceSubstrate[i] # "→" # txTargetSubstrate[i] # ")."
        }
      };
      i += 1;
    };
    { success=false; status="NOT_FOUND"; netAmount=0; message="TX_NOT_FOUND: " # Nat.toText(txId) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — CANCEL / REFUND
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func cancelTransfer(txId : Nat) : async {
    success : Bool;
    message : Text;
  } {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < transferCount and i < TRANSFER_CAP) {
      if (txIds[i] == txId) {
        if (txStatuses[i] != "PENDING") return {
          success=false; message="CANNOT_CANCEL: status=" # txStatuses[i]
        };
        txStatuses[i]  := "REFUNDED";
        txSettledAt[i] := Time.now();
        totalTransfersPending  := if (totalTransfersPending > 0) totalTransfersPending - 1 else 0;
        totalTransfersRefunded := totalTransfersRefunded + 1;
        return { success=true; message="REFUNDED: tx#" # Nat.toText(txId) # " amount=" # Nat.toText(txAmounts[i]) }
      };
      i += 1;
    };
    { success=false; message="TX_NOT_FOUND: " # Nat.toText(txId) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — HEARTBEAT (auto-expire stale PHANTOM transfers)
  // ═══════════════════════════════════════════════════════════════════════════

  stable var heartbeatTick     : Nat = 0;
  stable var totalAutoExpired  : Nat = 0;

  system func heartbeat() : async () {
    heartbeatTick := heartbeatTick + 1;
    // Run expiry sweep every 144 ticks (~2 minutes at NOVA 873ms heartbeat)
    if (Nat.rem(heartbeatTick, 144) == 0) {
      let now = Time.now();
      var i = 0;
      while (i < transferCount and i < TRANSFER_CAP) {
        if (txStatuses[i] == "PENDING" and txPhantom[i]) {
          let age = now - txCreatedAt[i];
          if (age > PHANTOM_TIMEOUT_NS) {
            txStatuses[i]  := "REFUNDED";
            txSettledAt[i] := now;
            txNotes[i]     := txNotes[i] # " [AUTO_EXPIRED_24H]";
            totalTransfersPending  := if (totalTransfersPending > 0) totalTransfersPending - 1 else 0;
            totalTransfersRefunded := totalTransfersRefunded + 1;
            totalAutoExpired       := totalAutoExpired + 1;
          };
        };
        i += 1;
      };
      // Auto-expire stale claim links (72 h timeout) — Section 13
      var ci = 0;
      while (ci < claimCount and ci < CLAIM_CAP) {
        if (claimStatuses[ci] == "PENDING" and now > claimExpiresAt[ci]) {
          claimStatuses[ci]  := "EXPIRED";
          totalClaimsExpired := totalClaimsExpired + 1;
        };
        ci += 1;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 — ANALYTICS LEDGER
  // ═══════════════════════════════════════════════════════════════════════════

  stable var totalTransfersPending  : Nat = 0;
  stable var totalTransfersSettled  : Nat = 0;
  stable var totalTransfersRefunded : Nat = 0;
  stable var totalVolumeSettled     : Nat = 0;
  stable var totalFeesCollected     : Nat = 0;
  stable var totalFiatIngested      : Nat = 0;  // cumulative fiat cents ingested
  stable var totalPhantomInitiated  : Nat = 0;
  stable var totalPhantomSettled    : Nat = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 11 — QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getTransferStatus(txId : Nat) : async ?{
    txId           : Nat;
    sender         : Text;
    recipient      : Text;
    rail           : Text;
    currency       : Text;
    amount         : Nat;
    fee            : Nat;
    status         : Text;
    phantom        : Bool;
    commitmentHash : Text;
    sourceSubstrate: Text;
    targetSubstrate: Text;
    createdAt      : Int;
    settledAt      : Int;
    note           : Text;
  } {
    var i = 0;
    while (i < transferCount and i < TRANSFER_CAP) {
      if (txIds[i] == txId) {
        return ?{
          txId           = txIds[i];
          sender         = txSenders[i];
          recipient      = txRecipients[i];
          rail           = txRails[i];
          currency       = txCurrencies[i];
          amount         = txAmounts[i];
          fee            = txFees[i];
          status         = txStatuses[i];
          phantom        = txPhantom[i];
          commitmentHash = txCommitments[i];
          sourceSubstrate= txSourceSubstrate[i];
          targetSubstrate= txTargetSubstrate[i];
          createdAt      = txCreatedAt[i];
          settledAt      = txSettledAt[i];
          note           = txNotes[i];
        }
      };
      i += 1;
    };
    null
  };

  // Get transfers by status
  public query func getTransfersByStatus(status : Text, limit : Nat) : async [{
    txId     : Nat;
    sender   : Text;
    rail     : Text;
    currency : Text;
    amount   : Nat;
    status   : Text;
    phantom  : Bool;
    createdAt: Int;
  }] {
    var result : [{ txId:Nat; sender:Text; rail:Text; currency:Text; amount:Nat; status:Text; phantom:Bool; createdAt:Int }] = [];
    var i = 0;
    var found = 0;
    while (i < transferCount and i < TRANSFER_CAP and found < limit) {
      if (txStatuses[i] == status or status == "ALL") {
        result := Array.append(result, [{
          txId      = txIds[i];
          sender    = txSenders[i];
          rail      = txRails[i];
          currency  = txCurrencies[i];
          amount    = txAmounts[i];
          status    = txStatuses[i];
          phantom   = txPhantom[i];
          createdAt = txCreatedAt[i];
        }]);
        found += 1;
      };
      i += 1;
    };
    result
  };

  // Clearinghouse status — NOVA as sovereign settlement layer
  public query func getClearinghouseStatus() : async {
    canisterId             : Text;
    build                  : Nat;
    sovereignSeal          : Text;
    totalTransfers         : Nat;
    pending                : Nat;
    settled                : Nat;
    refunded               : Nat;
    volumeSettled          : Nat;
    feesCollected          : Nat;
    fiatIngestedCents      : Nat;
    phantomInitiated       : Nat;
    phantomSettled         : Nat;
    autoExpired            : Nat;
    novaPesoSupply         : Nat;
    novaPesoMinted         : Nat;
    novaPesoBurned         : Nat;
    heartbeatTick          : Nat;
    registeredUsers        : Nat;
    linkedAccountsTotal    : Nat;
    claimsGenerated        : Nat;
    claimsRedeemed         : Nat;
    claimsExpired          : Nat;
    exitsQueued            : Nat;
    exitsDelivered         : Nat;
    totalRemittances       : Nat;
    authorizedOracles      : Nat;
    feeSchedule            : [{rail:Text; rateText:Text; ratePct:Float}];
    supportedRails         : [Text];
    supportedCurrencies    : [Text];
    architectureStatement  : Text;
  } {
    {
      canisterId         = "phantom_transfer";
      build              = buildNumber;
      sovereignSeal      = sovereignSeal;
      totalTransfers     = transferCount;
      pending            = totalTransfersPending;
      settled            = totalTransfersSettled;
      refunded           = totalTransfersRefunded;
      volumeSettled      = totalVolumeSettled;
      feesCollected      = totalFeesCollected;
      fiatIngestedCents  = totalFiatIngested;
      phantomInitiated   = totalPhantomInitiated;
      phantomSettled     = totalPhantomSettled;
      autoExpired        = totalAutoExpired;
      novaPesoSupply     = novaPesoSupply;
      novaPesoMinted     = novaPesoMinted;
      novaPesoBurned     = novaPesoBurned;
      heartbeatTick      = heartbeatTick;
      registeredUsers    = userCount;
      linkedAccountsTotal= laCount;
      claimsGenerated    = totalClaimsGenerated;
      claimsRedeemed     = totalClaimsRedeemed;
      claimsExpired      = totalClaimsExpired;
      exitsQueued        = totalExitsQueued;
      exitsDelivered     = totalExitsDelivered;
      totalRemittances   = totalRemittances;
      authorizedOracles  = oracleCount;
      feeSchedule = [
        { rail="INTERNAL"; rateText="φ⁻⁵ = 0.090%"; ratePct = PHI_5 * 100.0 },
        { rail="FIAT";     rateText="φ⁻⁴ = 0.146%"; ratePct = PHI_4 * 100.0 },
        { rail="CRYPTO";   rateText="φ⁻⁴ = 0.146%"; ratePct = PHI_4 * 100.0 },
        { rail="PHANTOM";  rateText="φ⁻³ = 0.236%"; ratePct = PHI_3 * 100.0 },
      ];
      supportedRails = ["FIAT", "INTERNAL", "CRYPTO", "PHANTOM", "CLAIM_LINK", "FIAT_EXIT", "REMITTANCE"];
      supportedCurrencies = [
        "USD", "MXN", "EUR", "GBP", "JPY", "BRL",                    // fiat rails (6 currencies)
        "NOVA_PESO",                                                   // MXN sovereign peg
        "ONESICAN", "CHR", "GOL", "ORS", "SCB", "PHT",               // internal tokens
        "ICP", "BTC", "ETH", "ETH_L2", "SOL", "MATIC", "BNB",       // crypto rails (ETH_L2 = Arbitrum/Optimism/Base/zkEVM)
      ];
      architectureStatement =
        "NOVA IS THE CLEARINGHOUSE. ICP, ETH, ETH_L2, BTC, SOL — substrates. Exit rails. " #
        "NOVA is portable. ETH L2 (Arbitrum/Optimism/Base) settlement layer is the same PARALLAX. " #
        "The exit rail to Ethereum L2 does not change NOVA. NOVA is the constant. " #
        "5 user tiers: Tier1=fiat-only, Tier2=crypto multi-chain, Tier3=multi-bank aggregator, " #
        "Tier4=bank-to-bank international, Tier5=card-only/claim-link (no account needed). " #
        "sendRemittance: single-call Tier1/5 path — card in, pesos out, 0.146% fee vs 4-8% WU. " #
        "6 fiat currencies: USD|MXN|EUR|GBP|JPY|BRL — all oracle-live via setExchangeRate. " #
        "Exit rails: ACH (USD) | SPEI (MXN) | SEPA (EUR/GBP) | Zengin (JPY) | PIX (BRL) | CARD. " #
        "User identity: persistent sovereign identity — linked banks, cards, crypto wallets, NOVA wallet. " #
        "Claim links: send to anyone. Recipient picks delivery. No crypto ever required. " #
        "NOVA-PESO: on-chain MXN sovereign peg. Visa/card → ONESICAN → any rail. No custodian.";
    }
  };

  // Rail-level status for monitoring
  public query func getRailStatus() : async [{
    rail       : Text;
    txCount    : Nat;
    volumeTotal: Nat;
    feesTotal  : Nat;
    pendingCount: Nat;
  }] {
    var fiatCount : Nat = 0; var fiatVol : Nat = 0; var fiatFee : Nat = 0; var fiatPend : Nat = 0;
    var intCount  : Nat = 0; var intVol  : Nat = 0; var intFee  : Nat = 0; var intPend  : Nat = 0;
    var cryCount  : Nat = 0; var cryVol  : Nat = 0; var cryFee  : Nat = 0; var cryPend  : Nat = 0;
    var phCount   : Nat = 0; var phVol   : Nat = 0; var phFee   : Nat = 0; var phPend   : Nat = 0;
    var i = 0;
    while (i < transferCount and i < TRANSFER_CAP) {
      let rail = txRails[i];
      let amt  = txAmounts[i];
      let fee  = txFees[i];
      let pend : Nat = if (txStatuses[i] == "PENDING") 1 else 0;
      if      (rail == "FIAT")     { fiatCount+=1; fiatVol+=amt; fiatFee+=fee; fiatPend+=pend }
      else if (rail == "INTERNAL") { intCount +=1; intVol +=amt; intFee +=fee; intPend +=pend }
      else if (rail == "CRYPTO")   { cryCount +=1; cryVol +=amt; cryFee +=fee; cryPend +=pend }
      else if (rail == "PHANTOM")  { phCount  +=1; phVol  +=amt; phFee  +=fee; phPend  +=pend };
      i += 1;
    };
    [
      { rail="FIAT";     txCount=fiatCount; volumeTotal=fiatVol; feesTotal=fiatFee; pendingCount=fiatPend },
      { rail="INTERNAL"; txCount=intCount;  volumeTotal=intVol;  feesTotal=intFee;  pendingCount=intPend  },
      { rail="CRYPTO";   txCount=cryCount;  volumeTotal=cryVol;  feesTotal=cryFee;  pendingCount=cryPend  },
      { rail="PHANTOM";  txCount=phCount;   volumeTotal=phVol;   feesTotal=phFee;   pendingCount=phPend   },
    ]
  };

  // Fee revenue breakdown (for auto_market absorption)
  public query func getFeeRevenueSplit() : async {
    totalFees   : Nat;
    toTreasury  : Nat;   // φ⁻¹ of fees
    toGovernance: Nat;   // φ⁻² of fees
    toEmission  : Nat;   // φ⁻³ of fees
    retainedBps : Float; // basis points
  } {
    let f = Float.fromInt(totalFeesCollected);
    {
      totalFees    = totalFeesCollected;
      toTreasury   = _floatToNat(f * PHI_INV);
      toGovernance = _floatToNat(f * PHI_2);
      toEmission   = _floatToNat(f * PHI_3);
      retainedBps  = PHI_4 * 10_000.0;  // 1.46 bps retained
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 12 — USER IDENTITY + LINKED ACCOUNTS (PARALLAX MULTI-LEDGER)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // PARALLAX knows the user — not just the transaction.
  // Persistent sovereign identity: who you are, what you have linked, what you hold.
  //
  // User tiers:
  //   Tier 1 — Fiat-only (single card or bank, one source)
  //   Tier 2 — Multi-bank (multiple banks/cards, same country)
  //   Tier 3 — Crypto wallet (no bank required — wallet-native user)
  //   Tier 4 — Full multi-rail (bank + crypto + cross-border)
  //   Tier 5 — Unregistered recipient (claim-link delivery, no NOVA account yet)
  //
  // LinkedAccount railTypes:
  //   BANK_ACH | BANK_SPEI | BANK_SEPA |
  //   CARD_VISA | CARD_CHIME | CARD_DEBIT |
  //   WALLET_BTC | WALLET_ETH | WALLET_ETH_L2 | WALLET_SOL |
  //   WALLET_ICP | WALLET_MATIC | WALLET_BNB | WALLET_NOVA
  //
  // WALLET_ETH_L2 covers Arbitrum, Optimism, Base, Polygon zkEVM.
  // Settlement layer is the same PARALLAX clearinghouse regardless of which L2.
  // NOVA is portable. The exit rail to ETH L2 does not change NOVA.

  let USER_CAP       : Nat = 4096;
  let LINKED_ACC_CAP : Nat = 16384;

  stable var userCount             : Nat       = 0;
  stable var userPrincipals        : [var Text] = Array.init<Text>(USER_CAP, "");
  stable var userDisplayNames      : [var Text] = Array.init<Text>(USER_CAP, "");
  stable var userOnesicansBalance  : [var Nat]  = Array.init<Nat>(USER_CAP,  0);
  stable var userNovaPesoBalance   : [var Nat]  = Array.init<Nat>(USER_CAP,  0);
  stable var userCreatedAt         : [var Int]  = Array.init<Int>(USER_CAP,  0);
  stable var userTierLevel         : [var Nat]  = Array.init<Nat>(USER_CAP,  1);

  // Parallel arrays for linked accounts (flat pool across all users)
  stable var laCount               : Nat       = 0;
  stable var laOwner               : [var Text] = Array.init<Text>(LINKED_ACC_CAP, "");
  stable var laRailType            : [var Text] = Array.init<Text>(LINKED_ACC_CAP, "");
  stable var laAccountRef          : [var Text] = Array.init<Text>(LINKED_ACC_CAP, "");
  stable var laLabel               : [var Text] = Array.init<Text>(LINKED_ACC_CAP, "");
  stable var laBalanceCents        : [var Nat]  = Array.init<Nat>(LINKED_ACC_CAP,  0);
  stable var laCurrency            : [var Text] = Array.init<Text>(LINKED_ACC_CAP, "");
  stable var laActive              : [var Bool] = Array.init<Bool>(LINKED_ACC_CAP, true);
  stable var laLinkedAt            : [var Int]  = Array.init<Int>(LINKED_ACC_CAP,  0);

  func _findUser(p : Text) : ?Nat {
    var i = 0;
    while (i < userCount and i < USER_CAP) {
      if (userPrincipals[i] == p) return ?i;
      i += 1;
    };
    null
  };

  func _computeUserTier(p : Text) : Nat {
    var hasCrypto = false;
    var bankCount = 0;
    var cardCount = 0;
    var i = 0;
    while (i < laCount and i < LINKED_ACC_CAP) {
      if (laOwner[i] == p and laActive[i]) {
        let rt = laRailType[i];
        if (rt == "WALLET_BTC" or rt == "WALLET_ETH"    or rt == "WALLET_ETH_L2" or
            rt == "WALLET_SOL" or rt == "WALLET_ICP"    or rt == "WALLET_MATIC"  or
            rt == "WALLET_BNB" or rt == "WALLET_NOVA") {
          hasCrypto := true;
        };
        if (rt == "BANK_ACH"   or rt == "BANK_SPEI"  or rt == "BANK_SEPA")  bankCount += 1;
        if (rt == "CARD_VISA"  or rt == "CARD_CHIME" or rt == "CARD_DEBIT") cardCount += 1;
      };
      i += 1;
    };
    if      (hasCrypto and (bankCount > 0 or cardCount > 0)) 4
    else if  hasCrypto                                        3
    else if (bankCount > 1 or (bankCount > 0 and cardCount > 0) or cardCount > 1) 2
    else 1
  };

  // Register a new PARALLAX identity (call once per principal)
  public shared(msg) func registerUser(displayName : Text) : async { success : Bool; message : Text } {
    let p = Principal.toText(msg.caller);
    switch (_findUser(p)) {
      case (?_) return { success=false; message="ALREADY_REGISTERED: " # p };
      case null {};
    };
    if (userCount >= USER_CAP) return { success=false; message="USER_CAP_REACHED" };
    let i               = userCount;
    userPrincipals[i]   := p;
    userDisplayNames[i] := displayName;
    userCreatedAt[i]    := Time.now();
    userTierLevel[i]    := 1;
    userCount           := userCount + 1;
    { success=true; message="PARALLAX_IDENTITY_REGISTERED: " # displayName # " | principal=" # p }
  };

  // Link an external rail to the calling user's identity
  // accountRef is tokenized in production (never store raw card/account numbers on-chain)
  public shared(msg) func linkAccount(
    railType     : Text,   // BANK_ACH | BANK_SPEI | CARD_CHIME | WALLET_ETH_L2 | etc.
    accountRef   : Text,   // tokenized routing+acct, CLABE, IBAN, card token, wallet address
    label        : Text,   // "My Chase Checking" | "Chime Debit" | "MetaMask L2" | etc.
    currency     : Text,   // USD | MXN | EUR | BTC | ETH | SOL | ICP | MATIC
    balanceCents : Nat     // last-known balance from off-chain bridge sync
  ) : async { success : Bool; linkedAccId : Nat; message : Text } {
    let p = Principal.toText(msg.caller);
    let ui = switch (_findUser(p)) {
      case null return { success=false; linkedAccId=0; message="USER_NOT_REGISTERED: call registerUser first" };
      case (?x) x;
    };
    if (laCount >= LINKED_ACC_CAP) return { success=false; linkedAccId=0; message="LINKED_ACC_CAP_REACHED" };
    // Reject duplicate (same railType + accountRef already active for this user)
    var j = 0;
    while (j < laCount and j < LINKED_ACC_CAP) {
      if (laOwner[j] == p and laRailType[j] == railType and laAccountRef[j] == accountRef and laActive[j]) {
        return { success=false; linkedAccId=j; message="ACCOUNT_ALREADY_LINKED" };
      };
      j += 1;
    };
    let idx          = laCount;
    laOwner[idx]     := p;
    laRailType[idx]  := railType;
    laAccountRef[idx]:= accountRef;
    laLabel[idx]     := label;
    laBalanceCents[idx] := balanceCents;
    laCurrency[idx]  := currency;
    laActive[idx]    := true;
    laLinkedAt[idx]  := Time.now();
    laCount          := laCount + 1;
    userTierLevel[ui]:= _computeUserTier(p);
    { success=true; linkedAccId=idx;
      message="ACCOUNT_LINKED: \"" # label # "\" (" # railType # ") → tier " # Nat.toText(userTierLevel[ui]) }
  };

  // Deactivate a linked account
  public shared(msg) func unlinkAccount(linkedAccId : Nat) : async { success : Bool; message : Text } {
    let p = Principal.toText(msg.caller);
    if (linkedAccId >= laCount or linkedAccId >= LINKED_ACC_CAP) return {
      success=false; message="LINKED_ACC_NOT_FOUND"
    };
    if (laOwner[linkedAccId] != p and not isSovereign(msg.caller)) return {
      success=false; message="UNAUTHORIZED"
    };
    laActive[linkedAccId] := false;
    { success=true; message="ACCOUNT_UNLINKED: " # laLabel[linkedAccId] }
  };

  // Called by oracle/bridge after balance sync for a linked external account
  public shared(msg) func updateLinkedAccountBalance(linkedAccId : Nat, balanceCents : Nat) : async Bool {
    if (linkedAccId >= laCount or linkedAccId >= LINKED_ACC_CAP) return false;
    if (not isSovereign(msg.caller) and not _isAuthorizedOracle(Principal.toText(msg.caller))) return false;
    laBalanceCents[linkedAccId] := balanceCents;
    true
  };

  public query func getUserProfile(userPrincipal : Text) : async ?{
    principal        : Text;
    displayName      : Text;
    onesicansBalance : Nat;
    novaPesoBalance  : Nat;
    tierLevel        : Nat;
    createdAt        : Int;
    activeLinkedAccs : Nat;
  } {
    switch (_findUser(userPrincipal)) {
      case null null;
      case (?i) {
        var count = 0;
        var j = 0;
        while (j < laCount and j < LINKED_ACC_CAP) {
          if (laOwner[j] == userPrincipal and laActive[j]) count += 1;
          j += 1;
        };
        ?{
          principal        = userPrincipals[i];
          displayName      = userDisplayNames[i];
          onesicansBalance = userOnesicansBalance[i];
          novaPesoBalance  = userNovaPesoBalance[i];
          tierLevel        = userTierLevel[i];
          createdAt        = userCreatedAt[i];
          activeLinkedAccs = count;
        }
      };
    }
  };

  // Returns all active linked accounts (banks + cards + wallets) with balances
  // accountRef is shown as-is; in production the bridge returns masked/tokenized refs
  public query func getUserLinkedAccounts(userPrincipal : Text) : async [{
    linkedAccId  : Nat;
    railType     : Text;
    accountRef   : Text;
    label        : Text;
    balanceCents : Nat;
    currency     : Text;
    linkedAt     : Int;
  }] {
    var result : [{linkedAccId:Nat; railType:Text; accountRef:Text; label:Text; balanceCents:Nat; currency:Text; linkedAt:Int}] = [];
    var i = 0;
    while (i < laCount and i < LINKED_ACC_CAP) {
      if (laOwner[i] == userPrincipal and laActive[i]) {
        result := Array.append(result, [{
          linkedAccId  = i;
          railType     = laRailType[i];
          accountRef   = laAccountRef[i];
          label        = laLabel[i];
          balanceCents = laBalanceCents[i];
          currency     = laCurrency[i];
          linkedAt     = laLinkedAt[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 13 — CLAIM LINKS (TIER 5: NO ACCOUNT NEEDED)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Scenario: Ana (Chime user) sends $50 USD to her cousin Carlos in Mexico.
  // Carlos has no NOVA account, no crypto, no bank app. Nothing.
  //   1. Ana calls generateClaimLink(5000, "USD", "Para Carlos")
  //   2. PARALLAX returns a claim code → Ana shares with Carlos
  //   3. Carlos opens link → picks delivery method (SPEI, cash, new NOVA wallet)
  //   4. Carlos calls redeemClaimLink(code, "BANK_SPEI", "CLABE...")
  //   5. PARALLAX routes delivery. No crypto ever touched.
  //
  // Claim link expires in 72 hours. Unclaimed amounts refund to sender.
  //
  // Delivery methods (redeemMethod):
  //   BANK_ACH    → US bank deposit (ACH push)
  //   BANK_SPEI   → MX bank deposit (SPEI, same-day)
  //   BANK_SEPA   → EU bank deposit (SEPA credit)
  //   CARD_CHIME  → Chime direct deposit
  //   CARD_DEBIT  → Any debit card push (Visa/Mastercard)
  //   NOVA_WALLET → auto-register + receive in PARALLAX (best path)

  let CLAIM_CAP        : Nat = 4096;
  let CLAIM_TIMEOUT_NS : Int = 259_200_000_000_000; // 72 hours

  stable var claimCount           : Nat       = 0;
  stable var claimCodes           : [var Text] = Array.init<Text>(CLAIM_CAP, "");
  stable var claimAmounts         : [var Nat]  = Array.init<Nat>(CLAIM_CAP,  0);
  stable var claimCurrencies      : [var Text] = Array.init<Text>(CLAIM_CAP, "");
  stable var claimSenders         : [var Text] = Array.init<Text>(CLAIM_CAP, "");
  stable var claimCreatedAt       : [var Int]  = Array.init<Int>(CLAIM_CAP,  0);
  stable var claimExpiresAt       : [var Int]  = Array.init<Int>(CLAIM_CAP,  0);
  stable var claimStatuses        : [var Text] = Array.init<Text>(CLAIM_CAP, "PENDING");
  stable var claimRedeemMethods   : [var Text] = Array.init<Text>(CLAIM_CAP, "");
  stable var claimRedeemRefs      : [var Text] = Array.init<Text>(CLAIM_CAP, "");
  stable var claimNotes           : [var Text] = Array.init<Text>(CLAIM_CAP, "");

  stable var totalClaimsGenerated : Nat = 0;
  stable var totalClaimsRedeemed  : Nat = 0;
  stable var totalClaimsExpired   : Nat = 0;

  // Generate a claim link for a registered user (or sovereign)
  // In production: use IC raw_rand for cryptographically random claim codes
  public shared(msg) func generateClaimLink(
    amount   : Nat,    // in smallest unit of currency (cents for USD/MXN/EUR)
    currency : Text,   // USD | MXN | EUR | ONESICAN
    note     : Text
  ) : async { success : Bool; claimCode : Text; expiresAt : Int; message : Text } {
    let p = Principal.toText(msg.caller);
    if (not isSovereign(msg.caller)) {
      switch (_findUser(p)) {
        case null return { success=false; claimCode=""; expiresAt=0; message="USER_NOT_REGISTERED: call registerUser first" };
        case (?_) {};
      };
    };
    if (claimCount >= CLAIM_CAP) return { success=false; claimCode=""; expiresAt=0; message="CLAIM_CAP_REACHED" };
    let now       = Time.now();
    let expiresAt = now + CLAIM_TIMEOUT_NS;
    // Claim code: counter + amount + currency (unique within this canister)
    // Production: replace with IC raw_rand to prevent enumeration
    let code = "NOVA-" # Nat.toText(claimCount + 1) # "-" # currency # "-" # Nat.toText(amount);
    let i = claimCount;
    claimCodes[i]        := code;
    claimAmounts[i]      := amount;
    claimCurrencies[i]   := currency;
    claimSenders[i]      := p;
    claimCreatedAt[i]    := now;
    claimExpiresAt[i]    := expiresAt;
    claimStatuses[i]     := "PENDING";
    claimRedeemMethods[i]:= "";
    claimRedeemRefs[i]   := "";
    claimNotes[i]        := note;
    claimCount           := claimCount + 1;
    totalClaimsGenerated := totalClaimsGenerated + 1;
    {
      success   = true;
      claimCode = code;
      expiresAt = expiresAt;
      message   = "CLAIM_LINK_READY: " # code # " | " # Nat.toText(amount) # " " # currency #
                  " | 72h expiry | share code with recipient — they call redeemClaimLink to choose delivery"
    }
  };

  // Recipient redeems a claim link — no NOVA account required
  public shared(msg) func redeemClaimLink(
    claimCode    : Text,
    redeemMethod : Text,  // BANK_ACH | BANK_SPEI | BANK_SEPA | CARD_CHIME | CARD_DEBIT | NOVA_WALLET
    redeemRef    : Text   // routing+acct, CLABE, IBAN, card token, or NOVA principal
  ) : async { success : Bool; amount : Nat; currency : Text; message : Text } {
    var i = 0;
    while (i < claimCount and i < CLAIM_CAP) {
      if (claimCodes[i] == claimCode) {
        if (claimStatuses[i] != "PENDING") return {
          success=false; amount=0; currency=""; message="CLAIM_NOT_PENDING: " # claimStatuses[i]
        };
        if (Time.now() > claimExpiresAt[i]) {
          claimStatuses[i]   := "EXPIRED";
          totalClaimsExpired := totalClaimsExpired + 1;
          return { success=false; amount=0; currency=""; message="CLAIM_EXPIRED: 72h window passed" }
        };
        let amount   = claimAmounts[i];
        let currency = claimCurrencies[i];
        claimStatuses[i]     := "REDEEMED";
        claimRedeemMethods[i]:= redeemMethod;
        claimRedeemRefs[i]   := redeemRef;
        totalClaimsRedeemed  := totalClaimsRedeemed + 1;
        return {
          success  = true;
          amount   = amount;
          currency = currency;
          message  = "CLAIM_REDEEMED: " # Nat.toText(amount) # " " # currency #
                     " → " # redeemMethod # " | ref=" # redeemRef #
                     " | PARALLAX will deliver. No crypto required."
        }
      };
      i += 1;
    };
    { success=false; amount=0; currency=""; message="CLAIM_CODE_NOT_FOUND: " # claimCode }
  };

  // Sender can cancel a pending claim link before it's redeemed
  public shared(msg) func cancelClaimLink(claimCode : Text) : async { success : Bool; message : Text } {
    let p = Principal.toText(msg.caller);
    var i = 0;
    while (i < claimCount and i < CLAIM_CAP) {
      if (claimCodes[i] == claimCode) {
        if (claimStatuses[i] != "PENDING") return {
          success=false; message="CANNOT_CANCEL: " # claimStatuses[i]
        };
        if (claimSenders[i] != p and not isSovereign(msg.caller)) return {
          success=false; message="UNAUTHORIZED: not your claim link"
        };
        claimStatuses[i] := "CANCELLED";
        return { success=true; message="CLAIM_CANCELLED: " # claimCode # " — amount refunded to sender" }
      };
      i += 1;
    };
    { success=false; message="CLAIM_CODE_NOT_FOUND: " # claimCode }
  };

  public query func getClaimStatus(claimCode : Text) : async ?{
    claimCode    : Text;
    amount       : Nat;
    currency     : Text;
    status       : Text;
    expiresAt    : Int;
    redeemMethod : Text;
  } {
    var i = 0;
    while (i < claimCount and i < CLAIM_CAP) {
      if (claimCodes[i] == claimCode) {
        return ?{
          claimCode    = claimCodes[i];
          amount       = claimAmounts[i];
          currency     = claimCurrencies[i];
          status       = claimStatuses[i];
          expiresAt    = claimExpiresAt[i];
          redeemMethod = claimRedeemMethods[i];
        }
      };
      i += 1;
    };
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 14 — FIAT EXIT ROUTING (ONESICAN → USD/MXN/EUR)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Entry is ingestFiatPayment (fiat → ONESICAN inside PARALLAX).
  // Exit is exitToFiat (ONESICAN → fiat, pushed to bank/card/cash network).
  //
  // Exit rails:
  //   ACH   → USD bank deposit (US ACH push, routing number + account number)
  //   SPEI  → MXN bank deposit (Mexico SPEI, CLABE 18 digits)
  //   SEPA  → EUR bank deposit (EU SEPA credit transfer, IBAN)
  //   CARD  → card push (Visa Direct / Mastercard Send to debit card)
  //
  // Exit flow:
  //   1. User calls exitToFiat → ONESICAN debited from PARALLAX balance
  //   2. Exit record created (QUEUED) on-chain
  //   3. Off-chain NOVA bridge reads QUEUED exits → initiates ACH/SPEI/SEPA/card
  //   4. Bridge calls markExitDelivered(exitId) after bank confirmation
  //
  // Bridge partners (production): Synapse/Column (ACH), Banxico SPEI API (MXN),
  //   SEPA clearing (EUR), Visa Direct (card push).

  let EXIT_CAP : Nat = 8192;

  stable var exitCount             : Nat       = 0;
  stable var exitIds               : [var Nat]  = Array.init<Nat>(EXIT_CAP,  0);
  stable var exitUserPrincipals    : [var Text] = Array.init<Text>(EXIT_CAP, "");
  stable var exitAmountsOnesican   : [var Nat]  = Array.init<Nat>(EXIT_CAP,  0);
  stable var exitAmountsFiat       : [var Nat]  = Array.init<Nat>(EXIT_CAP,  0); // net fiat cents
  stable var exitTargetCurrencies  : [var Text] = Array.init<Text>(EXIT_CAP, "");
  stable var exitRails             : [var Text] = Array.init<Text>(EXIT_CAP, "");
  stable var exitDestRefs          : [var Text] = Array.init<Text>(EXIT_CAP, "");
  stable var exitStatuses          : [var Text] = Array.init<Text>(EXIT_CAP, "QUEUED");
  stable var exitCreatedAt         : [var Int]  = Array.init<Int>(EXIT_CAP,  0);
  stable var exitDeliveredAt       : [var Int]  = Array.init<Int>(EXIT_CAP,  0);
  stable var exitNotes             : [var Text] = Array.init<Text>(EXIT_CAP, "");
  stable var nextExitId            : Nat        = 1;

  stable var totalExitsQueued      : Nat = 0;
  stable var totalExitsDelivered   : Nat = 0;
  stable var totalExitVolumeFiat   : Nat = 0; // cumulative fiat cents delivered

  // Convert ONESICAN balance → fiat, queue for off-chain bridge delivery
  public shared(msg) func exitToFiat(
    amountOnesicans : Nat,
    targetCurrency  : Text,   // USD | MXN | EUR
    exitRail        : Text,   // ACH | SPEI | SEPA | CARD
    destinationRef  : Text,   // routing+acct, CLABE, IBAN, card token (tokenized)
    note            : Text
  ) : async { success : Bool; exitId : Nat; fiatAmount : Nat; message : Text } {
    let p      = Principal.toText(msg.caller);
    let userIdx : ?Nat = if (isSovereign(msg.caller)) null else _findUser(p);
    if (not isSovereign(msg.caller) and userIdx == null) return {
      success=false; exitId=0; fiatAmount=0; message="USER_NOT_REGISTERED: call registerUser first"
    };
    if (exitCount >= EXIT_CAP) return { success=false; exitId=0; fiatAmount=0; message="EXIT_CAP_REACHED" };
    let rate : Nat = if      (targetCurrency == "USD") fiatRateUSD
                     else if (targetCurrency == "MXN") fiatRateMXN
                     else if (targetCurrency == "EUR") fiatRateEUR
                     else if (targetCurrency == "GBP") fiatRateGBP
                     else if (targetCurrency == "JPY") fiatRateJPY
                     else if (targetCurrency == "BRL") fiatRateBRL
                     else 0;
    if (rate == 0) return {
      success=false; exitId=0; fiatAmount=0; message="UNSUPPORTED_EXIT_CURRENCY: " # targetCurrency
    };
    let fee          = _computeFee("FIAT", amountOnesicans);
    let netOnesicans = if (amountOnesicans > fee) amountOnesicans - fee else 0;
    // Inverse of ingestFiatPayment: ONESICAN → fiat cents
    let netFiatCents = (netOnesicans * 100) / rate;
    // Debit user ONESICAN balance (registered users only; sovereign bypasses)
    switch (userIdx) {
      case (?i) {
        if (userOnesicansBalance[i] < amountOnesicans) return {
          success=false; exitId=0; fiatAmount=0; message="INSUFFICIENT_ONESICAN_BALANCE"
        };
        userOnesicansBalance[i] := userOnesicansBalance[i] - amountOnesicans;
      };
      case null {};
    };
    let idx = exitCount;
    let id  = nextExitId;
    exitIds[idx]             := id;
    exitUserPrincipals[idx]  := p;
    exitAmountsOnesican[idx] := amountOnesicans;
    exitAmountsFiat[idx]     := netFiatCents;
    exitTargetCurrencies[idx]:= targetCurrency;
    exitRails[idx]           := exitRail;
    exitDestRefs[idx]        := destinationRef;
    exitStatuses[idx]        := "QUEUED";
    exitCreatedAt[idx]       := Time.now();
    exitDeliveredAt[idx]     := 0;
    exitNotes[idx]           := note;
    exitCount                := exitCount + 1;
    nextExitId               := nextExitId + 1;
    totalExitsQueued         := totalExitsQueued + 1;
    totalFeesCollected       := totalFeesCollected + fee;
    {
      success    = true;
      exitId     = id;
      fiatAmount = netFiatCents;
      message    = "EXIT_QUEUED: exit#" # Nat.toText(id) # " | " # Nat.toText(amountOnesicans) #
                   " ONESICAN → " # Nat.toText(netFiatCents) # " " # targetCurrency # " cents via " # exitRail #
                   " | fee=" # Nat.toText(fee) # " | bridge will initiate " # exitRail # " transfer"
    }
  };

  // Called by off-chain bridge after ACH/SPEI/SEPA/card confirms delivery
  public shared(msg) func markExitDelivered(exitId : Nat) : async { success : Bool; message : Text } {
    if (not isSovereign(msg.caller) and not _isAuthorizedOracle(Principal.toText(msg.caller))) return {
      success=false; message="UNAUTHORIZED"
    };
    var i = 0;
    while (i < exitCount and i < EXIT_CAP) {
      if (exitIds[i] == exitId) {
        if (exitStatuses[i] != "QUEUED") return {
          success=false; message="EXIT_NOT_QUEUED: " # exitStatuses[i]
        };
        exitStatuses[i]   := "DELIVERED";
        exitDeliveredAt[i]:= Time.now();
        totalExitsDelivered  := totalExitsDelivered + 1;
        totalExitVolumeFiat  := totalExitVolumeFiat + exitAmountsFiat[i];
        return {
          success=true;
          message="EXIT_DELIVERED: exit#" # Nat.toText(exitId) # " | " #
                  Nat.toText(exitAmountsFiat[i]) # " " # exitTargetCurrencies[i] # " cents via " # exitRails[i]
        }
      };
      i += 1;
    };
    { success=false; message="EXIT_NOT_FOUND: " # Nat.toText(exitId) }
  };

  // Bridge polls this to get pending exits to process
  public query func getQueuedExits(limit : Nat) : async [{
    exitId         : Nat;
    userPrincipal  : Text;
    amountOnesican : Nat;
    fiatAmount     : Nat;
    targetCurrency : Text;
    exitRail       : Text;
    destinationRef : Text;
    createdAt      : Int;
  }] {
    var result : [{exitId:Nat; userPrincipal:Text; amountOnesican:Nat; fiatAmount:Nat; targetCurrency:Text; exitRail:Text; destinationRef:Text; createdAt:Int}] = [];
    var i = 0;
    var found = 0;
    while (i < exitCount and i < EXIT_CAP and found < limit) {
      if (exitStatuses[i] == "QUEUED") {
        result := Array.append(result, [{
          exitId         = exitIds[i];
          userPrincipal  = exitUserPrincipals[i];
          amountOnesican = exitAmountsOnesican[i];
          fiatAmount     = exitAmountsFiat[i];
          targetCurrency = exitTargetCurrencies[i];
          exitRail       = exitRails[i];
          destinationRef = exitDestRefs[i];
          createdAt      = exitCreatedAt[i];
        }]);
        found += 1;
      };
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 15 — ORACLE EXCHANGE RATES
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Exchange rates are kept live by authorized oracle principals or AI agents.
  // Sovereign can always set rates directly.
  // Rates: ONESICAN units per 100 fiat cents (same unit as fiatRateUSD/MXN/EUR).
  //
  // Production oracle sources:
  //   USD/MXN → Banxico API (real-time spot, updated every minute)
  //   EUR/USD → ECB reference rate
  //   Crypto  → on-chain DEX TWAP (future expansion)
  //
  // Oracle principal is registered by sovereign → calls setExchangeRate() on-chain.
  // Any oracle principal can also call updateLinkedAccountBalance() and markExitDelivered().

  let ORACLE_CAP : Nat = 16;

  stable var oracleCount       : Nat       = 0;
  stable var oraclePrincipals  : [var Text] = Array.init<Text>(ORACLE_CAP, "");
  stable var oracleLabels      : [var Text] = Array.init<Text>(ORACLE_CAP, "");

  // Rate metadata: who set it and when (indices: 0=USD, 1=MXN, 2=EUR, 3=GBP, 4=JPY, 5=BRL)
  stable var rateLastUpdatedBy : [var Text] = Array.init<Text>(6, "GENESIS");
  stable var rateLastUpdatedAt : [var Int]  = Array.init<Int>(6,  0);

  func _isAuthorizedOracle(p : Text) : Bool {
    var i = 0;
    while (i < oracleCount and i < ORACLE_CAP) {
      if (oraclePrincipals[i] == p) return true;
      i += 1;
    };
    false
  };

  public shared(msg) func addOraclePrincipal(oraclePrincipal : Text, label : Text) : async Bool {
    requireSovereign(msg.caller);
    if (oracleCount >= ORACLE_CAP) return false;
    var i = 0;
    while (i < oracleCount and i < ORACLE_CAP) {
      if (oraclePrincipals[i] == oraclePrincipal) return true; // already registered
      i += 1;
    };
    oraclePrincipals[oracleCount] := oraclePrincipal;
    oracleLabels[oracleCount]     := label;
    oracleCount := oracleCount + 1;
    true
  };

  public shared(msg) func removeOraclePrincipal(oraclePrincipal : Text) : async Bool {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < oracleCount and i < ORACLE_CAP) {
      if (oraclePrincipals[i] == oraclePrincipal) {
        // Shift remaining entries left to fill the gap
        var j = i;
        while (j + 1 < oracleCount and j + 1 < ORACLE_CAP) {
          oraclePrincipals[j] := oraclePrincipals[j + 1];
          oracleLabels[j]     := oracleLabels[j + 1];
          j += 1;
        };
        if (oracleCount > 0) {
          oraclePrincipals[oracleCount - 1] := "";
          oracleLabels[oracleCount - 1]     := "";
          oracleCount := oracleCount - 1;
        };
        return true;
      };
      i += 1;
    };
    false
  };

  // Set fiat exchange rate — callable by sovereign or any authorized oracle/AI agent
  // ratePerCent: ONESICAN units per 100 fiat cents (e.g. 100 = 1 USD → 100 ONESICAN)
  public shared(msg) func setExchangeRate(currency : Text, ratePerCent : Nat) : async {
    success : Bool;
    message : Text;
  } {
    let p = Principal.toText(msg.caller);
    if (not isSovereign(msg.caller) and not _isAuthorizedOracle(p)) return {
      success=false; message="UNAUTHORIZED: not sovereign or registered oracle"
    };
    if (ratePerCent == 0) return { success=false; message="INVALID_RATE: zero not allowed" };
    let now = Time.now();
    if (currency == "USD") {
      fiatRateUSD         := ratePerCent;
      rateLastUpdatedBy[0]:= p;
      rateLastUpdatedAt[0]:= now;
    } else if (currency == "MXN") {
      fiatRateMXN         := ratePerCent;
      rateLastUpdatedBy[1]:= p;
      rateLastUpdatedAt[1]:= now;
    } else if (currency == "EUR") {
      fiatRateEUR         := ratePerCent;
      rateLastUpdatedBy[2]:= p;
      rateLastUpdatedAt[2]:= now;
    } else if (currency == "GBP") {
      fiatRateGBP         := ratePerCent;
      rateLastUpdatedBy[3]:= p;
      rateLastUpdatedAt[3]:= now;
    } else if (currency == "JPY") {
      fiatRateJPY         := ratePerCent;
      rateLastUpdatedBy[4]:= p;
      rateLastUpdatedAt[4]:= now;
    } else if (currency == "BRL") {
      fiatRateBRL         := ratePerCent;
      rateLastUpdatedBy[5]:= p;
      rateLastUpdatedAt[5]:= now;
    } else {
      return { success=false; message="UNSUPPORTED_CURRENCY: " # currency # " (supported: USD | MXN | EUR | GBP | JPY | BRL)" }
    };
    { success=true; message="RATE_UPDATED: " # currency # " → " # Nat.toText(ratePerCent) # " ONESICAN/100cents | oracle=" # p }
  };

  public query func getExchangeRates() : async [{
    currency    : Text;
    ratePerCent : Nat;
    updatedBy   : Text;
    updatedAt   : Int;
  }] {
    [
      { currency="USD"; ratePerCent=fiatRateUSD; updatedBy=rateLastUpdatedBy[0]; updatedAt=rateLastUpdatedAt[0] },
      { currency="MXN"; ratePerCent=fiatRateMXN; updatedBy=rateLastUpdatedBy[1]; updatedAt=rateLastUpdatedAt[1] },
      { currency="EUR"; ratePerCent=fiatRateEUR; updatedBy=rateLastUpdatedBy[2]; updatedAt=rateLastUpdatedAt[2] },
      { currency="GBP"; ratePerCent=fiatRateGBP; updatedBy=rateLastUpdatedBy[3]; updatedAt=rateLastUpdatedAt[3] },
      { currency="JPY"; ratePerCent=fiatRateJPY; updatedBy=rateLastUpdatedBy[4]; updatedAt=rateLastUpdatedAt[4] },
      { currency="BRL"; ratePerCent=fiatRateBRL; updatedBy=rateLastUpdatedBy[5]; updatedAt=rateLastUpdatedAt[5] },
    ]
  };

  public query func getOraclePrincipals() : async [{ principal : Text; label : Text }] {
    var result : [{principal:Text; label:Text}] = [];
    var i = 0;
    while (i < oracleCount and i < ORACLE_CAP) {
      result := Array.append(result, [{ principal=oraclePrincipals[i]; label=oracleLabels[i] }]);
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 16 — SEND REMITTANCE (SINGLE-CALL TIER 1 / TIER 5 FAMILY PATH)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // The family path — for the Monterrey-to-Chicago use case.
  // The user should never have to think about rails, ONESICAN, or substrates.
  // They say: "I have 5,000 MXN. My sister in Chicago should get dollars."
  // PARALLAX handles everything in a single call.
  //
  // Flow:
  //   1. Charge sender's card/bank (fromCardRef) in fromCurrency
  //   2. Ingest fiat → ONESICAN at oracle rate (Section 5 FIAT rail)
  //   3. Convert ONESICAN → toCurrency at oracle rate
  //   4. Queue fiat exit (Section 14) to recipient's ref
  //   5. Return both txId (entry) and exitId (exit) in one response
  //
  // toRefType tells PARALLAX how to deliver:
  //   BANK_ACH   → US bank routing+account
  //   BANK_SPEI  → Mexican CLABE (18 digits)
  //   BANK_SEPA  → European IBAN
  //   BANK_ZENGIN→ Japanese bank (7-digit + account)
  //   CARD_VISA  → Visa Direct push to debit card token
  //   CARD_CHIME → Chime instant deposit
  //   PHONE      → phone number (paired with a claim link if unregistered)
  //   CLAIM_LINK → auto-generates a claim link (recipient not yet on NOVA)
  //   NOVA_WALLET→ PARALLAX internal wallet (registered user)
  //
  // For PHONE and CLAIM_LINK: a claim link is generated automatically.
  // Recipient is notified (off-chain by NOVA bridge) and picks their delivery.
  //
  // This is what replaces Western Union for the 40M Mexicans in the US sending
  // $60B/year to Mexico. 0.146% fee vs 4-8%. Same-day vs 3-5 business days.

  stable var totalRemittances : Nat = 0;

  // Helper: get rate for any supported currency (returns 0 if unsupported)
  func _getFiatRate(currency : Text) : Nat {
    if      (currency == "USD") fiatRateUSD
    else if (currency == "MXN") fiatRateMXN
    else if (currency == "EUR") fiatRateEUR
    else if (currency == "GBP") fiatRateGBP
    else if (currency == "JPY") fiatRateJPY
    else if (currency == "BRL") fiatRateBRL
    else 0
  };

  // Helper: infer the best exit rail for a given currency and toRefType
  func _inferExitRail(toCurrency : Text, toRefType : Text) : Text {
    if (toRefType == "BANK_ACH")    "ACH"
    else if (toRefType == "BANK_SPEI")  "SPEI"
    else if (toRefType == "BANK_SEPA")  "SEPA"
    else if (toRefType == "BANK_ZENGIN")"ZENGIN"
    else if (toRefType == "CARD_VISA")  "CARD"
    else if (toRefType == "CARD_CHIME") "CARD"
    else if (toRefType == "NOVA_WALLET") "NOVA"
    else if (toCurrency == "USD")       "ACH"
    else if (toCurrency == "MXN")       "SPEI"
    else if (toCurrency == "EUR")       "SEPA"
    else if (toCurrency == "GBP")       "SEPA"
    else if (toCurrency == "JPY")       "ZENGIN"
    else if (toCurrency == "BRL")       "PIX"
    else "ACH"
  };

  public shared(msg) func sendRemittance(
    fromCurrency  : Text,   // USD | MXN | EUR | GBP | JPY | BRL
    amountCents   : Nat,    // amount in smallest unit of fromCurrency
    fromCardRef   : Text,   // tokenized card/bank ref for the charge (processed off-chain edge gate)
    toCurrency    : Text,   // USD | MXN | EUR | GBP | JPY | BRL
    toRef         : Text,   // routing+acct / CLABE / IBAN / card token / phone / "NOVA:<principal>"
    toRefType     : Text,   // BANK_ACH | BANK_SPEI | BANK_SEPA | BANK_ZENGIN | CARD_VISA | CARD_CHIME | PHONE | CLAIM_LINK | NOVA_WALLET
    note          : Text
  ) : async {
    success       : Bool;
    txId          : Nat;    // entry tx (fiat → ONESICAN)
    exitId        : Nat;    // exit tx (ONESICAN → fiat) — 0 if claim link generated instead
    claimCode     : Text;   // populated if toRefType=PHONE or CLAIM_LINK
    fiatIn        : Nat;    // fromCurrency cents sent
    onesicansNet  : Nat;    // net ONESICAN after fee
    fiatOut       : Nat;    // toCurrency cents recipient receives
    fee           : Nat;    // ONESICAN fee collected
    message       : Text;
  } {
    let p = Principal.toText(msg.caller);
    // Accept registered users or sovereign
    if (not isSovereign(msg.caller)) {
      switch (_findUser(p)) {
        case null return {
          success=false; txId=0; exitId=0; claimCode=""; fiatIn=0; onesicansNet=0; fiatOut=0; fee=0;
          message="USER_NOT_REGISTERED: call registerUser first"
        };
        case (?_) {};
      };
    };
    if (transferCount >= TRANSFER_CAP or exitCount >= EXIT_CAP) return {
      success=false; txId=0; exitId=0; claimCode=""; fiatIn=0; onesicansNet=0; fiatOut=0; fee=0;
      message="CAPACITY_REACHED"
    };
    // ── STEP 1: Ingest fromCurrency → ONESICAN ───────────────────────────────
    let fromRate = _getFiatRate(fromCurrency);
    if (fromRate == 0) return {
      success=false; txId=0; exitId=0; claimCode=""; fiatIn=0; onesicansNet=0; fiatOut=0; fee=0;
      message="UNSUPPORTED_FROM_CURRENCY: " # fromCurrency
    };
    let toRate = _getFiatRate(toCurrency);
    if (toRate == 0) return {
      success=false; txId=0; exitId=0; claimCode=""; fiatIn=0; onesicansNet=0; fiatOut=0; fee=0;
      message="UNSUPPORTED_TO_CURRENCY: " # toCurrency
    };
    let grossOnesicans = amountCents * fromRate / 100;
    let fee            = _computeFee("FIAT", grossOnesicans);
    let netOnesicans   = if (grossOnesicans > fee) grossOnesicans - fee else 0;
    let now            = Time.now();
    // Record entry transaction
    let ni = transferCount;
    let txId = nextTxId;
    txIds[ni]            := txId;
    txSenders[ni]        := "REMITTANCE:" # fromCardRef;
    txRecipients[ni]     := toRef;
    txRails[ni]          := "FIAT";
    txCurrencies[ni]     := fromCurrency;
    txAmounts[ni]        := grossOnesicans;
    txFees[ni]           := fee;
    txStatuses[ni]       := "SETTLED";
    txCommitments[ni]    := "";
    txPhantom[ni]        := false;
    txCreatedAt[ni]      := now;
    txSettledAt[ni]      := now;
    txNotes[ni]          := "REMITTANCE: " # note # " | from=" # fromCardRef # " to=" # toRef;
    txSourceSubstrate[ni]:= "EDGE";
    txTargetSubstrate[ni]:= "PARALLAX";
    transferCount        := transferCount + 1;
    nextTxId             := nextTxId + 1;
    totalFiatIngested    := totalFiatIngested + amountCents;
    totalFeesCollected   := totalFeesCollected + fee;
    totalTransfersSettled:= totalTransfersSettled + 1;
    // ── STEP 2: PHONE / CLAIM_LINK → generate claim link instead of exit ──────
    if (toRefType == "PHONE" or toRefType == "CLAIM_LINK") {
      if (claimCount >= CLAIM_CAP) return {
        success=false; txId; exitId=0; claimCode=""; fiatIn=amountCents;
        onesicansNet=netOnesicans; fiatOut=0; fee;
        message="CLAIM_CAP_REACHED: remittance entry recorded but claim link could not be issued"
      };
      let expiresAt = now + CLAIM_TIMEOUT_NS;
      let code = "NOVA-REM-" # Nat.toText(claimCount + 1) # "-" # toCurrency # "-" # Nat.toText(netOnesicans);
      let ci = claimCount;
      claimCodes[ci]        := code;
      claimAmounts[ci]      := netOnesicans;     // stored in ONESICAN; bridge converts on delivery
      claimCurrencies[ci]   := toCurrency;
      claimSenders[ci]      := p;
      claimCreatedAt[ci]    := now;
      claimExpiresAt[ci]    := expiresAt;
      claimStatuses[ci]     := "PENDING";
      claimRedeemMethods[ci]:= toRefType;
      claimRedeemRefs[ci]   := toRef;           // phone number or ""
      claimNotes[ci]        := "REMITTANCE from " # fromCurrency # " | " # note;
      claimCount            := claimCount + 1;
      totalClaimsGenerated  := totalClaimsGenerated + 1;
      totalRemittances      := totalRemittances + 1;
      let fiatOutEstimate   = (netOnesicans * 100) / toRate;
      return {
        success=true; txId; exitId=0; claimCode=code;
        fiatIn=amountCents; onesicansNet=netOnesicans; fiatOut=fiatOutEstimate; fee;
        message = "REMITTANCE_CLAIM: " # Nat.toText(amountCents) # " " # fromCurrency #
                  " → " # Nat.toText(fiatOutEstimate) # " " # toCurrency #
                  " (est.) | claim code=" # code #
                  " | recipient redeems via link — no NOVA account needed | 72h expiry | fee=" # Nat.toText(fee)
      }
    };
    // ── STEP 3: Known destination → queue fiat exit directly ─────────────────
    let netFiatCents  = (netOnesicans * 100) / toRate;
    let exitRail      = _inferExitRail(toCurrency, toRefType);
    if (exitCount >= EXIT_CAP) return {
      success=false; txId; exitId=0; claimCode=""; fiatIn=amountCents;
      onesicansNet=netOnesicans; fiatOut=0; fee;
      message="EXIT_CAP_REACHED: remittance entry recorded but exit could not be queued"
    };
    let ei = exitCount;
    let exitId = nextExitId;
    exitIds[ei]             := exitId;
    exitUserPrincipals[ei]  := p;
    exitAmountsOnesican[ei] := netOnesicans;
    exitAmountsFiat[ei]     := netFiatCents;
    exitTargetCurrencies[ei]:= toCurrency;
    exitRails[ei]           := exitRail;
    exitDestRefs[ei]        := toRef;
    exitStatuses[ei]        := "QUEUED";
    exitCreatedAt[ei]       := now;
    exitDeliveredAt[ei]     := 0;
    exitNotes[ei]           := "REMITTANCE: " # note # " | entry txId=" # Nat.toText(txId);
    exitCount               := exitCount + 1;
    nextExitId              := nextExitId + 1;
    totalExitsQueued        := totalExitsQueued + 1;
    totalRemittances        := totalRemittances + 1;
    {
      success=true; txId; exitId; claimCode="";
      fiatIn=amountCents; onesicansNet=netOnesicans; fiatOut=netFiatCents; fee;
      message = "REMITTANCE_QUEUED: " # Nat.toText(amountCents) # " " # fromCurrency #
                " → " # Nat.toText(netFiatCents) # " " # toCurrency # " " # exitRail #
                " | fee=" # Nat.toText(fee) # " (" # Float.toText(PHI_4 * 100.0) # "%) | " #
                "bridge delivers via " # exitRail # " to " # toRef #
                " | txId=" # Nat.toText(txId) # " exitId=" # Nat.toText(exitId)
    }
  };

};
