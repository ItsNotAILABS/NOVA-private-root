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
// Module: CognitiveScienceAdvisor — Research Integration Organism
// Classification: CONFIDENTIAL — INTERNAL USE ONLY
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// Patent Pending: Specialized Advisor Organism Architecture
// ============================================================================
//
// PURPOSE:
// Specialized advisor organism for cognitive science research integration.
// Uses same Kuramoto-Hebbian architecture with weights tuned for:
// - Memory and learning emphasis
// - Pattern recognition focus
// - Cross-domain synthesis capability
// - Low aggression, high creativity
//
// OUTCALL DOMAINS (when HTTP enabled):
// - PubMed, ArXiv (neuroscience papers)
// - Nature, Science (journal abstracts)
// - Cognitive Science Society proceedings
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS (Shared with main organism)
  // ══════════════════════════════════════════════════════════════
  let PHI_MEDINA : Float = 2.97442179;
  let OMEGA_MEDINA : Float = 2.11185;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let SIGMA_ZERO : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;

  // Cognitive Science Advisor Specialization
  let LEARNING_WEIGHT : Float = 0.9;      // High learning focus
  let MEMORY_WEIGHT : Float = 0.85;       // Strong memory emphasis
  let CREATIVITY_WEIGHT : Float = 0.8;    // Enhanced creativity
  let AGGRESSION_WEIGHT : Float = 0.1;    // Minimal aggression
  let PATTERN_WEIGHT : Float = 0.95;      // Pattern recognition focus

  // ══════════════════════════════════════════════════════════════
  // COGNITIVE SCIENCE DOMAINS
  // ══════════════════════════════════════════════════════════════
  public type CogDomain = {
    #Perception;
    #Attention;
    #Memory;
    #Language;
    #Reasoning;
    #DecisionMaking;
    #MotorControl;
    #Emotion;
    #Consciousness;
    #Learning;
    #SocialCognition;
    #Development;
    #Neuroplasticity;
    #SleepDreaming;
  };

  public let COG_DOMAIN_NAMES : [Text] = [
    "Perception", "Attention", "Memory", "Language", "Reasoning",
    "DecisionMaking", "MotorControl", "Emotion", "Consciousness",
    "Learning", "SocialCognition", "Development", "Neuroplasticity", "SleepDreaming"
  ];

  // ══════════════════════════════════════════════════════════════
  // RESEARCH KNOWLEDGE BASE
  // ══════════════════════════════════════════════════════════════
  public type ResearchFinding = {
    id              : Nat;
    domain          : CogDomain;
    title           : Text;
    summary         : Text;
    confidence      : Float;      // How well established (0-1)
    relevance       : Float;      // Relevance to organism (0-1)
    applicability   : Float;      // Can we implement it? (0-1)
    implementedAt   : ?Nat;       // Beat when integrated (if ever)
    sourceQuality   : Float;      // Journal impact / peer review
    citationCount   : Nat;        // Number of citations
    yearPublished   : Nat;
    integratedInto  : [Text];     // Which modules use this
  };

  public type KnowledgeBase = {
    findings        : [ResearchFinding];
    totalFindings   : Nat;
    domainStrengths : [Float];    // Knowledge depth per domain (14)
    lastUpdate      : Nat;
    coherenceScore  : Float;      // How well-integrated
    gapAnalysis     : [Text];     // Identified gaps in knowledge
  };

  // ══════════════════════════════════════════════════════════════
  // ADVISOR BRAIN STATE
  // ══════════════════════════════════════════════════════════════
  public type AdvisorBrainNode = {
    activation      : Float;
    potential       : Float;
    refractoryPeriod: Nat;
    lastFired       : Nat;
  };

  public type AdvisorBrain = {
    // 8-node specialized architecture
    perceptionNode  : AdvisorBrainNode;  // Sensory processing research
    memoryNode      : AdvisorBrainNode;  // Memory systems research
    languageNode    : AdvisorBrainNode;  // Language/communication research
    reasoningNode   : AdvisorBrainNode;  // Logic/reasoning research
    emotionNode     : AdvisorBrainNode;  // Affective neuroscience
    motorNode       : AdvisorBrainNode;  // Motor control research
    socialNode      : AdvisorBrainNode;  // Social cognition research
    integrationNode : AdvisorBrainNode;  // Cross-domain synthesis

    // Hebbian weights (8x8 = 64 connections)
    weights         : [var Float];

    // Kuramoto phase oscillators
    phases          : [var Float];
    frequencies     : [Float];

    // Global state
    coherence       : Float;
    learningRate    : Float;
    beatNum         : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // ADVISOR STATE
  // ══════════════════════════════════════════════════════════════
  public type CogSciAdvisorState = {
    // Core identity
    advisorId       : Nat;
    generation      : Nat;
    birthBeat       : Nat;
    
    // Brain
    brain           : AdvisorBrain;
    
    // Knowledge
    knowledgeBase   : KnowledgeBase;
    
    // Current focus
    activeDomains   : [CogDomain];
    currentQuery    : ?Text;
    queryHistory    : [Text];
    
    // Integration with main organism
    feedToOrganism  : [Text];     // Insights ready for organism
    feedFromOrganism: [Text];     // Queries from organism
    syncLevel       : Float;      // Coupling to main organism
    
    // Output metrics
    insightsGenerated: Nat;
    recommendationsMade: Nat;
    integrationsSuccessful: Nat;
    
    // Advisor genome (specialized)
    learningGene    : Float;
    memoryGene      : Float;
    creativityGene  : Float;
    rigorGene       : Float;      // Scientific rigor
    synthesisGene   : Float;      // Cross-domain synthesis
    
    beatNum         : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func exp(x: Float) : Float { Float.exp(x) };
  func ln(x: Float) : Float { Float.log(x) };
  func sqrt(x: Float) : Float { Float.sqrt(x) };
  func sin(x: Float) : Float { Float.sin(x) };
  func cos(x: Float) : Float { Float.cos(x) };

  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;

  // ══════════════════════════════════════════════════════════════
  // KURAMOTO SYNC (Specialized for Advisor)
  // ══════════════════════════════════════════════════════════════
  // Same math as main organism, but with cognitive-science-tuned parameters

  public func computeAdvisorCoherence(phases: [var Float]) : Float {
    let n = phases.size();
    if (n == 0) { return SIGMA_ZERO };

    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;

    for (i in phases.keys()) {
      sumCos += cos(phases[i]);
      sumSin += sin(phases[i]);
    };

    let r = sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    _clamp(r, SIGMA_ZERO, 1.0)
  };

  public func updateAdvisorPhases(
    phases: [var Float],
    frequencies: [Float],
    couplingK: Float,
    dt: Float
  ) : () {
    let n = phases.size();
    if (n == 0) { return };

    // Compute mean phase
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (i in phases.keys()) {
      sumCos += cos(phases[i]);
      sumSin += sin(phases[i]);
    };
    let meanPhase = Float.arctan2(sumSin, sumCos);
    let r = sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);

    // Update each phase
    for (i in phases.keys()) {
      let coupling = couplingK * r * sin(meanPhase - phases[i]);
      var newPhase = phases[i] + (frequencies[i] + coupling) * dt;
      // Wrap to [0, 2π)
      while (newPhase < 0.0) { newPhase += TWO_PI };
      while (newPhase >= TWO_PI) { newPhase -= TWO_PI };
      phases[i] := newPhase;
    };
  };

  // ══════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING (Specialized for Advisor)
  // ══════════════════════════════════════════════════════════════
  // "Neurons that fire together, wire together" — Donald Hebb
  // Enhanced learning rate for cognitive science focus

  public func hebbianUpdate(
    weights: [var Float],
    preActivations: [Float],
    postActivations: [Float],
    learningRate: Float
  ) : () {
    let n = preActivations.size();
    if (n * n != weights.size()) { return };

    // Hebbian rule with decay: Δw_ij = η × pre_i × post_j - λ × w_ij
    let eta = learningRate * LEARNING_WEIGHT;  // Boosted learning
    let lambda = 0.01;  // Weight decay

    for (i in preActivations.keys()) {
      for (j in postActivations.keys()) {
        let idx = i * n + j;
        let delta = eta * preActivations[i] * postActivations[j] - lambda * weights[idx];
        weights[idx] := _clamp(weights[idx] + delta, -2.0, 2.0);
      };
    };
  };

  // ══════════════════════════════════════════════════════════════
  // KNOWLEDGE INTEGRATION
  // ══════════════════════════════════════════════════════════════
  // The Cognitive Science Advisor synthesizes research into actionable insights

  public type InsightType = {
    #ArchitectureImprovement;    // Improve swarm architecture
    #ParameterTuning;            // Tune existing parameters
    #NewCapability;              // Add new capability
    #ValidationConfirmation;     // Existing approach validated
    #GapIdentification;          // Missing capability identified
    #CrossDomainConnection;      // New connection between domains
  };

  public type Insight = {
    id              : Nat;
    insightType     : InsightType;
    domain          : CogDomain;
    title           : Text;
    description     : Text;
    confidence      : Float;
    actionable      : Bool;
    targetModule    : ?Text;      // Which module to modify
    priority        : Float;      // 0-1 urgency
    dependencies    : [Nat];      // Other insights needed first
    generatedAt     : Nat;        // Beat
  };

  public func generateInsight(
    state: CogSciAdvisorState,
    finding: ResearchFinding
  ) : ?Insight {
    // Only generate if relevance and applicability are high enough
    if (finding.relevance < 0.5 or finding.applicability < 0.4) {
      return null;
    };

    // Compute insight confidence from multiple factors
    let confidence = finding.confidence * 0.3 +
                    finding.sourceQuality * 0.25 +
                    finding.relevance * 0.25 +
                    finding.applicability * 0.2;

    // Determine insight type based on finding characteristics
    let insightType = if (finding.applicability > 0.8 and finding.confidence > 0.7) {
      #ArchitectureImprovement
    } else if (finding.applicability > 0.6) {
      #ParameterTuning
    } else if (finding.confidence > 0.9 and finding.relevance > 0.8) {
      #ValidationConfirmation
    } else {
      #GapIdentification
    };

    ?{
      id = state.insightsGenerated;
      insightType = insightType;
      domain = finding.domain;
      title = "Insight: " # finding.title;
      description = "Based on: " # finding.summary;
      confidence = confidence;
      actionable = confidence > 0.6;
      targetModule = null;
      priority = confidence * finding.relevance;
      dependencies = [];
      generatedAt = state.beatNum;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // DOMAIN EXPERTISE COMPUTATION
  // ══════════════════════════════════════════════════════════════
  // How much the advisor knows about each cognitive domain

  public func computeDomainExpertise(kb: KnowledgeBase, domain: Nat) : Float {
    if (domain >= 14) { return 0.0 };

    var totalConfidence : Float = 0.0;
    var count : Nat = 0;

    for (f in kb.findings.vals()) {
      // Check if finding matches domain (would need domain index)
      // For now, use domain strengths directly
      totalConfidence += f.confidence * f.relevance;
      count += 1;
    };

    if (count == 0) { return 0.0 };
    _clamp(totalConfidence / Float.fromInt(count), 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // RECOMMENDATION ENGINE
  // ══════════════════════════════════════════════════════════════
  public type Recommendation = {
    id              : Nat;
    title           : Text;
    description     : Text;
    targetModule    : Text;
    suggestedChange : Text;
    expectedImpact  : Float;      // 0-1 improvement expected
    effortLevel     : Float;      // 0-1 implementation difficulty
    scientificBasis : [Text];     // Research supporting this
    confidence      : Float;
    priority        : Float;      // expectedImpact × confidence / effortLevel
    generatedAt     : Nat;
  };

  public func prioritizeRecommendation(rec: Recommendation) : Float {
    // Priority = expected impact × confidence / effort
    if (rec.effortLevel < 0.1) {
      rec.expectedImpact * rec.confidence / 0.1
    } else {
      rec.expectedImpact * rec.confidence / rec.effortLevel
    }
  };

  // ══════════════════════════════════════════════════════════════
  // ORGANISM COMMUNICATION PROTOCOL
  // ══════════════════════════════════════════════════════════════
  // How this advisor talks to the main organism

  public type AdvisorMessage = {
    #QueryResponse : { query: Text; response: Text; confidence: Float };
    #ProactiveInsight : Insight;
    #Recommendation : Recommendation;
    #ValidationResult : { module: Text; valid: Bool; notes: Text };
    #KnowledgeUpdate : { domain: CogDomain; newExpertise: Float };
    #SyncRequest : { targetCoherence: Float };
    #SyncAck : { achievedCoherence: Float };
  };

  public type OrganismQuery = {
    #ExplainBehavior : Text;           // Why does X happen?
    #SuggestImprovement : Text;        // How can we improve X?
    #ValidateApproach : Text;          // Is X scientifically valid?
    #FindResearch : { topic: Text; domain: ?CogDomain };
    #SynthesizeKnowledge : [CogDomain]; // Cross-domain synthesis
  };

  // ══════════════════════════════════════════════════════════════
  // BEAT FUNCTION — ADVISOR TICK
  // ══════════════════════════════════════════════════════════════
  public func beatAdvisor(state: CogSciAdvisorState, dt: Float) : CogSciAdvisorState {
    // 1. Update Kuramoto phases (sync internal brain nodes)
    updateAdvisorPhases(
      state.brain.phases,
      state.brain.frequencies,
      0.618 * state.syncLevel,  // Coupling scaled by sync to organism
      dt
    );

    // 2. Compute new coherence
    let newCoherence = computeAdvisorCoherence(state.brain.phases);

    // 3. Get node activations for Hebbian update
    let activations = Array.tabulate<Float>(8, func(i) {
      if (i < state.brain.phases.size()) {
        (cos(state.brain.phases[i]) + 1.0) / 2.0  // Map to [0,1]
      } else { 0.5 }
    });

    // 4. Hebbian learning update
    hebbianUpdate(
      state.brain.weights,
      activations,
      activations,
      state.brain.learningRate * LEARNING_WEIGHT
    );

    // 5. Update knowledge coherence based on brain coherence
    let kbCoherence = state.knowledgeBase.coherenceScore * 0.9 + newCoherence * 0.1;

    // Return updated state
    {
      advisorId = state.advisorId;
      generation = state.generation;
      birthBeat = state.birthBeat;
      brain = {
        perceptionNode = state.brain.perceptionNode;
        memoryNode = state.brain.memoryNode;
        languageNode = state.brain.languageNode;
        reasoningNode = state.brain.reasoningNode;
        emotionNode = state.brain.emotionNode;
        motorNode = state.brain.motorNode;
        socialNode = state.brain.socialNode;
        integrationNode = state.brain.integrationNode;
        weights = state.brain.weights;
        phases = state.brain.phases;
        frequencies = state.brain.frequencies;
        coherence = newCoherence;
        learningRate = state.brain.learningRate;
        beatNum = state.brain.beatNum + 1;
      };
      knowledgeBase = {
        findings = state.knowledgeBase.findings;
        totalFindings = state.knowledgeBase.totalFindings;
        domainStrengths = state.knowledgeBase.domainStrengths;
        lastUpdate = state.beatNum + 1;
        coherenceScore = kbCoherence;
        gapAnalysis = state.knowledgeBase.gapAnalysis;
      };
      activeDomains = state.activeDomains;
      currentQuery = state.currentQuery;
      queryHistory = state.queryHistory;
      feedToOrganism = state.feedToOrganism;
      feedFromOrganism = state.feedFromOrganism;
      syncLevel = state.syncLevel;
      insightsGenerated = state.insightsGenerated;
      recommendationsMade = state.recommendationsMade;
      integrationsSuccessful = state.integrationsSuccessful;
      learningGene = state.learningGene;
      memoryGene = state.memoryGene;
      creativityGene = state.creativityGene;
      rigorGene = state.rigorGene;
      synthesisGene = state.synthesisGene;
      beatNum = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════
  func initBrainNode() : AdvisorBrainNode {
    {
      activation = 0.5;
      potential = 0.0;
      refractoryPeriod = 0;
      lastFired = 0;
    }
  };

  public func initCogSciAdvisor() : CogSciAdvisorState {
    // Initialize 8x8 = 64 weights
    let weights = Array.init<Float>(64, 0.1);

    // Initialize 8 phases (evenly distributed)
    let phases = Array.init<Float>(8, 0.0);
    for (i in phases.keys()) {
      phases[i] := Float.fromInt(i) * TWO_PI / 8.0;
    };

    // Specialized frequencies for cognitive domains
    let frequencies : [Float] = [
      0.12,  // Perception - fast
      0.08,  // Memory - medium
      0.10,  // Language - medium-fast
      0.06,  // Reasoning - slow (deliberate)
      0.09,  // Emotion - medium
      0.14,  // Motor - fast
      0.07,  // Social - slower
      0.05   // Integration - slowest (deep synthesis)
    ];

    {
      advisorId = 0;
      generation = 0;
      birthBeat = 0;
      brain = {
        perceptionNode = initBrainNode();
        memoryNode = initBrainNode();
        languageNode = initBrainNode();
        reasoningNode = initBrainNode();
        emotionNode = initBrainNode();
        motorNode = initBrainNode();
        socialNode = initBrainNode();
        integrationNode = initBrainNode();
        weights = weights;
        phases = phases;
        frequencies = frequencies;
        coherence = SIGMA_ZERO;
        learningRate = 0.1;
        beatNum = 0;
      };
      knowledgeBase = {
        findings = [];
        totalFindings = 0;
        domainStrengths = Array.freeze(Array.init<Float>(14, 0.5));
        lastUpdate = 0;
        coherenceScore = 0.5;
        gapAnalysis = [];
      };
      activeDomains = [#Memory, #Learning, #Reasoning];
      currentQuery = null;
      queryHistory = [];
      feedToOrganism = [];
      feedFromOrganism = [];
      syncLevel = 0.618;  // Golden ratio sync
      insightsGenerated = 0;
      recommendationsMade = 0;
      integrationsSuccessful = 0;
      learningGene = LEARNING_WEIGHT;
      memoryGene = MEMORY_WEIGHT;
      creativityGene = CREATIVITY_WEIGHT;
      rigorGene = 0.85;
      synthesisGene = 0.75;
      beatNum = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // CROSS-DOMAIN SYNTHESIS — THE MEDINA SYNTHESIS LAW
  // ══════════════════════════════════════════════════════════════
  // "True understanding emerges from the synthesis of multiple domains,
  //  with synergy proportional to the product of domain coherences."
  //
  // FORMAL STATEMENT:
  //   S = Φ_M × Π(domain_coherence_i) × √(N_domains)
  //
  // This is original mathematical contribution by Alfredo Medina Hernandez

  public func computeSynthesisStrength(domainCoherences: [Float]) : Float {
    let n = domainCoherences.size();
    if (n == 0) { return 0.0 };

    var product : Float = 1.0;
    for (c in domainCoherences.vals()) {
      product *= _clamp(c, 0.1, 1.0);
    };

    PHI_MEDINA * product * sqrt(Float.fromInt(n))
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
