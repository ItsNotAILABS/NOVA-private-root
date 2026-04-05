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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ════════════════════════════════════════════════════════════════════════════════════════
// ████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                    ██
// ██  COGNITIVE MEMORY SYSTEMS — REAL BACKEND INTELLIGENCE                             ██
// ██                                                                                    ██
// ██  Implements 3 types of memory (from cognitive neuroscience):                      ██
// ██                                                                                    ██
// ██  1. EPISODIC MEMORY — "What happened" (events, trades, experiences)               ██
// ██     - Autobiographical memory of past events                                       ██
// ██     - Pattern matching for similar situations                                      ██
// ██     - Emotional tagging for significance                                           ██
// ██                                                                                    ██
// ██  2. SEMANTIC MEMORY — "What I know" (facts, relationships, models)                ██
// ██     - Knowledge graph of market facts                                              ██
// ██     - Correlation relationships                                                    ██
// ██     - Causal models                                                                ██
// ██                                                                                    ██
// ██  3. PROCEDURAL MEMORY — "How to do things" (skills, strategies)                   ██
// ██     - Trading strategies with performance history                                  ██
// ██     - Parameter optimization                                                       ██
// ██     - Skill acquisition curves                                                     ██
// ██                                                                                    ██
// ████████████████████████████████████████████████████████████████████████████████████████
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Hash  "mo:base/Hash";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════
  
  let PHI : Float = 1.6180339887498948;
  let PHI_INV : Float = 0.6180339887498948;
  
  // Memory capacity constants
  let EPISODIC_CAPACITY : Nat = 10000;        // Max episodic memories
  let SEMANTIC_CAPACITY : Nat = 5000;         // Max semantic facts
  let PROCEDURAL_CAPACITY : Nat = 100;        // Max procedures/skills
  
  // Memory decay constants (Ebbinghaus forgetting curve)
  let FORGETTING_RATE : Float = 0.1;          // Base forgetting rate
  let REHEARSAL_BOOST : Float = 1.5;          // Strength boost from rehearsal
  let EMOTIONAL_BOOST : Float = 2.0;          // Memories with high emotion decay slower
  
  // Similarity threshold for pattern matching
  let SIMILARITY_THRESHOLD : Float = 0.7;

  // ══════════════════════════════════════════════════════════════════════════
  // 1. EPISODIC MEMORY — "What Happened"
  // ══════════════════════════════════════════════════════════════════════════

  public type Episode = {
    episodeId : Nat;
    timestamp : Nat;                   // Beat when this occurred
    
    // Context
    marketState : MarketContext;
    organismState : OrganismContext;
    
    // Event details
    eventType : EventType;
    eventData : EventData;
    
    // Outcome
    outcome : Outcome;
    
    // Memory metadata
    emotionalValence : Float;          // [-1, 1] negative to positive
    emotionalArousal : Float;          // [0, 1] calm to excited
    significance : Float;              // [0, 1] how important
    strength : Float;                  // [0, 1] memory strength (decays)
    rehearsalCount : Nat;              // Times remembered
    lastAccess : Nat;                  // Last retrieval beat
    
    // Pattern features (for similarity matching)
    featureVector : [Float];
  };

  public type MarketContext = {
    symbol : Text;
    price : Float;
    trend : Float;                     // [-1, 1] bearish to bullish
    volatility : Float;
    volume : Float;
    regime : Text;                     // "Trending", "MeanReverting", etc.
  };

  public type OrganismContext = {
    coherence : Float;
    fearLevel : Float;
    greedLevel : Float;
    disciplineLevel : Float;
    capital : Float;
    openPositions : Nat;
  };

  public type EventType = {
    #TradeEntry;
    #TradeExit;
    #SignalGenerated;
    #RiskAlert;
    #ProfitTaken;
    #LossTaken;
    #MarketShock;
    #RegimeChange;
    #CoherenceSpike;
    #CoherenceDrop;
  };

  public type EventData = {
    description : Text;
    values : [Float];                  // Numerical data
    labels : [Text];                   // Categorical data
  };

  public type Outcome = {
    success : Bool;
    profitLoss : Float;                // USD P&L
    profitLossPercent : Float;         // Percentage
    lessonLearned : Text;
    correctPrediction : Bool;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 2. SEMANTIC MEMORY — "What I Know"
  // ══════════════════════════════════════════════════════════════════════════

  public type SemanticFact = {
    factId : Nat;
    category : FactCategory;
    
    // The fact itself
    subject : Text;
    predicate : Text;
    object : Text;
    
    // Confidence and provenance
    confidence : Float;                // [0, 1]
    evidenceCount : Nat;               // Supporting observations
    contradictionCount : Nat;          // Contradicting observations
    lastUpdated : Nat;
    
    // Relationships
    relatedFacts : [Nat];              // IDs of related facts
    causedBy : [Nat];                  // Facts that cause this
    causes : [Nat];                    // Facts this causes
    
    // Usage statistics
    accessCount : Nat;
    usefulness : Float;                // How often this fact led to good decisions
  };

  public type FactCategory = {
    #MarketBehavior;                   // "BTC tends to rally in January"
    #Correlation;                      // "BTC and ETH are correlated at 0.8"
    #Causation;                        // "Fed rate hikes cause BTC drops"
    #TradingRule;                      // "Don't trade during low volume"
    #RiskFact;                         // "Max drawdown for BTC is 80%"
    #ProtocolKnowledge;                // "Uniswap V3 has concentrated liquidity"
  };

  public type Correlation = {
    asset1 : Text;
    asset2 : Text;
    correlation : Float;               // [-1, 1]
    timeframe : Text;                  // "1D", "1W", etc.
    sampleSize : Nat;
    lastUpdated : Nat;
  };

  public type CausalModel = {
    cause : Text;
    effect : Text;
    strength : Float;                  // [0, 1]
    lag : Nat;                         // Beats between cause and effect
    confidence : Float;
    observations : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // 3. PROCEDURAL MEMORY — "How To Do Things"
  // ══════════════════════════════════════════════════════════════════════════

  public type Procedure = {
    procedureId : Nat;
    name : Text;
    category : ProcedureCategory;
    
    // The procedure itself
    steps : [ProcedureStep];
    parameters : [ProcedureParameter];
    
    // Performance tracking
    executionCount : Nat;
    successCount : Nat;
    successRate : Float;
    avgReturn : Float;
    sharpeRatio : Float;
    maxDrawdown : Float;
    
    // Learning
    skillLevel : Float;                // [0, 1] mastery level
    learningCurve : [Float];           // Success rate over time
    lastExecution : Nat;
    
    // Conditions
    applicableRegimes : [Text];
    requiredCoherence : Float;
    requiredConfidence : Float;
  };

  public type ProcedureCategory = {
    #TradingStrategy;
    #RiskManagement;
    #PositionSizing;
    #EntryTiming;
    #ExitTiming;
    #Rebalancing;
    #Hedging;
  };

  public type ProcedureStep = {
    stepNumber : Nat;
    action : Text;
    condition : ?Text;                 // Optional condition
    parameters : [Text];               // Parameter names used
  };

  public type ProcedureParameter = {
    name : Text;
    currentValue : Float;
    minValue : Float;
    maxValue : Float;
    optimizedValue : ?Float;           // Best value found
    sensitivity : Float;               // How much outcome changes with param
  };

  // ══════════════════════════════════════════════════════════════════════════
  // MEMORY SYSTEM STATE
  // ══════════════════════════════════════════════════════════════════════════

  public type MemorySystem = {
    // Episodic
    episodes : [Episode];
    nextEpisodeId : Nat;
    
    // Semantic
    facts : [SemanticFact];
    correlations : [Correlation];
    causalModels : [CausalModel];
    nextFactId : Nat;
    
    // Procedural
    procedures : [Procedure];
    nextProcedureId : Nat;
    
    // System metadata
    totalMemories : Nat;
    lastConsolidation : Nat;           // Last memory consolidation beat
    memoryHealth : Float;              // [0, 1] overall memory system health
  };

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // Ebbinghaus forgetting curve: R = e^(-t/S) where S = strength
  func forgettingCurve(timeSinceAccess: Float, strength: Float, emotionalBoost: Float) : Float {
    let adjustedStrength = strength * (1.0 + emotionalBoost);
    Float.exp(-timeSinceAccess / (adjustedStrength * 1000.0 + 1.0))
  };

  // Cosine similarity between feature vectors
  func cosineSimilarity(a: [Float], b: [Float]) : Float {
    if (a.size() != b.size() or a.size() == 0) { return 0.0 };
    
    var dotProduct : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    
    var i = 0;
    while (i < a.size()) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
      i += 1;
    };
    
    let denominator = Float.sqrt(normA) * Float.sqrt(normB);
    if (denominator > 0.001) { dotProduct / denominator } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // EPISODIC MEMORY FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════

  // Create feature vector from context for similarity matching
  func createFeatureVector(market: MarketContext, organism: OrganismContext) : [Float] {
    [
      market.price / 100000.0,         // Normalized price
      market.trend,
      market.volatility,
      market.volume / 1000000.0,       // Normalized volume
      organism.coherence,
      organism.fearLevel,
      organism.greedLevel,
      organism.disciplineLevel
    ]
  };

  public func storeEpisode(
    memory : MemorySystem,
    market : MarketContext,
    organism : OrganismContext,
    eventType : EventType,
    eventData : EventData,
    outcome : Outcome,
    emotionalValence : Float,
    emotionalArousal : Float,
    beat : Nat
  ) : MemorySystem {
    // Calculate significance based on outcome magnitude and emotion
    let profitMagnitude = Float.abs(outcome.profitLossPercent);
    let emotionMagnitude = Float.abs(emotionalValence) + emotionalArousal;
    let significance = _clamp(profitMagnitude * 10.0 + emotionMagnitude, 0.0, 1.0);
    
    let episode : Episode = {
      episodeId = memory.nextEpisodeId;
      timestamp = beat;
      marketState = market;
      organismState = organism;
      eventType = eventType;
      eventData = eventData;
      outcome = outcome;
      emotionalValence = emotionalValence;
      emotionalArousal = emotionalArousal;
      significance = significance;
      strength = 1.0;                  // Starts at full strength
      rehearsalCount = 0;
      lastAccess = beat;
      featureVector = createFeatureVector(market, organism);
    };
    
    // Check capacity and add
    var episodes = memory.episodes;
    if (episodes.size() >= EPISODIC_CAPACITY) {
      // Remove weakest memory (lowest strength × significance)
      var minIdx : Nat = 0;
      var minScore : Float = 999999.0;
      var i = 0;
      while (i < episodes.size()) {
        let score = episodes[i].strength * episodes[i].significance;
        if (score < minScore) {
          minScore := score;
          minIdx := i;
        };
        i += 1;
      };
      episodes := Array.tabulate(episodes.size(), func(j : Nat) : Episode {
        if (j == minIdx) { episode } else { episodes[j] }
      });
    } else {
      episodes := Array.append(episodes, [episode]);
    };
    
    {
      episodes = episodes;
      nextEpisodeId = memory.nextEpisodeId + 1;
      facts = memory.facts;
      correlations = memory.correlations;
      causalModels = memory.causalModels;
      nextFactId = memory.nextFactId;
      procedures = memory.procedures;
      nextProcedureId = memory.nextProcedureId;
      totalMemories = memory.totalMemories + 1;
      lastConsolidation = memory.lastConsolidation;
      memoryHealth = memory.memoryHealth;
    }
  };

  // Retrieve similar episodes (pattern matching)
  public func retrieveSimilarEpisodes(
    memory : MemorySystem,
    currentMarket : MarketContext,
    currentOrganism : OrganismContext,
    maxResults : Nat,
    beat : Nat
  ) : [Episode] {
    let queryVector = createFeatureVector(currentMarket, currentOrganism);
    
    // Score all episodes by similarity and recency
    var scored : [(Episode, Float)] = [];
    for (ep in memory.episodes.vals()) {
      let similarity = cosineSimilarity(queryVector, ep.featureVector);
      let recencyBoost = forgettingCurve(Float.fromInt(beat - ep.lastAccess), ep.strength, ep.emotionalArousal);
      let score = similarity * recencyBoost * ep.significance;
      
      if (similarity > SIMILARITY_THRESHOLD) {
        scored := Array.append(scored, [(ep, score)]);
      };
    };
    
    // Sort by score (descending)
    var i = 0;
    while (i < scored.size()) {
      var j = i + 1;
      while (j < scored.size()) {
        if (scored[j].1 > scored[i].1) {
          let temp = scored[i];
          scored := Array.tabulate(scored.size(), func(k : Nat) : (Episode, Float) {
            if (k == i) { scored[j] }
            else if (k == j) { temp }
            else { scored[k] }
          });
        };
        j += 1;
      };
      i += 1;
    };
    
    // Return top N
    let n = Int.abs(Float.toInt(Float.min(Float.fromInt(maxResults), Float.fromInt(scored.size()))));
    Array.tabulate<Episode>(n, func(idx) { scored[idx].0 })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SEMANTIC MEMORY FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════

  public func storeFact(
    memory : MemorySystem,
    category : FactCategory,
    subject : Text,
    predicate : Text,
    object : Text,
    confidence : Float,
    beat : Nat
  ) : MemorySystem {
    // Check if fact already exists (update if so)
    var factExists = false;
    var existingIdx : Nat = 0;
    var i = 0;
    while (i < memory.facts.size()) {
      let fact = memory.facts[i];
      if (fact.subject == subject and fact.predicate == predicate) {
        factExists := true;
        existingIdx := i;
      };
      i += 1;
    };
    
    var facts = memory.facts;
    
    if (factExists) {
      // Update existing fact
      let oldFact = facts[existingIdx];
      let newFact : SemanticFact = {
        factId = oldFact.factId;
        category = category;
        subject = subject;
        predicate = predicate;
        object = object;
        confidence = (oldFact.confidence + confidence) / 2.0;  // Average
        evidenceCount = oldFact.evidenceCount + 1;
        contradictionCount = oldFact.contradictionCount;
        lastUpdated = beat;
        relatedFacts = oldFact.relatedFacts;
        causedBy = oldFact.causedBy;
        causes = oldFact.causes;
        accessCount = oldFact.accessCount;
        usefulness = oldFact.usefulness;
      };
      facts := Array.tabulate(facts.size(), func(j : Nat) : SemanticFact {
        if (j == existingIdx) { newFact } else { facts[j] }
      });
    } else {
      // Add new fact
      let newFact : SemanticFact = {
        factId = memory.nextFactId;
        category = category;
        subject = subject;
        predicate = predicate;
        object = object;
        confidence = confidence;
        evidenceCount = 1;
        contradictionCount = 0;
        lastUpdated = beat;
        relatedFacts = [];
        causedBy = [];
        causes = [];
        accessCount = 0;
        usefulness = 0.5;
      };
      facts := Array.append(facts, [newFact]);
    };
    
    {
      episodes = memory.episodes;
      nextEpisodeId = memory.nextEpisodeId;
      facts = facts;
      correlations = memory.correlations;
      causalModels = memory.causalModels;
      nextFactId = if (factExists) { memory.nextFactId } else { memory.nextFactId + 1 };
      procedures = memory.procedures;
      nextProcedureId = memory.nextProcedureId;
      totalMemories = if (factExists) { memory.totalMemories } else { memory.totalMemories + 1 };
      lastConsolidation = memory.lastConsolidation;
      memoryHealth = memory.memoryHealth;
    }
  };

  // Update correlation knowledge
  public func updateCorrelation(
    memory : MemorySystem,
    asset1 : Text,
    asset2 : Text,
    newCorrelation : Float,
    timeframe : Text,
    beat : Nat
  ) : MemorySystem {
    var correlations = memory.correlations;
    var found = false;
    
    var i = 0;
    while (i < correlations.size()) {
      let corr = correlations[i];
      if (corr.asset1 == asset1 and corr.asset2 == asset2 and corr.timeframe == timeframe) {
        // Update with exponential moving average
        let alpha = 0.1;  // Learning rate
        let updatedCorr : Correlation = {
          asset1 = asset1;
          asset2 = asset2;
          correlation = corr.correlation * (1.0 - alpha) + newCorrelation * alpha;
          timeframe = timeframe;
          sampleSize = corr.sampleSize + 1;
          lastUpdated = beat;
        };
        correlations := Array.tabulate(correlations.size(), func(j : Nat) : Correlation {
          if (j == i) { updatedCorr } else { correlations[j] }
        });
        found := true;
      };
      i += 1;
    };
    
    if (not found) {
      let newCorr : Correlation = {
        asset1 = asset1;
        asset2 = asset2;
        correlation = newCorrelation;
        timeframe = timeframe;
        sampleSize = 1;
        lastUpdated = beat;
      };
      correlations := Array.append(correlations, [newCorr]);
    };
    
    {
      episodes = memory.episodes;
      nextEpisodeId = memory.nextEpisodeId;
      facts = memory.facts;
      correlations = correlations;
      causalModels = memory.causalModels;
      nextFactId = memory.nextFactId;
      procedures = memory.procedures;
      nextProcedureId = memory.nextProcedureId;
      totalMemories = memory.totalMemories;
      lastConsolidation = memory.lastConsolidation;
      memoryHealth = memory.memoryHealth;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // PROCEDURAL MEMORY FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════

  public func updateProcedure(
    memory : MemorySystem,
    procedureId : Nat,
    wasSuccessful : Bool,
    returnAchieved : Float,
    beat : Nat
  ) : MemorySystem {
    var procedures = memory.procedures;
    
    var i = 0;
    while (i < procedures.size()) {
      if (procedures[i].procedureId == procedureId) {
        let proc = procedures[i];
        let newExecCount = proc.executionCount + 1;
        let newSuccessCount = if (wasSuccessful) { proc.successCount + 1 } else { proc.successCount };
        let newSuccessRate = Float.fromInt(newSuccessCount) / Float.fromInt(newExecCount);
        
        // Update average return with EMA
        let alpha = 2.0 / (Float.fromInt(newExecCount) + 1.0);
        let newAvgReturn = proc.avgReturn * (1.0 - alpha) + returnAchieved * alpha;
        
        // Update learning curve
        let newLearningCurve = Array.append(proc.learningCurve, [newSuccessRate]);
        
        // Update skill level based on recent performance
        let recentPerformance = if (newLearningCurve.size() > 10) {
          var sum : Float = 0.0;
          var j = newLearningCurve.size() - 10;
          while (j < newLearningCurve.size()) {
            sum += newLearningCurve[j];
            j += 1;
          };
          sum / 10.0
        } else {
          newSuccessRate
        };
        
        let updatedProc : Procedure = {
          procedureId = proc.procedureId;
          name = proc.name;
          category = proc.category;
          steps = proc.steps;
          parameters = proc.parameters;
          executionCount = newExecCount;
          successCount = newSuccessCount;
          successRate = newSuccessRate;
          avgReturn = newAvgReturn;
          sharpeRatio = proc.sharpeRatio;  // Would need more data to update
          maxDrawdown = if (returnAchieved < 0.0 and Float.abs(returnAchieved) > proc.maxDrawdown) {
            Float.abs(returnAchieved)
          } else {
            proc.maxDrawdown
          };
          skillLevel = _clamp(recentPerformance, 0.0, 1.0);
          learningCurve = newLearningCurve;
          lastExecution = beat;
          applicableRegimes = proc.applicableRegimes;
          requiredCoherence = proc.requiredCoherence;
          requiredConfidence = proc.requiredConfidence;
        };
        
        procedures := Array.tabulate(procedures.size(), func(k : Nat) : Procedure {
          if (k == i) { updatedProc } else { procedures[k] }
        });
      };
      i += 1;
    };
    
    {
      episodes = memory.episodes;
      nextEpisodeId = memory.nextEpisodeId;
      facts = memory.facts;
      correlations = memory.correlations;
      causalModels = memory.causalModels;
      nextFactId = memory.nextFactId;
      procedures = procedures;
      nextProcedureId = memory.nextProcedureId;
      totalMemories = memory.totalMemories;
      lastConsolidation = memory.lastConsolidation;
      memoryHealth = memory.memoryHealth;
    }
  };

  // Get best procedure for current conditions
  public func getBestProcedure(
    memory : MemorySystem,
    regime : Text,
    coherence : Float,
    category : ProcedureCategory
  ) : ?Procedure {
    var bestProc : ?Procedure = null;
    var bestScore : Float = 0.0;
    
    for (proc in memory.procedures.vals()) {
      // Check if applicable
      var regimeMatch = false;
      for (r in proc.applicableRegimes.vals()) {
        if (r == regime) { regimeMatch := true };
      };
      
      let categoryMatch = switch (proc.category, category) {
        case (#TradingStrategy, #TradingStrategy) { true };
        case (#RiskManagement, #RiskManagement) { true };
        case (#PositionSizing, #PositionSizing) { true };
        case (#EntryTiming, #EntryTiming) { true };
        case (#ExitTiming, #ExitTiming) { true };
        case (#Rebalancing, #Rebalancing) { true };
        case (#Hedging, #Hedging) { true };
        case (_, _) { false };
      };
      
      let coherenceOK = coherence >= proc.requiredCoherence;
      
      if (regimeMatch and categoryMatch and coherenceOK) {
        // Score by skill level and historical performance
        let score = proc.skillLevel * 0.4 + proc.successRate * 0.4 + 
                   (1.0 - proc.maxDrawdown) * 0.2;
        if (score > bestScore) {
          bestScore := score;
          bestProc := ?proc;
        };
      };
    };
    
    bestProc
  };

  // ══════════════════════════════════════════════════════════════════════════
  // MEMORY CONSOLIDATION (Sleep/Replay)
  // ══════════════════════════════════════════════════════════════════════════

  public func consolidateMemory(
    memory : MemorySystem,
    beat : Nat
  ) : MemorySystem {
    // Decay all episodic memories based on time since access
    var episodes = Array.tabulate<Episode>(memory.episodes.size(), func(i) {
      let ep = memory.episodes[i];
      let timeSinceAccess = Float.fromInt(beat - ep.lastAccess);
      let decayedStrength = forgettingCurve(timeSinceAccess, ep.strength, ep.emotionalArousal);
      {
        episodeId = ep.episodeId;
        timestamp = ep.timestamp;
        marketState = ep.marketState;
        organismState = ep.organismState;
        eventType = ep.eventType;
        eventData = ep.eventData;
        outcome = ep.outcome;
        emotionalValence = ep.emotionalValence;
        emotionalArousal = ep.emotionalArousal;
        significance = ep.significance;
        strength = decayedStrength;
        rehearsalCount = ep.rehearsalCount;
        lastAccess = ep.lastAccess;
        featureVector = ep.featureVector;
      }
    });
    
    // Remove memories below threshold
    episodes := Array.filter<Episode>(episodes, func(ep) { ep.strength > 0.1 });
    
    // Calculate memory health
    var totalStrength : Float = 0.0;
    for (ep in episodes.vals()) {
      totalStrength += ep.strength;
    };
    let avgStrength = if (episodes.size() > 0) { 
      totalStrength / Float.fromInt(episodes.size()) 
    } else { 0.5 };
    
    let factHealth = Float.fromInt(memory.facts.size()) / Float.fromInt(SEMANTIC_CAPACITY);
    let procHealth = if (memory.procedures.size() > 0) {
      var avgSkill : Float = 0.0;
      for (proc in memory.procedures.vals()) {
        avgSkill += proc.skillLevel;
      };
      avgSkill / Float.fromInt(memory.procedures.size())
    } else { 0.5 };
    
    let overallHealth = (avgStrength + factHealth + procHealth) / 3.0;
    
    {
      episodes = episodes;
      nextEpisodeId = memory.nextEpisodeId;
      facts = memory.facts;
      correlations = memory.correlations;
      causalModels = memory.causalModels;
      nextFactId = memory.nextFactId;
      procedures = memory.procedures;
      nextProcedureId = memory.nextProcedureId;
      totalMemories = episodes.size() + memory.facts.size() + memory.procedures.size();
      lastConsolidation = beat;
      memoryHealth = overallHealth;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // INITIALIZE MEMORY SYSTEM
  // ══════════════════════════════════════════════════════════════════════════

  public func initMemorySystem() : MemorySystem {
    {
      episodes = [];
      nextEpisodeId = 0;
      facts = [];
      correlations = [];
      causalModels = [];
      nextFactId = 0;
      procedures = [];
      nextProcedureId = 0;
      totalMemories = 0;
      lastConsolidation = 0;
      memoryHealth = 1.0;
    }
  };

  // Learn from outcome — extracts facts and updates procedures
  public func learnFromOutcome(
    memory : MemorySystem,
    episode : Episode,
    beat : Nat
  ) : MemorySystem {
    var updatedMemory = memory;
    
    // If significant profit, store as fact
    if (episode.outcome.profitLossPercent > 0.05) {
      updatedMemory := storeFact(
        updatedMemory,
        #TradingRule,
        episode.marketState.symbol,
        "profitable_in",
        episode.marketState.regime,
        episode.outcome.profitLossPercent,
        beat
      );
    };
    
    // If significant loss, store warning fact
    if (episode.outcome.profitLossPercent < -0.05) {
      updatedMemory := storeFact(
        updatedMemory,
        #RiskFact,
        episode.marketState.symbol,
        "loss_in",
        episode.marketState.regime,
        Float.abs(episode.outcome.profitLossPercent),
        beat
      );
    };
    
    updatedMemory
  };

}
