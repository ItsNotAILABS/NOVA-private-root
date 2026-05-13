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
// TOKEN INTELLIGENCE — Autonomous AI Token Flow Management
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// TOKEN INTELLIGENCE IS THE BRAIN OF THE ECONOMY.
// It is a sovereign AI canister that watches every token flow —
// internal and external — and autonomously decides:
//
//   • When to trigger emission (Fibonacci gate reached? demand spike?)
//   • How much to burn (deflationary pressure score)
//   • How to route treasury to substrates (demand weighting per substrate)
//   • When to escalate: alert sovereign if health drops below φ⁻³
//   • Airdrop wave triggers: behavioral signal threshold crossed
//   • Velocity circuit breaker: if daily volume > φ×average, throttle
//
// Architecture:
//   SENSUM (sensor layer)  — reads substrate demand, volume, health signals
//   COGITO (reasoning layer) — φ-weighted decision scoring
//   ACTIO (action layer)  — emits ACTION records consumed by other canisters
//   MEMORIA (memory layer) — rolling 30-epoch ledger of decisions + outcomes
//   VIGILIA (watchdog)    — monitors all sovereign canisters for health
//
// Decision cycle: runs on every heartbeat call (sovereign calls every N seconds)
// All decisions are recorded immutably. The AI never acts silently.
//
// Health score formula:
//   H = φ⁻¹ × (circulating/cap_ratio inverted) + φ⁻² × velocity_score
//      + φ⁻³ × governance_participation + φ⁻⁴ × developer_count_growth
//   H ∈ [0, 1]. H < φ⁻³ (≈0.236) triggers SOVEREIGN_ALERT.
//
// Token flow decisions:
//   EMIT_ECOSYSTEM   — trigger TOKEN_FORGE emission into ecosystem bucket
//   EMIT_AIRDROP     — unlock next airdrop wave in AIRDROP_ENGINE
//   BURN_PRESSURE    — recommend burn of treasury surplus
//   ROUTE_SUBSTRATE  — redistribute treasury to substrate-specific buckets
//   THROTTLE         — pause emission (velocity too high)
//   RELEASE          — resume after throttle
//   ALERT_SOVEREIGN  — health critical, notify

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor TokenIntelligence {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var heartbeatCount     : Nat       = 0;
  stable var lastHeartbeat      : Int       = 0;

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };
  func requireSovereign(caller : Principal) { assert(isSovereign(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "TOKEN_INTELLIGENCE_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-TOKEN-INTELLIGENCE-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };
  public query func getHeartbeatCount() : async Nat { heartbeatCount };

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

  // Alert threshold: H < φ⁻³ ≈ 0.236
  let HEALTH_ALERT_THRESHOLD : Float = _pow(PHI_INV, 3.0);
  // Velocity circuit breaker: volume > φ × rolling average
  let VELOCITY_BREAKER_MULT  : Float = PHI;
  // Burn pressure threshold: treasury > φ² × emission_rate
  let BURN_THRESHOLD_MULT    : Float = PHI * PHI;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — SENSUM (SENSOR LAYER)
  // The AI reads signals. Signals are fed by sovereign or by querying
  // sibling canisters. Each signal has a name, value, substrate, and timestamp.
  // ═══════════════════════════════════════════════════════════════════════════

  let SIGNAL_CAP : Nat = 2048;

  stable var signalCount     : Nat = 0;
  stable var signalNames     : [var Text]  = Array.init<Text>(SIGNAL_CAP,  "");
  stable var signalValues    : [var Float] = Array.init<Float>(SIGNAL_CAP, 0.0);
  stable var signalSubstrates: [var Text]  = Array.init<Text>(SIGNAL_CAP,  "ICP");
  stable var signalKinds     : [var Text]  = Array.init<Text>(SIGNAL_CAP,  "");
  // Kinds: VOLUME | DEMAND | PARTICIPATION | DEVELOPER_COUNT | BURN_RATE | HEALTH
  stable var signalTimes     : [var Int]   = Array.init<Int>(SIGNAL_CAP,   0);

  // Feed a signal into SENSUM (called by sovereign or automated heartbeat)
  public shared(msg) func feedSignal(
    name      : Text,
    value     : Float,
    substrate : Text,
    kind      : Text
  ) : async { success : Bool; signalId : Nat } {
    if (not isSovereign(msg.caller)) {
      // Non-sovereign can only feed non-privileged signals
      if (kind == "HEALTH" or kind == "BURN_RATE") return { success = false; signalId = 0 }
    };
    if (signalCount >= SIGNAL_CAP) return { success = false; signalId = 0 };
    let i = signalCount;
    signalNames[i]      := name;
    signalValues[i]     := value;
    signalSubstrates[i] := substrate;
    signalKinds[i]      := kind;
    signalTimes[i]      := Time.now();
    signalCount         := signalCount + 1;
    { success = true; signalId = i }
  };

  // Get latest signal value by name
  func _latestSignal(name : Text) : ?Float {
    var latest : ?Float = null;
    var latestTime : Int = 0;
    var i = 0;
    while (i < signalCount and i < SIGNAL_CAP) {
      if (signalNames[i] == name and signalTimes[i] >= latestTime) {
        latest     := ?signalValues[i];
        latestTime := signalTimes[i];
      };
      i += 1;
    };
    latest
  };

  // Average of last N signals matching kind
  func _avgSignalByKind(kind : Text, n : Nat) : Float {
    var sum : Float = 0.0;
    var count : Nat = 0;
    var i = signalCount;
    while (i > 0 and count < n) {
      i -= 1;
      if (i < SIGNAL_CAP and signalKinds[i] == kind) {
        sum   += signalValues[i];
        count += 1;
      };
    };
    if (count == 0) 0.0 else sum / Float.fromInt(count)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — COGITO (REASONING LAYER)
  // φ-weighted multi-dimensional health and decision scoring
  // ═══════════════════════════════════════════════════════════════════════════

  // Compute overall economy health score from fed signals
  // H = φ⁻¹×supply_health + φ⁻²×velocity_score + φ⁻³×governance + φ⁻⁴×dev_growth
  public query func computeHealthScore() : async {
    score           : Float;
    supplyHealth    : Float;
    velocityScore   : Float;
    governanceScore : Float;
    devGrowthScore  : Float;
    alert           : Bool;
    status          : Text;
  } {
    let supplyHealth    = _clamp(switch (_latestSignal("CIRCULATING_RATIO"))  { case null 0.5; case (?v) 1.0 - v }, 0.0, 1.0);
    let velocityScore   = _clamp(switch (_latestSignal("VELOCITY_NORMAL"))    { case null 0.5; case (?v) v },        0.0, 1.0);
    let governanceScore = _clamp(switch (_latestSignal("GOVERNANCE_PART"))    { case null 0.3; case (?v) v },        0.0, 1.0);
    let devGrowthScore  = _clamp(switch (_latestSignal("DEV_GROWTH"))         { case null 0.2; case (?v) v },        0.0, 1.0);
    let score =
      _pow(PHI_INV, 1.0) * supplyHealth +
      _pow(PHI_INV, 2.0) * velocityScore +
      _pow(PHI_INV, 3.0) * governanceScore +
      _pow(PHI_INV, 4.0) * devGrowthScore;
    let alert = score < HEALTH_ALERT_THRESHOLD;
    let status = if (score > 0.8) "EXCELLENT"
      else if (score > 0.6) "HEALTHY"
      else if (score > 0.4) "NOMINAL"
      else if (score > HEALTH_ALERT_THRESHOLD) "DEGRADED"
      else "CRITICAL";
    { score; supplyHealth; velocityScore; governanceScore; devGrowthScore; alert; status }
  };

  // Substrate demand weighting: returns φ-normalized weight per substrate
  public query func computeSubstrateDemand() : async [{
    substrate  : Text;
    rawDemand  : Float;
    weight     : Float;
    recommended: Text;  // INCREASE | HOLD | REDUCE
  }] {
    let substrates : [Text] = ["ICP", "BLOCKCHAIN", "EDGE", "CLOUD", "PHANTOM"];
    var raws : [Float] = Array.tabulate<Float>(5, func(_ : Nat) : Float { 0.0 });
    var raws : [Float] = Array.tabulate<Float>(5, func(_) 0.0);
    var i = 0;
    while (i < signalCount and i < SIGNAL_CAP) {
      if (signalKinds[i] == "DEMAND") {
        var si = 0;
        while (si < 5) {
          if (substrates[si] == signalSubstrates[i]) {
            raws := Array.tabulate<Float>(5, func(j) { if (j == si) signalValues[i] else raws[j] });
          };
          si += 1;
        };
      };
      i += 1;
    };
    var total : Float = 0.0;
    var j = 0;
    while (j < 5) { total += raws[j]; j += 1 };
    if (total < EPSILON) { total := 1.0 };
    let avgDemand = total / 5.0;
    Array.tabulate<{ substrate:Text; rawDemand:Float; weight:Float; recommended:Text }>(5, func(k) {
      let w = raws[k] / total;
      let rec = if (raws[k] > avgDemand * PHI) "INCREASE"
                else if (raws[k] < avgDemand * PHI_INV) "REDUCE"
                else "HOLD";
      { substrate = substrates[k]; rawDemand = raws[k]; weight = w; recommended = rec }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — ACTIO (ACTION LAYER)
  // Autonomous decisions — stored as immutable action records
  // Other canisters poll getReadyActions() and execute them
  // ═══════════════════════════════════════════════════════════════════════════

  let ACTION_CAP : Nat = 2048;

  stable var actionCount      : Nat = 0;
  stable var actionIds        : [var Nat]   = Array.init<Nat>(ACTION_CAP,   0);
  stable var actionKinds      : [var Text]  = Array.init<Text>(ACTION_CAP,  "");
  // Kinds: EMIT_ECOSYSTEM | EMIT_AIRDROP | BURN_PRESSURE | ROUTE_SUBSTRATE
  //        THROTTLE | RELEASE | ALERT_SOVEREIGN | GRANT_WAVE | VEST_ACCELERATE
  stable var actionParams     : [var Text]  = Array.init<Text>(ACTION_CAP,  "");  // JSON-encoded params
  stable var actionScores     : [var Float] = Array.init<Float>(ACTION_CAP, 0.0); // decision score
  stable var actionStatuses   : [var Text]  = Array.init<Text>(ACTION_CAP,  "READY");
  // Statuses: READY | EXECUTING | DONE | CANCELLED
  stable var actionCreatedAt  : [var Int]   = Array.init<Int>(ACTION_CAP,   0);
  stable var actionExecutedAt : [var Int]   = Array.init<Int>(ACTION_CAP,   0);
  stable var actionReasons    : [var Text]  = Array.init<Text>(ACTION_CAP,  "");
  stable var nextActionId     : Nat         = 1;

  // Throttle state
  stable var throttleActive   : Bool = false;
  stable var throttleReason   : Text = "";
  stable var throttleAt       : Int  = 0;

  func _emitAction(kind : Text, params : Text, score : Float, reason : Text) {
    if (actionCount >= ACTION_CAP) return;
    let i = actionCount;
    actionIds[i]        := nextActionId;
    actionKinds[i]      := kind;
    actionParams[i]     := params;
    actionScores[i]     := score;
    actionStatuses[i]   := "READY";
    actionCreatedAt[i]  := Time.now();
    actionExecutedAt[i] := 0;
    actionReasons[i]    := reason;
    actionCount         := actionCount + 1;
    nextActionId        := nextActionId + 1;
  };

  // ── Main heartbeat: runs decision cycle ───────────────────────────────────
  // Sovereign (or automated timer canister) calls this periodically.
  // Returns all actions generated this cycle.
  public shared(msg) func heartbeat() : async {
    cycle        : Nat;
    actionsEmitted: Nat;
    healthScore  : Float;
    healthStatus : Text;
    throttle     : Bool;
    alert        : Bool;
    actions      : [{ id:Nat; kind:Text; params:Text; score:Float; reason:Text }];
  } {
    if (not isSovereign(msg.caller)) return {
      cycle = heartbeatCount; actionsEmitted = 0; healthScore = 0.0;
      healthStatus = "UNAUTHORIZED"; throttle = throttleActive; alert = false; actions = []
    };
    let cycleStart = actionCount;
    heartbeatCount := heartbeatCount + 1;
    lastHeartbeat  := Time.now();

    // ── 1. Compute health ─────────────────────────────────────────────────
    let supplyHealth    = _clamp(switch (_latestSignal("CIRCULATING_RATIO"))  { case null 0.5; case (?v) 1.0 - v }, 0.0, 1.0);
    let velocityScore   = _clamp(switch (_latestSignal("VELOCITY_NORMAL"))    { case null 0.5; case (?v) v },        0.0, 1.0);
    let governanceScore = _clamp(switch (_latestSignal("GOVERNANCE_PART"))    { case null 0.3; case (?v) v },        0.0, 1.0);
    let devGrowthScore  = _clamp(switch (_latestSignal("DEV_GROWTH"))         { case null 0.2; case (?v) v },        0.0, 1.0);
    let healthScore =
      _pow(PHI_INV, 1.0) * supplyHealth +
      _pow(PHI_INV, 2.0) * velocityScore +
      _pow(PHI_INV, 3.0) * governanceScore +
      _pow(PHI_INV, 4.0) * devGrowthScore;
    let alert = healthScore < HEALTH_ALERT_THRESHOLD;
    let healthStatus = if (healthScore > 0.8) "EXCELLENT"
      else if (healthScore > 0.6) "HEALTHY"
      else if (healthScore > 0.4) "NOMINAL"
      else if (healthScore > HEALTH_ALERT_THRESHOLD) "DEGRADED"
      else "CRITICAL";

    // ── 2. Velocity circuit breaker ───────────────────────────────────────
    let currentVol  = switch (_latestSignal("DAILY_VOLUME"))  { case null 0.0; case (?v) v };
    let avgVol      = _avgSignalByKind("VOLUME", 30);
    if (currentVol > avgVol * VELOCITY_BREAKER_MULT and not throttleActive) {
      throttleActive := true;
      throttleReason := "VELOCITY_BREAKER: volume " # Float.toText(currentVol) # " > " # Float.toText(avgVol * VELOCITY_BREAKER_MULT);
      throttleAt     := Time.now();
      _emitAction("THROTTLE", "{\"reason\":\"velocity\"}", 0.95,
        "Daily volume " # Float.toText(currentVol) # " exceeds φ×avg " # Float.toText(avgVol * VELOCITY_BREAKER_MULT));
    } else if (throttleActive and currentVol <= avgVol) {
      throttleActive := false;
      _emitAction("RELEASE", "{\"reason\":\"velocity_normalized\"}", 0.8, "Volume normalized, releasing throttle");
    };

    // ── 3. Emission decision (only if not throttled) ──────────────────────
    if (not throttleActive) {
      // Emit ecosystem tokens if governance participation is high (signal the forge)
      if (governanceScore > 0.6) {
        let emitScore = healthScore * governanceScore;
        _emitAction("EMIT_ECOSYSTEM",
          "{\"bucket\":\"ECOSYSTEM\",\"trigger\":\"governance_participation\"}",
          emitScore,
          "Governance participation " # Float.toText(governanceScore) # " > 0.6, trigger ecosystem emission"
        );
      };
      // Trigger airdrop wave if dev growth is accelerating
      if (devGrowthScore > 0.5 and healthScore > 0.4) {
        _emitAction("EMIT_AIRDROP",
          "{\"trigger\":\"dev_growth\",\"wave\":\"NEXT\"}",
          devGrowthScore * healthScore,
          "Developer growth " # Float.toText(devGrowthScore) # " crossed 0.5 threshold"
        );
      };
    };

    // ── 4. Burn pressure ──────────────────────────────────────────────────
    let treasuryRatio = switch (_latestSignal("TREASURY_RATIO")) { case null 0.0; case (?v) v };
    if (treasuryRatio > _pow(PHI_INV, 2.0)) {  // treasury > φ⁻² of supply
      _emitAction("BURN_PRESSURE",
        "{\"ratio\":" # Float.toText(treasuryRatio) # "}",
        treasuryRatio,
        "Treasury ratio " # Float.toText(treasuryRatio) # " exceeds φ⁻² threshold — apply burn pressure"
      );
    };

    // ── 5. Substrate routing ──────────────────────────────────────────────
    let icpDemand     = switch (_latestSignal("ICP_DEMAND"))     { case null 0.2; case (?v) v };
    let edgeDemand    = switch (_latestSignal("EDGE_DEMAND"))    { case null 0.2; case (?v) v };
    let phantomDemand = switch (_latestSignal("PHANTOM_DEMAND")) { case null 0.2; case (?v) v };
    if (edgeDemand > icpDemand * PHI) {
      _emitAction("ROUTE_SUBSTRATE",
        "{\"from\":\"ICP\",\"to\":\"EDGE\",\"weight\":" # Float.toText(edgeDemand) # "}",
        edgeDemand,
        "EDGE demand " # Float.toText(edgeDemand) # " exceeds ICP demand × φ — reroute"
      );
    };
    if (phantomDemand > icpDemand * PHI * PHI) {
      _emitAction("ROUTE_SUBSTRATE",
        "{\"from\":\"ICP\",\"to\":\"PHANTOM\",\"weight\":" # Float.toText(phantomDemand) # "}",
        phantomDemand,
        "PHANTOM demand " # Float.toText(phantomDemand) # " exceeds ICP demand × φ² — sovereign reroute"
      );
    };

    // ── 6. Health alert ───────────────────────────────────────────────────
    if (alert) {
      _emitAction("ALERT_SOVEREIGN",
        "{\"health\":" # Float.toText(healthScore) # ",\"status\":\"" # healthStatus # "\"}",
        1.0,
        "CRITICAL: health score " # Float.toText(healthScore) # " below φ⁻³ threshold " # Float.toText(HEALTH_ALERT_THRESHOLD)
      );
    };

    // Return actions emitted this cycle
    let newCount = actionCount - cycleStart;
    let emitted  = Array.tabulate<{ id:Nat; kind:Text; params:Text; score:Float; reason:Text }>(
      if (newCount > 20) 20 else newCount,
      func(j) {
        let idx = cycleStart + j;
        { id = actionIds[idx]; kind = actionKinds[idx]; params = actionParams[idx]; score = actionScores[idx]; reason = actionReasons[idx] }
      }
    );
    { cycle = heartbeatCount; actionsEmitted = newCount; healthScore; healthStatus; throttle = throttleActive; alert; actions = emitted }
  };

  // ── Get ready actions (for sibling canisters to poll and execute) ─────────
  public query func getReadyActions(limit : Nat) : async [{
    id     : Nat;
    kind   : Text;
    params : Text;
    score  : Float;
    reason : Text;
    createdAt : Int;
  }] {
    var result : [{ id:Nat; kind:Text; params:Text; score:Float; reason:Text; createdAt:Int }] = [];
    var i = 0;
    while (i < actionCount and i < ACTION_CAP and result.size() < limit) {
      if (actionStatuses[i] == "READY") {
        result := Array.append(result, [{
          id = actionIds[i]; kind = actionKinds[i]; params = actionParams[i];
          score = actionScores[i]; reason = actionReasons[i]; createdAt = actionCreatedAt[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // Mark action as executing (transition READY → EXECUTING)
  // Callers poll getReadyActions() then claim one before running it.
  // On ICP, each update call is processed atomically — the canister processes
  // one message at a time, so concurrent claim attempts are automatically
  // serialized by the IC runtime (no true race condition is possible).
  public shared(_msg) func markActionExecuting(actionId : Nat) : async Bool {
    var i = 0;
    while (i < actionCount and i < ACTION_CAP) {
      if (actionIds[i] == actionId and actionStatuses[i] == "READY") {
        actionStatuses[i]   := "EXECUTING";
        actionExecutedAt[i] := Time.now();
        return true;
      };
      i += 1;
    };
    false
  };

  // Mark action as executed (accepts READY or EXECUTING → DONE)
  public shared(msg) func markActionDone(actionId : Nat) : async Bool {
    var i = 0;
    while (i < actionCount and i < ACTION_CAP) {
      if (actionIds[i] == actionId and
          (actionStatuses[i] == "READY" or actionStatuses[i] == "EXECUTING")) {
  // Mark action as executed
  public shared(msg) func markActionDone(actionId : Nat) : async Bool {
    var i = 0;
    while (i < actionCount and i < ACTION_CAP) {
      if (actionIds[i] == actionId and actionStatuses[i] == "READY") {
        actionStatuses[i]   := "DONE";
        actionExecutedAt[i] := Time.now();
        return true;
      };
      i += 1;
    };
    false
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — MEMORIA (DECISION MEMORY)
  // Rolling epoch ledger: records health scores per epoch for trend analysis
  // ═══════════════════════════════════════════════════════════════════════════

  let EPOCH_CAP : Nat = 128;  // 30 epochs rolling + overflow buffer

  stable var epochCount        : Nat = 0;
  stable var epochHealthScores : [var Float] = Array.init<Float>(EPOCH_CAP, 0.0);
  stable var epochActionsEmit  : [var Nat]   = Array.init<Nat>(EPOCH_CAP,   0);
  stable var epochTimes        : [var Int]   = Array.init<Int>(EPOCH_CAP,   0);
  stable var epochStatus       : [var Text]  = Array.init<Text>(EPOCH_CAP,  "NORMAL");

  // Record epoch snapshot (sovereign calls after heartbeat)
  public shared(msg) func recordEpoch(healthScore : Float, actionsEmitted : Nat, status : Text) : async Nat {
    requireSovereign(msg.caller);
    let i = Nat.rem(epochCount, EPOCH_CAP);  // rolling overwrite
    epochHealthScores[i] := healthScore;
    epochActionsEmit[i]  := actionsEmitted;
    epochTimes[i]        := Time.now();
    epochStatus[i]       := status;
    epochCount           := epochCount + 1;
    epochCount
  };

  // Get trend: last N epoch health scores
  public query func getHealthTrend(n : Nat) : async [{ epoch:Nat; health:Float; status:Text; time:Int }] {
    let total = if (n < epochCount) n else epochCount;
    let cap   = if (epochCount < EPOCH_CAP) epochCount else EPOCH_CAP;
    Array.tabulate<{ epoch:Nat; health:Float; status:Text; time:Int }>(
      if (total > cap) cap else total,
      func(j) {
        let i = Nat.rem(epochCount + EPOCH_CAP - total + j, EPOCH_CAP);
        { epoch = epochCount - total + j; health = epochHealthScores[i]; status = epochStatus[i]; time = epochTimes[i] }
      }
    )
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — VIGILIA (WATCHDOG)
  // Sovereign canister health monitoring — ping any registered canister endpoint
  // ═══════════════════════════════════════════════════════════════════════════

  let WATCH_CAP : Nat = 64;

  stable var watchCount        : Nat = 0;
  stable var watchIds          : [var Nat]   = Array.init<Nat>(WATCH_CAP,   0);
  stable var watchNames        : [var Text]  = Array.init<Text>(WATCH_CAP,  "");
  stable var watchPrincipals   : [var Text]  = Array.init<Text>(WATCH_CAP,  "");
  stable var watchLastPing     : [var Int]   = Array.init<Int>(WATCH_CAP,   0);
  stable var watchStatuses     : [var Text]  = Array.init<Text>(WATCH_CAP,  "UNKNOWN");
  stable var watchMissedPings  : [var Nat]   = Array.init<Nat>(WATCH_CAP,   0);
  stable var nextWatchId       : Nat         = 1;

  // Register a canister for health monitoring
  public shared(msg) func registerWatch(name : Text, canisterPrincipal : Text) : async {
    success : Bool;
    watchId : Nat;
  } {
    requireSovereign(msg.caller);
    if (watchCount >= WATCH_CAP) return { success = false; watchId = 0 };
    let wi = watchCount;
    watchIds[wi]         := nextWatchId;
    watchNames[wi]       := name;
    watchPrincipals[wi]  := canisterPrincipal;
    watchLastPing[wi]    := Time.now();
    watchStatuses[wi]    := "WATCHING";
    watchMissedPings[wi] := 0;
    watchCount           := watchCount + 1;
    let id = nextWatchId;
    nextWatchId          := nextWatchId + 1;
    { success = true; watchId = id }
  };

  // Report canister ping result
  public shared(msg) func reportPing(watchId : Nat, alive : Bool) : async Bool {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < watchCount and i < WATCH_CAP) {
      if (watchIds[i] == watchId) {
        watchLastPing[i] := Time.now();
        if (alive) {
          watchStatuses[i]     := "ALIVE";
          watchMissedPings[i]  := 0;
        } else {
          watchMissedPings[i]  := watchMissedPings[i] + 1;
          watchStatuses[i]     := if (watchMissedPings[i] >= 3) "DEAD" else "DEGRADED";
          // Emit alert action for dead canister
          if (watchMissedPings[i] >= 3) {
            _emitAction("ALERT_SOVEREIGN",
              "{\"canister\":\"" # watchNames[i] # "\",\"missed\":" # Nat.toText(watchMissedPings[i]) # "}",
              1.0, "WATCHDOG: " # watchNames[i] # " missed " # Nat.toText(watchMissedPings[i]) # " pings"
            );
          };
        };
        return true;
      };
      i += 1;
    };
    false
  };

  public query func getWatchList() : async [{
    watchId      : Nat;
    name         : Text;
    canister     : Text;
    status       : Text;
    missedPings  : Nat;
    lastPing     : Int;
  }] {
    Array.tabulate<{ watchId:Nat; name:Text; canister:Text; status:Text; missedPings:Nat; lastPing:Int }>(watchCount, func(i) {
      { watchId = watchIds[i]; name = watchNames[i]; canister = watchPrincipals[i]; status = watchStatuses[i]; missedPings = watchMissedPings[i]; lastPing = watchLastPing[i] }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getIntelligenceStatus() : async {
    seal            : Text;
    claimed         : Bool;
    heartbeatCount  : Nat;
    lastHeartbeat   : Int;
    signalCount     : Nat;
    actionCount     : Nat;
    epochCount      : Nat;
    watchCount      : Nat;
    throttleActive  : Bool;
    throttleReason  : Text;
    phi             : Float;
    alertThreshold  : Float;
    architecture    : Text;
  } {
    {
      seal           = sovereignSeal;
      claimed        = genesisLocked;
      heartbeatCount = heartbeatCount;
      lastHeartbeat  = lastHeartbeat;
      signalCount    = signalCount;
      actionCount    = actionCount;
      epochCount     = epochCount;
      watchCount     = watchCount;
      throttleActive = throttleActive;
      throttleReason = throttleReason;
      phi            = PHI;
      alertThreshold = HEALTH_ALERT_THRESHOLD;
      architecture   = "SENSUM→COGITO→ACTIO(READY→EXECUTING→DONE) | MEMORIA (128-epoch) | VIGILIA (64-node watchdog)";
      architecture   = "SENSUM→COGITO→ACTIO | MEMORIA (128-epoch) | VIGILIA (64-node watchdog)";
    }
  };

};
