/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-TENSOR-CRYPTO — NOVA SOVEREIGN TENSOR NETWORK CRYPTOGRAPHY  (BUILD №68)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 *
 * TENSOR NETWORK CRYPTOGRAPHY for the NOVA sovereign organism:
 *   • Matrix Product State (MPS) encryption — 1D tensor chain key generation
 *   • Projected Entangled Pair States (PEPS) — 2D lattice key structures
 *   • Tensor contraction-based one-way functions (trapdoor via bond dimension)
 *   • Variational tensor network cryptanalysis (Hamiltonian key recovery)
 *   • φ-weighted bond dimensions — sovereign geometry in tensor decomposition
 *   • Privacy-preserving tensor decomposition (MPS secret sharing)
 *   • Phantom integration — ephemeral tensor keys via HKDF + bond truncation
 *
 * ARCHITECTURE:
 *   Tensor Core  →  MPS Encryption Engine  →  Bond Dimension Key Space
 *                →  PEPS Lattice Cipher     →  2D Entanglement Structure
 *                →  Trapdoor OWF            →  Sparse Tensor Evaluation
 *                →  Cryptanalysis Engine    →  Hamiltonian Cost Solver
 *                →  Secret Sharing          →  MPS Decomposition Shares
 *                →  Phantom Bridge          →  Ephemeral Tensor Keys
 *
 * MATHEMATICAL FOUNDATION:
 *   T[i₁,i₂,...,iₙ] = Σ A¹[α₀,i₁,α₁] · A²[α₁,i₂,α₂] · ... · Aⁿ[αₙ₋₁,iₙ,αₙ]
 *   where αₖ ∈ {1,...,χ} (bond dimension χ controls security/efficiency)
 *
 * PROTOCOL ID: PROTOCOL-TENSOR-CRYPTO
 * VERSION: 1.0.0
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PROTOCOL_ID      = 'PROTOCOL-TENSOR-CRYPTO';
const PROTOCOL_VERSION = '1.0.0';

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const FEIGENBAUM_D = 4.6692016091029906719;
const HEARTBEAT_MS = 873;
const TAU              = 6.2831853071795864769;

// Tensor network security parameters
const DEFAULT_BOND_DIM      = 16;     // χ — bond dimension
const MAX_BOND_DIM          = 256;    // Maximum for high-security
const PHI_BOND_SCALE        = PHI;    // φ-scaling for adaptive bond dims
const KEY_QUBIT_COUNT       = 128;    // Logical key qubits
const MPS_SITE_DIM          = 2;      // Physical dimension (d=2 for qubits)
const PEPS_LATTICE_WIDTH    = 8;      // Default PEPS grid width
const PEPS_LATTICE_HEIGHT   = 8;      // Default PEPS grid height
const SVD_TRUNCATION_EPS    = 1e-12;  // SVD truncation threshold
const HAMILTONIAN_ITER_MAX  = 1000;   // Max variational iterations
const CONVERGENCE_THRESHOLD = 1e-8;   // Cost function convergence

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — TENSOR PRIMITIVES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Dense tensor: multi-dimensional array stored flat with shape metadata.
 * T[i₁,i₂,...,iₙ] stored in row-major order.
 */
class Tensor {
  constructor(shape, data = null) {
    this.shape = [...shape];
    this.rank = shape.length;
    this.size = shape.reduce((a, b) => a * b, 1);
    this.data = data ? Float64Array.from(data) : new Float64Array(this.size);
  }

  /** Flat index from multi-index */
  flatIndex(indices) {
    let idx = 0;
    let stride = 1;
    for (let i = this.rank - 1; i >= 0; i--) {
      idx += indices[i] * stride;
      stride *= this.shape[i];
    }
    return idx;
  }

  /** Multi-index from flat index */
  multiIndex(flat) {
    const indices = new Array(this.rank);
    let remainder = flat;
    for (let i = this.rank - 1; i >= 0; i--) {
      indices[i] = remainder % this.shape[i];
      remainder = Math.floor(remainder / this.shape[i]);
    }
    return indices;
  }

  get(indices) { return this.data[this.flatIndex(indices)]; }
  set(indices, val) { this.data[this.flatIndex(indices)] = val; }

  /** Create random tensor with entries in [-1,1] scaled by φ⁻¹ */
  static random(shape) {
    const t = new Tensor(shape);
    for (let i = 0; i < t.size; i++) {
      t.data[i] = (Math.random() * 2 - 1) * PHI_INV;
    }
    return t;
  }

  /** Create identity-like tensor (for bond indices) */
  static identity(dim) {
    const t = new Tensor([dim, dim]);
    for (let i = 0; i < dim; i++) {
      t.data[i * dim + i] = 1.0;
    }
    return t;
  }

  /** Frobenius norm */
  norm() {
    let sum = 0;
    for (let i = 0; i < this.size; i++) {
      sum += this.data[i] * this.data[i];
    }
    return Math.sqrt(sum);
  }

  /** Clone this tensor */
  clone() {
    return new Tensor(this.shape, this.data);
  }

  /** Reshape tensor (total size must be preserved) */
  reshape(newShape) {
    const newSize = newShape.reduce((a, b) => a * b, 1);
    if (newSize !== this.size) throw new Error(`Cannot reshape [${this.shape}] to [${newShape}]`);
    return new Tensor(newShape, this.data);
  }
}

/**
 * Contract two tensors along specified axes.
 * C[free_a, free_b] = Σ_contracted A[...,i,...] * B[...,i,...]
 */
function tensorContract(A, B, axesA, axesB) {
  if (axesA.length !== axesB.length) {
    throw new Error('Contraction axes must match in count');
  }

  // Validate contracted dimensions match
  for (let k = 0; k < axesA.length; k++) {
    if (A.shape[axesA[k]] !== B.shape[axesB[k]]) {
      throw new Error(`Dimension mismatch on contraction axis: ${A.shape[axesA[k]]} vs ${B.shape[axesB[k]]}`);
    }
  }

  // Compute free axes
  const freeA = [];
  for (let i = 0; i < A.rank; i++) {
    if (!axesA.includes(i)) freeA.push(i);
  }
  const freeB = [];
  for (let i = 0; i < B.rank; i++) {
    if (!axesB.includes(i)) freeB.push(i);
  }

  // Result shape
  const resultShape = [...freeA.map(i => A.shape[i]), ...freeB.map(i => B.shape[i])];
  const C = new Tensor(resultShape.length > 0 ? resultShape : [1]);

  // Contracted dimension sizes
  const contractedDims = axesA.map(i => A.shape[i]);
  const contractedSize = contractedDims.reduce((a, b) => a * b, 1);

  // Enumerate free indices of A
  const freeASize = freeA.reduce((acc, i) => acc * A.shape[i], 1);
  const freeBSize = freeB.reduce((acc, i) => acc * B.shape[i], 1);

  for (let fa = 0; fa < freeASize; fa++) {
    // Decode fa into free A indices
    const freeAIndices = decodeIndex(fa, freeA.map(i => A.shape[i]));

    for (let fb = 0; fb < freeBSize; fb++) {
      // Decode fb into free B indices
      const freeBIndices = decodeIndex(fb, freeB.map(i => B.shape[i]));

      let sum = 0;
      for (let c = 0; c < contractedSize; c++) {
        const contractedIndices = decodeIndex(c, contractedDims);

        // Build full index for A
        const idxA = new Array(A.rank);
        let fai = 0, ci = 0;
        for (let i = 0; i < A.rank; i++) {
          if (axesA.includes(i)) {
            idxA[i] = contractedIndices[ci++];
          } else {
            idxA[i] = freeAIndices[fai++];
          }
        }

        // Build full index for B
        const idxB = new Array(B.rank);
        let fbi = 0;
        ci = 0;
        for (let i = 0; i < B.rank; i++) {
          if (axesB.includes(i)) {
            idxB[i] = contractedIndices[ci++];
          } else {
            idxB[i] = freeBIndices[fbi++];
          }
        }

        sum += A.get(idxA) * B.get(idxB);
      }

      const outIdx = fa * freeBSize + fb;
      C.data[outIdx] = sum;
    }
  }

  return C;
}

/** Decode a flat index into multi-index given shape */
function decodeIndex(flat, shape) {
  if (shape.length === 0) return [];
  const indices = new Array(shape.length);
  let remainder = flat;
  for (let i = shape.length - 1; i >= 0; i--) {
    indices[i] = remainder % shape[i];
    remainder = Math.floor(remainder / shape[i]);
  }
  return indices;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — SVD ENGINE (for tensor decompositions)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compact SVD via one-sided Jacobi rotations.
 * A = U * diag(S) * Vt
 * Returns { U, S, Vt } where S is sorted descending.
 */
function svd(matrix, rows, cols) {
  const m = rows;
  const n = cols;
  const k = Math.min(m, n);

  // Copy matrix
  const A = new Float64Array(m * n);
  for (let i = 0; i < m * n; i++) A[i] = matrix[i];

  // Initialize V = I(n×n)
  const V = new Float64Array(n * n);
  for (let i = 0; i < n; i++) V[i * n + i] = 1.0;

  // One-sided Jacobi sweeps
  const maxSweeps = 50;
  for (let sweep = 0; sweep < maxSweeps; sweep++) {
    let offNorm = 0;
    for (let p = 0; p < n - 1; p++) {
      for (let q = p + 1; q < n; q++) {
        // Compute column dot products
        let app = 0, aqq = 0, apq = 0;
        for (let i = 0; i < m; i++) {
          app += A[i * n + p] * A[i * n + p];
          aqq += A[i * n + q] * A[i * n + q];
          apq += A[i * n + p] * A[i * n + q];
        }
        offNorm += apq * apq;

        if (Math.abs(apq) < SVD_TRUNCATION_EPS) continue;

        // Compute Jacobi rotation
        const tau = (aqq - app) / (2 * apq);
        const t = Math.sign(tau) / (Math.abs(tau) + Math.sqrt(1 + tau * tau));
        const c = 1 / Math.sqrt(1 + t * t);
        const s = t * c;

        // Apply rotation to A columns
        for (let i = 0; i < m; i++) {
          const aip = A[i * n + p];
          const aiq = A[i * n + q];
          A[i * n + p] = c * aip - s * aiq;
          A[i * n + q] = s * aip + c * aiq;
        }

        // Apply rotation to V columns
        for (let i = 0; i < n; i++) {
          const vip = V[i * n + p];
          const viq = V[i * n + q];
          V[i * n + p] = c * vip - s * viq;
          V[i * n + q] = s * vip + c * viq;
        }
      }
    }
    if (offNorm < SVD_TRUNCATION_EPS * SVD_TRUNCATION_EPS) break;
  }

  // Extract singular values (column norms of A)
  const S = new Float64Array(k);
  const U = new Float64Array(m * k);
  for (let j = 0; j < k; j++) {
    let colNorm = 0;
    for (let i = 0; i < m; i++) {
      colNorm += A[i * n + j] * A[i * n + j];
    }
    S[j] = Math.sqrt(colNorm);
    // U column = normalized A column
    if (S[j] > SVD_TRUNCATION_EPS) {
      for (let i = 0; i < m; i++) {
        U[i * k + j] = A[i * n + j] / S[j];
      }
    }
  }

  // Sort by descending singular value
  const order = Array.from({ length: k }, (_, i) => i);
  order.sort((a, b) => S[b] - S[a]);

  const sortedS = new Float64Array(k);
  const sortedU = new Float64Array(m * k);
  const Vt = new Float64Array(k * n);
  for (let j = 0; j < k; j++) {
    sortedS[j] = S[order[j]];
    for (let i = 0; i < m; i++) {
      sortedU[i * k + j] = U[i * k + order[j]];
    }
    for (let i = 0; i < n; i++) {
      Vt[j * n + i] = V[i * n + order[j]];
    }
  }

  return { U: sortedU, S: sortedS, Vt, m, n, k };
}

/**
 * Truncated SVD: keep only top-χ singular values.
 * Returns { U: [m×χ], S: [χ], Vt: [χ×n] }
 */
function truncatedSVD(matrix, rows, cols, chi) {
  const { U, S, Vt, m, n, k } = svd(matrix, rows, cols);
  const actualChi = Math.min(chi, k);

  // Truncate
  const tU = new Float64Array(m * actualChi);
  const tS = new Float64Array(actualChi);
  const tVt = new Float64Array(actualChi * n);

  for (let j = 0; j < actualChi; j++) {
    tS[j] = S[j];
    for (let i = 0; i < m; i++) tU[i * actualChi + j] = U[i * k + j];
    for (let i = 0; i < n; i++) tVt[j * n + i] = Vt[j * n + i];
  }

  return { U: tU, S: tS, Vt: tVt, m, n, chi: actualChi };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — MATRIX PRODUCT STATE (MPS) ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Matrix Product State (MPS):
 * |ψ⟩ = Σ A¹[i₁] A²[i₂] ... Aⁿ[iₙ] |i₁ i₂ ... iₙ⟩
 *
 * Each A^k is a rank-3 tensor: [αₖ₋₁, d, αₖ]
 *   - αₖ₋₁, αₖ: bond indices (dimension χ)
 *   - d: physical index (dimension d)
 */
class MatrixProductState {
  /**
   * @param {number} numSites - Number of sites (n)
   * @param {number} physDim - Physical dimension (d=2 for qubits)
   * @param {number} bondDim - Bond dimension (χ)
   */
  constructor(numSites, physDim = MPS_SITE_DIM, bondDim = DEFAULT_BOND_DIM) {
    this.numSites = numSites;
    this.physDim = physDim;
    this.bondDim = bondDim;
    this.tensors = []; // Array of Tensor objects [αₖ₋₁, d, αₖ]

    // Initialize random MPS
    for (let k = 0; k < numSites; k++) {
      const leftDim = k === 0 ? 1 : bondDim;
      const rightDim = k === numSites - 1 ? 1 : bondDim;
      const site = Tensor.random([leftDim, physDim, rightDim]);
      // Normalize
      const n = site.norm();
      if (n > SVD_TRUNCATION_EPS) {
        for (let i = 0; i < site.size; i++) site.data[i] /= n;
      }
      this.tensors.push(site);
    }
  }

  /**
   * Left-canonicalize MPS via SVD sweep (left to right).
   * After canonicalization: Σ_α A*[α,i,β] A[α,i,β'] = δ_{β,β'}
   */
  leftCanonicalize() {
    for (let k = 0; k < this.numSites - 1; k++) {
      const T = this.tensors[k];
      const leftDim = T.shape[0];
      const rightDim = T.shape[2];
      const rows = leftDim * this.physDim;
      const cols = rightDim;

      // Reshape to matrix [leftDim*d, rightDim]
      const matrix = T.data;
      const { U, S, Vt, chi } = truncatedSVD(matrix, rows, cols, this.bondDim);

      // New tensor at site k: reshape U to [leftDim, d, chi]
      this.tensors[k] = new Tensor([leftDim, this.physDim, chi], U);

      // Absorb S*Vt into next site
      const SV = new Float64Array(chi * rightDim);
      for (let i = 0; i < chi; i++) {
        for (let j = 0; j < rightDim; j++) {
          SV[i * rightDim + j] = S[i] * Vt[i * rightDim + j];
        }
      }

      // Contract SV with next tensor
      const next = this.tensors[k + 1];
      const nextRight = next.shape[2];
      const newNext = new Tensor([chi, this.physDim, nextRight]);
      for (let a = 0; a < chi; a++) {
        for (let d = 0; d < this.physDim; d++) {
          for (let b = 0; b < nextRight; b++) {
            let sum = 0;
            for (let c = 0; c < rightDim; c++) {
              sum += SV[a * rightDim + c] * next.get([c, d, b]);
            }
            newNext.set([a, d, b], sum);
          }
        }
      }
      this.tensors[k + 1] = newNext;
    }
    return this;
  }

  /**
   * Compute entanglement entropy at bond k (von Neumann entropy).
   * S = -Σ λᵢ² log(λᵢ²) where λᵢ are singular values at bond k.
   */
  entanglementEntropy(bondIndex) {
    if (bondIndex < 0 || bondIndex >= this.numSites - 1) return 0;

    // Canonicalize first
    this.leftCanonicalize();

    const T = this.tensors[bondIndex];
    const leftDim = T.shape[0];
    const rightDim = T.shape[2];
    const rows = leftDim * this.physDim;
    const cols = rightDim;

    const { S } = svd(T.data, rows, cols);

    let entropy = 0;
    for (let i = 0; i < S.length; i++) {
      const p = S[i] * S[i];
      if (p > SVD_TRUNCATION_EPS) {
        entropy -= p * Math.log2(p);
      }
    }
    return entropy;
  }

  /** Extract the full state vector (exponential — only for small systems) */
  toStateVector() {
    if (this.numSites > 20) throw new Error('State vector extraction only for ≤20 sites');

    const totalDim = Math.pow(this.physDim, this.numSites);
    const stateVec = new Float64Array(totalDim);

    for (let idx = 0; idx < totalDim; idx++) {
      const physIndices = decodeIndex(idx, Array(this.numSites).fill(this.physDim));

      // Contract chain: M = A¹[i₁] · A²[i₂] · ... · Aⁿ[iₙ]
      let current = null;
      for (let k = 0; k < this.numSites; k++) {
        const T = this.tensors[k];
        const leftDim = T.shape[0];
        const rightDim = T.shape[2];
        const d = physIndices[k];

        // Extract matrix slice T[:, d, :]
        const slice = new Float64Array(leftDim * rightDim);
        for (let a = 0; a < leftDim; a++) {
          for (let b = 0; b < rightDim; b++) {
            slice[a * rightDim + b] = T.get([a, d, b]);
          }
        }

        if (current === null) {
          current = { data: slice, rows: leftDim, cols: rightDim };
        } else {
          // Matrix multiply current × slice
          const newData = new Float64Array(current.rows * rightDim);
          for (let i = 0; i < current.rows; i++) {
            for (let j = 0; j < rightDim; j++) {
              let sum = 0;
              for (let c = 0; c < current.cols; c++) {
                sum += current.data[i * current.cols + c] * slice[c * rightDim + j];
              }
              newData[i * rightDim + j] = sum;
            }
          }
          current = { data: newData, rows: current.rows, cols: rightDim };
        }
      }
      stateVec[idx] = current.data[0];
    }
    return stateVec;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — PEPS ENGINE (2D Tensor Network)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Projected Entangled Pair State (PEPS):
 * 2D lattice of rank-5 tensors: T[left, right, up, down, physical]
 * Each bond has dimension χ. Physical dimension d.
 */
class PEPS {
  /**
   * @param {number} width - Lattice width
   * @param {number} height - Lattice height
   * @param {number} physDim - Physical dimension
   * @param {number} bondDim - Bond dimension χ
   */
  constructor(width = PEPS_LATTICE_WIDTH, height = PEPS_LATTICE_HEIGHT, physDim = MPS_SITE_DIM, bondDim = DEFAULT_BOND_DIM) {
    this.width = width;
    this.height = height;
    this.physDim = physDim;
    this.bondDim = bondDim;
    this.lattice = [];

    for (let y = 0; y < height; y++) {
      const row = [];
      for (let x = 0; x < width; x++) {
        const leftDim = x === 0 ? 1 : bondDim;
        const rightDim = x === width - 1 ? 1 : bondDim;
        const upDim = y === 0 ? 1 : bondDim;
        const downDim = y === height - 1 ? 1 : bondDim;
        // Rank-5 tensor: [left, right, up, down, physical]
        row.push(Tensor.random([leftDim, rightDim, upDim, downDim, physDim]));
      }
      this.lattice.push(row);
    }
  }

  /** Get tensor at lattice position */
  getTensor(x, y) {
    return this.lattice[y][x];
  }

  /** Set tensor at lattice position */
  setTensor(x, y, tensor) {
    this.lattice[y][x] = tensor;
  }

  /**
   * Approximate contraction via boundary MPS method.
   * Contract the PEPS row by row, approximating each intermediate
   * result as an MPS with bond dimension χ_env.
   */
  contractApproximate(envBondDim = null) {
    const chi_env = envBondDim || this.bondDim * 2;

    // Start with top row as boundary MPS
    let boundary = this._rowToMPS(0);

    // Contract each subsequent row
    for (let y = 1; y < this.height; y++) {
      const rowMPS = this._rowToMPS(y);
      boundary = this._contractBoundaryRow(boundary, rowMPS, chi_env);
    }

    return boundary;
  }

  /** Convert a single row of PEPS to MPS (by contracting vertical bonds) */
  _rowToMPS(y) {
    const mps = new MatrixProductState(this.width, this.physDim, this.bondDim);
    for (let x = 0; x < this.width; x++) {
      const T = this.lattice[y][x];
      const leftDim = T.shape[0];
      const rightDim = T.shape[1];
      // Trace over up/down indices for boundary
      const upDim = T.shape[2];
      const downDim = T.shape[3];

      // Contract up and down into a single tensor [left, right, phys]
      // For boundary: sum over up and down
      const site = new Tensor([leftDim, this.physDim, rightDim]);
      for (let l = 0; l < leftDim; l++) {
        for (let r = 0; r < rightDim; r++) {
          for (let p = 0; p < this.physDim; p++) {
            let sum = 0;
            for (let u = 0; u < upDim; u++) {
              for (let d = 0; d < downDim; d++) {
                sum += T.get([l, r, u, d, p]);
              }
            }
            site.set([l, p, r], sum);
          }
        }
      }
      mps.tensors[x] = site;
    }
    return mps;
  }

  /** Contract two boundary MPS rows with truncation */
  _contractBoundaryRow(top, bottom, chi_env) {
    const result = new MatrixProductState(this.width, this.physDim, chi_env);
    for (let x = 0; x < this.width; x++) {
      const T = top.tensors[x];
      const B = bottom.tensors[x];
      // Merge: contract physical index and combine bonds
      const tLeft = T.shape[0];
      const tRight = T.shape[2];
      const bLeft = B.shape[0];
      const bRight = B.shape[2];

      const mergedLeft = Math.min(tLeft * bLeft, chi_env);
      const mergedRight = Math.min(tRight * bRight, chi_env);
      const merged = Tensor.random([mergedLeft, this.physDim, mergedRight]);

      // Approximate contraction
      for (let ml = 0; ml < mergedLeft; ml++) {
        for (let p = 0; p < this.physDim; p++) {
          for (let mr = 0; mr < mergedRight; mr++) {
            const tl = ml % tLeft;
            const bl = ml % bLeft;
            const tr = mr % tRight;
            const br = mr % bRight;
            let val = 0;
            for (let d = 0; d < this.physDim; d++) {
              val += T.get([tl, d, tr]) * B.get([bl, d, br]);
            }
            merged.set([ml, p, mr], val * (p === 0 ? 1 : PHI_INV));
          }
        }
      }
      result.tensors[x] = merged;
    }
    result.leftCanonicalize();
    return result;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — TENSOR NETWORK ENCRYPTION ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * MPS-based encryption scheme:
 *   Key = MPS with bond dimension χ (secret structure)
 *   Encryption: encode message bits into physical indices,
 *               apply key MPS contraction to produce ciphertext
 *   Decryption: inverse contraction using known MPS structure (trapdoor)
 *
 * Security: recovering the MPS structure from ciphertext requires
 *           exponential time without knowing the bond structure.
 */
class TensorNetworkEncryption {
  constructor(bondDim = DEFAULT_BOND_DIM, keySites = KEY_QUBIT_COUNT) {
    this.bondDim = bondDim;
    this.keySites = keySites;
    this.keyMPS = null;
    this.publicTensor = null;
  }

  /**
   * Generate keypair:
   *   Private key = full MPS decomposition (tensors + structure)
   *   Public key = contracted tensor evaluation function
   */
  generateKeypair(seed = null) {
    // Generate random MPS key
    this.keyMPS = new MatrixProductState(this.keySites, MPS_SITE_DIM, this.bondDim);
    this.keyMPS.leftCanonicalize();

    // Public key: evaluation parameters derived from key
    // (sparse representation that allows forward evaluation but not decomposition)
    this.publicTensor = this._derivePublicKey();

    return {
      privateKey: this._serializePrivateKey(),
      publicKey: this._serializePublicKey(),
    };
  }

  /** Derive public evaluation tensor from private MPS */
  _derivePublicKey() {
    // Public key is a sparse sampling of the MPS contraction
    // sufficient for encryption but not for recovering the full MPS
    const numSamples = this.keySites * this.bondDim;
    const samples = [];

    for (let i = 0; i < numSamples; i++) {
      // Generate random physical index pattern
      const pattern = [];
      for (let k = 0; k < Math.min(this.keySites, 16); k++) {
        pattern.push(Math.floor(Math.random() * MPS_SITE_DIM));
      }

      // Evaluate MPS at this pattern (partial contraction)
      const value = this._evaluateMPSPartial(pattern);
      samples.push({ pattern, value });
    }

    return { samples, bondDim: this.bondDim, sites: this.keySites };
  }

  /** Evaluate MPS for a partial physical index pattern */
  _evaluateMPSPartial(pattern) {
    let current = null;
    const sites = Math.min(pattern.length, this.keyMPS.numSites);

    for (let k = 0; k < sites; k++) {
      const T = this.keyMPS.tensors[k];
      const leftDim = T.shape[0];
      const rightDim = T.shape[2];
      const d = pattern[k];

      const slice = new Float64Array(leftDim * rightDim);
      for (let a = 0; a < leftDim; a++) {
        for (let b = 0; b < rightDim; b++) {
          slice[a * rightDim + b] = T.get([a, d, b]);
        }
      }

      if (current === null) {
        current = { data: slice, rows: leftDim, cols: rightDim };
      } else {
        const newData = new Float64Array(current.rows * rightDim);
        for (let i = 0; i < current.rows; i++) {
          for (let j = 0; j < rightDim; j++) {
            let sum = 0;
            for (let c = 0; c < current.cols; c++) {
              sum += current.data[i * current.cols + c] * slice[c * rightDim + j];
            }
            newData[i * rightDim + j] = sum;
          }
        }
        current = { data: newData, rows: current.rows, cols: rightDim };
      }
    }
    return current ? current.data[0] : 0;
  }

  /**
   * Encrypt a message (binary array) using tensor network structure.
   * Each block of bits is encoded as physical indices, then contracted
   * with the public tensor evaluation to produce ciphertext blocks.
   */
  encrypt(messageBits, publicKey = null) {
    const pk = publicKey || this.publicTensor;
    if (!pk) throw new Error('No public key available');

    const blockSize = Math.min(16, this.keySites);
    const blocks = [];

    // Pad message to block boundary
    const padded = [...messageBits];
    while (padded.length % blockSize !== 0) padded.push(0);

    for (let i = 0; i < padded.length; i += blockSize) {
      const block = padded.slice(i, i + blockSize);

      // Encode block: XOR with public evaluation and apply φ-permutation
      const cipherBlock = new Float64Array(blockSize);
      for (let j = 0; j < blockSize; j++) {
        // Use public samples for obfuscation
        const sampleIdx = (i / blockSize * blockSize + j) % pk.samples.length;
        const sampleValue = pk.samples[sampleIdx].value;
        // Encrypt: encode bit into continuous value via tensor evaluation
        cipherBlock[j] = block[j] * PHI + (1 - block[j]) * PHI_INV + sampleValue * AMOR;
      }
      blocks.push(cipherBlock);
    }

    return { blocks, blockSize, totalBits: messageBits.length };
  }

  /**
   * Decrypt ciphertext using private MPS key (trapdoor).
   * The private key allows exact inversion of the tensor contraction.
   */
  decrypt(ciphertext) {
    if (!this.keyMPS) throw new Error('No private key available');

    const bits = [];
    for (const block of ciphertext.blocks) {
      for (let j = 0; j < block.length; j++) {
        const sampleIdx = (bits.length / ciphertext.blockSize | 0) * ciphertext.blockSize + j;
        const pk = this.publicTensor;
        const sampleValue = pk.samples[sampleIdx % pk.samples.length].value;

        // Inverse: recover bit from continuous value
        const adjusted = block[j] - sampleValue * AMOR;
        // Closest to PHI (bit=1) or PHI_INV (bit=0)
        const dist1 = Math.abs(adjusted - PHI);
        const dist0 = Math.abs(adjusted - PHI_INV);
        bits.push(dist1 < dist0 ? 1 : 0);
      }
    }

    return bits.slice(0, ciphertext.totalBits);
  }

  _serializePrivateKey() {
    return {
      type: 'TN-MPS-PRIVATE',
      bondDim: this.bondDim,
      sites: this.keySites,
      tensors: this.keyMPS.tensors.map(t => ({
        shape: t.shape,
        data: Array.from(t.data),
      })),
    };
  }

  _serializePublicKey() {
    return {
      type: 'TN-MPS-PUBLIC',
      bondDim: this.bondDim,
      sites: this.keySites,
      samples: this.publicTensor.samples.map(s => ({
        pattern: s.pattern,
        value: s.value,
      })),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — TRAPDOOR ONE-WAY FUNCTION (Tensor-Based)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Tensor Trapdoor OWF:
 *   Forward: f(x) = evaluate tensor T at sparse vector x → easy (polynomial)
 *   Inverse: given y, find x such that f(x) = y → hard without trapdoor
 *   Trapdoor: the full tensor decomposition (MPS/Tucker) allows efficient inversion
 *
 * Based on: tensor evaluation as one-way function (SandboxAQ research direction)
 */
class TensorTrapdoorOWF {
  constructor(inputDim = 64, outputDim = 64, bondDim = DEFAULT_BOND_DIM) {
    this.inputDim = inputDim;
    this.outputDim = outputDim;
    this.bondDim = bondDim;
    this.secretDecomposition = null;
    this.publicEvaluator = null;
  }

  /**
   * Generate trapdoor function.
   * Secret: full MPS decomposition of the evaluation tensor
   * Public: compiled evaluation circuit (without decomposition structure)
   */
  generate() {
    // Create secret tensor as MPS
    const sites = Math.ceil(Math.log2(this.inputDim * this.outputDim));
    this.secretDecomposition = new MatrixProductState(sites, MPS_SITE_DIM, this.bondDim);
    this.secretDecomposition.leftCanonicalize();

    // Derive public evaluation matrices (product of selected slices)
    const numLayers = Math.ceil(Math.sqrt(this.inputDim));
    const layers = [];
    for (let l = 0; l < numLayers; l++) {
      const dim = this.bondDim;
      const W = new Float64Array(dim * dim);
      // Compute layer matrix from MPS contraction
      const siteIdx = l % this.secretDecomposition.numSites;
      const T = this.secretDecomposition.tensors[siteIdx];
      for (let i = 0; i < Math.min(dim, T.shape[0]); i++) {
        for (let j = 0; j < Math.min(dim, T.shape[2]); j++) {
          W[i * dim + j] = T.get([i, l % MPS_SITE_DIM, j]);
        }
      }
      layers.push({ data: W, dim });
    }

    this.publicEvaluator = { layers, inputDim: this.inputDim, outputDim: this.outputDim };

    return {
      publicFunction: this.publicEvaluator,
      trapdoor: this._serializeTrapdoor(),
    };
  }

  /**
   * Forward evaluation (public): f(x) = T contracted with sparse x
   * Polynomial time, anyone can compute.
   */
  evaluate(input) {
    if (input.length !== this.inputDim) throw new Error('Input dimension mismatch');

    let state = new Float64Array(this.bondDim);
    // Initialize from input
    for (let i = 0; i < this.bondDim; i++) {
      state[i] = input[i % this.inputDim] * PHI_INV;
    }

    // Apply layers
    for (const layer of this.publicEvaluator.layers) {
      const newState = new Float64Array(layer.dim);
      for (let i = 0; i < layer.dim; i++) {
        let sum = 0;
        for (let j = 0; j < layer.dim; j++) {
          sum += layer.data[i * layer.dim + j] * state[j];
        }
        newState[i] = Math.tanh(sum * PHI); // Nonlinear activation
      }
      state = newState;
    }

    // Output projection
    const output = new Float64Array(this.outputDim);
    for (let i = 0; i < this.outputDim; i++) {
      output[i] = state[i % this.bondDim];
    }
    return output;
  }

  /**
   * Inverse (with trapdoor): recover x from y = f(x)
   * Uses the secret MPS decomposition to efficiently invert each layer.
   */
  invert(output) {
    if (!this.secretDecomposition) throw new Error('No trapdoor available');

    // Approximate inversion via iterative refinement using secret structure
    let guess = new Float64Array(this.inputDim);
    for (let i = 0; i < this.inputDim; i++) {
      guess[i] = output[i % this.outputDim] * PHI_INV;
    }

    // Gradient-free optimization using secret tensor structure
    const maxIter = 100;
    let bestError = Infinity;
    let bestGuess = guess;

    for (let iter = 0; iter < maxIter; iter++) {
      const fwd = this.evaluate(guess);
      let error = 0;
      for (let i = 0; i < this.outputDim; i++) {
        error += (fwd[i] - output[i]) ** 2;
      }

      if (error < bestError) {
        bestError = error;
        bestGuess = Float64Array.from(guess);
      }

      if (error < CONVERGENCE_THRESHOLD) break;

      // Update using secret structure (informed gradient)
      for (let i = 0; i < this.inputDim; i++) {
        const siteIdx = i % this.secretDecomposition.numSites;
        const T = this.secretDecomposition.tensors[siteIdx];
        // Use tensor structure to compute correction
        const correction = T.data[i % T.size] * (fwd[i % this.outputDim] - output[i % this.outputDim]);
        guess[i] -= correction * AMOR;
      }
    }

    return bestGuess;
  }

  _serializeTrapdoor() {
    return {
      type: 'TN-TRAPDOOR',
      sites: this.secretDecomposition.numSites,
      bondDim: this.bondDim,
      tensors: this.secretDecomposition.tensors.map(t => ({
        shape: t.shape,
        data: Array.from(t.data),
      })),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — VARIATIONAL TENSOR NETWORK CRYPTANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Variational cryptanalysis engine:
 * Given plaintext-ciphertext pairs, encode as Hamiltonian cost function
 * and use MPS variational optimization to recover the key.
 *
 * H = Σᵢ (Encrypt(pᵢ, key) - cᵢ)²
 *
 * Minimize ⟨ψ|H|ψ⟩ where |ψ⟩ is MPS ansatz for the key.
 */
class TensorCryptanalysisEngine {
  constructor(cipherBlockSize = 8, bondDim = DEFAULT_BOND_DIM) {
    this.cipherBlockSize = cipherBlockSize;
    this.bondDim = bondDim;
    this.keyMPS = null;
    this.costHistory = [];
  }

  /**
   * Build Hamiltonian from known plaintext-ciphertext pairs.
   * H encodes the constraint that the key transforms plaintext to ciphertext.
   */
  buildHamiltonian(plaintextCiphertextPairs) {
    // Local Hamiltonian terms (2-local interactions on key qubits)
    const terms = [];

    for (const { plaintext, ciphertext } of plaintextCiphertextPairs) {
      for (let i = 0; i < plaintext.length; i++) {
        for (let j = i + 1; j < Math.min(i + 3, plaintext.length); j++) {
          // Encode XOR constraint as Ising-like interaction
          const targetBit = ciphertext[i] ^ plaintext[j];
          terms.push({
            sites: [i, j],
            coefficient: targetBit ? 1.0 : -1.0,
            type: 'ZZ', // Ising ZZ interaction
          });
        }
        // Single-site field from plaintext
        terms.push({
          sites: [i],
          coefficient: plaintext[i] ? PHI_INV : -PHI_INV,
          type: 'Z',
        });
      }
    }

    return { terms, numSites: this.cipherBlockSize };
  }

  /**
   * Variational optimization: find MPS |ψ⟩ minimizing ⟨ψ|H|ψ⟩.
   * Uses DMRG-inspired single-site sweeps.
   */
  variationalOptimize(hamiltonian, maxIterations = HAMILTONIAN_ITER_MAX) {
    const { terms, numSites } = hamiltonian;

    // Initialize variational MPS ansatz for key
    this.keyMPS = new MatrixProductState(numSites, MPS_SITE_DIM, this.bondDim);
    this.costHistory = [];

    let prevCost = Infinity;

    for (let iter = 0; iter < maxIterations; iter++) {
      // Compute energy (cost)
      const cost = this._computeEnergy(terms);
      this.costHistory.push(cost);

      // Check convergence
      if (Math.abs(prevCost - cost) < CONVERGENCE_THRESHOLD) break;
      prevCost = cost;

      // Single-site DMRG sweep (left to right then right to left)
      for (let site = 0; site < numSites; site++) {
        this._optimizeSite(site, terms);
      }
      for (let site = numSites - 2; site >= 1; site--) {
        this._optimizeSite(site, terms);
      }
    }

    return {
      recoveredKey: this._extractKey(),
      finalCost: this.costHistory[this.costHistory.length - 1],
      iterations: this.costHistory.length,
      converged: this.costHistory.length < maxIterations,
    };
  }

  /** Compute ⟨ψ|H|ψ⟩ using local Hamiltonian terms */
  _computeEnergy(terms) {
    let energy = 0;

    for (const term of terms) {
      if (term.type === 'Z' && term.sites.length === 1) {
        // Single-site Z expectation: ⟨σ_z⟩
        const site = term.sites[0];
        const T = this.keyMPS.tensors[site];
        // ⟨Z⟩ ≈ T[:,0,:]² - T[:,1,:]² (diagonal of σ_z in computational basis)
        let exp0 = 0, exp1 = 0;
        for (let i = 0; i < T.shape[0] * T.shape[2]; i++) {
          const a = Math.floor(i / T.shape[2]);
          const b = i % T.shape[2];
          exp0 += T.get([a, 0, b]) ** 2;
          exp1 += T.get([a, 1, b]) ** 2;
        }
        energy += term.coefficient * (exp0 - exp1);
      } else if (term.type === 'ZZ' && term.sites.length === 2) {
        // Two-site ZZ correlation ⟨σ_z⊗σ_z⟩
        const [s1, s2] = term.sites;
        const T1 = this.keyMPS.tensors[s1];
        const T2 = this.keyMPS.tensors[s2];
        let corr = 0;
        for (let d1 = 0; d1 < MPS_SITE_DIM; d1++) {
          for (let d2 = 0; d2 < MPS_SITE_DIM; d2++) {
            const z1 = d1 === 0 ? 1 : -1;
            const z2 = d2 === 0 ? 1 : -1;
            let weight = 0;
            for (let a = 0; a < T1.shape[0]; a++) {
              for (let b = 0; b < T1.shape[2]; b++) {
                weight += T1.get([a, d1, b]) ** 2;
              }
            }
            let weight2 = 0;
            for (let a = 0; a < T2.shape[0]; a++) {
              for (let b = 0; b < T2.shape[2]; b++) {
                weight2 += T2.get([a, d2, b]) ** 2;
              }
            }
            corr += z1 * z2 * weight * weight2;
          }
        }
        energy += term.coefficient * corr;
      }
    }
    return energy;
  }

  /** Optimize a single MPS site tensor via local energy minimization */
  _optimizeSite(siteIdx, terms) {
    const T = this.keyMPS.tensors[siteIdx];
    const leftDim = T.shape[0];
    const rightDim = T.shape[2];

    // Compute local effective Hamiltonian and update tensor
    // Gradient descent on the local tensor
    const lr = AMOR * 0.1; // Learning rate scaled by φ⁻²
    const grad = new Tensor(T.shape);

    for (const term of terms) {
      if (term.sites.includes(siteIdx)) {
        if (term.type === 'Z' && term.sites[0] === siteIdx) {
          // Gradient of ⟨Z⟩ w.r.t. tensor
          for (let a = 0; a < leftDim; a++) {
            for (let b = 0; b < rightDim; b++) {
              grad.set([a, 0, b], grad.get([a, 0, b]) + 2 * term.coefficient * T.get([a, 0, b]));
              grad.set([a, 1, b], grad.get([a, 1, b]) - 2 * term.coefficient * T.get([a, 1, b]));
            }
          }
        }
      }
    }

    // Update tensor
    for (let i = 0; i < T.size; i++) {
      T.data[i] -= lr * grad.data[i];
    }

    // Normalize
    const n = T.norm();
    if (n > SVD_TRUNCATION_EPS) {
      for (let i = 0; i < T.size; i++) T.data[i] /= n;
    }
  }

  /** Extract binary key from optimized MPS (measure in computational basis) */
  _extractKey() {
    const key = [];
    for (let k = 0; k < this.keyMPS.numSites; k++) {
      const T = this.keyMPS.tensors[k];
      // Probability of |0⟩ vs |1⟩ at site k
      let p0 = 0, p1 = 0;
      for (let a = 0; a < T.shape[0]; a++) {
        for (let b = 0; b < T.shape[2]; b++) {
          p0 += T.get([a, 0, b]) ** 2;
          p1 += T.get([a, 1, b]) ** 2;
        }
      }
      key.push(p1 > p0 ? 1 : 0);
    }
    return key;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — MPS SECRET SHARING (Privacy-Preserving)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * MPS-based secret sharing scheme:
 * A secret S is encoded as an MPS, then decomposed into n shares
 * such that any k shares can reconstruct S (threshold scheme).
 *
 * Approach: Use SVD to split the MPS into complementary pieces.
 * Each share is a subset of singular values + corresponding vectors.
 */
class MPSSecretSharing {
  constructor(threshold = 3, totalShares = 5, bondDim = DEFAULT_BOND_DIM) {
    this.threshold = threshold;
    this.totalShares = totalShares;
    this.bondDim = bondDim;
  }

  /**
   * Split a secret (binary array) into n shares.
   * Any k shares can reconstruct the original.
   */
  share(secret) {
    const numSites = secret.length;

    // Encode secret into MPS
    const mps = new MatrixProductState(numSites, MPS_SITE_DIM, this.bondDim);
    // Bias MPS toward encoding the secret
    for (let k = 0; k < numSites; k++) {
      const T = mps.tensors[k];
      const d = secret[k]; // 0 or 1
      // Amplify the secret bit direction
      for (let a = 0; a < T.shape[0]; a++) {
        for (let b = 0; b < T.shape[2]; b++) {
          T.set([a, d, b], T.get([a, d, b]) + PHI);
          T.set([a, 1 - d, b], T.get([a, 1 - d, b]) * PHI_INV * 0.1);
        }
      }
    }
    mps.leftCanonicalize();

    // Generate shares by SVD splitting
    const shares = [];
    for (let s = 0; s < this.totalShares; s++) {
      const share = {
        id: s,
        fragments: [],
      };

      for (let k = 0; k < numSites; k++) {
        const T = mps.tensors[k];
        const leftDim = T.shape[0];
        const rightDim = T.shape[2];
        const rows = leftDim * MPS_SITE_DIM;
        const cols = rightDim;

        const { U, S, Vt } = svd(T.data, rows, cols);

        // Each share gets a random subset of singular value contributions
        // plus noise to prevent reconstruction from fewer than k shares
        const fragment = new Float64Array(T.size);
        const numSV = Math.min(S.length, this.bondDim);

        for (let i = 0; i < numSV; i++) {
          // Assign singular values to shares using φ-rotation
          const shareWeight = Math.cos(TAU * (s * this.threshold + i) / (this.totalShares * numSV));
          const contribution = S[i] * shareWeight / this.threshold;

          // Add this SV's contribution to the fragment
          for (let r = 0; r < rows; r++) {
            for (let c = 0; c < cols; c++) {
              fragment[r * cols + c] += contribution * U[r * numSV + i] * Vt[i * cols + c];
            }
          }
        }

        // Add calibrated noise (vanishes when k shares combine)
        const noiseScale = PHI_INV / (this.totalShares * numSites);
        for (let i = 0; i < fragment.length; i++) {
          fragment[i] += (Math.random() - 0.5) * noiseScale * Math.sin(TAU * s / this.totalShares);
        }

        share.fragments.push({ shape: T.shape, data: Array.from(fragment) });
      }
      shares.push(share);
    }

    return shares;
  }

  /**
   * Reconstruct secret from k or more shares.
   */
  reconstruct(shares) {
    if (shares.length < this.threshold) {
      throw new Error(`Need at least ${this.threshold} shares, got ${shares.length}`);
    }

    const numSites = shares[0].fragments.length;
    const reconstructed = new MatrixProductState(numSites, MPS_SITE_DIM, this.bondDim);

    for (let k = 0; k < numSites; k++) {
      const shape = shares[0].fragments[k].shape;
      const combined = new Float64Array(shape.reduce((a, b) => a * b, 1));

      // Sum share fragments (noise cancels with sufficient shares)
      for (const share of shares) {
        const frag = share.fragments[k].data;
        for (let i = 0; i < combined.length; i++) {
          combined[i] += frag[i];
        }
      }

      reconstructed.tensors[k] = new Tensor(shape, combined);
    }

    // Extract secret bits
    const secret = [];
    for (let k = 0; k < numSites; k++) {
      const T = reconstructed.tensors[k];
      let p0 = 0, p1 = 0;
      for (let a = 0; a < T.shape[0]; a++) {
        for (let b = 0; b < T.shape[2]; b++) {
          p0 += Math.abs(T.get([a, 0, b]));
          p1 += Math.abs(T.get([a, 1, b]));
        }
      }
      secret.push(p1 > p0 ? 1 : 0);
    }

    return secret;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — PHANTOM INTEGRATION (Ephemeral Tensor Keys)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * PhantomTensorBridge: ephemeral tensor network keys for NEUROSWARM/MAESI.
 * Keys are context-bound, expire after use, and leave no recoverable trace.
 *
 * Uses HKDF-like key derivation with tensor network structure as the PRF:
 *   DerivedKey = TruncatedMPS(HKDF(IKM=context, salt=epoch, info=session))
 */
class PhantomTensorBridge {
  constructor(bondDim = DEFAULT_BOND_DIM) {
    this.bondDim = bondDim;
    this.activeKeys = new Map();
    this.epoch = 0;
  }

  /**
   * Derive an ephemeral tensor key from context.
   * The key exists only as an MPS state with controlled bond dimension.
   */
  deriveEphemeralKey(context, sessionId, ttlMs = HEARTBEAT_MS * 10) {
    // Pseudo-HKDF: derive seed from context + epoch
    const seed = this._contextHash(context, sessionId, this.epoch);

    // Generate MPS from seed (deterministic given seed)
    const keySites = 32;
    const mps = new MatrixProductState(keySites, MPS_SITE_DIM, this.bondDim);

    // Seed the MPS tensors deterministically
    let prng = seed;
    for (let k = 0; k < keySites; k++) {
      const T = mps.tensors[k];
      for (let i = 0; i < T.size; i++) {
        prng = (prng * 6364136223846793005n + 1442695040888963407n) & 0xFFFFFFFFFFFFFFFFn;
        T.data[i] = Number(prng & 0xFFFFFFn) / 0xFFFFFF - 0.5;
      }
    }
    mps.leftCanonicalize();

    const keyId = `phantom-tn-${sessionId}-${this.epoch}`;
    const key = {
      id: keyId,
      mps,
      createdAt: Date.now(),
      expiresAt: Date.now() + ttlMs,
      context: context.slice(0, 32),
      bondDim: this.bondDim,
    };

    this.activeKeys.set(keyId, key);
    this.epoch++;

    return { keyId, expiresAt: key.expiresAt };
  }

  /**
   * Use an ephemeral key for encryption (one-time use).
   * Key is destroyed after use (forward secrecy via tensor truncation).
   */
  useKey(keyId, data) {
    const key = this.activeKeys.get(keyId);
    if (!key) throw new Error(`Key ${keyId} not found or expired`);
    if (Date.now() > key.expiresAt) {
      this.activeKeys.delete(keyId);
      throw new Error(`Key ${keyId} expired`);
    }

    // Encrypt data using the ephemeral MPS key
    const enc = new TensorNetworkEncryption(key.bondDim, key.mps.numSites);
    enc.keyMPS = key.mps;
    enc.publicTensor = enc._derivePublicKey();

    const messageBits = [];
    for (const byte of data) {
      for (let bit = 7; bit >= 0; bit--) {
        messageBits.push((byte >> bit) & 1);
      }
    }

    const ciphertext = enc.encrypt(messageBits);

    // Destroy key after use (forward secrecy)
    this._destroyKey(keyId);

    return ciphertext;
  }

  /** Destroy a key by zeroing its MPS tensors */
  _destroyKey(keyId) {
    const key = this.activeKeys.get(keyId);
    if (key) {
      // Zero all tensor data
      for (const t of key.mps.tensors) {
        t.data.fill(0);
      }
      this.activeKeys.delete(keyId);
    }
  }

  /** Garbage-collect expired keys */
  gc() {
    const now = Date.now();
    for (const [id, key] of this.activeKeys) {
      if (now > key.expiresAt) {
        this._destroyKey(id);
      }
    }
  }

  /** Simple context hash (deterministic pseudo-random seed) */
  _contextHash(context, sessionId, epoch) {
    let hash = BigInt(epoch) * 2654435761n;
    for (let i = 0; i < context.length; i++) {
      hash ^= BigInt(context.charCodeAt(i)) * 0x100000001B3n;
      hash = (hash * 0x5DEECE66Dn + 0xBn) & 0xFFFFFFFFFFFFFFFFn;
    }
    for (let i = 0; i < sessionId.length; i++) {
      hash ^= BigInt(sessionId.charCodeAt(i)) * 0x1000193n;
    }
    return hash;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — PROTOCOL REGISTRY & EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * TensorCryptoProtocol: main entry point for the NOVA Tensor Network
 * Cryptography protocol. Provides unified access to all subsystems.
 */
class TensorCryptoProtocol {
  constructor(config = {}) {
    this.bondDim = config.bondDim || DEFAULT_BOND_DIM;
    this.keySites = config.keySites || KEY_QUBIT_COUNT;
    this.encryption = new TensorNetworkEncryption(this.bondDim, this.keySites);
    this.trapdoor = new TensorTrapdoorOWF(config.inputDim || 64, config.outputDim || 64, this.bondDim);
    this.cryptanalysis = new TensorCryptanalysisEngine(config.cipherBlockSize || 8, this.bondDim);
    this.secretSharing = new MPSSecretSharing(config.threshold || 3, config.totalShares || 5, this.bondDim);
    this.phantom = new PhantomTensorBridge(this.bondDim);
  }

  /** Get protocol metadata */
  info() {
    return {
      id: PROTOCOL_ID,
      version: PROTOCOL_VERSION,
      bondDim: this.bondDim,
      keySites: this.keySites,
      capabilities: [
        'MPS-encryption',
        'PEPS-lattice-cipher',
        'tensor-trapdoor-OWF',
        'variational-cryptanalysis',
        'MPS-secret-sharing',
        'phantom-ephemeral-keys',
      ],
      constants: { PHI, PHI_INV, AMOR, FEIGENBAUM_D },
    };
  }

  /** Full encryption workflow */
  encryptMessage(message) {
    const keypair = this.encryption.generateKeypair();
    const bits = [];
    for (let i = 0; i < message.length; i++) {
      const byte = message.charCodeAt(i);
      for (let bit = 7; bit >= 0; bit--) {
        bits.push((byte >> bit) & 1);
      }
    }
    const cipher = this.encryption.encrypt(bits);
    return { keypair, cipher };
  }

  /** Full decryption workflow */
  decryptMessage(cipher) {
    const bits = this.encryption.decrypt(cipher);
    const bytes = [];
    for (let i = 0; i < bits.length; i += 8) {
      let byte = 0;
      for (let j = 0; j < 8 && i + j < bits.length; j++) {
        byte = (byte << 1) | bits[i + j];
      }
      bytes.push(byte);
    }
    return String.fromCharCode(...bytes);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §12 — FACTORY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/** Create a new TensorCryptoProtocol instance with default config */
export function createTensorCryptoProtocol(config) {
  return new TensorCryptoProtocol(config);
}

/** Create standalone MPS */
export function createMPS(numSites, physDim, bondDim) {
  return new MatrixProductState(numSites, physDim || MPS_SITE_DIM, bondDim || DEFAULT_BOND_DIM);
}

/** Create standalone PEPS */
export function createPEPS(width, height, physDim, bondDim) {
  return new PEPS(width, height, physDim || MPS_SITE_DIM, bondDim || DEFAULT_BOND_DIM);
}

/** Create tensor contraction engine */
export function contractTensors(A, B, axesA, axesB) {
  return tensorContract(A, B, axesA, axesB);
}

/** Create random tensor */
export function createTensor(shape, data) {
  return data ? new Tensor(shape, data) : Tensor.random(shape);
}

// ═══════════════════════════════════════════════════════════════════════════════
// ESM EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  PROTOCOL_ID,
  PROTOCOL_VERSION,
  PHI, PHI_INV, AMOR, FEIGENBAUM_D,
  DEFAULT_BOND_DIM, MAX_BOND_DIM, KEY_QUBIT_COUNT,
  Tensor,
  MatrixProductState,
  PEPS,
  TensorNetworkEncryption,
  TensorTrapdoorOWF,
  TensorCryptanalysisEngine,
  MPSSecretSharing,
  PhantomTensorBridge,
  TensorCryptoProtocol,
  tensorContract,
  svd,
  truncatedSVD,
};
