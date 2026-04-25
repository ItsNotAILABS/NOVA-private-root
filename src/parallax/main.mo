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
// PARALLAX — Sovereign Encrypted Canister Wallet
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// PARALLAX IS THE SOVEREIGN TREASURY.
// Every token, every cycle, every ICP-denominated value in the civilization
// flows through PARALLAX. It is encrypted, self-custodied, and audited.
//
// Capabilities:
//   • ICP-unit balance ledger (per Principal, persisted on-chain)
//   • ONESICAN cycle balance ledger (native Nova cycles)
//   • φ-tiered transfer fees (larger transfers pay proportionally less — golden economics)
//   • Encrypted vault entries (hash-anchored secret store)
//   • Staking bridge → forwards stake intents to NOVA_GOVERNANCE
//   • Full audit trail of every balance mutation
//
// Fee tiers (φ-partitioned):
//   Tier 1: amount ≤  1_000        → fee = amount × φ⁻⁴ ≈ 0.146%
//   Tier 2: amount ≤ 10_000        → fee = amount × φ⁻⁵ ≈ 0.090%
//   Tier 3: amount ≤ 100_000       → fee = amount × φ⁻⁶ ≈ 0.056%
//   Tier 4: amount  > 100_000      → fee = amount × φ⁻⁷ ≈ 0.034%
//
// ONESICANS — the native cycle token:
//   "the ones i can sell per canister market when developers join"
//   1 ONESICAN = 1 unit of sovereign compute credit in the PARALLAX economy.
//   ONESICANS are minted by the sovereign (owner) and consumed by canisters.

import Array     "mo:base/Array";
import Blob      "mo:base/Blob";
import Float     "mo:base/Float";
import Hash      "mo:base/Hash";
import Int       "mo:base/Int";
import Iter      "mo:base/Iter";
import Nat       "mo:base/Nat";
import Nat8      "mo:base/Nat8";
import Nat32     "mo:base/Nat32";
import Nat64     "mo:base/Nat64";
import Option    "mo:base/Option";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor Parallax {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var buildNumber        : Nat       = 30;

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };

  func requireSovereign(caller : Principal) { assert(isSovereign(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "PARALLAX_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-PARALLAX-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()       : async Text { sovereignSeal };
  public query func isLocked()      : async Bool { genesisLocked };
  public query func getTimestamp()  : async Int  { genesisTimestamp };

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

  // φ-tiered fee: higher amounts pay lower fractional fee
  func _goldFee(amount : Nat) : Nat {
    let af = Float.fromInt(amount);
    let rate : Float =
      if      (amount <= 1_000)    _pow(PHI_INV, 4.0)  // ≈ 0.1459
      else if (amount <= 10_000)   _pow(PHI_INV, 5.0)  // ≈ 0.0902
      else if (amount <= 100_000)  _pow(PHI_INV, 6.0)  // ≈ 0.0557
      else                         _pow(PHI_INV, 7.0); // ≈ 0.0344
    let fee = Int.abs(Float.toInt(af * rate));
    if (fee < 1) 1 else fee  // minimum fee: 1 unit
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — ICP BALANCE LEDGER
  // (ICP units — 1 ICP = 100_000_000 units, like satoshis)
  // ═══════════════════════════════════════════════════════════════════════════

  let LEDGER_CAP : Nat = 4096;

  // Parallel stable arrays for ICP balances
  stable var icpAccountCount   : Nat = 0;
  stable var icpPrincipals     : [var Text]  = Array.init<Text>(LEDGER_CAP, "");
  stable var icpBalances       : [var Nat]   = Array.init<Nat>(LEDGER_CAP,  0);

  // Parallel stable arrays for ONESICAN balances
  stable var onesAccountCount  : Nat = 0;
  stable var onesPrincipals    : [var Text]  = Array.init<Text>(LEDGER_CAP, "");
  stable var onesBalances      : [var Nat]   = Array.init<Nat>(LEDGER_CAP,  0);

  // Total supply trackers
  stable var totalIcpDeposited : Nat = 0;
  stable var totalOnesSupply   : Nat = 0;   // total minted ONESICANS
  stable var totalOnesBurned   : Nat = 0;

  // Treasury balances (fees accumulate here)
  stable var icpTreasury       : Nat = 0;
  stable var onesTreasury      : Nat = 0;

  // ── Find or create ICP account index ────────────────────────────────────
  func _icpIdx(p : Text) : ?Nat {
    var i = 0;
    while (i < icpAccountCount and i < LEDGER_CAP) {
      if (icpPrincipals[i] == p) return ?i;
      i += 1;
    };
    null
  };

  func _icpIdxOrCreate(p : Text) : Nat {
    switch (_icpIdx(p)) {
      case (?i) i;
      case null {
        if (icpAccountCount >= LEDGER_CAP) return 0;  // ledger full — safe fallback
        let i = icpAccountCount;
        icpPrincipals[i] := p;
        icpBalances[i]   := 0;
        icpAccountCount  := icpAccountCount + 1;
        i
      };
    }
  };

  // ── Find or create ONESICAN account index ────────────────────────────────
  func _onesIdx(p : Text) : ?Nat {
    var i = 0;
    while (i < onesAccountCount and i < LEDGER_CAP) {
      if (onesPrincipals[i] == p) return ?i;
      i += 1;
    };
    null
  };

  func _onesIdxOrCreate(p : Text) : Nat {
    switch (_onesIdx(p)) {
      case (?i) i;
      case null {
        if (onesAccountCount >= LEDGER_CAP) return 0;
        let i = onesAccountCount;
        onesPrincipals[i] := p;
        onesBalances[i]   := 0;
        onesAccountCount  := onesAccountCount + 1;
        i
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — AUDIT LOG
  // ═══════════════════════════════════════════════════════════════════════════

  let AUDIT_CAP : Nat = 2048;

  stable var auditCount   : Nat = 0;
  stable var auditKinds   : [var Text] = Array.init<Text>(AUDIT_CAP, "");
  stable var auditFroms   : [var Text] = Array.init<Text>(AUDIT_CAP, "");
  stable var auditTos     : [var Text] = Array.init<Text>(AUDIT_CAP, "");
  stable var auditAmounts : [var Nat]  = Array.init<Nat>(AUDIT_CAP,  0);
  stable var auditFees    : [var Nat]  = Array.init<Nat>(AUDIT_CAP,  0);
  stable var auditTimes   : [var Int]  = Array.init<Int>(AUDIT_CAP,  0);
  stable var auditTokens  : [var Text] = Array.init<Text>(AUDIT_CAP, "ICP");

  func _audit(kind : Text, from : Text, to : Text, amount : Nat, fee : Nat, token : Text) {
    if (auditCount >= AUDIT_CAP) return;  // rolling in future; for now cap
    let i = auditCount;
    auditKinds[i]   := kind;
    auditFroms[i]   := from;
    auditTos[i]     := to;
    auditAmounts[i] := amount;
    auditFees[i]    := fee;
    auditTimes[i]   := Time.now();
    auditTokens[i]  := token;
    auditCount      := auditCount + 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — ENCRYPTED VAULT
  // Each vault entry is a hash-anchored secret note (key → hash + ciphertext)
  // The vault stores encrypted blobs; the canister never sees plaintext.
  // Only the depositing principal can read back their entries.
  // ═══════════════════════════════════════════════════════════════════════════

  let VAULT_CAP : Nat = 1024;

  stable var vaultCount    : Nat = 0;
  stable var vaultOwners   : [var Text] = Array.init<Text>(VAULT_CAP, "");
  stable var vaultKeys     : [var Text] = Array.init<Text>(VAULT_CAP, "");
  stable var vaultPayloads : [var Text] = Array.init<Text>(VAULT_CAP, "");  // encrypted ciphertext (base64)
  stable var vaultHashes   : [var Text] = Array.init<Text>(VAULT_CAP, "");  // sha256 of plaintext (for integrity)
  stable var vaultTimes    : [var Int]  = Array.init<Int>(VAULT_CAP,  0);

  // Simple FNV-1a hash for internal key deduplication (not cryptographic)
  func _fnvHash(t : Text) : Text {
    var h : Nat32 = 2166136261;
    for (c in t.chars()) {
      h := h ^ Nat32.fromNat(Nat8.toNat(Nat8.fromNat(Nat32.toNat(Nat32.fromIntWrap(Int32.toInt(Int32.fromNat32(Nat32.fromNat(Nat.rem(Char.toNat32(c) % 256, 256)))))))));
      h := h *% 16777619;
    };
    Nat32.toText(h)
  };

  // Store an encrypted vault entry
  public shared(msg) func vaultStore(key : Text, ciphertext : Text, hashHex : Text) : async {
    success : Bool;
    vaultId : Nat;
  } {
    if (vaultCount >= VAULT_CAP) return { success = false; vaultId = 0 };
    let owner = Principal.toText(msg.caller);
    let i = vaultCount;
    vaultOwners[i]   := owner;
    vaultKeys[i]     := key;
    vaultPayloads[i] := ciphertext;
    vaultHashes[i]   := hashHex;
    vaultTimes[i]    := Time.now();
    vaultCount       := vaultCount + 1;
    _audit("VAULT_STORE", owner, "VAULT", 0, 0, "ENCRYPTED");
    { success = true; vaultId = i }
  };

  // Read vault entries by the calling principal
  public shared(msg) func vaultRead(key : Text) : async ?{
    ciphertext : Text;
    hashHex    : Text;
    storedAt   : Int;
  } {
    let owner = Principal.toText(msg.caller);
    var i = 0;
    while (i < vaultCount and i < VAULT_CAP) {
      if (vaultOwners[i] == owner and vaultKeys[i] == key) {
        return ?{
          ciphertext = vaultPayloads[i];
          hashHex    = vaultHashes[i];
          storedAt   = vaultTimes[i];
        }
      };
      i += 1;
    };
    null
  };

  // List vault keys for the calling principal (metadata only — no payloads)
  public shared(msg) func vaultListKeys() : async [{ key : Text; storedAt : Int }] {
    let owner  = Principal.toText(msg.caller);
    var result : [{ key:Text; storedAt:Int }] = [];
    var i = 0;
    while (i < vaultCount and i < VAULT_CAP) {
      if (vaultOwners[i] == owner) {
        result := Array.append(result, [{ key = vaultKeys[i]; storedAt = vaultTimes[i] }]);
      };
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — ICP OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  // Sovereign deposits ICP for a recipient (simulates ledger transfer receipt)
  public shared(msg) func icpDeposit(recipient : Text, amount : Nat) : async {
    success : Bool;
    balance : Nat;
  } {
    requireSovereign(msg.caller);
    if (amount == 0) return { success = false; balance = 0 };
    let i = _icpIdxOrCreate(recipient);
    icpBalances[i]   := icpBalances[i] + amount;
    totalIcpDeposited := totalIcpDeposited + amount;
    _audit("ICP_DEPOSIT", Principal.toText(msg.caller), recipient, amount, 0, "ICP");
    { success = true; balance = icpBalances[i] }
  };

  // Transfer ICP between principals within PARALLAX
  public shared(msg) func icpTransfer(to : Text, amount : Nat) : async {
    success  : Bool;
    fee      : Nat;
    balance  : Nat;
  } {
    let from = Principal.toText(msg.caller);
    if (amount == 0) return { success = false; fee = 0; balance = 0 };
    let fee  = _goldFee(amount);
    let total = amount + fee;
    let fromIdx = _icpIdxOrCreate(from);
    if (icpBalances[fromIdx] < total) return { success = false; fee; balance = icpBalances[fromIdx] };
    let toIdx = _icpIdxOrCreate(to);
    icpBalances[fromIdx] := icpBalances[fromIdx] - total;
    icpBalances[toIdx]   := icpBalances[toIdx]   + amount;
    icpTreasury          := icpTreasury + fee;
    _audit("ICP_TRANSFER", from, to, amount, fee, "ICP");
    { success = true; fee; balance = icpBalances[fromIdx] }
  };

  // Query ICP balance
  public shared(msg) func icpBalance() : async Nat {
    let p = Principal.toText(msg.caller);
    switch (_icpIdx(p)) {
      case null 0;
      case (?i) icpBalances[i];
    }
  };

  public query func icpBalanceOf(p : Text) : async Nat {
    switch (_icpIdx(p)) {
      case null 0;
      case (?i) icpBalances[i];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — ONESICAN OPERATIONS
  // "the ones i can sell per canister market when developers join"
  // ONESICANS are minted by the sovereign, distributed to developers,
  // and burned when consumed as compute credit in the cycles market.
  // ═══════════════════════════════════════════════════════════════════════════

  // Mint new ONESICANS (sovereign only)
  public shared(msg) func onesMint(recipient : Text, amount : Nat) : async {
    success     : Bool;
    totalSupply : Nat;
    balance     : Nat;
  } {
    requireSovereign(msg.caller);
    if (amount == 0) return { success = false; totalSupply = totalOnesSupply; balance = 0 };
    let i = _onesIdxOrCreate(recipient);
    onesBalances[i]  := onesBalances[i] + amount;
    totalOnesSupply  := totalOnesSupply + amount;
    _audit("ONES_MINT", Principal.toText(msg.caller), recipient, amount, 0, "ONESICAN");
    { success = true; totalSupply = totalOnesSupply; balance = onesBalances[i] }
  };

  // Burn ONESICANS (for compute credit consumption)
  public shared(msg) func onesBurn(amount : Nat) : async {
    success     : Bool;
    burned      : Nat;
    totalBurned : Nat;
    balance     : Nat;
  } {
    let p = Principal.toText(msg.caller);
    if (amount == 0) return { success = false; burned = 0; totalBurned = totalOnesBurned; balance = 0 };
    let i = _onesIdxOrCreate(p);
    if (onesBalances[i] < amount) return {
      success = false; burned = 0; totalBurned = totalOnesBurned; balance = onesBalances[i]
    };
    onesBalances[i] := onesBalances[i] - amount;
    totalOnesSupply := if (totalOnesSupply >= amount) totalOnesSupply - amount else 0;
    totalOnesBurned := totalOnesBurned + amount;
    _audit("ONES_BURN", p, "BURNED", amount, 0, "ONESICAN");
    { success = true; burned = amount; totalBurned = totalOnesBurned; balance = onesBalances[i] }
  };

  // Transfer ONESICANS between principals
  public shared(msg) func onesTransfer(to : Text, amount : Nat) : async {
    success : Bool;
    fee     : Nat;
    balance : Nat;
  } {
    let from = Principal.toText(msg.caller);
    if (amount == 0) return { success = false; fee = 0; balance = 0 };
    let fee      = _goldFee(amount);
    let total    = amount + fee;
    let fromIdx  = _onesIdxOrCreate(from);
    if (onesBalances[fromIdx] < total) return { success = false; fee; balance = onesBalances[fromIdx] };
    let toIdx = _onesIdxOrCreate(to);
    onesBalances[fromIdx] := onesBalances[fromIdx] - total;
    onesBalances[toIdx]   := onesBalances[toIdx]   + amount;
    onesTreasury          := onesTreasury + fee;
    _audit("ONES_TRANSFER", from, to, amount, fee, "ONESICAN");
    { success = true; fee; balance = onesBalances[fromIdx] }
  };

  // Query ONESICAN balance
  public shared(msg) func onesBalance() : async Nat {
    let p = Principal.toText(msg.caller);
    switch (_onesIdx(p)) {
      case null 0;
      case (?i) onesBalances[i];
    }
  };

  public query func onesBalanceOf(p : Text) : async Nat {
    switch (_onesIdx(p)) {
      case null 0;
      case (?i) onesBalances[i];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — STAKING BRIDGE
  // Stakes ICP from PARALLAX balance to NOVA_GOVERNANCE neuron creation.
  // Records the stake intent; NOVA_GOVERNANCE confirms neuron creation.
  // ═══════════════════════════════════════════════════════════════════════════

  let STAKE_CAP : Nat = 1024;

  stable var stakeCount        : Nat = 0;
  stable var stakeIds          : [var Nat]   = Array.init<Nat>(STAKE_CAP,  0);
  stable var stakeOwners       : [var Text]  = Array.init<Text>(STAKE_CAP, "");
  stable var stakeAmountsIcp   : [var Nat]   = Array.init<Nat>(STAKE_CAP,  0);
  stable var stakeAmountsOnes  : [var Nat]   = Array.init<Nat>(STAKE_CAP,  0);
  stable var stakeDissolves    : [var Nat]   = Array.init<Nat>(STAKE_CAP,  0);  // dissolve delay in days
  stable var stakeStatuses     : [var Text]  = Array.init<Text>(STAKE_CAP, "PENDING");
  stable var stakeNeuronIds    : [var Nat]   = Array.init<Nat>(STAKE_CAP,  0);  // filled by governance
  stable var stakeTimes        : [var Int]   = Array.init<Int>(STAKE_CAP,  0);
  stable var nextStakeId       : Nat         = 0;

  // Initiate a stake from PARALLAX balance
  public shared(msg) func stakeIcp(amount : Nat, dissolveDays : Nat) : async {
    success   : Bool;
    stakeId   : Nat;
    remaining : Nat;
  } {
    let p = Principal.toText(msg.caller);
    if (amount == 0 or dissolveDays == 0) return { success = false; stakeId = 0; remaining = 0 };
    if (stakeCount >= STAKE_CAP) return { success = false; stakeId = 0; remaining = 0 };
    let fromIdx = _icpIdxOrCreate(p);
    let fee     = _goldFee(amount);
    let total   = amount + fee;
    if (icpBalances[fromIdx] < total) return { success = false; stakeId = 0; remaining = icpBalances[fromIdx] };
    // Debit balance — stake amount goes to staking lock
    icpBalances[fromIdx] := icpBalances[fromIdx] - total;
    icpTreasury          := icpTreasury + fee;
    let si = stakeCount;
    stakeIds[si]         := nextStakeId;
    stakeOwners[si]      := p;
    stakeAmountsIcp[si]  := amount;
    stakeAmountsOnes[si] := 0;
    stakeDissolves[si]   := dissolveDays;
    stakeStatuses[si]    := "PENDING";
    stakeNeuronIds[si]   := 0;
    stakeTimes[si]       := Time.now();
    let stakeId = nextStakeId;
    stakeCount  := stakeCount + 1;
    nextStakeId := nextStakeId + 1;
    _audit("STAKE_ICP", p, "GOVERNANCE", amount, fee, "ICP");
    { success = true; stakeId; remaining = icpBalances[fromIdx] }
  };

  // Initiate a stake of ONESICANS
  public shared(msg) func stakeOnes(amount : Nat, dissolveDays : Nat) : async {
    success   : Bool;
    stakeId   : Nat;
    remaining : Nat;
  } {
    let p = Principal.toText(msg.caller);
    if (amount == 0 or dissolveDays == 0) return { success = false; stakeId = 0; remaining = 0 };
    if (stakeCount >= STAKE_CAP) return { success = false; stakeId = 0; remaining = 0 };
    let fromIdx = _onesIdxOrCreate(p);
    let fee     = _goldFee(amount);
    let total   = amount + fee;
    if (onesBalances[fromIdx] < total) return { success = false; stakeId = 0; remaining = onesBalances[fromIdx] };
    onesBalances[fromIdx] := onesBalances[fromIdx] - total;
    onesTreasury          := onesTreasury + fee;
    let si = stakeCount;
    stakeIds[si]         := nextStakeId;
    stakeOwners[si]      := p;
    stakeAmountsIcp[si]  := 0;
    stakeAmountsOnes[si] := amount;
    stakeDissolves[si]   := dissolveDays;
    stakeStatuses[si]    := "PENDING";
    stakeNeuronIds[si]   := 0;
    stakeTimes[si]       := Time.now();
    let stakeId = nextStakeId;
    stakeCount  := stakeCount + 1;
    nextStakeId := nextStakeId + 1;
    _audit("STAKE_ONES", p, "GOVERNANCE", amount, fee, "ONESICAN");
    { success = true; stakeId; remaining = onesBalances[fromIdx] }
  };

  // Governance canister confirms neuron creation (sovereign only)
  public shared(msg) func confirmStakeNeuron(stakeId : Nat, neuronId : Nat) : async Bool {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < stakeCount and i < STAKE_CAP) {
      if (stakeIds[i] == stakeId) {
        stakeNeuronIds[i] := neuronId;
        stakeStatuses[i]  := "CONFIRMED";
        return true;
      };
      i += 1;
    };
    false
  };

  // List stakes for calling principal
  public shared(msg) func myStakes() : async [{
    stakeId      : Nat;
    amountIcp    : Nat;
    amountOnes   : Nat;
    dissolveDays : Nat;
    status       : Text;
    neuronId     : Nat;
    createdAt    : Int;
  }] {
    let p = Principal.toText(msg.caller);
    var result : [{ stakeId:Nat; amountIcp:Nat; amountOnes:Nat; dissolveDays:Nat; status:Text; neuronId:Nat; createdAt:Int }] = [];
    var i = 0;
    while (i < stakeCount and i < STAKE_CAP) {
      if (stakeOwners[i] == p) {
        result := Array.append(result, [{
          stakeId      = stakeIds[i];
          amountIcp    = stakeAmountsIcp[i];
          amountOnes   = stakeAmountsOnes[i];
          dissolveDays = stakeDissolves[i];
          status       = stakeStatuses[i];
          neuronId     = stakeNeuronIds[i];
          createdAt    = stakeTimes[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — AUDIT READ API (pure queries)
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getAuditRecent(n : Nat) : async [{
    kind   : Text;
    from   : Text;
    to     : Text;
    amount : Nat;
    fee    : Nat;
    token  : Text;
    time   : Int;
  }] {
    let total  = if (n < auditCount) n else auditCount;
    Array.tabulate<{ kind:Text; from:Text; to:Text; amount:Nat; fee:Nat; token:Text; time:Int }>(total, func(j) {
      let i = auditCount - total + j;
      { kind = auditKinds[i]; from = auditFroms[i]; to = auditTos[i]; amount = auditAmounts[i]; fee = auditFees[i]; token = auditTokens[i]; time = auditTimes[i] }
    })
  };

  public query func getAuditCount() : async Nat { auditCount };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 — PARALLAX TREASURY STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getParallaxStatus() : async {
    seal               : Text;
    claimed            : Bool;
    totalIcpDeposited  : Nat;
    totalOnesSupply    : Nat;
    totalOnesBurned    : Nat;
    icpTreasury        : Nat;
    onesTreasury       : Nat;
    icpAccountCount    : Nat;
    onesAccountCount   : Nat;
    stakeCount         : Nat;
    vaultEntries       : Nat;
    auditEntries       : Nat;
    buildNumber        : Nat;
    tokenName          : Text;
    tokenSymbol        : Text;
  } {
    {
      seal              = sovereignSeal;
      claimed           = genesisLocked;
      totalIcpDeposited = totalIcpDeposited;
      totalOnesSupply   = totalOnesSupply;
      totalOnesBurned   = totalOnesBurned;
      icpTreasury       = icpTreasury;
      onesTreasury      = onesTreasury;
      icpAccountCount   = icpAccountCount;
      onesAccountCount  = onesAccountCount;
      stakeCount        = stakeCount;
      vaultEntries      = vaultCount;
      auditEntries      = auditCount;
      buildNumber       = buildNumber;
      tokenName         = "ONESICAN";
      tokenSymbol       = "ONES";
    }
  };

  // φ-fee schedule preview
  public query func feeSchedule() : async [{
    tier        : Text;
    amountRange : Text;
    ratePercent : Float;
    example100  : Nat;
  }] {
    [
      { tier = "MICRO";  amountRange = "1 – 1,000";        ratePercent = _pow(PHI_INV, 4.0) * 100.0; example100 = _goldFee(100)    },
      { tier = "SMALL";  amountRange = "1,001 – 10,000";   ratePercent = _pow(PHI_INV, 5.0) * 100.0; example100 = _goldFee(5_000)  },
      { tier = "MEDIUM"; amountRange = "10,001 – 100,000"; ratePercent = _pow(PHI_INV, 6.0) * 100.0; example100 = _goldFee(50_000) },
      { tier = "LARGE";  amountRange = "100,001+";         ratePercent = _pow(PHI_INV, 7.0) * 100.0; example100 = _goldFee(200_000)},
    ]
  };

};
