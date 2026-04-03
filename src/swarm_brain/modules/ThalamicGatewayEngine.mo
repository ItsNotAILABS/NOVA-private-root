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
// NEUROEMERGENCE CORE — THALAMIC GATEWAY ENGINE
// Sensory relay, attention gating, and cortico-thalamic loops
// 
// Biological basis:
// - Relay nuclei: LGN (vision), MGN (audition), VPL (somatosensory)
// - Reticular nucleus (TRN): Inhibitory gating
// - Pulvinar: Higher-order relay, attention
// - Intralaminar nuclei: Arousal, consciousness
// 
// Mathematical Framework:
// - Gating: y = x × g(attention, arousal)
// - Gain control: y = f(x) × (1 + α·attention)
// - Burst/tonic modes: determined by membrane potential/arousal
// - Corticothalamic feedback: modulates relay gain
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

  // Thalamic relay mode
  public type RelayMode = {
    #Tonic;          // Faithful relay, awake state
    #Burst;          // Rhythmic bursting, drowsy/sleep
    #Gated;          // Selective relay based on attention
  };

  // Single relay nucleus
  public type RelayNucleus = {
    name           : Text;
    sensoryInput   : [Float];      // Input from periphery/lower areas
    relayOutput    : [Float];      // Output to cortex
    gain           : Float;        // Current gain [0.1, 3.0]
    gateOpen       : Float;        // How open the gate is [0, 1]
    mode           : RelayMode;
    feedbackInput  : [Float];      // Corticothalamic feedback
    trnInhibition  : Float;        // Inhibition from reticular nucleus
    firingRate     : Float;        // Current firing rate
  };

  // Thalamic Reticular Nucleus (TRN) - inhibitory shell
  public type TRNState = {
    sectors        : [Float];      // Activity in different TRN sectors
    globalInhibition: Float;       // Overall inhibition level
    attentionFocus : Nat;          // Which sector is attention-enhanced
    oscillationPhase: Float;       // Sleep spindle phase
    burstProbability: Float;       // Likelihood of burst firing
  };

  // Pulvinar (higher-order, attention)
  public type PulvinarState = {
    activity       : [Float];      // Current activity pattern
    attentionMap   : [Float];      // Spatial attention weights
    saliencyIntegration: Float;    // Integrated saliency
    corticalBinding: Float;        // Cortico-cortical coordination
  };

  // Intralaminar nuclei (arousal, consciousness)
  public type IntralaminarState = {
    arousalSignal  : Float;        // Ascending arousal
    consciousnessGate: Float;      // Global workspace access
    painRelay      : Float;        // Nociceptive signals
    motorPreparation: Float;       // Motor readiness
  };

  // Full thalamic state
  public type ThalamusState = {
    // Specific relay nuclei
    visualRelay    : RelayNucleus;  // LGN
    auditoryRelay  : RelayNucleus;  // MGN
    somatoRelay    : RelayNucleus;  // VPL
    motorRelay     : RelayNucleus;  // VL/VA
    
    // Modulatory structures
    trn            : TRNState;
    pulvinar       : PulvinarState;
    intralaminar   : IntralaminarState;
    
    // Global state
    globalArousal  : Float;         // Overall arousal level
    sleepPressure  : Float;         // Drive toward sleep mode
    attentionBias  : [Float];       // Top-down attention
    
    // Oscillations
    alphaPhase     : Float;         // 8-12 Hz alpha rhythm
    spindlePhase   : Float;         // 12-15 Hz spindle rhythm
    
    // Parameters
    baselineGain   : Float;
    attentionGainBoost: Float;
    
    // Temporal
    beatNum        : Nat;
    lastModeSwitch : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let EPSILON : Float = 1e-10;
  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;
  
  // Gain parameters
  let MIN_GAIN : Float = 0.1;
  let MAX_GAIN : Float = 3.0;
  let BASELINE_GAIN : Float = 1.0;
  let ATTENTION_BOOST : Float = 0.5;
  
  // Mode thresholds
  let TONIC_THRESHOLD : Float = 0.6;    // Above this = tonic mode
  let BURST_THRESHOLD : Float = 0.3;    // Below this = burst mode

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

  func wrapPhase(p: Float) : Float {
    var phase = p;
    while (phase < 0.0) { phase += TWO_PI };
    while (phase >= TWO_PI) { phase -= TWO_PI };
    phase
  };

  // ══════════════════════════════════════════════════════════════
  // RELAY GATING
  // ══════════════════════════════════════════════════════════════

  // Compute gate opening based on attention and TRN inhibition
  // Gate = attention × (1 - TRN_inhibition) × arousal
  public func computeGateOpening(
    attention: Float,
    trnInhibition: Float,
    arousal: Float
  ) : Float {
    let gate = attention * (1.0 - trnInhibition) * arousal;
    _clamp(gate, 0.0, 1.0)
  };

  // Compute relay gain
  // Gain = baseline × (1 + attention_boost × attention) × arousal_factor
  public func computeRelayGain(
    baselineGain: Float,
    attentionBoost: Float,
    attention: Float,
    arousal: Float,
    feedback: Float
  ) : Float {
    let arousalFactor = 0.5 + arousal * 0.5;  // 0.5 to 1.0
    let feedbackFactor = 1.0 + feedback * 0.3;  // Feedback enhances gain
    let gain = baselineGain * (1.0 + attentionBoost * attention) * arousalFactor * feedbackFactor;
    _clamp(gain, MIN_GAIN, MAX_GAIN)
  };

  // Determine relay mode based on arousal
  public func determineRelayMode(arousal: Float, sleepPressure: Float) : RelayMode {
    let effectiveArousal = arousal * (1.0 - sleepPressure * 0.5);
    
    if (effectiveArousal > TONIC_THRESHOLD) {
      #Tonic
    } else if (effectiveArousal < BURST_THRESHOLD) {
      #Burst
    } else {
      #Gated
    }
  };

  // ══════════════════════════════════════════════════════════════
  // RELAY NUCLEUS UPDATE
  // ══════════════════════════════════════════════════════════════

  // Process sensory input through relay nucleus
  public func relayInput(
    nucleus: RelayNucleus,
    sensoryInput: [Float],
    attention: Float,
    corticalFeedback: [Float],
    trnInhibition: Float,
    arousal: Float
  ) : RelayNucleus {
    // Compute gate opening
    let gateOpen = computeGateOpening(attention, trnInhibition, arousal);
    
    // Compute gain
    let avgFeedback = if (corticalFeedback.size() > 0) {
      var sum : Float = 0.0;
      for (f in corticalFeedback.vals()) { sum += f };
      sum / Float.fromInt(corticalFeedback.size())
    } else { 0.0 };
    
    let gain = computeRelayGain(
      BASELINE_GAIN,
      ATTENTION_BOOST,
      attention,
      arousal,
      avgFeedback
    );
    
    // Determine mode
    let mode = determineRelayMode(arousal, 0.0);
    
    // Process input through gate and gain
    let relayOutput = Array.tabulate<Float>(sensoryInput.size(), func(i) {
      let input = if (i < sensoryInput.size()) { sensoryInput[i] } else { 0.0 };
      
      switch (mode) {
        case (#Tonic) {
          // Faithful relay with gain
          _clamp(input * gain * gateOpen, 0.0, 1.0)
        };
        case (#Burst) {
          // Bursty relay - enhanced transients
          let transient = if (_abs(input) > 0.3) { 1.5 } else { 0.5 };
          _clamp(input * gain * transient * gateOpen, 0.0, 1.0)
        };
        case (#Gated) {
          // Selective relay
          _clamp(input * gain * gateOpen, 0.0, 1.0)
        };
      }
    });
    
    // Compute firing rate
    var sumOutput : Float = 0.0;
    for (o in relayOutput.vals()) { sumOutput += o };
    let firingRate = sumOutput / Float.fromInt(Nat.max(relayOutput.size(), 1));
    
    {
      name = nucleus.name;
      sensoryInput = sensoryInput;
      relayOutput = relayOutput;
      gain = gain;
      gateOpen = gateOpen;
      mode = mode;
      feedbackInput = corticalFeedback;
      trnInhibition = trnInhibition;
      firingRate = firingRate;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THALAMIC RETICULAR NUCLEUS (TRN)
  // ══════════════════════════════════════════════════════════════

  // Update TRN - inhibitory control of relay nuclei
  public func updateTRN(
    trn: TRNState,
    relayActivities: [Float],
    attentionFocus: Nat,
    arousal: Float
  ) : TRNState {
    // TRN sectors respond to relay activity
    let newSectors = Array.tabulate<Float>(relayActivities.size(), func(i) {
      let relayActivity = if (i < relayActivities.size()) { relayActivities[i] } else { 0.0 };
      
      // Attention suppresses TRN at focused sector
      let attentionMod = if (i == attentionFocus) { 0.5 } else { 1.0 };
      
      // TRN inhibition increases with relay activity (feedback inhibition)
      _clamp(relayActivity * 0.5 * attentionMod, 0.0, 1.0)
    });
    
    // Global inhibition
    var sumSectors : Float = 0.0;
    for (s in newSectors.vals()) { sumSectors += s };
    let globalInhibition = sumSectors / Float.fromInt(Nat.max(newSectors.size(), 1));
    
    // Spindle oscillation (low arousal promotes spindles)
    let newPhase = wrapPhase(trn.oscillationPhase + 0.1 * (1.0 - arousal));
    
    // Burst probability increases with low arousal
    let burstProb = (1.0 - arousal) * 0.5;
    
    {
      sectors = newSectors;
      globalInhibition = globalInhibition;
      attentionFocus = attentionFocus;
      oscillationPhase = newPhase;
      burstProbability = burstProb;
    }
  };

  // Get TRN inhibition for specific relay
  public func getTRNInhibition(trn: TRNState, relayIndex: Nat) : Float {
    if (relayIndex < trn.sectors.size()) {
      trn.sectors[relayIndex]
    } else {
      trn.globalInhibition
    }
  };

  // ══════════════════════════════════════════════════════════════
  // PULVINAR (Higher-order attention)
  // ══════════════════════════════════════════════════════════════

  // Update pulvinar - attention coordination
  public func updatePulvinar(
    pulvinar: PulvinarState,
    visualInput: [Float],
    attentionSignal: [Float],
    saliencyMap: [Float]
  ) : PulvinarState {
    // Integrate visual input with attention
    let newActivity = Array.tabulate<Float>(
      Nat.max(visualInput.size(), attentionSignal.size()),
      func(i) {
        let vis = if (i < visualInput.size()) { visualInput[i] } else { 0.0 };
        let att = if (i < attentionSignal.size()) { attentionSignal[i] } else { 0.5 };
        _clamp(vis * att, 0.0, 1.0)
      }
    );
    
    // Update attention map
    let newAttentionMap = Array.tabulate<Float>(attentionSignal.size(), func(i) {
      let current = if (i < pulvinar.attentionMap.size()) { pulvinar.attentionMap[i] } else { 0.0 };
      let target = if (i < attentionSignal.size()) { attentionSignal[i] } else { 0.0 };
      current * 0.8 + target * 0.2  // Smooth updating
    });
    
    // Integrate saliency
    var saliencySum : Float = 0.0;
    for (s in saliencyMap.vals()) { saliencySum += s };
    let saliencyIntegration = saliencySum / Float.fromInt(Nat.max(saliencyMap.size(), 1));
    
    // Cortical binding: high when attention is focused
    var attentionFocus : Float = 0.0;
    for (a in newAttentionMap.vals()) {
      if (a > attentionFocus) { attentionFocus := a };
    };
    let corticalBinding = attentionFocus;
    
    {
      activity = newActivity;
      attentionMap = newAttentionMap;
      saliencyIntegration = saliencyIntegration;
      corticalBinding = corticalBinding;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INTRALAMINAR NUCLEI (Arousal, consciousness)
  // ══════════════════════════════════════════════════════════════

  // Update intralaminar nuclei
  public func updateIntralaminar(
    intralaminar: IntralaminarState,
    brainstemInput: Float,
    painInput: Float,
    motorPrep: Float
  ) : IntralaminarState {
    // Arousal signal from brainstem
    let newArousal = intralaminar.arousalSignal * 0.9 + brainstemInput * 0.1;
    
    // Consciousness gate: open when arousal is sufficient
    let consciousnessGate = if (newArousal > 0.4) {
      _clamp(newArousal * 1.2, 0.0, 1.0)
    } else { 0.0 };
    
    // Pain relay (always active if pain present)
    let painRelay = _clamp(painInput, 0.0, 1.0);
    
    // Motor preparation
    let motorPreparation = intralaminar.motorPreparation * 0.8 + motorPrep * 0.2;
    
    {
      arousalSignal = newArousal;
      consciousnessGate = consciousnessGate;
      painRelay = painRelay;
      motorPreparation = motorPreparation;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // OSCILLATIONS
  // ══════════════════════════════════════════════════════════════

  // Update alpha rhythm (8-12 Hz) - linked to attention
  public func updateAlphaPhase(phase: Float, attention: Float) : Float {
    // Alpha suppressed by attention
    let frequency = 10.0 * (1.0 - attention * 0.3);  // Hz
    wrapPhase(phase + TWO_PI * frequency * 0.001)  // Assuming ~1ms beat
  };

  // Update spindle rhythm (12-15 Hz) - sleep/NREM
  public func updateSpindlePhase(phase: Float, arousal: Float) : Float {
    // Spindles prominent during low arousal
    let amplitude = 1.0 - arousal;
    if (amplitude > 0.3) {
      wrapPhase(phase + TWO_PI * 13.0 * 0.001)
    } else { phase }
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type ThalamusInput = {
    visualInput      : [Float];
    auditoryInput    : [Float];
    somatosensoryInput: [Float];
    motorInput       : [Float];
    corticalFeedback : [Float];     // From cortex back to thalamus
    attentionSignal  : [Float];     // Attention weights per modality
    attentionFocusIdx: Nat;         // Which modality is attended
    brainstemArousal : Float;       // Arousal from brainstem
    painInput        : Float;
    motorPreparation : Float;
    saliencyMap      : [Float];
  };

  public func beatThalamus(
    state: ThalamusState,
    input: ThalamusInput
  ) : ThalamusState {
    
    // 1. Update intralaminar first (arousal)
    let newIntralaminar = updateIntralaminar(
      state.intralaminar,
      input.brainstemArousal,
      input.painInput,
      input.motorPreparation
    );
    
    let globalArousal = newIntralaminar.arousalSignal;
    
    // 2. Update TRN with relay activities
    let relayActivities = [
      state.visualRelay.firingRate,
      state.auditoryRelay.firingRate,
      state.somatoRelay.firingRate,
      state.motorRelay.firingRate
    ];
    
    let newTRN = updateTRN(
      state.trn,
      relayActivities,
      input.attentionFocusIdx,
      globalArousal
    );
    
    // 3. Get attention for each modality
    let visualAttention = if (input.attentionSignal.size() > 0) { input.attentionSignal[0] } else { 0.5 };
    let auditoryAttention = if (input.attentionSignal.size() > 1) { input.attentionSignal[1] } else { 0.5 };
    let somatoAttention = if (input.attentionSignal.size() > 2) { input.attentionSignal[2] } else { 0.5 };
    let motorAttention = if (input.attentionSignal.size() > 3) { input.attentionSignal[3] } else { 0.5 };
    
    // 4. Update relay nuclei
    let newVisualRelay = relayInput(
      state.visualRelay,
      input.visualInput,
      visualAttention,
      input.corticalFeedback,
      getTRNInhibition(newTRN, 0),
      globalArousal
    );
    
    let newAuditoryRelay = relayInput(
      state.auditoryRelay,
      input.auditoryInput,
      auditoryAttention,
      input.corticalFeedback,
      getTRNInhibition(newTRN, 1),
      globalArousal
    );
    
    let newSomatoRelay = relayInput(
      state.somatoRelay,
      input.somatosensoryInput,
      somatoAttention,
      input.corticalFeedback,
      getTRNInhibition(newTRN, 2),
      globalArousal
    );
    
    let newMotorRelay = relayInput(
      state.motorRelay,
      input.motorInput,
      motorAttention,
      input.corticalFeedback,
      getTRNInhibition(newTRN, 3),
      globalArousal
    );
    
    // 5. Update pulvinar
    let newPulvinar = updatePulvinar(
      state.pulvinar,
      input.visualInput,
      input.attentionSignal,
      input.saliencyMap
    );
    
    // 6. Update oscillations
    let newAlphaPhase = updateAlphaPhase(state.alphaPhase, visualAttention);
    let newSpindlePhase = updateSpindlePhase(state.spindlePhase, globalArousal);
    
    // 7. Update sleep pressure
    let newSleepPressure = if (globalArousal < 0.3) {
      _clamp(state.sleepPressure + 0.01, 0.0, 1.0)
    } else {
      _clamp(state.sleepPressure - 0.005, 0.0, 1.0)
    };
    
    {
      visualRelay = newVisualRelay;
      auditoryRelay = newAuditoryRelay;
      somatoRelay = newSomatoRelay;
      motorRelay = newMotorRelay;
      trn = newTRN;
      pulvinar = newPulvinar;
      intralaminar = newIntralaminar;
      globalArousal = globalArousal;
      sleepPressure = newSleepPressure;
      attentionBias = input.attentionSignal;
      alphaPhase = newAlphaPhase;
      spindlePhase = newSpindlePhase;
      baselineGain = state.baselineGain;
      attentionGainBoost = state.attentionGainBoost;
      beatNum = state.beatNum + 1;
      lastModeSwitch = state.lastModeSwitch;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ══════════════════════════════════════════════════════════════

  // Get combined sensory output (gated relay to cortex)
  public func getSensoryOutput(state: ThalamusState) : [Float] {
    var output : [Float] = [];
    output := Array.append(output, state.visualRelay.relayOutput);
    output := Array.append(output, state.auditoryRelay.relayOutput);
    output := Array.append(output, state.somatoRelay.relayOutput);
    output
  };

  // Is consciousness gate open?
  public func isConsciousnessGateOpen(state: ThalamusState) : Bool {
    state.intralaminar.consciousnessGate > 0.5 and state.globalArousal > 0.4
  };

  // Get dominant relay mode
  public func getDominantMode(state: ThalamusState) : RelayMode {
    // Check mode of most active relay
    let relays = [
      (state.visualRelay.firingRate, state.visualRelay.mode),
      (state.auditoryRelay.firingRate, state.auditoryRelay.mode),
      (state.somatoRelay.firingRate, state.somatoRelay.mode)
    ];
    
    var maxRate : Float = 0.0;
    var dominantMode : RelayMode = #Gated;
    
    for ((rate, mode) in relays.vals()) {
      if (rate > maxRate) {
        maxRate := rate;
        dominantMode := mode;
      };
    };
    
    dominantMode
  };

  // Create relay nucleus
  func createRelayNucleus(name: Text, size: Nat) : RelayNucleus {
    {
      name = name;
      sensoryInput = Array.tabulate<Float>(size, func(_) { 0.0 });
      relayOutput = Array.tabulate<Float>(size, func(_) { 0.0 });
      gain = BASELINE_GAIN;
      gateOpen = 0.5;
      mode = #Tonic;
      feedbackInput = [];
      trnInhibition = 0.0;
      firingRate = 0.0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initThalamus(inputSize: Nat) : ThalamusState {
    {
      visualRelay = createRelayNucleus("LGN", inputSize);
      auditoryRelay = createRelayNucleus("MGN", inputSize);
      somatoRelay = createRelayNucleus("VPL", inputSize);
      motorRelay = createRelayNucleus("VL", inputSize);
      trn = {
        sectors = Array.tabulate<Float>(4, func(_) { 0.0 });
        globalInhibition = 0.0;
        attentionFocus = 0;
        oscillationPhase = 0.0;
        burstProbability = 0.0;
      };
      pulvinar = {
        activity = [];
        attentionMap = [];
        saliencyIntegration = 0.0;
        corticalBinding = 0.0;
      };
      intralaminar = {
        arousalSignal = 0.5;
        consciousnessGate = 0.5;
        painRelay = 0.0;
        motorPreparation = 0.0;
      };
      globalArousal = 0.5;
      sleepPressure = 0.0;
      attentionBias = [];
      alphaPhase = 0.0;
      spindlePhase = 0.0;
      baselineGain = BASELINE_GAIN;
      attentionGainBoost = ATTENTION_BOOST;
      beatNum = 0;
      lastModeSwitch = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type ThalamusSummary = {
    globalArousal       : Float;
    consciousnessGate   : Float;
    visualGain          : Float;
    auditoryGain        : Float;
    somatoGain          : Float;
    trnInhibition       : Float;
    dominantMode        : Text;
    sleepPressure       : Float;
    pulvinarBinding     : Float;
  };

  public func summary(state: ThalamusState) : ThalamusSummary {
    let modeText = switch (getDominantMode(state)) {
      case (#Tonic) { "Tonic" };
      case (#Burst) { "Burst" };
      case (#Gated) { "Gated" };
    };
    
    {
      globalArousal = state.globalArousal;
      consciousnessGate = state.intralaminar.consciousnessGate;
      visualGain = state.visualRelay.gain;
      auditoryGain = state.auditoryRelay.gain;
      somatoGain = state.somatoRelay.gain;
      trnInhibition = state.trn.globalInhibition;
      dominantMode = modeText;
      sleepPressure = state.sleepPressure;
      pulvinarBinding = state.pulvinar.corticalBinding;
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

}
