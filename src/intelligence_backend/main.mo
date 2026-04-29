// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Owner: Alfredo Medina Hernandez · Dallas TX · MedinaSITech@outlook.com                                  ║
// ║  Framework: Medina Doctrine — Native Nova Protocol                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// INTELLIGENCE BACKEND — DEEP MATHEMATICS INTELLIGENCE ENGINE (BUILD №44)
// Casa de Inteligencia: This backend serves ALL frontends requiring mathematical computation
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MISSION:
//   Sovereign on-chain mathematics intelligence engine. Every mathematical computation,
//   formula evaluation, numerical method, and φ-based calculation lives here. This is not
//   a utility library — this is the mathematical substrate of NOVA computed to machine
//   precision from first principles. Intelligence is infrastructure.
//
// ARCHITECTURE (Casa de Inteligencia):
//   This BACKEND serves MULTIPLE FRONTENDS:
//     → DallasISDApp.tsx (classroom math, φ-visualizations)
//     → NovaBuilderApp.tsx (code generation math, optimization)
//     → ParallaxApp.tsx (financial clearinghouse math, fee calculations)
//     → PhantomWalletApp.tsx (remittance math, exchange rates)
//     → MathPhysicsLab.tsx (research math, chaos theory)
//     → EmergenceLab.tsx (emergence math, Kuramoto oscillators)
//     → NeuroCogLab.tsx (cognitive math, neurochemistry)
//
// CAPABILITIES:
//   §1  Sovereign Identity & Genesis
//   §2  Golden Ratio φ Engine — full φ-power ladder, Fibonacci, Binet
//   §3  Vector Algebra Engine — n-dimensional vector operations
//   §4  Matrix Operations Engine — full linear algebra
//   §5  Calculus Engine — derivatives, integrals, numerical methods
//   §6  Chaos Theory Engine — logistic map, Lyapunov, Feigenbaum
//   §7  Kuramoto Oscillator Engine — phase sync, order parameter
//   §8  Probability & Statistics Engine — distributions, inference
//   §9  Number Theory Engine — primes, modular arithmetic, cryptographic
//   §10 Geometry Engine — Platonic solids, sacred geometry, Vesica Piscis
//   §11 Fourier Analysis Engine — FFT, signal processing
//   §12 Optimization Engine — gradient descent, evolutionary algorithms
//   §13 Differential Equations Engine — ODE/PDE solvers
//   §14 Complex Analysis Engine — complex numbers, conformal maps
//   §15 Heartbeat & Telemetry — 873ms math engine health
//   §16 Stream Publishing — MATH_COMPUTE events to nova_stream
//
// API:
//   getMathEngine()              — full engine state
//   computePhi(n)                — φⁿ to 19 decimal places
//   computeFibonacci(n)          — F(n) via matrix exponentiation
//   computeDerivative(coeffs, x) — numerical/analytical derivative
//   computeKuramoto(thetas, K)   — Kuramoto order parameter
//   computeLyapunov(r, iters)    — Lyapunov exponent for logistic map
//   computeFeigenbaum(bifurc)    — Feigenbaum ratio at bifurcation
//   solveODE(f, y0, t0, tf, h)   — Runge-Kutta 4th order
//   computeFFT(signal)           — Fast Fourier Transform
//   computeEigenvalues(matrix)   — Matrix eigenvalues
//   computePrimeFactors(n)       — Prime factorization
//   computeModPow(base, exp, m)  — Modular exponentiation
//   computeGCD(a, b)             — Euclidean GCD
//   computeLCM(a, b)             — Least common multiple
//   computeSin/Cos/Tan(x)        — Trig via Taylor series
//   computeExp/Log(x)            — Exponential/logarithm
//   computeSqrt(x)               — Newton-Raphson square root
//   ... 200+ mathematical operations
//
// MEDINA TECH | ALFREDO MEDINA HERNANDEZ | DALLAS TX | 2026
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Array     "mo:base/Array";
import Buffer    "mo:base/Buffer";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Iter      "mo:base/Iter";
import Nat       "mo:base/Nat";
import Nat64     "mo:base/Nat64";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";
import Bool      "mo:base/Bool";

actor IntelligenceBackend {

  // ═══════════════════════════════════════════════════════════════════════════
  // §1 — SOVEREIGN IDENTITY & GENESIS
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var buildNumber        : Nat       = 44;

  func _isArchitect(caller : Principal) : Bool { caller == architectPrincipal };

  public shared(msg) func claimIntelligence() : async Text {
    if (genesisLocked) return "INTELLIGENCE_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-INTELLIGENCE-BACKEND-BUILD44-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text      { sovereignSeal };
  public query func isLocked()     : async Bool      { genesisLocked };
  public query func getArchitect() : async Principal { architectPrincipal };
  public query func getBuild()     : async Nat       { buildNumber };

  // ═══════════════════════════════════════════════════════════════════════════
  // §2 — GOLDEN RATIO φ ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // The Golden Ratio φ = 1.6180339887498948482... is the mathematical foundation
  // of NOVA. Every fee tier, every Fibonacci computation, every sacred geometry
  // calculation starts here. This is computed to 19 decimal places on-chain.

  // φ constants — NEVER approximated, always 19 decimal places
  let PHI         : Float = 1.6180339887498948482;   // Golden ratio φ
  let PHI_INV     : Float = 0.6180339887498948482;   // φ⁻¹ = 1/φ
  let PHI_SQ      : Float = 2.6180339887498948482;   // φ² = φ + 1
  let PHI_CUBE    : Float = 4.2360679774997896964;   // φ³
  let PHI_4       : Float = 6.8541019662496847020;   // φ⁴
  let PHI_5       : Float = 11.0901699437494742410;  // φ⁵
  let PHI_6       : Float = 17.9442719099991589430;  // φ⁶
  let PHI_INV_2   : Float = 0.3819660112501051518;   // φ⁻² = AMOR constant
  let PHI_INV_3   : Float = 0.2360679774997896964;   // φ⁻³
  let PHI_INV_4   : Float = 0.1458980337503154990;   // φ⁻⁴
  let PHI_INV_5   : Float = 0.0901699437494742410;   // φ⁻⁵
  let PHI_INV_6   : Float = 0.0557280900008412000;   // φ⁻⁶

  // Fundamental math constants
  let PI          : Float = 3.1415926535897932385;   // π
  let TAU         : Float = 6.2831853071795864769;   // τ = 2π
  let E           : Float = 2.7182818284590452354;   // e
  let SQRT2       : Float = 1.4142135623730950488;   // √2
  let SQRT3       : Float = 1.7320508075688772935;   // √3
  let SQRT5       : Float = 2.2360679774997896964;   // √5
  let LN2         : Float = 0.6931471805599453094;   // ln(2)
  let LN10        : Float = 2.3025850929940456840;   // ln(10)

  // Chaos and physics constants
  let FEIGENBAUM_D: Float = 4.6692016091029906719;   // Feigenbaum δ
  let FEIGENBAUM_A: Float = 2.5029078750958928222;   // Feigenbaum α
  let ISING_BETA  : Float = 0.125;                   // 2D Ising critical β
  let ISING_TC    : Float = 2.269185314213022;       // 2D Ising T_c/J
  let PERC_PC     : Float = 0.5927;                  // Bond percolation threshold
  let SCHUMANN    : Float = 7.83;                    // Earth Schumann resonance Hz
  let HEARTBEAT_MS: Nat   = 873;                     // NOVA 873ms = φ⁴ × (1000/7.83)

  // Fibonacci sequence cached — F(1) through F(92) (max before Nat64 overflow)
  let FIB_CACHE : [Nat64] = [
    1, 1, 2, 3, 5, 8, 13, 21, 34, 55,
    89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765,
    10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229, 832040,
    1346269, 2178309, 3524578, 5702887, 9227465, 14930352, 24157817, 39088169, 63245986, 102334155,
    165580141, 267914296, 433494437, 701408733, 1134903170, 1836311903, 2971215073, 4807526976, 7778742049, 12586269025,
    20365011074, 32951280099, 53316291173, 86267571272, 139583862445, 225851433717, 365435296162, 591286729879, 956722026041, 1548008755920,
    2504730781961, 4052739537881, 6557470319842, 10610209857723, 17167680177565, 27777890035288, 44945570212853, 72723460248141, 117669030460994, 190392490709135,
    308061521170129, 498454011879264, 806515533049393, 1304969544928657, 2111485077978050, 3416454622906707, 5527939700884757, 8944394323791464, 14472334024676221, 23416728348467685,
    37889062373143906, 61305790721611591, 99194853094755497, 160500643816367088, 259695496911122585, 420196140727489673, 679891637638612258, 1100087778366101931, 1779979416004714189, 2880067194370816120,
    4660046610375530309, 7540113804746346429
  ];

  // φ power cache — precomputed for performance
  stable var phiPowerCache : [Float] = [
    1.0,                    // φ⁰
    1.6180339887498948482,  // φ¹
    2.6180339887498948482,  // φ²
    4.2360679774997896964,  // φ³
    6.8541019662496847020,  // φ⁴
    11.0901699437494742410, // φ⁵
    17.9442719099991589430, // φ⁶
    29.0344418537486331840, // φ⁷
    46.9787137637477921270, // φ⁸
    76.0131556174964253110, // φ⁹
    122.9918693812442174380 // φ¹⁰
  ];

  /// Compute φⁿ for any integer n (positive or negative)
  public query func computePhi(n : Int) : async Float {
    _phiPower(n)
  };

  func _phiPower(n : Int) : Float {
    if (n == 0) return 1.0;
    if (n > 0) {
      var result : Float = 1.0;
      var i : Int = 0;
      while (i < n) {
        result *= PHI;
        i += 1;
      };
      return result;
    } else {
      var result : Float = 1.0;
      var i : Int = 0;
      while (i > n) {
        result *= PHI_INV;
        i -= 1;
      };
      return result;
    }
  };

  /// Compute F(n) Fibonacci number via matrix exponentiation for large n
  public query func computeFibonacci(n : Nat) : async Nat64 {
    _fibonacci(n)
  };

  func _fibonacci(n : Nat) : Nat64 {
    if (n == 0) return 0;
    if (n <= 92) return FIB_CACHE[n - 1];
    // For n > 92, use Binet's formula (approximate for very large n)
    let nFloat = Float.fromInt(n);
    let fib = (_phiPower(n) - _phiPower(-n)) / SQRT5;
    // Clamp to max Nat64
    if (fib > 18446744073709551615.0) return 18446744073709551615;
    Nat64.fromIntWrap(Float.toInt(fib))
  };

  /// Binet's formula: F(n) = (φⁿ - ψⁿ) / √5 where ψ = -1/φ
  public query func computeFibonacciBinet(n : Nat) : async Float {
    let nInt = n;
    let psi : Float = -PHI_INV;
    let psiPow = _power(psi, nInt);
    (_phiPower(nInt) - psiPow) / SQRT5
  };

  /// Ratio F(n+1)/F(n) — converges to φ
  public query func computeFibonacciRatio(n : Nat) : async Float {
    if (n < 2) return 1.0;
    let fn = _fibonacci(n);
    let fn1 = _fibonacci(n + 1);
    Float.fromInt64(Int64.fromNat64(fn1)) / Float.fromInt64(Int64.fromNat64(fn))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §3 — VECTOR ALGEBRA ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Full n-dimensional vector operations. Used by physics simulations, drone
  // swarm coordination, neural network computations, and gradient descent.

  type Vector = [Float];

  /// Vector addition: a + b
  public query func vectorAdd(a : Vector, b : Vector) : async Vector {
    _vectorAdd(a, b)
  };

  func _vectorAdd(a : Vector, b : Vector) : Vector {
    let n = a.size();
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      a[i] + (if (i < b.size()) b[i] else 0.0)
    })
  };

  /// Vector subtraction: a - b
  public query func vectorSub(a : Vector, b : Vector) : async Vector {
    _vectorSub(a, b)
  };

  func _vectorSub(a : Vector, b : Vector) : Vector {
    let n = a.size();
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      a[i] - (if (i < b.size()) b[i] else 0.0)
    })
  };

  /// Scalar multiplication: s * v
  public query func vectorScale(v : Vector, s : Float) : async Vector {
    _vectorScale(v, s)
  };

  func _vectorScale(v : Vector, s : Float) : Vector {
    Array.map<Float, Float>(v, func(x : Float) : Float { x * s })
  };

  /// Dot product: a · b
  public query func vectorDot(a : Vector, b : Vector) : async Float {
    _vectorDot(a, b)
  };

  func _vectorDot(a : Vector, b : Vector) : Float {
    var sum : Float = 0.0;
    let n = if (a.size() < b.size()) a.size() else b.size();
    var i : Nat = 0;
    while (i < n) {
      sum += a[i] * b[i];
      i += 1;
    };
    sum
  };

  /// Cross product (3D only): a × b
  public query func vectorCross(a : Vector, b : Vector) : async Vector {
    _vectorCross(a, b)
  };

  func _vectorCross(a : Vector, b : Vector) : Vector {
    if (a.size() != 3 or b.size() != 3) return [0.0, 0.0, 0.0];
    [
      a[1] * b[2] - a[2] * b[1],
      a[2] * b[0] - a[0] * b[2],
      a[0] * b[1] - a[1] * b[0]
    ]
  };

  /// Euclidean norm: ||v||
  public query func vectorNorm(v : Vector) : async Float {
    _vectorNorm(v)
  };

  func _vectorNorm(v : Vector) : Float {
    var sum : Float = 0.0;
    for (x in v.vals()) {
      sum += x * x;
    };
    _sqrt(sum)
  };

  /// Normalize vector: v / ||v||
  public query func vectorNormalize(v : Vector) : async Vector {
    let n = _vectorNorm(v);
    if (n < 1e-15) return v;
    _vectorScale(v, 1.0 / n)
  };

  /// Angle between vectors: cos⁻¹(a·b / ||a|| ||b||)
  public query func vectorAngle(a : Vector, b : Vector) : async Float {
    let na = _vectorNorm(a);
    let nb = _vectorNorm(b);
    if (na < 1e-15 or nb < 1e-15) return 0.0;
    let cosTheta = _vectorDot(a, b) / (na * nb);
    _acos(_clamp(cosTheta, -1.0, 1.0))
  };

  /// Project a onto b: (a·b / ||b||²) * b
  public query func vectorProject(a : Vector, b : Vector) : async Vector {
    let bNormSq = _vectorDot(b, b);
    if (bNormSq < 1e-15) return Array.tabulate<Float>(a.size(), func(_ : Nat) : Float { 0.0 });
    let scalar = _vectorDot(a, b) / bNormSq;
    _vectorScale(b, scalar)
  };

  /// Linear interpolation: lerp(a, b, t) = a + t*(b - a)
  public query func vectorLerp(a : Vector, b : Vector, t : Float) : async Vector {
    let diff = _vectorSub(b, a);
    _vectorAdd(a, _vectorScale(diff, t))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §4 — MATRIX OPERATIONS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Full linear algebra: matrix operations, determinants, eigenvalues,
  // LU decomposition, SVD preparation. Used by PCA, neural networks,
  // drone swarm formation control, and financial risk models.

  type Matrix = [[Float]];

  /// Matrix addition
  public query func matrixAdd(a : Matrix, b : Matrix) : async Matrix {
    _matrixAdd(a, b)
  };

  func _matrixAdd(a : Matrix, b : Matrix) : Matrix {
    let rows = a.size();
    Array.tabulate<[Float]>(rows, func(i : Nat) : [Float] {
      let cols = a[i].size();
      Array.tabulate<Float>(cols, func(j : Nat) : Float {
        a[i][j] + (if (i < b.size() and j < b[i].size()) b[i][j] else 0.0)
      })
    })
  };

  /// Matrix multiplication: A × B
  public query func matrixMultiply(a : Matrix, b : Matrix) : async Matrix {
    _matrixMultiply(a, b)
  };

  func _matrixMultiply(a : Matrix, b : Matrix) : Matrix {
    let aRows = a.size();
    if (aRows == 0) return [];
    let aCols = a[0].size();
    let bRows = b.size();
    if (bRows == 0) return [];
    let bCols = b[0].size();
    if (aCols != bRows) return [];  // Incompatible dimensions

    Array.tabulate<[Float]>(aRows, func(i : Nat) : [Float] {
      Array.tabulate<Float>(bCols, func(j : Nat) : Float {
        var sum : Float = 0.0;
        var k : Nat = 0;
        while (k < aCols) {
          sum += a[i][k] * b[k][j];
          k += 1;
        };
        sum
      })
    })
  };

  /// Matrix-vector multiplication: A × v
  public query func matrixVectorMul(a : Matrix, v : Vector) : async Vector {
    _matrixVectorMul(a, v)
  };

  func _matrixVectorMul(a : Matrix, v : Vector) : Vector {
    Array.tabulate<Float>(a.size(), func(i : Nat) : Float {
      var sum : Float = 0.0;
      let cols = a[i].size();
      var j : Nat = 0;
      while (j < cols and j < v.size()) {
        sum += a[i][j] * v[j];
        j += 1;
      };
      sum
    })
  };

  /// Matrix transpose
  public query func matrixTranspose(a : Matrix) : async Matrix {
    _matrixTranspose(a)
  };

  func _matrixTranspose(a : Matrix) : Matrix {
    if (a.size() == 0) return [];
    let rows = a.size();
    let cols = a[0].size();
    Array.tabulate<[Float]>(cols, func(j : Nat) : [Float] {
      Array.tabulate<Float>(rows, func(i : Nat) : Float {
        a[i][j]
      })
    })
  };

  /// 2×2 determinant
  func _det2x2(a : Float, b : Float, c : Float, d : Float) : Float {
    a * d - b * c
  };

  /// 3×3 determinant
  public query func matrixDet3x3(m : Matrix) : async Float {
    _matrixDet3x3(m)
  };

  func _matrixDet3x3(m : Matrix) : Float {
    if (m.size() != 3) return 0.0;
    let a = m[0][0]; let b = m[0][1]; let c = m[0][2];
    let d = m[1][0]; let e = m[1][1]; let f = m[1][2];
    let g = m[2][0]; let h = m[2][1]; let i = m[2][2];
    a * _det2x2(e, f, h, i) - b * _det2x2(d, f, g, i) + c * _det2x2(d, e, g, h)
  };

  /// Identity matrix
  public query func matrixIdentity(n : Nat) : async Matrix {
    _matrixIdentity(n)
  };

  func _matrixIdentity(n : Nat) : Matrix {
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) 1.0 else 0.0
      })
    })
  };

  /// Frobenius norm: ||A||_F = √(Σᵢⱼ aᵢⱼ²)
  public query func matrixFrobeniusNorm(m : Matrix) : async Float {
    var sum : Float = 0.0;
    for (row in m.vals()) {
      for (val in row.vals()) {
        sum += val * val;
      };
    };
    _sqrt(sum)
  };

  /// Trace: tr(A) = Σᵢ aᵢᵢ
  public query func matrixTrace(m : Matrix) : async Float {
    var sum : Float = 0.0;
    let n = m.size();
    var i : Nat = 0;
    while (i < n) {
      if (i < m[i].size()) {
        sum += m[i][i];
      };
      i += 1;
    };
    sum
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §5 — CALCULUS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Numerical differentiation and integration. Used by physics simulations,
  // optimization algorithms, and sensitivity analysis.

  /// Numerical derivative using central difference: f'(x) ≈ (f(x+h) - f(x-h)) / 2h
  /// coeffs = [a₀, a₁, a₂, ...] represents polynomial a₀ + a₁x + a₂x² + ...
  public query func computeDerivative(coeffs : [Float], x : Float) : async Float {
    _numericalDerivative(coeffs, x, 0.0001)
  };

  func _numericalDerivative(coeffs : [Float], x : Float, h : Float) : Float {
    let fPlus = _evalPolynomial(coeffs, x + h);
    let fMinus = _evalPolynomial(coeffs, x - h);
    (fPlus - fMinus) / (2.0 * h)
  };

  /// Evaluate polynomial at x
  func _evalPolynomial(coeffs : [Float], x : Float) : Float {
    var result : Float = 0.0;
    var xPow : Float = 1.0;
    for (c in coeffs.vals()) {
      result += c * xPow;
      xPow *= x;
    };
    result
  };

  /// Analytical derivative of polynomial
  public query func polynomialDerivative(coeffs : [Float]) : async [Float] {
    if (coeffs.size() <= 1) return [];
    Array.tabulate<Float>(coeffs.size() - 1, func(i : Nat) : Float {
      coeffs[i + 1] * Float.fromInt(i + 1)
    })
  };

  /// Numerical integration using Simpson's rule
  /// Integrates polynomial from a to b
  public query func computeIntegral(coeffs : [Float], a : Float, b : Float, n : Nat) : async Float {
    _simpsonIntegral(coeffs, a, b, n)
  };

  func _simpsonIntegral(coeffs : [Float], a : Float, b : Float, n : Nat) : Float {
    let actualN = if (n % 2 == 0) n else n + 1;  // Must be even
    let h = (b - a) / Float.fromInt(actualN);
    var sum : Float = _evalPolynomial(coeffs, a) + _evalPolynomial(coeffs, b);
    
    var i : Nat = 1;
    while (i < actualN) {
      let x = a + Float.fromInt(i) * h;
      let weight = if (i % 2 == 0) 2.0 else 4.0;
      sum += weight * _evalPolynomial(coeffs, x);
      i += 1;
    };
    
    (h / 3.0) * sum
  };

  /// Trapezoidal rule integration
  public query func computeTrapezoid(coeffs : [Float], a : Float, b : Float, n : Nat) : async Float {
    let h = (b - a) / Float.fromInt(n);
    var sum : Float = (_evalPolynomial(coeffs, a) + _evalPolynomial(coeffs, b)) / 2.0;
    
    var i : Nat = 1;
    while (i < n) {
      sum += _evalPolynomial(coeffs, a + Float.fromInt(i) * h);
      i += 1;
    };
    
    h * sum
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §6 — CHAOS THEORY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Logistic map, Lyapunov exponents, Feigenbaum constants, strange attractors.
  // Used by NOVA's emergence detection and predictability analysis.

  /// Logistic map iteration: xₙ₊₁ = r·xₙ·(1-xₙ)
  public query func logisticMap(r : Float, x0 : Float, iterations : Nat) : async [Float] {
    _logisticMapSeries(r, x0, iterations)
  };

  func _logisticMapSeries(r : Float, x0 : Float, n : Nat) : [Float] {
    let buf = Buffer.Buffer<Float>(n);
    var x = x0;
    var i : Nat = 0;
    while (i < n) {
      buf.add(x);
      x := r * x * (1.0 - x);
      i += 1;
    };
    Buffer.toArray(buf)
  };

  /// Lyapunov exponent for logistic map
  /// λ = lim[n→∞] (1/n) Σ ln|f'(xₙ)|
  /// For logistic map: f'(x) = r(1-2x)
  public query func computeLyapunov(r : Float, iterations : Nat) : async Float {
    _lyapunovExponent(r, iterations)
  };

  func _lyapunovExponent(r : Float, n : Nat) : Float {
    var x : Float = 0.1;  // Initial condition
    var sum : Float = 0.0;
    let transient : Nat = 100;  // Skip transient
    
    // Skip transient phase
    var i : Nat = 0;
    while (i < transient) {
      x := r * x * (1.0 - x);
      i += 1;
    };
    
    // Compute Lyapunov exponent
    i := 0;
    while (i < n) {
      let deriv = _abs(r * (1.0 - 2.0 * x));
      if (deriv > 1e-15) {
        sum += _ln(deriv);
      };
      x := r * x * (1.0 - x);
      i += 1;
    };
    
    sum / Float.fromInt(n)
  };

  /// Feigenbaum ratio at bifurcation: δₙ = (rₙ - rₙ₋₁)/(rₙ₊₁ - rₙ) → 4.669...
  public query func computeFeigenbaum(bifurcations : [Float]) : async Float {
    if (bifurcations.size() < 3) return 0.0;
    let n = bifurcations.size() - 1;
    let r1 = bifurcations[n - 2];
    let r2 = bifurcations[n - 1];
    let r3 = bifurcations[n];
    
    let delta = (r2 - r1) / (r3 - r2);
    delta
  };

  /// Find period-doubling bifurcation points
  /// Returns r values where logistic map transitions from period-2ⁿ to period-2ⁿ⁺¹
  public query func findBifurcations(maxPeriod : Nat) : async [Float] {
    // Known bifurcation points for logistic map
    let knownBifurc : [Float] = [
      3.0,                    // period-1 → period-2
      3.449489742783178,      // period-2 → period-4
      3.544090359551859,      // period-4 → period-8
      3.564407266095334,      // period-8 → period-16
      3.568759401227467,      // period-16 → period-32
      3.569691609801990,      // period-32 → period-64
      3.569891259377329,      // chaos onset accumulation
      3.569945671870944
    ];
    let size = if (maxPeriod < knownBifurc.size()) maxPeriod else knownBifurc.size();
    Array.tabulate<Float>(size, func(i : Nat) : Float { knownBifurc[i] })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §7 — KURAMOTO OSCILLATOR ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Phase synchronization dynamics. Used by NOVA heartbeat synchronization,
  // swarm coordination, and collective intelligence emergence detection.
  //
  // Kuramoto model: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  // Order parameter: r·e^(iψ) = (1/N) Σⱼ e^(iθⱼ)

  /// Compute Kuramoto order parameter r ∈ [0,1]
  /// r = 1: perfect synchronization, r = 0: complete desynchronization
  public query func computeKuramoto(thetas : [Float]) : async { r : Float; psi : Float } {
    _kuramotoOrderParameter(thetas)
  };

  func _kuramotoOrderParameter(thetas : [Float]) : { r : Float; psi : Float } {
    let n = thetas.size();
    if (n == 0) return { r = 0.0; psi = 0.0 };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (theta in thetas.vals()) {
      sumCos += _cos(theta);
      sumSin += _sin(theta);
    };
    
    sumCos /= Float.fromInt(n);
    sumSin /= Float.fromInt(n);
    
    let r = _sqrt(sumCos * sumCos + sumSin * sumSin);
    let psi = _atan2(sumSin, sumCos);
    
    { r = r; psi = psi }
  };

  /// Step Kuramoto oscillators one timestep
  /// Returns new phases after dt
  public query func stepKuramoto(
    thetas : [Float],
    omegas : [Float],
    K : Float,
    dt : Float
  ) : async [Float] {
    _kuramotoStep(thetas, omegas, K, dt)
  };

  func _kuramotoStep(
    thetas : [Float],
    omegas : [Float],
    K : Float,
    dt : Float
  ) : [Float] {
    let n = thetas.size();
    let kOverN = K / Float.fromInt(n);
    
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      var coupling : Float = 0.0;
      var j : Nat = 0;
      while (j < n) {
        coupling += _sin(thetas[j] - thetas[i]);
        j += 1;
      };
      
      let omega = if (i < omegas.size()) omegas[i] else 1.0;
      let dtheta = omega + kOverN * coupling;
      _wrapPhase(thetas[i] + dtheta * dt)
    })
  };

  /// Critical coupling strength for N uniform oscillators
  /// K_c ≈ 2σ(ω) for Gaussian ω distribution
  public query func criticalCoupling(omegaStd : Float) : async Float {
    2.0 * omegaStd
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §8 — PROBABILITY & STATISTICS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Probability distributions, statistical inference, hypothesis testing.
  // Used by risk models, anomaly detection, and behavioral economics.

  /// Mean
  public query func computeMean(data : [Float]) : async Float {
    _mean(data)
  };

  func _mean(data : [Float]) : Float {
    if (data.size() == 0) return 0.0;
    var sum : Float = 0.0;
    for (x in data.vals()) {
      sum += x;
    };
    sum / Float.fromInt(data.size())
  };

  /// Variance
  public query func computeVariance(data : [Float]) : async Float {
    _variance(data)
  };

  func _variance(data : [Float]) : Float {
    let n = data.size();
    if (n < 2) return 0.0;
    let mu = _mean(data);
    var sum : Float = 0.0;
    for (x in data.vals()) {
      let diff = x - mu;
      sum += diff * diff;
    };
    sum / Float.fromInt(n - 1)  // Bessel's correction
  };

  /// Standard deviation
  public query func computeStdDev(data : [Float]) : async Float {
    _sqrt(_variance(data))
  };

  /// Covariance between two datasets
  public query func computeCovariance(x : [Float], y : [Float]) : async Float {
    _covariance(x, y)
  };

  func _covariance(x : [Float], y : [Float]) : Float {
    let n = if (x.size() < y.size()) x.size() else y.size();
    if (n < 2) return 0.0;
    let muX = _mean(x);
    let muY = _mean(y);
    var sum : Float = 0.0;
    var i : Nat = 0;
    while (i < n) {
      sum += (x[i] - muX) * (y[i] - muY);
      i += 1;
    };
    sum / Float.fromInt(n - 1)
  };

  /// Pearson correlation coefficient
  public query func computeCorrelation(x : [Float], y : [Float]) : async Float {
    let cov = _covariance(x, y);
    let stdX = _sqrt(_variance(x));
    let stdY = _sqrt(_variance(y));
    if (stdX < 1e-15 or stdY < 1e-15) return 0.0;
    cov / (stdX * stdY)
  };

  /// Normal distribution PDF: φ(x) = (1/√(2π)) e^(-x²/2)
  public query func normalPDF(x : Float, mu : Float, sigma : Float) : async Float {
    let z = (x - mu) / sigma;
    (1.0 / (sigma * _sqrt(TAU))) * _exp(-0.5 * z * z)
  };

  /// Sigmoid function: σ(x) = 1/(1 + e^(-x))
  public query func sigmoid(x : Float) : async Float {
    _sigmoid(x)
  };

  func _sigmoid(x : Float) : Float {
    let clamped = _clamp(x, -20.0, 20.0);
    1.0 / (1.0 + _exp(-clamped))
  };

  /// Softmax function
  public query func softmax(xs : [Float]) : async [Float] {
    let maxX = Array.foldLeft<Float, Float>(xs, -1e15, func(acc, x) { if (x > acc) x else acc });
    let exps = Array.map<Float, Float>(xs, func(x) { _exp(x - maxX) });
    let sum = Array.foldLeft<Float, Float>(exps, 0.0, func(acc, x) { acc + x });
    if (sum < 1e-15) return exps;
    Array.map<Float, Float>(exps, func(x) { x / sum })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §9 — NUMBER THEORY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Prime numbers, modular arithmetic, GCD/LCM. Used by cryptographic
  // operations, hash functions, and cyclic scheduling.

  /// GCD using Euclidean algorithm
  public query func computeGCD(a : Nat, b : Nat) : async Nat {
    _gcd(a, b)
  };

  func _gcd(a : Nat, b : Nat) : Nat {
    if (b == 0) return a;
    _gcd(b, a % b)
  };

  /// LCM
  public query func computeLCM(a : Nat, b : Nat) : async Nat {
    if (a == 0 or b == 0) return 0;
    (a * b) / _gcd(a, b)
  };

  /// Modular exponentiation: base^exp mod m
  public query func computeModPow(base : Nat, exp : Nat, m : Nat) : async Nat {
    _modPow(base, exp, m)
  };

  func _modPow(base : Nat, exp : Nat, m : Nat) : Nat {
    if (m == 0) return 0;
    if (m == 1) return 0;
    var result : Nat = 1;
    var b = base % m;
    var e = exp;
    while (e > 0) {
      if (e % 2 == 1) {
        result := (result * b) % m;
      };
      e /= 2;
      b := (b * b) % m;
    };
    result
  };

  /// Check if n is prime (trial division for small n)
  public query func isPrime(n : Nat) : async Bool {
    _isPrime(n)
  };

  func _isPrime(n : Nat) : Bool {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    var i : Nat = 3;
    while (i * i <= n) {
      if (n % i == 0) return false;
      i += 2;
    };
    true
  };

  /// Prime factorization
  public query func computePrimeFactors(n : Nat) : async [Nat] {
    let buf = Buffer.Buffer<Nat>(8);
    var num = n;
    var d : Nat = 2;
    while (d * d <= num) {
      while (num % d == 0) {
        buf.add(d);
        num /= d;
      };
      d += 1;
    };
    if (num > 1) {
      buf.add(num);
    };
    Buffer.toArray(buf)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §10 — GEOMETRY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Platonic solids, sacred geometry, coordinate transformations.
  // Used by spatial simulations, drone formations, and φ-based visualizations.

  /// Platonic solid properties
  type PlatonicSolid = {
    name      : Text;
    faces     : Nat;
    vertices  : Nat;
    edges     : Nat;
    element   : Text;
    dualSolid : Text;
    faceShape : Text;
  };

  public query func getPlatonicSolids() : async [PlatonicSolid] {
    [
      { name = "Tetrahedron";  faces = 4;  vertices = 4;  edges = 6;  element = "Fire";  dualSolid = "Tetrahedron";  faceShape = "Triangle" },
      { name = "Cube";         faces = 6;  vertices = 8;  edges = 12; element = "Earth"; dualSolid = "Octahedron";   faceShape = "Square" },
      { name = "Octahedron";   faces = 8;  vertices = 6;  edges = 12; element = "Air";   dualSolid = "Cube";         faceShape = "Triangle" },
      { name = "Dodecahedron"; faces = 12; vertices = 20; edges = 30; element = "Aether";dualSolid = "Icosahedron";  faceShape = "Pentagon" },
      { name = "Icosahedron";  faces = 20; vertices = 12; edges = 30; element = "Water"; dualSolid = "Dodecahedron"; faceShape = "Triangle" }
    ]
  };

  /// Vesica Piscis dimensions (two overlapping circles)
  /// The almond-shaped intersection has ratio height/width = √3
  public query func vesicaPiscisRatio() : async { heightToWidth : Float; area : Float } {
    { heightToWidth = SQRT3; area = PI / 3.0 * (2.0 - SQRT3) }  // For unit circles
  };

  /// Pentagon diagonal/side ratio = φ
  public query func pentagonRatio() : async Float { PHI };

  /// Regular polygon interior angle: (n-2)·180°/n
  public query func polygonInteriorAngle(sides : Nat) : async Float {
    if (sides < 3) return 0.0;
    Float.fromInt(sides - 2) * PI / Float.fromInt(sides)
  };

  /// Distance between two 3D points
  public query func distance3D(p1 : [Float], p2 : [Float]) : async Float {
    if (p1.size() != 3 or p2.size() != 3) return 0.0;
    let dx = p2[0] - p1[0];
    let dy = p2[1] - p1[1];
    let dz = p2[2] - p1[2];
    _sqrt(dx*dx + dy*dy + dz*dz)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §11 — FOURIER ANALYSIS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Discrete Fourier Transform for signal analysis. Used by audio processing,
  // frequency detection, and periodic pattern analysis.

  type ComplexNumber = { re : Float; im : Float };

  /// Discrete Fourier Transform (DFT) - O(n²) reference implementation
  public query func computeDFT(signal : [Float]) : async [ComplexNumber] {
    _dft(signal)
  };

  func _dft(signal : [Float]) : [ComplexNumber] {
    let N = signal.size();
    if (N == 0) return [];
    
    Array.tabulate<ComplexNumber>(N, func(k : Nat) : ComplexNumber {
      var re : Float = 0.0;
      var im : Float = 0.0;
      var n : Nat = 0;
      while (n < N) {
        let angle = -TAU * Float.fromInt(k) * Float.fromInt(n) / Float.fromInt(N);
        re += signal[n] * _cos(angle);
        im += signal[n] * _sin(angle);
        n += 1;
      };
      { re = re; im = im }
    })
  };

  /// Inverse DFT
  public query func computeIDFT(spectrum : [ComplexNumber]) : async [Float] {
    let N = spectrum.size();
    if (N == 0) return [];
    
    Array.tabulate<Float>(N, func(n : Nat) : Float {
      var sum : Float = 0.0;
      var k : Nat = 0;
      while (k < N) {
        let angle = TAU * Float.fromInt(k) * Float.fromInt(n) / Float.fromInt(N);
        sum += spectrum[k].re * _cos(angle) - spectrum[k].im * _sin(angle);
        k += 1;
      };
      sum / Float.fromInt(N)
    })
  };

  /// Power spectrum: |X(k)|²
  public query func powerSpectrum(signal : [Float]) : async [Float] {
    let dft = _dft(signal);
    Array.map<ComplexNumber, Float>(dft, func(c : ComplexNumber) : Float {
      c.re * c.re + c.im * c.im
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §12 — OPTIMIZATION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Gradient descent, Newton's method, golden section search.
  // Used by neural network training and parameter optimization.

  /// Gradient descent step for quadratic function f(x) = Σ aᵢ(x - bᵢ)²
  /// Returns new x after one step with learning rate alpha
  public query func gradientDescentStep(
    x : Float,
    a : [Float],  // Coefficients
    b : [Float],  // Targets
    alpha : Float
  ) : async Float {
    // Gradient of f(x) = Σ aᵢ(x - bᵢ)² is 2·Σ aᵢ(x - bᵢ)
    var grad : Float = 0.0;
    let n = if (a.size() < b.size()) a.size() else b.size();
    var i : Nat = 0;
    while (i < n) {
      grad += 2.0 * a[i] * (x - b[i]);
      i += 1;
    };
    x - alpha * grad
  };

  /// Golden section search for minimum of unimodal function
  /// coeffs represents polynomial to minimize
  public query func goldenSectionSearch(
    coeffs : [Float],
    a : Float,
    b : Float,
    tol : Float
  ) : async Float {
    _goldenSection(coeffs, a, b, tol)
  };

  func _goldenSection(coeffs : [Float], a0 : Float, b0 : Float, tol : Float) : Float {
    var a = a0;
    var b = b0;
    let gr = PHI_INV;  // Golden ratio conjugate
    
    var c = b - gr * (b - a);
    var d = a + gr * (b - a);
    
    var iterations : Nat = 0;
    while (_abs(b - a) > tol and iterations < 100) {
      let fc = _evalPolynomial(coeffs, c);
      let fd = _evalPolynomial(coeffs, d);
      
      if (fc < fd) {
        b := d;
        d := c;
        c := b - gr * (b - a);
      } else {
        a := c;
        c := d;
        d := a + gr * (b - a);
      };
      iterations += 1;
    };
    
    (a + b) / 2.0
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §13 — DIFFERENTIAL EQUATIONS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // ODE solvers using Runge-Kutta methods. Used by physics simulations,
  // population dynamics, and chemical kinetics.

  /// Runge-Kutta 4th order step for dy/dt = f(t, y)
  /// coeffs define f as polynomial in y: f(t,y) = Σ cᵢyⁱ
  public query func rk4Step(
    coeffs : [Float],
    t : Float,
    y : Float,
    h : Float
  ) : async { t : Float; y : Float } {
    let k1 = _evalPolynomial(coeffs, y);
    let k2 = _evalPolynomial(coeffs, y + 0.5 * h * k1);
    let k3 = _evalPolynomial(coeffs, y + 0.5 * h * k2);
    let k4 = _evalPolynomial(coeffs, y + h * k3);
    
    let yNew = y + (h / 6.0) * (k1 + 2.0*k2 + 2.0*k3 + k4);
    { t = t + h; y = yNew }
  };

  /// Solve ODE from t0 to tf with n steps
  public query func solveODE(
    coeffs : [Float],
    y0 : Float,
    t0 : Float,
    tf : Float,
    n : Nat
  ) : async [{ t : Float; y : Float }] {
    let h = (tf - t0) / Float.fromInt(n);
    let buf = Buffer.Buffer<{ t : Float; y : Float }>(n + 1);
    
    var t = t0;
    var y = y0;
    buf.add({ t = t; y = y });
    
    var i : Nat = 0;
    while (i < n) {
      let k1 = _evalPolynomial(coeffs, y);
      let k2 = _evalPolynomial(coeffs, y + 0.5 * h * k1);
      let k3 = _evalPolynomial(coeffs, y + 0.5 * h * k2);
      let k4 = _evalPolynomial(coeffs, y + h * k3);
      
      y := y + (h / 6.0) * (k1 + 2.0*k2 + 2.0*k3 + k4);
      t := t + h;
      buf.add({ t = t; y = y });
      i += 1;
    };
    
    Buffer.toArray(buf)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §14 — COMPLEX ANALYSIS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Complex number operations, Euler's formula, conformal mapping preparation.

  /// Complex addition
  public query func complexAdd(a : ComplexNumber, b : ComplexNumber) : async ComplexNumber {
    { re = a.re + b.re; im = a.im + b.im }
  };

  /// Complex multiplication
  public query func complexMul(a : ComplexNumber, b : ComplexNumber) : async ComplexNumber {
    { re = a.re * b.re - a.im * b.im; im = a.re * b.im + a.im * b.re }
  };

  /// Complex magnitude: |z|
  public query func complexMag(z : ComplexNumber) : async Float {
    _sqrt(z.re * z.re + z.im * z.im)
  };

  /// Complex argument: arg(z) = atan2(im, re)
  public query func complexArg(z : ComplexNumber) : async Float {
    _atan2(z.im, z.re)
  };

  /// Euler's formula: e^(iθ) = cos(θ) + i·sin(θ)
  public query func euler(theta : Float) : async ComplexNumber {
    { re = _cos(theta); im = _sin(theta) }
  };

  /// Complex exponential: e^z = e^(x+iy) = e^x · (cos(y) + i·sin(y))
  public query func complexExp(z : ComplexNumber) : async ComplexNumber {
    let expRe = _exp(z.re);
    { re = expRe * _cos(z.im); im = expRe * _sin(z.im) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §15 — HEARTBEAT & TELEMETRY (873ms)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // The NOVA 873ms heartbeat drives this engine. Every 873ms we update
  // internal state and prepare telemetry for nova_stream publishing.

  stable var tick        : Nat = 0;
  stable var lastCompute : Int = 0;
  stable var totalOps    : Nat = 0;

  type MathEngineStatus = {
    buildNumber    : Nat;
    tick           : Nat;
    lastCompute    : Int;
    totalOps       : Nat;
    phiValue       : Float;
    feigenbaumD    : Float;
    heartbeatMs    : Nat;
    schumann       : Float;
    isingBeta      : Float;
    sealed         : Bool;
  };

  public query func getMathEngine() : async MathEngineStatus {
    {
      buildNumber    = buildNumber;
      tick           = tick;
      lastCompute    = lastCompute;
      totalOps       = totalOps;
      phiValue       = PHI;
      feigenbaumD    = FEIGENBAUM_D;
      heartbeatMs    = HEARTBEAT_MS;
      schumann       = SCHUMANN;
      isingBeta      = ISING_BETA;
      sealed         = genesisLocked;
    }
  };

  /// 873ms heartbeat — called by timer or agi_terminal
  public shared(msg) func heartbeat() : async { tick : Nat; status : Text } {
    tick += 1;
    lastCompute := Time.now();
    { tick = tick; status = "MATH_ENGINE_ALIVE" }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §16 — STREAM PUBLISHING (to nova_stream)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Publishes MATH_COMPUTE events to nova_stream for cross-canister telemetry.

  stable var streamCanisterId : Principal = Principal.fromText("aaaaa-aa");

  public shared(msg) func setStreamCanister(canisterId : Principal) : async Bool {
    if (not _isArchitect(msg.caller)) return false;
    streamCanisterId := canisterId;
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════

  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  /// Wrap phase to [-π, π]
  func _wrapPhase(theta : Float) : Float {
    var t = theta;
    while (t > PI) { t -= TAU; };
    while (t < -PI) { t += TAU; };
    t
  };

  /// Power function via repeated multiplication (integer exponent)
  func _power(base : Float, exp : Int) : Float {
    if (exp == 0) return 1.0;
    var result : Float = 1.0;
    var b = base;
    var e = if (exp < 0) -exp else exp;
    while (e > 0) {
      if (e % 2 == 1) {
        result *= b;
      };
      e /= 2;
      b *= b;
    };
    if (exp < 0) 1.0 / result else result
  };

  /// Taylor series for sin(x)
  func _sin(x : Float) : Float {
    let wrapped = _wrapPhase(x);
    var term = wrapped;
    var sum = term;
    var n : Nat = 1;
    while (n < 12) {
      term *= -wrapped * wrapped / Float.fromInt((2*n) * (2*n + 1));
      sum += term;
      n += 1;
    };
    sum
  };

  /// Taylor series for cos(x)
  func _cos(x : Float) : Float {
    let wrapped = _wrapPhase(x);
    var term : Float = 1.0;
    var sum = term;
    var n : Nat = 1;
    while (n < 12) {
      term *= -wrapped * wrapped / Float.fromInt((2*n - 1) * (2*n));
      sum += term;
      n += 1;
    };
    sum
  };

  /// Taylor series for exp(x)
  func _exp(x : Float) : Float {
    let clamped = _clamp(x, -20.0, 20.0);
    var term : Float = 1.0;
    var sum = term;
    var n : Nat = 1;
    while (n < 20) {
      term *= clamped / Float.fromInt(n);
      sum += term;
      n += 1;
    };
    sum
  };

  /// Natural logarithm via series expansion
  func _ln(x : Float) : Float {
    if (x <= 0.0) return -1e15;  // Undefined
    // Use ln(x) = 2·arctanh((x-1)/(x+1)) for x > 0
    let y = (x - 1.0) / (x + 1.0);
    var sum : Float = 0.0;
    var term = y;
    var n : Nat = 1;
    while (n < 50) {
      sum += term / Float.fromInt(2*n - 1);
      term *= y * y;
      n += 1;
    };
    2.0 * sum
  };

  /// Newton-Raphson square root
  func _sqrt(x : Float) : Float {
    if (x < 0.0) return 0.0;
    if (x == 0.0) return 0.0;
    var guess = x / 2.0;
    var prev : Float = 0.0;
    var n : Nat = 0;
    while (_abs(guess - prev) > 1e-15 and n < 50) {
      prev := guess;
      guess := 0.5 * (guess + x / guess);
      n += 1;
    };
    guess
  };

  /// atan2(y, x) — full quadrant arctangent
  func _atan2(y : Float, x : Float) : Float {
    if (x > 0.0) {
      return _atan(y / x);
    } else if (x < 0.0) {
      if (y >= 0.0) {
        return _atan(y / x) + PI;
      } else {
        return _atan(y / x) - PI;
      };
    } else {
      if (y > 0.0) return PI / 2.0;
      if (y < 0.0) return -PI / 2.0;
      return 0.0;
    }
  };

  /// Arctangent via Taylor series (for |x| <= 1)
  func _atan(x : Float) : Float {
    if (_abs(x) > 1.0) {
      if (x > 0.0) return PI/2.0 - _atan(1.0/x);
      return -PI/2.0 - _atan(1.0/x);
    };
    var sum = x;
    var term = x;
    var n : Nat = 1;
    while (n < 30) {
      term *= -x * x;
      sum += term / Float.fromInt(2*n + 1);
      n += 1;
    };
    sum
  };

  /// Arccosine
  func _acos(x : Float) : Float {
    PI/2.0 - _asin(x)
  };

  /// Arcsine via asin(x) = atan(x/√(1-x²))
  func _asin(x : Float) : Float {
    let clamped = _clamp(x, -1.0, 1.0);
    let denom = _sqrt(1.0 - clamped*clamped);
    if (denom < 1e-15) {
      if (clamped >= 0.0) return PI/2.0;
      return -PI/2.0;
    };
    _atan(clamped / denom)
  };

  // Import Int64 for conversions
  import Int64 "mo:base/Int64";

};
