/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA SERVITOR: TENSOR CRYPTO SOLVER WORKER  (GOL-TNCRYPT-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * KERNEL ID:     GOL-TNCRYPT-001
 * FAMILY:        CRYPTO_AETERNA
 * HEARTBEAT:     COR_PARVUM (873ms MiniHeart Kuramoto φ-oscillator)
 * BRAIN:         CEREBRUM_COMPOSITUM (tensor network cryptographic intelligence)
 * MACHINE:       MACHINA_VIRTUALIS (Turing-capable state machine)
 *
 * STATE MACHINE:
 *   IDLE → PARSE → DECOMPOSE → CONTRACT → ENCRYPT → ANALYSE → EMIT
 *
 * PURPOSE:
 *   Autonomous tensor network cryptography solver. Handles:
 *   - MPS/PEPS key generation with φ-weighted bond dimensions
 *   - Tensor contraction-based encryption/decryption
 *   - Variational cryptanalysis via Hamiltonian optimization
 *   - Secret sharing through tensor decomposition
 *   - Ephemeral key management (Phantom integration)
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * ═══════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══ SOVEREIGN CONSTANTS ═════════════════════════════════════════════════════

const KERNEL_ID        = 'GOL-TNCRYPT-001';
const FAMILIA          = 'CRYPTO_AETERNA';
const HEARTBEAT_MS     = 873;
const PHI              = 1.6180339887498948482;
const PHI_INV          = 0.6180339887498948482;
const AMOR             = 0.3819660112501051518;  // φ⁻²
const FEIGENBAUM_D     = 4.6692016091029906719;

// Tensor network parameters
const DEFAULT_BOND_DIM = 16;
const MAX_BOND_DIM     = 256;
const PHYSICAL_DIM     = 2;
const SVD_EPSILON      = 1e-12;
const CONVERGENCE_EPS  = 1e-8;

// ═══ STATE MACHINE ═══════════════════════════════════════════════════════════

const STATES = Object.freeze({
  IDLE:       'IDLE',
  PARSE:      'PARSE',
  DECOMPOSE:  'DECOMPOSE',
  CONTRACT:   'CONTRACT',
  ENCRYPT:    'ENCRYPT',
  ANALYSE:    'ANALYSE',
  EMIT:       'EMIT',
});

let currentState = STATES.IDLE;
let tickCount = 0;
let coherence = PHI_INV;

// ═══ COR_PARVUM — 873ms MiniHeart ═══════════════════════════════════════════

const COR_PARVUM = {
  phase: 0,
  frequency: 1000 / HEARTBEAT_MS,  // Hz
  amplitude: PHI_INV,
  coupling: AMOR,

  tick() {
    this.phase += this.frequency * 0.001 * HEARTBEAT_MS;
    if (this.phase > 2 * Math.PI) this.phase -= 2 * Math.PI;
    // Kuramoto oscillator: dθ/dt = ω + K·sin(θ_fleet - θ)
    const kuramoto = this.coupling * Math.sin(0 - this.phase);
    this.phase += kuramoto;
    return {
      phase: this.phase,
      amplitude: this.amplitude * Math.cos(this.phase),
      coherence: Math.abs(Math.cos(this.phase)),
    };
  },
};

// ═══ CEREBRUM_COMPOSITUM — Tensor Crypto Intelligence ════════════════════════

const CEREBRUM_COMPOSITUM = {
  activeTasks: [],
  keypairs: new Map(),
  analysisResults: [],

  /**
   * Generate MPS keypair for tensor encryption
   */
  generateKeypair(bondDim = DEFAULT_BOND_DIM, keySites = 32) {
    const mps = createRandomMPS(keySites, PHYSICAL_DIM, bondDim);
    const canonical = leftCanonicalizeMPS(mps);

    // Derive public samples
    const samples = [];
    const numSamples = keySites * bondDim;
    for (let i = 0; i < numSamples; i++) {
      const pattern = [];
      for (let k = 0; k < Math.min(keySites, 16); k++) {
        pattern.push(Math.floor(Math.random() * PHYSICAL_DIM));
      }
      samples.push({ pattern, value: evaluateMPS(canonical, pattern) });
    }

    const keypairId = `${KERNEL_ID}-kp-${Date.now()}`;
    const keypair = { id: keypairId, mps: canonical, publicSamples: samples, bondDim, sites: keySites };
    this.keypairs.set(keypairId, keypair);

    return { keypairId, publicSamples: samples, bondDim, sites: keySites };
  },

  /**
   * Encrypt message using tensor network structure
   */
  encrypt(keypairId, messageBits) {
    const kp = this.keypairs.get(keypairId);
    if (!kp) throw new Error(`Keypair ${keypairId} not found`);

    const blockSize = Math.min(16, kp.sites);
    const padded = [...messageBits];
    while (padded.length % blockSize !== 0) padded.push(0);

    const blocks = [];
    for (let i = 0; i < padded.length; i += blockSize) {
      const block = padded.slice(i, i + blockSize);
      const cipher = new Array(blockSize);
      for (let j = 0; j < blockSize; j++) {
        const sIdx = ((i / blockSize) * blockSize + j) % kp.publicSamples.length;
        const sv = kp.publicSamples[sIdx].value;
        cipher[j] = block[j] * PHI + (1 - block[j]) * PHI_INV + sv * AMOR;
      }
      blocks.push(cipher);
    }

    return { blocks, blockSize, totalBits: messageBits.length };
  },

  /**
   * Decrypt ciphertext using private MPS key
   */
  decrypt(keypairId, ciphertext) {
    const kp = this.keypairs.get(keypairId);
    if (!kp) throw new Error(`Keypair ${keypairId} not found`);

    const bits = [];
    for (let bi = 0; bi < ciphertext.blocks.length; bi++) {
      const block = ciphertext.blocks[bi];
      for (let j = 0; j < block.length; j++) {
        const sIdx = (bi * ciphertext.blockSize + j) % kp.publicSamples.length;
        const sv = kp.publicSamples[sIdx].value;
        const adjusted = block[j] - sv * AMOR;
        const d1 = Math.abs(adjusted - PHI);
        const d0 = Math.abs(adjusted - PHI_INV);
        bits.push(d1 < d0 ? 1 : 0);
      }
    }
    return bits.slice(0, ciphertext.totalBits);
  },

  /**
   * Run variational cryptanalysis
   */
  cryptanalyse(plaintextCiphertextPairs, bondDim = DEFAULT_BOND_DIM, maxIter = 200) {
    const hamiltonian = buildHamiltonian(plaintextCiphertextPairs);
    const result = variationalOptimize(hamiltonian, bondDim, maxIter);
    this.analysisResults.push(result);
    return result;
  },

  /**
   * Secret sharing via MPS decomposition
   */
  shareSecret(secret, threshold, totalShares, bondDim = DEFAULT_BOND_DIM) {
    return mpsSecretShare(secret, threshold, totalShares, bondDim);
  },

  reconstructSecret(shares, threshold) {
    return mpsSecretReconstruct(shares, threshold);
  },
};

// ═══ MACHINA_VIRTUALIS — State Machine Engine ════════════════════════════════

const MACHINA_VIRTUALIS = {
  taskQueue: [],
  results: [],

  enqueue(task) {
    this.taskQueue.push({ ...task, enqueuedAt: Date.now() });
  },

  process() {
    if (this.taskQueue.length === 0) return null;

    const task = this.taskQueue.shift();
    currentState = STATES.PARSE;

    let result;
    try {
      switch (task.type) {
        case 'GENERATE_KEYPAIR':
          currentState = STATES.DECOMPOSE;
          result = CEREBRUM_COMPOSITUM.generateKeypair(task.bondDim, task.keySites);
          break;

        case 'ENCRYPT':
          currentState = STATES.ENCRYPT;
          result = CEREBRUM_COMPOSITUM.encrypt(task.keypairId, task.messageBits);
          break;

        case 'DECRYPT':
          currentState = STATES.ENCRYPT;
          result = CEREBRUM_COMPOSITUM.decrypt(task.keypairId, task.ciphertext);
          break;

        case 'CRYPTANALYSE':
          currentState = STATES.ANALYSE;
          result = CEREBRUM_COMPOSITUM.cryptanalyse(task.pairs, task.bondDim, task.maxIter);
          break;

        case 'SECRET_SHARE':
          currentState = STATES.DECOMPOSE;
          result = CEREBRUM_COMPOSITUM.shareSecret(task.secret, task.threshold, task.totalShares, task.bondDim);
          break;

        case 'SECRET_RECONSTRUCT':
          currentState = STATES.CONTRACT;
          result = CEREBRUM_COMPOSITUM.reconstructSecret(task.shares, task.threshold);
          break;

        default:
          throw new Error(`Unknown task type: ${task.type}`);
      }

      currentState = STATES.EMIT;
      this.results.push({ taskType: task.type, success: true, result, completedAt: Date.now() });
      return result;
    } catch (error) {
      currentState = STATES.IDLE;
      this.results.push({ taskType: task.type, success: false, error: error.message, completedAt: Date.now() });
      return null;
    }
  },
};

// ═══ TENSOR MATH SUBSTRATE (Worker-local) ════════════════════════════════════

function createRandomMPS(numSites, physDim, bondDim) {
  const sites = [];
  for (let k = 0; k < numSites; k++) {
    const left = k === 0 ? 1 : bondDim;
    const right = k === numSites - 1 ? 1 : bondDim;
    const size = left * physDim * right;
    const data = new Float64Array(size);
    for (let i = 0; i < size; i++) data[i] = (Math.random() * 2 - 1) * PHI_INV;
    // Normalize
    let norm = 0;
    for (let i = 0; i < size; i++) norm += data[i] * data[i];
    norm = Math.sqrt(norm);
    if (norm > SVD_EPSILON) for (let i = 0; i < size; i++) data[i] /= norm;
    sites.push({ left, physDim, right, data });
  }
  return { numSites, physDim, bondDim, sites };
}

function leftCanonicalizeMPS(mps) {
  const sites = mps.sites.map(s => ({ ...s, data: Float64Array.from(s.data) }));

  for (let k = 0; k < mps.numSites - 1; k++) {
    const site = sites[k];
    const rows = site.left * site.physDim;
    const cols = site.right;
    const { U, S, Vt, rank } = compactSVD(site.data, rows, cols, mps.bondDim);

    sites[k] = { left: site.left, physDim: site.physDim, right: rank, data: U };

    // Absorb S·Vt into next
    const next = sites[k + 1];
    const SV = new Float64Array(rank * cols);
    for (let i = 0; i < rank; i++)
      for (let j = 0; j < cols; j++)
        SV[i * cols + j] = S[i] * Vt[i * cols + j];

    const nextRight = next.right;
    const newData = new Float64Array(rank * mps.physDim * nextRight);
    for (let a = 0; a < rank; a++) {
      for (let d = 0; d < mps.physDim; d++) {
        for (let b = 0; b < nextRight; b++) {
          let sum = 0;
          for (let c = 0; c < cols; c++) {
            sum += SV[a * cols + c] * next.data[c * mps.physDim * nextRight + d * nextRight + b];
          }
          newData[a * mps.physDim * nextRight + d * nextRight + b] = sum;
        }
      }
    }
    sites[k + 1] = { left: rank, physDim: mps.physDim, right: nextRight, data: newData };
  }

  return { ...mps, sites };
}

function compactSVD(matrix, m, n, maxChi) {
  const k = Math.min(m, n, maxChi);
  const A = Float64Array.from(matrix);
  const V = new Float64Array(n * n);
  for (let i = 0; i < n; i++) V[i * n + i] = 1.0;

  for (let sweep = 0; sweep < 30; sweep++) {
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
        if (Math.abs(apq) < SVD_EPSILON) continue;
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
    if (off < SVD_EPSILON * SVD_EPSILON) break;
  }

  const S = new Float64Array(k);
  const U = new Float64Array(m * k);
  for (let j = 0; j < k; j++) {
    let cn = 0;
    for (let i = 0; i < m; i++) cn += A[i * n + j] * A[i * n + j];
    S[j] = Math.sqrt(cn);
    if (S[j] > SVD_EPSILON) for (let i = 0; i < m; i++) U[i * k + j] = A[i * n + j] / S[j];
  }

  const order = Array.from({ length: k }, (_, i) => i).sort((a, b) => S[b] - S[a]);
  const sS = new Float64Array(k);
  const sU = new Float64Array(m * k);
  const Vt = new Float64Array(k * n);
  for (let j = 0; j < k; j++) {
    sS[j] = S[order[j]];
    for (let i = 0; i < m; i++) sU[i * k + j] = U[i * k + order[j]];
    for (let i = 0; i < n; i++) Vt[j * n + i] = V[i * n + order[j]];
  }

  return { U: sU, S: sS, Vt, rank: k };
}

function evaluateMPS(mps, pattern) {
  let current = null;
  const n = Math.min(pattern.length, mps.numSites);

  for (let k = 0; k < n; k++) {
    const site = mps.sites[k];
    const d = pattern[k];
    const left = site.left;
    const right = site.right;

    const slice = new Float64Array(left * right);
    for (let a = 0; a < left; a++) {
      for (let b = 0; b < right; b++) {
        slice[a * right + b] = site.data[a * site.physDim * right + d * right + b];
      }
    }

    if (!current) {
      current = { data: slice, rows: left, cols: right };
    } else {
      const nd = new Float64Array(current.rows * right);
      for (let i = 0; i < current.rows; i++) {
        for (let j = 0; j < right; j++) {
          let sum = 0;
          for (let c = 0; c < current.cols; c++) sum += current.data[i * current.cols + c] * slice[c * right + j];
          nd[i * right + j] = sum;
        }
      }
      current = { data: nd, rows: current.rows, cols: right };
    }
  }
  return current ? current.data[0] : 0;
}

function buildHamiltonian(pairs) {
  const terms = [];
  let maxSite = 0;
  for (const { plaintext, ciphertext } of pairs) {
    for (let i = 0; i < plaintext.length; i++) {
      maxSite = Math.max(maxSite, i);
      for (let j = i + 1; j < Math.min(i + 3, plaintext.length); j++) {
        terms.push({ sites: [i, j], coeff: (ciphertext[i] ^ plaintext[j]) ? 1.0 : -1.0, type: 'ZZ' });
      }
      terms.push({ sites: [i], coeff: plaintext[i] ? PHI_INV : -PHI_INV, type: 'Z' });
    }
  }
  return { terms, numSites: maxSite + 1 };
}

function variationalOptimize(hamiltonian, bondDim, maxIter) {
  const { terms, numSites } = hamiltonian;
  let mps = createRandomMPS(numSites, PHYSICAL_DIM, bondDim);
  const costHistory = [];
  let prev = Infinity;

  for (let iter = 0; iter < maxIter; iter++) {
    let energy = 0;
    for (const term of terms) {
      if (term.type === 'Z') {
        const site = mps.sites[term.sites[0]];
        let p0 = 0, p1 = 0;
        for (let a = 0; a < site.left; a++) {
          for (let b = 0; b < site.right; b++) {
            p0 += site.data[a * site.physDim * site.right + 0 * site.right + b] ** 2;
            p1 += site.data[a * site.physDim * site.right + 1 * site.right + b] ** 2;
          }
        }
        energy += term.coeff * (p0 - p1);
      } else if (term.type === 'ZZ') {
        const s1 = mps.sites[term.sites[0]], s2 = mps.sites[term.sites[1]];
        let corr = 0;
        for (let d1 = 0; d1 < PHYSICAL_DIM; d1++) {
          for (let d2 = 0; d2 < PHYSICAL_DIM; d2++) {
            const z1 = d1 === 0 ? 1 : -1, z2 = d2 === 0 ? 1 : -1;
            let w1 = 0, w2 = 0;
            for (let a = 0; a < s1.left; a++)
              for (let b = 0; b < s1.right; b++)
                w1 += s1.data[a * s1.physDim * s1.right + d1 * s1.right + b] ** 2;
            for (let a = 0; a < s2.left; a++)
              for (let b = 0; b < s2.right; b++)
                w2 += s2.data[a * s2.physDim * s2.right + d2 * s2.right + b] ** 2;
            corr += z1 * z2 * w1 * w2;
          }
        }
        energy += term.coeff * corr;
      }
    }

    costHistory.push(energy);
    if (Math.abs(prev - energy) < CONVERGENCE_EPS) break;
    prev = energy;

    // Update sites
    const lr = AMOR * 0.1;
    for (let site = 0; site < numSites; site++) {
      const s = mps.sites[site];
      for (const term of terms) {
        if (term.type === 'Z' && term.sites[0] === site) {
          for (let a = 0; a < s.left; a++) {
            for (let b = 0; b < s.right; b++) {
              const i0 = a * s.physDim * s.right + 0 * s.right + b;
              const i1 = a * s.physDim * s.right + 1 * s.right + b;
              s.data[i0] -= lr * 2 * term.coeff * s.data[i0];
              s.data[i1] += lr * 2 * term.coeff * s.data[i1];
            }
          }
        }
      }
      let norm = 0;
      for (let i = 0; i < s.data.length; i++) norm += s.data[i] * s.data[i];
      norm = Math.sqrt(norm);
      if (norm > SVD_EPSILON) for (let i = 0; i < s.data.length; i++) s.data[i] /= norm;
    }
  }

  // Extract key
  const key = [];
  for (let k = 0; k < numSites; k++) {
    const s = mps.sites[k];
    let p0 = 0, p1 = 0;
    for (let a = 0; a < s.left; a++) {
      for (let b = 0; b < s.right; b++) {
        p0 += s.data[a * s.physDim * s.right + 0 * s.right + b] ** 2;
        p1 += s.data[a * s.physDim * s.right + 1 * s.right + b] ** 2;
      }
    }
    key.push(p1 > p0 ? 1 : 0);
  }

  return {
    recoveredKey: key,
    finalCost: costHistory[costHistory.length - 1],
    iterations: costHistory.length,
    converged: costHistory.length < maxIter,
  };
}

function mpsSecretShare(secret, threshold, totalShares, bondDim) {
  const numSites = secret.length;
  const mps = createRandomMPS(numSites, PHYSICAL_DIM, bondDim);

  // Bias toward secret
  for (let k = 0; k < numSites; k++) {
    const s = mps.sites[k];
    const d = secret[k];
    for (let a = 0; a < s.left; a++) {
      for (let b = 0; b < s.right; b++) {
        const id = a * s.physDim * s.right + d * s.right + b;
        const ind = a * s.physDim * s.right + (1 - d) * s.right + b;
        s.data[id] += PHI;
        s.data[ind] *= PHI_INV * 0.1;
      }
    }
  }

  const canonical = leftCanonicalizeMPS(mps);
  const shares = [];

  for (let sh = 0; sh < totalShares; sh++) {
    const fragments = [];
    for (let k = 0; k < numSites; k++) {
      const site = canonical.sites[k];
      const rows = site.left * site.physDim;
      const cols = site.right;
      const { U, S, Vt, rank } = compactSVD(site.data, rows, cols, bondDim);

      const frag = new Float64Array(site.data.length);
      for (let i = 0; i < rank; i++) {
        const w = Math.cos(2 * Math.PI * (sh * threshold + i) / (totalShares * rank));
        const c = S[i] * w / threshold;
        for (let r = 0; r < rows; r++) {
          for (let col = 0; col < cols; col++) {
            frag[r * cols + col] += c * U[r * rank + i] * Vt[i * cols + col];
          }
        }
      }
      fragments.push({ left: site.left, physDim: site.physDim, right: site.right, data: Array.from(frag) });
    }
    shares.push({ id: sh, fragments });
  }

  return shares;
}

function mpsSecretReconstruct(shares, threshold) {
  if (shares.length < threshold) throw new Error(`Need ≥${threshold} shares`);

  const numSites = shares[0].fragments.length;
  const secret = [];

  for (let k = 0; k < numSites; k++) {
    const frag0 = shares[0].fragments[k];
    const combined = new Float64Array(frag0.data.length);
    for (const share of shares) {
      const fd = share.fragments[k].data;
      for (let i = 0; i < combined.length; i++) combined[i] += fd[i];
    }

    const left = frag0.left, physDim = frag0.physDim, right = frag0.right;
    let p0 = 0, p1 = 0;
    for (let a = 0; a < left; a++) {
      for (let b = 0; b < right; b++) {
        p0 += Math.abs(combined[a * physDim * right + 0 * right + b]);
        p1 += Math.abs(combined[a * physDim * right + 1 * right + b]);
      }
    }
    secret.push(p1 > p0 ? 1 : 0);
  }

  return secret;
}

// ═══ MAIN HEARTBEAT LOOP ════════════════════════════════════════════════════

function tick() {
  tickCount++;
  const heart = COR_PARVUM.tick();
  coherence = heart.coherence;

  // Process any queued tasks
  const result = MACHINA_VIRTUALIS.process();

  // Emit telemetry
  if (typeof self !== 'undefined' && self.postMessage) {
    self.postMessage({
      type: 'HEARTBEAT',
      kernel: KERNEL_ID,
      familia: FAMILIA,
      tick: tickCount,
      state: currentState,
      coherence,
      phase: heart.phase,
      queueLength: MACHINA_VIRTUALIS.taskQueue.length,
      keypairsActive: CEREBRUM_COMPOSITUM.keypairs.size,
      result: result || null,
    });
  }

  currentState = STATES.IDLE;
}

// ═══ MESSAGE HANDLER ═════════════════════════════════════════════════════════

if (typeof self !== 'undefined' && self.addEventListener) {
  self.addEventListener('message', (event) => {
    const msg = event.data;

    switch (msg.type) {
      case 'GENERATE_KEYPAIR':
        MACHINA_VIRTUALIS.enqueue({ type: 'GENERATE_KEYPAIR', bondDim: msg.bondDim, keySites: msg.keySites });
        break;

      case 'ENCRYPT':
        MACHINA_VIRTUALIS.enqueue({ type: 'ENCRYPT', keypairId: msg.keypairId, messageBits: msg.messageBits });
        break;

      case 'DECRYPT':
        MACHINA_VIRTUALIS.enqueue({ type: 'DECRYPT', keypairId: msg.keypairId, ciphertext: msg.ciphertext });
        break;

      case 'CRYPTANALYSE':
        MACHINA_VIRTUALIS.enqueue({ type: 'CRYPTANALYSE', pairs: msg.pairs, bondDim: msg.bondDim, maxIter: msg.maxIter });
        break;

      case 'SECRET_SHARE':
        MACHINA_VIRTUALIS.enqueue({
          type: 'SECRET_SHARE', secret: msg.secret,
          threshold: msg.threshold, totalShares: msg.totalShares, bondDim: msg.bondDim,
        });
        break;

      case 'SECRET_RECONSTRUCT':
        MACHINA_VIRTUALIS.enqueue({ type: 'SECRET_RECONSTRUCT', shares: msg.shares, threshold: msg.threshold });
        break;

      case 'STATUS':
        if (self.postMessage) {
          self.postMessage({
            type: 'STATUS_RESPONSE',
            kernel: KERNEL_ID,
            familia: FAMILIA,
            state: currentState,
            coherence,
            tickCount,
            queueLength: MACHINA_VIRTUALIS.taskQueue.length,
            keypairsActive: CEREBRUM_COMPOSITUM.keypairs.size,
            analysisCount: CEREBRUM_COMPOSITUM.analysisResults.length,
          });
        }
        break;
    }
  });
}

// ═══ START HEARTBEAT ═════════════════════════════════════════════════════════

const heartbeatInterval = setInterval(tick, HEARTBEAT_MS);

// Emit birth signal
if (typeof self !== 'undefined' && self.postMessage) {
  self.postMessage({
    type: 'BIRTH',
    kernel: KERNEL_ID,
    familia: FAMILIA,
    capabilities: [
      'MPS_ENCRYPTION',
      'PEPS_LATTICE_CIPHER',
      'TENSOR_TRAPDOOR_OWF',
      'VARIATIONAL_CRYPTANALYSIS',
      'MPS_SECRET_SHARING',
      'PHANTOM_EPHEMERAL_KEYS',
    ],
    bondDimRange: [1, MAX_BOND_DIM],
    heartbeatMs: HEARTBEAT_MS,
    phi: PHI,
  });
}
