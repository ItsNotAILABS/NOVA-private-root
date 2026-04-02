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

}
