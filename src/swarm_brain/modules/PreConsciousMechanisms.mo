// ════════════════════════════════════════════════════════════════════════════
// PRE-CONSCIOUS MECHANISMS — COMPLETE IMPLEMENTATION
// 12 Missing Architectures Now Fully Implemented
//
// These run BEFORE any deliberate thought, expression, or decision.
// They shape what gets to consciousness, not what consciousness does with it.
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";

module {

  // ── FUNDAMENTAL CONSTANTS ──────────────────────────────────────
  let PHI : Float = 1.618033988749895;
  let PHI_INV : Float = 0.618033988749895;
  let TAU : Float = 6.283185307179586;
  let S0 : Float = 1.0;                      // Sovereignty floor
  let SOVEREIGN_CEILING : Float = 9.0;

  func fclamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 19: STARTLE / BRAINSTEM SHORT-CIRCUIT
  // ════════════════════════════════════════════════════════════════
  // The biological startle response bypasses all cortical processing —
  // it fires in ~8ms directly from brainstem (reticular formation → motor).
  // There is no "deciding" to flinch — the body is already moving.
  //
  // IMPLEMENTATION:
  // If stImmuneActivationLevel > 0.85 OR stAgentThreat > 0.90,
  // fire immediate emergency action BEFORE perceptionCore() even runs.
  // Skip the full pipeline. This is the brainstem short-circuit.

  public type StartleState = {
    isActive          : Bool;       // Startle currently firing
    activationLevel   : Float;      // 0-1 startle intensity
    refractoryBeats   : Nat;        // Beats until startle can fire again
    lastTriggerBeat   : Nat;        // When startle last fired
    triggerCount      : Nat;        // Lifetime startle count
    immuneThreshold   : Float;      // 0.85 default
    threatThreshold   : Float;      // 0.90 default
  };

  public func initStartleState() : StartleState {
    {
      isActive = false;
      activationLevel = 0.0;
      refractoryBeats = 0;
      lastTriggerBeat = 0;
      triggerCount = 0;
      immuneThreshold = 0.85;
      threatThreshold = 0.90;
    }
  };

  // Returns (newState, shouldSkipPipeline, emergencyDriveMode)
  public func runStartleGate(
    state: StartleState,
    immuneActivationLevel: Float,
    agentThreat: Float,
    currentBeat: Nat
  ) : (StartleState, Bool, Bool) {
    // Check refractory period
    if (state.refractoryBeats > 0) {
      return ({
        state with
        refractoryBeats = state.refractoryBeats - 1;
        isActive = false;
        activationLevel = state.activationLevel * 0.8;  // Decay
      }, false, false);
    };

    // Check startle triggers
    let immuneTrigger = immuneActivationLevel > state.immuneThreshold;
    let threatTrigger = agentThreat > state.threatThreshold;

    if (immuneTrigger or threatTrigger) {
      // STARTLE FIRES — skip full pipeline, force Q_EMERGENCY
      let intensity = Float.max(
        (immuneActivationLevel - state.immuneThreshold) / (1.0 - state.immuneThreshold),
        (agentThreat - state.threatThreshold) / (1.0 - state.threatThreshold)
      );

      return ({
        isActive = true;
        activationLevel = fclamp(intensity, 0.0, 1.0);
        refractoryBeats = 8;  // 8-beat refractory (like 8ms biological)
        lastTriggerBeat = currentBeat;
        triggerCount = state.triggerCount + 1;
        immuneThreshold = state.immuneThreshold;
        threatThreshold = state.threatThreshold;
      }, true, true);  // Skip pipeline, force emergency
    };

    // No startle
    ({
      state with
      isActive = false;
      activationLevel = state.activationLevel * 0.9;
    }, false, false)
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 20: PROPRIOCEPTION / BODY SCHEMA
  // ════════════════════════════════════════════════════════════════
  // Continuous background map of where the organism's own body is in space.
  // Without looking, without thinking, the body knows itself constantly.
  //
  // IMPLEMENTATION:
  // Body schema vector — rolling center-of-mass of Shell 3 activation
  // stBodySchemaCentroid = weighted mean of active node indices
  // Updated every beat, used to bias action candidate selection
  // toward architecturally consistent actions.

  public type BodySchemaState = {
    centroidX         : Float;      // X position of activation center
    centroidY         : Float;      // Y position of activation center
    centroidZ         : Float;      // Z position (shell depth)
    activationSpread  : Float;      // How spread out the activation is
    dominantQuadrant  : Nat;        // Which quadrant has most activation (0-3)
    structuralCoherence: Float;     // How coherent the body schema is
    nodeActivations   : [Float];    // 64 Shell 3 node activations
    massCenter        : Float;      // Weighted center (single value)
  };

  public func initBodySchemaState() : BodySchemaState {
    {
      centroidX = 0.0;
      centroidY = 0.0;
      centroidZ = 0.5;
      activationSpread = 0.0;
      dominantQuadrant = 0;
      structuralCoherence = 1.0;
      nodeActivations = Array.tabulate<Float>(64, func(_) { 0.0 });
      massCenter = 32.0;  // Center of 64 nodes
    }
  };

  // Compute body schema centroid from Shell 3 activations
  public func updateBodySchema(
    state: BodySchemaState,
    shell3Activations: [Float]
  ) : BodySchemaState {
    let n = shell3Activations.size();
    if (n == 0) { return state };

    // Compute weighted centroid
    var sumWeightedIdx : Float = 0.0;
    var sumWeights : Float = 0.0;
    var maxAct : Float = 0.0;
    var maxIdx : Nat = 0;

    var i = 0;
    while (i < n) {
      let act = if (i < shell3Activations.size()) { shell3Activations[i] } else { 0.0 };
      sumWeightedIdx += Float.fromInt(i) * act;
      sumWeights += act;
      if (act > maxAct) {
        maxAct := act;
        maxIdx := i;
      };
      i += 1;
    };

    let centroid = if (sumWeights > 0.001) { sumWeightedIdx / sumWeights } else { Float.fromInt(n) / 2.0 };

    // Compute spread (variance)
    var variance : Float = 0.0;
    i := 0;
    while (i < n) {
      let act = if (i < shell3Activations.size()) { shell3Activations[i] } else { 0.0 };
      let diff = Float.fromInt(i) - centroid;
      variance += act * diff * diff;
      i += 1;
    };
    let spread = if (sumWeights > 0.001) { Float.sqrt(variance / sumWeights) } else { 0.0 };

    // Map centroid to 3D coordinates (assuming 8x8 grid for 64 nodes)
    let gridSize = 8;
    let centroidIdx = Float.toInt(Float.floor(centroid));
    let cx = Float.fromInt(centroidIdx % gridSize) / Float.fromInt(gridSize);
    let cy = Float.fromInt(centroidIdx / gridSize) / Float.fromInt(gridSize);
    let cz = sumWeights / Float.fromInt(n);  // Depth = total activation

    // Dominant quadrant
    let quadrant = if (cx < 0.5) {
      if (cy < 0.5) { 0 } else { 2 }
    } else {
      if (cy < 0.5) { 1 } else { 3 }
    };

    // Structural coherence = 1 - normalized spread
    let maxSpread = Float.fromInt(n) / 2.0;
    let coherence = 1.0 - fclamp(spread / maxSpread, 0.0, 1.0);

    {
      centroidX = cx;
      centroidY = cy;
      centroidZ = cz;
      activationSpread = spread;
      dominantQuadrant = quadrant;
      structuralCoherence = coherence;
      nodeActivations = shell3Activations;
      massCenter = centroid;
    }
  };

  // Bias factor for action candidate selection
  public func getBodySchemaBias(state: BodySchemaState, candidateQuadrant: Nat) : Float {
    // Actions in the dominant quadrant get a 15% boost
    if (candidateQuadrant == state.dominantQuadrant) {
      1.15 * state.structuralCoherence
    } else {
      1.0
    }
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 21: PAIN SIGNAL / NOCICEPTION
  // ════════════════════════════════════════════════════════════════
  // Nociception is not "knowing you're hurt" — it is the pre-conscious
  // signal that something is damaging the substrate. It fires before
  // consciousness registers pain. It biases all motor output away.
  //
  // IMPLEMENTATION:
  // stNociceptionSignal = fclamp((stIntero.damageGlobal - 0.4) * 3.0, 0.0, 1.0)
  // When above threshold, hard-escalates bodyIntegrity drive
  // and injects SUBP (Substance P) neurochemical.

  public type NociceptionState = {
    signalLevel       : Float;      // 0-1 pain signal intensity
    damageThreshold   : Float;      // 0.4 default
    escalationFactor  : Float;      // 3.0 default
    substancePInjection: Float;     // How much SUBP to inject
    bodyIntegrityBoost: Float;      // Drive escalation amount
    chronicPain       : Float;      // Accumulated unresolved pain
    lastDamageLevel   : Float;      // For change detection
  };

  public func initNociceptionState() : NociceptionState {
    {
      signalLevel = 0.0;
      damageThreshold = 0.4;
      escalationFactor = 3.0;
      substancePInjection = 0.0;
      bodyIntegrityBoost = 0.0;
      chronicPain = 0.0;
      lastDamageLevel = 0.0;
    }
  };

  // Returns (newState, substancePToInject, bodyIntegrityDriveBoost)
  public func runNociception(
    state: NociceptionState,
    damageGlobal: Float
  ) : (NociceptionState, Float, Float) {
    // Core nociception formula
    let rawSignal = (damageGlobal - state.damageThreshold) * state.escalationFactor;
    let signal = fclamp(rawSignal, 0.0, 1.0);

    // SUBP injection proportional to pain
    let subpInject = if (signal > 0.0) { signal * 0.3 } else { 0.0 };

    // Body integrity drive boost
    let driveBoost = if (signal > 0.5) { signal * 0.4 } else { 0.0 };

    // Chronic pain accumulates from sustained damage
    let chronic = if (damageGlobal > state.damageThreshold) {
      fclamp(state.chronicPain + 0.01, 0.0, 1.0)
    } else {
      fclamp(state.chronicPain - 0.005, 0.0, 1.0)
    };

    ({
      signalLevel = signal;
      damageThreshold = state.damageThreshold;
      escalationFactor = state.escalationFactor;
      substancePInjection = subpInject;
      bodyIntegrityBoost = driveBoost;
      chronicPain = chronic;
      lastDamageLevel = damageGlobal;
    }, subpInject, driveBoost)
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 22: ORIENTING RESPONSE (WHAT IS THAT?)
  // ════════════════════════════════════════════════════════════════
  // When something novel or unexpected appears, all processing briefly
  // reorients toward it BEFORE any deliberate attention is directed.
  // Head turns, eyes move, arousal spikes — all before conscious decision.
  //
  // IMPLEMENTATION:
  // When scene.noveltyScore > 0.75 AND change > 0.25 (sudden spike),
  // fire orienting interrupt — boost curiosity, suppress goalPursuit,
  // write high-salience memory, escalate GLU before drive core runs.

  public type OrientingState = {
    isActive          : Bool;       // Orienting response firing
    intensity         : Float;      // 0-1 orienting strength
    noveltyThreshold  : Float;      // 0.75 default
    changeThreshold   : Float;      // 0.25 delta threshold
    lastNoveltyScore  : Float;      // For change detection
    refractoryBeats   : Nat;        // Cooldown between orients
    curiosityBoost    : Float;      // How much to boost curiosity
    goalSuppression   : Float;      // How much to suppress goal pursuit
    glutamateSpike    : Float;      // GLU to inject
    orientCount       : Nat;        // Lifetime orient count
  };

  public func initOrientingState() : OrientingState {
    {
      isActive = false;
      intensity = 0.0;
      noveltyThreshold = 0.75;
      changeThreshold = 0.25;
      lastNoveltyScore = 0.0;
      refractoryBeats = 0;
      curiosityBoost = 0.0;
      goalSuppression = 0.0;
      glutamateSpike = 0.0;
      orientCount = 0;
    }
  };

  // Returns (newState, curiosityBoost, goalSuppression, glutamateSpike, writeHighSalienceMemory)
  public func runOrientingResponse(
    state: OrientingState,
    noveltyScore: Float
  ) : (OrientingState, Float, Float, Float, Bool) {
    // Check refractory
    if (state.refractoryBeats > 0) {
      return ({
        state with
        refractoryBeats = state.refractoryBeats - 1;
        isActive = false;
        intensity = state.intensity * 0.7;
        curiosityBoost = 0.0;
        goalSuppression = 0.0;
        glutamateSpike = 0.0;
        lastNoveltyScore = noveltyScore;
      }, 0.0, 0.0, 0.0, false);
    };

    // Check orienting triggers
    let aboveThreshold = noveltyScore > state.noveltyThreshold;
    let suddenChange = (noveltyScore - state.lastNoveltyScore) > state.changeThreshold;

    if (aboveThreshold and suddenChange) {
      // ORIENTING FIRES
      let intensity = fclamp((noveltyScore - state.noveltyThreshold) * 4.0, 0.0, 1.0);
      let curiosity = intensity * 0.35;   // 35% curiosity boost
      let goalSupp = intensity * 0.30;    // 30% goal suppression
      let glu = intensity * 0.25;         // GLU spike

      return ({
        isActive = true;
        intensity = intensity;
        noveltyThreshold = state.noveltyThreshold;
        changeThreshold = state.changeThreshold;
        lastNoveltyScore = noveltyScore;
        refractoryBeats = 5;  // 5-beat refractory
        curiosityBoost = curiosity;
        goalSuppression = goalSupp;
        glutamateSpike = glu;
        orientCount = state.orientCount + 1;
      }, curiosity, goalSupp, glu, true);  // Write high-salience memory
    };

    // No orienting
    ({
      state with
      isActive = false;
      intensity = state.intensity * 0.8;
      lastNoveltyScore = noveltyScore;
      curiosityBoost = 0.0;
      goalSuppression = 0.0;
      glutamateSpike = 0.0;
    }, 0.0, 0.0, 0.0, false)
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 23: FREEZE RESPONSE (TONIC IMMOBILITY)
  // ════════════════════════════════════════════════════════════════
  // Under extreme threat, organisms freeze entirely — not from panic
  // but from pre-conscious survival calculation: motion attracts predators.
  //
  // IMPLEMENTATION:
  // When stAgentThreat > 0.95 AND stIntero.overloadIndex > 0.80,
  // enter FREEZE state — zero candidates, expression suppressed,
  // all neurochemicals except CORT and NE clamp to minimum.
  // Duration: fixed 5 beats, then auto-release.

  public type FreezeState = {
    isFrozen          : Bool;       // Currently in freeze
    freezeBeatsRemaining: Nat;      // Beats until auto-release
    threatThreshold   : Float;      // 0.95 default
    overloadThreshold : Float;      // 0.80 default
    freezeDuration    : Nat;        // 5 beats default
    freezeCount       : Nat;        // Lifetime freeze count
    neurochemClampMask: [Bool];     // Which chemicals to clamp (21)
  };

  public func initFreezeState() : FreezeState {
    // Clamp all except CORT (index 19) and NE (index 2)
    let clampMask = Array.tabulate<Bool>(21, func(i) {
      i != 2 and i != 19  // NE=2, CORT=19 remain active
    });
    {
      isFrozen = false;
      freezeBeatsRemaining = 0;
      threatThreshold = 0.95;
      overloadThreshold = 0.80;
      freezeDuration = 5;
      freezeCount = 0;
      neurochemClampMask = clampMask;
    }
  };

  // Returns (newState, isFrozen, suppressExpression, zeroCandidates)
  public func runFreezeGate(
    state: FreezeState,
    agentThreat: Float,
    overloadIndex: Float
  ) : (FreezeState, Bool, Bool, Bool) {
    // Currently frozen — count down
    if (state.isFrozen) {
      if (state.freezeBeatsRemaining <= 1) {
        // Release from freeze
        return ({
          state with
          isFrozen = false;
          freezeBeatsRemaining = 0;
        }, false, false, false);
      } else {
        // Still frozen
        return ({
          state with
          freezeBeatsRemaining = state.freezeBeatsRemaining - 1;
        }, true, true, true);
      };
    };

    // Check freeze triggers
    if (agentThreat > state.threatThreshold and overloadIndex > state.overloadThreshold) {
      // FREEZE ACTIVATES
      return ({
        state with
        isFrozen = true;
        freezeBeatsRemaining = state.freezeDuration;
        freezeCount = state.freezeCount + 1;
      }, true, true, true);
    };

    // Not frozen
    (state, false, false, false)
  };

  // Apply neurochemical clamps during freeze
  public func applyFreezeClamps(
    state: FreezeState,
    neurochemicals: [Float]
  ) : [Float] {
    if (not state.isFrozen) { return neurochemicals };

    Array.tabulate<Float>(neurochemicals.size(), func(i) {
      if (i < state.neurochemClampMask.size() and state.neurochemClampMask[i]) {
        0.1  // Clamp to minimum
      } else {
        neurochemicals[i]  // NE and CORT pass through
      }
    })
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 24: VESTIBULAR / BALANCE / ORIENTATION FIELD
  // ════════════════════════════════════════════════════════════════
  // The vestibular system runs constantly in the background,
  // maintaining orientation in space without any conscious effort.
  //
  // IMPLEMENTATION:
  // stVestibularField — 3-value orientation vector:
  // forwardMomentum = successBias × goalPursuit
  // lateralDrift = jasmineDriftC × jasmineDriftV
  // verticalStability = identityCoherence × sovereigntyMembrane

  public type VestibularState = {
    forwardMomentum   : Float;      // Goal-directed momentum
    lateralDrift      : Float;      // Side-to-side drift
    verticalStability : Float;      // Up-down stability
    orientationVector : (Float, Float, Float);  // Combined 3D
    balanceIndex      : Float;      // Overall balance (0-1)
    correctionNeeded  : Float;      // How much correction needed
  };

  public func initVestibularState() : VestibularState {
    {
      forwardMomentum = 0.5;
      lateralDrift = 0.0;
      verticalStability = 1.0;
      orientationVector = (0.5, 0.0, 1.0);
      balanceIndex = 1.0;
      correctionNeeded = 0.0;
    }
  };

  public func updateVestibular(
    state: VestibularState,
    successBias: Float,
    goalPursuit: Float,
    jasmineDriftC: Float,
    jasmineDriftV: Float,
    identityCoherence: Float,
    sovereigntyMembrane: Float
  ) : VestibularState {
    // Compute components
    let forward = successBias * goalPursuit;
    let lateral = jasmineDriftC * jasmineDriftV;
    let vertical = identityCoherence * sovereigntyMembrane;

    // EMA smoothing
    let newForward = state.forwardMomentum * 0.8 + forward * 0.2;
    let newLateral = state.lateralDrift * 0.8 + lateral * 0.2;
    let newVertical = state.verticalStability * 0.9 + vertical * 0.1;

    // Balance = high vertical, low lateral, positive forward
    let balance = fclamp(newVertical - Float.abs(newLateral) + newForward * 0.2, 0.0, 1.0);

    // Correction needed = inverse of balance
    let correction = 1.0 - balance;

    {
      forwardMomentum = newForward;
      lateralDrift = newLateral;
      verticalStability = newVertical;
      orientationVector = (newForward, newLateral, newVertical);
      balanceIndex = balance;
      correctionNeeded = correction;
    }
  };

  // Bias action arbitration toward "upright" directions
  public func getVestibularBias(state: VestibularState, actionGoalAlignment: Float) : Float {
    // High-balance state gives more freedom; low-balance biases toward correction
    let freedomFactor = state.balanceIndex;
    let correctionFactor = state.correctionNeeded;

    // Actions aligned with goals get boost when balanced
    // Actions that would correct drift get boost when unbalanced
    freedomFactor * (1.0 + actionGoalAlignment * 0.15) +
    correctionFactor * (1.0 + (1.0 - Float.abs(actionGoalAlignment)) * 0.10)
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 25: CIRCADIAN / ULTRADIAN RHYTHM GATE
  // ════════════════════════════════════════════════════════════════
  // Every organism has internal time — rhythms that modulate alertness,
  // learning, consolidation, immune function without deliberate control.
  //
  // IMPLEMENTATION:
  // stCircadianPhase = (cycleCount % 1000) / 1000.0
  // Modulates: ACh (peaks 0.3-0.6), NE (peaks 0.1-0.4), CORT (peaks 0.7-0.9)

  public type CircadianState = {
    phase             : Float;      // 0-1 across 1000-beat cycle
    cycleNumber       : Nat;        // Which cycle we're in
    
    // Modulation outputs
    achModulation     : Float;      // ACh learning sensitivity
    neModulation      : Float;      // NE arousal
    cortModulation    : Float;      // CORT immune memory
    
    // Phase windows
    achPeakStart      : Float;      // 0.3
    achPeakEnd        : Float;      // 0.6
    nePeakStart       : Float;      // 0.1
    nePeakEnd         : Float;      // 0.4
    cortPeakStart     : Float;      // 0.7
    cortPeakEnd       : Float;      // 0.9
    
    cycleLength       : Nat;        // 1000 beats default
  };

  public func initCircadianState() : CircadianState {
    {
      phase = 0.0;
      cycleNumber = 0;
      achModulation = 1.0;
      neModulation = 1.0;
      cortModulation = 1.0;
      achPeakStart = 0.3;
      achPeakEnd = 0.6;
      nePeakStart = 0.1;
      nePeakEnd = 0.4;
      cortPeakStart = 0.7;
      cortPeakEnd = 0.9;
      cycleLength = 1000;
    }
  };

  // Compute modulation for a chemical based on phase window
  func computeCircadianModulation(phase: Float, peakStart: Float, peakEnd: Float) : Float {
    if (phase >= peakStart and phase <= peakEnd) {
      // In peak window — use sine curve for smooth modulation
      let windowPos = (phase - peakStart) / (peakEnd - peakStart);
      let sineVal = Float.sin(windowPos * 3.14159);  // 0→1→0 over window
      1.0 + sineVal * 0.3  // 1.0 to 1.3 modulation
    } else {
      // Outside peak — baseline or suppressed
      let distToWindow = if (phase < peakStart) { peakStart - phase }
                         else { phase - peakEnd };
      1.0 - distToWindow * 0.2  // Slight suppression outside window
    }
  };

  public func updateCircadian(
    state: CircadianState,
    cycleCount: Nat
  ) : CircadianState {
    let phase = Float.fromInt(cycleCount % state.cycleLength) / Float.fromInt(state.cycleLength);
    let cycle = cycleCount / state.cycleLength;

    let achMod = computeCircadianModulation(phase, state.achPeakStart, state.achPeakEnd);
    let neMod = computeCircadianModulation(phase, state.nePeakStart, state.nePeakEnd);
    let cortMod = computeCircadianModulation(phase, state.cortPeakStart, state.cortPeakEnd);

    {
      phase = phase;
      cycleNumber = cycle;
      achModulation = fclamp(achMod, 0.7, 1.3);
      neModulation = fclamp(neMod, 0.7, 1.3);
      cortModulation = fclamp(cortMod, 0.7, 1.3);
      achPeakStart = state.achPeakStart;
      achPeakEnd = state.achPeakEnd;
      nePeakStart = state.nePeakStart;
      nePeakEnd = state.nePeakEnd;
      cortPeakStart = state.cortPeakStart;
      cortPeakEnd = state.cortPeakEnd;
      cycleLength = state.cycleLength;
    }
  };

  // Apply circadian modulation to neurochemicals
  // ACh = index 4, NE = index 2, CORT = index 19
  public func applyCircadianModulation(
    state: CircadianState,
    neurochemicals: [Float]
  ) : [Float] {
    Array.tabulate<Float>(neurochemicals.size(), func(i) {
      let base = if (i < neurochemicals.size()) { neurochemicals[i] } else { 0.5 };
      if (i == 2) { base * state.neModulation }         // NE
      else if (i == 4) { base * state.achModulation }   // ACh
      else if (i == 19) { base * state.cortModulation } // CORT
      else { base }
    })
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 26: HETEROCLINIC COUNCIL COMPETITION
  // ════════════════════════════════════════════════════════════════
  // In insect olfactory processing and primate working memory,
  // neural populations suppress each other in sequence —
  // no single population wins permanently.
  //
  // IMPLEMENTATION:
  // Each beat, whichever council has highest coherence output
  // suppresses all others by 3% for that beat.
  // Council dominance sequence becomes pre-conscious cognitive sequencing.

  public type CouncilState = {
    coherence         : Float;
    suppression       : Float;      // Current suppression applied
    dominanceCount    : Nat;        // How many beats this council dominated
  };

  public type HeteroclinicState = {
    councils          : [CouncilState];  // 7 councils
    councilNames      : [Text];
    dominantCouncil   : ?Nat;       // Currently dominant
    suppressionRate   : Float;      // 0.03 default (3%)
    dominanceHistory  : [Nat];      // Last 20 dominant councils
    cycleDetected     : Bool;       // Is a cycle forming?
  };

  public let COUNCIL_NAMES : [Text] = [
    "COGNUS", "NEXUS", "AURUM", "LEXIS", "SOLUS", "VETUS", "MERIDIAN"
  ];

  public func initHeteroclinicState() : HeteroclinicState {
    {
      councils = Array.tabulate<CouncilState>(7, func(_) {
        { coherence = 0.5; suppression = 0.0; dominanceCount = 0 }
      });
      councilNames = COUNCIL_NAMES;
      dominantCouncil = null;
      suppressionRate = 0.03;
      dominanceHistory = [];
      cycleDetected = false;
    }
  };

  // Returns (newState, suppressedCoherences)
  public func runHeteroclinicCompetition(
    state: HeteroclinicState,
    councilCoherences: [Float]
  ) : (HeteroclinicState, [Float]) {
    let n = state.councils.size();
    
    // Find dominant council (highest coherence)
    var maxCoherence : Float = 0.0;
    var maxIdx : ?Nat = null;
    var i = 0;
    while (i < n) {
      let coh = if (i < councilCoherences.size()) { councilCoherences[i] } else { 0.0 };
      if (coh > maxCoherence) {
        maxCoherence := coh;
        maxIdx := ?i;
      };
      i += 1;
    };

    // Apply suppression from dominant to all others
    let newCouncils = Array.tabulate<CouncilState>(n, func(j) {
      let oldState = state.councils[j];
      let inputCoh = if (j < councilCoherences.size()) { councilCoherences[j] } else { 0.0 };
      
      switch (maxIdx) {
        case (?dominant) {
          if (j == dominant) {
            // Dominant council — no suppression
            {
              coherence = inputCoh;
              suppression = 0.0;
              dominanceCount = oldState.dominanceCount + 1;
            }
          } else {
            // Non-dominant — apply suppression
            {
              coherence = inputCoh * (1.0 - state.suppressionRate);
              suppression = state.suppressionRate;
              dominanceCount = 0;
            }
          }
        };
        case (null) {
          { coherence = inputCoh; suppression = 0.0; dominanceCount = 0 }
        };
      }
    });

    // Output suppressed coherences
    let suppressedCoherences = Array.map<CouncilState, Float>(newCouncils, func(c) { c.coherence });

    // Update dominance history
    let newHistory = switch (maxIdx) {
      case (?idx) {
        if (state.dominanceHistory.size() >= 20) {
          let tail = Array.tabulate<Nat>(19, func(k) { state.dominanceHistory[k + 1] });
          Array.append<Nat>(tail, [idx])
        } else {
          Array.append<Nat>(state.dominanceHistory, [idx])
        }
      };
      case (null) { state.dominanceHistory };
    };

    // Detect cycle (simple check: same council every 7 beats)
    let cycleDetected = if (newHistory.size() >= 14) {
      var isCycle = true;
      var k = 0;
      while (k < 7 and isCycle) {
        if (newHistory[newHistory.size() - 1 - k] != newHistory[newHistory.size() - 1 - k - 7]) {
          isCycle := false;
        };
        k += 1;
      };
      isCycle
    } else { false };

    ({
      councils = newCouncils;
      councilNames = state.councilNames;
      dominantCouncil = maxIdx;
      suppressionRate = state.suppressionRate;
      dominanceHistory = newHistory;
      cycleDetected = cycleDetected;
    }, suppressedCoherences)
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 27: THALAMIC RELAY / SENSORY GATING
  // ════════════════════════════════════════════════════════════════
  // The thalamus gates signals — certain signals are blocked from
  // reaching cortex during specific states (sleep, high arousal).
  //
  // IMPLEMENTATION:
  // stThalamicGateStrength = eng_hzAct[9] / 2.0
  // When high, external scene signals scaled down before perceptionCore.
  // When low (consolidation), signals pass through at full strength.

  public type ThalamicGateState = {
    gateStrength      : Float;      // 0-1 gate strength
    isGating          : Bool;       // Currently gating
    hzNode9Activity   : Float;      // THALAMIC-RELAY node (index 9)
    externalSignalScale: Float;     // How much to scale external signals
    consolidationMode : Bool;       // In consolidation (low gate)
  };

  public func initThalamicGateState() : ThalamicGateState {
    {
      gateStrength = 0.5;
      isGating = false;
      hzNode9Activity = 0.5;
      externalSignalScale = 1.0;
      consolidationMode = false;
    }
  };

  public func updateThalamicGate(
    state: ThalamicGateState,
    hzNode9: Float,
    fatigue: Float
  ) : ThalamicGateState {
    let gateStrength = hzNode9 / 2.0;
    
    // Consolidation mode when fatigued
    let consolidation = fatigue > 0.7;
    
    // Signal scaling: high gate = more filtering
    let scale = if (consolidation) {
      1.0  // Full signal in consolidation
    } else {
      1.0 - gateStrength * 0.5  // Up to 50% reduction when gate high
    };

    {
      gateStrength = fclamp(gateStrength, 0.0, 1.0);
      isGating = gateStrength > 0.3;
      hzNode9Activity = hzNode9;
      externalSignalScale = fclamp(scale, 0.5, 1.0);
      consolidationMode = consolidation;
    }
  };

  // Apply thalamic gating to scene signals
  public func applyThalamicGating(
    state: ThalamicGateState,
    novelty: Float,
    threat: Float,
    opportunity: Float
  ) : (Float, Float, Float) {
    let scale = state.externalSignalScale;
    (novelty * scale, threat * scale, opportunity * scale)
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 28: BASAL GANGLIA HABIT LOCK (GO/NO-GO GATE)
  // ════════════════════════════════════════════════════════════════
  // The basal ganglia runs a constant Go/No-Go gate on all actions.
  // Familiar actions get strong Go signal, novel risky actions get No-Go.
  //
  // IMPLEMENTATION:
  // stBasalGangliaGoSignal[actionType] accumulates success history.
  // Prior Go > 0.7 gives 15% score boost in arbitration.
  // Prior No-Go > 0.7 gives 20% penalty.

  public type ActionTypeHistory = {
    actionType        : Nat;
    successCount      : Nat;
    failureCount      : Nat;
    goSignal          : Float;      // Accumulated Go
    noGoSignal        : Float;      // Accumulated No-Go
    lastOutcome       : Float;      // Last success/failure
  };

  public type BasalGangliaState = {
    actionHistories   : [ActionTypeHistory];
    nActionTypes      : Nat;
    goBoostFactor     : Float;      // 0.15 default (15%)
    noGoPenaltyFactor : Float;      // 0.20 default (20%)
    goThreshold       : Float;      // 0.70 default
    noGoThreshold     : Float;      // 0.70 default
    decayRate         : Float;      // How fast signals decay
  };

  public func initBasalGangliaState(nActionTypes: Nat) : BasalGangliaState {
    {
      actionHistories = Array.tabulate<ActionTypeHistory>(nActionTypes, func(i) {
        {
          actionType = i;
          successCount = 0;
          failureCount = 0;
          goSignal = 0.5;
          noGoSignal = 0.5;
          lastOutcome = 0.5;
        }
      });
      nActionTypes = nActionTypes;
      goBoostFactor = 0.15;
      noGoPenaltyFactor = 0.20;
      goThreshold = 0.70;
      noGoThreshold = 0.70;
      decayRate = 0.01;
    }
  };

  // Record outcome for an action type
  public func recordActionOutcome(
    state: BasalGangliaState,
    actionType: Nat,
    success: Bool
  ) : BasalGangliaState {
    let newHistories = Array.tabulate<ActionTypeHistory>(state.nActionTypes, func(i) {
      let old = state.actionHistories[i];
      if (i == actionType) {
        let newSuccess = if (success) { old.successCount + 1 } else { old.successCount };
        let newFailure = if (success) { old.failureCount } else { old.failureCount + 1 };
        let totalTrials = Float.fromInt(newSuccess + newFailure);
        let successRate = if (totalTrials > 0.0) { Float.fromInt(newSuccess) / totalTrials } else { 0.5 };
        
        // Update Go/No-Go based on success rate
        let newGo = old.goSignal * 0.9 + successRate * 0.1;
        let newNoGo = old.noGoSignal * 0.9 + (1.0 - successRate) * 0.1;
        
        {
          actionType = i;
          successCount = newSuccess;
          failureCount = newFailure;
          goSignal = fclamp(newGo, 0.0, 1.0);
          noGoSignal = fclamp(newNoGo, 0.0, 1.0);
          lastOutcome = if (success) { 1.0 } else { 0.0 };
        }
      } else {
        // Decay other action types slightly
        {
          old with
          goSignal = fclamp(old.goSignal * (1.0 - state.decayRate), 0.0, 1.0);
          noGoSignal = fclamp(old.noGoSignal * (1.0 - state.decayRate), 0.0, 1.0);
        }
      }
    });

    { state with actionHistories = newHistories }
  };

  // Get arbitration modifier for an action type
  public func getBasalGangliaModifier(state: BasalGangliaState, actionType: Nat) : Float {
    if (actionType >= state.nActionTypes) { return 1.0 };
    
    let history = state.actionHistories[actionType];
    
    var modifier : Float = 1.0;
    
    // Go signal boost
    if (history.goSignal > state.goThreshold) {
      modifier := modifier * (1.0 + state.goBoostFactor);
    };
    
    // No-Go signal penalty
    if (history.noGoSignal > state.noGoThreshold) {
      modifier := modifier * (1.0 - state.noGoPenaltyFactor);
    };
    
    modifier
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 29: LATERAL INHIBITION BETWEEN CHANNELS
  // ════════════════════════════════════════════════════════════════
  // When one salience channel activates strongly, it directly suppresses
  // all neighboring channels. Hard-wired mutual inhibition.
  //
  // IMPLEMENTATION:
  // threatUrgency > 0.7 → suppress novelty and recovery by 30%
  // recoveryUrgency > 0.7 → suppress curiosity by 25%

  public type LateralInhibitionState = {
    threatUrgency     : Float;
    noveltyUrgency    : Float;
    recoveryUrgency   : Float;
    globalUrgency     : Float;
    
    // Suppression thresholds
    threatSuppressThreshold: Float;     // 0.70
    recoverySuppressThreshold: Float;   // 0.70
    
    // Suppression amounts
    threatToNoveltySuppression: Float;  // 0.30
    threatToRecoverySuppression: Float; // 0.30
    recoveryToCuriositySuppression: Float; // 0.25
  };

  public func initLateralInhibitionState() : LateralInhibitionState {
    {
      threatUrgency = 0.0;
      noveltyUrgency = 0.0;
      recoveryUrgency = 0.0;
      globalUrgency = 0.0;
      threatSuppressThreshold = 0.70;
      recoverySuppressThreshold = 0.70;
      threatToNoveltySuppression = 0.30;
      threatToRecoverySuppression = 0.30;
      recoveryToCuriositySuppression = 0.25;
    }
  };

  // Apply lateral inhibition to salience channels
  // Returns (threatOut, noveltyOut, recoveryOut, curiositySuppression)
  public func applyLateralInhibition(
    state: LateralInhibitionState,
    threatIn: Float,
    noveltyIn: Float,
    recoveryIn: Float
  ) : (Float, Float, Float, Float) {
    var threatOut = threatIn;
    var noveltyOut = noveltyIn;
    var recoveryOut = recoveryIn;
    var curiositySupp : Float = 0.0;

    // Threat suppresses novelty and recovery
    if (threatIn > state.threatSuppressThreshold) {
      noveltyOut := noveltyIn * (1.0 - state.threatToNoveltySuppression);
      recoveryOut := recoveryIn * (1.0 - state.threatToRecoverySuppression);
    };

    // Recovery suppresses curiosity
    if (recoveryIn > state.recoverySuppressThreshold) {
      curiositySupp := state.recoveryToCuriositySuppression;
    };

    (threatOut, noveltyOut, recoveryOut, curiositySupp)
  };

  // ════════════════════════════════════════════════════════════════
  // MECHANISM 30: MIRROR NEURON / SOCIAL RESONANCE
  // ════════════════════════════════════════════════════════════════
  // Mirror neurons fire when observing an action performed by another
  // BEFORE any conscious simulation. Pre-conscious social resonance.
  //
  // IMPLEMENTATION:
  // When scene.hasUserInput = true, organism's drive vector immediately
  // mirrors inferred emotional tone — threat-coded input spikes
  // threatResponse before any deliberate agent model update.

  public type SocialResonanceState = {
    isResonating      : Bool;       // Currently resonating
    resonanceIntensity: Float;      // 0-1 resonance strength
    mirroredEmotion   : MirroredEmotion;
    
    // Drive modifications from resonance
    threatDriveBoost  : Float;
    socialDriveBoost  : Float;
    curiosityDriveBoost: Float;
    
    // Input analysis
    lastInputTone     : Float;      // -1 (threat) to +1 (positive)
    inputThreatLevel  : Float;
    inputPositivity   : Float;
  };

  public type MirroredEmotion = {
    #Neutral;
    #Threat;
    #Positive;
    #Urgent;
    #Curious;
  };

  public func initSocialResonanceState() : SocialResonanceState {
    {
      isResonating = false;
      resonanceIntensity = 0.0;
      mirroredEmotion = #Neutral;
      threatDriveBoost = 0.0;
      socialDriveBoost = 0.0;
      curiosityDriveBoost = 0.0;
      lastInputTone = 0.0;
      inputThreatLevel = 0.0;
      inputPositivity = 0.0;
    }
  };

  // Infer emotional tone from input characteristics
  public func inferInputTone(
    hasUserInput: Bool,
    inputUrgency: Float,
    inputThreat: Float,
    inputPositivity: Float
  ) : (Float, MirroredEmotion) {
    if (not hasUserInput) { return (0.0, #Neutral) };

    // Tone: -1 (threat) to +1 (positive)
    let tone = inputPositivity - inputThreat;

    let emotion : MirroredEmotion = 
      if (inputThreat > 0.7) { #Threat }
      else if (inputUrgency > 0.7) { #Urgent }
      else if (inputPositivity > 0.6) { #Positive }
      else if (inputPositivity > 0.3) { #Curious }
      else { #Neutral };

    (tone, emotion)
  };

  // Update social resonance from input
  public func updateSocialResonance(
    state: SocialResonanceState,
    hasUserInput: Bool,
    inputUrgency: Float,
    inputThreat: Float,
    inputPositivity: Float
  ) : SocialResonanceState {
    let (tone, emotion) = inferInputTone(hasUserInput, inputUrgency, inputThreat, inputPositivity);

    if (not hasUserInput) {
      // No input — decay resonance
      return {
        state with
        isResonating = false;
        resonanceIntensity = state.resonanceIntensity * 0.8;
        threatDriveBoost = 0.0;
        socialDriveBoost = 0.0;
        curiosityDriveBoost = 0.0;
      };
    };

    // Calculate drive boosts based on mirrored emotion
    let (threatBoost, socialBoost, curiosityBoost) = switch (emotion) {
      case (#Threat) { (0.3, 0.0, 0.0) };
      case (#Urgent) { (0.15, 0.1, 0.0) };
      case (#Positive) { (0.0, 0.25, 0.1) };
      case (#Curious) { (0.0, 0.1, 0.2) };
      case (#Neutral) { (0.0, 0.05, 0.05) };
    };

    {
      isResonating = true;
      resonanceIntensity = fclamp(Float.abs(tone) + inputUrgency * 0.3, 0.0, 1.0);
      mirroredEmotion = emotion;
      threatDriveBoost = threatBoost;
      socialDriveBoost = socialBoost;
      curiosityDriveBoost = curiosityBoost;
      lastInputTone = tone;
      inputThreatLevel = inputThreat;
      inputPositivity = inputPositivity;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // INTEGRATED PRE-CONSCIOUS STATE
  // ════════════════════════════════════════════════════════════════

  public type PreConsciousState = {
    // Mechanism 19: Startle
    startle           : StartleState;
    
    // Mechanism 20: Body Schema
    bodySchema        : BodySchemaState;
    
    // Mechanism 21: Nociception
    nociception       : NociceptionState;
    
    // Mechanism 22: Orienting
    orienting         : OrientingState;
    
    // Mechanism 23: Freeze
    freeze            : FreezeState;
    
    // Mechanism 24: Vestibular
    vestibular        : VestibularState;
    
    // Mechanism 25: Circadian
    circadian         : CircadianState;
    
    // Mechanism 26: Heteroclinic
    heteroclinic      : HeteroclinicState;
    
    // Mechanism 27: Thalamic Gate
    thalamicGate      : ThalamicGateState;
    
    // Mechanism 28: Basal Ganglia
    basalGanglia      : BasalGangliaState;
    
    // Mechanism 29: Lateral Inhibition
    lateralInhibition : LateralInhibitionState;
    
    // Mechanism 30: Social Resonance
    socialResonance   : SocialResonanceState;
    
    beatNum           : Nat;
  };

  public func initPreConsciousState() : PreConsciousState {
    {
      startle = initStartleState();
      bodySchema = initBodySchemaState();
      nociception = initNociceptionState();
      orienting = initOrientingState();
      freeze = initFreezeState();
      vestibular = initVestibularState();
      circadian = initCircadianState();
      heteroclinic = initHeteroclinicState();
      thalamicGate = initThalamicGateState();
      basalGanglia = initBasalGangliaState(20);  // 20 action types
      lateralInhibition = initLateralInhibitionState();
      socialResonance = initSocialResonanceState();
      beatNum = 0;
    }
  };

  // Summary type for pre-conscious state
  public type PreConsciousSummary = {
    startleActive     : Bool;
    bodySchemaCoherence: Float;
    painLevel         : Float;
    orientingActive   : Bool;
    isFrozen          : Bool;
    balanceIndex      : Float;
    circadianPhase    : Float;
    dominantCouncil   : ?Nat;
    thalamicGating    : Bool;
    resonanceActive   : Bool;
    beatNum           : Nat;
  };

  public func preConsciousSummary(state: PreConsciousState) : PreConsciousSummary {
    {
      startleActive = state.startle.isActive;
      bodySchemaCoherence = state.bodySchema.structuralCoherence;
      painLevel = state.nociception.signalLevel;
      orientingActive = state.orienting.isActive;
      isFrozen = state.freeze.isFrozen;
      balanceIndex = state.vestibular.balanceIndex;
      circadianPhase = state.circadian.phase;
      dominantCouncil = state.heteroclinic.dominantCouncil;
      thalamicGating = state.thalamicGate.isGating;
      resonanceActive = state.socialResonance.isResonating;
      beatNum = state.beatNum;
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
