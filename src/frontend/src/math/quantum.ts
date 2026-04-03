// ─── NOVA / PARALLAX — Full Quantum Math Engine ──────────────────────────────
// Full port of QuantumMath.mo:
//   Complex arithmetic, density matrix (Lindblad), von Neumann entropy,
//   Berry phase, Chern number (topological invariant),
//   Orch-OR collapse time, Zeno survival, quantum discord.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, PI, TAU } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// COMPLEX NUMBERS
// ═══════════════════════════════════════════════════════════════════════════════

export interface Cplx { re: number; im: number }

export const C0: Cplx = { re: 0, im: 0 };
export const C1: Cplx = { re: 1, im: 0 };
export const Ci: Cplx = { re: 0, im: 1 };

export function cAdd(a: Cplx, b: Cplx): Cplx { return { re: a.re + b.re, im: a.im + b.im }; }
export function cSub(a: Cplx, b: Cplx): Cplx { return { re: a.re - b.re, im: a.im - b.im }; }
export function cMul(a: Cplx, b: Cplx): Cplx {
  return { re: a.re * b.re - a.im * b.im, im: a.re * b.im + a.im * b.re };
}
export function cDiv(a: Cplx, b: Cplx): Cplx {
  const denom = b.re * b.re + b.im * b.im;
  if (denom < 1e-15) return C0;
  return { re: (a.re * b.re + a.im * b.im) / denom, im: (a.im * b.re - a.re * b.im) / denom };
}
export function cConj(a: Cplx): Cplx { return { re: a.re, im: -a.im }; }
export function cAbs(a: Cplx): number { return Math.sqrt(a.re * a.re + a.im * a.im); }
export function cAbsSq(a: Cplx): number { return a.re * a.re + a.im * a.im; }
export function cScale(a: Cplx, s: number): Cplx { return { re: a.re * s, im: a.im * s }; }
export function cPhase(a: Cplx): number { return Math.atan2(a.im, a.re); }
export function cExpI(theta: number): Cplx { return { re: Math.cos(theta), im: Math.sin(theta) }; }
export function cExp(z: Cplx): Cplx {
  const r = Math.exp(z.re);
  return { re: r * Math.cos(z.im), im: r * Math.sin(z.im) };
}
export function cLog(z: Cplx): Cplx {
  const r = cAbs(z);
  return { re: Math.log(Math.max(r, 1e-15)), im: cPhase(z) };
}

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM STATE VECTORS
// |ψ⟩ ∈ ℂⁿ, normalized: ⟨ψ|ψ⟩ = 1
// ═══════════════════════════════════════════════════════════════════════════════

export function innerProduct(psi: Cplx[], phi: Cplx[]): Cplx {
  const n = Math.min(psi.length, phi.length);
  let sum: Cplx = C0;
  for (let i = 0; i < n; i++) {
    sum = cAdd(sum, cMul(cConj(psi[i]!), phi[i]!));
  }
  return sum;
}

export function stateNorm(psi: Cplx[]): number {
  return Math.sqrt(psi.reduce((s, c) => s + cAbsSq(c), 0));
}

export function normalizeState(psi: Cplx[]): Cplx[] {
  const norm = Math.max(stateNorm(psi), 1e-15);
  return psi.map(c => cScale(c, 1 / norm));
}

// ═══════════════════════════════════════════════════════════════════════════════
// DENSITY MATRIX ρ — N×N complex matrix (flat row-major)
// Pure state: ρ = |ψ⟩⟨ψ|,  Tr(ρ²) = 1
// Mixed state: Tr(ρ²) < 1
// ═══════════════════════════════════════════════════════════════════════════════

export function matGet(m: Cplx[], n: number, i: number, j: number): Cplx {
  return m[i * n + j] ?? C0;
}
export function matSet(m: Cplx[], n: number, i: number, j: number, v: Cplx): void {
  m[i * n + j] = v;
}

export function matMul(a: Cplx[], b: Cplx[], n: number): Cplx[] {
  const out: Cplx[] = new Array(n * n).fill(C0).map(() => ({ ...C0 }));
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      let sum: Cplx = C0;
      for (let k = 0; k < n; k++) {
        sum = cAdd(sum, cMul(matGet(a, n, i, k), matGet(b, n, k, j)));
      }
      matSet(out, n, i, j, sum);
    }
  }
  return out;
}

export function matAdd(a: Cplx[], b: Cplx[]): Cplx[] {
  return a.map((v, i) => cAdd(v, b[i] ?? C0));
}

export function matDagger(m: Cplx[], n: number): Cplx[] {
  const out: Cplx[] = new Array(n * n).fill(C0).map(() => ({ ...C0 }));
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      matSet(out, n, j, i, cConj(matGet(m, n, i, j)));
    }
  }
  return out;
}

export function matTrace(m: Cplx[], n: number): Cplx {
  let sum: Cplx = C0;
  for (let i = 0; i < n; i++) sum = cAdd(sum, matGet(m, n, i, i));
  return sum;
}

export function matScale(m: Cplx[], s: Cplx): Cplx[] {
  return m.map(v => cMul(v, s));
}

/** Purity = Tr(ρ²) */
export function purity(rho: Cplx[], n: number): number {
  const rho2 = matMul(rho, rho, n);
  return matTrace(rho2, n).re;
}

/** Pure state density matrix: ρ = |ψ⟩⟨ψ| */
export function pureStateToDensity(psi: Cplx[], n: number): Cplx[] {
  const norm = normalizeState(psi);
  const rho: Cplx[] = new Array(n * n).fill(C0).map(() => ({ ...C0 }));
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      matSet(rho, n, i, j, cMul(norm[i]!, cConj(norm[j]!)));
    }
  }
  return rho;
}

/** Identity matrix */
export function identityMatrix(n: number): Cplx[] {
  const m: Cplx[] = new Array(n * n).fill(C0).map(() => ({ ...C0 }));
  for (let i = 0; i < n; i++) matSet(m, n, i, i, C1);
  return m;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LINDBLAD MASTER EQUATION
// dρ/dt = −i[H, ρ] + Σₖ γₖ(LₖρLₖ† − ½{Lₖ†Lₖ, ρ})
// Euler step approximation
// ═══════════════════════════════════════════════════════════════════════════════

function commutator(a: Cplx[], b: Cplx[], n: number): Cplx[] {
  const ab = matMul(a, b, n);
  const ba = matMul(b, a, n);
  return ab.map((v, i) => cSub(v, ba[i] ?? C0));
}

function anticommutator(a: Cplx[], b: Cplx[], n: number): Cplx[] {
  const ab = matMul(a, b, n);
  const ba = matMul(b, a, n);
  return ab.map((v, i) => cAdd(v, ba[i] ?? C0));
}

function lindbladTerm(L: Cplx[], rho: Cplx[], n: number, gamma: number): Cplx[] {
  const Ldag  = matDagger(L, n);
  const LdagL = matMul(Ldag, L, n);
  const LrhoLdag = matMul(matMul(L, rho, n), Ldag, n);
  const anticom  = anticommutator(LdagL, rho, n);
  return matAdd(LrhoLdag, matScale(anticom, { re: -0.5 * gamma, im: 0 }));
}

/** Lindblad Euler step for density matrix */
export function evolveLindblad(
  rho:   Cplx[],
  H:     Cplx[],    // Hamiltonian
  Ls:    Cplx[][],  // Lindblad operators
  n:     number,
  gamma: number,    // decoherence rate
  dt:    number
): Cplx[] {
  // Unitary part: -i[H,ρ]·dt
  const comm  = commutator(H, rho, n);
  const unitary = matScale(comm, { re: 0, im: -dt });
  let newRho = matAdd(rho, unitary);

  // Dissipative part: Σₖ γₖ·L_term·dt
  for (const L of Ls) {
    const term = lindbladTerm(L, rho, n, gamma);
    const scaled = matScale(term, { re: gamma * dt, im: 0 });
    newRho = matAdd(newRho, scaled);
  }

  // Renormalize trace
  const tr = matTrace(newRho, n);
  if (Math.abs(tr.re) > 1e-10) {
    newRho = newRho.map(v => cDiv(v, tr));
  }
  return newRho;
}

// ═══════════════════════════════════════════════════════════════════════════════
// VON NEUMANN ENTROPY
// S(ρ) = −Tr(ρ·ln ρ) = −Σᵢ λᵢ·ln λᵢ   (where λᵢ are eigenvalues)
// For diagonal density matrix, eigenvalues are diagonal elements.
// ═══════════════════════════════════════════════════════════════════════════════

/** Approximate von Neumann entropy from diagonal of density matrix */
export function vonNeumannEntropyDiag(diagonals: number[]): number {
  return -diagonals.reduce((s, lambda) => {
    if (lambda < 1e-15) return s;
    return s + lambda * Math.log(lambda);
  }, 0);
}

/** l₁ coherence measure: sum of off-diagonal magnitudes */
export function coherenceL1(rho: Cplx[], n: number): number {
  let sum = 0;
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      if (i !== j) sum += cAbs(matGet(rho, n, i, j));
    }
  }
  return sum;
}

// ═══════════════════════════════════════════════════════════════════════════════
// BERRY PHASE — Geometric phase
// φ_Berry = −Im·ln⟨ψ_prev|ψ_current⟩
// Accumulated: φ_total = Σₜ φ_Berry(t)
// ═══════════════════════════════════════════════════════════════════════════════

export function berryPhase(psiPrev: Cplx[], psiCurrent: Cplx[]): number {
  const overlap = innerProduct(psiPrev, psiCurrent);
  return -cPhase(overlap);
}

export function accumulatedBerryPhase(trajectory: Cplx[][]): number {
  let phase = 0;
  for (let i = 1; i < trajectory.length; i++) {
    phase += berryPhase(trajectory[i - 1]!, trajectory[i]!);
  }
  return phase;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CHERN NUMBER — Topological invariant
// C = (1/2π) Σ_plaquettes Im·ln(U₁U₂U₃U₄)
// Link variables: Uᵢⱼ = ⟨ψ(kᵢ)|ψ(kⱼ)⟩ / |⟨ψ(kᵢ)|ψ(kⱼ)⟩|
// ═══════════════════════════════════════════════════════════════════════════════

export function chernNumber(states: Cplx[][], gridSize: number): number {
  if (gridSize < 2 || states.length < 4) return 0;
  let totalPhase = 0;
  const n = gridSize;

  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      const s00 = states[(i     ) * n + (j     )] ?? [C1];
      const s10 = states[(i + 1) % n * n + j]     ?? [C1];
      const s11 = states[(i + 1) % n * n + (j + 1) % n] ?? [C1];
      const s01 = states[i * n + (j + 1) % n]     ?? [C1];

      // Link variables (normalized overlaps)
      const link = (a: Cplx[], b: Cplx[]): Cplx => {
        const ov = innerProduct(a, b);
        const r  = cAbs(ov);
        return r > 1e-15 ? cDiv(ov, { re: r, im: 0 }) : C1;
      };

      const U1 = link(s00, s10);
      const U2 = link(s10, s11);
      const U3 = link(s11, s01);
      const U4 = link(s01, s00);

      // Plaquette Wilson loop
      const loop = cMul(cMul(cMul(U1, U2), U3), U4);
      totalPhase += cPhase(loop);
    }
  }
  return totalPhase / (2 * PI);
}

// ═══════════════════════════════════════════════════════════════════════════════
// ORCHESTRATED OBJECTIVE REDUCTION (Orch-OR)
// Penrose-Hameroff: collapse time τ = ℏ / E_G
// E_G = energy of gravitational self-energy of superposition
// Approximated: E_G ∝ Tr(ρ²) − Tr(ρ)²/n (superposition delocalization)
// τ_collapse = HBAR / E_G (in ms, scaled for simulation)
// ═══════════════════════════════════════════════════════════════════════════════

export const HBAR_SCALE = 1.0;  // simulation scale factor

export function orchOrCollapseProbability(
  rho:  Cplx[],
  n:    number,
  dt:   number
): number {
  // E_G ∝ purity deviation from pure state
  const p    = purity(rho, n);
  const E_G  = Math.max(1 - p, 1e-6);
  const tau  = HBAR_SCALE / E_G;
  // P_collapse = 1 − exp(−dt/τ)  [Poisson decay]
  return clamp(1 - Math.exp(-dt / tau), 0, 1);
}

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM ZENO EFFECT
// P(t) = cos²(Ω·t/2) — survival probability under repeated measurements
// Frequent measurements freeze the system (P → 1 as measurement rate → ∞)
// ═══════════════════════════════════════════════════════════════════════════════

export function zenoSurvivalProbability(
  Omega:             number,   // Rabi frequency
  t:                 number,   // time
  measurementInterval: number  // τ between measurements
): number {
  if (measurementInterval <= 0) return 1.0;
  const numMeasurements = Math.floor(t / measurementInterval);
  // Per measurement: P_survive = cos²(Ω·τ/2)
  const perMeasure = Math.cos(Omega * measurementInterval / 2) ** 2;
  return Math.pow(perMeasure, numMeasurements);
}

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM DISCORD — Quantum correlations beyond entanglement
// D(A:B) = I(A:B) − C(A:B)
// I = mutual information, C = classical correlations
// Approximated for 2-qubit states using concurrence
// ═══════════════════════════════════════════════════════════════════════════════

export function quantumDiscordApprox(rho: Cplx[], n: number): number {
  if (n < 2) return 0;
  // Approximate via purity-based measure
  // D ≈ S(ρ_A) + S(ρ_B) − S(ρ_AB) + min measurement entropy
  // Simplified: D ≈ (1 − purity) / 2 for 2-qubit states
  const p = purity(rho, n);
  return clamp((1 - p) / 2, 0, 1);
}

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM SYSTEM STATE — Full simulation object
// ═══════════════════════════════════════════════════════════════════════════════

export interface QuantumSystemState {
  n:              number;    // Hilbert space dimension
  rho:            Cplx[];   // Density matrix (n×n)
  H:              Cplx[];   // Hamiltonian
  purity:         number;
  vonNeumannS:    number;   // von Neumann entropy
  coherenceL1:    number;   // l₁ coherence
  berryPhase:     number;   // accumulated Berry phase
  chernNumber:    number;
  orchOrProb:     number;   // Orch-OR collapse probability per beat
  zenoSurvival:   number;
  discord:        number;
  beat:           number;
}

export function initQuantumSystem(n: number = 4): QuantumSystemState {
  // Start in maximally mixed state (equal superposition)
  const rho = identityMatrix(n).map(v => cScale(v, 1 / n));
  // Simple Hamiltonian: diagonal with equally-spaced energies
  const H   = identityMatrix(n).map((v, i) => {
    const row = Math.floor(i / n), col = i % n;
    return row === col ? { re: row * 0.1, im: 0 } : C0;
  });
  return {
    n, rho, H,
    purity: 1 / n, vonNeumannS: Math.log(n), coherenceL1: 0,
    berryPhase: 0, chernNumber: 0, orchOrProb: 0, zenoSurvival: 1, discord: 0,
    beat: 0,
  };
}

/** Quantum system beat update */
export function quantumBeat(
  s:     QuantumSystemState,
  gamma: number = 0.01,   // decoherence rate
  dt:    number = 0.05
): QuantumSystemState {
  // Dephasing Lindblad operators: L_k = |k⟩⟨k| (σz-like for each basis state)
  const Ls: Cplx[][] = [];
  for (let k = 0; k < s.n; k++) {
    const L: Cplx[] = new Array(s.n * s.n).fill(C0).map(() => ({ ...C0 }));
    matSet(L, s.n, k, k, C1);
    Ls.push(L);
  }

  const newRho = evolveLindblad(s.rho, s.H, Ls, s.n, gamma, dt);

  // Extract diagonal eigenvalues (approx: diagonal elements)
  const diags = Array.from({ length: s.n }, (_, i) => matGet(newRho, s.n, i, i).re);

  return {
    ...s,
    rho:         newRho,
    purity:      purity(newRho, s.n),
    vonNeumannS: vonNeumannEntropyDiag(diags),
    coherenceL1: coherenceL1(newRho, s.n),
    orchOrProb:  orchOrCollapseProbability(newRho, s.n, dt),
    discord:     quantumDiscordApprox(newRho, s.n),
    beat:        s.beat + 1,
  };
}

/** Map quantum purity to sovereign signal contribution */
export function quantumToSovereign(s: QuantumSystemState): number {
  // High purity (near pure state) → higher sovereign signal
  return clamp(s.purity * 0.5 + s.vonNeumannS / Math.log(s.n + 1) * 0.3 + s.coherenceL1 * 0.2, 0, 1);
}
