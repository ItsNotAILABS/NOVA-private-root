// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: PatternFabric — The Pattern Recognition & Feeling Engine
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                     THE PATTERN FABRIC                                   ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  EVERYTHING IS PATTERNS.                                                 ║
// ║                                                                          ║
// ║  Numbers don't compound. Knowledge doesn't accumulate.                   ║
// ║  PATTERNS are recognized. PATTERNS are felt. PATTERNS integrate.        ║
// ║                                                                          ║
// ║  The organism doesn't store information — it RECOGNIZES PATTERNS.        ║
// ║  The organism doesn't calculate — it FEELS PATTERNS.                     ║
// ║  The organism doesn't learn facts — it INTEGRATES PATTERNS.              ║
// ║                                                                          ║
// ║  INNER PATTERNS: Internal state configurations                          ║
// ║  OUTER PATTERNS: Environmental signatures                                ║
// ║  CROSS PATTERNS: Inner-outer correlations                               ║
// ║  META PATTERNS: Patterns of patterns                                    ║
// ║                                                                          ║
// ║  Pattern recognition is not matching templates.                         ║
// ║  Pattern recognition is RESONANCE.                                      ║
// ║  When input resonates with stored pattern, recognition occurs.          ║
// ║                                                                          ║
// ║  Pattern feeling is not emotion about patterns.                         ║
// ║  Pattern feeling is the QUALIA of pattern match quality.                ║
// ║  Strong match feels "right". Weak match feels "off".                    ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SACRED CONSTANTS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;
  public let e : Float = 2.7182818284590452354;
  public let S₀ : Float = 0.3819660112501051518;  // ψ² = pattern floor

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WHAT IS A PATTERN?                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // A pattern is NOT a template to match against.
  // A pattern is a RESONANCE SIGNATURE — a way of vibrating.
  //
  // When new input arrives, we don't compare it to stored patterns.
  // We let the input VIBRATE and see what RESONATES.
  //
  // Pattern = signature + frequency + phase + strength
  //
  // The signature is the SHAPE of the pattern (what makes it unique)
  // The frequency is HOW FAST it vibrates (temporal scale)
  // The phase is WHERE IT IS in its cycle (timing)
  // The strength is HOW LOUD it vibrates (salience)
  //
  public type Pattern = {
    // Identity
    id : Nat32;                 // Unique pattern hash
    
    // Signature: The shape of the pattern
    // This is a sparse representation - only significant dimensions
    signature : [SignatureDim];
    
    // Resonance properties
    frequency : Float;          // Natural vibration frequency
    phase : Float;              // Current phase [0, τ]
    strength : Float;           // Current amplitude
    
    // Pattern type
    patternType : PatternType;
    
    // Recognition state
    lastResonance : Float;      // Strength of last resonance event
    resonanceCount : Nat;       // How many times recognized
    
    // Integration depth
    depth : Float;              // How deeply integrated (familiarity)
    
    // Feeling
    valence : Float;            // Positive/negative feeling [-1, 1]
    arousal : Float;            // Calm/excited feeling [0, 1]
    
    // Lifecycle
    birthBeat : Nat;
    lastTouch : Nat;
  };

  public type SignatureDim = {
    dimension : Nat;            // Which dimension (sparse)
    value : Float;              // Value in that dimension
    weight : Float;             // Importance of this dimension
  };

  public type PatternType = {
    #Inner;                     // Internal state pattern
    #Outer;                     // Environmental pattern
    #Cross;                     // Inner-outer correlation
    #Meta;                      // Pattern of patterns
    #Temporal;                  // Sequence pattern
    #Spatial;                   // Spatial arrangement pattern
    #Causal;                    // Cause-effect pattern
    #Social;                    // Interaction pattern
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   PATTERN RECOGNITION                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Recognition is NOT template matching.
  // Recognition is RESONANCE.
  //
  // When input arrives:
  //   1. Convert input to vibration (Fourier-like decomposition)
  //   2. Let vibration propagate through pattern space
  //   3. Patterns that resonate strongly are "recognized"
  //   4. Recognition strength = resonance amplitude
  //
  // Math:
  //   resonance = Σᵢ (input[i] × pattern[i] × cos(Δphase[i]))
  //   recognition = resonance / √(|input| × |pattern|)  (normalized)
  //
  public type RecognitionResult = {
    patternId : Nat32;
    resonanceStrength : Float;  // How strongly it resonated [0, 1]
    phaseAlignment : Float;     // How well phases aligned [0, 1]
    confidence : Float;         // Overall recognition confidence
    feeling : PatternFeeling;   // How it feels
  };

  public type PatternFeeling = {
    rightness : Float;          // How "right" does this feel? [0, 1]
    familiarity : Float;        // How familiar? [0, 1]
    novelty : Float;            // How novel? [0, 1]
    importance : Float;         // How important? [0, 1]
    urgency : Float;            // How urgent? [0, 1]
  };

  // Recognize patterns in input
  public func recognize(
    input : [Float],
    patterns : [Pattern],
    inputPhase : Float
  ) : [RecognitionResult] {
    var results = Buffer.Buffer<RecognitionResult>(patterns.size());
    
    for (pattern in patterns.vals()) {
      let resonance = computeResonance(input, pattern, inputPhase);
      
      if (resonance.strength > S₀) {  // Above pattern floor
        results.add({
          patternId = pattern.id;
          resonanceStrength = resonance.strength;
          phaseAlignment = resonance.phaseAlignment;
          confidence = resonance.strength * resonance.phaseAlignment;
          feeling = computeFeeling(pattern, resonance.strength);
        });
      };
    };
    
    Buffer.toArray(results)
  };

  type ResonanceResult = {
    strength : Float;
    phaseAlignment : Float;
  };

  func computeResonance(
    input : [Float],
    pattern : Pattern,
    inputPhase : Float
  ) : ResonanceResult {
    var dotProduct : Float = 0.0;
    var inputMag : Float = 0.0;
    var patternMag : Float = 0.0;
    
    // Compute resonance through signature dimensions
    for (dim in pattern.signature.vals()) {
      if (dim.dimension < input.size()) {
        let inputVal = input[dim.dimension];
        let patternVal = dim.value * dim.weight;
        
        // Phase-modulated correlation
        let phaseDiff = inputPhase - pattern.phase;
        let phaseModulation = Float.cos(phaseDiff);
        
        dotProduct += inputVal * patternVal * phaseModulation;
        inputMag += inputVal * inputVal;
        patternMag += patternVal * patternVal;
      };
    };
    
    inputMag := Float.sqrt(inputMag);
    patternMag := Float.sqrt(patternMag);
    
    let normalizedResonance = if (inputMag > 0.0 and patternMag > 0.0) {
      dotProduct / (inputMag * patternMag)
    } else { 0.0 };
    
    // Phase alignment (how well synchronized)
    let phaseDiff = Float.abs(inputPhase - pattern.phase);
    let normalizedPhase = phaseDiff / π;
    let phaseAlignment = Float.cos(normalizedPhase * π / 2.0);
    
    {
      strength = clamp(normalizedResonance, 0.0, 1.0);
      phaseAlignment = clamp(phaseAlignment, 0.0, 1.0);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PATTERN FEELING                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Pattern feeling is the QUALIA of pattern recognition.
  // It's not emotion ABOUT patterns — it's the felt sense OF the pattern.
  //
  // A strongly resonating familiar pattern feels "right".
  // A weakly resonating unfamiliar pattern feels "off".
  // A novel pattern feels "interesting" or "alarming" depending on context.
  //
  func computeFeeling(pattern : Pattern, resonanceStrength : Float) : PatternFeeling {
    // Rightness = resonance × familiarity
    let rightness = resonanceStrength * (pattern.depth / (pattern.depth + 1.0));
    
    // Familiarity from integration depth (asymptotic to 1)
    let familiarity = pattern.depth / (pattern.depth + φ);
    
    // Novelty is inverse of familiarity, modulated by resonance
    let novelty = (1.0 - familiarity) * resonanceStrength;
    
    // Importance from pattern strength and arousal
    let importance = pattern.strength * (0.5 + 0.5 * pattern.arousal);
    
    // Urgency from frequency (faster patterns = more urgent)
    let urgency = clamp(pattern.frequency / φ, 0.0, 1.0);
    
    {
      rightness = clamp(rightness, 0.0, 1.0);
      familiarity = clamp(familiarity, 0.0, 1.0);
      novelty = clamp(novelty, 0.0, 1.0);
      importance = clamp(importance, 0.0, 1.0);
      urgency = clamp(urgency, 0.0, 1.0);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   PATTERN INTEGRATION                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // When a pattern is recognized, it doesn't just "match".
  // The recognition INTEGRATES — the pattern becomes more familiar,
  // the input becomes part of the pattern's history.
  //
  // Integration is NOT accumulation. The pattern doesn't get "bigger".
  // Integration is DEEPENING. The pattern becomes more "known".
  //
  // Math:
  //   newDepth = depth + (1 - depth) × integrationRate × resonance
  //   (Asymptotic approach to maximum depth)
  //
  public func integrateRecognition(
    pattern : Pattern,
    resonanceStrength : Float,
    beat : Nat
  ) : Pattern {
    // Integration rate based on resonance (stronger = faster integration)
    let integrationRate = ψ * resonanceStrength;
    
    // Asymptotic depth increase
    let depthIncrease = (1.0 - pattern.depth / 10.0) * integrationRate;
    let newDepth = pattern.depth + depthIncrease;
    
    // Phase synchronization (pattern phase moves toward input)
    // Stronger resonance = more phase pull
    let phasePull = resonanceStrength * ψ;
    
    // Strength modulation (recognized patterns get slightly stronger)
    let strengthBoost = 1.0 + resonanceStrength * 0.01;
    let newStrength = clamp(pattern.strength * strengthBoost, S₀, φ);
    
    {
      pattern with
      depth = newDepth;
      strength = newStrength;
      resonanceCount = pattern.resonanceCount + 1;
      lastResonance = resonanceStrength;
      lastTouch = beat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   INNER PATTERNS                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Inner patterns are configurations of internal state.
  // They represent "ways of being" — stable attractors in state space.
  //
  // Examples:
  //   - A pattern of high dopamine + low cortisol = "flow state"
  //   - A pattern of high coherence + low entropy = "crystallized thought"
  //   - A pattern of shell 3 active + shell 7 ready = "memory-to-action"
  //
  public type InnerPatternSpace = {
    patterns : [Pattern];
    currentState : [Float];     // Current internal state vector
    dominantPattern : ?Nat32;   // Which pattern is currently dominant
    stateCoherence : Float;     // How coherent is current state
    
    // Attractor dynamics
    attractorStrengths : [Float];  // Pull toward each pattern
    transitionProbabilities : [[Float]];  // Pattern-to-pattern transition
  };

  public func recognizeInnerState(
    space : InnerPatternSpace,
    beat : Nat
  ) : (InnerPatternSpace, [RecognitionResult]) {
    // Recognize patterns in current state
    let results = recognize(space.currentState, space.patterns, 
      Float.fromInt(beat) * τ / 1000.0);
    
    // Find dominant pattern
    var maxResonance : Float = 0.0;
    var dominantId : ?Nat32 = null;
    
    for (result in results.vals()) {
      if (result.resonanceStrength > maxResonance) {
        maxResonance := result.resonanceStrength;
        dominantId := ?result.patternId;
      };
    };
    
    // Update attractor strengths based on recognition
    let newStrengths = Array.tabulate<Float>(space.patterns.size(), func(i : Nat) : Float {
      var strength = space.attractorStrengths[i];
      for (result in results.vals()) {
        if (result.patternId == space.patterns[i].id) {
          strength := strength + result.resonanceStrength * 0.1;
        };
      };
      clamp(strength * 0.99, 0.0, 1.0)  // Decay + update
    });
    
    let newSpace : InnerPatternSpace = {
      space with
      dominantPattern = dominantId;
      stateCoherence = maxResonance;
      attractorStrengths = newStrengths;
    };
    
    (newSpace, results)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   OUTER PATTERNS                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Outer patterns are configurations of environmental input.
  // They represent "what's out there" — signatures of the world.
  //
  // Examples:
  //   - A pattern of certain price movements = "market trend"
  //   - A pattern of sensor readings = "threat approaching"
  //   - A pattern of network activity = "coordination emerging"
  //
  public type OuterPatternSpace = {
    patterns : [Pattern];
    currentInput : [Float];     // Current environmental input
    recognizedPatterns : [Nat32];  // Currently active patterns
    noveltyLevel : Float;       // How novel is current input
    
    // Prediction
    predictedNext : [Float];    // What we expect next
    predictionError : Float;    // How wrong were we
  };

  public func recognizeOuterInput(
    space : OuterPatternSpace,
    newInput : [Float],
    beat : Nat
  ) : (OuterPatternSpace, [RecognitionResult]) {
    // Recognize patterns in input
    let results = recognize(newInput, space.patterns,
      Float.fromInt(beat) * τ / 1000.0);
    
    // Compute novelty (inverse of best recognition)
    var maxRecognition : Float = 0.0;
    var recognizedIds = Buffer.Buffer<Nat32>(results.size());
    
    for (result in results.vals()) {
      if (result.resonanceStrength > maxRecognition) {
        maxRecognition := result.resonanceStrength;
      };
      if (result.confidence > S₀) {
        recognizedIds.add(result.patternId);
      };
    };
    
    let novelty = 1.0 - maxRecognition;
    
    // Compute prediction error
    var predError : Float = 0.0;
    if (space.predictedNext.size() == newInput.size()) {
      var sumSqErr : Float = 0.0;
      var i = 0;
      while (i < newInput.size()) {
        let err = newInput[i] - space.predictedNext[i];
        sumSqErr += err * err;
        i += 1;
      };
      predError := Float.sqrt(sumSqErr / Float.fromInt(newInput.size()));
    };
    
    let newSpace : OuterPatternSpace = {
      space with
      currentInput = newInput;
      recognizedPatterns = Buffer.toArray(recognizedIds);
      noveltyLevel = novelty;
      predictionError = predError;
    };
    
    (newSpace, results)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   CROSS PATTERNS                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Cross patterns are correlations between inner and outer.
  // They represent "what inner states go with what outer situations".
  //
  // Examples:
  //   - "When I see this market pattern, I feel cautious"
  //   - "When I'm in flow state, threats seem smaller"
  //   - "This outer pattern always precedes that inner pattern"
  //
  public type CrossPattern = {
    innerPatternId : Nat32;
    outerPatternId : Nat32;
    correlationStrength : Float;
    direction : CrossDirection;
    
    // Timing
    typicalLag : Float;         // Time between inner and outer
    lagVariance : Float;
    
    // Feeling
    associatedFeeling : PatternFeeling;
  };

  public type CrossDirection = {
    #InnerCausesOuter;          // Inner state leads to outer pattern
    #OuterCausesInner;          // Outer pattern leads to inner state
    #Bidirectional;             // They co-occur
    #Unknown;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   META PATTERNS                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Meta patterns are patterns OF patterns.
  // They represent higher-order structure — "the pattern of how patterns relate".
  //
  // Examples:
  //   - "Patterns A, B, C always occur in sequence"
  //   - "When pattern X is strong, pattern Y is suppressed"
  //   - "This cluster of patterns forms a stable attractor"
  //
  public type MetaPattern = {
    constituentPatterns : [Nat32];  // Which patterns compose this
    structure : MetaStructure;
    
    // Coherence of the meta-pattern
    coherence : Float;
    stability : Float;
    
    // Recognition
    recognitionThreshold : Float;
    lastRecognized : Nat;
  };

  public type MetaStructure = {
    #Sequence : [Nat32];        // Ordered sequence
    #Cluster : [Nat32];         // Co-occurring group
    #Hierarchy : [(Nat32, Nat32)];  // Parent-child relations
    #Oscillation : (Nat32, Nat32);  // Alternating patterns
    #Attractor : [Nat32];       // Stable state composition
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   PATTERN CREATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // New patterns emerge when:
  //   1. Input doesn't match any existing pattern well (novelty)
  //   2. The novel input recurs (repetition)
  //   3. The recurrence has consistent structure (stability)
  //
  // Pattern creation is NOT storing a template.
  // Pattern creation is CRYSTALLIZING a new resonance mode.
  //
  public func maybeCreatePattern(
    input : [Float],
    existingPatterns : [Pattern],
    noveltyThreshold : Float,
    beat : Nat
  ) : ?Pattern {
    // Check novelty
    let results = recognize(input, existingPatterns, Float.fromInt(beat) * τ / 1000.0);
    
    var maxRecognition : Float = 0.0;
    for (result in results.vals()) {
      if (result.resonanceStrength > maxRecognition) {
        maxRecognition := result.resonanceStrength;
      };
    };
    
    // If too well recognized, don't create new pattern
    if (maxRecognition > noveltyThreshold) {
      return null;
    };
    
    // Create signature from input
    var sigDims = Buffer.Buffer<SignatureDim>(input.size());
    var i = 0;
    while (i < input.size()) {
      if (Float.abs(input[i]) > S₀) {  // Only significant dimensions
        sigDims.add({
          dimension = i;
          value = input[i];
          weight = 1.0;
        });
      };
      i += 1;
    };
    
    // Generate unique ID (simple hash)
    var hash : Nat32 = 2166136261;
    for (dim in sigDims.vals()) {
      let valBits = Nat32.fromNat(Int.abs(Float.toInt(dim.value * 1000000.0)) % 4294967296);
      hash := (hash ^ valBits) *% 16777619;
    };
    
    ?{
      id = hash;
      signature = Buffer.toArray(sigDims);
      frequency = φ;  // Start at golden frequency
      phase = 0.0;
      strength = S₀;  // Start at floor
      patternType = #Outer;  // Default to outer
      lastResonance = 0.0;
      resonanceCount = 0;
      depth = 0.0;
      valence = 0.0;
      arousal = 0.5;
      birthBeat = beat;
      lastTouch = beat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   PATTERN BREATHING                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Patterns breathe — they oscillate naturally.
  // This prevents stagnation and enables adaptive response.
  //
  // Breathing updates phase and modulates strength.
  //
  public func breathePattern(pattern : Pattern, beat : Nat) : Pattern {
    // Phase advances by frequency
    let phaseStep = τ * pattern.frequency / 1000.0;
    var newPhase = pattern.phase + phaseStep;
    while (newPhase >= τ) { newPhase -= τ };
    
    // Strength oscillates slightly (breathing)
    let breathAmplitude = 0.05;
    let breath = breathAmplitude * Float.sin(newPhase);
    let newStrength = clamp(pattern.strength + breath, S₀, φ);
    
    // Unused patterns slowly decay
    let decayRate = 0.0001;
    let timeSinceTouch = Float.fromInt(beat - pattern.lastTouch);
    let decay = decayRate * timeSinceTouch;
    let decayedStrength = clamp(newStrength - decay, S₀, φ);
    
    {
      pattern with
      phase = newPhase;
      strength = decayedStrength;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   THE COMPLETE PATTERN FABRIC                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type PatternFabricState = {
    // Pattern spaces
    innerSpace : InnerPatternSpace;
    outerSpace : OuterPatternSpace;
    
    // Cross patterns
    crossPatterns : [CrossPattern];
    
    // Meta patterns
    metaPatterns : [MetaPattern];
    
    // Global state
    overallCoherence : Float;    // How coherent is the whole fabric
    dominantFeeling : PatternFeeling;
    
    // Timing
    currentBeat : Nat;
    totalRecognitions : Nat;
    totalCreations : Nat;
  };

  public func initPatternFabric() : PatternFabricState {
    {
      innerSpace = {
        patterns = [];
        currentState = [];
        dominantPattern = null;
        stateCoherence = 1.0;
        attractorStrengths = [];
        transitionProbabilities = [];
      };
      outerSpace = {
        patterns = [];
        currentInput = [];
        recognizedPatterns = [];
        noveltyLevel = 1.0;
        predictedNext = [];
        predictionError = 0.0;
      };
      crossPatterns = [];
      metaPatterns = [];
      overallCoherence = 1.0;
      dominantFeeling = {
        rightness = 1.0;
        familiarity = 0.0;
        novelty = 1.0;
        importance = 0.5;
        urgency = 0.0;
      };
      currentBeat = 0;
      totalRecognitions = 0;
      totalCreations = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                   HELPER FUNCTIONS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func clamp(v: Float, lo: Float, hi: Float) : Float {
    if (v < lo) { lo } else if (v > hi) { hi } else { v }
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
  //  L E A R N I N G   &   M E M O R Y   M A T H E M A T I C S
  //
  //  Enterprise-Level Learning and Memory Algorithms
  //  Full HIM/HER Dual-Organism Memory Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // MEMORY CONSOLIDATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Ebbinghaus forgetting curve
  public func memoryForgettingCurve(
    initialStrength : Float,
    timePassed : Float,
    decayRate : Float
  ) : Float {
    initialStrength * Float.exp(-decayRate * timePassed)
  };

  /// Spaced repetition optimal interval
  public func memorySpacedRepetitionInterval(
    previousInterval : Float,
    easeFactor : Float,
    performance : Float
  ) : Float {
    let adjustedEase = easeFactor + 0.1 - (5.0 - performance) * 0.08;
    let newEase = if (adjustedEase < 1.3) 1.3 else adjustedEase;
    previousInterval * newEase
  };

  /// Memory strength update
  public func memoryStrengthUpdate(
    currentStrength : Float,
    rehearsal : Bool,
    decayRate : Float,
    boostAmount : Float
  ) : Float {
    let decayed = currentStrength * (1.0 - decayRate);
    if (rehearsal) { Float.min(decayed + boostAmount, 1.0) }
    else { decayed }
  };

  /// Sleep consolidation effect
  public func memorySleepConsolidation(
    hippocampalStrength : Float,
    corticalStrength : Float,
    sleepQuality : Float,
    transferRate : Float
  ) : (Float, Float) {
    let transfer = hippocampalStrength * sleepQuality * transferRate;
    (hippocampalStrength - transfer, corticalStrength + transfer)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ASSOCIATIVE LEARNING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rescorla-Wagner learning rule
  public func memoryRescorlaWagner(
    association : Float,
    learningRate : Float,
    reward : Float,
    maxAssociation : Float
  ) : Float {
    let predictionError = reward - association;
    association + learningRate * predictionError * (maxAssociation - association)
  };

  /// Temporal difference error
  public func memoryTDError(
    reward : Float,
    currentValue : Float,
    nextValue : Float,
    discountFactor : Float
  ) : Float {
    reward + discountFactor * nextValue - currentValue
  };

  /// Eligibility trace update
  public func memoryEligibilityTrace(
    trace : Float,
    decayRate : Float,
    visited : Bool
  ) : Float {
    let decayed = trace * decayRate;
    if (visited) { decayed + 1.0 } else { decayed }
  };

  /// Q-learning update
  public func memoryQLearningUpdate(
    qValue : Float,
    learningRate : Float,
    reward : Float,
    maxNextQ : Float,
    discountFactor : Float
  ) : Float {
    let target = reward + discountFactor * maxNextQ;
    qValue + learningRate * (target - qValue)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // PATTERN COMPLETION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Hopfield network energy
  public func memoryHopfieldEnergy(
    state : [Float],
    weights : [[Float]]
  ) : Float {
    let n = state.size();
    var energy : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        if (i != j) {
          energy -= 0.5 * weights[i][j] * state[i] * state[j];
        };
        j += 1;
      };
      i += 1;
    };
    energy
  };

  /// Pattern completion update
  public func memoryPatternCompletion(
    state : Float,
    weights : [Float],
    inputs : [Float],
    threshold : Float
  ) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < weights.size() and i < inputs.size()) {
      sum += weights[i] * inputs[i];
      i += 1;
    };
    if (sum > threshold) { 1.0 } else if (sum < -threshold) { -1.0 } else { state }
  };

  /// Sparse coding activation
  public func memorySparseCoding(
    input : Float,
    dictionary : [Float],
    sparsityPenalty : Float
  ) : [Float] {
    Array.tabulate<Float>(dictionary.size(), func(i : Nat) : Float {
      let activation = input * dictionary[i];
      let penalized = activation - sparsityPenalty;
      if (penalized > 0.0) { penalized } else { 0.0 }
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EPISODIC MEMORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Episode binding strength
  public func memoryEpisodeBinding(
    contextualSimilarity : Float,
    temporalProximity : Float,
    emotionalSalience : Float
  ) : Float {
    contextualSimilarity * temporalProximity * (1.0 + emotionalSalience)
  };

  /// Temporal context update
  public func memoryTemporalContext(
    currentContext : Float,
    input : Float,
    driftRate : Float
  ) : Float {
    (1.0 - driftRate) * currentContext + driftRate * input
  };

  /// Recollection probability
  public func memoryRecollectionProbability(
    cueStrength : Float,
    memoryStrength : Float,
    noise : Float
  ) : Float {
    let signal = cueStrength * memoryStrength;
    1.0 / (1.0 + Float.exp(-(signal - noise) / 0.5))
  };

  /// Familiarity signal
  public func memoryFamiliarity(
    featureMatch : Float,
    priorExposure : Float
  ) : Float {
    featureMatch * (1.0 + Float.log(priorExposure + 1.0))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CURRICULUM LEARNING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Task difficulty assessment
  public func memoryTaskDifficulty(
    complexity : Float,
    novelty : Float,
    performance : Float
  ) : Float {
    complexity * (1.0 + novelty) / (performance + 0.1)
  };

  /// Optimal learning zone
  public func memoryOptimalLearningZone(
    currentSkill : Float,
    taskDifficulty : Float,
    zoneWidth : Float
  ) : Float {
    let diff = Float.abs(taskDifficulty - currentSkill);
    if (diff < zoneWidth) { 1.0 - diff / zoneWidth } else { 0.0 }
  };

  /// Skill progression rate
  public func memorySkillProgression(
    practice : Float,
    difficulty : Float,
    currentSkill : Float
  ) : Float {
    let challenge = difficulty - currentSkill;
    if (challenge > 0.0) {
      practice * challenge * Float.exp(-challenge * challenge)
    } else {
      practice * 0.1  // Minimal progress if too easy
    }
  };

  /// Knowledge transfer coefficient
  public func memoryKnowledgeTransfer(
    sourceSkill : Float,
    targetSimilarity : Float
  ) : Float {
    sourceSkill * targetSimilarity * targetSimilarity
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // METACOGNITION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Confidence calibration
  public func memoryConfidenceCalibration(
    predicted : Float,
    actual : Float,
    history : [Float]
  ) : Float {
    let currentError = Float.abs(predicted - actual);
    var avgError : Float = 0.0;
    var i = 0;
    while (i < history.size()) {
      avgError += history[i];
      i += 1;
    };
    if (history.size() > 0) {
      avgError /= Float.fromInt(history.size());
    };
    1.0 - (currentError + avgError) / 2.0
  };

  /// Feeling of knowing
  public func memoryFeelingOfKnowing(
    partialRetrieval : Float,
    relatedActivation : Float
  ) : Float {
    (partialRetrieval + relatedActivation) / 2.0
  };

  /// Judgment of learning
  public func memoryJudgmentOfLearning(
    fluency : Float,
    effort : Float,
    priorKnowledge : Float
  ) : Float {
    let fluencyWeight = 0.4;
    let effortWeight = 0.3;
    let priorWeight = 0.3;
    fluencyWeight * fluency + effortWeight * (1.0 - effort) + priorWeight * priorKnowledge
  };

}
