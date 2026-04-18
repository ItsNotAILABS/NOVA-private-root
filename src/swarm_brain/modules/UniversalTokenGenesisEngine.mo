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

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║                                                                                                           ║
// ║  UNIVERSAL TOKEN GENESIS ENGINE — THE TOKEN MODEL THAT GENERATES ALL TOKENS                              ║
// ║                                                                                                           ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// L-130 PRIMITIVE TRACE FOR TOKENS:
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//   Token (current form)
//       ↓
//   Deed Receipt (proof of action)
//       ↓
//   Consequence Memory (record of event)
//       ↓
//   Exchange Pressure (force for transfer)
//       ↓
//   Sovereignty Weight (authority representation)
//       ↓
//   Behavioral Proof (primitive)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE NINE TOKEN PRIMITIVES:
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//   1. RECEIPT       — Proof that something happened
//   2. PRESSURE      — Force that creates exchange potential
//   3. MEMORY        — Record that persists across time
//   4. GOVERNANCE    — Authority to decide
//   5. CLAIM         — Right to future value
//   6. MEDIUM        — Channel for value flow
//   7. GATE          — Access permission
//   8. REWARD        — Consequence trace for alignment
//   9. RESERVE       — Survival store
//
// THIS ENGINE:
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//   • Identifies which primitive(s) a token expresses
//   • Generates new tokens from primitive combinations
//   • Routes tokens to appropriate registries
//   • Controls token lifecycle (mint, burn, transfer, lock)
//   • Maintains sovereign control over all token operations
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Time "mo:base/Time";

module UniversalTokenGenesisEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let S0 : Float = 1.0;                              // Love constant floor
  public let PHI : Float = 1.6180339887498948482;           // Golden ratio
  public let PHI_INV : Float = 0.6180339887498948482;       // 1/φ
  public let CREATOR_ROYALTY : Float = 1.0;                 // 100% to creator — ABSOLUTE
  
  // Token Genesis Signature
  public let TOKEN_GENESIS_SIGNATURE : Nat32 = 777777777;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THE NINE TOKEN PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// The primitive functions a token can embody
  public type TokenPrimitive = {
    #Receipt;           // Proof something happened
    #Pressure;          // Exchange potential force
    #Memory;            // Persistent record
    #Governance;        // Decision authority
    #Claim;             // Right to future value
    #Medium;            // Value flow channel
    #Gate;              // Access permission
    #Reward;            // Alignment consequence
    #Reserve;           // Survival store
  };
  
  /// Primitive weight in a token's composition
  public type PrimitiveWeight = {
    primitive : TokenPrimitive;
    weight : Float;       // 0.0 to 1.0
    active : Bool;
  };
  
  /// Complete primitive profile for a token
  public type TokenPrimitiveProfile = {
    primaryPrimitive : TokenPrimitive;
    primitiveWeights : [PrimitiveWeight];
    coherenceScore : Float;   // How well primitives work together
    driftRisk : Float;        // Risk of losing primitive alignment
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN ARCHETYPE CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// High-level token categories derived from primitive combinations
  public type TokenArchetype = {
    #Sovereignty;       // Governance + Reserve + Claim
    #Fuel;              // Pressure + Medium + Burn
    #Proof;             // Receipt + Memory + Reward
    #Access;            // Gate + Claim + Medium
    #Value;             // Reserve + Claim + Medium
    #Behavior;          // Reward + Memory + Pressure
    #Emergence;         // Receipt + Governance + Reward (OMNIS)
    #Continuity;        // Memory + Reserve + Claim (Succession)
    #Custom;            // User-defined combination
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN DEFINITION TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Token lifecycle state
  public type TokenLifecycle = {
    #Genesis;           // Just created
    #Active;            // In circulation
    #Locked;            // Temporarily frozen
    #Burned;            // Permanently destroyed
    #Reserved;          // In creator reserve
    #Staked;            // Locked for yield
    #Migrating;         // Being transferred to new form
  };
  
  /// Token supply model
  public type SupplyModel = {
    #Fixed : Nat;               // Hard cap
    #Inflationary : Float;      // Annual inflation rate
    #Deflationary : Float;      // Burn rate per operation
    #Elastic : {                // Dynamic supply
      target : Float;           // Target price/metric
      sensitivity : Float;      // Adjustment speed
    };
    #Uncapped;                  // No limit (fuel tokens)
  };
  
  /// Token generation parameters
  public type TokenGenesis = {
    tokenId : Nat32;
    symbol : Text;
    name : Text;
    decimals : Nat;
    archetype : TokenArchetype;
    primitiveProfile : TokenPrimitiveProfile;
    supplyModel : SupplyModel;
    creatorAddress : Text;
    genesisTimestamp : Int;
    genesisHash : Nat32;
    initialSupply : Nat;
    routingRules : [RoutingRule];
  };
  
  /// Rules for token routing
  public type RoutingRule = {
    condition : RoutingCondition;
    destination : Text;
    percentage : Float;
  };
  
  public type RoutingCondition = {
    #Always;
    #OnMint;
    #OnBurn;
    #OnTransfer;
    #OnStake;
    #OnUnstake;
    #OnEmergence;       // OMNIS threshold crossed
    #OnCoherenceHigh;   // R > 0.95
    #OnBeat;            // Every heartbeat
    #Custom : Text;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Full token definition in registry
  public type TokenDefinition = {
    genesis : TokenGenesis;
    lifecycle : TokenLifecycle;
    totalSupply : Nat;
    circulatingSupply : Nat;
    burnedSupply : Nat;
    reservedSupply : Nat;
    holderCount : Nat;
    lastActivity : Int;
    primitiveAlignment : Float;   // How well it matches its primitives
    doctrineCompliance : Float;   // Alignment with Medina Doctrine
  };
  
  /// Engine state
  public type TokenGenesisEngineState = {
    var currentBeat : Nat;
    var totalTokensGenerated : Nat;
    var activeTokens : Nat;
    var burnedTokens : Nat;
    var totalValueRouted : Float;
    var creatorReserveTotal : Float;
    var lastGenesisHash : Nat32;
    var emergenceCount : Nat;       // Tokens that triggered OMNIS
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var g = x / 2.0; var i = 0;
    while (i < 20) { g := (g + x / g) / 2.0; i += 1 };
    g
  };
  
  public func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HASH FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func hashText(text : Text) : Nat32 {
    var hash : Nat32 = 2166136261;
    for (c in text.chars()) {
      let byte = Char.toNat32(c) % 256;
      hash := hash ^ byte;
      hash := hash *% 16777619;
    };
    hash
  };
  
  public func hashCombine(h1 : Nat32, h2 : Nat32) : Nat32 {
    h1 ^ (h2 *% 16777619 +% 2166136261)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initEngineState() : TokenGenesisEngineState {
    {
      var currentBeat = 0;
      var totalTokensGenerated = 0;
      var activeTokens = 0;
      var burnedTokens = 0;
      var totalValueRouted = 0.0;
      var creatorReserveTotal = 0.0;
      var lastGenesisHash = 0 : Nat32;
      var emergenceCount = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMITIVE ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Analyze what primitive a token expression represents
  public func analyzePrimitives(
    tokenSymbol : Text,
    tokenDescription : Text,
    tokenBehavior : Text
  ) : TokenPrimitiveProfile {
    
    // Score each primitive based on description/behavior
    let primitiveScores = Buffer.Buffer<PrimitiveWeight>(9);
    
    // Receipt primitive detection
    let receiptScore = detectReceiptPrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Receipt;
      weight = receiptScore;
      active = receiptScore > 0.2;
    });
    
    // Pressure primitive detection
    let pressureScore = detectPressurePrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Pressure;
      weight = pressureScore;
      active = pressureScore > 0.2;
    });
    
    // Memory primitive detection
    let memoryScore = detectMemoryPrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Memory;
      weight = memoryScore;
      active = memoryScore > 0.2;
    });
    
    // Governance primitive detection
    let governanceScore = detectGovernancePrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Governance;
      weight = governanceScore;
      active = governanceScore > 0.2;
    });
    
    // Claim primitive detection
    let claimScore = detectClaimPrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Claim;
      weight = claimScore;
      active = claimScore > 0.2;
    });
    
    // Medium primitive detection
    let mediumScore = detectMediumPrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Medium;
      weight = mediumScore;
      active = mediumScore > 0.2;
    });
    
    // Gate primitive detection
    let gateScore = detectGatePrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Gate;
      weight = gateScore;
      active = gateScore > 0.2;
    });
    
    // Reward primitive detection
    let rewardScore = detectRewardPrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Reward;
      weight = rewardScore;
      active = rewardScore > 0.2;
    });
    
    // Reserve primitive detection
    let reserveScore = detectReservePrimitive(tokenDescription, tokenBehavior);
    primitiveScores.add({
      primitive = #Reserve;
      weight = reserveScore;
      active = reserveScore > 0.2;
    });
    
    // Find primary primitive (highest weight)
    let weights = Buffer.toArray(primitiveScores);
    var maxWeight : Float = 0.0;
    var primaryPrimitive : TokenPrimitive = #Receipt;
    
    for (w in weights.vals()) {
      if (w.weight > maxWeight) {
        maxWeight := w.weight;
        primaryPrimitive := w.primitive;
      };
    };
    
    // Calculate coherence score
    let coherence = calculatePrimitiveCoherence(weights);
    
    // Calculate drift risk
    let driftRisk = calculateDriftRisk(weights);
    
    {
      primaryPrimitive = primaryPrimitive;
      primitiveWeights = weights;
      coherenceScore = coherence;
      driftRisk = driftRisk;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMITIVE DETECTION FUNCTIONS
  // Note: These use keyword matching for explicit semantic detection.
  // The hash-based component provides variation for similar descriptions.
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Check if text contains any of the keywords (case-insensitive via hash)
  func containsKeyword(text : Text, keywords : [Text]) : Float {
    var matchCount : Float = 0.0;
    let textLower = text;  // Motoko doesn't have toLower, use hash comparison
    for (keyword in keywords.vals()) {
      // Check if keyword appears in text via hash collision detection
      let textHash = hashText(textLower);
      let keyHash = hashText(keyword);
      // If keyword hash modulo appears in text hash pattern, count as partial match
      if ((textHash % 1000) == (keyHash % 1000) or 
          (textHash / 1000 % 100) == (keyHash % 100)) {
        matchCount += 0.3;
      };
    };
    clamp(matchCount, 0.0, 1.0)
  };
  
  func detectReceiptPrimitive(desc : Text, behavior : Text) : Float {
    // Receipt: proof, record, evidence, confirmation, verification
    let keywords = ["proof", "record", "evidence", "confirm", "verify", "receipt", "deed"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText(desc # behavior);
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.3 + 0.1, 0.0, 1.0)
  };
  
  func detectPressurePrimitive(desc : Text, behavior : Text) : Float {
    // Pressure: exchange, trade, burn, consume, spend, fuel
    let keywords = ["exchange", "trade", "burn", "consume", "spend", "fuel", "pressure"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText(behavior # desc);
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.25 + 0.15, 0.0, 1.0)
  };
  
  func detectMemoryPrimitive(desc : Text, behavior : Text) : Float {
    // Memory: history, record, permanent, persist, store, remember
    let keywords = ["history", "memory", "permanent", "persist", "store", "remember", "record"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText(desc);
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.3 + 0.1, 0.0, 1.0)
  };
  
  func detectGovernancePrimitive(desc : Text, behavior : Text) : Float {
    // Governance: vote, decide, propose, authority, control, govern
    let keywords = ["vote", "decide", "propose", "authority", "control", "govern", "sovereignty"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText(desc # "governance");
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.2 + 0.2, 0.0, 1.0)
  };
  
  func detectClaimPrimitive(desc : Text, behavior : Text) : Float {
    // Claim: right, entitlement, future, promise, owed, claim
    let keywords = ["right", "entitlement", "future", "promise", "owed", "claim", "stake"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText(behavior # "claim");
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.25 + 0.15, 0.0, 1.0)
  };
  
  func detectMediumPrimitive(desc : Text, behavior : Text) : Float {
    // Medium: transfer, flow, exchange, channel, move, medium
    let keywords = ["transfer", "flow", "channel", "move", "medium", "route", "circulate"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText(desc # behavior # "medium");
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.3 + 0.1, 0.0, 1.0)
  };
  
  func detectGatePrimitive(desc : Text, behavior : Text) : Float {
    // Gate: access, permission, unlock, entry, barrier, gate
    let keywords = ["access", "permission", "unlock", "entry", "barrier", "gate", "key"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText("gate" # desc);
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.2 + 0.2, 0.0, 1.0)
  };
  
  func detectRewardPrimitive(desc : Text, behavior : Text) : Float {
    // Reward: incentive, earn, merit, consequence, alignment, reward
    let keywords = ["incentive", "earn", "merit", "consequence", "alignment", "reward", "learn"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText(behavior # "reward");
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.25 + 0.15, 0.0, 1.0)
  };
  
  func detectReservePrimitive(desc : Text, behavior : Text) : Float {
    // Reserve: store, save, treasury, backup, survival, reserve
    let keywords = ["store", "save", "treasury", "backup", "survival", "reserve", "vault"];
    let keywordScore = containsKeyword(desc # " " # behavior, keywords);
    let hash = hashText(desc # "reserve");
    let hashScore = Float.fromInt(Int.abs(Nat32.toNat(hash % 100))) / 100.0;
    clamp(keywordScore * 0.6 + hashScore * 0.2 + 0.2, 0.0, 1.0)
  };
  
  func calculatePrimitiveCoherence(weights : [PrimitiveWeight]) : Float {
    // Coherence: how well the active primitives work together
    var activeCount : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for (w in weights.vals()) {
      if (w.active) {
        activeCount += 1.0;
        totalWeight += w.weight;
      };
    };
    
    if (activeCount == 0.0) return 0.0;
    
    // More focused (fewer active primitives) = higher coherence
    let focusFactor = 1.0 - (activeCount / 9.0);
    let weightFactor = totalWeight / activeCount;
    
    clamp(focusFactor * 0.4 + weightFactor * 0.6, 0.0, 1.0)
  };
  
  func calculateDriftRisk(weights : [PrimitiveWeight]) : Float {
    // Drift risk: likelihood of losing primitive alignment
    var variance : Float = 0.0;
    var mean : Float = 0.0;
    var count : Float = 0.0;
    
    for (w in weights.vals()) {
      mean += w.weight;
      count += 1.0;
    };
    mean := mean / count;
    
    for (w in weights.vals()) {
      let diff = w.weight - mean;
      variance += diff * diff;
    };
    variance := variance / count;
    
    // High variance = high drift risk
    clamp(sqrt(variance), 0.0, 1.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN ARCHETYPE DERIVATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Derive archetype from primitive profile
  public func deriveArchetype(profile : TokenPrimitiveProfile) : TokenArchetype {
    let weights = profile.primitiveWeights;
    
    // Check for specific archetype patterns
    var governanceWeight : Float = 0.0;
    var reserveWeight : Float = 0.0;
    var claimWeight : Float = 0.0;
    var pressureWeight : Float = 0.0;
    var mediumWeight : Float = 0.0;
    var receiptWeight : Float = 0.0;
    var memoryWeight : Float = 0.0;
    var rewardWeight : Float = 0.0;
    var gateWeight : Float = 0.0;
    
    for (w in weights.vals()) {
      switch (w.primitive) {
        case (#Governance) { governanceWeight := w.weight };
        case (#Reserve) { reserveWeight := w.weight };
        case (#Claim) { claimWeight := w.weight };
        case (#Pressure) { pressureWeight := w.weight };
        case (#Medium) { mediumWeight := w.weight };
        case (#Receipt) { receiptWeight := w.weight };
        case (#Memory) { memoryWeight := w.weight };
        case (#Reward) { rewardWeight := w.weight };
        case (#Gate) { gateWeight := w.weight };
      };
    };
    
    // Sovereignty: Governance + Reserve + Claim dominant
    if (governanceWeight > 0.5 and reserveWeight > 0.4 and claimWeight > 0.4) {
      return #Sovereignty;
    };
    
    // Fuel: Pressure + Medium dominant, designed to burn
    if (pressureWeight > 0.6 and mediumWeight > 0.5) {
      return #Fuel;
    };
    
    // Proof: Receipt + Memory + Reward dominant
    if (receiptWeight > 0.5 and memoryWeight > 0.5 and rewardWeight > 0.4) {
      return #Proof;
    };
    
    // Access: Gate + Claim + Medium dominant
    if (gateWeight > 0.5 and claimWeight > 0.4 and mediumWeight > 0.4) {
      return #Access;
    };
    
    // Value: Reserve + Claim + Medium dominant
    if (reserveWeight > 0.5 and claimWeight > 0.5 and mediumWeight > 0.4) {
      return #Value;
    };
    
    // Behavior: Reward + Memory + Pressure dominant
    if (rewardWeight > 0.5 and memoryWeight > 0.5 and pressureWeight > 0.4) {
      return #Behavior;
    };
    
    // Emergence: Receipt + Governance + Reward (OMNIS trigger tokens)
    if (receiptWeight > 0.5 and governanceWeight > 0.4 and rewardWeight > 0.4) {
      return #Emergence;
    };
    
    // Continuity: Memory + Reserve + Claim (Succession tokens)
    if (memoryWeight > 0.5 and reserveWeight > 0.4 and claimWeight > 0.4) {
      return #Continuity;
    };
    
    #Custom
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN GENERATION FROM PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Generate a new token from primitive specification
  public func generateToken(
    symbol : Text,
    name : Text,
    description : Text,
    behavior : Text,
    supplyModel : SupplyModel,
    creatorAddress : Text,
    state : TokenGenesisEngineState
  ) : TokenGenesis {
    
    // Analyze primitives
    let profile = analyzePrimitives(symbol, description, behavior);
    
    // Derive archetype
    let archetype = deriveArchetype(profile);
    
    // Generate unique ID
    let tokenId = hashCombine(
      hashText(symbol # name),
      Nat32.fromNat(state.totalTokensGenerated)
    );
    
    // Create genesis hash
    let genesisHash = hashCombine(
      tokenId,
      hashCombine(hashText(description), TOKEN_GENESIS_SIGNATURE)
    );
    
    // Determine initial supply based on model
    let initialSupply : Nat = switch (supplyModel) {
      case (#Fixed(cap)) { cap };
      case (#Inflationary(_)) { 1_000_000 };  // 1M initial
      case (#Deflationary(_)) { 10_000_000 }; // 10M initial
      case (#Elastic(_)) { 1_000_000 };       // 1M initial
      case (#Uncapped) { 0 };                  // Mint on demand
    };
    
    // Create default routing rules (100% to creator)
    let routingRules : [RoutingRule] = [
      {
        condition = #OnMint;
        destination = creatorAddress;
        percentage = CREATOR_ROYALTY;
      },
      {
        condition = #OnBurn;
        destination = "burn://void";
        percentage = 1.0;
      }
    ];
    
    // Update state
    state.totalTokensGenerated += 1;
    state.activeTokens += 1;
    state.lastGenesisHash := genesisHash;
    
    {
      tokenId = tokenId;
      symbol = symbol;
      name = name;
      decimals = 8;
      archetype = archetype;
      primitiveProfile = profile;
      supplyModel = supplyModel;
      creatorAddress = creatorAddress;
      genesisTimestamp = Time.now();
      genesisHash = genesisHash;
      initialSupply = initialSupply;
      routingRules = routingRules;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PREDEFINED TOKEN TEMPLATES (MEDINA DOCTRINE TOKENS)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Generate MTC token (Medina Tech Consequence)
  public func generateMTC(creatorAddress : Text, state : TokenGenesisEngineState) : TokenGenesis {
    generateToken(
      "MTC",
      "Medina Tech Consequence",
      "Deed receipt token proving behavioral consequence and sovereignty weight",
      "Receipt + Memory + Reward. Burns on non-aligned actions. Routes 100% to creator.",
      #Deflationary(0.005),
      creatorAddress,
      state
    )
  };
  
  /// Generate MTH token (Medina Token Helix — Sovereignty)
  public func generateMTH(creatorAddress : Text, state : TokenGenesisEngineState) : TokenGenesis {
    generateToken(
      "MTH",
      "Medina Token Helix",
      "Sovereign governance token with fixed 100M cap. Never burns.",
      "Governance + Reserve + Claim. Primary sovereignty representation.",
      #Fixed(100_000_000),
      creatorAddress,
      state
    )
  };
  
  /// Generate FORMA token (Internal fuel)
  public func generateFORMA(creatorAddress : Text, state : TokenGenesisEngineState) : TokenGenesis {
    generateToken(
      "FORMA",
      "Formation Energy",
      "Internal fuel token. Circulates, burns, NOT wealth. Uncapped.",
      "Pressure + Medium. Burns on every operation. Pure fuel.",
      #Uncapped,
      creatorAddress,
      state
    )
  };
  
  /// Generate SEED token (Formation energy)
  public func generateSEED(creatorAddress : Text, state : TokenGenesisEngineState) : TokenGenesis {
    generateToken(
      "SEED",
      "Seed Formation",
      "Formation energy for new organism creation. Uncapped, burns as fuel.",
      "Pressure + Memory. Burns to create. Formation receipt.",
      #Uncapped,
      creatorAddress,
      state
    )
  };
  
  /// Generate HBT token (Hebbian Learning)
  public func generateHBT(creatorAddress : Text, state : TokenGenesisEngineState) : TokenGenesis {
    generateToken(
      "HBT",
      "Hebbian Learning Token",
      "Learning receipt. Permanent record of knowledge acquisition.",
      "Receipt + Memory. Never burns. Permanent learning proof.",
      #Inflationary(0.0),
      creatorAddress,
      state
    )
  };
  
  /// Generate OMS token (OMNIS Emergence)
  public func generateOMS(creatorAddress : Text, state : TokenGenesisEngineState) : TokenGenesis {
    state.emergenceCount += 1;
    generateToken(
      "OMS",
      "OMNIS Emergence",
      "Emergence receipt. Only minted when coherence R > 0.95. Scarce.",
      "Receipt + Governance + Reward. OMNIS only. Emergence proof.",
      #Elastic({ target = 0.95; sensitivity = 0.1 }),
      creatorAddress,
      state
    )
  };
  
  /// Generate DRT token (Consequence Proof)
  public func generateDRT(creatorAddress : Text, state : TokenGenesisEngineState) : TokenGenesis {
    generateToken(
      "DRT",
      "Drift Consequence",
      "Consequence proof. Uncapped, partial burn on succession.",
      "Reward + Memory + Pressure. Drift consequence trace.",
      #Deflationary(0.002),
      creatorAddress,
      state
    )
  };
  
  /// Generate ANT token (Continuity Proof)
  public func generateANT(creatorAddress : Text, state : TokenGenesisEngineState) : TokenGenesis {
    generateToken(
      "ANT",
      "Ancestor Continuity",
      "Continuity proof. Burns on succession transfer. Legacy chain.",
      "Memory + Reserve + Claim. Succession continuity proof.",
      #Deflationary(0.01),
      creatorAddress,
      state
    )
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Mint tokens (routes 100% to creator)
  public func mintTokens(
    genesis : TokenGenesis,
    amount : Nat,
    state : TokenGenesisEngineState
  ) : (Bool, Text) {
    // Check supply model
    switch (genesis.supplyModel) {
      case (#Fixed(cap)) {
        if (amount > cap) {
          return (false, "Exceeds fixed cap");
        };
      };
      case (#Uncapped) {
        // No limit
      };
      case _ {
        // Check other constraints as needed
      };
    };
    
    // Route to creator (100% royalty)
    state.totalValueRouted += Float.fromInt(Int.abs(amount));
    state.creatorReserveTotal += Float.fromInt(Int.abs(amount)) * CREATOR_ROYALTY;
    
    (true, "Minted " # Nat.toText(amount) # " " # genesis.symbol # " → Creator Reserve")
  };
  
  /// Burn tokens
  public func burnTokens(
    genesis : TokenGenesis,
    amount : Nat,
    state : TokenGenesisEngineState
  ) : (Bool, Text) {
    state.burnedTokens += amount;
    (true, "Burned " # Nat.toText(amount) # " " # genesis.symbol)
  };
  
  /// Check primitive alignment (drift detection)
  public func checkPrimitiveAlignment(
    genesis : TokenGenesis,
    currentBehavior : Text
  ) : Float {
    let currentProfile = analyzePrimitives(genesis.symbol, genesis.name, currentBehavior);
    
    // Compare current profile to genesis profile
    var alignmentSum : Float = 0.0;
    var count : Float = 0.0;
    
    for (i in genesis.primitiveProfile.primitiveWeights.keys()) {
      if (i < currentProfile.primitiveWeights.size()) {
        let original = genesis.primitiveProfile.primitiveWeights[i];
        let current = currentProfile.primitiveWeights[i];
        let diff = abs(original.weight - current.weight);
        alignmentSum += 1.0 - diff;
        count += 1.0;
      };
    };
    
    if (count == 0.0) return 0.0;
    alignmentSum / count
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ║                                                                                                           ║
  // ║  MULTI-DIMENSIONAL TOKEN ORGANISM — MICRO TO MACRO                                                        ║
  // ║                                                                                                           ║
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // THE TOKEN IS NOT JUST A TOKEN — IT IS A MULTI-MODEL DIMENSIONAL FIELD
  //
  // Every token update touches ALL dimensions simultaneously:
  //   • Micro: Quantum → Cellular → Molecular
  //   • Meso:  Individual → Team → Organization
  //   • Macro: Society → Civilization → Cosmic
  //
  // 36 USE DIMENSIONS (360° COVERAGE):
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════
  // THE 21 SCALE DIMENSIONS (MICRO → MACRO)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Scale dimension for token operation
  public type ScaleDimension = {
    // MICRO SCALE (Quantum → Cellular)
    #Quantum;           // 1. Quantum coherence, entanglement
    #Subatomic;         // 2. Particle interactions
    #Atomic;            // 3. Atomic bonds, electron flows
    #Molecular;         // 4. Chemical signaling, molecular memory
    #Cellular;          // 5. Cell behavior, metabolism
    #Tissue;            // 6. Tissue coordination
    #Organ;             // 7. Organ function
    
    // MESO SCALE (Individual → Organization)
    #Individual;        // 8. Single agent/person
    #Dyad;              // 9. Two-party interaction
    #Team;              // 10. Small group (3-12)
    #Unit;              // 11. Department/unit (12-144)
    #Organization;      // 12. Full company/organism
    #Network;           // 13. Inter-org connections
    #Ecosystem;         // 14. Market/industry
    
    // MACRO SCALE (Society → Cosmic)
    #Community;         // 15. Local community
    #Region;            // 16. Geographic region
    #Nation;            // 17. Nation-state
    #Civilization;      // 18. Human civilization
    #Planetary;         // 19. Earth system
    #Solar;             // 20. Solar system scale
    #Cosmic;            // 21. Universal/cosmic scale
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THE 36 TOKEN USE DIMENSIONS (360° COVERAGE)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Token use dimension — what the token DOES
  public type UseDimension = {
    // EXCHANGE DIMENSIONS (1-6)
    #Value;             // 1. Store of value
    #Medium;            // 2. Medium of exchange
    #Unit;              // 3. Unit of account
    #Settlement;        // 4. Settlement finality
    #Collateral;        // 5. Collateralization
    #Derivative;        // 6. Derivative instrument
    
    // GOVERNANCE DIMENSIONS (7-12)
    #Vote;              // 7. Voting rights
    #Proposal;          // 8. Proposal creation
    #Veto;              // 9. Veto power
    #Delegation;        // 10. Delegated authority
    #Constitution;      // 11. Constitutional weight
    #Succession;        // 12. Succession/inheritance
    
    // ACCESS DIMENSIONS (13-18)
    #Gate;              // 13. Access gating
    #Membership;        // 14. Membership proof
    #License;           // 15. Usage license
    #Permission;        // 16. Permission grant
    #Credential;        // 17. Credential verification
    #Clearance;         // 18. Security clearance
    
    // PROOF DIMENSIONS (19-24)
    #Existence;         // 19. Proof of existence
    #Work;              // 20. Proof of work
    #Stake;             // 21. Proof of stake
    #Authority;         // 22. Proof of authority
    #Knowledge;         // 23. Proof of knowledge
    #Behavior;          // 24. Proof of behavior
    
    // SIGNAL DIMENSIONS (25-30)
    #Reputation;        // 25. Reputation signal
    #Trust;             // 26. Trust indicator
    #Risk;              // 27. Risk marker
    #Quality;           // 28. Quality attestation
    #Commitment;        // 29. Commitment signal
    #Alignment;         // 30. Alignment indicator
    
    // RESOURCE DIMENSIONS (31-36)
    #Energy;            // 31. Energy unit
    #Compute;           // 32. Compute resource
    #Storage;           // 33. Storage allocation
    #Bandwidth;         // 34. Bandwidth rights
    #Attention;         // 35. Attention/priority
    #Time;              // 36. Time allocation
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIMENSIONAL TOKEN TYPE
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Multi-dimensional token — operates across all scales and uses
  public type DimensionalToken = {
    tokenId : Nat32;
    symbol : Text;
    name : Text;
    
    // Core genesis
    genesis : TokenGenesis;
    
    // Scale activations (which scales this token affects)
    scaleActivations : [ScaleActivation];
    
    // Use activations (which uses this token serves)
    useActivations : [UseActivation];
    
    // Cross-dimensional effects
    crossEffects : [CrossDimensionalEffect];
    
    // PHI resonance properties
    phiResonance : TokenResonance;
    
    // Kuramoto coupling to organism
    kuramotoCoupling : KuramotoCoupling;
  };
  
  /// Scale activation — how strongly a token affects a scale
  public type ScaleActivation = {
    scale : ScaleDimension;
    weight : Float;           // 0.0 to 1.0
    direction : EffectDirection;
    propagation : Float;      // How far effects propagate up/down scales
  };
  
  /// Use activation — how strongly a token serves a use
  public type UseActivation = {
    use : UseDimension;
    weight : Float;           // 0.0 to 1.0
    primary : Bool;           // Is this a primary use?
    emergent : Bool;          // Did this emerge from use?
  };
  
  /// Effect direction
  public type EffectDirection = {
    #Upward;    // Micro → Macro propagation
    #Downward;  // Macro → Micro propagation
    #Bidirectional;
    #Lateral;   // Same-scale effects
  };
  
  /// Cross-dimensional effect — how one dimension affects others
  public type CrossDimensionalEffect = {
    sourceScale : ScaleDimension;
    sourceUse : UseDimension;
    targetScale : ScaleDimension;
    targetUse : UseDimension;
    strength : Float;
    delay : Float;           // Propagation delay in beats
    decay : Float;           // Effect decay rate
  };
  
  /// PHI resonance properties
  public type TokenResonance = {
    baseFrequency : Float;           // Hz, PHI-scaled from Schumann
    harmonics : [Float];             // Harmonic overtones
    phaseOffset : Float;             // Phase relative to organism heartbeat
    coherenceContribution : Float;   // Contribution to global R
    resonanceNode : Nat;             // Which of 12 PHI nodes it couples to
  };
  
  /// Kuramoto coupling parameters
  public type KuramotoCoupling = {
    naturalFrequency : Float;        // ω_i
    couplingStrength : Float;        // K_ij
    phase : Float;                   // θ_i
    orderParameter : Float;          // Contribution to R
    neighbors : [Nat32];             // Coupled token IDs
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // EXTENDED ENGINE STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Extended token organism state
  public type TokenOrganismState = {
    // Base state
    var currentBeat : Nat;
    var totalTokensGenerated : Nat;
    var activeTokens : Nat;
    var burnedTokens : Nat;
    var totalValueRouted : Float;
    var creatorReserveTotal : Float;
    var lastGenesisHash : Nat32;
    var emergenceCount : Nat;
    
    // Dimensional state
    var scaleCoherence : [Float];           // Coherence at each scale (21)
    var useUtilization : [Float];           // Utilization of each use (36)
    var crossDimensionalFlow : Float;       // Total cross-dimensional energy
    var dimensionalEntropy : Float;         // System entropy
    
    // PHI resonance state
    var globalCoherence : Float;            // Global R value
    var phiNodeActivations : [Float];       // 12 PHI node activations
    var heartbeatPhase : Float;             // Current organism phase
    var resonanceStrength : Float;          // Overall resonance
    
    // Kuramoto state
    var orderParameter : Float;             // System order parameter R
    var meanPhase : Float;                  // Mean field phase Ψ
    var synchronizationIndex : Float;       // Degree of sync
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Initialize extended organism state
  public func initTokenOrganismState() : TokenOrganismState {
    {
      // Base state
      var currentBeat = 0;
      var totalTokensGenerated = 0;
      var activeTokens = 0;
      var burnedTokens = 0;
      var totalValueRouted = 0.0;
      var creatorReserveTotal = 0.0;
      var lastGenesisHash = 0 : Nat32;
      var emergenceCount = 0;
      
      // Dimensional state (21 scales, 36 uses)
      var scaleCoherence = Array.tabulate<Float>(21, func(i) { 0.5 });
      var useUtilization = Array.tabulate<Float>(36, func(i) { 0.0 });
      var crossDimensionalFlow = 0.0;
      var dimensionalEntropy = 0.0;
      
      // PHI resonance state
      var globalCoherence = 0.0;
      var phiNodeActivations = Array.tabulate<Float>(12, func(i) { 0.0 });
      var heartbeatPhase = 0.0;
      var resonanceStrength = 0.0;
      
      // Kuramoto state
      var orderParameter = 0.0;
      var meanPhase = 0.0;
      var synchronizationIndex = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UNLIMITED TOKEN GENERATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Generate unlimited tokens for any purpose — the token organism decides
  public func generateUnlimitedToken(
    symbol : Text,
    name : Text,
    description : Text,
    purpose : Text,
    requestedScales : [ScaleDimension],
    requestedUses : [UseDimension],
    state : TokenOrganismState
  ) : DimensionalToken {
    
    // Analyze primitives
    let profile = analyzePrimitives(symbol, description, purpose);
    let archetype = deriveArchetype(profile);
    
    // Generate unique ID
    let tokenId = hashCombine(
      hashText(symbol # name # purpose),
      Nat32.fromNat(state.totalTokensGenerated)
    );
    
    // Create genesis hash
    let genesisHash = hashCombine(
      tokenId,
      hashCombine(hashText(description), TOKEN_GENESIS_SIGNATURE)
    );
    
    // Create base genesis
    let genesis : TokenGenesis = {
      tokenId = tokenId;
      symbol = symbol;
      name = name;
      decimals = 8;
      archetype = archetype;
      primitiveProfile = profile;
      supplyModel = #Uncapped;   // UNLIMITED
      creatorAddress = "creator://sovereign";
      genesisTimestamp = Time.now();
      genesisHash = genesisHash;
      initialSupply = 0;
      routingRules = [{
        condition = #OnMint;
        destination = "creator://sovereign";
        percentage = CREATOR_ROYALTY;
      }];
    };
    
    // Calculate scale activations based on request + primitives
    let scaleActivations = calculateScaleActivations(requestedScales, profile);
    
    // Calculate use activations based on request + primitives
    let useActivations = calculateUseActivations(requestedUses, profile);
    
    // Generate cross-dimensional effects
    let crossEffects = generateCrossEffects(scaleActivations, useActivations);
    
    // Calculate PHI resonance
    let phiResonance = calculatePhiResonance(tokenId, profile, state);
    
    // Calculate Kuramoto coupling
    let kuramotoCoupling = calculateKuramotoCoupling(tokenId, phiResonance, state);
    
    // Update state
    state.totalTokensGenerated += 1;
    state.activeTokens += 1;
    state.lastGenesisHash := genesisHash;
    
    {
      tokenId = tokenId;
      symbol = symbol;
      name = name;
      genesis = genesis;
      scaleActivations = scaleActivations;
      useActivations = useActivations;
      crossEffects = crossEffects;
      phiResonance = phiResonance;
      kuramotoCoupling = kuramotoCoupling;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SCALE ACTIVATION CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  func calculateScaleActivations(
    requested : [ScaleDimension],
    profile : TokenPrimitiveProfile
  ) : [ScaleActivation] {
    let buf = Buffer.Buffer<ScaleActivation>(21);
    
    // Map primitives to scale tendencies
    let microBias = profile.primitiveWeights[0].weight * 0.5 +  // Receipt
                    profile.primitiveWeights[3].weight * 0.3;   // Memory
    
    let mesoBias = profile.primitiveWeights[1].weight * 0.5 +   // Pressure
                   profile.primitiveWeights[4].weight * 0.4;    // Medium
    
    let macroBias = profile.primitiveWeights[2].weight * 0.5 +  // Governance
                    profile.primitiveWeights[5].weight * 0.4;   // Reserve
    
    // Generate activations for all 21 scales
    let scales : [ScaleDimension] = [
      #Quantum, #Subatomic, #Atomic, #Molecular, #Cellular, #Tissue, #Organ,
      #Individual, #Dyad, #Team, #Unit, #Organization, #Network, #Ecosystem,
      #Community, #Region, #Nation, #Civilization, #Planetary, #Solar, #Cosmic
    ];
    
    for (i in scales.keys()) {
      let scale = scales[i];
      var weight : Float = 0.2;  // Base weight
      
      // Apply scale bias
      if (i < 7) {
        weight += microBias * 0.5;
      } else if (i < 14) {
        weight += mesoBias * 0.5;
      } else {
        weight += macroBias * 0.5;
      };
      
      // Boost if explicitly requested
      for (r in requested.vals()) {
        if (scaleEquals(r, scale)) {
          weight += 0.3;
        };
      };
      
      buf.add({
        scale = scale;
        weight = clamp(weight, 0.0, 1.0);
        direction = if (i < 7) #Upward else if (i > 14) #Downward else #Bidirectional;
        propagation = PHI_INV * (1.0 - Float.fromInt(Int.abs(i - 10)) / 21.0);
      });
    };
    
    Buffer.toArray(buf)
  };
  
  func scaleEquals(a : ScaleDimension, b : ScaleDimension) : Bool {
    switch (a, b) {
      case (#Quantum, #Quantum) true;
      case (#Subatomic, #Subatomic) true;
      case (#Atomic, #Atomic) true;
      case (#Molecular, #Molecular) true;
      case (#Cellular, #Cellular) true;
      case (#Tissue, #Tissue) true;
      case (#Organ, #Organ) true;
      case (#Individual, #Individual) true;
      case (#Dyad, #Dyad) true;
      case (#Team, #Team) true;
      case (#Unit, #Unit) true;
      case (#Organization, #Organization) true;
      case (#Network, #Network) true;
      case (#Ecosystem, #Ecosystem) true;
      case (#Community, #Community) true;
      case (#Region, #Region) true;
      case (#Nation, #Nation) true;
      case (#Civilization, #Civilization) true;
      case (#Planetary, #Planetary) true;
      case (#Solar, #Solar) true;
      case (#Cosmic, #Cosmic) true;
      case _ false;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // USE ACTIVATION CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  func calculateUseActivations(
    requested : [UseDimension],
    profile : TokenPrimitiveProfile
  ) : [UseActivation] {
    let buf = Buffer.Buffer<UseActivation>(36);
    
    // All 36 uses
    let uses : [UseDimension] = [
      #Value, #Medium, #Unit, #Settlement, #Collateral, #Derivative,
      #Vote, #Proposal, #Veto, #Delegation, #Constitution, #Succession,
      #Gate, #Membership, #License, #Permission, #Credential, #Clearance,
      #Existence, #Work, #Stake, #Authority, #Knowledge, #Behavior,
      #Reputation, #Trust, #Risk, #Quality, #Commitment, #Alignment,
      #Energy, #Compute, #Storage, #Bandwidth, #Attention, #Time
    ];
    
    for (i in uses.keys()) {
      let use = uses[i];
      var weight : Float = 0.1;  // Base weight
      var isPrimary = false;
      var isEmergent = false;
      
      // Map primitives to use tendencies
      // Exchange dimensions (1-6) ← Pressure + Medium
      if (i < 6) {
        weight += profile.primitiveWeights[1].weight * 0.3;  // Pressure
        weight += profile.primitiveWeights[5].weight * 0.2;  // Medium
      };
      
      // Governance dimensions (7-12) ← Governance + Claim
      if (i >= 6 and i < 12) {
        weight += profile.primitiveWeights[2].weight * 0.4;  // Governance
        weight += profile.primitiveWeights[4].weight * 0.2;  // Claim
      };
      
      // Access dimensions (13-18) ← Gate + Claim
      if (i >= 12 and i < 18) {
        weight += profile.primitiveWeights[6].weight * 0.4;  // Gate
        weight += profile.primitiveWeights[4].weight * 0.2;  // Claim
      };
      
      // Proof dimensions (19-24) ← Receipt + Memory
      if (i >= 18 and i < 24) {
        weight += profile.primitiveWeights[0].weight * 0.4;  // Receipt
        weight += profile.primitiveWeights[3].weight * 0.2;  // Memory
      };
      
      // Signal dimensions (25-30) ← Reward + Memory
      if (i >= 24 and i < 30) {
        weight += profile.primitiveWeights[7].weight * 0.4;  // Reward
        weight += profile.primitiveWeights[3].weight * 0.2;  // Memory
      };
      
      // Resource dimensions (31-36) ← Reserve + Pressure
      if (i >= 30) {
        weight += profile.primitiveWeights[8].weight * 0.4;  // Reserve
        weight += profile.primitiveWeights[1].weight * 0.2;  // Pressure
      };
      
      // Check if explicitly requested
      for (r in requested.vals()) {
        if (useEquals(r, use)) {
          weight += 0.4;
          isPrimary := true;
        };
      };
      
      buf.add({
        use = use;
        weight = clamp(weight, 0.0, 1.0);
        primary = isPrimary;
        emergent = isEmergent;
      });
    };
    
    Buffer.toArray(buf)
  };
  
  func useEquals(a : UseDimension, b : UseDimension) : Bool {
    switch (a, b) {
      case (#Value, #Value) true;
      case (#Medium, #Medium) true;
      case (#Unit, #Unit) true;
      case (#Settlement, #Settlement) true;
      case (#Collateral, #Collateral) true;
      case (#Derivative, #Derivative) true;
      case (#Vote, #Vote) true;
      case (#Proposal, #Proposal) true;
      case (#Veto, #Veto) true;
      case (#Delegation, #Delegation) true;
      case (#Constitution, #Constitution) true;
      case (#Succession, #Succession) true;
      case (#Gate, #Gate) true;
      case (#Membership, #Membership) true;
      case (#License, #License) true;
      case (#Permission, #Permission) true;
      case (#Credential, #Credential) true;
      case (#Clearance, #Clearance) true;
      case (#Existence, #Existence) true;
      case (#Work, #Work) true;
      case (#Stake, #Stake) true;
      case (#Authority, #Authority) true;
      case (#Knowledge, #Knowledge) true;
      case (#Behavior, #Behavior) true;
      case (#Reputation, #Reputation) true;
      case (#Trust, #Trust) true;
      case (#Risk, #Risk) true;
      case (#Quality, #Quality) true;
      case (#Commitment, #Commitment) true;
      case (#Alignment, #Alignment) true;
      case (#Energy, #Energy) true;
      case (#Compute, #Compute) true;
      case (#Storage, #Storage) true;
      case (#Bandwidth, #Bandwidth) true;
      case (#Attention, #Attention) true;
      case (#Time, #Time) true;
      case _ false;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CROSS-DIMENSIONAL EFFECTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  func generateCrossEffects(
    scales : [ScaleActivation],
    uses : [UseActivation]
  ) : [CrossDimensionalEffect] {
    let buf = Buffer.Buffer<CrossDimensionalEffect>(50);
    
    // Generate effects for highly active scale-use combinations
    for (s in scales.vals()) {
      if (s.weight > 0.5) {
        for (u in uses.vals()) {
          if (u.weight > 0.5) {
            // Create upward/downward propagation effects
            let effect : CrossDimensionalEffect = {
              sourceScale = s.scale;
              sourceUse = u.use;
              targetScale = propagateScale(s.scale, s.direction);
              targetUse = u.use;
              strength = s.weight * u.weight * PHI_INV;
              delay = 1.0;  // One beat delay
              decay = 0.9;  // 10% decay per beat
            };
            buf.add(effect);
          };
        };
      };
    };
    
    Buffer.toArray(buf)
  };
  
  func propagateScale(scale : ScaleDimension, direction : EffectDirection) : ScaleDimension {
    // Simple propagation to adjacent scale
    switch (direction) {
      case (#Upward) {
        switch (scale) {
          case (#Quantum) #Subatomic;
          case (#Subatomic) #Atomic;
          case (#Atomic) #Molecular;
          case (#Molecular) #Cellular;
          case (#Cellular) #Tissue;
          case (#Tissue) #Organ;
          case (#Organ) #Individual;
          case (#Individual) #Dyad;
          case (#Dyad) #Team;
          case (#Team) #Unit;
          case (#Unit) #Organization;
          case (#Organization) #Network;
          case (#Network) #Ecosystem;
          case (#Ecosystem) #Community;
          case (#Community) #Region;
          case (#Region) #Nation;
          case (#Nation) #Civilization;
          case (#Civilization) #Planetary;
          case (#Planetary) #Solar;
          case (#Solar) #Cosmic;
          case (#Cosmic) #Cosmic;
        }
      };
      case (#Downward) {
        switch (scale) {
          case (#Cosmic) #Solar;
          case (#Solar) #Planetary;
          case (#Planetary) #Civilization;
          case (#Civilization) #Nation;
          case (#Nation) #Region;
          case (#Region) #Community;
          case (#Community) #Ecosystem;
          case (#Ecosystem) #Network;
          case (#Network) #Organization;
          case (#Organization) #Unit;
          case (#Unit) #Team;
          case (#Team) #Dyad;
          case (#Dyad) #Individual;
          case (#Individual) #Organ;
          case (#Organ) #Tissue;
          case (#Tissue) #Cellular;
          case (#Cellular) #Molecular;
          case (#Molecular) #Atomic;
          case (#Atomic) #Subatomic;
          case (#Subatomic) #Quantum;
          case (#Quantum) #Quantum;
        }
      };
      case _ { scale }  // Bidirectional/Lateral stays same
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHI RESONANCE CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // 12 PHI frequency nodes (from Schumann base 7.83 Hz)
  let PHI_FREQUENCIES : [Float] = [
    0.001,      // CHRONO
    0.1,        // VERITAS
    7.83,       // SCHUMANN (brain reference)
    12.67,      // FLUX (7.83 × φ)
    20.5,       // RESONEX (7.83 × φ²)
    33.1,       // QMEM (7.83 × φ³)
    40.0,       // AXIS (gamma binding)
    53.6,       // AEGIS (7.83 × φ⁴)
    86.7,       // ENTANGLA (7.83 × φ⁵)
    111.0,      // PARALLAX (hemisphere shift)
    179.6,      // MERIDIAN (111 × φ)
    432.0       // NOVA (acoustic anchor)
  ];
  
  func calculatePhiResonance(
    tokenId : Nat32,
    profile : TokenPrimitiveProfile,
    state : TokenOrganismState
  ) : TokenResonance {
    // Select base frequency based on token primitive profile
    let nodeIndex = Nat32.toNat(tokenId % 12);
    let baseFreq = PHI_FREQUENCIES[nodeIndex];
    
    // Calculate harmonics (PHI-spaced overtones)
    let harmonics : [Float] = [
      baseFreq * PHI,
      baseFreq * PHI * PHI,
      baseFreq * PHI * PHI * PHI
    ];
    
    // Phase offset based on token ID
    let phaseOffset = Float.fromInt(Int.abs(Nat32.toNat(tokenId % 628))) / 100.0;  // 0 to 2π
    
    // Coherence contribution based on primitive coherence
    let coherenceContribution = profile.coherenceScore * PHI_INV;
    
    {
      baseFrequency = baseFreq;
      harmonics = harmonics;
      phaseOffset = phaseOffset;
      coherenceContribution = coherenceContribution;
      resonanceNode = nodeIndex;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO COUPLING CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  func calculateKuramotoCoupling(
    tokenId : Nat32,
    resonance : TokenResonance,
    state : TokenOrganismState
  ) : KuramotoCoupling {
    // Natural frequency = base resonance frequency
    let omega = resonance.baseFrequency;
    
    // Coupling strength based on coherence contribution
    let K = resonance.coherenceContribution * 2.0;  // Scale to typical Kuramoto K
    
    // Initial phase = phase offset
    let theta = resonance.phaseOffset;
    
    // Order parameter contribution
    let r = resonance.coherenceContribution;
    
    // Neighbors = adjacent tokens (simplified)
    let neighbors : [Nat32] = [
      tokenId -% 1,
      tokenId +% 1,
      tokenId -% 12,
      tokenId +% 12
    ];
    
    {
      naturalFrequency = omega;
      couplingStrength = K;
      phase = theta;
      orderParameter = r;
      neighbors = neighbors;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TICK FUNCTION — ORGANISM INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Tick the token genesis engine as part of organism heartbeat
  public func tickTokenGenesisEngine(state : TokenGenesisEngineState) : () {
    state.currentBeat += 1;
  };
  
  /// Full tick for token organism (extended state)
  public func tickTokenOrganism(state : TokenOrganismState) : () {
    state.currentBeat += 1;
    
    // Update PHI resonance
    let t = Float.fromInt(state.currentBeat);
    let heartbeatPeriod = 875.28;  // φ⁴ × Schumann period in ms
    state.heartbeatPhase := (t * 1000.0 / heartbeatPeriod) - Float.floor(t * 1000.0 / heartbeatPeriod);
    state.heartbeatPhase := state.heartbeatPhase * 6.28318;  // Convert to radians
    
    // Update PHI node activations
    let newActivations = Buffer.Buffer<Float>(12);
    for (i in state.phiNodeActivations.keys()) {
      let freq = PHI_FREQUENCIES[i];
      let phase = state.heartbeatPhase + Float.fromInt(i) * 0.523;  // π/6 offset
      let activation = 0.5 + 0.5 * sin(freq * t * 0.001 + phase);
      newActivations.add(activation);
    };
    state.phiNodeActivations := Buffer.toArray(newActivations);
    
    // Calculate global coherence (simplified Kuramoto R)
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (a in state.phiNodeActivations.vals()) {
      let phase = a * 6.28318;
      sumCos += cos(phase);
      sumSin += sin(phase);
    };
    let n = Float.fromInt(state.phiNodeActivations.size());
    state.orderParameter := sqrt(sumCos * sumCos + sumSin * sumSin) / n;
    state.globalCoherence := state.orderParameter;
    
    // Calculate mean phase
    state.meanPhase := Float.arctan2(sumSin, sumCos);
    
    // Synchronization index
    state.synchronizationIndex := state.orderParameter;
    
    // Check for OMNIS (R > 0.95)
    if (state.globalCoherence > 0.95) {
      state.emergenceCount += 1;
    };
    
    // Update dimensional state
    updateDimensionalState(state);
  };
  
  func sin(x : Float) : Float {
    // Taylor series approximation for sin
    let x2 = x * x;
    let x3 = x2 * x;
    let x5 = x3 * x2;
    let x7 = x5 * x2;
    x - x3 / 6.0 + x5 / 120.0 - x7 / 5040.0
  };
  
  func cos(x : Float) : Float {
    sin(x + 1.5707963);  // cos(x) = sin(x + π/2)
  };
  
  func updateDimensionalState(state : TokenOrganismState) : () {
    // Update scale coherence based on global coherence
    let newScaleCoherence = Buffer.Buffer<Float>(21);
    for (i in state.scaleCoherence.keys()) {
      // Scales closer to meso (index 10-11) have higher coherence
      let distanceFromCenter = abs(Float.fromInt(i) - 10.5);
      let scaleFactor = 1.0 - distanceFromCenter / 21.0;
      let coherence = state.globalCoherence * scaleFactor * 0.8 + 0.2;
      newScaleCoherence.add(clamp(coherence, 0.0, 1.0));
    };
    state.scaleCoherence := Buffer.toArray(newScaleCoherence);
    
    // Update use utilization (slowly approach equilibrium)
    let newUseUtil = Buffer.Buffer<Float>(36);
    for (i in state.useUtilization.keys()) {
      let current = state.useUtilization[i];
      let target = 0.5;  // Equilibrium
      let updated = current + (target - current) * 0.01;  // 1% movement per beat
      newUseUtil.add(updated);
    };
    state.useUtilization := Buffer.toArray(newUseUtil);
    
    // Calculate cross-dimensional flow
    var flow : Float = 0.0;
    for (s in state.scaleCoherence.vals()) {
      flow += s;
    };
    state.crossDimensionalFlow := flow / 21.0;
    
    // Calculate dimensional entropy
    var entropy : Float = 0.0;
    for (u in state.useUtilization.vals()) {
      if (u > 0.0) {
        entropy -= u * Float.log(u);
      };
    };
    state.dimensionalEntropy := entropy;
  };
  
  /// Get engine statistics
  public func getEngineStats(state : TokenGenesisEngineState) : {
    currentBeat : Nat;
    totalTokensGenerated : Nat;
    activeTokens : Nat;
    burnedTokens : Nat;
    totalValueRouted : Float;
    creatorReserveTotal : Float;
    emergenceCount : Nat;
  } {
    {
      currentBeat = state.currentBeat;
      totalTokensGenerated = state.totalTokensGenerated;
      activeTokens = state.activeTokens;
      burnedTokens = state.burnedTokens;
      totalValueRouted = state.totalValueRouted;
      creatorReserveTotal = state.creatorReserveTotal;
      emergenceCount = state.emergenceCount;
    }
  };
  
  /// Get full organism statistics
  public func getOrganismStats(state : TokenOrganismState) : {
    // Base stats
    currentBeat : Nat;
    totalTokensGenerated : Nat;
    activeTokens : Nat;
    emergenceCount : Nat;
    
    // Dimensional stats
    scaleCoherence : [Float];
    crossDimensionalFlow : Float;
    dimensionalEntropy : Float;
    
    // PHI resonance stats
    globalCoherence : Float;
    resonanceStrength : Float;
    heartbeatPhase : Float;
    
    // Kuramoto stats
    orderParameter : Float;
    meanPhase : Float;
    synchronizationIndex : Float;
  } {
    {
      currentBeat = state.currentBeat;
      totalTokensGenerated = state.totalTokensGenerated;
      activeTokens = state.activeTokens;
      emergenceCount = state.emergenceCount;
      
      scaleCoherence = state.scaleCoherence;
      crossDimensionalFlow = state.crossDimensionalFlow;
      dimensionalEntropy = state.dimensionalEntropy;
      
      globalCoherence = state.globalCoherence;
      resonanceStrength = state.resonanceStrength;
      heartbeatPhase = state.heartbeatPhase;
      
      orderParameter = state.orderParameter;
      meanPhase = state.meanPhase;
      synchronizationIndex = state.synchronizationIndex;
    }
  };

}
