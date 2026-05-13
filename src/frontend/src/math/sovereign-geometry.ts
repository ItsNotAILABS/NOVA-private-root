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
// §13  GOLDEN TRIANGLE & GOLDEN GNOMON
// The two fundamental triangles of the golden ratio — they tile the plane
// (as Penrose P3 Robinson tiles) and together construct the regular pentagon
// and the star pentagram.
//
// GOLDEN TRIANGLE (acute isoceles): apex = 36°, base angles = 72°–72°
//   leg / base = φ    (if base = 1, each equal leg = φ)
//   Self-similar: bisecting one base angle separates a golden gnomon from
//   a smaller golden triangle, each scaled by φ⁻¹.
//   Five golden triangles meeting at the center assemble a regular pentagon.
//
// GOLDEN GNOMON (obtuse isoceles): apex = 108°, base angles = 36°–36°
//   base / leg = φ    (if legs = 1, the base = φ)
//   Complement to the golden triangle: together they tile the plane and build
//   the Penrose P3 tiling (aperiodic, 5-fold symmetric).
//
// KEY PROOF:  cos(36°) = φ/2  (exact) — from the identity
//   2cos(π/5) = (1+√5)/2 = φ.  Therefore diagonal/side in a regular pentagon
//   equals 2cos(36°) = φ, connecting the pentagon, pentagram, and golden triangles.
// ═══════════════════════════════════════════════════════════════════════════════

export interface GoldenTriangle {
  apexAngleDeg:          number;   // 36° — tip of the acute triangle
  baseAngleDeg:          number;   // 72° — each base angle
  base:                  number;   // 1 (normalized)
  leg:                   number;   // φ — each equal leg
  legToBaseRatio:        number;   // φ — defining ratio
  height:                number;   // φ·sin(72°) — altitude from apex to base
  area:                  number;   // ½·base·height
  perimeter:             number;   // 2φ + 1
  circumradius:          number;   // φ / (2·sin 36°)
  inradius:              number;   // area / semi-perimeter
  selfSimilarityRatio:   number;   // φ⁻¹ — scaling factor each gnomonic cut
  cosApexExact:          number;   // cos(36°) = φ/2 — exact proof value
  proof:                 string;
}

export const GOLDEN_TRIANGLE: Readonly<GoldenTriangle> = (() => {
  const apex36  = 36 * PI / 180;
  const base72  = 72 * PI / 180;
  const leg     = PHI;
  const base    = 1;
  const height  = leg * Math.sin(base72);
  const area    = 0.5 * base * height;
  const perim   = 2 * leg + base;
  const semi    = perim / 2;
  const R       = leg / (2 * Math.sin(apex36));
  const inr     = area / semi;
  return {
    apexAngleDeg:        36,
    baseAngleDeg:        72,
    base,
    leg,
    legToBaseRatio:      PHI,
    height,
    area,
    perimeter:           perim,
    circumradius:        R,
    inradius:            inr,
    selfSimilarityRatio: PHI_INV,
    cosApexExact:        PHI / 2,   // cos(π/5) = φ/2 exactly
    proof: [
      'cos(36°) = cos(π/5) = φ/2 exactly (from Chebyshev polynomial T₅).',
      'Therefore leg/base = 2cos(36°) = φ for a 36-72-72° isoceles triangle.',
      'Bisecting one 72° base angle creates a smaller golden gnomon (inverted) and',
      'a smaller golden triangle scaled by φ⁻¹. The recursion is infinite.',
      'Five such triangles fan around a common apex to build a regular pentagon;',
      'the five diagonals of the pentagon form a pentagram whose triangles are',
      'again golden triangles — a closed self-similar system.',
    ].join(' '),
  };
})();

export interface GoldenGnomon {
  apexAngleDeg:          number;   // 108° — obtuse apex
  baseAngleDeg:          number;   // 36°  — each base angle
  leg:                   number;   // 1 (normalized equal legs)
  base:                  number;   // φ — the longer base
  baseToLegRatio:        number;   // φ — defining ratio
  height:                number;   // sin(36°) — altitude from apex to base midpoint
  area:                  number;   // ½·base·height = φ·sin(36°)/2
  perimeter:             number;   // 2 + φ
  circumradius:          number;   // φ / (2·sin 108°)
  inradius:              number;   // area / semi-perimeter
  selfSimilarityRatio:   number;   // φ⁻¹ — scaling factor each gnomonic cut
  penrosePairName:       string;   // 'Golden Triangle' — Penrose P3 tile partner
}

export const GOLDEN_GNOMON: Readonly<GoldenGnomon> = (() => {
  const apex108  = 108 * PI / 180;
  const base36   = 36  * PI / 180;
  const leg      = 1;
  const base     = PHI;
  const height   = leg * Math.sin(base36);
  const area     = 0.5 * base * height;
  const perim    = 2 * leg + base;
  const semi     = perim / 2;
  const R        = base / (2 * Math.sin(apex108));
  const inr      = area / semi;
  return {
    apexAngleDeg:        108,
    baseAngleDeg:        36,
    leg,
    base,
    baseToLegRatio:      PHI,
    height,
    area,
    perimeter:           perim,
    circumradius:        R,
    inradius:            inr,
    selfSimilarityRatio: PHI_INV,
    penrosePairName:     'Golden Triangle',
  };
})();

// ═══════════════════════════════════════════════════════════════════════════════
// §14  GOLDEN ANGLE & PHYLLOTAXIS
// The golden angle γ = 360° × φ⁻² ≈ 137.5077640500...° is the irrational
// divergence angle governing botanical growth: sunflower seeds, pine-cone
// scales, leaf spirals, and nautilus chambers.
//
// PROOF OF OPTIMALITY:
//   Any rational divergence angle p/q° produces exactly q angular spokes and
//   leaves large bare sectors between them.  The golden angle, whose continued-
//   fraction expansion is [1;1,1,1,...] — the slowest-converging CF of any
//   positive real — maximises the minimum angular separation between all
//   successive seeds, packing them as uniformly as possible.
//
// PHYLLOTAXIS GEOMETRY (Vogel model):
//   n-th primordium:  r(n) = r₀·√n,  θ(n) = n·γ (radians)
//   Consecutive seeds separated by γ always group into two families of
//   Archimedean spirals whose member counts are consecutive Fibonacci numbers.
//   Sunflower: 34 clockwise / 55 counter-clockwise spirals (both Fibonacci).
// ═══════════════════════════════════════════════════════════════════════════════

export interface GoldenAngle {
  degreesExact:           number;   // 360 × φ⁻² ≈ 137.5077640500378...°
  complementDegrees:      number;   // 360 − γ ≈ 222.4922359499622...°
  radiansExact:           number;   // 2π × φ⁻² ≈ 2.399963229728653...
  phiSquaredInverse:      number;   // φ⁻² = 0.38196601125010515...
  fibonacciSpiralsLow:    number;   // inner Fibonacci spiral count (e.g. 34)
  fibonacciSpiralsHigh:   number;   // outer Fibonacci spiral count (e.g. 55)
  botanicalExamples:      string;
  proof:                  string;
}

export const GOLDEN_ANGLE: Readonly<GoldenAngle> = (() => {
  const phi2inv = phiPow(-2);           // φ⁻²
  const deg     = 360 * phi2inv;        // ≈ 137.5077640500378°
  const rad     = 2 * PI * phi2inv;     // ≈ 2.39996322972865...
  return {
    degreesExact:         deg,
    complementDegrees:    360 - deg,
    radiansExact:         rad,
    phiSquaredInverse:    phi2inv,
    fibonacciSpiralsLow:  34,
    fibonacciSpiralsHigh: 55,
    botanicalExamples: [
      'Sunflower (Helianthus annuus): 34/55 or 55/89 opposing spiral families.',
      'Pine cone (Pinus): 8/13 spirals.',
      'Pineapple (Ananas comosus): 8/13 spirals.',
      'Daisy (Bellis perennis): 21/34 spirals.',
      'Romanesco broccoli: 13/21 spirals.',
      'Aloe vera: leaf divergence ≈ golden angle.',
    ].join(' '),
    proof: [
      'γ = 360°·φ⁻² because φ satisfies φ⁻¹ + φ⁻² = 1 (the fundamental identity).',
      'So γ divides the full circle in the golden ratio: (360°−γ)/γ = φ.',
      'The CF expansion [1;1,1,...] makes φ the hardest irrational to approximate',
      'by rationals — hence n·γ (mod 360°) fills the circle most uniformly.',
      'The Fibonacci spiral counts emerge because F(n+1)·γ ≡ −F(n)·γ (mod 360°),',
      'creating the quasi-periodic lattice that human eyes parse as spirals.',
    ].join(' '),
  };
})();

/** Vogel model: position of the n-th primordium (seed / leaf) in polar form */
export function phyllotaxisSeed(
  n: number,
  r0 = 1,
): { r: number; theta: number; x: number; y: number } {
  const theta = n * GOLDEN_ANGLE.radiansExact;
  const r     = r0 * Math.sqrt(n);
  return { r, theta, x: r * Math.cos(theta), y: r * Math.sin(theta) };
}

/** Generate the first n primordium positions (Vogel spiral) */
export function phyllotaxisSpiral(n: number, r0 = 1) {
  return Array.from({ length: n }, (_, i) => phyllotaxisSeed(i + 1, r0));
}

// ═══════════════════════════════════════════════════════════════════════════════
// §15  KEPLER'S TRIANGLE
// The unique right triangle whose sides are in the ratio 1 : √φ : φ.
// Documented by Johannes Kepler (Mysterium Cosmographicum, 1597).
//
// PYTHAGOREAN PROOF:
//   1² + (√φ)² = 1 + φ = φ²     (since φ² = φ + 1, the defining equation of φ)
//   ∴ the triangle is a valid right triangle. ✓
//
// GREAT PYRAMID CONNECTION:
//   The Great Pyramid of Giza (Khufu): slant height ≈ 356 royal cubits,
//   base half-width = 220 royal cubits.  356/220 ≈ 1.6182 ≈ φ.
//   The face triangle of the pyramid is a Kepler triangle within surveying
//   tolerance — suggesting ancient knowledge of this form.
//
// π–φ CONNECTION:
//   Perimeter / (2 × short leg) = (1 + √φ + φ) / 2 ≈ 1.5705... ≈ π/2
//   The error is |π/2 − (1+√φ+φ)/2| < 0.0003 — a near-miraculous coincidence
//   that has puzzled mathematicians for centuries.
// ═══════════════════════════════════════════════════════════════════════════════

export interface KeplerTriangle {
  shortLeg:              number;   // 1
  longLeg:               number;   // √φ ≈ 1.27201964951406896...
  hypotenuse:            number;   // φ ≈ 1.61803398874989485...
  hypotenuseToShort:     number;   // φ
  longToShort:           number;   // √φ
  hypotenuseToLong:      number;   // φ / √φ = √φ
  pythagoreanCheck:      number;   // 1 + φ = φ² (must equal hypotenuse²)
  shortLegAngleDeg:      number;   // arctan(1/√φ) ≈ 38.1727°
  longLegAngleDeg:       number;   // arctan(√φ)   ≈ 51.8273°
  rightAngleDeg:         number;   // 90°
  area:                  number;   // √φ / 2
  perimeter:             number;   // 1 + √φ + φ
  piPhiConnectionNote:   string;
  historicalNote:        string;
}

export const KEPLER_TRIANGLE: Readonly<KeplerTriangle> = (() => {
  const sqrtPhi    = Math.sqrt(PHI);
  const shortLeg   = 1;
  const longLeg    = sqrtPhi;
  const hyp        = PHI;
  const check      = shortLeg * shortLeg + longLeg * longLeg;  // should = φ²
  const shortAngle = Math.atan(1 / sqrtPhi) * 180 / PI;
  const longAngle  = Math.atan(sqrtPhi) * 180 / PI;
  return {
    shortLeg,
    longLeg,
    hypotenuse:          hyp,
    hypotenuseToShort:   PHI,
    longToShort:         sqrtPhi,
    hypotenuseToLong:    sqrtPhi,  // φ / √φ = √φ
    pythagoreanCheck:    check,    // = 1 + φ = φ² = 2.6180...
    shortLegAngleDeg:    shortAngle,
    longLegAngleDeg:     longAngle,
    rightAngleDeg:       90,
    area:                0.5 * shortLeg * longLeg,
    perimeter:           shortLeg + longLeg + hyp,
    piPhiConnectionNote: [
      'Perimeter / (2 × short leg) = (1 + √φ + φ) / 2 ≈ 1.5705...',
      'π/2 ≈ 1.5707... — a near-identity with error < 0.03%.',
      'This is why ancient builders who knew φ may have "squared the circle"',
      'empirically: using a Kepler triangle approximates π from φ alone.',
    ].join(' '),
    historicalNote: [
      'Kepler described this triangle in Mysterium Cosmographicum (1597).',
      'Great Pyramid of Giza: slant height 356 / base half-width 220 = 1.6182 ≈ φ.',
      'The face triangle of Khufu\'s pyramid matches Kepler\'s triangle within',
      'the surveying accuracy of ancient Egyptian royal cubits.',
    ].join(' '),
  };
})();

// ═══════════════════════════════════════════════════════════════════════════════
// §16  FLOWER OF LIFE
// Seven overlapping circles (the "Seed of Life") where every surrounding
// circle centre lies exactly on the circumference of the central circle.
// The six outer centres form a regular hexagon of side r = circle radius.
//
// CIRCLE CENTRES (normalized r = 1):
//   C₀ = (0, 0)          — central circle
//   Cₖ = (cos(60°k), sin(60°k))  for k = 0…5  — ring circles
//
// SACRED GEOMETRY HISTORY:
//   — Temple of Osiris at Abydos, Egypt (red ochre, ≥535 BCE)
//   — Leonardo da Vinci's notebooks (15th c.)
//   — Forbidden City, Beijing
//   — Goldberg's molecular geometry (fullerenes)
//
// Extending to 19 circles (adding a second ring) yields the full "Flower of
// Life" pattern. Selecting 13 circles and connecting all centres with straight
// lines yields Metatron's Cube (§17).
// ═══════════════════════════════════════════════════════════════════════════════

export interface FlowerOfLife {
  circleRadius:          number;   // r = 1 (normalised)
  circleCountSeed:       number;   // 7  — "Seed of Life" (1 + 6)
  circleCountFull:       number;   // 19 — full Flower of Life (1 + 6 + 12)
  circleCountFruit:      number;   // 13 — "Fruit of Life" (basis for Metatron's Cube)
  innerHexagonSide:      number;   // r — the 6 outer centres form a hexagon of side r
  innerHexagonArea:      number;   // (3√3/2)·r²  for the inner hexagon
  patternWidth:          number;   // 4r — leftmost to rightmost point
  patternHeight:         number;   // r(2+√3) ≈ 3.732r
  vesicaPiscisCount:     number;   // 6 — adjacent circle pairs create 6 Vesica Piscis
  vesicaLensHeight:      number;   // r√3 per lens
  vesicaLensArea:        number;   // 2π/3 − √3/2 per unit-circle lens
  sqrt3Relation:         string;
  phiRelation:           string;
  sacredGeometryNote:    string;
}

export const FLOWER_OF_LIFE: Readonly<FlowerOfLife> = (() => {
  const r           = 1;
  const hexArea     = 3 * SQRT3 / 2;          // regular unit-side hexagon area
  const vesicaArea  = 2 * PI / 3 - SQRT3 / 2;
  return {
    circleRadius:        r,
    circleCountSeed:     7,
    circleCountFull:     19,
    circleCountFruit:    13,
    innerHexagonSide:    r,
    innerHexagonArea:    hexArea,
    patternWidth:        4 * r,
    patternHeight:       r * (2 + SQRT3),
    vesicaPiscisCount:   6,
    vesicaLensHeight:    r * SQRT3,
    vesicaLensArea:      vesicaArea,
    sqrt3Relation: [
      '60° hexagonal symmetry encodes √3 throughout.',
      'Lens height / lens width = √3 (each Vesica Piscis).',
      'Inner hexagon area = (3√3/2)r².',
      'Adjacent centre distance = r → lens height = r√3.',
    ].join(' '),
    phiRelation: [
      'In the 19-circle Flower of Life, connecting non-adjacent centres creates',
      'Vesica Piscis chains whose accumulated lengths converge to φ-multiples.',
      'The Fruit of Life (13 circles) generates Metatron\'s Cube (§17),',
      'which encodes all five Platonic solids and the golden triangles.',
    ].join(' '),
    sacredGeometryNote: [
      'Temple of Osiris, Abydos (red-ochre, ≥535 BCE).',
      'Leonardo da Vinci notebooks (15th c.).',
      'Forbidden City, Beijing.',
      'Appears in Goldberg polyhedra and carbon fullerene geometry.',
    ].join(' — '),
  };
})();

/** Return the (x, y) centre of ring circle k (k = 0…5) in the Seed of Life (r = 1) */
export function flowerOfLifeCenter(k: number, r = 1): { x: number; y: number } {
  const theta = (k * PI) / 3;   // 60° steps
  return { x: r * Math.cos(theta), y: r * Math.sin(theta) };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §17  METATRON'S CUBE
// Constructed by taking the 13-circle "Fruit of Life" pattern and drawing
// straight lines from every circle centre to every other circle centre.
//
// STRUCTURE:
//   13 circles: 1 central + 6 at radius r + 6 at radius 2r (offset 30°)
//   Lines: C(13,2) = 78 unique line segments
//
// ENCODED PLATONIC SOLIDS (2-D projections):
//   • Tetrahedron   — 4 vertices in the Star of David triangle pairs
//   • Cube          — hexagonal projection reveals 8 cube vertices
//   • Octahedron    — dual of cube projection (shared 12-edge skeleton)
//   • Dodecahedron  — pentagonal sub-rings (requires 3-D rotation)
//   • Icosahedron   — 20-triangle projection in the full diagram
//
// PHI PRESENCE:
//   The golden triangles (36°-72°-72°) and golden gnomons (108°-36°-36°)
//   tile the interior regions. Outer ring radius / inner ring radius = 2.
//   Connecting all 13 centres to the 6 inner centres forms a 6-pointed star
//   (hexagram) whose triangles are equilateral — a reflection of the φ-hexagon
//   packing underlying both the Flower of Life and Fibonacci spirals.
// ═══════════════════════════════════════════════════════════════════════════════

export interface MetatronsCube {
  totalCircles:           number;   // 13
  centralCount:           number;   // 1
  innerRingCount:         number;   // 6 (at distance r)
  outerRingCount:         number;   // 6 (at distance 2r, offset 30°)
  totalLines:             number;   // C(13,2) = 78
  innerRingRadius:        number;   // r = 1 (normalised)
  outerRingRadius:        number;   // 2r = 2
  outerToInnerRatio:      number;   // 2
  encodedPlatonicSolids:  string[];
  phiRelation:            string;
  sacredGeometryNote:     string;
}

export const METATRONS_CUBE: Readonly<MetatronsCube> = {
  totalCircles:    13,
  centralCount:    1,
  innerRingCount:  6,
  outerRingCount:  6,
  totalLines:      78,    // C(13,2) = 13·12/2 = 78
  innerRingRadius: 1,
  outerRingRadius: 2,
  outerToInnerRatio: 2,
  encodedPlatonicSolids: [
    'Tetrahedron (4 vertices — Star of David inner triangles)',
    'Cube (8 vertices — hexagonal axis projection)',
    'Octahedron (6 vertices — dual of cube, same 12-edge frame)',
    'Dodecahedron (20 vertices — pentagonal ring sub-structure)',
    'Icosahedron (12 vertices — inner ring + rotated outer pairs)',
  ],
  phiRelation: [
    'Golden triangles (36°-72°-72°) and golden gnomons (108°-36°-36°)',
    'tile every interior region of Metatron\'s Cube.',
    'The six inner-ring centres at radius r form a regular hexagon;',
    'six outer-ring centres at 2r and 30° offset complete the Fruit of Life.',
    'Every radial length ratio in the diagram is a power of √3 or involves φ.',
    'The 78 line segments contain nested self-similar golden triangles at',
    'every scale, mirroring the infinite regress of the pentagon / pentagram.',
  ].join(' '),
  sacredGeometryNote: [
    'Metatron\'s Cube is cited in Kabbalistic texts (Sefer Yetzirah, 3rd c. CE).',
    'Drunvalo Melchizedek\'s analysis (1990s) popularised its φ-geometry.',
    'The 78-line complete graph K₁₃ corresponds to 78 Tarot cards (coincidence).',
    'In molecular geometry, the 13-sphere arrangement describes',
    'the densest known packing of 12 equal spheres around a central sphere —',
    'a kissing-number result proved by Schütte & van der Waerden (1953).',
  ].join(' '),
};

/** Return the (x, y) centre of every circle in Metatron's Cube (r = 1) */
export function metatronsCubeCenters(r = 1): Array<{ x: number; y: number; ring: number }> {
  const centres: Array<{ x: number; y: number; ring: number }> = [
    { x: 0, y: 0, ring: 0 },   // central
  ];
  for (let k = 0; k < 6; k++) {
    const theta = (k * PI) / 3;                // 60° steps — inner ring
    centres.push({ x: r * Math.cos(theta), y: r * Math.sin(theta), ring: 1 });
  }
  for (let k = 0; k < 6; k++) {
    const theta = (k * PI) / 3 + PI / 6;      // 60° steps, 30° offset — outer ring
    centres.push({ x: 2 * r * Math.cos(theta), y: 2 * r * Math.sin(theta), ring: 2 });
  }
  return centres;
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
  goldenTriangle:   GOLDEN_TRIANGLE,
  goldenGnomon:     GOLDEN_GNOMON,
  goldenAngle:      GOLDEN_ANGLE,
  keplerTriangle:   KEPLER_TRIANGLE,
  flowerOfLife:     FLOWER_OF_LIFE,
  metatronsCube:    METATRONS_CUBE,
} as const;

export type SovereignGeometry = typeof SOVEREIGN_GEOMETRY;
