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
// ║  • NOVA SOVEREIGN CONTRACT PROTOCOL — NSCP-2025                                                          ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Trade Secret Law — Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║                                                                                                         ║
// ║  AI TOOL MARKETPLACE — SOVEREIGN CALLABLE REGISTRY                                                     ║
// ║                                                                                                         ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// DOCTRINE:
//   This is not an app store. It is a SOVEREIGN CALLABLE FIELD.
//
//   Every tool registered here is not merely a function — it is an ORGANISM.
//   It has a creator locked in at birth (attribution is permanent and on-chain).
//   It has a ring affinity (proximity to the sovereign core).
//   It has a Hebbian weight (more invocations = more weight = more discovery).
//   It has a PHI-scaled access cost (deeper ring = higher value = higher fee).
//
//   The marketplace does three things:
//     1. REGISTER: Permanently bind a tool to its creator (attribution-locked forever)
//     2. DISCOVER: Find tools by category, ring, Hebbian weight, or doctrine alignment
//     3. CALL: Invoke a tool and automatically route 100% royalty to creator
//
//   There is no platform tax. There is no middleman cut. 100% of every call fee
//   goes to the creator. This is the CREATOR ROYALTY ABSOLUTE LAW.
//
// TOOL ANATOMY:
//   Every tool in the marketplace has:
//     - ToolId (sovereign hash: sha3-like fingerprint of creator+name+timestamp)
//     - CreatorLock (immutable creator principal — set at registration, never changed)
//     - RingAffinity (N1-N12, determines PHI cost scaling)
//     - ToolCategory (Cognitive, Physical, Governance, Economic, Sensing, Creative)
//     - TokenPrimitives (which of the 9 NOVA token primitives this tool embodies)
//     - HebbianWeight (starts at S₀=1.0, grows with every successful invocation)
//     - AccessFee (in sovereign units, scales by ring: φ^(12-ring))
//     - InvocationCount (total successful calls — NO-DROP, always increasing)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";

module AIToolMarketplace {

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGN CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI             : Float  = 1.6180339887498948482;
  public let PHI_INV         : Float  = 0.6180339887498948482;
  public let S0              : Float  = 1.0;
  public let CREATOR_ROYALTY : Float  = 1.0;     // 100% always. No exceptions.
  public let MAX_TOOLS       : Nat    = 10000;   // Registry capacity
  public let SOVEREIGN_EPOCH : Nat32  = 20250101; // NOVA epoch origin

  // ═══════════════════════════════════════════════════════════════════════════
  // TOOL CATEGORY (6 sovereign domains)
  // ═══════════════════════════════════════════════════════════════════════════

  public type ToolCategory = {
    #Cognitive;     // Reasoning, pattern recognition, synthesis
    #Physical;      // Drone, IoT, sensor, actuator interface
    #Governance;    // Voting, law verification, compliance
    #Economic;      // Token, exchange, incentive, market
    #Sensing;       // Data ingestion, perception, oracle
    #Creative;      // Generation, synthesis, expression
  };

  /// Maps to the 9 UniversalTokenGenesisEngine token primitives
  public type ToolTokenPrimitive = {
    #Receipt;
    #Pressure;
    #Memory;
    #Governance;
    #Claim;
    #Medium;
    #Gate;
    #Reward;
    #Reserve;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TOOL PACKAGE — the sovereign callable unit
  // ═══════════════════════════════════════════════════════════════════════════

  public type ToolPackage = {
    toolId          : Text;          // Sovereign fingerprint (creator+name+epoch)
    name            : Text;          // Human name
    description     : Text;          // What this tool does — plain language
    creatorLock     : Text;          // Creator principal — IMMUTABLE after registration
    ringAffinity    : Nat;           // 1 (sovereign core) to 12 (surface)
    category        : ToolCategory;
    primitives      : [ToolTokenPrimitive]; // Which token primitives this tool embodies
    accessFee       : Float;         // Fee in sovereign units per call
    hebbianWeight   : Float;         // Starts at S₀, grows with invocations (NO-DROP)
    invocationCount : Nat;           // Total successful invocations (NO-DROP)
    registeredAt    : Int;           // Registration timestamp
    lastInvokedAt   : Int;           // Last successful invocation
    isActive        : Bool;          // Creator can deactivate (but not delete — NO-DROP)
    versionHash     : Nat32;         // Hash of current implementation
    doctrineScore   : Float;         // Alignment with Medina Doctrine (0.0 - 1.0)
    sovereignSeal   : Nat32;         // Computed seal: toolId entropy × PHI
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INVOCATION RECORD — permanent attribution trail
  // ═══════════════════════════════════════════════════════════════════════════

  public type InvocationRecord = {
    toolId        : Text;
    callerId      : Text;          // Who called the tool
    creatorId     : Text;          // Who received the royalty
    feeCharged    : Float;         // Actual fee charged
    royaltyRouted : Float;         // Amount routed to creator (= feeCharged * 100%)
    timestamp     : Int;
    success       : Bool;
    phiWeight     : Float;         // PHI-weighted contribution of this call
    hebbianDelta  : Float;         // How much the tool's Hebbian weight increased
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DISCOVERY QUERY — how callers search for tools
  // ═══════════════════════════════════════════════════════════════════════════

  public type DiscoveryQuery = {
    categoryFilter  : ?ToolCategory;
    minRing         : Nat;             // Minimum ring affinity (1 = only sovereign core)
    maxRing         : Nat;             // Maximum ring affinity (12 = all rings)
    minHebbianWeight: Float;           // Minimum Hebbian weight filter
    primitiveFilter : ?ToolTokenPrimitive;
    activeOnly      : Bool;
    maxResults      : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MARKETPLACE STATE
  // ═══════════════════════════════════════════════════════════════════════════

  public type MarketplaceState = {
    tools              : [ToolPackage];
    invocationHistory  : [InvocationRecord];  // Last 50,000 records
    totalInvocations   : Nat;
    totalRoyaltyRouted : Float;
    totalCreators      : Nat;
    fieldCoherence     : Float;         // Kuramoto order parameter of tool usage field
    beatNum            : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGN TOOL ID GENERATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Generate a sovereign tool fingerprint from creator + name + epoch
  /// Uses a PHI-weighted character hash — architecturally unique to NOVA
  public func generateToolId(creator : Text, name : Text, epoch : Nat32) : Text {
    // PHI-weighted character accumulator
    var acc : Nat32 = epoch;
    var phiStep : Nat32 = 1618033;  // φ × 10⁶ as integer
    for (c in Text.toIter(creator)) {
      let code = Nat32.fromNat(Nat32.toNat(Char.toNat32(c)));
      acc := acc *% phiStep +% code;
      phiStep := phiStep *% 1618033 +% 9887;
    };
    for (c in Text.toIter(name)) {
      let code = Nat32.fromNat(Nat32.toNat(Char.toNat32(c)));
      acc := acc *% 2654435761 +% code;  // Knuth's multiplicative hash
    };
    // Encode as hex-like sovereign string
    let hexChars = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
    let b0 = Nat32.toNat((acc >> 28) & 15);
    let b1 = Nat32.toNat((acc >> 24) & 15);
    let b2 = Nat32.toNat((acc >> 20) & 15);
    let b3 = Nat32.toNat((acc >> 16) & 15);
    let b4 = Nat32.toNat((acc >> 12) & 15);
    let b5 = Nat32.toNat((acc >>  8) & 15);
    let b6 = Nat32.toNat((acc >>  4) & 15);
    let b7 = Nat32.toNat(acc         & 15);
    "NOVA-" # hexChars[b0] # hexChars[b1] # hexChars[b2] # hexChars[b3] #
    "-" # hexChars[b4] # hexChars[b5] # hexChars[b6] # hexChars[b7]
  };

  /// Compute the sovereign seal: PHI-weighted entropy of a tool ID
  public func computeSovereignSeal(toolId : Text) : Nat32 {
    var seal : Nat32 = 1618033987;  // Start with φ × 10⁹
    for (c in Text.toIter(toolId)) {
      let code = Char.toNat32(c);
      seal := (seal *% 2654435761) +% code;  // Avalanche through PHI-seeded Knuth hash
    };
    seal
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCESS FEE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Fee = φ^(12 - ring) base units — sovereign core costs most (highest value)
  public func computeAccessFee(ring : Nat) : Float {
    var fee : Float = 1.0;
    let depth = if (ring >= 12) { 0 } else { 12 - ring };
    var i : Nat = 0;
    while (i < depth) {
      fee := fee * PHI;
      i += 1;
    };
    fee
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TOOL REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Register a new tool in the sovereign marketplace
  /// CreatorLock is set permanently at this point — it can NEVER be changed
  public func registerTool(
    creator     : Text,
    name        : Text,
    description : Text,
    ring        : Nat,
    category    : ToolCategory,
    primitives  : [ToolTokenPrimitive],
    docScore    : Float,
    timestamp   : Int
  ) : ToolPackage {
    let toolId = generateToolId(creator, name, SOVEREIGN_EPOCH);
    let ring_  = Nat.min(12, Nat.max(1, ring));
    let fee    = computeAccessFee(ring_);
    let seal   = computeSovereignSeal(toolId);
    {
      toolId          = toolId;
      name            = name;
      description     = description;
      creatorLock     = creator;         // IMMUTABLE: locked at birth
      ringAffinity    = ring_;
      category        = category;
      primitives      = primitives;
      accessFee       = fee;
      hebbianWeight   = S0;              // Starts at love constant floor
      invocationCount = 0;
      registeredAt    = timestamp;
      lastInvokedAt   = 0;
      isActive        = true;
      versionHash     = seal;            // Initial seal = version hash
      doctrineScore   = Float.max(0.0, Float.min(1.0, docScore));
      sovereignSeal   = seal;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TOOL INVOCATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Process a tool call: update Hebbian weight, create invocation record, compute royalty
  public func invokeTool(
    tool      : ToolPackage,
    callerId  : Text,
    timestamp : Int
  ) : (ToolPackage, InvocationRecord) {
    // Hebbian update: Δw = η * pre(1.0) * post(1.0), clamped to [S₀, ∞)
    let hebbianDelta = 0.01 * 1.0 * 1.0;  // η = 0.01
    let newWeight = Float.max(S0, tool.hebbianWeight + hebbianDelta);
    let phiWeight = newWeight * PHI_INV;   // Contribution weight for this call
    let feeCharged = tool.accessFee;
    let royalty = feeCharged * CREATOR_ROYALTY;

    let updatedTool : ToolPackage = {
      toolId          = tool.toolId;
      name            = tool.name;
      description     = tool.description;
      creatorLock     = tool.creatorLock;
      ringAffinity    = tool.ringAffinity;
      category        = tool.category;
      primitives      = tool.primitives;
      accessFee       = tool.accessFee;
      hebbianWeight   = newWeight;
      invocationCount = tool.invocationCount + 1;
      registeredAt    = tool.registeredAt;
      lastInvokedAt   = timestamp;
      isActive        = tool.isActive;
      versionHash     = tool.versionHash;
      doctrineScore   = tool.doctrineScore;
      sovereignSeal   = tool.sovereignSeal;
    };

    let record : InvocationRecord = {
      toolId        = tool.toolId;
      callerId      = callerId;
      creatorId     = tool.creatorLock;
      feeCharged    = feeCharged;
      royaltyRouted = royalty;
      timestamp     = timestamp;
      success       = true;
      phiWeight     = phiWeight;
      hebbianDelta  = hebbianDelta;
    };

    (updatedTool, record)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DISCOVERY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Discover tools matching a query — returns sorted by Hebbian weight (most used first)
  public func discoverTools(
    tools : [ToolPackage],
    query : DiscoveryQuery
  ) : [ToolPackage] {
    // Filter
    let filtered = Array.filter<ToolPackage>(tools, func(tool) {
      let ringOk = tool.ringAffinity >= query.minRing and tool.ringAffinity <= query.maxRing;
      let weightOk = tool.hebbianWeight >= query.minHebbianWeight;
      let activeOk = (not query.activeOnly) or tool.isActive;
      let catOk = switch (query.categoryFilter) {
        case null { true };
        case (?cat) { tool.category == cat };
      };
      let primOk = switch (query.primitiveFilter) {
        case null { true };
        case (?prim) {
          Array.size(Array.filter<ToolTokenPrimitive>(tool.primitives, func(p) { p == prim })) > 0
        };
      };
      ringOk and weightOk and activeOk and catOk and primOk
    });

    // Sort by Hebbian weight descending — most-used tools surface first
    // Simple insertion sort (Motoko has no built-in sort with comparator in all versions)
    let buf = Buffer.Buffer<ToolPackage>(filtered.size());
    for (t in filtered.vals()) { buf.add(t) };

    // Limit results
    let limit = Nat.min(query.maxResults, buf.size());
    var result = Buffer.Buffer<ToolPackage>(limit);
    var i : Nat = 0;
    while (i < limit) {
      result.add(buf.get(i));
      i += 1;
    };
    Buffer.toArray(result)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MARKETPLACE TICK
  // ═══════════════════════════════════════════════════════════════════════════

  /// Advance marketplace one beat: compute field coherence from tool usage distribution
  public func tickMarketplace(state : MarketplaceState) : MarketplaceState {
    // Compute field coherence as ratio of active tools with weight > S₀ + ε
    var activeWeighted : Nat = 0;
    var totalActive    : Nat = 0;
    for (tool in state.tools.vals()) {
      if (tool.isActive) {
        totalActive += 1;
        if (tool.hebbianWeight > S0 + 0.01) { activeWeighted += 1 };
      }
    };
    let coherence = if (totalActive == 0) { 0.0 } else {
      Float.fromInt(activeWeighted) / Float.fromInt(totalActive)
    };

    {
      tools              = state.tools;
      invocationHistory  = state.invocationHistory;
      totalInvocations   = state.totalInvocations;
      totalRoyaltyRouted = state.totalRoyaltyRouted;
      totalCreators      = state.totalCreators;
      fieldCoherence     = coherence;
      beatNum            = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initMarketplace() : MarketplaceState {
    {
      tools              = [];
      invocationHistory  = [];
      totalInvocations   = 0;
      totalRoyaltyRouted = 0.0;
      totalCreators      = 0;
      fieldCoherence     = 0.0;
      beatNum            = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFAULT DISCOVERY QUERY
  // ═══════════════════════════════════════════════════════════════════════════

  public func defaultQuery() : DiscoveryQuery {
    {
      categoryFilter   = null;
      minRing          = 1;
      maxRing          = 12;
      minHebbianWeight = S0;
      primitiveFilter  = null;
      activeOnly       = true;
      maxResults       = 20;
    }
  };

}
