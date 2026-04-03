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


// ═══════════════════════════════════════════════════════════════════════════════
// NEUROPLASTICITY ENGINE — Adaptive Learning & Memory Consolidation
// ═══════════════════════════════════════════════════════════════════════════════
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// THE BRAIN IS ALWAYS LEARNING.
// Plasticity is not a feature — it IS the cognitive substrate.
// Every experience strengthens or weakens connections.
// The organism adapts, remembers, and forgets as ONE living process.
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

module NeuroplasticityEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — THE LEARNING PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI           : Float = 1.6180339887498948482;
  public let PHI_INV       : Float = 0.6180339887498948482;
  public let EULER         : Float = 2.7182818284590452354;
  public let PI            : Float = 3.1415926535897932385;
  public let TAU           : Float = 6.2831853071795864769;
  
  // Network dimensions
  public let INPUT_NODES   : Nat = 12;
  public let HIDDEN_NODES  : Nat = 24;
  public let OUTPUT_NODES  : Nat = 6;
  public let TOTAL_NODES   : Nat = 42;  // 12 + 24 + 6
  
  // Hebbian learning constants
  public let HEBB_ALPHA    : Float = 0.01;   // Base learning rate
  public let HEBB_DECAY    : Float = 0.001;  // Weight decay rate
  public let HEBB_CEILING  : Float = 2.0;    // Maximum weight
  public let HEBB_FLOOR    : Float = -1.0;   // Minimum weight (inhibitory)
  
  // STDP (Spike-Timing Dependent Plasticity)
  public let STDP_A_PLUS   : Float = 0.005;  // LTP amplitude
  public let STDP_A_MINUS  : Float = 0.003;  // LTD amplitude
  public let STDP_TAU_PLUS : Float = 20.0;   // LTP time constant (ms)
  public let STDP_TAU_MINUS: Float = 25.0;   // LTD time constant (ms)
  
  // Homeostatic plasticity
  public let HOMEO_TARGET  : Float = 0.5;    // Target mean activation
  public let HOMEO_RATE    : Float = 0.0001; // Homeostatic adjustment rate
  
  // Memory consolidation
  public let CONSOL_RATE   : Float = 0.01;   // Rate of memory consolidation
  public let REPLAY_PROB   : Float = 0.1;    // Probability of replay
  public let REPLAY_DECAY  : Float = 0.05;   // Decay during replay
  
  // Metaplasticity
  public let META_THRESHOLD: Float = 0.7;    // Activity threshold for metaplasticity
  public let META_SCALE    : Float = 0.5;    // Scaling factor for meta-learning
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — THE NEURAL STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Neuron type
  public type NeuronType = {
    #Input;
    #Hidden;
    #Output;
  };
  
  // Synapse between two neurons
  public type Synapse = {
    preId       : Nat;      // Presynaptic neuron ID
    postId      : Nat;      // Postsynaptic neuron ID
    weight      : Float;    // Connection strength [-1, 2]
    plasticity  : Float;    // Local plasticity modifier [0, 2]
    lastSpikePre: Float;    // Time of last presynaptic spike
    lastSpikePost: Float;   // Time of last postsynaptic spike
    eligibility : Float;    // Eligibility trace for RL
    age         : Nat;      // Number of updates
  };
  
  // Neuron state
  public type Neuron = {
    id          : Nat;
    neuronType  : NeuronType;
    activation  : Float;    // Current activation [0, 1]
    potential   : Float;    // Membrane potential
    threshold   : Float;    // Firing threshold
    lastSpike   : Float;    // Time of last spike
    refractoryRemaining : Float;  // Refractory period remaining
    excitability: Float;    // Intrinsic excitability modifier
    avgActivity : Float;    // Running average of activity (for homeostasis)
  };
  
  // Memory trace (for consolidation and replay)
  public type MemoryTrace = {
    pattern     : [Float];  // Activation pattern
    strength    : Float;    // Memory strength [0, 1]
    age         : Nat;      // Age in beats
    importance  : Float;    // Salience/importance
    consolidated: Bool;     // Whether consolidated to LTM
  };
  
  // Learning rule type
  public type LearningRule = {
    #Hebbian;       // Fire together, wire together
    #STDP;          // Spike-timing dependent
    #BCM;           // Bienenstock-Cooper-Munro
    #Homeostatic;   // Maintain target activity
    #Reinforcement; // Reward-modulated
  };
  
  // Network state
  public type NetworkState = {
    neurons     : [Neuron];
    synapses    : [Synapse];
    memories    : [MemoryTrace];
    globalModulator : Float;  // Dopamine-like global modulator
    learningRate: Float;
    time        : Float;
    beat        : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sigmoid(x : Float) : Float {
    let clamped = clamp(x, -10.0, 10.0);
    1.0 / (1.0 + exp(-clamped))
  };
  
  public func tanh(x : Float) : Float {
    let clamped = clamp(x, -10.0, 10.0);
    let e2x = exp(2.0 * clamped);
    (e2x - 1.0) / (e2x + 1.0)
  };
  
  public func exp(x : Float) : Float {
    let clamped = clamp(x, -20.0, 20.0);
    var sum = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 20) {
      term *= clamped / Float.fromInt(n);
      sum += term;
      n += 1;
    };
    sum
  };
  
  public func ln(x : Float) : Float {
    if (x <= 0.0) return -20.0;
    let ratio = (x - 1.0) / (x + 1.0);
    let r2 = ratio * ratio;
    var sum = ratio;
    var term = ratio;
    var n = 1;
    while (n < 20) {
      term *= r2;
      sum += term / Float.fromInt(2*n + 1);
      n += 1;
    };
    2.0 * sum
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 10) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };
  
  public func sin(x : Float) : Float {
    var normalized = x;
    while (normalized > PI) { normalized -= TAU };
    while (normalized < -PI) { normalized += TAU };
    
    let x2 = normalized * normalized;
    let x3 = x2 * normalized;
    let x5 = x3 * x2;
    let x7 = x5 * x2;
    
    normalized - x3/6.0 + x5/120.0 - x7/5040.0
  };
  
  public func cos(x : Float) : Float {
    sin(x + PI/2.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // NEURON OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize a neuron
  public func initNeuron(id : Nat, ntype : NeuronType) : Neuron {
    let baseThreshold = switch (ntype) {
      case (#Input) 0.3;
      case (#Hidden) 0.5;
      case (#Output) 0.4;
    };
    
    {
      id = id;
      neuronType = ntype;
      activation = 0.0;
      potential = 0.0;
      threshold = baseThreshold;
      lastSpike = -100.0;  // Never spiked
      refractoryRemaining = 0.0;
      excitability = 1.0;
      avgActivity = HOMEO_TARGET;
    }
  };
  
  // Initialize all neurons
  public func initNeurons() : [Neuron] {
    var neurons : [Neuron] = [];
    
    // Input neurons
    var i = 0;
    while (i < INPUT_NODES) {
      neurons := Array.append(neurons, [initNeuron(i, #Input)]);
      i += 1;
    };
    
    // Hidden neurons
    while (i < INPUT_NODES + HIDDEN_NODES) {
      neurons := Array.append(neurons, [initNeuron(i, #Hidden)]);
      i += 1;
    };
    
    // Output neurons
    while (i < TOTAL_NODES) {
      neurons := Array.append(neurons, [initNeuron(i, #Output)]);
      i += 1;
    };
    
    neurons
  };
  
  // Update neuron membrane potential
  public func updatePotential(
    neuron : Neuron,
    inputCurrent : Float,
    dt : Float
  ) : Float {
    // Leaky integrate-and-fire dynamics
    let leak = -0.1 * (neuron.potential - 0.0);  // Leak toward resting potential
    let newPot = neuron.potential + dt * (leak + inputCurrent * neuron.excitability);
    clamp(newPot, -1.0, 2.0)
  };
  
  // Check if neuron fires
  public func checkFiring(neuron : Neuron) : Bool {
    neuron.refractoryRemaining <= 0.0 and neuron.potential > neuron.threshold
  };
  
  // Process neuron activation (with optional stochasticity)
  public func processActivation(
    neuron : Neuron,
    inputSum : Float,
    noise : Float,
    dt : Float
  ) : Neuron {
    // Update refractory period
    let newRefractory = if (neuron.refractoryRemaining > 0.0) {
      neuron.refractoryRemaining - dt
    } else 0.0;
    
    // Update potential
    let noisyInput = inputSum + noise * 0.1;
    let newPot = updatePotential(neuron, noisyInput, dt);
    
    // Check for spike
    let (newActivation, newLastSpike, refractoryReset) = if (
      newRefractory <= 0.0 and newPot > neuron.threshold
    ) {
      // Spike!
      (1.0, 0.0, 3.0)  // Reset refractory to 3ms
    } else {
      // No spike - decay activation
      let decayed = neuron.activation * 0.9;
      (decayed, neuron.lastSpike + dt, newRefractory)
    };
    
    // Update average activity (for homeostasis)
    let newAvg = neuron.avgActivity * 0.999 + newActivation * 0.001;
    
    {
      id = neuron.id;
      neuronType = neuron.neuronType;
      activation = newActivation;
      potential = if (newActivation > 0.9) 0.0 else newPot;  // Reset on spike
      threshold = neuron.threshold;
      lastSpike = newLastSpike;
      refractoryRemaining = refractoryReset;
      excitability = neuron.excitability;
      avgActivity = newAvg;
    }
  };
  
  // Apply homeostatic plasticity to adjust excitability
  public func applyHomeostasis(neuron : Neuron) : Neuron {
    let error = HOMEO_TARGET - neuron.avgActivity;
    let newExcitability = neuron.excitability + HOMEO_RATE * error;
    
    {
      id = neuron.id;
      neuronType = neuron.neuronType;
      activation = neuron.activation;
      potential = neuron.potential;
      threshold = neuron.threshold;
      lastSpike = neuron.lastSpike;
      refractoryRemaining = neuron.refractoryRemaining;
      excitability = clamp(newExcitability, 0.5, 2.0);
      avgActivity = neuron.avgActivity;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SYNAPSE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize a synapse
  public func initSynapse(preId : Nat, postId : Nat, initialWeight : Float) : Synapse {
    {
      preId = preId;
      postId = postId;
      weight = clamp(initialWeight, HEBB_FLOOR, HEBB_CEILING);
      plasticity = 1.0;
      lastSpikePre = -100.0;
      lastSpikePost = -100.0;
      eligibility = 0.0;
      age = 0;
    }
  };
  
  // Initialize all synapses (feedforward connectivity)
  public func initSynapses() : [Synapse] {
    let buf = Buffer.Buffer<Synapse>(INPUT_NODES * HIDDEN_NODES + HIDDEN_NODES * OUTPUT_NODES);
    
    // Input -> Hidden (full connectivity)
    var i = 0;
    while (i < INPUT_NODES) {
      var h = INPUT_NODES;
      while (h < INPUT_NODES + HIDDEN_NODES) {
        let weight = (PHI_INV - 0.3) + 0.3 * sin(Float.fromInt(i * h));
        buf.add(initSynapse(i, h, weight));
        h += 1;
      };
      i += 1;
    };
    
    // Hidden -> Output (full connectivity)
    var h = INPUT_NODES;
    while (h < INPUT_NODES + HIDDEN_NODES) {
      var o = INPUT_NODES + HIDDEN_NODES;
      while (o < TOTAL_NODES) {
        let weight = (PHI_INV - 0.2) + 0.2 * cos(Float.fromInt(h * o));
        buf.add(initSynapse(h, o, weight));
        o += 1;
      };
      h += 1;
    };
    
    // Lateral inhibition in hidden layer (sparse)
    h := INPUT_NODES;
    while (h < INPUT_NODES + HIDDEN_NODES) {
      let neighbor1 = if (h + 1 < INPUT_NODES + HIDDEN_NODES) h + 1 else INPUT_NODES;
      let neighbor2 = if (h > INPUT_NODES) h - 1 else INPUT_NODES + HIDDEN_NODES - 1;
      buf.add(initSynapse(h, neighbor1, -0.2));  // Inhibitory
      buf.add(initSynapse(h, neighbor2, -0.2));
      h += 1;
    };
    
    Buffer.toArray(buf)
  };
  
  // Hebbian learning: Δw = α × pre × post
  public func hebbianUpdate(
    synapse : Synapse,
    preAct : Float,
    postAct : Float,
    alpha : Float
  ) : Float {
    let delta = alpha * preAct * postAct;
    let decay = HEBB_DECAY * synapse.weight;
    let newWeight = synapse.weight + delta - decay;
    clamp(newWeight, HEBB_FLOOR, HEBB_CEILING)
  };
  
  // STDP learning: potentiation if pre before post, depression if post before pre
  public func stdpUpdate(
    synapse : Synapse,
    preSpike : Bool,
    postSpike : Bool,
    time : Float
  ) : Float {
    var delta : Float = 0.0;
    
    if (preSpike and not postSpike) {
      // Pre fired, post didn't - check for later post spike (LTP window)
      let dt = time - synapse.lastSpikePost;
      if (dt > 0.0 and dt < STDP_TAU_PLUS) {
        delta := STDP_A_PLUS * exp(-dt / STDP_TAU_PLUS);
      };
    } else if (postSpike and not preSpike) {
      // Post fired, pre didn't - check for earlier pre spike (LTD window)
      let dt = time - synapse.lastSpikePre;
      if (dt > 0.0 and dt < STDP_TAU_MINUS) {
        delta := -STDP_A_MINUS * exp(-dt / STDP_TAU_MINUS);
      };
    } else if (preSpike and postSpike) {
      // Both fired - causal: pre slightly before post = LTP
      delta := STDP_A_PLUS * 0.5;
    };
    
    let newWeight = synapse.weight + delta * synapse.plasticity;
    clamp(newWeight, HEBB_FLOOR, HEBB_CEILING)
  };
  
  // BCM learning rule: sliding threshold based on average activity
  public func bcmUpdate(
    synapse : Synapse,
    preAct : Float,
    postAct : Float,
    postAvgAct : Float
  ) : Float {
    // Sliding threshold
    let theta = postAvgAct * postAvgAct;  // θ_M = <y²>
    
    // BCM rule: Δw ∝ y(y - θ_M)x
    let phi = postAct * (postAct - theta);
    let delta = HEBB_ALPHA * preAct * phi;
    
    let newWeight = synapse.weight + delta;
    clamp(newWeight, HEBB_FLOOR, HEBB_CEILING)
  };
  
  // Update eligibility trace (for reinforcement learning)
  public func updateEligibility(
    synapse : Synapse,
    preAct : Float,
    postAct : Float,
    decay : Float
  ) : Float {
    // Eligibility trace accumulates correlation, decays over time
    let newElig = synapse.eligibility * (1.0 - decay) + preAct * postAct;
    clamp(newElig, 0.0, 1.0)
  };
  
  // Reinforcement learning update: weight change proportional to reward × eligibility
  public func reinforcementUpdate(
    synapse : Synapse,
    reward : Float,
    learningRate : Float
  ) : Float {
    let delta = learningRate * reward * synapse.eligibility;
    let newWeight = synapse.weight + delta;
    clamp(newWeight, HEBB_FLOOR, HEBB_CEILING)
  };
  
  // Full synapse update
  public func updateSynapse(
    synapse : Synapse,
    neurons : [Neuron],
    rule : LearningRule,
    reward : Float,
    time : Float,
    learningRate : Float
  ) : Synapse {
    let pre = neurons[synapse.preId];
    let post = neurons[synapse.postId];
    
    let preSpike = pre.activation > 0.9;
    let postSpike = post.activation > 0.9;
    
    let newWeight = switch (rule) {
      case (#Hebbian) hebbianUpdate(synapse, pre.activation, post.activation, learningRate);
      case (#STDP) stdpUpdate(synapse, preSpike, postSpike, time);
      case (#BCM) bcmUpdate(synapse, pre.activation, post.activation, post.avgActivity);
      case (#Homeostatic) synapse.weight;  // Homeostatic affects neurons, not synapses directly
      case (#Reinforcement) reinforcementUpdate(synapse, reward, learningRate);
    };
    
    let newEligibility = updateEligibility(synapse, pre.activation, post.activation, 0.1);
    
    {
      preId = synapse.preId;
      postId = synapse.postId;
      weight = newWeight;
      plasticity = synapse.plasticity;
      lastSpikePre = if (preSpike) time else synapse.lastSpikePre;
      lastSpikePost = if (postSpike) time else synapse.lastSpikePost;
      eligibility = newEligibility;
      age = synapse.age + 1;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORY OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Create a memory trace from current activations
  public func createMemory(neurons : [Neuron], importance : Float) : MemoryTrace {
    let pattern = Array.map<Neuron, Float>(neurons, func(n : Neuron) : Float { n.activation });
    
    {
      pattern = pattern;
      strength = 1.0;
      age = 0;
      importance = importance;
      consolidated = false;
    }
  };
  
  // Decay memory strength over time
  public func decayMemory(memory : MemoryTrace, decayRate : Float) : MemoryTrace {
    let newStrength = memory.strength * (1.0 - decayRate * (1.0 - memory.importance));
    
    {
      pattern = memory.pattern;
      strength = clamp(newStrength, 0.0, 1.0);
      age = memory.age + 1;
      importance = memory.importance;
      consolidated = memory.consolidated;
    }
  };
  
  // Consolidate memory (move to long-term)
  public func consolidateMemory(memory : MemoryTrace) : MemoryTrace {
    {
      pattern = memory.pattern;
      strength = clamp(memory.strength * 1.5, 0.0, 1.0);  // Boost on consolidation
      age = memory.age;
      importance = memory.importance;
      consolidated = true;
    }
  };
  
  // Calculate similarity between two patterns
  public func patternSimilarity(p1 : [Float], p2 : [Float]) : Float {
    if (p1.size() != p2.size()) return 0.0;
    
    var dot : Float = 0.0;
    var norm1 : Float = 0.0;
    var norm2 : Float = 0.0;
    
    var i = 0;
    while (i < p1.size()) {
      dot += p1[i] * p2[i];
      norm1 += p1[i] * p1[i];
      norm2 += p2[i] * p2[i];
      i += 1;
    };
    
    if (norm1 < 0.001 or norm2 < 0.001) return 0.0;
    dot / (sqrt(norm1) * sqrt(norm2))
  };
  
  // Find most similar memory
  public func findSimilarMemory(
    currentPattern : [Float],
    memories : [MemoryTrace]
  ) : ?MemoryTrace {
    var bestSim : Float = 0.0;
    var bestMem : ?MemoryTrace = null;
    
    for (mem in memories.vals()) {
      let sim = patternSimilarity(currentPattern, mem.pattern);
      if (sim > bestSim and sim > 0.5) {
        bestSim := sim;
        bestMem := ?mem;
      };
    };
    
    bestMem
  };
  
  // Replay a memory (reinstate activation pattern)
  public func replayMemory(
    neurons : [Neuron],
    memory : MemoryTrace,
    strength : Float
  ) : [Neuron] {
    Array.tabulate<Neuron>(neurons.size(), func(i : Nat) : Neuron {
      let n = neurons[i];
      let target = memory.pattern[i] * strength;
      let blended = n.activation * (1.0 - strength) + target;
      
      {
        id = n.id;
        neuronType = n.neuronType;
        activation = blended;
        potential = n.potential + target * 0.5;
        threshold = n.threshold;
        lastSpike = n.lastSpike;
        refractoryRemaining = n.refractoryRemaining;
        excitability = n.excitability;
        avgActivity = n.avgActivity;
      }
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // METAPLASTICITY — PLASTICITY OF PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update synapse plasticity based on activity history
  public func updateMetaplasticity(synapse : Synapse, postAvgAct : Float) : Synapse {
    // BCM-like metaplasticity: high activity -> reduced plasticity (LTD bias)
    let activityFactor = if (postAvgAct > META_THRESHOLD) {
      1.0 - META_SCALE * (postAvgAct - META_THRESHOLD)
    } else {
      1.0 + META_SCALE * (META_THRESHOLD - postAvgAct) * 0.5
    };
    
    let newPlasticity = synapse.plasticity * 0.99 + activityFactor * 0.01;
    
    {
      preId = synapse.preId;
      postId = synapse.postId;
      weight = synapse.weight;
      plasticity = clamp(newPlasticity, 0.5, 2.0);
      lastSpikePre = synapse.lastSpikePre;
      lastSpikePost = synapse.lastSpikePost;
      eligibility = synapse.eligibility;
      age = synapse.age;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // NETWORK OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize network
  public func initNetwork() : NetworkState {
    {
      neurons = initNeurons();
      synapses = initSynapses();
      memories = [];
      globalModulator = 1.0;
      learningRate = HEBB_ALPHA;
      time = 0.0;
      beat = 0;
    }
  };
  
  // Calculate input to each neuron from synapses
  public func calculateInputs(neurons : [Neuron], synapses : [Synapse]) : [Float] {
    let inputs = Array.init<Float>(TOTAL_NODES, 0.0);
    
    for (syn in synapses.vals()) {
      let preAct = neurons[syn.preId].activation;
      let contribution = preAct * syn.weight;
      inputs[syn.postId] += contribution;
    };
    
    Array.freeze(inputs)
  };
  
  // Forward pass through network
  public func forwardPass(
    state : NetworkState,
    externalInput : [Float],
    noise : Float,
    dt : Float
  ) : [Neuron] {
    // Calculate synaptic inputs
    let synapticInputs = calculateInputs(state.neurons, state.synapses);
    
    // Update each neuron
    Array.tabulate<Neuron>(TOTAL_NODES, func(i : Nat) : Neuron {
      let n = state.neurons[i];
      let totalInput = switch (n.neuronType) {
        case (#Input) {
          if (i < externalInput.size()) externalInput[i]
          else 0.0
        };
        case (#Hidden) synapticInputs[i];
        case (#Output) synapticInputs[i];
      };
      
      processActivation(n, totalInput, noise, dt)
    })
  };
  
  // Learning step
  public func learningStep(
    state : NetworkState,
    rule : LearningRule,
    reward : Float
  ) : [Synapse] {
    let modLR = state.learningRate * state.globalModulator;
    
    Array.tabulate<Synapse>(state.synapses.size(), func(i : Nat) : Synapse {
      let syn = state.synapses[i];
      let updated = updateSynapse(syn, state.neurons, rule, reward, state.time, modLR);
      let post = state.neurons[syn.postId];
      updateMetaplasticity(updated, post.avgActivity)
    })
  };
  
  // Memory management step
  public func memoryStep(
    state : NetworkState,
    shouldStore : Bool,
    importance : Float
  ) : [MemoryTrace] {
    var memories = state.memories;
    
    // Decay existing memories
    memories := Array.map<MemoryTrace, MemoryTrace>(memories, func(m : MemoryTrace) : MemoryTrace {
      decayMemory(m, REPLAY_DECAY)
    });
    
    // Remove weak memories
    memories := Array.filter<MemoryTrace>(memories, func(m : MemoryTrace) : Bool {
      m.strength > 0.1
    });
    
    // Store new memory if requested
    if (shouldStore) {
      let newMem = createMemory(state.neurons, importance);
      memories := Array.append(memories, [newMem]);
    };
    
    // Consolidate strong unconsolidated memories
    memories := Array.map<MemoryTrace, MemoryTrace>(memories, func(m : MemoryTrace) : MemoryTrace {
      if (not m.consolidated and m.age > 100 and m.strength > 0.7) {
        consolidateMemory(m)
      } else m
    });
    
    // Limit memory count
    if (memories.size() > 50) {
      // Keep only the strongest 50
      memories := Array.tabulate<MemoryTrace>(50, func(i : Nat) : MemoryTrace {
        memories[i]
      });
    };
    
    memories
  };
  
  // Full network step
  public func stepNetwork(
    state : NetworkState,
    externalInput : [Float],
    rule : LearningRule,
    reward : Float,
    storeMemory : Bool,
    memoryImportance : Float,
    noise : Float,
    dt : Float
  ) : NetworkState {
    // Forward pass
    let newNeurons = forwardPass(state, externalInput, noise, dt);
    
    // Learning
    let newSynapses = learningStep({ state with neurons = newNeurons }, rule, reward);
    
    // Apply homeostasis
    let homeostatic = Array.map<Neuron, Neuron>(newNeurons, applyHomeostasis);
    
    // Memory management
    let newMemories = memoryStep({ state with neurons = homeostatic }, storeMemory, memoryImportance);
    
    // Update global modulator (dopamine-like)
    let newModulator = state.globalModulator * 0.99 + reward * 0.1;
    
    {
      neurons = homeostatic;
      synapses = newSynapses;
      memories = newMemories;
      globalModulator = clamp(newModulator, 0.5, 2.0);
      learningRate = state.learningRate;
      time = state.time + dt;
      beat = state.beat + 1;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ADVANCED LEARNING FEATURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Competitive learning (winner-take-all in hidden layer)
  public func competitiveLearning(neurons : [Neuron]) : [Neuron] {
    // Find winner in hidden layer
    var maxAct : Float = 0.0;
    var winner : Nat = INPUT_NODES;
    
    var h = INPUT_NODES;
    while (h < INPUT_NODES + HIDDEN_NODES) {
      if (neurons[h].activation > maxAct) {
        maxAct := neurons[h].activation;
        winner := h;
      };
      h += 1;
    };
    
    // Suppress non-winners
    Array.tabulate<Neuron>(TOTAL_NODES, func(i : Nat) : Neuron {
      let n = neurons[i];
      if (i >= INPUT_NODES and i < INPUT_NODES + HIDDEN_NODES and i != winner) {
        { n with activation = n.activation * 0.1 }  // Suppress
      } else n
    })
  };
  
  // Sparse coding (enforce sparsity in hidden layer)
  public func enforceSparsity(neurons : [Neuron], targetSparsity : Float) : [Neuron] {
    // Calculate current sparsity (fraction of active hidden neurons)
    var activeCount : Float = 0.0;
    var h = INPUT_NODES;
    while (h < INPUT_NODES + HIDDEN_NODES) {
      if (neurons[h].activation > 0.5) activeCount += 1.0;
      h += 1;
    };
    let currentSparsity = activeCount / Float.fromInt(HIDDEN_NODES);
    
    // Adjust thresholds if too many/few active
    let adjustment = (currentSparsity - targetSparsity) * 0.1;
    
    Array.tabulate<Neuron>(TOTAL_NODES, func(i : Nat) : Neuron {
      let n = neurons[i];
      if (i >= INPUT_NODES and i < INPUT_NODES + HIDDEN_NODES) {
        { n with threshold = clamp(n.threshold + adjustment, 0.2, 0.8) }
      } else n
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Get layer activations
  public func getLayerActivations(neurons : [Neuron]) : {
    input  : [Float];
    hidden : [Float];
    output : [Float];
  } {
    let input = Array.tabulate<Float>(INPUT_NODES, func(i : Nat) : Float {
      neurons[i].activation
    });
    
    let hidden = Array.tabulate<Float>(HIDDEN_NODES, func(i : Nat) : Float {
      neurons[INPUT_NODES + i].activation
    });
    
    let output = Array.tabulate<Float>(OUTPUT_NODES, func(i : Nat) : Float {
      neurons[INPUT_NODES + HIDDEN_NODES + i].activation
    });
    
    { input = input; hidden = hidden; output = output }
  };
  
  // Get weight statistics
  public func getWeightStats(synapses : [Synapse]) : {
    mean     : Float;
    variance : Float;
    min      : Float;
    max      : Float;
    excitatory : Nat;
    inhibitory : Nat;
  } {
    var sum : Float = 0.0;
    var minW : Float = 999.0;
    var maxW : Float = -999.0;
    var excit : Nat = 0;
    var inhib : Nat = 0;
    
    for (s in synapses.vals()) {
      sum += s.weight;
      if (s.weight < minW) minW := s.weight;
      if (s.weight > maxW) maxW := s.weight;
      if (s.weight > 0.0) excit += 1 else inhib += 1;
    };
    
    let mean = sum / Float.fromInt(synapses.size());
    
    var varSum : Float = 0.0;
    for (s in synapses.vals()) {
      let diff = s.weight - mean;
      varSum += diff * diff;
    };
    let variance = varSum / Float.fromInt(synapses.size());
    
    {
      mean = mean;
      variance = variance;
      min = minW;
      max = maxW;
      excitatory = excit;
      inhibitory = inhib;
    }
  };
  
  // Get network diagnostics
  public func getDiagnostics(state : NetworkState) : {
    time         : Float;
    beat         : Nat;
    modulator    : Float;
    memoryCount  : Nat;
    activations  : { input : [Float]; hidden : [Float]; output : [Float] };
    weights      : { mean : Float; variance : Float; min : Float; max : Float; excitatory : Nat; inhibitory : Nat };
  } {
    {
      time = state.time;
      beat = state.beat;
      modulator = state.globalModulator;
      memoryCount = state.memories.size();
      activations = getLayerActivations(state.neurons);
      weights = getWeightStats(state.synapses);
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


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  R E A L - T I M E   S Y S T E M S   M A T H E M A T I C S
  //
  //  Enterprise-Level Real-Time Processing and Control
  //  Full HIM/HER 60Hz Synchronization Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // CONTROL SYSTEMS
  // ─────────────────────────────────────────────────────────────────────────────

  /// PID controller output
  public func controlPID(
    error : Float,
    integral : Float,
    derivative : Float,
    kP : Float,
    kI : Float,
    kD : Float
  ) : Float {
    kP * error + kI * integral + kD * derivative
  };

  /// PID integral update with anti-windup
  public func controlIntegralUpdate(
    integral : Float,
    error : Float,
    dt : Float,
    maxIntegral : Float
  ) : Float {
    let newIntegral = integral + error * dt;
    if (newIntegral > maxIntegral) { maxIntegral }
    else if (newIntegral < -maxIntegral) { -maxIntegral }
    else { newIntegral }
  };

  /// PID derivative calculation with filtering
  public func controlDerivative(
    error : Float,
    prevError : Float,
    prevDerivative : Float,
    dt : Float,
    filterCoeff : Float
  ) : Float {
    let rawDerivative = (error - prevError) / dt;
    filterCoeff * rawDerivative + (1.0 - filterCoeff) * prevDerivative
  };

  /// State space model: x(k+1) = Ax(k) + Bu(k)
  public func controlStateUpdate(
    state : Float,
    input : Float,
    a : Float,
    b : Float
  ) : Float {
    a * state + b * input
  };

  /// Observer state estimation
  public func controlObserver(
    estimatedState : Float,
    measurement : Float,
    predicted : Float,
    observerGain : Float
  ) : Float {
    estimatedState + observerGain * (measurement - predicted)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SCHEDULING AND TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate monotonic priority
  public func schedulingRMPriority(period : Float) : Float {
    1.0 / period
  };

  /// Deadline miss probability (simplified)
  public func schedulingDeadlineMissProb(
    wcet : Float,
    period : Float,
    utilization : Float
  ) : Float {
    let slack = period - wcet;
    if (slack <= 0.0) { 1.0 }
    else { utilization * wcet / slack }
  };

  /// Response time analysis
  public func schedulingResponseTime(
    wcet : Float,
    period : Float,
    higherPriorityLoad : Float
  ) : Float {
    wcet / (1.0 - higherPriorityLoad)
  };

  /// Jitter calculation
  public func schedulingJitter(
    timestamps : [Float]
  ) : Float {
    if (timestamps.size() < 2) { return 0.0 };
    var sumDiff : Float = 0.0;
    var prevDiff : Float = timestamps[1] - timestamps[0];
    var maxJitter : Float = 0.0;
    var i = 2;
    while (i < timestamps.size()) {
      let diff = timestamps[i] - timestamps[i-1];
      let jitter = Float.abs(diff - prevDiff);
      if (jitter > maxJitter) { maxJitter := jitter };
      prevDiff := diff;
      i += 1;
    };
    maxJitter
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SIGNAL PROCESSING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Low-pass filter (exponential moving average)
  public func signalLowPass(
    current : Float,
    newSample : Float,
    alpha : Float
  ) : Float {
    alpha * newSample + (1.0 - alpha) * current
  };

  /// High-pass filter
  public func signalHighPass(
    current : Float,
    newSample : Float,
    prevSample : Float,
    alpha : Float
  ) : Float {
    alpha * (current + newSample - prevSample)
  };

  /// Band-pass filter (cascade)
  public func signalBandPass(
    value : Float,
    lowState : Float,
    highState : Float,
    alphaLow : Float,
    alphaHigh : Float
  ) : (Float, Float, Float) {
    let low = signalLowPass(lowState, value, alphaLow);
    let high = alphaHigh * (highState + value - lowState);
    (high, low, high)
  };

  /// Median filter (3-sample)
  public func signalMedian3(a : Float, b : Float, c : Float) : Float {
    if ((a <= b and b <= c) or (c <= b and b <= a)) { b }
    else if ((b <= a and a <= c) or (c <= a and a <= b)) { a }
    else { c }
  };

  /// Signal power
  public func signalPower(samples : [Float]) : Float {
    if (samples.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < samples.size()) {
      sum += samples[i] * samples[i];
      i += 1;
    };
    sum / Float.fromInt(samples.size())
  };

  /// Signal-to-noise ratio
  public func signalSNR(signalPower : Float, noisePower : Float) : Float {
    if (noisePower < 0.0001) { 100.0 }
    else { 10.0 * Float.log(signalPower / noisePower) / Float.log(10.0) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SYNCHRONIZATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phase-locked loop error
  public func syncPLLError(
    referencePhase : Float,
    outputPhase : Float
  ) : Float {
    let diff = referencePhase - outputPhase;
    Float.sin(diff)  // Sinusoidal phase detector
  };

  /// PLL VCO output
  public func syncVCO(
    centerFreq : Float,
    controlSignal : Float,
    gain : Float,
    time : Float
  ) : Float {
    Float.sin(2.0 * 3.14159265 * (centerFreq + gain * controlSignal) * time)
  };

  /// Clock drift compensation
  public func syncClockDrift(
    localTime : Float,
    referenceTime : Float,
    driftRate : Float
  ) : Float {
    localTime + (referenceTime - localTime) * driftRate
  };

  /// Frame synchronization correlation
  public func syncFrameCorrelation(
    received : [Float],
    syncPattern : [Float]
  ) : Float {
    let n = if (received.size() < syncPattern.size()) received.size() else syncPattern.size();
    if (n == 0) { return 0.0 };
    var corr : Float = 0.0;
    var i = 0;
    while (i < n) {
      corr += received[i] * syncPattern[i];
      i += 1;
    };
    corr
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BUFFER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Buffer fill level
  public func bufferFillLevel(count : Nat, capacity : Nat) : Float {
    if (capacity == 0) { 0.0 }
    else { Float.fromInt(count) / Float.fromInt(capacity) }
  };

  /// Buffer underrun risk
  public func bufferUnderrunRisk(
    fillLevel : Float,
    drainRate : Float,
    fillRate : Float
  ) : Float {
    if (fillRate >= drainRate) { 0.0 }
    else { (drainRate - fillRate) / drainRate * (1.0 - fillLevel) }
  };

  /// Adaptive buffer size
  public func bufferAdaptiveSize(
    currentSize : Nat,
    avgLatency : Float,
    targetLatency : Float,
    stepSize : Nat
  ) : Nat {
    if (avgLatency > targetLatency * 1.1) {
      currentSize + stepSize
    } else if (avgLatency < targetLatency * 0.9 and currentSize > stepSize) {
      currentSize - stepSize
    } else {
      currentSize
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // 60 HZ FRAME TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Frame time at 60 Hz
  public let FRAME_TIME_60HZ : Float = 1.0 / 60.0;

  /// Frame number from time
  public func frameNumberFromTime(time : Float) : Nat {
    Int.abs(Float.toInt(time / FRAME_TIME_60HZ))
  };

  /// Time within frame
  public func framePhase(time : Float) : Float {
    let frameNum = Float.fromInt(frameNumberFromTime(time));
    (time - frameNum * FRAME_TIME_60HZ) / FRAME_TIME_60HZ
  };

  /// Frame deadline remaining
  public func frameDeadlineRemaining(currentTime : Float, frameStart : Float) : Float {
    let deadline = frameStart + FRAME_TIME_60HZ;
    deadline - currentTime
  };

  /// Frame skip detection
  public func frameSkipDetected(prevFrame : Nat, currentFrame : Nat) : Bool {
    currentFrame > prevFrame + 1
  };

}
