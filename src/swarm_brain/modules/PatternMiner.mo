// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: PatternMiner — OpenCog-Style Pattern Discovery & Schema Generation
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    PATTERN MINER — GOERTZEL UPGRADE                      ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  Based on Ben Goertzel's OpenCog Pattern Miner.                          ║
// ║                                                                          ║
// ║  CORE INSIGHT:                                                           ║
// ║    Intelligence = pattern recognition + pattern creation.                ║
// ║    The mind discovers patterns, stores them, uses them to predict.       ║
// ║    Frequent patterns become SCHEMAS that drive behavior directly.        ║
// ║                                                                          ║
// ║  PATTERN LIBRARY:                                                        ║
// ║    Array of { pattern: SDR, frequency: Nat, last_seen: Beat }            ║
// ║                                                                          ║
// ║  MINING CYCLE (every 50 beats):                                          ║
// ║    1. Scan last 50 events for recurring SDR patterns                     ║
// ║    2. If pattern appears 3+ times → add to library                       ║
// ║    3. If pattern appears 13+ times → becomes SCHEMA                      ║
// ║                                                                          ║
// ║  SCHEMAS DRIVE BEHAVIOR:                                                 ║
// ║    if current_state matches schema.trigger:                              ║
// ║      probability(schema.response) += 0.275                               ║
// ║                                                                          ║
// ║  OMNIS EVENTS CREATE SCHEMAS:                                            ║
// ║    The state that triggered OMNIS is preserved as high-value schema.     ║
// ║    Organism actively tries to recreate conditions for emergence.         ║
// ║    This is SELF-DIRECTED EVOLUTION, not random walk.                     ║
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
  
  // Mining parameters
  public let MINING_INTERVAL : Nat = 50;          // Mine every 50 beats
  public let PATTERN_THRESHOLD : Nat = 3;         // 3+ occurrences = pattern
  public let SCHEMA_THRESHOLD : Nat = 13;         // F[7] = 13+ = schema
  public let EVENT_WINDOW : Nat = 50;             // Look back 50 events
  
  // Pattern library limits
  public let MAX_PATTERNS : Nat = 144;            // F[12] max patterns
  public let MAX_SCHEMAS : Nat = 21;              // F[8] max schemas
  
  // Behavior influence
  public let SCHEMA_INFLUENCE : Float = 0.275;    // How much schemas affect behavior
  public let OMNIS_SCHEMA_VALUE : Float = 5.0;    // OMNIS schemas are 5× more valuable
  
  // SDR parameters
  public let SDR_SIZE : Nat = 64;
  public let SIMILARITY_THRESHOLD : Float = 0.7;  // 70% overlap = same pattern

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PATTERN TYPES                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Sparse Distributed Representation
  public type SDR = {
    activeBits : [Nat];
    dimensions : Nat;
  };
  
  /// A discovered pattern
  public type Pattern = {
    id : Nat32;
    sdr : SDR;
    
    // Frequency metrics
    frequency : Nat;          // Times observed
    firstSeen : Nat;          // Beat of first observation
    lastSeen : Nat;           // Beat of most recent
    
    // Value metrics
    surpriseValue : Float;    // How surprising was this when discovered
    predictiveValue : Float;  // How useful for prediction
    
    // Categorization
    isSchema : Bool;          // Has it reached schema threshold?
    isOMNISPattern : Bool;    // Did it trigger OMNIS?
  };
  
  /// A schema (high-frequency pattern that drives behavior)
  public type Schema = {
    id : Nat32;
    
    // Trigger-Response pair
    trigger : SDR;            // State that activates this schema
    response : SDR;           // Behavior/state this schema produces
    
    // Metrics
    activations : Nat;        // Times this schema fired
    successRate : Float;      // How often response led to good outcome
    value : Float;            // Importance score
    
    // Origin
    sourcePattern : Nat32;    // Pattern ID this came from
    isOMNISSchema : Bool;     // Created from OMNIS event
    
    // Timing
    createdAt : Nat;
    lastActivation : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     EVENT LOG                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Event = {
    beat : Nat;
    state : SDR;
    wasOMNIS : Bool;
    coherenceLevel : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PATTERN MINER STATE                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type PatternMiner = {
    // Pattern storage
    patterns : [Pattern];
    schemas : [Schema];
    
    // Event log
    eventLog : [Event];
    
    // Mining state
    lastMiningBeat : Nat;
    nextPatternId : Nat32;
    nextSchemaId : Nat32;
    
    // Statistics
    totalPatternsMined : Nat;
    totalSchemasCreated : Nat;
    omnisPatternCount : Nat;
    
    // Current matches
    activeSchemas : [Nat32];  // Schema IDs currently matching
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SDR OPERATIONS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Calculate overlap between two SDRs
  public func sdrOverlap(a: SDR, b: SDR) : Nat {
    var count : Nat = 0;
    for (bitA in a.activeBits.vals()) {
      for (bitB in b.activeBits.vals()) {
        if (bitA == bitB) { count += 1 };
      };
    };
    count
  };
  
  /// Calculate similarity (Jaccard index)
  public func sdrSimilarity(a: SDR, b: SDR) : Float {
    let overlap = sdrOverlap(a, b);
    let union = a.activeBits.size() + b.activeBits.size() - overlap;
    
    if (union == 0) { return 0.0 };
    Float.fromInt(overlap) / Float.fromInt(union)
  };
  
  /// Check if SDRs are similar enough to be same pattern
  public func sdrMatch(a: SDR, b: SDR) : Bool {
    sdrSimilarity(a, b) >= SIMILARITY_THRESHOLD
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     EVENT LOGGING                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Log a new event
  public func logEvent(
    miner: PatternMiner,
    state: SDR,
    coherence: Float,
    wasOMNIS: Bool,
    currentBeat: Nat
  ) : PatternMiner {
    let event : Event = {
      beat = currentBeat;
      state = state;
      wasOMNIS = wasOMNIS;
      coherenceLevel = coherence;
    };
    
    // Add to log, keep last EVENT_WINDOW events
    let newLog = Buffer.Buffer<Event>(EVENT_WINDOW);
    newLog.add(event);
    
    for (e in miner.eventLog.vals()) {
      if (newLog.size() < EVENT_WINDOW) {
        newLog.add(e);
      };
    };
    
    {
      patterns = miner.patterns;
      schemas = miner.schemas;
      eventLog = Buffer.toArray(newLog);
      lastMiningBeat = miner.lastMiningBeat;
      nextPatternId = miner.nextPatternId;
      nextSchemaId = miner.nextSchemaId;
      totalPatternsMined = miner.totalPatternsMined;
      totalSchemasCreated = miner.totalSchemasCreated;
      omnisPatternCount = miner.omnisPatternCount;
      activeSchemas = miner.activeSchemas;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PATTERN MINING                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Mine patterns from event log
  public func minePatterns(
    miner: PatternMiner,
    currentBeat: Nat
  ) : PatternMiner {
    if (miner.eventLog.size() < 3) {
      return miner;  // Not enough events
    };
    
    // Count pattern frequencies
    // Group similar SDRs and count occurrences
    let patternCounts = Buffer.Buffer<(SDR, Nat, Bool)>(miner.eventLog.size());
    
    for (event in miner.eventLog.vals()) {
      // Check if this SDR matches any existing count
      var found = false;
      var i = 0;
      while (i < patternCounts.size() and not found) {
        let (existingSDR, count, wasOMNIS) = patternCounts.get(i);
        if (sdrMatch(event.state, existingSDR)) {
          patternCounts.put(i, (existingSDR, count + 1, wasOMNIS or event.wasOMNIS));
          found := true;
        };
        i += 1;
      };
      
      if (not found) {
        patternCounts.add((event.state, 1, event.wasOMNIS));
      };
    };
    
    // Find patterns that meet threshold
    let newPatterns = Buffer.Buffer<Pattern>(MAX_PATTERNS);
    var nextId = miner.nextPatternId;
    var newPatternCount : Nat = 0;
    var newOMNISCount : Nat = 0;
    
    // Keep existing patterns
    for (p in miner.patterns.vals()) {
      if (newPatterns.size() < MAX_PATTERNS) {
        newPatterns.add(p);
      };
    };
    
    // Add new patterns
    for ((sdr, count, wasOMNIS) in patternCounts.vals()) {
      if (count >= PATTERN_THRESHOLD) {
        // Check if already exists
        var exists = false;
        for (p in newPatterns.vals()) {
          if (sdrMatch(p.sdr, sdr)) {
            exists := true;
          };
        };
        
        if (not exists and newPatterns.size() < MAX_PATTERNS) {
          let newPattern : Pattern = {
            id = nextId;
            sdr = sdr;
            frequency = count;
            firstSeen = currentBeat;
            lastSeen = currentBeat;
            surpriseValue = 1.0 / Float.fromInt(count);  // Rare = surprising
            predictiveValue = Float.fromInt(count) / Float.fromInt(miner.eventLog.size());
            isSchema = count >= SCHEMA_THRESHOLD;
            isOMNISPattern = wasOMNIS;
          };
          
          newPatterns.add(newPattern);
          nextId += 1;
          newPatternCount += 1;
          if (wasOMNIS) { newOMNISCount += 1 };
        };
      };
    };
    
    {
      patterns = Buffer.toArray(newPatterns);
      schemas = miner.schemas;
      eventLog = miner.eventLog;
      lastMiningBeat = currentBeat;
      nextPatternId = nextId;
      nextSchemaId = miner.nextSchemaId;
      totalPatternsMined = miner.totalPatternsMined + newPatternCount;
      totalSchemasCreated = miner.totalSchemasCreated;
      omnisPatternCount = miner.omnisPatternCount + newOMNISCount;
      activeSchemas = miner.activeSchemas;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SCHEMA GENERATION                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Promote patterns to schemas
  public func promoteToSchemas(
    miner: PatternMiner,
    currentBeat: Nat
  ) : PatternMiner {
    let newSchemas = Buffer.Buffer<Schema>(MAX_SCHEMAS);
    var nextId = miner.nextSchemaId;
    var newSchemaCount : Nat = 0;
    
    // Keep existing schemas
    for (s in miner.schemas.vals()) {
      if (newSchemas.size() < MAX_SCHEMAS) {
        newSchemas.add(s);
      };
    };
    
    // Check patterns for promotion
    for (pattern in miner.patterns.vals()) {
      if (pattern.frequency >= SCHEMA_THRESHOLD or pattern.isOMNISPattern) {
        // Check if schema already exists
        var exists = false;
        for (s in newSchemas.vals()) {
          if (s.sourcePattern == pattern.id) {
            exists := true;
          };
        };
        
        if (not exists and newSchemas.size() < MAX_SCHEMAS) {
          // Create trigger-response pair
          // Trigger = the pattern itself
          // Response = what usually follows (simplified: same pattern)
          let value = if (pattern.isOMNISPattern) { 
            OMNIS_SCHEMA_VALUE 
          } else { 
            Float.fromInt(pattern.frequency) / Float.fromInt(SCHEMA_THRESHOLD) 
          };
          
          let newSchema : Schema = {
            id = nextId;
            trigger = pattern.sdr;
            response = pattern.sdr;  // Simplified: response = maintain pattern
            activations = 0;
            successRate = 0.5;
            value = value;
            sourcePattern = pattern.id;
            isOMNISSchema = pattern.isOMNISPattern;
            createdAt = currentBeat;
            lastActivation = 0;
          };
          
          newSchemas.add(newSchema);
          nextId += 1;
          newSchemaCount += 1;
        };
      };
    };
    
    {
      patterns = miner.patterns;
      schemas = Buffer.toArray(newSchemas);
      eventLog = miner.eventLog;
      lastMiningBeat = miner.lastMiningBeat;
      nextPatternId = miner.nextPatternId;
      nextSchemaId = nextId;
      totalPatternsMined = miner.totalPatternsMined;
      totalSchemasCreated = miner.totalSchemasCreated + newSchemaCount;
      omnisPatternCount = miner.omnisPatternCount;
      activeSchemas = miner.activeSchemas;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SCHEMA MATCHING                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Find schemas that match current state
  public func matchSchemas(
    miner: PatternMiner,
    currentState: SDR
  ) : (PatternMiner, [Schema]) {
    let matches = Buffer.Buffer<Schema>(MAX_SCHEMAS);
    let matchIds = Buffer.Buffer<Nat32>(MAX_SCHEMAS);
    
    for (schema in miner.schemas.vals()) {
      if (sdrMatch(currentState, schema.trigger)) {
        matches.add(schema);
        matchIds.add(schema.id);
      };
    };
    
    let updatedMiner = {
      patterns = miner.patterns;
      schemas = miner.schemas;
      eventLog = miner.eventLog;
      lastMiningBeat = miner.lastMiningBeat;
      nextPatternId = miner.nextPatternId;
      nextSchemaId = miner.nextSchemaId;
      totalPatternsMined = miner.totalPatternsMined;
      totalSchemasCreated = miner.totalSchemasCreated;
      omnisPatternCount = miner.omnisPatternCount;
      activeSchemas = Buffer.toArray(matchIds);
    };
    
    (updatedMiner, Buffer.toArray(matches))
  };
  
  /// Calculate behavior influence from matching schemas
  public func schemaBehaviorInfluence(matchingSchemas: [Schema]) : Float {
    var totalInfluence : Float = 0.0;
    
    for (schema in matchingSchemas.vals()) {
      let baseInfluence = SCHEMA_INFLUENCE;
      let valueMultiplier = schema.value;
      let successMultiplier = 0.5 + schema.successRate * 0.5;
      
      totalInfluence += baseInfluence * valueMultiplier * successMultiplier;
    };
    
    _clamp(totalInfluence, 0.0, 1.0)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FULL MINING CYCLE                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Run complete mining cycle
  public func miningCycle(
    miner: PatternMiner,
    currentBeat: Nat
  ) : PatternMiner {
    // Only mine every MINING_INTERVAL beats
    if (currentBeat - miner.lastMiningBeat < MINING_INTERVAL) {
      return miner;
    };
    
    // 1. Mine patterns from events
    let mined = minePatterns(miner, currentBeat);
    
    // 2. Promote patterns to schemas
    let promoted = promoteToSchemas(mined, currentBeat);
    
    promoted
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     OMNIS SCHEMA CREATION                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // When OMNIS fires, capture that state as a high-value schema.
  // The organism will actively try to recreate OMNIS conditions.
  //
  
  /// Create schema from OMNIS event
  public func createOMNISSchema(
    miner: PatternMiner,
    omnisState: SDR,
    currentBeat: Nat
  ) : PatternMiner {
    // Create high-value OMNIS schema
    let omnisSchema : Schema = {
      id = miner.nextSchemaId;
      trigger = omnisState;
      response = omnisState;
      activations = 1;
      successRate = 1.0;  // OMNIS = success by definition
      value = OMNIS_SCHEMA_VALUE;
      sourcePattern = 0;  // No source pattern
      isOMNISSchema = true;
      createdAt = currentBeat;
      lastActivation = currentBeat;
    };
    
    // Add to schemas (prioritize over regular schemas)
    let newSchemas = Buffer.Buffer<Schema>(MAX_SCHEMAS);
    newSchemas.add(omnisSchema);  // OMNIS schema first
    
    for (s in miner.schemas.vals()) {
      if (newSchemas.size() < MAX_SCHEMAS) {
        newSchemas.add(s);
      };
    };
    
    {
      patterns = miner.patterns;
      schemas = Buffer.toArray(newSchemas);
      eventLog = miner.eventLog;
      lastMiningBeat = miner.lastMiningBeat;
      nextPatternId = miner.nextPatternId;
      nextSchemaId = miner.nextSchemaId + 1;
      totalPatternsMined = miner.totalPatternsMined;
      totalSchemasCreated = miner.totalSchemasCreated + 1;
      omnisPatternCount = miner.omnisPatternCount + 1;
      activeSchemas = miner.activeSchemas;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initPatternMiner() : PatternMiner {
    {
      patterns = [];
      schemas = [];
      eventLog = [];
      lastMiningBeat = 0;
      nextPatternId = 1;
      nextSchemaId = 1;
      totalPatternsMined = 0;
      totalSchemasCreated = 0;
      omnisPatternCount = 0;
      activeSchemas = [];
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
  
  public type MinerSummary = {
    patternCount : Nat;
    schemaCount : Nat;
    omnisSchemaCount : Nat;
    activeSchemaCount : Nat;
    eventCount : Nat;
  };
  
  public func summarize(miner: PatternMiner) : MinerSummary {
    var omnisCount : Nat = 0;
    for (s in miner.schemas.vals()) {
      if (s.isOMNISSchema) { omnisCount += 1 };
    };
    
    {
      patternCount = miner.patterns.size();
      schemaCount = miner.schemas.size();
      omnisSchemaCount = omnisCount;
      activeSchemaCount = miner.activeSchemas.size();
      eventCount = miner.eventLog.size();
    }
  };

}
