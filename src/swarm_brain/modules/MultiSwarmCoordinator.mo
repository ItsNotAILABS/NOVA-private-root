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
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ════════════════════════════════════════════════════════════════════════════════════════
// ███╗   ███╗██╗   ██╗██╗  ████████╗██╗    ███████╗██╗    ██╗ █████╗ ██████╗ ███╗   ███╗
// ████╗ ████║██║   ██║██║  ╚══██╔══╝██║    ██╔════╝██║    ██║██╔══██╗██╔══██╗████╗ ████║
// ██╔████╔██║██║   ██║██║     ██║   ██║    ███████╗██║ █╗ ██║███████║██████╔╝██╔████╔██║
// ██║╚██╔╝██║██║   ██║██║     ██║   ██║    ╚════██║██║███╗██║██╔══██║██╔══██╗██║╚██╔╝██║
// ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║    ███████║╚███╔███╔╝██║  ██║██║  ██║██║ ╚═╝ ██║
// ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝    ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
// ════════════════════════════════════════════════════════════════════════════════════════
//
// MULTI-SWARM COORDINATOR — L3 GOVERNANCE & EVOLUTION LAYER
// Canister for Swarm-to-Swarm Communication (Stage 6 Evolution)
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// When a single swarm achieves OMNIS state (r ≥ 0.98), it becomes capable of
// coordinating with OTHER swarms. This is Stage 6: the Sovereign Network.
//
// MULTI-SWARM ARCHITECTURE:
//
//   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
//   │   SWARM A    │     │   SWARM B    │     │   SWARM C    │
//   │  (OMNIS)     │◄───►│  (OMNIS)     │◄───►│  (OMNIS)     │
//   └──────────────┘     └──────────────┘     └──────────────┘
//          │                    │                    │
//          └────────────────────┼────────────────────┘
//                               │
//                    ┌──────────▼──────────┐
//                    │   MULTI-SWARM       │
//                    │   COORDINATOR       │
//                    │   (This Module)     │
//                    └─────────────────────┘
//                               │
//                    ┌──────────▼──────────┐
//                    │   DAO GOVERNANCE    │
//                    │   FORMA Treasury    │
//                    └─────────────────────┘
//
// CAPABILITIES:
//   1. Swarm Registration & Discovery
//   2. Inter-Swarm Messaging (coherence-authenticated)
//   3. Collective Missions (multi-swarm operations)
//   4. Shared Resource Pools (FORMA treasury)
//   5. DAO Governance (cross-swarm voting)
//   6. Evolution Tracking (network-level emergence)
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float     "mo:base/Float";
import Nat       "mo:base/Nat";
import Int       "mo:base/Int";
import Text      "mo:base/Text";
import Array     "mo:base/Array";
import Principal "mo:base/Principal";
import Time      "mo:base/Time";

module {

  // ══════════════════════════════════════════════════════════════════════════════════════
  // MULTI-SWARM CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════════════════

  // OMNIS threshold for network participation
  public let OMNIS_THRESHOLD : Float = 0.98;

  // Maximum swarms in network (scalable)
  public let MAX_SWARMS : Nat = 100;

  // Coherence requirement for inter-swarm communication
  public let COMMS_COHERENCE_MIN : Float = 0.85;

  // Governance quorum (percentage of registered swarms)
  public let GOVERNANCE_QUORUM : Float = 0.51;

  // ══════════════════════════════════════════════════════════════════════════════════════
  // SWARM IDENTITY & REGISTRATION
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type SwarmIdentity = {
    id              : Nat;
    name            : Text;
    canisterId      : Principal;
    registrationBeat: Nat;
    droneCount      : Nat;
    currentRSwarm   : Float;
    isOMNIS         : Bool;
    lastHeartbeat   : Int;  // Timestamp
    reputation      : Float;  // 0-1 based on mission success
    totalMissions   : Nat;
    formaBalance    : Nat;
  };

  public type SwarmStatus = {
    #ACTIVE;
    #DORMANT;        // No heartbeat for extended period
    #DEGRADED;       // r < OMNIS but still responsive
    #DISCONNECTED;   // No heartbeat, presumed offline
    #SANCTIONED;     // Governance action against swarm
  };

  public type RegistrationRequest = {
    name        : Text;
    canisterId  : Principal;
    droneCount  : Nat;
    initialR    : Float;
    proofOfWork : Text;  // Hash proving computational effort
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // INTER-SWARM COMMUNICATION
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type SwarmMessage = {
    messageId   : Nat;
    fromSwarm   : Nat;
    toSwarm     : ?Nat;  // None = broadcast to all
    timestamp   : Int;
    messageType : MessageType;
    payload     : Text;  // JSON encoded
    coherenceProof: Float;  // Sender's rSwarm at time of send
    signature   : Text;  // Cryptographic signature
  };

  public type MessageType = {
    #HEARTBEAT;
    #MISSION_PROPOSAL;
    #MISSION_ACCEPT;
    #MISSION_REJECT;
    #RESOURCE_REQUEST;
    #RESOURCE_OFFER;
    #GOVERNANCE_VOTE;
    #EMERGENCY_ALERT;
    #COHERENCE_REPORT;
    #FORMA_TRANSFER;
  };

  public type MessageQueue = {
    pending     : [SwarmMessage];
    processed   : Nat;
    dropped     : Nat;  // Messages dropped due to low coherence
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // COLLECTIVE MISSIONS
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type CollectiveMission = {
    missionId       : Nat;
    title           : Text;
    description     : Text;
    proposerSwarm   : Nat;
    participantSwarms: [Nat];
    requiredSwarms  : Nat;
    missionType     : CollectiveMissionType;
    status          : MissionStatus;
    startBeat       : ?Nat;
    endBeat         : ?Nat;
    totalFORMACost  : Nat;
    formaPerSwarm   : Nat;
    reward          : Nat;
    objectiveData   : Text;  // JSON encoded mission parameters
  };

  public type CollectiveMissionType = {
    #SURVEY;           // Large area coverage
    #SEARCH_RESCUE;    // Emergency response
    #PERIMETER;        // Multi-zone security
    #LOGISTICS;        // Coordinated delivery
    #FORMATION_DISPLAY;// Synchronized aerial display
    #DEFENSE;          // Collective defense operation
  };

  public type MissionStatus = {
    #PROPOSED;
    #RECRUITING;     // Gathering participant swarms
    #ACTIVE;
    #COMPLETED;
    #FAILED;
    #CANCELLED;
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // DAO GOVERNANCE
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type DAOProposal = {
    proposalId      : Nat;
    proposerSwarm   : Nat;
    title           : Text;
    description     : Text;
    category        : DAOCategory;
    votesFor        : Nat;  // Weighted by swarm reputation
    votesAgainst    : Nat;
    abstentions     : Nat;
    quorumRequired  : Nat;
    deadline        : Int;  // Timestamp
    status          : ProposalStatus;
    executionData   : Text;  // What happens if passed
  };

  public type DAOCategory = {
    #PARAMETER_CHANGE;   // Change network parameters
    #TREASURY_SPEND;     // Allocate shared FORMA
    #SWARM_SANCTION;     // Punish misbehaving swarm
    #SWARM_REWARD;       // Reward excellent swarm
    #PROTOCOL_UPGRADE;   // Upgrade coordinator logic
    #EMERGENCY_ACTION;   // Time-sensitive decision
  };

  public type ProposalStatus = {
    #VOTING;
    #PASSED;
    #REJECTED;
    #EXECUTED;
    #VETOED;
  };

  public type Vote = {
    voterSwarm  : Nat;
    proposalId  : Nat;
    voteType    : VoteType;
    weight      : Nat;  // Based on reputation + FORMA stake
    timestamp   : Int;
  };

  public type VoteType = {
    #FOR;
    #AGAINST;
    #ABSTAIN;
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // NETWORK STATE
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type NetworkState = {
    totalSwarms         : Nat;
    activeSwarms        : Nat;
    omnisSwarms         : Nat;  // Swarms currently in OMNIS
    networkCoherence    : Float;  // Average coherence across network
    totalDrones         : Nat;
    totalFORMASupply    : Nat;
    treasuryBalance     : Nat;
    activeMissions      : Nat;
    totalMissionsCompleted: Nat;
    activeProposals     : Nat;
    lastNetworkBeat     : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // NETWORK COHERENCE — INTER-SWARM SYNCHRONIZATION
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // Just as drones synchronize within a swarm (Kuramoto), swarms can synchronize
  // across the network. Network coherence measures this meta-level synchrony.
  //
  // NETWORK ORDER PARAMETER:
  //   R_network = |Σ rᵢ × e^(iψᵢ)| / N
  //
  // where rᵢ is swarm i's internal coherence and ψᵢ is its "phase" (mission alignment)
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type NetworkCoherence = {
    orderParameter  : Float;  // R_network
    meanPhase       : Float;  // Network-level phase
    variance        : Float;  // Spread of swarm coherences
    isNetworkOMNIS  : Bool;   // R_network ≥ 0.95
  };

  public func computeNetworkCoherence(swarms: [SwarmIdentity]) : NetworkCoherence {
    let n = swarms.size();
    if (n == 0) {
      return {
        orderParameter = 0.0;
        meanPhase = 0.0;
        variance = 1.0;
        isNetworkOMNIS = false;
      }
    };

    // Compute weighted sum
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var sumR : Float = 0.0;
    var phase : Float = 0.0;

    for (i in Array.keys(swarms)) {
      let swarm = swarms[i];
      let r = swarm.currentRSwarm;
      // Use reputation as phase offset (aligned reputations = aligned phases)
      let psi = swarm.reputation * 6.28318;  // Map reputation to [0, 2π]

      sumCos += r * Float.cos(psi);
      sumSin += r * Float.sin(psi);
      sumR += r;
    };

    let nf = Float.fromInt(n);
    let R = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    let meanPhase = Float.arctan2(sumSin, sumCos);

    // Compute variance
    let meanR = sumR / nf;
    var variance : Float = 0.0;
    for (swarm in swarms.vals()) {
      let diff = swarm.currentRSwarm - meanR;
      variance += diff * diff;
    };
    variance /= nf;

    {
      orderParameter = R;
      meanPhase = meanPhase;
      variance = variance;
      isNetworkOMNIS = R >= 0.95;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // EVOLUTION TRACKING — NETWORK-LEVEL EMERGENCE
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type EvolutionStage = {
    #STAGE_1_SINGLE_DRONE;
    #STAGE_2_DRONE_PAIR;
    #STAGE_3_SMALL_SWARM;      // 3-10 drones
    #STAGE_4_SWARM_INTELLIGENCE; // 10-30 drones, r > 0.7
    #STAGE_5_OMNIS_STATE;      // r ≥ 0.98
    #STAGE_6_SOVEREIGN_NETWORK;// Multiple OMNIS swarms
    #STAGE_7_PLANETARY_MESH;   // Global network (future)
  };

  public type NetworkEvolution = {
    currentStage    : EvolutionStage;
    stageProgress   : Float;  // 0-1 progress toward next stage
    totalDrones     : Nat;
    omnisSwarmCount : Nat;
    networkR        : Float;
    milestonesReached: [Text];
    nextMilestone   : Text;
  };

  public func assessNetworkEvolution(state: NetworkState, coherence: NetworkCoherence) : NetworkEvolution {
    // Determine current stage
    let stage : EvolutionStage = 
      if (coherence.isNetworkOMNIS and state.omnisSwarms >= 3) { #STAGE_6_SOVEREIGN_NETWORK }
      else if (state.omnisSwarms >= 1) { #STAGE_5_OMNIS_STATE }
      else if (state.totalDrones >= 10 and coherence.orderParameter > 0.7) { #STAGE_4_SWARM_INTELLIGENCE }
      else if (state.totalDrones >= 3) { #STAGE_3_SMALL_SWARM }
      else if (state.totalDrones >= 2) { #STAGE_2_DRONE_PAIR }
      else { #STAGE_1_SINGLE_DRONE };

    // Calculate progress toward next stage
    let progress : Float = switch (stage) {
      case (#STAGE_1_SINGLE_DRONE) { Float.fromInt(state.totalDrones) / 2.0 };
      case (#STAGE_2_DRONE_PAIR) { Float.fromInt(state.totalDrones) / 3.0 };
      case (#STAGE_3_SMALL_SWARM) { coherence.orderParameter / 0.7 };
      case (#STAGE_4_SWARM_INTELLIGENCE) { coherence.orderParameter / 0.98 };
      case (#STAGE_5_OMNIS_STATE) { Float.fromInt(state.omnisSwarms) / 3.0 };
      case (#STAGE_6_SOVEREIGN_NETWORK) { coherence.orderParameter / 0.95 };
      case (#STAGE_7_PLANETARY_MESH) { 1.0 };  // Already at max
    };

    // Milestones
    var milestones : [Text] = [];
    if (state.totalDrones >= 1) { milestones := Array.append(milestones, ["First drone online"]) };
    if (state.totalDrones >= 10) { milestones := Array.append(milestones, ["Swarm threshold reached"]) };
    if (state.omnisSwarms >= 1) { milestones := Array.append(milestones, ["First OMNIS achieved"]) };
    if (state.totalMissionsCompleted >= 1) { milestones := Array.append(milestones, ["First mission completed"]) };
    if (coherence.isNetworkOMNIS) { milestones := Array.append(milestones, ["Network OMNIS achieved"]) };

    let nextMilestone = switch (stage) {
      case (#STAGE_1_SINGLE_DRONE) { "Add second drone" };
      case (#STAGE_2_DRONE_PAIR) { "Expand to 3+ drones" };
      case (#STAGE_3_SMALL_SWARM) { "Achieve r > 0.7 coherence" };
      case (#STAGE_4_SWARM_INTELLIGENCE) { "Achieve OMNIS (r ≥ 0.98)" };
      case (#STAGE_5_OMNIS_STATE) { "Connect 3+ OMNIS swarms" };
      case (#STAGE_6_SOVEREIGN_NETWORK) { "Achieve network-level OMNIS" };
      case (#STAGE_7_PLANETARY_MESH) { "Expand to global coverage" };
    };

    {
      currentStage = stage;
      stageProgress = if (progress > 1.0) { 1.0 } else { progress };
      totalDrones = state.totalDrones;
      omnisSwarmCount = state.omnisSwarms;
      networkR = coherence.orderParameter;
      milestonesReached = milestones;
      nextMilestone = nextMilestone;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // HELPER: Reputation calculation
  // ══════════════════════════════════════════════════════════════════════════════════════

  public func calculateReputation(
    missionsCompleted: Nat,
    missionsFailed: Nat,
    coherenceHistory: [Float],
    sanctionCount: Nat
  ) : Float {
    // Base from mission success rate
    let totalMissions = missionsCompleted + missionsFailed;
    let successRate = if (totalMissions > 0) {
      Float.fromInt(missionsCompleted) / Float.fromInt(totalMissions)
    } else { 0.5 };

    // Average coherence bonus
    var avgCoherence : Float = 0.0;
    if (coherenceHistory.size() > 0) {
      for (c in coherenceHistory.vals()) { avgCoherence += c };
      avgCoherence /= Float.fromInt(coherenceHistory.size());
    };

    // Sanction penalty
    let sanctionPenalty = Float.fromInt(sanctionCount) * 0.1;

    let reputation = successRate * 0.5 + avgCoherence * 0.5 - sanctionPenalty;

    // Clamp to [0, 1]
    if (reputation < 0.0) { 0.0 }
    else if (reputation > 1.0) { 1.0 }
    else { reputation }
  };

}
