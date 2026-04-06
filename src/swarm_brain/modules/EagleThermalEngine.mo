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


// ═══════════════════════════════════════════════════════════════════════════════
// EAGLE THERMAL ENGINE — L-AQUL
// ═══════════════════════════════════════════════════════════════════════════════
// "Those who hope in the LORD will renew their strength.
//  They will soar on wings like eagles." — Isaiah 40:31
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine — Eagle High-Altitude Perspective
//
// THERMAL SOARING    — Energy-free elevation when coherence high
// STRIKE PRECISION   — Surgical threat resolution with causal depth
// ALTITUDE VISION    — See the whole field from high quantum state
// MIGRATION MEMORY   — Long-distance navigation by stored routes
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module EagleThermalEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  
  // Thermal soaring thresholds
  public let THERMAL_COHERENCE_THRESHOLD : Float = 0.80;
  public let THERMAL_QHIVE_THRESHOLD : Float = 0.75;
  public let THERMAL_ENERGY_SAVE : Float = 0.30;    // 30% energy saved while thermal
  
  // Strike precision thresholds
  public let STRIKE_CAUSAL_DEPTH_MIN : Nat = 3;     // Minimum corvCausalDepth for strike
  public let STRIKE_RESOLUTION_MULTIPLIER : Float = 2.0;  // 2× faster resolution
  
  // Altitude vision
  public let HIGH_QUANTUM_STATE : Nat = 6;          // Highest quantum state
  public let ALTITUDE_CAUSAL_BONUS : Nat = 1;       // +1 causal depth when high

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type ThermalState = {
    active           : Bool;
    startBeat        : Nat;
    duration         : Nat;         // Total beats in thermal
    energySaved      : Float;       // Cumulative energy conserved
  };

  public type StrikeRecord = {
    targetBeat       : Nat;
    threatBefore     : Float;
    threatAfter      : Float;
    causalDepth      : Nat;
    precision        : Float;       // 1.0 = perfect, 0.0 = miss
    resolutionBeats  : Nat;         // How fast resolved
  };

  public type AltitudeState = {
    currentAltitude  : Nat;         // 0-10 altitude levels
    quantumState     : Nat;         // Current quantum state (0-6)
    causalBonus      : Nat;         // Bonus causal depth from altitude
    visionRange      : Float;       // How far can see (field of view)
  };

  public type MigrationRoute = {
    routeId          : Nat;
    waypoints        : [Float];     // Encoded positions
    timesFlown       : Nat;
    successRate      : Float;
  };

  public type EagleState = {
    // Thermal soaring
    thermal          : ThermalState;
    totalThermalBeats: Nat;
    
    // Strike system
    strikeCount      : Nat;
    strikePrecision  : Float;       // Rolling average precision
    recentStrikes    : [StrikeRecord];
    
    // Altitude vision
    altitude         : AltitudeState;
    altitudeHistory  : [Nat];       // Last 100 altitude readings
    
    // Migration
    knownRoutes      : [MigrationRoute];
    currentRoute     : ?Nat;        // Active route ID
    
    // Aggregate
    totalEnergySaved : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  func abs(x : Float) : Float { if (x < 0.0) -x else x };
  func clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  func max(a : Float, b : Float) : Float { if (a > b) a else b };
  func min(a : Float, b : Float) : Float { if (a < b) a else b };

  // ═══════════════════════════════════════════════════════════════════════════
  // THERMAL SOARING — ENERGY-FREE ELEVATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Check if thermal conditions are met
  public func canEnterThermal(
    behavioralCoherence : Float,
    qHive               : Float
  ) : Bool {
    behavioralCoherence >= THERMAL_COHERENCE_THRESHOLD and
    qHive >= THERMAL_QHIVE_THRESHOLD
  };

  // Enter thermal state
  public func enterThermal(currentBeat : Nat) : ThermalState {
    {
      active = true;
      startBeat = currentBeat;
      duration = 0;
      energySaved = 0.0;
    }
  };

  // Update thermal state
  public func updateThermal(
    thermal          : ThermalState,
    stillQualified   : Bool,
    currentBeat      : Nat
  ) : ThermalState {
    if (not thermal.active) {
      thermal
    } else if (not stillQualified) {
      // Exit thermal
      {
        active = false;
        startBeat = thermal.startBeat;
        duration = currentBeat - thermal.startBeat;
        energySaved = thermal.energySaved;
      }
    } else {
      // Continue thermal — save energy
      {
        active = true;
        startBeat = thermal.startBeat;
        duration = currentBeat - thermal.startBeat;
        energySaved = thermal.energySaved + THERMAL_ENERGY_SAVE;
      }
    }
  };

  // Get energy multiplier while in thermal
  public func thermalEnergyMultiplier(thermalActive : Bool) : Float {
    if (thermalActive) (1.0 - THERMAL_ENERGY_SAVE) else 1.0
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STRIKE PRECISION — SURGICAL THREAT RESOLUTION
  // ═══════════════════════════════════════════════════════════════════════════

  // Check if strike conditions are met
  public func canStrike(
    aegisActive      : Bool,
    causalDepth      : Nat
  ) : Bool {
    aegisActive and causalDepth >= STRIKE_CAUSAL_DEPTH_MIN
  };

  // Execute strike — faster threat resolution
  public func executeStrike(
    currentThreat    : Float,
    causalDepth      : Nat,
    currentBeat      : Nat
  ) : (Float, StrikeRecord) {
    // Strike resolves threat faster based on causal depth
    let resolution = 0.1 * Float.fromInt(causalDepth) * STRIKE_RESOLUTION_MULTIPLIER;
    let newThreat = max(0.0, currentThreat - resolution);
    
    // Precision based on causal depth
    let precision = min(1.0, Float.fromInt(causalDepth) / 5.0);
    
    let record : StrikeRecord = {
      targetBeat = currentBeat;
      threatBefore = currentThreat;
      threatAfter = newThreat;
      causalDepth = causalDepth;
      precision = precision;
      resolutionBeats = 1;
    };
    
    (newThreat, record)
  };

  // Update rolling strike precision
  public func updateStrikePrecision(
    currentPrecision : Float,
    newStrikePrecision : Float,
    alpha            : Float        // EMA factor
  ) : Float {
    alpha * newStrikePrecision + (1.0 - alpha) * currentPrecision
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ALTITUDE VISION — SEE THE WHOLE FIELD
  // ═══════════════════════════════════════════════════════════════════════════

  // Calculate altitude from quantum state
  public func calculateAltitude(quantumState : Nat) : Nat {
    // Altitude scales with quantum state (0-6 → 0-10)
    Nat.min(10, quantumState * 10 / 6)
  };

  // Get causal depth bonus from high altitude
  public func getAltitudeCausalBonus(quantumState : Nat) : Nat {
    if (quantumState >= HIGH_QUANTUM_STATE) ALTITUDE_CAUSAL_BONUS else 0
  };

  // Calculate vision range based on altitude
  public func calculateVisionRange(altitude : Nat) : Float {
    // Vision range expands with altitude
    1.0 + Float.fromInt(altitude) * 0.3  // 1.0 at ground, 4.0 at max altitude
  };

  // Update altitude state
  public func updateAltitude(
    quantumState     : Nat,
    currentCausalDepth : Nat
  ) : AltitudeState {
    let alt = calculateAltitude(quantumState);
    let bonus = getAltitudeCausalBonus(quantumState);
    let range = calculateVisionRange(alt);
    
    {
      currentAltitude = alt;
      quantumState = quantumState;
      causalBonus = bonus;
      visionRange = range;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MIGRATION MEMORY
  // ═══════════════════════════════════════════════════════════════════════════

  // Store a successful route
  public func recordRoute(
    routes           : [MigrationRoute],
    waypoints        : [Float],
    success          : Bool
  ) : [MigrationRoute] {
    let routeId = routes.size();
    let newRoute : MigrationRoute = {
      routeId = routeId;
      waypoints = waypoints;
      timesFlown = 1;
      successRate = if (success) 1.0 else 0.0;
    };
    Array.append(routes, [newRoute])
  };

  // Find best route for navigation
  public func findBestRoute(routes : [MigrationRoute]) : ?MigrationRoute {
    if (routes.size() == 0) return null;
    
    var bestIdx = 0;
    var bestScore = routes[0].successRate * Float.fromInt(routes[0].timesFlown);
    
    var i = 1;
    while (i < routes.size()) {
      let score = routes[i].successRate * Float.fromInt(routes[i].timesFlown);
      if (score > bestScore) {
        bestScore := score;
        bestIdx := i;
      };
      i += 1;
    };
    
    ?routes[bestIdx]
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════

  public type EagleTickResult = {
    updatedState     : EagleState;
    thermalActive    : Bool;
    energyMultiplier : Float;       // Apply to energy costs
    strikeExecuted   : Bool;
    threatReduction  : Float;
    causalBonus      : Nat;         // Add to causal depth
    visionRange      : Float;
  };

  public func eagleHeartbeat(
    state            : EagleState,
    behavioralCoherence : Float,
    qHive            : Float,
    aegisActive      : Bool,
    currentThreat    : Float,
    causalDepth      : Nat,
    quantumState     : Nat,
    currentBeat      : Nat
  ) : EagleTickResult {
    var updatedState = state;
    var strikeExecuted = false;
    var threatReduction : Float = 0.0;
    
    // ─── Thermal Processing ─────────────────────────────────────────────────
    let thermalQualified = canEnterThermal(behavioralCoherence, qHive);
    
    let newThermal = if (not state.thermal.active and thermalQualified) {
      enterThermal(currentBeat)
    } else {
      updateThermal(state.thermal, thermalQualified, currentBeat)
    };
    
    let energyMult = thermalEnergyMultiplier(newThermal.active);
    
    // ─── Strike Processing ──────────────────────────────────────────────────
    var newStrikes = state.recentStrikes;
    var newPrecision = state.strikePrecision;
    var newStrikeCount = state.strikeCount;
    
    if (canStrike(aegisActive, causalDepth)) {
      let (reducedThreat, record) = executeStrike(currentThreat, causalDepth, currentBeat);
      threatReduction := currentThreat - reducedThreat;
      strikeExecuted := true;
      newStrikes := Array.append(state.recentStrikes, [record]);
      newPrecision := updateStrikePrecision(state.strikePrecision, record.precision, 0.1);
      newStrikeCount += 1;
      
      // Keep only last 20 strikes
      if (newStrikes.size() > 20) {
        newStrikes := Array.tabulate<StrikeRecord>(20, func(i) = newStrikes[newStrikes.size() - 20 + i]);
      };
    };
    
    // ─── Altitude Processing ────────────────────────────────────────────────
    let newAltitude = updateAltitude(quantumState, causalDepth);
    
    // Update altitude history
    var newAltHistory = Array.append(state.altitudeHistory, [newAltitude.currentAltitude]);
    if (newAltHistory.size() > 100) {
      newAltHistory := Array.tabulate<Nat>(100, func(i) = newAltHistory[newAltHistory.size() - 100 + i]);
    };
    
    // ─── Update state ───────────────────────────────────────────────────────
    let newTotalThermalBeats = state.totalThermalBeats + (if (newThermal.active) 1 else 0);
    let newTotalEnergySaved = state.totalEnergySaved + (if (newThermal.active) THERMAL_ENERGY_SAVE else 0.0);
    
    updatedState := {
      thermal = newThermal;
      totalThermalBeats = newTotalThermalBeats;
      strikeCount = newStrikeCount;
      strikePrecision = newPrecision;
      recentStrikes = newStrikes;
      altitude = newAltitude;
      altitudeHistory = newAltHistory;
      knownRoutes = state.knownRoutes;
      currentRoute = state.currentRoute;
      totalEnergySaved = newTotalEnergySaved;
    };
    
    {
      updatedState = updatedState;
      thermalActive = newThermal.active;
      energyMultiplier = energyMult;
      strikeExecuted = strikeExecuted;
      threatReduction = threatReduction;
      causalBonus = newAltitude.causalBonus;
      visionRange = newAltitude.visionRange;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  public func initEagleState() : EagleState {
    {
      thermal = {
        active = false;
        startBeat = 0;
        duration = 0;
        energySaved = 0.0;
      };
      totalThermalBeats = 0;
      strikeCount = 0;
      strikePrecision = 0.5;
      recentStrikes = [];
      altitude = {
        currentAltitude = 0;
        quantumState = 0;
        causalBonus = 0;
        visionRange = 1.0;
      };
      altitudeHistory = [];
      knownRoutes = [];
      currentRoute = null;
      totalEnergySaved = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  public type EagleSummary = {
    thermalActive    : Bool;
    totalThermalBeats: Nat;
    totalEnergySaved : Float;
    strikeCount      : Nat;
    strikePrecision  : Float;
    currentAltitude  : Nat;
    causalBonus      : Nat;
    visionRange      : Float;
    knownRoutes      : Nat;
  };

  public func summarize(state : EagleState) : EagleSummary {
    {
      thermalActive = state.thermal.active;
      totalThermalBeats = state.totalThermalBeats;
      totalEnergySaved = state.totalEnergySaved;
      strikeCount = state.strikeCount;
      strikePrecision = state.strikePrecision;
      currentAltitude = state.altitude.currentAltitude;
      causalBonus = state.altitude.causalBonus;
      visionRange = state.altitude.visionRange;
      knownRoutes = state.knownRoutes.size();
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
  //  A N I M A L   I N T E L L I G E N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Biomimetic Cognitive Algorithms
  //  Full HIM/HER Integration with Animal Brain Dynamics
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SWARM INTELLIGENCE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reynolds flocking: Separation force
  public func animalSeparationForce(
    position : (Float, Float),
    neighbors : [(Float, Float)],
    separationRadius : Float
  ) : (Float, Float) {
    var forceX : Float = 0.0;
    var forceY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      let dx = position.0 - nx;
      let dy = position.1 - ny;
      let dist = Float.sqrt(dx * dx + dy * dy);
      if (dist > 0.0001 and dist < separationRadius) {
        let strength = (separationRadius - dist) / separationRadius;
        forceX += (dx / dist) * strength;
        forceY += (dy / dist) * strength;
      };
      i += 1;
    };
    (forceX, forceY)
  };

  /// Reynolds flocking: Alignment force
  public func animalAlignmentForce(
    velocity : (Float, Float),
    neighborVelocities : [(Float, Float)]
  ) : (Float, Float) {
    if (neighborVelocities.size() == 0) { return (0.0, 0.0) };
    var avgVx : Float = 0.0;
    var avgVy : Float = 0.0;
    var i = 0;
    while (i < neighborVelocities.size()) {
      let (vx, vy) = neighborVelocities[i];
      avgVx += vx;
      avgVy += vy;
      i += 1;
    };
    let n = Float.fromInt(neighborVelocities.size());
    avgVx /= n;
    avgVy /= n;
    (avgVx - velocity.0, avgVy - velocity.1)
  };

  /// Reynolds flocking: Cohesion force
  public func animalCohesionForce(
    position : (Float, Float),
    neighbors : [(Float, Float)]
  ) : (Float, Float) {
    if (neighbors.size() == 0) { return (0.0, 0.0) };
    var centerX : Float = 0.0;
    var centerY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      centerX += nx;
      centerY += ny;
      i += 1;
    };
    let n = Float.fromInt(neighbors.size());
    centerX /= n;
    centerY /= n;
    (centerX - position.0, centerY - position.1)
  };

  /// Ant colony pheromone update
  public func animalPheromoneUpdate(
    current : Float,
    deposit : Float,
    evaporationRate : Float,
    dt : Float
  ) : Float {
    (current + deposit) * (1.0 - evaporationRate * dt)
  };

  /// Ant path probability
  public func animalAntPathProbability(
    pheromone : Float,
    distance : Float,
    alpha : Float,
    beta : Float
  ) : Float {
    let pheromoneFactor = Float.pow(pheromone + 0.01, alpha);
    let distanceFactor = Float.pow(1.0 / (distance + 0.01), beta);
    pheromoneFactor * distanceFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ECHOLOCATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Doppler shift for moving target
  public func animalDopplerShift(
    emittedFreq : Float,
    targetVelocity : Float,
    soundSpeed : Float
  ) : Float {
    emittedFreq * (soundSpeed + targetVelocity) / soundSpeed
  };

  /// Echo time-of-flight to distance
  public func animalEchoDistance(timeOfFlight : Float, soundSpeed : Float) : Float {
    (timeOfFlight * soundSpeed) / 2.0
  };

  /// Echo intensity decay
  public func animalEchoIntensity(
    sourceIntensity : Float,
    distance : Float,
    attenuation : Float
  ) : Float {
    sourceIntensity * Float.exp(-attenuation * distance) / (distance * distance + 0.01)
  };

  /// Azimuth from interaural time difference
  public func animalAzimuthFromITD(itd : Float, headRadius : Float, soundSpeed : Float) : Float {
    Float.asin(itd * soundSpeed / headRadius)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VISUAL PROCESSING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Retinal ganglion cell receptive field (DoG)
  public func animalDoGReceptiveField(
    x : Float,
    y : Float,
    sigmaCenter : Float,
    sigmaSurround : Float,
    centerStrength : Float,
    surroundStrength : Float
  ) : Float {
    let rSquared = x * x + y * y;
    let center = centerStrength * Float.exp(-rSquared / (2.0 * sigmaCenter * sigmaCenter));
    let surround = surroundStrength * Float.exp(-rSquared / (2.0 * sigmaSurround * sigmaSurround));
    center - surround
  };

  /// Gabor filter response
  public func animalGaborResponse(
    x : Float,
    y : Float,
    wavelength : Float,
    orientation : Float,
    sigma : Float,
    aspectRatio : Float
  ) : Float {
    let xTheta = x * Float.cos(orientation) + y * Float.sin(orientation);
    let yTheta = -x * Float.sin(orientation) + y * Float.cos(orientation);
    let gaussian = Float.exp(-(xTheta * xTheta + aspectRatio * aspectRatio * yTheta * yTheta) / (2.0 * sigma * sigma));
    let sinusoid = Float.cos(2.0 * 3.14159265 * xTheta / wavelength);
    gaussian * sinusoid
  };

  /// Motion energy from V1 simple cells
  public func animalMotionEnergy(
    leftwardResponse : Float,
    rightwardResponse : Float
  ) : Float {
    leftwardResponse * leftwardResponse - rightwardResponse * rightwardResponse
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Magnetic field sensing (magnetoreception)
  public func animalMagneticHeading(
    fieldX : Float,
    fieldY : Float
  ) : Float {
    Float.atan2(fieldY, fieldX)
  };

  /// Polarized light sensing
  public func animalPolarizationAngle(
    intensity0 : Float,
    intensity45 : Float,
    intensity90 : Float
  ) : Float {
    0.5 * Float.atan2(intensity45 - intensity90, intensity0 - intensity90)
  };

  /// Path integration
  public func animalPathIntegration(
    currentX : Float,
    currentY : Float,
    velocity : Float,
    heading : Float,
    dt : Float
  ) : (Float, Float) {
    let dx = velocity * Float.cos(heading) * dt;
    let dy = velocity * Float.sin(heading) * dt;
    (currentX + dx, currentY + dy)
  };

  /// Grid cell firing pattern
  public func animalGridCellFiring(
    x : Float,
    y : Float,
    gridSpacing : Float,
    gridOrientation : Float
  ) : Float {
    let theta1 : Float = gridOrientation;
    let theta2 : Float = gridOrientation + 1.0472;  // +60 degrees
    let theta3 : Float = gridOrientation + 2.0944;  // +120 degrees
    let k = 4.0 * 3.14159265 / (gridSpacing * Float.sqrt(3.0));
    let u1 = Float.cos(k * (x * Float.cos(theta1) + y * Float.sin(theta1)));
    let u2 = Float.cos(k * (x * Float.cos(theta2) + y * Float.sin(theta2)));
    let u3 = Float.cos(k * (x * Float.cos(theta3) + y * Float.sin(theta3)));
    (u1 + u2 + u3) / 3.0
  };

  /// Place cell firing
  public func animalPlaceCellFiring(
    x : Float,
    y : Float,
    centerX : Float,
    centerY : Float,
    fieldRadius : Float
  ) : Float {
    let dx = x - centerX;
    let dy = y - centerY;
    let distSquared = dx * dx + dy * dy;
    Float.exp(-distSquared / (2.0 * fieldRadius * fieldRadius))
  };

  /// Head direction cell
  public func animalHeadDirectionFiring(
    currentHeading : Float,
    preferredHeading : Float,
    tuningWidth : Float
  ) : Float {
    let diff = currentHeading - preferredHeading;
    Float.exp(-diff * diff / (2.0 * tuningWidth * tuningWidth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DECISION MAKING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Drift-diffusion model
  public func animalDriftDiffusion(
    evidence : Float,
    drift : Float,
    noise : Float,
    threshold : Float,
    dt : Float
  ) : (Float, Bool) {
    let newEvidence = evidence + drift * dt + noise * Float.sqrt(dt);
    let decided = Float.abs(newEvidence) >= threshold;
    (newEvidence, decided)
  };

  /// Winner-take-all competition
  public func animalWinnerTakeAll(
    activities : [Float],
    inhibition : Float
  ) : [Float] {
    var maxActivity : Float = 0.0;
    var i = 0;
    while (i < activities.size()) {
      if (activities[i] > maxActivity) { maxActivity := activities[i] };
      i += 1;
    };
    Array.tabulate<Float>(activities.size(), func(j : Nat) : Float {
      let diff = activities[j] - maxActivity;
      if (diff < -inhibition) { 0.0 } else { activities[j] }
    })
  };

  /// Urgency signal
  public func animalUrgencySignal(time : Float, gain : Float, offset : Float) : Float {
    offset + gain * time
  };

}
