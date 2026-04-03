// ─── NOVA / PARALLAX — Emergence Physics Engine ──────────────────────────────
// Full port of EmergencePhysicsEngine.mo:
//   Landau free energy, Ising model (Metropolis), Lorenz system,
//   reaction-diffusion (Turing instability), Bak-Tang-Wiesenfeld sandpile,
//   Brusselator, synergetics, emergence scoring.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, sigmoid, PI, TAU } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// LANDAU FREE ENERGY — Phase transition order parameter
// F(φ) = a₂·φ² + a₄·φ⁴ + a₆·φ⁶ − h·φ
// Second-order transition when a₂ changes sign at T_c
// ═══════════════════════════════════════════════════════════════════════════════

export interface LandauParams {
  a2: number;   // coefficient of φ² (negative below T_c)
  a4: number;   // coefficient of φ⁴ (positive for stability)
  a6: number;   // coefficient of φ⁶ (positive, prevents runaway)
  h:  number;   // external field
}

/** Landau free energy F(φ) = a₂φ² + a₄φ⁴ + a₆φ⁶ − h·φ — Full params version */
export function landauFreeEnergyFull(phi: number, p: LandauParams): number {
  return p.a2 * phi ** 2 + p.a4 * phi ** 4 + p.a6 * phi ** 6 - p.h * phi;
}

/** dF/dφ — gradient of free energy (used for gradient descent to equilibrium) */
export function landauGradient(phi: number, p: LandauParams): number {
  return 2 * p.a2 * phi + 4 * p.a4 * phi ** 3 + 6 * p.a6 * phi ** 5 - p.h;
}

/** Find equilibrium order parameter (φ* where dF/dφ = 0) by gradient descent */
export function findEquilibriumPhi(p: LandauParams, steps = 200, lr = 0.01): number {
  let phi = 0.01;  // start near zero
  for (let i = 0; i < steps; i++) {
    phi -= lr * landauGradient(phi, p);
    phi = clamp(phi, -5, 5);
  }
  return phi;
}

/** Susceptibility χ = 1 / (d²F/dφ²) at φ* — diverges at critical point */
export function landauSusceptibility(phi: number, p: LandauParams): number {
  const d2F = 2 * p.a2 + 12 * p.a4 * phi ** 2 + 30 * p.a6 * phi ** 4;
  return d2F > 1e-10 ? 1 / d2F : 1e6;
}

/** Landau params from temperature: a₂ = a(T − Tc), a₄ fixed, a₆ fixed */
export function landauFromTemperature(
  T: number, Tc: number, a: number = 1, a4: number = 1, a6: number = 0.1, h: number = 0
): LandauParams {
  return { a2: a * (T - Tc), a4, a6, h };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ISING MODEL — 2D Lattice with Metropolis algorithm
// H = −J Σ<ij> sᵢsⱼ − B Σᵢ sᵢ
// Metropolis: ΔE = 2·J·sᵢ·Σneighbors sⱼ; accept if ΔE<0 or rand<exp(−ΔE/kT)
// ═══════════════════════════════════════════════════════════════════════════════

export interface IsingState {
  spins:       number[];  // +1 or -1, flat gridW×gridH
  gridW:       number;
  gridH:       number;
  temperature: number;    // kT
  J:           number;    // exchange coupling (default 1.0)
  B:           number;    // external field
  energy:      number;
  magnetization: number;
}

export function initIsingState(gridW: number, gridH: number, temperature: number): IsingState {
  const n = gridW * gridH;
  const spins = Array.from({ length: n }, () => Math.random() > 0.5 ? 1 : -1);
  return { spins, gridW, gridH, temperature, J: 1.0, B: 0.0, energy: 0, magnetization: 0 };
}

export function isingEnergy(s: IsingState): number {
  const { spins, gridW, gridH, J, B } = s;
  let E = 0;
  for (let r = 0; r < gridH; r++) {
    for (let c = 0; c < gridW; c++) {
      const i   = r * gridW + c;
      const si  = spins[i] ?? 1;
      // Right neighbor (periodic)
      const iR  = r * gridW + ((c + 1) % gridW);
      const iD  = ((r + 1) % gridH) * gridW + c;
      E -= J * si * (spins[iR] ?? 1);
      E -= J * si * (spins[iD] ?? 1);
      E -= B * si;
    }
  }
  return E;
}

export function isingMagnetization(s: IsingState): number {
  const n = s.spins.length || 1;
  return s.spins.reduce((sum, si) => sum + si, 0) / n;
}

export function isingMetropolisStep(s: IsingState, rand: number, siteIndex: number): IsingState {
  const { spins, gridW, gridH, temperature, J, B } = s;
  const r = Math.floor(siteIndex / gridW);
  const c = siteIndex % gridW;
  const si = spins[siteIndex] ?? 1;

  // Sum of neighbors
  const up    = spins[((r - 1 + gridH) % gridH) * gridW + c] ?? 1;
  const dn    = spins[((r + 1) % gridH) * gridW + c]         ?? 1;
  const lt    = spins[r * gridW + ((c - 1 + gridW) % gridW)] ?? 1;
  const rt    = spins[r * gridW + ((c + 1) % gridW)]         ?? 1;
  const sumNbr = up + dn + lt + rt;

  const dE = 2 * J * si * sumNbr + 2 * B * si;
  const accept = dE < 0 || rand < Math.exp(-dE / Math.max(temperature, 0.001));

  if (accept) {
    const newSpins = [...spins];
    newSpins[siteIndex] = -si;
    const newS = { ...s, spins: newSpins };
    return { ...newS, energy: isingEnergy(newS), magnetization: isingMagnetization(newS) };
  }
  return s;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LORENZ SYSTEM — Deterministic chaos (σ=10, ρ=28, β=8/3)
// dx/dt = σ(y − x)
// dy/dt = x(ρ − z) − y
// dz/dt = xy − βz
// ═══════════════════════════════════════════════════════════════════════════════

export interface LorenzState {
  x:     number;
  y:     number;
  z:     number;
  sigma: number;  // 10.0
  rho:   number;  // 28.0
  beta:  number;  // 8/3
}

export function initLorenzState(): LorenzState {
  return { x: 0.1, y: 0.0, z: 0.0, sigma: 10.0, rho: 28.0, beta: 8/3 };
}

/** RK4 Lorenz integration step */
export function lorenzStep(s: LorenzState, dt: number = 0.01): LorenzState {
  const f = (x: number, y: number, z: number) => ({
    dx: s.sigma * (y - x),
    dy: x * (s.rho - z) - y,
    dz: x * y - s.beta * z,
  });

  const k1 = f(s.x, s.y, s.z);
  const k2 = f(s.x + k1.dx * dt/2, s.y + k1.dy * dt/2, s.z + k1.dz * dt/2);
  const k3 = f(s.x + k2.dx * dt/2, s.y + k2.dy * dt/2, s.z + k2.dz * dt/2);
  const k4 = f(s.x + k3.dx * dt, s.y + k3.dy * dt, s.z + k3.dz * dt);

  return {
    ...s,
    x: s.x + (k1.dx + 2*k2.dx + 2*k3.dx + k4.dx) * dt / 6,
    y: s.y + (k1.dy + 2*k2.dy + 2*k3.dy + k4.dy) * dt / 6,
    z: s.z + (k1.dz + 2*k2.dz + 2*k3.dz + k4.dz) * dt / 6,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// REACTION-DIFFUSION — Turing Pattern Formation
// ∂u/∂t = D_u·∇²u + f(u,v)
// ∂v/∂t = D_v·∇²v + g(u,v)
// Turing instability when D_v/D_u >> 1 (diffusion-driven instability)
// ═══════════════════════════════════════════════════════════════════════════════

export interface RDState {
  u:   number[];   // activator concentration, flat gridSize×gridSize
  v:   number[];   // inhibitor concentration
  Du:  number;     // activator diffusion coefficient
  Dv:  number;     // inhibitor diffusion coefficient (Dv >> Du for Turing)
  gridSize: number;
  a:   number;     // reaction parameter
  b:   number;     // reaction parameter
}

export function initRDState(gridSize: number): RDState {
  const n = gridSize * gridSize;
  return {
    u:   Array.from({ length: n }, () => 0.5 + (Math.random() - 0.5) * 0.01),
    v:   Array.from({ length: n }, () => 0.25 + (Math.random() - 0.5) * 0.01),
    Du:  0.16, Dv: 0.08, gridSize,
    a:   0.035, b: 0.065,
  };
}

/** Discrete Laplacian (5-point stencil, periodic boundary) */
function laplacian2D(field: number[], gridSize: number, i: number, j: number): number {
  const idx   = (r: number, c: number) => ((r + gridSize) % gridSize) * gridSize + ((c + gridSize) % gridSize);
  const center = field[idx(i, j)]     ?? 0;
  const up     = field[idx(i-1, j)]   ?? 0;
  const dn     = field[idx(i+1, j)]   ?? 0;
  const lt     = field[idx(i, j-1)]   ?? 0;
  const rt     = field[idx(i, j+1)]   ?? 0;
  return up + dn + lt + rt - 4 * center;
}

/** Gray-Scott reaction-diffusion step */
export function rdStep(s: RDState, dt: number = 1.0): RDState {
  const { u, v, Du, Dv, gridSize, a, b } = s;
  const newU = new Array(u.length).fill(0) as number[];
  const newV = new Array(v.length).fill(0) as number[];

  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      const idx = i * gridSize + j;
      const ui  = u[idx] ?? 0;
      const vi  = v[idx] ?? 0;
      const uvv = ui * vi * vi;

      const lapU = laplacian2D(u, gridSize, i, j);
      const lapV = laplacian2D(v, gridSize, i, j);

      // Gray-Scott: F(u,v) = -u·v² + a·(1-u), G(u,v) = u·v² − (a+b)·v
      newU[idx] = clamp(ui + (Du * lapU - uvv + a * (1 - ui)) * dt, 0, 1);
      newV[idx] = clamp(vi + (Dv * lapV + uvv - (a + b) * vi) * dt, 0, 1);
    }
  }
  return { ...s, u: newU, v: newV };
}

/** Turing instability check: Dv/Du > (1 + sqrt(a/b))² */
export function isTuringUnstable(s: RDState): boolean {
  const threshold = (1 + Math.sqrt(s.a / Math.max(s.b, 1e-6))) ** 2;
  return s.Dv / Math.max(s.Du, 1e-6) > threshold;
}

// ═══════════════════════════════════════════════════════════════════════════════
// BTW SANDPILE MODEL — Self-organized criticality
// Sites have heights h_i. Topple when h_i >= threshold (z_c = 4 for 2D).
// Avalanche = cascade of topples. P(s) ~ s^{-τ}, τ ≈ 1.27 in 2D.
// ═══════════════════════════════════════════════════════════════════════════════

export interface SandpileState {
  heights:   number[];  // integer heights, flat gridSize×gridSize
  gridSize:  number;
  threshold: number;    // toppling threshold z_c (default 4)
  totalGrains: number;
  totalAvalanches: number;
}

export function initSandpile(gridSize: number): SandpileState {
  return {
    heights:   new Array(gridSize * gridSize).fill(0),
    gridSize, threshold: 4,
    totalGrains: 0, totalAvalanches: 0,
  };
}

export function sandpileAddGrain(s: SandpileState, siteIndex: number): SandpileState {
  const heights = [...s.heights];
  heights[siteIndex] = (heights[siteIndex] ?? 0) + 1;
  return sandpileRelax({ ...s, heights, totalGrains: s.totalGrains + 1 });
}

function sandpileRelax(s: SandpileState): SandpileState {
  const { gridSize, threshold } = s;
  const heights = [...s.heights];
  let avalanches = s.totalAvalanches;
  let active = true;

  while (active) {
    active = false;
    for (let r = 0; r < gridSize; r++) {
      for (let c = 0; c < gridSize; c++) {
        const idx = r * gridSize + c;
        if ((heights[idx] ?? 0) >= threshold) {
          heights[idx] = (heights[idx] ?? 0) - 4;
          if (r > 0)            heights[(r-1) * gridSize + c] = (heights[(r-1) * gridSize + c] ?? 0) + 1;
          if (r < gridSize - 1) heights[(r+1) * gridSize + c] = (heights[(r+1) * gridSize + c] ?? 0) + 1;
          if (c > 0)            heights[r * gridSize + (c-1)] = (heights[r * gridSize + (c-1)] ?? 0) + 1;
          if (c < gridSize - 1) heights[r * gridSize + (c+1)] = (heights[r * gridSize + (c+1)] ?? 0) + 1;
          active = true;
          avalanches++;
        }
      }
    }
  }
  return { ...s, heights, totalAvalanches: avalanches };
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMERGENCE SCORE — Composite metric
// E = w₁·r + w₂·syncEntropy + w₃·magnetization + w₄·phiEquil + w₅·(1-lorentzNorm)
// ═══════════════════════════════════════════════════════════════════════════════

export interface EmergenceInputs {
  kuramotoR:     number;   // Kuramoto order ∈ [0,1]
  syncEntropy:   number;   // synchronization entropy ∈ [0,1]
  magnetization: number;   // |Ising magnetization| ∈ [0,1]
  phiEquil:      number;   // |Landau equilibrium φ*| normalized ∈ [0,1]
  lorenzNorm:    number;   // |Lorenz (x,y,z)|/60 normalized ∈ [0,1] (higher=chaotic)
}

export function computeEmergenceScore(inp: EmergenceInputs): number {
  return clamp(
    0.30 * inp.kuramotoR +
    0.20 * inp.syncEntropy +
    0.20 * Math.abs(inp.magnetization) +
    0.15 * inp.phiEquil +
    0.15 * (1 - inp.lorenzNorm),   // low chaos → higher emergence score
    0, 1
  );
}

export function classifyEmergence(score: number): 'weak' | 'strong' | 'radical' {
  if (score >= 0.80) return 'radical';
  if (score >= 0.50) return 'strong';
  return 'weak';
}

// ═══════════════════════════════════════════════════════════════════════════════
// BRUSSELATOR — Chemical oscillator (limit cycle attractor)
// du/dt = a − (b+1)u + u²v + Du·∇²u
// dv/dt = bu − u²v + Dv·∇²v
// Oscillates when b > 1 + a²
// ═══════════════════════════════════════════════════════════════════════════════

export interface BrusselatorState {
  u:   number[];
  v:   number[];
  a:   number;  // parameter (source rate)
  b:   number;  // parameter (conversion rate, b > 1+a² for oscillation)
  Du:  number;
  Dv:  number;
  gridSize: number;
}

export function initBrusselator(gridSize: number, a = 1.0, b = 3.0): BrusselatorState {
  const n = gridSize * gridSize;
  return {
    u: Array.from({ length: n }, () => a + (Math.random() - 0.5) * 0.05),
    v: Array.from({ length: n }, () => b / a + (Math.random() - 0.5) * 0.05),
    a, b, Du: 0.5, Dv: 4.0, gridSize,
  };
}

export function brusselatorStep(s: BrusselatorState, dt: number = 0.02): BrusselatorState {
  const { u, v, a, b, Du, Dv, gridSize } = s;
  const newU = new Array(u.length).fill(0) as number[];
  const newV = new Array(v.length).fill(0) as number[];

  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      const idx = i * gridSize + j;
      const ui  = u[idx] ?? a;
      const vi  = v[idx] ?? b / a;
      const uv2 = ui * ui * vi;
      newU[idx] = clamp(ui + (a - (b + 1) * ui + uv2 + Du * laplacian2D(u, gridSize, i, j)) * dt, 0, 20);
      newV[idx] = clamp(vi + (b * ui - uv2 + Dv * laplacian2D(v, gridSize, i, j)) * dt, 0, 20);
    }
  }
  return { ...s, u: newU, v: newV };
}

/** Check Brusselator oscillation condition: b > 1 + a² */
export function brusselatorOscillates(s: BrusselatorState): boolean {
  return s.b > 1 + s.a ** 2;
}
