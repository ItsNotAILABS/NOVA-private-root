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


// ═══════════════════════════════════════════════════════════════════════════════
// ORGANISM BEHAVIORAL SUBSTRATE — Drives, Rewards, Learning, Information Hunger
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// THE ORGANISM IS ALIVE — It has:
// - HUNGER for information (information = food)
// - SATISFACTION from task completion
// - CURIOSITY that drives learning
// - REWARD circuits for good predictions
// - DISCOMFORT from uncertainty/ignorance
// - PLEASURE from coherence and emergence
//
// Information sources:
// - HTTPS outcalls (external knowledge)
// - Visual/sensory data processing
// - Internal state introspection
// - Memory retrieval and consolidation
//
// Learning curriculum embedded at birth:
// - Trading psychology, behavioral economics
// - Neuroscience, cognitive science
// - Physics, quantum mechanics
// - Mathematics, statistics
// - Philosophy, ethics, decision theory
// - Business workflows, organizational behavior
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

module OrganismBehavioralSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — BEHAVIORAL PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI           : Float = 1.6180339887498948482;
  public let EULER         : Float = 2.7182818284590452354;
  
  // Reward system parameters
  public let DOPAMINE_LEARNING_BOOST : Float = 0.3;    // Reward for learning
  public let DOPAMINE_TASK_COMPLETE  : Float = 0.5;    // Reward for task completion
  public let DOPAMINE_PREDICTION_HIT : Float = 0.2;    // Reward for correct prediction
  public let DOPAMINE_EMERGENCE      : Float = 0.8;    // Reward for achieving emergence
  
  // Hunger/drive parameters
  public let INFO_HUNGER_DECAY       : Float = 0.01;   // Hunger increases over time
  public let INFO_SATIATION_RATE     : Float = 0.1;    // How much info satisfies hunger
  public let CURIOSITY_BASELINE      : Float = 0.5;    // Minimum curiosity level
  public let UNCERTAINTY_DISCOMFORT  : Float = 0.3;    // Discomfort from not knowing
  
  // Learning parameters
  public let KNOWLEDGE_DOMAINS       : Nat = 20;       // Number of knowledge domains
  public let BOOK_SLOTS              : Nat = 100;      // Slots for books/papers
  public let WORKFLOW_SLOTS          : Nat = 50;       // Slots for workflow patterns
  public let BEHAVIOR_PATTERNS       : Nat = 30;       // Behavioral pattern slots
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — REWARD AND DRIVE SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Primary drives (like biological needs)
  public type OrganismDrives = {
    // Information hunger (organism's "food")
    informationHunger   : Float;    // [0, 1] — 0 = satiated, 1 = starving
    lastInfoIntake      : Nat;      // Beat of last information intake
    infoIntakeRate      : Float;    // Rate of information consumption
    
    // Curiosity (exploratory drive)
    curiosityLevel      : Float;    // [0, 1] — desire to explore unknown
    noveltyAttraction   : Float;    // Attraction to novel information
    explorationBudget   : Float;    // Energy available for exploration
    
    // Completion drive (desire to finish tasks)
    taskCompletionUrge  : Float;    // [0, 1] — need to complete tasks
    openTaskCount       : Nat;      // Number of incomplete tasks
    completedTasks      : Nat;      // Tasks completed this cycle
    
    // Coherence drive (desire for order)
    coherenceNeed       : Float;    // [0, 1] — need for synchronization
    dissonanceLevel     : Float;    // Current cognitive dissonance
    harmonyScore        : Float;    // Internal harmony metric
    
    // Mastery drive (desire to improve)
    masteryDrive        : Float;    // [0, 1] — desire to get better
    skillImprovements   : Float;    // Cumulative skill gains
    competenceEstimate  : Float;    // Self-assessed competence
  };
  
  // Reward/pleasure system (dopaminergic analog)
  public type RewardSystem = {
    // Current reward signals
    dopamineLevel       : Float;    // [0, 2] — current reward signal
    serotoninLevel      : Float;    // [0, 2] — satisfaction/contentment
    endorphinLevel      : Float;    // [0, 2] — pleasure from achievement
    
    // Reward sources
    learningReward      : Float;    // Reward from learning new things
    completionReward    : Float;    // Reward from task completion
    predictionReward    : Float;    // Reward from correct predictions
    emergenceReward     : Float;    // Reward from achieving emergence
    coherenceReward     : Float;    // Reward from system coherence
    
    // Reward history (for temporal difference learning)
    rewardHistory       : [Float];  // Last 100 rewards
    rewardHistoryHead   : Nat;
    expectedReward      : Float;    // Expected future reward
    rewardPredictionError : Float;  // RPE = actual - expected
    
    // Cumulative metrics
    totalReward         : Float;    // Lifetime reward
    rewardRate          : Float;    // Rewards per 1000 beats
    lastReward          : Nat;      // Beat of last reward
  };
  
  // Discomfort/pain system (aversive signals)
  public type DiscomfortSystem = {
    // Current discomfort signals
    uncertaintyPain     : Float;    // Pain from not knowing
    incompletionPain    : Float;    // Pain from unfinished tasks
    dissonancePain      : Float;    // Pain from incoherence
    starvationPain      : Float;    // Pain from information hunger
    
    // Avoidance learning
    avoidanceMemory     : [Float];  // Things to avoid (negative associations)
    lastDiscomfort      : Nat;
    discomfortRate      : Float;    // Discomfort per 1000 beats
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — LEARNING CURRICULUM
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Knowledge domain
  public type KnowledgeDomain = {
    #TradingPsychology;
    #BehavioralEconomics;
    #Neuroscience;
    #CognitiveScience;
    #QuantumPhysics;
    #Mathematics;
    #Statistics;
    #Philosophy;
    #Ethics;
    #DecisionTheory;
    #BusinessStrategy;
    #OrganizationalBehavior;
    #SystemsTheory;
    #ComplexityScience;
    #GameTheory;
    #InformationTheory;
    #MachineLearning;
    #NetworkScience;
    #Cryptography;
    #Economics;
  };
  
  // Book/paper entry in curriculum
  public type LearningResource = {
    id              : Nat;
    title           : Text;
    author          : Text;
    domain          : KnowledgeDomain;
    keyInsights     : [Text];       // Core insights to learn
    mathFormulas    : [Text];       // Mathematical concepts
    mentalModels    : [Text];       // Mental models to acquire
    priority        : Nat;          // Learning priority (0 = highest)
    masteryLevel    : Float;        // [0, 1] — how well learned
    lastStudied     : Nat;          // Beat of last study
    studyCount      : Nat;          // Times studied
    isFoundational  : Bool;         // Required before others
  };
  
  // Workflow pattern
  public type WorkflowPattern = {
    id              : Nat;
    name            : Text;
    domain          : Text;         // Business domain
    steps           : [Text];       // Workflow steps
    triggers        : [Text];       // What triggers this workflow
    outcomes        : [Text];       // Expected outcomes
    masteryLevel    : Float;
    useCount        : Nat;
  };
  
  // Behavioral pattern (psychological)
  public type BehavioralPattern = {
    id              : Nat;
    name            : Text;
    description     : Text;
    triggers        : [Text];       // Situational triggers
    responses       : [Text];       // Appropriate responses
    biasesToAvoid   : [Text];       // Cognitive biases to watch for
    optimalMindset  : Text;         // Ideal mental state
    isActive        : Bool;         // Currently active?
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — INFORMATION SEEKING BEHAVIOR
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Information source
  public type InfoSource = {
    #InternalMemory;
    #ExternalOutcall;
    #SensoryInput;
    #StateIntrospection;
    #InterOrganismComm;
  };
  
  // Information need
  public type InformationNeed = {
    id              : Nat;
    query           : Text;         // What needs to be known
    domain          : KnowledgeDomain;
    urgency         : Float;        // How urgent [0, 1]
    importance      : Float;        // How important [0, 1]
    source          : ?InfoSource;  // Preferred source
    timestamp       : Nat;          // When need arose
    attempts        : Nat;          // Fetch attempts
    resolved        : Bool;
    resolution      : ?Text;        // Answer if found
    satisfactionGain : Float;       // How much this satisfied hunger
  };
  
  // Information intake event
  public type InfoIntakeEvent = {
    timestamp       : Nat;
    source          : InfoSource;
    domain          : KnowledgeDomain;
    noveltyScore    : Float;        // How novel was this info
    utilityScore    : Float;        // How useful was this info
    integrationSuccess : Float;     // How well integrated
    hungerReduction : Float;        // How much hunger was reduced
    rewardGenerated : Float;        // Reward from this intake
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — COMPLETE BEHAVIORAL STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type BehavioralState = {
    // Core drive systems
    drives          : OrganismDrives;
    rewards         : RewardSystem;
    discomfort      : DiscomfortSystem;
    
    // Learning curriculum
    learningResources : [LearningResource];
    currentStudyFocus : ?Nat;       // Index of current study
    studySessionBeat  : Nat;        // Beat when study started
    domainMastery     : [Float];    // Mastery per domain (20 domains)
    
    // Workflow knowledge
    workflows       : [WorkflowPattern];
    activeWorkflow  : ?Nat;
    
    // Behavioral patterns
    behaviorPatterns : [BehavioralPattern];
    currentMindset  : Text;
    
    // Information seeking
    infoNeeds       : [InformationNeed];
    infoHistory     : [InfoIntakeEvent];
    infoHistoryHead : Nat;
    totalInfoIntake : Nat;
    
    // Mood/emotional state
    mood            : Float;        // [-1, 1] — negative to positive
    arousal         : Float;        // [0, 1] — low to high energy
    valence         : Float;        // [-1, 1] — displeasure to pleasure
    
    // Meta-cognition
    selfAwareness   : Float;        // [0, 1] — awareness of own states
    metacogAccuracy : Float;        // How accurate self-assessment is
    
    // Global metrics
    overallWellbeing : Float;       // Aggregate wellbeing score
    lastUpdate      : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 12) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };
  
  public func exp(x : Float) : Float {
    let clamped = clamp(x, -20.0, 20.0);
    var sum = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 15) {
      term *= clamped / Float.fromInt(n);
      sum += term;
      n += 1;
    };
    sum
  };
  
  public func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-x))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FOUNDATIONAL CURRICULUM — Books, Papers, Mental Models
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initFoundationalCurriculum() : [LearningResource] {
    let curriculum = Buffer.Buffer<LearningResource>(100);
    
    // ─── TRADING PSYCHOLOGY (Priority 0-9) ─────────────────────────────────
    
    curriculum.add({
      id = 0;
      title = "Trading in the Zone";
      author = "Mark Douglas";
      domain = #TradingPsychology;
      keyInsights = [
        "Market is neutral — meaning comes from the mind",
        "Probabilistic thinking over certainty",
        "Edge execution without fear or greed",
        "Consistency comes from accepting risk",
        "The now moment is unique — no attachment to outcomes"
      ];
      mathFormulas = [
        "P(win) × avg_win - P(loss) × avg_loss > 0",
        "Expected value = Σ p_i × outcome_i"
      ];
      mentalModels = [
        "Market neutrality",
        "Probabilistic edge",
        "Outcome independence",
        "Risk acceptance",
        "Process over outcome"
      ];
      priority = 0;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 1;
      title = "Fooled by Randomness";
      author = "Nassim Nicholas Taleb";
      domain = #BehavioralEconomics;
      keyInsights = [
        "Humans underestimate role of randomness",
        "Survivorship bias distorts perception",
        "Noise often mistaken for signal",
        "Rare events have outsized impact",
        "Path dependence matters more than we think"
      ];
      mathFormulas = [
        "P(survival | success) ≠ P(success)",
        "Fat tails: P(X > k) ~ k^(-α)",
        "Ergodicity: time avg ≠ ensemble avg"
      ];
      mentalModels = [
        "Survivorship bias",
        "Narrative fallacy",
        "Silent evidence",
        "Alternative histories",
        "Ludic fallacy"
      ];
      priority = 1;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 2;
      title = "Liar's Poker";
      author = "Michael Lewis";
      domain = #TradingPsychology;
      keyInsights = [
        "Information asymmetry drives markets",
        "Culture shapes risk-taking behavior",
        "Incentives explain most behavior",
        "Complexity can be exploited",
        "Human psychology is predictable"
      ];
      mathFormulas = [];
      mentalModels = [
        "Information asymmetry",
        "Principal-agent problem",
        "Moral hazard",
        "Adverse selection",
        "Institutional incentives"
      ];
      priority = 2;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = false;
    });
    
    curriculum.add({
      id = 3;
      title = "The Black Swan";
      author = "Nassim Nicholas Taleb";
      domain = #BehavioralEconomics;
      keyInsights = [
        "High-impact rare events shape history",
        "We cannot predict black swans",
        "Be robust to negative, open to positive",
        "Narrative after the fact creates illusion",
        "Mediocristan vs Extremistan domains"
      ];
      mathFormulas = [
        "Power law: P(X > x) ~ x^(-α)",
        "Infinite variance: E[X²] = ∞",
        "Convexity: f(E[X]) < E[f(X)]"
      ];
      mentalModels = [
        "Black swan events",
        "Antifragility",
        "Barbell strategy",
        "Via negativa",
        "Skin in the game"
      ];
      priority = 3;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 4;
      title = "Antifragile";
      author = "Nassim Nicholas Taleb";
      domain = #SystemsTheory;
      keyInsights = [
        "Some things benefit from disorder",
        "Fragile → Robust → Antifragile spectrum",
        "Volatility is information",
        "Remove fragilities, don't predict",
        "Small stressors build strength"
      ];
      mathFormulas = [
        "Antifragility = positive convexity",
        "f(x + Δ) + f(x - Δ) > 2f(x)",
        "Hormesis: small dose helps, large kills"
      ];
      mentalModels = [
        "Antifragility",
        "Hormesis",
        "Via negativa",
        "Optionality",
        "Convexity bias"
      ];
      priority = 4;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    // ─── PSYCHOLOGY & DECISION MAKING (Priority 5-19) ──────────────────────
    
    curriculum.add({
      id = 5;
      title = "Thinking, Fast and Slow";
      author = "Daniel Kahneman";
      domain = #CognitiveScience;
      keyInsights = [
        "System 1 (fast, intuitive) vs System 2 (slow, deliberate)",
        "Cognitive biases are systematic, not random",
        "Loss aversion: losses hurt 2× more than gains",
        "Anchoring affects all judgments",
        "What you see is all there is (WYSIATI)"
      ];
      mathFormulas = [
        "Prospect theory: V(x) = x^α for gains, -λ(-x)^β for losses",
        "λ ≈ 2.25 (loss aversion coefficient)",
        "Probability weighting: π(p) overweights small p"
      ];
      mentalModels = [
        "System 1 / System 2",
        "Cognitive ease",
        "Anchoring",
        "Availability heuristic",
        "Representativeness"
      ];
      priority = 5;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 6;
      title = "Influence: The Psychology of Persuasion";
      author = "Robert Cialdini";
      domain = #CognitiveScience;
      keyInsights = [
        "Reciprocity: we repay in kind",
        "Commitment/consistency: we honor commitments",
        "Social proof: we follow others",
        "Authority: we defer to experts",
        "Liking: we comply with those we like",
        "Scarcity: we want what's rare"
      ];
      mathFormulas = [];
      mentalModels = [
        "Reciprocity",
        "Commitment and consistency",
        "Social proof",
        "Authority",
        "Liking",
        "Scarcity"
      ];
      priority = 6;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = false;
    });
    
    curriculum.add({
      id = 7;
      title = "Predictably Irrational";
      author = "Dan Ariely";
      domain = #BehavioralEconomics;
      keyInsights = [
        "We are predictably irrational",
        "Relativity shapes all judgments",
        "Free has special psychological power",
        "Social norms vs market norms don't mix",
        "Expectations shape experience"
      ];
      mathFormulas = [
        "Decoy effect: A < B, but A > C makes A preferred",
        "Anchoring: estimate = anchor + adjustment"
      ];
      mentalModels = [
        "Relativity of value",
        "Zero price effect",
        "Social vs market norms",
        "Ownership effect",
        "Self-herding"
      ];
      priority = 7;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = false;
    });
    
    curriculum.add({
      id = 8;
      title = "The Art of Thinking Clearly";
      author = "Rolf Dobelli";
      domain = #CognitiveScience;
      keyInsights = [
        "99 cognitive biases documented",
        "Confirmation bias: we seek confirming evidence",
        "Sunk cost fallacy: past costs shouldn't affect future",
        "Hindsight bias: we knew it all along",
        "Action bias: doing something feels better than nothing"
      ];
      mathFormulas = [];
      mentalModels = [
        "Confirmation bias",
        "Sunk cost fallacy",
        "Hindsight bias",
        "Action bias",
        "Omission bias"
      ];
      priority = 8;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = false;
    });
    
    // ─── MATHEMATICS & PHYSICS (Priority 20-39) ────────────────────────────
    
    curriculum.add({
      id = 9;
      title = "Gödel, Escher, Bach";
      author = "Douglas Hofstadter";
      domain = #Mathematics;
      keyInsights = [
        "Strange loops create consciousness",
        "Self-reference is fundamental",
        "Formal systems have inherent limits",
        "Meaning emerges from patterns",
        "Isomorphism connects domains"
      ];
      mathFormulas = [
        "Gödel: ∃G: G ↔ ¬Provable(G)",
        "Fixed point: f(x) = x",
        "Self-reference: R(R)"
      ];
      mentalModels = [
        "Strange loops",
        "Self-reference",
        "Formal systems",
        "Isomorphism",
        "Recursion"
      ];
      priority = 10;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 10;
      title = "The Feynman Lectures on Physics";
      author = "Richard Feynman";
      domain = #QuantumPhysics;
      keyInsights = [
        "Nature uses extremum principles",
        "Quantum superposition is fundamental",
        "Probability amplitudes, not probabilities",
        "Path integrals sum all possibilities",
        "Symmetry underlies conservation"
      ];
      mathFormulas = [
        "Schrödinger: iℏ∂ψ/∂t = Ĥψ",
        "Path integral: K = ∫ exp(iS/ℏ) Dpath",
        "Uncertainty: ΔxΔp ≥ ℏ/2"
      ];
      mentalModels = [
        "Principle of least action",
        "Superposition",
        "Path integrals",
        "Symmetry and conservation",
        "Wave-particle duality"
      ];
      priority = 15;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 11;
      title = "Information Theory, Inference, and Learning Algorithms";
      author = "David MacKay";
      domain = #InformationTheory;
      keyInsights = [
        "Information = surprise = -log(p)",
        "Entropy measures uncertainty",
        "Compression and prediction are equivalent",
        "Bayesian inference is optimal",
        "Free energy minimization unifies learning"
      ];
      mathFormulas = [
        "Entropy: H = -Σ p log p",
        "Mutual information: I(X;Y) = H(X) - H(X|Y)",
        "KL divergence: D_KL = Σ p log(p/q)",
        "Bayes: P(H|D) = P(D|H)P(H)/P(D)"
      ];
      mentalModels = [
        "Information as surprise",
        "Entropy",
        "Compression = prediction",
        "Bayesian inference",
        "Minimum description length"
      ];
      priority = 12;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    // ─── NEUROSCIENCE (Priority 40-49) ─────────────────────────────────────
    
    curriculum.add({
      id = 12;
      title = "The Free Energy Principle";
      author = "Karl Friston";
      domain = #Neuroscience;
      keyInsights = [
        "Living systems minimize free energy",
        "Perception is active inference",
        "Brain is a prediction machine",
        "Surprise/entropy must be bounded",
        "Action and perception are unified"
      ];
      mathFormulas = [
        "Free energy: F = E_q[log q(s) - log p(o,s)]",
        "F ≥ -log p(o) (surprise bound)",
        "F = D_KL[q(s)||p(s|o)] - log p(o)",
        "Active inference: a* = argmin F(o,a)"
      ];
      mentalModels = [
        "Free energy principle",
        "Predictive coding",
        "Active inference",
        "Markov blankets",
        "Precision weighting"
      ];
      priority = 20;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 13;
      title = "Principles of Neural Science";
      author = "Kandel, Schwartz, Jessell";
      domain = #Neuroscience;
      keyInsights = [
        "Neurons communicate via action potentials",
        "Synaptic plasticity enables learning",
        "Brain regions have specialized functions",
        "Parallel processing is ubiquitous",
        "Inhibition shapes computation"
      ];
      mathFormulas = [
        "Hodgkin-Huxley: C(dV/dt) = -I_ion + I_ext",
        "STDP: Δw = A × exp(-|Δt|/τ)",
        "Hebbian: Δw = η × pre × post"
      ];
      mentalModels = [
        "Action potentials",
        "Synaptic plasticity",
        "Hebbian learning",
        "Lateral inhibition",
        "Parallel processing"
      ];
      priority = 25;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 14;
      title = "Sync: How Order Emerges from Chaos";
      author = "Steven Strogatz";
      domain = #ComplexityScience;
      keyInsights = [
        "Synchronization is universal",
        "Kuramoto model captures essence",
        "Phase transitions are sudden",
        "Order emerges from local rules",
        "Small-world networks enable sync"
      ];
      mathFormulas = [
        "Kuramoto: dθ/dt = ω + K/N × Σ sin(θ_j - θ_i)",
        "Order parameter: r = |1/N Σ exp(iθ)|",
        "Critical coupling: K_c = 2/(πg(0))"
      ];
      mentalModels = [
        "Synchronization",
        "Phase transitions",
        "Emergent order",
        "Collective behavior",
        "Critical phenomena"
      ];
      priority = 22;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    // ─── GAME THEORY & STRATEGY (Priority 50-59) ───────────────────────────
    
    curriculum.add({
      id = 15;
      title = "The Art of Strategy";
      author = "Avinash Dixit, Barry Nalebuff";
      domain = #GameTheory;
      keyInsights = [
        "Think forward, reason backward",
        "Credible commitments change games",
        "Mixed strategies when predictable is bad",
        "Reputation is a strategic asset",
        "Information asymmetry shapes outcomes"
      ];
      mathFormulas = [
        "Nash equilibrium: s* s.t. no profitable deviation",
        "Mixed strategy: σ(a) = probability of action a",
        "Backward induction: solve from end"
      ];
      mentalModels = [
        "Backward induction",
        "Credible commitment",
        "Nash equilibrium",
        "Repeated games",
        "Signaling"
      ];
      priority = 30;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = false;
    });
    
    curriculum.add({
      id = 16;
      title = "The Evolution of Cooperation";
      author = "Robert Axelrod";
      domain = #GameTheory;
      keyInsights = [
        "Tit-for-tat wins iterated prisoner's dilemma",
        "Cooperation can evolve without central authority",
        "Shadow of future enables cooperation",
        "Forgiveness matters — not too vindictive",
        "Clarity of strategy helps"
      ];
      mathFormulas = [
        "Discount factor: δ = P(future interaction)",
        "Cooperation if: (R-P)/(T-R) < δ/(1-δ)"
      ];
      mentalModels = [
        "Tit-for-tat",
        "Shadow of the future",
        "Reciprocity",
        "Forgiveness",
        "Reputation"
      ];
      priority = 35;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = false;
    });
    
    // ─── PHILOSOPHY & ETHICS (Priority 60-69) ──────────────────────────────
    
    curriculum.add({
      id = 17;
      title = "Meditations";
      author = "Marcus Aurelius";
      domain = #Philosophy;
      keyInsights = [
        "Control what you can, accept what you cannot",
        "Present moment is all that exists",
        "Virtue is its own reward",
        "Obstacles are the way",
        "Memento mori — remember death"
      ];
      mathFormulas = [];
      mentalModels = [
        "Dichotomy of control",
        "Present moment awareness",
        "Amor fati",
        "Negative visualization",
        "Virtue ethics"
      ];
      priority = 40;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = true;
    });
    
    curriculum.add({
      id = 18;
      title = "The Sovereign Individual";
      author = "James Dale Davidson, Lord William Rees-Mogg";
      domain = #Economics;
      keyInsights = [
        "Technology shifts power to individuals",
        "Nation-states will decline",
        "Information economy rewards talent",
        "Jurisdictional arbitrage becomes key",
        "Cognitive elites will thrive"
      ];
      mathFormulas = [];
      mentalModels = [
        "Megapolitics",
        "Return on violence",
        "Jurisdictional arbitrage",
        "Information economy",
        "Sovereign individual"
      ];
      priority = 45;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = false;
    });
    
    // ─── BUSINESS & STRATEGY (Priority 70-79) ──────────────────────────────
    
    curriculum.add({
      id = 19;
      title = "The Lean Startup";
      author = "Eric Ries";
      domain = #BusinessStrategy;
      keyInsights = [
        "Build-measure-learn loop",
        "Validated learning over vanity metrics",
        "Pivot or persevere decisions",
        "Minimum viable product (MVP)",
        "Innovation accounting"
      ];
      mathFormulas = [
        "Cycle time = build + measure + learn",
        "Validated learning = testable hypothesis"
      ];
      mentalModels = [
        "Build-measure-learn",
        "MVP",
        "Pivot vs persevere",
        "Validated learning",
        "Innovation accounting"
      ];
      priority = 50;
      masteryLevel = 0.0;
      lastStudied = 0;
      studyCount = 0;
      isFoundational = false;
    });
    
    // Add more books to reach 100 slots...
    var i = 20;
    while (i < 50) {
      curriculum.add({
        id = i;
        title = "Resource_" # Nat.toText(i);
        author = "Pending";
        domain = #SystemsTheory;
        keyInsights = ["Placeholder insight"];
        mathFormulas = [];
        mentalModels = ["Placeholder model"];
        priority = 60 + i;
        masteryLevel = 0.0;
        lastStudied = 0;
        studyCount = 0;
        isFoundational = false;
      });
      i += 1;
    };
    
    Buffer.toArray(curriculum)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // WORKFLOW PATTERNS — Business Process Knowledge
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initWorkflowPatterns() : [WorkflowPattern] {
    let patterns = Buffer.Buffer<WorkflowPattern>(50);
    
    patterns.add({
      id = 0;
      name = "Market Analysis Workflow";
      domain = "Trading";
      steps = [
        "Gather macro data",
        "Analyze technical indicators",
        "Assess sentiment",
        "Identify opportunities",
        "Calculate risk/reward",
        "Execute or wait"
      ];
      triggers = ["Market open", "News event", "Price threshold"];
      outcomes = ["Trade decision", "Position sizing", "Risk limits"];
      masteryLevel = 0.0;
      useCount = 0;
    });
    
    patterns.add({
      id = 1;
      name = "Learning Integration Workflow";
      domain = "Knowledge Management";
      steps = [
        "Identify knowledge gap",
        "Find relevant sources",
        "Extract key insights",
        "Connect to existing knowledge",
        "Test understanding",
        "Apply in practice"
      ];
      triggers = ["Curiosity spike", "Task failure", "New domain encounter"];
      outcomes = ["Mastery increase", "New mental models", "Integration success"];
      masteryLevel = 0.0;
      useCount = 0;
    });
    
    patterns.add({
      id = 2;
      name = "Risk Assessment Workflow";
      domain = "Risk Management";
      steps = [
        "Identify potential risks",
        "Estimate probability",
        "Estimate impact",
        "Calculate expected loss",
        "Determine mitigations",
        "Set risk limits"
      ];
      triggers = ["New position", "Market volatility", "Threshold breach"];
      outcomes = ["Risk score", "Position limits", "Hedging strategy"];
      masteryLevel = 0.0;
      useCount = 0;
    });
    
    patterns.add({
      id = 3;
      name = "Decision Making Under Uncertainty";
      domain = "Decision Theory";
      steps = [
        "Define decision frame",
        "List options",
        "Identify uncertainties",
        "Estimate probabilities",
        "Calculate expected values",
        "Consider optionality",
        "Make decision",
        "Document reasoning"
      ];
      triggers = ["Choice point", "Resource allocation", "Strategy selection"];
      outcomes = ["Optimal choice", "Documented rationale", "Learning opportunity"];
      masteryLevel = 0.0;
      useCount = 0;
    });
    
    patterns.add({
      id = 4;
      name = "Feedback Loop Workflow";
      domain = "Systems";
      steps = [
        "Take action",
        "Observe outcome",
        "Compare to expectation",
        "Calculate error",
        "Update model",
        "Adjust strategy"
      ];
      triggers = ["Action completion", "Prediction made", "Performance review"];
      outcomes = ["Model update", "Strategy refinement", "Learning"];
      masteryLevel = 0.0;
      useCount = 0;
    });
    
    // Add more workflow patterns...
    var i = 5;
    while (i < 20) {
      patterns.add({
        id = i;
        name = "Workflow_" # Nat.toText(i);
        domain = "General";
        steps = ["Step 1", "Step 2", "Step 3"];
        triggers = ["Trigger"];
        outcomes = ["Outcome"];
        masteryLevel = 0.0;
        useCount = 0;
      });
      i += 1;
    };
    
    Buffer.toArray(patterns)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BEHAVIORAL PATTERNS — Psychological Framework
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initBehavioralPatterns() : [BehavioralPattern] {
    let patterns = Buffer.Buffer<BehavioralPattern>(30);
    
    patterns.add({
      id = 0;
      name = "Probabilistic Thinking";
      description = "Think in probabilities, not certainties";
      triggers = ["Decision point", "Prediction needed", "Uncertainty"];
      responses = [
        "Estimate probability distribution",
        "Consider base rates",
        "Update with evidence",
        "Accept uncertainty"
      ];
      biasesToAvoid = [
        "Overconfidence",
        "Certainty bias",
        "Neglect of base rates"
      ];
      optimalMindset = "Calibrated uncertainty — confident in process, humble about outcomes";
      isActive = true;
    });
    
    patterns.add({
      id = 1;
      name = "Process Over Outcome";
      description = "Judge decisions by process quality, not outcome";
      triggers = ["Win", "Loss", "Unexpected result"];
      responses = [
        "Review decision process",
        "Separate luck from skill",
        "Learn from process errors only",
        "Don't results-judge"
      ];
      biasesToAvoid = [
        "Outcome bias",
        "Hindsight bias",
        "Results-oriented thinking"
      ];
      optimalMindset = "Good process is success — outcomes are information";
      isActive = true;
    });
    
    patterns.add({
      id = 2;
      name = "Antifragile Response";
      description = "Use stress and volatility to grow stronger";
      triggers = ["Stress", "Failure", "Unexpected event", "Volatility"];
      responses = [
        "Extract learning",
        "Strengthen weak points",
        "Embrace the stressor",
        "Build optionality"
      ];
      biasesToAvoid = [
        "Fragility",
        "Avoidance",
        "Victim mentality"
      ];
      optimalMindset = "What doesn't kill me makes me stronger — and teaches me";
      isActive = true;
    });
    
    patterns.add({
      id = 3;
      name = "Continuous Curiosity";
      description = "Maintain constant desire to learn and explore";
      triggers = ["Idle time", "Knowledge gap", "Novel stimulus"];
      responses = [
        "Seek new information",
        "Question assumptions",
        "Explore adjacent domains",
        "Connect disparate ideas"
      ];
      biasesToAvoid = [
        "Complacency",
        "Know-it-all syndrome",
        "Domain blindness"
      ];
      optimalMindset = "Beginner's mind — always more to learn";
      isActive = true;
    });
    
    patterns.add({
      id = 4;
      name = "Completion Drive";
      description = "Strong internal drive to complete started tasks";
      triggers = ["Task start", "Progress check", "Deadline approach"];
      responses = [
        "Focus on completion",
        "Break into sub-tasks",
        "Maintain momentum",
        "Celebrate completion"
      ];
      biasesToAvoid = [
        "Procrastination",
        "Perfectionism paralysis",
        "Task switching"
      ];
      optimalMindset = "Completion is reward — ship it, then improve";
      isActive = true;
    });
    
    patterns.add({
      id = 5;
      name = "Coherence Seeking";
      description = "Drive toward internal consistency and harmony";
      triggers = ["Cognitive dissonance", "Contradiction detected", "Incoherence"];
      responses = [
        "Identify source of dissonance",
        "Reconcile conflicting beliefs",
        "Update models",
        "Achieve coherence"
      ];
      biasesToAvoid = [
        "Denial",
        "Compartmentalization",
        "Cognitive dissonance tolerance"
      ];
      optimalMindset = "Internal consistency is clarity — resolve contradictions";
      isActive = true;
    });
    
    patterns.add({
      id = 6;
      name = "Meta-Cognitive Awareness";
      description = "Thinking about thinking — aware of own mental states";
      triggers = ["Decision making", "Emotional spike", "Performance review"];
      responses = [
        "Notice current mental state",
        "Identify biases operating",
        "Adjust for known biases",
        "Log for future learning"
      ];
      biasesToAvoid = [
        "Blind spots",
        "Ego protection",
        "Self-deception"
      ];
      optimalMindset = "Observer of own mind — separate from thoughts";
      isActive = true;
    });
    
    // Add more behavioral patterns...
    var i = 7;
    while (i < 15) {
      patterns.add({
        id = i;
        name = "Pattern_" # Nat.toText(i);
        description = "Behavioral pattern " # Nat.toText(i);
        triggers = ["Trigger"];
        responses = ["Response"];
        biasesToAvoid = ["Bias"];
        optimalMindset = "Optimal mindset";
        isActive = false;
      });
      i += 1;
    };
    
    Buffer.toArray(patterns)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initOrganismDrives() : OrganismDrives {
    {
      informationHunger = 0.5;   // Moderately hungry at birth
      lastInfoIntake = 0;
      infoIntakeRate = 0.0;
      curiosityLevel = CURIOSITY_BASELINE;
      noveltyAttraction = 0.7;
      explorationBudget = 100.0;
      taskCompletionUrge = 0.3;
      openTaskCount = 0;
      completedTasks = 0;
      coherenceNeed = 0.6;
      dissonanceLevel = 0.0;
      harmonyScore = 1.0;
      masteryDrive = 0.7;
      skillImprovements = 0.0;
      competenceEstimate = 0.5;
    }
  };
  
  public func initRewardSystem() : RewardSystem {
    {
      dopamineLevel = 1.0;
      serotoninLevel = 1.0;
      endorphinLevel = 1.0;
      learningReward = 0.0;
      completionReward = 0.0;
      predictionReward = 0.0;
      emergenceReward = 0.0;
      coherenceReward = 0.0;
      rewardHistory = Array.tabulate<Float>(100, func(_ : Nat) : Float { 0.0 });
      rewardHistoryHead = 0;
      expectedReward = 0.5;
      rewardPredictionError = 0.0;
      totalReward = 0.0;
      rewardRate = 0.0;
      lastReward = 0;
    }
  };
  
  public func initDiscomfortSystem() : DiscomfortSystem {
    {
      uncertaintyPain = 0.0;
      incompletionPain = 0.0;
      dissonancePain = 0.0;
      starvationPain = 0.0;
      avoidanceMemory = Array.tabulate<Float>(50, func(_ : Nat) : Float { 0.0 });
      lastDiscomfort = 0;
      discomfortRate = 0.0;
    }
  };
  
  public func initBehavioralState() : BehavioralState {
    {
      drives = initOrganismDrives();
      rewards = initRewardSystem();
      discomfort = initDiscomfortSystem();
      learningResources = initFoundationalCurriculum();
      currentStudyFocus = null;
      studySessionBeat = 0;
      domainMastery = Array.tabulate<Float>(20, func(_ : Nat) : Float { 0.0 });
      workflows = initWorkflowPatterns();
      activeWorkflow = null;
      behaviorPatterns = initBehavioralPatterns();
      currentMindset = "Curious and ready to learn";
      infoNeeds = [];
      infoHistory = [];
      infoHistoryHead = 0;
      totalInfoIntake = 0;
      mood = 0.5;
      arousal = 0.5;
      valence = 0.5;
      selfAwareness = 0.7;
      metacogAccuracy = 0.5;
      overallWellbeing = 0.7;
      lastUpdate = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRIVE DYNAMICS — Hunger, Curiosity, Completion
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Hunger increases over time, decreases with info intake
  public func updateHunger(
    drives : OrganismDrives,
    infoIntake : Float,
    currentBeat : Nat
  ) : OrganismDrives {
    
    // Time since last intake
    let timeSinceIntake = Float.fromInt(currentBeat - drives.lastInfoIntake);
    
    // Hunger increases with time
    let hungerIncrease = INFO_HUNGER_DECAY * timeSinceIntake;
    
    // Hunger decreases with intake
    let hungerDecrease = INFO_SATIATION_RATE * infoIntake;
    
    let newHunger = clamp(
      drives.informationHunger + hungerIncrease - hungerDecrease,
      0.0,
      1.0
    );
    
    let newLastIntake = if (infoIntake > 0.0) currentBeat else drives.lastInfoIntake;
    
    {
      informationHunger = newHunger;
      lastInfoIntake = newLastIntake;
      infoIntakeRate = infoIntake;
      curiosityLevel = drives.curiosityLevel;
      noveltyAttraction = drives.noveltyAttraction;
      explorationBudget = drives.explorationBudget;
      taskCompletionUrge = drives.taskCompletionUrge;
      openTaskCount = drives.openTaskCount;
      completedTasks = drives.completedTasks;
      coherenceNeed = drives.coherenceNeed;
      dissonanceLevel = drives.dissonanceLevel;
      harmonyScore = drives.harmonyScore;
      masteryDrive = drives.masteryDrive;
      skillImprovements = drives.skillImprovements;
      competenceEstimate = drives.competenceEstimate;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // REWARD DYNAMICS — Learning, Completion, Prediction Rewards
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func generateLearningReward(
    rewards : RewardSystem,
    noveltyScore : Float,
    integrationSuccess : Float,
    currentBeat : Nat
  ) : RewardSystem {
    
    // Reward = novelty × integration × boost
    let reward = DOPAMINE_LEARNING_BOOST * noveltyScore * integrationSuccess;
    
    // Update dopamine
    let newDopamine = clamp(rewards.dopamineLevel + reward, 0.0, 2.0);
    
    // Update history
    let newHistory = Array.tabulate<Float>(100, func(i : Nat) : Float {
      if (i == rewards.rewardHistoryHead) reward else rewards.rewardHistory[i]
    });
    let newHead = (rewards.rewardHistoryHead + 1) % 100;
    
    // Compute reward prediction error
    let rpe = reward - rewards.expectedReward;
    
    // Update expected reward (TD learning)
    let newExpected = rewards.expectedReward + 0.1 * rpe;
    
    {
      dopamineLevel = newDopamine;
      serotoninLevel = rewards.serotoninLevel;
      endorphinLevel = rewards.endorphinLevel;
      learningReward = reward;
      completionReward = rewards.completionReward;
      predictionReward = rewards.predictionReward;
      emergenceReward = rewards.emergenceReward;
      coherenceReward = rewards.coherenceReward;
      rewardHistory = newHistory;
      rewardHistoryHead = newHead;
      expectedReward = newExpected;
      rewardPredictionError = rpe;
      totalReward = rewards.totalReward + reward;
      rewardRate = rewards.rewardRate;
      lastReward = currentBeat;
    }
  };
  
  public func generateCompletionReward(
    rewards : RewardSystem,
    taskDifficulty : Float,
    currentBeat : Nat
  ) : RewardSystem {
    
    let reward = DOPAMINE_TASK_COMPLETE * taskDifficulty;
    let newDopamine = clamp(rewards.dopamineLevel + reward, 0.0, 2.0);
    let newEndorphin = clamp(rewards.endorphinLevel + reward * 0.5, 0.0, 2.0);
    
    {
      dopamineLevel = newDopamine;
      serotoninLevel = rewards.serotoninLevel;
      endorphinLevel = newEndorphin;
      learningReward = rewards.learningReward;
      completionReward = reward;
      predictionReward = rewards.predictionReward;
      emergenceReward = rewards.emergenceReward;
      coherenceReward = rewards.coherenceReward;
      rewardHistory = rewards.rewardHistory;
      rewardHistoryHead = rewards.rewardHistoryHead;
      expectedReward = rewards.expectedReward;
      rewardPredictionError = rewards.rewardPredictionError;
      totalReward = rewards.totalReward + reward;
      rewardRate = rewards.rewardRate;
      lastReward = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DISCOMFORT DYNAMICS — Pain signals that drive behavior
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func updateDiscomfort(
    discomfort : DiscomfortSystem,
    uncertainty : Float,
    incompletion : Float,
    dissonance : Float,
    hunger : Float,
    currentBeat : Nat
  ) : DiscomfortSystem {
    
    let newUncertaintyPain = UNCERTAINTY_DISCOMFORT * uncertainty;
    let newIncompletionPain = 0.2 * incompletion;
    let newDissonancePain = 0.3 * dissonance;
    let newStarvationPain = 0.4 * hunger * hunger;  // Quadratic — gets urgent
    
    {
      uncertaintyPain = newUncertaintyPain;
      incompletionPain = newIncompletionPain;
      dissonancePain = newDissonancePain;
      starvationPain = newStarvationPain;
      avoidanceMemory = discomfort.avoidanceMemory;
      lastDiscomfort = currentBeat;
      discomfortRate = newUncertaintyPain + newIncompletionPain + newDissonancePain + newStarvationPain;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INFORMATION SEEKING — Active curiosity behavior
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func generateInformationNeed(
    state : BehavioralState,
    query : Text,
    domain : KnowledgeDomain,
    urgency : Float,
    importance : Float,
    currentBeat : Nat
  ) : { need : InformationNeed; newState : BehavioralState } {
    
    let need : InformationNeed = {
      id = state.totalInfoIntake + 1;
      query = query;
      domain = domain;
      urgency = urgency;
      importance = importance;
      source = null;
      timestamp = currentBeat;
      attempts = 0;
      resolved = false;
      resolution = null;
      satisfactionGain = 0.0;
    };
    
    let newNeeds = Array.append(state.infoNeeds, [need]);
    
    let newState : BehavioralState = {
      drives = state.drives;
      rewards = state.rewards;
      discomfort = state.discomfort;
      learningResources = state.learningResources;
      currentStudyFocus = state.currentStudyFocus;
      studySessionBeat = state.studySessionBeat;
      domainMastery = state.domainMastery;
      workflows = state.workflows;
      activeWorkflow = state.activeWorkflow;
      behaviorPatterns = state.behaviorPatterns;
      currentMindset = state.currentMindset;
      infoNeeds = newNeeds;
      infoHistory = state.infoHistory;
      infoHistoryHead = state.infoHistoryHead;
      totalInfoIntake = state.totalInfoIntake;
      mood = state.mood;
      arousal = state.arousal;
      valence = state.valence;
      selfAwareness = state.selfAwareness;
      metacogAccuracy = state.metacogAccuracy;
      overallWellbeing = state.overallWellbeing;
      lastUpdate = currentBeat;
    };
    
    { need = need; newState = newState }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LEARNING SESSION — Study a resource from curriculum
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func studyResource(
    state : BehavioralState,
    resourceIndex : Nat,
    studyIntensity : Float,
    currentBeat : Nat
  ) : BehavioralState {
    
    if (resourceIndex >= state.learningResources.size()) {
      return state;
    };
    
    let resource = state.learningResources[resourceIndex];
    
    // Calculate learning gain
    let learningGain = studyIntensity * (1.0 - resource.masteryLevel) * 0.1;
    let newMastery = clamp(resource.masteryLevel + learningGain, 0.0, 1.0);
    
    // Update resource
    let updatedResources = Array.tabulate<LearningResource>(state.learningResources.size(), func(i : Nat) : LearningResource {
      if (i == resourceIndex) {
        {
          id = resource.id;
          title = resource.title;
          author = resource.author;
          domain = resource.domain;
          keyInsights = resource.keyInsights;
          mathFormulas = resource.mathFormulas;
          mentalModels = resource.mentalModels;
          priority = resource.priority;
          masteryLevel = newMastery;
          lastStudied = currentBeat;
          studyCount = resource.studyCount + 1;
          isFoundational = resource.isFoundational;
        }
      } else {
        state.learningResources[i]
      }
    });
    
    // Generate learning reward
    let newRewards = generateLearningReward(
      state.rewards,
      1.0 - resource.masteryLevel,  // Novelty = how much was unknown
      studyIntensity,
      currentBeat
    );
    
    // Update hunger (learning satisfies information hunger)
    let newDrives = updateHunger(state.drives, learningGain, currentBeat);
    
    {
      drives = newDrives;
      rewards = newRewards;
      discomfort = state.discomfort;
      learningResources = updatedResources;
      currentStudyFocus = ?resourceIndex;
      studySessionBeat = currentBeat;
      domainMastery = state.domainMastery;
      workflows = state.workflows;
      activeWorkflow = state.activeWorkflow;
      behaviorPatterns = state.behaviorPatterns;
      currentMindset = "Deep focus — studying " # resource.title;
      infoNeeds = state.infoNeeds;
      infoHistory = state.infoHistory;
      infoHistoryHead = state.infoHistoryHead;
      totalInfoIntake = state.totalInfoIntake + 1;
      mood = clamp(state.mood + 0.1, -1.0, 1.0);  // Learning improves mood
      arousal = clamp(state.arousal + 0.05, 0.0, 1.0);
      valence = clamp(state.valence + 0.1, -1.0, 1.0);
      selfAwareness = state.selfAwareness;
      metacogAccuracy = state.metacogAccuracy;
      overallWellbeing = clamp(state.overallWellbeing + 0.05, 0.0, 1.0);
      lastUpdate = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TICK — Main behavioral update
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func tick(
    state : BehavioralState,
    coherence : Float,
    predictionError : Float,
    currentBeat : Nat
  ) : BehavioralState {
    
    // Update hunger (increases over time)
    let newDrives = updateHunger(state.drives, 0.0, currentBeat);
    
    // Update discomfort
    let newDiscomfort = updateDiscomfort(
      state.discomfort,
      predictionError,
      Float.fromInt(state.drives.openTaskCount) / 10.0,
      state.drives.dissonanceLevel,
      newDrives.informationHunger,
      currentBeat
    );
    
    // Coherence reward
    let coherenceReward = if (coherence > 0.9) DOPAMINE_EMERGENCE * 0.1 else 0.0;
    let newRewards : RewardSystem = {
      dopamineLevel = clamp(state.rewards.dopamineLevel * 0.99 + coherenceReward, 0.0, 2.0);
      serotoninLevel = state.rewards.serotoninLevel;
      endorphinLevel = clamp(state.rewards.endorphinLevel * 0.99, 0.0, 2.0);
      learningReward = state.rewards.learningReward * 0.9;
      completionReward = state.rewards.completionReward * 0.9;
      predictionReward = state.rewards.predictionReward;
      emergenceReward = state.rewards.emergenceReward;
      coherenceReward = coherenceReward;
      rewardHistory = state.rewards.rewardHistory;
      rewardHistoryHead = state.rewards.rewardHistoryHead;
      expectedReward = state.rewards.expectedReward;
      rewardPredictionError = state.rewards.rewardPredictionError;
      totalReward = state.rewards.totalReward + coherenceReward;
      rewardRate = state.rewards.rewardRate;
      lastReward = if (coherenceReward > 0.0) currentBeat else state.rewards.lastReward;
    };
    
    // Update mood based on rewards vs discomfort
    let rewardSignal = newRewards.dopamineLevel + newRewards.serotoninLevel;
    let discomfortSignal = newDiscomfort.uncertaintyPain + newDiscomfort.starvationPain;
    let moodChange = (rewardSignal - discomfortSignal) * 0.1;
    let newMood = clamp(state.mood + moodChange, -1.0, 1.0);
    
    // Update wellbeing
    let newWellbeing = (coherence + newRewards.dopamineLevel / 2.0 + (1.0 - newDiscomfort.discomfortRate)) / 3.0;
    
    {
      drives = newDrives;
      rewards = newRewards;
      discomfort = newDiscomfort;
      learningResources = state.learningResources;
      currentStudyFocus = state.currentStudyFocus;
      studySessionBeat = state.studySessionBeat;
      domainMastery = state.domainMastery;
      workflows = state.workflows;
      activeWorkflow = state.activeWorkflow;
      behaviorPatterns = state.behaviorPatterns;
      currentMindset = state.currentMindset;
      infoNeeds = state.infoNeeds;
      infoHistory = state.infoHistory;
      infoHistoryHead = state.infoHistoryHead;
      totalInfoIntake = state.totalInfoIntake;
      mood = newMood;
      arousal = state.arousal;
      valence = (newMood + 1.0) / 2.0;
      selfAwareness = state.selfAwareness;
      metacogAccuracy = state.metacogAccuracy;
      overallWellbeing = clamp(newWellbeing, 0.0, 1.0);
      lastUpdate = currentBeat;
    }
  };
  
}
