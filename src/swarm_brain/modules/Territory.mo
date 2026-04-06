// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: Territory — Fibonacci Ring Expansion System
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    TERRITORY — FIBONACCI RING EXPANSION                  ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  Territory expands in Fibonacci rings from the core:                     ║
// ║    Ring 0 (core):   1 biome   — F[2] = 1                                 ║
// ║    Ring 1:          1 biome   — F[2] = 1                                 ║
// ║    Ring 2:          2 biomes  — F[3] = 2                                 ║
// ║    Ring 3:          3 biomes  — F[4] = 3                                 ║
// ║    Ring 4:          5 biomes  — F[5] = 5                                 ║
// ║    Ring 5:          8 biomes  — F[6] = 8                                 ║
// ║    Ring 6:         13 biomes  — F[7] = 13                                ║
// ║    Ring 7:         21 biomes  — F[8] = 21                                ║
// ║                                                                          ║
// ║  Total biomes at ring N = F[N+3] - 1                                     ║
// ║                                                                          ║
// ║  The 36 biomes reach max at ring ~7:                                     ║
// ║    F[10] - 1 = 55 - 1 = 54 (theoretical max)                             ║
// ║    With 4 factions, each controls ~9 biomes at equilibrium               ║
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
  
  // Fibonacci sequence
  public let F : [Nat] = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];
  
  // World configuration
  public let TOTAL_BIOMES : Nat = 36;             // 6×6 grid
  public let FACTION_COUNT : Nat = 4;
  public let BIOMES_PER_FACTION_EQUILIBRIUM : Nat = 9;  // 36/4
  
  // Expansion thresholds
  public let SURGE_THRESHOLD : Float = 0.70;      // >70% control = surge resistance
  public let CONTESTED_THRESHOLD : Float = 0.30;  // <30% = contested

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FACTION TYPE                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type FactionId = {
    #IronVeil;        // Industrial, defensive
    #EmberTide;       // Aggressive, expansionist
    #CrownOrder;      // Structured, governance
    #OriginDeep;      // Mysterious, adaptive
    #Neutral;         // Unclaimed
  };
  
  public func factionIndex(faction: FactionId) : Nat {
    switch (faction) {
      case (#IronVeil) { 0 };
      case (#EmberTide) { 1 };
      case (#CrownOrder) { 2 };
      case (#OriginDeep) { 3 };
      case (#Neutral) { 4 };
    }
  };
  
  public func factionFromIndex(index: Nat) : FactionId {
    switch (index) {
      case (0) { #IronVeil };
      case (1) { #EmberTide };
      case (2) { #CrownOrder };
      case (3) { #OriginDeep };
      case (_) { #Neutral };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BIOME TYPE                                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BiomeType = {
    #Plains;          // Balanced resources
    #Forest;          // High GAIA
    #Mountain;        // High defense
    #Desert;          // High VULCAN
    #Swamp;           // Difficult terrain
    #Coastal;         // Trade bonus
    #Volcanic;        // High ARES
    #Sacred;          // High RESONEX
    #Ruins;           // High SATURN
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BIOME STATE                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BiomeState = {
    biomeId : Nat;
    biomeType : BiomeType;
    
    // Position in 6×6 grid
    gridX : Nat;
    gridY : Nat;
    
    // Ownership
    owner : FactionId;
    controlLevel : Float;         // [0, 1] how firmly controlled
    contestedBy : [FactionId];    // Who is contesting
    
    // Ring position
    ringNumber : Nat;             // Which expansion ring
    distanceFromCore : Float;     // Distance from center
    
    // Resources
    resourceDensity : Float;      // [0, 1]
    extractionRate : Float;
    
    // Strategic value
    strategicValue : Float;       // [0, 1] importance
    neighbors : [Nat];            // Adjacent biome IDs
    
    // History
    lastConquered : Nat;          // Beat when last changed hands
    timesContested : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TERRITORY STATE                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type TerritoryState = {
    biomes : [BiomeState];
    
    // Per-faction metrics
    factionBiomeCounts : [Nat];   // Biomes per faction [4]
    factionControlPercents : [Float];  // Control % per faction [4]
    
    // Ring status per faction
    factionRings : [Nat];         // Current ring per faction [4]
    
    // Global metrics
    neutralBiomes : Nat;
    contestedBiomes : Nat;
    
    // Balance metrics
    dominantFaction : ?FactionId;
    surgeActive : Bool;           // One faction > 70%
    balanceScore : Float;         // [0, 1] how balanced
    
    // History
    lastExpansion : Nat;
    totalConquests : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FIBONACCI RING FUNCTIONS                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Biomes in a specific ring
  public func ringBiomes(ring: Nat) : Nat {
    if (ring + 2 < F.size()) { F[ring + 2] } else { F[F.size() - 1] }
  };
  
  /// Total biomes at ring N
  public func totalBiomesAtRing(ring: Nat) : Nat {
    if (ring + 4 < F.size()) { F[ring + 4] - 1 } else { 54 }
  };
  
  /// Find ring from biome count
  public func ringFromBiomeCount(count: Nat) : Nat {
    var ring : Nat = 0;
    while (totalBiomesAtRing(ring) < count and ring < 10) {
      ring += 1;
    };
    ring
  };
  
  /// Check if expansion is possible
  public func canExpand(currentRing: Nat, availableBiomes: Nat) : Bool {
    availableBiomes >= ringBiomes(currentRing + 1)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TERRITORY OPERATIONS                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Claim a biome for a faction
  public func claimBiome(
    territory: TerritoryState,
    biomeId: Nat,
    faction: FactionId,
    currentBeat: Nat
  ) : TerritoryState {
    if (biomeId >= territory.biomes.size()) {
      return territory;
    };
    
    let biome = territory.biomes[biomeId];
    let previousOwner = biome.owner;
    
    // Update biome
    let newBiomes = Array.tabulate<BiomeState>(territory.biomes.size(), func(i) {
      if (i == biomeId) {
        {
          biomeId = biome.biomeId;
          biomeType = biome.biomeType;
          gridX = biome.gridX;
          gridY = biome.gridY;
          owner = faction;
          controlLevel = 0.5;  // Start at 50% control
          contestedBy = [];
          ringNumber = biome.ringNumber;
          distanceFromCore = biome.distanceFromCore;
          resourceDensity = biome.resourceDensity;
          extractionRate = biome.extractionRate;
          strategicValue = biome.strategicValue;
          neighbors = biome.neighbors;
          lastConquered = currentBeat;
          timesContested = biome.timesContested + 1;
        }
      } else {
        territory.biomes[i]
      }
    });
    
    // Recalculate faction metrics
    let (counts, percents) = calculateFactionMetrics(newBiomes);
    let rings = calculateFactionRings(newBiomes, counts);
    let (dominant, surge) = checkDominance(percents);
    let balance = calculateBalance(percents);
    
    var neutral : Nat = 0;
    var contested : Nat = 0;
    for (b in newBiomes.vals()) {
      switch (b.owner) {
        case (#Neutral) { neutral += 1 };
        case (_) { if (b.contestedBy.size() > 0) { contested += 1 } };
      };
    };
    
    {
      biomes = newBiomes;
      factionBiomeCounts = counts;
      factionControlPercents = percents;
      factionRings = rings;
      neutralBiomes = neutral;
      contestedBiomes = contested;
      dominantFaction = dominant;
      surgeActive = surge;
      balanceScore = balance;
      lastExpansion = currentBeat;
      totalConquests = territory.totalConquests + 1;
    }
  };
  
  /// Contest a biome
  public func contestBiome(
    territory: TerritoryState,
    biomeId: Nat,
    attacker: FactionId
  ) : TerritoryState {
    if (biomeId >= territory.biomes.size()) {
      return territory;
    };
    
    let biome = territory.biomes[biomeId];
    
    // Add attacker to contested list if not already
    let contesters = Buffer.Buffer<FactionId>(4);
    var alreadyContesting = false;
    
    for (c in biome.contestedBy.vals()) {
      contesters.add(c);
      if (c == attacker) { alreadyContesting := true };
    };
    
    if (not alreadyContesting) {
      contesters.add(attacker);
    };
    
    let newBiomes = Array.tabulate<BiomeState>(territory.biomes.size(), func(i) {
      if (i == biomeId) {
        {
          biomeId = biome.biomeId;
          biomeType = biome.biomeType;
          gridX = biome.gridX;
          gridY = biome.gridY;
          owner = biome.owner;
          controlLevel = Float.max(0.0, biome.controlLevel - 0.1);  // Reduce control
          contestedBy = Buffer.toArray(contesters);
          ringNumber = biome.ringNumber;
          distanceFromCore = biome.distanceFromCore;
          resourceDensity = biome.resourceDensity;
          extractionRate = biome.extractionRate;
          strategicValue = biome.strategicValue;
          neighbors = biome.neighbors;
          lastConquered = biome.lastConquered;
          timesContested = biome.timesContested;
        }
      } else {
        territory.biomes[i]
      }
    });
    
    {
      biomes = newBiomes;
      factionBiomeCounts = territory.factionBiomeCounts;
      factionControlPercents = territory.factionControlPercents;
      factionRings = territory.factionRings;
      neutralBiomes = territory.neutralBiomes;
      contestedBiomes = territory.contestedBiomes + 1;
      dominantFaction = territory.dominantFaction;
      surgeActive = territory.surgeActive;
      balanceScore = territory.balanceScore;
      lastExpansion = territory.lastExpansion;
      totalConquests = territory.totalConquests;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     METRIC CALCULATIONS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func calculateFactionMetrics(biomes: [BiomeState]) : ([Nat], [Float]) {
    var counts = Array.init<Nat>(FACTION_COUNT, 0);
    
    for (biome in biomes.vals()) {
      let idx = factionIndex(biome.owner);
      if (idx < FACTION_COUNT) {
        counts[idx] += 1;
      };
    };
    
    let total = Float.fromInt(biomes.size());
    let percents = Array.tabulate<Float>(FACTION_COUNT, func(i) {
      Float.fromInt(counts[i]) / total
    });
    
    (Array.freeze(counts), percents)
  };
  
  func calculateFactionRings(biomes: [BiomeState], counts: [Nat]) : [Nat] {
    Array.tabulate<Nat>(FACTION_COUNT, func(i) {
      ringFromBiomeCount(counts[i])
    })
  };
  
  func checkDominance(percents: [Float]) : (?FactionId, Bool) {
    var maxPercent : Float = 0.0;
    var maxIdx : Nat = 0;
    
    var i = 0;
    while (i < percents.size()) {
      if (percents[i] > maxPercent) {
        maxPercent := percents[i];
        maxIdx := i;
      };
      i += 1;
    };
    
    let surge = maxPercent > SURGE_THRESHOLD;
    let dominant = if (maxPercent > 0.3) { ?factionFromIndex(maxIdx) } else { null };
    
    (dominant, surge)
  };
  
  func calculateBalance(percents: [Float]) : Float {
    // Balance = 1 - variance from equal distribution
    let ideal = 1.0 / Float.fromInt(FACTION_COUNT);
    var variance : Float = 0.0;
    
    for (p in percents.vals()) {
      variance += (p - ideal) * (p - ideal);
    };
    
    1.0 - Float.sqrt(variance)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initBiome(
    id: Nat,
    gridX: Nat,
    gridY: Nat
  ) : BiomeState {
    // Calculate distance from center (3, 3 in 6×6 grid)
    let dx = Float.fromInt(Int.abs(Int.fromNat(gridX) - 3));
    let dy = Float.fromInt(Int.abs(Int.fromNat(gridY) - 3));
    let distance = Float.sqrt(dx * dx + dy * dy);
    
    // Assign ring based on distance
    let ring = if (distance < 1.0) { 0 }
               else if (distance < 2.0) { 1 }
               else if (distance < 3.0) { 2 }
               else { 3 };
    
    // Calculate neighbors
    let neighbors = Buffer.Buffer<Nat>(4);
    if (gridY > 0) { neighbors.add((gridY - 1) * 6 + gridX) };  // North
    if (gridY < 5) { neighbors.add((gridY + 1) * 6 + gridX) };  // South
    if (gridX > 0) { neighbors.add(gridY * 6 + gridX - 1) };    // West
    if (gridX < 5) { neighbors.add(gridY * 6 + gridX + 1) };    // East
    
    // Assign biome type based on position
    let biomeType = switch ((gridX + gridY) % 9) {
      case (0) { #Plains };
      case (1) { #Forest };
      case (2) { #Mountain };
      case (3) { #Desert };
      case (4) { #Swamp };
      case (5) { #Coastal };
      case (6) { #Volcanic };
      case (7) { #Sacred };
      case (_) { #Ruins };
    };
    
    {
      biomeId = id;
      biomeType = biomeType;
      gridX = gridX;
      gridY = gridY;
      owner = #Neutral;
      controlLevel = 0.0;
      contestedBy = [];
      ringNumber = ring;
      distanceFromCore = distance;
      resourceDensity = 0.5 + distance * 0.1;
      extractionRate = 0.1;
      strategicValue = 1.0 - distance * 0.1;
      neighbors = Buffer.toArray(neighbors);
      lastConquered = 0;
      timesContested = 0;
    }
  };
  
  public func initTerritory() : TerritoryState {
    let biomes = Array.tabulate<BiomeState>(TOTAL_BIOMES, func(i) {
      let gridX = i % 6;
      let gridY = i / 6;
      initBiome(i, gridX, gridY)
    });
    
    {
      biomes = biomes;
      factionBiomeCounts = [0, 0, 0, 0];
      factionControlPercents = [0.0, 0.0, 0.0, 0.0];
      factionRings = [0, 0, 0, 0];
      neutralBiomes = TOTAL_BIOMES;
      contestedBiomes = 0;
      dominantFaction = null;
      surgeActive = false;
      balanceScore = 1.0;
      lastExpansion = 0;
      totalConquests = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUMMARY                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type TerritorySummary = {
    factionCounts : [Nat];
    neutralCount : Nat;
    contestedCount : Nat;
    balanceScore : Float;
    surgeActive : Bool;
  };
  
  public func summarize(territory: TerritoryState) : TerritorySummary {
    {
      factionCounts = territory.factionBiomeCounts;
      neutralCount = territory.neutralBiomes;
      contestedCount = territory.contestedBiomes;
      balanceScore = territory.balanceScore;
      surgeActive = territory.surgeActive;
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
  //  W O R L D   S I M U L A T I O N   M A T H E M A T I C S
  //
  //  Enterprise-Level World Modeling and Physics
  //  Full HIM/HER Integration for Virtual Environments
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // PHYSICS SIMULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Newtonian mechanics: F = ma
  public func worldForceToAcceleration(force : Float, mass : Float) : Float {
    if (mass < 0.0001) { 0.0 } else { force / mass }
  };

  /// Velocity update: v = v0 + a*t
  public func worldVelocityUpdate(v0 : Float, acceleration : Float, dt : Float) : Float {
    v0 + acceleration * dt
  };

  /// Position update: x = x0 + v*t + 0.5*a*t²
  public func worldPositionUpdate(x0 : Float, velocity : Float, acceleration : Float, dt : Float) : Float {
    x0 + velocity * dt + 0.5 * acceleration * dt * dt
  };

  /// Gravitational force: F = G*m1*m2/r²
  public func worldGravitationalForce(m1 : Float, m2 : Float, distance : Float, g : Float) : Float {
    if (distance < 0.0001) { 0.0 }
    else { g * m1 * m2 / (distance * distance) }
  };

  /// Drag force: F = 0.5*rho*v²*Cd*A
  public func worldDragForce(density : Float, velocity : Float, dragCoeff : Float, area : Float) : Float {
    0.5 * density * velocity * velocity * dragCoeff * area
  };

  /// Spring force: F = -k*x
  public func worldSpringForce(springConstant : Float, displacement : Float) : Float {
    -springConstant * displacement
  };

  /// Friction force: F = μ*N
  public func worldFrictionForce(frictionCoeff : Float, normalForce : Float) : Float {
    frictionCoeff * normalForce
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COLLISION DETECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// AABB collision test
  public func worldAABBCollision(
    ax1 : Float, ay1 : Float, ax2 : Float, ay2 : Float,
    bx1 : Float, by1 : Float, bx2 : Float, by2 : Float
  ) : Bool {
    ax1 <= bx2 and ax2 >= bx1 and ay1 <= by2 and ay2 >= by1
  };

  /// Circle collision test
  public func worldCircleCollision(
    x1 : Float, y1 : Float, r1 : Float,
    x2 : Float, y2 : Float, r2 : Float
  ) : Bool {
    let dx = x2 - x1;
    let dy = y2 - y1;
    let dist = Float.sqrt(dx * dx + dy * dy);
    dist < (r1 + r2)
  };

  /// Point in triangle test
  public func worldPointInTriangle(
    px : Float, py : Float,
    ax : Float, ay : Float,
    bx : Float, by : Float,
    cx : Float, cy : Float
  ) : Bool {
    func sign(p1x : Float, p1y : Float, p2x : Float, p2y : Float, p3x : Float, p3y : Float) : Float {
      (p1x - p3x) * (p2y - p3y) - (p2x - p3x) * (p1y - p3y)
    };
    let d1 = sign(px, py, ax, ay, bx, by);
    let d2 = sign(px, py, bx, by, cx, cy);
    let d3 = sign(px, py, cx, cy, ax, ay);
    let hasNeg = (d1 < 0.0) or (d2 < 0.0) or (d3 < 0.0);
    let hasPos = (d1 > 0.0) or (d2 > 0.0) or (d3 > 0.0);
    not (hasNeg and hasPos)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TERRAIN GENERATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Simple noise function (pseudo-random)
  public func worldSimpleNoise(x : Nat, y : Nat, seed : Nat) : Float {
    let n = x + y * 57 + seed * 131;
    let m = ((n * (n * n * 15731 + 789221) + 1376312589) % 2147483648);
    Float.fromInt(m % 1000000) / 1000000.0
  };

  /// Linear interpolation
  public func worldLerp(a : Float, b : Float, t : Float) : Float {
    a + t * (b - a)
  };

  /// Smooth interpolation
  public func worldSmoothStep(t : Float) : Float {
    t * t * (3.0 - 2.0 * t)
  };

  /// Height map sample
  public func worldHeightMapSample(
    x : Float, y : Float,
    octaves : Nat,
    persistence : Float,
    lacunarity : Float,
    seed : Nat
  ) : Float {
    var total : Float = 0.0;
    var amplitude : Float = 1.0;
    var frequency : Float = 1.0;
    var maxVal : Float = 0.0;
    var i = 0;
    while (i < octaves) {
      let xi = Int.abs(Float.toInt(x * frequency));
      let yi = Int.abs(Float.toInt(y * frequency));
      total += worldSimpleNoise(xi, yi, seed + i) * amplitude;
      maxVal += amplitude;
      amplitude *= persistence;
      frequency *= lacunarity;
      i += 1;
    };
    total / maxVal
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // WEATHER SIMULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Temperature model
  public func worldTemperature(
    baseTemp : Float,
    latitude : Float,
    altitude : Float,
    timeOfDay : Float
  ) : Float {
    let latFactor = Float.cos(latitude * 3.14159265 / 180.0) * 30.0;
    let altFactor = -altitude * 0.0065;
    let diurnalFactor = 5.0 * Float.sin((timeOfDay - 6.0) * 3.14159265 / 12.0);
    baseTemp + latFactor + altFactor + diurnalFactor
  };

  /// Wind speed from pressure gradient
  public func worldWindSpeed(
    pressureGradient : Float,
    coriolisFactor : Float,
    friction : Float
  ) : Float {
    pressureGradient / (coriolisFactor + friction + 0.01)
  };

  /// Precipitation probability
  public func worldPrecipitationProb(
    humidity : Float,
    temperature : Float,
    pressure : Float
  ) : Float {
    let saturation = humidity / (1.0 + Float.exp(-0.1 * (temperature - 10.0)));
    let instability = 1.0 / (pressure + 0.01);
    Float.min(saturation * instability * 2.0, 1.0)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE DISTRIBUTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Resource density based on terrain
  public func worldResourceDensity(
    terrainType : Nat,
    height : Float,
    moisture : Float
  ) : Float {
    let baseDensity = Float.fromInt(terrainType % 10) / 10.0;
    let heightFactor = 1.0 - Float.abs(height - 0.5);
    let moistureFactor = moisture;
    baseDensity * heightFactor * moistureFactor
  };

  /// Population growth model
  public func worldPopulationGrowth(
    population : Float,
    resources : Float,
    capacity : Float,
    growthRate : Float
  ) : Float {
    let resourceFactor = resources / (resources + 1.0);
    let carryingFactor = 1.0 - population / capacity;
    population * growthRate * resourceFactor * carryingFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPATIAL INDEXING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Grid cell index from position
  public func worldGridIndex(x : Float, y : Float, cellSize : Float) : (Nat, Nat) {
    let ix = Int.abs(Float.toInt(x / cellSize));
    let iy = Int.abs(Float.toInt(y / cellSize));
    (ix, iy)
  };

  /// Distance between grid cells
  public func worldGridDistance(x1 : Nat, y1 : Nat, x2 : Nat, y2 : Nat) : Float {
    let dx = Float.fromInt(if (x1 > x2) x1 - x2 else x2 - x1);
    let dy = Float.fromInt(if (y1 > y2) y1 - y2 else y2 - y1);
    Float.sqrt(dx * dx + dy * dy)
  };

  /// Morton code for Z-order curve
  public func worldMortonCode(x : Nat, y : Nat) : Nat {
    var mx = x;
    var my = y;
    var code : Nat = 0;
    var bit : Nat = 0;
    while (bit < 16) {
      code += ((mx % 2) * 2 + (my % 2)) * (4 ** bit);
      mx /= 2;
      my /= 2;
      bit += 1;
    };
    code
  };

}
