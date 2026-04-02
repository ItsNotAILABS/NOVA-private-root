// ============================================================
// NEUROEMERGENCE CORE — CEREBELLAR TIMING ENGINE
// Precise timing, motor learning, and internal models
// 
// Biological basis:
// - Purkinje cells: Main computational units (inhibitory output)
// - Granule cells: Massive expansion layer (pattern separation)
// - Climbing fibers: Error signals from inferior olive
// - Mossy fibers: Sensory/motor input
// - Deep cerebellar nuclei: Output to motor systems
// 
// Mathematical Framework:
// - Delay adaptation: Δw ∝ e(t) · x(t - τ)
// - Forward model: ŝ(t+1) = f(s(t), a(t))
// - Timing error: ε_t = |t_actual - t_predicted|
// - LTD rule: w ← w - η · CF · PF  (climbing fiber × parallel fiber)
// 
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ══════════════════════════════════════════════════════════════
  // TYPES
  // ══════════════════════════════════════════════════════════════

  // Purkinje cell - main computational unit
  public type PurkinjeCell = {
    id            : Nat;
    activity      : Float;         // Current firing rate [0, 1]
    parallelWeights: [Float];      // Weights from granule cells
    climbingInput : Float;         // Error signal from olive
    simpleSpike   : Float;         // Regular spiking
    complexSpike  : Float;         // Climbing fiber-driven burst
    pauseDuration : Nat;           // Post-complex-spike pause
  };

  // Granule cell - pattern expansion
  public type GranuleCell = {
    activity      : Float;         // Current activity [0, 1]
    mossyWeights  : [Float];       // Weights from mossy fibers
    threshold     : Float;         // Activation threshold
  };

  // Deep cerebellar nucleus neuron
  public type DCNNeuron = {
    activity      : Float;         // Output activity
    purkinjeInput : Float;         // Inhibitory input from Purkinje
    mossyInput    : Float;         // Excitatory input from mossy
    rebound       : Float;         // Post-inhibitory rebound
  };

  // Timing memory - learned interval
  public type TimingMemory = {
    conditionedStimulus : Nat;     // CS identifier
    interval            : Nat;     // Target interval (beats)
    learnedDelay        : Float;   // Learned delay (beats, can be fractional)
    accuracy            : Float;   // Timing precision [0, 1]
    trialCount          : Nat;     // Training trials
    lastError           : Float;   // Most recent timing error
  };

  // Forward model prediction
  public type ForwardModel = {
    stateEstimate     : [Float];   // Predicted next state
    motorCommand      : [Float];   // Current motor command
    sensoryPrediction : [Float];   // Predicted sensory feedback
    error             : Float;     // Prediction error
    confidence        : Float;     // Model confidence
  };

  // Motor primitive - basic movement unit
  public type MotorPrimitive = {
    id            : Nat;
    pattern       : [Float];       // Temporal pattern
    duration      : Nat;           // Primitive duration
    amplitude     : Float;         // Movement amplitude
    velocity      : Float;         // Movement velocity
    trained       : Bool;          // Is this primitive trained?
  };

  // Full cerebellar state
  public type CerebellarState = {
    // Neural populations
    purkinjeCells : [PurkinjeCell];
    granuleCells  : [GranuleCell];
    dcnNeurons    : [DCNNeuron];
    
    // Input/Output
    mossyFiberInput   : [Float];   // Current sensory/motor input
    climbingFiberError: Float;     // Global error signal
    cerebellarOutput  : [Float];   // Output to motor systems
    
    // Timing
    timingMemories    : [TimingMemory];
    currentInterval   : Nat;       // Current interval being timed
    intervalPhase     : Float;     // Phase within interval [0, 1]
    
    // Forward models
    forwardModels     : [ForwardModel];
    activeModel       : Nat;       // Currently active model
    
    // Motor primitives
    motorPrimitives   : [MotorPrimitive];
    activePrimitive   : ?Nat;
    primitiveProgress : Float;     // Progress through primitive [0, 1]
    
    // Learning parameters
    ltdRate           : Float;     // Long-term depression rate
    ltpRate           : Float;     // Long-term potentiation rate
    timingLR          : Float;     // Timing learning rate
    
    // Error tracking
    cumulativeError   : Float;
    adaptationRate    : Float;
    
    // Temporal
    beatNum           : Nat;
    lastClimbingSpike : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let EPSILON : Float = 1e-10;
  let PI : Float = 3.14159265358979;
  
  // Network sizes
  let N_PURKINJE : Nat = 10;
  let N_GRANULE : Nat = 100;      // Massive expansion (10:1 ratio typical)
  let N_DCN : Nat = 5;
  
  // Learning rates
  let DEFAULT_LTD_RATE : Float = 0.01;
  let DEFAULT_LTP_RATE : Float = 0.002;   // LTP is weaker than LTD
  let DEFAULT_TIMING_LR : Float = 0.05;
  
  // Timing
  let MIN_INTERVAL : Nat = 10;
  let MAX_INTERVAL : Nat = 1000;

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func _sigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-x))
  };

  func _relu(x: Float) : Float {
    if (x > 0.0) { x } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════
  // GRANULE CELL LAYER (Pattern Expansion)
  // ══════════════════════════════════════════════════════════════

  // Granule cells create sparse, decorrelated representations
  public func updateGranuleCell(
    cell: GranuleCell,
    mossyInput: [Float]
  ) : GranuleCell {
    // Weighted sum of mossy fiber inputs
    var activation : Float = 0.0;
    let nWeights = Nat.min(cell.mossyWeights.size(), mossyInput.size());
    var i : Nat = 0;
    while (i < nWeights) {
      activation += cell.mossyWeights[i] * mossyInput[i];
      i += 1;
    };
    
    // Sparse activation (high threshold)
    let newActivity = if (activation > cell.threshold) {
      _clamp(activation - cell.threshold, 0.0, 1.0)
    } else { 0.0 };
    
    {
      activity = newActivity;
      mossyWeights = cell.mossyWeights;
      threshold = cell.threshold;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // PURKINJE CELL DYNAMICS
  // ══════════════════════════════════════════════════════════════

  // Purkinje cells integrate parallel fiber input and modulate by climbing fiber
  public func updatePurkinjeCell(
    cell: PurkinjeCell,
    granuleActivities: [Float],
    climbingError: Float
  ) : PurkinjeCell {
    // Simple spike: weighted sum of parallel fibers
    var parallelSum : Float = 0.0;
    let nWeights = Nat.min(cell.parallelWeights.size(), granuleActivities.size());
    var i : Nat = 0;
    while (i < nWeights) {
      parallelSum += cell.parallelWeights[i] * granuleActivities[i];
      i += 1;
    };
    
    let newSimpleSpike = _sigmoid(parallelSum * 3.0 - 1.5);
    
    // Complex spike: driven by climbing fiber error
    let newComplexSpike = if (_abs(climbingError) > 0.3) {
      _abs(climbingError)
    } else { 0.0 };
    
    // Pause after complex spike
    let newPause = if (newComplexSpike > 0.5) { 5 } else {
      if (cell.pauseDuration > 0) { cell.pauseDuration - 1 } else { 0 }
    };
    
    // Activity is simple spike unless paused
    let activity = if (newPause > 0) { 0.1 } else { newSimpleSpike };
    
    {
      id = cell.id;
      activity = activity;
      parallelWeights = cell.parallelWeights;
      climbingInput = climbingError;
      simpleSpike = newSimpleSpike;
      complexSpike = newComplexSpike;
      pauseDuration = newPause;
    }
  };

  // LTD at parallel fiber-Purkinje synapse
  // When climbing fiber fires (error), weaken active parallel fiber synapses
  public func applyLTD(
    cell: PurkinjeCell,
    granuleActivities: [Float],
    ltdRate: Float
  ) : PurkinjeCell {
    if (cell.complexSpike < 0.3) { return cell };  // No LTD without error
    
    let newWeights = Array.tabulate<Float>(cell.parallelWeights.size(), func(i) {
      let activity = if (i < granuleActivities.size()) { granuleActivities[i] } else { 0.0 };
      // LTD: reduce weight proportional to granule activity and error
      let delta = -ltdRate * activity * cell.complexSpike;
      _clamp(cell.parallelWeights[i] + delta, 0.0, 2.0)
    });
    
    {
      id = cell.id;
      activity = cell.activity;
      parallelWeights = newWeights;
      climbingInput = cell.climbingInput;
      simpleSpike = cell.simpleSpike;
      complexSpike = cell.complexSpike;
      pauseDuration = cell.pauseDuration;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // DEEP CEREBELLAR NUCLEUS
  // ══════════════════════════════════════════════════════════════

  // DCN neurons: inhibited by Purkinje, excited by mossy fibers
  public func updateDCNNeuron(
    dcn: DCNNeuron,
    purkinjeInput: Float,
    mossyInput: Float
  ) : DCNNeuron {
    // Inhibitory-excitatory balance
    let netInput = mossyInput * 0.7 - purkinjeInput * 0.8;
    
    // Post-inhibitory rebound: when Purkinje pauses, DCN rebounds
    let rebound = if (dcn.purkinjeInput > 0.5 and purkinjeInput < 0.3) {
      0.5
    } else {
      dcn.rebound * 0.9
    };
    
    let activity = _clamp(_relu(netInput) + rebound, 0.0, 1.0);
    
    {
      activity = activity;
      purkinjeInput = purkinjeInput;
      mossyInput = mossyInput;
      rebound = rebound;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // TIMING MECHANISMS
  // ══════════════════════════════════════════════════════════════

  // Compute timing error
  public func computeTimingError(
    targetInterval: Nat,
    actualInterval: Nat
  ) : Float {
    let diff = Float.fromInt(Int.abs(actualInterval - targetInterval));
    let normalized = diff / Float.fromInt(targetInterval);
    _clamp(normalized, 0.0, 1.0)
  };

  // Update timing memory with new trial
  public func updateTimingMemory(
    memory: TimingMemory,
    actualInterval: Nat,
    learningRate: Float
  ) : TimingMemory {
    // Error
    let error = computeTimingError(memory.interval, actualInterval);
    
    // Update learned delay toward actual
    let correction = Float.fromInt(actualInterval) - memory.learnedDelay;
    let newDelay = memory.learnedDelay + learningRate * correction;
    
    // Update accuracy (exponential moving average)
    let newAccuracy = memory.accuracy * 0.9 + (1.0 - error) * 0.1;
    
    {
      conditionedStimulus = memory.conditionedStimulus;
      interval = memory.interval;
      learnedDelay = _clamp(newDelay, Float.fromInt(MIN_INTERVAL), Float.fromInt(MAX_INTERVAL));
      accuracy = newAccuracy;
      trialCount = memory.trialCount + 1;
      lastError = error;
    }
  };

  // Create timing response (conditioned response)
  // Response peaks near the learned interval
  public func generateTimingResponse(
    memory: TimingMemory,
    currentPhase: Float
  ) : Float {
    // Gaussian-like response centered at learned time
    let targetPhase = memory.learnedDelay / Float.fromInt(memory.interval);
    let width = 0.1 + (1.0 - memory.accuracy) * 0.2;  // Narrower with better accuracy
    let diff = currentPhase - targetPhase;
    Float.exp(-(diff * diff) / (2.0 * width * width))
  };

  // ══════════════════════════════════════════════════════════════
  // FORWARD MODEL
  // ══════════════════════════════════════════════════════════════

  // Forward model: predict next state from current state + action
  // ŝ(t+1) = f(s(t), a(t))
  public func updateForwardModel(
    model: ForwardModel,
    actualState: [Float],
    nextState: [Float],
    action: [Float],
    learningRate: Float
  ) : ForwardModel {
    // Compute prediction error
    var totalError : Float = 0.0;
    let nDims = Nat.min(model.sensoryPrediction.size(), nextState.size());
    var i : Nat = 0;
    while (i < nDims) {
      let err = nextState[i] - model.sensoryPrediction[i];
      totalError += err * err;
      i += 1;
    };
    let rmsError = Float.sqrt(totalError / Float.fromInt(Nat.max(nDims, 1)));
    
    // Update predictions (simple linear model)
    let newPrediction = Array.tabulate<Float>(actualState.size(), func(j) {
      let current = if (j < actualState.size()) { actualState[j] } else { 0.0 };
      let act = if (j < action.size()) { action[j] } else { 0.0 };
      _clamp(current + act * 0.1, 0.0, 1.0)  // Simple dynamics
    });
    
    // Update confidence based on error
    let newConfidence = model.confidence * 0.9 + (1.0 - _clamp(rmsError, 0.0, 1.0)) * 0.1;
    
    {
      stateEstimate = nextState;
      motorCommand = action;
      sensoryPrediction = newPrediction;
      error = rmsError;
      confidence = newConfidence;
    }
  };

  // Predict sensory consequence of action
  public func predictConsequence(
    state: [Float],
    action: [Float]
  ) : [Float] {
    Array.tabulate<Float>(state.size(), func(i) {
      let s = if (i < state.size()) { state[i] } else { 0.0 };
      let a = if (i < action.size()) { action[i] } else { 0.0 };
      _clamp(s + a * 0.1, 0.0, 1.0)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // MOTOR PRIMITIVE EXECUTION
  // ══════════════════════════════════════════════════════════════

  // Execute motor primitive at current progress
  public func executePrimitive(
    primitive: MotorPrimitive,
    progress: Float
  ) : [Float] {
    let idx = Int.abs(Float.toInt(progress * Float.fromInt(primitive.pattern.size() - 1)));
    let i = if (idx < primitive.pattern.size()) { idx } else { primitive.pattern.size() - 1 };
    
    // Interpolate between pattern points
    let t = progress * Float.fromInt(primitive.pattern.size() - 1) - Float.fromInt(i);
    let v1 = primitive.pattern[i];
    let v2 = if (i + 1 < primitive.pattern.size()) { primitive.pattern[i + 1] } else { v1 };
    
    let value = v1 * (1.0 - t) + v2 * t;
    [value * primitive.amplitude]
  };

  // Learn motor primitive from repeated execution
  public func refinePrimitive(
    primitive: MotorPrimitive,
    error: Float,
    learningRate: Float
  ) : MotorPrimitive {
    // Refine amplitude based on error
    let amplitudeCorrection = if (error > 0.0) { -error * learningRate } else { 0.0 };
    let newAmplitude = _clamp(primitive.amplitude + amplitudeCorrection, 0.1, 2.0);
    
    {
      id = primitive.id;
      pattern = primitive.pattern;
      duration = primitive.duration;
      amplitude = newAmplitude;
      velocity = primitive.velocity;
      trained = primitive.trialCount > 10;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type CerebellarInput = {
    mossyInput      : [Float];     // Sensory/motor input
    climbingError   : Float;       // Error signal from olive
    targetInterval  : Nat;         // Interval to time (0 if none)
    motorCommand    : [Float];     // Current motor command
    sensoryFeedback : [Float];     // Actual sensory feedback
  };

  public func beatCerebellum(
    state: CerebellarState,
    input: CerebellarInput
  ) : CerebellarState {
    
    // 1. Update granule cells
    let newGranules = Array.map<GranuleCell, GranuleCell>(
      state.granuleCells,
      func(cell) { updateGranuleCell(cell, input.mossyInput) }
    );
    
    // Collect granule activities
    let granuleActivities = Array.map<GranuleCell, Float>(
      newGranules,
      func(cell) { cell.activity }
    );
    
    // 2. Update Purkinje cells
    var newPurkinje = Array.map<PurkinjeCell, PurkinjeCell>(
      state.purkinjeCells,
      func(cell) { updatePurkinjeCell(cell, granuleActivities, input.climbingError) }
    );
    
    // Apply LTD if climbing fiber active
    if (_abs(input.climbingError) > 0.3) {
      newPurkinje := Array.map<PurkinjeCell, PurkinjeCell>(
        newPurkinje,
        func(cell) { applyLTD(cell, granuleActivities, state.ltdRate) }
      );
    };
    
    // 3. Update DCN neurons
    // Compute average Purkinje output
    var avgPurkinje : Float = 0.0;
    for (p in newPurkinje.vals()) {
      avgPurkinje += p.activity;
    };
    avgPurkinje /= Float.fromInt(Nat.max(newPurkinje.size(), 1));
    
    // Average mossy input
    var avgMossy : Float = 0.0;
    for (m in input.mossyInput.vals()) {
      avgMossy += m;
    };
    avgMossy /= Float.fromInt(Nat.max(input.mossyInput.size(), 1));
    
    let newDCN = Array.map<DCNNeuron, DCNNeuron>(
      state.dcnNeurons,
      func(dcn) { updateDCNNeuron(dcn, avgPurkinje, avgMossy) }
    );
    
    // 4. Generate cerebellar output
    let cerebellarOutput = Array.map<DCNNeuron, Float>(
      newDCN,
      func(dcn) { dcn.activity }
    );
    
    // 5. Update timing
    var newTimingMemories = state.timingMemories;
    var newInterval = state.currentInterval;
    var newPhase = state.intervalPhase;
    
    if (input.targetInterval > 0) {
      newInterval := input.targetInterval;
      newPhase := (newPhase + 1.0 / Float.fromInt(input.targetInterval));
      
      if (newPhase >= 1.0) {
        // Interval completed - update timing memory
        newPhase := 0.0;
        
        // Find or create timing memory
        var found = false;
        newTimingMemories := Array.map<TimingMemory, TimingMemory>(
          state.timingMemories,
          func(m) {
            if (m.interval == input.targetInterval) {
              found := true;
              updateTimingMemory(m, input.targetInterval, state.timingLR)
            } else { m }
          }
        );
        
        if (not found and newTimingMemories.size() < 20) {
          let newMemory : TimingMemory = {
            conditionedStimulus = input.targetInterval;
            interval = input.targetInterval;
            learnedDelay = Float.fromInt(input.targetInterval);
            accuracy = 0.5;
            trialCount = 1;
            lastError = 0.0;
          };
          newTimingMemories := Array.append(newTimingMemories, [newMemory]);
        };
      };
    };
    
    // 6. Update forward model
    var newForwardModels = state.forwardModels;
    if (state.forwardModels.size() > 0 and state.activeModel < state.forwardModels.size()) {
      let updatedModel = updateForwardModel(
        state.forwardModels[state.activeModel],
        input.mossyInput,
        input.sensoryFeedback,
        input.motorCommand,
        state.ltpRate
      );
      newForwardModels := Array.tabulate<ForwardModel>(state.forwardModels.size(), func(i) {
        if (i == state.activeModel) { updatedModel } else { state.forwardModels[i] }
      });
    };
    
    // 7. Track errors
    let newCumulativeError = state.cumulativeError * 0.99 + _abs(input.climbingError) * 0.01;
    
    // 8. Update adaptation rate based on error history
    let newAdaptation = if (newCumulativeError > 0.5) {
      _clamp(state.adaptationRate * 1.1, 0.01, 0.5)  // Increase learning if high error
    } else {
      _clamp(state.adaptationRate * 0.99, 0.01, 0.5)  // Slowly decrease
    };
    
    {
      purkinjeCells = newPurkinje;
      granuleCells = newGranules;
      dcnNeurons = newDCN;
      mossyFiberInput = input.mossyInput;
      climbingFiberError = input.climbingError;
      cerebellarOutput = cerebellarOutput;
      timingMemories = newTimingMemories;
      currentInterval = newInterval;
      intervalPhase = newPhase;
      forwardModels = newForwardModels;
      activeModel = state.activeModel;
      motorPrimitives = state.motorPrimitives;
      activePrimitive = state.activePrimitive;
      primitiveProgress = state.primitiveProgress;
      ltdRate = state.ltdRate;
      ltpRate = state.ltpRate;
      timingLR = state.timingLR;
      cumulativeError = newCumulativeError;
      adaptationRate = newAdaptation;
      beatNum = state.beatNum + 1;
      lastClimbingSpike = if (_abs(input.climbingError) > 0.3) { state.beatNum } else { state.lastClimbingSpike };
    }
  };

  // ══════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ══════════════════════════════════════════════════════════════

  // Get timing accuracy for specific interval
  public func getTimingAccuracy(state: CerebellarState, interval: Nat) : Float {
    for (m in state.timingMemories.vals()) {
      if (m.interval == interval) {
        return m.accuracy;
      };
    };
    0.0
  };

  // Generate conditioned response amplitude
  public func getConditionedResponse(state: CerebellarState, interval: Nat) : Float {
    for (m in state.timingMemories.vals()) {
      if (m.interval == interval) {
        return generateTimingResponse(m, state.intervalPhase);
      };
    };
    0.0
  };

  // Create Purkinje cell
  func createPurkinjeCell(id: Nat, nGranule: Nat) : PurkinjeCell {
    {
      id = id;
      activity = 0.5;
      parallelWeights = Array.tabulate<Float>(nGranule, func(_) { 0.5 });
      climbingInput = 0.0;
      simpleSpike = 0.5;
      complexSpike = 0.0;
      pauseDuration = 0;
    }
  };

  // Create Granule cell
  func createGranuleCell(nMossy: Nat, seed: Nat) : GranuleCell {
    {
      activity = 0.0;
      mossyWeights = Array.tabulate<Float>(nMossy, func(i) { 
        Float.fromInt((seed + i * 17) % 100) / 100.0 
      });
      threshold = 0.3 + Float.fromInt(seed % 40) / 100.0;  // Varied thresholds
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initCerebellum(nMossyInputs: Nat) : CerebellarState {
    let purkinje = Array.tabulate<PurkinjeCell>(N_PURKINJE, func(i) {
      createPurkinjeCell(i, N_GRANULE)
    });
    
    let granule = Array.tabulate<GranuleCell>(N_GRANULE, func(i) {
      createGranuleCell(nMossyInputs, i)
    });
    
    let dcn = Array.tabulate<DCNNeuron>(N_DCN, func(_) {
      { activity = 0.5; purkinjeInput = 0.5; mossyInput = 0.5; rebound = 0.0 }
    });
    
    // Initialize one forward model
    let forwardModel : ForwardModel = {
      stateEstimate = Array.tabulate<Float>(nMossyInputs, func(_) { 0.5 });
      motorCommand = [];
      sensoryPrediction = Array.tabulate<Float>(nMossyInputs, func(_) { 0.5 });
      error = 0.0;
      confidence = 0.5;
    };
    
    {
      purkinjeCells = purkinje;
      granuleCells = granule;
      dcnNeurons = dcn;
      mossyFiberInput = Array.tabulate<Float>(nMossyInputs, func(_) { 0.0 });
      climbingFiberError = 0.0;
      cerebellarOutput = Array.tabulate<Float>(N_DCN, func(_) { 0.5 });
      timingMemories = [];
      currentInterval = 0;
      intervalPhase = 0.0;
      forwardModels = [forwardModel];
      activeModel = 0;
      motorPrimitives = [];
      activePrimitive = null;
      primitiveProgress = 0.0;
      ltdRate = DEFAULT_LTD_RATE;
      ltpRate = DEFAULT_LTP_RATE;
      timingLR = DEFAULT_TIMING_LR;
      cumulativeError = 0.0;
      adaptationRate = 0.1;
      beatNum = 0;
      lastClimbingSpike = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type CerebellarSummary = {
    avgPurkinjeActivity : Float;
    avgDCNActivity      : Float;
    climbingError       : Float;
    timingMemoryCount   : Nat;
    bestTimingAccuracy  : Float;
    forwardModelError   : Float;
    cumulativeError     : Float;
    adaptationRate      : Float;
  };

  public func summary(state: CerebellarState) : CerebellarSummary {
    var avgP : Float = 0.0;
    for (p in state.purkinjeCells.vals()) { avgP += p.activity };
    avgP /= Float.fromInt(Nat.max(state.purkinjeCells.size(), 1));
    
    var avgD : Float = 0.0;
    for (d in state.dcnNeurons.vals()) { avgD += d.activity };
    avgD /= Float.fromInt(Nat.max(state.dcnNeurons.size(), 1));
    
    var bestAcc : Float = 0.0;
    for (m in state.timingMemories.vals()) {
      if (m.accuracy > bestAcc) { bestAcc := m.accuracy };
    };
    
    let fmError = if (state.forwardModels.size() > 0 and state.activeModel < state.forwardModels.size()) {
      state.forwardModels[state.activeModel].error
    } else { 0.0 };
    
    {
      avgPurkinjeActivity = avgP;
      avgDCNActivity = avgD;
      climbingError = state.climbingFiberError;
      timingMemoryCount = state.timingMemories.size();
      bestTimingAccuracy = bestAcc;
      forwardModelError = fmError;
      cumulativeError = state.cumulativeError;
      adaptationRate = state.adaptationRate;
    }
  };

}
