// ─── NOVA / PARALLAX — Core Math Engine ──────────────────────────────────────
// Mirrors the Motoko backend math precisely.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// PROPRIETARY — All rights reserved.

// ── Constants (from AdvancedMathematicalFoundations.mo) ───────────────────────
export const PHI            = 1.6180339887498948482;  // Golden ratio φ
export const PHI_INV        = 0.6180339887498948482;  // 1/φ
export const EULER_E        = 2.7182818284590452354;  // e
export const PI             = 3.1415926535897932385;  // π
export const TAU            = 6.2831853071795864769;  // 2π
export const SQRT2          = 1.4142135623730950488;  // √2
export const SQRT3          = 1.7320508075688772935;  // √3
export const SQRT5          = 2.2360679774997896964;  // √5  (φ = (1+√5)/2)
export const LN2            = 0.6931471805599453094;  // ln(2)
export const ISING_2D_BETA  = 0.125;   // Order parameter exponent
export const ISING_2D_TC    = 2.269;   // Critical temperature (T_c/J)
export const PERC_2D_PC     = 0.5927;  // Bond percolation threshold
export const FEIGENBAUM_D   = 4.6692016091029906719; // Feigenbaum δ

// ── Sovereign Floor (S₀ = 1.0) ────────────────────────────────────────────────
// From MassiveScaleOrganismCore: no neurochemical may fall below S₀.
export const SOVEREIGN_FLOOR = 1.0;

// ── Primitive Math ────────────────────────────────────────────────────────────
export function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

/** Sovereign floor: enforce S₀=1.0 minimum on any neuro-metric */
export function sf(x: number): number {
  return Math.max(SOVEREIGN_FLOOR, x);
}

export function sigmoid(x: number): number {
  return 1.0 / (1.0 + Math.exp(-clamp(x, -10, 10)));
}

export function tanh(x: number): number {
  const e2 = Math.exp(2 * clamp(x, -20, 20));
  return (e2 - 1) / (e2 + 1);
}

export function softmax(xs: number[]): number[] {
  const m = Math.max(...xs);
  const exps = xs.map(x => Math.exp(x - m));
  const sum = exps.reduce((a, b) => a + b, 0.001);
  return exps.map(e => e / sum);
}

/** ReLU with optional leak */
export function relu(x: number, leak = 0.0): number {
  return x >= 0 ? x : leak * x;
}

/** Euclidean norm of vector */
export function norm(v: number[]): number {
  return Math.sqrt(v.reduce((s, x) => s + x * x, 0));
}

/** Dot product */
export function dot(a: number[], b: number[]): number {
  return a.reduce((s, x, i) => s + x * (b[i] ?? 0), 0);
}

/** Vector addition */
export function vadd(a: number[], b: number[]): number[] {
  return a.map((x, i) => x + (b[i] ?? 0));
}

/** Vector scale */
export function vscale(v: number[], s: number): number[] {
  return v.map(x => x * s);
}

/** Wrap phase into [−π, π] — from MassiveScaleOrganismCore */
export function wrapPhase(theta: number): number {
  let t = theta % TAU;
  if (t > PI) t -= TAU;
  if (t < -PI) t += TAU;
  return t;
}

/** Linearize phase difference for Kuramoto — Δφ ∈ [−π, π] */
export function phaseDiff(a: number, b: number): number {
  return wrapPhase(a - b);
}

/** Logistic growth: dN/dt = r·N·(1 − N/K) */
export function logisticStep(n: number, r: number, K: number, dt: number): number {
  return n + r * n * (1 - n / K) * dt;
}

/** Exponential moving average */
export function ema(prev: number, current: number, tau: number): number {
  const alpha = 1 / (1 + tau);
  return alpha * current + (1 - alpha) * prev;
}

/** Mahalanobis-like distance: (x − μ)² / σ² summed */
export function mahalanobisApprox(xs: number[], means: number[], stds: number[]): number {
  return xs.reduce((s, x, i) => {
    const sigma = Math.max(stds[i] ?? 0.01, 0.01);
    return s + ((x - (means[i] ?? 0)) / sigma) ** 2;
  }, 0) / (xs.length || 1);
}

/** z-score */
export function zScore(x: number, mean: number, std: number): number {
  return (x - mean) / Math.max(std, 0.001);
}

/** Landau free energy: F(m) = a·m² + b·m⁴ (symmetry-broken at a<0) */
export function landauFreeEnergy(m: number, a: number, b: number): number {
  return a * m * m + b * m * m * m * m;
}

/** Fisher information metric approximation: 1 / (p·(1−p)) */
export function fisherInfo(p: number): number {
  const q = clamp(p, 0.001, 0.999);
  return 1.0 / (q * (1 - q));
}

/** KL divergence: KL(P || Q) = Σ p·log(p/q) */
export function klDivergence(p: number[], q: number[]): number {
  return p.reduce((s, pi, i) => {
    if (pi <= 0) return s;
    const qi = Math.max(q[i] ?? 0.001, 0.001);
    return s + pi * Math.log(pi / qi);
  }, 0);
}

/** Jacobi drift magnitude J(t) — Lyapunov-style divergence from MassiveScaleOrganismCore */
export function computeJasmineDrift(phases: number[], cortisols: number[], signals: number[]): number {
  const n = phases.length || 1;
  const meanPh = phases.reduce((s, x) => s + x, 0) / n;
  const meanCo = cortisols.reduce((s, x) => s + x, 0) / n;
  const meanSg = signals.reduce((s, x) => s + x, 0) / n;
  const j1 = phases.reduce((s, x) => s + 0.4 * (x - meanPh) ** 2, 0) / n;
  const j2 = cortisols.reduce((s, x) => s + 0.3 * (x - meanCo) ** 2, 0) / n;
  const j3 = signals.reduce((s, x) => s + 0.3 * (x - meanSg) ** 2, 0) / n;
  return j1 + j2 + j3;
}

// ── Kuramoto Order Parameter ─────────────────────────────────────────────────
// r·e^{iΨ} = (1/N) Σ e^{iφⱼ}
// r ∈ [0,1]: 0 = incoherent, 1 = fully synchronized
// K = 0.618 (PHI_INV) — golden coupling constant

export const KURAMOTO_K = PHI_INV;   // 0.618

export function computeKuramotoOrder(phases: number[]): { r: number; psi: number } {
  const n = phases.length || 1;
  const sumCos = phases.reduce((s, p) => s + Math.cos(p), 0) / n;
  const sumSin = phases.reduce((s, p) => s + Math.sin(p), 0) / n;
  const r = clamp(Math.sqrt(sumCos ** 2 + sumSin ** 2), 0, 1);
  const psi = Math.atan2(sumSin, sumCos);
  return { r, psi };
}

/** Kuramoto phase update for one oscillator:
 *  dφᵢ/dt = ωᵢ + (K/N) Σⱼ sin(φⱼ − φᵢ)
 */
export function kuramotoPhaseStep(
  phi_i: number,
  omega_i: number,
  phases: number[],
  K: number = KURAMOTO_K,
  dt: number = 0.05
): number {
  const N = phases.length || 1;
  const coupling = phases.reduce((s, phi_j) => s + Math.sin(phi_j - phi_i), 0) * K / N;
  return wrapPhase(phi_i + (omega_i + coupling) * dt);
}

// ── Neurochemical ODE System ──────────────────────────────────────────────────
// 4-species: DOPAMINE (D), CORTISOL (C), NOREPINEPHRINE (N), OXYTOCIN (O)
// All gated by sovereign floor S₀ = 1.0 (sf())
// Euler integration dt = 0.05

export const NEURO_DT = 0.05;

export interface NeurochemicalState {
  dopamine:       number; // D — reward, consolidation
  cortisol:       number; // C — stress, danger
  norepinephrine: number; // N — arousal, alertness
  oxytocin:       number; // O — bonding, cohesion
}

export interface NeurochemicalBaseline extends NeurochemicalState {}

export const CHEM_BASELINES: Record<string, NeurochemicalBaseline> = {
  SCOUT:     { dopamine: 1.0, cortisol: 1.0, norepinephrine: 1.5, oxytocin: 1.0 },
  STRIKER:   { dopamine: 1.0, cortisol: 1.3, norepinephrine: 1.2, oxytocin: 1.0 },
  GUARDIAN:  { dopamine: 1.0, cortisol: 1.1, norepinephrine: 1.0, oxytocin: 1.5 },
  RELAY:     { dopamine: 1.5, cortisol: 1.0, norepinephrine: 1.0, oxytocin: 1.0 },
  MEDIC:     { dopamine: 1.0, cortisol: 1.0, norepinephrine: 1.0, oxytocin: 1.5 },
  SOVEREIGN: { dopamine: 1.2, cortisol: 1.2, norepinephrine: 1.2, oxytocin: 1.2 },
  WORKER:    { dopamine: 1.0, cortisol: 1.0, norepinephrine: 1.0, oxytocin: 1.0 },
};

/**
 * Coupled neurochemical ODEs — Euler step.
 *
 * dD/dt = 0.5·r·E − 0.15·(D − D₀)        [reward from coherence × energy]
 * dC/dt = 0.8·J − 0.20·O·(C−1) − 0.10·(C − C₀)  [stress from Jasmine drift]
 * dN/dt = 0.6·max(0, C−C₀) − 0.25·(N − N₀)   [arousal from cortisol excess]
 * dO/dt = 0.4·Ĥ + 0.3·r − 0.20·(O − O₀)    [bonding from Hebbian + coherence]
 */
export function neurochemStep(
  state: NeurochemicalState,
  baseline: NeurochemicalBaseline,
  rSwarm: number,   // Kuramoto order r ∈ [0,1]
  jDrift: number,   // Jasmine drift J(t)
  energy: number,   // drone energy ∈ [0,2]
  meanHebb: number, // mean Hebbian weight
  dt: number = NEURO_DT
): NeurochemicalState {
  const { dopamine: D, cortisol: C, norepinephrine: N, oxytocin: O } = state;
  const { dopamine: D0, cortisol: C0, norepinephrine: N0, oxytocin: O0 } = baseline;
  const E = clamp(energy, 0, 2);

  const dD = (0.5 * rSwarm * E - 0.15 * (D - D0)) * dt;
  const corExcess = Math.max(0, C - 1.0);
  const dC = (0.8 * jDrift - 0.20 * O * corExcess - 0.10 * (C - C0)) * dt;
  const dN = (0.6 * Math.max(0, C - C0) - 0.25 * (N - N0)) * dt;
  const dO = (0.4 * meanHebb + 0.3 * rSwarm - 0.20 * (O - O0)) * dt;

  return {
    dopamine:       sf(D + dD),
    cortisol:       sf(C + dC),
    norepinephrine: sf(N + dN),
    oxytocin:       sf(O + dO),
  };
}

// ── 6-Node Micro-Brain ────────────────────────────────────────────────────────
// Nodes: 0=SENSOR 1=MEMORY 2=EXECUTIVE 3=EMOTIONAL 4=MOTOR 5=OUTPUT
// Neurochemicals gate each node's bias. Two settling passes (recurrent).

export const BRAIN_NODES = 6;
export const BRAIN_NODE_NAMES = ['SENSOR', 'MEMORY', 'EXECUTIVE', 'EMOTIONAL', 'MOTOR', 'OUTPUT'] as const;
export type BrainNodeName = typeof BRAIN_NODE_NAMES[number];

export const STDP_ALPHA = 0.005;  // learning rate
export const STDP_DECAY = 0.001;  // weight decay

/**
 * Compute neurochemical bias for each of the 6 brain nodes.
 * Excess above S₀ modulates the corresponding node's gain.
 */
export function brainBias(
  chem: NeurochemicalState,
  architectSignal: number
): number[] {
  const { dopamine: D, cortisol: C, norepinephrine: N, oxytocin: O } = chem;
  return [
    N * 0.25,                               // SENSOR: arousal sharpens
    D * 0.20,                               // MEMORY: dopamine consolidates
    D * 0.15 - C * 0.10,                   // EXECUTIVE: reward on, stress off
    C * 0.30 + N * 0.20,                   // EMOTIONAL: stress + arousal
    N * 0.35,                               // MOTOR: arousal drives action
    O * 0.20 + architectSignal * 0.30,      // OUTPUT: cohesion + command
  ];
}

/**
 * Forward pass through the 6×6 recurrent brain weight matrix.
 * Two settling passes; returns activation[0..5].
 */
export function brainForwardPass(
  prevActivations: number[],
  weights: number[],         // flat 6×6 row-major
  bias: number[]
): number[] {
  let act = [...prevActivations];
  for (let pass = 0; pass < 2; pass++) {
    const next = Array(BRAIN_NODES).fill(0) as number[];
    for (let i = 0; i < BRAIN_NODES; i++) {
      let sum = bias[i] ?? 0;
      for (let j = 0; j < BRAIN_NODES; j++) {
        sum += (weights[i * BRAIN_NODES + j] ?? 0.5) * (act[j] ?? 0.5);
      }
      next[i] = sigmoid(sum);
    }
    act = next;
  }
  return act;
}

/**
 * STDP / BCM weight update:
 * Δw_{ij} = α·pre_j·post_i − decay·w_{ij}
 */
export function stdpUpdate(weights: number[], activations: number[]): number[] {
  return weights.map((w, idx) => {
    const i = Math.floor(idx / BRAIN_NODES);
    const j = idx % BRAIN_NODES;
    const dw = STDP_ALPHA * (activations[i] ?? 0.5) * (activations[j] ?? 0.5)
             - STDP_DECAY * w;
    return clamp(w + dw, 0.1, 3.0);
  });
}

/**
 * Hebbian inter-drone weight update for swarm coherence matrix.
 * Δw_{ij} = α·signal_i·signal_j − decay·w_{ij}
 * W-ceiling = 2.0  (HELIX_ALPHA = 0.01)
 */
export const HELIX_ALPHA = 0.01;
export const W_CEIL      = 2.0;

export function hebbianUpdate(
  w: number,
  sig_i: number,
  sig_j: number,
  alpha: number = HELIX_ALPHA,
  decay: number = 0.001
): number {
  return clamp(w + alpha * sig_i * sig_j - decay * w, 0, W_CEIL);
}

// ── Quantum Cognitive Channels ────────────────────────────────────────────────
// 4 channels: α=spatial/sensor  β=temporal/memory  γ=relational  δ=executive-motor
// Channel time constant τ = 10 beats (CHAN_TAU)

export const CHAN_TAU  = 10.0;
export const NOW_RATE  = 0.05;

export interface QuantumChannels {
  alpha:       number;  // spatial / sensor
  beta:        number;  // temporal / memory
  gamma:       number;  // relational
  delta:       number;  // executive-motor
  convergence: number;  // alignment of all 4 channels ∈ [0,1]
  coherence:   number;  // internal + swarm alignment ∈ [0,1]
  nowAttention: number; // present-moment weight ∈ [0,1]
}

/** Update quantum channel α toward target via exponential relaxation */
function channelStep(current: number, target: number, tau: number, dt: number): number {
  return current + (target - current) * dt / tau;
}

/** Compute 4-channel convergence: how much all channels agree */
export function computeConvergence(ch: QuantumChannels): number {
  const vals = [ch.alpha, ch.beta, ch.gamma, ch.delta];
  const mean = vals.reduce((s, v) => s + v, 0) / 4;
  const variance = vals.reduce((s, v) => s + (v - mean) ** 2, 0) / 4;
  return Math.exp(-variance * 4);  // 1 = identical, 0 = max divergence
}

/** Update quantum channels from neurochemical state and swarm coherence */
export function quantumChannelStep(
  ch: QuantumChannels,
  chem: NeurochemicalState,
  rSwarm: number,
  dt: number = NEURO_DT
): QuantumChannels {
  const { dopamine: D, cortisol: C, norepinephrine: N, oxytocin: O } = chem;
  const target_alpha = clamp(N * 0.4 + rSwarm * 0.3, 0, 1);
  const target_beta  = clamp(D * 0.35 + ch.nowAttention * 0.2, 0, 1);
  const target_gamma = clamp(O * 0.45 + rSwarm * 0.25, 0, 1);
  const target_delta = clamp(N * 0.3 - C * 0.2 + 0.5, 0, 1);

  const next: QuantumChannels = {
    alpha:       channelStep(ch.alpha,  target_alpha,  CHAN_TAU, dt),
    beta:        channelStep(ch.beta,   target_beta,   CHAN_TAU, dt),
    gamma:       channelStep(ch.gamma,  target_gamma,  CHAN_TAU, dt),
    delta:       channelStep(ch.delta,  target_delta,  CHAN_TAU, dt),
    convergence: 0,
    coherence:   0,
    nowAttention: ch.nowAttention + (1 - ch.nowAttention) * NOW_RATE * dt,
  };
  next.convergence = computeConvergence(next);
  next.coherence   = clamp(next.convergence * rSwarm, 0, 1);
  return next;
}

// ── Energy Model ──────────────────────────────────────────────────────────────
export const ENERGY_REPLENISH   = 0.015;
export const ENERGY_SIGNAL_COST = 0.003;
export const ENERGY_BRAIN_COST  = 0.002;
export const ENERGY_MOVE_COST   = 0.005;

export function energyStep(
  energy: number,
  signal: number,
  brainActivations: number[],
  velX: number,
  velZ: number
): number {
  const meanAct = brainActivations.reduce((s, a) => s + a, 0) / (brainActivations.length || 1);
  const speed   = Math.sqrt(velX ** 2 + velZ ** 2);
  const next = energy
    + ENERGY_REPLENISH
    - ENERGY_SIGNAL_COST * signal
    - ENERGY_BRAIN_COST  * meanAct
    - ENERGY_MOVE_COST   * speed;
  return clamp(next, 0.2, 2.0);
}

// ── Scoring Models (from problem statement) ───────────────────────────────────
// These scores drive routing, autonomy, approvals, escalation, and rendering.

/**
 * Continuity Score K_c
 * K_c = 1 − (λ₁·G + λ₂·L + λ₃·X + λ₄·H + λ₅·D)
 *   G = context gap          λ₁ = 0.25
 *   L = lost references      λ₂ = 0.20
 *   X = contradiction burden λ₃ = 0.20
 *   H = handoff breakage     λ₄ = 0.20
 *   D = memory decay/drift   λ₅ = 0.15
 */
export interface ContinuityInputs {
  contextGap:         number;  // G ∈ [0,1]
  lostReferences:     number;  // L ∈ [0,1]
  contradictionBurden: number; // X ∈ [0,1]
  handoffBreakage:    number;  // H ∈ [0,1]
  memoryDecay:        number;  // D ∈ [0,1]
}

export function continuityScore(inp: ContinuityInputs): number {
  const { contextGap: G, lostReferences: L, contradictionBurden: X, handoffBreakage: H, memoryDecay: D } = inp;
  return clamp(1 - (0.25 * G + 0.20 * L + 0.20 * X + 0.20 * H + 0.15 * D), 0, 1);
}

/**
 * Work Priority Score P_w
 * P_w = a·U + b·R + c·T + d·B + e·S + f·O
 *   U = unresolved burden     a = 0.25
 *   R = risk                  b = 0.20
 *   T = time urgency          c = 0.20
 *   B = business impact       d = 0.15
 *   S = salience              e = 0.10
 *   O = organizational dep    f = 0.10
 */
export interface WorkPriorityInputs {
  unresolvedBurden:       number;  // U ∈ [0,1]
  risk:                   number;  // R ∈ [0,1]
  timeUrgency:            number;  // T ∈ [0,1]
  businessImpact:         number;  // B ∈ [0,1]
  salience:               number;  // S ∈ [0,1]
  organizationalDependency: number; // O ∈ [0,1]
}

export function workPriorityScore(inp: WorkPriorityInputs): number {
  const { unresolvedBurden: U, risk: R, timeUrgency: T, businessImpact: B, salience: S, organizationalDependency: O } = inp;
  return clamp(0.25 * U + 0.20 * R + 0.20 * T + 0.15 * B + 0.10 * S + 0.10 * O, 0, 1);
}

/**
 * Trust Score T_s
 * T_s = m₁·C + m₂·L + m₃·R − m₄·A − m₅·V
 *   C = continuity quality         m₁ = 0.30
 *   L = lineage completeness       m₂ = 0.25
 *   R = review confidence          m₃ = 0.20
 *   A = anomaly burden             m₄ = 0.15
 *   V = version conflict burden    m₅ = 0.10
 */
export interface TrustInputs {
  continuityQuality:     number;  // C ∈ [0,1]
  lineageCompleteness:   number;  // L ∈ [0,1]
  reviewConfidence:      number;  // R ∈ [0,1]
  anomalyBurden:         number;  // A ∈ [0,1]
  versionConflictBurden: number;  // V ∈ [0,1]
}

export function trustScore(inp: TrustInputs): number {
  const { continuityQuality: C, lineageCompleteness: L, reviewConfidence: R, anomalyBurden: A, versionConflictBurden: V } = inp;
  return clamp(0.30 * C + 0.25 * L + 0.20 * R - 0.15 * A - 0.10 * V, 0, 1);
}

/**
 * Anomaly Score A_s
 * A_s = 0.35·M + 0.30·I + 0.20·Z + 0.15·F
 *   M = Mahalanobis-like abnormality   0.35
 *   I = isolation-forest signal        0.30
 *   Z = z-score excursion              0.20
 *   F = fingerprint deviation          0.15
 */
export interface AnomalyInputs {
  mahalanobisAbnormality: number;  // M ∈ [0,1]
  isolationForestSignal:  number;  // I ∈ [0,1]
  zScoreExcursion:        number;  // Z ∈ [0,1]
  fingerprintDeviation:   number;  // F ∈ [0,1]
}

export function anomalyScore(inp: AnomalyInputs): number {
  const { mahalanobisAbnormality: M, isolationForestSignal: I, zScoreExcursion: Z, fingerprintDeviation: F } = inp;
  return clamp(0.35 * M + 0.30 * I + 0.20 * Z + 0.15 * F, 0, 1);
}

/**
 * Conflict Severity Score C_s
 * C_s = α·D_f + β·D_t + γ·D_u + δ·D_a + ε·D_o
 *   D_f = field divergence           α = 0.25
 *   D_t = timing divergence          β = 0.20
 *   D_u = user/role divergence       γ = 0.20
 *   D_a = attachment divergence      δ = 0.20
 *   D_o = operational consequence    ε = 0.15
 */
export interface ConflictSeverityInputs {
  fieldDivergence:       number;  // D_f ∈ [0,1]
  timingDivergence:      number;  // D_t ∈ [0,1]
  userRoleDivergence:    number;  // D_u ∈ [0,1]
  attachmentDivergence:  number;  // D_a ∈ [0,1]
  operationalConsequence: number; // D_o ∈ [0,1]
}

export function conflictSeverityScore(inp: ConflictSeverityInputs): number {
  const { fieldDivergence: Df, timingDivergence: Dt, userRoleDivergence: Du, attachmentDivergence: Da, operationalConsequence: Do } = inp;
  return clamp(0.25 * Df + 0.20 * Dt + 0.20 * Du + 0.20 * Da + 0.15 * Do, 0, 1);
}

/**
 * Artifact Trust Score T_a
 * T_a = n₁·T_s + n₂·K_c + n₃·E_v − n₄·A_s
 *   T_s = trust score                n₁ = 0.35
 *   K_c = continuity score           n₂ = 0.30
 *   E_v = evidence completeness      n₃ = 0.25
 *   A_s = anomaly score              n₄ = 0.10
 */
export function artifactTrustScore(Ts: number, Kc: number, Ev: number, As: number): number {
  return clamp(0.35 * Ts + 0.30 * Kc + 0.25 * Ev - 0.10 * As, 0, 1);
}

/**
 * Load / Pulse Score L_p
 * L_p = r₁·Q + r₂·N + r₃·B + r₄·A + r₅·W
 *   Q = queue burden          r₁ = 0.30
 *   N = notification burden   r₂ = 0.20
 *   B = blocker burden        r₃ = 0.20
 *   A = anomaly burden        r₄ = 0.15
 *   W = workload pressure     r₅ = 0.15
 */
export interface LoadPulseInputs {
  queueBurden:        number;  // Q ∈ [0,1]
  notificationBurden: number;  // N ∈ [0,1]
  blockerBurden:      number;  // B ∈ [0,1]
  anomalyBurden:      number;  // A ∈ [0,1]
  workloadPressure:   number;  // W ∈ [0,1]
}

export function loadPulseScore(inp: LoadPulseInputs): number {
  const { queueBurden: Q, notificationBurden: N, blockerBurden: B, anomalyBurden: A, workloadPressure: W } = inp;
  return clamp(0.30 * Q + 0.20 * N + 0.20 * B + 0.15 * A + 0.15 * W, 0, 1);
}

/**
 * Simulation Confidence Score SC
 * SC = w₁·K_c + w₂·T_s + w₃·(1 − A_s) + w₄·r
 *   K_c = continuity    w₁ = 0.30
 *   T_s = trust         w₂ = 0.25
 *   1−A_s = not-anomaly w₃ = 0.25
 *   r   = Kuramoto order w₄ = 0.20
 */
export function simulationConfidenceScore(Kc: number, Ts: number, As: number, r: number): number {
  return clamp(0.30 * Kc + 0.25 * Ts + 0.25 * (1 - As) + 0.20 * r, 0, 1);
}

// ── FORMA Token Compounding ───────────────────────────────────────────────────
// From ArchitectureDoc: FORMA × thyroid × T3 × chronoDilation × jacobMult × dopamine
// Genesis floor: 1,000 FORMA

export const FORMA_GENESIS_FLOOR = 1000;

export function formaCompound(
  forma: number,
  thyroid: number,   // typically ∈ [0.9, 1.1]
  t3: number,        // T3 hormone factor
  chronoDilation: number, // time-dilation factor ∈ [0.8, 1.2]
  jacobMult: number,      // Jacobi multiplier (inversely related to J(t))
  dopamine: number        // reward signal
): number {
  const raw = forma * thyroid * t3 * chronoDilation * jacobMult * dopamine;
  return Math.max(raw, FORMA_GENESIS_FLOOR);
}

// ── Shell Architecture Tier Compounding ──────────────────────────────────────
// 43-core tier system: compound rate = tier_number / 9
// Tier 9 (cores 40-42) = 9× compounding

export function tierCompoundRate(tier: number): number {
  return tier / 9.0;
}

// ── Heritage Node Activation ──────────────────────────────────────────────────
// 7 Heritage nodes: REVOLUCIONARIO, ZAPATA, VILLA, INDEPENDENCIA, HIDALGO, ADELITA, MORELOS
export const HERITAGE_NODES = [
  'REVOLUCIONARIO', 'ZAPATA', 'VILLA', 'INDEPENDENCIA', 'HIDALGO', 'ADELITA', 'MORELOS',
] as const;
export type HeritageNode = typeof HERITAGE_NODES[number];

// ── Faction Resistance (Law 24) ───────────────────────────────────────────────
export const FACTION_DOMINANCE_THRESHOLD = 0.7;
export const FACTION_NOR_MULTIPLIER      = 1.3;
export const FACTION_SIGNAL_MULTIPLIER   = 1.1;

export function applyFactionResistance(
  signal: number,
  norepinephrine: number,
  dominanceRatio: number
): { signal: number; norepinephrine: number } {
  if (dominanceRatio > FACTION_DOMINANCE_THRESHOLD) {
    return {
      signal:         signal * FACTION_SIGNAL_MULTIPLIER,
      norepinephrine: norepinephrine * FACTION_NOR_MULTIPLIER,
    };
  }
  return { signal, norepinephrine };
}

// ── Gradient Field Equations ──────────────────────────────────────────────────
// Gradient fields turn macro-state into spatial pressure maps.
// Each field is a 2D array (gridW × gridH) of floats in [0,1].

export type GradientGrid = number[];

/** Gaussian pressure kernel at (cx, cy) with radius r */
export function gaussianKernel(
  grid: GradientGrid,
  gridW: number, gridH: number,
  cx: number, cy: number,
  radius: number,
  magnitude: number
): GradientGrid {
  const out = [...grid] as GradientGrid;
  for (let row = 0; row < gridH; row++) {
    for (let col = 0; col < gridW; col++) {
      const dx = col - cx;
      const dy = row - cy;
      const d2 = dx * dx + dy * dy;
      const g = magnitude * Math.exp(-d2 / (2 * radius * radius));
      const idx = row * gridW + col;
      out[idx] = Math.min(1, (out[idx] ?? 0) + g);
    }
  }
  return out;
}

/** Diffuse a gradient field by one step (isotropic diffusion) */
export function diffuseField(
  field: GradientGrid,
  gridW: number, gridH: number,
  diffusionRate: number = 0.1
): GradientGrid {
  const out: GradientGrid = new Array(field.length).fill(0);
  for (let r = 0; r < gridH; r++) {
    for (let c = 0; c < gridW; c++) {
      const i   = r * gridW + c;
      const up  = (r > 0)         ? field[(r-1) * gridW + c]! : field[i]!;
      const dn  = (r < gridH - 1) ? field[(r+1) * gridW + c]! : field[i]!;
      const lt  = (c > 0)         ? field[r * gridW + (c-1)]! : field[i]!;
      const rt  = (c < gridW - 1) ? field[r * gridW + (c+1)]! : field[i]!;
      const lap = (up + dn + lt + rt - 4 * (field[i] ?? 0));
      out[i] = clamp((field[i] ?? 0) + diffusionRate * lap, 0, 1);
    }
  }
  return out;
}

/** Decay a gradient field toward zero */
export function decayField(field: GradientGrid, decayRate: number = 0.005): GradientGrid {
  return field.map(v => Math.max(0, v * (1 - decayRate)));
}

// ── Morphogenesis Grammar ─────────────────────────────────────────────────────
// Translates gradient fields into world-structure decisions.

export type WorldStructureClass =
  | 'territory'
  | 'hub'
  | 'road'
  | 'scar'
  | 'ruin'
  | 'fortification'
  | 'biome'
  | 'anomaly'
  | 'domain';

export interface MorphogenesisRule {
  structureClass:  WorldStructureClass;
  coherenceMin:    number;  // coherence field threshold to trigger
  pressureMin:     number;  // pressure field threshold to trigger
  stabilityMin:    number;  // stability field threshold to trigger
  damageMax:       number;  // max damage field before rule fires differently
  lawDensityMin:   number;  // law density required
  trafficMin:      number;  // traffic/flow required for roads
}

export const MORPHOGENESIS_RULES: MorphogenesisRule[] = [
  { structureClass: 'hub',          coherenceMin: 0.70, pressureMin: 0.0, stabilityMin: 0.60, damageMax: 0.30, lawDensityMin: 0.50, trafficMin: 0.60 },
  { structureClass: 'fortification',coherenceMin: 0.50, pressureMin: 0.60, stabilityMin: 0.40, damageMax: 0.50, lawDensityMin: 0.40, trafficMin: 0.30 },
  { structureClass: 'road',         coherenceMin: 0.30, pressureMin: 0.0, stabilityMin: 0.30, damageMax: 0.40, lawDensityMin: 0.20, trafficMin: 0.70 },
  { structureClass: 'territory',    coherenceMin: 0.50, pressureMin: 0.0, stabilityMin: 0.40, damageMax: 0.60, lawDensityMin: 0.30, trafficMin: 0.0 },
  { structureClass: 'scar',         coherenceMin: 0.0,  pressureMin: 0.0, stabilityMin: 0.0,  damageMax: 1.0,  lawDensityMin: 0.0,  trafficMin: 0.0 },
  { structureClass: 'ruin',         coherenceMin: 0.0,  pressureMin: 0.0, stabilityMin: 0.0,  damageMax: 1.0,  lawDensityMin: 0.0,  trafficMin: 0.0 },
  { structureClass: 'anomaly',      coherenceMin: 0.0,  pressureMin: 0.70, stabilityMin: 0.0,  damageMax: 1.0,  lawDensityMin: 0.0,  trafficMin: 0.0 },
  { structureClass: 'biome',        coherenceMin: 0.40, pressureMin: 0.0, stabilityMin: 0.50, damageMax: 0.40, lawDensityMin: 0.35, trafficMin: 0.0 },
  { structureClass: 'domain',       coherenceMin: 0.80, pressureMin: 0.0, stabilityMin: 0.70, damageMax: 0.20, lawDensityMin: 0.70, trafficMin: 0.50 },
];

// ── Materialization States ────────────────────────────────────────────────────
export type MaterialState =
  | 'fluid'
  | 'semi-stable'
  | 'crystallized'
  | 'decayed'
  | 'anomalous'
  | 'memory-anchored'
  | 'sacred';  // law-dense, highest permanence

/** Determine material state from coherence, damage, age, and law-density */
export function materializationState(
  coherence: number,
  damage: number,
  age: number,       // beats since creation
  lawDensity: number
): MaterialState {
  if (lawDensity > 0.80 && coherence > 0.80) return 'sacred';
  if (coherence > 0.85 && damage < 0.15 && age > 50) return 'crystallized';
  if (damage > 0.70) return 'decayed';
  if (coherence < 0.25 || damage > 0.50) return 'anomalous';
  if (age > 100 && coherence > 0.60) return 'memory-anchored';
  if (coherence > 0.50) return 'semi-stable';
  return 'fluid';
}

// ── Domain Unlock Thresholds ──────────────────────────────────────────────────
export interface DomainUnlockRule {
  domainId:         string;
  coherenceRequired: number;
  stabilityRequired: number;
  lawDensityRequired: number;
  ageRequired:       number;   // beats
  label:            string;
}

export const DOMAIN_UNLOCK_RULES: DomainUnlockRule[] = [
  { domainId: 'NEXUS',        coherenceRequired: 0.70, stabilityRequired: 0.60, lawDensityRequired: 0.50, ageRequired: 50,  label: 'Nexus Hub Zone' },
  { domainId: 'APEX',         coherenceRequired: 0.85, stabilityRequired: 0.75, lawDensityRequired: 0.70, ageRequired: 100, label: 'Apex Sovereign Domain' },
  { domainId: 'MEMORIA',      coherenceRequired: 0.60, stabilityRequired: 0.50, lawDensityRequired: 0.40, ageRequired: 80,  label: 'Memory Sediment Zone' },
  { domainId: 'BATTLEGROUND', coherenceRequired: 0.20, stabilityRequired: 0.10, lawDensityRequired: 0.10, ageRequired: 30,  label: 'Active Conflict Domain' },
  { domainId: 'SANCTUARY',    coherenceRequired: 0.90, stabilityRequired: 0.85, lawDensityRequired: 0.80, ageRequired: 150, label: 'Sacred Sanctuary Domain' },
];

export function checkDomainUnlock(
  rule: DomainUnlockRule,
  coherence: number,
  stability: number,
  lawDensity: number,
  age: number
): boolean {
  return (
    coherence  >= rule.coherenceRequired &&
    stability  >= rule.stabilityRequired &&
    lawDensity >= rule.lawDensityRequired &&
    age        >= rule.ageRequired
  );
}
