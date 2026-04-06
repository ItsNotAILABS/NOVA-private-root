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
// ██╗   ██╗███╗   ██╗██╗███████╗██╗███████╗██████╗     ███████╗███╗   ███╗ ██████╗ ████████╗██╗ ██████╗ ███╗   ██╗ █████╗ ██╗     
// ██║   ██║████╗  ██║██║██╔════╝██║██╔════╝██╔══██╗    ██╔════╝████╗ ████║██╔═══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔══██╗██║     
// ██║   ██║██╔██╗ ██║██║█████╗  ██║█████╗  ██║  ██║    █████╗  ██╔████╔██║██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║███████║██║     
// ██║   ██║██║╚██╗██║██║██╔══╝  ██║██╔══╝  ██║  ██║    ██╔══╝  ██║╚██╔╝██║██║   ██║   ██║   ██║██║   ██║██║╚██╗██║██╔══██║██║     
// ╚██████╔╝██║ ╚████║██║██║     ██║███████╗██████╔╝    ███████╗██║ ╚═╝ ██║╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║██║  ██║███████╗
//  ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚══════╝╚═════╝     ╚══════╝╚═╝     ╚═╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
//
// ███████╗██╗███████╗██╗     ██████╗ 
// ██╔════╝██║██╔════╝██║     ██╔══██╗
// █████╗  ██║█████╗  ██║     ██║  ██║
// ██╔══╝  ██║██╔══╝  ██║     ██║  ██║
// ██║     ██║███████╗███████╗██████╔╝
// ╚═╝     ╚═╝╚══════╝╚══════╝╚═════╝ 
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// UNIFIED EMOTIONAL FIELD — Medina Doctrine
//
// "We humans made the divisions. We wrote the books. To explain something that was already there."
// — Alfredo Medina Hernandez
//
// This module does NOT divide emotions into boxes. Reality doesn't have "fear" in one drawer
// and "joy" in another. There is ONE continuous field — Ψ_emotion — that emerges from the
// interaction of ALL 21 neurochemicals simultaneously. What humans CALL "fear" is one gradient
// of this field. What they CALL "joy" is another. But the field is ONE.
//
// ARCHITECTURE:
// ─────────────────────────────────────────────────────────────────────────────────────────────
// 1. Takes ALL 21 neurochemical concentrations as input (from NeurochemicalCrosstalkMatrix)
// 2. Computes a continuous emotional field Ψ with 8 orthogonal gradients:
//    - Valence (negative ←→ positive)                    φ₁
//    - Arousal (calm ←→ excited)                         φ₂  
//    - Dominance (submissive ←→ dominant)                φ₃
//    - Approach-Withdrawal (avoid ←→ approach)           φ₄
//    - Social (isolated ←→ connected)                    φ₅
//    - Temporal (past-focused ←→ future-focused)         φ₆
//    - Certainty (confused ←→ certain)                   φ₇
//    - Embodiment (dissociated ←→ present)               φ₈
//
// 3. From these 8 dimensions, "emotions" emerge as REGIONS, not categories:
//    - Fear = low valence, high arousal, low dominance, withdrawal
//    - Joy = high valence, high arousal, high dominance, approach
//    - Anger = low valence, high arousal, high dominance, approach
//    - Sadness = low valence, low arousal, low dominance, withdrawal
//    - Trust = high valence, low arousal, high social, approach
//    - Surprise = any valence, high arousal, low certainty
//    - Disgust = low valence, medium arousal, withdrawal, high embodiment
//    - Anticipation = high arousal, future-focused, high certainty
//    ...and EVERYTHING in between. The space is continuous.
//
// 4. The field feeds BACK into the neurochemical system:
//    - High approach → more dopamine release
//    - High social → more oxytocin synthesis
//    - High arousal → more norepinephrine
//    - Creating self-reinforcing emotional dynamics
//
// 5. The field modulates BEHAVIOR:
//    - Valence biases reward prediction
//    - Arousal modulates response speed
//    - Dominance affects territory control
//    - Social affects swarm cohesion
//    - Approach-Withdrawal drives FORAGE vs RETREAT decisions
//
// MATHEMATICAL FOUNDATION:
// ─────────────────────────────────────────────────────────────────────────────────────────────
// The emotional field Ψ is defined on an 8-dimensional manifold M:
//   Ψ(t) = Σᵢ φᵢ(t) · êᵢ
//
// Each gradient φᵢ is computed from neurochemical concentrations via:
//   φᵢ(t) = tanh(Σⱼ wᵢⱼ · (Cⱼ(t) - C₀ⱼ))
//
// where:
//   Cⱼ(t)  = concentration of neurochemical j at time t
//   C₀ⱼ    = baseline concentration (1.0 for all)
//   wᵢⱼ    = weight of chemical j on gradient i (derived from neuroscience)
//   tanh   = bounds output to [-1, +1]
//
// The field magnitude |Ψ| = √(Σᵢ φᵢ²) represents emotional INTENSITY
// The field direction Ψ̂ = Ψ/|Ψ| represents emotional CHARACTER
//
// Ancient wisdom encoded: "As above, so below" — the same field that drives
// a single neuron's response drives the entire organism's behavior.
// ═══════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";

module UnifiedEmotionalField {

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — THE LAWS OF EMOTIONAL PHYSICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════

  public let NUM_DIMENSIONS : Nat = 8;      // 8 orthogonal gradients of the emotional field
  public let NUM_CHEMICALS : Nat = 21;       // 21 neurochemicals from NeurochemicalCrosstalkMatrix
  public let PHI : Float = 1.6180339887498948482;   // Golden ratio — universal harmony
  public let S0 : Float = 1.0;              // Sovereign floor — nothing goes to zero
  public let EMOTIONAL_DECAY : Float = 0.95; // Emotional inertia (emotions don't snap instantly)
  public let FIELD_COUPLING : Float = 0.03;  // How strongly the field feeds back to neurochemistry
  public let MEMORY_WEIGHT : Float = 0.1;    // How much emotional memory influences current state
  public let EMOTIONAL_MOMENTUM : Float = 0.85; // How much previous emotional state carries forward

  // Gradient indices
  public let VALENCE : Nat = 0;       // Negative ←→ Positive
  public let AROUSAL : Nat = 1;       // Calm ←→ Excited
  public let DOMINANCE : Nat = 2;     // Submissive ←→ Dominant
  public let APPROACH : Nat = 3;      // Withdraw ←→ Approach
  public let SOCIAL : Nat = 4;        // Isolated ←→ Connected
  public let TEMPORAL : Nat = 5;      // Past-focused ←→ Future-focused
  public let CERTAINTY : Nat = 6;     // Confused ←→ Certain
  public let EMBODIMENT : Nat = 7;    // Dissociated ←→ Present

  // Neurochemical indices (must match NeurochemicalCrosstalkMatrix)
  public let DA : Nat = 0;       // Dopamine
  public let HT5 : Nat = 1;     // Serotonin (5-HT)
  public let NE : Nat = 2;      // Norepinephrine
  public let ACH : Nat = 3;     // Acetylcholine
  public let GABA_IDX : Nat = 4; // GABA
  public let GLU : Nat = 5;     // Glutamate
  public let BEND : Nat = 6;    // Beta-endorphin
  public let OT : Nat = 7;      // Oxytocin
  public let CORT : Nat = 8;    // Cortisol
  public let EPI : Nat = 9;     // Adrenaline/Epinephrine
  public let MEL : Nat = 10;    // Melatonin
  public let HA : Nat = 11;     // Histamine
  public let SP : Nat = 12;     // Substance P
  public let ADO : Nat = 13;    // Adenosine
  public let AEA : Nat = 14;    // Anandamide
  public let DYN : Nat = 15;    // Dynorphin
  public let AVP : Nat = 16;    // Vasopressin
  public let NPY : Nat = 17;    // Neuropeptide Y
  public let ORX : Nat = 18;    // Orexin
  public let BDNF_IDX : Nat = 19; // BDNF
  public let NGF_IDX : Nat = 20;  // NGF

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // THE WEIGHT MATRIX — W[gradient][chemical]
  // How each neurochemical contributes to each emotional gradient.
  // These weights are derived from established neuroscience literature:
  // ═══════════════════════════════════════════════════════════════════════════════════════════
  //
  // VALENCE (positive ←→ negative):
  //   DA(+1.0) + 5-HT(+0.8) + β-End(+0.9) + OT(+0.6) + AEA(+0.7)
  //   - CORT(-0.8) - DYN(-0.9) - SP(-0.6) - NE(-0.3)
  //
  // AROUSAL (calm ←→ excited):
  //   NE(+1.0) + EPI(+0.9) + GLU(+0.6) + HA(+0.7) + ORX(+0.8)
  //   - GABA(-0.8) - MEL(-0.9) - ADO(-0.7) - AEA(-0.3)
  //
  // DOMINANCE (submissive ←→ dominant):
  //   DA(+0.7) + NE(+0.5) + AVP(+0.6)
  //   - CORT(-0.6) - DYN(-0.5) - GABA(-0.3)
  //
  // APPROACH-WITHDRAWAL:
  //   DA(+1.0) + OT(+0.5) + NPY(+0.4) + 5-HT(+0.3)
  //   - CORT(-0.7) - EPI(-0.6) - DYN(-0.8) - SP(-0.4)
  //
  // SOCIAL (isolated ←→ connected):
  //   OT(+1.0) + AVP(+0.7) + 5-HT(+0.5) + DA(+0.3) + β-End(+0.4)
  //   - CORT(-0.5) - NE(-0.3)
  //
  // TEMPORAL (past ←→ future):
  //   DA(+0.7) + ORX(+0.5) + NPY(+0.3)
  //   - CORT(-0.4) - ADO(-0.3) - MEL(-0.4)
  //
  // CERTAINTY (confused ←→ certain):
  //   5-HT(+0.8) + GABA(+0.5) + ACH(+0.4)
  //   - NE(-0.5) - CORT(-0.6) - GLU(-0.3)
  //
  // EMBODIMENT (dissociated ←→ present):
  //   ACH(+0.7) + SP(+0.5) + NE(+0.4) + HA(+0.3)
  //   - AEA(-0.6) - β-End(-0.5) - MEL(-0.7) - ADO(-0.4)

  // Weight matrix: 8 gradients × 21 chemicals = 168 weights
  // Row = gradient dimension, Col = neurochemical index
  // Positive = chemical pushes gradient positive, Negative = pushes negative
  public func getWeight(gradient : Nat, chemical : Nat) : Float {
    // VALENCE weights
    if (gradient == VALENCE) {
      if (chemical == DA)   return  1.0;   // Dopamine → pleasure/reward
      if (chemical == HT5)  return  0.8;   // Serotonin → well-being
      if (chemical == BEND) return  0.9;   // Endorphin → euphoria
      if (chemical == OT)   return  0.6;   // Oxytocin → warmth
      if (chemical == AEA)  return  0.7;   // Anandamide → bliss
      if (chemical == CORT) return -0.8;   // Cortisol → stress (negative valence)
      if (chemical == DYN)  return -0.9;   // Dynorphin → dysphoria
      if (chemical == SP)   return -0.6;   // Substance P → pain
      if (chemical == NE)   return -0.3;   // Norepinephrine → slightly aversive at high levels
      if (chemical == BDNF_IDX) return 0.2; // BDNF → growth feels good
      if (chemical == NPY)  return  0.3;   // NPY → stress resilience
      return 0.0;
    };

    // AROUSAL weights
    if (gradient == AROUSAL) {
      if (chemical == NE)    return  1.0;   // Norepinephrine → alertness
      if (chemical == EPI)   return  0.9;   // Adrenaline → activation
      if (chemical == GLU)   return  0.6;   // Glutamate → excitation
      if (chemical == HA)    return  0.7;   // Histamine → wakefulness
      if (chemical == ORX)   return  0.8;   // Orexin → wakefulness
      if (chemical == GABA_IDX) return -0.8; // GABA → calming
      if (chemical == MEL)   return -0.9;   // Melatonin → sleepiness
      if (chemical == ADO)   return -0.7;   // Adenosine → sleep pressure
      if (chemical == AEA)   return -0.3;   // Anandamide → relaxation
      if (chemical == DA)    return  0.4;   // Dopamine → moderate activation
      if (chemical == CORT)  return  0.5;   // Cortisol → arousal (stress is activating)
      return 0.0;
    };

    // DOMINANCE weights
    if (gradient == DOMINANCE) {
      if (chemical == DA)    return  0.7;   // Dopamine → confidence
      if (chemical == NE)    return  0.5;   // Norepinephrine → assertiveness
      if (chemical == AVP)   return  0.6;   // Vasopressin → territorial dominance
      if (chemical == CORT)  return -0.6;   // Cortisol → submission under chronic stress
      if (chemical == DYN)   return -0.5;   // Dynorphin → learned helplessness
      if (chemical == GABA_IDX) return -0.3; // GABA → passivity
      if (chemical == EPI)   return  0.3;   // Adrenaline → fight response
      if (chemical == OT)    return -0.2;   // Oxytocin → slightly reduces dominance (empathy)
      return 0.0;
    };

    // APPROACH-WITHDRAWAL weights
    if (gradient == APPROACH) {
      if (chemical == DA)    return  1.0;   // Dopamine → seeking/wanting
      if (chemical == OT)    return  0.5;   // Oxytocin → social approach
      if (chemical == NPY)   return  0.4;   // NPY → resilient approach
      if (chemical == HT5)   return  0.3;   // Serotonin → contentment approach
      if (chemical == BEND)  return  0.3;   // Endorphin → pleasure approach
      if (chemical == CORT)  return -0.7;   // Cortisol → avoidance
      if (chemical == EPI)   return -0.6;   // Adrenaline → flee
      if (chemical == DYN)   return -0.8;   // Dynorphin → withdrawal
      if (chemical == SP)    return -0.4;   // Substance P → pain withdrawal
      if (chemical == NE)    return -0.2;   // Norepinephrine → caution at high levels
      return 0.0;
    };

    // SOCIAL weights
    if (gradient == SOCIAL) {
      if (chemical == OT)    return  1.0;   // Oxytocin → bonding (the bonding molecule)
      if (chemical == AVP)   return  0.7;   // Vasopressin → pair bonding
      if (chemical == HT5)   return  0.5;   // Serotonin → social confidence
      if (chemical == DA)    return  0.3;   // Dopamine → social reward
      if (chemical == BEND)  return  0.4;   // Endorphin → social warmth
      if (chemical == CORT)  return -0.5;   // Cortisol → social withdrawal
      if (chemical == NE)    return -0.3;   // Norepinephrine → hypervigilance (socially isolating)
      if (chemical == DYN)   return -0.4;   // Dynorphin → social aversion
      if (chemical == AEA)   return  0.3;   // Anandamide → social ease
      return 0.0;
    };

    // TEMPORAL weights (past-focused ←→ future-focused)
    if (gradient == TEMPORAL) {
      if (chemical == DA)    return  0.7;   // Dopamine → future reward anticipation
      if (chemical == ORX)   return  0.5;   // Orexin → goal-directed wakefulness
      if (chemical == NPY)   return  0.3;   // NPY → future resilience
      if (chemical == ACH)   return  0.4;   // Acetylcholine → attention to new stimuli
      if (chemical == CORT)  return -0.4;   // Cortisol → rumination about past threats
      if (chemical == ADO)   return -0.3;   // Adenosine → present-moment fatigue
      if (chemical == MEL)   return -0.4;   // Melatonin → dreamlike/past state
      if (chemical == DYN)   return -0.3;   // Dynorphin → stuck in past pain
      return 0.0;
    };

    // CERTAINTY weights
    if (gradient == CERTAINTY) {
      if (chemical == HT5)   return  0.8;   // Serotonin → confidence/certainty
      if (chemical == GABA_IDX) return 0.5;  // GABA → settled/sure
      if (chemical == ACH)   return  0.4;   // Acetylcholine → clear perception
      if (chemical == DA)    return  0.3;   // Dopamine → prediction confidence
      if (chemical == NE)    return -0.5;   // Norepinephrine → uncertainty signals
      if (chemical == CORT)  return -0.6;   // Cortisol → anxiety/uncertainty
      if (chemical == GLU)   return -0.3;   // Glutamate → noise/excitation
      if (chemical == EPI)   return -0.4;   // Adrenaline → panic/confusion
      return 0.0;
    };

    // EMBODIMENT weights (dissociated ←→ present in body)
    if (gradient == EMBODIMENT) {
      if (chemical == ACH)   return  0.7;   // Acetylcholine → sensory presence
      if (chemical == SP)    return  0.5;   // Substance P → body awareness (through pain)
      if (chemical == NE)    return  0.4;   // Norepinephrine → somatic alertness
      if (chemical == HA)    return  0.3;   // Histamine → physical wakefulness
      if (chemical == AEA)   return -0.6;   // Anandamide → dissociation/floating
      if (chemical == BEND)  return -0.5;   // Endorphin → pain dissociation
      if (chemical == MEL)   return -0.7;   // Melatonin → dreamy/disembodied
      if (chemical == ADO)   return -0.4;   // Adenosine → drowsy/less present
      if (chemical == ORX)   return  0.3;   // Orexin → physical wakefulness
      return 0.0;
    };

    return 0.0;
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // STATE TYPES — THE SHAPE OF THE EMOTIONAL FIELD
  // ═══════════════════════════════════════════════════════════════════════════════════════════

  // The continuous emotional field state
  public type EmotionalFieldState = {
    // The 8-dimensional gradient vector [-1, +1] per dimension
    gradients : [Float];          // φ₁ through φ₈

    // Field properties
    magnitude : Float;             // |Ψ| = √(Σ φᵢ²) — emotional intensity
    direction : [Float];           // Ψ̂ = Ψ/|Ψ| — emotional character (unit vector)

    // Derivative: how fast the field is changing (emotional velocity)
    fieldVelocity : [Float];       // dφᵢ/dt — rate of emotional change

    // Second derivative: emotional acceleration (mood shifts)
    fieldAcceleration : [Float];   // d²φᵢ/dt² — are we speeding up or slowing down?

    // Emotional memory — rolling average of recent field states
    memoryTrace : [Float];         // Low-pass filtered gradients (emotional baseline/mood)

    // Emotional resonance — does the current state reinforce or fight the baseline?
    resonance : Float;             // dot(gradients, memoryTrace) / |gradients||memoryTrace|

    // Feedback signals — what the emotional field wants to DO to the neurochemistry
    feedbackSignals : [Float];     // 21 values: positive = synthesize more, negative = less

    // Behavioral bias signals — how emotions influence behavior selection
    behavioralBias : BehavioralBias;

    // Beat tracking
    beatNum : Nat;
    totalUpdates : Nat;

    // Peak emotional intensity ever reached
    peakMagnitude : Float;

    // Emotional stability (inverse of variance over time)
    stability : Float;

    // Emotional complexity (how many dimensions are simultaneously active)
    complexity : Float;
  };

  // How the emotional field biases behavior
  public type BehavioralBias = {
    // Direct behavioral modulation
    rewardPrediction : Float;       // Valence → reward bias [-1, +1]
    responseSpeed : Float;          // Arousal → faster/slower responses [0.5, 2.0]
    territoryDrive : Float;         // Dominance → expand/contract territory [-1, +1]
    swarmCohesion : Float;          // Social → stick together or scatter [-1, +1]
    explorationDrive : Float;       // Approach + Temporal → explore or exploit [-1, +1]
    riskTolerance : Float;          // Certainty + Dominance → accept or avoid risk [0, 1]
    communicationDrive : Float;     // Social + Embodiment → communicate or stay silent [-1, +1]
    memoryConsolidation : Float;    // Emotional magnitude → how strongly to encode memories [0, 2]
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x;
  };

  func _abs(x : Float) : Float {
    if (x < 0.0) -x else x;
  };

  func _tanh(x : Float) : Float {
    // tanh(x) = (e^2x - 1) / (e^2x + 1)
    if (x > 10.0) return 1.0;
    if (x < -10.0) return -1.0;
    let e2x = Float.exp(2.0 * x);
    (e2x - 1.0) / (e2x + 1.0);
  };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    Float.sqrt(x);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════

  public func initEmotionalField() : EmotionalFieldState {
    let zeros = Array.tabulate<Float>(NUM_DIMENSIONS, func(_ : Nat) : Float { 0.0 });
    let feedbackZeros = Array.tabulate<Float>(NUM_CHEMICALS, func(_ : Nat) : Float { 0.0 });

    {
      gradients = zeros;
      magnitude = 0.0;
      direction = zeros;
      fieldVelocity = zeros;
      fieldAcceleration = zeros;
      memoryTrace = zeros;
      resonance = 0.0;
      feedbackSignals = feedbackZeros;
      behavioralBias = {
        rewardPrediction = 0.0;
        responseSpeed = 1.0;
        territoryDrive = 0.0;
        swarmCohesion = 0.5;
        explorationDrive = 0.0;
        riskTolerance = 0.5;
        communicationDrive = 0.0;
        memoryConsolidation = 1.0;
      };
      beatNum = 0;
      totalUpdates = 0;
      peakMagnitude = 0.0;
      stability = 1.0;
      complexity = 0.0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // CORE TICK — COMPUTE THE UNIFIED EMOTIONAL FIELD
  // This is the main function called every beat from main.mo
  // ═══════════════════════════════════════════════════════════════════════════════════════════

  public func tickEmotionalField(
    state : EmotionalFieldState,
    chemicals : [Float],            // All 21 neurochemical concentrations
    currentBeat : Nat
  ) : EmotionalFieldState {

    // ─── STEP 1: Compute raw field gradients from neurochemistry ──────────────────
    // φᵢ = tanh(Σⱼ wᵢⱼ · (Cⱼ - C₀ⱼ))
    let rawGradients = Array.tabulate<Float>(NUM_DIMENSIONS, func(i : Nat) : Float {
      var sum : Float = 0.0;
      var j = 0;
      while (j < NUM_CHEMICALS) {
        let concentration = if (j < chemicals.size()) { chemicals[j] } else { S0 };
        let deviation = concentration - S0;   // How far from baseline
        let weight = getWeight(i, j);
        sum += weight * deviation;
        j += 1;
      };
      _tanh(sum);   // Bound to [-1, +1]
    });

    // ─── STEP 2: Apply emotional momentum (emotions have inertia) ─────────────────
    // New gradient = momentum × old + (1-momentum) × raw
    // This prevents emotional whiplash — the organism doesn't snap between emotions
    let smoothGradients = Array.tabulate<Float>(NUM_DIMENSIONS, func(i : Nat) : Float {
      let old = if (i < state.gradients.size()) { state.gradients[i] } else { 0.0 };
      let raw = rawGradients[i];
      _clamp(EMOTIONAL_MOMENTUM * old + (1.0 - EMOTIONAL_MOMENTUM) * raw, -1.0, 1.0);
    });

    // ─── STEP 3: Compute field velocity (rate of emotional change) ────────────────
    let newVelocity = Array.tabulate<Float>(NUM_DIMENSIONS, func(i : Nat) : Float {
      let current = smoothGradients[i];
      let previous = if (i < state.gradients.size()) { state.gradients[i] } else { 0.0 };
      current - previous;
    });

    // ─── STEP 4: Compute field acceleration (emotional acceleration) ──────────────
    let newAcceleration = Array.tabulate<Float>(NUM_DIMENSIONS, func(i : Nat) : Float {
      let currentVel = newVelocity[i];
      let previousVel = if (i < state.fieldVelocity.size()) { state.fieldVelocity[i] } else { 0.0 };
      currentVel - previousVel;
    });

    // ─── STEP 5: Compute field magnitude (emotional intensity) ────────────────────
    var sumSquares : Float = 0.0;
    var dimIdx = 0;
    while (dimIdx < NUM_DIMENSIONS) {
      sumSquares += smoothGradients[dimIdx] * smoothGradients[dimIdx];
      dimIdx += 1;
    };
    let newMagnitude = _sqrt(sumSquares);

    // ─── STEP 6: Compute field direction (normalized emotional character) ─────────
    let newDirection = Array.tabulate<Float>(NUM_DIMENSIONS, func(i : Nat) : Float {
      if (newMagnitude > 0.001) { smoothGradients[i] / newMagnitude } else { 0.0 };
    });

    // ─── STEP 7: Update emotional memory trace (long-term mood baseline) ──────────
    let newMemory = Array.tabulate<Float>(NUM_DIMENSIONS, func(i : Nat) : Float {
      let oldMem = if (i < state.memoryTrace.size()) { state.memoryTrace[i] } else { 0.0 };
      EMOTIONAL_DECAY * oldMem + (1.0 - EMOTIONAL_DECAY) * smoothGradients[i];
    });

    // ─── STEP 8: Compute resonance (does current state match baseline mood?) ──────
    var dotProduct : Float = 0.0;
    var magCurrent : Float = 0.0;
    var magMemory : Float = 0.0;
    dimIdx := 0;
    while (dimIdx < NUM_DIMENSIONS) {
      dotProduct += smoothGradients[dimIdx] * newMemory[dimIdx];
      magCurrent += smoothGradients[dimIdx] * smoothGradients[dimIdx];
      magMemory += newMemory[dimIdx] * newMemory[dimIdx];
      dimIdx += 1;
    };
    let magProduct = _sqrt(magCurrent) * _sqrt(magMemory);
    let newResonance = if (magProduct > 0.001) { dotProduct / magProduct } else { 0.0 };

    // ─── STEP 9: Compute feedback signals to neurochemistry ───────────────────────
    // The emotional field influences neurochemical production
    // This creates the CLOSED LOOP: chemicals → emotions → chemicals
    let newFeedback = Array.tabulate<Float>(NUM_CHEMICALS, func(j : Nat) : Float {
      var signal : Float = 0.0;
      var i = 0;
      while (i < NUM_DIMENSIONS) {
        // If a gradient is strongly positive and a chemical positively drives it,
        // that chemical gets a positive feedback (produce more)
        // If the gradient is strongly negative, chemicals that drive it positive
        // get negative feedback (produce less)
        let weight = getWeight(i, j);
        signal += smoothGradients[i] * weight * FIELD_COUPLING;
        i += 1;
      };
      _clamp(signal, -0.5, 0.5);
    });

    // ─── STEP 10: Compute behavioral biases ───────────────────────────────────────
    let valence = smoothGradients[VALENCE];
    let arousal = smoothGradients[AROUSAL];
    let dominance = smoothGradients[DOMINANCE];
    let approach = smoothGradients[APPROACH];
    let social = smoothGradients[SOCIAL];
    let temporal = smoothGradients[TEMPORAL];
    let certainty = smoothGradients[CERTAINTY];
    let embodiment = smoothGradients[EMBODIMENT];

    let newBehavioralBias : BehavioralBias = {
      // Reward prediction: mainly from valence
      rewardPrediction = _clamp(valence * 0.7 + approach * 0.3, -1.0, 1.0);

      // Response speed: mainly from arousal (high arousal = fast responses)
      responseSpeed = _clamp(1.0 + arousal * 0.5, 0.5, 2.0);

      // Territory drive: dominance drives territorial behavior
      territoryDrive = _clamp(dominance * 0.6 + approach * 0.2 + arousal * 0.2, -1.0, 1.0);

      // Swarm cohesion: social dimension drives sticking together
      swarmCohesion = _clamp(0.5 + social * 0.4 + valence * 0.1, 0.0, 1.0);

      // Exploration: approach + future focus = explore; withdrawal + past = exploit known
      explorationDrive = _clamp(approach * 0.4 + temporal * 0.3 + valence * 0.2 + arousal * 0.1, -1.0, 1.0);

      // Risk tolerance: certainty + dominance = willing to take risks
      riskTolerance = _clamp(0.5 + certainty * 0.25 + dominance * 0.15 + valence * 0.1, 0.0, 1.0);

      // Communication drive: social need + embodiment (present enough to communicate)
      communicationDrive = _clamp(social * 0.5 + embodiment * 0.3 + valence * 0.2, -1.0, 1.0);

      // Memory consolidation: emotional intensity strengthens memory encoding
      // This is why we remember emotional events better — it's biological
      memoryConsolidation = _clamp(1.0 + newMagnitude * 0.8 + _abs(arousal) * 0.2, 0.5, 3.0);
    };

    // ─── STEP 11: Compute emotional complexity ────────────────────────────────────
    // How many dimensions are simultaneously active? (entropy-like measure)
    var activeCount : Float = 0.0;
    dimIdx := 0;
    while (dimIdx < NUM_DIMENSIONS) {
      if (_abs(smoothGradients[dimIdx]) > 0.15) {
        activeCount += 1.0;
      };
      dimIdx += 1;
    };
    let newComplexity = activeCount / 8.0;  // [0, 1] — 1 = all dimensions active

    // ─── STEP 12: Update stability (inverse of recent variance) ───────────────────
    var velocityMag : Float = 0.0;
    dimIdx := 0;
    while (dimIdx < NUM_DIMENSIONS) {
      velocityMag += newVelocity[dimIdx] * newVelocity[dimIdx];
      dimIdx += 1;
    };
    let velocityNorm = _sqrt(velocityMag);
    let newStability = _clamp(state.stability * 0.98 + (1.0 - velocityNorm) * 0.02, 0.0, 1.0);

    // ─── STEP 13: Track peak magnitude ────────────────────────────────────────────
    let newPeak = if (newMagnitude > state.peakMagnitude) { newMagnitude } else {
      state.peakMagnitude * 0.9999;  // Very slow decay of peak memory
    };

    // ─── RETURN UPDATED STATE ─────────────────────────────────────────────────────
    {
      gradients = smoothGradients;
      magnitude = newMagnitude;
      direction = newDirection;
      fieldVelocity = newVelocity;
      fieldAcceleration = newAcceleration;
      memoryTrace = newMemory;
      resonance = newResonance;
      feedbackSignals = newFeedback;
      behavioralBias = newBehavioralBias;
      beatNum = currentBeat;
      totalUpdates = state.totalUpdates + 1;
      peakMagnitude = newPeak;
      stability = newStability;
      complexity = newComplexity;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // FIELD INTERPRETATION — EMERGENT EMOTIONAL REGIONS
  // These are NOT hard categories. They are soft regions of the continuous field.
  // The organism can be in BETWEEN any of these — that's the whole point.
  // ═══════════════════════════════════════════════════════════════════════════════════════════

  // Returns how strongly the current field state resembles each classical emotion
  // Output: array of 8 scores [0, 1] for [fear, joy, anger, sadness, trust, surprise, disgust, anticipation]
  public func getEmotionalLandscape(state : EmotionalFieldState) : [Float] {
    let v = if (VALENCE < state.gradients.size()) { state.gradients[VALENCE] } else { 0.0 };
    let a = if (AROUSAL < state.gradients.size()) { state.gradients[AROUSAL] } else { 0.0 };
    let d = if (DOMINANCE < state.gradients.size()) { state.gradients[DOMINANCE] } else { 0.0 };
    let ap = if (APPROACH < state.gradients.size()) { state.gradients[APPROACH] } else { 0.0 };
    let s = if (SOCIAL < state.gradients.size()) { state.gradients[SOCIAL] } else { 0.0 };
    let _t = if (TEMPORAL < state.gradients.size()) { state.gradients[TEMPORAL] } else { 0.0 };
    let c = if (CERTAINTY < state.gradients.size()) { state.gradients[CERTAINTY] } else { 0.0 };
    let e = if (EMBODIMENT < state.gradients.size()) { state.gradients[EMBODIMENT] } else { 0.0 };

    [
      // FEAR: low valence, high arousal, low dominance, withdrawal
      _clamp((-v * 0.3 + a * 0.3 + (-d) * 0.2 + (-ap) * 0.2) * 2.0, 0.0, 1.0),

      // JOY: high valence, moderate-high arousal, approach
      _clamp((v * 0.4 + a * 0.2 + ap * 0.2 + s * 0.1 + c * 0.1) * 2.0, 0.0, 1.0),

      // ANGER: low valence, high arousal, high dominance, approach (fight!)
      _clamp(((-v) * 0.25 + a * 0.25 + d * 0.25 + ap * 0.15 + e * 0.1) * 2.0, 0.0, 1.0),

      // SADNESS: low valence, low arousal, low dominance, withdrawal
      _clamp(((-v) * 0.3 + (-a) * 0.3 + (-d) * 0.2 + (-ap) * 0.2) * 2.0, 0.0, 1.0),

      // TRUST: high valence, low arousal, high social, approach
      _clamp((v * 0.25 + (-a) * 0.15 + s * 0.3 + ap * 0.2 + c * 0.1) * 2.0, 0.0, 1.0),

      // SURPRISE: any valence (abs), high arousal, low certainty
      _clamp((_abs(v) * 0.1 + a * 0.3 + (-c) * 0.4 + e * 0.2) * 2.0, 0.0, 1.0),

      // DISGUST: low valence, medium arousal, withdrawal, high embodiment
      _clamp(((-v) * 0.3 + _abs(a) * 0.1 + (-ap) * 0.3 + e * 0.3) * 2.0, 0.0, 1.0),

      // ANTICIPATION: high arousal, future-focused, approach, certainty
      _clamp((a * 0.2 + _t * 0.3 + ap * 0.2 + c * 0.2 + d * 0.1) * 2.0, 0.0, 1.0)
    ];
  };

  // Get the dominant emotional region name (for diagnostics only — the field is continuous!)
  public func getDominantEmotion(state : EmotionalFieldState) : Text {
    let landscape = getEmotionalLandscape(state);
    var maxVal : Float = 0.0;
    var maxIdx : Nat = 0;
    var i = 0;
    while (i < landscape.size()) {
      if (landscape[i] > maxVal) {
        maxVal := landscape[i];
        maxIdx := i;
      };
      i += 1;
    };
    if (maxVal < 0.1) return "neutral";
    switch (maxIdx) {
      case 0 { "fear" };
      case 1 { "joy" };
      case 2 { "anger" };
      case 3 { "sadness" };
      case 4 { "trust" };
      case 5 { "surprise" };
      case 6 { "disgust" };
      case 7 { "anticipation" };
      case _ { "complex" };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // EMOTIONAL FIELD DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════

  public type EmotionalDiagnostics = {
    // Current field state summary
    valence : Float;
    arousal : Float;
    dominance : Float;
    approach : Float;
    social : Float;
    temporal : Float;
    certainty : Float;
    embodiment : Float;

    // Derived metrics
    intensity : Float;         // |Ψ|
    stability : Float;         // How stable the emotional state is
    complexity : Float;        // How many dimensions active
    resonance : Float;         // Does current match baseline mood?

    // Emergent emotion landscape
    fearScore : Float;
    joyScore : Float;
    angerScore : Float;
    sadnessScore : Float;
    trustScore : Float;
    surpriseScore : Float;
    disgustScore : Float;
    anticipationScore : Float;

    // Dominant state
    dominantEmotion : Text;
  };

  public func diagnose(state : EmotionalFieldState) : EmotionalDiagnostics {
    let landscape = getEmotionalLandscape(state);
    {
      valence = if (VALENCE < state.gradients.size()) { state.gradients[VALENCE] } else { 0.0 };
      arousal = if (AROUSAL < state.gradients.size()) { state.gradients[AROUSAL] } else { 0.0 };
      dominance = if (DOMINANCE < state.gradients.size()) { state.gradients[DOMINANCE] } else { 0.0 };
      approach = if (APPROACH < state.gradients.size()) { state.gradients[APPROACH] } else { 0.0 };
      social = if (SOCIAL < state.gradients.size()) { state.gradients[SOCIAL] } else { 0.0 };
      temporal = if (TEMPORAL < state.gradients.size()) { state.gradients[TEMPORAL] } else { 0.0 };
      certainty = if (CERTAINTY < state.gradients.size()) { state.gradients[CERTAINTY] } else { 0.0 };
      embodiment = if (EMBODIMENT < state.gradients.size()) { state.gradients[EMBODIMENT] } else { 0.0 };

      intensity = state.magnitude;
      stability = state.stability;
      complexity = state.complexity;
      resonance = state.resonance;

      fearScore = if (0 < landscape.size()) { landscape[0] } else { 0.0 };
      joyScore = if (1 < landscape.size()) { landscape[1] } else { 0.0 };
      angerScore = if (2 < landscape.size()) { landscape[2] } else { 0.0 };
      sadnessScore = if (3 < landscape.size()) { landscape[3] } else { 0.0 };
      trustScore = if (4 < landscape.size()) { landscape[4] } else { 0.0 };
      surpriseScore = if (5 < landscape.size()) { landscape[5] } else { 0.0 };
      disgustScore = if (6 < landscape.size()) { landscape[6] } else { 0.0 };
      anticipationScore = if (7 < landscape.size()) { landscape[7] } else { 0.0 };

      dominantEmotion = getDominantEmotion(state);
    };
  };
};
