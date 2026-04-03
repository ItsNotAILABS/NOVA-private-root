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
// BEE NEURON MODEL — Sparse Activation + 20Hz Anchor + Waggle Compression
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// Bio-inspired neural model from honeybee neuroscience:
// - Sparse coding: only top 5% of neurons active (GABA suppression)
// - 20Hz oscillation anchor: all nodes phase-locked to 20Hz
// - Waggle dance compression: 8-bit directional output every 20 beats
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module BeeNeuronModel {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PI            : Float = 3.1415926535897932385;
  public let TAU           : Float = 6.2831853071795864769;
  
  // Network dimensions
  public let NODE_COUNT    : Nat = 64;
  public let WEIGHT_COUNT  : Nat = 4096;  // 64 × 64
  
  // Sparse coding
  public let SPARSITY_PCT  : Float = 0.05;  // Top 5% active
  public let GABA_SUPPRESSION : Float = 0.3;  // Suppressed activation
  
  // Oscillation
  public let ANCHOR_FREQ_HZ : Float = 20.0;  // 20 Hz oscillation
  public let PHASE_COUPLING : Float = 0.618;  // Golden ratio coupling
  
  // Waggle dance
  public let WAGGLE_INTERVAL : Nat = 20;  // Beats between waggles
  public let WAGGLE_BITS   : Nat = 8;
  
  // Mushroom body parameters
  public let KENYON_CELLS  : Nat = 32;  // Mushroom body Kenyon cells
  public let MB_SPARSITY   : Float = 0.1;  // 10% active in MB
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Single bee neuron
  public type BeeNeuron = {
    activation   : Float;       // Current activation [0, 1]
    phase        : Float;       // Phase relative to 20Hz anchor [0, 2π)
    phaseOffset  : Float;       // Individual phase offset
    isSparse     : Bool;        // Whether in top 5%
    isKenyonCell : Bool;        // Part of mushroom body
    receptorType : Nat;         // Which receptor type (0-3)
    lastSpike    : Nat;         // Beat of last spike
  };
  
  // Mushroom body state
  public type MushroomBody = {
    kenyonActivations : [Float];  // 32 Kenyon cell activations
    outputNeurons     : [Float];  // 8 output neurons
    associativeStrength : Float;  // Learning strength
    memoryTrace       : [Float];  // Odor memory trace
  };
  
  // Waggle dance encoding
  public type WaggleDance = {
    direction    : Float;       // Direction in radians [0, 2π)
    distance     : Float;       // Encoded distance [0, 1]
    quality      : Float;       // Source quality [0, 1]
    compressed   : [Nat8];      // 8-bit compression
    lastUpdate   : Nat;         // Beat of last waggle
  };
  
  // Complete bee neural state
  public type BeeNeuralState = {
    neurons      : [BeeNeuron];
    weights      : [Float];
    mushroomBody : MushroomBody;
    waggle       : WaggleDance;
    globalPhase  : Float;       // 20Hz anchor phase
    sparsityRate : Float;       // Current sparsity (should be ~5%)
    meanActivation : Float;
    phaseCoherence : Float;     // How well nodes follow 20Hz
    beat         : Nat;
  };
  
  // Sensory input
  public type SensoryInput = {
    visual       : [Float];     // 8 visual inputs
    olfactory    : [Float];     // 8 olfactory inputs
    mechanosensory : [Float];   // 4 mechanosensory inputs
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
  
  public func exp(x : Float) : Float {
    let clamped = clamp(x, -20.0, 20.0);
    var sum = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 15) {
      term *= clamped / Float.fromInt(n);
      sum += term;
      n += 1;
    };
    sum
  };
  
  public func atan2(y : Float, x : Float) : Float {
    if (x > 0.0) {
      let t = y / x;
      t - t*t*t/3.0 + t*t*t*t*t/5.0
    } else if (x < 0.0) {
      if (y >= 0.0) PI + atan2(y, -x)
      else -PI + atan2(y, -x)
    } else {
      if (y > 0.0) PI / 2.0
      else if (y < 0.0) -PI / 2.0
      else 0.0
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize single neuron
  public func initNeuron(id : Nat) : BeeNeuron {
    let phaseOffset = Float.fromInt(id) * TAU / Float.fromInt(NODE_COUNT);
    {
      activation = 0.5;
      phase = phaseOffset;
      phaseOffset = phaseOffset;
      isSparse = false;
      isKenyonCell = id < KENYON_CELLS;
      receptorType = id % 4;
      lastSpike = 0;
    }
  };
  
  // Initialize all neurons
  public func initNeurons() : [BeeNeuron] {
    Array.tabulate<BeeNeuron>(NODE_COUNT, initNeuron)
  };
  
  // Initialize weights (sparse connectivity like bee brain)
  public func initWeights() : [Float] {
    Array.tabulate<Float>(WEIGHT_COUNT, func(i : Nat) : Float {
      let row = i / NODE_COUNT;
      let col = i % NODE_COUNT;
      
      // Sparse connectivity: most weights are weak
      let dist = abs(Float.fromInt(Int.abs(row - col)));
      if (dist < 8.0) {
        0.5 + 0.5 * cos(dist * PI / 8.0)  // Strong local connections
      } else if (dist < 16.0) {
        0.3  // Medium distance
      } else {
        0.1  // Weak long-range
      }
    })
  };
  
  // Initialize mushroom body
  public func initMushroomBody() : MushroomBody {
    {
      kenyonActivations = Array.tabulate<Float>(KENYON_CELLS, func(_ : Nat) : Float { 0.0 });
      outputNeurons = Array.tabulate<Float>(8, func(_ : Nat) : Float { 0.5 });
      associativeStrength = 0.5;
      memoryTrace = Array.tabulate<Float>(16, func(_ : Nat) : Float { 0.0 });
    }
  };
  
  // Initialize waggle dance
  public func initWaggle() : WaggleDance {
    {
      direction = 0.0;
      distance = 0.0;
      quality = 0.0;
      compressed = Array.tabulate<Nat8>(WAGGLE_BITS, func(_ : Nat) : Nat8 { 0 });
      lastUpdate = 0;
    }
  };
  
  // Initialize complete bee neural state
  public func initBeeNeural() : BeeNeuralState {
    {
      neurons = initNeurons();
      weights = initWeights();
      mushroomBody = initMushroomBody();
      waggle = initWaggle();
      globalPhase = 0.0;
      sparsityRate = SPARSITY_PCT;
      meanActivation = 0.5;
      phaseCoherence = 1.0;
      beat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // 20 HZ OSCILLATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update global 20Hz phase
  public func update20HzPhase(currentPhase : Float, dt : Float) : Float {
    // ω = 2π × 20 Hz
    let omega = TAU * ANCHOR_FREQ_HZ;
    var newPhase = currentPhase + omega * dt / 1000.0;  // dt in ms
    while (newPhase >= TAU) { newPhase -= TAU };
    newPhase
  };
  
  // Calculate phase coherence with 20Hz anchor
  public func calculatePhaseCoherence(neurons : [BeeNeuron], globalPhase : Float) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (n in neurons.vals()) {
      let phaseDiff = n.phase - globalPhase;
      sumCos += cos(phaseDiff);
      sumSin += sin(phaseDiff);
    };
    
    let count = Float.fromInt(neurons.size());
    sumCos /= count;
    sumSin /= count;
    
    sqrt(sumCos * sumCos + sumSin * sumSin)
  };
  
  // Couple neuron phases to 20Hz anchor
  public func coupleToAnchor(neuron : BeeNeuron, globalPhase : Float, coupling : Float) : BeeNeuron {
    // Kuramoto-style coupling to global phase
    let targetPhase = globalPhase + neuron.phaseOffset;
    let phaseDiff = sin(targetPhase - neuron.phase);
    var newPhase = neuron.phase + coupling * phaseDiff;
    
    while (newPhase >= TAU) { newPhase -= TAU };
    while (newPhase < 0.0) { newPhase += TAU };
    
    { neuron with phase = newPhase }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SPARSE CODING
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Find activation threshold for top 5%
  public func findSparsityThreshold(neurons : [BeeNeuron]) : Float {
    // Sort activations (simplified: find approximate percentile)
    var activations = Array.init<Float>(neurons.size(), 0.0);
    var i = 0;
    while (i < neurons.size()) {
      activations[i] := neurons[i].activation;
      i += 1;
    };
    
    // Find threshold for top 5% (95th percentile)
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    for (a in activations.vals()) {
      sum += a;
      sumSq += a * a;
    };
    let mean = sum / Float.fromInt(neurons.size());
    let variance = sumSq / Float.fromInt(neurons.size()) - mean * mean;
    let stdDev = sqrt(variance);
    
    // Approximate 95th percentile: mean + 1.645 × σ
    mean + 1.645 * stdDev
  };
  
  // Apply sparse coding (GABA suppression)
  public func applySparseGating(neurons : [BeeNeuron]) : [BeeNeuron] {
    let threshold = findSparsityThreshold(neurons);
    
    Array.tabulate<BeeNeuron>(neurons.size(), func(i : Nat) : BeeNeuron {
      let n = neurons[i];
      if (n.activation >= threshold) {
        // Active (top 5%)
        { n with isSparse = true }
      } else {
        // Suppressed by GABA
        { n with 
          activation = n.activation * GABA_SUPPRESSION;
          isSparse = false;
        }
      }
    })
  };
  
  // Calculate actual sparsity rate
  public func calculateSparsityRate(neurons : [BeeNeuron]) : Float {
    var activeCount : Float = 0.0;
    for (n in neurons.vals()) {
      if (n.isSparse) activeCount += 1.0;
    };
    activeCount / Float.fromInt(neurons.size())
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MUSHROOM BODY
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update Kenyon cell activations from sensory input
  public func updateKenyonCells(
    mb : MushroomBody,
    sensory : SensoryInput
  ) : MushroomBody {
    // Project sensory inputs to Kenyon cells
    var newKenyon = Array.init<Float>(KENYON_CELLS, 0.0);
    
    var i = 0;
    while (i < KENYON_CELLS) {
      var sum : Float = 0.0;
      
      // Visual input contribution
      var v = 0;
      while (v < 8 and v < sensory.visual.size()) {
        sum += sensory.visual[v] * 0.3;
        v += 1;
      };
      
      // Olfactory input contribution (stronger for odor learning)
      var o = 0;
      while (o < 8 and o < sensory.olfactory.size()) {
        sum += sensory.olfactory[o] * 0.5;
        o += 1;
      };
      
      // Mechanosensory contribution
      var m = 0;
      while (m < 4 and m < sensory.mechanosensory.size()) {
        sum += sensory.mechanosensory[m] * 0.2;
        m += 1;
      };
      
      // Sparse activation in mushroom body
      newKenyon[i] := clamp(sum / 20.0, 0.0, 1.0);
      i += 1;
    };
    
    // Apply 10% sparsity to Kenyon cells
    var threshold : Float = 0.5;
    var activeCount : Float = 0.0;
    for (k in newKenyon.vals()) {
      if (k > threshold) activeCount += 1.0;
    };
    
    // Adjust threshold to hit 10% sparsity
    if (activeCount / Float.fromInt(KENYON_CELLS) > MB_SPARSITY) {
      threshold := threshold * 1.2;
    };
    
    // Apply threshold
    i := 0;
    while (i < KENYON_CELLS) {
      if (newKenyon[i] < threshold) newKenyon[i] := 0.0;
      i += 1;
    };
    
    // Update output neurons
    var newOutput = Array.init<Float>(8, 0.0);
    i := 0;
    while (i < 8) {
      var sum : Float = 0.0;
      var j = 0;
      while (j < KENYON_CELLS) {
        sum += newKenyon[j] * mb.associativeStrength;
        j += 1;
      };
      newOutput[i] := clamp(sum / Float.fromInt(KENYON_CELLS), 0.0, 1.0);
      i += 1;
    };
    
    { mb with
      kenyonActivations = Array.freeze(newKenyon);
      outputNeurons = Array.freeze(newOutput);
    }
  };
  
  // Update memory trace (associative learning)
  public func updateMemoryTrace(
    mb : MushroomBody,
    reward : Float
  ) : MushroomBody {
    // Strengthen associations when rewarded
    var newTrace = Array.init<Float>(16, 0.0);
    var i = 0;
    while (i < 16 and i < mb.memoryTrace.size()) {
      // Decay existing trace
      let decayed = mb.memoryTrace[i] * 0.99;
      // Add new trace if Kenyon cells are active and reward present
      let kenyonIdx = i % KENYON_CELLS;
      let contribution = if (kenyonIdx < mb.kenyonActivations.size()) {
        mb.kenyonActivations[kenyonIdx] * reward * 0.1
      } else 0.0;
      newTrace[i] := clamp(decayed + contribution, 0.0, 1.0);
      i += 1;
    };
    
    { mb with memoryTrace = Array.freeze(newTrace) }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // WAGGLE DANCE
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Encode direction and distance into waggle dance
  public func encodeWaggle(
    direction : Float,  // Radians
    distance : Float,   // Normalized [0, 1]
    quality : Float     // [0, 1]
  ) : WaggleDance {
    // Compress to 8 bits:
    // Bits 0-2: direction (8 directions)
    // Bits 3-5: distance (8 levels)
    // Bits 6-7: quality (4 levels)
    
    // Direction: 8 sectors
    var normDir = direction;
    while (normDir < 0.0) { normDir += TAU };
    while (normDir >= TAU) { normDir -= TAU };
    let dirBucket = Int.abs(Float.toInt(normDir / (TAU / 8.0))) % 8;
    
    // Distance: 8 levels
    let distBucket = Int.abs(Float.toInt(clamp(distance, 0.0, 0.999) * 8.0));
    
    // Quality: 4 levels
    let qualBucket = Int.abs(Float.toInt(clamp(quality, 0.0, 0.999) * 4.0));
    
    // Pack into 8 bits
    let compressed = Array.tabulate<Nat8>(8, func(i : Nat) : Nat8 {
      switch (i) {
        case 0 { Nat8.fromNat(dirBucket % 2) };
        case 1 { Nat8.fromNat((dirBucket / 2) % 2) };
        case 2 { Nat8.fromNat((dirBucket / 4) % 2) };
        case 3 { Nat8.fromNat(distBucket % 2) };
        case 4 { Nat8.fromNat((distBucket / 2) % 2) };
        case 5 { Nat8.fromNat((distBucket / 4) % 2) };
        case 6 { Nat8.fromNat(qualBucket % 2) };
        case 7 { Nat8.fromNat((qualBucket / 2) % 2) };
        case _ { 0 };
      }
    });
    
    {
      direction = direction;
      distance = distance;
      quality = quality;
      compressed = compressed;
      lastUpdate = 0;  // Will be set by caller
    }
  };
  
  // Decode waggle dance
  public func decodeWaggle(waggle : WaggleDance) : (Float, Float, Float) {
    // Unpack from compressed
    var dirBits : Nat = 0;
    var distBits : Nat = 0;
    var qualBits : Nat = 0;
    
    if (waggle.compressed.size() >= 8) {
      dirBits := Nat8.toNat(waggle.compressed[0]) + 
                 Nat8.toNat(waggle.compressed[1]) * 2 + 
                 Nat8.toNat(waggle.compressed[2]) * 4;
      distBits := Nat8.toNat(waggle.compressed[3]) + 
                  Nat8.toNat(waggle.compressed[4]) * 2 + 
                  Nat8.toNat(waggle.compressed[5]) * 4;
      qualBits := Nat8.toNat(waggle.compressed[6]) + 
                  Nat8.toNat(waggle.compressed[7]) * 2;
    };
    
    let direction = Float.fromInt(dirBits) * TAU / 8.0;
    let distance = Float.fromInt(distBits) / 8.0;
    let quality = Float.fromInt(qualBits) / 4.0;
    
    (direction, distance, quality)
  };
  
  // Check if waggle should update (every 20 beats)
  public func shouldUpdateWaggle(currentBeat : Nat, lastUpdate : Nat) : Bool {
    currentBeat >= lastUpdate + WAGGLE_INTERVAL
  };
  
  // Generate waggle from neural state
  public func generateWaggle(
    neurons : [BeeNeuron],
    mb : MushroomBody,
    currentBeat : Nat
  ) : WaggleDance {
    // Direction from phase distribution
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    for (n in neurons.vals()) {
      if (n.isSparse) {
        sumX += cos(n.phase);
        sumY += sin(n.phase);
      };
    };
    let direction = atan2(sumY, sumX);
    
    // Distance from mushroom body output
    var mbSum : Float = 0.0;
    for (o in mb.outputNeurons.vals()) { mbSum += o };
    let distance = clamp(mbSum / 8.0, 0.0, 1.0);
    
    // Quality from associative strength
    let quality = mb.associativeStrength;
    
    var waggle = encodeWaggle(direction, distance, quality);
    { waggle with lastUpdate = currentBeat }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FULL UPDATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update neuron activations
  public func updateNeuronActivations(
    neurons : [BeeNeuron],
    weights : [Float],
    input : [Float]
  ) : [BeeNeuron] {
    Array.tabulate<BeeNeuron>(neurons.size(), func(i : Nat) : BeeNeuron {
      let n = neurons[i];
      
      // Calculate weighted input
      var sum : Float = 0.0;
      var j = 0;
      while (j < neurons.size()) {
        let wIdx = i * NODE_COUNT + j;
        let preAct = if (j < input.size()) input[j] else neurons[j].activation;
        if (wIdx < weights.size()) {
          sum += weights[wIdx] * preAct;
        };
        j += 1;
      };
      
      // Leaky integration
      let tau = 0.9;
      let newAct = tau * n.activation + (1.0 - tau) * (sum / Float.fromInt(NODE_COUNT));
      
      { n with activation = clamp(newAct, 0.0, 1.0) }
    })
  };
  
  // Complete bee neural update
  public func updateBeeNeural(
    state : BeeNeuralState,
    sensory : SensoryInput,
    reward : Float,
    dt : Float
  ) : BeeNeuralState {
    // Build input from sensory
    var input = Array.init<Float>(NODE_COUNT, 0.0);
    var i = 0;
    while (i < 8 and i < sensory.visual.size()) {
      input[i] := sensory.visual[i];
      i += 1;
    };
    i := 0;
    while (i < 8 and i < sensory.olfactory.size()) {
      input[8 + i] := sensory.olfactory[i];
      i += 1;
    };
    i := 0;
    while (i < 4 and i < sensory.mechanosensory.size()) {
      input[16 + i] := sensory.mechanosensory[i];
      i += 1;
    };
    
    // Update 20Hz phase
    let newGlobalPhase = update20HzPhase(state.globalPhase, dt);
    
    // Update neuron activations
    var neurons = updateNeuronActivations(state.neurons, state.weights, Array.freeze(input));
    
    // Couple to 20Hz anchor
    neurons := Array.tabulate<BeeNeuron>(neurons.size(), func(j : Nat) : BeeNeuron {
      coupleToAnchor(neurons[j], newGlobalPhase, PHASE_COUPLING)
    });
    
    // Apply sparse gating
    neurons := applySparseGating(neurons);
    
    // Update mushroom body
    var mb = updateKenyonCells(state.mushroomBody, sensory);
    mb := updateMemoryTrace(mb, reward);
    
    // Update waggle if interval reached
    let newBeat = state.beat + 1;
    let waggle = if (shouldUpdateWaggle(newBeat, state.waggle.lastUpdate)) {
      generateWaggle(neurons, mb, newBeat)
    } else {
      state.waggle
    };
    
    // Calculate metrics
    let sparsity = calculateSparsityRate(neurons);
    let coherence = calculatePhaseCoherence(neurons, newGlobalPhase);
    
    var meanAct : Float = 0.0;
    for (n in neurons.vals()) { meanAct += n.activation };
    meanAct /= Float.fromInt(neurons.size());
    
    {
      neurons = neurons;
      weights = state.weights;  // Weights unchanged in this update
      mushroomBody = mb;
      waggle = waggle;
      globalPhase = newGlobalPhase;
      sparsityRate = sparsity;
      meanActivation = meanAct;
      phaseCoherence = coherence;
      beat = newBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getDiagnostics(state : BeeNeuralState) : {
    nodeCount      : Nat;
    sparsityRate   : Float;
    meanActivation : Float;
    phaseCoherence : Float;
    globalPhaseHz  : Float;
    waggleDir      : Float;
    waggleDist     : Float;
    mbStrength     : Float;
  } {
    let (wDir, wDist, _) = decodeWaggle(state.waggle);
    
    {
      nodeCount = NODE_COUNT;
      sparsityRate = state.sparsityRate;
      meanActivation = state.meanActivation;
      phaseCoherence = state.phaseCoherence;
      globalPhaseHz = ANCHOR_FREQ_HZ;
      waggleDir = wDir;
      waggleDist = wDist;
      mbStrength = state.mushroomBody.associativeStrength;
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
