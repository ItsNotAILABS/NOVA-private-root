// ============================================================
// ANIMAL BRAIN ORCHESTRATOR — UNIFIED INTEGRATION
// Integrates all animal architectures with compounding growth
// Mathematical synthesis of 10+ biological systems
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

// Import all animal modules
import Octopus      "OctopusBrain";
import Crow         "CrowCognition";
import Dolphin      "DolphinEcholocation";
import Elephant     "ElephantMemory";
import Bee          "BeeSwarmIntelligence";
import Mantis       "MantisShrimp";
import Owl          "OwlAuditory";
import Compound     "CompoundLearning";

module {

  // ══════════════════════════════════════════════════════════════
  // SCIENTIFIC REFERENCES & MATHEMATICAL FOUNDATIONS
  // ══════════════════════════════════════════════════════════════
  //
  // OCTOPUS BRAIN (Hochner et al., 2006)
  //   - 500M neurons, 2/3 in arms
  //   - Distributed decision-making: D_total = Σ w_i × D_arm_i
  //   - Chromatophore control: sigmoid(neural_input)
  //
  // CROW COGNITION (Emery & Clayton, 2004)
  //   - Causal reasoning: P(effect|cause) via Bayesian inference
  //   - Theory of Mind: mental state attribution
  //   - Tool use: means-end analysis
  //
  // DOLPHIN ECHOLOCATION (Au, 1993)
  //   - Click rate: 700/s, frequency 20-130 kHz
  //   - Distance: d = c × t / 2
  //   - Target discrimination via frequency analysis
  //
  // ELEPHANT MEMORY (Byrne et al., 2009)
  //   - Hippocampal-dependent episodic memory
  //   - Infrasound: 5-20 Hz, range up to 10 km
  //   - Social network: O(100) individuals
  //
  // BEE SWARM (Seeley, 2010)
  //   - Waggle dance: distance ∝ duration
  //   - Quorum sensing: threshold-based consensus
  //   - Democratic decision-making
  //
  // MANTIS SHRIMP (Marshall et al., 2014)
  //   - 16 photoreceptor types (vs human 3)
  //   - Polarization vision: linear & circular
  //   - Strike: 23 m/s, 10,400g acceleration
  //
  // OWL AUDITORY (Konishi, 2003)
  //   - ITD resolution: ~10 microseconds
  //   - Asymmetric ears for elevation
  //   - 3D sound localization map
  //
  // ══════════════════════════════════════════════════════════════

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let NUM_ANIMAL_SYSTEMS : Nat = 7;

  // ── Types ─────────────────────────────────────────────────────
  
  // Individual animal system weights
  public type SystemWeights = {
    octopus  : Float;   // Distributed intelligence
    crow     : Float;   // Causal reasoning
    dolphin  : Float;   // Spatial sensing
    elephant : Float;   // Long-term memory
    bee      : Float;   // Collective decision
    mantis   : Float;   // Rapid response
    owl      : Float;   // Precision targeting
  };

  // Cross-system synergies
  public type SystemSynergies = {
    spatialMemory      : Float;  // Dolphin × Elephant
    collectiveCausal   : Float;  // Bee × Crow
    distributedSensing : Float;  // Octopus × Mantis
    precisionTracking  : Float;  // Owl × Dolphin
    socialIntelligence : Float;  // Elephant × Crow
    rapidDecision      : Float;  // Mantis × Bee
    adaptiveLearning   : Float;  // All systems
  };

  // Integrated organism state
  public type OrganismState = {
    // Individual animal systems
    octopusState  : Octopus.OctopusState;
    crowState     : Crow.CrowState;
    dolphinState  : Dolphin.DolphinState;
    elephantState : Elephant.ElephantState;
    beeState      : Bee.HiveState;
    mantisState   : Mantis.MantisState;
    owlState      : Owl.OwlState;

    // Compound learning engine
    compoundState : Compound.CompoundKnowledgeState;

    // System integration
    weights       : SystemWeights;
    synergies     : SystemSynergies;
    
    // Unified outputs
    coherence     : Float;      // Global system coherence
    adaptability  : Float;      // Ability to adapt
    intelligence  : Float;      // Integrated intelligence metric
    resilience    : Float;      // System resilience
    
    // Growth metrics
    growthRate    : Float;      // Current compound growth rate
    lifetimeGrowth: Float;      // Cumulative growth
    
    beatNum       : Nat;
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func exp(x: Float) : Float { Float.exp(x) };
  func ln(x: Float) : Float { Float.log(x) };
  func sqrt(x: Float) : Float { Float.sqrt(x) };

  // ══════════════════════════════════════════════════════════════
  // SYNERGY COMPUTATION
  // Cross-system synergies create emergent capabilities
  // ══════════════════════════════════════════════════════════════

  public func computeSynergies(state: OrganismState) : SystemSynergies {
    // Spatial Memory: Dolphin's spatial mapping + Elephant's long-term memory
    let spatialMemory = state.dolphinState.trackingQuality * 
                        state.elephantState.recallAccuracy;

    // Collective Causal: Bee's consensus + Crow's causal reasoning
    let collectiveCausal = state.beeState.consensusStrength * 
                           state.crowState.causalConfidence;

    // Distributed Sensing: Octopus's arm coordination + Mantis's hyperspectral
    let distributedSensing = state.octopusState.armSynchrony * 
                             state.mantisState.colorAnalysis;

    // Precision Tracking: Owl's 3D localization + Dolphin's target tracking
    let precisionTracking = state.owlState.snr * 
                           state.dolphinState.trackingQuality;

    // Social Intelligence: Elephant's social network + Crow's theory of mind
    let socialIntelligence = state.elephantState.herdCohesion * 
                             state.crowState.theoryOfMind;

    // Rapid Decision: Mantis's strike readiness + Bee's quorum speed
    let rapidDecision = state.mantisState.strikeSystem.strikeReady * 
                        state.beeState.danceFloorActivity;

    // Adaptive Learning: Weighted average of all adaptation signals
    let adaptiveLearning = (
      state.octopusState.explorationDrive +
      state.crowState.insightLevel +
      state.dolphinState.gainControl +
      state.elephantState.memoryConsolidation +
      state.mantisState.polarAnalysis +
      state.owlState.auditoryFocus +
      state.compoundState.metaState.curiosityDrive
    ) / 7.0;

    {
      spatialMemory = _clamp(spatialMemory, 0.0, 1.0);
      collectiveCausal = _clamp(collectiveCausal, 0.0, 1.0);
      distributedSensing = _clamp(distributedSensing, 0.0, 1.0);
      precisionTracking = _clamp(precisionTracking, 0.0, 1.0);
      socialIntelligence = _clamp(socialIntelligence, 0.0, 1.0);
      rapidDecision = _clamp(rapidDecision, 0.0, 1.0);
      adaptiveLearning = _clamp(adaptiveLearning, 0.0, 1.0);
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INTEGRATED INTELLIGENCE COMPUTATION
  // I = Σ w_i × capability_i × synergy_boost
  // ══════════════════════════════════════════════════════════════

  public func computeIntelligence(
    state: OrganismState,
    synergies: SystemSynergies
  ) : Float {
    // Extract capability scores from each system
    let octopusCap = state.octopusState.centralCoherence * 
                     state.octopusState.decisionConfidence;
    let crowCap = state.crowState.causalConfidence * 
                  state.crowState.theoryOfMind * 
                  state.crowState.insightLevel;
    let dolphinCap = state.dolphinState.trackingQuality * 
                     state.dolphinState.signalToNoise / 10.0;
    let elephantCap = state.elephantState.recallAccuracy * 
                      state.elephantState.memoryConsolidation;
    let beeCap = state.beeState.consensusStrength * 
                 (if (state.beeState.quorumReached) { 1.5 } else { 1.0 });
    let mantisCap = state.mantisState.visualField.stereopsis * 
                    state.mantisState.polarAnalysis;
    let owlCap = state.owlState.snr / 10.0 * 
                 (1.0 - state.owlState.noiseFloor);

    // Weighted sum with system weights
    let baseIntelligence = 
      state.weights.octopus * octopusCap +
      state.weights.crow * crowCap +
      state.weights.dolphin * dolphinCap +
      state.weights.elephant * elephantCap +
      state.weights.bee * beeCap +
      state.weights.mantis * mantisCap +
      state.weights.owl * owlCap;

    // Synergy multiplier
    let synergyAvg = (
      synergies.spatialMemory +
      synergies.collectiveCausal +
      synergies.distributedSensing +
      synergies.precisionTracking +
      synergies.socialIntelligence +
      synergies.rapidDecision +
      synergies.adaptiveLearning
    ) / 7.0;

    let synergyMultiplier = 1.0 + synergyAvg * 0.5;  // Up to 1.5x boost

    // Compound learning boost
    let compoundBoost = 1.0 + state.compoundState.totalKnowledge * 0.01;

    _clamp(baseIntelligence * synergyMultiplier * compoundBoost, S0, SOVEREIGN_CEILING)
  };

  // ══════════════════════════════════════════════════════════════
  // COHERENCE COMPUTATION
  // Global phase coherence across all systems
  // ══════════════════════════════════════════════════════════════

  public func computeCoherence(state: OrganismState) : Float {
    // Each system contributes a phase-like signal
    let phases : [Float] = [
      state.octopusState.centralCoherence,
      state.crowState.selfAwareness,
      state.dolphinState.trackingQuality,
      state.elephantState.herdCohesion,
      state.beeState.consensusStrength,
      state.mantisState.visualField.stereopsis,
      state.owlState.auditoryFocus
    ];

    // Kuramoto-style order parameter
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;

    for (p in phases.vals()) {
      // Convert coherence to phase angle
      let angle = p * 3.14159;
      sumCos += Float.cos(angle);
      sumSin += Float.sin(angle);
    };

    let r = sqrt(sumCos * sumCos + sumSin * sumSin) / 7.0;
    _clamp(r, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // GROWTH RATE COMPUTATION
  // How fast is the organism improving?
  // ══════════════════════════════════════════════════════════════

  public func computeGrowthRate(
    state: OrganismState,
    synergies: SystemSynergies
  ) : Float {
    // Base growth from compound learning
    let baseGrowth = state.compoundState.compoundRate;

    // Synergy boost
    let synergyBoost = synergies.adaptiveLearning * 0.5;

    // Antifragility boost
    let antifragBoost = (state.compoundState.antifragility - S0) * 0.1;

    // Meta-learning boost (faster learning = faster growth)
    let metaBoost = state.compoundState.metaState.learningRate * 10.0;

    _clamp(baseGrowth + synergyBoost + antifragBoost + metaBoost, 0.0, 0.1)
  };

  // ══════════════════════════════════════════════════════════════
  // ADAPTIVE WEIGHT ADJUSTMENT
  // Automatically adjust system weights based on performance
  // ══════════════════════════════════════════════════════════════

  public func adaptWeights(
    weights: SystemWeights,
    synergies: SystemSynergies,
    reward: Float
  ) : SystemWeights {
    // Increase weight of systems contributing to high synergy
    let learningRate = 0.01;

    let octopusDelta = synergies.distributedSensing * reward * learningRate;
    let crowDelta = (synergies.collectiveCausal + synergies.socialIntelligence) / 2.0 * reward * learningRate;
    let dolphinDelta = (synergies.spatialMemory + synergies.precisionTracking) / 2.0 * reward * learningRate;
    let elephantDelta = (synergies.spatialMemory + synergies.socialIntelligence) / 2.0 * reward * learningRate;
    let beeDelta = (synergies.collectiveCausal + synergies.rapidDecision) / 2.0 * reward * learningRate;
    let mantisDelta = (synergies.distributedSensing + synergies.rapidDecision) / 2.0 * reward * learningRate;
    let owlDelta = synergies.precisionTracking * reward * learningRate;

    // Normalize to sum to ~1
    let newOctopus = _clamp(weights.octopus + octopusDelta, 0.05, 0.3);
    let newCrow = _clamp(weights.crow + crowDelta, 0.05, 0.3);
    let newDolphin = _clamp(weights.dolphin + dolphinDelta, 0.05, 0.3);
    let newElephant = _clamp(weights.elephant + elephantDelta, 0.05, 0.3);
    let newBee = _clamp(weights.bee + beeDelta, 0.05, 0.3);
    let newMantis = _clamp(weights.mantis + mantisDelta, 0.05, 0.3);
    let newOwl = _clamp(weights.owl + owlDelta, 0.05, 0.3);

    let total = newOctopus + newCrow + newDolphin + newElephant + newBee + newMantis + newOwl;

    {
      octopus = newOctopus / total;
      crow = newCrow / total;
      dolphin = newDolphin / total;
      elephant = newElephant / total;
      bee = newBee / total;
      mantis = newMantis / total;
      owl = newOwl / total;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // FULL BEAT UPDATE — ORGANISM INTEGRATION
  // ══════════════════════════════════════════════════════════════

  public func beatOrganism(
    state: OrganismState,
    // Environmental inputs
    environmentSignal: Float,
    threatSignal: Float,
    rewardSignal: Float,
    // Sensory inputs
    visualInput: [Float],
    auditoryInput: Owl.AuditoryInput,
    spatialInput: Float
  ) : OrganismState {

    // 1. Update individual animal systems
    // (In production, each would receive appropriate inputs)
    
    let newOctopus = Octopus.beatOctopus(
      state.octopusState,
      Array.tabulate<Float>(8, func(_) { environmentSignal }),
      environmentSignal,
      threatSignal,
      [0.5, 0.5, 0.3]  // Background colors
    );

    let newCrow = Crow.beatCrow(
      state.crowState,
      environmentSignal,
      threatSignal,
      spatialInput
    );

    let newDolphin = Dolphin.beatDolphin(
      state.dolphinState,
      [],  // Would pass echo returns
      spatialInput * 180.0,
      0.0,
      threatSignal
    );

    let newElephant = Elephant.beatElephant(
      state.elephantState,
      128,  // Current position
      rewardSignal,
      threatSignal,
      null,  // Infrasound
      environmentSignal
    );

    let newBee = Bee.beatHive(
      state.beeState,
      [],  // Discoveries
      0.01  // Consumption
    );

    let newMantis = Mantis.beatMantis(
      state.mantisState,
      if (visualInput.size() >= 16) { 
        Array.tabulate<Float>(16, func(i) { visualInput[i] }) 
      } else { 
        Array.tabulate<Float>(16, func(_) { 0.0 }) 
      },
      if (visualInput.size() >= 16) { 
        Array.tabulate<Float>(16, func(i) { visualInput[i] }) 
      } else { 
        Array.tabulate<Float>(16, func(_) { 0.0 }) 
      },
      Array.tabulate<Float>(8, func(_) { 0.0 }),
      threatSignal
    );

    let newOwl = Owl.beatOwl(state.owlState, auditoryInput);

    // 2. Update compound learning with integrated signal
    let stressLevel = threatSignal;
    let newCompound = Compound.beatCompoundLearning(
      state.compoundState,
      rewardSignal,
      stressLevel,
      null  // Would pass new knowledge quanta
    );

    // 3. Compute synergies
    let tempState = {
      octopusState = newOctopus;
      crowState = newCrow;
      dolphinState = newDolphin;
      elephantState = newElephant;
      beeState = newBee;
      mantisState = newMantis;
      owlState = newOwl;
      compoundState = newCompound;
      weights = state.weights;
      synergies = state.synergies;
      coherence = state.coherence;
      adaptability = state.adaptability;
      intelligence = state.intelligence;
      resilience = state.resilience;
      growthRate = state.growthRate;
      lifetimeGrowth = state.lifetimeGrowth;
      beatNum = state.beatNum;
    };

    let newSynergies = computeSynergies(tempState);

    // 4. Compute global metrics
    let newCoherence = computeCoherence(tempState);
    let newIntelligence = computeIntelligence(tempState, newSynergies);
    let newGrowthRate = computeGrowthRate(tempState, newSynergies);

    // 5. Adapt weights
    let newWeights = adaptWeights(state.weights, newSynergies, rewardSignal);

    // 6. Compute resilience
    let newResilience = _clamp(
      0.9 * state.resilience + 0.1 * (newCompound.antifragility + newCoherence) / 2.0,
      S0, SOVEREIGN_CEILING
    );

    // 7. Compute adaptability
    let newAdaptability = _clamp(
      newSynergies.adaptiveLearning * newCompound.metaState.learningRate * 100.0,
      0.0, 1.0
    );

    // 8. Accumulate lifetime growth
    let newLifetimeGrowth = state.lifetimeGrowth * (1.0 + newGrowthRate) + newGrowthRate;

    {
      octopusState = newOctopus;
      crowState = newCrow;
      dolphinState = newDolphin;
      elephantState = newElephant;
      beeState = newBee;
      mantisState = newMantis;
      owlState = newOwl;
      compoundState = newCompound;
      weights = newWeights;
      synergies = newSynergies;
      coherence = newCoherence;
      adaptability = newAdaptability;
      intelligence = newIntelligence;
      resilience = newResilience;
      growthRate = newGrowthRate;
      lifetimeGrowth = newLifetimeGrowth;
      beatNum = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initOrganism() : OrganismState {
    {
      octopusState = Octopus.initOctopus();
      crowState = Crow.initCrow();
      dolphinState = Dolphin.initDolphin();
      elephantState = Elephant.initElephant();
      beeState = Bee.initHive();
      mantisState = Mantis.initMantis();
      owlState = Owl.initOwl();
      compoundState = Compound.initCompoundLearning();
      weights = {
        octopus = 0.143;
        crow = 0.143;
        dolphin = 0.143;
        elephant = 0.143;
        bee = 0.143;
        mantis = 0.143;
        owl = 0.143;
      };
      synergies = {
        spatialMemory = 0.0;
        collectiveCausal = 0.0;
        distributedSensing = 0.0;
        precisionTracking = 0.0;
        socialIntelligence = 0.0;
        rapidDecision = 0.0;
        adaptiveLearning = 0.0;
      };
      coherence = S0;
      adaptability = 0.5;
      intelligence = S0;
      resilience = S0;
      growthRate = 0.001;
      lifetimeGrowth = 0.0;
      beatNum = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type OrganismSummary = {
    // Core metrics
    coherence        : Float;
    intelligence     : Float;
    resilience       : Float;
    adaptability     : Float;
    
    // Growth
    growthRate       : Float;
    lifetimeGrowth   : Float;
    compoundPrincipal: Float;
    
    // Synergies
    topSynergy       : Float;
    synergyCount     : Nat;  // How many synergies > 0.5
    
    // System health
    systemsOnline    : Nat;
    
    beatNum          : Nat;
  };

  public func summary(state: OrganismState) : OrganismSummary {
    // Count active synergies
    var synergyCount : Nat = 0;
    var topSynergy : Float = 0.0;
    
    let synergies = [
      state.synergies.spatialMemory,
      state.synergies.collectiveCausal,
      state.synergies.distributedSensing,
      state.synergies.precisionTracking,
      state.synergies.socialIntelligence,
      state.synergies.rapidDecision,
      state.synergies.adaptiveLearning
    ];
    
    for (s in synergies.vals()) {
      if (s > 0.5) { synergyCount += 1 };
      if (s > topSynergy) { topSynergy := s };
    };

    {
      coherence = state.coherence;
      intelligence = state.intelligence;
      resilience = state.resilience;
      adaptability = state.adaptability;
      growthRate = state.growthRate;
      lifetimeGrowth = state.lifetimeGrowth;
      compoundPrincipal = state.compoundState.compoundPrincipal;
      topSynergy = topSynergy;
      synergyCount = synergyCount;
      systemsOnline = 7;  // All 7 animal systems
      beatNum = state.beatNum;
    }
  };

}
