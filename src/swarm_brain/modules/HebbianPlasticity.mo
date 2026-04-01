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

}
