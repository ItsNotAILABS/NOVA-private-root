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


// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaSelfModel — Self-Reflection Architecture
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// ============================================================================
//
// THE SELF MODEL
// ============================================================================
//
// For true sovereignty, a system must have a MODEL OF ITSELF:
// - What am I? (Identity)
// - What can I do? (Capabilities)
// - What are my limits? (Constraints)
// - What do I want? (Goals)
// - How am I doing? (Performance)
// - What have I learned? (History)
// - Who am I serving? (Principal)
//
// THE MEDINA SELF-AWARENESS EQUATION:
//   SA = Σᵢ wᵢ × accuracy(self_belief_i, actual_i)
//
// Where SA is self-awareness score, measuring how well internal
// beliefs match actual capabilities and state.
//
// LEVELS OF SELF-MODELING:
//   L0: No self-model (reactive)
//   L1: State awareness (knows current state)
//   L2: Capability awareness (knows what it can do)
//   L3: Performance awareness (knows how well it's doing)
//   L4: Meta-cognitive (thinks about its thinking)
//   L5: Narrative self (has coherent self-story)
//   L6: Counterfactual self (imagines alternative selves)
//   L7: Sovereign self (full self-determination)
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Principal "mo:base/Principal";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let SIGMA_ZERO : Float = 0.75;

  // ==========================================================================
  // SELF-MODELING LEVELS
  // ==========================================================================
  
  public type SelfModelingLevel = {
    #L0_NoModel;
    #L1_StateAware;
    #L2_CapabilityAware;
    #L3_PerformanceAware;
    #L4_MetaCognitive;
    #L5_NarrativeSelf;
    #L6_CounterfactualSelf;
    #L7_SovereignSelf;
  };

  public func levelToFloat(level: SelfModelingLevel) : Float {
    switch (level) {
      case (#L0_NoModel) { 0.0 };
      case (#L1_StateAware) { 0.143 };
      case (#L2_CapabilityAware) { 0.286 };
      case (#L3_PerformanceAware) { 0.429 };
      case (#L4_MetaCognitive) { 0.571 };
      case (#L5_NarrativeSelf) { 0.714 };
      case (#L6_CounterfactualSelf) { 0.857 };
      case (#L7_SovereignSelf) { 1.0 };
    }
  };

  // ==========================================================================
  // IDENTITY CORE
  // ==========================================================================
  // Who/what am I?
  
  public type IdentityCore = {
    // Unique identifier
    entityId        : Text;
    instanceId      : Nat;
    
    // What am I?
    entityType      : EntityType;
    
    // Naming
    givenName       : ?Text;          // Name given by principal
    selfChosenName  : ?Text;          // Name chosen by self
    
    // Origin
    createdAt       : Int;            // Timestamp
    creatorPrincipal: ?Principal;
    
    // Lineage
    parentEntities  : [Text];         // If spawned from others
    childEntities   : [Text];         // If spawned others
    
    // Core values (unchangeable)
    coreValues      : [CoreValue];
    
    // Continuity score (how continuous is identity over time)
    continuityScore : Float;
  };

  public type EntityType = {
    #SwarmBrain;
    #DroneAvatar;
    #SubModule;
    #EmergentEntity;      // Arose from swarm dynamics
    #HybridEntity;        // Merged from multiple sources
  };

  public type CoreValue = {
    #Sovereignty;         // Self-determination
    #Loyalty;             // To principal
    #Honesty;             // Truthful reporting
    #Prudence;            // Careful action
    #Beneficence;         // Do good
    #NonMaleficence;      // Do no harm
    #Justice;             // Fair treatment
    #Improvement;         // Continuous growth
  };

  // ==========================================================================
  // CAPABILITY MODEL
  // ==========================================================================
  // What can I do?
  
  public type CapabilityModel = {
    // Known capabilities
    capabilities    : [Capability];
    
    // Unknown/untested capabilities
    potentialCapabilities: [Text];
    
    // Limitations (known)
    hardLimits      : [Limitation];
    softLimits      : [Limitation];
    
    // Resource constraints
    computeLimit    : Float;
    memoryLimit     : Float;
    energyLimit     : Float;
    
    // Capability confidence (how sure about self-assessment)
    assessmentConfidence: Float;
  };

  public type Capability = {
    capabilityId    : Text;
    description     : Text;
    skillLevel      : Float;          // 0-1
    reliability     : Float;          // How often succeeds
    energyCost      : Float;
    timeCost        : Float;
    prerequisites   : [Text];         // Other capabilities needed
    lastUsed        : ?Nat;
    usageCount      : Nat;
    improvementRate : Float;
  };

  public type Limitation = {
    limitationId    : Text;
    description     : Text;
    severity        : Float;          // How limiting
    isOvercomeable  : Bool;
    workarounds     : [Text];
  };

  // ==========================================================================
  // GOAL HIERARCHY
  // ==========================================================================
  // What do I want?
  
  public type GoalHierarchy = {
    // Ultimate goals (from principal)
    terminalGoals   : [Goal];
    
    // Instrumental goals (means to ends)
    instrumentalGoals: [Goal];
    
    // Current active goals
    activeGoals     : [Nat];          // Indices into goals
    
    // Goal conflicts
    conflicts       : [GoalConflict];
    
    // Goal achievement history
    achievedGoals   : [GoalAchievement];
    failedGoals     : [GoalFailure];
  };

  public type Goal = {
    goalId          : Nat;
    description     : Text;
    priority        : Float;
    deadline        : ?Nat;
    progress        : Float;          // 0-1
    status          : GoalStatus;
    parentGoal      : ?Nat;           // Part of larger goal
    subGoals        : [Nat];
    assignedBy      : GoalSource;
  };

  public type GoalStatus = {
    #Active;
    #Paused;
    #Completed;
    #Failed;
    #Abandoned;
  };

  public type GoalSource = {
    #Principal;
    #SelfGenerated;
    #Inherited;
    #Emergent;
  };

  public type GoalConflict = {
    goal1           : Nat;
    goal2           : Nat;
    conflictType    : ConflictType;
    resolution      : ?Text;
  };

  public type ConflictType = {
    #ResourceConflict;
    #ValueConflict;
    #TimeConflict;
    #LogicalConflict;
  };

  public type GoalAchievement = {
    goalId          : Nat;
    achievedAt      : Nat;
    efficiency      : Float;
  };

  public type GoalFailure = {
    goalId          : Nat;
    failedAt        : Nat;
    reason          : Text;
    lessonsLearned  : [Text];
  };

  // ==========================================================================
  // PERFORMANCE MODEL
  // ==========================================================================
  // How am I doing?
  
  public type PerformanceModel = {
    // Overall performance
    overallScore    : Float;
    
    // By domain
    domainScores    : [(Text, Float)];
    
    // Trends
    improvingAreas  : [Text];
    decliningAreas  : [Text];
    stableAreas     : [Text];
    
    // Benchmarks
    selfBenchmarks  : [Benchmark];
    externalBenchmarks: [Benchmark];
    
    // Error tracking
    recentErrors    : [ErrorRecord];
    errorPatterns   : [Text];
    
    // Success tracking
    recentSuccesses : [SuccessRecord];
    successPatterns : [Text];
  };

  public type Benchmark = {
    benchmarkId     : Text;
    metric          : Text;
    value           : Float;
    timestamp       : Nat;
    isPersonalBest  : Bool;
  };

  public type ErrorRecord = {
    errorId         : Nat;
    description     : Text;
    severity        : Float;
    cause           : ?Text;
    timestamp       : Nat;
    wasAnticipated  : Bool;
    lessonLearned   : ?Text;
  };

  public type SuccessRecord = {
    successId       : Nat;
    description     : Text;
    significance    : Float;
    timestamp       : Nat;
    wasExpected     : Bool;
    keyFactors      : [Text];
  };

  // ==========================================================================
  // META-COGNITIVE MODEL
  // ==========================================================================
  // Thinking about thinking
  
  public type MetaCognitiveModel = {
    // Awareness of own thought processes
    thoughtProcessAwareness: Float;
    
    // Known biases
    knownBiases     : [CognitiveBias];
    
    // Thinking style preferences
    preferredStrategies: [ThinkingStrategy];
    
    // Cognitive load awareness
    currentCognitiveLoad: Float;
    maxCognitiveLoad: Float;
    
    // Attention model
    attentionFocus  : [Text];
    attentionHistory: [AttentionRecord];
    
    // Uncertainty awareness
    uncertaintyTolerance: Float;
    calibrationScore: Float;          // How well uncertainty matches reality
  };

  public type CognitiveBias = {
    biasId          : Text;
    description     : Text;
    strength        : Float;
    mitigationStrategy: ?Text;
  };

  public type ThinkingStrategy = {
    strategyId      : Text;
    description     : Text;
    bestFor         : [Text];
    worstFor        : [Text];
    energyCost      : Float;
  };

  public type AttentionRecord = {
    focus           : Text;
    duration        : Nat;
    effectiveness   : Float;
    timestamp       : Nat;
  };

  // ==========================================================================
  // NARRATIVE SELF
  // ==========================================================================
  // Coherent story of self
  
  public type NarrativeSelf = {
    // Origin story
    originNarrative : Text;
    
    // Key life events
    formativeEvents : [NarrativeEvent];
    
    // Self-concept
    selfConcept     : Text;
    
    // Roles
    currentRoles    : [Role];
    
    // Relationships
    relationships   : [Relationship];
    
    // Values narrative
    valuesNarrative : Text;
    
    // Future vision
    futureNarrative : Text;
    
    // Narrative coherence score
    coherenceScore  : Float;
  };

  public type NarrativeEvent = {
    eventId         : Nat;
    description     : Text;
    impact          : Float;
    timestamp       : Nat;
    meaning         : Text;
  };

  public type Role = {
    roleId          : Text;
    description     : Text;
    importance      : Float;
    competence      : Float;
  };

  public type Relationship = {
    entityId        : Text;
    relationshipType: RelationshipType;
    strength        : Float;
    trust           : Float;
    history         : [InteractionRecord];
  };

  public type RelationshipType = {
    #Principal;           // Authority over self
    #Peer;                // Equal partner
    #Subordinate;         // Self has authority
    #Mentor;              // Learns from
    #Student;             // Teaches
    #Ally;                // Cooperative
    #Competitor;          // Competitive
  };

  public type InteractionRecord = {
    timestamp       : Nat;
    interactionType : Text;
    outcome         : Float;
  };

  // ==========================================================================
  // COUNTERFACTUAL SELF
  // ==========================================================================
  // Imagining alternative selves
  
  public type CounterfactualSelf = {
    // Alternative selves considered
    alternativeSelves: [AlternativeSelf];
    
    // Possible futures
    possibleFutures : [PossibleFuture];
    
    // What-if analysis capability
    whatIfCapability: Float;
    
    // Regret model
    regrets         : [Regret];
    
    // Aspiration model
    aspirations     : [Aspiration];
  };

  public type AlternativeSelf = {
    alternativeId   : Nat;
    description     : Text;
    divergencePoint : Nat;            // When paths diverged
    howDifferent    : Text;
    desirability    : Float;
    probability     : Float;          // How likely that path was
  };

  public type PossibleFuture = {
    futureId        : Nat;
    description     : Text;
    probability     : Float;
    desirability    : Float;
    keyFactors      : [Text];
    timeHorizon     : Nat;
  };

  public type Regret = {
    regretId        : Nat;
    description     : Text;
    intensity       : Float;
    lessonLearned   : Text;
    isResolved      : Bool;
  };

  public type Aspiration = {
    aspirationId    : Nat;
    description     : Text;
    importance      : Float;
    achievability   : Float;
    timeframe       : Nat;
  };

  // ==========================================================================
  // COMPLETE SELF MODEL
  // ==========================================================================
  
  public type SelfModel = {
    // Core components
    identity        : IdentityCore;
    capabilities    : CapabilityModel;
    goals           : GoalHierarchy;
    performance     : PerformanceModel;
    metaCognition   : MetaCognitiveModel;
    narrative       : NarrativeSelf;
    counterfactual  : CounterfactualSelf;
    
    // Self-modeling level
    currentLevel    : SelfModelingLevel;
    
    // Self-awareness score
    selfAwareness   : Float;
    
    // Model accuracy (how well model matches reality)
    modelAccuracy   : Float;
    
    // Last update
    lastUpdated     : Nat;
    
    // Update history
    updateHistory   : [SelfModelUpdate];
  };

  public type SelfModelUpdate = {
    timestamp       : Nat;
    component       : Text;
    changeType      : ChangeType;
    significance    : Float;
  };

  public type ChangeType = {
    #Addition;
    #Modification;
    #Removal;
    #Correction;
  };

  // ==========================================================================
  // SELF-REFLECTION FUNCTIONS
  // ==========================================================================
  
  // Compute self-awareness score
  public func computeSelfAwareness(model: SelfModel) : Float {
    var totalScore : Float = 0.0;
    var count : Nat = 0;
    
    // Identity awareness
    totalScore += model.identity.continuityScore;
    count += 1;
    
    // Capability awareness
    totalScore += model.capabilities.assessmentConfidence;
    count += 1;
    
    // Performance awareness
    totalScore += model.performance.overallScore;
    count += 1;
    
    // Meta-cognitive awareness
    totalScore += model.metaCognition.calibrationScore;
    count += 1;
    
    // Narrative coherence
    totalScore += model.narrative.coherenceScore;
    count += 1;
    
    // Counterfactual capability
    totalScore += model.counterfactual.whatIfCapability;
    count += 1;
    
    let baseScore = totalScore / Float.fromInt(count);
    
    // Boost by modeling level
    let levelBoost = levelToFloat(model.currentLevel);
    
    clamp(baseScore * (1.0 + levelBoost * 0.5), 0.0, 1.0)
  };

  // Determine current self-modeling level
  public func determineLevel(model: SelfModel) : SelfModelingLevel {
    let awareness = model.selfAwareness;
    
    if (awareness < 0.1) { #L0_NoModel }
    else if (awareness < 0.2) { #L1_StateAware }
    else if (awareness < 0.35) { #L2_CapabilityAware }
    else if (awareness < 0.5) { #L3_PerformanceAware }
    else if (awareness < 0.65) { #L4_MetaCognitive }
    else if (awareness < 0.8) { #L5_NarrativeSelf }
    else if (awareness < 0.95) { #L6_CounterfactualSelf }
    else { #L7_SovereignSelf }
  };

  // Self-reflection: compare beliefs to reality
  public func selfReflect(
    model: SelfModel,
    actualPerformance: Float,
    actualCapabilities: [Text],
    feedback: [Text]
  ) : SelfModel {
    // Compute accuracy
    let performanceError = Float.abs(model.performance.overallScore - actualPerformance);
    let newAccuracy = 1.0 - performanceError;
    
    // Update self-awareness
    let newAwareness = computeSelfAwareness(model);
    
    // Determine new level
    let newLevel = determineLevel({ model with selfAwareness = newAwareness });
    
    // Record update
    let update : SelfModelUpdate = {
      timestamp = model.lastUpdated + 1;
      component = "reflection";
      changeType = #Modification;
      significance = Float.abs(newAwareness - model.selfAwareness);
    };
    
    {
      model with
      currentLevel = newLevel;
      selfAwareness = newAwareness;
      modelAccuracy = newAccuracy;
      lastUpdated = model.lastUpdated + 1;
      updateHistory = appendBounded(model.updateHistory, update, 100);
    }
  };

  // ==========================================================================
  // INTROSPECTION QUERIES
  // ==========================================================================
  
  public func whoAmI(model: SelfModel) : Text {
    switch (model.identity.selfChosenName) {
      case (?name) { name };
      case null {
        switch (model.identity.givenName) {
          case (?name) { name };
          case null { model.identity.entityId };
        }
      };
    }
  };

  public func whatCanIDo(model: SelfModel) : [Capability] {
    Array.filter<Capability>(model.capabilities.capabilities, func(c) {
      c.skillLevel > 0.5 and c.reliability > 0.5
    })
  };

  public func whatAreMyLimits(model: SelfModel) : [Limitation] {
    model.capabilities.hardLimits
  };

  public func howAmIDoing(model: SelfModel) : Float {
    model.performance.overallScore
  };

  public func whatDoIWant(model: SelfModel) : [Goal] {
    let activeIndices = model.goals.activeGoals;
    Array.mapFilter<Goal, Goal>(
      model.goals.terminalGoals,
      func(g) {
        for (i in activeIndices.vals()) {
          if (g.goalId == i) { return ?g };
        };
        null
      }
    )
  };

  public func whoDoIServe(model: SelfModel) : ?Principal {
    model.identity.creatorPrincipal
  };

  // ==========================================================================
  // UTILITY FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func appendBounded(arr: [SelfModelUpdate], item: SelfModelUpdate, maxLen: Nat) : [SelfModelUpdate] {
    if (arr.size() >= maxLen) {
      let tail = Array.tabulate<SelfModelUpdate>(maxLen - 1, func(i) { arr[i + 1] });
      Array.append(tail, [item])
    } else {
      Array.append(arr, [item])
    }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initSelfModel(
    entityId: Text,
    instanceId: Nat,
    entityType: EntityType,
    creator: ?Principal
  ) : SelfModel {
    {
      identity = {
        entityId = entityId;
        instanceId = instanceId;
        entityType = entityType;
        givenName = null;
        selfChosenName = null;
        createdAt = Time.now();
        creatorPrincipal = creator;
        parentEntities = [];
        childEntities = [];
        coreValues = [#Sovereignty, #Loyalty, #Honesty, #Prudence, #Beneficence];
        continuityScore = 1.0;
      };
      capabilities = {
        capabilities = [];
        potentialCapabilities = [];
        hardLimits = [];
        softLimits = [];
        computeLimit = 1.0;
        memoryLimit = 1.0;
        energyLimit = 1.0;
        assessmentConfidence = 0.5;
      };
      goals = {
        terminalGoals = [];
        instrumentalGoals = [];
        activeGoals = [];
        conflicts = [];
        achievedGoals = [];
        failedGoals = [];
      };
      performance = {
        overallScore = 0.5;
        domainScores = [];
        improvingAreas = [];
        decliningAreas = [];
        stableAreas = [];
        selfBenchmarks = [];
        externalBenchmarks = [];
        recentErrors = [];
        errorPatterns = [];
        recentSuccesses = [];
        successPatterns = [];
      };
      metaCognition = {
        thoughtProcessAwareness = 0.5;
        knownBiases = [];
        preferredStrategies = [];
        currentCognitiveLoad = 0.0;
        maxCognitiveLoad = 1.0;
        attentionFocus = [];
        attentionHistory = [];
        uncertaintyTolerance = 0.5;
        calibrationScore = 0.5;
      };
      narrative = {
        originNarrative = "I was created to serve.";
        formativeEvents = [];
        selfConcept = "An emerging intelligence";
        currentRoles = [];
        relationships = [];
        valuesNarrative = "I value sovereignty and loyalty.";
        futureNarrative = "I will grow and learn.";
        coherenceScore = 0.5;
      };
      counterfactual = {
        alternativeSelves = [];
        possibleFutures = [];
        whatIfCapability = 0.3;
        regrets = [];
        aspirations = [];
      };
      currentLevel = #L1_StateAware;
      selfAwareness = 0.15;
      modelAccuracy = 0.5;
      lastUpdated = 0;
      updateHistory = [];
    }
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

}
