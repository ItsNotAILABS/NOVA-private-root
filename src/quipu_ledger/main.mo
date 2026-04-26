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
// QUIPU LEDGER — Digital Quipu: Canonical Cross-Canister Telemetry Log
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// THE QUIPU LEDGER IS NOVA'S STRING MEMORY.
// Inspired by the Inca quipu — a typed, hierarchical, append-only fiber database
// that was simultaneously a ledger AND an executable instruction set (tribute,
// labor, logistics). The same device that stored state also drove action.
//
// Architecture maps to quipu structure:
//   SPINE     (main cord)      → top-level domain category (ECONOMY, ROUTING, etc.)
//   PENDANT   (pendant cord)   → event field/record type (SIGNAL, ACTION, TELEMETRY)
//   SUBSIDIARY(subsidiary cord)→ nested sub-entries (depth 0=top, 1=sub, 2=sub-sub)
//   KNOT      (knot value)     → numeric magnitude, positionally encoded
//   COLOR     (cord color)     → type system tag (sub-token, substrate, or entity name)
//
// Record lifecycle (executable semantics — quipu as bytecode, not just ledger):
//   PENDING → EXECUTING → SETTLED
//   PENDING   — written, not yet consumed
//   EXECUTING — a canister has claimed this record and is processing it
//   SETTLED   — execution confirmed, record becomes immutable audit trail
//   CANCELLED — record voided before execution
//
// Spine domains:
//   ECONOMY   — token flows, revenue, emissions, burns
//   ROUTING   — substrate mesh events, tambo relays, route decisions
//   PRODUCTION — production ticks, organism output, work records
//   GOVERNANCE — votes, proposals, NNS maturity, neuron events
//   SENTINEL   — health alerts, watchdog events, anomalies
//   QUIPU_META — quipu self-referential records (log-of-log)
//
// Pendant types (record categories):
//   SIGNAL   — sensor input (from SENSUM layer)
//   ACTION   — decision output (from ACTIO layer)
//   TELEMETRY— live metrics from any organism canister
//   TRIBUTE  — value transfer (ICP, ONESICANS, sub-tokens)
//   RELAY    — tambo waystation message transit
//   ARTIFACT — produced goods (WASM, docs, compute units)
//
// Color tags (type system on fiber):
//   Sub-tokens: CHR | SCB | ARC | NXS | SWM | PHT | ORS | GOL
//   Substrates: ICP | BLOCKCHAIN | EDGE | CLOUD | PHANTOM
//   Organisms:  CHRYSALIS | SCRIBE | ARCHITECT | NEXUS | SWARM_BRAIN
//   Special:    SOVEREIGN | QUIPU | UNKNOWN

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor QuipuLedger {

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
    if (genesisLocked) return "QUIPU_LEDGER_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-QUIPU-LEDGER-BUILD30-" # Principal.toText(msg.caller);
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

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — QUIPU RECORD STORE
  // Parallel stable arrays — each index is one quipu record (one "knot")
  // ═══════════════════════════════════════════════════════════════════════════

  let QUIPU_CAP : Nat = 8192;  // F(19)=4181 rounded up to power-of-2 zone

  // Structural fields (the quipu's fiber geometry)
  stable var quipuCount        : Nat = 0;
  stable var quipuIds          : [var Nat]   = Array.init<Nat>(QUIPU_CAP,   0);
  stable var quipuSpines       : [var Text]  = Array.init<Text>(QUIPU_CAP,  ""); // main cord domain
  stable var quipuPendants     : [var Text]  = Array.init<Text>(QUIPU_CAP,  ""); // pendant type
  stable var quipuDepths       : [var Nat]   = Array.init<Nat>(QUIPU_CAP,   0);  // subsidiary depth
  stable var quipuValues       : [var Float] = Array.init<Float>(QUIPU_CAP, 0.0);// knot value
  stable var quipuColorTags    : [var Text]  = Array.init<Text>(QUIPU_CAP,  ""); // type system tag
  stable var quipuEmitters     : [var Text]  = Array.init<Text>(QUIPU_CAP,  ""); // source canister/entity
  stable var quipuReasons      : [var Text]  = Array.init<Text>(QUIPU_CAP,  ""); // human-readable
  stable var quipuStatuses     : [var Text]  = Array.init<Text>(QUIPU_CAP,  "PENDING");
  // Statuses: PENDING | EXECUTING | SETTLED | CANCELLED
  stable var quipuCreatedAt    : [var Int]   = Array.init<Int>(QUIPU_CAP,   0);
  stable var quipuExecutedAt   : [var Int]   = Array.init<Int>(QUIPU_CAP,   0);
  stable var quipuSettledAt    : [var Int]   = Array.init<Int>(QUIPU_CAP,   0);
  stable var quipuParentIds    : [var Nat]   = Array.init<Nat>(QUIPU_CAP,   0);  // 0 = no parent
  stable var nextQuipuId       : Nat         = 1;

  // Aggregate counters per spine domain
  stable var economyCount    : Nat = 0;
  stable var routingCount    : Nat = 0;
  stable var productionCount : Nat = 0;
  stable var governanceCount : Nat = 0;
  stable var sentinelCount   : Nat = 0;
  stable var quipuMetaCount  : Nat = 0;

  // Total value transacted through the ledger (sum of all knot values)
  stable var totalKnotValue : Float = 0.0;

  // ── Validation helpers ────────────────────────────────────────────────────

  func _isValidSpine(s : Text) : Bool {
    s == "ECONOMY" or s == "ROUTING" or s == "PRODUCTION" or
    s == "GOVERNANCE" or s == "SENTINEL" or s == "QUIPU_META"
  };

  func _isValidPendant(p : Text) : Bool {
    p == "SIGNAL" or p == "ACTION" or p == "TELEMETRY" or
    p == "TRIBUTE" or p == "RELAY" or p == "ARTIFACT"
  };

  func _incrementSpineCounter(spine : Text) {
    if      (spine == "ECONOMY")    { economyCount    += 1 }
    else if (spine == "ROUTING")    { routingCount    += 1 }
    else if (spine == "PRODUCTION") { productionCount += 1 }
    else if (spine == "GOVERNANCE") { governanceCount += 1 }
    else if (spine == "SENTINEL")   { sentinelCount   += 1 }
    else if (spine == "QUIPU_META") { quipuMetaCount  += 1 };
  };

  // ── Find record by ID ─────────────────────────────────────────────────────
  func _findQuipu(id : Nat) : ?Nat {
    var i = 0;
    while (i < quipuCount and i < QUIPU_CAP) {
      if (quipuIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — WRITE API (append-only)
  // ═══════════════════════════════════════════════════════════════════════════

  // Append a new quipu record (any caller, open write — sovereign may restrict later)
  public shared(_msg) func appendRecord(
    spine     : Text,   // e.g. "ECONOMY"
    pendant   : Text,   // e.g. "ACTION"
    depth     : Nat,    // subsidiary depth 0–3
    value     : Float,  // knot value (magnitude/priority)
    colorTag  : Text,   // type tag (sub-token, substrate, organism)
    emitter   : Text,   // source canister name or principal
    reason    : Text,   // human-readable description
    parentId  : Nat     // 0 for top-level; ID of parent for subsidiaries
  ) : async { success : Bool; quipuId : Nat } {
    if (quipuCount >= QUIPU_CAP)   return { success = false; quipuId = 0 };
    if (not _isValidSpine(spine))  return { success = false; quipuId = 0 };
    if (not _isValidPendant(pendant)) return { success = false; quipuId = 0 };

    let i  = quipuCount;
    let id = nextQuipuId;
    let now = Time.now();

    quipuIds[i]        := id;
    quipuSpines[i]     := spine;
    quipuPendants[i]   := pendant;
    quipuDepths[i]     := if (depth > 3) 3 else depth;
    quipuValues[i]     := value;
    quipuColorTags[i]  := colorTag;
    quipuEmitters[i]   := emitter;
    quipuReasons[i]    := reason;
    quipuStatuses[i]   := "PENDING";
    quipuCreatedAt[i]  := now;
    quipuExecutedAt[i] := 0;
    quipuSettledAt[i]  := 0;
    quipuParentIds[i]  := parentId;

    quipuCount         := quipuCount + 1;
    nextQuipuId        := nextQuipuId + 1;
    totalKnotValue     := totalKnotValue + value;
    _incrementSpineCounter(spine);

    { success = true; quipuId = id }
  };

  // Append a sovereign-priority record (marked immediately EXECUTING)
  // Used by AGI_MAIN and TOKEN_INTELLIGENCE for urgent instructions
  public shared(msg) func appendExecutive(
    spine    : Text,
    pendant  : Text,
    depth    : Nat,
    value    : Float,
    colorTag : Text,
    emitter  : Text,
    reason   : Text,
    parentId : Nat
  ) : async { success : Bool; quipuId : Nat } {
    requireSovereign(msg.caller);
    if (quipuCount >= QUIPU_CAP)      return { success = false; quipuId = 0 };
    if (not _isValidSpine(spine))     return { success = false; quipuId = 0 };
    if (not _isValidPendant(pendant)) return { success = false; quipuId = 0 };

    let i  = quipuCount;
    let id = nextQuipuId;
    let now = Time.now();

    quipuIds[i]        := id;
    quipuSpines[i]     := spine;
    quipuPendants[i]   := pendant;
    quipuDepths[i]     := if (depth > 3) 3 else depth;
    quipuValues[i]     := value;
    quipuColorTags[i]  := colorTag;
    quipuEmitters[i]   := emitter;
    quipuReasons[i]    := reason;
    quipuStatuses[i]   := "EXECUTING";  // sovereign records are immediately active
    quipuCreatedAt[i]  := now;
    quipuExecutedAt[i] := now;
    quipuSettledAt[i]  := 0;
    quipuParentIds[i]  := parentId;

    quipuCount         := quipuCount + 1;
    nextQuipuId        := nextQuipuId + 1;
    totalKnotValue     := totalKnotValue + value;
    _incrementSpineCounter(spine);

    { success = true; quipuId = id }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — EXECUTABLE LIFECYCLE (PENDING → EXECUTING → SETTLED)
  // The quipu is not just a ledger — it drives action.
  // These transitions make every record an executable instruction.
  // ═══════════════════════════════════════════════════════════════════════════

  // Claim a PENDING record for execution (transition → EXECUTING)
  // On ICP, each update call is processed atomically — the canister processes
  // one message at a time, so concurrent claim attempts are automatically
  // serialized by the IC runtime (no true race condition is possible within
  // a single actor; the first caller to arrive wins the PENDING→EXECUTING transition).
  public shared(_msg) func claimRecord(quipuId : Nat, executor : Text) : async {
    success : Bool;
    status  : Text;
  } {
    switch (_findQuipu(quipuId)) {
      case null { { success = false; status = "NOT_FOUND" } };
      case (?i) {
        if (quipuStatuses[i] != "PENDING") {
          return { success = false; status = quipuStatuses[i] }
        };
        quipuStatuses[i]   := "EXECUTING";
        quipuExecutedAt[i] := Time.now();
        quipuEmitters[i]   := quipuEmitters[i] # " → " # executor;
        { success = true; status = "EXECUTING" }
      };
    }
  };

  // Settle an EXECUTING record (transition → SETTLED, immutable audit trail)
  public shared(_msg) func settleRecord(quipuId : Nat, outcome : Text) : async {
    success : Bool;
    status  : Text;
  } {
    switch (_findQuipu(quipuId)) {
      case null { { success = false; status = "NOT_FOUND" } };
      case (?i) {
        if (quipuStatuses[i] != "EXECUTING") {
          return { success = false; status = quipuStatuses[i] }
        };
        quipuStatuses[i]  := "SETTLED";
        quipuSettledAt[i] := Time.now();
        quipuReasons[i]   := quipuReasons[i] # " | SETTLED: " # outcome;
        { success = true; status = "SETTLED" }
      };
    }
  };

  // Cancel a PENDING record (transition → CANCELLED)
  public shared(msg) func cancelRecord(quipuId : Nat, reason : Text) : async Bool {
    requireSovereign(msg.caller);
    switch (_findQuipu(quipuId)) {
      case null false;
      case (?i) {
        if (quipuStatuses[i] != "PENDING") return false;
        quipuStatuses[i] := "CANCELLED";
        quipuReasons[i]  := quipuReasons[i] # " | CANCELLED: " # reason;
        true
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — QUERY API
  // ═══════════════════════════════════════════════════════════════════════════

  // Get a single record by ID
  public query func getRecord(id : Nat) : async ?{
    quipuId    : Nat;
    spine      : Text;
    pendant    : Text;
    depth      : Nat;
    value      : Float;
    colorTag   : Text;
    emitter    : Text;
    reason     : Text;
    status     : Text;
    createdAt  : Int;
    executedAt : Int;
    settledAt  : Int;
    parentId   : Nat;
  } {
    switch (_findQuipu(id)) {
      case null null;
      case (?i) {
        ?{
          quipuId    = quipuIds[i];
          spine      = quipuSpines[i];
          pendant    = quipuPendants[i];
          depth      = quipuDepths[i];
          value      = quipuValues[i];
          colorTag   = quipuColorTags[i];
          emitter    = quipuEmitters[i];
          reason     = quipuReasons[i];
          status     = quipuStatuses[i];
          createdAt  = quipuCreatedAt[i];
          executedAt = quipuExecutedAt[i];
          settledAt  = quipuSettledAt[i];
          parentId   = quipuParentIds[i];
        }
      };
    }
  };

  // Get all PENDING records (the instruction queue — what the empire "runs" next)
  public query func getPendingRecords(limit : Nat) : async [{
    quipuId  : Nat;
    spine    : Text;
    pendant  : Text;
    value    : Float;
    colorTag : Text;
    emitter  : Text;
    reason   : Text;
    createdAt: Int;
  }] {
    var result : [{ quipuId:Nat; spine:Text; pendant:Text; value:Float; colorTag:Text; emitter:Text; reason:Text; createdAt:Int }] = [];
    var i = 0;
    while (i < quipuCount and i < QUIPU_CAP and result.size() < limit) {
      if (quipuStatuses[i] == "PENDING") {
        result := Array.append(result, [{
          quipuId   = quipuIds[i];
          spine     = quipuSpines[i];
          pendant   = quipuPendants[i];
          value     = quipuValues[i];
          colorTag  = quipuColorTags[i];
          emitter   = quipuEmitters[i];
          reason    = quipuReasons[i];
          createdAt = quipuCreatedAt[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // Get records by spine domain
  public query func getBySpine(spine : Text, limit : Nat) : async [{
    quipuId  : Nat;
    pendant  : Text;
    depth    : Nat;
    value    : Float;
    colorTag : Text;
    status   : Text;
    createdAt: Int;
  }] {
    var result : [{ quipuId:Nat; pendant:Text; depth:Nat; value:Float; colorTag:Text; status:Text; createdAt:Int }] = [];
    var i = 0;
    while (i < quipuCount and i < QUIPU_CAP and result.size() < limit) {
      if (quipuSpines[i] == spine) {
        result := Array.append(result, [{
          quipuId   = quipuIds[i];
          pendant   = quipuPendants[i];
          depth     = quipuDepths[i];
          value     = quipuValues[i];
          colorTag  = quipuColorTags[i];
          status    = quipuStatuses[i];
          createdAt = quipuCreatedAt[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // Get subsidiary records for a parent (drill down one level)
  public query func getSubsidiaries(parentId : Nat) : async [{
    quipuId  : Nat;
    depth    : Nat;
    value    : Float;
    colorTag : Text;
    reason   : Text;
    status   : Text;
  }] {
    var result : [{ quipuId:Nat; depth:Nat; value:Float; colorTag:Text; reason:Text; status:Text }] = [];
    var i = 0;
    while (i < quipuCount and i < QUIPU_CAP) {
      if (quipuParentIds[i] == parentId and parentId != 0) {
        result := Array.append(result, [{
          quipuId  = quipuIds[i];
          depth    = quipuDepths[i];
          value    = quipuValues[i];
          colorTag = quipuColorTags[i];
          reason   = quipuReasons[i];
          status   = quipuStatuses[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // Get records by color tag (type system query — "show me all CHR flows")
  public query func getByColorTag(tag : Text, limit : Nat) : async [{
    quipuId : Nat;
    spine   : Text;
    pendant : Text;
    value   : Float;
    status  : Text;
    reason  : Text;
  }] {
    var result : [{ quipuId:Nat; spine:Text; pendant:Text; value:Float; status:Text; reason:Text }] = [];
    var i = 0;
    while (i < quipuCount and i < QUIPU_CAP and result.size() < limit) {
      if (quipuColorTags[i] == tag) {
        result := Array.append(result, [{
          quipuId = quipuIds[i];
          spine   = quipuSpines[i];
          pendant = quipuPendants[i];
          value   = quipuValues[i];
          status  = quipuStatuses[i];
          reason  = quipuReasons[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — COMPRESSION ANALYTICS
  // The quipu compresses reality at ratio φ — each layer of hierarchy
  // reduces information volume by φ⁻¹ while preserving full fidelity.
  // ═══════════════════════════════════════════════════════════════════════════

  // Compute compression ratio of the ledger (information density metric)
  // Ratio = total records / distinct (spine, pendant) pairs → how dense is the encoding?
  public query func getCompressionMetrics() : async {
    totalRecords     : Nat;
    pendingCount     : Nat;
    executingCount   : Nat;
    settledCount     : Nat;
    cancelledCount   : Nat;
    totalKnotValue   : Float;
    avgValuePerRecord: Float;
    compressionRatio : Float;  // records / distinct categories (φ-normalized)
    phi              : Float;
    spineBreakdown   : {
      economy    : Nat;
      routing    : Nat;
      production : Nat;
      governance : Nat;
      sentinel   : Nat;
      quipuMeta  : Nat;
    };
  } {
    var pending   : Nat = 0;
    var executing : Nat = 0;
    var settled   : Nat = 0;
    var cancelled : Nat = 0;
    var i = 0;
    while (i < quipuCount and i < QUIPU_CAP) {
      if      (quipuStatuses[i] == "PENDING")   { pending   += 1 }
      else if (quipuStatuses[i] == "EXECUTING") { executing += 1 }
      else if (quipuStatuses[i] == "SETTLED")   { settled   += 1 }
      else if (quipuStatuses[i] == "CANCELLED") { cancelled += 1 };
      i += 1;
    };
    let avgVal = if (quipuCount == 0) 0.0
                 else totalKnotValue / Float.fromInt(quipuCount);
    // Compression ratio: records vs. 6 spines × 6 pendants = 36 distinct categories
    let distinctCategories : Float = 36.0;
    let ratio = if (distinctCategories < EPSILON) 0.0
                else Float.fromInt(quipuCount) / (distinctCategories * PHI);
    {
      totalRecords      = quipuCount;
      pendingCount      = pending;
      executingCount    = executing;
      settledCount      = settled;
      cancelledCount    = cancelled;
      totalKnotValue    = totalKnotValue;
      avgValuePerRecord = avgVal;
      compressionRatio  = ratio;
      phi               = PHI;
      spineBreakdown    = {
        economy    = economyCount;
        routing    = routingCount;
        production = productionCount;
        governance = governanceCount;
        sentinel   = sentinelCount;
        quipuMeta  = quipuMetaCount;
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — PROTOCOL CONSTANTS (quipu schema reference)
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getSpineDomains() : async [Text] {
    ["ECONOMY", "ROUTING", "PRODUCTION", "GOVERNANCE", "SENTINEL", "QUIPU_META"]
  };

  public query func getPendantTypes() : async [Text] {
    ["SIGNAL", "ACTION", "TELEMETRY", "TRIBUTE", "RELAY", "ARTIFACT"]
  };

  public query func getColorTags() : async {
    subTokens  : [Text];
    substrates : [Text];
    organisms  : [Text];
    special    : [Text];
  } {
    {
      subTokens  = ["CHR", "SCB", "ARC", "NXS", "SWM", "PHT", "ORS", "GOL"];
      substrates = ["ICP", "BLOCKCHAIN", "EDGE", "CLOUD", "PHANTOM"];
      organisms  = ["CHRYSALIS", "SCRIBE", "ARCHITECT", "NEXUS", "SWARM_BRAIN"];
      special    = ["SOVEREIGN", "QUIPU", "UNKNOWN"];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 — STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getQuipuStatus() : async {
    seal            : Text;
    claimed         : Bool;
    recordCount     : Nat;
    capacity        : Nat;
    fillPct         : Float;
    totalKnotValue  : Float;
    phi             : Float;
    architecture    : Text;
    lifecycleSchema : Text;
    compressionConst: Text;
  } {
    let fillPct = if (QUIPU_CAP == 0) 0.0
                  else Float.fromInt(quipuCount) / Float.fromInt(QUIPU_CAP) * 100.0;
    {
      seal             = sovereignSeal;
      claimed          = genesisLocked;
      recordCount      = quipuCount;
      capacity         = QUIPU_CAP;
      fillPct;
      totalKnotValue   = totalKnotValue;
      phi              = PHI;
      architecture     = "SPINE(domain) → PENDANT(type) → SUBSIDIARY(depth) → KNOT(value) | COLOR(tag)";
      lifecycleSchema  = "PENDING → EXECUTING → SETTLED | CANCELLED";
      compressionConst = "φ = 1.6180339887 — each hierarchy level compresses by φ⁻¹";
    }
  };

};
