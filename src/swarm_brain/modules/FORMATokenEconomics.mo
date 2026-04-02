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
// ███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗     ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
// ██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
// █████╗  ██║   ██║██████╔╝██╔████╔██║███████║       ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
// ██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║       ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
// ██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║       ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
// ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝       ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
// ════════════════════════════════════════════════════════════════════════════════════════
//
// FORMA TOKEN ECONOMICS — L2 VALUE LAYER
// ERC-20 Compatible Token for Sovereign Swarm Economics
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// FORMA (Formation Organism Resource Metric Asset) is the economic substrate
// of the swarm organism. Unlike traditional cryptocurrencies, FORMA is:
//
//   1. COHERENCE-MINTED  — New tokens created when rSwarm is high
//   2. WORK-BACKED       — Represents actual swarm labor (missions, formations)
//   3. DECAY-RESISTANT   — Sovereign floor prevents total devaluation
//   4. BEHAVIORALLY-VALUED — Uses prospect theory, not rational pricing
//
// FORMA TOKEN MECHANICS:
//   - Minting: FORMA_mint = energy × rSwarm × coherenceTime
//   - Burning: Mission costs consume FORMA
//   - Staking: Locked FORMA increases swarm commitment
//   - Governance: FORMA holders vote on mission parameters
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Array "mo:base/Array";
import Principal "mo:base/Principal";

module {

  // ══════════════════════════════════════════════════════════════════════════════════════
  // FORMA CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════════════════

  // Token identity
  public let TOKEN_NAME     : Text = "FORMA";
  public let TOKEN_SYMBOL   : Text = "FORMA";
  public let TOKEN_DECIMALS : Nat8 = 18;

  // Supply limits
  public let MAX_SUPPLY     : Nat = 1_000_000_000_000_000_000_000_000_000;  // 1 billion FORMA
  public let INITIAL_SUPPLY : Nat = 0;  // All FORMA must be minted through coherence

  // Minting parameters
  public let MINT_RATE_BASE : Float = 1.0;        // Base mint per beat at r=1.0
  public let COHERENCE_THRESHOLD : Float = 0.5;   // Minimum rSwarm to mint
  public let OMNIS_BONUS    : Float = 2.0;        // 2x mint rate during OMNIS state

  // Economic parameters
  public let MISSION_COST_BASE : Float = 10.0;    // Base FORMA per mission
  public let SACRIFICE_REWARD  : Float = 100.0;   // FORMA reward for drone sacrifice
  public let EMERGENCE_BONUS   : Float = 1000.0;  // Bonus for achieving emergence

  // Behavioral economics parameters
  public let LOSS_AVERSION : Float = 2.25;        // Losses hurt 2.25x more
  public let ENDOWMENT_EFFECT : Float = 0.1;      // Owned tokens valued 10% higher

  // ══════════════════════════════════════════════════════════════════════════════════════
  // FORMA TOKEN TYPES
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type TokenBalance = {
    owner       : Principal;
    balance     : Nat;
    staked      : Nat;
    lastMint    : Nat;  // Beat of last mint
    totalMinted : Nat;
    totalBurned : Nat;
  };

  public type MintEvent = {
    beat        : Nat;
    amount      : Nat;
    rSwarm      : Float;
    energy      : Float;
    recipient   : Principal;
    reason      : Text;
  };

  public type BurnEvent = {
    beat        : Nat;
    amount      : Nat;
    burner      : Principal;
    reason      : Text;
  };

  public type TransferEvent = {
    beat        : Nat;
    from        : Principal;
    to          : Principal;
    amount      : Nat;
    memo        : Text;
  };

  public type StakeEvent = {
    beat        : Nat;
    staker      : Principal;
    amount      : Nat;
    duration    : Nat;  // Beats
    reward      : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // TOKEN STATE
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type FORMAState = {
    totalSupply     : Nat;
    circulatingSupply: Nat;  // totalSupply - burned - staked
    totalBurned     : Nat;
    totalStaked     : Nat;
    totalMintEvents : Nat;
    balances        : [TokenBalance];
    mintHistory     : [MintEvent];
    burnHistory     : [BurnEvent];
    lastMintBeat    : Nat;
    currentMintRate : Float;
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  1. COHERENCE-BASED MINTING  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // FORMA MINTING FORMULA:
  //   mint_amount = energy × rSwarm² × coherence_time × base_rate × bonuses
  //
  // The squared rSwarm means:
  //   - At r=0.5: mint = 0.25 × base
  //   - At r=0.8: mint = 0.64 × base
  //   - At r=0.98 (OMNIS): mint = 0.96 × base × 2 (OMNIS bonus)
  //
  // This creates strong incentive for coherence.
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type MintCalculation = {
    baseAmount      : Float;
    coherenceBonus  : Float;
    energyFactor    : Float;
    omnisBonus      : Float;
    totalMint       : Nat;
    eligible        : Bool;
    reason          : Text;
  };

  public func calculateMint(
    rSwarm: Float,
    energy: Float,
    coherenceTime: Nat,  // Beats at high coherence
    isOMNIS: Bool
  ) : MintCalculation {
    // Check eligibility
    if (rSwarm < COHERENCE_THRESHOLD) {
      return {
        baseAmount = 0.0;
        coherenceBonus = 0.0;
        energyFactor = 0.0;
        omnisBonus = 0.0;
        totalMint = 0;
        eligible = false;
        reason = "Coherence below threshold (" # Float.toText(rSwarm) # " < " # Float.toText(COHERENCE_THRESHOLD) # ")";
      }
    };

    // Base calculation
    let baseAmount = MINT_RATE_BASE * Float.fromInt(coherenceTime);

    // Coherence bonus (squared for exponential incentive)
    let coherenceBonus = rSwarm * rSwarm;

    // Energy factor (capped at 2x)
    let energyFactor = Float.min(2.0, energy);

    // OMNIS state bonus
    let omnisBonus = if (isOMNIS) { OMNIS_BONUS } else { 1.0 };

    // Total mint
    let totalFloat = baseAmount * coherenceBonus * energyFactor * omnisBonus;
    let totalMint = Int.abs(Float.toInt(totalFloat * 1_000_000_000_000_000_000.0));  // Scale to 18 decimals

    {
      baseAmount = baseAmount;
      coherenceBonus = coherenceBonus;
      energyFactor = energyFactor;
      omnisBonus = omnisBonus;
      totalMint = totalMint;
      eligible = true;
      reason = "Mint approved";
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  2. MISSION ECONOMICS  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // Missions have FORMA costs that scale with:
  //   - Duration
  //   - Risk level
  //   - Number of drones
  //   - Distance
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type MissionCost = {
    baseCost        : Float;
    durationCost    : Float;
    riskCost        : Float;
    scaleCost       : Float;
    totalCost       : Nat;
    breakdown       : Text;
  };

  public func calculateMissionCost(
    duration: Nat,        // Beats
    riskLevel: Float,     // 0-1
    droneCount: Nat,
    distance: Float       // Meters
  ) : MissionCost {
    // Base cost
    let baseCost = MISSION_COST_BASE;

    // Duration cost (linear)
    let durationCost = Float.fromInt(duration) * 0.1;

    // Risk cost (exponential at high risk)
    let riskCost = baseCost * riskLevel * riskLevel * 2.0;

    // Scale cost (diminishing returns for more drones)
    let scaleCost = Float.fromInt(droneCount) * 0.5 + Float.sqrt(Float.fromInt(droneCount)) * 2.0;

    // Distance cost
    let distanceCost = distance * 0.001;

    let total = baseCost + durationCost + riskCost + scaleCost + distanceCost;
    let totalCost = Int.abs(Float.toInt(total * 1_000_000_000_000_000_000.0));

    {
      baseCost = baseCost;
      durationCost = durationCost;
      riskCost = riskCost;
      scaleCost = scaleCost;
      totalCost = totalCost;
      breakdown = "Base: " # Float.toText(baseCost) # 
                  " + Duration: " # Float.toText(durationCost) #
                  " + Risk: " # Float.toText(riskCost) #
                  " + Scale: " # Float.toText(scaleCost);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  3. BEHAVIORAL TOKEN VALUATION  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // FORMA value is perceived through behavioral economics lenses:
  //   - Reference dependence: Value relative to acquisition cost
  //   - Loss aversion: Selling at loss requires 2.25x premium
  //   - Endowment effect: Owned tokens valued higher
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type PerceivedValue = {
    marketValue     : Float;
    perceivedValue  : Float;
    sellingPrice    : Float;  // Price at which holder would sell
    endowmentBonus  : Float;
    lossAversionAdj : Float;
  };

  public func perceiveValue(
    marketPrice: Float,
    acquisitionCost: Float,
    holdingDuration: Nat
  ) : PerceivedValue {
    // Endowment effect grows with holding time
    let endowmentBonus = ENDOWMENT_EFFECT * Float.log(1.0 + Float.fromInt(holdingDuration) / 1000.0);
    let perceivedValue = marketPrice * (1.0 + endowmentBonus);

    // Loss aversion affects selling price
    let gainLoss = marketPrice - acquisitionCost;
    let lossAversionAdj = if (gainLoss < 0.0) { 
      LOSS_AVERSION * Float.abs(gainLoss) / acquisitionCost 
    } else { 0.0 };

    // Selling price: won't sell below acquisition cost without premium
    let sellingPrice = if (gainLoss >= 0.0) {
      marketPrice * 0.98  // Small discount acceptable in gains
    } else {
      acquisitionCost * (1.0 + lossAversionAdj)  // Need premium in losses
    };

    {
      marketValue = marketPrice;
      perceivedValue = perceivedValue;
      sellingPrice = sellingPrice;
      endowmentBonus = endowmentBonus;
      lossAversionAdj = lossAversionAdj;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  4. STAKING MECHANICS  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // Staking FORMA shows commitment to the swarm.
  // Longer stakes = higher rewards.
  // Staked FORMA counts toward governance weight.
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type StakeReward = {
    amount          : Nat;
    duration        : Nat;  // Beats
    apy             : Float;
    expectedReward  : Nat;
    governanceWeight: Float;
  };

  public func calculateStakeReward(
    amount: Nat,
    duration: Nat,
    currentCoherence: Float
  ) : StakeReward {
    // APY increases with duration (tiered)
    let baseAPY = 0.05;  // 5% base
    let durationBonus = if (duration > 100000) { 0.15 }
                        else if (duration > 10000) { 0.10 }
                        else if (duration > 1000) { 0.05 }
                        else { 0.0 };
    
    // Coherence bonus
    let coherenceBonus = currentCoherence * 0.05;

    let apy = baseAPY + durationBonus + coherenceBonus;

    // Expected reward
    let rewardFloat = Float.fromInt(amount) * apy * Float.fromInt(duration) / 365_000.0;
    let expectedReward = Int.abs(Float.toInt(rewardFloat));

    // Governance weight: sqrt of staked amount × duration factor
    let governanceWeight = Float.sqrt(Float.fromInt(amount) / 1_000_000_000_000_000_000.0) * 
                          (1.0 + Float.log(1.0 + Float.fromInt(duration) / 1000.0));

    {
      amount = amount;
      duration = duration;
      apy = apy;
      expectedReward = expectedReward;
      governanceWeight = governanceWeight;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  5. GOVERNANCE VOTING  ████
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type Proposal = {
    id              : Nat;
    proposer        : Principal;
    title           : Text;
    description     : Text;
    category        : ProposalCategory;
    votesFor        : Nat;
    votesAgainst    : Nat;
    quorum          : Nat;
    deadline        : Nat;  // Beat
    status          : ProposalStatus;
  };

  public type ProposalCategory = {
    #MISSION_PARAMETER;
    #ECONOMIC_CHANGE;
    #GOVERNANCE_RULE;
    #EMERGENCY;
  };

  public type ProposalStatus = {
    #ACTIVE;
    #PASSED;
    #REJECTED;
    #EXECUTED;
    #EXPIRED;
  };

  public func calculateVotePower(balance: Nat, stakedAmount: Nat, stakeDuration: Nat) : Nat {
    // Staked tokens have higher voting power
    let liquidPower = balance;
    let stakedPower = stakedAmount * 2;  // 2x for staked
    let durationBonus = stakedAmount * stakeDuration / 10000;
    
    liquidPower + stakedPower + durationBonus
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  6. AUDIT HASH ANCHOR  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // Every significant FORMA event is hashed and anchored to the ICP blockchain.
  // This creates an immutable audit trail.
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type AuditAnchor = {
    beat        : Nat;
    eventType   : Text;
    dataHash    : Text;  // SHA256 of event data
    icpBlock    : ?Nat;  // ICP block number (once confirmed)
  };

  // Generate audit hash (simplified - would use actual SHA256)
  public func generateAuditHash(
    eventType: Text,
    amount: Nat,
    beat: Nat,
    participants: [Principal]
  ) : Text {
    // Simplified hash representation
    eventType # "_" # Nat.toText(amount) # "_" # Nat.toText(beat) # "_" # Nat.toText(participants.size())
  };

}
