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
// NEUROEMERGENCE CORE — HIPPOCAMPAL REPLAY ENGINE
// Memory consolidation through sleep replay and sharp-wave ripples
// 
// Biological basis:
// - Sharp-wave ripples (SWR): 80-120 Hz bursts during sleep/rest
// - Replay: Sequential reactivation of experiences
// - Consolidation: Hippocampus → Neocortex transfer
// - Preplay: Forward simulation of future paths
// 
// Mathematical Framework:
// - Sequence compression: τ_replay ≈ τ_experience / 20
// - Reactivation probability: P(replay) ∝ reward × recency × importance
// - Synaptic consolidation: w_neocortex ← w_neocortex + α·w_hippocampus
// - Interference prevention: sleep spindles gate learning windows
// 
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════════

  // A single memory trace (episode)
  public type MemoryTrace = {
    id            : Nat;
    sequence      : [Float];      // State sequence
    reward        : Float;        // Total reward of episode
    emotionalTag  : Float;        // Emotional salience [0, 1]
    timestamp     : Nat;          // Beat when encoded
    replayCount   : Nat;          // Times replayed
    consolidation : Float;        // Transfer to neocortex [0, 1]
    importance    : Float;        // Computed importance score
    duration      : Nat;          // Original experience length
  };

  // Place cell representation
  public type PlaceCell = {
    location     : [Float];       // Spatial coordinates
    firingRate   : Float;         // Current firing rate
    fieldSize    : Float;         // Receptive field size
    phase        : Float;         // Theta phase coupling
  };

  // Sharp-wave ripple event
  public type SharpWaveRipple = {
    amplitude    : Float;         // SWR strength [0, 1]
    frequency    : Float;         // Ripple frequency (~100 Hz)
    duration     : Nat;           // Duration in ms-equivalent
    replayedMemory: Nat;          // ID of memory being replayed
    direction    : Bool;          // Forward (true) or reverse (false)
    compressionRatio: Float;      // Time compression factor
  };

  // Sleep spindle (thalamocortical)
  public type SleepSpindle = {
    amplitude    : Float;         // Spindle strength
    frequency    : Float;         // ~12-15 Hz
    duration     : Nat;
    phase        : Float;         // Current phase
    coupledToSWR : Bool;          // Synchronized with ripple?
  };

  // Theta oscillation state
  public type ThetaState = {
    phase        : Float;         // Current theta phase [0, 2π]
    frequency    : Float;         // ~6-10 Hz
    amplitude    : Float;         // Theta power
    phasePrecession: Float;       // Place cell phase shift
  };

  // Consolidation transfer packet
  public type ConsolidationPacket = {
    sourceMemory : Nat;           // Memory ID
    targetWeight : Float;         // Neocortical weight change
    strength     : Float;         // Transfer strength
    timestamp    : Nat;
  };

  // Sleep stage
  public type SleepStage = {
    #Wake;
    #NREM1;
    #NREM2;
    #NREM3;        // Deep sleep (most SWR)
    #REM;          // Dream sleep (different replay)
  };

  // Full hippocampal state
  public type HippocampalState = {
    // Memory store
    memories        : [MemoryTrace];
    maxMemories     : Nat;
    
    // Place cells
    placeCells      : [PlaceCell];
    currentLocation : [Float];
    
    // Oscillations
    theta           : ThetaState;
    swrBuffer       : [SharpWaveRipple];
    spindleBuffer   : [SleepSpindle];
    
    // Sleep state
    sleepStage      : SleepStage;
    sleepDepth      : Float;
    
    // Replay tracking
    currentReplay   : ?Nat;        // Currently replaying memory ID
    replayPosition  : Nat;         // Position in sequence
    replayDirection : Bool;        // Forward or backward
    
    // Consolidation
    consolidationQueue : [ConsolidationPacket];
    totalConsolidated  : Float;
    
    // Temporal
    beatNum         : Nat;
    lastWake        : Nat;
    sleepCycles     : Nat;
    
    // Learning rates
    encodingStrength : Float;
    replayLR         : Float;
    consolidationRate: Float;
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;
  let EPSILON : Float = 1e-10;
  
  // Default parameters
  let DEFAULT_MAX_MEMORIES : Nat = 1000;
  let DEFAULT_THETA_FREQ : Float = 8.0;       // Hz
  let DEFAULT_SWR_FREQ : Float = 100.0;       // Hz
  let DEFAULT_SPINDLE_FREQ : Float = 13.0;    // Hz
  let COMPRESSION_RATIO : Float = 20.0;       // 20x time compression
  let ENCODING_STRENGTH : Float = 0.8;
  let REPLAY_LR : Float = 0.1;
  let CONSOLIDATION_RATE : Float = 0.05;

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func wrapPhase(phase: Float) : Float {
    var p = phase;
    while (p < 0.0) { p += TWO_PI };
    while (p >= TWO_PI) { p -= TWO_PI };
    p
  };

  // ══════════════════════════════════════════════════════════════
  // MEMORY ENCODING
  // ══════════════════════════════════════════════════════════════

  // Compute memory importance for replay prioritization
  // Importance = f(reward, recency, emotional_tag, novelty)
  public func computeImportance(
    trace: MemoryTrace, currentBeat: Nat, avgReward: Float
  ) : Float {
    // Recency: exponential decay
    let age = Float.fromInt(currentBeat - trace.timestamp);
    let recencyFactor = Float.exp(-age / 1000.0);
    
    // Reward surprise: deviation from average
    let rewardSurprise = _abs(trace.reward - avgReward) / (_abs(avgReward) + 0.1);
    
    // Replay boost: frequently replayed memories are important
    let replayBoost = Float.fromInt(trace.replayCount) / 10.0;
    
    // Emotional salience
    let emotionalFactor = trace.emotionalTag;
    
    // Combine factors
    let importance = 
      0.3 * _clamp(rewardSurprise, 0.0, 1.0) +
      0.25 * recencyFactor +
      0.25 * emotionalFactor +
      0.1 * _clamp(replayBoost, 0.0, 1.0) +
      0.1 * (1.0 - trace.consolidation);  // Prioritize unconsolidated
    
    _clamp(importance, 0.0, 1.0)
  };

  // Encode new experience as memory trace
  public func encodeMemory(
    sequence: [Float],
    reward: Float,
    emotionalTag: Float,
    currentBeat: Nat,
    nextId: Nat
  ) : MemoryTrace {
    {
      id = nextId;
      sequence = sequence;
      reward = reward;
      emotionalTag = emotionalTag;
      timestamp = currentBeat;
      replayCount = 0;
      consolidation = 0.0;
      importance = 0.5;  // Initial estimate
      duration = sequence.size();
    }
  };

  // Update memory after replay
  public func updateAfterReplay(trace: MemoryTrace, consolidationGain: Float) : MemoryTrace {
    {
      id = trace.id;
      sequence = trace.sequence;
      reward = trace.reward;
      emotionalTag = trace.emotionalTag;
      timestamp = trace.timestamp;
      replayCount = trace.replayCount + 1;
      consolidation = _clamp(trace.consolidation + consolidationGain, 0.0, 1.0);
      importance = trace.importance;
      duration = trace.duration;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // REPLAY SELECTION
  // ══════════════════════════════════════════════════════════════

  // Select memory for replay based on importance sampling
  public func selectMemoryForReplay(
    memories: [MemoryTrace], 
    currentBeat: Nat,
    avgReward: Float
  ) : ?Nat {
    if (memories.size() == 0) { return null };
    
    // Compute importance for all memories
    var totalImportance : Float = 0.0;
    let importances = Array.tabulate<Float>(memories.size(), func(i) {
      let imp = computeImportance(memories[i], currentBeat, avgReward);
      totalImportance += imp;
      imp
    });
    
    if (totalImportance < EPSILON) { return ?0 };
    
    // Deterministic selection based on beat (pseudo-random)
    let selector = Float.fromInt(currentBeat * 37 % 1000) / 1000.0 * totalImportance;
    
    var cumulative : Float = 0.0;
    var selected : Nat = 0;
    for (i in importances.keys()) {
      cumulative += importances[i];
      if (cumulative >= selector) {
        selected := i;
        return ?selected;
      };
    };
    
    ?selected
  };

  // ══════════════════════════════════════════════════════════════
  // SHARP-WAVE RIPPLE GENERATION
  // ══════════════════════════════════════════════════════════════

  // Determine if SWR should occur
  // SWRs happen during NREM3 and quiet wake
  public func shouldGenerateSWR(state: HippocampalState) : Bool {
    switch (state.sleepStage) {
      case (#NREM3) { state.sleepDepth > 0.6 };
      case (#NREM2) { state.sleepDepth > 0.8 };
      case (#Wake) { 
        // Quiet wake: occasional SWRs
        Float.fromInt(state.beatNum % 50) < 5.0
      };
      case (_) { false };
    }
  };

  // Generate sharp-wave ripple event
  public func generateSWR(
    memoryId: Nat,
    forward: Bool,
    sleepDepth: Float
  ) : SharpWaveRipple {
    {
      amplitude = 0.5 + sleepDepth * 0.5;
      frequency = DEFAULT_SWR_FREQ;
      duration = 100;  // ~100ms
      replayedMemory = memoryId;
      direction = forward;
      compressionRatio = COMPRESSION_RATIO;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SLEEP SPINDLE GENERATION
  // ══════════════════════════════════════════════════════════════

  // Spindles gate consolidation during NREM2
  public func shouldGenerateSpindle(state: HippocampalState) : Bool {
    switch (state.sleepStage) {
      case (#NREM2) { true };
      case (#NREM3) { state.sleepDepth > 0.5 };
      case (_) { false };
    }
  };

  public func generateSpindle(swrPresent: Bool, phase: Float) : SleepSpindle {
    {
      amplitude = 0.6;
      frequency = DEFAULT_SPINDLE_FREQ;
      duration = 500;  // ~500ms
      phase = phase;
      coupledToSWR = swrPresent;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THETA OSCILLATION
  // ══════════════════════════════════════════════════════════════

  // Update theta phase (during wake and REM)
  public func updateTheta(theta: ThetaState, dt: Float) : ThetaState {
    let newPhase = wrapPhase(theta.phase + TWO_PI * theta.frequency * dt);
    {
      phase = newPhase;
      frequency = theta.frequency;
      amplitude = theta.amplitude;
      phasePrecession = theta.phasePrecession;
    }
  };

  // Theta-gamma coupling: memory encoding window
  public func isThetaTrough(theta: ThetaState) : Bool {
    // Trough is optimal for encoding
    theta.phase > PI * 0.8 and theta.phase < PI * 1.2
  };

  // ══════════════════════════════════════════════════════════════
  // CONSOLIDATION
  // ══════════════════════════════════════════════════════════════

  // Generate consolidation packet for neocortex
  public func createConsolidationPacket(
    memory: MemoryTrace,
    spindleCoupled: Bool,
    currentBeat: Nat
  ) : ConsolidationPacket {
    let baseStrength = memory.importance * (1.0 - memory.consolidation);
    let strength = if (spindleCoupled) {
      baseStrength * 1.5  // Spindle-coupled consolidation is stronger
    } else {
      baseStrength
    };
    
    {
      sourceMemory = memory.id;
      targetWeight = _clamp(strength * 0.1, 0.0, 0.2);
      strength = _clamp(strength, 0.0, 1.0);
      timestamp = currentBeat;
    }
  };

  // Process consolidation queue
  public func processConsolidation(
    packets: [ConsolidationPacket]
  ) : Float {
    var total : Float = 0.0;
    for (p in packets.vals()) {
      total += p.targetWeight;
    };
    total
  };

  // ══════════════════════════════════════════════════════════════
  // SLEEP STAGE TRANSITIONS
  // ══════════════════════════════════════════════════════════════

  // Update sleep stage based on time and depth
  public func updateSleepStage(
    current: SleepStage, 
    depth: Float, 
    beatsSinceSleep: Nat
  ) : SleepStage {
    let cyclePhase = Float.fromInt(beatsSinceSleep % 90) / 90.0;  // ~90 min cycles
    
    if (depth < 0.1) { return #Wake };
    
    if (cyclePhase < 0.1) {
      #NREM1
    } else if (cyclePhase < 0.3) {
      #NREM2
    } else if (cyclePhase < 0.6) {
      #NREM3  // Deep sleep
    } else if (cyclePhase < 0.8) {
      #NREM2
    } else {
      #REM  // Dream sleep
    }
  };

  // ══════════════════════════════════════════════════════════════
  // PLACE CELL DYNAMICS
  // ══════════════════════════════════════════════════════════════

  // Update place cell firing based on location
  public func updatePlaceCell(
    cell: PlaceCell, 
    currentLoc: [Float]
  ) : PlaceCell {
    // Compute distance to place field center
    var distSq : Float = 0.0;
    let minDim = Nat.min(cell.location.size(), currentLoc.size());
    var i : Nat = 0;
    while (i < minDim) {
      let d = cell.location[i] - currentLoc[i];
      distSq += d * d;
      i += 1;
    };
    
    // Gaussian firing rate based on distance
    let firingRate = Float.exp(-distSq / (2.0 * cell.fieldSize * cell.fieldSize));
    
    {
      location = cell.location;
      firingRate = _clamp(firingRate, 0.0, 1.0);
      fieldSize = cell.fieldSize;
      phase = cell.phase;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // PREPLAY (Forward simulation)
  // ══════════════════════════════════════════════════════════════

  // Generate preplay sequence for planning
  public func generatePreplay(
    memories: [MemoryTrace],
    currentContext: [Float],
    targetContext: [Float]
  ) : [Float] {
    // Find memories with similar starting points
    // Generate predicted path to target
    // Simplified: interpolate between current and target
    
    let steps = 10;
    let minDim = Nat.min(currentContext.size(), targetContext.size());
    
    var sequence = Buffer.Buffer<Float>(steps);
    var i : Nat = 0;
    while (i < steps) {
      let t = Float.fromInt(i) / Float.fromInt(steps - 1);
      var j : Nat = 0;
      while (j < minDim) {
        let val = currentContext[j] * (1.0 - t) + targetContext[j] * t;
        sequence.add(val);
        j += 1;
      };
      i += 1;
    };
    
    Buffer.toArray(sequence)
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type HippocampalInput = {
    currentState    : [Float];     // Current state/location
    reward          : Float;       // Reward received
    emotionalSignal : Float;       // Emotional salience
    sleepDepth      : Float;       // Sleep depth [0, 1]
    isEncoding      : Bool;        // Should encode new memory?
  };

  public func beatHippocampus(
    state: HippocampalState,
    input: HippocampalInput
  ) : HippocampalState {
    
    // 1. Update sleep stage
    let beatsSinceSleep = if (input.sleepDepth > 0.1) {
      state.beatNum - state.lastWake
    } else { 0 };
    
    let newSleepStage = updateSleepStage(
      state.sleepStage, 
      input.sleepDepth, 
      beatsSinceSleep
    );
    
    let newLastWake = if (input.sleepDepth < 0.1) { state.beatNum } else { state.lastWake };
    
    // 2. Update theta (active during wake/REM)
    let newTheta = switch (newSleepStage) {
      case (#Wake) { updateTheta(state.theta, 0.001) };
      case (#REM) { updateTheta(state.theta, 0.001) };
      case (_) { state.theta };
    };
    
    // 3. Encode new memory if appropriate
    var newMemories = state.memories;
    if (input.isEncoding and input.currentState.size() > 0) {
      let thetaOptimal = isThetaTrough(newTheta) or input.sleepDepth < 0.1;
      if (thetaOptimal) {
        let newTrace = encodeMemory(
          input.currentState,
          input.reward,
          input.emotionalSignal,
          state.beatNum,
          state.memories.size()
        );
        newMemories := Array.append<MemoryTrace>(state.memories, [newTrace]);
        
        // Trim if over capacity
        if (newMemories.size() > state.maxMemories) {
          // Remove oldest, least important memories
          newMemories := Array.tabulate<MemoryTrace>(
            state.maxMemories,
            func(i) { newMemories[newMemories.size() - state.maxMemories + i] }
          );
        };
      };
    };
    
    // 4. Compute average reward for importance calculation
    var avgReward : Float = 0.0;
    for (m in newMemories.vals()) {
      avgReward += m.reward;
    };
    avgReward := if (newMemories.size() > 0) {
      avgReward / Float.fromInt(newMemories.size())
    } else { 0.0 };
    
    // 5. Update memory importance scores
    newMemories := Array.tabulate<MemoryTrace>(newMemories.size(), func(i) {
      let m = newMemories[i];
      {
        id = m.id;
        sequence = m.sequence;
        reward = m.reward;
        emotionalTag = m.emotionalTag;
        timestamp = m.timestamp;
        replayCount = m.replayCount;
        consolidation = m.consolidation;
        importance = computeImportance(m, state.beatNum, avgReward);
        duration = m.duration;
      }
    });
    
    // 6. Generate SWR and replay
    var newSWRBuffer = state.swrBuffer;
    var newCurrentReplay = state.currentReplay;
    var newReplayPos = state.replayPosition;
    var newReplayDir = state.replayDirection;
    var consolidationPackets : [ConsolidationPacket] = [];
    
    if (shouldGenerateSWR(state) and newMemories.size() > 0) {
      switch (selectMemoryForReplay(newMemories, state.beatNum, avgReward)) {
        case (?memId) {
          // Generate SWR
          let forward = state.beatNum % 2 == 0;  // Alternate directions
          let swr = generateSWR(memId, forward, input.sleepDepth);
          newSWRBuffer := Array.append<SharpWaveRipple>(state.swrBuffer, [swr]);
          
          // Start replay
          newCurrentReplay := ?memId;
          newReplayPos := 0;
          newReplayDir := forward;
          
          // Update replayed memory
          if (memId < newMemories.size()) {
            let replayedMem = updateAfterReplay(
              newMemories[memId],
              state.consolidationRate
            );
            
            // Generate consolidation packet
            let spindleCoupled = shouldGenerateSpindle(state);
            let packet = createConsolidationPacket(
              replayedMem,
              spindleCoupled,
              state.beatNum
            );
            consolidationPackets := [packet];
            
            newMemories := Array.tabulate<MemoryTrace>(newMemories.size(), func(i) {
              if (i == memId) { replayedMem } else { newMemories[i] }
            });
          };
        };
        case (null) {};
      };
    };
    
    // 7. Generate spindles
    var newSpindleBuffer = state.spindleBuffer;
    if (shouldGenerateSpindle(state)) {
      let swrPresent = newSWRBuffer.size() > 0;
      let spindle = generateSpindle(swrPresent, newTheta.phase);
      newSpindleBuffer := Array.append<SleepSpindle>(state.spindleBuffer, [spindle]);
    };
    
    // 8. Process consolidation
    let consolidationGain = processConsolidation(consolidationPackets);
    let newConsolidationQueue = Array.append<ConsolidationPacket>(
      state.consolidationQueue, 
      consolidationPackets
    );
    
    // 9. Update place cells
    let newPlaceCells = Array.map<PlaceCell, PlaceCell>(
      state.placeCells,
      func(cell) { updatePlaceCell(cell, input.currentState) }
    );
    
    // 10. Track sleep cycles
    let newSleepCycles = switch (state.sleepStage, newSleepStage) {
      case (#REM, #NREM1) { state.sleepCycles + 1 };  // Completed cycle
      case (_, _) { state.sleepCycles };
    };
    
    // Trim buffers
    let maxBuffer = 20;
    let trimmedSWR = if (newSWRBuffer.size() > maxBuffer) {
      Array.tabulate<SharpWaveRipple>(maxBuffer, func(i) { 
        newSWRBuffer[newSWRBuffer.size() - maxBuffer + i] 
      })
    } else { newSWRBuffer };
    
    let trimmedSpindle = if (newSpindleBuffer.size() > maxBuffer) {
      Array.tabulate<SleepSpindle>(maxBuffer, func(i) { 
        newSpindleBuffer[newSpindleBuffer.size() - maxBuffer + i] 
      })
    } else { newSpindleBuffer };
    
    {
      memories = newMemories;
      maxMemories = state.maxMemories;
      placeCells = newPlaceCells;
      currentLocation = input.currentState;
      theta = newTheta;
      swrBuffer = trimmedSWR;
      spindleBuffer = trimmedSpindle;
      sleepStage = newSleepStage;
      sleepDepth = input.sleepDepth;
      currentReplay = newCurrentReplay;
      replayPosition = newReplayPos;
      replayDirection = newReplayDir;
      consolidationQueue = newConsolidationQueue;
      totalConsolidated = state.totalConsolidated + consolidationGain;
      beatNum = state.beatNum + 1;
      lastWake = newLastWake;
      sleepCycles = newSleepCycles;
      encodingStrength = state.encodingStrength;
      replayLR = state.replayLR;
      consolidationRate = state.consolidationRate;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ══════════════════════════════════════════════════════════════

  // Get most important memories for review
  public func getTopMemories(state: HippocampalState, n: Nat) : [MemoryTrace] {
    // Sort by importance (simplified: just take first n after sorting)
    var sorted = Array.sort<MemoryTrace>(
      state.memories,
      func(a, b) {
        if (a.importance > b.importance) { #less }
        else if (a.importance < b.importance) { #greater }
        else { #equal }
      }
    );
    
    let count = Nat.min(n, sorted.size());
    Array.tabulate<MemoryTrace>(count, func(i) { sorted[i] })
  };

  // Get recently encoded memories
  public func getRecentMemories(state: HippocampalState, windowBeats: Nat) : [MemoryTrace] {
    let threshold = if (state.beatNum > windowBeats) { state.beatNum - windowBeats } else { 0 };
    Array.filter<MemoryTrace>(state.memories, func(m) { m.timestamp >= threshold })
  };

  // Get unconsolidated memories (need more sleep)
  public func getUnconsolidated(state: HippocampalState, threshold: Float) : [MemoryTrace] {
    Array.filter<MemoryTrace>(state.memories, func(m) { m.consolidation < threshold })
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initHippocampus(nPlaceCells: Nat) : HippocampalState {
    let placeCells = Array.tabulate<PlaceCell>(nPlaceCells, func(i) {
      {
        location = [Float.fromInt(i) / Float.fromInt(nPlaceCells)];
        firingRate = 0.0;
        fieldSize = 0.2;
        phase = 0.0;
      }
    });
    
    {
      memories = [];
      maxMemories = DEFAULT_MAX_MEMORIES;
      placeCells = placeCells;
      currentLocation = [0.5];
      theta = {
        phase = 0.0;
        frequency = DEFAULT_THETA_FREQ;
        amplitude = 0.5;
        phasePrecession = 0.0;
      };
      swrBuffer = [];
      spindleBuffer = [];
      sleepStage = #Wake;
      sleepDepth = 0.0;
      currentReplay = null;
      replayPosition = 0;
      replayDirection = true;
      consolidationQueue = [];
      totalConsolidated = 0.0;
      beatNum = 0;
      lastWake = 0;
      sleepCycles = 0;
      encodingStrength = ENCODING_STRENGTH;
      replayLR = REPLAY_LR;
      consolidationRate = CONSOLIDATION_RATE;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type HippocampalSummary = {
    memoryCount       : Nat;
    avgConsolidation  : Float;
    sleepStage        : Text;
    sleepCycles       : Nat;
    recentSWRs        : Nat;
    recentSpindles    : Nat;
    thetaPhase        : Float;
    totalConsolidated : Float;
    topMemoryReward   : Float;
  };

  public func summary(state: HippocampalState) : HippocampalSummary {
    var avgCons : Float = 0.0;
    var topReward : Float = -10.0;
    for (m in state.memories.vals()) {
      avgCons += m.consolidation;
      if (m.reward > topReward) { topReward := m.reward };
    };
    avgCons := if (state.memories.size() > 0) {
      avgCons / Float.fromInt(state.memories.size())
    } else { 0.0 };
    
    let stageName = switch (state.sleepStage) {
      case (#Wake) { "Wake" };
      case (#NREM1) { "NREM1" };
      case (#NREM2) { "NREM2" };
      case (#NREM3) { "NREM3" };
      case (#REM) { "REM" };
    };
    
    {
      memoryCount = state.memories.size();
      avgConsolidation = avgCons;
      sleepStage = stageName;
      sleepCycles = state.sleepCycles;
      recentSWRs = state.swrBuffer.size();
      recentSpindles = state.spindleBuffer.size();
      thetaPhase = state.theta.phase;
      totalConsolidated = state.totalConsolidated;
      topMemoryReward = topReward;
    }
  };

}
