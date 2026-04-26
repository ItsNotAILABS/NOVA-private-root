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
// AIRDROP ENGINE — Sovereign Deep Airdrop System
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// THE AIRDROP ENGINE IS THE CIVILIZATION'S GROWTH MECHANISM.
// It doesn't just send tokens to wallets. It qualifies recipients,
// scores their participation, runs multi-wave campaigns with behavioral
// triggers, enforces anti-sybil rules, and generates immutable proof
// records for every claim.
//
// ── ARCHITECTURE ────────────────────────────────────────────────────────────
// 5 qualification dimensions (scored 0.0-1.0 each):
//   STAKING_DEPTH    — has staked ICP or ONESICANS in governance
//   DEV_ACTIVITY     — has listed or purchased in cycles market
//   GOVERNANCE_VOTES — has voted on proposals
//   COMMUNITY_PROOF  — has a developer seat in cycles market
//   TIME_ON_CHAIN    — wallet age since genesis
//
// Final score = φ⁻¹×STAKING + φ⁻²×DEV + φ⁻³×GOV + φ⁻⁴×COMMUNITY + φ⁻⁵×TIME
// Score ≥ TIER_THRESHOLD → eligible for that tier
//
// ── WAVE SYSTEM ─────────────────────────────────────────────────────────────
// Each campaign has up to 13 waves (Fibonacci: 1,1,2,3,5,8,13,21,34,55,89,144,233 days between waves)
// Wave bonuses: wave N → bonus = F(N) × BASE_BONUS (Fibonacci multiplier)
//   Wave 1:  1× base     (early adopters get base)
//   Wave 2:  1× base     (parity)
//   Wave 3:  2× base     (compound growth begins)
//   Wave 5:  5× base     (significant bonus)
//   Wave 8:  21× base    (major early mover advantage)
//   Wave 13: 233× base   (legendary wave)
//
// ── ANTI-SYBIL ───────────────────────────────────────────────────────────────
// Duplicate detection:
//   1. Principal uniqueness (one claim per principal per campaign)
//   2. Proof-of-stake: must have staked ≥ MINIMUM_STAKE before registration
//   3. Cooldown: ≥ 24h between registration and claim
//   4. Voucher: sovereign can issue vouchers that skip stake requirement
//      (for verified community members, hackathon winners, etc.)
//
// ── PROOF SYSTEM ─────────────────────────────────────────────────────────────
// Every successful claim generates a CLAIM_PROOF:
//   proof_id | principal | campaign | wave | amount | score | timestamp
// Proofs are immutable, queryable, and serve as on-chain credential.
// Future: Merkle tree root can be computed from proofs for ZK verification.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor AirdropEngine {

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
    if (genesisLocked) return "AIRDROP_ENGINE_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-AIRDROP-ENGINE-BUILD30-" # Principal.toText(msg.caller);
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

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  // Fibonacci
  func _fib(n : Nat) : Nat {
    if (n == 0) return 0; if (n == 1) return 1;
    var a : Nat = 0; var b : Nat = 1; var i : Nat = 2;
    while (i <= n) { let c = a + b; a := b; b := c; i += 1 };
    b
  };

  // Qualification score formula (φ-weighted 5 dimensions)
  func _qualScore(staking : Float, dev : Float, gov : Float, community : Float, time_ : Float) : Float {
    _pow(PHI_INV, 1.0) * staking +
    _pow(PHI_INV, 2.0) * dev +
    _pow(PHI_INV, 3.0) * gov +
    _pow(PHI_INV, 4.0) * community +
    _pow(PHI_INV, 5.0) * time_
  };

  // Nanoseconds per day
  let NS_PER_DAY : Int = 86_400_000_000_000;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — CAMPAIGN STATE
  // ═══════════════════════════════════════════════════════════════════════════

  let CAMPAIGN_CAP : Nat = 64;

  stable var campaignCount        : Nat = 0;
  stable var campaignIds          : [var Nat]   = Array.init<Nat>(CAMPAIGN_CAP,   0);
  stable var campaignNames        : [var Text]  = Array.init<Text>(CAMPAIGN_CAP,  "");
  stable var campaignDescriptions : [var Text]  = Array.init<Text>(CAMPAIGN_CAP,  "");
  stable var campaignTotalBudgets : [var Nat]   = Array.init<Nat>(CAMPAIGN_CAP,   0);  // ONESICANS
  stable var campaignSpent        : [var Nat]   = Array.init<Nat>(CAMPAIGN_CAP,   0);
  stable var campaignCurrentWaves : [var Nat]   = Array.init<Nat>(CAMPAIGN_CAP,   1);  // starts at wave 1
  stable var campaignMaxWaves     : [var Nat]   = Array.init<Nat>(CAMPAIGN_CAP,   8);
  stable var campaignBaseAmounts  : [var Nat]   = Array.init<Nat>(CAMPAIGN_CAP,   100); // base ONES per claim
  stable var campaignMinScores    : [var Float] = Array.init<Float>(CAMPAIGN_CAP, 0.0); // min qual score
  stable var campaignMinStakes    : [var Nat]   = Array.init<Nat>(CAMPAIGN_CAP,   0);  // min staked ONES
  stable var campaignStatuses     : [var Text]  = Array.init<Text>(CAMPAIGN_CAP,  "PENDING");
  // Statuses: PENDING | ACTIVE | WAVE_PAUSED | COMPLETED | CANCELLED
  stable var campaignCreatedAt    : [var Int]   = Array.init<Int>(CAMPAIGN_CAP,   0);
  stable var campaignLastWaveAt   : [var Int]   = Array.init<Int>(CAMPAIGN_CAP,   0);
  stable var campaignWaveDayGaps  : [var Nat]   = Array.init<Nat>(CAMPAIGN_CAP,   1);  // Fibonacci-gated wave gaps
  stable var nextCampaignId       : Nat         = 1;

  func _findCampaign(id : Nat) : ?Nat {
    var i = 0;
    while (i < campaignCount and i < CAMPAIGN_CAP) {
      if (campaignIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // Create a campaign
  public shared(msg) func createCampaign(
    name        : Text,
    description : Text,
    budget      : Nat,
    maxWaves    : Nat,
    baseAmount  : Nat,
    minScore    : Float,
    minStake    : Nat
  ) : async { success : Bool; campaignId : Nat } {
    requireSovereign(msg.caller);
    if (campaignCount >= CAMPAIGN_CAP) return { success = false; campaignId = 0 };
    if (budget == 0 or baseAmount == 0) return { success = false; campaignId = 0 };
    let ci = campaignCount;
    let id = nextCampaignId;
    campaignIds[ci]          := id;
    campaignNames[ci]        := name;
    campaignDescriptions[ci] := description;
    campaignTotalBudgets[ci] := budget;
    campaignSpent[ci]        := 0;
    campaignCurrentWaves[ci] := 1;
    campaignMaxWaves[ci]     := if (maxWaves > 13) 13 else maxWaves;  // cap at 13 waves
    campaignBaseAmounts[ci]  := baseAmount;
    campaignMinScores[ci]    := _clamp(minScore, 0.0, 1.0);
    campaignMinStakes[ci]    := minStake;
    campaignStatuses[ci]     := "PENDING";
    campaignCreatedAt[ci]    := Time.now();
    campaignLastWaveAt[ci]   := 0;
    campaignWaveDayGaps[ci]  := 1;  // first wave gap = 1 day (Fibonacci)
    campaignCount            := campaignCount + 1;
    nextCampaignId           := nextCampaignId + 1;
    { success = true; campaignId = id }
  };

  // Open a campaign (start wave 1)
  public shared(msg) func openCampaign(campaignId : Nat) : async { success : Bool; wave : Nat } {
    requireSovereign(msg.caller);
    switch (_findCampaign(campaignId)) {
      case null { { success = false; wave = 0 } };
      case (?ci) {
        if (campaignStatuses[ci] != "PENDING") return { success = false; wave = campaignCurrentWaves[ci] };
        campaignStatuses[ci]   := "ACTIVE";
        campaignLastWaveAt[ci] := Time.now();
        { success = true; wave = campaignCurrentWaves[ci] }
      };
    }
  };

  // Advance to next wave (sovereign or TOKEN_INTELLIGENCE trigger)
  public shared(msg) func advanceWave(campaignId : Nat) : async {
    success   : Bool;
    newWave   : Nat;
    waveBonus : Nat;
    nextGapDays : Nat;
  } {
    if (not isSovereign(msg.caller)) return { success = false; newWave = 0; waveBonus = 0; nextGapDays = 0 };
    switch (_findCampaign(campaignId)) {
      case null { { success = false; newWave = 0; waveBonus = 0; nextGapDays = 0 } };
      case (?ci) {
        if (campaignStatuses[ci] != "ACTIVE" and campaignStatuses[ci] != "WAVE_PAUSED") {
          return { success = false; newWave = campaignCurrentWaves[ci]; waveBonus = 0; nextGapDays = 0 }
        };
        // Check Fibonacci gate: enough time since last wave?
        let requiredNs = campaignWaveDayGaps[ci] * Int.abs(NS_PER_DAY);
        let elapsed    = Time.now() - campaignLastWaveAt[ci];
        if (elapsed < requiredNs and campaignLastWaveAt[ci] > 0) {
          return { success = false; newWave = campaignCurrentWaves[ci]; waveBonus = 0; nextGapDays = campaignWaveDayGaps[ci] }
        };
        let newWave = campaignCurrentWaves[ci] + 1;
        if (newWave > campaignMaxWaves[ci]) {
          campaignStatuses[ci] := "COMPLETED";
          return { success = false; newWave = campaignCurrentWaves[ci]; waveBonus = 0; nextGapDays = 0 }
        };
        campaignCurrentWaves[ci] := newWave;
        campaignLastWaveAt[ci]   := Time.now();
        // Next gap = Fibonacci(wave) days
        campaignWaveDayGaps[ci]  := _fib(newWave);
        let bonus = _fib(newWave) * campaignBaseAmounts[ci];
        { success = true; newWave; waveBonus = bonus; nextGapDays = campaignWaveDayGaps[ci] }
      };
    }
  };

  // Pause/resume wave
  public shared(msg) func pauseWave(campaignId : Nat) : async Bool {
    requireSovereign(msg.caller);
    switch (_findCampaign(campaignId)) {
      case null false;
      case (?ci) {
        if (campaignStatuses[ci] == "ACTIVE") { campaignStatuses[ci] := "WAVE_PAUSED"; true }
        else if (campaignStatuses[ci] == "WAVE_PAUSED") { campaignStatuses[ci] := "ACTIVE"; true }
        else false
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — RECIPIENT REGISTRATION + QUALIFICATION SCORING
  // ═══════════════════════════════════════════════════════════════════════════

  let RECIP_CAP : Nat = 32768;

  stable var recipCount        : Nat = 0;
  stable var recipIds          : [var Nat]   = Array.init<Nat>(RECIP_CAP,   0);
  stable var recipPrincipals   : [var Text]  = Array.init<Text>(RECIP_CAP,  "");
  stable var recipCampaignIds  : [var Nat]   = Array.init<Nat>(RECIP_CAP,   0);
  stable var recipQualScores   : [var Float] = Array.init<Float>(RECIP_CAP, 0.0);
  stable var recipStakingScores: [var Float] = Array.init<Float>(RECIP_CAP, 0.0);
  stable var recipDevScores    : [var Float] = Array.init<Float>(RECIP_CAP, 0.0);
  stable var recipGovScores    : [var Float] = Array.init<Float>(RECIP_CAP, 0.0);
  stable var recipCommunityScores: [var Float] = Array.init<Float>(RECIP_CAP, 0.0);
  stable var recipTimeScores   : [var Float] = Array.init<Float>(RECIP_CAP, 0.0);
  stable var recipStaked       : [var Nat]   = Array.init<Nat>(RECIP_CAP,   0);  // ONESICANS staked
  stable var recipTiers        : [var Nat]   = Array.init<Nat>(RECIP_CAP,   0);  // 0=unqualified, 1-5
  stable var recipClaimed      : [var Bool]  = Array.init<Bool>(RECIP_CAP,  false);
  stable var recipClaimedWave  : [var Nat]   = Array.init<Nat>(RECIP_CAP,   0);
  stable var recipClaimedAmount: [var Nat]   = Array.init<Nat>(RECIP_CAP,   0);
  stable var recipRegisteredAt : [var Int]   = Array.init<Int>(RECIP_CAP,   0);
  stable var recipHasVoucher   : [var Bool]  = Array.init<Bool>(RECIP_CAP,  false);
  stable var nextRecipId       : Nat         = 1;

  // Check if principal already registered for campaign
  func _findRecip(p : Text, campaignId : Nat) : ?Nat {
    var i = 0;
    while (i < recipCount and i < RECIP_CAP) {
      if (recipPrincipals[i] == p and recipCampaignIds[i] == campaignId) return ?i;
      i += 1;
    };
    null
  };

  // Compute tier from score
  func _scoreTier(score : Float) : Nat {
    if      (score >= _pow(PHI_INV, 1.0)) 5  // ≥ 0.618
    else if (score >= _pow(PHI_INV, 2.0)) 4  // ≥ 0.382
    else if (score >= _pow(PHI_INV, 3.0)) 3  // ≥ 0.236
    else if (score >= _pow(PHI_INV, 4.0)) 2  // ≥ 0.146
    else if (score >= _pow(PHI_INV, 5.0)) 1  // ≥ 0.090
    else 0
  };

  // Register for airdrop with qualification scores
  public shared(msg) func registerForAirdrop(
    campaignId    : Nat,
    stakingScore  : Float,  // 0.0-1.0: fraction of stake depth
    devScore      : Float,  // 0.0-1.0: developer activity level
    govScore      : Float,  // 0.0-1.0: governance participation
    communityScore: Float,  // 0.0-1.0: community presence
    timeScore     : Float,  // 0.0-1.0: wallet age normalized
    stakedAmount  : Nat     // actual ONES staked (for anti-sybil)
  ) : async {
    success    : Bool;
    recipId    : Nat;
    qualScore  : Float;
    tier       : Nat;
    eligible   : Bool;
    reason     : Text;
  } {
    let p = Principal.toText(msg.caller);
    switch (_findCampaign(campaignId)) {
      case null { return { success = false; recipId = 0; qualScore = 0.0; tier = 0; eligible = false; reason = "CAMPAIGN_NOT_FOUND" } };
      case (?ci) {
        if (campaignStatuses[ci] != "ACTIVE") return { success = false; recipId = 0; qualScore = 0.0; tier = 0; eligible = false; reason = "CAMPAIGN_NOT_ACTIVE" };
        // Anti-sybil: stake requirement
        if (stakedAmount < campaignMinStakes[ci]) {
          return { success = false; recipId = 0; qualScore = 0.0; tier = 0; eligible = false;
            reason = "INSUFFICIENT_STAKE: need " # Nat.toText(campaignMinStakes[ci]) # " ONES" }
        };
        // Duplicate check
        if (_findRecip(p, campaignId) != null) {
          return { success = false; recipId = 0; qualScore = 0.0; tier = 0; eligible = false; reason = "ALREADY_REGISTERED" }
        };
        if (recipCount >= RECIP_CAP) return { success = false; recipId = 0; qualScore = 0.0; tier = 0; eligible = false; reason = "CAPACITY_FULL" };
        let ss = _clamp(stakingScore,   0.0, 1.0);
        let ds = _clamp(devScore,       0.0, 1.0);
        let gs = _clamp(govScore,       0.0, 1.0);
        let cs = _clamp(communityScore, 0.0, 1.0);
        let ts = _clamp(timeScore,      0.0, 1.0);
        let score = _qualScore(ss, ds, gs, cs, ts);
        let tier  = _scoreTier(score);
        let eligible = score >= campaignMinScores[ci] and tier >= 1;
        let ri = recipCount;
        let id = nextRecipId;
        recipIds[ri]             := id;
        recipPrincipals[ri]      := p;
        recipCampaignIds[ri]     := campaignId;
        recipQualScores[ri]      := score;
        recipStakingScores[ri]   := ss;
        recipDevScores[ri]       := ds;
        recipGovScores[ri]       := gs;
        recipCommunityScores[ri] := cs;
        recipTimeScores[ri]      := ts;
        recipStaked[ri]          := stakedAmount;
        recipTiers[ri]           := tier;
        recipClaimed[ri]         := false;
        recipClaimedWave[ri]     := 0;
        recipClaimedAmount[ri]   := 0;
        recipRegisteredAt[ri]    := Time.now();
        recipHasVoucher[ri]      := false;
        recipCount               := recipCount + 1;
        nextRecipId              := nextRecipId + 1;
        {
          success = true; recipId = id; qualScore = score; tier; eligible;
          reason = if eligible "QUALIFIED" else "SCORE_BELOW_MINIMUM"
        }
      };
    }
  };

  // Issue voucher to a recipient (bypasses stake check on next claim)
  public shared(msg) func issueVoucher(campaignId : Nat, recipient : Text) : async Bool {
    requireSovereign(msg.caller);
    switch (_findRecip(recipient, campaignId)) {
      case null false;
      case (?ri) { recipHasVoucher[ri] := true; true };
    }
  };

  // Update qualification scores (sovereign can re-score after on-chain verification)
  public shared(msg) func updateQualScores(
    campaignId    : Nat,
    recipient     : Text,
    stakingScore  : Float,
    devScore      : Float,
    govScore      : Float,
    communityScore: Float,
    timeScore     : Float
  ) : async { success : Bool; newScore : Float; newTier : Nat } {
    requireSovereign(msg.caller);
    switch (_findRecip(recipient, campaignId)) {
      case null { { success = false; newScore = 0.0; newTier = 0 } };
      case (?ri) {
        let ss = _clamp(stakingScore, 0.0, 1.0); let ds = _clamp(devScore, 0.0, 1.0);
        let gs = _clamp(govScore, 0.0, 1.0); let cs = _clamp(communityScore, 0.0, 1.0);
        let ts = _clamp(timeScore, 0.0, 1.0);
        let score = _qualScore(ss, ds, gs, cs, ts);
        recipQualScores[ri]      := score;
        recipStakingScores[ri]   := ss;
        recipDevScores[ri]       := ds;
        recipGovScores[ri]       := gs;
        recipCommunityScores[ri] := cs;
        recipTimeScores[ri]      := ts;
        recipTiers[ri]           := _scoreTier(score);
        { success = true; newScore = score; newTier = recipTiers[ri] }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — CLAIM ENGINE + PROOF SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════

  let PROOF_CAP : Nat = 32768;

  stable var proofCount      : Nat = 0;
  stable var proofIds        : [var Nat]   = Array.init<Nat>(PROOF_CAP,   0);
  stable var proofRecipients : [var Text]  = Array.init<Text>(PROOF_CAP,  "");
  stable var proofCampaigns  : [var Nat]   = Array.init<Nat>(PROOF_CAP,   0);
  stable var proofWaves      : [var Nat]   = Array.init<Nat>(PROOF_CAP,   0);
  stable var proofAmounts    : [var Nat]   = Array.init<Nat>(PROOF_CAP,   0);
  stable var proofScores     : [var Float] = Array.init<Float>(PROOF_CAP, 0.0);
  stable var proofTiers      : [var Nat]   = Array.init<Nat>(PROOF_CAP,   0);
  stable var proofTimes      : [var Int]   = Array.init<Int>(PROOF_CAP,   0);
  stable var proofHashes     : [var Text]  = Array.init<Text>(PROOF_CAP,  ""); // deterministic proof hash
  stable var nextProofId     : Nat         = 1;

  // Generate deterministic proof hash (lightweight — not cryptographic)
  func _proofHash(principal : Text, campaignId : Nat, wave : Nat, amount : Nat, ts : Int) : Text {
    // Concatenate fields into a unique proof string
    "PROOF-" # principal # "-C" # Nat.toText(campaignId) # "-W" # Nat.toText(wave) # "-A" # Nat.toText(amount) # "-T" # Int.toText(ts)
  };

  // Compute wave claim amount: base × F(wave) × tier_multiplier
  func _claimAmount(campaignIdx : Nat, wave : Nat, tier : Nat) : Nat {
    let base      = campaignBaseAmounts[campaignIdx];
    let waveMult  = _fib(if (wave == 0) 1 else wave);
    let tierBonus = _floatToNat(_pow(PHI, Float.fromInt(tier) * 0.5));  // tier N → φ^(0.5N)
    base * waveMult * tierBonus
  };

  // Claim airdrop tokens
  public shared(msg) func claimAirdrop(campaignId : Nat) : async {
    success     : Bool;
    proofId     : Nat;
    proofHash   : Text;
    amount      : Nat;
    wave        : Nat;
    tier        : Nat;
    qualScore   : Float;
    reason      : Text;
  } {
    let p = Principal.toText(msg.caller);
    switch (_findCampaign(campaignId), _findRecip(p, campaignId)) {
      case (null, _)    { { success = false; proofId = 0; proofHash = ""; amount = 0; wave = 0; tier = 0; qualScore = 0.0; reason = "CAMPAIGN_NOT_FOUND" } };
      case (_, null)    { { success = false; proofId = 0; proofHash = ""; amount = 0; wave = 0; tier = 0; qualScore = 0.0; reason = "NOT_REGISTERED" } };
      case (?ci, ?ri)   {
        if (campaignStatuses[ci] != "ACTIVE") return { success = false; proofId = 0; proofHash = ""; amount = 0; wave = 0; tier = 0; qualScore = 0.0; reason = "CAMPAIGN_NOT_ACTIVE" };
        if (recipClaimed[ri]) return { success = false; proofId = 0; proofHash = ""; amount = 0; wave = recipClaimedWave[ri]; tier = recipTiers[ri]; qualScore = recipQualScores[ri]; reason = "ALREADY_CLAIMED" };
        let score = recipQualScores[ri];
        if (score < campaignMinScores[ci] and not recipHasVoucher[ri]) {
          return { success = false; proofId = 0; proofHash = ""; amount = 0; wave = 0; tier = 0; qualScore = score; reason = "SCORE_TOO_LOW" }
        };
        if (recipTiers[ri] == 0 and not recipHasVoucher[ri]) {
          return { success = false; proofId = 0; proofHash = ""; amount = 0; wave = 0; tier = 0; qualScore = score; reason = "UNQUALIFIED_TIER" }
        };
        // Anti-sybil cooldown: ≥24h between registration and claim (unless voucher)
        let elapsed = Time.now() - recipRegisteredAt[ri];
        if (elapsed < Int.abs(NS_PER_DAY) and not recipHasVoucher[ri]) {
          return { success = false; proofId = 0; proofHash = ""; amount = 0; wave = 0; tier = 0; qualScore = score; reason = "COOLDOWN: wait 24h after registration" }
        };
        let wave   = campaignCurrentWaves[ci];
        let tier   = recipTiers[ri];
        let amount = _claimAmount(ci, wave, tier);
        // Check budget
        if (campaignSpent[ci] + amount > campaignTotalBudgets[ci]) {
          return { success = false; proofId = 0; proofHash = ""; amount = 0; wave; tier; qualScore = score; reason = "BUDGET_EXHAUSTED" }
        };
        if (proofCount >= PROOF_CAP) return { success = false; proofId = 0; proofHash = ""; amount = 0; wave; tier; qualScore = score; reason = "PROOF_CAPACITY_FULL" };
        // Record claim
        let now = Time.now();
        let hash = _proofHash(p, campaignId, wave, amount, now);
        let pi = proofCount;
        proofIds[pi]        := nextProofId;
        proofRecipients[pi] := p;
        proofCampaigns[pi]  := campaignId;
        proofWaves[pi]      := wave;
        proofAmounts[pi]    := amount;
        proofScores[pi]     := score;
        proofTiers[pi]      := tier;
        proofTimes[pi]      := now;
        proofHashes[pi]     := hash;
        proofCount          := proofCount + 1;
        let pid = nextProofId;
        nextProofId         := nextProofId + 1;
        // Update recipient
        recipClaimed[ri]       := true;
        recipClaimedWave[ri]   := wave;
        recipClaimedAmount[ri] := amount;
        // Update campaign spend
        campaignSpent[ci] := campaignSpent[ci] + amount;
        if (campaignSpent[ci] >= campaignTotalBudgets[ci]) { campaignStatuses[ci] := "COMPLETED" };
        { success = true; proofId = pid; proofHash = hash; amount; wave; tier; qualScore = score; reason = "CLAIMED" }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — PROOF VERIFICATION + QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  public query func verifyProof(proofHash : Text) : async ?{
    proofId    : Nat;
    recipient  : Text;
    campaignId : Nat;
    wave       : Nat;
    amount     : Nat;
    score      : Float;
    tier       : Nat;
    claimedAt  : Int;
  } {
    var i = 0;
    while (i < proofCount and i < PROOF_CAP) {
      if (proofHashes[i] == proofHash) {
        return ?{
          proofId    = proofIds[i];
          recipient  = proofRecipients[i];
          campaignId = proofCampaigns[i];
          wave       = proofWaves[i];
          amount     = proofAmounts[i];
          score      = proofScores[i];
          tier       = proofTiers[i];
          claimedAt  = proofTimes[i];
        }
      };
      i += 1;
    };
    null
  };

  public shared(msg) func myProofs() : async [{
    proofId    : Nat;
    proofHash  : Text;
    campaignId : Nat;
    wave       : Nat;
    amount     : Nat;
    tier       : Nat;
    claimedAt  : Int;
  }] {
    let p = Principal.toText(msg.caller);
    var result : [{ proofId:Nat; proofHash:Text; campaignId:Nat; wave:Nat; amount:Nat; tier:Nat; claimedAt:Int }] = [];
    var i = 0;
    while (i < proofCount and i < PROOF_CAP) {
      if (proofRecipients[i] == p) {
        result := Array.append(result, [{
          proofId = proofIds[i]; proofHash = proofHashes[i]; campaignId = proofCampaigns[i];
          wave = proofWaves[i]; amount = proofAmounts[i]; tier = proofTiers[i]; claimedAt = proofTimes[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // Check my registration status
  public shared(msg) func myStatus(campaignId : Nat) : async {
    registered   : Bool;
    claimed      : Bool;
    qualScore    : Float;
    tier         : Nat;
    tierLabel    : Text;
    claimedWave  : Nat;
    claimedAmount: Nat;
    hasVoucher   : Bool;
    nextWaveBonus: Nat;
    cooldownDone : Bool;
  } {
    let p = Principal.toText(msg.caller);
    switch (_findRecip(p, campaignId), _findCampaign(campaignId)) {
      case (null, _) { { registered = false; claimed = false; qualScore = 0.0; tier = 0; tierLabel = "UNREGISTERED"; claimedWave = 0; claimedAmount = 0; hasVoucher = false; nextWaveBonus = 0; cooldownDone = false } };
      case (_, null) { { registered = false; claimed = false; qualScore = 0.0; tier = 0; tierLabel = "CAMPAIGN_NOT_FOUND"; claimedWave = 0; claimedAmount = 0; hasVoucher = false; nextWaveBonus = 0; cooldownDone = false } };
      case (?ri, ?ci) {
        let labels : [Text] = ["UNQUALIFIED","BRONZE","SILVER","GOLD","PLATINUM","DIAMOND"];
        let wave   = campaignCurrentWaves[ci];
        let bonus  = _claimAmount(ci, wave, recipTiers[ri]);
        let cooldownDone = (Time.now() - recipRegisteredAt[ri]) >= Int.abs(NS_PER_DAY) or recipHasVoucher[ri];
        {
          registered    = true;
          claimed       = recipClaimed[ri];
          qualScore     = recipQualScores[ri];
          tier          = recipTiers[ri];
          tierLabel     = labels[recipTiers[ri]];
          claimedWave   = recipClaimedWave[ri];
          claimedAmount = recipClaimedAmount[ri];
          hasVoucher    = recipHasVoucher[ri];
          nextWaveBonus = bonus;
          cooldownDone;
        }
      };
    }
  };

  // Campaign analytics
  public query func getCampaignAnalytics(campaignId : Nat) : async ?{
    name          : Text;
    status        : Text;
    budget        : Nat;
    spent         : Nat;
    remaining     : Nat;
    pctSpent      : Float;
    wave          : Nat;
    maxWaves      : Nat;
    nextGapDays   : Nat;
    totalRegistered : Nat;
    totalClaimed    : Nat;
    waveAmounts     : [{ wave:Nat; amount:Nat; fibMult:Nat }];
  } {
    switch (_findCampaign(campaignId)) {
      case null null;
      case (?ci) {
        var registered : Nat = 0;
        var claimed    : Nat = 0;
        var i = 0;
        while (i < recipCount and i < RECIP_CAP) {
          if (recipCampaignIds[i] == campaignId) {
            registered += 1;
            if (recipClaimed[i]) { claimed += 1 };
          };
          i += 1;
        };
        let budget  = campaignTotalBudgets[ci];
        let spent   = campaignSpent[ci];
        let pct     = if (budget == 0) 0.0 else Float.fromInt(spent) / Float.fromInt(budget) * 100.0;
        let maxW    = campaignMaxWaves[ci];
        let waves   = Array.tabulate<{ wave:Nat; amount:Nat; fibMult:Nat }>(maxW, func(j) {
          let w = j + 1;
          { wave = w; amount = _claimAmount(ci, w, 3); fibMult = _fib(w) }  // tier-3 (GOLD) preview
        });
        ?{
          name     = campaignNames[ci];
          status   = campaignStatuses[ci];
          budget; spent; remaining = if (budget > spent) budget - spent else 0; pctSpent = pct;
          wave     = campaignCurrentWaves[ci];
          maxWaves = maxW;
          nextGapDays = campaignWaveDayGaps[ci];
          totalRegistered = registered;
          totalClaimed    = claimed;
          waveAmounts     = waves;
        }
      };
    }
  };

  public query func listCampaigns() : async [{
    campaignId : Nat; name : Text; status : Text; wave : Nat; spent : Nat; budget : Nat;
  }] {
    Array.tabulate<{ campaignId:Nat; name:Text; status:Text; wave:Nat; spent:Nat; budget:Nat }>(campaignCount, func(i) {
      { campaignId = campaignIds[i]; name = campaignNames[i]; status = campaignStatuses[i]; wave = campaignCurrentWaves[i]; spent = campaignSpent[i]; budget = campaignTotalBudgets[i] }
    })
  };

  // Full tier breakdown: what each score threshold gets in each wave
  public query func tierBreakdown(baseAmount : Nat) : async [{
    tier     : Nat;
    lbl    : Text;
    minScore : Float;
    wave1    : Nat;
    wave2    : Nat;
    wave3    : Nat;
    wave5    : Nat;
    wave8    : Nat;
    wave13   : Nat;
  }] {
    let labels : [Text] = ["UNQUALIFIED","BRONZE","SILVER","GOLD","PLATINUM","DIAMOND"];
    let minScores : [Float] = [0.0, _pow(PHI_INV,5.0), _pow(PHI_INV,4.0), _pow(PHI_INV,3.0), _pow(PHI_INV,2.0), _pow(PHI_INV,1.0)];
    let wavePicks : [Nat] = [1, 2, 3, 5, 8, 13];
    Array.tabulate<{ tier:Nat; lbl:Text; minScore:Float; wave1:Nat; wave2:Nat; wave3:Nat; wave5:Nat; wave8:Nat; wave13:Nat }>(6, func(t) {
      let tierBonus = _floatToNat(_pow(PHI, Float.fromInt(t) * 0.5));
      let amt : (Nat) -> Nat = func(w) { baseAmount * _fib(if(w==0) 1 else w) * tierBonus };
      { tier = t; lbl = labels[t]; minScore = minScores[t];
        wave1 = amt(1); wave2 = amt(2); wave3 = amt(3);
        wave5 = amt(5); wave8 = amt(8); wave13 = amt(13) }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — ENGINE STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getEngineStatus() : async {
    seal             : Text;
    claimed          : Bool;
    campaignCount    : Nat;
    recipientCount   : Nat;
    proofCount       : Nat;
    totalClaimed     : Nat;
    phi              : Float;
    qualFormula      : Text;
    waveFormula      : Text;
    antiSybilRules   : Text;
  } {
    var totalClaimed : Nat = 0;
    var i = 0;
    while (i < proofCount and i < PROOF_CAP) { totalClaimed += proofAmounts[i]; i += 1 };
    {
      seal           = sovereignSeal;
      claimed        = genesisLocked;
      campaignCount  = campaignCount;
      recipientCount = recipCount;
      proofCount     = proofCount;
      totalClaimed;
      phi            = PHI;
      qualFormula    = "score = φ⁻¹×STAKING + φ⁻²×DEV + φ⁻³×GOV + φ⁻⁴×COMMUNITY + φ⁻⁵×TIME";
      waveFormula    = "amount = BASE × F(wave) × φ^(0.5×tier) | waves: Fibonacci day gaps";
      antiSybilRules = "1.principal-unique 2.min-stake 3.24h-cooldown 4.sovereign-voucher-override";
    }
  };

};
