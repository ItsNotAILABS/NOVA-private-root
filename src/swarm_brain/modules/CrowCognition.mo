// ============================================================
// CROW COGNITION — CORVID INTELLIGENCE MODULE
// Causal reasoning, tool use, future planning, social learning
// 1.5 billion pallial neurons (comparable to some primates)
// Theory of mind, episodic memory, mental time travel
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let PLANNING_HORIZON : Nat = 12;   // Steps ahead crow can plan
  let TOOL_MEMORY_SIZE : Nat = 8;    // Remembered tool-use solutions

  // ── Types ─────────────────────────────────────────────────────
  public type CausalModel = {
    causeId    : Nat;
    effectId   : Nat;
    strength   : Float;    // How strongly cause predicts effect
    confidence : Float;    // Certainty in this relationship
    usageCount : Nat;      // Times this model was used
  };

  public type ToolSolution = {
    problemType : Nat;     // Category of problem
    toolType    : Nat;     // Type of tool used
    success     : Float;   // Success rate
    complexity  : Float;   // Number of steps
    lastUsed    : Nat;     // Beat when last used
  };

  public type FuturePlan = {
    goal        : Nat;     // Target state
    steps       : [Nat];   // Sequence of actions
    confidence  : Float;   // Likelihood of success
    value       : Float;   // Expected reward
    timeToGoal  : Nat;     // Estimated beats to achieve
  };

  public type SocialKnowledge = {
    agentId     : Nat;
    trustLevel  : Float;   // How much to trust this agent
    dominance   : Float;   // Social rank
    lastSeen    : Nat;     // When last observed
    behaviors   : [Float]; // Observed behavior patterns
  };

  public type CrowState = {
    // Causal reasoning
    causalModels     : [CausalModel];
    causalConfidence : Float;

    // Tool use
    toolSolutions    : [ToolSolution];
    currentTool      : ?Nat;
    toolProficiency  : Float;

    // Future planning
    currentPlan      : ?FuturePlan;
    planningDepth    : Nat;
    futureDiscounting: Float;  // How much to discount future rewards

    // Social cognition
    socialKnowledge  : [SocialKnowledge];
    selfAwareness    : Float;
    theoryOfMind     : Float;  // Ability to model others' mental states

    // Working memory
    workingMemory    : [Float];  // 7±2 items
    attentionFocus   : Float;

    // Episodic memory: what-where-when
    episodicMemory   : [EpisodicEvent];

    // Problem solving
    insightLevel     : Float;   // Aha! moment likelihood
    persistenceLevel : Float;   // Keep trying vs. give up

    beatNum          : Nat;
  };

  public type EpisodicEvent = {
    what  : Nat;      // Event type
    where : Nat;      // Location index
    when  : Nat;      // Beat number
    who   : ?Nat;     // Agent involved
    value : Float;    // Emotional valence
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func sigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-4.0 * (x - 0.5)))
  };

  // ── Causal Reasoning ──────────────────────────────────────────
  // Corvids can infer cause-effect from observation
  public func updateCausalModel(
    models: [CausalModel], observedCause: Nat, observedEffect: Nat, success: Bool
  ) : [CausalModel] {
    Array.map<CausalModel, CausalModel>(models, func(m) {
      if (m.causeId == observedCause and m.effectId == observedEffect) {
        let delta = if (success) { 0.1 } else { -0.05 };
        {
          causeId = m.causeId;
          effectId = m.effectId;
          strength = _clamp(m.strength + delta, 0.0, 1.0);
          confidence = _clamp(m.confidence + 0.02, 0.0, 1.0);
          usageCount = m.usageCount + 1;
        }
      } else { m }
    })
  };

  // Predict effect given cause
  public func predictEffect(models: [CausalModel], causeId: Nat) : ?Nat {
    var bestEffect : ?Nat = null;
    var bestStrength : Float = 0.0;

    for (m in models.vals()) {
      if (m.causeId == causeId and m.strength > bestStrength) {
        bestStrength := m.strength;
        bestEffect := ?m.effectId;
      };
    };
    bestEffect
  };

  // ── Tool Use ──────────────────────────────────────────────────
  // Select best tool for current problem
  public func selectTool(
    solutions: [ToolSolution], problemType: Nat
  ) : ?ToolSolution {
    var bestSolution : ?ToolSolution = null;
    var bestScore : Float = 0.0;

    for (s in solutions.vals()) {
      if (s.problemType == problemType) {
        let score = s.success * (1.0 / (1.0 + s.complexity * 0.1));
        if (score > bestScore) {
          bestScore := score;
          bestSolution := ?s;
        };
      };
    };
    bestSolution
  };

  // Learn from tool use outcome
  public func learnToolUse(
    solutions: [ToolSolution], problemType: Nat, toolType: Nat,
    success: Bool, beat: Nat
  ) : [ToolSolution] {
    var found = false;
    let updated = Array.map<ToolSolution, ToolSolution>(solutions, func(s) {
      if (s.problemType == problemType and s.toolType == toolType) {
        found := true;
        let delta = if (success) { 0.1 } else { -0.05 };
        {
          problemType = s.problemType;
          toolType = s.toolType;
          success = _clamp(s.success + delta, 0.0, 1.0);
          complexity = s.complexity;
          lastUsed = beat;
        }
      } else { s }
    });

    if (not found and success) {
      // Add new solution
      Array.append<ToolSolution>(updated, [{
        problemType = problemType;
        toolType = toolType;
        success = 0.6;
        complexity = 1.0;
        lastUsed = beat;
      }])
    } else { updated }
  };

  // ── Future Planning ───────────────────────────────────────────
  // Corvids can plan multiple steps ahead
  public func generatePlan(
    state: CrowState, goal: Nat, currentState: Nat
  ) : FuturePlan {
    // Simple breadth-first style planning using causal models
    var steps : [Nat] = [];
    var current = currentState;
    var confidence : Float = 1.0;
    var totalValue : Float = 0.0;

    var depth = 0;
    while (depth < state.planningDepth and current != goal) {
      switch (predictEffect(state.causalModels, current)) {
        case (null) { depth := state.planningDepth }; // No path
        case (?next) {
          steps := Array.append<Nat>(steps, [next]);
          // Discount future values
          totalValue += Float.pow(state.futureDiscounting, Float.fromInt(depth));
          confidence *= 0.9;
          current := next;
          depth += 1;
        };
      };
    };

    {
      goal = goal;
      steps = steps;
      confidence = confidence;
      value = totalValue;
      timeToGoal = steps.size();
    }
  };

  // ── Social Cognition ──────────────────────────────────────────
  // Update knowledge about another agent
  public func observeAgent(
    knowledge: [SocialKnowledge], agentId: Nat, behavior: Float, beat: Nat
  ) : [SocialKnowledge] {
    var found = false;
    let updated = Array.map<SocialKnowledge, SocialKnowledge>(knowledge, func(k) {
      if (k.agentId == agentId) {
        found := true;
        // Update trust based on behavior consistency
        let behaviorHistory = Array.append<Float>(
          if (k.behaviors.size() > 10) {
            Array.tabulate<Float>(9, func(i) { k.behaviors[i + 1] })
          } else { k.behaviors },
          [behavior]
        );
        {
          agentId = k.agentId;
          trustLevel = _clamp(k.trustLevel + (behavior - 0.5) * 0.1, 0.0, 1.0);
          dominance = k.dominance;
          lastSeen = beat;
          behaviors = behaviorHistory;
        }
      } else { k }
    });

    if (not found) {
      Array.append<SocialKnowledge>(updated, [{
        agentId = agentId;
        trustLevel = 0.5;
        dominance = 0.5;
        lastSeen = beat;
        behaviors = [behavior];
      }])
    } else { updated }
  };

  // ── Theory of Mind ────────────────────────────────────────────
  // Model what another agent might know/want
  public func inferAgentState(
    knowledge: [SocialKnowledge], agentId: Nat, theoryOfMind: Float
  ) : (Float, Float) {
    // Returns (likely_goal, likely_knowledge_level)
    for (k in knowledge.vals()) {
      if (k.agentId == agentId) {
        // Use behavior history to infer state
        var avgBehavior : Float = 0.0;
        for (b in k.behaviors.vals()) { avgBehavior += b };
        avgBehavior /= Float.fromInt(k.behaviors.size());

        let inferredGoal = avgBehavior * theoryOfMind;
        let inferredKnowledge = k.trustLevel * theoryOfMind;
        return (inferredGoal, inferredKnowledge);
      };
    };
    (0.5, 0.5)
  };

  // ── Episodic Memory ───────────────────────────────────────────
  // Store what-where-when event
  public func storeEpisode(
    memory: [EpisodicEvent], what: Nat, where_: Nat, when_: Nat,
    who: ?Nat, value: Float
  ) : [EpisodicEvent] {
    let newEvent : EpisodicEvent = {
      what = what;
      where = where_;
      when = when_;
      who = who;
      value = value;
    };

    // Keep most recent 50 episodes
    let updated = Array.append<EpisodicEvent>(memory, [newEvent]);
    if (updated.size() > 50) {
      Array.tabulate<EpisodicEvent>(50, func(i) { updated[i + updated.size() - 50] })
    } else { updated }
  };

  // Recall episodes matching criteria
  public func recallEpisodes(
    memory: [EpisodicEvent], what: ?Nat, where_: ?Nat
  ) : [EpisodicEvent] {
    Array.filter<EpisodicEvent>(memory, func(e) {
      let whatMatch = switch (what) {
        case (null) { true };
        case (?w) { e.what == w };
      };
      let whereMatch = switch (where_) {
        case (null) { true };
        case (?w) { e.where == w };
      };
      whatMatch and whereMatch
    })
  };

  // ── Insight ───────────────────────────────────────────────────
  // Sudden problem-solving insight (Aha! moment)
  public func checkInsight(
    state: CrowState, problemComplexity: Float
  ) : (Bool, Float) {
    // Insight more likely with:
    // - High working memory capacity
    // - Low attention (incubation)
    // - Relevant episodic memories

    let memoryLoad = Float.fromInt(state.workingMemory.size()) / 7.0;
    let incubation = 1.0 - state.attentionFocus;

    let insightChance = state.insightLevel *
                        (1.0 - memoryLoad * 0.3) *
                        (incubation * 0.5 + 0.5) *
                        (1.0 / (problemComplexity + 0.1));

    let triggered = insightChance > 0.7;
    (triggered, insightChance)
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatCrow(
    state: CrowState,
    sensorInput: Float,
    problemSignal: Float,
    socialSignal: Float
  ) : CrowState {
    // Update attention
    let newAttention = _clamp(
      0.7 * state.attentionFocus + 0.3 * (problemSignal + socialSignal) / 2.0,
      0.0, 1.0
    );

    // Update persistence
    let newPersistence = if (problemSignal > 0.5) {
      _clamp(state.persistenceLevel + 0.02, 0.0, 1.0)
    } else {
      _clamp(state.persistenceLevel - 0.01, 0.0, 1.0)
    };

    // Update insight potential (increases during incubation)
    let newInsight = if (newAttention < 0.3) {
      _clamp(state.insightLevel + 0.05, 0.0, 1.0)
    } else {
      _clamp(state.insightLevel - 0.02, 0.0, 1.0)
    };

    // Update theory of mind (improves with social interaction)
    let newToM = _clamp(
      state.theoryOfMind + socialSignal * 0.01,
      0.0, 1.0
    );

    // Update self-awareness
    let newSelfAware = _clamp(
      0.95 * state.selfAwareness + 0.05 * newToM,
      0.0, 1.0
    );

    // Update causal confidence
    let newCausalConf = _clamp(
      0.9 * state.causalConfidence + 0.1 * (1.0 - problemSignal),
      0.0, 1.0
    );

    // Update tool proficiency (decays without use)
    let newToolProf = _clamp(
      state.toolProficiency * 0.995,
      0.0, 1.0
    );

    {
      causalModels = state.causalModels;
      causalConfidence = newCausalConf;
      toolSolutions = state.toolSolutions;
      currentTool = state.currentTool;
      toolProficiency = newToolProf;
      currentPlan = state.currentPlan;
      planningDepth = state.planningDepth;
      futureDiscounting = state.futureDiscounting;
      socialKnowledge = state.socialKnowledge;
      selfAwareness = newSelfAware;
      theoryOfMind = newToM;
      workingMemory = state.workingMemory;
      attentionFocus = newAttention;
      episodicMemory = state.episodicMemory;
      insightLevel = newInsight;
      persistenceLevel = newPersistence;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initCrow() : CrowState {
    {
      causalModels = [];
      causalConfidence = 0.5;
      toolSolutions = [];
      currentTool = null;
      toolProficiency = 0.3;
      currentPlan = null;
      planningDepth = 6;
      futureDiscounting = 0.9;
      socialKnowledge = [];
      selfAwareness = 0.5;
      theoryOfMind = 0.4;
      workingMemory = [];
      attentionFocus = 0.5;
      episodicMemory = [];
      insightLevel = 0.3;
      persistenceLevel = 0.5;
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type CrowSummary = {
    causalConfidence  : Float;
    toolProficiency   : Float;
    theoryOfMind      : Float;
    selfAwareness     : Float;
    insightLevel      : Float;
    planningDepth     : Nat;
    episodicMemorySize: Nat;
  };

  public func summary(state: CrowState) : CrowSummary {
    {
      causalConfidence = state.causalConfidence;
      toolProficiency = state.toolProficiency;
      theoryOfMind = state.theoryOfMind;
      selfAwareness = state.selfAwareness;
      insightLevel = state.insightLevel;
      planningDepth = state.planningDepth;
      episodicMemorySize = state.episodicMemory.size();
    }
  };

}
