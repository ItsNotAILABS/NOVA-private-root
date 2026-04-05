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
// ██████╗ ███████╗██╗  ██╗ █████╗ ██╗   ██╗██╗ ██████╗ ██████╗  █████╗ ██╗     
// ██╔══██╗██╔════╝██║  ██║██╔══██╗██║   ██║██║██╔═══██╗██╔══██╗██╔══██╗██║     
// ██████╔╝█████╗  ███████║███████║██║   ██║██║██║   ██║██████╔╝███████║██║     
// ██╔══██╗██╔══╝  ██╔══██║██╔══██║╚██╗ ██╔╝██║██║   ██║██╔══██╗██╔══██║██║     
// ██████╔╝███████╗██║  ██║██║  ██║ ╚████╔╝ ██║╚██████╔╝██║  ██║██║  ██║███████╗
// ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
//                                                                               
// ███████╗ ██████╗ ██████╗ ███╗   ██╗ ██████╗ ███╗   ███╗██╗ ██████╗███████╗   
// ██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔═══██╗████╗ ████║██║██╔════╝██╔════╝   
// █████╗  ██║     ██║   ██║██╔██╗ ██║██║   ██║██╔████╔██║██║██║     ███████╗   
// ██╔══╝  ██║     ██║   ██║██║╚██╗██║██║   ██║██║╚██╔╝██║██║██║     ╚════██║   
// ███████╗╚██████╗╚██████╔╝██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║╚██████╗███████║   
// ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝ ╚═════╝╚══════╝   
// ════════════════════════════════════════════════════════════════════════════════════════
//
// BEHAVIORAL ECONOMICS ENGINE FOR COGNITIVE SWARM SYSTEMS
// The Psychology of Decision-Making in Sovereign Living Systems
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// This module implements the behavioral economics principles that govern how
// the swarm organism thinks, decides, and learns. Unlike classical economics
// which assumes rational actors, behavioral economics acknowledges that
// cognition is shaped by:
//
//   - Prospect Theory (Kahneman & Tversky)
//   - Hyperbolic Discounting
//   - Loss Aversion
//   - Anchoring Effects
//   - Cognitive Biases as Features (not bugs)
//   - Heuristics for Fast Decision-Making
//   - Social Proof and Herding Behavior
//   - Framing Effects
//
// THE MEDINA EXTENSION:
// In synthetic life, these "biases" are not flaws — they are evolved cognitive
// shortcuts that allow real-time decision-making in uncertain environments.
// The swarm brain uses behavioral economics to:
//
//   1. Value FORMA tokens (prospect theory + reference dependence)
//   2. Discount future rewards (hyperbolic, not exponential)
//   3. Weight losses more than gains (loss aversion λ ≈ 2.25)
//   4. Anchor decisions on recent experience
//   5. Follow coherent swarm behavior (social proof)
//   6. Make fast decisions under uncertainty (heuristics)
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ══════════════════════════════════════════════════════════════════════════════════════
  // BEHAVIORAL ECONOMICS CONSTANTS — THE MEDINA COGNITIVE COEFFICIENTS
  // ══════════════════════════════════════════════════════════════════════════════════════

  // Loss Aversion Coefficient (Kahneman & Tversky, 1992)
  // Losses hurt ~2.25x more than equivalent gains feel good
  public let LOSS_AVERSION_LAMBDA : Float = 2.25;

  // Prospect Theory Exponents (diminishing sensitivity)
  // α for gains, β for losses (typically α = β ≈ 0.88)
  public let PROSPECT_ALPHA : Float = 0.88;  // Gains curvature
  public let PROSPECT_BETA  : Float = 0.88;  // Losses curvature

  // Hyperbolic Discount Rate
  // Future rewards discounted as V = V₀ / (1 + k × t)
  public let HYPERBOLIC_K : Float = 0.1;  // Present bias parameter

  // Anchoring Strength
  // How much prior reference points influence current judgment
  public let ANCHORING_WEIGHT : Float = 0.4;

  // Social Proof Sensitivity
  // How much swarm behavior influences individual decisions
  public let SOCIAL_PROOF_SENSITIVITY : Float = 0.6;

  // Status Quo Bias
  // Preference for current state over change
  public let STATUS_QUO_BIAS : Float = 0.2;

  // Overconfidence Factor
  // Tendency to overestimate own predictions
  public let OVERCONFIDENCE : Float = 0.15;

  // Availability Heuristic Weight
  // Recent/vivid events weighted more heavily
  public let AVAILABILITY_WEIGHT : Float = 0.35;

  // ══════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _sign(x: Float) : Float {
    if (x > 0.0) { 1.0 } else if (x < 0.0) { -1.0 } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  1. PROSPECT THEORY — VALUE FUNCTION  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // KAHNEMAN & TVERSKY'S VALUE FUNCTION:
  //
  //            ⎧  x^α           if x ≥ 0  (gains)
  //   v(x) = ⎨
  //            ⎩ -λ(-x)^β       if x < 0  (losses)
  //
  // Properties:
  //   - Reference dependence: Value relative to reference point
  //   - Diminishing sensitivity: Curvature α, β < 1
  //   - Loss aversion: λ > 1 (losses hurt more)
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type ProspectValue = {
    rawOutcome      : Float;   // x
    referencePoint  : Float;   // where gains/losses are measured from
    relativeOutcome : Float;   // x - reference
    subjectiveValue : Float;   // v(x - reference)
    isGain          : Bool;
  };

  // Core prospect theory value function
  public func prospectValue(outcome: Float, reference: Float) : ProspectValue {
    let relative = outcome - reference;
    let isGain = relative >= 0.0;

    let subjective = if (isGain) {
      // Gains: v(x) = x^α
      Float.pow(Float.abs(relative), PROSPECT_ALPHA)
    } else {
      // Losses: v(x) = -λ × |x|^β
      -LOSS_AVERSION_LAMBDA * Float.pow(Float.abs(relative), PROSPECT_BETA)
    };

    {
      rawOutcome = outcome;
      referencePoint = reference;
      relativeOutcome = relative;
      subjectiveValue = subjective;
      isGain = isGain;
    }
  };

  // Evaluate a prospect (probability-weighted outcomes)
  public func evaluateProspect(
    outcomes: [Float],
    probabilities: [Float],
    reference: Float
  ) : Float {
    let n = outcomes.size();
    if (n == 0) { return 0.0 };

    var expectedValue : Float = 0.0;
    var i = 0;
    while (i < n) {
      let prob = if (i < probabilities.size()) { probabilities[i] } else { 1.0 / Float.fromInt(n) };
      let pv = prospectValue(outcomes[i], reference);

      // Weight probability (probability weighting function)
      let weightedProb = probabilityWeight(prob, pv.isGain);

      expectedValue += pv.subjectiveValue * weightedProb;
      i += 1;
    };

    expectedValue
  };

  // Probability weighting function (Tversky & Kahneman, 1992)
  // π(p) = p^γ / (p^γ + (1-p)^γ)^(1/γ)
  // Overweight small probabilities, underweight large probabilities
  func probabilityWeight(p: Float, isGain: Bool) : Float {
    let gamma = if (isGain) { 0.61 } else { 0.69 };  // Different for gains/losses
    let pClamp = _clamp(p, 0.001, 0.999);

    let pGamma = Float.pow(pClamp, gamma);
    let oneMinusPGamma = Float.pow(1.0 - pClamp, gamma);
    let denom = Float.pow(pGamma + oneMinusPGamma, 1.0 / gamma);

    if (denom > 0.001) { pGamma / denom } else { p }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  2. HYPERBOLIC DISCOUNTING — TEMPORAL VALUE  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // HYPERBOLIC VS EXPONENTIAL DISCOUNTING:
  //
  //   Exponential (classical):  V(t) = V₀ × e^(-δt)    ← Rational but unrealistic
  //   Hyperbolic (behavioral):  V(t) = V₀ / (1 + kt)  ← Matches actual behavior
  //
  // Hyperbolic discounting creates:
  //   - Present bias: Strong preference for immediate rewards
  //   - Time inconsistency: Preferences change as time passes
  //   - Procrastination: Future costs are underweighted
  //
  // THE MEDINA INSIGHT:
  //   Present bias is adaptive for survival. A drone that waits for "optimal"
  //   timing may never act. Hyperbolic discounting creates urgency.
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type TemporalValue = {
    presentValue    : Float;   // V₀
    delay           : Float;   // t (in beats)
    discountedValue : Float;   // V(t)
    discountFactor  : Float;   // 1 / (1 + kt)
    presentBias     : Float;   // How much sooner is preferred
  };

  // Hyperbolic discount function
  public func hyperbolicDiscount(presentValue: Float, delay: Float) : TemporalValue {
    let k = HYPERBOLIC_K;
    let discountFactor = 1.0 / (1.0 + k * Float.max(0.0, delay));
    let discountedValue = presentValue * discountFactor;

    // Present bias: compare to exponential discount
    let exponentialDiscount = Float.exp(-k * delay);
    let presentBias = discountFactor - exponentialDiscount;

    {
      presentValue = presentValue;
      delay = delay;
      discountedValue = discountedValue;
      discountFactor = discountFactor;
      presentBias = presentBias;
    }
  };

  // Compare two options with different delays
  public func compareTemporalOptions(
    value1: Float, delay1: Float,
    value2: Float, delay2: Float
  ) : Int {
    let dv1 = hyperbolicDiscount(value1, delay1);
    let dv2 = hyperbolicDiscount(value2, delay2);

    if (dv1.discountedValue > dv2.discountedValue + 0.001) { 1 }
    else if (dv2.discountedValue > dv1.discountedValue + 0.001) { -1 }
    else { 0 }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  3. ANCHORING — REFERENCE POINT DYNAMICS  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // ANCHORING EFFECT:
  //   Initial information (anchor) disproportionately influences judgment.
  //   Adjustment from anchor is typically insufficient.
  //
  //   adjusted_estimate = anchor + α × (new_info - anchor)
  //
  // where α < 1 (insufficient adjustment)
  //
  // IN SWARM COGNITION:
  //   - Previous swarm state anchors current expectations
  //   - Reference coherence anchors acceptable coherence
  //   - Prior FORMA value anchors token valuation
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type AnchoredJudgment = {
    anchor          : Float;
    newInformation  : Float;
    adjustment      : Float;
    finalEstimate   : Float;
    anchorInfluence : Float;  // How much anchor pulled the estimate
  };

  public func anchoredJudgment(anchor: Float, newInfo: Float) : AnchoredJudgment {
    let adjustment = (1.0 - ANCHORING_WEIGHT) * (newInfo - anchor);
    let finalEstimate = anchor + adjustment;
    let anchorInfluence = Float.abs(finalEstimate - newInfo) / Float.max(0.001, Float.abs(newInfo - anchor));

    {
      anchor = anchor;
      newInformation = newInfo;
      adjustment = adjustment;
      finalEstimate = finalEstimate;
      anchorInfluence = anchorInfluence;
    }
  };

  // Dynamic reference point that adapts over time
  public func updateReferencePoint(
    currentRef: Float,
    newOutcome: Float,
    adaptationRate: Float
  ) : Float {
    // Reference point slowly adapts to recent outcomes
    currentRef + adaptationRate * (newOutcome - currentRef)
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  4. SOCIAL PROOF — SWARM HERDING BEHAVIOR  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // SOCIAL PROOF PRINCIPLE:
  //   Individuals look to others' behavior when uncertain.
  //   "If everyone is doing X, X must be correct."
  //
  // IN SWARM COGNITION:
  //   - Drones follow majority behavior
  //   - Coherent swarm amplifies confidence
  //   - Dissent is costly but potentially valuable (diversity)
  //
  // INFORMATION CASCADE:
  //   When enough agents act, others follow regardless of private info
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type SocialProofDecision = {
    privateSignal     : Float;   // Individual drone's information
    socialSignal      : Float;   // What the swarm is doing
    combinedSignal    : Float;   // Weighted combination
    conformityPressure: Float;   // Strength of social pull
    isConforming      : Bool;    // Did drone follow the swarm?
  };

  public func socialProofDecision(
    privateSignal: Float,
    swarmBehavior: Float,
    coherence: Float
  ) : SocialProofDecision {
    // Social pressure increases with swarm coherence
    let conformityPressure = SOCIAL_PROOF_SENSITIVITY * coherence;

    // Combine private and social signals
    let socialWeight = conformityPressure;
    let privateWeight = 1.0 - socialWeight;
    let combinedSignal = privateWeight * privateSignal + socialWeight * swarmBehavior;

    // Determine if conforming (combined closer to swarm than private)
    let isConforming = Float.abs(combinedSignal - swarmBehavior) < Float.abs(privateSignal - swarmBehavior);

    {
      privateSignal = privateSignal;
      socialSignal = swarmBehavior;
      combinedSignal = combinedSignal;
      conformityPressure = conformityPressure;
      isConforming = isConforming;
    }
  };

  // Cascade threshold: when cascade begins
  public func cascadeThreshold(numAgents: Nat, coherence: Float) : Float {
    // Higher coherence = lower threshold for cascade
    let baseThreshold = 0.5;
    baseThreshold * (1.0 - coherence * 0.5)
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  5. HEURISTICS — FAST AND FRUGAL DECISION MAKING  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // GIGERENZER'S HEURISTICS:
  //   Simple rules that ignore information but often outperform complex models.
  //
  // RECOGNITION HEURISTIC:
  //   If one option is recognized and another isn't, choose the recognized one.
  //
  // TAKE-THE-BEST:
  //   Look at cues in order of validity; decide on first discriminating cue.
  //
  // 1/N HEURISTIC:
  //   Allocate equally among N options (often beats optimization).
  //
  // SATISFICING:
  //   Accept first option that exceeds aspiration level.
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type HeuristicResult = {
    heuristicUsed  : Text;
    decision       : Float;   // Chosen value/action
    confidence     : Float;   // How confident in decision
    searchEffort   : Nat;     // How many options examined
    wasOptimal     : Bool;    // Would optimization have chosen same?
  };

  // Satisficing: accept first option above threshold
  public func satisfice(options: [Float], aspirationLevel: Float) : HeuristicResult {
    var decision : Float = 0.0;
    var searchEffort : Nat = 0;
    var found = false;

    for (opt in options.vals()) {
      searchEffort += 1;
      if (not found and opt >= aspirationLevel) {
        decision := opt;
        found := true;
      };
    };

    // If nothing satisfies, take best available
    if (not found) {
      for (opt in options.vals()) {
        if (opt > decision) { decision := opt };
      };
    };

    // Check if optimal
    var optimal : Float = 0.0;
    for (opt in options.vals()) {
      if (opt > optimal) { optimal := opt };
    };

    {
      heuristicUsed = "SATISFICE";
      decision = decision;
      confidence = if (found) { 0.8 } else { 0.5 };
      searchEffort = searchEffort;
      wasOptimal = Float.abs(decision - optimal) < 0.001;
    }
  };

  // 1/N allocation heuristic
  public func equalAllocation(totalResource: Float, numTargets: Nat) : [Float] {
    if (numTargets == 0) { return [] };
    let each = totalResource / Float.fromInt(numTargets);
    Array.tabulate<Float>(numTargets, func(_) { each })
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  6. COGNITIVE BIAS ENSEMBLE — THE FULL BEHAVIORAL BRAIN  ████
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type BehavioralDecision = {
    // Inputs
    rawOutcome          : Float;
    referencePoint      : Float;
    delay               : Float;
    swarmBehavior       : Float;
    coherence           : Float;

    // Processed through biases
    prospectValue       : Float;
    temporalValue       : Float;
    anchoredValue       : Float;
    socialValue         : Float;

    // Final decision
    finalValue          : Float;
    confidence          : Float;
    dominantBias        : Text;
  };

  public func fullBehavioralDecision(
    outcome: Float,
    reference: Float,
    delay: Float,
    swarmBehavior: Float,
    coherence: Float,
    anchor: Float
  ) : BehavioralDecision {
    // 1. Prospect theory valuation
    let pv = prospectValue(outcome, reference);

    // 2. Temporal discounting
    let tv = hyperbolicDiscount(pv.subjectiveValue, delay);

    // 3. Anchoring
    let av = anchoredJudgment(anchor, tv.discountedValue);

    // 4. Social proof
    let sp = socialProofDecision(av.finalEstimate, swarmBehavior, coherence);

    // Determine dominant bias
    let biases = [
      ("LOSS_AVERSION", if (not pv.isGain) { LOSS_AVERSION_LAMBDA - 1.0 } else { 0.0 }),
      ("PRESENT_BIAS", tv.presentBias),
      ("ANCHORING", av.anchorInfluence),
      ("CONFORMITY", sp.conformityPressure)
    ];

    var dominantBias : Text = "NEUTRAL";
    var maxInfluence : Float = 0.0;
    for ((name, influence) in biases.vals()) {
      if (Float.abs(influence) > maxInfluence) {
        maxInfluence := Float.abs(influence);
        dominantBias := name;
      };
    };

    // Confidence based on coherence and bias alignment
    let confidence = _clamp(0.5 + coherence * 0.3 - maxInfluence * 0.1, 0.2, 0.95);

    {
      rawOutcome = outcome;
      referencePoint = reference;
      delay = delay;
      swarmBehavior = swarmBehavior;
      coherence = coherence;
      prospectValue = pv.subjectiveValue;
      temporalValue = tv.discountedValue;
      anchoredValue = av.finalEstimate;
      socialValue = sp.combinedSignal;
      finalValue = sp.combinedSignal;
      confidence = confidence;
      dominantBias = dominantBias;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  7. FORMA TOKEN ECONOMICS — BEHAVIORAL VALUATION  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // FORMA tokens are valued using behavioral economics:
  //   - Reference dependence: Value relative to acquisition cost
  //   - Loss aversion: Selling at loss hurts 2.25x
  //   - Endowment effect: Owned tokens valued higher
  //   - Mental accounting: Tokens from different sources valued differently
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type FORMAValuation = {
    marketPrice       : Float;   // Objective market price
    acquisitionCost   : Float;   // What the holder paid
    perceivedValue    : Float;   // Subjective value to holder
    sellingThreshold  : Float;   // Price at which they'd sell
    endowmentPremium  : Float;   // Extra value from ownership
  };

  public func valueFORMA(
    marketPrice: Float,
    acquisitionCost: Float,
    holdingDuration: Float  // In beats
  ) : FORMAValuation {
    // Endowment effect: longer holding = higher perceived value
    let endowmentPremium = 0.1 * Float.log(1.0 + holdingDuration / 100.0);

    // Perceived value combines market price with endowment
    let perceivedValue = marketPrice * (1.0 + endowmentPremium);

    // Selling threshold accounts for loss aversion
    let gainLoss = marketPrice - acquisitionCost;
    let sellingThreshold = if (gainLoss >= 0.0) {
      // In gain territory: willing to sell near market
      marketPrice * 0.95
    } else {
      // In loss territory: need premium to compensate for loss aversion
      acquisitionCost * (1.0 + LOSS_AVERSION_LAMBDA * 0.1)
    };

    {
      marketPrice = marketPrice;
      acquisitionCost = acquisitionCost;
      perceivedValue = perceivedValue;
      sellingThreshold = sellingThreshold;
      endowmentPremium = endowmentPremium;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  8. RISK PERCEPTION — SUBJECTIVE PROBABILITY  ████
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type RiskPerception = {
    objectiveProb     : Float;   // Actual probability
    subjectiveProb    : Float;   // Perceived probability
    dreadFactor       : Float;   // Emotional weight of outcome
    controllability   : Float;   // Perceived control over outcome
    riskTaking        : Float;   // 0 = risk averse, 1 = risk seeking
  };

  public func perceiveRisk(
    objectiveProb: Float,
    outcomeValence: Float,  // Positive or negative outcome?
    familiarity: Float,     // How familiar is this risk?
    coherence: Float        // Swarm coherence (safety in numbers)
  ) : RiskPerception {
    let isNegative = outcomeValence < 0.0;

    // Subjective probability (overweight small, underweight large)
    let subjectiveProb = probabilityWeight(objectiveProb, not isNegative);

    // Dread: unfamiliar + negative = more dread
    let dreadFactor = if (isNegative) {
      (1.0 - familiarity) * Float.abs(outcomeValence)
    } else { 0.0 };

    // Controllability: coherent swarm feels more in control
    let controllability = 0.3 + coherence * 0.5;

    // Risk taking: gains domain = risk averse, loss domain = risk seeking
    let riskTaking = if (isNegative) {
      0.6 + (1.0 - coherence) * 0.2  // Risk seeking in losses
    } else {
      0.4 - (1.0 - coherence) * 0.2  // Risk averse in gains
    };

    {
      objectiveProb = objectiveProb;
      subjectiveProb = subjectiveProb;
      dreadFactor = dreadFactor;
      controllability = controllability;
      riskTaking = _clamp(riskTaking, 0.0, 1.0);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████████████████████████████████████████████████████████████████████████████████████
  // ██                                                                                ██
  // ██  TRADING PSYCHOLOGY — 6 BOOKS AS DECISION ARCHITECTURE                         ██
  // ██                                                                                ██
  // ██  1. Trading in the Zone (Mark Douglas) — Probabilistic thinking                ██
  // ██  2. Market Wizards (Jack Schwager) — Risk management principles                ██
  // ██  3. Market Mind Games (Denise Shull) — Emotional intelligence in trading       ██
  // ██  4. Trading to Win (Ari Kiev) — Performance psychology                         ██
  // ██  5. Principles (Ray Dalio) — Pain + Reflection = Progress                      ██
  // ██  6. Stoicism — Dichotomy of control, acceptance of outcomes                    ██
  // ██                                                                                ██
  // ████████████████████████████████████████████████████████████████████████████████████
  // ══════════════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────────────
  // BOOK 1: TRADING IN THE ZONE (Mark Douglas)
  // Core insight: Markets are probabilistic. Every edge has a random distribution.
  // The key is consistency, not prediction.
  // ─────────────────────────────────────────────────────────────────────────────────────

  public type ZoneState = {
    // Core belief states
    acceptsRandomDistribution : Bool;    // Accepts that any trade can lose
    definesOwnRisk           : Bool;     // Pre-defines risk before entry
    acceptsRiskCompletely    : Bool;     // No hoping, wishing, praying
    actsWithoutHesitation    : Bool;     // When edge appears, executes
    paysYourselfProfits      : Bool;     // Takes profits without greed
    
    // Probabilistic thinking score [0, 1]
    probabilisticThinking    : Float;
    
    // Trader's mindset
    fearOfBeingWrong         : Float;    // [0, 1] — should be LOW
    fearOfMissingOut         : Float;    // [0, 1] — should be LOW  
    fearOfLettingProfitTurn  : Float;    // [0, 1] — should be LOW
    fearOfNotBeingRight      : Float;    // [0, 1] — should be LOW
    
    // Flow state
    inTheZone                : Bool;
  };

  // Douglas's 5 fundamental truths
  public func evaluateZoneState(
    recentTradeOutcomes: [Bool],   // Recent wins/losses
    preDefinedRisk: Bool,
    executionHesitation: Float,    // [0, 1]
    profitTakingGreed: Float       // [0, 1]
  ) : ZoneState {
    // Count wins to assess acceptance of random distribution
    var wins : Nat = 0;
    var losses : Nat = 0;
    for (outcome in recentTradeOutcomes.vals()) {
      if (outcome) { wins += 1 } else { losses += 1 };
    };
    let totalTrades = wins + losses;
    let winRate = if (totalTrades > 0) { Float.fromInt(wins) / Float.fromInt(totalTrades) } else { 0.5 };
    
    // Probabilistic thinking: high if win rate is moderate (not extreme)
    let probabilistic = 1.0 - Float.abs(winRate - 0.5) * 2.0;
    
    // Fears are INVERSE of good trading psychology
    let fearWrong = executionHesitation * 0.7;
    let fearMissing = profitTakingGreed * 0.5;
    let fearProfitTurn = profitTakingGreed * 0.8;
    let fearNotRight = executionHesitation * 0.5;
    
    // In the zone when all fears are low and probabilistic thinking is high
    let totalFear = fearWrong + fearMissing + fearProfitTurn + fearNotRight;
    let zoneState = probabilistic > 0.7 and totalFear < 1.0;
    
    {
      acceptsRandomDistribution = probabilistic > 0.6;
      definesOwnRisk = preDefinedRisk;
      acceptsRiskCompletely = fearWrong < 0.3;
      actsWithoutHesitation = executionHesitation < 0.3;
      paysYourselfProfits = profitTakingGreed < 0.3;
      probabilisticThinking = probabilistic;
      fearOfBeingWrong = fearWrong;
      fearOfMissingOut = fearMissing;
      fearOfLettingProfitTurn = fearProfitTurn;
      fearOfNotBeingRight = fearNotRight;
      inTheZone = zoneState;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────
  // BOOK 2: MARKET WIZARDS (Jack Schwager)
  // Core insights from top traders: Risk management, cutting losses, letting profits run
  // ─────────────────────────────────────────────────────────────────────────────────────

  public type WizardPrinciples = {
    // Risk rules
    maxRiskPerTrade          : Float;    // Never risk more than X% per trade (typically 1-2%)
    maxDailyDrawdown         : Float;    // Stop trading after X% daily loss
    positionSizeRule         : Float;    // Position size = risk / (entry - stop)
    
    // Trade management
    cutLossesQuickly         : Bool;     // Exit losing trades fast
    letProfitsRun            : Bool;     // Don't cut winners short
    addToWinners             : Bool;     // Scale into winning positions
    neverAddToLosers         : Bool;     // Never average down
    
    // Market selection
    tradeLiquidMarkets       : Bool;     // Only trade liquid instruments
    followTrend              : Bool;     // Trade with the trend
    waitForConfirmation      : Bool;     // Don't anticipate, react
    
    // Wizard score [0, 1]
    wizardAlignment          : Float;
  };

  public func evaluateWizardPrinciples(
    currentRiskPerTrade: Float,
    dailyDrawdown: Float,
    recentCutLosses: Bool,
    recentLetProfitsRun: Bool,
    addedToLoser: Bool,
    marketLiquidity: Float,       // [0, 1]
    trendAlignment: Float         // [-1, 1], positive = with trend
  ) : WizardPrinciples {
    let maxRisk = 0.02;  // 2% max risk per trade (Wizard standard)
    let maxDrawdown = 0.05;  // 5% max daily drawdown
    
    let riskCompliant = currentRiskPerTrade <= maxRisk;
    let drawdownCompliant = dailyDrawdown <= maxDrawdown;
    let liquidityOk = marketLiquidity > 0.6;
    let trendOk = trendAlignment > 0.0;
    
    // Wizard alignment score
    var score : Float = 0.0;
    if (riskCompliant) { score += 0.2 };
    if (drawdownCompliant) { score += 0.15 };
    if (recentCutLosses) { score += 0.2 };
    if (recentLetProfitsRun) { score += 0.2 };
    if (not addedToLoser) { score += 0.1 };
    if (liquidityOk) { score += 0.1 };
    if (trendOk) { score += 0.05 };
    
    {
      maxRiskPerTrade = maxRisk;
      maxDailyDrawdown = maxDrawdown;
      positionSizeRule = currentRiskPerTrade;
      cutLossesQuickly = recentCutLosses;
      letProfitsRun = recentLetProfitsRun;
      addToWinners = trendAlignment > 0.3 and recentLetProfitsRun;
      neverAddToLosers = not addedToLoser;
      tradeLiquidMarkets = liquidityOk;
      followTrend = trendOk;
      waitForConfirmation = true;  // Always true for the organism
      wizardAlignment = score;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────
  // BOOK 3: MARKET MIND GAMES (Denise Shull)
  // Core insight: Emotions are DATA, not noise. Use them.
  // ─────────────────────────────────────────────────────────────────────────────────────

  public type EmotionalIntelligence = {
    // Emotional awareness
    fearLevel                : Float;    // [0, 1]
    greedLevel               : Float;    // [0, 1]
    hopeLevel                : Float;    // [0, 1] — hope is dangerous in trading
    angerLevel               : Float;    // [0, 1] — revenge trading
    
    // Emotional intelligence metrics
    emotionalAwareness       : Float;    // [0, 1] — knowing what you feel
    emotionalRegulation      : Float;    // [0, 1] — controlling emotions
    emotionalUtilization     : Float;    // [0, 1] — using emotions as data
    
    // Shull's key insight: Intuition = unconscious pattern recognition
    intuitionStrength        : Float;    // [0, 1]
    intuitionClarity         : Float;    // [0, 1] — is the signal clear?
    
    // Overall EQ score
    tradingEQ                : Float;
  };

  public func evaluateEmotionalIntelligence(
    fear: Float,
    greed: Float,
    hope: Float,
    anger: Float,
    coherence: Float,           // Organism coherence
    recentAccuracy: Float       // How accurate recent intuitions were
  ) : EmotionalIntelligence {
    // Emotional awareness = inversely related to extreme emotions
    let extremity = (Float.abs(fear - 0.3) + Float.abs(greed - 0.3) + hope + anger) / 4.0;
    let awareness = 1.0 - extremity;
    
    // Emotional regulation = coherence (swarm coherence = emotional stability)
    let regulation = coherence;
    
    // Emotional utilization = moderate emotions channeled productively
    let optimalFear = 0.3;  // Some fear is healthy
    let optimalGreed = 0.3; // Some greed drives action
    let fearUtilization = 1.0 - Float.abs(fear - optimalFear);
    let greedUtilization = 1.0 - Float.abs(greed - optimalGreed);
    let utilization = (fearUtilization + greedUtilization) / 2.0;
    
    // Intuition = pattern recognition accuracy
    let intuitionStrength = recentAccuracy;
    let intuitionClarity = coherence * recentAccuracy;
    
    // Trading EQ = weighted average
    let eq = awareness * 0.2 + regulation * 0.3 + utilization * 0.2 + 
             intuitionStrength * 0.2 + intuitionClarity * 0.1;
    
    {
      fearLevel = fear;
      greedLevel = greed;
      hopeLevel = hope;
      angerLevel = anger;
      emotionalAwareness = _clamp(awareness, 0.0, 1.0);
      emotionalRegulation = _clamp(regulation, 0.0, 1.0);
      emotionalUtilization = _clamp(utilization, 0.0, 1.0);
      intuitionStrength = _clamp(intuitionStrength, 0.0, 1.0);
      intuitionClarity = _clamp(intuitionClarity, 0.0, 1.0);
      tradingEQ = _clamp(eq, 0.0, 1.0);
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────
  // BOOK 4: TRADING TO WIN (Ari Kiev)
  // Core insight: Performance psychology. Goal setting. Mental rehearsal.
  // ─────────────────────────────────────────────────────────────────────────────────────

  public type PerformanceState = {
    // Goal structure
    hasSpecificGoal          : Bool;
    goalClarity              : Float;    // [0, 1]
    goalCommitment           : Float;    // [0, 1]
    
    // Mental preparation
    mentalRehearsalDone      : Bool;
    scenarioPlanning         : Float;    // [0, 1] — prepared for multiple outcomes
    
    // Execution state
    focusLevel               : Float;    // [0, 1]
    confidenceLevel          : Float;    // [0, 1]
    disciplineLevel          : Float;    // [0, 1]
    
    // Performance zone
    inPerformanceZone        : Bool;
    performanceScore         : Float;
  };

  public func evaluatePerformanceState(
    currentGoal: ?Float,          // Target profit/loss
    coherence: Float,
    recentDiscipline: Float,      // How well did organism follow its rules?
    focusMetric: Float            // Attention metric from organism
  ) : PerformanceState {
    let hasGoal = switch (currentGoal) { case (?_) { true }; case (null) { false } };
    let goalClear = if (hasGoal) { 0.8 } else { 0.2 };
    let commitment = if (hasGoal) { coherence } else { 0.3 };
    
    // Mental rehearsal assumed if organism has predictive models running
    let rehearsed = true;  // Organism always runs simulations
    let scenarios = coherence * 0.8;  // Higher coherence = better scenario planning
    
    // Performance metrics
    let focus = focusMetric;
    let confidence = (coherence + recentDiscipline) / 2.0;
    let discipline = recentDiscipline;
    
    // Performance zone = high focus + high discipline + moderate confidence
    let zoneScore = focus * 0.35 + discipline * 0.35 + confidence * 0.3;
    let inZone = zoneScore > 0.7;
    
    {
      hasSpecificGoal = hasGoal;
      goalClarity = goalClear;
      goalCommitment = commitment;
      mentalRehearsalDone = rehearsed;
      scenarioPlanning = _clamp(scenarios, 0.0, 1.0);
      focusLevel = _clamp(focus, 0.0, 1.0);
      confidenceLevel = _clamp(confidence, 0.0, 1.0);
      disciplineLevel = _clamp(discipline, 0.0, 1.0);
      inPerformanceZone = inZone;
      performanceScore = _clamp(zoneScore, 0.0, 1.0);
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────
  // BOOK 5: PRINCIPLES (Ray Dalio)
  // Core insight: Pain + Reflection = Progress. Radical transparency. Idea meritocracy.
  // ─────────────────────────────────────────────────────────────────────────────────────

  public type DalioPrinciples = {
    // The formula
    painLevel                : Float;    // [0, 1] — from losses
    reflectionLevel          : Float;    // [0, 1] — learning from pain
    progressLevel            : Float;    // [0, 1] — Pain × Reflection
    
    // Radical transparency
    transparencyScore        : Float;    // [0, 1] — how honest with self
    
    // Idea meritocracy (best ideas win)
    beliefConfidence         : Float;    // [0, 1] — confidence in beliefs
    beliefUpdateRate         : Float;    // How quickly beliefs update with evidence
    
    // Dalio's key principle: Embrace reality and deal with it
    realityAcceptance        : Float;    // [0, 1]
    
    // Overall Dalio alignment
    principlesScore          : Float;
  };

  public func evaluateDalioPrinciples(
    recentLoss: Float,            // Magnitude of recent loss
    lessonLearned: Bool,          // Did organism update from loss?
    beliefUpdateOccurred: Bool,   // Did beliefs change with evidence?
    coherence: Float
  ) : DalioPrinciples {
    // Pain level from recent loss (normalized)
    let pain = _clamp(recentLoss * 10.0, 0.0, 1.0);
    
    // Reflection = did we learn? Plus coherence (self-awareness)
    let reflection = if (lessonLearned) { 0.7 + coherence * 0.3 } else { coherence * 0.3 };
    
    // Progress = Pain × Reflection (Dalio's formula)
    let progress = pain * reflection;
    
    // Transparency = coherence (transparent with self = coherent)
    let transparency = coherence;
    
    // Belief update rate
    let beliefUpdate = if (beliefUpdateOccurred) { 0.8 } else { 0.2 };
    let beliefConfidence = coherence;
    
    // Reality acceptance = accepting losses + updating beliefs
    let realityAccept = (if (recentLoss > 0.0 and lessonLearned) { 0.8 } else { 0.4 }) + 
                        (if (beliefUpdateOccurred) { 0.2 } else { 0.0 });
    
    // Principles score
    let score = (progress * 0.3 + transparency * 0.2 + beliefUpdate * 0.2 + 
                 realityAccept * 0.3);
    
    {
      painLevel = pain;
      reflectionLevel = reflection;
      progressLevel = progress;
      transparencyScore = transparency;
      beliefConfidence = beliefConfidence;
      beliefUpdateRate = beliefUpdate;
      realityAcceptance = _clamp(realityAccept, 0.0, 1.0);
      principlesScore = _clamp(score, 0.0, 1.0);
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────
  // BOOK 6: STOICISM (Marcus Aurelius, Seneca, Epictetus)
  // Core insight: Control what you can control. Accept what you cannot.
  // ─────────────────────────────────────────────────────────────────────────────────────

  public type StoicMindset = {
    // Dichotomy of control
    focusOnControllables     : Float;    // [0, 1] — focus on what you control
    acceptUncontrollables    : Float;    // [0, 1] — accept what you cannot control
    
    // Key Stoic virtues
    wisdomScore              : Float;    // [0, 1] — making good judgments
    courageScore             : Float;    // [0, 1] — acting despite fear
    justiceScore             : Float;    // [0, 1] — fair dealing
    temperanceScore          : Float;    // [0, 1] — moderation
    
    // Stoic practices
    premeditationOfEvils     : Bool;     // Have you considered what could go wrong?
    amorFati                 : Float;    // [0, 1] — love of fate, acceptance
    momentoMori              : Float;    // [0, 1] — remembrance of death (urgency)
    
    // Overall Stoic score
    stoicAlignment           : Float;
  };

  public func evaluateStoicMindset(
    attentionOnProcess: Float,    // Focus on process vs outcome
    recentLossAcceptance: Float,  // How well did organism accept loss?
    riskAssessmentDone: Bool,     // Did organism consider downsides?
    moderationLevel: Float,       // Position sizing moderation
    fairnessMetric: Float,        // Fair dealing with counterparties
    urgencyLevel: Float           // Acting with appropriate urgency
  ) : StoicMindset {
    // Dichotomy of control
    let controllables = attentionOnProcess;
    let uncontrollables = recentLossAcceptance;
    
    // Virtues
    let wisdom = (attentionOnProcess + if (riskAssessmentDone) { 0.5 } else { 0.0 }) / 1.5;
    let courage = 1.0 - LOSS_AVERSION_LAMBDA / 3.0;  // Lower loss aversion = more courage
    let justice = fairnessMetric;
    let temperance = moderationLevel;
    
    // Practices
    let premeditatio = riskAssessmentDone;
    let amorFati = recentLossAcceptance;
    let momentoMori = urgencyLevel;
    
    // Stoic alignment = average of all scores
    let score = (controllables + uncontrollables + wisdom + courage + 
                 justice + temperance + amorFati + momentoMori) / 8.0;
    
    {
      focusOnControllables = _clamp(controllables, 0.0, 1.0);
      acceptUncontrollables = _clamp(uncontrollables, 0.0, 1.0);
      wisdomScore = _clamp(wisdom, 0.0, 1.0);
      courageScore = _clamp(courage, 0.0, 1.0);
      justiceScore = _clamp(justice, 0.0, 1.0);
      temperanceScore = _clamp(temperance, 0.0, 1.0);
      premeditationOfEvils = premeditatio;
      amorFati = _clamp(amorFati, 0.0, 1.0);
      momentoMori = _clamp(momentoMori, 0.0, 1.0);
      stoicAlignment = _clamp(score, 0.0, 1.0);
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────────────
  // INTEGRATED TRADING PSYCHOLOGY — Combining all 6 books
  // ─────────────────────────────────────────────────────────────────────────────────────

  public type IntegratedTradingPsychology = {
    // Individual book scores
    zoneScore                : Float;    // Trading in the Zone
    wizardScore              : Float;    // Market Wizards
    eqScore                  : Float;    // Market Mind Games
    performanceScore         : Float;    // Trading to Win
    dalioScore               : Float;    // Principles
    stoicScore               : Float;    // Stoicism
    
    // Composite scores
    executionReadiness       : Float;    // Ready to execute trades
    riskManagementQuality    : Float;    // Risk management discipline
    emotionalBalance         : Float;    // Emotional regulation
    learningCapacity         : Float;    // Ability to learn from mistakes
    
    // Overall trading psychology score
    overallPsychologyScore   : Float;
    
    // Trading permission
    psychologicallyFitToTrade : Bool;
  };

  public func integratedTradingPsychology(
    zone: ZoneState,
    wizard: WizardPrinciples,
    eq: EmotionalIntelligence,
    performance: PerformanceState,
    dalio: DalioPrinciples,
    stoic: StoicMindset
  ) : IntegratedTradingPsychology {
    // Book scores
    let zScore = if (zone.inTheZone) { 1.0 } else { zone.probabilisticThinking };
    let wScore = wizard.wizardAlignment;
    let eScore = eq.tradingEQ;
    let pScore = performance.performanceScore;
    let dScore = dalio.principlesScore;
    let sScore = stoic.stoicAlignment;
    
    // Composite scores
    let execution = (zScore + pScore + eScore) / 3.0;
    let risk = wScore;
    let emotional = (eScore + sScore) / 2.0;
    let learning = dScore;
    
    // Overall score (weighted)
    let overall = zScore * 0.15 + wScore * 0.20 + eScore * 0.15 + 
                  pScore * 0.15 + dScore * 0.15 + sScore * 0.20;
    
    // Fit to trade if overall > 0.6 and no major red flags
    let fit = overall > 0.6 and 
              wScore > 0.5 and  // Must have risk management
              sScore > 0.4;     // Must have some Stoic acceptance
    
    {
      zoneScore = zScore;
      wizardScore = wScore;
      eqScore = eScore;
      performanceScore = pScore;
      dalioScore = dScore;
      stoicScore = sScore;
      executionReadiness = _clamp(execution, 0.0, 1.0);
      riskManagementQuality = _clamp(risk, 0.0, 1.0);
      emotionalBalance = _clamp(emotional, 0.0, 1.0);
      learningCapacity = _clamp(learning, 0.0, 1.0);
      overallPsychologyScore = _clamp(overall, 0.0, 1.0);
      psychologicallyFitToTrade = fit;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // FEAR = LOSS AVERSION (WIRING)
  // The FearArchitecture module's fear IS the loss aversion λ = 2.25
  // This function converts organism fear level to loss aversion coefficient
  // ══════════════════════════════════════════════════════════════════════════════════════

  public func fearToLossAversion(fearLevel: Float) : Float {
    // Baseline loss aversion λ = 2.25 (Kahneman & Tversky)
    // Higher fear = higher loss aversion (losses hurt more)
    // Lower fear = lower loss aversion (can take more risk)
    // Range: 1.5 (low fear) to 3.5 (high fear)
    let minLambda = 1.5;
    let maxLambda = 3.5;
    let baseline = LOSS_AVERSION_LAMBDA;  // 2.25
    
    // Fear maps to loss aversion
    minLambda + (maxLambda - minLambda) * fearLevel
  };

  // Position size adjustment based on loss aversion
  public func positionSizeFromLossAversion(
    basePositionSize: Float,
    lossAversion: Float,
    currentDrawdown: Float
  ) : Float {
    // Higher loss aversion = smaller positions
    // Higher drawdown = even smaller positions (risk scaling)
    let lambdaAdjustment = LOSS_AVERSION_LAMBDA / lossAversion;
    let drawdownFactor = 1.0 - currentDrawdown * 2.0;
    _clamp(basePositionSize * lambdaAdjustment * drawdownFactor, 0.0, basePositionSize)
  };

}
