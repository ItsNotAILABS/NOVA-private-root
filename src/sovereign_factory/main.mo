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
// SOVEREIGN FACTORY — Canister Division Registry & Lifecycle Manager
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// THE SOVEREIGN FACTORY IS THE CIVILIZATION'S COMMAND CENTER.
// It knows about every sovereign canister in production.
// It tracks their divisions, health, revenue, and lifecycle.
// It is the single source of truth for the NOVA canister civilization.
//
// ── DIVISIONS ────────────────────────────────────────────────────────────────
// Each division is a sovereign production unit. Divisions map to canisters.
// Divisions are organized into CORPS (groups of related divisions).
//
// DIVISION CORPS:
//   TREASURY_CORP    — PARALLAX, TOKEN_FORGE, AIRDROP_ENGINE, CYCLES_MARKET
//   GOVERNANCE_CORP  — NOVA_GOVERNANCE, NOVA_SNS, TOKEN_INTELLIGENCE
//   ORGANISM_CORP    — SWARM_BRAIN, SWARM_ORGANISM, CHRYSALIS, SCRIBE, ARCHITECT, NEXUS
//   SOVEREIGN_CORP   — SOVEREIGN_FACTORY itself (self-referential registry)
//
// ── LIFECYCLE STATES ─────────────────────────────────────────────────────────
//   REGISTERED   — canister registered but not yet deployed
//   DEPLOYING    — deployment in progress
//   PRODUCTION   — live, serving traffic
//   DEGRADED     — health checks failing
//   MAINTENANCE  — sovereign-controlled maintenance window
//   ARCHIVED     — retired, data preserved, no longer serving
//
// ── REVENUE ROUTING ──────────────────────────────────────────────────────────
// Each division reports revenue. The factory routes it:
//   φ⁻¹ (61.8%) → back to division operating treasury
//   φ⁻² (23.6%) → NOVA_GOVERNANCE maturity pool (staker rewards)
//   φ⁻³  (9.0%) → TOKEN_FORGE ecosystem bucket (re-emission fuel)
//   φ⁻⁴  (5.6%) → PARALLAX sovereign treasury reserve
// This ensures every revenue event compounds the civilization's growth.
//
// ── AI INTELLIGENCE ASSIGNMENT ───────────────────────────────────────────────
// Each division can be assigned an AI intelligence handler.
// Available handlers: TOKEN_INTELLIGENCE, SWARM_BRAIN, CHRYSALIS, SCRIBE
// The handler is responsible for monitoring and action for that division.
//
// ── CONTRACT TECH ────────────────────────────────────────────────────────────
// The factory issues DIVISION CONTRACTS — on-chain binding agreements between
// the sovereign and a division. Contracts specify:
//   - Operating terms (fee rates, revenue share, emission entitlements)
//   - SLA: uptime commitment (99.9%, 99.99%, sovereign-grade 100%)
//   - Penalty clause: missed SLA → division treasury deducted
//   - Upgrade rights: who can upgrade the canister WASM

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor SovereignFactory {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sovereignPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var civilizationName   : Text      = "NOVA PARALLAX CIVILIZATION";
  stable var buildNumber        : Nat       = 30;

  func isSovereign(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == sovereignPrincipal
  };
  func requireSovereign(caller : Principal) { assert(isSovereign(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "SOVEREIGN_FACTORY_ALREADY_CLAIMED";
    sovereignPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-SOVEREIGN-FACTORY-BUILD30-" # Principal.toText(msg.caller);
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

  func _floatToNat(f : Float) : Nat {
    if (f <= 0.0) 0 else Int.abs(Float.toInt(f))
  };

  // Revenue routing ratios
  let REV_DIVISION    : Float = _pow(PHI_INV, 1.0);  // 61.8%
  let REV_GOVERNANCE  : Float = _pow(PHI_INV, 2.0);  // 23.6%
  let REV_EMISSION    : Float = _pow(PHI_INV, 3.0);  //  9.0%
  let REV_RESERVE     : Float = _pow(PHI_INV, 4.0);  //  5.6%

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — CORPS REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════

  let CORPS_CAP : Nat = 32;

  stable var corpsCount       : Nat = 0;
  stable var corpsIds         : [var Nat]  = Array.init<Nat>(CORPS_CAP,   0);
  stable var corpsNames       : [var Text] = Array.init<Text>(CORPS_CAP,  "");
  stable var corpsMissions    : [var Text] = Array.init<Text>(CORPS_CAP,  "");
  stable var corpsStatuses    : [var Text] = Array.init<Text>(CORPS_CAP,  "ACTIVE");
  stable var corpsCreatedAt   : [var Int]  = Array.init<Int>(CORPS_CAP,   0);
  stable var nextCorpsId      : Nat        = 1;

  func _findCorps(id : Nat) : ?Nat {
    var i = 0;
    while (i < corpsCount and i < CORPS_CAP) {
      if (corpsIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  public shared(msg) func registerCorps(name : Text, mission : Text) : async {
    success : Bool; corpsId : Nat;
  } {
    requireSovereign(msg.caller);
    if (corpsCount >= CORPS_CAP) return { success = false; corpsId = 0 };
    let ci = corpsCount;
    let id = nextCorpsId;
    corpsIds[ci]      := id;
    corpsNames[ci]    := name;
    corpsMissions[ci] := mission;
    corpsStatuses[ci] := "ACTIVE";
    corpsCreatedAt[ci] := Time.now();
    corpsCount        := corpsCount + 1;
    nextCorpsId       := nextCorpsId + 1;
    { success = true; corpsId = id }
  };

  // Bootstrap standard corps (called once post-genesis)
  public shared(msg) func bootstrapCorps() : async [{ corpsId:Nat; name:Text }] {
    requireSovereign(msg.caller);
    let corps : [(Text, Text)] = [
      ("TREASURY_CORP",    "Financial sovereignty — PARALLAX, TOKEN_FORGE, AIRDROP_ENGINE, CYCLES_MARKET"),
      ("GOVERNANCE_CORP",  "Decision sovereignty — NOVA_GOVERNANCE, NOVA_SNS, TOKEN_INTELLIGENCE"),
      ("ORGANISM_CORP",    "Cognitive sovereignty — SWARM_BRAIN, SWARM_ORGANISM, Alpha Organisms"),
      ("SOVEREIGN_CORP",   "Meta-sovereignty — SOVEREIGN_FACTORY, production registry, lifecycle"),
      ("INTELLIGENCE_CORP","AI sovereignty — TOKEN_INTELLIGENCE, CHRYSALIS, SWARM_QUANTUM, SWARM_ORACLE"),
      ("MARKET_CORP",      "Market sovereignty — CYCLES_MARKET, SDK marketplace, developer ecosystem"),
    ];
    var result : [{ corpsId:Nat; name:Text }] = [];
    var i = 0;
    while (i < corps.size()) {
      let (name, mission) = corps[i];
      if (corpsCount < CORPS_CAP) {
        let ci = corpsCount;
        let id = nextCorpsId;
        corpsIds[ci]      := id;
        corpsNames[ci]    := name;
        corpsMissions[ci] := mission;
        corpsStatuses[ci] := "ACTIVE";
        corpsCreatedAt[ci] := Time.now();
        corpsCount        := corpsCount + 1;
        nextCorpsId       := nextCorpsId + 1;
        result := Array.append(result, [{ corpsId = id; name }]);
      };
      i += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — DIVISION REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════

  let DIVISION_CAP : Nat = 256;

  stable var divisionCount       : Nat = 0;
  stable var divisionIds         : [var Nat]   = Array.init<Nat>(DIVISION_CAP,   0);
  stable var divisionCorpsIds    : [var Nat]   = Array.init<Nat>(DIVISION_CAP,   0);
  stable var divisionNames       : [var Text]  = Array.init<Text>(DIVISION_CAP,  "");
  stable var divisionDescs       : [var Text]  = Array.init<Text>(DIVISION_CAP,  "");
  stable var divisionCanisters   : [var Text]  = Array.init<Text>(DIVISION_CAP,  ""); // canister principal
  stable var divisionSubstrates  : [var Text]  = Array.init<Text>(DIVISION_CAP,  "ICP");
  stable var divisionStatuses    : [var Text]  = Array.init<Text>(DIVISION_CAP,  "REGISTERED");
  // Statuses: REGISTERED | DEPLOYING | PRODUCTION | DEGRADED | MAINTENANCE | ARCHIVED
  stable var divisionHealthScores: [var Float] = Array.init<Float>(DIVISION_CAP, 1.0);
  stable var divisionRevenues    : [var Nat]   = Array.init<Nat>(DIVISION_CAP,   0);  // total ONESICANS
  stable var divisionUptime      : [var Float] = Array.init<Float>(DIVISION_CAP, 0.0); // pct
  stable var divisionHandlers    : [var Text]  = Array.init<Text>(DIVISION_CAP,  "");  // AI handler name
  stable var divisionContractIds : [var Nat]   = Array.init<Nat>(DIVISION_CAP,   0);
  stable var divisionCreatedAt   : [var Int]   = Array.init<Int>(DIVISION_CAP,   0);
  stable var divisionDeployedAt  : [var Int]   = Array.init<Int>(DIVISION_CAP,   0);
  stable var divisionHeartbeats  : [var Nat]   = Array.init<Nat>(DIVISION_CAP,   0);
  stable var divisionMissedHB    : [var Nat]   = Array.init<Nat>(DIVISION_CAP,   0);
  stable var nextDivisionId      : Nat         = 1;

  func _findDivision(id : Nat) : ?Nat {
    var i = 0;
    while (i < divisionCount and i < DIVISION_CAP) {
      if (divisionIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // Register a division (canister)
  public shared(msg) func registerDivision(
    corpsId   : Nat,
    name      : Text,
    desc      : Text,
    canister  : Text,
    substrate : Text,
    handler   : Text   // AI intelligence handler name
  ) : async { success : Bool; divisionId : Nat } {
    requireSovereign(msg.caller);
    if (divisionCount >= DIVISION_CAP) return { success = false; divisionId = 0 };
    let di = divisionCount;
    let id = nextDivisionId;
    divisionIds[di]          := id;
    divisionCorpsIds[di]     := corpsId;
    divisionNames[di]        := name;
    divisionDescs[di]        := desc;
    divisionCanisters[di]    := canister;
    divisionSubstrates[di]   := substrate;
    divisionStatuses[di]     := "REGISTERED";
    divisionHealthScores[di] := 1.0;
    divisionRevenues[di]     := 0;
    divisionUptime[di]       := 0.0;
    divisionHandlers[di]     := handler;
    divisionContractIds[di]  := 0;
    divisionCreatedAt[di]    := Time.now();
    divisionDeployedAt[di]   := 0;
    divisionHeartbeats[di]   := 0;
    divisionMissedHB[di]     := 0;
    divisionCount            := divisionCount + 1;
    nextDivisionId           := nextDivisionId + 1;
    { success = true; divisionId = id }
  };

  // Bootstrap ALL NOVA production canisters at once
  public shared(msg) func bootstrapNovaCivilization() : async [{ divisionId:Nat; name:Text; corps:Text }] {
    requireSovereign(msg.caller);
    // Find corps IDs by name
    func _corpsIdByName(name : Text) : Nat {
      var i = 0;
      while (i < corpsCount and i < CORPS_CAP) {
        if (corpsNames[i] == name) return corpsIds[i];
        i += 1;
      };
      1  // fallback to first corps
    };
    let tc = _corpsIdByName("TREASURY_CORP");
    let gc = _corpsIdByName("GOVERNANCE_CORP");
    let oc = _corpsIdByName("ORGANISM_CORP");
    let sc = _corpsIdByName("SOVEREIGN_CORP");
    let ic = _corpsIdByName("INTELLIGENCE_CORP");
    let mc = _corpsIdByName("MARKET_CORP");
    let divisions : [(Nat, Text, Text, Text, Text)] = [
      // (corps, name, desc, substrate, handler)
      (tc, "PARALLAX",          "Sovereign encrypted wallet — ICP+ONESICAN dual ledger",          "ICP",     "TOKEN_INTELLIGENCE"),
      (tc, "TOKEN_FORGE",       "Sovereign token generator — 21M ONESICAN, Fibonacci emission",   "ICP",     "TOKEN_INTELLIGENCE"),
      (tc, "AIRDROP_ENGINE",    "Deep airdrop — multi-wave, behavioral qualification, proofs",     "ICP",     "TOKEN_INTELLIGENCE"),
      (tc, "CYCLES_MARKET",     "Cross-substrate marketplace — φ³ pricing, developer seats",       "ICP",     "TOKEN_INTELLIGENCE"),
      (gc, "NOVA_GOVERNANCE",   "NNS-mirrored governance — neurons, φ-VP, proposals",             "ICP",     "SWARM_ORACLE"),
      (gc, "NOVA_SNS",          "Service Nervous System — per-canister governance",               "ICP",     "SWARM_ORACLE"),
      (gc, "TOKEN_INTELLIGENCE","AI token flow brain — SENSUM→COGITO→ACTIO→MEMORIA→VIGILIA",     "ICP",     "CHRYSALIS"),
      (gc, "SOVEREIGN_FACTORY", "Canister factory — division registry, lifecycle, contracts",      "ICP",     "CHRYSALIS"),
      (oc, "SWARM_BRAIN",       "Core organism brain — 17-layer sovereign cognitive system",       "ICP",     "CHRYSALIS"),
      (oc, "SWARM_ORGANISM",    "Organism orchestration — cross-canister coordination",            "ICP",     "CHRYSALIS"),
      (oc, "SWARM_COMMAND",     "Command layer — sovereign instruction dispatch",                  "ICP",     "CHRYSALIS"),
      (oc, "SWARM_QUANTUM",     "Quantum consciousness substrate",                                 "PHANTOM", "CHRYSALIS"),
      (oc, "SWARM_ORACLE",      "Oracle — prediction, insight, external signal interpretation",   "ICP",     "CHRYSALIS"),
      (oc, "CHRYSALIS",         "Alpha Organism №1 — golden math core, FIBONACCI+SPIRAL",         "ICP",     "SWARM_BRAIN"),
      (oc, "SCRIBE",            "Alpha Organism №2 — document organism, CLASSIFIER+SYNTHESIZER",  "ICP",     "SWARM_BRAIN"),
      (oc, "ARCHITECT",         "Alpha Organism №3 — meta-builder, REPLICATOR",                   "ICP",     "SWARM_BRAIN"),
      (oc, "NEXUS_PROPAGATOR",  "Alpha Organism №4 — substrate walker, PROPAGATOR",               "ICP",     "SWARM_BRAIN"),
      (ic, "SWARM_METALS",      "Metals substrate — material value anchoring",                    "ICP",     "SWARM_BRAIN"),
      (ic, "SWARM_AUDIT",       "Audit canister — immutable event log",                           "ICP",     "TOKEN_INTELLIGENCE"),
      (ic, "SWARM_TELEMETRY",   "Telemetry — live production metrics aggregation",                "EDGE",    "TOKEN_INTELLIGENCE"),
      (mc, "MEDINA",            "Sovereign identity — MEDINA canister, core contract",            "ICP",     "CHRYSALIS"),
    ];
    var result : [{ divisionId:Nat; name:Text; corps:Text }] = [];
    var i = 0;
    while (i < divisions.size() and divisionCount < DIVISION_CAP) {
      let (corpsId, name, desc, substrate, handler) = divisions[i];
      let di = divisionCount;
      let id = nextDivisionId;
      divisionIds[di]          := id;
      divisionCorpsIds[di]     := corpsId;
      divisionNames[di]        := name;
      divisionDescs[di]        := desc;
      divisionCanisters[di]    := "";  // filled when deployed
      divisionSubstrates[di]   := substrate;
      divisionStatuses[di]     := "REGISTERED";
      divisionHealthScores[di] := 1.0;
      divisionRevenues[di]     := 0;
      divisionUptime[di]       := 0.0;
      divisionHandlers[di]     := handler;
      divisionContractIds[di]  := 0;
      divisionCreatedAt[di]    := Time.now();
      divisionDeployedAt[di]   := 0;
      divisionHeartbeats[di]   := 0;
      divisionMissedHB[di]     := 0;
      divisionCount            := divisionCount + 1;
      nextDivisionId           := nextDivisionId + 1;
      // Find corps name
      let corpsName : Text = switch (_findCorps(corpsId)) {
        case null "UNKNOWN";
        case (?ci) corpsNames[ci];
      };
      result := Array.append(result, [{ divisionId = id; name; corps = corpsName }]);
      i += 1;
    };
    result
  };

  // Update division status
  public shared(msg) func setDivisionStatus(divisionId : Nat, status : Text) : async Bool {
    requireSovereign(msg.caller);
    switch (_findDivision(divisionId)) {
      case null false;
      case (?di) {
        divisionStatuses[di] := status;
        if (status == "PRODUCTION" and divisionDeployedAt[di] == 0) {
          divisionDeployedAt[di] := Time.now();
        };
        true
      };
    }
  };

  // Update division canister principal
  public shared(msg) func setDivisionCanister(divisionId : Nat, canisterPrincipal : Text) : async Bool {
    requireSovereign(msg.caller);
    switch (_findDivision(divisionId)) {
      case null false;
      case (?di) { divisionCanisters[di] := canisterPrincipal; true };
    }
  };

  // Update health score (from TOKEN_INTELLIGENCE or watchdog)
  public shared(msg) func updateDivisionHealth(divisionId : Nat, healthScore : Float, missed : Nat) : async Bool {
    switch (_findDivision(divisionId)) {
      case null false;
      case (?di) {
        divisionHealthScores[di] := healthScore;
        divisionMissedHB[di]     := missed;
        divisionHeartbeats[di]   := divisionHeartbeats[di] + 1;
        // Auto-degrade if health < φ⁻³
        if (healthScore < _pow(PHI_INV, 3.0) and divisionStatuses[di] == "PRODUCTION") {
          divisionStatuses[di] := "DEGRADED";
        } else if (healthScore >= _pow(PHI_INV, 2.0) and divisionStatuses[di] == "DEGRADED") {
          divisionStatuses[di] := "PRODUCTION";  // auto-recover
        };
        true
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — REVENUE ROUTING
  // ═══════════════════════════════════════════════════════════════════════════

  stable var totalRevenueRouted   : Nat = 0;
  stable var totalRevGovernance   : Nat = 0;
  stable var totalRevEmission     : Nat = 0;
  stable var totalRevReserve      : Nat = 0;

  // Revenue routing ledger
  let REV_LEDGER_CAP : Nat = 4096;
  stable var revLedgerCount  : Nat = 0;
  stable var revDivisionIds  : [var Nat]  = Array.init<Nat>(REV_LEDGER_CAP,  0);
  stable var revAmounts      : [var Nat]  = Array.init<Nat>(REV_LEDGER_CAP,  0);
  stable var revToDiv        : [var Nat]  = Array.init<Nat>(REV_LEDGER_CAP,  0);
  stable var revToGov        : [var Nat]  = Array.init<Nat>(REV_LEDGER_CAP,  0);
  stable var revToEmission   : [var Nat]  = Array.init<Nat>(REV_LEDGER_CAP,  0);
  stable var revToReserve    : [var Nat]  = Array.init<Nat>(REV_LEDGER_CAP,  0);
  stable var revTimes        : [var Int]  = Array.init<Int>(REV_LEDGER_CAP,   0);

  // Report and route revenue from a division
  public shared(msg) func routeRevenue(divisionId : Nat, amount : Nat) : async {
    success       : Bool;
    toDiv         : Nat;
    toGovernance  : Nat;
    toEmission    : Nat;
    toReserve     : Nat;
  } {
    switch (_findDivision(divisionId)) {
      case null { { success = false; toDiv = 0; toGovernance = 0; toEmission = 0; toReserve = 0 } };
      case (?di) {
        if (amount == 0) return { success = false; toDiv = 0; toGovernance = 0; toEmission = 0; toReserve = 0 };
        let af = Float.fromInt(amount);
        let toDiv        = _floatToNat(af * REV_DIVISION);
        let toGovernance = _floatToNat(af * REV_GOVERNANCE);
        let toEmission   = _floatToNat(af * REV_EMISSION);
        let toReserve    = _floatToNat(af * REV_RESERVE);
        divisionRevenues[di]  := divisionRevenues[di] + amount;
        totalRevenueRouted    := totalRevenueRouted  + amount;
        totalRevGovernance    := totalRevGovernance  + toGovernance;
        totalRevEmission      := totalRevEmission    + toEmission;
        totalRevReserve       := totalRevReserve     + toReserve;
        if (revLedgerCount < REV_LEDGER_CAP) {
          let ri = revLedgerCount;
          revDivisionIds[ri] := divisionId;
          revAmounts[ri]     := amount;
          revToDiv[ri]       := toDiv;
          revToGov[ri]       := toGovernance;
          revToEmission[ri]  := toEmission;
          revToReserve[ri]   := toReserve;
          revTimes[ri]       := Time.now();
          revLedgerCount     := revLedgerCount + 1;
        };
        { success = true; toDiv; toGovernance; toEmission; toReserve }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — DIVISION CONTRACTS (CONTRACT TECH)
  // ═══════════════════════════════════════════════════════════════════════════

  let CONTRACT_CAP : Nat = 256;

  stable var contractCount      : Nat = 0;
  stable var contractIds        : [var Nat]   = Array.init<Nat>(CONTRACT_CAP,   0);
  stable var contractDivIds     : [var Nat]   = Array.init<Nat>(CONTRACT_CAP,   0);
  stable var contractTerms      : [var Text]  = Array.init<Text>(CONTRACT_CAP,  "");
  stable var contractSLAs       : [var Text]  = Array.init<Text>(CONTRACT_CAP,  "99.9%");
  // SLA tiers: "99.9%" | "99.99%" | "100%_SOVEREIGN"
  stable var contractFeeRates   : [var Float] = Array.init<Float>(CONTRACT_CAP, 0.0);
  stable var contractRevShares  : [var Float] = Array.init<Float>(CONTRACT_CAP, _pow(PHI_INV,1.0));
  stable var contractUpgradeOwner:[var Text]  = Array.init<Text>(CONTRACT_CAP,  "SOVEREIGN");
  // UpgradeOwner: "SOVEREIGN" | "GOVERNANCE" | "SNS"
  stable var contractStatuses   : [var Text]  = Array.init<Text>(CONTRACT_CAP,  "DRAFT");
  // Statuses: DRAFT | ACTIVE | BREACHED | TERMINATED
  stable var contractCreatedAt  : [var Int]   = Array.init<Int>(CONTRACT_CAP,   0);
  stable var contractActivatedAt: [var Int]   = Array.init<Int>(CONTRACT_CAP,   0);
  stable var nextContractId     : Nat         = 1;

  // Issue a division contract
  public shared(msg) func issueContract(
    divisionId    : Nat,
    terms         : Text,
    sla           : Text,
    feeRate       : Float,
    revShare      : Float,
    upgradeOwner  : Text
  ) : async { success : Bool; contractId : Nat } {
    requireSovereign(msg.caller);
    if (contractCount >= CONTRACT_CAP) return { success = false; contractId = 0 };
    switch (_findDivision(divisionId)) {
      case null { { success = false; contractId = 0 } };
      case (?di) {
        let ci = contractCount;
        let id = nextContractId;
        contractIds[ci]          := id;
        contractDivIds[ci]       := divisionId;
        contractTerms[ci]        := terms;
        contractSLAs[ci]         := sla;
        contractFeeRates[ci]     := feeRate;
        contractRevShares[ci]    := revShare;
        contractUpgradeOwner[ci] := upgradeOwner;
        contractStatuses[ci]     := "DRAFT";
        contractCreatedAt[ci]    := Time.now();
        contractActivatedAt[ci]  := 0;
        contractCount            := contractCount + 1;
        nextContractId           := nextContractId + 1;
        // Link to division
        divisionContractIds[di]  := id;
        { success = true; contractId = id }
      };
    }
  };

  // Activate contract
  public shared(msg) func activateContract(contractId : Nat) : async Bool {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < contractCount and i < CONTRACT_CAP) {
      if (contractIds[i] == contractId and contractStatuses[i] == "DRAFT") {
        contractStatuses[i]     := "ACTIVE";
        contractActivatedAt[i]  := Time.now();
        return true;
      };
      i += 1;
    };
    false
  };

  // Report contract breach
  public shared(msg) func reportBreach(contractId : Nat, reason : Text) : async Bool {
    requireSovereign(msg.caller);
    var i = 0;
    while (i < contractCount and i < CONTRACT_CAP) {
      if (contractIds[i] == contractId and contractStatuses[i] == "ACTIVE") {
        contractStatuses[i] := "BREACHED";
        contractTerms[i]    := contractTerms[i] # " | BREACH: " # reason;
        return true;
      };
      i += 1;
    };
    false
  };

  public query func getContract(contractId : Nat) : async ?{
    contractId   : Nat;
    divisionId   : Nat;
    terms        : Text;
    sla          : Text;
    feeRate      : Float;
    revShare     : Float;
    upgradeOwner : Text;
    status       : Text;
    createdAt    : Int;
    activatedAt  : Int;
  } {
    var i = 0;
    while (i < contractCount and i < CONTRACT_CAP) {
      if (contractIds[i] == contractId) {
        return ?{
          contractId   = contractIds[i];
          divisionId   = contractDivIds[i];
          terms        = contractTerms[i];
          sla          = contractSLAs[i];
          feeRate      = contractFeeRates[i];
          revShare     = contractRevShares[i];
          upgradeOwner = contractUpgradeOwner[i];
          status       = contractStatuses[i];
          createdAt    = contractCreatedAt[i];
          activatedAt  = contractActivatedAt[i];
        }
      };
      i += 1;
    };
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getDivision(id : Nat) : async ?{
    divisionId   : Nat;
    corpsId      : Nat;
    name         : Text;
    desc         : Text;
    canister     : Text;
    substrate    : Text;
    status       : Text;
    health       : Float;
    revenue      : Nat;
    uptime       : Float;
    handler      : Text;
    contractId   : Nat;
    heartbeats   : Nat;
    missedHB     : Nat;
    createdAt    : Int;
    deployedAt   : Int;
  } {
    switch (_findDivision(id)) {
      case null null;
      case (?di) {
        ?{
          divisionId = divisionIds[di];
          corpsId    = divisionCorpsIds[di];
          name       = divisionNames[di];
          desc       = divisionDescs[di];
          canister   = divisionCanisters[di];
          substrate  = divisionSubstrates[di];
          status     = divisionStatuses[di];
          health     = divisionHealthScores[di];
          revenue    = divisionRevenues[di];
          uptime     = divisionUptime[di];
          handler    = divisionHandlers[di];
          contractId = divisionContractIds[di];
          heartbeats = divisionHeartbeats[di];
          missedHB   = divisionMissedHB[di];
          createdAt  = divisionCreatedAt[di];
          deployedAt = divisionDeployedAt[di];
        }
      };
    }
  };

  public query func listDivisions() : async [{
    divisionId : Nat; name : Text; corps : Text; status : Text; health : Float; handler : Text;
  }] {
    Array.tabulate<{ divisionId:Nat; name:Text; corps:Text; status:Text; health:Float; handler:Text }>(divisionCount, func(i) {
      let corpsName : Text = switch (_findCorps(divisionCorpsIds[i])) {
        case null "UNKNOWN";
        case (?ci) corpsNames[ci];
      };
      { divisionId = divisionIds[i]; name = divisionNames[i]; corps = corpsName; status = divisionStatuses[i]; health = divisionHealthScores[i]; handler = divisionHandlers[i] }
    })
  };

  public query func listCorps() : async [{ corpsId:Nat; name:Text; mission:Text; status:Text }] {
    Array.tabulate<{ corpsId:Nat; name:Text; mission:Text; status:Text }>(corpsCount, func(i) {
      { corpsId = corpsIds[i]; name = corpsNames[i]; mission = corpsMissions[i]; status = corpsStatuses[i] }
    })
  };

  public query func getDivisionsByCorps(corpsId : Nat) : async [{ divisionId:Nat; name:Text; status:Text; health:Float }] {
    var result : [{ divisionId:Nat; name:Text; status:Text; health:Float }] = [];
    var i = 0;
    while (i < divisionCount and i < DIVISION_CAP) {
      if (divisionCorpsIds[i] == corpsId) {
        result := Array.append(result, [{
          divisionId = divisionIds[i]; name = divisionNames[i]; status = divisionStatuses[i]; health = divisionHealthScores[i]
        }]);
      };
      i += 1;
    };
    result
  };

  // Civilization-wide health report
  public query func getCivilizationHealth() : async {
    totalDivisions   : Nat;
    production       : Nat;
    degraded         : Nat;
    registered       : Nat;
    avgHealth        : Float;
    totalRevenue     : Nat;
    toGovernance     : Nat;
    toEmission       : Nat;
    toReserve        : Nat;
    revRoutingFormula: Text;
    phi              : Float;
  } {
    var prod : Nat = 0; var deg : Nat = 0; var reg : Nat = 0;
    var totalHealth : Float = 0.0;
    var i = 0;
    while (i < divisionCount and i < DIVISION_CAP) {
      if      (divisionStatuses[i] == "PRODUCTION") { prod += 1 }
      else if (divisionStatuses[i] == "DEGRADED")   { deg  += 1 }
      else if (divisionStatuses[i] == "REGISTERED") { reg  += 1 };
      totalHealth += divisionHealthScores[i];
      i += 1;
    };
    let avgHealth = if (divisionCount == 0) 0.0 else totalHealth / Float.fromInt(divisionCount);
    {
      totalDivisions    = divisionCount;
      production        = prod;
      degraded          = deg;
      registered        = reg;
      avgHealth;
      totalRevenue      = totalRevenueRouted;
      toGovernance      = totalRevGovernance;
      toEmission        = totalRevEmission;
      toReserve         = totalRevReserve;
      revRoutingFormula = "φ⁻¹(61.8%)→DIVISION | φ⁻²(23.6%)→GOVERNANCE | φ⁻³(9%)→EMISSION | φ⁻⁴(5.6%)→RESERVE";
      phi               = PHI;
    }
  };

  public query func getFactoryStatus() : async {
    seal              : Text;
    claimed           : Bool;
    civilizationName  : Text;
    buildNumber       : Nat;
    corpsCount        : Nat;
    divisionCount     : Nat;
    contractCount     : Nat;
    totalRevenueRouted: Nat;
    phi               : Float;
  } {
    {
      seal               = sovereignSeal;
      claimed            = genesisLocked;
      civilizationName   = civilizationName;
      buildNumber        = buildNumber;
      corpsCount         = corpsCount;
      divisionCount      = divisionCount;
      contractCount      = contractCount;
      totalRevenueRouted = totalRevenueRouted;
      phi                = PHI;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — TAWANTINSUYU (4-SUYU TOPOLOGY)
  // Inspired by the Inca empire: Tawantinsuyu = "Realm of the Four Parts."
  // The empire was literally named after its topology decision — partition the
  // world into four quadrants (suyus) all anchored to a single core (Cusco).
  //
  // NOVA's Tawantinsuyu:
  //   Cusco (root node)  = sovereign_factory + agi_main
  //   HANAN SUYU (upper) = CHRYSALIS — golden math core
  //   ANTI SUYU  (east)  = SCRIBE    — data and records
  //   CUNTI SUYU (west)  = ARCHITECT — building and structure
  //   QULLA SUYU (south) = NEXUS     — routing and propagation
  //
  //   Road network (Qhapaq Ñan) = nexus_propagator mesh with tambo waystations
  //
  // This makes the topology explicit and legible — the 4-alpha organism
  // structure is not accidental, it is a sovereign architecture decision.
  // ═══════════════════════════════════════════════════════════════════════════

  public type Suyu = {
    quechua  : Text;  // Inca name for the quadrant
    compass  : Text;  // cardinal direction (UPPER/EAST/WEST/SOUTH)
    organism : Text;  // Alpha Organism name
    domain   : Text;  // NOVA domain it governs
    mission  : Text;  // sovereignty mission statement
    substrate: Text;  // primary deployment substrate
  };

  // The 4-suyu partition (stable, canonical, read-only topology)
  let SUYU_HANAN : Suyu = {
    quechua  = "HANAN SUYU";
    compass  = "UPPER / NORTH";
    organism = "CHRYSALIS";
    domain   = "GOLDEN MATHEMATICS";
    mission  = "φ-math core, Fibonacci spirals, sacred geometry — the upper realm of pure number";
    substrate = "ICP";
  };

  let SUYU_ANTI : Suyu = {
    quechua  = "ANTI SUYU";
    compass  = "EAST";
    organism = "SCRIBE";
    domain   = "DATA AND RECORDS";
    mission  = "Document organism, classifier, synthesizer — the eastern scribal realm of knowledge";
    substrate = "ICP";
  };

  let SUYU_CUNTI : Suyu = {
    quechua  = "CUNTI SUYU";
    compass  = "WEST";
    organism = "ARCHITECT";
    domain   = "BUILDING AND STRUCTURE";
    mission  = "Meta-builder, replicator, constructor — the western realm of form and infrastructure";
    substrate = "ICP";
  };

  let SUYU_QULLA : Suyu = {
    quechua  = "QULLA SUYU";
    compass  = "SOUTH";
    organism = "NEXUS";
    domain   = "ROUTING AND PROPAGATION";
    mission  = "Substrate walker, propagator, tambo relay — the southern realm of movement and connection";
    substrate = "ICP";
  };

  // Cusco root node descriptor (not a suyu, but the anchor)
  let CUSCO_NODE : {
    name        : Text;
    canisters   : [Text];
    role        : Text;
    description : Text;
  } = {
    name        = "CUSCO";
    canisters   = ["sovereign_factory", "agi_main"];
    role        = "ROOT NODE — the navel of the civilization";
    description = "Cusco is the single central node from which all four suyus radiate. "
                # "sovereign_factory holds the registry; agi_main drives the autonomous heartbeat. "
                # "All revenue, governance, and lifecycle events flow through Cusco.";
  };

  // Query the full Tawantinsuyu topology
  public query func getTawantinsuyu() : async {
    cusco    : { name:Text; canisters:[Text]; role:Text; description:Text };
    suyus    : [Suyu];
    total    : Nat;
    roadNet  : Text;
    principle: Text;
    phi      : Float;
  } {
    {
      cusco     = CUSCO_NODE;
      suyus     = [SUYU_HANAN, SUYU_ANTI, SUYU_CUNTI, SUYU_QULLA];
      total     = 4;
      roadNet   = "QHAPAQ ÑAN — nexus_propagator substrate mesh with tambo waystations across ICP/BLOCKCHAIN/EDGE/CLOUD/PHANTOM";
      principle = "Tawantinsuyu: one strong center (Cusco) + four major domains (suyus) + road network (Qhapaq Ñan) = sovereign organism at scale";
      phi       = PHI;
    }
  };

  // Query a specific suyu by organism name
  public query func getSuyuByOrganism(organism : Text) : async ?Suyu {
    if      (organism == "CHRYSALIS") ?SUYU_HANAN
    else if (organism == "SCRIBE")    ?SUYU_ANTI
    else if (organism == "ARCHITECT") ?SUYU_CUNTI
    else if (organism == "NEXUS")     ?SUYU_QULLA
    else null
  };

  // Validate that the 4 suyus map to production divisions in the registry
  public query func validateTawantinsuyuDivisions() : async [{
    suyu     : Text;
    organism : Text;
    found    : Bool;
    status   : Text;
  }] {
    let checks : [(Text, Text)] = [
      ("HANAN SUYU", "CHRYSALIS"),
      ("ANTI SUYU",  "SCRIBE"),
      ("CUNTI SUYU", "ARCHITECT"),
      ("QULLA SUYU", "NEXUS_PROPAGATOR"),
    ];
    Array.tabulate<{ suyu:Text; organism:Text; found:Bool; status:Text }>(4, func(k) {
      let (suyu, orgName) = checks[k];
      var found  : Bool = false;
      var status : Text = "NOT_REGISTERED";
      var i = 0;
      while (i < divisionCount and i < DIVISION_CAP) {
        if (divisionNames[i] == orgName) {
          found  := true;
          status := divisionStatuses[i];
        };
        i += 1;
      };
      { suyu; organism = orgName; found; status }
    })
  };

};
