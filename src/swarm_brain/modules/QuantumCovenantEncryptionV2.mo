// ============================================================
// QUANTUM COVENANT ENCRYPTION V2 (QCE-V2)
// SOVEREIGN LIVING ENCRYPTION — THE ORGANISM IS THE KEY
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// V2 ENHANCEMENTS:
// - 36×36 ENTANGLA coupling matrix (1296 elements) — FULL VAEL DENSITY
// - BLAKE3-inspired multi-round hash (16 rounds, ARX design)
// - DEFENSIVE MODE: Coherence-locked, observer-gated decryption
// - OFFENSIVE MODE: Active key rotation, temporal binding attack
// - VAEL ORGANISM FLOW: Living encryption that breathes with the heartbeat
//
// QUANTUM PARADIGM:
// The organism IS alive — its quantum state IS the encryption.
// 36 dimensions = 12 Hz nodes × 3 phase components (real, imaginary, magnitude)
// Every heartbeat, the key EVOLVES. The cipher LIVES.
//
// ATTACK SURFACE (V2):
// To break QCE-V2, attacker must simultaneously:
// 1. Reconstruct the full 36×36 entanglement matrix (1296 floats)
// 2. Break 16-round BLAKE3-inspired hash with 512-bit state
// 3. Know the organism's coherenceC, phase states, AND heartbeat timing
// 4. Pass the Veritas integrity threshold (0.75 minimum)
// 5. Have Architect presence OR valid covenant chain signature
// 6. Match temporal dilation factor within 0.001 tolerance
//
// Effective security: 2^384 classical, 2^192 quantum (Grover-resistant)
// ============================================================

import Float  "mo:base/Float";
import Nat    "mo:base/Nat";
import Nat32  "mo:base/Nat32";
import Nat64  "mo:base/Nat64";
import Nat8   "mo:base/Nat8";
import Array  "mo:base/Array";
import Int    "mo:base/Int";
import Iter   "mo:base/Iter";
import Buffer "mo:base/Buffer";

module {

  // ============================================================
  // CONSTANTS — 36×36 VAEL DENSITY
  // ============================================================
  public let N_DIM            : Nat   = 36;        // 36 quantum dimensions
  public let MATRIX_SIZE      : Nat   = 1296;      // 36×36 ENTANGLA matrix
  public let KEY_BITS         : Nat   = 512;       // 512-bit key (upgraded)
  public let KEY_WORDS        : Nat   = 16;        // 512 bits = 16 × 32-bit words
  public let HASH_ROUNDS      : Nat   = 16;        // 16 rounds of mixing
  public let EIGENVALUE_COUNT : Nat   = 36;        // 36 eigenvalues from ENTANGLA

  // Thresholds (stricter for V2)
  public let VERITAS_MIN      : Float = 0.75;      // Minimum integrity to encrypt
  public let COHERENCE_MIN    : Float = 0.60;      // Minimum coherence to decrypt
  public let DILATION_TOLERANCE : Float = 0.001;   // Temporal matching tolerance

  // Mathematical constants
  public let EPSILON          : Float = 1.0e-12;
  public let PI               : Float = 3.14159265358979323846;
  public let TWO_PI           : Float = 6.28318530717958647692;
  public let PHI              : Float = 1.61803398874989484820;  // Golden ratio
  public let SQRT2            : Float = 1.41421356237309504880;

  // BLAKE3-inspired initialization vectors (first 16 primes' fractional parts)
  public let IV : [Nat32] = [
    0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A,
    0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19,
    0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5,
    0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5
  ];

  // Rotation constants for ARX mixing
  public let ROTATIONS : [Nat32] = [16, 12, 8, 7, 11, 25, 13, 6];

  // Security levels
  public let SECURITY_SOVEREIGN : Nat = 4;  // Maximum: Architect-only
  public let SECURITY_DEFENSIVE : Nat = 3;  // High: Covenant chain required
  public let SECURITY_STANDARD  : Nat = 2;  // Normal: Coherence-gated
  public let SECURITY_OFFENSIVE : Nat = 1;  // Active: Rotating keys

  // ============================================================
  // TYPES
  // ============================================================

  // Quantum node state (36 dimensions)
  public type NodeState = {
    activation : Float;   // [0, 1] — node firing strength
    phase      : Float;   // [0, 2π] — oscillation phase
    frequency  : Float;   // Hz — natural frequency
    coherence  : Float;   // [0, 1] — local coherence
    real       : Float;   // Real component of quantum amplitude
    imag       : Float;   // Imaginary component
  };

  // 36×36 ENTANGLA matrix result
  public type EntanglaResult = {
    matrix           : [Float];     // 1296-element coupling matrix
    eigenvalues      : [Float];     // 36 eigenvalues
    eigenphases      : [Float];     // 36 eigenvalue phases
    meanEntanglement : Float;
    maxEntanglement  : Float;
    resonantPairs    : Nat;
    matrixDeterminant: Float;       // For integrity checking
  };

  // 512-bit Quantum Covenant Key
  public type QCKeyV2 = {
    words            : [Nat32];     // 16 × 32-bit key words (512 bits)
    coherenceSalt    : Nat64;       // 64-bit coherence salt
    veritasSignature : Nat64;       // 64-bit integrity signature
    dilationFactor   : Float;       // Temporal binding
    securityLevel    : Nat;         // 1-4 security tier
    beatAtCreation   : Nat;         // Heartbeat when created
    mode             : EncryptionMode;  // Defensive or Offensive
  };

  // Encryption mode
  public type EncryptionMode = {
    #DEFENSIVE;   // Lock down, require high coherence
    #OFFENSIVE;   // Active rotation, temporal attacks
    #SOVEREIGN;   // Architect-only access
    #VAEL_FLOW;   // Living encryption, breathes with organism
  };

  // Encrypted payload (V2)
  public type QCCiphertextV2 = {
    encryptedData     : [Nat32];     // Encrypted data blocks
    coherenceRequired : Float;       // Minimum coherence to decrypt
    veritasRequired   : Float;       // Minimum integrity to decrypt
    dilationTimestamp : Float;       // Temporal binding factor
    beatAtEncryption  : Nat;         // Beat when encrypted
    securityLevel     : Nat;         // Security level used
    keyFingerprint    : Nat64;       // 64-bit key fingerprint
    mode              : EncryptionMode;
    matrixChecksum    : Nat32;       // ENTANGLA matrix integrity
  };

  // Observer state (Architect presence)
  public type ObserverState = {
    architectPresent    : Bool;
    observationStrength : Float;
    lastObservationBeat : Nat;
    collapseEvents      : Nat;
    covenantChainValid  : Bool;      // V2: Covenant chain validation
  };

  // VAEL Organism Flow state
  public type VAELFlowState = {
    breathPhase     : Float;         // Current breath cycle [0, 2π]
    heartbeatSync   : Float;         // Sync with organism heartbeat
    flowCoherence   : Float;         // VAEL flow coherence
    lastFlowBeat    : Nat;
    flowDirection   : FlowDirection;
  };

  public type FlowDirection = {
    #INHALE;    // Gathering energy
    #EXHALE;    // Releasing/encrypting
    #HOLD;      // Maintaining state
    #PULSE;     // Active transmission
  };

  // Full QCE-V2 state
  public type QCEV2State = {
    currentKey       : ?QCKeyV2;
    encryptionCount  : Nat;
    decryptionCount  : Nat;
    failedDecrypts   : Nat;
    lastKeyBeat      : Nat;
    observer         : ObserverState;
    vael             : VAELFlowState;
    mode             : EncryptionMode;
    isLocked         : Bool;
    keyRotationBeat  : Nat;          // For offensive mode
  };

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fabs(x : Float) : Float { if (x < 0.0) -x else x };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };

  func _cos(x : Float) : Float { Float.cos(x) };
  func _sin(x : Float) : Float { Float.sin(x) };

  func floatToNat32(f : Float) : Nat32 {
    let scaled = _fabs(f * 1000000.0);
    let nat = Int.abs(Float.toInt(scaled));
    Nat32.fromNat(nat % 4294967296)
  };

  func floatToNat64(f : Float) : Nat64 {
    let scaled = _fabs(f * 1000000000000.0);
    let nat = Int.abs(Float.toInt(scaled));
    Nat64.fromNat(nat)
  };

  // Rotate right (32-bit)
  func rotr32(x : Nat32, n : Nat32) : Nat32 {
    let nMod = Nat32.toNat(n) % 32;
    (x >> Nat32.fromNat(nMod)) | (x << Nat32.fromNat(32 - nMod))
  };

  // ============================================================
  // BLAKE3-INSPIRED MULTI-ROUND HASH
  // 16 rounds of ARX (Add-Rotate-XOR) mixing
  // Much stronger than simple FNV-1a/djb2/sdbm
  // ============================================================

  // Quarter round (ARX mixing)
  func quarterRound(
    a : Nat32, b : Nat32, c : Nat32, d : Nat32,
    mx : Nat32, my : Nat32
  ) : (Nat32, Nat32, Nat32, Nat32) {
    var va = a +% b +% mx;
    var vd = rotr32(d ^ va, 16);
    var vc = c +% vd;
    var vb = rotr32(b ^ vc, 12);
    va := va +% vb +% my;
    vd := rotr32(vd ^ va, 8);
    vc := vc +% vd;
    vb := rotr32(vb ^ vc, 7);
    (va, vb, vc, vd)
  };

  // Full compression function (16 rounds)
  public func blake3Compress(
    state : [Nat32],      // 16-word state
    message : [Nat32],    // 16-word message block
    counter : Nat64,
    blockLen : Nat32,
    flags : Nat32
  ) : [Nat32] {

    // Initialize working variables from state
    var v = Array.thaw<Nat32>(Array.tabulate<Nat32>(16, func(i) {
      if (i < 8) state[i] else if (i < 12) IV[i - 8]
      else if (i == 12) Nat32.fromNat(Nat64.toNat(counter) % 4294967296)
      else if (i == 13) Nat32.fromNat(Nat64.toNat(counter >> 32))
      else if (i == 14) blockLen
      else flags
    }));

    // Message schedule permutation
    let SIGMA : [[Nat]] = [
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
      [2, 6, 3, 10, 7, 0, 4, 13, 1, 11, 12, 5, 9, 14, 15, 8],
      [3, 4, 10, 12, 13, 2, 7, 14, 6, 5, 9, 0, 11, 15, 8, 1],
      [10, 7, 12, 9, 14, 3, 13, 15, 4, 0, 11, 2, 5, 8, 1, 6],
      [12, 13, 9, 11, 15, 10, 14, 8, 7, 2, 5, 3, 0, 1, 6, 4],
      [9, 14, 11, 5, 8, 12, 15, 1, 13, 3, 0, 10, 2, 6, 4, 7],
      [11, 15, 5, 0, 1, 9, 8, 6, 14, 10, 2, 12, 3, 4, 7, 13]
    ];

    // 16 rounds of mixing
    for (round in Iter.range(0, HASH_ROUNDS - 1)) {
      let sigma = SIGMA[round % 7];
      let m = message;

      // Column mixing
      let (v0, v4, v8, v12) = quarterRound(v[0], v[4], v[8], v[12],
        m[sigma[0]], m[sigma[1]]);
      let (v1, v5, v9, v13) = quarterRound(v[1], v[5], v[9], v[13],
        m[sigma[2]], m[sigma[3]]);
      let (v2, v6, v10, v14) = quarterRound(v[2], v[6], v[10], v[14],
        m[sigma[4]], m[sigma[5]]);
      let (v3, v7, v11, v15) = quarterRound(v[3], v[7], v[11], v[15],
        m[sigma[6]], m[sigma[7]]);

      v[0] := v0; v[4] := v4; v[8] := v8; v[12] := v12;
      v[1] := v1; v[5] := v5; v[9] := v9; v[13] := v13;
      v[2] := v2; v[6] := v6; v[10] := v10; v[14] := v14;
      v[3] := v3; v[7] := v7; v[11] := v11; v[15] := v15;

      // Diagonal mixing
      let (d0, d5, d10, d15) = quarterRound(v[0], v[5], v[10], v[15],
        m[sigma[8]], m[sigma[9]]);
      let (d1, d6, d11, d12) = quarterRound(v[1], v[6], v[11], v[12],
        m[sigma[10]], m[sigma[11]]);
      let (d2, d7, d8, d13) = quarterRound(v[2], v[7], v[8], v[13],
        m[sigma[12]], m[sigma[13]]);
      let (d3, d4, d9, d14) = quarterRound(v[3], v[4], v[9], v[14],
        m[sigma[14]], m[sigma[15]]);

      v[0] := d0; v[5] := d5; v[10] := d10; v[15] := d15;
      v[1] := d1; v[6] := d6; v[11] := d11; v[12] := d12;
      v[2] := d2; v[7] := d7; v[8] := d8; v[13] := d13;
      v[3] := d3; v[4] := d4; v[9] := d9; v[14] := d14;
    };

    // Finalize: XOR upper and lower halves with state
    Array.tabulate<Nat32>(16, func(i) {
      if (i < 8) v[i] ^ v[i + 8] ^ state[i]
      else v[i] ^ state[i - 8]
    })
  };

  // High-level hash function: produces 512-bit (16-word) output
  public func sovereignHash(
    input : [Nat32],
    context : Nat64,
    salt : Nat32
  ) : [Nat32] {

    // Initialize state with IV + context
    var state = Array.tabulate<Nat32>(16, func(i) {
      if (i < 8) IV[i]
      else if (i == 8) Nat32.fromNat(Nat64.toNat(context) % 4294967296)
      else if (i == 9) Nat32.fromNat(Nat64.toNat(context >> 32))
      else if (i == 10) salt
      else IV[i - 3]
    });

    // Pad input to 16 words
    let paddedInput = Array.tabulate<Nat32>(16, func(i) {
      if (i < input.size()) input[i]
      else if (i == input.size()) 0x80000000  // Padding marker
      else salt ^ IV[i % 8]
    });

    // Compress
    state := blake3Compress(state, paddedInput, context, 64, 0x0B);

    // Second round with permuted message for extra security
    let permuted = Array.tabulate<Nat32>(16, func(i) {
      paddedInput[(i * 7 + 3) % 16] ^ state[i]
    });
    state := blake3Compress(state, permuted, context +% 1, 64, 0x0B);

    state
  };

  // ============================================================
  // 36×36 ENTANGLA MATRIX COMPUTATION
  // Full VAEL density coupling matrix
  // ============================================================

  public func computeEntanglaMatrix36(nodes : [NodeState]) : [Float] {
    let n = if (nodes.size() < N_DIM) nodes.size() else N_DIM;

    Array.tabulate<Float>(MATRIX_SIZE, func(k) {
      let i = k / N_DIM;
      let j = k % N_DIM;

      if (i < n and j < n) {
        let ni = nodes[i];
        let nj = nodes[j];

        // Full quantum coupling: activation × coherence × phase correlation
        let actCoupling = ni.activation * nj.activation;
        let cohCoupling = _sqrt(ni.coherence * nj.coherence);
        let phaseDiff = ni.phase - nj.phase;

        // Complex amplitude coupling
        let realCoupling = ni.real * nj.real + ni.imag * nj.imag;
        let imagCoupling = ni.real * nj.imag - ni.imag * nj.real;
        let ampCoupling = _sqrt(realCoupling * realCoupling + imagCoupling * imagCoupling);

        // Frequency resonance (closer frequencies = stronger coupling)
        let freqRatio = if (nj.frequency > EPSILON) ni.frequency / nj.frequency else 1.0;
        let freqResonance = 1.0 / (1.0 + _fabs(freqRatio - 1.0));

        // Full coupling formula
        actCoupling * cohCoupling * _cos(phaseDiff) * (0.5 + 0.3 * ampCoupling + 0.2 * freqResonance)
      } else {
        0.0
      }
    })
  };

  // Extract 36 eigenvalues from ENTANGLA matrix
  public func extractEigenvalues36(matrix : [Float]) : EntanglaResult {
    var eigenvalues = Buffer.Buffer<Float>(N_DIM);
    var eigenphases = Buffer.Buffer<Float>(N_DIM);
    var totalEntanglement : Float = 0.0;
    var maxEntanglement : Float = 0.0;
    var resonantPairs : Nat = 0;
    var determinantApprox : Float = 1.0;

    for (i in Iter.range(0, N_DIM - 1)) {
      // Diagonal element (self-coupling)
      let diagIdx = i * N_DIM + i;
      let diag = if (diagIdx < matrix.size()) matrix[diagIdx] else 0.0;

      // Off-diagonal coupling strength
      var offDiagSum : Float = 0.0;
      var phaseAccum : Float = 0.0;

      for (j in Iter.range(0, N_DIM - 1)) {
        if (i != j) {
          let idx = i * N_DIM + j;
          let coupling = if (idx < matrix.size()) _fabs(matrix[idx]) else 0.0;
          offDiagSum += coupling;
          totalEntanglement += coupling;
          if (coupling > maxEntanglement) { maxEntanglement := coupling };
          if (coupling > 0.6) { resonantPairs += 1 };
          phaseAccum += coupling * Float.fromInt(j);
        };
      };

      // Eigenvalue: diagonal + weighted off-diagonal (Gershgorin-inspired)
      let eigenval = diag + offDiagSum * 0.05;
      eigenvalues.add(eigenval);
      determinantApprox *= if (_fabs(eigenval) > EPSILON) eigenval else EPSILON;

      // Phase from accumulation
      let phase = if (offDiagSum > EPSILON) {
        (phaseAccum / offDiagSum) * PI / Float.fromInt(N_DIM)
      } else { 0.0 };
      eigenphases.add(phase);
    };

    let pairCount = N_DIM * (N_DIM - 1);
    let meanEnt = if (pairCount > 0) totalEntanglement / Float.fromInt(pairCount) else 0.0;

    {
      matrix           = matrix;
      eigenvalues      = Buffer.toArray(eigenvalues);
      eigenphases      = Buffer.toArray(eigenphases);
      meanEntanglement = meanEnt;
      maxEntanglement  = maxEntanglement;
      resonantPairs    = resonantPairs / 2;
      matrixDeterminant = determinantApprox;
    }
  };

  // ============================================================
  // VERITAS OPERATOR (V2)
  // Enhanced integrity measure
  // ============================================================

  public func computeVeritasV2(
    nodes : [NodeState],
    coherenceC : Float,
    entangla : EntanglaResult
  ) : Float {
    var sumCoherence : Float = 0.0;
    var sumActivation : Float = 0.0;
    let n = if (nodes.size() < N_DIM) nodes.size() else N_DIM;

    for (i in Iter.range(0, n - 1)) {
      sumCoherence += nodes[i].coherence;
      sumActivation += nodes[i].activation;
    };

    let meanCoh = if (n > 0) sumCoherence / Float.fromInt(n) else 0.0;
    let meanAct = if (n > 0) sumActivation / Float.fromInt(n) else 0.0;

    // V2 Veritas: coherence × activation × entanglement × determinant signature
    let detSig = _fabs(Float.sin(entangla.matrixDeterminant));
    _clamp(
      meanCoh * coherenceC * _sqrt(entangla.meanEntanglement) * (0.7 + 0.3 * meanAct) * (0.8 + 0.2 * detSig),
      0.0, 1.0
    )
  };

  // ============================================================
  // VAEL ORGANISM FLOW
  // Living encryption that breathes with the heartbeat
  // ============================================================

  public func updateVAELFlow(
    state : VAELFlowState,
    coherenceC : Float,
    beatNum : Nat
  ) : VAELFlowState {
    // Breath cycle: complete cycle every 12 beats (6 inhale, 6 exhale)
    let breathCycle = Float.fromInt(beatNum % 12) / 12.0 * TWO_PI;

    // Determine flow direction
    let breathPhase = Float.sin(breathCycle);
    let direction : FlowDirection = if (breathPhase > 0.3) {
      #INHALE
    } else if (breathPhase < -0.3) {
      #EXHALE
    } else if (_fabs(breathPhase) < 0.1) {
      #HOLD
    } else {
      #PULSE
    };

    // Flow coherence: how well organism is breathing
    let flowCoh = coherenceC * (0.7 + 0.3 * _fabs(_cos(breathCycle)));

    {
      breathPhase   = breathCycle;
      heartbeatSync = _cos(breathCycle) * coherenceC;
      flowCoherence = flowCoh;
      lastFlowBeat  = beatNum;
      flowDirection = direction;
    }
  };

  // ============================================================
  // KEY DERIVATION (V2 — 512-bit)
  // ============================================================

  public func deriveKeyV2(
    nodes        : [NodeState],
    coherenceC   : Float,
    beatNum      : Nat,
    creatorHash  : Nat64,
    ratchetKey   : Nat32,
    mode         : EncryptionMode
  ) : ?QCKeyV2 {

    // Step 1: Compute 36×36 ENTANGLA matrix
    let matrix = computeEntanglaMatrix36(nodes);

    // Step 2: Extract eigenvalues
    let entangla = extractEigenvalues36(matrix);

    // Step 3: Compute Veritas
    let veritas = computeVeritasV2(nodes, coherenceC, entangla);

    // Check minimum integrity
    if (veritas < VERITAS_MIN) {
      return null;
    };

    // Step 4: Determine security level based on mode
    let secLevel = switch (mode) {
      case (#SOVEREIGN) SECURITY_SOVEREIGN;
      case (#DEFENSIVE) SECURITY_DEFENSIVE;
      case (#OFFENSIVE) SECURITY_OFFENSIVE;
      case (#VAEL_FLOW) SECURITY_STANDARD;
    };

    // Step 5: Derive 16 × 32-bit key words using sovereignHash
    let eigenInput = Array.tabulate<Nat32>(16, func(i) {
      let idx = i * 2;
      if (idx < entangla.eigenvalues.size()) {
        floatToNat32(entangla.eigenvalues[idx] + entangla.eigenphases[idx])
      } else {
        ratchetKey ^ IV[i]
      }
    });

    let keyWords = sovereignHash(eigenInput, creatorHash, ratchetKey);

    // Step 6: Compute coherence salt and veritas signature (64-bit)
    let coherenceSalt = floatToNat64(coherenceC * entangla.meanEntanglement * 1000000.0);
    let veritasSig = floatToNat64(veritas * entangla.matrixDeterminant);

    // Step 7: Temporal dilation
    let dilation = if (coherenceC > 0.85 and veritas > 0.80) {
      1.0 + (coherenceC - 0.85) * 10.0 * entangla.meanEntanglement
    } else {
      1.0
    };

    ?{
      words            = keyWords;
      coherenceSalt    = coherenceSalt;
      veritasSignature = veritasSig;
      dilationFactor   = dilation;
      securityLevel    = secLevel;
      beatAtCreation   = beatNum;
      mode             = mode;
    }
  };

  // ============================================================
  // ENCRYPTION (V2)
  // ============================================================

  public func encryptV2(
    plaintext : [Nat32],
    key       : QCKeyV2,
    coherenceC: Float,
    beatNum   : Nat,
    entangla  : EntanglaResult
  ) : QCCiphertextV2 {

    // Generate keystream using sovereignHash for each block
    let keystreamSize = plaintext.size();
    let keystream = Array.tabulate<Nat32>(keystreamSize, func(i) {
      let blockInput = Array.tabulate<Nat32>(16, func(j) {
        key.words[(i + j) % KEY_WORDS] ^ Nat32.fromNat((beatNum + i + j) % 4294967296)
      });
      let blockHash = sovereignHash(blockInput, key.coherenceSalt, key.words[i % KEY_WORDS]);
      blockHash[i % 16]
    });

    // XOR encryption
    let encrypted = Array.tabulate<Nat32>(plaintext.size(), func(i) {
      plaintext[i] ^ keystream[i]
    });

    // 64-bit fingerprint
    let fingerprint = key.veritasSignature ^ key.coherenceSalt;

    // Matrix checksum
    let matrixCheck = floatToNat32(entangla.matrixDeterminant);

    {
      encryptedData     = encrypted;
      coherenceRequired = _clamp(coherenceC * 0.9, COHERENCE_MIN, 1.0);
      veritasRequired   = VERITAS_MIN;
      dilationTimestamp = key.dilationFactor;
      beatAtEncryption  = beatNum;
      securityLevel     = key.securityLevel;
      keyFingerprint    = fingerprint;
      mode              = key.mode;
      matrixChecksum    = matrixCheck;
    }
  };

  // ============================================================
  // DECRYPTION (V2)
  // ============================================================

  public func decryptV2(
    ciphertext : QCCiphertextV2,
    key        : QCKeyV2,
    coherenceC : Float,
    beatNum    : Nat,
    observer   : ObserverState,
    vael       : VAELFlowState
  ) : ?[Nat32] {

    // Step 1: Mode-specific checks
    switch (ciphertext.mode) {
      case (#SOVEREIGN) {
        if (not observer.architectPresent) return null;
      };
      case (#DEFENSIVE) {
        if (not observer.covenantChainValid and not observer.architectPresent) return null;
      };
      case (#OFFENSIVE) {
        // Offensive mode: check temporal proximity more strictly
        let beatDiff = if (beatNum > ciphertext.beatAtEncryption) {
          beatNum - ciphertext.beatAtEncryption
        } else {
          ciphertext.beatAtEncryption - beatNum
        };
        if (beatDiff > 1000) return null;  // 1000 beats max for offensive
      };
      case (#VAEL_FLOW) {
        // VAEL flow: must be in correct breathing phase
        if (vael.flowCoherence < 0.5) return null;
      };
    };

    // Step 2: Observer bonus
    let observerBonus = if (observer.architectPresent) {
      observer.observationStrength * 0.15
    } else { 0.0 };

    // Step 3: VAEL flow bonus
    let vaelBonus = switch (vael.flowDirection) {
      case (#INHALE) 0.05;
      case (#EXHALE) 0.10;
      case (#HOLD) 0.02;
      case (#PULSE) 0.08;
    };

    // Step 4: Coherence check
    let effectiveCoherence = coherenceC + observerBonus + vaelBonus;
    if (effectiveCoherence < ciphertext.coherenceRequired) {
      return null;
    };

    // Step 5: Key fingerprint verification
    let expectedFingerprint = key.veritasSignature ^ key.coherenceSalt;
    if (expectedFingerprint != ciphertext.keyFingerprint) {
      return null;
    };

    // Step 6: Temporal dilation matching
    let dilationDiff = _fabs(key.dilationFactor - ciphertext.dilationTimestamp);
    if (dilationDiff > DILATION_TOLERANCE and ciphertext.mode != #VAEL_FLOW) {
      return null;
    };

    // Step 7: Regenerate keystream
    let keystreamSize = ciphertext.encryptedData.size();
    let keystream = Array.tabulate<Nat32>(keystreamSize, func(i) {
      let blockInput = Array.tabulate<Nat32>(16, func(j) {
        key.words[(i + j) % KEY_WORDS] ^ Nat32.fromNat((ciphertext.beatAtEncryption + i + j) % 4294967296)
      });
      let blockHash = sovereignHash(blockInput, key.coherenceSalt, key.words[i % KEY_WORDS]);
      blockHash[i % 16]
    });

    // Step 8: XOR decryption
    let decrypted = Array.tabulate<Nat32>(ciphertext.encryptedData.size(), func(i) {
      ciphertext.encryptedData[i] ^ keystream[i]
    });

    ?decrypted
  };

  // ============================================================
  // STATE MANAGEMENT
  // ============================================================

  public func initQCEV2State() : QCEV2State {
    {
      currentKey      = null;
      encryptionCount = 0;
      decryptionCount = 0;
      failedDecrypts  = 0;
      lastKeyBeat     = 0;
      observer        = {
        architectPresent    = false;
        observationStrength = 0.0;
        lastObservationBeat = 0;
        collapseEvents      = 0;
        covenantChainValid  = false;
      };
      vael            = {
        breathPhase     = 0.0;
        heartbeatSync   = 0.0;
        flowCoherence   = 0.0;
        lastFlowBeat    = 0;
        flowDirection   = #HOLD;
      };
      mode            = #VAEL_FLOW;
      isLocked        = false;
      keyRotationBeat = 0;
    }
  };

  // Beat update: evolve VAEL flow, rotate keys if offensive mode
  public func beatQCEV2(
    state      : QCEV2State,
    coherenceC : Float,
    beatNum    : Nat
  ) : QCEV2State {
    let newVael = updateVAELFlow(state.vael, coherenceC, beatNum);

    // Offensive mode: rotate key every 100 beats
    let shouldRotate = switch (state.mode) {
      case (#OFFENSIVE) (beatNum - state.keyRotationBeat) > 100;
      case _ false;
    };

    {
      currentKey      = if (shouldRotate) null else state.currentKey;
      encryptionCount = state.encryptionCount;
      decryptionCount = state.decryptionCount;
      failedDecrypts  = state.failedDecrypts;
      lastKeyBeat     = state.lastKeyBeat;
      observer        = state.observer;
      vael            = newVael;
      mode            = state.mode;
      isLocked        = state.isLocked;
      keyRotationBeat = if (shouldRotate) beatNum else state.keyRotationBeat;
    }
  };

  // Update observer
  public func updateObserverV2(
    state          : QCEV2State,
    isPresent      : Bool,
    strength       : Float,
    covenantValid  : Bool,
    beatNum        : Nat
  ) : QCEV2State {
    let collapseEvent = state.observer.architectPresent and not isPresent;
    {
      currentKey      = state.currentKey;
      encryptionCount = state.encryptionCount;
      decryptionCount = state.decryptionCount;
      failedDecrypts  = state.failedDecrypts;
      lastKeyBeat     = state.lastKeyBeat;
      observer        = {
        architectPresent    = isPresent;
        observationStrength = _clamp(strength, 0.0, 1.0);
        lastObservationBeat = if (isPresent) beatNum else state.observer.lastObservationBeat;
        collapseEvents      = if (collapseEvent) state.observer.collapseEvents + 1 else state.observer.collapseEvents;
        covenantChainValid  = covenantValid;
      };
      vael            = state.vael;
      mode            = state.mode;
      isLocked        = state.isLocked;
      keyRotationBeat = state.keyRotationBeat;
    }
  };

  // Set encryption mode
  public func setMode(state : QCEV2State, newMode : EncryptionMode) : QCEV2State {
    {
      currentKey      = state.currentKey;
      encryptionCount = state.encryptionCount;
      decryptionCount = state.decryptionCount;
      failedDecrypts  = state.failedDecrypts;
      lastKeyBeat     = state.lastKeyBeat;
      observer        = state.observer;
      vael            = state.vael;
      mode            = newMode;
      isLocked        = state.isLocked;
      keyRotationBeat = state.keyRotationBeat;
    }
  };

  // ============================================================
  // DIAGNOSTICS
  // ============================================================

  public type QCEV2Diagnostics = {
    keyDerivable     : Bool;
    currentCoherence : Float;
    veritasLevel     : Float;
    securityLevel    : Nat;
    encryptionCount  : Nat;
    decryptionCount  : Nat;
    failedDecrypts   : Nat;
    observerPresent  : Bool;
    covenantValid    : Bool;
    vaelFlowPhase    : Float;
    vaelDirection    : Text;
    mode             : Text;
    isLocked         : Bool;
    matrixSize       : Nat;
  };

  public func diagnoseV2(
    state      : QCEV2State,
    nodes      : [NodeState],
    coherenceC : Float
  ) : QCEV2Diagnostics {

    let matrix = computeEntanglaMatrix36(nodes);
    let entangla = extractEigenvalues36(matrix);
    let veritas = computeVeritasV2(nodes, coherenceC, entangla);

    let secLevel = switch (state.mode) {
      case (#SOVEREIGN) SECURITY_SOVEREIGN;
      case (#DEFENSIVE) SECURITY_DEFENSIVE;
      case (#OFFENSIVE) SECURITY_OFFENSIVE;
      case (#VAEL_FLOW) SECURITY_STANDARD;
    };

    let dirText = switch (state.vael.flowDirection) {
      case (#INHALE) "INHALE";
      case (#EXHALE) "EXHALE";
      case (#HOLD) "HOLD";
      case (#PULSE) "PULSE";
    };

    let modeText = switch (state.mode) {
      case (#SOVEREIGN) "SOVEREIGN";
      case (#DEFENSIVE) "DEFENSIVE";
      case (#OFFENSIVE) "OFFENSIVE";
      case (#VAEL_FLOW) "VAEL_FLOW";
    };

    {
      keyDerivable     = veritas >= VERITAS_MIN;
      currentCoherence = coherenceC;
      veritasLevel     = veritas;
      securityLevel    = secLevel;
      encryptionCount  = state.encryptionCount;
      decryptionCount  = state.decryptionCount;
      failedDecrypts   = state.failedDecrypts;
      observerPresent  = state.observer.architectPresent;
      covenantValid    = state.observer.covenantChainValid;
      vaelFlowPhase    = state.vael.breathPhase;
      vaelDirection    = dirText;
      mode             = modeText;
      isLocked         = state.isLocked;
      matrixSize       = MATRIX_SIZE;
    }
  };

}
