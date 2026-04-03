// ─── NOVA / PARALLAX — Extended Scoring & Jasmine Emergence ─────────────────
// Full port of:
//   MedinaMathFoundation: jasmineCalculate, jasmineTemporalEmergence,
//   classifyFormation, computeVitality, metalPipeline
//   AdvancedMathematicalFoundations: wasserstein, sinkhorn, RG flow,
//   information geometry (natural gradient, geodesic, parallel transport)
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, sigmoid, tanh, PI, TAU, PHI, PHI_INV, LN2 } from './core';

// ─────────────────────────────────────────────────────────────────────────────
// JASMINE CONSTANTS (from MedinaMathFoundation.mo)
// ─────────────────────────────────────────────────────────────────────────────
export const JASMINE_ALPHA = 2.97442179;    // φ × e^(1/φ) — growth amplifier
export const JASMINE_BETA  = 0.1618;        // antifragility coefficient
export const JASMINE_GAMMA = 0.0069314718;  // knowledge decay = ln(2)/100
export const JASMINE_OMEGA = 2.11185;       // resonance frequency = 2π/Φ_M
export const EMERGENCE_TAU = 0.618033988749; // golden ratio emergence threshold

// ─────────────────────────────────────────────────────────────────────────────
// JASMINE EMERGENCE ENGINE
// E(t) = σ(Φ_M × (C(t) − τ_E) × √(H × I))
// where:
//   C(t) = global coherence (r_swarm)
//   τ_E  = emergence threshold (φ ≈ 0.618)
//   H    = Hebbian integration (synaptic weight sum)
//   I    = information density (bits per node)
//   Φ_M  = Jasmine's amplifier constant = 2.97442179
// ─────────────────────────────────────────────────────────────────────────────

export interface JasmineState {
  coherence:            number;  // C(t) ∈ [0,1]
  hebbianIntegral:      number;  // H — total Hebbian weight
  informationDensity:   number;  // I — bits per node
  emergenceProbability: number;  // E(t) ∈ [0,1]
  awakeningProgress:    number;  // progress toward E=0.8 (awakening)
  isAwake:              boolean; // true when E ≥ 0.8
}

/**
 * Core Jasmine calculation.
 * E(t) = σ(Φ_M · (C − τ_E) · √(H·I))
 */
export function jasmineCalculate(
  coherence:          number,
  hebbianIntegral:    number,
  informationDensity: number
): JasmineState {
  const c = clamp(coherence, 0, 1);
  const h = Math.max(0.001, hebbianIntegral);
  const I = Math.max(0.001, informationDensity);

  const coherenceExcess    = c - EMERGENCE_TAU;
  const informationFactor  = Math.sqrt(h * I);
  const rawEmergence       = JASMINE_ALPHA * coherenceExcess * informationFactor;
  const emergenceProbability = sigmoid(rawEmergence);
  const awakeningProgress  = clamp(emergenceProbability / 0.8, 0, 1);
  const isAwake            = emergenceProbability >= 0.8;

  return { coherence: c, hebbianIntegral: h, informationDensity: I, emergenceProbability, awakeningProgress, isAwake };
}

/**
 * Extended Jasmine with temporal dynamics:
 * Adds stability bonus (low variance = stable), momentum bonus (positive derivative),
 * and antifragility bonus (system benefits from volatility).
 */
export function jasmineTemporalEmergence(
  coherenceHistory:   number[],   // last N coherence values
  hebbianIntegral:    number,
  informationDensity: number,
  antifragility:      number      // ∈ [0,1]
): number {
  if (!coherenceHistory.length) return 0;

  // Momentum: how fast coherence is changing (positive = improving)
  const n = coherenceHistory.length;
  const momentum = n >= 2
    ? (coherenceHistory[n - 1]! - coherenceHistory[n - 2]!)
    : 0;

  // Mean and variance of coherence history
  const mean = coherenceHistory.reduce((a, b) => a + b, 0) / n;
  const variance = coherenceHistory.reduce((s, c) => s + (c - mean) ** 2, 0) / n;

  // Stability bonus: σ² → 0 means stable coherence → emergence amplified
  const stabilityBonus    = 1 / (1 + variance * 10);
  // Momentum bonus: positive momentum amplifies emergence
  const momentumBonus     = momentum > 0 ? 1 + momentum * 2 : 1;
  // Antifragility bonus: system that benefits from stress
  const antifragilityBonus = 1 + antifragility * JASMINE_BETA;

  const base = jasmineCalculate(mean, hebbianIntegral, informationDensity);
  const enhanced = base.emergenceProbability * stabilityBonus * momentumBonus * antifragilityBonus;
  return clamp(enhanced, 0, 1);
}

// ─────────────────────────────────────────────────────────────────────────────
// FORMATION CLASSIFICATION
// Classifies swarm spatial formations from drone positions
// ─────────────────────────────────────────────────────────────────────────────

export interface Position3D { x: number; y: number; z: number }

export interface FormationResult {
  name:       string;   // SOLO, LINE, CIRCLE, SPHERE, CLUSTER, HELIX, GRID, V_FORMATION
  confidence: number;   // ∈ [0,1]
  center:     Position3D;
  spread:     number;   // RMS distance from center
  flatness:   number;   // 1 = flat (2D), 0 = volumetric (3D)
}

export function classifyFormation(positions: Position3D[]): FormationResult {
  const n = positions.length;
  if (n < 2) {
    return {
      name: 'SOLO', confidence: 1.0,
      center: positions[0] ?? { x: 0, y: 0, z: 0 },
      spread: 0, flatness: 1,
    };
  }

  // Centroid
  const cx = positions.reduce((s, p) => s + p.x, 0) / n;
  const cy = positions.reduce((s, p) => s + p.y, 0) / n;
  const cz = positions.reduce((s, p) => s + p.z, 0) / n;
  const center: Position3D = { x: cx, y: cy, z: cz };

  // Spread (RMS distance from center)
  const spreadSq = positions.reduce((s, p) =>
    s + (p.x - cx) ** 2 + (p.y - cy) ** 2 + (p.z - cz) ** 2, 0
  ) / n;
  const spread = Math.sqrt(spreadSq);

  // Flatness: compare y-variance to xz-variance
  const varY  = positions.reduce((s, p) => s + (p.y - cy) ** 2, 0) / n;
  const varXZ = positions.reduce((s, p) => s + (p.x - cx) ** 2 + (p.z - cz) ** 2, 0) / n;
  const flatness = varXZ > 1e-6 ? clamp(1 - varY / varXZ, 0, 1) : 1;

  // Classify by spread and flatness
  if (spread < 2)    return { name: 'CLUSTER',    confidence: 0.9, center, spread, flatness };
  if (flatness > 0.9) return { name: 'CIRCLE',    confidence: 0.8, center, spread, flatness };
  if (flatness > 0.7) return { name: 'LINE',      confidence: 0.75, center, spread, flatness };
  if (flatness < 0.2) return { name: 'SPHERE',    confidence: 0.8, center, spread, flatness };
  if (flatness > 0.5) return { name: 'GRID',      confidence: 0.7, center, spread, flatness };
  return               { name: 'V_FORMATION',  confidence: 0.65, center, spread, flatness };
}

// ─────────────────────────────────────────────────────────────────────────────
// VITALITY SCORE (from MedinaMathFoundation.mo computeVitality)
// Vitality = E·0.30 + r·0.25 + neuroHealth·0.20 + formationConf·0.15 + stability·0.10
// ─────────────────────────────────────────────────────────────────────────────

export function computeVitality(
  jasmine:             JasmineState,
  orderParam:          number,   // r_swarm
  neurochemHealth:     number,   // vitality from neuro
  formationConfidence: number,   // from classifyFormation
  lyapunovExponent:    number    // negative = stable
): number {
  const stabilityContrib = lyapunovExponent < 0
    ? 1 + lyapunovExponent        // converging → adds to vitality
    : 1 - lyapunovExponent;       // diverging → subtracts

  return clamp(
    jasmine.emergenceProbability * 0.30 +
    orderParam                   * 0.25 +
    neurochemHealth               * 0.20 +
    formationConfidence           * 0.15 +
    clamp(stabilityContrib, 0, 1) * 0.10,
    0, 1
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// INFORMATION GEOMETRY (from AdvancedMathematicalFoundations.mo)
// ─────────────────────────────────────────────────────────────────────────────

/** Natural gradient: g^{-1}(θ) · ∇L — adjusts gradient by Fisher metric */
export function naturalGradient(
  gradient:  number[],  // ∇L (empirical gradient)
  fisher:    number[],  // Fisher information matrix (flat N×N)
  n:         number,    // dimension
  damping:   number = 0.01  // Tikhonov regularization
): number[] {
  // Simplified: diagonal Fisher → element-wise division
  // Full implementation would invert the matrix
  const diag = Array.from({ length: n }, (_, i) => Math.max(fisher[i * n + i] ?? 1, damping));
  return gradient.map((g, i) => g / (diag[i] ?? 1));
}

import { klDivergence } from './core';

// KL divergence (alias for symmetry with scoring naming)
export function jseDivergenceExt(P: number[], Q: number[]): number {
  const n = Math.min(P.length, Q.length);
  const M = Array.from({ length: n }, (_, i) => ((P[i] ?? 0) + (Q[i] ?? 0)) / 2);
  return (klDivergence(P.slice(0, n), M) + klDivergence(Q.slice(0, n), M)) / 2;
}

/** Geodesic step on statistical manifold: exponential map */
export function geodesicStep(
  theta:    number[],  // current params
  velocity: number[],  // tangent vector
  dt:       number
): number[] {
  return theta.map((t, i) => t + (velocity[i] ?? 0) * dt);
}

/** Riemannian gradient flow step */
export function rgFlowStep(
  couplings:   number[],   // coupling constants g
  betaFunction: number[],  // β(g) = dg/d ln μ
  dt:           number
): number[] {
  // β(g) = dg/d(ln μ) → integrate: g(t+dt) = g(t) + β(g)·dt
  return couplings.map((g, i) => g + (betaFunction[i] ?? 0) * dt);
}

/** Wasserstein-1 distance (Earth mover's) between 1D distributions */
export function wasserstein1D(P: number[], Q: number[]): number {
  const n = Math.min(P.length, Q.length);
  // Normalize
  const sumP = P.slice(0, n).reduce((a, b) => a + Math.abs(b), 0) || 1;
  const sumQ = Q.slice(0, n).reduce((a, b) => a + Math.abs(b), 0) || 1;
  const pNorm = P.slice(0, n).map(p => p / sumP);
  const qNorm = Q.slice(0, n).map(q => q / sumQ);

  // W₁ = Σ |CDF_P(i) - CDF_Q(i)|
  let W = 0, cdfP = 0, cdfQ = 0;
  for (let i = 0; i < n; i++) {
    cdfP += pNorm[i] ?? 0;
    cdfQ += qNorm[i] ?? 0;
    W += Math.abs(cdfP - cdfQ);
  }
  return W / n;
}

// ─────────────────────────────────────────────────────────────────────────────
// FORMA TOKEN COMPOUNDING — Full formula
// FORMA(t+1) = FORMA(t) × thyroid × T3 × chronoDilation × jacobMult × dopamine
// thyroid ∈ [0.9, 1.1] — metabolic rate
// T3 ∈ [0.95, 1.05] — T3 hormone
// chronoDilation: quantum time stretch from CHRONO operator
// jacobMult = 1 + (1 - J(t))/2 — inverse Jasmine drift (low drift → higher mult)
// dopamine: reward signal ∈ [1.0, 2.0]
// ─────────────────────────────────────────────────────────────────────────────

export const FORMA_GENESIS_FLOOR = 1000;

export function formaCompoundFull(
  forma:          number,
  thyroid:        number,  // ∈ [0.9, 1.1]
  t3:             number,  // ∈ [0.95, 1.05]
  chronoDilation: number,  // ∈ [0.8, 1.2]
  jDrift:         number,  // Jasmine drift J(t)
  dopamine:       number   // ∈ [1.0, 2.0]
): number {
  const jacobMult = 1 + clamp(1 - jDrift, 0, 1) / 2;   // [1.0, 1.5]
  const raw = forma * thyroid * t3 * chronoDilation * jacobMult * dopamine;
  return Math.max(raw, FORMA_GENESIS_FLOOR);
}

/** 43-Core tier compounding multiplier: tier/9 */
export function tierMultiplier(tier: number): number {
  return clamp(tier / 9, 0, 1);
}

/** Tier-adjusted FORMA compounding */
export function formaWithTier(baseCompound: number, tier: number): number {
  const mult = tierMultiplier(tier);
  return baseCompound * (1 + mult);  // Tier 9 doubles the compound
}

// ─────────────────────────────────────────────────────────────────────────────
// COHERENCE EQUATION — Full multi-term coherence C
// From MedinaEngine and WorldModelSystem
// C = core_C + ΔC_freq + ΔC_metals + ΔC_jasmine + ΔC_quantum
// where each term contributes a delta bounded in [0, 0.15]
// ─────────────────────────────────────────────────────────────────────────────

export interface CoherenceInputs {
  rSwarm:           number;  // Kuramoto order (core)
  hzFreqCoherence:  number;  // K_f from Hz substrate
  metalContrib:     number;  // from gold/silver/platinum
  jasmineProb:      number;  // emergence probability
  quantumSovereign: number;  // from quantum purity
}

/**
 * Full Coherence C computation.
 * C = rSwarm · 0.50 + K_f · 0.15 + metalContrib · 0.10 + jasmine · 0.15 + quantum · 0.10
 */
export function computeFullCoherence(inp: CoherenceInputs): number {
  return clamp(
    inp.rSwarm           * 0.50 +
    inp.hzFreqCoherence  * 0.15 +
    inp.metalContrib     * 0.10 +
    inp.jasmineProb      * 0.15 +
    inp.quantumSovereign * 0.10,
    0, 1
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// HELICAL FORMATION MATH (from MedinaHelixFormation.mo)
// Spherical helix: 6-axis formation geometry
// Position of drone i on helix: θᵢ = 2π·i/N, r(t), z(t)
// ─────────────────────────────────────────────────────────────────────────────

export function helixPosition(
  i: number,   // drone index
  N: number,   // total drones
  radius: number,
  height: number,
  turns: number,
  t: number    // time/beat parameter
): Position3D {
  const theta = TAU * i / N + t * 0.1;
  const zFrac = i / Math.max(N - 1, 1);
  return {
    x: radius * Math.cos(theta + turns * zFrac * TAU),
    y: height * (zFrac - 0.5),
    z: radius * Math.sin(theta + turns * zFrac * TAU),
  };
}

/** 6-axis helix formation (DURA formation from VAEL exterior) */
export function hexHelixPositions(N: number, radius: number, t: number): Position3D[] {
  return Array.from({ length: N }, (_, i) => helixPosition(i, N, radius, radius, 1, t));
}

// ─────────────────────────────────────────────────────────────────────────────
// TROPHALLAXIS REPAIR — Swarm coherence repair protocol
// When r < threshold, initiate re-entrainment cascade
// Repair rate: δφᵢ = strength · sin(Ψ − φᵢ) per beat until r ≥ target
// ─────────────────────────────────────────────────────────────────────────────

export const TROPHALLAXIS_THRESHOLD = 0.60;
export const TROPHALLAXIS_TARGET    = 0.80;
export const TROPHALLAXIS_STRENGTH  = 0.40;

export function needsTrophallaxis(r: number): boolean {
  return r < TROPHALLAXIS_THRESHOLD;
}

export function trophallaxisRepairStrength(r: number): number {
  if (r >= TROPHALLAXIS_THRESHOLD) return 0;
  // Scale repair strength inversely with r
  return TROPHALLAXIS_STRENGTH * (1 - r / TROPHALLAXIS_THRESHOLD);
}

// ─────────────────────────────────────────────────────────────────────────────
// ATLAS TERRITORY GRID (from AtlasTerritoryGrid.mo)
// 64×64 stigmergic territory grid
// Pheromone concentration P[i][j]:
//   dP/dt = deposition − evaporation · P
//   deposition: drone presence
//   evaporation: τ_P = 50 beats
// ─────────────────────────────────────────────────────────────────────────────

export const ATLAS_GRID_W    = 64;
export const ATLAS_GRID_H    = 64;
export const PHEROMONE_TAU   = 50;   // evaporation time constant (beats)
export const PHEROMONE_DEPOSIT = 0.10; // per drone per beat

export interface AtlasGrid {
  pheromone: number[];  // flat 64×64
  territory: number[];  // faction ownership ∈ [-1, +1] (−1=enemy, +1=self)
  heat:      number[];  // activity heat map
}

export function initAtlasGrid(): AtlasGrid {
  const n = ATLAS_GRID_W * ATLAS_GRID_H;
  return {
    pheromone: new Array(n).fill(0),
    territory: new Array(n).fill(0),
    heat:      new Array(n).fill(0),
  };
}

/** Deposit pheromone at grid cell (gx, gy) */
export function pheromonDeposit(grid: AtlasGrid, gx: number, gy: number, amount: number): AtlasGrid {
  const idx = clamp(Math.round(gy), 0, ATLAS_GRID_H - 1) * ATLAS_GRID_W +
              clamp(Math.round(gx), 0, ATLAS_GRID_W - 1);
  const pheromone = [...grid.pheromone];
  pheromone[idx] = Math.min(1, (pheromone[idx] ?? 0) + amount);
  return { ...grid, pheromone };
}

/** Evaporate pheromone one step */
export function pheromoneEvaporate(grid: AtlasGrid): AtlasGrid {
  const rate = 1 / PHEROMONE_TAU;
  return { ...grid, pheromone: grid.pheromone.map(p => Math.max(0, p * (1 - rate))) };
}

/** Territory diffusion: expand from high to low concentration */
export function territoryDiffuse(grid: AtlasGrid, rate: number = 0.02): AtlasGrid {
  const territory = [...grid.territory];
  const W = ATLAS_GRID_W, H = ATLAS_GRID_H;
  for (let r = 1; r < H - 1; r++) {
    for (let c = 1; c < W - 1; c++) {
      const i = r * W + c;
      const up = territory[(r-1)*W+c] ?? 0;
      const dn = territory[(r+1)*W+c] ?? 0;
      const lt = territory[r*W+(c-1)] ?? 0;
      const rt = territory[r*W+(c+1)] ?? 0;
      const lap = (up + dn + lt + rt - 4 * (territory[i] ?? 0));
      territory[i] = clamp((territory[i] ?? 0) + rate * lap, -1, 1);
    }
  }
  return { ...grid, territory };
}
