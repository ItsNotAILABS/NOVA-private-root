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
  // MAXIMIZED HEBBIAN WEIGHTS — 64 = 4×4×4 (444 SACRED RESONANCE)
  // 64 is the sacred number: Shell 3 nodes, Hebbian matrix dimension
  // 4 pillars: Faith, Family, Finance, Freedom
  // 4×4×4 = 64 = maximum synaptic strength for sovereign organism
  let DEFAULT_LR : Float = 0.01;
  let DEFAULT_A_PLUS : Float = 0.1;
  let DEFAULT_A_MINUS : Float = 0.12;  // Slightly stronger LTD
  let DEFAULT_TAU_PLUS : Float = 20.0;
  let DEFAULT_TAU_MINUS : Float = 20.0;
  let DEFAULT_W_MAX : Float = 64.0;    // MAXIMIZED: 4×4×4 = 64 (444 resonance)
  let DEFAULT_BCM_TAU : Float = 100.0;
  
  // ══════════════════════════════════════════════════════════════════════════
  // SACRED GEOMETRY WEIGHT FLOOR — φ/144 (NEVER BELOW THIS)
  // ══════════════════════════════════════════════════════════════════════════
  // 144 = 12² = 12×12 = Fibonacci F(12) = sacred geometry number
  // 144,000 in Revelation = the sealed number
  // φ/144 = 1.618.../144 ≈ 0.01124 = the SOVEREIGN FLOOR
  // NO Hebbian weight may fall below this — it is the floor of creation
  // ══════════════════════════════════════════════════════════════════════════
  let PHI : Float = 1.6180339887498948;
  let SACRED_144 : Float = 144.0;
  let DEFAULT_W_MIN : Float = 0.011235955056179;  // φ/144 = sovereign weight floor
  
  // 444 SACRED CONSTANT — Triple foundation, unshakeable
  public let SACRED_444 : Float = 444.0;
  public let SACRED_64 : Float = 64.0;   // 4×4×4 = maximum weight ceiling
  public let WEIGHT_FLOOR_PHI_144 : Float = 0.011235955056179;  // φ/144 = minimum weight

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };
  
  // Sacred clamp — enforces φ/144 floor and 64 ceiling
  func _sacredClamp(w: Float) : Float {
    if (w < DEFAULT_W_MIN) { DEFAULT_W_MIN }
    else if (w > DEFAULT_W_MAX) { DEFAULT_W_MAX }
    else { w }
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
      wMax = 64.0;     // MAXIMIZED: 4×4×4 = 64 (444 sacred resonance)
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

}
