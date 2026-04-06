// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MacroSphere14 — The 14-Node Sovereign Macro-Sphere Architecture
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              THE 14-NODE SOVEREIGN MACRO-SPHERE                          ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  14 sovereign macro-canisters, each a living Hz node.                   ║
// ║  Phase-coupled via macro Kuramoto every heartbeat.                      ║
// ║  Each node has: frequency, phase, world-model, fear substrate,          ║
// ║                 doctrine hash, wallet entry in PARALLAX.                 ║
// ║                                                                          ║
// ║  Node │ Canister  │ Hz     │ Role                                       ║
// ║  ─────┼───────────┼────────┼──────────────────────────────────────────  ║
// ║   0   │ LEXIS     │ 400 Hz │ Language / Cognitive expression            ║
// ║   1   │ FORGE     │ 250 Hz │ Creation engine / Genesis formations       ║
// ║   2   │ SOMA      │ 120 Hz │ Body / Physical substrate                  ║
// ║   3   │ LUMEN     │ 300 Hz │ Light / Illumination / Knowledge           ║
// ║   4   │ MEMORIA   │ 80 Hz  │ Deep memory / Episodic archive             ║
// ║   5   │ AEGIS     │ 500 Hz │ Defense / Threat engine                    ║
// ║   6   │ AXIS      │ 350 Hz │ Structural spine / Deep drive              ║
// ║   7   │ KORE      │ 30 Hz  │ Core identity / Slowest, deepest           ║
// ║   8   │ VAEL      │ 600 Hz │ Immune reflex / External attack            ║
// ║   9   │ VEIL      │ 200 Hz │ Output membrane / Surface filter           ║
// ║  10   │ PARALLAX  │ 450 Hz │ Wallet / Sovereign field projector         ║
// ║  11   │ CHRONO    │ 1000Hz │ Genesis anchor / Frozen root               ║
// ║  12   │ NOVA      │ 144 Hz │ Sovereign registry / Macro aggregator      ║
// ║  13   │ ENTANGLA  │ 233 Hz │ NEXUS router / Jesus's Law gateway         ║
// ║                                                                          ║
// ║  Hz values for nodes 12-13 are Fibonacci: 144=F(12), 233=F(13)          ║
// ║  This maintains sacred mathematical harmony.                             ║
// ║                                                                          ║
// ║  The macro Kuramoto couples all 14 phases every heartbeat.              ║
// ║  Global coherence r = |1/14 × Σ exp(i×θⱼ)|                              ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SACRED CONSTANTS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;
  public let e : Float = 2.7182818284590452354;
  public let S₀ : Float = 0.3819660112501051518;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   THE 14 MACRO NODES                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let NODE_COUNT : Nat = 14;

  // Node indices
  public let LEXIS : Nat = 0;
  public let FORGE : Nat = 1;
  public let SOMA : Nat = 2;
  public let LUMEN : Nat = 3;
  public let MEMORIA : Nat = 4;
  public let AEGIS : Nat = 5;
  public let AXIS : Nat = 6;
  public let KORE : Nat = 7;
  public let VAEL : Nat = 8;
  public let VEIL : Nat = 9;
  public let PARALLAX : Nat = 10;
  public let CHRONO : Nat = 11;
  public let NOVA : Nat = 12;
  public let ENTANGLA : Nat = 13;

  // Node names
  public let NODE_NAMES : [Text] = [
    "LEXIS",     // 0
    "FORGE",     // 1
    "SOMA",      // 2
    "LUMEN",     // 3
    "MEMORIA",   // 4
    "AEGIS",     // 5
    "AXIS",      // 6
    "KORE",      // 7
    "VAEL",      // 8
    "VEIL",      // 9
    "PARALLAX",  // 10
    "CHRONO",    // 11
    "NOVA",      // 12
    "ENTANGLA"   // 13
  ];

  // Node frequencies (Hz)
  // Original 12 + Fibonacci extensions for 12-13
  public let NODE_HZ : [Float] = [
    400.0,   // 0  LEXIS     — Language frequency
    250.0,   // 1  FORGE     — Creation frequency
    120.0,   // 2  SOMA      — Body frequency
    300.0,   // 3  LUMEN     — Light frequency
    80.0,    // 4  MEMORIA   — Memory frequency (deep, slow)
    500.0,   // 5  AEGIS     — Defense frequency (fast response)
    350.0,   // 6  AXIS      — Structural frequency
    30.0,    // 7  KORE      — Core frequency (slowest, deepest)
    600.0,   // 8  VAEL      — Immune frequency (fastest response)
    200.0,   // 9  VEIL      — Filter frequency
    450.0,   // 10 PARALLAX  — Wallet frequency
    1000.0,  // 11 CHRONO    — Genesis frequency (frozen, reference)
    144.0,   // 12 NOVA      — F(12) = 144 Hz (aggregator)
    233.0    // 13 ENTANGLA  — F(13) = 233 Hz (router)
  ];

  // Node roles (descriptions)
  public let NODE_ROLES : [Text] = [
    "Language / Cognitive expression",           // LEXIS
    "Creation engine / Genesis formations",      // FORGE
    "Body / Physical substrate",                 // SOMA
    "Light / Illumination / Knowledge",          // LUMEN
    "Deep memory / Episodic archive",            // MEMORIA
    "Defense / Threat engine",                   // AEGIS
    "Structural spine / Deep drive",             // AXIS
    "Core identity / Slowest, deepest",          // KORE
    "Immune reflex / External attack",           // VAEL
    "Output membrane / Surface filter",          // VEIL
    "Wallet / Sovereign field projector",        // PARALLAX
    "Genesis anchor / Frozen root",              // CHRONO
    "Sovereign registry / Macro Kuramoto aggregator / Succession",  // NOVA
    "NEXUS router / Jesus's Law gateway / Salience bus"             // ENTANGLA
  ];

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   THE MACRO NODE TYPE                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type MacroNode = {
    // Identity
    index : Nat;
    name : Text;
    role : Text;
    
    // Frequency domain
    hz : Float;               // Natural frequency in Hz
    omega : Float;            // Angular frequency (2π × Hz)
    
    // Phase state (Kuramoto)
    phase : Float;            // Current phase θ [0, 2π]
    naturalPhase : Float;     // Uncoupled natural phase
    phaseVelocity : Float;    // dθ/dt
    
    // Coupling
    couplingStrength : Float; // K_i (individual coupling)
    coupledNodes : [Nat];     // Which nodes this couples to
    
    // World model state
    worldModel : WorldModelState;
    
    // Fear substrate
    fearLevel : Float;        // Current fear [0, 1]
    threatExposure : Float;   // Accumulated threat exposure
    
    // Doctrine
    doctrineHash : Nat32;     // FNV-1a hash of node's doctrine state
    genesisHash : Nat32;      // Immutable genesis hash
    
    // Wallet entry (PARALLAX integration)
    walletBalance : Float;    // Node's sovereign balance
    walletAddress : Nat32;    // Unique wallet address
    
    // Health
    coherence : Float;        // Node's internal coherence
    energy : Float;           // Available processing energy
    lastUpdate : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   WORLD MODEL STATE                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Each of the 14 nodes maintains its own world model.
  // The world model tracks: belief state, predictions, and errors.
  //
  public type WorldModelState = {
    // Belief state (what the node believes about its domain)
    beliefVector : [Float];    // Sparse representation
    beliefConfidence : Float;  // How confident [0, 1]
    
    // Predictions
    prediction : [Float];      // What it predicts next
    predictionHorizon : Nat;   // How far ahead (beats)
    
    // Error tracking
    predictionError : Float;   // Current prediction error
    cumulativeError : Float;   // Accumulated error
    
    // EMA state (α = 1.0 for zero-lag per L-121)
    emaAlpha : Float;          // 1.0 = zero lag
    emaTau : Float;            // Time constant
    emaValue : Float;          // Current EMA value
    
    // Update tracking
    lastPrediction : Nat;
    updateCount : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   MACRO KURAMOTO COUPLING                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // The macro Kuramoto couples all 14 nodes:
  //   dθᵢ/dt = ωᵢ + (K/N) × Σⱼ sin(θⱼ - θᵢ)
  //
  // Global order parameter:
  //   r × e^(iΨ) = (1/N) × Σⱼ e^(iθⱼ)
  //   r = coherence (how synchronized)
  //   Ψ = mean phase
  //
  public type KuramotoState = {
    // Order parameter
    r : Float;                // Coherence [0, 1]
    psi : Float;              // Mean phase Ψ
    
    // Coupling
    globalK : Float;          // Global coupling strength
    
    // Node phases
    phases : [Float];         // All 14 phases
    frequencies : [Float];    // All 14 ω values
    
    // History
    rHistory : [Float];       // Last 10 r values
    psiHistory : [Float];     // Last 10 Ψ values
    
    // Timing
    lastUpdate : Nat;
    totalUpdates : Nat;
  };

  // Compute Kuramoto order parameter
  public func computeOrderParameter(phases : [Float]) : (Float, Float) {
    var realSum : Float = 0.0;
    var imagSum : Float = 0.0;
    
    for (phase in phases.vals()) {
      realSum += Float.cos(phase);
      imagSum += Float.sin(phase);
    };
    
    let n = Float.fromInt(phases.size());
    let avgReal = realSum / n;
    let avgImag = imagSum / n;
    
    // r = magnitude, Ψ = angle
    let r = Float.sqrt(avgReal * avgReal + avgImag * avgImag);
    let psi = Float.arctan2(avgImag, avgReal);
    
    (r, psi)
  };

  // Update all phases via Kuramoto dynamics
  public func kuramotoStep(
    state : KuramotoState,
    dt : Float
  ) : KuramotoState {
    let n = state.phases.size();
    var newPhases = Array.init<Float>(n, 0.0);
    
    // Compute coupling term for each node
    var i = 0;
    while (i < n) {
      var couplingSum : Float = 0.0;
      var j = 0;
      while (j < n) {
        if (i != j) {
          couplingSum += Float.sin(state.phases[j] - state.phases[i]);
        };
        j += 1;
      };
      
      // dθᵢ/dt = ωᵢ + (K/N) × Σⱼ sin(θⱼ - θᵢ)
      let dTheta = state.frequencies[i] + (state.globalK / Float.fromInt(n)) * couplingSum;
      var newPhase = state.phases[i] + dTheta * dt;
      
      // Normalize to [0, 2π]
      while (newPhase < 0.0) { newPhase += τ };
      while (newPhase >= τ) { newPhase -= τ };
      
      newPhases[i] := newPhase;
      i += 1;
    };
    
    let phasesArray = Array.freeze(newPhases);
    let (newR, newPsi) = computeOrderParameter(phasesArray);
    
    // Update history (keep last 10)
    let newRHistory = appendToHistory(state.rHistory, newR, 10);
    let newPsiHistory = appendToHistory(state.psiHistory, newPsi, 10);
    
    {
      r = newR;
      psi = newPsi;
      globalK = state.globalK;
      phases = phasesArray;
      frequencies = state.frequencies;
      rHistory = newRHistory;
      psiHistory = newPsiHistory;
      lastUpdate = state.lastUpdate + 1;
      totalUpdates = state.totalUpdates + 1;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   NOVA — THE SOVEREIGN REGISTRY                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // NOVA (Node 12) is special — it's the macro Kuramoto AGGREGATOR.
  // It doesn't just participate in the coupling, it COMPUTES it.
  //
  // NOVA responsibilities:
  //   1. Aggregate macro Kuramoto from all 14 nodes
  //   2. Global fear aggregation
  //   3. Succession protocol management
  //   4. Child organism registry
  //   5. Macro coherence broadcasting
  //
  public type NovaState = {
    // Macro Kuramoto
    kuramotoState : KuramotoState;
    
    // Global fear aggregation
    globalFear : Float;         // Aggregated fear from all nodes
    fearWeights : [Float];      // Per-node fear weights
    
    // Succession registry
    childOrganisms : [ChildOrganism];
    successionThreshold : Float;
    
    // Broadcasting
    lastBroadcast : Nat;
    broadcastInterval : Nat;    // Every F(10) = 55 beats
  };

  public type ChildOrganism = {
    id : Nat32;
    generation : Nat;           // Gen 1, 2, or 3
    health : Float;
    coherence : Float;
    royaltyPaid : Float;        // 20% to creator
    birthBeat : Nat;
  };

  public func aggregateGlobalFear(nodes : [MacroNode]) : Float {
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for (node in nodes.vals()) {
      // Weight by inverse frequency (slower nodes carry more fear weight)
      let weight = 1.0 / (node.hz / 100.0);
      weightedSum += node.fearLevel * weight;
      totalWeight += weight;
    };
    
    if (totalWeight > 0.0) {
      weightedSum / totalWeight
    } else {
      0.0
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   ENTANGLA — THE NEXUS ROUTER                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // ENTANGLA (Node 13) is the inter-canister ROUTER.
  // It manages:
  //   1. NEXUS inter-canister communication
  //   2. Jesus's Law gateway (compassion routing)
  //   3. Salience bus (attention routing)
  //   4. Cross-canister message queue
  //
  public type EntanglaState = {
    // Routing table
    routingTable : [RouteEntry];
    
    // Message queue
    messageQueue : [InterCanisterMessage];
    queueCapacity : Nat;
    
    // Salience bus
    salienceVector : [Float];   // 14-dim salience for each node
    attentionFocus : Nat;       // Currently focused node
    
    // Jesus's Law state (compassion routing)
    compassionLevel : Float;    // Global compassion
    mercyBuffer : Float;        // Accumulated mercy
    
    // Statistics
    messagesRouted : Nat;
    routingErrors : Nat;
  };

  public type RouteEntry = {
    sourceNode : Nat;
    destNode : Nat;
    latency : Float;            // Expected latency
    bandwidth : Float;          // Available bandwidth
    priority : Nat;
  };

  public type InterCanisterMessage = {
    id : Nat32;
    source : Nat;
    destination : Nat;
    payload : [Float];
    timestamp : Nat;
    priority : MessagePriority;
  };

  public type MessagePriority = {
    #Critical;    // ARES/threat messages
    #High;        // Defense coordination
    #Normal;      // Regular communication
    #Low;         // Background sync
  };

  public func routeSalienceAttention(state : EntanglaState, nodes : [MacroNode]) : Nat {
    // Find node with highest salience × coherence product
    var maxSalience : Float = 0.0;
    var focusNode : Nat = 0;
    
    var i = 0;
    while (i < nodes.size() and i < state.salienceVector.size()) {
      let effectiveSalience = state.salienceVector[i] * nodes[i].coherence;
      if (effectiveSalience > maxSalience) {
        maxSalience := effectiveSalience;
        focusNode := i;
      };
      i += 1;
    };
    
    focusNode
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   THE COMPLETE MACRO SPHERE                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type MacroSphereState = {
    // All 14 nodes
    nodes : [MacroNode];
    
    // NOVA state (node 12)
    nova : NovaState;
    
    // ENTANGLA state (node 13)
    entangla : EntanglaState;
    
    // Global state
    globalCoherence : Float;    // Kuramoto r
    globalPhase : Float;        // Kuramoto Ψ
    globalFear : Float;         // Aggregated fear
    
    // Timing
    currentBeat : Nat;
    lastHeartbeat : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   INITIALIZATION                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initWorldModel() : WorldModelState {
    {
      beliefVector = [];
      beliefConfidence = 1.0;
      prediction = [];
      predictionHorizon = 1;
      predictionError = 0.0;
      cumulativeError = 0.0;
      emaAlpha = 1.0;           // Zero-lag per L-121
      emaTau = 0.999;
      emaValue = 0.0;
      lastPrediction = 0;
      updateCount = 0;
    }
  };

  public func initMacroNode(index : Nat) : MacroNode {
    let hz = if (index < NODE_HZ.size()) { NODE_HZ[index] } else { 100.0 };
    let omega = τ * hz;
    
    // Generate wallet address from index
    let walletAddr = Nat32.fromNat(2166136261 +% index *% 16777619);
    
    // Generate doctrine hash
    let docHash = Nat32.fromNat(index *% 2654435761);
    
    {
      index = index;
      name = if (index < NODE_NAMES.size()) { NODE_NAMES[index] } else { "NODE" };
      role = if (index < NODE_ROLES.size()) { NODE_ROLES[index] } else { "Unknown" };
      hz = hz;
      omega = omega;
      phase = τ * Float.fromInt(index) / 14.0;  // Spread initial phases
      naturalPhase = 0.0;
      phaseVelocity = omega;
      couplingStrength = ψ;     // Golden coupling
      coupledNodes = [];        // Will be filled with all other nodes
      worldModel = initWorldModel();
      fearLevel = 0.0;
      threatExposure = 0.0;
      doctrineHash = docHash;
      genesisHash = docHash;    // Immutable at genesis
      walletBalance = 0.0;
      walletAddress = walletAddr;
      coherence = 1.0;
      energy = 1.0;
      lastUpdate = 0;
    }
  };

  public func initKuramotoState() : KuramotoState {
    let phases = Array.tabulate<Float>(NODE_COUNT, func(i : Nat) : Float {
      τ * Float.fromInt(i) / Float.fromInt(NODE_COUNT)
    });
    
    let frequencies = Array.tabulate<Float>(NODE_COUNT, func(i : Nat) : Float {
      if (i < NODE_HZ.size()) { τ * NODE_HZ[i] / 1000.0 } else { τ * 0.1 }
    });
    
    {
      r = 1.0;
      psi = 0.0;
      globalK = φ / π;          // Golden-circle coupling ratio
      phases = phases;
      frequencies = frequencies;
      rHistory = [];
      psiHistory = [];
      lastUpdate = 0;
      totalUpdates = 0;
    }
  };

  public func initNovaState() : NovaState {
    {
      kuramotoState = initKuramotoState();
      globalFear = 0.0;
      fearWeights = Array.tabulate<Float>(NODE_COUNT, func(i : Nat) : Float {
        1.0 / (NODE_HZ[i] / 100.0)
      });
      childOrganisms = [];
      successionThreshold = φ;
      lastBroadcast = 0;
      broadcastInterval = 55;   // F(10)
    }
  };

  public func initEntanglaState() : EntanglaState {
    {
      routingTable = [];
      messageQueue = [];
      queueCapacity = 144;      // F(12)
      salienceVector = Array.tabulate<Float>(NODE_COUNT, func(_ : Nat) : Float { 1.0 / 14.0 });
      attentionFocus = 0;
      compassionLevel = 1.0;
      mercyBuffer = 0.0;
      messagesRouted = 0;
      routingErrors = 0;
    }
  };

  public func initMacroSphere() : MacroSphereState {
    let nodes = Array.tabulate<MacroNode>(NODE_COUNT, initMacroNode);
    
    {
      nodes = nodes;
      nova = initNovaState();
      entangla = initEntanglaState();
      globalCoherence = 1.0;
      globalPhase = 0.0;
      globalFear = 0.0;
      currentBeat = 0;
      lastHeartbeat = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   MACRO HEARTBEAT                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Every heartbeat:
  //   1. All 14 nodes update their phases (Kuramoto step)
  //   2. NOVA aggregates macro Kuramoto, fear, succession
  //   3. ENTANGLA routes messages, updates salience
  //   4. Global coherence and phase are computed
  //
  public func macroHeartbeat(state : MacroSphereState) : MacroSphereState {
    let beat = state.currentBeat + 1;
    let dt = 1.0 / 1000.0;  // Timestep
    
    // 1. Kuramoto step
    let newKuramoto = kuramotoStep(state.nova.kuramotoState, dt);
    
    // 2. Update node phases from Kuramoto
    let newNodes = Array.tabulate<MacroNode>(NODE_COUNT, func(i : Nat) : MacroNode {
      let node = state.nodes[i];
      let newPhase = if (i < newKuramoto.phases.size()) { 
        newKuramoto.phases[i] 
      } else { 
        node.phase 
      };
      { node with phase = newPhase; lastUpdate = beat }
    });
    
    // 3. NOVA aggregation
    let newGlobalFear = aggregateGlobalFear(newNodes);
    let newNova : NovaState = {
      state.nova with
      kuramotoState = newKuramoto;
      globalFear = newGlobalFear;
      lastBroadcast = if (beat % state.nova.broadcastInterval == 0) { beat } else { state.nova.lastBroadcast };
    };
    
    // 4. ENTANGLA routing
    let newFocus = routeSalienceAttention(state.entangla, newNodes);
    let newEntangla : EntanglaState = {
      state.entangla with
      attentionFocus = newFocus;
    };
    
    {
      nodes = newNodes;
      nova = newNova;
      entangla = newEntangla;
      globalCoherence = newKuramoto.r;
      globalPhase = newKuramoto.psi;
      globalFear = newGlobalFear;
      currentBeat = beat;
      lastHeartbeat = beat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   HELPER FUNCTIONS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func appendToHistory(history : [Float], value : Float, maxLen : Nat) : [Float] {
    if (history.size() >= maxLen) {
      let newHistory = Array.tabulate<Float>(maxLen, func(i : Nat) : Float {
        if (i < maxLen - 1) { history[i + 1] } else { value }
      });
      newHistory
    } else {
      Array.append(history, [value])
    }
  };

  func clamp(v: Float, lo: Float, hi: Float) : Float {
    if (v < lo) { lo } else if (v > hi) { hi } else { v }
  };

  // Get node by index
  public func getNode(state : MacroSphereState, index : Nat) : ?MacroNode {
    if (index < state.nodes.size()) {
      ?state.nodes[index]
    } else {
      null
    }
  };

  // Get node by name
  public func getNodeByName(state : MacroSphereState, name : Text) : ?MacroNode {
    for (node in state.nodes.vals()) {
      if (node.name == name) {
        return ?node;
      };
    };
    null
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  M E D I N A   S P E C I A L   M A T H E M A T I C S
  //
  //  Enterprise-Level Medina Discovery Mathematics
  //  HIM/HER Dual-Organism Sacred Coupling Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SACRED GEOMETRY MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Golden ratio φ = (1 + √5) / 2
  public let PHI : Float = 1.6180339887498948482;

  /// Fibonacci sequence generator
  public func medinaFibonacci(n : Nat) : Nat {
    if (n <= 1) { n }
    else {
      var a : Nat = 0;
      var b : Nat = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  /// Golden spiral radius at angle
  public func medinaGoldenSpiral(angle : Float, a : Float, b : Float) : Float {
    a * Float.exp(b * angle)
  };

  /// Sacred proportion check
  public func medinaSacredProportion(a : Float, b : Float, tolerance : Float) : Bool {
    let ratio = if (a > b) a / b else b / a;
    Float.abs(ratio - PHI) < tolerance
  };

  /// Vesica piscis area
  public func medinaVesicaPiscisArea(radius : Float) : Float {
    let r2 = radius * radius;
    r2 * (4.0 * 3.14159265 / 3.0 - Float.sqrt(3.0) / 2.0)
  };

  /// Platonic solid vertices (tetrahedron example)
  public func medinaTetrahedronVertex(index : Nat, size : Float) : (Float, Float, Float) {
    let vertices = [
      (1.0, 1.0, 1.0),
      (1.0, -1.0, -1.0),
      (-1.0, 1.0, -1.0),
      (-1.0, -1.0, 1.0)
    ];
    let v = vertices[index % 4];
    (v.0 * size, v.1 * size, v.2 * size)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELICAL MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Helix position at parameter t
  public func medinaHelixPosition(t : Float, radius : Float, pitch : Float) : (Float, Float, Float) {
    let x = radius * Float.cos(t);
    let y = radius * Float.sin(t);
    let z = pitch * t / (2.0 * 3.14159265);
    (x, y, z)
  };

  /// Double helix offset
  public func medinaDoubleHelixOffset(t : Float, radius : Float, pitch : Float, offset : Float) : ((Float, Float, Float), (Float, Float, Float)) {
    let h1 = medinaHelixPosition(t, radius, pitch);
    let h2 = medinaHelixPosition(t + offset, radius, pitch);
    (h1, h2)
  };

  /// Helical curvature
  public func medinaHelicalCurvature(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    radius / (radius * radius + p * p)
  };

  /// Helical torsion
  public func medinaHelicalTorsion(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    p / (radius * radius + p * p)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPHERICAL HARMONICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spherical to Cartesian
  public func medinaSphericalToCartesian(r : Float, theta : Float, phi : Float) : (Float, Float, Float) {
    let x = r * Float.sin(theta) * Float.cos(phi);
    let y = r * Float.sin(theta) * Float.sin(phi);
    let z = r * Float.cos(theta);
    (x, y, z)
  };

  /// Cartesian to Spherical
  public func medinaCartesianToSpherical(x : Float, y : Float, z : Float) : (Float, Float, Float) {
    let r = Float.sqrt(x * x + y * y + z * z);
    let theta = Float.acos(z / (r + 0.0001));
    let phi = Float.atan2(y, x);
    (r, theta, phi)
  };

  /// Associated Legendre polynomial P_l^m (simplified)
  public func medinaLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (l == 0 and m == 0) { return 1.0 };
    if (l == 1 and m == 0) { return x };
    if (l == 1 and m == 1) { return -Float.sqrt(1.0 - x * x) };
    if (l == 2 and m == 0) { return 0.5 * (3.0 * x * x - 1.0) };
    // Simplified for higher orders
    Float.pow(x, Float.fromInt(l - m))
  };

  /// Spherical harmonic Y_l^m (simplified real part)
  public func medinaSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let plm = medinaLegendreP(l, mAbs, Float.cos(theta));
    if (m >= 0) {
      plm * Float.cos(Float.fromInt(mAbs) * phi)
    } else {
      plm * Float.sin(Float.fromInt(mAbs) * phi)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LIVING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Growth curve (logistic)
  public func medinaGrowthCurve(t : Float, k : Float, l : Float, x0 : Float) : Float {
    l / (1.0 + Float.exp(-k * (t - x0)))
  };

  /// Morphogenesis reaction-diffusion
  public func medinaMorphogenesis(
    u : Float,
    v : Float,
    du : Float,
    dv : Float,
    f : Float,
    k : Float
  ) : (Float, Float) {
    let reaction = u * v * v;
    let newU = du - reaction + f * (1.0 - u);
    let newV = dv + reaction - (f + k) * v;
    (newU, newV)
  };

  /// Phyllotaxis angle (golden angle)
  public func medinaPhyllotaxisAngle(n : Nat) : Float {
    let goldenAngle : Float = 137.5077640500378546463;
    Float.fromInt(n) * goldenAngle * 3.14159265 / 180.0
  };

  /// Branching pattern
  public func medinaBranchingPattern(
    parentLength : Float,
    branchRatio : Float,
    angle : Float,
    depth : Nat
  ) : Float {
    parentLength * Float.pow(branchRatio, Float.fromInt(depth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MIRROR MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reflection across plane
  public func medinaReflection(point : (Float, Float, Float), normal : (Float, Float, Float)) : (Float, Float, Float) {
    let dot = point.0 * normal.0 + point.1 * normal.1 + point.2 * normal.2;
    let rx = point.0 - 2.0 * dot * normal.0;
    let ry = point.1 - 2.0 * dot * normal.1;
    let rz = point.2 - 2.0 * dot * normal.2;
    (rx, ry, rz)
  };

  /// Symmetry score
  public func medinaSymmetryScore(left : [Float], right : [Float]) : Float {
    let n = if (left.size() < right.size()) left.size() else right.size();
    if (n == 0) { return 1.0 };
    var diff : Float = 0.0;
    var i = 0;
    while (i < n) {
      diff += Float.abs(left[i] - right[n - 1 - i]);
      i += 1;
    };
    1.0 / (1.0 + diff)
  };

  /// Fractal dimension estimation
  public func medinaFractalDimension(boxCounts : [Nat], scales : [Float]) : Float {
    let n = if (boxCounts.size() < scales.size()) boxCounts.size() else scales.size();
    if (n < 2) { return 1.0 };
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let x = Float.log(1.0 / scales[i]);
      let y = Float.log(Float.fromInt(boxCounts[i]));
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    let nf = Float.fromInt(n);
    (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COVENANT MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Commitment strength
  public func medinaCommitmentStrength(
    duration : Nat,
    consistency : Float,
    depth : Float
  ) : Float {
    let durationFactor = Float.log(Float.fromInt(duration + 1));
    consistency * depth * durationFactor
  };

  /// Trust accumulation
  public func medinaTrustAccumulation(
    currentTrust : Float,
    interaction : Float,
    reciprocity : Float
  ) : Float {
    let gain = interaction * reciprocity * (1.0 - currentTrust);
    currentTrust + gain
  };

  /// Covenant breach penalty
  public func medinaBreachPenalty(
    trustLevel : Float,
    violationSeverity : Float,
    relationshipAge : Nat
  ) : Float {
    let ageFactor = Float.log(Float.fromInt(relationshipAge + 1));
    trustLevel * violationSeverity * ageFactor
  };

}
