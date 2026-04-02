// ============================================================
// SALMON NAVIGATION — MAGNETIC & OLFACTORY HOMING
// Geomagnetic compass, olfactory imprinting
// 3000+ mile migration accuracy
// References: Putman et al. (2014), Dittman & Quinn (1996)
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let EARTH_FIELD_STRENGTH : Float = 50.0;  // μT average
  let OLFACTORY_MEMORY_SIZE : Nat = 100;

  // ── Types ─────────────────────────────────────────────────────
  public type MagneticField = {
    intensity   : Float;    // Field strength (μT)
    inclination : Float;    // Dip angle (degrees)
    declination : Float;    // Deviation from true north
  };

  public type OlfactorySignature = {
    id          : Nat;
    compounds   : [Float];  // 8 chemical compound levels
    strength    : Float;    // Signal strength
    familiarity : Float;    // How well remembered
    location    : Nat;      // Associated location
  };

  public type MigrationGoal = {
    magneticTarget  : MagneticField;   // Target magnetic signature
    olfactoryTarget : [Float];         // Target smell profile
    distance        : Float;           // Estimated remaining distance
    direction       : Float;           // Current heading
    confidence      : Float;           // Navigation confidence
  };

  public type SalmonState = {
    // Magnetic sensing
    currentField    : MagneticField;
    magneticMemory  : [MagneticField];   // Remembered fields along route
    magneticMap     : [Float];           // 64-cell magnetic map
    compassHeading  : Float;             // Current heading from compass

    // Olfactory system
    currentSmell    : [Float];           // 8 compounds sensed now
    imprintedSmells : [OlfactorySignature];
    homeSignature   : [Float];           // Birth stream signature
    olfactoryMatch  : Float;             // How close to home smell

    // Navigation state
    migrationGoal   : MigrationGoal;
    progressToGoal  : Float;             // 0-1 journey completion
    navigationMode  : NavigationMode;

    // Position estimation (dead reckoning)
    estimatedLat    : Float;             // Latitude estimate
    estimatedLon    : Float;             // Longitude estimate
    swimSpeed       : Float;             // Current speed (m/s)
    swimDirection   : Float;             // Current direction (degrees)

    // Energy and condition
    energyReserve   : Float;             // Fat stores
    stressLevel     : Float;
    maturationLevel : Float;             // Reproductive readiness

    // Learning
    routeMemory     : [Nat];             // Waypoint sequence
    courseCorrections : Nat;             // Number of corrections made

    beatNum         : Nat;
  };

  public type NavigationMode = {
    #Oceanic;      // Open ocean, use magnetic
    #Coastal;      // Near coast, use both
    #Riverine;     // In river, use olfactory
    #Homing;       // Final approach, olfactory dominant
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float { if (x < 0.0) { -x } else { x } };
  func sqrt(x: Float) : Float { Float.sqrt(x) };

  // ══════════════════════════════════════════════════════════════
  // MAGNETIC NAVIGATION
  // Use Earth's magnetic field for position and direction
  // ══════════════════════════════════════════════════════════════

  // Compute compass heading from magnetic field
  public func computeCompassHeading(field: MagneticField) : Float {
    // Declination gives deviation from true north
    // Inclination helps determine latitude
    let heading = field.declination;
    if (heading < 0.0) { heading + 360.0 }
    else if (heading >= 360.0) { heading - 360.0 }
    else { heading }
  };

  // Estimate latitude from magnetic inclination
  public func estimateLatitude(inclination: Float) : Float {
    // tan(I) = 2 tan(λ) [simplified dipole model]
    // λ ≈ arctan(tan(I) / 2)
    let tanI = Float.tan(inclination * 0.01745);  // deg to rad
    let tanLat = tanI / 2.0;
    let latRad = Float.arctan(tanLat);
    latRad / 0.01745  // rad to deg
  };

  // Compare current position to target
  public func magneticError(current: MagneticField, target: MagneticField) : Float {
    let intensityErr = abs(current.intensity - target.intensity) / EARTH_FIELD_STRENGTH;
    let inclinationErr = abs(current.inclination - target.inclination) / 90.0;
    let declinationErr = abs(current.declination - target.declination) / 180.0;

    (intensityErr + inclinationErr + declinationErr) / 3.0
  };

  // Compute course correction needed
  public func computeCourseCorrection(
    current: MagneticField,
    target: MagneticField,
    currentHeading: Float
  ) : Float {
    // Vector to target based on field differences
    let latDiff = estimateLatitude(target.inclination) - estimateLatitude(current.inclination);
    let lonDiff = target.declination - current.declination;

    // Simple direction calculation
    let targetHeading = Float.arctan2(lonDiff, latDiff) / 0.01745;  // rad to deg
    
    var correction = targetHeading - currentHeading;
    if (correction > 180.0) { correction -= 360.0 };
    if (correction < -180.0) { correction += 360.0 };
    
    correction
  };

  // ══════════════════════════════════════════════════════════════
  // OLFACTORY NAVIGATION
  // Follow smell gradients to natal stream
  // ══════════════════════════════════════════════════════════════

  // Compute similarity between two smell signatures
  public func olfactorySimilarity(a: [Float], b: [Float]) : Float {
    var dotProduct : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;

    let n = Nat.min(a.size(), b.size());
    var i = 0;
    while (i < n) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
      i += 1;
    };

    if (normA > 0.0 and normB > 0.0) {
      dotProduct / (sqrt(normA) * sqrt(normB))
    } else { 0.0 }
  };

  // Compute smell gradient direction
  public func olfactoryGradient(
    leftSmell: [Float],
    rightSmell: [Float],
    targetSmell: [Float]
  ) : Float {
    let leftMatch = olfactorySimilarity(leftSmell, targetSmell);
    let rightMatch = olfactorySimilarity(rightSmell, targetSmell);

    // Positive = turn right, negative = turn left
    (rightMatch - leftMatch) * 45.0  // Scale to degrees
  };

  // Check if current smell matches home
  public func isHomeSmell(current: [Float], home: [Float], threshold: Float) : Bool {
    olfactorySimilarity(current, home) > threshold
  };

  // ══════════════════════════════════════════════════════════════
  // NAVIGATION MODE SELECTION
  // Switch between magnetic and olfactory based on context
  // ══════════════════════════════════════════════════════════════

  public func selectNavigationMode(
    distanceToCoast: Float,
    olfactoryStrength: Float,
    maturation: Float
  ) : NavigationMode {
    if (olfactoryStrength > 0.8 and maturation > 0.9) {
      #Homing
    } else if (olfactoryStrength > 0.5) {
      #Riverine
    } else if (distanceToCoast < 100.0) {
      #Coastal
    } else {
      #Oceanic
    }
  };

  // ══════════════════════════════════════════════════════════════
  // DEAD RECKONING
  // Estimate position from speed and direction
  // ══════════════════════════════════════════════════════════════

  public func updatePosition(
    lat: Float, lon: Float,
    speed: Float, direction: Float,
    dt: Float  // Time step in hours
  ) : (Float, Float) {
    // Simple spherical approximation
    // 1 degree latitude ≈ 111 km
    // 1 degree longitude ≈ 111 km * cos(lat)

    let distanceKm = speed * dt * 3.6;  // m/s to km/h to km

    let dirRad = direction * 0.01745;
    let dLat = distanceKm * Float.cos(dirRad) / 111.0;
    let dLon = distanceKm * Float.sin(dirRad) / (111.0 * Float.cos(lat * 0.01745));

    (lat + dLat, lon + dLon)
  };

  // ══════════════════════════════════════════════════════════════
  // FULL BEAT UPDATE
  // ══════════════════════════════════════════════════════════════

  public func beatSalmon(
    state: SalmonState,
    magneticInput: MagneticField,
    olfactoryInput: [Float],
    waterSpeed: Float
  ) : SalmonState {
    // 1. Update magnetic sensing
    let newCompass = computeCompassHeading(magneticInput);

    // 2. Compute olfactory match to home
    let newOlfactoryMatch = olfactorySimilarity(olfactoryInput, state.homeSignature);

    // 3. Select navigation mode
    let olfactoryStrength = newOlfactoryMatch;
    let distanceToCoast = 1000.0 - state.progressToGoal * 1000.0;  // Simplified
    let newMode = selectNavigationMode(distanceToCoast, olfactoryStrength, state.maturationLevel);

    // 4. Compute course correction based on mode
    let courseCorrection = switch (newMode) {
      case (#Oceanic) {
        computeCourseCorrection(magneticInput, state.migrationGoal.magneticTarget, state.swimDirection)
      };
      case (#Coastal) {
        let magCorrection = computeCourseCorrection(magneticInput, state.migrationGoal.magneticTarget, state.swimDirection);
        let olfCorrection = olfactoryGradient(
          olfactoryInput,  // Use same for both (simplified)
          olfactoryInput,
          state.homeSignature
        );
        (magCorrection + olfCorrection) / 2.0
      };
      case (#Riverine) {
        olfactoryGradient(olfactoryInput, olfactoryInput, state.homeSignature)
      };
      case (#Homing) {
        olfactoryGradient(olfactoryInput, olfactoryInput, state.homeSignature) * 2.0
      };
    };

    // 5. Update swim direction
    let newDirection = state.swimDirection + _clamp(courseCorrection, -30.0, 30.0);
    let normalizedDirection = if (newDirection < 0.0) { newDirection + 360.0 }
                              else if (newDirection >= 360.0) { newDirection - 360.0 }
                              else { newDirection };

    // 6. Update position (dead reckoning)
    let swimSpeed = _clamp(state.swimSpeed + waterSpeed * 0.1 - state.stressLevel * 0.5, 0.5, 3.0);
    let (newLat, newLon) = updatePosition(
      state.estimatedLat,
      state.estimatedLon,
      swimSpeed,
      normalizedDirection,
      0.01  // Time step
    );

    // 7. Compute progress
    let magneticErr = magneticError(magneticInput, state.migrationGoal.magneticTarget);
    let newProgress = _clamp(
      state.progressToGoal + (1.0 - magneticErr) * 0.001 + newOlfactoryMatch * 0.002,
      0.0, 1.0
    );

    // 8. Update energy (decreases with swimming)
    let newEnergy = _clamp(
      state.energyReserve - swimSpeed * 0.001 - state.stressLevel * 0.0005,
      0.0, 1.0
    );

    // 9. Update maturation (increases over time)
    let newMaturation = _clamp(state.maturationLevel + 0.0001, 0.0, 1.0);

    // 10. Update stress (increases with magnetic confusion)
    let newStress = _clamp(
      state.stressLevel * 0.99 + magneticErr * 0.1,
      0.0, 1.0
    );

    // 11. Update navigation confidence
    let newConfidence = switch (newMode) {
      case (#Oceanic) { 1.0 - magneticErr };
      case (#Coastal) { (1.0 - magneticErr + newOlfactoryMatch) / 2.0 };
      case (#Riverine) { newOlfactoryMatch };
      case (#Homing) { newOlfactoryMatch };
    };

    // 12. Track course corrections
    let newCorrections = if (abs(courseCorrection) > 5.0) {
      state.courseCorrections + 1
    } else { state.courseCorrections };

    // 13. Update migration goal
    let newGoal = {
      magneticTarget = state.migrationGoal.magneticTarget;
      olfactoryTarget = state.migrationGoal.olfactoryTarget;
      distance = state.migrationGoal.distance * (1.0 - newProgress);
      direction = normalizedDirection;
      confidence = newConfidence;
    };

    {
      currentField = magneticInput;
      magneticMemory = state.magneticMemory;
      magneticMap = state.magneticMap;
      compassHeading = newCompass;
      currentSmell = olfactoryInput;
      imprintedSmells = state.imprintedSmells;
      homeSignature = state.homeSignature;
      olfactoryMatch = newOlfactoryMatch;
      migrationGoal = newGoal;
      progressToGoal = newProgress;
      navigationMode = newMode;
      estimatedLat = newLat;
      estimatedLon = newLon;
      swimSpeed = swimSpeed;
      swimDirection = normalizedDirection;
      energyReserve = newEnergy;
      stressLevel = newStress;
      maturationLevel = newMaturation;
      routeMemory = state.routeMemory;
      courseCorrections = newCorrections;
      beatNum = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initSalmon() : SalmonState {
    {
      currentField = { intensity = 50.0; inclination = 60.0; declination = 0.0 };
      magneticMemory = [];
      magneticMap = Array.tabulate<Float>(64, func(_) { 0.0 });
      compassHeading = 0.0;
      currentSmell = Array.tabulate<Float>(8, func(_) { 0.0 });
      imprintedSmells = [];
      homeSignature = Array.tabulate<Float>(8, func(i) { Float.fromInt(i + 1) * 0.1 });
      olfactoryMatch = 0.0;
      migrationGoal = {
        magneticTarget = { intensity = 52.0; inclination = 65.0; declination = -10.0 };
        olfactoryTarget = Array.tabulate<Float>(8, func(i) { Float.fromInt(i + 1) * 0.1 });
        distance = 3000.0;
        direction = 45.0;
        confidence = 0.5;
      };
      progressToGoal = 0.0;
      navigationMode = #Oceanic;
      estimatedLat = 45.0;
      estimatedLon = -125.0;
      swimSpeed = 1.5;
      swimDirection = 45.0;
      energyReserve = 1.0;
      stressLevel = 0.0;
      maturationLevel = 0.0;
      routeMemory = [];
      courseCorrections = 0;
      beatNum = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type SalmonSummary = {
    progressToGoal    : Float;
    navigationMode    : NavigationMode;
    olfactoryMatch    : Float;
    compassHeading    : Float;
    confidence        : Float;
    energyReserve     : Float;
    courseCorrections : Nat;
  };

  public func summary(state: SalmonState) : SalmonSummary {
    {
      progressToGoal = state.progressToGoal;
      navigationMode = state.navigationMode;
      olfactoryMatch = state.olfactoryMatch;
      compassHeading = state.compassHeading;
      confidence = state.migrationGoal.confidence;
      energyReserve = state.energyReserve;
      courseCorrections = state.courseCorrections;
    }
  };

}
