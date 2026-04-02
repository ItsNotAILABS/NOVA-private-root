// ============================================================
// FREQUENCY-LAYERED COGNITIVE ARCHITECTURE
// 5 FREQUENCY BANDS WITH CROSS-FREQUENCY COUPLING
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// DOCTRINE:
// Gamma (30-100 Hz) ──── Real-time inference, live alerts, agent binding
//        ↕ coupling
// Beta  (14-30 Hz)  ──── Proactive preparation, pre-fetch, agent queue
//        ↕ coupling
// Alpha  (8-14 Hz)  ──── Attention gating, UI suppression, mode switching
//        ↕ coupling
// Theta  (4-8 Hz)   ──── Agent orchestration, working memory, phase cycles
//        ↕ coupling
// Delta  (0.5-4 Hz) ──── Deep memory, blockchain persistence, consolidation
//
// CROSS-FREQUENCY COUPLING LAW:
// Agents fire at Gamma, synchronize at Theta phase completion, consolidate to Delta.
// This is theta-gamma coupling — the dopamine reward architecture.
// Floor completion = visible reward signal. Won bid = cascade across all frequency layers.
//
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ============================================================
  // FREQUENCY BAND CONSTANTS
  // ============================================================

  public let PI  : Float = 3.14159265358979323846;
  public let TAU : Float = 6.28318530717958647692;

  // Gamma band (30-100 Hz) — Real-time inference
  public let GAMMA_MIN : Float = 30.0;
  public let GAMMA_MAX : Float = 100.0;
  public let GAMMA_CENTER : Float = 65.0;

  // Beta band (14-30 Hz) — Proactive preparation
  public let BETA_MIN : Float = 14.0;
  public let BETA_MAX : Float = 30.0;
  public let BETA_CENTER : Float = 22.0;

  // Alpha band (8-14 Hz) — Attention gating
  public let ALPHA_MIN : Float = 8.0;
  public let ALPHA_MAX : Float = 14.0;
  public let ALPHA_CENTER : Float = 11.0;

  // Theta band (4-8 Hz) — Agent orchestration
  public let THETA_MIN : Float = 4.0;
  public let THETA_MAX : Float = 8.0;
  public let THETA_CENTER : Float = 6.0;

  // Delta band (0.5-4 Hz) — Deep memory
  public let DELTA_MIN : Float = 0.5;
  public let DELTA_MAX : Float = 4.0;
  public let DELTA_CENTER : Float = 2.25;

  // ============================================================
  // TYPES
  // ============================================================

  public type FrequencyBand = {
    #Gamma;
    #Beta;
    #Alpha;
    #Theta;
    #Delta;
  };

  // State for a single frequency band
  public type BandState = {
    band          : FrequencyBand;
    frequency     : Float;         // Current frequency in Hz
    phase         : Float;         // Current phase [0, 2π]
    amplitude     : Float;         // Signal strength [0, 1]
    power         : Float;         // Power = amplitude²
    
    // Burst detection
    burstActive   : Bool;
    burstStart    : Nat;
    burstDuration : Nat;
    burstCount    : Nat;           // Total bursts this session
    
    // Phase-amplitude coupling
    coupledTo     : ?FrequencyBand;
    couplingStrength : Float;
  };

  // Cross-frequency coupling state
  public type CouplingState = {
    // Theta-Gamma coupling (primary)
    thetaGammaMI      : Float;     // Modulation index
    thetaGammaPhase   : Float;     // Preferred theta phase for gamma bursts
    
    // Delta-Theta coupling
    deltaThetaMI      : Float;
    deltaThetaPhase   : Float;
    
    // Alpha-Beta coupling
    alphaBetaMI       : Float;
    alphaBetaPhase    : Float;
    
    // Phase-amplitude coupling matrix (5×5)
    couplingMatrix    : [[Float]];
  };

  // Full cognitive frequency state
  public type CognitiveFrequencyState = {
    // Individual bands
    gamma         : BandState;
    beta          : BandState;
    alpha         : BandState;
    theta         : BandState;
    delta         : BandState;
    
    // Cross-frequency coupling
    coupling      : CouplingState;
    
    // Global state
    dominantBand  : FrequencyBand;
    globalPower   : Float;
    coherence     : Float;         // Cross-band coherence
    
    // Functional states
    alertLevel    : Float;         // Gamma-driven
    preparationLevel : Float;      // Beta-driven
    attentionGate : Float;         // Alpha-driven
    workingMemoryLoad : Float;     // Theta-driven
    consolidationRate : Float;     // Delta-driven
    
    beatNum       : Nat;
  };

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _exp(x : Float) : Float { Float.exp(x) };

  // Wrap phase to [0, 2π]
  func wrapPhase(phase : Float) : Float {
    var p = phase;
    while (p >= TAU) { p -= TAU };
    while (p < 0.0) { p += TAU };
    p
  };

  // ============================================================
  // BAND FREQUENCY DYNAMICS
  // ============================================================

  // Get band limits
  public func getBandLimits(band : FrequencyBand) : (Float, Float, Float) {
    switch (band) {
      case (#Gamma) { (GAMMA_MIN, GAMMA_MAX, GAMMA_CENTER) };
      case (#Beta)  { (BETA_MIN, BETA_MAX, BETA_CENTER) };
      case (#Alpha) { (ALPHA_MIN, ALPHA_MAX, ALPHA_CENTER) };
      case (#Theta) { (THETA_MIN, THETA_MAX, THETA_CENTER) };
      case (#Delta) { (DELTA_MIN, DELTA_MAX, DELTA_CENTER) };
    }
  };

  // Compute instantaneous frequency within band
  // f(t) = f_center + (f_range/2) × sin(modulation_phase)
  public func bandFrequency(band : FrequencyBand, modulationPhase : Float) : Float {
    let (minF, maxF, centerF) = getBandLimits(band);
    let range = (maxF - minF) / 2.0;
    centerF + range * _sin(modulationPhase)
  };

  // ============================================================
  // PHASE EVOLUTION
  // ============================================================

  // Evolve phase for a single band
  // dφ/dt = 2πf
  public func evolvePhase(currentPhase : Float, frequency : Float, dt : Float) : Float {
    wrapPhase(currentPhase + TAU * frequency * dt)
  };

  // Evolve band state
  public func evolveBandState(
    state : BandState,
    dt : Float,
    amplitudeInput : Float
  ) : BandState {
    // Update phase
    let newPhase = evolvePhase(state.phase, state.frequency, dt);
    
    // Update amplitude with smoothing
    let ampSmooth = 0.9;
    let newAmp = ampSmooth * state.amplitude + (1.0 - ampSmooth) * amplitudeInput;
    
    // Power = amplitude²
    let newPower = newAmp * newAmp;
    
    // Burst detection: amplitude > 0.7 triggers burst
    let burstThreshold = 0.7;
    let burstNow = newAmp > burstThreshold;
    let newBurstActive = burstNow;
    let newBurstDuration = if (burstNow and state.burstActive) {
      state.burstDuration + 1
    } else if (burstNow) { 1 } else { 0 };
    let newBurstCount = if (burstNow and not state.burstActive) {
      state.burstCount + 1
    } else { state.burstCount };
    
    {
      state with
      phase = newPhase;
      amplitude = _clamp(newAmp, 0.0, 1.0);
      power = newPower;
      burstActive = newBurstActive;
      burstDuration = newBurstDuration;
      burstCount = newBurstCount;
    }
  };

  // ============================================================
  // THETA-GAMMA COUPLING — THE DOPAMINE REWARD ARCHITECTURE
  // ============================================================

  // Agents fire at Gamma, synchronize at Theta phase completion,
  // consolidate to Delta (stable canister memory).
  // This is theta-gamma coupling.
  // Floor completion = visible reward signal.
  // Won bid = cascade across all frequency layers.

  // Compute theta-gamma modulation index
  // MI = (max_gamma_amp - min_gamma_amp) / (max + min)
  public func computeThetaGammaMI(
    gammaAmplitudes : [Float],
    thetaPhases : [Float]
  ) : Float {
    if (gammaAmplitudes.size() == 0) { return 0.0 };
    
    var maxAmp : Float = 0.0;
    var minAmp : Float = 1.0;
    
    for (amp in gammaAmplitudes.vals()) {
      if (amp > maxAmp) { maxAmp := amp };
      if (amp < minAmp) { minAmp := amp };
    };
    
    if (maxAmp + minAmp < 0.001) { return 0.0 };
    (maxAmp - minAmp) / (maxAmp + minAmp)
  };

  // Compute preferred theta phase for gamma bursts
  // Returns theta phase at which gamma amplitude is maximal
  public func computePreferredThetaPhase(
    samples : [{ thetaPhase : Float; gammaAmp : Float }]
  ) : Float {
    if (samples.size() == 0) { return 0.0 };
    
    // Find sample with max gamma amplitude
    var maxAmp : Float = 0.0;
    var bestPhase : Float = 0.0;
    
    for (s in samples.vals()) {
      if (s.gammaAmp > maxAmp) {
        maxAmp := s.gammaAmp;
        bestPhase := s.thetaPhase;
      };
    };
    
    bestPhase
  };

  // Phase-amplitude coupling (PAC)
  // Gamma amplitude is modulated by theta phase
  // PAC = E[gamma_amp × exp(i × theta_phase)]
  public func computePAC(
    gammaAmplitudes : [Float],
    thetaPhases : [Float]
  ) : Float {
    let n = if (gammaAmplitudes.size() < thetaPhases.size()) {
      gammaAmplitudes.size()
    } else { thetaPhases.size() };
    
    if (n == 0) { return 0.0 };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    var i = 0;
    while (i < n) {
      sumCos += gammaAmplitudes[i] * _cos(thetaPhases[i]);
      sumSin += gammaAmplitudes[i] * _sin(thetaPhases[i]);
      i += 1;
    };
    
    let nf = Float.fromInt(n);
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  // ============================================================
  // CROSS-FREQUENCY COUPLING MATRIX
  // ============================================================

  // 5×5 coupling matrix: rows = amplitude carrier, cols = phase modulator
  // M[i][j] = how much band j's phase modulates band i's amplitude
  public let DEFAULT_COUPLING_MATRIX : [[Float]] = [
    // Gamma  Beta   Alpha  Theta  Delta
    [0.0,    0.2,   0.3,   0.7,   0.1],    // Gamma (modulated by theta primarily)
    [0.3,    0.0,   0.5,   0.3,   0.1],    // Beta (modulated by alpha)
    [0.1,    0.3,   0.0,   0.4,   0.2],    // Alpha (modulated by theta)
    [0.05,   0.1,   0.2,   0.0,   0.6],    // Theta (modulated by delta)
    [0.01,   0.02,  0.05,  0.1,   0.0]     // Delta (slow, less modulated)
  ];

  // Apply coupling: modulate amplitude based on other band's phase
  public func applyCoupling(
    state : CognitiveFrequencyState,
    couplingStrength : Float
  ) : CognitiveFrequencyState {
    let bands = [state.gamma, state.beta, state.alpha, state.theta, state.delta];
    let phases = [state.gamma.phase, state.beta.phase, state.alpha.phase, 
                  state.theta.phase, state.delta.phase];
    
    var newAmps = Array.init<Float>(5, 0.0);
    
    var i = 0;
    while (i < 5) {
      var modulation : Float = 0.0;
      var j = 0;
      while (j < 5) {
        // Amplitude modulation = coupling × cos(phase)
        modulation += DEFAULT_COUPLING_MATRIX[i][j] * _cos(phases[j]);
        j += 1;
      };
      
      // Apply modulation to amplitude
      newAmps[i] := _clamp(bands[i].amplitude * (1.0 + couplingStrength * modulation), 0.0, 1.0);
      i += 1;
    };
    
    {
      state with
      gamma = { state.gamma with amplitude = newAmps[0] };
      beta = { state.beta with amplitude = newAmps[1] };
      alpha = { state.alpha with amplitude = newAmps[2] };
      theta = { state.theta with amplitude = newAmps[3] };
      delta = { state.delta with amplitude = newAmps[4] };
    }
  };

  // ============================================================
  // FUNCTIONAL ROLES OF EACH BAND
  // ============================================================

  // GAMMA: Real-time inference, live alerts, agent binding
  // High gamma = system is actively processing, agents are firing
  public func gammaAlertLevel(gammaState : BandState) : Float {
    gammaState.amplitude * (if (gammaState.burstActive) { 1.5 } else { 1.0 })
  };

  // BETA: Proactive preparation, pre-fetch, agent queue
  // High beta = system is preparing for action, anticipating
  public func betaPreparationLevel(betaState : BandState) : Float {
    betaState.amplitude * betaState.power
  };

  // ALPHA: Attention gating, UI suppression, mode switching
  // High alpha = attention is focused, irrelevant info suppressed
  // This is an inverse gating: high alpha = relaxed, low alpha = focused
  public func alphaAttentionGate(alphaState : BandState) : Float {
    1.0 - alphaState.amplitude  // Inverse: low alpha = high attention
  };

  // THETA: Agent orchestration, working memory, phase cycles
  // High theta = working memory engaged, agents coordinating
  public func thetaWorkingMemoryLoad(thetaState : BandState) : Float {
    thetaState.amplitude * (1.0 + Float.fromInt(thetaState.burstCount) * 0.01)
  };

  // DELTA: Deep memory, blockchain persistence, consolidation
  // High delta = memory consolidation active, "sleeping" in sense
  public func deltaConsolidationRate(deltaState : BandState) : Float {
    deltaState.amplitude * deltaState.power * 2.0
  };

  // ============================================================
  // REWARD CASCADE — WON BID = CASCADE ACROSS ALL LAYERS
  // ============================================================

  // When a significant event occurs (floor completion, won bid),
  // it triggers a cascade through all frequency layers

  public type RewardEvent = {
    eventType : RewardType;
    magnitude : Float;      // [0, 1]
    timestamp : Nat;
  };

  public type RewardType = {
    #FloorCompletion;      // Visible reward signal
    #WonBid;               // Major achievement
    #MilestoneReached;
    #PatternRecognized;
    #TaskCompleted;
  };

  // Trigger reward cascade
  public func triggerRewardCascade(
    state : CognitiveFrequencyState,
    event : RewardEvent
  ) : CognitiveFrequencyState {
    // Reward magnitude
    let mag = event.magnitude;
    
    // Gamma: Immediate alert burst
    let newGamma = {
      state.gamma with
      amplitude = _clamp(state.gamma.amplitude + mag * 0.5, 0.0, 1.0);
      burstActive = true;
    };
    
    // Beta: Preparation boost
    let newBeta = {
      state.beta with
      amplitude = _clamp(state.beta.amplitude + mag * 0.3, 0.0, 1.0);
    };
    
    // Alpha: Attention sharpening (amplitude decreases for focus)
    let newAlpha = {
      state.alpha with
      amplitude = _clamp(state.alpha.amplitude - mag * 0.2, 0.0, 1.0);
    };
    
    // Theta: Working memory engagement
    let newTheta = {
      state.theta with
      amplitude = _clamp(state.theta.amplitude + mag * 0.4, 0.0, 1.0);
    };
    
    // Delta: Consolidation trigger
    let newDelta = {
      state.delta with
      amplitude = _clamp(state.delta.amplitude + mag * 0.2, 0.0, 1.0);
    };
    
    {
      state with
      gamma = newGamma;
      beta = newBeta;
      alpha = newAlpha;
      theta = newTheta;
      delta = newDelta;
    }
  };

  // ============================================================
  // AGENT FIRING AND SYNCHRONIZATION
  // ============================================================

  // Agent fires at gamma frequency
  // Must synchronize at theta phase completion
  public type AgentFiring = {
    agentId     : Nat;
    firingPhase : Float;      // Phase at which agent fires
    thetaPhase  : Float;      // Theta phase when fired
    synchronized: Bool;       // Did it sync with theta cycle?
  };

  // Check if agent firing is synchronized with theta
  // Firing is synchronized if it occurs near theta trough (phase ≈ π)
  public func isAgentSynchronized(
    firingThetaPhase : Float,
    tolerance : Float
  ) : Bool {
    let diff = Float.abs(firingThetaPhase - PI);
    diff < tolerance
  };

  // Compute synchronization quality for a set of agent firings
  public func computeSyncQuality(firings : [AgentFiring]) : Float {
    if (firings.size() == 0) { return 0.0 };
    
    var syncCount : Nat = 0;
    for (f in firings.vals()) {
      if (f.synchronized) { syncCount += 1 };
    };
    
    Float.fromInt(syncCount) / Float.fromInt(firings.size())
  };

  // ============================================================
  // FULL COGNITIVE FREQUENCY BEAT
  // ============================================================

  public func cognitiveFrequencyBeat(
    state : CognitiveFrequencyState,
    dt : Float,
    inputs : {
      gammaInput : Float;
      betaInput  : Float;
      alphaInput : Float;
      thetaInput : Float;
      deltaInput : Float;
    }
  ) : CognitiveFrequencyState {
    // Evolve each band
    let newGamma = evolveBandState(state.gamma, dt, inputs.gammaInput);
    let newBeta = evolveBandState(state.beta, dt, inputs.betaInput);
    let newAlpha = evolveBandState(state.alpha, dt, inputs.alphaInput);
    let newTheta = evolveBandState(state.theta, dt, inputs.thetaInput);
    let newDelta = evolveBandState(state.delta, dt, inputs.deltaInput);
    
    // Compute functional states
    let alertLevel = gammaAlertLevel(newGamma);
    let prepLevel = betaPreparationLevel(newBeta);
    let attGate = alphaAttentionGate(newAlpha);
    let wmLoad = thetaWorkingMemoryLoad(newTheta);
    let consRate = deltaConsolidationRate(newDelta);
    
    // Compute global power
    let globalPower = (newGamma.power + newBeta.power + newAlpha.power + 
                       newTheta.power + newDelta.power) / 5.0;
    
    // Determine dominant band
    let powers = [newGamma.power, newBeta.power, newAlpha.power, newTheta.power, newDelta.power];
    var maxPower : Float = 0.0;
    var domIdx : Nat = 0;
    var i = 0;
    for (p in powers.vals()) {
      if (p > maxPower) {
        maxPower := p;
        domIdx := i;
      };
      i += 1;
    };
    let dominant = switch (domIdx) {
      case 0 { #Gamma };
      case 1 { #Beta };
      case 2 { #Alpha };
      case 3 { #Theta };
      case _ { #Delta };
    };
    
    // Compute coherence (simplified: average pairwise phase coherence)
    let phases = [newGamma.phase, newBeta.phase, newAlpha.phase, newTheta.phase, newDelta.phase];
    var coherenceSum : Float = 0.0;
    var pairs : Nat = 0;
    i := 0;
    while (i < 5) {
      var j = i + 1;
      while (j < 5) {
        let phaseDiff = phases[i] - phases[j];
        coherenceSum += _cos(phaseDiff);
        pairs += 1;
        j += 1;
      };
      i += 1;
    };
    let coherence = (coherenceSum / Float.fromInt(pairs) + 1.0) / 2.0;  // Normalize to [0, 1]
    
    // Update theta-gamma coupling
    let tgMI = computeThetaGammaMI([newGamma.amplitude], [newTheta.phase]);
    
    let newCoupling = {
      state.coupling with
      thetaGammaMI = tgMI;
      thetaGammaPhase = newTheta.phase;
    };
    
    let newState = {
      gamma = newGamma;
      beta = newBeta;
      alpha = newAlpha;
      theta = newTheta;
      delta = newDelta;
      coupling = newCoupling;
      dominantBand = dominant;
      globalPower = globalPower;
      coherence = coherence;
      alertLevel = alertLevel;
      preparationLevel = prepLevel;
      attentionGate = attGate;
      workingMemoryLoad = wmLoad;
      consolidationRate = consRate;
      beatNum = state.beatNum + 1;
    };
    
    // Apply cross-frequency coupling
    applyCoupling(newState, 0.3)
  };

  // ============================================================
  // INITIALIZATION
  // ============================================================

  func initBandState(band : FrequencyBand) : BandState {
    let (_, _, center) = getBandLimits(band);
    {
      band = band;
      frequency = center;
      phase = 0.0;
      amplitude = 0.5;
      power = 0.25;
      burstActive = false;
      burstStart = 0;
      burstDuration = 0;
      burstCount = 0;
      coupledTo = null;
      couplingStrength = 0.0;
    }
  };

  public func initCognitiveFrequencyState() : CognitiveFrequencyState {
    {
      gamma = initBandState(#Gamma);
      beta = initBandState(#Beta);
      alpha = initBandState(#Alpha);
      theta = initBandState(#Theta);
      delta = initBandState(#Delta);
      coupling = {
        thetaGammaMI = 0.0;
        thetaGammaPhase = 0.0;
        deltaThetaMI = 0.0;
        deltaThetaPhase = 0.0;
        alphaBetaMI = 0.0;
        alphaBetaPhase = 0.0;
        couplingMatrix = DEFAULT_COUPLING_MATRIX;
      };
      dominantBand = #Alpha;
      globalPower = 0.25;
      coherence = 0.5;
      alertLevel = 0.5;
      preparationLevel = 0.5;
      attentionGate = 0.5;
      workingMemoryLoad = 0.5;
      consolidationRate = 0.5;
      beatNum = 0;
    }
  };

}
