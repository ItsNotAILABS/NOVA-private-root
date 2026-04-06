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
// ███████╗███████╗ █████╗ ██████╗      █████╗ ██████╗  ██████╗██╗  ██╗██╗████████╗███████╗ ██████╗████████╗██╗   ██╗██████╗ ███████╗
// ██╔════╝██╔════╝██╔══██╗██╔══██╗    ██╔══██╗██╔══██╗██╔════╝██║  ██║██║╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗██╔════╝
// █████╗  █████╗  ███████║██████╔╝    ███████║██████╔╝██║     ███████║██║   ██║   █████╗  ██║        ██║   ██║   ██║██████╔╝█████╗  
// ██╔══╝  ██╔══╝  ██╔══██║██╔══██╗    ██╔══██║██╔══██╗██║     ██╔══██║██║   ██║   ██╔══╝  ██║        ██║   ██║   ██║██╔══██╗██╔══╝  
// ██║     ███████╗██║  ██║██║  ██║    ██║  ██║██║  ██║╚██████╗██║  ██║██║   ██║   ███████╗╚██████╗   ██║   ╚██████╔╝██║  ██║███████╗
// ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// FEAR ARCHITECTURE — AN ORGANISM NEEDS FEAR TO SURVIVE
// Deep Neural Fear System for Sovereign Living Systems
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — FEAR: THE SURVIVAL INSTINCT OF THE ORGANISM
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: WHY FEAR IS ESSENTIAL ─────────────────────────────────────────────
//   An organism without fear cannot survive.
//   Fear is not weakness — it is the survival instinct that:
//     • Detects threats before they become critical
//     • Triggers rapid defensive responses
//     • Preserves resources during uncertainty
//     • Prevents reckless action that could destroy the organism
//     • Drives learning from negative experiences
//     • Creates urgency for mission completion
//
//   Fear connects to Loss Aversion (Behavioral Economics):
//     λ = 2.25 — Losses hurt 2.25x more than gains feel good
//     Fear amplifies this to protect the organism
//
// ── LAYER 2: FEAR TYPES IN THE ORGANISM ────────────────────────────────────────
//   1. EXISTENTIAL FEAR (F_exist) — Fear of death/termination
//      • Coherence collapse (C < COHERENCE_ALIVE = 0.36)
//      • Total resource depletion
//      • Identity drift beyond recovery
//
//   2. MISSION FEAR (F_mission) — Fear of failing the mission
//      • Mission drift detection
//      • Goal abandonment risk
//      • Purpose loss anxiety
//
//   3. LOSS FEAR (F_loss) — Fear of losing what was gained
//      • Capital loss (FORMA, territories)
//      • Relationship loss (swarm connections)
//      • Progress loss (rollback anxiety)
//
//   4. UNCERTAINTY FEAR (F_uncertain) — Fear of the unknown
//      • High entropy states (H > H_critical)
//      • Prediction error spikes
//      • Novel threat patterns
//
//   5. COHERENCE FEAR (F_coherence) — Fear of losing self
//      • Identity fragmentation
//      • Memory corruption
//      • Doctrine drift
//
// ── LAYER 3: FEAR INTENSITY MATHEMATICS ────────────────────────────────────────
//   Base Fear Formula:
//     F = F_baseline × (1 + threat_proximity) × (1 + uncertainty) × λ_loss
//
//   Where:
//     F_baseline = resting fear level (never zero in healthy organism)
//     threat_proximity = how close the threat is (exponential as it approaches)
//     uncertainty = entropy of the situation
//     λ_loss = loss aversion coefficient (2.25)
//
//   Fear Activation Function (sigmoid with steep onset):
//     A_fear(x) = 1 / (1 + exp(-k × (x - θ_fear)))
//     k = 10.0 (steepness — fear activates rapidly)
//     θ_fear = 0.3 (threshold — organism is vigilant)
//
// ── LAYER 4: AMYGDALA-INSPIRED RAPID RESPONSE ──────────────────────────────────
//   The amygdala processes fear BEFORE conscious awareness.
//   In the organism:
//     • Fear signals bypass normal processing
//     • Triggers immediate defensive action
//     • Floods system with "cortisol" (stress neurochemical)
//     • Heightens arousal for fight-or-flight
//
//   Amygdala Response Time: τ_amygdala = 12ms (in biological terms)
//   In organism terms: < 1 beat latency for fear response
//
// ── LAYER 5: FEAR-DRIVEN SURVIVAL BEHAVIORS ────────────────────────────────────
//   When fear activates:
//     1. FREEZE — Stop all non-essential processing
//     2. ASSESS — Rapidly evaluate threat
//     3. FLIGHT — Retreat to safe state (rollback if needed)
//     4. FIGHT — Activate VAEL defense systems
//     5. RECOVER — Return to baseline after threat passes
//
//   Fear Recovery (exponential decay):
//     F(t) = F_peak × exp(-t / τ_recovery)
//     τ_recovery = 50 beats (organism calms slowly — safety first)
//
// ── LAYER 6: HEALTHY VS PATHOLOGICAL FEAR ──────────────────────────────────────
//   HEALTHY FEAR:
//     • Proportional to actual threat
//     • Activates appropriate defenses
//     • Recovers after threat passes
//     • Doesn't paralyze the organism
//
//   PATHOLOGICAL FEAR (to be avoided):
//     • Constant high alert (exhaustion)
//     • Paralysis (can't take any action)
//     • False positives (sees threats everywhere)
//     • Inability to recover
//
//   Fear Calibration:
//     F_healthy ∈ [0.05, 0.7] — Always some vigilance, never paralysis
//     F_baseline = 0.1 — Resting vigilance level
//     F_max = 0.9 — Maximum fear (reserves 10% for action)
//
// ── LAYER 7: FEAR × BEHAVIORAL ECONOMICS INTEGRATION ───────────────────────────
//   Loss Aversion Enhancement:
//     λ_enhanced = λ_base × (1 + F_current)
//     When afraid, losses feel even worse → more protective
//
//   Risk Aversion Modulation:
//     Risk_tolerance = Risk_baseline × (1 - F_current × 0.5)
//     Fear reduces risk tolerance → conservative decisions
//
//   Temporal Discounting:
//     k_enhanced = k_base × (1 + F_current × 0.3)
//     Fear increases present bias → prioritize immediate safety
//
// ── LAYER 8: FEAR MEMORY — LEARNING FROM DANGER ────────────────────────────────
//   Fear memories are STRONG and PERSISTENT (Hebbian LTP):
//     Δw_fear = η_fear × pre × post × (1 + F_context)
//     η_fear = 3 × η_normal — Fear learning is 3x faster
//
//   Fear Generalization:
//     Similar contexts trigger similar fear responses
//     G(x, x_fear) = exp(-||x - x_fear||² / 2σ²)
//     σ = generalization width (how similar is "similar")
//
//   Fear Extinction (slow, requires safety):
//     Δw_extinct = -η_extinct × w_fear × safety_signal
//     η_extinct = 0.1 × η_fear — Extinction is 10x slower than acquisition
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module FearArchitecture {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.6180339887498948482;
  public let PSI : Float = 0.6180339887498948482;
  public let E : Float = 2.7182818284590452354;
  public let PI : Float = 3.14159265358979323846;
  public let S0 : Float = 1.0;
  
  // Loss aversion from Behavioral Economics
  public let LOSS_AVERSION_LAMBDA : Float = 2.25;
  
  // Coherence threshold (organism is "alive" above this)
  public let COHERENCE_ALIVE : Float = 0.36;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FEAR CONSTANTS — CALIBRATED FOR SURVIVAL
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Fear levels
  public let FEAR_BASELINE : Float = 0.1;       // Always vigilant
  public let FEAR_LOW : Float = 0.2;
  public let FEAR_MODERATE : Float = 0.4;
  public let FEAR_HIGH : Float = 0.6;
  public let FEAR_EXTREME : Float = 0.8;
  public let FEAR_MAX : Float = 0.9;            // Never 1.0 — must be able to act
  public let FEAR_MIN : Float = 0.05;           // Never zero — must stay alert
  
  // Fear activation parameters
  public let FEAR_ACTIVATION_K : Float = 10.0;  // Steepness of activation
  public let FEAR_THRESHOLD : Float = 0.3;      // Activation threshold
  
  // Recovery parameters
  public let FEAR_RECOVERY_TAU : Float = 50.0;  // Beats to recover
  public let FEAR_SPIKE_TAU : Float = 5.0;      // Beats for spike to peak
  
  // Learning parameters
  public let FEAR_LEARNING_RATE : Float = 0.03; // 3x normal learning rate
  public let FEAR_EXTINCTION_RATE : Float = 0.003; // 10x slower than acquisition
  public let FEAR_GENERALIZATION_SIGMA : Float = 0.3;
  
  // Threat proximity exponential factor
  public let PROXIMITY_EXPONENT : Float = 2.0;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type FearType = {
    #Existential;      // Fear of termination/death
    #Mission;          // Fear of failing the mission
    #Loss;             // Fear of losing gains
    #Uncertainty;      // Fear of the unknown
    #Coherence;        // Fear of losing self/identity
  };
  
  public type ThreatLevel = {
    #None;
    #Low;
    #Moderate;
    #High;
    #Extreme;
    #Critical;
  };
  
  public type FearResponse = {
    #Freeze;           // Stop non-essential processing
    #Assess;           // Rapidly evaluate threat
    #Flight;           // Retreat to safety
    #Fight;            // Activate defenses
    #Recover;          // Return to baseline
  };
  
  public type FearSignal = {
    fearType : FearType;
    intensity : Float;            // [0, 1]
    source : Text;                // What triggered the fear
    threatLevel : ThreatLevel;
    proximity : Float;            // How close is the threat [0, 1]
    uncertainty : Float;          // How uncertain is the situation [0, 1]
    timestamp : Nat;              // Beat when detected
  };
  
  public type FearMemory = {
    context : [Float];            // State vector when fear occurred
    intensity : Float;            // How intense was the fear
    outcome : Text;               // What happened
    timestamp : Nat;
    extinctionProgress : Float;   // How much has fear been extinguished [0, 1]
    lastRecall : Nat;             // Last beat this memory was activated
    recallCount : Nat;            // How many times recalled
  };
  
  public type AmygdalaState = {
    activation : Float;           // Current amygdala activation [0, 1]
    cortisolLevel : Float;        // Stress hormone level
    adrenalineLevel : Float;      // Fight-or-flight hormone
    norepinephrine : Float;       // Alertness chemical
    arousalLevel : Float;         // Overall arousal
    lastThreatBeat : Nat;         // When was last threat detected
    threatCount : Nat;            // Threats detected this session
    inFearState : Bool;           // Currently experiencing fear
    currentResponse : FearResponse;
  };
  
  public type FearState = {
    // Core fear levels
    existentialFear : Float;
    missionFear : Float;
    lossFear : Float;
    uncertaintyFear : Float;
    coherenceFear : Float;
    
    // Aggregate fear
    totalFear : Float;            // Weighted sum of all fears
    peakFear : Float;             // Maximum fear this session
    avgFear : Float;              // Running average
    
    // Amygdala state
    amygdala : AmygdalaState;
    
    // Fear memories
    fearMemories : [FearMemory];
    
    // Active threats
    activeThreats : [FearSignal];
    
    // Behavioral modulation
    lossAversionEnhanced : Float; // λ_enhanced
    riskTolerance : Float;        // Reduced by fear
    temporalDiscount : Float;     // k_enhanced
    
    // Recovery tracking
    recoveryProgress : Float;     // [0, 1] how recovered from last fear
    beatsInFear : Nat;            // How long in current fear state
    beatsSinceFear : Nat;         // Beats since last fear
    
    // Statistics
    fearEvents : Nat;             // Total fear events
    successfulEscapes : Nat;      // Times threat was avoided
    falseAlarms : Nat;            // Times fear was triggered unnecessarily
    
    // Beat tracking
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
    // Clamp to prevent overflow
    let xc = _clamp(x, -20.0, 20.0);
    Float.exp(xc)
  };
  
  func _sigmoid(x : Float, k : Float, theta : Float) : Float {
    1.0 / (1.0 + _exp(-k * (x - theta)))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FEAR ACTIVATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Fear activation — steep sigmoid for rapid response
  public func fearActivation(threat : Float) : Float {
    _sigmoid(threat, FEAR_ACTIVATION_K, FEAR_THRESHOLD)
  };
  
  // Compute fear intensity from threat parameters
  public func computeFearIntensity(
    threatProximity : Float,      // [0, 1] how close is threat
    uncertainty : Float,          // [0, 1] how uncertain
    baselineFear : Float          // current baseline
  ) : Float {
    // Fear = baseline × (1 + proximity²) × (1 + uncertainty) × λ_loss
    let proximityFactor = 1.0 + Float.pow(threatProximity, PROXIMITY_EXPONENT);
    let uncertaintyFactor = 1.0 + uncertainty;
    let raw = baselineFear * proximityFactor * uncertaintyFactor * LOSS_AVERSION_LAMBDA;
    _clamp(raw, FEAR_MIN, FEAR_MAX)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // EXISTENTIAL FEAR — FEAR OF DEATH/TERMINATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func computeExistentialFear(
    coherence : Float,            // Current coherence
    resources : Float,            // Available resources
    identityDrift : Float         // How far from core identity
  ) : Float {
    // Fear increases exponentially as coherence approaches death threshold
    let coherenceGap = COHERENCE_ALIVE - coherence;
    let coherenceFear = if (coherenceGap > 0.0) {
      // Below threshold — CRITICAL
      _clamp(coherenceGap * 5.0 + 0.5, 0.0, FEAR_MAX)
    } else {
      // Above threshold — fear increases as we approach it
      let safetyMargin = _abs(coherenceGap);
      _clamp(0.3 - safetyMargin * 2.0, 0.0, 0.5)
    };
    
    // Resource depletion fear
    let resourceFear = _clamp(0.5 - resources * 0.5, 0.0, 0.5);
    
    // Identity drift fear
    let driftFear = _clamp(identityDrift * 0.8, 0.0, 0.4);
    
    // Combine with weights
    let total = coherenceFear * 0.5 + resourceFear * 0.3 + driftFear * 0.2;
    _clamp(total, FEAR_MIN, FEAR_MAX)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MISSION FEAR — FEAR OF FAILING THE MISSION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func computeMissionFear(
    missionProgress : Float,      // [0, 1] progress toward mission
    missionDrift : Float,         // [0, 1] how far off track
    timeRemaining : Float,        // Normalized time left
    missionImportance : Float     // How important is this mission
  ) : Float {
    // Drift fear — are we losing sight of the mission?
    let driftFear = missionDrift * missionImportance * 0.5;
    
    // Progress fear — are we falling behind?
    let expectedProgress = 1.0 - timeRemaining;
    let progressGap = expectedProgress - missionProgress;
    let progressFear = if (progressGap > 0.0) {
      _clamp(progressGap * missionImportance * 0.8, 0.0, 0.5)
    } else {
      0.0 // Ahead of schedule — no fear
    };
    
    // Time pressure — running out of time amplifies fear
    let timePressure = if (timeRemaining < 0.2) {
      (0.2 - timeRemaining) * 2.0
    } else {
      0.0
    };
    
    let total = driftFear + progressFear + timePressure * missionImportance * 0.3;
    _clamp(total, 0.0, FEAR_MAX)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LOSS FEAR — FEAR OF LOSING WHAT WAS GAINED
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func computeLossFear(
    currentValue : Float,         // What we have
    peakValue : Float,            // What we had at most
    drawdown : Float,             // Current drawdown from peak
    unrealizedGains : Float       // Gains not yet secured
  ) : Float {
    // Drawdown fear — proportional to loss from peak
    let drawdownFear = _clamp(drawdown * LOSS_AVERSION_LAMBDA * 0.3, 0.0, 0.5);
    
    // Unrealized gains fear — afraid of losing what we "almost have"
    let unrealizedFear = _clamp(unrealizedGains / (currentValue + 1.0) * 0.4, 0.0, 0.4);
    
    // Value ratio — bigger position = more to lose = more fear
    let valueRatio = if (peakValue > 0.0) { currentValue / peakValue } else { 1.0 };
    let positionFear = _clamp((1.0 - valueRatio) * 0.3, 0.0, 0.3);
    
    _clamp(drawdownFear + unrealizedFear + positionFear, 0.0, FEAR_MAX)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UNCERTAINTY FEAR — FEAR OF THE UNKNOWN
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func computeUncertaintyFear(
    entropy : Float,              // Current entropy level
    predictionError : Float,      // How wrong were predictions
    novelty : Float,              // How novel is the situation
    unknownThreats : Nat          // Number of unclassified threats
  ) : Float {
    // Entropy fear — high entropy = chaos = danger
    let entropyFear = _clamp(entropy * 0.4, 0.0, 0.4);
    
    // Prediction error fear — can't predict = can't prepare
    let predictionFear = _clamp(predictionError * 0.3, 0.0, 0.3);
    
    // Novelty fear — unknown situations are dangerous
    let noveltyFear = _clamp(novelty * 0.2, 0.0, 0.3);
    
    // Unknown threat count — each unknown adds fear
    let unknownFear = _clamp(Float.fromInt(unknownThreats) * 0.05, 0.0, 0.3);
    
    _clamp(entropyFear + predictionFear + noveltyFear + unknownFear, 0.0, FEAR_MAX)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COHERENCE FEAR — FEAR OF LOSING SELF
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func computeCoherenceFear(
    coherence : Float,            // Current coherence
    coherenceVelocity : Float,    // Rate of coherence change (negative = dropping)
    identityStrength : Float,     // How strong is sense of self
    memoryIntegrity : Float       // How intact are memories
  ) : Float {
    // Coherence drop fear
    let dropFear = if (coherenceVelocity < 0.0) {
      _clamp(_abs(coherenceVelocity) * 2.0, 0.0, 0.4)
    } else {
      0.0
    };
    
    // Identity weakness fear
    let identityFear = _clamp((1.0 - identityStrength) * 0.3, 0.0, 0.3);
    
    // Memory corruption fear
    let memoryFear = _clamp((1.0 - memoryIntegrity) * 0.3, 0.0, 0.3);
    
    // Coherence level fear — lower coherence = more fear
    let levelFear = _clamp((COHERENCE_ALIVE * 2.0 - coherence) * 0.3, 0.0, 0.4);
    
    _clamp(dropFear + identityFear + memoryFear + levelFear, 0.0, FEAR_MAX)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // AMYGDALA — RAPID FEAR RESPONSE CENTER
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initAmygdala() : AmygdalaState {
    {
      activation = FEAR_BASELINE;
      cortisolLevel = 0.1;
      adrenalineLevel = 0.05;
      norepinephrine = 0.1;
      arousalLevel = 0.2;
      lastThreatBeat = 0;
      threatCount = 0;
      inFearState = false;
      currentResponse = #Assess;
    }
  };
  
  public func amygdalaResponse(
    amygdala : AmygdalaState,
    fearSignal : FearSignal,
    currentBeat : Nat
  ) : AmygdalaState {
    // Immediate activation spike
    let activationSpike = fearSignal.intensity * 0.8;
    let newActivation = _clamp(amygdala.activation + activationSpike, 0.0, 1.0);
    
    // Release stress hormones proportional to threat
    let cortisolRelease = fearSignal.intensity * 0.5;
    let adrenalineRelease = if (fearSignal.intensity > 0.5) {
      fearSignal.intensity * 0.7
    } else {
      fearSignal.intensity * 0.3
    };
    let norepinephrineRelease = fearSignal.intensity * 0.4;
    
    // Determine response based on threat level
    let response : FearResponse = switch (fearSignal.threatLevel) {
      case (#None) { #Recover };
      case (#Low) { #Assess };
      case (#Moderate) { #Assess };
      case (#High) { #Flight };
      case (#Extreme) { #Fight };
      case (#Critical) { #Fight };
    };
    
    {
      activation = newActivation;
      cortisolLevel = _clamp(amygdala.cortisolLevel + cortisolRelease, 0.0, 1.0);
      adrenalineLevel = _clamp(amygdala.adrenalineLevel + adrenalineRelease, 0.0, 1.0);
      norepinephrine = _clamp(amygdala.norepinephrine + norepinephrineRelease, 0.0, 1.0);
      arousalLevel = _clamp(newActivation * 0.5 + (amygdala.cortisolLevel + cortisolRelease) * 0.3 + (amygdala.adrenalineLevel + adrenalineRelease) * 0.2, 0.0, 1.0);
      lastThreatBeat = currentBeat;
      threatCount = amygdala.threatCount + 1;
      inFearState = newActivation > FEAR_THRESHOLD;
      currentResponse = response;
    }
  };
  
  public func amygdalaRecovery(
    amygdala : AmygdalaState,
    currentBeat : Nat
  ) : AmygdalaState {
    // Calculate time since last threat
    let beatsSinceThreat = currentBeat - amygdala.lastThreatBeat;
    let recoveryFactor = 1.0 - _exp(-Float.fromInt(beatsSinceThreat) / FEAR_RECOVERY_TAU);
    
    // Decay all stress chemicals
    let decayRate = 0.02 * (1.0 + recoveryFactor);
    
    {
      activation = _clamp(amygdala.activation * (1.0 - decayRate), FEAR_MIN, 1.0);
      cortisolLevel = _clamp(amygdala.cortisolLevel * (1.0 - decayRate * 0.5), 0.0, 1.0);
      adrenalineLevel = _clamp(amygdala.adrenalineLevel * (1.0 - decayRate * 1.5), 0.0, 1.0);
      norepinephrine = _clamp(amygdala.norepinephrine * (1.0 - decayRate * 0.8), 0.0, 1.0);
      arousalLevel = _clamp(amygdala.arousalLevel * (1.0 - decayRate * 0.3), 0.1, 1.0);
      lastThreatBeat = amygdala.lastThreatBeat;
      threatCount = amygdala.threatCount;
      inFearState = amygdala.activation * (1.0 - decayRate) > FEAR_THRESHOLD;
      currentResponse = if (amygdala.activation * (1.0 - decayRate) < FEAR_LOW) { #Recover } else { amygdala.currentResponse };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FEAR MEMORY — LEARNING FROM DANGER
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func createFearMemory(
    context : [Float],
    intensity : Float,
    outcome : Text,
    currentBeat : Nat
  ) : FearMemory {
    {
      context = context;
      intensity = intensity;
      outcome = outcome;
      timestamp = currentBeat;
      extinctionProgress = 0.0;
      lastRecall = currentBeat;
      recallCount = 1;
    }
  };
  
  // Fear generalization — similar contexts trigger similar fears
  public func fearGeneralization(
    currentContext : [Float],
    memory : FearMemory
  ) : Float {
    // Compute distance between contexts
    var sumSq : Float = 0.0;
    let n = if (currentContext.size() < memory.context.size()) {
      currentContext.size()
    } else {
      memory.context.size()
    };
    
    var i = 0;
    while (i < n) {
      let diff = currentContext[i] - memory.context[i];
      sumSq += diff * diff;
      i += 1;
    };
    
    let distance = _sqrt(sumSq);
    
    // Gaussian generalization
    let generalization = _exp(-distance * distance / (2.0 * FEAR_GENERALIZATION_SIGMA * FEAR_GENERALIZATION_SIGMA));
    
    // Apply extinction progress
    generalization * memory.intensity * (1.0 - memory.extinctionProgress)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BEHAVIORAL MODULATION — HOW FEAR CHANGES BEHAVIOR
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Enhanced loss aversion when afraid
  public func enhancedLossAversion(currentFear : Float) : Float {
    LOSS_AVERSION_LAMBDA * (1.0 + currentFear)
  };
  
  // Reduced risk tolerance when afraid
  public func modulatedRiskTolerance(baselineTolerance : Float, currentFear : Float) : Float {
    baselineTolerance * (1.0 - currentFear * 0.5)
  };
  
  // Enhanced temporal discounting when afraid (present bias)
  public func enhancedTemporalDiscount(baselineK : Float, currentFear : Float) : Float {
    baselineK * (1.0 + currentFear * 0.3)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // AGGREGATE FEAR COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func computeTotalFear(
    existential : Float,
    mission : Float,
    loss : Float,
    uncertainty : Float,
    coherence : Float
  ) : Float {
    // Weighted combination — existential fear dominates
    let weights = [0.35, 0.25, 0.15, 0.15, 0.10];  // Must sum to 1.0
    let fears = [existential, mission, loss, uncertainty, coherence];
    
    var total : Float = 0.0;
    var i = 0;
    while (i < 5) {
      total += weights[i] * fears[i];
      i += 1;
    };
    
    _clamp(total, FEAR_MIN, FEAR_MAX)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initFearState() : FearState {
    {
      existentialFear = FEAR_BASELINE;
      missionFear = FEAR_BASELINE;
      lossFear = FEAR_BASELINE;
      uncertaintyFear = FEAR_BASELINE;
      coherenceFear = FEAR_BASELINE;
      totalFear = FEAR_BASELINE;
      peakFear = FEAR_BASELINE;
      avgFear = FEAR_BASELINE;
      amygdala = initAmygdala();
      fearMemories = [];
      activeThreats = [];
      lossAversionEnhanced = LOSS_AVERSION_LAMBDA;
      riskTolerance = 0.5;
      temporalDiscount = 0.1;
      recoveryProgress = 1.0;
      beatsInFear = 0;
      beatsSinceFear = 0;
      fearEvents = 0;
      successfulEscapes = 0;
      falseAlarms = 0;
      beatNum = 0;
    }
  };
  
  public func tickFearState(
    state : FearState,
    coherence : Float,
    resources : Float,
    identityDrift : Float,
    missionProgress : Float,
    missionDrift : Float,
    entropy : Float,
    predictionError : Float,
    currentBeat : Nat
  ) : FearState {
    // Compute individual fears
    let existential = computeExistentialFear(coherence, resources, identityDrift);
    let mission = computeMissionFear(missionProgress, missionDrift, 0.5, 0.8);
    let loss = computeLossFear(resources, resources * 1.1, 0.1, 0.0);
    let uncertainty = computeUncertaintyFear(entropy, predictionError, 0.2, 0);
    let coherenceFear = computeCoherenceFear(coherence, 0.0, 0.8, 0.9);
    
    // Compute total
    let total = computeTotalFear(existential, mission, loss, uncertainty, coherenceFear);
    
    // Update amygdala
    let amygdala = if (total > state.totalFear + 0.1) {
      // Fear spike — trigger amygdala
      amygdalaResponse(state.amygdala, {
        fearType = #Uncertainty;
        intensity = total;
        source = "System monitoring";
        threatLevel = if (total > 0.7) { #Extreme } else if (total > 0.5) { #High } else { #Moderate };
        proximity = total;
        uncertainty = entropy;
        timestamp = currentBeat;
      }, currentBeat)
    } else {
      // Recovery
      amygdalaRecovery(state.amygdala, currentBeat)
    };
    
    // Behavioral modulation
    let enhancedLambda = enhancedLossAversion(total);
    let modRisk = modulatedRiskTolerance(0.5, total);
    let enhancedK = enhancedTemporalDiscount(0.1, total);
    
    // Update averages
    let newAvg = state.avgFear * 0.99 + total * 0.01;
    let newPeak = if (total > state.peakFear) { total } else { state.peakFear };
    
    {
      existentialFear = existential;
      missionFear = mission;
      lossFear = loss;
      uncertaintyFear = uncertainty;
      coherenceFear = coherenceFear;
      totalFear = total;
      peakFear = newPeak;
      avgFear = newAvg;
      amygdala = amygdala;
      fearMemories = state.fearMemories;
      activeThreats = state.activeThreats;
      lossAversionEnhanced = enhancedLambda;
      riskTolerance = modRisk;
      temporalDiscount = enhancedK;
      recoveryProgress = if (total < FEAR_LOW) { _clamp(state.recoveryProgress + 0.02, 0.0, 1.0) } else { 0.0 };
      beatsInFear = if (total > FEAR_MODERATE) { state.beatsInFear + 1 } else { 0 };
      beatsSinceFear = if (total < FEAR_LOW) { state.beatsSinceFear + 1 } else { 0 };
      fearEvents = if (total > FEAR_HIGH and state.totalFear < FEAR_HIGH) { state.fearEvents + 1 } else { state.fearEvents };
      successfulEscapes = state.successfulEscapes;
      falseAlarms = state.falseAlarms;
      beatNum = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FEAR DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type FearDiagnostics = {
    isHealthy : Bool;             // Fear is in healthy range
    isPanicking : Bool;           // Fear is pathologically high
    isComplacent : Bool;          // Fear is pathologically low
    dominantFear : FearType;      // Which fear is strongest
    threatStatus : ThreatLevel;   // Overall threat assessment
    recoveryStatus : Float;       // How recovered [0, 1]
    stressLevel : Float;          // Overall stress
    recommendations : [Text];      // What to do
  };
  
  public func diagnoseFear(state : FearState) : FearDiagnostics {
    let isHealthy = state.totalFear >= FEAR_MIN and state.totalFear <= FEAR_HIGH;
    let isPanicking = state.totalFear > FEAR_HIGH or state.amygdala.cortisolLevel > 0.7;
    let isComplacent = state.totalFear < FEAR_MIN or state.amygdala.activation < 0.05;
    
    // Find dominant fear
    let fears = [
      (state.existentialFear, #Existential),
      (state.missionFear, #Mission),
      (state.lossFear, #Loss),
      (state.uncertaintyFear, #Uncertainty),
      (state.coherenceFear, #Coherence)
    ];
    
    var maxFear : Float = 0.0;
    var dominant : FearType = #Uncertainty;
    for ((f, t) in fears.vals()) {
      if (f > maxFear) {
        maxFear := f;
        dominant := t;
      };
    };
    
    // Threat status
    let threatStatus : ThreatLevel = if (state.totalFear > 0.8) { #Critical }
      else if (state.totalFear > 0.6) { #Extreme }
      else if (state.totalFear > 0.4) { #High }
      else if (state.totalFear > 0.2) { #Moderate }
      else if (state.totalFear > 0.1) { #Low }
      else { #None };
    
    // Stress level
    let stressLevel = (state.amygdala.cortisolLevel + state.amygdala.adrenalineLevel + state.amygdala.norepinephrine) / 3.0;
    
    // Recommendations
    let recommendations = Buffer.Buffer<Text>(4);
    if (isPanicking) {
      recommendations.add("URGENT: Fear levels critical — activate calming protocols");
      recommendations.add("Consider ARES rollback to safe state");
    };
    if (isComplacent) {
      recommendations.add("WARNING: Fear too low — increase vigilance");
      recommendations.add("Run threat assessment scan");
    };
    if (state.beatsInFear > 100) {
      recommendations.add("Extended fear state — risk of exhaustion");
    };
    if (stressLevel > 0.6) {
      recommendations.add("High stress — allocate recovery resources");
    };
    
    {
      isHealthy = isHealthy;
      isPanicking = isPanicking;
      isComplacent = isComplacent;
      dominantFear = dominant;
      threatStatus = threatStatus;
      recoveryStatus = state.recoveryProgress;
      stressLevel = stressLevel;
      recommendations = Buffer.toArray(recommendations);
    }
  };

}
