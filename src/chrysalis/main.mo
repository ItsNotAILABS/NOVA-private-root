// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine — Native Nova Protocol                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// NATIVE NOVA PROTOCOL — BUILD №30
// CHRYSALIS — Alpha Organism №1 — Golden Mathematics Core
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// CHRYSALIS IS THE DNA.
// Every other organism queries CHRYSALIS for growth constants, spiral coordinates,
// and distribution patterns. The golden ratio is not chosen — it is derived from
// the requirement that growth be self-similar at every scale.
//
// Sub-models hosted:
//   FIBONACCI — Sequence generation, Binet's formula, Zeckendorf decomposition
//   SPIRAL    — Spatial distribution: phyllotaxis, sphere lattice, golden partitions
//
// Generation advancement thresholds (Fibonacci numbers):
//   Count: 1  2  3  5  8  13  21  34  55  89
//   Gen:   1  2  3  4  5   6   7   8   9  10
//
// ALL PUBLIC FUNCTIONS ARE PURE QUERIES — CHRYSALIS NEVER MUTATES ON READ.

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor Chrysalis {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var buildNumber        : Nat       = 30;  // Build №30 — Native Nova Protocol

  func isAuthorized(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == architectPrincipal
  };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "CHRYSALIS_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-CHRYSALIS-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func getBuildNum()  : async Nat  { buildNumber };
  public query func isLocked()     : async Bool { genesisLocked };
  public query func getTimestamp() : async Int  { genesisTimestamp };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN PRIMITIVES (embedded constants)
  // φ = (1 + √5) / 2 ≈ 1.6180339887498948482
  // ψ = (1 − √5) / 2 ≈ −0.6180339887498948482  (conjugate)
  // φ² = φ + 1  (defining property)
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI       : Float = 1.6180339887498948482;   // Golden ratio
  let PHI_INV   : Float = 0.6180339887498948482;   // 1/φ = φ − 1
  let PHI_SQ    : Float = 2.6180339887498948482;   // φ² = φ + 1
  let PSI       : Float = -0.6180339887498948482;  // conjugate (1−√5)/2
  let SQRT5     : Float = 2.2360679774997896964;   // √5
  let PI        : Float = 3.14159265358979323846;
  let TWO_PI    : Float = 6.28318530717958647692;
  let GOLDEN_ANGLE_RAD : Float = 2.39996322972865332;   // θ = 2π(2−φ) ≈ 137.508°
  let GOLDEN_ANGLE_DEG : Float = 137.50776405003785;
  let EPSILON   : Float = 1.0e-10;

  // ── Private math helpers ─────────────────────────────────────────────────

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) {
      if (exp == 0.0) 1.0 else 0.0
    } else {
      Float.exp(exp * Float.log(base))
    }
  };

  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };

  func _arccos(x : Float) : Float {
    let xc = if (x < -1.0) -1.0 else if (x > 1.0) 1.0 else x;
    Float.arctan2(_sqrt(1.0 - xc * xc), xc)
  };

  func _mod(a : Float, b : Float) : Float {
    if (b < EPSILON) 0.0
    else a - Float.fromInt(Int.abs(Float.toInt(a / b))) * b
  };

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  // ── Iterative nth Fibonacci (exact) ─────────────────────────────────────

  func _nthFib(n : Nat) : Float {
    if (n == 0) return 0.0;
    if (n == 1) return 1.0;
    var a : Float = 0.0;
    var b : Float = 1.0;
    var i : Nat   = 2;
    while (i <= n) { let c = a + b; a := b; b := c; i += 1 };
    b
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUB-MODEL: FIBONACCI
  // Sequence generation, Binet's formula, Zeckendorf decomposition,
  // generation advancement, golden ratio properties.
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Return F(n) using iterative method (exact) ───────────────────────────
  public query func fibonacci(n : Nat) : async Float {
    _nthFib(n)
  };

  // ── Binet's closed form: F(n) = (φⁿ − ψⁿ) / √5 ─────────────────────────
  public query func fibonacciBinet(n : Nat) : async Float {
    let nf    = Float.fromInt(n);
    let phi_n = _pow(PHI, nf);
    let psi_n = if (n mod 2 == 0) _pow(-PSI, nf) else -_pow(-PSI, nf);
    (phi_n - psi_n) / SQRT5
  };

  // ── First N Fibonacci numbers as an array ────────────────────────────────
  public query func fibonacciSequence(n : Nat) : async [Float] {
    Array.tabulate<Float>(n, func(i) { _nthFib(i) })
  };

  // ── Ratio F(n+1)/F(n) — converges to φ ──────────────────────────────────
  public query func fibonacciRatio(n : Nat) : async Float {
    if (n == 0) return 0.0;
    let fn   = _nthFib(n);
    let fn_1 = _nthFib(n + 1);
    if (fn < EPSILON) PHI else fn_1 / fn
  };

  // ── |F(n+1)/F(n) − φ| — convergence error ───────────────────────────────
  public query func fibonacciConvergenceError(n : Nat) : async Float {
    if (n == 0) return _abs(1.0 - PHI);
    let fn   = _nthFib(n);
    let fn_1 = _nthFib(n + 1);
    if (fn < EPSILON) 0.0 else _abs(fn_1 / fn - PHI)
  };

  // ── Zeckendorf decomposition ─────────────────────────────────────────────
  // Every positive integer has a unique representation as a sum of
  // non-consecutive Fibonacci numbers (Zeckendorf's Theorem).
  // Greedy algorithm: subtract the largest Fibonacci ≤ n, skip one, repeat.
  public query func zeckendorfDecompose(n : Nat) : async {
    indices : [Nat];
    fibValues : [Nat];
    representation : Text;
  } {
    if (n == 0) return { indices = []; fibValues = []; representation = "0" };

    // Build fib table up to n
    var fibTable : [var Nat] = Array.init<Nat>(100, 0);
    fibTable[0] := 1;
    fibTable[1] := 2;
    var count : Nat = 2;
    while (count < 100) {
      let nxt = fibTable[count - 1] + fibTable[count - 2];
      if (nxt > n * 10 + 100) { count := 100 }  // cap
      else {
        fibTable[count] := nxt;
        count += 1;
      }
    };
    // Find highest fib ≤ n and greedily subtract
    var remaining = n;
    var idxList  : [Nat] = [];
    var valList  : [Nat] = [];
    // Scan downward from highest built fib
    var i : Nat = count;
    while (i > 0 and remaining > 0) {
      i -= 1;
      let fv = fibTable[i];
      if (fv <= remaining and fv > 0) {
        idxList  := Array.append(idxList,  [i]);
        valList  := Array.append(valList,  [fv]);
        remaining -= fv;
        // Skip consecutive to enforce non-consecutive rule
        if (i > 0) { i -= 1 };
      }
    };
    var rep : Text = "";
    var j = 0;
    while (j < valList.size()) {
      if (j > 0) rep := rep # "+";
      rep := rep # "F(" # Nat.toText(idxList[j]) # ")=" # Nat.toText(valList[j]);
      j += 1;
    };
    { indices = idxList; fibValues = valList; representation = rep }
  };

  // ── Generation from accumulated count (Fibonacci threshold table) ────────
  // Threshold: 1→gen1, 2→gen2, 3→gen3, 5→gen4, 8→gen5, 13→gen6,
  //            21→gen7, 34→gen8, 55→gen9, 89→gen10
  public query func generationFromCount(count : Nat) : async Nat {
    // Fibonacci thresholds for generations 1-10
    let thresholds : [Nat] = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89];
    var gen : Nat = 0;
    var i   : Nat = 0;
    while (i < thresholds.size()) {
      if (count >= thresholds[i]) { gen := i + 1 };
      i += 1;
    };
    if (gen == 0 and count > 0) gen := 1;
    gen
  };

  // ── Next generation threshold ─────────────────────────────────────────────
  public query func nextGenerationThreshold(currentGen : Nat) : async Nat {
    let thresholds : [Nat] = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89];
    if (currentGen >= thresholds.size()) return 144; // next Fibonacci
    thresholds[currentGen]
  };

  // ── The 10 Fibonacci generation thresholds ────────────────────────────────
  public query func allGenerationThresholds() : async [(Nat, Nat)] {
    // (generation, count_threshold)
    [
      (1, 1), (2, 2), (3, 3), (4, 5), (5, 8),
      (6, 13), (7, 21), (8, 34), (9, 55), (10, 89)
    ]
  };

  // ── φ at generation g: scale factor = φᵍ ─────────────────────────────────
  public query func goldenGrowthFactor(generation : Nat) : async Float {
    _pow(PHI, Float.fromInt(generation))
  };

  // ── All 10 generation scale factors ──────────────────────────────────────
  public query func generationScaleTable() : async [(Nat, Float)] {
    Array.tabulate<(Nat, Float)>(11, func(i) {
      (i, _pow(PHI, Float.fromInt(i)))
    })
  };

  // ── Relevance decay: φ⁻¹ per generation ──────────────────────────────────
  public query func relevanceDecay(initialValue : Float, generations : Nat) : async Float {
    initialValue * _pow(PHI_INV, Float.fromInt(generations))
  };

  // ── Lucas numbers L(n) = φⁿ + ψⁿ ────────────────────────────────────────
  public query func lucas(n : Nat) : async Float {
    let nf    = Float.fromInt(n);
    let phi_n = _pow(PHI, nf);
    let psi_n = if (n mod 2 == 0) _pow(PHI_INV, nf) else -_pow(PHI_INV, nf);
    phi_n + psi_n
  };

  // ── Golden constants ──────────────────────────────────────────────────────
  public query func phi()            : async Float { PHI };
  public query func phiInverse()     : async Float { PHI_INV };
  public query func phiSquared()     : async Float { PHI_SQ };
  public query func goldenAngleDeg() : async Float { GOLDEN_ANGLE_DEG };
  public query func goldenAngleRad() : async Float { GOLDEN_ANGLE_RAD };
  public query func sqrt5()          : async Float { SQRT5 };

  // ── Verify φ² = φ + 1 (the defining property) ───────────────────────────
  public query func verifyPhiProperty() : async {
    phiSquared : Float;
    phiPlusOne : Float;
    error      : Float;
  } {
    {
      phiSquared = PHI * PHI;
      phiPlusOne = PHI + 1.0;
      error      = _abs(PHI * PHI - PHI - 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUB-MODEL: SPIRAL
  // Spatial distribution: phyllotaxis, Fibonacci sphere lattice,
  // golden partitioning, golden spiral.
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Phyllotaxis position of the nth organism ─────────────────────────────
  // angle = n × θ_golden,  radius = √n × scale
  // (exact spec formula from §5.3)
  public query func phyllotaxisPosition(n : Nat, scale : Float) : async {
    n     : Nat;
    angle : Float;   // radians
    angleDeg : Float;
    radius   : Float;
    x        : Float;
    y        : Float;
  } {
    let nf     = Float.fromInt(n);
    let angle  = _mod(nf * GOLDEN_ANGLE_RAD, TWO_PI);
    let radius = _sqrt(nf) * scale;
    {
      n        = n;
      angle    = angle;
      angleDeg = angle * 180.0 / PI;
      radius   = radius;
      x        = radius * _cos(angle);
      y        = radius * _sin(angle);
    }
  };

  // ── Phyllotaxis field: positions for organisms 0..count-1 ────────────────
  public query func phyllotaxisField(count : Nat, scale : Float) : async [{
    n        : Nat;
    angle    : Float;
    angleDeg : Float;
    radius   : Float;
    x        : Float;
    y        : Float;
  }] {
    Array.tabulate<{ n:Nat; angle:Float; angleDeg:Float; radius:Float; x:Float; y:Float }>(count, func(i) {
      let nf     = Float.fromInt(i);
      let angle  = _mod(nf * GOLDEN_ANGLE_RAD, TWO_PI);
      let radius = _sqrt(nf) * scale;
      {
        n        = i;
        angle    = angle;
        angleDeg = angle * 180.0 / PI;
        radius   = radius;
        x        = radius * _cos(angle);
        y        = radius * _sin(angle);
      }
    })
  };

  // ── Fibonacci sphere distribution ────────────────────────────────────────
  // θ_n = arccos(1 − 2n/N), φ_n = 2πn/φ mod 2π
  public query func fibSpherePoint(n : Nat, totalN : Nat) : async {
    n    : Nat;
    lat  : Float;   // polar angle (radians)
    lon  : Float;   // azimuthal angle (radians)
    x    : Float;
    y    : Float;
    z    : Float;
  } {
    if (totalN == 0) return { n=0; lat=0.0; lon=0.0; x=0.0; y=0.0; z=1.0 };
    let nf  = Float.fromInt(n);
    let Nf  = Float.fromInt(totalN);
    let lat = _arccos(1.0 - 2.0 * nf / Nf);
    let lon = _mod(TWO_PI * nf / PHI, TWO_PI);
    let sinLat = _sin(lat);
    {
      n   = n;
      lat = lat;
      lon = lon;
      x   = sinLat * _cos(lon);
      y   = sinLat * _sin(lon);
      z   = _cos(lat);
    }
  };

  // ── Fibonacci sphere distribution: N points ───────────────────────────────
  public query func fibSphereDistribution(totalN : Nat) : async [{
    n : Nat; lat : Float; lon : Float; x : Float; y : Float; z : Float;
  }] {
    Array.tabulate<{ n:Nat; lat:Float; lon:Float; x:Float; y:Float; z:Float }>(totalN, func(i) {
      let nf     = Float.fromInt(i);
      let Nf     = Float.fromInt(totalN);
      let lat    = if (totalN == 0) 0.0 else _arccos(1.0 - 2.0 * nf / Nf);
      let lon    = _mod(TWO_PI * nf / PHI, TWO_PI);
      let sinLat = _sin(lat);
      { n=i; lat; lon; x=sinLat * _cos(lon); y=sinLat * _sin(lon); z=_cos(lat) }
    })
  };

  // ── Golden spiral coordinate ─────────────────────────────────────────────
  // Logarithmic spiral: r = a × e^(b × θ), b = ln(φ) / (π/2)
  public query func goldenSpiralPoint(theta : Float, a : Float) : async {
    theta : Float;
    r     : Float;
    x     : Float;
    y     : Float;
  } {
    let b = Float.log(PHI) / (PI / 2.0);
    let r = a * Float.exp(b * theta);
    { theta; r; x = r * _cos(theta); y = r * _sin(theta) }
  };

  // ── Golden partition: split total in ratio φ:1 ────────────────────────────
  // major = total × φ/(φ+1) = total × φ/φ² = total / φ
  // minor = total × 1/(φ+1) = total × 1/φ²
  public query func goldenPartition(total : Float) : async {
    total : Float;
    major : Float;
    minor : Float;
    ratio : Float;
  } {
    let major = total * PHI_INV;  // total × (1/φ) = total × φ/(φ+1)
    let minor = total - major;
    {
      total = total;
      major = major;
      minor = minor;
      ratio = if (minor < EPSILON) PHI else major / minor;
    }
  };

  // ── Recursive golden partitioning: split n levels deep ───────────────────
  public query func goldenPartitionLevels(total : Float, levels : Nat) : async [Float] {
    var segments : [Float] = [total];
    var lvl : Nat = 0;
    while (lvl < levels and segments.size() < 512) {
      var next : [Float] = [];
      var i = 0;
      while (i < segments.size()) {
        let s = segments[i];
        next := Array.append(next, [s * PHI_INV, s - s * PHI_INV]);
        i += 1;
      };
      segments := next;
      lvl += 1;
    };
    segments
  };

  // ── Golden angle: n × 137.508° ───────────────────────────────────────────
  public query func goldenAngleMultiple(n : Nat) : async { deg : Float; rad : Float } {
    let deg = Float.fromInt(n) * GOLDEN_ANGLE_DEG;
    let rad = Float.fromInt(n) * GOLDEN_ANGLE_RAD;
    { deg = _mod(deg, 360.0); rad = _mod(rad, TWO_PI) }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — CHRYSALIS STATUS QUERY
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getChrysalisStatus() : async {
    seal         : Text;
    buildNumber  : Nat;
    claimed      : Bool;
    timestamp    : Int;
    phi          : Float;
    goldenAngle  : Float;
    subModels    : [Text];
  } {
    {
      seal        = sovereignSeal;
      buildNumber = buildNumber;
      claimed     = genesisLocked;
      timestamp   = genesisTimestamp;
      phi         = PHI;
      goldenAngle = GOLDEN_ANGLE_DEG;
      subModels   = ["FIBONACCI", "SPIRAL"];
    }
  };

};
