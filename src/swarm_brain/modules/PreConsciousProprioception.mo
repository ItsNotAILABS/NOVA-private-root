// ════════════════════════════════════════════════════════════════════════════════
// PRE-CONSCIOUS MECHANISM 20: PROPRIOCEPTION / BODY SCHEMA
// COMPREHENSIVE IMPLEMENTATION — FULL INTEGRATION WITH ALL 12 LAYERS
//
// Proprioception is the continuous, pre-conscious sense of where the body is
// in space. Without looking, without thinking, the organism knows itself constantly.
// This is NOT a "feature" — it is a fundamental architectural substrate.
//
// This module implements:
//   - Body schema centroid computation from Shell 3 activation
//   - 3D body representation (64 nodes mapped to body space)
//   - Structural coherence metrics
//   - Action candidate biasing toward architecturally consistent actions
//   - Integration with vestibular system
//   - Integration with motor planning
//   - Phantom limb / schema distortion detection
//   - Rubber hand illusion equivalent (schema plasticity)
//
// Mathematical Model:
//
// BODY SCHEMA CENTROID:
//   C = Σᵢ(aᵢ × pᵢ) / Σᵢ(aᵢ)
//   where:
//     aᵢ = activation of node i
//     pᵢ = position of node i in body space
//     C = centroid position (3D vector)
//
// STRUCTURAL COHERENCE:
//   SC = 1 - σ(activations) / max_spread
//   where:
//     σ = standard deviation of activation distribution
//     max_spread = maximum possible spread
//
// BODY SPACE MAPPING (64 Shell 3 nodes → body regions):
//   Nodes 0-7:   HEAD (frontal, parietal, occipital, temporal × 2)
//   Nodes 8-15:  TORSO (chest, abdomen, back upper/lower × 2)
//   Nodes 16-23: LEFT ARM (shoulder, upper arm, elbow, forearm, wrist, hand, fingers × 2)
//   Nodes 24-31: RIGHT ARM (mirror of left)
//   Nodes 32-39: LEFT LEG (hip, thigh, knee, calf, ankle, foot, toes × 2)
//   Nodes 40-47: RIGHT LEG (mirror of left)
//   Nodes 48-55: INTERNAL (heart, lungs, gut, liver, kidneys, spine × 2)
//   Nodes 56-63: INTEGRATION (whole-body gestalt, balance, posture × 2)
//
// PROPRIOCEPTIVE ERROR:
//   PE = |predicted_position - actual_position|
//   Used to detect schema distortions
//
// SCHEMA PLASTICITY:
//   ΔSchema = η × (sensory_input - predicted_input) × attention
//   Allows schema to adapt to tools, prosthetics, virtual bodies
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

module {

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════════
  
  // Mathematical constants
  public let PHI : Float = 1.618033988749895;
  public let PHI_INV : Float = 0.618033988749895;
  public let PI : Float = 3.141592653589793;
  public let TAU : Float = 6.283185307179586;
  public let E : Float = 2.718281828459045;
  
  // Sovereignty constants
  public let S0 : Float = 1.0;
  public let SOVEREIGN_CEILING : Float = 9.0;
  
  // Body schema constants
  public let BODY_NODE_COUNT : Nat = 64;
  public let BODY_REGION_COUNT : Nat = 8;
  public let NODES_PER_REGION : Nat = 8;
  
  // 3D body space dimensions (normalized to [-1, 1])
  public let BODY_SPACE_MIN : Float = -1.0;
  public let BODY_SPACE_MAX : Float = 1.0;
  
  // Coherence thresholds
  public let COHERENCE_HIGH : Float = 0.8;
  public let COHERENCE_MEDIUM : Float = 0.5;
  public let COHERENCE_LOW : Float = 0.3;
  public let COHERENCE_CRITICAL : Float = 0.15;
  
  // Schema plasticity
  public let PLASTICITY_RATE : Float = 0.01;
  public let PLASTICITY_DECAY : Float = 0.001;
  public let PLASTICITY_MAX : Float = 0.5;
  
  // Proprioceptive error thresholds
  public let ERROR_THRESHOLD_NORMAL : Float = 0.1;
  public let ERROR_THRESHOLD_WARNING : Float = 0.3;
  public let ERROR_THRESHOLD_CRITICAL : Float = 0.5;
  
  // Action biasing
  public let ACTION_BIAS_BOOST : Float = 0.15;
  public let ACTION_BIAS_PENALTY : Float = 0.10;
  
  // Body region indices
  public let REGION_HEAD : Nat = 0;
  public let REGION_TORSO : Nat = 1;
  public let REGION_LEFT_ARM : Nat = 2;
  public let REGION_RIGHT_ARM : Nat = 3;
  public let REGION_LEFT_LEG : Nat = 4;
  public let REGION_RIGHT_LEG : Nat = 5;
  public let REGION_INTERNAL : Nat = 6;
  public let REGION_INTEGRATION : Nat = 7;

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════════
  
  public func fclamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };
  
  public func fabs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };
  
  public func fsqrt(x: Float) : Float {
    if (x <= 0.0) { 0.0 } else { Float.sqrt(x) }
  };
  
  public func fexp(x: Float) : Float {
    Float.exp(fclamp(x, -50.0, 50.0))
  };
  
  public func fsin(x: Float) : Float { Float.sin(x) };
  public func fcos(x: Float) : Float { Float.cos(x) };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: TYPE DEFINITIONS — 3D VECTOR AND BODY SPACE
  // ══════════════════════════════════════════════════════════════════════════════

  /// 3D vector type for body space coordinates
  public type Vec3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  /// Create zero vector
  public func vec3Zero() : Vec3 { { x = 0.0; y = 0.0; z = 0.0 } };

  /// Vector addition
  public func vec3Add(a: Vec3, b: Vec3) : Vec3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };

  /// Vector subtraction
  public func vec3Sub(a: Vec3, b: Vec3) : Vec3 {
    { x = a.x - b.x; y = a.y - b.y; z = a.z - b.z }
  };

  /// Scalar multiplication
  public func vec3Scale(v: Vec3, s: Float) : Vec3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };

  /// Vector magnitude
  public func vec3Mag(v: Vec3) : Float {
    fsqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };

  /// Vector normalization
  public func vec3Normalize(v: Vec3) : Vec3 {
    let mag = vec3Mag(v);
    if (mag < 1e-10) { return vec3Zero() };
    vec3Scale(v, 1.0 / mag)
  };

  /// Dot product
  public func vec3Dot(a: Vec3, b: Vec3) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };

  /// Cross product
  public func vec3Cross(a: Vec3, b: Vec3) : Vec3 {
    {
      x = a.y * b.z - a.z * b.y;
      y = a.z * b.x - a.x * b.z;
      z = a.x * b.y - a.y * b.x;
    }
  };

  /// Distance between vectors
  public func vec3Distance(a: Vec3, b: Vec3) : Float {
    vec3Mag(vec3Sub(a, b))
  };

  /// Linear interpolation
  public func vec3Lerp(a: Vec3, b: Vec3, t: Float) : Vec3 {
    let tc = fclamp(t, 0.0, 1.0);
    {
      x = a.x + (b.x - a.x) * tc;
      y = a.y + (b.y - a.y) * tc;
      z = a.z + (b.z - a.z) * tc;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: TYPE DEFINITIONS — BODY REGIONS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Body region type
  public type BodyRegion = {
    #Head;
    #Torso;
    #LeftArm;
    #RightArm;
    #LeftLeg;
    #RightLeg;
    #Internal;
    #Integration;
  };

  /// Body sub-region for fine-grained mapping
  public type BodySubRegion = {
    region        : BodyRegion;
    subIndex      : Nat;           // 0-7 within region
    name          : Text;
    centerPosition: Vec3;          // Center in body space
    extent        : Vec3;          // Size in each dimension
    importance    : Float;         // Importance weight (0-1)
    mobility      : Float;         // How mobile this region is (0-1)
    sensitivity   : Float;         // Proprioceptive sensitivity (0-1)
  };

  /// Body node state (one per Shell 3 node)
  public type BodyNode = {
    nodeIndex     : Nat;           // 0-63
    region        : BodyRegion;
    subRegion     : BodySubRegion;
    
    // Position in body space
    position      : Vec3;          // Current position
    restPosition  : Vec3;          // Rest/default position
    velocity      : Vec3;          // Rate of position change
    
    // Activation
    activation    : Float;         // Current activation (from Shell 3)
    baselineActivation : Float;    // Expected baseline
    activationHistory : [Float];   // Recent history
    
    // Proprioceptive signals
    positionSense : Float;         // Position awareness (0-1)
    movementSense : Float;         // Movement awareness (0-1)
    forceSense    : Float;         // Force/resistance awareness (0-1)
    
    // Schema properties
    schemaWeight  : Float;         // Weight in schema computation
    schemaPlasticity : Float;      // How plastic this node's schema is
    schemaError   : Float;         // Current schema error
    
    // Connections
    connectedNodes : [Nat];        // Adjacent body nodes
    connectionStrengths : [Float]; // Strength of connections
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: TYPE DEFINITIONS — BODY SCHEMA STATE
  // ══════════════════════════════════════════════════════════════════════════════

  /// Quadrant enumeration for spatial organization
  public type BodyQuadrant = {
    #FrontLeft;
    #FrontRight;
    #BackLeft;
    #BackRight;
    #Upper;
    #Lower;
    #Central;
  };

  /// Body schema centroid state
  public type SchemaCentroid = {
    position      : Vec3;          // Current centroid position
    velocity      : Vec3;          // Centroid velocity
    acceleration  : Vec3;          // Centroid acceleration
    
    // Filtered/smoothed versions
    filteredPosition : Vec3;       // EMA-filtered position
    filteredVelocity : Vec3;       // EMA-filtered velocity
    
    // Historical
    positionHistory : [Vec3];      // Last 20 positions
    historyIndex  : Nat;
    
    // Derived metrics
    stability     : Float;         // How stable the centroid is (0-1)
    displacement  : Float;         // Displacement from rest
    dominantDirection : Vec3;      // Main direction of centroid shift
  };

  /// Structural coherence metrics
  public type StructuralCoherence = {
    // Overall coherence
    globalCoherence : Float;       // 0-1 overall structural coherence
    
    // Regional coherence
    headCoherence   : Float;
    torsoCoherence  : Float;
    leftArmCoherence : Float;
    rightArmCoherence : Float;
    leftLegCoherence : Float;
    rightLegCoherence : Float;
    internalCoherence : Float;
    integrationCoherence : Float;
    
    // Inter-regional coherence
    leftRightSymmetry : Float;     // Symmetry between sides
    upperLowerBalance : Float;     // Balance between upper/lower
    corePeripheryGradient : Float; // Core vs periphery
    
    // Activation spread
    activationSpread : Float;      // Standard deviation of activations
    activationSkew   : Float;      // Skewness of distribution
    activationKurtosis : Float;    // Kurtosis of distribution
    
    // Dominance
    dominantRegion  : BodyRegion;
    dominantQuadrant : BodyQuadrant;
    dominanceStrength : Float;
  };

  /// Proprioceptive error state
  public type ProprioceptiveError = {
    // Global error
    globalError     : Float;       // Overall proprioceptive error
    errorTrend      : Float;       // Is error increasing or decreasing
    
    // Regional errors
    regionErrors    : [Float];     // Error per region (8 values)
    
    // Error types
    positionError   : Float;       // Position prediction error
    velocityError   : Float;       // Velocity prediction error
    accelerationError : Float;     // Acceleration prediction error
    
    // Schema distortion indicators
    phantomActivation : Float;     // Activation where nothing should be
    numbnessIndicator : Float;     // Lack of activation where expected
    distortionIndex : Float;       // Overall schema distortion
    
    // Error history
    errorHistory    : [Float];
    historyIndex    : Nat;
  };

  /// Schema plasticity state
  public type SchemaPlasticity = {
    // Global plasticity
    globalPlasticity : Float;      // Overall schema plasticity
    plasticityMode  : PlasticityMode;
    
    // Regional plasticity
    regionalPlasticity : [Float];  // Per-region plasticity (8 values)
    
    // Learning
    learningRate    : Float;       // Current learning rate
    learningHistory : [Float];     // Recent learning events
    
    // Tool/extension integration
    toolExtensionActive : Bool;    // Is tool being integrated
    toolPosition    : Vec3;        // Tool position in body space
    toolIntegration : Float;       // How integrated the tool is
    
    // Virtual body
    virtualBodyActive : Bool;      // Virtual/avatar body active
    virtualBodyOffset : Vec3;      // Offset from physical body
    virtualBodyScale : Float;      // Scale relative to physical
    
    // Plasticity limits
    maxPlasticity   : Float;       // Maximum allowed plasticity
    plasticityDecay : Float;       // How fast plasticity decays
  };

  /// Plasticity mode
  public type PlasticityMode = {
    #Stable;          // Schema is stable
    #Learning;        // Actively learning new schema
    #Adapting;        // Adapting to changes
    #Distorted;       // Schema is distorted
    #Recovering;      // Recovering from distortion
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: TYPE DEFINITIONS — ACTION BIASING
  // ══════════════════════════════════════════════════════════════════════════════

  /// Action candidate with proprioceptive bias
  public type ActionCandidate = {
    actionId      : Nat;
    actionType    : ActionType;
    targetRegion  : ?BodyRegion;
    targetPosition : ?Vec3;
    
    // Base score (from arbitration)
    baseScore     : Float;
    
    // Proprioceptive biasing
    schemaBias    : Float;         // Bias from body schema
    coherenceBias : Float;         // Bias from structural coherence
    postureBias   : Float;         // Bias from posture
    balanceBias   : Float;         // Bias from balance
    
    // Final score
    biasedScore   : Float;
    
    // Confidence
    confidence    : Float;
  };

  /// Action types for biasing
  public type ActionType = {
    #Movement;        // Physical movement
    #Manipulation;    // Object manipulation
    #Communication;   // Communication action
    #Cognitive;       // Cognitive action
    #Social;          // Social action
    #Defensive;       // Defensive action
    #Exploratory;     // Exploratory action
  };

  /// Posture state
  public type PostureState = {
    // Current posture
    currentPosture : Posture;
    postureStability : Float;
    postureHistory : [Posture];
    
    // Center of mass
    centerOfMass  : Vec3;
    comVelocity   : Vec3;
    
    // Balance
    balanceIndex  : Float;
    balanceDirection : Vec3;
    balanceCorrection : Vec3;
    
    // Orientation
    bodyOrientation : Vec3;        // Euler angles (pitch, yaw, roll)
    headOrientation : Vec3;
    
    // Ground contact
    groundContact : Float;         // 0-1 how grounded
    supportBase   : Float;         // Size of support base
  };

  /// Posture enumeration
  public type Posture = {
    #Standing;
    #Sitting;
    #Lying;
    #Crouching;
    #Moving;
    #Reaching;
    #Defensive;
    #Unknown;
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: TYPE DEFINITIONS — ORGANISM INTEGRATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Shell 3 integration effects
  public type Shell3ProprioceptionEffects = {
    // Node stimulation
    nodeStimulation : [Float];     // Stimulation delta for all 64 nodes
    
    // Coherence effects
    coherenceTarget : Float;       // Target coherence
    coherenceUrgency : Float;      // Urgency of reaching target
    
    // Phase effects
    phaseAlignment  : Bool;        // Should align phases
    phaseTarget     : Float;       // Target phase
  };

  /// Drive modulation from proprioception
  public type ProprioceptionDriveEffects = {
    // Drive modifications
    bodyIntegrityDelta : Float;    // Body integrity drive
    explorationDelta : Float;      // Exploration drive
    threatResponseDelta : Float;   // Threat response
    
    // Balance-based
    balanceUrgency  : Float;       // Urgency of balance correction
    
    // All drives (10 values)
    allDriveDeltas  : [Float];
  };

  /// Neurochemical effects from proprioception
  public type ProprioceptionNeurochemicalEffects = {
    // Stability-related
    serotoninDelta  : Float;       // Stability increases 5-HT
    gabaDeelta      : Float;       // Stability increases GABA
    
    // Alertness-related
    neDelta         : Float;       // Instability increases NE
    cortDelta       : Float;       // Instability increases CORT
    
    // All chemicals (21 values)
    allChemicalDeltas : [Float];
  };

  /// Memory effects
  public type ProprioceptionMemoryEvent = {
    beatOccurred    : Nat;
    eventType       : ProprioceptionEventType;
    centroidPosition : Vec3;
    coherenceLevel  : Float;
    errorLevel      : Float;
    salience        : Float;
  };

  /// Proprioception event types
  public type ProprioceptionEventType = {
    #StableState;
    #BalanceLoss;
    #SchemaDistortion;
    #PostureChange;
    #ToolIntegration;
    #SchemaRecovery;
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: MASTER STATE TYPE
  // ══════════════════════════════════════════════════════════════════════════════

  /// Processing phase
  public type ProprioceptionPhase = {
    #Idle;
    #SensingPosition;
    #ComputingCentroid;
    #ComputingCoherence;
    #DetectingErrors;
    #UpdateingPlasticity;
    #BiasingActions;
    #IntegratingOrganism;
  };

  /// Complete proprioception system state
  public type ProprioceptionState = {
    // System status
    isActive        : Bool;
    currentPhase    : ProprioceptionPhase;
    beatNum         : Nat;
    
    // Body nodes (64)
    bodyNodes       : [BodyNode];
    
    // Schema centroid
    centroid        : SchemaCentroid;
    
    // Structural coherence
    coherence       : StructuralCoherence;
    
    // Proprioceptive error
    error           : ProprioceptiveError;
    
    // Schema plasticity
    plasticity      : SchemaPlasticity;
    
    // Posture
    posture         : PostureState;
    
    // Integration with vestibular
    vestibularInput : Vec3;         // From vestibular system
    vestibularWeight : Float;       // How much to weight vestibular
    
    // Integration with motor
    motorFeedback   : [Float];      // Feedback from motor system
    efferenceCopy   : [Float];      // Copy of motor commands
    
    // Action biasing
    currentBiases   : [Float];      // Biases for each action type
    lastBiasedAction : ?ActionCandidate;
    
    // History
    eventHistory    : [ProprioceptionMemoryEvent];
    historyMaxSize  : Nat;
    
    // Organism integration outputs
    pendingShell3Effects : ?Shell3ProprioceptionEffects;
    pendingDriveEffects : ?ProprioceptionDriveEffects;
    pendingNeurochemicalEffects : ?ProprioceptionNeurochemicalEffects;
    pendingMemoryEvent : ?ProprioceptionMemoryEvent;
    
    // External inputs (updated each beat)
    currentShell3Activations : [Float];
    currentKfEng    : Float;
    currentArousal  : Float;
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: INITIALIZATION — BODY NODE MAPPING
  // ══════════════════════════════════════════════════════════════════════════════

  /// Get body region for node index
  public func getBodyRegionForNode(nodeIndex: Nat) : BodyRegion {
    let regionIndex = nodeIndex / NODES_PER_REGION;
    switch (regionIndex) {
      case 0 { #Head };
      case 1 { #Torso };
      case 2 { #LeftArm };
      case 3 { #RightArm };
      case 4 { #LeftLeg };
      case 5 { #RightLeg };
      case 6 { #Internal };
      case _ { #Integration };
    }
  };

  /// Get default position for body node
  public func getDefaultNodePosition(nodeIndex: Nat) : Vec3 {
    let region = nodeIndex / NODES_PER_REGION;
    let subIndex = nodeIndex % NODES_PER_REGION;
    let subOffset = Float.fromInt(subIndex) / 8.0 - 0.5;
    
    switch (region) {
      case 0 { // HEAD
        { x = subOffset * 0.3; y = 0.9 + subOffset * 0.1; z = subOffset * 0.2 }
      };
      case 1 { // TORSO
        { x = subOffset * 0.4; y = 0.3 + subOffset * 0.4; z = subOffset * 0.3 }
      };
      case 2 { // LEFT ARM
        { x = -0.6 - subOffset * 0.3; y = 0.5 - subOffset * 0.3; z = 0.0 }
      };
      case 3 { // RIGHT ARM
        { x = 0.6 + subOffset * 0.3; y = 0.5 - subOffset * 0.3; z = 0.0 }
      };
      case 4 { // LEFT LEG
        { x = -0.2 - subOffset * 0.1; y = -0.5 - subOffset * 0.4; z = 0.0 }
      };
      case 5 { // RIGHT LEG
        { x = 0.2 + subOffset * 0.1; y = -0.5 - subOffset * 0.4; z = 0.0 }
      };
      case 6 { // INTERNAL
        { x = subOffset * 0.2; y = 0.2 + subOffset * 0.3; z = subOffset * 0.1 }
      };
      case _ { // INTEGRATION
        { x = 0.0; y = 0.0; z = 0.0 }
      }
    }
  };

  /// Get sub-region name
  public func getSubRegionName(region: BodyRegion, subIndex: Nat) : Text {
    switch (region) {
      case (#Head) {
        switch (subIndex) {
          case 0 { "Frontal" };
          case 1 { "Parietal_L" };
          case 2 { "Parietal_R" };
          case 3 { "Occipital" };
          case 4 { "Temporal_L" };
          case 5 { "Temporal_R" };
          case 6 { "Face" };
          case _ { "Jaw" };
        }
      };
      case (#Torso) {
        switch (subIndex) {
          case 0 { "Chest_Upper" };
          case 1 { "Chest_Lower" };
          case 2 { "Abdomen_Upper" };
          case 3 { "Abdomen_Lower" };
          case 4 { "Back_Upper" };
          case 5 { "Back_Lower" };
          case 6 { "Shoulder_L" };
          case _ { "Shoulder_R" };
        }
      };
      case (#LeftArm) {
        switch (subIndex) {
          case 0 { "Shoulder" };
          case 1 { "UpperArm" };
          case 2 { "Elbow" };
          case 3 { "Forearm" };
          case 4 { "Wrist" };
          case 5 { "Palm" };
          case 6 { "Fingers_123" };
          case _ { "Fingers_45" };
        }
      };
      case (#RightArm) {
        switch (subIndex) {
          case 0 { "Shoulder" };
          case 1 { "UpperArm" };
          case 2 { "Elbow" };
          case 3 { "Forearm" };
          case 4 { "Wrist" };
          case 5 { "Palm" };
          case 6 { "Fingers_123" };
          case _ { "Fingers_45" };
        }
      };
      case (#LeftLeg) {
        switch (subIndex) {
          case 0 { "Hip" };
          case 1 { "Thigh_Upper" };
          case 2 { "Thigh_Lower" };
          case 3 { "Knee" };
          case 4 { "Calf" };
          case 5 { "Ankle" };
          case 6 { "Foot" };
          case _ { "Toes" };
        }
      };
      case (#RightLeg) {
        switch (subIndex) {
          case 0 { "Hip" };
          case 1 { "Thigh_Upper" };
          case 2 { "Thigh_Lower" };
          case 3 { "Knee" };
          case 4 { "Calf" };
          case 5 { "Ankle" };
          case 6 { "Foot" };
          case _ { "Toes" };
        }
      };
      case (#Internal) {
        switch (subIndex) {
          case 0 { "Heart" };
          case 1 { "Lungs_L" };
          case 2 { "Lungs_R" };
          case 3 { "Gut" };
          case 4 { "Liver" };
          case 5 { "Kidneys" };
          case 6 { "Spine_Upper" };
          case _ { "Spine_Lower" };
        }
      };
      case (#Integration) {
        switch (subIndex) {
          case 0 { "WholeBody_COM" };
          case 1 { "Balance_X" };
          case 2 { "Balance_Y" };
          case 3 { "Balance_Z" };
          case 4 { "Posture_Forward" };
          case 5 { "Posture_Side" };
          case 6 { "Posture_Rotation" };
          case _ { "Gestalt" };
        }
      };
    }
  };

  /// Initialize sub-region
  public func initSubRegion(region: BodyRegion, subIndex: Nat) : BodySubRegion {
    let position = getDefaultNodePosition(subIndex + switch(region) {
      case (#Head) { 0 };
      case (#Torso) { 8 };
      case (#LeftArm) { 16 };
      case (#RightArm) { 24 };
      case (#LeftLeg) { 32 };
      case (#RightLeg) { 40 };
      case (#Internal) { 48 };
      case (#Integration) { 56 };
    });
    
    let importance = switch (region) {
      case (#Head) { 1.0 };
      case (#Torso) { 0.9 };
      case (#LeftArm) { 0.7 };
      case (#RightArm) { 0.7 };
      case (#LeftLeg) { 0.6 };
      case (#RightLeg) { 0.6 };
      case (#Internal) { 0.8 };
      case (#Integration) { 1.0 };
    };
    
    let mobility = switch (region) {
      case (#Head) { 0.8 };
      case (#Torso) { 0.4 };
      case (#LeftArm) { 1.0 };
      case (#RightArm) { 1.0 };
      case (#LeftLeg) { 0.9 };
      case (#RightLeg) { 0.9 };
      case (#Internal) { 0.1 };
      case (#Integration) { 0.5 };
    };
    
    let sensitivity = switch (region) {
      case (#Head) { 0.9 };
      case (#Torso) { 0.6 };
      case (#LeftArm) { 0.85 };
      case (#RightArm) { 0.85 };
      case (#LeftLeg) { 0.7 };
      case (#RightLeg) { 0.7 };
      case (#Internal) { 0.5 };
      case (#Integration) { 1.0 };
    };
    
    {
      region = region;
      subIndex = subIndex;
      name = getSubRegionName(region, subIndex);
      centerPosition = position;
      extent = { x = 0.1; y = 0.1; z = 0.1 };
      importance = importance;
      mobility = mobility;
      sensitivity = sensitivity;
    }
  };

  /// Initialize body node
  public func initBodyNode(nodeIndex: Nat) : BodyNode {
    let region = getBodyRegionForNode(nodeIndex);
    let subIndex = nodeIndex % NODES_PER_REGION;
    let subRegion = initSubRegion(region, subIndex);
    let position = getDefaultNodePosition(nodeIndex);
    
    // Get connected nodes (adjacent in body topology)
    let connected = getConnectedNodes(nodeIndex);
    
    {
      nodeIndex = nodeIndex;
      region = region;
      subRegion = subRegion;
      position = position;
      restPosition = position;
      velocity = vec3Zero();
      activation = 0.5;
      baselineActivation = 0.5;
      activationHistory = Array.tabulate<Float>(10, func(_) { 0.5 });
      positionSense = 0.5;
      movementSense = 0.0;
      forceSense = 0.0;
      schemaWeight = subRegion.importance;
      schemaPlasticity = PLASTICITY_RATE;
      schemaError = 0.0;
      connectedNodes = connected;
      connectionStrengths = Array.tabulate<Float>(connected.size(), func(_) { 1.0 });
    }
  };

  /// Get connected nodes based on body topology
  public func getConnectedNodes(nodeIndex: Nat) : [Nat] {
    let region = nodeIndex / NODES_PER_REGION;
    let subIndex = nodeIndex % NODES_PER_REGION;
    
    var connections : [Nat] = [];
    
    // Connect to adjacent nodes in same region
    if (subIndex > 0) {
      connections := Array.append<Nat>(connections, [nodeIndex - 1]);
    };
    if (subIndex < NODES_PER_REGION - 1) {
      connections := Array.append<Nat>(connections, [nodeIndex + 1]);
    };
    
    // Connect to integration nodes
    if (region != 7) {
      connections := Array.append<Nat>(connections, [56 + (nodeIndex % 8)]);
    };
    
    // Cross-body connections (left-right symmetry)
    if (region == 2) { // Left arm connects to right arm
      connections := Array.append<Nat>(connections, [24 + subIndex]);
    };
    if (region == 3) { // Right arm connects to left arm
      connections := Array.append<Nat>(connections, [16 + subIndex]);
    };
    if (region == 4) { // Left leg connects to right leg
      connections := Array.append<Nat>(connections, [40 + subIndex]);
    };
    if (region == 5) { // Right leg connects to left leg
      connections := Array.append<Nat>(connections, [32 + subIndex]);
    };
    
    connections
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: INITIALIZATION — COMPLETE SYSTEM
  // ══════════════════════════════════════════════════════════════════════════════

  /// Initialize schema centroid
  public func initSchemaCentroid() : SchemaCentroid {
    {
      position = vec3Zero();
      velocity = vec3Zero();
      acceleration = vec3Zero();
      filteredPosition = vec3Zero();
      filteredVelocity = vec3Zero();
      positionHistory = Array.tabulate<Vec3>(20, func(_) { vec3Zero() });
      historyIndex = 0;
      stability = 1.0;
      displacement = 0.0;
      dominantDirection = vec3Zero();
    }
  };

  /// Initialize structural coherence
  public func initStructuralCoherence() : StructuralCoherence {
    {
      globalCoherence = 1.0;
      headCoherence = 1.0;
      torsoCoherence = 1.0;
      leftArmCoherence = 1.0;
      rightArmCoherence = 1.0;
      leftLegCoherence = 1.0;
      rightLegCoherence = 1.0;
      internalCoherence = 1.0;
      integrationCoherence = 1.0;
      leftRightSymmetry = 1.0;
      upperLowerBalance = 1.0;
      corePeripheryGradient = 0.5;
      activationSpread = 0.0;
      activationSkew = 0.0;
      activationKurtosis = 0.0;
      dominantRegion = #Integration;
      dominantQuadrant = #Central;
      dominanceStrength = 0.0;
    }
  };

  /// Initialize proprioceptive error
  public func initProprioceptiveError() : ProprioceptiveError {
    {
      globalError = 0.0;
      errorTrend = 0.0;
      regionErrors = Array.tabulate<Float>(8, func(_) { 0.0 });
      positionError = 0.0;
      velocityError = 0.0;
      accelerationError = 0.0;
      phantomActivation = 0.0;
      numbnessIndicator = 0.0;
      distortionIndex = 0.0;
      errorHistory = Array.tabulate<Float>(20, func(_) { 0.0 });
      historyIndex = 0;
    }
  };

  /// Initialize schema plasticity
  public func initSchemaPlasticity() : SchemaPlasticity {
    {
      globalPlasticity = PLASTICITY_RATE;
      plasticityMode = #Stable;
      regionalPlasticity = Array.tabulate<Float>(8, func(_) { PLASTICITY_RATE });
      learningRate = PLASTICITY_RATE;
      learningHistory = Array.tabulate<Float>(20, func(_) { 0.0 });
      toolExtensionActive = false;
      toolPosition = vec3Zero();
      toolIntegration = 0.0;
      virtualBodyActive = false;
      virtualBodyOffset = vec3Zero();
      virtualBodyScale = 1.0;
      maxPlasticity = PLASTICITY_MAX;
      plasticityDecay = PLASTICITY_DECAY;
    }
  };

  /// Initialize posture state
  public func initPostureState() : PostureState {
    {
      currentPosture = #Standing;
      postureStability = 1.0;
      postureHistory = [];
      centerOfMass = { x = 0.0; y = 0.0; z = 0.0 };
      comVelocity = vec3Zero();
      balanceIndex = 1.0;
      balanceDirection = { x = 0.0; y = 1.0; z = 0.0 };
      balanceCorrection = vec3Zero();
      bodyOrientation = vec3Zero();
      headOrientation = vec3Zero();
      groundContact = 1.0;
      supportBase = 1.0;
    }
  };

  /// Initialize complete proprioception system
  public func initProprioceptionState() : ProprioceptionState {
    {
      isActive = true;
      currentPhase = #Idle;
      beatNum = 0;
      bodyNodes = Array.tabulate<BodyNode>(BODY_NODE_COUNT, initBodyNode);
      centroid = initSchemaCentroid();
      coherence = initStructuralCoherence();
      error = initProprioceptiveError();
      plasticity = initSchemaPlasticity();
      posture = initPostureState();
      vestibularInput = vec3Zero();
      vestibularWeight = 0.5;
      motorFeedback = Array.tabulate<Float>(64, func(_) { 0.0 });
      efferenceCopy = Array.tabulate<Float>(64, func(_) { 0.0 });
      currentBiases = Array.tabulate<Float>(7, func(_) { 1.0 });
      lastBiasedAction = null;
      eventHistory = [];
      historyMaxSize = 50;
      pendingShell3Effects = null;
      pendingDriveEffects = null;
      pendingNeurochemicalEffects = null;
      pendingMemoryEvent = null;
      currentShell3Activations = Array.tabulate<Float>(64, func(_) { 0.5 });
      currentKfEng = 0.5;
      currentArousal = 0.5;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: CENTROID COMPUTATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute body schema centroid from node activations
  /// C = Σᵢ(aᵢ × pᵢ × wᵢ) / Σᵢ(aᵢ × wᵢ)
  public func computeCentroid(
    nodes: [BodyNode],
    previousCentroid: SchemaCentroid,
    dt: Float
  ) : SchemaCentroid {
    var sumWeightedPos = vec3Zero();
    var sumWeights : Float = 0.0;
    var maxActivation : Float = 0.0;
    var maxActivationIdx : Nat = 0;
    
    // Compute weighted sum
    var i = 0;
    while (i < nodes.size()) {
      let node = nodes[i];
      let weight = node.activation * node.schemaWeight;
      sumWeights += weight;
      sumWeightedPos := vec3Add(sumWeightedPos, vec3Scale(node.position, weight));
      
      if (node.activation > maxActivation) {
        maxActivation := node.activation;
        maxActivationIdx := i;
      };
      i += 1;
    };
    
    // Compute centroid position
    let position = if (sumWeights > 0.001) {
      vec3Scale(sumWeightedPos, 1.0 / sumWeights)
    } else {
      vec3Zero()
    };
    
    // Compute velocity (change from previous)
    let velocity = vec3Scale(vec3Sub(position, previousCentroid.position), 1.0 / dt);
    
    // Compute acceleration
    let acceleration = vec3Scale(vec3Sub(velocity, previousCentroid.velocity), 1.0 / dt);
    
    // EMA filtering (alpha = 0.3)
    let alpha = 0.3;
    let filteredPos = vec3Lerp(previousCentroid.filteredPosition, position, alpha);
    let filteredVel = vec3Lerp(previousCentroid.filteredVelocity, velocity, alpha);
    
    // Update history
    let newHistory = Array.tabulate<Vec3>(20, func(j) {
      if (j == previousCentroid.historyIndex) { position }
      else { previousCentroid.positionHistory[j] }
    });
    let newHistoryIdx = (previousCentroid.historyIndex + 1) % 20;
    
    // Compute stability (inverse of velocity magnitude)
    let velMag = vec3Mag(velocity);
    let stability = fclamp(1.0 - velMag * 2.0, 0.0, 1.0);
    
    // Compute displacement from origin
    let displacement = vec3Mag(position);
    
    // Dominant direction (normalized velocity)
    let dominantDir = if (velMag > 0.01) { vec3Normalize(velocity) } else { vec3Zero() };
    
    {
      position = position;
      velocity = velocity;
      acceleration = acceleration;
      filteredPosition = filteredPos;
      filteredVelocity = filteredVel;
      positionHistory = newHistory;
      historyIndex = newHistoryIdx;
      stability = stability;
      displacement = displacement;
      dominantDirection = dominantDir;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: STRUCTURAL COHERENCE COMPUTATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute regional coherence for a set of nodes
  public func computeRegionalCoherence(
    nodes: [BodyNode],
    startIdx: Nat,
    endIdx: Nat
  ) : Float {
    if (endIdx <= startIdx) { return 1.0 };
    
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var count : Nat = 0;
    
    var i = startIdx;
    while (i < endIdx and i < nodes.size()) {
      let act = nodes[i].activation;
      sum += act;
      sumSq += act * act;
      count += 1;
      i += 1;
    };
    
    if (count == 0) { return 1.0 };
    
    let mean = sum / Float.fromInt(count);
    let variance = sumSq / Float.fromInt(count) - mean * mean;
    let stdDev = fsqrt(fabs(variance));
    
    // Coherence = 1 - normalized spread
    let maxSpread = 0.5;  // Maximum expected spread
    fclamp(1.0 - stdDev / maxSpread, 0.0, 1.0)
  };

  /// Compute full structural coherence
  public func computeStructuralCoherence(
    nodes: [BodyNode]
  ) : StructuralCoherence {
    // Regional coherence
    let headCoh = computeRegionalCoherence(nodes, 0, 8);
    let torsoCoh = computeRegionalCoherence(nodes, 8, 16);
    let leftArmCoh = computeRegionalCoherence(nodes, 16, 24);
    let rightArmCoh = computeRegionalCoherence(nodes, 24, 32);
    let leftLegCoh = computeRegionalCoherence(nodes, 32, 40);
    let rightLegCoh = computeRegionalCoherence(nodes, 40, 48);
    let internalCoh = computeRegionalCoherence(nodes, 48, 56);
    let integrationCoh = computeRegionalCoherence(nodes, 56, 64);
    
    // Global coherence (weighted average)
    let globalCoh = (headCoh * 1.0 + torsoCoh * 0.9 + leftArmCoh * 0.7 + rightArmCoh * 0.7 +
                     leftLegCoh * 0.6 + rightLegCoh * 0.6 + internalCoh * 0.8 + integrationCoh * 1.0) / 6.3;
    
    // Left-right symmetry
    var leftSum : Float = 0.0;
    var rightSum : Float = 0.0;
    var i = 0;
    while (i < 8) {
      leftSum += nodes[16 + i].activation + nodes[32 + i].activation;  // Left arm + leg
      rightSum += nodes[24 + i].activation + nodes[40 + i].activation; // Right arm + leg
      i += 1;
    };
    let symmetry = 1.0 - fabs(leftSum - rightSum) / (leftSum + rightSum + 0.001);
    
    // Upper-lower balance
    var upperSum : Float = 0.0;
    var lowerSum : Float = 0.0;
    i := 0;
    while (i < 32) {
      upperSum += nodes[i].activation;  // Head, torso, arms
      i += 1;
    };
    i := 32;
    while (i < 48) {
      lowerSum += nodes[i].activation;  // Legs
      i += 1;
    };
    let balance = 1.0 - fabs(upperSum / 32.0 - lowerSum / 16.0);
    
    // Activation statistics
    var totalSum : Float = 0.0;
    var totalSumSq : Float = 0.0;
    i := 0;
    while (i < nodes.size()) {
      totalSum += nodes[i].activation;
      totalSumSq += nodes[i].activation * nodes[i].activation;
      i += 1;
    };
    let mean = totalSum / Float.fromInt(nodes.size());
    let variance = totalSumSq / Float.fromInt(nodes.size()) - mean * mean;
    let spread = fsqrt(fabs(variance));
    
    // Find dominant region
    let regionSums = [
      headCoh, torsoCoh, leftArmCoh, rightArmCoh,
      leftLegCoh, rightLegCoh, internalCoh, integrationCoh
    ];
    var maxCoh : Float = 0.0;
    var maxRegionIdx : Nat = 0;
    i := 0;
    while (i < regionSums.size()) {
      if (regionSums[i] > maxCoh) {
        maxCoh := regionSums[i];
        maxRegionIdx := i;
      };
      i += 1;
    };
    
    let dominantRegion : BodyRegion = switch (maxRegionIdx) {
      case 0 { #Head };
      case 1 { #Torso };
      case 2 { #LeftArm };
      case 3 { #RightArm };
      case 4 { #LeftLeg };
      case 5 { #RightLeg };
      case 6 { #Internal };
      case _ { #Integration };
    };
    
    {
      globalCoherence = fclamp(globalCoh, 0.0, 1.0);
      headCoherence = headCoh;
      torsoCoherence = torsoCoh;
      leftArmCoherence = leftArmCoh;
      rightArmCoherence = rightArmCoh;
      leftLegCoherence = leftLegCoh;
      rightLegCoherence = rightLegCoh;
      internalCoherence = internalCoh;
      integrationCoherence = integrationCoh;
      leftRightSymmetry = fclamp(symmetry, 0.0, 1.0);
      upperLowerBalance = fclamp(balance, 0.0, 1.0);
      corePeripheryGradient = 0.5;  // Simplified
      activationSpread = spread;
      activationSkew = 0.0;  // Would compute properly
      activationKurtosis = 0.0;
      dominantRegion = dominantRegion;
      dominantQuadrant = #Central;
      dominanceStrength = maxCoh - globalCoh;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: PROPRIOCEPTIVE ERROR DETECTION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute proprioceptive error
  public func computeProprioceptiveError(
    nodes: [BodyNode],
    efferenceCopy: [Float],
    motorFeedback: [Float],
    previousError: ProprioceptiveError
  ) : ProprioceptiveError {
    var globalErr : Float = 0.0;
    var regionErrs = Array.init<Float>(8, 0.0);
    var phantomAct : Float = 0.0;
    var numbnessInd : Float = 0.0;
    
    // Compute per-node error
    var i = 0;
    while (i < nodes.size()) {
      let node = nodes[i];
      let regionIdx = i / NODES_PER_REGION;
      
      // Position error: difference between expected and actual
      let expectedAct = if (i < efferenceCopy.size()) { efferenceCopy[i] } else { node.baselineActivation };
      let actualAct = node.activation;
      let nodeError = fabs(expectedAct - actualAct);
      
      globalErr += nodeError;
      if (regionIdx < 8) {
        regionErrs[regionIdx] := regionErrs[regionIdx] + nodeError;
      };
      
      // Phantom activation: high activation where baseline is low
      if (node.baselineActivation < 0.3 and actualAct > 0.7) {
        phantomAct += actualAct - 0.7;
      };
      
      // Numbness: low activation where baseline is high
      if (node.baselineActivation > 0.7 and actualAct < 0.3) {
        numbnessInd += 0.7 - actualAct;
      };
      
      i += 1;
    };
    
    // Normalize
    globalErr := globalErr / Float.fromInt(nodes.size());
    i := 0;
    while (i < 8) {
      regionErrs[i] := regionErrs[i] / Float.fromInt(NODES_PER_REGION);
      i += 1;
    };
    phantomAct := phantomAct / Float.fromInt(nodes.size());
    numbnessInd := numbnessInd / Float.fromInt(nodes.size());
    
    // Error trend
    let errorTrend = globalErr - previousError.globalError;
    
    // Distortion index
    let distortion = (phantomAct + numbnessInd) / 2.0;
    
    // Update history
    let newHistory = Array.tabulate<Float>(20, func(j) {
      if (j == previousError.historyIndex) { globalErr }
      else { previousError.errorHistory[j] }
    });
    let newHistoryIdx = (previousError.historyIndex + 1) % 20;
    
    {
      globalError = fclamp(globalErr, 0.0, 1.0);
      errorTrend = errorTrend;
      regionErrors = Array.freeze(regionErrs);
      positionError = globalErr;
      velocityError = fabs(errorTrend);
      accelerationError = 0.0;
      phantomActivation = phantomAct;
      numbnessIndicator = numbnessInd;
      distortionIndex = distortion;
      errorHistory = newHistory;
      historyIndex = newHistoryIdx;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: SCHEMA PLASTICITY UPDATE
  // ══════════════════════════════════════════════════════════════════════════════

  /// Update schema plasticity based on error and context
  public func updateSchemaPlasticity(
    plasticity: SchemaPlasticity,
    error: ProprioceptiveError,
    arousal: Float,
    attention: Float
  ) : SchemaPlasticity {
    // Determine plasticity mode
    let newMode : PlasticityMode = 
      if (error.distortionIndex > 0.3) { #Distorted }
      else if (error.globalError > ERROR_THRESHOLD_WARNING) { #Adapting }
      else if (plasticity.toolExtensionActive or plasticity.virtualBodyActive) { #Learning }
      else if (error.globalError < ERROR_THRESHOLD_NORMAL and error.distortionIndex < 0.1) { #Stable }
      else { #Recovering };
    
    // Adjust learning rate based on mode and arousal
    let baseLR = switch (newMode) {
      case (#Learning) { PLASTICITY_RATE * 2.0 };
      case (#Adapting) { PLASTICITY_RATE * 1.5 };
      case (#Recovering) { PLASTICITY_RATE * 1.2 };
      case (#Distorted) { PLASTICITY_RATE * 0.5 };  // Reduce plasticity during distortion
      case (#Stable) { PLASTICITY_RATE };
    };
    
    let newLR = baseLR * (1.0 + arousal * 0.3) * (1.0 + attention * 0.5);
    let clampedLR = fclamp(newLR, 0.001, plasticity.maxPlasticity);
    
    // Update regional plasticity
    let newRegionalPlasticity = Array.tabulate<Float>(8, func(i) {
      let regionError = if (i < error.regionErrors.size()) { error.regionErrors[i] } else { 0.0 };
      let regionLR = clampedLR * (1.0 + regionError);
      fclamp(regionLR, 0.001, plasticity.maxPlasticity)
    });
    
    // Update tool integration
    let newToolIntegration = if (plasticity.toolExtensionActive) {
      fclamp(plasticity.toolIntegration + clampedLR * 0.1, 0.0, 1.0)
    } else {
      fclamp(plasticity.toolIntegration - PLASTICITY_DECAY, 0.0, 1.0)
    };
    
    // Global plasticity EMA
    let globalPlast = plasticity.globalPlasticity * 0.9 + clampedLR * 0.1;
    
    {
      globalPlasticity = globalPlast;
      plasticityMode = newMode;
      regionalPlasticity = newRegionalPlasticity;
      learningRate = clampedLR;
      learningHistory = plasticity.learningHistory;  // Would update
      toolExtensionActive = plasticity.toolExtensionActive;
      toolPosition = plasticity.toolPosition;
      toolIntegration = newToolIntegration;
      virtualBodyActive = plasticity.virtualBodyActive;
      virtualBodyOffset = plasticity.virtualBodyOffset;
      virtualBodyScale = plasticity.virtualBodyScale;
      maxPlasticity = plasticity.maxPlasticity;
      plasticityDecay = plasticity.plasticityDecay;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: ACTION BIASING
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute bias for an action candidate based on body schema
  public func computeActionBias(
    candidate: ActionCandidate,
    centroid: SchemaCentroid,
    coherence: StructuralCoherence,
    posture: PostureState
  ) : ActionCandidate {
    // Schema bias: actions aligned with centroid direction get boost
    let schemaBias = switch (candidate.targetPosition) {
      case (?targetPos) {
        let toTarget = vec3Sub(targetPos, centroid.position);
        let alignment = vec3Dot(vec3Normalize(toTarget), centroid.dominantDirection);
        alignment * ACTION_BIAS_BOOST
      };
      case (null) { 0.0 };
    };
    
    // Coherence bias: high coherence allows more actions
    let coherenceBias = (coherence.globalCoherence - 0.5) * ACTION_BIAS_BOOST;
    
    // Posture bias: some actions are easier from certain postures
    let postureBias = switch (candidate.actionType) {
      case (#Movement) {
        if (posture.currentPosture == #Standing) { ACTION_BIAS_BOOST }
        else if (posture.currentPosture == #Sitting) { 0.0 }
        else { -ACTION_BIAS_PENALTY }
      };
      case (#Manipulation) {
        if (posture.currentPosture == #Standing or posture.currentPosture == #Sitting) { ACTION_BIAS_BOOST }
        else { -ACTION_BIAS_PENALTY }
      };
      case (_) { 0.0 };
    };
    
    // Balance bias: unstable balance penalizes physical actions
    let balanceBias = switch (candidate.actionType) {
      case (#Movement) { (posture.balanceIndex - 0.5) * ACTION_BIAS_BOOST };
      case (#Manipulation) { (posture.balanceIndex - 0.7) * ACTION_BIAS_BOOST };
      case (_) { 0.0 };
    };
    
    // Compute final biased score
    let totalBias = schemaBias + coherenceBias + postureBias + balanceBias;
    let biasedScore = candidate.baseScore * (1.0 + totalBias);
    
    {
      candidate with
      schemaBias = schemaBias;
      coherenceBias = coherenceBias;
      postureBias = postureBias;
      balanceBias = balanceBias;
      biasedScore = fclamp(biasedScore, 0.0, 1.0);
    }
  };

  /// Get bias factor for a specific quadrant
  public func getQuadrantBias(
    coherence: StructuralCoherence,
    candidateQuadrant: BodyQuadrant
  ) : Float {
    // Actions in the dominant quadrant get a 15% boost
    if (candidateQuadrant == coherence.dominantQuadrant) {
      1.0 + ACTION_BIAS_BOOST
    } else {
      1.0
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: ORGANISM INTEGRATION EFFECTS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute Shell 3 effects from proprioception
  public func computeShell3Effects(
    coherence: StructuralCoherence,
    centroid: SchemaCentroid,
    error: ProprioceptiveError
  ) : Shell3ProprioceptionEffects {
    // Node stimulation based on coherence
    var nodeStim = Array.init<Float>(64, 0.0);
    
    // Stimulate integration nodes when coherence is high
    if (coherence.globalCoherence > COHERENCE_HIGH) {
      var i = 56;
      while (i < 64) {
        nodeStim[i] := 0.1 * coherence.globalCoherence;
        i += 1;
      };
    };
    
    // Suppress nodes with high error
    var j = 0;
    while (j < 8) {
      if (error.regionErrors[j] > ERROR_THRESHOLD_WARNING) {
        let regionStart = j * 8;
        var k = regionStart;
        while (k < regionStart + 8 and k < 64) {
          nodeStim[k] := -0.05 * error.regionErrors[j];
          k += 1;
        };
      };
      j += 1;
    };
    
    {
      nodeStimulation = Array.freeze(nodeStim);
      coherenceTarget = coherence.globalCoherence;
      coherenceUrgency = if (error.globalError > ERROR_THRESHOLD_WARNING) { 0.8 } else { 0.3 };
      phaseAlignment = coherence.globalCoherence > COHERENCE_HIGH;
      phaseTarget = 0.0;
    }
  };

  /// Compute drive effects from proprioception
  public func computeDriveEffects(
    coherence: StructuralCoherence,
    posture: PostureState,
    error: ProprioceptiveError
  ) : ProprioceptionDriveEffects {
    var allDeltas = Array.init<Float>(10, 0.0);
    
    // Body integrity: increases with error
    let bodyIntegrity = error.globalError * 0.3;
    allDeltas[1] := bodyIntegrity;
    
    // Exploration: decreases with instability
    let exploration = -(1.0 - posture.balanceIndex) * 0.2;
    allDeltas[2] := exploration;
    
    // Threat response: increases with distortion
    let threatResponse = error.distortionIndex * 0.2;
    allDeltas[0] := threatResponse;
    
    // Balance urgency
    let balanceUrgency = (1.0 - posture.balanceIndex) * posture.groundContact;
    
    {
      bodyIntegrityDelta = bodyIntegrity;
      explorationDelta = exploration;
      threatResponseDelta = threatResponse;
      balanceUrgency = balanceUrgency;
      allDriveDeltas = Array.freeze(allDeltas);
    }
  };

  /// Compute neurochemical effects from proprioception
  public func computeNeurochemicalEffects(
    coherence: StructuralCoherence,
    posture: PostureState,
    error: ProprioceptiveError
  ) : ProprioceptionNeurochemicalEffects {
    var allDeltas = Array.init<Float>(21, 0.0);
    
    // Serotonin: increases with stability
    let serotoninDelta = (coherence.globalCoherence - 0.5) * 0.1;
    allDeltas[1] := serotoninDelta;
    
    // GABA: increases with stability
    let gabaDelta = posture.postureStability * 0.05;
    allDeltas[5] := gabaDelta;
    
    // Norepinephrine: increases with instability
    let neDelta = (1.0 - posture.balanceIndex) * 0.15;
    allDeltas[2] := neDelta;
    
    // Cortisol: increases with error
    let cortDelta = error.globalError * 0.1;
    allDeltas[19] := cortDelta;
    
    {
      serotoninDelta = serotoninDelta;
      gabaDeelta = gabaDelta;
      neDelta = neDelta;
      cortDelta = cortDelta;
      allChemicalDeltas = Array.freeze(allDeltas);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: MAIN UPDATE FUNCTION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Update body nodes from Shell 3 activations
  public func updateBodyNodes(
    nodes: [BodyNode],
    shell3Activations: [Float],
    motorFeedback: [Float],
    dt: Float
  ) : [BodyNode] {
    Array.tabulate<BodyNode>(nodes.size(), func(i) {
      let node = nodes[i];
      let newActivation = if (i < shell3Activations.size()) { shell3Activations[i] } else { 0.5 };
      
      // Update activation history
      let newHistory = Array.tabulate<Float>(10, func(j) {
        if (j == 0) { newActivation }
        else if (j < node.activationHistory.size()) { node.activationHistory[j - 1] }
        else { 0.5 }
      });
      
      // Compute movement sense from activation change
      let activationChange = fabs(newActivation - node.activation);
      let movementSense = activationChange * 2.0;
      
      // Compute position sense (higher for more activated nodes)
      let positionSense = newActivation;
      
      // Compute schema error
      let schemaError = fabs(newActivation - node.baselineActivation);
      
      {
        node with
        activation = newActivation;
        activationHistory = newHistory;
        positionSense = fclamp(positionSense, 0.0, 1.0);
        movementSense = fclamp(movementSense, 0.0, 1.0);
        schemaError = schemaError;
      }
    })
  };

  /// Main proprioception system update
  public func updateProprioceptionSystem(
    state: ProprioceptionState,
    shell3Activations: [Float],
    motorFeedback: [Float],
    efferenceCopy: [Float],
    vestibularInput: Vec3,
    arousal: Float,
    attention: Float,
    kfEng: Float
  ) : ProprioceptionState {
    let currentBeat = state.beatNum + 1;
    let dt = 1.0;  // 1 beat
    
    // ══════════════════════════════════════════════════════════════════════════
    // PHASE 1: Update body nodes from Shell 3
    // ══════════════════════════════════════════════════════════════════════════
    let updatedNodes = updateBodyNodes(state.bodyNodes, shell3Activations, motorFeedback, dt);
    
    // ══════════════════════════════════════════════════════════════════════════
    // PHASE 2: Compute centroid
    // ══════════════════════════════════════════════════════════════════════════
    let newCentroid = computeCentroid(updatedNodes, state.centroid, dt);
    
    // ══════════════════════════════════════════════════════════════════════════
    // PHASE 3: Compute structural coherence
    // ══════════════════════════════════════════════════════════════════════════
    let newCoherence = computeStructuralCoherence(updatedNodes);
    
    // ══════════════════════════════════════════════════════════════════════════
    // PHASE 4: Compute proprioceptive error
    // ══════════════════════════════════════════════════════════════════════════
    let newError = computeProprioceptiveError(updatedNodes, efferenceCopy, motorFeedback, state.error);
    
    // ══════════════════════════════════════════════════════════════════════════
    // PHASE 5: Update schema plasticity
    // ══════════════════════════════════════════════════════════════════════════
    let newPlasticity = updateSchemaPlasticity(state.plasticity, newError, arousal, attention);
    
    // ══════════════════════════════════════════════════════════════════════════
    // PHASE 6: Update posture (simplified)
    // ══════════════════════════════════════════════════════════════════════════
    let newPosture : PostureState = {
      state.posture with
      centerOfMass = newCentroid.position;
      comVelocity = newCentroid.velocity;
      balanceIndex = newCentroid.stability;
      postureStability = newCoherence.globalCoherence;
    };
    
    // ══════════════════════════════════════════════════════════════════════════
    // PHASE 7: Compute organism integration effects
    // ══════════════════════════════════════════════════════════════════════════
    let shell3Effects = computeShell3Effects(newCoherence, newCentroid, newError);
    let driveEffects = computeDriveEffects(newCoherence, newPosture, newError);
    let neurochemEffects = computeNeurochemicalEffects(newCoherence, newPosture, newError);
    
    // ══════════════════════════════════════════════════════════════════════════
    // PHASE 8: Create memory event if significant
    // ══════════════════════════════════════════════════════════════════════════
    let memoryEvent : ?ProprioceptionMemoryEvent = if (newError.globalError > ERROR_THRESHOLD_WARNING or
                                                       newCoherence.globalCoherence < COHERENCE_LOW) {
      ?{
        beatOccurred = currentBeat;
        eventType = if (newError.distortionIndex > 0.3) { #SchemaDistortion }
                   else if (newPosture.balanceIndex < 0.5) { #BalanceLoss }
                   else { #StableState };
        centroidPosition = newCentroid.position;
        coherenceLevel = newCoherence.globalCoherence;
        errorLevel = newError.globalError;
        salience = newError.globalError + (1.0 - newCoherence.globalCoherence);
      }
    } else { null };
    
    {
      state with
      isActive = true;
      currentPhase = #IntegratingOrganism;
      beatNum = currentBeat;
      bodyNodes = updatedNodes;
      centroid = newCentroid;
      coherence = newCoherence;
      error = newError;
      plasticity = newPlasticity;
      posture = newPosture;
      vestibularInput = vestibularInput;
      motorFeedback = motorFeedback;
      efferenceCopy = efferenceCopy;
      pendingShell3Effects = ?shell3Effects;
      pendingDriveEffects = ?driveEffects;
      pendingNeurochemicalEffects = ?neurochemEffects;
      pendingMemoryEvent = memoryEvent;
      currentShell3Activations = shell3Activations;
      currentKfEng = kfEng;
      currentArousal = arousal;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 18: QUERY FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Summary type
  public type ProprioceptionSummary = {
    centroidPosition  : Vec3;
    centroidStability : Float;
    globalCoherence   : Float;
    globalError       : Float;
    plasticityMode    : PlasticityMode;
    balanceIndex      : Float;
    dominantRegion    : BodyRegion;
    leftRightSymmetry : Float;
  };

  public func getProprioceptionSummary(state: ProprioceptionState) : ProprioceptionSummary {
    {
      centroidPosition = state.centroid.position;
      centroidStability = state.centroid.stability;
      globalCoherence = state.coherence.globalCoherence;
      globalError = state.error.globalError;
      plasticityMode = state.plasticity.plasticityMode;
      balanceIndex = state.posture.balanceIndex;
      dominantRegion = state.coherence.dominantRegion;
      leftRightSymmetry = state.coherence.leftRightSymmetry;
    }
  };

  public func getCentroidPosition(state: ProprioceptionState) : Vec3 {
    state.centroid.position
  };

  public func getStructuralCoherence(state: ProprioceptionState) : Float {
    state.coherence.globalCoherence
  };

  public func getBodySchemaBias(state: ProprioceptionState, candidateQuadrant: Nat) : Float {
    let quadrant : BodyQuadrant = switch (candidateQuadrant % 7) {
      case 0 { #FrontLeft };
      case 1 { #FrontRight };
      case 2 { #BackLeft };
      case 3 { #BackRight };
      case 4 { #Upper };
      case 5 { #Lower };
      case _ { #Central };
    };
    getQuadrantBias(state.coherence, quadrant)
  };

  public func getPendingShell3Effects(state: ProprioceptionState) : ?Shell3ProprioceptionEffects {
    state.pendingShell3Effects
  };

  public func getPendingDriveEffects(state: ProprioceptionState) : ?ProprioceptionDriveEffects {
    state.pendingDriveEffects
  };

  public func clearPendingEffects(state: ProprioceptionState) : ProprioceptionState {
    {
      state with
      pendingShell3Effects = null;
      pendingDriveEffects = null;
      pendingNeurochemicalEffects = null;
      pendingMemoryEvent = null;
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

}
