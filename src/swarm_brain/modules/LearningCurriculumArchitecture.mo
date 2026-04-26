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
// LEARNING CURRICULUM ARCHITECTURE — Principles Extracted from Foundational Texts
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Classification: CONFIDENTIAL — TRADE SECRET
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// This module extracts ARCHITECTURAL PRINCIPLES from foundational texts and
// implements them as computational structures within the organism.
//
// ┌─────────────────────────────────────────────────────────────────────────────┐
// │ LEARNING CURRICULUM → ARCHITECTURE MAPPING                                  │
// ├─────────────────────────────────────────────────────────────────────────────┤
// │ Trading in the Zone     → Probabilistic state machine, outcome detachment  │
// │ Fooled by Randomness    → Survivorship filter, alternative history buffer  │
// │ Liar's Poker            → Information asymmetry detector, incentive model  │
// │ The Black Swan          → Fat-tail handler, antifragility core            │
// │ Antifragile             → Stressor-strength converter, optionality engine │
// │ Thinking Fast/Slow      → Dual-process architecture, bias detector        │
// │ Influence               → Persuasion pattern recognizer, social dynamics  │
// │ Predictably Irrational  → Irrationality predictor, decoy detector         │
// │ Gödel Escher Bach       → Strange loop detector, self-reference handler   │
// │ Feynman Lectures        → Path integral computer, least action optimizer  │
// │ Information Theory      → Entropy computer, compression engine            │
// │ Free Energy Principle   → Prediction error minimizer, active inference    │
// │ Principles of Neuro     → Ion channel dynamics, plasticity rules          │
// │ Sync                    → Kuramoto synchronizer, phase transition detect  │
// └─────────────────────────────────────────────────────────────────────────────┘
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

module LearningCurriculumArchitecture {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.6180339887498948482;
  public let EULER : Float = 2.7182818284590452354;
  public let PI : Float = 3.1415926535897932385;
  public let TAU : Float = 6.2831853071795864769;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float { if (v < 0.0) -v else v };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var g = x / 2.0; var i = 0;
    while (i < 15) { g := (g + x / g) / 2.0; i += 1 };
    g
  };
  
  public func exp(x : Float) : Float {
    let c = clamp(x, -30.0, 30.0);
    var s = 1.0; var t = 1.0; var i = 1;
    while (i < 20) { t *= c / Float.fromInt(i); s += t; i += 1 };
    s
  };
  
  public func ln(x : Float) : Float {
    if (x <= 0.0) return -100.0;
    let z = (x - 1.0) / (x + 1.0);
    let z2 = z * z;
    var s = z; var t = z; var i = 1;
    while (i < 30) { t *= z2; s += t / Float.fromInt(2*i + 1); i += 1 };
    2.0 * s
  };
  
  public func pow(b : Float, e : Float) : Float {
    if (b <= 0.0) 0.0 else exp(e * ln(b))
  };
  
  public func sin(x : Float) : Float {
    var n = x;
    while (n > PI) { n -= TAU };
    while (n < -PI) { n += TAU };
    let x2 = n * n;
    n - n*x2/6.0 + n*x2*x2/120.0 - n*x2*x2*x2/5040.0
  };
  
  public func cos(x : Float) : Float { sin(x + PI/2.0) };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TRADING IN THE ZONE (Mark Douglas) — Probabilistic Mindset Architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. Market is neutral — meaning comes from the mind
  // 2. Probabilistic thinking over certainty
  // 3. Edge execution without fear or greed
  // 4. Consistency comes from accepting risk
  // 5. The now moment is unique — no attachment to outcomes
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ProbabilisticMindset = {
    // Core beliefs (must be internalized)
    beliefs : {
      marketNeutrality : Float;       // 1.0 = fully internalized
      edgeAcceptance : Float;         // Accepts probabilistic edge
      riskAcceptance : Float;         // Comfortable with uncertainty
      outcomeDetachment : Float;      // Not attached to single outcomes
      nowMomentFocus : Float;         // Present-focused
    };
    
    // Mental state
    fearLevel : Float;                // Fear disrupts execution
    greedLevel : Float;               // Greed causes overtrading
    confidenceLevel : Float;          // Calibrated confidence
    
    // Edge tracking
    edgeDefinition : {
      winProbability : Float;         // P(win)
      avgWinSize : Float;             // E[win]
      avgLossSize : Float;            // E[loss]
      expectedValue : Float;          // P(win) × avgWin - P(loss) × avgLoss
    };
    
    // Consistency metrics
    followedPlan : Nat;               // Trades that followed plan
    deviatedFromPlan : Nat;           // Trades that deviated
    consistencyScore : Float;         // followedPlan / total
  };
  
  public func initProbabilisticMindset() : ProbabilisticMindset {
    {
      beliefs = {
        marketNeutrality = 0.5;
        edgeAcceptance = 0.5;
        riskAcceptance = 0.5;
        outcomeDetachment = 0.5;
        nowMomentFocus = 0.5;
      };
      fearLevel = 0.0;
      greedLevel = 0.0;
      confidenceLevel = 0.5;
      edgeDefinition = {
        winProbability = 0.5;
        avgWinSize = 1.0;
        avgLossSize = 1.0;
        expectedValue = 0.0;
      };
      followedPlan = 0;
      deviatedFromPlan = 0;
      consistencyScore = 1.0;
    }
  };
  
  /// Update mindset based on outcome (learning without attachment)
  public func updateMindsetAfterTrade(
    mindset : ProbabilisticMindset,
    wasWin : Bool,
    followedPlan : Bool
  ) : ProbabilisticMindset {
    // Key insight: Process over outcome
    // A loss from following the plan is SUCCESS
    // A win from deviating is FAILURE
    
    let newFollowed = if (followedPlan) mindset.followedPlan + 1 else mindset.followedPlan;
    let newDeviated = if (not followedPlan) mindset.deviatedFromPlan + 1 else mindset.deviatedFromPlan;
    let total = newFollowed + newDeviated;
    let newConsistency = if (total > 0) Float.fromInt(newFollowed) / Float.fromInt(total) else 1.0;
    
    // Outcome detachment strengthens with each trade
    let outcomeBoost = if (followedPlan) 0.01 else -0.02;
    
    {
      beliefs = {
        marketNeutrality = mindset.beliefs.marketNeutrality;
        edgeAcceptance = clamp(mindset.beliefs.edgeAcceptance + (if (followedPlan) 0.005 else -0.01), 0.0, 1.0);
        riskAcceptance = mindset.beliefs.riskAcceptance;
        outcomeDetachment = clamp(mindset.beliefs.outcomeDetachment + outcomeBoost, 0.0, 1.0);
        nowMomentFocus = mindset.beliefs.nowMomentFocus;
      };
      fearLevel = clamp(mindset.fearLevel + (if (wasWin) -0.05 else 0.1), 0.0, 1.0);
      greedLevel = clamp(mindset.greedLevel + (if (wasWin) 0.05 else -0.1), 0.0, 1.0);
      confidenceLevel = mindset.confidenceLevel;
      edgeDefinition = mindset.edgeDefinition;
      followedPlan = newFollowed;
      deviatedFromPlan = newDeviated;
      consistencyScore = newConsistency;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FOOLED BY RANDOMNESS (Taleb) — Randomness Filter Architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. Humans underestimate randomness
  // 2. Survivorship bias distorts perception
  // 3. Noise often mistaken for signal
  // 4. Rare events have outsized impact
  // 5. Path dependence matters
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type RandomnessFilter = {
    // Survivorship bias detector
    survivorshipBiasDetector : {
      observedSuccessRate : Float;    // What we see
      trueSuccessRate : Float;        // After correction
      silentEvidenceWeight : Float;   // Weight of unobserved failures
      cemeterySize : Nat;             // Number of silent failures
    };
    
    // Alternative history simulator
    alternativeHistories : {
      numSimulations : Nat;           // Monte Carlo paths
      currentOutcome : Float;         // Actual observed outcome
      alternativeOutcomes : [Float];  // What could have happened
      percentileOfActual : Float;     // Where actual falls in distribution
    };
    
    // Noise vs signal discriminator
    signalNoiseRatio : Float;
    noiseEstimate : Float;
    signalEstimate : Float;
    
    // Path dependence tracker
    pathDependence : {
      currentPath : [Float];          // Actual trajectory
      branchingPoints : [Nat];        // Where fate could have diverged
      sensitivityToInitial : Float;   // Butterfly effect measure
    };
  };
  
  public func initRandomnessFilter() : RandomnessFilter {
    {
      survivorshipBiasDetector = {
        observedSuccessRate = 0.5;
        trueSuccessRate = 0.1;        // Usually much lower
        silentEvidenceWeight = 0.8;
        cemeterySize = 0;
      };
      alternativeHistories = {
        numSimulations = 1000;
        currentOutcome = 0.0;
        alternativeOutcomes = [];
        percentileOfActual = 0.5;
      };
      signalNoiseRatio = 1.0;
      noiseEstimate = 0.5;
      signalEstimate = 0.5;
      pathDependence = {
        currentPath = [];
        branchingPoints = [];
        sensitivityToInitial = 1.0;
      };
    }
  };
  
  /// Correct for survivorship bias
  public func correctSurvivorshipBias(
    observedSuccess : Float,
    silentFailures : Nat,
    observedTotal : Nat
  ) : Float {
    // True rate = observed successes / (observed total + silent failures)
    let totalWithSilent = Float.fromInt(observedTotal + silentFailures);
    if (totalWithSilent == 0.0) return 0.0;
    let observedSuccesses = observedSuccess * Float.fromInt(observedTotal);
    observedSuccesses / totalWithSilent
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THE BLACK SWAN (Taleb) — Fat Tail Handler Architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. High-impact rare events shape history
  // 2. We cannot predict black swans
  // 3. Be robust to negative, open to positive
  // 4. Mediocristan vs Extremistan domains
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type Domain = {
    #Mediocristan;    // Gaussian, bounded, scalable
    #Extremistan;     // Power law, unbounded, winner-take-all
  };
  
  public type BlackSwanHandler = {
    // Domain classification
    currentDomain : Domain;
    domainScore : Float;              // -1 = pure Mediocristan, +1 = pure Extremistan
    
    // Fat tail detector
    fatTailMetrics : {
      kurtosis : Float;               // > 3 indicates fat tails
      skewness : Float;               // Asymmetry
      tailIndex : Float;              // α in P(X > x) ~ x^(-α)
      maxObserved : Float;            // Largest observed event
      theoreticalMax : Float;         // Theoretical maximum (if bounded)
    };
    
    // Exposure management (barbell strategy)
    barbellStrategy : {
      safeAllocation : Float;         // 85-90% ultra-safe
      speculativeAllocation : Float;  // 10-15% high-upside
      middleExposure : Float;         // Should be ~0
    };
    
    // Black swan preparedness
    negativeBlackSwanDefense : Float; // Robustness to negative shocks
    positiveBlackSwanExposure : Float; // Optionality to positive shocks
    
    // Narrative awareness (post-hoc rationalization detector)
    narrativeFallacyScore : Float;    // How much we're fooling ourselves
  };
  
  public func initBlackSwanHandler() : BlackSwanHandler {
    {
      currentDomain = #Extremistan;
      domainScore = 0.5;
      fatTailMetrics = {
        kurtosis = 3.0;
        skewness = 0.0;
        tailIndex = 2.0;
        maxObserved = 0.0;
        theoreticalMax = 0.0;
      };
      barbellStrategy = {
        safeAllocation = 0.85;
        speculativeAllocation = 0.15;
        middleExposure = 0.0;
      };
      negativeBlackSwanDefense = 0.8;
      positiveBlackSwanExposure = 0.5;
      narrativeFallacyScore = 0.3;
    }
  };
  
  /// Detect if we're in Extremistan
  public func detectExtremistan(kurtosis : Float, maxEvent : Float, mean : Float) : Bool {
    // Extremistan indicators:
    // 1. Kurtosis >> 3
    // 2. Single event >> mean
    kurtosis > 5.0 or (mean > 0.0 and maxEvent / mean > 10.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ANTIFRAGILE (Taleb) — Antifragility Engine
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. Some things benefit from disorder
  // 2. Fragile → Robust → Antifragile spectrum
  // 3. Volatility is information
  // 4. Remove fragilities, don't predict
  // 5. Small stressors build strength
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type FragilityClass = {
    #Fragile;         // Harmed by volatility
    #Robust;          // Unaffected by volatility
    #Antifragile;     // Benefits from volatility
  };
  
  public type AntifragilityEngine = {
    // Current state on the spectrum
    fragilityClass : FragilityClass;
    fragilityScore : Float;           // -1 = fragile, 0 = robust, +1 = antifragile
    
    // Convexity detector (antifragility = positive convexity)
    convexityMetrics : {
      secondDerivative : Float;       // f''(x) — positive = convex
      payoffAsymmetry : Float;        // Upside / downside ratio
      optionality : Float;            // Number of options available
    };
    
    // Hormesis tracker (small doses strengthen)
    hormesisState : {
      stressorHistory : [Float];      // Recent stressors
      adaptationLevel : Float;        // How much we've adapted
      breakingPoint : Float;          // Stress level that would break us
      optimalStress : Float;          // Goldilocks zone
    };
    
    // Via Negativa (remove bad > add good)
    viaNegativa : {
      fragilitiesToRemove : [Text];
      fragilityRemovalRate : Float;
      robustnessGained : Float;
    };
    
    // Skin in the game
    skinInTheGame : Float;            // 0 = none, 1 = full alignment
  };
  
  public func initAntifragilityEngine() : AntifragilityEngine {
    {
      fragilityClass = #Robust;
      fragilityScore = 0.0;
      convexityMetrics = {
        secondDerivative = 0.0;
        payoffAsymmetry = 1.0;
        optionality = 1.0;
      };
      hormesisState = {
        stressorHistory = [];
        adaptationLevel = 0.5;
        breakingPoint = 10.0;
        optimalStress = 3.0;
      };
      viaNegativa = {
        fragilitiesToRemove = [];
        fragilityRemovalRate = 0.0;
        robustnessGained = 0.0;
      };
      skinInTheGame = 1.0;
    }
  };
  
  /// Apply stressor and update antifragility
  public func applyStressor(
    engine : AntifragilityEngine,
    stressorMagnitude : Float
  ) : AntifragilityEngine {
    // Hormesis: small stress strengthens, large stress breaks
    let relativeStress = stressorMagnitude / engine.hormesisState.breakingPoint;
    
    let adaptationChange = if (relativeStress < 0.3) {
      // Small stress: strengthen (hormesis)
      0.05 * relativeStress
    } else if (relativeStress < 0.7) {
      // Moderate stress: neutral to slight benefit
      0.02 * (0.7 - relativeStress)
    } else {
      // Large stress: damage
      -0.1 * (relativeStress - 0.7)
    };
    
    let newAdaptation = clamp(engine.hormesisState.adaptationLevel + adaptationChange, 0.0, 1.0);
    
    // Antifragile if we gained from the stressor
    let newScore = if (adaptationChange > 0.0) {
      clamp(engine.fragilityScore + 0.1, -1.0, 1.0)
    } else {
      clamp(engine.fragilityScore - 0.1, -1.0, 1.0)
    };
    
    let newClass = if (newScore > 0.3) #Antifragile
                   else if (newScore > -0.3) #Robust
                   else #Fragile;
    
    {
      fragilityClass = newClass;
      fragilityScore = newScore;
      convexityMetrics = engine.convexityMetrics;
      hormesisState = {
        stressorHistory = engine.hormesisState.stressorHistory;  // Would append
        adaptationLevel = newAdaptation;
        breakingPoint = engine.hormesisState.breakingPoint * (1.0 + 0.01 * adaptationChange);
        optimalStress = engine.hormesisState.optimalStress;
      };
      viaNegativa = engine.viaNegativa;
      skinInTheGame = engine.skinInTheGame;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THINKING, FAST AND SLOW (Kahneman) — Dual Process Architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. System 1 (fast, intuitive) vs System 2 (slow, deliberate)
  // 2. Cognitive biases are systematic
  // 3. Loss aversion: losses hurt 2× more
  // 4. Anchoring affects all judgments
  // 5. WYSIATI: What you see is all there is
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DualProcessArchitecture = {
    // System 1: Fast, automatic, emotional
    system1 : {
      active : Bool;
      confidence : Float;             // Often overconfident
      processingTime : Float;         // ~100-200ms
      energyCost : Float;             // Low
      biasVulnerability : Float;      // High
      currentHeuristic : Text;
    };
    
    // System 2: Slow, deliberate, logical
    system2 : {
      active : Bool;
      confidence : Float;             // More calibrated
      processingTime : Float;         // Seconds to minutes
      energyCost : Float;             // High (depletes glucose)
      depletion : Float;              // Ego depletion level
      currentOperation : Text;
    };
    
    // Bias detectors
    biasState : {
      anchoringBias : Float;          // Influenced by initial number
      availabilityBias : Float;       // Overweight recent/vivid
      confirmationBias : Float;       // Seeking confirming evidence
      lossAversion : Float;           // λ ≈ 2.25
      overconfidence : Float;         // Confidence - accuracy
      hindsightBias : Float;          // "I knew it all along"
    };
    
    // Prospect theory state
    prospectTheory : {
      referencePoint : Float;         // Anchor for gains/losses
      gainSensitivity : Float;        // α ≈ 0.88
      lossSensitivity : Float;        // β ≈ 0.88
      lossAversionCoeff : Float;      // λ ≈ 2.25
    };
    
    // Meta-cognition
    cognitiveEase : Float;            // Low = more System 2
    currentMode : { #System1; #System2; #Mixed };
  };
  
  public func initDualProcessArchitecture() : DualProcessArchitecture {
    {
      system1 = {
        active = true;
        confidence = 0.8;
        processingTime = 0.15;
        energyCost = 0.1;
        biasVulnerability = 0.7;
        currentHeuristic = "availability";
      };
      system2 = {
        active = false;
        confidence = 0.6;
        processingTime = 2.0;
        energyCost = 0.8;
        depletion = 0.0;
        currentOperation = "none";
      };
      biasState = {
        anchoringBias = 0.5;
        availabilityBias = 0.5;
        confirmationBias = 0.5;
        lossAversion = 2.25;
        overconfidence = 0.2;
        hindsightBias = 0.3;
      };
      prospectTheory = {
        referencePoint = 0.0;
        gainSensitivity = 0.88;
        lossSensitivity = 0.88;
        lossAversionCoeff = 2.25;
      };
      cognitiveEase = 0.5;
      currentMode = #System1;
    }
  };
  
  /// Prospect theory value function: V(x) = x^α for gains, -λ(-x)^β for losses
  public func prospectValue(
    outcome : Float,
    referencePoint : Float,
    alpha : Float,
    beta : Float,
    lambda : Float
  ) : Float {
    let delta = outcome - referencePoint;
    if (delta >= 0.0) {
      pow(delta, alpha)
    } else {
      -lambda * pow(-delta, beta)
    }
  };
  
  /// Decide whether to engage System 2
  public func shouldEngageSystem2(
    cognitiveEase : Float,
    stakesMagnitude : Float,
    system2Depletion : Float
  ) : Bool {
    // Engage System 2 when:
    // - Stakes are high
    // - Cognitive ease is low (something feels off)
    // - Not too depleted
    stakesMagnitude > 0.7 and cognitiveEase < 0.4 and system2Depletion < 0.8
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INFLUENCE (Cialdini) — Persuasion Pattern Architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // 6 Principles:
  // 1. Reciprocity
  // 2. Commitment/Consistency
  // 3. Social Proof
  // 4. Authority
  // 5. Liking
  // 6. Scarcity
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type PersuasionPattern = {
    #Reciprocity;
    #Commitment;
    #SocialProof;
    #Authority;
    #Liking;
    #Scarcity;
  };
  
  public type PersuasionDetector = {
    // Detection scores for each principle
    reciprocityDetected : Float;
    commitmentDetected : Float;
    socialProofDetected : Float;
    authorityDetected : Float;
    likingDetected : Float;
    scarcityDetected : Float;
    
    // Resistance levels
    resistanceToReciprocity : Float;
    resistanceToCommitment : Float;
    resistanceToSocialProof : Float;
    resistanceToAuthority : Float;
    resistanceToLiking : Float;
    resistanceToScarcity : Float;
    
    // Current influence attempt
    activePatterns : [PersuasionPattern];
    totalInfluenceAttempt : Float;
    
    // Counter-persuasion
    awareness : Float;                // Meta-awareness of being influenced
  };
  
  public func initPersuasionDetector() : PersuasionDetector {
    {
      reciprocityDetected = 0.0;
      commitmentDetected = 0.0;
      socialProofDetected = 0.0;
      authorityDetected = 0.0;
      likingDetected = 0.0;
      scarcityDetected = 0.0;
      resistanceToReciprocity = 0.5;
      resistanceToCommitment = 0.5;
      resistanceToSocialProof = 0.5;
      resistanceToAuthority = 0.5;
      resistanceToLiking = 0.5;
      resistanceToScarcity = 0.5;
      activePatterns = [];
      totalInfluenceAttempt = 0.0;
      awareness = 0.5;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GÖDEL, ESCHER, BACH (Hofstadter) — Strange Loop Architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. Strange loops create consciousness
  // 2. Self-reference is fundamental
  // 3. Formal systems have inherent limits (Gödel)
  // 4. Meaning emerges from patterns
  // 5. Isomorphism connects domains
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type StrangeLoopArchitecture = {
    // Self-reference capability
    selfReferenceLevel : Nat;         // How many levels of self-modeling
    selfModelAccuracy : Float;        // How accurate is the self-model
    
    // Tangled hierarchy detector
    hierarchyTangles : [Nat];         // Levels that loop back
    isStrangeLoop : Bool;             // True if hierarchy tangles
    
    // Gödel incompleteness awareness
    godelAwareness : {
      hasUnprovableStatements : Bool;
      selfReferentialCapacity : Bool;
      consistencyUnprovable : Bool;
    };
    
    // Isomorphism finder
    isomorphisms : [{
      domain1 : Text;
      domain2 : Text;
      mappingStrength : Float;
    }];
    
    // Recursion engine
    recursionDepth : Nat;
    recursionLimit : Nat;
    
    // Pattern-meaning emergence
    meaningEmergence : Float;         // How much meaning has emerged
  };
  
  public func initStrangeLoopArchitecture() : StrangeLoopArchitecture {
    {
      selfReferenceLevel = 2;
      selfModelAccuracy = 0.7;
      hierarchyTangles = [];
      isStrangeLoop = true;
      godelAwareness = {
        hasUnprovableStatements = true;
        selfReferentialCapacity = true;
        consistencyUnprovable = true;
      };
      isomorphisms = [];
      recursionDepth = 0;
      recursionLimit = 100;
      meaningEmergence = 0.5;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INFORMATION THEORY (MacKay/Shannon) — Entropy Engine
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. Information = surprise = -log(p)
  // 2. Entropy measures uncertainty: H = -Σ p log p
  // 3. Compression and prediction are equivalent
  // 4. Channel capacity limits
  // 5. Mutual information measures dependence
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type InformationTheoryEngine = {
    // Current entropy state
    entropy : Float;                  // H(X) = -Σ p_i log p_i
    maxEntropy : Float;               // log(n) for n states
    normalizedEntropy : Float;        // H / H_max ∈ [0, 1]
    
    // Compression
    compressionRatio : Float;         // Compressed / original
    minDescriptionLength : Float;     // MDL principle
    
    // Channel
    channelCapacity : Float;          // Max reliable bits per symbol
    noiseLevel : Float;
    signalToNoise : Float;
    
    // Mutual information
    mutualInformation : Float;        // I(X;Y) = H(X) - H(X|Y)
    conditionalEntropy : Float;       // H(X|Y)
    
    // KL divergence from prior
    klDivergence : Float;             // D_KL(P || Q)
  };
  
  public func initInformationTheoryEngine() : InformationTheoryEngine {
    {
      entropy = 1.0;
      maxEntropy = 8.0;               // log2(256)
      normalizedEntropy = 0.125;
      compressionRatio = 1.0;
      minDescriptionLength = 0.0;
      channelCapacity = 1.0;
      noiseLevel = 0.1;
      signalToNoise = 10.0;
      mutualInformation = 0.0;
      conditionalEntropy = 1.0;
      klDivergence = 0.0;
    }
  };
  
  /// Compute Shannon entropy
  public func shannonEntropy(probabilities : [Float]) : Float {
    var H : Float = 0.0;
    for (p in probabilities.vals()) {
      if (p > 1e-10) {
        H -= p * ln(p) / ln(2.0);  // log base 2
      };
    };
    H
  };
  
  /// Compute KL divergence D_KL(P || Q)
  public func klDivergence(P : [Float], Q : [Float]) : Float {
    var D : Float = 0.0;
    let n = if (P.size() < Q.size()) P.size() else Q.size();
    var i = 0;
    while (i < n) {
      if (P[i] > 1e-10 and Q[i] > 1e-10) {
        D += P[i] * ln(P[i] / Q[i]) / ln(2.0);
      };
      i += 1;
    };
    D
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FREE ENERGY PRINCIPLE (Friston) — Active Inference Architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. Living systems minimize free energy
  // 2. Perception is active inference
  // 3. Brain is a prediction machine
  // 4. Surprise/entropy must be bounded
  // 5. Action and perception are unified
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type FreeEnergyPrincipleEngine = {
    // Variational free energy: F ≥ -log p(o) (surprise bound)
    variationalFreeEnergy : Float;    // F = E_q[log q(s) - log p(o,s)]
    surprise : Float;                 // -log p(o)
    
    // Generative model p(o,s) = p(o|s)p(s)
    generativeModel : {
      priorBeliefs : [Float];         // p(s)
      likelihoodModel : [Float];      // p(o|s)
    };
    
    // Recognition model q(s|o)
    recognitionModel : {
      posteriorBeliefs : [Float];     // q(s)
      precision : Float;              // Inverse variance
    };
    
    // Prediction error
    predictionError : Float;          // o - E_q[o]
    precisionWeightedError : Float;   // precision × error²
    
    // Active inference
    expectedFreeEnergy : Float;       // G = E_q[F] for action selection
    actionPrior : [Float];            // p(a)
    selectedAction : Nat;
    
    // Markov blanket
    markovBlanket : {
      sensoryStates : [Float];
      activeStates : [Float];
      internalStates : [Float];
    };
  };
  
  public func initFreeEnergyEngine() : FreeEnergyPrincipleEngine {
    {
      variationalFreeEnergy = 0.0;
      surprise = 0.0;
      generativeModel = {
        priorBeliefs = [0.5, 0.5];
        likelihoodModel = [0.9, 0.1];
      };
      recognitionModel = {
        posteriorBeliefs = [0.5, 0.5];
        precision = 1.0;
      };
      predictionError = 0.0;
      precisionWeightedError = 0.0;
      expectedFreeEnergy = 0.0;
      actionPrior = [0.5, 0.5];
      selectedAction = 0;
      markovBlanket = {
        sensoryStates = [];
        activeStates = [];
        internalStates = [];
      };
    }
  };
  
  /// Compute variational free energy
  public func computeVariationalFreeEnergy(
    posteriorBeliefs : [Float],
    priorBeliefs : [Float],
    predictionError : Float,
    precision : Float
  ) : Float {
    // F = D_KL(q(s) || p(s)) + E_q[log p(o|s)]
    // ≈ KL divergence + precision-weighted prediction error
    let kl = klDivergence(posteriorBeliefs, priorBeliefs);
    let accuracy = -0.5 * precision * predictionError * predictionError;
    kl - accuracy
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SYNC (Strogatz) — Synchronization Architecture
  // ═══════════════════════════════════════════════════════════════════════════
  // Key Principles:
  // 1. Synchronization is universal
  // 2. Kuramoto model captures essence
  // 3. Phase transitions are sudden
  // 4. Order emerges from local rules
  // 5. Small-world networks enable sync
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SynchronizationArchitecture = {
    // Kuramoto model
    kuramoto : {
      phases : [Float];               // θ_i ∈ [0, 2π)
      naturalFrequencies : [Float];   // ω_i
      couplingStrength : Float;       // K
      orderParameter : Float;         // r = |1/N Σ exp(iθ_j)|
      meanPhase : Float;              // psi = arg(Σ exp(iθ_j))
    };
    
    // Sync detection
    isSynchronized : Bool;            // r > threshold
    syncThreshold : Float;            // Typically 0.9
    criticalCoupling : Float;         // K_c = 2/(πg(0))
    
    // Phase transition
    inTransition : Bool;
    transitionProgress : Float;       // 0 = disordered, 1 = ordered
    
    // Network topology
    networkType : { #AllToAll; #SmallWorld; #ScaleFree; #Lattice };
    meanDegree : Float;
    clusteringCoeff : Float;
    pathLength : Float;
  };
  
  public func initSynchronizationArchitecture(numOscillators : Nat) : SynchronizationArchitecture {
    {
      kuramoto = {
        phases = Array.tabulate<Float>(numOscillators, func(i : Nat) : Float {
          Float.fromInt(i) * TAU / Float.fromInt(numOscillators)
        });
        naturalFrequencies = Array.tabulate<Float>(numOscillators, func(_ : Nat) : Float { 1.0 });
        couplingStrength = 0.618;     // φ⁻¹
        orderParameter = 0.0;
        meanPhase = 0.0;
      };
      isSynchronized = false;
      syncThreshold = 0.9;
      criticalCoupling = 0.5;
      inTransition = false;
      transitionProgress = 0.0;
      networkType = #AllToAll;
      meanDegree = Float.fromInt(numOscillators - 1);
      clusteringCoeff = 1.0;
      pathLength = 1.0;
    }
  };
  
  /// Compute Kuramoto order parameter
  public func kuramotoOrderParameter(phases : [Float]) : Float {
    var cosSum : Float = 0.0;
    var sinSum : Float = 0.0;
    for (θ in phases.vals()) {
      cosSum += cos(θ);
      sinSum += sin(θ);
    };
    let n = Float.fromInt(phases.size());
    if (n == 0.0) return 0.0;
    sqrt(cosSum*cosSum + sinSum*sinSum) / n
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLETE CURRICULUM-DERIVED ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type CurriculumDerivedArchitecture = {
    // Trading psychology
    probabilisticMindset : ProbabilisticMindset;
    randomnessFilter : RandomnessFilter;
    blackSwanHandler : BlackSwanHandler;
    antifragilityEngine : AntifragilityEngine;
    
    // Cognitive science
    dualProcess : DualProcessArchitecture;
    persuasionDetector : PersuasionDetector;
    
    // Mathematics
    strangeLoop : StrangeLoopArchitecture;
    informationTheory : InformationTheoryEngine;
    
    // Neuroscience
    freeEnergyPrinciple : FreeEnergyPrincipleEngine;
    synchronization : SynchronizationArchitecture;
    
    // Integration metrics
    curriculumMastery : Float;        // 0-1 how much is integrated
    principleAlignment : Float;       // How well principles align
    architecturalCoherence : Float;   // Internal consistency
  };
  
  public func initCurriculumArchitecture() : CurriculumDerivedArchitecture {
    {
      probabilisticMindset = initProbabilisticMindset();
      randomnessFilter = initRandomnessFilter();
      blackSwanHandler = initBlackSwanHandler();
      antifragilityEngine = initAntifragilityEngine();
      dualProcess = initDualProcessArchitecture();
      persuasionDetector = initPersuasionDetector();
      strangeLoop = initStrangeLoopArchitecture();
      informationTheory = initInformationTheoryEngine();
      freeEnergyPrinciple = initFreeEnergyEngine();
      synchronization = initSynchronizationArchitecture(256);
      curriculumMastery = 0.0;
      principleAlignment = 1.0;
      architecturalCoherence = 1.0;
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


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  L E A R N I N G   &   M E M O R Y   M A T H E M A T I C S
  //
  //  Enterprise-Level Learning and Memory Algorithms
  //  Full HIM/HER Dual-Organism Memory Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // MEMORY CONSOLIDATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Ebbinghaus forgetting curve
  public func memoryForgettingCurve(
    initialStrength : Float,
    timePassed : Float,
    decayRate : Float
  ) : Float {
    initialStrength * Float.exp(-decayRate * timePassed)
  };

  /// Spaced repetition optimal interval
  public func memorySpacedRepetitionInterval(
    previousInterval : Float,
    easeFactor : Float,
    performance : Float
  ) : Float {
    let adjustedEase = easeFactor + 0.1 - (5.0 - performance) * 0.08;
    let newEase = if (adjustedEase < 1.3) 1.3 else adjustedEase;
    previousInterval * newEase
  };

  /// Memory strength update
  public func memoryStrengthUpdate(
    currentStrength : Float,
    rehearsal : Bool,
    decayRate : Float,
    boostAmount : Float
  ) : Float {
    let decayed = currentStrength * (1.0 - decayRate);
    if (rehearsal) { Float.min(decayed + boostAmount, 1.0) }
    else { decayed }
  };

  /// Sleep consolidation effect
  public func memorySleepConsolidation(
    hippocampalStrength : Float,
    corticalStrength : Float,
    sleepQuality : Float,
    transferRate : Float
  ) : (Float, Float) {
    let transfer = hippocampalStrength * sleepQuality * transferRate;
    (hippocampalStrength - transfer, corticalStrength + transfer)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ASSOCIATIVE LEARNING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rescorla-Wagner learning rule
  public func memoryRescorlaWagner(
    association : Float,
    learningRate : Float,
    reward : Float,
    maxAssociation : Float
  ) : Float {
    let predictionError = reward - association;
    association + learningRate * predictionError * (maxAssociation - association)
  };

  /// Temporal difference error
  public func memoryTDError(
    reward : Float,
    currentValue : Float,
    nextValue : Float,
    discountFactor : Float
  ) : Float {
    reward + discountFactor * nextValue - currentValue
  };

  /// Eligibility trace update
  public func memoryEligibilityTrace(
    trace : Float,
    decayRate : Float,
    visited : Bool
  ) : Float {
    let decayed = trace * decayRate;
    if (visited) { decayed + 1.0 } else { decayed }
  };

  /// Q-learning update
  public func memoryQLearningUpdate(
    qValue : Float,
    learningRate : Float,
    reward : Float,
    maxNextQ : Float,
    discountFactor : Float
  ) : Float {
    let target = reward + discountFactor * maxNextQ;
    qValue + learningRate * (target - qValue)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // PATTERN COMPLETION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Hopfield network energy
  public func memoryHopfieldEnergy(
    state : [Float],
    weights : [[Float]]
  ) : Float {
    let n = state.size();
    var energy : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        if (i != j) {
          energy -= 0.5 * weights[i][j] * state[i] * state[j];
        };
        j += 1;
      };
      i += 1;
    };
    energy
  };

  /// Pattern completion update
  public func memoryPatternCompletion(
    state : Float,
    weights : [Float],
    inputs : [Float],
    threshold : Float
  ) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < weights.size() and i < inputs.size()) {
      sum += weights[i] * inputs[i];
      i += 1;
    };
    if (sum > threshold) { 1.0 } else if (sum < -threshold) { -1.0 } else { state }
  };

  /// Sparse coding activation
  public func memorySparseCoding(
    input : Float,
    dictionary : [Float],
    sparsityPenalty : Float
  ) : [Float] {
    Array.tabulate<Float>(dictionary.size(), func(i : Nat) : Float {
      let activation = input * dictionary[i];
      let penalized = activation - sparsityPenalty;
      if (penalized > 0.0) { penalized } else { 0.0 }
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EPISODIC MEMORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Episode binding strength
  public func memoryEpisodeBinding(
    contextualSimilarity : Float,
    temporalProximity : Float,
    emotionalSalience : Float
  ) : Float {
    contextualSimilarity * temporalProximity * (1.0 + emotionalSalience)
  };

  /// Temporal context update
  public func memoryTemporalContext(
    currentContext : Float,
    input : Float,
    driftRate : Float
  ) : Float {
    (1.0 - driftRate) * currentContext + driftRate * input
  };

  /// Recollection probability
  public func memoryRecollectionProbability(
    cueStrength : Float,
    memoryStrength : Float,
    noise : Float
  ) : Float {
    let signal = cueStrength * memoryStrength;
    1.0 / (1.0 + Float.exp(-(signal - noise) / 0.5))
  };

  /// Familiarity signal
  public func memoryFamiliarity(
    featureMatch : Float,
    priorExposure : Float
  ) : Float {
    featureMatch * (1.0 + Float.log(priorExposure + 1.0))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CURRICULUM LEARNING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Task difficulty assessment
  public func memoryTaskDifficulty(
    complexity : Float,
    novelty : Float,
    performance : Float
  ) : Float {
    complexity * (1.0 + novelty) / (performance + 0.1)
  };

  /// Optimal learning zone
  public func memoryOptimalLearningZone(
    currentSkill : Float,
    taskDifficulty : Float,
    zoneWidth : Float
  ) : Float {
    let diff = Float.abs(taskDifficulty - currentSkill);
    if (diff < zoneWidth) { 1.0 - diff / zoneWidth } else { 0.0 }
  };

  /// Skill progression rate
  public func memorySkillProgression(
    practice : Float,
    difficulty : Float,
    currentSkill : Float
  ) : Float {
    let challenge = difficulty - currentSkill;
    if (challenge > 0.0) {
      practice * challenge * Float.exp(-challenge * challenge)
    } else {
      practice * 0.1  // Minimal progress if too easy
    }
  };

  /// Knowledge transfer coefficient
  public func memoryKnowledgeTransfer(
    sourceSkill : Float,
    targetSimilarity : Float
  ) : Float {
    sourceSkill * targetSimilarity * targetSimilarity
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // METACOGNITION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Confidence calibration
  public func memoryConfidenceCalibration(
    predicted : Float,
    actual : Float,
    history : [Float]
  ) : Float {
    let currentError = Float.abs(predicted - actual);
    var avgError : Float = 0.0;
    var i = 0;
    while (i < history.size()) {
      avgError += history[i];
      i += 1;
    };
    if (history.size() > 0) {
      avgError /= Float.fromInt(history.size());
    };
    1.0 - (currentError + avgError) / 2.0
  };

  /// Feeling of knowing
  public func memoryFeelingOfKnowing(
    partialRetrieval : Float,
    relatedActivation : Float
  ) : Float {
    (partialRetrieval + relatedActivation) / 2.0
  };

  /// Judgment of learning
  public func memoryJudgmentOfLearning(
    fluency : Float,
    effort : Float,
    priorKnowledge : Float
  ) : Float {
    let fluencyWeight = 0.4;
    let effortWeight = 0.3;
    let priorWeight = 0.3;
    fluencyWeight * fluency + effortWeight * (1.0 - effort) + priorWeight * priorKnowledge
  };

}
