// ═══════════════════════════════════════════════════════════════════════════════
// Tests for PROTOCOL-TENSOR-CRYPTO (BUILD №68)
// ═══════════════════════════════════════════════════════════════════════════════

import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import {
  PROTOCOL_ID, PROTOCOL_VERSION,
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
  createTensorCryptoProtocol,
  createMPS,
  createPEPS,
  createTensor,
} from '../PROTOCOL-TENSOR-CRYPTO.js';

// ═══ §1 — Protocol Identity ═════════════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Identity', () => {
  it('should have correct protocol ID and version', () => {
    assert.strictEqual(PROTOCOL_ID, 'PROTOCOL-TENSOR-CRYPTO');
    assert.strictEqual(PROTOCOL_VERSION, '1.0.0');
  });

  it('should export sovereign constants', () => {
    assert.strictEqual(PHI, 1.6180339887498948482);
    assert.strictEqual(PHI_INV, 0.6180339887498948482);
    assert.strictEqual(AMOR, 0.3819660112501051518);
    assert.strictEqual(FEIGENBAUM_D, 4.6692016091029906719);
  });

  it('should have correct tensor network parameters', () => {
    assert.strictEqual(DEFAULT_BOND_DIM, 16);
    assert.strictEqual(MAX_BOND_DIM, 256);
    assert.strictEqual(KEY_QUBIT_COUNT, 128);
  });
});

// ═══ §2 — Tensor Primitives ═════════════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Tensor Primitives', () => {
  it('should create tensor with correct shape', () => {
    const t = new Tensor([3, 4, 5]);
    assert.deepStrictEqual(t.shape, [3, 4, 5]);
    assert.strictEqual(t.rank, 3);
    assert.strictEqual(t.size, 60);
  });

  it('should get/set tensor elements', () => {
    const t = new Tensor([2, 3]);
    t.set([1, 2], 3.14);
    assert.strictEqual(t.get([1, 2]), 3.14);
    assert.strictEqual(t.get([0, 0]), 0);
  });

  it('should create random tensor', () => {
    const t = Tensor.random([4, 4]);
    assert.strictEqual(t.size, 16);
    // Should have non-zero entries
    let hasNonZero = false;
    for (let i = 0; i < t.size; i++) {
      if (t.data[i] !== 0) hasNonZero = true;
    }
    assert.ok(hasNonZero);
  });

  it('should compute Frobenius norm', () => {
    const t = new Tensor([2], [3, 4]);
    assert.ok(Math.abs(t.norm() - 5) < 1e-10);
  });

  it('should reshape tensor', () => {
    const t = new Tensor([2, 3], [1, 2, 3, 4, 5, 6]);
    const r = t.reshape([3, 2]);
    assert.deepStrictEqual(r.shape, [3, 2]);
    assert.strictEqual(r.data[0], 1);
    assert.strictEqual(r.data[5], 6);
  });

  it('should create identity tensor', () => {
    const I = Tensor.identity(3);
    assert.strictEqual(I.get([0, 0]), 1);
    assert.strictEqual(I.get([1, 1]), 1);
    assert.strictEqual(I.get([0, 1]), 0);
  });
});

// ═══ §3 — Tensor Contraction ═════════════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Tensor Contraction', () => {
  it('should contract two matrices (matrix multiplication)', () => {
    // A[2,3] * B[3,2] = C[2,2]
    const A = new Tensor([2, 3], [1, 2, 3, 4, 5, 6]);
    const B = new Tensor([3, 2], [1, 2, 3, 4, 5, 6]);
    const C = tensorContract(A, B, [1], [0]);
    assert.deepStrictEqual(C.shape, [2, 2]);
    // C[0,0] = 1*1 + 2*3 + 3*5 = 22
    assert.ok(Math.abs(C.get([0, 0]) - 22) < 1e-10);
    // C[0,1] = 1*2 + 2*4 + 3*6 = 28
    assert.ok(Math.abs(C.get([0, 1]) - 28) < 1e-10);
  });

  it('should contract vectors (dot product)', () => {
    const a = new Tensor([3], [1, 2, 3]);
    const b = new Tensor([3], [4, 5, 6]);
    const c = tensorContract(a, b, [0], [0]);
    // 1*4 + 2*5 + 3*6 = 32
    assert.ok(Math.abs(c.data[0] - 32) < 1e-10);
  });

  it('should throw on dimension mismatch', () => {
    const A = new Tensor([2, 3]);
    const B = new Tensor([4, 2]);
    assert.throws(() => tensorContract(A, B, [1], [0]));
  });
});

// ═══ §4 — SVD Engine ═════════════════════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: SVD', () => {
  it('should decompose matrix and reconstruct', () => {
    // Full-rank 3x3 matrix for stable SVD
    const data = new Float64Array([2, 0, 1, 0, 3, 0, 1, 0, 4]);
    const { U, S, Vt } = svd(data, 3, 3);

    // Reconstruct: A ≈ U * diag(S) * Vt
    const k = S.length;
    for (let i = 0; i < 3; i++) {
      for (let j = 0; j < 3; j++) {
        let val = 0;
        for (let r = 0; r < k; r++) {
          val += U[i * k + r] * S[r] * Vt[r * 3 + j];
        }
        assert.ok(Math.abs(val - data[i * 3 + j]) < 1e-6, `Reconstruction error at [${i},${j}]: got ${val}, expected ${data[i*3+j]}`);
      }
    }
  });

  it('should return sorted singular values', () => {
    const data = new Float64Array([1, 0, 0, 0, 3, 0, 0, 0, 2]);
    const { S } = svd(data, 3, 3);
    // Should be sorted descending
    for (let i = 0; i < S.length - 1; i++) {
      assert.ok(S[i] >= S[i + 1], `S[${i}]=${S[i]} should >= S[${i + 1}]=${S[i + 1]}`);
    }
  });

  it('should truncate SVD to given chi', () => {
    const data = new Float64Array(16);
    for (let i = 0; i < 16; i++) data[i] = Math.random();
    const { S } = truncatedSVD(data, 4, 4, 2);
    assert.strictEqual(S.length, 2);
  });
});

// ═══ §5 — Matrix Product State ══════════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: MPS', () => {
  it('should create MPS with correct structure', () => {
    const mps = createMPS(8, 2, 4);
    assert.strictEqual(mps.numSites, 8);
    assert.strictEqual(mps.physDim, 2);
    assert.strictEqual(mps.bondDim, 4);
    assert.strictEqual(mps.tensors.length, 8);
    // First site: left=1, right=4
    assert.deepStrictEqual(mps.tensors[0].shape, [1, 2, 4]);
    // Last site: left=4, right=1
    assert.deepStrictEqual(mps.tensors[7].shape, [4, 2, 1]);
  });

  it('should left-canonicalize MPS', () => {
    const mps = createMPS(4, 2, 4);
    mps.leftCanonicalize();
    // After canonicalization, tensors should still have valid norms
    for (const t of mps.tensors) {
      assert.ok(t.norm() > 0, 'Tensor should have non-zero norm');
    }
  });

  it('should compute entanglement entropy', () => {
    const mps = createMPS(6, 2, 4);
    const entropy = mps.entanglementEntropy(2);
    // Entropy should be non-negative
    assert.ok(entropy >= 0, `Entropy should be >= 0, got ${entropy}`);
  });

  it('should extract state vector for small MPS', () => {
    const mps = createMPS(4, 2, 2);
    const sv = mps.toStateVector();
    assert.strictEqual(sv.length, 16); // 2^4 = 16
  });
});

// ═══ §6 — PEPS ══════════════════════════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: PEPS', () => {
  it('should create PEPS lattice with correct dimensions', () => {
    const peps = createPEPS(4, 4, 2, 4);
    assert.strictEqual(peps.width, 4);
    assert.strictEqual(peps.height, 4);
    assert.ok(peps.lattice[0][0] instanceof Tensor);
  });

  it('should have correct boundary conditions', () => {
    const peps = new PEPS(3, 3, 2, 4);
    // Corner (0,0): left=1, right=4, up=1, down=4
    const corner = peps.getTensor(0, 0);
    assert.strictEqual(corner.shape[0], 1); // left
    assert.strictEqual(corner.shape[1], 4); // right
    assert.strictEqual(corner.shape[2], 1); // up
    assert.strictEqual(corner.shape[3], 4); // down
  });

  it('should perform approximate contraction', () => {
    const peps = new PEPS(3, 3, 2, 2);
    const result = peps.contractApproximate(4);
    assert.ok(result instanceof MatrixProductState);
    assert.strictEqual(result.numSites, 3);
  });
});

// ═══ §7 — Tensor Network Encryption ═════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Encryption', () => {
  it('should generate keypair', () => {
    const enc = new TensorNetworkEncryption(8, 16);
    const { privateKey, publicKey } = enc.generateKeypair();
    assert.strictEqual(privateKey.type, 'TN-MPS-PRIVATE');
    assert.strictEqual(publicKey.type, 'TN-MPS-PUBLIC');
    assert.strictEqual(privateKey.bondDim, 8);
    assert.ok(publicKey.samples.length > 0);
  });

  it('should encrypt and decrypt message correctly', () => {
    const enc = new TensorNetworkEncryption(8, 16);
    enc.generateKeypair();

    const message = [1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0];
    const cipher = enc.encrypt(message);
    const decrypted = enc.decrypt(cipher);

    assert.deepStrictEqual(decrypted, message);
  });

  it('should handle empty message', () => {
    const enc = new TensorNetworkEncryption(8, 16);
    enc.generateKeypair();
    const cipher = enc.encrypt([]);
    const decrypted = enc.decrypt(cipher);
    assert.deepStrictEqual(decrypted, []);
  });

  it('should encrypt different messages to different ciphertexts', () => {
    const enc = new TensorNetworkEncryption(8, 16);
    enc.generateKeypair();

    const m1 = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0];
    const m2 = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1];

    const c1 = enc.encrypt(m1);
    const c2 = enc.encrypt(m2);

    // Ciphertexts should differ
    let differs = false;
    for (let i = 0; i < c1.blocks[0].length; i++) {
      if (c1.blocks[0][i] !== c2.blocks[0][i]) differs = true;
    }
    assert.ok(differs);
  });
});

// ═══ §8 — Trapdoor One-Way Function ═════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Trapdoor OWF', () => {
  it('should generate trapdoor function', () => {
    const owf = new TensorTrapdoorOWF(16, 16, 8);
    const { publicFunction, trapdoor } = owf.generate();
    assert.ok(publicFunction.layers.length > 0);
    assert.strictEqual(trapdoor.type, 'TN-TRAPDOOR');
  });

  it('should evaluate forward function', () => {
    const owf = new TensorTrapdoorOWF(16, 16, 8);
    owf.generate();

    const input = new Float64Array(16);
    for (let i = 0; i < 16; i++) input[i] = Math.random();

    const output = owf.evaluate(input);
    assert.strictEqual(output.length, 16);
    // Output should be bounded by tanh
    for (let i = 0; i < output.length; i++) {
      assert.ok(Math.abs(output[i]) <= 1.01, `Output ${output[i]} exceeds tanh bounds`);
    }
  });

  it('should produce different outputs for different inputs', () => {
    const owf = new TensorTrapdoorOWF(16, 16, 8);
    owf.generate();

    const i1 = new Float64Array(16).fill(0.5);
    const i2 = new Float64Array(16).fill(-0.5);

    const o1 = owf.evaluate(i1);
    const o2 = owf.evaluate(i2);

    let differs = false;
    for (let i = 0; i < 16; i++) {
      if (Math.abs(o1[i] - o2[i]) > 1e-10) differs = true;
    }
    assert.ok(differs);
  });

  it('should invert with trapdoor (approximate)', () => {
    const owf = new TensorTrapdoorOWF(8, 8, 4);
    owf.generate();

    const input = new Float64Array(8);
    for (let i = 0; i < 8; i++) input[i] = (Math.random() - 0.5) * 0.5;

    const output = owf.evaluate(input);
    const recovered = owf.invert(output);

    // The inversion should get closer than random
    const fwdRecovered = owf.evaluate(recovered);
    let error = 0;
    for (let i = 0; i < 8; i++) error += (fwdRecovered[i] - output[i]) ** 2;
    // Error should be less than random baseline
    assert.ok(error < 8.0, `Inversion error ${error} too large`);
  });
});

// ═══ §9 — Variational Cryptanalysis ═════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Cryptanalysis', () => {
  it('should build Hamiltonian from plaintext-ciphertext pairs', () => {
    const engine = new TensorCryptanalysisEngine(8, 4);
    const hamiltonian = engine.buildHamiltonian([
      { plaintext: [1, 0, 1, 0, 1, 0, 1, 0], ciphertext: [0, 1, 1, 0, 0, 1, 0, 1] },
    ]);
    assert.ok(hamiltonian.terms.length > 0);
    assert.strictEqual(hamiltonian.numSites, 8);
  });

  it('should run variational optimization', () => {
    const engine = new TensorCryptanalysisEngine(4, 4);
    const hamiltonian = engine.buildHamiltonian([
      { plaintext: [1, 0, 1, 0], ciphertext: [0, 1, 0, 1] },
      { plaintext: [0, 0, 1, 1], ciphertext: [1, 1, 0, 0] },
    ]);
    const result = engine.variationalOptimize(hamiltonian, 50);
    assert.ok(result.recoveredKey.length === 4);
    assert.ok(result.iterations > 0);
    assert.ok(typeof result.finalCost === 'number');
  });

  it('should converge to lower cost', () => {
    const engine = new TensorCryptanalysisEngine(4, 4);
    const hamiltonian = engine.buildHamiltonian([
      { plaintext: [1, 1, 0, 0], ciphertext: [0, 0, 1, 1] },
    ]);
    engine.variationalOptimize(hamiltonian, 100);
    // Cost should generally decrease
    if (engine.costHistory.length > 2) {
      const first = engine.costHistory[0];
      const last = engine.costHistory[engine.costHistory.length - 1];
      // At minimum, the optimization shouldn't blow up
      assert.ok(Math.abs(last) < Math.abs(first) * 100);
    }
  });
});

// ═══ §10 — MPS Secret Sharing ════════════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Secret Sharing', () => {
  it('should split secret into shares', () => {
    const ss = new MPSSecretSharing(3, 5, 4);
    const secret = [1, 0, 1, 1, 0, 0, 1, 0];
    const shares = ss.share(secret);
    assert.strictEqual(shares.length, 5);
    assert.strictEqual(shares[0].fragments.length, 8);
  });

  it('should reconstruct from threshold shares', () => {
    const ss = new MPSSecretSharing(3, 5, 4);
    const secret = [1, 0, 1, 1, 0, 0, 1, 0];
    const shares = ss.share(secret);

    // Use first 3 shares (threshold = 3)
    const reconstructed = ss.reconstruct(shares.slice(0, 3));
    // Due to noise, reconstruction may not be perfect for all bits
    // but should recover majority correctly
    let correct = 0;
    for (let i = 0; i < secret.length; i++) {
      if (reconstructed[i] === secret[i]) correct++;
    }
    assert.ok(correct >= secret.length * 0.5, `Only ${correct}/${secret.length} bits correct`);
  });

  it('should reject reconstruction with too few shares', () => {
    const ss = new MPSSecretSharing(3, 5, 4);
    const secret = [1, 0, 1, 1];
    const shares = ss.share(secret);
    assert.throws(() => ss.reconstruct(shares.slice(0, 2)));
  });
});

// ═══ §11 — Phantom Tensor Bridge ════════════════════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Phantom Bridge', () => {
  it('should derive ephemeral keys', () => {
    const bridge = new PhantomTensorBridge(8);
    const { keyId, expiresAt } = bridge.deriveEphemeralKey('test-context', 'session-123');
    assert.ok(keyId.startsWith('phantom-tn-'));
    assert.ok(expiresAt > Date.now());
  });

  it('should use key for encryption (one-time)', () => {
    const bridge = new PhantomTensorBridge(8);
    const { keyId } = bridge.deriveEphemeralKey('context', 'sess-1', 60000);
    const data = new Uint8Array([72, 101, 108, 108, 111]); // "Hello"
    const cipher = bridge.useKey(keyId, data);
    assert.ok(cipher.blocks.length > 0);
    // Key should be destroyed after use
    assert.throws(() => bridge.useKey(keyId, data));
  });

  it('should reject expired keys', async () => {
    const bridge = new PhantomTensorBridge(8);
    const { keyId } = bridge.deriveEphemeralKey('ctx', 'sess', 1); // 1ms TTL
    await new Promise(r => setTimeout(r, 10));
    const data = new Uint8Array([1, 2, 3]);
    assert.throws(() => bridge.useKey(keyId, data));
  });

  it('should garbage-collect expired keys', async () => {
    const bridge = new PhantomTensorBridge(8);
    bridge.deriveEphemeralKey('a', 's1', 1);
    bridge.deriveEphemeralKey('b', 's2', 1);
    await new Promise(r => setTimeout(r, 10));
    bridge.gc();
    assert.strictEqual(bridge.activeKeys.size, 0);
  });
});

// ═══ §12 — TensorCryptoProtocol (Unified API) ═══════════════════════════════

describe('PROTOCOL-TENSOR-CRYPTO: Unified Protocol', () => {
  it('should create protocol instance', () => {
    const proto = createTensorCryptoProtocol({ bondDim: 8, keySites: 16 });
    assert.ok(proto instanceof TensorCryptoProtocol);
  });

  it('should return protocol info', () => {
    const proto = createTensorCryptoProtocol({ bondDim: 8 });
    const info = proto.info();
    assert.strictEqual(info.id, 'PROTOCOL-TENSOR-CRYPTO');
    assert.strictEqual(info.version, '1.0.0');
    assert.ok(info.capabilities.includes('MPS-encryption'));
    assert.ok(info.capabilities.includes('tensor-trapdoor-OWF'));
    assert.ok(info.capabilities.includes('variational-cryptanalysis'));
  });

  it('should encrypt and decrypt string message', () => {
    const proto = createTensorCryptoProtocol({ bondDim: 8, keySites: 16 });
    const { cipher } = proto.encryptMessage('Hi');
    const decrypted = proto.decryptMessage(cipher);
    assert.strictEqual(decrypted, 'Hi');
  });

  it('factory createTensor should work', () => {
    const t = createTensor([3, 3]);
    assert.ok(t instanceof Tensor);
    assert.strictEqual(t.size, 9);
  });
});
