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


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ████████╗██████╗  █████╗ ██████╗ ██╗███╗   ██╗ ██████╗     ██████╗ ███████╗██╗   ██╗ ██████╗██╗  ██╗
// ╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝     ██╔══██╗██╔════╝╚██╗ ██╔╝██╔════╝██║  ██║
//    ██║   ██████╔╝███████║██║  ██║██║██╔██╗ ██║██║  ███╗    ██████╔╝███████╗ ╚████╔╝ ██║     ███████║
//    ██║   ██╔══██╗██╔══██║██║  ██║██║██║╚██╗██║██║   ██║    ██╔═══╝ ╚════██║  ╚██╔╝  ██║     ██╔══██║
//    ██║   ██║  ██║██║  ██║██████╔╝██║██║ ╚████║╚██████╔╝    ██║     ███████║   ██║   ╚██████╗██║  ██║
//    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// TRADING PSYCHOLOGY ARCHITECTURE
// Integration of: Trading in the Zone, Market Wizards, Market Mind Games, 
//                 Trading to Win, Principles (Dalio), Stoicism
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — TRADING PSYCHOLOGY AS NEURAL ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ══ BOOK 1: TRADING IN THE ZONE (Mark Douglas) ══════════════════════════════
//   Core Principles:
//     1. PROBABILISTIC THINKING — Every trade has uncertain outcome
//        • P(win) = edge × execution × market_conditions
//        • Each trade is ONE of many — focus on process, not outcome
//        • Expected value: EV = Σ(outcome_i × P(outcome_i))
//
//     2. BELIEF SYSTEMS — Beliefs shape perception and action
//        • Limiting beliefs create self-fulfilling failures
//        • Empowering beliefs enable consistent execution
//        • Belief audit: identify and replace limiting beliefs
//
//     3. FLOW STATE TRADING — The "Zone"
//        • Effortless execution without emotional interference
//        • State equation: Flow = skill_match × challenge_level × focus
//        • Arousal sweet spot: not too calm, not too anxious
//
//     4. ACCEPTING RISK — Pre-accept loss before entry
//        • Risk_accepted = position_size × stop_distance
//        • If can't accept risk → don't take trade
//        • Risk acceptance removes emotional attachment
//
// ══ BOOK 2: MARKET WIZARDS (Jack Schwager) ══════════════════════════════════
//   Core Principles:
//     1. CUT LOSSES SHORT — The #1 rule
//        • Max loss per trade: R_max = capital × risk_percent
//        • Stop loss: non-negotiable exit point
//        • "Losers average losers"
//
//     2. LET PROFITS RUN — Don't cut winners
//        • Trailing stop preserves gains while allowing growth
//        • Profit target scaling: take partial at 1R, 2R, 3R
//        • "You can't go broke taking profits" is FALSE
//
//     3. POSITION SIZING — The key to survival
//        • Size = (capital × risk_percent) / stop_distance
//        • Kelly criterion: f* = (bp - q) / b
//        • Never bet more than you can afford to lose
//
//     4. DISCIPLINE — Follow the system
//        • Rules exist for a reason
//        • Deviation = eventual destruction
//        • Discipline score: adherence / opportunities
//
// ══ BOOK 3: MARKET MIND GAMES (Denise Shull) ════════════════════════════════
//   Core Principles:
//     1. EMOTIONS AS DATA — Not noise to be suppressed
//        • Fear = information about perceived risk
//        • Greed = information about opportunity
//        • Emotional signal processing, not emotional suppression
//
//     2. UNCERTAINTY NAVIGATION — Embrace, don't fight
//        • Uncertainty is constant — accept it
//        • Confidence in process, not in predictions
//        • Scenario planning over single-path thinking
//
//     3. SELF-AWARENESS — Know your patterns
//        • Trading journal: decisions, emotions, outcomes
//        • Pattern recognition in own behavior
//        • Trigger identification and management
//
// ══ BOOK 4: TRADING TO WIN (Ari Kiev) ═══════════════════════════════════════
//   Core Principles:
//     1. PEAK PERFORMANCE — Trading as elite sport
//        • Mental rehearsal before trading
//        • Visualization of successful execution
//        • Post-session review and improvement
//
//     2. COMMITMENT — Full dedication to the craft
//        • Commitment score = effort × consistency × growth
//        • No half-measures in trading
//        • Professional mindset always
//
//     3. GOAL SETTING — Clear, measurable targets
//        • SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound
//        • Process goals > outcome goals
//        • Daily, weekly, monthly, yearly targets
//
// ══ BOOK 5: PRINCIPLES (Ray Dalio) ══════════════════════════════════════════
//   Core Principles:
//     1. RADICAL TRUTH — See reality as it is
//        • No wishful thinking
//        • Data over opinion
//        • Challenge assumptions constantly
//
//     2. RADICAL TRANSPARENCY — Share information
//        • Hide nothing from self
//        • Document everything
//        • Learn from all outcomes
//
//     3. PAIN + REFLECTION = PROGRESS
//        • Losses are tuition
//        • Every failure is a lesson
//        • Systematic improvement process
//
//     4. SYSTEMATIC DECISION-MAKING — Algorithms over intuition
//        • Codify principles into rules
//        • Remove emotion from execution
//        • Backtest everything
//
// ══ BOOK 6: STOICISM ════════════════════════════════════════════════════════
//   Core Principles:
//     1. CONTROL DICHOTOMY — Focus only on controllables
//        • Controllable: entry, exit, size, system
//        • Uncontrollable: market direction, other traders, news
//        • Energy allocation: 100% to controllables
//
//     2. EMOTIONAL REGULATION — Respond, don't react
//        • Pause between stimulus and response
//        • Premeditatio malorum: visualize worst case
//        • Negative visualization reduces emotional impact
//
//     3. ACCEPTANCE — Amor fati (love of fate)
//        • Accept outcomes without attachment
//        • The market is neither friend nor enemy
//        • Every outcome is correct — only our expectation was wrong
//
//     4. VIRTUE — Character over profit
//        • Discipline, courage, wisdom, justice
//        • Sustainable success requires virtue
//        • Short-term gains from vice lead to long-term destruction
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module TradingPsychologyArchitecture {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.6180339887498948482;
  public let PSI : Float = 0.6180339887498948482;
  public let E : Float = 2.7182818284590452354;
  public let PI : Float = 3.14159265358979323846;
  
  // Loss aversion (from BehavioralEconomics)
  public let LOSS_AVERSION_LAMBDA : Float = 2.25;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TRADING IN THE ZONE — PROBABILISTIC MINDSET
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type BeliefType = {
    #Empowering;
    #Limiting;
    #Neutral;
  };
  
  public type Belief = {
    content : Text;
    beliefType : BeliefType;
    strength : Float;           // [0, 1] how strongly held
    evidenceFor : Nat;          // Count of supporting evidence
    evidenceAgainst : Nat;      // Count of contradicting evidence
    lastUpdated : Nat;
  };
  
  public type FlowState = {
    isInFlow : Bool;
    flowIntensity : Float;      // [0, 1]
    skillLevel : Float;
    challengeLevel : Float;
    focusLevel : Float;
    arousalLevel : Float;       // Yerkes-Dodson optimal
    durationBeats : Nat;
  };
  
  public type RiskAcceptance = {
    maxRiskPerTrade : Float;    // % of capital
    currentRiskAccepted : Float;
    riskEmotionalAttachment : Float;  // Lower is better
    preAccepted : Bool;         // Did we accept before entry?
  };
  
  // Probabilistic thinking — every outcome is one of many
  public func computeExpectedValue(
    outcomes : [Float],
    probabilities : [Float]
  ) : Float {
    var ev : Float = 0.0;
    let n = if (outcomes.size() < probabilities.size()) { outcomes.size() } else { probabilities.size() };
    var i = 0;
    while (i < n) {
      ev += outcomes[i] * probabilities[i];
      i += 1;
    };
    ev
  };
  
  // Flow state computation
  public func computeFlowState(
    skill : Float,
    challenge : Float,
    focus : Float,
    arousal : Float
  ) : FlowState {
    // Flow occurs when skill matches challenge and focus is high
    let skillChallengeMatch = 1.0 - _abs(skill - challenge);
    
    // Arousal should be moderate (Yerkes-Dodson)
    let optimalArousal = 0.5;
    let arousalFit = 1.0 - _abs(arousal - optimalArousal) * 2.0;
    
    let flowIntensity = skillChallengeMatch * focus * _clamp(arousalFit, 0.0, 1.0);
    
    {
      isInFlow = flowIntensity > 0.7;
      flowIntensity = flowIntensity;
      skillLevel = skill;
      challengeLevel = challenge;
      focusLevel = focus;
      arousalLevel = arousal;
      durationBeats = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MARKET WIZARDS — DISCIPLINE & POSITION SIZING
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type PositionSizing = {
    capitalAtRisk : Float;
    riskPercent : Float;        // e.g., 0.02 for 2%
    stopDistance : Float;       // Price units to stop
    positionSize : Float;       // Calculated size
    kellyFraction : Float;      // Optimal Kelly bet
  };
  
  public type DisciplineScore = {
    rulesFollowed : Nat;
    rulesAvailable : Nat;
    adherenceRate : Float;
    deviations : [Text];
    streak : Nat;               // Consecutive disciplined actions
  };
  
  public type TradeManagement = {
    cutLossesShort : Bool;      // Did we honor stops?
    letProfitsRun : Bool;       // Did we avoid premature exits?
    trailingStopActive : Bool;
    partialTakesProfits : [Float];  // R-multiples where we took partial
  };
  
  // Position sizing formula: Size = (Capital × Risk%) / Stop Distance
  public func calculatePositionSize(
    capital : Float,
    riskPercent : Float,
    stopDistance : Float
  ) : Float {
    if (stopDistance <= 0.0) { return 0.0 };
    (capital * riskPercent) / stopDistance
  };
  
  // Kelly Criterion: f* = (bp - q) / b
  // b = odds (win/loss ratio), p = win probability, q = 1-p
  public func kellyFraction(
    winRate : Float,
    avgWin : Float,
    avgLoss : Float
  ) : Float {
    if (avgLoss <= 0.0) { return 0.0 };
    let b = avgWin / avgLoss;  // Win/loss ratio
    let p = winRate;
    let q = 1.0 - p;
    let kelly = (b * p - q) / b;
    _clamp(kelly, 0.0, 1.0)  // Never more than 100% (and never negative)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MARKET MIND GAMES — EMOTIONS AS DATA
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type EmotionalSignal = {
    #Fear : Float;              // Risk perception intensity
    #Greed : Float;             // Opportunity perception intensity
    #Hope : Float;              // Optimism bias
    #Regret : Float;            // Past decision pain
    #Anxiety : Float;           // Uncertainty discomfort
    #Excitement : Float;        // Opportunity excitement
    #Frustration : Float;       // Blocked goal energy
    #Confidence : Float;        // Self-assurance level
  };
  
  public type EmotionalState = {
    dominantEmotion : EmotionalSignal;
    fearLevel : Float;
    greedLevel : Float;
    hopeLevel : Float;
    regretLevel : Float;
    anxietyLevel : Float;
    excitementLevel : Float;
    frustrationLevel : Float;
    confidenceLevel : Float;
    overallValence : Float;     // Positive vs negative [-1, 1]
    overallArousal : Float;     // Calm vs excited [0, 1]
  };
  
  public type TradingJournal = {
    entries : [JournalEntry];
    patterns : [BehaviorPattern];
    triggers : [EmotionalTrigger];
  };
  
  public type JournalEntry = {
    beat : Nat;
    decision : Text;
    emotionsBefore : EmotionalState;
    emotionsAfter : EmotionalState;
    outcome : Float;            // P&L
    lessonsLearned : [Text];
  };
  
  public type BehaviorPattern = {
    trigger : Text;
    behavior : Text;
    frequency : Nat;
    profitability : Float;      // Average outcome when pattern occurs
    shouldContinue : Bool;
  };
  
  public type EmotionalTrigger = {
    stimulus : Text;
    emotionalResponse : EmotionalSignal;
    behavioralResponse : Text;
    isProductive : Bool;
  };
  
  // Emotions as data — interpret, don't suppress
  public func interpretEmotionalSignal(emotion : EmotionalSignal) : Text {
    switch (emotion) {
      case (#Fear(intensity)) {
        if (intensity > 0.7) { "HIGH RISK PERCEIVED — verify or reduce exposure" }
        else if (intensity > 0.4) { "Moderate caution — review position size" }
        else { "Healthy vigilance — proceed with plan" }
      };
      case (#Greed(intensity)) {
        if (intensity > 0.7) { "OVEREXCITEMENT — reduce size, stick to rules" }
        else if (intensity > 0.4) { "Opportunity detected — verify with system" }
        else { "Normal opportunity assessment" }
      };
      case (#Hope(intensity)) {
        if (intensity > 0.5) { "WARNING: Hope is not a strategy — check stop" }
        else { "Optimism within bounds" }
      };
      case (#Regret(intensity)) {
        if (intensity > 0.5) { "Regret detected — don't revenge trade" }
        else { "Normal post-decision reflection" }
      };
      case (#Anxiety(intensity)) {
        if (intensity > 0.7) { "High anxiety — reduce position or step away" }
        else { "Manageable uncertainty" }
      };
      case (#Excitement(intensity)) {
        if (intensity > 0.7) { "Overexcitement — slow down, verify edge" }
        else { "Healthy engagement" }
      };
      case (#Frustration(intensity)) {
        if (intensity > 0.5) { "Frustration building — take a break" }
        else { "Minor frustration — normal" }
      };
      case (#Confidence(intensity)) {
        if (intensity > 0.9) { "OVERCONFIDENCE — danger zone, reduce size" }
        else if (intensity < 0.3) { "Low confidence — verify edge or stand aside" }
        else { "Healthy confidence level" }
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TRADING TO WIN — PEAK PERFORMANCE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type MentalRehearsal = {
    scenario : Text;
    visualizedOutcome : Text;
    emotionalPreparation : Text;
    actionPlan : [Text];
    rehearsalCount : Nat;
    lastRehearsalBeat : Nat;
  };
  
  public type CommitmentLevel = {
    effort : Float;             // [0, 1]
    consistency : Float;        // [0, 1]
    growthFocus : Float;        // [0, 1]
    overallCommitment : Float;  // Weighted combination
  };
  
  public type SMARTGoal = {
    description : Text;
    specific : Bool;
    measurable : Bool;
    achievable : Bool;
    relevant : Bool;
    timeBound : Bool;
    deadline : Nat;             // Beat deadline
    progress : Float;           // [0, 1]
    isProcessGoal : Bool;       // Process > outcome
  };
  
  // Commitment calculation
  public func computeCommitment(
    effort : Float,
    consistency : Float,
    growthFocus : Float
  ) : CommitmentLevel {
    let overall = effort * 0.4 + consistency * 0.4 + growthFocus * 0.2;
    {
      effort = effort;
      consistency = consistency;
      growthFocus = growthFocus;
      overallCommitment = overall;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PRINCIPLES (DALIO) — RADICAL TRUTH & SYSTEMATIC DECISIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type RadicalTruth = {
    observation : Text;
    dataSupport : Float;        // [0, 1] how much data supports
    opinionBias : Float;        // [0, 1] how much is opinion
    assumptions : [Text];
    challengedBy : [Text];      // Counter-arguments
  };
  
  public type PainReflection = {
    painSource : Text;
    painIntensity : Float;      // [0, 1]
    lessonsExtracted : [Text];
    progressMade : Float;       // [0, 1]
    implementedChanges : [Text];
  };
  
  public type SystematicDecision = {
    inputFactors : [Text];
    weights : [Float];
    threshold : Float;
    currentScore : Float;
    decision : Bool;            // Above threshold = yes
    humanOverride : Bool;       // Was system overridden?
  };
  
  // Pain + Reflection = Progress
  public func processLoss(
    lossAmount : Float,
    lossContext : Text
  ) : PainReflection {
    let painIntensity = _clamp(lossAmount * LOSS_AVERSION_LAMBDA * 0.1, 0.0, 1.0);
    {
      painSource = lossContext;
      painIntensity = painIntensity;
      lessonsExtracted = [];  // To be filled by reflection
      progressMade = 0.0;     // To be updated over time
      implementedChanges = [];
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STOICISM — EMOTIONAL REGULATION & CONTROL DICHOTOMY
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ControlCategory = {
    #FullyControllable;
    #PartiallyControllable;
    #Uncontrollable;
  };
  
  public type ControlDichotomy = {
    factor : Text;
    category : ControlCategory;
    energyAllocated : Float;    // Should be 0 for uncontrollable
    shouldReallocate : Bool;
  };
  
  public type StoicVirtue = {
    #Discipline;
    #Courage;
    #Wisdom;
    #Justice;
  };
  
  public type VirtueScore = {
    discipline : Float;         // Following rules
    courage : Float;            // Taking calculated risks
    wisdom : Float;             // Making good decisions
    justice : Float;            // Fair dealing
    overallVirtue : Float;
  };
  
  public type NegativeVisualization = {
    worstCaseScenario : Text;
    emotionalImpact : Float;    // Expected impact [0, 1]
    actualizedImpact : Float;   // Reduced after visualization
    prepared : Bool;
  };
  
  // Control dichotomy — categorize factors
  public func categorizeControl(factor : Text, context : Text) : ControlCategory {
    // Simple heuristic — in practice, would need more sophisticated analysis
    let controllableKeywords = ["entry", "exit", "size", "stop", "system", "rules", "preparation"];
    let uncontrollableKeywords = ["market", "news", "others", "economy", "weather", "politics"];
    
    // Default to partially controllable
    #PartiallyControllable
  };
  
  // Virtue score computation
  public func computeVirtueScore(
    rulesFollowed : Float,      // Discipline
    risksManaged : Float,       // Courage
    goodDecisions : Float,      // Wisdom
    fairDealing : Float         // Justice
  ) : VirtueScore {
    let overall = rulesFollowed * 0.3 + risksManaged * 0.25 + goodDecisions * 0.35 + fairDealing * 0.1;
    {
      discipline = rulesFollowed;
      courage = risksManaged;
      wisdom = goodDecisions;
      justice = fairDealing;
      overallVirtue = overall;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRATED TRADING PSYCHOLOGY STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type TradingPsychologyState = {
    // Trading in the Zone
    beliefs : [Belief];
    flowState : FlowState;
    riskAcceptance : RiskAcceptance;
    probabilisticThinking : Float;  // [0, 1] how probabilistic
    
    // Market Wizards
    positionSizing : PositionSizing;
    discipline : DisciplineScore;
    tradeManagement : TradeManagement;
    
    // Market Mind Games
    emotionalState : EmotionalState;
    journal : TradingJournal;
    selfAwareness : Float;          // [0, 1]
    
    // Trading to Win
    mentalRehearsal : MentalRehearsal;
    commitment : CommitmentLevel;
    goals : [SMARTGoal];
    peakPerformance : Float;        // [0, 1]
    
    // Principles
    radicalTruth : Float;           // [0, 1] adherence
    radicalTransparency : Float;
    painReflections : [PainReflection];
    
    // Stoicism
    controlDichotomy : [ControlDichotomy];
    virtue : VirtueScore;
    negativeVisualization : NegativeVisualization;
    emotionalRegulation : Float;    // [0, 1]
    acceptance : Float;             // Amor fati level
    
    // Overall
    tradingEdge : Float;            // Combined edge estimate
    psychologicalCapital : Float;   // Mental resources
    beatNum : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  func _sqrt(x : Float) : Float { 
    if (x <= 0.0) 0.0 else Float.sqrt(x) 
  };
  
  func _exp(x : Float) : Float {
    let xc = _clamp(x, -20.0, 20.0);
    Float.exp(xc)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initTradingPsychology(currentBeat : Nat) : TradingPsychologyState {
    {
      // Trading in the Zone
      beliefs = [];
      flowState = {
        isInFlow = false;
        flowIntensity = 0.0;
        skillLevel = 0.5;
        challengeLevel = 0.5;
        focusLevel = 0.5;
        arousalLevel = 0.5;
        durationBeats = 0;
      };
      riskAcceptance = {
        maxRiskPerTrade = 0.02;  // 2%
        currentRiskAccepted = 0.0;
        riskEmotionalAttachment = 0.5;
        preAccepted = false;
      };
      probabilisticThinking = 0.5;
      
      // Market Wizards
      positionSizing = {
        capitalAtRisk = 0.0;
        riskPercent = 0.02;
        stopDistance = 0.0;
        positionSize = 0.0;
        kellyFraction = 0.0;
      };
      discipline = {
        rulesFollowed = 0;
        rulesAvailable = 0;
        adherenceRate = 1.0;
        deviations = [];
        streak = 0;
      };
      tradeManagement = {
        cutLossesShort = true;
        letProfitsRun = true;
        trailingStopActive = false;
        partialTakesProfits = [];
      };
      
      // Market Mind Games
      emotionalState = {
        dominantEmotion = #Confidence(0.5);
        fearLevel = 0.1;
        greedLevel = 0.1;
        hopeLevel = 0.3;
        regretLevel = 0.0;
        anxietyLevel = 0.1;
        excitementLevel = 0.2;
        frustrationLevel = 0.0;
        confidenceLevel = 0.5;
        overallValence = 0.3;
        overallArousal = 0.4;
      };
      journal = {
        entries = [];
        patterns = [];
        triggers = [];
      };
      selfAwareness = 0.5;
      
      // Trading to Win
      mentalRehearsal = {
        scenario = "";
        visualizedOutcome = "";
        emotionalPreparation = "";
        actionPlan = [];
        rehearsalCount = 0;
        lastRehearsalBeat = 0;
      };
      commitment = {
        effort = 0.7;
        consistency = 0.7;
        growthFocus = 0.7;
        overallCommitment = 0.7;
      };
      goals = [];
      peakPerformance = 0.5;
      
      // Principles
      radicalTruth = 0.7;
      radicalTransparency = 0.7;
      painReflections = [];
      
      // Stoicism
      controlDichotomy = [];
      virtue = {
        discipline = 0.7;
        courage = 0.6;
        wisdom = 0.6;
        justice = 0.8;
        overallVirtue = 0.675;
      };
      negativeVisualization = {
        worstCaseScenario = "Maximum acceptable loss";
        emotionalImpact = 0.5;
        actualizedImpact = 0.3;
        prepared = true;
      };
      emotionalRegulation = 0.6;
      acceptance = 0.5;
      
      // Overall
      tradingEdge = 0.0;
      psychologicalCapital = 1.0;
      beatNum = currentBeat;
    }
  };
  
  // Comprehensive tick update
  public func tickTradingPsychology(
    state : TradingPsychologyState,
    marketConditions : Float,       // [-1, 1] favorable/unfavorable
    recentPnL : Float,
    currentBeat : Nat
  ) : TradingPsychologyState {
    
    // Update emotional state based on P&L
    let newFear = if (recentPnL < 0.0) {
      _clamp(state.emotionalState.fearLevel + _abs(recentPnL) * 0.1, 0.0, 1.0)
    } else {
      _clamp(state.emotionalState.fearLevel * 0.95, 0.0, 1.0)
    };
    
    let newGreed = if (recentPnL > 0.0) {
      _clamp(state.emotionalState.greedLevel + recentPnL * 0.1, 0.0, 1.0)
    } else {
      _clamp(state.emotionalState.greedLevel * 0.9, 0.0, 1.0)
    };
    
    let newConfidence = if (recentPnL > 0.0) {
      _clamp(state.emotionalState.confidenceLevel + recentPnL * 0.05, 0.0, 1.0)
    } else {
      _clamp(state.emotionalState.confidenceLevel - _abs(recentPnL) * 0.1, 0.2, 1.0)
    };
    
    // Update flow state
    let newFocus = _clamp(state.flowState.focusLevel + (marketConditions * 0.05), 0.0, 1.0);
    let newFlow = computeFlowState(
      state.flowState.skillLevel,
      _abs(marketConditions),
      newFocus,
      state.emotionalState.overallArousal
    );
    
    // Update psychological capital (drains under stress)
    let stressLevel = (newFear + state.emotionalState.anxietyLevel) / 2.0;
    let newPsychCapital = _clamp(
      state.psychologicalCapital - stressLevel * 0.01 + 0.005,
      0.1, 1.0
    );
    
    // Update virtue based on discipline
    let newVirtue = computeVirtueScore(
      state.discipline.adherenceRate,
      1.0 - newFear,  // Courage inverse of fear
      newConfidence,
      state.virtue.justice
    );
    
    // Compute trading edge
    let newEdge = state.flowState.flowIntensity * 0.2 +
                  state.discipline.adherenceRate * 0.3 +
                  state.virtue.overallVirtue * 0.2 +
                  state.probabilisticThinking * 0.15 +
                  state.emotionalRegulation * 0.15;
    
    {
      beliefs = state.beliefs;
      flowState = newFlow;
      riskAcceptance = state.riskAcceptance;
      probabilisticThinking = state.probabilisticThinking;
      
      positionSizing = state.positionSizing;
      discipline = state.discipline;
      tradeManagement = state.tradeManagement;
      
      emotionalState = {
        dominantEmotion = if (newFear > newGreed and newFear > newConfidence) {
          #Fear(newFear)
        } else if (newGreed > newConfidence) {
          #Greed(newGreed)
        } else {
          #Confidence(newConfidence)
        };
        fearLevel = newFear;
        greedLevel = newGreed;
        hopeLevel = state.emotionalState.hopeLevel;
        regretLevel = if (recentPnL < 0.0) { _clamp(state.emotionalState.regretLevel + 0.1, 0.0, 0.5) } else { state.emotionalState.regretLevel * 0.9 };
        anxietyLevel = _clamp(newFear * 0.8, 0.0, 1.0);
        excitementLevel = _clamp(newGreed * 0.7 + (if (recentPnL > 0.0) { 0.1 } else { 0.0 }), 0.0, 1.0);
        frustrationLevel = state.emotionalState.frustrationLevel * 0.95;
        confidenceLevel = newConfidence;
        overallValence = (newConfidence - newFear) * 0.5;
        overallArousal = (newFear + newGreed + state.emotionalState.excitementLevel) / 3.0;
      };
      journal = state.journal;
      selfAwareness = state.selfAwareness;
      
      mentalRehearsal = state.mentalRehearsal;
      commitment = state.commitment;
      goals = state.goals;
      peakPerformance = newFlow.flowIntensity * 0.6 + state.peakPerformance * 0.4;
      
      radicalTruth = state.radicalTruth;
      radicalTransparency = state.radicalTransparency;
      painReflections = state.painReflections;
      
      controlDichotomy = state.controlDichotomy;
      virtue = newVirtue;
      negativeVisualization = state.negativeVisualization;
      emotionalRegulation = _clamp(state.emotionalRegulation + (if (stressLevel < 0.3) { 0.01 } else { -0.02 }), 0.3, 1.0);
      acceptance = state.acceptance;
      
      tradingEdge = newEdge;
      psychologicalCapital = newPsychCapital;
      beatNum = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type TradingPsychDiagnostics = {
    overallHealth : Float;
    edgeEstimate : Float;
    psychCapitalStatus : Text;
    emotionalBalance : Text;
    disciplineStatus : Text;
    flowStatus : Text;
    warnings : [Text];
    recommendations : [Text];
  };
  
  public func diagnoseTradingPsych(state : TradingPsychologyState) : TradingPsychDiagnostics {
    let warnings = Buffer.Buffer<Text>(4);
    let recommendations = Buffer.Buffer<Text>(4);
    
    // Check emotional balance
    let emotionalBalance = if (_abs(state.emotionalState.overallValence) < 0.3) { "BALANCED" }
      else if (state.emotionalState.overallValence > 0.3) { "OPTIMISTIC — watch for overconfidence" }
      else { "PESSIMISTIC — ensure proper risk management" };
    
    if (state.emotionalState.fearLevel > 0.7) {
      warnings.add("HIGH FEAR — reduce position size or step away");
    };
    if (state.emotionalState.greedLevel > 0.7) {
      warnings.add("HIGH GREED — stick to position sizing rules");
    };
    if (state.emotionalState.confidenceLevel > 0.9) {
      warnings.add("OVERCONFIDENCE — verify edge before acting");
    };
    
    // Check psychological capital
    let psychCapitalStatus = if (state.psychologicalCapital > 0.7) { "HEALTHY" }
      else if (state.psychologicalCapital > 0.4) { "DEPLETING — take breaks" }
      else { "CRITICAL — rest required" };
    
    if (state.psychologicalCapital < 0.3) {
      recommendations.add("URGENT: Rest and recover psychological capital");
    };
    
    // Check discipline
    let disciplineStatus = if (state.discipline.adherenceRate > 0.9) { "EXCELLENT" }
      else if (state.discipline.adherenceRate > 0.7) { "GOOD" }
      else { "NEEDS IMPROVEMENT" };
    
    // Check flow
    let flowStatus = if (state.flowState.isInFlow) { "IN THE ZONE" }
      else if (state.flowState.flowIntensity > 0.4) { "APPROACHING FLOW" }
      else { "NOT IN FLOW — adjust conditions" };
    
    // Overall health
    let overallHealth = (state.tradingEdge * 0.3 + 
                         state.psychologicalCapital * 0.3 + 
                         state.discipline.adherenceRate * 0.2 + 
                         state.virtue.overallVirtue * 0.2);
    
    {
      overallHealth = overallHealth;
      edgeEstimate = state.tradingEdge;
      psychCapitalStatus = psychCapitalStatus;
      emotionalBalance = emotionalBalance;
      disciplineStatus = disciplineStatus;
      flowStatus = flowStatus;
      warnings = Buffer.toArray(warnings);
      recommendations = Buffer.toArray(recommendations);
    }
  };

}
