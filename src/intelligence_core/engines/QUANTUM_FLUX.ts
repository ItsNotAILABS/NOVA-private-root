// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// QUANTUM_FLUX ENGINE — Sovereign Entropy & Randomness Engine (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// QUANTUM_FLUX is the "physics of entropy" for the organism. All randomness, stochastic
// processes, and entropy-driven decisions flow through here. This is NOT Math.random() —
// this is a living entropy engine with φ-weighted noise, Gaussian distributions,
// and quantum-inspired randomness.
//
// Used by: CORPUS (stochastic behavior), SENSUS (noise filtering), ANIMUS (exploration)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { PHI, PHI_INV, clamp, PI, TAU } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — ENTROPY STATE
// ═══════════════════════════════════════════════════════════════════════════════

export interface EntropyPool {
  seed: number;
  state: number[];   // Internal state array
  index: number;
  entropy: number;   // Current entropy measure
  samples: number;
}

export interface QuantumFluxState {
  pool: EntropyPool;
  beat: number;
  totalSamples: number;
  entropyHistory: number[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — PRNG — Xorshift128+ (fast, high-quality)
// ═══════════════════════════════════════════════════════════════════════════════

function xorshift128plus(state: number[]): number {
  let s1 = state[0]!;
  const s0 = state[1]!;
  state[0] = s0;
  s1 ^= s1 << 23;
  s1 ^= s1 >>> 17;
  s1 ^= s0;
  s1 ^= s0 >>> 26;
  state[1] = s1;
  return (s0 + s1) >>> 0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — QUANTUM FLUX ENGINE CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class QuantumFluxEngine {
  private state: QuantumFluxState;

  constructor(seed?: number) {
    const actualSeed = seed ?? (Date.now() ^ (Math.random() * 0xffffffff));
    
    this.state = {
      pool: {
        seed: actualSeed,
        state: [actualSeed, actualSeed ^ 0xdeadbeef],
        index: 0,
        entropy: 1.0,
        samples: 0,
      },
      beat: 0,
      totalSamples: 0,
      entropyHistory: [],
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CORE RANDOMNESS
  // ─────────────────────────────────────────────────────────────────────────────

  /** Raw [0, 1) uniform random */
  random(): number {
    const raw = xorshift128plus(this.state.pool.state);
    this.state.pool.samples++;
    this.state.totalSamples++;
    return raw / 0xffffffff;
  }

  /** Uniform [min, max) */
  uniform(min: number = 0, max: number = 1): number {
    return min + this.random() * (max - min);
  }

  /** Integer [min, max] inclusive */
  integer(min: number, max: number): number {
    return Math.floor(this.uniform(min, max + 1));
  }

  /** Boolean with given probability of true */
  chance(probability: number = 0.5): boolean {
    return this.random() < probability;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // GAUSSIAN (Box-Muller Transform)
  // ─────────────────────────────────────────────────────────────────────────────

  private _spare: number | null = null;

  gaussian(mean: number = 0, stddev: number = 1): number {
    if (this._spare !== null) {
      const result = this._spare * stddev + mean;
      this._spare = null;
      return result;
    }

    let u, v, s;
    do {
      u = this.random() * 2 - 1;
      v = this.random() * 2 - 1;
      s = u * u + v * v;
    } while (s >= 1 || s === 0);

    const mul = Math.sqrt(-2 * Math.log(s) / s);
    this._spare = v * mul;
    return u * mul * stddev + mean;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // φ-WEIGHTED NOISE
  // ─────────────────────────────────────────────────────────────────────────────

  /** Noise biased toward φ-scaled values */
  phiNoise(amplitude: number = 1): number {
    const base = this.gaussian(0, amplitude * PHI_INV);
    const harmonic = this.gaussian(0, amplitude * PHI_INV * PHI_INV);
    return base + harmonic * PHI_INV;
  }

  /** Noise scaled by golden ratio power */
  phiScaledNoise(power: number = 1, amplitude: number = 1): number {
    const scale = Math.pow(PHI, power);
    return this.gaussian(0, amplitude / scale);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DISTRIBUTIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /** Exponential distribution */
  exponential(rate: number = 1): number {
    return -Math.log(1 - this.random()) / rate;
  }

  /** Poisson distribution (for rare events) */
  poisson(lambda: number): number {
    const L = Math.exp(-lambda);
    let k = 0;
    let p = 1;
    do {
      k++;
      p *= this.random();
    } while (p > L);
    return k - 1;
  }

  /** Pareto distribution (80/20 rule) */
  pareto(alpha: number = 1, xm: number = 1): number {
    return xm / Math.pow(this.random(), 1 / alpha);
  }

  /** Pick random element from array */
  pick<T>(array: T[]): T | undefined {
    if (array.length === 0) return undefined;
    return array[Math.floor(this.random() * array.length)];
  }

  /** Weighted random selection */
  weightedPick<T>(items: T[], weights: number[]): T | undefined {
    if (items.length === 0 || weights.length === 0) return undefined;
    
    const total = weights.reduce((s, w) => s + w, 0);
    let r = this.random() * total;
    
    for (let i = 0; i < items.length; i++) {
      r -= weights[i]!;
      if (r <= 0) return items[i];
    }
    return items[items.length - 1];
  }

  /** Shuffle array in place */
  shuffle<T>(array: T[]): T[] {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(this.random() * (i + 1));
      [array[i], array[j]] = [array[j]!, array[i]!];
    }
    return array;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // NOISE FUNCTIONS (coherent noise)
  // ─────────────────────────────────────────────────────────────────────────────

  /** 1D Perlin-like noise */
  noise1D(x: number): number {
    const xi = Math.floor(x);
    const xf = x - xi;
    
    // Smoothstep
    const t = xf * xf * (3 - 2 * xf);
    
    // Pseudo-random gradients
    const g0 = this._hash1D(xi) * 2 - 1;
    const g1 = this._hash1D(xi + 1) * 2 - 1;
    
    // Dot products
    const d0 = g0 * xf;
    const d1 = g1 * (xf - 1);
    
    return d0 + t * (d1 - d0);
  }

  private _hash1D(x: number): number {
    // Deterministic hash for noise
    const h = Math.sin(x * 127.1 + this.state.pool.seed * 0.0001) * 43758.5453;
    return h - Math.floor(h);
  }

  /** Fractal Brownian Motion */
  fbm(x: number, octaves: number = 4, lacunarity: number = PHI, gain: number = PHI_INV): number {
    let value = 0;
    let amplitude = 1;
    let frequency = 1;
    
    for (let i = 0; i < octaves; i++) {
      value += amplitude * this.noise1D(x * frequency);
      frequency *= lacunarity;
      amplitude *= gain;
    }
    
    return value;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TICK — Entropy evolution
  // ─────────────────────────────────────────────────────────────────────────────

  tick(): void {
    this.state.beat++;
    
    // Compute entropy from recent samples
    const recentSamples: number[] = [];
    for (let i = 0; i < 100; i++) {
      recentSamples.push(this.random());
    }
    
    // Shannon entropy approximation
    const bins = new Array(10).fill(0);
    for (const s of recentSamples) {
      bins[Math.floor(s * 10)] = (bins[Math.floor(s * 10)] ?? 0) + 1;
    }
    
    let entropy = 0;
    for (const count of bins) {
      if (count > 0) {
        const p = count / 100;
        entropy -= p * Math.log2(p);
      }
    }
    
    this.state.pool.entropy = entropy / Math.log2(10); // Normalize to [0, 1]
    this.state.entropyHistory.push(this.state.pool.entropy);
    if (this.state.entropyHistory.length > 50) {
      this.state.entropyHistory.shift();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SEEDING
  // ─────────────────────────────────────────────────────────────────────────────

  setSeed(seed: number): void {
    this.state.pool.seed = seed;
    this.state.pool.state = [seed, seed ^ 0xdeadbeef];
    this.state.pool.samples = 0;
    this._spare = null;
  }

  /** Inject external entropy */
  injectEntropy(data: number[]): void {
    for (const d of data) {
      this.state.pool.state[0] ^= Math.floor(d * 0xffffffff);
      this.random(); // Mix
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DIAGNOSTICS
  // ─────────────────────────────────────────────────────────────────────────────

  getEntropy(): number {
    return this.state.pool.entropy;
  }

  getDiagnostics(): {
    seed: number;
    totalSamples: number;
    entropy: number;
    beat: number;
  } {
    return {
      seed: this.state.pool.seed,
      totalSamples: this.state.totalSamples,
      entropy: this.state.pool.entropy,
      beat: this.state.beat,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON EXPORT
// ═══════════════════════════════════════════════════════════════════════════════

export const QUANTUM_FLUX = new QuantumFluxEngine();
