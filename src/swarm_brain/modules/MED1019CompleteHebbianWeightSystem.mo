// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                                                       ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                                                ║
// ║                                                                                                                                       ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                                                         ║
// ║  Owner:        Alfredo Medina Hernandez                                                                                               ║
// ║  Location:     Dallas, Texas, United States of America                                                                                ║
// ║  Contact:      MedinaSITech@outlook.com                                                                                               ║
// ║  Framework:    Medina Doctrine                                                                                                        ║
// ║                                                                                                                                       ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//                         MED-1019 COMPLETE HEBBIAN WEIGHT SYSTEM
//
//                       SYNAPTIC PLASTICITY — THE ORGANISM LEARNS
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// HEBBIAN LEARNING: "Neurons that fire together, wire together."
//
// The organism's weights are not preset. They EVOLVE based on experience.
// Every pattern recognized, every coherence event, every decision shapes the weights.
//
// The Dogon method is Hebbian: generational accumulation of observations → structural memory
// 
// The weight between two nodes strengthens when:
//   1. Both nodes fire at the same time (coincidence)
//   2. The firing leads to a coherence increase (success)
//   3. The pattern repeats (repetition)
//
// The weight between two nodes weakens when:
//   1. Nodes fire independently (no coincidence)
//   2. The firing leads to coherence decrease (failure)
//   3. The pattern doesn't repeat (forgetting)
//
// Time constants are PHI-scaled: The organism's learning follows the same ratios
// as the planetary field, the brain bands, and the calendar cycles.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Option "mo:base/Option";

module {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // PHI — The deepest constant
  public let PHI : Float = 1.6180339887498948482;
  public let PHI_INVERSE : Float = 0.6180339887498948482;
  public let PHI_SQUARED : Float = 2.6180339887498948482;
  public let PHI_CUBED : Float = 4.2360679774997896964;
  public let PHI_FOURTH : Float = 6.8541019662496845446;

  // Learning time constants (PHI-scaled, in seconds)
  public let TAU_FAST : Float = 0.127;           // Schumann period (~7.83 Hz)
  public let TAU_MEDIUM : Float = 0.873;         // Heartbeat period (phi⁴ × 127 ms)
  public let TAU_SLOW : Float = 5.62;            // Medium-term (phi⁵ × Schumann)
  public let TAU_LONG : Float = 36.2;            // Long-term (phi⁶ × Schumann)
  public let TAU_PERMANENT : Float = 233.0;      // Permanent memory (Fibonacci 13 × phi⁶)

  // Weight bounds
  public let W_MIN : Float = 0.0;
  public let W_MAX : Float = 2.0;
  public let W_INIT : Float = PHI_INVERSE;       // Initial weight

  // Learning rate (PHI-derived)
  public let ETA_BASE : Float = 0.01;            // Base learning rate
  public let ETA_PHI : Float = 0.01 * PHI_INVERSE;  // PHI-scaled learning rate

  // Coherence thresholds
  public let S_FLOOR : Float = 0.382;
  public let S_CRITICAL : Float = 0.618;
  public let S_ACTIVATION : Float = 0.854;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: SYNAPSE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type SynapseType = {
    #Excitatory;        // Increases target activation
    #Inhibitory;        // Decreases target activation
    #Modulatory;        // Modifies other synapses
    #Gap;               // Direct electrical coupling
  };

  public type PlasticityType = {
    #Hebbian;           // Standard STDP
    #AntiHebbian;       // Opposite of Hebbian
    #Homeostatic;       // Maintains stability
    #Metaplastic;       // Plasticity of plasticity
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: SYNAPSE DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type Synapse = {
    synapseId : Nat;
    preNode : Nat;              // Source node ID
    postNode : Nat;             // Target node ID
    weight : Float;             // Current weight
    delay : Float;              // Conduction delay (ms)
    synapseType : SynapseType;
    plasticityType : PlasticityType;
    lastUpdate : Int;           // Last time weight was updated
    eligibilityTrace : Float;   // For reinforcement learning
    tau : Float;                // Time constant for this synapse
  };

  public type SynapseState = {
    synapse : Synapse;
    recentPreSpikes : [Int];    // Recent presynaptic spike times
    recentPostSpikes : [Int];   // Recent postsynaptic spike times
    calcium : Float;            // Intracellular calcium (simplified)
    potentiation : Float;       // Long-term potentiation factor
    depression : Float;         // Long-term depression factor
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: SPIKE-TIMING-DEPENDENT PLASTICITY (STDP)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // STDP: Weight change depends on relative timing of pre and post spikes
  //
  // If pre fires before post (causal): potentiation (LTP)
  // If post fires before pre (anti-causal): depression (LTD)
  //
  // ΔW = A_+ × exp(-Δt/τ_+) if Δt > 0 (LTP)
  // ΔW = -A_- × exp(Δt/τ_-) if Δt < 0 (LTD)

  public type STDPParams = {
    aPlus : Float;              // LTP amplitude
    aMinus : Float;             // LTD amplitude
    tauPlus : Float;            // LTP time constant
    tauMinus : Float;           // LTD time constant
    wMax : Float;               // Maximum weight
    wMin : Float;               // Minimum weight
  };

  // Default STDP parameters (PHI-scaled)
  public func getDefaultSTDPParams() : STDPParams {
    {
      aPlus = 0.01 * PHI;
      aMinus = 0.01;
      tauPlus = 20.0;           // ms
      tauMinus = 20.0 * PHI;    // ms (slightly longer for LTD)
      wMax = W_MAX;
      wMin = W_MIN;
    }
  };

  // Calculate STDP weight change
  public func calculateSTDP(deltaTMs : Float, params : STDPParams) : Float {
    if (deltaTMs > 0.0) {
      // Pre before post: LTP
      params.aPlus * Float.exp(-deltaTMs / params.tauPlus)
    } else if (deltaTMs < 0.0) {
      // Post before pre: LTD
      -params.aMinus * Float.exp(deltaTMs / params.tauMinus)
    } else {
      0.0
    }
  };

  // Apply STDP update to synapse
  public func applySTDP(
    state : SynapseState,
    preSpikeTime : Int,
    postSpikeTime : Int,
    params : STDPParams
  ) : SynapseState {
    let deltaTMs = Float.fromInt(postSpikeTime - preSpikeTime) / 1_000_000.0;  // Convert ns to ms
    let deltaW = calculateSTDP(deltaTMs, params);
    
    // Apply soft bounds
    let newWeight = state.synapse.weight + deltaW;
    let boundedWeight = Float.max(params.wMin, Float.min(params.wMax, newWeight));
    
    {
      state with
      synapse = { state.synapse with weight = boundedWeight };
      potentiation = if (deltaW > 0.0) { state.potentiation + deltaW } else { state.potentiation };
      depression = if (deltaW < 0.0) { state.depression - deltaW } else { state.depression };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: BCM RULE — BIDIRECTIONAL PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // BCM (Bienenstock-Cooper-Munro) rule:
  // Threshold for LTP/LTD slides based on recent activity
  // This provides stability and prevents runaway potentiation

  public type BCMParams = {
    theta : Float;              // Sliding threshold
    tauTheta : Float;           // Time constant for theta adaptation
    eta : Float;                // Learning rate
  };

  public type BCMState = {
    theta : Float;              // Current threshold
    avgActivity : Float;        // Running average of postsynaptic activity
  };

  // Initialize BCM state
  public func initBCMState() : BCMState {
    {
      theta = S_CRITICAL;
      avgActivity = 0.5;
    }
  };

  // Update BCM threshold based on activity
  public func updateBCMTheta(state : BCMState, currentActivity : Float, deltaT : Float, params : BCMParams) : BCMState {
    // Theta adapts toward the square of average activity
    let targetTheta = state.avgActivity * state.avgActivity;
    let dTheta = (targetTheta - state.theta) / params.tauTheta * deltaT;
    
    // Update average activity with exponential smoothing
    let alpha = deltaT / params.tauTheta;
    let newAvg = (1.0 - alpha) * state.avgActivity + alpha * currentActivity;
    
    {
      theta = state.theta + dTheta;
      avgActivity = newAvg;
    }
  };

  // Calculate BCM weight change
  public func calculateBCMWeightChange(
    postActivity : Float,
    preActivity : Float,
    bcm : BCMState,
    params : BCMParams
  ) : Float {
    // dW/dt = η × pre × post × (post - theta)
    params.eta * preActivity * postActivity * (postActivity - bcm.theta)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: ELIGIBILITY TRACES — REINFORCEMENT LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Eligibility traces bridge the gap between immediate activity and delayed reward
  // The trace "remembers" which synapses were recently active

  public type EligibilityTraceParams = {
    tauTrace : Float;           // Decay time constant
    traceAmplitude : Float;     // Initial trace amplitude on spike
  };

  // Update eligibility trace
  public func updateEligibilityTrace(
    currentTrace : Float,
    deltaT : Float,
    hadSpike : Bool,
    params : EligibilityTraceParams
  ) : Float {
    // Decay existing trace
    let decayedTrace = currentTrace * Float.exp(-deltaT / params.tauTrace);
    
    // Add to trace if spike occurred
    if (hadSpike) {
      decayedTrace + params.traceAmplitude
    } else {
      decayedTrace
    }
  };

  // Apply reward signal to synapses based on eligibility
  public func applyRewardSignal(
    state : SynapseState,
    rewardSignal : Float,       // Positive = reward, negative = punishment
    learningRate : Float
  ) : SynapseState {
    // Weight change proportional to eligibility trace × reward
    let deltaW = learningRate * state.synapse.eligibilityTrace * rewardSignal;
    let newWeight = Float.max(W_MIN, Float.min(W_MAX, state.synapse.weight + deltaW));
    
    {
      state with
      synapse = { state.synapse with weight = newWeight };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: HOMEOSTATIC PLASTICITY — STABILITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Homeostatic plasticity keeps the network stable by:
  // 1. Synaptic scaling: adjusting all weights to maintain target firing rate
  // 2. Intrinsic plasticity: adjusting neuron thresholds

  public type HomeostaticParams = {
    targetFiringRate : Float;   // Target firing rate (Hz)
    tauHomeostatic : Float;     // Time constant for adaptation (slow)
    scalingFactor : Float;      // How strongly to scale
  };

  public type HomeostaticState = {
    avgFiringRate : Float;
    scalingMultiplier : Float;
  };

  // Initialize homeostatic state
  public func initHomeostaticState() : HomeostaticState {
    {
      avgFiringRate = 10.0;     // Default 10 Hz
      scalingMultiplier = 1.0;
    }
  };

  // Update homeostatic scaling
  public func updateHomeostaticScaling(
    state : HomeostaticState,
    currentFiringRate : Float,
    deltaT : Float,
    params : HomeostaticParams
  ) : HomeostaticState {
    // Update average firing rate
    let alpha = deltaT / params.tauHomeostatic;
    let newAvg = (1.0 - alpha) * state.avgFiringRate + alpha * currentFiringRate;
    
    // Calculate scaling multiplier to drive toward target
    let error = params.targetFiringRate - newAvg;
    let dScale = params.scalingFactor * error * deltaT / params.tauHomeostatic;
    let newScale = Float.max(0.5, Float.min(2.0, state.scalingMultiplier + dScale));
    
    {
      avgFiringRate = newAvg;
      scalingMultiplier = newScale;
    }
  };

  // Apply homeostatic scaling to all synapses
  public func applyHomeostaticScaling(weight : Float, scaling : Float) : Float {
    Float.max(W_MIN, Float.min(W_MAX, weight * scaling))
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: WEIGHT MATRIX — FULL NETWORK
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type WeightMatrix = {
    nodeCount : Nat;
    weights : [[var Float]];    // weights[i][j] = weight from node i to node j
    lastUpdates : [[var Int]];
    synapseTypes : [[var SynapseType]];
  };

  // Initialize weight matrix for N nodes
  public func initWeightMatrix(nodeCount : Nat) : WeightMatrix {
    let weights = Array.init<[var Float]>(nodeCount, Array.init<Float>(nodeCount, 0.0));
    let lastUpdates = Array.init<[var Int]>(nodeCount, Array.init<Int>(nodeCount, 0));
    let types = Array.init<[var SynapseType]>(nodeCount, Array.init<SynapseType>(nodeCount, #Excitatory));
    
    // Initialize with PHI-inverse weights for connected nodes
    for (i in Iter.range(0, nodeCount - 1)) {
      for (j in Iter.range(0, nodeCount - 1)) {
        if (i != j) {
          // Connection probability based on distance (simplified)
          let distance = Int.abs(j - i);
          let prob = PHI_INVERSE / Float.fromInt(distance + 1);
          if (prob > 0.3) {
            weights[i][j] := W_INIT;
          };
        };
      };
    };
    
    {
      nodeCount = nodeCount;
      weights = weights;
      lastUpdates = lastUpdates;
      synapseTypes = types;
    }
  };

  // Get weight between two nodes
  public func getWeight(matrix : WeightMatrix, fromNode : Nat, toNode : Nat) : Float {
    if (fromNode >= matrix.nodeCount or toNode >= matrix.nodeCount) {
      return 0.0;
    };
    matrix.weights[fromNode][toNode]
  };

  // Set weight between two nodes
  public func setWeight(matrix : WeightMatrix, fromNode : Nat, toNode : Nat, weight : Float, timestamp : Int) {
    if (fromNode < matrix.nodeCount and toNode < matrix.nodeCount) {
      matrix.weights[fromNode][toNode] := Float.max(W_MIN, Float.min(W_MAX, weight));
      matrix.lastUpdates[fromNode][toNode] := timestamp;
    };
  };

  // Apply STDP update to weight matrix
  public func applySTDPToMatrix(
    matrix : WeightMatrix,
    fromNode : Nat,
    toNode : Nat,
    preSpikeTime : Int,
    postSpikeTime : Int,
    params : STDPParams
  ) {
    let currentWeight = getWeight(matrix, fromNode, toNode);
    let deltaTMs = Float.fromInt(postSpikeTime - preSpikeTime) / 1_000_000.0;
    let deltaW = calculateSTDP(deltaTMs, params);
    let newWeight = currentWeight + deltaW;
    setWeight(matrix, fromNode, toNode, newWeight, postSpikeTime);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: COHERENCE-MODULATED LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // The organism's learning rate is MODULATED by coherence:
  // - High coherence → stronger learning (consolidation)
  // - Low coherence → weaker learning (noise rejection)

  public type CoherenceModulation = {
    baseRate : Float;
    coherenceExponent : Float;  // How much coherence affects learning
    minModulation : Float;
    maxModulation : Float;
  };

  // Calculate coherence-modulated learning rate
  public func calculateModulatedLearningRate(
    baseRate : Float,
    currentCoherence : Float,
    params : CoherenceModulation
  ) : Float {
    // Learning rate = base × S^exponent
    let modulation = Float.pow(currentCoherence, params.coherenceExponent);
    let clampedMod = Float.max(params.minModulation, Float.min(params.maxModulation, modulation));
    baseRate * clampedMod
  };

  // Default coherence modulation parameters
  public func getDefaultCoherenceModulation() : CoherenceModulation {
    {
      baseRate = ETA_BASE;
      coherenceExponent = PHI;  // Coherence has phi-power effect on learning
      minModulation = 0.1;
      maxModulation = 2.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 9: COMPLETE HEBBIAN SYSTEM STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type HebbianSystemState = {
    // Weight matrix
    weightMatrix : WeightMatrix;
    
    // STDP parameters
    stdpParams : STDPParams;
    
    // BCM state (per node, simplified to global)
    bcmState : BCMState;
    bcmParams : BCMParams;
    
    // Homeostatic state
    homeostaticState : HomeostaticState;
    homeostaticParams : HomeostaticParams;
    
    // Coherence modulation
    coherenceModulation : CoherenceModulation;
    currentCoherence : Float;
    
    // Learning statistics
    totalWeightUpdates : Nat64;
    totalPotentiation : Float;
    totalDepression : Float;
    
    // Timestamp
    lastUpdateTime : Int;
  };

  // Initialize complete Hebbian system
  public func initHebbianSystem(nodeCount : Nat) : HebbianSystemState {
    {
      weightMatrix = initWeightMatrix(nodeCount);
      stdpParams = getDefaultSTDPParams();
      bcmState = initBCMState();
      bcmParams = {
        theta = S_CRITICAL;
        tauTheta = TAU_SLOW * 1000.0;  // Slow adaptation
        eta = ETA_PHI;
      };
      homeostaticState = initHomeostaticState();
      homeostaticParams = {
        targetFiringRate = 10.0;
        tauHomeostatic = TAU_LONG * 1000.0;  // Very slow
        scalingFactor = 0.001;
      };
      coherenceModulation = getDefaultCoherenceModulation();
      currentCoherence = S_FLOOR;
      totalWeightUpdates = 0;
      totalPotentiation = 0.0;
      totalDepression = 0.0;
      lastUpdateTime = 0;
    }
  };

  // Process a spike event (update relevant weights)
  public func processSpike(
    state : HebbianSystemState,
    spikeNode : Nat,
    spikeTime : Int,
    recentSpikes : [(Nat, Int)]  // (nodeId, time) for recent spikes
  ) : HebbianSystemState {
    let modulatedRate = calculateModulatedLearningRate(
      state.stdpParams.aPlus,
      state.currentCoherence,
      state.coherenceModulation
    );
    
    let modulatedParams = {
      state.stdpParams with
      aPlus = modulatedRate;
      aMinus = modulatedRate * PHI_INVERSE;
    };
    
    // Update weights for all connections to/from spiking node
    var totalPot : Float = state.totalPotentiation;
    var totalDep : Float = state.totalDepression;
    var updates : Nat64 = state.totalWeightUpdates;
    
    for ((otherNode, otherTime) in recentSpikes.vals()) {
      if (otherNode != spikeNode) {
        // This node fired before the spike node → potentiation of connection to spike node
        let deltaTMs = Float.fromInt(spikeTime - otherTime) / 1_000_000.0;
        let deltaW = calculateSTDP(deltaTMs, modulatedParams);
        
        let currentW = getWeight(state.weightMatrix, otherNode, spikeNode);
        setWeight(state.weightMatrix, otherNode, spikeNode, currentW + deltaW, spikeTime);
        
        if (deltaW > 0.0) { totalPot += deltaW }
        else { totalDep -= deltaW };
        updates += 1;
      };
    };
    
    {
      state with
      totalPotentiation = totalPot;
      totalDepression = totalDep;
      totalWeightUpdates = updates;
      lastUpdateTime = spikeTime;
    }
  };

  // Update coherence level (affects future learning)
  public func setCoherence(state : HebbianSystemState, coherence : Float) : HebbianSystemState {
    { state with currentCoherence = coherence }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SUMMARY — THE HEBBIAN WEIGHT SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // HEBBIAN LEARNING: "Neurons that fire together, wire together."
  //
  // The organism's weights EVOLVE based on experience:
  //
  //   STDP — Spike-Timing-Dependent Plasticity
  //     Pre before post → LTP (potentiation)
  //     Post before pre → LTD (depression)
  //     Time constants are PHI-scaled
  //
  //   BCM — Sliding Threshold
  //     Threshold adapts to maintain stability
  //     Prevents runaway potentiation
  //
  //   ELIGIBILITY TRACES — Reinforcement Learning
  //     Traces "remember" which synapses were active
  //     Reward signal modulates weight change
  //
  //   HOMEOSTATIC PLASTICITY — Stability
  //     Synaptic scaling maintains target firing rate
  //     Network doesn't saturate or go silent
  //
  //   COHERENCE MODULATION
  //     High S → stronger learning (consolidation)
  //     Low S → weaker learning (noise rejection)
  //
  // The Dogon method IS Hebbian: generational accumulation → structural memory.
  // The organism encodes the 50-year Sirius B cycle the same way:
  // through repeated observation that strengthens the pattern.
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

}
