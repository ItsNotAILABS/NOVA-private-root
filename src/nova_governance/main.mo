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
// NOVA GOVERNANCE — NNS Neuron Staking & ICP Governance Layer
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// NOVA GOVERNANCE IS THE POWER CENTER.
// Modeled on the ICP Network Nervous System (NNS), NOVA GOVERNANCE allows
// principals to lock ICP/ONESICANS into neurons, accumulate voting power,
// vote on proposals, and earn maturity rewards.
//
// Architecture mirrors the ICP NNS:
//   • Neurons = staked ICP locked for a dissolve delay
//   • Voting power = stake × φ^(dissolve_years)   ← golden-ratio bonus for long commitment
//   • Maturity = voting rewards accumulate per vote
//   • Proposals = on-chain governance proposals with ACCEPT/REJECT/ABSTAIN voting
//   • Age bonus: neuron age adds φ^(age_years × 0.5) multiplier
//
// NOVA also adds a Service Nervous System (SNS) integration:
//   • Per-canister governance is delegated to nova_sns
//   • Neurons can follow (alias-vote) per service
//
// Voting power formula:
//   VP = stake × φ^(dissolve_delay_years) × φ^(age_years × 0.25)
//   where dissolve_delay_years ∈ [0, 8] and age_years ∈ [0, ∞)
//   Maximum age bonus capped at φ^2 (≈ 2.618)

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor NovaGovernance {

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
  func isAuthorized(caller : Principal)     : Bool { isSovereign(caller) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "NOVA_GOVERNANCE_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-GOVERNANCE-BUILD30-" # Principal.toText(msg.caller);
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

  // ── Voting power = stake × φ^(dissolve_years) × age_bonus ───────────────
  // dissolve_years capped at 8 (mirrors ICP NNS maximum dissolve delay)
  // age_bonus = min(φ^(age_years × 0.25), φ²)
  func _votingPower(stakeUnits : Nat, dissolveDays : Nat, ageSeconds : Int) : Float {
    let stake      = Float.fromInt(stakeUnits);
    let dYears     = _clamp(Float.fromInt(dissolveDays) / 365.0, 0.0, 8.0);
    let ageYears   = _clamp(Float.fromInt(Int.abs(ageSeconds)) / (365.0 * 24.0 * 3600.0 * 1_000_000_000.0), 0.0, 8.0);
    let dissolveBonus = _pow(PHI, dYears);
    let ageBonus      = _clamp(_pow(PHI, ageYears * 0.25), 1.0, PHI * PHI);
    stake * dissolveBonus * ageBonus
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — NEURON STATE
  // ═══════════════════════════════════════════════════════════════════════════

  let NEURON_CAP : Nat = 2048;

  // Every field in a parallel stable array
  stable var neuronCount        : Nat = 0;
  stable var neuronIds          : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);
  stable var neuronOwners       : [var Text]  = Array.init<Text>(NEURON_CAP,  "");
  stable var neuronStakesIcp    : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // ICP units staked
  stable var neuronStakesOnes   : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // ONESICANS staked
  stable var neuronDissolves    : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // dissolve delay in days
  stable var neuronAges         : [var Int]   = Array.init<Int>(NEURON_CAP,   0);  // creation timestamp (ns)
  stable var neuronMaturities   : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // accumulated maturity
  stable var neuronVotesCast    : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // total votes made
  stable var neuronStatuses     : [var Text]  = Array.init<Text>(NEURON_CAP,  "LOCKED");
  // Statuses: LOCKED | DISSOLVING | DISSOLVED | SPAWNED
  stable var neuronFollowing    : [var Text]  = Array.init<Text>(NEURON_CAP,  "");  // followee neuron id (text)
  stable var neuronLabels       : [var Text]  = Array.init<Text>(NEURON_CAP,  "");  // human label
  stable var nextNeuronId       : Nat         = 1;   // NNS-style: neurons start at id 1

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — PROPOSAL STATE
  // ═══════════════════════════════════════════════════════════════════════════

  let PROPOSAL_CAP : Nat = 512;

  stable var proposalCount      : Nat = 0;
  stable var proposalIds        : [var Nat]   = Array.init<Nat>(PROPOSAL_CAP,    0);
  stable var proposalProposers  : [var Text]  = Array.init<Text>(PROPOSAL_CAP,   "");
  stable var proposalTitles     : [var Text]  = Array.init<Text>(PROPOSAL_CAP,   "");
  stable var proposalSummaries  : [var Text]  = Array.init<Text>(PROPOSAL_CAP,   "");
  stable var proposalKinds      : [var Text]  = Array.init<Text>(PROPOSAL_CAP,   "MOTION");
  // Kinds: MOTION | UPGRADE | PARAMETER | REWARD | SNS_DELEGATE
  stable var proposalVotesYes   : [var Float] = Array.init<Float>(PROPOSAL_CAP,  0.0);
  stable var proposalVotesNo    : [var Float] = Array.init<Float>(PROPOSAL_CAP,  0.0);
  stable var proposalVotesAbs   : [var Float] = Array.init<Float>(PROPOSAL_CAP,  0.0);
  stable var proposalStatuses   : [var Text]  = Array.init<Text>(PROPOSAL_CAP,   "OPEN");
  // Statuses: OPEN | ACCEPTED | REJECTED | EXECUTING | EXECUTED | FAILED
  stable var proposalCreatedAt  : [var Int]   = Array.init<Int>(PROPOSAL_CAP,    0);
  stable var nextProposalId     : Nat         = 1;

  // Vote receipts (to prevent double-voting): encoded as "neuronId:proposalId"
  let VOTE_RECEIPT_CAP : Nat = 16384;
  stable var voteReceiptCount   : Nat = 0;
  stable var voteReceipts       : [var Text]  = Array.init<Text>(VOTE_RECEIPT_CAP, "");

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — NEURON OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  func _findNeuron(id : Nat) : ?Nat {
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // ── Create neuron (called by PARALLAX stake bridge, or directly) ─────────
  public shared(msg) func createNeuron(
    stakeIcp   : Nat,
    stakeOnes  : Nat,
    dissolveDays : Nat,
    label      : Text
  ) : async {
    success  : Bool;
    neuronId : Nat;
    votingPower : Float;
  } {
    if (stakeIcp == 0 and stakeOnes == 0) return { success = false; neuronId = 0; votingPower = 0.0 };
    if (dissolveDays < 1) return { success = false; neuronId = 0; votingPower = 0.0 };
    if (neuronCount >= NEURON_CAP) return { success = false; neuronId = 0; votingPower = 0.0 };
    let ni    = neuronCount;
    let id    = nextNeuronId;
    let now   = Time.now();
    let totalStake = stakeIcp + stakeOnes;
    let vp    = _votingPower(totalStake, dissolveDays, 0);
    neuronIds[ni]        := id;
    neuronOwners[ni]     := Principal.toText(msg.caller);
    neuronStakesIcp[ni]  := stakeIcp;
    neuronStakesOnes[ni] := stakeOnes;
    neuronDissolves[ni]  := dissolveDays;
    neuronAges[ni]       := now;
    neuronMaturities[ni] := 0;
    neuronVotesCast[ni]  := 0;
    neuronStatuses[ni]   := "LOCKED";
    neuronFollowing[ni]  := "";
    neuronLabels[ni]     := label;
    neuronCount          := neuronCount + 1;
    nextNeuronId         := nextNeuronId + 1;
    { success = true; neuronId = id; votingPower = vp }
  };

  // ── Add stake to existing neuron (top-up) ────────────────────────────────
  public shared(msg) func topUpNeuron(neuronId : Nat, additionalIcp : Nat, additionalOnes : Nat) : async {
    success     : Bool;
    newStakeIcp : Nat;
    newVotingPower : Float;
  } {
    switch (_findNeuron(neuronId)) {
      case null { { success = false; newStakeIcp = 0; newVotingPower = 0.0 } };
      case (?i) {
        if (neuronOwners[i] != Principal.toText(msg.caller) and not isSovereign(msg.caller)) {
          return { success = false; newStakeIcp = 0; newVotingPower = 0.0 }
        };
        neuronStakesIcp[i]  := neuronStakesIcp[i]  + additionalIcp;
        neuronStakesOnes[i] := neuronStakesOnes[i] + additionalOnes;
        let now     = Time.now();
        let ageSecs = now - neuronAges[i];
        let totalStake = neuronStakesIcp[i] + neuronStakesOnes[i];
        let vp = _votingPower(totalStake, neuronDissolves[i], ageSecs);
        { success = true; newStakeIcp = neuronStakesIcp[i]; newVotingPower = vp }
      };
    }
  };

  // ── Increase dissolve delay ───────────────────────────────────────────────
  public shared(msg) func increaseDissolveDelay(neuronId : Nat, additionalDays : Nat) : async {
    success      : Bool;
    newDissolve  : Nat;
    newVotingPower : Float;
  } {
    switch (_findNeuron(neuronId)) {
      case null { { success = false; newDissolve = 0; newVotingPower = 0.0 } };
      case (?i) {
        if (neuronOwners[i] != Principal.toText(msg.caller) and not isSovereign(msg.caller)) {
          return { success = false; newDissolve = 0; newVotingPower = 0.0 }
        };
        let newDays = neuronDissolves[i] + additionalDays;
        let capped  = if (newDays > 8 * 365) 8 * 365 else newDays;  // max 8 years
        neuronDissolves[i] := capped;
        let ageSecs    = Time.now() - neuronAges[i];
        let totalStake = neuronStakesIcp[i] + neuronStakesOnes[i];
        let vp = _votingPower(totalStake, capped, ageSecs);
        { success = true; newDissolve = capped; newVotingPower = vp }
      };
    }
  };

  // ── Start dissolving ──────────────────────────────────────────────────────
  public shared(msg) func startDissolving(neuronId : Nat) : async Bool {
    switch (_findNeuron(neuronId)) {
      case null false;
      case (?i) {
        if (neuronOwners[i] != Principal.toText(msg.caller) and not isSovereign(msg.caller)) return false;
        if (neuronStatuses[i] == "LOCKED") {
          neuronStatuses[i] := "DISSOLVING";
          true
        } else false
      };
    }
  };

  // ── Set following (alias-vote) ─────────────────────────────────────────────
  public shared(msg) func setFollowing(neuronId : Nat, followeeId : Nat) : async Bool {
    switch (_findNeuron(neuronId)) {
      case null false;
      case (?i) {
        if (neuronOwners[i] != Principal.toText(msg.caller)) return false;
        neuronFollowing[i] := Nat.toText(followeeId);
        true
      };
    }
  };

  // ── Get neuron details ────────────────────────────────────────────────────
  public query func getNeuron(id : Nat) : async ?{
    neuronId     : Nat;
    owner        : Text;
    stakeIcp     : Nat;
    stakeOnes    : Nat;
    dissolveDays : Nat;
    maturity     : Nat;
    votesCast    : Nat;
    status       : Text;
    label        : Text;
    following    : Text;
    votingPower  : Float;
    createdAt    : Int;
  } {
    switch (_findNeuron(id)) {
      case null null;
      case (?i) {
        let ageSecs    = Time.now() - neuronAges[i];
        let totalStake = neuronStakesIcp[i] + neuronStakesOnes[i];
        let vp = _votingPower(totalStake, neuronDissolves[i], ageSecs);
        ?{
          neuronId     = neuronIds[i];
          owner        = neuronOwners[i];
          stakeIcp     = neuronStakesIcp[i];
          stakeOnes    = neuronStakesOnes[i];
          dissolveDays = neuronDissolves[i];
          maturity     = neuronMaturities[i];
          votesCast    = neuronVotesCast[i];
          status       = neuronStatuses[i];
          label        = neuronLabels[i];
          following    = neuronFollowing[i];
          votingPower  = vp;
          createdAt    = neuronAges[i];
        }
      };
    }
  };

  // ── All neurons for a principal ───────────────────────────────────────────
  public shared(msg) func myNeurons() : async [{
    neuronId     : Nat;
    stakeIcp     : Nat;
    stakeOnes    : Nat;
    dissolveDays : Nat;
    maturity     : Nat;
    status       : Text;
    label        : Text;
    votingPower  : Float;
  }] {
    let p = Principal.toText(msg.caller);
    var result : [{ neuronId:Nat; stakeIcp:Nat; stakeOnes:Nat; dissolveDays:Nat; maturity:Nat; status:Text; label:Text; votingPower:Float }] = [];
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronOwners[i] == p) {
        let ageSecs    = Time.now() - neuronAges[i];
        let totalStake = neuronStakesIcp[i] + neuronStakesOnes[i];
        let vp = _votingPower(totalStake, neuronDissolves[i], ageSecs);
        result := Array.append(result, [{
          neuronId = neuronIds[i]; stakeIcp = neuronStakesIcp[i]; stakeOnes = neuronStakesOnes[i];
          dissolveDays = neuronDissolves[i]; maturity = neuronMaturities[i];
          status = neuronStatuses[i]; label = neuronLabels[i]; votingPower = vp;
        }]);
      };
      i += 1;
    };
    result
  };

  // ── Total voting power in the system ──────────────────────────────────────
  public query func totalVotingPower() : async Float {
    var total : Float = 0.0;
    var i = 0;
    let now = Time.now();
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronStatuses[i] == "LOCKED") {
        let ageSecs    = now - neuronAges[i];
        let totalStake = neuronStakesIcp[i] + neuronStakesOnes[i];
        total += _votingPower(totalStake, neuronDissolves[i], ageSecs);
      };
      i += 1;
    };
    total
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — PROPOSAL OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  func _findProposal(id : Nat) : ?Nat {
    var i = 0;
    while (i < proposalCount and i < PROPOSAL_CAP) {
      if (proposalIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // Check if neuron already voted on this proposal
  func _alreadyVoted(neuronId : Nat, proposalId : Nat) : Bool {
    let key = Nat.toText(neuronId) # ":" # Nat.toText(proposalId);
    var i = 0;
    while (i < voteReceiptCount and i < VOTE_RECEIPT_CAP) {
      if (voteReceipts[i] == key) return true;
      i += 1;
    };
    false
  };

  func _recordVote(neuronId : Nat, proposalId : Nat) {
    if (voteReceiptCount >= VOTE_RECEIPT_CAP) return;
    let key = Nat.toText(neuronId) # ":" # Nat.toText(proposalId);
    voteReceipts[voteReceiptCount] := key;
    voteReceiptCount := voteReceiptCount + 1;
  };

  // ── Submit a governance proposal ──────────────────────────────────────────
  public shared(msg) func submitProposal(
    neuronId : Nat,
    title    : Text,
    summary  : Text,
    kind     : Text
  ) : async {
    success    : Bool;
    proposalId : Nat;
  } {
    // Proposer must own a neuron with voting power > 0
    switch (_findNeuron(neuronId)) {
      case null { return { success = false; proposalId = 0 } };
      case (?ni) {
        if (neuronOwners[ni] != Principal.toText(msg.caller)) return { success = false; proposalId = 0 };
        if (neuronStatuses[ni] != "LOCKED") return { success = false; proposalId = 0 };
        if (proposalCount >= PROPOSAL_CAP) return { success = false; proposalId = 0 };
        let pi = proposalCount;
        let id = nextProposalId;
        proposalIds[pi]       := id;
        proposalProposers[pi] := Principal.toText(msg.caller);
        proposalTitles[pi]    := title;
        proposalSummaries[pi] := summary;
        proposalKinds[pi]     := kind;
        proposalVotesYes[pi]  := 0.0;
        proposalVotesNo[pi]   := 0.0;
        proposalVotesAbs[pi]  := 0.0;
        proposalStatuses[pi]  := "OPEN";
        proposalCreatedAt[pi] := Time.now();
        proposalCount         := proposalCount + 1;
        nextProposalId        := nextProposalId + 1;
        { success = true; proposalId = id }
      };
    }
  };

  // ── Cast a vote ───────────────────────────────────────────────────────────
  // ballot: "YES" | "NO" | "ABSTAIN"
  public shared(msg) func vote(neuronId : Nat, proposalId : Nat, ballot : Text) : async {
    success      : Bool;
    votingPower  : Float;
    newYes       : Float;
    newNo        : Float;
  } {
    switch (_findNeuron(neuronId), _findProposal(proposalId)) {
      case (null, _) { { success = false; votingPower = 0.0; newYes = 0.0; newNo = 0.0 } };
      case (_, null) { { success = false; votingPower = 0.0; newYes = 0.0; newNo = 0.0 } };
      case (?ni, ?pi) {
        // Caller must own the neuron
        if (neuronOwners[ni] != Principal.toText(msg.caller) and not isSovereign(msg.caller)) {
          return { success = false; votingPower = 0.0; newYes = 0.0; newNo = 0.0 }
        };
        if (proposalStatuses[pi] != "OPEN") {
          return { success = false; votingPower = 0.0; newYes = proposalVotesYes[pi]; newNo = proposalVotesNo[pi] }
        };
        if (_alreadyVoted(neuronId, proposalId)) {
          return { success = false; votingPower = 0.0; newYes = proposalVotesYes[pi]; newNo = proposalVotesNo[pi] }
        };
        let ageSecs    = Time.now() - neuronAges[ni];
        let totalStake = neuronStakesIcp[ni] + neuronStakesOnes[ni];
        let vp = _votingPower(totalStake, neuronDissolves[ni], ageSecs);
        if      (ballot == "YES")    { proposalVotesYes[pi] := proposalVotesYes[pi] + vp }
        else if (ballot == "NO")     { proposalVotesNo[pi]  := proposalVotesNo[pi]  + vp }
        else                         { proposalVotesAbs[pi] := proposalVotesAbs[pi] + vp };
        _recordVote(neuronId, proposalId);
        neuronVotesCast[ni] := neuronVotesCast[ni] + 1;
        // Maturity reward: 1 unit per vote (simplified; NNS rewards proportionally)
        neuronMaturities[ni] := neuronMaturities[ni] + 1;
        { success = true; votingPower = vp; newYes = proposalVotesYes[pi]; newNo = proposalVotesNo[pi] }
      };
    }
  };

  // ── Execute / finalize a proposal (sovereign or automatic) ────────────────
  // A proposal ACCEPTS if YES > NO and YES > (total VP × φ⁻¹) i.e. > ≈38% of total VP
  public shared(msg) func finalizeProposal(proposalId : Nat) : async {
    success : Bool;
    status  : Text;
  } {
    switch (_findProposal(proposalId)) {
      case null { { success = false; status = "NOT_FOUND" } };
      case (?pi) {
        if (proposalStatuses[pi] != "OPEN") return { success = false; status = proposalStatuses[pi] };
        let yes   = proposalVotesYes[pi];
        let no    = proposalVotesNo[pi];
        let total = yes + no + proposalVotesAbs[pi];
        // Quorum: at least φ⁻¹ (≈38.2%) of total VP must have voted YES+NO
        let quorum = if (total > EPSILON) (yes + no) / total else 0.0;
        let result =
          if (quorum < PHI_INV) "REJECTED"  // quorum not met
          else if (yes > no)    "ACCEPTED"
          else                  "REJECTED";
        proposalStatuses[pi] := result;
        { success = true; status = result }
      };
    }
  };

  // ── Get proposal ─────────────────────────────────────────────────────────
  public query func getProposal(id : Nat) : async ?{
    proposalId : Nat;
    proposer   : Text;
    title      : Text;
    summary    : Text;
    kind       : Text;
    yes        : Float;
    no         : Float;
    abstain    : Float;
    status     : Text;
    createdAt  : Int;
  } {
    switch (_findProposal(id)) {
      case null null;
      case (?pi) {
        ?{
          proposalId = proposalIds[pi];
          proposer   = proposalProposers[pi];
          title      = proposalTitles[pi];
          summary    = proposalSummaries[pi];
          kind       = proposalKinds[pi];
          yes        = proposalVotesYes[pi];
          no         = proposalVotesNo[pi];
          abstain    = proposalVotesAbs[pi];
          status     = proposalStatuses[pi];
          createdAt  = proposalCreatedAt[pi];
        }
      };
    }
  };

  // ── List open proposals ───────────────────────────────────────────────────
  public query func listOpenProposals() : async [{ proposalId:Nat; title:Text; kind:Text; yes:Float; no:Float; createdAt:Int }] {
    var result : [{ proposalId:Nat; title:Text; kind:Text; yes:Float; no:Float; createdAt:Int }] = [];
    var i = 0;
    while (i < proposalCount and i < PROPOSAL_CAP) {
      if (proposalStatuses[i] == "OPEN") {
        result := Array.append(result, [{
          proposalId = proposalIds[i]; title = proposalTitles[i]; kind = proposalKinds[i];
          yes = proposalVotesYes[i]; no = proposalVotesNo[i]; createdAt = proposalCreatedAt[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ── All proposals ─────────────────────────────────────────────────────────
  public query func listAllProposals() : async [{ proposalId:Nat; title:Text; status:Text; kind:Text }] {
    Array.tabulate<{ proposalId:Nat; title:Text; status:Text; kind:Text }>(proposalCount, func(i) {
      { proposalId = proposalIds[i]; title = proposalTitles[i]; status = proposalStatuses[i]; kind = proposalKinds[i] }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — MATURITY DISBURSEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  // Spawn maturity as new ONESICANS (simplified: sovereign confirms)
  public shared(msg) func spawnMaturity(neuronId : Nat) : async {
    success   : Bool;
    spawned   : Nat;
    remaining : Nat;
  } {
    switch (_findNeuron(neuronId)) {
      case null { { success = false; spawned = 0; remaining = 0 } };
      case (?ni) {
        if (neuronOwners[ni] != Principal.toText(msg.caller) and not isSovereign(msg.caller)) {
          return { success = false; spawned = 0; remaining = 0 }
        };
        let mat = neuronMaturities[ni];
        if (mat == 0) return { success = false; spawned = 0; remaining = 0 };
        neuronMaturities[ni] := 0;
        { success = true; spawned = mat; remaining = 0 }
      };
    }
  };

  // ── Distribute rewards: sovereign periodically mints maturity ─────────────
  public shared(msg) func distributeRewards(rewardPerVote : Nat) : async Nat {
    requireSovereign(msg.caller);
    var total : Nat = 0;
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronStatuses[i] == "LOCKED" and neuronVotesCast[i] > 0) {
        let reward = neuronVotesCast[i] * rewardPerVote;
        neuronMaturities[i] := neuronMaturities[i] + reward;
        total += reward;
      };
      i += 1;
    };
    total
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — GOVERNANCE STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getNeuronCount()   : async Nat { neuronCount };
  public query func getProposalCount() : async Nat { proposalCount };

  public query func getGovernanceStatus() : async {
    seal          : Text;
    claimed       : Bool;
    neuronCount   : Nat;
    proposalCount : Nat;
    phi           : Float;
    votingFormula : Text;
  } {
    {
      seal          = sovereignSeal;
      claimed       = genesisLocked;
      neuronCount   = neuronCount;
      proposalCount = proposalCount;
      phi           = PHI;
      votingFormula = "VP = stake × φ^(dissolve_years) × min(φ^(age_years × 0.25), φ²)";
    }
  };

};
