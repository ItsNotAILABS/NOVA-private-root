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
// ORGANISM TOKEN — Sub-Token Economy for Organisms and AI Entities
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// THE ORGANISM TOKEN IS THE INTERNAL ECONOMY OF THE LIVING CIVILIZATION.
//
// ONESICANS are the civilization's reserve currency (like ICP cycles but sovereign).
// ORGANISM TOKENS are denomination-specific sub-tokens for each organism and AI.
// Think of them as the internal metabolic currency of each organism — specialized,
// contextual, and tied to each organism's computational domain.
//
// ── TOKEN TYPES ──────────────────────────────────────────────────────────────
// Each organism has its own native sub-token:
//
//   CHRYSALIS_TOKEN  (CHR) — Math compute token. Used to purchase golden math ops.
//   SCRIBE_TOKEN     (SCB) — Knowledge token. Used to purchase data synthesis.
//   ARCHITECT_TOKEN  (ARC) — Build token. Used to purchase construction capacity.
//   NEXUS_TOKEN      (NXS) — Routing token. Used to purchase substrate routing.
//   SWARM_TOKEN      (SWM) — Coordination token. Meta-token for fleet ops.
//   PHANTOM_TOKEN    (PHT) — Phantom substrate token. Premium compute credit.
//   ORGANISM_RESERVE (ORS) — Internal reserve token for cross-organism payments.
//
// ── RELATIONSHIP TO ONESICANS ────────────────────────────────────────────────
// 1 ONESICAN = φ CHR = φ² SCB = φ³ ARC = φ⁴ NXS = φ⁵ SWM
// The deeper into specialization, the more sub-tokens you need per ONESICAN.
// This creates a natural scarcity gradient — PHT tokens are rarest.
//
// ONESICAN → sub-token conversion:
//   CHR  = 1 ONESICAN × φ¹  = 1.618 CHR  (math is fundamental)
//   SCB  = 1 ONESICAN × φ²  = 2.618 SCB  (knowledge is compound)
//   ARC  = 1 ONESICAN × φ³  = 4.236 ARC  (build is specialist)
//   NXS  = 1 ONESICAN × φ⁴  = 6.854 NXS  (routing is deep)
//   SWM  = 1 ONESICAN × φ⁵  = 11.09 SWM  (coordination is meta)
//   PHT  = 1 ONESICAN × φ³  = 4.236 PHT  (phantom = special, same as φ³)
//   ORS  = 1 ONESICAN × 1   = 1.0   ORS  (reserve parity)
//
// ── AI ENTITY ACCOUNTS ───────────────────────────────────────────────────────
// Every Latin AGI server (GOL-*) has an account in the organism token ledger.
// Servers earn sub-tokens by completing work. They stake sub-tokens for governance.
// This creates a full AI economy:
//   Server completes task → earns CHR tokens → stakes CHR for governance weight
//   → votes on CHRYSALIS upgrade proposals → receives maturity → more tokens
//
// ── STAKING-TO-GOVERNANCE BRIDGE ─────────────────────────────────────────────
// Sub-token holders can stake to the NOVA_GOVERNANCE canister:
//   Stake CHR → earns CHRYSALIS governance VP
//   Stake SCB → earns SCRIBE governance VP
//   Stake SWM → earns SWARM_BRAIN governance VP
// VP = staked_amount × φ^(stake_tier) where stake_tier = 1..5 (Fibonacci ladder)
//
// ── CIRCULATION ───────────────────────────────────────────────────────────────
// Tokens circulate within the organism economy:
//   AI entity completes work → pays in sub-tokens → organism treasury grows
//   → organism treasury stakes to NNS → earns maturity → converts to ONESICAN
//   → minted sub-tokens distributed to participants → loop continues
//
// Everything loops. Everything circulates. This is the organism economy.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor OrganismToken {

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
    if (genesisLocked) return "ORGANISM_TOKEN_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-ORGANISM-TOKEN-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH
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

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — TOKEN TYPE REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════

  // 8 sub-token types, all defined at genesis
  // Conversion rate = how many sub-tokens per 1 ONESICAN
  stable var tokenTypes : Nat = 0;

  let TT_CAP : Nat = 32;
  stable var ttSymbols       : [var Text]  = Array.init<Text>(TT_CAP,  "");
  stable var ttNames         : [var Text]  = Array.init<Text>(TT_CAP,  "");
  stable var ttOrganisms     : [var Text]  = Array.init<Text>(TT_CAP,  "");
  stable var ttConversionRate: [var Float] = Array.init<Float>(TT_CAP, 1.0); // sub-tokens per ONESICAN
  stable var ttTotalSupply   : [var Nat]   = Array.init<Nat>(TT_CAP,   0);
  stable var ttTotalStaked   : [var Nat]   = Array.init<Nat>(TT_CAP,   0);
  stable var ttTotalBurned   : [var Nat]   = Array.init<Nat>(TT_CAP,   0);
  stable var ttGovWeight     : [var Float] = Array.init<Float>(TT_CAP, 0.0); // VP per 1000 tokens staked

  func _findToken(symbol : Text) : ?Nat {
    var i = 0;
    while (i < tokenTypes and i < TT_CAP) {
      if (ttSymbols[i] == symbol) return ?i;
      i += 1;
    };
    null
  };

  // Bootstrap all organism sub-token types
  public shared(msg) func bootstrapTokenTypes() : async [{ symbol:Text; name:Text; rate:Float }] {
    requireSovereign(msg.caller);
    let types : [(Text, Text, Text, Float, Float)] = [
      // (symbol, name, organism, convRate, govWeight)
      ("CHR", "Chrysalis Token",   "CHRYSALIS",    _pow(PHI, 1.0), _pow(PHI_INV, 1.0)),
      ("SCB", "Scribe Token",      "SCRIBE",       _pow(PHI, 2.0), _pow(PHI_INV, 2.0)),
      ("ARC", "Architect Token",   "ARCHITECT",    _pow(PHI, 3.0), _pow(PHI_INV, 3.0)),
      ("NXS", "Nexus Token",       "NEXUS",        _pow(PHI, 4.0), _pow(PHI_INV, 4.0)),
      ("SWM", "Swarm Token",       "SWARM_BRAIN",  _pow(PHI, 5.0), _pow(PHI_INV, 5.0)),
      ("PHT", "Phantom Token",     "PHANTOM",      _pow(PHI, 3.0), _pow(PHI_INV, 3.0)),
      ("ORS", "Organism Reserve",  "RESERVE",      1.0,            _pow(PHI_INV, 2.0)),
      ("GOL", "Governance Latin",  "LATINI",       _pow(PHI, 2.0), _pow(PHI_INV, 2.0)),
    ];
    var result : [{ symbol:Text; name:Text; rate:Float }] = [];
    var i = 0;
    while (i < types.size() and tokenTypes < TT_CAP) {
      let (symbol, name, organism, rate, govWt) = types[i];
      let ti = tokenTypes;
      ttSymbols[ti]        := symbol;
      ttNames[ti]          := name;
      ttOrganisms[ti]      := organism;
      ttConversionRate[ti] := rate;
      ttTotalSupply[ti]    := 0;
      ttTotalStaked[ti]    := 0;
      ttTotalBurned[ti]    := 0;
      ttGovWeight[ti]      := govWt;
      tokenTypes           := tokenTypes + 1;
      result := Array.append(result, [{ symbol; name; rate }]);
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — ACCOUNT LEDGER (entities + organisms)
  // ═══════════════════════════════════════════════════════════════════════════

  let ACCOUNT_CAP : Nat = 4096;

  stable var accountCount   : Nat = 0;
  stable var acctIds        : [var Nat]   = Array.init<Nat>(ACCOUNT_CAP,   0);
  stable var acctOwners     : [var Text]  = Array.init<Text>(ACCOUNT_CAP,  "");
  // Owner: principal text OR "GOL-MEMORIA-001" (Latin server) OR "CHRYSALIS" (organism)
  stable var acctSymbols    : [var Text]  = Array.init<Text>(ACCOUNT_CAP,  "");  // which sub-token
  stable var acctBalances   : [var Nat]   = Array.init<Nat>(ACCOUNT_CAP,   0);   // token balance
  stable var acctStaked     : [var Nat]   = Array.init<Nat>(ACCOUNT_CAP,   0);   // staked for governance
  stable var acctGovVP      : [var Float] = Array.init<Float>(ACCOUNT_CAP, 0.0); // governance VP
  stable var acctEarned     : [var Nat]   = Array.init<Nat>(ACCOUNT_CAP,   0);   // lifetime earned
  stable var acctSpent      : [var Nat]   = Array.init<Nat>(ACCOUNT_CAP,   0);   // lifetime spent
  stable var acctCreatedAt  : [var Int]   = Array.init<Int>(ACCOUNT_CAP,   0);
  stable var nextAcctId     : Nat         = 1;

  func _findAccount(owner : Text, symbol : Text) : ?Nat {
    var i = 0;
    while (i < accountCount and i < ACCOUNT_CAP) {
      if (acctOwners[i] == owner and acctSymbols[i] == symbol) return ?i;
      i += 1;
    };
    null
  };

  func _getOrCreateAccount(owner : Text, symbol : Text) : Nat {
    switch (_findAccount(owner, symbol)) {
      case (?ai) ai;
      case null {
        if (accountCount >= ACCOUNT_CAP) return 0;
        let ai = accountCount;
        acctIds[ai]       := nextAcctId;
        acctOwners[ai]    := owner;
        acctSymbols[ai]   := symbol;
        acctBalances[ai]  := 0;
        acctStaked[ai]    := 0;
        acctGovVP[ai]     := 0.0;
        acctEarned[ai]    := 0;
        acctSpent[ai]     := 0;
        acctCreatedAt[ai] := Time.now();
        accountCount      := accountCount + 1;
        nextAcctId        := nextAcctId + 1;
        ai
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — MINT + TRANSFER
  // ═══════════════════════════════════════════════════════════════════════════

  // Convert ONESICANS to sub-tokens and mint to an account
  public shared(msg) func mintFromOnesicans(
    owner       : Text,
    symbol      : Text,
    onesicans   : Nat   // amount of ONESICANS to convert
  ) : async { success : Bool; minted : Nat; rate : Float } {
    requireSovereign(msg.caller);
    switch (_findToken(symbol)) {
      case null { { success = false; minted = 0; rate = 0.0 } };
      case (?ti) {
        let rate   = ttConversionRate[ti];
        let minted = _floatToNat(Float.fromInt(onesicans) * rate);
        if (minted == 0) return { success = false; minted = 0; rate };
        let ai = _getOrCreateAccount(owner, symbol);
        acctBalances[ai] := acctBalances[ai] + minted;
        acctEarned[ai]   := acctEarned[ai] + minted;
        ttTotalSupply[ti]:= ttTotalSupply[ti] + minted;
        { success = true; minted; rate }
      };
    }
  };

  // Sovereign direct mint (reward for work completion)
  public shared(msg) func mintReward(owner : Text, symbol : Text, amount : Nat, reason : Text) : async Bool {
    requireSovereign(msg.caller);
    switch (_findToken(symbol)) {
      case null false;
      case (?ti) {
        let ai = _getOrCreateAccount(owner, symbol);
        acctBalances[ai]  := acctBalances[ai] + amount;
        acctEarned[ai]    := acctEarned[ai] + amount;
        ttTotalSupply[ti] := ttTotalSupply[ti] + amount;
        true
      };
    }
  };

  // Transfer sub-tokens between accounts
  public shared(msg) func transfer(
    from   : Text,
    to     : Text,
    symbol : Text,
    amount : Nat
  ) : async { success : Bool; fromBalance : Nat; toBalance : Nat } {
    // Either sovereign or the from-account principal
    if (not isSovereign(msg.caller) and Principal.toText(msg.caller) != from) {
      return { success = false; fromBalance = 0; toBalance = 0 }
    };
    switch (_findAccount(from, symbol)) {
      case null { { success = false; fromBalance = 0; toBalance = 0 } };
      case (?fai) {
        if (acctBalances[fai] < amount) return { success = false; fromBalance = acctBalances[fai]; toBalance = 0 };
        let tai = _getOrCreateAccount(to, symbol);
        acctBalances[fai] := acctBalances[fai] - amount;
        acctSpent[fai]    := acctSpent[fai] + amount;
        acctBalances[tai] := acctBalances[tai] + amount;
        acctEarned[tai]   := acctEarned[tai] + amount;
        { success = true; fromBalance = acctBalances[fai]; toBalance = acctBalances[tai] }
      };
    }
  };

  // Burn tokens (deflationary)
  public shared(msg) func burn(owner : Text, symbol : Text, amount : Nat) : async Bool {
    requireSovereign(msg.caller);
    switch (_findAccount(owner, symbol), _findToken(symbol)) {
      case (?ai, ?ti) {
        if (acctBalances[ai] < amount) return false;
        acctBalances[ai]  := acctBalances[ai] - amount;
        acctSpent[ai]     := acctSpent[ai] + amount;
        ttTotalBurned[ti] := ttTotalBurned[ti] + amount;
        ttTotalSupply[ti] := if (ttTotalSupply[ti] >= amount) ttTotalSupply[ti] - amount else 0;
        true
      };
      case _ false;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — GOVERNANCE STAKING BRIDGE
  // ═══════════════════════════════════════════════════════════════════════════

  // Stake sub-tokens to earn governance VP
  // VP = staked × gov_weight_per_1000 × φ^(stake_tier)
  // stake_tier = 1..5 based on duration (in days): 30/90/180/365/730
  public shared(msg) func stakeForGovernance(
    symbol      : Text,
    amount      : Nat,
    durationDays: Nat   // 30 | 90 | 180 | 365 | 730
  ) : async { success : Bool; vp : Float; stakeTier : Nat } {
    let owner = Principal.toText(msg.caller);
    switch (_findAccount(owner, symbol), _findToken(symbol)) {
      case (?ai, ?ti) {
        if (acctBalances[ai] < amount) return { success = false; vp = 0.0; stakeTier = 0 };
        let tier : Nat =
          if      (durationDays >= 730) 5
          else if (durationDays >= 365) 4
          else if (durationDays >= 180) 3
          else if (durationDays >= 90)  2
          else 1;
        let vp = Float.fromInt(amount) / 1000.0 * ttGovWeight[ti] * _pow(PHI, Float.fromInt(tier));
        acctBalances[ai] := acctBalances[ai] - amount;
        acctStaked[ai]   := acctStaked[ai] + amount;
        acctGovVP[ai]    := acctGovVP[ai] + vp;
        ttTotalStaked[ti]:= ttTotalStaked[ti] + amount;
        { success = true; vp; stakeTier = tier }
      };
      case _ { { success = false; vp = 0.0; stakeTier = 0 } };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — AI ENTITY ACCOUNT BOOTSTRAPPER
  // Initializes accounts for all 19 Latin AGI servers + 4 Alpha Organisms
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func bootstrapAiEntityAccounts(mintPerEntity : Nat) : async { entities : Nat; accountsCreated : Nat } {
    requireSovereign(msg.caller);
    let entities : [Text] = [
      // 19 Latin AGI servers
      "GOL-MEMORIA-001", "GOL-COMPUTATIO-001", "GOL-CUSTODIA-001",
      "GOL-COMMERCIUM-001", "GOL-COMMUNICATIO-001", "GOL-GUBERNATIO-001",
      "GOL-EVOLUTIO-001", "GOL-ORACULUM-001",
      "GOL-TEMPUS-001", "GOL-SPATIUM-001", "GOL-IUDICIUM-001",
      "GOL-PROPHETIA-001", "GOL-LUX-001", "GOL-HARMONIA-001",
      "GOL-POTENTIA-001", "GOL-NEXUS-001",
      "GOL-QUANTUM-001", "GOL-PHANTOMA-001", "GOL-MEDINA-001",
      // 4 Alpha Organisms
      "CHRYSALIS", "SCRIBE", "ARCHITECT", "NEXUS_PROPAGATOR",
      // Swarm entities
      "SWARM_BRAIN", "SWARM_ORGANISM",
    ];
    // Each entity gets CHR + GOL tokens; organisms get their native token too
    var created : Nat = 0;
    var ei = 0;
    while (ei < entities.size()) {
      let e = entities[ei];
      // Mint CHR and GOL for all entities
      let ai1 = _getOrCreateAccount(e, "CHR");
      let ai2 = _getOrCreateAccount(e, "GOL");
      switch (_findToken("CHR"), _findToken("GOL")) {
        case (?ti1, ?ti2) {
          if (ai1 > 0 or accountCount > 0) {
            acctBalances[ai1]  := acctBalances[ai1] + mintPerEntity;
            acctEarned[ai1]    := acctEarned[ai1] + mintPerEntity;
            ttTotalSupply[ti1] := ttTotalSupply[ti1] + mintPerEntity;
            acctBalances[ai2]  := acctBalances[ai2] + mintPerEntity;
            acctEarned[ai2]    := acctEarned[ai2] + mintPerEntity;
            ttTotalSupply[ti2] := ttTotalSupply[ti2] + mintPerEntity;
            created := created + 2;
          }
        };
        case _ {};
      };
      ei += 1;
    };
    { entities = entities.size(); accountsCreated = created }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func getMyBalance(symbol : Text) : async { balance : Nat; staked : Nat; vp : Float; earned : Nat; spent : Nat } {
    let owner = Principal.toText(msg.caller);
    switch (_findAccount(owner, symbol)) {
      case null { { balance = 0; staked = 0; vp = 0.0; earned = 0; spent = 0 } };
      case (?ai) { { balance = acctBalances[ai]; staked = acctStaked[ai]; vp = acctGovVP[ai]; earned = acctEarned[ai]; spent = acctSpent[ai] } };
    }
  };

  public query func getEntityBalance(entity : Text, symbol : Text) : async { balance : Nat; staked : Nat; vp : Float } {
    switch (_findAccount(entity, symbol)) {
      case null { { balance = 0; staked = 0; vp = 0.0 } };
      case (?ai) { { balance = acctBalances[ai]; staked = acctStaked[ai]; vp = acctGovVP[ai] } };
    }
  };

  public query func getTokenStats() : async [{
    symbol : Text; name : Text; organism : Text; rate : Float;
    supply : Nat; staked : Nat; burned : Nat; govWeight : Float;
  }] {
    Array.tabulate<{ symbol:Text; name:Text; organism:Text; rate:Float; supply:Nat; staked:Nat; burned:Nat; govWeight:Float }>(tokenTypes, func(i) {
      { symbol = ttSymbols[i]; name = ttNames[i]; organism = ttOrganisms[i]; rate = ttConversionRate[i]; supply = ttTotalSupply[i]; staked = ttTotalStaked[i]; burned = ttTotalBurned[i]; govWeight = ttGovWeight[i] }
    })
  };

  public query func getEconomyStatus() : async {
    seal              : Text;
    claimed           : Bool;
    tokenTypes        : Nat;
    totalAccounts     : Nat;
    phi               : Float;
    economyFormula    : Text;
    circulationModel  : Text;
  } {
    {
      seal             = sovereignSeal;
      claimed          = genesisLocked;
      tokenTypes       = tokenTypes;
      totalAccounts    = accountCount;
      phi              = PHI;
      economyFormula   = "1 ONESICAN = φ¹ CHR = φ² SCB = φ³ ARC = φ⁴ NXS = φ⁵ SWM | VP = staked/1000 × govWeight × φ^tier";
      circulationModel = "Work→earn CHR/GOL→stake→governance VP→proposals→maturity→ICP→ONESICAN→mint sub-tokens→loop";
    }
  };

};
