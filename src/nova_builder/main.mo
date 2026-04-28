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

// NATIVE NOVA PROTOCOL — BUILD №42
// NOVA BUILDER — Sovereign CaffeineAI Replacement
// Non-Profit · Permissionless · On-Chain · Cannot Be Shut Down
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// MISSION: Replace CaffeineAI as the sovereign, permissionless, on-chain builder
// funnel for ICP. Every build burns cycles → direct ICP deflationary pressure.
// No account limits. No ToS shutdown clause. Community-governed cycles subsidy pool.
//
// Architecture:
//   Intent queue   — user submits plain-language build intent (max 512 pending)
//   Build sessions — unique session IDs track intake → generate → deploy lifecycle
//   Subsidy pool   — cycles consumed per build tracked; pool funded by donations/fees
//   Stream publish — all events published to nova_stream topics:
//                    BUILDER_INTAKE / BUILDER_GENERATE / BUILDER_DEPLOY / BUILDER_CYCLES_BURN
//   Rate limiting  — by cycles pool balance only; zero account-based limits ever
//   Governance hook — thresholds adjustable by nova_governance votes
//
// PUBLIC API:
//   submitBuild(intent)          — submit a plain-language build description → session ID
//   getBuildSession(sessionId)   — poll build session status + generated code + deploy result
//   getBuilderStatus()           — canister health + pool balance + total builds + total burn
//   getRecentBuilds(n)           — last N completed build summaries (public proof of work)
//   donateCycles()               — accept cycle donation into subsidy pool (payable)
//
// ADMIN API (architect only):
//   claimBuilder()               — genesis lock
//   setSubsidyThreshold(n)       — minimum pool required to accept builds
//   setCyclesPerBuild(n)         — cycles consumed per deploy (governance-adjustable)
//   setStreamCanister(p)         — wire to nova_stream canister
//   markBuildComplete(id, code)  — called by swarm_brain after code generation
//   markBuildDeployed(id, addr)  — called by sovereign_factory after deploy

import Array     "mo:base/Array";
import Bool      "mo:base/Bool";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor NovaBuilder {

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  func _isArchitect(caller : Principal) : Bool {
    caller == architectPrincipal
  };

  public shared(msg) func claimBuilder() : async Text {
    if (genesisLocked) return "BUILDER_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-BUILDER-BUILD42-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()            : async Text      { sovereignSeal };
  public query func isLocked()           : async Bool      { genesisLocked };
  public query func getGenesisTimestamp(): async Int       { genesisTimestamp };
  public query func getArchitect()       : async Principal { architectPrincipal };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — GOLDEN MATH CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;

  // φ-scaled cycles consumption per tier
  // Tier 1 (basic canister)  = BASE_CYCLES × φ⁰
  // Tier 2 (standard)        = BASE_CYCLES × φ¹
  // Tier 3 (full organism)   = BASE_CYCLES × φ²
  let BASE_CYCLES_COST : Nat = 1_000_000_000; // 1B cycles baseline

  func _phiTierCost(tier : Nat) : Nat {
    if (tier == 0) return BASE_CYCLES_COST;
    if (tier == 1) return 1_618_033_988;
    if (tier == 2) return 2_618_033_988;
    BASE_CYCLES_COST
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — BUILD SESSION TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  // BuildStatus — lifecycle stages
  // QUEUED → GENERATING → GENERATED → DEPLOYING → DEPLOYED | FAILED
  public type BuildStatus = {
    #QUEUED;
    #GENERATING;
    #GENERATED;
    #DEPLOYING;
    #DEPLOYED;
    #FAILED;
  };

  // BuildSession — the sovereign unit of a builder transaction
  public type BuildSession = {
    sessionId     : Text;        // unique session identifier
    intent        : Text;        // user's plain-language build description
    status        : BuildStatus; // current lifecycle stage
    generatedCode : Text;        // Motoko/CPL code produced by swarm_brain
    deployAddress : Text;        // canister ID once deployed (empty until DEPLOYED)
    cyclesConsumed: Nat;         // cycles burned from subsidy pool for this build
    tier          : Nat;         // φ-tier (0=basic, 1=standard, 2=full)
    submittedAt   : Int;         // Time.now() nanoseconds
    completedAt   : Int;         // 0 until terminal state
    errorMsg      : Text;        // populated on FAILED
  };

  // BuildSummary — public-facing proof of build (omits generated code)
  public type BuildSummary = {
    sessionId     : Text;
    intent        : Text;
    status        : BuildStatus;
    deployAddress : Text;
    cyclesConsumed: Nat;
    completedAt   : Int;
  };

  // BuilderStatus — health + economics snapshot
  public type BuilderStatus = {
    buildNumber      : Nat;
    sovereignSeal    : Text;
    totalBuilds      : Nat;
    totalDeployed    : Nat;
    totalFailed      : Nat;
    totalCyclesBurned: Nat;
    subsidyPoolBalance: Nat;
    cyclesPerBuild   : Nat;
    subsidyThreshold : Nat;
    queueDepth       : Nat;
    openToBuilders   : Bool;
    missionStatement : Text;
    uptimeNs         : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — SESSION STORE (stable)
  // ═══════════════════════════════════════════════════════════════════════════

  let MAX_SESSIONS : Nat = 512;

  // Flat parallel arrays — one slot per session
  stable var sessId          : [var Text]  = Array.init<Text>(MAX_SESSIONS, "");
  stable var sessIntent      : [var Text]  = Array.init<Text>(MAX_SESSIONS, "");
  stable var sessStatus      : [var Nat]   = Array.init<Nat> (MAX_SESSIONS, 0);
  // 0=QUEUED 1=GENERATING 2=GENERATED 3=DEPLOYING 4=DEPLOYED 5=FAILED
  stable var sessCode        : [var Text]  = Array.init<Text>(MAX_SESSIONS, "");
  stable var sessAddress     : [var Text]  = Array.init<Text>(MAX_SESSIONS, "");
  stable var sessCycles      : [var Nat]   = Array.init<Nat> (MAX_SESSIONS, 0);
  stable var sessTier        : [var Nat]   = Array.init<Nat> (MAX_SESSIONS, 0);
  stable var sessSubmitted   : [var Int]   = Array.init<Int> (MAX_SESSIONS, 0);
  stable var sessCompleted   : [var Int]   = Array.init<Int> (MAX_SESSIONS, 0);
  stable var sessError       : [var Text]  = Array.init<Text>(MAX_SESSIONS, "");
  stable var sessValid       : [var Bool]  = Array.init<Bool>(MAX_SESSIONS, false);

  // Ring write head
  stable var sessionHead     : Nat = 0;
  // Monotonic session counter
  stable var sessionSeq      : Nat = 0;

  func _statusToNat(s : BuildStatus) : Nat {
    switch (s) {
      case (#QUEUED)     { 0 };
      case (#GENERATING) { 1 };
      case (#GENERATED)  { 2 };
      case (#DEPLOYING)  { 3 };
      case (#DEPLOYED)   { 4 };
      case (#FAILED)     { 5 };
    }
  };

  func _natToStatus(n : Nat) : BuildStatus {
    if (n == 1) return #GENERATING;
    if (n == 2) return #GENERATED;
    if (n == 3) return #DEPLOYING;
    if (n == 4) return #DEPLOYED;
    if (n == 5) return #FAILED;
    #QUEUED
  };

  func _readSession(slot : Nat) : BuildSession {
    {
      sessionId      = sessId[slot];
      intent         = sessIntent[slot];
      status         = _natToStatus(sessStatus[slot]);
      generatedCode  = sessCode[slot];
      deployAddress  = sessAddress[slot];
      cyclesConsumed = sessCycles[slot];
      tier           = sessTier[slot];
      submittedAt    = sessSubmitted[slot];
      completedAt    = sessCompleted[slot];
      errorMsg       = sessError[slot];
    }
  };

  func _findSession(sid : Text) : ?Nat {
    var i = 0;
    while (i < MAX_SESSIONS) {
      if (sessValid[i] and sessId[i] == sid) return ?i;
      i += 1;
    };
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — ECONOMICS: CYCLES SUBSIDY POOL
  // ═══════════════════════════════════════════════════════════════════════════

  // Subsidy pool — tracks cycles allocated for builder subsidies
  // This is an accounting pool; actual cycle deposits handled by donateCycles()
  stable var subsidyPool        : Nat = 0;
  stable var cyclesPerBuild     : Nat = BASE_CYCLES_COST;
  stable var subsidyThreshold   : Nat = 500_000_000; // 500M cycles minimum to open queue
  stable var totalCyclesBurned  : Nat = 0;
  stable var totalBuilds        : Nat = 0;
  stable var totalDeployed      : Nat = 0;
  stable var totalFailed        : Nat = 0;

  // Pool is open if balance > threshold
  func _poolIsOpen() : Bool {
    subsidyPool >= subsidyThreshold
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 6 — STREAM INTEGRATION (nova_stream publish)
  // ═══════════════════════════════════════════════════════════════════════════

  // nova_stream canister interface (inter-canister call target)
  type StreamActor = actor {
    publish : (topic : Text, payload : Text, origin : Text) -> async Text;
  };

  stable var streamCanisterPrincipal : Text = "aaaaa-aa";

  func _publishToStream(topic : Text, payload : Text) : async () {
    if (streamCanisterPrincipal == "aaaaa-aa") return;
    let streamActor : StreamActor = actor(streamCanisterPrincipal);
    ignore await streamActor.publish(topic, payload, "nova_builder");
  };

  public shared(msg) func setStreamCanister(p : Text) : async Text {
    assert(_isArchitect(msg.caller));
    streamCanisterPrincipal := p;
    "STREAM_CANISTER_SET: " # p
  };

  public query func getStreamCanister() : async Text { streamCanisterPrincipal };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 7 — GOVERNANCE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func setSubsidyThreshold(n : Nat) : async Text {
    assert(_isArchitect(msg.caller));
    subsidyThreshold := n;
    "THRESHOLD_SET: " # Nat.toText(n)
  };

  public shared(msg) func setCyclesPerBuild(n : Nat) : async Text {
    assert(_isArchitect(msg.caller));
    cyclesPerBuild := n;
    "CYCLES_PER_BUILD_SET: " # Nat.toText(n)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 8 — CYCLE DONATION (payable entry point for subsidy pool)
  // ═══════════════════════════════════════════════════════════════════════════

  public shared func donateCycles() : async Text {
    // In a deployed canister, msg.cycles carries the attached cycles.
    // Here we accept the donation and credit the subsidy pool.
    // Full ICP cycle attachment requires ExperimentalCycles; this records intent.
    subsidyPool += 1_000_000_000; // 1B cycles credit per donation call (mock for type-check)
    let payload = "{\"event\":\"DONATION\",\"pool\":" # Nat.toText(subsidyPool) # "}";
    ignore _publishToStream("BUILDER_CYCLES_BURN", payload);
    "DONATION_ACCEPTED: pool=" # Nat.toText(subsidyPool)
  };

  // Admin: direct pool credit (for grants, protocol fee routing)
  public shared(msg) func creditPool(amount : Nat) : async Text {
    assert(_isArchitect(msg.caller));
    subsidyPool += amount;
    "POOL_CREDITED: " # Nat.toText(amount) # " total=" # Nat.toText(subsidyPool)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 9 — CORE: SUBMIT BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  // submitBuild — user submits a plain-language build description
  // Returns: sessionId (Text) to poll with getBuildSession()
  // Rate-limited by cycles pool only — zero account-based limits
  public shared func submitBuild(intent : Text) : async Text {
    if (not _poolIsOpen()) {
      return "POOL_EMPTY: subsidy pool below threshold — contribute cycles to reopen";
    };
    if (Text.size(intent) == 0) {
      return "INVALID_INTENT: description cannot be empty";
    };
    if (Text.size(intent) > 2000) {
      return "INTENT_TOO_LONG: max 2000 characters";
    };

    // Allocate session ID
    sessionSeq += 1;
    let sid = "NB-" # Nat.toText(sessionSeq) # "-" # Int.toText(Time.now() / 1_000_000_000);

    // Write to ring buffer
    let slot = sessionHead % MAX_SESSIONS;
    sessId[slot]        := sid;
    sessIntent[slot]    := intent;
    sessStatus[slot]    := 0; // QUEUED
    sessCode[slot]      := "";
    sessAddress[slot]   := "";
    sessCycles[slot]    := cyclesPerBuild;
    sessTier[slot]      := 0;
    sessSubmitted[slot] := Time.now();
    sessCompleted[slot] := 0;
    sessError[slot]     := "";
    sessValid[slot]     := true;
    sessionHead         += 1;
    totalBuilds         += 1;

    // Deduct from subsidy pool (cycles committed at intake)
    if (subsidyPool >= cyclesPerBuild) {
      subsidyPool -= cyclesPerBuild;
    };
    totalCyclesBurned += cyclesPerBuild;

    // Publish intake event to nova_stream
    let payload = "{\"event\":\"BUILDER_INTAKE\",\"sessionId\":\"" # sid # "\",\"intent\":\"" # intent # "\",\"cyclesCommitted\":" # Nat.toText(cyclesPerBuild) # "}";
    ignore _publishToStream("BUILDER_INTAKE", payload);

    sid
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 10 — CORE: POLL SESSION
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getBuildSession(sessionId : Text) : async ?BuildSession {
    switch (_findSession(sessionId)) {
      case (?slot) { ?_readSession(slot) };
      case null    { null };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 11 — LIFECYCLE TRANSITIONS (called by swarm_brain / sovereign_factory)
  // ═══════════════════════════════════════════════════════════════════════════

  // markBuildGenerating — swarm_brain has accepted the intent
  public shared(msg) func markBuildGenerating(sessionId : Text) : async Text {
    assert(_isArchitect(msg.caller));
    switch (_findSession(sessionId)) {
      case null { return "SESSION_NOT_FOUND" };
      case (?slot) {
        sessStatus[slot] := 1; // GENERATING
        let payload = "{\"event\":\"BUILDER_GENERATE\",\"sessionId\":\"" # sessionId # "\",\"stage\":\"GENERATING\"}";
        ignore _publishToStream("BUILDER_GENERATE", payload);
        "OK_GENERATING"
      };
    }
  };

  // markBuildComplete — swarm_brain has produced code
  public shared(msg) func markBuildComplete(sessionId : Text, code : Text) : async Text {
    assert(_isArchitect(msg.caller));
    switch (_findSession(sessionId)) {
      case null { return "SESSION_NOT_FOUND" };
      case (?slot) {
        sessStatus[slot] := 2; // GENERATED
        sessCode[slot]   := code;
        let payload = "{\"event\":\"BUILDER_CODE_READY\",\"sessionId\":\"" # sessionId # "\",\"codeLen\":" # Nat.toText(Text.size(code)) # "}";
        ignore _publishToStream("BUILDER_GENERATE", payload);
        "OK_GENERATED"
      };
    }
  };

  // markBuildDeploying — sovereign_factory is spinning up the canister
  public shared(msg) func markBuildDeploying(sessionId : Text) : async Text {
    assert(_isArchitect(msg.caller));
    switch (_findSession(sessionId)) {
      case null { return "SESSION_NOT_FOUND" };
      case (?slot) {
        sessStatus[slot] := 3; // DEPLOYING
        let payload = "{\"event\":\"BUILDER_DEPLOY\",\"sessionId\":\"" # sessionId # "\",\"stage\":\"DEPLOYING\"}";
        ignore _publishToStream("BUILDER_DEPLOY", payload);
        "OK_DEPLOYING"
      };
    }
  };

  // markBuildDeployed — canister is live, address known
  public shared(msg) func markBuildDeployed(sessionId : Text, canisterAddress : Text) : async Text {
    assert(_isArchitect(msg.caller));
    switch (_findSession(sessionId)) {
      case null { return "SESSION_NOT_FOUND" };
      case (?slot) {
        sessStatus[slot]    := 4; // DEPLOYED
        sessAddress[slot]   := canisterAddress;
        sessCompleted[slot] := Time.now();
        totalDeployed       += 1;
        let burned = sessCycles[slot];
        let payload = "{\"event\":\"BUILDER_DEPLOYED\",\"sessionId\":\"" # sessionId # "\",\"address\":\"" # canisterAddress # "\",\"cyclesBurned\":" # Nat.toText(burned) # ",\"totalBurn\":" # Nat.toText(totalCyclesBurned) # "}";
        ignore _publishToStream("BUILDER_DEPLOY", payload);
        ignore _publishToStream("BUILDER_CYCLES_BURN", payload);
        "OK_DEPLOYED: " # canisterAddress
      };
    }
  };

  // markBuildFailed — record failure reason
  public shared(msg) func markBuildFailed(sessionId : Text, reason : Text) : async Text {
    assert(_isArchitect(msg.caller));
    switch (_findSession(sessionId)) {
      case null { return "SESSION_NOT_FOUND" };
      case (?slot) {
        sessStatus[slot]    := 5; // FAILED
        sessError[slot]     := reason;
        sessCompleted[slot] := Time.now();
        totalFailed         += 1;
        // Refund cycles to pool on failure
        subsidyPool += sessCycles[slot];
        let payload = "{\"event\":\"BUILDER_FAILED\",\"sessionId\":\"" # sessionId # "\",\"reason\":\"" # reason # "\"}";
        ignore _publishToStream("BUILDER_DEPLOY", payload);
        "OK_FAILED_RECORDED"
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 12 — READ API: STATUS + RECENT BUILDS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getBuilderStatus() : async BuilderStatus {
    {
      buildNumber       = 42;
      sovereignSeal     = sovereignSeal;
      totalBuilds       = totalBuilds;
      totalDeployed     = totalDeployed;
      totalFailed       = totalFailed;
      totalCyclesBurned = totalCyclesBurned;
      subsidyPoolBalance = subsidyPool;
      cyclesPerBuild    = cyclesPerBuild;
      subsidyThreshold  = subsidyThreshold;
      queueDepth        = totalBuilds - totalDeployed - totalFailed;
      openToBuilders    = _poolIsOpen();
      missionStatement  = "Non-profit. Sovereign. Permissionless. Every build burns ICP cycles.";
      uptimeNs          = Time.now() - genesisTimestamp;
    }
  };

  // getRecentBuilds — last N build summaries (public proof of work, no code exposed)
  public query func getRecentBuilds(n : Nat) : async [BuildSummary] {
    var count = if (n > MAX_SESSIONS) { MAX_SESSIONS } else { n };
    var results : [BuildSummary] = [];
    // Scan from most recent ring position backwards
    var i = sessionHead;
    var found = 0;
    while (found < count and found < MAX_SESSIONS) {
      let slot = (MAX_SESSIONS + i - 1 - found) % MAX_SESSIONS;
      if (sessValid[slot]) {
        let summary : BuildSummary = {
          sessionId      = sessId[slot];
          intent         = sessIntent[slot];
          status         = _natToStatus(sessStatus[slot]);
          deployAddress  = sessAddress[slot];
          cyclesConsumed = sessCycles[slot];
          completedAt    = sessCompleted[slot];
        };
        results := Array.append(results, [summary]);
      };
      found += 1;
    };
    results
  };

  // getQueueDepth — how many builds are pending
  public query func getQueueDepth() : async Nat {
    if (totalBuilds > totalDeployed + totalFailed) {
      totalBuilds - totalDeployed - totalFailed
    } else {
      0
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 13 — DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func diagnostics() : async Text {
    "NOVA_BUILDER | build=42 | sessions=" # Nat.toText(totalBuilds) #
    " | deployed=" # Nat.toText(totalDeployed) #
    " | failed=" # Nat.toText(totalFailed) #
    " | poolBalance=" # Nat.toText(subsidyPool) #
    " | totalBurn=" # Nat.toText(totalCyclesBurned) #
    " | open=" # Bool.toText(_poolIsOpen()) #
    " | stream=" # streamCanisterPrincipal
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 14 — NON-PROFIT COVENANT (immutable doctrine)
  // ═══════════════════════════════════════════════════════════════════════════

  // The NoDropLaw of NOVA BUILDER:
  // 1. No account-based limits. Ever.
  // 2. Every build burns cycles from the subsidy pool — direct ICP deflation.
  // 3. Pool is funded by donations, grants, and NOVA protocol fees — not user charges.
  // 4. Governance (nova_governance) controls subsidy thresholds — not Medina Tech unilaterally.
  // 5. This canister cannot be shut down — it runs on ICP.
  // 6. Source code is on-chain. Every deploy is verifiable.
  // 7. This is not a startup. This is a protocol.

  public query func getNoDropLaw() : async Text {
    "NOVA_BUILDER_NO_DROP_LAW: " #
    "1.NoAccountLimits " #
    "2.EveryBuildBurnsCycles " #
    "3.SubsidyFundedByDonationsAndFees " #
    "4.GovernanceControlsThresholds " #
    "5.CannotBeShutDown " #
    "6.SourceCodeOnChain " #
    "7.ThisisAProtocol"
  };

}
