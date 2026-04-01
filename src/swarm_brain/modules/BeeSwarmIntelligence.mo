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

}
