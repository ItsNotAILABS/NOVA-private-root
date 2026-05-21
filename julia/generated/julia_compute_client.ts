// ═══════════════════════════════════════════════════════════════════════════════
// julia_compute_client.ts — TypeScript Client for NOVA Julia-Motoko Bridge
// Classification: CONFIDENTIAL — SOVEREIGN PROTOCOL
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// BUILD №64 — FOUR DOORS ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════
//
// DOOR 1 (TypeScript variant): TYPED JAVASCRIPT/TYPESCRIPT CLIENT
//
// This client provides typed access to the Julia-Motoko bridge from
// TypeScript/JavaScript applications, including ICP frontends.
//
// USAGE:
//   import { JuliaComputeClient } from './julia_compute_client';
//   const julia = new JuliaComputeClient('canister-id');
//   const result = await julia.linalg_eigen(matrix);
//
// ═══════════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent, ActorSubclass } from '@dfinity/agent';
import { Principal } from '@dfinity/principal';
import { IDL } from '@dfinity/candid';

// ═══ φ-Constants ═════════════════════════════════════════════════════════════

export const PHI = 1.6180339887498948482;
export const PHI_INV = 0.6180339887498948482;
export const AMOR = 0.3819660112501051518;
export const HEARTBEAT_MS = 873;

// ═══ Type Definitions ════════════════════════════════════════════════════════

export interface Complex {
  re: number;
  im: number;
}

export interface Oscillator {
  phase: number;
  frequency: number;
}

export interface EigenResult {
  eigenvalues: number[];
  eigenvectors: number[][];
}

export interface SvdResult {
  U: number[][];
  S: number[];
  V: number[][];
}

export interface OptimResult {
  optimum: number[];
  iterations: bigint;
  converged: boolean;
}

export interface MonteCarloResult {
  samples: number[];
  mean: number;
  std: number;
}

export type BridgeError =
  | { NotInitialized: null }
  | { InvalidInput: string }
  | { ComputationFailed: string }
  | { TypeConversionError: string }
  | { Timeout: null };

export type BridgeResult<T> = { ok: T } | { err: BridgeError };

// ═══ IDL Factory ═════════════════════════════════════════════════════════════

const Complex = IDL.Record({
  re: IDL.Float64,
  im: IDL.Float64,
});

const Oscillator = IDL.Record({
  phase: IDL.Float64,
  frequency: IDL.Float64,
});

const EigenResultIDL = IDL.Record({
  eigenvalues: IDL.Vec(IDL.Float64),
  eigenvectors: IDL.Vec(IDL.Vec(IDL.Float64)),
});

const SvdResultIDL = IDL.Record({
  U: IDL.Vec(IDL.Vec(IDL.Float64)),
  S: IDL.Vec(IDL.Float64),
  V: IDL.Vec(IDL.Vec(IDL.Float64)),
});

const OptimResultIDL = IDL.Record({
  optimum: IDL.Vec(IDL.Float64),
  iterations: IDL.Nat64,
  converged: IDL.Bool,
});

const BridgeErrorIDL = IDL.Variant({
  NotInitialized: IDL.Null,
  InvalidInput: IDL.Text,
  ComputationFailed: IDL.Text,
  TypeConversionError: IDL.Text,
  Timeout: IDL.Null,
});

const BridgeResult = (T: IDL.Type) =>
  IDL.Variant({
    ok: T,
    err: BridgeErrorIDL,
  });

export const idlFactory = ({ IDL }: { IDL: any }) => {
  const Complex = IDL.Record({ re: IDL.Float64, im: IDL.Float64 });
  const Oscillator = IDL.Record({ phase: IDL.Float64, frequency: IDL.Float64 });
  const EigenResult = IDL.Record({
    eigenvalues: IDL.Vec(IDL.Float64),
    eigenvectors: IDL.Vec(IDL.Vec(IDL.Float64)),
  });
  const SvdResult = IDL.Record({
    U: IDL.Vec(IDL.Vec(IDL.Float64)),
    S: IDL.Vec(IDL.Float64),
    V: IDL.Vec(IDL.Vec(IDL.Float64)),
  });
  const OptimResult = IDL.Record({
    optimum: IDL.Vec(IDL.Float64),
    iterations: IDL.Nat64,
    converged: IDL.Bool,
  });
  const BridgeError = IDL.Variant({
    NotInitialized: IDL.Null,
    InvalidInput: IDL.Text,
    ComputationFailed: IDL.Text,
    TypeConversionError: IDL.Text,
    Timeout: IDL.Null,
  });

  return IDL.Service({
    get_phi: IDL.Func([], [IDL.Float64], ['query']),
    get_phi_inv: IDL.Func([], [IDL.Float64], ['query']),
    get_amor: IDL.Func([], [IDL.Float64], ['query']),
    get_heartbeat_ms: IDL.Func([], [IDL.Nat64], ['query']),
    get_version: IDL.Func([], [IDL.Text], ['query']),
    linalg_eigen: IDL.Func(
      [IDL.Vec(IDL.Vec(IDL.Float64))],
      [IDL.Variant({ ok: EigenResult, err: BridgeError })],
      []
    ),
    linalg_svd: IDL.Func(
      [IDL.Vec(IDL.Vec(IDL.Float64))],
      [IDL.Variant({ ok: SvdResult, err: BridgeError })],
      []
    ),
    linalg_inv: IDL.Func(
      [IDL.Vec(IDL.Vec(IDL.Float64))],
      [IDL.Variant({ ok: IDL.Vec(IDL.Vec(IDL.Float64)), err: BridgeError })],
      []
    ),
    linalg_det: IDL.Func(
      [IDL.Vec(IDL.Vec(IDL.Float64))],
      [IDL.Variant({ ok: IDL.Float64, err: BridgeError })],
      []
    ),
    linalg_norm: IDL.Func(
      [IDL.Vec(IDL.Float64)],
      [IDL.Variant({ ok: IDL.Float64, err: BridgeError })],
      []
    ),
    stats_mean: IDL.Func(
      [IDL.Vec(IDL.Float64)],
      [IDL.Variant({ ok: IDL.Float64, err: BridgeError })],
      []
    ),
    stats_std: IDL.Func(
      [IDL.Vec(IDL.Float64)],
      [IDL.Variant({ ok: IDL.Float64, err: BridgeError })],
      []
    ),
    stats_cor: IDL.Func(
      [IDL.Vec(IDL.Float64), IDL.Vec(IDL.Float64)],
      [IDL.Variant({ ok: IDL.Float64, err: BridgeError })],
      []
    ),
    fft_fft: IDL.Func(
      [IDL.Vec(Complex)],
      [IDL.Variant({ ok: IDL.Vec(Complex), err: BridgeError })],
      []
    ),
    fft_ifft: IDL.Func(
      [IDL.Vec(Complex)],
      [IDL.Variant({ ok: IDL.Vec(Complex), err: BridgeError })],
      []
    ),
    optim_gradient_descent: IDL.Func(
      [IDL.Vec(IDL.Float64), IDL.Opt(IDL.Nat64)],
      [IDL.Variant({ ok: OptimResult, err: BridgeError })],
      []
    ),
    kuramoto_step: IDL.Func(
      [IDL.Vec(Oscillator), IDL.Float64, IDL.Float64],
      [IDL.Variant({ ok: IDL.Vec(Oscillator), err: BridgeError })],
      []
    ),
    order_parameter: IDL.Func(
      [IDL.Vec(Oscillator)],
      [IDL.Variant({ ok: IDL.Float64, err: BridgeError })],
      ['query']
    ),
    is_phi_coherent: IDL.Func([IDL.Float64], [IDL.Bool], ['query']),
    meets_amor_threshold: IDL.Func([IDL.Float64], [IDL.Bool], ['query']),
  });
};

// ═══ Client Class ════════════════════════════════════════════════════════════

export interface JuliaComputeService {
  get_phi(): Promise<number>;
  get_phi_inv(): Promise<number>;
  get_amor(): Promise<number>;
  get_heartbeat_ms(): Promise<bigint>;
  get_version(): Promise<string>;
  linalg_eigen(matrix: number[][]): Promise<BridgeResult<EigenResult>>;
  linalg_svd(matrix: number[][]): Promise<BridgeResult<SvdResult>>;
  linalg_inv(matrix: number[][]): Promise<BridgeResult<number[][]>>;
  linalg_det(matrix: number[][]): Promise<BridgeResult<number>>;
  linalg_norm(vector: number[]): Promise<BridgeResult<number>>;
  stats_mean(values: number[]): Promise<BridgeResult<number>>;
  stats_std(values: number[]): Promise<BridgeResult<number>>;
  stats_cor(x: number[], y: number[]): Promise<BridgeResult<number>>;
  fft_fft(signal: Complex[]): Promise<BridgeResult<Complex[]>>;
  fft_ifft(spectrum: Complex[]): Promise<BridgeResult<Complex[]>>;
  optim_gradient_descent(initialPoint: number[], maxIter?: bigint): Promise<BridgeResult<OptimResult>>;
  kuramoto_step(oscillators: Oscillator[], K: number, dt: number): Promise<BridgeResult<Oscillator[]>>;
  order_parameter(oscillators: Oscillator[]): Promise<BridgeResult<number>>;
  is_phi_coherent(value: number): Promise<boolean>;
  meets_amor_threshold(value: number): Promise<boolean>;
}

/**
 * TypeScript client for the NOVA Julia-Motoko Bridge
 * 
 * @example
 * ```typescript
 * import { JuliaComputeClient } from './julia_compute_client';
 * 
 * const julia = new JuliaComputeClient('your-canister-id');
 * await julia.connect();
 * 
 * const matrix = [[2, 1, 0], [1, 2, 1], [0, 1, 2]];
 * const result = await julia.eigen(matrix);
 * 
 * if ('ok' in result) {
 *   console.log('Eigenvalues:', result.ok.eigenvalues);
 * }
 * ```
 */
export class JuliaComputeClient {
  private canisterId: string;
  private host: string;
  private agent: HttpAgent | null = null;
  private actor: ActorSubclass<JuliaComputeService> | null = null;

  constructor(canisterId: string, host: string = 'https://ic0.app') {
    this.canisterId = canisterId;
    this.host = host;
  }

  /**
   * Connect to the Julia compute canister
   */
  async connect(): Promise<void> {
    this.agent = new HttpAgent({ host: this.host });

    // Fetch root key for local development
    if (this.host.includes('localhost') || this.host.includes('127.0.0.1')) {
      await this.agent.fetchRootKey();
    }

    this.actor = Actor.createActor<JuliaComputeService>(idlFactory, {
      agent: this.agent,
      canisterId: this.canisterId,
    });
  }

  private ensureConnected(): void {
    if (!this.actor) {
      throw new Error('Not connected. Call connect() first.');
    }
  }

  // ═══ Constants ═════════════════════════════════════════════════════════════

  async getPhi(): Promise<number> {
    this.ensureConnected();
    return this.actor!.get_phi();
  }

  async getPhiInv(): Promise<number> {
    this.ensureConnected();
    return this.actor!.get_phi_inv();
  }

  async getAmor(): Promise<number> {
    this.ensureConnected();
    return this.actor!.get_amor();
  }

  async getHeartbeatMs(): Promise<bigint> {
    this.ensureConnected();
    return this.actor!.get_heartbeat_ms();
  }

  async getVersion(): Promise<string> {
    this.ensureConnected();
    return this.actor!.get_version();
  }

  // ═══ Linear Algebra ════════════════════════════════════════════════════════

  /**
   * Eigenvalue decomposition with φ-weighting
   */
  async eigen(matrix: number[][]): Promise<BridgeResult<EigenResult>> {
    this.ensureConnected();
    return this.actor!.linalg_eigen(matrix);
  }

  /**
   * Singular Value Decomposition with φ-weighting
   */
  async svd(matrix: number[][]): Promise<BridgeResult<SvdResult>> {
    this.ensureConnected();
    return this.actor!.linalg_svd(matrix);
  }

  /**
   * Matrix inverse
   */
  async inv(matrix: number[][]): Promise<BridgeResult<number[][]>> {
    this.ensureConnected();
    return this.actor!.linalg_inv(matrix);
  }

  /**
   * Matrix determinant
   */
  async det(matrix: number[][]): Promise<BridgeResult<number>> {
    this.ensureConnected();
    return this.actor!.linalg_det(matrix);
  }

  /**
   * Vector L2 norm
   */
  async norm(vector: number[]): Promise<BridgeResult<number>> {
    this.ensureConnected();
    return this.actor!.linalg_norm(vector);
  }

  // ═══ Statistics ════════════════════════════════════════════════════════════

  /**
   * Arithmetic mean
   */
  async mean(values: number[]): Promise<BridgeResult<number>> {
    this.ensureConnected();
    return this.actor!.stats_mean(values);
  }

  /**
   * Sample standard deviation
   */
  async std(values: number[]): Promise<BridgeResult<number>> {
    this.ensureConnected();
    return this.actor!.stats_std(values);
  }

  /**
   * Pearson correlation coefficient
   */
  async cor(x: number[], y: number[]): Promise<BridgeResult<number>> {
    this.ensureConnected();
    return this.actor!.stats_cor(x, y);
  }

  // ═══ FFT ═══════════════════════════════════════════════════════════════════

  /**
   * Fast Fourier Transform
   */
  async fft(signal: Complex[]): Promise<BridgeResult<Complex[]>> {
    this.ensureConnected();
    return this.actor!.fft_fft(signal);
  }

  /**
   * Inverse FFT
   */
  async ifft(spectrum: Complex[]): Promise<BridgeResult<Complex[]>> {
    this.ensureConnected();
    return this.actor!.fft_ifft(spectrum);
  }

  // ═══ Optimization ══════════════════════════════════════════════════════════

  /**
   * φ-optimized gradient descent
   */
  async gradientDescent(
    initialPoint: number[],
    maxIter?: number
  ): Promise<BridgeResult<OptimResult>> {
    this.ensureConnected();
    const maxIterBigInt = maxIter !== undefined ? [BigInt(maxIter)] : [];
    return this.actor!.optim_gradient_descent(initialPoint, maxIterBigInt as any);
  }

  // ═══ Kuramoto ══════════════════════════════════════════════════════════════

  /**
   * Single Kuramoto oscillator step
   */
  async kuramocoStep(
    oscillators: Oscillator[],
    K: number = PHI_INV,
    dt: number = HEARTBEAT_MS / 1000
  ): Promise<BridgeResult<Oscillator[]>> {
    this.ensureConnected();
    return this.actor!.kuramoto_step(oscillators, K, dt);
  }

  /**
   * Compute order parameter R
   */
  async orderParameter(oscillators: Oscillator[]): Promise<BridgeResult<number>> {
    this.ensureConnected();
    return this.actor!.order_parameter(oscillators);
  }

  // ═══ Utility ═══════════════════════════════════════════════════════════════

  /**
   * Check if value indicates φ-coherent state
   */
  async isPhiCoherent(value: number): Promise<boolean> {
    this.ensureConnected();
    return this.actor!.is_phi_coherent(value);
  }

  /**
   * Check if gradient meets AMOR threshold
   */
  async meetsAmorThreshold(value: number): Promise<boolean> {
    this.ensureConnected();
    return this.actor!.meets_amor_threshold(value);
  }
}

// ═══ Default Export ══════════════════════════════════════════════════════════

export default JuliaComputeClient;

// ═══ Convenience Function ════════════════════════════════════════════════════

/**
 * Create and connect a Julia compute client
 * 
 * @example
 * ```typescript
 * const julia = await createJuliaClient('your-canister-id');
 * const result = await julia.eigen([[2,1,0],[1,2,1],[0,1,2]]);
 * ```
 */
export async function createJuliaClient(
  canisterId: string,
  host: string = 'https://ic0.app'
): Promise<JuliaComputeClient> {
  const client = new JuliaComputeClient(canisterId, host);
  await client.connect();
  return client;
}
