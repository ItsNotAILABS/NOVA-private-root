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


// ============================================================
// NEUROEMERGENCE CORE — INTEROCEPTION ENGINE
// Internal body state sensing for sovereign organism homeostasis
// 
// Interoception: the sense of the internal state of the body
// Signals: hunger, thirst, fatigue, arousal, temperature, pain
// 
// Mathematical Framework:
// - Allostatic Load: L = Σᵢ wᵢ · |sᵢ - sᵢ*| / σᵢ
// - Homeostatic Error: E_h = ∫(s(t) - s*)² dt
// - Predictive Interoception: p(s_t+1 | s_t, a_t)
// - Free Energy: F = E_q[-log p(o|s)] + KL[q(s)||p(s)]
// 
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ══════════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════════

  // Individual interoceptive channel
  public type InteroChannel = {
    name         : Text;           // Channel identifier
    value        : Float;          // Current signal value [0, 1]
    setpoint     : Float;          // Target homeostatic setpoint
    sensitivity  : Float;          // σ - variance of signal
    weight       : Float;          // wᵢ - importance weight
    velocity     : Float;          // Rate of change ds/dt
    prediction   : Float;          // Predicted next value
    error        : Float;          // Prediction error
    history      : [Float];        // Rolling history (last 50 beats)
  };

  // Hunger-specific state (complex multi-signal)
  public type HungerState = {
    glucose      : Float;          // Blood glucose level [0, 1]
    ghrelin      : Float;          // Hunger hormone [0, 1]
    leptin       : Float;          // Satiety hormone [0, 1]
    stomach      : Float;          // Stomach fullness [0, 1]
    metabolicRate: Float;          // Current metabolic demand
    hungerDrive  : Float;          // Composite hunger signal
  };

  // Fatigue-specific state
  public type FatigueState = {
    adenosine    : Float;          // Sleep pressure chemical [0, 1]
    cortisol     : Float;          // Stress/alertness hormone [0, 1]
    melatonin    : Float;          // Sleep hormone [0, 1]
    glycogen     : Float;          // Energy reserves [0, 1]
    cognitiveLoad: Float;          // Mental exhaustion [0, 1]
    fatigueDrive : Float;          // Composite fatigue signal
  };

  // Arousal/Alertness state
  public type ArousalState = {
    norepinephrine : Float;        // Alertness neurotransmitter [0, 1]
    acetylcholine  : Float;        // Attention neurotransmitter [0, 1]
    dopamine       : Float;        // Motivation neurotransmitter [0, 1]
    heartRate      : Float;        // Cardiac arousal [0, 1]
    skinConductance: Float;        // Galvanic response [0, 1]
    arousalLevel   : Float;        // Composite arousal signal
  };

  // Temperature regulation
  public type ThermoState = {
    coreTemp     : Float;          // Core body temperature [0, 1] → maps to 35-40°C
    skinTemp     : Float;          // Peripheral temperature [0, 1]
    setpoint     : Float;          // Target temperature (37°C norm)
    sweating     : Float;          // Cooling response [0, 1]
    shivering    : Float;          // Heating response [0, 1]
    thermoError  : Float;          // Deviation from setpoint
  };

  // Pain/Nociception state
  public type PainState = {
    nociceptive  : Float;          // Tissue damage signals [0, 1]
    inflammatory : Float;          // Inflammation level [0, 1]
    neuropathic  : Float;          // Nerve damage signals [0, 1]
    affective    : Float;          // Emotional pain component [0, 1]
    endorphins   : Float;          // Natural pain relief [0, 1]
    painIntensity: Float;          // Composite pain signal
  };

  // Full interoceptive state
  public type InteroState = {
    // Core channels
    channels     : [InteroChannel];
    
    // Specialized subsystems
    hunger       : HungerState;
    fatigue      : FatigueState;
    arousal      : ArousalState;
    thermo       : ThermoState;
    pain         : PainState;
    
    // Global metrics
    allostaticLoad  : Float;       // Overall body stress
    homeostaticError: Float;       // Deviation from setpoints
    wellbeingIndex  : Float;       // Inverse of allostatic load
    survivalUrgency : Float;       // Immediate action needed?
    
    // Predictive coding
    predictionError : Float;       // Free energy (interoceptive)
    bodyBudget      : Float;       // Energy budget estimate
    
    // Temporal
    beatNum         : Nat;
    lastUpdate      : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let EPSILON : Float = 1e-10;
  let HISTORY_SIZE : Nat = 50;

  // Default setpoints (homeostatic targets)
  let DEFAULT_GLUCOSE_SETPOINT : Float = 0.5;
  let DEFAULT_TEMP_SETPOINT : Float = 0.5;  // 37°C
  let DEFAULT_AROUSAL_SETPOINT : Float = 0.4;
  let DEFAULT_FATIGUE_SETPOINT : Float = 0.3;

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func _sigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-x))
  };

  func _tanh(x: Float) : Float {
    let e2x = Float.exp(2.0 * x);
    (e2x - 1.0) / (e2x + 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // CORE INTEROCEPTION MATH
  // ══════════════════════════════════════════════════════════════

  // Allostatic Load: L = Σᵢ wᵢ · |sᵢ - sᵢ*| / σᵢ
  // Measures cumulative body stress from homeostatic deviations
  public func computeAllostaticLoad(channels: [InteroChannel]) : Float {
    var load : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for (ch in channels.vals()) {
      let deviation = _abs(ch.value - ch.setpoint);
      let normalizedDev = deviation / (ch.sensitivity + EPSILON);
      load += ch.weight * normalizedDev;
      totalWeight += ch.weight;
    };
    
    if (totalWeight > EPSILON) {
      _clamp(load / totalWeight, 0.0, 1.0)
    } else { 0.0 }
  };

  // Homeostatic Error: cumulative squared deviation
  public func computeHomeostaticError(channels: [InteroChannel]) : Float {
    var sumSqError : Float = 0.0;
    var n : Float = 0.0;
    
    for (ch in channels.vals()) {
      let error = ch.value - ch.setpoint;
      sumSqError += error * error * ch.weight;
      n += ch.weight;
    };
    
    if (n > EPSILON) {
      Float.sqrt(sumSqError / n)
    } else { 0.0 }
  };

  // Predictive Interoception: predict next state
  // Simple AR(1): s_t+1 = α·s_t + (1-α)·setpoint + β·velocity
  public func predictNextValue(
    current: Float, setpoint: Float, velocity: Float,
    alpha: Float, beta: Float
  ) : Float {
    let predicted = alpha * current + (1.0 - alpha) * setpoint + beta * velocity;
    _clamp(predicted, 0.0, 1.0)
  };

  // Interoceptive Prediction Error (for free energy)
  public func computePredictionError(predicted: Float, actual: Float, precision: Float) : Float {
    precision * (actual - predicted) * (actual - predicted)
  };

  // ══════════════════════════════════════════════════════════════
  // HUNGER SUBSYSTEM
  // ══════════════════════════════════════════════════════════════

  // Update hunger state based on metabolic dynamics
  // Hunger = high ghrelin + low glucose + low leptin + empty stomach
  public func updateHunger(hunger: HungerState, energyExpenditure: Float, foodIntake: Float) : HungerState {
    // Glucose dynamics: drops with expenditure, rises with intake
    let newGlucose = _clamp(
      hunger.glucose - energyExpenditure * 0.05 + foodIntake * 0.3,
      0.0, 1.0
    );
    
    // Ghrelin: rises when glucose low, drops after eating
    let ghrelinChange = (0.5 - newGlucose) * 0.1 - foodIntake * 0.4;
    let newGhrelin = _clamp(hunger.ghrelin + ghrelinChange, 0.0, 1.0);
    
    // Leptin: rises with satiety (inverse of ghrelin roughly)
    let newLeptin = _clamp(
      hunger.leptin + foodIntake * 0.3 - energyExpenditure * 0.02,
      0.0, 1.0
    );
    
    // Stomach fullness
    let newStomach = _clamp(
      hunger.stomach + foodIntake * 0.5 - 0.02,  // Empties slowly
      0.0, 1.0
    );
    
    // Metabolic rate adapts to energy availability
    let newMetabolic = _clamp(
      0.4 + 0.3 * newGlucose + 0.3 * hunger.metabolicRate,
      0.2, 0.8
    );
    
    // Composite hunger drive
    // High ghrelin, low glucose, low leptin, empty stomach → high hunger
    let hungerDrive = _clamp(
      0.3 * newGhrelin + 0.3 * (1.0 - newGlucose) + 
      0.2 * (1.0 - newLeptin) + 0.2 * (1.0 - newStomach),
      0.0, 1.0
    );
    
    {
      glucose = newGlucose;
      ghrelin = newGhrelin;
      leptin = newLeptin;
      stomach = newStomach;
      metabolicRate = newMetabolic;
      hungerDrive = hungerDrive;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // FATIGUE SUBSYSTEM
  // ══════════════════════════════════════════════════════════════

  // Update fatigue based on activity and rest
  public func updateFatigue(fatigue: FatigueState, activity: Float, sleep: Float, beatOfDay: Nat) : FatigueState {
    // Adenosine: accumulates during waking, clears during sleep
    let adenosineGain = if (sleep < 0.5) { activity * 0.02 } else { -0.1 };
    let newAdenosine = _clamp(fatigue.adenosine + adenosineGain, 0.0, 1.0);
    
    // Cortisol: circadian rhythm (high morning, low evening)
    let circadianPhase = Float.sin(Float.fromInt(beatOfDay) * 0.001);
    let newCortisol = _clamp(
      0.5 + 0.3 * circadianPhase + 0.2 * (1.0 - newAdenosine),
      0.0, 1.0
    );
    
    // Melatonin: inverse of cortisol (circadian)
    let newMelatonin = _clamp(
      0.5 - 0.3 * circadianPhase + sleep * 0.3,
      0.0, 1.0
    );
    
    // Glycogen: energy reserves deplete with activity
    let newGlycogen = _clamp(
      fatigue.glycogen - activity * 0.01 + sleep * 0.05,
      0.0, 1.0
    );
    
    // Cognitive load: mental fatigue
    let cogLoad = _clamp(
      fatigue.cognitiveLoad * 0.95 + activity * 0.1,
      0.0, 1.0
    );
    
    // Composite fatigue drive
    // High adenosine, low glycogen, high cognitive load → high fatigue
    let fatigueDrive = _clamp(
      0.35 * newAdenosine + 0.25 * (1.0 - newGlycogen) + 
      0.25 * cogLoad + 0.15 * newMelatonin,
      0.0, 1.0
    );
    
    {
      adenosine = newAdenosine;
      cortisol = newCortisol;
      melatonin = newMelatonin;
      glycogen = newGlycogen;
      cognitiveLoad = cogLoad;
      fatigueDrive = fatigueDrive;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // AROUSAL SUBSYSTEM
  // ══════════════════════════════════════════════════════════════

  // Update arousal based on stimulation and threat
  public func updateArousal(arousal: ArousalState, stimulation: Float, threat: Float, reward: Float) : ArousalState {
    // Norepinephrine: rises with threat/novelty
    let newNorepi = _clamp(
      arousal.norepinephrine * 0.9 + threat * 0.2 + stimulation * 0.1,
      0.0, 1.0
    );
    
    // Acetylcholine: attention modulation
    let newACh = _clamp(
      arousal.acetylcholine * 0.85 + stimulation * 0.15,
      0.0, 1.0
    );
    
    // Dopamine: reward and motivation
    let newDopamine = _clamp(
      arousal.dopamine * 0.8 + reward * 0.3 - 0.02,  // Natural decay
      0.0, 1.0
    );
    
    // Heart rate: sympathetic response
    let newHR = _clamp(
      arousal.heartRate * 0.7 + 0.15 * newNorepi + 0.1 * threat + 0.05,
      0.2, 1.0  // Minimum resting HR
    );
    
    // Skin conductance: emotional arousal
    let newSC = _clamp(
      arousal.skinConductance * 0.8 + 0.1 * threat + 0.1 * reward,
      0.0, 1.0
    );
    
    // Composite arousal level
    let arousalLevel = _clamp(
      0.25 * newNorepi + 0.2 * newACh + 0.2 * newDopamine +
      0.2 * newHR + 0.15 * newSC,
      0.0, 1.0
    );
    
    {
      norepinephrine = newNorepi;
      acetylcholine = newACh;
      dopamine = newDopamine;
      heartRate = newHR;
      skinConductance = newSC;
      arousalLevel = arousalLevel;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THERMOREGULATION
  // ══════════════════════════════════════════════════════════════

  // Update temperature regulation
  public func updateThermo(thermo: ThermoState, ambient: Float, activity: Float) : ThermoState {
    // Core temp: affected by activity (heat generation) and ambient
    let heatGen = activity * 0.05;
    let heatLoss = (thermo.coreTemp - ambient) * 0.02;
    let newCore = _clamp(
      thermo.coreTemp + heatGen - heatLoss,
      0.2, 0.9  // Survivable range
    );
    
    // Skin temp: more responsive to ambient
    let newSkin = _clamp(
      thermo.skinTemp * 0.7 + ambient * 0.2 + newCore * 0.1,
      0.1, 0.9
    );
    
    // Error from setpoint
    let error = newCore - thermo.setpoint;
    
    // Sweating response (cooling) - activates when hot
    let newSweat = if (error > 0.02) {
      _clamp(error * 5.0, 0.0, 1.0)
    } else { thermo.sweating * 0.9 };
    
    // Shivering response (heating) - activates when cold
    let newShiver = if (error < -0.02) {
      _clamp(-error * 5.0, 0.0, 1.0)
    } else { thermo.shivering * 0.9 };
    
    {
      coreTemp = newCore;
      skinTemp = newSkin;
      setpoint = thermo.setpoint;
      sweating = newSweat;
      shivering = newShiver;
      thermoError = error;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // PAIN/NOCICEPTION
  // ══════════════════════════════════════════════════════════════

  // Update pain state
  public func updatePain(pain: PainState, damage: Float, inflammation: Float, stress: Float) : PainState {
    // Nociceptive: direct tissue damage
    let newNoci = _clamp(
      pain.nociceptive * 0.95 + damage * 0.2,
      0.0, 1.0
    );
    
    // Inflammatory: slower, longer lasting
    let newInflam = _clamp(
      pain.inflammatory * 0.98 + inflammation * 0.1,
      0.0, 1.0
    );
    
    // Neuropathic: nerve damage (very slow to heal)
    let newNeuro = _clamp(
      pain.neuropathic * 0.995 + damage * 0.01,
      0.0, 1.0
    );
    
    // Affective: emotional component of pain
    let newAffect = _clamp(
      pain.affective * 0.9 + stress * 0.05 + newNoci * 0.1,
      0.0, 1.0
    );
    
    // Endorphins: natural pain relief (stress-induced)
    let newEndo = _clamp(
      pain.endorphins * 0.85 + stress * 0.1 + (if (newNoci > 0.5) { 0.1 } else { 0.0 }),
      0.0, 1.0
    );
    
    // Composite pain intensity (endorphins reduce it)
    let painIntensity = _clamp(
      (0.4 * newNoci + 0.25 * newInflam + 0.2 * newNeuro + 0.15 * newAffect) * (1.0 - newEndo * 0.5),
      0.0, 1.0
    );
    
    {
      nociceptive = newNoci;
      inflammatory = newInflam;
      neuropathic = newNeuro;
      affective = newAffect;
      endorphins = newEndo;
      painIntensity = painIntensity;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SURVIVAL URGENCY
  // ══════════════════════════════════════════════════════════════

  // Compute survival urgency - immediate action needed?
  // High urgency when critical channels far from setpoint
  public func computeSurvivalUrgency(state: InteroState) : Float {
    var urgency : Float = 0.0;
    
    // Critical thresholds
    if (state.hunger.glucose < 0.15) { urgency += 0.4 };        // Hypoglycemia
    if (state.hunger.glucose > 0.85) { urgency += 0.2 };        // Hyperglycemia
    if (state.thermo.coreTemp < 0.3) { urgency += 0.5 };        // Hypothermia
    if (state.thermo.coreTemp > 0.75) { urgency += 0.5 };       // Hyperthermia
    if (state.pain.painIntensity > 0.8) { urgency += 0.3 };     // Severe pain
    if (state.fatigue.fatigueDrive > 0.9) { urgency += 0.2 };   // Extreme fatigue
    
    // Allostatic load contribution
    urgency += state.allostaticLoad * 0.3;
    
    _clamp(urgency, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // BODY BUDGET (Energy accounting)
  // ══════════════════════════════════════════════════════════════

  // Estimate body budget: available energy for action
  public func computeBodyBudget(state: InteroState) : Float {
    let glucoseContrib = state.hunger.glucose * 0.4;
    let glycogenContrib = state.fatigue.glycogen * 0.3;
    let fatigueDebit = state.fatigue.fatigueDrive * 0.2;
    let painDebit = state.pain.painIntensity * 0.1;
    
    _clamp(glucoseContrib + glycogenContrib - fatigueDebit - painDebit, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // WELLBEING INDEX
  // ══════════════════════════════════════════════════════════════

  // Overall wellbeing: inverse of distress signals
  public func computeWellbeing(state: InteroState) : Float {
    let distress = 
      state.allostaticLoad * 0.3 +
      state.hunger.hungerDrive * 0.15 +
      state.fatigue.fatigueDrive * 0.15 +
      state.pain.painIntensity * 0.2 +
      _abs(state.thermo.thermoError) * 0.1 +
      (1.0 - state.arousal.dopamine) * 0.1;
    
    _clamp(1.0 - distress, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // CHANNEL UPDATE
  // ══════════════════════════════════════════════════════════════

  // Update individual channel with prediction
  public func updateChannel(ch: InteroChannel, newValue: Float, beat: Nat) : InteroChannel {
    // Compute velocity
    let velocity = newValue - ch.value;
    
    // Predict next value
    let prediction = predictNextValue(newValue, ch.setpoint, velocity, 0.8, 0.2);
    
    // Update history (rolling window)
    let newHistory = if (ch.history.size() >= HISTORY_SIZE) {
      let tail = Array.tabulate<Float>(HISTORY_SIZE - 1, func(i) { ch.history[i + 1] });
      Array.append<Float>(tail, [newValue])
    } else {
      Array.append<Float>(ch.history, [newValue])
    };
    
    {
      name = ch.name;
      value = _clamp(newValue, 0.0, 1.0);
      setpoint = ch.setpoint;
      sensitivity = ch.sensitivity;
      weight = ch.weight;
      velocity = velocity;
      prediction = prediction;
      error = newValue - ch.prediction;  // Compare to previous prediction
      history = newHistory;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type InteroInput = {
    energyExpenditure : Float;    // Activity level [0, 1]
    foodIntake        : Float;    // Food consumed [0, 1]
    sleepState        : Float;    // Sleep depth [0, 1]
    ambientTemp       : Float;    // Environment temp [0, 1]
    threat            : Float;    // Threat level [0, 1]
    reward            : Float;    // Reward signal [0, 1]
    stimulation       : Float;    // Sensory stimulation [0, 1]
    damage            : Float;    // Physical damage [0, 1]
    inflammation      : Float;    // Inflammation level [0, 1]
    stress            : Float;    // Psychological stress [0, 1]
  };

  // Full interoceptive beat update
  public func beatInteroception(state: InteroState, input: InteroInput, beatOfDay: Nat) : InteroState {
    // Update subsystems
    let newHunger = updateHunger(state.hunger, input.energyExpenditure, input.foodIntake);
    let newFatigue = updateFatigue(state.fatigue, input.energyExpenditure, input.sleepState, beatOfDay);
    let newArousal = updateArousal(state.arousal, input.stimulation, input.threat, input.reward);
    let newThermo = updateThermo(state.thermo, input.ambientTemp, input.energyExpenditure);
    let newPain = updatePain(state.pain, input.damage, input.inflammation, input.stress);
    
    // Create derived channel values for global metrics
    let channelValues : [(Float, Float, Float)] = [
      (newHunger.hungerDrive, 0.2, 0.15),     // value, setpoint, weight
      (newFatigue.fatigueDrive, 0.3, 0.2),
      (newArousal.arousalLevel, 0.4, 0.15),
      (newThermo.coreTemp, 0.5, 0.25),
      (newPain.painIntensity, 0.0, 0.25),
    ];
    
    // Build simple channels for allostatic calculation
    let simpleChannels = Array.tabulate<InteroChannel>(5, func(i) {
      let (val, sp, w) = channelValues[i];
      {
        name = "";
        value = val;
        setpoint = sp;
        sensitivity = 0.2;
        weight = w;
        velocity = 0.0;
        prediction = val;
        error = 0.0;
        history = [];
      }
    });
    
    // Compute global metrics
    let allostaticLoad = computeAllostaticLoad(simpleChannels);
    let homeostaticError = computeHomeostaticError(simpleChannels);
    
    // Build intermediate state for urgency/budget
    let interimState : InteroState = {
      channels = state.channels;
      hunger = newHunger;
      fatigue = newFatigue;
      arousal = newArousal;
      thermo = newThermo;
      pain = newPain;
      allostaticLoad = allostaticLoad;
      homeostaticError = homeostaticError;
      wellbeingIndex = 0.0;
      survivalUrgency = 0.0;
      predictionError = 0.0;
      bodyBudget = 0.0;
      beatNum = state.beatNum;
      lastUpdate = state.beatNum;
    };
    
    let survivalUrgency = computeSurvivalUrgency(interimState);
    let bodyBudget = computeBodyBudget(interimState);
    let wellbeing = computeWellbeing(interimState);
    
    // Interoceptive prediction error (free energy)
    let predError = 
      _abs(newHunger.hungerDrive - state.hunger.hungerDrive) +
      _abs(newFatigue.fatigueDrive - state.fatigue.fatigueDrive) +
      _abs(newArousal.arousalLevel - state.arousal.arousalLevel) +
      _abs(newThermo.thermoError - state.thermo.thermoError) +
      _abs(newPain.painIntensity - state.pain.painIntensity);
    
    {
      channels = state.channels;  // Could update individual channels here
      hunger = newHunger;
      fatigue = newFatigue;
      arousal = newArousal;
      thermo = newThermo;
      pain = newPain;
      allostaticLoad = allostaticLoad;
      homeostaticError = homeostaticError;
      wellbeingIndex = wellbeing;
      survivalUrgency = survivalUrgency;
      predictionError = predError;
      bodyBudget = bodyBudget;
      beatNum = state.beatNum + 1;
      lastUpdate = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // ACTION PRIORITIES (for sovereign organism)
  // ══════════════════════════════════════════════════════════════

  public type InteroAction = {
    #Eat;           // Address hunger
    #Sleep;         // Address fatigue
    #Flee;          // Address threat/arousal
    #Cool;          // Address overheating
    #Warm;          // Address hypothermia
    #Rest;          // Reduce pain/recover
    #Explore;       // Seek stimulation (when bored)
    #Maintain;      // No urgent action
  };

  // Determine most urgent interoceptive action
  public func prioritizeAction(state: InteroState) : InteroAction {
    // Critical thresholds first
    if (state.thermo.coreTemp > 0.7) { return #Cool };
    if (state.thermo.coreTemp < 0.35) { return #Warm };
    if (state.survivalUrgency > 0.7) {
      if (state.hunger.glucose < 0.2) { return #Eat };
      if (state.arousal.arousalLevel > 0.9) { return #Flee };
    };
    
    // Non-critical priorities
    if (state.hunger.hungerDrive > 0.7) { return #Eat };
    if (state.fatigue.fatigueDrive > 0.7) { return #Sleep };
    if (state.pain.painIntensity > 0.5) { return #Rest };
    if (state.arousal.arousalLevel < 0.2) { return #Explore };
    
    #Maintain
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initInteroception() : InteroState {
    {
      channels = [];
      hunger = {
        glucose = 0.5;
        ghrelin = 0.3;
        leptin = 0.5;
        stomach = 0.5;
        metabolicRate = 0.5;
        hungerDrive = 0.3;
      };
      fatigue = {
        adenosine = 0.2;
        cortisol = 0.5;
        melatonin = 0.2;
        glycogen = 0.7;
        cognitiveLoad = 0.2;
        fatigueDrive = 0.2;
      };
      arousal = {
        norepinephrine = 0.3;
        acetylcholine = 0.4;
        dopamine = 0.5;
        heartRate = 0.4;
        skinConductance = 0.2;
        arousalLevel = 0.35;
      };
      thermo = {
        coreTemp = 0.5;
        skinTemp = 0.5;
        setpoint = 0.5;
        sweating = 0.0;
        shivering = 0.0;
        thermoError = 0.0;
      };
      pain = {
        nociceptive = 0.0;
        inflammatory = 0.0;
        neuropathic = 0.0;
        affective = 0.0;
        endorphins = 0.2;
        painIntensity = 0.0;
      };
      allostaticLoad = 0.0;
      homeostaticError = 0.0;
      wellbeingIndex = 0.8;
      survivalUrgency = 0.0;
      predictionError = 0.0;
      bodyBudget = 0.7;
      beatNum = 0;
      lastUpdate = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type InteroSummary = {
    allostaticLoad   : Float;
    wellbeingIndex   : Float;
    survivalUrgency  : Float;
    bodyBudget       : Float;
    hungerDrive      : Float;
    fatigueDrive     : Float;
    arousalLevel     : Float;
    painIntensity    : Float;
    thermoError      : Float;
    priorityAction   : InteroAction;
  };

  public func summary(state: InteroState) : InteroSummary {
    {
      allostaticLoad = state.allostaticLoad;
      wellbeingIndex = state.wellbeingIndex;
      survivalUrgency = state.survivalUrgency;
      bodyBudget = state.bodyBudget;
      hungerDrive = state.hunger.hungerDrive;
      fatigueDrive = state.fatigue.fatigueDrive;
      arousalLevel = state.arousal.arousalLevel;
      painIntensity = state.pain.painIntensity;
      thermoError = state.thermo.thermoError;
      priorityAction = prioritizeAction(state);
    }
  };

}
