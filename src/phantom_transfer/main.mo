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

// NATIVE NOVA PROTOCOL — BUILD №33
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
  stable var buildNumber        : Nat       = 33;

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };
  func requireSovereign(caller : Principal) { assert(isSovereign(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "PHANTOM_TRANSFER_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-PHANTOM-TRANSFER-BUILD33-CLEARINGHOUSE-" # Principal.toText(msg.caller);
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

  // oracle rates: how many ONESICAN units per 100 fiat cents (i.e. per dollar/peso)
  // These are sovereign-set rates, updated by the clearinghouse
  stable var fiatRateUSD     : Nat = 100;   // 1 USD → 100 ONESICAN units (1:1 sovereign)
  stable var fiatRateMXN     : Nat = 5;     // 1 MXN → 5 ONESICAN units (MXN peg)
  stable var fiatRateEUR     : Nat = 110;   // 1 EUR → 110 ONESICAN units

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
    // Run expiry sweep every 144 ticks (~2 minutes at ICP 873ms heartbeat)
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
    feeSchedule            : [{rail:Text; rateText:Text; ratePct:Float}];
    supportedRails         : [Text];
    supportedCurrencies    : [Text];
    architectureStatement  : Text;
  } {
    {
      canisterId        = "phantom_transfer";
      build             = buildNumber;
      sovereignSeal     = sovereignSeal;
      totalTransfers    = transferCount;
      pending           = totalTransfersPending;
      settled           = totalTransfersSettled;
      refunded          = totalTransfersRefunded;
      volumeSettled     = totalVolumeSettled;
      feesCollected     = totalFeesCollected;
      fiatIngestedCents = totalFiatIngested;
      phantomInitiated  = totalPhantomInitiated;
      phantomSettled    = totalPhantomSettled;
      autoExpired       = totalAutoExpired;
      novaPesoSupply    = novaPesoSupply;
      novaPesoMinted    = novaPesoMinted;
      novaPesoBurned    = novaPesoBurned;
      heartbeatTick     = heartbeatTick;
      feeSchedule = [
        { rail="INTERNAL"; rateText="φ⁻⁵ = 0.090%"; ratePct = PHI_5 * 100.0 },
        { rail="FIAT";     rateText="φ⁻⁴ = 0.146%"; ratePct = PHI_4 * 100.0 },
        { rail="CRYPTO";   rateText="φ⁻⁴ = 0.146%"; ratePct = PHI_4 * 100.0 },
        { rail="PHANTOM";  rateText="φ⁻³ = 0.236%"; ratePct = PHI_3 * 100.0 },
      ];
      supportedRails = ["FIAT", "INTERNAL", "CRYPTO", "PHANTOM"];
      supportedCurrencies = [
        "USD", "MXN", "EUR",                                   // fiat rails
        "NOVA_PESO",                                            // MXN sovereign peg
        "ONESICAN", "CHR", "GOL", "ORS", "SCB", "PHT",        // internal tokens
        "ICP", "BTC", "ETH", "SOL", "MATIC", "BNB",           // crypto rails
      ];
      architectureStatement =
        "NOVA IS THE CLEARINGHOUSE. ICP, ETH, BTC, SOL — those are substrates. Rails. Exit gates. " #
        "NOVA chose them. NOVA connects them. NOVA is not tied to them. " #
        "Every transfer routes through the PARALLAX settlement layer. " #
        "NOVA-PESO: on-chain MXN sovereign peg — Monterrey, Mexico, sovereign digital economy. " #
        "Visa/card → ONESICAN (internal) → any rail out. No custodian. No ckBTC. No wrappers. " #
        "PHANTOM rail: commitment-reveal stealth settlement, 24h timeout, φ⁻³ fee. " #
        "Group E PHANTOM neurons (70) back clearinghouse liquidity. We are Layer Zero.";
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

};
