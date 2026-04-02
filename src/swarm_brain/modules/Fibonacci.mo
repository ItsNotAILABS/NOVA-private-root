// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: Fibonacci — The Sacred Mathematics Core Library
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    FIBONACCI — THE MATH OF CREATION                      ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This is the CORE math library used by EVERYTHING in the organism.       ║
// ║                                                                          ║
// ║  WHY FIBONACCI?                                                          ║
// ║    - Structurally optimal load distribution (Parthenon, cathedrals)     ║
// ║    - Minimal energy expenditure (sunflower seeds, nautilus)             ║
// ║    - Maximum packing efficiency (pine cones, pineapples)                ║
// ║    - Natural growth patterns (trees, rivers, galaxies)                  ║
// ║                                                                          ║
// ║  φ = 1.618... is not arbitrary. It's the limit of F[n+1]/F[n].          ║
// ║  It appears because it's the ONLY irrational number that cannot be      ║
// ║  approximated by rationals — it's maximally irrational.                 ║
// ║  This makes it optimal for distributing things without clumping.        ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Array "mo:base/Array";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     THE GOLDEN RATIO — φ                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Golden ratio: (1 + √5) / 2
  public let φ : Float = 1.6180339887498948482;
  
  /// Golden ratio inverse: 1/φ = φ - 1 (remarkable identity!)
  public let φ_INV : Float = 0.6180339887498948482;
  
  /// Golden ratio squared: φ² = φ + 1
  public let φ_SQ : Float = 2.6180339887498948482;
  
  /// Golden ratio cubed: φ³ = 2φ + 1
  public let φ_CUBE : Float = 4.2360679774997896964;
  
  /// Golden ratio to the -2: φ⁻² = 1 - φ⁻¹
  public let φ_INV_SQ : Float = 0.3819660112501051518;
  
  /// √5 — appears in Binet's formula
  public let SQRT_5 : Float = 2.2360679774997896964;
  
  /// √φ — appears in golden spiral
  public let SQRT_φ : Float = 1.2720196495140689643;
  
  /// Golden angle in radians: 2π × φ⁻² ≈ 2.4 rad ≈ 137.5°
  public let GOLDEN_ANGLE : Float = 2.3999632297286533;
  
  /// Golden angle in degrees
  public let GOLDEN_ANGLE_DEG : Float = 137.5077640500378;
  
  /// Other sacred constants
  public let π : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;
  public let e : Float = 2.7182818284590452354;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FIBONACCI SEQUENCE — F[0..30]                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Fibonacci sequence up to F[30] = 832,040
  public let F : [Nat] = [
    0, 1, 1, 2, 3, 5, 8, 13, 21, 34,                    // F[0]-F[9]
    55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,  // F[10]-F[19]
    6765, 10946, 17711, 28657, 46368, 75025, 121393,    // F[20]-F[26]
    196418, 317811, 514229, 832040                      // F[27]-F[30]
  ];
  
  /// Fibonacci as floats for calculations
  public let F_FLOAT : [Float] = [
    0.0, 1.0, 1.0, 2.0, 3.0, 5.0, 8.0, 13.0, 21.0, 34.0,
    55.0, 89.0, 144.0, 233.0, 377.0, 610.0, 987.0, 1597.0, 2584.0, 4181.0,
    6765.0, 10946.0, 17711.0, 28657.0, 46368.0, 75025.0, 121393.0,
    196418.0, 317811.0, 514229.0, 832040.0
  ];
  
  /// Lucas sequence (related to Fibonacci: L[n] = F[n-1] + F[n+1])
  public let L : [Nat] = [
    2, 1, 3, 4, 7, 11, 18, 29, 47, 76,
    123, 199, 322, 521, 843, 1364, 2207, 3571, 5778, 9349
  ];

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FIBONACCI FUNCTIONS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Get Fibonacci number (returns F[30] if n > 30)
  public func fib(n: Nat) : Nat {
    if (n < F.size()) { F[n] } else { F[F.size() - 1] }
  };
  
  /// Get Fibonacci as float
  public func fibF(n: Nat) : Float {
    if (n < F_FLOAT.size()) { F_FLOAT[n] } else { F_FLOAT[F_FLOAT.size() - 1] }
  };
  
  /// Binet's formula: F[n] = (φⁿ - ψⁿ) / √5 where ψ = -1/φ
  /// Accurate for large n (floating point)
  public func binetApprox(n: Nat) : Float {
    let nf = Float.fromInt(n);
    let psi = -φ_INV;  // ψ = -1/φ ≈ -0.618
    (Float.pow(φ, nf) - Float.pow(psi, nf)) / SQRT_5
  };
  
  /// Check if a number is Fibonacci
  public func isFibonacci(n: Nat) : Bool {
    for (f in F.vals()) {
      if (f == n) { return true };
      if (f > n) { return false };
    };
    false
  };
  
  /// Find closest Fibonacci number
  public func closestFib(n: Nat) : Nat {
    var closest = F[0];
    var minDist = n;
    
    for (f in F.vals()) {
      let dist = if (f > n) { f - n } else { n - f };
      if (dist < minDist) {
        minDist := dist;
        closest := f;
      };
    };
    closest
  };
  
  /// Find Fibonacci index (returns 0 if not found)
  public func fibIndex(n: Nat) : Nat {
    var i = 0;
    while (i < F.size()) {
      if (F[i] == n) { return i };
      i += 1;
    };
    0
  };
  
  /// Fibonacci floor: largest F[n] ≤ x
  public func fibFloor(x: Nat) : Nat {
    var result = F[0];
    for (f in F.vals()) {
      if (f <= x) { result := f }
      else { return result };
    };
    result
  };
  
  /// Fibonacci ceiling: smallest F[n] ≥ x
  public func fibCeil(x: Nat) : Nat {
    for (f in F.vals()) {
      if (f >= x) { return f };
    };
    F[F.size() - 1]
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     GOLDEN RECTANGLE & SPIRAL                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Golden rectangle dimensions from width
  public func goldenRect(width: Float) : (Float, Float) {
    (width, width * φ)
  };
  
  /// Golden rectangle from height
  public func goldenRectFromHeight(height: Float) : (Float, Float) {
    (height * φ_INV, height)
  };
  
  /// Golden spiral position: r = a × φ^(θ/90°)
  /// Returns (x, y) for given angle θ (in radians) and scale a
  public func goldenSpiralPos(theta: Float, scale: Float) : (Float, Float) {
    // r = scale × φ^(θ × 2/π) = scale × φ^(θ/90° in radians)
    let r = scale * Float.pow(φ, theta * 2.0 / π);
    let x = r * Float.cos(theta);
    let y = r * Float.sin(theta);
    (x, y)
  };
  
  /// Fibonacci spiral position (discrete version)
  /// Shell = which ring, index = position within ring
  /// Returns (x, y) position
  public func spiralPos(shell: Nat, index: Nat) : (Float, Float) {
    let shellF = Float.fromInt(shell);
    let indexF = Float.fromInt(index);
    
    // Angle: index × golden angle
    let theta = indexF * GOLDEN_ANGLE;
    
    // Radius: F[shell] scaled
    let radius = fibF(shell + 3) * 0.5;
    
    let x = radius * Float.cos(theta);
    let y = radius * Float.sin(theta);
    (x, y)
  };
  
  /// Phyllotactic position (sunflower seed arrangement)
  /// n = element index, returns (x, y)
  public func phyllotacticPos(n: Nat, scale: Float) : (Float, Float) {
    let nf = Float.fromInt(n);
    let angle = nf * GOLDEN_ANGLE;
    let radius = scale * Float.sqrt(nf);
    
    let x = radius * Float.cos(angle);
    let y = radius * Float.sin(angle);
    (x, y)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BUILDING TIERS — FIBONACCI HP                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Building tier sizes and HP follow Fibonacci:
  //   Tier 1:  F[1]  =   1 cell   →  F[6]  =  8 HP
  //   Tier 2:  F[2]  =   1 cell   →  F[7]  = 13 HP
  //   Tier 3:  F[3]  =   2 cells  →  F[8]  = 21 HP
  //   Tier 4:  F[4]  =   3 cells  →  F[9]  = 34 HP
  //   Tier 5:  F[5]  =   5 cells  →  F[10] = 55 HP
  //   Tier 6:  F[6]  =   8 cells  →  F[11] = 89 HP  (fortress)
  //   Tier 7:  F[7]  = 13 cells   →  F[12] = 144 HP (citadel)
  //
  
  /// Get building size (cells) for tier
  public func tierSize(tier: Nat) : Nat {
    if (tier == 0) { 1 } else { fib(tier) }
  };
  
  /// Get building HP for tier
  public func tierHP(tier: Nat) : Nat {
    fib(tier + 5)  // Tier 1 → F[6] = 8 HP
  };
  
  /// Get cascade threshold HP for tier (when cascade failure starts)
  public func cascadeThreshold(tier: Nat) : Nat {
    if (tier < 2) { 1 } else { fib(tier + 3) }  // F[tier-2+5] = F[tier+3]
  };
  
  /// Cascade damage amount (damage to adjacent nodes)
  public func cascadeDamage(tier: Nat) : Nat {
    if (tier < 3) { 1 } else { fib(tier + 2) }  // F[tier-3+5] = F[tier+2]
  };
  
  /// Check if cascade should fire
  public func cascadeCheck(nodeHP: Nat, tier: Nat) : Bool {
    nodeHP < cascadeThreshold(tier)
  };
  
  /// Cascade probability calculation
  public func cascadeProbability(nodeHP: Nat, tier: Nat) : Float {
    let tierHPFloat = Float.fromInt(tierHP(tier));
    let nodeHPFloat = Float.fromInt(nodeHP);
    
    // cascade_probability = (φ - nodeHP/F[tier]) × 0.618
    let ratio = nodeHPFloat / tierHPFloat;
    let prob = (φ - ratio) * φ_INV;
    
    _clamp(prob, 0.0, 1.0)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TERRITORY RINGS — FIBONACCI EXPANSION              ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Territory expands in Fibonacci rings:
  //   Ring 0 (core):   1 biome   — F[2]
  //   Ring 1:          1 biome   — F[2]
  //   Ring 2:          2 biomes  — F[3]
  //   Ring 3:          3 biomes  — F[4]
  //   Ring 4:          5 biomes  — F[5]
  //   Ring 5:          8 biomes  — F[6]
  //   ...
  //   Ring N:          F[N+1] biomes
  //
  // Total biomes at ring N = F[1]+F[2]+...+F[N+1] = F[N+3] - 1
  //
  
  /// Biomes in a specific ring
  public func ringBiomes(ring: Nat) : Nat {
    fib(ring + 2)  // Ring 0 → F[2] = 1
  };
  
  /// Total biomes controlled at ring N
  public func totalBiomesAtRing(ring: Nat) : Nat {
    // Sum of F[2] to F[ring+2] = F[ring+4] - 1
    if (ring + 4 < F.size()) {
      F[ring + 4] - 1
    } else {
      // Approximate for large rings
      var sum : Nat = 0;
      var i : Nat = 2;
      while (i <= ring + 2 and i < F.size()) {
        sum += F[i];
        i += 1;
      };
      sum
    }
  };
  
  /// Find ring number given total biome count
  public func ringFromBiomes(totalBiomes: Nat) : Nat {
    var ring : Nat = 0;
    while (totalBiomesAtRing(ring) < totalBiomes and ring < 20) {
      ring += 1;
    };
    ring
  };
  
  /// Check if expansion to next ring is possible
  public func canExpandRing(currentRing: Nat, availableBiomes: Nat) : Bool {
    availableBiomes >= ringBiomes(currentRing + 1)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DAMAGE PROPAGATION — FIBONACCI PHYSICS             ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Damage propagates via inverse square law weighted by φ:
  //   damage_at_node_i = impact_force × φ^(-distance)
  //
  // This creates realistic structural failure patterns.
  //
  
  /// Calculate damage at distance from impact point
  public func damageAtDistance(impactForce: Float, distance: Float) : Float {
    if (distance < 0.001) {
      impactForce  // Direct hit
    } else {
      impactForce * Float.pow(φ_INV, distance)
    }
  };
  
  /// Calculate total damage to a node given impact
  public func nodeDamage(
    impactForce: Float,
    impactX: Float, impactZ: Float,
    nodeX: Float, nodeZ: Float
  ) : Float {
    let dx = nodeX - impactX;
    let dz = nodeZ - impactZ;
    let distance = Float.sqrt(dx * dx + dz * dz);
    
    damageAtDistance(impactForce, distance)
  };
  
  /// Collapse direction: buildings fall TOWARD most damaged side
  /// Returns angle in radians
  public func collapseDirection(
    nodeDamages: [(Float, Float, Float)]  // (x, z, damage)
  ) : Float {
    // Weighted average of damage positions
    var weightedX : Float = 0.0;
    var weightedZ : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for ((x, z, damage) in nodeDamages.vals()) {
      weightedX += x * damage;
      weightedZ += z * damage;
      totalWeight += damage;
    };
    
    if (totalWeight > 0.001) {
      let avgX = weightedX / totalWeight;
      let avgZ = weightedZ / totalWeight;
      Float.arctan2(avgZ, avgX)
    } else {
      0.0  // No clear direction
    }
  };
  
  /// Collapse arc follows logarithmic spiral: r = φ^(θ/π)
  public func collapseArcPosition(theta: Float, startRadius: Float) : Float {
    startRadius * Float.pow(φ, theta / π)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     GOLDEN RATIO PROPORTIONS                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Real architecture uses φ for:
  //   - Column spacing: primary at φ×base, secondary at φ⁻¹×base
  //   - Floor heights: decrease by φ⁻¹ each floor up
  //   - Window ratios: width:height = 1:φ
  //   - Facade: height:width = φ:1
  //
  
  /// Column spacing levels
  public func columnSpacing(baseUnit: Float, level: Nat) : Float {
    // Primary: φ × base
    // Secondary: φ⁻¹ × base
    // Tertiary: φ⁻² × base
    baseUnit * Float.pow(φ_INV, Float.fromInt(level))
  };
  
  /// Floor height (decreases as you go up)
  public func floorHeight(baseHeight: Float, floor: Nat) : Float {
    // Ground: F[5] = 5 units
    // Floor 2: F[4] = 3 units
    // etc.
    if (floor == 0) { baseHeight }
    else { baseHeight * Float.pow(φ_INV, Float.fromInt(floor)) }
  };
  
  /// Window dimensions (golden rectangle)
  public func windowDimensions(width: Float) : (Float, Float) {
    (width, width * φ)  // width : height = 1 : φ
  };
  
  /// Facade proportions
  public func facadeProportions(totalWidth: Float) : (Float, Float, Float) {
    let totalHeight = totalWidth * φ;
    let upperSection = totalHeight * φ_INV;
    let lowerSection = totalHeight - upperSection;
    (totalWidth, upperSection, lowerSection)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };
  
  /// Golden power: φⁿ
  public func phiPow(n: Float) : Float {
    Float.pow(φ, n)
  };
  
  /// Inverse golden power: φ⁻ⁿ
  public func phiInvPow(n: Float) : Float {
    Float.pow(φ_INV, n)
  };
  
  /// Check if ratio is approximately golden
  public func isGoldenRatio(ratio: Float, tolerance: Float) : Bool {
    Float.abs(ratio - φ) < tolerance or Float.abs(ratio - φ_INV) < tolerance
  };
  
  /// Normalize to golden proportion
  public func goldenNormalize(value: Float, min: Float, max: Float) : Float {
    let range = max - min;
    if (range < 0.001) { return 0.5 };
    
    let normalized = (value - min) / range;
    // Apply golden sigmoid
    let goldenSig = 1.0 / (1.0 + Float.pow(φ, -10.0 * (normalized - 0.5)));
    goldenSig
  };

}
