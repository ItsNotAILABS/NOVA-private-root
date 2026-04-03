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

  // ============================================================
  // HIPPOCAMPAL MEMORY SYSTEMS — COMPLETE NEURAL ARCHITECTURE
  // Place cells, grid cells, head direction cells, border cells
  // Time cells, episodic binding, pattern completion/separation
  // All mathematics explicit, all connections documented
  // ============================================================

  // ── FUNDAMENTAL CONSTANTS ──────────────────────────────────────
  let PHI : Float = 1.618033988749895;         // Golden ratio
  let PHI_INV : Float = 0.618033988749895;     // 1/φ  
  let TAU : Float = 6.283185307179586;         // 2π
  let SOVEREIGN_METAL : Float = 1.0;           // All metals at sovereign max

  // Mirror law: balance in all things
  public func mirrorLaw(x: Float) : Float {
    1.0 - x
  };

  // ── PLACE CELL SYSTEM ──────────────────────────────────────────
  // Each place cell fires when animal is at specific location
  // Gaussian firing field centered at place field

  public type PlaceCell = {
    id            : Nat;
    centerX       : Float;      // Place field center X
    centerY       : Float;      // Place field center Y
    fieldWidth    : Float;      // σ (standard deviation of field)
    peakRate      : Float;      // Maximum firing rate (Hz)
    currentRate   : Float;      // Current firing rate
    theta_phase   : Float;      // Phase precession within theta cycle
    stability     : Float;      // Field stability (0-1)
    remappingProb : Float;      // Probability of global remapping
  };

  // Place cell firing rate as function of position
  // f(x,y) = f_max × exp(-((x-x_c)² + (y-y_c)²) / (2σ²))
  public func placeCellFiringRate(
    cell: PlaceCell,
    posX: Float, posY: Float
  ) : Float {
    let dx = posX - cell.centerX;
    let dy = posY - cell.centerY;
    let distSq = dx * dx + dy * dy;
    let sigma2 = cell.fieldWidth * cell.fieldWidth;
    
    cell.peakRate * Float.exp(-distSq / (2.0 * sigma2))
  };

  // Initialize place cell population (sparse coding)
  public func initPlaceCells(nCells: Nat, arenaSize: Float) : [PlaceCell] {
    Array.tabulate<PlaceCell>(nCells, func(i) {
      // Distribute place fields across arena using PHI for spacing
      let row = i / 16;
      let col = i % 16;
      let spacing = arenaSize / 16.0;
      
      {
        id = i;
        centerX = spacing * Float.fromInt(col) + spacing / 2.0;
        centerY = spacing * Float.fromInt(row) + spacing / 2.0;
        fieldWidth = spacing * PHI_INV;  // Field width scaled by golden ratio
        peakRate = 20.0;  // Hz
        currentRate = 0.0;
        theta_phase = TAU * Float.fromInt(i % 8) / 8.0;  // Distributed phases
        stability = 0.9;
        remappingProb = 0.01;
      }
    })
  };

  // Update all place cell firing rates
  public func updatePlaceCells(
    cells: [PlaceCell],
    posX: Float, posY: Float,
    theta_phase: Float
  ) : [PlaceCell] {
    Array.map<PlaceCell, PlaceCell>(cells, func(cell) {
      let rate = placeCellFiringRate(cell, posX, posY);
      
      // Phase precession: firing phase depends on position within field
      let fieldEntry = Float.sqrt(
        (posX - cell.centerX) * (posX - cell.centerX) +
        (posY - cell.centerY) * (posY - cell.centerY)
      ) / cell.fieldWidth;
      let phaseShift = Float.min(1.0, fieldEntry) * 0.5;  // Up to 180° shift
      
      {
        id = cell.id;
        centerX = cell.centerX;
        centerY = cell.centerY;
        fieldWidth = cell.fieldWidth;
        peakRate = cell.peakRate;
        currentRate = rate;
        theta_phase = Float.mod(cell.theta_phase - phaseShift, TAU);
        stability = cell.stability;
        remappingProb = cell.remappingProb;
      }
    })
  };

  // ── GRID CELL SYSTEM ───────────────────────────────────────────
  // Hexagonal firing pattern covering entire environment
  // Multiple modules with different spatial scales

  public type GridCell = {
    id            : Nat;
    phase_x       : Float;      // Phase offset X
    phase_y       : Float;      // Phase offset Y
    gridSpacing   : Float;      // λ (distance between firing fields)
    orientation   : Float;      // θ (grid orientation in radians)
    moduleId      : Nat;        // Which grid module (different scales)
    currentRate   : Float;
    peakRate      : Float;
  };

  // Grid cell firing: hexagonal pattern
  // Uses three cosine gratings at 60° angles
  public func gridCellFiringRate(
    cell: GridCell,
    posX: Float, posY: Float
  ) : Float {
    let theta = cell.orientation;
    let lambda = cell.gridSpacing;
    
    // Three gratings at 0°, 60°, 120°
    var sum : Float = 0.0;
    var angle = 0.0;
    while (angle < 3.0) {
      let phi = theta + angle * (TAU / 6.0);  // 60° = π/3
      let projection = posX * Float.cos(phi) + posY * Float.sin(phi);
      sum += Float.cos(TAU * (projection + cell.phase_x) / lambda);
      angle += 1.0;
    };
    
    // Normalize: mean = 0, max ≈ 3 when all aligned
    let normalized = (sum / 3.0 + 1.0) / 2.0;  // Map to [0, 1]
    let thresholded = Float.max(0.0, normalized - 0.5) * 2.0;  // Sharp peaks
    
    cell.peakRate * thresholded * thresholded  // Square for sharper fields
  };

  // Initialize grid cells with multiple modules
  // Each module has spacing scaled by PHI
  public func initGridCells(nModules: Nat, cellsPerModule: Nat, baseSpacing: Float) : [GridCell] {
    var cells : [GridCell] = [];
    
    var module = 0;
    while (module < nModules) {
      // Each module has spacing scaled by PHI^module
      let spacing = baseSpacing * Float.pow(PHI, Float.fromInt(module));
      // Each module has different orientation
      let baseOrientation = Float.fromInt(module) * 7.5 * (TAU / 360.0);  // 7.5° offset
      
      var i = 0;
      while (i < cellsPerModule) {
        let phase_x = Float.fromInt(i % 4) / 4.0;
        let phase_y = Float.fromInt(i / 4) / 4.0;
        
        cells := Array.append<GridCell>(cells, [{
          id = module * cellsPerModule + i;
          phase_x = phase_x;
          phase_y = phase_y;
          gridSpacing = spacing;
          orientation = baseOrientation;
          moduleId = module;
          currentRate = 0.0;
          peakRate = 30.0;
        }]);
        
        i += 1;
      };
      module += 1;
    };
    
    cells
  };

  // ── HEAD DIRECTION SYSTEM ──────────────────────────────────────
  // Compass-like representation of facing direction
  // Ring attractor dynamics

  public type HeadDirectionCell = {
    id              : Nat;
    preferredDir    : Float;    // Preferred direction (radians)
    tuningWidth     : Float;    // σ (tuning curve width)
    currentRate     : Float;
    peakRate        : Float;
    anticipatoryGain: Float;    // Increase firing during turns
  };

  // Head direction cell firing
  // f(θ) = f_max × exp(κ × cos(θ - θ_pref))
  // von Mises distribution (circular Gaussian)
  public func headDirectionFiringRate(
    cell: HeadDirectionCell,
    currentDirection: Float,
    angularVelocity: Float
  ) : Float {
    let kappa = 1.0 / (cell.tuningWidth * cell.tuningWidth);
    let dirDiff = currentDirection - cell.preferredDir;
    
    // Anticipatory firing: shift preferred direction during turns
    let anticipation = cell.anticipatoryGain * angularVelocity;
    let adjustedDiff = dirDiff - anticipation;
    
    cell.peakRate * Float.exp(kappa * (Float.cos(adjustedDiff) - 1.0))
  };

  // Initialize head direction cells (uniform around circle)
  public func initHeadDirectionCells(nCells: Nat) : [HeadDirectionCell] {
    Array.tabulate<HeadDirectionCell>(nCells, func(i) {
      {
        id = i;
        preferredDir = TAU * Float.fromInt(i) / Float.fromInt(nCells);
        tuningWidth = TAU / Float.fromInt(nCells) * PHI_INV;  // Slight overlap
        currentRate = 0.0;
        peakRate = 40.0;
        anticipatoryGain = 0.1;  // 100ms anticipation at typical speeds
      }
    })
  };

  // Ring attractor update for head direction
  public func updateHeadDirectionAttractor(
    cells: [HeadDirectionCell],
    currentDir: Float,
    angularVel: Float,
    dt: Float
  ) : (Float, [HeadDirectionCell]) {
    // Compute population vector
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    var totalRate : Float = 0.0;
    
    let updatedCells = Array.map<HeadDirectionCell, HeadDirectionCell>(cells, func(cell) {
      let rate = headDirectionFiringRate(cell, currentDir, angularVel);
      sumSin += rate * Float.sin(cell.preferredDir);
      sumCos += rate * Float.cos(cell.preferredDir);
      totalRate += rate;
      
      { cell with currentRate = rate }
    });
    
    // Decoded direction from population
    let decodedDir = Float.atan2(sumSin, sumCos);
    
    (decodedDir, updatedCells)
  };

  // ── BORDER CELLS ───────────────────────────────────────────────
  // Fire near environmental boundaries
  
  public type BorderCell = {
    id            : Nat;
    preferredWall : WallDirection;
    fieldDistance : Float;      // Distance from wall for peak firing
    fieldWidth    : Float;      // σ
    currentRate   : Float;
    peakRate      : Float;
  };

  public type WallDirection = {
    #North;
    #South;
    #East;
    #West;
  };

  // Border cell firing based on distance to preferred wall
  public func borderCellFiringRate(
    cell: BorderCell,
    posX: Float, posY: Float,
    arenaWidth: Float, arenaHeight: Float
  ) : Float {
    let distToWall = switch (cell.preferredWall) {
      case (#North) { arenaHeight - posY };
      case (#South) { posY };
      case (#East) { arenaWidth - posX };
      case (#West) { posX };
    };
    
    let diff = distToWall - cell.fieldDistance;
    cell.peakRate * Float.exp(-diff * diff / (2.0 * cell.fieldWidth * cell.fieldWidth))
  };

  // ── TIME CELLS ─────────────────────────────────────────────────
  // Fire at specific times within an interval
  // "Mental timeline"

  public type TimeCell = {
    id            : Nat;
    preferredTime : Float;      // Preferred firing time (seconds from start)
    fieldWidth    : Float;      // Temporal receptive field width
    currentRate   : Float;
    peakRate      : Float;
    lastResetBeat : Nat;        // When timing started
  };

  // Time cell firing
  public func timeCellFiringRate(
    cell: TimeCell,
    currentTime: Float
  ) : Float {
    let diff = currentTime - cell.preferredTime;
    cell.peakRate * Float.exp(-diff * diff / (2.0 * cell.fieldWidth * cell.fieldWidth))
  };

  // Time cells follow Weber's law: later times have wider fields
  public func initTimeCells(nCells: Nat, maxInterval: Float) : [TimeCell] {
    Array.tabulate<TimeCell>(nCells, func(i) {
      let time = maxInterval * Float.fromInt(i + 1) / Float.fromInt(nCells + 1);
      {
        id = i;
        preferredTime = time;
        fieldWidth = time * 0.2;  // Weber fraction ~0.2
        currentRate = 0.0;
        peakRate = 25.0;
        lastResetBeat = 0;
      }
    })
  };

  // ── PATTERN COMPLETION ─────────────────────────────────────────
  // CA3 autoassociative network retrieves full pattern from partial cue

  public type CA3Network = {
    weights       : [[Float]];   // N×N recurrent weight matrix
    activity      : [Float];     // Current activity pattern
    threshold     : Float;       // Activation threshold
    recurrentGain : Float;       // Strength of recurrent connections
    nNeurons      : Nat;
  };

  public func initCA3(nNeurons: Nat) : CA3Network {
    {
      weights = Array.tabulate<[Float]>(nNeurons, func(_) {
        Array.tabulate<Float>(nNeurons, func(_) { 0.0 })
      });
      activity = Array.tabulate<Float>(nNeurons, func(_) { 0.0 });
      threshold = 0.5;
      recurrentGain = 0.5;
      nNeurons = nNeurons;
    }
  };

  // Store pattern using Hopfield rule
  // w_ij += (1/N) × (ξ_i - 0.5) × (ξ_j - 0.5)
  public func storePatternCA3(
    network: CA3Network,
    pattern: [Float]
  ) : CA3Network {
    let n = network.nNeurons;
    let nFloat = Float.fromInt(n);
    
    var newWeights = Array.thaw<[Float]>(network.weights);
    
    var i = 0;
    while (i < n) {
      var row = Array.thaw<Float>(network.weights[i]);
      var j = 0;
      while (j < n) {
        if (i != j) {
          let xi = if (i < pattern.size()) { pattern[i] - 0.5 } else { 0.0 };
          let xj = if (j < pattern.size()) { pattern[j] - 0.5 } else { 0.0 };
          row[j] := network.weights[i][j] + xi * xj / nFloat;
        };
        j += 1;
      };
      newWeights[i] := Array.freeze(row);
      i += 1;
    };
    
    { network with weights = Array.freeze(newWeights) }
  };

  // Pattern completion: iterate until convergence
  public func completePatternCA3(
    network: CA3Network,
    cue: [Float],
    maxIterations: Nat
  ) : [Float] {
    let n = network.nNeurons;
    var activity = Array.thaw<Float>(cue);
    
    // Pad if necessary
    while (activity.size() < n) {
      activity := Array.thaw<Float>(Array.append<Float>(Array.freeze(activity), [0.5]));
    };
    
    var iter = 0;
    var converged = false;
    
    while (iter < maxIterations and not converged) {
      var newActivity = Array.init<Float>(n, 0.0);
      var changed = false;
      
      var i = 0;
      while (i < n) {
        // Sum weighted inputs
        var input : Float = 0.0;
        var j = 0;
        while (j < n) {
          input += network.weights[i][j] * activity[j];
          j += 1;
        };
        
        // Sigmoid activation
        let rawAct = 1.0 / (1.0 + Float.exp(-10.0 * (input - network.threshold)));
        newActivity[i] := rawAct;
        
        if (Float.abs(rawAct - activity[i]) > 0.01) {
          changed := true;
        };
        
        i += 1;
      };
      
      activity := newActivity;
      converged := not changed;
      iter += 1;
    };
    
    Array.freeze(activity)
  };

  // ── PATTERN SEPARATION ─────────────────────────────────────────
  // Dentate gyrus creates orthogonal representations
  // Expansion recoding: N inputs → M outputs (M >> N)

  public type DentateGyrus = {
    nInputs       : Nat;
    nGranule      : Nat;        // ~1 million granule cells
    sparsity      : Float;      // ~2-4% active at once
    inputWeights  : [[Float]];  // Input → Granule weights
    activity      : [Float];
  };

  public func initDentateGyrus(nInputs: Nat, expansionFactor: Nat, sparsity: Float) : DentateGyrus {
    let nGranule = nInputs * expansionFactor;
    {
      nInputs = nInputs;
      nGranule = nGranule;
      sparsity = sparsity;
      inputWeights = Array.tabulate<[Float]>(nGranule, func(i) {
        // Each granule cell receives from random subset of inputs
        Array.tabulate<Float>(nInputs, func(j) {
          // Sparse random connectivity
          let seed = (i * 7919 + j * 104729) % 1000;
          if (Float.fromInt(seed) / 1000.0 < 0.1) {  // 10% connectivity
            Float.fromInt((seed * 31) % 100) / 100.0  // Random weight
          } else { 0.0 }
        })
      });
      activity = Array.tabulate<Float>(nGranule, func(_) { 0.0 });
    }
  };

  // Pattern separation: orthogonalize similar inputs
  public func separatePatternDG(
    dg: DentateGyrus,
    input: [Float]
  ) : [Float] {
    let n = dg.nGranule;
    
    // Compute all granule cell activations
    var rawActivity = Array.init<Float>(n, 0.0);
    var i = 0;
    while (i < n) {
      var sum : Float = 0.0;
      var j = 0;
      while (j < dg.nInputs and j < input.size()) {
        sum += dg.inputWeights[i][j] * input[j];
        j += 1;
      };
      rawActivity[i] := sum;
      i += 1;
    };
    
    // Winner-take-all: only top k% remain active
    // Find threshold for desired sparsity
    let nActive = Float.toInt(Float.floor(dg.sparsity * Float.fromInt(n)));
    
    // Simple k-winners: set threshold to k-th highest
    // (Simplified: use percentile estimation)
    var sortedVals : [Float] = [];
    for (v in rawActivity.vals()) {
      sortedVals := Array.append<Float>(sortedVals, [v]);
    };
    
    // Estimate threshold as mean + 2*std (rough top 5%)
    var mean : Float = 0.0;
    for (v in rawActivity.vals()) { mean += v };
    mean /= Float.fromInt(n);
    
    var variance : Float = 0.0;
    for (v in rawActivity.vals()) {
      let diff = v - mean;
      variance += diff * diff;
    };
    variance /= Float.fromInt(n);
    let std = Float.sqrt(variance);
    let threshold = mean + 2.0 * std;
    
    // Apply threshold
    Array.tabulate<Float>(n, func(k) {
      if (rawActivity[k] > threshold) { rawActivity[k] } else { 0.0 }
    })
  };

  // ── EPISODIC MEMORY BINDING ────────────────────────────────────
  // CA1 combines place, time, and item information
  // Creates unique episode representations

  public type Episode = {
    id            : Nat;
    whatBinding   : [Float];    // Item/object representation
    whereBinding  : [Float];    // Place cell pattern
    whenBinding   : [Float];    // Time cell pattern
    contextBinding: [Float];    // Contextual features
    emotionalTag  : Float;      // Emotional significance
    createdBeat   : Nat;
    lastRecallBeat: Nat;
    strength      : Float;
  };

  public type EpisodicMemorySystem = {
    episodes      : [Episode];
    ca3           : CA3Network;
    dentateGyrus  : DentateGyrus;
    
    // Binding weights
    whatToCA1     : [[Float]];
    whereToCA1    : [[Float]];
    whenToCA1     : [[Float]];
    
    // Consolidation state
    replayQueue   : [Nat];      // Episodes queued for replay
    replayActive  : Bool;
    sleepPhase    : Float;      // 0-1 within sleep cycle
    
    // Statistics
    totalEpisodes : Nat;
    totalRecalls  : Nat;
  };

  // Bind components into episode
  public func bindEpisode(
    what: [Float],
    where_: [Float],
    when: [Float],
    context: [Float],
    emotionalValue: Float,
    currentBeat: Nat
  ) : Episode {
    {
      id = currentBeat;  // Use beat as unique ID
      whatBinding = what;
      whereBinding = where_;
      whenBinding = when;
      contextBinding = context;
      emotionalTag = emotionalValue;
      createdBeat = currentBeat;
      lastRecallBeat = currentBeat;
      strength = 0.5 + Float.abs(emotionalValue) * 0.5;  // Emotional boost
    }
  };

  // Episode similarity (for retrieval)
  public func episodeSimilarity(
    ep1: Episode,
    ep2: Episode
  ) : Float {
    var sim : Float = 0.0;
    var count : Float = 0.0;
    
    // What similarity
    var i = 0;
    while (i < ep1.whatBinding.size() and i < ep2.whatBinding.size()) {
      sim += 1.0 - Float.abs(ep1.whatBinding[i] - ep2.whatBinding[i]);
      count += 1.0;
      i += 1;
    };
    
    // Where similarity
    i := 0;
    while (i < ep1.whereBinding.size() and i < ep2.whereBinding.size()) {
      sim += 1.0 - Float.abs(ep1.whereBinding[i] - ep2.whereBinding[i]);
      count += 1.0;
      i += 1;
    };
    
    if (count > 0.0) { sim / count } else { 0.0 }
  };

  // ── MEMORY REPLAY ──────────────────────────────────────────────
  // Sharp-wave ripples replay experiences for consolidation

  public type ReplayEvent = {
    episodes      : [Nat];      // Episode IDs being replayed
    compressionRatio: Float;    // How compressed (typically 5-20x)
    direction     : ReplayDirection;
    ripplePhase   : Float;
  };

  public type ReplayDirection = {
    #Forward;       // Sequential replay
    #Reverse;       // Backward replay (common after reward)
    #Random;        // Shuffle replay
  };

  // Generate replay sequence
  public func generateReplaySequence(
    episodes: [Episode],
    startIdx: Nat,
    length: Nat,
    direction: ReplayDirection
  ) : [Nat] {
    switch (direction) {
      case (#Forward) {
        Array.tabulate<Nat>(length, func(i) {
          (startIdx + i) % episodes.size()
        })
      };
      case (#Reverse) {
        Array.tabulate<Nat>(length, func(i) {
          let idx = Int.abs(startIdx - i);
          idx % episodes.size()
        })
      };
      case (#Random) {
        Array.tabulate<Nat>(length, func(i) {
          (startIdx * 7919 + i * 104729) % episodes.size()
        })
      };
    }
  };

  // Consolidation through replay
  // Strengthens replayed memories, weakens others
  public func consolidateViaReplay(
    episodes: [Episode],
    replayedIds: [Nat],
    replayStrength: Float
  ) : [Episode] {
    Array.tabulate<Episode>(episodes.size(), func(i) {
      var wasReplayed = false;
      for (id in replayedIds.vals()) {
        if (id == i) { wasReplayed := true };
      };
      
      let ep = episodes[i];
      if (wasReplayed) {
        { ep with strength = _clamp(ep.strength + replayStrength * 0.1, 0.0, 1.0) }
      } else {
        { ep with strength = _clamp(ep.strength * 0.999, 0.0, 1.0) }  // Slight decay
      }
    })
  };

  // ── SYSTEMS CONSOLIDATION ──────────────────────────────────────
  // Hippocampus → Neocortex transfer over time
  // Two-stage model: fast hippocampal, slow cortical

  public type SystemsConsolidationState = {
    hippocampalStrength : [Float];   // Per-episode hippocampal trace
    corticalStrength    : [Float];   // Per-episode cortical trace
    transferRate        : Float;      // Rate of hippocampus → cortex
    hippocampalDecay    : Float;      // Hippocampal forgetting rate
    corticalLearning    : Float;      // Cortical learning rate
  };

  // Update systems consolidation
  // dH/dt = -λ_H × H (hippocampus decays)
  // dC/dt = α × H × (1 - C) (cortex learns from hippocampus)
  public func updateSystemsConsolidation(
    state: SystemsConsolidationState,
    dt: Float
  ) : SystemsConsolidationState {
    let n = state.hippocampalStrength.size();
    
    var newHippocampal = Array.init<Float>(n, 0.0);
    var newCortical = Array.init<Float>(n, 0.0);
    
    var i = 0;
    while (i < n) {
      let h = state.hippocampalStrength[i];
      let c = state.corticalStrength[i];
      
      // Hippocampal decay
      newHippocampal[i] := h * Float.exp(-state.hippocampalDecay * dt);
      
      // Cortical learning
      let learning = state.corticalLearning * h * (1.0 - c);
      newCortical[i] := c + learning * dt;
      
      i += 1;
    };
    
    {
      hippocampalStrength = Array.freeze(newHippocampal);
      corticalStrength = Array.freeze(newCortical);
      transferRate = state.transferRate;
      hippocampalDecay = state.hippocampalDecay;
      corticalLearning = state.corticalLearning;
    }
  };

  // ── THETA RHYTHM COORDINATION ──────────────────────────────────
  // 4-8 Hz oscillation organizes hippocampal processing

  public type ThetaRhythm = {
    frequency     : Float;      // Hz (typically 6-8)
    phase         : Float;      // Current phase (0-2π)
    amplitude     : Float;      // Strength of oscillation
    
    // Phase-locking
    encodingPhase : Float;      // Phase for encoding (typically peak)
    retrievalPhase: Float;      // Phase for retrieval (typically trough)
    
    // Modulation
    speedModulation: Float;     // Running speed effect on frequency
    currentSpeed  : Float;
  };

  // Update theta rhythm
  // Frequency increases with running speed
  public func updateThetaRhythm(
    theta: ThetaRhythm,
    runningSpeed: Float,
    dt: Float
  ) : ThetaRhythm {
    // Speed modulates frequency: f = f_0 + k × speed
    let modulatedFreq = theta.frequency + theta.speedModulation * runningSpeed;
    let dPhase = TAU * modulatedFreq * dt;
    
    {
      frequency = theta.frequency;
      phase = Float.mod(theta.phase + dPhase, TAU);
      amplitude = theta.amplitude;
      encodingPhase = theta.encodingPhase;
      retrievalPhase = theta.retrievalPhase;
      speedModulation = theta.speedModulation;
      currentSpeed = runningSpeed;
    }
  };

  // Determine if in encoding or retrieval phase
  public func isEncodingPhase(theta: ThetaRhythm) : Bool {
    let phaseDiff = Float.abs(theta.phase - theta.encodingPhase);
    phaseDiff < 0.5 or phaseDiff > TAU - 0.5
  };

  // ── COMPREHENSIVE HIPPOCAMPAL STATE ────────────────────────────

  public type HippocampalState = {
    // Spatial cells
    placeCells    : [PlaceCell];
    gridCells     : [GridCell];
    headDirCells  : [HeadDirectionCell];
    borderCells   : [BorderCell];
    timeCells     : [TimeCell];
    
    // Memory systems
    episodicMemory: EpisodicMemorySystem;
    systemsConsol : SystemsConsolidationState;
    
    // Theta rhythm
    theta         : ThetaRhythm;
    
    // Current state
    positionX     : Float;
    positionY     : Float;
    headDirection : Float;
    runningSpeed  : Float;
    timeInTask    : Float;
    
    // Arena properties
    arenaWidth    : Float;
    arenaHeight   : Float;
    
    beatNum       : Nat;
  };

  // Initialize complete hippocampal system
  public func initHippocampalSystem(
    arenaWidth: Float,
    arenaHeight: Float
  ) : HippocampalState {
    {
      placeCells = initPlaceCells(256, arenaWidth);
      gridCells = initGridCells(4, 16, 0.3);  // 4 modules, 16 cells each
      headDirCells = initHeadDirectionCells(36);  // 10° resolution
      borderCells = [];  // Initialize as needed
      timeCells = initTimeCells(20, 30.0);  // 20 cells, 30 second interval
      
      episodicMemory = {
        episodes = [];
        ca3 = initCA3(100);
        dentateGyrus = initDentateGyrus(50, 10, 0.05);
        whatToCA1 = [];
        whereToCA1 = [];
        whenToCA1 = [];
        replayQueue = [];
        replayActive = false;
        sleepPhase = 0.0;
        totalEpisodes = 0;
        totalRecalls = 0;
      };
      
      systemsConsol = {
        hippocampalStrength = [];
        corticalStrength = [];
        transferRate = 0.001;
        hippocampalDecay = 0.0001;
        corticalLearning = 0.00001;
      };
      
      theta = {
        frequency = 7.0;
        phase = 0.0;
        amplitude = 1.0;
        encodingPhase = 0.0;  // Peak
        retrievalPhase = TAU / 2.0;  // Trough
        speedModulation = 0.5;
        currentSpeed = 0.0;
      };
      
      positionX = arenaWidth / 2.0;
      positionY = arenaHeight / 2.0;
      headDirection = 0.0;
      runningSpeed = 0.0;
      timeInTask = 0.0;
      arenaWidth = arenaWidth;
      arenaHeight = arenaHeight;
      beatNum = 0;
    }
  };

  // Full hippocampal beat update
  public func beatHippocampus(
    state: HippocampalState,
    newX: Float,
    newY: Float,
    newHeadDir: Float,
    dt: Float
  ) : HippocampalState {
    // Calculate movement
    let dx = newX - state.positionX;
    let dy = newY - state.positionY;
    let speed = Float.sqrt(dx * dx + dy * dy) / dt;
    let dTheta = newHeadDir - state.headDirection;
    let angularVel = dTheta / dt;
    
    // Update theta rhythm
    let newTheta = updateThetaRhythm(state.theta, speed, dt);
    
    // Update place cells
    let newPlaceCells = updatePlaceCells(state.placeCells, newX, newY, newTheta.phase);
    
    // Update head direction
    let (decodedDir, newHDCells) = updateHeadDirectionAttractor(
      state.headDirCells, newHeadDir, angularVel, dt
    );
    
    // Update time cells
    let newTimeInTask = state.timeInTask + dt;
    
    {
      state with
      placeCells = newPlaceCells;
      headDirCells = newHDCells;
      theta = newTheta;
      positionX = newX;
      positionY = newY;
      headDirection = newHeadDir;
      runningSpeed = speed;
      timeInTask = newTimeInTask;
      beatNum = state.beatNum + 1;
    }
  };

}

