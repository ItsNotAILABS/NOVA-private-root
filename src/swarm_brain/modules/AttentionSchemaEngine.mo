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
// NEUROEMERGENCE CORE — ATTENTION SCHEMA ENGINE
// Awareness, attention, and consciousness modeling
// 
// Based on Graziano's Attention Schema Theory (AST):
// - The brain models its own attention process
// - This model creates subjective awareness
// - "Attention" = signal enhancement + competition resolution
// - "Awareness" = the brain's model of this process
// 
// Mathematical Framework:
// - Attention: A(x) = softmax(saliency × relevance × top_down)
// - Competition: WTA (winner-take-all) with lateral inhibition
// - Schema: S(a) = f(attention_state, prediction, confidence)
// - Awareness: Metacognitive access to attention schema
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

  // Attention target
  public type AttentionTarget = {
    id           : Nat;
    features     : [Float];       // Feature representation
    saliency     : Float;         // Bottom-up saliency [0, 1]
    relevance    : Float;         // Goal relevance [0, 1]
    attention    : Float;         // Current attention weight [0, 1]
    priority     : Float;         // Computed priority
    lastAttended : Nat;           // Beat when last attended
    inhibition   : Float;         // Inhibition from other targets
  };

  // Attention state representation
  public type AttentionState = {
    targets       : [AttentionTarget];   // All potential targets
    currentFocus  : ?Nat;                // ID of attended target
    focusStrength : Float;               // How strongly focused [0, 1]
    breadth       : Float;               // Attention breadth (narrow vs diffuse)
    capacity      : Float;               // Available attention resources
    topDownBias   : [Float];             // Goal-directed bias
    alertness     : Float;               // Overall alertness level
  };

  // Attention schema - the model of attention
  public type AttentionSchema = {
    // What is being attended
    attendedObject    : [Float];         // Representation of current focus
    attendedLocation  : [Float];         // Spatial location (if relevant)
    
    // Model of attention process
    attentionStrength : Float;           // How strongly attending
    attentionMode     : AttentionMode;   // Type of attention
    controlSource     : ControlSource;   // Endogenous vs exogenous
    
    // Predictions about attention
    predictedShift    : [Float];         // Where attention will go
    shiftUrgency      : Float;           // How soon shift expected
    
    // Confidence in the model
    modelConfidence   : Float;           // Confidence in attention model
    awarenessLevel    : Float;           // "How aware" of attending
  };

  // Attention modes
  public type AttentionMode = {
    #Focused;         // Narrow, concentrated
    #Diffuse;         // Broad, distributed
    #Divided;         // Split between targets
    #Vigilant;        // Alert but unfocused
    #Absent;          // Attention wandering/mind-wandering
  };

  // Control source
  public type ControlSource = {
    #Endogenous;      // Voluntary, goal-directed
    #Exogenous;       // Stimulus-driven, reflexive
    #Habitual;        // Automatic, learned
    #Mixed;           // Combination
  };

  // Awareness event (moments of conscious access)
  public type AwarenessEvent = {
    beatNum          : Nat;
    content          : [Float];         // What was being aware of
    intensity        : Float;           // How vivid/clear
    reportability    : Float;           // Could this be reported?
    metacognitive    : Bool;            // Aware of being aware?
  };

  // Full attention schema engine state
  public type AttentionSchemaState = {
    // Attention mechanics
    attention         : AttentionState;
    
    // The schema (model of attention)
    schema            : AttentionSchema;
    
    // Awareness history
    awarenessEvents   : [AwarenessEvent];
    awarenessCapacity : Nat;             // Max events to track
    
    // Global workspace (conscious access)
    globalWorkspace   : [Float];         // Broadcast content
    workspaceThreshold: Float;           // Threshold for access
    ignitionStrength  : Float;           // Global ignition
    
    // Metacognition
    introspectionDepth: Float;           // How deeply self-reflecting
    selfModelAccuracy : Float;           // Accuracy of self-model
    
    // Parameters
    inhibitionStrength: Float;           // Lateral inhibition
    attentionDecay    : Float;           // How fast attention decays
    
    // Temporal
    beatNum           : Nat;
    lastShift         : Nat;             // Beat of last attention shift
    shiftCount        : Nat;             // Total shifts
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let EPSILON : Float = 1e-10;
  let DEFAULT_INHIBITION : Float = 0.3;
  let DEFAULT_DECAY : Float = 0.05;
  let AWARENESS_THRESHOLD : Float = 0.5;
  let WORKSPACE_CAPACITY : Nat = 7;      // Magical number 7

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func _max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  // Softmax for attention distribution
  func softmax(values: [Float], temp: Float) : [Float] {
    let n = values.size();
    if (n == 0) { return [] };
    
    var maxVal : Float = values[0];
    for (v in values.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    
    var sumExp : Float = 0.0;
    let exps = Array.tabulate<Float>(n, func(i) {
      let e = Float.exp((values[i] - maxVal) / (temp + EPSILON));
      sumExp += e;
      e
    });
    
    Array.map<Float, Float>(exps, func(e) { e / (sumExp + EPSILON) })
  };

  // ══════════════════════════════════════════════════════════════
  // ATTENTION COMPUTATION
  // ══════════════════════════════════════════════════════════════

  // Compute target priority
  // Priority = saliency × relevance × (1 - inhibition) × recency_bonus
  public func computePriority(
    target: AttentionTarget,
    topDownBias: [Float],
    currentBeat: Nat
  ) : Float {
    // Recency: recently attended items get temporary boost then decay
    let beatsSinceAttended = currentBeat - target.lastAttended;
    let recencyFactor = if (beatsSinceAttended < 5) {
      0.8  // IOR: inhibition of return
    } else if (beatsSinceAttended < 20) {
      1.0
    } else {
      1.0 + 0.1 * Float.fromInt(beatsSinceAttended) / 100.0  // Novelty boost
    };
    
    // Top-down relevance boost
    var relevanceBoost : Float = target.relevance;
    let minLen = Nat.min(topDownBias.size(), target.features.size());
    var i : Nat = 0;
    while (i < minLen) {
      relevanceBoost += topDownBias[i] * target.features[i] * 0.2;
      i += 1;
    };
    relevanceBoost := _clamp(relevanceBoost, 0.0, 1.0);
    
    // Final priority
    let priority = target.saliency * relevanceBoost * (1.0 - target.inhibition) * recencyFactor;
    _clamp(priority, 0.0, 1.0)
  };

  // Winner-take-all competition with lateral inhibition
  public func computeAttentionWeights(
    targets: [AttentionTarget],
    inhibitionStrength: Float
  ) : [Float] {
    let n = targets.size();
    if (n == 0) { return [] };
    
    // Get priorities
    let priorities = Array.map<AttentionTarget, Float>(targets, func(t) { t.priority });
    
    // Softmax to get attention distribution
    let rawWeights = softmax(priorities, 0.5);
    
    // Apply lateral inhibition
    var maxWeight : Float = 0.0;
    var maxIdx : Nat = 0;
    var i : Nat = 0;
    for (w in rawWeights.vals()) {
      if (w > maxWeight) {
        maxWeight := w;
        maxIdx := i;
      };
      i += 1;
    };
    
    // Enhance winner, suppress others
    Array.tabulate<Float>(n, func(j) {
      if (j == maxIdx) {
        _clamp(rawWeights[j] * (1.0 + inhibitionStrength), 0.0, 1.0)
      } else {
        _clamp(rawWeights[j] * (1.0 - inhibitionStrength), 0.0, 1.0)
      }
    })
  };

  // Update attention targets
  public func updateTargets(
    targets: [AttentionTarget],
    attentionWeights: [Float],
    currentBeat: Nat
  ) : [AttentionTarget] {
    Array.tabulate<AttentionTarget>(targets.size(), func(i) {
      let target = targets[i];
      let newAttention = if (i < attentionWeights.size()) { attentionWeights[i] } else { 0.0 };
      let isAttended = newAttention > 0.5;
      
      {
        id = target.id;
        features = target.features;
        saliency = target.saliency * 0.95;  // Habituation
        relevance = target.relevance;
        attention = newAttention;
        priority = target.priority;
        lastAttended = if (isAttended) { currentBeat } else { target.lastAttended };
        inhibition = target.inhibition * 0.9;  // Inhibition decays
      }
    })
  };

  // ══════════════════════════════════════════════════════════════
  // ATTENTION SCHEMA (Model of attention)
  // ══════════════════════════════════════════════════════════════

  // Update the attention schema - the brain's model of its own attention
  public func updateAttentionSchema(
    schema: AttentionSchema,
    attentionState: AttentionState,
    previousSchema: AttentionSchema
  ) : AttentionSchema {
    // What is being attended
    let attendedFeatures = switch (attentionState.currentFocus) {
      case (?focusId) {
        var features : [Float] = [];
        for (t in attentionState.targets.vals()) {
          if (t.id == focusId) {
            features := t.features;
          };
        };
        features
      };
      case (null) { [] };
    };
    
    // Determine attention mode
    let mode : AttentionMode = if (attentionState.focusStrength > 0.8) {
      #Focused
    } else if (attentionState.breadth > 0.7) {
      #Diffuse
    } else if (attentionState.focusStrength < 0.2) {
      #Absent
    } else {
      #Vigilant
    };
    
    // Determine control source
    let highSaliencyTarget = Array.foldLeft<AttentionTarget, Float>(
      attentionState.targets,
      0.0,
      func(acc, t) { _max(acc, t.saliency) }
    );
    
    let source : ControlSource = if (highSaliencyTarget > 0.8) {
      #Exogenous
    } else if (attentionState.topDownBias.size() > 0) {
      #Endogenous
    } else {
      #Habitual
    };
    
    // Predict attention shift
    var predictedShift : [Float] = [];
    var shiftUrgency : Float = 0.0;
    for (t in attentionState.targets.vals()) {
      if (t.priority > 0.7 and t.attention < 0.5) {
        predictedShift := t.features;
        shiftUrgency := t.priority;
      };
    };
    
    // Model confidence: how well does the schema match reality?
    let attendedMatch = if (attendedFeatures.size() > 0 and previousSchema.attendedObject.size() > 0) {
      // Compute similarity
      var sim : Float = 0.0;
      let minLen = Nat.min(attendedFeatures.size(), previousSchema.attendedObject.size());
      var i : Nat = 0;
      while (i < minLen) {
        sim += attendedFeatures[i] * previousSchema.attendedObject[i];
        i += 1;
      };
      _clamp(sim, 0.0, 1.0)
    } else { 0.5 };
    
    let modelConfidence = previousSchema.modelConfidence * 0.9 + attendedMatch * 0.1;
    
    // Awareness level: depends on focus strength and model confidence
    let awarenessLevel = attentionState.focusStrength * modelConfidence;
    
    {
      attendedObject = attendedFeatures;
      attendedLocation = schema.attendedLocation;  // Would need spatial info
      attentionStrength = attentionState.focusStrength;
      attentionMode = mode;
      controlSource = source;
      predictedShift = predictedShift;
      shiftUrgency = shiftUrgency;
      modelConfidence = modelConfidence;
      awarenessLevel = awarenessLevel;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // GLOBAL WORKSPACE (Conscious access)
  // ══════════════════════════════════════════════════════════════

  // Compute global workspace content (broadcast)
  // Content enters workspace if attention + ignition exceed threshold
  public func updateGlobalWorkspace(
    schema: AttentionSchema,
    threshold: Float
  ) : ([Float], Float) {
    // Ignition: when attention exceeds threshold, content is broadcast
    let ignition = if (schema.attentionStrength > threshold) {
      _clamp((schema.attentionStrength - threshold) * 2.0, 0.0, 1.0)
    } else { 0.0 };
    
    // Workspace content is the attended object if ignition occurred
    let content = if (ignition > 0.5) {
      schema.attendedObject
    } else { [] };
    
    (content, ignition)
  };

  // Check if content has conscious access
  public func hasConsciousAccess(
    ignitionStrength: Float,
    modelConfidence: Float
  ) : Bool {
    ignitionStrength > 0.5 and modelConfidence > 0.4
  };

  // ══════════════════════════════════════════════════════════════
  // AWARENESS EVENTS
  // ══════════════════════════════════════════════════════════════

  // Create awareness event if threshold crossed
  public func createAwarenessEvent(
    schema: AttentionSchema,
    globalWorkspace: [Float],
    ignition: Float,
    beatNum: Nat
  ) : ?AwarenessEvent {
    if (ignition > AWARENESS_THRESHOLD and globalWorkspace.size() > 0) {
      ?{
        beatNum = beatNum;
        content = globalWorkspace;
        intensity = ignition;
        reportability = schema.modelConfidence;
        metacognitive = schema.awarenessLevel > 0.7;
      }
    } else { null }
  };

  // ══════════════════════════════════════════════════════════════
  // METACOGNITION
  // ══════════════════════════════════════════════════════════════

  // Introspection: examine the attention schema itself
  public func introspect(state: AttentionSchemaState) : (Float, Text) {
    let schema = state.schema;
    
    // Depth of introspection
    let depth = schema.awarenessLevel * state.introspectionDepth;
    
    // Generate introspective report
    let modeText = switch (schema.attentionMode) {
      case (#Focused) { "focused" };
      case (#Diffuse) { "diffuse" };
      case (#Divided) { "divided" };
      case (#Vigilant) { "vigilant" };
      case (#Absent) { "wandering" };
    };
    
    let report = "Attention is " # modeText # " with strength " # 
                 Float.toText(schema.attentionStrength);
    
    (depth, report)
  };

  // Update self-model accuracy based on prediction outcomes
  public func updateSelfModelAccuracy(
    currentAccuracy: Float,
    predicted: [Float],
    actual: [Float]
  ) : Float {
    if (predicted.size() == 0 or actual.size() == 0) {
      return currentAccuracy * 0.99;  // Slight decay without data
    };
    
    // Compute prediction error
    var error : Float = 0.0;
    let minLen = Nat.min(predicted.size(), actual.size());
    var i : Nat = 0;
    while (i < minLen) {
      let d = predicted[i] - actual[i];
      error += d * d;
      i += 1;
    };
    error := Float.sqrt(error / Float.fromInt(minLen));
    
    // Update accuracy
    currentAccuracy * 0.95 + (1.0 - _clamp(error, 0.0, 1.0)) * 0.05
  };

  // ══════════════════════════════════════════════════════════════
  // ATTENTION SHIFTS
  // ══════════════════════════════════════════════════════════════

  // Detect attention shift
  public func detectAttentionShift(
    oldFocus: ?Nat,
    newFocus: ?Nat
  ) : Bool {
    switch (oldFocus, newFocus) {
      case (?old, ?new) { old != new };
      case (null, ?_) { true };
      case (?_, null) { true };
      case (null, null) { false };
    }
  };

  // Compute attention shift cost
  public func computeShiftCost(
    source: ControlSource,
    distance: Float  // Conceptual/spatial distance
  ) : Float {
    let baseCost = distance * 0.2;
    let sourceMod = switch (source) {
      case (#Exogenous) { 0.5 };   // Stimulus-driven shifts are cheap
      case (#Endogenous) { 1.0 };  // Voluntary shifts cost more
      case (#Habitual) { 0.3 };    // Habitual shifts are cheapest
      case (#Mixed) { 0.7 };
    };
    _clamp(baseCost * sourceMod, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type AttentionInput = {
    newTargets     : [AttentionTarget];  // New/updated targets
    topDownBias    : [Float];            // Goal-directed bias
    alertnessLevel : Float;              // Overall alertness
    externalCue    : ?[Float];           // External attention cue
  };

  public func beatAttentionSchema(
    state: AttentionSchemaState,
    input: AttentionInput
  ) : AttentionSchemaState {
    
    // 1. Merge new targets with existing
    var allTargets = state.attention.targets;
    for (newTarget in input.newTargets.vals()) {
      var found = false;
      allTargets := Array.map<AttentionTarget, AttentionTarget>(allTargets, func(t) {
        if (t.id == newTarget.id) {
          found := true;
          newTarget
        } else { t }
      });
      if (not found) {
        allTargets := Array.append(allTargets, [newTarget]);
      };
    };
    
    // 2. Compute priorities for all targets
    allTargets := Array.map<AttentionTarget, AttentionTarget>(allTargets, func(t) {
      let priority = computePriority(t, input.topDownBias, state.beatNum);
      { t with priority = priority }
    });
    
    // 3. Apply external cue if present
    switch (input.externalCue) {
      case (?cue) {
        // Find target matching cue
        allTargets := Array.map<AttentionTarget, AttentionTarget>(allTargets, func(t) {
          var match : Float = 0.0;
          let minLen = Nat.min(t.features.size(), cue.size());
          var i : Nat = 0;
          while (i < minLen) {
            match += t.features[i] * cue[i];
            i += 1;
          };
          if (match > 0.5) {
            { t with saliency = _clamp(t.saliency + 0.3, 0.0, 1.0); priority = _clamp(t.priority + 0.3, 0.0, 1.0) }
          } else { t }
        });
      };
      case (null) {};
    };
    
    // 4. Compute attention weights (competition)
    let attentionWeights = computeAttentionWeights(allTargets, state.inhibitionStrength);
    
    // 5. Find winner (current focus)
    var maxWeight : Float = 0.0;
    var newFocus : ?Nat = null;
    var i : Nat = 0;
    for (w in attentionWeights.vals()) {
      if (w > maxWeight) {
        maxWeight := w;
        newFocus := ?i;
      };
      i += 1;
    };
    
    // 6. Detect shift
    let shifted = detectAttentionShift(state.attention.currentFocus, newFocus);
    let newShiftCount = if (shifted) { state.shiftCount + 1 } else { state.shiftCount };
    let newLastShift = if (shifted) { state.beatNum } else { state.lastShift };
    
    // 7. Update targets with new attention weights
    let updatedTargets = updateTargets(allTargets, attentionWeights, state.beatNum);
    
    // 8. Update attention state
    let newAttentionState : AttentionState = {
      targets = updatedTargets;
      currentFocus = newFocus;
      focusStrength = maxWeight;
      breadth = 1.0 - maxWeight;  // High focus = narrow breadth
      capacity = state.attention.capacity * 0.99 + input.alertnessLevel * 0.01;
      topDownBias = input.topDownBias;
      alertness = input.alertnessLevel;
    };
    
    // 9. Update attention schema
    let newSchema = updateAttentionSchema(state.schema, newAttentionState, state.schema);
    
    // 10. Update global workspace
    let (newWorkspace, ignition) = updateGlobalWorkspace(newSchema, state.workspaceThreshold);
    
    // 11. Create awareness event if appropriate
    var newAwarenessEvents = state.awarenessEvents;
    switch (createAwarenessEvent(newSchema, newWorkspace, ignition, state.beatNum)) {
      case (?event) {
        newAwarenessEvents := Array.append(newAwarenessEvents, [event]);
        // Trim to capacity
        if (newAwarenessEvents.size() > state.awarenessCapacity) {
          newAwarenessEvents := Array.tabulate<AwarenessEvent>(
            state.awarenessCapacity,
            func(j) { newAwarenessEvents[newAwarenessEvents.size() - state.awarenessCapacity + j] }
          );
        };
      };
      case (null) {};
    };
    
    // 12. Update self-model accuracy
    let newSelfModelAccuracy = updateSelfModelAccuracy(
      state.selfModelAccuracy,
      state.schema.predictedShift,
      switch (newFocus) {
        case (?fid) {
          if (fid < updatedTargets.size()) { updatedTargets[fid].features }
          else { [] }
        };
        case (null) { [] };
      }
    );
    
    // 13. Update introspection depth (increases with metacognitive events)
    let newIntrospectionDepth = if (newSchema.awarenessLevel > 0.7) {
      _clamp(state.introspectionDepth + 0.01, 0.0, 1.0)
    } else {
      state.introspectionDepth * 0.995
    };
    
    {
      attention = newAttentionState;
      schema = newSchema;
      awarenessEvents = newAwarenessEvents;
      awarenessCapacity = state.awarenessCapacity;
      globalWorkspace = newWorkspace;
      workspaceThreshold = state.workspaceThreshold;
      ignitionStrength = ignition;
      introspectionDepth = newIntrospectionDepth;
      selfModelAccuracy = newSelfModelAccuracy;
      inhibitionStrength = state.inhibitionStrength;
      attentionDecay = state.attentionDecay;
      beatNum = state.beatNum + 1;
      lastShift = newLastShift;
      shiftCount = newShiftCount;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ══════════════════════════════════════════════════════════════

  // Create attention target
  public func createTarget(
    id: Nat,
    features: [Float],
    saliency: Float,
    relevance: Float
  ) : AttentionTarget {
    {
      id = id;
      features = features;
      saliency = saliency;
      relevance = relevance;
      attention = 0.0;
      priority = saliency * relevance;
      lastAttended = 0;
      inhibition = 0.0;
    }
  };

  // Get current awareness level
  public func getAwarenessLevel(state: AttentionSchemaState) : Float {
    state.schema.awarenessLevel * state.ignitionStrength
  };

  // Is the system "conscious" of something?
  public func isConscious(state: AttentionSchemaState) : Bool {
    state.ignitionStrength > 0.5 and 
    state.schema.awarenessLevel > 0.4 and
    state.globalWorkspace.size() > 0
  };

  // Get attended content
  public func getAttendedContent(state: AttentionSchemaState) : [Float] {
    state.schema.attendedObject
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initAttentionSchema() : AttentionSchemaState {
    {
      attention = {
        targets = [];
        currentFocus = null;
        focusStrength = 0.0;
        breadth = 1.0;
        capacity = 1.0;
        topDownBias = [];
        alertness = 0.5;
      };
      schema = {
        attendedObject = [];
        attendedLocation = [];
        attentionStrength = 0.0;
        attentionMode = #Vigilant;
        controlSource = #Endogenous;
        predictedShift = [];
        shiftUrgency = 0.0;
        modelConfidence = 0.5;
        awarenessLevel = 0.0;
      };
      awarenessEvents = [];
      awarenessCapacity = 100;
      globalWorkspace = [];
      workspaceThreshold = 0.5;
      ignitionStrength = 0.0;
      introspectionDepth = 0.3;
      selfModelAccuracy = 0.5;
      inhibitionStrength = DEFAULT_INHIBITION;
      attentionDecay = DEFAULT_DECAY;
      beatNum = 0;
      lastShift = 0;
      shiftCount = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type AttentionSchemaSummary = {
    targetCount       : Nat;
    currentFocus      : ?Nat;
    focusStrength     : Float;
    attentionMode     : Text;
    awarenessLevel    : Float;
    ignitionStrength  : Float;
    isConscious       : Bool;
    selfModelAccuracy : Float;
    shiftCount        : Nat;
    recentAwarenessEvents: Nat;
  };

  public func summary(state: AttentionSchemaState) : AttentionSchemaSummary {
    let modeText = switch (state.schema.attentionMode) {
      case (#Focused) { "Focused" };
      case (#Diffuse) { "Diffuse" };
      case (#Divided) { "Divided" };
      case (#Vigilant) { "Vigilant" };
      case (#Absent) { "Absent" };
    };
    
    {
      targetCount = state.attention.targets.size();
      currentFocus = state.attention.currentFocus;
      focusStrength = state.attention.focusStrength;
      attentionMode = modeText;
      awarenessLevel = state.schema.awarenessLevel;
      ignitionStrength = state.ignitionStrength;
      isConscious = isConscious(state);
      selfModelAccuracy = state.selfModelAccuracy;
      shiftCount = state.shiftCount;
      recentAwarenessEvents = state.awarenessEvents.size();
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
