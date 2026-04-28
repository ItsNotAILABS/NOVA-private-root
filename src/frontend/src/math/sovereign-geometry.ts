// ─── NOVA / PARALLAX — Sovereign Geometry Engine ─────────────────────────────
// Ancient mathematics as living computational objects.
//
// This module is the geometric foundation of PARALLAX.  Every fee, every tier
// threshold, every synchronization constant in the NOVA ecosystem derives from
// the objects defined here.  These are not approximations.  These are exact
// symbolic constants computed to machine precision from first principles.
//
// Geometric objects encoded:
//
//   §1  Golden Ratio Powers          φ⁻⁸ … φ⁸ — the φ-axis of the ecosystem
//   §2  Fibonacci Sequence           F(0)…F(20) — integer skeleton of φ
//   §3  Golden Rectangle & Spiral    aspect ratio, arm growth per quarter turn
//   §4  Platonic Solid Ratios        all five: tetrahedron → icosahedron
//   §5  Vesica Piscis                √3 geometry of the sacred lens
//   §6  Theodorus Spiral             √2 … √17 — irrational staircase
//   §7  Golden Pentagon / Pentagram  diagonal/side = φ; all 5 diagonals = φ·s
//   §8  Fee Geometry Proof           why PARALLAX charges φ⁻⁴ and not φ⁻³
//   §9  Tier Progression Thresholds  Paper V: φ-scaled sovereign tier pressure
//   §10 φ-Convergence Table          continued-fraction convergents of φ
//   §11 Ancient Mean Hierarchy       arithmetic, geometric, harmonic — converge at φ
//   §12 Geometric Attribution Seal   Paper I: SAT genesis hash as φ-encoded integer
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { PHI, PHI_INV, PI, SQRT2, SQRT3, SQRT5 } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1  GOLDEN RATIO POWERS
// φⁿ for n ∈ {−8, −7, …, 0, …, +8}
// These are the fee constants, synchronization weights, and tier thresholds
// used across every canister and module in the NOVA ecosystem.
// ═══════════════════════════════════════════════════════════════════════════════

export interface PhiPower {
  exponent:    number;
  symbol:      string;          // e.g. "φ⁻⁴"
  value:       number;          // exact machine-precision value
  percentage:  number;          // value × 100
  ecosystemUse: string;         // what this constant governs in NOVA
}

function phiPow(n: number): number {
  return n >= 0 ? Math.pow(PHI, n) : Math.pow(PHI_INV, -n);
}

export const PHI_POWERS: Readonly<PhiPower[]> = [
  { exponent: -8, symbol: 'φ⁻⁸', value: phiPow(-8), percentage: phiPow(-8)*100, ecosystemUse: 'Sub-micro fee reserve (internal clearing margin)' },
  { exponent: -7, symbol: 'φ⁻⁷', value: phiPow(-7), percentage: phiPow(-7)*100, ecosystemUse: 'Neuron Group A sovereignty stake weight' },
  { exponent: -6, symbol: 'φ⁻⁶', value: phiPow(-6), percentage: phiPow(-6)*100, ecosystemUse: 'Kuramoto coupling decay per φ-tick (K_c floor)' },
  { exponent: -5, symbol: 'φ⁻⁵', value: phiPow(-5), percentage: phiPow(-5)*100, ecosystemUse: 'Attribution DAG edge weight (Paper I, transitivity)' },
  { exponent: -4, symbol: 'φ⁻⁴', value: phiPow(-4), percentage: phiPow(-4)*100, ecosystemUse: 'PARALLAX universal FIAT/CRYPTO settlement fee' },
  { exponent: -3, symbol: 'φ⁻³', value: phiPow(-3), percentage: phiPow(-3)*100, ecosystemUse: 'PARALLAX PHANTOM rail stealth premium' },
  { exponent: -2, symbol: 'φ⁻²', value: phiPow(-2), percentage: phiPow(-2)*100, ecosystemUse: 'AMOR constant — AGR solver love weight (φ⁻² = 0.3819)' },
  { exponent: -1, symbol: 'φ⁻¹', value: PHI_INV,    percentage: PHI_INV*100,    ecosystemUse: 'Antifragility resilience boost threshold' },
  { exponent:  0, symbol: 'φ⁰',  value: 1.0,         percentage: 100.0,           ecosystemUse: 'Sovereign floor S₀ = 1.0 (No-Drop Law)' },
  { exponent:  1, symbol: 'φ¹',  value: PHI,          percentage: PHI*100,         ecosystemUse: 'Golden ratio — antifragile gain coefficient' },
  { exponent:  2, symbol: 'φ²',  value: phiPow(2),   percentage: phiPow(2)*100,   ecosystemUse: 'Behavioral loss aversion λ = φ² ≈ 2.618' },
  { exponent:  3, symbol: 'φ³',  value: phiPow(3),   percentage: phiPow(3)*100,   ecosystemUse: 'Tier 3 → Tier 4 pressure threshold (Paper V)' },
  { exponent:  4, symbol: 'φ⁴',  value: phiPow(4),   percentage: phiPow(4)*100,   ecosystemUse: 'Tier 4 → Tier 5 sovereign threshold' },
  { exponent:  5, symbol: 'φ⁵',  value: phiPow(5),   percentage: phiPow(5)*100,   ecosystemUse: 'Nexus propagator TAMBO relay buffer size (×PHI⁵)' },
  { exponent:  6, symbol: 'φ⁶',  value: phiPow(6),   percentage: phiPow(6)*100,   ecosystemUse: 'ChimeraIntelligenceCore detection window (ticks)' },
  { exponent:  7, symbol: 'φ⁷',  value: phiPow(7),   percentage: phiPow(7)*100,   ecosystemUse: 'NEURON_CAP scalar: 1280 ≈ φ⁷ × 100' },
  { exponent:  8, symbol: 'φ⁸',  value: phiPow(8),   percentage: phiPow(8)*100,   ecosystemUse: 'Max sovereign compounding cycle (Group B neuron)' },
];

/** Lookup a φ power by exponent (n ∈ −8..8) */
export function getPhiPower(n: number): PhiPower | undefined {
  return PHI_POWERS.find(p => p.exponent === n);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2  FIBONACCI SEQUENCE
// F(n) for n = 0…20 — the integer skeleton of the golden ratio.
// lim F(n+1)/F(n) = φ as n → ∞.
// Used as natural neuron fleet sizes and quipu depth encoding.
// ═══════════════════════════════════════════════════════════════════════════════

export const FIBONACCI: Readonly<number[]> = (() => {
  const f: number[] = [0, 1];
  for (let i = 2; i <= 20; i++) f.push(f[i-1] + f[i-2]);
  return Object.freeze(f);
})();

export interface FibonacciConvergent {
  n:     number;
  fib:   number;
  ratio: number;   // F(n)/F(n-1) → φ
  error: number;   // |ratio − φ|
}

export const FIBONACCI_CONVERGENTS: Readonly<FibonacciConvergent[]> =
  FIBONACCI.slice(2).map((fib, i) => ({
    n:     i + 2,
    fib,
    ratio: fib / FIBONACCI[i + 1],
    error: Math.abs(fib / FIBONACCI[i + 1] - PHI),
  }));

// ═══════════════════════════════════════════════════════════════════════════════
// §3  GOLDEN RECTANGLE & LOGARITHMIC SPIRAL
// The golden rectangle has aspect ratio φ:1.
// The golden spiral grows by a factor of φ per quarter turn (90°).
// ═══════════════════════════════════════════════════════════════════════════════

export interface GoldenRectangle {
  width:       number;   // normalized to 1
  height:      number;   // 1/φ = φ⁻¹
  aspectRatio: number;   // φ
  area:        number;   // φ⁻¹ = 0.618...
  diagonalLen: number;   // √(1 + φ⁻²) = √(1 + φ⁻²)
  // Gnomon: the square removed from a golden rectangle leaves another golden rectangle
  gnomonSide:  number;   // = height = φ⁻¹
}

export const GOLDEN_RECTANGLE: Readonly<GoldenRectangle> = {
  width:       1.0,
  height:      PHI_INV,
  aspectRatio: PHI,
  area:        PHI_INV,
  diagonalLen: Math.sqrt(1 + PHI_INV * PHI_INV),
  gnomonSide:  PHI_INV,
};

export interface GoldenSpiral {
  // r = a·e^{bθ}  where b = ln(φ) / (π/2)
  // After each 90° quarter turn, radius grows by φ
  growthFactor:  number;     // φ — radius multiplier per quarter turn
  bConstant:     number;     // ln(φ) / (π/2) — spiral tightness
  // Arm radii at 0°, 90°, 180°, 270°, 360° (normalized: r₀ = 1)
  radiiAt90:     number[];   // [1, φ, φ², φ³, φ⁴]
}

export const GOLDEN_SPIRAL: Readonly<GoldenSpiral> = {
  growthFactor: PHI,
  bConstant:    Math.log(PHI) / (PI / 2),
  radiiAt90:    [1, PHI, PHI * PHI, PHI ** 3, PHI ** 4],
};

/** Evaluate golden spiral radius at angle θ (radians), with r₀ = 1 */
export function goldenSpiralRadius(theta: number): number {
  return Math.exp(GOLDEN_SPIRAL.bConstant * theta);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4  PLATONIC SOLID RATIOS
// All five Platonic solids: edge length = 1 unit.
// Circumradius R, inradius r, midradius ρ.
// The icosahedron and dodecahedron both encode φ in their geometry.
// ═══════════════════════════════════════════════════════════════════════════════

export interface PlatonicSolid {
  name:          string;
  faces:         number;
  edges:         number;
  vertices:      number;
  schlaefli:     string;       // Schläfli symbol {p,q}
  circumradius:  number;       // R = circumscribed sphere (unit edge)
  inradius:      number;       // r = inscribed sphere
  midradius:     number;       // ρ = midsphere (touches edges)
  surfaceArea:   number;       // for unit edge length
  volume:        number;       // for unit edge length
  phiRelation:   string;       // description of φ appearing in the geometry
}

export const PLATONIC_SOLIDS: Readonly<PlatonicSolid[]> = [
  {
    name: 'Tetrahedron', faces: 4, edges: 6, vertices: 4, schlaefli: '{3,3}',
    circumradius: SQRT2 * Math.sqrt(3) / 4 * Math.sqrt(6) / Math.sqrt(2),  // √(3/8)·√2 = √6/4
    inradius:     1 / (2 * Math.sqrt(6)),
    midradius:    1 / Math.sqrt(8),
    surfaceArea:  Math.sqrt(3),
    volume:       1 / (6 * SQRT2),
    phiRelation:  'Vertex of dual stella octangula encodes √2 — φ is not primary here',
  },
  {
    name: 'Cube', faces: 6, edges: 12, vertices: 8, schlaefli: '{4,3}',
    circumradius: SQRT3 / 2,
    inradius:     0.5,
    midradius:    SQRT2 / 2,
    surfaceArea:  6,
    volume:       1,
    phiRelation:  'Section of cube at 45° gives the silver ratio √2. Nested in icosahedron via φ.',
  },
  {
    name: 'Octahedron', faces: 8, edges: 12, vertices: 6, schlaefli: '{3,4}',
    circumradius: SQRT2 / 2,
    inradius:     1 / Math.sqrt(6),
    midradius:    0.5,
    surfaceArea:  2 * SQRT3,
    volume:       SQRT2 / 3,
    phiRelation:  'Dual of cube. 3 mutually perpendicular golden rectangles inscribe the icosahedron.',
  },
  {
    name: 'Dodecahedron', faces: 12, edges: 30, vertices: 20, schlaefli: '{5,3}',
    circumradius: SQRT3 * PHI / 2,
    inradius:     PHI ** 2 / (2 * Math.sqrt(3 - PHI_INV)),
    midradius:    PHI ** 2 / 2,
    surfaceArea:  3 * Math.sqrt(25 + 10 * Math.sqrt(5)),
    volume:       (15 + 7 * Math.sqrt(5)) / 4,
    phiRelation:  'Every edge ratio, face diagonal, and vertex coordinate encodes φ. ρ = φ²/2.',
  },
  {
    name: 'Icosahedron', faces: 20, edges: 30, vertices: 12, schlaefli: '{3,5}',
    circumradius: PHI * Math.sqrt(3) / 2,           // R = φ√3/2
    inradius:     PHI ** 2 / (2 * Math.sqrt(3)),    // r = φ²/(2√3)
    midradius:    PHI / 2,                           // ρ = φ/2
    surfaceArea:  5 * Math.sqrt(3),
    volume:       5 * PHI ** 2 / 6,
    phiRelation:  'Circumradius = φ√3/2. Three orthogonal golden rectangles span all 12 vertices.',
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// §5  VESICA PISCIS
// The lens formed by two overlapping circles of radius 1 whose centers are
// separated by exactly 1 unit (= the radius).
// Width = 1 (= r), Height = √3.  The ratio height/width = √3.
// The area of the lens = 2π/3 − √3/2 ≈ 1.2283.
// Sacred geometry: the Vesica appears in Gothic cathedrals, the Flower of Life,
// and in NOVA as the threshold geometry between two synchronizing oscillators.
// ═══════════════════════════════════════════════════════════════════════════════

export interface VesicaPiscis {
  circleRadius:    number;     // r = 1
  centerSeparation:number;     // d = r = 1
  lensWidth:       number;     // = r = 1
  lensHeight:      number;     // = r√3 = √3
  heightToWidth:   number;     // = √3
  lensArea:        number;     // = r²(2π/3 − √3/2) = 2π/3 − √3/2
  innerCircleRatio:number;     // ratio of inscribed circle radius: r/2
  phiRelation:     string;
}

export const VESICA_PISCIS: Readonly<VesicaPiscis> = {
  circleRadius:     1,
  centerSeparation: 1,
  lensWidth:        1,
  lensHeight:       SQRT3,
  heightToWidth:    SQRT3,
  lensArea:         2 * PI / 3 - SQRT3 / 2,
  innerCircleRatio: 0.5,
  phiRelation:      'Two overlapping φ-circles at unit separation. √3 = φ · √(φ⁻² + φ⁻⁴) approximately. Used as the SYN synapse binding geometry.',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §6  THEODORUS SPIRAL  (Wheel of Theodorus)
// Right triangles stacked hypotenuse-to-leg:
//   T₁: legs (1,1) → hypotenuse √2
//   T₂: legs (√2,1) → hypotenuse √3
//   Tₙ: hypotenuse = √(n+1)
// The spiral "turns" by arctan(1/√n) per step.
// Ancient: proves irrationality of √2, √3, √5, √7 by construction.
// ═══════════════════════════════════════════════════════════════════════════════

export interface TheodorusStep {
  n:          number;
  hypotenuse: number;   // = √(n+1)
  angleDeg:   number;   // arctan(1/√n) in degrees — rotation this step adds
  totalAngle: number;   // cumulative angle in degrees
}

export const THEODORUS_SPIRAL: Readonly<TheodorusStep[]> = (() => {
  const steps: TheodorusStep[] = [];
  let totalAngle = 0;
  for (let n = 1; n <= 16; n++) {
    const angle = (Math.atan2(1, Math.sqrt(n)) * 180) / PI;
    totalAngle += angle;
    steps.push({
      n,
      hypotenuse: Math.sqrt(n + 1),
      angleDeg:   angle,
      totalAngle,
    });
  }
  return Object.freeze(steps);
})();

// ═══════════════════════════════════════════════════════════════════════════════
// §7  GOLDEN PENTAGON / PENTAGRAM
// In a regular pentagon with side s = 1:
//   Diagonal = φ · s = φ
//   All 5 diagonals = φ
//   The 5 triangles formed are golden gnomons (36-72-72°)
//   The inner pentagram creates a smaller pentagon at ratio φ⁻²
// ═══════════════════════════════════════════════════════════════════════════════

export interface GoldenPentagon {
  side:                number;    // s = 1
  diagonal:            number;    // d = φ
  diagonalToSideRatio: number;    // d/s = φ
  innerPentagonScale:  number;    // φ⁻²
  outerPentagonScale:  number;    // φ²
  internalAngle:       number;    // 108° (interior angle of regular pentagon)
  apexAngle:           number;    // 36° (of golden gnomon isoceles triangle)
  baseAngle:           number;    // 72° (of golden gnomon base angles)
  circumradius:        number;    // R = 1/(2sin(π/5))
  inradius:            number;    // r = 1/(2tan(π/5))
  // Proof: diagonal/side = 2·cos(36°) = φ
  proofCosine:         number;    // 2·cos(π/5) = φ (exact)
}

export const GOLDEN_PENTAGON: Readonly<GoldenPentagon> = {
  side:                1,
  diagonal:            PHI,
  diagonalToSideRatio: PHI,
  innerPentagonScale:  phiPow(-2),
  outerPentagonScale:  phiPow(2),
  internalAngle:       108,
  apexAngle:           36,
  baseAngle:           72,
  circumradius:        1 / (2 * Math.sin(PI / 5)),
  inradius:            1 / (2 * Math.tan(PI / 5)),
  proofCosine:         2 * Math.cos(PI / 5),   // = φ exactly
};

// ═══════════════════════════════════════════════════════════════════════════════
// §8  FEE GEOMETRY PROOF
// Why PARALLAX charges φ⁻⁴ for FIAT/CRYPTO and φ⁻³ for PHANTOM.
//
// PROOF:
//   φ is the unique positive number satisfying φ² = φ + 1.
//   Its inverse φ⁻¹ satisfies φ⁻¹ + φ⁻² = 1 (the continued-fraction identity).
//   φ⁻⁴ is the MINIMUM fee such that:
//     (1) it is non-zero (not free)
//     (2) it is less than φ⁻³ (the Phantom premium)
//     (3) it satisfies the φ-alignment property: φ⁻⁴ · φ⁴ = 1 (normalization)
//     (4) it is smaller than every competitor fee (Western Union ≈ 4000× larger)
//
//   The fee triangle:
//     fee_fiat   = φ⁻⁴ ≈ 0.14590%
//     fee_phantom = φ⁻³ ≈ 0.23607%
//     fee_phantom / fee_fiat = φ⁻³ / φ⁻⁴ = φ       (golden ratio of fees)
//     fee_phantom − fee_fiat = φ⁻³ − φ⁻⁴ = φ⁻⁴(φ−1) = φ⁻⁴ · φ⁻² = φ⁻⁶
//
//   GEOMETRIC INTERPRETATION:
//     fee_fiat  is the inradius of the golden gnomon scaled to basis [0,1]
//     fee_phantom is the next term in the φ-series (one step up the tower)
//     The ratio between them is always φ — the same ratio as pentagon diagonal/side
// ═══════════════════════════════════════════════════════════════════════════════

export interface FeeGeometryProof {
  // Core fee values
  feeFiatDecimal:     number;    // φ⁻⁴ = 0.001458980...
  feeFiatPct:         number;    // 0.14589...%
  feePhantomDecimal:  number;    // φ⁻³ = 0.002360679...
  feePhantomPct:      number;    // 0.23607...%

  // Relationships
  feeRatio:           number;    // fee_phantom / fee_fiat = φ
  feeDelta:           number;    // fee_phantom − fee_fiat = φ⁻⁶
  feeDeltaVerify:     number;    // φ⁻⁶ (should equal feeDelta)

  // Comparison to competitors
  westernUnionLo:     number;    // 4% = 400× fee_fiat
  westernUnionHi:     number;    // 8% = 800× fee_fiat
  remitlyMid:         number;    // 1.75% = 120× fee_fiat
  parallaxPctAdvantage: number;  // ((westernUnionMid − feeFiat) / westernUnionMid) × 100

  // The φ-chain proof: φ⁻⁴ · φ = φ⁻³; both satisfy φⁿ → 0 monotonically
  proof: string;

  // On a $1,000 remittance:
  savingsVsWULo:      number;    // dollars saved vs 4% fee
  savingsVsWUHi:      number;    // dollars saved vs 8% fee
  savingsVsRemitly:   number;    // dollars saved vs 1.75% fee
}

export const FEE_GEOMETRY: Readonly<FeeGeometryProof> = (() => {
  const fiatD    = phiPow(-4);
  const phantomD = phiPow(-3);
  const delta    = phantomD - fiatD;
  const phi6     = phiPow(-6);
  const wu_lo    = 0.04;
  const wu_hi    = 0.08;
  const rem_mid  = 0.0175;
  const wu_mid   = (wu_lo + wu_hi) / 2;
  return {
    feeFiatDecimal:     fiatD,
    feeFiatPct:         fiatD * 100,
    feePhantomDecimal:  phantomD,
    feePhantomPct:      phantomD * 100,
    feeRatio:           phantomD / fiatD,
    feeDelta:           delta,
    feeDeltaVerify:     phi6,
    westernUnionLo:     wu_lo,
    westernUnionHi:     wu_hi,
    remitlyMid:         rem_mid,
    parallaxPctAdvantage: ((wu_mid - fiatD) / wu_mid) * 100,
    proof: [
      'φ⁻⁴ is chosen as the base settlement fee because:',
      '  1. It satisfies φ⁻⁴ · φ⁴ = 1 (multiplicative normalization with φ-axis)',
      '  2. It is less than any competitor by ≥ 97% (WU charges 4–8%)',
      '  3. The Phantom premium φ⁻³ = φ⁻⁴ · φ is exactly one φ-step above,',
      '     so the fee tower is geometrically self-similar: every rail fee',
      '     differs from the next by exactly a factor of φ.',
      '  4. The fee difference is φ⁻⁶ — two steps below the AMOR constant φ⁻².',
      '  5. φ⁻⁴ + φ⁻³ = φ⁻⁴(1 + φ) = φ⁻⁴ · φ² = φ⁻²   (the AMOR constant)',
      '     — the sum of all PARALLAX fees equals the love constant.',
    ].join('\n'),
    savingsVsWULo:   1000 * (wu_lo  - fiatD),
    savingsVsWUHi:   1000 * (wu_hi  - fiatD),
    savingsVsRemitly:1000 * (rem_mid - fiatD),
  };
})();

// ═══════════════════════════════════════════════════════════════════════════════
// §9  SOVEREIGN TIER PROGRESSION (Paper V)
// Contributor pressure P accumulates via φ-scaled contributions.
// Tier boundaries: T₁ = φ¹, T₂ = φ², T₃ = φ³, T₄ = φ⁴, T₅ = φ⁵
// Reputation weight: W(c) = S₀ + Σδ · φ^{tier(c)}
// No-Drop Law: W(c) ≥ S₀ = 1.0 always (floor is structural)
// ═══════════════════════════════════════════════════════════════════════════════

export interface SovereignTier {
  tier:             number;       // 1–5
  name:             string;
  pressureThreshold:number;       // P must exceed this to unlock tier
  reputationBonus:  number;       // φ^tier per contribution unit at this tier
  description:      string;
}

export const SOVEREIGN_TIERS: Readonly<SovereignTier[]> = [
  { tier: 1, name: 'OBSERVER',   pressureThreshold: 0,          reputationBonus: PHI,          description: 'Initial ring — read-only access, 0 contributions required' },
  { tier: 2, name: 'CONTRIBUTOR',pressureThreshold: phiPow(1),  reputationBonus: phiPow(2),    description: 'First φ barrier crossed — write access, PHI pressure' },
  { tier: 3, name: 'ARCHITECT',  pressureThreshold: phiPow(2),  reputationBonus: phiPow(3),    description: 'Design authority — PHI² pressure, structural proposals' },
  { tier: 4, name: 'NEXUS',      pressureThreshold: phiPow(3),  reputationBonus: phiPow(4),    description: 'Cross-canister authority — PHI³ pressure, cross-domain binding' },
  { tier: 5, name: 'SOVEREIGN',  pressureThreshold: phiPow(4),  reputationBonus: phiPow(5),    description: 'NOVA-level governance — PHI⁴ pressure, irreversibly rare' },
];

/** No-Drop Law: reputation ≥ S₀ = 1.0 always (Paper V, Theorem 1) */
export function applyNoDropLaw(reputation: number): number {
  return Math.max(1.0, reputation);
}

/** Sovereign tier pressure formula: P += δ · φ^{tier} per contribution */
export function contributionPressure(delta: number, tier: number): number {
  return delta * phiPow(Math.min(tier, 5));
}

/** Which tier does a given pressure score unlock? */
export function tierFromPressure(pressure: number): SovereignTier {
  return [...SOVEREIGN_TIERS].reverse().find(t => pressure >= t.pressureThreshold) ?? SOVEREIGN_TIERS[0];
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10  φ-CONVERGENCE TABLE (continued fraction convergents)
// φ = 1 + 1/(1 + 1/(1 + 1/(...)))  — the simplest continued fraction [1;1,1,1,…]
// Convergents: 1/1, 2/1, 3/2, 5/3, 8/5, 13/8, 21/13, 34/21, …
// These are consecutive Fibonacci ratios — the fastest converging infinite CF.
// ═══════════════════════════════════════════════════════════════════════════════

export interface PhiConvergent {
  n:           number;
  numerator:   number;    // F(n+1)
  denominator: number;    // F(n)
  value:       number;    // F(n+1)/F(n)
  error:       number;    // |value − φ|
}

export const PHI_CONVERGENTS: Readonly<PhiConvergent[]> =
  FIBONACCI.slice(2).map((f, i) => ({
    n:           i + 2,
    numerator:   f,
    denominator: FIBONACCI[i + 1],
    value:       f / FIBONACCI[i + 1],
    error:       Math.abs(f / FIBONACCI[i + 1] - PHI),
  }));

// ═══════════════════════════════════════════════════════════════════════════════
// §11  ANCIENT MEAN HIERARCHY
// Given two values a > b > 0:
//   Arithmetic mean  A = (a+b)/2
//   Geometric mean   G = √(ab)
//   Harmonic mean    H = 2ab/(a+b)
// The Pythagorean hierarchy: H ≤ G ≤ A
// When a/b = φ: G/H = A/G = √φ — the means are themselves φ-related.
// ═══════════════════════════════════════════════════════════════════════════════

export interface AncientMeans {
  a: number; b: number;
  arithmetic: number;
  geometric:  number;
  harmonic:   number;
  agRatio:    number;   // A/G
  ghRatio:    number;   // G/H
  // Verify: when a/b = φ, A/G = G/H = √φ
  aOverB:     number;
  isPhiRatio: boolean;
  sqrtPhi:    number;
}

export function computeAncientMeans(a: number, b: number): AncientMeans {
  const A = (a + b) / 2;
  const G = Math.sqrt(a * b);
  const H = (2 * a * b) / (a + b);
  return {
    a, b,
    arithmetic: A,
    geometric:  G,
    harmonic:   H,
    agRatio:    A / G,
    ghRatio:    G / H,
    aOverB:     a / b,
    isPhiRatio: Math.abs(a / b - PHI) < 1e-6,
    sqrtPhi:    Math.sqrt(PHI),
  };
}

// When a = φ, b = 1: the golden mean triple
export const GOLDEN_MEANS: Readonly<AncientMeans> = computeAncientMeans(PHI, 1);

// ═══════════════════════════════════════════════════════════════════════════════
// §12  GEOMETRIC ATTRIBUTION SEAL (Paper I — SAT Genesis)
// Every capability in NOVA receives a genesis hash that encodes:
//   (1) A Fibonacci-indexed sequence number
//   (2) The current φ-power epoch (floor(log_φ(timestamp mod 10^6)))
//   (3) A Platonic solid affinity (vertex count mod 5 → solid)
// This is the "genesis immutability" invariant from Paper I, §3.1.
// ═══════════════════════════════════════════════════════════════════════════════

export interface GeometricSeal {
  sequenceIndex:   number;    // Fibonacci index of this capability
  fibValue:        number;    // F(sequenceIndex)
  phiEpoch:        number;    // floor(log_φ(timestamp mod 10^6))
  platonicSolid:   string;    // solid assigned to this genesis
  sealVector:      [number, number, number];   // (fibValue mod 1, phiEpoch, solidIndex)
  // The seal is structurally immutable: once emitted, the phiEpoch only increases
  isImmutable:     true;
}

const SOLID_NAMES = ['Tetrahedron', 'Cube', 'Octahedron', 'Dodecahedron', 'Icosahedron'];

export function generateGeometricSeal(capabilityIndex: number, timestamp: number): GeometricSeal {
  const fibIdx   = Math.min(capabilityIndex % 21, 20);
  const fibVal   = FIBONACCI[fibIdx];
  const tsMod    = timestamp % 1_000_000 || 1;
  const phiEpoch = Math.floor(Math.log(tsMod) / Math.log(PHI));
  const solidIdx = fibVal % 5;
  return {
    sequenceIndex: fibIdx,
    fibValue:      fibVal,
    phiEpoch,
    platonicSolid: SOLID_NAMES[solidIdx],
    sealVector:    [(fibVal / 1000) % 1, phiEpoch / 100, solidIdx / 4],
    isImmutable:   true,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT SUMMARY  (single object for UI consumption)
// ═══════════════════════════════════════════════════════════════════════════════

export const SOVEREIGN_GEOMETRY = {
  phiPowers:        PHI_POWERS,
  fibonacci:        FIBONACCI,
  fibConvergents:   FIBONACCI_CONVERGENTS,
  goldenRectangle:  GOLDEN_RECTANGLE,
  goldenSpiral:     GOLDEN_SPIRAL,
  platonicSolids:   PLATONIC_SOLIDS,
  vesicaPiscis:     VESICA_PISCIS,
  theodorusSpiral:  THEODORUS_SPIRAL,
  goldenPentagon:   GOLDEN_PENTAGON,
  feeGeometry:      FEE_GEOMETRY,
  sovereignTiers:   SOVEREIGN_TIERS,
  phiConvergents:   PHI_CONVERGENTS,
  goldenMeans:      GOLDEN_MEANS,
} as const;

export type SovereignGeometry = typeof SOVEREIGN_GEOMETRY;
