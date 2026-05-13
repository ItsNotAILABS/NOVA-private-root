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
// ║  INCENTIVE SERVICE — SOVEREIGN CONTRIBUTION PRESSURE ENGINE                                            ║
// ║                                                                                                         ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// DOCTRINE:
//   This is not a "rewards program". It is a pressure field.
//   Every contribution — code, data, invocation, verification — generates a pressure vector
//   in the sovereign field. Pressure compounds. Pressure resonates. Pressure never drops
//   below the love constant floor S₀ = 1.0.
//
//   The IncentiveService is the general-purpose pressure manager.
//   AgentIncentiveService handles agent-specific field dynamics.
//   This module manages the broader contributor ecosystem:
//     - Human contributors
//     - Organization nodes
//     - Ecosystem participants
//     - Cross-canister contribution routing
//
// CONTRIBUTION PRIMITIVES (maps to UniversalTokenGenesisEngine primitives):
//   1. BUILD_CONTRIBUTION     → REWARD token (behavioral consequence)
//   2. CALL_CONTRIBUTION      → PRESSURE token (exchange potential)
//   3. GOVERN_CONTRIBUTION    → GOVERNANCE token (decision authority)
//   4. VERIFY_CONTRIBUTION    → PROOF token (verification receipt)
//   5. MEMORY_CONTRIBUTION    → MEMORY token (persistent record)
//   6. GATE_CONTRIBUTION      → GATE token (access provision)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";

module IncentiveService {

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGN CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI             : Float = 1.6180339887498948482;
  public let PHI_INV         : Float = 0.6180339887498948482;
  public let S0              : Float = 1.0;
  public let CREATOR_ROYALTY : Float = 1.0;
  public let MAX_CONTRIBUTORS: Nat   = 1000;

  // Contribution type magnitudes (base pressure units)
  public let BUILD_MAGNITUDE  : Float = PHI * PHI;         // phi2 ≈ 2.618
  public let CALL_MAGNITUDE   : Float = PHI;               // phi ≈ 1.618
  public let GOVERN_MAGNITUDE : Float = PHI * PHI * PHI;  // phi3 ≈ 4.236
  public let VERIFY_MAGNITUDE : Float = PHI * PHI;         // phi2 ≈ 2.618
  public let MEMORY_MAGNITUDE : Float = PHI;               // phi ≈ 1.618
  public let GATE_MAGNITUDE   : Float = PHI_INV;           // 1/φ ≈ 0.618

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTRIBUTION TYPE
  // ═══════════════════════════════════════════════════════════════════════════

  public type ContributionKind = {
    #Build;     // Created a tool, module, or capability
    #Call;      // Invoked a tool successfully
    #Govern;    // Participated in governance decision
    #Verify;    // Validated correctness of output
    #Memory;    // Stored retrievable knowledge
    #Gate;      // Provided access or unlocked capability
  };

  /// A single contribution record — immutable once created
  public type ContributionRecord = {
    contributorId : Text;          // Contributor principal / identifier
    kind          : ContributionKind;
    toolId        : Text;          // Tool this contribution is associated with
    creatorId     : Text;          // Creator of the tool (royalty recipient)
    magnitude     : Float;         // Raw pressure generated
    phiWeight     : Float;         // PHI-scaled final weight
    royaltyRouted : Float;         // Amount routed to creator
    timestamp     : Int;
    sessionId     : Nat32;         // Which session/epoch this belongs to
    verified      : Bool;          // Has been verified by oracle or consensus
  };

  /// A contributor's running account in the incentive field
  public type ContributorAccount = {
    contributorId     : Text;
    isCreator         : Bool;       // If true, receives royalties from own tools
    totalPressure     : Float;      // Cumulative pressure generated (≥ S₀)
    totalRoyaltyEarned: Float;      // Total royalties received
    buildCount        : Nat;
    callCount         : Nat;
    governCount       : Nat;
    verifyCount       : Nat;
    memoryCount       : Nat;
    gateCount         : Nat;
    firstContribAt    : Int;
    lastContribAt     : Int;
    compoundMultiplier: Float;      // Increases as contributor stays active
    sovereignTier     : SovereignTier;
  };

  /// Tiered recognition based on cumulative pressure (not arbitrary rank)
  public type SovereignTier = {
    #Seed;          // 0 < pressure < φ
    #Root;          // phi ≤ pressure < φ²
    #Trunk;         // phi2 ≤ pressure < φ³
    #Branch;        // phi3 ≤ pressure < φ⁴
    #Canopy;        // phi4 ≤ pressure < φ⁵
    #Crown;         // phi5 ≤ pressure < φ⁶
    #Sovereign;     // pressure ≥ φ⁶
  };

  /// Full incentive service state
  public type IncentiveServiceState = {
    contributors      : [ContributorAccount];
    records           : [ContributionRecord];   // Last 10,000 records (ring buffer)
    totalPressure     : Float;                  // Global field pressure
    totalRoyaltyPaid  : Float;                  // Total creator royalties disbursed
    sessionId         : Nat32;
    phiCoherence      : Float;                  // Ratio of verified to total contributions
    beatNum           : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAGNITUDE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get the base pressure magnitude for a contribution kind
  public func magnitudeOf(kind : ContributionKind) : Float {
    switch (kind) {
      case (#Build)   { BUILD_MAGNITUDE  };
      case (#Call)    { CALL_MAGNITUDE   };
      case (#Govern)  { GOVERN_MAGNITUDE };
      case (#Verify)  { VERIFY_MAGNITUDE };
      case (#Memory)  { MEMORY_MAGNITUDE };
      case (#Gate)    { GATE_MAGNITUDE   };
    }
  };

  /// Compute the PHI-weighted final pressure for a contribution
  /// phiWeight = magnitude * compoundMultiplier * (1.0 if unverified, PHI if verified)
  public func computePhiWeight(
    kind            : ContributionKind,
    compoundMult    : Float,
    verified        : Bool
  ) : Float {
    let base = magnitudeOf(kind);
    let verifyBonus = if (verified) { PHI } else { 1.0 };
    Float.max(S0, base * compoundMult * verifyBonus)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGN TIER CLASSIFICATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func classifyTier(pressure : Float) : SovereignTier {
    let p6 = PHI * PHI * PHI * PHI * PHI * PHI;
    let p5 = PHI * PHI * PHI * PHI * PHI;
    let p4 = PHI * PHI * PHI * PHI;
    let p3 = PHI * PHI * PHI;
    let p2 = PHI * PHI;
    if      (pressure >= p6) { #Sovereign }
    else if (pressure >= p5) { #Crown     }
    else if (pressure >= p4) { #Canopy    }
    else if (pressure >= p3) { #Branch    }
    else if (pressure >= p2) { #Trunk     }
    else if (pressure >= PHI){ #Root      }
    else                     { #Seed      }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTRIBUTION REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create a new contribution record and updated contributor account
  public func registerContribution(
    account       : ContributorAccount,
    kind          : ContributionKind,
    toolId        : Text,
    creatorId     : Text,
    verified      : Bool,
    timestamp     : Int,
    sessionId     : Nat32
  ) : (ContributorAccount, ContributionRecord) {
    let phiWeight = computePhiWeight(kind, account.compoundMultiplier, verified);
    let royalty   = phiWeight * CREATOR_ROYALTY;

    let record : ContributionRecord = {
      contributorId = account.contributorId;
      kind          = kind;
      toolId        = toolId;
      creatorId     = creatorId;
      magnitude     = magnitudeOf(kind);
      phiWeight     = phiWeight;
      royaltyRouted = royalty;
      timestamp     = timestamp;
      sessionId     = sessionId;
      verified      = verified;
    };

    // Update compound multiplier: grows by φ⁻¹ % per contribution, never drops
    let newCompound = Float.max(1.0, account.compoundMultiplier * (1.0 + PHI_INV * 0.001));
    let newPressure = Float.max(S0, account.totalPressure + phiWeight);
    let newRoyalty  = account.totalRoyaltyEarned + (if (account.isCreator and creatorId == account.contributorId) { royalty } else { 0.0 });

    let (newB, newC, newG, newV, newM, newGt) = switch (kind) {
      case (#Build)  { (account.buildCount+1,  account.callCount,   account.governCount, account.verifyCount, account.memoryCount, account.gateCount)   };
      case (#Call)   { (account.buildCount,    account.callCount+1, account.governCount, account.verifyCount, account.memoryCount, account.gateCount)   };
      case (#Govern) { (account.buildCount,    account.callCount,   account.governCount+1, account.verifyCount, account.memoryCount, account.gateCount) };
      case (#Verify) { (account.buildCount,    account.callCount,   account.governCount, account.verifyCount+1, account.memoryCount, account.gateCount) };
      case (#Memory) { (account.buildCount,    account.callCount,   account.governCount, account.verifyCount, account.memoryCount+1, account.gateCount)  };
      case (#Gate)   { (account.buildCount,    account.callCount,   account.governCount, account.verifyCount, account.memoryCount, account.gateCount+1) };
    };

    let updatedAccount : ContributorAccount = {
      contributorId      = account.contributorId;
      isCreator          = account.isCreator;
      totalPressure      = newPressure;
      totalRoyaltyEarned = newRoyalty;
      buildCount         = newB;
      callCount          = newC;
      governCount        = newG;
      verifyCount        = newV;
      memoryCount        = newM;
      gateCount          = newGt;
      firstContribAt     = if (account.firstContribAt == 0) { timestamp } else { account.firstContribAt };
      lastContribAt      = timestamp;
      compoundMultiplier = newCompound;
      sovereignTier      = classifyTier(newPressure);
    };

    (updatedAccount, record)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initService() : IncentiveServiceState {
    {
      contributors     = [];
      records          = [];
      totalPressure    = 0.0;
      totalRoyaltyPaid = 0.0;
      sessionId        = 0;
      phiCoherence     = 0.0;
      beatNum          = 0;
    }
  };

  public func initContributor(
    id        : Text,
    isCreator : Bool
  ) : ContributorAccount {
    {
      contributorId      = id;
      isCreator          = isCreator;
      totalPressure      = S0;     // Starts at the love constant floor
      totalRoyaltyEarned = 0.0;
      buildCount         = 0;
      callCount          = 0;
      governCount        = 0;
      verifyCount        = 0;
      memoryCount        = 0;
      gateCount          = 0;
      firstContribAt     = 0;
      lastContribAt      = 0;
      compoundMultiplier = 1.0;
      sovereignTier      = #Seed;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FIELD TICK
  // ═══════════════════════════════════════════════════════════════════════════

  /// Advance the incentive service one beat:
  ///   - Decay compound multipliers for inactive contributors (but never below 1.0)
  ///   - Recompute global field pressure
  ///   - Update phi coherence ratio
  public func tickIncentiveService(state : IncentiveServiceState, currentTime : Int) : IncentiveServiceState {
    let INACTIVITY_DECAY : Float = 1.0 - (PHI_INV * 0.0001);  // Very slow decay toward 1.0

    let updatedContributors = Array.map<ContributorAccount, ContributorAccount>(
      state.contributors,
      func(acc) {
        // If contributor hasn't acted this beat, gently decay compound multiplier
        // but never below 1.0 — sovereignty preserved
        let timeSinceLast : Int = currentTime - acc.lastContribAt;
        let decayed = if (timeSinceLast > 86_400_000_000_000) {  // > 1 day in nanoseconds
          Float.max(1.0, acc.compoundMultiplier * INACTIVITY_DECAY)
        } else {
          acc.compoundMultiplier
        };
        {
          contributorId      = acc.contributorId;
          isCreator          = acc.isCreator;
          totalPressure      = acc.totalPressure;
          totalRoyaltyEarned = acc.totalRoyaltyEarned;
          buildCount         = acc.buildCount;
          callCount          = acc.callCount;
          governCount        = acc.governCount;
          verifyCount        = acc.verifyCount;
          memoryCount        = acc.memoryCount;
          gateCount          = acc.gateCount;
          firstContribAt     = acc.firstContribAt;
          lastContribAt      = acc.lastContribAt;
          compoundMultiplier = decayed;
          sovereignTier      = acc.sovereignTier;
        }
      }
    );

    // Recompute global pressure
    var globalPressure : Float = 0.0;
    for (acc in updatedContributors.vals()) {
      globalPressure += acc.totalPressure;
    };

    // Phi coherence = verified / total contributions
    var verifiedCount : Nat = 0;
    for (r in state.records.vals()) {
      if (r.verified) { verifiedCount += 1 };
    };
    let totalRecords = state.records.size();
    let coherence = if (totalRecords == 0) { 0.0 } else {
      Float.fromInt(verifiedCount) / Float.fromInt(totalRecords)
    };

    {
      contributors     = updatedContributors;
      records          = state.records;
      totalPressure    = globalPressure;
      totalRoyaltyPaid = state.totalRoyaltyPaid;
      sessionId        = state.sessionId;
      phiCoherence     = coherence;
      beatNum          = state.beatNum + 1;
    }
  };

}
