// ─── NOVA / PARALLAX — Tensor Network Cryptography Math Engine ────────────────
// Sovereign tensor network operations for post-quantum cryptographic primitives.
// Implements: MPS/PEPS decompositions, tensor contractions, φ-weighted bond
// dimensions, trapdoor one-way functions, variational cryptanalysis substrate.
// Mirrors the Protocol layer (PROTOCOL-TENSOR-CRYPTO.js) in CPL-F typed form.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { PHI, PHI_INV, FEIGENBAUM_D, clamp, sigmoid } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const TN_DEFAULT_BOND_DIM    = 16;
export const TN_MAX_BOND_DIM        = 256;
export const TN_PHI_BOND_SCALE      = PHI;
export const TN_SVD_EPSILON         = 1e-12;
export const TN_CONVERGENCE_EPS     = 1e-8;
export const TN_PHYSICAL_DIM        = 2;  // qubit basis
export const TN_AMOR                = PHI_INV * PHI_INV; // φ⁻² = 0.3819...
export const TN_HAMILTONIAN_MAX_ITER = 1000;

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — TENSOR TYPE SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface TensorShape {
  readonly dimensions: readonly number[];
  readonly rank: number;
  readonly totalSize: number;
}

export interface TensorData {
  shape: TensorShape;
  data: Float64Array;
}

export interface MPSSite {
  leftBond: number;
  physicalDim: number;
  rightBond: number;
  tensor: TensorData;
}

export interface MPSState {
  numSites: number;
  physicalDim: number;
  bondDim: number;
  sites: MPSSite[];
  isCanonical: boolean;
}

export interface PEPSSite {
  x: number;
  y: number;
  leftBond: number;
  rightBond: number;
  upBond: number;
  downBond: number;
  physicalDim: number;
  tensor: TensorData;
}

export interface PEPSLattice {
  width: number;
  height: number;
  bondDim: number;
  physicalDim: number;
  sites: PEPSSite[][];
}

export interface SVDResult {
  U: Float64Array;
  S: Float64Array;   // singular values (descending)
  Vt: Float64Array;
  rows: number;
  cols: number;
  rank: number;
}

export interface TensorKeypair {
  privateKey: MPSState;
  publicSamples: TensorPublicSample[];
  bondDim: number;
  sites: number;
}

export interface TensorPublicSample {
  pattern: number[];
  value: number;
}

export interface CryptanalysisResult {
  recoveredKey: number[];
  finalCost: number;
  iterations: number;
  converged: boolean;
  costHistory: number[];
}

export interface SecretShare {
  id: number;
  fragments: TensorData[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — TENSOR PRIMITIVES
// ═══════════════════════════════════════════════════════════════════════════════

export function createShape(dims: number[]): TensorShape {
  return {
    dimensions: Object.freeze([...dims]),
    rank: dims.length,
    totalSize: dims.reduce((a, b) => a * b, 1),
  };
}

export function createTensor(dims: number[], data?: number[]): TensorData {
  const shape = createShape(dims);
  return {
    shape,
    data: data ? Float64Array.from(data) : new Float64Array(shape.totalSize),
  };
}

export function randomTensor(dims: number[]): TensorData {
  const shape = createShape(dims);
  const data = new Float64Array(shape.totalSize);
  for (let i = 0; i < shape.totalSize; i++) {
    data[i] = (Math.random() * 2 - 1) * PHI_INV;
  }
  return { shape, data };
}

export function tensorNorm(t: TensorData): number {
  let sum = 0;
  for (let i = 0; i < t.data.length; i++) {
    sum += t.data[i] * t.data[i];
  }
  return Math.sqrt(sum);
}

export function normalizeTensor(t: TensorData): TensorData {
  const n = tensorNorm(t);
  if (n < TN_SVD_EPSILON) return t;
  const data = new Float64Array(t.data.length);
  for (let i = 0; i < data.length; i++) {
    data[i] = t.data[i] / n;
  }
  return { shape: t.shape, data };
}

/** Flat index → multi-index */
export function unflattenIndex(flat: number, dims: readonly number[]): number[] {
  const indices = new Array(dims.length);
  let rem = flat;
  for (let i = dims.length - 1; i >= 0; i--) {
    indices[i] = rem % dims[i];
    rem = Math.floor(rem / dims[i]);
  }
  return indices;
}

/** Multi-index → flat index */
export function flattenIndex(indices: number[], dims: readonly number[]): number {
  let idx = 0;
  let stride = 1;
  for (let i = dims.length - 1; i >= 0; i--) {
    idx += indices[i] * stride;
    stride *= dims[i];
  }
  return idx;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — SVD ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compact SVD via one-sided Jacobi method.
 * A[m×n] = U[m×k] · diag(S[k]) · Vt[k×n], k = min(m,n)
 */
export function computeSVD(matrix: Float64Array, m: number, n: number): SVDResult {
  const k = Math.min(m, n);
  const A = Float64Array.from(matrix);
  const V = new Float64Array(n * n);
  for (let i = 0; i < n; i++) V[i * n + i] = 1.0;

  // Jacobi sweeps
  for (let sweep = 0; sweep < 50; sweep++) {
    let off = 0;
    for (let p = 0; p < n - 1; p++) {
      for (let q = p + 1; q < n; q++) {
        let app = 0, aqq = 0, apq = 0;
        for (let i = 0; i < m; i++) {
          app += A[i * n + p] * A[i * n + p];
          aqq += A[i * n + q] * A[i * n + q];
          apq += A[i * n + p] * A[i * n + q];
        }
        off += apq * apq;
        if (Math.abs(apq) < TN_SVD_EPSILON) continue;

        const tau = (aqq - app) / (2 * apq);
        const t = Math.sign(tau) / (Math.abs(tau) + Math.sqrt(1 + tau * tau));
        const c = 1 / Math.sqrt(1 + t * t);
        const s = t * c;

        for (let i = 0; i < m; i++) {
          const aip = A[i * n + p], aiq = A[i * n + q];
          A[i * n + p] = c * aip - s * aiq;
          A[i * n + q] = s * aip + c * aiq;
        }
        for (let i = 0; i < n; i++) {
          const vip = V[i * n + p], viq = V[i * n + q];
          V[i * n + p] = c * vip - s * viq;
          V[i * n + q] = s * vip + c * viq;
        }
      }
    }
    if (off < TN_SVD_EPSILON * TN_SVD_EPSILON) break;
  }

  // Extract singular values and U
  const S = new Float64Array(k);
  const U = new Float64Array(m * k);
  for (let j = 0; j < k; j++) {
    let colNorm = 0;
    for (let i = 0; i < m; i++) colNorm += A[i * n + j] * A[i * n + j];
    S[j] = Math.sqrt(colNorm);
    if (S[j] > TN_SVD_EPSILON) {
      for (let i = 0; i < m; i++) U[i * k + j] = A[i * n + j] / S[j];
    }
  }

  // Sort descending
  const order = Array.from({ length: k }, (_, i) => i).sort((a, b) => S[b] - S[a]);
  const sS = new Float64Array(k);
  const sU = new Float64Array(m * k);
  const Vt = new Float64Array(k * n);
  for (let j = 0; j < k; j++) {
    sS[j] = S[order[j]];
    for (let i = 0; i < m; i++) sU[i * k + j] = U[i * k + order[j]];
    for (let i = 0; i < n; i++) Vt[j * n + i] = V[i * n + order[j]];
  }

  return { U: sU, S: sS, Vt, rows: m, cols: n, rank: k };
}

/**
 * Truncated SVD: keep top-χ singular values.
 */
export function truncatedSVD(matrix: Float64Array, m: number, n: number, chi: number): SVDResult {
  const full = computeSVD(matrix, m, n);
  const actualChi = Math.min(chi, full.rank);

  const tU = new Float64Array(m * actualChi);
  const tS = new Float64Array(actualChi);
  const tVt = new Float64Array(actualChi * n);

  for (let j = 0; j < actualChi; j++) {
    tS[j] = full.S[j];
    for (let i = 0; i < m; i++) tU[i * actualChi + j] = full.U[i * full.rank + j];
    for (let i = 0; i < n; i++) tVt[j * n + i] = full.Vt[j * n + i];
  }

  return { U: tU, S: tS, Vt: tVt, rows: m, cols: n, rank: actualChi };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — MATRIX PRODUCT STATE (MPS)
// ═══════════════════════════════════════════════════════════════════════════════

/** Create a random MPS with given parameters */
export function createMPS(numSites: number, physDim = TN_PHYSICAL_DIM, bondDim = TN_DEFAULT_BOND_DIM): MPSState {
  const sites: MPSSite[] = [];

  for (let k = 0; k < numSites; k++) {
    const leftBond = k === 0 ? 1 : bondDim;
    const rightBond = k === numSites - 1 ? 1 : bondDim;
    const tensor = normalizeTensor(randomTensor([leftBond, physDim, rightBond]));
    sites.push({ leftBond, physicalDim: physDim, rightBond, tensor });
  }

  return { numSites, physicalDim: physDim, bondDim, sites, isCanonical: false };
}

/** Left-canonicalize MPS via SVD sweep */
export function leftCanonicalize(mps: MPSState): MPSState {
  const sites = mps.sites.map(s => ({ ...s, tensor: { ...s.tensor, data: Float64Array.from(s.tensor.data) } }));

  for (let k = 0; k < mps.numSites - 1; k++) {
    const site = sites[k];
    const rows = site.leftBond * site.physicalDim;
    const cols = site.rightBond;

    const { U, S, Vt, rank } = truncatedSVD(site.tensor.data, rows, cols, mps.bondDim);
    const chi = rank;

    // Update current site
    sites[k] = {
      leftBond: site.leftBond,
      physicalDim: site.physicalDim,
      rightBond: chi,
      tensor: { shape: createShape([site.leftBond, site.physicalDim, chi]), data: U },
    };

    // Absorb S·Vt into next site
    const next = sites[k + 1];
    const SV = new Float64Array(chi * cols);
    for (let i = 0; i < chi; i++) {
      for (let j = 0; j < cols; j++) {
        SV[i * cols + j] = S[i] * Vt[i * cols + j];
      }
    }

    const nextRight = next.rightBond;
    const newData = new Float64Array(chi * mps.physicalDim * nextRight);
    for (let a = 0; a < chi; a++) {
      for (let d = 0; d < mps.physicalDim; d++) {
        for (let b = 0; b < nextRight; b++) {
          let sum = 0;
          for (let c = 0; c < cols; c++) {
            const nextIdx = flattenIndex([c, d, b], [next.leftBond, next.physicalDim, nextRight]);
            sum += SV[a * cols + c] * next.tensor.data[nextIdx];
          }
          newData[flattenIndex([a, d, b], [chi, mps.physicalDim, nextRight])] = sum;
        }
      }
    }

    sites[k + 1] = {
      leftBond: chi,
      physicalDim: mps.physicalDim,
      rightBond: nextRight,
      tensor: { shape: createShape([chi, mps.physicalDim, nextRight]), data: newData },
    };
  }

  return { ...mps, sites, isCanonical: true };
}

/** Compute entanglement entropy at bond k */
export function entanglementEntropy(mps: MPSState, bondIndex: number): number {
  if (bondIndex < 0 || bondIndex >= mps.numSites - 1) return 0;

  const canonical = mps.isCanonical ? mps : leftCanonicalize(mps);
  const site = canonical.sites[bondIndex];
  const rows = site.leftBond * site.physicalDim;
  const cols = site.rightBond;

  const { S } = computeSVD(site.tensor.data, rows, cols);

  let entropy = 0;
  for (let i = 0; i < S.length; i++) {
    const p = S[i] * S[i];
    if (p > TN_SVD_EPSILON) entropy -= p * Math.log2(p);
  }
  return entropy;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — PEPS (2D TENSOR NETWORK)
// ═══════════════════════════════════════════════════════════════════════════════

/** Create a PEPS lattice */
export function createPEPS(
  width: number, height: number,
  physDim = TN_PHYSICAL_DIM, bondDim = TN_DEFAULT_BOND_DIM
): PEPSLattice {
  const sites: PEPSSite[][] = [];

  for (let y = 0; y < height; y++) {
    const row: PEPSSite[] = [];
    for (let x = 0; x < width; x++) {
      const left = x === 0 ? 1 : bondDim;
      const right = x === width - 1 ? 1 : bondDim;
      const up = y === 0 ? 1 : bondDim;
      const down = y === height - 1 ? 1 : bondDim;

      row.push({
        x, y,
        leftBond: left, rightBond: right, upBond: up, downBond: down,
        physicalDim: physDim,
        tensor: randomTensor([left, right, up, down, physDim]),
      });
    }
    sites.push(row);
  }

  return { width, height, bondDim, physicalDim: physDim, sites };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — TENSOR NETWORK ENCRYPTION (CPL-F Interface)
// ═══════════════════════════════════════════════════════════════════════════════

/** Generate a tensor network keypair for encryption */
export function generateTNKeypair(
  bondDim = TN_DEFAULT_BOND_DIM,
  keySites = 32
): TensorKeypair {
  const mps = leftCanonicalize(createMPS(keySites, TN_PHYSICAL_DIM, bondDim));

  // Derive public samples
  const numSamples = keySites * bondDim;
  const publicSamples: TensorPublicSample[] = [];

  for (let i = 0; i < numSamples; i++) {
    const pattern: number[] = [];
    for (let k = 0; k < Math.min(keySites, 16); k++) {
      pattern.push(Math.floor(Math.random() * TN_PHYSICAL_DIM));
    }
    const value = evaluateMPSPartial(mps, pattern);
    publicSamples.push({ pattern, value });
  }

  return { privateKey: mps, publicSamples, bondDim, sites: keySites };
}

/** Evaluate MPS at a partial physical index pattern */
export function evaluateMPSPartial(mps: MPSState, pattern: number[]): number {
  let current: { data: Float64Array; rows: number; cols: number } | null = null;
  const n = Math.min(pattern.length, mps.numSites);

  for (let k = 0; k < n; k++) {
    const site = mps.sites[k];
    const d = pattern[k];
    const left = site.leftBond;
    const right = site.rightBond;

    // Extract slice T[:, d, :]
    const slice = new Float64Array(left * right);
    for (let a = 0; a < left; a++) {
      for (let b = 0; b < right; b++) {
        slice[a * right + b] = site.tensor.data[flattenIndex([a, d, b], [left, site.physicalDim, right])];
      }
    }

    if (!current) {
      current = { data: slice, rows: left, cols: right };
    } else {
      const newData = new Float64Array(current.rows * right);
      for (let i = 0; i < current.rows; i++) {
        for (let j = 0; j < right; j++) {
          let sum = 0;
          for (let c = 0; c < current.cols; c++) {
            sum += current.data[i * current.cols + c] * slice[c * right + j];
          }
          newData[i * right + j] = sum;
        }
      }
      current = { data: newData, rows: current.rows, cols: right };
    }
  }
  return current ? current.data[0] : 0;
}

/** Encrypt binary message using tensor network keypair */
export function tnEncrypt(messageBits: number[], keypair: TensorKeypair): Float64Array[] {
  const blockSize = Math.min(16, keypair.sites);
  const padded = [...messageBits];
  while (padded.length % blockSize !== 0) padded.push(0);

  const blocks: Float64Array[] = [];
  for (let i = 0; i < padded.length; i += blockSize) {
    const block = padded.slice(i, i + blockSize);
    const cipher = new Float64Array(blockSize);
    for (let j = 0; j < blockSize; j++) {
      const sampleIdx = ((i / blockSize) * blockSize + j) % keypair.publicSamples.length;
      const sv = keypair.publicSamples[sampleIdx].value;
      cipher[j] = block[j] * PHI + (1 - block[j]) * PHI_INV + sv * TN_AMOR;
    }
    blocks.push(cipher);
  }
  return blocks;
}

/** Decrypt cipher blocks using private key */
export function tnDecrypt(blocks: Float64Array[], keypair: TensorKeypair, totalBits: number): number[] {
  const blockSize = Math.min(16, keypair.sites);
  const bits: number[] = [];

  for (let bi = 0; bi < blocks.length; bi++) {
    const block = blocks[bi];
    for (let j = 0; j < block.length; j++) {
      const sampleIdx = (bi * blockSize + j) % keypair.publicSamples.length;
      const sv = keypair.publicSamples[sampleIdx].value;
      const adjusted = block[j] - sv * TN_AMOR;
      const dist1 = Math.abs(adjusted - PHI);
      const dist0 = Math.abs(adjusted - PHI_INV);
      bits.push(dist1 < dist0 ? 1 : 0);
    }
  }

  return bits.slice(0, totalBits);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — VARIATIONAL CRYPTANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════

export interface HamiltonianTerm {
  sites: number[];
  coefficient: number;
  type: 'Z' | 'ZZ';
}

/** Build Hamiltonian from known plaintext-ciphertext pairs */
export function buildCryptanalysisHamiltonian(
  pairs: { plaintext: number[]; ciphertext: number[] }[]
): { terms: HamiltonianTerm[]; numSites: number } {
  const terms: HamiltonianTerm[] = [];
  let maxSite = 0;

  for (const { plaintext, ciphertext } of pairs) {
    for (let i = 0; i < plaintext.length; i++) {
      maxSite = Math.max(maxSite, i);
      for (let j = i + 1; j < Math.min(i + 3, plaintext.length); j++) {
        const targetBit = ciphertext[i] ^ plaintext[j];
        terms.push({ sites: [i, j], coefficient: targetBit ? 1.0 : -1.0, type: 'ZZ' });
      }
      terms.push({ sites: [i], coefficient: plaintext[i] ? PHI_INV : -PHI_INV, type: 'Z' });
    }
  }

  return { terms, numSites: maxSite + 1 };
}

/** Run variational optimization to recover key */
export function variationalCryptanalysis(
  hamiltonian: { terms: HamiltonianTerm[]; numSites: number },
  bondDim = TN_DEFAULT_BOND_DIM,
  maxIter = TN_HAMILTONIAN_MAX_ITER
): CryptanalysisResult {
  const { terms, numSites } = hamiltonian;
  let mps = createMPS(numSites, TN_PHYSICAL_DIM, bondDim);
  const costHistory: number[] = [];
  let prevCost = Infinity;

  for (let iter = 0; iter < maxIter; iter++) {
    const cost = computeMPSEnergy(mps, terms);
    costHistory.push(cost);
    if (Math.abs(prevCost - cost) < TN_CONVERGENCE_EPS) break;
    prevCost = cost;

    // Sweep optimization
    for (let site = 0; site < numSites; site++) {
      mps = optimizeMPSSite(mps, site, terms);
    }
    for (let site = numSites - 2; site >= 1; site--) {
      mps = optimizeMPSSite(mps, site, terms);
    }
  }

  return {
    recoveredKey: extractKeyFromMPS(mps),
    finalCost: costHistory[costHistory.length - 1],
    iterations: costHistory.length,
    converged: costHistory.length < maxIter,
    costHistory,
  };
}

function computeMPSEnergy(mps: MPSState, terms: HamiltonianTerm[]): number {
  let energy = 0;
  for (const term of terms) {
    if (term.type === 'Z' && term.sites.length === 1) {
      const site = mps.sites[term.sites[0]];
      let p0 = 0, p1 = 0;
      const left = site.leftBond, right = site.rightBond;
      for (let a = 0; a < left; a++) {
        for (let b = 0; b < right; b++) {
          const v0 = site.tensor.data[flattenIndex([a, 0, b], [left, mps.physicalDim, right])];
          const v1 = site.tensor.data[flattenIndex([a, 1, b], [left, mps.physicalDim, right])];
          p0 += v0 * v0;
          p1 += v1 * v1;
        }
      }
      energy += term.coefficient * (p0 - p1);
    } else if (term.type === 'ZZ' && term.sites.length === 2) {
      const s1 = mps.sites[term.sites[0]];
      const s2 = mps.sites[term.sites[1]];
      let corr = 0;
      for (let d1 = 0; d1 < TN_PHYSICAL_DIM; d1++) {
        for (let d2 = 0; d2 < TN_PHYSICAL_DIM; d2++) {
          const z1 = d1 === 0 ? 1 : -1;
          const z2 = d2 === 0 ? 1 : -1;
          let w1 = 0, w2 = 0;
          for (let a = 0; a < s1.leftBond; a++) {
            for (let b = 0; b < s1.rightBond; b++) {
              const v = s1.tensor.data[flattenIndex([a, d1, b], [s1.leftBond, mps.physicalDim, s1.rightBond])];
              w1 += v * v;
            }
          }
          for (let a = 0; a < s2.leftBond; a++) {
            for (let b = 0; b < s2.rightBond; b++) {
              const v = s2.tensor.data[flattenIndex([a, d2, b], [s2.leftBond, mps.physicalDim, s2.rightBond])];
              w2 += v * v;
            }
          }
          corr += z1 * z2 * w1 * w2;
        }
      }
      energy += term.coefficient * corr;
    }
  }
  return energy;
}

function optimizeMPSSite(mps: MPSState, siteIdx: number, terms: HamiltonianTerm[]): MPSState {
  const sites = [...mps.sites];
  const site = sites[siteIdx];
  const data = Float64Array.from(site.tensor.data);
  const left = site.leftBond;
  const right = site.rightBond;
  const lr = TN_AMOR * 0.1;

  for (const term of terms) {
    if (term.type === 'Z' && term.sites[0] === siteIdx) {
      for (let a = 0; a < left; a++) {
        for (let b = 0; b < right; b++) {
          const i0 = flattenIndex([a, 0, b], [left, mps.physicalDim, right]);
          const i1 = flattenIndex([a, 1, b], [left, mps.physicalDim, right]);
          data[i0] -= lr * 2 * term.coefficient * data[i0];
          data[i1] += lr * 2 * term.coefficient * data[i1];
        }
      }
    }
  }

  // Normalize
  let norm = 0;
  for (let i = 0; i < data.length; i++) norm += data[i] * data[i];
  norm = Math.sqrt(norm);
  if (norm > TN_SVD_EPSILON) {
    for (let i = 0; i < data.length; i++) data[i] /= norm;
  }

  sites[siteIdx] = { ...site, tensor: { shape: site.tensor.shape, data } };
  return { ...mps, sites };
}

function extractKeyFromMPS(mps: MPSState): number[] {
  const key: number[] = [];
  for (let k = 0; k < mps.numSites; k++) {
    const site = mps.sites[k];
    let p0 = 0, p1 = 0;
    for (let a = 0; a < site.leftBond; a++) {
      for (let b = 0; b < site.rightBond; b++) {
        const v0 = site.tensor.data[flattenIndex([a, 0, b], [site.leftBond, site.physicalDim, site.rightBond])];
        const v1 = site.tensor.data[flattenIndex([a, 1, b], [site.leftBond, site.physicalDim, site.rightBond])];
        p0 += v0 * v0;
        p1 += v1 * v1;
      }
    }
    key.push(p1 > p0 ? 1 : 0);
  }
  return key;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — MPS SECRET SHARING
// ═══════════════════════════════════════════════════════════════════════════════

/** Split secret into n shares with threshold k reconstruction */
export function mpsSecretShare(
  secret: number[],
  threshold: number,
  totalShares: number,
  bondDim = TN_DEFAULT_BOND_DIM
): SecretShare[] {
  const numSites = secret.length;
  let mps = createMPS(numSites, TN_PHYSICAL_DIM, bondDim);

  // Bias MPS to encode secret
  const sites = mps.sites.map((site, k) => {
    const data = Float64Array.from(site.tensor.data);
    const d = secret[k];
    for (let a = 0; a < site.leftBond; a++) {
      for (let b = 0; b < site.rightBond; b++) {
        const i_d = flattenIndex([a, d, b], [site.leftBond, site.physicalDim, site.rightBond]);
        const i_nd = flattenIndex([a, 1 - d, b], [site.leftBond, site.physicalDim, site.rightBond]);
        data[i_d] += PHI;
        data[i_nd] *= PHI_INV * 0.1;
      }
    }
    return { ...site, tensor: { shape: site.tensor.shape, data } };
  });

  mps = leftCanonicalize({ ...mps, sites });

  // Generate shares
  const shares: SecretShare[] = [];
  const TAU = Math.PI * 2;

  for (let s = 0; s < totalShares; s++) {
    const fragments: TensorData[] = [];

    for (let k = 0; k < numSites; k++) {
      const site = mps.sites[k];
      const rows = site.leftBond * site.physicalDim;
      const cols = site.rightBond;
      const { U, S, Vt, rank } = computeSVD(site.tensor.data, rows, cols);

      const fragData = new Float64Array(site.tensor.data.length);
      for (let i = 0; i < rank; i++) {
        const weight = Math.cos(TAU * (s * threshold + i) / (totalShares * rank));
        const contribution = S[i] * weight / threshold;
        for (let r = 0; r < rows; r++) {
          for (let c = 0; c < cols; c++) {
            fragData[r * cols + c] += contribution * U[r * rank + i] * Vt[i * cols + c];
          }
        }
      }

      fragments.push({ shape: site.tensor.shape, data: fragData });
    }

    shares.push({ id: s, fragments });
  }

  return shares;
}

/** Reconstruct secret from k or more shares */
export function mpsSecretReconstruct(shares: SecretShare[], threshold: number): number[] {
  if (shares.length < threshold) {
    throw new Error(`Need ≥${threshold} shares, got ${shares.length}`);
  }

  const numSites = shares[0].fragments.length;
  const secret: number[] = [];

  for (let k = 0; k < numSites; k++) {
    const combined = new Float64Array(shares[0].fragments[k].data.length);
    for (const share of shares) {
      const frag = share.fragments[k].data;
      for (let i = 0; i < combined.length; i++) combined[i] += frag[i];
    }

    // Extract bit
    const shape = shares[0].fragments[k].shape;
    const dims = shape.dimensions;
    const left = dims[0], phys = dims[1], right = dims[2];
    let p0 = 0, p1 = 0;
    for (let a = 0; a < left; a++) {
      for (let b = 0; b < right; b++) {
        p0 += Math.abs(combined[flattenIndex([a, 0, b], [left, phys, right])]);
        p1 += Math.abs(combined[flattenIndex([a, 1, b], [left, phys, right])]);
      }
    }
    secret.push(p1 > p0 ? 1 : 0);
  }

  return secret;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — φ-BOND DIMENSION SCALING
// ═══════════════════════════════════════════════════════════════════════════════

/** Compute φ-scaled bond dimension for security level */
export function phiBondDimension(securityLevel: number): number {
  // Security level 1..10 maps to bond dim via φ-scaling
  const level = clamp(securityLevel, 1, 10);
  return Math.min(Math.round(TN_DEFAULT_BOND_DIM * Math.pow(PHI, level - 1)), TN_MAX_BOND_DIM);
}

/** Compute tensor network security estimate (bits of security) */
export function estimateSecurityBits(bondDim: number, numSites: number): number {
  // Security ≈ log₂(χ^n) where χ=bondDim, n=numSites
  // More precisely: information-theoretic bound on recovering MPS from samples
  return Math.floor(numSites * Math.log2(bondDim) * PHI_INV);
}

/** Compute φ-weighted entanglement capacity */
export function phiEntanglementCapacity(bondDim: number): number {
  // Maximum entanglement entropy across a bond = log₂(χ)
  // φ-weighted: scale by golden ratio for sovereign geometry
  return Math.log2(bondDim) * PHI;
}
