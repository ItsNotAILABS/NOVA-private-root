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

