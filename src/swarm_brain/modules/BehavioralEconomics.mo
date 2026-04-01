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

}
