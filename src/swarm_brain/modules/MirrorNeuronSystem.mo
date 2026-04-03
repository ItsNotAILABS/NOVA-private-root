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
// NEUROEMERGENCE CORE — MIRROR NEURON SYSTEM
// Imitation, empathy, action understanding, and social learning
// 
// Biological basis:
// - F5 mirror neurons (premotor): Fire during action and observation
// - PF mirror neurons (parietal): Goal understanding
// - STS: Biological motion detection
// - Insula: Emotional mirroring, empathy
// 
// Mathematical Framework:
// - Mirror activation: M(a) = α·observe(a) + β·execute(a)
// - Action understanding: P(goal | observation) via Bayesian inference
// - Empathy: E(other) = simulation(other_state)
// - Imitation learning: Δw = η × (observed_action - predicted_action)
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

  // Observed action
  public type ObservedAction = {
    actorId      : Nat;            // Who is performing
    actionType   : Nat;            // Type of action
    kinematics   : [Float];        // Movement parameters
    object       : ?Nat;           // Object involved (if any)
    goal         : ?[Float];       // Inferred goal (if known)
    confidence   : Float;          // Observation confidence
    timestamp    : Nat;
  };

  // Mirror neuron response
  public type MirrorResponse = {
    actionId     : Nat;
    observeActivation: Float;      // Activation from observation
    executeActivation: Float;      // Activation from execution
    combinedActivation: Float;     // Mirror response
    goalRepresentation: [Float];   // Abstract goal encoding
    motorPlan    : [Float];        // Corresponding motor plan
  };

  // Agent model (for simulation/empathy)
  public type AgentModel = {
    id           : Nat;
    mentalState  : [Float];        // Estimated mental state
    intentions   : [Float];        // Estimated intentions
    emotions     : [Float];        // Estimated emotions
    beliefs      : [Float];        // Estimated beliefs
    trustLevel   : Float;          // How much to trust/cooperate
    lastUpdate   : Nat;
  };

  // Empathy response
  public type EmpathyResponse = {
    targetAgent  : Nat;
    emotionalResonance: Float;     // How much we "feel" their emotion
    cognitiveEmpathy: Float;       // Understanding their perspective
    compassion   : Float;          // Motivation to help
    contagion    : Float;          // Emotional contagion level
  };

  // Imitation memory
  public type ImitationMemory = {
    actionSequence: [[Float]];     // Observed action sequence
    demonstrator : Nat;            // Who demonstrated
    successScore : Float;          // How successful when imitated
    practiceCount: Nat;            // Times practiced
    mastery      : Float;          // Level of mastery [0, 1]
  };

  // Full mirror neuron system state
  public type MirrorNeuronState = {
    // Mirror neurons
    f5Neurons    : [Float];        // Premotor mirror neurons
    pfNeurons    : [Float];        // Parietal mirror neurons
    stsNeurons   : [Float];        // Biological motion
    insulaNeurons: [Float];        // Emotional mirroring
    
    // Current observations
    currentObservations: [ObservedAction];
    mirrorResponses: [MirrorResponse];
    
    // Agent models (theory of mind)
    agentModels  : [AgentModel];
    selfModel    : AgentModel;     // Model of self
    
    // Empathy state
    currentEmpathy: [EmpathyResponse];
    empathyCapacity: Float;        // Individual differences
    
    // Imitation learning
    imitationMemories: [ImitationMemory];
    currentImitationTarget: ?Nat;  // Who to imitate
    imitationStrength: Float;      // How strongly imitating
    
    // Social learning
    socialLearningRate: Float;
    observationalLearning: Float;  // Learning from watching
    
    // Parameters
    mirrorGain   : Float;
    empathyGain  : Float;
    
    // Temporal
    beatNum      : Nat;
    lastObservation: Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let EPSILON : Float = 1e-10;
  let MIRROR_GAIN : Float = 1.0;
  let EMPATHY_GAIN : Float = 0.8;
  let MAX_AGENTS : Nat = 10;
  let MAX_OBSERVATIONS : Nat = 20;

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

  // Cosine similarity between vectors
  func cosineSimilarity(a: [Float], b: [Float]) : Float {
    let minLen = Nat.min(a.size(), b.size());
    if (minLen == 0) { return 0.0 };
    
    var dot : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    
    var i : Nat = 0;
    while (i < minLen) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
      i += 1;
    };
    
    let denom = Float.sqrt(normA) * Float.sqrt(normB);
    if (denom < EPSILON) { 0.0 } else { dot / denom }
  };

  // ══════════════════════════════════════════════════════════════
  // MIRROR NEURON ACTIVATION
  // ══════════════════════════════════════════════════════════════

  // Compute mirror neuron response to observed action
  // M(a) = α·observe(a) + β·execute(a)
  public func computeMirrorResponse(
    observation: ObservedAction,
    ownMotorState: [Float],
    mirrorGain: Float
  ) : MirrorResponse {
    // Observation activation: based on kinematics
    var observeActivation : Float = 0.0;
    for (k in observation.kinematics.vals()) {
      observeActivation += _abs(k);
    };
    observeActivation := _clamp(
      observeActivation / Float.fromInt(Nat.max(observation.kinematics.size(), 1)),
      0.0, 1.0
    );
    
    // Execute activation: match between observation and own motor state
    let similarity = cosineSimilarity(observation.kinematics, ownMotorState);
    let executeActivation = _clamp(_abs(similarity), 0.0, 1.0);
    
    // Combined mirror activation
    let combined = mirrorGain * (0.6 * observeActivation + 0.4 * executeActivation);
    
    // Goal representation: abstract encoding of action goal
    let goalRep = switch (observation.goal) {
      case (?g) { g };
      case (null) {
        // Infer goal from kinematics
        Array.tabulate<Float>(5, func(i) {
          if (i < observation.kinematics.size()) {
            _sigmoid(observation.kinematics[i] * 2.0)
          } else { 0.5 }
        })
      };
    };
    
    // Motor plan for imitation
    let motorPlan = observation.kinematics;
    
    {
      actionId = observation.actionType;
      observeActivation = observeActivation;
      executeActivation = executeActivation;
      combinedActivation = _clamp(combined, 0.0, 1.0);
      goalRepresentation = goalRep;
      motorPlan = motorPlan;
    }
  };

  // Update F5 (premotor) mirror neurons
  public func updateF5Neurons(
    f5: [Float],
    mirrorResponses: [MirrorResponse]
  ) : [Float] {
    let n = Nat.max(f5.size(), 10);
    Array.tabulate<Float>(n, func(i) {
      var activation : Float = if (i < f5.size()) { f5[i] * 0.8 } else { 0.0 };
      
      // Sum activations from matching mirror responses
      for (mr in mirrorResponses.vals()) {
        if (mr.actionId == i) {
          activation += mr.combinedActivation * 0.3;
        };
      };
      
      _clamp(activation, 0.0, 1.0)
    })
  };

  // Update PF (parietal) mirror neurons - goal encoding
  public func updatePFNeurons(
    pf: [Float],
    mirrorResponses: [MirrorResponse]
  ) : [Float] {
    let n = Nat.max(pf.size(), 10);
    Array.tabulate<Float>(n, func(i) {
      var activation : Float = if (i < pf.size()) { pf[i] * 0.85 } else { 0.0 };
      
      // PF encodes goal abstraction
      for (mr in mirrorResponses.vals()) {
        if (i < mr.goalRepresentation.size()) {
          activation += mr.goalRepresentation[i] * mr.combinedActivation * 0.2;
        };
      };
      
      _clamp(activation, 0.0, 1.0)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // BIOLOGICAL MOTION (STS)
  // ══════════════════════════════════════════════════════════════

  // Update STS neurons - biological motion detection
  public func updateSTSNeurons(
    sts: [Float],
    observations: [ObservedAction]
  ) : [Float] {
    let n = Nat.max(sts.size(), 5);
    Array.tabulate<Float>(n, func(i) {
      var activation : Float = if (i < sts.size()) { sts[i] * 0.7 } else { 0.0 };
      
      // STS responds to biological motion patterns
      for (obs in observations.vals()) {
        // Check for biological motion signatures
        if (obs.kinematics.size() > 2) {
          var variance : Float = 0.0;
          var mean : Float = 0.0;
          for (k in obs.kinematics.vals()) { mean += k };
          mean /= Float.fromInt(obs.kinematics.size());
          for (k in obs.kinematics.vals()) {
            variance += (k - mean) * (k - mean);
          };
          
          // Biological motion has characteristic variance
          let bioMotionScore = _sigmoid(variance * 5.0 - 1.0);
          activation += bioMotionScore * obs.confidence * 0.3;
        };
      };
      
      _clamp(activation, 0.0, 1.0)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // EMPATHY (Insula)
  // ══════════════════════════════════════════════════════════════

  // Compute empathy response for observed agent
  public func computeEmpathyResponse(
    agentModel: AgentModel,
    selfEmotions: [Float],
    empathyGain: Float
  ) : EmpathyResponse {
    // Emotional resonance: similarity between self and other's emotions
    let emotionalSim = cosineSimilarity(selfEmotions, agentModel.emotions);
    let emotionalResonance = _clamp(emotionalSim * empathyGain, 0.0, 1.0);
    
    // Cognitive empathy: understanding their mental state
    var mentalStateClarity : Float = 0.0;
    for (ms in agentModel.mentalState.vals()) {
      mentalStateClarity += _abs(ms);
    };
    mentalStateClarity := mentalStateClarity / Float.fromInt(Nat.max(agentModel.mentalState.size(), 1));
    let cognitiveEmpathy = _clamp(mentalStateClarity * empathyGain, 0.0, 1.0);
    
    // Emotional contagion: how much their emotion affects us
    var emotionIntensity : Float = 0.0;
    for (e in agentModel.emotions.vals()) {
      emotionIntensity += _abs(e);
    };
    emotionIntensity := emotionIntensity / Float.fromInt(Nat.max(agentModel.emotions.size(), 1));
    let contagion = emotionIntensity * emotionalResonance;
    
    // Compassion: motivated by negative emotions in other
    var negativeEmotion : Float = 0.0;
    for (e in agentModel.emotions.vals()) {
      if (e < 0.0) { negativeEmotion += _abs(e) };
    };
    let compassion = _clamp(negativeEmotion * cognitiveEmpathy, 0.0, 1.0);
    
    {
      targetAgent = agentModel.id;
      emotionalResonance = emotionalResonance;
      cognitiveEmpathy = cognitiveEmpathy;
      compassion = compassion;
      contagion = contagion;
    }
  };

  // Update insula neurons (emotional mirroring)
  public func updateInsulaNeurons(
    insula: [Float],
    empathyResponses: [EmpathyResponse]
  ) : [Float] {
    let n = Nat.max(insula.size(), 5);
    Array.tabulate<Float>(n, func(i) {
      var activation : Float = if (i < insula.size()) { insula[i] * 0.75 } else { 0.0 };
      
      // Insula reflects empathic responses
      for (er in empathyResponses.vals()) {
        activation += er.emotionalResonance * 0.2;
        activation += er.contagion * 0.15;
      };
      
      _clamp(activation, 0.0, 1.0)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // AGENT MODELING (Theory of Mind)
  // ══════════════════════════════════════════════════════════════

  // Update or create agent model based on observations
  public func updateAgentModel(
    model: AgentModel,
    observation: ObservedAction,
    currentBeat: Nat
  ) : AgentModel {
    // Update intentions based on observed action
    let newIntentions = Array.tabulate<Float>(5, func(i) {
      let current = if (i < model.intentions.size()) { model.intentions[i] } else { 0.0 };
      let observed = if (i < observation.kinematics.size()) { 
        _sigmoid(observation.kinematics[i]) 
      } else { 0.0 };
      current * 0.7 + observed * 0.3
    });
    
    // Infer emotions from action kinematics
    let newEmotions = Array.tabulate<Float>(3, func(i) {
      let current = if (i < model.emotions.size()) { model.emotions[i] } else { 0.0 };
      // Emotion inference heuristic
      let inferred = switch (i) {
        case 0 { observation.confidence * 0.5 - 0.25 };  // Valence
        case 1 { if (observation.kinematics.size() > 0) { _abs(observation.kinematics[0]) } else { 0.0 } };  // Arousal
        case _ { 0.0 };
      };
      current * 0.8 + inferred * 0.2
    });
    
    // Update mental state
    let newMentalState = Array.tabulate<Float>(model.mentalState.size(), func(i) {
      let current = if (i < model.mentalState.size()) { model.mentalState[i] } else { 0.0 };
      current * 0.9 + (if (i < newIntentions.size()) { newIntentions[i] } else { 0.0 }) * 0.1
    });
    
    {
      id = model.id;
      mentalState = newMentalState;
      intentions = newIntentions;
      emotions = newEmotions;
      beliefs = model.beliefs;  // Beliefs update more slowly
      trustLevel = model.trustLevel;
      lastUpdate = currentBeat;
    }
  };

  // Create new agent model
  public func createAgentModel(id: Nat, beatNum: Nat) : AgentModel {
    {
      id = id;
      mentalState = Array.tabulate<Float>(5, func(_) { 0.0 });
      intentions = Array.tabulate<Float>(5, func(_) { 0.0 });
      emotions = Array.tabulate<Float>(3, func(_) { 0.0 });
      beliefs = [];
      trustLevel = 0.5;
      lastUpdate = beatNum;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // IMITATION LEARNING
  // ══════════════════════════════════════════════════════════════

  // Create imitation memory from observation
  public func createImitationMemory(
    observations: [ObservedAction],
    demonstratorId: Nat
  ) : ImitationMemory {
    let sequence = Array.map<ObservedAction, [Float]>(observations, func(o) { o.kinematics });
    
    {
      actionSequence = sequence;
      demonstrator = demonstratorId;
      successScore = 0.0;
      practiceCount = 0;
      mastery = 0.0;
    }
  };

  // Update imitation memory after practice
  public func updateImitationMemory(
    memory: ImitationMemory,
    executionSuccess: Float
  ) : ImitationMemory {
    let newPractice = memory.practiceCount + 1;
    let newSuccess = memory.successScore * 0.9 + executionSuccess * 0.1;
    
    // Mastery increases with practice and success
    let newMastery = _clamp(
      memory.mastery + (executionSuccess * 0.1 / Float.sqrt(Float.fromInt(newPractice))),
      0.0, 1.0
    );
    
    {
      actionSequence = memory.actionSequence;
      demonstrator = memory.demonstrator;
      successScore = newSuccess;
      practiceCount = newPractice;
      mastery = newMastery;
    }
  };

  // Get motor plan for imitation
  public func getImitationMotorPlan(memory: ImitationMemory, step: Nat) : [Float] {
    if (step < memory.actionSequence.size()) {
      memory.actionSequence[step]
    } else if (memory.actionSequence.size() > 0) {
      memory.actionSequence[memory.actionSequence.size() - 1]
    } else {
      []
    }
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type MirrorInput = {
    observations     : [ObservedAction];
    ownMotorState    : [Float];
    ownEmotions      : [Float];
    executingAction  : ?Nat;
    imitationTarget  : ?Nat;
    socialContext    : Float;      // Social salience [0, 1]
  };

  public func beatMirrorNeurons(
    state: MirrorNeuronState,
    input: MirrorInput
  ) : MirrorNeuronState {
    
    // 1. Compute mirror responses for all observations
    let mirrorResponses = Array.map<ObservedAction, MirrorResponse>(
      input.observations,
      func(obs) { computeMirrorResponse(obs, input.ownMotorState, state.mirrorGain) }
    );
    
    // 2. Update F5 neurons
    let newF5 = updateF5Neurons(state.f5Neurons, mirrorResponses);
    
    // 3. Update PF neurons
    let newPF = updatePFNeurons(state.pfNeurons, mirrorResponses);
    
    // 4. Update STS neurons
    let newSTS = updateSTSNeurons(state.stsNeurons, input.observations);
    
    // 5. Update agent models
    var newAgentModels = state.agentModels;
    for (obs in input.observations.vals()) {
      var found = false;
      newAgentModels := Array.map<AgentModel, AgentModel>(newAgentModels, func(am) {
        if (am.id == obs.actorId) {
          found := true;
          updateAgentModel(am, obs, state.beatNum)
        } else { am }
      });
      
      if (not found and newAgentModels.size() < MAX_AGENTS) {
        let newModel = updateAgentModel(
          createAgentModel(obs.actorId, state.beatNum),
          obs,
          state.beatNum
        );
        newAgentModels := Array.append(newAgentModels, [newModel]);
      };
    };
    
    // 6. Compute empathy responses
    let empathyResponses = Array.map<AgentModel, EmpathyResponse>(
      newAgentModels,
      func(am) { computeEmpathyResponse(am, input.ownEmotions, state.empathyGain) }
    );
    
    // 7. Update insula neurons
    let newInsula = updateInsulaNeurons(state.insulaNeurons, empathyResponses);
    
    // 8. Update imitation state
    var newImitationMemories = state.imitationMemories;
    var newImitationTarget = input.imitationTarget;
    var newImitationStrength = state.imitationStrength;
    
    switch (input.imitationTarget) {
      case (?targetId) {
        // Find observations from target
        let targetObs = Array.filter<ObservedAction>(
          input.observations,
          func(o) { o.actorId == targetId }
        );
        
        if (targetObs.size() > 0) {
          // Create or update imitation memory
          let newMemory = createImitationMemory(targetObs, targetId);
          newImitationMemories := Array.append(newImitationMemories, [newMemory]);
          newImitationStrength := _clamp(state.imitationStrength + 0.1, 0.0, 1.0);
        };
      };
      case (null) {
        newImitationStrength := state.imitationStrength * 0.95;
      };
    };
    
    // Trim memories
    if (newImitationMemories.size() > 50) {
      newImitationMemories := Array.tabulate<ImitationMemory>(
        50,
        func(i) { newImitationMemories[newImitationMemories.size() - 50 + i] }
      );
    };
    
    // 9. Update self model
    let newSelfModel : AgentModel = {
      id = state.selfModel.id;
      mentalState = Array.tabulate<Float>(5, func(i) {
        let current = if (i < state.selfModel.mentalState.size()) { 
          state.selfModel.mentalState[i] 
        } else { 0.0 };
        let motor = if (i < input.ownMotorState.size()) { input.ownMotorState[i] } else { 0.0 };
        current * 0.9 + motor * 0.1
      });
      intentions = state.selfModel.intentions;
      emotions = input.ownEmotions;
      beliefs = state.selfModel.beliefs;
      trustLevel = 1.0;  // Trust self
      lastUpdate = state.beatNum;
    };
    
    // 10. Update social learning rate based on context
    let newSocialLR = state.socialLearningRate * 0.99 + input.socialContext * 0.01;
    
    // 11. Observational learning: average mirror activation
    var obsLearning : Float = 0.0;
    for (mr in mirrorResponses.vals()) {
      obsLearning += mr.combinedActivation;
    };
    obsLearning := if (mirrorResponses.size() > 0) {
      obsLearning / Float.fromInt(mirrorResponses.size())
    } else { 0.0 };
    
    {
      f5Neurons = newF5;
      pfNeurons = newPF;
      stsNeurons = newSTS;
      insulaNeurons = newInsula;
      currentObservations = input.observations;
      mirrorResponses = mirrorResponses;
      agentModels = newAgentModels;
      selfModel = newSelfModel;
      currentEmpathy = empathyResponses;
      empathyCapacity = state.empathyCapacity;
      imitationMemories = newImitationMemories;
      currentImitationTarget = newImitationTarget;
      imitationStrength = newImitationStrength;
      socialLearningRate = newSocialLR;
      observationalLearning = obsLearning;
      mirrorGain = state.mirrorGain;
      empathyGain = state.empathyGain;
      beatNum = state.beatNum + 1;
      lastObservation = if (input.observations.size() > 0) { state.beatNum } else { state.lastObservation };
    }
  };

  // ══════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ══════════════════════════════════════════════════════════════

  // Get motor plan for imitation of target
  public func getImitationPlan(state: MirrorNeuronState, step: Nat) : [Float] {
    switch (state.currentImitationTarget) {
      case (?targetId) {
        for (mem in state.imitationMemories.vals()) {
          if (mem.demonstrator == targetId) {
            return getImitationMotorPlan(mem, step);
          };
        };
        [];
      };
      case (null) { [] };
    }
  };

  // Get empathy level for specific agent
  public func getEmpathyForAgent(state: MirrorNeuronState, agentId: Nat) : Float {
    for (er in state.currentEmpathy.vals()) {
      if (er.targetAgent == agentId) {
        return (er.emotionalResonance + er.cognitiveEmpathy) / 2.0;
      };
    };
    0.0
  };

  // Is observing biological motion?
  public func isObservingBioMotion(state: MirrorNeuronState) : Bool {
    var avgSTS : Float = 0.0;
    for (s in state.stsNeurons.vals()) { avgSTS += s };
    avgSTS /= Float.fromInt(Nat.max(state.stsNeurons.size(), 1));
    avgSTS > 0.5
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initMirrorNeurons() : MirrorNeuronState {
    {
      f5Neurons = Array.tabulate<Float>(10, func(_) { 0.0 });
      pfNeurons = Array.tabulate<Float>(10, func(_) { 0.0 });
      stsNeurons = Array.tabulate<Float>(5, func(_) { 0.0 });
      insulaNeurons = Array.tabulate<Float>(5, func(_) { 0.0 });
      currentObservations = [];
      mirrorResponses = [];
      agentModels = [];
      selfModel = createAgentModel(0, 0);
      currentEmpathy = [];
      empathyCapacity = 0.7;
      imitationMemories = [];
      currentImitationTarget = null;
      imitationStrength = 0.0;
      socialLearningRate = 0.1;
      observationalLearning = 0.0;
      mirrorGain = MIRROR_GAIN;
      empathyGain = EMPATHY_GAIN;
      beatNum = 0;
      lastObservation = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type MirrorNeuronSummary = {
    avgMirrorActivation : Float;
    agentModelsCount    : Nat;
    avgEmpathyLevel     : Float;
    imitationStrength   : Float;
    observationalLearning: Float;
    isObservingBioMotion: Bool;
    currentTargetAgent  : ?Nat;
  };

  public func summary(state: MirrorNeuronState) : MirrorNeuronSummary {
    var avgMirror : Float = 0.0;
    for (mr in state.mirrorResponses.vals()) {
      avgMirror += mr.combinedActivation;
    };
    avgMirror := if (state.mirrorResponses.size() > 0) {
      avgMirror / Float.fromInt(state.mirrorResponses.size())
    } else { 0.0 };
    
    var avgEmpathy : Float = 0.0;
    for (er in state.currentEmpathy.vals()) {
      avgEmpathy += (er.emotionalResonance + er.cognitiveEmpathy) / 2.0;
    };
    avgEmpathy := if (state.currentEmpathy.size() > 0) {
      avgEmpathy / Float.fromInt(state.currentEmpathy.size())
    } else { 0.0 };
    
    {
      avgMirrorActivation = avgMirror;
      agentModelsCount = state.agentModels.size();
      avgEmpathyLevel = avgEmpathy;
      imitationStrength = state.imitationStrength;
      observationalLearning = state.observationalLearning;
      isObservingBioMotion = isObservingBioMotion(state);
      currentTargetAgent = state.currentImitationTarget;
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
  //  M E D I N A   S P E C I A L   M A T H E M A T I C S
  //
  //  Enterprise-Level Medina Discovery Mathematics
  //  HIM/HER Dual-Organism Sacred Coupling Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SACRED GEOMETRY MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Golden ratio φ = (1 + √5) / 2
  public let PHI : Float = 1.6180339887498948482;

  /// Fibonacci sequence generator
  public func medinaFibonacci(n : Nat) : Nat {
    if (n <= 1) { n }
    else {
      var a : Nat = 0;
      var b : Nat = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  /// Golden spiral radius at angle
  public func medinaGoldenSpiral(angle : Float, a : Float, b : Float) : Float {
    a * Float.exp(b * angle)
  };

  /// Sacred proportion check
  public func medinaSacredProportion(a : Float, b : Float, tolerance : Float) : Bool {
    let ratio = if (a > b) a / b else b / a;
    Float.abs(ratio - PHI) < tolerance
  };

  /// Vesica piscis area
  public func medinaVesicaPiscisArea(radius : Float) : Float {
    let r2 = radius * radius;
    r2 * (4.0 * 3.14159265 / 3.0 - Float.sqrt(3.0) / 2.0)
  };

  /// Platonic solid vertices (tetrahedron example)
  public func medinaTetrahedronVertex(index : Nat, size : Float) : (Float, Float, Float) {
    let vertices = [
      (1.0, 1.0, 1.0),
      (1.0, -1.0, -1.0),
      (-1.0, 1.0, -1.0),
      (-1.0, -1.0, 1.0)
    ];
    let v = vertices[index % 4];
    (v.0 * size, v.1 * size, v.2 * size)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELICAL MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Helix position at parameter t
  public func medinaHelixPosition(t : Float, radius : Float, pitch : Float) : (Float, Float, Float) {
    let x = radius * Float.cos(t);
    let y = radius * Float.sin(t);
    let z = pitch * t / (2.0 * 3.14159265);
    (x, y, z)
  };

  /// Double helix offset
  public func medinaDoubleHelixOffset(t : Float, radius : Float, pitch : Float, offset : Float) : ((Float, Float, Float), (Float, Float, Float)) {
    let h1 = medinaHelixPosition(t, radius, pitch);
    let h2 = medinaHelixPosition(t + offset, radius, pitch);
    (h1, h2)
  };

  /// Helical curvature
  public func medinaHelicalCurvature(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    radius / (radius * radius + p * p)
  };

  /// Helical torsion
  public func medinaHelicalTorsion(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    p / (radius * radius + p * p)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPHERICAL HARMONICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spherical to Cartesian
  public func medinaSphericalToCartesian(r : Float, theta : Float, phi : Float) : (Float, Float, Float) {
    let x = r * Float.sin(theta) * Float.cos(phi);
    let y = r * Float.sin(theta) * Float.sin(phi);
    let z = r * Float.cos(theta);
    (x, y, z)
  };

  /// Cartesian to Spherical
  public func medinaCartesianToSpherical(x : Float, y : Float, z : Float) : (Float, Float, Float) {
    let r = Float.sqrt(x * x + y * y + z * z);
    let theta = Float.acos(z / (r + 0.0001));
    let phi = Float.atan2(y, x);
    (r, theta, phi)
  };

  /// Associated Legendre polynomial P_l^m (simplified)
  public func medinaLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (l == 0 and m == 0) { return 1.0 };
    if (l == 1 and m == 0) { return x };
    if (l == 1 and m == 1) { return -Float.sqrt(1.0 - x * x) };
    if (l == 2 and m == 0) { return 0.5 * (3.0 * x * x - 1.0) };
    // Simplified for higher orders
    Float.pow(x, Float.fromInt(l - m))
  };

  /// Spherical harmonic Y_l^m (simplified real part)
  public func medinaSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let plm = medinaLegendreP(l, mAbs, Float.cos(theta));
    if (m >= 0) {
      plm * Float.cos(Float.fromInt(mAbs) * phi)
    } else {
      plm * Float.sin(Float.fromInt(mAbs) * phi)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LIVING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Growth curve (logistic)
  public func medinaGrowthCurve(t : Float, k : Float, l : Float, x0 : Float) : Float {
    l / (1.0 + Float.exp(-k * (t - x0)))
  };

  /// Morphogenesis reaction-diffusion
  public func medinaMorphogenesis(
    u : Float,
    v : Float,
    du : Float,
    dv : Float,
    f : Float,
    k : Float
  ) : (Float, Float) {
    let reaction = u * v * v;
    let newU = du - reaction + f * (1.0 - u);
    let newV = dv + reaction - (f + k) * v;
    (newU, newV)
  };

  /// Phyllotaxis angle (golden angle)
  public func medinaPhyllotaxisAngle(n : Nat) : Float {
    let goldenAngle : Float = 137.5077640500378546463;
    Float.fromInt(n) * goldenAngle * 3.14159265 / 180.0
  };

  /// Branching pattern
  public func medinaBranchingPattern(
    parentLength : Float,
    branchRatio : Float,
    angle : Float,
    depth : Nat
  ) : Float {
    parentLength * Float.pow(branchRatio, Float.fromInt(depth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MIRROR MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reflection across plane
  public func medinaReflection(point : (Float, Float, Float), normal : (Float, Float, Float)) : (Float, Float, Float) {
    let dot = point.0 * normal.0 + point.1 * normal.1 + point.2 * normal.2;
    let rx = point.0 - 2.0 * dot * normal.0;
    let ry = point.1 - 2.0 * dot * normal.1;
    let rz = point.2 - 2.0 * dot * normal.2;
    (rx, ry, rz)
  };

  /// Symmetry score
  public func medinaSymmetryScore(left : [Float], right : [Float]) : Float {
    let n = if (left.size() < right.size()) left.size() else right.size();
    if (n == 0) { return 1.0 };
    var diff : Float = 0.0;
    var i = 0;
    while (i < n) {
      diff += Float.abs(left[i] - right[n - 1 - i]);
      i += 1;
    };
    1.0 / (1.0 + diff)
  };

  /// Fractal dimension estimation
  public func medinaFractalDimension(boxCounts : [Nat], scales : [Float]) : Float {
    let n = if (boxCounts.size() < scales.size()) boxCounts.size() else scales.size();
    if (n < 2) { return 1.0 };
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let x = Float.log(1.0 / scales[i]);
      let y = Float.log(Float.fromInt(boxCounts[i]));
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    let nf = Float.fromInt(n);
    (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COVENANT MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Commitment strength
  public func medinaCommitmentStrength(
    duration : Nat,
    consistency : Float,
    depth : Float
  ) : Float {
    let durationFactor = Float.log(Float.fromInt(duration + 1));
    consistency * depth * durationFactor
  };

  /// Trust accumulation
  public func medinaTrustAccumulation(
    currentTrust : Float,
    interaction : Float,
    reciprocity : Float
  ) : Float {
    let gain = interaction * reciprocity * (1.0 - currentTrust);
    currentTrust + gain
  };

  /// Covenant breach penalty
  public func medinaBreachPenalty(
    trustLevel : Float,
    violationSeverity : Float,
    relationshipAge : Nat
  ) : Float {
    let ageFactor = Float.log(Float.fromInt(relationshipAge + 1));
    trustLevel * violationSeverity * ageFactor
  };

}
