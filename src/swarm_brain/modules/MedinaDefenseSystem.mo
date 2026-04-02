// ════════════════════════════════════════════════════════════════════════════
// ██████╗ ███████╗███████╗███████╗███╗   ██╗███████╗███████╗
// ██╔══██╗██╔════╝██╔════╝██╔════╝████╗  ██║██╔════╝██╔════╝
// ██║  ██║█████╗  █████╗  █████╗  ██╔██╗ ██║███████╗█████╗  
// ██║  ██║██╔══╝  ██╔══╝  ██╔══╝  ██║╚██╗██║╚════██║██╔══╝  
// ██████╔╝███████╗██║     ███████╗██║ ╚████║███████║███████╗
// ╚═════╝ ╚══════╝╚═╝     ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝
//    ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
//    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
//    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
//    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
//    ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
//    ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝
// ════════════════════════════════════════════════════════════════════════════
//
// MEDINA DEFENSE SYSTEM
// Biologically-Accurate Threat Detection, Fear Circuits, and Response
//
// ════════════════════════════════════════════════════════════════════════════
// REAL NEUROSCIENCE: THE FEAR CIRCUIT
// ════════════════════════════════════════════════════════════════════════════
//
// THE AMYGDALA — Fear Processing Center:
// ─────────────────────────────────────
// - Lateral Amygdala (LA): Receives sensory input, threat detection
// - Basal Amygdala (BA): Integrates context, sends to prefrontal
// - Central Amygdala (CeA): Output nucleus, triggers fear responses
// - Basolateral complex (BLA): LA + BA, associative learning
//
// TWO PATHWAYS TO AMYGDALA (LeDoux):
// ─────────────────────────────────
// 1. LOW ROAD (fast, dirty):
//    Thalamus → Amygdala (12ms)
//    - Quick threat detection
//    - False positives acceptable
//    - "Better safe than sorry"
//
// 2. HIGH ROAD (slow, accurate):
//    Thalamus → Cortex → Amygdala (24ms+)
//    - Detailed threat analysis
//    - Context-dependent
//    - Can override low road
//
// FEAR OUTPUTS FROM CENTRAL AMYGDALA:
// ──────────────────────────────────
// → Hypothalamus: Stress hormones (cortisol, adrenaline)
// → Periaqueductal Gray: Freezing behavior
// → Lateral Hypothalamus: Sympathetic activation
// → Parabrachial Nucleus: Breathing changes
// → Locus Coeruleus: Norepinephrine release (arousal)
// → Facial Motor Nucleus: Fear expression
// → Trigeminal Nucleus: Jaw tension
// → Paraventricular Hypothalamus: HPA axis activation
//
// FEAR EXTINCTION:
// ───────────────
// - Medial Prefrontal Cortex (mPFC) inhibits amygdala
// - Infralimbic cortex → Intercalated cells → CeA inhibition
// - NOT erasure but new inhibitory learning
// - Context-dependent (hippocampus involved)
//
// STRESS HORMONES:
// ───────────────
// - Cortisol: HPA axis, slow (minutes), genomic effects
// - Adrenaline: Sympathetic, fast (seconds), fight-flight
// - Norepinephrine: Brain arousal
// - CRH: Hypothalamic release factor
// - ACTH: Pituitary hormone
//
// ════════════════════════════════════════════════════════════════════════════
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA THREAT DETECTION EQUATION (MTDE):
// ────────────────────────────────────────────
//   T(s) = α_low × f_low(s) + α_high × f_high(s) × context
//   f_low(s) = σ_M(‖features - threat_template‖ / threshold)
//   f_high(s) = cortical_analysis(s) × hippocampal_context(s)
//
// THE MEDINA FEAR RESPONSE DYNAMICS (MFRD):
// ─────────────────────────────────────────
//   dF/dt = β × T(s) - γ × F - δ × extinction_signal + η × stress_hormones
//
// THE MEDINA FIGHT-FLIGHT-FREEZE DECISION (MFFFD):
// ────────────────────────────────────────────────
//   P(action) = softmax([fight_value, flight_value, freeze_value] / T)
//   fight_value = aggression × strength × Φ_M^(-fear_level)
//   flight_value = fear × escape_route × Φ_M^(-fatigue)
//   freeze_value = fear × concealment × Φ_M^(-detectability)
//
// THE MEDINA STRESS HORMONE CASCADE (MSHC):
// ─────────────────────────────────────────
//   CRH(t) = CRH_base + k₁ × amygdala_output
//   ACTH(t) = ACTH_base + k₂ × CRH(t - τ₁)
//   Cortisol(t) = Cortisol_base + k₃ × ACTH(t - τ₂) - feedback(Cortisol)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════
  // BIOLOGICAL CONSTANTS (Real neuroscience values)
  // ══════════════════════════════════════════════════════════════
  let PHI_MEDINA : Float = 2.97442179;
  let OMEGA_MEDINA : Float = 2.11185;
  let TAU_EMERGENCE : Float = 0.618033988749;

  // Timing constants (ms)
  let LOW_ROAD_LATENCY : Float = 12.0;        // Thalamus → Amygdala
  let HIGH_ROAD_LATENCY : Float = 24.0;       // Thalamus → Cortex → Amygdala
  let FREEZE_ONSET : Float = 50.0;            // Time to freeze response
  let FLIGHT_ONSET : Float = 100.0;           // Time to flight initiation
  let FIGHT_ONSET : Float = 150.0;            // Time to aggressive response

  // Hormone kinetics
  let TAU_ADRENALINE : Float = 5000.0;        // ms (fast: seconds)
  let TAU_CORTISOL : Float = 300000.0;        // ms (slow: minutes)
  let TAU_NOREPINEPHRINE : Float = 10000.0;   // ms
  let CORTISOL_FEEDBACK : Float = 0.001;      // Negative feedback rate

  // Fear circuit parameters
  let AMYGDALA_SENSITIVITY : Float = 0.5;     // Base threat sensitivity
  let EXTINCTION_RATE : Float = 0.01;         // Fear extinction rate
  let GENERALIZATION_SIGMA : Float = 0.3;     // Threat generalization width

  // ══════════════════════════════════════════════════════════════
  // AMYGDALA NUCLEI
  // ══════════════════════════════════════════════════════════════
  public type AmygdalaNuclei = {
    lateralAmygdala   : LateralAmygdala;
    basalAmygdala     : BasalAmygdala;
    centralAmygdala   : CentralAmygdala;
    intercalatedCells : Float;    // Inhibitory gate
  };

  public type LateralAmygdala = {
    activation        : Float;
    threatDetection   : Float;
    sensoryInput      : [Float];
    plasticWeights    : [Float];  // Fear conditioning weights
    recentSpikes      : [Float];  // Spike times
  };

  public type BasalAmygdala = {
    activation        : Float;
    contextIntegration: Float;
    hippocampalInput  : Float;
    prefrontalInput   : Float;
    valenceCoding     : Float;    // Positive vs negative valence
  };

  public type CentralAmygdala = {
    activation        : Float;
    outputLevel       : Float;
    medialDivision    : Float;    // CeM - output to brainstem
    lateralDivision   : Float;    // CeL - local inhibition
    freezeOutput      : Float;
    flightOutput      : Float;
    autonomicOutput   : Float;
  };

  // ══════════════════════════════════════════════════════════════
  // THREAT TYPES
  // ══════════════════════════════════════════════════════════════
  public type ThreatType = {
    #Predator;
    #Conspecific;       // Same species aggressor
    #Environmental;     // Fire, flood, etc.
    #Pathogen;
    #Starvation;
    #Dehydration;
    #Temperature;       // Extreme heat/cold
    #Unknown;
  };

  public type ThreatSignature = {
    threatType        : ThreatType;
    visualFeatures    : [Float];   // Visual pattern
    auditoryFeatures  : [Float];   // Sound pattern
    olfactoryFeatures : [Float];   // Smell pattern
    movementPattern   : [Float];   // Motion signature
    size              : Float;
    distance          : Float;
    velocity          : Float;     // Approach speed
    looming           : Bool;      // Expanding visual angle
  };

  // ══════════════════════════════════════════════════════════════
  // STRESS HORMONE STATE
  // ══════════════════════════════════════════════════════════════
  public type StressHormoneState = {
    // Fast-acting (sympathetic)
    adrenaline        : Float;     // Epinephrine
    noradrenaline     : Float;     // Norepinephrine
    
    // HPA axis (slow)
    crh               : Float;     // Corticotropin-releasing hormone
    acth              : Float;     // Adrenocorticotropic hormone
    cortisol          : Float;     // Glucocorticoid
    
    // Accumulated stress
    allostaticLoad    : Float;     // Cumulative stress damage
    
    // Timestamps
    lastStressor      : Float;
    chronicStressLevel: Float;
  };

  // ══════════════════════════════════════════════════════════════
  // FEAR STATE
  // ══════════════════════════════════════════════════════════════
  public type FearState = {
    // Core fear circuit
    amygdala          : AmygdalaNuclei;
    
    // Fear level
    currentFear       : Float;     // 0-1 fear intensity
    conditionedFears  : [ConditionedFear];
    
    // Behavioral output
    freezeActivation  : Float;
    flightActivation  : Float;
    fightActivation   : Float;
    
    // Extinction
    extinctionProgress: Float;     // How much fear has been extinguished
    safetySignals     : [Float];   // Learned safety cues
    
    // Stress hormones
    hormones          : StressHormoneState;
    
    // Physiological arousal
    heartRateIncrease : Float;
    breathingRate     : Float;
    muscleReadiness   : Float;
    pupilDilation     : Float;
  };

  public type ConditionedFear = {
    stimulus          : [Float];   // CS (conditioned stimulus)
    fearStrength      : Float;     // Association strength
    extinctionLevel   : Float;     // Extinction progress
    lastActivation    : Float;     // Time of last activation
    contextDependence : Float;     // How context-specific
  };

  // ══════════════════════════════════════════════════════════════
  // DEFENSIVE BEHAVIORS
  // ══════════════════════════════════════════════════════════════
  public type DefensiveBehavior = {
    #Freeze;
    #Flight;
    #Fight;
    #Fawn;            // Appeasement
    #Hide;
    #Alarm;           // Warning others
    #Mob;             // Group defense
    #Feign_Death;     // Tonic immobility
  };

  // ══════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func medinaSigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-PHI_MEDINA * x))
  };

  func softmax(values: [Float], temperature: Float) : [Float] {
    let n = values.size();
    if (n == 0) { return [] };
    
    // Find max for numerical stability
    var maxVal : Float = values[0];
    for (v in values.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    
    // Compute exp and sum
    var expSum : Float = 0.0;
    let exps = Array.map<Float, Float>(values, func(v) {
      let e = Float.exp((v - maxVal) / (temperature + 0.001));
      expSum += e;
      e
    });
    
    // Normalize
    Array.map<Float, Float>(exps, func(e) { e / expSum })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA THREAT DETECTION EQUATION (MTDE)
  // ══════════════════════════════════════════════════════════════
  //
  // Low road + high road threat processing
  //
  // T(s) = α_low × f_low(s) + α_high × f_high(s) × context
  //
  public func medinaThreatDetection(
    stimulus: ThreatSignature,
    threatTemplates: [[Float]],
    contextSafety: Float,
    attentionalFocus: Float
  ) : (Float, Float) {
    // LOW ROAD: Fast, template matching
    var lowRoadThreat : Float = 0.0;
    
    // Match against innate threat templates
    for (template in threatTemplates.vals()) {
      var distance : Float = 0.0;
      var i : Nat = 0;
      while (i < template.size() and i < stimulus.visualFeatures.size()) {
        let diff = template[i] - stimulus.visualFeatures[i];
        distance += diff * diff;
        i += 1;
      };
      distance := Float.sqrt(distance);
      
      // Threat detection (closer = more threatening)
      let templateMatch = medinaSigmoid(-distance / GENERALIZATION_SIGMA + 0.5);
      if (templateMatch > lowRoadThreat) {
        lowRoadThreat := templateMatch;
      };
    };
    
    // Looming detection (expanding visual angle = approaching threat)
    if (stimulus.looming) {
      lowRoadThreat := _clamp(lowRoadThreat + 0.3, 0.0, 1.0);
    };
    
    // Size and proximity boost
    let sizeProximityThreat = (stimulus.size / (stimulus.distance + 1.0)) * 0.5;
    lowRoadThreat := _clamp(lowRoadThreat + sizeProximityThreat, 0.0, 1.0);
    
    // HIGH ROAD: Slow, context-dependent
    var highRoadThreat : Float = lowRoadThreat;
    
    // Context modulation (safe context reduces threat)
    highRoadThreat *= (1.0 - contextSafety * 0.5);
    
    // Attentional focus modulation
    highRoadThreat *= (0.5 + attentionalFocus * 0.5);
    
    // Medina integration: weighted by processing time
    let alpha_low = 0.6;   // Low road weight
    let alpha_high = 0.4;  // High road weight
    
    let totalThreat = alpha_low * lowRoadThreat + alpha_high * highRoadThreat;
    
    (lowRoadThreat, _clamp(totalThreat, 0.0, 1.0))
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA FEAR RESPONSE DYNAMICS (MFRD)
  // ══════════════════════════════════════════════════════════════
  //
  // dF/dt = β × T(s) - γ × F - δ × extinction + η × hormones
  //
  public func medinaFearDynamics(
    currentFear: Float,
    threatLevel: Float,
    extinctionSignal: Float,
    stressHormones: Float,
    deltaTime: Float
  ) : Float {
    let beta : Float = 0.3;   // Threat sensitivity
    let gamma : Float = 0.05;  // Natural decay
    let delta : Float = 0.1;   // Extinction rate
    let eta : Float = 0.2;     // Hormone amplification
    
    // Fear change rate
    let dFdt = beta * threatLevel 
             - gamma * currentFear 
             - delta * extinctionSignal * currentFear
             + eta * stressHormones * threatLevel;
    
    // Medina temporal integration
    let medinaFactor = Float.pow(PHI_MEDINA, -currentFear);
    let newFear = currentFear + dFdt * deltaTime * medinaFactor;
    
    _clamp(newFear, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA FIGHT-FLIGHT-FREEZE DECISION (MFFFD)
  // ══════════════════════════════════════════════════════════════
  //
  // Probabilistic action selection based on threat assessment
  //
  public func medinaDefensiveDecision(
    fearLevel: Float,
    threatDistance: Float,
    escapeRouteQuality: Float,
    relativeStrength: Float,
    concealment: Float,
    fatigue: Float
  ) : (DefensiveBehavior, Float) {
    // Fight value: high when strong, threat close, no escape
    let fightValue = relativeStrength * (1.0 - escapeRouteQuality * 0.5) * 
                     Float.pow(PHI_MEDINA, -fearLevel);
    
    // Flight value: high when escape available, not exhausted
    let flightValue = fearLevel * escapeRouteQuality * 
                      Float.pow(PHI_MEDINA, -fatigue);
    
    // Freeze value: high when hidden, threat uncertain
    let freezeValue = fearLevel * concealment * (1.0 - relativeStrength) *
                      Float.pow(PHI_MEDINA, -1.0 / (threatDistance + 0.1));
    
    // Temperature (lower = more deterministic)
    let temperature = 0.2 + (1.0 - fearLevel) * 0.3;
    
    let values = [fightValue, flightValue, freezeValue];
    let probs = softmax(values, temperature);
    
    // Select behavior with highest probability
    var maxProb : Float = 0.0;
    var maxIdx : Nat = 0;
    var i : Nat = 0;
    for (p in probs.vals()) {
      if (p > maxProb) {
        maxProb := p;
        maxIdx := i;
      };
      i += 1;
    };
    
    let behavior : DefensiveBehavior = switch (maxIdx) {
      case 0 { #Fight };
      case 1 { #Flight };
      case _ { #Freeze };
    };
    
    (behavior, maxProb)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA STRESS HORMONE CASCADE (MSHC)
  // ══════════════════════════════════════════════════════════════
  //
  // HPA axis dynamics with feedback
  //
  public func medinaStressHormoneCascade(
    hormones: StressHormoneState,
    amygdalaOutput: Float,
    deltaTime: Float
  ) : StressHormoneState {
    // Fast pathway: Adrenaline (sympathetic)
    let newAdrenaline = hormones.adrenaline * Float.exp(-deltaTime / TAU_ADRENALINE)
                       + amygdalaOutput * 0.5;
    
    // Norepinephrine (locus coeruleus)
    let newNoradrenaline = hormones.noradrenaline * Float.exp(-deltaTime / TAU_NOREPINEPHRINE)
                          + amygdalaOutput * 0.3;
    
    // HPA axis (slow pathway)
    // CRH from hypothalamus
    let crhIncrease = amygdalaOutput * 0.1;
    let newCRH = hormones.crh + crhIncrease - hormones.crh * 0.01;
    
    // ACTH from pituitary (delayed by ~5 min)
    let acthIncrease = hormones.crh * 0.05;  // Driven by CRH
    let newACTH = hormones.acth + acthIncrease - hormones.acth * 0.01;
    
    // Cortisol from adrenal cortex (delayed by ~15 min)
    let cortisolIncrease = hormones.acth * 0.03;
    let negativeFeedback = hormones.cortisol * CORTISOL_FEEDBACK;
    let newCortisol = hormones.cortisol + cortisolIncrease - negativeFeedback;
    
    // Allostatic load accumulation (chronic stress damage)
    let loadIncrease = if (newCortisol > 0.5) {
      (newCortisol - 0.5) * 0.001 * deltaTime
    } else { 0.0 };
    let newAllostaticLoad = hormones.allostaticLoad + loadIncrease;
    
    // Chronic stress tracking
    let alpha = 0.001;  // Slow integration
    let newChronicStress = hormones.chronicStressLevel * (1.0 - alpha) 
                          + newCortisol * alpha;
    
    {
      adrenaline = _clamp(newAdrenaline, 0.0, 2.0);
      noradrenaline = _clamp(newNoradrenaline, 0.0, 2.0);
      crh = _clamp(newCRH, 0.0, 1.0);
      acth = _clamp(newACTH, 0.0, 1.0);
      cortisol = _clamp(newCortisol, 0.0, 1.0);
      allostaticLoad = _clamp(newAllostaticLoad, 0.0, 10.0);
      lastStressor = if (amygdalaOutput > 0.3) { 0.0 } else { hormones.lastStressor + deltaTime };
      chronicStressLevel = _clamp(newChronicStress, 0.0, 1.0);
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA FEAR CONDITIONING (MFC)
  // ══════════════════════════════════════════════════════════════
  //
  // Pavlovian fear learning: CS-US association
  //
  public func medinaFearConditioning(
    conditionedStimulus: [Float],
    unconditionedStimulus: Float,  // US (e.g., pain)
    existingFears: [ConditionedFear],
    learningRate: Float
  ) : [ConditionedFear] {
    var updatedFears = Buffer.Buffer<ConditionedFear>(existingFears.size() + 1);
    var foundMatch = false;
    
    for (fear in existingFears.vals()) {
      // Check if CS matches existing fear
      var similarity : Float = 0.0;
      var i : Nat = 0;
      while (i < fear.stimulus.size() and i < conditionedStimulus.size()) {
        similarity += fear.stimulus[i] * conditionedStimulus[i];
        i += 1;
      };
      
      if (similarity > 0.8) {
        // Update existing fear
        foundMatch := true;
        let newStrength = fear.fearStrength + learningRate * 
                         (unconditionedStimulus - fear.fearStrength) *
                         Float.pow(PHI_MEDINA, fear.fearStrength - 1.0);
        
        updatedFears.add({
          stimulus = fear.stimulus;
          fearStrength = _clamp(newStrength, 0.0, 1.0);
          extinctionLevel = fear.extinctionLevel * 0.95;  // Extinction weakens
          lastActivation = 0.0;
          contextDependence = fear.contextDependence;
        });
      } else {
        updatedFears.add(fear);
      };
    };
    
    // Create new fear if no match found and US present
    if (not foundMatch and unconditionedStimulus > 0.3) {
      updatedFears.add({
        stimulus = conditionedStimulus;
        fearStrength = unconditionedStimulus * learningRate;
        extinctionLevel = 0.0;
        lastActivation = 0.0;
        contextDependence = 0.5;
      });
    };
    
    Buffer.toArray(updatedFears)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA FEAR EXTINCTION (MFE)
  // ══════════════════════════════════════════════════════════════
  //
  // Extinction = new inhibitory learning, not erasure
  //
  public func medinaFearExtinction(
    fear: ConditionedFear,
    csPresented: Bool,
    usAbsent: Bool,
    prefrontalActivity: Float,  // mPFC inhibition of amygdala
    extinctionRate: Float
  ) : ConditionedFear {
    if (csPresented and usAbsent) {
      // Extinction learning
      let extinctionIncrease = extinctionRate * prefrontalActivity *
                               Float.pow(PHI_MEDINA, -fear.extinctionLevel);
      
      let newExtinction = _clamp(fear.extinctionLevel + extinctionIncrease, 0.0, 1.0);
      
      // Fear strength is modulated by extinction
      // (Original fear trace remains but is inhibited)
      
      {
        stimulus = fear.stimulus;
        fearStrength = fear.fearStrength;  // Doesn't decrease!
        extinctionLevel = newExtinction;
        lastActivation = 0.0;
        contextDependence = fear.contextDependence;
      }
    } else {
      fear
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA FEAR RENEWAL (MFR)
  // ══════════════════════════════════════════════════════════════
  //
  // Fear returns in new context (extinction is context-specific)
  //
  public func medinaFearRenewal(
    fear: ConditionedFear,
    currentContext: [Float],
    extinctionContext: [Float]
  ) : Float {
    // Compute context similarity
    var similarity : Float = 0.0;
    var i : Nat = 0;
    while (i < currentContext.size() and i < extinctionContext.size()) {
      similarity += currentContext[i] * extinctionContext[i];
      i += 1;
    };
    
    // If in different context, extinction doesn't apply
    let contextMatch = _clamp(similarity, 0.0, 1.0);
    
    // Effective fear = original strength × (1 - extinction × context_match)
    let effectiveFear = fear.fearStrength * 
                        (1.0 - fear.extinctionLevel * contextMatch);
    
    // Medina renewal factor
    let renewalFactor = Float.pow(PHI_MEDINA, contextMatch - 1.0);
    
    _clamp(effectiveFear * renewalFactor, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA AMYGDALA UPDATE (MAU)
  // ══════════════════════════════════════════════════════════════
  public func medinaAmygdalaUpdate(
    amygdala: AmygdalaNuclei,
    sensoryInput: [Float],
    hippocampalContext: Float,
    prefrontalControl: Float,
    threatLevel: Float,
    deltaTime: Float
  ) : AmygdalaNuclei {
    // Lateral amygdala: threat detection
    let laActivation = medinaSigmoid(threatLevel * 2.0 - 0.5);
    
    // Basal amygdala: context integration
    let baActivation = laActivation * (0.5 + hippocampalContext * 0.5);
    
    // Central amygdala: output with prefrontal inhibition
    let ceaRaw = (laActivation + baActivation) / 2.0;
    let intercalatedInhibition = prefrontalControl * amygdala.intercalatedCells;
    let ceaActivation = _clamp(ceaRaw - intercalatedInhibition, 0.0, 1.0);
    
    // Behavioral outputs
    let freezeOut = ceaActivation * 0.8;
    let flightOut = ceaActivation * 0.6;
    let autonomicOut = ceaActivation * 0.9;
    
    {
      lateralAmygdala = {
        activation = laActivation;
        threatDetection = threatLevel;
        sensoryInput = sensoryInput;
        plasticWeights = amygdala.lateralAmygdala.plasticWeights;
        recentSpikes = amygdala.lateralAmygdala.recentSpikes;
      };
      basalAmygdala = {
        activation = baActivation;
        contextIntegration = hippocampalContext;
        hippocampalInput = hippocampalContext;
        prefrontalInput = prefrontalControl;
        valenceCoding = if (threatLevel > 0.5) { -1.0 } else { 0.0 };
      };
      centralAmygdala = {
        activation = ceaActivation;
        outputLevel = ceaActivation;
        medialDivision = ceaActivation * 0.9;
        lateralDivision = ceaActivation * 0.3;
        freezeOutput = freezeOut;
        flightOutput = flightOut;
        autonomicOutput = autonomicOut;
      };
      intercalatedCells = _clamp(amygdala.intercalatedCells + prefrontalControl * 0.01, 0.0, 1.0);
    }
  };

  // ══════════════════════════════════════════════════════════════
  // COMPLETE DEFENSE SYSTEM UPDATE
  // ══════════════════════════════════════════════════════════════
  public func updateDefenseSystem(
    state: FearState,
    stimulus: ThreatSignature,
    context: [Float],
    prefrontalControl: Float,
    deltaTime: Float
  ) : FearState {
    // 1. Detect threat (low + high road)
    let (lowRoadThreat, totalThreat) = medinaThreatDetection(
      stimulus, [], 1.0 - state.currentFear, 0.7
    );
    
    // 2. Update amygdala
    let newAmygdala = medinaAmygdalaUpdate(
      state.amygdala,
      stimulus.visualFeatures,
      0.5,  // hippocampal context
      prefrontalControl,
      totalThreat,
      deltaTime
    );
    
    // 3. Update fear level
    let extinctionSignal = prefrontalControl * state.extinctionProgress;
    let hormoneEffect = state.hormones.adrenaline + state.hormones.cortisol * 0.5;
    let newFear = medinaFearDynamics(
      state.currentFear,
      totalThreat,
      extinctionSignal,
      hormoneEffect,
      deltaTime
    );
    
    // 4. Update stress hormones
    let newHormones = medinaStressHormoneCascade(
      state.hormones,
      newAmygdala.centralAmygdala.outputLevel,
      deltaTime
    );
    
    // 5. Decide defensive behavior
    let (behavior, confidence) = medinaDefensiveDecision(
      newFear,
      stimulus.distance,
      0.5,  // escape route quality
      0.5,  // relative strength
      0.3,  // concealment
      0.2   // fatigue
    );
    
    // Compute behavior activations
    let (freezeAct, flightAct, fightAct) = switch (behavior) {
      case (#Freeze) { (confidence, 0.0, 0.0) };
      case (#Flight) { (0.0, confidence, 0.0) };
      case (#Fight) { (0.0, 0.0, confidence) };
      case _ { (0.0, 0.0, 0.0) };
    };
    
    // 6. Physiological responses
    let hrIncrease = newHormones.adrenaline * 50.0;  // bpm increase
    let breathRate = 12.0 + newHormones.adrenaline * 8.0;  // breaths/min
    let muscleReady = newHormones.noradrenaline * 0.8;
    let pupilDil = newHormones.noradrenaline * 0.6;
    
    {
      amygdala = newAmygdala;
      currentFear = newFear;
      conditionedFears = state.conditionedFears;
      freezeActivation = freezeAct;
      flightActivation = flightAct;
      fightActivation = fightAct;
      extinctionProgress = state.extinctionProgress;
      safetySignals = state.safetySignals;
      hormones = newHormones;
      heartRateIncrease = hrIncrease;
      breathingRate = breathRate;
      muscleReadiness = muscleReady;
      pupilDilation = pupilDil;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════
  public func initFearState() : FearState {
    {
      amygdala = {
        lateralAmygdala = {
          activation = 0.0;
          threatDetection = 0.0;
          sensoryInput = [];
          plasticWeights = [];
          recentSpikes = [];
        };
        basalAmygdala = {
          activation = 0.0;
          contextIntegration = 0.0;
          hippocampalInput = 0.0;
          prefrontalInput = 0.0;
          valenceCoding = 0.0;
        };
        centralAmygdala = {
          activation = 0.0;
          outputLevel = 0.0;
          medialDivision = 0.0;
          lateralDivision = 0.0;
          freezeOutput = 0.0;
          flightOutput = 0.0;
          autonomicOutput = 0.0;
        };
        intercalatedCells = 0.5;
      };
      currentFear = 0.0;
      conditionedFears = [];
      freezeActivation = 0.0;
      flightActivation = 0.0;
      fightActivation = 0.0;
      extinctionProgress = 0.0;
      safetySignals = [];
      hormones = {
        adrenaline = 0.0;
        noradrenaline = 0.0;
        crh = 0.0;
        acth = 0.0;
        cortisol = 0.1;  // Baseline cortisol
        allostaticLoad = 0.0;
        lastStressor = 10000.0;  // Long time ago
        chronicStressLevel = 0.0;
      };
      heartRateIncrease = 0.0;
      breathingRate = 12.0;
      muscleReadiness = 0.2;
      pupilDilation = 0.0;
    }
  };

}
