// ============================================================
// CONTINUOUS SELF-PREDICTION ENGINE
// SOVEREIGN SUBSTRATE MODULE — PREDICTIVE CODING TIER
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// THE SYSTEM MODELING ITSELF:
// 1. 12-Domain Prediction Engine (Identity→Evaluation)
// 2. Free Energy = Mean Squared Prediction Error across 12 domains
// 3. Hebbian Predictive Coding: pred[x] += (domain[x] - pred[x]) × ncAdaptRate
// 4. Domain Temporal — tracks beat cadence coherence
// 5. TD-delta learning per cognitive core
// 6. Seven Coherence Mechanisms (Kuramoto, PAC, HELIX_ALPHA, H_obs, Demon Yield, Temporal Dilation, ENTANGLA)
// ============================================================
import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Array "mo:base/Array";

module {

  // ============================================================
  // PHYSICAL CONSTANTS
  // ============================================================
  public let N_DOMAINS          : Nat   = 12;     // 12 prediction domains
  public let N_SHELLS           : Nat   = 11;     // 11 shells
  public let N_CORES            : Nat   = 12;     // 12 cognitive cores
  public let N_HZ_NODES         : Nat   = 12;     // 12 Hz hierarchy nodes
  public let NC_ADAPT_RATE      : Float = 0.1;    // Predictive coding learning rate
  public let GAMMA_TD           : Float = 0.98;   // TD learning discount factor
  public let S0                 : Float = 0.75;   // Sovereign floor
  public let PI                 : Float = 3.14159265358979;
  public let TWO_PI             : Float = 6.28318530717958;
  public let LOG2_E             : Float = 1.4426950408889634;
  public let EPSILON            : Float = 1.0e-10;

  // ============================================================
  // DOMAIN INDICES (12 Domains)
  // ============================================================
  public let DOMAIN_IDENTITY     : Nat = 0;   // Who am I?
  public let DOMAIN_MISSION      : Nat = 1;   // What is my purpose?
  public let DOMAIN_BODY         : Nat = 2;   // Physical state
  public let DOMAIN_WORLD        : Nat = 3;   // External environment
  public let DOMAIN_SOCIAL       : Nat = 4;   // Social context
  public let DOMAIN_COGNITION    : Nat = 5;   // Thinking processes
  public let DOMAIN_GOALS        : Nat = 6;   // Current objectives
  public let DOMAIN_MEMORY       : Nat = 7;   // Memory systems
  public let DOMAIN_CONSEQUENCES : Nat = 8;   // Predicted outcomes
  public let DOMAIN_ADAPTATION   : Nat = 9;   // Learning state
  public let DOMAIN_TEMPORAL     : Nat = 10;  // Temporal coherence
  public let DOMAIN_EVALUATION   : Nat = 11;  // Self-assessment

  // ============================================================
  // HELIX_ALPHA SHELL LEARNING RATES
  // Geometric decrease from Shell 1 (fast, primal) to Shell 11 (slow, identity)
  // ============================================================
  public let HELIX_ALPHA : [Float] = [
    0.042,  // Shell 1:  Primal, fastest plasticity
    0.038,  // Shell 2
    0.034,  // Shell 3
    0.030,  // Shell 4
    0.026,  // Shell 5
    0.022,  // Shell 6:  Cognitive frame
    0.018,  // Shell 7
    0.014,  // Shell 8
    0.010,  // Shell 9
    0.007,  // Shell 10
    0.004   // Shell 11: Sovereign identity, slowest
  ];

  // BDNF modulation per shell (plasticity multipliers)
  public let BDNF_MODULATION : [Float] = [
    1.80,  // Shell 1:  Maximum plasticity
    1.65,  // Shell 2
    1.50,  // Shell 3
    1.38,  // Shell 4
    1.27,  // Shell 5
    1.18,  // Shell 6
    1.12,  // Shell 7
    1.08,  // Shell 8
    1.05,  // Shell 9
    1.02,  // Shell 10
    1.00   // Shell 11: Fully consolidated
  ];

  // ============================================================
  // PHASE-AMPLITUDE COUPLING CONSTANTS (PAC)
  // Slower shells modulate faster shells via phase-locked envelopes
  // ============================================================
  // Primary coupling: shell[k] modulates shell[k+1]
  public let PAC_PRIMARY : [Float] = [
    0.35,  // Shell 1 → Shell 2
    0.32,  // Shell 2 → Shell 3
    0.29,  // Shell 3 → Shell 4
    0.26,  // Shell 4 → Shell 5
    0.23,  // Shell 5 → Shell 6
    0.20,  // Shell 6 → Shell 7
    0.17,  // Shell 7 → Shell 8
    0.14,  // Shell 8 → Shell 9
    0.11,  // Shell 9 → Shell 10
    0.08   // Shell 10 → Shell 11
  ];

  // Skip-one coupling: shell[k] modulates shell[k+2]
  public let PAC_SKIP : [Float] = [
    0.18,  // Shell 1 → Shell 3
    0.16,  // Shell 2 → Shell 4
    0.14,  // Shell 3 → Shell 5
    0.12,  // Shell 4 → Shell 6
    0.10,  // Shell 5 → Shell 7
    0.08,  // Shell 6 → Shell 8
    0.06,  // Shell 7 → Shell 9
    0.04,  // Shell 8 → Shell 10
    0.02   // Shell 9 → Shell 11
  ];

  // ============================================================
  // Hz NODE FREQUENCIES (12 binary hierarchy)
  // fd(k) = 2.5 × 2^(k-4), k=1..12
  // ============================================================
  public let HZ_FREQUENCIES : [Float] = [
    0.15625,    // k=1: 2.5 × 2^(-3) = 0.3125/2
    0.3125,     // k=2: 2.5 × 2^(-2)
    0.625,      // k=3: 2.5 × 2^(-1)
    1.25,       // k=4: 2.5 × 2^0
    2.5,        // k=5: 2.5 × 2^1
    5.0,        // k=6: 2.5 × 2^2
    10.0,       // k=7: 2.5 × 2^3
    20.0,       // k=8: 2.5 × 2^4
    40.0,       // k=9: 2.5 × 2^5
    80.0,       // k=10: 2.5 × 2^6
    160.0,      // k=11: 2.5 × 2^7
    320.0       // k=12: 2.5 × 2^8
  ];

  // ============================================================
  // TYPES
  // ============================================================

  // 12-Domain Prediction State
  public type DomainState = {
    // Current measured values
    domain : [Float];      // 12 domain measurements
    // Predicted values
    pred : [Float];        // 12 predictions
    // Prediction errors
    errors : [Float];      // 12 errors (domain - pred)
    // Free energy (MSE)
    freeEnergy : Float;
    // Arousal (triggered by high free energy)
    arousal : Float;
    // Salience (attention signal)
    salience : Float;
    // Beat number
    beatNum : Nat;
  };

  // TD Learning State (per cognitive core)
  public type TDLearningState = {
    // Value estimates V(s) for each core
    valueEstimates : [Float];   // 12 cores
    // Core coherence levels
    coreCoherence : [Float];    // 12 cores
    // TD deltas
    tdDeltas : [Float];         // 12 cores
    // Reward history
    rewardHistory : [Float];    // rolling window
    // Hz activations
    hzActivations : [Float];    // 12 Hz nodes
  };

  // Shell State (11 shells)
  public type ShellState = {
    activations : [Float];    // 11 shell activations
    phases : [Float];         // 11 shell phases
    learningRates : [Float];  // 11 effective learning rates (HELIX_ALPHA × BDNF)
  };

  // Coherence Mechanisms State
  public type CoherenceState = {
    // Mechanism 1: Kuramoto Phase Alignment
    kfHz : Float;              // |Σ e^(iφ_k)| / 12
    hzPhases : [Float];        // 12 Hz node phases

    // Mechanism 2: Phase-Amplitude Coupling
    pacPrimaryAmps : [Float];  // 10 primary PAC amplitudes
    pacSkipAmps : [Float];     // 9 skip-one PAC amplitudes

    // Mechanism 3: HELIX_ALPHA (stored in ShellState)

    // Mechanism 4: H_obs Information Entropy
    hObs : Float;              // Observational entropy [0, 12] bits
    blockEntropies : [Float];  // 8 block entropies
    activeDimensions : Float;  // 2^H_obs

    // Mechanism 5: Maxwell's Demon Yield
    demonYield : Float;        // ΔH × coherenceC × C_adj
    hObsPrev : Float;          // Previous H_obs

    // Mechanism 6: Temporal Dilation
    dilationFactor : Float;    // 1 + (coherenceC - 0.9) × 10 × resonexAlign
    temporalCoherence : Float; // coherenceC component
    veritasOperator : Float;   // Truth alignment
    resonexAlign : Float;      // Resonex alignment

    // Mechanism 7: ENTANGLA 11×11 Coupling Matrix
    entanglaMatrix : [Float];  // 121 elements (11×11)
    meanEntanglement : Float;  // Mean coupling strength
    bypassActive : Bool;       // BYPASS cascade gate status
  };

  // Full Predictive Coding System
  public type PredictiveCodingState = {
    domains : DomainState;
    tdLearning : TDLearningState;
    shells : ShellState;
    coherence : CoherenceState;
    // Global coherence measure
    coherenceC : Float;        // Main coherence variable [0, 1]
    beatNum : Nat;
  };

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fabs(x : Float) : Float { if (x < 0.0) -x else x };

  func _ln(x : Float) : Float {
    if (x <= 0.0) -100.0 else Float.log(x)
  };

  func _log2(x : Float) : Float {
    _ln(x) * LOG2_E
  };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };

  // ============================================================
  // 12-DOMAIN PREDICTION ENGINE
  // ============================================================

  // Compute free energy: F = (Σ d_i²) / 12 where d_i = domain[i] - pred[i]
  public func computeFreeEnergy(domain : [Float], pred : [Float]) : Float {
    if (domain.size() != N_DOMAINS or pred.size() != N_DOMAINS) {
      return 0.0;
    };

    var sumSq : Float = 0.0;
    for (i in Array.keys(domain)) {
      let d = domain[i] - pred[i];
      sumSq += d * d;
    };

    sumSq / Float.fromInt(N_DOMAINS)
  };

  // Update predictions via Hebbian predictive coding
  // pred[x] += (domain[x] - pred[x]) × ncAdaptRate
  public func updatePredictions(domain : [Float], pred : [Float], adaptRate : Float) : [Float] {
    Array.tabulate<Float>(N_DOMAINS, func(i) {
      if (i < pred.size() and i < domain.size()) {
        let error = domain[i] - pred[i];
        pred[i] + error * adaptRate
      } else { S0 }
    })
  };

  // Compute arousal from free energy
  // High free energy → cannot predict self → arousal rises
  public func computeArousal(freeEnergy : Float, prevArousal : Float) : Float {
    // Arousal increases with free energy, decays otherwise
    let targetArousal = _clamp(freeEnergy * 2.0, 0.0, 1.0);
    prevArousal * 0.9 + targetArousal * 0.1
  };

  // Compute salience from arousal and free energy gradient
  public func computeSalience(arousal : Float, freeEnergy : Float, prevFreeEnergy : Float) : Float {
    let gradient = freeEnergy - prevFreeEnergy;
    let salienceSignal = arousal * (1.0 + _fabs(gradient) * 5.0);
    _clamp(salienceSignal, 0.0, 1.0)
  };

  // Update Domain Temporal based on beat cadence divergence
  // domainTemporal = clamp(domainTemporal * 0.98 + (1.0 - velaDivergenceScore) * 0.02, 0.0, 1.0)
  public func updateDomainTemporal(currentTemporal : Float, velaDivergenceScore : Float) : Float {
    _clamp(currentTemporal * 0.98 + (1.0 - velaDivergenceScore) * 0.02, 0.0, 1.0)
  };

  // Full domain state update
  public func updateDomainState(
    state : DomainState,
    newDomainValues : [Float],
    velaDivergenceScore : Float
  ) : DomainState {
    // Update predictions
    let newPred = updatePredictions(newDomainValues, state.pred, NC_ADAPT_RATE);

    // Compute errors
    let newErrors = Array.tabulate<Float>(N_DOMAINS, func(i) {
      if (i < newDomainValues.size() and i < newPred.size()) {
        newDomainValues[i] - newPred[i]
      } else { 0.0 }
    });

    // Update domain temporal (index 10)
    var finalDomain = Array.thaw<Float>(newDomainValues);
    if (finalDomain.size() > DOMAIN_TEMPORAL) {
      finalDomain[DOMAIN_TEMPORAL] := updateDomainTemporal(
        state.domain[DOMAIN_TEMPORAL],
        velaDivergenceScore
      );
    };

    // Compute free energy
    let newFE = computeFreeEnergy(Array.freeze(finalDomain), newPred);

    // Compute arousal and salience
    let newArousal = computeArousal(newFE, state.arousal);
    let newSalience = computeSalience(newArousal, newFE, state.freeEnergy);

    {
      domain = Array.freeze(finalDomain);
      pred = newPred;
      errors = newErrors;
      freeEnergy = newFE;
      arousal = newArousal;
      salience = newSalience;
      beatNum = state.beatNum + 1;
    }
  };

  // ============================================================
  // TD-DELTA LEARNING (per cognitive core)
  // TD_delta = reward[t] + γ * V(s[t+1]) - V(s[t])
  // coreCoherence[i] = coreCoherence[i] * 0.98 + hzActivations[hzIdx] * coherenceC * 5.0 + TD_delta
  // ============================================================

  // Compute TD delta for a single core
  public func computeTDDelta(
    reward : Float,
    currentValue : Float,
    nextValue : Float,
    gamma : Float
  ) : Float {
    reward + gamma * nextValue - currentValue
  };

  // Update core coherence via TD learning
  public func updateCoreCoherence(
    currentCoherence : Float,
    hzActivation : Float,
    coherenceC : Float,
    tdDelta : Float
  ) : Float {
    _clamp(currentCoherence * 0.98 + hzActivation * coherenceC * 5.0 + tdDelta, 0.0, 1.0)
  };

  // Full TD learning update
  public func updateTDLearning(
    state : TDLearningState,
    rewards : [Float],
    coherenceC : Float
  ) : TDLearningState {
    let n = N_CORES;

    // Compute TD deltas and update value estimates
    var newValues = Array.thaw<Float>(state.valueEstimates);
    var newDeltas = Array.thaw<Float>(state.tdDeltas);
    var newCoherence = Array.thaw<Float>(state.coreCoherence);

    for (i in Array.keys(Array.tabulate<Nat>(n, func(x) { x }))) {
      let reward = if (i < rewards.size()) rewards[i] else 0.0;
      let nextIdx = (i + 1) % n;
      let nextValue = state.valueEstimates[nextIdx];
      let currentValue = state.valueEstimates[i];

      // TD delta
      let delta = computeTDDelta(reward, currentValue, nextValue, GAMMA_TD);
      newDeltas[i] := delta;

      // Update value estimate
      newValues[i] := _clamp(currentValue + 0.1 * delta, 0.0, 1.0);

      // Update core coherence
      let hzIdx = i % N_HZ_NODES;
      let hzAct = state.hzActivations[hzIdx];
      newCoherence[i] := updateCoreCoherence(state.coreCoherence[i], hzAct, coherenceC, delta);
    };

    // Update reward history
    let newHistory = if (state.rewardHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { state.rewardHistory[i + 1] });
      var sumR : Float = 0.0;
      for (r in rewards.vals()) { sumR += r };
      Array.append<Float>(tail, [sumR / Float.fromInt(rewards.size())])
    } else {
      var sumR : Float = 0.0;
      for (r in rewards.vals()) { sumR += r };
      Array.append<Float>(state.rewardHistory, [sumR / Float.fromInt(Nat.max(1, rewards.size()))])
    };

    {
      valueEstimates = Array.freeze(newValues);
      coreCoherence = Array.freeze(newCoherence);
      tdDeltas = Array.freeze(newDeltas);
      rewardHistory = newHistory;
      hzActivations = state.hzActivations;
    }
  };

  // ============================================================
  // MECHANISM 1: KURAMOTO PHASE ALIGNMENT (kfHz)
  // kfHz = |Σ e^(iφ_k)| / 12
  // kfHz = 1.0 → all phase-locked; kfHz = 0.0 → complete scatter
  // ============================================================

  public func computeKuramotoR(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };

    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;

    for (phi in phases.vals()) {
      sumCos += Float.cos(phi);
      sumSin += Float.sin(phi);
    };

    let nf = Float.fromInt(n);
    _sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  // Update Hz node phases (Kuramoto dynamics)
  public func updateHzPhases(
    phases : [Float],
    frequencies : [Float],
    globalK : Float,
    dt : Float
  ) : [Float] {
    let n = phases.size();
    let (r, meanPhase) = computeOrderParams(phases);

    Array.tabulate<Float>(n, func(i) {
      let omega = if (i < frequencies.size()) frequencies[i] else 1.0;
      let coupling = globalK * r * Float.sin(meanPhase - phases[i]);
      wrapPhase(phases[i] + (omega + coupling) * dt)
    })
  };

  func computeOrderParams(phases : [Float]) : (Float, Float) {
    let n = phases.size();
    if (n == 0) { return (0.0, 0.0) };

    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;

    for (phi in phases.vals()) {
      sumCos += Float.cos(phi);
      sumSin += Float.sin(phi);
    };

    let nf = Float.fromInt(n);
    let r = _sqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    let psi = Float.arctan2(sumSin, sumCos);
    (r, psi)
  };

  func wrapPhase(theta : Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };

  // ============================================================
  // MECHANISM 2: PHASE-AMPLITUDE COUPLING (PAC)
  // A_fast = A_base × (1 + PAC_PRIMARY[k] × cos(φ_slow))
  // A_fast+1 = A_base × (1 + PAC_SKIP[k] × cos(φ_slow))
  // ============================================================

  // Compute PAC modulated amplitude
  public func pacModulatedAmplitude(
    baseAmp : Float,
    pacStrength : Float,
    slowPhase : Float
  ) : Float {
    baseAmp * (1.0 + pacStrength * Float.cos(slowPhase))
  };

  // Update all PAC amplitudes
  public func updatePACAmplitudes(
    shellActivations : [Float],
    shellPhases : [Float]
  ) : ([Float], [Float]) {
    // Primary coupling (shell k → shell k+1)
    let primaryAmps = Array.tabulate<Float>(10, func(k) {
      if (k + 1 < N_SHELLS) {
        pacModulatedAmplitude(
          shellActivations[k + 1],
          PAC_PRIMARY[k],
          shellPhases[k]
        )
      } else { 0.0 }
    });

    // Skip-one coupling (shell k → shell k+2)
    let skipAmps = Array.tabulate<Float>(9, func(k) {
      if (k + 2 < N_SHELLS) {
        pacModulatedAmplitude(
          shellActivations[k + 2],
          PAC_SKIP[k],
          shellPhases[k]
        )
      } else { 0.0 }
    });

    (primaryAmps, skipAmps)
  };

  // ============================================================
  // MECHANISM 4: H_obs INFORMATION ENTROPY
  // 8 blocks, Shannon entropy per block, weighted sum
  // H_obs = Σ (H_block[i] × weight[i]) → [0, 12] bits
  // activeDims = 2^H_obs
  // ============================================================

  // Block weights for H_obs calculation
  public let HOBS_WEIGHTS : [Float] = [
    0.12,  // Block 0: Spatial
    0.15,  // Block 1: Memory
    0.14,  // Block 2: Executive
    0.18,  // Block 3: Temporal (most important)
    0.10,  // Block 4: Motor
    0.08,  // Block 5: Sensory
    0.13,  // Block 6: Affective
    0.10   // Block 7: Social
  ];

  // Compute Shannon entropy for a probability distribution
  public func shannonEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) {
        h -= p * _log2(p);
      };
    };
    _clamp(h, 0.0, 12.0)
  };

  // Normalize values to probabilities
  public func normalizeToProbs(values : [Float]) : [Float] {
    var sum : Float = 0.0;
    for (v in values.vals()) { sum += _fabs(v) };
    if (sum < EPSILON) {
      let n = values.size();
      return Array.tabulate<Float>(n, func(_) { 1.0 / Float.fromInt(n) });
    };
    Array.map<Float, Float>(values, func(v) { _fabs(v) / sum })
  };

  // Compute H_obs from block values
  public func computeHObs(blockValues : [[Float]]) : (Float, [Float]) {
    let blockEntropies = Array.tabulate<Float>(8, func(i) {
      if (i < blockValues.size()) {
        let probs = normalizeToProbs(blockValues[i]);
        shannonEntropy(probs)
      } else { 0.0 }
    });

    var hObs : Float = 0.0;
    for (i in Array.keys(blockEntropies)) {
      if (i < HOBS_WEIGHTS.size()) {
        hObs += blockEntropies[i] * HOBS_WEIGHTS[i];
      };
    };

    // Scale to [0, 12]
    hObs := _clamp(hObs * 3.0, 0.0, 12.0);

    (hObs, blockEntropies)
  };

  // Compute active dimensions from H_obs
  public func computeActiveDimensions(hObs : Float) : Float {
    Float.exp(hObs * _ln(2.0))  // 2^H_obs
  };

  // ============================================================
  // MECHANISM 5: MAXWELL'S DEMON YIELD
  // ΔH = H_obs - H_obs_prev
  // Y = 0.85 × ΔH × coherenceC × C_adj
  // ============================================================

  public func computeDemonYield(
    hObs : Float,
    hObsPrev : Float,
    coherenceC : Float,
    cAdj : Float
  ) : Float {
    let deltaH = hObs - hObsPrev;
    if (deltaH > 0.0) {
      0.85 * deltaH * coherenceC * cAdj
    } else { 0.0 }
  };

  // ============================================================
  // MECHANISM 6: TEMPORAL DILATION
  // When coherenceC > 0.90 AND veritasOperator > 0.85 AND all shells resonant:
  // dilationFactor = 1 + (coherenceC - 0.9) × 10 × resonexAlign
  // ============================================================

  public func computeTemporalDilation(
    coherenceC : Float,
    veritasOperator : Float,
    resonexAlign : Float,
    shellsResonant : Bool
  ) : Float {
    if (coherenceC > 0.90 and veritasOperator > 0.85 and shellsResonant) {
      1.0 + (coherenceC - 0.9) * 10.0 * resonexAlign
    } else { 1.0 }
  };

  // Check if all shells are resonant
  public func checkShellsResonant(shellActivations : [Float], threshold : Float) : Bool {
    for (a in shellActivations.vals()) {
      if (a < threshold) { return false };
    };
    true
  };

  // ============================================================
  // MECHANISM 7: ENTANGLA 11×11 COUPLING MATRIX
  // matrix[i][j] = (shellAct[i] × shellAct[j]) × cos(shellPhase[i] - shellPhase[j])
  // Mean entanglement drives BYPASS cascade gate
  // ============================================================

  // Compute ENTANGLA matrix element
  public func entanglaElement(
    actI : Float,
    actJ : Float,
    phaseI : Float,
    phaseJ : Float
  ) : Float {
    (actI * actJ) * Float.cos(phaseI - phaseJ)
  };

  // Compute full ENTANGLA matrix
  public func computeEntanglaMatrix(
    activations : [Float],
    phases : [Float]
  ) : [Float] {
    let n = N_SHELLS;
    Array.tabulate<Float>(n * n, func(k) {
      let i = k / n;
      let j = k % n;
      if (i < activations.size() and j < activations.size() and
          i < phases.size() and j < phases.size()) {
        entanglaElement(activations[i], activations[j], phases[i], phases[j])
      } else { 0.0 }
    })
  };

  // Compute mean entanglement
  public func computeMeanEntanglement(matrix : [Float]) : Float {
    var sum : Float = 0.0;
    for (e in matrix.vals()) {
      sum += _fabs(e);
    };
    sum / Float.fromInt(matrix.size())
  };

  // Check BYPASS gate activation
  public func checkBypassGate(meanEntanglement : Float, threshold : Float) : Bool {
    meanEntanglement > threshold
  };

  // ============================================================
  // FULL COHERENCE UPDATE
  // ============================================================

  public func updateCoherenceState(
    state : CoherenceState,
    shellActivations : [Float],
    shellPhases : [Float],
    blockValues : [[Float]],
    coherenceC : Float,
    cAdj : Float,
    dt : Float
  ) : CoherenceState {
    // Mechanism 1: Kuramoto
    let newHzPhases = updateHzPhases(state.hzPhases, HZ_FREQUENCIES, 0.618, dt);
    let newKfHz = computeKuramotoR(newHzPhases);

    // Mechanism 2: PAC
    let (newPrimaryAmps, newSkipAmps) = updatePACAmplitudes(shellActivations, shellPhases);

    // Mechanism 4: H_obs
    let (newHObs, newBlockEntropies) = computeHObs(blockValues);
    let newActiveDims = computeActiveDimensions(newHObs);

    // Mechanism 5: Demon Yield
    let newDemonYield = computeDemonYield(newHObs, state.hObsPrev, coherenceC, cAdj);

    // Mechanism 6: Temporal Dilation
    let shellsResonant = checkShellsResonant(shellActivations, 0.5);
    let newDilation = computeTemporalDilation(
      coherenceC,
      state.veritasOperator,
      state.resonexAlign,
      shellsResonant
    );

    // Mechanism 7: ENTANGLA
    let newMatrix = computeEntanglaMatrix(shellActivations, shellPhases);
    let newMeanEntangle = computeMeanEntanglement(newMatrix);
    let newBypass = checkBypassGate(newMeanEntangle, 0.7);

    {
      kfHz = newKfHz;
      hzPhases = newHzPhases;
      pacPrimaryAmps = newPrimaryAmps;
      pacSkipAmps = newSkipAmps;
      hObs = newHObs;
      blockEntropies = newBlockEntropies;
      activeDimensions = newActiveDims;
      demonYield = newDemonYield;
      hObsPrev = newHObs;
      dilationFactor = newDilation;
      temporalCoherence = coherenceC;
      veritasOperator = state.veritasOperator;
      resonexAlign = state.resonexAlign;
      entanglaMatrix = newMatrix;
      meanEntanglement = newMeanEntangle;
      bypassActive = newBypass;
    }
  };

  // ============================================================
  // GLOBAL COHERENCE COMPUTATION
  // coherenceC = 0.3 × kfHz + 0.2 × pacMean + 0.2 × shellMean + 0.15 × (1 - freeEnergy) + 0.15 × entangleMean
  // ============================================================

  public func computeGlobalCoherence(
    kfHz : Float,
    pacAmps : [Float],
    shellActivations : [Float],
    freeEnergy : Float,
    meanEntanglement : Float
  ) : Float {
    // PAC mean
    var pacSum : Float = 0.0;
    for (a in pacAmps.vals()) { pacSum += a };
    let pacMean = pacSum / Float.fromInt(Nat.max(1, pacAmps.size()));

    // Shell mean
    var shellSum : Float = 0.0;
    for (s in shellActivations.vals()) { shellSum += s };
    let shellMean = shellSum / Float.fromInt(Nat.max(1, shellActivations.size()));

    // Combine
    let coherence = 0.30 * kfHz +
                    0.20 * _clamp(pacMean, 0.0, 1.0) +
                    0.20 * _clamp(shellMean, 0.0, 1.0) +
                    0.15 * (1.0 - _clamp(freeEnergy, 0.0, 1.0)) +
                    0.15 * _clamp(meanEntanglement, 0.0, 1.0);

    _clamp(coherence, 0.0, 1.0)
  };

  // ============================================================
  // FULL SYSTEM UPDATE
  // ============================================================

  public func beatPredictiveCoding(
    state : PredictiveCodingState,
    newDomainValues : [Float],
    rewards : [Float],
    shellActivations : [Float],
    shellPhases : [Float],
    blockValues : [[Float]],
    velaDivergenceScore : Float,
    cAdj : Float,
    dt : Float
  ) : PredictiveCodingState {
    // Update domains
    let newDomains = updateDomainState(state.domains, newDomainValues, velaDivergenceScore);

    // Update TD learning
    let newTD = updateTDLearning(state.tdLearning, rewards, state.coherenceC);

    // Update shells
    let newShells = {
      activations = shellActivations;
      phases = shellPhases;
      learningRates = Array.tabulate<Float>(N_SHELLS, func(i) {
        if (i < HELIX_ALPHA.size() and i < BDNF_MODULATION.size()) {
          HELIX_ALPHA[i] * BDNF_MODULATION[i]
        } else { 0.01 }
      });
    };

    // Update coherence mechanisms
    let newCoherence = updateCoherenceState(
      state.coherence,
      shellActivations,
      shellPhases,
      blockValues,
      state.coherenceC,
      cAdj,
      dt
    );

    // Compute new global coherence
    let newCoherenceC = computeGlobalCoherence(
      newCoherence.kfHz,
      newCoherence.pacPrimaryAmps,
      shellActivations,
      newDomains.freeEnergy,
      newCoherence.meanEntanglement
    );

    {
      domains = newDomains;
      tdLearning = newTD;
      shells = newShells;
      coherence = newCoherence;
      coherenceC = newCoherenceC;
      beatNum = state.beatNum + 1;
    }
  };

  // ============================================================
  // INITIALIZATION
  // ============================================================

  public func initDomainState() : DomainState {
    {
      domain = Array.tabulate<Float>(N_DOMAINS, func(_) { S0 });
      pred = Array.tabulate<Float>(N_DOMAINS, func(_) { S0 });
      errors = Array.tabulate<Float>(N_DOMAINS, func(_) { 0.0 });
      freeEnergy = 0.0;
      arousal = 0.0;
      salience = 0.0;
      beatNum = 0;
    }
  };

  public func initTDLearningState() : TDLearningState {
    {
      valueEstimates = Array.tabulate<Float>(N_CORES, func(_) { 0.5 });
      coreCoherence = Array.tabulate<Float>(N_CORES, func(_) { 0.5 });
      tdDeltas = Array.tabulate<Float>(N_CORES, func(_) { 0.0 });
      rewardHistory = [];
      hzActivations = Array.tabulate<Float>(N_HZ_NODES, func(_) { 0.5 });
    }
  };

  public func initShellState() : ShellState {
    {
      activations = Array.tabulate<Float>(N_SHELLS, func(_) { 0.5 });
      phases = Array.tabulate<Float>(N_SHELLS, func(i) {
        Float.fromInt(i) * TWO_PI / Float.fromInt(N_SHELLS)
      });
      learningRates = Array.tabulate<Float>(N_SHELLS, func(i) {
        if (i < HELIX_ALPHA.size()) HELIX_ALPHA[i] else 0.01
      });
    }
  };

  public func initCoherenceState() : CoherenceState {
    {
      kfHz = 0.5;
      hzPhases = Array.tabulate<Float>(N_HZ_NODES, func(i) {
        Float.fromInt(i) * TWO_PI / Float.fromInt(N_HZ_NODES)
      });
      pacPrimaryAmps = Array.tabulate<Float>(10, func(_) { 0.5 });
      pacSkipAmps = Array.tabulate<Float>(9, func(_) { 0.5 });
      hObs = 6.0;
      blockEntropies = Array.tabulate<Float>(8, func(_) { 2.0 });
      activeDimensions = 64.0;
      demonYield = 0.0;
      hObsPrev = 6.0;
      dilationFactor = 1.0;
      temporalCoherence = 0.5;
      veritasOperator = 0.5;
      resonexAlign = 0.5;
      entanglaMatrix = Array.tabulate<Float>(121, func(k) {
        let i = k / 11;
        let j = k % 11;
        if (i == j) 1.0 else 0.5
      });
      meanEntanglement = 0.5;
      bypassActive = false;
    }
  };

  public func initPredictiveCodingState() : PredictiveCodingState {
    {
      domains = initDomainState();
      tdLearning = initTDLearningState();
      shells = initShellState();
      coherence = initCoherenceState();
      coherenceC = 0.5;
      beatNum = 0;
    }
  };

  // ============================================================
  // SUMMARY TYPES
  // ============================================================

  public type DomainSummary = {
    freeEnergy   : Float;
    arousal      : Float;
    salience     : Float;
    domainErrors : [Float];
  };

  public type CoherenceSummary = {
    coherenceC       : Float;
    kfHz             : Float;
    hObs             : Float;
    activeDimensions : Float;
    demonYield       : Float;
    dilationFactor   : Float;
    meanEntanglement : Float;
    bypassActive     : Bool;
  };

  public type PredictiveCodingSummary = {
    domains   : DomainSummary;
    coherence : CoherenceSummary;
    beatNum   : Nat;
  };

  public func summary(state : PredictiveCodingState) : PredictiveCodingSummary {
    {
      domains = {
        freeEnergy = state.domains.freeEnergy;
        arousal = state.domains.arousal;
        salience = state.domains.salience;
        domainErrors = state.domains.errors;
      };
      coherence = {
        coherenceC = state.coherenceC;
        kfHz = state.coherence.kfHz;
        hObs = state.coherence.hObs;
        activeDimensions = state.coherence.activeDimensions;
        demonYield = state.coherence.demonYield;
        dilationFactor = state.coherence.dilationFactor;
        meanEntanglement = state.coherence.meanEntanglement;
        bypassActive = state.coherence.bypassActive;
      };
      beatNum = state.beatNum;
    }
  };

  // ============================================================
  // PREDICTIVE PROCESSING HIERARCHIES — FULL EXPLICIT MATH
  // Multiple levels of generative models
  // ============================================================

  // Hierarchical prediction error
  // ε[l] = observation[l] - prediction[l-1→l]
  // Each level receives predictions from above and observations from below

  public type HierarchicalLevel = {
    levelIndex      : Nat;
    
    // State estimates
    mu              : [Float];     // Mean estimates (beliefs)
    sigma           : [Float];     // Precision (inverse variance)
    
    // Predictions
    predictionDown  : [Float];     // Prediction to level below
    predictionUp    : [Float];     // Prediction to level above
    
    // Errors
    errorDown       : [Float];     // Error from level below
    errorUp         : [Float];     // Error from level above
    
    // Generalized coordinates
    mu_d            : [Float];     // First derivative (velocity)
    mu_dd           : [Float];     // Second derivative (acceleration)
    
    // Learning rates
    learningRate    : Float;
    precisionLearningRate : Float;
  };

  public type HierarchicalPPCState = {
    levels          : [HierarchicalLevel];
    nLevels         : Nat;
    dimPerLevel     : Nat;
    
    // Global metrics
    totalFE         : Float;       // Total variational free energy
    totalComplexity : Float;       // KL divergence from priors
    totalInaccuracy : Float;       // Prediction error cost
    
    // Precision weighting
    precisionMatrix : [[Float]];   // Level × Level precision coupling
    
    beatNum         : Nat;
  };

  // Initialize hierarchical predictive processing
  public func initHierarchicalPPC(nLevels : Nat, dimPerLevel : Nat) : HierarchicalPPCState {
    let levels = Array.tabulate<HierarchicalLevel>(nLevels, func(l) {
      {
        levelIndex = l;
        mu = Array.tabulate<Float>(dimPerLevel, func(_) { 0.5 });
        sigma = Array.tabulate<Float>(dimPerLevel, func(_) { 1.0 });
        predictionDown = Array.tabulate<Float>(dimPerLevel, func(_) { 0.5 });
        predictionUp = Array.tabulate<Float>(dimPerLevel, func(_) { 0.5 });
        errorDown = Array.tabulate<Float>(dimPerLevel, func(_) { 0.0 });
        errorUp = Array.tabulate<Float>(dimPerLevel, func(_) { 0.0 });
        mu_d = Array.tabulate<Float>(dimPerLevel, func(_) { 0.0 });
        mu_dd = Array.tabulate<Float>(dimPerLevel, func(_) { 0.0 });
        learningRate = 0.1 / Float.fromInt(l + 1);  // Higher levels learn slower
        precisionLearningRate = 0.05 / Float.fromInt(l + 1);
      }
    });
    
    let precMatrix = Array.tabulate<[Float]>(nLevels, func(i) {
      Array.tabulate<Float>(nLevels, func(j) {
        if (i == j) { 1.0 }
        else if (Int.abs(i - j) == 1) { 0.5 }  // Adjacent levels
        else { 0.1 }
      })
    });
    
    {
      levels = levels;
      nLevels = nLevels;
      dimPerLevel = dimPerLevel;
      totalFE = 0.0;
      totalComplexity = 0.0;
      totalInaccuracy = 0.0;
      precisionMatrix = precMatrix;
      beatNum = 0;
    }
  };

  // Compute prediction error at a level
  // ε = Π × (x - g(μ))
  // where Π is precision, x is observation, g(μ) is prediction
  public func computeLevelError(
    observation : [Float],
    prediction : [Float],
    precision : [Float]
  ) : [Float] {
    let n = observation.size();
    Array.tabulate<Float>(n, func(i) {
      let obs = if (i < observation.size()) { observation[i] } else { 0.0 };
      let pred = if (i < prediction.size()) { prediction[i] } else { 0.0 };
      let prec = if (i < precision.size()) { precision[i] } else { 1.0 };
      prec * (obs - pred)
    })
  };

  // Update belief at a level using gradient descent on prediction error
  // dμ/dt = D × μ_d + Π × ε - D' × Π × ε_d
  // D is derivative operator, D' is transpose
  public func updateLevelBelief(
    level : HierarchicalLevel,
    errorBelow : [Float],
    errorAbove : [Float],
    dt : Float
  ) : HierarchicalLevel {
    let n = level.mu.size();
    var newMu = Array.init<Float>(n, 0.0);
    var newMu_d = Array.init<Float>(n, 0.0);
    var newMu_dd = Array.init<Float>(n, 0.0);
    var newSigma = Array.init<Float>(n, 0.0);
    
    var i = 0;
    while (i < n) {
      // Gradient from errors below and above
      let errB = if (i < errorBelow.size()) { errorBelow[i] } else { 0.0 };
      let errA = if (i < errorAbove.size()) { errorAbove[i] } else { 0.0 };
      
      // Total gradient: balance between top-down and bottom-up
      let gradient = errB * level.sigma[i] - errA * 0.5;
      
      // Update mean
      newMu[i] := level.mu[i] + level.learningRate * gradient * dt;
      
      // Update velocity (generalized coordinates)
      newMu_d[i] := level.mu_d[i] + (newMu[i] - level.mu[i]) / dt * 0.1;
      
      // Update acceleration
      newMu_dd[i] := level.mu_dd[i] + (newMu_d[i] - level.mu_d[i]) / dt * 0.1;
      
      // Update precision based on error magnitude
      let errMag = Float.abs(errB) + Float.abs(errA);
      newSigma[i] := _clamp(level.sigma[i] + level.precisionLearningRate * (1.0 / (errMag + 0.1) - level.sigma[i]), 0.1, 10.0);
      
      i += 1;
    };
    
    {
      level with
      mu = Array.freeze(newMu);
      mu_d = Array.freeze(newMu_d);
      mu_dd = Array.freeze(newMu_dd);
      sigma = Array.freeze(newSigma);
    }
  };

  // Full hierarchical update pass
  public func hierarchicalPPCBeat(
    state : HierarchicalPPCState,
    sensoryInput : [Float],
    dt : Float
  ) : HierarchicalPPCState {
    let nLevels = state.levels.size();
    var newLevels = Array.thaw<HierarchicalLevel>(state.levels);
    
    // Bottom-up pass: propagate errors upward
    var l = 0;
    while (l < nLevels) {
      let observation = if (l == 0) {
        sensoryInput
      } else {
        newLevels[l - 1].predictionUp
      };
      
      let prediction = newLevels[l].predictionDown;
      let errorDown = computeLevelError(observation, prediction, newLevels[l].sigma);
      
      newLevels[l] := { newLevels[l] with errorDown = errorDown };
      l += 1;
    };
    
    // Top-down pass: propagate predictions downward
    l := nLevels - 1;
    while (l >= 0) {
      let errorAbove = if (l == nLevels - 1) {
        Array.tabulate<Float>(state.dimPerLevel, func(_) { 0.0 })
      } else {
        newLevels[l + 1].errorDown
      };
      
      // Update beliefs
      newLevels[l] := updateLevelBelief(newLevels[l], newLevels[l].errorDown, errorAbove, dt);
      
      // Generate new predictions
      let newPredDown = Array.tabulate<Float>(state.dimPerLevel, func(i) {
        newLevels[l].mu[i]  // Prediction is current belief
      });
      let newPredUp = Array.tabulate<Float>(state.dimPerLevel, func(i) {
        newLevels[l].mu[i] + newLevels[l].mu_d[i] * dt
      });
      
      newLevels[l] := { newLevels[l] with predictionDown = newPredDown; predictionUp = newPredUp };
      
      if (l == 0) { l := -1 } else { l -= 1 };
    };
    
    // Compute total free energy
    var totalFE : Float = 0.0;
    var totalComplexity : Float = 0.0;
    var totalInaccuracy : Float = 0.0;
    
    for (level in newLevels.vals()) {
      for (err in level.errorDown.vals()) {
        totalInaccuracy += err * err;
      };
      // Complexity: KL divergence from prior (simplified)
      for (i in level.mu.keys()) {
        let diff = level.mu[i] - 0.5;  // Prior is 0.5
        totalComplexity += 0.5 * level.sigma[i] * diff * diff;
      };
    };
    totalFE := totalComplexity + totalInaccuracy;
    
    {
      state with
      levels = Array.freeze(newLevels);
      totalFE = totalFE;
      totalComplexity = totalComplexity;
      totalInaccuracy = totalInaccuracy;
      beatNum = state.beatNum + 1;
    }
  };

  // ============================================================
  // PRECISION WEIGHTING — ATTENTION ALLOCATION
  // ============================================================

  // Precision represents confidence in a prediction
  // High precision = reliable channel, gets more attention
  // Low precision = unreliable, less attention

  public type AttentionState = {
    precisionWeights : [Float];    // Weight for each sensory channel
    attentionFocus   : Nat;        // Index of most attended channel
    attentionSpread  : Float;      // How distributed attention is [0, 1]
    volatility       : Float;      // Environmental uncertainty
    
    // Precision dynamics
    expectedPrecision   : [Float];
    precisionPredError  : Float;
  };

  // Softmax attention allocation
  public func allocateAttention(precisions : [Float], temperature : Float) : [Float] {
    let n = precisions.size();
    var maxP : Float = -1000.0;
    for (p in precisions.vals()) {
      if (p > maxP) { maxP := p };
    };
    
    var expSum : Float = 0.0;
    let exps = Array.init<Float>(n, 0.0);
    var i = 0;
    while (i < n) {
      exps[i] := Float.exp((precisions[i] - maxP) / temperature);
      expSum += exps[i];
      i += 1;
    };
    
    if (expSum < 1.0e-10) {
      return Array.tabulate<Float>(n, func(_) { 1.0 / Float.fromInt(n) });
    };
    
    Array.tabulate<Float>(n, func(j) { exps[j] / expSum })
  };

  // Compute attention entropy (measure of spread)
  // H = -Σ p × log(p)
  public func attentionEntropy(weights : [Float]) : Float {
    var entropy : Float = 0.0;
    for (w in weights.vals()) {
      if (w > 1.0e-10) {
        entropy -= w * Float.log(w);
      };
    };
    entropy
  };

  // Update attention based on prediction errors
  public func updateAttention(
    state : AttentionState,
    errors : [Float],
    learningRate : Float
  ) : AttentionState {
    let n = state.precisionWeights.size();
    var newPrecisions = Array.init<Float>(n, 0.0);
    
    var i = 0;
    while (i < n) {
      let err = if (i < errors.size()) { errors[i] } else { 0.0 };
      // Precision decreases when errors are large
      // π(t+1) = π(t) × (1 - lr × |ε|)
      newPrecisions[i] := _clamp(
        state.precisionWeights[i] * (1.0 - learningRate * Float.abs(err)),
        0.1,
        10.0
      );
      i += 1;
    };
    
    let weights = allocateAttention(Array.freeze(newPrecisions), 1.0);
    let entropy = attentionEntropy(weights);
    let maxEntropy = Float.log(Float.fromInt(n));
    let spread = entropy / maxEntropy;
    
    // Find focus (max weight index)
    var maxWeight : Float = 0.0;
    var focusIdx : Nat = 0;
    i := 0;
    for (w in weights.vals()) {
      if (w > maxWeight) {
        maxWeight := w;
        focusIdx := i;
      };
      i += 1;
    };
    
    {
      precisionWeights = Array.freeze(newPrecisions);
      attentionFocus = focusIdx;
      attentionSpread = spread;
      volatility = state.volatility;
      expectedPrecision = state.expectedPrecision;
      precisionPredError = Float.abs(state.precisionWeights[focusIdx] - state.expectedPrecision[focusIdx]);
    }
  };

  // ============================================================
  // TEMPORAL DIFFERENCE LEARNING — FULL EXPLICIT
  // ============================================================

  // TD error: δ = r + γ × V(s') - V(s)
  // Value update: V(s) ← V(s) + α × δ

  // TD(λ) with eligibility traces
  // e(s) ← γλ × e(s) + ∇V(s)
  // V(s) ← V(s) + α × δ × e(s)

  public type TDLambdaState = {
    values          : [Float];     // State values V(s)
    eligibility     : [Float];     // Eligibility traces e(s)
    gamma           : Float;       // Discount factor
    lambda          : Float;       // Trace decay
    alpha           : Float;       // Learning rate
    lastState       : Nat;
    lastReward      : Float;
    totalReward     : Float;
    episodeReturns  : [Float];     // History of episode returns
  };

  public func initTDLambda(nStates : Nat, gamma : Float, lambda : Float, alpha : Float) : TDLambdaState {
    {
      values = Array.tabulate<Float>(nStates, func(_) { 0.0 });
      eligibility = Array.tabulate<Float>(nStates, func(_) { 0.0 });
      gamma = gamma;
      lambda = lambda;
      alpha = alpha;
      lastState = 0;
      lastReward = 0.0;
      totalReward = 0.0;
      episodeReturns = [];
    }
  };

  // Compute TD error
  public func computeTDError(
    state : TDLambdaState,
    currentState : Nat,
    nextState : Nat,
    reward : Float,
    terminal : Bool
  ) : Float {
    let vCurrent = if (currentState < state.values.size()) { state.values[currentState] } else { 0.0 };
    let vNext = if (terminal) { 0.0 }
                else if (nextState < state.values.size()) { state.values[nextState] }
                else { 0.0 };
    
    reward + state.gamma * vNext - vCurrent
  };

  // TD(λ) update step
  public func tdLambdaStep(
    state : TDLambdaState,
    currentState : Nat,
    nextState : Nat,
    reward : Float,
    terminal : Bool
  ) : TDLambdaState {
    let delta = computeTDError(state, currentState, nextState, reward, terminal);
    let nStates = state.values.size();
    
    var newValues = Array.init<Float>(nStates, 0.0);
    var newEligibility = Array.init<Float>(nStates, 0.0);
    
    var i = 0;
    while (i < nStates) {
      // Decay eligibility
      newEligibility[i] := state.gamma * state.lambda * state.eligibility[i];
      
      // Accumulating traces: add 1 for current state
      if (i == currentState) {
        newEligibility[i] += 1.0;
      };
      
      // Update value
      newValues[i] := state.values[i] + state.alpha * delta * newEligibility[i];
      
      i += 1;
    };
    
    // Reset eligibility on terminal
    if (terminal) {
      i := 0;
      while (i < nStates) {
        newEligibility[i] := 0.0;
        i += 1;
      };
    };
    
    {
      state with
      values = Array.freeze(newValues);
      eligibility = Array.freeze(newEligibility);
      lastState = nextState;
      lastReward = reward;
      totalReward = state.totalReward + reward;
    }
  };

  // ============================================================
  // SUCCESSOR REPRESENTATION — PREDICTIVE STATE REPRESENTATION
  // ============================================================

  // M(s, s') = E[Σ γ^t × I(s_t = s') | s_0 = s]
  // Successor representation: expected discounted occupancy

  public type SuccessorRepState = {
    sr              : [[Float]];   // Successor matrix M[s][s']
    nStates         : Nat;
    gamma           : Float;
    alpha           : Float;
  };

  public func initSuccessorRep(nStates : Nat, gamma : Float, alpha : Float) : SuccessorRepState {
    // Initialize SR as identity (each state predicts itself)
    let sr = Array.tabulate<[Float]>(nStates, func(i) {
      Array.tabulate<Float>(nStates, func(j) {
        if (i == j) { 1.0 / (1.0 - gamma) } else { 0.0 }
      })
    });
    {
      sr = sr;
      nStates = nStates;
      gamma = gamma;
      alpha = alpha;
    }
  };

  // Update SR with TD learning
  // M(s, s') ← M(s, s') + α × (I(s = s') + γ × M(s', ·) - M(s, s'))
  public func updateSuccessorRep(
    state : SuccessorRepState,
    currentState : Nat,
    nextState : Nat
  ) : SuccessorRepState {
    let n = state.nStates;
    var newSR = Array.init<[Float]>(n, Array.tabulate<Float>(n, func(_) { 0.0 }));
    
    // Copy existing SR
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        newSR[i] := Array.thaw<Float>(state.sr[i]);
        j += 1;
      };
      i += 1;
    };
    
    // Update row for current state
    if (currentState < n) {
      var mutableRow = Array.thaw<Float>(state.sr[currentState]);
      var j = 0;
      while (j < n) {
        let indicator : Float = if (currentState == j) { 1.0 } else { 0.0 };
        let nextSR = if (nextState < n) { state.sr[nextState][j] } else { 0.0 };
        let currentSR = state.sr[currentState][j];
        
        mutableRow[j] := currentSR + state.alpha * (indicator + state.gamma * nextSR - currentSR);
        j += 1;
      };
      newSR[currentState] := Array.freeze(mutableRow);
    };
    
    {
      state with
      sr = Array.freeze(newSR);
    }
  };

  // Compute value from SR and reward function
  // V(s) = Σ_s' M(s, s') × R(s')
  public func srValue(
    state : SuccessorRepState,
    rewards : [Float],
    queryState : Nat
  ) : Float {
    if (queryState >= state.nStates) { return 0.0 };
    
    var value : Float = 0.0;
    var j = 0;
    while (j < state.nStates) {
      let r = if (j < rewards.size()) { rewards[j] } else { 0.0 };
      value += state.sr[queryState][j] * r;
      j += 1;
    };
    value
  };

}

