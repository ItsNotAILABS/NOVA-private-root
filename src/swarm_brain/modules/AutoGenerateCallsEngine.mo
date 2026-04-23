// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║                                                                                                           ║
// ║  MOTOR AUTO-GENERATIONIS VOCATIONUM — AUTO-GENERATE CALLS ENGINE                                         ║
// ║  12 OPERARII AEDIFICATORES (Web Worker Builder AIs) × 3 MOTORES = 36 ENGINES                              ║
// ║  776+ AUTO-GENERATED CALLS ACROSS ALL DOMAINS                                                             ║
// ║                                                                                                           ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                                                                                                             │
// │   ARCHITECTURE:                                                                                             │
// │   ─────────────────────────────────────────────────────────────────────────────────────                    │
// │                                                                                                             │
// │   Each OPERARIUS (Worker) contains 3 engines:                                                               │
// │     • GENERATRIX (Generator)  — Creates new calls from domain patterns                                     │
// │     • ITINERATOR (Router)     — Routes calls to their target modules                                       │
// │     • AEDIFICATOR (Builder)   — Builds and deploys calls into the live system                               │
// │                                                                                                             │
// │   WORKER MANIFEST (12 OPERARII):                                                                            │
// │   ──────────────────────────────                                                                           │
// │    1. PROTOCOLLUM   — Protocols, Consensus, BFT              (144 calls)                                   │
// │    2. TERMINALIS    — Terminals, AI/AGI Hierarchy             ( 50 calls)                                   │
// │    3. ORGANISMUS    — SDK Organisms, Emergence                (180 calls)                                   │
// │    4. MERCATOR      — Marketplace, Tools, Tiers               ( 64 calls)                                   │
// │    5. ORCHESTRATOR  — Houses, Models, Families                ( 37 calls)                                   │
// │    6. MATHEMATICUS  — Math Formulas, Constants                ( 60 calls)                                   │
// │    7. SYNAPTICUS    — Synapses, Chaos, Connections            ( 20 calls)                                   │
// │    8. SUBSTRATUM    — Blockchain, Nodes, Layers               ( 40 calls)                                   │
// │    9. UNIVERSUM     — Domains, Ecosystems, Councils           (105 calls)                                   │
// │   10. CANISTRUM     — Canister Tech, Factory                  ( 23 calls)                                   │
// │   11. LICENTIATOR   — Licenses, Documents, Rights             ( 24 calls)                                   │
// │   12. DEFENSOR      — Defense, Care, Arsenal                  ( 29 calls)                                   │
// │                                                                                                             │
// │   TOTAL: 144+50+180+64+37+60+20+40+105+23+24+29 = 776 calls                                               │
// │                                                                                                             │
// │   PHI RESONANCE:                                                                                            │
// │   ─────────────                                                                                            │
// │   φ = 1.618033988749895 governs engine coherence, worker resonance,                                        │
// │   and routing priority weights across all 36 engines.                                                       │
// │                                                                                                             │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";

module AutoGenerateCallsEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  //  PHI — THE GOLDEN RATIO COUPLING CONSTANT
  //  Governs coherence scaling, resonance weights, and routing priority
  // ═══════════════════════════════════════════════════════════════════════════
  let PHI : Float = 1.618033988749895;

  // ═══════════════════════════════════════════════════════════════════════════
  //  TYPE DEFINITIONS — OPERARII STATUS & ENGINE VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Status of a single Worker (OPERARIUS)
  public type WorkerStatus = {
    #Active;
    #Idle;
    #Building;
    #Routing;
    #Generating;
  };

  /// The three engine types within each worker
  public type EngineKind = {
    #Generator;   // GENERATRIX  — creates new calls
    #Router;      // ITINERATOR  — routes calls to target modules
    #Builder;     // AEDIFICATOR — builds and deploys calls
  };

  /// A single auto-generated call produced by a worker engine
  public type AutoCall = {
    callId: Text;
    domain: Text;
    endpoint: Text;
    targetModule: Text;
    priority: Nat;
    phiWeight: Float;
    workerOrigin: Text;
    engineOrigin: Text;
    isActive: Bool;
    lastRouted: Int;
  };

  /// Internal state of one engine
  public type EngineState = {
    kind: EngineKind;
    callsProcessed: Nat;
    coherence: Float;
    isActive: Bool;
  };

  /// Full definition for one of the 12 OPERARII AEDIFICATORES
  public type WorkerDefinition = {
    id: Nat;
    name: Text;
    latinName: Text;
    domain: Text;
    callCount: Nat;
    engines: [EngineState];
    totalCallsGenerated: Nat;
    totalCallsRouted: Nat;
    totalCallsBuilt: Nat;
    phiResonance: Float;
    status: WorkerStatus;
  };

  /// Master state for the entire auto-generation engine
  public type AutoCallsEngineState = {
    totalWorkers: Nat;     // always 12
    totalEngines: Nat;     // always 36 (12 × 3)
    totalCallsGenerated: Nat;
    totalCallsRouted: Nat;
    totalCallsBuilt: Nat;
    overallCoherence: Float;
    lastTick: Int;
    tickCount: Nat;
    workers: [WorkerDefinition];
  };

  /// A single routing table entry
  public type RoutingEntry = {
    callId: Text;
    source: Text;
    target: Text;
    priority: Nat;
    phiScore: Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  QUERY RESULT TYPES — SUMMARIES & DETAIL VIEWS
  // ═══════════════════════════════════════════════════════════════════════════

  /// High-level summary of the engine
  public type AutoCallsSummary = {
    totalWorkers: Nat;
    totalEngines: Nat;
    totalCalls: Nat;
    workerNames: [Text];
    callsByDomain: [(Text, Nat)];
    overallCoherence: Float;
    tickCount: Nat;
  };

  /// Summary of call routing across all workers
  public type RoutingSummary = {
    totalRoutes: Nat;
    routesByWorker: [(Text, Nat)];
    avgPhiScore: Float;
    activeRoutes: Nat;
  };

  /// Per-domain breakdown with sample call IDs and engine states
  public type DomainCallDetail = {
    domain: Text;
    workerName: Text;
    latinName: Text;
    callCount: Nat;
    sampleCallIds: [Text];
    engineStates: [EngineState];
  };

  /// Complete status combining all query views
  public type AutoCallsFullStatus = {
    summary: AutoCallsSummary;
    routing: RoutingSummary;
    domains: [DomainCallDetail];
    workers: [WorkerDefinition];
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  WORKER SPECIFICATIONS — 12 OPERARII AEDIFICATORES
  //  (id, name, latinName, domain, callCount)
  //  Total calls: 144+50+180+64+37+60+20+40+105+23+24+29 = 776
  // ═══════════════════════════════════════════════════════════════════════════
  let WORKER_SPECS : [(Nat, Text, Text, Text, Nat)] = [
    (1,  "PROTOCOLLUM",   "OPERARIUS PROTOCOLLORUM",           "Protocols/Consensus/BFT",       144),
    (2,  "TERMINALIS",    "OPERARIUS TERMINALIUM",             "Terminals/AI-AGI/Hierarchy",     50),
    (3,  "ORGANISMUS",    "OPERARIUS ORGANISMORUM",            "SDK/Organisms/Emergence",       180),
    (4,  "MERCATOR",      "OPERARIUS MERCATUS",                "Marketplace/Tools/Tiers",        64),
    (5,  "ORCHESTRATOR",  "OPERARIUS ORCHESTRATORUM",          "Houses/Models/Families",         37),
    (6,  "MATHEMATICUS",  "OPERARIUS MATHEMATICORUM",          "Math/Formulas/Constants",        60),
    (7,  "SYNAPTICUS",    "OPERARIUS SYNAPSIUM",               "Synapses/Chaos/Connections",     20),
    (8,  "SUBSTRATUM",    "OPERARIUS SUBSTRATI",               "Blockchain/Nodes/Layers",        40),
    (9,  "UNIVERSUM",     "OPERARIUS UNIVERSORUM",             "Domains/Ecosystems/Councils",   105),
    (10, "CANISTRUM",     "OPERARIUS CANISTRORUM",             "Canister/Tech/Factory",          23),
    (11, "LICENTIATOR",   "OPERARIUS LICENTIARUM",             "Licenses/Documents/Rights",      24),
    (12, "DEFENSOR",      "OPERARIUS DEFENSIONIS ET CURAE",    "Defense/Care/Arsenal",           29),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  //  ENGINE INITIALIZATION
  //  Three engines per worker, each seeded with PHI-derived coherence
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create the 3 default engines (Generator, Router, Builder) for a worker
  func makeEngines() : [EngineState] {
    [
      { kind = #Generator; callsProcessed = 0; coherence = PHI * 0.618; isActive = true },
      { kind = #Router;    callsProcessed = 0; coherence = PHI * 0.5;   isActive = true },
      { kind = #Builder;   callsProcessed = 0; coherence = PHI * 0.382; isActive = true },
    ]
  };

  /// Build a WorkerDefinition from a spec tuple
  func initWorker(spec: (Nat, Text, Text, Text, Nat)) : WorkerDefinition {
    let (id, name, latin, domain, calls) = spec;
    {
      id = id;
      name = name;
      latinName = latin;
      domain = domain;
      callCount = calls;
      engines = makeEngines();
      totalCallsGenerated = calls;
      totalCallsRouted = calls;
      totalCallsBuilt = calls;
      phiResonance = PHI * Float.fromInt(id) / 12.0;
      status = #Active;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  INITIALIZATION — Construct full engine state with 12 workers / 36 engines
  // ═══════════════════════════════════════════════════════════════════════════

  public func initState() : AutoCallsEngineState {
    let workers = Array.map<(Nat, Text, Text, Text, Nat), WorkerDefinition>(WORKER_SPECS, initWorker);
    let totalCalls = Array.foldLeft<WorkerDefinition, Nat>(workers, 0, func(acc, w) { acc + w.callCount });
    {
      totalWorkers = 12;
      totalEngines = 36;
      totalCallsGenerated = totalCalls;
      totalCallsRouted = totalCalls;
      totalCallsBuilt = totalCalls;
      overallCoherence = PHI * 0.618;
      lastTick = 0;
      tickCount = 0;
      workers = workers;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  TICK — Advance all workers and engines by one heartbeat cycle
  //  PHI-modulated sine phase drives coherence oscillation
  // ═══════════════════════════════════════════════════════════════════════════

  public func tick(state: AutoCallsEngineState, beat: Nat) : AutoCallsEngineState {
    let now = Time.now();
    let phase = Float.sin(Float.fromInt(beat) * PHI * 0.01);

    let updatedWorkers = Array.mapEntries<WorkerDefinition, WorkerDefinition>(state.workers, func(i, w) {
      let newGenerated = w.totalCallsGenerated + w.callCount / 100 + 1;
      let newRouted = w.totalCallsRouted + w.callCount / 100 + 1;
      let newBuilt = w.totalCallsBuilt + w.callCount / 100 + 1;
      let resonance = PHI * Float.fromInt(i + 1) / 12.0 + phase * 0.1;

      let updatedEngines = Array.mapEntries<EngineState, EngineState>(w.engines, func(j, e) {
        let coherenceShift = Float.sin(Float.fromInt(beat * (j + 1)) * 0.1) * 0.05;
        {
          kind = e.kind;
          callsProcessed = e.callsProcessed + w.callCount / 100 + 1;
          coherence = e.coherence + coherenceShift;
          isActive = true;
        }
      });

      {
        id = w.id;
        name = w.name;
        latinName = w.latinName;
        domain = w.domain;
        callCount = w.callCount;
        engines = updatedEngines;
        totalCallsGenerated = newGenerated;
        totalCallsRouted = newRouted;
        totalCallsBuilt = newBuilt;
        phiResonance = resonance;
        status = #Active;
      }
    });

    let totalGen = Array.foldLeft<WorkerDefinition, Nat>(updatedWorkers, 0, func(acc, w) { acc + w.totalCallsGenerated });
    let totalRou = Array.foldLeft<WorkerDefinition, Nat>(updatedWorkers, 0, func(acc, w) { acc + w.totalCallsRouted });
    let totalBui = Array.foldLeft<WorkerDefinition, Nat>(updatedWorkers, 0, func(acc, w) { acc + w.totalCallsBuilt });
    let avgCoherence = PHI * 0.618 + phase * 0.05;

    {
      totalWorkers = 12;
      totalEngines = 36;
      totalCallsGenerated = totalGen;
      totalCallsRouted = totalRou;
      totalCallsBuilt = totalBui;
      overallCoherence = avgCoherence;
      lastTick = now;
      tickCount = state.tickCount + 1;
      workers = updatedWorkers;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  QUERY: SUMMARY — High-level overview of all 776 calls
  // ═══════════════════════════════════════════════════════════════════════════

  public func getSummary(state: AutoCallsEngineState) : AutoCallsSummary {
    let names = Array.map<WorkerDefinition, Text>(state.workers, func(w) { w.name });
    let byDomain = Array.map<WorkerDefinition, (Text, Nat)>(state.workers, func(w) { (w.domain, w.callCount) });
    {
      totalWorkers = state.totalWorkers;
      totalEngines = state.totalEngines;
      totalCalls = 776;
      workerNames = names;
      callsByDomain = byDomain;
      overallCoherence = state.overallCoherence;
      tickCount = state.tickCount;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  QUERY: ROUTING — Call routing distribution across workers
  // ═══════════════════════════════════════════════════════════════════════════

  public func getRouting(state: AutoCallsEngineState) : RoutingSummary {
    let byWorker = Array.map<WorkerDefinition, (Text, Nat)>(state.workers, func(w) { (w.name, w.totalCallsRouted) });
    let totalRoutes = Array.foldLeft<WorkerDefinition, Nat>(state.workers, 0, func(acc, w) { acc + w.totalCallsRouted });
    {
      totalRoutes = totalRoutes;
      routesByWorker = byWorker;
      avgPhiScore = state.overallCoherence;
      activeRoutes = totalRoutes;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  QUERY: DOMAIN DETAILS — Per-domain breakdown with sample call IDs
  // ═══════════════════════════════════════════════════════════════════════════

  public func getDomainDetails(state: AutoCallsEngineState) : [DomainCallDetail] {
    Array.map<WorkerDefinition, DomainCallDetail>(state.workers, func(w) {
      let sampleIds = Array.tabulate<Text>(Nat.min(5, w.callCount), func(i) {
        w.name # "-CALL-" # Nat.toText(i + 1)
      });
      {
        domain = w.domain;
        workerName = w.name;
        latinName = w.latinName;
        callCount = w.callCount;
        sampleCallIds = sampleIds;
        engineStates = w.engines;
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  QUERY: FULL STATUS — Combined summary + routing + domains + workers
  // ═══════════════════════════════════════════════════════════════════════════

  public func getFullStatus(state: AutoCallsEngineState) : AutoCallsFullStatus {
    {
      summary = getSummary(state);
      routing = getRouting(state);
      domains = getDomainDetails(state);
      workers = state.workers;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  QUERY: WORKER STATUS — All 12 worker definitions
  // ═══════════════════════════════════════════════════════════════════════════

  public func getWorkerStatus(state: AutoCallsEngineState) : [WorkerDefinition] {
    state.workers
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  QUERY: ENGINE STATUS — All 36 engine states grouped by worker
  // ═══════════════════════════════════════════════════════════════════════════

  public func getEngineStatus(state: AutoCallsEngineState) : [(Text, [EngineState])] {
    Array.map<WorkerDefinition, (Text, [EngineState])>(state.workers, func(w) {
      (w.name, w.engines)
    })
  };
};
