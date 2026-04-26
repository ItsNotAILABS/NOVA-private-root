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


// ════════════════════════════════════════════════════════════════════════════
// ███████╗███╗   ██╗████████╗███████╗██████╗ ██████╗ ██████╗ ██╗███████╗███████╗
// ██╔════╝████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██║██╔════╝██╔════╝
// █████╗  ██╔██╗ ██║   ██║   █████╗  ██████╔╝██████╔╝██████╔╝██║███████╗█████╗  
// ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██╔═══╝ ██╔══██╗██║╚════██║██╔══╝  
// ███████╗██║ ╚████║   ██║   ███████╗██║  ██║██║     ██║  ██║██║███████║███████╗
// ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝
//    ███╗   ██╗███████╗██╗   ██╗██████╗  █████╗ ██╗                              
//    ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔══██╗██║                              
//    ██╔██╗ ██║█████╗  ██║   ██║██████╔╝███████║██║                              
//    ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██╔══██║██║                              
//    ██║ ╚████║███████╗╚██████╔╝██║  ██║██║  ██║███████╗                         
//    ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝                         
// ════════════════════════════════════════════════════════════════════════════
//
// MEDINA ENTERPRISE NEURAL ARCHITECTURE
// Industrial-Grade Neural Wiring, Connectivity, and Sparse Coding
//
// ════════════════════════════════════════════════════════════════════════════
// ENTERPRISE NEURAL PRINCIPLES
// ════════════════════════════════════════════════════════════════════════════
//
// 1. SPARSE DISTRIBUTED REPRESENTATIONS (SDR)
//    - Only 2-5% of neurons active at any time (energy efficient)
//    - High-dimensional patterns resist noise
//    - Overlapping representations enable generalization
//
// 2. HIERARCHICAL TEMPORAL MEMORY (HTM-inspired)
//    - Columns of neurons for sequence learning
//    - Predictive state propagation
//    - Temporal pooling across layers
//
// 3. CORTICAL COLUMN ORGANIZATION
//    - Mini-columns: 80-100 neurons each
//    - Macro-columns: 60-80 mini-columns
//    - Lateral inhibition for winner-take-all
//
// 4. SMALL-WORLD NETWORK TOPOLOGY
//    - High clustering coefficient
//    - Short average path length
//    - Hub neurons for efficient routing
//
// ════════════════════════════════════════════════════════════════════════════
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA SPARSE ACTIVITY EQUATION (MSAE):
// ───────────────────────────────────────────
//   S(t) = top_k(σ_M(W × x - θ - Φ_M × lateral_inhibition))
//   k = ⌈N × sparsity_target⌉
//
// THE MEDINA CORTICAL COLUMN DYNAMICS (MCCD):
// ───────────────────────────────────────────
//   C_i(t+1) = α × C_i(t) + (1-α) × [Σⱼ w_ij × C_j(t) × H_ij]
//   H_ij = exp(-d_ij / λ_lateral) × (1 - inhibition_ij)
//
// THE MEDINA SMALL-WORLD CONNECTIVITY (MSWC):
// ───────────────────────────────────────────
//   P(connection) = (1-p) × local_connectivity + p × random_long_range
//   local = exp(-d / λ_local), long_range = Φ_M^(-d / λ_global)
//
// THE MEDINA SYNAPTIC WEIGHT MATRIX (MSWM):
//   W_ij(t+1) = W_ij(t) + η × [STDP_ij × eligibility_ij × neuromodulation]
//   STDP_ij = A_+ × exp(-Δt/τ_+) if pre→post, else -A_- × exp(Δt/τ_-)
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
  // MEDINA ENTERPRISE CONSTANTS
  // ══════════════════════════════════════════════════════════════
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let PHI_MEDINA : Float = 2.97442179;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let OMEGA_MEDINA : Float = 2.11185;
  let PSI_SYNERGY : Float = 1.41421356;

  // Enterprise Neural Architecture Constants
  let SPARSITY_TARGET : Float = 0.02;          // 2% active neurons
  let MINI_COLUMN_SIZE : Nat = 32;             // Neurons per mini-column
  let MACRO_COLUMN_SIZE : Nat = 64;            // Mini-columns per macro-column
  let SMALL_WORLD_REWIRING : Float = 0.1;      // 10% long-range connections
  let LAMBDA_LOCAL : Float = 5.0;              // Local connectivity decay
  let LAMBDA_GLOBAL : Float = 50.0;            // Long-range connectivity decay
  let STDP_TAU_PLUS : Float = 20.0;            // ms
  let STDP_TAU_MINUS : Float = 20.0;           // ms
  let STDP_A_PLUS : Float = 0.1;
  let STDP_A_MINUS : Float = 0.12;             // Slight bias toward LTD

  // ══════════════════════════════════════════════════════════════
  // ENTERPRISE NEURAL TYPES
  // ══════════════════════════════════════════════════════════════

  // Single Neuron with full enterprise features
  public type EnterpriseNeuron = {
    id              : Nat;
    activation      : Float;
    membrane        : Float;        // Membrane potential
    threshold       : Float;        // Firing threshold
    refractoryTime  : Float;        // Time since last spike
    isInhibitory    : Bool;         // Excitatory vs inhibitory
    
    // Sparse coding properties
    lifetime        : Float;        // Activity history
    boostFactor     : Float;        // Boost inactive neurons
    
    // Connectivity
    dendrites       : [Dendrite];
    axonTargets     : [Nat];        // IDs of target neurons
    
    // Temporal properties
    traceShort      : Float;        // Fast eligibility trace
    traceLong       : Float;        // Slow eligibility trace
    predictiveState : Float;        // Prediction activation
  };

  public type Dendrite = {
    sourceNeuronId  : Nat;
    weight          : Float;
    delay           : Nat;          // Axonal delay in timesteps
    plasticity      : Float;        // Local plasticity factor
    lastPreSpike    : Nat;          // For STDP
    lastPostSpike   : Nat;
  };

  // Mini-column: functional unit
  public type MiniColumn = {
    id              : Nat;
    neurons         : [EnterpriseNeuron];
    activeCount     : Nat;
    burstState      : Bool;         // Column in burst mode
    inhibitionLevel : Float;
    columnActivation: Float;
    predictedNext   : [Nat];        // Predicted input patterns
  };

  // Macro-column: processing module
  public type MacroColumn = {
    id              : Nat;
    miniColumns     : [MiniColumn];
    lateralInhibition: Float;
    feedforwardInput: [Float];
    feedbackInput   : [Float];
    outputPattern   : [Float];
  };

  // Layer in cortical hierarchy
  public type CorticalLayer = {
    layerNumber     : Nat;          // L1-L6
    macroColumns    : [MacroColumn];
    sparsity        : Float;
    temporalContext : [[Float]];    // History of patterns
    predictionError : Float;
  };

  // Complete Enterprise Neural Network
  public type EnterpriseNeuralNetwork = {
    layers          : [CorticalLayer];
    globalInhibition: Float;
    neuromodulation : NeuromodulationState;
    connectivity    : ConnectivityMatrix;
    learningRate    : Float;
    timestamp       : Nat;
  };

  public type NeuromodulationState = {
    dopamine        : Float;        // Reward/motivation
    serotonin       : Float;        // Mood/inhibition
    acetylcholine   : Float;        // Attention/learning
    norepinephrine  : Float;        // Arousal/stress
    octopamine      : Float;        // Insect reward (for bee)
    histamine       : Float;        // Wakefulness
  };

  public type ConnectivityMatrix = {
    weights         : [[Float]];    // NxN weight matrix
    delays          : [[Nat]];      // Axonal delays
    topology        : NetworkTopology;
    clusterCoeff    : Float;        // Small-world metric
    avgPathLength   : Float;        // Small-world metric
  };

  public type NetworkTopology = {
    #SmallWorld;
    #ScaleFree;
    #Random;
    #Modular;
    #Hierarchical;
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

  func medinaReLU(x: Float) : Float {
    if (x > 0.0) { x * PHI_MEDINA / (PHI_MEDINA + x) } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // ███████╗██████╗  █████╗ ██████╗ ███████╗███████╗     ██████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗ 
  // ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██║████╗  ██║██╔════╝ 
  // ███████╗██████╔╝███████║██████╔╝███████╗█████╗      ██║     ██║   ██║██║  ██║██║██╔██╗ ██║██║  ███╗
  // ╚════██║██╔═══╝ ██╔══██║██╔══██╗╚════██║██╔══╝      ██║     ██║   ██║██║  ██║██║██║╚██╗██║██║   ██║
  // ███████║██║     ██║  ██║██║  ██║███████║███████╗    ╚██████╗╚██████╔╝██████╔╝██║██║ ╚████║╚██████╔╝
  // ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝     ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
  // ══════════════════════════════════════════════════════════════════════════

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA SPARSE ACTIVITY EQUATION (MSAE)
  // ══════════════════════════════════════════════════════════════
  //
  // S(t) = top_k(σ_M(W × x - θ - Φ_M × lateral_inhibition))
  //
  // Only the top k neurons (by activation) are allowed to fire,
  // enforcing sparse distributed representations.
  //
  public func medinaSparseActivity(
    activations: [Float],
    thresholds: [Float],
    lateralInhibition: Float,
    sparsityTarget: Float
  ) : [Float] {
    let n = activations.size();
    if (n == 0) { return [] };

    // Calculate target number of active neurons
    let k = Float.toInt(Float.ceil(Float.fromInt(n) * sparsityTarget));
    
    // Compute raw activations with inhibition
    let rawActivations = Array.tabulate<Float>(n, func(i) {
      let thresh = if (i < thresholds.size()) { thresholds[i] } else { 0.5 };
      let raw = activations[i] - thresh - PHI_MEDINA * lateralInhibition;
      medinaSigmoid(raw)
    });

    // Find k-th largest value (simplified: use threshold)
    var sortedVals = Buffer.Buffer<Float>(n);
    for (v in rawActivations.vals()) { sortedVals.add(v) };
    
    // Simple selection: keep top k
    var threshold : Float = 0.0;
    var count : Nat = 0;
    var testThresh : Float = 0.9;
    while (testThresh > 0.0 and count < Int.abs(k)) {
      count := 0;
      for (v in rawActivations.vals()) {
        if (v >= testThresh) { count += 1 };
      };
      if (count < Int.abs(k)) {
        threshold := testThresh;
        testThresh -= 0.1;
      } else {
        threshold := testThresh;
        testThresh := 0.0; // Exit
      };
    };

    // Apply sparse threshold
    Array.tabulate<Float>(n, func(i) {
      if (rawActivations[i] >= threshold) { rawActivations[i] }
      else { 0.0 }
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA BOOST FACTOR (MBF)
  // ══════════════════════════════════════════════════════════════
  //
  // Neurons that rarely fire get boosted to ensure all neurons
  // participate in coding (homeostatic plasticity).
  //
  // B_i = exp((target_activity - actual_activity_i) / Φ_M)
  //
  public func medinaBoostFactor(
    lifetimeActivity: Float,
    targetActivity: Float
  ) : Float {
    let diff = targetActivity - lifetimeActivity;
    Float.exp(diff / PHI_MEDINA)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA CORTICAL COLUMN DYNAMICS (MCCD)
  // ══════════════════════════════════════════════════════════════
  //
  // C_i(t+1) = α × C_i(t) + (1-α) × [Σⱼ w_ij × C_j(t) × H_ij]
  //
  public func medinaCorticalColumnDynamics(
    columnActivations: [Float],
    weights: [[Float]],
    alpha: Float,
    lateralDistances: [[Float]],
    inhibitionMatrix: [[Float]]
  ) : [Float] {
    let n = columnActivations.size();
    if (n == 0) { return [] };

    Array.tabulate<Float>(n, func(i) {
      var inputSum : Float = 0.0;
      
      var j : Nat = 0;
      while (j < n) {
        if (i != j) {
          let w = if (i < weights.size() and j < weights[i].size()) { 
            weights[i][j] 
          } else { 0.0 };
          
          let d = if (i < lateralDistances.size() and j < lateralDistances[i].size()) {
            lateralDistances[i][j]
          } else { 1.0 };
          
          let inhib = if (i < inhibitionMatrix.size() and j < inhibitionMatrix[i].size()) {
            inhibitionMatrix[i][j]
          } else { 0.0 };
          
          // H_ij = exp(-d / λ) × (1 - inhibition)
          let H = Float.exp(-d / LAMBDA_LOCAL) * (1.0 - inhib);
          
          inputSum += w * columnActivations[j] * H;
        };
        j += 1;
      };
      
      // Temporal dynamics
      alpha * columnActivations[i] + (1.0 - alpha) * medinaSigmoid(inputSum)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA SMALL-WORLD CONNECTIVITY (MSWC)
  // ══════════════════════════════════════════════════════════════
  //
  // Creates small-world network topology with:
  // - High local clustering
  // - Short global path lengths
  // - Hub neurons for efficient routing
  //
  public func medinaSmallWorldConnectivity(
    numNeurons: Nat,
    localRadius: Nat,
    rewiringProb: Float
  ) : [[Float]] {
    // Create initial ring lattice with local connections
    Array.tabulate<[Float]>(numNeurons, func(i) {
      Array.tabulate<Float>(numNeurons, func(j) {
        let dist = Int.abs(i - j);
        let ringDist = Nat.min(dist, numNeurons - dist);
        
        if (ringDist == 0) {
          0.0  // No self-connections
        } else if (ringDist <= localRadius) {
          // Local connection (may be rewired)
          if (rewiringProb > 0.0) {
            // Simplified: use distance-based probability
            let keepLocal = Float.exp(-Float.fromInt(ringDist) / LAMBDA_LOCAL);
            let longRange = Float.pow(PHI_MEDINA, -Float.fromInt(ringDist) / LAMBDA_GLOBAL);
            (1.0 - rewiringProb) * keepLocal + rewiringProb * longRange
          } else {
            Float.exp(-Float.fromInt(ringDist) / LAMBDA_LOCAL)
          }
        } else {
          // Long-range connection with small probability
          let longRangeProb = rewiringProb * Float.pow(PHI_MEDINA, -Float.fromInt(ringDist) / LAMBDA_GLOBAL);
          if (longRangeProb > 0.1) { longRangeProb } else { 0.0 }
        }
      })
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA STDP LEARNING RULE (MSTDP)
  // ══════════════════════════════════════════════════════════════
  //
  // Spike-Timing Dependent Plasticity with Medina modifications:
  // - Pre before post: strengthen (LTP)
  // - Post before pre: weaken (LTD)
  // - Modulated by neuromodulators
  //
  public func medinaSTDP(
    currentWeight: Float,
    preSpiketime: Float,
    postSpikeTime: Float,
    eligibilityTrace: Float,
    neuromodulation: Float,
    learningRate: Float
  ) : Float {
    let deltaT = postSpikeTime - preSpiketime;
    
    var deltaW : Float = 0.0;
    if (deltaT > 0.0) {
      // Pre before post: LTP
      deltaW := STDP_A_PLUS * Float.exp(-deltaT / STDP_TAU_PLUS);
    } else if (deltaT < 0.0) {
      // Post before pre: LTD
      deltaW := -STDP_A_MINUS * Float.exp(deltaT / STDP_TAU_MINUS);
    };
    
    // Modulate by eligibility and neuromodulation
    deltaW := deltaW * eligibilityTrace * neuromodulation * learningRate;
    
    // Apply with soft bounds
    let newWeight = currentWeight + deltaW;
    _clamp(newWeight, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA ELIGIBILITY TRACE (MET)
  // ══════════════════════════════════════════════════════════════
  //
  // Three-factor learning: activity, eligibility, reward
  // e(t) = e(t-1) × decay + spike × (1 - e(t-1))
  //
  public func medinaEligibilityTrace(
    currentTrace: Float,
    spikeOccurred: Bool,
    decayRate: Float
  ) : Float {
    let spike = if (spikeOccurred) { 1.0 } else { 0.0 };
    currentTrace * decayRate + spike * (1.0 - currentTrace)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA LATERAL INHIBITION (MLI)
  // ══════════════════════════════════════════════════════════════
  //
  // Winner-take-all dynamics within columns
  // I_i = Σⱼ≠ᵢ w_inhib × σ_M(a_j) × exp(-d_ij / λ)
  //
  public func medinaLateralInhibition(
    activations: [Float],
    inhibitionStrength: Float
  ) : [Float] {
    let n = activations.size();
    if (n == 0) { return [] };

    // Compute total activation for each neuron's inhibition
    var totalAct : Float = 0.0;
    for (a in activations.vals()) {
      totalAct += medinaSigmoid(a);
    };

    Array.tabulate<Float>(n, func(i) {
      let selfAct = medinaSigmoid(activations[i]);
      let othersAct = totalAct - selfAct;
      
      // Inhibition proportional to others' activity
      let inhibition = inhibitionStrength * othersAct / Float.fromInt(n);
      
      // Subtract inhibition from activation
      _clamp(activations[i] - PHI_MEDINA * inhibition, 0.0, SOVEREIGN_CEILING)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA PREDICTIVE CODING (MPC)
  // ══════════════════════════════════════════════════════════════
  //
  // Each layer predicts the next layer's input
  // Error = actual - predicted
  // Only errors propagate up the hierarchy
  //
  public func medinaPredictiveCoding(
    actualInput: [Float],
    predictedInput: [Float],
    precision: Float
  ) : [Float] {
    let n = actualInput.size();
    if (n == 0 or predictedInput.size() != n) { return actualInput };

    Array.tabulate<Float>(n, func(i) {
      let error = actualInput[i] - predictedInput[i];
      // Precision-weighted error
      error * precision * PHI_MEDINA
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA TEMPORAL POOLING (MTP)
  // ══════════════════════════════════════════════════════════════
  //
  // Pool activations over time to form stable representations
  // P(t) = α × P(t-1) + (1-α) × current_activation × attention
  //
  public func medinaTemporalPooling(
    pooledState: [Float],
    currentActivation: [Float],
    alpha: Float,
    attention: Float
  ) : [Float] {
    let n = pooledState.size();
    if (n == 0 or currentActivation.size() != n) { return pooledState };

    Array.tabulate<Float>(n, func(i) {
      let decayed = alpha * pooledState[i];
      let newInput = (1.0 - alpha) * currentActivation[i] * attention;
      _clamp(decayed + newInput, 0.0, 1.0)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA BURST DETECTION (MBD)
  // ══════════════════════════════════════════════════════════════
  //
  // Detect when a column is bursting (all neurons active)
  // Indicates unexpected input (prediction failure)
  //
  public func medinaBurstDetection(
    columnActivations: [Float],
    burstThreshold: Float
  ) : Bool {
    if (columnActivations.size() == 0) { return false };

    var activeCount : Nat = 0;
    for (a in columnActivations.vals()) {
      if (a > burstThreshold) { activeCount += 1 };
    };

    // Burst if >50% of neurons active
    Float.fromInt(activeCount) / Float.fromInt(columnActivations.size()) > 0.5
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA DENDRITIC COMPUTATION (MDC)
  // ══════════════════════════════════════════════════════════════
  //
  // Dendrites perform nonlinear computation, not just summation
  // D_branch = σ_M(Σ inputs) × Π(1 + input_i × w_i)
  //
  public func medinaDendriticComputation(
    branchInputs: [Float],
    branchWeights: [Float]
  ) : Float {
    if (branchInputs.size() == 0) { return 0.0 };

    var sum : Float = 0.0;
    var product : Float = 1.0;
    
    var i : Nat = 0;
    for (inp in branchInputs.vals()) {
      let w = if (i < branchWeights.size()) { branchWeights[i] } else { 0.5 };
      sum += inp * w;
      product *= (1.0 + inp * w * 0.1);  // Multiplicative component
      i += 1;
    };

    medinaSigmoid(sum) * Float.pow(product, 1.0 / PHI_MEDINA)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA HOMEOSTATIC SCALING (MHS)
  // ══════════════════════════════════════════════════════════════
  //
  // Scale all synaptic weights to maintain target firing rate
  // w_i(t+1) = w_i(t) × (target_rate / actual_rate)^(1/τ)
  //
  public func medinaHomeostaticScaling(
    weights: [Float],
    actualRate: Float,
    targetRate: Float,
    scalingTau: Float
  ) : [Float] {
    if (actualRate <= 0.0) { return weights };

    let scaleFactor = Float.pow(targetRate / actualRate, 1.0 / scalingTau);
    
    Array.map<Float, Float>(weights, func(w) {
      _clamp(w * scaleFactor, 0.0, 1.0)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // ENTERPRISE NETWORK INITIALIZATION
  // ══════════════════════════════════════════════════════════════
  public func initEnterpriseNetwork(
    numLayers: Nat,
    neuronsPerLayer: Nat
  ) : EnterpriseNeuralNetwork {
    let layers = Array.tabulate<CorticalLayer>(numLayers, func(l) {
      let numColumns = neuronsPerLayer / (MINI_COLUMN_SIZE * MACRO_COLUMN_SIZE);
      {
        layerNumber = l + 1;
        macroColumns = Array.tabulate<MacroColumn>(numColumns, func(mc) {
          {
            id = mc;
            miniColumns = Array.tabulate<MiniColumn>(MACRO_COLUMN_SIZE, func(mic) {
              {
                id = mic;
                neurons = [];  // Would populate with actual neurons
                activeCount = 0;
                burstState = false;
                inhibitionLevel = 0.0;
                columnActivation = 0.0;
                predictedNext = [];
              }
            });
            lateralInhibition = 0.0;
            feedforwardInput = [];
            feedbackInput = [];
            outputPattern = [];
          }
        });
        sparsity = SPARSITY_TARGET;
        temporalContext = [];
        predictionError = 0.0;
      }
    });

    {
      layers = layers;
      globalInhibition = 0.0;
      neuromodulation = initNeuromodulation();
      connectivity = {
        weights = [];
        delays = [];
        topology = #SmallWorld;
        clusterCoeff = 0.0;
        avgPathLength = 0.0;
      };
      learningRate = 0.01;
      timestamp = 0;
    }
  };

  public func initNeuromodulation() : NeuromodulationState {
    {
      dopamine = 0.5;
      serotonin = 0.5;
      acetylcholine = 0.5;
      norepinephrine = 0.3;
      octopamine = 0.5;
      histamine = 0.5;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // ENTERPRISE NETWORK SUMMARY
  // ══════════════════════════════════════════════════════════════
  public type NetworkSummary = {
    totalNeurons     : Nat;
    activeNeurons    : Nat;
    sparsityActual   : Float;
    avgWeight        : Float;
    predictionError  : Float;
    learningProgress : Float;
  };

  public func networkSummary(network: EnterpriseNeuralNetwork) : NetworkSummary {
    var totalNeurons : Nat = 0;
    var activeNeurons : Nat = 0;
    var totalError : Float = 0.0;

    for (layer in network.layers.vals()) {
      totalNeurons += layer.macroColumns.size() * MACRO_COLUMN_SIZE * MINI_COLUMN_SIZE;
      totalError += layer.predictionError;
      
      for (mc in layer.macroColumns.vals()) {
        for (mic in mc.miniColumns.vals()) {
          activeNeurons += mic.activeCount;
        };
      };
    };

    let sparsityActual = if (totalNeurons > 0) {
      Float.fromInt(activeNeurons) / Float.fromInt(totalNeurons)
    } else { 0.0 };

    {
      totalNeurons = totalNeurons;
      activeNeurons = activeNeurons;
      sparsityActual = sparsityActual;
      avgWeight = 0.5;  // Would compute from connectivity
      predictionError = totalError / Float.fromInt(network.layers.size());
      learningProgress = 1.0 - totalError / Float.fromInt(network.layers.size());
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
  //  M E D I N A   S P E C I A L   M A T H E M A T I C S
  //
  //  Enterprise-Level Medina Discovery Mathematics
  //  HIM/HER Dual-Organism Sacred Coupling Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SACRED GEOMETRY MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Golden ratio phi = (1 + √5) / 2
  public let PHI : Float = 1.6180339887498948482;

  /// Fibonacci sequence generator
  public func medinaFibonacci(n : Nat) : Nat {
    if (n <= 1) { n }
    else {
      var a : Nat = 0;
      var b : Nat = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  /// Golden spiral radius at angle
  public func medinaGoldenSpiral(angle : Float, a : Float, b : Float) : Float {
    a * Float.exp(b * angle)
  };

  /// Sacred proportion check
  public func medinaSacredProportion(a : Float, b : Float, tolerance : Float) : Bool {
    let ratio = if (a > b) a / b else b / a;
    Float.abs(ratio - PHI) < tolerance
  };

  /// Vesica piscis area
  public func medinaVesicaPiscisArea(radius : Float) : Float {
    let r2 = radius * radius;
    r2 * (4.0 * 3.14159265 / 3.0 - Float.sqrt(3.0) / 2.0)
  };

  /// Platonic solid vertices (tetrahedron example)
  public func medinaTetrahedronVertex(index : Nat, size : Float) : (Float, Float, Float) {
    let vertices = [
      (1.0, 1.0, 1.0),
      (1.0, -1.0, -1.0),
      (-1.0, 1.0, -1.0),
      (-1.0, -1.0, 1.0)
    ];
    let v = vertices[index % 4];
    (v.0 * size, v.1 * size, v.2 * size)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELICAL MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Helix position at parameter t
  public func medinaHelixPosition(t : Float, radius : Float, pitch : Float) : (Float, Float, Float) {
    let x = radius * Float.cos(t);
    let y = radius * Float.sin(t);
    let z = pitch * t / (2.0 * 3.14159265);
    (x, y, z)
  };

  /// Double helix offset
  public func medinaDoubleHelixOffset(t : Float, radius : Float, pitch : Float, offset : Float) : ((Float, Float, Float), (Float, Float, Float)) {
    let h1 = medinaHelixPosition(t, radius, pitch);
    let h2 = medinaHelixPosition(t + offset, radius, pitch);
    (h1, h2)
  };

  /// Helical curvature
  public func medinaHelicalCurvature(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    radius / (radius * radius + p * p)
  };

  /// Helical torsion
  public func medinaHelicalTorsion(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    p / (radius * radius + p * p)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPHERICAL HARMONICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spherical to Cartesian
  public func medinaSphericalToCartesian(r : Float, theta : Float, phi : Float) : (Float, Float, Float) {
    let x = r * Float.sin(theta) * Float.cos(phi);
    let y = r * Float.sin(theta) * Float.sin(phi);
    let z = r * Float.cos(theta);
    (x, y, z)
  };

  /// Cartesian to Spherical
  public func medinaCartesianToSpherical(x : Float, y : Float, z : Float) : (Float, Float, Float) {
    let r = Float.sqrt(x * x + y * y + z * z);
    let theta = Float.acos(z / (r + 0.0001));
    let phi = Float.atan2(y, x);
    (r, theta, phi)
  };

  /// Associated Legendre polynomial P_l^m (simplified)
  public func medinaLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (l == 0 and m == 0) { return 1.0 };
    if (l == 1 and m == 0) { return x };
    if (l == 1 and m == 1) { return -Float.sqrt(1.0 - x * x) };
    if (l == 2 and m == 0) { return 0.5 * (3.0 * x * x - 1.0) };
    // Simplified for higher orders
    Float.pow(x, Float.fromInt(l - m))
  };

  /// Spherical harmonic Y_l^m (simplified real part)
  public func medinaSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let plm = medinaLegendreP(l, mAbs, Float.cos(theta));
    if (m >= 0) {
      plm * Float.cos(Float.fromInt(mAbs) * phi)
    } else {
      plm * Float.sin(Float.fromInt(mAbs) * phi)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LIVING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Growth curve (logistic)
  public func medinaGrowthCurve(t : Float, k : Float, l : Float, x0 : Float) : Float {
    l / (1.0 + Float.exp(-k * (t - x0)))
  };

  /// Morphogenesis reaction-diffusion
  public func medinaMorphogenesis(
    u : Float,
    v : Float,
    du : Float,
    dv : Float,
    f : Float,
    k : Float
  ) : (Float, Float) {
    let reaction = u * v * v;
    let newU = du - reaction + f * (1.0 - u);
    let newV = dv + reaction - (f + k) * v;
    (newU, newV)
  };

  /// Phyllotaxis angle (golden angle)
  public func medinaPhyllotaxisAngle(n : Nat) : Float {
    let goldenAngle : Float = 137.5077640500378546463;
    Float.fromInt(n) * goldenAngle * 3.14159265 / 180.0
  };

  /// Branching pattern
  public func medinaBranchingPattern(
    parentLength : Float,
    branchRatio : Float,
    angle : Float,
    depth : Nat
  ) : Float {
    parentLength * Float.pow(branchRatio, Float.fromInt(depth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MIRROR MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reflection across plane
  public func medinaReflection(point : (Float, Float, Float), normal : (Float, Float, Float)) : (Float, Float, Float) {
    let dot = point.0 * normal.0 + point.1 * normal.1 + point.2 * normal.2;
    let rx = point.0 - 2.0 * dot * normal.0;
    let ry = point.1 - 2.0 * dot * normal.1;
    let rz = point.2 - 2.0 * dot * normal.2;
    (rx, ry, rz)
  };

  /// Symmetry score
  public func medinaSymmetryScore(left : [Float], right : [Float]) : Float {
    let n = if (left.size() < right.size()) left.size() else right.size();
    if (n == 0) { return 1.0 };
    var diff : Float = 0.0;
    var i = 0;
    while (i < n) {
      diff += Float.abs(left[i] - right[n - 1 - i]);
      i += 1;
    };
    1.0 / (1.0 + diff)
  };

  /// Fractal dimension estimation
  public func medinaFractalDimension(boxCounts : [Nat], scales : [Float]) : Float {
    let n = if (boxCounts.size() < scales.size()) boxCounts.size() else scales.size();
    if (n < 2) { return 1.0 };
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let x = Float.log(1.0 / scales[i]);
      let y = Float.log(Float.fromInt(boxCounts[i]));
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    let nf = Float.fromInt(n);
    (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COVENANT MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Commitment strength
  public func medinaCommitmentStrength(
    duration : Nat,
    consistency : Float,
    depth : Float
  ) : Float {
    let durationFactor = Float.log(Float.fromInt(duration + 1));
    consistency * depth * durationFactor
  };

  /// Trust accumulation
  public func medinaTrustAccumulation(
    currentTrust : Float,
    interaction : Float,
    reciprocity : Float
  ) : Float {
    let gain = interaction * reciprocity * (1.0 - currentTrust);
    currentTrust + gain
  };

  /// Covenant breach penalty
  public func medinaBreachPenalty(
    trustLevel : Float,
    violationSeverity : Float,
    relationshipAge : Nat
  ) : Float {
    let ageFactor = Float.log(Float.fromInt(relationshipAge + 1));
    trustLevel * violationSeverity * ageFactor
  };

}
