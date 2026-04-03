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

// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA EXPANDED MATHEMATICS — ENTERPRISE-LEVEL MATHEMATICAL FOUNDATIONS
// Complete Mathematical Library for 32-Architecture Neural Implementation
// ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";

module MedinaExpandedMathematics {

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: FUNDAMENTAL CONSTANTS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public let S0 : Float = 0.75;
  public let SOVEREIGN_CEILING : Float = 9.0;
  public let OMEGA : Float = 9.0;
  public let PHI_MEDINA : Float = 2.97442179;
  public let TAU_EMERGENCE : Float = 0.618033988749;
  public let OMEGA_MEDINA : Float = 2.11185;
  public let SOVEREIGN_RATIO : Float = 12.0;

  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let HALF_PI : Float = 1.57079632679489661923;
  public let PI_SQUARED : Float = 9.86960440108935861883;
  public let SQRT_PI : Float = 1.77245385090551602730;
  public let INV_PI : Float = 0.31830988618379067154;

  public let E : Float = 2.71828182845904523536;
  public let INV_E : Float = 0.36787944117144232160;
  public let LN_2 : Float = 0.69314718055994530942;
  public let LN_10 : Float = 2.30258509299404568402;
  public let LOG2_E : Float = 1.44269504088896340736;

  public let PHI : Float = 1.61803398874989484820;
  public let PHI_SQUARED : Float = 2.61803398874989484820;
  public let INV_PHI : Float = 0.61803398874989484820;
  public let SQRT_5 : Float = 2.23606797749978969640;

  public let EULER_GAMMA : Float = 0.57721566490153286061;
  public let SQRT_2 : Float = 1.41421356237309504880;
  public let INV_SQRT_2 : Float = 0.70710678118654752440;
  public let SQRT_3 : Float = 1.73205080756887729353;
  public let APERY : Float = 1.20205690315959428540;

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: BASIC HELPERS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  public func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  public func _sign(x: Float) : Float {
    if (x > 0.0) { 1.0 } else if (x < 0.0) { -1.0 } else { 0.0 }
  };

  public func _max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  public func _min(a: Float, b: Float) : Float {
    if (a < b) { a } else { b }
  };

  public func _floor(x: Float) : Float {
    Float.floor(x)
  };

  public func _ceil(x: Float) : Float {
    Float.ceil(x)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: EXPONENTIAL & LOGARITHM
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Taylor: exp(x) = Σ(n=0 to ∞) xⁿ/n!
  public func expTaylor(x: Float, terms: Nat) : Float {
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, terms)) {
      term *= x / Float.fromInt(n);
      result += term;
      if (_abs(term) < 1.0e-15) { return result };
    };
    result
  };

  public func expPrecise(x: Float) : Float {
    if (x == 0.0) { return 1.0 };
    if (x > 700.0) { return 1.0e308 };
    if (x < -700.0) { return 0.0 };
    let k = Float.nearest(x / LN_2);
    let r = x - k * LN_2;
    let exp_r = expTaylor(r, 25);
    exp_r * Float.pow(2.0, k)
  };

  public func lnArtanh(x: Float, terms: Nat) : Float {
    if (x <= 0.0) { return -1.0e10 };
    let y = (x - 1.0) / (x + 1.0);
    let y2 = y * y;
    var result : Float = 0.0;
    var power : Float = y;
    for (n in Iter.range(0, terms - 1)) {
      result += power / Float.fromInt(2*n + 1);
      power *= y2;
    };
    2.0 * result
  };

  public func lnPrecise(x: Float) : Float {
    if (x <= 0.0) { return -1.0e10 };
    if (x == 1.0) { return 0.0 };
    var m = x;
    var k : Float = 0.0;
    while (m >= SQRT_2) { m /= 2.0; k += 1.0; };
    while (m < INV_SQRT_2) { m *= 2.0; k -= 1.0; };
    k * LN_2 + lnArtanh(m, 30)
  };

  public func pow(base: Float, exp: Float) : Float {
    if (base <= 0.0) { return 0.0 };
    expPrecise(exp * lnPrecise(base))
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: TRIGONOMETRIC FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func reduceAngle(x: Float) : Float {
    var reduced = x;
    while (reduced > PI) { reduced -= TWO_PI };
    while (reduced < -PI) { reduced += TWO_PI };
    reduced
  };

  public func sinTaylor(x: Float, terms: Nat) : Float {
    let reduced = reduceAngle(x);
    let x2 = reduced * reduced;
    var result : Float = 0.0;
    var term : Float = reduced;
    var sign : Float = 1.0;
    for (n in Iter.range(0, terms - 1)) {
      result += sign * term;
      let k = 2*n + 1;
      term *= x2 / Float.fromInt((k+1) * (k+2));
      sign := -sign;
    };
    result
  };

  public func cosTaylor(x: Float, terms: Nat) : Float {
    let reduced = reduceAngle(x);
    let x2 = reduced * reduced;
    var result : Float = 0.0;
    var term : Float = 1.0;
    var sign : Float = 1.0;
    for (n in Iter.range(0, terms - 1)) {
      result += sign * term;
      let k = 2*n;
      term *= x2 / Float.fromInt((k+1) * (k+2));
      sign := -sign;
    };
    result
  };

  public func sinPrecise(x: Float) : Float { sinTaylor(x, 15) };
  public func cosPrecise(x: Float) : Float { cosTaylor(x, 15) };
  
  public func tanPrecise(x: Float) : Float {
    let c = cosPrecise(x);
    if (_abs(c) < 1.0e-10) { return _sign(sinPrecise(x)) * 1.0e10 };
    sinPrecise(x) / c
  };

  public func cotPrecise(x: Float) : Float {
    let s = sinPrecise(x);
    if (_abs(s) < 1.0e-10) { return _sign(cosPrecise(x)) * 1.0e10 };
    cosPrecise(x) / s
  };

  public func secPrecise(x: Float) : Float {
    let c = cosPrecise(x);
    if (_abs(c) < 1.0e-10) { return 1.0e10 };
    1.0 / c
  };

  public func cscPrecise(x: Float) : Float {
    let s = sinPrecise(x);
    if (_abs(s) < 1.0e-10) { return 1.0e10 };
    1.0 / s
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: HYPERBOLIC FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func sinhPrecise(x: Float) : Float {
    if (_abs(x) < 0.5) {
      let x2 = x * x;
      var result : Float = 0.0;
      var term : Float = x;
      for (n in Iter.range(0, 14)) {
        result += term;
        let k = 2*n + 1;
        term *= x2 / Float.fromInt((k+1) * (k+2));
      };
      return result;
    };
    let ex = expPrecise(x);
    let emx = expPrecise(-x);
    (ex - emx) / 2.0
  };

  public func coshPrecise(x: Float) : Float {
    let ex = expPrecise(x);
    let emx = expPrecise(-x);
    (ex + emx) / 2.0
  };

  public func tanhPrecise(x: Float) : Float {
    if (_abs(x) > 20.0) { return _sign(x) };
    let ex = expPrecise(x);
    let emx = expPrecise(-x);
    (ex - emx) / (ex + emx)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: INVERSE TRIGONOMETRIC
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func arctanTaylor(x: Float, terms: Nat) : Float {
    if (_abs(x) > 1.0) {
      let sign = if (x > 0.0) { 1.0 } else { -1.0 };
      return sign * HALF_PI - arctanTaylor(1.0/x, terms);
    };
    let x2 = x * x;
    var result : Float = 0.0;
    var term : Float = x;
    var sign : Float = 1.0;
    for (n in Iter.range(0, terms - 1)) {
      result += sign * term / Float.fromInt(2*n + 1);
      term *= x2;
      sign := -sign;
    };
    result
  };

  public func atan2Precise(y: Float, x: Float) : Float {
    if (x > 0.0) { return arctanTaylor(y/x, 25) };
    if (x < 0.0) {
      if (y >= 0.0) { return PI + arctanTaylor(y/x, 25) }
      else { return -PI + arctanTaylor(y/x, 25) };
    };
    if (y > 0.0) { return HALF_PI };
    if (y < 0.0) { return -HALF_PI };
    0.0
  };

  public func arcsinTaylor(x: Float, terms: Nat) : Float {
    if (_abs(x) > 1.0) { return if (x > 0.0) { HALF_PI } else { -HALF_PI } };
    let x2 = x * x;
    var result : Float = x;
    var term : Float = x;
    var num : Float = 1.0;
    var den : Float = 1.0;
    for (n in Iter.range(1, terms)) {
      num *= Float.fromInt(2*n - 1);
      den *= Float.fromInt(2*n);
      term *= x2;
      result += (num / den) * term / Float.fromInt(2*n + 1);
    };
    result
  };

  public func arccosPrecise(x: Float) : Float {
    HALF_PI - arcsinTaylor(x, 20)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: SPECIAL FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Gamma via Lanczos
  let LANCZOS_G : Float = 7.0;
  let LANCZOS_COEFFS : [Float] = [
    0.99999999999980993,
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-6,
    1.5056327351493116e-7
  ];

  public func gammaLanczos(x: Float) : Float {
    if (x < 0.5) {
      return PI / (sinPrecise(PI * x) * gammaLanczos(1.0 - x));
    };
    let z = x - 1.0;
    var sum : Float = LANCZOS_COEFFS[0];
    for (i in Iter.range(1, LANCZOS_COEFFS.size() - 1)) {
      sum += LANCZOS_COEFFS[i] / (z + Float.fromInt(i));
    };
    let t = z + LANCZOS_G + 0.5;
    SQRT_2 * SQRT_PI * pow(t, z + 0.5) * expPrecise(-t) * sum
  };

  public func logGamma(x: Float) : Float {
    if (x <= 0.0) { return 1.0e10 };
    if (x < 0.5) { return lnPrecise(PI / sinPrecise(PI * x)) - logGamma(1.0 - x) };
    let z = x - 1.0;
    var sum : Float = LANCZOS_COEFFS[0];
    for (i in Iter.range(1, LANCZOS_COEFFS.size() - 1)) {
      sum += LANCZOS_COEFFS[i] / (z + Float.fromInt(i));
    };
    let t = z + LANCZOS_G + 0.5;
    0.5 * lnPrecise(2.0 * PI) + (z + 0.5) * lnPrecise(t) - t + lnPrecise(sum)
  };

  public func factorial(n: Nat) : Float {
    if (n <= 1) { return 1.0 };
    if (n <= 20) {
      var result : Float = 1.0;
      for (i in Iter.range(2, n)) { result *= Float.fromInt(i) };
      return result;
    };
    gammaLanczos(Float.fromInt(n) + 1.0)
  };

  public func betaFunction(a: Float, b: Float) : Float {
    expPrecise(logGamma(a) + logGamma(b) - logGamma(a + b))
  };

  // Error function
  public func erfApprox(x: Float) : Float {
    let sign = if (x >= 0.0) { 1.0 } else { -1.0 };
    let ax = _abs(x);
    let a1 = 0.254829592;
    let a2 = -0.284496736;
    let a3 = 1.421413741;
    let a4 = -1.453152027;
    let a5 = 1.061405429;
    let p = 0.3275911;
    let t = 1.0 / (1.0 + p * ax);
    let t2 = t * t;
    let t3 = t2 * t;
    let t4 = t3 * t;
    let t5 = t4 * t;
    let y = 1.0 - (a1*t + a2*t2 + a3*t3 + a4*t4 + a5*t5) * expPrecise(-ax*ax);
    sign * y
  };

  // Bessel J0
  public func besselJ0(x: Float, terms: Nat) : Float {
    let x2 = x * x;
    var result : Float = 0.0;
    var term : Float = 1.0;
    var sign : Float = 1.0;
    for (k in Iter.range(0, terms - 1)) {
      result += sign * term;
      let kf = Float.fromInt(k);
      term *= x2 / (4.0 * (kf + 1.0) * (kf + 1.0));
      sign := -sign;
    };
    result
  };

  // Legendre P_n
  public func legendreP(n: Nat, x: Float) : Float {
    if (n == 0) { return 1.0 };
    if (n == 1) { return x };
    var p_nm1 : Float = 1.0;
    var p_n : Float = x;
    for (k in Iter.range(2, n)) {
      let kf = Float.fromInt(k);
      let p_np1 = ((2.0*kf - 1.0) * x * p_n - (kf - 1.0) * p_nm1) / kf;
      p_nm1 := p_n;
      p_n := p_np1;
    };
    p_n
  };

  // Hermite H_n
  public func hermiteH(n: Nat, x: Float) : Float {
    if (n == 0) { return 1.0 };
    if (n == 1) { return 2.0 * x };
    var h_nm1 : Float = 1.0;
    var h_n : Float = 2.0 * x;
    for (k in Iter.range(2, n)) {
      let h_np1 = 2.0 * x * h_n - 2.0 * Float.fromInt(k - 1) * h_nm1;
      h_nm1 := h_n;
      h_n := h_np1;
    };
    h_n
  };

  // Chebyshev T_n
  public func chebyshevT(n: Nat, x: Float) : Float {
    if (n == 0) { return 1.0 };
    if (n == 1) { return x };
    var t_nm1 : Float = 1.0;
    var t_n : Float = x;
    for (k in Iter.range(2, n)) {
      let t_np1 = 2.0 * x * t_n - t_nm1;
      t_nm1 := t_n;
      t_n := t_np1;
    };
    t_n
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: LINEAR ALGEBRA
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func vectorAdd(u: [Float], v: [Float]) : [Float] {
    let n = u.size();
    if (n != v.size()) { return u };
    Array.tabulate<Float>(n, func(i: Nat) : Float { u[i] + v[i] })
  };

  public func vectorSub(u: [Float], v: [Float]) : [Float] {
    let n = u.size();
    if (n != v.size()) { return u };
    Array.tabulate<Float>(n, func(i: Nat) : Float { u[i] - v[i] })
  };

  public func vectorScale(alpha: Float, v: [Float]) : [Float] {
    Array.map<Float, Float>(v, func(x: Float) : Float { alpha * x })
  };

  public func dotProduct(u: [Float], v: [Float]) : Float {
    let n = u.size();
    if (n != v.size()) { return 0.0 };
    var sum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) { sum += u[i] * v[i] };
    sum
  };

  public func vectorNorm(v: [Float]) : Float {
    Float.sqrt(dotProduct(v, v))
  };

  public func vectorNormalize(v: [Float]) : [Float] {
    let norm = vectorNorm(v);
    if (norm < 1.0e-10) { return v };
    vectorScale(1.0 / norm, v)
  };

  public func crossProduct(u: [Float], v: [Float]) : [Float] {
    if (u.size() != 3 or v.size() != 3) { return [0.0, 0.0, 0.0] };
    [
      u[1]*v[2] - u[2]*v[1],
      u[2]*v[0] - u[0]*v[2],
      u[0]*v[1] - u[1]*v[0]
    ]
  };

  public func matrixMult(A: [[Float]], B: [[Float]]) : [[Float]] {
    let m = A.size();
    if (m == 0) { return [[]] };
    let k = A[0].size();
    if (B.size() != k) { return [[]] };
    let n = B[0].size();
    Array.tabulate<[Float]>(m, func(i: Nat) : [Float] {
      Array.tabulate<Float>(n, func(j: Nat) : Float {
        var sum : Float = 0.0;
        for (l in Iter.range(0, k - 1)) { sum += A[i][l] * B[l][j] };
        sum
      })
    })
  };

  public func matrixVectorMult(A: [[Float]], v: [Float]) : [Float] {
    let m = A.size();
    if (m == 0) { return [] };
    let n = A[0].size();
    if (v.size() != n) { return [] };
    Array.tabulate<Float>(m, func(i: Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) { sum += A[i][j] * v[j] };
      sum
    })
  };

  public func matrixTranspose(A: [[Float]]) : [[Float]] {
    let m = A.size();
    if (m == 0) { return [[]] };
    let n = A[0].size();
    Array.tabulate<[Float]>(n, func(j: Nat) : [Float] {
      Array.tabulate<Float>(m, func(i: Nat) : Float { A[i][j] })
    })
  };

  public func matrixTrace(A: [[Float]]) : Float {
    let n = A.size();
    var trace : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (i < A[i].size()) { trace += A[i][i] };
    };
    trace
  };

  public func identityMatrix(n: Nat) : [[Float]] {
    Array.tabulate<[Float]>(n, func(i: Nat) : [Float] {
      Array.tabulate<Float>(n, func(j: Nat) : Float {
        if (i == j) { 1.0 } else { 0.0 }
      })
    })
  };

  public func det2x2(A: [[Float]]) : Float {
    A[0][0] * A[1][1] - A[0][1] * A[1][0]
  };

  public func det3x3(A: [[Float]]) : Float {
    A[0][0] * (A[1][1]*A[2][2] - A[1][2]*A[2][1]) -
    A[0][1] * (A[1][0]*A[2][2] - A[1][2]*A[2][0]) +
    A[0][2] * (A[1][0]*A[2][1] - A[1][1]*A[2][0])
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 9: NUMERICAL CALCULUS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Simpson's rule integration
  public func integrateSimpson(f: Float -> Float, a: Float, b: Float, n: Nat) : Float {
    let nEven = if (n % 2 == 0) { n } else { n + 1 };
    let h = (b - a) / Float.fromInt(nEven);
    var sum : Float = f(a) + f(b);
    for (i in Iter.range(1, nEven - 1)) {
      let x = a + Float.fromInt(i) * h;
      let coeff = if (i % 2 == 0) { 2.0 } else { 4.0 };
      sum += coeff * f(x);
    };
    sum * h / 3.0
  };

  // Central difference derivative
  public func diffCentral(f: Float -> Float, x: Float, h: Float) : Float {
    (f(x + h) - f(x - h)) / (2.0 * h)
  };

  // Second derivative
  public func diff2Central(f: Float -> Float, x: Float, h: Float) : Float {
    (f(x + h) - 2.0*f(x) + f(x - h)) / (h * h)
  };

  // Runge-Kutta 4th order step
  public func rk4Step(f: (Float, Float) -> Float, t: Float, y: Float, h: Float) : Float {
    let k1 = f(t, y);
    let k2 = f(t + h/2.0, y + h*k1/2.0);
    let k3 = f(t + h/2.0, y + h*k2/2.0);
    let k4 = f(t + h, y + h*k3);
    y + h * (k1 + 2.0*k2 + 2.0*k3 + k4) / 6.0
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 10: PROBABILITY & STATISTICS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func mean(data: [Float]) : Float {
    let n = data.size();
    if (n == 0) { return 0.0 };
    var sum : Float = 0.0;
    for (x in data.vals()) { sum += x };
    sum / Float.fromInt(n)
  };

  public func variance(data: [Float]) : Float {
    let n = data.size();
    if (n < 2) { return 0.0 };
    let m = mean(data);
    var sum : Float = 0.0;
    for (x in data.vals()) {
      let d = x - m;
      sum += d * d;
    };
    sum / Float.fromInt(n - 1)
  };

  public func stdDev(data: [Float]) : Float {
    Float.sqrt(variance(data))
  };

  public func covariance(x: [Float], y: [Float]) : Float {
    let n = x.size();
    if (n != y.size() or n < 2) { return 0.0 };
    let mx = mean(x);
    let my = mean(y);
    var sum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      sum += (x[i] - mx) * (y[i] - my);
    };
    sum / Float.fromInt(n - 1)
  };

  public func correlation(x: [Float], y: [Float]) : Float {
    let cov = covariance(x, y);
    let sx = stdDev(x);
    let sy = stdDev(y);
    if (sx < 1.0e-10 or sy < 1.0e-10) { return 0.0 };
    cov / (sx * sy)
  };

  // Gaussian PDF
  public func gaussianPDF(x: Float, mu: Float, sigma: Float) : Float {
    let z = (x - mu) / sigma;
    expPrecise(-0.5 * z * z) / (sigma * Float.sqrt(TWO_PI))
  };

  // Gaussian CDF via erf
  public func gaussianCDF(x: Float, mu: Float, sigma: Float) : Float {
    let z = (x - mu) / (sigma * SQRT_2);
    0.5 * (1.0 + erfApprox(z))
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 11: INFORMATION THEORY
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func entropy(probs: [Float]) : Float {
    var h : Float = 0.0;
    for (p in probs.vals()) {
      if (p > 1.0e-10) {
        h -= p * lnPrecise(p) / LN_2;
      };
    };
    h
  };

  public func crossEntropy(p: [Float], q: [Float]) : Float {
    let n = p.size();
    if (n != q.size()) { return 1.0e10 };
    var h : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (p[i] > 1.0e-10 and q[i] > 1.0e-10) {
        h -= p[i] * lnPrecise(q[i]) / LN_2;
      };
    };
    h
  };

  public func klDivergence(p: [Float], q: [Float]) : Float {
    let n = p.size();
    if (n != q.size()) { return 1.0e10 };
    var kl : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (p[i] > 1.0e-10 and q[i] > 1.0e-10) {
        kl += p[i] * lnPrecise(p[i] / q[i]) / LN_2;
      };
    };
    kl
  };

  public func mutualInformation(pxy: [[Float]]) : Float {
    let m = pxy.size();
    if (m == 0) { return 0.0 };
    let n = pxy[0].size();
    
    // Marginals
    let px = Array.tabulate<Float>(m, func(i: Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) { sum += pxy[i][j] };
      sum
    });
    let py = Array.tabulate<Float>(n, func(j: Nat) : Float {
      var sum : Float = 0.0;
      for (i in Iter.range(0, m - 1)) { sum += pxy[i][j] };
      sum
    });
    
    var mi : Float = 0.0;
    for (i in Iter.range(0, m - 1)) {
      for (j in Iter.range(0, n - 1)) {
        let p = pxy[i][j];
        if (p > 1.0e-10 and px[i] > 1.0e-10 and py[j] > 1.0e-10) {
          mi += p * lnPrecise(p / (px[i] * py[j])) / LN_2;
        };
      };
    };
    mi
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 12: DYNAMICAL SYSTEMS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Lyapunov exponent estimator
  public func lyapunovExponent(
    trajectory: [Float],
    perturbation: Float,
    separation: Nat
  ) : Float {
    let n = trajectory.size();
    if (n < separation * 2) { return 0.0 };
    
    var sumLog : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(0, n - separation - 1)) {
      let x0 = trajectory[i];
      let x1 = trajectory[i + separation];
      let delta0 = perturbation;
      let delta1 = _abs(x1 - x0);
      
      if (delta1 > 1.0e-10) {
        sumLog += lnPrecise(delta1 / delta0);
        count += 1;
      };
    };
    
    if (count > 0) {
      sumLog / (Float.fromInt(count) * Float.fromInt(separation))
    } else { 0.0 }
  };

  // Bifurcation parameter sweep
  public func bifurcationMap(
    f: (Float, Float) -> Float,  // map(x, r) -> x'
    rMin: Float,
    rMax: Float,
    rSteps: Nat,
    transient: Nat,
    samples: Nat,
    x0: Float
  ) : [(Float, [Float])] {
    let results = Buffer.Buffer<(Float, [Float])>(rSteps);
    
    for (step in Iter.range(0, rSteps - 1)) {
      let r = rMin + Float.fromInt(step) * (rMax - rMin) / Float.fromInt(rSteps - 1);
      var x = x0;
      
      // Transient
      for (_ in Iter.range(0, transient - 1)) {
        x := f(x, r);
      };
      
      // Sample attractor
      let attractor = Buffer.Buffer<Float>(samples);
      for (_ in Iter.range(0, samples - 1)) {
        x := f(x, r);
        attractor.add(x);
      };
      
      results.add((r, Buffer.toArray(attractor)));
    };
    
    Buffer.toArray(results)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 13: NEURAL MATHEMATICS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Activation functions
  public func sigmoid(x: Float) : Float {
    1.0 / (1.0 + expPrecise(-x))
  };

  public func sigmoidDerivative(x: Float) : Float {
    let s = sigmoid(x);
    s * (1.0 - s)
  };

  public func medinaSigmoid(x: Float) : Float {
    1.0 / (1.0 + expPrecise(-PHI_MEDINA * x))
  };

  public func relu(x: Float) : Float {
    if (x > 0.0) { x } else { 0.0 }
  };

  public func leakyRelu(x: Float, alpha: Float) : Float {
    if (x > 0.0) { x } else { alpha * x }
  };

  public func elu(x: Float, alpha: Float) : Float {
    if (x > 0.0) { x } else { alpha * (expPrecise(x) - 1.0) }
  };

  public func gelu(x: Float) : Float {
    0.5 * x * (1.0 + tanhPrecise(SQRT_2 / SQRT_PI * (x + 0.044715 * x * x * x)))
  };

  public func swish(x: Float) : Float {
    x * sigmoid(x)
  };

  public func softplus(x: Float) : Float {
    lnPrecise(1.0 + expPrecise(x))
  };

  public func softmax(x: [Float]) : [Float] {
    let maxX = Array.foldLeft<Float, Float>(x, -1.0e10, _max);
    let exps = Array.map<Float, Float>(x, func(xi: Float) : Float {
      expPrecise(xi - maxX)
    });
    let sumExp = Array.foldLeft<Float, Float>(exps, 0.0, func(acc, e) { acc + e });
    Array.map<Float, Float>(exps, func(e: Float) : Float { e / sumExp })
  };

  // Hodgkin-Huxley gating variables
  public func hhAlphaN(V: Float) : Float {
    let x = V + 55.0;
    if (_abs(x) < 0.001) { return 0.1 };
    0.01 * x / (1.0 - expPrecise(-x / 10.0))
  };

  public func hhBetaN(V: Float) : Float {
    0.125 * expPrecise(-(V + 65.0) / 80.0)
  };

  public func hhAlphaM(V: Float) : Float {
    let x = V + 40.0;
    if (_abs(x) < 0.001) { return 1.0 };
    0.1 * x / (1.0 - expPrecise(-x / 10.0))
  };

  public func hhBetaM(V: Float) : Float {
    4.0 * expPrecise(-(V + 65.0) / 18.0)
  };

  public func hhAlphaH(V: Float) : Float {
    0.07 * expPrecise(-(V + 65.0) / 20.0)
  };

  public func hhBetaH(V: Float) : Float {
    1.0 / (1.0 + expPrecise(-(V + 35.0) / 10.0))
  };

  // Kuramoto order parameter
  public func kuramotoOrderParameter(phases: [Float]) : (Float, Float) {
    let n = phases.size();
    if (n == 0) { return (0.0, 0.0) };
    
    var realSum : Float = 0.0;
    var imagSum : Float = 0.0;
    
    for (theta in phases.vals()) {
      realSum += cosPrecise(theta);
      imagSum += sinPrecise(theta);
    };
    
    realSum /= Float.fromInt(n);
    imagSum /= Float.fromInt(n);
    
    let r = Float.sqrt(realSum*realSum + imagSum*imagSum);
    let psi = atan2Precise(imagSum, realSum);
    
    (r, psi)
  };

  // STDP learning rule
  public func stdpWeight(dt: Float, A_plus: Float, A_minus: Float, tau_plus: Float, tau_minus: Float) : Float {
    if (dt > 0.0) {
      // Pre before post (LTP)
      A_plus * expPrecise(-dt / tau_plus)
    } else if (dt < 0.0) {
      // Post before pre (LTD)
      -A_minus * expPrecise(dt / tau_minus)
    } else {
      0.0
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 14: QUANTUM MATHEMATICS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Complex number as (real, imag)
  public type Complex = (Float, Float);

  public func complexAdd(a: Complex, b: Complex) : Complex {
    (a.0 + b.0, a.1 + b.1)
  };

  public func complexSub(a: Complex, b: Complex) : Complex {
    (a.0 - b.0, a.1 - b.1)
  };

  public func complexMult(a: Complex, b: Complex) : Complex {
    (a.0*b.0 - a.1*b.1, a.0*b.1 + a.1*b.0)
  };

  public func complexConj(a: Complex) : Complex {
    (a.0, -a.1)
  };

  public func complexMag(a: Complex) : Float {
    Float.sqrt(a.0*a.0 + a.1*a.1)
  };

  public func complexPhase(a: Complex) : Float {
    atan2Precise(a.1, a.0)
  };

  public func complexExp(a: Complex) : Complex {
    let r = expPrecise(a.0);
    (r * cosPrecise(a.1), r * sinPrecise(a.1))
  };

  // Pauli matrices (as 2x2 complex matrices)
  public func pauliX() : [[Complex]] {
    [[(0.0, 0.0), (1.0, 0.0)],
     [(1.0, 0.0), (0.0, 0.0)]]
  };

  public func pauliY() : [[Complex]] {
    [[(0.0, 0.0), (0.0, -1.0)],
     [(0.0, 1.0), (0.0, 0.0)]]
  };

  public func pauliZ() : [[Complex]] {
    [[(1.0, 0.0), (0.0, 0.0)],
     [(0.0, 0.0), (-1.0, 0.0)]]
  };

  // Inner product <ψ|φ>
  public func quantumInnerProduct(psi: [Complex], phi: [Complex]) : Complex {
    let n = psi.size();
    if (n != phi.size()) { return (0.0, 0.0) };
    
    var result : Complex = (0.0, 0.0);
    for (i in Iter.range(0, n - 1)) {
      let conjPsi = complexConj(psi[i]);
      result := complexAdd(result, complexMult(conjPsi, phi[i]));
    };
    result
  };

  // Probability |<ψ|φ>|²
  public func quantumProbability(psi: [Complex], phi: [Complex]) : Float {
    let inner = quantumInnerProduct(psi, phi);
    inner.0 * inner.0 + inner.1 * inner.1
  };

  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 15: MEDINA ORIGINAL EQUATIONS
  // ════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Medina Sovereign Transform
  public func medinaSovereignTransform(x: Float) : Float {
    let bounded = _clamp(x, 0.0, SOVEREIGN_CEILING);
    S0 + (SOVEREIGN_CEILING - S0) * tanhPrecise((bounded - S0) / PHI_MEDINA)
  };

  // Medina Harmonic Series
  public func medinaHarmonicSeries(n: Nat) : Float {
    var sum : Float = 0.0;
    for (k in Iter.range(1, n)) {
      sum += 1.0 / (Float.fromInt(k) * pow(PHI_MEDINA, Float.fromInt(k - 1)));
    };
    sum
  };

  // Medina Emergence Function
  public func medinaEmergence(x: Float, threshold: Float) : Float {
    let scaled = (x - threshold) / TAU_EMERGENCE;
    if (scaled > 10.0) { return 1.0 };
    if (scaled < -10.0) { return 0.0 };
    1.0 / (1.0 + expPrecise(-PHI_MEDINA * scaled))
  };

  // Medina Coherence Metric
  public func medinaCoherence(phases: [Float]) : Float {
    let (r, _) = kuramotoOrderParameter(phases);
    pow(r, 1.0 / PHI_MEDINA)
  };

  // Medina Compound Growth
  public func medinaCompoundGrowth(
    principal: Float,
    rate: Float,
    periods: Nat
  ) : Float {
    // Enhanced compound growth with Medina scaling
    let effectiveRate = rate * (1.0 + TAU_EMERGENCE);
    principal * pow(1.0 + effectiveRate / PHI_MEDINA, Float.fromInt(periods))
  };

  // Medina Golden Integral
  public func medinaGoldenIntegral(f: Float -> Float, a: Float, b: Float, n: Nat) : Float {
    // Gaussian quadrature with Medina weights
    let h = (b - a) / Float.fromInt(n);
    var sum : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let x0 = a + Float.fromInt(i) * h;
      let x1 = x0 + h;
      let mid = (x0 + x1) / 2.0;
      
      // Golden ratio weighted nodes
      let w1 = INV_PHI;
      let w2 = 1.0 - INV_PHI;
      let xi1 = x0 + w1 * h;
      let xi2 = x0 + w2 * h;
      
      sum += (f(xi1) + f(xi2)) * h / 2.0;
    };
    
    sum
  };

  // Medina Fractal Dimension Estimator
  public func medinaFractalDimension(
    data: [Float],
    scales: [Float]
  ) : Float {
    let nScales = scales.size();
    if (nScales < 2) { return 1.0 };
    
    let counts = Buffer.Buffer<Float>(nScales);
    let n = data.size();
    
    for (scale in scales.vals()) {
      var count : Float = 0.0;
      var i : Nat = 0;
      while (i < n) {
        count += 1.0;
        var j = i + 1;
        while (j < n and _abs(data[j] - data[i]) < scale) {
          j += 1;
        };
        i := j;
      };
      counts.add(count);
    };
    
    // Linear regression of log(count) vs log(scale)
    let logScales = Array.map<Float, Float>(scales, lnPrecise);
    let logCounts = Array.map<Float, Float>(Buffer.toArray(counts), lnPrecise);
    
    let sumX = Array.foldLeft<Float, Float>(logScales, 0.0, func(a, b) { a + b });
    let sumY = Array.foldLeft<Float, Float>(logCounts, 0.0, func(a, b) { a + b });
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    
    for (i in Iter.range(0, nScales - 1)) {
      sumXY += logScales[i] * logCounts[i];
      sumX2 += logScales[i] * logScales[i];
    };
    
    let nf = Float.fromInt(nScales);
    let slope = (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX);
    
    -slope  // Fractal dimension
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
  //  M E D I N A   S P E C I A L   M A T H E M A T I C S
  //
  //  Enterprise-Level Medina Discovery Mathematics
  //  HIM/HER Dual-Organism Sacred Coupling Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SACRED GEOMETRY MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Golden ratio φ = (1 + √5) / 2
  public let PHI : Float = 1.6180339887498948482;

  /// Fibonacci sequence generator
  public func medinaFibonacci(n : Nat) : Nat {
    if (n <= 1) { n }
    else {
      var a : Nat = 0;
      var b : Nat = 1;
      var i = 2;
      while (i <= n) {
        let temp = a + b;
        a := b;
        b := temp;
        i += 1;
      };
      b
    }
  };

  /// Golden spiral radius at angle
  public func medinaGoldenSpiral(angle : Float, a : Float, b : Float) : Float {
    a * Float.exp(b * angle)
  };

  /// Sacred proportion check
  public func medinaSacredProportion(a : Float, b : Float, tolerance : Float) : Bool {
    let ratio = if (a > b) a / b else b / a;
    Float.abs(ratio - PHI) < tolerance
  };

  /// Vesica piscis area
  public func medinaVesicaPiscisArea(radius : Float) : Float {
    let r2 = radius * radius;
    r2 * (4.0 * 3.14159265 / 3.0 - Float.sqrt(3.0) / 2.0)
  };

  /// Platonic solid vertices (tetrahedron example)
  public func medinaTetrahedronVertex(index : Nat, size : Float) : (Float, Float, Float) {
    let vertices = [
      (1.0, 1.0, 1.0),
      (1.0, -1.0, -1.0),
      (-1.0, 1.0, -1.0),
      (-1.0, -1.0, 1.0)
    ];
    let v = vertices[index % 4];
    (v.0 * size, v.1 * size, v.2 * size)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HELICAL MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Helix position at parameter t
  public func medinaHelixPosition(t : Float, radius : Float, pitch : Float) : (Float, Float, Float) {
    let x = radius * Float.cos(t);
    let y = radius * Float.sin(t);
    let z = pitch * t / (2.0 * 3.14159265);
    (x, y, z)
  };

  /// Double helix offset
  public func medinaDoubleHelixOffset(t : Float, radius : Float, pitch : Float, offset : Float) : ((Float, Float, Float), (Float, Float, Float)) {
    let h1 = medinaHelixPosition(t, radius, pitch);
    let h2 = medinaHelixPosition(t + offset, radius, pitch);
    (h1, h2)
  };

  /// Helical curvature
  public func medinaHelicalCurvature(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    radius / (radius * radius + p * p)
  };

  /// Helical torsion
  public func medinaHelicalTorsion(radius : Float, pitch : Float) : Float {
    let p = pitch / (2.0 * 3.14159265);
    p / (radius * radius + p * p)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPHERICAL HARMONICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spherical to Cartesian
  public func medinaSphericalToCartesian(r : Float, theta : Float, phi : Float) : (Float, Float, Float) {
    let x = r * Float.sin(theta) * Float.cos(phi);
    let y = r * Float.sin(theta) * Float.sin(phi);
    let z = r * Float.cos(theta);
    (x, y, z)
  };

  /// Cartesian to Spherical
  public func medinaCartesianToSpherical(x : Float, y : Float, z : Float) : (Float, Float, Float) {
    let r = Float.sqrt(x * x + y * y + z * z);
    let theta = Float.acos(z / (r + 0.0001));
    let phi = Float.atan2(y, x);
    (r, theta, phi)
  };

  /// Associated Legendre polynomial P_l^m (simplified)
  public func medinaLegendreP(l : Nat, m : Nat, x : Float) : Float {
    if (l == 0 and m == 0) { return 1.0 };
    if (l == 1 and m == 0) { return x };
    if (l == 1 and m == 1) { return -Float.sqrt(1.0 - x * x) };
    if (l == 2 and m == 0) { return 0.5 * (3.0 * x * x - 1.0) };
    // Simplified for higher orders
    Float.pow(x, Float.fromInt(l - m))
  };

  /// Spherical harmonic Y_l^m (simplified real part)
  public func medinaSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let mAbs = Int.abs(m);
    let plm = medinaLegendreP(l, mAbs, Float.cos(theta));
    if (m >= 0) {
      plm * Float.cos(Float.fromInt(mAbs) * phi)
    } else {
      plm * Float.sin(Float.fromInt(mAbs) * phi)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LIVING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Growth curve (logistic)
  public func medinaGrowthCurve(t : Float, k : Float, l : Float, x0 : Float) : Float {
    l / (1.0 + Float.exp(-k * (t - x0)))
  };

  /// Morphogenesis reaction-diffusion
  public func medinaMorphogenesis(
    u : Float,
    v : Float,
    du : Float,
    dv : Float,
    f : Float,
    k : Float
  ) : (Float, Float) {
    let reaction = u * v * v;
    let newU = du - reaction + f * (1.0 - u);
    let newV = dv + reaction - (f + k) * v;
    (newU, newV)
  };

  /// Phyllotaxis angle (golden angle)
  public func medinaPhyllotaxisAngle(n : Nat) : Float {
    let goldenAngle : Float = 137.5077640500378546463;
    Float.fromInt(n) * goldenAngle * 3.14159265 / 180.0
  };

  /// Branching pattern
  public func medinaBranchingPattern(
    parentLength : Float,
    branchRatio : Float,
    angle : Float,
    depth : Nat
  ) : Float {
    parentLength * Float.pow(branchRatio, Float.fromInt(depth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MIRROR MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reflection across plane
  public func medinaReflection(point : (Float, Float, Float), normal : (Float, Float, Float)) : (Float, Float, Float) {
    let dot = point.0 * normal.0 + point.1 * normal.1 + point.2 * normal.2;
    let rx = point.0 - 2.0 * dot * normal.0;
    let ry = point.1 - 2.0 * dot * normal.1;
    let rz = point.2 - 2.0 * dot * normal.2;
    (rx, ry, rz)
  };

  /// Symmetry score
  public func medinaSymmetryScore(left : [Float], right : [Float]) : Float {
    let n = if (left.size() < right.size()) left.size() else right.size();
    if (n == 0) { return 1.0 };
    var diff : Float = 0.0;
    var i = 0;
    while (i < n) {
      diff += Float.abs(left[i] - right[n - 1 - i]);
      i += 1;
    };
    1.0 / (1.0 + diff)
  };

  /// Fractal dimension estimation
  public func medinaFractalDimension(boxCounts : [Nat], scales : [Float]) : Float {
    let n = if (boxCounts.size() < scales.size()) boxCounts.size() else scales.size();
    if (n < 2) { return 1.0 };
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let x = Float.log(1.0 / scales[i]);
      let y = Float.log(Float.fromInt(boxCounts[i]));
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    let nf = Float.fromInt(n);
    (nf * sumXY - sumX * sumY) / (nf * sumX2 - sumX * sumX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COVENANT MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Commitment strength
  public func medinaCommitmentStrength(
    duration : Nat,
    consistency : Float,
    depth : Float
  ) : Float {
    let durationFactor = Float.log(Float.fromInt(duration + 1));
    consistency * depth * durationFactor
  };

  /// Trust accumulation
  public func medinaTrustAccumulation(
    currentTrust : Float,
    interaction : Float,
    reciprocity : Float
  ) : Float {
    let gain = interaction * reciprocity * (1.0 - currentTrust);
    currentTrust + gain
  };

  /// Covenant breach penalty
  public func medinaBreachPenalty(
    trustLevel : Float,
    violationSeverity : Float,
    relationshipAge : Nat
  ) : Float {
    let ageFactor = Float.log(Float.fromInt(relationshipAge + 1));
    trustLevel * violationSeverity * ageFactor
  };

}
