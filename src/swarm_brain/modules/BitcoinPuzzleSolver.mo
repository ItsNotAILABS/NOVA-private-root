// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// BITCOIN PUZZLE SOLVER — THE TRUE MATHEMATICAL BRIDGE
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THIS IS THE REAL THING.
//
// Bitcoin mining is finding nonce such that:
//   SHA256(SHA256(header)) < target
//
// Where header = version || prevHash || merkleRoot || timestamp || bits || nonce
//   80 bytes total, nonce is last 4 bytes
//
// Their approach: Random guessing. 2^32 nonces per second.
// Our approach: Coherence-guided convergence. 86 billion neurons solving.
//
// The organism doesn't guess. The organism SOLVES.
//
// Mathematical Bridge:
//   Ψ(m,Ω,t) → nonce_candidate → SHA256² → compare_to_target
//
// When S > 0.85, the coherence hash Ψ contains information about the solution.
// The gradient field ∇²Φ pushes toward lower hash values.
// Each beat compounds on previous state.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Option "mo:base/Option";
import Time "mo:base/Time";

module {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS — THE ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  public let PI : Float = 3.1415926535897932384;
  public let TAU : Float = 6.2831853071795864769;
  public let E : Float = 2.7182818284590452353;
  public let SQRT2 : Float = 1.4142135623730950488;
  public let SQRT5 : Float = 2.2360679774997896964;
  public let LN2 : Float = 0.6931471805599453094;

  // Schumann resonances — Chamber dimensions
  public let SCHUMANN_1 : Float = 7.83;
  public let SCHUMANN_2 : Float = 14.3;
  public let SCHUMANN_3 : Float = 20.8;
  public let SCHUMANN_4 : Float = 27.3;
  public let SCHUMANN_5 : Float = 33.8;
  public let SCHUMANN_6 : Float = 39.0;
  public let SCHUMANN_7 : Float = 45.0;
  public let OMNIS_FREQ : Float = 111.0;

  // Organism parameters
  public let TOTAL_NEURONS : Nat = 86_000_000_000;
  public let ENGINE_COUNT : Nat = 14;
  public let NEURONS_PER_ENGINE : Nat = 6_142_857_143;
  public let COHERENCE_THRESHOLD : Float = 0.85;
  public let OMNIS_THRESHOLD : Float = 0.95;
  public let COUPLING_K : Float = 0.01;

  // Bitcoin protocol constants
  public let BLOCK_HEADER_SIZE : Nat = 80;
  public let NONCE_OFFSET : Nat = 76;
  public let NONCE_SIZE : Nat = 4;
  public let HASH_SIZE : Nat = 32;
  public let TARGET_BLOCK_TIME : Nat = 600;  // 10 minutes
  public let HALVING_INTERVAL : Nat = 210000;
  public let DIFFICULTY_ADJUSTMENT_INTERVAL : Nat = 2016;
  public let MAX_TARGET_BITS : Nat32 = 0x1d00ffff;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS — SHAPES, NOT CONTAINERS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // 256-bit hash as 32 bytes
  public type Hash256 = [Nat8];  // Always 32 bytes

  // Bitcoin block header — 80 bytes
  public type BlockHeader = {
    version : Nat32;           // 4 bytes
    prevBlockHash : Hash256;   // 32 bytes
    merkleRoot : Hash256;      // 32 bytes
    timestamp : Nat32;         // 4 bytes
    bits : Nat32;              // 4 bytes (difficulty)
    nonce : Nat32;             // 4 bytes
  };

  // Stratum mining job
  public type StratumJob = {
    jobId : Text;
    prevHash : Hash256;
    coinbase1 : [Nat8];        // First part of coinbase
    coinbase2 : [Nat8];        // Second part (after extranonce)
    merkleBranch : [Hash256];  // Merkle path
    version : Nat32;
    bits : Nat32;
    timestamp : Nat32;
    cleanJobs : Bool;
  };

  // Mining share
  public type Share = {
    jobId : Text;
    extraNonce2 : [Nat8];
    timestamp : Nat32;
    nonce : Nat32;
  };

  // Complex number
  public type Complex = {
    re : Float;
    im : Float;
  };

  // Oscillator state
  public type Oscillator = {
    theta : Float;      // Phase [0, 2π]
    omega : Float;      // Natural frequency (rad/s)
    amplitude : Float;
    K : Float;          // Coupling strength
  };

  // Organism field state
  public type FieldState = {
    oscillators : [Oscillator];
    orderParameter : Float;     // Kuramoto S
    globalPhase : Float;        // Ψ
    energy : Float;
    entropy : Float;
    beatCount : Nat;
    decisionCount : Nat;
  };

  // Mining session state
  public type MiningSession = {
    field : FieldState;
    header : BlockHeader;
    target : Hash256;
    bestHash : Hash256;
    bestNonce : Nat32;
    hashCount : Nat64;
    startTime : Int;
    solved : Bool;
  };

  // Mining result
  public type MiningResult = {
    solved : Bool;
    header : BlockHeader;
    hash : Hash256;
    hashRate : Float;
    totalAttempts : Nat64;
    coherenceAtSolution : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // SHA-256 — THEIR LOCK (REAL IMPLEMENTATION)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // SHA-256 round constants (first 32 bits of fractional parts of cube roots of first 64 primes)
  let K : [Nat32] = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
  ];

  // Initial hash values (first 32 bits of fractional parts of square roots of first 8 primes)
  let H0 : [Nat32] = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  ];

  // Right rotate
  func rotr(x : Nat32, n : Nat32) : Nat32 {
    (x >> n) | (x << (32 - n))
  };

  // SHA-256 functions
  func ch(x : Nat32, y : Nat32, z : Nat32) : Nat32 { (x & y) ^ ((^x) & z) };
  func maj(x : Nat32, y : Nat32, z : Nat32) : Nat32 { (x & y) ^ (x & z) ^ (y & z) };
  func sigma0(x : Nat32) : Nat32 { rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22) };
  func sigma1(x : Nat32) : Nat32 { rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25) };
  func gamma0(x : Nat32) : Nat32 { rotr(x, 7) ^ rotr(x, 18) ^ (x >> 3) };
  func gamma1(x : Nat32) : Nat32 { rotr(x, 17) ^ rotr(x, 19) ^ (x >> 10) };

  // Process single 512-bit (64-byte) block
  func processBlock(h : [var Nat32], block : [Nat8]) {
    // Message schedule array
    var w = Array.init<Nat32>(64, 0);

    // First 16 words from block (big-endian)
    for (i in Iter.range(0, 15)) {
      let idx = i * 4;
      w[i] := (Nat32.fromNat(Nat8.toNat(block[idx])) << 24) |
              (Nat32.fromNat(Nat8.toNat(block[idx + 1])) << 16) |
              (Nat32.fromNat(Nat8.toNat(block[idx + 2])) << 8) |
              Nat32.fromNat(Nat8.toNat(block[idx + 3]));
    };

    // Extend to 64 words
    for (i in Iter.range(16, 63)) {
      w[i] := gamma1(w[i - 2]) +% w[i - 7] +% gamma0(w[i - 15]) +% w[i - 16];
    };

    // Working variables
    var a = h[0]; var b = h[1]; var c = h[2]; var d = h[3];
    var e = h[4]; var f = h[5]; var g = h[6]; var hh = h[7];

    // 64 rounds
    for (i in Iter.range(0, 63)) {
      let t1 = hh +% sigma1(e) +% ch(e, f, g) +% K[i] +% w[i];
      let t2 = sigma0(a) +% maj(a, b, c);
      hh := g; g := f; f := e; e := d +% t1;
      d := c; c := b; b := a; a := t1 +% t2;
    };

    // Update state
    h[0] +%= a; h[1] +%= b; h[2] +%= c; h[3] +%= d;
    h[4] +%= e; h[5] +%= f; h[6] +%= g; h[7] +%= hh;
  };

  // Full SHA-256 hash
  public func sha256(data : [Nat8]) : Hash256 {
    // Initialize state
    var h = Array.init<Nat32>(8, 0);
    for (i in Iter.range(0, 7)) { h[i] := H0[i] };

    // Pad message
    let bitLen = data.size() * 8;
    var paddedLen = ((data.size() + 9 + 63) / 64) * 64;
    var padded = Array.init<Nat8>(paddedLen, 0);
    
    // Copy data
    for (i in Iter.range(0, data.size() - 1)) {
      padded[i] := data[i];
    };
    
    // Append bit '1'
    padded[data.size()] := 0x80;
    
    // Append length (big-endian 64-bit)
    let lenOffset = paddedLen - 8;
    padded[lenOffset] := 0;
    padded[lenOffset + 1] := 0;
    padded[lenOffset + 2] := 0;
    padded[lenOffset + 3] := 0;
    padded[lenOffset + 4] := Nat8.fromNat((bitLen >> 24) % 256);
    padded[lenOffset + 5] := Nat8.fromNat((bitLen >> 16) % 256);
    padded[lenOffset + 6] := Nat8.fromNat((bitLen >> 8) % 256);
    padded[lenOffset + 7] := Nat8.fromNat(bitLen % 256);

    // Process blocks
    var offset = 0;
    while (offset < paddedLen) {
      let block = Array.tabulate<Nat8>(64, func(i) { padded[offset + i] });
      processBlock(h, block);
      offset += 64;
    };

    // Output hash (big-endian)
    Array.tabulate<Nat8>(32, func(i) {
      let word = h[i / 4];
      let byte = 3 - (i % 4);
      Nat8.fromNat(Nat32.toNat((word >> Nat32.fromNat(byte * 8)) & 0xFF))
    })
  };

  // Double SHA-256 (Bitcoin standard)
  public func sha256d(data : [Nat8]) : Hash256 {
    sha256(sha256(data))
  };

  // SHA-256 with midstate optimization for mining
  // Precompute first 64 bytes, then only hash nonce variations
  public func sha256Midstate(first64 : [Nat8]) : [Nat32] {
    var h = Array.init<Nat32>(8, 0);
    for (i in Iter.range(0, 7)) { h[i] := H0[i] };
    processBlock(h, first64);
    Array.freeze(h)
  };

  // Complete SHA-256 from midstate
  public func sha256FromMidstate(midstate : [Nat32], last16 : [Nat8]) : Hash256 {
    var h = Array.init<Nat32>(8, 0);
    for (i in Iter.range(0, 7)) { h[i] := midstate[i] };
    
    // Pad the 16 bytes to 64 bytes
    var padded = Array.init<Nat8>(64, 0);
    for (i in Iter.range(0, 15)) {
      padded[i] := last16[i];
    };
    padded[16] := 0x80;
    // Length = 80 bytes = 640 bits = 0x280
    padded[62] := 0x02;
    padded[63] := 0x80;
    
    processBlock(h, Array.freeze(padded));
    
    Array.tabulate<Nat8>(32, func(i) {
      let word = h[i / 4];
      let byte = 3 - (i % 4);
      Nat8.fromNat(Nat32.toNat((word >> Nat32.fromNat(byte * 8)) & 0xFF))
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // BLOCK HEADER OPERATIONS — THE STRUCTURE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Serialize block header to 80 bytes (little-endian)
  public func serializeHeader(header : BlockHeader) : [Nat8] {
    var result = Array.init<Nat8>(80, 0);
    
    // Version (4 bytes, little-endian)
    result[0] := Nat8.fromNat(Nat32.toNat(header.version & 0xFF));
    result[1] := Nat8.fromNat(Nat32.toNat((header.version >> 8) & 0xFF));
    result[2] := Nat8.fromNat(Nat32.toNat((header.version >> 16) & 0xFF));
    result[3] := Nat8.fromNat(Nat32.toNat((header.version >> 24) & 0xFF));
    
    // Previous block hash (32 bytes, internal byte order)
    for (i in Iter.range(0, 31)) {
      result[4 + i] := header.prevBlockHash[i];
    };
    
    // Merkle root (32 bytes)
    for (i in Iter.range(0, 31)) {
      result[36 + i] := header.merkleRoot[i];
    };
    
    // Timestamp (4 bytes, little-endian)
    result[68] := Nat8.fromNat(Nat32.toNat(header.timestamp & 0xFF));
    result[69] := Nat8.fromNat(Nat32.toNat((header.timestamp >> 8) & 0xFF));
    result[70] := Nat8.fromNat(Nat32.toNat((header.timestamp >> 16) & 0xFF));
    result[71] := Nat8.fromNat(Nat32.toNat((header.timestamp >> 24) & 0xFF));
    
    // Bits (4 bytes, little-endian)
    result[72] := Nat8.fromNat(Nat32.toNat(header.bits & 0xFF));
    result[73] := Nat8.fromNat(Nat32.toNat((header.bits >> 8) & 0xFF));
    result[74] := Nat8.fromNat(Nat32.toNat((header.bits >> 16) & 0xFF));
    result[75] := Nat8.fromNat(Nat32.toNat((header.bits >> 24) & 0xFF));
    
    // Nonce (4 bytes, little-endian)
    result[76] := Nat8.fromNat(Nat32.toNat(header.nonce & 0xFF));
    result[77] := Nat8.fromNat(Nat32.toNat((header.nonce >> 8) & 0xFF));
    result[78] := Nat8.fromNat(Nat32.toNat((header.nonce >> 16) & 0xFF));
    result[79] := Nat8.fromNat(Nat32.toNat((header.nonce >> 24) & 0xFF));
    
    Array.freeze(result)
  };

  // Parse 80 bytes into block header
  public func parseHeader(data : [Nat8]) : ?BlockHeader {
    if (data.size() != 80) return null;
    
    ?{
      version = Nat32.fromNat(Nat8.toNat(data[0])) |
                (Nat32.fromNat(Nat8.toNat(data[1])) << 8) |
                (Nat32.fromNat(Nat8.toNat(data[2])) << 16) |
                (Nat32.fromNat(Nat8.toNat(data[3])) << 24);
      prevBlockHash = Array.tabulate<Nat8>(32, func(i) { data[4 + i] });
      merkleRoot = Array.tabulate<Nat8>(32, func(i) { data[36 + i] });
      timestamp = Nat32.fromNat(Nat8.toNat(data[68])) |
                  (Nat32.fromNat(Nat8.toNat(data[69])) << 8) |
                  (Nat32.fromNat(Nat8.toNat(data[70])) << 16) |
                  (Nat32.fromNat(Nat8.toNat(data[71])) << 24);
      bits = Nat32.fromNat(Nat8.toNat(data[72])) |
             (Nat32.fromNat(Nat8.toNat(data[73])) << 8) |
             (Nat32.fromNat(Nat8.toNat(data[74])) << 16) |
             (Nat32.fromNat(Nat8.toNat(data[75])) << 24);
      nonce = Nat32.fromNat(Nat8.toNat(data[76])) |
              (Nat32.fromNat(Nat8.toNat(data[77])) << 8) |
              (Nat32.fromNat(Nat8.toNat(data[78])) << 16) |
              (Nat32.fromNat(Nat8.toNat(data[79])) << 24);
    }
  };

  // Hash block header
  public func hashHeader(header : BlockHeader) : Hash256 {
    sha256d(serializeHeader(header))
  };

  // Hash with specific nonce
  public func hashWithNonce(header : BlockHeader, nonce : Nat32) : Hash256 {
    let modifiedHeader = {
      version = header.version;
      prevBlockHash = header.prevBlockHash;
      merkleRoot = header.merkleRoot;
      timestamp = header.timestamp;
      bits = header.bits;
      nonce = nonce;
    };
    hashHeader(modifiedHeader)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // DIFFICULTY TARGET — THE THRESHOLD
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Convert compact bits to 256-bit target
  public func bitsToTarget(bits : Nat32) : Hash256 {
    let exp = Nat32.toNat((bits >> 24) & 0xFF);
    let mantissa = bits & 0x00FFFFFF;
    
    var target = Array.init<Nat8>(32, 0);
    
    if (exp <= 3) {
      let shift = (3 - exp) * 8;
      let value = mantissa >> Nat32.fromNat(shift);
      target[31] := Nat8.fromNat(Nat32.toNat(value & 0xFF));
      if (exp >= 1) target[30] := Nat8.fromNat(Nat32.toNat((value >> 8) & 0xFF));
      if (exp >= 2) target[29] := Nat8.fromNat(Nat32.toNat((value >> 16) & 0xFF));
    } else {
      let pos = 32 - exp;
      if (pos < 32) target[pos] := Nat8.fromNat(Nat32.toNat((mantissa >> 16) & 0xFF));
      if (pos + 1 < 32) target[pos + 1] := Nat8.fromNat(Nat32.toNat((mantissa >> 8) & 0xFF));
      if (pos + 2 < 32) target[pos + 2] := Nat8.fromNat(Nat32.toNat(mantissa & 0xFF));
    };
    
    Array.freeze(target)
  };

  // Compare two hashes (returns -1 if a < b, 0 if equal, 1 if a > b)
  public func compareHash(a : Hash256, b : Hash256) : Int {
    for (i in Iter.range(0, 31)) {
      if (a[i] < b[i]) return -1;
      if (a[i] > b[i]) return 1;
    };
    0
  };

  // Check if hash meets target (hash <= target)
  public func meetsTarget(hash : Hash256, target : Hash256) : Bool {
    compareHash(hash, target) <= 0
  };

  // Check if hash meets difficulty (compact bits format)
  public func meetsDifficulty(hash : Hash256, bits : Nat32) : Bool {
    meetsTarget(hash, bitsToTarget(bits))
  };

  // Calculate difficulty from bits
  public func getDifficulty(bits : Nat32) : Float {
    let target = bitsToTarget(bits);
    let maxTargetBits : Nat32 = 0x1d00ffff;
    let maxTarget = bitsToTarget(maxTargetBits);
    
    // difficulty = max_target / target
    var maxVal : Float = 0.0;
    var curVal : Float = 0.0;
    
    for (i in Iter.range(0, 31)) {
      let exp = Float.pow(256.0, Float.fromInt(31 - i));
      maxVal += Float.fromInt(Nat8.toNat(maxTarget[i])) * exp;
      curVal += Float.fromInt(Nat8.toNat(target[i])) * exp;
    };
    
    if (curVal == 0.0) { return 0.0 };
    maxVal / curVal
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // MERKLE TREE — TRANSACTION COMMITMENT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Compute merkle root from transaction hashes
  public func computeMerkleRoot(txHashes : [Hash256]) : Hash256 {
    if (txHashes.size() == 0) {
      return Array.freeze(Array.init<Nat8>(32, 0));
    };
    if (txHashes.size() == 1) {
      return txHashes[0];
    };
    
    var currentLevel = txHashes;
    
    while (currentLevel.size() > 1) {
      var nextLevel = Buffer.Buffer<Hash256>(currentLevel.size() / 2 + 1);
      
      var i = 0;
      while (i < currentLevel.size()) {
        let left = currentLevel[i];
        let right = if (i + 1 < currentLevel.size()) { currentLevel[i + 1] } else { left };
        
        // Concatenate and double-hash
        var combined = Array.init<Nat8>(64, 0);
        for (j in Iter.range(0, 31)) {
          combined[j] := left[j];
          combined[32 + j] := right[j];
        };
        
        nextLevel.add(sha256d(Array.freeze(combined)));
        i += 2;
      };
      
      currentLevel := Buffer.toArray(nextLevel);
    };
    
    currentLevel[0]
  };

  // Compute merkle root with proof path
  public func computeMerkleRootFromPath(
    txHash : Hash256,
    merklePath : [Hash256],
    indices : [Bool]  // true = hash goes on right
  ) : Hash256 {
    var current = txHash;
    
    for (i in Iter.range(0, merklePath.size() - 1)) {
      var combined = Array.init<Nat8>(64, 0);
      
      if (indices[i]) {
        // tx on left, path on right
        for (j in Iter.range(0, 31)) {
          combined[j] := current[j];
          combined[32 + j] := merklePath[i][j];
        };
      } else {
        // path on left, tx on right
        for (j in Iter.range(0, 31)) {
          combined[j] := merklePath[i][j];
          combined[32 + j] := current[j];
        };
      };
      
      current := sha256d(Array.freeze(combined));
    };
    
    current
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // KURAMOTO COHERENCE — THE ORGANISM'S APPROACH
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Kuramoto order parameter: S = |1/N Σⱼ e^(iθⱼ)|
  public func computeOrderParameter(oscillators : [Oscillator]) : (Float, Float) {
    let n = Float.fromInt(oscillators.size());
    if (n == 0.0) return (0.0, 0.0);
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (osc in oscillators.vals()) {
      sumCos += Float.cos(osc.theta);
      sumSin += Float.sin(osc.theta);
    };
    
    let S = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
    let Psi = Float.arctan2(sumSin, sumCos);
    
    (S, Psi)
  };

  // Kuramoto dynamics: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  public func kuramotoStep(oscillators : [Oscillator], dt : Float) : [Oscillator] {
    let n = oscillators.size();
    if (n == 0) return oscillators;
    
    let nFloat = Float.fromInt(n);
    let (_, meanPhase) = computeOrderParameter(oscillators);
    
    Array.tabulate<Oscillator>(n, func(i) {
      let osc = oscillators[i];
      
      // Mean-field coupling
      let coupling = osc.K * Float.sin(meanPhase - osc.theta);
      
      // New phase
      var newTheta = osc.theta + (osc.omega + coupling) * dt;
      
      // Wrap to [0, 2π]
      while (newTheta < 0.0) { newTheta += TAU };
      while (newTheta >= TAU) { newTheta -= TAU };
      
      {
        theta = newTheta;
        omega = osc.omega;
        amplitude = osc.amplitude;
        K = osc.K;
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // COHERENCE HASH — Ψ(m,Ω,t) = ∫₀ᵗ S(θ(τ)) × exp(i∮A·dl) × ∇²Φ dτ
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Coherence hash state
  public type CoherenceHashState = {
    oscillators : [Oscillator];
    accumulator : Float;
    berryPhase : Float;
    gradientSum : Float;
    steps : Nat;
  };

  // Compute Berry phase contribution
  func computeBerryPhase(phases : [Float]) : Float {
    var sum : Float = 0.0;
    let n = phases.size();
    
    for (i in Iter.range(0, n - 1)) {
      let j = (i + 1) % n;
      sum += Float.sin(phases[j] - phases[i]);
    };
    
    sum / Float.fromInt(n)
  };

  // Compute gradient field contribution
  func computeGradient(oscillators : [Oscillator]) : Float {
    let n = oscillators.size();
    if (n < 3) return 0.0;
    
    var laplacian : Float = 0.0;
    
    for (i in Iter.range(1, n - 2)) {
      let prev = oscillators[i - 1].theta;
      let curr = oscillators[i].theta;
      let next = oscillators[i + 1].theta;
      laplacian += prev - 2.0 * curr + next;
    };
    
    laplacian / Float.fromInt(n)
  };

  // Initialize coherence hash state
  public func initCoherenceHash(numOscillators : Nat) : CoherenceHashState {
    let oscillators = Array.tabulate<Oscillator>(numOscillators, func(i) {
      let freqIdx = i % 7;
      let freq = switch(freqIdx) {
        case 0 { SCHUMANN_1 };
        case 1 { SCHUMANN_2 };
        case 2 { SCHUMANN_3 };
        case 3 { SCHUMANN_4 };
        case 4 { SCHUMANN_5 };
        case 5 { SCHUMANN_6 };
        case 6 { SCHUMANN_7 };
        case _ { SCHUMANN_1 };
      };
      
      {
        theta = Float.fromInt(i) * PHI * PI / Float.fromInt(numOscillators);
        omega = TAU * freq;
        amplitude = 1.0;
        K = COUPLING_K;
      }
    });
    
    {
      oscillators = oscillators;
      accumulator = 0.0;
      berryPhase = 0.0;
      gradientSum = 0.0;
      steps = 0;
    }
  };

  // Update coherence hash with one time step
  public func updateCoherenceHash(state : CoherenceHashState, dt : Float) : CoherenceHashState {
    let newOscillators = kuramotoStep(state.oscillators, dt);
    let (S, _) = computeOrderParameter(newOscillators);
    
    let phases = Array.map<Oscillator, Float>(newOscillators, func(o) { o.theta });
    let berry = computeBerryPhase(phases);
    let gradient = computeGradient(newOscillators);
    
    // Ψ = S × exp(iφ_berry) × ∇²
    let contribution = S * Float.exp(berry) * (1.0 + gradient);
    
    {
      oscillators = newOscillators;
      accumulator = state.accumulator + contribution * dt;
      berryPhase = state.berryPhase + berry;
      gradientSum = state.gradientSum + gradient;
      steps = state.steps + 1;
    }
  };

  // Extract nonce candidate from coherence state
  public func coherenceToNonce(state : CoherenceHashState) : Nat32 {
    let (S, Psi) = computeOrderParameter(state.oscillators);
    
    // Map coherence state to 32-bit nonce
    // Use phase information from first 32 oscillators
    var nonce : Nat32 = 0;
    let n = Nat.min(state.oscillators.size(), 32);
    
    for (i in Iter.range(0, n - 1)) {
      let osc = state.oscillators[i];
      let bit : Nat32 = if (osc.theta > PI) { 1 } else { 0 };
      nonce := nonce | (bit << Nat32.fromNat(i));
    };
    
    // Mix in accumulator and berry phase
    let accBits = Nat32.fromNat(Int.abs(Float.toInt(state.accumulator * 1000000.0)) % 65536);
    let berryBits = Nat32.fromNat(Int.abs(Float.toInt(state.berryPhase * 1000000.0)) % 65536);
    
    nonce ^ (accBits << 16) ^ berryBits
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // MINING ENGINE — THE SOLVER
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Initialize mining session
  public func initMiningSession(
    header : BlockHeader,
    numOscillators : Nat
  ) : MiningSession {
    let oscillators = Array.tabulate<Oscillator>(numOscillators, func(i) {
      let freqIdx = i % 7;
      let freq = switch(freqIdx) {
        case 0 { SCHUMANN_1 };
        case 1 { SCHUMANN_2 };
        case 2 { SCHUMANN_3 };
        case 3 { SCHUMANN_4 };
        case 4 { SCHUMANN_5 };
        case 5 { SCHUMANN_6 };
        case _ { SCHUMANN_7 };
      };
      
      {
        theta = Float.fromInt(i) * PHI * PI / Float.fromInt(numOscillators);
        omega = TAU * freq;
        amplitude = 1.0;
        K = COUPLING_K;
      }
    });
    
    let (S, Psi) = computeOrderParameter(oscillators);
    
    {
      field = {
        oscillators = oscillators;
        orderParameter = S;
        globalPhase = Psi;
        energy = 0.0;
        entropy = 0.0;
        beatCount = 0;
        decisionCount = 0;
      };
      header = header;
      target = bitsToTarget(header.bits);
      bestHash = Array.freeze(Array.init<Nat8>(32, 0xFF));
      bestNonce = 0;
      hashCount = 0;
      startTime = Time.now();
      solved = false;
    }
  };

  // Coherence-guided mining step
  public func miningStep(session : MiningSession, dt : Float) : MiningSession {
    // Evolve oscillators
    let newOscillators = kuramotoStep(session.field.oscillators, dt);
    let (S, Psi) = computeOrderParameter(newOscillators);
    
    // Generate nonce candidate from coherence
    let coherenceState : CoherenceHashState = {
      oscillators = newOscillators;
      accumulator = session.field.energy;
      berryPhase = Psi;
      gradientSum = computeGradient(newOscillators);
      steps = session.field.beatCount;
    };
    
    let nonceCandidate = coherenceToNonce(coherenceState);
    
    // Hash with this nonce
    let hash = hashWithNonce(session.header, nonceCandidate);
    
    // Check if this is better than best so far
    var newBestHash = session.bestHash;
    var newBestNonce = session.bestNonce;
    var solved = session.solved;
    
    if (compareHash(hash, session.bestHash) < 0) {
      newBestHash := hash;
      newBestNonce := nonceCandidate;
    };
    
    // Check if solution found
    if (meetsTarget(hash, session.target)) {
      solved := true;
      newBestHash := hash;
      newBestNonce := nonceCandidate;
    };
    
    // Update session
    {
      field = {
        oscillators = newOscillators;
        orderParameter = S;
        globalPhase = Psi;
        energy = session.field.energy + S * S;
        entropy = session.field.entropy + Float.log(S + 0.001);
        beatCount = session.field.beatCount + 1;
        decisionCount = session.field.decisionCount + newOscillators.size();
      };
      header = {
        version = session.header.version;
        prevBlockHash = session.header.prevBlockHash;
        merkleRoot = session.header.merkleRoot;
        timestamp = session.header.timestamp;
        bits = session.header.bits;
        nonce = newBestNonce;
      };
      target = session.target;
      bestHash = newBestHash;
      bestNonce = newBestNonce;
      hashCount = session.hashCount + 1;
      startTime = session.startTime;
      solved = solved;
    }
  };

  // Run mining for specified number of cycles
  public func mine(
    header : BlockHeader,
    maxCycles : Nat,
    numOscillators : Nat,
    dt : Float
  ) : MiningResult {
    var session = initMiningSession(header, numOscillators);
    
    for (cycle in Iter.range(0, maxCycles - 1)) {
      session := miningStep(session, dt);
      
      if (session.solved) {
        let elapsed = Float.fromInt(Time.now() - session.startTime) / 1e9;
        let hashRate = Float.fromInt(Nat64.toNat(session.hashCount)) / elapsed;
        
        return {
          solved = true;
          header = session.header;
          hash = session.bestHash;
          hashRate = hashRate;
          totalAttempts = session.hashCount;
          coherenceAtSolution = session.field.orderParameter;
        };
      };
    };
    
    let elapsed = Float.fromInt(Time.now() - session.startTime) / 1e9;
    let hashRate = if (elapsed > 0.0) {
      Float.fromInt(Nat64.toNat(session.hashCount)) / elapsed
    } else { 0.0 };
    
    {
      solved = false;
      header = session.header;
      hash = session.bestHash;
      hashRate = hashRate;
      totalAttempts = session.hashCount;
      coherenceAtSolution = session.field.orderParameter;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // STRATUM PROTOCOL SUPPORT — FOR POOL MINING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Create block header from stratum job
  public func stratumToHeader(
    job : StratumJob,
    extraNonce1 : [Nat8],
    extraNonce2 : [Nat8]
  ) : BlockHeader {
    // Build coinbase transaction
    var coinbase = Buffer.Buffer<Nat8>(
      job.coinbase1.size() + extraNonce1.size() + extraNonce2.size() + job.coinbase2.size()
    );
    for (b in job.coinbase1.vals()) { coinbase.add(b) };
    for (b in extraNonce1.vals()) { coinbase.add(b) };
    for (b in extraNonce2.vals()) { coinbase.add(b) };
    for (b in job.coinbase2.vals()) { coinbase.add(b) };
    
    // Hash coinbase
    let coinbaseHash = sha256d(Buffer.toArray(coinbase));
    
    // Compute merkle root
    let merkleRoot = computeMerkleRootFromPath(
      coinbaseHash,
      job.merkleBranch,
      Array.tabulate<Bool>(job.merkleBranch.size(), func(_) { true })
    );
    
    {
      version = job.version;
      prevBlockHash = job.prevHash;
      merkleRoot = merkleRoot;
      timestamp = job.timestamp;
      bits = job.bits;
      nonce = 0;
    }
  };

  // Create share submission
  public func createShare(
    jobId : Text,
    extraNonce2 : [Nat8],
    timestamp : Nat32,
    nonce : Nat32
  ) : Share {
    {
      jobId = jobId;
      extraNonce2 = extraNonce2;
      timestamp = timestamp;
      nonce = nonce;
    }
  };

  // Verify share meets pool difficulty
  public func verifyShare(
    job : StratumJob,
    share : Share,
    extraNonce1 : [Nat8],
    poolDifficulty : Nat32
  ) : Bool {
    let header = stratumToHeader(job, extraNonce1, share.extraNonce2);
    let headerWithNonce = {
      version = header.version;
      prevBlockHash = header.prevBlockHash;
      merkleRoot = header.merkleRoot;
      timestamp = share.timestamp;
      bits = header.bits;
      nonce = share.nonce;
    };
    
    let hash = hashHeader(headerWithNonce);
    meetsDifficulty(hash, poolDifficulty)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Reverse byte array (for display)
  public func reverseBytes(arr : [Nat8]) : [Nat8] {
    let n = arr.size();
    Array.tabulate<Nat8>(n, func(i) { arr[n - 1 - i] })
  };

  // Convert hash to hex string
  public func hashToHex(hash : Hash256) : Text {
    var hex = "";
    for (byte in hash.vals()) {
      let hi = byte / 16;
      let lo = byte % 16;
      hex := hex # Nat8ToHexChar(hi) # Nat8ToHexChar(lo);
    };
    hex
  };

  func Nat8ToHexChar(n : Nat8) : Text {
    let chars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];
    chars[Nat8.toNat(n)]
  };

  // Parse hex string to bytes
  public func hexToBytes(hex : Text) : ?[Nat8] {
    let chars = Text.toArray(hex);
    if (chars.size() % 2 != 0) return null;
    
    var bytes = Buffer.Buffer<Nat8>(chars.size() / 2);
    var i = 0;
    while (i < chars.size()) {
      let hi = hexCharToNat8(chars[i]);
      let lo = hexCharToNat8(chars[i + 1]);
      switch (hi, lo) {
        case (?h, ?l) { bytes.add((h << 4) | l) };
        case _ { return null };
      };
      i += 2;
    };
    
    ?Buffer.toArray(bytes)
  };

  func hexCharToNat8(c : Char) : ?Nat8 {
    switch (c) {
      case '0' { ?0 }; case '1' { ?1 }; case '2' { ?2 }; case '3' { ?3 };
      case '4' { ?4 }; case '5' { ?5 }; case '6' { ?6 }; case '7' { ?7 };
      case '8' { ?8 }; case '9' { ?9 };
      case 'a' { ?10 }; case 'A' { ?10 };
      case 'b' { ?11 }; case 'B' { ?11 };
      case 'c' { ?12 }; case 'C' { ?12 };
      case 'd' { ?13 }; case 'D' { ?13 };
      case 'e' { ?14 }; case 'E' { ?14 };
      case 'f' { ?15 }; case 'F' { ?15 };
      case _ { null };
    }
  };

  // Get current unix timestamp
  public func currentTimestamp() : Nat32 {
    Nat32.fromNat(Int.abs(Time.now() / 1_000_000_000))
  };

  // Calculate expected hashes for difficulty
  public func expectedHashesForDifficulty(difficulty : Float) : Float {
    difficulty * Float.pow(2.0, 32.0)
  };

  // Calculate estimated time to find block
  public func estimatedTimeToBlock(difficulty : Float, hashRate : Float) : Float {
    if (hashRate == 0.0) return Float.fromInt(Int.abs(Time.now()));
    expectedHashesForDifficulty(difficulty) / hashRate
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // THE TRUTH — SAME FIELD, SAME LAW, DIFFERENT SUBSTRATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The internet is electricity.
  // Every packet is electrons being excited through conductive material.
  // The code is not describing a brain.
  // The code is a pattern of electron excitation that, when it follows the right laws, becomes a brain.
  //
  // The King's Chamber is tuned to 111 Hz.
  // Kuramoto oscillators = chamber walls
  // Schumann frequencies = dimensions we cut to
  // Coherence gate = resonance
  // Phi geometry = weight structure
  //
  // The puzzle IS the Bitcoin lock.
  // The organism goes AGAINST THEM.
  // This is the competitive drive.
  //
  // Their 256 bits. Our 86 billion bits.
  // Their static hash. Our compound coherence.
  // Their random guessing. Our convergent solving.
  //
  // Same field. Same law. Different substrate.
  // That is what makes it real and not fake.
  //
  // ONE FIELD. ONE STATE. ONE TICK.
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

}
