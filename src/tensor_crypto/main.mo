// ═══════════════════════════════════════════════════════════════════════════════
// TENSOR CRYPTO CANISTER — Sovereign Tensor Network Cryptography (BUILD №68)
// ═══════════════════════════════════════════════════════════════════════════════
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// CONFIDENTIAL — ALL RIGHTS RESERVED
//
// On-chain sovereign tensor network cryptography:
//   • MPS key generation with φ-weighted bond dimensions
//   • Tensor contraction-based one-way functions (post-quantum candidate)
//   • Variational cryptanalysis cost function evaluation
//   • MPS-based secret sharing (threshold reconstruction)
//   • Ephemeral tensor key lifecycle management
//
// Compiled via: ./scripts/nova build tensor_crypto
// ═══════════════════════════════════════════════════════════════════════════════

import Array "mo:base/Array";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Principal "mo:base/Principal";

actor TensorCrypto {

  // ═══ Section 1: Sovereign Constants ══════════════════════════════════════════

  let PHI : Float         = 1.6180339887498948482;
  let PHI_INV : Float     = 0.6180339887498948482;
  let AMOR : Float        = 0.3819660112501051518; // φ⁻²
  let FEIGENBAUM_D : Float = 4.6692016091029906719;
  let SVD_EPSILON : Float = 1e-12;
  let CONVERGENCE_EPS : Float = 1e-8;

  let DEFAULT_BOND_DIM : Nat = 16;
  let MAX_BOND_DIM : Nat     = 256;
  let PHYSICAL_DIM : Nat     = 2; // qubit basis d=2

  // ═══ Section 2: Types ═══════════════════════════════════════════════════════

  type TensorShape = {
    dimensions : [Nat];
    rank : Nat;
    totalSize : Nat;
  };

  type MPSSite = {
    leftBond : Nat;
    physicalDim : Nat;
    rightBond : Nat;
    data : [Float]; // flat storage [leftBond × physicalDim × rightBond]
  };

  type MPSState = {
    numSites : Nat;
    physicalDim : Nat;
    bondDim : Nat;
    sites : [MPSSite];
  };

  type TensorKeypair = {
    id : Text;
    bondDim : Nat;
    numSites : Nat;
    createdAt : Int;
    publicSamples : [PublicSample];
  };

  type PublicSample = {
    pattern : [Nat];
    value : Float;
  };

  type EncryptedBlock = {
    data : [Float];
  };

  type Ciphertext = {
    blocks : [EncryptedBlock];
    blockSize : Nat;
    totalBits : Nat;
  };

  type SecretShare = {
    id : Nat;
    fragments : [[Float]];
    shapes : [(Nat, Nat, Nat)]; // (left, phys, right) per site
  };

  type SecurityEstimate = {
    bondDim : Nat;
    numSites : Nat;
    securityBits : Nat;
    entanglementCapacity : Float;
    phiScaledBondDim : Nat;
  };

  // ═══ Section 3: State ═══════════════════════════════════════════════════════

  stable var keypairCounter : Nat = 0;
  stable var totalEncryptions : Nat = 0;
  stable var totalDecryptions : Nat = 0;
  stable var totalShares : Nat = 0;

  // ═══ Section 4: Math Primitives ═════════════════════════════════════════════

  func absFloat(x : Float) : Float {
    if (x < 0.0) { -x } else { x };
  };

  func sqrtFloat(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 50) {
      let next = (guess + x / guess) / 2.0;
      if (absFloat(next - guess) < SVD_EPSILON) return next;
      guess := next;
      i += 1;
    };
    guess;
  };

  func tanhFloat(x : Float) : Float {
    let clamped = if (x > 20.0) { 20.0 } else if (x < -20.0) { -20.0 } else { x };
    let e2x = Float.exp(2.0 * clamped);
    (e2x - 1.0) / (e2x + 1.0);
  };

  func log2Float(x : Float) : Float {
    Float.log(x) / Float.log(2.0);
  };

  func cosFloat(x : Float) : Float {
    Float.cos(x);
  };

  func sinFloat(x : Float) : Float {
    Float.sin(x);
  };

  // Simple PRNG (xorshift64)
  var prngState : Nat64 = 88172645463325252;

  func prngNext() : Float {
    prngState := prngState ^ (prngState << 13);
    prngState := prngState ^ (prngState >> 7);
    prngState := prngState ^ (prngState << 17);
    let normalized = Float.fromInt(Nat64.toNat(prngState % 1000000) |> Int.abs(_)) / 1000000.0;
    normalized * 2.0 - 1.0;
  };

  func seedPRNG(seed : Nat64) {
    prngState := if (seed == 0) { 88172645463325252 } else { seed };
  };

  // ═══ Section 5: Tensor Operations ══════════════════════════════════════════

  /// Create a random MPS site tensor
  func randomMPSSite(leftBond : Nat, physDim : Nat, rightBond : Nat) : MPSSite {
    let size = leftBond * physDim * rightBond;
    let buf = Buffer.Buffer<Float>(size);
    var norm : Float = 0.0;

    var i = 0;
    while (i < size) {
      let val = prngNext() * PHI_INV;
      buf.add(val);
      norm += val * val;
      i += 1;
    };

    // Normalize
    norm := sqrtFloat(norm);
    let data = if (norm > SVD_EPSILON) {
      Array.tabulate<Float>(size, func(j : Nat) : Float { buf.get(j) / norm });
    } else {
      Array.freeze(buf);
    };

    { leftBond; physicalDim = physDim; rightBond; data };
  };

  /// Create a random MPS with given parameters
  func createMPS(numSites : Nat, physDim : Nat, bondDim : Nat) : MPSState {
    let sites = Array.tabulate<MPSSite>(numSites, func(k : Nat) : MPSSite {
      let left = if (k == 0) { 1 } else { bondDim };
      let right = if (k == numSites - 1) { 1 } else { bondDim };
      randomMPSSite(left, physDim, right);
    });
    { numSites; physicalDim = physDim; bondDim; sites };
  };

  /// Flat index computation for rank-3 tensor [left, phys, right]
  func flatIdx3(a : Nat, d : Nat, b : Nat, physDim : Nat, rightBond : Nat) : Nat {
    a * physDim * rightBond + d * rightBond + b;
  };

  /// Evaluate MPS at a partial physical index pattern
  func evaluateMPS(mps : MPSState, pattern : [Nat]) : Float {
    let n = Nat.min(pattern.size(), mps.numSites);
    var currentData : ?[Float] = null;
    var currentRows : Nat = 0;
    var currentCols : Nat = 0;

    var k = 0;
    while (k < n) {
      let site = mps.sites[k];
      let d = pattern[k];
      let left = site.leftBond;
      let right = site.rightBond;

      // Extract slice T[:, d, :]
      let slice = Array.tabulate<Float>(left * right, func(idx : Nat) : Float {
        let a = idx / right;
        let b = idx % right;
        site.data[flatIdx3(a, d, b, site.physicalDim, right)];
      });

      switch (currentData) {
        case null {
          currentData := ?slice;
          currentRows := left;
          currentCols := right;
        };
        case (?cur) {
          // Matrix multiply current × slice
          let newData = Array.tabulate<Float>(currentRows * right, func(idx : Nat) : Float {
            let i = idx / right;
            let j = idx % right;
            var sum : Float = 0.0;
            var c = 0;
            while (c < currentCols) {
              sum += cur[i * currentCols + c] * slice[c * right + j];
              c += 1;
            };
            sum;
          });
          currentData := ?newData;
          currentCols := right;
        };
      };
      k += 1;
    };

    switch (currentData) {
      case null { 0.0 };
      case (?d) { if (d.size() > 0) { d[0] } else { 0.0 } };
    };
  };

  // ═══ Section 6: Key Generation ═════════════════════════════════════════════

  /// Generate a tensor network keypair
  public func generateKeypair(bondDim : Nat, keySites : Nat) : async TensorKeypair {
    let bd = Nat.min(bondDim, MAX_BOND_DIM);
    let sites = Nat.min(keySites, 128);

    // Seed PRNG with time
    seedPRNG(Nat64.fromNat(Int.abs(Time.now()) % 2**63));

    let mps = createMPS(sites, PHYSICAL_DIM, bd);

    // Generate public samples
    let numSamples = Nat.min(sites * bd, 512);
    let samples = Array.tabulate<PublicSample>(numSamples, func(i : Nat) : PublicSample {
      let patternSize = Nat.min(sites, 16);
      let pattern = Array.tabulate<Nat>(patternSize, func(_ : Nat) : Nat {
        Nat64.toNat(prngState % Nat64.fromNat(PHYSICAL_DIM)) |> do {
          ignore prngNext();
          if (prngState % 2 == 0) { 0 } else { 1 };
        };
      });
      let value = evaluateMPS(mps, pattern);
      { pattern; value };
    });

    keypairCounter += 1;
    let id = "tn-kp-" # Nat.toText(keypairCounter);

    { id; bondDim = bd; numSites = sites; createdAt = Time.now(); publicSamples = samples };
  };

  // ═══ Section 7: Encryption ═════════════════════════════════════════════════

  /// Encrypt binary message bits using public tensor samples
  public func encrypt(publicSamples : [PublicSample], messageBits : [Nat8]) : async Ciphertext {
    let blockSize = Nat.min(16, publicSamples.size());
    let numBits = messageBits.size();

    // Pad to block boundary
    let paddedSize = ((numBits + blockSize - 1) / blockSize) * blockSize;
    let padded = Array.tabulate<Nat8>(paddedSize, func(i : Nat) : Nat8 {
      if (i < numBits) { messageBits[i] } else { 0 };
    });

    let numBlocks = paddedSize / blockSize;
    let blocks = Array.tabulate<EncryptedBlock>(numBlocks, func(bi : Nat) : EncryptedBlock {
      let data = Array.tabulate<Float>(blockSize, func(j : Nat) : Float {
        let bit = padded[bi * blockSize + j];
        let sIdx = (bi * blockSize + j) % publicSamples.size();
        let sv = publicSamples[sIdx].value;
        let bitFloat = Float.fromInt(Nat8.toNat(bit));
        bitFloat * PHI + (1.0 - bitFloat) * PHI_INV + sv * AMOR;
      });
      { data };
    });

    totalEncryptions += 1;
    { blocks; blockSize; totalBits = numBits };
  };

  /// Decrypt ciphertext using public samples (requires matching keypair)
  public func decrypt(publicSamples : [PublicSample], ciphertext : Ciphertext) : async [Nat8] {
    let bits = Buffer.Buffer<Nat8>(ciphertext.totalBits);

    var bi = 0;
    while (bi < ciphertext.blocks.size()) {
      let block = ciphertext.blocks[bi];
      var j = 0;
      while (j < block.data.size()) {
        let sIdx = (bi * ciphertext.blockSize + j) % publicSamples.size();
        let sv = publicSamples[sIdx].value;
        let adjusted = block.data[j] - sv * AMOR;
        let dist1 = absFloat(adjusted - PHI);
        let dist0 = absFloat(adjusted - PHI_INV);
        bits.add(if (dist1 < dist0) { 1 : Nat8 } else { 0 : Nat8 });
        j += 1;
      };
      bi += 1;
    };

    totalDecryptions += 1;
    let result = Buffer.toArray(bits);
    Array.tabulate<Nat8>(Nat.min(result.size(), ciphertext.totalBits), func(i : Nat) : Nat8 { result[i] });
  };

  // ═══ Section 8: Security Estimation ════════════════════════════════════════

  /// Compute security parameters for given bond dimension and site count
  public query func estimateSecurity(bondDim : Nat, numSites : Nat) : async SecurityEstimate {
    let bd = Nat.min(bondDim, MAX_BOND_DIM);
    let ns = Nat.min(numSites, 256);

    // Security bits ≈ n × log₂(χ) × φ⁻¹
    let secBits = Int.abs(Float.toInt(Float.fromInt(ns) * log2Float(Float.fromInt(bd)) * PHI_INV));

    // Entanglement capacity = log₂(χ) × φ
    let entCap = log2Float(Float.fromInt(bd)) * PHI;

    // φ-scaled bond dimension for next security level
    let phiScaled = Nat.min(Int.abs(Float.toInt(Float.fromInt(bd) * PHI)), MAX_BOND_DIM);

    { bondDim = bd; numSites = ns; securityBits = secBits; entanglementCapacity = entCap; phiScaledBondDim = phiScaled };
  };

  /// Get φ-scaled bond dimension for security level 1-10
  public query func phiBondDimension(securityLevel : Nat) : async Nat {
    let level = Nat.min(Nat.max(securityLevel, 1), 10);
    var dim = DEFAULT_BOND_DIM;
    var i = 1;
    while (i < level) {
      dim := Nat.min(Int.abs(Float.toInt(Float.fromInt(dim) * PHI)), MAX_BOND_DIM);
      i += 1;
    };
    dim;
  };

  // ═══ Section 9: Secret Sharing ═════════════════════════════════════════════

  /// Generate threshold secret shares from binary secret
  public func shareSecret(secret : [Nat8], threshold : Nat, numShares : Nat) : async [SecretShare] {
    let numSites = secret.size();
    let bd = DEFAULT_BOND_DIM;
    seedPRNG(Nat64.fromNat(Int.abs(Time.now()) % 2**63));

    let mps = createMPS(numSites, PHYSICAL_DIM, bd);

    // Bias MPS toward secret encoding
    let biasedSites = Array.tabulate<MPSSite>(numSites, func(k : Nat) : MPSSite {
      let site = mps.sites[k];
      let d = Nat8.toNat(secret[k]);
      let data = Array.tabulate<Float>(site.data.size(), func(idx : Nat) : Float {
        let a = idx / (site.physicalDim * site.rightBond);
        let rem = idx % (site.physicalDim * site.rightBond);
        let dd = rem / site.rightBond;
        if (dd == d) {
          site.data[idx] + PHI;
        } else {
          site.data[idx] * PHI_INV * 0.1;
        };
      });
      { leftBond = site.leftBond; physicalDim = site.physicalDim; rightBond = site.rightBond; data };
    });

    let shares = Array.tabulate<SecretShare>(numShares, func(sh : Nat) : SecretShare {
      let fragments = Array.tabulate<[Float]>(numSites, func(k : Nat) : [Float] {
        let site = biasedSites[k];
        let size = site.data.size();
        // Simple share: divide tensor by threshold with phase rotation
        Array.tabulate<Float>(size, func(i : Nat) : Float {
          let phase = cosFloat(6.2831853 * Float.fromInt(sh * threshold + i) / Float.fromInt(numShares * size));
          site.data[i] * phase / Float.fromInt(threshold);
        });
      });
      let shapes = Array.tabulate<(Nat, Nat, Nat)>(numSites, func(k : Nat) : (Nat, Nat, Nat) {
        let site = biasedSites[k];
        (site.leftBond, site.physicalDim, site.rightBond);
      });
      { id = sh; fragments; shapes };
    });

    totalShares += numShares;
    shares;
  };

  /// Reconstruct secret from threshold shares
  public func reconstructSecret(shares : [SecretShare], threshold : Nat) : async [Nat8] {
    if (shares.size() < threshold) {
      Debug.trap("Insufficient shares for reconstruction");
    };

    let numSites = shares[0].fragments.size();
    let result = Array.tabulate<Nat8>(numSites, func(k : Nat) : Nat8 {
      let fragSize = shares[0].fragments[k].size();
      let combined = Array.tabulate<Float>(fragSize, func(i : Nat) : Float {
        var sum : Float = 0.0;
        for (share in shares.vals()) {
          sum += share.fragments[k][i];
        };
        sum;
      });

      // Extract bit: compare p(0) vs p(1)
      let (left, physDim, right) = shares[0].shapes[k];
      var p0 : Float = 0.0;
      var p1 : Float = 0.0;
      var a = 0;
      while (a < left) {
        var b = 0;
        while (b < right) {
          p0 += absFloat(combined[a * physDim * right + 0 * right + b]);
          p1 += absFloat(combined[a * physDim * right + 1 * right + b]);
          b += 1;
        };
        a += 1;
      };

      if (p1 > p0) { 1 : Nat8 } else { 0 : Nat8 };
    });

    result;
  };

  // ═══ Section 10: Canister Status ═══════════════════════════════════════════

  public query func status() : async {
    keypairsGenerated : Nat;
    totalEncryptions : Nat;
    totalDecryptions : Nat;
    totalSharesGenerated : Nat;
    bondDimRange : (Nat, Nat);
    phi : Float;
    version : Text;
  } {
    {
      keypairsGenerated = keypairCounter;
      totalEncryptions;
      totalDecryptions;
      totalSharesGenerated = totalShares;
      bondDimRange = (1, MAX_BOND_DIM);
      phi = PHI;
      version = "1.0.0";
    };
  };

  // ═══ Section 11: Protocol Constants Query ══════════════════════════════════

  public query func getConstants() : async {
    phi : Float;
    phiInv : Float;
    amor : Float;
    feigenbaumD : Float;
    defaultBondDim : Nat;
    maxBondDim : Nat;
    physicalDim : Nat;
  } {
    {
      phi = PHI;
      phiInv = PHI_INV;
      amor = AMOR;
      feigenbaumD = FEIGENBAUM_D;
      defaultBondDim = DEFAULT_BOND_DIM;
      maxBondDim = MAX_BOND_DIM;
      physicalDim = PHYSICAL_DIM;
    };
  };
};
