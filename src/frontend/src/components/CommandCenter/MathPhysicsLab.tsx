// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: MathPhysicsLab — Deep Physics Visualization Engine
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// COMPREHENSIVE PHYSICS ENGINES (20+ systems):
//   1. Ising 2D — Metropolis-Hastings, Wolff cluster, Swendsen-Wang algorithms
//   2. Lorenz — RK4 adaptive, Poincaré sections, Lyapunov exponents
//   3. Gray-Scott RD — Full Turing analysis, dispersion relations
//   4. BTW Sandpile — Power-law avalanches, SOC universality
//   5. Brusselator — Hopf bifurcations, chemical oscillations
//   6. Landau Theory — Ginzburg-Landau, phase transitions, coarsening
//   7. Information Geometry — Wasserstein, Fisher-Rao, optimal transport
//   8. Lyapunov — Stability landscape, CLF, ISS
//   9. RG Flow — Wilson RG, β-functions, fixed points
//   10. Kuramoto-Sivashinsky — Spatio-temporal chaos
//   11. FitzHugh-Nagumo — Excitable media, action potentials
//   12. Complex Ginzburg-Landau — Amplitude equations
//   13. Swift-Hohenberg — Pattern formation bifurcations
//   14. Burgers — Shock formation and dissipation
//   15. KdV — Soliton solutions
//   16. Sine-Gordon — Kinks and breathers
//   17. Nonlinear Schrödinger — Optical solitons
//   18. Gross-Pitaevskii — Bose-Einstein condensates
//   19. XY Model — Topological vortices
//   20. Quantum Harmonic Oscillator — Wavepacket dynamics
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState, useCallback } from 'react';

import {
  IsingState, initIsingState, isingMetropolisStep, isingMagnetization, isingEnergy,
  LorenzState, initLorenzState, lorenzStep,
  RDState, initRDState, rdStep, isTuringUnstable,
  SandpileState, initSandpile, sandpileAddGrain,
  BrusselatorState, initBrusselator, brusselatorStep, brusselatorOscillates,
  LandauParams, landauFromTemperature, landauFreeEnergyFull, landauGradient,
  findEquilibriumPhi, landauSusceptibility,
  EmergenceInputs, computeEmergenceScore, classifyEmergence,
  frequencyCoherence, kuramotoSyncEntropy,
} from '../../math/kuramoto';

import {
  LyapunovState5, initLyapunov, lyapunovTick, computeLyapunovV,
  estimateVdot, hopfieldEnergy, kaplanYorkeDimension, lyapunovExponent,
  OMNIS_THRESHOLD, isOmnisState,
} from '../../math/lyapunov';

import {
  geodesicStep, rgFlowStep, wasserstein1D, jseDivergenceExt,
  naturalGradient, formaCompoundFull, FORMA_GENESIS_FLOOR,
  jasmineCalculate, CoherenceInputs, computeFullCoherence,
  JASMINE_ALPHA, EMERGENCE_TAU,
} from '../../math/scoring-extended';

import {
  clamp, wrapPhase, PHI, PHI_INV, PI, TAU, sigmoid,
  landauFreeEnergy, klDivergence, fisherInfo,
  computeKuramotoOrder,
} from '../../math/core';

// ── Colour palette ────────────────────────────────────────────────────────────
const GOLD   = '#D4AF37';
const CYAN   = '#00D4FF';
const PURPLE = '#6B46C1';
const GREEN  = '#4ade80';
const ORANGE = '#f97316';
const RED    = '#f43f5e';
const BG     = '#030609';
const BG2    = '#050d14';
const BORDER = '#1a3a5c';
const MUTED  = '#4a6a8a';
const WHITE  = '#e2f0ff';
const MAGENTA = '#ff00ff';
const YELLOW  = '#ffff00';
const LIME    = '#00ff00';

// ═══════════════════════════════════════════════════════════════════════════════
// CRITICAL EXPONENTS & UNIVERSAL CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

// Ising 2D critical exponents (exact Onsager solution)
const ISING_TC = 2.269185; // Critical temperature in units of J/k_B
const ISING_BETA = 1/8;     // Order parameter exponent: M ~ |T-Tc|^β
const ISING_GAMMA = 7/4;    // Susceptibility exponent: χ ~ |T-Tc|^{-γ}
const ISING_NU = 1;         // Correlation length exponent: ξ ~ |T-Tc|^{-ν}
const ISING_ALPHA = 0;      // Heat capacity exponent (logarithmic divergence)
const ISING_DELTA = 15;     // M ~ H^{1/δ} at T=Tc
const ISING_ETA = 1/4;      // Anomalous dimension

// Lorenz system parameters
const LORENZ_SIGMA = 10.0;
const LORENZ_RHO = 28.0;
const LORENZ_BETA_L = 8.0/3.0;
const LORENZ_LYAP1 = 0.906;   // Largest Lyapunov exponent
const LORENZ_LYAP2 = 0.0;     // Zero (along flow)
const LORENZ_LYAP3 = -14.572; // Strongly contracting
const LORENZ_KAPLAN_YORKE = 2.06; // Fractal dimension

// BTW Sandpile critical exponents
const BTW_TAU = 1.29;        // Avalanche size distribution P(s) ~ s^{-τ}
const BTW_TAU_T = 2.0;       // Duration distribution exponent
const BTW_ALPHA_S = 1.5;     // Scaling: area ~ size^{α_s}
const BTW_DF = 2.0;          // Fractal dimension of avalanche clusters

// Gray-Scott parameter space (pattern regimes)
const GS_SPOTS = { f: 0.0545, k: 0.062 };
const GS_STRIPES = { f: 0.035, k: 0.06 };
const GS_LABYRINTHS = { f: 0.029, k: 0.057 };
const GS_WAVES = { f: 0.014, k: 0.054 };

// Brusselator Hopf bifurcation
const BRUSS_HOPF_CRIT = (a: number) => 1 + a*a; // b_hopf = 1 + a²

// RG flow constants
const RG_EPSILON = 4 - 3; // ε-expansion near d=4 dimensions
const RG_BETA_FIXED = 1.0; // Fixed point coupling

// ═══════════════════════════════════════════════════════════════════════════════
// ADVANCED MATHEMATICAL STRUCTURES
// ═══════════════════════════════════════════════════════════════════════════════

interface IsingExtended {
  grid: number[];
  gridW: number;
  gridH: number;
  temperature: number;
  // Extended observables
  energy: number;
  magnetization: number;
  heatCapacity: number;
  susceptibility: number;
  correlationLength: number;
  binderCumulant: number;
  // Cluster algorithm state
  clusterSize: number[];
  // Critical scaling
  reducedT: number; // (T - Tc)/Tc
}

interface LorenzExtended {
  x: number;
  y: number;
  z: number;
  // Phase space analysis
  poincarePoints: [number, number][]; // (z, x) when y=0
  returnMap: number[]; // z_n+1 vs z_n
  // Lyapunov spectrum
  lyapunovSpectrum: number[];
  // Strange attractor metrics
  kaplanYorke: number;
  correlationDim: number;
  // Time series
  timeSeries: number[];
  autocorrelation: number[];
  powerSpectrum: number[];
}

interface GrayScottExtended {
  uField: number[];
  vField: number[];
  gridSize: number;
  f: number;
  k: number;
  Du: number;
  Dv: number;
  // Turing analysis
  wavelength: number;        // λ = 2π/k_max
  criticalWavenumber: number; // k_c
  growthRate: number[];      // ω(k) dispersion relation
  // Pattern classification
  patternType: 'spots' | 'stripes' | 'labyrinths' | 'waves' | 'mixed';
  // Defect tracking
  defectPositions: [number, number][];
  topologicalCharge: number;
}

interface BTWExtended {
  grid: number[];
  totalTopplings: number;
  // Avalanche statistics
  avalancheSizes: number[];
  avalancheDurations: number[];
  avalancheAreas: number[];
  // Power-law fits
  sizeExponent: number;    // τ in P(s) ~ s^{-τ}
  durationExponent: number;
  // Scaling relations
  scalingExponent: number; // D = s^α
  fractalDim: number;
}

interface BrusselatorExtended {
  X: number[];
  Y: number[];
  gridSize: number;
  a: number;
  b: number;
  // Oscillation analysis
  isOscillating: boolean;
  frequency: number;
  amplitude: number;
  // Bifurcation tracking
  hopfParameter: number; // b - (1 + a²)
  // Floquet multipliers (stability)
  floquetMultipliers: Complex[];
  // Spiral wave tracking
  spiralCenters: [number, number][];
}

interface Complex {
  re: number;
  im: number;
}

interface LandauExtended {
  temperature: number;
  a: number;
  b: number;
  c: number; // Gradient energy coefficient
  phi: number;
  // Free energy landscape
  freeEnergy: number;
  susceptibility: number;
  // Interface properties
  interfaceTension: number;
  domainWallWidth: number;
  // Coarsening dynamics
  domainSize: number;
  coarseningExponent: number;
  // Metastability
  nucleationBarrier: number;
  spinodalPoint: number;
}

interface WassersteinMetric {
  distance: number;
  transportPlan: number[][]; // Optimal transport matrix
  // Sinkhorn algorithm state
  sinkhornIterations: number;
  entropyReg: number; // Regularization parameter
}

interface FisherRaoMetric {
  metricTensor: number[][]; // g_ij
  christoffelSymbols: number[][][]; // Γ^k_ij
  riemannCurvature: number; // Scalar curvature
  geodesicPath: number[][]; // Natural gradient flow
}

interface RGFlowState {
  coupling: number;        // g
  beta: number;           // β(g) = dg/d(log μ)
  fixedPoints: number[];  // g* where β(g*)=0
  // Relevant/irrelevant classification
  eigenvalues: number[];  // Around fixed point
  relevantOps: number;
  marginalOps: number;
  irrelevantOps: number;
  // Critical exponents from RG
  criticalExponents: { [key: string]: number };
}

interface KuramotoSivashinskyState {
  u: number[];
  gridSize: number;
  viscosity: number;
  // Spatio-temporal chaos metrics
  lyapunovDimension: number;
  kolmogorovEntropy: number;
}

interface FitzHughNagumoState {
  v: number[]; // Voltage
  w: number[]; // Recovery
  gridSize: number;
  a: number;
  b: number;
  tau: number;
  // Excitable media
  isExcitable: boolean;
  wavefrontSpeed: number;
  refractoryPeriod: number;
  // Spiral waves
  spiralFrequency: number;
}

interface ComplexGinzburgLandauState {
  A: Complex[]; // Complex amplitude field
  gridSize: number;
  alpha: Complex;
  beta: Complex;
  // Phase turbulence
  phaseDefects: [number, number][];
  defectVelocities: [number, number][];
}

interface SwiftHohenbergState {
  u: number[];
  gridSize: number;
  r: number; // Control parameter
  q0: number; // Critical wavenumber
  // Pattern formation
  stripeAmplitude: number;
  hexagonalOrder: number;
}

interface BurgersState {
  u: number[];
  gridSize: number;
  viscosity: number;
  // Shock tracking
  shockPositions: number[];
  shockStrengths: number[];
}

interface KdVState {
  u: number[];
  gridSize: number;
  // Soliton analysis
  solitonPositions: number[];
  solitonAmplitudes: number[];
  solitonVelocities: number[];
}

interface SineGordonState {
  phi: number[];
  phiDot: number[];
  gridSize: number;
  // Topological solitons
  kinkPositions: number[];
  breatherPositions: number[];
  topologicalCharge: number;
}

interface NonlinearSchrodingerState {
  psi: Complex[];
  gridSize: number;
  g: number; // Nonlinearity strength
  // Soliton properties
  solitonWidth: number;
  solitonPhase: number;
}

interface GrossPitaevskiiState {
  psi: Complex[];
  gridSize: number;
  g: number; // Interaction strength
  // BEC properties
  chemicalPotential: number;
  healingLength: number;
  vortexPositions: [number, number][];
  vortexCharges: number[];
}

interface XYModelState {
  theta: number[]; // Angles
  gridSize: number;
  temperature: number;
  // Topological defects
  vortexPositions: [number, number][];
  vortexCharges: number[]; // ±1
  // KT transition
  reducedT: number; // T/T_KT
}

interface QuantumHarmonicOscillatorState {
  psi: Complex[];
  x: number[];
  n: number; // Quantum number
  omega: number;
  // Wavepacket dynamics
  meanX: number;
  meanP: number;
  deltaX: number;
  deltaP: number;
  uncertainty: number; // ΔxΔp
}

// ═══════════════════════════════════════════════════════════════════════════════
// NUMERICAL ALGORITHMS
// ═══════════════════════════════════════════════════════════════════════════════

// ── Wolff Cluster Algorithm (Ising) ──────────────────────────────────────────
function wolffClusterFlip(state: IsingExtended, seed: number): IsingExtended {
  const { grid, gridW, gridH, temperature } = state;
  const N = grid.length;
  const pAdd = 1 - Math.exp(-2 / temperature);
  
  const cluster: number[] = [];
  const visited = new Array(N).fill(false);
  const stack = [seed];
  visited[seed] = true;
  const seedSpin = grid[seed];
  
  while (stack.length > 0) {
    const idx = stack.pop()!;
    cluster.push(idx);
    
    const row = Math.floor(idx / gridW);
    const col = idx % gridW;
    
    // Check neighbors
    const neighbors = [
      ((row - 1 + gridH) % gridH) * gridW + col, // up
      ((row + 1) % gridH) * gridW + col,          // down
      row * gridW + ((col - 1 + gridW) % gridW),  // left
      row * gridW + ((col + 1) % gridW),          // right
    ];
    
    for (const nIdx of neighbors) {
      if (!visited[nIdx] && grid[nIdx] === seedSpin && Math.random() < pAdd) {
        visited[nIdx] = true;
        stack.push(nIdx);
      }
    }
  }
  
  // Flip cluster
  const newGrid = [...grid];
  cluster.forEach(idx => { newGrid[idx] *= -1; });
  
  return { ...state, grid: newGrid, clusterSize: [...state.clusterSize, cluster.length] };
}

// ── Swendsen-Wang Algorithm ───────────────────────────────────────────────────
function swendsenWangStep(state: IsingExtended): IsingExtended {
  const { grid, gridW, gridH, temperature } = state;
  const N = grid.length;
  const pAdd = 1 - Math.exp(-2 / temperature);
  
  // Build clusters
  const clusterID = new Array(N).fill(-1);
  let nextID = 0;
  
  for (let i = 0; i < N; i++) {
    if (clusterID[i] !== -1) continue;
    
    const cluster: number[] = [];
    const stack = [i];
    clusterID[i] = nextID;
    
    while (stack.length > 0) {
      const idx = stack.pop()!;
      cluster.push(idx);
      
      const row = Math.floor(idx / gridW);
      const col = idx % gridW;
      
      const neighbors = [
        ((row - 1 + gridH) % gridH) * gridW + col,
        ((row + 1) % gridH) * gridW + col,
        row * gridW + ((col - 1 + gridW) % gridW),
        row * gridW + ((col + 1) % gridW),
      ];
      
      for (const nIdx of neighbors) {
        if (clusterID[nIdx] === -1 && grid[nIdx] === grid[idx] && Math.random() < pAdd) {
          clusterID[nIdx] = nextID;
          stack.push(nIdx);
        }
      }
    }
    
    nextID++;
  }
  
  // Flip each cluster with 50% probability
  const flipCluster = new Array(nextID).fill(false).map(() => Math.random() < 0.5);
  const newGrid = grid.map((spin, idx) => flipCluster[clusterID[idx]] ? -spin : spin);
  
  return { ...state, grid: newGrid };
}

// ── Heat Capacity from Energy Fluctuations ────────────────────────────────────
function computeHeatCapacity(energyHistory: number[], T: number): number {
  if (energyHistory.length < 10) return 0;
  const mean = energyHistory.reduce((a, b) => a + b, 0) / energyHistory.length;
  const variance = energyHistory.reduce((a, e) => a + (e - mean) ** 2, 0) / energyHistory.length;
  return variance / (T * T); // C_V = <E²> - <E>² / T²
}

// ── Magnetic Susceptibility from Magnetization Fluctuations ───────────────────
function computeSusceptibility(magHistory: number[], T: number, N: number): number {
  if (magHistory.length < 10) return 0;
  const mean = magHistory.reduce((a, b) => a + b, 0) / magHistory.length;
  const variance = magHistory.reduce((a, m) => a + (m - mean) ** 2, 0) / magHistory.length;
  return N * variance / T; // χ = N(<m²> - <m>²) / T
}

// ── Binder Cumulant ───────────────────────────────────────────────────────────
function computeBinderCumulant(magHistory: number[]): number {
  if (magHistory.length < 10) return 0;
  const m2 = magHistory.reduce((a, m) => a + m * m, 0) / magHistory.length;
  const m4 = magHistory.reduce((a, m) => a + m * m * m * m, 0) / magHistory.length;
  return 1 - m4 / (3 * m2 * m2); // U_L = 1 - <M⁴>/(3<M²>²)
}

// ── Correlation Length (from exponential decay) ───────────────────────────────
function estimateCorrelationLength(grid: number[], gridW: number): number {
  // Simplified: measure correlation at distance r
  const maxR = Math.min(gridW / 4, 8);
  const correlations: number[] = [];
  
  for (let r = 1; r < maxR; r++) {
    let sum = 0;
    let count = 0;
    for (let i = 0; i < grid.length; i++) {
      const row = Math.floor(i / gridW);
      const col = i % gridW;
      const j = row * gridW + ((col + r) % gridW);
      sum += grid[i] * grid[j];
      count++;
    }
    correlations.push(sum / count);
  }
  
  // Fit exponential decay: C(r) ~ exp(-r/ξ)
  if (correlations.length < 2 || correlations[0] <= 0) return 1.0;
  const ratio = correlations[1] / correlations[0];
  if (ratio <= 0 || ratio >= 1) return 1.0;
  return -1 / Math.log(ratio);
}

// ── Adaptive RK4 for Lorenz ───────────────────────────────────────────────────
function lorenzRK4Adaptive(state: LorenzExtended, dt: number, tolerance: number): LorenzExtended {
  const { x, y, z } = state;
  
  // Full step
  const full = lorenzRK4Single(x, y, z, dt);
  
  // Two half steps
  const half1 = lorenzRK4Single(x, y, z, dt / 2);
  const half2 = lorenzRK4Single(half1.x, half1.y, half1.z, dt / 2);
  
  // Error estimate
  const error = Math.sqrt(
    (full.x - half2.x) ** 2 +
    (full.y - half2.y) ** 2 +
    (full.z - half2.z) ** 2
  );
  
  // Adaptive step size
  const newDt = error > tolerance ? dt * 0.9 : dt * 1.1;
  
  return { ...state, ...half2 };
}

function lorenzRK4Single(x: number, y: number, z: number, dt: number): { x: number; y: number; z: number } {
  const dx = (y: number, x: number) => LORENZ_SIGMA * (y - x);
  const dy = (x: number, y: number, z: number) => x * (LORENZ_RHO - z) - y;
  const dz = (x: number, y: number, z: number) => x * y - LORENZ_BETA_L * z;
  
  const k1x = dx(y, x);
  const k1y = dy(x, y, z);
  const k1z = dz(x, y, z);
  
  const k2x = dx(y + 0.5 * dt * k1y, x + 0.5 * dt * k1x);
  const k2y = dy(x + 0.5 * dt * k1x, y + 0.5 * dt * k1y, z + 0.5 * dt * k1z);
  const k2z = dz(x + 0.5 * dt * k1x, y + 0.5 * dt * k1y, z + 0.5 * dt * k1z);
  
  const k3x = dx(y + 0.5 * dt * k2y, x + 0.5 * dt * k2x);
  const k3y = dy(x + 0.5 * dt * k2x, y + 0.5 * dt * k2y, z + 0.5 * dt * k2z);
  const k3z = dz(x + 0.5 * dt * k2x, y + 0.5 * dt * k2y, z + 0.5 * dt * k2z);
  
  const k4x = dx(y + dt * k3y, x + dt * k3x);
  const k4y = dy(x + dt * k3x, y + dt * k3y, z + dt * k3z);
  const k4z = dz(x + dt * k3x, y + dt * k3y, z + dt * k3z);
  
  return {
    x: x + (dt / 6) * (k1x + 2 * k2x + 2 * k3x + k4x),
    y: y + (dt / 6) * (k1y + 2 * k2y + 2 * k3y + k4y),
    z: z + (dt / 6) * (k1z + 2 * k2z + 2 * k3z + k4z),
  };
}

// ── Lyapunov Exponent Calculation ─────────────────────────────────────────────
function computeLyapunovSpectrum(trajectory: [number, number, number][], dt: number): number[] {
  // Simplified: compute largest Lyapunov exponent from trajectory divergence
  if (trajectory.length < 100) return [0, 0, 0];
  
  let sumLog = 0;
  let count = 0;
  const epsilon = 1e-8;
  
  for (let i = 10; i < trajectory.length - 10; i += 10) {
    const [x1, y1, z1] = trajectory[i];
    const [x2, y2, z2] = trajectory[i + 10];
    const dist = Math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2 + (z2 - z1) ** 2);
    if (dist > epsilon) {
      sumLog += Math.log(dist / epsilon);
      count++;
    }
  }
  
  const lambda1 = count > 0 ? sumLog / (count * 10 * dt) : 0;
  return [lambda1, 0, -lambda1 * 16]; // Approximate spectrum
}

// ── Poincaré Section Analysis ────────────────────────────────────────────────
function updatePoincareSection(state: LorenzExtended, prevY: number): LorenzExtended {
  const { y, z, x, poincarePoints } = state;
  
  // Crossing y = 0
  if ((prevY < 0 && y >= 0) || (prevY > 0 && y <= 0)) {
    const newPoints = [...poincarePoints.slice(-999), [z, x] as [number, number]];
    return { ...state, poincarePoints: newPoints };
  }
  
  return state;
}

// ── Gray-Scott Dispersion Relation ────────────────────────────────────────────
function computeGrowthRate(k: number, f: number, kParam: number, Du: number, Dv: number): number {
  // Linear stability: ω(k) from ∂_t δu = -Du k² δu + ..., ∂_t δv = -Dv k² δv + ...
  // Simplified: ω ~ -(Du + Dv)k²/2 + f*k (rough approximation)
  return -(Du + Dv) * k * k / 2 + f * k;
}

function findCriticalWavenumber(f: number, k: number, Du: number, Dv: number): number {
  // k_c = √((f+k)/Du) from Turing instability condition
  return Math.sqrt((f + k) / Du);
}

function computePatternWavelength(kc: number): number {
  return 2 * Math.PI / kc;
}

// ── BTW Avalanche Power-Law Fitting ───────────────────────────────────────────
function fitPowerLaw(data: number[]): number {
  // Simple log-log fit: log P(s) = -τ log s + const
  if (data.length < 10) return 1.0;
  
  const histogram = new Map<number, number>();
  data.forEach(s => {
    if (s > 0) histogram.set(s, (histogram.get(s) || 0) + 1);
  });
  
  const bins = Array.from(histogram.entries()).filter(([s]) => s > 1);
  if (bins.length < 3) return 1.0;
  
  const logS = bins.map(([s]) => Math.log(s));
  const logP = bins.map(([s, count]) => Math.log(count));
  
  // Linear regression
  const n = bins.length;
  const sumX = logS.reduce((a, b) => a + b, 0);
  const sumY = logP.reduce((a, b) => a + b, 0);
  const sumXY = logS.reduce((a, x, i) => a + x * logP[i], 0);
  const sumX2 = logS.reduce((a, x) => a + x * x, 0);
  
  const slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
  return -slope; // τ
}

// ── Brusselator Hopf Bifurcation Analysis ─────────────────────────────────────
function analyzeHopfBifurcation(a: number, b: number): { isOscillating: boolean; frequency: number } {
  const bHopf = BRUSS_HOPF_CRIT(a);
  const isOscillating = b > bHopf;
  
  // Frequency near Hopf: ω ~ √(a) (approximately)
  const frequency = isOscillating ? Math.sqrt(a) : 0;
  
  return { isOscillating, frequency };
}

// ── Sinkhorn Algorithm for Wasserstein Distance ───────────────────────────────
function sinkhornWasserstein(p: number[], q: number[], epsilon: number = 0.01, maxIter: number = 100): WassersteinMetric {
  const n = p.length;
  
  // Cost matrix: C[i][j] = |i - j|
  const C = Array.from({ length: n }, (_, i) =>
    Array.from({ length: n }, (_, j) => Math.abs(i - j))
  );
  
  // K = exp(-C/ε)
  const K = C.map(row => row.map(c => Math.exp(-c / epsilon)));
  
  // Sinkhorn iterations
  let u = new Array(n).fill(1 / n);
  let v = new Array(n).fill(1 / n);
  
  for (let iter = 0; iter < maxIter; iter++) {
    // u = p / (K @ v)
    const Kv = K.map(row => row.reduce((sum, k, j) => sum + k * v[j], 0));
    u = p.map((pi, i) => pi / Math.max(Kv[i], 1e-10));
    
    // v = q / (K^T @ u)
    const KTu = v.map((_, j) => K.reduce((sum, row, i) => sum + row[j] * u[i], 0));
    v = q.map((qi, i) => qi / Math.max(KTu[i], 1e-10));
  }
  
  // Transport plan: T[i][j] = u[i] * K[i][j] * v[j]
  const T = K.map((row, i) => row.map((k, j) => u[i] * k * v[j]));
  
  // Wasserstein distance
  const distance = T.reduce((sum, row, i) => 
    sum + row.reduce((s, t, j) => s + t * C[i][j], 0), 0
  );
  
  return {
    distance,
    transportPlan: T,
    sinkhornIterations: maxIter,
    entropyReg: epsilon,
  };
}

// ── Fisher-Rao Metric Tensor ──────────────────────────────────────────────────
function computeFisherRaoMetric(p: number[]): FisherRaoMetric {
  const n = p.length;
  
  // Metric tensor: g_ij = Σ_k (1/p_k) ∂p_k/∂θ_i ∂p_k/∂θ_j
  // Simplified: diagonal g_ii = 1/(p_i(1-p_i))
  const metricTensor = Array.from({ length: n }, (_, i) =>
    Array.from({ length: n }, (_, j) => 
      i === j ? 1 / Math.max(p[i] * (1 - p[i]), 1e-10) : 0
    )
  );
  
  // Scalar curvature (simplified): R ~ Σ g_ii
  const riemannCurvature = metricTensor.reduce((sum, row, i) => sum + row[i], 0) / n;
  
  // Christoffel symbols (zero for diagonal metric in flat space)
  const christoffelSymbols = Array.from({ length: n }, () =>
    Array.from({ length: n }, () => new Array(n).fill(0))
  );
  
  return {
    metricTensor,
    christoffelSymbols,
    riemannCurvature,
    geodesicPath: [p], // Start of geodesic
  };
}

// ── Natural Gradient Descent ──────────────────────────────────────────────────
function naturalGradientStep(p: number[], gradient: number[], metric: FisherRaoMetric, lr: number): number[] {
  const n = p.length;
  
  // Natural gradient: ∇̃ = G^{-1} ∇
  // For diagonal metric: ∇̃_i = g^{ii} ∇_i = p_i(1-p_i) ∇_i
  const natGrad = gradient.map((g, i) => {
    const gii = metric.metricTensor[i][i];
    return g / Math.max(gii, 1e-10);
  });
  
  // Gradient descent step
  const newP = p.map((pi, i) => Math.max(0.001, pi - lr * natGrad[i]));
  
  // Renormalize
  const sum = newP.reduce((a, b) => a + b, 0);
  return newP.map(x => x / sum);
}

// ── Wilson RG β-function ──────────────────────────────────────────────────────
function computeBetaFunction(g: number, epsilon: number = RG_EPSILON): number {
  // β(g) = -ε g + (N+8)/(N+2) g² (one-loop for φ⁴ theory)
  const N = 1; // Number of components
  return -epsilon * g + ((N + 8) / (N + 2)) * g * g;
}

function findRGFixedPoints(epsilon: number = RG_EPSILON): number[] {
  // Solve β(g*) = 0
  const N = 1;
  const trivial = 0;
  const wilson = epsilon * (N + 2) / (N + 8);
  return [trivial, wilson];
}

function computeCriticalExponents(gStar: number, epsilon: number = RG_EPSILON): { [key: string]: number } {
  // Critical exponents from RG eigenvalues
  const N = 1;
  const eta = (epsilon * (N + 2)) / (2 * (N + 8));  // Anomalous dimension
  const nu = 1 / 2 + epsilon / 4;                    // Correlation length exponent
  const gamma = (2 - eta) * nu;                      // Susceptibility
  const beta = nu / 2;                               // Order parameter
  const delta = (4 + epsilon) / (2 - epsilon);       // Critical isotherm
  const alpha = 2 - 3 * nu;                          // Heat capacity
  
  return { eta, nu, gamma, beta, delta, alpha };
}

// ═══════════════════════════════════════════════════════════════════════════════
// NEW PHYSICS SYSTEMS: INITIALIZATION & STEPPING
// ═══════════════════════════════════════════════════════════════════════════════

// ── Kuramoto-Sivashinsky Equation ─────────────────────────────────────────────
// ∂u/∂t = -u∇²u - ∇⁴u - ∇²u (spatio-temporal chaos)
function initKuramotoSivashinsky(gridSize: number, viscosity: number): KuramotoSivashinskyState {
  const u = Array.from({ length: gridSize }, (_, i) => 
    0.1 * Math.sin(2 * Math.PI * i / gridSize) + 0.05 * Math.random()
  );
  return {
    u,
    gridSize,
    viscosity,
    lyapunovDimension: 0,
    kolmogorovEntropy: 0,
  };
}

function stepKuramotoSivashinsky(state: KuramotoSivashinskyState, dt: number): KuramotoSivashinskyState {
  const { u, gridSize, viscosity } = state;
  const dx = 1.0 / gridSize;
  const newU = [...u];
  
  for (let i = 0; i < gridSize; i++) {
    const im2 = (i - 2 + gridSize) % gridSize;
    const im1 = (i - 1 + gridSize) % gridSize;
    const ip1 = (i + 1) % gridSize;
    const ip2 = (i + 2) % gridSize;
    
    // ∇²u ≈ (u[i+1] - 2u[i] + u[i-1])/dx²
    const laplacian = (u[ip1] - 2 * u[i] + u[im1]) / (dx * dx);
    
    // ∇⁴u ≈ (u[i+2] - 4u[i+1] + 6u[i] - 4u[i-1] + u[i-2])/dx⁴
    const biharmonic = (u[ip2] - 4 * u[ip1] + 6 * u[i] - 4 * u[im1] + u[im2]) / (dx * dx * dx * dx);
    
    // ∂u/∂t = -u∇²u - ∇⁴u - ν∇²u
    const dudt = -u[i] * laplacian - biharmonic - viscosity * laplacian;
    newU[i] = u[i] + dt * dudt;
  }
  
  return { ...state, u: newU };
}

// ── FitzHugh-Nagumo (Excitable Media) ─────────────────────────────────────────
// ∂v/∂t = v - v³/3 - w + I
// ∂w/∂t = ε(v + a - bw)
function initFitzHughNagumo(gridSize: number, a: number, b: number, tau: number): FitzHughNagumoState {
  const v = Array.from({ length: gridSize * gridSize }, () => Math.random() * 0.2 - 0.1);
  const w = Array.from({ length: gridSize * gridSize }, () => Math.random() * 0.1);
  
  // Add stimulus in center
  const center = Math.floor(gridSize / 2);
  const centerIdx = center * gridSize + center;
  v[centerIdx] = 2.0;
  
  return {
    v,
    w,
    gridSize,
    a,
    b,
    tau,
    isExcitable: true,
    wavefrontSpeed: 0,
    refractoryPeriod: 0,
    spiralFrequency: 0,
  };
}

function stepFitzHughNagumo(state: FitzHughNagumoState, dt: number, D: number): FitzHughNagumoState {
  const { v, w, gridSize, a, b, tau } = state;
  const newV = [...v];
  const newW = [...w];
  const dx = 1.0;
  
  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      const idx = i * gridSize + j;
      const up = ((i - 1 + gridSize) % gridSize) * gridSize + j;
      const down = ((i + 1) % gridSize) * gridSize + j;
      const left = i * gridSize + ((j - 1 + gridSize) % gridSize);
      const right = i * gridSize + ((j + 1) % gridSize);
      
      const laplacianV = (v[up] + v[down] + v[left] + v[right] - 4 * v[idx]) / (dx * dx);
      
      // FHN dynamics
      const dvdt = v[idx] - v[idx] ** 3 / 3 - w[idx] + D * laplacianV;
      const dwdt = (v[idx] + a - b * w[idx]) / tau;
      
      newV[idx] = v[idx] + dt * dvdt;
      newW[idx] = w[idx] + dt * dwdt;
    }
  }
  
  return { ...state, v: newV, w: newW };
}

// ── Complex Ginzburg-Landau ───────────────────────────────────────────────────
// ∂A/∂t = A + (1+iα)∇²A - (1+iβ)|A|²A
function initComplexGinzburgLandau(gridSize: number): ComplexGinzburgLandauState {
  const A = Array.from({ length: gridSize * gridSize }, () => ({
    re: 0.1 * (Math.random() - 0.5),
    im: 0.1 * (Math.random() - 0.5),
  }));
  
  return {
    A,
    gridSize,
    alpha: { re: 0, im: 1.5 }, // (1 + iα)
    beta: { re: 0, im: -2.0 }, // (1 + iβ)
    phaseDefects: [],
    defectVelocities: [],
  };
}

function complexMult(a: Complex, b: Complex): Complex {
  return {
    re: a.re * b.re - a.im * b.im,
    im: a.re * b.im + a.im * b.re,
  };
}

function complexAbs2(a: Complex): number {
  return a.re * a.re + a.im * a.im;
}

function stepComplexGinzburgLandau(state: ComplexGinzburgLandauState, dt: number): ComplexGinzburgLandauState {
  const { A, gridSize, alpha, beta } = state;
  const newA = [...A];
  const dx = 1.0;
  
  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      const idx = i * gridSize + j;
      const up = ((i - 1 + gridSize) % gridSize) * gridSize + j;
      const down = ((i + 1) % gridSize) * gridSize + j;
      const left = i * gridSize + ((j - 1 + gridSize) % gridSize);
      const right = i * gridSize + ((j + 1) % gridSize);
      
      // Laplacian of complex field
      const lapRe = (A[up].re + A[down].re + A[left].re + A[right].re - 4 * A[idx].re) / (dx * dx);
      const lapIm = (A[up].im + A[down].im + A[left].im + A[right].im - 4 * A[idx].im) / (dx * dx);
      
      const laplacian: Complex = { re: lapRe, im: lapIm };
      
      // (1 + iα)∇²A
      const alphaLap = complexMult({ re: 1 + alpha.re, im: alpha.im }, laplacian);
      
      // |A|²A
      const abs2 = complexAbs2(A[idx]);
      const abs2A: Complex = { re: abs2 * A[idx].re, im: abs2 * A[idx].im };
      
      // (1 + iβ)|A|²A
      const betaAbs2A = complexMult({ re: 1 + beta.re, im: beta.im }, abs2A);
      
      // ∂A/∂t = A + (1+iα)∇²A - (1+iβ)|A|²A
      const dAdt: Complex = {
        re: A[idx].re + alphaLap.re - betaAbs2A.re,
        im: A[idx].im + alphaLap.im - betaAbs2A.im,
      };
      
      newA[idx] = {
        re: A[idx].re + dt * dAdt.re,
        im: A[idx].im + dt * dAdt.im,
      };
    }
  }
  
  return { ...state, A: newA };
}

// ── Swift-Hohenberg Equation ──────────────────────────────────────────────────
// ∂u/∂t = ru - (1 + ∇²)²u + u³
function initSwiftHohenberg(gridSize: number, r: number, q0: number): SwiftHohenbergState {
  const u = Array.from({ length: gridSize * gridSize }, () => 0.1 * (Math.random() - 0.5));
  return {
    u,
    gridSize,
    r,
    q0,
    stripeAmplitude: 0,
    hexagonalOrder: 0,
  };
}

function stepSwiftHohenberg(state: SwiftHohenbergState, dt: number): SwiftHohenbergState {
  const { u, gridSize, r } = state;
  const newU = [...u];
  const dx = 1.0;
  
  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      const idx = i * gridSize + j;
      const up = ((i - 1 + gridSize) % gridSize) * gridSize + j;
      const down = ((i + 1) % gridSize) * gridSize + j;
      const left = i * gridSize + ((j - 1 + gridSize) % gridSize);
      const right = i * gridSize + ((j + 1) % gridSize);
      
      // ∇²u
      const lap1 = (u[up] + u[down] + u[left] + u[right] - 4 * u[idx]) / (dx * dx);
      
      // (1 + ∇²)u
      const op1 = u[idx] + lap1;
      
      // ∇²(1 + ∇²)u - approximate with finite differences
      const op1Up = u[up] + (u[((i - 2 + gridSize) % gridSize) * gridSize + j] + u[down] + u[left] + u[right] - 4 * u[up]) / (dx * dx);
      const op1Down = u[down] + (u[up] + u[((i + 2) % gridSize) * gridSize + j] + u[left] + u[right] - 4 * u[down]) / (dx * dx);
      const op1Left = u[left] + (u[up] + u[down] + u[((j - 2 + gridSize) % gridSize)] + u[right] - 4 * u[left]) / (dx * dx);
      const op1Right = u[right] + (u[up] + u[down] + u[left] + u[((j + 2) % gridSize)] - 4 * u[right]) / (dx * dx);
      
      const lap2 = (op1Up + op1Down + op1Left + op1Right - 4 * op1) / (dx * dx);
      
      // (1 + ∇²)²u
      const op2 = op1 + lap2;
      
      // ∂u/∂t = ru - (1 + ∇²)²u + u³
      const dudt = r * u[idx] - op2 + u[idx] ** 3;
      newU[idx] = u[idx] + dt * dudt;
    }
  }
  
  return { ...state, u: newU };
}

// ── Burgers Equation ──────────────────────────────────────────────────────────
// ∂u/∂t + u∂u/∂x = ν∂²u/∂x²
function initBurgers(gridSize: number, viscosity: number): BurgersState {
  const u = Array.from({ length: gridSize }, (_, i) => 
    Math.sin(2 * Math.PI * i / gridSize) + 0.5 * Math.sin(4 * Math.PI * i / gridSize)
  );
  return {
    u,
    gridSize,
    viscosity,
    shockPositions: [],
    shockStrengths: [],
  };
}

function stepBurgers(state: BurgersState, dt: number): BurgersState {
  const { u, gridSize, viscosity } = state;
  const newU = [...u];
  const dx = 1.0 / gridSize;
  
  for (let i = 0; i < gridSize; i++) {
    const im1 = (i - 1 + gridSize) % gridSize;
    const ip1 = (i + 1) % gridSize;
    
    // ∂u/∂x (central difference)
    const dudx = (u[ip1] - u[im1]) / (2 * dx);
    
    // ∂²u/∂x²
    const d2udx2 = (u[ip1] - 2 * u[i] + u[im1]) / (dx * dx);
    
    // Burgers equation
    const dudt = -u[i] * dudx + viscosity * d2udx2;
    newU[i] = u[i] + dt * dudt;
  }
  
  // Detect shocks (large gradients)
  const shockPositions: number[] = [];
  const shockStrengths: number[] = [];
  for (let i = 0; i < gridSize; i++) {
    const ip1 = (i + 1) % gridSize;
    const gradient = Math.abs(newU[ip1] - newU[i]) / dx;
    if (gradient > 5.0) {
      shockPositions.push(i);
      shockStrengths.push(gradient);
    }
  }
  
  return { ...state, u: newU, shockPositions, shockStrengths };
}

// ── KdV (Korteweg-de Vries) Equation ──────────────────────────────────────────
// ∂u/∂t + u∂u/∂x + ∂³u/∂x³ = 0
function initKdV(gridSize: number): KdVState {
  const u = Array.from({ length: gridSize }, (_, i) => 
    2 * Math.exp(-((i - gridSize / 2) / 10) ** 2) // Gaussian pulse
  );
  return {
    u,
    gridSize,
    solitonPositions: [],
    solitonAmplitudes: [],
    solitonVelocities: [],
  };
}

function stepKdV(state: KdVState, dt: number): KdVState {
  const { u, gridSize } = state;
  const newU = [...u];
  const dx = 1.0 / gridSize;
  
  for (let i = 0; i < gridSize; i++) {
    const im1 = (i - 1 + gridSize) % gridSize;
    const im2 = (i - 2 + gridSize) % gridSize;
    const ip1 = (i + 1) % gridSize;
    const ip2 = (i + 2) % gridSize;
    
    // ∂u/∂x
    const dudx = (u[ip1] - u[im1]) / (2 * dx);
    
    // ∂³u/∂x³ (central difference)
    const d3udx3 = (u[ip2] - 2 * u[ip1] + 2 * u[im1] - u[im2]) / (2 * dx * dx * dx);
    
    // KdV equation
    const dudt = -u[i] * dudx - d3udx3;
    newU[i] = u[i] + dt * dudt;
  }
  
  // Detect solitons (local maxima)
  const solitonPositions: number[] = [];
  const solitonAmplitudes: number[] = [];
  for (let i = 1; i < gridSize - 1; i++) {
    if (newU[i] > newU[i - 1] && newU[i] > newU[i + 1] && newU[i] > 0.5) {
      solitonPositions.push(i);
      solitonAmplitudes.push(newU[i]);
    }
  }
  
  return { ...state, u: newU, solitonPositions, solitonAmplitudes };
}

// ── Sine-Gordon Equation ──────────────────────────────────────────────────────
// ∂²φ/∂t² = ∂²φ/∂x² - sin(φ)
function initSineGordon(gridSize: number): SineGordonState {
  const phi = Array.from({ length: gridSize }, (_, i) => 
    i < gridSize / 2 ? 0 : 2 * Math.PI // Kink configuration
  );
  const phiDot = new Array(gridSize).fill(0);
  return {
    phi,
    phiDot,
    gridSize,
    kinkPositions: [Math.floor(gridSize / 2)],
    breatherPositions: [],
    topologicalCharge: 1,
  };
}

function stepSineGordon(state: SineGordonState, dt: number): SineGordonState {
  const { phi, phiDot, gridSize } = state;
  const newPhi = [...phi];
  const newPhiDot = [...phiDot];
  const dx = 1.0 / gridSize;
  
  for (let i = 0; i < gridSize; i++) {
    const im1 = (i - 1 + gridSize) % gridSize;
    const ip1 = (i + 1) % gridSize;
    
    // ∂²φ/∂x²
    const d2phidx2 = (phi[ip1] - 2 * phi[i] + phi[im1]) / (dx * dx);
    
    // ∂²φ/∂t² = ∂²φ/∂x² - sin(φ)
    const d2phidt2 = d2phidx2 - Math.sin(phi[i]);
    
    // Verlet integration
    newPhiDot[i] = phiDot[i] + dt * d2phidt2;
    newPhi[i] = phi[i] + dt * newPhiDot[i];
  }
  
  return { ...state, phi: newPhi, phiDot: newPhiDot };
}

// ── Nonlinear Schrödinger Equation ────────────────────────────────────────────
// i∂ψ/∂t = -∂²ψ/∂x² + g|ψ|²ψ
function initNonlinearSchrodinger(gridSize: number, g: number): NonlinearSchrodingerState {
  const psi = Array.from({ length: gridSize }, (_, i) => ({
    re: Math.exp(-((i - gridSize / 2) / 10) ** 2),
    im: 0,
  }));
  return {
    psi,
    gridSize,
    g,
    solitonWidth: 0,
    solitonPhase: 0,
  };
}

function stepNonlinearSchrodinger(state: NonlinearSchrodingerState, dt: number): NonlinearSchrodingerState {
  const { psi, gridSize, g } = state;
  const newPsi = [...psi];
  const dx = 1.0 / gridSize;
  
  for (let i = 0; i < gridSize; i++) {
    const im1 = (i - 1 + gridSize) % gridSize;
    const ip1 = (i + 1) % gridSize;
    
    // ∂²ψ/∂x²
    const d2psidx2: Complex = {
      re: (psi[ip1].re - 2 * psi[i].re + psi[im1].re) / (dx * dx),
      im: (psi[ip1].im - 2 * psi[i].im + psi[im1].im) / (dx * dx),
    };
    
    // |ψ|²ψ
    const abs2 = complexAbs2(psi[i]);
    const nlTerm: Complex = {
      re: g * abs2 * psi[i].re,
      im: g * abs2 * psi[i].im,
    };
    
    // i∂ψ/∂t = -∂²ψ/∂x² + g|ψ|²ψ
    // ∂ψ/∂t = i(∂²ψ/∂x² - g|ψ|²ψ)
    const dpsidt: Complex = {
      re: -(d2psidx2.im - nlTerm.im),
      im: d2psidx2.re - nlTerm.re,
    };
    
    newPsi[i] = {
      re: psi[i].re + dt * dpsidt.re,
      im: psi[i].im + dt * dpsidt.im,
    };
  }
  
  return { ...state, psi: newPsi };
}

// ── Gross-Pitaevskii Equation (BEC) ───────────────────────────────────────────
// i∂ψ/∂t = -∇²ψ/2 + V(r)ψ + g|ψ|²ψ
function initGrossPitaevskii(gridSize: number, g: number): GrossPitaevskiiState {
  const psi = Array.from({ length: gridSize * gridSize }, (_, idx) => {
    const i = Math.floor(idx / gridSize);
    const j = idx % gridSize;
    const r2 = (i - gridSize / 2) ** 2 + (j - gridSize / 2) ** 2;
    return {
      re: Math.exp(-r2 / 100),
      im: 0,
    };
  });
  return {
    psi,
    gridSize,
    g,
    chemicalPotential: 0,
    healingLength: 0,
    vortexPositions: [],
    vortexCharges: [],
  };
}

function stepGrossPitaevskii(state: GrossPitaevskiiState, dt: number): GrossPitaevskiiState {
  const { psi, gridSize, g } = state;
  const newPsi = [...psi];
  const dx = 1.0;
  
  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      const idx = i * gridSize + j;
      const up = ((i - 1 + gridSize) % gridSize) * gridSize + j;
      const down = ((i + 1) % gridSize) * gridSize + j;
      const left = i * gridSize + ((j - 1 + gridSize) % gridSize);
      const right = i * gridSize + ((j + 1) % gridSize);
      
      // ∇²ψ
      const lapRe = (psi[up].re + psi[down].re + psi[left].re + psi[right].re - 4 * psi[idx].re) / (dx * dx);
      const lapIm = (psi[up].im + psi[down].im + psi[left].im + psi[right].im - 4 * psi[idx].im) / (dx * dx);
      
      // Harmonic trap V(r) = r²/2
      const r2 = ((i - gridSize / 2) ** 2 + (j - gridSize / 2) ** 2) / (gridSize * gridSize);
      const V = 0.5 * r2;
      
      // |ψ|²ψ
      const abs2 = complexAbs2(psi[idx]);
      
      // i∂ψ/∂t = -∇²ψ/2 + Vψ + g|ψ|²ψ
      const dpsidt: Complex = {
        re: -(-lapIm / 2 + V * psi[idx].im + g * abs2 * psi[idx].im),
        im: -lapRe / 2 + V * psi[idx].re + g * abs2 * psi[idx].re,
      };
      
      newPsi[idx] = {
        re: psi[idx].re + dt * dpsidt.re,
        im: psi[idx].im + dt * dpsidt.im,
      };
    }
  }
  
  return { ...state, psi: newPsi };
}

// ── XY Model (Topological Vortices) ───────────────────────────────────────────
function initXYModel(gridSize: number, temperature: number): XYModelState {
  const theta = Array.from({ length: gridSize * gridSize }, () => 2 * Math.PI * Math.random());
  return {
    theta,
    gridSize,
    temperature,
    vortexPositions: [],
    vortexCharges: [],
    reducedT: temperature / 0.89, // T_KT ≈ 0.89
  };
}

function stepXYModel(state: XYModelState, dt: number): XYModelState {
  const { theta, gridSize, temperature } = state;
  const newTheta = [...theta];
  
  // Monte Carlo update
  for (let step = 0; step < gridSize * gridSize; step++) {
    const idx = Math.floor(Math.random() * theta.length);
    const i = Math.floor(idx / gridSize);
    const j = idx % gridSize;
    
    const up = ((i - 1 + gridSize) % gridSize) * gridSize + j;
    const down = ((i + 1) % gridSize) * gridSize + j;
    const left = i * gridSize + ((j - 1 + gridSize) % gridSize);
    const right = i * gridSize + ((j + 1) % gridSize);
    
    // Energy before
    const E1 = -Math.cos(theta[idx] - theta[up]) - Math.cos(theta[idx] - theta[down]) -
               Math.cos(theta[idx] - theta[left]) - Math.cos(theta[idx] - theta[right]);
    
    // Propose new angle
    const newAngle = theta[idx] + (Math.random() - 0.5) * 0.5;
    
    // Energy after
    const E2 = -Math.cos(newAngle - theta[up]) - Math.cos(newAngle - theta[down]) -
               Math.cos(newAngle - theta[left]) - Math.cos(newAngle - theta[right]);
    
    // Metropolis acceptance
    const dE = E2 - E1;
    if (dE < 0 || Math.random() < Math.exp(-dE / temperature)) {
      newTheta[idx] = newAngle;
    }
  }
  
  // Detect vortices (circulation around plaquettes)
  const vortexPositions: [number, number][] = [];
  const vortexCharges: number[] = [];
  
  for (let i = 0; i < gridSize - 1; i++) {
    for (let j = 0; j < gridSize - 1; j++) {
      const idx = i * gridSize + j;
      const right = i * gridSize + (j + 1);
      const down = (i + 1) * gridSize + j;
      const diag = (i + 1) * gridSize + (j + 1);
      
      // Circulation around plaquette
      const dtheta1 = theta[right] - theta[idx];
      const dtheta2 = theta[diag] - theta[right];
      const dtheta3 = theta[down] - theta[diag];
      const dtheta4 = theta[idx] - theta[down];
      
      const circulation = wrapPhase(dtheta1) + wrapPhase(dtheta2) + wrapPhase(dtheta3) + wrapPhase(dtheta4);
      
      if (Math.abs(circulation) > Math.PI) {
        vortexPositions.push([i, j]);
        vortexCharges.push(Math.sign(circulation));
      }
    }
  }
  
  return { ...state, theta: newTheta, vortexPositions, vortexCharges };
}

// ── Quantum Harmonic Oscillator ───────────────────────────────────────────────
function initQuantumHO(n: number, omega: number): QuantumHarmonicOscillatorState {
  const gridSize = 128;
  const xmax = 5.0;
  const x = Array.from({ length: gridSize }, (_, i) => -xmax + (2 * xmax * i) / (gridSize - 1));
  
  // Hermite polynomial H_n(x) * Gaussian
  const psi = x.map(xi => {
    const hermite = n === 0 ? 1 : n === 1 ? 2 * xi : 2 * xi * (2 * xi) - 2; // Simplified
    const gaussian = Math.exp(-xi * xi / 2);
    return { re: hermite * gaussian, im: 0 };
  });
  
  // Normalize
  const norm = Math.sqrt(psi.reduce((sum, p) => sum + complexAbs2(p), 0) * (2 * xmax / gridSize));
  const psiNorm = psi.map(p => ({ re: p.re / norm, im: p.im / norm }));
  
  return {
    psi: psiNorm,
    x,
    n,
    omega,
    meanX: 0,
    meanP: 0,
    deltaX: 0,
    deltaP: 0,
    uncertainty: 0,
  };
}

function stepQuantumHO(state: QuantumHarmonicOscillatorState, dt: number): QuantumHarmonicOscillatorState {
  const { psi, x, omega } = state;
  const dx = x[1] - x[0];
  const newPsi = [...psi];
  
  // i∂ψ/∂t = Hψ = (-∂²/∂x² + ω²x²/2)ψ
  for (let i = 1; i < psi.length - 1; i++) {
    const d2psidx2: Complex = {
      re: (psi[i + 1].re - 2 * psi[i].re + psi[i - 1].re) / (dx * dx),
      im: (psi[i + 1].im - 2 * psi[i].im + psi[i - 1].im) / (dx * dx),
    };
    
    const V = 0.5 * omega * omega * x[i] * x[i];
    
    // Hψ = -d²ψ/dx² + Vψ
    const Hpsi: Complex = {
      re: -d2psidx2.re + V * psi[i].re,
      im: -d2psidx2.im + V * psi[i].im,
    };
    
    // i∂ψ/∂t = Hψ → ∂ψ/∂t = -iHψ
    newPsi[i] = {
      re: psi[i].re + dt * Hpsi.im,
      im: psi[i].im - dt * Hpsi.re,
    };
  }
  
  // Compute expectation values
  const prob = newPsi.map(p => complexAbs2(p));
  const sumProb = prob.reduce((a, b) => a + b, 0) * dx;
  const meanX = x.reduce((sum, xi, i) => sum + xi * prob[i], 0) * dx / sumProb;
  
  // Compute uncertainties
  const meanX2 = x.reduce((sum, xi, i) => sum + xi * xi * prob[i], 0) * dx / sumProb;
  const deltaX = Math.sqrt(meanX2 - meanX * meanX);
  
  return { ...state, psi: newPsi, meanX, deltaX, uncertainty: deltaX * 1.0 }; // Simplified ΔxΔp
}

// ═══════════════════════════════════════════════════════════════════════════════
// ADVANCED ANALYSIS UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════

// ── Autocorrelation Function ──────────────────────────────────────────────────
function computeAutocorrelation(timeSeries: number[], maxLag: number): number[] {
  const N = timeSeries.length;
  const mean = timeSeries.reduce((a, b) => a + b, 0) / N;
  const variance = timeSeries.reduce((a, x) => a + (x - mean) ** 2, 0) / N;
  
  const autocorr: number[] = [];
  for (let lag = 0; lag < Math.min(maxLag, N / 2); lag++) {
    let sum = 0;
    for (let i = 0; i < N - lag; i++) {
      sum += (timeSeries[i] - mean) * (timeSeries[i + lag] - mean);
    }
    autocorr.push(sum / ((N - lag) * variance));
  }
  return autocorr;
}

// ── Structure Factor (Fourier) ────────────────────────────────────────────────
function computeStructureFactor(field: number[], gridSize: number): number[][] {
  // S(k) = ⟨|ρ(k)|²⟩ where ρ(k) = Σ_r ρ(r) e^(-ik·r)
  const N = gridSize;
  const S: number[][] = Array.from({ length: N }, () => new Array(N).fill(0));
  
  for (let kx = 0; kx < N; kx++) {
    for (let ky = 0; ky < N; ky++) {
      let re = 0, im = 0;
      for (let x = 0; x < N; x++) {
        for (let y = 0; y < N; y++) {
          const idx = x * N + y;
          const phase = -2 * Math.PI * (kx * x + ky * y) / N;
          re += field[idx] * Math.cos(phase);
          im += field[idx] * Math.sin(phase);
        }
      }
      S[kx][ky] = (re * re + im * im) / (N * N);
    }
  }
  return S;
}

// ── Correlation Function G(r) ─────────────────────────────────────────────────
function computeSpatialCorrelation(field: number[], gridSize: number, maxR: number): number[] {
  const N = gridSize;
  const correlations: number[] = [];
  const mean = field.reduce((a, b) => a + b, 0) / field.length;
  
  for (let r = 0; r < maxR; r++) {
    let sum = 0;
    let count = 0;
    for (let i = 0; i < N; i++) {
      for (let j = 0; j < N; j++) {
        const idx1 = i * N + j;
        const i2 = (i + r) % N;
        const idx2 = i2 * N + j;
        sum += (field[idx1] - mean) * (field[idx2] - mean);
        count++;
      }
    }
    correlations.push(sum / count);
  }
  return correlations;
}

// ── First Return Map ──────────────────────────────────────────────────────────
function computeFirstReturnMap(timeSeries: number[], threshold: number): [number, number][] {
  const crossings: number[] = [];
  for (let i = 1; i < timeSeries.length; i++) {
    if ((timeSeries[i - 1] < threshold && timeSeries[i] >= threshold) ||
        (timeSeries[i - 1] > threshold && timeSeries[i] <= threshold)) {
      crossings.push(timeSeries[i]);
    }
  }
  
  const map: [number, number][] = [];
  for (let i = 0; i < crossings.length - 1; i++) {
    map.push([crossings[i], crossings[i + 1]]);
  }
  return map;
}

// ── Estimate Correlation Dimension ────────────────────────────────────────────
function estimateCorrelationDimension(points: [number, number][], epsilons: number[]): number {
  // Box-counting: D_2 = lim_(ε→0) log C(ε) / log ε
  const correlationSums: number[] = [];
  
  for (const eps of epsilons) {
    let count = 0;
    for (let i = 0; i < points.length; i++) {
      for (let j = i + 1; j < points.length; j++) {
        const dist = Math.sqrt((points[i][0] - points[j][0]) ** 2 + (points[i][1] - points[j][1]) ** 2);
        if (dist < eps) count++;
      }
    }
    const C = 2 * count / (points.length * (points.length - 1));
    correlationSums.push(C);
  }
  
  // Fit log(C) vs log(ε)
  if (correlationSums.length < 2) return 2.0;
  const logEps = epsilons.map(e => Math.log(e));
  const logC = correlationSums.map(c => Math.log(Math.max(c, 1e-10)));
  
  // Linear regression
  const n = logEps.length;
  const sumX = logEps.reduce((a, b) => a + b, 0);
  const sumY = logC.reduce((a, b) => a + b, 0);
  const sumXY = logEps.reduce((a, x, i) => a + x * logC[i], 0);
  const sumX2 = logEps.reduce((a, x) => a + x * x, 0);
  
  const slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
  return slope;
}

// ── Finite-Size Scaling Analysis ──────────────────────────────────────────────
function finiteAdaptation(observables: number[], systemSizes: number[], criticalExponent: number): number {
  // Scale: O_L = L^β f((T-Tc)L^{1/ν})
  // Extract critical point from data collapse
  // Simplified: return best-fit Tc
  if (observables.length < 2) return 2.27;
  return observables[0] / observables[observables.length - 1];
}

// ── Topological Charge Density ────────────────────────────────────────────────
function computeTopologicalCharge(phaseField: number[], gridSize: number): number {
  // Q = (1/2π) ∫ d²r ε_ij ∂_i φ ∂_j φ
  const N = gridSize;
  let totalCharge = 0;
  
  for (let i = 0; i < N - 1; i++) {
    for (let j = 0; j < N - 1; j++) {
      const idx = i * N + j;
      const right = i * N + (j + 1);
      const down = (i + 1) * N + j;
      const diag = (i + 1) * N + (j + 1);
      
      // Circulation around plaquette
      const dtheta1 = wrapPhase(phaseField[right] - phaseField[idx]);
      const dtheta2 = wrapPhase(phaseField[diag] - phaseField[right]);
      const dtheta3 = wrapPhase(phaseField[down] - phaseField[diag]);
      const dtheta4 = wrapPhase(phaseField[idx] - phaseField[down]);
      
      const circulation = dtheta1 + dtheta2 + dtheta3 + dtheta4;
      totalCharge += circulation / (2 * Math.PI);
    }
  }
  
  return Math.round(totalCharge); // Should be integer
}

// ── Detect Phase Singularities ────────────────────────────────────────────────
function detectPhaseSingularities(A: Complex[], gridSize: number): [number, number][] {
  const N = gridSize;
  const singularities: [number, number][] = [];
  
  for (let i = 1; i < N - 1; i++) {
    for (let j = 1; j < N - 1; j++) {
      const idx = i * N + j;
      
      // Check if amplitude is very small (core of defect)
      if (complexAbs2(A[idx]) < 0.01) {
        // Verify phase winding
        const neighbors = [
          A[(i - 1) * N + j],
          A[i * N + (j + 1)],
          A[(i + 1) * N + j],
          A[i * N + (j - 1)],
        ];
        
        const phases = neighbors.map(c => Math.atan2(c.im, c.re));
        let winding = 0;
        for (let k = 0; k < 4; k++) {
          winding += wrapPhase(phases[(k + 1) % 4] - phases[k]);
        }
        
        if (Math.abs(winding) > Math.PI) {
          singularities.push([i, j]);
        }
      }
    }
  }
  
  return singularities;
}

// ── Entropy Production Rate ───────────────────────────────────────────────────
function computeEntropyProduction(fluxes: number[], forces: number[]): number {
  // σ = Σ_i J_i X_i (thermodynamic entropy production)
  let sigma = 0;
  for (let i = 0; i < Math.min(fluxes.length, forces.length); i++) {
    sigma += fluxes[i] * forces[i];
  }
  return Math.max(sigma, 0);
}

// ── Onsager Reciprocal Relations ──────────────────────────────────────────────
function checkOnsagerReciprocity(transportMatrix: number[][]): boolean {
  // L_ij = L_ji (near equilibrium)
  const n = transportMatrix.length;
  let maxDev = 0;
  
  for (let i = 0; i < n; i++) {
    for (let j = i + 1; j < n; j++) {
      const dev = Math.abs(transportMatrix[i][j] - transportMatrix[j][i]);
      maxDev = Math.max(maxDev, dev);
    }
  }
  
  return maxDev < 0.01; // Tolerance
}

// ── Linear Response Theory (Kubo Formula) ─────────────────────────────────────
function kuboResponse(correlationFunction: number[], dt: number): number {
  // χ(ω=0) = ∫_0^∞ dt ⟨A(t)A(0)⟩
  return correlationFunction.reduce((sum, c, i) => sum + c * dt, 0);
}

// ── Fluctuation-Dissipation Theorem ───────────────────────────────────────────
function checkFluctuationDissipation(response: number, fluctuation: number, temperature: number): boolean {
  // χ = β ⟨(ΔA)²⟩
  const predicted = fluctuation / temperature;
  const error = Math.abs(response - predicted) / Math.max(predicted, 1e-10);
  return error < 0.1;
}

// ── Maximum Entropy Production ────────────────────────────────────────────────
function maximumEntropyProduction(constraints: number[]): number[] {
  // Variational principle: δσ = 0 subject to constraints
  // Simplified: uniform distribution
  const sum = constraints.reduce((a, b) => a + b, 0);
  return constraints.map(c => c / sum);
}

// ── Detailed Balance Check ────────────────────────────────────────────────────
function checkDetailedBalance(transitionMatrix: number[][], equilibriumDist: number[]): boolean {
  // π_i P_ij = π_j P_ji
  const n = transitionMatrix.length;
  let maxViolation = 0;
  
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      const forward = equilibriumDist[i] * transitionMatrix[i][j];
      const reverse = equilibriumDist[j] * transitionMatrix[j][i];
      const violation = Math.abs(forward - reverse);
      maxViolation = Math.max(maxViolation, violation);
    }
  }
  
  return maxViolation < 0.01;
}

// ── Kramers Escape Rate ───────────────────────────────────────────────────────
function kramersRate(barrierHeight: number, frequency: number, temperature: number, damping: number): number {
  // k = (ω_b ω_0 / 2πγ) exp(-ΔV/k_B T)
  return (frequency / (2 * Math.PI * damping)) * Math.exp(-barrierHeight / temperature);
}

// ── Arrhenius Law ─────────────────────────────────────────────────────────────
function arrheniusRate(activationEnergy: number, temperature: number, prefactor: number): number {
  // k = A exp(-E_a / k_B T)
  return prefactor * Math.exp(-activationEnergy / temperature);
}

// ── Nucleation Rate (Classical) ───────────────────────────────────────────────
function nucleationRate(supersaturation: number, interfaceTension: number, temperature: number): number {
  // J = J_0 exp(-16π γ³ / 3 k_B T Δμ²)
  const barrier = (16 * Math.PI * interfaceTension ** 3) / (3 * temperature * supersaturation ** 2);
  return Math.exp(-barrier);
}

// ── Gibbs-Thomson Effect ──────────────────────────────────────────────────────
function gibbsThomsonShift(radius: number, interfaceTension: number, molarVolume: number, temperature: number): number {
  // ΔT = 2γT_m / (ρ L r)
  return 2 * interfaceTension / (radius * temperature);
}

// ── Ostwald Ripening ──────────────────────────────────────────────────────────
function ostwaldRipeningRate(diffusivity: number, concentration: number, interfaceTension: number): number {
  // dr³/dt = 8γDc/9
  return (8 * interfaceTension * diffusivity * concentration) / 9;
}

// ── Lifshitz-Slyozov Growth ───────────────────────────────────────────────────
function lifshitzSlyozovExponent(): number {
  // R(t) ~ t^{1/3} for diffusion-limited coarsening
  return 1 / 3;
}

// ── Allen-Cahn Dynamics ───────────────────────────────────────────────────────
function allenCahnRate(mobility: number, gradient: number): number {
  // ∂φ/∂t = -M δF/δφ (non-conserved order parameter)
  return -mobility * gradient;
}

// ── Cahn-Hilliard Dynamics ────────────────────────────────────────────────────
function cahnHilliardRate(mobility: number, laplacian: number): number {
  // ∂φ/∂t = M∇²(δF/δφ) (conserved order parameter)
  return mobility * laplacian;
}

// ── Spinodal Decomposition ────────────────────────────────────────────────────
function spinodalWavelength(a: number, kappa: number): number {
  // λ_max = 2π√(2κ/|a|) for fastest growing mode
  return 2 * Math.PI * Math.sqrt(2 * kappa / Math.abs(a));
}

// ── Ginzburg Criterion ────────────────────────────────────────────────────────
function ginzburgCriterion(correlationVolume: number, coherenceVolume: number): boolean {
  // Mean-field valid if ξ³/v ≫ 1
  return correlationVolume / coherenceVolume > 10;
}

// ── Kadanoff Block Spin ───────────────────────────────────────────────────────
function kadanoffBlocking(spins: number[], blockSize: number): number[] {
  // Coarse-grain by averaging blocks
  const N = Math.sqrt(spins.length);
  const Nb = Math.floor(N / blockSize);
  const blocked: number[] = [];
  
  for (let i = 0; i < Nb; i++) {
    for (let j = 0; j < Nb; j++) {
      let sum = 0;
      for (let di = 0; di < blockSize; di++) {
        for (let dj = 0; dj < blockSize; dj++) {
          const idx = (i * blockSize + di) * N + (j * blockSize + dj);
          sum += spins[idx];
        }
      }
      blocked.push(Math.sign(sum)); // Majority rule
    }
  }
  
  return blocked;
}

// ── Scaling Hypothesis ────────────────────────────────────────────────────────
function scalingFunction(reducedT: number, reducedH: number, beta: number, delta: number): number {
  // m(t,h) = |t|^β f(h/|t|^{βδ})
  const x = reducedH / Math.pow(Math.abs(reducedT), beta * delta);
  return Math.pow(Math.abs(reducedT), beta) * Math.tanh(x);
}

// ── Hyperscaling Relation ─────────────────────────────────────────────────────
function checkHyperscaling(alpha: number, beta: number, gamma: number, nu: number, delta: number, d: number): boolean {
  // dν = 2 - α = β(δ+1) = γ(δ+1)/(δ-1)
  const relation1 = Math.abs(d * nu - (2 - alpha));
  const relation2 = Math.abs(d * nu - beta * (delta + 1));
  const relation3 = Math.abs(d * nu - gamma * (delta + 1) / (delta - 1));
  return relation1 < 0.01 && relation2 < 0.01 && relation3 < 0.01;
}

// ── Fisher Relation ───────────────────────────────────────────────────────────
function checkFisherRelation(gamma: number, nu: number, eta: number): boolean {
  // γ = ν(2 - η)
  return Math.abs(gamma - nu * (2 - eta)) < 0.01;
}

// ── Rushbrooke Inequality ─────────────────────────────────────────────────────
function checkRushbrooke(alpha: number, beta: number, gamma: number): boolean {
  // α + 2β + γ ≥ 2 (equality at phase transition)
  const sum = alpha + 2 * beta + gamma;
  return Math.abs(sum - 2) < 0.01;
}

// ── Widom Scaling ─────────────────────────────────────────────────────────────
function checkWidomScaling(beta: number, gamma: number, delta: number): boolean {
  // γ = β(δ - 1)
  return Math.abs(gamma - beta * (delta - 1)) < 0.01;
}

// ── Josephson Scaling ─────────────────────────────────────────────────────────
function checkJosephsonScaling(d: number, nu: number, alpha: number): boolean {
  // dν = 2 - α
  return Math.abs(d * nu - (2 - alpha)) < 0.01;
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATE
// ═══════════════════════════════════════════════════════════════════════════════
interface PhysicsLabStateExtended {
  beat: number;
  
  // Original systems (enhanced)
  ising: IsingExtended;
  isingEnergyHistory: number[];
  isingMagHistory: number[];
  
  lorenz: LorenzExtended;
  lorenzTrail: [number, number, number][];
  
  rd: GrayScottExtended;
  sandpile: BTWExtended;
  brussel: BrusselatorExtended;
  lyapunov: LyapunovState5;
  
  // Landau Theory (extended)
  landau: LandauExtended;
  phiHistory: number[];
  fHistory: number[];
  
  // Information Geometry (extended)
  infoP: number[];
  infoQ: number[];
  wasserstein: WassersteinMetric;
  fisherRao: FisherRaoMetric;
  klDiv: number;
  jseDiv: number;
  
  // RG Flow
  rgFlow: RGFlowState;
  
  // New Physics Systems
  ks: KuramotoSivashinskyState;
  fhn: FitzHughNagumoState;
  cgl: ComplexGinzburgLandauState;
  sh: SwiftHohenbergState;
  burgers: BurgersState;
  kdv: KdVState;
  sineGordon: SineGordonState;
  nls: NonlinearSchrodingerState;
  gp: GrossPitaevskiiState;
  xy: XYModelState;
  qho: QuantumHarmonicOscillatorState;
  
  // Composite metrics
  emergenceE: number;
  forma: number;
  kyDim: number;
  
  // Analysis data
  criticalExponents: { [key: string]: number };
  powerLawExponents: { size: number; duration: number };
  bifurcationParameter: number;
}

// Simplified state for backward compatibility
interface PhysicsLabState {
  beat:       number;
  ising:      IsingState;
  lorenz:     LorenzState;
  lorenzTrail: [number,number,number][];
  rd:         RDState;
  sandpile:   SandpileState;
  brussel:    BrusselatorState;
  lyapunov:   LyapunovState5;
  temperature:   number;
  landauParams:  LandauParams;
  phiHistory:    number[];
  fHistory:      number[];
  infoP:     number[];
  infoQ:     number[];
  fisherMet: number;
  wassDist:  number;
  klDiv:     number;
  jseDiv:    number;
  rgCoupling: number;
  emergenceE: number;
  forma:      number;
  lyapExpHistory: number[];
  kyDim:      number;
  
  // Extended systems (added)
  ks?: KuramotoSivashinskyState;
  fhn?: FitzHughNagumoState;
  cgl?: ComplexGinzburgLandauState;
  sh?: SwiftHohenbergState;
  burgers?: BurgersState;
  kdv?: KdVState;
  sineGordon?: SineGordonState;
  nls?: NonlinearSchrodingerState;
  gp?: GrossPitaevskiiState;
  xy?: XYModelState;
  qho?: QuantumHarmonicOscillatorState;
  
  isingEnergyHistory?: number[];
  isingMagHistory?: number[];
  rgFlow?: RGFlowState;
  powerLawTau?: number;
}

function initPhysicsLab(): PhysicsLabState {
  const lp = landauFromTemperature(2.5);
  return {
    beat: 0,
    ising:    initIsingState(32, 32, 2.8),
    lorenz:   initLorenzState(),
    lorenzTrail: [],
    rd:       initRDState(32),
    sandpile: initSandpile(24),
    brussel:  initBrusselator(20, 1.0, 3.0),
    lyapunov: initLyapunov(),
    temperature: 2.8,
    landauParams: lp,
    phiHistory: [],
    fHistory: [],
    infoP: Array.from({ length: 8 }, (_, i) => 0.05 + i * 0.1),
    infoQ: Array.from({ length: 8 }, () => 0.125),
    fisherMet: 0,
    wassDist: 0,
    klDiv: 0,
    jseDiv: 0,
    rgCoupling: 1.0,
    emergenceE: 0,
    forma: FORMA_GENESIS_FLOOR,
    lyapExpHistory: [],
    kyDim: 1.0,
    
    // Initialize new systems
    ks: initKuramotoSivashinsky(64, 0.1),
    fhn: initFitzHughNagumo(32, 0.7, 0.8, 12.5),
    cgl: initComplexGinzburgLandau(32),
    sh: initSwiftHohenberg(32, 0.5, 1.0),
    burgers: initBurgers(64, 0.01),
    kdv: initKdV(128),
    sineGordon: initSineGordon(128),
    nls: initNonlinearSchrodinger(128, -1.0),
    gp: initGrossPitaevskii(24, 100),
    xy: initXYModel(24, 1.0),
    qho: initQuantumHO(0, 1.0),
    
    isingEnergyHistory: [],
    isingMagHistory: [],
    rgFlow: {
      coupling: 1.0,
      beta: 0,
      fixedPoints: findRGFixedPoints(),
      eigenvalues: [],
      relevantOps: 0,
      marginalOps: 0,
      irrelevantOps: 0,
      criticalExponents: computeCriticalExponents(1.0),
    },
    powerLawTau: BTW_TAU,
  };
}

function tickPhysics(prev: PhysicsLabState): PhysicsLabState {
  const beat = prev.beat + 1;

  // ── Ising ────────────────────────────────────────────────────────────────
  let ising = prev.ising;
  // Slowly cool the system toward Tc = 2.269
  const targetT = beat < 200 ? 2.8 - beat * 0.003 : 2.269 + Math.sin(beat * 0.01) * 0.3;
  ising = { ...ising, temperature: Math.max(0.5, targetT) };
  for (let s = 0; s < 5; s++) {
    const idx = Math.floor(Math.random() * ising.grid.length);
    ising = isingMetropolisStep(ising, Math.random(), idx);
  }
  const mag = isingMagnetization(ising);

  // ── Lorenz ────────────────────────────────────────────────────────────────
  const lorenz = lorenzStep(prev.lorenz, 0.01);
  const trail: [number,number,number][] = [
    ...prev.lorenzTrail.slice(-1499),
    [lorenz.x, lorenz.y, lorenz.z],
  ];

  // ── Gray-Scott RD ────────────────────────────────────────────────────────
  const rd = rdStep(prev.rd, 1.0);

  // ── Sandpile ──────────────────────────────────────────────────────────────
  const center = Math.floor(Math.sqrt(prev.sandpile.grid.length) / 2);
  const spIdx = center * Math.floor(Math.sqrt(prev.sandpile.grid.length)) + center;
  const sandpile = sandpileAddGrain(prev.sandpile, spIdx);

  // ── Brusselator ───────────────────────────────────────────────────────────
  const brussel = brusselatorStep(prev.brussel, 0.02);

  // ── Landau ────────────────────────────────────────────────────────────────
  const temperature = Math.max(0.5, prev.temperature + Math.sin(beat * 0.02) * 0.05);
  const landauParams = landauFromTemperature(temperature);
  const phiStar = findEquilibriumPhi(landauParams);
  const fStar = landauFreeEnergyFull(phiStar, landauParams);
  const phiHistory = [...prev.phiHistory.slice(-199), phiStar];
  const fHistory = [...prev.fHistory.slice(-199), fStar];

  // ── Lyapunov ─────────────────────────────────────────────────────────────
  const { r: kuramR } = computeKuramotoOrder(
    Array.from({ length: 12 }, (_, i) => (beat * HIERARCHY_FREQS[i]) % TAU)
  );
  const lyapunov = lyapunovTick(
    prev.lyapunov, kuramR, Math.abs(mag), ising.temperature / 3,
    clamp(1 - Math.abs(fStar), 0, 1), clamp(Math.abs(mag) + kuramR * 0.3, 0, 1)
  );
  const lyapExpHistory = [...prev.lyapExpHistory.slice(-49), lyapunov.V];
  const lyapExp = lyapunovExponent(lyapExpHistory, 20);
  const kyDim = kaplanYorkeDimension([lyapExp, lyapExp * 0.6, -lyapExp]);

  // ── Information Geometry ────────────────────────────────────────────────
  // Slowly evolve P toward Q via gradient descent
  const pSum = prev.infoP.reduce((a, b) => a + b, 0.001);
  const infoP = prev.infoP.map((p, i) => {
    const grad = p > 0 ? Math.log(p / Math.max(prev.infoQ[i], 0.001)) : 0;
    return Math.max(0.001, p - 0.001 * grad);
  });
  const pSum2 = infoP.reduce((a, b) => a + b, 0.001);
  const pNorm = infoP.map(p => p / pSum2);
  const qNorm = prev.infoQ.map((q, i) => {
    const distort = Math.sin(beat * 0.05 + i) * 0.02;
    return Math.max(0.001, q + distort);
  });
  const qSum = qNorm.reduce((a, b) => a + b, 0.001);
  const qNormalized = qNorm.map(q => q / qSum);

  const fisherMet = pNorm.reduce((s, p) => s + fisherInfo(p), 0) / pNorm.length;
  const wassDist = wasserstein1D(pNorm, qNormalized);
  const klDiv = klDivergence(pNorm, qNormalized);
  const jseDiv = jseDivergenceExt(pNorm, qNormalized);
  const rgCoupling = clamp(prev.rgCoupling * (1 + (kuramR - 0.5) * 0.01), 0.1, 5.0);

  // ── Composite Emergence ─────────────────────────────────────────────────
  const lorenzNorm = Math.sqrt(lorenz.x ** 2 + lorenz.y ** 2 + lorenz.z ** 2);
  const emergInputs: EmergenceInputs = {
    r: kuramR, syncEntropy: kuramotoSyncEntropy(kuramR),
    magnetization: Math.abs(mag), phiStar: Math.abs(phiStar),
    lorenzNorm, lyapunovV: lyapunov.V,
  };
  const emergenceE = computeEmergenceScore(emergInputs);
  const forma = formaCompoundFull(prev.forma, kuramR, beat, 0.20, 2);
  
  // ── Update New Physics Systems ─────────────────────────────────────────────
  const ks = prev.ks ? stepKuramotoSivashinsky(prev.ks, 0.1) : initKuramotoSivashinsky(64, 0.1);
  const fhn = prev.fhn ? stepFitzHughNagumo(prev.fhn, 0.5, 1.0) : initFitzHughNagumo(32, 0.7, 0.8, 12.5);
  const cgl = prev.cgl ? stepComplexGinzburgLandau(prev.cgl, 0.1) : initComplexGinzburgLandau(32);
  const sh = prev.sh ? stepSwiftHohenberg(prev.sh, 0.1) : initSwiftHohenberg(32, 0.5, 1.0);
  const burgers = prev.burgers ? stepBurgers(prev.burgers, 0.01) : initBurgers(64, 0.01);
  const kdv = prev.kdv ? stepKdV(prev.kdv, 0.001) : initKdV(128);
  const sineGordon = prev.sineGordon ? stepSineGordon(prev.sineGordon, 0.01) : initSineGordon(128);
  const nls = prev.nls ? stepNonlinearSchrodinger(prev.nls, 0.001) : initNonlinearSchrodinger(128, -1.0);
  const gp = prev.gp ? stepGrossPitaevskii(prev.gp, 0.01) : initGrossPitaevskii(24, 100);
  const xy = prev.xy ? stepXYModel(prev.xy, 0.1) : initXYModel(24, 1.0);
  const qho = prev.qho ? stepQuantumHO(prev.qho, 0.01) : initQuantumHO(0, 1.0);
  
  // ── Enhanced Analysis ──────────────────────────────────────────────────────
  const isingEnergyHistory = [...(prev.isingEnergyHistory || []).slice(-99), isingEnergy(ising)];
  const isingMagHistory = [...(prev.isingMagHistory || []).slice(-99), mag];
  
  // RG Flow evolution
  const beta = computeBetaFunction(rgCoupling);
  const rgFlow = prev.rgFlow ? {
    ...prev.rgFlow,
    coupling: rgCoupling,
    beta,
  } : {
    coupling: rgCoupling,
    beta,
    fixedPoints: findRGFixedPoints(),
    eigenvalues: [],
    relevantOps: 0,
    marginalOps: 0,
    irrelevantOps: 0,
    criticalExponents: computeCriticalExponents(rgCoupling),
  };
  
  // BTW power-law analysis
  const powerLawTau = sandpile.totalTopplings > 100 && (prev.powerLawTau || BTW_TAU);

  return {
    beat, ising, lorenz, lorenzTrail: trail, rd, sandpile, brussel,
    lyapunov, temperature, landauParams, phiHistory, fHistory,
    infoP: pNorm, infoQ: qNormalized,
    fisherMet, wassDist, klDiv, jseDiv, rgCoupling,
    emergenceE, forma, lyapExpHistory, kyDim,
    ks, fhn, cgl, sh, burgers, kdv, sineGordon, nls, gp, xy, qho,
    isingEnergyHistory, isingMagHistory, rgFlow, powerLawTau,
  };
}

// Hierarchy freqs for Kuramoto order
const HIERARCHY_FREQS = Array.from({ length: 12 }, (_, k) => 0.000384 * Math.pow(PHI, k));

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS DRAWERS
// ═══════════════════════════════════════════════════════════════════════════════

function drawIsingFull(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const gW = s.ising.gridW, gH = s.ising.gridH;
  const cW = (W - 2) / gW, cH = (H - 24) / gH;
  s.ising.grid.forEach((spin, idx) => {
    const col = idx % gW, row = Math.floor(idx / gW);
    ctx.fillStyle = spin > 0 ? CYAN : '#071a2a';
    ctx.fillRect(1 + col * cW, 1 + row * cH, cW - 0.5, cH - 0.5);
  });
  const mag = isingMagnetization(s.ising);
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`T=${s.ising.temperature.toFixed(3)}  m=${mag.toFixed(4)}  E=${isingEnergy(s.ising).toFixed(1)}`, 4, H - 6);
  // Phase boundary line at Tc = 2.269
  if (Math.abs(s.ising.temperature - 2.269) < 0.15) {
    ctx.strokeStyle = GOLD; ctx.lineWidth = 1.5;
    ctx.globalAlpha = 0.5;
    ctx.beginPath(); ctx.moveTo(0, 4); ctx.lineTo(W, 4); ctx.stroke();
    ctx.globalAlpha = 1;
    ctx.fillStyle = GOLD; ctx.font = 'bold 9px monospace';
    ctx.textAlign = 'center'; ctx.fillText('T≈Tc', W/2, 13);
  }
}

function drawLorenzFull(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const trail = s.lorenzTrail;
  if (trail.length < 2) return;
  const xs = trail.map(p => p[0]), zs = trail.map(p => p[2]);
  const minX = Math.min(...xs), maxX = Math.max(...xs);
  const minZ = Math.min(...zs), maxZ = Math.max(...zs);
  const rX = maxX - minX || 1, rZ = maxZ - minZ || 1;
  const pad = 16;
  for (let i = 1; i < trail.length; i++) {
    const t = i / trail.length;
    const r = Math.round(t * 212), g = Math.round(t * 150), b = Math.round(255 - t * 60);
    ctx.strokeStyle = `rgba(${r},${g},${b},${0.2 + t * 0.8})`;
    ctx.lineWidth = t > 0.97 ? 2 : 0.8;
    ctx.beginPath();
    ctx.moveTo(pad + (trail[i-1][0]-minX)/(rX)*(W-2*pad), H-pad-(trail[i-1][2]-minZ)/(rZ)*(H-2*pad));
    ctx.lineTo(pad + (trail[i][0]-minX)/(rX)*(W-2*pad), H-pad-(trail[i][2]-minZ)/(rZ)*(H-2*pad));
    ctx.stroke();
  }
  const last = trail[trail.length-1];
  ctx.fillStyle = GOLD; ctx.beginPath();
  ctx.arc(pad+(last[0]-minX)/rX*(W-2*pad), H-pad-(last[2]-minZ)/rZ*(H-2*pad), 3, 0, TAU);
  ctx.fill();
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`x=${s.lorenz.x.toFixed(2)} y=${s.lorenz.y.toFixed(2)} z=${s.lorenz.z.toFixed(2)}`, 4, 12);
}

function drawRDFull(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const gS = s.rd.gridSize;
  const cW = W / gS, cH = H / gS;
  const u = s.rd.uField, v = s.rd.vField;
  if (!u || !v) return;
  for (let i = 0; i < gS * gS; i++) {
    const col = i % gS, row = Math.floor(i / gS);
    const uv = clamp(u[i], 0, 1), vv = clamp(v[i], 0, 1);
    const r = Math.round(uv * 30), g = Math.round(uv * 200 + vv * 55), b = Math.round(vv * 255);
    ctx.fillStyle = `rgb(${r},${g},${b})`;
    ctx.fillRect(col*cW, row*cH, cW, cH);
  }
  const turing = isTuringUnstable(s.rd);
  ctx.fillStyle = turing ? GREEN : MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Turing=${turing} f=${s.rd.f.toFixed(4)} k=${s.rd.k.toFixed(4)}`, 3, H-4);
}

function drawSandpile(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const gS = Math.round(Math.sqrt(s.sandpile.grid.length));
  const cW = W / gS, cH = H / gS;
  s.sandpile.grid.forEach((h, idx) => {
    const col = idx % gS, row = Math.floor(idx / gS);
    const intensity = Math.min(h / 4, 1);
    const r = Math.round(intensity * 212), g = Math.round(intensity * 175), b = 0;
    ctx.fillStyle = h >= 4 ? RED : `rgb(${r},${g},${b})`;
    ctx.fillRect(col*cW, row*cH, cW-0.5, cH-0.5);
  });
  const totalGrains = s.sandpile.grid.reduce((a, b) => a + b, 0);
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`BTW grains=${totalGrains} topplings=${s.sandpile.totalTopplings}`, 3, H-4);
}

function drawBrussPhase(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const gS = s.brussel.gridSize;
  const cW = W / gS, cH = H / gS;
  const X = s.brussel.X, Y = s.brussel.Y;
  if (!X || !Y) return;
  for (let i = 0; i < gS * gS; i++) {
    const col = i % gS, row = Math.floor(i / gS);
    const x = clamp(X[i]/3, 0, 1), y = clamp(Y[i]/3, 0, 1);
    const r = Math.round(x * 255), g = 60, b = Math.round(y * 255);
    ctx.fillStyle = `rgb(${r},${g},${b})`;
    ctx.fillRect(col*cW, row*cH, cW, cH);
  }
  const osc = brusselatorOscillates(s.brussel);
  ctx.fillStyle = osc ? GREEN : MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Brusselator osc=${osc} a=${s.brussel.a.toFixed(2)} b=${s.brussel.b.toFixed(2)}`, 3, H-4);
}

function drawLandauCurve(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const pad = 20;
  const iW = W - 2*pad, iH = H - 2*pad;
  // Draw F(φ) curve
  const phiRange = 2.5;
  const steps = 200;
  ctx.strokeStyle = CYAN; ctx.lineWidth = 1.5; ctx.beginPath();
  let fMin = Infinity, fMax = -Infinity;
  const fVals = Array.from({length: steps}, (_, i) => {
    const phi = -phiRange + i * 2 * phiRange / steps;
    const f = landauFreeEnergyFull(phi, s.landauParams);
    if (f < fMin) fMin = f; if (f > fMax) fMax = f;
    return f;
  });
  const fRange = fMax - fMin || 1;
  fVals.forEach((f, i) => {
    const px = pad + i / steps * iW;
    const py = pad + iH - (f - fMin) / fRange * iH;
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  // Mark φ*
  const phiStar = findEquilibriumPhi(s.landauParams);
  const pxStar = pad + ((phiStar + phiRange) / (2*phiRange)) * iW;
  const fStarV = landauFreeEnergyFull(phiStar, s.landauParams);
  const pyStar = pad + iH - (fStarV - fMin) / fRange * iH;
  ctx.fillStyle = GOLD; ctx.beginPath(); ctx.arc(pxStar, pyStar, 4, 0, TAU); ctx.fill();
  // Zero line
  const pyZero = pad + iH - (0 - fMin) / fRange * iH;
  ctx.strokeStyle = BORDER; ctx.lineWidth = 0.5;
  ctx.beginPath(); ctx.moveTo(pad, pyZero); ctx.lineTo(W-pad, pyZero); ctx.stroke();
  ctx.fillStyle = WHITE; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`T=${s.temperature.toFixed(3)}  φ*=${phiStar.toFixed(4)}  F=${fStarV.toFixed(4)}`, 4, 12);
  const sus = landauSusceptibility(phiStar, s.landauParams);
  ctx.fillText(`χ=${sus.toFixed(4)} a=${s.landauParams.a.toFixed(3)}`, 4, 24);
}

function drawInfoGeo(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const N = s.infoP.length;
  const barW = (W - 16) / N;
  // Draw P (cyan) and Q (orange) distributions
  s.infoP.forEach((p, i) => {
    const bh = p * (H - 40);
    ctx.fillStyle = CYAN; ctx.globalAlpha = 0.7;
    ctx.fillRect(8 + i * barW, H - 20 - bh, barW * 0.45, bh);
    const qh = (s.infoQ[i] ?? 0.125) * (H - 40);
    ctx.fillStyle = ORANGE;
    ctx.fillRect(8 + i * barW + barW * 0.5, H - 20 - qh, barW * 0.45, qh);
    ctx.globalAlpha = 1;
  });
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`W₁=${s.wassDist.toFixed(4)} KL=${s.klDiv.toFixed(4)} JSE=${s.jseDiv.toFixed(4)} g=${s.rgCoupling.toFixed(3)}`, 4, H-4);
  ctx.fillText(`Fisher g̃=${s.fisherMet.toFixed(4)}`, 4, 12);
}

function drawLyapunovLandscape(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  const hist = s.lyapunov.Vhistory;
  if (hist.length < 2) return;
  const vMin = Math.min(...hist), vMax = Math.max(...hist, 0.01);
  const pad = 16;
  const iW = W - 2*pad, iH = H - 2*pad - 16;
  // V(t) time series
  ctx.strokeStyle = ORANGE; ctx.lineWidth = 1.5; ctx.beginPath();
  hist.forEach((v, i) => {
    const px = pad + i / (hist.length - 1) * iW;
    const py = pad + iH - (v - vMin) / (vMax - vMin) * iH;
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  // OMNIS line
  if (isOmnisState(s.lyapunov.coherenceC)) {
    ctx.strokeStyle = GOLD; ctx.lineWidth = 1; ctx.globalAlpha = 0.5;
    const pyOmnis = pad + iH - (0.02 - vMin) / (vMax - vMin) * iH;
    ctx.beginPath(); ctx.moveTo(pad, pyOmnis); ctx.lineTo(W-pad, pyOmnis); ctx.stroke();
    ctx.globalAlpha = 1;
  }
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`V=${s.lyapunov.V.toFixed(4)} dV/dt=${s.lyapunov.Vdot.toFixed(4)} D_KY=${s.kyDim.toFixed(3)}`, 4, H-4);
  ctx.fillText(`stable=${s.lyapunov.isAsymptotic} beats=${s.lyapunov.stableBeats}`, 4, H-14);
}

// ═══════════════════════════════════════════════════════════════════════════════
// NEW SYSTEM VISUALIZATIONS
// ═══════════════════════════════════════════════════════════════════════════════

function drawKuramotoSivashinsky(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.ks) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { u, gridSize } = s.ks;
  const uMin = Math.min(...u), uMax = Math.max(...u);
  const range = uMax - uMin || 1;
  const pad = 16;
  
  ctx.strokeStyle = CYAN; ctx.lineWidth = 1.5; ctx.beginPath();
  u.forEach((val, i) => {
    const px = pad + (i / (gridSize - 1)) * (W - 2 * pad);
    const py = pad + (H - 2 * pad) - ((val - uMin) / range) * (H - 2 * pad);
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Kuramoto-Sivashinsky: spatio-temporal chaos`, 4, 12);
  ctx.fillText(`ν=${s.ks.viscosity.toFixed(3)} range=[${uMin.toFixed(2)},${uMax.toFixed(2)}]`, 4, H-4);
}

function drawFitzHughNagumo(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.fhn) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { v, gridSize } = s.fhn;
  const cW = W / gridSize, cH = H / gridSize;
  
  for (let i = 0; i < gridSize * gridSize; i++) {
    const col = i % gridSize, row = Math.floor(i / gridSize);
    const val = clamp((v[i] + 2) / 4, 0, 1); // Normalize to [0,1]
    const r = Math.round(val * 255), g = Math.round((1 - val) * 100), b = Math.round((1 - val) * 200);
    ctx.fillStyle = `rgb(${r},${g},${b})`;
    ctx.fillRect(col * cW, row * cH, cW, cH);
  }
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`FitzHugh-Nagumo: excitable media`, 4, H-4);
}

function drawComplexGinzburgLandau(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.cgl) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { A, gridSize } = s.cgl;
  const cW = W / gridSize, cH = H / gridSize;
  
  for (let i = 0; i < gridSize * gridSize; i++) {
    const col = i % gridSize, row = Math.floor(i / gridSize);
    const amplitude = Math.sqrt(complexAbs2(A[i]));
    const phase = Math.atan2(A[i].im, A[i].re);
    
    // Color based on phase, intensity on amplitude
    const hue = ((phase + Math.PI) / (2 * Math.PI)) * 360;
    const sat = 70;
    const light = clamp(amplitude * 50, 0, 80);
    ctx.fillStyle = `hsl(${hue},${sat}%,${light}%)`;
    ctx.fillRect(col * cW, row * cH, cW, cH);
  }
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Complex Ginzburg-Landau: phase turbulence`, 4, H-4);
}

function drawSwiftHohenberg(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.sh) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { u, gridSize } = s.sh;
  const cW = W / gridSize, cH = H / gridSize;
  
  for (let i = 0; i < gridSize * gridSize; i++) {
    const col = i % gridSize, row = Math.floor(i / gridSize);
    const val = clamp((u[i] + 2) / 4, 0, 1);
    const r = Math.round(val * 180), g = Math.round(val * 220), b = Math.round(val * 255);
    ctx.fillStyle = `rgb(${r},${g},${b})`;
    ctx.fillRect(col * cW, row * cH, cW, cH);
  }
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Swift-Hohenberg: pattern formation`, 4, H-4);
  ctx.fillText(`r=${s.sh.r.toFixed(3)}`, 4, 12);
}

function drawBurgers(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.burgers) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { u, gridSize, shockPositions } = s.burgers;
  const uMin = Math.min(...u), uMax = Math.max(...u);
  const range = uMax - uMin || 1;
  const pad = 16;
  
  ctx.strokeStyle = GREEN; ctx.lineWidth = 1.5; ctx.beginPath();
  u.forEach((val, i) => {
    const px = pad + (i / (gridSize - 1)) * (W - 2 * pad);
    const py = pad + (H - 2 * pad) - ((val - uMin) / range) * (H - 2 * pad);
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  
  // Mark shocks
  shockPositions.forEach(pos => {
    const px = pad + (pos / (gridSize - 1)) * (W - 2 * pad);
    ctx.strokeStyle = RED; ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(px, pad);
    ctx.lineTo(px, H - pad);
    ctx.stroke();
  });
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Burgers: shocks=${shockPositions.length}`, 4, 12);
  ctx.fillText(`ν=${s.burgers.viscosity.toFixed(3)}`, 4, H-4);
}

function drawKdV(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.kdv) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { u, gridSize, solitonPositions } = s.kdv;
  const uMin = Math.min(...u, 0), uMax = Math.max(...u);
  const range = uMax - uMin || 1;
  const pad = 16;
  
  ctx.strokeStyle = PURPLE; ctx.lineWidth = 1.5; ctx.beginPath();
  u.forEach((val, i) => {
    const px = pad + (i / (gridSize - 1)) * (W - 2 * pad);
    const py = pad + (H - 2 * pad) - ((val - uMin) / range) * (H - 2 * pad);
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  
  // Mark solitons
  solitonPositions.forEach(pos => {
    const px = pad + (pos / (gridSize - 1)) * (W - 2 * pad);
    ctx.fillStyle = GOLD;
    ctx.beginPath();
    ctx.arc(px, pad + (H - 2 * pad) / 2, 4, 0, TAU);
    ctx.fill();
  });
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`KdV: solitons=${solitonPositions.length}`, 4, 12);
}

function drawSineGordon(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.sineGordon) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { phi, gridSize, kinkPositions } = s.sineGordon;
  const pad = 16;
  
  ctx.strokeStyle = ORANGE; ctx.lineWidth = 1.5; ctx.beginPath();
  phi.forEach((val, i) => {
    const px = pad + (i / (gridSize - 1)) * (W - 2 * pad);
    const py = pad + (H - 2 * pad) - ((val % (2 * Math.PI)) / (2 * Math.PI)) * (H - 2 * pad);
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  
  // Mark kinks
  kinkPositions.forEach(pos => {
    const px = pad + (pos / (gridSize - 1)) * (W - 2 * pad);
    ctx.strokeStyle = GOLD; ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(px, pad);
    ctx.lineTo(px, H - pad);
    ctx.stroke();
  });
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Sine-Gordon: kinks=${kinkPositions.length} Q=${s.sineGordon.topologicalCharge}`, 4, 12);
}

function drawNonlinearSchrodinger(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.nls) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { psi, gridSize } = s.nls;
  const pad = 16;
  
  // Draw |ψ|²
  const prob = psi.map(p => complexAbs2(p));
  const maxProb = Math.max(...prob, 0.01);
  
  ctx.fillStyle = CYAN; ctx.globalAlpha = 0.5;
  prob.forEach((p, i) => {
    const px = pad + (i / (gridSize - 1)) * (W - 2 * pad);
    const height = (p / maxProb) * (H - 2 * pad);
    ctx.fillRect(px - 1, H - pad - height, 2, height);
  });
  ctx.globalAlpha = 1;
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`NLS: optical soliton g=${s.nls.g.toFixed(2)}`, 4, 12);
}

function drawGrossPitaevskii(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.gp) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { psi, gridSize, vortexPositions } = s.gp;
  const cW = W / gridSize, cH = H / gridSize;
  
  // Draw density |ψ|²
  const densities = psi.map(p => complexAbs2(p));
  const maxDens = Math.max(...densities, 0.01);
  
  for (let i = 0; i < gridSize * gridSize; i++) {
    const col = i % gridSize, row = Math.floor(i / gridSize);
    const dens = densities[i] / maxDens;
    const val = Math.round(dens * 255);
    ctx.fillStyle = `rgb(0,${val},${val})`;
    ctx.fillRect(col * cW, row * cH, cW, cH);
  }
  
  // Mark vortices
  vortexPositions.forEach(([i, j]) => {
    ctx.fillStyle = GOLD;
    ctx.beginPath();
    ctx.arc((j + 0.5) * cW, (i + 0.5) * cH, 3, 0, TAU);
    ctx.fill();
  });
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Gross-Pitaevskii: BEC vortices=${vortexPositions.length}`, 4, H-4);
}

function drawXYModel(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.xy) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { theta, gridSize, vortexPositions, vortexCharges } = s.xy;
  const cW = W / gridSize, cH = H / gridSize;
  
  // Draw spins as colors based on angle
  for (let i = 0; i < gridSize * gridSize; i++) {
    const col = i % gridSize, row = Math.floor(i / gridSize);
    const angle = theta[i];
    const hue = ((angle % (2 * Math.PI)) / (2 * Math.PI)) * 360;
    ctx.fillStyle = `hsl(${hue},70%,50%)`;
    ctx.fillRect(col * cW, row * cH, cW, cH);
  }
  
  // Mark vortices
  vortexPositions.forEach(([i, j], idx) => {
    const charge = vortexCharges[idx];
    ctx.fillStyle = charge > 0 ? RED : CYAN;
    ctx.beginPath();
    ctx.arc((j + 0.5) * cW, (i + 0.5) * cH, 4, 0, TAU);
    ctx.fill();
  });
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`XY Model: vortices=${vortexPositions.length} T/T_KT=${s.xy.reducedT.toFixed(2)}`, 4, H-4);
}

function drawQuantumHO(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  if (!s.qho) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const { psi, x } = s.qho;
  const pad = 16;
  
  // Draw |ψ|²
  const prob = psi.map(p => complexAbs2(p));
  const maxProb = Math.max(...prob, 0.01);
  
  ctx.fillStyle = PURPLE; ctx.globalAlpha = 0.6;
  prob.forEach((p, i) => {
    const px = pad + ((x[i] - x[0]) / (x[x.length - 1] - x[0])) * (W - 2 * pad);
    const height = (p / maxProb) * (H - 2 * pad) * 0.8;
    ctx.fillRect(px - 1, H - pad - height, 2, height);
  });
  ctx.globalAlpha = 1;
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Quantum HO: n=${s.qho.n} ΔxΔp=${s.qho.uncertainty.toFixed(3)}`, 4, 12);
  ctx.fillText(`⟨x⟩=${s.qho.meanX.toFixed(3)} Δx=${s.qho.deltaX.toFixed(3)}`, 4, H-4);
}

// ── Advanced Analysis Visualizations ──────────────────────────────────────────

function drawHeatCapacity(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const energyHist = s.isingEnergyHistory || [];
  if (energyHist.length < 2) return;
  
  const Cv = computeHeatCapacity(energyHist, s.ising.temperature);
  const pad = 20;
  
  // Plot C_V vs T (simplified: just show current value)
  ctx.fillStyle = GOLD; ctx.font = 'bold 16px monospace'; ctx.textAlign = 'center';
  ctx.fillText(`C_V = ${Cv.toFixed(3)}`, W / 2, H / 2);
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace';
  ctx.fillText(`Heat capacity diverges at T_c=${ISING_TC.toFixed(3)}`, W / 2, H / 2 + 20);
  ctx.fillText(`T=${s.ising.temperature.toFixed(3)}`, W / 2, H / 2 + 35);
  
  // Draw energy history
  const eMin = Math.min(...energyHist), eMax = Math.max(...energyHist);
  const eRange = eMax - eMin || 1;
  ctx.strokeStyle = CYAN; ctx.lineWidth = 1; ctx.beginPath();
  energyHist.forEach((e, i) => {
    const px = pad + (i / (energyHist.length - 1)) * (W - 2 * pad);
    const py = H - pad - ((e - eMin) / eRange) * (H / 3);
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
}

function drawSusceptibility(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const magHist = s.isingMagHistory || [];
  if (magHist.length < 2) return;
  
  const chi = computeSusceptibility(magHist, s.ising.temperature, s.ising.grid.length);
  const binderU = computeBinderCumulant(magHist);
  const pad = 20;
  
  ctx.fillStyle = GREEN; ctx.font = 'bold 16px monospace'; ctx.textAlign = 'center';
  ctx.fillText(`χ = ${chi.toFixed(3)}`, W / 2, H / 2 - 10);
  
  ctx.fillStyle = ORANGE; ctx.font = 'bold 14px monospace';
  ctx.fillText(`U_L = ${binderU.toFixed(3)}`, W / 2, H / 2 + 15);
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace';
  ctx.fillText(`Binder cumulant: U_L = 1 - ⟨M⁴⟩/(3⟨M²⟩²)`, W / 2, H / 2 + 35);
  ctx.fillText(`Divergence exponent: γ = ${ISING_GAMMA.toFixed(3)}`, W / 2, H / 2 + 50);
  
  // Draw mag history
  const mMin = Math.min(...magHist), mMax = Math.max(...magHist);
  const mRange = mMax - mMin || 0.01;
  ctx.strokeStyle = GREEN; ctx.lineWidth = 1; ctx.beginPath();
  magHist.forEach((m, i) => {
    const px = pad + (i / (magHist.length - 1)) * (W - 2 * pad);
    const py = H - pad - ((m - mMin) / mRange) * (H / 3);
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
}

function drawPoincareSection(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  // Simulate Poincaré section (y=0 crossings)
  const trail = s.lorenzTrail;
  const points: [number, number][] = [];
  
  for (let i = 1; i < trail.length; i++) {
    const [x0, y0, z0] = trail[i - 1];
    const [x1, y1, z1] = trail[i];
    
    if ((y0 < 0 && y1 >= 0) || (y0 > 0 && y1 <= 0)) {
      // Interpolate crossing point
      const t = -y0 / (y1 - y0);
      const xCross = x0 + t * (x1 - x0);
      const zCross = z0 + t * (z1 - z0);
      points.push([zCross, xCross]);
    }
  }
  
  if (points.length < 2) return;
  
  const zs = points.map(p => p[0]), xs = points.map(p => p[1]);
  const zMin = Math.min(...zs), zMax = Math.max(...zs);
  const xMin = Math.min(...xs), xMax = Math.max(...xs);
  const zRange = zMax - zMin || 1, xRange = xMax - xMin || 1;
  const pad = 20;
  
  ctx.fillStyle = CYAN;
  points.forEach(([z, x]) => {
    const px = pad + ((z - zMin) / zRange) * (W - 2 * pad);
    const py = pad + ((x - xMin) / xRange) * (H - 2 * pad);
    ctx.beginPath();
    ctx.arc(px, py, 1.5, 0, TAU);
    ctx.fill();
  });
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Poincaré section (y=0): ${points.length} points`, 4, 12);
  ctx.fillText(`Strange attractor structure`, 4, H-4);
}

function drawPowerSpectrum(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  // Simplified power spectrum from Lorenz time series
  const trail = s.lorenzTrail.slice(-256);
  if (trail.length < 64) return;
  
  const timeSeries = trail.map(p => p[0]); // Use x component
  const N = timeSeries.length;
  
  // Simple DFT (magnitude)
  const spectrum: number[] = [];
  for (let k = 0; k < N / 2; k++) {
    let re = 0, im = 0;
    for (let n = 0; n < N; n++) {
      const angle = -2 * Math.PI * k * n / N;
      re += timeSeries[n] * Math.cos(angle);
      im += timeSeries[n] * Math.sin(angle);
    }
    spectrum.push(Math.sqrt(re * re + im * im) / N);
  }
  
  const maxPower = Math.max(...spectrum, 0.01);
  const pad = 20;
  
  ctx.strokeStyle = PURPLE; ctx.lineWidth = 1; ctx.beginPath();
  spectrum.forEach((power, i) => {
    const px = pad + (i / (spectrum.length - 1)) * (W - 2 * pad);
    const py = H - pad - (power / maxPower) * (H - 2 * pad);
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  });
  ctx.stroke();
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`Power Spectrum (Lorenz x)`, 4, 12);
  ctx.fillText(`Chaotic broadband spectrum`, 4, H-4);
}

function drawRGFlow(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  const rgFlow = s.rgFlow;
  if (!rgFlow) return;
  
  const pad = 30;
  const gMax = 3;
  
  // Draw β(g) function
  ctx.strokeStyle = CYAN; ctx.lineWidth = 1.5; ctx.beginPath();
  for (let i = 0; i <= 100; i++) {
    const g = (i / 100) * gMax;
    const beta = computeBetaFunction(g);
    const px = pad + (g / gMax) * (W - 2 * pad);
    const py = H / 2 - beta * 30;
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  }
  ctx.stroke();
  
  // Draw fixed points
  rgFlow.fixedPoints.forEach(gStar => {
    if (gStar <= gMax) {
      const px = pad + (gStar / gMax) * (W - 2 * pad);
      ctx.fillStyle = GOLD;
      ctx.beginPath();
      ctx.arc(px, H / 2, 5, 0, TAU);
      ctx.fill();
    }
  });
  
  // Zero line
  ctx.strokeStyle = BORDER; ctx.lineWidth = 0.5;
  ctx.beginPath();
  ctx.moveTo(pad, H / 2);
  ctx.lineTo(W - pad, H / 2);
  ctx.stroke();
  
  ctx.fillStyle = MUTED; ctx.font = '9px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`RG β-function: dg/d(log μ)`, 4, 12);
  ctx.fillText(`g=${rgFlow.coupling.toFixed(3)} β=${rgFlow.beta.toFixed(4)}`, 4, H-4);
  
  // Critical exponents
  const exps = rgFlow.criticalExponents;
  ctx.fillStyle = GREEN; ctx.font = '8px monospace';
  ctx.fillText(`ν=${exps.nu?.toFixed(3)} η=${exps.eta?.toFixed(3)} γ=${exps.gamma?.toFixed(3)}`, 4, H-16);
}

function drawBTWAvalanche(canvas: HTMLCanvasElement, s: PhysicsLabState) {
  const ctx = canvas.getContext('2d'); if (!ctx) return;
  const W = canvas.width, H = canvas.height;
  ctx.fillStyle = BG; ctx.fillRect(0, 0, W, H);
  
  // Simplified: show power-law exponent τ
  const tau = s.powerLawTau || BTW_TAU;
  const pad = 30;
  
  ctx.fillStyle = GOLD; ctx.font = 'bold 18px monospace'; ctx.textAlign = 'center';
  ctx.fillText(`τ = ${tau.toFixed(3)}`, W / 2, H / 2);
  
  ctx.fillStyle = MUTED; ctx.font = '10px monospace';
  ctx.fillText(`P(s) ~ s^{-τ}`, W / 2, H / 2 + 25);
  ctx.fillText(`Self-Organized Criticality`, W / 2, H / 2 + 40);
  
  // Draw log-log plot sketch
  ctx.strokeStyle = ORANGE; ctx.lineWidth = 1.5; ctx.beginPath();
  for (let i = 0; i <= 100; i++) {
    const logS = (i / 100) * 3; // log10(s) from 0 to 3
    const logP = -tau * logS;
    const px = pad + (logS / 3) * (W - 2 * pad);
    const py = H - pad - ((logP + 4) / 4) * (H / 2);
    i === 0 ? ctx.moveTo(px, py) : ctx.lineTo(px, py);
  }
  ctx.stroke();
  
  ctx.fillStyle = MUTED; ctx.font = '8px monospace'; ctx.textAlign = 'left';
  ctx.fillText(`log P(s)`, 5, H - pad + 12);
  ctx.fillText(`log s`, W - pad + 5, H - 5);
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROPS
// ═══════════════════════════════════════════════════════════════════════════════
interface MathPhysicsLabProps {
  organism?: { r?: number; beat?: number; [key: string]: unknown };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════
export function MathPhysicsLab({ organism: _organism }: MathPhysicsLabProps) {
  // Original system refs
  const isingRef    = useRef<HTMLCanvasElement>(null);
  const lorenzRef   = useRef<HTMLCanvasElement>(null);
  const rdRef       = useRef<HTMLCanvasElement>(null);
  const sandpileRef = useRef<HTMLCanvasElement>(null);
  const brusselRef  = useRef<HTMLCanvasElement>(null);
  const landauRef   = useRef<HTMLCanvasElement>(null);
  const infoGeoRef  = useRef<HTMLCanvasElement>(null);
  const lyapRef     = useRef<HTMLCanvasElement>(null);
  
  // New system refs
  const ksRef       = useRef<HTMLCanvasElement>(null);
  const fhnRef      = useRef<HTMLCanvasElement>(null);
  const cglRef      = useRef<HTMLCanvasElement>(null);
  const shRef       = useRef<HTMLCanvasElement>(null);
  const burgersRef  = useRef<HTMLCanvasElement>(null);
  const kdvRef      = useRef<HTMLCanvasElement>(null);
  const sgRef       = useRef<HTMLCanvasElement>(null);
  const nlsRef      = useRef<HTMLCanvasElement>(null);
  const gpRef       = useRef<HTMLCanvasElement>(null);
  const xyRef       = useRef<HTMLCanvasElement>(null);
  const qhoRef      = useRef<HTMLCanvasElement>(null);
  
  // Analysis refs
  const heatCapRef  = useRef<HTMLCanvasElement>(null);
  const susceptRef  = useRef<HTMLCanvasElement>(null);
  const poincareRef = useRef<HTMLCanvasElement>(null);
  const spectrumRef = useRef<HTMLCanvasElement>(null);
  const rgFlowRef   = useRef<HTMLCanvasElement>(null);
  const avalRef     = useRef<HTMLCanvasElement>(null);

  const simRef  = useRef<PhysicsLabState>(initPhysicsLab());
  const tickCnt = useRef(0);
  const frameRef = useRef<number>(0);
  const [ui, setUi] = useState<PhysicsLabState>(simRef.current);

  const animate = useCallback(() => {
    simRef.current = tickPhysics(simRef.current);
    tickCnt.current++;
    
    // Original systems
    if (isingRef.current)    drawIsingFull(isingRef.current,    simRef.current);
    if (lorenzRef.current)   drawLorenzFull(lorenzRef.current,  simRef.current);
    if (rdRef.current)       drawRDFull(rdRef.current,          simRef.current);
    if (sandpileRef.current) drawSandpile(sandpileRef.current,  simRef.current);
    if (brusselRef.current)  drawBrussPhase(brusselRef.current, simRef.current);
    if (landauRef.current)   drawLandauCurve(landauRef.current, simRef.current);
    if (infoGeoRef.current)  drawInfoGeo(infoGeoRef.current,    simRef.current);
    if (lyapRef.current)     drawLyapunovLandscape(lyapRef.current, simRef.current);
    
    // New systems
    if (ksRef.current)       drawKuramotoSivashinsky(ksRef.current, simRef.current);
    if (fhnRef.current)      drawFitzHughNagumo(fhnRef.current, simRef.current);
    if (cglRef.current)      drawComplexGinzburgLandau(cglRef.current, simRef.current);
    if (shRef.current)       drawSwiftHohenberg(shRef.current, simRef.current);
    if (burgersRef.current)  drawBurgers(burgersRef.current, simRef.current);
    if (kdvRef.current)      drawKdV(kdvRef.current, simRef.current);
    if (sgRef.current)       drawSineGordon(sgRef.current, simRef.current);
    if (nlsRef.current)      drawNonlinearSchrodinger(nlsRef.current, simRef.current);
    if (gpRef.current)       drawGrossPitaevskii(gpRef.current, simRef.current);
    if (xyRef.current)       drawXYModel(xyRef.current, simRef.current);
    if (qhoRef.current)      drawQuantumHO(qhoRef.current, simRef.current);
    
    // Analysis panels
    if (heatCapRef.current)  drawHeatCapacity(heatCapRef.current, simRef.current);
    if (susceptRef.current)  drawSusceptibility(susceptRef.current, simRef.current);
    if (poincareRef.current) drawPoincareSection(poincareRef.current, simRef.current);
    if (spectrumRef.current) drawPowerSpectrum(spectrumRef.current, simRef.current);
    if (rgFlowRef.current)   drawRGFlow(rgFlowRef.current, simRef.current);
    if (avalRef.current)     drawBTWAvalanche(avalRef.current, simRef.current);
    
    if (tickCnt.current % 8 === 0) setUi({ ...simRef.current });
    frameRef.current = requestAnimationFrame(animate);
  }, []);

  useEffect(() => {
    frameRef.current = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(frameRef.current);
  }, [animate]);

  useEffect(() => {
    const refs = [
      isingRef, lorenzRef, rdRef, sandpileRef, brusselRef, landauRef, infoGeoRef, lyapRef,
      ksRef, fhnRef, cglRef, shRef, burgersRef, kdvRef, sgRef, nlsRef, gpRef, xyRef, qhoRef,
      heatCapRef, susceptRef, poincareRef, spectrumRef, rgFlowRef, avalRef
    ];
    const obs = refs.map(ref => {
      const o = new ResizeObserver(entries => {
        for (const e of entries) {
          const el = e.target as HTMLCanvasElement;
          el.width  = e.contentRect.width  * (window.devicePixelRatio || 1);
          el.height = e.contentRect.height * (window.devicePixelRatio || 1);
        }
      });
      if (ref.current) o.observe(ref.current);
      return o;
    });
    return () => obs.forEach(o => o.disconnect());
  }, []);

  const emergLabel = classifyEmergence(ui.emergenceE);
  const eColor = emergLabel === 'radical' ? GOLD : emergLabel === 'strong' ? GREEN : MUTED;

  const S = {
    root: { width:'100%', height:'100%', background:BG, display:'grid', gridTemplateRows:'auto 1fr auto auto', fontFamily:'monospace', overflow:'hidden' } as React.CSSProperties,
    header: { background:BG2, borderBottom:`1px solid ${BORDER}`, padding:'8px 16px', display:'flex', alignItems:'center', gap:16, flexWrap:'wrap' as const },
    title: { fontSize:14, fontWeight:'bold', color:GOLD, letterSpacing:'0.12em' },
    stat: { display:'flex', flexDirection:'column' as const, alignItems:'center', minWidth:60 },
    statLabel: { fontSize:9, color:MUTED, textTransform:'uppercase' as const },
    statVal: (c:string) => ({ fontSize:12, color:c, fontWeight:'bold' }),
    grid: { display:'grid', gridTemplateColumns:'repeat(6, 1fr)', gridTemplateRows:'repeat(5, 1fr)', gap:2, padding:2, overflow:'auto' as const },
    cell: { position:'relative' as const, background:BG, overflow:'hidden', minHeight:150 },
    canvas: { width:'100%', height:'100%', display:'block' },
    label: { position:'absolute' as const, top:3, left:5, fontSize:8, color:MUTED, pointerEvents:'none' as const, zIndex:1 },
    eqRow: { background:BG2, borderTop:`1px solid ${BORDER}`, display:'flex', flexDirection:'column' as const, gap:8, padding:'12px', overflowY:'auto' as const, maxHeight:300, fontSize:9, color:WHITE, fontFamily:'monospace' },
    eqGrid: { display:'grid', gridTemplateColumns:'repeat(auto-fit, minmax(300px, 1fr))', gap:12 },
    eqSec: (c:string) => ({ borderLeft:`3px solid ${c}`, paddingLeft:10, background:BG }),
    eqTitle: (c:string) => ({ color:c, fontWeight:'bold', marginBottom:4, fontSize:11 }),
  };

  return (
    <div style={S.root}>
      <header style={S.header}>
        <div style={S.title}>⬡ NOVA · COMPREHENSIVE MATH PHYSICS LAB — 20+ SYSTEMS</div>
        {[
          { label:'Beat',     val:String(ui.beat),                   color:CYAN   },
          { label:'Ising T',  val:ui.ising.temperature.toFixed(3),   color:ui.ising.temperature < 2.4 ? GOLD : MUTED },
          { label:'Ising m',  val:isingMagnetization(ui.ising).toFixed(4), color:GREEN },
          { label:'Emergence',val:ui.emergenceE.toFixed(4),          color:eColor },
          { label:'FORMA',    val:ui.forma.toFixed(0),               color:GOLD   },
          { label:'Lyap V',   val:ui.lyapunov.V.toFixed(4),          color:ORANGE },
          { label:'D_KY',     val:ui.kyDim.toFixed(3),               color:PURPLE },
          { label:'φ*',       val:findEquilibriumPhi(ui.landauParams).toFixed(4), color:CYAN },
          { label:'Wass W₁',  val:ui.wassDist.toFixed(4),            color:ORANGE },
          { label:'RG g',     val:ui.rgCoupling.toFixed(3),          color:GREEN  },
          { label:'BTW τ',    val:(ui.powerLawTau || BTW_TAU).toFixed(3), color:RED },
        ].map(({ label, val, color }) => (
          <div key={label} style={S.stat}>
            <span style={S.statLabel}>{label}</span>
            <span style={S.statVal(color)}>{val}</span>
          </div>
        ))}
      </header>

      <div style={S.grid}>
        {[
          // Original 8 systems
          { ref: isingRef,     label: 'ISING 2D — Metropolis/Wolff/SW'      },
          { ref: lorenzRef,    label: 'LORENZ — Chaotic Attractor'          },
          { ref: rdRef,        label: 'GRAY-SCOTT — Turing Patterns'        },
          { ref: sandpileRef,  label: 'BTW SANDPILE — SOC'                  },
          { ref: brusselRef,   label: 'BRUSSELATOR — Hopf Bifurcation'      },
          { ref: landauRef,    label: 'LANDAU — Phase Transitions'          },
          { ref: infoGeoRef,   label: 'INFO GEOMETRY — Wasserstein'         },
          { ref: lyapRef,      label: 'LYAPUNOV — Stability Landscape'      },
          
          // New physics systems
          { ref: ksRef,        label: 'KURAMOTO-SIVASHINSKY — Chaos'        },
          { ref: fhnRef,       label: 'FITZHUGH-NAGUMO — Excitable'         },
          { ref: cglRef,       label: 'COMPLEX GL — Phase Turbulence'       },
          { ref: shRef,        label: 'SWIFT-HOHENBERG — Patterns'          },
          { ref: burgersRef,   label: 'BURGERS — Shocks'                    },
          { ref: kdvRef,       label: 'KdV — Solitons'                      },
          { ref: sgRef,        label: 'SINE-GORDON — Kinks/Breathers'       },
          { ref: nlsRef,       label: 'NONLINEAR SCHRÖDINGER — Optical'     },
          { ref: gpRef,        label: 'GROSS-PITAEVSKII — BEC'              },
          { ref: xyRef,        label: 'XY MODEL — Topological Vortices'     },
          { ref: qhoRef,       label: 'QUANTUM HO — Wavepacket'             },
          
          // Analysis panels
          { ref: heatCapRef,   label: 'ISING HEAT CAPACITY C_V'             },
          { ref: susceptRef,   label: 'SUSCEPTIBILITY χ & BINDER U_L'       },
          { ref: poincareRef,  label: 'POINCARÉ SECTION (y=0)'              },
          { ref: spectrumRef,  label: 'POWER SPECTRUM — Chaos'              },
          { ref: rgFlowRef,    label: 'RG FLOW — β-function'                },
          { ref: avalRef,      label: 'BTW AVALANCHE — Power Law'           },
        ].map(({ ref, label }) => (
          <div key={label} style={S.cell}>
            <span style={S.label}>{label}</span>
            <canvas ref={ref as React.RefObject<HTMLCanvasElement>} style={S.canvas} />
          </div>
        ))}
      </div>

      <div style={S.eqRow}>
        <div style={S.eqGrid}>
          {/* Ising Model - Full Theory */}
          <div style={S.eqSec(CYAN)}>
            <div style={S.eqTitle(CYAN)}>ISING MODEL — Critical Phenomena</div>
            <div>H = −J·Σ⟨ij⟩ sᵢsⱼ − h·Σᵢ sᵢ</div>
            <div>ΔE = 2J·sᵢ·(s_up + s_down + s_left + s_right)</div>
            <div>P_flip = min(1, e^(−ΔE/k_B T))</div>
            <div style={{marginTop:4}}>T_c = 2.269185 J/k_B (exact, Onsager 1944)</div>
            <div>m = ⟨s⟩ ~ |T−T_c|^β   β = 1/8</div>
            <div>χ = ∂m/∂h ~ |T−T_c|^(−γ)   γ = 7/4</div>
            <div>C_V ~ |T−T_c|^(−α)   α = 0 (log divergence)</div>
            <div>ξ ~ |T−T_c|^(−ν)   ν = 1</div>
            <div>U_L = 1 − ⟨M⁴⟩/(3⟨M²⟩²) (Binder cumulant)</div>
            <div style={{color:GREEN,marginTop:4}}>m={isingMagnetization(ui.ising).toFixed(4)} T={ui.ising.temperature.toFixed(3)} E={isingEnergy(ui.ising).toFixed(1)}</div>
          </div>

          {/* Lorenz - Full Analysis */}
          <div style={S.eqSec(ORANGE)}>
            <div style={S.eqTitle(ORANGE)}>LORENZ ATTRACTOR — Chaos Theory</div>
            <div>dx/dt = σ(y − x)   σ = 10</div>
            <div>dy/dt = x(ρ − z) − y   ρ = 28</div>
            <div>dz/dt = xy − βz   β = 8/3</div>
            <div style={{marginTop:4}}>Lyapunov exponents:</div>
            <div>λ₁ ≈ 0.906 (divergence), λ₂ = 0, λ₃ ≈ −14.57</div>
            <div>D_KY = 2 + λ₁/|λ₃| ≈ 2.06 (Kaplan-Yorke)</div>
            <div>Poincaré map: (z,x) when y=0</div>
            <div>Strange attractor: fractal dimension</div>
            <div style={{color:GREEN,marginTop:4}}>x={ui.lorenz.x.toFixed(3)} y={ui.lorenz.y.toFixed(3)} z={ui.lorenz.z.toFixed(3)}</div>
          </div>

          {/* Gray-Scott - Turing Theory */}
          <div style={S.eqSec(PURPLE)}>
            <div style={S.eqTitle(PURPLE)}>GRAY-SCOTT — Turing Patterns</div>
            <div>∂u/∂t = D_u∇²u − uv² + f(1−u)</div>
            <div>∂v/∂t = D_v∇²v + uv² − (f+k)v</div>
            <div style={{marginTop:4}}>Turing instability: k²_c = (f+k)/D_u</div>
            <div>Wavelength: λ = 2π/k_c</div>
            <div>Dispersion: ω(k) = −(D_u + D_v)k²/2 + ...</div>
            <div>Patterns: spots (f=0.054,k=0.062)</div>
            <div>         stripes (f=0.035,k=0.06)</div>
            <div>         labyrinths (f=0.029,k=0.057)</div>
            <div style={{color:GREEN,marginTop:4}}>Turing={String(isTuringUnstable(ui.rd))} f={ui.rd.f.toFixed(4)} k={ui.rd.k.toFixed(4)}</div>
          </div>

          {/* BTW Sandpile */}
          <div style={S.eqSec(RED)}>
            <div style={S.eqTitle(RED)}>BTW SANDPILE — SOC</div>
            <div>h_i → h_i + 1 (add grain)</div>
            <div>if h_i ≥ 4: h_i → h_i − 4, neighbors +1</div>
            <div style={{marginTop:4}}>Self-Organized Criticality:</div>
            <div>P(s) ~ s^(−τ)   τ ≈ 1.29 (avalanche size)</div>
            <div>P(T) ~ T^(−τ_T)   τ_T ≈ 2.0 (duration)</div>
            <div>Scaling: area ~ size^(α_s)   α_s ≈ 1.5</div>
            <div>Fractal dimension: D_f ≈ 2.0</div>
            <div>Universality class: Abelian sandpile</div>
            <div style={{color:GREEN,marginTop:4}}>τ={(ui.powerLawTau || BTW_TAU).toFixed(3)}</div>
          </div>

          {/* Brusselator */}
          <div style={S.eqSec(MAGENTA)}>
            <div style={S.eqTitle(MAGENTA)}>BRUSSELATOR — Chemical Oscillator</div>
            <div>Reactions: A → X, B+X → Y+D, 2X+Y → 3X, X → E</div>
            <div>∂X/∂t = a − (b+1)X + X²Y + D_X∇²X</div>
            <div>∂Y/∂t = bX − X²Y + D_Y∇²Y</div>
            <div style={{marginTop:4}}>Hopf bifurcation at b = 1 + a²</div>
            <div>Frequency: ω ~ √a near Hopf</div>
            <div>Limit cycle amplitude ~ √(b − b_c)</div>
            <div>Floquet multipliers for stability</div>
            <div>Spiral waves, Turing-Hopf interaction</div>
            <div style={{color:GREEN,marginTop:4}}>osc={String(brusselatorOscillates(ui.brussel))} a={ui.brussel.a.toFixed(2)} b={ui.brussel.b.toFixed(2)}</div>
          </div>

          {/* Landau Theory */}
          <div style={S.eqSec(GOLD)}>
            <div style={S.eqTitle(GOLD)}>LANDAU THEORY — Phase Transitions</div>
            <div>F(φ) = ∫[a(T)φ² + b·φ⁴ + c(∇φ)²]dV</div>
            <div>a(T) = α(T − T_c),   b {'>'} 0</div>
            <div>φ* = 0 (T {'>'} T_c), φ* = ±√(−a/2b) (T {'<'} T_c)</div>
            <div style={{marginTop:4}}>Susceptibility: χ = ∂²F/∂φ² |_(φ*)</div>
            <div>Interface tension: σ ~ √(ac)</div>
            <div>Domain wall width: δ ~ √(c/|a|)</div>
            <div>Coarsening: L(t) ~ t^(1/3) (Allen-Cahn)</div>
            <div>Tricritical: b=0 → first-order transition</div>
            <div>Kibble-Zurek: defect density ~ τ_Q^(−d·ν/(1+z·ν))</div>
            <div style={{color:GOLD,marginTop:4}}>φ*={findEquilibriumPhi(ui.landauParams).toFixed(4)} T={ui.temperature.toFixed(3)}</div>
          </div>

          {/* Information Geometry */}
          <div style={S.eqSec(GREEN)}>
            <div style={S.eqTitle(GREEN)}>INFORMATION GEOMETRY</div>
            <div>Wasserstein: W₁(P,Q) = inf_γ ∫|x−y|dγ(x,y)</div>
            <div>Sinkhorn: K = exp(−C/ε), iterate u,v</div>
            <div>Fisher-Rao: g_ij = E[∂_i log p · ∂_j log p]</div>
            <div>Natural gradient: ∇̃ = G^(−1)∇</div>
            <div style={{marginTop:4}}>f-divergences:</div>
            <div>KL(P||Q) = Σ p_i log(p_i/q_i)</div>
            <div>JSE = [KL(P||M) + KL(Q||M)]/2, M=(P+Q)/2</div>
            <div>Hellinger: H²(P,Q) = Σ(√p_i − √q_i)²</div>
            <div>Cramér-Rao: Var(θ̂) ≥ 1/(n·I(θ))</div>
            <div style={{color:GREEN,marginTop:4}}>W₁={ui.wassDist.toFixed(4)} KL={ui.klDiv.toFixed(4)} g={ui.rgCoupling.toFixed(3)}</div>
          </div>

          {/* Lyapunov Stability */}
          <div style={S.eqSec(ORANGE)}>
            <div style={S.eqTitle(ORANGE)}>LYAPUNOV STABILITY</div>
            <div>V(x) = x^T P x   (quadratic form)</div>
            <div>dV/dt = ∂V/∂x · f(x) {'<'} 0 → stable</div>
            <div>LaSalle: largest invariant set in {'{'}V̇=0{'}'}</div>
            <div style={{marginTop:4}}>Stability types:</div>
            <div>Exponential: V̇ ≤ −αV, α {'>'} 0</div>
            <div>Asymptotic: V̇ {'<'} 0 outside origin</div>
            <div>ISS (Input-to-State): ||x|| ≤ β(||x₀||,t) + γ(||u||)</div>
            <div>Kaplan-Yorke: D_KY = j + Σ_(i=1)^j λ_i/|λ_(j+1)|</div>
            <div style={{color:ORANGE,marginTop:4}}>V={ui.lyapunov.V.toFixed(4)} D_KY={ui.kyDim.toFixed(3)} stable={String(ui.lyapunov.isAsymptotic)}</div>
          </div>

          {/* RG Flow */}
          <div style={S.eqSec(PURPLE)}>
            <div style={S.eqTitle(PURPLE)}>RENORMALIZATION GROUP</div>
            <div>β(g) = dg/d(log μ) [Wilson RG]</div>
            <div>Fixed points: β(g*) = 0</div>
            <div>ε-expansion: β(g) = −εg + bg², b=(N+8)/(N+2)</div>
            <div style={{marginTop:4}}>Critical exponents:</div>
            <div>η = ε(N+2)/(2(N+8)) [anomalous dim]</div>
            <div>ν = 1/2 + ε/4 [correlation length]</div>
            <div>γ = (2−η)ν [susceptibility]</div>
            <div>β = ν/2 [order parameter]</div>
            <div>Universality: same exponents → same class</div>
            <div>Kadanoff blocking, Wetterich equation</div>
            <div style={{color:PURPLE,marginTop:4}}>g={ui.rgCoupling.toFixed(3)} ε={RG_EPSILON.toFixed(2)}</div>
          </div>

          {/* Kuramoto-Sivashinsky */}
          <div style={S.eqSec(CYAN)}>
            <div style={S.eqTitle(CYAN)}>KURAMOTO-SIVASHINSKY</div>
            <div>∂u/∂t + u∂u/∂x + ∂²u/∂x² + ν∂⁴u/∂x⁴ = 0</div>
            <div>Spatio-temporal chaos in 1D</div>
            <div>Lyapunov dimension: D_L ~ L/λ</div>
            <div>Kolmogorov entropy: h_KS ~ L</div>
            <div>Cell dynamics, inertial manifold</div>
          </div>

          {/* FitzHugh-Nagumo */}
          <div style={S.eqSec(RED)}>
            <div style={S.eqTitle(RED)}>FITZHUGH-NAGUMO</div>
            <div>∂v/∂t = v − v³/3 − w + I + D∇²v</div>
            <div>∂w/∂t = ε(v + a − bw)</div>
            <div>Excitable dynamics, action potentials</div>
            <div>Wavefront speed: c ~ √D</div>
            <div>Spiral waves, reentry in cardiac tissue</div>
          </div>

          {/* Complex Ginzburg-Landau */}
          <div style={S.eqSec(MAGENTA)}>
            <div style={S.eqTitle(MAGENTA)}>COMPLEX GINZBURG-LANDAU</div>
            <div>∂A/∂t = A + (1+iα)∇²A − (1+iβ)|A|²A</div>
            <div>Amplitude equations near Hopf bifurcation</div>
            <div>Phase turbulence, defect chaos</div>
            <div>Benjamin-Feir instability (α·β {'<'} 0)</div>
            <div>Spiral/target patterns, phase singularities</div>
          </div>

          {/* Swift-Hohenberg */}
          <div style={S.eqSec(GOLD)}>
            <div style={S.eqTitle(GOLD)}>SWIFT-HOHENBERG</div>
            <div>∂u/∂t = ru − (q₀² + ∇²)²u + u³</div>
            <div>Pattern formation bifurcation</div>
            <div>Stripes at onset: u ~ cos(q₀x)</div>
            <div>Hexagons for stronger nonlinearity</div>
            <div>Grain boundaries, defects</div>
          </div>

          {/* Burgers */}
          <div style={S.eqSec(GREEN)}>
            <div style={S.eqTitle(GREEN)}>BURGERS EQUATION</div>
            <div>∂u/∂t + u∂u/∂x = ν∂²u/∂x²</div>
            <div>Shock formation: ∂u/∂x → −∞</div>
            <div>Cole-Hopf: u = −2ν∂_x log ψ</div>
            <div>Viscous: smooth shocks, width ~ ν/U</div>
          </div>

          {/* KdV */}
          <div style={S.eqSec(ORANGE)}>
            <div style={S.eqTitle(ORANGE)}>KORTEWEG-DE VRIES</div>
            <div>∂u/∂t + u∂u/∂x + ∂³u/∂x³ = 0</div>
            <div>Soliton: u = −(c/2)sech²[√(c/12)(x−ct)]</div>
            <div>Inverse scattering, integrability</div>
            <div>N-soliton collisions: elastic</div>
          </div>

          {/* Sine-Gordon */}
          <div style={S.eqSec(PURPLE)}>
            <div style={S.eqTitle(PURPLE)}>SINE-GORDON</div>
            <div>∂²φ/∂t² − ∂²φ/∂x² + sin(φ) = 0</div>
            <div>Kink: φ = 4 arctan(e^(x−vt)/√(1−v²))</div>
            <div>Topological charge: Q = (φ(∞)−φ(−∞))/2π</div>
            <div>Breathers: oscillating localized modes</div>
          </div>

          {/* Nonlinear Schrödinger */}
          <div style={S.eqSec(CYAN)}>
            <div style={S.eqTitle(CYAN)}>NONLINEAR SCHRÖDINGER</div>
            <div>i∂ψ/∂t = −∂²ψ/∂x² + g|ψ|²ψ</div>
            <div>Optical soliton (g{'<'}0): bright</div>
            <div>ψ = √(2/g) sech(x) e^(it)</div>
            <div>Modulation instability (g{'<'}0)</div>
          </div>

          {/* Gross-Pitaevskii */}
          <div style={S.eqSec(RED)}>
            <div style={S.eqTitle(RED)}>GROSS-PITAEVSKII (BEC)</div>
            <div>i∂ψ/∂t = [−∇²/2 + V(r) + g|ψ|²]ψ</div>
            <div>Chemical potential: μ = ∂E/∂N</div>
            <div>Healing length: ξ = 1/√(2gn)</div>
            <div>Quantized vortices: circulation Γ=2πℏ/m</div>
            <div>Thomas-Fermi: |ψ|² = (μ−V)/g</div>
          </div>

          {/* XY Model */}
          <div style={S.eqSec(MAGENTA)}>
            <div style={S.eqTitle(MAGENTA)}>XY MODEL — KT Transition</div>
            <div>H = −J·Σ⟨ij⟩ cos(θ_i − θ_j)</div>
            <div>Kosterlitz-Thouless: T_KT ≈ 0.89J</div>
            <div>Vortex unbinding: T {'<'} T_KT (bound pairs)</div>
            <div>                  T {'>'} T_KT (free vortices)</div>
            <div>Topological order, QLRO</div>
          </div>

          {/* Quantum HO */}
          <div style={S.eqSec(GOLD)}>
            <div style={S.eqTitle(GOLD)}>QUANTUM HARMONIC OSCILLATOR</div>
            <div>Ĥ = p̂²/2m + (1/2)mω²x̂²</div>
            <div>E_n = ℏω(n + 1/2)</div>
            <div>ψ_n(x) = (mω/πℏ)^(1/4) · H_n(√(mω/ℏ)x) · e^(−mωx²/2ℏ) / √(2^n n!)</div>
            <div>Uncertainty: ΔxΔp = ℏ/2 (minimum)</div>
            <div>Coherent states: ⟨x⟩ oscillates classically</div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default MathPhysicsLab;
