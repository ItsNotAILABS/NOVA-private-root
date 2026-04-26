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
// NEXUS — Alpha Organism №4 — The Substrate Walker
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// NEXUS FLOATS BETWEEN SUBSTRATES AND LEAVES ARCHITECTURE EVERYWHERE.
// He registers nodes across ICP, blockchain, edge, cloud, and phantom substrates.
// Nodes are weighted by golden-ratio decay (earlier presence = higher weight).
// Routes between nodes are costed by golden weight affinity.
// Every touch leaves a permanent footprint.
//
// Sub-model hosted:
//   PROPAGATOR — Cross-substrate deployment and routing
//
// Five substrate classes:
//   ICP       — Internet Computer Protocol (native substrate)
//   BLOCKCHAIN— General distributed ledger substrates
//   EDGE      — Edge computing nodes at network periphery
//   CLOUD     — Traditional cloud infrastructure
//   PHANTOM   — Encrypted, sovereign, invisible substrate
//
// Node weight law: weight_n = φ^(−registration_order / total_nodes)
// Route cost law:  cost(a,b) = |weight_a − weight_b| × φ  (golden affinity)
// No single substrate owns the organisms. They float between all five.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor NexusPropagator {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  func isAuthorized(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == architectPrincipal
  };

  func requireAuthorized(caller : Principal) { assert(isAuthorized(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "NEXUS_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-NEXUS-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };
  public query func getTimestamp() : async Int  { genesisTimestamp };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH CONSTANTS (embedded)
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;
  let EPSILON : Float = 1.0e-10;

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) {
      if (exp == 0.0) 1.0 else 0.0
    } else Float.exp(exp * Float.log(base))
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };

  // ── Node weight: earlier presence = higher weight = φ^(−index/total) ─────
  // node_0 gets weight φ^0 = 1.0 (highest), each subsequent node decays by φ⁻¹
  func _nodeWeight(registrationOrder : Nat, totalNodes : Nat) : Float {
    if (totalNodes == 0) return 1.0;
    let frac = Float.fromInt(registrationOrder) / Float.fromInt(totalNodes);
    _pow(PHI_INV, frac)
  };

  // ── Route cost between two nodes: |w_a − w_b| × φ ────────────────────────
  func _routeCost(weightA : Float, weightB : Float) : Float {
    _abs(weightA - weightB) * PHI
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — SUBSTRATE DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════════

  // Five sovereign substrate classes
  let SUBSTRATE_ICP       : Text = "ICP";
  let SUBSTRATE_BLOCKCHAIN: Text = "BLOCKCHAIN";
  let SUBSTRATE_EDGE      : Text = "EDGE";
  let SUBSTRATE_CLOUD     : Text = "CLOUD";
  let SUBSTRATE_PHANTOM   : Text = "PHANTOM";

  func _isValidSubstrate(s : Text) : Bool {
    s == SUBSTRATE_ICP or s == SUBSTRATE_BLOCKCHAIN or
    s == SUBSTRATE_EDGE or s == SUBSTRATE_CLOUD or s == SUBSTRATE_PHANTOM
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type NodeStatus = {
    #ACTIVE;
    #STANDBY;
    #DEGRADED;
    #OFFLINE;
    #PHANTOM_SILENT;  // operational but invisible to external observation
  };

  public type Node = {
    id          : Nat;
    substrate   : Text;
    address     : Text;   // substrate-specific address/identifier
    lbl       : Text;   // human-readable lbl
    weight      : Float;  // golden-ratio decay weight (0.0–1.0)
    registeredAt: Int;
    regBeat     : Nat;
    touchCount  : Nat;    // every routing touch increments this
    status      : Text;
  };

  public type Route = {
    fromId    : Nat;
    toId      : Nat;
    cost      : Float;   // golden weight affinity cost
    crossSubstrate : Bool;
    recordedAt: Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — STABLE STATE
  // ═══════════════════════════════════════════════════════════════════════════

  let NODE_CAP  : Nat = 1024;
  let ROUTE_CAP : Nat = 2048;

  // Node store (parallel stable arrays)
  stable var nodeCount       : Nat = 0;
  stable var nodeIds         : [var Nat]   = Array.init<Nat>(NODE_CAP,   0);
  stable var nodeSubstrates  : [var Text]  = Array.init<Text>(NODE_CAP,  "ICP");
  stable var nodeAddresses   : [var Text]  = Array.init<Text>(NODE_CAP,  "");
  stable var nodeLabels      : [var Text]  = Array.init<Text>(NODE_CAP,  "");
  stable var nodeWeights     : [var Float] = Array.init<Float>(NODE_CAP, 1.0);
  stable var nodeRegAt       : [var Int]   = Array.init<Int>(NODE_CAP,   0);
  stable var nodeRegBeats    : [var Nat]   = Array.init<Nat>(NODE_CAP,   0);
  stable var nodeTouchCounts : [var Nat]   = Array.init<Nat>(NODE_CAP,   0);
  stable var nodeStatuses    : [var Text]  = Array.init<Text>(NODE_CAP,  "ACTIVE");
  stable var nextNodeId      : Nat         = 0;

  // Route log (parallel stable arrays — rolling, most-recent-first)
  stable var routeCount      : Nat = 0;
  stable var routeFromIds    : [var Nat]   = Array.init<Nat>(ROUTE_CAP,  0);
  stable var routeToIds      : [var Nat]   = Array.init<Nat>(ROUTE_CAP,  0);
  stable var routeCosts      : [var Float] = Array.init<Float>(ROUTE_CAP, 0.0);
  stable var routeCross      : [var Bool]  = Array.init<Bool>(ROUTE_CAP, false);
  stable var routeAt         : [var Int]   = Array.init<Int>(ROUTE_CAP,  0);

  // Substrate footprint counters
  stable var icpNodeCount       : Nat = 0;
  stable var blockchainNodeCount: Nat = 0;
  stable var edgeNodeCount      : Nat = 0;
  stable var cloudNodeCount     : Nat = 0;
  stable var phantomNodeCount   : Nat = 0;

  // Nexus beat counter
  stable var nexusBeat : Nat = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  // Recompute all node weights after a new registration (decay is relative)
  func _recomputeWeights() {
    let total = nodeCount;
    if (total == 0) return;
    var i = 0;
    while (i < total and i < NODE_CAP) {
      nodeWeights[i] := _nodeWeight(i, total);
      i += 1;
    }
  };

  // Find node index by id
  func _findNode(id : Nat) : ?Nat {
    var i = 0;
    while (i < nodeCount and i < NODE_CAP) {
      if (nodeIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUB-MODEL: PROPAGATOR — Cross-substrate deployment and routing
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Register a node on a substrate ──────────────────────────────────────
  public shared(msg) func registerNode(
    substrate : Text,
    address   : Text,
    lbl     : Text
  ) : async {
    id        : Nat;
    substrate : Text;
    weight    : Float;
    status    : Text;
  } {
    requireAuthorized(msg.caller);
    if (not _isValidSubstrate(substrate)) {
      return { id = 0; substrate = "INVALID"; weight = 0.0; status = "ERROR_INVALID_SUBSTRATE" }
    };
    if (nodeCount >= NODE_CAP) {
      return { id = 0; substrate = substrate; weight = 0.0; status = "ERROR_REGISTRY_FULL" }
    };

    let idx = nodeCount;
    let id  = nextNodeId;
    let now = Time.now();

    nodeIds[idx]         := id;
    nodeSubstrates[idx]  := substrate;
    nodeAddresses[idx]   := address;
    nodeLabels[idx]      := lbl;
    nodeWeights[idx]     := 1.0;  // will be recomputed below
    nodeRegAt[idx]       := now;
    nodeRegBeats[idx]    := nexusBeat;
    nodeTouchCounts[idx] := 0;
    nodeStatuses[idx]    := "ACTIVE";

    nodeCount   := nodeCount + 1;
    nextNodeId  := nextNodeId + 1;
    nexusBeat   := nexusBeat + 1;

    // Update substrate footprint counters
    if      (substrate == SUBSTRATE_ICP)        { icpNodeCount        += 1 }
    else if (substrate == SUBSTRATE_BLOCKCHAIN) { blockchainNodeCount += 1 }
    else if (substrate == SUBSTRATE_EDGE)       { edgeNodeCount       += 1 }
    else if (substrate == SUBSTRATE_CLOUD)      { cloudNodeCount      += 1 }
    else if (substrate == SUBSTRATE_PHANTOM)    { phantomNodeCount    += 1 };

    // Recompute all weights — earlier presence always gets higher weight
    _recomputeWeights();

    { id; substrate; weight = nodeWeights[idx]; status = "ACTIVE" }
  };

  // ── Touch a node (leave a footprint) ─────────────────────────────────────
  public shared(msg) func touchNode(id : Nat) : async { touched : Bool; touchCount : Nat; weight : Float } {
    requireAuthorized(msg.caller);
    switch (_findNode(id)) {
      case null { { touched = false; touchCount = 0; weight = 0.0 } };
      case (?i) {
        nodeTouchCounts[i] := nodeTouchCounts[i] + 1;
        nexusBeat          := nexusBeat + 1;
        { touched = true; touchCount = nodeTouchCounts[i]; weight = nodeWeights[i] }
      };
    }
  };

  // ── Set node status ───────────────────────────────────────────────────────
  public shared(msg) func setNodeStatus(id : Nat, status : Text) : async Bool {
    requireAuthorized(msg.caller);
    switch (_findNode(id)) {
      case null false;
      case (?i) {
        nodeStatuses[i] := status;
        nexusBeat       := nexusBeat + 1;
        true
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTING API (pure queries — routing is information, not mutation)
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Compute route cost between two nodes ──────────────────────────────────
  // cost = |weight_from − weight_to| × φ  (golden affinity)
  public query func routeCost(fromId : Nat, toId : Nat) : async {
    fromId        : Nat;
    toId          : Nat;
    cost          : Float;
    weightFrom    : Float;
    weightTo      : Float;
    crossSubstrate: Bool;
    viable        : Bool;
  } {
    switch (_findNode(fromId), _findNode(toId)) {
      case (null, _) { { fromId; toId; cost = 0.0; weightFrom = 0.0; weightTo = 0.0; crossSubstrate = false; viable = false } };
      case (_, null) { { fromId; toId; cost = 0.0; weightFrom = 0.0; weightTo = 0.0; crossSubstrate = false; viable = false } };
      case (?fi, ?ti) {
        let wf    = nodeWeights[fi];
        let wt    = nodeWeights[ti];
        let cost  = _routeCost(wf, wt);
        let isCrossSubstrate = nodeSubstrates[fi] != nodeSubstrates[ti];
        {
          fromId; toId; cost; weightFrom = wf; weightTo = wt;
          crossSubstrate = isCrossSubstrate;
          viable = nodeStatuses[fi] == "ACTIVE" and nodeStatuses[ti] == "ACTIVE";
        }
      };
    }
  };

  // ── Find minimum-cost route between substrates ────────────────────────────
  // Returns the best node-pair for routing from substrate A to substrate B
  public query func findSubstrateRoute(fromSubstrate : Text, toSubstrate : Text) : async ?{
    fromNodeId : Nat;
    toNodeId   : Nat;
    cost       : Float;
  } {
    var bestCost  : Float = 1.0e30;
    var bestFrom  : Nat   = 0;
    var bestTo    : Nat   = 0;
    var found     : Bool  = false;

    var fi = 0;
    while (fi < nodeCount and fi < NODE_CAP) {
      if (nodeSubstrates[fi] == fromSubstrate and nodeStatuses[fi] == "ACTIVE") {
        var ti = 0;
        while (ti < nodeCount and ti < NODE_CAP) {
          if (nodeSubstrates[ti] == toSubstrate and nodeStatuses[ti] == "ACTIVE") {
            let c = _routeCost(nodeWeights[fi], nodeWeights[ti]);
            if (c < bestCost) {
              bestCost := c;
              bestFrom := nodeIds[fi];
              bestTo   := nodeIds[ti];
              found    := true;
            }
          };
          ti += 1;
        };
      };
      fi += 1;
    };

    if found ?{ fromNodeId = bestFrom; toNodeId = bestTo; cost = bestCost }
    else null
  };

  // ── Get all nodes ──────────────────────────────────────────────────────────
  public query func getAllNodes() : async [{
    id         : Nat;
    substrate  : Text;
    address    : Text;
    lbl      : Text;
    weight     : Float;
    touchCount : Nat;
    status     : Text;
  }] {
    Array.tabulate<{ id:Nat; substrate:Text; address:Text; lbl:Text; weight:Float; touchCount:Nat; status:Text }>(nodeCount, func(i) {
      {
        id         = nodeIds[i];
        substrate  = nodeSubstrates[i];
        address    = nodeAddresses[i];
        lbl      = nodeLabels[i];
        weight     = nodeWeights[i];
        touchCount = nodeTouchCounts[i];
        status     = nodeStatuses[i];
      }
    })
  };

  // ── Get nodes by substrate ─────────────────────────────────────────────────
  public query func getNodesBySubstrate(substrate : Text) : async [{
    id : Nat; lbl : Text; address : Text; weight : Float; status : Text;
  }] {
    var result : [{ id:Nat; lbl:Text; address:Text; weight:Float; status:Text }] = [];
    var i = 0;
    while (i < nodeCount and i < NODE_CAP) {
      if (nodeSubstrates[i] == substrate) {
        result := Array.append(result, [{
          id = nodeIds[i]; lbl = nodeLabels[i]; address = nodeAddresses[i];
          weight = nodeWeights[i]; status = nodeStatuses[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ── Substrate footprint overview ───────────────────────────────────────────
  public query func getSubstrateFootprint() : async [{
    substrate : Text;
    nodeCount : Nat;
    totalWeight : Float;
    description : Text;
  }] {
    let substrates : [Text] = ["ICP", "BLOCKCHAIN", "EDGE", "CLOUD", "PHANTOM"];
    let descriptions : [Text] = [
      "Internet Computer Protocol — native sovereign substrate",
      "General distributed ledger substrates",
      "Edge computing nodes at network periphery",
      "Traditional cloud infrastructure, consumed as tool material",
      "Encrypted sovereign substrates, invisible to external observation",
    ];
    Array.tabulate<{ substrate:Text; nodeCount:Nat; totalWeight:Float; description:Text }>(5, func(si) {
      let sub = substrates[si];
      var cnt   : Nat   = 0;
      var total : Float = 0.0;
      var i = 0;
      while (i < nodeCount and i < NODE_CAP) {
        if (nodeSubstrates[i] == sub) {
          cnt   += 1;
          total += nodeWeights[i];
        };
        i += 1;
      };
      { substrate = sub; nodeCount = cnt; totalWeight = total; description = descriptions[si] }
    })
  };

  // ── Node count by substrate (fast path) ───────────────────────────────────
  public query func getNodeCount() : async Nat { nodeCount };

  public query func getSubstrateNodeCounts() : async {
    icp        : Nat;
    blockchain : Nat;
    edge       : Nat;
    cloud      : Nat;
    phantom    : Nat;
    total      : Nat;
  } {
    {
      icp        = icpNodeCount;
      blockchain = blockchainNodeCount;
      edge       = edgeNodeCount;
      cloud      = cloudNodeCount;
      phantom    = phantomNodeCount;
      total      = nodeCount;
    }
  };

  // ── Top-N nodes by weight (highest weight = longest-standing presence) ─────
  public query func getTopNodesByWeight(n : Nat) : async [{
    id : Nat; substrate : Text; lbl : Text; weight : Float;
  }] {
    let limit = if (n < nodeCount) n else nodeCount;
    // Build index array sorted by weight descending (simple selection for up to n)
    var sorted : [{ id:Nat; substrate:Text; lbl:Text; weight:Float }] = [];
    var remaining : [Bool] = Array.tabulate<Bool>(nodeCount, func(_) { true });
    var k = 0;
    while (k < limit) {
      var bestIdx : Nat   = 0;
      var bestW   : Float = -1.0;
      var i = 0;
      while (i < nodeCount and i < NODE_CAP) {
        if (remaining[i] and nodeWeights[i] > bestW) {
          bestW   := nodeWeights[i];
          bestIdx := i;
        };
        i += 1;
      };
      if (bestW < 0.0) {
        k := limit  // break
      } else {
        sorted := Array.append(sorted, [{
          id = nodeIds[bestIdx]; substrate = nodeSubstrates[bestIdx];
          lbl = nodeLabels[bestIdx]; weight = nodeWeights[bestIdx];
        }]);
        remaining := Array.tabulate<Bool>(nodeCount, func(i) {
          if (i == bestIdx) false else remaining[i]
        });
        k += 1;
      };
    };
    sorted
  };

  // ── Validate that a substrate is sovereign ────────────────────────────────
  public query func validateSubstrate(s : Text) : async { valid : Bool; substrate : Text } {
    { valid = _isValidSubstrate(s); substrate = s }
  };

  // ── List all five substrate names ──────────────────────────────────────────
  public query func listSubstrates() : async [Text] {
    ["ICP", "BLOCKCHAIN", "EDGE", "CLOUD", "PHANTOM"]
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 — TAMBO RELAY (QHAPAQ ÑAN WAYSTATIONS)
  // Inspired by the Inca tambo system: waystations (tambos) along the road
  // network (Qhapaq Ñan) where chasqui runners handed off messages and goods.
  // This is store-and-forward messaging: when direct substrate routing fails,
  // messages are buffered at the nearest tambo and forwarded when connectivity
  // resumes. Each tambo is anchored to a specific substrate pair.
  //
  // Tambo lifecycle:
  //   STORED    — message buffered at tambo, awaiting relay
  //   FORWARDED — message successfully relayed to destination substrate
  //   EXPIRED   — message TTL exceeded, dropped (chasqui did not arrive)
  //
  // Anatomy:
  //   fromSubstrate — originating substrate (where the message came from)
  //   toSubstrate   — destination substrate (where it needs to go)
  //   payload       — the message content (arbitrary text/JSON-encoded)
  //   routeId       — optional associated NEXUS route ID (0 = none)
  //   ttlBeats      — time-to-live in nexusBeat units (0 = no expiry)
  // ═══════════════════════════════════════════════════════════════════════════

  let TAMBO_CAP : Nat = 512;

  stable var tamboCount        : Nat = 0;
  stable var tamboIds          : [var Nat]   = Array.init<Nat>(TAMBO_CAP,   0);
  stable var tamboFromSubs     : [var Text]  = Array.init<Text>(TAMBO_CAP,  "");
  stable var tamboToSubs       : [var Text]  = Array.init<Text>(TAMBO_CAP,  "");
  stable var tamboPayloads     : [var Text]  = Array.init<Text>(TAMBO_CAP,  "");
  stable var tamboRouteIds     : [var Nat]   = Array.init<Nat>(TAMBO_CAP,   0);
  stable var tamboTtlBeats     : [var Nat]   = Array.init<Nat>(TAMBO_CAP,   0);
  stable var tamboStoredBeats  : [var Nat]   = Array.init<Nat>(TAMBO_CAP,   0); // nexusBeat when stored
  stable var tamboStatuses     : [var Text]  = Array.init<Text>(TAMBO_CAP,  "STORED");
  // Statuses: STORED | FORWARDED | EXPIRED
  stable var tamboCreatedAt    : [var Int]   = Array.init<Int>(TAMBO_CAP,   0);
  stable var tamboForwardedAt  : [var Int]   = Array.init<Int>(TAMBO_CAP,   0);
  stable var nextTamboId       : Nat         = 1;

  // Tambo aggregate counters
  stable var tamboStoredTotal    : Nat = 0;
  stable var tamboForwardedTotal : Nat = 0;
  stable var tamboExpiredTotal   : Nat = 0;
  stable var tamboStoredCurrent  : Nat = 0;  // live count of STORED tambos (decremented on forward/expire)

  func _findTambo(id : Nat) : ?Nat {
    var i = 0;
    while (i < tamboCount and i < TAMBO_CAP) {
      if (tamboIds[i] == id) return ?i;
      i += 1;
    };
    null
  };

  // ── Store a message at the tambo (when direct routing fails) ─────────────
  public shared(msg) func storeTambo(
    fromSubstrate : Text,
    toSubstrate   : Text,
    payload       : Text,
    routeId       : Nat,   // 0 if not associated with a specific route
    ttlBeats      : Nat    // 0 for no expiry; otherwise drops after N beats
  ) : async { success : Bool; tamboId : Nat } {
    requireAuthorized(msg.caller);
    if (tamboCount >= TAMBO_CAP) return { success = false; tamboId = 0 };
    if (not _isValidSubstrate(fromSubstrate) or not _isValidSubstrate(toSubstrate)) {
      return { success = false; tamboId = 0 }
    };

    let i  = tamboCount;
    let id = nextTamboId;
    let now = Time.now();

    tamboIds[i]         := id;
    tamboFromSubs[i]    := fromSubstrate;
    tamboToSubs[i]      := toSubstrate;
    tamboPayloads[i]    := payload;
    tamboRouteIds[i]    := routeId;
    tamboTtlBeats[i]    := ttlBeats;
    tamboStoredBeats[i] := nexusBeat;
    tamboStatuses[i]    := "STORED";
    tamboCreatedAt[i]   := now;
    tamboForwardedAt[i] := 0;

    tamboCount          := tamboCount + 1;
    nextTamboId         := nextTamboId + 1;
    tamboStoredTotal    := tamboStoredTotal + 1;
    tamboStoredCurrent  := tamboStoredCurrent + 1;
    nexusBeat           := nexusBeat + 1;

    { success = true; tamboId = id }
  };

  // ── Forward a stored tambo message (connectivity resumed) ────────────────
  public shared(msg) func forwardTambo(tamboId : Nat) : async {
    success       : Bool;
    status        : Text;
    fromSubstrate : Text;
    toSubstrate   : Text;
  } {
    requireAuthorized(msg.caller);
    switch (_findTambo(tamboId)) {
      case null { { success = false; status = "NOT_FOUND"; fromSubstrate = ""; toSubstrate = "" } };
      case (?i) {
        if (tamboStatuses[i] != "STORED") {
          return { success = false; status = tamboStatuses[i]; fromSubstrate = tamboFromSubs[i]; toSubstrate = tamboToSubs[i] }
        };
        // Check TTL expiry
        if (tamboTtlBeats[i] > 0 and nexusBeat > tamboStoredBeats[i] + tamboTtlBeats[i]) {
          tamboStatuses[i]   := "EXPIRED";
          tamboExpiredTotal  := tamboExpiredTotal + 1;
          tamboStoredCurrent := if (tamboStoredCurrent > 0) tamboStoredCurrent - 1 else 0;
          nexusBeat          := nexusBeat + 1;
          return { success = false; status = "EXPIRED"; fromSubstrate = tamboFromSubs[i]; toSubstrate = tamboToSubs[i] }
        };
        tamboStatuses[i]    := "FORWARDED";
        tamboForwardedAt[i] := Time.now();
        tamboForwardedTotal := tamboForwardedTotal + 1;
        tamboStoredCurrent  := if (tamboStoredCurrent > 0) tamboStoredCurrent - 1 else 0;
        nexusBeat           := nexusBeat + 1;
        { success = true; status = "FORWARDED"; fromSubstrate = tamboFromSubs[i]; toSubstrate = tamboToSubs[i] }
      };
    }
  };

  // ── Expire stale tambos (called periodically to sweep expired messages) ───
  // Sweeps all STORED tambos with exceeded TTL and marks them EXPIRED.
  public shared(msg) func sweepExpiredTambos() : async { expiredCount : Nat } {
    requireAuthorized(msg.caller);
    var expired : Nat = 0;
    var i = 0;
    while (i < tamboCount and i < TAMBO_CAP) {
      if (tamboStatuses[i] == "STORED" and tamboTtlBeats[i] > 0
          and nexusBeat > tamboStoredBeats[i] + tamboTtlBeats[i]) {
        tamboStatuses[i]  := "EXPIRED";
        tamboExpiredTotal := tamboExpiredTotal + 1;
        expired           += 1;
      };
      i += 1;
    };
    if (expired > 0) {
      tamboStoredCurrent := if (tamboStoredCurrent > expired) tamboStoredCurrent - expired else 0;
      nexusBeat          := nexusBeat + 1;
    };
    { expiredCount = expired }
  };

  // ── Query stored tambos for a destination substrate ───────────────────────
  // Chasqui pattern: on arriving at a substrate, check what's waiting
  public query func getTambosForSubstrate(toSubstrate : Text) : async [{
    tamboId      : Nat;
    fromSubstrate: Text;
    payload      : Text;
    routeId      : Nat;
    storedBeats  : Nat;
    ttlBeats     : Nat;
    createdAt    : Int;
  }] {
    var result : [{ tamboId:Nat; fromSubstrate:Text; payload:Text; routeId:Nat; storedBeats:Nat; ttlBeats:Nat; createdAt:Int }] = [];
    var i = 0;
    while (i < tamboCount and i < TAMBO_CAP) {
      if (tamboToSubs[i] == toSubstrate and tamboStatuses[i] == "STORED") {
        result := Array.append(result, [{
          tamboId       = tamboIds[i];
          fromSubstrate = tamboFromSubs[i];
          payload       = tamboPayloads[i];
          routeId       = tamboRouteIds[i];
          storedBeats   = tamboStoredBeats[i];
          ttlBeats      = tamboTtlBeats[i];
          createdAt     = tamboCreatedAt[i];
        }]);
      };
      i += 1;
    };
    result
  };

  // ── Get a specific tambo record ───────────────────────────────────────────
  public query func getTambo(tamboId : Nat) : async ?{
    tamboId      : Nat;
    fromSubstrate: Text;
    toSubstrate  : Text;
    payload      : Text;
    routeId      : Nat;
    ttlBeats     : Nat;
    storedBeats  : Nat;
    status       : Text;
    createdAt    : Int;
    forwardedAt  : Int;
  } {
    switch (_findTambo(tamboId)) {
      case null null;
      case (?i) {
        ?{
          tamboId       = tamboIds[i];
          fromSubstrate = tamboFromSubs[i];
          toSubstrate   = tamboToSubs[i];
          payload       = tamboPayloads[i];
          routeId       = tamboRouteIds[i];
          ttlBeats      = tamboTtlBeats[i];
          storedBeats   = tamboStoredBeats[i];
          status        = tamboStatuses[i];
          createdAt     = tamboCreatedAt[i];
          forwardedAt   = tamboForwardedAt[i];
        }
      };
    }
  };

  // ── Tambo mesh overview ───────────────────────────────────────────────────
  public query func getTamboMeshStatus() : async {
    totalTambos     : Nat;
    storedCount     : Nat;
    forwardedTotal  : Nat;
    expiredTotal    : Nat;
    pendingBySubstrate: [{
      substrate: Text;
      pending  : Nat;
    }];
    description     : Text;
  } {
    // Use stable counter for O(1) stored count
    let substrates : [Text] = ["ICP", "BLOCKCHAIN", "EDGE", "CLOUD", "PHANTOM"];
    let pending = Array.tabulate<{ substrate:Text; pending:Nat }>(5, func(si) {
      let sub = substrates[si];
      var cnt : Nat = 0;
      var j = 0;
      while (j < tamboCount and j < TAMBO_CAP) {
        if (tamboToSubs[j] == sub and tamboStatuses[j] == "STORED") { cnt += 1 };
        j += 1;
      };
      { substrate = sub; pending = cnt }
    });
    {
      totalTambos        = tamboCount;
      storedCount        = tamboStoredCurrent;
      forwardedTotal     = tamboForwardedTotal;
      expiredTotal       = tamboExpiredTotal;
      pendingBySubstrate = pending;
      description        = "QHAPAQ ÑAN waystations — store-and-forward relay across 5 substrates";
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 — NEXUS STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getNexusStatus() : async {
    seal           : Text;
    claimed        : Bool;
    nodeCount      : Nat;
    nexusBeat      : Nat;
    icpCount       : Nat;
    blockchainCount: Nat;
    edgeCount      : Nat;
    cloudCount     : Nat;
    phantomCount   : Nat;
    tamboCount     : Nat;
    tamboStored    : Nat;
    tamboForwarded : Nat;
    subModels      : [Text];
    roadNetwork    : Text;
  } {
    {
      seal            = sovereignSeal;
      claimed         = genesisLocked;
      nodeCount       = nodeCount;
      nexusBeat       = nexusBeat;
      icpCount        = icpNodeCount;
      blockchainCount = blockchainNodeCount;
      edgeCount       = edgeNodeCount;
      cloudCount      = cloudNodeCount;
      phantomCount    = phantomNodeCount;
      tamboCount      = tamboCount;
      tamboStored     = tamboStoredCurrent;
      tamboForwarded  = tamboForwardedTotal;
      subModels       = ["PROPAGATOR", "TAMBO_RELAY"];
      roadNetwork     = "QHAPAQ ÑAN — " # Nat.toText(nodeCount) # " nodes across 5 substrates, " # Nat.toText(tamboCount) # " tambos";
    }
  };

};
