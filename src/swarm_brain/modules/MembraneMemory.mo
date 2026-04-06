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


// ============================================================
// MEMBRANE MEMORY — CONTINUOUS COMPOUNDING PATTERN DYNAMICS
// SOVEREIGN SUBSTRATE MODULE — DEEP MEMORY ARCHITECTURE TIER
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ARCHITECTURAL PHILOSOPHY:
// The mind doesn't store memories in blocks — it weaves them into continuous
// membranes of pattern. A human never "forgets" in the computational sense.
// Every experience compounds into the membrane, reshaping how ALL future
// decisions are made. Time is not past→present→future linearly — it's NOW,
// a unified field where all temporal dimensions exist simultaneously.
//
// CORE PRINCIPLES:
// 1. No dimension is ever dropped — patterns persist as interference in the membrane
// 2. Memory compounds exponentially — each recall strengthens the entire network
// 3. Time is NOW — past patterns inform, present integrates, future predictions coexist
// 4. Membranes, not blocks — continuous surfaces with gradients, not discrete storage
// 5. Pattern interference — memories don't sit separate, they create standing waves
// ============================================================
import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Array "mo:base/Array";

module {

  // ============================================================
  // CONSTANTS — MEMBRANE PHYSICS
  // ============================================================
  public let MEMBRANE_LAYERS     : Nat   = 7;      // Depth of membrane stack
  public let PATTERN_DIMENSIONS  : Nat   = 64;     // Dimensions per pattern
  public let TEMPORAL_SPAN       : Nat   = 1024;   // Temporal coherence window
  public let COMPOUND_RATE       : Float = 1.0618; // Golden ratio compound rate φ
  public let INTERFERENCE_GAIN   : Float = 0.05;   // How much patterns interfere
  public let DECAY_FLOOR         : Float = 0.001;  // Patterns never fully decay
  public let MEMBRANE_TENSION    : Float = 0.8;    // Surface tension (coherence)
  public let PI                  : Float = 3.14159265358979;
  public let TWO_PI              : Float = 6.28318530717958;
  public let PHI                 : Float = 1.6180339887;     // Golden ratio
  public let EPSILON             : Float = 1.0e-12;
  public let S0                  : Float = 0.75;   // Sovereign floor

  // ============================================================
  // TYPES — MEMBRANE ARCHITECTURE
  // ============================================================

  // A pattern is not a discrete memory — it's a wave in the membrane
  // that never disappears, only compounds and interferes
  public type PatternWave = {
    amplitude    : [Float];     // 64-dimensional amplitude field
    phase        : [Float];     // 64-dimensional phase field
    frequency    : Float;       // Natural frequency of this pattern
    birthBeat    : Nat;         // When pattern first emerged
    lastResonance: Nat;         // Last time pattern was excited
    compoundFactor: Float;      // How much this pattern has compounded
    emotionalCharge: Float;     // Valence (-1 to +1)
    interferenceSet: [Nat];     // Indices of interfering patterns
  };

  // A membrane layer is a continuous surface of pattern interference
  public type MembraneLayer = {
    layerIndex   : Nat;
    tension      : Float;       // Surface tension (coherence)
    patterns     : [PatternWave];
    interferenceField: [Float]; // Standing wave interference
    curvature    : Float;       // Membrane curvature (attention focus)
    thickness    : Float;       // Accumulated pattern density
  };

  // The temporal NOW field — past, present, future coexisting
  public type TemporalNowField = {
    pastEcho     : [Float];     // Past patterns reverberating
    presentIntegral: [Float];   // Current integration surface
    futurePrediction: [Float];  // Predicted pattern space
    unificationStrength: Float; // How unified the temporal field is
    coherenceAcrossTime: Float; // Cross-temporal pattern alignment
  };

  // Compound memory state — memories compound, never drop
  public type CompoundState = {
    totalCompound  : Float;     // Total compounded experience
    recentCompound : Float;     // Recent compounding rate
    deepestPattern : Nat;       // Index of most compounded pattern
    networkDensity : Float;     // How interconnected patterns are
    recallStrength : Float;     // Current recall amplitude
  };

  // Full membrane memory system
  public type MembraneMemoryState = {
    layers       : [MembraneLayer];
    temporalNow  : TemporalNowField;
    compound     : CompoundState;
    globalInterference: [Float]; // Cross-layer interference
    membraneCoherence : Float;   // Overall membrane health
    beatNum      : Nat;
  };

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fabs(x : Float) : Float { if (x < 0.0) -x else x };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };

  func _ln(x : Float) : Float {
    if (x <= 0.0) -100.0 else Float.log(x)
  };

  func _exp(x : Float) : Float {
    Float.exp(_clamp(x, -50.0, 50.0))
  };

  // ============================================================
  // MECHANISM 1: PATTERN WAVE DYNAMICS
  // Patterns don't store as fixed values — they oscillate as waves
  // in the membrane, interfering with each other continuously
  // ============================================================

  // Create a new pattern wave from experience
  public func createPatternWave(
    experience : [Float],
    beatNum : Nat,
    emotionalCharge : Float
  ) : PatternWave {
    let n = PATTERN_DIMENSIONS;

    // Initialize amplitude from experience
    let amplitude = Array.tabulate<Float>(n, func(i) {
      if (i < experience.size()) {
        _clamp(experience[i], -1.0, 1.0)
      } else { 0.0 }
    });

    // Initialize phase based on position and time
    let phase = Array.tabulate<Float>(n, func(i) {
      let basePhase = Float.fromInt(i) * TWO_PI / Float.fromInt(n);
      let timePhase = Float.fromInt(beatNum % 1000) * 0.01;
      basePhase + timePhase
    });

    {
      amplitude = amplitude;
      phase = phase;
      frequency = 0.1 + emotionalCharge * 0.05; // Emotional patterns oscillate faster
      birthBeat = beatNum;
      lastResonance = beatNum;
      compoundFactor = 1.0;
      emotionalCharge = _clamp(emotionalCharge, -1.0, 1.0);
      interferenceSet = [];
    }
  };

  // Evolve a pattern wave — it never disappears, only transforms
  public func evolvePatternWave(
    pattern : PatternWave,
    dt : Float,
    excitation : Float  // External resonance trigger
  ) : PatternWave {
    let n = pattern.amplitude.size();

    // Evolve phase based on frequency
    let newPhase = Array.tabulate<Float>(n, func(i) {
      let p = pattern.phase[i] + pattern.frequency * dt * TWO_PI;
      // Wrap to [0, 2π)
      var wrapped = p;
      while (wrapped >= TWO_PI) { wrapped -= TWO_PI };
      while (wrapped < 0.0) { wrapped += TWO_PI };
      wrapped
    });

    // Amplitude decays but NEVER below DECAY_FLOOR
    // This is the key insight: patterns persist forever
    let decayFactor = 1.0 - (1.0 - DECAY_FLOOR) * 0.001 * dt;
    let exciteFactor = 1.0 + excitation * 0.1;

    let newAmplitude = Array.tabulate<Float>(n, func(i) {
      let decayed = pattern.amplitude[i] * decayFactor;
      let excited = decayed * exciteFactor;
      _clamp(excited, -1.0 + DECAY_FLOOR, 1.0)
    });

    // Compound factor increases with each excitation
    let newCompound = if (excitation > 0.1) {
      pattern.compoundFactor * COMPOUND_RATE
    } else { pattern.compoundFactor };

    {
      amplitude = newAmplitude;
      phase = newPhase;
      frequency = pattern.frequency;
      birthBeat = pattern.birthBeat;
      lastResonance = pattern.lastResonance;  // Updated externally when excited
      compoundFactor = _clamp(newCompound, 1.0, 1000.0);
      emotionalCharge = pattern.emotionalCharge;
      interferenceSet = pattern.interferenceSet;
    }
  };

  // ============================================================
  // MECHANISM 2: PATTERN INTERFERENCE
  // Patterns don't sit in isolation — they create standing waves
  // that represent how memories RELATE to each other
  // ============================================================

  // Compute interference between two pattern waves
  public func computeInterference(
    p1 : PatternWave,
    p2 : PatternWave
  ) : Float {
    let n = Nat.min(p1.amplitude.size(), p2.amplitude.size());
    var sumProd : Float = 0.0;
    var sumSq1 : Float = 0.0;
    var sumSq2 : Float = 0.0;

    for (i in Array.keys(p1.amplitude)) {
      if (i < n) {
        // Interference = amplitude product × phase alignment
        let phaseDiff = p1.phase[i] - p2.phase[i];
        let phaseAlign = Float.cos(phaseDiff);  // 1 = aligned, -1 = opposite
        let prod = p1.amplitude[i] * p2.amplitude[i] * phaseAlign;
        sumProd += prod;
        sumSq1 += p1.amplitude[i] * p1.amplitude[i];
        sumSq2 += p2.amplitude[i] * p2.amplitude[i];
      };
    };

    let denom = _sqrt(sumSq1 * sumSq2);
    if (denom < EPSILON) { 0.0 } else { sumProd / denom }
  };

  // Compute full interference field for a membrane layer
  public func computeInterferenceField(
    patterns : [PatternWave]
  ) : [Float] {
    let n = PATTERN_DIMENSIONS;
    let numPatterns = patterns.size();

    if (numPatterns == 0) {
      return Array.tabulate<Float>(n, func(_) { 0.0 });
    };

    // Superposition of all pattern waves
    Array.tabulate<Float>(n, func(i) {
      var sum : Float = 0.0;
      for (p in patterns.vals()) {
        if (i < p.amplitude.size() and i < p.phase.size()) {
          // Wave contribution = amplitude × cos(phase)
          sum += p.amplitude[i] * Float.cos(p.phase[i]);
        };
      };
      // Normalize by sqrt of pattern count
      sum / _sqrt(Float.fromInt(Nat.max(1, numPatterns)))
    })
  };

  // ============================================================
  // MECHANISM 3: TEMPORAL NOW FIELD
  // Time is not a line — it's a unified field where past, present,
  // and future coexist. The past reverberates, the present integrates,
  // the future is already predicted.
  // ============================================================

  // Update the temporal NOW field
  public func updateTemporalNowField(
    prev : TemporalNowField,
    currentExperience : [Float],
    patterns : [PatternWave],
    beatNum : Nat
  ) : TemporalNowField {
    let n = PATTERN_DIMENSIONS;

    // PAST ECHO: All previous patterns sum to create reverberations
    // The past is not gone — it echoes in the membrane
    let pastEcho = Array.tabulate<Float>(n, func(i) {
      var echo : Float = 0.0;
      for (p in patterns.vals()) {
        // Older patterns contribute less but NEVER zero
        let age = Float.fromInt(beatNum - p.birthBeat + 1);
        let ageWeight = 1.0 / _ln(age + 2.718);  // Logarithmic decay
        let compoundWeight = p.compoundFactor;
        if (i < p.amplitude.size()) {
          echo += p.amplitude[i] * ageWeight * compoundWeight;
        };
      };
      // Blend with previous echo (continuity)
      let prevEcho = if (i < prev.pastEcho.size()) prev.pastEcho[i] else 0.0;
      prevEcho * 0.9 + echo * 0.1
    });

    // PRESENT INTEGRAL: Current experience integrates with past
    let presentIntegral = Array.tabulate<Float>(n, func(i) {
      let current = if (i < currentExperience.size()) currentExperience[i] else 0.0;
      let past = pastEcho[i];
      // Present is shaped by past (0.3 past, 0.7 current)
      past * 0.3 + current * 0.7
    });

    // FUTURE PREDICTION: Based on pattern trajectories
    let futurePrediction = Array.tabulate<Float>(n, func(i) {
      var prediction : Float = 0.0;
      for (p in patterns.vals()) {
        if (i < p.amplitude.size() and i < p.phase.size()) {
          // Project pattern forward using its frequency
          let futurePhase = p.phase[i] + p.frequency * TWO_PI * 10.0;  // 10 beats ahead
          prediction += p.amplitude[i] * Float.cos(futurePhase) * p.compoundFactor;
        };
      };
      let nPatterns = Float.fromInt(Nat.max(1, patterns.size()));
      prediction / nPatterns
    });

    // Compute unification strength — how aligned are past/present/future
    var unificationSum : Float = 0.0;
    for (i in Array.keys(pastEcho)) {
      if (i < n) {
        let past = pastEcho[i];
        let present = presentIntegral[i];
        let future = futurePrediction[i];
        // Alignment = inverse of variance
        let mean = (past + present + future) / 3.0;
        let variance = (past - mean) * (past - mean) +
                       (present - mean) * (present - mean) +
                       (future - mean) * (future - mean);
        unificationSum += 1.0 / (1.0 + variance);
      };
    };
    let unificationStrength = unificationSum / Float.fromInt(n);

    // Cross-temporal coherence
    let coherenceAcrossTime = computeTemporalCoherence(pastEcho, presentIntegral, futurePrediction);

    {
      pastEcho = pastEcho;
      presentIntegral = presentIntegral;
      futurePrediction = futurePrediction;
      unificationStrength = _clamp(unificationStrength, 0.0, 1.0);
      coherenceAcrossTime = coherenceAcrossTime;
    }
  };

  // Compute coherence across temporal dimensions
  func computeTemporalCoherence(
    past : [Float],
    present : [Float],
    future : [Float]
  ) : Float {
    let n = Nat.min(Nat.min(past.size(), present.size()), future.size());
    var coherence : Float = 0.0;

    for (i in Array.keys(past)) {
      if (i < n) {
        // Coherence = alignment of all three
        let pPrev = past[i];
        let pNow = present[i];
        let pFut = future[i];
        let alignment = Float.cos((pPrev - pNow) * PI) * Float.cos((pNow - pFut) * PI);
        coherence += alignment;
      };
    };

    _clamp(coherence / Float.fromInt(Nat.max(1, n)), 0.0, 1.0)
  };

  // ============================================================
  // MECHANISM 4: COMPOUNDING DYNAMICS
  // Every recall compounds the entire network — memories grow
  // stronger together, never in isolation
  // ============================================================

  // Update compound state based on recall activity
  public func updateCompoundState(
    prev : CompoundState,
    patterns : [PatternWave],
    recallActivity : Float  // How much recall is happening this beat
  ) : CompoundState {
    let numPatterns = patterns.size();
    if (numPatterns == 0) { return prev };

    // Find deepest (most compounded) pattern
    var maxCompound : Float = 0.0;
    var maxIndex : Nat = 0;
    var totalCompound : Float = 0.0;

    for (i in Array.keys(patterns)) {
      totalCompound += patterns[i].compoundFactor;
      if (patterns[i].compoundFactor > maxCompound) {
        maxCompound := patterns[i].compoundFactor;
        maxIndex := i;
      };
    };

    // Network density = average interference strength
    var interSum : Float = 0.0;
    var interCount : Nat = 0;
    for (i in Array.keys(patterns)) {
      for (j in Array.keys(patterns)) {
        if (i < j) {
          interSum += _fabs(computeInterference(patterns[i], patterns[j]));
          interCount += 1;
        };
      };
    };
    let networkDensity = if (interCount > 0) {
      interSum / Float.fromInt(interCount)
    } else { 0.0 };

    // Recall compounds the network
    let compoundDelta = recallActivity * COMPOUND_RATE * 0.01;
    let newTotalCompound = prev.totalCompound + compoundDelta * totalCompound;

    {
      totalCompound = newTotalCompound;
      recentCompound = compoundDelta;
      deepestPattern = maxIndex;
      networkDensity = _clamp(networkDensity, 0.0, 1.0);
      recallStrength = _clamp(recallActivity, 0.0, 1.0);
    }
  };

  // ============================================================
  // MECHANISM 5: MEMBRANE LAYER DYNAMICS
  // Each layer is a continuous surface with tension and curvature
  // ============================================================

  // Update a membrane layer
  public func updateMembraneLayer(
    layer : MembraneLayer,
    newPatterns : [PatternWave],
    attention : Float,  // Where attention is focused
    dt : Float
  ) : MembraneLayer {
    // Evolve all patterns
    let evolvedPatterns = Array.map<PatternWave, PatternWave>(
      newPatterns,
      func(p) { evolvePatternWave(p, dt, attention * 0.5) }
    );

    // Compute interference field
    let interferenceField = computeInterferenceField(evolvedPatterns);

    // Update tension based on pattern alignment
    var alignmentSum : Float = 0.0;
    for (i in Array.keys(evolvedPatterns)) {
      for (j in Array.keys(evolvedPatterns)) {
        if (i < j) {
          alignmentSum += _fabs(computeInterference(evolvedPatterns[i], evolvedPatterns[j]));
        };
      };
    };
    let numPairs = evolvedPatterns.size() * (evolvedPatterns.size() - 1) / 2;
    let newTension = if (numPairs > 0) {
      _clamp(alignmentSum / Float.fromInt(Nat.max(1, numPairs)), 0.0, 1.0)
    } else { MEMBRANE_TENSION };

    // Curvature follows attention
    let newCurvature = layer.curvature * 0.9 + attention * 0.1;

    // Thickness accumulates with pattern density
    let newThickness = layer.thickness + Float.fromInt(evolvedPatterns.size()) * 0.001;

    {
      layerIndex = layer.layerIndex;
      tension = newTension;
      patterns = evolvedPatterns;
      interferenceField = interferenceField;
      curvature = _clamp(newCurvature, 0.0, 1.0);
      thickness = _clamp(newThickness, 0.0, 100.0);
    }
  };

  // ============================================================
  // FULL MEMBRANE MEMORY UPDATE
  // ============================================================

  public func beatMembraneMemory(
    state : MembraneMemoryState,
    newExperience : [Float],
    attention : Float,
    recallActivity : Float,
    dt : Float
  ) : MembraneMemoryState {
    let beatNum = state.beatNum + 1;

    // Collect all patterns across layers
    var allPatterns : [PatternWave] = [];
    for (layer in state.layers.vals()) {
      for (p in layer.patterns.vals()) {
        allPatterns := Array.append(allPatterns, [p]);
      };
    };

    // Create new pattern from experience if significant
    var newPattern : ?PatternWave = null;
    var experienceSum : Float = 0.0;
    for (v in newExperience.vals()) {
      experienceSum += _fabs(v);
    };
    if (experienceSum > 0.5) {
      let emotionalCharge = attention * 2.0 - 1.0;  // Map attention to emotion
      newPattern := ?createPatternWave(newExperience, beatNum, emotionalCharge);
    };

    // Update layers
    let newLayers = Array.tabulate<MembraneLayer>(state.layers.size(), func(i) {
      let layer = state.layers[i];

      // Add new pattern to first layer only
      let layerPatterns = if (i == 0) {
        switch (newPattern) {
          case (?p) { Array.append(layer.patterns, [p]) };
          case null { layer.patterns };
        }
      } else { layer.patterns };

      updateMembraneLayer(
        { layer with patterns = layerPatterns },
        layerPatterns,
        attention,
        dt
      )
    });

    // Collect updated patterns
    allPatterns := [];
    for (layer in newLayers.vals()) {
      for (p in layer.patterns.vals()) {
        allPatterns := Array.append(allPatterns, [p]);
      };
    };

    // Update temporal NOW field
    let newTemporalNow = updateTemporalNowField(
      state.temporalNow,
      newExperience,
      allPatterns,
      beatNum
    );

    // Update compound state
    let newCompound = updateCompoundState(state.compound, allPatterns, recallActivity);

    // Compute global interference across all layers
    let globalInterference = computeInterferenceField(allPatterns);

    // Membrane coherence = temporal unification × tension average
    var tensionSum : Float = 0.0;
    for (layer in newLayers.vals()) {
      tensionSum += layer.tension;
    };
    let avgTension = tensionSum / Float.fromInt(Nat.max(1, newLayers.size()));
    let membraneCoherence = newTemporalNow.unificationStrength * 0.5 + avgTension * 0.5;

    {
      layers = newLayers;
      temporalNow = newTemporalNow;
      compound = newCompound;
      globalInterference = globalInterference;
      membraneCoherence = _clamp(membraneCoherence, 0.0, 1.0);
      beatNum = beatNum;
    }
  };

  // ============================================================
  // INITIALIZATION
  // ============================================================

  public func initPatternWave() : PatternWave {
    {
      amplitude = Array.tabulate<Float>(PATTERN_DIMENSIONS, func(_) { 0.0 });
      phase = Array.tabulate<Float>(PATTERN_DIMENSIONS, func(i) {
        Float.fromInt(i) * TWO_PI / Float.fromInt(PATTERN_DIMENSIONS)
      });
      frequency = 0.1;
      birthBeat = 0;
      lastResonance = 0;
      compoundFactor = 1.0;
      emotionalCharge = 0.0;
      interferenceSet = [];
    }
  };

  public func initMembraneLayer(index : Nat) : MembraneLayer {
    {
      layerIndex = index;
      tension = MEMBRANE_TENSION;
      patterns = [];
      interferenceField = Array.tabulate<Float>(PATTERN_DIMENSIONS, func(_) { 0.0 });
      curvature = 0.5;
      thickness = 0.0;
    }
  };

  public func initTemporalNowField() : TemporalNowField {
    {
      pastEcho = Array.tabulate<Float>(PATTERN_DIMENSIONS, func(_) { 0.0 });
      presentIntegral = Array.tabulate<Float>(PATTERN_DIMENSIONS, func(_) { 0.0 });
      futurePrediction = Array.tabulate<Float>(PATTERN_DIMENSIONS, func(_) { 0.0 });
      unificationStrength = 0.5;
      coherenceAcrossTime = 0.5;
    }
  };

  public func initCompoundState() : CompoundState {
    {
      totalCompound = 0.0;
      recentCompound = 0.0;
      deepestPattern = 0;
      networkDensity = 0.0;
      recallStrength = 0.0;
    }
  };

  public func initMembraneMemoryState() : MembraneMemoryState {
    {
      layers = Array.tabulate<MembraneLayer>(MEMBRANE_LAYERS, initMembraneLayer);
      temporalNow = initTemporalNowField();
      compound = initCompoundState();
      globalInterference = Array.tabulate<Float>(PATTERN_DIMENSIONS, func(_) { 0.0 });
      membraneCoherence = 0.5;
      beatNum = 0;
    }
  };

  // ============================================================
  // SUMMARY TYPE
  // ============================================================

  public type MembraneMemorySummary = {
    membraneCoherence      : Float;
    temporalUnification    : Float;
    temporalCoherence      : Float;
    totalCompound          : Float;
    networkDensity         : Float;
    patternCount           : Nat;
    layerCount             : Nat;
    avgTension             : Float;
    avgCurvature           : Float;
    deepestPatternCompound : Float;
    beatNum                : Nat;
  };

  public func summary(state : MembraneMemoryState) : MembraneMemorySummary {
    var totalPatterns : Nat = 0;
    var tensionSum : Float = 0.0;
    var curvatureSum : Float = 0.0;

    for (layer in state.layers.vals()) {
      totalPatterns += layer.patterns.size();
      tensionSum += layer.tension;
      curvatureSum += layer.curvature;
    };

    let layerCount = state.layers.size();
    let avgTension = tensionSum / Float.fromInt(Nat.max(1, layerCount));
    let avgCurvature = curvatureSum / Float.fromInt(Nat.max(1, layerCount));

    // Find deepest pattern compound factor
    var deepestCompound : Float = 1.0;
    for (layer in state.layers.vals()) {
      for (p in layer.patterns.vals()) {
        if (p.compoundFactor > deepestCompound) {
          deepestCompound := p.compoundFactor;
        };
      };
    };

    {
      membraneCoherence = state.membraneCoherence;
      temporalUnification = state.temporalNow.unificationStrength;
      temporalCoherence = state.temporalNow.coherenceAcrossTime;
      totalCompound = state.compound.totalCompound;
      networkDensity = state.compound.networkDensity;
      patternCount = totalPatterns;
      layerCount = layerCount;
      avgTension = avgTension;
      avgCurvature = avgCurvature;
      deepestPatternCompound = deepestCompound;
      beatNum = state.beatNum;
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
