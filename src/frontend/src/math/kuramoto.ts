// ─── NOVA / PARALLAX — Full Kuramoto Engine ──────────────────────────────────
// Full port of KuramotoEngine.mo + MedinaMathFoundation kuramotoOrderParameter
// 18-organ frequency table, amplitude-weighted order parameter,
// critical coupling K_c, re-entrainment, saddle-node bifurcation detection.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, wrapPhase, PI, TAU, PHI, PHI_INV, NEURO_DT } from './core';

// ── 18-Organ natural frequencies (Hz-equivalent, from KuramotoEngine.mo) ─────
export const ORGAN_FREQS: Readonly<Record<string, number>> = {
  heart:     0.08,
  lungs:     0.05,
  brain:     0.12,
  liver:     0.03,
  kidneys:   0.02,
  gut:       0.10,
  spleen:    0.07,
  pancreas:  0.04,
  thyroid:   0.15,
  adrenals:  0.06,
  thymus:    0.09,
  skin:      0.11,
  marrow:    0.08,
  lymph:     0.04,
  gonads:    0.03,
  eyes:      0.05,
  ears:      0.02,
  spine:     0.13,
};

export const ORGAN_FREQ_ARRAY: number[] = Object.values(ORGAN_FREQS);

// ── Kuramoto Oscillator ───────────────────────────────────────────────────────
export interface KuramotoOscillator {
  phase:       number;  // θ ∈ [0, 2π)
  naturalFreq: number;  // ωᵢ (Hz equivalent)
  coupling:    number;  // local coupling strength
  amplitude:   number;  // signal strength ∈ [0,1]
}

export interface KuramotoOrderResult {
  r:   number;   // order parameter magnitude ∈ [0,1]
  psi: number;   // mean phase ψ = atan2(Σsin θ, Σcos θ)
}

// ── Amplitude-weighted order parameter ───────────────────────────────────────
// r·e^{iΨ} = (1/N) Σⱼ aⱼ·e^{iθⱼ}   (amplitude-weighted extension)
// Without amplitudes this reduces to standard r = |Σe^{iθⱼ}| / N
export function computeAmplitudeOrderParameter(oscs: KuramotoOscillator[]): KuramotoOrderResult {
  const n = oscs.length;
  if (!n) return { r: 0, psi: 0 };
  let sumCos = 0, sumSin = 0;
  for (const o of oscs) {
    sumCos += Math.cos(o.phase) * o.amplitude;
    sumSin += Math.sin(o.phase) * o.amplitude;
  }
  const r   = Math.sqrt(sumCos ** 2 + sumSin ** 2) / n;
  const psi = Math.atan2(sumSin, sumCos);
  return { r: clamp(r, 0, 1), psi };
}

// ── Standard order parameter (no amplitude weighting) ─────────────────────────
export function computeOrderParameter(phases: number[]): KuramotoOrderResult {
  const n = phases.length || 1;
  const sumCos = phases.reduce((s, p) => s + Math.cos(p), 0) / n;
  const sumSin = phases.reduce((s, p) => s + Math.sin(p), 0) / n;
  return {
    r:   clamp(Math.sqrt(sumCos ** 2 + sumSin ** 2), 0, 1),
    psi: Math.atan2(sumSin, sumCos),
  };
}

// ── Full Kuramoto ODE step ─────────────────────────────────────────────────────
// dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)   [standard]
// With local coupling: uses each oscillator's own coupling strength
export function kuramotoStep(
  oscs: KuramotoOscillator[],
  globalCoupling: number,   // K
  dt: number = NEURO_DT
): KuramotoOscillator[] {
  const N = oscs.length || 1;
  return oscs.map((o, i) => {
    const K_eff = (globalCoupling + o.coupling) / 2;
    const coupling = oscs.reduce((s, other, j) => {
      if (i === j) return s;
      return s + Math.sin(other.phase - o.phase);
    }, 0) * K_eff / N;
    const newPhase = wrapPhase(o.phase + (o.naturalFreq * TAU + coupling) * dt);
    return { ...o, phase: newPhase };
  });
}

// ── Critical coupling K_c ─────────────────────────────────────────────────────
// Phase transition occurs at K_c = 2 / (π · g(ω₀))
// where g(ω₀) = distribution density at the mean frequency ω₀.
// For a Lorentzian distribution: K_c = 2γ (half-width).
// Approximated from frequency spread:
export function criticalCoupling(naturalFreqs: number[]): number {
  if (!naturalFreqs.length) return 0.618;
  const mean = naturalFreqs.reduce((a, b) => a + b, 0) / naturalFreqs.length;
  const spread = Math.sqrt(naturalFreqs.reduce((s, f) => s + (f - mean) ** 2, 0) / naturalFreqs.length);
  // K_c ≈ 2·spread for Gaussian distribution
  return clamp(2 * spread, 0.1, 2.0);
}

// ── Phase transition detection ─────────────────────────────────────────────────
// Saddle-node bifurcation: r jumps discontinuously as K crosses K_c
export interface PhaseTransitionState {
  rHistory:      number[];   // last 50 r values
  K:             number;     // current coupling
  Kc:            number;     // critical coupling estimate
  inSynchronized: boolean;  // true if r > transition threshold
  transitionBeat: number | null;  // beat where transition occurred
}

export function detectPhaseTransition(state: PhaseTransitionState, r: number, beat: number): PhaseTransitionState {
  const SYNC_THRESHOLD = 0.70;
  const history = [...state.rHistory.slice(-49), r];
  const wasSync  = state.inSynchronized;
  const isSync   = r >= SYNC_THRESHOLD;
  return {
    ...state,
    rHistory:       history,
    inSynchronized: isSync,
    transitionBeat: (!wasSync && isSync) ? beat : state.transitionBeat,
  };
}

// ── Re-entrainment (trophallaxis-phase repair) ────────────────────────────────
// Force oscillator i toward the mean phase Ψ by strength s ∈ [0,1]
// dθᵢ/dt += s · sin(Ψ − θᵢ)
export function reEntrain(phase: number, psi: number, strength: number = 0.3, dt: number = NEURO_DT): number {
  const pull = strength * Math.sin(psi - phase);
  return wrapPhase(phase + pull * dt);
}

// ── Kuramoto synchronization entropy ─────────────────────────────────────────
// H_sync = −r · ln(r) − (1−r) · ln(1−r)   [phase synchronization entropy]
export function kuramotoSyncEntropy(r: number): number {
  const q = clamp(r, 0.001, 0.999);
  const p = clamp(1 - q, 0.001, 0.999);
  return -(q * Math.log(q) + p * Math.log(p));
}

// ── 18-Organ system Kuramoto state ───────────────────────────────────────────
export interface OrganKuramotoState {
  phases:    number[];   // 18 phases
  r:         number;     // global order parameter
  psi:       number;     // mean phase
  syncEntr:  number;     // synchronization entropy
  critK:     number;     // critical coupling
}

export function initOrganKuramoto(): OrganKuramotoState {
  return {
    phases:   ORGAN_FREQ_ARRAY.map((_, i) => (i / 18) * TAU),
    r:        0.5,
    psi:      0,
    syncEntr: 0.693,
    critK:    criticalCoupling(ORGAN_FREQ_ARRAY),
  };
}

export function stepOrganKuramoto(
  state: OrganKuramotoState,
  K: number = PHI_INV,
  dt: number = NEURO_DT
): OrganKuramotoState {
  const N = state.phases.length;
  const newPhases = state.phases.map((phi_i, i) => {
    const omega_i = (ORGAN_FREQ_ARRAY[i] ?? 0.05) * TAU;
    const coupling = state.phases.reduce((s, phi_j, j) => {
      if (i === j) return s;
      return s + Math.sin(phi_j - phi_i);
    }, 0) * K / N;
    return wrapPhase(phi_i + (omega_i + coupling) * dt);
  });
  const { r, psi } = computeOrderParameter(newPhases);
  return { phases: newPhases, r, psi, syncEntr: kuramotoSyncEntropy(r), critK: state.critK };
}

// ── Frequency Coherence K_f (from HzFrequencySubstrate.mo) ───────────────────
// K_f = 1 − (σ_f / f̄)²   where σ_f is frequency std dev, f̄ is mean
// K_f → 1 means all nodes oscillate at same frequency (coherent)
// K_f → 0 means fragmented oscillation
export function frequencyCoherence(frequencies: number[]): number {
  if (!frequencies.length) return 0;
  const mean = frequencies.reduce((a, b) => a + b, 0) / frequencies.length;
  if (mean < 1e-6) return 1;
  const variance = frequencies.reduce((s, f) => s + (f - mean) ** 2, 0) / frequencies.length;
  return clamp(1 - variance / (mean ** 2), 0, 1);
}
