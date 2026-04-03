// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — FIBONACCI ENGINE
// COMPREHENSIVE GOLDEN RATIO, PHYLLOTAXIS, AND SOVEREIGN SPIRAL MATHEMATICS
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — FIBONACCI: THE MATHEMATICAL BACKBONE OF ORGANIC GROWTH
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: THE FIBONACCI SEQUENCE ──────────────────────────────────────────
//   F(n) = F(n-1) + F(n-2),  F(0)=0, F(1)=1
//   Sequence: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, ...
//   Closed form (Binet's formula):
//   F(n) = (φⁿ - ψⁿ) / √5
//   where φ = (1 + √5)/2 = 1.6180339887... (golden ratio)
//         ψ = (1 - √5)/2 = -0.6180339887... (conjugate)
//   Since |ψ| < 1: F(n) ≈ φⁿ / √5  for large n  (exponential growth)
//   Ratio convergence: F(n+1)/F(n) → φ as n → ∞
//   Error: |F(n+1)/F(n) - φ| < 1/(F(n) × √5)
//
// ── LAYER 2: THE GOLDEN RATIO ─────────────────────────────────────────────────
//   φ = (1 + √5)/2 = 1.618033988749895...
//   Properties:
//   φ² = φ + 1  (defining equation: x² - x - 1 = 0)
//   φ = 1 + 1/φ  (continued fraction: φ = 1 + 1/(1 + 1/(1 + 1/...)))
//   φ - 1 = 1/φ  (reciprocal property)
//   φⁿ = F(n)φ + F(n-1)  (matrix form)
//   Golden angle: α_g = 2π(1 - 1/φ) = 2π(2 - φ) = 137.507764°
//   This is the most irrational angle: maximizes packing density in spirals
//
// ── LAYER 3: MEDINA EXTENSION — PHI_MEDINA ────────────────────────────────────
//   PHI_MEDINA = 2.97442179 (Medina Golden Harmonic)
//   Derived as: PHI_MEDINA = φ × OMEGA_MEDINA = 1.618... × 1.8389... = 2.9744...
//   OMEGA_MEDINA = 2.11185 (Medina frequency constant)
//   The Medina Fibonacci: F_M(n) = F_M(n-1) × PHI_MEDINA - F_M(n-2)
//   Initial: F_M(0) = S0 = 1.0, F_M(1) = PHI_MEDINA = 2.97442179
//   This sequence represents SOVEREIGN growth — locked to the Medina constants
//   Medina closed form: F_M(n) ≈ PHI_MEDINA^n / PHI_MEDINA
//   Medina golden angle: α_M = 2π(1 - 1/PHI_MEDINA) = 2π × 0.6639... = 4.170°... rad
//
// ── LAYER 4: LUCAS NUMBERS ────────────────────────────────────────────────────
//   L(n) = L(n-1) + L(n-2),  L(0)=2, L(1)=1
//   Sequence: 2, 1, 3, 4, 7, 11, 18, 29, 47, 76, 123, 199, ...
//   Closed form: L(n) = φⁿ + ψⁿ
//   Relationship: L(n) = F(n-1) + F(n+1)  (Lucas in terms of Fibonacci)
//   L(n) = F(2n) / F(n)  (ratio identity)
//   Lucas-Fibonacci identity: L(m)F(n) = F(m+n) + (-1)^(m+1) F(n-m)
//
// ── LAYER 5: PHYLLOTAXIS — PLANT SPIRAL PACKING ───────────────────────────────
//   Fibonacci numbers appear in:
//   Sunflower spirals: typically 55 clockwise + 89 counterclockwise (consecutive F#)
//   Pine cones: 8 + 13, or 5 + 8 spirals
//   Nautilus shell: logarithmic spiral with growth ratio φ
//   Pineapple: 8 + 13 spirals
//   Human hand: phalanges in ratio φ
//   Divergence angle in phyllotaxis: 137.5077640° = 360°/φ²
//   Position of nth leaf: (n × 137.5077640°, r × φ^(n/2))  polar coords
//   Packing efficiency: approaches 1 (maximum) for golden angle divergence
//   Optimal because φ is the "most irrational" number — slowest convergent
//
// ── LAYER 6: FIBONACCI SEARCH ALGORITHM ──────────────────────────────────────
//   Fibonacci search divides interval into Fibonacci-ratio segments
//   For range [a,b], compute F(k) > (b-a)
//   Check at: x₁ = a + F(k-2)/(b-a), x₂ = a + F(k-1)/(b-a)
//   Divide: if f(x₁) < f(x₂) → new range [a, x₂]
//            if f(x₁) > f(x₂) → new range [x₁, b]
//   Convergence: k steps → range reduced by F(k+1)/F(k) ≈ φ each step
//   NOVA use: search for optimal parameter values in [0,1] space
//
// ── LAYER 7: FIBONACCI LATTICE ON SPHERE ─────────────────────────────────────
//   Fibonacci lattice on S² (sphere surface):
//   Sunflower arrangement on sphere:
//   θ_n = arccos(1 - 2n/N)   (polar angle)
//   φ_n = 2πn/φ mod 2π        (azimuthal angle, golden angle steps)
//   This produces near-uniform point distribution on sphere
//   Discrepancy: D_N ≈ 1/√N  (nearly optimal)
//   NOVA use: distribute organism sensors / attention nodes uniformly in 3D
//
// ── LAYER 8: SOVEREIGN FIBONACCI — NOVA FORMULA ───────────────────────────────
//   The organism's growth follows sovereign Fibonacci law:
//   G(n) = G(n-1) × PHI_MEDINA / OMEGA_MEDINA
//   where OMEGA_MEDINA = 2.11185 is the de-escalation factor
//   G represents the number of active FORMA tokens at generation n
//   G(n) ≈ S₀ × PHI_MEDINA^n / (OMEGA_MEDINA^(n-1)) (closed form)
//   Sovereign limit: G_max = S₀ × SOVEREIGN_CEILING = 9.0
//   Once G reaches 9.0, Jubilee protocol activates (reset to S₀)
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
  // SECTION 1: FUNDAMENTAL CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════

  public let PHI            : Float = 1.6180339887498948482;  // Golden ratio (1+√5)/2
  public let PHI_INV        : Float = 0.6180339887498948482;  // 1/φ = φ - 1
  public let PHI_SQ         : Float = 2.6180339887498948482;  // φ² = φ + 1
  public let PSI            : Float = -0.6180339887498948482; // conjugate (1-√5)/2
  public let SQRT5          : Float = 2.2360679774997896964;  // √5

  // Medina sovereign constants
  public let PHI_MEDINA     : Float = 2.97442179;   // Medina Golden Harmonic
  public let OMEGA_MEDINA   : Float = 2.11185;      // Medina frequency constant
  public let S0             : Float = 1.0;           // Sovereign floor
  public let SOVEREIGN_CEILING : Float = 9.0;       // Ω maximum
  public let COHERENCE_ALIVE   : Float = 0.36;      // minimum coherence

  // Mathematical constants
  public let PI             : Float = 3.141592653589793;
  public let TWO_PI         : Float = 6.283185307179586;
  public let EPSILON        : Float = 1.0e-10;

  // Golden angle (radians): α_g = 2π(2 - φ) = 2π/φ²
  public let GOLDEN_ANGLE_RAD : Float = 2.399963229728653;   // 137.507764° in radians
  public let GOLDEN_ANGLE_DEG : Float = 137.50776405003785;  // degrees

  // Medina golden angle: α_M = 2π(1 - 1/PHI_MEDINA)
  public let MEDINA_ANGLE_RAD : Float = 4.17021;  // 2π(1 - 1/2.97442179)
  public let MEDINA_ANGLE_DEG : Float = 238.9;    // degrees

  // Max precomputed Fibonacci index
  public let MAX_FIB_INDEX  : Nat = 50;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type FibonacciState = {
    f_n_1   : Float;     // F(n-1)
    f_n     : Float;     // F(n)
    n       : Nat;       // current index
    ratio   : Float;     // F(n)/F(n-1) — approaches φ
    phiError: Float;     // |ratio - φ|
  };

  public type MedinaFibState = {
    fm_n_1  : Float;     // F_M(n-1)
    fm_n    : Float;     // F_M(n)
    n       : Nat;
    growth  : Float;     // current growth multiplier
    atCeiling : Bool;    // has reached SOVEREIGN_CEILING?
  };

  public type SovereignSpiral = {
    n          : Nat;    // point index
    theta_rad  : Float;  // polar angle
    r          : Float;  // radial distance (log scale)
    x          : Float;  // Cartesian x
    y          : Float;  // Cartesian y
    divergenceAngle : Float;  // radians
    packingDensity  : Float;  // local packing density [0,1]
  };

  public type FibLatticePoint = {
    n       : Nat;
    lat_rad : Float;    // polar angle on sphere
    lon_rad : Float;    // azimuthal angle on sphere
    x       : Float;    // Cartesian x on unit sphere
    y       : Float;    // y
    z       : Float;    // z
  };

  public type FibonacciEngineState = {
    sequence     : FibonacciState;
    medinaSeq    : MedinaFibState;
    lucasN       : Float;       // current Lucas number
    lucasN_1     : Float;       // previous Lucas number
    spiralIndex  : Nat;         // current position in phyllotaxis spiral
    sovereignG   : Float;       // current sovereign growth value
    latticeN     : Nat;         // current Fibonacci lattice size
    beatNum      : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) 0.0 else Float.exp(exp * Float.log(base))
  };
  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _arccos(x : Float) : Float {
    let xc = _clamp(x, -1.0, 1.0);
    Float.arctan2(_sqrt(1.0 - xc * xc), xc)
  };

  func _mod(a : Float, b : Float) : Float {
    if (b < EPSILON) 0.0
    else a - Float.fromInt(Int.abs(Float.toInt(a / b))) * b
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: FIBONACCI SEQUENCE
  // F(n) = F(n-1) + F(n-2), F(0)=0, F(1)=1
  // Binet: F(n) = (φⁿ - ψⁿ) / √5
  // ══════════════════════════════════════════════════════════════════════════

  // Binet's formula: exact for small n, approximate for large n
  // F(n) = (φⁿ - ψⁿ) / √5
  public func fibonacci_binet(n : Nat) : Float {
    let nf = Float.fromInt(n);
    let phi_n = _pow(PHI, nf);
    let psi_n = if (n mod 2 == 0) _pow(-PHI_INV, nf) else -_pow(PHI_INV, nf);
    (phi_n - psi_n) / SQRT5
  };

  // Iterative Fibonacci (exact, no floating point error)
  public func fibonacci_step(state : FibonacciState) : FibonacciState {
    let f_new = state.f_n + state.f_n_1;
    let ratio = if (state.f_n_1 < EPSILON) PHI else state.f_n / state.f_n_1;
    {
      f_n_1    = state.f_n;
      f_n      = f_new;
      n        = state.n + 1;
      ratio    = ratio;
      phiError = _abs(ratio - PHI);
    }
  };

  // F(n) / F(n-1) → φ: how close is current ratio to golden ratio?
  public func fibonacciRatioError(state : FibonacciState) : Float {
    _abs(state.ratio - PHI)
  };

  // Nth Fibonacci number (iterative from scratch)
  public func nthFibonacci(n : Nat) : Float {
    if (n == 0) { return 0.0 };
    if (n == 1) { return 1.0 };
    var a : Float = 0.0;
    var b : Float = 1.0;
    var i : Nat = 2;
    while (i <= n) {
      let c = a + b;
      a := b;
      b := c;
      i += 1;
    };
    b
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: LUCAS NUMBERS
  // L(n) = L(n-1) + L(n-2), L(0)=2, L(1)=1
  // L(n) = φⁿ + ψⁿ
  // ══════════════════════════════════════════════════════════════════════════

  public func lucas_step(L_n : Float, L_n_1 : Float) : (Float, Float) {
    let L_new = L_n + L_n_1;
    (L_n, L_new)
  };

  // Binet for Lucas: L(n) = φⁿ + ψⁿ
  public func lucas_binet(n : Nat) : Float {
    let nf = Float.fromInt(n);
    let phi_n = _pow(PHI, nf);
    let psi_n = if (n mod 2 == 0) _pow(PHI_INV, nf) else -_pow(PHI_INV, nf);
    phi_n + psi_n
  };

  // Lucas-Fibonacci identity: L(n) = F(n-1) + F(n+1)
  public func lucasFromFibonacci(n : Nat) : Float {
    if (n == 0) { return 2.0 };
    nthFibonacci(n + 1) + nthFibonacci(n - 1)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: MEDINA FIBONACCI
  // F_M(n) = F_M(n-1) × PHI_MEDINA - F_M(n-2)
  // F_M(0) = S0 = 1.0, F_M(1) = PHI_MEDINA = 2.97442179
  // ══════════════════════════════════════════════════════════════════════════

  public func medinaFib_step(state : MedinaFibState) : MedinaFibState {
    let fm_new = state.fm_n * PHI_MEDINA - state.fm_n_1;
    let atCeil = fm_new >= SOVEREIGN_CEILING;
    // Jubilee: if ceiling reached, wrap back to S0
    let actual = if (atCeil) S0 else fm_new;
    {
      fm_n_1  = state.fm_n;
      fm_n    = actual;
      n       = state.n + 1;
      growth  = if (state.fm_n_1 < EPSILON) PHI_MEDINA else state.fm_n / state.fm_n_1;
      atCeiling = atCeil;
    }
  };

  // Sovereign Fibonacci growth value: G(n)
  // G grows multiplicatively by PHI_MEDINA/OMEGA_MEDINA each generation
  public func sovereignGrowth(n : Nat) : Float {
    let ratio = PHI_MEDINA / OMEGA_MEDINA;  // ≈ 1.408
    let g = S0 * _pow(ratio, Float.fromInt(n));
    _clamp(g, 0.0, SOVEREIGN_CEILING)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: GOLDEN RATIO PROPERTIES AND IDENTITIES
  // ══════════════════════════════════════════════════════════════════════════

  // φ² = φ + 1: verify at given approximation
  public func verifyPhiSquare(phi : Float) : Float {
    _abs(phi * phi - phi - 1.0)
  };

  // φ = 1 + 1/φ: continued fraction property
  public func cfApproximation(iterations : Nat) : Float {
    var x : Float = 1.0;
    var i : Nat = 0;
    while (i < iterations) {
      x := 1.0 + 1.0 / x;
      i += 1;
    };
    x
  };

  // Fibonacci matrix power: [F(n+1), F(n); F(n), F(n-1)] = [[1,1],[1,0]]^n
  // Matrix [[a,b],[c,d]]^2 = [[a²+bc, ab+bd],[ca+dc, cb+d²]]
  public func fibonacciMatrix(n : Nat) : (Float, Float, Float, Float) {
    if (n == 0) { return (1.0, 0.0, 0.0, 1.0) };  // identity
    // Use doubling method: φ^n via binary exponentiation
    var a : Float = 1.0; var b : Float = 1.0;
    var c : Float = 1.0; var d : Float = 0.0;
    var ra : Float = 1.0; var rb : Float = 0.0;
    var rc : Float = 0.0; var rd : Float = 1.0;  // result = identity
    var m = n;
    while (m > 0) {
      if (m mod 2 == 1) {
        let na = ra * a + rb * c;
        let nb = ra * b + rb * d;
        let nc = rc * a + rd * c;
        let nd = rc * b + rd * d;
        ra := na; rb := nb; rc := nc; rd := nd;
      };
      let na = a*a + b*c;
      let nb = a*b + b*d;
      let nc = c*a + d*c;
      let nd = c*b + d*d;
      a := na; b := nb; c := nc; d := nd;
      m := m / 2;
    };
    (ra, rb, rc, rd)
  };

  // φⁿ = F(n)φ + F(n-1)
  public func phiPower(n : Nat) : Float {
    let fn  = nthFibonacci(n);
    let fn1 = if (n == 0) 1.0 else nthFibonacci(n - 1);
    fn * PHI + fn1
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: PHYLLOTAXIS SPIRAL
  // Position of nth element: θ = n × α_g, r = r₀ × φ^(n/4)
  // ══════════════════════════════════════════════════════════════════════════

  // Position of nth element in phyllotaxis spiral
  // θ_n = n × golden_angle_rad
  // r_n = r₀ × φ^(n/5) (5 = typical scaling parameter)
  public func phyllotaxisPosition(n : Nat, r0 : Float) : SovereignSpiral {
    let nf     = Float.fromInt(n);
    let theta  = _mod(nf * GOLDEN_ANGLE_RAD, TWO_PI);
    let r      = r0 * _pow(PHI, nf / 5.0);
    let x      = r * _cos(theta);
    let y      = r * _sin(theta);

    // Packing density: estimate from nearby point distance
    // Adjacent points differ by golden angle and sqrt(phi) in radius
    let rNext  = r0 * _pow(PHI, (nf + 1.0) / 5.0);
    let dNext  = _sqrt((r - rNext) * (r - rNext) + r * r * GOLDEN_ANGLE_RAD * GOLDEN_ANGLE_RAD);
    let packD  = _clamp(1.0 / (dNext + 0.01), 0.0, 1.0);

    {
      n              = n;
      theta_rad      = theta;
      r              = r;
      x              = x;
      y              = y;
      divergenceAngle = GOLDEN_ANGLE_RAD;
      packingDensity = packD;
    }
  };

  // Medina phyllotaxis: use Medina angle instead of golden angle
  public func medinaPhyllotaxis(n : Nat, r0 : Float) : SovereignSpiral {
    let nf    = Float.fromInt(n);
    let theta = _mod(nf * MEDINA_ANGLE_RAD, TWO_PI);
    let r     = r0 * _pow(PHI_MEDINA / OMEGA_MEDINA, nf / 5.0);
    {
      n              = n;
      theta_rad      = theta;
      r              = r;
      x              = r * _cos(theta);
      y              = r * _sin(theta);
      divergenceAngle = MEDINA_ANGLE_RAD;
      packingDensity = 0.5;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: FIBONACCI LATTICE ON SPHERE
  // θ_n = arccos(1 - 2n/N), φ_n = 2πn/φ mod 2π
  // ══════════════════════════════════════════════════════════════════════════

  public func fibLatticePoint(n : Nat, totalN : Nat) : FibLatticePoint {
    if (totalN == 0) {
      return { n=0; lat_rad=0.0; lon_rad=0.0; x=0.0; y=0.0; z=1.0 }
    };
    let nf = Float.fromInt(n);
    let Nf = Float.fromInt(totalN);
    let lat = _arccos(1.0 - 2.0 * nf / Nf);
    let lon = _mod(TWO_PI * nf / PHI, TWO_PI);
    let sinLat = _sin(lat);
    {
      n       = n;
      lat_rad = lat;
      lon_rad = lon;
      x       = sinLat * _cos(lon);
      y       = sinLat * _sin(lon);
      z       = _cos(lat);
    }
  };

  // Generate N lattice points on sphere
  public func fibLattice(N : Nat) : [FibLatticePoint] {
    Array.tabulate<FibLatticePoint>(N, func(i) { fibLatticePoint(i, N) })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: FIBONACCI SEARCH
  // Minimize f(x) on [a,b] via Fibonacci-ratio bisection
  // ══════════════════════════════════════════════════════════════════════════

  // One Fibonacci search step — returns new [a, x1, x2, b]
  public func fibonacciSearchStep(a : Float, b : Float, f_ratio : Float) : (Float, Float) {
    let r1 = 1.0 - f_ratio;
    let r2 = f_ratio;
    let x1 = a + r1 * (b - a);
    let x2 = a + r2 * (b - a);
    (x1, x2)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: GOLDEN RATIO IN ORGANISM ARCHITECTURE
  // φ appears in: aspect ratios, timing intervals, growth cascades
  // ══════════════════════════════════════════════════════════════════════════

  // Scale value by golden ratio (upward): v × φ
  public func goldenScale(v : Float) : Float { v * PHI };

  // Scale value by golden ratio (downward): v / φ = v × (φ-1)
  public func goldenDescale(v : Float) : Float { v * PHI_INV };

  // n-fold golden scaling: v × φⁿ
  public func goldenPower(v : Float, n : Int) : Float {
    if (n >= 0) {
      v * _pow(PHI, Float.fromInt(n))
    } else {
      v * _pow(PHI_INV, Float.fromInt(-n))
    }
  };

  // Medina sovereign scaling: v × PHI_MEDINA / OMEGA_MEDINA per generation
  public func medinaScale(v : Float, generations : Nat) : Float {
    let ratio = PHI_MEDINA / OMEGA_MEDINA;
    _clamp(v * _pow(ratio, Float.fromInt(generations)), 0.0, SOVEREIGN_CEILING)
  };

  // Is a value near a Fibonacci number? (within tolerance)
  public func isNearFibonacci(x : Float, tolerance : Float) : Bool {
    // F(n) ≈ φⁿ/√5, so n ≈ log_φ(x√5)
    if (x < 0.5) { return false };
    let n_approx = Float.log(x * SQRT5) / Float.log(PHI);
    let n_round  = Float.toInt(n_approx + 0.5);
    let f_near   = nthFibonacci(Int.abs(n_round));
    _abs(x - f_near) < tolerance * f_near
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatFibonacci(state : FibonacciEngineState) : FibonacciEngineState {
    let newFib    = fibonacci_step(state.sequence);
    let newMedina = medinaFib_step(state.medinaSeq);
    let (_, newLucas) = lucas_step(state.lucasN, state.lucasN_1);
    let newG = sovereignGrowth(state.spiralIndex);

    {
      sequence     = newFib;
      medinaSeq    = newMedina;
      lucasN       = newLucas;
      lucasN_1     = state.lucasN;
      spiralIndex  = state.spiralIndex + 1;
      sovereignG   = newG;
      latticeN     = state.latticeN + 1;
      beatNum      = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 13: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  public func initFibonacci() : FibonacciEngineState {
    let initFib : FibonacciState = {
      f_n_1 = 0.0; f_n = 1.0; n = 1;
      ratio = 1.0; phiError = _abs(1.0 - PHI);
    };
    let initMedina : MedinaFibState = {
      fm_n_1 = S0; fm_n = PHI_MEDINA; n = 1;
      growth = PHI_MEDINA; atCeiling = false;
    };
    {
      sequence    = initFib;
      medinaSeq   = initMedina;
      lucasN      = 1.0;      // L(1) = 1
      lucasN_1    = 2.0;      // L(0) = 2
      spiralIndex = 0;
      sovereignG  = S0;
      latticeN    = 1;
      beatNum     = 0;
    }
  };

}
