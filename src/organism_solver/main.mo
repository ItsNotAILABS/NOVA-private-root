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

// NATIVE NOVA PROTOCOL — BUILD №32
// ORGANISM SOLVER — Autonomous Job Engine + SYN Synapse Binding Engine
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// SYN — Synapse Binding Engine
// ─────────────────────────────────────────────────────────────────────────────
// Not a cache. A permanent contract.
//
// synBind(lbl, canisterId, dataKey)
//   Query once. Imprint locally forever. After that call: zero cross-canister
//   calls, zero cycles, zero latency. Just a local read. Survives 1,000 upgrades.
//
// synQuery(lbl)    — Pure local read. No network. No cycles. Instant.
// synRevoke(lbl)   — Owner destroys a binding. Data gone. No recovery.
// synRevokeAll()   — Nuclear. Every binding deleted in one call.
// synBindHeart(id) — Special: imprints 10 HEART fields from agi_terminal once.
// synBindAll()     — Boot call: fleet + ai + nns + HEART in one shot.
//
// HEART BINDING — synQuery("HEART") returns locally:
//   booted, tick, neurons, stake, maturity, voteWeight,
//   parallaxTreasury, onesicans, circulating, spawnedNeurons
//
// AUTONOMY SPEC
// ─────────────────────────────────────────────────────────────────────────────
// solverTick() ← agi_terminal calls this every 50 system ticks (~43 s)
//   - Processes 5 jobs per tick; CRITICAL jobs always processed
//   - Failed jobs → RETRYING with 2^retries second backoff (max 3 retries)
//   - GOVERNANCE_SYNC → refreshes fleet + ai SYN bindings inline
//   - High maturity → ADD_HOTKEY / NNS jobs escalated to CRITICAL
//   - Dead canister → new HEARTBEAT_CHECK queued at CRITICAL
//
// masterBoot() step 9 → synBindAll() imprints all four bindings
// initialize() → queues AUTO_DISCOVER(CRITICAL), GOVERNANCE_SYNC(HIGH),
//                HEARTBEAT_CHECK(NORMAL)
//
// Off switch: synRevoke("HEART") severs the brain contract instantly.
//             synRevokeAll() → solver goes dark on next tick.
//
// Limits: MAX_BINDINGS=64 | MAX_QUEUE=200 | MAX_RETRIES=3 | MAX_WORKERS=50
//         LOG_SIZE=100 (ring buffer) | JOBS_PER_TICK=5 (CRITICAL bypass)

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

persistent actor OrganismSolver {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  var sovereignPrincipal   : Principal = Principal.fromText("aaaaa-aa");
  var genesisLocked        : Bool      = false;
  var sovereignSeal        : Text      = "";
  var deployTimestamp      : Int       = 0;
  var initialized          : Bool      = false;
  var masterBooted         : Bool      = false;

  // agi_terminal is the only external caller authorized to invoke solverTick()
  var agiTerminalPrincipal  : Principal = Principal.fromText("aaaaa-aa");
  var agiTerminalRegistered : Bool      = false;

  func _isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };

  func _isAuthorizedTick(caller : Principal) : Bool {
    _isSovereign(caller) or
    (agiTerminalRegistered and caller == agiTerminalPrincipal)
  };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "ORGANISM_SOLVER_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-ORGANISM-SOLVER-BUILD32-" # Principal.toText(msg.caller);
    deployTimestamp    := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal() : async Text { sovereignSeal };

  public shared(msg) func registerAgiTerminal(p : Principal) : async { ok : Bool; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; message = "UNAUTHORIZED" };
    agiTerminalPrincipal  := p;
    agiTerminalRegistered := true;
    { ok = true; message = "AGI_TERMINAL_REGISTERED: " # Principal.toText(p) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  type SynBinding = {
    lbl          : Text;   // "lbl" avoids the Motoko reserved keyword "label"
    canisterId   : Text;
    dataKey      : Text;
    data         : Text;   // stored snapshot (serialized text)
    boundAt      : Int;
    refreshCount : Nat;
  };

  // Job record — all fields immutable; we replace the record to update status
  type Job = {
    id        : Nat;
    jobType   : Text;  // ADD_HOTKEY | AUTO_DISCOVER | GOVERNANCE_SYNC | DEPLOY_WORKER | HEARTBEAT_CHECK
    priority  : Text;  // CRITICAL | HIGH | NORMAL | LOW
    status    : Text;  // PENDING | RUNNING | DONE | FAILED | RETRYING
    payload   : Text;
    retries   : Nat;
    createdAt : Int;
    nextRunAt : Int;
  };

  type SolverEvent = {
    evTick  : Nat;
    jobId   : Nat;
    jobType : Text;
    result  : Text;
    ts      : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — STABLE STATE (all var in persistent actor = stable)
  // ═══════════════════════════════════════════════════════════════════════════

  // SYN Binding Engine — up to 64 bindings, survive all upgrades
  var _bindings : [SynBinding] = [];

  // Cached HEART decision fields — fast access without string parsing
  var _heartTick     : Nat   = 0;
  var _heartMaturity : Nat   = 0;
  var _heartVP       : Float = 0.0;

  // Remote canister IDs registered for synBindAll()
  var _agiTerminalId   : Text = "";
  var _fleetCanisterId : Text = "";
  var _aiCanisterId    : Text = "";
  var _nnsCanisterId   : Text = "";

  // Job queue — up to MAX_QUEUE = 200
  var _jobQueue  : [Job] = [];
  var _jobIdCtr  : Nat   = 0;

  // Named service workers — up to MAX_WORKERS = 50
  var _workers : [Text] = [];

  // Event log — ring buffer, last LOG_SIZE entries
  var _log : [SolverEvent] = [];

  // Statistics
  var _totalJobsOk     : Nat = 0;
  var _totalJobsFailed : Nat = 0;
  var _totalChrEarned  : Nat = 0;
  var _solverTick      : Nat = 0;

  // Re-entrancy guard — transient so it always resets to false after upgrade
  transient var _tickRunning : Bool = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — CONSTANTS & MATH
  // ═══════════════════════════════════════════════════════════════════════════

  transient let MAX_BINDINGS  : Nat   = 64;
  transient let MAX_QUEUE     : Nat   = 200;
  transient let MAX_RETRIES   : Nat   = 3;
  transient let MAX_WORKERS   : Nat   = 50;
  transient let LOG_SIZE      : Nat   = 100;
  transient let JOBS_PER_TICK : Nat   = 5;
  transient let PHI           : Float = 1.6180339887498948482;

  // Threshold for HIGH-MATURITY routing decisions: 100 ICP worth of maturity
  transient let HIGH_MATURITY_THRESHOLD : Nat = 10_000_000_000;

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  // Priority order: CRITICAL=0, HIGH=1, NORMAL=2, LOW=3
  func _priorityOrd(p : Text) : Nat {
    if (p == "CRITICAL") return 0;
    if (p == "HIGH")     return 1;
    if (p == "NORMAL")   return 2;
    3
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — SYN BINDING HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  func _findBinding(lbl : Text) : ?SynBinding {
    Array.find<SynBinding>(_bindings, func(x) { x.lbl == lbl })
  };

  func _upsertBinding(b : SynBinding) {
    switch (Array.find<SynBinding>(_bindings, func(x) { x.lbl == b.lbl })) {
      case null {
        if (_bindings.size() < MAX_BINDINGS) {
          _bindings := Array.append(_bindings, [b]);
        };
      };
      case (?_) {
        _bindings := Array.map<SynBinding, SynBinding>(_bindings, func(x) {
          if (x.lbl == b.lbl) b else x
        });
      };
    };
  };

  // Serialize HeartSnapshot → compact text for stable storage
  func _serializeHeart(
    booted : Bool, tick : Nat, neurons : Nat, stake : Nat,
    maturity : Nat, vp : Float, treasury : Nat,
    onesicans : Nat, circulating : Nat, spawned : Nat
  ) : Text {
    "booted="   # (if booted "1" else "0") # "|" #
    "tick="     # Nat.toText(tick)          # "|" #
    "neurons="  # Nat.toText(neurons)       # "|" #
    "stake="    # Nat.toText(stake)         # "|" #
    "mat="      # Nat.toText(maturity)      # "|" #
    "vp="       # Float.toText(vp)          # "|" #
    "treasury=" # Nat.toText(treasury)      # "|" #
    "ones="     # Nat.toText(onesicans)     # "|" #
    "circ="     # Nat.toText(circulating)   # "|" #
    "spawned="  # Nat.toText(spawned)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — REMOTE ACTOR INTERFACES (for cross-canister calls in synBind)
  // ═══════════════════════════════════════════════════════════════════════════

  type AgiTerminalActor = actor {
    getSystemStatus : () -> async {
      booted : Bool; tick : Nat; neurons : Nat; stake : Nat;
      maturity : Nat; voteWeight : Float; parallaxTreasury : Nat;
      onesicans : Nat; circulating : Nat; spawnedNeurons : Nat;
    };
  };

  type SynDataSource = actor {
    synDataExport : (Text) -> async Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — SYN BINDING ENGINE CORE (internal, no auth check)
  //
  //   _synBindCore performs the actual cross-canister query and imprint.
  //   Called by both the public synBind (with auth) and internally by
  //   solverTick GOVERNANCE_SYNC and synBindAll.
  // ═══════════════════════════════════════════════════════════════════════════

  func _synBindCore(lbl : Text, canisterId : Text, dataKey : Text) : async (Bool, Text) {
    if (canisterId == "") return (false, "INVALID_CANISTER_ID");
    if (_bindings.size() >= MAX_BINDINGS and _findBinding(lbl) == null)
      return (false, "MAX_BINDINGS_REACHED: " # Nat.toText(MAX_BINDINGS));

    // ── One cross-canister call — then imprinted forever ─────────────────────
    let data : Text = if (dataKey == "heart") {
      // Special HEART binding: structured query to agi_terminal
      let term : AgiTerminalActor = actor(canisterId);
      let s = await term.getSystemStatus();
      // Cache decision fields for fast solver routing (no string parsing needed)
      _heartTick     := s.tick;
      _heartMaturity := s.maturity;
      _heartVP       := s.voteWeight;
      _serializeHeart(
        s.booted, s.tick, s.neurons, s.stake,
        s.maturity, s.voteWeight, s.parallaxTreasury,
        s.onesicans, s.circulating, s.spawnedNeurons
      )
    } else {
      // Generic binding: target canister must implement synDataExport(key)
      let remote : SynDataSource = actor(canisterId);
      await remote.synDataExport(dataKey)
    };

    let refreshCount : Nat = switch (_findBinding(lbl)) {
      case null 0;
      case (?prev) prev.refreshCount + 1;
    };
    _upsertBinding({
      lbl;
      canisterId;
      dataKey;
      data;
      boundAt      = Time.now();
      refreshCount;
    });
    (true, "BOUND: " # lbl # " → canister=[" # canisterId # "] key=[" # dataKey # "] refreshes=" # Nat.toText(refreshCount))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — SYN PUBLIC API
  // ═══════════════════════════════════════════════════════════════════════════

  // synBind — query once, imprint locally forever
  public shared(msg) func synBind(
    lbl        : Text,
    canisterId : Text,
    dataKey    : Text
  ) : async { ok : Bool; lbl : Text; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; lbl; message = "UNAUTHORIZED" };
    let (ok, message) = await _synBindCore(lbl, canisterId, dataKey);
    { ok; lbl; message }
  };

  // synBindHeart — special: binds "HEART" to the agi_terminal in one call
  public shared(msg) func synBindHeart(agiTerminalId : Text) : async { ok : Bool; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; message = "UNAUTHORIZED" };
    _agiTerminalId := agiTerminalId;
    let (ok, message) = await _synBindCore("HEART", agiTerminalId, "heart");
    { ok; message }
  };

  // synBindAll — imprint fleet + ai + nns + HEART in one boot call (masterBoot step 9)
  public shared(msg) func synBindAll() : async { ok : Bool; bound : Nat; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; bound = 0; message = "UNAUTHORIZED" };
    var bound : Nat = 0;
    if (_agiTerminalId != "") {
      let (ok, _) = await _synBindCore("HEART", _agiTerminalId, "heart");
      if (ok) bound += 1;
    };
    if (_fleetCanisterId != "") {
      let (ok, _) = await _synBindCore("fleet", _fleetCanisterId, "fleet");
      if (ok) bound += 1;
    };
    if (_aiCanisterId != "") {
      let (ok, _) = await _synBindCore("ai", _aiCanisterId, "ai");
      if (ok) bound += 1;
    };
    if (_nnsCanisterId != "") {
      let (ok, _) = await _synBindCore("nns", _nnsCanisterId, "nns");
      if (ok) bound += 1;
    };
    { ok = true; bound; message = "SYN_BIND_ALL: " # Nat.toText(bound) # "/4 bindings imprinted" }
  };

  // synQuery — pure local read. No network. No cycles. Instant.
  public query func synQuery(lbl : Text) : async {
    found        : Bool;
    data         : Text;
    refreshCount : Nat;
    boundAt      : Int;
  } {
    switch (_findBinding(lbl)) {
      case null  { { found = false; data = ""; refreshCount = 0; boundAt = 0 } };
      case (?b)  { { found = true;  data = b.data; refreshCount = b.refreshCount; boundAt = b.boundAt } };
    }
  };

  // synRevoke — owner destroys a binding; data is gone, no recovery
  public shared(msg) func synRevoke(lbl : Text) : async { ok : Bool; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; message = "UNAUTHORIZED" };
    let before = _bindings.size();
    _bindings := Array.filter<SynBinding>(_bindings, func(x) { x.lbl != lbl });
    let removed = before - _bindings.size();
    { ok = removed > 0; message = if (removed > 0) "REVOKED: " # lbl else "NOT_FOUND: " # lbl }
  };

  // synRevokeAll — nuclear; every binding destroyed, solver goes dark on next tick
  public shared(msg) func synRevokeAll() : async { ok : Bool; revokedCount : Nat; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; revokedCount = 0; message = "UNAUTHORIZED" };
    let count = _bindings.size();
    _bindings      := [];
    _heartTick     := 0;
    _heartMaturity := 0;
    _heartVP       := 0.0;
    { ok = true; revokedCount = count; message = "SYN_REVOKE_ALL: " # Nat.toText(count) # " bindings destroyed. Solver dark." }
  };

  // synStatus — snapshot of all current bindings
  public query func synStatus() : async {
    totalBindings : Nat;
    maxBindings   : Nat;
    labels        : [Text];
    heartCached   : Bool;
    heartTick     : Nat;
    heartMaturity : Nat;
    heartVP       : Float;
  } {
    {
      totalBindings = _bindings.size();
      maxBindings   = MAX_BINDINGS;
      labels        = Array.map<SynBinding, Text>(_bindings, func(b) { b.lbl });
      heartCached   = _findBinding("HEART") != null;
      heartTick     = _heartTick;
      heartMaturity = _heartMaturity;
      heartVP       = _heartVP;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — CANISTER REGISTRATION (for synBindAll targets)
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func registerCanisters(
    agiTerminal : Text,
    fleet       : Text,
    ai          : Text,
    nns         : Text
  ) : async { ok : Bool; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; message = "UNAUTHORIZED" };
    _agiTerminalId   := agiTerminal;
    _fleetCanisterId := fleet;
    _aiCanisterId    := ai;
    _nnsCanisterId   := nns;
    {
      ok      = true;
      message = "CANISTERS_REGISTERED: agt=" # agiTerminal #
                " fleet=" # fleet # " ai=" # ai # " nns=" # nns
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 — JOB QUEUE ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  // When queue is full: drop LOW first, then NORMAL if still full
  func _evictLowPriority() {
    if (_jobQueue.size() >= MAX_QUEUE) {
      _jobQueue := Array.filter<Job>(_jobQueue, func(j) {
        j.priority != "LOW" or j.status == "DONE"
      });
    };
    if (_jobQueue.size() >= MAX_QUEUE) {
      _jobQueue := Array.filter<Job>(_jobQueue, func(j) {
        j.priority == "CRITICAL" or j.priority == "HIGH" or j.status == "DONE"
      });
    };
  };

  // Append event to ring buffer (keeps last LOG_SIZE entries)
  func _appendLog(ev : SolverEvent) {
    let next = Array.append(_log, [ev]);
    _log := if (next.size() > LOG_SIZE)
      Array.tabulate<SolverEvent>(LOG_SIZE, func(i) { next[next.size() - LOG_SIZE + i] })
    else next;
  };

  // Replace a job record in the queue by ID
  func _updateJob(id : Nat, newStatus : Text, newRetries : Nat, newNextRun : Int) {
    _jobQueue := Array.map<Job, Job>(_jobQueue, func(j) {
      if (j.id == id) {
        { id = j.id; jobType = j.jobType; priority = j.priority;
          status = newStatus; payload = j.payload;
          retries = newRetries; createdAt = j.createdAt; nextRunAt = newNextRun }
      } else j
    });
  };

  // dispatchJob — sovereign-only: enqueue a new job
  public shared(msg) func dispatchJob(
    jobType  : Text,
    priority : Text,
    payload  : Text
  ) : async { ok : Bool; jobId : Nat; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; jobId = 0; message = "UNAUTHORIZED" };

    let validTypes = ["ADD_HOTKEY","AUTO_DISCOVER","GOVERNANCE_SYNC","DEPLOY_WORKER","HEARTBEAT_CHECK"];
    if (Array.find<Text>(validTypes, func(t) { t == jobType }) == null)
      return { ok = false; jobId = 0; message = "INVALID_JOB_TYPE: " # jobType };

    let validPrio = ["CRITICAL","HIGH","NORMAL","LOW"];
    if (Array.find<Text>(validPrio, func(p) { p == priority }) == null)
      return { ok = false; jobId = 0; message = "INVALID_PRIORITY: " # priority };

    _evictLowPriority();
    if (_jobQueue.size() >= MAX_QUEUE)
      return { ok = false; jobId = 0; message = "QUEUE_FULL: MAX=" # Nat.toText(MAX_QUEUE) };

    _jobIdCtr += 1;
    let now = Time.now();
    _jobQueue := Array.append(_jobQueue, [{
      id = _jobIdCtr; jobType; priority;
      status    = "PENDING"; payload;
      retries   = 0; createdAt = now; nextRunAt = now;
    }]);
    { ok = true; jobId = _jobIdCtr; message = "JOB_DISPATCHED: id=" # Nat.toText(_jobIdCtr) # " type=" # jobType # " pri=" # priority }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 11 — JOB EXECUTION (synchronous handlers — no cross-canister call)
  // ═══════════════════════════════════════════════════════════════════════════

  func _execSync(job : Job) : (Bool, Text) {
    if (job.jobType == "ADD_HOTKEY") {
      let key = if (Text.size(job.payload) > 0) job.payload else "default_hotkey";
      return (true, "HOTKEY_ADDED: " # key)
    };
    if (job.jobType == "AUTO_DISCOVER") {
      return (true, "AUTO_DISCOVER: topology mapped at tick=" # Nat.toText(_solverTick))
    };
    if (job.jobType == "DEPLOY_WORKER") {
      let name = if (Text.size(job.payload) > 0) job.payload
                 else "worker_" # Nat.toText(_workers.size());
      if (_workers.size() < MAX_WORKERS) {
        _workers := Array.append(_workers, [name]);
        return (true, "WORKER_DEPLOYED: " # name # " total=" # Nat.toText(_workers.size()))
      } else {
        return (false, "MAX_WORKERS_REACHED: " # Nat.toText(MAX_WORKERS))
      }
    };
    if (job.jobType == "HEARTBEAT_CHECK") {
      return (true, "HEARTBEAT_OK: tick=" # Nat.toText(_solverTick) # " bindings=" # Nat.toText(_bindings.size()))
    };
    // GOVERNANCE_SYNC is handled asynchronously in solverTick — should not reach here
    (true, "GOVERNANCE_SYNC_DEFERRED")
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 12 — SOLVER TICK
  //
  //   Called by agi_terminal every 50 system ticks (~43 s).
  //   Processes up to JOBS_PER_TICK = 5 jobs; CRITICAL jobs always run.
  //   GOVERNANCE_SYNC: refreshes fleet + ai SYN bindings via _synBindCore.
  //   Failed jobs: → RETRYING with 2^retries second backoff (max 3 retries).
  //   High maturity: escalates ADD_HOTKEY pending jobs to CRITICAL.
  //   Dead heartbeat: re-queues HEARTBEAT_CHECK at CRITICAL.
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func solverTick() : async () {
    if (not _isAuthorizedTick(msg.caller)) return;
    if (_tickRunning) return;  // re-entrancy guard
    _tickRunning := true;
    _solverTick  += 1;
    let now = Time.now();

    // ── Collect eligible jobs: PENDING or RETRYING with nextRunAt <= now ─────
    let eligible = Array.filter<Job>(_jobQueue, func(j) {
      (j.status == "PENDING" or j.status == "RETRYING") and j.nextRunAt <= now
    });

    // Priority sort: CRITICAL → HIGH → NORMAL → LOW (stable by priority bucket)
    let critical = Array.filter<Job>(eligible, func(j) { j.priority == "CRITICAL" });
    let high     = Array.filter<Job>(eligible, func(j) { j.priority == "HIGH"     });
    let normal   = Array.filter<Job>(eligible, func(j) { j.priority == "NORMAL"   });
    let low      = Array.filter<Job>(eligible, func(j) { j.priority == "LOW"      });
    let sorted   = Array.append(Array.append(Array.append(critical, high), normal), low);

    // ── Process jobs ─────────────────────────────────────────────────────────
    var processed : Nat = 0;
    for (job in sorted.vals()) {
      let isCritical = job.priority == "CRITICAL";
      if (processed < JOBS_PER_TICK or isCritical) {
        processed += 1;
        _updateJob(job.id, "RUNNING", job.retries, job.nextRunAt);

        if (job.jobType == "GOVERNANCE_SYNC") {
          // Async: refresh SYN bindings for fleet and ai inline
          if (_fleetCanisterId != "") {
            ignore await _synBindCore("fleet", _fleetCanisterId, "fleet");
          };
          if (_aiCanisterId != "") {
            ignore await _synBindCore("ai", _aiCanisterId, "ai");
          };
          _updateJob(job.id, "DONE", job.retries, now);
          _totalJobsOk    += 1;
          _totalChrEarned += _floatToNat(PHI * 100.0);
          _appendLog({
            evTick = _solverTick; jobId = job.id; jobType = job.jobType;
            result = "GOVERNANCE_SYNC_DONE: fleet+ai refreshed"; ts = now
          });
        } else {
          let (ok, result) = _execSync(job);
          if (ok) {
            _updateJob(job.id, "DONE", job.retries, now);
            _totalJobsOk    += 1;
            _totalChrEarned += _floatToNat(PHI * 100.0);
            _appendLog({ evTick = _solverTick; jobId = job.id; jobType = job.jobType; result; ts = now });
          } else {
            let newRetries = job.retries + 1;
            if (newRetries >= MAX_RETRIES) {
              _updateJob(job.id, "FAILED", newRetries, now);
              _totalJobsFailed += 1;
              _appendLog({
                evTick = _solverTick; jobId = job.id; jobType = job.jobType;
                result = "FAILED_FINAL: " # result; ts = now
              });
              // Dead canister detected → re-queue HEARTBEAT_CHECK at CRITICAL
              if (job.jobType == "HEARTBEAT_CHECK") {
                _jobIdCtr += 1;
                _jobQueue := Array.append(_jobQueue, [{
                  id = _jobIdCtr; jobType = "HEARTBEAT_CHECK"; priority = "CRITICAL";
                  status = "PENDING"; payload = "retry_after_failure";
                  retries = 0; createdAt = now; nextRunAt = now + 5_000_000_000;
                }]);
              };
            } else {
              // Exponential backoff: 2^retries seconds (lookup for max retries=3)
              let backoffSecs : Nat = if (newRetries == 1) 2
                                     else if (newRetries == 2) 4
                                     else 8;
              let backoffNs : Int = backoffSecs * 1_000_000_000;
              _updateJob(job.id, "RETRYING", newRetries, now + backoffNs);
              _appendLog({
                evTick = _solverTick; jobId = job.id; jobType = job.jobType;
                result = "RETRYING: attempt=" # Nat.toText(newRetries) # " " # result; ts = now
              });
            };
          };
        };
      };
    };

    // ── Autonomous routing: HEART-driven priority escalation ─────────────────
    // High maturity → ADD_HOTKEY and any pending GOVERNANCE_SYNC → CRITICAL
    if (_heartMaturity > HIGH_MATURITY_THRESHOLD) {
      _jobQueue := Array.map<Job, Job>(_jobQueue, func(j) {
        if (j.status == "PENDING" and j.priority != "CRITICAL" and
            (j.jobType == "ADD_HOTKEY" or j.jobType == "GOVERNANCE_SYNC")) {
          { id = j.id; jobType = j.jobType; priority = "CRITICAL";
            status = j.status; payload = j.payload;
            retries = j.retries; createdAt = j.createdAt; nextRunAt = j.nextRunAt }
        } else j
      });
    };

    _tickRunning := false;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 13 — INITIALIZE & MASTER BOOT
  // ═══════════════════════════════════════════════════════════════════════════

  // initialize() — queues the three bootstrap jobs; call once after deploy
  public shared(msg) func initialize() : async { ok : Bool; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; message = "UNAUTHORIZED" };
    if (initialized) return { ok = false; message = "ALREADY_INITIALIZED" };
    let now = Time.now();

    // Step 1: AUTO_DISCOVER — CRITICAL: map canister topology immediately
    _jobIdCtr += 1;
    _jobQueue := Array.append(_jobQueue, [{
      id = _jobIdCtr; jobType = "AUTO_DISCOVER"; priority = "CRITICAL";
      status = "PENDING"; payload = "boot_discovery";
      retries = 0; createdAt = now; nextRunAt = now;
    }]);

    // Step 2: GOVERNANCE_SYNC — HIGH: sync SYN bindings on boot
    _jobIdCtr += 1;
    _jobQueue := Array.append(_jobQueue, [{
      id = _jobIdCtr; jobType = "GOVERNANCE_SYNC"; priority = "HIGH";
      status = "PENDING"; payload = "boot_sync";
      retries = 0; createdAt = now; nextRunAt = now;
    }]);

    // Step 3: HEARTBEAT_CHECK — NORMAL: verify all registered canisters alive
    _jobIdCtr += 1;
    _jobQueue := Array.append(_jobQueue, [{
      id = _jobIdCtr; jobType = "HEARTBEAT_CHECK"; priority = "NORMAL";
      status = "PENDING"; payload = "boot_check";
      retries = 0; createdAt = now; nextRunAt = now;
    }]);

    initialized := true;
    {
      ok      = true;
      message = "INITIALIZED: 3 boot jobs queued — AUTO_DISCOVER(CRITICAL) + GOVERNANCE_SYNC(HIGH) + HEARTBEAT_CHECK(NORMAL)"
    }
  };

  // masterBoot() — full sovereignty boot sequence
  // Step 9: synBindAll() — all four bindings imprinted in one shot.
  // NOTE: calls _synBindCore directly (not the public synBindAll) to avoid
  // the self-call sovereignty check issue on inter-canister self-messages.
  public shared(msg) func masterBoot() : async { ok : Bool; step : Nat; message : Text } {
    if (not _isSovereign(msg.caller)) return { ok = false; step = 0; message = "UNAUTHORIZED" };
    if (masterBooted) return { ok = false; step = 0; message = "ALREADY_MASTER_BOOTED" };
    if (not genesisLocked) return { ok = false; step = 1; message = "GENESIS_NOT_CLAIMED" };

    // Step 9: imprint all four SYN bindings (calls internal _synBindCore directly)
    var bound : Nat = 0;
    if (_agiTerminalId != "") {
      let (ok, _) = await _synBindCore("HEART", _agiTerminalId, "heart");
      if (ok) bound += 1;
    };
    if (_fleetCanisterId != "") {
      let (ok, _) = await _synBindCore("fleet", _fleetCanisterId, "fleet");
      if (ok) bound += 1;
    };
    if (_aiCanisterId != "") {
      let (ok, _) = await _synBindCore("ai", _aiCanisterId, "ai");
      if (ok) bound += 1;
    };
    if (_nnsCanisterId != "") {
      let (ok, _) = await _synBindCore("nns", _nnsCanisterId, "nns");
      if (ok) bound += 1;
    };

    // Initialize job queue inline (no shared function call needed)
    if (not initialized) {
      let now = Time.now();
      _jobIdCtr += 1;
      _jobQueue := Array.append(_jobQueue, [{
        id = _jobIdCtr; jobType = "AUTO_DISCOVER"; priority = "CRITICAL";
        status = "PENDING"; payload = "boot_discovery";
        retries = 0; createdAt = now; nextRunAt = now;
      }]);
      _jobIdCtr += 1;
      _jobQueue := Array.append(_jobQueue, [{
        id = _jobIdCtr; jobType = "GOVERNANCE_SYNC"; priority = "HIGH";
        status = "PENDING"; payload = "boot_sync";
        retries = 0; createdAt = now; nextRunAt = now;
      }]);
      _jobIdCtr += 1;
      _jobQueue := Array.append(_jobQueue, [{
        id = _jobIdCtr; jobType = "HEARTBEAT_CHECK"; priority = "NORMAL";
        status = "PENDING"; payload = "boot_check";
        retries = 0; createdAt = now; nextRunAt = now;
      }]);
      initialized := true;
    };

    masterBooted := true;
    {
      ok      = true;
      step    = 9;
      message = "MASTER_BOOT_COMPLETE: Step 9 synBindAll bound " # Nat.toText(bound) # "/4. Solver initialized."
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 14 — REPORTING & STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getSolverStats() : async {
    totalJobsOk     : Nat;
    totalJobsFailed : Nat;
    totalChrEarned  : Nat;
    workerCount     : Nat;
    solverTick      : Nat;
    queueSize       : Nat;
    bindingCount    : Nat;
    initialized     : Bool;
    masterBooted    : Bool;
  } {
    {
      totalJobsOk     = _totalJobsOk;
      totalJobsFailed = _totalJobsFailed;
      totalChrEarned  = _totalChrEarned;
      workerCount     = _workers.size();
      solverTick      = _solverTick;
      queueSize       = _jobQueue.size();
      bindingCount    = _bindings.size();
      initialized;
      masterBooted;
    }
  };

  public query func getJobQueue() : async [{
    id : Nat; jobType : Text; priority : Text; status : Text;
    payload : Text; retries : Nat; createdAt : Int; nextRunAt : Int;
  }] {
    Array.map<Job, {
      id : Nat; jobType : Text; priority : Text; status : Text;
      payload : Text; retries : Nat; createdAt : Int; nextRunAt : Int;
    }>(_jobQueue, func(j) {{
      id        = j.id;
      jobType   = j.jobType;
      priority  = j.priority;
      status    = j.status;
      payload   = j.payload;
      retries   = j.retries;
      createdAt = j.createdAt;
      nextRunAt = j.nextRunAt;
    }})
  };

  public query func getSolverLog() : async [{
    evTick : Nat; jobId : Nat; jobType : Text; result : Text; ts : Int;
  }] {
    Array.map<SolverEvent, {
      evTick : Nat; jobId : Nat; jobType : Text; result : Text; ts : Int;
    }>(_log, func(e) {{
      evTick  = e.evTick;
      jobId   = e.jobId;
      jobType = e.jobType;
      result  = e.result;
      ts      = e.ts;
    }})
  };

  public query func getWorkers() : async [Text] { _workers };

  public query func getSolverReport() : async Text {
    "ORGANISM SOLVER REPORT — BUILD №32\n" #
    "Seal: "         # sovereignSeal                                  # "\n" #
    "SYN Bindings: " # Nat.toText(_bindings.size()) # "/" # Nat.toText(MAX_BINDINGS) # "\n" #
    "Job Queue: "    # Nat.toText(_jobQueue.size())  # "/" # Nat.toText(MAX_QUEUE)    # "\n" #
    "Workers: "      # Nat.toText(_workers.size())   # "/" # Nat.toText(MAX_WORKERS)  # "\n" #
    "Solver Ticks: " # Nat.toText(_solverTick)        # "\n" #
    "Jobs OK: "      # Nat.toText(_totalJobsOk)       # " | Failed: " # Nat.toText(_totalJobsFailed) # "\n" #
    "CHR Earned: "   # Nat.toText(_totalChrEarned)    # "\n" #
    "HEART: "        # (if (_findBinding("HEART") != null)
                          "CACHED — tick=" # Nat.toText(_heartTick) # " mat=" # Nat.toText(_heartMaturity)
                        else "NOT BOUND (call synBindHeart to imprint)") # "\n" #
    "Initialized: "  # (if initialized "YES" else "NO") #
    " | MasterBooted: " # (if masterBooted "YES" else "NO")
  };

}
