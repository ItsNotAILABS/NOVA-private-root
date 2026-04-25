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
// NEURON FLEET — 200 NNS Neuron Fleet Manager
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// THE NEURON FLEET IS THE SOVEREIGNTY ENGINE.
//
// 200 neurons registered in the ICP Network Nervous System (NNS).
// This canister tracks, manages, and maximizes governance value from all 200.
// It is the single source of truth for the NOVA governance posture.
//
// ── WHAT A NEURON IS ─────────────────────────────────────────────────────────
// A neuron is staked ICP. When you stake ICP in the NNS:
//   - You earn voting rewards proportional to VP × voting_frequency
//   - VP (Voting Power) = stake × dissolve_delay_bonus × age_bonus
//   - Dissolve delay bonus: up to 2× for 8-year dissolve
//   - Age bonus: up to 1.25× for neurons aged 4+ years
//   - Maturity accumulates. Maturity can be spawned into NEW ICP neurons
//     or staked back into the existing neuron (compounding)
//
// ── OUR APPROACH — φ-MAXIMIZATION ────────────────────────────────────────────
// 200 neurons organized in Fibonacci-weighted groups:
//
//   GROUP A (SOVEREIGNTY, 8 neurons)  — 8-year dissolve, max VP, auto-vote
//     Stake per neuron: LARGE. These never dissolve. Pure governance.
//   GROUP B (COMPOUNDING, 34 neurons) — 4-6yr dissolve, auto-stake-maturity
//     Stake per neuron: MEDIUM. Maturity always staked back. Compounds.
//   GROUP C (HARVEST, 89 neurons)     — 2-4yr dissolve, maturity→spawn
//     Stake per neuron: MEDIUM-SMALL. Maturity spawns NEW neurons.
//   GROUP D (LIQUID, 55 neurons)      — 1-2yr dissolve, maturity→ICP→ONESICAN
//     Stake per neuron: SMALL. Fastest reward cycle. Feeds ONESICAN treasury.
//   GROUP E (PHANTOM, 14 neurons)     — PHANTOM substrate, 8-year dissolve
//     These neurons are conceptually assigned to PHANTOM substrate governance.
//     They vote on topics that affect cross-substrate sovereignty.
//
//   Total: 8 + 34 + 89 + 55 + 14 = 200 neurons
//   Fibonacci groups: 8, 34, 89, 55, 14 (F(6), F(9), F(11), F(10), F(7))
//
// ── VOTING STRATEGY ──────────────────────────────────────────────────────────
// Auto-follow: every neuron follows the SOVEREIGN neuron (Group A, neuron 1)
// for most topics. For economic/governance proposals, the AI DIVISION
// can override with per-neuron vote commands.
//
// Topics:
//   NNS_CANISTER_UPGRADE  → follow SOVEREIGN
//   NETWORK_ECONOMICS     → AI_DIVISION decides (owns the vote)
//   NEURON_MANAGEMENT     → follow SOVEREIGN
//   GOVERNANCE            → follow SOVEREIGN
//   NODE_ADMIN            → AI_DIVISION decides
//   SNS_AND_COMMUNITY     → AI_DIVISION + majority ONESICAN holder vote
//
// ── MATURITY ENGINE ──────────────────────────────────────────────────────────
// Every maturity harvest event is recorded.
// Each group has its own maturity policy:
//   GROUP_A: STAKE_MATURITY (compound forever)
//   GROUP_B: STAKE_MATURITY (compound)
//   GROUP_C: SPAWN_NEURON   (grow the fleet)
//   GROUP_D: DISBURSE       (ICP out → ONESICAN mint)
//   GROUP_E: STAKE_MATURITY (phantom compounding)
//
// ── VALUE CALCULATION ────────────────────────────────────────────────────────
// Per ICP staked in NNS at maximum settings:
//   Voting reward rate ≈ 10-15% APY on ICP
//   Our 200-neuron fleet compounds that:
//   If average stake = 100 ICP/neuron → 20,000 ICP total
//   At 12% APY → 2,400 ICP/year in maturity
//   Group C spawns new neurons from maturity → fleet grows
//   Group D converts to ICP → ONESICAN → treasury
//
// ── CYCLES PREMIUM EXPLAINED ─────────────────────────────────────────────────
// ICP cycles are denominated in XDR (SDR, ~$1.30).
// 1 ICP ≈ 10 trillion cycles (varies with ICP price).
// At ICP=$10:  1 ICP = 1T cycles = 1T compute units
// At ICP=$30:  1 ICP = 3T cycles (cycles are XDR-pegged, not ICP-pegged)
//
// ONESICAN premium over raw ICP cycles:
//   ONESICAN on ICP substrate      = 1× (parity with raw cycles)
//   ONESICAN on EDGE substrate     = φ¹ = 1.618× (latency premium)
//   ONESICAN on CLOUD substrate    = φ² = 2.618× (sovereignty tax)
//   ONESICAN on PHANTOM substrate  = φ³ = 4.236× (encryption + sovereign)
//
// So 1 ONESICAN sold on PHANTOM substrate = 4.236 raw ICP cycle-equivalents.
// At 10T cycles per ICP: 1 ONESICAN on PHANTOM ≈ 4.236T raw-cycle-equivalent.
// This is the vein. We OWN the vein.
//
// ── NODE REGISTRATION ────────────────────────────────────────────────────────
// 100 field nodes are registered. Each node is associated with 2 neurons.
// Node-neuron binding allows per-node governance participation.
// AI_DIVISION uses node health to route vote weight.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor NeuronFleet {

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
    if (genesisLocked) return "NEURON_FLEET_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-NEURON-FLEET-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };
  public query func getTimestamp() : async Int  { genesisTimestamp };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp == 0.0) 1.0 else 0.0 }
    else Float.exp(exp * Float.log(base))
  };

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — NEURON GROUP DEFINITIONS (200 neurons, 5 Fibonacci groups)
  // ═══════════════════════════════════════════════════════════════════════════

  // Group sizes: 8 + 34 + 89 + 55 + 14 = 200
  let GROUP_A_SIZE : Nat = 8;   // SOVEREIGNTY (F6)
  let GROUP_B_SIZE : Nat = 34;  // COMPOUNDING (F9)
  let GROUP_C_SIZE : Nat = 89;  // HARVEST     (F11)
  let GROUP_D_SIZE : Nat = 55;  // LIQUID      (F10)
  let GROUP_E_SIZE : Nat = 14;  // PHANTOM     (F7)
  let TOTAL_NEURONS : Nat = 200;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — NEURON REGISTRY (200 slots)
  // ═══════════════════════════════════════════════════════════════════════════

  let NEURON_CAP : Nat = 256;  // headroom for spawned neurons

  stable var neuronCount        : Nat = 0;
  stable var neuronIds          : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);
  // NNS neuron IDs (provided when staked on-chain)
  stable var neuronNnsIds       : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);
  stable var neuronGroups       : [var Text]  = Array.init<Text>(NEURON_CAP,  "");
  // Groups: A_SOVEREIGNTY | B_COMPOUNDING | C_HARVEST | D_LIQUID | E_PHANTOM
  stable var neuronStakes       : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // e8s ICP
  stable var neuronDissolveYears: [var Float] = Array.init<Float>(NEURON_CAP, 0.0);
  stable var neuronAgeYears     : [var Float] = Array.init<Float>(NEURON_CAP, 0.0);
  stable var neuronMaturity     : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // e8s maturity
  stable var neuronTotalHarvest : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // lifetime
  stable var neuronVotingPower  : [var Float] = Array.init<Float>(NEURON_CAP, 0.0);
  stable var neuronPolicies     : [var Text]  = Array.init<Text>(NEURON_CAP,  "STAKE_MATURITY");
  // Policies: STAKE_MATURITY | SPAWN_NEURON | DISBURSE
  stable var neuronStatuses     : [var Text]  = Array.init<Text>(NEURON_CAP,  "ACTIVE");
  // Statuses: ACTIVE | DISSOLVING | DISSOLVED | SPAWNING | INACTIVE
  stable var neuronFollowsId    : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // follows this neuron ID
  stable var neuronSubstrates   : [var Text]  = Array.init<Text>(NEURON_CAP,  "ICP");
  stable var neuronNodeBindings : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);  // bound field node ID
  stable var neuronCreatedAt    : [var Int]   = Array.init<Int>(NEURON_CAP,   0);
  stable var neuronLastVoted    : [var Int]   = Array.init<Int>(NEURON_CAP,   0);
  stable var neuronVoteCount    : [var Nat]   = Array.init<Nat>(NEURON_CAP,   0);
  stable var nextNeuronId       : Nat         = 1;

  // Compute voting power: VP = stake_e8s / 1e8 × dissolve_bonus × age_bonus
  // dissolve_bonus = 1 + min(dissolveYears/8, 1)  (max 2× at 8yr)
  // age_bonus      = 1 + min(ageYears/4, 1) × 0.25 (max 1.25× at 4yr)
  func _computeVP(stakeE8s : Nat, dissolveYears : Float, ageYears : Float) : Float {
    let stake = Float.fromInt(stakeE8s) / 100_000_000.0;
    let dBonus = 1.0 + (if (dissolveYears >= 8.0) 1.0 else dissolveYears / 8.0);
    let aBonus = 1.0 + (if (ageYears >= 4.0) 1.0 else ageYears / 4.0) * 0.25;
    stake * dBonus * aBonus
  };

  // Register a neuron in the fleet
  public shared(msg) func registerNeuron(
    nnsId        : Nat,
    group        : Text,
    stakeE8s     : Nat,
    dissolveYears: Float,
    ageYears     : Float,
    policy       : Text,
    substrate    : Text,
    nodeBinding  : Nat
  ) : async { success : Bool; neuronId : Nat; votingPower : Float } {
    requireSovereign(msg.caller);
    if (neuronCount >= NEURON_CAP) return { success = false; neuronId = 0; votingPower = 0.0 };
    let ni = neuronCount;
    let id = nextNeuronId;
    let vp = _computeVP(stakeE8s, dissolveYears, ageYears);
    neuronIds[ni]           := id;
    neuronNnsIds[ni]        := nnsId;
    neuronGroups[ni]        := group;
    neuronStakes[ni]        := stakeE8s;
    neuronDissolveYears[ni] := dissolveYears;
    neuronAgeYears[ni]      := ageYears;
    neuronMaturity[ni]      := 0;
    neuronTotalHarvest[ni]  := 0;
    neuronVotingPower[ni]   := vp;
    neuronPolicies[ni]      := policy;
    neuronStatuses[ni]      := "ACTIVE";
    neuronFollowsId[ni]     := 1;  // default: follow neuron 1 (SOVEREIGN)
    neuronSubstrates[ni]    := substrate;
    neuronNodeBindings[ni]  := nodeBinding;
    neuronCreatedAt[ni]     := Time.now();
    neuronLastVoted[ni]     := 0;
    neuronVoteCount[ni]     := 0;
    neuronCount             := neuronCount + 1;
    nextNeuronId            := nextNeuronId + 1;
    { success = true; neuronId = id; votingPower = vp }
  };

  // Bootstrap all 200 neurons with Fibonacci-group defaults
  // Sovereign calls this once with their stake amounts per group
  public shared(msg) func bootstrapFleet(
    groupAStakeE8s : Nat,   // e.g. 100_000_000_000 (1000 ICP per neuron × 8)
    groupBStakeE8s : Nat,
    groupCStakeE8s : Nat,
    groupDStakeE8s : Nat,
    groupEStakeE8s : Nat
  ) : async { success : Bool; registered : Nat; totalVP : Float; totalStakeE8s : Nat } {
    requireSovereign(msg.caller);
    var registered : Nat = 0;
    var totalVP    : Float = 0.0;
    var totalStake : Nat = 0;

    // Helper to register a batch
    let registerBatch = func(group : Text, size : Nat, stakeE8s : Nat,
                               dissolveYrs : Float, policy : Text, substrate : Text) {
      var i = 0;
      while (i < size and neuronCount < NEURON_CAP) {
        let ni  = neuronCount;
        let id  = nextNeuronId;
        let vp  = _computeVP(stakeE8s, dissolveYrs, if (i == 0) 0.0 else Float.fromInt(i) * 0.1);
        neuronIds[ni]           := id;
        neuronNnsIds[ni]        := 0;  // to be filled when staked on NNS
        neuronGroups[ni]        := group;
        neuronStakes[ni]        := stakeE8s;
        neuronDissolveYears[ni] := dissolveYrs;
        neuronAgeYears[ni]      := if (i == 0) 0.0 else Float.fromInt(i) * 0.1;
        neuronMaturity[ni]      := 0;
        neuronTotalHarvest[ni]  := 0;
        neuronVotingPower[ni]   := vp;
        neuronPolicies[ni]      := policy;
        neuronStatuses[ni]      := "ACTIVE";
        neuronFollowsId[ni]     := if (group == "A_SOVEREIGNTY") 0 else 1;  // group A follows itself
        neuronSubstrates[ni]    := substrate;
        neuronNodeBindings[ni]  := 0;
        neuronCreatedAt[ni]     := Time.now();
        neuronLastVoted[ni]     := 0;
        neuronVoteCount[ni]     := 0;
        neuronCount             := neuronCount + 1;
        nextNeuronId            := nextNeuronId + 1;
        registered              += 1;
        totalVP                 += vp;
        totalStake              += stakeE8s;
        i += 1;
      };
    };

    registerBatch("A_SOVEREIGNTY", GROUP_A_SIZE,  groupAStakeE8s, 8.0, "STAKE_MATURITY", "ICP");
    registerBatch("B_COMPOUNDING", GROUP_B_SIZE,  groupBStakeE8s, 5.0, "STAKE_MATURITY", "ICP");
    registerBatch("C_HARVEST",     GROUP_C_SIZE,  groupCStakeE8s, 3.0, "SPAWN_NEURON",   "ICP");
    registerBatch("D_LIQUID",      GROUP_D_SIZE,  groupDStakeE8s, 1.5, "DISBURSE",       "ICP");
    registerBatch("E_PHANTOM",     GROUP_E_SIZE,  groupEStakeE8s, 8.0, "STAKE_MATURITY", "PHANTOM");

    { success = true; registered; totalVP; totalStakeE8s = totalStake }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — NNS ID ASSIGNMENT (after on-chain staking)
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func setNnsId(neuronId : Nat, nnsId : Nat) : async Bool {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronIds[i] == neuronId) { neuronNnsIds[i] := nnsId; return true };
      i += 1;
    };
    false
  };

  // Bind a field node to a neuron
  public shared(msg) func bindNode(neuronId : Nat, nodeId : Nat) : async Bool {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronIds[i] == neuronId) { neuronNodeBindings[i] := nodeId; return true };
      i += 1;
    };
    false
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — MATURITY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var totalMaturityAccrued  : Nat = 0;
  stable var totalMaturityStaked   : Nat = 0;
  stable var totalMaturitySpawned  : Nat = 0;
  stable var totalMaturityDisbursed: Nat = 0;
  stable var totalNeuronsSpawned   : Nat = 0;

  // Record maturity accrual for a neuron
  public shared(msg) func recordMaturity(neuronId : Nat, maturityE8s : Nat) : async {
    success  : Bool;
    policy   : Text;
    action   : Text;
  } {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronIds[i] == neuronId) {
        neuronMaturity[i]      := neuronMaturity[i] + maturityE8s;
        neuronTotalHarvest[i]  := neuronTotalHarvest[i] + maturityE8s;
        totalMaturityAccrued   := totalMaturityAccrued + maturityE8s;
        let policy = neuronPolicies[i];
        let action = if (policy == "STAKE_MATURITY")
          "STAKE_BACK: " # Nat.toText(maturityE8s) # "e8s added to stake"
        else if (policy == "SPAWN_NEURON")
          "SPAWN_READY: " # Nat.toText(maturityE8s) # "e8s ready to spawn new neuron"
        else
          "DISBURSE: " # Nat.toText(maturityE8s) # "e8s → ICP → ONESICAN treasury";
        return { success = true; policy; action }
      };
      i += 1;
    };
    { success = false; policy = "NOT_FOUND"; action = "NO_ACTION" }
  };

  // Execute maturity policy for a neuron
  public shared(msg) func executeMaturityPolicy(neuronId : Nat) : async {
    success   : Bool;
    policy    : Text;
    amount    : Nat;
    outcome   : Text;
    newNeuronId : Nat;
  } {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronIds[i] == neuronId and neuronMaturity[i] > 0) {
        let amount = neuronMaturity[i];
        let policy = neuronPolicies[i];
        neuronMaturity[i] := 0;  // clear pending maturity
        if (policy == "STAKE_MATURITY") {
          neuronStakes[i]     := neuronStakes[i] + amount;
          neuronVotingPower[i] := _computeVP(neuronStakes[i], neuronDissolveYears[i], neuronAgeYears[i]);
          totalMaturityStaked := totalMaturityStaked + amount;
          return { success = true; policy; amount; outcome = "STAKED_BACK_VP_INCREASED"; newNeuronId = 0 }
        } else if (policy == "SPAWN_NEURON") {
          // Spawn a new child neuron (recorded as a new fleet member)
          totalMaturitySpawned := totalMaturitySpawned + amount;
          totalNeuronsSpawned  := totalNeuronsSpawned + 1;
          if (neuronCount < NEURON_CAP) {
            let ni2 = neuronCount;
            let id2 = nextNeuronId;
            let vp2 = _computeVP(amount, 3.0, 0.0);  // 3yr dissolve for spawned neurons
            neuronIds[ni2]           := id2;
            neuronNnsIds[ni2]        := 0;
            neuronGroups[ni2]        := "C_HARVEST";
            neuronStakes[ni2]        := amount;
            neuronDissolveYears[ni2] := 3.0;
            neuronAgeYears[ni2]      := 0.0;
            neuronMaturity[ni2]      := 0;
            neuronTotalHarvest[ni2]  := 0;
            neuronVotingPower[ni2]   := vp2;
            neuronPolicies[ni2]      := "SPAWN_NEURON";
            neuronStatuses[ni2]      := "ACTIVE";
            neuronFollowsId[ni2]     := 1;
            neuronSubstrates[ni2]    := "ICP";
            neuronNodeBindings[ni2]  := 0;
            neuronCreatedAt[ni2]     := Time.now();
            neuronLastVoted[ni2]     := 0;
            neuronVoteCount[ni2]     := 0;
            neuronCount              := neuronCount + 1;
            nextNeuronId             := nextNeuronId + 1;
            return { success = true; policy; amount; outcome = "NEW_NEURON_SPAWNED"; newNeuronId = id2 }
          };
          return { success = true; policy; amount; outcome = "SPAWN_QUEUED_CAPACITY_FULL"; newNeuronId = 0 }
        } else {
          // DISBURSE: send to ONESICAN treasury (recorded here, executed by TOKEN_FORGE)
          totalMaturityDisbursed := totalMaturityDisbursed + amount;
          return { success = true; policy; amount; outcome = "DISBURSED_TO_ONESICAN_TREASURY"; newNeuronId = 0 }
        };
      };
      i += 1;
    };
    { success = false; policy = "NOT_FOUND"; amount = 0; outcome = "NEURON_NOT_FOUND"; newNeuronId = 0 }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6b — DISPATCH MATURITY ACTIONS (BATCH — neurons make neurons)
  //
  //   This is the autonomous neurons-make-neurons loop.
  //   Called by ai_division.productionTick() every tick.
  //   Processes ALL neurons with pending maturity in a single call:
  //
  //   GROUP A/B/E → STAKE_MATURITY  → increases stake, boosts VP, compounds
  //   GROUP C     → SPAWN_NEURON    → spawns new C_HARVEST neurons (fleet grows)
  //   GROUP D     → DISBURSE        → returns ICP to auto_market treasury
  //
  //   Returns:
  //     staked      : total ICP (e8s) staked back across A/B/E neurons
  //     newNeurons  : count of neurons spawned by C group this dispatch
  //     disbursedE8s: total ICP (e8s) disbursed from D group → auto_market ingestIcp()
  //     totalProcessed: neurons that had maturity and were processed
  //
  //   After this call, auto_market.ingestIcp(disbursedE8s) should be called
  //   so the ICP enters the Golden Loop and becomes ONESICANS.
  //   This is wired in ai_division.productionTick() — no human action needed.
  // ═══════════════════════════════════════════════════════════════════════════

  stable var lifetimeDispatchCalls : Nat = 0;
  stable var lifetimeAutoStaked    : Nat = 0;   // total e8s auto-staked
  stable var lifetimeAutoSpawned   : Nat = 0;   // total neurons auto-spawned
  stable var lifetimeAutoDisbursed : Nat = 0;   // total e8s auto-disbursed to treasury

  public shared(msg) func dispatchMaturityActions() : async {
    staked           : Nat;   // total ICP e8s staked back (GROUP A/B/E)
    newNeurons       : Nat;   // neurons spawned (GROUP C)
    disbursedE8s     : Nat;   // ICP e8s to route to auto_market (GROUP D)
    totalProcessed   : Nat;   // neurons that had pending maturity
    fleetSize        : Nat;   // current total neuron count (including spawned)
    message          : Text;
  } {
    if (not isSovereign(msg.caller)) return {
      staked=0; newNeurons=0; disbursedE8s=0; totalProcessed=0; fleetSize=neuronCount;
      message="UNAUTHORIZED"
    };
    var staked       : Nat = 0;
    var newNeurons   : Nat = 0;
    var disbursedE8s : Nat = 0;
    var processed    : Nat = 0;
    var i = 0;
    // Snapshot current count to avoid processing newly-spawned neurons this tick
    let countSnap = neuronCount;
    while (i < countSnap and i < NEURON_CAP) {
      if (neuronStatuses[i] == "ACTIVE" and neuronMaturity[i] > 0) {
        let amount = neuronMaturity[i];
        let policy = neuronPolicies[i];
        neuronMaturity[i] := 0;
        processed += 1;
        if (policy == "STAKE_MATURITY") {
          // Stake back → VP increases → more governance power → more maturity next cycle
          neuronStakes[i]      := neuronStakes[i] + amount;
          neuronVotingPower[i] := _computeVP(neuronStakes[i], neuronDissolveYears[i], neuronAgeYears[i]);
          totalMaturityStaked  := totalMaturityStaked + amount;
          staked               := staked + amount;
          lifetimeAutoStaked   := lifetimeAutoStaked + amount;
        } else if (policy == "SPAWN_NEURON") {
          // Spawn a new C_HARVEST neuron — fleet grows autonomously
          totalMaturitySpawned := totalMaturitySpawned + amount;
          totalNeuronsSpawned  := totalNeuronsSpawned + 1;
          if (neuronCount < NEURON_CAP) {
            let ni2 = neuronCount;
            let id2 = nextNeuronId;
            let vp2 = _computeVP(amount, 3.0, 0.0);
            neuronIds[ni2]           := id2;
            neuronNnsIds[ni2]        := 0;
            neuronGroups[ni2]        := "C_HARVEST";
            neuronStakes[ni2]        := amount;
            neuronDissolveYears[ni2] := 3.0;
            neuronAgeYears[ni2]      := 0.0;
            neuronMaturity[ni2]      := 0;
            neuronTotalHarvest[ni2]  := 0;
            neuronVotingPower[ni2]   := vp2;
            neuronPolicies[ni2]      := "SPAWN_NEURON";
            neuronStatuses[ni2]      := "ACTIVE";
            neuronFollowsId[ni2]     := 1;
            neuronSubstrates[ni2]    := "ICP";
            neuronNodeBindings[ni2]  := 0;
            neuronCreatedAt[ni2]     := Time.now();
            neuronLastVoted[ni2]     := 0;
            neuronVoteCount[ni2]     := 0;
            neuronCount              := neuronCount + 1;
            nextNeuronId             := nextNeuronId + 1;
            newNeurons               := newNeurons + 1;
            lifetimeAutoSpawned      := lifetimeAutoSpawned + 1;
          };
        } else {
          // DISBURSE: ICP exits the fleet and enters auto_market Golden Loop
          totalMaturityDisbursed := totalMaturityDisbursed + amount;
          disbursedE8s           := disbursedE8s + amount;
          lifetimeAutoDisbursed  := lifetimeAutoDisbursed + amount;
        };
      };
      i += 1;
    };
    lifetimeDispatchCalls := lifetimeDispatchCalls + 1;
    {
      staked;
      newNeurons;
      disbursedE8s;
      totalProcessed = processed;
      fleetSize = neuronCount;
      message =
        "DISPATCH_COMPLETE: " # Nat.toText(processed) # " neurons processed. " #
        Nat.toText(staked/100_000_000) # " ICP staked. " #
        Nat.toText(newNeurons) # " neurons spawned (fleet=" # Nat.toText(neuronCount) # "). " #
        Nat.toText(disbursedE8s/100_000_000) # " ICP disbursed → auto_market ingestIcp() → Golden Loop."
    }
  };

  // Simulate maturity accrual for all neurons (called by ai_division each tick)
  // In production, maturity is recorded by real NNS events (recordMaturity per neuron).
  // This simulates the autonomous accrual so the loop runs without manual recording.
  public shared(msg) func simulateMaturityAccrual(baseMaturityPerNeuronE8s : Nat) : async {
    accrued : Nat; neurons : Nat;
  } {
    if (not isSovereign(msg.caller)) return { accrued = 0; neurons = 0 };
    var accrued : Nat = 0;
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronStatuses[i] == "ACTIVE") {
        // Scale by VP weight (more stake = more maturity)
        let vpFactor = _floatToNat(neuronVotingPower[i] / 10.0 + 1.0);
        let mat = baseMaturityPerNeuronE8s * vpFactor;
        neuronMaturity[i]      := neuronMaturity[i] + mat;
        neuronTotalHarvest[i]  := neuronTotalHarvest[i] + mat;
        totalMaturityAccrued   := totalMaturityAccrued + mat;
        accrued                := accrued + mat;
      };
      i += 1;
    };
    { accrued; neurons = neuronCount }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — VOTING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  let VOTE_CAP : Nat = 4096;

  stable var voteCount     : Nat = 0;
  stable var voteProposals : [var Nat]   = Array.init<Nat>(VOTE_CAP,   0);
  stable var voteTopics    : [var Text]  = Array.init<Text>(VOTE_CAP,  "");
  stable var voteDecisions : [var Text]  = Array.init<Text>(VOTE_CAP,  "YES");  // YES | NO | ABSTAIN
  stable var voteVP        : [var Float] = Array.init<Float>(VOTE_CAP, 0.0);
  stable var voteNeuronIds : [var Nat]   = Array.init<Nat>(VOTE_CAP,   0);
  stable var voteTimes     : [var Int]   = Array.init<Int>(VOTE_CAP,   0);

  // Cast fleet-wide vote on a proposal (all active neurons vote)
  public shared(msg) func castFleetVote(
    proposalId : Nat,
    topic      : Text,
    decision   : Text  // YES | NO | ABSTAIN
  ) : async {
    success      : Bool;
    neuronsVoted : Nat;
    totalVP      : Float;
    decision     : Text;
  } {
    if (not isSovereign(msg.caller)) return { success = false; neuronsVoted = 0; totalVP = 0.0; decision = "UNAUTHORIZED" };
    var voted : Nat = 0;
    var totalVP : Float = 0.0;
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronStatuses[i] == "ACTIVE" and voteCount < VOTE_CAP) {
        let vi = voteCount;
        voteProposals[vi] := proposalId;
        voteTopics[vi]    := topic;
        voteDecisions[vi] := decision;
        voteVP[vi]        := neuronVotingPower[i];
        voteNeuronIds[vi] := neuronIds[i];
        voteTimes[vi]     := Time.now();
        voteCount         := voteCount + 1;
        neuronLastVoted[i] := Time.now();
        neuronVoteCount[i] := neuronVoteCount[i] + 1;
        totalVP           += neuronVotingPower[i];
        voted             += 1;
      };
      i += 1;
    };
    { success = true; neuronsVoted = voted; totalVP; decision }
  };

  // Override vote for specific topic/neurons (AI_DIVISION calls this for economic proposals)
  public shared(msg) func castTargetedVote(
    proposalId : Nat,
    topic      : Text,
    group      : Text,    // vote only GROUP_D for economic topics
    decision   : Text
  ) : async { success : Bool; neuronsVoted : Nat; totalVP : Float } {
    requireSovereign(msg.caller);
    var voted : Nat = 0; var totalVP : Float = 0.0; var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronStatuses[i] == "ACTIVE" and neuronGroups[i] == group and voteCount < VOTE_CAP) {
        let vi = voteCount;
        voteProposals[vi] := proposalId; voteTopics[vi] := topic;
        voteDecisions[vi] := decision; voteVP[vi] := neuronVotingPower[i];
        voteNeuronIds[vi] := neuronIds[i]; voteTimes[vi] := Time.now();
        voteCount := voteCount + 1;
        neuronLastVoted[i] := Time.now(); neuronVoteCount[i] := neuronVoteCount[i] + 1;
        totalVP += neuronVotingPower[i]; voted += 1;
      };
      i += 1;
    };
    { success = true; neuronsVoted = voted; totalVP }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — FIELD NODE REGISTRY (100 nodes)
  // ═══════════════════════════════════════════════════════════════════════════

  let NODE_CAP : Nat = 128;

  stable var nodeCount      : Nat = 0;
  stable var nodeIds        : [var Nat]   = Array.init<Nat>(NODE_CAP,   0);
  stable var nodeNames      : [var Text]  = Array.init<Text>(NODE_CAP,  "");
  stable var nodeSubstrates : [var Text]  = Array.init<Text>(NODE_CAP,  "ICP");
  stable var nodeStatuses   : [var Text]  = Array.init<Text>(NODE_CAP,  "ACTIVE");
  // Statuses: ACTIVE | DEGRADED | OFFLINE
  stable var nodeHealths    : [var Float] = Array.init<Float>(NODE_CAP, 1.0);
  stable var nodeGpuCount   : [var Nat]   = Array.init<Nat>(NODE_CAP,   0);
  stable var nodeNeuron1    : [var Nat]   = Array.init<Nat>(NODE_CAP,   0);  // primary neuron
  stable var nodeNeuron2    : [var Nat]   = Array.init<Nat>(NODE_CAP,   0);  // secondary neuron
  stable var nodeRegisteredAt:[var Int]   = Array.init<Int>(NODE_CAP,   0);
  stable var nextNodeId     : Nat         = 1;

  // Bootstrap 100 field nodes
  public shared(msg) func bootstrapNodes() : async { success : Bool; registered : Nat } {
    requireSovereign(msg.caller);
    let substrates : [Text] = ["ICP", "ICP", "ICP", "BLOCKCHAIN", "EDGE", "CLOUD", "PHANTOM"];
    var registered : Nat = 0;
    var i = 0;
    while (i < 100 and nodeCount < NODE_CAP) {
      let ni  = nodeCount;
      let id  = nextNodeId;
      let sub = substrates[Nat.rem(i, substrates.size())];
      nodeIds[ni]          := id;
      nodeNames[ni]        := "NOVA-NODE-" # Nat.toText(id);
      nodeSubstrates[ni]   := sub;
      nodeStatuses[ni]     := "ACTIVE";
      nodeHealths[ni]      := 1.0;
      nodeGpuCount[ni]     := 1 + Nat.rem(i, 8);  // 1-8 GPUs per node
      nodeNeuron1[ni]      := 0;
      nodeNeuron2[ni]      := 0;
      nodeRegisteredAt[ni] := Time.now();
      nodeCount            := nodeCount + 1;
      nextNodeId           := nextNodeId + 1;
      registered           += 1;
      i += 1;
    };
    { success = true; registered }
  };

  public shared(msg) func updateNodeHealth(nodeId : Nat, health : Float, status : Text) : async Bool {
    var i = 0;
    while (i < nodeCount and i < NODE_CAP) {
      if (nodeIds[i] == nodeId) {
        nodeHealths[i]  := health;
        nodeStatuses[i] := status;
        return true
      };
      i += 1;
    };
    false
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — ANALYTICS + QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  // Fleet-wide summary
  public query func getFleetSummary() : async {
    totalNeurons    : Nat;
    activeNeurons   : Nat;
    totalStakeE8s   : Nat;
    totalStakeICP   : Float;
    totalVP         : Float;
    groupBreakdown  : [{ group:Text; count:Nat; totalVP:Float; policy:Text }];
    maturityStats   : { accrued:Nat; staked:Nat; spawned:Nat; disbursed:Nat; neuronsSpawned:Nat };
    nodeCount       : Nat;
    phi             : Float;
    valueExplainer  : Text;
  } {
    var active : Nat = 0;
    var totalStake : Nat = 0;
    var totalVP : Float = 0.0;
    var groupAs : (Nat, Float) = (0, 0.0); var groupBs : (Nat, Float) = (0, 0.0);
    var groupCs : (Nat, Float) = (0, 0.0); var groupDs : (Nat, Float) = (0, 0.0);
    var groupEs : (Nat, Float) = (0, 0.0);
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronStatuses[i] == "ACTIVE") {
        active += 1;
        totalStake += neuronStakes[i];
        totalVP    += neuronVotingPower[i];
        if      (neuronGroups[i] == "A_SOVEREIGNTY") { groupAs := (groupAs.0 + 1, groupAs.1 + neuronVotingPower[i]) }
        else if (neuronGroups[i] == "B_COMPOUNDING") { groupBs := (groupBs.0 + 1, groupBs.1 + neuronVotingPower[i]) }
        else if (neuronGroups[i] == "C_HARVEST")     { groupCs := (groupCs.0 + 1, groupCs.1 + neuronVotingPower[i]) }
        else if (neuronGroups[i] == "D_LIQUID")      { groupDs := (groupDs.0 + 1, groupDs.1 + neuronVotingPower[i]) }
        else if (neuronGroups[i] == "E_PHANTOM")     { groupEs := (groupEs.0 + 1, groupEs.1 + neuronVotingPower[i]) };
      };
      i += 1;
    };
    {
      totalNeurons   = neuronCount;
      activeNeurons  = active;
      totalStakeE8s  = totalStake;
      totalStakeICP  = Float.fromInt(totalStake) / 100_000_000.0;
      totalVP;
      groupBreakdown = [
        { group = "A_SOVEREIGNTY"; count = groupAs.0; totalVP = groupAs.1; policy = "STAKE_MATURITY (8yr dissolve, max VP, sovereign follow)" },
        { group = "B_COMPOUNDING"; count = groupBs.0; totalVP = groupBs.1; policy = "STAKE_MATURITY (5yr dissolve, compounds forever)" },
        { group = "C_HARVEST";     count = groupCs.0; totalVP = groupCs.1; policy = "SPAWN_NEURON (3yr dissolve, grows fleet)" },
        { group = "D_LIQUID";      count = groupDs.0; totalVP = groupDs.1; policy = "DISBURSE (1.5yr dissolve, feeds ONESICAN treasury)" },
        { group = "E_PHANTOM";     count = groupEs.0; totalVP = groupEs.1; policy = "STAKE_MATURITY (8yr dissolve, PHANTOM substrate governance)" },
      ];
      maturityStats  = {
        accrued        = totalMaturityAccrued;
        staked         = totalMaturityStaked;
        spawned        = totalMaturitySpawned;
        disbursed      = totalMaturityDisbursed;
        neuronsSpawned = totalNeuronsSpawned;
      };
      nodeCount  = nodeCount;
      phi        = PHI;
      valueExplainer = "1 ICP → staked → NNS → ~12% APY maturity/yr. Group C spawns new neurons. Group D converts maturity to ICP→ONESICAN. ONESICAN on PHANTOM = φ³ × raw cycle value (4.236×). We own the vein.";
    }
  };

  public query func getNeuron(id : Nat) : async ?{
    neuronId     : Nat;
    nnsId        : Nat;
    group        : Text;
    stakeE8s     : Nat;
    stakeICP     : Float;
    dissolveYears: Float;
    ageYears     : Float;
    votingPower  : Float;
    maturityE8s  : Nat;
    totalHarvest : Nat;
    policy       : Text;
    status       : Text;
    substrate    : Text;
    nodeBinding  : Nat;
    voteCount    : Nat;
    lastVoted    : Int;
  } {
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (neuronIds[i] == id) {
        return ?{
          neuronId      = neuronIds[i];
          nnsId         = neuronNnsIds[i];
          group         = neuronGroups[i];
          stakeE8s      = neuronStakes[i];
          stakeICP      = Float.fromInt(neuronStakes[i]) / 100_000_000.0;
          dissolveYears = neuronDissolveYears[i];
          ageYears      = neuronAgeYears[i];
          votingPower   = neuronVotingPower[i];
          maturityE8s   = neuronMaturity[i];
          totalHarvest  = neuronTotalHarvest[i];
          policy        = neuronPolicies[i];
          status        = neuronStatuses[i];
          substrate     = neuronSubstrates[i];
          nodeBinding   = neuronNodeBindings[i];
          voteCount     = neuronVoteCount[i];
          lastVoted     = neuronLastVoted[i];
        }
      };
      i += 1;
    };
    null
  };

  public query func listNeurons(group : Text) : async [{
    neuronId : Nat; nnsId : Nat; group : Text; stakeICP : Float; votingPower : Float; policy : Text; status : Text;
  }] {
    var result : [{ neuronId:Nat; nnsId:Nat; group:Text; stakeICP:Float; votingPower:Float; policy:Text; status:Text }] = [];
    var i = 0;
    while (i < neuronCount and i < NEURON_CAP) {
      if (group == "ALL" or neuronGroups[i] == group) {
        result := Array.append(result, [{
          neuronId = neuronIds[i]; nnsId = neuronNnsIds[i]; group = neuronGroups[i];
          stakeICP = Float.fromInt(neuronStakes[i]) / 100_000_000.0;
          votingPower = neuronVotingPower[i]; policy = neuronPolicies[i]; status = neuronStatuses[i];
        }]);
      };
      i += 1;
    };
    result
  };

  public query func listNodes() : async [{
    nodeId : Nat; name : Text; substrate : Text; status : Text; health : Float; gpus : Nat; neuron1 : Nat; neuron2 : Nat;
  }] {
    Array.tabulate<{ nodeId:Nat; name:Text; substrate:Text; status:Text; health:Float; gpus:Nat; neuron1:Nat; neuron2:Nat }>(nodeCount, func(i) {
      { nodeId = nodeIds[i]; name = nodeNames[i]; substrate = nodeSubstrates[i]; status = nodeStatuses[i]; health = nodeHealths[i]; gpus = nodeGpuCount[i]; neuron1 = nodeNeuron1[i]; neuron2 = nodeNeuron2[i] }
    })
  };

  // ICP cycles value explainer
  public query func getCyclesPremiumReport() : async {
    rawCyclesPerICP   : Text;
    onesicansPerICP   : Float;
    icpMultiplier     : Float;
    edgeMultiplier    : Float;
    cloudMultiplier   : Float;
    phantomMultiplier : Float;
    premiumExplainer  : Text;
  } {
    {
      rawCyclesPerICP   = "~10T cycles per ICP (XDR-pegged; varies with ICP price)";
      onesicansPerICP   = 1.0;        // 1 ONESICAN costs 1 ICP-equivalent at parity
      icpMultiplier     = 1.0;
      edgeMultiplier    = PHI;
      cloudMultiplier   = PHI * PHI;
      phantomMultiplier = PHI * PHI * PHI;
      premiumExplainer  =
        "Raw ICP cycles = XDR-denominated compute. 1 ICP = 10T raw cycles (at current price). " #
        "ONESICAN PHANTOM = φ³ premium = 4.236× raw cycle value. " #
        "Selling on PHANTOM substrate: 1 ONESICAN ≈ 42.36T raw-cycle-equivalent. " #
        "We don't USE ICP cycles as a mask — we SELL compute access at sovereign premium. " #
        "We own the vein: every ONESICAN sold enriches the NOVA treasury + governance pool.";
    }
  };

};
