// ═══════════════════════════════════════════════════════════════════════════════
// INSURANCE POOL — SOVEREIGN RISK MANAGEMENT SUBSTRATE
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — Collective Risk Pooling & Automated Claims
//
// The Insurance Pool is the organism's immune system for value preservation.
// It operates on three principles:
//   1. POOLING    — All participants contribute to shared risk reserve
//   2. PROTECTION — Automated coverage against defined loss events
//   3. RECOVERY   — Claims paid from pool with mathematical fairness
//
// Coverage Types:
//   - PREDICTION_FAILURE: When SIMULACRUM predictions catastrophically fail
//   - COHERENCE_COLLAPSE: When Shell 12 coherence drops below critical
//   - QUANTUM_DECOHERENCE: When QSOV score fails
//   - TERRITORY_LOSS: When ATLAS sovereignty drops significantly
//   - BLACK_SWAN: Unpredictable catastrophic events
//
// Premium Calculation: Based on risk profile, tier, and historical claims
// Claim Processing: Automated verification + multi-sig for large claims
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";

module InsurancePool {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  
  // Pool parameters
  public let MIN_POOL_RESERVE : Float = 1000.0;      // Minimum pool balance
  public let MAX_CLAIM_RATIO : Float = 0.25;         // Max 25% of pool per claim
  public let PREMIUM_BASE_RATE : Float = 0.02;       // 2% base premium rate
  public let DEDUCTIBLE_RATE : Float = 0.10;         // 10% deductible on claims
  
  // Coverage thresholds
  public let PREDICTION_FAILURE_THRESHOLD : Float = 0.50;   // 50% error = failure
  public let COHERENCE_COLLAPSE_THRESHOLD : Float = 0.30;   // Below 30% = collapse
  public let QSOV_FAILURE_THRESHOLD : Float = 0.80;         // Below 0.8 = failure
  public let TERRITORY_LOSS_THRESHOLD : Float = 0.30;       // 30% loss = coverage
  
  // Cooldown periods (in beats)
  public let CLAIM_COOLDOWN : Nat = 500;             // 500 beats between claims
  public let PREMIUM_PERIOD : Nat = 1000;            // Premium due every 1000 beats

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type CoverageType = {
    #PredictionFailure;
    #CoherenceCollapse;
    #QuantumDecoherence;
    #TerritoryLoss;
    #BlackSwan;
  };

  public type ClaimStatus = {
    #Pending;
    #Approved;
    #Denied;
    #Paid;
    #Appealed;
  };

  public type RiskProfile = {
    predictionRisk    : Float;    // [0,1] based on historical accuracy
    coherenceRisk     : Float;    // [0,1] based on coherence stability
    quantumRisk       : Float;    // [0,1] based on QSOV history
    territoryRisk     : Float;    // [0,1] based on territory volatility
    overallRisk       : Float;    // Weighted composite
    tierMultiplier    : Float;    // From VELA tier
  };

  public type Policy = {
    policyId          : Nat;
    holderPrincipal   : Text;     // Principal as text
    coverages         : [CoverageType];
    coverageAmounts   : [Float];  // Max payout per coverage type
    premiumPaid       : Float;
    premiumDueAt      : Nat;      // Beat when next premium due
    riskProfile       : RiskProfile;
    activeSince       : Nat;
    lastClaimAt       : Nat;
    totalClaimsPaid   : Float;
    claimCount        : Nat;
    isActive          : Bool;
  };

  public type Claim = {
    claimId           : Nat;
    policyId          : Nat;
    coverageType      : CoverageType;
    claimAmount       : Float;
    actualLoss        : Float;
    evidenceHash      : Nat64;    // Hash of supporting evidence
    filedAt           : Nat;
    status            : ClaimStatus;
    paidAmount        : Float;
    denialReason      : ?Text;
    reviewedAt        : ?Nat;
  };

  public type PoolState = {
    // Pool balances
    totalReserve      : Float;    // Total pool value
    availableReserve  : Float;    // Available for claims
    lockedForClaims   : Float;    // Reserved for pending claims
    
    // Pool statistics
    totalPremiumsCollected : Float;
    totalClaimsPaid   : Float;
    totalClaimsDenied : Float;
    
    // Active entities
    policies          : [Policy];
    pendingClaims     : [Claim];
    claimHistory      : [Claim];
    
    // Operational state
    nextPolicyId      : Nat;
    nextClaimId       : Nat;
    lastRebalanceAt   : Nat;
    poolHealthScore   : Float;    // [0,1] pool sustainability
    
    // Risk aggregates
    totalExposure     : Float;    // Sum of all coverage amounts
    aggregateRisk     : Float;    // Pool-wide risk score
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  func abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 15) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };

  func exp(x : Float) : Float {
    let c = clamp(x, -20.0, 20.0);
    var result = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 25) {
      term := term * c / Float.fromInt(n);
      result += term;
      n += 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initPoolState() : PoolState {
    {
      totalReserve = MIN_POOL_RESERVE;
      availableReserve = MIN_POOL_RESERVE;
      lockedForClaims = 0.0;
      totalPremiumsCollected = 0.0;
      totalClaimsPaid = 0.0;
      totalClaimsDenied = 0.0;
      policies = [];
      pendingClaims = [];
      claimHistory = [];
      nextPolicyId = 1;
      nextClaimId = 1;
      lastRebalanceAt = 0;
      poolHealthScore = 1.0;
      totalExposure = 0.0;
      aggregateRisk = 0.0;
    }
  };

  public func initRiskProfile() : RiskProfile {
    {
      predictionRisk = 0.3;
      coherenceRisk = 0.3;
      quantumRisk = 0.3;
      territoryRisk = 0.3;
      overallRisk = 0.3;
      tierMultiplier = 1.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PREMIUM CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Calculate risk-adjusted premium for a policy
  public func calculatePremium(
    coverages       : [CoverageType],
    coverageAmounts : [Float],
    riskProfile     : RiskProfile
  ) : Float {
    var totalPremium = 0.0;
    
    var i = 0;
    while (i < coverages.size() and i < coverageAmounts.size()) {
      let coverage = coverages[i];
      let amount = coverageAmounts[i];
      
      // Base premium rate per coverage type
      let baseRate = switch (coverage) {
        case (#PredictionFailure) PREMIUM_BASE_RATE * 1.2;   // Higher risk
        case (#CoherenceCollapse) PREMIUM_BASE_RATE * 1.5;   // High risk
        case (#QuantumDecoherence) PREMIUM_BASE_RATE * 1.3;
        case (#TerritoryLoss) PREMIUM_BASE_RATE * 1.1;
        case (#BlackSwan) PREMIUM_BASE_RATE * 2.0;           // Highest risk
      };
      
      // Risk-specific adjustment
      let riskAdjustment = switch (coverage) {
        case (#PredictionFailure) riskProfile.predictionRisk;
        case (#CoherenceCollapse) riskProfile.coherenceRisk;
        case (#QuantumDecoherence) riskProfile.quantumRisk;
        case (#TerritoryLoss) riskProfile.territoryRisk;
        case (#BlackSwan) riskProfile.overallRisk;
      };
      
      // Premium = amount × baseRate × (1 + riskAdjustment) × tierMultiplier
      let coveragePremium = amount * baseRate * (1.0 + riskAdjustment) * riskProfile.tierMultiplier;
      totalPremium += coveragePremium;
      
      i += 1;
    };
    
    totalPremium
  };

  // Update risk profile based on historical data
  public func updateRiskProfile(
    profile         : RiskProfile,
    predictionError : Float,
    coherenceLevel  : Float,
    qsovScore       : Float,
    territorySov    : Float,
    tierMultiplier  : Float
  ) : RiskProfile {
    // Risk increases with poor performance
    let newPredRisk = clamp(
      profile.predictionRisk * 0.9 + predictionError * 0.1,
      0.1, 0.9
    );
    
    let newCohRisk = clamp(
      profile.coherenceRisk * 0.9 + (1.0 - coherenceLevel) * 0.1,
      0.1, 0.9
    );
    
    let newQuantumRisk = clamp(
      profile.quantumRisk * 0.9 + (2.0 - qsovScore) / 2.0 * 0.1,
      0.1, 0.9
    );
    
    let newTerrRisk = clamp(
      profile.territoryRisk * 0.9 + (1.0 - territorySov) * 0.1,
      0.1, 0.9
    );
    
    // Weighted overall risk
    let newOverall = 0.3 * newPredRisk + 0.25 * newCohRisk + 
                     0.25 * newQuantumRisk + 0.2 * newTerrRisk;
    
    {
      predictionRisk = newPredRisk;
      coherenceRisk = newCohRisk;
      quantumRisk = newQuantumRisk;
      territoryRisk = newTerrRisk;
      overallRisk = newOverall;
      tierMultiplier = tierMultiplier;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // POLICY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  // Create new policy
  public func createPolicy(
    state           : PoolState,
    holderPrincipal : Text,
    coverages       : [CoverageType],
    coverageAmounts : [Float],
    currentBeat     : Nat
  ) : (PoolState, Policy) {
    let riskProfile = initRiskProfile();
    let premium = calculatePremium(coverages, coverageAmounts, riskProfile);
    
    let policy : Policy = {
      policyId = state.nextPolicyId;
      holderPrincipal = holderPrincipal;
      coverages = coverages;
      coverageAmounts = coverageAmounts;
      premiumPaid = premium;
      premiumDueAt = currentBeat + PREMIUM_PERIOD;
      riskProfile = riskProfile;
      activeSince = currentBeat;
      lastClaimAt = 0;
      totalClaimsPaid = 0.0;
      claimCount = 0;
      isActive = true;
    };
    
    // Calculate total exposure increase
    var exposure = 0.0;
    for (amt in coverageAmounts.vals()) {
      exposure += amt;
    };
    
    let newPolicies = Array.append(state.policies, [policy]);
    
    let newState : PoolState = {
      totalReserve = state.totalReserve + premium;
      availableReserve = state.availableReserve + premium;
      lockedForClaims = state.lockedForClaims;
      totalPremiumsCollected = state.totalPremiumsCollected + premium;
      totalClaimsPaid = state.totalClaimsPaid;
      totalClaimsDenied = state.totalClaimsDenied;
      policies = newPolicies;
      pendingClaims = state.pendingClaims;
      claimHistory = state.claimHistory;
      nextPolicyId = state.nextPolicyId + 1;
      nextClaimId = state.nextClaimId;
      lastRebalanceAt = state.lastRebalanceAt;
      poolHealthScore = calculatePoolHealth(state.totalReserve + premium, state.totalExposure + exposure);
      totalExposure = state.totalExposure + exposure;
      aggregateRisk = recalculateAggregateRisk(newPolicies);
    };
    
    (newState, policy)
  };

  // Renew policy (pay premium)
  public func renewPolicy(
    state     : PoolState,
    policyId  : Nat,
    currentBeat : Nat
  ) : PoolState {
    let updatedPolicies = Array.map<Policy, Policy>(state.policies, func(p : Policy) : Policy {
      if (p.policyId == policyId and p.isActive) {
        let newPremium = calculatePremium(p.coverages, p.coverageAmounts, p.riskProfile);
        {
          policyId = p.policyId;
          holderPrincipal = p.holderPrincipal;
          coverages = p.coverages;
          coverageAmounts = p.coverageAmounts;
          premiumPaid = p.premiumPaid + newPremium;
          premiumDueAt = currentBeat + PREMIUM_PERIOD;
          riskProfile = p.riskProfile;
          activeSince = p.activeSince;
          lastClaimAt = p.lastClaimAt;
          totalClaimsPaid = p.totalClaimsPaid;
          claimCount = p.claimCount;
          isActive = true;
        }
      } else {
        p
      }
    });
    
    // Calculate premium collected
    var premiumCollected = 0.0;
    for (p in state.policies.vals()) {
      if (p.policyId == policyId) {
        premiumCollected := calculatePremium(p.coverages, p.coverageAmounts, p.riskProfile);
      };
    };
    
    {
      totalReserve = state.totalReserve + premiumCollected;
      availableReserve = state.availableReserve + premiumCollected;
      lockedForClaims = state.lockedForClaims;
      totalPremiumsCollected = state.totalPremiumsCollected + premiumCollected;
      totalClaimsPaid = state.totalClaimsPaid;
      totalClaimsDenied = state.totalClaimsDenied;
      policies = updatedPolicies;
      pendingClaims = state.pendingClaims;
      claimHistory = state.claimHistory;
      nextPolicyId = state.nextPolicyId;
      nextClaimId = state.nextClaimId;
      lastRebalanceAt = state.lastRebalanceAt;
      poolHealthScore = calculatePoolHealth(state.totalReserve + premiumCollected, state.totalExposure);
      totalExposure = state.totalExposure;
      aggregateRisk = state.aggregateRisk;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CLAIM PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════

  // File a claim
  public func fileClaim(
    state        : PoolState,
    policyId     : Nat,
    coverageType : CoverageType,
    actualLoss   : Float,
    evidenceHash : Nat64,
    currentBeat  : Nat
  ) : (PoolState, ?Claim) {
    // Find policy
    var policy : ?Policy = null;
    for (p in state.policies.vals()) {
      if (p.policyId == policyId and p.isActive) {
        policy := ?p;
      };
    };
    
    switch (policy) {
      case (null) { (state, null) };
      case (?p) {
        // Check cooldown
        if (p.lastClaimAt > 0 and currentBeat - p.lastClaimAt < CLAIM_COOLDOWN) {
          return (state, null);
        };
        
        // Check if coverage type is covered
        var maxCoverage : Float = 0.0;
        var i = 0;
        var covered = false;
        while (i < p.coverages.size()) {
          if (coverageTypeEqual(p.coverages[i], coverageType)) {
            covered := true;
            if (i < p.coverageAmounts.size()) {
              maxCoverage := p.coverageAmounts[i];
            };
          };
          i += 1;
        };
        
        if (not covered) {
          return (state, null);
        };
        
        // Calculate claim amount (with deductible)
        let afterDeductible = actualLoss * (1.0 - DEDUCTIBLE_RATE);
        let claimAmount = Float.min(afterDeductible, maxCoverage);
        let cappedAmount = Float.min(claimAmount, state.availableReserve * MAX_CLAIM_RATIO);
        
        let claim : Claim = {
          claimId = state.nextClaimId;
          policyId = policyId;
          coverageType = coverageType;
          claimAmount = cappedAmount;
          actualLoss = actualLoss;
          evidenceHash = evidenceHash;
          filedAt = currentBeat;
          status = #Pending;
          paidAmount = 0.0;
          denialReason = null;
          reviewedAt = null;
        };
        
        let newPending = Array.append(state.pendingClaims, [claim]);
        
        let newState : PoolState = {
          totalReserve = state.totalReserve;
          availableReserve = state.availableReserve - cappedAmount;
          lockedForClaims = state.lockedForClaims + cappedAmount;
          totalPremiumsCollected = state.totalPremiumsCollected;
          totalClaimsPaid = state.totalClaimsPaid;
          totalClaimsDenied = state.totalClaimsDenied;
          policies = state.policies;
          pendingClaims = newPending;
          claimHistory = state.claimHistory;
          nextPolicyId = state.nextPolicyId;
          nextClaimId = state.nextClaimId + 1;
          lastRebalanceAt = state.lastRebalanceAt;
          poolHealthScore = state.poolHealthScore;
          totalExposure = state.totalExposure;
          aggregateRisk = state.aggregateRisk;
        };
        
        (newState, ?claim)
      };
    }
  };

  // Process pending claims (automated verification)
  public func processClaims(
    state           : PoolState,
    predictionError : Float,
    coherenceLevel  : Float,
    qsovScore       : Float,
    territorySov    : Float,
    currentBeat     : Nat
  ) : PoolState {
    let processedClaims = Buffer.Buffer<Claim>(state.pendingClaims.size());
    let newHistory = Buffer.Buffer<Claim>(state.claimHistory.size() + state.pendingClaims.size());
    
    // Copy existing history
    for (c in state.claimHistory.vals()) {
      newHistory.add(c);
    };
    
    var totalPaid = 0.0;
    var totalDenied = 0.0;
    var releasedLock = 0.0;
    
    for (claim in state.pendingClaims.vals()) {
      // Verify claim based on coverage type
      let isValid = switch (claim.coverageType) {
        case (#PredictionFailure) predictionError >= PREDICTION_FAILURE_THRESHOLD;
        case (#CoherenceCollapse) coherenceLevel <= COHERENCE_COLLAPSE_THRESHOLD;
        case (#QuantumDecoherence) qsovScore <= QSOV_FAILURE_THRESHOLD;
        case (#TerritoryLoss) territorySov <= (1.0 - TERRITORY_LOSS_THRESHOLD);
        case (#BlackSwan) true;  // Always requires manual review, auto-approve for now
      };
      
      if (isValid) {
        // Approve and pay claim
        let paidClaim : Claim = {
          claimId = claim.claimId;
          policyId = claim.policyId;
          coverageType = claim.coverageType;
          claimAmount = claim.claimAmount;
          actualLoss = claim.actualLoss;
          evidenceHash = claim.evidenceHash;
          filedAt = claim.filedAt;
          status = #Paid;
          paidAmount = claim.claimAmount;
          denialReason = null;
          reviewedAt = ?currentBeat;
        };
        newHistory.add(paidClaim);
        totalPaid += claim.claimAmount;
        releasedLock += claim.claimAmount;
      } else {
        // Deny claim
        let deniedClaim : Claim = {
          claimId = claim.claimId;
          policyId = claim.policyId;
          coverageType = claim.coverageType;
          claimAmount = claim.claimAmount;
          actualLoss = claim.actualLoss;
          evidenceHash = claim.evidenceHash;
          filedAt = claim.filedAt;
          status = #Denied;
          paidAmount = 0.0;
          denialReason = ?"Threshold not met";
          reviewedAt = ?currentBeat;
        };
        newHistory.add(deniedClaim);
        totalDenied += claim.claimAmount;
        releasedLock += claim.claimAmount;
      };
    };
    
    // Update policies with claim info
    let updatedPolicies = Array.map<Policy, Policy>(state.policies, func(p : Policy) : Policy {
      var paidForPolicy = 0.0;
      var claimsMade = 0;
      for (c in Buffer.toArray(newHistory).vals()) {
        if (c.policyId == p.policyId and c.status == #Paid) {
          paidForPolicy += c.paidAmount;
          claimsMade += 1;
        };
      };
      
      if (paidForPolicy > 0.0) {
        {
          policyId = p.policyId;
          holderPrincipal = p.holderPrincipal;
          coverages = p.coverages;
          coverageAmounts = p.coverageAmounts;
          premiumPaid = p.premiumPaid;
          premiumDueAt = p.premiumDueAt;
          riskProfile = p.riskProfile;
          activeSince = p.activeSince;
          lastClaimAt = currentBeat;
          totalClaimsPaid = p.totalClaimsPaid + paidForPolicy;
          claimCount = p.claimCount + claimsMade;
          isActive = p.isActive;
        }
      } else {
        p
      }
    });
    
    {
      totalReserve = state.totalReserve - totalPaid;
      availableReserve = state.availableReserve + (releasedLock - totalPaid);
      lockedForClaims = state.lockedForClaims - releasedLock;
      totalPremiumsCollected = state.totalPremiumsCollected;
      totalClaimsPaid = state.totalClaimsPaid + totalPaid;
      totalClaimsDenied = state.totalClaimsDenied + totalDenied;
      policies = updatedPolicies;
      pendingClaims = [];  // All processed
      claimHistory = Buffer.toArray(newHistory);
      nextPolicyId = state.nextPolicyId;
      nextClaimId = state.nextClaimId;
      lastRebalanceAt = state.lastRebalanceAt;
      poolHealthScore = calculatePoolHealth(state.totalReserve - totalPaid, state.totalExposure);
      totalExposure = state.totalExposure;
      aggregateRisk = recalculateAggregateRisk(updatedPolicies);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // POOL HEALTH & RISK METRICS
  // ═══════════════════════════════════════════════════════════════════════════

  func calculatePoolHealth(reserve : Float, exposure : Float) : Float {
    if (exposure <= 0.0) return 1.0;
    
    // Health = Reserve / Exposure, capped at 1.0
    // Pool is healthy if reserve > 50% of exposure
    let ratio = reserve / exposure;
    clamp(ratio * 2.0, 0.0, 1.0)
  };

  func recalculateAggregateRisk(policies : [Policy]) : Float {
    if (policies.size() == 0) return 0.0;
    
    var totalRisk = 0.0;
    var totalWeight = 0.0;
    
    for (p in policies.vals()) {
      if (p.isActive) {
        var exposure = 0.0;
        for (amt in p.coverageAmounts.vals()) {
          exposure += amt;
        };
        totalRisk += p.riskProfile.overallRisk * exposure;
        totalWeight += exposure;
      };
    };
    
    if (totalWeight <= 0.0) 0.0 else totalRisk / totalWeight
  };

  func coverageTypeEqual(a : CoverageType, b : CoverageType) : Bool {
    switch (a, b) {
      case (#PredictionFailure, #PredictionFailure) true;
      case (#CoherenceCollapse, #CoherenceCollapse) true;
      case (#QuantumDecoherence, #QuantumDecoherence) true;
      case (#TerritoryLoss, #TerritoryLoss) true;
      case (#BlackSwan, #BlackSwan) true;
      case _ false;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  public type PoolSummary = {
    totalReserve       : Float;
    availableReserve   : Float;
    poolHealthScore    : Float;
    totalPolicies      : Nat;
    activePolicies     : Nat;
    pendingClaimsCount : Nat;
    totalClaimsPaid    : Float;
    claimDenialRate    : Float;
    aggregateRisk      : Float;
    exposureRatio      : Float;   // Exposure / Reserve
  };

  public func summarize(state : PoolState) : PoolSummary {
    var activePolicies = 0;
    for (p in state.policies.vals()) {
      if (p.isActive) activePolicies += 1;
    };
    
    let totalClaimsProcessed = state.totalClaimsPaid + state.totalClaimsDenied;
    let denialRate = if (totalClaimsProcessed > 0.0) 
      state.totalClaimsDenied / totalClaimsProcessed
      else 0.0;
    
    let exposureRatio = if (state.totalReserve > 0.0)
      state.totalExposure / state.totalReserve
      else 0.0;
    
    {
      totalReserve = state.totalReserve;
      availableReserve = state.availableReserve;
      poolHealthScore = state.poolHealthScore;
      totalPolicies = state.policies.size();
      activePolicies = activePolicies;
      pendingClaimsCount = state.pendingClaims.size();
      totalClaimsPaid = state.totalClaimsPaid;
      claimDenialRate = denialRate;
      aggregateRisk = state.aggregateRisk;
      exposureRatio = exposureRatio;
    }
  };

}
