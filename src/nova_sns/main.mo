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
// NOVA SNS — Service Nervous System (Per-Canister Governance)
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// NOVA SNS IS THE CIVILIZATION'S NERVOUS SYSTEM ACROSS SERVICES.
// Modeled on ICP's Service Nervous System (SNS), NOVA SNS extends governance
// down to individual canisters and services. Each registered service has:
//   • Its own service token (drawn from ONESICAN ecosystem or minted fresh)
//   • Developer staking: devs stake ONESICANS to participate in service governance
//   • Per-service proposals: upgrade paths, parameter changes, fee adjustments
//   • Revenue sharing: service revenue distributed to stakers by φ-weight
//   • Token flow: ONESICANS flow in (staking) and out (rewards, revenue share)
//
// SNS Token Economics:
//   • Each service reserves N ONESICANS as its service token pool
//   • Developers join by staking ONESICANS against the service
//   • Staking weight = stake × φ^(stake_duration_years)
//   • Revenue from the service is distributed to stakers proportionally
//   • NOVA GOVERNANCE has oversight via delegation: SNS proposals can escalate

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor NovaSns {

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
    if (genesisLocked) return "NOVA_SNS_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-SNS-BUILD30-" # Principal.toText(msg.caller);
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

  // Staking weight: stake × φ^(years), capped dissolve at 4yr for SNS
  func _stakingWeight(stake : Nat, dissolveDays : Nat) : Float {
    let dYears = _clamp(Float.fromInt(dissolveDays) / 365.0, 0.0, 4.0);
    Float.fromInt(stake) * _pow(PHI, dYears)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — SERVICE REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════

  let SERVICE_CAP : Nat = 512;

  stable var serviceCount       : Nat = 0;
  stable var serviceIds         : [var Nat]   = Array.init<Nat>(SERVICE_CAP,   0);
  stable var serviceOwners      : [var Text]  = Array.init<Text>(SERVICE_CAP,  "");
  stable var serviceNames       : [var Text]  = Array.init<Text>(SERVICE_CAP,  "");
  stable var serviceDescriptions: [var Text]  = Array.init<Text>(SERVICE_CAP,  "");
  stable var serviceTokenPools  : [var Nat]   = Array.init<Nat>(SERVICE_CAP,   0);   // ONESICANS reserved
  stable var serviceStakeTotals : [var Nat]   = Array.init<Nat>(SERVICE_CAP,   0);   // total staked
  stable var serviceRevenues    : [var Nat]   = Array.init<Nat>(SERVICE_CAP,   0);   // accumulated revenue (ONES)
  stable var serviceStatuses    : [var Text]  = Array.init<Text>(SERVICE_CAP,  "ACTIVE");
  stable var serviceCreatedAt   : [var Int]   = Array.init<Int>(SERVICE_CAP,   0);
  stable var nextServiceId      : Nat         = 1;

  func _findService(id : Nat) : ?Nat {
    var i = 0;
    while (i < serviceCount and i < SERVICE_CAP) {
      if (serviceIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // ── Register a service ────────────────────────────────────────────────────
  public shared(msg) func registerService(
    name        : Text,
    description : Text,
    tokenPool   : Nat   // ONESICANS to reserve for this service's governance
  ) : async {
    success   : Bool;
    serviceId : Nat;
  } {
    if (serviceCount >= SERVICE_CAP) return { success = false; serviceId = 0 };
    let si = serviceCount;
    let id = nextServiceId;
    serviceIds[si]          := id;
    serviceOwners[si]       := Principal.toText(msg.caller);
    serviceNames[si]        := name;
    serviceDescriptions[si] := description;
    serviceTokenPools[si]   := tokenPool;
    serviceStakeTotals[si]  := 0;
    serviceRevenues[si]     := 0;
    serviceStatuses[si]     := "ACTIVE";
    serviceCreatedAt[si]    := Time.now();
    serviceCount            := serviceCount + 1;
    nextServiceId           := nextServiceId + 1;
    { success = true; serviceId = id }
  };

  // ── Get service details ───────────────────────────────────────────────────
  public query func getService(id : Nat) : async ?{
    serviceId   : Nat;
    owner       : Text;
    name        : Text;
    description : Text;
    tokenPool   : Nat;
    stakeTotals : Nat;
    revenue     : Nat;
    status      : Text;
    createdAt   : Int;
  } {
    switch (_findService(id)) {
      case null null;
      case (?si) {
        ?{
          serviceId   = serviceIds[si];
          owner       = serviceOwners[si];
          name        = serviceNames[si];
          description = serviceDescriptions[si];
          tokenPool   = serviceTokenPools[si];
          stakeTotals = serviceStakeTotals[si];
          revenue     = serviceRevenues[si];
          status      = serviceStatuses[si];
          createdAt   = serviceCreatedAt[si];
        }
      };
    }
  };

  public query func listServices() : async [{
    serviceId : Nat; name : Text; owner : Text; stakeTotals : Nat; status : Text;
  }] {
    Array.tabulate<{ serviceId:Nat; name:Text; owner:Text; stakeTotals:Nat; status:Text }>(serviceCount, func(i) {
      { serviceId = serviceIds[i]; name = serviceNames[i]; owner = serviceOwners[i]; stakeTotals = serviceStakeTotals[i]; status = serviceStatuses[i] }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — DEVELOPER STAKING (per service)
  // ═══════════════════════════════════════════════════════════════════════════

  let STAKE_CAP : Nat = 4096;

  stable var devStakeCount      : Nat = 0;
  stable var devStakeIds        : [var Nat]   = Array.init<Nat>(STAKE_CAP,   0);
  stable var devStakeDevs       : [var Text]  = Array.init<Text>(STAKE_CAP,  "");
  stable var devStakeServiceIds : [var Nat]   = Array.init<Nat>(STAKE_CAP,   0);
  stable var devStakeAmounts    : [var Nat]   = Array.init<Nat>(STAKE_CAP,   0);
  stable var devStakeDissolves  : [var Nat]   = Array.init<Nat>(STAKE_CAP,   0);  // dissolve days
  stable var devStakeCreatedAt  : [var Int]   = Array.init<Int>(STAKE_CAP,   0);
  stable var devStakeStatuses   : [var Text]  = Array.init<Text>(STAKE_CAP,  "ACTIVE");
  stable var devStakeRewardClaimed : [var Nat] = Array.init<Nat>(STAKE_CAP,  0);
  stable var nextDevStakeId     : Nat         = 1;

  // ── Stake ONESICANS against a service ────────────────────────────────────
  public shared(msg) func developerStake(
    serviceId    : Nat,
    amount       : Nat,
    dissolveDays : Nat
  ) : async {
    success       : Bool;
    devStakeId    : Nat;
    stakingWeight : Float;
  } {
    if (amount == 0 or dissolveDays == 0) return { success = false; devStakeId = 0; stakingWeight = 0.0 };
    if (devStakeCount >= STAKE_CAP) return { success = false; devStakeId = 0; stakingWeight = 0.0 };
    switch (_findService(serviceId)) {
      case null { { success = false; devStakeId = 0; stakingWeight = 0.0 } };
      case (?si) {
        let di = devStakeCount;
        let id = nextDevStakeId;
        devStakeIds[di]           := id;
        devStakeDevs[di]          := Principal.toText(msg.caller);
        devStakeServiceIds[di]    := serviceId;
        devStakeAmounts[di]       := amount;
        devStakeDissolves[di]     := dissolveDays;
        devStakeCreatedAt[di]     := Time.now();
        devStakeStatuses[di]      := "ACTIVE";
        devStakeRewardClaimed[di] := 0;
        devStakeCount             := devStakeCount + 1;
        nextDevStakeId            := nextDevStakeId + 1;
        serviceStakeTotals[si]    := serviceStakeTotals[si] + amount;
        let w = _stakingWeight(amount, dissolveDays);
        { success = true; devStakeId = id; stakingWeight = w }
      };
    }
  };

  // ── Total staking weight for a service ───────────────────────────────────
  func _totalWeightForService(serviceId : Nat) : Float {
    var total : Float = 0.0;
    var i = 0;
    while (i < devStakeCount and i < STAKE_CAP) {
      if (devStakeServiceIds[i] == serviceId and devStakeStatuses[i] == "ACTIVE") {
        total += _stakingWeight(devStakeAmounts[i], devStakeDissolves[i]);
      };
      i += 1;
    };
    total
  };

  // ── Record revenue for a service (sovereign or service owner) ─────────────
  public shared(msg) func recordRevenue(serviceId : Nat, amount : Nat) : async Bool {
    switch (_findService(serviceId)) {
      case null false;
      case (?si) {
        if (serviceOwners[si] != Principal.toText(msg.caller) and not isSovereign(msg.caller)) return false;
        serviceRevenues[si] := serviceRevenues[si] + amount;
        true
      };
    }
  };

  // ── Claim revenue share for a dev stake ──────────────────────────────────
  public shared(msg) func claimRevenueShare(devStakeId : Nat) : async {
    success  : Bool;
    rewarded : Nat;
    share    : Float;
  } {
    let p = Principal.toText(msg.caller);
    var i = 0;
    while (i < devStakeCount and i < STAKE_CAP) {
      if (devStakeIds[i] == devStakeId and devStakeDevs[i] == p) {
        let sid = devStakeServiceIds[i];
        switch (_findService(sid)) {
          case null { return { success = false; rewarded = 0; share = 0.0 } };
          case (?si) {
            let totalRevenue = serviceRevenues[si];
            let totalWeight  = _totalWeightForService(sid);
            if (totalWeight < EPSILON or totalRevenue == 0) return { success = false; rewarded = 0; share = 0.0 };
            let myWeight   = _stakingWeight(devStakeAmounts[i], devStakeDissolves[i]);
            let myShare    = myWeight / totalWeight;
            let myReward   = _floatToNat(Float.fromInt(totalRevenue) * myShare);
            let unclaimed  = if (myReward > devStakeRewardClaimed[i]) myReward - devStakeRewardClaimed[i] else 0;
            if (unclaimed == 0) return { success = false; rewarded = 0; share = myShare };
            devStakeRewardClaimed[i] := devStakeRewardClaimed[i] + unclaimed;
            return { success = true; rewarded = unclaimed; share = myShare }
          };
        };
      };
      i += 1;
    };
    { success = false; rewarded = 0; share = 0.0 }
  };

  // ── Get my dev stakes ─────────────────────────────────────────────────────
  public shared(msg) func myDevStakes() : async [{
    devStakeId   : Nat;
    serviceId    : Nat;
    amount       : Nat;
    dissolveDays : Nat;
    stakingWeight: Float;
    status       : Text;
    createdAt    : Int;
  }] {
    let p = Principal.toText(msg.caller);
    var result : [{ devStakeId:Nat; serviceId:Nat; amount:Nat; dissolveDays:Nat; stakingWeight:Float; status:Text; createdAt:Int }] = [];
    var i = 0;
    while (i < devStakeCount and i < STAKE_CAP) {
      if (devStakeDevs[i] == p) {
        let w = _stakingWeight(devStakeAmounts[i], devStakeDissolves[i]);
        result := Array.append(result, [{
          devStakeId   = devStakeIds[i];
          serviceId    = devStakeServiceIds[i];
          amount       = devStakeAmounts[i];
          dissolveDays = devStakeDissolves[i];
          stakingWeight = w;
          status       = devStakeStatuses[i];
          createdAt    = devStakeCreatedAt[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — PER-SERVICE PROPOSALS
  // ═══════════════════════════════════════════════════════════════════════════

  let SNS_PROPOSAL_CAP : Nat = 1024;

  stable var snsPropCount     : Nat = 0;
  stable var snsPropIds       : [var Nat]   = Array.init<Nat>(SNS_PROPOSAL_CAP,   0);
  stable var snsPropServiceIds: [var Nat]   = Array.init<Nat>(SNS_PROPOSAL_CAP,   0);
  stable var snsPropTitles    : [var Text]  = Array.init<Text>(SNS_PROPOSAL_CAP,  "");
  stable var snsPropSummaries : [var Text]  = Array.init<Text>(SNS_PROPOSAL_CAP,  "");
  stable var snsPropKinds     : [var Text]  = Array.init<Text>(SNS_PROPOSAL_CAP,  "UPGRADE");
  // Kinds: UPGRADE | PARAMETER | FEE_CHANGE | DISSOLVE | DELEGATE_NNS
  stable var snsPropVotesYes  : [var Float] = Array.init<Float>(SNS_PROPOSAL_CAP, 0.0);
  stable var snsPropVotesNo   : [var Float] = Array.init<Float>(SNS_PROPOSAL_CAP, 0.0);
  stable var snsPropStatuses  : [var Text]  = Array.init<Text>(SNS_PROPOSAL_CAP,  "OPEN");
  stable var snsPropCreatedAt : [var Int]   = Array.init<Int>(SNS_PROPOSAL_CAP,   0);
  stable var nextSnsPropId    : Nat         = 1;

  // Vote receipts: "devStakeId:proposalId"
  let SNS_RECEIPT_CAP : Nat = 32768;
  stable var snsReceiptCount  : Nat = 0;
  stable var snsReceipts      : [var Text] = Array.init<Text>(SNS_RECEIPT_CAP, "");

  func _snsVoted(stakeId : Nat, propId : Nat) : Bool {
    let key = Nat.toText(stakeId) # ":" # Nat.toText(propId);
    var i = 0;
    while (i < snsReceiptCount and i < SNS_RECEIPT_CAP) {
      if (snsReceipts[i] == key) return true;
      i += 1;
    };
    false
  };

  func _recordSnsVote(stakeId : Nat, propId : Nat) {
    if (snsReceiptCount >= SNS_RECEIPT_CAP) return;
    snsReceipts[snsReceiptCount] := Nat.toText(stakeId) # ":" # Nat.toText(propId);
    snsReceiptCount := snsReceiptCount + 1;
  };

  // Submit a service proposal (caller must have active dev stake)
  public shared(msg) func submitServiceProposal(
    serviceId : Nat,
    title     : Text,
    summary   : Text,
    kind      : Text
  ) : async { success : Bool; proposalId : Nat } {
    // Caller must have an active stake in this service
    let p = Principal.toText(msg.caller);
    var hasStake = false;
    var i = 0;
    while (i < devStakeCount and i < STAKE_CAP) {
      if (devStakeDevs[i] == p and devStakeServiceIds[i] == serviceId and devStakeStatuses[i] == "ACTIVE") {
        hasStake := true;
      };
      i += 1;
    };
    if (not hasStake and not isSovereign(msg.caller)) return { success = false; proposalId = 0 };
    if (snsPropCount >= SNS_PROPOSAL_CAP) return { success = false; proposalId = 0 };
    let pi = snsPropCount;
    let id = nextSnsPropId;
    snsPropIds[pi]        := id;
    snsPropServiceIds[pi] := serviceId;
    snsPropTitles[pi]     := title;
    snsPropSummaries[pi]  := summary;
    snsPropKinds[pi]      := kind;
    snsPropVotesYes[pi]   := 0.0;
    snsPropVotesNo[pi]    := 0.0;
    snsPropStatuses[pi]   := "OPEN";
    snsPropCreatedAt[pi]  := Time.now();
    snsPropCount          := snsPropCount + 1;
    nextSnsPropId         := nextSnsPropId + 1;
    { success = true; proposalId = id }
  };

  // Vote on a service proposal using a dev stake
  public shared(msg) func voteSnsProposal(
    devStakeId : Nat,
    proposalId : Nat,
    ballot     : Text  // "YES" | "NO"
  ) : async { success : Bool; weight : Float; newYes : Float; newNo : Float } {
    let p = Principal.toText(msg.caller);
    // Find dev stake
    var stakeIdx : ?Nat = null;
    var i = 0;
    while (i < devStakeCount and i < STAKE_CAP) {
      if (devStakeIds[i] == devStakeId and devStakeDevs[i] == p) { stakeIdx := ?i };
      i += 1;
    };
    switch stakeIdx {
      case null { { success = false; weight = 0.0; newYes = 0.0; newNo = 0.0 } };
      case (?si) {
        // Find proposal
        var propIdx : ?Nat = null;
        var j = 0;
        while (j < snsPropCount and j < SNS_PROPOSAL_CAP) {
          if (snsPropIds[j] == proposalId) { propIdx := ?j };
          j += 1;
        };
        switch propIdx {
          case null { { success = false; weight = 0.0; newYes = 0.0; newNo = 0.0 } };
          case (?pi) {
            if (snsPropStatuses[pi] != "OPEN") return { success = false; weight = 0.0; newYes = snsPropVotesYes[pi]; newNo = snsPropVotesNo[pi] };
            if (devStakeServiceIds[si] != snsPropServiceIds[pi]) return { success = false; weight = 0.0; newYes = snsPropVotesYes[pi]; newNo = snsPropVotesNo[pi] };
            if (_snsVoted(devStakeId, proposalId)) return { success = false; weight = 0.0; newYes = snsPropVotesYes[pi]; newNo = snsPropVotesNo[pi] };
            let w = _stakingWeight(devStakeAmounts[si], devStakeDissolves[si]);
            if (ballot == "YES") { snsPropVotesYes[pi] := snsPropVotesYes[pi] + w }
            else                 { snsPropVotesNo[pi]  := snsPropVotesNo[pi]  + w };
            _recordSnsVote(devStakeId, proposalId);
            { success = true; weight = w; newYes = snsPropVotesYes[pi]; newNo = snsPropVotesNo[pi] }
          };
        }
      };
    }
  };

  public query func listServiceProposals(serviceId : Nat) : async [{
    proposalId : Nat; title : Text; kind : Text; yes : Float; no : Float; status : Text;
  }] {
    var result : [{ proposalId:Nat; title:Text; kind:Text; yes:Float; no:Float; status:Text }] = [];
    var i = 0;
    while (i < snsPropCount and i < SNS_PROPOSAL_CAP) {
      if (snsPropServiceIds[i] == serviceId) {
        result := Array.append(result, [{
          proposalId = snsPropIds[i]; title = snsPropTitles[i]; kind = snsPropKinds[i];
          yes = snsPropVotesYes[i]; no = snsPropVotesNo[i]; status = snsPropStatuses[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — SNS STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getSnsStatus() : async {
    seal          : Text;
    claimed       : Bool;
    serviceCount  : Nat;
    devStakeCount : Nat;
    proposalCount : Nat;
    phi           : Float;
    stakingFormula: Text;
  } {
    {
      seal          = sovereignSeal;
      claimed       = genesisLocked;
      serviceCount  = serviceCount;
      devStakeCount = devStakeCount;
      proposalCount = snsPropCount;
      phi           = PHI;
      stakingFormula = "weight = stake × φ^(dissolve_years), max 4yr";
    }
  };

};
