// ============================================================
// COMPOUND LEARNING ENGINE — ENTERPRISE MATHEMATICS
// Integrates all animal brain architectures with compounding knowledge
// Mathematical foundations: Bellman equations, TD-learning, meta-plasticity
// References: Sutton & Barto (1998), Schmidhuber (1987), Doya (2002)
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ══════════════════════════════════════════════════════════════
  // MATHEMATICAL FOUNDATIONS — ENTERPRISE GRADE
  // ══════════════════════════════════════════════════════════════
  //
  // 1. BELLMAN OPTIMALITY (Richard Bellman, 1957)
  //    V*(s) = max_a [R(s,a) + γ Σ P(s'|s,a) V*(s')]
  //    Q*(s,a) = R(s,a) + γ Σ P(s'|s,a) max_a' Q*(s',a')
  //
  // 2. TEMPORAL DIFFERENCE LEARNING (Sutton, 1988)
  //    δ = r + γV(s') - V(s)  [TD error]
  //    V(s) ← V(s) + α·δ
  //
  // 3. META-LEARNING (Schmidhuber, 1987; Finn et al., 2017)
  //    θ ← θ - α ∇_θ L(f_θ)  [inner loop]
  //    φ ← φ - β ∇_φ Σ L(f_{θ_i})  [outer loop]
  //
  // 4. COMPOUND INTEREST ON KNOWLEDGE (Novel)
  //    K(t+1) = K(t) × (1 + r_learn)^Δt + ΔK_new
  //    r_learn = f(coherence, diversity, consolidation)
  //
  // 5. ANTIFRAGILITY ACCUMULATION (Taleb, 2012, formalized)
  //    A(t) = A(t-1) + β·(stress - threshold)⁺·recovery_signal
  //
  // ══════════════════════════════════════════════════════════════

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let EULER : Float = 2.71828182845904523536;
  let PHI : Float = 1.61803398874989484820;  // Golden ratio

  // Learning rate bounds (enterprise stability)
  let ALPHA_MIN : Float = 0.0001;
  let ALPHA_MAX : Float = 0.1;
  let GAMMA_DISCOUNT : Float = 0.99;  // Future value discount

  // ── Types ─────────────────────────────────────────────────────
  
  // Knowledge quantum - smallest unit of learned information
  public type KnowledgeQuantum = {
    domain       : KnowledgeDomain;
    strength     : Float;         // 0-1 consolidation
    timestamp    : Nat;           // When acquired
    accessCount  : Nat;           // Retrieval frequency
    connections  : [Nat];         // Links to other quanta
    decayRate    : Float;         // Forgetting rate
    compoundRate : Float;         // Growth rate from use
  };

  public type KnowledgeDomain = {
    #Spatial;        // Navigation, mapping
    #Temporal;       // Timing, sequences
    #Social;         // Agent modeling
    #Causal;         // Cause-effect
    #Motor;          // Movement patterns
    #Sensory;        // Perceptual patterns
    #Linguistic;     // Communication patterns
    #Abstract;       // High-level concepts
  };

  // Meta-learning state - learning how to learn
  public type MetaLearningState = {
    learningRate     : Float;       // Current α
    momentum         : Float;       // Gradient momentum
    adaptiveScale    : Float;       // Adam-style scaling
    explorationRate  : Float;       // ε for exploration
    curiosityDrive   : Float;       // Intrinsic motivation
    competenceLevel  : Float;       // Self-assessed ability
    
    // Learning rate adaptation (per domain)
    domainRates      : [Float];     // 8 domain-specific rates
    
    // Meta-gradient accumulators
    gradientHistory  : [Float];     // Recent gradient magnitudes
    lossHistory      : [Float];     // Recent loss values
  };

  // Compound knowledge state
  public type CompoundKnowledgeState = {
    // Core knowledge store
    knowledgeBase    : [KnowledgeQuantum];
    totalKnowledge   : Float;       // Integrated knowledge metric
    
    // Compounding mechanics
    compoundPrincipal: Float;       // Base knowledge "principal"
    compoundRate     : Float;       // Current compound rate r
    compoundPeriods  : Nat;         // Number of compounding events
    
    // Domain-specific knowledge levels
    domainLevels     : [Float];     // 8 domains
    domainGrowth     : [Float];     // Growth rates per domain
    
    // Cross-domain transfer
    transferMatrix   : [Float];     // 8×8 transfer coefficients
    synergyScore     : Float;       // Multi-domain synergy
    
    // Meta-learning
    metaState        : MetaLearningState;
    
    // Temporal dynamics
    consolidationPhase: Float;      // Sleep/wake cycle position
    replayBuffer     : [Nat];       // Experience replay indices
    
    // Antifragility
    stressHistory    : [Float];     // Recent stress levels
    recoveryHistory  : [Float];     // Recovery signals
    antifragility    : Float;       // Accumulated antifragility
    
    beatNum          : Nat;
  };

  // TD-Learning signal
  public type TDSignal = {
    tdError          : Float;       // δ = r + γV(s') - V(s)
    reward           : Float;       // Immediate reward r
    valueEstimate    : Float;       // V(s)
    nextValueEstimate: Float;       // V(s')
    eligibilityTrace : Float;       // e(s) for TD(λ)
  };

  // Enterprise audit trail
  public type LearningEvent = {
    eventType   : LearningEventType;
    timestamp   : Nat;
    magnitude   : Float;
    domain      : KnowledgeDomain;
    success     : Bool;
  };

  public type LearningEventType = {
    #Acquisition;     // New knowledge
    #Consolidation;   // Strengthening
    #Transfer;        // Cross-domain
    #Compounding;     // Interest accrual
    #Forgetting;      // Decay
    #Antifragile;     // Stress-induced growth
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func exp(x: Float) : Float { Float.exp(x) };
  func ln(x: Float) : Float { Float.log(x) };
  func sqrt(x: Float) : Float { Float.sqrt(x) };
  func pow(base: Float, exp_: Float) : Float { Float.pow(base, exp_) };
  func abs(x: Float) : Float { if (x < 0.0) { -x } else { x } };

  // ══════════════════════════════════════════════════════════════
  // BELLMAN EQUATION IMPLEMENTATION
  // V*(s) = max_a [R(s,a) + γ Σ P(s'|s,a) V*(s')]
  // ══════════════════════════════════════════════════════════════

  public func bellmanUpdate(
    currentValue: Float,
    reward: Float,
    nextValue: Float,
    gamma: Float,
    alpha: Float
  ) : Float {
    // V(s) ← V(s) + α[r + γV(s') - V(s)]
    let tdError = reward + gamma * nextValue - currentValue;
    _clamp(currentValue + alpha * tdError, 0.0, SOVEREIGN_CEILING)
  };

  // Q-learning update (off-policy)
  public func qLearningUpdate(
    qValue: Float,
    reward: Float,
    maxNextQ: Float,
    gamma: Float,
    alpha: Float
  ) : Float {
    // Q(s,a) ← Q(s,a) + α[r + γ max_a' Q(s',a') - Q(s,a)]
    let tdError = reward + gamma * maxNextQ - qValue;
    _clamp(qValue + alpha * tdError, 0.0, SOVEREIGN_CEILING)
  };

  // ══════════════════════════════════════════════════════════════
  // TEMPORAL DIFFERENCE LEARNING
  // δ_t = r_{t+1} + γV(s_{t+1}) - V(s_t)
  // ══════════════════════════════════════════════════════════════

  public func computeTDError(
    reward: Float,
    currentValue: Float,
    nextValue: Float,
    gamma: Float
  ) : TDSignal {
    let delta = reward + gamma * nextValue - currentValue;
    {
      tdError = delta;
      reward = reward;
      valueEstimate = currentValue;
      nextValueEstimate = nextValue;
      eligibilityTrace = 1.0;  // Immediate state
    }
  };

  // TD(λ) with eligibility traces
  public func tdLambdaUpdate(
    values: [Float],
    tdSignal: TDSignal,
    lambda: Float,
    alpha: Float
  ) : [Float] {
    // Update all states proportional to eligibility
    Array.tabulate<Float>(values.size(), func(i) {
      let eligibility = pow(lambda * GAMMA_DISCOUNT, Float.fromInt(values.size() - 1 - i));
      _clamp(
        values[i] + alpha * tdSignal.tdError * eligibility,
        0.0, SOVEREIGN_CEILING
      )
    })
  };

  // ══════════════════════════════════════════════════════════════
  // COMPOUND LEARNING MATHEMATICS
  // K(t+1) = K(t) × (1 + r)^n + ΔK
  // ══════════════════════════════════════════════════════════════

  // Calculate compound growth
  public func compoundKnowledge(
    principal: Float,
    rate: Float,
    periods: Nat
  ) : Float {
    // A = P(1 + r)^n
    principal * pow(1.0 + rate, Float.fromInt(periods))
  };

  // Continuous compounding (more mathematically elegant)
  public func continuousCompound(
    principal: Float,
    rate: Float,
    time: Float
  ) : Float {
    // A = P × e^(rt)
    principal * exp(rate * time)
  };

  // Calculate effective compound rate based on learning quality
  public func calculateCompoundRate(
    coherence: Float,      // System coherence (Kuramoto r)
    diversity: Float,      // Knowledge diversity
    consolidation: Float,  // Memory consolidation level
    retrieval: Float       // Access frequency
  ) : Float {
    // r = base_rate × coherence × diversity_bonus × consolidation × retrieval_boost
    let baseRate = 0.001;  // 0.1% base compound rate per beat
    
    let coherenceMultiplier = 1.0 + coherence * 0.5;  // Up to 1.5x
    let diversityBonus = 1.0 + diversity * 0.3;       // Up to 1.3x
    let consolidationMultiplier = 0.5 + consolidation * 0.5;  // 0.5x to 1.0x
    let retrievalBoost = 1.0 + ln(retrieval + 1.0) * 0.1;  // Log boost
    
    let rate = baseRate * coherenceMultiplier * diversityBonus * 
               consolidationMultiplier * retrievalBoost;
    
    _clamp(rate, 0.0, 0.01)  // Cap at 1% per beat
  };

  // ══════════════════════════════════════════════════════════════
  // META-LEARNING: LEARNING TO LEARN
  // Adapts learning rate based on performance
  // ══════════════════════════════════════════════════════════════

  public func adaptLearningRate(
    meta: MetaLearningState,
    recentLoss: Float,
    gradientMagnitude: Float
  ) : MetaLearningState {
    // Adam-style adaptive learning rate
    // m_t = β₁ m_{t-1} + (1-β₁) g_t
    // v_t = β₂ v_{t-1} + (1-β₂) g_t²
    // α_t = α × sqrt(1-β₂^t) / (1-β₁^t)
    
    let beta1 = 0.9;
    let beta2 = 0.999;
    let epsilon = 1e-8;
    
    // Update momentum
    let newMomentum = beta1 * meta.momentum + (1.0 - beta1) * gradientMagnitude;
    
    // Update adaptive scale (second moment)
    let newScale = beta2 * meta.adaptiveScale + 
                   (1.0 - beta2) * gradientMagnitude * gradientMagnitude;
    
    // Compute adaptive learning rate
    let adaptedAlpha = meta.learningRate / (sqrt(newScale) + epsilon);
    let clampedAlpha = _clamp(adaptedAlpha, ALPHA_MIN, ALPHA_MAX);
    
    // Adjust exploration based on loss trend
    let avgLoss = if (meta.lossHistory.size() > 0) {
      var sum : Float = 0.0;
      for (l in meta.lossHistory.vals()) { sum += l };
      sum / Float.fromInt(meta.lossHistory.size())
    } else { recentLoss };
    
    let lossTrend = recentLoss - avgLoss;
    let newExploration = if (lossTrend > 0.0) {
      // Getting worse: increase exploration
      _clamp(meta.explorationRate + 0.01, 0.0, 0.3)
    } else {
      // Improving: decrease exploration
      _clamp(meta.explorationRate - 0.005, 0.05, 0.3)
    };
    
    // Update curiosity (intrinsic motivation)
    let newCuriosity = _clamp(
      meta.curiosityDrive * 0.99 + gradientMagnitude * 0.1,
      0.0, 1.0
    );
    
    // Update loss history
    let newLossHistory = if (meta.lossHistory.size() >= 100) {
      Array.tabulate<Float>(99, func(i) { meta.lossHistory[i + 1] })
    } else { meta.lossHistory };
    let finalLossHistory = Array.append<Float>(newLossHistory, [recentLoss]);
    
    {
      learningRate = clampedAlpha;
      momentum = newMomentum;
      adaptiveScale = newScale;
      explorationRate = newExploration;
      curiosityDrive = newCuriosity;
      competenceLevel = meta.competenceLevel;
      domainRates = meta.domainRates;
      gradientHistory = meta.gradientHistory;
      lossHistory = finalLossHistory;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // KNOWLEDGE CONSOLIDATION (Sleep-like)
  // Strengthens important memories, prunes weak ones
  // ══════════════════════════════════════════════════════════════

  public func consolidateKnowledge(
    quanta: [KnowledgeQuantum],
    consolidationStrength: Float,
    currentBeat: Nat
  ) : [KnowledgeQuantum] {
    Array.map<KnowledgeQuantum, KnowledgeQuantum>(quanta, func(q) {
      // Recency effect
      let age = currentBeat - q.timestamp;
      let recencyBonus = exp(-Float.fromInt(age) * 0.0001);
      
      // Frequency effect (power law)
      let frequencyBonus = ln(Float.fromInt(q.accessCount + 1)) * 0.1;
      
      // Connection strength (Hebbian)
      let connectionBonus = Float.fromInt(q.connections.size()) * 0.02;
      
      // Total consolidation delta
      let delta = consolidationStrength * 
                  (recencyBonus + frequencyBonus + connectionBonus);
      
      // Decay
      let decay = q.decayRate * (1.0 - consolidationStrength);
      
      {
        domain = q.domain;
        strength = _clamp(q.strength + delta - decay, 0.0, 1.0);
        timestamp = q.timestamp;
        accessCount = q.accessCount;
        connections = q.connections;
        decayRate = q.decayRate * 0.999;  // Decay slows over time
        compoundRate = q.compoundRate + delta * 0.01;  // Compound rate grows
      }
    })
  };

  // ══════════════════════════════════════════════════════════════
  // CROSS-DOMAIN TRANSFER LEARNING
  // Knowledge in one domain accelerates learning in others
  // ══════════════════════════════════════════════════════════════

  public func computeTransfer(
    sourceDomain: Nat,
    targetDomain: Nat,
    transferMatrix: [Float],
    sourceStrength: Float
  ) : Float {
    // Transfer coefficient from matrix
    let idx = sourceDomain * 8 + targetDomain;
    let coefficient = if (idx < transferMatrix.size()) { 
      transferMatrix[idx] 
    } else { 0.1 };
    
    // Transfer amount (diminishing returns)
    sourceStrength * coefficient * 0.3
  };

  // Update transfer matrix based on observed transfers
  public func updateTransferMatrix(
    matrix: [Float],
    sourceDomain: Nat,
    targetDomain: Nat,
    success: Bool
  ) : [Float] {
    Array.tabulate<Float>(64, func(i) {
      if (i == sourceDomain * 8 + targetDomain) {
        let delta = if (success) { 0.01 } else { -0.005 };
        _clamp(matrix[i] + delta, 0.0, 1.0)
      } else { matrix[i] }
    })
  };

  // ══════════════════════════════════════════════════════════════
  // ANTIFRAGILITY MATHEMATICS
  // A(t) = A(t-1) + β(stress - θ)⁺ × recovery
  // ══════════════════════════════════════════════════════════════

  public func computeAntifragility(
    currentAntifragility: Float,
    stress: Float,
    recovery: Float,
    threshold: Float
  ) : Float {
    // Only positive stress above threshold contributes
    let effectiveStress = if (stress > threshold) { stress - threshold } else { 0.0 };
    
    // Growth proportional to stress × recovery
    let growth = 0.1 * effectiveStress * recovery;
    
    // Small decay to prevent runaway
    let decay = 0.001 * currentAntifragility;
    
    _clamp(currentAntifragility + growth - decay, S0, SOVEREIGN_CEILING)
  };

  // ══════════════════════════════════════════════════════════════
  // SYNERGY COMPUTATION
  // Multi-domain synergy creates superlinear returns
  // ══════════════════════════════════════════════════════════════

  public func computeSynergy(domainLevels: [Float]) : Float {
    // Synergy = product / (sum / n)^n
    // High when domains are balanced and all strong
    
    var product : Float = 1.0;
    var sum : Float = 0.0;
    let n = Float.fromInt(domainLevels.size());
    
    for (level in domainLevels.vals()) {
      product *= (level + 0.1);  // Avoid zero
      sum += level;
    };
    
    let mean = sum / n;
    let baseline = pow(mean + 0.1, n);
    
    if (baseline > 0.0) {
      _clamp(product / baseline, 0.0, 3.0)  // Up to 3x synergy
    } else { 1.0 }
  };

  // ══════════════════════════════════════════════════════════════
  // FULL BEAT UPDATE — COMPOUND LEARNING ENGINE
  // ══════════════════════════════════════════════════════════════

  public func beatCompoundLearning(
    state: CompoundKnowledgeState,
    reward: Float,
    stressLevel: Float,
    newExperience: ?KnowledgeQuantum
  ) : CompoundKnowledgeState {
    
    // 1. Update consolidation phase (circadian-like)
    let newConsolidationPhase = (state.consolidationPhase + 0.001) % 1.0;
    let isConsolidating = newConsolidationPhase > 0.7;  // 30% of time
    
    // 2. Consolidate existing knowledge if in consolidation phase
    let consolidatedKnowledge = if (isConsolidating) {
      consolidateKnowledge(state.knowledgeBase, 0.1, state.beatNum + 1)
    } else { state.knowledgeBase };
    
    // 3. Add new experience if present
    let updatedKnowledge = switch (newExperience) {
      case (null) { consolidatedKnowledge };
      case (?exp) { Array.append<KnowledgeQuantum>(consolidatedKnowledge, [exp]) };
    };
    
    // 4. Prune weak knowledge (keep top N)
    let prunedKnowledge = if (updatedKnowledge.size() > 10000) {
      // Would implement proper pruning - keep strongest
      Array.tabulate<KnowledgeQuantum>(
        Nat.min(10000, updatedKnowledge.size()),
        func(i) { updatedKnowledge[i] }
      )
    } else { updatedKnowledge };
    
    // 5. Update domain levels
    var newDomainLevels = Array.thaw<Float>(state.domainLevels);
    for (q in prunedKnowledge.vals()) {
      let domainIdx = switch (q.domain) {
        case (#Spatial) { 0 };
        case (#Temporal) { 1 };
        case (#Social) { 2 };
        case (#Causal) { 3 };
        case (#Motor) { 4 };
        case (#Sensory) { 5 };
        case (#Linguistic) { 6 };
        case (#Abstract) { 7 };
      };
      if (domainIdx < 8) {
        newDomainLevels[domainIdx] := _clamp(
          newDomainLevels[domainIdx] + q.strength * 0.001,
          0.0, SOVEREIGN_CEILING
        );
      };
    };
    
    // 6. Compute synergy
    let domainLevelsFrozen = Array.freeze(newDomainLevels);
    let newSynergy = computeSynergy(domainLevelsFrozen);
    
    // 7. Calculate compound rate
    let diversity = computeDiversity(domainLevelsFrozen);
    let newCompoundRate = calculateCompoundRate(
      newSynergy,
      diversity,
      if (isConsolidating) { 0.8 } else { 0.3 },
      Float.fromInt(prunedKnowledge.size()) / 1000.0
    );
    
    // 8. Apply compounding to principal
    let newPrincipal = compoundKnowledge(
      state.compoundPrincipal,
      newCompoundRate,
      1  // One period
    );
    
    // 9. Update total knowledge
    var totalK : Float = 0.0;
    for (q in prunedKnowledge.vals()) { totalK += q.strength };
    let newTotalKnowledge = totalK + newPrincipal * 0.1;
    
    // 10. Compute TD error and adapt meta-learning
    let tdSignal = computeTDError(reward, state.totalKnowledge, newTotalKnowledge, GAMMA_DISCOUNT);
    let newMetaState = adaptLearningRate(state.metaState, abs(tdSignal.tdError), abs(tdSignal.tdError));
    
    // 11. Update antifragility
    let recoverySignal = if (stressLevel < 0.5 and state.stressHistory.size() > 0) {
      let lastStress = state.stressHistory[state.stressHistory.size() - 1];
      if (lastStress > 0.7) { 1.0 } else { 0.5 }
    } else { 0.2 };
    
    let newAntifragility = computeAntifragility(
      state.antifragility,
      stressLevel,
      recoverySignal,
      0.6  // Stress threshold
    );
    
    // 12. Update stress history
    let newStressHistory = if (state.stressHistory.size() >= 100) {
      Array.tabulate<Float>(99, func(i) { state.stressHistory[i + 1] })
    } else { state.stressHistory };
    let finalStressHistory = Array.append<Float>(newStressHistory, [stressLevel]);
    
    {
      knowledgeBase = prunedKnowledge;
      totalKnowledge = newTotalKnowledge;
      compoundPrincipal = newPrincipal;
      compoundRate = newCompoundRate;
      compoundPeriods = state.compoundPeriods + 1;
      domainLevels = domainLevelsFrozen;
      domainGrowth = state.domainGrowth;
      transferMatrix = state.transferMatrix;
      synergyScore = newSynergy;
      metaState = newMetaState;
      consolidationPhase = newConsolidationPhase;
      replayBuffer = state.replayBuffer;
      stressHistory = finalStressHistory;
      recoveryHistory = state.recoveryHistory;
      antifragility = newAntifragility;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Helper: Compute diversity ─────────────────────────────────
  func computeDiversity(levels: [Float]) : Float {
    // Shannon entropy of domain distribution
    var total : Float = 0.0;
    for (l in levels.vals()) { total += l };
    
    if (total < 0.01) { return 0.0 };
    
    var entropy : Float = 0.0;
    for (l in levels.vals()) {
      let p = l / total;
      if (p > 0.001) {
        entropy -= p * ln(p);
      };
    };
    
    // Normalize by max entropy (ln(8))
    _clamp(entropy / 2.079, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initCompoundLearning() : CompoundKnowledgeState {
    {
      knowledgeBase = [];
      totalKnowledge = S0;
      compoundPrincipal = 1.0;
      compoundRate = 0.001;
      compoundPeriods = 0;
      domainLevels = Array.tabulate<Float>(8, func(_) { S0 });
      domainGrowth = Array.tabulate<Float>(8, func(_) { 0.001 });
      transferMatrix = Array.tabulate<Float>(64, func(i) {
        let row = i / 8;
        let col = i % 8;
        if (row == col) { 1.0 }  // Self-transfer is 1.0
        else { 0.1 }  // Default cross-transfer
      });
      synergyScore = 1.0;
      metaState = {
        learningRate = 0.01;
        momentum = 0.0;
        adaptiveScale = 1.0;
        explorationRate = 0.1;
        curiosityDrive = 0.5;
        competenceLevel = 0.0;
        domainRates = Array.tabulate<Float>(8, func(_) { 0.01 });
        gradientHistory = [];
        lossHistory = [];
      };
      consolidationPhase = 0.0;
      replayBuffer = [];
      stressHistory = [];
      recoveryHistory = [];
      antifragility = S0;
      beatNum = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY & METRICS
  // ══════════════════════════════════════════════════════════════

  public type CompoundLearningSummary = {
    totalKnowledge     : Float;
    compoundPrincipal  : Float;
    compoundRate       : Float;
    compoundPeriods    : Nat;
    synergyScore       : Float;
    antifragility      : Float;
    learningRate       : Float;
    diversityIndex     : Float;
    knowledgeCount     : Nat;
  };

  public func summary(state: CompoundKnowledgeState) : CompoundLearningSummary {
    {
      totalKnowledge = state.totalKnowledge;
      compoundPrincipal = state.compoundPrincipal;
      compoundRate = state.compoundRate;
      compoundPeriods = state.compoundPeriods;
      synergyScore = state.synergyScore;
      antifragility = state.antifragility;
      learningRate = state.metaState.learningRate;
      diversityIndex = computeDiversity(state.domainLevels);
      knowledgeCount = state.knowledgeBase.size();
    }
  };

}
