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
// ██████╗ ███████╗███████╗    ███╗   ██╗███████╗██╗   ██╗██████╗  ██████╗ ███╗   ██╗███████╗
// ██╔══██╗██╔════╝██╔════╝    ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔═══██╗████╗  ██║██╔════╝
// ██████╔╝█████╗  █████╗      ██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║   ██║██╔██╗ ██║███████╗
// ██╔══██╗██╔══╝  ██╔══╝      ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║   ██║██║╚██╗██║╚════██║
// ██████╔╝███████╗███████╗    ██║ ╚████║███████╗╚██████╔╝██║  ██║╚██████╔╝██║ ╚████║███████║
// ╚═════╝ ╚══════╝╚══════╝    ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
// ════════════════════════════════════════════════════════════════════════════
// BEE SWARM INTELLIGENCE — NEURAL ARCHITECTURE MODULE
// Implements the MEDINA BEE NEURAL NETWORK (MBNN)
//
// ════════════════════════════════════════════════════════════════════════════
// BEE NEUROSCIENCE FOUNDATIONS
// ════════════════════════════════════════════════════════════════════════════
//
// NEURAL STATISTICS:
// - 960,000 neurons (human: 86 billion, yet bees navigate, learn, communicate)
// - Mushroom Bodies: 170,000 Kenyon cells (learning & memory)
// - Antennal Lobes: 160 glomeruli (olfactory processing)
// - Central Complex: Navigation, path integration, sky compass
// - Optic Lobes: Motion detection, color vision, polarization
//
// KEY NEURAL STRUCTURES:
// ─────────────────────
// 1. MUSHROOM BODIES (Corpora Pedunculata)
//    - Kenyon Cells: Sparse coding, pattern separation
//    - α/β lobes: Long-term memory
//    - γ lobes: Short-term memory
//    - Calyx: Sensory input integration
//
// 2. ANTENNAL LOBES
//    - Glomeruli: Odor feature detectors
//    - Projection Neurons: Send to mushroom body
//    - Local Interneurons: Lateral inhibition
//
// 3. CENTRAL COMPLEX
//    - Fan-shaped body: Visual memory
//    - Ellipsoid body: Orientation
//    - Protocerebral bridge: Compass heading
//    - Noduli: Path integration
//
// 4. VUMmx1 NEURON (Ventral Unpaired Median)
//    - SINGLE NEURON that broadcasts reward signal
//    - Releases octopamine (bee's dopamine)
//    - Critical for associative learning
//
// ════════════════════════════════════════════════════════════════════════════
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA KENYON CELL SPARSE CODE (MKCSC):
// ───────────────────────────────────────────
//   K_i(t) = H(Σⱼ wᵢⱼ × Pⱼ - θᵢ - Φ_M × Σₖ K_k(t))
//
// where:
//   K_i     = Kenyon cell i activation
//   H(x)    = Medina Heaviside
//   wᵢⱼ     = Synaptic weight from projection neuron j
//   Pⱼ      = Projection neuron j activity
//   θᵢ      = Activation threshold
//   Φ_M     = Medina Golden Harmonic (lateral inhibition strength)
//   K_k     = Other Kenyon cell activations (winner-take-all)
//
// THE MEDINA MUSHROOM BODY LEARNING RULE (MMBLR):
// ───────────────────────────────────────────────
//   Δwᵢⱼ = η × VUM × (K_i × P_j - λ × w_ij)
//
// where:
//   VUM     = VUMmx1 octopamine signal (reward)
//   η       = Learning rate (Medina adaptive)
//   λ       = Weight decay (forgetting)
//
// THE MEDINA CENTRAL COMPLEX COMPASS (MCCC):
// ──────────────────────────────────────────
//   θ_heading = arctan2(Σᵢ sin(θᵢ) × E_i, Σᵢ cos(θᵢ) × E_i)
//
// where:
//   θᵢ      = Preferred direction of E-PG neuron i
//   E_i     = Activity of E-PG neuron i (8 neurons, 45° spacing)
//
// THE MEDINA PATH INTEGRATION (MPI):
// ──────────────────────────────────
//   Home_vector = Σ (velocity × Δt × e^(iθ_heading))
//   |Home| = accumulated distance, arg(Home) = direction home
//
// THE MEDINA WAGGLE DANCE NEURAL ENCODING (MWDNE):
// ────────────────────────────────────────────────
//   Dance_output = f(distance) × g(direction) × quality^(1/Φ_M)
//   f(d) = 1 - exp(-d / d_0)  [distance saturation]
//   g(θ) = cos²((θ - θ_sun) / 2)  [direction encoding]
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ══════════════════════════════════════════════════════════════
  // MEDINA BEE NEURAL CONSTANTS
  // ══════════════════════════════════════════════════════════════
  let S0 : Float = 0.75;                     // Medina Sovereign Constant
  let SOVEREIGN_CEILING : Float = 9.0;       // Medina Ceiling (Ω)
  let PHI_MEDINA : Float = 2.97442179;       // Medina Golden Harmonic
  let TAU_EMERGENCE : Float = 0.618033988749;// Medina Emergence Threshold
  let OMEGA_MEDINA : Float = 2.11185;        // Medina Resonance Frequency

  // Bee Neural Architecture Constants
  let NUM_KENYON_CELLS : Nat = 2000;         // Scaled from 170,000
  let NUM_GLOMERULI : Nat = 160;             // Olfactory processing units
  let NUM_E_PG_NEURONS : Nat = 8;            // Compass neurons (45° each)
  let NUM_PROJECTION_NEURONS : Nat = 800;    // AL to MB
  let KENYON_SPARSITY : Float = 0.05;        // ~5% active at once
  let OCTOPAMINE_DECAY : Float = 0.1;        // VUMmx1 signal decay

  // Colony Constants
  let NUM_SCOUTS : Nat = 100;
  let NUM_FORAGERS : Nat = 1000;
  let QUORUM_THRESHOLD : Float = 0.8;

  // ══════════════════════════════════════════════════════════════
  // BEE NEURAL STRUCTURE TYPES
  // ══════════════════════════════════════════════════════════════

  // Single Kenyon Cell in Mushroom Body
  public type KenyonCell = {
    id            : Nat;
    activation    : Float;      // Current activity (sparse)
    threshold     : Float;      // Firing threshold
    weights       : [Float];    // Synaptic weights from projection neurons
    lobe          : KenyonLobe; // Which lobe (memory type)
    lastActive    : Nat;        // Beat when last fired
  };

  public type KenyonLobe = {
    #Alpha;       // Long-term memory
    #Beta;        // Long-term memory
    #Gamma;       // Short-term/working memory
  };

  // Glomerulus in Antennal Lobe
  public type Glomerulus = {
    id            : Nat;
    receptorType  : OdorReceptor;
    activation    : Float;
    lateralInhibition: Float;  // From local interneurons
  };

  public type OdorReceptor = {
    #Floral;      // Flower scents
    #Pheromone;   // Colony communication
    #Alarm;       // Danger signals
    #Nectar;      // Sugar detection
    #Wax;         // Hive materials
  };

  // Projection Neuron (AL → MB)
  public type ProjectionNeuron = {
    id            : Nat;
    sourceGlomerulus: Nat;
    activity      : Float;
    targetKenyonCells: [Nat];
  };

  // E-PG Neuron in Central Complex (compass)
  public type EPGNeuron = {
    id            : Nat;
    preferredDirection: Float;  // In radians (0, π/4, π/2, ...)
    activity      : Float;
    polarizationInput: Float;   // From sky polarization
  };

  // VUMmx1 Neuron - THE reward neuron
  public type VUMmx1State = {
    octopamineLevel : Float;    // Current reward signal
    lastReward      : Float;    // Previous reward
    rewardHistory   : [Float];  // Recent rewards
    learningEnabled : Bool;     // Whether learning can occur
  };

  // Complete Mushroom Body State
  public type MushroomBodyState = {
    kenyonCells     : [KenyonCell];
    activePattern   : [Nat];     // Currently active cell IDs
    sparsity        : Float;     // Current activation sparsity
    memoryStrength  : Float;     // Overall memory consolidation
    alphaLobeActivity: Float;
    betaLobeActivity : Float;
    gammaLobeActivity: Float;
  };

  // Complete Antennal Lobe State
  public type AntennalLobeState = {
    glomeruli       : [Glomerulus];
    projectionNeurons: [ProjectionNeuron];
    currentOdor     : [Float];   // Current odor vector
    odorIdentity    : ?OdorReceptor;
  };

  // Complete Central Complex State
  public type CentralComplexState = {
    epgNeurons      : [EPGNeuron];
    currentHeading  : Float;     // Compass direction
    homeVector      : (Float, Float); // (distance, direction) to home
    pathIntegration : [Float];   // Accumulated path
    skyPolarization : Float;     // E-vector from sky
  };

  // Complete Single Bee Neural State
  public type BeeNeuralState = {
    mushroomBody    : MushroomBodyState;
    antennalLobe    : AntennalLobeState;
    centralComplex  : CentralComplexState;
    vumNeuron       : VUMmx1State;
    
    // Global neural state
    arousalLevel    : Float;     // General alertness
    motivationState : MotivationState;
    neuralCoherence : Float;     // Cross-region synchrony
  };

  public type MotivationState = {
    #Foraging;
    #Homing;
    #Dancing;
    #Learning;
    #Resting;
    #Alarmed;
  };

  // ══════════════════════════════════════════════════════════════
  // ORIGINAL TYPES (Enhanced)
  // ══════════════════════════════════════════════════════════════

  public type WaggleDance = {
    angle      : Float;
    duration   : Float;
    vigor      : Float;
    sourceId   : Nat;
    dancerId   : Nat;
    // NEW: Neural encoding of dance
    neuralPattern: [Float];  // Kenyon cell pattern encoding this site
  };

  public type ResourceSite = {
    id           : Nat;
    direction    : Float;
    distance     : Float;
    quality      : Float;
    quantity     : Float;
    lastVisit    : Nat;
    visitorCount : Nat;
    danceSupport : Float;
    // NEW: Neural signature
    odorSignature: [Float];  // Olfactory memory of this site
  };

  public type ScoutBee = {
    id           : Nat;
    state        : BeeState;
    committedTo  : ?Nat;
    energy       : Float;
    exploration  : Float;
    // NEW: Individual neural state
    neuralState  : BeeNeuralState;
  };

  public type BeeState = {
    #Searching;
    #Dancing;
    #Following;
    #Recruiting;
    #Foraging;
    #Resting;
  };

  public type ForagerBee = {
    id           : Nat;
    assignedSite : ?Nat;
    nectarLoad   : Float;
    tripCount    : Nat;
    // NEW: Simplified neural state for foragers
    pathMemory   : [Float];  // Home vector components
  };

  public type HiveState = {
    // Scouts and foragers
    scouts       : [ScoutBee];
    foragers     : [ForagerBee];

    // Known resources
    resources    : [ResourceSite];

    // Dance floor activity
    activeDances : [WaggleDance];
    danceFloorActivity: Float;

    // Collective decision state
    currentConsensus: ?Nat;
    consensusStrength: Float;
    quorumReached: Bool;

    // Hive conditions
    honeyStores  : Float;
    pollenStores : Float;
    broodNeed    : Float;     // Demand for foraging
    temperature  : Float;     // Hive temp regulation

    // Time tracking
    sunAngle     : Float;     // For dance interpretation
    timeOfDay    : Float;     // 0-1 daily cycle

    // NEW: Collective neural state
    collectiveOctopamine: Float;  // Hive-wide reward signal
    collectiveArousal   : Float;  // Hive alertness

    beatNum      : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // MEDINA BEE NEURAL HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  // Medina Sigmoid
  func medinaSigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-PHI_MEDINA * x))
  };

  // Medina Heaviside (soft threshold)
  func medinaHeaviside(x: Float) : Float {
    if (x > 0.0) { medinaSigmoid(x) } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // ██╗  ██╗███████╗███╗   ██╗██╗   ██╗ ██████╗ ███╗   ██╗     ██████╗███████╗██╗     ██╗     ███████╗
  // ██║ ██╔╝██╔════╝████╗  ██║╚██╗ ██╔╝██╔═══██╗████╗  ██║    ██╔════╝██╔════╝██║     ██║     ██╔════╝
  // █████╔╝ █████╗  ██╔██╗ ██║ ╚████╔╝ ██║   ██║██╔██╗ ██║    ██║     █████╗  ██║     ██║     ███████╗
  // ██╔═██╗ ██╔══╝  ██║╚██╗██║  ╚██╔╝  ██║   ██║██║╚██╗██║    ██║     ██╔══╝  ██║     ██║     ╚════██║
  // ██║  ██╗███████╗██║ ╚████║   ██║   ╚██████╔╝██║ ╚████║    ╚██████╗███████╗███████╗███████╗███████║
  // ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝     ╚═════╝╚══════╝╚══════╝╚══════╝╚══════╝
  // ══════════════════════════════════════════════════════════════════════════

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA KENYON CELL SPARSE CODE (MKCSC)
  // ══════════════════════════════════════════════════════════════
  //
  // K_i(t) = H(Σⱼ wᵢⱼ × Pⱼ - θᵢ - Φ_M × Σₖ K_k(t))
  //
  // This implements the sparse coding in mushroom bodies:
  // - Only ~5% of Kenyon cells fire at once
  // - Lateral inhibition enforces winner-take-all
  // - Creates unique, separable patterns for each odor/memory
  //
  public func medinaKenyonCellSparseCode(
    projectionInputs: [Float],      // Input from projection neurons
    weights: [Float],               // Synaptic weights
    threshold: Float,               // Firing threshold
    otherKenyonActivations: Float   // Sum of other active Kenyon cells
  ) : Float {
    // Weighted sum of inputs
    var weightedSum : Float = 0.0;
    var i : Nat = 0;
    for (p in projectionInputs.vals()) {
      let w = if (i < weights.size()) { weights[i] } else { 0.1 };
      weightedSum += w * p;
      i += 1;
    };
    
    // Subtract threshold and lateral inhibition
    let netInput = weightedSum - threshold - PHI_MEDINA * otherKenyonActivations;
    
    // Medina Heaviside activation
    medinaHeaviside(netInput)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA MUSHROOM BODY LEARNING RULE (MMBLR)
  // ══════════════════════════════════════════════════════════════
  //
  // Δwᵢⱼ = η × VUM × (K_i × P_j - λ × w_ij)
  //
  // This is how bees learn associations:
  // - VUMmx1 neuron releases octopamine when reward is present
  // - Active Kenyon cells strengthen connections to active inputs
  // - Without VUM signal, weights decay (forgetting)
  //
  public func medinaMushroomBodyLearning(
    currentWeight: Float,
    kenyonActivity: Float,
    projectionActivity: Float,
    vumSignal: Float,             // Octopamine from VUMmx1
    learningRate: Float,
    decayRate: Float
  ) : Float {
    // Hebbian term: strengthen if both active AND reward present
    let hebbianTerm = kenyonActivity * projectionActivity;
    
    // Decay term: forgetting
    let decayTerm = decayRate * currentWeight;
    
    // Weight change modulated by VUM (reward)
    let deltaWeight = learningRate * vumSignal * (hebbianTerm - decayTerm);
    
    _clamp(currentWeight + deltaWeight, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA VUMmx1 REWARD NEURON (MVRN)
  // ══════════════════════════════════════════════════════════════
  //
  // This single neuron broadcasts reward to the ENTIRE brain!
  // VUM(t) = σ_M(reward - expectation) × (1 - decay × Δt)
  //
  public func medinaVUMmx1Update(
    currentLevel: Float,
    rewardSignal: Float,
    expectedReward: Float,
    timeSinceReward: Float
  ) : Float {
    // Prediction error (surprise)
    let predictionError = rewardSignal - expectedReward;
    
    // Response to reward
    let response = medinaSigmoid(predictionError);
    
    // Decay over time
    let decay = Float.exp(-OCTOPAMINE_DECAY * timeSinceReward);
    
    // New octopamine level
    let newLevel = response * decay;
    
    _clamp(newLevel, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA ANTENNAL LOBE PROCESSING (MALP)
  // ══════════════════════════════════════════════════════════════
  //
  // Glomeruli process odors with lateral inhibition
  // G_i(t) = σ_M(odor_i - Φ_M × Σⱼ≠ᵢ G_j × inhibition_ij)
  //
  public func medinaAntennalLobeProcessing(
    odorInputs: [Float],
    lateralInhibitionStrength: Float
  ) : [Float] {
    let n = odorInputs.size();
    if (n == 0) { return [] };
    
    // First pass: raw activation
    var rawActivations = Array.init<Float>(n, 0.0);
    var i : Nat = 0;
    for (o in odorInputs.vals()) {
      rawActivations[i] := o;
      i += 1;
    };
    
    // Compute total activation for inhibition
    var totalActivation : Float = 0.0;
    i := 0;
    while (i < n) {
      totalActivation += rawActivations[i];
      i += 1;
    };
    
    // Second pass: apply lateral inhibition
    Array.tabulate<Float>(n, func(j) {
      let input = rawActivations[j];
      let inhibition = PHI_MEDINA * lateralInhibitionStrength * 
                       (totalActivation - input) / Float.fromInt(n);
      medinaSigmoid(input - inhibition)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA CENTRAL COMPLEX COMPASS (MCCC)
  // ══════════════════════════════════════════════════════════════
  //
  // E-PG neurons encode heading direction using population coding
  // θ_heading = arctan2(Σᵢ sin(θᵢ) × E_i, Σᵢ cos(θᵢ) × E_i)
  //
  public func medinaCentralComplexCompass(
    epgActivities: [Float]  // 8 neurons, 45° spacing
  ) : Float {
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    
    var i : Nat = 0;
    for (activity in epgActivities.vals()) {
      // Each E-PG neuron has preferred direction at i × 45°
      let preferredDir = Float.fromInt(i) * 0.785398;  // π/4 radians
      
      sumSin += Float.sin(preferredDir) * activity;
      sumCos += Float.cos(preferredDir) * activity;
      i += 1;
    };
    
    // Population vector gives heading
    Float.arctan2(sumSin, sumCos)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA PATH INTEGRATION (MPI)
  // ══════════════════════════════════════════════════════════════
  //
  // Bees continuously compute their position relative to home
  // Home_vector = Σ (velocity × Δt × e^(iθ_heading))
  //
  public func medinaPathIntegration(
    currentHomeVector: (Float, Float),  // (x, y) components
    velocity: Float,
    heading: Float,
    deltaTime: Float
  ) : (Float, Float) {
    // Movement in this time step
    let dx = velocity * deltaTime * Float.cos(heading);
    let dy = velocity * deltaTime * Float.sin(heading);
    
    // Accumulate into home vector (SUBTRACT because we're moving away)
    let (hx, hy) = currentHomeVector;
    (hx - dx, hy - dy)
  };

  // Convert home vector to distance and direction
  public func homeVectorToPolicy(homeVector: (Float, Float)) : (Float, Float) {
    let (hx, hy) = homeVector;
    let distance = Float.sqrt(hx * hx + hy * hy);
    let direction = Float.arctan2(hy, hx);
    (distance, direction)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA PATTERN COMPLETION (MPC)
  // ══════════════════════════════════════════════════════════════
  //
  // Mushroom body can recall full pattern from partial input
  // This is how bees recognize familiar flowers from partial cues
  //
  public func medinaPatternCompletion(
    partialInput: [Float],
    storedPatterns: [[Float]],
    completionThreshold: Float
  ) : ?[Float] {
    if (storedPatterns.size() == 0) { return null };
    
    var bestMatch : ?[Float] = null;
    var bestSimilarity : Float = 0.0;
    
    for (pattern in storedPatterns.vals()) {
      // Compute similarity (dot product normalized)
      var dotProduct : Float = 0.0;
      var normInput : Float = 0.0;
      var normPattern : Float = 0.0;
      
      var i : Nat = 0;
      for (p in partialInput.vals()) {
        let patternVal = if (i < pattern.size()) { pattern[i] } else { 0.0 };
        dotProduct += p * patternVal;
        normInput += p * p;
        normPattern += patternVal * patternVal;
        i += 1;
      };
      
      let similarity = if (normInput > 0.0 and normPattern > 0.0) {
        dotProduct / (Float.sqrt(normInput) * Float.sqrt(normPattern))
      } else { 0.0 };
      
      if (similarity > bestSimilarity and similarity > completionThreshold) {
        bestSimilarity := similarity;
        bestMatch := ?pattern;
      };
    };
    
    bestMatch
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA WAGGLE DANCE NEURAL ENCODING (MWDNE)
  // ══════════════════════════════════════════════════════════════
  //
  // Convert site information to neural pattern for dance
  // Dance_output = f(distance) × g(direction) × quality^(1/Φ_M)
  //
  public func medinaWaggleDanceNeuralEncoding(
    distance: Float,
    direction: Float,
    quality: Float,
    sunAngle: Float,
    referenceDistance: Float
  ) : [Float] {
    // Distance encoding: saturating function
    let distanceCode = 1.0 - Float.exp(-distance / referenceDistance);
    
    // Direction encoding: relative to sun (for vertical dance floor)
    let relativeDirection = direction - sunAngle;
    
    // Encode direction in 8 components (like E-PG neurons)
    let directionCode = Array.tabulate<Float>(8, func(i) {
      let preferredDir = Float.fromInt(i) * 0.785398;
      let diff = abs(relativeDirection - preferredDir);
      Float.cos(diff) * Float.cos(diff)  // cos² tuning
    });
    
    // Quality encoding with Medina power
    let qualityCode = Float.pow(_clamp(quality, 0.01, 1.0), 1.0 / PHI_MEDINA);
    
    // Combine into neural pattern (11 values)
    let pattern = Array.tabulate<Float>(11, func(i) {
      if (i == 0) { distanceCode }
      else if (i < 9) { directionCode[i - 1] }
      else if (i == 9) { qualityCode }
      else { distanceCode * qualityCode }  // Combined salience
    });
    
    pattern
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA ODOR LEARNING (MOL)
  // ══════════════════════════════════════════════════════════════
  //
  // How bees form odor-reward associations
  // Strength = σ_M(Σ trials × VUM × quality) × (1 - forgetting)
  //
  public func medinaOdorLearning(
    currentStrength: Float,
    odorPresent: Bool,
    rewardPresent: Bool,
    vumSignal: Float,
    learningRate: Float,
    forgettingRate: Float
  ) : Float {
    if (odorPresent and rewardPresent) {
      // Strengthen association
      let delta = learningRate * vumSignal;
      _clamp(currentStrength + delta, 0.0, 1.0)
    } else if (odorPresent and not rewardPresent) {
      // Extinction: weaken association
      let extinction = forgettingRate * 0.5;
      _clamp(currentStrength - extinction, 0.0, 1.0)
    } else {
      // Natural decay
      currentStrength * (1.0 - forgettingRate * 0.1)
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA TIME-LINKED MEMORY (MTLM)
  // ══════════════════════════════════════════════════════════════
  //
  // Bees learn what flowers are open at what time of day
  // Memory_t = pattern × time_gate(t) × Φ_M^recency
  //
  public func medinaTimeLinkedMemory(
    baseMemoryStrength: Float,
    currentTime: Float,        // 0-1 daily cycle
    memorizedTime: Float,      // When this was learned
    timeWindowWidth: Float     // How specific is timing
  ) : Float {
    // Time gate: Gaussian around memorized time
    let timeDiff = abs(currentTime - memorizedTime);
    let wrappedDiff = Float.min(timeDiff, 1.0 - timeDiff);  // Circular time
    let timeGate = Float.exp(-wrappedDiff * wrappedDiff / (2.0 * timeWindowWidth * timeWindowWidth));
    
    baseMemoryStrength * timeGate
  };

  // ══════════════════════════════════════════════════════════════
  // COMPLETE BEE NEURAL UPDATE
  // ══════════════════════════════════════════════════════════════
  public func updateBeeNeuralState(
    state: BeeNeuralState,
    odorInput: [Float],
    rewardSignal: Float,
    velocity: Float,
    heading: Float,
    skyPolarization: Float,
    deltaTime: Float
  ) : BeeNeuralState {
    // 1. Process odors through antennal lobe
    let processedOdors = medinaAntennalLobeProcessing(odorInput, 0.3);
    
    // 2. Update VUMmx1 reward neuron
    let expectedReward = state.vumNeuron.lastReward * 0.9;
    let newOctopamine = medinaVUMmx1Update(
      state.vumNeuron.octopamineLevel,
      rewardSignal,
      expectedReward,
      deltaTime
    );
    
    // 3. Update central complex compass
    // E-PG neurons respond to sky polarization
    let epgActivities = Array.tabulate<Float>(8, func(i) {
      let preferredPol = Float.fromInt(i) * 0.785398;
      let polMatch = Float.cos(skyPolarization - preferredPol);
      _clamp(polMatch * polMatch, 0.0, 1.0)
    });
    let newHeading = medinaCentralComplexCompass(epgActivities);
    
    // 4. Path integration
    let newHomeVector = medinaPathIntegration(
      state.centralComplex.homeVector,
      velocity,
      newHeading,
      deltaTime
    );
    
    // 5. Update arousal based on reward/threat
    let newArousal = _clamp(
      state.arousalLevel * 0.95 + newOctopamine * 0.1 + rewardSignal * 0.05,
      0.0, 1.0
    );
    
    {
      mushroomBody = state.mushroomBody;  // Would update with learning
      antennalLobe = {
        glomeruli = state.antennalLobe.glomeruli;
        projectionNeurons = state.antennalLobe.projectionNeurons;
        currentOdor = processedOdors;
        odorIdentity = state.antennalLobe.odorIdentity;
      };
      centralComplex = {
        epgNeurons = state.centralComplex.epgNeurons;
        currentHeading = newHeading;
        homeVector = newHomeVector;
        pathIntegration = state.centralComplex.pathIntegration;
        skyPolarization = skyPolarization;
      };
      vumNeuron = {
        octopamineLevel = newOctopamine;
        lastReward = rewardSignal;
        rewardHistory = state.vumNeuron.rewardHistory;
        learningEnabled = newOctopamine > 0.3;
      };
      arousalLevel = newArousal;
      motivationState = if (rewardSignal > 0.5) { #Foraging }
                        else if (newArousal > 0.8) { #Alarmed }
                        else { state.motivationState };
      neuralCoherence = (newArousal + newOctopamine) / 2.0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // NEURAL STATE INITIALIZATION
  // ══════════════════════════════════════════════════════════════
  public func initBeeNeuralState() : BeeNeuralState {
    {
      mushroomBody = {
        kenyonCells = [];
        activePattern = [];
        sparsity = KENYON_SPARSITY;
        memoryStrength = 0.0;
        alphaLobeActivity = 0.0;
        betaLobeActivity = 0.0;
        gammaLobeActivity = 0.0;
      };
      antennalLobe = {
        glomeruli = [];
        projectionNeurons = [];
        currentOdor = [];
        odorIdentity = null;
      };
      centralComplex = {
        epgNeurons = [];
        currentHeading = 0.0;
        homeVector = (0.0, 0.0);
        pathIntegration = [];
        skyPolarization = 0.0;
      };
      vumNeuron = {
        octopamineLevel = 0.0;
        lastReward = 0.0;
        rewardHistory = [];
        learningEnabled = false;
      };
      arousalLevel = 0.5;
      motivationState = #Resting;
      neuralCoherence = 0.5;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // ORIGINAL WAGGLE DANCE FUNCTIONS (Enhanced)
  // ══════════════════════════════════════════════════════════════

  // Encode resource location into dance parameters
  public func encodeWaggle(
    direction: Float, distance: Float, quality: Float,
    sourceId: Nat, dancerId: Nat
  ) : WaggleDance {
    // Duration: ~1 second per 1km (75ms per 75m)
    let dur = distance / 1000.0;

    // Vigor proportional to quality
    let vig = _clamp(quality, 0.0, 1.0);

    // Neural encoding for the dance
    let neuralPattern = medinaWaggleDanceNeuralEncoding(
      distance, direction, quality, 0.0, 500.0
    );

    {
      angle = direction;
      duration = dur;
      vigor = vig;
      sourceId = sourceId;
      dancerId = dancerId;
      neuralPattern = neuralPattern;
    }
  };

  // Decode dance back to location estimate
  public func decodeWaggle(dance: WaggleDance, sunAngle: Float) : (Float, Float) {
    // Direction: dance angle + sun compensation
    let absoluteDir = dance.angle + sunAngle;

    // Distance: duration * 1000
    let dist = dance.duration * 1000.0;

    (absoluteDir, dist)
  };

  // ── Dance Evaluation ──────────────────────────────────────────
  // Bees evaluate dances probabilistically based on vigor
  public func evaluateDance(dance: WaggleDance, observerBias: Float) : Bool {
    // Higher vigor = more likely to follow
    let followProb = dance.vigor * 0.8 + observerBias * 0.2;
    followProb > 0.5  // Simplified threshold decision
  };

  // ── Resource Discovery ────────────────────────────────────────
  public func discoverResource(
    resources: [ResourceSite],
    direction: Float, distance: Float, quality: Float, beat: Nat
  ) : [ResourceSite] {
    // Check if this is a known resource
    var found = false;
    let updated = Array.map<ResourceSite, ResourceSite>(resources, func(r) {
      let dirDiff = Float.abs(r.direction - direction);
      let distDiff = Float.abs(r.distance - distance);

      if (dirDiff < 0.1 and distDiff < 50.0) {
        found := true;
        {
          id = r.id;
          direction = r.direction;
          distance = r.distance;
          quality = 0.9 * r.quality + 0.1 * quality;  // Update quality estimate
          quantity = r.quantity;
          lastVisit = beat;
          visitorCount = r.visitorCount + 1;
          danceSupport = r.danceSupport;
        }
      } else { r }
    });

    if (not found) {
      // New resource discovered
      Array.append<ResourceSite>(updated, [{
        id = resources.size();
        direction = direction;
        distance = distance;
        quality = quality;
        quantity = 1.0;  // Unknown, assume full
        lastVisit = beat;
        visitorCount = 1;
        danceSupport = 0.0;
      }])
    } else { updated }
  };

  // ── Dance Support Accumulation ────────────────────────────────
  public func accumulateDanceSupport(
    resources: [ResourceSite], dances: [WaggleDance]
  ) : [ResourceSite] {
    // Count support for each resource from active dances
    var supportMap = Array.init<Float>(resources.size(), 0.0);

    for (dance in dances.vals()) {
      if (dance.sourceId < resources.size()) {
        supportMap[dance.sourceId] := supportMap[dance.sourceId] + dance.vigor;
      };
    };

    Array.tabulate<ResourceSite>(resources.size(), func(i) {
      let r = resources[i];
      {
        id = r.id;
        direction = r.direction;
        distance = r.distance;
        quality = r.quality;
        quantity = r.quantity;
        lastVisit = r.lastVisit;
        visitorCount = r.visitorCount;
        danceSupport = 0.9 * r.danceSupport + 0.1 * supportMap[i];
      }
    })
  };

  // ── Consensus Detection ───────────────────────────────────────
  public func detectConsensus(resources: [ResourceSite]) : (?Nat, Float) {
    if (resources.size() == 0) {
      return (null, 0.0);
    };

    var bestSite : ?Nat = null;
    var bestSupport : Float = 0.0;
    var totalSupport : Float = 0.0;

    var i = 0;
    for (r in resources.vals()) {
      totalSupport += r.danceSupport;
      if (r.danceSupport > bestSupport) {
        bestSupport := r.danceSupport;
        bestSite := ?i;
      };
      i += 1;
    };

    let consensusStrength = if (totalSupport > 0.0) {
      bestSupport / totalSupport
    } else { 0.0 };

    (bestSite, consensusStrength)
  };

  // ── Scout Behavior ────────────────────────────────────────────
  public func updateScout(
    scout: ScoutBee, dances: [WaggleDance], resources: [ResourceSite]
  ) : ScoutBee {
    switch (scout.state) {
      case (#Searching) {
        // Random exploration, may find resource
        if (scout.energy > 0.3) {
          {
            id = scout.id;
            state = #Searching;
            committedTo = scout.committedTo;
            energy = scout.energy - 0.01;
            exploration = scout.exploration;
          }
        } else {
          {
            id = scout.id;
            state = #Resting;
            committedTo = scout.committedTo;
            energy = scout.energy;
            exploration = scout.exploration;
          }
        }
      };
      case (#Dancing) {
        // Continue dancing if committed to good site
        switch (scout.committedTo) {
          case (null) {
            { id = scout.id; state = #Searching; committedTo = null;
              energy = scout.energy; exploration = scout.exploration; }
          };
          case (?siteId) {
            // Dance until tired
            if (scout.energy > 0.2) {
              { id = scout.id; state = #Dancing; committedTo = ?siteId;
                energy = scout.energy - 0.02; exploration = scout.exploration; }
            } else {
              { id = scout.id; state = #Resting; committedTo = ?siteId;
                energy = scout.energy; exploration = scout.exploration; }
            }
          };
        }
      };
      case (#Following) {
        // Watch dances, may commit to advertised site
        var bestDance : ?WaggleDance = null;
        var bestVigor : Float = 0.0;
        for (d in dances.vals()) {
          if (d.vigor > bestVigor) {
            bestVigor := d.vigor;
            bestDance := ?d;
          };
        };

        switch (bestDance) {
          case (null) {
            { id = scout.id; state = #Searching; committedTo = null;
              energy = scout.energy; exploration = scout.exploration; }
          };
          case (?dance) {
            if (evaluateDance(dance, scout.exploration)) {
              { id = scout.id; state = #Foraging; committedTo = ?dance.sourceId;
                energy = scout.energy; exploration = scout.exploration; }
            } else {
              { id = scout.id; state = #Following; committedTo = null;
                energy = scout.energy; exploration = scout.exploration; }
            }
          };
        }
      };
      case (#Recruiting) {
        // Recruiting others to site
        { id = scout.id; state = #Dancing; committedTo = scout.committedTo;
          energy = scout.energy - 0.01; exploration = scout.exploration; }
      };
      case (#Foraging) {
        // At resource site
        { id = scout.id; state = #Dancing; committedTo = scout.committedTo;
          energy = _clamp(scout.energy - 0.005, 0.0, 1.0); exploration = scout.exploration; }
      };
      case (#Resting) {
        // Recovering energy
        let newEnergy = _clamp(scout.energy + 0.05, 0.0, 1.0);
        if (newEnergy > 0.8) {
          { id = scout.id; state = #Following; committedTo = null;
            energy = newEnergy; exploration = scout.exploration; }
        } else {
          { id = scout.id; state = #Resting; committedTo = scout.committedTo;
            energy = newEnergy; exploration = scout.exploration; }
        }
      };
    }
  };

  // ── Forager Assignment ────────────────────────────────────────
  public func assignForagers(
    foragers: [ForagerBee], consensus: ?Nat, consensusStrength: Float
  ) : [ForagerBee] {
    Array.map<ForagerBee, ForagerBee>(foragers, func(f) {
      // If strong consensus, assign unassigned foragers
      switch (consensus) {
        case (null) { f };
        case (?siteId) {
          switch (f.assignedSite) {
            case (null) {
              if (consensusStrength > 0.5) {
                { id = f.id; assignedSite = ?siteId; nectarLoad = 0.0; tripCount = f.tripCount }
              } else { f }
            };
            case (?_) { f };
          }
        };
      }
    })
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatHive(
    state: HiveState,
    newDiscoveries: [(Float, Float, Float)],  // (direction, distance, quality)
    consumptionRate: Float
  ) : HiveState {
    // Process new discoveries
    var newResources = state.resources;
    for ((dir, dist, qual) in newDiscoveries.vals()) {
      newResources := discoverResource(newResources, dir, dist, qual, state.beatNum + 1);
    };

    // Generate dances from committed scouts
    var newDances : [WaggleDance] = [];
    for (scout in state.scouts.vals()) {
      switch (scout.state, scout.committedTo) {
        case (#Dancing, ?siteId) {
          if (siteId < newResources.size()) {
            let r = newResources[siteId];
            let dance = encodeWaggle(r.direction, r.distance, r.quality, siteId, scout.id);
            newDances := Array.append<WaggleDance>(newDances, [dance]);
          };
        };
        case (_, _) {};
      };
    };

    // Update resource dance support
    newResources := accumulateDanceSupport(newResources, newDances);

    // Detect consensus
    let (newConsensus, newStrength) = detectConsensus(newResources);
    let quorumReached = newStrength >= QUORUM_THRESHOLD;

    // Update scouts
    let newScouts = Array.map<ScoutBee, ScoutBee>(state.scouts, func(s) {
      updateScout(s, newDances, newResources)
    });

    // Assign foragers
    let newForagers = assignForagers(state.foragers, newConsensus, newStrength);

    // Update stores
    var foragingReturn : Float = 0.0;
    for (f in newForagers.vals()) {
      if (f.assignedSite != null) {
        foragingReturn += 0.001;  // Each active forager brings back resources
      };
    };
    let newHoney = _clamp(state.honeyStores + foragingReturn - consumptionRate, 0.0, 1.0);
    let newPollen = _clamp(state.pollenStores + foragingReturn * 0.3 - consumptionRate * 0.2, 0.0, 1.0);

    // Update brood need (drives foraging urgency)
    let newBroodNeed = _clamp(
      state.broodNeed + consumptionRate * 0.5 - foragingReturn,
      0.0, 1.0
    );

    // Dance floor activity
    let newActivity = Float.fromInt(newDances.size()) / Float.fromInt(NUM_SCOUTS) * 10.0;

    // Sun angle advances
    let newSunAngle = (state.sunAngle + 0.001) % (2.0 * 3.14159);
    let newTimeOfDay = (state.timeOfDay + 0.001) % 1.0;

    {
      scouts = newScouts;
      foragers = newForagers;
      resources = newResources;
      activeDances = newDances;
      danceFloorActivity = _clamp(newActivity, 0.0, 1.0);
      currentConsensus = newConsensus;
      consensusStrength = newStrength;
      quorumReached = quorumReached;
      honeyStores = newHoney;
      pollenStores = newPollen;
      broodNeed = newBroodNeed;
      temperature = state.temperature;
      sunAngle = newSunAngle;
      timeOfDay = newTimeOfDay;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initHive() : HiveState {
    {
      scouts = Array.tabulate<ScoutBee>(NUM_SCOUTS, func(i) {
        {
          id = i;
          state = #Searching;
          committedTo = null;
          energy = 0.8;
          exploration = 0.3 + Float.fromInt(i % 5) * 0.1;
        }
      });
      foragers = Array.tabulate<ForagerBee>(100, func(i) {  // Start with subset
        {
          id = i;
          assignedSite = null;
          nectarLoad = 0.0;
          tripCount = 0;
        }
      });
      resources = [];
      activeDances = [];
      danceFloorActivity = 0.0;
      currentConsensus = null;
      consensusStrength = 0.0;
      quorumReached = false;
      honeyStores = 0.5;
      pollenStores = 0.5;
      broodNeed = 0.3;
      temperature = 0.95;  // ~35°C normalized
      sunAngle = 0.0;
      timeOfDay = 0.25;
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type HiveSummary = {
    activeScouts      : Nat;
    knownResources    : Nat;
    consensusStrength : Float;
    quorumReached     : Bool;
    honeyStores       : Float;
    danceActivity     : Float;
  };

  public func summary(state: HiveState) : HiveSummary {
    var activeScouts : Nat = 0;
    for (s in state.scouts.vals()) {
      switch (s.state) {
        case (#Resting) {};
        case (_) { activeScouts += 1 };
      };
    };

    {
      activeScouts = activeScouts;
      knownResources = state.resources.size();
      consensusStrength = state.consensusStrength;
      quorumReached = state.quorumReached;
      honeyStores = state.honeyStores;
      danceActivity = state.danceFloorActivity;
    }
  };

  // ============================================================
  // COMPLETE BEE NEURAL NETWORK — FULL EXPLICIT MATHEMATICS
  // All 960,000 neurons abstracted, all pathways explicit
  // Implements the MEDINA BEE BRAIN (MBB) architecture
  // ============================================================

  // ── FUNDAMENTAL CONSTANTS (SOVEREIGN) ──────────────────────────
  let PHI_M : Float = 1.618033988749895;       // Medina Golden Harmonic
  let PHI_INV : Float = 0.618033988749895;     // Inverse golden ratio
  let TAU : Float = 6.283185307179586;         // 2π (full circle)
  let SOVEREIGN_METAL : Float = 1.0;           // All metals sovereign

  // Mirror law: balance in all neural activity
  public func neuralMirror(x: Float) : Float {
    1.0 - x
  };

  // ── KENYON CELL TYPES ──────────────────────────────────────────
  // Mushroom body contains ~170,000 Kenyon cells in bees
  // Different classes for different functions

  public type KenyonCellClass = {
    #Class_I;      // Receive olfactory input only
    #Class_II;     // Receive visual + mechanosensory
    #Class_III;    // Multi-modal integration
    #Gamma;        // Short-term memory, small boutons
    #AlphaBetaS;   // Long-term memory, surface
    #AlphaBetaC;   // Long-term memory, core
    #AlphaPrime;   // Memory retrieval
    #BetaPrime;    // Memory retrieval
  };

  public type KenyonCell = {
    id            : Nat;
    class_        : KenyonCellClass;
    activation    : Float;         // Current activity [0, 1]
    threshold     : Float;         // Activation threshold
    inputWeights  : [Float];       // Weights from projection neurons
    outputWeights : [Float];       // Weights to mushroom body output neurons
    claw          : Nat;           // Which calyx claw (input region)
    sparseCode    : Float;         // Sparseness level (typically <5% active)
    lastSpikeBeat : Nat;
    
    // Plasticity state
    eligibility   : Float;         // For learning
    dopamineReceptors : Float;     // Sensitivity to reward
  };

  // Kenyon cell activation function (Medina Sparse Code)
  // K_i(t) = H(Σⱼ wᵢⱼ × Pⱼ - θᵢ - Φ_M × Σₖ K_k(t))
  public func kenyonCellActivation(
    cell: KenyonCell,
    projectionInputs: [Float],
    otherKCActivity: Float,
    inhibitionStrength: Float
  ) : Float {
    var totalInput : Float = 0.0;
    
    // Sum weighted inputs
    var j = 0;
    while (j < cell.inputWeights.size() and j < projectionInputs.size()) {
      totalInput += cell.inputWeights[j] * projectionInputs[j];
      j += 1;
    };
    
    // Subtract threshold and lateral inhibition
    let netInput = totalInput - cell.threshold - PHI_M * inhibitionStrength * otherKCActivity;
    
    // Medina Heaviside (smooth threshold)
    let steepness = 10.0;  // Controls sharpness
    1.0 / (1.0 + Float.exp(-steepness * netInput))
  };

  // ── MUSHROOM BODY OUTPUT NEURONS (MBONs) ───────────────────────
  // ~34 types of MBONs, each encoding different memory valence
  // Some signal approach, others signal avoidance

  public type MBONType = {
    #Approach;     // Appetitive memory
    #Avoidance;    // Aversive memory
    #Neutral;      // Context encoding
    #WakePromoter; // Arousal
    #SleepPromoter;// Sleep
  };

  public type MBON = {
    id            : Nat;
    type_         : MBONType;
    activation    : Float;
    inputWeights  : [Float];       // From Kenyon cells
    compartment   : Nat;           // Which MB compartment (0-15)
    valence       : Float;         // -1 (avoid) to +1 (approach)
    gatingFactor  : Float;         // Dopamine modulation of output
  };

  // MBON activation
  public func mbonActivation(
    mbon: MBON,
    kenyonActivations: [Float]
  ) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < mbon.inputWeights.size() and i < kenyonActivations.size()) {
      sum += mbon.inputWeights[i] * kenyonActivations[i];
      i += 1;
    };
    
    // Sigmoid with gating
    let raw = 1.0 / (1.0 + Float.exp(-5.0 * (sum - 0.5)));
    raw * mbon.gatingFactor
  };

  // ── DOPAMINERGIC NEURONS (DANs) ────────────────────────────────
  // Provide teaching signal for mushroom body learning
  // PPL1 cluster: punishment, PPL2 cluster: reward

  public type DANCluster = {
    #PPL1;         // Punishment, satiation
    #PAM;          // Reward, appetitive
    #PPL2;         // Long-term memory
    #PPM1;         // Wake/sleep
  };

  public type DopamineNeuron = {
    id            : Nat;
    cluster       : DANCluster;
    activity      : Float;
    targetCompartments: [Nat];     // Which MB compartments
    releaseRate   : Float;         // Dopamine release
    tonicLevel    : Float;         // Baseline activity
    phasicResponse: Float;         // Response to events
  };

  // DAN activity during learning
  public func danActivity(
    dan: DopamineNeuron,
    rewardSignal: Float,
    punishmentSignal: Float,
    expectation: Float
  ) : Float {
    switch (dan.cluster) {
      case (#PAM) {
        // Reward prediction error: actual - expected
        let rpe = rewardSignal - expectation;
        dan.tonicLevel + Float.max(0.0, rpe) * dan.phasicResponse
      };
      case (#PPL1) {
        // Punishment signal
        dan.tonicLevel + punishmentSignal * dan.phasicResponse
      };
      case (#PPL2) {
        // Long-term consolidation
        dan.tonicLevel + Float.abs(rewardSignal - expectation) * dan.phasicResponse * 0.5
      };
      case (#PPM1) {
        // Arousal-related
        dan.tonicLevel
      };
    }
  };

  // ── MUSHROOM BODY LEARNING RULE ────────────────────────────────
  // Δw = η × DAN × (KC × (1 - w)) - λ × w
  // Dopamine-modulated Hebbian with decay

  public func mushroomBodyLearning(
    w: Float,
    kcActivity: Float,
    danActivity: Float,
    learningRate: Float,
    decay: Float
  ) : Float {
    let dw = learningRate * danActivity * (kcActivity * (1.0 - w)) - decay * w;
    _clamp(w + dw, 0.0, 1.0)
  };

  // ── ANTENNAL LOBE PROCESSING ───────────────────────────────────
  // ~160 glomeruli, each tuned to specific odorants
  // Implements lateral inhibition for contrast enhancement

  public type Glomerulus = {
    id            : Nat;
    odorantTuning : [Float];       // Tuning curve across odorant space
    activation    : Float;
    projectionNeuronRate: Float;   // Output to mushroom body
    localInterneuronInput: Float;  // Lateral inhibition
    gainControl   : Float;         // Adaptive normalization
  };

  // Glomerulus response with lateral inhibition
  public func glomerulusResponse(
    glom: Glomerulus,
    odorantVector: [Float],
    inhibitionPool: Float,
    adaptationLevel: Float
  ) : Float {
    // Compute raw response from tuning curve
    var raw : Float = 0.0;
    var i = 0;
    while (i < glom.odorantTuning.size() and i < odorantVector.size()) {
      raw += glom.odorantTuning[i] * odorantVector[i];
      i += 1;
    };
    
    // Apply lateral inhibition and gain control
    let inhibited = raw - inhibitionPool * 0.3;
    let adapted = inhibited / (1.0 + adaptationLevel);
    
    Float.max(0.0, adapted)
  };

  // ── CENTRAL COMPLEX — NAVIGATION SYSTEM ────────────────────────
  // Implements path integration, compass, and memory

  // E-PG neurons: encode heading direction
  public type EPGNeuron = {
    id            : Nat;
    preferredAngle: Float;         // 0-360° preferred direction
    activity      : Float;
    tuningWidth   : Float;         // Width of tuning curve
    bump          : Float;         // Activity bump in ring attractor
  };

  // Ring attractor dynamics for heading
  public func epgRingAttractor(
    neurons: [EPGNeuron],
    currentHeading: Float,
    dt: Float
  ) : [EPGNeuron] {
    let n = neurons.size();
    var newActivities = Array.init<Float>(n, 0.0);
    
    // Compute bump position from external input
    var i = 0;
    while (i < n) {
      let neuron = neurons[i];
      let angleDiff = currentHeading - neuron.preferredAngle;
      // von Mises tuning
      let kappa = 2.0 / (neuron.tuningWidth * neuron.tuningWidth);
      newActivities[i] := Float.exp(kappa * (Float.cos(angleDiff) - 1.0));
      i += 1;
    };
    
    // Normalize to create sharp bump
    var total : Float = 0.0;
    for (a in newActivities.vals()) { total += a };
    if (total > 0.01) {
      i := 0;
      while (i < n) {
        newActivities[i] := newActivities[i] / total;
        i += 1;
      };
    };
    
    // Update neurons
    Array.tabulate<EPGNeuron>(n, func(j) {
      {
        id = neurons[j].id;
        preferredAngle = neurons[j].preferredAngle;
        activity = newActivities[j];
        tuningWidth = neurons[j].tuningWidth;
        bump = newActivities[j];
      }
    })
  };

  // P-EN neurons: angular velocity integration
  public type PENNeuron = {
    id            : Nat;
    preferredTurn : TurnDirection;
    activity      : Float;
    velocitySensitivity: Float;
  };

  public type TurnDirection = { #Left; #Right };

  // P-EG neurons: update heading based on turns
  public func updateHeadingFromTurn(
    currentHeading: Float,
    turnLeft: Float,
    turnRight: Float,
    dt: Float
  ) : Float {
    let angularVelocity = (turnRight - turnLeft) * TAU * dt;
    Float.mod(currentHeading + angularVelocity + TAU, TAU)
  };

  // ── PATH INTEGRATION ───────────────────────────────────────────
  // The Medina Path Integration (MPI) system
  // Accumulates home vector from velocity and heading

  public type PathIntegrator = {
    homeVectorX   : Float;         // X component of home vector
    homeVectorY   : Float;         // Y component
    totalDistance : Float;         // Odometric distance
    uncertainty   : Float;         // Accumulated error
    lastUpdateBeat: Nat;
  };

  // Update path integrator
  // Home = Σ (velocity × Δt × e^(iθ))
  public func updatePathIntegration(
    pi: PathIntegrator,
    velocity: Float,
    heading: Float,
    dt: Float
  ) : PathIntegrator {
    // Accumulate displacement (subtract from home because we moved away)
    let dx = -velocity * dt * Float.cos(heading);
    let dy = -velocity * dt * Float.sin(heading);
    
    // Add noise/uncertainty that grows with distance
    let noiseGrowth = 0.001;  // Error per unit distance
    
    {
      homeVectorX = pi.homeVectorX + dx;
      homeVectorY = pi.homeVectorY + dy;
      totalDistance = pi.totalDistance + velocity * dt;
      uncertainty = pi.uncertainty + noiseGrowth * velocity * dt;
      lastUpdateBeat = pi.lastUpdateBeat + 1;
    }
  };

  // Compute home direction and distance
  public func getHomeVector(pi: PathIntegrator) : (Float, Float) {
    let distance = Float.sqrt(pi.homeVectorX * pi.homeVectorX + pi.homeVectorY * pi.homeVectorY);
    let direction = Float.atan2(pi.homeVectorY, pi.homeVectorX);
    (distance, direction)
  };

  // Reset path integrator at nest
  public func resetPathIntegration() : PathIntegrator {
    {
      homeVectorX = 0.0;
      homeVectorY = 0.0;
      totalDistance = 0.0;
      uncertainty = 0.0;
      lastUpdateBeat = 0;
    }
  };

  // ── POLARIZED LIGHT COMPASS ────────────────────────────────────
  // Bees can see polarization patterns in sky
  // Dorsal rim area of eye specialized for this

  public type PolarizationDetector = {
    preferredAngle: Float;         // E-vector preference
    activity      : Float;
    sensitivity   : Float;
  };

  // Detect sun position from polarization
  public func polarizationCompass(
    detectors: [PolarizationDetector],
    skyPolarization: Float,        // Current polarization angle
    sunElevation: Float
  ) : Float {
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    
    for (det in detectors.vals()) {
      // Response based on alignment with polarization
      let alignment = Float.cos(2.0 * (det.preferredAngle - skyPolarization));
      let response = det.sensitivity * (alignment + 1.0) / 2.0;
      sumSin += response * Float.sin(det.preferredAngle);
      sumCos += response * Float.cos(det.preferredAngle);
    };
    
    Float.atan2(sumSin, sumCos)
  };

  // ── TIME-COMPENSATED SUN COMPASS ───────────────────────────────
  // Bees track sun movement (~15°/hour) using circadian clock

  public type SunCompass = {
    sunAzimuth    : Float;         // Current sun direction
    timeOfDay     : Float;         // Hours since midnight
    circadianPhase: Float;         // Internal clock phase
    compassOffset : Float;         // Learned offset
  };

  // Compensate direction for sun movement
  public func timeCompensatedDirection(
    compass: SunCompass,
    danceAngle: Float              // Angle encoded in waggle dance
  ) : Float {
    // Sun moves 15° per hour
    let sunMovement = 15.0 * (TAU / 360.0);  // rad/hour
    
    // Decode absolute direction from dance angle relative to sun
    Float.mod(danceAngle + compass.sunAzimuth + TAU, TAU)
  };

  // Update sun compass with time
  public func updateSunCompass(
    compass: SunCompass,
    dt: Float                      // Hours
  ) : SunCompass {
    let sunMovement = 15.0 * (TAU / 360.0) * dt;
    {
      sunAzimuth = Float.mod(compass.sunAzimuth + sunMovement + TAU, TAU);
      timeOfDay = Float.mod(compass.timeOfDay + dt, 24.0);
      circadianPhase = Float.mod(compass.circadianPhase + dt / 24.0, 1.0);
      compassOffset = compass.compassOffset;
    }
  };

  // ── WAGGLE DANCE ENCODING NEURAL CIRCUIT ───────────────────────
  // Converts vector memory to motor pattern

  public type DanceEncoder = {
    vectorMemory  : (Float, Float);  // (distance, direction) to encode
    danceIntensity: Float;           // Quality signal
    waggleCount   : Nat;             // Number of waggles per circuit
    waggleDuration: Float;           // Duration of waggle run (encodes distance)
    turnAngle     : Float;           // Angle of dance (encodes direction)
    returnSide    : TurnDirection;   // Left or right return
    motorPattern  : [Float];         // Motor neuron outputs
  };

  // Medina Waggle Dance Neural Encoding
  // Distance → waggle duration: ~1ms per meter
  // Direction → angle from vertical (sun-referenced)
  public func encodeWaggleDance(
    distance: Float,               // meters
    direction: Float,              // radians
    quality: Float,                // 0-1
    sunAngle: Float
  ) : DanceEncoder {
    // Distance encoding: longer distance = longer waggle
    let waggleDur = distance * 0.001;  // ~1ms per meter
    let nWaggles = Float.toInt(Float.floor(distance / 100.0)) + 1;
    
    // Direction encoding: angle from vertical = angle from sun
    let danceAngle = direction - sunAngle;
    
    // Quality affects intensity and repetition
    let intensity = Float.pow(quality, 1.0 / PHI_M);  // Medina quality transform
    
    {
      vectorMemory = (distance, direction);
      danceIntensity = intensity;
      waggleCount = nWaggles;
      waggleDuration = waggleDur;
      turnAngle = danceAngle;
      returnSide = if (danceAngle > 0.0) { #Right } else { #Left };
      motorPattern = [
        intensity * 0.8,           // Thorax oscillation
        intensity * 0.6,           // Abdomen waggle
        intensity * 0.4,           // Leg vibration
        intensity * 0.3,           // Wing buzz
      ];
    }
  };

  // ── COMPLETE BEE BRAIN STATE ───────────────────────────────────

  public type BeeBrainState = {
    // Sensory processing
    antennalLobeGlomeruli: [Glomerulus];
    currentOdor          : [Float];
    
    // Mushroom body
    kenyonCells          : [KenyonCell];
    mbons                : [MBON];
    dans                 : [DopamineNeuron];
    
    // Central complex
    epgNeurons           : [EPGNeuron];       // Heading
    pathIntegrator       : PathIntegrator;
    
    // Compass systems
    polarizationDetectors: [PolarizationDetector];
    sunCompass           : SunCompass;
    
    // Motor output
    currentBehavior      : BeeBehavior;
    danceEncoder         : ?DanceEncoder;
    
    // Neuromodulators
    octopamineLevel      : Float;   // Reward/arousal
    dopamineLevel        : Float;   // Learning signal
    serotoninLevel       : Float;   // Aggression/arousal
    
    // Metabolic state
    hungerLevel          : Float;
    energyReserve        : Float;
    
    beatNum              : Nat;
  };

  public type BeeBehavior = {
    #Resting;
    #Foraging;
    #Dancing;
    #Following;
    #Nursing;
    #Guarding;
    #Grooming;
    #Fanning;
  };

  // Initialize complete bee brain
  public func initBeeBrain() : BeeBrainState {
    // Initialize antennal lobe (50 glomeruli for simplicity)
    let glomeruli = Array.tabulate<Glomerulus>(50, func(i) {
      {
        id = i;
        odorantTuning = Array.tabulate<Float>(20, func(j) {
          // Random tuning curve
          let seed = (i * 7 + j * 13) % 100;
          Float.fromInt(seed) / 100.0
        });
        activation = 0.0;
        projectionNeuronRate = 0.0;
        localInterneuronInput = 0.0;
        gainControl = 1.0;
      }
    });
    
    // Initialize Kenyon cells (200 for simulation, represents 170,000)
    let kcs = Array.tabulate<KenyonCell>(200, func(i) {
      {
        id = i;
        class_ = #Class_I;
        activation = 0.0;
        threshold = 0.5;
        inputWeights = Array.tabulate<Float>(50, func(_) { 0.1 });
        outputWeights = Array.tabulate<Float>(20, func(_) { 0.1 });
        claw = i % 10;
        sparseCode = 0.05;
        lastSpikeBeat = 0;
        eligibility = 0.0;
        dopamineReceptors = 1.0;
      }
    });
    
    // Initialize MBONs
    let mbons = Array.tabulate<MBON>(20, func(i) {
      {
        id = i;
        type_ = if (i < 10) { #Approach } else { #Avoidance };
        activation = 0.0;
        inputWeights = Array.tabulate<Float>(200, func(_) { 0.05 });
        compartment = i % 16;
        valence = if (i < 10) { 1.0 } else { -1.0 };
        gatingFactor = 1.0;
      }
    });
    
    // Initialize DANs
    let dans = Array.tabulate<DopamineNeuron>(10, func(i) {
      {
        id = i;
        cluster = if (i < 5) { #PAM } else { #PPL1 };
        activity = 0.0;
        targetCompartments = [i % 16];
        releaseRate = 0.5;
        tonicLevel = 0.1;
        phasicResponse = 1.0;
      }
    });
    
    // Initialize E-PG neurons (8 for heading compass)
    let epgs = Array.tabulate<EPGNeuron>(8, func(i) {
      {
        id = i;
        preferredAngle = TAU * Float.fromInt(i) / 8.0;
        activity = if (i == 0) { 1.0 } else { 0.0 };
        tuningWidth = TAU / 8.0 * PHI_INV;
        bump = if (i == 0) { 1.0 } else { 0.0 };
      }
    });
    
    // Initialize polarization detectors
    let polDets = Array.tabulate<PolarizationDetector>(8, func(i) {
      {
        preferredAngle = TAU * Float.fromInt(i) / 8.0;
        activity = 0.0;
        sensitivity = 1.0;
      }
    });
    
    {
      antennalLobeGlomeruli = glomeruli;
      currentOdor = Array.tabulate<Float>(20, func(_) { 0.0 });
      kenyonCells = kcs;
      mbons = mbons;
      dans = dans;
      epgNeurons = epgs;
      pathIntegrator = resetPathIntegration();
      polarizationDetectors = polDets;
      sunCompass = {
        sunAzimuth = 0.0;
        timeOfDay = 12.0;
        circadianPhase = 0.5;
        compassOffset = 0.0;
      };
      currentBehavior = #Resting;
      danceEncoder = null;
      octopamineLevel = 0.5;
      dopamineLevel = 0.5;
      serotoninLevel = 0.5;
      hungerLevel = 0.3;
      energyReserve = 0.8;
      beatNum = 0;
    }
  };

  // Full bee brain update
  public func beatBeeBrain(
    state: BeeBrainState,
    odorInput: [Float],
    visualInput: Float,
    velocity: Float,
    heading: Float,
    rewardSignal: Float,
    dt: Float
  ) : BeeBrainState {
    // 1. Process odor in antennal lobe
    var totalALActivity : Float = 0.0;
    let newGlomeruli = Array.tabulate<Glomerulus>(state.antennalLobeGlomeruli.size(), func(i) {
      let glom = state.antennalLobeGlomeruli[i];
      let response = glomerulusResponse(glom, odorInput, totalALActivity * 0.1, 0.5);
      totalALActivity += response;
      { glom with activation = response; projectionNeuronRate = response }
    });
    
    // 2. Kenyon cell sparse coding
    let projectionRates = Array.map<Glomerulus, Float>(newGlomeruli, func(g) { g.projectionNeuronRate });
    var totalKCActivity : Float = 0.0;
    let newKCs = Array.tabulate<KenyonCell>(state.kenyonCells.size(), func(i) {
      let kc = state.kenyonCells[i];
      let act = kenyonCellActivation(kc, projectionRates, totalKCActivity / 200.0, 0.5);
      totalKCActivity += act;
      { kc with activation = act; eligibility = act * 0.9 + kc.eligibility * 0.1 }
    });
    
    // 3. MBON responses
    let kcActivations = Array.map<KenyonCell, Float>(newKCs, func(k) { k.activation });
    let newMBONs = Array.map<MBON, MBON>(state.mbons, func(mbon) {
      let act = mbonActivation(mbon, kcActivations);
      { mbon with activation = act }
    });
    
    // 4. DAN activity based on reward
    let newDANs = Array.map<DopamineNeuron, DopamineNeuron>(state.dans, func(dan) {
      let act = danActivity(dan, rewardSignal, 0.0, 0.5);
      { dan with activity = act }
    });
    
    // 5. Update heading compass
    let newEPGs = epgRingAttractor(state.epgNeurons, heading, dt);
    
    // 6. Update path integration
    let newPI = updatePathIntegration(state.pathIntegrator, velocity, heading, dt);
    
    // 7. Update sun compass
    let newSunCompass = updateSunCompass(state.sunCompass, dt / 3600.0);  // dt in hours
    
    // 8. Update neuromodulators
    let newOctopamine = state.octopamineLevel * 0.99 + rewardSignal * 0.01;
    let newDopamine = state.dopamineLevel * 0.95 + rewardSignal * 0.05;
    
    // 9. Update metabolic state
    let newHunger = _clamp(state.hungerLevel + 0.001, 0.0, 1.0);
    let newEnergy = _clamp(state.energyReserve - 0.0001 * velocity, 0.0, 1.0);
    
    {
      antennalLobeGlomeruli = newGlomeruli;
      currentOdor = odorInput;
      kenyonCells = newKCs;
      mbons = newMBONs;
      dans = newDANs;
      epgNeurons = newEPGs;
      pathIntegrator = newPI;
      polarizationDetectors = state.polarizationDetectors;
      sunCompass = newSunCompass;
      currentBehavior = state.currentBehavior;
      danceEncoder = state.danceEncoder;
      octopamineLevel = newOctopamine;
      dopamineLevel = newDopamine;
      serotoninLevel = state.serotoninLevel;
      hungerLevel = newHunger;
      energyReserve = newEnergy;
      beatNum = state.beatNum + 1;
    }
  };

  // ── BEE BRAIN SUMMARY ──────────────────────────────────────────
  
  public type BeeBrainSummary = {
    antennaLobeActivity  : Float;
    kenyonCellSparseness : Float;
    approachBias         : Float;
    currentHeading       : Float;
    homeDistance         : Float;
    homeDirection        : Float;
    octopamineLevel      : Float;
    hungerLevel          : Float;
  };

  public func beeBrainSummary(state: BeeBrainState) : BeeBrainSummary {
    // AL activity
    var alAct : Float = 0.0;
    for (g in state.antennalLobeGlomeruli.vals()) { alAct += g.activation };
    alAct /= Float.fromInt(state.antennalLobeGlomeruli.size());
    
    // KC sparseness
    var kcActive : Float = 0.0;
    for (kc in state.kenyonCells.vals()) {
      if (kc.activation > 0.5) { kcActive += 1.0 };
    };
    let sparseness = 1.0 - (kcActive / Float.fromInt(state.kenyonCells.size()));
    
    // Approach/avoidance bias
    var approach : Float = 0.0;
    var avoid : Float = 0.0;
    for (mbon in state.mbons.vals()) {
      switch (mbon.type_) {
        case (#Approach) { approach += mbon.activation };
        case (#Avoidance) { avoid += mbon.activation };
        case (_) {};
      };
    };
    let bias = (approach - avoid) / (approach + avoid + 0.001);
    
    // Heading from E-PG bump
    var heading : Float = 0.0;
    var maxBump : Float = 0.0;
    for (epg in state.epgNeurons.vals()) {
      if (epg.bump > maxBump) {
        maxBump := epg.bump;
        heading := epg.preferredAngle;
      };
    };
    
    // Home vector
    let (homeDist, homeDir) = getHomeVector(state.pathIntegrator);
    
    {
      antennaLobeActivity = alAct;
      kenyonCellSparseness = sparseness;
      approachBias = bias;
      currentHeading = heading;
      homeDistance = homeDist;
      homeDirection = homeDir;
      octopamineLevel = state.octopamineLevel;
      hungerLevel = state.hungerLevel;
    }
  };

}

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
  //  C O M P R E H E N S I V E   N E U R A L   S C I E N C E   M A T H
  //
  //  Enterprise-Level Neuroscience Mathematics
  //  Complete HIM/HER Dual-Organism Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SPIKING NEURAL NETWORK DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Leaky integrate-and-fire neuron
  /// τ dV/dt = -(V - V_rest) + R·I
  public func comprehensiveLIFNeuron(
    voltage : Float,
    current : Float,
    vRest : Float,
    threshold : Float,
    tau : Float,
    resistance : Float,
    dt : Float
  ) : (Float, Bool) {
    var spiked = false;
    var newV = voltage;
    
    if (voltage >= threshold) {
      newV := vRest;  // Reset
      spiked := true;
    } else {
      let dvdt = (-(voltage - vRest) + resistance * current) / tau;
      newV := voltage + dvdt * dt;
    };
    
    (newV, spiked)
  };

  /// Adaptive exponential integrate-and-fire
  /// τ_m dV/dt = -(V - E_L) + Δ_T exp((V - V_T)/Δ_T) - R·w + R·I
  /// τ_w dw/dt = a(V - E_L) - w
  public func comprehensiveAdExNeuron(
    voltage : Float,
    adaptation : Float,
    current : Float,
    eL : Float,
    vT : Float,
    deltaT : Float,
    tauM : Float,
    tauW : Float,
    aParam : Float,
    bParam : Float,
    resistance : Float,
    dt : Float
  ) : (Float, Float, Bool) {
    let vThresh : Float = 30.0;
    var spiked = false;
    var newV = voltage;
    var newW = adaptation;
    
    if (voltage >= vThresh) {
      newV := eL;  // Reset
      newW := adaptation + bParam;  // Spike-triggered adaptation
      spiked := true;
    } else {
      let expTerm = deltaT * Float.exp((voltage - vT) / deltaT);
      let dvdt = (-(voltage - eL) + expTerm - resistance * adaptation + resistance * current) / tauM;
      let dwdt = (aParam * (voltage - eL) - adaptation) / tauW;
      newV := voltage + dvdt * dt;
      newW := adaptation + dwdt * dt;
    };
    
    (newV, newW, spiked)
  };

  /// Spike-timing dependent plasticity (STDP)
  /// Δw = A+ exp(-Δt/τ+) if Δt > 0 (LTP)
  /// Δw = A- exp(Δt/τ-) if Δt < 0 (LTD)
  public func comprehensiveSTDP(
    weight : Float,
    preTime : Float,
    postTime : Float,
    aPlus : Float,
    aMinus : Float,
    tauPlus : Float,
    tauMinus : Float
  ) : Float {
    let deltaT = postTime - preTime;
    var deltaW : Float = 0.0;
    
    if (deltaT > 0.0) {
      // Post after pre: LTP
      deltaW := aPlus * Float.exp(-deltaT / tauPlus);
    } else if (deltaT < 0.0) {
      // Pre after post: LTD
      deltaW := -aMinus * Float.exp(deltaT / tauMinus);
    };
    
    let newWeight = weight + deltaW;
    // Bounds
    if (newWeight > 1.0) { 1.0 }
    else if (newWeight < 0.0) { 0.0 }
    else { newWeight }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // POPULATION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Mean-field firing rate model
  /// τ dr/dt = -r + φ(I)
  public func comprehensiveMeanFieldRate(
    rate : Float,
    input : Float,
    tau : Float,
    gain : Float,
    threshold : Float,
    dt : Float
  ) : Float {
    // ReLU-like activation
    let activation = if (input > threshold) { gain * (input - threshold) } else { 0.0 };
    let drdt = (-rate + activation) / tau;
    rate + drdt * dt
  };

  /// Balanced network dynamics
  /// E(t+1) = φ(w_EE E - w_EI I + h_E)
  /// I(t+1) = φ(w_IE E - w_II I + h_I)
  public func comprehensiveBalancedNetwork(
    excitatory : Float,
    inhibitory : Float,
    wEE : Float,
    wEI : Float,
    wIE : Float,
    wII : Float,
    hE : Float,
    hI : Float
  ) : (Float, Float) {
    func sigmoid(x : Float) : Float {
      1.0 / (1.0 + Float.exp(-x))
    };
    
    let newE = sigmoid(wEE * excitatory - wEI * inhibitory + hE);
    let newI = sigmoid(wIE * excitatory - wII * inhibitory + hI);
    (newE, newI)
  };

  /// Spatially embedded network distance
  public func comprehensiveSpatialDistance(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
    let dx = x2 - x1;
    let dy = y2 - y1;
    Float.sqrt(dx * dx + dy * dy)
  };

  /// Gaussian spatial kernel for connectivity
  public func comprehensiveGaussianKernel(distance : Float, sigma : Float) : Float {
    Float.exp(-(distance * distance) / (2.0 * sigma * sigma))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // PREDICTIVE CODING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Prediction error: ε = o - g(μ)
  public func comprehensivePredictionError(observation : Float, prediction : Float) : Float {
    observation - prediction
  };

  /// Precision-weighted prediction error update
  /// dμ/dt = ε_below - ε_above
  public func comprehensivePredictiveCodingUpdate(
    belief : Float,
    errorBelow : Float,
    errorAbove : Float,
    learningRate : Float
  ) : Float {
    belief + learningRate * (errorBelow - errorAbove)
  };

  /// Hierarchical message passing
  /// μ_new = μ + κ (Π_below ε_below - Π_above ε_above)
  public func comprehensiveHierarchicalUpdate(
    belief : Float,
    errorBelow : Float,
    precisionBelow : Float,
    errorAbove : Float,
    precisionAbove : Float,
    learningRate : Float
  ) : Float {
    let weightedError = precisionBelow * errorBelow - precisionAbove * errorAbove;
    belief + learningRate * weightedError
  };

  /// Precision estimation from variance
  public func comprehensivePrecisionEstimate(variance : Float) : Float {
    if (variance < 0.0001) { 10000.0 }
    else { 1.0 / variance }
  };

  /// Variance accumulator
  public func comprehensiveVarianceAccumulate(
    currentVariance : Float,
    newSample : Float,
    mean : Float,
    alpha : Float
  ) : Float {
    let deviation = newSample - mean;
    alpha * (deviation * deviation) + (1.0 - alpha) * currentVariance
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTENTION AND GAIN MODULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Gain modulation: y = g · φ(x)
  public func comprehensiveGainModulation(input : Float, gain : Float) : Float {
    let activation = 1.0 / (1.0 + Float.exp(-input));
    gain * activation
  };

  /// Divisive normalization
  /// r_i = a_i^n / (σ^n + Σ_j a_j^n)
  public func comprehensiveDivisiveNormalization(
    activities : [Float],
    index : Nat,
    sigma : Float,
    exponent : Float
  ) : Float {
    if (index >= activities.size()) { return 0.0 };
    
    let ai = activities[index];
    let aiPow = Float.pow(Float.abs(ai), exponent);
    
    var sumPow : Float = Float.pow(sigma, exponent);
    var i = 0;
    while (i < activities.size()) {
      sumPow += Float.pow(Float.abs(activities[i]), exponent);
      i += 1;
    };
    
    if (sumPow < 0.0001) { 0.0 } else { aiPow / sumPow }
  };

  /// Attention spotlight position update
  public func comprehensiveAttentionUpdate(
    currentPos : Float,
    targetPos : Float,
    velocity : Float,
    maxSpeed : Float,
    dt : Float
  ) : (Float, Float) {
    let error = targetPos - currentPos;
    let desiredVel = error * 2.0;  // Proportional control
    let clampedVel = if (desiredVel > maxSpeed) { maxSpeed }
                     else if (desiredVel < -maxSpeed) { -maxSpeed }
                     else { desiredVel };
    let newVel = 0.9 * velocity + 0.1 * clampedVel;  // Smooth
    let newPos = currentPos + newVel * dt;
    (newPos, newVel)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // WORKING MEMORY DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Persistent activity through recurrent excitation
  /// τ dx/dt = -x + W_rec φ(x) + I_ext
  public func comprehensivePersistentActivity(
    activity : Float,
    wRecurrent : Float,
    externalInput : Float,
    tau : Float,
    dt : Float
  ) : Float {
    let activation = 1.0 / (1.0 + Float.exp(-activity));
    let dxdt = (-activity + wRecurrent * activation + externalInput) / tau;
    activity + dxdt * dt
  };

  /// Memory decay with refresh
  public func comprehensiveMemoryDecay(
    memory : Float,
    decayRate : Float,
    refreshSignal : Float,
    dt : Float
  ) : Float {
    let decay = -decayRate * memory;
    let refresh = refreshSignal * (1.0 - memory);
    memory + (decay + refresh) * dt
  };

  /// Bump attractor for spatial working memory
  /// τ du/dt = -u + Σ_j W(θ_i - θ_j) φ(u_j) + h
  public func comprehensiveBumpAttractor(
    activity : Float,
    position : Float,
    allActivities : [Float],
    allPositions : [Float],
    sigma : Float,
    externalInput : Float,
    tau : Float,
    dt : Float
  ) : Float {
    var sumWeighted : Float = 0.0;
    var i = 0;
    while (i < allActivities.size()) {
      let dist = position - allPositions[i];
      let weight = Float.exp(-(dist * dist) / (2.0 * sigma * sigma));
      let activation = if (allActivities[i] > 0.0) { allActivities[i] } else { 0.0 };
      sumWeighted += weight * activation;
      i += 1;
    };
    
    let dudt = (-activity + sumWeighted + externalInput) / tau;
    activity + dudt * dt
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // OSCILLATION COUPLING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phase-amplitude coupling (PAC)
  public func comprehensivePACMetric(lowPhase : Float, highAmplitude : Float) : Float {
    highAmplitude * Float.cos(lowPhase)
  };

  /// Cross-frequency coupling strength
  public func comprehensiveCFCStrength(
    lowFreqPhases : [Float],
    highFreqAmplitudes : [Float]
  ) : Float {
    let n = if (lowFreqPhases.size() < highFreqAmplitudes.size()) 
            lowFreqPhases.size() else highFreqAmplitudes.size();
    if (n == 0) { return 0.0 };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var sumAmp : Float = 0.0;
    var i = 0;
    while (i < n) {
      let amp = highFreqAmplitudes[i];
      sumCos += amp * Float.cos(lowFreqPhases[i]);
      sumSin += amp * Float.sin(lowFreqPhases[i]);
      sumAmp += amp;
      i += 1;
    };
    
    if (sumAmp < 0.0001) { 0.0 }
    else { Float.sqrt(sumCos * sumCos + sumSin * sumSin) / sumAmp }
  };

  /// Oscillation band power
  public func comprehensiveBandPower(signal : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < signal.size()) {
      sum += signal[i] * signal[i];
      i += 1;
    };
    sum / Float.fromInt(signal.size())
  };

  /// Phase-locking value (PLV)
  public func comprehensivePLV(phases1 : [Float], phases2 : [Float]) : Float {
    let n = if (phases1.size() < phases2.size()) phases1.size() else phases2.size();
    if (n == 0) { return 0.0 };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      let diff = phases1[i] - phases2[i];
      sumCos += Float.cos(diff);
      sumSin += Float.sin(diff);
      i += 1;
    };
    
    let nf = Float.fromInt(n);
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: REAL-WORLD DRONE INTEGRATION — BEE-TO-DRONE MAPPING
  // ═══════════════════════════════════════════════════════════════════════════════
  // Translating bee neuroscience into autonomous drone swarm behavior
  // Each bee cognitive function maps to a drone capability
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Drone physical state
  public type DronePhysicalState = {
    // Position (GPS coordinates or local NED frame)
    latitude   : Float;
    longitude  : Float;
    altitude   : Float;
    // Velocity (m/s)
    vx         : Float;
    vy         : Float;
    vz         : Float;
    // Attitude (radians)
    roll       : Float;
    pitch      : Float;
    yaw        : Float;
    // Angular rates (rad/s)
    rollRate   : Float;
    pitchRate  : Float;
    yawRate    : Float;
    // Battery
    batteryVoltage  : Float;
    batteryPercent  : Float;
    // Sensors
    gpsFixType      : Nat;   // 0=no fix, 1=2D, 2=3D, 3=DGPS
    satelliteCount  : Nat;
    hdop            : Float;
    // Timestamp
    lastUpdate      : Nat;
  };

  /// Drone mission state (maps to bee foraging state)
  public type DroneMissionState = {
    // Current mission phase (maps to bee behavioral state)
    phase          : Text;   // "idle", "scouting", "foraging", "returning", "dancing"
    // Target coordinates
    targetLat      : Float;
    targetLon      : Float;
    targetAlt      : Float;
    // Resource quality assessment (like nectar quality)
    resourceQuality : Float;
    // Distance to target
    distanceToTarget : Float;
    // Time on mission
    missionStartTime : Nat;
    missionDuration  : Nat;
    // Waggle dance equivalent (telemetry report)
    reportReady      : Bool;
    reportQuality    : Float;
    reportDirection  : Float;
    reportDistance   : Float;
  };

  /// Complete drone state with bee brain mapping
  public type BeeDroneState = {
    // Identity
    droneId        : Nat;
    squadronId     : Nat;
    role           : Text;   // "scout", "forager", "guard", "nurse"
    age            : Nat;    // Beats since birth
    
    // Physical
    physical       : DronePhysicalState;
    
    // Mission
    mission        : DroneMissionState;
    
    // Bee brain state
    kenyonActivation : [Float];        // Sparse code in mushroom body
    antennalInput    : [Float];        // Sensory processing
    centralComplex   : CentralComplexState;  // Navigation
    vum              : Float;          // Reward signal (octopamine equivalent)
    
    // Kuramoto phase (for swarm sync)
    phase           : Float;
    naturalFreq     : Float;
    
    // Communication
    receivedWaggles : [WaggleSignal];
    pendingWaggles  : [WaggleSignal];
    
    // Health/Status
    isActive        : Bool;
    faultCodes      : [Nat];
  };

  /// Central complex state for navigation (maps to drone autopilot)
  public type CentralComplexState = {
    // Heading representation (protocerebral bridge)
    headingNeurons   : [Float];    // 16 heading cells
    currentHeading   : Float;      // Derived heading
    desiredHeading   : Float;      // Target heading
    // Path integration (noduli)
    homeVector       : { distance : Float; direction : Float };
    // Fan-shaped body (visual memory)
    visualMemory     : [Float];
    // Ellipsoid body (orientation)
    orientationCells : [Float];
  };

  /// Waggle signal for drone communication
  public type WaggleSignal = {
    senderId       : Nat;
    direction      : Float;       // Radians from reference
    distance       : Float;       // Meters
    quality        : Float;       // 0-1 resource quality
    timestamp      : Nat;
    strength       : Float;       // Signal strength (recruitment power)
    encoded        : [Float];     // Neural encoding
  };

  /// Initialize drone with bee brain
  public func initBeeDrone(droneId: Nat, squadronId: Nat, lat: Float, lon: Float, alt: Float) : BeeDroneState {
    let physical : DronePhysicalState = {
      latitude = lat;
      longitude = lon;
      altitude = alt;
      vx = 0.0; vy = 0.0; vz = 0.0;
      roll = 0.0; pitch = 0.0; yaw = 0.0;
      rollRate = 0.0; pitchRate = 0.0; yawRate = 0.0;
      batteryVoltage = 16.8;  // 4S LiPo full
      batteryPercent = 100.0;
      gpsFixType = 3;
      satelliteCount = 12;
      hdop = 0.8;
      lastUpdate = 0;
    };
    
    let mission : DroneMissionState = {
      phase = "idle";
      targetLat = lat;
      targetLon = lon;
      targetAlt = alt;
      resourceQuality = 0.0;
      distanceToTarget = 0.0;
      missionStartTime = 0;
      missionDuration = 0;
      reportReady = false;
      reportQuality = 0.0;
      reportDirection = 0.0;
      reportDistance = 0.0;
    };
    
    let centralComplex : CentralComplexState = {
      headingNeurons = Array.tabulate<Float>(16, func(_) { 0.0 });
      currentHeading = 0.0;
      desiredHeading = 0.0;
      homeVector = { distance = 0.0; direction = 0.0 };
      visualMemory = Array.tabulate<Float>(64, func(_) { 0.0 });
      orientationCells = Array.tabulate<Float>(8, func(_) { 0.0 });
    };
    
    {
      droneId = droneId;
      squadronId = squadronId;
      role = if (droneId % 10 == 0) { "scout" } 
             else if (droneId % 5 == 0) { "guard" }
             else { "forager" };
      age = 0;
      physical = physical;
      mission = mission;
      kenyonActivation = Array.tabulate<Float>(170, func(_) { 0.0 });  // 170K scaled down
      antennalInput = Array.tabulate<Float>(160, func(_) { 0.0 });     // 160 glomeruli
      centralComplex = centralComplex;
      vum = 0.0;
      phase = Float.fromInt(droneId) * PHI;
      naturalFreq = 0.1 + Float.fromInt(droneId % 100) * 0.001;
      receivedWaggles = [];
      pendingWaggles = [];
      isActive = true;
      faultCodes = [];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: WAGGLE DANCE ENCODING/DECODING FOR DRONE COMMUNICATION
  // ═══════════════════════════════════════════════════════════════════════════════
  // Real bees encode direction (angle to sun) and distance (duration) in waggle
  // Drones encode GPS target, quality, and threat information
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Encode target location into waggle signal
  public func encodeWaggleDance(
    senderId: Nat,
    senderLat: Float,
    senderLon: Float,
    targetLat: Float,
    targetLon: Float,
    quality: Float,
    timestamp: Nat
  ) : WaggleSignal {
    // Calculate direction using haversine-like approach
    let dLat = targetLat - senderLat;
    let dLon = targetLon - senderLon;
    let direction = Float.arctan2(dLon, dLat);
    
    // Calculate distance (simplified, assumes flat Earth for short distances)
    let latRad = senderLat * PI / 180.0;
    let mPerDegLat = 111132.92 - 559.82 * Float.cos(2.0 * latRad) + 1.175 * Float.cos(4.0 * latRad);
    let mPerDegLon = 111412.84 * Float.cos(latRad) - 93.5 * Float.cos(3.0 * latRad);
    let distance = Float.sqrt((dLat * mPerDegLat) ** 2.0 + (dLon * mPerDegLon) ** 2.0);
    
    // Encode into neural representation (like bee brain encoding)
    // Direction encoded as population of 16 heading neurons
    // Distance encoded as duration (rate code)
    let encoded = Array.tabulate<Float>(32, func(i) {
      if (i < 16) {
        // Heading neurons: von Mises distribution centered on direction
        let preferred = Float.fromInt(i) * TAU / 16.0;
        let kappa = 2.0;  // Concentration parameter
        Float.exp(kappa * Float.cos(direction - preferred)) / Float.exp(kappa)
      } else {
        // Distance neurons: log-scaled distance encoding
        let preferred = Float.exp(Float.fromInt(i - 16) * 0.5);  // Log scale
        let sigma = preferred * 0.2;
        Float.exp(-(distance - preferred) ** 2.0 / (2.0 * sigma ** 2.0))
      }
    });
    
    // Signal strength based on quality (better quality = more vigorous dance)
    let strength = quality * (1.0 + 0.3 * Float.sin(Float.fromInt(timestamp) * 0.1));
    
    {
      senderId = senderId;
      direction = direction;
      distance = distance;
      quality = quality;
      timestamp = timestamp;
      strength = strength;
      encoded = encoded;
    }
  };

  /// Decode waggle signal back to target coordinates
  public func decodeWaggleDance(
    signal: WaggleSignal,
    receiverLat: Float,
    receiverLon: Float
  ) : { targetLat: Float; targetLon: Float; confidence: Float } {
    let direction = signal.direction;
    let distance = signal.distance;
    
    // Convert back to lat/lon
    let latRad = receiverLat * PI / 180.0;
    let mPerDegLat = 111132.92 - 559.82 * Float.cos(2.0 * latRad) + 1.175 * Float.cos(4.0 * latRad);
    let mPerDegLon = 111412.84 * Float.cos(latRad) - 93.5 * Float.cos(3.0 * latRad);
    
    let dLat = distance * Float.cos(direction) / mPerDegLat;
    let dLon = distance * Float.sin(direction) / mPerDegLon;
    
    let targetLat = receiverLat + dLat;
    let targetLon = receiverLon + dLon;
    
    // Confidence based on signal strength and encoding clarity
    var encodingClarity : Float = 0.0;
    var maxActivation : Float = 0.0;
    for (v in signal.encoded.vals()) {
      if (v > maxActivation) { maxActivation := v };
      encodingClarity += v * v;
    };
    let confidence = Float.sqrt(encodingClarity / 32.0) * signal.strength;
    
    { targetLat = targetLat; targetLon = targetLon; confidence = confidence }
  };

  /// Aggregate multiple waggle signals (like bee follower integration)
  public func aggregateWaggleSignals(signals: [WaggleSignal]) : ?WaggleSignal {
    if (signals.size() == 0) { return null };
    
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumDist : Float = 0.0;
    var sumQuality : Float = 0.0;
    var sumStrength : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for (signal in signals.vals()) {
      let weight = signal.strength * signal.quality;
      sumX += Float.cos(signal.direction) * signal.distance * weight;
      sumY += Float.sin(signal.direction) * signal.distance * weight;
      sumDist += signal.distance * weight;
      sumQuality += signal.quality * weight;
      sumStrength += signal.strength;
      totalWeight += weight;
    };
    
    if (totalWeight < 0.001) { return null };
    
    let avgDirection = Float.arctan2(sumY, sumX);
    let avgDistance = sumDist / totalWeight;
    let avgQuality = sumQuality / totalWeight;
    
    // Combine encoded representations
    let combinedEncoded = Array.tabulate<Float>(32, func(i) {
      var sum : Float = 0.0;
      for (signal in signals.vals()) {
        sum += signal.encoded[i] * signal.strength;
      };
      sum / sumStrength
    });
    
    ?{
      senderId = 0;  // Aggregated signal has no single sender
      direction = avgDirection;
      distance = avgDistance;
      quality = avgQuality;
      timestamp = signals[0].timestamp;
      strength = sumStrength / Float.fromInt(signals.size());
      encoded = combinedEncoded;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: FORAGER RECRUITMENT MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  // Bees recruit foragers based on resource quality - drones do the same
  // Better targets get more drones assigned
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Recruitment probability based on waggle dance observation
  public func computeRecruitmentProbability(
    observerState: BeeDroneState,
    signal: WaggleSignal,
    currentPhase: Text,
    energyLevel: Float
  ) : Float {
    // Base probability from signal quality and strength
    var prob = signal.quality * signal.strength;
    
    // Modify based on observer state
    // Idle drones more likely to be recruited
    if (currentPhase == "idle") {
      prob := prob * 1.5;
    } else if (currentPhase == "returning") {
      // Just returned, might go back
      prob := prob * 1.2;
    } else if (currentPhase == "foraging") {
      // Already busy, less likely
      prob := prob * 0.3;
    };
    
    // Energy (battery) affects willingness
    if (energyLevel < 30.0) {
      prob := prob * 0.2;  // Low battery, unlikely to go
    } else if (energyLevel > 80.0) {
      prob := prob * 1.3;  // Full battery, eager
    };
    
    // Distance penalty (far targets need better quality)
    let distanceFactor = 1.0 / (1.0 + signal.distance / 1000.0);  // 1km reference
    prob := prob * (0.5 + 0.5 * distanceFactor);
    
    // Clamp
    if (prob > 1.0) { prob := 1.0 };
    if (prob < 0.0) { prob := 0.0 };
    
    prob
  };

  /// Assign drones to targets based on quality (resource allocation)
  public type TargetAssignment = {
    targetId       : Nat;
    targetLat      : Float;
    targetLon      : Float;
    quality        : Float;
    assignedDrones : [Nat];
    priority       : Float;
  };

  public func allocateDronesToTargets(
    availableDrones: [Nat],
    targets: [{ lat: Float; lon: Float; quality: Float; priority: Float }],
    maxPerTarget: Nat
  ) : [TargetAssignment] {
    // Sort targets by quality × priority (best first)
    var sortedIndices : [Nat] = Array.tabulate<Nat>(targets.size(), func(i) { i });
    // Simple bubble sort by quality × priority
    let mutableIndices = Array.thaw<Nat>(sortedIndices);
    for (i in Iter.range(0, Int.abs(targets.size() - 2))) {
      for (j in Iter.range(0, Int.abs(targets.size() - 2 - i))) {
        let score_j = targets[mutableIndices[j]].quality * targets[mutableIndices[j]].priority;
        let score_j1 = targets[mutableIndices[j + 1]].quality * targets[mutableIndices[j + 1]].priority;
        if (score_j < score_j1) {
          let temp = mutableIndices[j];
          mutableIndices[j] := mutableIndices[j + 1];
          mutableIndices[j + 1] := temp;
        };
      };
    };
    sortedIndices := Array.freeze(mutableIndices);
    
    // Allocate drones proportionally to quality
    var totalQuality : Float = 0.0;
    for (t in targets.vals()) {
      totalQuality += t.quality * t.priority;
    };
    
    var remaining = availableDrones;
    var assignments : [TargetAssignment] = [];
    
    for (idx in sortedIndices.vals()) {
      let target = targets[idx];
      let proportionalShare = (target.quality * target.priority) / totalQuality;
      var numToAssign = Int.abs(Float.toInt(Float.fromInt(availableDrones.size()) * proportionalShare));
      if (numToAssign > maxPerTarget) { numToAssign := maxPerTarget };
      if (numToAssign > remaining.size()) { numToAssign := remaining.size() };
      
      var assigned : [Nat] = [];
      for (i in Iter.range(0, numToAssign - 1)) {
        if (i < remaining.size()) {
          assigned := Array.append(assigned, [remaining[i]]);
        };
      };
      
      // Remove assigned from remaining
      remaining := Array.tabulate<Nat>(
        if (numToAssign < remaining.size()) { remaining.size() - numToAssign } else { 0 },
        func(i) { remaining[i + numToAssign] }
      );
      
      assignments := Array.append(assignments, [{
        targetId = idx;
        targetLat = target.lat;
        targetLon = target.lon;
        quality = target.quality;
        assignedDrones = assigned;
        priority = target.priority;
      }]);
    };
    
    assignments
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 18: QUORUM SENSING FOR SWARM DECISION MAKING
  // ═══════════════════════════════════════════════════════════════════════════════
  // Bee swarms use quorum sensing to make collective decisions
  // When enough scouts report on a site, the swarm commits
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Quorum state for collective decision
  public type QuorumState = {
    candidateSites : [{ lat: Float; lon: Float; votes: Nat; quality: Float; committed: Bool }];
    quorumThreshold : Nat;
    totalScouts     : Nat;
    decisionMade    : Bool;
    winnerIndex     : ?Nat;
    consensusLevel  : Float;
    votingRound     : Nat;
  };

  /// Initialize quorum sensing
  public func initQuorumSensing(numScouts: Nat, threshold: Nat) : QuorumState {
    {
      candidateSites = [];
      quorumThreshold = threshold;
      totalScouts = numScouts;
      decisionMade = false;
      winnerIndex = null;
      consensusLevel = 0.0;
      votingRound = 0;
    }
  };

  /// Scout reports a candidate site
  public func reportCandidateSite(
    state: QuorumState,
    scoutId: Nat,
    lat: Float,
    lon: Float,
    quality: Float,
    mergeRadius: Float
  ) : QuorumState {
    // Check if this site is close to an existing candidate
    var merged = false;
    var newSites = state.candidateSites;
    
    for (i in Iter.range(0, Int.abs(state.candidateSites.size() - 1))) {
      let site = state.candidateSites[i];
      let dLat = lat - site.lat;
      let dLon = lon - site.lon;
      let dist = Float.sqrt(dLat * dLat + dLon * dLon) * 111000.0;  // Approx meters
      
      if (dist < mergeRadius) {
        // Merge with existing site
        let mutableSites = Array.thaw<{ lat: Float; lon: Float; votes: Nat; quality: Float; committed: Bool }>(newSites);
        mutableSites[i] := {
          lat = (site.lat * Float.fromInt(site.votes) + lat) / Float.fromInt(site.votes + 1);
          lon = (site.lon * Float.fromInt(site.votes) + lon) / Float.fromInt(site.votes + 1);
          votes = site.votes + 1;
          quality = (site.quality * Float.fromInt(site.votes) + quality) / Float.fromInt(site.votes + 1);
          committed = site.committed;
        };
        newSites := Array.freeze(mutableSites);
        merged := true;
      };
    };
    
    if (not merged) {
      // New candidate site
      newSites := Array.append(newSites, [{
        lat = lat;
        lon = lon;
        votes = 1;
        quality = quality;
        committed = false;
      }]);
    };
    
    // Check for quorum
    var winner : ?Nat = null;
    var maxVotes : Nat = 0;
    var totalVotes : Nat = 0;
    
    for (i in Iter.range(0, Int.abs(newSites.size() - 1))) {
      let site = newSites[i];
      totalVotes += site.votes;
      if (site.votes >= state.quorumThreshold and site.votes > maxVotes) {
        maxVotes := site.votes;
        winner := ?i;
      };
    };
    
    let consensus = if (totalVotes > 0 and maxVotes > 0) {
      Float.fromInt(maxVotes) / Float.fromInt(totalVotes)
    } else { 0.0 };
    
    {
      candidateSites = newSites;
      quorumThreshold = state.quorumThreshold;
      totalScouts = state.totalScouts;
      decisionMade = winner != null;
      winnerIndex = winner;
      consensusLevel = consensus;
      votingRound = state.votingRound + 1;
    }
  };

  /// Get the winning site coordinates
  public func getQuorumWinner(state: QuorumState) : ?{ lat: Float; lon: Float; quality: Float } {
    switch (state.winnerIndex) {
      case (?idx) {
        if (idx < state.candidateSites.size()) {
          let site = state.candidateSites[idx];
          ?{ lat = site.lat; lon = site.lon; quality = site.quality }
        } else { null }
      };
      case null { null };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 19: DRONE CENTRAL COMPLEX — NAVIGATION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Maps bee central complex to drone navigation system
  // Path integration, heading control, landmark memory
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Update heading neurons (protocerebral bridge analog)
  public func updateHeadingNeurons(
    currentNeurons: [Float],
    measuredHeading: Float,
    desiredHeading: Float,
    angularVelocity: Float,
    dt: Float
  ) : [Float] {
    let n = currentNeurons.size();
    if (n == 0) { return currentNeurons };
    
    Array.tabulate<Float>(n, func(i) {
      let preferredHeading = Float.fromInt(i) * TAU / Float.fromInt(n);
      
      // Sensory input: peaked at measured heading
      let sensorInput = Float.exp(2.0 * Float.cos(measuredHeading - preferredHeading)) / Float.exp(2.0);
      
      // Motor command: peaked at desired heading
      let motorInput = Float.exp(1.5 * Float.cos(desiredHeading - preferredHeading)) / Float.exp(1.5);
      
      // Angular velocity shifts activity
      let velocityShift = angularVelocity * dt * Float.fromInt(n) / TAU;
      let shiftedIdx = i + Int.abs(Float.toInt(velocityShift));
      let shiftedActivity = if (shiftedIdx < n) { currentNeurons[shiftedIdx] } else { currentNeurons[shiftedIdx % n] };
      
      // Leaky integrator
      let tau = 0.1;
      let decay = Float.exp(-dt / tau);
      
      decay * shiftedActivity + (1.0 - decay) * (0.3 * sensorInput + 0.3 * motorInput + 0.4 * currentNeurons[i])
    })
  };

  /// Path integration update (noduli analog)
  public func updatePathIntegration(
    currentHome: { distance: Float; direction: Float },
    velocity: { vx: Float; vy: Float },
    heading: Float,
    dt: Float
  ) : { distance: Float; direction: Float } {
    // Convert velocity to displacement in world frame
    let dx = velocity.vx * dt;
    let dy = velocity.vy * dt;
    
    // Current home position in Cartesian
    let homeX = currentHome.distance * Float.cos(currentHome.direction);
    let homeY = currentHome.distance * Float.sin(currentHome.direction);
    
    // Subtract displacement (we moved away from home)
    let newHomeX = homeX - dx;
    let newHomeY = homeY - dy;
    
    // Convert back to polar
    let newDistance = Float.sqrt(newHomeX * newHomeX + newHomeY * newHomeY);
    let newDirection = Float.arctan2(newHomeY, newHomeX);
    
    { distance = newDistance; direction = newDirection }
  };

  /// Compute steering command from central complex
  public func computeSteeringCommand(
    headingNeurons: [Float],
    homeVector: { distance: Float; direction: Float },
    targetVector: { distance: Float; direction: Float },
    currentHeading: Float,
    mode: Text  // "homing", "foraging", "exploring"
  ) : { turnRate: Float; speed: Float } {
    let n = headingNeurons.size();
    if (n == 0) { return { turnRate = 0.0; speed = 0.0 } };
    
    // Compute desired heading based on mode
    let desiredHeading = switch (mode) {
      case "homing" { homeVector.direction + PI };  // Opposite of home vector
      case "foraging" { targetVector.direction };
      case _ { currentHeading };  // Maintain heading
    };
    
    // Heading error
    var headingError = desiredHeading - currentHeading;
    while (headingError > PI) { headingError -= TAU };
    while (headingError < -PI) { headingError += TAU };
    
    // Turn rate proportional to error, with saturation
    let maxTurnRate = 1.0;  // rad/s
    var turnRate = headingError * 2.0;  // Gain
    if (turnRate > maxTurnRate) { turnRate := maxTurnRate };
    if (turnRate < -maxTurnRate) { turnRate := -maxTurnRate };
    
    // Speed based on mode and distance
    let speed = switch (mode) {
      case "homing" { 
        let urgency = Float.min(1.0, homeVector.distance / 100.0);  // Speed up when far
        5.0 + 10.0 * urgency  // 5-15 m/s
      };
      case "foraging" {
        let approach = if (targetVector.distance < 50.0) { 
          targetVector.distance / 50.0  // Slow down near target
        } else { 1.0 };
        5.0 + 8.0 * approach  // 5-13 m/s
      };
      case _ { 3.0 };  // Slow exploration
    };
    
    { turnRate = turnRate; speed = speed }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 20: SWARM FORMATION CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════
  // Bee swarm formations mapped to drone tactical formations
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Formation types
  public type FormationType = {
    #Sphere;           // Defensive sphere (like bee cluster)
    #Wedge;            // Attack wedge
    #Line;             // Search line
    #Grid;             // Survey grid
    #Helix;            // Golden helix (Medina signature)
    #Fibonacci;        // Fibonacci sphere packing
    #Custom : [{ x: Float; y: Float; z: Float }];
  };

  /// Compute position in formation
  public func computeFormationPosition(
    formation: FormationType,
    droneIndex: Nat,
    totalDrones: Nat,
    centerX: Float,
    centerY: Float,
    centerZ: Float,
    scale: Float,
    heading: Float
  ) : { x: Float; y: Float; z: Float } {
    let i = droneIndex;
    let n = totalDrones;
    let nf = Float.fromInt(n);
    let ifloat = Float.fromInt(i);
    
    let (localX, localY, localZ) = switch (formation) {
      case (#Sphere) {
        // Fibonacci sphere
        let goldenAngle = PI * (3.0 - Float.sqrt(5.0));
        let theta = goldenAngle * ifloat;
        let z = 1.0 - (2.0 * ifloat + 1.0) / nf;
        let radius = Float.sqrt(1.0 - z * z);
        (radius * Float.cos(theta) * scale, radius * Float.sin(theta) * scale, z * scale)
      };
      
      case (#Wedge) {
        // V-formation (like geese/bees in flight)
        let row = Int.abs(Float.toInt(Float.sqrt(ifloat)));
        let col = i - row * row;
        let xOff = Float.fromInt(col) - Float.fromInt(row) / 2.0;
        let yOff = Float.fromInt(row);
        (xOff * scale * 2.0, yOff * scale * 3.0, 0.0)
      };
      
      case (#Line) {
        // Linear search pattern
        let spacing = scale * 2.0;
        ((ifloat - nf / 2.0) * spacing, 0.0, 0.0)
      };
      
      case (#Grid) {
        // Square grid
        let side = Int.abs(Float.toInt(Float.ceil(Float.sqrt(nf))));
        let row = i / side;
        let col = i % side;
        let spacing = scale;
        ((Float.fromInt(col) - Float.fromInt(side) / 2.0) * spacing,
         (Float.fromInt(row) - Float.fromInt(side) / 2.0) * spacing,
         0.0)
      };
      
      case (#Helix) {
        // Golden helix (Medina signature formation)
        let t = ifloat / nf * 4.0 * PI;  // 2 full turns
        let radius = scale * (0.5 + 0.5 * ifloat / nf);  // Expanding radius
        let z = ifloat / nf * scale * 2.0 - scale;  // Vertical spread
        (radius * Float.cos(t), radius * Float.sin(t), z)
      };
      
      case (#Fibonacci) {
        // Fibonacci spiral on plane
        let theta = ifloat * PHI * TAU;
        let radius = scale * Float.sqrt(ifloat / nf);
        (radius * Float.cos(theta), radius * Float.sin(theta), 0.0)
      };
      
      case (#Custom(positions)) {
        if (i < positions.size()) {
          let p = positions[i];
          (p.x * scale, p.y * scale, p.z * scale)
        } else { (0.0, 0.0, 0.0) }
      };
    };
    
    // Rotate by heading
    let cosH = Float.cos(heading);
    let sinH = Float.sin(heading);
    let rotatedX = localX * cosH - localY * sinH;
    let rotatedY = localX * sinH + localY * cosH;
    
    {
      x = centerX + rotatedX;
      y = centerY + rotatedY;
      z = centerZ + localZ;
    }
  };

  /// Compute formation quality (how well drones maintain formation)
  public func computeFormationQuality(
    actualPositions: [{ x: Float; y: Float; z: Float }],
    targetPositions: [{ x: Float; y: Float; z: Float }]
  ) : Float {
    let n = if (actualPositions.size() < targetPositions.size()) 
            actualPositions.size() else targetPositions.size();
    if (n == 0) { return 0.0 };
    
    var totalError : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let dx = actualPositions[i].x - targetPositions[i].x;
      let dy = actualPositions[i].y - targetPositions[i].y;
      let dz = actualPositions[i].z - targetPositions[i].z;
      totalError += Float.sqrt(dx*dx + dy*dy + dz*dz);
    };
    
    let avgError = totalError / Float.fromInt(n);
    // Convert error to quality (0-1), with 10m as reference
    1.0 / (1.0 + avgError / 10.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 21: SWARM THREAT RESPONSE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Bee defensive behaviors mapped to drone swarm defense
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Threat types
  public type ThreatType = {
    #Predator : { lat: Float; lon: Float; alt: Float; threatLevel: Float };
    #NoFlyZone : { lat: Float; lon: Float; radius: Float };
    #LowBattery : { droneId: Nat; batteryPercent: Float };
    #Communication : { affectedDrones: [Nat] };
    #Weather : { windSpeed: Float; precipitation: Float };
    #Collision : { droneA: Nat; droneB: Nat; minSeparation: Float };
  };

  /// Compute threat response (like bee alarm pheromone cascade)
  public func computeThreatResponse(
    threat: ThreatType,
    dronePositions: [{ id: Nat; lat: Float; lon: Float; alt: Float }],
    currentFormation: FormationType
  ) : { 
    newFormation: FormationType; 
    evasionVector: { lat: Float; lon: Float; alt: Float };
    alertLevel: Float;
    affectedDrones: [Nat];
  } {
    switch (threat) {
      case (#Predator(p)) {
        // Compute direction away from predator
        var sumLat : Float = 0.0;
        var sumLon : Float = 0.0;
        for (drone in dronePositions.vals()) {
          sumLat += drone.lat;
          sumLon += drone.lon;
        };
        let centroidLat = sumLat / Float.fromInt(dronePositions.size());
        let centroidLon = sumLon / Float.fromInt(dronePositions.size());
        
        let evadeDir = Float.arctan2(centroidLat - p.lat, centroidLon - p.lon);
        let evadeDist = 100.0 / 111000.0;  // 100m in degrees
        
        {
          newFormation = #Sphere;  // Defensive formation
          evasionVector = {
            lat = Float.cos(evadeDir) * evadeDist;
            lon = Float.sin(evadeDir) * evadeDist;
            alt = 10.0;  // Gain altitude
          };
          alertLevel = p.threatLevel;
          affectedDrones = Array.tabulate<Nat>(dronePositions.size(), func(i) { dronePositions[i].id });
        }
      };
      
      case (#NoFlyZone(nfz)) {
        // Find drones inside/near NFZ
        var affected : [Nat] = [];
        for (drone in dronePositions.vals()) {
          let dist = Float.sqrt((drone.lat - nfz.lat)**2.0 + (drone.lon - nfz.lon)**2.0) * 111000.0;
          if (dist < nfz.radius * 1.5) {
            affected := Array.append(affected, [drone.id]);
          };
        };
        
        {
          newFormation = currentFormation;
          evasionVector = { lat = 0.0; lon = 0.0; alt = 0.0 };
          alertLevel = 0.8;
          affectedDrones = affected;
        }
      };
      
      case (#LowBattery(lb)) {
        {
          newFormation = currentFormation;
          evasionVector = { lat = 0.0; lon = 0.0; alt = 0.0 };
          alertLevel = if (lb.batteryPercent < 15.0) { 0.9 } else { 0.5 };
          affectedDrones = [lb.droneId];
        }
      };
      
      case (#Communication(c)) {
        {
          newFormation = #Grid;  // Spread out to re-establish comms
          evasionVector = { lat = 0.0; lon = 0.0; alt = 20.0 };  // Gain altitude for better reception
          alertLevel = 0.7;
          affectedDrones = c.affectedDrones;
        }
      };
      
      case (#Weather(w)) {
        let alertLevel = (w.windSpeed / 20.0 + w.precipitation) / 2.0;
        {
          newFormation = if (alertLevel > 0.7) { #Sphere } else { currentFormation };
          evasionVector = { lat = 0.0; lon = 0.0; alt = -10.0 };  // Descend in bad weather
          alertLevel = alertLevel;
          affectedDrones = Array.tabulate<Nat>(dronePositions.size(), func(i) { dronePositions[i].id });
        }
      };
      
      case (#Collision(c)) {
        {
          newFormation = currentFormation;
          evasionVector = { lat = 0.0; lon = 0.0; alt = 5.0 };
          alertLevel = 1.0;  // Maximum alert
          affectedDrones = [c.droneA, c.droneB];
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 22: COMPLETE SWARM BRAIN TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  // One beat of the swarm intelligence
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Complete swarm state
  public type SwarmBrainState = {
    // Drones
    drones          : [BeeDroneState];
    
    // Collective state
    swarmPhase      : Float;           // Mean Kuramoto phase
    swarmCoherence  : Float;           // Order parameter r
    swarmCentroid   : { lat: Float; lon: Float; alt: Float };
    
    // Mission
    currentFormation : FormationType;
    missionPhase     : Text;           // "idle", "scouting", "foraging", "returning", "defending"
    activeTargets    : [TargetAssignment];
    
    // Decision making
    quorumState      : QuorumState;
    
    // Threats
    activeThreats    : [ThreatType];
    alertLevel       : Float;
    
    // Communication
    wagglePool       : [WaggleSignal];
    
    // Timing
    beatNum          : Nat;
  };

  /// Initialize complete swarm
  public func initSwarmBrain(numDrones: Nat, baseLat: Float, baseLon: Float, baseAlt: Float) : SwarmBrainState {
    // Initialize drones in Fibonacci sphere around base
    let drones = Array.tabulate<BeeDroneState>(numDrones, func(i) {
      let goldenAngle = PI * (3.0 - Float.sqrt(5.0));
      let theta = goldenAngle * Float.fromInt(i);
      let z = 1.0 - (2.0 * Float.fromInt(i) + 1.0) / Float.fromInt(numDrones);
      let radius = Float.sqrt(1.0 - z * z) * 0.0001;  // Small spread in degrees
      
      let lat = baseLat + radius * Float.cos(theta);
      let lon = baseLon + radius * Float.sin(theta);
      let alt = baseAlt + z * 20.0;  // ±20m altitude spread
      
      initBeeDrone(i, i / 10, lat, lon, alt)  // Groups of 10 per squadron
    });
    
    {
      drones = drones;
      swarmPhase = 0.0;
      swarmCoherence = 0.5;
      swarmCentroid = { lat = baseLat; lon = baseLon; alt = baseAlt };
      currentFormation = #Fibonacci;
      missionPhase = "idle";
      activeTargets = [];
      quorumState = initQuorumSensing(numDrones / 10, 3);  // 10% scouts, need 3 votes
      activeThreats = [];
      alertLevel = 0.0;
      wagglePool = [];
      beatNum = 0;
    }
  };

  /// Execute one beat of swarm brain
  public func tickSwarmBrain(state: SwarmBrainState, dt: Float) : SwarmBrainState {
    let n = state.drones.size();
    if (n == 0) { return state };
    
    // 1. Compute Kuramoto synchronization
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (drone in state.drones.vals()) {
      sumCos += Float.cos(drone.phase);
      sumSin += Float.sin(drone.phase);
    };
    let meanPhase = Float.arctan2(sumSin, sumCos);
    let coherence = Float.sqrt(sumCos*sumCos + sumSin*sumSin) / Float.fromInt(n);
    
    // 2. Update each drone
    var newDrones : [BeeDroneState] = [];
    var sumLat : Float = 0.0;
    var sumLon : Float = 0.0;
    var sumAlt : Float = 0.0;
    
    for (drone in state.drones.vals()) {
      // Kuramoto phase update
      let phaseSync = KURAMOTO_K * coherence * Float.sin(meanPhase - drone.phase);
      let newPhase = drone.phase + (drone.naturalFreq + phaseSync) * dt;
      
      // Update mission based on role and state
      let newMission = updateDroneMission(drone.mission, state.activeTargets, drone.role);
      
      // Update central complex for navigation
      let steering = computeSteeringCommand(
        drone.centralComplex.headingNeurons,
        drone.centralComplex.homeVector,
        { distance = drone.mission.distanceToTarget; direction = drone.mission.reportDirection },
        drone.physical.yaw,
        drone.mission.phase
      );
      
      // Simplified physics update
      let newYaw = drone.physical.yaw + steering.turnRate * dt;
      let newVx = steering.speed * Float.cos(newYaw);
      let newVy = steering.speed * Float.sin(newYaw);
      
      // Update position (very simplified)
      let newLat = drone.physical.latitude + newVy * dt / 111000.0;
      let newLon = drone.physical.longitude + newVx * dt / (111000.0 * Float.cos(drone.physical.latitude * PI / 180.0));
      
      sumLat += newLat;
      sumLon += newLon;
      sumAlt += drone.physical.altitude;
      
      // Update drone state
      let updatedPhysical : DronePhysicalState = {
        latitude = newLat;
        longitude = newLon;
        altitude = drone.physical.altitude;
        vx = newVx;
        vy = newVy;
        vz = drone.physical.vz;
        roll = drone.physical.roll;
        pitch = drone.physical.pitch;
        yaw = newYaw;
        rollRate = drone.physical.rollRate;
        pitchRate = drone.physical.pitchRate;
        yawRate = steering.turnRate;
        batteryVoltage = drone.physical.batteryVoltage - 0.0001 * dt;  // Slow discharge
        batteryPercent = drone.physical.batteryPercent - 0.001 * dt;
        gpsFixType = drone.physical.gpsFixType;
        satelliteCount = drone.physical.satelliteCount;
        hdop = drone.physical.hdop;
        lastUpdate = state.beatNum;
      };
      
      newDrones := Array.append(newDrones, [{
        droneId = drone.droneId;
        squadronId = drone.squadronId;
        role = drone.role;
        age = drone.age + 1;
        physical = updatedPhysical;
        mission = newMission;
        kenyonActivation = drone.kenyonActivation;
        antennalInput = drone.antennalInput;
        centralComplex = drone.centralComplex;
        vum = drone.vum;
        phase = newPhase;
        naturalFreq = drone.naturalFreq;
        receivedWaggles = drone.receivedWaggles;
        pendingWaggles = drone.pendingWaggles;
        isActive = drone.isActive;
        faultCodes = drone.faultCodes;
      }]);
    };
    
    // 3. Update swarm centroid
    let newCentroid = {
      lat = sumLat / Float.fromInt(n);
      lon = sumLon / Float.fromInt(n);
      alt = sumAlt / Float.fromInt(n);
    };
    
    // 4. Process waggle pool (collective decision making)
    let aggregatedSignal = aggregateWaggleSignals(state.wagglePool);
    
    {
      drones = newDrones;
      swarmPhase = meanPhase;
      swarmCoherence = coherence;
      swarmCentroid = newCentroid;
      currentFormation = state.currentFormation;
      missionPhase = state.missionPhase;
      activeTargets = state.activeTargets;
      quorumState = state.quorumState;
      activeThreats = state.activeThreats;
      alertLevel = state.alertLevel;
      wagglePool = state.wagglePool;
      beatNum = state.beatNum + 1;
    }
  };

  /// Update drone mission state
  func updateDroneMission(
    mission: DroneMissionState,
    targets: [TargetAssignment],
    role: Text
  ) : DroneMissionState {
    // Simple state machine
    var newPhase = mission.phase;
    var newDuration = mission.missionDuration + 1;
    
    if (mission.phase == "idle" and targets.size() > 0) {
      newPhase := if (role == "scout") { "scouting" } else { "foraging" };
      newDuration := 0;
    } else if (mission.phase == "foraging" and mission.distanceToTarget < 10.0) {
      newPhase := "returning";
    } else if (mission.phase == "returning" and mission.distanceToTarget < 10.0) {
      newPhase := "dancing";
    } else if (mission.phase == "dancing" and newDuration > 50) {
      newPhase := "idle";
    };
    
    {
      phase = newPhase;
      targetLat = mission.targetLat;
      targetLon = mission.targetLon;
      targetAlt = mission.targetAlt;
      resourceQuality = mission.resourceQuality;
      distanceToTarget = mission.distanceToTarget;
      missionStartTime = mission.missionStartTime;
      missionDuration = newDuration;
      reportReady = newPhase == "dancing";
      reportQuality = mission.resourceQuality;
      reportDirection = mission.reportDirection;
      reportDistance = mission.reportDistance;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 23: SWARM-TO-SWARM ENGAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  // When two swarms meet - competitive/adversarial behavior
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Swarm engagement state
  public type SwarmEngagementState = {
    friendlySwarm   : SwarmBrainState;
    enemySwarm      : SwarmBrainState;
    engagementPhase : Text;            // "detecting", "engaging", "disengaging", "victory", "retreat"
    relativeAdvantage : Float;         // Positive = friendly winning
    casualtiesFriendly : Nat;
    casualtiesEnemy : Nat;
    contestedArea   : { lat: Float; lon: Float; radius: Float };
    beatNum         : Nat;
  };

  /// Initialize swarm engagement
  public func initSwarmEngagement(
    friendlySwarm: SwarmBrainState,
    enemySwarm: SwarmBrainState,
    engagementArea: { lat: Float; lon: Float; radius: Float }
  ) : SwarmEngagementState {
    {
      friendlySwarm = friendlySwarm;
      enemySwarm = enemySwarm;
      engagementPhase = "detecting";
      relativeAdvantage = 0.0;
      casualtiesFriendly = 0;
      casualtiesEnemy = 0;
      contestedArea = engagementArea;
      beatNum = 0;
    }
  };

  /// Compute engagement advantage
  public func computeEngagementAdvantage(state: SwarmEngagementState) : Float {
    // Numerical advantage
    let numAdvantage = Float.fromInt(state.friendlySwarm.drones.size()) / 
                       Float.fromInt(state.enemySwarm.drones.size() + 1);
    
    // Coherence advantage (better coordinated swarm)
    let coherenceAdvantage = state.friendlySwarm.swarmCoherence - state.enemySwarm.swarmCoherence;
    
    // Position advantage (higher altitude)
    let altAdvantage = (state.friendlySwarm.swarmCentroid.alt - state.enemySwarm.swarmCentroid.alt) / 50.0;
    
    // Combined advantage
    (numAdvantage - 1.0) * 0.4 + coherenceAdvantage * 0.4 + altAdvantage * 0.2
  };

  /// Execute one tick of swarm engagement
  public func tickSwarmEngagement(state: SwarmEngagementState, dt: Float) : SwarmEngagementState {
    let advantage = computeEngagementAdvantage(state);
    
    // Update phase based on advantage
    let newPhase = if (advantage > 0.5) { "victory" }
                   else if (advantage < -0.5) { "retreat" }
                   else if (state.engagementPhase == "detecting") { "engaging" }
                   else { state.engagementPhase };
    
    // Simulate casualties based on advantage
    var newCasFriendly = state.casualtiesFriendly;
    var newCasEnemy = state.casualtiesEnemy;
    
    if (state.engagementPhase == "engaging") {
      // Probability of casualty inversely related to advantage
      if (advantage < 0.0) {
        newCasFriendly += 1;  // Losing, take more casualties
      } else {
        newCasEnemy += 1;     // Winning, inflict more
      };
    };
    
    // Update swarm positions (simplified)
    let friendlyState = tickSwarmBrain(state.friendlySwarm, dt);
    let enemyState = tickSwarmBrain(state.enemySwarm, dt);
    
    {
      friendlySwarm = friendlyState;
      enemySwarm = enemyState;
      engagementPhase = newPhase;
      relativeAdvantage = advantage;
      casualtiesFriendly = newCasFriendly;
      casualtiesEnemy = newCasEnemy;
      contestedArea = state.contestedArea;
      beatNum = state.beatNum + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 24: MASTER OUTPUT INTERFACE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete swarm intelligence output for organism integration
  public type SwarmIntelligenceOutput = {
    // Collective metrics
    swarmCoherence    : Float;
    swarmPhase        : Float;
    swarmSize         : Nat;
    activeDrones      : Nat;
    
    // Position
    centroidLat       : Float;
    centroidLon       : Float;
    centroidAlt       : Float;
    spreadRadius      : Float;
    
    // Mission
    missionPhase      : Text;
    missionProgress   : Float;
    targetsAssigned   : Nat;
    
    // Formation
    formationQuality  : Float;
    formationType     : Text;
    
    // Threat
    alertLevel        : Float;
    activeThreats     : Nat;
    
    // Communication
    wagglePoolSize    : Nat;
    consensusLevel    : Float;
    
    // Beat
    beatNum           : Nat;
  };

  /// Generate comprehensive output
  public func generateSwarmOutput(state: SwarmBrainState) : SwarmIntelligenceOutput {
    var activeDrones = 0;
    for (drone in state.drones.vals()) {
      if (drone.isActive) { activeDrones += 1 };
    };
    
    // Compute spread radius
    var maxDist : Float = 0.0;
    for (drone in state.drones.vals()) {
      let dLat = drone.physical.latitude - state.swarmCentroid.lat;
      let dLon = drone.physical.longitude - state.swarmCentroid.lon;
      let dist = Float.sqrt(dLat*dLat + dLon*dLon) * 111000.0;
      if (dist > maxDist) { maxDist := dist };
    };
    
    let formationName = switch (state.currentFormation) {
      case (#Sphere) { "sphere" };
      case (#Wedge) { "wedge" };
      case (#Line) { "line" };
      case (#Grid) { "grid" };
      case (#Helix) { "helix" };
      case (#Fibonacci) { "fibonacci" };
      case (#Custom(_)) { "custom" };
    };
    
    {
      swarmCoherence = state.swarmCoherence;
      swarmPhase = state.swarmPhase;
      swarmSize = state.drones.size();
      activeDrones = activeDrones;
      centroidLat = state.swarmCentroid.lat;
      centroidLon = state.swarmCentroid.lon;
      centroidAlt = state.swarmCentroid.alt;
      spreadRadius = maxDist;
      missionPhase = state.missionPhase;
      missionProgress = 0.5;  // Would compute from mission state
      targetsAssigned = state.activeTargets.size();
      formationQuality = state.swarmCoherence;  // Simplified
      formationType = formationName;
      alertLevel = state.alertLevel;
      activeThreats = state.activeThreats.size();
      wagglePoolSize = state.wagglePool.size();
      consensusLevel = state.quorumState.consensusLevel;
      beatNum = state.beatNum;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ██████╗ ███████╗███████╗    ███████╗██╗    ██╗ █████╗ ██████╗ ███╗   ███╗
  // ██╔══██╗██╔════╝██╔════╝    ██╔════╝██║    ██║██╔══██╗██╔══██╗████╗ ████║
  // ██████╔╝█████╗  █████╗      ███████╗██║ █╗ ██║███████║██████╔╝██╔████╔██║
  // ██╔══██╗██╔══╝  ██╔══╝      ╚════██║██║███╗██║██╔══██║██╔══██╗██║╚██╔╝██║
  // ██████╔╝███████╗███████╗    ███████║╚███╔███╔╝██║  ██║██║  ██║██║ ╚═╝ ██║
  // ╚═════╝ ╚══════╝╚══════╝    ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 25: REAL BEE SWARM BEHAVIOR — QUEEN FOLLOWING & COLONY MIGRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // When a colony swarms, it's one of the most beautiful behaviors in nature:
  //   1. Scout bees find potential new nest sites
  //   2. Scouts perform waggle dances to recruit followers
  //   3. More scouts visit and "vote" via dance intensity
  //   4. When enough scouts agree (quorum), the swarm commits
  //   5. The entire swarm lifts off and follows the scouts
  //   6. They form a "bee tornado" spiraling upward
  //   7. The swarm moves as ONE ORGANISM toward the new site
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Swarm migration state
  public type SwarmMigrationState = {
    // Migration phase
    phase           : MigrationPhase;
    phaseStartBeat  : Nat;
    
    // Scout activity
    scoutIds        : [Nat];        // IDs of scout drones
    scoutReports    : [ScoutReport];
    
    // Nest site candidates
    candidateSites  : [NestSiteCandidate];
    
    // Quorum voting
    votingState     : QuorumVotingState;
    
    // Queen (or high-value asset)
    queenId         : ?Nat;
    queenPosition   : ?{ lat: Float; lon: Float; alt: Float };
    queenEscorts    : [Nat];
    
    // Swarm cluster
    clusterCenter   : { lat: Float; lon: Float; alt: Float };
    clusterRadius   : Float;
    clusterDensity  : Float;
    
    // Movement
    targetSite      : ?NestSiteCandidate;
    movementSpeed   : Float;
    movementHeading : Float;
    
    // Temperature regulation
    clusterTemperature : Float;     // Core temperature
    ambientTemperature : Float;
    
    beatNum         : Nat;
  };

  /// Migration phases
  public type MigrationPhase = {
    #Clustering;      // Forming cluster at departure point
    #Scouting;        // Scouts exploring for sites
    #Deliberating;    // Waggle dance competition
    #Preparing;       // Pre-flight warm-up
    #Launching;       // Liftoff phase
    #Flying;          // In transit
    #Approaching;     // Near destination
    #Landing;         // Settling at new site
    #Establishing;    // Setting up new nest
  };

  /// Scout report
  public type ScoutReport = {
    scoutId         : Nat;
    timestamp       : Nat;
    
    // Site information
    siteLocation    : { lat: Float; lon: Float; alt: Float };
    siteQuality     : Float;        // 0-1
    
    // Quality factors
    volumeFactor    : Float;        // Space adequacy
    entranceFactor  : Float;        // Entrance quality
    shelterFactor   : Float;        // Protection from elements
    resourceFactor  : Float;        // Nearby resources
    
    // Scout assessment
    confidence      : Float;
    visitCount      : Nat;
    
    // Dance parameters
    danceIntensity  : Float;
    danceDuration   : Float;
  };

  /// Nest site candidate
  public type NestSiteCandidate = {
    siteId          : Nat;
    location        : { lat: Float; lon: Float; alt: Float };
    
    // Aggregated quality
    overallQuality  : Float;
    qualityHistory  : [Float];
    
    // Votes
    supportingScouts : [Nat];
    voteStrength    : Float;
    
    // Status
    isViable        : Bool;
    isSelected      : Bool;
    
    // Discovery
    discoveredAt    : Nat;
    discoveredBy    : Nat;
  };

  /// Quorum voting state
  public type QuorumVotingState = {
    // Voting parameters
    quorumThreshold : Float;        // Fraction of scouts needed
    currentQuorum   : Float;
    
    // Vote counts per site
    siteVotes       : [(Nat, Float)];  // (siteId, voteStrength)
    
    // Leading candidate
    leadingSite     : ?Nat;
    leadStrength    : Float;
    
    // Consensus metrics
    consensusLevel  : Float;
    votingEntropy   : Float;        // Low entropy = high consensus
    
    // Deliberation state
    roundNumber     : Nat;
    deadlockCount   : Nat;
    
    // Decision
    decisionMade    : Bool;
    decisionBeat    : ?Nat;
  };

  /// Initialize migration state
  public func initMigrationState(
    swarmSize: Nat,
    startPosition: { lat: Float; lon: Float; alt: Float },
    ambientTemp: Float
  ) : SwarmMigrationState {
    // Designate ~10% as scouts
    let numScouts = (swarmSize + 9) / 10;
    let scouts = Array.tabulate<Nat>(numScouts, func(i) { i * 10 });  // Every 10th drone
    
    {
      phase = #Clustering;
      phaseStartBeat = 0;
      scoutIds = scouts;
      scoutReports = [];
      candidateSites = [];
      votingState = {
        quorumThreshold = 0.3;  // 30% of scouts must agree
        currentQuorum = 0.0;
        siteVotes = [];
        leadingSite = null;
        leadStrength = 0.0;
        consensusLevel = 0.0;
        votingEntropy = 1.0;
        roundNumber = 0;
        deadlockCount = 0;
        decisionMade = false;
        decisionBeat = null;
      };
      queenId = null;  // Will be assigned
      queenPosition = ?startPosition;
      queenEscorts = [];
      clusterCenter = startPosition;
      clusterRadius = 5.0;  // 5 meters initially
      clusterDensity = 0.8;
      targetSite = null;
      movementSpeed = 0.0;
      movementHeading = 0.0;
      clusterTemperature = 35.0;  // Bee cluster maintains ~35°C
      ambientTemperature = ambientTemp;
      beatNum = 0;
    }
  };

  /// Process scout report and update candidates
  public func processScoutReport(
    state: SwarmMigrationState,
    report: ScoutReport
  ) : SwarmMigrationState {
    // Check if this is a new site or update to existing
    var candidateSites = state.candidateSites;
    var foundExisting = false;
    
    let newCandidates = Array.map<NestSiteCandidate, NestSiteCandidate>(candidateSites, func(site) {
      let dist = haversineDistance(
        site.location.lat, site.location.lon,
        report.siteLocation.lat, report.siteLocation.lon
      );
      
      if (dist < 50.0) {  // Within 50 meters = same site
        foundExisting := true;
        // Update site with new report
        var newSupporting = site.supportingScouts;
        var alreadySupporting = false;
        for (sid in newSupporting.vals()) {
          if (sid == report.scoutId) { alreadySupporting := true };
        };
        if (not alreadySupporting) {
          newSupporting := Array.append(newSupporting, [report.scoutId]);
        };
        
        let newQuality = (site.overallQuality * Float.fromInt(site.supportingScouts.size()) + report.siteQuality) /
                         Float.fromInt(newSupporting.size());
        
        {
          siteId = site.siteId;
          location = {
            lat = (site.location.lat + report.siteLocation.lat) / 2.0;
            lon = (site.location.lon + report.siteLocation.lon) / 2.0;
            alt = (site.location.alt + report.siteLocation.alt) / 2.0;
          };
          overallQuality = newQuality;
          qualityHistory = Array.append(site.qualityHistory, [report.siteQuality]);
          supportingScouts = newSupporting;
          voteStrength = Float.fromInt(newSupporting.size()) * newQuality;
          isViable = newQuality > 0.3;
          isSelected = site.isSelected;
          discoveredAt = site.discoveredAt;
          discoveredBy = site.discoveredBy;
        }
      } else { site }
    });
    
    let finalCandidates = if (foundExisting) {
      newCandidates
    } else {
      // New site
      Array.append(newCandidates, [{
        siteId = newCandidates.size();
        location = report.siteLocation;
        overallQuality = report.siteQuality;
        qualityHistory = [report.siteQuality];
        supportingScouts = [report.scoutId];
        voteStrength = report.siteQuality;
        isViable = report.siteQuality > 0.3;
        isSelected = false;
        discoveredAt = state.beatNum;
        discoveredBy = report.scoutId;
      }])
    };
    
    // Update voting
    var siteVotes : [(Nat, Float)] = [];
    for (site in finalCandidates.vals()) {
      siteVotes := Array.append(siteVotes, [(site.siteId, site.voteStrength)]);
    };
    
    // Find leading site
    var maxVote : Float = 0.0;
    var leadId : ?Nat = null;
    for ((id, vote) in siteVotes.vals()) {
      if (vote > maxVote) {
        maxVote := vote;
        leadId := ?id;
      };
    };
    
    // Compute quorum
    let totalScouts = Float.fromInt(state.scoutIds.size());
    var votingScouts : Nat = 0;
    for (site in finalCandidates.vals()) {
      votingScouts += site.supportingScouts.size();
    };
    // Deduplicate (scouts may visit multiple sites)
    let currentQuorum = Float.fromInt(votingScouts) / totalScouts;
    
    // Compute consensus (entropy)
    var totalVotes : Float = 0.0;
    for ((_, v) in siteVotes.vals()) { totalVotes += v };
    var entropy : Float = 0.0;
    if (totalVotes > 0.0) {
      for ((_, v) in siteVotes.vals()) {
        let p = v / totalVotes;
        if (p > 0.01) {
          entropy -= p * Float.log(p);
        };
      };
    };
    let maxEntropy = Float.log(Float.fromInt(siteVotes.size() + 1));
    let consensusLevel = if (maxEntropy > 0.0) { 1.0 - entropy / maxEntropy } else { 1.0 };
    
    // Check if decision reached
    let decisionMade = maxVote / totalScouts > state.votingState.quorumThreshold and consensusLevel > 0.7;
    
    {
      phase = state.phase;
      phaseStartBeat = state.phaseStartBeat;
      scoutIds = state.scoutIds;
      scoutReports = Array.append(state.scoutReports, [report]);
      candidateSites = finalCandidates;
      votingState = {
        quorumThreshold = state.votingState.quorumThreshold;
        currentQuorum = currentQuorum;
        siteVotes = siteVotes;
        leadingSite = leadId;
        leadStrength = maxVote;
        consensusLevel = consensusLevel;
        votingEntropy = entropy;
        roundNumber = state.votingState.roundNumber;
        deadlockCount = state.votingState.deadlockCount;
        decisionMade = decisionMade;
        decisionBeat = if (decisionMade and state.votingState.decisionBeat == null) { ?state.beatNum } else { state.votingState.decisionBeat };
      };
      queenId = state.queenId;
      queenPosition = state.queenPosition;
      queenEscorts = state.queenEscorts;
      clusterCenter = state.clusterCenter;
      clusterRadius = state.clusterRadius;
      clusterDensity = state.clusterDensity;
      targetSite = if (decisionMade) {
        switch (leadId) {
          case (?id) {
            var found : ?NestSiteCandidate = null;
            for (site in finalCandidates.vals()) {
              if (site.siteId == id) { found := ?site };
            };
            found
          };
          case null { null };
        }
      } else { state.targetSite };
      movementSpeed = state.movementSpeed;
      movementHeading = state.movementHeading;
      clusterTemperature = state.clusterTemperature;
      ambientTemperature = state.ambientTemperature;
      beatNum = state.beatNum;
    }
  };

  /// Update migration phase
  public func updateMigrationPhase(
    state: SwarmMigrationState,
    swarmCoherence: Float,
    dt: Float
  ) : SwarmMigrationState {
    let timeSincePhaseStart = state.beatNum - state.phaseStartBeat;
    
    let newPhase : MigrationPhase = switch (state.phase) {
      case (#Clustering) {
        // Ready to scout when cluster is formed
        if (state.clusterDensity > 0.7 and timeSincePhaseStart > 100) {
          #Scouting
        } else { #Clustering }
      };
      case (#Scouting) {
        // Move to deliberating when we have candidates
        if (state.candidateSites.size() > 0 and timeSincePhaseStart > 200) {
          #Deliberating
        } else { #Scouting }
      };
      case (#Deliberating) {
        // Decision made
        if (state.votingState.decisionMade) {
          #Preparing
        } else if (timeSincePhaseStart > 1000) {
          // Deadlock - restart scouting
          #Scouting
        } else { #Deliberating }
      };
      case (#Preparing) {
        // Warm up complete
        if (state.clusterTemperature > 38.0 and timeSincePhaseStart > 50) {
          #Launching
        } else { #Preparing }
      };
      case (#Launching) {
        // All drones airborne
        if (swarmCoherence > 0.8 and timeSincePhaseStart > 30) {
          #Flying
        } else { #Launching }
      };
      case (#Flying) {
        // Near target
        switch (state.targetSite) {
          case (?site) {
            let dist = haversineDistance(
              state.clusterCenter.lat, state.clusterCenter.lon,
              site.location.lat, site.location.lon
            );
            if (dist < 100.0) { #Approaching } else { #Flying }
          };
          case null { #Flying };
        }
      };
      case (#Approaching) {
        switch (state.targetSite) {
          case (?site) {
            let dist = haversineDistance(
              state.clusterCenter.lat, state.clusterCenter.lon,
              site.location.lat, site.location.lon
            );
            if (dist < 20.0) { #Landing } else { #Approaching }
          };
          case null { #Approaching };
        }
      };
      case (#Landing) {
        if (state.movementSpeed < 0.5 and state.clusterDensity > 0.8) {
          #Establishing
        } else { #Landing }
      };
      case (#Establishing) { #Establishing };  // Terminal state
    };
    
    let phaseChanged = switch (state.phase, newPhase) {
      case (#Clustering, #Clustering) { false };
      case (#Scouting, #Scouting) { false };
      case (#Deliberating, #Deliberating) { false };
      case (#Preparing, #Preparing) { false };
      case (#Launching, #Launching) { false };
      case (#Flying, #Flying) { false };
      case (#Approaching, #Approaching) { false };
      case (#Landing, #Landing) { false };
      case (#Establishing, #Establishing) { false };
      case _ { true };
    };
    
    // Update temperature (bees shiver to warm up before flight)
    var newTemp = state.clusterTemperature;
    switch (newPhase) {
      case (#Preparing) {
        // Shivering warms up
        newTemp := state.clusterTemperature + 0.5 * dt;
      };
      case (#Flying) {
        // Cooling during flight
        newTemp := state.clusterTemperature * 0.99 + state.ambientTemperature * 0.01;
      };
      case _ {
        // Maintain temperature
        if (state.clusterTemperature < 35.0) {
          newTemp := state.clusterTemperature + 0.1;
        } else if (state.clusterTemperature > 36.0) {
          newTemp := state.clusterTemperature - 0.05;
        };
      };
    };
    
    // Update movement
    var newSpeed = state.movementSpeed;
    var newHeading = state.movementHeading;
    
    switch (newPhase) {
      case (#Flying) {
        switch (state.targetSite) {
          case (?site) {
            newHeading := Float.arctan2(
              site.location.lon - state.clusterCenter.lon,
              site.location.lat - state.clusterCenter.lat
            );
            newSpeed := Float.min(state.movementSpeed + 2.0 * dt, 15.0);  // Max 15 m/s
          };
          case null { };
        };
      };
      case (#Approaching) {
        newSpeed := Float.max(state.movementSpeed - 1.0 * dt, 3.0);  // Slow down
      };
      case (#Landing) {
        newSpeed := Float.max(state.movementSpeed - 2.0 * dt, 0.0);  // Stop
      };
      case _ {
        newSpeed := 0.0;
      };
    };
    
    {
      phase = newPhase;
      phaseStartBeat = if (phaseChanged) { state.beatNum } else { state.phaseStartBeat };
      scoutIds = state.scoutIds;
      scoutReports = state.scoutReports;
      candidateSites = state.candidateSites;
      votingState = state.votingState;
      queenId = state.queenId;
      queenPosition = state.queenPosition;
      queenEscorts = state.queenEscorts;
      clusterCenter = state.clusterCenter;
      clusterRadius = state.clusterRadius;
      clusterDensity = state.clusterDensity;
      targetSite = state.targetSite;
      movementSpeed = newSpeed;
      movementHeading = newHeading;
      clusterTemperature = newTemp;
      ambientTemperature = state.ambientTemperature;
      beatNum = state.beatNum + 1;
    }
  };

  /// Haversine distance in meters
  func haversineDistance(lat1: Float, lon1: Float, lat2: Float, lon2: Float) : Float {
    let R = 6371000.0;  // Earth radius in meters
    let dLat = (lat2 - lat1) * PI / 180.0;
    let dLon = (lon2 - lon1) * PI / 180.0;
    let a = Float.sin(dLat/2.0) ** 2.0 + 
            Float.cos(lat1 * PI / 180.0) * Float.cos(lat2 * PI / 180.0) * 
            Float.sin(dLon/2.0) ** 2.0;
    let c = 2.0 * Float.arctan2(Float.sqrt(a), Float.sqrt(1.0 - a));
    R * c
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 26: EMERGENT SWARM BEHAVIORS — COLLECTIVE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Emergent behaviors that arise from simple local rules:
  //   • Thermoregulation - Cluster tightens/loosens to regulate temperature
  //   • Predator response - Coordinated defensive behaviors
  //   • Resource allocation - Dynamic task switching
  //   • Information cascade - Rapid signal propagation
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Emergent behavior state
  public type EmergentBehaviorState = {
    // Thermoregulation
    thermoregulation : ThermoregulationState;
    
    // Predator response
    predatorResponse : PredatorResponseState;
    
    // Information cascade
    infoCascade     : InformationCascadeState;
    
    // Task allocation
    taskAllocation  : TaskAllocationState;
    
    // Stigmergy (indirect communication through environment)
    stigmergy       : StigmergyState;
  };

  /// Thermoregulation state
  public type ThermoregulationState = {
    // Current temperature map
    temperatureField : [[Float]];
    
    // Core temperature
    coreTemp        : Float;
    
    // Target temperature
    targetTemp      : Float;
    
    // Behavior modes
    fanningCount    : Nat;         // Drones cooling with wings
    shiveringCount  : Nat;         // Drones warming
    insulatingCount : Nat;         // Drones on outer layer
    
    // Heat transfer
    heatGeneration  : Float;       // From activity
    heatLoss        : Float;       // To environment
    
    // Metabolic cost
    thermalCost     : Float;
  };

  /// Predator response state
  public type PredatorResponseState = {
    // Threat status
    threatDetected  : Bool;
    threatType      : Text;
    threatPosition  : ?{ x: Float; y: Float; z: Float };
    threatLevel     : Float;
    
    // Response type
    currentResponse : PredatorResponseType;
    
    // Wave formation
    waveActive      : Bool;
    waveCenter      : ?{ x: Float; y: Float };
    wavePhase       : Float;
    
    // Defensive formation
    defenseFormation : DefenseFormationType;
    
    // Alarm propagation
    alarmLevel      : [Float];     // Per drone
    alarmDecay      : Float;
  };

  /// Predator response types
  public type PredatorResponseType = {
    #None;
    #Alert;           // Increased vigilance
    #Shimmer;         // Coordinated wing flashing (bees do this!)
    #Ball;            // Form defensive ball around threat
    #Disperse;        // Scatter to confuse
    #Attack;          // Coordinated attack
    #Flee;            // Retreat as unit
  };

  /// Defense formation types
  public type DefenseFormationType = {
    #Normal;
    #Compact;         // Tight ball
    #Hollow;          // Sphere with empty center
    #Layered;         // Concentric shells
    #Spiky;           // Drones pointing outward
  };

  /// Information cascade state
  public type InformationCascadeState = {
    // Active cascades
    activeCascades  : [Cascade];
    
    // Cascade metrics
    averageSpeed    : Float;       // How fast info spreads
    reachFraction   : Float;       // What fraction received
    distortion      : Float;       // Signal degradation
    
    // Network topology effect
    networkDensity  : Float;
    averagePathLength : Float;
  };

  /// Information cascade
  public type Cascade = {
    cascadeId       : Nat;
    infoType        : Text;
    originDrone     : Nat;
    startBeat       : Nat;
    
    // Propagation
    infectedDrones  : [Nat];       // Who has received
    frontier        : [Nat];       // Currently spreading from
    
    // Content
    payload         : [Float];
    priority        : Float;
    
    // Decay
    strength        : Float;
    decayRate       : Float;
  };

  /// Task allocation state
  public type TaskAllocationState = {
    // Available tasks
    tasks           : [SwarmTask];
    
    // Current allocation
    allocation      : [(Nat, Nat)];  // (droneId, taskId)
    
    // Thresholds (response threshold model)
    thresholds      : [[Float]];    // [droneId][taskId]
    
    // Stimuli (task demand)
    stimuli         : [Float];      // Per task type
    
    // Efficiency metrics
    taskCompletion  : [Float];
    idleFraction    : Float;
    overlapFraction : Float;
  };

  /// Swarm task
  public type SwarmTask = {
    taskId          : Nat;
    taskType        : Text;
    location        : ?{ lat: Float; lon: Float; alt: Float };
    priority        : Float;
    requiredDrones  : Nat;
    assignedDrones  : [Nat];
    progress        : Float;
    deadline        : ?Nat;
  };

  /// Stigmergy state (indirect communication)
  public type StigmergyState = {
    // Pheromone fields
    trailField      : [[Float]];   // Path pheromones
    alarmField      : [[Float]];   // Danger pheromones
    recruitField    : [[Float]];   // Help-wanted pheromones
    foodField       : [[Float]];   // Resource markers
    
    // Field parameters
    evaporationRate : Float;
    diffusionRate   : Float;
    depositionRate  : Float;
    
    // Grid info
    gridResolution  : Float;       // Meters per cell
    gridOrigin      : { lat: Float; lon: Float };
  };

  /// Initialize emergent behavior state
  public func initEmergentBehaviors(gridSize: Nat, gridRes: Float, origin: { lat: Float; lon: Float }) : EmergentBehaviorState {
    let emptyGrid = Array.tabulate<[Float]>(gridSize, func(_) {
      Array.tabulate<Float>(gridSize, func(_) { 0.0 })
    });
    
    {
      thermoregulation = {
        temperatureField = emptyGrid;
        coreTemp = 35.0;
        targetTemp = 35.0;
        fanningCount = 0;
        shiveringCount = 0;
        insulatingCount = 0;
        heatGeneration = 0.0;
        heatLoss = 0.0;
        thermalCost = 0.0;
      };
      predatorResponse = {
        threatDetected = false;
        threatType = "none";
        threatPosition = null;
        threatLevel = 0.0;
        currentResponse = #None;
        waveActive = false;
        waveCenter = null;
        wavePhase = 0.0;
        defenseFormation = #Normal;
        alarmLevel = [];
        alarmDecay = 0.1;
      };
      infoCascade = {
        activeCascades = [];
        averageSpeed = 0.0;
        reachFraction = 0.0;
        distortion = 0.0;
        networkDensity = 0.5;
        averagePathLength = 3.0;
      };
      taskAllocation = {
        tasks = [];
        allocation = [];
        thresholds = [[]];
        stimuli = [];
        taskCompletion = [];
        idleFraction = 0.0;
        overlapFraction = 0.0;
      };
      stigmergy = {
        trailField = emptyGrid;
        alarmField = emptyGrid;
        recruitField = emptyGrid;
        foodField = emptyGrid;
        evaporationRate = 0.01;
        diffusionRate = 0.05;
        depositionRate = 1.0;
        gridResolution = gridRes;
        gridOrigin = origin;
      };
    }
  };

  /// Bee shimmer defense (beautiful coordinated wave)
  public func computeShimmerWave(
    dronePositions: [{ x: Float; y: Float }],
    threatPosition: { x: Float; y: Float },
    wavePhase: Float,
    waveSpeed: Float
  ) : [Float] {
    // Each drone raises wings when wave passes through
    Array.tabulate<Float>(dronePositions.size(), func(i) {
      let pos = dronePositions[i];
      let dist = Float.sqrt((pos.x - threatPosition.x) ** 2.0 + (pos.y - threatPosition.y) ** 2.0);
      let wavePosition = wavePhase * waveSpeed;
      let waveWidth = 2.0;  // meters
      
      // Gaussian wave profile
      let phase = (dist - wavePosition) / waveWidth;
      let intensity = Float.exp(-phase * phase);
      
      // 0 = wings down, 1 = wings up
      intensity
    })
  };

  /// Update thermoregulation (bees maintain 35°C!)
  public func updateThermoregulation(
    state: ThermoregulationState,
    droneStates: [{ position: { x: Float; y: Float; z: Float }; activity: Float }],
    ambientTemp: Float,
    clusterRadius: Float,
    dt: Float
  ) : ThermoregulationState {
    // Surface area to volume ratio
    let surfaceArea = 4.0 * PI * clusterRadius * clusterRadius;
    let volume = (4.0 / 3.0) * PI * clusterRadius * clusterRadius * clusterRadius;
    let saRatio = surfaceArea / volume;
    
    // Heat generation from activity
    var totalHeat : Float = 0.0;
    for (drone in droneStates.vals()) {
      totalHeat += drone.activity * 0.1;  // Heat per unit activity
    };
    
    // Heat loss to environment
    let heatLoss = saRatio * (state.coreTemp - ambientTemp) * 0.01;
    
    // Temperature change
    let heatCapacity = volume * 1.0;  // Simplified
    let dTemp = (totalHeat - heatLoss) / heatCapacity * dt;
    let newCoreTemp = state.coreTemp + dTemp;
    
    // Behavioral response
    var fanningCount = 0;
    var shiveringCount = 0;
    var insulatingCount = 0;
    
    if (newCoreTemp > state.targetTemp + 1.0) {
      // Too hot - need fanning
      fanningCount := droneStates.size() / 5;
    } else if (newCoreTemp < state.targetTemp - 1.0) {
      // Too cold - need shivering
      shiveringCount := droneStates.size() / 3;
      insulatingCount := droneStates.size() / 4;
    };
    
    {
      temperatureField = state.temperatureField;
      coreTemp = newCoreTemp;
      targetTemp = state.targetTemp;
      fanningCount = fanningCount;
      shiveringCount = shiveringCount;
      insulatingCount = insulatingCount;
      heatGeneration = totalHeat;
      heatLoss = heatLoss;
      thermalCost = Float.fromInt(fanningCount + shiveringCount) * 0.1;
    }
  };

  /// Response threshold task allocation
  public func allocateTasks(
    state: TaskAllocationState,
    droneIds: [Nat],
    dt: Float
  ) : TaskAllocationState {
    var newAllocation : [(Nat, Nat)] = [];
    var newStimuli = state.stimuli;
    
    for (droneId in droneIds.vals()) {
      // Find best task for this drone
      var bestTask : ?Nat = null;
      var bestProb : Float = 0.0;
      
      for (task in state.tasks.vals()) {
        // Get threshold (or default)
        let threshold = if (droneId < state.thresholds.size() and task.taskId < state.thresholds[droneId].size()) {
          state.thresholds[droneId][task.taskId]
        } else { 0.5 };
        
        // Get stimulus
        let stimulus = if (task.taskId < newStimuli.size()) { newStimuli[task.taskId] } else { 0.0 };
        
        // Response probability (sigmoidal threshold model)
        let prob = stimulus * stimulus / (stimulus * stimulus + threshold * threshold);
        
        if (prob > bestProb and prob > 0.3) {  // Minimum probability to engage
          bestProb := prob;
          bestTask := ?task.taskId;
        };
      };
      
      switch (bestTask) {
        case (?taskId) {
          newAllocation := Array.append(newAllocation, [(droneId, taskId)]);
          // Reduce stimulus for allocated task
          let stimMut = Array.thaw<Float>(newStimuli);
          if (taskId < stimMut.size()) {
            stimMut[taskId] := Float.max(stimMut[taskId] - 0.1, 0.0);
          };
          newStimuli := Array.freeze(stimMut);
        };
        case null { };
      };
    };
    
    {
      tasks = state.tasks;
      allocation = newAllocation;
      thresholds = state.thresholds;
      stimuli = newStimuli;
      taskCompletion = state.taskCompletion;
      idleFraction = Float.fromInt(droneIds.size() - newAllocation.size()) / Float.fromInt(droneIds.size());
      overlapFraction = state.overlapFraction;
    }
  };

  /// Update stigmergy fields (pheromone-like)
  public func updateStigmergy(
    state: StigmergyState,
    deposits: [{ x: Nat; y: Nat; fieldType: Text; amount: Float }],
    dt: Float
  ) : StigmergyState {
    let size = state.trailField.size();
    
    // Process deposits
    let trailMut = Array.thaw<[Float]>(state.trailField);
    let alarmMut = Array.thaw<[Float]>(state.alarmField);
    let recruitMut = Array.thaw<[Float]>(state.recruitField);
    let foodMut = Array.thaw<[Float]>(state.foodField);
    
    for (deposit in deposits.vals()) {
      if (deposit.x < size and deposit.y < size) {
        switch (deposit.fieldType) {
          case "trail" {
            let row = Array.thaw<Float>(trailMut[deposit.y]);
            row[deposit.x] := row[deposit.x] + deposit.amount * state.depositionRate;
            trailMut[deposit.y] := Array.freeze(row);
          };
          case "alarm" {
            let row = Array.thaw<Float>(alarmMut[deposit.y]);
            row[deposit.x] := row[deposit.x] + deposit.amount * state.depositionRate;
            alarmMut[deposit.y] := Array.freeze(row);
          };
          case "recruit" {
            let row = Array.thaw<Float>(recruitMut[deposit.y]);
            row[deposit.x] := row[deposit.x] + deposit.amount * state.depositionRate;
            recruitMut[deposit.y] := Array.freeze(row);
          };
          case "food" {
            let row = Array.thaw<Float>(foodMut[deposit.y]);
            row[deposit.x] := row[deposit.x] + deposit.amount * state.depositionRate;
            foodMut[deposit.y] := Array.freeze(row);
          };
          case _ { };
        };
      };
    };
    
    // Evaporation and diffusion
    for (y in Iter.range(0, size - 1)) {
      let trailRow = Array.thaw<Float>(trailMut[y]);
      let alarmRow = Array.thaw<Float>(alarmMut[y]);
      let recruitRow = Array.thaw<Float>(recruitMut[y]);
      let foodRow = Array.thaw<Float>(foodMut[y]);
      
      for (x in Iter.range(0, size - 1)) {
        // Evaporation
        trailRow[x] := trailRow[x] * (1.0 - state.evaporationRate * dt);
        alarmRow[x] := alarmRow[x] * (1.0 - state.evaporationRate * 2.0 * dt);  // Alarm evaporates faster
        recruitRow[x] := recruitRow[x] * (1.0 - state.evaporationRate * dt);
        foodRow[x] := foodRow[x] * (1.0 - state.evaporationRate * 0.5 * dt);  // Food markers last longer
      };
      
      trailMut[y] := Array.freeze(trailRow);
      alarmMut[y] := Array.freeze(alarmRow);
      recruitMut[y] := Array.freeze(recruitRow);
      foodMut[y] := Array.freeze(foodRow);
    };
    
    {
      trailField = Array.freeze(trailMut);
      alarmField = Array.freeze(alarmMut);
      recruitField = Array.freeze(recruitMut);
      foodField = Array.freeze(foodMut);
      evaporationRate = state.evaporationRate;
      diffusionRate = state.diffusionRate;
      depositionRate = state.depositionRate;
      gridResolution = state.gridResolution;
      gridOrigin = state.gridOrigin;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 27: COMPLETE SWARM ORGANISM — INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Complete swarm organism state
  public type CompleteSwarmOrganism = {
    // Core swarm brain
    swarmBrain      : SwarmBrainState;
    
    // Migration state
    migration       : SwarmMigrationState;
    
    // Emergent behaviors
    emergent        : EmergentBehaviorState;
    
    // Colony metrics
    colonyHealth    : Float;
    colonyEfficiency : Float;
    colonyResilience : Float;
    
    // Population dynamics
    populationSize  : Nat;
    birthRate       : Float;
    deathRate       : Float;
    
    beatNum         : Nat;
  };

  /// Initialize complete swarm organism
  public func initCompleteSwarmOrganism(
    numDrones: Nat,
    baseLat: Float,
    baseLon: Float,
    baseAlt: Float
  ) : CompleteSwarmOrganism {
    let swarmBrain = initSwarmBrain(numDrones, baseLat, baseLon, baseAlt);
    let migration = initMigrationState(numDrones, { lat = baseLat; lon = baseLon; alt = baseAlt }, 20.0);
    let emergent = initEmergentBehaviors(50, 10.0, { lat = baseLat; lon = baseLon });
    
    {
      swarmBrain = swarmBrain;
      migration = migration;
      emergent = emergent;
      colonyHealth = 1.0;
      colonyEfficiency = 0.5;
      colonyResilience = 0.8;
      populationSize = numDrones;
      birthRate = 0.0;
      deathRate = 0.0;
      beatNum = 0;
    }
  };

  /// Tick complete swarm organism
  public func tickCompleteSwarmOrganism(
    state: CompleteSwarmOrganism,
    externalInputs: {
      threats: [{ x: Float; y: Float; z: Float; level: Float }];
      resources: [{ lat: Float; lon: Float; quality: Float }];
      ambientTemp: Float;
    },
    dt: Float
  ) : CompleteSwarmOrganism {
    // 1. Update swarm brain
    let newSwarmBrain = tickSwarmBrain(state.swarmBrain, dt);
    
    // 2. Update migration
    let newMigration = updateMigrationPhase(state.migration, newSwarmBrain.swarmCoherence, dt);
    
    // 3. Update thermoregulation
    let droneStates = Array.map<BeeDroneState, { position: { x: Float; y: Float; z: Float }; activity: Float }>(
      newSwarmBrain.drones,
      func(d) { { position = { x = d.physical.longitude * 111000.0; y = d.physical.latitude * 111000.0; z = d.physical.altitude }; activity = 0.5 } }
    );
    let newThermo = updateThermoregulation(
      state.emergent.thermoregulation,
      droneStates,
      externalInputs.ambientTemp,
      state.swarmBrain.swarmCoherence * 10.0,  // Cluster radius
      dt
    );
    
    // 4. Update predator response
    var newPredatorResponse = state.emergent.predatorResponse;
    if (externalInputs.threats.size() > 0) {
      let threat = externalInputs.threats[0];
      newPredatorResponse := {
        threatDetected = true;
        threatType = "predator";
        threatPosition = ?threat;
        threatLevel = threat.level;
        currentResponse = if (threat.level > 0.7) { #Ball } else if (threat.level > 0.4) { #Shimmer } else { #Alert };
        waveActive = threat.level > 0.4;
        waveCenter = ?{ x = threat.x; y = threat.y };
        wavePhase = newPredatorResponse.wavePhase + dt * 2.0;
        defenseFormation = if (threat.level > 0.7) { #Compact } else { #Normal };
        alarmLevel = newPredatorResponse.alarmLevel;
        alarmDecay = newPredatorResponse.alarmDecay;
      };
    };
    
    let newEmergent : EmergentBehaviorState = {
      thermoregulation = newThermo;
      predatorResponse = newPredatorResponse;
      infoCascade = state.emergent.infoCascade;
      taskAllocation = state.emergent.taskAllocation;
      stigmergy = state.emergent.stigmergy;
    };
    
    // 5. Compute colony metrics
    let colonyHealth = newSwarmBrain.swarmCoherence * 0.4 + newThermo.coreTemp / 40.0 * 0.3 + 
                       (1.0 - newPredatorResponse.threatLevel) * 0.3;
    
    {
      swarmBrain = newSwarmBrain;
      migration = newMigration;
      emergent = newEmergent;
      colonyHealth = colonyHealth;
      colonyEfficiency = state.colonyEfficiency * 0.99 + 0.01 * (1.0 - state.emergent.taskAllocation.idleFraction);
      colonyResilience = state.colonyResilience * 0.99 + 0.01 * (1.0 - newPredatorResponse.threatLevel);
      populationSize = newSwarmBrain.drones.size();
      birthRate = state.birthRate;
      deathRate = state.deathRate;
      beatNum = state.beatNum + 1;
    }
  };

  /// Generate complete swarm output
  public type CompleteSwarmOutput = {
    // Swarm metrics
    swarmCoherence  : Float;
    swarmSize       : Nat;
    centroid        : { lat: Float; lon: Float; alt: Float };
    
    // Migration
    migrationPhase  : MigrationPhase;
    targetSite      : ?{ lat: Float; lon: Float; alt: Float };
    migrationProgress : Float;
    
    // Temperature
    coreTemperature : Float;
    fanningDrones   : Nat;
    shiveringDrones : Nat;
    
    // Defense
    threatLevel     : Float;
    defenseResponse : PredatorResponseType;
    
    // Colony
    colonyHealth    : Float;
    colonyEfficiency : Float;
    
    beatNum         : Nat;
  };

  public func generateCompleteSwarmOutput(state: CompleteSwarmOrganism) : CompleteSwarmOutput {
    {
      swarmCoherence = state.swarmBrain.swarmCoherence;
      swarmSize = state.populationSize;
      centroid = state.swarmBrain.swarmCentroid;
      migrationPhase = state.migration.phase;
      targetSite = switch (state.migration.targetSite) {
        case (?site) { ?site.location };
        case null { null };
      };
      migrationProgress = switch (state.migration.phase) {
        case (#Establishing) { 1.0 };
        case (#Landing) { 0.95 };
        case (#Approaching) { 0.85 };
        case (#Flying) { 0.5 };
        case (#Launching) { 0.3 };
        case (#Preparing) { 0.2 };
        case (#Deliberating) { 0.15 };
        case (#Scouting) { 0.1 };
        case (#Clustering) { 0.05 };
      };
      coreTemperature = state.emergent.thermoregulation.coreTemp;
      fanningDrones = state.emergent.thermoregulation.fanningCount;
      shiveringDrones = state.emergent.thermoregulation.shiveringCount;
      threatLevel = state.emergent.predatorResponse.threatLevel;
      defenseResponse = state.emergent.predatorResponse.currentResponse;
      colonyHealth = state.colonyHealth;
      colonyEfficiency = state.colonyEfficiency;
      beatNum = state.beatNum;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ███████╗██╗    ██╗ █████╗ ██████╗ ███╗   ███╗    ████████╗ █████╗  ██████╗████████╗██╗ ██████╗███████╗
  // ██╔════╝██║    ██║██╔══██╗██╔══██╗████╗ ████║    ╚══██╔══╝██╔══██╗██╔════╝╚══██╔══╝██║██╔════╝██╔════╝
  // ███████╗██║ █╗ ██║███████║██████╔╝██╔████╔██║       ██║   ███████║██║        ██║   ██║██║     ███████╗
  // ╚════██║██║███╗██║██╔══██║██╔══██╗██║╚██╔╝██║       ██║   ██╔══██║██║        ██║   ██║██║     ╚════██║
  // ███████║╚███╔███╔╝██║  ██║██║  ██║██║ ╚═╝ ██║       ██║   ██║  ██║╚██████╗   ██║   ██║╚██████╗███████║
  // ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝       ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝╚══════╝
  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 20: ADVANCED SWARM TACTICS — REAL DRONE WARFARE
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Advanced tactical behaviors for drone swarms:
  //   • Attack formations
  //   • Evasion patterns
  //   • Target acquisition and tracking
  //   • Swarm combat maneuvers
  //   • Electronic warfare support
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Tactical state
  public type TacticalState = {
    // Current tactical mode
    tacticalMode      : TacticalMode;
    
    // Targets
    targets           : [TacticalTarget];
    primaryTarget     : ?Nat;
    
    // Threat assessment
    threatAssessment  : ThreatAssessmentState;
    
    // Attack
    attackState       : AttackState;
    
    // Defense
    defenseState      : DefenseState;
    
    // Electronic warfare
    ewState           : ElectronicWarfareState;
    
    // Coordination
    tacticalCoordination : TacticalCoordinationState;
    
    beatNum           : Nat;
  };

  /// Tactical modes
  public type TacticalMode = {
    #Patrol;          // Searching for targets
    #Approach;        // Moving toward target area
    #Attack;          // Active engagement
    #Retreat;         // Tactical withdrawal
    #Evade;           // Evasive maneuvers
    #Support;         // Supporting other drones
    #Recon;           // Reconnaissance
    #Standby;         // Waiting for orders
  };

  /// Tactical target
  public type TacticalTarget = {
    targetId          : Nat;
    targetType        : TargetType;
    
    // Position
    position          : { lat: Float; lon: Float; alt: Float };
    velocity          : { vx: Float; vy: Float; vz: Float };
    heading           : Float;
    
    // State estimation
    positionUncertainty : Float;
    lastUpdateBeat    : Nat;
    trackingConfidence : Float;
    
    // Threat level
    threatLevel       : Float;
    
    // Engagement
    engagementStatus  : EngagementStatus;
    assignedDrones    : [Nat];
    
    // Classification
    classification    : Text;
    classificationConfidence : Float;
  };

  /// Target types
  public type TargetType = {
    #HostileDrone;
    #GroundVehicle;
    #Aircraft;
    #Ship;
    #Structure;
    #Person;
    #Unknown;
  };

  /// Engagement status
  public type EngagementStatus = {
    #Unassigned;
    #Tracking;
    #Approaching;
    #Engaging;
    #Neutralized;
    #Lost;
  };

  /// Threat assessment state
  public type ThreatAssessmentState = {
    // Overall threat level
    overallThreat     : Float;
    
    // Threat sources
    threatSources     : [ThreatSource];
    
    // Area threat map
    threatMap         : [[Float]];
    threatMapResolution : Float;
    
    // Predicted threats
    predictedThreats  : [{ position: { lat: Float; lon: Float }; time: Nat; probability: Float }];
    
    // Safe corridors
    safeCorridors     : [SafeCorridor];
  };

  /// Threat source
  public type ThreatSource = {
    sourceId          : Nat;
    sourceType        : Text;
    position          : { lat: Float; lon: Float; alt: Float };
    effectiveRange    : Float;
    lethality         : Float;
    isActive          : Bool;
    lastDetection     : Nat;
  };

  /// Safe corridor
  public type SafeCorridor = {
    corridorId        : Nat;
    waypoints         : [{ lat: Float; lon: Float; alt: Float }];
    width             : Float;
    safetyRating      : Float;
    expirationBeat    : Nat;
  };

  /// Attack state
  public type AttackState = {
    // Attack formation
    attackFormation   : AttackFormation;
    
    // Weapons status
    weaponsArmed      : Bool;
    payloadRemaining  : Nat;
    
    // Attack vectors
    attackVectors     : [AttackVector];
    selectedVector    : ?Nat;
    
    // Timing
    attackPhase       : AttackPhase;
    timeToTarget      : Float;
    
    // Rules of engagement
    roeLevel          : Nat;           // 0 = weapons free, 5 = weapons hold
    requiresConfirmation : Bool;
    
    // Battle damage assessment
    bdaScore          : Float;
  };

  /// Attack formations
  public type AttackFormation = {
    #Line;            // Line abreast
    #Echelon;         // Stepped formation
    #Wedge;           // V-formation attack
    #Column;          // Single file
    #Swarm;           // Distributed attack
    #Pincer;          // Flanking attack
  };

  /// Attack vector
  public type AttackVector = {
    vectorId          : Nat;
    approachHeading   : Float;
    approachAltitude  : Float;
    attackAngle       : Float;
    riskLevel         : Float;
    successProbability : Float;
    collateralRisk    : Float;
  };

  /// Attack phases
  public type AttackPhase = {
    #Planning;
    #Ingress;
    #Acquisition;
    #Engagement;
    #Egress;
    #Assessment;
  };

  /// Defense state
  public type DefenseState = {
    // Defense posture
    defensivePosture  : DefensivePosture;
    
    // Evasion
    evasionState      : EvasionState;
    
    // Countermeasures
    countermeasures   : CountermeasureState;
    
    // Shield formation
    shieldFormation   : ?ShieldFormation;
    
    // Damage control
    damageControlActive : Bool;
    criticalSystemsProtected : Bool;
  };

  /// Defensive postures
  public type DefensivePosture = {
    #Normal;          // Standard awareness
    #Heightened;      // Increased vigilance
    #Defensive;       // Active defense
    #Evasive;         // Primary focus on survival
  };

  /// Evasion state
  public type EvasionState = {
    // Current maneuver
    currentManeuver   : ?EvasiveManeuver;
    
    // Predicted incoming
    incomingThreats   : [{ direction: Float; timeToImpact: Float }];
    
    // Evasion success rate
    evasionSuccessRate : Float;
    
    // Energy budget for evasion
    evasionEnergy     : Float;
  };

  /// Evasive maneuvers
  public type EvasiveManeuver = {
    #Break;           // Hard turn
    #Dive;            // Rapid descent
    #Climb;           // Rapid ascent
    #Jink;            // Random movements
    #Spiral;          // Corkscrew
    #SplitS;          // Dive and reverse
    #BarrelRoll;
  };

  /// Countermeasure state
  public type CountermeasureState = {
    // Chaff/flares
    chaffRemaining    : Nat;
    flaresRemaining   : Nat;
    
    // Jamming
    jammingActive     : Bool;
    jammingFrequency  : Float;
    
    // Decoys
    decoysDeployed    : Nat;
    decoysRemaining   : Nat;
    
    // Last deployment
    lastDeploymentBeat : Nat;
    cooldownRemaining : Nat;
  };

  /// Shield formation
  public type ShieldFormation = {
    formationType     : Text;
    protectedDrones   : [Nat];
    shieldDrones      : [Nat];
    formationRadius   : Float;
  };

  /// Electronic warfare state
  public type ElectronicWarfareState = {
    // Jamming
    jammingState      : JammingState;
    
    // Detection
    radarDetection    : RadarDetectionState;
    
    // Spoofing
    spoofingState     : SpoofingState;
    
    // SIGINT
    sigintState       : SigintState;
    
    // Cyber
    cyberState        : CyberState;
  };

  /// Jamming state
  public type JammingState = {
    isJamming         : Bool;
    targetFrequencies : [Float];
    jammingPower      : Float;
    jammingPattern    : Text;
    effectivenessEstimate : Float;
    powerConsumption  : Float;
  };

  /// Radar detection state
  public type RadarDetectionState = {
    // Detected emitters
    detectedEmitters  : [RadarEmitter];
    
    // Warning
    radarWarningActive : Bool;
    lockOnDetected    : Bool;
    
    // Signature management
    currentRCS        : Float;         // Radar cross-section
    rcsReductionMode  : Bool;
  };

  /// Radar emitter
  public type RadarEmitter = {
    emitterId         : Nat;
    frequency         : Float;
    pulseRepetition   : Float;
    estimatedPosition : { lat: Float; lon: Float };
    signalStrength    : Float;
    emitterType       : Text;
    threatLevel       : Float;
  };

  /// Spoofing state
  public type SpoofingState = {
    gpsSpoofingActive : Bool;
    spoofedPosition   : ?{ lat: Float; lon: Float };
    commsSpoofingActive : Bool;
    spoofedIdentity   : ?Nat;
  };

  /// SIGINT state
  public type SigintState = {
    // Intercepted signals
    interceptedSignals : [InterceptedSignal];
    
    // Analysis
    analysisInProgress : Bool;
    decodedMessages   : [Text];
  };

  /// Intercepted signal
  public type InterceptedSignal = {
    signalId          : Nat;
    frequency         : Float;
    timestamp         : Nat;
    signalType        : Text;
    direction         : Float;
    content           : ?[Nat8];
  };

  /// Cyber state
  public type CyberState = {
    // Attacks
    activeAttacks     : [CyberAttack];
    
    // Defense
    firewallActive    : Bool;
    intrusionDetected : Bool;
    
    // System integrity
    systemIntegrity   : Float;
  };

  /// Cyber attack
  public type CyberAttack = {
    attackId          : Nat;
    targetSystem      : Text;
    attackType        : Text;
    progress          : Float;
    successProbability : Float;
  };

  /// Tactical coordination state
  public type TacticalCoordinationState = {
    // Mission coordination
    missionId         : ?Nat;
    missionPhase      : Text;
    
    // Unit coordination
    coordinatingWith  : [Nat];
    myRole            : Text;
    
    // Communication
    commsChannel      : Nat;
    lastCommsUpdate   : Nat;
    commsStatus       : Text;
    
    // Fire coordination
    fireControlMode   : Text;
    deconflictionActive : Bool;
    
    // Synchronization
    syncTime          : Nat;
    syncAccuracy      : Float;
  };

  /// Initialize tactical state
  public func initTacticalState() : TacticalState {
    {
      tacticalMode = #Patrol;
      targets = [];
      primaryTarget = null;
      threatAssessment = {
        overallThreat = 0.0;
        threatSources = [];
        threatMap = [[]];
        threatMapResolution = 100.0;
        predictedThreats = [];
        safeCorridors = [];
      };
      attackState = {
        attackFormation = #Wedge;
        weaponsArmed = false;
        payloadRemaining = 0;
        attackVectors = [];
        selectedVector = null;
        attackPhase = #Planning;
        timeToTarget = 0.0;
        roeLevel = 3;
        requiresConfirmation = true;
        bdaScore = 0.0;
      };
      defenseState = {
        defensivePosture = #Normal;
        evasionState = {
          currentManeuver = null;
          incomingThreats = [];
          evasionSuccessRate = 0.8;
          evasionEnergy = 1.0;
        };
        countermeasures = {
          chaffRemaining = 0;
          flaresRemaining = 0;
          jammingActive = false;
          jammingFrequency = 0.0;
          decoysDeployed = 0;
          decoysRemaining = 0;
          lastDeploymentBeat = 0;
          cooldownRemaining = 0;
        };
        shieldFormation = null;
        damageControlActive = false;
        criticalSystemsProtected = false;
      };
      ewState = {
        jammingState = {
          isJamming = false;
          targetFrequencies = [];
          jammingPower = 0.0;
          jammingPattern = "barrage";
          effectivenessEstimate = 0.0;
          powerConsumption = 0.0;
        };
        radarDetection = {
          detectedEmitters = [];
          radarWarningActive = false;
          lockOnDetected = false;
          currentRCS = 0.1;
          rcsReductionMode = false;
        };
        spoofingState = {
          gpsSpoofingActive = false;
          spoofedPosition = null;
          commsSpoofingActive = false;
          spoofedIdentity = null;
        };
        sigintState = {
          interceptedSignals = [];
          analysisInProgress = false;
          decodedMessages = [];
        };
        cyberState = {
          activeAttacks = [];
          firewallActive = true;
          intrusionDetected = false;
          systemIntegrity = 1.0;
        };
      };
      tacticalCoordination = {
        missionId = null;
        missionPhase = "planning";
        coordinatingWith = [];
        myRole = "element";
        commsChannel = 1;
        lastCommsUpdate = 0;
        commsStatus = "nominal";
        fireControlMode = "safe";
        deconflictionActive = true;
        syncTime = 0;
        syncAccuracy = 0.0;
      };
      beatNum = 0;
    }
  };

  /// Assess threats
  public func assessThreats(
    current: ThreatAssessmentState,
    detectedEntities: [{ position: { lat: Float; lon: Float; alt: Float }; type_: Text; velocity: { vx: Float; vy: Float; vz: Float } }],
    ownPosition: { lat: Float; lon: Float; alt: Float },
    beat: Nat
  ) : ThreatAssessmentState {
    // Build threat sources
    var newSources : [ThreatSource] = [];
    var maxThreat : Float = 0.0;
    
    for (entity in detectedEntities.vals()) {
      // Calculate distance
      let dx = (entity.position.lon - ownPosition.lon) * 111000.0;
      let dy = (entity.position.lat - ownPosition.lat) * 111000.0;
      let dz = entity.position.alt - ownPosition.alt;
      let distance = Float.sqrt(dx * dx + dy * dy + dz * dz);
      
      // Determine threat level based on type and distance
      let baseThreat = switch (entity.type_) {
        case "hostile_drone" { 0.8 };
        case "missile" { 1.0 };
        case "aircraft" { 0.6 };
        case "radar" { 0.4 };
        case _ { 0.2 };
      };
      
      // Distance attenuation
      let distanceFactor = 1.0 / (1.0 + distance / 1000.0);
      let threatLevel = baseThreat * distanceFactor;
      
      if (threatLevel > maxThreat) {
        maxThreat := threatLevel;
      };
      
      let source : ThreatSource = {
        sourceId = newSources.size();
        sourceType = entity.type_;
        position = entity.position;
        effectiveRange = 1000.0;
        lethality = baseThreat;
        isActive = true;
        lastDetection = beat;
      };
      newSources := Array.append(newSources, [source]);
    };
    
    {
      overallThreat = maxThreat;
      threatSources = newSources;
      threatMap = current.threatMap;
      threatMapResolution = current.threatMapResolution;
      predictedThreats = current.predictedThreats;
      safeCorridors = current.safeCorridors;
    }
  };

  /// Select attack vector
  public func selectAttackVector(
    attack: AttackState,
    target: TacticalTarget,
    ownPosition: { lat: Float; lon: Float; alt: Float },
    threats: ThreatAssessmentState
  ) : AttackState {
    // Generate potential attack vectors
    var vectors : [AttackVector] = [];
    
    // 8 approach directions
    for (i in Iter.range(0, 7)) {
      let heading = Float.fromInt(i) * PI / 4.0;
      
      // Compute risk from that direction
      var risk : Float = 0.1;
      for (source in threats.threatSources.vals()) {
        let dx = (source.position.lon - target.position.lon) * 111000.0;
        let dy = (source.position.lat - target.position.lat) * 111000.0;
        let threatDir = Float.arctan2(dy, dx);
        let angleDiff = Float.abs(heading - threatDir);
        if (angleDiff < PI / 4.0) {
          risk := risk + source.lethality * 0.3;
        };
      };
      
      // Altitude options
      let altitudes = [target.position.alt + 50.0, target.position.alt, target.position.alt - 50.0];
      
      for (alt in altitudes.vals()) {
        let vector : AttackVector = {
          vectorId = vectors.size();
          approachHeading = heading;
          approachAltitude = alt;
          attackAngle = Float.arctan2(alt - target.position.alt, 100.0);
          riskLevel = risk;
          successProbability = 1.0 - risk;
          collateralRisk = 0.1;
        };
        vectors := Array.append(vectors, [vector]);
      };
    };
    
    // Select best vector
    var bestVector : ?Nat = null;
    var bestScore : Float = 0.0;
    
    for (v in vectors.vals()) {
      let score = v.successProbability - v.riskLevel * 0.5 - v.collateralRisk * 0.3;
      if (score > bestScore) {
        bestScore := score;
        bestVector := ?v.vectorId;
      };
    };
    
    {
      attackFormation = attack.attackFormation;
      weaponsArmed = attack.weaponsArmed;
      payloadRemaining = attack.payloadRemaining;
      attackVectors = vectors;
      selectedVector = bestVector;
      attackPhase = attack.attackPhase;
      timeToTarget = attack.timeToTarget;
      roeLevel = attack.roeLevel;
      requiresConfirmation = attack.requiresConfirmation;
      bdaScore = attack.bdaScore;
    }
  };

  /// Select evasive maneuver
  public func selectEvasiveManeuver(
    evasion: EvasionState,
    incomingDirection: Float,
    timeToImpact: Float,
    currentHeading: Float,
    currentAltitude: Float,
    maxAltitude: Float
  ) : EvasionState {
    // Select best maneuver based on incoming threat
    let relativeAngle = incomingDirection - currentHeading;
    let normalizedAngle = Float.sin(relativeAngle);  // -1 to 1
    
    var selectedManeuver : ?EvasiveManeuver = null;
    
    if (timeToImpact < 2.0) {
      // Emergency - jink
      selectedManeuver := ?#Jink;
    } else if (timeToImpact < 5.0) {
      // Need quick response
      if (Float.abs(normalizedAngle) > 0.7) {
        // Threat from side - break into it
        selectedManeuver := ?#Break;
      } else if (currentAltitude > maxAltitude * 0.5) {
        // High altitude - dive
        selectedManeuver := ?#Dive;
      } else {
        // Low altitude - climb
        selectedManeuver := ?#Climb;
      };
    } else {
      // More time - use spiral or barrel roll
      if (evasion.evasionEnergy > 0.5) {
        selectedManeuver := ?#BarrelRoll;
      } else {
        selectedManeuver := ?#Spiral;
      };
    };
    
    // Update energy
    let energyCost = switch (selectedManeuver) {
      case (?#Jink) { 0.3 };
      case (?#Break) { 0.25 };
      case (?#BarrelRoll) { 0.4 };
      case (?#Spiral) { 0.2 };
      case _ { 0.15 };
    };
    
    {
      currentManeuver = selectedManeuver;
      incomingThreats = Array.append(evasion.incomingThreats, [{ direction = incomingDirection; timeToImpact = timeToImpact }]);
      evasionSuccessRate = evasion.evasionSuccessRate;
      evasionEnergy = Float.max(0.0, evasion.evasionEnergy - energyCost);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 21: SWARM NAVIGATION — AUTONOMOUS MOVEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Navigation state
  public type SwarmNavigationState = {
    // Waypoints
    waypoints         : [NavigationWaypoint];
    currentWaypointIdx : Nat;
    
    // Path planning
    plannedPath       : [{ lat: Float; lon: Float; alt: Float }];
    pathProgress      : Float;
    
    // Terrain
    terrainMap        : TerrainMap;
    
    // Obstacles
    obstacles         : [Obstacle];
    
    // Wind
    windVector        : { speed: Float; direction: Float };
    
    // Navigation modes
    navMode           : NavigationMode;
    
    // Performance
    navigationError   : Float;
    estimatedTimeEnroute : Float;
    
    beatNum           : Nat;
  };

  /// Navigation waypoint
  public type NavigationWaypoint = {
    waypointId        : Nat;
    position          : { lat: Float; lon: Float; alt: Float };
    waypointType      : WaypointType;
    loiterTime        : Nat;
    speedLimit        : ?Float;
    altitudeConstraint : ?{ min: Float; max: Float };
    passRadius        : Float;
    isCompleted       : Bool;
  };

  /// Waypoint types
  public type WaypointType = {
    #Flythrough;
    #Loiter;
    #Landing;
    #Takeoff;
    #Rally;
    #Target;
  };

  /// Terrain map
  public type TerrainMap = {
    elevationGrid     : [[Float]];
    gridResolution    : Float;
    originLat         : Float;
    originLon         : Float;
    noFlyZones        : [NoFlyZone];
  };

  /// No-fly zone
  public type NoFlyZone = {
    zoneId            : Nat;
    center            : { lat: Float; lon: Float };
    radius            : Float;
    altitudeFloor     : Float;
    altitudeCeiling   : Float;
    active            : Bool;
  };

  /// Obstacle
  public type Obstacle = {
    obstacleId        : Nat;
    position          : { lat: Float; lon: Float; alt: Float };
    size              : { width: Float; height: Float; depth: Float };
    velocity          : ?{ vx: Float; vy: Float; vz: Float };
    isDynamic         : Bool;
    lastUpdate        : Nat;
  };

  /// Navigation modes
  public type NavigationMode = {
    #Direct;          // Straight to waypoint
    #TerrainFollow;   // Follow terrain contour
    #ObstacleAvoid;   // Active obstacle avoidance
    #FormationHold;   // Maintain formation position
    #ContourFly;      // Fly along contour lines
    #NOE;             // Nap-of-the-earth
  };

  /// Initialize navigation state
  public func initNavigationState() : SwarmNavigationState {
    {
      waypoints = [];
      currentWaypointIdx = 0;
      plannedPath = [];
      pathProgress = 0.0;
      terrainMap = {
        elevationGrid = [[]];
        gridResolution = 100.0;
        originLat = 0.0;
        originLon = 0.0;
        noFlyZones = [];
      };
      obstacles = [];
      windVector = { speed = 0.0; direction = 0.0 };
      navMode = #Direct;
      navigationError = 0.0;
      estimatedTimeEnroute = 0.0;
      beatNum = 0;
    }
  };

  /// Plan path (A* algorithm simplified)
  public func planPath(
    start: { lat: Float; lon: Float; alt: Float },
    goal: { lat: Float; lon: Float; alt: Float },
    terrain: TerrainMap,
    obstacles: [Obstacle]
  ) : [{ lat: Float; lon: Float; alt: Float }] {
    // Simplified path planning - straight line with intermediate waypoints
    let numSegments = 10;
    var path : [{ lat: Float; lon: Float; alt: Float }] = [];
    
    for (i in Iter.range(0, numSegments)) {
      let t = Float.fromInt(i) / Float.fromInt(numSegments);
      let lat = start.lat + t * (goal.lat - start.lat);
      let lon = start.lon + t * (goal.lon - start.lon);
      let alt = start.alt + t * (goal.alt - start.alt);
      
      // Check for obstacles
      var adjustedAlt = alt;
      for (obs in obstacles.vals()) {
        let dx = (lon - obs.position.lon) * 111000.0;
        let dy = (lat - obs.position.lat) * 111000.0;
        let dist = Float.sqrt(dx * dx + dy * dy);
        if (dist < obs.size.width) {
          adjustedAlt := Float.max(adjustedAlt, obs.position.alt + obs.size.height + 10.0);
        };
      };
      
      // Check terrain
      let gridX = Int.abs(Float.toInt((lon - terrain.originLon) * 111000.0 / terrain.gridResolution));
      let gridY = Int.abs(Float.toInt((lat - terrain.originLat) * 111000.0 / terrain.gridResolution));
      
      if (gridY < terrain.elevationGrid.size() and gridX < terrain.elevationGrid[0].size()) {
        let terrainAlt = terrain.elevationGrid[gridY][gridX];
        adjustedAlt := Float.max(adjustedAlt, terrainAlt + 50.0);  // 50m clearance
      };
      
      path := Array.append(path, [{ lat = lat; lon = lon; alt = adjustedAlt }]);
    };
    
    path
  };

  /// Navigate to waypoint
  public func navigateToWaypoint(
    nav: SwarmNavigationState,
    currentPosition: { lat: Float; lon: Float; alt: Float },
    currentVelocity: { vx: Float; vy: Float; vz: Float },
    dt: Float
  ) : (SwarmNavigationState, { vx: Float; vy: Float; vz: Float }) {
    if (nav.waypoints.size() == 0 or nav.currentWaypointIdx >= nav.waypoints.size()) {
      return (nav, { vx = 0.0; vy = 0.0; vz = 0.0 });
    };
    
    let waypoint = nav.waypoints[nav.currentWaypointIdx];
    
    // Vector to waypoint
    let dx = (waypoint.position.lon - currentPosition.lon) * 111000.0;
    let dy = (waypoint.position.lat - currentPosition.lat) * 111000.0;
    let dz = waypoint.position.alt - currentPosition.alt;
    
    let distance = Float.sqrt(dx * dx + dy * dy + dz * dz);
    
    // Check if reached
    if (distance < waypoint.passRadius) {
      // Move to next waypoint
      let newWpIdx = nav.currentWaypointIdx + 1;
      let newNav : SwarmNavigationState = {
        waypoints = nav.waypoints;
        currentWaypointIdx = newWpIdx;
        plannedPath = nav.plannedPath;
        pathProgress = Float.fromInt(newWpIdx) / Float.fromInt(nav.waypoints.size());
        terrainMap = nav.terrainMap;
        obstacles = nav.obstacles;
        windVector = nav.windVector;
        navMode = nav.navMode;
        navigationError = nav.navigationError;
        estimatedTimeEnroute = nav.estimatedTimeEnroute;
        beatNum = nav.beatNum + 1;
      };
      return (newNav, { vx = 0.0; vy = 0.0; vz = 0.0 });
    };
    
    // Compute desired velocity
    let maxSpeed = switch (waypoint.speedLimit) {
      case (?limit) { limit };
      case null { 20.0 };
    };
    
    let desiredSpeed = Float.min(maxSpeed, distance * 0.5);  // Slow down near waypoint
    let speedScale = desiredSpeed / (distance + 0.001);
    
    var targetVx = dx * speedScale;
    var targetVy = dy * speedScale;
    var targetVz = dz * speedScale;
    
    // Wind compensation
    targetVx := targetVx - nav.windVector.speed * Float.cos(nav.windVector.direction);
    targetVy := targetVy - nav.windVector.speed * Float.sin(nav.windVector.direction);
    
    // Smoothing
    let alpha = 0.3;
    let vx = currentVelocity.vx * (1.0 - alpha) + targetVx * alpha;
    let vy = currentVelocity.vy * (1.0 - alpha) + targetVy * alpha;
    let vz = currentVelocity.vz * (1.0 - alpha) + targetVz * alpha;
    
    // Update nav error
    let crossTrackError = 0.0;  // Would compute properly
    
    let newNav : SwarmNavigationState = {
      waypoints = nav.waypoints;
      currentWaypointIdx = nav.currentWaypointIdx;
      plannedPath = nav.plannedPath;
      pathProgress = nav.pathProgress;
      terrainMap = nav.terrainMap;
      obstacles = nav.obstacles;
      windVector = nav.windVector;
      navMode = nav.navMode;
      navigationError = crossTrackError;
      estimatedTimeEnroute = distance / (desiredSpeed + 0.001);
      beatNum = nav.beatNum + 1;
    };
    
    (newNav, { vx = vx; vy = vy; vz = vz })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 22: RESOURCE MANAGEMENT — ENERGY AND PAYLOAD
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Resource management state
  public type ResourceManagementState = {
    // Battery
    batteryState      : BatteryState;
    
    // Payload
    payloadState      : PayloadState;
    
    // Fuel (for hybrid drones)
    fuelState         : ?FuelState;
    
    // Resource allocation
    resourceAllocation : ResourceAllocation;
    
    // Efficiency
    efficiencyMetrics : EfficiencyMetrics;
    
    beatNum           : Nat;
  };

  /// Battery state
  public type BatteryState = {
    // Charge
    currentCharge     : Float;       // Wh remaining
    maxCharge         : Float;       // Wh capacity
    chargePercent     : Float;
    
    // Health
    cycleCount        : Nat;
    healthPercent     : Float;
    
    // Thermal
    temperature       : Float;
    isOverheating     : Bool;
    
    // Power draw
    currentDraw       : Float;       // W
    averageDraw       : Float;       // W
    peakDraw          : Float;       // W
    
    // Estimates
    timeRemaining     : Float;       // seconds
    rangeRemaining    : Float;       // meters
    
    // Charging
    isCharging        : Bool;
    chargeRate        : Float;
  };

  /// Payload state
  public type PayloadState = {
    // Weight
    totalWeight       : Float;       // kg
    
    // Items
    payloadItems      : [PayloadItem];
    
    // Dispensers
    dispensers        : [Dispenser];
    
    // Sensors
    sensorPayloads    : [SensorPayload];
  };

  /// Payload item
  public type PayloadItem = {
    itemId            : Nat;
    itemType          : Text;
    weight            : Float;
    isDeployed        : Bool;
    deploymentMethod  : Text;
  };

  /// Dispenser
  public type Dispenser = {
    dispenserId       : Nat;
    dispenserType     : Text;
    capacity          : Nat;
    remaining         : Nat;
    isReady           : Bool;
  };

  /// Sensor payload
  public type SensorPayload = {
    sensorId          : Nat;
    sensorType        : Text;       // "camera", "lidar", "radar", etc.
    isActive          : Bool;
    powerDraw         : Float;
    dataRate          : Float;      // bytes/sec
    fieldOfView       : Float;
    range             : Float;
  };

  /// Fuel state (for hybrid)
  public type FuelState = {
    fuelRemaining     : Float;       // liters
    fuelCapacity      : Float;
    fuelConsumption   : Float;       // L/hour
    generatorOutput   : Float;       // W
    generatorEfficiency : Float;
  };

  /// Resource allocation
  public type ResourceAllocation = {
    // Priority allocation
    propulsionAlloc   : Float;       // 0-1
    sensorsAlloc      : Float;
    communicationAlloc : Float;
    computeAlloc      : Float;
    reserveAlloc      : Float;
    
    // Mode
    allocationMode    : AllocationMode;
    
    // Constraints
    minimumReserve    : Float;
  };

  /// Allocation modes
  public type AllocationMode = {
    #Normal;
    #HighPerformance;
    #Endurance;
    #Emergency;
    #Stealth;
  };

  /// Efficiency metrics
  public type EfficiencyMetrics = {
    propulsiveEfficiency : Float;
    energyPerMeter    : Float;       // Wh/m
    overallEfficiency : Float;
    comparedToBaseline : Float;
  };

  /// Initialize resource management
  public func initResourceManagement(batteryWh: Float) : ResourceManagementState {
    {
      batteryState = {
        currentCharge = batteryWh;
        maxCharge = batteryWh;
        chargePercent = 1.0;
        cycleCount = 0;
        healthPercent = 1.0;
        temperature = 25.0;
        isOverheating = false;
        currentDraw = 0.0;
        averageDraw = 0.0;
        peakDraw = 0.0;
        timeRemaining = 3600.0;
        rangeRemaining = 10000.0;
        isCharging = false;
        chargeRate = 0.0;
      };
      payloadState = {
        totalWeight = 0.0;
        payloadItems = [];
        dispensers = [];
        sensorPayloads = [];
      };
      fuelState = null;
      resourceAllocation = {
        propulsionAlloc = 0.7;
        sensorsAlloc = 0.1;
        communicationAlloc = 0.1;
        computeAlloc = 0.05;
        reserveAlloc = 0.05;
        allocationMode = #Normal;
        minimumReserve = 0.1;
      };
      efficiencyMetrics = {
        propulsiveEfficiency = 0.8;
        energyPerMeter = 0.01;
        overallEfficiency = 0.75;
        comparedToBaseline = 1.0;
      };
      beatNum = 0;
    }
  };

  /// Update battery state
  public func updateBatteryState(
    battery: BatteryState,
    powerDraw: Float,
    dt: Float
  ) : BatteryState {
    // Energy consumed
    let energyUsed = powerDraw * dt / 3600.0;  // Wh
    let newCharge = Float.max(0.0, battery.currentCharge - energyUsed);
    let newChargePercent = newCharge / battery.maxCharge;
    
    // Update averages
    let newAvgDraw = battery.averageDraw * 0.99 + powerDraw * 0.01;
    let newPeakDraw = Float.max(battery.peakDraw, powerDraw);
    
    // Temperature (simplified)
    let heatGenerated = powerDraw * (1.0 - 0.9) * 0.001;  // Inefficiency heat
    let cooling = (battery.temperature - 25.0) * 0.01;
    let newTemp = battery.temperature + heatGenerated - cooling;
    let overheating = newTemp > 60.0;
    
    // Time remaining estimate
    let timeRemaining = if (newAvgDraw > 0.0) {
      newCharge / newAvgDraw * 3600.0
    } else { 9999.0 };
    
    // Range estimate (assuming 10 W/m/s average speed)
    let rangeRemaining = newCharge / 0.01;
    
    {
      currentCharge = newCharge;
      maxCharge = battery.maxCharge;
      chargePercent = newChargePercent;
      cycleCount = battery.cycleCount;
      healthPercent = battery.healthPercent;
      temperature = newTemp;
      isOverheating = overheating;
      currentDraw = powerDraw;
      averageDraw = newAvgDraw;
      peakDraw = newPeakDraw;
      timeRemaining = timeRemaining;
      rangeRemaining = rangeRemaining;
      isCharging = battery.isCharging;
      chargeRate = battery.chargeRate;
    }
  };

  /// Allocate resources based on mode
  public func allocateResources(
    allocation: ResourceAllocation,
    mode: AllocationMode,
    batteryPercent: Float
  ) : ResourceAllocation {
    let (prop, sens, comm, comp, res) = switch (mode) {
      case (#Normal) { (0.7, 0.1, 0.1, 0.05, 0.05) };
      case (#HighPerformance) { (0.85, 0.05, 0.05, 0.03, 0.02) };
      case (#Endurance) { (0.5, 0.15, 0.15, 0.1, 0.1) };
      case (#Emergency) { (0.9, 0.02, 0.02, 0.01, 0.05) };
      case (#Stealth) { (0.4, 0.3, 0.05, 0.15, 0.1) };
    };
    
    // Adjust for low battery
    let batteryFactor = if (batteryPercent < 0.2) { 0.7 } else { 1.0 };
    
    {
      propulsionAlloc = prop * batteryFactor;
      sensorsAlloc = sens;
      communicationAlloc = comm;
      computeAlloc = comp;
      reserveAlloc = res + (1.0 - batteryFactor) * prop;
      allocationMode = mode;
      minimumReserve = allocation.minimumReserve;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 23: COMPLETE SWARM ORGANISM STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Ultimate complete swarm state
  public type UltimateSwarmState = {
    // Previous state
    organism          : CompleteSwarmOrganism;
    
    // Tactical
    tactical          : TacticalState;
    
    // Navigation
    navigation        : SwarmNavigationState;
    
    // Resources
    resources         : ResourceManagementState;
    
    // Global metrics
    swarmCohesion     : Float;
    swarmSurvival     : Float;
    missionSuccess    : Float;
    
    beatNum           : Nat;
  };

  /// Initialize ultimate swarm
  public func initUltimateSwarm(centroid: { lat: Float; lon: Float; alt: Float }) : UltimateSwarmState {
    {
      organism = initCompleteSwarmOrganism(centroid);
      tactical = initTacticalState();
      navigation = initNavigationState();
      resources = initResourceManagement(100.0);
      swarmCohesion = 1.0;
      swarmSurvival = 1.0;
      missionSuccess = 0.0;
      beatNum = 0;
    }
  };

  /// Tick ultimate swarm
  public func tickUltimateSwarm(
    state: UltimateSwarmState,
    detectedEntities: [{ position: { lat: Float; lon: Float; alt: Float }; type_: Text; velocity: { vx: Float; vy: Float; vz: Float } }],
    currentPosition: { lat: Float; lon: Float; alt: Float },
    currentVelocity: { vx: Float; vy: Float; vz: Float },
    powerDraw: Float,
    dt: Float
  ) : UltimateSwarmState {
    // 1. Assess threats
    let newThreatAssessment = assessThreats(
      state.tactical.threatAssessment,
      detectedEntities,
      currentPosition,
      state.beatNum
    );
    
    // 2. Navigate
    let (newNav, desiredVel) = navigateToWaypoint(
      state.navigation,
      currentPosition,
      currentVelocity,
      dt
    );
    
    // 3. Update resources
    let newBattery = updateBatteryState(state.resources.batteryState, powerDraw, dt);
    let newAllocation = allocateResources(
      state.resources.resourceAllocation,
      state.resources.resourceAllocation.allocationMode,
      newBattery.chargePercent
    );
    
    // 4. Update tactical mode based on threats
    let newTacticalMode : TacticalMode = if (newThreatAssessment.overallThreat > 0.8) {
      #Evade
    } else if (newThreatAssessment.overallThreat > 0.5) {
      #Attack
    } else if (newThreatAssessment.overallThreat > 0.2) {
      #Approach
    } else {
      #Patrol
    };
    
    // Compute metrics
    let survivalProb = 1.0 - newThreatAssessment.overallThreat * 0.5;
    
    {
      organism = state.organism;
      tactical = {
        tacticalMode = newTacticalMode;
        targets = state.tactical.targets;
        primaryTarget = state.tactical.primaryTarget;
        threatAssessment = newThreatAssessment;
        attackState = state.tactical.attackState;
        defenseState = state.tactical.defenseState;
        ewState = state.tactical.ewState;
        tacticalCoordination = state.tactical.tacticalCoordination;
        beatNum = state.tactical.beatNum + 1;
      };
      navigation = newNav;
      resources = {
        batteryState = newBattery;
        payloadState = state.resources.payloadState;
        fuelState = state.resources.fuelState;
        resourceAllocation = newAllocation;
        efficiencyMetrics = state.resources.efficiencyMetrics;
        beatNum = state.resources.beatNum + 1;
      };
      swarmCohesion = state.swarmCohesion;
      swarmSurvival = survivalProb;
      missionSuccess = state.navigation.pathProgress;
      beatNum = state.beatNum + 1;
    }
  };

  /// Generate ultimate swarm output
  public type UltimateSwarmOutput = {
    // Tactical
    tacticalMode      : TacticalMode;
    threatLevel       : Float;
    
    // Navigation
    pathProgress      : Float;
    navigationError   : Float;
    
    // Resources
    batteryPercent    : Float;
    timeRemaining     : Float;
    
    // Metrics
    swarmSurvival     : Float;
    missionSuccess    : Float;
    
    beatNum           : Nat;
  };

  public func generateUltimateSwarmOutput(state: UltimateSwarmState) : UltimateSwarmOutput {
    {
      tacticalMode = state.tactical.tacticalMode;
      threatLevel = state.tactical.threatAssessment.overallThreat;
      pathProgress = state.navigation.pathProgress;
      navigationError = state.navigation.navigationError;
      batteryPercent = state.resources.batteryState.chargePercent;
      timeRemaining = state.resources.batteryState.timeRemaining;
      swarmSurvival = state.swarmSurvival;
      missionSuccess = state.missionSuccess;
      beatNum = state.beatNum;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 24: SWARM COMMUNICATION PROTOCOLS
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // Real communication protocols for drone swarms:
  //   • Message types and encoding
  //   • Network topology management
  //   • Routing algorithms
  //   • Encryption and authentication
  //   • Bandwidth management
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Communication protocol state
  public type CommProtocolState = {
    // Network topology
    networkTopology   : NetworkTopology;
    
    // Message queues
    outboundQueue     : [ProtocolMessage];
    inboundQueue      : [ProtocolMessage];
    
    // Routing
    routingTable      : RoutingTable;
    
    // Security
    securityState     : SecurityState;
    
    // Bandwidth
    bandwidthState    : BandwidthState;
    
    // Statistics
    commStats         : CommStatistics;
    
    beatNum           : Nat;
  };

  /// Network topology
  public type NetworkTopology = {
    // My ID
    myNodeId          : Nat;
    
    // Known nodes
    knownNodes        : [NetworkNode];
    
    // Links
    links             : [NetworkLink];
    
    // Cluster info
    clusterId         : Nat;
    clusterHead       : ?Nat;
    amClusterHead     : Bool;
    
    // Topology type
    topologyType      : TopologyType;
    
    // Last update
    lastTopologyUpdate : Nat;
  };

  /// Network node
  public type NetworkNode = {
    nodeId            : Nat;
    position          : { lat: Float; lon: Float; alt: Float };
    signalStrength    : Float;
    lastHeard         : Nat;
    capabilities      : [Text];
    isAlive           : Bool;
    hopCount          : Nat;
  };

  /// Network link
  public type NetworkLink = {
    sourceNode        : Nat;
    destNode          : Nat;
    linkQuality       : Float;
    latency           : Float;
    bandwidth         : Float;
    isDirectional     : Bool;
  };

  /// Topology types
  public type TopologyType = {
    #Mesh;            // Full mesh (everyone talks to everyone)
    #Star;            // Central hub
    #Hierarchical;    // Multi-level clusters
    #Ring;            // Circular
    #Tree;            // Parent-child
    #Hybrid;          // Combination
  };

  /// Protocol message
  public type ProtocolMessage = {
    messageId         : Nat;
    sourceId          : Nat;
    destId            : Nat;        // 0xFFFFFFFF = broadcast
    messageType       : MessageType;
    payload           : MessagePayload;
    ttl               : Nat;
    priority          : MessagePriority;
    timestamp         : Nat;
    requiresAck       : Bool;
    encrypted         : Bool;
  };

  /// Message types
  public type MessageType = {
    #Heartbeat;       // Keep-alive
    #Position;        // Position update
    #Command;         // Control command
    #Data;            // Sensor data
    #Alert;           // Warning/alarm
    #Ack;             // Acknowledgment
    #RouteRequest;    // Routing
    #RouteReply;
    #Sync;            // Time sync
    #Formation;       // Formation update
    #Mission;         // Mission data
    #Status;          // Status report
  };

  /// Message payload
  public type MessagePayload = {
    #Position : { lat: Float; lon: Float; alt: Float; vel: { vx: Float; vy: Float; vz: Float } };
    #Command : { commandId: Nat; parameters: [Float] };
    #SensorData : { sensorType: Text; data: [Float] };
    #Alert : { alertType: Text; severity: Nat; details: Text };
    #Route : { waypoints: [{ lat: Float; lon: Float }] };
    #Status : { batteryLevel: Float; health: Float; mode: Text };
    #Formation : { formationType: Text; myPosition: Nat };
    #Raw : [Nat8];
  };

  /// Message priority
  public type MessagePriority = {
    #Critical;        // Highest, always send
    #High;            // Important
    #Normal;          // Regular
    #Low;             // Can be delayed
    #Background;      // Send when idle
  };

  /// Routing table
  public type RoutingTable = {
    entries           : [RoutingEntry];
    defaultGateway    : ?Nat;
    lastUpdate        : Nat;
  };

  /// Routing entry
  public type RoutingEntry = {
    destId            : Nat;
    nextHop           : Nat;
    hopCount          : Nat;
    metric            : Float;
    timestamp         : Nat;
    isValid           : Bool;
  };

  /// Security state
  public type SecurityState = {
    // Keys
    publicKey         : [Nat8];
    privateKeyHash    : [Nat8];     // Don't store actual private key
    sessionKeys       : [(Nat, [Nat8])];  // Per-node session keys
    
    // Authentication
    isAuthenticated   : Bool;
    authLevel         : Nat;
    
    // Trust
    trustedNodes      : [Nat];
    blacklistedNodes  : [Nat];
    
    // Encryption
    encryptionEnabled : Bool;
    encryptionType    : Text;
  };

  /// Bandwidth state
  public type BandwidthState = {
    // Capacity
    maxBandwidth      : Float;      // bits/sec
    currentUtilization : Float;
    
    // Quality of Service
    qosEnabled        : Bool;
    qosLevels         : [(MessagePriority, Float)];
    
    // Congestion
    congestionLevel   : Float;
    droppedPackets    : Nat;
    
    // Rate limiting
    rateLimiters      : [(Nat, Float)];  // Per-node rate limits
  };

  /// Communication statistics
  public type CommStatistics = {
    messagesSent      : Nat;
    messagesReceived  : Nat;
    bytesTransmitted  : Nat;
    bytesReceived     : Nat;
    acksSent          : Nat;
    acksReceived      : Nat;
    retransmissions   : Nat;
    droppedMessages   : Nat;
    averageLatency    : Float;
    packetLossRate    : Float;
  };

  /// Initialize communication protocol
  public func initCommProtocol(myNodeId: Nat) : CommProtocolState {
    {
      networkTopology = {
        myNodeId = myNodeId;
        knownNodes = [];
        links = [];
        clusterId = 0;
        clusterHead = null;
        amClusterHead = false;
        topologyType = #Mesh;
        lastTopologyUpdate = 0;
      };
      outboundQueue = [];
      inboundQueue = [];
      routingTable = {
        entries = [];
        defaultGateway = null;
        lastUpdate = 0;
      };
      securityState = {
        publicKey = [];
        privateKeyHash = [];
        sessionKeys = [];
        isAuthenticated = true;
        authLevel = 1;
        trustedNodes = [];
        blacklistedNodes = [];
        encryptionEnabled = false;
        encryptionType = "none";
      };
      bandwidthState = {
        maxBandwidth = 1000000.0;   // 1 Mbps
        currentUtilization = 0.0;
        qosEnabled = true;
        qosLevels = [
          (#Critical, 1.0),
          (#High, 0.8),
          (#Normal, 0.6),
          (#Low, 0.4),
          (#Background, 0.2)
        ];
        congestionLevel = 0.0;
        droppedPackets = 0;
        rateLimiters = [];
      };
      commStats = {
        messagesSent = 0;
        messagesReceived = 0;
        bytesTransmitted = 0;
        bytesReceived = 0;
        acksSent = 0;
        acksReceived = 0;
        retransmissions = 0;
        droppedMessages = 0;
        averageLatency = 0.0;
        packetLossRate = 0.0;
      };
      beatNum = 0;
    }
  };

  /// Find route to destination
  public func findRoute(
    routing: RoutingTable,
    destId: Nat,
    topology: NetworkTopology
  ) : ?Nat {
    // Check routing table first
    for (entry in routing.entries.vals()) {
      if (entry.destId == destId and entry.isValid) {
        return ?entry.nextHop;
      };
    };
    
    // Check for direct link
    for (link in topology.links.vals()) {
      if (link.sourceNode == topology.myNodeId and link.destNode == destId) {
        return ?destId;  // Direct link
      };
    };
    
    // Use default gateway
    routing.defaultGateway
  };

  /// Create message
  public func createMessage(
    protocol: CommProtocolState,
    destId: Nat,
    msgType: MessageType,
    payload: MessagePayload,
    priority: MessagePriority
  ) : ProtocolMessage {
    {
      messageId = protocol.commStats.messagesSent;
      sourceId = protocol.networkTopology.myNodeId;
      destId = destId;
      messageType = msgType;
      payload = payload;
      ttl = 10;
      priority = priority;
      timestamp = protocol.beatNum;
      requiresAck = switch (priority) {
        case (#Critical) { true };
        case (#High) { true };
        case _ { false };
      };
      encrypted = protocol.securityState.encryptionEnabled;
    }
  };

  /// Queue message for sending
  public func queueMessage(
    protocol: CommProtocolState,
    message: ProtocolMessage
  ) : CommProtocolState {
    // Priority insertion
    var newQueue : [ProtocolMessage] = [];
    var inserted = false;
    
    for (existing in protocol.outboundQueue.vals()) {
      if (not inserted and comparePriority(message.priority, existing.priority)) {
        newQueue := Array.append(newQueue, [message]);
        inserted := true;
      };
      newQueue := Array.append(newQueue, [existing]);
    };
    
    if (not inserted) {
      newQueue := Array.append(newQueue, [message]);
    };
    
    // Update stats
    let newStats : CommStatistics = {
      messagesSent = protocol.commStats.messagesSent + 1;
      messagesReceived = protocol.commStats.messagesReceived;
      bytesTransmitted = protocol.commStats.bytesTransmitted;
      bytesReceived = protocol.commStats.bytesReceived;
      acksSent = protocol.commStats.acksSent;
      acksReceived = protocol.commStats.acksReceived;
      retransmissions = protocol.commStats.retransmissions;
      droppedMessages = protocol.commStats.droppedMessages;
      averageLatency = protocol.commStats.averageLatency;
      packetLossRate = protocol.commStats.packetLossRate;
    };
    
    {
      networkTopology = protocol.networkTopology;
      outboundQueue = newQueue;
      inboundQueue = protocol.inboundQueue;
      routingTable = protocol.routingTable;
      securityState = protocol.securityState;
      bandwidthState = protocol.bandwidthState;
      commStats = newStats;
      beatNum = protocol.beatNum;
    }
  };

  /// Compare message priorities
  func comparePriority(a: MessagePriority, b: MessagePriority) : Bool {
    let aVal = switch (a) {
      case (#Critical) { 5 };
      case (#High) { 4 };
      case (#Normal) { 3 };
      case (#Low) { 2 };
      case (#Background) { 1 };
    };
    let bVal = switch (b) {
      case (#Critical) { 5 };
      case (#High) { 4 };
      case (#Normal) { 3 };
      case (#Low) { 2 };
      case (#Background) { 1 };
    };
    aVal > bVal
  };

  /// Update network topology
  public func updateTopology(
    topology: NetworkTopology,
    heardFrom: [{ nodeId: Nat; position: { lat: Float; lon: Float; alt: Float }; signalStrength: Float }],
    beat: Nat
  ) : NetworkTopology {
    // Update known nodes
    var newNodes = topology.knownNodes;
    
    for (heard in heardFrom.vals()) {
      var found = false;
      newNodes := Array.map<NetworkNode, NetworkNode>(newNodes, func(node) {
        if (node.nodeId == heard.nodeId) {
          found := true;
          {
            nodeId = node.nodeId;
            position = heard.position;
            signalStrength = heard.signalStrength;
            lastHeard = beat;
            capabilities = node.capabilities;
            isAlive = true;
            hopCount = 1;
          }
        } else { node }
      });
      
      if (not found) {
        let newNode : NetworkNode = {
          nodeId = heard.nodeId;
          position = heard.position;
          signalStrength = heard.signalStrength;
          lastHeard = beat;
          capabilities = [];
          isAlive = true;
          hopCount = 1;
        };
        newNodes := Array.append(newNodes, [newNode]);
      };
    };
    
    // Mark stale nodes as dead
    newNodes := Array.map<NetworkNode, NetworkNode>(newNodes, func(node) {
      if (beat - node.lastHeard > 100) {
        {
          nodeId = node.nodeId;
          position = node.position;
          signalStrength = 0.0;
          lastHeard = node.lastHeard;
          capabilities = node.capabilities;
          isAlive = false;
          hopCount = node.hopCount;
        }
      } else { node }
    });
    
    // Update links based on signal strength
    var newLinks : [NetworkLink] = [];
    for (node in newNodes.vals()) {
      if (node.isAlive and node.signalStrength > 0.1) {
        let link : NetworkLink = {
          sourceNode = topology.myNodeId;
          destNode = node.nodeId;
          linkQuality = node.signalStrength;
          latency = 0.01 / node.signalStrength;
          bandwidth = node.signalStrength * 1000000.0;
          isDirectional = false;
        };
        newLinks := Array.append(newLinks, [link]);
      };
    };
    
    {
      myNodeId = topology.myNodeId;
      knownNodes = newNodes;
      links = newLinks;
      clusterId = topology.clusterId;
      clusterHead = topology.clusterHead;
      amClusterHead = topology.amClusterHead;
      topologyType = topology.topologyType;
      lastTopologyUpdate = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 25: COLLECTIVE INTELLIGENCE — EMERGENT COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  // How the swarm performs collective computation:
  //   • Distributed consensus
  //   • Collective estimation
  //   • Swarm optimization
  //   • Emergent behavior patterns
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Collective intelligence state
  public type CollectiveIntelligenceState = {
    // Consensus
    consensusState    : ConsensusState;
    
    // Collective estimation
    estimationState   : CollectiveEstimationState;
    
    // Optimization
    optimizationState : SwarmOptimizationState;
    
    // Emergent patterns
    patternState      : EmergentPatternState;
    
    // Swarm wisdom
    swarmWisdom       : SwarmWisdomState;
    
    beatNum           : Nat;
  };

  /// Consensus state
  public type ConsensusState = {
    // Current consensus topic
    currentTopic      : ?ConsensusTopic;
    
    // My opinion
    myOpinion         : [Float];
    myConfidence      : Float;
    
    // Received opinions
    opinions          : [(Nat, [Float], Float)];  // (nodeId, opinion, confidence)
    
    // Consensus value
    consensusValue    : ?[Float];
    consensusReached  : Bool;
    convergenceRate   : Float;
    
    // History
    consensusHistory  : [([Float], Nat)];
  };

  /// Consensus topic
  public type ConsensusTopic = {
    topicId           : Nat;
    topicType         : Text;
    dimensions        : Nat;
    deadline          : ?Nat;
    requiredAgreement : Float;
  };

  /// Collective estimation state
  public type CollectiveEstimationState = {
    // Target being estimated
    estimationTarget  : Text;
    
    // My estimate
    myEstimate        : [Float];
    myUncertainty     : [Float];
    
    // Others' estimates
    otherEstimates    : [(Nat, [Float], [Float])];  // (nodeId, estimate, uncertainty)
    
    // Fused estimate
    fusedEstimate     : [Float];
    fusedUncertainty  : [Float];
    
    // Weighting scheme
    weightingScheme   : WeightingScheme;
  };

  /// Weighting schemes
  public type WeightingScheme = {
    #Equal;           // All equal weight
    #InverseVariance; // Weight by 1/variance
    #ReputationBased; // Weight by trust/reputation
    #DistanceBased;   // Weight by proximity
  };

  /// Swarm optimization state
  public type SwarmOptimizationState = {
    // PSO state
    psoState          : ?PSOState;
    
    // ACO state
    acoState          : ?ACOState;
    
    // Genetic algorithm state
    gaState           : ?GAState;
    
    // Current best
    globalBest        : ?([Float], Float);  // (solution, fitness)
    
    // Convergence
    iterationCount    : Nat;
    improvementRate   : Float;
  };

  /// Particle Swarm Optimization state
  public type PSOState = {
    // My particle
    position          : [Float];
    velocity          : [Float];
    personalBest      : [Float];
    personalBestFitness : Float;
    
    // Parameters
    inertia           : Float;
    cognitive         : Float;
    social            : Float;
    
    // Neighborhood
    neighborhoodBest  : ?([Float], Float);
  };

  /// Ant Colony Optimization state
  public type ACOState = {
    // Pheromone map
    pheromoneMap      : [[Float]];
    
    // My path
    currentPath       : [Nat];
    pathQuality       : Float;
    
    // Parameters
    alpha             : Float;       // Pheromone importance
    beta              : Float;       // Heuristic importance
    evaporationRate   : Float;
    
    // Best path
    bestPath          : [Nat];
    bestPathQuality   : Float;
  };

  /// Genetic Algorithm state
  public type GAState = {
    // My chromosome
    chromosome        : [Float];
    fitness           : Float;
    
    // Population info
    populationSize    : Nat;
    generation        : Nat;
    
    // Parameters
    mutationRate      : Float;
    crossoverRate     : Float;
    
    // Best
    bestChromosome    : [Float];
    bestFitness       : Float;
  };

  /// Emergent pattern state
  public type EmergentPatternState = {
    // Detected patterns
    detectedPatterns  : [DetectedPattern];
    
    // Pattern formation
    formingPatterns   : [FormingPattern];
    
    // My contribution
    myContribution    : PatternContribution;
    
    // Pattern stability
    patternStability  : Float;
  };

  /// Detected pattern
  public type DetectedPattern = {
    patternId         : Nat;
    patternType       : Text;
    confidence        : Float;
    participatingNodes : [Nat];
    spatialExtent     : Float;
    temporalDuration  : Nat;
  };

  /// Forming pattern
  public type FormingPattern = {
    patternId         : Nat;
    targetPattern     : Text;
    formationProgress : Float;
    requiredNodes     : Nat;
    currentNodes      : Nat;
    coordinator       : ?Nat;
  };

  /// Pattern contribution
  public type PatternContribution = {
    currentPattern    : ?Nat;
    myRole            : Text;
    targetPosition    : ?{ x: Float; y: Float; z: Float };
    alignmentError    : Float;
  };

  /// Swarm wisdom state
  public type SwarmWisdomState = {
    // Collective knowledge
    sharedKnowledge   : [KnowledgeItem];
    
    // Information flow
    informationEntropy : Float;
    informationFlow   : Float;
    
    // Decision quality
    collectiveAccuracy : Float;
    diversityIndex    : Float;
    
    // Learning
    collectiveLearning : Float;
  };

  /// Knowledge item
  public type KnowledgeItem = {
    itemId            : Nat;
    content           : Text;
    source            : Nat;
    confidence        : Float;
    corroborations    : Nat;
    contradictions    : Nat;
    timestamp         : Nat;
  };

  /// Initialize collective intelligence
  public func initCollectiveIntelligence() : CollectiveIntelligenceState {
    {
      consensusState = {
        currentTopic = null;
        myOpinion = [];
        myConfidence = 0.5;
        opinions = [];
        consensusValue = null;
        consensusReached = false;
        convergenceRate = 0.0;
        consensusHistory = [];
      };
      estimationState = {
        estimationTarget = "";
        myEstimate = [];
        myUncertainty = [];
        otherEstimates = [];
        fusedEstimate = [];
        fusedUncertainty = [];
        weightingScheme = #InverseVariance;
      };
      optimizationState = {
        psoState = null;
        acoState = null;
        gaState = null;
        globalBest = null;
        iterationCount = 0;
        improvementRate = 0.0;
      };
      patternState = {
        detectedPatterns = [];
        formingPatterns = [];
        myContribution = {
          currentPattern = null;
          myRole = "none";
          targetPosition = null;
          alignmentError = 0.0;
        };
        patternStability = 0.0;
      };
      swarmWisdom = {
        sharedKnowledge = [];
        informationEntropy = 0.0;
        informationFlow = 0.0;
        collectiveAccuracy = 0.0;
        diversityIndex = 0.0;
        collectiveLearning = 0.0;
      };
      beatNum = 0;
    }
  };

  /// Update consensus (average consensus algorithm)
  public func updateConsensus(
    consensus: ConsensusState,
    receivedOpinions: [(Nat, [Float], Float)],
    alpha: Float
  ) : ConsensusState {
    if (consensus.myOpinion.size() == 0) {
      return consensus;
    };
    
    // Combine all opinions
    var allOpinions = Array.append(consensus.opinions, receivedOpinions);
    
    // Remove duplicates (keep most recent)
    var seenNodes : [Nat] = [];
    var uniqueOpinions : [(Nat, [Float], Float)] = [];
    for ((nodeId, opinion, conf) in allOpinions.vals()) {
      var seen = false;
      for (s in seenNodes.vals()) { if (s == nodeId) { seen := true } };
      if (not seen) {
        seenNodes := Array.append(seenNodes, [nodeId]);
        uniqueOpinions := Array.append(uniqueOpinions, [(nodeId, opinion, conf)]);
      };
    };
    
    // Weighted average
    let dim = consensus.myOpinion.size();
    var newOpinion : [Float] = Array.tabulate<Float>(dim, func(_) { 0.0 });
    var totalWeight : Float = consensus.myConfidence;
    
    let newOpinionMut = Array.thaw<Float>(newOpinion);
    
    // Add my opinion
    for (i in Iter.range(0, dim - 1)) {
      newOpinionMut[i] := consensus.myOpinion[i] * consensus.myConfidence;
    };
    
    // Add others
    for ((_, opinion, conf) in uniqueOpinions.vals()) {
      totalWeight += conf;
      for (i in Iter.range(0, Int.min(dim, opinion.size()) - 1)) {
        newOpinionMut[i] := newOpinionMut[i] + opinion[i] * conf;
      };
    };
    
    // Normalize
    if (totalWeight > 0.0) {
      for (i in Iter.range(0, dim - 1)) {
        newOpinionMut[i] := newOpinionMut[i] / totalWeight;
      };
    };
    
    newOpinion := Array.freeze(newOpinionMut);
    
    // Mix with previous (smoothing)
    let mixedOpinion = Array.tabulate<Float>(dim, func(i) {
      consensus.myOpinion[i] * (1.0 - alpha) + newOpinion[i] * alpha
    });
    
    // Check convergence
    var maxDiff : Float = 0.0;
    for ((_, opinion, _) in uniqueOpinions.vals()) {
      for (i in Iter.range(0, Int.min(dim, opinion.size()) - 1)) {
        let diff = Float.abs(mixedOpinion[i] - opinion[i]);
        if (diff > maxDiff) { maxDiff := diff };
      };
    };
    
    let converged = maxDiff < 0.01;
    
    {
      currentTopic = consensus.currentTopic;
      myOpinion = mixedOpinion;
      myConfidence = consensus.myConfidence;
      opinions = uniqueOpinions;
      consensusValue = if (converged) { ?mixedOpinion } else { null };
      consensusReached = converged;
      convergenceRate = 1.0 - maxDiff;
      consensusHistory = if (converged) {
        Array.append(consensus.consensusHistory, [(mixedOpinion, consensus.beatNum)])
      } else { consensus.consensusHistory };
    }
  };

  /// Fuse estimates (inverse variance weighting)
  public func fuseEstimates(
    estimation: CollectiveEstimationState
  ) : CollectiveEstimationState {
    if (estimation.myEstimate.size() == 0) {
      return estimation;
    };
    
    let dim = estimation.myEstimate.size();
    var fusedEst : [Float] = Array.tabulate<Float>(dim, func(_) { 0.0 });
    var totalPrecision : [Float] = Array.tabulate<Float>(dim, func(_) { 0.0 });
    
    let fusedMut = Array.thaw<Float>(fusedEst);
    let precisionMut = Array.thaw<Float>(totalPrecision);
    
    // Add my estimate
    for (i in Iter.range(0, dim - 1)) {
      let myPrec = if (i < estimation.myUncertainty.size() and estimation.myUncertainty[i] > 0.001) {
        1.0 / (estimation.myUncertainty[i] * estimation.myUncertainty[i])
      } else { 1.0 };
      
      fusedMut[i] := estimation.myEstimate[i] * myPrec;
      precisionMut[i] := myPrec;
    };
    
    // Add others
    for ((_, estimate, uncertainty) in estimation.otherEstimates.vals()) {
      for (i in Iter.range(0, Int.min(dim, estimate.size()) - 1)) {
        let prec = if (i < uncertainty.size() and uncertainty[i] > 0.001) {
          1.0 / (uncertainty[i] * uncertainty[i])
        } else { 1.0 };
        
        fusedMut[i] := fusedMut[i] + estimate[i] * prec;
        precisionMut[i] := precisionMut[i] + prec;
      };
    };
    
    // Normalize
    for (i in Iter.range(0, dim - 1)) {
      if (precisionMut[i] > 0.0) {
        fusedMut[i] := fusedMut[i] / precisionMut[i];
      };
    };
    
    fusedEst := Array.freeze(fusedMut);
    totalPrecision := Array.freeze(precisionMut);
    
    // Compute fused uncertainty
    let fusedUnc = Array.tabulate<Float>(dim, func(i) {
      if (totalPrecision[i] > 0.0) {
        Float.sqrt(1.0 / totalPrecision[i])
      } else { 1.0 }
    });
    
    {
      estimationTarget = estimation.estimationTarget;
      myEstimate = estimation.myEstimate;
      myUncertainty = estimation.myUncertainty;
      otherEstimates = estimation.otherEstimates;
      fusedEstimate = fusedEst;
      fusedUncertainty = fusedUnc;
      weightingScheme = estimation.weightingScheme;
    }
  };

  /// Update PSO
  public func updatePSO(
    pso: PSOState,
    fitness: Float,
    globalBest: ?([Float], Float),
    randomSeed: Nat
  ) : PSOState {
    let dim = pso.position.size();
    
    // Update personal best
    let (newPersonalBest, newPersonalFitness) = if (fitness > pso.personalBestFitness) {
      (pso.position, fitness)
    } else {
      (pso.personalBest, pso.personalBestFitness)
    };
    
    // Get neighborhood best
    let neighborBest = switch (globalBest) {
      case (?gb) { gb.0 };
      case null { newPersonalBest };
    };
    
    // Random factors (simplified)
    let r1 = Float.fromInt(randomSeed % 1000) / 1000.0;
    let r2 = Float.fromInt((randomSeed * 7) % 1000) / 1000.0;
    
    // Update velocity and position
    let newVelocity = Array.tabulate<Float>(dim, func(i) {
      let inertial = pso.inertia * pso.velocity[i];
      let cognitive = pso.cognitive * r1 * (newPersonalBest[i] - pso.position[i]);
      let social = pso.social * r2 * (neighborBest[i] - pso.position[i]);
      inertial + cognitive + social
    });
    
    let newPosition = Array.tabulate<Float>(dim, func(i) {
      pso.position[i] + newVelocity[i]
    });
    
    {
      position = newPosition;
      velocity = newVelocity;
      personalBest = newPersonalBest;
      personalBestFitness = newPersonalFitness;
      inertia = pso.inertia;
      cognitive = pso.cognitive;
      social = pso.social;
      neighborhoodBest = globalBest;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 26: SWARM HEALTH AND RESILIENCE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Swarm health state
  public type SwarmHealthState = {
    // Population
    totalDrones       : Nat;
    activeDrones      : Nat;
    damagedDrones     : Nat;
    lostDrones        : Nat;
    
    // Connectivity
    networkConnectivity : Float;
    isolatedDrones    : Nat;
    
    // Resource levels
    avgBattery        : Float;
    minBattery        : Float;
    
    // Performance
    missionCapability : Float;
    redundancyLevel   : Float;
    
    // Fault tolerance
    faultTolerance    : FaultToleranceState;
    
    // Resilience
    resilienceMetrics : ResilienceMetrics;
    
    beatNum           : Nat;
  };

  /// Fault tolerance state
  public type FaultToleranceState = {
    // Failures
    recentFailures    : [DroneFailure];
    failureRate       : Float;
    
    // Recovery
    recoveryActions   : [RecoveryAction];
    recoverySuccessRate : Float;
    
    // Redundancy
    roleCoverage      : [(Text, Nat)];  // (role, count)
    criticalRolesOK   : Bool;
    
    // Adaptation
    adaptationLevel   : Float;
  };

  /// Drone failure
  public type DroneFailure = {
    droneId           : Nat;
    failureType       : Text;
    timestamp         : Nat;
    wasCritical       : Bool;
    wasRecovered      : Bool;
  };

  /// Recovery action
  public type RecoveryAction = {
    actionId          : Nat;
    actionType        : Text;
    targetDrone       : Nat;
    status            : Text;
    startBeat         : Nat;
    completionBeat    : ?Nat;
  };

  /// Resilience metrics
  public type ResilienceMetrics = {
    // Robustness
    robustness        : Float;
    
    // Adaptability
    adaptability      : Float;
    
    // Recovery time
    meanTimeToRecover : Float;
    
    // Graceful degradation
    degradationCurve  : [Float];
    
    // Overall resilience score
    resilienceScore   : Float;
  };

  /// Initialize swarm health
  public func initSwarmHealth(numDrones: Nat) : SwarmHealthState {
    {
      totalDrones = numDrones;
      activeDrones = numDrones;
      damagedDrones = 0;
      lostDrones = 0;
      networkConnectivity = 1.0;
      isolatedDrones = 0;
      avgBattery = 1.0;
      minBattery = 1.0;
      missionCapability = 1.0;
      redundancyLevel = 1.0;
      faultTolerance = {
        recentFailures = [];
        failureRate = 0.0;
        recoveryActions = [];
        recoverySuccessRate = 1.0;
        roleCoverage = [];
        criticalRolesOK = true;
        adaptationLevel = 0.5;
      };
      resilienceMetrics = {
        robustness = 1.0;
        adaptability = 0.5;
        meanTimeToRecover = 0.0;
        degradationCurve = [];
        resilienceScore = 0.8;
      };
      beatNum = 0;
    }
  };

  /// Update swarm health
  public func updateSwarmHealth(
    health: SwarmHealthState,
    droneStatuses: [{ droneId: Nat; isActive: Bool; battery: Float; isConnected: Bool }],
    beat: Nat
  ) : SwarmHealthState {
    var active : Nat = 0;
    var damaged : Nat = 0;
    var isolated : Nat = 0;
    var totalBattery : Float = 0.0;
    var minBat : Float = 1.0;
    
    for (status in droneStatuses.vals()) {
      if (status.isActive) {
        active += 1;
        totalBattery += status.battery;
        if (status.battery < minBat) { minBat := status.battery };
        if (not status.isConnected) { isolated += 1 };
      } else {
        damaged += 1;
      };
    };
    
    let total = droneStatuses.size();
    let lost = health.totalDrones - total;
    let avgBat = if (active > 0) { totalBattery / Float.fromInt(active) } else { 0.0 };
    let connectivity = if (active > 0) { Float.fromInt(active - isolated) / Float.fromInt(active) } else { 0.0 };
    
    // Mission capability
    let capability = Float.fromInt(active) / Float.fromInt(health.totalDrones) * avgBat;
    
    // Redundancy
    let redundancy = Float.fromInt(active) / Float.max(Float.fromInt(health.totalDrones) * 0.5, 1.0);
    
    // Failure rate
    let failureRate = Float.fromInt(damaged + lost) / Float.fromInt(health.totalDrones);
    
    // Resilience score
    let resilience = (capability + connectivity + redundancy) / 3.0;
    
    {
      totalDrones = health.totalDrones;
      activeDrones = active;
      damagedDrones = damaged;
      lostDrones = lost;
      networkConnectivity = connectivity;
      isolatedDrones = isolated;
      avgBattery = avgBat;
      minBattery = minBat;
      missionCapability = capability;
      redundancyLevel = redundancy;
      faultTolerance = {
        recentFailures = health.faultTolerance.recentFailures;
        failureRate = failureRate;
        recoveryActions = health.faultTolerance.recoveryActions;
        recoverySuccessRate = health.faultTolerance.recoverySuccessRate;
        roleCoverage = health.faultTolerance.roleCoverage;
        criticalRolesOK = active >= health.totalDrones / 2;
        adaptationLevel = health.faultTolerance.adaptationLevel;
      };
      resilienceMetrics = {
        robustness = 1.0 - failureRate;
        adaptability = health.resilienceMetrics.adaptability;
        meanTimeToRecover = health.resilienceMetrics.meanTimeToRecover;
        degradationCurve = health.resilienceMetrics.degradationCurve;
        resilienceScore = resilience;
      };
      beatNum = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 27: FINAL SUPREME SWARM INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Supreme swarm state
  public type SupremeSwarmState = {
    // Previous ultimate state
    ultimate          : UltimateSwarmState;
    
    // Communication
    commProtocol      : CommProtocolState;
    
    // Collective intelligence
    collectiveIntel   : CollectiveIntelligenceState;
    
    // Health
    swarmHealth       : SwarmHealthState;
    
    // Supreme metrics
    supremeEfficiency : Float;
    supremeResilience : Float;
    supremeIntelligence : Float;
    
    beatNum           : Nat;
  };

  /// Initialize supreme swarm
  public func initSupremeSwarm(
    centroid: { lat: Float; lon: Float; alt: Float },
    numDrones: Nat,
    myNodeId: Nat
  ) : SupremeSwarmState {
    {
      ultimate = initUltimateSwarm(centroid);
      commProtocol = initCommProtocol(myNodeId);
      collectiveIntel = initCollectiveIntelligence();
      swarmHealth = initSwarmHealth(numDrones);
      supremeEfficiency = 0.5;
      supremeResilience = 1.0;
      supremeIntelligence = 0.5;
      beatNum = 0;
    }
  };

  /// Tick supreme swarm
  public func tickSupremeSwarm(
    state: SupremeSwarmState,
    detectedEntities: [{ position: { lat: Float; lon: Float; alt: Float }; type_: Text; velocity: { vx: Float; vy: Float; vz: Float } }],
    currentPosition: { lat: Float; lon: Float; alt: Float },
    currentVelocity: { vx: Float; vy: Float; vz: Float },
    heardNodes: [{ nodeId: Nat; position: { lat: Float; lon: Float; alt: Float }; signalStrength: Float }],
    receivedOpinions: [(Nat, [Float], Float)],
    droneStatuses: [{ droneId: Nat; isActive: Bool; battery: Float; isConnected: Bool }],
    powerDraw: Float,
    dt: Float
  ) : SupremeSwarmState {
    // 1. Update ultimate state
    let newUltimate = tickUltimateSwarm(
      state.ultimate,
      detectedEntities,
      currentPosition,
      currentVelocity,
      powerDraw,
      dt
    );
    
    // 2. Update communication topology
    let newTopology = updateTopology(
      state.commProtocol.networkTopology,
      heardNodes,
      state.beatNum
    );
    
    let newCommProtocol : CommProtocolState = {
      networkTopology = newTopology;
      outboundQueue = state.commProtocol.outboundQueue;
      inboundQueue = state.commProtocol.inboundQueue;
      routingTable = state.commProtocol.routingTable;
      securityState = state.commProtocol.securityState;
      bandwidthState = state.commProtocol.bandwidthState;
      commStats = state.commProtocol.commStats;
      beatNum = state.commProtocol.beatNum + 1;
    };
    
    // 3. Update consensus
    let newConsensus = updateConsensus(
      state.collectiveIntel.consensusState,
      receivedOpinions,
      0.2
    );
    
    // 4. Fuse estimates
    let newEstimation = fuseEstimates(state.collectiveIntel.estimationState);
    
    let newCollectiveIntel : CollectiveIntelligenceState = {
      consensusState = newConsensus;
      estimationState = newEstimation;
      optimizationState = state.collectiveIntel.optimizationState;
      patternState = state.collectiveIntel.patternState;
      swarmWisdom = state.collectiveIntel.swarmWisdom;
      beatNum = state.collectiveIntel.beatNum + 1;
    };
    
    // 5. Update health
    let newHealth = updateSwarmHealth(state.swarmHealth, droneStatuses, state.beatNum);
    
    // 6. Compute supreme metrics
    let efficiency = newUltimate.missionSuccess * newHealth.missionCapability;
    let resilience = newHealth.resilienceMetrics.resilienceScore;
    let intelligence = newConsensus.convergenceRate * 0.5 + 
                       (if (newCollectiveIntel.estimationState.fusedUncertainty.size() > 0) {
                         1.0 - newCollectiveIntel.estimationState.fusedUncertainty[0]
                       } else { 0.0 }) * 0.5;
    
    {
      ultimate = newUltimate;
      commProtocol = newCommProtocol;
      collectiveIntel = newCollectiveIntel;
      swarmHealth = newHealth;
      supremeEfficiency = efficiency;
      supremeResilience = resilience;
      supremeIntelligence = intelligence;
      beatNum = state.beatNum + 1;
    }
  };

  /// Supreme swarm output
  public type SupremeSwarmOutput = {
    // From ultimate
    tacticalMode      : TacticalMode;
    threatLevel       : Float;
    missionSuccess    : Float;
    
    // Communication
    networkSize       : Nat;
    networkConnectivity : Float;
    
    // Intelligence
    consensusReached  : Bool;
    collectiveAccuracy : Float;
    
    // Health
    activeDrones      : Nat;
    resilienceScore   : Float;
    
    // Supreme
    supremeEfficiency : Float;
    supremeResilience : Float;
    supremeIntelligence : Float;
    
    beatNum           : Nat;
  };

  public func generateSupremeSwarmOutput(state: SupremeSwarmState) : SupremeSwarmOutput {
    let ultimateOut = generateUltimateSwarmOutput(state.ultimate);
    
    {
      tacticalMode = ultimateOut.tacticalMode;
      threatLevel = ultimateOut.threatLevel;
      missionSuccess = ultimateOut.missionSuccess;
      networkSize = state.commProtocol.networkTopology.knownNodes.size();
      networkConnectivity = state.swarmHealth.networkConnectivity;
      consensusReached = state.collectiveIntel.consensusState.consensusReached;
      collectiveAccuracy = state.collectiveIntel.swarmWisdom.collectiveAccuracy;
      activeDrones = state.swarmHealth.activeDrones;
      resilienceScore = state.swarmHealth.resilienceMetrics.resilienceScore;
      supremeEfficiency = state.supremeEfficiency;
      supremeResilience = state.supremeResilience;
      supremeIntelligence = state.supremeIntelligence;
      beatNum = state.beatNum;
    }
  };

}
