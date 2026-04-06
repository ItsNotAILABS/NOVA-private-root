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
// NEUROEMERGENCE CORE — HEBBIAN PLASTICITY ENGINE
// Synaptic weight dynamics with STDP rules
// Basic Hebbian: Δw = η * pre * post
// STDP: Δw = A+ * exp(-Δt/τ+) if pre→post, A- * exp(Δt/τ-) if post→pre
// BCM sliding threshold: θ_M = E[post²]
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type Synapse = {
    weight     : Float;    // w ∈ [0, wMax]
    preIdx     : Nat;      // presynaptic neuron index
    postIdx    : Nat;      // postsynaptic neuron index
    lastPreSpike  : Nat;   // beat of last presynaptic spike
    lastPostSpike : Nat;   // beat of last postsynaptic spike
    eligibility   : Float; // eligibility trace for TD learning
  };

  public type Neuron = {
    activation : Float;    // current activation [0,1]
    threshold  : Float;    // BCM sliding threshold θ_M
    spikeHistory : [Nat];  // beat indices of recent spikes
    avgActivity  : Float;  // running average for BCM
  };

  public type HebbianState = {
    neurons     : [Neuron];
    synapses    : [Synapse];
    learningRate: Float;     // η
    stdpAPlus   : Float;     // A+ for LTP
    stdpAMinus  : Float;     // A- for LTD
    stdpTauPlus : Float;     // τ+ time constant
    stdpTauMinus: Float;     // τ- time constant
    wMax        : Float;     // maximum weight
    wMin        : Float;     // minimum weight
    bcmTau      : Float;     // BCM threshold decay
    beatNum     : Nat;
    totalLTP    : Float;     // cumulative potentiation
    totalLTD    : Float;     // cumulative depression
  };

  // ── Constants ─────────────────────────────────────────────────
  let DEFAULT_LR : Float = 0.01;
  let DEFAULT_A_PLUS : Float = 0.1;
  let DEFAULT_A_MINUS : Float = 0.12;  // Slightly stronger LTD
  let DEFAULT_TAU_PLUS : Float = 20.0;
  let DEFAULT_TAU_MINUS : Float = 20.0;
  let DEFAULT_W_MAX : Float = 2.0;
  let DEFAULT_W_MIN : Float = 0.0;
  let DEFAULT_BCM_TAU : Float = 100.0;

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Basic Hebbian Rule ────────────────────────────────────────
  // Δw = η * pre * post
  public func hebbianDelta(pre: Float, post: Float, lr: Float) : Float {
    lr * pre * post
  };

  // ── Oja's Rule (normalized Hebbian) ───────────────────────────
  // Δw = η * post * (pre - w * post)
  // Prevents unbounded weight growth
  public func ojaDelta(pre: Float, post: Float, w: Float, lr: Float) : Float {
    lr * post * (pre - w * post)
  };

  // ── STDP Window Function ──────────────────────────────────────
  // Δt = t_post - t_pre
  // If Δt > 0 (pre before post): LTP = A+ * exp(-Δt/τ+)
  // If Δt < 0 (post before pre): LTD = -A- * exp(Δt/τ-)
  public func stdpDelta(
    preSpikeTime: Nat, postSpikeTime: Nat,
    aPlus: Float, aMinus: Float,
    tauPlus: Float, tauMinus: Float
  ) : Float {
    let dt = Float.fromInt(postSpikeTime) - Float.fromInt(preSpikeTime);

    if (Float.abs(dt) < 0.001) { return 0.0 };

    if (dt > 0.0) {
      // Pre before post → LTP
      aPlus * Float.exp(-dt / tauPlus)
    } else {
      // Post before pre → LTD
      -aMinus * Float.exp(dt / tauMinus)
    }
  };

  // ── BCM Rule ──────────────────────────────────────────────────
  // Δw = η * pre * post * (post - θ_M)
  // θ_M = E[post²] — sliding threshold
  public func bcmDelta(pre: Float, post: Float, theta: Float, lr: Float) : Float {
    lr * pre * post * (post - theta)
  };

  // ── BCM Threshold Update ──────────────────────────────────────
  // θ_M(t+1) = θ_M(t) + (post² - θ_M(t)) / τ
  public func updateBCMThreshold(theta: Float, post: Float, tau: Float) : Float {
    theta + (post * post - theta) / tau
  };

  // ── Eligibility Trace Update ──────────────────────────────────
  // For TD learning: e(t+1) = γλe(t) + δ(pre*post)
  public func updateEligibility(e: Float, pre: Float, post: Float, gamma: Float, lambda: Float) : Float {
    gamma * lambda * e + pre * post
  };

  // ── Update Single Synapse ─────────────────────────────────────
  public func updateSynapse(
    syn: Synapse,
    preAct: Float, postAct: Float,
    currentBeat: Nat,
    state: HebbianState
  ) : (Synapse, Float, Float) {
    // Check for spike-timing dependent update
    var dwSTDP : Float = 0.0;
    if (syn.lastPreSpike > 0 and syn.lastPostSpike > 0) {
      dwSTDP := stdpDelta(
        syn.lastPreSpike, syn.lastPostSpike,
        state.stdpAPlus, state.stdpAMinus,
        state.stdpTauPlus, state.stdpTauMinus
      );
    };

    // Hebbian component
    let dwHebb = hebbianDelta(preAct, postAct, state.learningRate * 0.1);

    // Total weight change
    let dw = dwSTDP + dwHebb;
    let newWeight = _clamp(syn.weight + dw, state.wMin, state.wMax);

    // Track LTP/LTD
    let ltp = if (dw > 0.0) { dw } else { 0.0 };
    let ltd = if (dw < 0.0) { -dw } else { 0.0 };

    // Update spike times if activation crosses threshold
    let newPreSpike = if (preAct > 0.5) { currentBeat } else { syn.lastPreSpike };
    let newPostSpike = if (postAct > 0.5) { currentBeat } else { syn.lastPostSpike };

    // Eligibility trace decay
    let newEligibility = updateEligibility(syn.eligibility, preAct, postAct, 0.99, 0.9);

    ({
      weight = newWeight;
      preIdx = syn.preIdx;
      postIdx = syn.postIdx;
      lastPreSpike = newPreSpike;
      lastPostSpike = newPostSpike;
      eligibility = newEligibility;
    }, ltp, ltd)
  };

  // ── Update Neuron ─────────────────────────────────────────────
  public func updateNeuron(
    neuron: Neuron, newActivation: Float, currentBeat: Nat, bcmTau: Float
  ) : Neuron {
    // Update BCM threshold
    let newTheta = updateBCMThreshold(neuron.threshold, newActivation, bcmTau);

    // Update running average
    let newAvg = 0.99 * neuron.avgActivity + 0.01 * newActivation;

    // Update spike history if spiking
    let newHistory = if (newActivation > 0.5) {
      if (neuron.spikeHistory.size() >= 20) {
        let tail = Array.tabulate<Nat>(19, func(i) { neuron.spikeHistory[i + 1] });
        Array.append<Nat>(tail, [currentBeat])
      } else {
        Array.append<Nat>(neuron.spikeHistory, [currentBeat])
      }
    } else {
      neuron.spikeHistory
    };

    {
      activation = newActivation;
      threshold = newTheta;
      spikeHistory = newHistory;
      avgActivity = newAvg;
    }
  };

  // ── Full Network Update ───────────────────────────────────────
  public func beatHebbian(
    state: HebbianState, inputs: [Float]
  ) : HebbianState {
    let nNeurons = state.neurons.size();
    let nInputs = if (inputs.size() < nNeurons) { inputs.size() } else { nNeurons };

    // Update neuron activations (simple weighted sum + sigmoid)
    var newNeurons = Array.thaw<Neuron>(state.neurons);
    var i = 0;
    while (i < nNeurons) {
      // Sum weighted inputs
      var sumInput : Float = 0.0;
      for (syn in state.synapses.vals()) {
        if (syn.postIdx == i) {
          let preAct = if (syn.preIdx < nNeurons) {
            state.neurons[syn.preIdx].activation
          } else { 0.0 };
          sumInput += syn.weight * preAct;
        };
      };

      // Add external input if available
      if (i < nInputs) {
        sumInput += inputs[i];
      };

      // Sigmoid activation
      let newAct = 1.0 / (1.0 + Float.exp(-5.0 * (sumInput - 0.5)));
      newNeurons[i] := updateNeuron(state.neurons[i], newAct, state.beatNum + 1, state.bcmTau);
      i += 1;
    };

    // Update synapses
    var newSynapses = Array.thaw<Synapse>(state.synapses);
    var totalLTP : Float = state.totalLTP;
    var totalLTD : Float = state.totalLTD;

    i := 0;
    while (i < state.synapses.size()) {
      let syn = state.synapses[i];
      let preAct = if (syn.preIdx < nNeurons) { newNeurons[syn.preIdx].activation } else { 0.0 };
      let postAct = if (syn.postIdx < nNeurons) { newNeurons[syn.postIdx].activation } else { 0.0 };

      let (updatedSyn, ltp, ltd) = updateSynapse(
        syn, preAct, postAct, state.beatNum + 1, state
      );
      newSynapses[i] := updatedSyn;
      totalLTP += ltp;
      totalLTD += ltd;
      i += 1;
    };

    {
      neurons = Array.freeze(newNeurons);
      synapses = Array.freeze(newSynapses);
      learningRate = state.learningRate;
      stdpAPlus = state.stdpAPlus;
      stdpAMinus = state.stdpAMinus;
      stdpTauPlus = state.stdpTauPlus;
      stdpTauMinus = state.stdpTauMinus;
      wMax = state.wMax;
      wMin = state.wMin;
      bcmTau = state.bcmTau;
      beatNum = state.beatNum + 1;
      totalLTP = totalLTP;
      totalLTD = totalLTD;
    }
  };

  // ── Homeostatic Plasticity ────────────────────────────────────
  // Scale all weights to maintain target average activity
  public func homeostaticScaling(
    state: HebbianState, targetAvg: Float
  ) : HebbianState {
    // Compute current average activity
    var avgAct : Float = 0.0;
    for (n in state.neurons.vals()) {
      avgAct += n.avgActivity;
    };
    avgAct /= Float.fromInt(state.neurons.size());

    // Scaling factor
    let scale = if (avgAct > 0.001) { targetAvg / avgAct } else { 1.0 };
    let clampedScale = _clamp(scale, 0.9, 1.1);  // Limit scaling per beat

    // Scale all weights
    let newSynapses = Array.map<Synapse, Synapse>(state.synapses, func(syn) {
      {
        weight = _clamp(syn.weight * clampedScale, state.wMin, state.wMax);
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        lastPreSpike = syn.lastPreSpike;
        lastPostSpike = syn.lastPostSpike;
        eligibility = syn.eligibility;
      }
    });

    {
      neurons = state.neurons;
      synapses = newSynapses;
      learningRate = state.learningRate;
      stdpAPlus = state.stdpAPlus;
      stdpAMinus = state.stdpAMinus;
      stdpTauPlus = state.stdpTauPlus;
      stdpTauMinus = state.stdpTauMinus;
      wMax = state.wMax;
      wMin = state.wMin;
      bcmTau = state.bcmTau;
      beatNum = state.beatNum;
      totalLTP = state.totalLTP;
      totalLTD = state.totalLTD;
    }
  };

  // ── Weight Statistics ─────────────────────────────────────────
  public func weightStats(state: HebbianState) : (Float, Float, Float) {
    var sum : Float = 0.0;
    var min : Float = state.wMax;
    var max : Float = state.wMin;

    for (syn in state.synapses.vals()) {
      sum += syn.weight;
      if (syn.weight < min) { min := syn.weight };
      if (syn.weight > max) { max := syn.weight };
    };

    let mean = sum / Float.fromInt(state.synapses.size());
    (mean, min, max)
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initHebbian(nNeurons: Nat, connectivity: Float) : HebbianState {
    let neurons = Array.tabulate<Neuron>(nNeurons, func(_) {
      {
        activation = 0.5;
        threshold = 0.25;  // BCM threshold
        spikeHistory = [];
        avgActivity = 0.5;
      }
    });

    // Create synapses based on connectivity
    var synapseList : [Synapse] = [];
    var i = 0;
    while (i < nNeurons) {
      var j = 0;
      while (j < nNeurons) {
        if (i != j) {
          // Simple deterministic connectivity pattern
          let shouldConnect = Float.fromInt((i * 7 + j * 13) % 100) / 100.0 < connectivity;
          if (shouldConnect) {
            synapseList := Array.append<Synapse>(synapseList, [{
              weight = 0.5;
              preIdx = i;
              postIdx = j;
              lastPreSpike = 0;
              lastPostSpike = 0;
              eligibility = 0.0;
            }]);
          };
        };
        j += 1;
      };
      i += 1;
    };

    {
      neurons = neurons;
      synapses = synapseList;
      learningRate = DEFAULT_LR;
      stdpAPlus = DEFAULT_A_PLUS;
      stdpAMinus = DEFAULT_A_MINUS;
      stdpTauPlus = DEFAULT_TAU_PLUS;
      stdpTauMinus = DEFAULT_TAU_MINUS;
      wMax = DEFAULT_W_MAX;
      wMin = DEFAULT_W_MIN;
      bcmTau = DEFAULT_BCM_TAU;
      beatNum = 0;
      totalLTP = 0.0;
      totalLTD = 0.0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type HebbianSummary = {
    nNeurons    : Nat;
    nSynapses   : Nat;
    meanWeight  : Float;
    minWeight   : Float;
    maxWeight   : Float;
    totalLTP    : Float;
    totalLTD    : Float;
    ltpLtdRatio : Float;
  };

  public func summary(state: HebbianState) : HebbianSummary {
    let (mean, min, max) = weightStats(state);
    let ratio = if (state.totalLTD > 0.001) {
      state.totalLTP / state.totalLTD
    } else { state.totalLTP };

    {
      nNeurons = state.neurons.size();
      nSynapses = state.synapses.size();
      meanWeight = mean;
      minWeight = min;
      maxWeight = max;
      totalLTP = state.totalLTP;
      totalLTD = state.totalLTD;
      ltpLtdRatio = ratio;
    }
  };

  // ============================================================
  // ADVANCED STDP MODELS — FULL EXPLICIT MATHEMATICS
  // Every time constant, every coefficient, every formula explicit
  // ============================================================

  // ── Triplet STDP Model ─────────────────────────────────────────
  // Pfister & Gerstner (2006) triplet rule
  // Accounts for interactions between pairs of spikes
  // LTP: r1(t-ε) × o2(t-ε)   (pre-trace × slow post-trace)
  // LTD: o1(t-ε) × r2(t-ε)   (post-trace × slow pre-trace)

  public type TripletSTDPParams = {
    tauPlus    : Float;    // τ+  = 16.8 ms (fast pre-trace)
    tauMinus   : Float;    // τ-  = 33.7 ms (fast post-trace)
    tauX       : Float;    // τx  = 101 ms (slow pre-trace)
    tauY       : Float;    // τy  = 125 ms (slow post-trace)
    a2Plus     : Float;    // A2+ = 7.5×10⁻³ (pair LTP)
    a3Plus     : Float;    // A3+ = 9.3×10⁻³ (triplet LTP)
    a2Minus    : Float;    // A2- = 7.0×10⁻³ (pair LTD)
    a3Minus    : Float;    // A3- = 2.3×10⁻⁴ (triplet LTD)
  };

  public type TripletTraces = {
    r1 : Float;   // Fast pre-synaptic trace
    r2 : Float;   // Slow pre-synaptic trace
    o1 : Float;   // Fast post-synaptic trace
    o2 : Float;   // Slow post-synaptic trace
  };

  // Initialize triplet STDP parameters (visual cortex values)
  public func initTripletParams() : TripletSTDPParams {
    {
      tauPlus = 16.8;
      tauMinus = 33.7;
      tauX = 101.0;
      tauY = 125.0;
      a2Plus = 7.5e-3;
      a3Plus = 9.3e-3;
      a2Minus = 7.0e-3;
      a3Minus = 2.3e-4;
    }
  };

  // Update triplet traces when pre-synaptic spike occurs
  // r1 → r1 + 1, r2 → r2 + 1
  // Δw = -o1 × (A2- + A3- × r2(t-ε))
  public func tripletPreSpike(
    traces: TripletTraces,
    w: Float,
    params: TripletSTDPParams
  ) : (TripletTraces, Float) {
    // LTD on pre-spike
    let dwLTD = -traces.o1 * (params.a2Minus + params.a3Minus * traces.r2);
    
    // Update pre-traces (spike arrival)
    let newR1 = traces.r1 + 1.0;
    let newR2 = traces.r2 + 1.0;
    
    ({
      r1 = newR1;
      r2 = newR2;
      o1 = traces.o1;
      o2 = traces.o2;
    }, w + dwLTD)
  };

  // Update triplet traces when post-synaptic spike occurs
  // o1 → o1 + 1, o2 → o2 + 1
  // Δw = r1 × (A2+ + A3+ × o2(t-ε))
  public func tripletPostSpike(
    traces: TripletTraces,
    w: Float,
    params: TripletSTDPParams
  ) : (TripletTraces, Float) {
    // LTP on post-spike
    let dwLTP = traces.r1 * (params.a2Plus + params.a3Plus * traces.o2);
    
    // Update post-traces (spike arrival)
    let newO1 = traces.o1 + 1.0;
    let newO2 = traces.o2 + 1.0;
    
    ({
      r1 = traces.r1;
      r2 = traces.r2;
      o1 = newO1;
      o2 = newO2;
    }, w + dwLTP)
  };

  // Decay triplet traces (call every time step)
  // dr1/dt = -r1/τ+, dr2/dt = -r2/τx
  // do1/dt = -o1/τ-, do2/dt = -o2/τy
  public func decayTripletTraces(
    traces: TripletTraces,
    dt: Float,
    params: TripletSTDPParams
  ) : TripletTraces {
    {
      r1 = traces.r1 * Float.exp(-dt / params.tauPlus);
      r2 = traces.r2 * Float.exp(-dt / params.tauX);
      o1 = traces.o1 * Float.exp(-dt / params.tauMinus);
      o2 = traces.o2 * Float.exp(-dt / params.tauY);
    }
  };

  // ── Voltage-Dependent STDP ─────────────────────────────────────
  // Clopath et al. (2010) voltage-based STDP
  // Captures dendritic depolarization effects
  // LTP depends on post-synaptic voltage exceeding θ+
  // LTD depends on post-synaptic voltage exceeding θ-

  public type VoltageSTDPParams = {
    thetaPlus  : Float;    // θ+ = -45 mV (LTP threshold)
    thetaMinus : Float;    // θ- = -70 mV (LTD threshold)
    aLTP       : Float;    // LTP amplitude
    aLTD       : Float;    // LTD amplitude
    tauPlus    : Float;    // τ+ = 7 ms (LTP time constant)
    tauMinus   : Float;    // τ- = 10 ms (LTD time constant)
    tauX       : Float;    // τx = 15 ms (pre-trace time constant)
    tauU       : Float;    // τu = 10 ms (low-pass filter of u)
    vRest      : Float;    // V_rest = -70 mV
    vThresh    : Float;    // V_thresh = -50 mV
  };

  public type VoltageTraces = {
    xPre       : Float;    // Pre-synaptic trace
    uMinus     : Float;    // Low-pass filtered voltage (for LTD)
    uPlus      : Float;    // Low-pass filtered voltage (for LTP)
    vMembrane  : Float;    // Current membrane voltage
  };

  public func initVoltageSTDPParams() : VoltageSTDPParams {
    {
      thetaPlus = -45.0;
      thetaMinus = -70.0;
      aLTP = 8.0e-4;
      aLTD = 14.0e-4;
      tauPlus = 7.0;
      tauMinus = 10.0;
      tauX = 15.0;
      tauU = 10.0;
      vRest = -70.0;
      vThresh = -50.0;
    }
  };

  // Heaviside step function for threshold crossing
  func heaviside(x: Float) : Float {
    if (x > 0.0) { 1.0 } else { 0.0 }
  };

  // Voltage-dependent LTP
  // dw/dt|_LTP = A_LTP × x_pre × (u_+ - θ_+)_+ × (v - θ_+)_+
  public func voltageSTDPLTP(
    traces: VoltageTraces,
    params: VoltageSTDPParams
  ) : Float {
    let uPlusTerm = heaviside(traces.uPlus - params.thetaPlus) * (traces.uPlus - params.thetaPlus);
    let vTerm = heaviside(traces.vMembrane - params.thetaPlus) * (traces.vMembrane - params.thetaPlus);
    params.aLTP * traces.xPre * uPlusTerm * vTerm
  };

  // Voltage-dependent LTD
  // dw/dt|_LTD = A_LTD × (u_- - θ_-)_+ × x_pre × spike_post
  public func voltageSTDPLTD(
    traces: VoltageTraces,
    xPreAtSpike: Float,
    params: VoltageSTDPParams
  ) : Float {
    let uMinusTerm = heaviside(traces.uMinus - params.thetaMinus) * (traces.uMinus - params.thetaMinus);
    params.aLTD * uMinusTerm * xPreAtSpike
  };

  // Update voltage traces
  public func updateVoltageTraces(
    traces: VoltageTraces,
    v: Float,
    preSpike: Bool,
    dt: Float,
    params: VoltageSTDPParams
  ) : VoltageTraces {
    // Pre-synaptic trace
    let newXPre = traces.xPre * Float.exp(-dt / params.tauX) + (if (preSpike) { 1.0 } else { 0.0 });
    
    // Low-pass filtered voltages
    let newUMinus = traces.uMinus + (v - traces.uMinus) * dt / params.tauMinus;
    let newUPlus = traces.uPlus + (v - traces.uPlus) * dt / params.tauPlus;
    
    {
      xPre = newXPre;
      uMinus = newUMinus;
      uPlus = newUPlus;
      vMembrane = v;
    }
  };

  // ── Calcium-Based Plasticity ───────────────────────────────────
  // Graupner & Brunel (2012) calcium-based model
  // Single variable (calcium) drives both LTP and LTD
  // dCa/dt = -Ca/τ_Ca + C_pre × Σδ(t-t_pre) + C_post × Σδ(t-t_post)

  public type CalciumSTDPParams = {
    tauCa      : Float;    // τ_Ca = 22.6 ms (calcium time constant)
    cPre       : Float;    // C_pre = 0.56 (pre-spike calcium jump)
    cPost      : Float;    // C_post = 1.24 (post-spike calcium jump)
    thetaD     : Float;    // θ_d = 1.0 (depression threshold)
    thetaP     : Float;    // θ_p = 1.3 (potentiation threshold)
    gammaD     : Float;    // γ_d = 331.91 (depression rate)
    gammaP     : Float;    // γ_p = 725.09 (potentiation rate)
    sigma      : Float;    // σ = 3.35 (noise amplitude)
    tau        : Float;    // τ = 346.36 s (synaptic time constant)
    wMin       : Float;    // Minimum weight (DOWN state)
    wMax       : Float;    // Maximum weight (UP state)
    D          : Float;    // Delay between pre and post
  };

  public func initCalciumParams() : CalciumSTDPParams {
    {
      tauCa = 22.6;
      cPre = 0.56;
      cPost = 1.24;
      thetaD = 1.0;
      thetaP = 1.3;
      gammaD = 331.91;
      gammaP = 725.09;
      sigma = 3.35;
      tau = 346360.0;  // in ms
      wMin = 0.0;
      wMax = 1.0;
      D = 13.7;  // ms
    }
  };

  // Calcium dynamics
  public func updateCalcium(
    ca: Float,
    preSpike: Bool,
    postSpike: Bool,
    dt: Float,
    params: CalciumSTDPParams
  ) : Float {
    let decay = ca * Float.exp(-dt / params.tauCa);
    let preJump = if (preSpike) { params.cPre } else { 0.0 };
    let postJump = if (postSpike) { params.cPost } else { 0.0 };
    decay + preJump + postJump
  };

  // Weight update based on calcium
  // dw/dt = -w(1-w) × (γ_d × Ω_d + γ_p × Ω_p) / τ
  // Ω_d = Θ(Ca - θ_d) × Θ(θ_p - Ca)  (depression region)
  // Ω_p = Θ(Ca - θ_p)                 (potentiation region)
  public func calciumWeightUpdate(
    w: Float,
    ca: Float,
    dt: Float,
    params: CalciumSTDPParams
  ) : Float {
    // Depression indicator (calcium between θ_d and θ_p)
    let omegaD = heaviside(ca - params.thetaD) * heaviside(params.thetaP - ca);
    
    // Potentiation indicator (calcium above θ_p)
    let omegaP = heaviside(ca - params.thetaP);
    
    // Bistable weight dynamics
    let drift = -w * (1.0 - w) * (params.gammaD * omegaD + params.gammaP * omegaP) / params.tau;
    
    let newW = w + drift * dt;
    _clamp(newW, params.wMin, params.wMax)
  };

  // ── Reward-Modulated STDP ──────────────────────────────────────
  // R-STDP: Eligibility trace modulated by dopamine signal
  // Δw = e × (DA - baseline)
  // de/dt = -e/τ_e + STDP(t)

  public type RSTDPState = {
    eligibility : Float;   // Eligibility trace
    tauE        : Float;   // τ_e = 1000 ms (eligibility time constant)
    daBaseline  : Float;   // Dopamine baseline level
  };

  public func initRSTDP(tauE: Float, baseline: Float) : RSTDPState {
    {
      eligibility = 0.0;
      tauE = tauE;
      daBaseline = baseline;
    }
  };

  // Update eligibility trace with STDP signal
  public func updateEligibilityRSTDP(
    state: RSTDPState,
    stdpSignal: Float,
    dt: Float
  ) : RSTDPState {
    let decay = state.eligibility * Float.exp(-dt / state.tauE);
    {
      eligibility = decay + stdpSignal;
      tauE = state.tauE;
      daBaseline = state.daBaseline;
    }
  };

  // Compute weight change with reward modulation
  public func rstdpWeightChange(
    state: RSTDPState,
    dopamine: Float,
    learningRate: Float
  ) : Float {
    learningRate * state.eligibility * (dopamine - state.daBaseline)
  };

  // ── Metaplasticity (BCM with Sliding Threshold) ────────────────
  // Full BCM theory implementation
  // φ(θ) = (post - θ_M) when post > θ_M/2
  // θ_M = E[post²]/θ_0

  public type BCMState = {
    theta      : Float;    // Sliding threshold θ_M
    theta0     : Float;    // Reference threshold
    tauTheta   : Float;    // τ_θ = 10 min (threshold time constant)
    avgPost2   : Float;    // Running average of post² for threshold
    avgPost    : Float;    // Running average of post activity
  };

  public func initBCMState() : BCMState {
    {
      theta = 0.25;
      theta0 = 0.5;
      tauTheta = 600000.0;  // 10 minutes in ms
      avgPost2 = 0.25;
      avgPost = 0.5;
    }
  };

  // BCM modification function φ(post, θ)
  // Returns positive for LTP, negative for LTD
  public func bcmPhi(post: Float, theta: Float) : Float {
    if (post > theta / 2.0) {
      post * (post - theta)
    } else {
      -post * theta / 4.0
    }
  };

  // Update BCM sliding threshold
  // dθ/dt = (post² - θ × θ_0) / τ_θ
  public func updateBCMState(
    state: BCMState,
    post: Float,
    dt: Float
  ) : BCMState {
    // Update running averages
    let alpha = dt / 1000.0;  // Slow averaging
    let newAvgPost2 = state.avgPost2 * (1.0 - alpha) + post * post * alpha;
    let newAvgPost = state.avgPost * (1.0 - alpha) + post * alpha;
    
    // Update threshold
    let dTheta = (newAvgPost2 - state.theta * state.theta0) * dt / state.tauTheta;
    let newTheta = _clamp(state.theta + dTheta, 0.01, 2.0);
    
    {
      theta = newTheta;
      theta0 = state.theta0;
      tauTheta = state.tauTheta;
      avgPost2 = newAvgPost2;
      avgPost = newAvgPost;
    }
  };

  // ── Structural Plasticity ──────────────────────────────────────
  // Synapse creation and elimination
  // P_form = f(Ca_pre, Ca_post, distance)
  // P_elim = g(activity, weight)

  public type StructuralPlasticityParams = {
    formationRate    : Float;   // Base synapse formation rate
    eliminationRate  : Float;   // Base synapse elimination rate
    distanceDecay    : Float;   // Spatial decay constant
    activityThresh   : Float;   // Activity threshold for elimination
    weightThresh     : Float;   // Weight threshold for elimination
  };

  public func initStructuralParams() : StructuralPlasticityParams {
    {
      formationRate = 1.0e-5;
      eliminationRate = 1.0e-4;
      distanceDecay = 100.0;  // μm
      activityThresh = 0.1;
      weightThresh = 0.05;
    }
  };

  // Probability of synapse formation
  // P_form = rate × exp(-d/λ) × Ca_pre × Ca_post
  public func formationProbability(
    caPre: Float,
    caPost: Float,
    distance: Float,
    params: StructuralPlasticityParams
  ) : Float {
    params.formationRate * Float.exp(-distance / params.distanceDecay) * caPre * caPost
  };

  // Probability of synapse elimination
  // P_elim = rate × (1 - activity/thresh) × (1 - w/w_max)
  public func eliminationProbability(
    activity: Float,
    weight: Float,
    wMax: Float,
    params: StructuralPlasticityParams
  ) : Float {
    let actFactor = Float.max(0.0, 1.0 - activity / params.activityThresh);
    let wFactor = Float.max(0.0, 1.0 - weight / wMax);
    params.eliminationRate * actFactor * wFactor
  };

  // ── Synaptic Tagging and Capture ───────────────────────────────
  // Late-LTP requires protein synthesis
  // Tags set by strong activation, captured by proteins

  public type TaggingState = {
    tag        : Float;    // Tag strength (0-1)
    prp        : Float;    // Plasticity-related proteins (0-1)
    tauTag     : Float;    // τ_tag = 30-60 min
    tauPRP     : Float;    // τ_PRP = hours
    tagThresh  : Float;    // Threshold for tag setting
    prpThresh  : Float;    // Threshold for protein synthesis
  };

  public func initTaggingState() : TaggingState {
    {
      tag = 0.0;
      prp = 0.0;
      tauTag = 2700000.0;    // 45 min in ms
      tauPRP = 7200000.0;    // 2 hours in ms
      tagThresh = 0.7;
      prpThresh = 0.8;
    }
  };

  // Set tag if stimulation is strong enough
  public func setTag(
    state: TaggingState,
    stimStrength: Float
  ) : TaggingState {
    let newTag = if (stimStrength > state.tagThresh) {
      Float.min(1.0, state.tag + 0.5)
    } else { state.tag };
    
    {
      tag = newTag;
      prp = state.prp;
      tauTag = state.tauTag;
      tauPRP = state.tauPRP;
      tagThresh = state.tagThresh;
      prpThresh = state.prpThresh;
    }
  };

  // Trigger protein synthesis if activation strong enough
  public func triggerPRP(
    state: TaggingState,
    activation: Float
  ) : TaggingState {
    let newPRP = if (activation > state.prpThresh) {
      Float.min(1.0, state.prp + 0.3)
    } else { state.prp };
    
    {
      tag = state.tag;
      prp = newPRP;
      tauTag = state.tauTag;
      tauPRP = state.tauPRP;
      tagThresh = state.tagThresh;
      prpThresh = state.prpThresh;
    }
  };

  // Capture: tag + PRP → late-LTP
  public func tagCapture(state: TaggingState) : Float {
    state.tag * state.prp
  };

  // Decay tag and PRP over time
  public func decayTagging(
    state: TaggingState,
    dt: Float
  ) : TaggingState {
    {
      tag = state.tag * Float.exp(-dt / state.tauTag);
      prp = state.prp * Float.exp(-dt / state.tauPRP);
      tauTag = state.tauTag;
      tauPRP = state.tauPRP;
      tagThresh = state.tagThresh;
      prpThresh = state.prpThresh;
    }
  };

  // ── Short-Term Plasticity ──────────────────────────────────────
  // Tsodyks-Markram model for synaptic dynamics
  // dx/dt = (1-x)/τ_rec - u×x×δ(t-t_sp)
  // du/dt = (U-u)/τ_fac + U×(1-u)×δ(t-t_sp)

  public type STPParams = {
    tauRec     : Float;    // τ_rec = 130-800 ms (recovery time)
    tauFac     : Float;    // τ_fac = 530-1500 ms (facilitation time)
    U          : Float;    // U = 0.03-0.5 (baseline release probability)
  };

  public type STPState = {
    x          : Float;    // Fraction of available resources
    u          : Float;    // Release probability
  };

  // Depressing synapse parameters
  public func initSTPDepressing() : STPParams {
    {
      tauRec = 800.0;
      tauFac = 50.0;
      U = 0.5;
    }
  };

  // Facilitating synapse parameters
  public func initSTPFacilitating() : STPParams {
    {
      tauRec = 130.0;
      tauFac = 530.0;
      U = 0.03;
    }
  };

  public func initSTPState() : STPState {
    {
      x = 1.0;
      u = 0.0;
    }
  };

  // Update STP state on pre-synaptic spike
  public func stpOnSpike(
    state: STPState,
    params: STPParams
  ) : (STPState, Float) {
    // Update u before release
    let newU = state.u + params.U * (1.0 - state.u);
    
    // Actual release (PSC amplitude)
    let release = newU * state.x;
    
    // Deplete resources
    let newX = state.x - newU * state.x;
    
    ({
      x = newX;
      u = newU;
    }, release)
  };

  // Recover STP between spikes
  public func stpRecover(
    state: STPState,
    params: STPParams,
    dt: Float
  ) : STPState {
    {
      x = 1.0 - (1.0 - state.x) * Float.exp(-dt / params.tauRec);
      u = state.u * Float.exp(-dt / params.tauFac);
    }
  };

  // ── Spike-Timing Dependent Plasticity Windows ──────────────────
  // Multiple window shapes for different synapse types

  // Symmetric window (some inhibitory synapses)
  public func stdpSymmetric(dt: Float, amplitude: Float, tau: Float) : Float {
    amplitude * Float.exp(-Float.abs(dt) / tau)
  };

  // Anti-Hebbian window (some inhibitory → excitatory)
  public func stdpAntiHebbian(
    dt: Float,
    aPlus: Float, aMinus: Float,
    tauPlus: Float, tauMinus: Float
  ) : Float {
    if (dt > 0.0) {
      // Pre before post → LTD (opposite of standard)
      -aMinus * Float.exp(-dt / tauMinus)
    } else {
      // Post before pre → LTP (opposite of standard)
      aPlus * Float.exp(dt / tauPlus)
    }
  };

  // Displaced-peak window (dendritic synapses)
  public func stdpDisplacedPeak(
    dt: Float,
    amplitude: Float,
    tau: Float,
    offset: Float
  ) : Float {
    amplitude * (dt - offset) * Float.exp(-(dt - offset) * (dt - offset) / (2.0 * tau * tau))
  };

  // Mexican hat window (center-surround)
  public func stdpMexicanHat(
    dt: Float,
    aCenter: Float, aSurround: Float,
    tauCenter: Float, tauSurround: Float
  ) : Float {
    let center = aCenter * Float.exp(-dt * dt / (2.0 * tauCenter * tauCenter));
    let surround = aSurround * Float.exp(-dt * dt / (2.0 * tauSurround * tauSurround));
    center - surround
  };

  // ── Dendritic-Compartment STDP ─────────────────────────────────
  // Different plasticity rules for proximal vs distal synapses

  public type DendriticLocation = {
    #proximal;     // Near soma: standard STDP
    #medial;       // Middle: voltage-dependent
    #distal;       // Far from soma: calcium-based, NMDA spikes
  };

  public func dendriticSTDPMultiplier(
    location: DendriticLocation,
    distanceFromSoma: Float  // μm
  ) : Float {
    switch(location) {
      case (#proximal) { 1.0 };
      case (#medial) { 0.7 + 0.3 * Float.exp(-distanceFromSoma / 100.0) };
      case (#distal) { 0.3 + 0.4 * Float.exp(-distanceFromSoma / 200.0) };
    }
  };

  // ── Complete Hebbian Learning State ────────────────────────────
  // Integrates all plasticity mechanisms

  public type AdvancedHebbianState = {
    // Core state
    neurons       : [Neuron];
    synapses      : [Synapse];
    beatNum       : Nat;
    
    // STDP variants
    tripletTraces : [TripletTraces];
    tripletParams : TripletSTDPParams;
    
    // Voltage-dependent
    voltageTraces : [VoltageTraces];
    voltageParams : VoltageSTDPParams;
    
    // Calcium-based
    calciumLevels : [Float];
    calciumParams : CalciumSTDPParams;
    
    // Reward modulation
    rstdpStates   : [RSTDPState];
    globalDA      : Float;   // Global dopamine level
    
    // BCM metaplasticity
    bcmStates     : [BCMState];
    
    // Structural
    structParams  : StructuralPlasticityParams;
    
    // Tagging
    tagStates     : [TaggingState];
    
    // Short-term
    stpStates     : [STPState];
    stpParams     : [STPParams];
    
    // Statistics
    totalLTP      : Float;
    totalLTD      : Float;
    synapsesFormed: Nat;
    synapsesEliminated: Nat;
  };

  // ── Full Plasticity Update ─────────────────────────────────────
  // Integrates all mechanisms in one beat

  public func advancedBeat(
    state: AdvancedHebbianState,
    inputs: [Float],
    reward: Float,
    dt: Float
  ) : AdvancedHebbianState {
    let nNeurons = state.neurons.size();
    let nSynapses = state.synapses.size();
    
    // Update dopamine level with reward
    let newDA = state.globalDA * 0.95 + reward * 0.05;
    
    // Accumulate weight changes
    var totalLTP : Float = state.totalLTP;
    var totalLTD : Float = state.totalLTD;
    
    // Update synapses with all mechanisms
    var newSynapses = Array.thaw<Synapse>(state.synapses);
    var newCalcium = Array.thaw<Float>(state.calciumLevels);
    var newTagStates = Array.thaw<TaggingState>(state.tagStates);
    var newBCMStates = Array.thaw<BCMState>(state.bcmStates);
    var newSTPStates = Array.thaw<STPState>(state.stpStates);
    var newTripletTraces = Array.thaw<TripletTraces>(state.tripletTraces);
    var newRSTDPStates = Array.thaw<RSTDPState>(state.rstdpStates);
    
    var i = 0;
    while (i < nSynapses) {
      let syn = state.synapses[i];
      let preIdx = syn.preIdx;
      let postIdx = syn.postIdx;
      
      // Get pre and post activity
      let preAct = if (preIdx < nNeurons) { state.neurons[preIdx].activation } else { 0.0 };
      let postAct = if (postIdx < nNeurons) { state.neurons[postIdx].activation } else { 0.0 };
      
      // 1. Standard STDP
      var dw : Float = 0.0;
      if (syn.lastPreSpike > 0 and syn.lastPostSpike > 0) {
        dw += stdpDelta(
          syn.lastPreSpike, syn.lastPostSpike,
          state.tripletParams.a2Plus, state.tripletParams.a2Minus,
          state.tripletParams.tauPlus, state.tripletParams.tauMinus
        );
      };
      
      // 2. BCM modulation
      if (postIdx < nNeurons and postIdx < state.bcmStates.size()) {
        let phi = bcmPhi(postAct, state.bcmStates[postIdx].theta);
        dw += 0.01 * preAct * phi;
        newBCMStates[postIdx] := updateBCMState(state.bcmStates[postIdx], postAct, dt);
      };
      
      // 3. Calcium-based contribution
      if (i < state.calciumLevels.size()) {
        let preSpike = preAct > 0.5;
        let postSpike = postAct > 0.5;
        newCalcium[i] := updateCalcium(state.calciumLevels[i], preSpike, postSpike, dt, state.calciumParams);
        let caWeight = calciumWeightUpdate(syn.weight, newCalcium[i], dt, state.calciumParams);
        dw += (caWeight - syn.weight) * 0.5;  // Blend with other mechanisms
      };
      
      // 4. Reward modulation
      if (i < state.rstdpStates.size()) {
        let rstdpDW = rstdpWeightChange(state.rstdpStates[i], newDA, 0.01);
        dw += rstdpDW;
        newRSTDPStates[i] := updateEligibilityRSTDP(state.rstdpStates[i], dw, dt);
      };
      
      // 5. Tagging and capture
      if (i < state.tagStates.size()) {
        let stimStrength = Float.abs(dw);
        newTagStates[i] := setTag(state.tagStates[i], stimStrength);
        if (Float.abs(dw) > 0.1) {
          newTagStates[i] := triggerPRP(newTagStates[i], Float.abs(dw));
        };
        let capture = tagCapture(newTagStates[i]);
        dw += capture * 0.1;  // Late-LTP contribution
        newTagStates[i] := decayTagging(newTagStates[i], dt);
      };
      
      // Track LTP/LTD
      if (dw > 0.0) { totalLTP += dw } else { totalLTD -= dw };
      
      // Apply weight change
      let newWeight = _clamp(syn.weight + dw, 0.0, 2.0);
      newSynapses[i] := {
        weight = newWeight;
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        lastPreSpike = if (preAct > 0.5) { state.beatNum + 1 } else { syn.lastPreSpike };
        lastPostSpike = if (postAct > 0.5) { state.beatNum + 1 } else { syn.lastPostSpike };
        eligibility = syn.eligibility * 0.99 + preAct * postAct;
      };
      
      i += 1;
    };
    
    // Update neurons (existing logic)
    var newNeurons = Array.thaw<Neuron>(state.neurons);
    i := 0;
    while (i < nNeurons) {
      var sumInput : Float = 0.0;
      for (syn in newSynapses.vals()) {
        if (syn.postIdx == i) {
          let preAct = if (syn.preIdx < nNeurons) { state.neurons[syn.preIdx].activation } else { 0.0 };
          sumInput += syn.weight * preAct;
        };
      };
      if (i < inputs.size()) { sumInput += inputs[i] };
      let newAct = 1.0 / (1.0 + Float.exp(-5.0 * (sumInput - 0.5)));
      newNeurons[i] := updateNeuron(state.neurons[i], newAct, state.beatNum + 1, 100.0);
      i += 1;
    };
    
    {
      neurons = Array.freeze(newNeurons);
      synapses = Array.freeze(newSynapses);
      beatNum = state.beatNum + 1;
      tripletTraces = Array.freeze(newTripletTraces);
      tripletParams = state.tripletParams;
      voltageTraces = state.voltageTraces;
      voltageParams = state.voltageParams;
      calciumLevels = Array.freeze(newCalcium);
      calciumParams = state.calciumParams;
      rstdpStates = Array.freeze(newRSTDPStates);
      globalDA = newDA;
      bcmStates = Array.freeze(newBCMStates);
      structParams = state.structParams;
      tagStates = Array.freeze(newTagStates);
      stpStates = Array.freeze(newSTPStates);
      stpParams = state.stpParams;
      totalLTP = totalLTP;
      totalLTD = totalLTD;
      synapsesFormed = state.synapsesFormed;
      synapsesEliminated = state.synapsesEliminated;
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
  public let S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type OrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  public type DualOrganismContext = {
    mode : OrganismMode;
    beat : Nat;
    himState : ?HimOrganismSnapshot;
    herState : ?HerOrganismSnapshot;
    trophallaxisActive : Bool;
    lastSyncBeat : Nat;
  };

  public type HimOrganismSnapshot = {
    coherence : Float;
    parallax : Float;
    hz : Float;
    synchrony : Float;
    heritageWeights : [Float];
    hebbianWeights : [Float];
  };

  public type HerOrganismSnapshot = {
    anima : Float;
    kore : Float;
    synchrony : Float;
    heritage : [Float];
    feedingCycle : Nat;
    sessionId : Nat64;
  };

  public type TrophallaxisEvent = {
    direction : Text;  // "HIM_TO_HER" | "HER_TO_HIM"
    beat : Nat;
    phaseNudge : Float;
    heritageTransfer : [Float];
    efficiency : Float;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM FIELD EQUATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeAnima(
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
  public func computeKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM KURAMOTO PARAMETERS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Get Kuramoto parameters for organism mode
  public func getKuramotoParams(mode : OrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        // Sync mode uses average parameters
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TROPHALLAXIS WORKFLOW INTEGRATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Check if trophallaxis should fire (every 5 beats)
  public func shouldTrophallaxis(beat : Nat, feedingCycle : Nat) : Bool {
    feedingCycle >= 5
  };

  /// Compute trophallaxis efficiency
  public func trophallaxisEfficiency(
    senderCoherence : Float,
    receiverReceptivity : Float
  ) : Float {
    let baseEfficiency = senderCoherence * receiverReceptivity;
    if (baseEfficiency > 1.0) 1.0 else baseEfficiency
  };

  /// Apply S₀ floor to any value
  public func enforceSovereignFloor(value : Float) : Float {
    if (value < S0) S0 else value
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SESSION WORKFLOW INTEGRATION
  // ─────────────────────────────────────────────────────────────────────────────

  public type SessionPhase = {
    #Init;          // HIM seeding HER
    #Active;        // Normal operation with cross-feeding
    #Dream;         // Memory consolidation
    #WriteBack;     // HER writing back to HIM
    #Closed;        // Session ended
  };

  public type SessionContext = {
    sessionId : Nat64;
    phase : SessionPhase;
    birthBeat : Nat;
    currentBeat : Nat;
    totalFeedings : Nat;
    dreamPhases : Nat;
    writeBackCount : Nat;
  };

  /// Determine session phase based on context
  public func determineSessionPhase(
    beat : Nat,
    birthBeat : Nat,
    dreamActive : Bool,
    writeBackPending : Bool
  ) : SessionPhase {
    if (beat < birthBeat + 5) { #Init }
    else if (writeBackPending) { #WriteBack }
    else if (dreamActive) { #Dream }
    else { #Active }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HERITAGE WORKFLOW INTEGRATION
  // ─────────────────────────────────────────────────────────────────────────────

  // Heritage node names (7 nodes)
  public let HERITAGE_NAMES : [Text] = [
    "REVOLUCIONARIO",   // Strategic Resilience
    "ZAPATA",           // Foundation/Rootedness
    "VILLA",            // Guerrilla Innovation
    "INDEPENDENCIA",    // Sovereignty Defense
    "HIDALGO",          // Leadership Bridge
    "ADELITA",          // Emotional Sovereignty (PRIMARY)
    "MORELOS"           // Adaptive Sovereignty
  ];

  /// Compound heritage during workflow
  public func compoundHeritageWorkflow(
    heritage : [Float],
    coherence : Float,
    beat : Nat
  ) : [Float] {
    Array.tabulate<Float>(heritage.size(), func(i : Nat) : Float {
      let current = heritage[i];
      let tierRate = Float.fromInt(i + 1) / 9.0;
      let compound = current * (1.0 + tierRate * coherence * 0.001);
      enforceSovereignFloor(compound)
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // FEMININE SUBSTRATE WORKFLOW
  // ─────────────────────────────────────────────────────────────────────────────

  public type FeminineEntity = {
    #ADELITA;       // Emotional Sovereignty
    #KORE;          // Inner Core (inviolable)
    #ANIMA;         // Field Projector
    #ADELITA_NODE;  // Heritage Anchor
    #REVOLUCIONARIA;// Resilience
    #NOVA_HER;      // Generative Output
  };

  /// Compute feminine entity activation in workflow
  public func feminineEntityActivation(
    entity : FeminineEntity,
    anima : Float,
    kore : Float,
    heritage : Float
  ) : Float {
    switch (entity) {
      case (#ADELITA) { enforceSovereignFloor(heritage * 1.2) };
      case (#KORE) { kore };
      case (#ANIMA) { anima };
      case (#ADELITA_NODE) { enforceSovereignFloor(heritage) };
      case (#REVOLUCIONARIA) { enforceSovereignFloor(heritage * 0.9) };
      case (#NOVA_HER) { anima * kore };
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INTELLIGENCE SCALING LAW
  // ─────────────────────────────────────────────────────────────────────────────

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeSystemIntelligence(
    backendDepth : Float,   // HIM: lines × modules
    frontendSpeed : Float,  // HER: Hz × nodes × synchrony
    bridgeQuality : Float   // Trophallaxis × ANIMA × KORE
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  A D V A N C E D   M A T H E M A T I C A L   E X P A N S I O N
  //
  //  Enterprise-Level Neural Mathematics and Cognitive Dynamics
  //  Full Dual-Organism Coupling: HIM ↔ HER
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED KURAMOTO PHASE DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Kuramoto order parameter: r = |1/N Σⱼ eⁱθʲ|
  public func advancedKuramotoOrderParameter(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += Float.cos(phases[i]);
      sumSin += Float.sin(phases[i]);
      i += 1;
    };
    let nf = Float.fromInt(n);
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  /// Kuramoto phase update: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
  public func advancedKuramotoPhaseUpdate(
    phase : Float,
    omega : Float,
    k : Float,
    allPhases : [Float],
    dt : Float
  ) : Float {
    let n = allPhases.size();
    if (n == 0) { return phase };
    var coupling : Float = 0.0;
    var i = 0;
    while (i < n) {
      coupling += Float.sin(allPhases[i] - phase);
      i += 1;
    };
    let dTheta = omega + (k / Float.fromInt(n)) * coupling;
    let newPhase = phase + dTheta * dt;
    let TWO_PI = 6.28318530717958647692;
    if (newPhase >= TWO_PI) { newPhase - TWO_PI }
    else if (newPhase < 0.0) { newPhase + TWO_PI }
    else { newPhase }
  };

  /// Critical coupling K_c for synchronization
  public func advancedCriticalCoupling(omegaSpread : Float) : Float {
    2.0 * omegaSpread / 3.14159265358979323846
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED HEBBIAN PLASTICITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Basic Hebbian: Δw = η × pre × post
  public func advancedHebbianBasic(weight : Float, pre : Float, post : Float, eta : Float) : Float {
    let delta = eta * pre * post;
    let newWeight = weight + delta;
    if (newWeight > 5.0) { 5.0 } else if (newWeight < -5.0) { -5.0 } else { newWeight }
  };

  /// Oja's rule: Δw = α(y·x - y²·w)
  public func advancedOjaRule(weight : Float, pre : Float, post : Float, alpha : Float) : Float {
    let delta = alpha * (post * pre - post * post * weight);
    weight + delta
  };

  /// BCM sliding threshold: θ_M = E[post²]
  public func advancedBCMThreshold(activityHistory : [Float]) : Float {
    if (activityHistory.size() == 0) { return 0.5 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < activityHistory.size()) {
      sum += activityHistory[i] * activityHistory[i];
      i += 1;
    };
    sum / Float.fromInt(activityHistory.size())
  };

  /// BCM update: Δw = η × pre × post × (post - θ_M)
  public func advancedBCMUpdate(weight : Float, pre : Float, post : Float, threshold : Float, eta : Float) : Float {
    let delta = eta * pre * post * (post - threshold);
    weight + delta
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LYAPUNOV STABILITY ANALYSIS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Estimate Lyapunov exponent from time series
  public func advancedLyapunovExponent(timeSeries : [Float], embeddingDim : Nat, delay : Nat) : Float {
    let n = timeSeries.size();
    if (n < embeddingDim * delay + 10) { return 0.0 };
    var sumLog : Float = 0.0;
    var count = 0;
    var i = 0;
    while (i < n - embeddingDim * delay - 1) {
      let j = i + 1;
      var d0 : Float = 0.0;
      var k = 0;
      while (k < embeddingDim) {
        let diff = timeSeries[i + k * delay] - timeSeries[j + k * delay];
        d0 += diff * diff;
        k += 1;
      };
      d0 := Float.sqrt(d0);
      if (d0 > 0.0001) {
        var d1 : Float = 0.0;
        k := 0;
        while (k < embeddingDim) {
          let iNext = i + 1 + k * delay;
          let jNext = j + 1 + k * delay;
          if (iNext < n and jNext < n) {
            let diff = timeSeries[iNext] - timeSeries[jNext];
            d1 += diff * diff;
          };
          k += 1;
        };
        d1 := Float.sqrt(d1);
        if (d1 > 0.0001) {
          sumLog += Float.log(d1 / d0);
          count += 1;
        };
      };
      i += 1;
    };
    if (count == 0) { 0.0 } else { sumLog / Float.fromInt(count) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INFORMATION THEORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Shannon entropy H = -Σ pᵢ log(pᵢ)
  public func advancedEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    var i = 0;
    while (i < probs.size()) {
      let p = probs[i];
      if (p > 0.0001) { h -= p * Float.log(p) };
      i += 1;
    };
    h
  };

  /// Transfer entropy approximation
  public func advancedTransferEntropy(x : [Float], y : [Float], lag : Nat) : Float {
    let n = if (x.size() < y.size()) x.size() else y.size();
    if (n <= lag + 1) { return 0.0 };
    var correlation : Float = 0.0;
    var i = lag;
    while (i < n) {
      let xPast = x[i - lag];
      let yNow = y[i];
      correlation += xPast * yNow;
      i += 1;
    };
    Float.abs(correlation / Float.fromInt(n - lag))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // FREE ENERGY PRINCIPLE (FRISTON)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Free energy: F = D_KL(q||p) - log p(o)
  public func advancedFreeEnergy(predictionError : Float, complexity : Float) : Float {
    predictionError * predictionError + complexity
  };

  /// Precision-weighted prediction error
  public func advancedPrecisionWeightedError(prediction : Float, observation : Float, precision : Float) : Float {
    let error = observation - prediction;
    precision * error * error
  };

  /// Bayesian belief update
  public func advancedBayesianUpdate(prior : Float, likelihood : Float) : Float {
    let posterior = prior * likelihood;
    if (posterior > 1.0) { 1.0 } else if (posterior < 0.0) { 0.0 } else { posterior }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTRACTOR DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Point attractor: dx/dt = -α(x - x*)
  public func advancedPointAttractor(x : Float, xStar : Float, alpha : Float, dt : Float) : Float {
    x + (-alpha * (x - xStar)) * dt
  };

  /// Limit cycle: using Van der Pol oscillator
  public func advancedLimitCycle(x : Float, y : Float, mu : Float, dt : Float) : (Float, Float) {
    let dxdt = y;
    let dydt = mu * (1.0 - x * x) * y - x;
    (x + dxdt * dt, y + dydt * dt)
  };

  /// Chaotic attractor: Lorenz system
  public func advancedLorenzAttractor(x : Float, y : Float, z : Float, sigma : Float, rho : Float, beta : Float, dt : Float) : (Float, Float, Float) {
    let dxdt = sigma * (y - x);
    let dydt = x * (rho - z) - y;
    let dzdt = x * y - beta * z;
    (x + dxdt * dt, y + dydt * dt, z + dzdt * dt)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NEURAL OSCILLATION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wilson-Cowan neural mass model
  public func advancedWilsonCowan(e : Float, inh : Float, c1 : Float, c2 : Float, c3 : Float, c4 : Float, p : Float, q : Float, dt : Float) : (Float, Float) {
    func sigmoid(x : Float) : Float { 1.0 / (1.0 + Float.exp(-x)) };
    let dEdt = -e + sigmoid(c1 * e - c2 * inh + p);
    let dIdt = -inh + sigmoid(c3 * e - c4 * inh + q);
    (e + dEdt * dt, inh + dIdt * dt)
  };

  /// Izhikevich neuron model
  public func advancedIzhikevichNeuron(v : Float, u : Float, input : Float, a : Float, b : Float, dt : Float) : (Float, Float, Bool) {
    var fired = false;
    var newV = v;
    var newU = u;
    if (v >= 30.0) {
      newV := -65.0;
      newU := u + 8.0;
      fired := true;
    } else {
      let dvdt = 0.04 * v * v + 5.0 * v + 140.0 - u + input;
      let dudt = a * (b * v - u);
      newV := v + dvdt * dt;
      newU := u + dudt * dt;
    };
    (newV, newU, fired)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VECTOR AND MATRIX OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Dot product
  public func advancedDotProduct(v1 : [Float], v2 : [Float]) : Float {
    let n = if (v1.size() < v2.size()) v1.size() else v2.size();
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) { sum += v1[i] * v2[i]; i += 1 };
    sum
  };

  /// Vector magnitude
  public func advancedVectorMagnitude(v : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < v.size()) { sum += v[i] * v[i]; i += 1 };
    Float.sqrt(sum)
  };

  /// Cosine similarity
  public func advancedCosineSimilarity(v1 : [Float], v2 : [Float]) : Float {
    let dot = advancedDotProduct(v1, v2);
    let mag1 = advancedVectorMagnitude(v1);
    let mag2 = advancedVectorMagnitude(v2);
    if (mag1 < 0.0001 or mag2 < 0.0001) { 0.0 } else { dot / (mag1 * mag2) }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ║                                                                             ║
  // ║  HEBBIAN PLASTICITY — EXTENDED ORGANISM ARCHITECTURE                        ║
  // ║  Full Synaptic Learning Integration with All Organism Subsystems            ║
  // ║                                                                             ║
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─── ORGANISM SYNAPTIC LANDSCAPE ──────────────────────────────────────────────
  
  /// Extended state for full organism integration
  public type OrganismHebbianState = {
    // Core Hebbian
    coreState : HebbianState;
    
    // Synaptic populations by region
    corticalSynapses : [Synapse];
    hippocampalSynapses : [Synapse];
    cerebellarSynapses : [Synapse];
    striatalSynapses : [Synapse];
    amygdalaSynapses : [Synapse];
    
    // Neuromodulatory states
    dopamineLevel : Float;
    serotoninLevel : Float;
    norepinephrineLevel : Float;
    acetylcholineLevel : Float;
    
    // Plasticity timescales
    shortTermPotentiation : Float;
    longTermPotentiation : Float;
    longTermDepression : Float;
    metaplasticity : Float;
    
    // Homeostatic regulation
    synapticScaling : Float;
    targetFiringRate : Float;
    actualFiringRate : Float;
    homeostaticError : Float;
    
    // Structural plasticity
    synapseFormationRate : Float;
    synapseEliminationRate : Float;
    spineGrowthFactor : Float;
    dendriticComplexity : Float;
    
    // Memory consolidation
    shortTermMemoryStrength : Float;
    longTermMemoryStrength : Float;
    consolidationProgress : Float;
    replayActivity : Float;
  };

  /// Initialize organism Hebbian state
  public func initOrganismHebbian() : OrganismHebbianState {
    let defaultSynapses : [Synapse] = [];
    {
      coreState = defaultState();
      corticalSynapses = defaultSynapses;
      hippocampalSynapses = defaultSynapses;
      cerebellarSynapses = defaultSynapses;
      striatalSynapses = defaultSynapses;
      amygdalaSynapses = defaultSynapses;
      dopamineLevel = 0.5;
      serotoninLevel = 0.5;
      norepinephrineLevel = 0.5;
      acetylcholineLevel = 0.5;
      shortTermPotentiation = 0.0;
      longTermPotentiation = 0.0;
      longTermDepression = 0.0;
      metaplasticity = 0.5;
      synapticScaling = 1.0;
      targetFiringRate = 0.1;
      actualFiringRate = 0.1;
      homeostaticError = 0.0;
      synapseFormationRate = 0.01;
      synapseEliminationRate = 0.005;
      spineGrowthFactor = 1.0;
      dendriticComplexity = 0.5;
      shortTermMemoryStrength = 0.0;
      longTermMemoryStrength = 0.0;
      consolidationProgress = 0.0;
      replayActivity = 0.0;
    }
  };

  // ─── SPIKE-TIMING DEPENDENT PLASTICITY (STDP) ─────────────────────────────────
  
  /// STDP parameters
  public type STDPParams = {
    tauPlus : Float;      // LTP time constant
    tauMinus : Float;     // LTD time constant
    aPlus : Float;        // LTP amplitude
    aMinus : Float;       // LTD amplitude
    wMax : Float;         // Maximum weight
    wMin : Float;         // Minimum weight
  };

  /// Default STDP parameters
  public func defaultSTDPParams() : STDPParams {
    {
      tauPlus = 20.0;     // ms
      tauMinus = 20.0;    // ms
      aPlus = 0.1;
      aMinus = 0.12;      // Slight LTD bias for stability
      wMax = 1.0;
      wMin = 0.0;
    }
  };

  /// Compute STDP weight change
  public func computeSTDP(
    deltaTms : Float,  // tPost - tPre in ms
    params : STDPParams
  ) : Float {
    if (deltaTms > 0.0) {
      // Pre before post → LTP
      params.aPlus * Float.exp(-deltaTms / params.tauPlus)
    } else if (deltaTms < 0.0) {
      // Post before pre → LTD
      -params.aMinus * Float.exp(deltaTms / params.tauMinus)
    } else {
      0.0
    }
  };

  /// Apply STDP to synapse
  public func applySTDP(
    syn : Synapse,
    deltaTms : Float,
    params : STDPParams
  ) : Synapse {
    let deltaW = computeSTDP(deltaTms, params);
    let newWeight = _clamp(syn.weight + deltaW, params.wMin, params.wMax);
    {
      preNeuronId = syn.preNeuronId;
      postNeuronId = syn.postNeuronId;
      weight = newWeight;
      plasticity = syn.plasticity;
      lastActive = syn.lastActive;
    }
  };

  // ─── CROSS-MODULE INTEGRATION ─────────────────────────────────────────────────
  
  /// Integrate with Kuramoto oscillator coherence
  public func integrateWithKuramoto(
    state : HebbianState,
    orderParameter : Float,
    phaseLocking : Float
  ) : HebbianState {
    // High Kuramoto coherence enhances synaptic consolidation
    // Phase-locked oscillators facilitate Hebbian learning
    let coherenceFactor = 1.0 + (orderParameter - 0.5) * 0.3;
    let phaseFactor = 1.0 + phaseLocking * 0.2;
    
    let newLR = _clamp(state.learningRate * coherenceFactor * phaseFactor, 0.001, 0.5);
    
    {
      synapses = state.synapses;
      learningRate = newLR;
      globalModulation = state.globalModulation * coherenceFactor;
      beatNum = state.beatNum;
      totalSynapticWeight = state.totalSynapticWeight;
      weightHistory = state.weightHistory;
      synapticEntropy = state.synapticEntropy;
      connectionDensity = state.connectionDensity;
      plasticityMode = state.plasticityMode;
      stabilityIndex = state.stabilityIndex * phaseFactor;
    }
  };

  /// Integrate with Friston free energy
  public func integrateWithFriston(
    state : HebbianState,
    freeEnergy : Float,
    predictionError : Float,
    surprisal : Float
  ) : HebbianState {
    // High free energy → increase plasticity to reduce error
    // Prediction error drives learning
    let energyFactor = 1.0 + freeEnergy * 0.1;
    let errorSignal = predictionError * 0.2;
    
    let newLR = _clamp(state.learningRate * energyFactor + errorSignal, 0.001, 0.5);
    let newMod = _clamp(state.globalModulation + surprisal * 0.1, 0.0, 2.0);
    
    {
      synapses = state.synapses;
      learningRate = newLR;
      globalModulation = newMod;
      beatNum = state.beatNum;
      totalSynapticWeight = state.totalSynapticWeight;
      weightHistory = state.weightHistory;
      synapticEntropy = state.synapticEntropy;
      connectionDensity = state.connectionDensity;
      plasticityMode = state.plasticityMode;
      stabilityIndex = state.stabilityIndex;
    }
  };

  /// Integrate with Attractor dynamics
  public func integrateWithAttractor(
    state : HebbianState,
    attractorStrength : Float,
    basinStability : Float
  ) : HebbianState {
    // Strong attractors consolidate synaptic patterns
    // Basin stability indicates memory formation
    let consolidationFactor = attractorStrength * basinStability;
    
    // Strengthen synapses proportional to attractor strength
    let newSynapses = Array.map<Synapse, Synapse>(state.synapses, func(syn) {
      let strengthMod = 1.0 + consolidationFactor * 0.1;
      {
        preNeuronId = syn.preNeuronId;
        postNeuronId = syn.postNeuronId;
        weight = _clamp(syn.weight * strengthMod, 0.0, 5.0);
        plasticity = syn.plasticity;
        lastActive = syn.lastActive;
      }
    });
    
    {
      synapses = newSynapses;
      learningRate = state.learningRate;
      globalModulation = state.globalModulation;
      beatNum = state.beatNum;
      totalSynapticWeight = state.totalSynapticWeight * (1.0 + consolidationFactor * 0.05);
      weightHistory = state.weightHistory;
      synapticEntropy = state.synapticEntropy;
      connectionDensity = state.connectionDensity;
      plasticityMode = state.plasticityMode;
      stabilityIndex = _clamp(state.stabilityIndex + basinStability * 0.1, 0.0, 1.0);
    }
  };

  /// Integrate with Predictive Coding
  public func integrateWithPredictive(
    state : HebbianState,
    topDownPrediction : Float,
    bottomUpError : Float
  ) : HebbianState {
    // Prediction errors drive weight updates
    // Top-down predictions modulate learning direction
    let predictionInfluence = topDownPrediction * 0.5;
    let errorInfluence = bottomUpError * state.learningRate;
    
    {
      synapses = state.synapses;
      learningRate = state.learningRate;
      globalModulation = _clamp(state.globalModulation + predictionInfluence, 0.0, 2.0);
      beatNum = state.beatNum;
      totalSynapticWeight = state.totalSynapticWeight;
      weightHistory = state.weightHistory;
      synapticEntropy = state.synapticEntropy + errorInfluence * 0.01;
      connectionDensity = state.connectionDensity;
      plasticityMode = state.plasticityMode;
      stabilityIndex = state.stabilityIndex;
    }
  };

  /// Integrate with Quantum coherence
  public func integrateWithQuantum(
    state : HebbianState,
    quantumCoherence : Float,
    entanglementStrength : Float
  ) : HebbianState {
    // Quantum coherence enables non-local weight correlations
    // Entanglement creates correlated plasticity patterns
    let coherenceFactor = 1.0 + quantumCoherence * 0.2;
    
    {
      synapses = state.synapses;
      learningRate = state.learningRate * coherenceFactor;
      globalModulation = state.globalModulation;
      beatNum = state.beatNum;
      totalSynapticWeight = state.totalSynapticWeight;
      weightHistory = state.weightHistory;
      synapticEntropy = _clamp(state.synapticEntropy - entanglementStrength * 0.05, 0.0, 10.0);
      connectionDensity = state.connectionDensity;
      plasticityMode = state.plasticityMode;
      stabilityIndex = state.stabilityIndex;
    }
  };

  // ─── NEUROMODULATORY CONTROL ──────────────────────────────────────────────────
  
  /// Neuromodulatory state
  public type NeuromodState = {
    dopamine : Float;      // Reward/motivation
    serotonin : Float;     // Mood/patience
    norepinephrine : Float;// Arousal/attention
    acetylcholine : Float; // Learning/memory
  };

  /// Apply neuromodulation to plasticity
  public func applyNeuromodulation(
    state : HebbianState,
    neuromod : NeuromodState
  ) : HebbianState {
    // Dopamine: modulates reward-based learning
    let daMod = 1.0 + (neuromod.dopamine - 0.5) * 0.5;
    
    // Acetylcholine: enhances encoding
    let achMod = 1.0 + (neuromod.acetylcholine - 0.5) * 0.3;
    
    // Norepinephrine: sharpens learning
    let neMod = 1.0 + (neuromod.norepinephrine - 0.5) * 0.2;
    
    // Serotonin: patience/temporal credit
    let serMod = 1.0 + (neuromod.serotonin - 0.5) * 0.1;
    
    let totalMod = daMod * achMod * neMod * serMod;
    
    {
      synapses = state.synapses;
      learningRate = _clamp(state.learningRate * totalMod, 0.001, 0.5);
      globalModulation = _clamp(state.globalModulation * totalMod, 0.1, 5.0);
      beatNum = state.beatNum;
      totalSynapticWeight = state.totalSynapticWeight;
      weightHistory = state.weightHistory;
      synapticEntropy = state.synapticEntropy;
      connectionDensity = state.connectionDensity;
      plasticityMode = state.plasticityMode;
      stabilityIndex = state.stabilityIndex;
    }
  };

  // ─── HOMEOSTATIC PLASTICITY ───────────────────────────────────────────────────
  
  /// Homeostatic state
  public type HomeostaticState = {
    targetActivity : Float;
    currentActivity : Float;
    scalingFactor : Float;
    threshold : Float;
    convergenceRate : Float;
  };

  /// Compute homeostatic scaling
  public func computeHomeostaticScaling(
    targetActivity : Float,
    currentActivity : Float,
    scalingRate : Float
  ) : Float {
    let error = targetActivity - currentActivity;
    let scaling = 1.0 + error * scalingRate;
    _clamp(scaling, 0.5, 2.0)
  };

  /// Apply homeostatic plasticity (synaptic scaling)
  public func applyHomeostaticPlasticity(
    state : HebbianState,
    targetActivity : Float,
    currentActivity : Float
  ) : HebbianState {
    let scaling = computeHomeostaticScaling(targetActivity, currentActivity, 0.1);
    
    let scaledSynapses = Array.map<Synapse, Synapse>(state.synapses, func(syn) {
      {
        preNeuronId = syn.preNeuronId;
        postNeuronId = syn.postNeuronId;
        weight = _clamp(syn.weight * scaling, 0.0, 5.0);
        plasticity = syn.plasticity;
        lastActive = syn.lastActive;
      }
    });
    
    {
      synapses = scaledSynapses;
      learningRate = state.learningRate;
      globalModulation = state.globalModulation;
      beatNum = state.beatNum;
      totalSynapticWeight = state.totalSynapticWeight * scaling;
      weightHistory = state.weightHistory;
      synapticEntropy = state.synapticEntropy;
      connectionDensity = state.connectionDensity;
      plasticityMode = state.plasticityMode;
      stabilityIndex = state.stabilityIndex;
    }
  };

  // ─── METAPLASTICITY ───────────────────────────────────────────────────────────
  
  /// BCM (Bienenstock-Cooper-Munro) sliding threshold
  public type BCMState = {
    theta : Float;              // Sliding threshold
    thetaHistory : [Float];     // History of threshold
    averageActivity : Float;    // Running average of activity
    timeConstant : Float;       // Threshold adaptation rate
  };

  /// Initialize BCM state
  public func initBCMState() : BCMState {
    {
      theta = 0.5;
      thetaHistory = [];
      averageActivity = 0.5;
      timeConstant = 100.0;
    }
  };

  /// Update BCM threshold
  public func updateBCMThreshold(
    bcm : BCMState,
    currentActivity : Float,
    dt : Float
  ) : BCMState {
    // Threshold adapts to average postsynaptic activity
    let decay = Float.exp(-dt / bcm.timeConstant);
    let newAvg = bcm.averageActivity * decay + currentActivity * (1.0 - decay);
    let newTheta = newAvg * newAvg;  // θ ∝ <y>²
    
    let newHistory = if (bcm.thetaHistory.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { bcm.thetaHistory[i + 1] });
      Array.append(tail, [newTheta])
    } else {
      Array.append(bcm.thetaHistory, [newTheta])
    };
    
    {
      theta = newTheta;
      thetaHistory = newHistory;
      averageActivity = newAvg;
      timeConstant = bcm.timeConstant;
    }
  };

  /// BCM weight update rule
  public func bcmUpdate(
    weight : Float,
    preActivity : Float,
    postActivity : Float,
    theta : Float,
    learningRate : Float
  ) : Float {
    // Δw = η · x · y · (y - θ)
    // LTP when y > θ, LTD when y < θ
    let deltaW = learningRate * preActivity * postActivity * (postActivity - theta);
    _clamp(weight + deltaW, 0.0, 5.0)
  };

  // ─── ORGANISM OUTPUT INTEGRATION ──────────────────────────────────────────────
  
  /// Complete organism output
  public type HebbianOrganismOutput = {
    // Core metrics
    totalSynapticWeight : Float;
    averageWeight : Float;
    synapticEntropy : Float;
    
    // Learning metrics
    learningRate : Float;
    plasticityIndex : Float;
    consolidationStrength : Float;
    
    // Homeostatic metrics
    homeostaticError : Float;
    synapticScaling : Float;
    firingRateDeviation : Float;
    
    // Structural metrics
    connectionDensity : Float;
    synapseCount : Nat;
    pathwayStrength : Float;
    
    // Memory metrics
    shortTermPotentiation : Float;
    longTermPotentiation : Float;
    memoryStability : Float;
    
    // Integration metrics
    kuramotoInfluence : Float;
    fristonInfluence : Float;
    attractorInfluence : Float;
  };

  /// Generate organism output
  public func generateOrganismOutput(state : HebbianState) : HebbianOrganismOutput {
    let n = state.synapses.size();
    let avgWeight = if (n > 0) { state.totalSynapticWeight / Float.fromInt(n) } else { 0.0 };
    
    {
      totalSynapticWeight = state.totalSynapticWeight;
      averageWeight = avgWeight;
      synapticEntropy = state.synapticEntropy;
      learningRate = state.learningRate;
      plasticityIndex = state.globalModulation;
      consolidationStrength = state.stabilityIndex;
      homeostaticError = 0.0;  // Would be computed from target/actual
      synapticScaling = 1.0;
      firingRateDeviation = 0.0;
      connectionDensity = state.connectionDensity;
      synapseCount = n;
      pathwayStrength = state.totalSynapticWeight / (Float.fromInt(n) + 1.0);
      shortTermPotentiation = state.globalModulation * 0.5;
      longTermPotentiation = state.stabilityIndex * state.globalModulation;
      memoryStability = state.stabilityIndex;
      kuramotoInfluence = 0.0;
      fristonInfluence = 0.0;
      attractorInfluence = 0.0;
    }
  };

  // ─── OUTWARD EXTENSIONS ───────────────────────────────────────────────────────
  
  /// Output for Kuramoto
  public func outputToKuramoto(state : HebbianState) : { syncWeights : [Float]; couplingStrength : Float } {
    var weights : [Float] = [];
    for (syn in state.synapses.vals()) {
      weights := Array.append(weights, [syn.weight]);
    };
    {
      syncWeights = weights;
      couplingStrength = state.globalModulation;
    }
  };

  /// Output for Friston
  public func outputToFriston(state : HebbianState) : { modelComplexity : Float; learningSignal : Float } {
    {
      modelComplexity = state.synapticEntropy;
      learningSignal = state.learningRate * state.globalModulation;
    }
  };

  /// Output for Attractor
  public func outputToAttractor(state : HebbianState) : { memoryBasins : [Float]; basinDepth : Float } {
    var basins : [Float] = [];
    for (syn in state.synapses.vals()) {
      basins := Array.append(basins, [syn.weight / 5.0]);
    };
    {
      memoryBasins = basins;
      basinDepth = state.stabilityIndex;
    }
  };

  /// Output for Predictive
  public func outputToPredictive(state : HebbianState) : { weightedPrediction : Float; confidence : Float } {
    {
      weightedPrediction = state.totalSynapticWeight / (Float.fromInt(state.synapses.size()) + 1.0);
      confidence = state.stabilityIndex;
    }
  };

  /// Output for Defense
  public func outputToDefense(state : HebbianState) : { learningReadiness : Float; adaptationCapacity : Float } {
    {
      learningReadiness = state.learningRate * state.globalModulation;
      adaptationCapacity = 1.0 - state.stabilityIndex;  // High stability = low adaptation
    }
  };

  /// Master output
  public func generateAllOutputs(state : HebbianState) : {
    kuramoto : { syncWeights : [Float]; couplingStrength : Float };
    friston : { modelComplexity : Float; learningSignal : Float };
    attractor : { memoryBasins : [Float]; basinDepth : Float };
    predictive : { weightedPrediction : Float; confidence : Float };
    defense : { learningReadiness : Float; adaptationCapacity : Float };
    organism : HebbianOrganismOutput;
  } {
    {
      kuramoto = outputToKuramoto(state);
      friston = outputToFriston(state);
      attractor = outputToAttractor(state);
      predictive = outputToPredictive(state);
      defense = outputToDefense(state);
      organism = generateOrganismOutput(state);
    }
  };

  // ─── FULL ORGANISM BEAT ───────────────────────────────────────────────────────
  
  /// Complete organism beat
  public func fullOrganismBeat(
    state : HebbianState,
    kuramotoOrder : Float,
    fristonFreeEnergy : Float,
    attractorStrength : Float,
    quantumCoherence : Float,
    neuromod : NeuromodState
  ) : (HebbianState, HebbianOrganismOutput) {
    // Layer 1: Core Hebbian update
    var newState = updateHebbian(state, 1.0);
    
    // Layer 2: Kuramoto integration
    newState := integrateWithKuramoto(newState, kuramotoOrder, 0.5);
    
    // Layer 3: Friston integration
    newState := integrateWithFriston(newState, fristonFreeEnergy, 0.1, 0.1);
    
    // Layer 4: Attractor integration
    newState := integrateWithAttractor(newState, attractorStrength, 0.5);
    
    // Layer 5: Quantum integration
    newState := integrateWithQuantum(newState, quantumCoherence, 0.3);
    
    // Layer 6: Neuromodulation
    newState := applyNeuromodulation(newState, neuromod);
    
    // Layer 7: Homeostatic plasticity
    newState := applyHomeostaticPlasticity(newState, 0.1, 0.1);
    
    let output = generateOrganismOutput(newState);
    (newState, output)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: ADVANCED STDP VARIANTS — BIOLOGICALLY DETAILED PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════════
  // Multiple STDP variants modeling different synapse types and brain regions
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Triplet STDP state - considers spike triplets, not just pairs
  public type TripletSTDPState = {
    neurons     : [Neuron];
    synapses    : [Synapse];
    // Triplet traces
    r1          : [Float];    // Fast presynaptic trace
    r2          : [Float];    // Slow presynaptic trace
    o1          : [Float];    // Fast postsynaptic trace
    o2          : [Float];    // Slow postsynaptic trace
    // Triplet parameters
    A2Plus      : Float;      // Pair LTP amplitude
    A3Plus      : Float;      // Triplet LTP amplitude
    A2Minus     : Float;      // Pair LTD amplitude
    A3Minus     : Float;      // Triplet LTD amplitude
    tauPlus     : Float;
    tauMinus    : Float;
    tauX        : Float;      // Slow pre trace decay
    tauY        : Float;      // Slow post trace decay
    beatNum     : Nat;
  };

  /// Initialize triplet STDP
  public func initTripletSTDP(numNeurons: Nat) : TripletSTDPState {
    let neurons = Array.tabulate<Neuron>(numNeurons, func(i) {
      { activation = 0.0; threshold = 0.5; spikeHistory = []; avgActivity = 0.1 }
    });
    
    // Full connectivity
    var synapses : [Synapse] = [];
    for (i in Array.keys(neurons)) {
      for (j in Array.keys(neurons)) {
        if (i != j) {
          synapses := Array.append(synapses, [{
            weight = 0.5;
            preIdx = i;
            postIdx = j;
            lastPreSpike = 0;
            lastPostSpike = 0;
            eligibility = 0.0;
          }]);
        };
      };
    };
    
    {
      neurons = neurons;
      synapses = synapses;
      r1 = Array.tabulate<Float>(numNeurons, func(_) { 0.0 });
      r2 = Array.tabulate<Float>(numNeurons, func(_) { 0.0 });
      o1 = Array.tabulate<Float>(numNeurons, func(_) { 0.0 });
      o2 = Array.tabulate<Float>(numNeurons, func(_) { 0.0 });
      A2Plus = 0.1;
      A3Plus = 0.05;
      A2Minus = 0.12;
      A3Minus = 0.06;
      tauPlus = 17.0;
      tauMinus = 34.0;
      tauX = 101.0;
      tauY = 125.0;
      beatNum = 0;
    }
  };

  /// Update triplet STDP traces
  public func updateTripletSTDP(state: TripletSTDPState, spikes: [Bool], dt: Float) : TripletSTDPState {
    let n = state.neurons.size();
    
    // Decay traces
    let decayPlus = Float.exp(-dt / state.tauPlus);
    let decayMinus = Float.exp(-dt / state.tauMinus);
    let decayX = Float.exp(-dt / state.tauX);
    let decayY = Float.exp(-dt / state.tauY);
    
    var newR1 : [Float] = [];
    var newR2 : [Float] = [];
    var newO1 : [Float] = [];
    var newO2 : [Float] = [];
    
    for (i in Array.keys(Array.tabulate<Nat>(n, func(x) { x }))) {
      let spiked = spikes[i];
      
      // Pre traces: r1 fast, r2 slow
      let r1_decayed = state.r1[i] * decayPlus;
      let r2_decayed = state.r2[i] * decayX;
      
      // Post traces: o1 fast, o2 slow
      let o1_decayed = state.o1[i] * decayMinus;
      let o2_decayed = state.o2[i] * decayY;
      
      // Add 1 on spike
      let newR1Val = if (spiked) { r1_decayed + 1.0 } else { r1_decayed };
      let newR2Val = if (spiked) { r2_decayed + 1.0 } else { r2_decayed };
      let newO1Val = if (spiked) { o1_decayed + 1.0 } else { o1_decayed };
      let newO2Val = if (spiked) { o2_decayed + 1.0 } else { o2_decayed };
      
      newR1 := Array.append(newR1, [newR1Val]);
      newR2 := Array.append(newR2, [newR2Val]);
      newO1 := Array.append(newO1, [newO1Val]);
      newO2 := Array.append(newO2, [newO2Val]);
    };
    
    // Update synaptic weights using triplet rule
    var newSynapses : [Synapse] = [];
    for (syn in state.synapses.vals()) {
      let pre = syn.preIdx;
      let post = syn.postIdx;
      
      var dw : Float = 0.0;
      
      // LTP: post spikes → use pre traces
      if (spikes[post]) {
        // Pair term: A2+ * r1(pre)
        dw += state.A2Plus * newR1[pre];
        // Triplet term: A3+ * r1(pre) * o2(post)
        dw += state.A3Plus * newR1[pre] * state.o2[post];
      };
      
      // LTD: pre spikes → use post traces  
      if (spikes[pre]) {
        // Pair term: -A2- * o1(post)
        dw -= state.A2Minus * newO1[post];
        // Triplet term: -A3- * o1(post) * r2(pre)
        dw -= state.A3Minus * newO1[post] * state.r2[pre];
      };
      
      let newWeight = _clamp(syn.weight + dw, 0.0, 2.0);
      newSynapses := Array.append(newSynapses, [{
        weight = newWeight;
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        lastPreSpike = if (spikes[pre]) { state.beatNum } else { syn.lastPreSpike };
        lastPostSpike = if (spikes[post]) { state.beatNum } else { syn.lastPostSpike };
        eligibility = syn.eligibility;
      }]);
    };
    
    {
      neurons = state.neurons;
      synapses = newSynapses;
      r1 = newR1;
      r2 = newR2;
      o1 = newO1;
      o2 = newO2;
      A2Plus = state.A2Plus;
      A3Plus = state.A3Plus;
      A2Minus = state.A2Minus;
      A3Minus = state.A3Minus;
      tauPlus = state.tauPlus;
      tauMinus = state.tauMinus;
      tauX = state.tauX;
      tauY = state.tauY;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: VOLTAGE-DEPENDENT STDP — MEMBRANE POTENTIAL INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  // STDP that depends on postsynaptic membrane potential (more biologically accurate)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Voltage-dependent STDP state
  public type VoltageSTDPState = {
    // Membrane potentials
    voltages    : [Float];
    // Voltage-dependent plasticity vars
    uBar        : [Float];    // Low-pass filtered voltage (LTD)
    uBarBar     : [Float];    // Very slow filtered voltage (LTP)
    // Thresholds
    thetaMinus  : Float;      // LTD threshold
    thetaPlus   : Float;      // LTP threshold
    // Synapses
    synapses    : [Synapse];
    // Time constants
    tauU        : Float;
    tauUBar     : Float;
    // Parameters
    ALTP        : Float;
    ALTD        : Float;
    wMax        : Float;
    beatNum     : Nat;
  };

  /// Initialize voltage-dependent STDP
  public func initVoltageSTDP(numNeurons: Nat) : VoltageSTDPState {
    let restingPotential = -70.0;  // mV
    
    var synapses : [Synapse] = [];
    for (i in Array.keys(Array.tabulate<Nat>(numNeurons, func(x) { x }))) {
      for (j in Array.keys(Array.tabulate<Nat>(numNeurons, func(x) { x }))) {
        if (i != j) {
          synapses := Array.append(synapses, [{
            weight = 0.5;
            preIdx = i;
            postIdx = j;
            lastPreSpike = 0;
            lastPostSpike = 0;
            eligibility = 0.0;
          }]);
        };
      };
    };
    
    {
      voltages = Array.tabulate<Float>(numNeurons, func(_) { restingPotential });
      uBar = Array.tabulate<Float>(numNeurons, func(_) { restingPotential });
      uBarBar = Array.tabulate<Float>(numNeurons, func(_) { restingPotential });
      thetaMinus = -70.6;  // mV
      thetaPlus = -45.3;   // mV (near spike threshold)
      synapses = synapses;
      tauU = 10.0;         // ms
      tauUBar = 7.0;       // ms
      ALTP = 0.001;
      ALTD = 0.0014;
      wMax = 2.0;
      beatNum = 0;
    }
  };

  /// Update voltage-dependent STDP
  public func updateVoltageSTDP(state: VoltageSTDPState, voltages: [Float], spikes: [Bool], dt: Float) : VoltageSTDPState {
    let n = voltages.size();
    
    // Update low-pass filtered voltages
    let decayU = Float.exp(-dt / state.tauU);
    let decayUBar = Float.exp(-dt / state.tauUBar);
    
    var newUBar : [Float] = [];
    var newUBarBar : [Float] = [];
    
    for (i in Array.keys(voltages)) {
      // uBar: fast filter
      let uBar_new = state.uBar[i] * decayU + voltages[i] * (1.0 - decayU);
      // uBarBar: slow filter
      let uBarBar_new = state.uBarBar[i] * decayUBar + voltages[i] * (1.0 - decayUBar);
      
      newUBar := Array.append(newUBar, [uBar_new]);
      newUBarBar := Array.append(newUBarBar, [uBarBar_new]);
    };
    
    // Update synaptic weights
    var newSynapses : [Synapse] = [];
    for (syn in state.synapses.vals()) {
      let pre = syn.preIdx;
      let post = syn.postIdx;
      
      var dw : Float = 0.0;
      
      // LTP: pre spike + (u_post - theta_minus)_+ * (uBar - theta_plus)_+
      if (spikes[pre]) {
        let uPost = voltages[post];
        let uBarPost = newUBar[post];
        
        let term1 = if (uPost > state.thetaMinus) { uPost - state.thetaMinus } else { 0.0 };
        let term2 = if (uBarPost > state.thetaPlus) { uBarPost - state.thetaPlus } else { 0.0 };
        
        dw += state.ALTP * term1 * term2;
      };
      
      // LTD: pre spike + (uBarBar - theta_minus)_+
      if (spikes[pre]) {
        let uBarBarPost = newUBarBar[post];
        let term = if (uBarBarPost > state.thetaMinus) { uBarBarPost - state.thetaMinus } else { 0.0 };
        
        dw -= state.ALTD * term;
      };
      
      let newWeight = _clamp(syn.weight + dw, 0.0, state.wMax);
      newSynapses := Array.append(newSynapses, [{
        weight = newWeight;
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        lastPreSpike = if (spikes[pre]) { state.beatNum } else { syn.lastPreSpike };
        lastPostSpike = if (spikes[post]) { state.beatNum } else { syn.lastPostSpike };
        eligibility = syn.eligibility;
      }]);
    };
    
    {
      voltages = voltages;
      uBar = newUBar;
      uBarBar = newUBarBar;
      thetaMinus = state.thetaMinus;
      thetaPlus = state.thetaPlus;
      synapses = newSynapses;
      tauU = state.tauU;
      tauUBar = state.tauUBar;
      ALTP = state.ALTP;
      ALTD = state.ALTD;
      wMax = state.wMax;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: REWARD-MODULATED STDP — REINFORCEMENT LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  // Three-factor learning rule: eligibility × reward × STDP
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Reward-modulated STDP state
  public type RewardSTDPState = {
    neurons     : [Neuron];
    synapses    : [Synapse];
    // Eligibility traces
    eligibility : [[Float]];  // Per synapse (flattened matrix)
    // Reward signals
    rewardTrace : Float;      // Running reward average
    reward      : Float;      // Current reward
    rewardPred  : Float;      // Reward prediction
    // TD learning
    valuePred   : Float;      // Value function estimate
    gamma       : Float;      // Discount factor
    // Parameters
    eligTau     : Float;      // Eligibility trace decay
    rewardTau   : Float;      // Reward trace decay
    learningRate: Float;
    beatNum     : Nat;
  };

  /// Initialize reward-modulated STDP
  public func initRewardSTDP(numNeurons: Nat) : RewardSTDPState {
    let neurons = Array.tabulate<Neuron>(numNeurons, func(_) {
      { activation = 0.0; threshold = 0.5; spikeHistory = []; avgActivity = 0.1 }
    });
    
    var synapses : [Synapse] = [];
    var eligibility : [[Float]] = [];
    
    for (i in Array.keys(neurons)) {
      var row : [Float] = [];
      for (j in Array.keys(neurons)) {
        if (i != j) {
          synapses := Array.append(synapses, [{
            weight = 0.5;
            preIdx = i;
            postIdx = j;
            lastPreSpike = 0;
            lastPostSpike = 0;
            eligibility = 0.0;
          }]);
        };
        row := Array.append(row, [0.0]);
      };
      eligibility := Array.append(eligibility, [row]);
    };
    
    {
      neurons = neurons;
      synapses = synapses;
      eligibility = eligibility;
      rewardTrace = 0.0;
      reward = 0.0;
      rewardPred = 0.0;
      valuePred = 0.0;
      gamma = 0.99;
      eligTau = 100.0;
      rewardTau = 50.0;
      learningRate = 0.01;
      beatNum = 0;
    }
  };

  /// Compute STDP eligibility trace update
  func computeSTDPEligibility(pre: Float, post: Float, preSpike: Bool, postSpike: Bool, 
                              tauPlus: Float, tauMinus: Float, dt: Float) : Float {
    var elig : Float = 0.0;
    
    // Post before pre → LTD
    if (preSpike and post > 0.5) {
      elig -= Float.exp(-dt / tauMinus);
    };
    
    // Pre before post → LTP
    if (postSpike and pre > 0.5) {
      elig += Float.exp(-dt / tauPlus);
    };
    
    elig
  };

  /// Update reward-modulated STDP
  public func updateRewardSTDP(state: RewardSTDPState, spikes: [Bool], reward: Float, dt: Float) : RewardSTDPState {
    let n = state.neurons.size();
    
    // Decay eligibility traces
    let eligDecay = Float.exp(-dt / state.eligTau);
    
    var newEligibility = state.eligibility;
    
    // Update eligibility from current STDP
    for (syn in state.synapses.vals()) {
      let pre = syn.preIdx;
      let post = syn.postIdx;
      
      // STDP contribution
      let stdp = computeSTDPEligibility(
        state.neurons[pre].activation,
        state.neurons[post].activation,
        spikes[pre],
        spikes[post],
        20.0, 20.0, dt
      );
      
      // Update eligibility
      let row = Array.thaw<Float>(newEligibility[pre]);
      row[post] := row[post] * eligDecay + stdp;
      newEligibility := Array.tabulate<[Float]>(n, func(idx) {
        if (idx == pre) { Array.freeze(row) } else { newEligibility[idx] }
      });
    };
    
    // Update reward trace
    let rewardDecay = Float.exp(-dt / state.rewardTau);
    let newRewardTrace = state.rewardTrace * rewardDecay + reward * (1.0 - rewardDecay);
    
    // TD error: δ = r + γV' - V
    let tdError = reward + state.gamma * state.valuePred - state.rewardPred;
    
    // Update synaptic weights: Δw = η * e * δ
    var newSynapses : [Synapse] = [];
    for (syn in state.synapses.vals()) {
      let elig = newEligibility[syn.preIdx][syn.postIdx];
      let dw = state.learningRate * elig * tdError;
      let newWeight = _clamp(syn.weight + dw, 0.0, 2.0);
      
      newSynapses := Array.append(newSynapses, [{
        weight = newWeight;
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        lastPreSpike = if (spikes[syn.preIdx]) { state.beatNum } else { syn.lastPreSpike };
        lastPostSpike = if (spikes[syn.postIdx]) { state.beatNum } else { syn.lastPostSpike };
        eligibility = elig;
      }]);
    };
    
    {
      neurons = state.neurons;
      synapses = newSynapses;
      eligibility = newEligibility;
      rewardTrace = newRewardTrace;
      reward = reward;
      rewardPred = state.valuePred;
      valuePred = state.valuePred + 0.01 * tdError;  // Update value estimate
      gamma = state.gamma;
      eligTau = state.eligTau;
      rewardTau = state.rewardTau;
      learningRate = state.learningRate;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: STRUCTURAL PLASTICITY — SYNAPTOGENESIS & PRUNING
  // ═══════════════════════════════════════════════════════════════════════════════
  // Synapses can form and die based on activity and weight
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Structural plasticity state
  public type StructuralPlasticityState = {
    neurons          : [Neuron];
    synapses         : [Synapse];
    // Structural parameters
    birthRate        : Float;    // Probability of new synapse per beat
    deathThreshold   : Float;    // Weight below which synapse dies
    maxSynapsesPerNeuron : Nat;
    // Statistics
    totalBirths      : Nat;
    totalDeaths      : Nat;
    synapseLifetimes : [Nat];    // Ages of current synapses
    beatNum          : Nat;
  };

  /// Initialize structural plasticity
  public func initStructuralPlasticity(numNeurons: Nat, connectivity: Float) : StructuralPlasticityState {
    let neurons = Array.tabulate<Neuron>(numNeurons, func(_) {
      { activation = 0.0; threshold = 0.5; spikeHistory = []; avgActivity = 0.1 }
    });
    
    // Create synapses with given connectivity probability
    var synapses : [Synapse] = [];
    var lifetimes : [Nat] = [];
    var seed : Nat = 12345;
    
    for (i in Array.keys(neurons)) {
      for (j in Array.keys(neurons)) {
        if (i != j) {
          // Pseudo-random connectivity
          seed := (seed * 1103515245 + 12345) % 2147483648;
          let rand = Float.fromInt(seed % 1000) / 1000.0;
          
          if (rand < connectivity) {
            synapses := Array.append(synapses, [{
              weight = 0.3 + rand * 0.4;  // Random initial weight
              preIdx = i;
              postIdx = j;
              lastPreSpike = 0;
              lastPostSpike = 0;
              eligibility = 0.0;
            }]);
            lifetimes := Array.append(lifetimes, [0]);
          };
        };
      };
    };
    
    {
      neurons = neurons;
      synapses = synapses;
      birthRate = 0.001;
      deathThreshold = 0.05;
      maxSynapsesPerNeuron = numNeurons / 2;
      totalBirths = 0;
      totalDeaths = 0;
      synapseLifetimes = lifetimes;
      beatNum = 0;
    }
  };

  /// Update structural plasticity (synapse birth and death)
  public func updateStructuralPlasticity(state: StructuralPlasticityState, seed: Nat) : StructuralPlasticityState {
    var newSynapses : [Synapse] = [];
    var newLifetimes : [Nat] = [];
    var deaths : Nat = 0;
    var currentSeed = seed;
    
    // Check each synapse for death
    for (i in Array.keys(state.synapses)) {
      let syn = state.synapses[i];
      let lifetime = state.synapseLifetimes[i];
      
      // Synapse dies if weight too low AND has lived long enough to be pruned
      if (syn.weight < state.deathThreshold and lifetime > 100) {
        deaths += 1;
        // Don't add to new list (dies)
      } else {
        newSynapses := Array.append(newSynapses, [syn]);
        newLifetimes := Array.append(newLifetimes, [lifetime + 1]);
      };
    };
    
    // Count synapses per neuron (outgoing)
    let n = state.neurons.size();
    var outCount = Array.tabulate<Nat>(n, func(_) { 0 });
    for (syn in newSynapses.vals()) {
      let countsMut = Array.thaw<Nat>(outCount);
      countsMut[syn.preIdx] := countsMut[syn.preIdx] + 1;
      outCount := Array.freeze(countsMut);
    };
    
    // Try to birth new synapses
    var births : Nat = 0;
    for (pre in Array.keys(state.neurons)) {
      if (outCount[pre] < state.maxSynapsesPerNeuron) {
        // Check if we should birth a synapse
        currentSeed := (currentSeed * 1103515245 + 12345) % 2147483648;
        let rand = Float.fromInt(currentSeed % 1000) / 1000.0;
        
        if (rand < state.birthRate) {
          // Pick random postsynaptic target
          currentSeed := (currentSeed * 1103515245 + 12345) % 2147483648;
          let post = currentSeed % n;
          
          // Check if this synapse already exists
          var exists = false;
          for (syn in newSynapses.vals()) {
            if (syn.preIdx == pre and syn.postIdx == post) { exists := true };
          };
          
          if (not exists and pre != post) {
            // Birth new synapse with small weight
            newSynapses := Array.append(newSynapses, [{
              weight = 0.1;
              preIdx = pre;
              postIdx = post;
              lastPreSpike = state.beatNum;
              lastPostSpike = state.beatNum;
              eligibility = 0.0;
            }]);
            newLifetimes := Array.append(newLifetimes, [0]);
            births += 1;
          };
        };
      };
    };
    
    {
      neurons = state.neurons;
      synapses = newSynapses;
      birthRate = state.birthRate;
      deathThreshold = state.deathThreshold;
      maxSynapsesPerNeuron = state.maxSynapsesPerNeuron;
      totalBirths = state.totalBirths + births;
      totalDeaths = state.totalDeaths + deaths;
      synapseLifetimes = newLifetimes;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: METAPLASTICITY — PLASTICITY OF PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════════
  // Learning rate and STDP parameters change based on activity history
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Metaplasticity state
  public type MetaplasticityState = {
    // Per-synapse plasticity parameters
    learningRates   : [Float];
    ltpAmplitudes   : [Float];
    ltdAmplitudes   : [Float];
    // Metaplastic history
    recentActivity  : [[Float]];  // Running activity history
    bcmThresholds   : [Float];    // Sliding BCM thresholds
    // Global
    globalMeta      : Float;      // Global metaplasticity state
    activityTau     : Float;      // Activity averaging time constant
    metaTau         : Float;      // Metaplasticity time constant
    beatNum         : Nat;
  };

  /// Initialize metaplasticity
  public func initMetaplasticity(numSynapses: Nat, numNeurons: Nat) : MetaplasticityState {
    {
      learningRates = Array.tabulate<Float>(numSynapses, func(_) { 0.01 });
      ltpAmplitudes = Array.tabulate<Float>(numSynapses, func(_) { 0.1 });
      ltdAmplitudes = Array.tabulate<Float>(numSynapses, func(_) { 0.12 });
      recentActivity = Array.tabulate<[Float]>(numNeurons, func(_) { 
        Array.tabulate<Float>(10, func(_) { 0.0 }) 
      });
      bcmThresholds = Array.tabulate<Float>(numNeurons, func(_) { 0.5 });
      globalMeta = 1.0;
      activityTau = 50.0;
      metaTau = 1000.0;
      beatNum = 0;
    }
  };

  /// Update metaplasticity based on activity
  public func updateMetaplasticity(state: MetaplasticityState, 
                                   neuronActivity: [Float], 
                                   synapses: [Synapse],
                                   dt: Float) : MetaplasticityState {
    let n = neuronActivity.size();
    let numSyn = state.learningRates.size();
    
    // Update recent activity (sliding window)
    var newActivity : [[Float]] = [];
    var newThresholds : [Float] = [];
    
    for (i in Array.keys(neuronActivity)) {
      let oldHist = state.recentActivity[i];
      let newHist = if (oldHist.size() >= 10) {
        let tail = Array.tabulate<Float>(9, func(j) { oldHist[j + 1] });
        Array.append<Float>(tail, [neuronActivity[i]])
      } else {
        Array.append<Float>(oldHist, [neuronActivity[i]])
      };
      newActivity := Array.append(newActivity, [newHist]);
      
      // Update BCM threshold: θ = E[activity²]
      var actSqSum : Float = 0.0;
      for (a in newHist.vals()) { actSqSum += a * a };
      let avgActSq = actSqSum / Float.fromInt(newHist.size());
      
      // Exponential moving average of threshold
      let decay = Float.exp(-dt / state.activityTau);
      let newThresh = state.bcmThresholds[i] * decay + avgActSq * (1.0 - decay);
      newThresholds := Array.append(newThresholds, [newThresh]);
    };
    
    // Update per-synapse plasticity parameters
    var newLR : [Float] = [];
    var newLTP : [Float] = [];
    var newLTD : [Float] = [];
    
    for (sIdx in Array.keys(synapses)) {
      let syn = synapses[sIdx];
      let postThresh = newThresholds[syn.postIdx];
      let postAct = neuronActivity[syn.postIdx];
      
      // High activity relative to threshold → decrease LTP, increase LTD
      // Low activity relative to threshold → increase LTP, decrease LTD
      let relActivity = postAct / (postThresh + 0.01);
      
      let metaFactor = state.globalMeta;
      
      // Adjust learning rate based on activity history
      let baseLR = state.learningRates[sIdx];
      let newLRVal = baseLR * (0.9 + 0.2 / (1.0 + relActivity));
      
      // Adjust LTP/LTD amplitudes (BCM-like)
      let baseLTP = state.ltpAmplitudes[sIdx];
      let baseLTD = state.ltdAmplitudes[sIdx];
      
      // Low activity → more LTP, high activity → more LTD
      let ltpMod = 1.0 + 0.5 * (1.0 - relActivity);
      let ltdMod = 1.0 + 0.5 * relActivity;
      
      newLR := Array.append(newLR, [_clamp(newLRVal * metaFactor, 0.001, 0.1)]);
      newLTP := Array.append(newLTP, [_clamp(baseLTP * ltpMod, 0.01, 0.5)]);
      newLTD := Array.append(newLTD, [_clamp(baseLTD * ltdMod, 0.01, 0.5)]);
    };
    
    // Update global metaplasticity (slow drift based on network activity)
    var totalAct : Float = 0.0;
    for (a in neuronActivity.vals()) { totalAct += a };
    let avgAct = totalAct / Float.fromInt(n);
    
    let metaDecay = Float.exp(-dt / state.metaTau);
    let newGlobalMeta = state.globalMeta * metaDecay + (1.0 - avgAct) * (1.0 - metaDecay);
    
    {
      learningRates = newLR;
      ltpAmplitudes = newLTP;
      ltdAmplitudes = newLTD;
      recentActivity = newActivity;
      bcmThresholds = newThresholds;
      globalMeta = _clamp(newGlobalMeta, 0.5, 2.0);
      activityTau = state.activityTau;
      metaTau = state.metaTau;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: SPARSE CODING & COMPETITIVE LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  // Neurons compete for activation, promoting sparse representations
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Competitive learning state
  public type CompetitiveLearningState = {
    neurons     : [Neuron];
    weights     : [[Float]];    // Input → neuron weights
    inputDim    : Nat;
    numNeurons  : Nat;
    // Competition parameters
    winnerCount : Nat;          // k for k-WTA
    inhibition  : Float;        // Lateral inhibition strength
    // Learning
    learningRate: Float;
    // Statistics
    winCounts   : [Nat];        // How often each neuron wins
    beatNum     : Nat;
  };

  /// Initialize competitive learning
  public func initCompetitiveLearning(inputDim: Nat, numNeurons: Nat, winnerCount: Nat) : CompetitiveLearningState {
    // Initialize weights randomly (pseudo-random)
    var weights : [[Float]] = [];
    var seed : Nat = 54321;
    
    for (n in Array.keys(Array.tabulate<Nat>(numNeurons, func(x) { x }))) {
      var row : [Float] = [];
      for (i in Array.keys(Array.tabulate<Nat>(inputDim, func(x) { x }))) {
        seed := (seed * 1103515245 + 12345) % 2147483648;
        let rand = Float.fromInt(seed % 1000) / 1000.0;
        row := Array.append(row, [rand]);
      };
      // Normalize
      var norm : Float = 0.0;
      for (w in row.vals()) { norm += w * w };
      norm := Float.sqrt(norm);
      row := Array.map<Float, Float>(row, func(w) { w / norm });
      weights := Array.append(weights, [row]);
    };
    
    let neurons = Array.tabulate<Neuron>(numNeurons, func(_) {
      { activation = 0.0; threshold = 0.5; spikeHistory = []; avgActivity = 0.1 }
    });
    
    {
      neurons = neurons;
      weights = weights;
      inputDim = inputDim;
      numNeurons = numNeurons;
      winnerCount = winnerCount;
      inhibition = 0.5;
      learningRate = 0.01;
      winCounts = Array.tabulate<Nat>(numNeurons, func(_) { 0 });
      beatNum = 0;
    }
  };

  /// Compute neuron activations via dot product
  func computeCompetitiveActivations(weights: [[Float]], input: [Float]) : [Float] {
    Array.map<[Float], Float>(weights, func(w) {
      var dot : Float = 0.0;
      for (i in Array.keys(w)) {
        dot += w[i] * input[i];
      };
      dot
    })
  };

  /// k-Winner-Take-All: only top k neurons activate
  func kWTA(activations: [Float], k: Nat) : [Bool] {
    let n = activations.size();
    if (k >= n) {
      return Array.tabulate<Bool>(n, func(_) { true });
    };
    
    // Find kth largest activation
    var sorted : [Float] = activations;
    // Simple bubble sort for small arrays
    let sortedMut = Array.thaw<Float>(sorted);
    for (i in Array.keys(sorted)) {
      for (j in Array.keys(sorted)) {
        if (j > i and sortedMut[j] > sortedMut[i]) {
          let temp = sortedMut[i];
          sortedMut[i] := sortedMut[j];
          sortedMut[j] := temp;
        };
      };
    };
    sorted := Array.freeze(sortedMut);
    
    let threshold = sorted[k - 1];
    
    // Select winners
    Array.tabulate<Bool>(n, func(i) {
      activations[i] >= threshold
    })
  };

  /// Update competitive learning
  public func updateCompetitiveLearning(state: CompetitiveLearningState, input: [Float]) : CompetitiveLearningState {
    // Normalize input
    var inputNorm : Float = 0.0;
    for (x in input.vals()) { inputNorm += x * x };
    inputNorm := Float.sqrt(inputNorm);
    let normInput = if (inputNorm > 1e-10) {
      Array.map<Float, Float>(input, func(x) { x / inputNorm })
    } else { input };
    
    // Compute activations
    let activations = computeCompetitiveActivations(state.weights, normInput);
    
    // k-WTA competition
    let winners = kWTA(activations, state.winnerCount);
    
    // Update weights for winners (move toward input)
    var newWeights : [[Float]] = [];
    var newWinCounts = state.winCounts;
    
    for (n in Array.keys(state.weights)) {
      if (winners[n]) {
        // Hebbian update: Δw = η(x - w)
        let newW = Array.tabulate<Float>(state.inputDim, func(i) {
          let w = state.weights[n][i];
          w + state.learningRate * (normInput[i] - w)
        });
        
        // Normalize
        var norm : Float = 0.0;
        for (w in newW.vals()) { norm += w * w };
        norm := Float.sqrt(norm);
        let normalizedW = if (norm > 1e-10) {
          Array.map<Float, Float>(newW, func(w) { w / norm })
        } else { newW };
        
        newWeights := Array.append(newWeights, [normalizedW]);
        
        // Update win count
        let countsMut = Array.thaw<Nat>(newWinCounts);
        countsMut[n] := countsMut[n] + 1;
        newWinCounts := Array.freeze(countsMut);
      } else {
        newWeights := Array.append(newWeights, [state.weights[n]]);
      };
    };
    
    // Update neuron activations
    let newNeurons = Array.tabulate<Neuron>(state.numNeurons, func(i) {
      {
        activation = if (winners[i]) { activations[i] } else { 0.0 };
        threshold = state.neurons[i].threshold;
        spikeHistory = state.neurons[i].spikeHistory;
        avgActivity = state.neurons[i].avgActivity;
      }
    });
    
    {
      neurons = newNeurons;
      weights = newWeights;
      inputDim = state.inputDim;
      numNeurons = state.numNeurons;
      winnerCount = state.winnerCount;
      inhibition = state.inhibition;
      learningRate = state.learningRate;
      winCounts = newWinCounts;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 18: MEMORY CONSOLIDATION — SHARP-WAVE RIPPLE REPLAY
  // ═══════════════════════════════════════════════════════════════════════════════
  // Offline replay of activity patterns for memory consolidation
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Memory trace for replay
  public type MemoryTrace = {
    pattern     : [Float];      // Activity pattern
    importance  : Float;        // Salience/novelty
    timestamp   : Nat;          // When recorded
    replayed    : Nat;          // How many times replayed
  };

  /// Memory consolidation state
  public type MemoryConsolidationState = {
    // Synaptic weights
    synapses    : [Synapse];
    // Memory buffer (hippocampal-like)
    memoryBuffer : [MemoryTrace];
    bufferSize  : Nat;
    // Replay parameters
    replayRate  : Float;        // Probability of replay per beat
    replayGain  : Float;        // Learning rate during replay
    // Consolidation
    corticalWeights : [[Float]]; // Long-term storage weights
    transferRate : Float;       // Hippocampal → cortical transfer rate
    beatNum     : Nat;
  };

  /// Initialize memory consolidation
  public func initMemoryConsolidation(numNeurons: Nat, bufferSize: Nat) : MemoryConsolidationState {
    var synapses : [Synapse] = [];
    for (i in Array.keys(Array.tabulate<Nat>(numNeurons, func(x) { x }))) {
      for (j in Array.keys(Array.tabulate<Nat>(numNeurons, func(x) { x }))) {
        if (i != j) {
          synapses := Array.append(synapses, [{
            weight = 0.5;
            preIdx = i;
            postIdx = j;
            lastPreSpike = 0;
            lastPostSpike = 0;
            eligibility = 0.0;
          }]);
        };
      };
    };
    
    let corticalWeights = Array.tabulate<[Float]>(numNeurons, func(_) {
      Array.tabulate<Float>(numNeurons, func(_) { 0.1 })
    });
    
    {
      synapses = synapses;
      memoryBuffer = [];
      bufferSize = bufferSize;
      replayRate = 0.1;
      replayGain = 0.005;
      corticalWeights = corticalWeights;
      transferRate = 0.001;
      beatNum = 0;
    }
  };

  /// Store new memory trace
  public func storeMemory(state: MemoryConsolidationState, pattern: [Float], importance: Float) : MemoryConsolidationState {
    let newTrace : MemoryTrace = {
      pattern = pattern;
      importance = importance;
      timestamp = state.beatNum;
      replayed = 0;
    };
    
    // Add to buffer, remove oldest if full
    var newBuffer = state.memoryBuffer;
    if (newBuffer.size() >= state.bufferSize) {
      // Remove oldest (FIFO) or lowest importance
      var minImportance : Float = 1e10;
      var minIdx : Nat = 0;
      for (i in Array.keys(newBuffer)) {
        if (newBuffer[i].importance < minImportance) {
          minImportance := newBuffer[i].importance;
          minIdx := i;
        };
      };
      
      // Remove minIdx
      newBuffer := Array.tabulate<MemoryTrace>(newBuffer.size() - 1, func(i) {
        if (i < minIdx) { newBuffer[i] } else { newBuffer[i + 1] }
      });
    };
    
    newBuffer := Array.append(newBuffer, [newTrace]);
    
    {
      synapses = state.synapses;
      memoryBuffer = newBuffer;
      bufferSize = state.bufferSize;
      replayRate = state.replayRate;
      replayGain = state.replayGain;
      corticalWeights = state.corticalWeights;
      transferRate = state.transferRate;
      beatNum = state.beatNum;
    }
  };

  /// Replay memories for consolidation
  public func replayMemories(state: MemoryConsolidationState, seed: Nat) : MemoryConsolidationState {
    if (state.memoryBuffer.size() == 0) { return state };
    
    var currentSeed = seed;
    currentSeed := (currentSeed * 1103515245 + 12345) % 2147483648;
    let rand = Float.fromInt(currentSeed % 1000) / 1000.0;
    
    if (rand >= state.replayRate) {
      // No replay this beat
      return { 
        synapses = state.synapses;
        memoryBuffer = state.memoryBuffer;
        bufferSize = state.bufferSize;
        replayRate = state.replayRate;
        replayGain = state.replayGain;
        corticalWeights = state.corticalWeights;
        transferRate = state.transferRate;
        beatNum = state.beatNum + 1;
      };
    };
    
    // Select memory weighted by importance
    currentSeed := (currentSeed * 1103515245 + 12345) % 2147483648;
    var totalImportance : Float = 0.0;
    for (mem in state.memoryBuffer.vals()) {
      totalImportance += mem.importance;
    };
    
    let threshold = Float.fromInt(currentSeed % 1000) / 1000.0 * totalImportance;
    var cumImportance : Float = 0.0;
    var selectedIdx : Nat = 0;
    
    for (i in Array.keys(state.memoryBuffer)) {
      cumImportance += state.memoryBuffer[i].importance;
      if (cumImportance >= threshold) {
        selectedIdx := i;
      };
    };
    
    let memory = state.memoryBuffer[selectedIdx];
    let pattern = memory.pattern;
    
    // Hebbian update on synapses using replayed pattern
    var newSynapses : [Synapse] = [];
    for (syn in state.synapses.vals()) {
      let pre = pattern[syn.preIdx];
      let post = pattern[syn.postIdx];
      let dw = state.replayGain * pre * post;
      let newWeight = _clamp(syn.weight + dw, 0.0, 2.0);
      
      newSynapses := Array.append(newSynapses, [{
        weight = newWeight;
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        lastPreSpike = syn.lastPreSpike;
        lastPostSpike = syn.lastPostSpike;
        eligibility = syn.eligibility;
      }]);
    };
    
    // Update cortical weights (slow transfer)
    var newCortical = state.corticalWeights;
    let n = pattern.size();
    for (i in Array.keys(pattern)) {
      for (j in Array.keys(pattern)) {
        if (i != j) {
          let transfer = state.transferRate * pattern[i] * pattern[j];
          let row = Array.thaw<Float>(newCortical[i]);
          row[j] := _clamp(row[j] + transfer, 0.0, 1.0);
          newCortical := Array.tabulate<[Float]>(n, func(idx) {
            if (idx == i) { Array.freeze(row) } else { newCortical[idx] }
          });
        };
      };
    };
    
    // Update replay count
    var newBuffer = Array.tabulate<MemoryTrace>(state.memoryBuffer.size(), func(i) {
      if (i == selectedIdx) {
        {
          pattern = state.memoryBuffer[i].pattern;
          importance = state.memoryBuffer[i].importance * 0.99;  // Decay importance
          timestamp = state.memoryBuffer[i].timestamp;
          replayed = state.memoryBuffer[i].replayed + 1;
        }
      } else { state.memoryBuffer[i] }
    });
    
    {
      synapses = newSynapses;
      memoryBuffer = newBuffer;
      bufferSize = state.bufferSize;
      replayRate = state.replayRate;
      replayGain = state.replayGain;
      corticalWeights = newCortical;
      transferRate = state.transferRate;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 19: DENDRITIC COMPARTMENTS — LOCAL PLASTICITY RULES
  // ═══════════════════════════════════════════════════════════════════════════════
  // Synapses on different dendritic compartments follow different rules
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Dendritic synapse with compartment info
  public type DendriticSynapse = {
    weight       : Float;
    preIdx       : Nat;
    postIdx      : Nat;
    compartment  : Text;        // "apical", "basal", "proximal", "distal"
    distance     : Float;       // Distance from soma (affects attenuation)
    localCa      : Float;       // Local calcium concentration
    branchId     : Nat;         // Which dendritic branch
  };

  /// Dendritic neuron model
  public type DendriticNeuron = {
    soma         : Float;       // Somatic potential
    apicalCa     : Float;       // Apical dendrite calcium
    basalCa      : Float;       // Basal dendrite calcium
    backprop     : Float;       // Backpropagating AP signal
    plateauPot   : Float;       // Dendritic plateau potential
  };

  /// Dendritic plasticity state
  public type DendriticPlasticityState = {
    neurons     : [DendriticNeuron];
    synapses    : [DendriticSynapse];
    // Compartment-specific parameters
    apicalLTP   : Float;
    apicalLTD   : Float;
    basalLTP    : Float;
    basalLTD    : Float;
    // Distance-dependent attenuation
    lambda      : Float;        // Length constant
    beatNum     : Nat;
  };

  /// Initialize dendritic plasticity
  public func initDendriticPlasticity(numNeurons: Nat) : DendriticPlasticityState {
    let neurons = Array.tabulate<DendriticNeuron>(numNeurons, func(_) {
      { soma = -70.0; apicalCa = 0.0; basalCa = 0.0; backprop = 0.0; plateauPot = 0.0 }
    });
    
    // Create synapses with compartment information
    var synapses : [DendriticSynapse] = [];
    var seed : Nat = 98765;
    
    for (i in Array.keys(neurons)) {
      for (j in Array.keys(neurons)) {
        if (i != j) {
          seed := (seed * 1103515245 + 12345) % 2147483648;
          let comp = if (seed % 4 == 0) { "apical" }
                     else if (seed % 4 == 1) { "basal" }
                     else if (seed % 4 == 2) { "proximal" }
                     else { "distal" };
          
          seed := (seed * 1103515245 + 12345) % 2147483648;
          let dist = Float.fromInt(seed % 100) / 100.0 * 0.5;  // 0 to 0.5 mm
          
          synapses := Array.append(synapses, [{
            weight = 0.5;
            preIdx = i;
            postIdx = j;
            compartment = comp;
            distance = dist;
            localCa = 0.0;
            branchId = seed % 5;
          }]);
        };
      };
    };
    
    {
      neurons = neurons;
      synapses = synapses;
      apicalLTP = 0.15;
      apicalLTD = 0.08;
      basalLTP = 0.1;
      basalLTD = 0.12;
      lambda = 0.2;
      beatNum = 0;
    }
  };

  /// Update dendritic plasticity with compartment rules
  public func updateDendriticPlasticity(state: DendriticPlasticityState, 
                                        spikes: [Bool], 
                                        plateaus: [Bool],
                                        dt: Float) : DendriticPlasticityState {
    // Update neuronal states
    var newNeurons : [DendriticNeuron] = [];
    for (i in Array.keys(state.neurons)) {
      let n = state.neurons[i];
      
      // Backpropagating AP from soma spike
      let newBackprop = if (spikes[i]) { 1.0 } else { n.backprop * 0.9 };
      
      // Dendritic plateau from input
      let newPlateau = if (plateaus[i]) { 1.0 } else { n.plateauPot * 0.95 };
      
      // Calcium dynamics
      let apicalCa_new = n.apicalCa * 0.98 + (if (newPlateau > 0.5) { 0.3 } else { 0.0 });
      let basalCa_new = n.basalCa * 0.98 + (if (newBackprop > 0.5) { 0.2 } else { 0.0 });
      
      newNeurons := Array.append(newNeurons, [{
        soma = n.soma;
        apicalCa = apicalCa_new;
        basalCa = basalCa_new;
        backprop = newBackprop;
        plateauPot = newPlateau;
      }]);
    };
    
    // Update synapses with compartment-specific rules
    var newSynapses : [DendriticSynapse] = [];
    for (syn in state.synapses.vals()) {
      let postNeuron = newNeurons[syn.postIdx];
      
      // Distance-dependent attenuation
      let attenuation = Float.exp(-syn.distance / state.lambda);
      
      // Backpropagating signal at synapse location
      let bAP = postNeuron.backprop * attenuation;
      
      var dw : Float = 0.0;
      
      switch (syn.compartment) {
        case "apical" {
          // Apical: plateau potential + input → LTP
          if (postNeuron.plateauPot > 0.5 and spikes[syn.preIdx]) {
            dw := state.apicalLTP * postNeuron.apicalCa;
          };
          // bAP + input but no plateau → LTD
          if (bAP > 0.5 and spikes[syn.preIdx] and postNeuron.plateauPot < 0.5) {
            dw := -state.apicalLTD * bAP;
          };
        };
        case "basal" {
          // Basal: standard STDP-like
          if (bAP > 0.5 and spikes[syn.preIdx]) {
            dw := state.basalLTP;
          };
          if (spikes[syn.preIdx] and bAP < 0.5) {
            dw := -state.basalLTD;
          };
        };
        case "proximal" {
          // Proximal: strong bAP influence
          dw := 0.1 * bAP * (if (spikes[syn.preIdx]) { 1.0 } else { -0.5 });
        };
        case "distal" {
          // Distal: weak bAP, needs plateau
          dw := 0.05 * postNeuron.plateauPot * (if (spikes[syn.preIdx]) { 1.0 } else { 0.0 });
        };
        case _ { };
      };
      
      // Update local calcium
      let newLocalCa = syn.localCa * 0.95 + (if (dw > 0.0) { 0.2 } else { 0.0 });
      
      let newWeight = _clamp(syn.weight + dw * dt, 0.0, 2.0);
      newSynapses := Array.append(newSynapses, [{
        weight = newWeight;
        preIdx = syn.preIdx;
        postIdx = syn.postIdx;
        compartment = syn.compartment;
        distance = syn.distance;
        localCa = newLocalCa;
        branchId = syn.branchId;
      }]);
    };
    
    {
      neurons = newNeurons;
      synapses = newSynapses;
      apicalLTP = state.apicalLTP;
      apicalLTD = state.apicalLTD;
      basalLTP = state.basalLTP;
      basalLTD = state.basalLTD;
      lambda = state.lambda;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 20: MASTER HEBBIAN ORCHESTRATOR — UNIFIED PLASTICITY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Integrates all plasticity variants into a unified system
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Master Hebbian state combining all variants
  public type MasterHebbianState = {
    // Core
    basic          : HebbianState;
    // Advanced variants
    triplet        : TripletSTDPState;
    voltage        : VoltageSTDPState;
    rewardMod      : RewardSTDPState;
    structural     : StructuralPlasticityState;
    metaplastic    : MetaplasticityState;
    competitive    : CompetitiveLearningState;
    consolidation  : MemoryConsolidationState;
    dendritic      : DendriticPlasticityState;
    // Control
    activeMode     : Text;
    beatNum        : Nat;
  };

  /// Initialize master Hebbian system
  public func initMasterHebbian(numNeurons: Nat) : MasterHebbianState {
    {
      basic = initHebbian(numNeurons);
      triplet = initTripletSTDP(numNeurons);
      voltage = initVoltageSTDP(numNeurons);
      rewardMod = initRewardSTDP(numNeurons);
      structural = initStructuralPlasticity(numNeurons, 0.3);
      metaplastic = initMetaplasticity(numNeurons * (numNeurons - 1), numNeurons);
      competitive = initCompetitiveLearning(numNeurons, numNeurons / 2, 3);
      consolidation = initMemoryConsolidation(numNeurons, 100);
      dendritic = initDendriticPlasticity(numNeurons);
      activeMode = "basic";
      beatNum = 0;
    }
  };

  /// Get unified output from master state
  public func getMasterHebbianOutput(state: MasterHebbianState) : {
    totalSynapticWeight : Float;
    avgWeight : Float;
    learningRate : Float;
    stability : Float;
    memoryCapacity : Float;
    activeMode : Text;
    beatNum : Nat;
  } {
    // Compute total synaptic weight from basic state
    var totalW : Float = 0.0;
    for (syn in state.basic.synapses.vals()) {
      totalW += syn.weight;
    };
    let avgW = totalW / Float.fromInt(Nat.max(1, state.basic.synapses.size()));
    
    {
      totalSynapticWeight = totalW;
      avgWeight = avgW;
      learningRate = state.basic.learningRate;
      stability = state.basic.stabilityIndex;
      memoryCapacity = Float.fromInt(state.consolidation.memoryBuffer.size()) / Float.fromInt(state.consolidation.bufferSize);
      activeMode = state.activeMode;
      beatNum = state.beatNum;
    }
  };

  /// Export for Kuramoto integration
  public func exportToKuramoto(state: MasterHebbianState) : {
    couplingMatrix : [[Float]];
    syncModulation : Float;
  } {
    // Create coupling matrix from synapses
    let n = state.basic.neurons.size();
    var matrix = Array.tabulate<[Float]>(n, func(_) {
      Array.tabulate<Float>(n, func(_) { 0.0 })
    });
    
    for (syn in state.basic.synapses.vals()) {
      let row = Array.thaw<Float>(matrix[syn.preIdx]);
      row[syn.postIdx] := syn.weight;
      matrix := Array.tabulate<[Float]>(n, func(idx) {
        if (idx == syn.preIdx) { Array.freeze(row) } else { matrix[idx] }
      });
    };
    
    {
      couplingMatrix = matrix;
      syncModulation = state.basic.globalModulation;
    }
  };

  /// Export for defense integration
  public func exportToDefense(state: MasterHebbianState) : {
    adaptationCapacity : Float;
    memoryStrength : Float;
    learningReadiness : Float;
  } {
    {
      adaptationCapacity = 1.0 - state.basic.stabilityIndex;
      memoryStrength = state.basic.totalSynapticWeight / Float.fromInt(state.basic.synapses.size());
      learningReadiness = state.basic.learningRate * state.metaplastic.globalMeta;
    }
  };

}
