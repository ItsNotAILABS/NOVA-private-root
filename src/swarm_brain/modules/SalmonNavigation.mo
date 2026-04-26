// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — SALMON NAVIGATION ENGINE
// COMPREHENSIVE GEOMAGNETIC, OLFACTORY, AND CELESTIAL NAVIGATION
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — SALMON NAVIGATION: MULTI-MODAL SPATIAL INTELLIGENCE
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: GEOMAGNETIC NAVIGATION ──────────────────────────────────────────
//   Earth's magnetic field provides two navigational parameters:
//   Inclination angle I: angle of field vector with horizontal plane
//     tan(I) = 2 tan(λ)  where λ = magnetic latitude
//   Total field intensity B: measured in nanotesla (nT)
//     B = B_equator × √(1 + 3sin²(λ)) / cos⁶(λ)
//   These two parameters (I, B) define a unique bicoordinate position
//   on Earth's surface — the MAGNETIC MAP
//   Salmon's magnetite crystals in ethmoid region detect:
//     ΔB/Δx (spatial gradient of field intensity)
//     ΔI/Δx (spatial gradient of inclination)
//   Navigational accuracy: ±50 km using geomagnetic map
//   NOVA sovereign magnetic position:
//   X_mag = [I, B] — 2D magnetic coordinate vector
//   Target: X_home = [I_home, B_home] (memorized magnetic signature of birth river)
//   Error: ε_mag = ‖X_current - X_home‖
//   Guidance: head toward direction of decreasing ε_mag
//
// ── LAYER 2: OLFACTORY HOMING ─────────────────────────────────────────────────
//   Chemical imprinting during juvenile development (smoltification)
//   Each river has unique chemical signature: psi = [c₁, c₂, ..., c_K]
//   c_k = concentration of compound k (amino acids, bile acids, minerals)
//   Salmon's olfactory bulb has ~10,000 receptor types (humans: ~400)
//   Chemical detection threshold: C_min ~ 10⁻¹⁴ mol/L (parts per quadrillion)
//   Olfactory concentration gradient: ∂c/∂x (upstream gradient)
//   Chemotaxis: upstream movement follows ∂c/∂x > 0
//   Concentration gradient navigation equation:
//   v_olfactory = v_max × tanh(|∇c| / C₀) × sign(∇c · v̂_upstream)
//   C₀ = characteristic concentration gradient (half-saturation)
//   Turbulent dispersion: c(x,t) = Q/(4πDt) × exp(-x²/(4Dt))  (Fickian diffusion)
//   D = turbulent diffusion coefficient, Q = source strength
//
// ── LAYER 3: CELESTIAL NAVIGATION ────────────────────────────────────────────
//   Sun compass: azimuth angle A_sun(t) changes throughout the day
//   A_sun = arctan(sin(H) / [cos(H)sin(φ) - tan(δ)cos(φ)])
//   H = hour angle = (LST - RA_sun) × 15°/hr
//   phi = latitude, δ = sun's declination
//   Time compensation: salmon has internal circadian clock
//   Correction: A_correct(t) = A_sun(t) + dA/dt × (t - t_observed)
//   dA/dt ≈ 15°/hr (Earth's rotation rate)
//   Star navigation (night): use pole star for North reference
//   Polarized light (overcast): detect E-vector pattern in sky dome
//   Scattered light polarization: maximum at 90° from sun position
//   Salmon pineal detects this pattern even on cloudy days
//
// ── LAYER 4: KALMAN FILTER SENSOR FUSION ─────────────────────────────────────
//   State vector: x = [lat, lon, heading, speed, depth]  (5D)
//   State transition: x_{k+1} = F × x_k + B × u_k + w_k
//   Observation model: z_k = H × x_k + v_k
//   F = transition matrix, H = observation matrix
//   Process noise: w_k ~ N(0, Q)
//   Measurement noise: v_k ~ N(0, R)
//   Kalman prediction:
//   x̂⁻_k = F × x̂_{k-1} + B × u_{k-1}
//   P⁻_k = F × P_{k-1} × Fᵀ + Q
//   Kalman update:
//   K_k = P⁻_k × Hᵀ × (H × P⁻_k × Hᵀ + R)⁻¹
//   x̂_k = x̂⁻_k + K_k × (z_k - H × x̂⁻_k)
//   P_k = (I - K_k × H) × P⁻_k
//   Innovation (prediction error): ν_k = z_k - H × x̂⁻_k
//   Salmon fuses: geomagnetic + olfactory + celestial → optimal position estimate
//
// ── LAYER 5: HYDRODYNAMIC SENSING ─────────────────────────────────────────────
//   Lateral line system: detects water flow velocity and pressure
//   Canal neuromasts: dP/dx (pressure gradient → current speed)
//   Surface neuromasts: ∂v/∂z (velocity shear near skin)
//   Rheotaxis: swim upstream against current (negative geotaxis)
//   Flow velocity detection threshold: 0.01 m/s
//   Vortex detection: Kármán streets behind obstacles
//   Vortex spacing: λ_K = 0.28 D / St  where St ≈ 0.21 (Strouhal number)
//   Energy harvesting: extract energy from vortices (saves 20% ATP)
//   NOVA: hydrodynamic sensing maps to current market flow patterns
//
// ── LAYER 6: MIGRATION ROUTE OPTIMIZATION ────────────────────────────────────
//   Total path cost: J = ∫₀ᵀ [E(v(t)) + C_risk(x(t))] dt
//   E(v) = metabolic cost of swimming at velocity v
//   Swimming cost: E(v) = E₀ + α v² + β v³  (drag-dominated)
//   Optimal velocity: v* = argmin E(v)/v = √(E₀/β) (minimize cost/distance)
//   C_risk = predation risk along path (function of habitat)
//   Dynamic programming: backward induction over route
//   V_T(x) = 0 (arrive home)
//   V_t(x) = min_v [E(v) + C_risk(x) + V_{t+1}(f(x,v))]
//   Optimal heading: θ* = argmin V(next_state)
//
// ── LAYER 7: MEDINA SALMON NAVIGATION INDEX ───────────────────────────────────
//   N_salmon = S₀ × [ε_mag_inv × Φ_M + olfactory_signal] / Ω
//   ε_mag_inv = 1 - ε_mag/ε_max (how close to home magnetically)
//   olfactory_signal = chemical match to home signature [0,1]
//   N_salmon ∈ [0, S₀(Φ_M + 1)/Ω] = [0, 0.441]
//   When N_salmon > COHERENCE_ALIVE (0.36): navigation is sovereign
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 1: CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════

  public let PHI_MEDINA       : Float = 2.97442179;
  public let S0               : Float = 1.0;
  public let SOVEREIGN_CEILING: Float = 9.0;
  public let COHERENCE_ALIVE  : Float = 0.36;
  public let EPSILON          : Float = 1.0e-10;
  public let PI               : Float = 3.141592653589793;

  // Geomagnetic constants
  public let B_EQUATOR        : Float = 30000.0;    // nT Earth equatorial field
  public let I_EQUATOR        : Float = 0.0;        // inclination at equator (degrees)
  public let I_POLE           : Float = 90.0;       // inclination at poles
  public let B_ERROR_SIGMA    : Float = 200.0;      // nT magnetometer noise
  public let I_ERROR_SIGMA    : Float = 0.5;        // degrees inclination noise

  // Olfactory constants
  public let N_ODOR_COMPOUNDS : Nat   = 12;         // chemical compounds in river signature
  public let C_MIN_DETECT     : Float = 1.0e-14;    // mol/L detection threshold
  public let C_HALF_SAT       : Float = 1.0e-12;    // C₀ half-saturation constant
  public let DIFFUSION_COEFF  : Float = 0.01;       // m²/s turbulent diffusion
  public let V_OLFACTORY_MAX  : Float = 2.0;        // m/s max olfactory-driven speed

  // Celestial navigation
  public let EARTH_ROT_DEG_HR : Float = 15.0;       // degrees/hour Earth rotation
  public let SUN_DECL_MAX     : Float = 23.45;      // degrees max solar declination

  // Swimming mechanics
  public let SWIM_COST_BASE   : Float = 0.001;      // E₀ (W/kg basal swimming cost)
  public let SWIM_COST_ALPHA  : Float = 0.0005;     // α v² coefficient
  public let SWIM_COST_BETA   : Float = 0.0002;     // β v³ coefficient
  public let SWIM_V_MAX       : Float = 5.0;        // m/s maximum swim speed
  public let SWIM_V_OPTIMAL   : Float = 1.5;        // m/s optimal cruising speed
  public let SWIM_EFFICIENCY  : Float = 0.25;       // muscle energy efficiency

  // Kalman filter dimensions
  public let KF_STATE_DIM     : Nat = 5;            // [lat, lon, heading, speed, depth]
  public let KF_OBS_DIM       : Nat = 4;            // [B, I, olfactory_match, sun_angle]

  // Navigation accuracy targets
  public let NAV_ACCURACY_M   : Float = 1000.0;     // target: within 1km of home
  public let MAX_RANGE_M      : Float = 5000000.0;  // max navigation range (5000km)

  public let HIST_MAX         : Nat = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type MagneticSignature = {
    inclination   : Float;   // I (degrees)
    intensity     : Float;   // B (nT)
    declination   : Float;   // D (degrees) — angle from geographic north
    gradient_I    : Float;   // ∂I/∂x (degrees/km)
    gradient_B    : Float;   // ∂B/∂x (nT/km)
    latitudeEst   : Float;   // estimated magnetic latitude
    errorMeters   : Float;   // estimated position error from magnetic alone
  };

  public type OlfactorySignal = {
    concentrations   : [Float];  // 12 compounds, mol/L each
    homeSignature    : [Float];  // imprinted home chemical signature
    matchScore       : Float;    // cosine similarity to home [0,1]
    gradientStrength : Float;    // |∇c| — how strong the concentration gradient is
    upstreamDir      : Float;    // heading toward increasing concentration (degrees)
    distanceEst      : Float;    // estimated distance from home based on concentration
  };

  public type CelestialFix = {
    sunAzimuth    : Float;   // A_sun (degrees from N)
    hourAngle     : Float;   // H (degrees)
    declination   : Float;   // δ solar declination (degrees)
    timeOfDay     : Float;   // fractional hours 0-24
    northHeading  : Float;   // estimated true north from sun compass (degrees)
    polarizationE : Float;   // E-vector orientation from sky polarization
    isNight       : Bool;
    starNorth     : Float;   // North from pole star (night navigation)
  };

  public type NavigationState = {
    // Current best position estimate [lat, lon, heading, speed, depth]
    position      : [Float];   // 5-element state vector

    // Kalman filter covariance (5×5 flattened)
    covariance    : [Float];

    // Individual sensor readings
    magnetic      : MagneticSignature;
    olfactory     : OlfactorySignal;
    celestial     : CelestialFix;

    // Fused navigation
    headingBest   : Float;   // degrees — best heading toward home
    distanceHome  : Float;   // meters — estimated distance to home
    navConfidence : Float;   // [0,1] — confidence in navigation

    // Swimming state
    swimSpeed     : Float;   // current speed m/s
    swimHeading   : Float;   // current heading degrees
    metabolicCost : Float;   // W/kg current cost
    energyBudget  : Float;   // remaining energy [0,1]

    // Hydrodynamic
    currentSpeed  : Float;   // water flow speed m/s
    currentDir    : Float;   // water flow direction degrees
    vortexEnergy  : Float;   // energy harvestable from vortices [0,1]

    // Sovereign navigation index
    salmonNavIndex: Float;

    // History
    posHistory    : [Float];
    headingHistory: [Float];
    beatNum       : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };

  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _atan2(y : Float, x : Float) : Float { Float.arctan2(y, x) };
  func _tan(x : Float) : Float { Float.sin(x) / (Float.cos(x) + EPSILON) };

  func _deg2rad(d : Float) : Float { d * PI / 180.0 };
  func _rad2deg(r : Float) : Float { r * 180.0 / PI };

  func _tanh(x : Float) : Float {
    let e2x = Float.exp(_clamp(2.0 * x, -100.0, 100.0));
    (e2x - 1.0) / (e2x + 1.0)
  };

  func _cosSimilarity(a : [Float], b : [Float]) : Float {
    let n = if (a.size() < b.size()) a.size() else b.size();
    var dot : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    var i : Nat = 0;
    while (i < n) {
      dot  += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
      i += 1;
    };
    let denom = _sqrt(normA) * _sqrt(normB);
    if (denom < EPSILON) 0.0 else _clamp(dot / denom, -1.0, 1.0)
  };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: GEOMAGNETIC NAVIGATION
  // B = B_equator × √(1 + 3sin²λ) / cos⁶λ  (dipole field)
  // tan(I) = 2 tan(λ)  (inclination from latitude)
  // ══════════════════════════════════════════════════════════════════════════

  // Theoretical inclination from magnetic latitude λ (degrees)
  // tan(I) = 2 tan(λ)
  public func inclinationFromLatitude(latitude_deg : Float) : Float {
    let lat = _deg2rad(latitude_deg);
    _rad2deg(Float.arctan(2.0 * _tan(lat)))
  };

  // Theoretical field intensity at magnetic latitude λ (dipole model)
  // B(λ) = B_equator × √(1 + 3sin²λ) / cos⁶λ
  public func fieldIntensity(latitude_deg : Float) : Float {
    let lat = _deg2rad(latitude_deg);
    let sinLat = _sin(lat);
    let cosLat = _cos(lat);
    if (_abs(cosLat) < EPSILON) { return B_EQUATOR * 2.0 };
    let cos6 = cosLat * cosLat * cosLat * cosLat * cosLat * cosLat;
    B_EQUATOR * _sqrt(1.0 + 3.0 * sinLat * sinLat) / cos6
  };

  // Inverse: estimate latitude from measured inclination
  // I = arctan(2 tan λ) → λ = arctan(tan(I)/2)
  public func latitudeFromInclination(inclination_deg : Float) : Float {
    let I = _deg2rad(inclination_deg);
    _rad2deg(Float.arctan(_tan(I) / 2.0))
  };

  // Magnetic position error from (I_meas, B_meas) vs (I_home, B_home)
  public func magneticPositionError(
    I_meas : Float, B_meas : Float,
    I_home : Float, B_home : Float
  ) : Float {
    // Error in two-parameter space (normalized)
    let dI = (I_meas - I_home) / (I_POLE + EPSILON);
    let dB = (B_meas - B_home) / (B_EQUATOR * 2.0 + EPSILON);
    _sqrt(dI * dI + dB * dB) * MAX_RANGE_M
  };

  // Compute magnetic signature from position
  public func computeMagneticSignature(
    latitude_deg : Float,
    addNoise     : Float  // noise level (0 = perfect)
  ) : MagneticSignature {
    let I = inclinationFromLatitude(latitude_deg) + addNoise * I_ERROR_SIGMA;
    let B = fieldIntensity(latitude_deg) + addNoise * B_ERROR_SIGMA;
    let latEst = latitudeFromInclination(I);
    let grad_I = 0.5 / (latitude_deg + EPSILON);  // dI/dλ ≈ 1/cos²(λ)
    let grad_B = 100.0 / (latitude_deg + EPSILON); // dB/dλ approximate
    let errorM = (I_ERROR_SIGMA / (_abs(grad_I) + EPSILON)) * 111000.0;  // 1° lat = 111km

    {
      inclination  = I;
      intensity    = B;
      declination  = 0.0;   // simplified (no declination correction)
      gradient_I   = grad_I;
      gradient_B   = grad_B;
      latitudeEst  = latEst;
      errorMeters  = errorM;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: OLFACTORY NAVIGATION
  // Chemotaxis: follow ∇c toward home signature
  // Concentration gradient: ∂c/∂x from turbulent diffusion model
  // ══════════════════════════════════════════════════════════════════════════

  // Turbulent diffusion concentration at distance x from source
  // c(x,t) = Q/(4πDt) × exp(-x²/(4Dt))  [1D Fickian]
  public func odorConcentration(sourceStrength : Float, distance_m : Float, time_s : Float) : Float {
    if (time_s < EPSILON or distance_s < EPSILON) { return sourceStrength };
    let t = time_s;
    let prefactor = sourceStrength / (4.0 * PI * DIFFUSION_COEFF * t);
    let exponent  = -(distance_m * distance_m) / (4.0 * DIFFUSION_COEFF * t);
    prefactor * Float.exp(_clamp(exponent, -100.0, 0.0))
  };

  // Olfactory match score: cosine similarity to imprinted home signature
  public func olfactoryMatch(current : [Float], homeSignature : [Float]) : Float {
    let raw = _cosSimilarity(current, homeSignature);
    _clamp((raw + 1.0) / 2.0, 0.0, 1.0)  // shift from [-1,1] to [0,1]
  };

  // Chemotaxis velocity: v = v_max × tanh(|∇c| / C₀) × upstream_sign
  public func chemotaxisVelocity(gradMag : Float, upstreamSign : Float) : Float {
    V_OLFACTORY_MAX * _tanh(gradMag / (C_HALF_SAT + EPSILON)) * upstreamSign
  };

  // Estimate distance to home from concentration (inverse diffusion)
  public func estimateDistanceFromOdor(concentration : Float, sourceStrength : Float, time_s : Float) : Float {
    if (concentration < EPSILON or sourceStrength < EPSILON) { return MAX_RANGE_M };
    // c ≈ Q / (4πDt) × exp(-x²/(4Dt))  → x = √(-4Dt × ln(c × 4πDt / Q))
    let prefactor = 4.0 * PI * DIFFUSION_COEFF * time_s;
    if (prefactor < EPSILON) { return MAX_RANGE_M };
    let ratio = concentration * prefactor / sourceStrength;
    if (ratio <= 0.0 or ratio >= 1.0) { return MAX_RANGE_M };
    let x = _sqrt(-4.0 * DIFFUSION_COEFF * time_s * Float.log(ratio));
    _clamp(x, 0.0, MAX_RANGE_M)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: CELESTIAL NAVIGATION
  // Sun azimuth from hour angle H, declination δ, latitude φ
  // ══════════════════════════════════════════════════════════════════════════

  // Solar azimuth from hour angle, declination, latitude
  // A = arctan(sin(H) / [cos(H)sin(φ) - tan(δ)cos(φ)])
  public func solarAzimuth(hourAngle_deg : Float, declination_deg : Float, latitude_deg : Float) : Float {
    let H = _deg2rad(hourAngle_deg);
    let delta = _deg2rad(declination_deg);
    let phi = _deg2rad(latitude_deg);
    let y = _sin(H);
    let x = _cos(H) * _sin(phi) - _tan(delta) * _cos(phi);
    let A = _rad2deg(_atan2(y, x));
    // Normalize to [0, 360)
    let normalized = if (A < 0.0) A + 360.0 else A;
    _clamp(normalized, 0.0, 360.0)
  };

  // Solar declination as function of day of year
  // δ = 23.45° × sin(360/365 × (DOY - 81))
  public func solarDeclination(dayOfYear : Float) : Float {
    23.45 * _sin(_deg2rad(360.0 / 365.0 * (dayOfYear - 81.0)))
  };

  // Hour angle from time of day and longitude
  // H = (LST - 12) × 15°/hr  (solar noon at H=0)
  public func hourAngle(localSolarTime_hr : Float) : Float {
    (localSolarTime_hr - 12.0) * EARTH_ROT_DEG_HR
  };

  // True north from sun azimuth (compensated for time of day)
  // North_true = A_sun - A_expected_from_true_north
  public func trueNorthFromSun(
    measuredAzimuth_deg : Float,
    timeOfDay_hr : Float,
    latitude_deg : Float,
    dayOfYear : Float
  ) : Float {
    let H = hourAngle(timeOfDay_hr);
    let delta = solarDeclination(dayOfYear);
    let expectedA = solarAzimuth(H, delta, latitude_deg);
    // Compass heading = measured - expected + actual sun azimuth
    let northCorrection = measuredAzimuth_deg - expectedA;
    let trueNorth = 0.0 - northCorrection;  // 0° = North
    let normalized = if (trueNorth < 0.0) trueNorth + 360.0 else trueNorth;
    _clamp(normalized, 0.0, 360.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: KALMAN FILTER NAVIGATION FUSION
  // State: [lat, lon, heading, speed, depth]
  // 5D state × 5D transition — simplified scalar version for efficiency
  // ══════════════════════════════════════════════════════════════════════════

  // Kalman gain: K = P⁻ / (P⁻ + R)  (scalar version per dimension)
  public func kalmanGain(priorVar : Float, measurementVar : Float) : Float {
    if (priorVar + measurementVar < EPSILON) { return 0.5 };
    priorVar / (priorVar + measurementVar)
  };

  // Kalman update: x̂ = x̂⁻ + K(z - x̂⁻)
  public func kalmanUpdate(prior : Float, measurement : Float, K : Float) : Float {
    prior + K * (measurement - prior)
  };

  // Kalman variance update: P = (1-K) × P⁻
  public func kalmanVarianceUpdate(priorVar : Float, K : Float) : Float {
    _clamp((1.0 - K) * priorVar, EPSILON, 1.0e10)
  };

  // Fuse 3 independent position estimates (geomagnetic, olfactory, celestial)
  // Returns fused estimate and uncertainty
  public func fuseThreeEstimates(
    est1 : Float, var1 : Float,
    est2 : Float, var2 : Float,
    est3 : Float, var3 : Float
  ) : (Float, Float) {
    // Inverse-variance weighting: x_fused = Σ(xᵢ/σᵢ²) / Σ(1/σᵢ²)
    let w1 = if (var1 > EPSILON) 1.0 / var1 else 0.0;
    let w2 = if (var2 > EPSILON) 1.0 / var2 else 0.0;
    let w3 = if (var3 > EPSILON) 1.0 / var3 else 0.0;
    let wTotal = w1 + w2 + w3;
    if (wTotal < EPSILON) { return (est1, var1) };
    let fused = (est1 * w1 + est2 * w2 + est3 * w3) / wTotal;
    let fusedVar = 1.0 / wTotal;
    (fused, fusedVar)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: SWIMMING MECHANICS
  // E(v) = E₀ + α v² + β v³  (total cost)
  // Cost of transport: COT = E(v)/v = E₀/v + α v + β v²
  // Minimum COT at: v* = √(E₀/β)
  // ══════════════════════════════════════════════════════════════════════════

  public func swimmingCost(speed : Float) : Float {
    let v = _clamp(speed, 0.0, SWIM_V_MAX);
    SWIM_COST_BASE + SWIM_COST_ALPHA * v * v + SWIM_COST_BETA * v * v * v
  };

  // Cost of transport (per meter): COT = E(v)/v
  public func costOfTransport(speed : Float) : Float {
    if (speed < EPSILON) { return 9999.0 };
    swimmingCost(speed) / speed
  };

  // Optimal speed (minimize COT)
  public func optimalSpeed() : Float {
    // v* = (E₀/β)^(1/3) from d(COT)/dv = 0
    let vOpt = Float.exp(Float.log(SWIM_COST_BASE / (SWIM_COST_BETA + EPSILON)) / 3.0);
    _clamp(vOpt, 0.1, SWIM_V_MAX)
  };

  // Vortex energy harvesting from Kármán street
  // Energy flux: P_vortex = 0.5 × ρ_water × v_vortex³ × A_body × Cd_harvest
  public func vortexHarvestEnergy(flowSpeed : Float, bodyArea : Float) : Float {
    let Cd = 0.3;  // harvesting drag coefficient
    let rho = 1000.0;  // water density kg/m³
    0.5 * rho * flowSpeed * flowSpeed * flowSpeed * bodyArea * Cd
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: MEDINA SALMON NAVIGATION INDEX
  // N_salmon = S₀ × [ε_mag_inv × Φ_M + olfactory_match] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func salmonNavIndex(
    magneticError  : Float,   // ε_mag (meters)
    olfactoryMatch : Float    // [0,1]
  ) : Float {
    let epsilonInv = _clamp(1.0 - magneticError / MAX_RANGE_M, 0.0, 1.0);
    let idx = S0 * (epsilonInv * PHI_MEDINA + olfactoryMatch) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // Heading toward home (from current position vs home magnetic signature)
  public func computeHomeHeading(
    current_lat : Float, current_lon : Float,
    home_lat    : Float, home_lon    : Float
  ) : Float {
    let dLat = home_lat - current_lat;
    let dLon = home_lon - current_lon;
    let heading = _rad2deg(_atan2(dLon, dLat));
    let normalized = if (heading < 0.0) heading + 360.0 else heading;
    _clamp(normalized, 0.0, 360.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatSalmon(
    state           : NavigationState,
    measuredI       : Float,   // measured magnetic inclination
    measuredB       : Float,   // measured field intensity
    olfactoryConc   : [Float], // current chemical concentrations
    sunAzimuth      : Float,   // measured sun azimuth
    timeOfDay       : Float,   // hours 0-24
    currentSpeed    : Float,   // water current m/s
    currentDir      : Float,   // water current direction degrees
    dayOfYear       : Float
  ) : NavigationState {
    // Update magnetic signature
    let lat_est = latitudeFromInclination(measuredI);
    let magSig : MagneticSignature = {
      inclination  = measuredI;
      intensity    = measuredB;
      declination  = 0.0;
      gradient_I   = state.magnetic.gradient_I;
      gradient_B   = state.magnetic.gradient_B;
      latitudeEst  = lat_est;
      errorMeters  = B_ERROR_SIGMA * 100.0;  // rough
    };

    // Olfactory match
    let matchScore = olfactoryMatch(olfactoryConc, state.olfactory.homeSignature);
    let gradMag = if (olfactoryConc.size() > 0) olfactoryConc[0] else 0.0;
    let olfSig : OlfactorySignal = {
      concentrations   = olfactoryConc;
      homeSignature    = state.olfactory.homeSignature;
      matchScore       = matchScore;
      gradientStrength = gradMag;
      upstreamDir      = state.olfactory.upstreamDir;
      distanceEst      = state.olfactory.distanceEst;
    };

    // Celestial fix
    let delta = solarDeclination(dayOfYear);
    let H = hourAngle(timeOfDay);
    let lat_curr = if (state.position.size() > 0) state.position[0] else 45.0;
    let expectedA = solarAzimuth(H, delta, lat_curr);
    let celFix : CelestialFix = {
      sunAzimuth    = sunAzimuth;
      hourAngle     = H;
      declination   = delta;
      timeOfDay     = timeOfDay;
      northHeading  = trueNorthFromSun(sunAzimuth, timeOfDay, lat_curr, dayOfYear);
      polarizationE = (sunAzimuth + 90.0) mod 360.0;
      isNight       = timeOfDay < 6.0 or timeOfDay > 20.0;
      starNorth     = 0.0;
    };

    // Compute magnetic error vs home
    let home_lat = if (state.position.size() > 1) state.position[1] else 55.0;
    let I_home = inclinationFromLatitude(home_lat);
    let B_home = fieldIntensity(home_lat);
    let magError = magneticPositionError(measuredI, measuredB, I_home, B_home);

    // Navigation confidence
    let navConf = _clamp(matchScore * 0.4 + (1.0 - magError/MAX_RANGE_M) * 0.4 + 0.2, 0.0, 1.0);

    // Swim cost
    let cost = swimmingCost(state.swimSpeed);

    // Vortex energy
    let bodyArea = 0.02;  // salmon cross-section m²
    let vortexE  = vortexHarvestEnergy(currentSpeed, bodyArea);

    // Sovereign index
    let navIdx = salmonNavIndex(magError, matchScore);

    // Update history
    let newPosH = _appendRolling(state.posHistory, lat_est, HIST_MAX);
    let homeHeading = computeHomeHeading(lat_est, 0.0, home_lat, 0.0);
    let newHdgH = _appendRolling(state.headingHistory, homeHeading, HIST_MAX);

    {
      position      = state.position;
      covariance    = state.covariance;
      magnetic      = magSig;
      olfactory     = olfSig;
      celestial     = celFix;
      headingBest   = homeHeading;
      distanceHome  = magError;
      navConfidence = navConf;
      swimSpeed     = state.swimSpeed;
      swimHeading   = homeHeading;
      metabolicCost = cost;
      energyBudget  = _clamp(state.energyBudget - cost * 0.001, 0.0, 1.0);
      currentSpeed  = currentSpeed;
      currentDir    = currentDir;
      vortexEnergy  = vortexE / (cost + EPSILON);
      salmonNavIndex = navIdx;
      posHistory    = newPosH;
      headingHistory = newHdgH;
      beatNum       = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  // Home signature: 12 compounds at characteristic concentrations
  public let HOME_SIGNATURE : [Float] = [
    5.0e-13, 3.0e-13, 8.0e-13, 2.0e-13,  // amino acids
    1.0e-13, 4.0e-13, 6.0e-13, 2.0e-13,  // bile acids
    7.0e-13, 3.0e-13, 5.0e-13, 4.0e-13,  // minerals / organics
  ];

  public func initSalmonNavigation() : NavigationState {
    let initPosition = [45.0, -120.0, 0.0, SWIM_V_OPTIMAL, 0.5];  // [lat, lon, hdg, spd, depth]
    let initCov = Array.tabulate<Float>(KF_STATE_DIM * KF_STATE_DIM, func(i) {
      if (i mod (KF_STATE_DIM + 1) == 0) { 10.0 } else { 0.0 }  // diagonal covariance
    });

    let initMag : MagneticSignature = {
      inclination  = inclinationFromLatitude(45.0);
      intensity    = fieldIntensity(45.0);
      declination  = 0.0; gradient_I = 0.5; gradient_B = 100.0;
      latitudeEst  = 45.0; errorMeters = 50000.0;
    };

    let initOlf : OlfactorySignal = {
      concentrations   = HOME_SIGNATURE;
      homeSignature    = HOME_SIGNATURE;
      matchScore       = 1.0;
      gradientStrength = 0.0;
      upstreamDir      = 0.0;
      distanceEst      = 0.0;
    };

    let initCel : CelestialFix = {
      sunAzimuth=180.0; hourAngle=0.0; declination=0.0; timeOfDay=12.0;
      northHeading=0.0; polarizationE=90.0; isNight=false; starNorth=0.0;
    };

    {
      position       = initPosition;
      covariance     = initCov;
      magnetic       = initMag;
      olfactory      = initOlf;
      celestial      = initCel;
      headingBest    = 0.0;
      distanceHome   = 100000.0;
      navConfidence  = 0.5;
      swimSpeed      = SWIM_V_OPTIMAL;
      swimHeading    = 0.0;
      metabolicCost  = swimmingCost(SWIM_V_OPTIMAL);
      energyBudget   = 1.0;
      currentSpeed   = 0.5;
      currentDir     = 180.0;
      vortexEnergy   = 0.1;
      salmonNavIndex = 0.0;
      posHistory     = [];
      headingHistory = [];
      beatNum        = 0;
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
