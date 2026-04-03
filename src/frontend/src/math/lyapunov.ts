// ─── NOVA / PARALLAX — Lyapunov Stability Engine ────────────────────────────
// Full port of LyapunovStability.mo + AttractorDynamics.mo
// V(t) = Σᵢ wᵢ(xᵢ − x̄ᵢ)² + cross-term penalties
// dV/dt < 0 ⟹ asymptotically stable (converging to attractor)
// Hopfield energy: E = −0.5 Σᵢⱼ wᵢⱼ·sᵢ·sⱼ + Σᵢ θᵢ·sᵢ
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, sigmoid, dot } from './core';

// ── Lyapunov State Variables (5-component) ────────────────────────────────────
// x₁ = coherenceC  x₂ = entropy  x₃ = arousal  x₄ = stability  x₅ = emergence
export interface LyapunovState5 {
  // Current state
  coherenceC:  number;  // x₁
  entropy:     number;  // x₂ — observational entropy H_obs
  arousal:     number;  // x₃
  stability:   number;  // x₄
  emergence:   number;  // x₅

  // Homeostatic targets (x̄ᵢ)
  targetC:     number;  // x̄₁ = 0.75
  targetH:     number;  // x̄₂ = 6.0 bits
  targetA:     number;  // x̄₃ = 0.50
  targetS:     number;  // x̄₄ = 0.85
  targetE:     number;  // x̄₅ = 0.70

  // Lyapunov function
  V:           number;  // V(t) — current value
  Vdot:        number;  // dV/dt — time derivative
  Vhistory:    number[];

  // Weights
  weights:     number[];  // [w₁, w₂, w₃, w₄, w₅]

  // Stability classification
  stableBeats:   number;  // consecutive beats with Vdot < 0
  unstableBeats: number;  // consecutive beats with Vdot > 0
  isAsymptotic:  boolean; // true if converging
}

// Default weights (from LyapunovStability.mo)
export const DEFAULT_LYAPUNOV_WEIGHTS = [0.35, 0.20, 0.15, 0.15, 0.15];

// Default targets (homeostatic equilibrium)
export const DEFAULT_LYAPUNOV_TARGETS = {
  targetC: 0.75,
  targetH: 6.00,
  targetA: 0.50,
  targetS: 0.85,
  targetE: 0.70,
};

export function initLyapunov(overrides?: Partial<LyapunovState5>): LyapunovState5 {
  return {
    coherenceC: 0.5, entropy: 4.0, arousal: 0.5, stability: 0.7, emergence: 0.4,
    ...DEFAULT_LYAPUNOV_TARGETS,
    V: 0.5, Vdot: 0, Vhistory: [],
    weights: [...DEFAULT_LYAPUNOV_WEIGHTS],
    stableBeats: 0, unstableBeats: 0, isAsymptotic: false,
    ...overrides,
  };
}

// ── Lyapunov function V(t) ─────────────────────────────────────────────────────
// V(t) = Σᵢ wᵢ·(xᵢ − x̄ᵢ)²  [weighted squared deviation from attractor]
// Plus cross-term penalties for contradictory states:
//   coherence < 0.5 AND arousal > 0.8 → penalty (incoherent + hyperaroused)
//   entropy > 10 AND stability > 0.9  → penalty (high disorder + claiming stable)
export function computeLyapunovV(s: LyapunovState5): number {
  const [w0 = 0.35, w1 = 0.20, w2 = 0.15, w3 = 0.15, w4 = 0.15] = s.weights;

  // Normalize entropy deviation (target 6.0, max ~12 bits)
  const entNorm = clamp(s.entropy / 12, 0, 1);
  const entTarget = clamp(s.targetH / 12, 0, 1);

  const V_core = (
    w0 * (s.coherenceC - s.targetC) ** 2 +
    w1 * (entNorm      - entTarget)  ** 2 +
    w2 * (s.arousal    - s.targetA)  ** 2 +
    w3 * (s.stability  - s.targetS)  ** 2 +
    w4 * (s.emergence  - s.targetE)  ** 2
  );

  // Cross-term penalties
  let cross = 0;
  if (s.coherenceC < 0.5 && s.arousal > 0.8) {
    cross += 0.05 * (0.5 - s.coherenceC) * (s.arousal - 0.8);
  }
  if (s.entropy > 10 && s.stability > 0.9) {
    cross += 0.03 * (s.entropy - 10) * (s.stability - 0.9);
  }

  return V_core + cross;
}

// ── dV/dt (finite difference estimate) ───────────────────────────────────────
export function estimateVdot(Vhistory: number[], dt: number = 1.0): number {
  const n = Vhistory.length;
  if (n < 2) return 0;
  return (Vhistory[n - 1]! - Vhistory[n - 2]!) / dt;
}

// ── Full Lyapunov tick ─────────────────────────────────────────────────────────
export function lyapunovTick(
  s: LyapunovState5,
  coherenceC: number,
  entropy:    number,
  arousal:    number,
  stability:  number,
  emergence:  number
): LyapunovState5 {
  const next: LyapunovState5 = {
    ...s,
    coherenceC, entropy, arousal, stability, emergence,
  };
  const V    = computeLyapunovV(next);
  const hist = [...s.Vhistory.slice(-49), V];
  const Vdot = estimateVdot(hist);

  const isStableBeat   = Vdot <= 0;
  const stableBeats    = isStableBeat    ? s.stableBeats + 1   : 0;
  const unstableBeats  = !isStableBeat   ? s.unstableBeats + 1 : 0;
  const isAsymptotic   = stableBeats >= 5; // 5 consecutive stable beats

  return { ...next, V, Vdot, Vhistory: hist, stableBeats, unstableBeats, isAsymptotic };
}

// ── Attractor Types ────────────────────────────────────────────────────────────
export type AttractorType = 'point' | 'limit-cycle' | 'strange' | 'saddle-node';

export interface Attractor {
  id:       number;
  position: number[];   // center of basin in state space
  strength: number;     // basin depth
  radius:   number;     // basin radius
  type:     AttractorType;
  stability: number;    // 0-1
  visits:   number;
}

// ── Hopfield Energy ────────────────────────────────────────────────────────────
// E = −(1/2) Σᵢⱼ wᵢⱼ·sᵢ·sⱼ + Σᵢ θᵢ·sᵢ
// where s ∈ {-1,+1} and w is symmetric, zero-diagonal
export function hopfieldEnergy(
  state:      number[],   // s ∈ {-1,+1}^N
  weights:    number[],   // flat N×N row-major (wᵢⱼ = weights[i*N+j])
  thresholds: number[]    // θᵢ
): number {
  const N = state.length;
  let E = 0;
  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      E -= 0.5 * (weights[i * N + j] ?? 0) * (state[i] ?? 0) * (state[j] ?? 0);
    }
    E += (thresholds[i] ?? 0) * (state[i] ?? 0);
  }
  return E;
}

// ── Attractor basin distance ──────────────────────────────────────────────────
function euclidean(a: number[], b: number[]): number {
  const n = Math.min(a.length, b.length);
  let sum = 0;
  for (let i = 0; i < n; i++) sum += ((a[i] ?? 0) - (b[i] ?? 0)) ** 2;
  return Math.sqrt(sum);
}

// ── Find current attractor basin ──────────────────────────────────────────────
export function findCurrentBasin(
  position:   number[],
  attractors: Attractor[]
): { index: number | null; depth: number } {
  let bestIdx:   number | null = null;
  let bestDepth  = 0;

  for (let i = 0; i < attractors.length; i++) {
    const a    = attractors[i]!;
    const dist = euclidean(position, a.position);
    if (dist < a.radius) {
      const depth = a.strength * (1 - dist / a.radius);
      if (depth > bestDepth) {
        bestDepth = depth;
        bestIdx   = i;
      }
    }
  }
  return { index: bestIdx, depth: bestDepth };
}

// ── Attractor dynamics step ────────────────────────────────────────────────────
// Position evolves toward nearest attractor basin + stochastic noise
export function attractorStep(
  position:   number[],
  velocity:   number[],
  attractors: Attractor[],
  noise:      number = 0.01,
  damping:    number = 0.1,
  dt:         number = 0.05
): { position: number[]; velocity: number[] } {
  const { index } = findCurrentBasin(position, attractors);
  const target = index !== null ? attractors[index]!.position : position;

  const N = position.length;
  const newVel   = velocity.map((v, i) => {
    const force  = ((target[i] ?? 0) - (position[i] ?? 0)) * (attractors[index!]?.strength ?? 0);
    const noiseT = (Math.random() - 0.5) * noise * 2;
    return v * (1 - damping) + (force + noiseT) * dt;
  });
  const newPos = position.map((p, i) => clamp(p + (newVel[i] ?? 0) * dt, -2, 2));
  return { position: newPos, velocity: newVel };
}

// ── Lyapunov Exponent (from AdvancedMathematicalFoundations.mo) ──────────────
// λ = lim_{T→∞} (1/T) Σₜ ln|δx(t)/δx(0)|
// Approximated from state history: positive λ → chaos, negative → stable
export function lyapunovExponent(stateHistory: number[], windowSize: number = 20): number {
  const n = stateHistory.length;
  if (n < windowSize + 1) return 0;

  const recent = stateHistory.slice(n - windowSize);
  let sumLog = 0, count = 0;
  for (let i = 1; i < recent.length; i++) {
    const prev = recent[i - 1]!, curr = recent[i]!;
    const ratio = Math.abs(curr - prev);
    if (ratio > 1e-10) {
      sumLog += Math.log(ratio);
      count++;
    }
  }
  return count > 0 ? sumLog / count : 0;
}

// ── Kaplan-Yorke dimension ─────────────────────────────────────────────────────
// D_KY = j + Σ₁ʲ λₖ / |λⱼ₊₁|
// where j is largest index with Σ₁ʲ λₖ ≥ 0
export function kaplanYorkeDimension(exponents: number[]): number {
  const sorted = [...exponents].sort((a, b) => b - a); // descending
  let cumSum = 0, j = 0;
  for (let i = 0; i < sorted.length; i++) {
    cumSum += sorted[i]!;
    if (cumSum >= 0) j = i + 1;
    else break;
  }
  if (j === 0) return 0;
  const prevSum = sorted.slice(0, j).reduce((a, b) => a + b, 0);
  const nextLambda = Math.abs(sorted[j] ?? 1e-10);
  return j + prevSum / nextLambda;
}

// ── OMNIS State Detection ─────────────────────────────────────────────────────
// OMNIS_THRESHOLD = 0.98 (from MedinaMathFoundation.mo)
// When r >= 0.98 the organism enters OMNIS: unified consciousness
export const OMNIS_THRESHOLD   = 0.98;
export const EMERGENCE_TAU     = 0.618033988749;  // Golden ratio emergence point

export function isOmnisState(r: number): boolean {
  return r >= OMNIS_THRESHOLD;
}
