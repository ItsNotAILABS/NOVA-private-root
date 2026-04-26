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
// AI DIVISION MANAGER — Autonomous Node + Neuron Release Scheduler
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// THE AI DIVISION MANAGER IS THE OPERATING SYSTEM OF THE CIVILIZATION.
// It doesn't wait for commands. It loops, it decides, it releases,
// it routes, it circulates. Everything is on and running.
//
// ── WHAT IT DOES ─────────────────────────────────────────────────────────────
// It is a sovereign AI that manages:
//
//   NEURON RELEASE SCHEDULER
//     • Decides WHEN to spawn new neurons from Group C maturity
//     • Decides WHEN to disburse Group D maturity to ONESICAN treasury
//     • Tracks 200 neurons, fires harvest commands when maturity threshold crossed
//     • Fibonacci-scheduled: harvest attempts at F(n) day intervals
//
//   NODE MANAGER
//     • 100 field nodes. Each node runs AI organisms.
//     • Monitors health signals. Routes compute to healthy nodes.
//     • When node degrades: redistributes load to PHANTOM substrate.
//
//   ORGANISM-TO-NEURON BINDER
//     • Every Alpha Organism (CHRYSALIS/SCRIBE/ARCHITECT/NEXUS) has
//       a "governance weight" — how much VP they contribute to proposals.
//     • AI_DIVISION assigns a governance seat to each organism.
//     • Organisms can "propose" governance actions through the AI Division.
//
//   REWARD CIRCULATOR
//     • ICP rewards flow: NNS maturity → ICP → TOKEN_FORGE (ONESICAN mint)
//     • ONESICAN flows: TOKEN_FORGE → ORGANISM_TOKEN (organism sub-tokens)
//     • Sub-tokens flow: ORGANISM_TOKEN → staker rewards, community pool
//     • AI_DIVISION routes every token event through this circuit.
//
//   PRODUCTION LOOP
//     • Every call to productionTick() advances the loop:
//       1. Check neuron maturity thresholds
//       2. Execute maturity policies (stake/spawn/disburse)
//       3. Check node health signals
//       4. Redistribute degraded node load
//       5. Update organism governance weights
//       6. Emit intelligence actions (for TOKEN_INTELLIGENCE)
//     • Loop counter increments on every tick.
//     • Fully autonomous — no human input required per tick.
//
//   INTELLIGENCE ASSIGNMENT
//     • Each division is assigned one of 5 AI intelligences:
//       CHRYSALIS (math/strategy), SCRIBE (data/records), ARCHITECT (build),
//       NEXUS (routing), SWARM_BRAIN (meta-coordination)
//     • Intelligence handles all decisions for its domain.
//
// ── ORGANISM GOVERNANCE SEATS ─────────────────────────────────────────────────
// Organisms participate in governance through AI_DIVISION:
//   CHRYSALIS → ECONOMIC_TOPICS (Fibonacci emission decisions)
//   SCRIBE    → DATA_TOPICS (protocol data proposals)
//   ARCHITECT → BUILD_TOPICS (canister upgrade proposals)
//   NEXUS     → ROUTING_TOPICS (substrate/node management)
//
// ── PRODUCTION LOOP ARCHITECTURE ─────────────────────────────────────────────
// tick N → check maturity → execute policies → check nodes → update weights →
//   emit actions → increment tick → wait → tick N+1 → ...
//
// This is always on. Always running. Everything loops.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor AiDivision {

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
    if (genesisLocked) return "AI_DIVISION_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-AI-DIVISION-BUILD30-" # Principal.toText(msg.caller);
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

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp == 0.0) 1.0 else 0.0 }
    else Float.exp(exp * Float.log(base))
  };

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fib(n : Nat) : Nat {
    if (n == 0) return 0; if (n == 1) return 1;
    var a : Nat = 0; var b : Nat = 1; var i : Nat = 2;
    while (i <= n) { let c = a + b; a := b; b := c; i += 1 };
    b
  };

  let NS_PER_DAY : Int = 86_400_000_000_000;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — PRODUCTION LOOP STATE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var loopTick        : Nat  = 0;
  stable var loopLastTick    : Int  = 0;
  stable var loopStarted     : Bool = false;
  stable var loopStartedAt   : Int  = 0;
  stable var totalActionsEmit: Nat  = 0;
  stable var totalCirculated : Nat  = 0;  // ONESICANS circulated through loop

  // Production tick — advances the loop. Sovereign or timer calls this.
  public shared(msg) func productionTick() : async {
    tick           : Nat;
    actionsEmitted : Nat;
    neuronChecks   : Nat;
    nodeChecks     : Nat;
    rewardCirc     : Nat;
    intelligenceUsed: Text;
    nextTickDays   : Nat;
    status         : Text;
  } {
    if (not isSovereign(msg.caller)) return {
      tick = loopTick; actionsEmitted = 0; neuronChecks = 0; nodeChecks = 0;
      rewardCirc = 0; intelligenceUsed = "UNAUTHORIZED"; nextTickDays = 0; status = "UNAUTHORIZED"
    };
    if (not loopStarted) {
      loopStarted   := true;
      loopStartedAt := Time.now();
    };
    loopTick     := loopTick + 1;
    loopLastTick := Time.now();

    let tickFib = _fib(Nat.rem(loopTick, 12) + 1);  // Fibonacci-indexed intelligence
    let intelligences : [Text] = ["CHRYSALIS","SCRIBE","ARCHITECT","NEXUS","SWARM_BRAIN","TOKEN_INTELLIGENCE","CHRYSALIS","SCRIBE","ARCHITECT","NEXUS","SWARM_BRAIN","TOKEN_INTELLIGENCE"];
    let intel = intelligences[Nat.rem(loopTick, 12)];

    // Phase 1: Emit neuron check actions
    let neuronChecks = _tickNeuronChecks();
    // Phase 2: Check node health
    let nodeChecks = _tickNodeChecks();
    // Phase 3: Circulate rewards
    let circulated = _tickRewardCirculation();
    totalCirculated    := totalCirculated + circulated;
    // Phase 4: Emit loop action
    let loopActionsStart = divisionActionCount;
    _emitAction("PRODUCTION_LOOP_TICK",
      "{\"tick\":" # Nat.toText(loopTick) # ",\"intelligence\":\"" # intel # "\",\"fib\":" # Nat.toText(tickFib) # "}",
      1.0, "Autonomous production loop tick " # Nat.toText(loopTick) # " — intelligence: " # intel);
    let emitted = divisionActionCount - loopActionsStart + neuronChecks + nodeChecks;
    totalActionsEmit := totalActionsEmit + emitted;

    { tick = loopTick; actionsEmitted = emitted; neuronChecks; nodeChecks;
      rewardCirc = circulated; intelligenceUsed = intel; nextTickDays = tickFib; status = "RUNNING" }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — DIVISION ACTION SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════

  let ACTION_CAP : Nat = 4096;

  stable var divisionActionCount : Nat = 0;
  stable var divActionIds        : [var Nat]   = Array.init<Nat>(ACTION_CAP,   0);
  stable var divActionKinds      : [var Text]  = Array.init<Text>(ACTION_CAP,  "");
  stable var divActionParams     : [var Text]  = Array.init<Text>(ACTION_CAP,  "");
  stable var divActionScores     : [var Float] = Array.init<Float>(ACTION_CAP, 0.0);
  stable var divActionStatuses   : [var Text]  = Array.init<Text>(ACTION_CAP,  "READY");
  stable var divActionTimes      : [var Int]   = Array.init<Int>(ACTION_CAP,   0);
  stable var divActionReasons    : [var Text]  = Array.init<Text>(ACTION_CAP,  "");
  stable var nextDivActionId     : Nat         = 1;

  func _emitAction(kind : Text, params : Text, score : Float, reason : Text) {
    if (divisionActionCount >= ACTION_CAP) return;
    let i = divisionActionCount;
    divActionIds[i]      := nextDivActionId;
    divActionKinds[i]    := kind;
    divActionParams[i]   := params;
    divActionScores[i]   := score;
    divActionStatuses[i] := "READY";
    divActionTimes[i]    := Time.now();
    divActionReasons[i]  := reason;
    divisionActionCount  := divisionActionCount + 1;
    nextDivActionId      := nextDivActionId + 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — NEURON RELEASE SCHEDULER
  // ═══════════════════════════════════════════════════════════════════════════

  let NEURON_SCHED_CAP : Nat = 512;

  stable var schedCount       : Nat = 0;
  stable var schedNeuronIds   : [var Nat]   = Array.init<Nat>(NEURON_SCHED_CAP,   0);
  stable var schedPolicies    : [var Text]  = Array.init<Text>(NEURON_SCHED_CAP,  "");
  stable var schedMaturityE8s : [var Nat]   = Array.init<Nat>(NEURON_SCHED_CAP,   0);
  stable var schedFibGates    : [var Nat]   = Array.init<Nat>(NEURON_SCHED_CAP,   0);
  // fibGate N: execute only if loopTick mod F(N) == 0
  stable var schedLastExec    : [var Int]   = Array.init<Int>(NEURON_SCHED_CAP,   0);
  stable var schedExecuteCount: [var Nat]   = Array.init<Nat>(NEURON_SCHED_CAP,   0);
  stable var schedThresholdE8s: [var Nat]   = Array.init<Nat>(NEURON_SCHED_CAP,   0);
  // Threshold: fire when maturity ≥ this amount

  // Register a neuron for scheduled release
  public shared(msg) func scheduleNeuron(
    neuronId    : Nat,
    policy      : Text,
    fibGate     : Nat,     // Fibonacci index (3=2days, 5=5days, 8=21days...)
    thresholdE8s: Nat
  ) : async { success : Bool; schedId : Nat } {
    requireSovereign(msg.caller);
    if (schedCount >= NEURON_SCHED_CAP) return { success = false; schedId = 0 };
    let si = schedCount;
    schedNeuronIds[si]    := neuronId;
    schedPolicies[si]     := policy;
    schedMaturityE8s[si]  := 0;
    schedFibGates[si]     := fibGate;
    schedLastExec[si]     := 0;
    schedExecuteCount[si] := 0;
    schedThresholdE8s[si] := thresholdE8s;
    schedCount            := schedCount + 1;
    { success = true; schedId = si }
  };

  // Bootstrap all 200 neurons onto default schedules
  public shared(msg) func bootstrapSchedules() : async { registered : Nat } {
    requireSovereign(msg.caller);
    // Group A (8): check every F(5)=5 days, 1M e8s threshold, STAKE_MATURITY
    // Group B (34): check every F(5)=5 days, 500K e8s, STAKE_MATURITY
    // Group C (89): check every F(4)=3 days, 100K e8s, SPAWN_NEURON
    // Group D (55): check every F(3)=2 days, 50K e8s, DISBURSE
    // Group E (14): check every F(6)=8 days, 1M e8s, STAKE_MATURITY
    let groups : [(Nat, Text, Nat, Nat)] = [
      (8,  "STAKE_MATURITY", 5, 100_000_000),   // 1 ICP threshold
      (34, "STAKE_MATURITY", 5, 50_000_000),    // 0.5 ICP
      (89, "SPAWN_NEURON",   4, 10_000_000),    // 0.1 ICP
      (55, "DISBURSE",       3, 5_000_000),     // 0.05 ICP
      (14, "STAKE_MATURITY", 6, 100_000_000),   // 1 ICP
    ];
    var reg : Nat = 0;
    var neuronOffset : Nat = 1;
    var gi = 0;
    while (gi < groups.size()) {
      let (size, policy, fibGate, thresh) = groups[gi];
      var j = 0;
      while (j < size and schedCount < NEURON_SCHED_CAP) {
        let si = schedCount;
        schedNeuronIds[si]    := neuronOffset + j;
        schedPolicies[si]     := policy;
        schedMaturityE8s[si]  := 0;
        schedFibGates[si]     := fibGate;
        schedLastExec[si]     := 0;
        schedExecuteCount[si] := 0;
        schedThresholdE8s[si] := thresh;
        schedCount            := schedCount + 1;
        reg                   += 1;
        j                     += 1;
      };
      neuronOffset := neuronOffset + size;
      gi           += 1;
    };
    { registered = reg }
  };

  // Internal: check neurons this tick
  func _tickNeuronChecks() : Nat {
    var checks : Nat = 0;
    var i = 0;
    while (i < schedCount and i < NEURON_SCHED_CAP) {
      let gate   = _fib(schedFibGates[i]);
      let fire   = gate > 0 and Nat.rem(loopTick, gate) == 0;
      if (fire and schedMaturityE8s[i] >= schedThresholdE8s[i] and schedMaturityE8s[i] > 0) {
        _emitAction("NEURON_HARVEST",
          "{\"neuronId\":" # Nat.toText(schedNeuronIds[i]) # ",\"policy\":\"" # schedPolicies[i] # "\",\"maturity\":" # Nat.toText(schedMaturityE8s[i]) # "}",
          0.9, "Scheduled harvest: neuron " # Nat.toText(schedNeuronIds[i]) # " → " # schedPolicies[i]);
        schedLastExec[i]    := Time.now();
        schedExecuteCount[i]:= schedExecuteCount[i] + 1;
        schedMaturityE8s[i] := 0;  // reset after harvest
        checks              += 1;
      };
      i += 1;
    };
    checks
  };

  // Feed maturity data into scheduler (from neuron_fleet reporting)
  public shared(msg) func feedNeuronMaturity(neuronId : Nat, maturityE8s : Nat) : async Bool {
    var i = 0;
    while (i < schedCount and i < NEURON_SCHED_CAP) {
      if (schedNeuronIds[i] == neuronId) {
        schedMaturityE8s[i] := schedMaturityE8s[i] + maturityE8s;
        return true
      };
      i += 1;
    };
    false
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — NODE HEALTH MONITOR
  // ═══════════════════════════════════════════════════════════════════════════

  let NODE_HEALTH_CAP : Nat = 128;

  stable var nodeHealthCount    : Nat = 0;
  stable var nhNodeIds          : [var Nat]   = Array.init<Nat>(NODE_HEALTH_CAP,   0);
  stable var nhHealthScores     : [var Float] = Array.init<Float>(NODE_HEALTH_CAP, 1.0);
  stable var nhSubstrates       : [var Text]  = Array.init<Text>(NODE_HEALTH_CAP,  "ICP");
  stable var nhStatuses         : [var Text]  = Array.init<Text>(NODE_HEALTH_CAP,  "ACTIVE");
  stable var nhLastChecked      : [var Int]   = Array.init<Int>(NODE_HEALTH_CAP,   0);
  stable var nhMissedChecks     : [var Nat]   = Array.init<Nat>(NODE_HEALTH_CAP,   0);
  stable var nhRouted           : [var Nat]   = Array.init<Nat>(NODE_HEALTH_CAP,   0);  // workloads routed away

  // Register a node for health monitoring
  public shared(msg) func registerNodeHealth(nodeId : Nat, substrate : Text) : async Bool {
    if (nodeHealthCount >= NODE_HEALTH_CAP) return false;
    let ni = nodeHealthCount;
    nhNodeIds[ni]      := nodeId;
    nhHealthScores[ni] := 1.0;
    nhSubstrates[ni]   := substrate;
    nhStatuses[ni]     := "ACTIVE";
    nhLastChecked[ni]  := Time.now();
    nhMissedChecks[ni] := 0;
    nhRouted[ni]       := 0;
    nodeHealthCount    := nodeHealthCount + 1;
    true
  };

  // Report health from a node
  public shared(msg) func reportNodeHealth(nodeId : Nat, health : Float) : async Bool {
    var i = 0;
    while (i < nodeHealthCount and i < NODE_HEALTH_CAP) {
      if (nhNodeIds[i] == nodeId) {
        nhHealthScores[i] := _clamp(health, 0.0, 1.0);
        nhLastChecked[i]  := Time.now();
        nhMissedChecks[i] := 0;
        if (health < _pow(PHI_INV, 3.0)) {
          nhStatuses[i] := "DEGRADED";
          _emitAction("NODE_DEGRADE",
            "{\"nodeId\":" # Nat.toText(nodeId) # ",\"health\":" # Float.toText(health) # ",\"substrate\":\"" # nhSubstrates[i] # "\"}",
            0.95, "Node " # Nat.toText(nodeId) # " health " # Float.toText(health) # " < φ⁻³ — reroute load to PHANTOM");
        } else {
          nhStatuses[i] := "ACTIVE";
        };
        return true
      };
      i += 1;
    };
    false
  };

  func _tickNodeChecks() : Nat {
    var checks : Nat = 0;
    var i = 0;
    while (i < nodeHealthCount and i < NODE_HEALTH_CAP) {
      let elapsed = Time.now() - nhLastChecked[i];
      if (elapsed > Int.abs(NS_PER_DAY) and nhStatuses[i] == "ACTIVE") {
        nhMissedChecks[i] := nhMissedChecks[i] + 1;
        if (nhMissedChecks[i] >= 2) {
          nhStatuses[i] := "DEGRADED";
          _emitAction("NODE_MISSED_CHECK",
            "{\"nodeId\":" # Nat.toText(nhNodeIds[i]) # ",\"missed\":" # Nat.toText(nhMissedChecks[i]) # "}",
            0.8, "Node " # Nat.toText(nhNodeIds[i]) # " missed " # Nat.toText(nhMissedChecks[i]) # " health checks");
        };
        checks += 1;
      };
      i += 1;
    };
    checks
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — ORGANISM GOVERNANCE SEATS
  // ═══════════════════════════════════════════════════════════════════════════

  let ORG_SEAT_CAP : Nat = 64;

  stable var orgSeatCount      : Nat = 0;
  stable var orgNames          : [var Text]  = Array.init<Text>(ORG_SEAT_CAP,  "");
  stable var orgCanisterIds    : [var Text]  = Array.init<Text>(ORG_SEAT_CAP,  "");
  stable var orgTopics         : [var Text]  = Array.init<Text>(ORG_SEAT_CAP,  "");
  stable var orgGovWeights     : [var Float] = Array.init<Float>(ORG_SEAT_CAP, 0.0);
  stable var orgIntelligences  : [var Text]  = Array.init<Text>(ORG_SEAT_CAP,  "");
  stable var orgProposalCount  : [var Nat]   = Array.init<Nat>(ORG_SEAT_CAP,   0);
  stable var orgVoteCount      : [var Nat]   = Array.init<Nat>(ORG_SEAT_CAP,   0);

  // Bootstrap standard organism governance seats
  public shared(msg) func bootstrapOrganismSeats() : async [{ name:Text; topic:Text; weight:Float }] {
    requireSovereign(msg.caller);
    let orgs : [(Text, Text, Text, Float, Text)] = [
      ("CHRYSALIS", "", "ECONOMIC_TOPICS",  _pow(PHI_INV, 1.0), "CHRYSALIS"),
      ("SCRIBE",    "", "DATA_TOPICS",      _pow(PHI_INV, 2.0), "SCRIBE"),
      ("ARCHITECT", "", "BUILD_TOPICS",     _pow(PHI_INV, 3.0), "ARCHITECT"),
      ("NEXUS",     "", "ROUTING_TOPICS",   _pow(PHI_INV, 4.0), "NEXUS"),
      ("SWARM_BRAIN","","META_TOPICS",      _pow(PHI_INV, 5.0), "SWARM_BRAIN"),
    ];
    var result : [{ name:Text; topic:Text; weight:Float }] = [];
    var i = 0;
    while (i < orgs.size() and orgSeatCount < ORG_SEAT_CAP) {
      let (name, canId, topic, weight, intel) = orgs[i];
      let si = orgSeatCount;
      orgNames[si]         := name;
      orgCanisterIds[si]   := canId;
      orgTopics[si]        := topic;
      orgGovWeights[si]    := weight;
      orgIntelligences[si] := intel;
      orgProposalCount[si] := 0;
      orgVoteCount[si]     := 0;
      orgSeatCount         := orgSeatCount + 1;
      result := Array.append(result, [{ name; topic; weight }]);
      i += 1;
    };
    result
  };

  // Organism submits a governance proposal through AI_DIVISION
  public shared(msg) func submitOrganismProposal(
    organism : Text,
    topic    : Text,
    proposal : Text
  ) : async { success : Bool; actionId : Nat; weight : Float } {
    var weight : Float = 0.0;
    var i = 0;
    while (i < orgSeatCount and i < ORG_SEAT_CAP) {
      if (orgNames[i] == organism) {
        weight              := orgGovWeights[i];
        orgProposalCount[i] := orgProposalCount[i] + 1;
        i := orgSeatCount;  // break
      };
      i += 1;
    };
    if (weight <= 0.0) return { success = false; actionId = 0; weight = 0.0 };
    let start = divisionActionCount;
    _emitAction("ORGANISM_PROPOSAL",
      "{\"organism\":\"" # organism # "\",\"topic\":\"" # topic # "\",\"weight\":" # Float.toText(weight) # ",\"proposal\":\"" # proposal # "\"}",
      weight, organism # " proposes on " # topic # ": " # proposal);
    { success = true; actionId = nextDivActionId - 1; weight }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — REWARD CIRCULATION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  // Revenue flow: NNS maturity → ICP → ONESICAN mint → organism sub-tokens
  // → staker rewards → community pool → back to governance staking

  let CIRCL_CAP : Nat = 4096;

  stable var circlCount   : Nat = 0;
  stable var circlFroms   : [var Text] = Array.init<Text>(CIRCL_CAP, "");
  stable var circlTos     : [var Text] = Array.init<Text>(CIRCL_CAP, "");
  stable var circlAmounts : [var Nat]  = Array.init<Nat>(CIRCL_CAP,  0);
  stable var circlKinds   : [var Text] = Array.init<Text>(CIRCL_CAP, "");
  // Kinds: MATURITY_TO_ICP | ICP_TO_ONESICAN | ONESICAN_TO_ORGANISM | ORGANISM_TO_STAKER | STAKER_TO_GOVERNANCE
  stable var circlTimes   : [var Int]  = Array.init<Int>(CIRCL_CAP,  0);
  stable var circlTotalRouted : Nat = 0;

  // Record a circulation event
  public shared(msg) func recordCirculation(
    from   : Text,
    to     : Text,
    amount : Nat,
    kind   : Text
  ) : async { success : Bool; circlId : Nat } {
    if (circlCount >= CIRCL_CAP) return { success = false; circlId = 0 };
    let ci = circlCount;
    circlFroms[ci]   := from;
    circlTos[ci]     := to;
    circlAmounts[ci] := amount;
    circlKinds[ci]   := kind;
    circlTimes[ci]   := Time.now();
    circlCount       := circlCount + 1;
    circlTotalRouted := circlTotalRouted + amount;
    { success = true; circlId = ci }
  };

  func _tickRewardCirculation() : Nat {
    // Simulate circulation: every 5 ticks, emit a circulation-check action
    if (Nat.rem(loopTick, 5) != 0) return 0;
    _emitAction("CIRCULATE_REWARDS",
      "{\"tick\":" # Nat.toText(loopTick) # ",\"totalCirculated\":" # Nat.toText(circlTotalRouted) # "}",
      0.7, "Reward circulation check: route maturity ICP→ONESICAN→organisms→stakers→governance");
    1
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — INTELLIGENCE ASSIGNMENT REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════

  let INTEL_CAP : Nat = 64;

  stable var intelCount     : Nat = 0;
  stable var intelDivisions : [var Text] = Array.init<Text>(INTEL_CAP, "");
  stable var intelHandlers  : [var Text] = Array.init<Text>(INTEL_CAP, "");
  stable var intelDomains   : [var Text] = Array.init<Text>(INTEL_CAP, "");
  stable var intelTicksSeen : [var Nat]  = Array.init<Nat>(INTEL_CAP,  0);
  stable var intelActionsEmit:[var Nat]  = Array.init<Nat>(INTEL_CAP,  0);

  public shared(msg) func assignIntelligence(division : Text, handler : Text, domain : Text) : async Bool {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < intelCount and i < INTEL_CAP) {
      if (intelDivisions[i] == division) {
        intelHandlers[i] := handler;
        intelDomains[i]  := domain;
        return true
      };
      i += 1;
    };
    if (intelCount >= INTEL_CAP) return false;
    let ii = intelCount;
    intelDivisions[ii] := division;
    intelHandlers[ii]  := handler;
    intelDomains[ii]   := domain;
    intelTicksSeen[ii] := 0;
    intelActionsEmit[ii] := 0;
    intelCount         := intelCount + 1;
    true
  };

  // Bootstrap all intelligence assignments
  public shared(msg) func bootstrapIntelligenceAssignments() : async Nat {
    requireSovereign(msg.caller);
    let assignments : [(Text, Text, Text)] = [
      ("PARALLAX",          "TOKEN_INTELLIGENCE", "TREASURY_OPS"),
      ("TOKEN_FORGE",       "TOKEN_INTELLIGENCE", "EMISSION_CONTROL"),
      ("AIRDROP_ENGINE",    "TOKEN_INTELLIGENCE", "AIRDROP_WAVES"),
      ("CYCLES_MARKET",     "TOKEN_INTELLIGENCE", "MARKET_DYNAMICS"),
      ("NOVA_GOVERNANCE",   "CHRYSALIS",          "GOVERNANCE_STRATEGY"),
      ("NOVA_SNS",          "SCRIBE",             "SNS_DATA"),
      ("NEURON_FLEET",      "SWARM_BRAIN",         "NEURON_COORDINATION"),
      ("AI_DIVISION",       "SWARM_BRAIN",         "DIVISION_META"),
      ("ORGANISM_TOKEN",    "CHRYSALIS",          "TOKEN_ECONOMICS"),
      ("CYCLES_BRIDGE",     "NEXUS",              "SUBSTRATE_ROUTING"),
      ("SWARM_BRAIN",       "CHRYSALIS",          "COGNITIVE_CORE"),
      ("SWARM_ORGANISM",    "SWARM_BRAIN",         "ORGANISM_OPS"),
      ("CHRYSALIS",         "CHRYSALIS",          "GOLDEN_MATH"),
      ("SCRIBE",            "SCRIBE",             "DOCUMENT_INTEL"),
      ("ARCHITECT",         "ARCHITECT",          "BUILD_INTEL"),
      ("NEXUS_PROPAGATOR",  "NEXUS",              "ROUTING_INTEL"),
      ("SOVEREIGN_FACTORY", "SWARM_BRAIN",         "FACTORY_OPS"),
      ("TOKEN_INTELLIGENCE","CHRYSALIS",          "SIGNAL_PROCESSING"),
    ];
    var registered : Nat = 0;
    var i = 0;
    while (i < assignments.size() and intelCount < INTEL_CAP) {
      let (div, handler, domain) = assignments[i];
      let ii = intelCount;
      intelDivisions[ii]   := div;
      intelHandlers[ii]    := handler;
      intelDomains[ii]     := domain;
      intelTicksSeen[ii]   := 0;
      intelActionsEmit[ii] := 0;
      intelCount           := intelCount + 1;
      registered           += 1;
      i                    += 1;
    };
    registered
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 — QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getReadyActions(limit : Nat) : async [{
    id : Nat; kind : Text; params : Text; score : Float; reason : Text; createdAt : Int;
  }] {
    var result : [{ id:Nat; kind:Text; params:Text; score:Float; reason:Text; createdAt:Int }] = [];
    var i = 0;
    while (i < divisionActionCount and i < ACTION_CAP and result.size() < limit) {
      if (divActionStatuses[i] == "READY") {
        result := Array.append(result, [{
          id = divActionIds[i]; kind = divActionKinds[i]; params = divActionParams[i];
          score = divActionScores[i]; reason = divActionReasons[i]; createdAt = divActionTimes[i];
        }]);
      };
      i += 1;
    };
    result
  };

  public query func getLoopStatus() : async {
    tick             : Nat;
    started          : Bool;
    startedAt        : Int;
    lastTick         : Int;
    totalActionsEmit : Nat;
    totalCirculated  : Nat;
    scheduledNeurons : Nat;
    monitoredNodes   : Nat;
    organismSeats    : Nat;
    intelAssignments : Nat;
    phi              : Float;
    status           : Text;
  } {
    {
      tick             = loopTick;
      started          = loopStarted;
      startedAt        = loopStartedAt;
      lastTick         = loopLastTick;
      totalActionsEmit = totalActionsEmit;
      totalCirculated  = totalCirculated;
      scheduledNeurons = schedCount;
      monitoredNodes   = nodeHealthCount;
      organismSeats    = orgSeatCount;
      intelAssignments = intelCount;
      phi              = PHI;
      status           = if (loopStarted) "RUNNING" else "STANDBY";
    }
  };

  public query func getIntelligenceRegistry() : async [{
    division : Text; handler : Text; domain : Text; ticksSeen : Nat; actionsEmit : Nat;
  }] {
    Array.tabulate<{ division:Text; handler:Text; domain:Text; ticksSeen:Nat; actionsEmit:Nat }>(intelCount, func(i) {
      { division = intelDivisions[i]; handler = intelHandlers[i]; domain = intelDomains[i]; ticksSeen = intelTicksSeen[i]; actionsEmit = intelActionsEmit[i] }
    })
  };

  public query func getCirculationStats() : async {
    totalEvents      : Nat;
    totalRouted      : Nat;
    lastCirculation  : Int;
    recentEvents     : [{ from:Text; to:Text; amount:Nat; kind:Text; time:Int }];
  } {
    let recent = if (circlCount <= 10) circlCount else 10;
    let recentEvts = Array.tabulate<{ from:Text; to:Text; amount:Nat; kind:Text; time:Int }>(recent, func(j) {
      let i = if (circlCount > recent) circlCount - recent + j else j;
      { from = circlFroms[i]; to = circlTos[i]; amount = circlAmounts[i]; kind = circlKinds[i]; time = circlTimes[i] }
    });
    {
      totalEvents     = circlCount;
      totalRouted     = circlTotalRouted;
      lastCirculation = if (circlCount > 0) circlTimes[circlCount - 1] else 0;
      recentEvents    = recentEvts;
    }
  };

};
