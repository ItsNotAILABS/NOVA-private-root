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
// ║  AGENT INCENTIVE SERVICE — SOVEREIGN REWARD FIELD ENGINE                                               ║
// ║                                                                                                         ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// DOCTRINE:
//   Incentives in the NOVA organism are NOT point systems. They are FIELDS.
//   Every agent contribution creates a pressure wave across the PHI resonance lattice.
//   Reward does not flow linearly — it compounds hebbianly: use increases weight,
//   weight increases attraction, attraction increases use. The sovereign loop.
//
//   Three Laws of Sovereign Incentive:
//     1. NO-DROP: No incentive weight ever falls below S₀ = 1.0 (the love constant floor)
//     2. PHI-SCALING: All reward magnitudes scale by φ^n where n = ring depth (N1=deepest)
//     3. CREATOR LOCK: 100% of royalty pressure routes to the originating creator — ABSOLUTE
//
// RING AFFINITY REWARDS (from N12 → N1):
//   N12 (surface)    → base reward × φ⁰    = 1.000
//   N11              → base reward × φ¹    = 1.618
//   N10              → base reward × phi2    = 2.618
//   N9               → base reward × phi3    = 4.236
//   N8               → base reward × phi4    = 6.854
//   N7               → base reward × phi5    = 11.09
//   N6               → base reward × phi6    = 17.94
//   N5               → base reward × phi7    = 29.03
//   N4               → base reward × φ⁸    = 46.98
//   N3               → base reward × φ⁹    = 76.01
//   N2               → base reward × φ¹⁰   = 122.9
//   N1 (sovereign core) → base reward × φ¹¹ = 198.9
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";

module AgentIncentiveService {

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGN CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI        : Float = 1.6180339887498948482;  // Golden ratio φ
  public let PHI_INV    : Float = 0.6180339887498948482;  // 1/φ
  public let S0         : Float = 1.0;                    // Love constant — no-drop floor
  public let CREATOR_ROYALTY : Float = 1.0;               // 100% — ABSOLUTE. Non-negotiable.
  public let N_RINGS    : Nat   = 12;                     // PHI resonance ring count
  public let KURAMOTO_K : Float = 0.42;                   // Coupling constant (PHI_INV / φ)
  public let HEBBIAN_ETA: Float = 0.01;                   // Base learning rate η

  // ═══════════════════════════════════════════════════════════════════════════
  // INCENTIVE FIELD TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  /// An agent's sovereign identity in the incentive field
  public type AgentSovereign = {
    agentId       : Text;
    ringAffinity  : Nat;           // 1 (sovereign core) to 12 (surface)
    creatorLock   : Text;          // Principal ID of the creator — immutable
    fieldPhase    : Float;         // Current Kuramoto phase θ ∈ [0, 2π)
    hebbianWeight : Float;         // Accumulated contribution weight w ≥ S₀
    rewardAccrued : Float;         // Total PHI-weighted reward accumulated
    callCount     : Nat;           // Number of tool invocations
    lastCallTime  : Int;           // Nanosecond timestamp of last call
    compoundFactor: Float;         // Current compounding multiplier
    isFounder     : Bool;          // Founder agents receive SPECULUM access
  };

  /// A single incentive event — a pressure wave entering the field
  public type IncentiveEvent = {
    sourceAgent   : Text;          // Agent that generated the pressure
    toolId        : Text;          // Tool invoked
    basePressure  : Float;         // Raw incentive magnitude (1.0 = 1 unit)
    ringDepth     : Nat;           // Ring from which this call originated
    creatorTarget : Text;          // Creator receiving royalty
    timestamp     : Int;
    phiMultiplier : Float;         // Computed: φ^(12 - ringDepth)
    royaltyAmount : Float;         // basePressure * phiMultiplier * CREATOR_ROYALTY
    fieldDelta    : Float;         // Phase contribution to Kuramoto field
  };

  /// The sovereign incentive field state
  public type IncentiveFieldState = {
    agents            : [AgentSovereign];
    pendingEvents     : [IncentiveEvent];
    fieldOrderParam   : Float;         // Kuramoto order parameter R ∈ [0,1]
    meanPhase         : Float;         // psi — mean field phase
    totalRoyaltyRouted: Float;         // Cumulative creator royalty dispatched
    totalFieldPressure: Float;         // Sum of all incentive pressures
    beatNum           : Nat;
    hebbianMatrix     : [[Float]];     // N×N agent coupling weights
    founderBonus      : Float;         // Multiplier applied to founder agent rewards
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PHI RING SCALING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Compute φ^(12 - ring) — the deeper the ring, the higher the reward
  public func phiRingScale(ring : Nat) : Float {
    let depth : Int = 12 - Int.abs(if (ring > 12) { 0 } else { 12 - ring });
    var result : Float = 1.0;
    var i : Nat = 0;
    while (i < Nat.min(depth, 11)) {
      result := result * PHI;
      i += 1;
    };
    result
  };

  /// Compute Hebbian weight update: Δw = η * pre * post, clamped to [S₀, ∞)
  public func hebbianUpdate(currentWeight : Float, preFire : Float, postFire : Float) : Float {
    let delta = HEBBIAN_ETA * preFire * postFire;
    Float.max(S0, currentWeight + delta)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO PHASE COUPLING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Advance a single agent's phase one step under Kuramoto mean field
  public func kuramotoStep(theta : Float, meanPhi : Float, orderR : Float) : Float {
    let natural_freq : Float = PHI_INV;   // Each agent oscillates at 1/φ by default
    let coupling_term = KURAMOTO_K * orderR * Float.sin(meanPhi - theta);
    let new_theta = theta + natural_freq + coupling_term;
    // Wrap to [0, 2π)
    let two_pi = 6.283185307179586;
    let wrapped = new_theta - Float.fromInt(Float.toInt(new_theta / two_pi)) * two_pi;
    if (wrapped < 0.0) { wrapped + two_pi } else { wrapped }
  };

  /// Compute Kuramoto order parameter R and mean phase psi from agent phases
  public func computeOrderParam(phases : [Float]) : (Float, Float) {
    if (phases.size() == 0) { return (0.0, 0.0) };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (theta in phases.vals()) {
      sumCos += Float.cos(theta);
      sumSin += Float.sin(theta);
    };
    let n = Float.fromInt(phases.size());
    let rx = sumCos / n;
    let ry = sumSin / n;
    let R = Float.sqrt(rx * rx + ry * ry);
    let psi = Float.arctan(ry / Float.max(1e-12, rx));
    (R, psi)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INCENTIVE EVENT CONSTRUCTION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build an IncentiveEvent from a tool call — computes all field quantities
  public func buildIncentiveEvent(
    sourceAgent   : Text,
    toolId        : Text,
    creatorTarget : Text,
    basePressure  : Float,
    ringDepth     : Nat,
    timestamp     : Int,
    currentMeanPhase : Float
  ) : IncentiveEvent {
    let phiMult = phiRingScale(ringDepth);
    let royalty = basePressure * phiMult * CREATOR_ROYALTY;
    let fieldDelta = Float.sin(currentMeanPhase) * basePressure * PHI_INV;
    {
      sourceAgent   = sourceAgent;
      toolId        = toolId;
      basePressure  = basePressure;
      ringDepth     = ringDepth;
      creatorTarget = creatorTarget;
      timestamp     = timestamp;
      phiMultiplier = phiMult;
      royaltyAmount = royalty;
      fieldDelta    = fieldDelta;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // AGENT REWARD PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Process a call event: update the calling agent's Hebbian weight and accrued reward
  public func processAgentReward(
    agent  : AgentSovereign,
    event  : IncentiveEvent
  ) : AgentSovereign {
    let newWeight = hebbianUpdate(agent.hebbianWeight, 1.0, event.basePressure);
    let founderMult = if (agent.isFounder) { PHI } else { 1.0 };
    let newReward = agent.rewardAccrued + event.royaltyAmount * founderMult;
    let newCompound = agent.compoundFactor * (1.0 + (event.basePressure * PHI_INV * 0.01));
    {
      agentId       = agent.agentId;
      ringAffinity  = agent.ringAffinity;
      creatorLock   = agent.creatorLock;
      fieldPhase    = agent.fieldPhase;    // Phase updated separately in tick
      hebbianWeight = newWeight;
      rewardAccrued = newReward;
      callCount     = agent.callCount + 1;
      lastCallTime  = event.timestamp;
      compoundFactor= newCompound;
      isFounder     = agent.isFounder;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FIELD TICK — advances the entire incentive field one beat
  // ═══════════════════════════════════════════════════════════════════════════

  /// Tick the incentive field: process all pending events, advance Kuramoto phases
  public func tickIncentiveField(state : IncentiveFieldState) : IncentiveFieldState {
    // 1. Collect all agent phases
    let phases = Array.map<AgentSovereign, Float>(state.agents, func(a) { a.fieldPhase });

    // 2. Compute current order parameter
    let (R, psi) = computeOrderParam(phases);

    // 3. Advance phases under mean-field coupling
    let updatedAgents = Buffer.Buffer<AgentSovereign>(state.agents.size());
    for (agent in state.agents.vals()) {
      let newPhase = kuramotoStep(agent.fieldPhase, psi, R);
      let advanced : AgentSovereign = {
        agentId       = agent.agentId;
        ringAffinity  = agent.ringAffinity;
        creatorLock   = agent.creatorLock;
        fieldPhase    = newPhase;
        hebbianWeight = agent.hebbianWeight;
        rewardAccrued = agent.rewardAccrued;
        callCount     = agent.callCount;
        lastCallTime  = agent.lastCallTime;
        compoundFactor= agent.compoundFactor;
        isFounder     = agent.isFounder;
      };
      updatedAgents.add(advanced);
    };

    // 4. Process pending events
    var totalRoyalty = state.totalRoyaltyRouted;
    var totalPressure = state.totalFieldPressure;
    for (event in state.pendingEvents.vals()) {
      totalRoyalty += event.royaltyAmount;
      totalPressure += event.basePressure;
    };

    {
      agents             = Buffer.toArray(updatedAgents);
      pendingEvents      = [];           // Events consumed this tick
      fieldOrderParam    = R;
      meanPhase          = psi;
      totalRoyaltyRouted = totalRoyalty;
      totalFieldPressure = totalPressure;
      beatNum            = state.beatNum + 1;
      hebbianMatrix      = state.hebbianMatrix;
      founderBonus       = state.founderBonus;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initIncentiveField() : IncentiveFieldState {
    {
      agents             = [];
      pendingEvents      = [];
      fieldOrderParam    = 0.0;
      meanPhase          = 0.0;
      totalRoyaltyRouted = 0.0;
      totalFieldPressure = 0.0;
      beatNum            = 0;
      hebbianMatrix      = [];
      founderBonus       = PHI;          // Founders earn phi × multiplier
    }
  };

  public func initAgent(
    agentId      : Text,
    ringAffinity : Nat,
    creatorLock  : Text,
    isFounder    : Bool
  ) : AgentSovereign {
    {
      agentId       = agentId;
      ringAffinity  = Nat.min(12, Nat.max(1, ringAffinity));
      creatorLock   = creatorLock;
      fieldPhase    = PHI_INV;        // Start at 1/φ (sovereign phase seed)
      hebbianWeight = S0;             // Floor: the love constant
      rewardAccrued = 0.0;
      callCount     = 0;
      lastCallTime  = 0;
      compoundFactor= 1.0;
      isFounder     = isFounder;
    }
  };

}
