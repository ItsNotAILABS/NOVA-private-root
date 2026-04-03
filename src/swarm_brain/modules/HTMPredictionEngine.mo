// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: HTMPredictionEngine — Hierarchical Temporal Memory Prediction
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    HTM PREDICTION ENGINE — HAWKINS UPGRADE               ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  Based on Jeff Hawkins' Hierarchical Temporal Memory (HTM) theory.       ║
// ║  From "On Intelligence" and Numenta research.                            ║
// ║                                                                          ║
// ║  CORE INSIGHT:                                                           ║
// ║    The brain doesn't process — it PREDICTS.                              ║
// ║    Perception is prediction. Learning is prediction error.               ║
// ║    Intelligence is the ability to predict accurately.                    ║
// ║                                                                          ║
// ║  SPARSE DISTRIBUTED REPRESENTATIONS (SDR):                               ║
// ║    - 64 dimensions, 2% active = ~1-2 bits per dimension                  ║
// ║    - Massive capacity: C(64,2) ≈ 2016 unique patterns                   ║
// ║    - Noise tolerant: similar patterns have similar SDRs                  ║
// ║    - Union-friendly: can represent "A or B" by ORing bits                ║
// ║                                                                          ║
// ║  PREDICTION BUFFER:                                                      ║
// ║    predicted_next_state: What we expect                                  ║
// ║    actual_next_state: What happened                                      ║
// ║    prediction_error = hamming_distance(predicted, actual) / 64           ║
// ║                                                                          ║
// ║    if error > 0.15:                                                      ║
// ║      → SURPRISE! Hebbian update fires, dopamine spikes                   ║
// ║    else:                                                                 ║
// ║      → Confirmation is free, no energy spent                             ║
// ║                                                                          ║
// ║  RESULT: Entities that predict correctly get stronger faster.            ║
// ║          Entities that are surprised must learn or die.                  ║
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
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  
  // SDR parameters
  public let SDR_SIZE : Nat = 64;           // Dimensions
  public let SDR_SPARSITY : Float = 0.02;   // 2% active
  public let ACTIVE_BITS : Nat = 2;         // SDR_SIZE × SDR_SPARSITY ≈ 1-2
  
  // Prediction thresholds
  public let SURPRISE_THRESHOLD : Float = 0.15;   // 15% error = surprise
  public let NOVELTY_THRESHOLD : Float = 0.30;    // 30% error = novel event
  public let LEARNING_RATE : Float = 0.275;       // Hebbian learning rate (φ⁻² × 0.72)
  
  // Temporal parameters
  public let PREDICTION_HORIZON : Nat = 8;        // F[6] beats ahead
  public let CONTEXT_WINDOW : Nat = 13;           // F[7] past states
  
  // Fibonacci for timing
  public let F : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPARSE DISTRIBUTED REPRESENTATION                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // SDRs are binary vectors with only 2% active bits.
  // We represent them as arrays of active bit indices for efficiency.
  //
  
  /// SDR represented as set of active bit indices
  public type SDR = {
    activeBits : [Nat];       // Indices of active bits (0-63)
    dimensions : Nat;         // Total dimensions (64)
  };
  
  /// Create SDR from active bit indices
  public func createSDR(activeBits: [Nat]) : SDR {
    // Filter to valid range and ensure no duplicates
    let validBits = Buffer.Buffer<Nat>(activeBits.size());
    for (bit in activeBits.vals()) {
      if (bit < SDR_SIZE) {
        var isDuplicate = false;
        for (existing in validBits.vals()) {
          if (existing == bit) { isDuplicate := true };
        };
        if (not isDuplicate) {
          validBits.add(bit);
        };
      };
    };
    
    { activeBits = Buffer.toArray(validBits); dimensions = SDR_SIZE }
  };
  
  /// Create SDR from float array (threshold top 2% as active)
  public func sdrFromFloats(values: [Float]) : SDR {
    // Find threshold for top 2%
    let n = values.size();
    if (n == 0) { return { activeBits = []; dimensions = SDR_SIZE } };
    
    // Simple approach: find the 2 highest values
    let numActive = Nat.max(1, Nat.min(3, n * 2 / 100 + 1));
    
    // Track top indices
    let topIndices = Buffer.Buffer<Nat>(numActive);
    let topValues = Buffer.Buffer<Float>(numActive);
    
    var i = 0;
    while (i < n and i < SDR_SIZE) {
      let val = if (i < values.size()) { values[i] } else { 0.0 };
      
      // Insert in sorted order
      var inserted = false;
      var j = 0;
      while (j < topValues.size() and not inserted) {
        if (val > topValues.get(j)) {
          // Insert here
          if (topValues.size() < numActive) {
            topValues.add(0.0);
            topIndices.add(0);
          };
          // Shift down
          var k = topValues.size() - 1;
          while (k > j) {
            topValues.put(k, topValues.get(k - 1));
            topIndices.put(k, topIndices.get(k - 1));
            k -= 1;
          };
          topValues.put(j, val);
          topIndices.put(j, i);
          inserted := true;
        };
        j += 1;
      };
      
      if (not inserted and topValues.size() < numActive) {
        topValues.add(val);
        topIndices.add(i);
      };
      
      i += 1;
    };
    
    { activeBits = Buffer.toArray(topIndices); dimensions = SDR_SIZE }
  };
  
  /// Convert SDR to dense float array
  public func sdrToDense(sdr: SDR) : [Float] {
    Array.tabulate<Float>(SDR_SIZE, func(i) {
      var isActive = false;
      for (bit in sdr.activeBits.vals()) {
        if (bit == i) { isActive := true };
      };
      if (isActive) { 1.0 } else { 0.0 }
    })
  };
  
  /// Hamming distance between two SDRs
  public func hammingDistance(a: SDR, b: SDR) : Nat {
    // Count bits in A but not B, plus bits in B but not A
    var distance : Nat = 0;
    
    // Bits in A but not B
    for (bitA in a.activeBits.vals()) {
      var found = false;
      for (bitB in b.activeBits.vals()) {
        if (bitA == bitB) { found := true };
      };
      if (not found) { distance += 1 };
    };
    
    // Bits in B but not A
    for (bitB in b.activeBits.vals()) {
      var found = false;
      for (bitA in a.activeBits.vals()) {
        if (bitA == bitB) { found := true };
      };
      if (not found) { distance += 1 };
    };
    
    distance
  };
  
  /// Normalized Hamming distance [0, 1]
  public func normalizedHammingDistance(a: SDR, b: SDR) : Float {
    let dist = hammingDistance(a, b);
    Float.fromInt(dist) / Float.fromInt(SDR_SIZE)
  };
  
  /// Overlap (intersection) between SDRs
  public func overlap(a: SDR, b: SDR) : Nat {
    var count : Nat = 0;
    for (bitA in a.activeBits.vals()) {
      for (bitB in b.activeBits.vals()) {
        if (bitA == bitB) { count += 1 };
      };
    };
    count
  };
  
  /// Union of two SDRs
  public func unionSDR(a: SDR, b: SDR) : SDR {
    let combined = Buffer.Buffer<Nat>(a.activeBits.size() + b.activeBits.size());
    
    for (bit in a.activeBits.vals()) {
      combined.add(bit);
    };
    
    for (bit in b.activeBits.vals()) {
      var isDuplicate = false;
      for (existing in a.activeBits.vals()) {
        if (existing == bit) { isDuplicate := true };
      };
      if (not isDuplicate) {
        combined.add(bit);
      };
    };
    
    { activeBits = Buffer.toArray(combined); dimensions = SDR_SIZE }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PREDICTION BUFFER                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type PredictionBuffer = {
    entityId : Nat;
    
    // Current predictions
    predictedNextState : SDR;
    predictionConfidence : Float;     // [0, 1] how confident
    predictionBeat : Nat;             // When prediction was made
    
    // Actual outcomes
    actualNextState : SDR;
    actualBeat : Nat;
    
    // Prediction error history
    recentErrors : [Float];           // Last 13 prediction errors
    averageError : Float;             // Running average
    
    // Learning state
    surpriseCount : Nat;              // Total surprises experienced
    noveltyCount : Nat;               // Novel events discovered
    correctPredictions : Nat;         // Successful predictions
    totalPredictions : Nat;
    
    // Context (past states for temporal prediction)
    contextWindow : [SDR];            // Last 13 states
    
    // Temporal sequences learned
    sequenceMemory : [TemporalSequence];
  };
  
  public type TemporalSequence = {
    trigger : SDR;                    // State that triggers prediction
    prediction : SDR;                 // What usually follows
    confidence : Float;               // How often this is correct
    occurrences : Nat;                // Times observed
    lastSeen : Nat;                   // Beat number
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PREDICTION ENGINE                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Make a prediction based on current state and learned sequences
  public func makePrediction(
    buffer: PredictionBuffer,
    currentState: SDR,
    currentBeat: Nat
  ) : (SDR, Float) {
    // Look for matching temporal sequences
    var bestMatch : ?TemporalSequence = null;
    var bestOverlap : Nat = 0;
    
    for (seq in buffer.sequenceMemory.vals()) {
      let overlapCount = overlap(currentState, seq.trigger);
      if (overlapCount > bestOverlap and overlapCount >= 1) {
        bestOverlap := overlapCount;
        bestMatch := ?seq;
      };
    };
    
    switch (bestMatch) {
      case (?seq) {
        // Use the learned prediction
        (seq.prediction, seq.confidence)
      };
      case null {
        // No sequence match — predict current state persists
        // (simplest prediction: nothing changes)
        (currentState, 0.3)  // Low confidence
      };
    }
  };
  
  /// Evaluate prediction against actual outcome
  public func evaluatePrediction(
    buffer: PredictionBuffer,
    actualState: SDR,
    currentBeat: Nat
  ) : PredictionResult {
    // Calculate prediction error
    let error = normalizedHammingDistance(buffer.predictedNextState, actualState);
    
    // Determine if this is a surprise
    let isSurprise = error > SURPRISE_THRESHOLD;
    let isNovel = error > NOVELTY_THRESHOLD;
    
    // Calculate dopamine response
    // Surprise → dopamine spike (novelty reward)
    // Correct prediction → baseline (confirmation is free)
    let dopamineResponse = if (isNovel) {
      0.8 + error * 0.2  // High spike for novel events
    } else if (isSurprise) {
      0.5 + error * 0.3  // Moderate spike for surprise
    } else {
      0.1  // Baseline for correct predictions
    };
    
    // Calculate Hebbian update strength
    // Only learn when surprised — correct predictions don't need updates
    let hebbianStrength = if (isSurprise) {
      LEARNING_RATE * error
    } else {
      0.0  // No learning for correct predictions
    };
    
    {
      predictionError = error;
      isSurprise = isSurprise;
      isNovelEvent = isNovel;
      dopamineSpike = dopamineResponse;
      hebbianUpdateStrength = hebbianStrength;
      predictedState = buffer.predictedNextState;
      actualState = actualState;
      beat = currentBeat;
    }
  };
  
  public type PredictionResult = {
    predictionError : Float;          // [0, 1]
    isSurprise : Bool;                // Error > 15%
    isNovelEvent : Bool;              // Error > 30%
    dopamineSpike : Float;            // [0, 1] reward signal
    hebbianUpdateStrength : Float;    // How much to update weights
    predictedState : SDR;
    actualState : SDR;
    beat : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SEQUENCE LEARNING                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Learn a temporal sequence from transition
  public func learnSequence(
    buffer: PredictionBuffer,
    previousState: SDR,
    currentState: SDR,
    currentBeat: Nat
  ) : PredictionBuffer {
    // Look for existing sequence with this trigger
    let newSequences = Buffer.Buffer<TemporalSequence>(buffer.sequenceMemory.size() + 1);
    var found = false;
    
    for (seq in buffer.sequenceMemory.vals()) {
      let triggerOverlap = overlap(previousState, seq.trigger);
      let predictionOverlap = overlap(currentState, seq.prediction);
      
      if (triggerOverlap >= 1) {
        // Update existing sequence
        found := true;
        
        // Blend new observation with existing prediction
        let newPrediction = if (predictionOverlap >= 1) {
          // Prediction was somewhat correct — reinforce
          seq.prediction
        } else {
          // Prediction was wrong — blend with actual
          unionSDR(seq.prediction, currentState)
        };
        
        // Update confidence
        let wasCorrect = predictionOverlap >= 1;
        let newConf = if (wasCorrect) {
          seq.confidence * 0.9 + 0.1  // Increase confidence
        } else {
          seq.confidence * 0.8  // Decrease confidence
        };
        
        newSequences.add({
          trigger = seq.trigger;
          prediction = newPrediction;
          confidence = _clamp(newConf, 0.1, 0.99);
          occurrences = seq.occurrences + 1;
          lastSeen = currentBeat;
        });
      } else {
        // Keep unchanged
        newSequences.add(seq);
      };
    };
    
    // If no matching sequence found, create new one
    if (not found and previousState.activeBits.size() > 0) {
      newSequences.add({
        trigger = previousState;
        prediction = currentState;
        confidence = 0.5;  // Initial confidence
        occurrences = 1;
        lastSeen = currentBeat;
      });
    };
    
    // Prune old sequences (keep most recent 89 = F[11])
    let maxSequences = 89;
    let prunedSequences = if (newSequences.size() > maxSequences) {
      // Sort by recency and keep top
      let arr = Buffer.toArray(newSequences);
      // Simple pruning: keep first maxSequences
      Array.tabulate<TemporalSequence>(maxSequences, func(i) { arr[i] })
    } else {
      Buffer.toArray(newSequences)
    };
    
    // Update context window
    let newContext = Buffer.Buffer<SDR>(CONTEXT_WINDOW);
    // Add current state first
    newContext.add(currentState);
    // Add previous states (up to limit)
    var i = 0;
    while (i < buffer.contextWindow.size() and newContext.size() < CONTEXT_WINDOW) {
      newContext.add(buffer.contextWindow[i]);
      i += 1;
    };
    
    // Update error history
    let newErrors = Buffer.Buffer<Float>(CONTEXT_WINDOW);
    for (err in buffer.recentErrors.vals()) {
      if (newErrors.size() < CONTEXT_WINDOW) {
        newErrors.add(err);
      };
    };
    
    // Calculate new average error
    var errorSum : Float = 0.0;
    for (err in newErrors.vals()) {
      errorSum += err;
    };
    let avgErr = if (newErrors.size() > 0) { 
      errorSum / Float.fromInt(newErrors.size()) 
    } else { 0.0 };
    
    {
      entityId = buffer.entityId;
      predictedNextState = buffer.predictedNextState;
      predictionConfidence = buffer.predictionConfidence;
      predictionBeat = buffer.predictionBeat;
      actualNextState = currentState;
      actualBeat = currentBeat;
      recentErrors = Buffer.toArray(newErrors);
      averageError = avgErr;
      surpriseCount = buffer.surpriseCount;
      noveltyCount = buffer.noveltyCount;
      correctPredictions = buffer.correctPredictions;
      totalPredictions = buffer.totalPredictions;
      contextWindow = Buffer.toArray(newContext);
      sequenceMemory = prunedSequences;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FULL PREDICTION CYCLE                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Run complete prediction cycle: evaluate, learn, predict next
  public func predictionCycle(
    buffer: PredictionBuffer,
    currentState: SDR,
    currentBeat: Nat
  ) : (PredictionBuffer, PredictionResult) {
    // 1. Evaluate previous prediction
    let result = evaluatePrediction(buffer, currentState, currentBeat);
    
    // 2. Get previous state from context
    let previousState = if (buffer.contextWindow.size() > 0) {
      buffer.contextWindow[0]
    } else {
      { activeBits = []; dimensions = SDR_SIZE }
    };
    
    // 3. Learn from this transition (only if surprised)
    let learnedBuffer = if (result.isSurprise) {
      learnSequence(buffer, previousState, currentState, currentBeat)
    } else {
      // Update context without learning
      let newContext = Buffer.Buffer<SDR>(CONTEXT_WINDOW);
      newContext.add(currentState);
      var i = 0;
      while (i < buffer.contextWindow.size() and newContext.size() < CONTEXT_WINDOW) {
        newContext.add(buffer.contextWindow[i]);
        i += 1;
      };
      
      {
        entityId = buffer.entityId;
        predictedNextState = buffer.predictedNextState;
        predictionConfidence = buffer.predictionConfidence;
        predictionBeat = buffer.predictionBeat;
        actualNextState = currentState;
        actualBeat = currentBeat;
        recentErrors = buffer.recentErrors;
        averageError = buffer.averageError;
        surpriseCount = buffer.surpriseCount;
        noveltyCount = buffer.noveltyCount;
        correctPredictions = buffer.correctPredictions + 1;  // Correct prediction!
        totalPredictions = buffer.totalPredictions + 1;
        contextWindow = Buffer.toArray(newContext);
        sequenceMemory = buffer.sequenceMemory;
      }
    };
    
    // 4. Make prediction for next beat
    let (nextPrediction, nextConfidence) = makePrediction(learnedBuffer, currentState, currentBeat);
    
    // 5. Update counters
    let finalBuffer : PredictionBuffer = {
      entityId = learnedBuffer.entityId;
      predictedNextState = nextPrediction;
      predictionConfidence = nextConfidence;
      predictionBeat = currentBeat;
      actualNextState = learnedBuffer.actualNextState;
      actualBeat = learnedBuffer.actualBeat;
      recentErrors = learnedBuffer.recentErrors;
      averageError = learnedBuffer.averageError;
      surpriseCount = if (result.isSurprise) { learnedBuffer.surpriseCount + 1 } else { learnedBuffer.surpriseCount };
      noveltyCount = if (result.isNovelEvent) { learnedBuffer.noveltyCount + 1 } else { learnedBuffer.noveltyCount };
      correctPredictions = learnedBuffer.correctPredictions;
      totalPredictions = learnedBuffer.totalPredictions;
      contextWindow = learnedBuffer.contextWindow;
      sequenceMemory = learnedBuffer.sequenceMemory;
    };
    
    (finalBuffer, result)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PREDICTION QUALITY METRICS                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Calculate prediction accuracy
  public func predictionAccuracy(buffer: PredictionBuffer) : Float {
    if (buffer.totalPredictions == 0) { return 0.5 };
    Float.fromInt(buffer.correctPredictions) / Float.fromInt(buffer.totalPredictions)
  };
  
  /// Calculate learning efficiency (correct predictions per surprise)
  public func learningEfficiency(buffer: PredictionBuffer) : Float {
    if (buffer.surpriseCount == 0) { return 0.0 };
    Float.fromInt(buffer.correctPredictions) / Float.fromInt(buffer.surpriseCount)
  };
  
  /// Calculate sequence coverage (how much of observed patterns are predicted)
  public func sequenceCoverage(buffer: PredictionBuffer) : Float {
    let totalPatterns = buffer.totalPredictions;
    let coveredPatterns = buffer.sequenceMemory.size();
    
    if (totalPatterns == 0) { return 0.0 };
    Float.min(1.0, Float.fromInt(coveredPatterns) / Float.fromInt(totalPatterns) * 10.0)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initPredictionBuffer(entityId: Nat) : PredictionBuffer {
    {
      entityId = entityId;
      predictedNextState = { activeBits = []; dimensions = SDR_SIZE };
      predictionConfidence = 0.0;
      predictionBeat = 0;
      actualNextState = { activeBits = []; dimensions = SDR_SIZE };
      actualBeat = 0;
      recentErrors = [];
      averageError = 0.0;
      surpriseCount = 0;
      noveltyCount = 0;
      correctPredictions = 0;
      totalPredictions = 0;
      contextWindow = [];
      sequenceMemory = [];
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUMMARY                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type PredictionSummary = {
    accuracy : Float;
    efficiency : Float;
    coverage : Float;
    surpriseRate : Float;
    sequencesLearned : Nat;
  };
  
  public func summarize(buffer: PredictionBuffer) : PredictionSummary {
    let surpriseRate = if (buffer.totalPredictions > 0) {
      Float.fromInt(buffer.surpriseCount) / Float.fromInt(buffer.totalPredictions)
    } else { 0.0 };
    
    {
      accuracy = predictionAccuracy(buffer);
      efficiency = learningEfficiency(buffer);
      coverage = sequenceCoverage(buffer);
      surpriseRate = surpriseRate;
      sequencesLearned = buffer.sequenceMemory.size();
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
