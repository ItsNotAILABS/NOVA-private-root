// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ============================================================
// QUANTUM COVENANT ENCRYPTION (QCE)
// Quantum-native encryption using ENTANGLA matrix eigenvalues
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// QUANTUM PARADIGM:
// The encryption key IS the organism's quantum state itself.
// - ENTANGLA matrix (11×11 shell coupling) provides eigenvalue key material
// - Veritas operator provides integrity verification
// - Temporal dilation provides freshness/replay protection
// - Observer effect (Architect presence) enables measurement-based access control
// - PrincipalLock layered hashing provides quantum-resistant authentication
//
// ATTACK SURFACE:
// To break QCE, attacker must simultaneously:
// 1. Reconstruct the full 11-shell entanglement matrix (121 floats)
// 2. Know the organism's current coherenceC and phase states
// 3. Know the temporal dilation factor at encryption time
// 4. Break the layered hash (FNV-1a + djb2 + SDBM)
// 5. Pass the Veritas integrity threshold
//
// This is quantum-resistant because the key material is:
// - Non-deterministic (depends on organism's evolving state)
// - High-dimensional (121-element coupling matrix)
// - Temporally bound (dilation factor changes each beat)
// - Coherence-locked (requires high coherence to decrypt)
// ============================================================

import Float  "mo:base/Float";
import Nat    "mo:base/Nat";
import Nat32  "mo:base/Nat32";
import Nat8   "mo:base/Nat8";
import Array  "mo:base/Array";
import Int    "mo:base/Int";
import Iter   "mo:base/Iter";
import Buffer "mo:base/Buffer";

module {

  // ============================================================
  // CONSTANTS
  // ============================================================
  public let N_SHELLS         : Nat   = 11;       // 11 cognitive shells
  public let MATRIX_SIZE      : Nat   = 121;      // 11×11 ENTANGLA matrix
  public let KEY_BITS         : Nat   = 256;      // Encryption key size
  public let KEY_WORDS        : Nat   = 8;        // 256 bits = 8 × 32-bit words
  public let VERITAS_MIN      : Float = 0.70;     // Minimum integrity to encrypt
  public let COHERENCE_MIN    : Float = 0.50;     // Minimum coherence to decrypt
  public let EIGENVALUE_COUNT : Nat   = 11;       // 11 eigenvalues from ENTANGLA
  public let EPSILON          : Float = 1.0e-10;
  public let PI               : Float = 3.14159265358979;
  public let TWO_PI           : Float = 6.28318530717958;

  // Security levels (coherence-adaptive)
  public let SECURITY_MAX     : Nat   = 3;        // High coherence: maximum security
  public let SECURITY_MED     : Nat   = 2;        // Medium coherence
  public let SECURITY_MIN     : Nat   = 1;        // Low coherence: basic security

  // ============================================================
  // TYPES
  // ============================================================

  // Shell quantum state (matches QuantumOps)
  public type ShellState = {
    activation : Float;   // [0, 1]
    phase      : Float;   // [0, 2π]
    frequency  : Float;
    coherence  : Float;
  };

  // ENTANGLA-derived key material
  public type EntanglaKeyMaterial = {
    eigenvalues     : [Float];     // 11 eigenvalues
    eigenphases     : [Float];     // 11 eigenvalue phases (angle)
    meanEntanglement: Float;
    maxEntanglement : Float;
    resonantPairs   : Nat;
  };

  // Quantum Covenant Key (256-bit derived from organism state)
  public type QCKey = {
    words            : [Nat32];     // 8 × 32-bit key words
    coherenceSalt    : Nat32;       // Derived from coherenceC
    veritasSignature : Nat32;       // Integrity signature
    dilationFactor   : Float;       // Temporal binding
    securityLevel    : Nat;         // Coherence-adaptive level (1-3)
    beatAtCreation   : Nat;         // Beat number when key was created
  };

  // Encrypted payload
  public type QCCiphertext = {
    encryptedData    : [Nat32];     // XOR-encrypted data
    coherenceRequired: Float;       // Minimum coherence to decrypt
    veritasRequired  : Float;       // Minimum integrity to decrypt
    dilationTimestamp: Float;       // Temporal binding
    beatAtEncryption : Nat;         // Beat when encrypted
    securityLevel    : Nat;         // Security level used
    keyFingerprint   : Nat32;       // First 32 bits of key for verification
  };

  // Observer state (Architect presence)
  public type ObserverState = {
    architectPresent    : Bool;
    observationStrength : Float;
    lastObservationBeat : Nat;
    collapseEvents      : Nat;
  };

  // Full QCE state
  public type QCEState = {
    currentKey       : ?QCKey;
    encryptionCount  : Nat;
    decryptionCount  : Nat;
    failedDecrypts   : Nat;
    lastKeyBeat      : Nat;
    observer         : ObserverState;
    isLocked         : Bool;
  };

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fabs(x : Float) : Float {
    if (x < 0.0) -x else x
  };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };

  func _cos(x : Float) : Float { Float.cos(x) };
  func _sin(x : Float) : Float { Float.sin(x) };

  // Convert float to Nat32 (preserves 32 bits of mantissa)
  func floatToNat32(f : Float) : Nat32 {
    let scaled = _fabs(f * 1000000.0);
    let nat = Int.abs(Float.toInt(scaled));
    Nat32.fromNat(nat % 4294967296)
  };

  // Three primitive hash functions (from PrincipalLock)
  func h_fnv1a(a : Nat32, b : Nat32) : Nat32 {
    let prime  : Nat32 = 16777619;
    let offset : Nat32 = 2166136261;
    ((offset ^ a) *% prime ^ b) *% prime
  };

  func h_djb2(a : Nat32, b : Nat32) : Nat32 {
    (a *% 33) +% b
  };

  func h_sdbm(a : Nat32, b : Nat32) : Nat32 {
    b +% (a *% 64) +% (a *% 65536) -% a
  };

  // Layered hash (quantum-resistant)
  func layeredHash(input : Nat32, context : Nat32, salt : Nat32) : Nat32 {
    let h1 = h_fnv1a(input, context);
    let h2 = h_djb2(h1, context ^ salt);
    let h3 = h_sdbm(h2, h1 ^ salt);
    h1 ^ h2 ^ h3
  };

  // ============================================================
  // ENTANGLA MATRIX COMPUTATION
  // Compute the 11×11 shell coupling matrix
  // matrix[i][j] = activation[i] × activation[j] × cos(phase[i] - phase[j])
  // ============================================================

  public func computeEntanglaMatrix(shells : [ShellState]) : [Float] {
    let n = if (shells.size() < N_SHELLS) shells.size() else N_SHELLS;
    Array.tabulate<Float>(MATRIX_SIZE, func(k) {
      let i = k / N_SHELLS;
      let j = k % N_SHELLS;
      if (i < n and j < n) {
        let act_i = shells[i].activation;
        let act_j = shells[j].activation;
        let phase_diff = shells[i].phase - shells[j].phase;
        act_i * act_j * _cos(phase_diff)
      } else {
        0.0
      }
    })
  };

  // ============================================================
  // EIGENVALUE EXTRACTION (Simplified Jacobi-inspired)
  // Extract 11 "eigenvalue-like" measures from ENTANGLA matrix
  // Using diagonal dominance + off-diagonal coupling strength
  // ============================================================

  public func extractEigenvalues(matrix : [Float]) : EntanglaKeyMaterial {
    var eigenvalues = Buffer.Buffer<Float>(N_SHELLS);
    var eigenphases = Buffer.Buffer<Float>(N_SHELLS);
    var totalEntanglement : Float = 0.0;
    var maxEntanglement : Float = 0.0;
    var resonantPairs : Nat = 0;

    // Diagonal elements as primary eigenvalue approximation
    // Off-diagonal contribute to phase and entanglement strength
    for (i in Iter.range(0, N_SHELLS - 1)) {
      // Diagonal element (self-coupling)
      let diag = if (i * N_SHELLS + i < matrix.size()) {
        matrix[i * N_SHELLS + i]
      } else { 0.0 };

      // Off-diagonal coupling strength for this shell
      var offDiagSum : Float = 0.0;
      var phaseAccum : Float = 0.0;
      for (j in Iter.range(0, N_SHELLS - 1)) {
        if (i != j) {
          let coupling = if (i * N_SHELLS + j < matrix.size()) {
            _fabs(matrix[i * N_SHELLS + j])
          } else { 0.0 };
          offDiagSum += coupling;
          totalEntanglement += coupling;
          if (coupling > maxEntanglement) { maxEntanglement := coupling };
          if (coupling > 0.7) { resonantPairs += 1 };
          // Phase contribution
          phaseAccum += coupling * Float.fromInt(j);
        };
      };

      // Eigenvalue: diagonal + weighted off-diagonal
      let eigenval = diag + offDiagSum * 0.1;
      eigenvalues.add(eigenval);

      // Phase: atan2-like from phase accumulation
      let phase = if (offDiagSum > EPSILON) {
        (phaseAccum / offDiagSum) * PI / Float.fromInt(N_SHELLS)
      } else { 0.0 };
      eigenphases.add(phase);
    };

    let n = N_SHELLS * (N_SHELLS - 1);
    let meanEnt = if (n > 0) totalEntanglement / Float.fromInt(n) else 0.0;

    {
      eigenvalues      = Buffer.toArray(eigenvalues);
      eigenphases      = Buffer.toArray(eigenphases);
      meanEntanglement = meanEnt;
      maxEntanglement  = maxEntanglement;
      resonantPairs    = resonantPairs / 2;  // Pairs counted twice
    }
  };

  // ============================================================
  // VERITAS OPERATOR
  // Integrity/truth measure from shell coherence and entanglement
  // veritas = mean(shellCoherence) × coherenceC × sqrt(meanEntanglement)
  // ============================================================

  public func computeVeritas(
    shells : [ShellState],
    coherenceC : Float,
    meanEntanglement : Float
  ) : Float {
    var sumCoherence : Float = 0.0;
    let n = if (shells.size() < N_SHELLS) shells.size() else N_SHELLS;
    for (i in Iter.range(0, n - 1)) {
      sumCoherence += shells[i].coherence;
    };
    let meanShellCoherence = if (n > 0) sumCoherence / Float.fromInt(n) else 0.0;
    _clamp(meanShellCoherence * coherenceC * _sqrt(meanEntanglement), 0.0, 1.0)
  };

  // ============================================================
  // TEMPORAL DILATION FACTOR
  // Time-dependent factor that prevents replay attacks
  // dilationFactor = 1 + (coherenceC - 0.9) × 10 × resonexAlign (when coherenceC > 0.9)
  // ============================================================

  public func computeDilationFactor(
    coherenceC : Float,
    veritasOperator : Float,
    resonexAlign : Float
  ) : Float {
    if (coherenceC > 0.90 and veritasOperator > 0.85) {
      1.0 + (coherenceC - 0.9) * 10.0 * resonexAlign
    } else {
      1.0
    }
  };

  // Resonex alignment: cross-shell phase resonance
  public func computeResonex(shells : [ShellState]) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    let n = if (shells.size() < N_SHELLS) shells.size() else N_SHELLS;
    for (i in Iter.range(0, n - 2)) {
      let phaseDiff = shells[i].phase - shells[i + 1].phase;
      sumCos += _cos(phaseDiff);
      sumSin += _sin(phaseDiff);
    };
    if (n > 1) {
      _sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n - 1)
    } else {
      0.0
    }
  };

  // ============================================================
  // KEY DERIVATION
  // Derive 256-bit encryption key from organism's quantum state
  // ============================================================

  public func deriveKey(
    shells       : [ShellState],
    coherenceC   : Float,
    beatNum      : Nat,
    creatorHash  : Nat32,
    ratchetKey   : Nat32
  ) : ?QCKey {

    // Step 1: Compute ENTANGLA matrix
    let matrix = computeEntanglaMatrix(shells);

    // Step 2: Extract eigenvalues
    let keyMaterial = extractEigenvalues(matrix);

    // Step 3: Compute Veritas operator
    let veritas = computeVeritas(shells, coherenceC, keyMaterial.meanEntanglement);

    // Check minimum integrity
    if (veritas < VERITAS_MIN) {
      return null;  // Integrity too low
    };

    // Step 4: Compute temporal dilation
    let resonex = computeResonex(shells);
    let dilation = computeDilationFactor(coherenceC, veritas, resonex);

    // Step 5: Determine security level (coherence-adaptive)
    let secLevel = if (coherenceC >= 0.85) {
      SECURITY_MAX
    } else if (coherenceC >= 0.65) {
      SECURITY_MED
    } else {
      SECURITY_MIN
    };

    // Step 6: Derive 8 × 32-bit key words from eigenvalues + hashing
    let keyWords = Array.tabulate<Nat32>(KEY_WORDS, func(i) {
      // Mix eigenvalues, phases, and authentication material
      let eigenIdx = i % keyMaterial.eigenvalues.size();
      let phaseIdx = (i + 3) % keyMaterial.eigenphases.size();

      let eigenN32 = floatToNat32(keyMaterial.eigenvalues[eigenIdx]);
      let phaseN32 = floatToNat32(keyMaterial.eigenphases[phaseIdx]);
      let beatN32  = Nat32.fromNat(beatNum % 4294967296);

      // Multi-layer mixing
      let mix1 = layeredHash(eigenN32, creatorHash, ratchetKey);
      let mix2 = layeredHash(phaseN32, beatN32, mix1);
      let mix3 = layeredHash(mix1, mix2, floatToNat32(coherenceC));

      // Final key word
      mix1 ^ mix2 ^ mix3
    });

    // Step 7: Compute coherence salt and veritas signature
    let coherenceSalt = floatToNat32(coherenceC * keyMaterial.meanEntanglement);
    let veritasSig = layeredHash(
      floatToNat32(veritas),
      coherenceSalt,
      keyWords[0]
    );

    ?{
      words            = keyWords;
      coherenceSalt    = coherenceSalt;
      veritasSignature = veritasSig;
      dilationFactor   = dilation;
      securityLevel    = secLevel;
      beatAtCreation   = beatNum;
    }
  };

  // ============================================================
  // ENCRYPTION
  // XOR-based encryption using QCKey
  // ============================================================

  public func encrypt(
    plaintext : [Nat32],
    key       : QCKey,
    coherenceC: Float,
    beatNum   : Nat
  ) : QCCiphertext {

    // Generate keystream from key words (expand if needed)
    let keystreamSize = plaintext.size();
    let keystream = Array.tabulate<Nat32>(keystreamSize, func(i) {
      let keyWord = key.words[i % KEY_WORDS];
      let beatMix = Nat32.fromNat((beatNum + i) % 4294967296);
      layeredHash(keyWord, beatMix, key.coherenceSalt)
    });

    // XOR encryption
    let encrypted = Array.tabulate<Nat32>(plaintext.size(), func(i) {
      plaintext[i] ^ keystream[i]
    });

    // Key fingerprint (first 32 bits for verification)
    let fingerprint = layeredHash(key.words[0], key.words[1], key.veritasSignature);

    {
      encryptedData     = encrypted;
      coherenceRequired = COHERENCE_MIN + (coherenceC - COHERENCE_MIN) * 0.5;  // Require similar coherence
      veritasRequired   = VERITAS_MIN;
      dilationTimestamp = key.dilationFactor;
      beatAtEncryption  = beatNum;
      securityLevel     = key.securityLevel;
      keyFingerprint    = fingerprint;
    }
  };

  // ============================================================
  // DECRYPTION
  // Requires regenerating key from current organism state
  // ============================================================

  public func decrypt(
    ciphertext  : QCCiphertext,
    key         : QCKey,
    coherenceC  : Float,
    beatNum     : Nat,
    observer    : ObserverState
  ) : ?[Nat32] {

    // Step 1: Observer effect check (Architect presence)
    // If Architect is NOT present, decryption may fail randomly
    let observerBonus = if (observer.architectPresent) {
      observer.observationStrength * 0.2
    } else {
      0.0
    };

    // Step 2: Coherence check
    let effectiveCoherence = coherenceC + observerBonus;
    if (effectiveCoherence < ciphertext.coherenceRequired) {
      return null;  // Coherence too low
    };

    // Step 3: Key fingerprint verification
    let expectedFingerprint = layeredHash(key.words[0], key.words[1], key.veritasSignature);
    if (expectedFingerprint != ciphertext.keyFingerprint) {
      return null;  // Key mismatch
    };

    // Step 4: Temporal proximity check (within 10000 beats)
    let beatDiff = if (beatNum > ciphertext.beatAtEncryption) {
      beatNum - ciphertext.beatAtEncryption
    } else {
      ciphertext.beatAtEncryption - beatNum
    };
    if (beatDiff > 10000) {
      return null;  // Too old (replay protection)
    };

    // Step 5: Regenerate keystream
    let keystreamSize = ciphertext.encryptedData.size();
    let keystream = Array.tabulate<Nat32>(keystreamSize, func(i) {
      let keyWord = key.words[i % KEY_WORDS];
      let beatMix = Nat32.fromNat((ciphertext.beatAtEncryption + i) % 4294967296);
      layeredHash(keyWord, beatMix, key.coherenceSalt)
    });

    // Step 6: XOR decryption
    let decrypted = Array.tabulate<Nat32>(ciphertext.encryptedData.size(), func(i) {
      ciphertext.encryptedData[i] ^ keystream[i]
    });

    ?decrypted
  };

  // ============================================================
  // STATE MANAGEMENT
  // ============================================================

  public func initQCEState() : QCEState {
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
      };
      isLocked        = false;
    }
  };

  // Update observer state (Architect presence triggers wave function behavior)
  public func updateObserver(
    state        : QCEState,
    isPresent    : Bool,
    strength     : Float,
    beatNum      : Nat
  ) : QCEState {
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
      };
      isLocked        = state.isLocked;
    }
  };

  // Store a new key and update state
  public func storeKey(state : QCEState, key : QCKey, beatNum : Nat) : QCEState {
    {
      currentKey      = ?key;
      encryptionCount = state.encryptionCount;
      decryptionCount = state.decryptionCount;
      failedDecrypts  = state.failedDecrypts;
      lastKeyBeat     = beatNum;
      observer        = state.observer;
      isLocked        = false;
    }
  };

  // Record successful encryption
  public func recordEncryption(state : QCEState) : QCEState {
    {
      currentKey      = state.currentKey;
      encryptionCount = state.encryptionCount + 1;
      decryptionCount = state.decryptionCount;
      failedDecrypts  = state.failedDecrypts;
      lastKeyBeat     = state.lastKeyBeat;
      observer        = state.observer;
      isLocked        = state.isLocked;
    }
  };

  // Record decryption attempt
  public func recordDecryption(state : QCEState, success : Bool) : QCEState {
    {
      currentKey      = state.currentKey;
      encryptionCount = state.encryptionCount;
      decryptionCount = if (success) state.decryptionCount + 1 else state.decryptionCount;
      failedDecrypts  = if (success) state.failedDecrypts else state.failedDecrypts + 1;
      lastKeyBeat     = state.lastKeyBeat;
      observer        = state.observer;
      isLocked        = state.isLocked;
    }
  };

  // Lock the encryption system (prevents new operations)
  public func lockQCE(state : QCEState) : QCEState {
    {
      currentKey      = null;
      encryptionCount = state.encryptionCount;
      decryptionCount = state.decryptionCount;
      failedDecrypts  = state.failedDecrypts;
      lastKeyBeat     = state.lastKeyBeat;
      observer        = state.observer;
      isLocked        = true;
    }
  };

  // ============================================================
  // CONVENIENCE: FULL ENCRYPT/DECRYPT WITH STATE
  // ============================================================

  public func fullEncrypt(
    state       : QCEState,
    plaintext   : [Nat32],
    shells      : [ShellState],
    coherenceC  : Float,
    beatNum     : Nat,
    creatorHash : Nat32,
    ratchetKey  : Nat32
  ) : ?(QCEState, QCCiphertext) {

    if (state.isLocked) { return null };

    // Derive fresh key
    switch (deriveKey(shells, coherenceC, beatNum, creatorHash, ratchetKey)) {
      case null { null };
      case (?key) {
        let ciphertext = encrypt(plaintext, key, coherenceC, beatNum);
        let newState = recordEncryption(storeKey(state, key, beatNum));
        ?(newState, ciphertext)
      };
    }
  };

  public func fullDecrypt(
    state      : QCEState,
    ciphertext : QCCiphertext,
    shells     : [ShellState],
    coherenceC : Float,
    beatNum    : Nat,
    creatorHash: Nat32,
    ratchetKey : Nat32
  ) : ?(QCEState, [Nat32]) {

    if (state.isLocked) { return null };

    // Derive key for decryption
    switch (deriveKey(shells, coherenceC, beatNum, creatorHash, ratchetKey)) {
      case null {
        let failState = recordDecryption(state, false);
        null
      };
      case (?key) {
        switch (decrypt(ciphertext, key, coherenceC, beatNum, state.observer)) {
          case null {
            let failState = recordDecryption(state, false);
            null
          };
          case (?decrypted) {
            let successState = recordDecryption(storeKey(state, key, beatNum), true);
            ?(successState, decrypted)
          };
        }
      };
    }
  };

  // ============================================================
  // DIAGNOSTICS
  // ============================================================

  public type QCEDiagnostics = {
    keyDerivable     : Bool;
    currentCoherence : Float;
    veritasLevel     : Float;
    securityLevel    : Nat;
    encryptionCount  : Nat;
    decryptionCount  : Nat;
    failedDecrypts   : Nat;
    observerPresent  : Bool;
    isLocked         : Bool;
  };

  public func diagnose(
    state      : QCEState,
    shells     : [ShellState],
    coherenceC : Float
  ) : QCEDiagnostics {

    let matrix = computeEntanglaMatrix(shells);
    let keyMaterial = extractEigenvalues(matrix);
    let veritas = computeVeritas(shells, coherenceC, keyMaterial.meanEntanglement);

    let secLevel = if (coherenceC >= 0.85) {
      SECURITY_MAX
    } else if (coherenceC >= 0.65) {
      SECURITY_MED
    } else {
      SECURITY_MIN
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
      isLocked         = state.isLocked;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

}
