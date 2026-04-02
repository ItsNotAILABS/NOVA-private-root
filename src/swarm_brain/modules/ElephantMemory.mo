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
// ELEPHANT MEMORY — HIPPOCAMPAL-SCALE TEMPORAL BINDING
// Multi-decade episodic recall, spatial navigation
// 300 billion neurons, largest terrestrial brain
// Infrasound communication (5-20 Hz), seismic sensing
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let MEMORY_CAPACITY : Nat = 1000;    // Long-term memories
  let SPATIAL_CELLS : Nat = 256;       // Spatial map resolution
  let SOCIAL_MEMORY_SIZE : Nat = 100;  // Individual recognition

  // ── Types ─────────────────────────────────────────────────────
  public type LongTermMemory = {
    id            : Nat;
    eventType     : MemoryType;
    location      : Nat;         // Spatial index
    timeCreated   : Nat;         // Beat when formed
    lastAccessed  : Nat;         // Last recall
    emotionalValue: Float;       // -1 to 1 (trauma to joy)
    strength      : Float;       // Consolidation level
    associations  : [Nat];       // Linked memories
  };

  public type MemoryType = {
    #Spatial;      // Location memory
    #Social;       // Individual recognition
    #Resource;     // Water, food sources
    #Threat;       // Danger memories
    #Mourning;     // Death/loss memories
    #Migration;    // Route memories
    #Communication;// Learned calls
  };

  public type SocialMemory = {
    individualId  : Nat;
    relationship  : Relationship;
    lastContact   : Nat;
    trustLevel    : Float;
    dominance     : Float;
    voiceSignature: [Float];     // Acoustic ID (8 values)
    appearances   : Nat;         // Times encountered
  };

  public type Relationship = {
    #Mother;
    #Offspring;
    #Sibling;
    #MatriarchLine;
    #Ally;
    #Stranger;
    #Threat;
  };

  public type SpatialKnowledge = {
    cells         : [Float];     // 16x16 grid of familiarity
    waterSources  : [Nat];       // Known water locations
    dangerZones   : [Nat];       // Remembered threats
    migrationPath : [Nat];       // Ancestral routes
    currentCell   : Nat;
  };

  public type InfrasoundComm = {
    frequency     : Float;       // 5-20 Hz
    pattern       : [Float];     // Call structure
    meaning       : CallMeaning;
    sender        : ?Nat;        // Individual ID if known
    distance      : Float;       // Estimated km
  };

  public type CallMeaning = {
    #Contact;      // "I'm here"
    #Greeting;     // Recognition
    #Alarm;        // Danger warning
    #Musth;        // Male state
    #Estrus;       // Female state
    #Mourning;     // Loss call
    #Gathering;    // Come together
  };

  public type ElephantState = {
    // Long-term memory system
    memories         : [LongTermMemory];
    memoryConsolidation: Float;
    recallAccuracy   : Float;

    // Social knowledge
    socialNetwork    : [SocialMemory];
    matriarchId      : ?Nat;
    herdCohesion     : Float;

    // Spatial cognition
    spatialKnowledge : SpatialKnowledge;
    navigationGoal   : ?Nat;
    pathIntegration  : Float;   // Dead reckoning accuracy

    // Infrasound system
    recentCalls      : [InfrasoundComm];
    callRepertoire   : Nat;     // Known call types
    listeningFocus   : Float;

    // Seismic sensing (through feet)
    seismicAlert     : Float;
    groundVibration  : Float;

    // Emotional state
    griefLevel       : Float;   // Mourning intensity
    anxietyLevel     : Float;
    bonding          : Float;   // Social attachment

    // Temporal awareness
    seasonalPhase    : Float;   // 0-1 year cycle
    ageEstimate      : Nat;     // In beats (proxy for years)

    beatNum          : Nat;
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Memory Consolidation ──────────────────────────────────────
  // Strengthen memories during rest (sleep consolidation)
  public func consolidateMemories(
    memories: [LongTermMemory], currentBeat: Nat
  ) : [LongTermMemory] {
    Array.map<LongTermMemory, LongTermMemory>(memories, func(m) {
      // Recent memories consolidate faster
      let recency = Float.fromInt(currentBeat - m.lastAccessed);
      let consolidationRate = if (recency < 100.0) { 0.02 }
                              else if (recency < 1000.0) { 0.01 }
                              else { 0.001 };

      // Emotional memories consolidate stronger
      let emotionalBoost = Float.abs(m.emotionalValue) * 0.5 + 0.5;

      {
        id = m.id;
        eventType = m.eventType;
        location = m.location;
        timeCreated = m.timeCreated;
        lastAccessed = m.lastAccessed;
        emotionalValue = m.emotionalValue;
        strength = _clamp(m.strength + consolidationRate * emotionalBoost, 0.0, 1.0);
        associations = m.associations;
      }
    })
  };

  // ── Memory Retrieval ──────────────────────────────────────────
  // Cue-based recall with spreading activation
  public func recallMemory(
    memories: [LongTermMemory], cueType: MemoryType, cueLocation: ?Nat,
    currentBeat: Nat
  ) : [LongTermMemory] {
    // Find matching memories and update access time
    let recalled = Array.filter<LongTermMemory>(memories, func(m) {
      let typeMatch = m.eventType == cueType;
      let locationMatch = switch (cueLocation) {
        case (null) { true };
        case (?loc) { m.location == loc };
      };
      // Stronger memories more likely to be recalled
      typeMatch and locationMatch and m.strength > 0.2
    });

    // Sort by strength (would need custom sort in Motoko)
    recalled
  };

  // ── Memory Formation ──────────────────────────────────────────
  public func formMemory(
    memories: [LongTermMemory],
    eventType: MemoryType,
    location: Nat,
    emotionalValue: Float,
    currentBeat: Nat
  ) : [LongTermMemory] {
    let newMemory : LongTermMemory = {
      id = memories.size();
      eventType = eventType;
      location = location;
      timeCreated = currentBeat;
      lastAccessed = currentBeat;
      emotionalValue = emotionalValue;
      strength = 0.5;  // Initial strength
      associations = [];
    };

    // Add and prune if over capacity
    let updated = Array.append<LongTermMemory>(memories, [newMemory]);
    if (updated.size() > MEMORY_CAPACITY) {
      // Remove weakest memory
      var minStrength : Float = 1.0;
      var minIdx : Nat = 0;
      var i = 0;
      for (m in updated.vals()) {
        if (m.strength < minStrength) {
          minStrength := m.strength;
          minIdx := i;
        };
        i += 1;
      };
      Array.tabulate<LongTermMemory>(updated.size() - 1, func(j) {
        if (j < minIdx) { updated[j] }
        else { updated[j + 1] }
      })
    } else { updated }
  };

  // ── Social Recognition ────────────────────────────────────────
  public func recognizeIndividual(
    network: [SocialMemory], voiceSignature: [Float], currentBeat: Nat
  ) : ?SocialMemory {
    var bestMatch : ?SocialMemory = null;
    var bestScore : Float = 0.0;

    for (s in network.vals()) {
      // Compare voice signatures
      var similarity : Float = 0.0;
      var i = 0;
      while (i < 8 and i < voiceSignature.size() and i < s.voiceSignature.size()) {
        let diff = Float.abs(voiceSignature[i] - s.voiceSignature[i]);
        similarity += 1.0 - diff;
        i += 1;
      };
      similarity /= 8.0;

      if (similarity > bestScore and similarity > 0.7) {
        bestScore := similarity;
        bestMatch := ?s;
      };
    };

    bestMatch
  };

  // ── Update Social Network ─────────────────────────────────────
  public func updateSocialContact(
    network: [SocialMemory], individualId: Nat, interaction: Float, currentBeat: Nat
  ) : [SocialMemory] {
    var found = false;
    let updated = Array.map<SocialMemory, SocialMemory>(network, func(s) {
      if (s.individualId == individualId) {
        found := true;
        {
          individualId = s.individualId;
          relationship = s.relationship;
          lastContact = currentBeat;
          trustLevel = _clamp(s.trustLevel + interaction * 0.1, 0.0, 1.0);
          dominance = s.dominance;
          voiceSignature = s.voiceSignature;
          appearances = s.appearances + 1;
        }
      } else { s }
    });

    if (not found) {
      Array.append<SocialMemory>(updated, [{
        individualId = individualId;
        relationship = #Stranger;
        lastContact = currentBeat;
        trustLevel = 0.5;
        dominance = 0.5;
        voiceSignature = Array.tabulate<Float>(8, func(_) { 0.5 });
        appearances = 1;
      }])
    } else { updated }
  };

  // ── Infrasound Processing ─────────────────────────────────────
  public func processInfrasound(
    call: InfrasoundComm, network: [SocialMemory]
  ) : (CallMeaning, ?Nat) {
    // Identify sender if possible
    let sender = switch (call.sender) {
      case (?id) { ?id };
      case (null) { null };  // Unknown sender
    };

    // Classify call meaning based on frequency and pattern
    let meaning = if (call.frequency < 8.0) { #Musth }
                  else if (call.frequency > 18.0) { #Alarm }
                  else if (call.pattern.size() > 5) { #Greeting }
                  else { #Contact };

    (meaning, sender)
  };

  // ── Spatial Navigation ────────────────────────────────────────
  public func updateNavigation(
    spatial: SpatialKnowledge, currentPos: Nat, goal: ?Nat
  ) : SpatialKnowledge {
    // Update familiarity at current cell
    var newCells = Array.thaw<Float>(spatial.cells);
    if (currentPos < 256) {
      newCells[currentPos] := _clamp(spatial.cells[currentPos] + 0.1, 0.0, 1.0);
    };

    // Decay distant cells slightly
    var i = 0;
    while (i < 256) {
      if (i != currentPos) {
        newCells[i] := spatial.cells[i] * 0.999;
      };
      i += 1;
    };

    {
      cells = Array.freeze(newCells);
      waterSources = spatial.waterSources;
      dangerZones = spatial.dangerZones;
      migrationPath = spatial.migrationPath;
      currentCell = currentPos;
    }
  };

  // ── Grief Processing ──────────────────────────────────────────
  // Elephants show mourning behavior
  public func processGrief(
    currentGrief: Float, lossEvent: Bool, socialSupport: Float
  ) : Float {
    if (lossEvent) {
      // Spike grief on loss
      _clamp(currentGrief + 0.5, 0.0, 1.0)
    } else {
      // Gradual recovery, faster with social support
      let recovery = 0.005 + socialSupport * 0.01;
      _clamp(currentGrief - recovery, 0.0, 1.0)
    }
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatElephant(
    state: ElephantState,
    currentPosition: Nat,
    socialInteraction: Float,
    threatLevel: Float,
    infrasoundInput: ?InfrasoundComm,
    seismicInput: Float
  ) : ElephantState {
    // Consolidate memories periodically
    let newMemories = if (state.beatNum % 100 == 0) {
      consolidateMemories(state.memories, state.beatNum + 1)
    } else { state.memories };

    // Update spatial knowledge
    let newSpatial = updateNavigation(state.spatialKnowledge, currentPosition, state.navigationGoal);

    // Process infrasound if present
    let (newCalls, newListening) = switch (infrasoundInput) {
      case (null) { (state.recentCalls, state.listeningFocus * 0.95) };
      case (?call) {
        let calls = if (state.recentCalls.size() >= 10) {
          Array.tabulate<InfrasoundComm>(9, func(i) { state.recentCalls[i + 1] })
        } else { state.recentCalls };
        (Array.append<InfrasoundComm>(calls, [call]), 1.0)
      };
    };

    // Update emotional state
    let newGrief = processGrief(state.griefLevel, false, socialInteraction);
    let newAnxiety = _clamp(
      0.9 * state.anxietyLevel + 0.1 * threatLevel,
      0.0, 1.0
    );
    let newBonding = _clamp(
      0.95 * state.bonding + 0.05 * socialInteraction,
      0.0, 1.0
    );

    // Update seismic sensing
    let newSeismic = _clamp(
      0.7 * state.groundVibration + 0.3 * seismicInput,
      0.0, 1.0
    );
    let newAlert = if (newSeismic > 0.7) {
      _clamp(state.seismicAlert + 0.2, 0.0, 1.0)
    } else {
      _clamp(state.seismicAlert - 0.1, 0.0, 1.0)
    };

    // Update herd cohesion
    let newCohesion = _clamp(
      0.9 * state.herdCohesion + 0.1 * (newBonding - newAnxiety + 0.5),
      0.0, 1.0
    );

    // Memory consolidation quality
    let newConsolidation = _clamp(
      0.95 * state.memoryConsolidation + 0.05 * (1.0 - newAnxiety),
      0.0, 1.0
    );

    // Seasonal phase advance
    let newSeason = (state.seasonalPhase + 0.0001) % 1.0;

    {
      memories = newMemories;
      memoryConsolidation = newConsolidation;
      recallAccuracy = _clamp(newConsolidation * 0.8 + 0.2, 0.0, 1.0);
      socialNetwork = state.socialNetwork;
      matriarchId = state.matriarchId;
      herdCohesion = newCohesion;
      spatialKnowledge = newSpatial;
      navigationGoal = state.navigationGoal;
      pathIntegration = state.pathIntegration;
      recentCalls = newCalls;
      callRepertoire = state.callRepertoire;
      listeningFocus = newListening;
      seismicAlert = newAlert;
      groundVibration = newSeismic;
      griefLevel = newGrief;
      anxietyLevel = newAnxiety;
      bonding = newBonding;
      seasonalPhase = newSeason;
      ageEstimate = state.ageEstimate + 1;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initElephant() : ElephantState {
    {
      memories = [];
      memoryConsolidation = 0.5;
      recallAccuracy = 0.5;
      socialNetwork = [];
      matriarchId = null;
      herdCohesion = 0.5;
      spatialKnowledge = {
        cells = Array.tabulate<Float>(256, func(_) { 0.0 });
        waterSources = [];
        dangerZones = [];
        migrationPath = [];
        currentCell = 128;
      };
      navigationGoal = null;
      pathIntegration = 0.5;
      recentCalls = [];
      callRepertoire = 5;
      listeningFocus = 0.5;
      seismicAlert = 0.0;
      groundVibration = 0.0;
      griefLevel = 0.0;
      anxietyLevel = 0.0;
      bonding = 0.5;
      seasonalPhase = 0.0;
      ageEstimate = 0;
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type ElephantSummary = {
    memoryCount       : Nat;
    recallAccuracy    : Float;
    socialNetworkSize : Nat;
    herdCohesion      : Float;
    griefLevel        : Float;
    seismicAlert      : Float;
    spatialFamiliarity: Float;
  };

  public func summary(state: ElephantState) : ElephantSummary {
    var familiarity : Float = 0.0;
    for (c in state.spatialKnowledge.cells.vals()) {
      familiarity += c;
    };
    familiarity /= 256.0;

    {
      memoryCount = state.memories.size();
      recallAccuracy = state.recallAccuracy;
      socialNetworkSize = state.socialNetwork.size();
      herdCohesion = state.herdCohesion;
      griefLevel = state.griefLevel;
      seismicAlert = state.seismicAlert;
      spatialFamiliarity = familiarity;
    }
  };

}
