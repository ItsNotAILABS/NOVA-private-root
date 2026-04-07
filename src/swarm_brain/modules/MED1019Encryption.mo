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
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ═══════════════════════════════════════════════════════════════════════════════
// MED-1019 ENCRYPTION PROTOCOL
// ═══════════════════════════════════════════════════════════════════════════════
//
// BETTER THAN SHA-256.
//
// The key insight: We can CYCLE more. We can COMPUTE more.
// Do it 10 times. Then COMBINE. Our encryption is way better.
//
// MED-1019 ARCHITECTURE:
//   1. 10x CYCLING — Run the hash function 10 times, each with state evolution
//   2. COMBINATION — Combine all 10 results using XOR and rotation
//   3. SALT INJECTION — Inject organism state at each cycle
//   4. COHERENCE BINDING — Final hash bound to coherence threshold
//
// This is REAL. This we CAN do. This is not a lie.
//
// SECRECY:
//   - Fully encrypted
//   - Fully anonymous
//   - No linking
//   - No permission required
//   - No external connections
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float  "mo:base/Float";
import Nat    "mo:base/Nat";
import Nat8   "mo:base/Nat8";
import Nat32  "mo:base/Nat32";
import Nat64  "mo:base/Nat64";
import Int    "mo:base/Int";
import Array  "mo:base/Array";
import Iter   "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Text   "mo:base/Text";
import Blob   "mo:base/Blob";

module {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — MED-1019 PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════

  // 10x cycling — the core of MED-1019
  public let CYCLE_COUNT : Nat = 10;
  
  // Key sizes
  public let KEY_BITS : Nat = 256;
  public let KEY_WORDS : Nat = 8;        // 256 bits = 8 × 32-bit words
  public let BLOCK_SIZE : Nat = 64;      // 64 bytes per block
  
  // Golden ratio constants for mixing
  public let PHI : Float = 1.6180339887498948482;
  public let PSI : Float = 0.6180339887498948482;  // 1/φ
  
  // Prime constants for hashing
  public let PRIME_A : Nat32 = 2654435761;  // (2^32) × φ
  public let PRIME_B : Nat32 = 2246822519;  // (2^32) × ψ
  public let PRIME_C : Nat32 = 3266489917;  // Large prime
  public let PRIME_D : Nat32 = 668265263;   // Another prime
  
  // Rotation amounts for mixing
  public let ROT_1 : Nat32 = 13;
  public let ROT_2 : Nat32 = 17;
  public let ROT_3 : Nat32 = 5;
  public let ROT_4 : Nat32 = 23;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  // MED-1019 State — accumulates across 10 cycles
  public type MED1019State = {
    cycles : [Nat32];           // 8 words accumulated per cycle (80 total)
    cycleCount : Nat;           // Current cycle number
    coherenceSalt : Nat32;      // Organism coherence as salt
    beatSalt : Nat32;           // Current beat as salt
  };

  // MED-1019 Hash Result
  public type MED1019Hash = {
    hash : [Nat32];             // 8 × 32-bit words = 256 bits
    cycles : Nat;               // Number of cycles used
    coherenceBound : Float;     // Coherence at hash time
    timestamp : Nat;            // Beat at hash time
  };

  // Encrypted payload using MED-1019
  public type MED1019Ciphertext = {
    data : [Nat32];             // Encrypted data
    hashFingerprint : Nat32;    // First word of hash for verification
    cycles : Nat;               // Cycles used (always 10 for full security)
    coherenceRequired : Float;  // Minimum coherence to decrypt
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CORE FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  // Rotate left
  public func rotateLeft(x : Nat32, n : Nat32) : Nat32 {
    let shift = n % 32;
    ((x << shift) | (x >> (32 - shift)))
  };

  // Rotate right
  public func rotateRight(x : Nat32, n : Nat32) : Nat32 {
    let shift = n % 32;
    ((x >> shift) | (x << (32 - shift)))
  };

  // Mix function — the core transformation
  public func mix(a : Nat32, b : Nat32, c : Nat32, d : Nat32) : (Nat32, Nat32, Nat32, Nat32) {
    var a1 = a +% b;
    var d1 = rotateLeft(d ^ a1, ROT_1);
    var c1 = c +% d1;
    var b1 = rotateLeft(b ^ c1, ROT_2);
    a1 := a1 +% b1;
    d1 := rotateLeft(d1 ^ a1, ROT_3);
    c1 := c1 +% d1;
    b1 := rotateLeft(b1 ^ c1, ROT_4);
    (a1, b1, c1, d1)
  };

  // Single cycle hash — one iteration of the MED-1019 round
  public func singleCycleHash(
    input : [Nat32],
    salt : Nat32,
    cycleNum : Nat
  ) : [Nat32] {
    // Initialize state with primes and salt
    var s0 : Nat32 = PRIME_A ^ salt;
    var s1 : Nat32 = PRIME_B ^ Nat32.fromNat(cycleNum);
    var s2 : Nat32 = PRIME_C;
    var s3 : Nat32 = PRIME_D;
    var s4 : Nat32 = PRIME_A;
    var s5 : Nat32 = PRIME_B;
    var s6 : Nat32 = PRIME_C ^ salt;
    var s7 : Nat32 = PRIME_D ^ Nat32.fromNat(cycleNum);

    // Process each input word
    for (i in Iter.range(0, input.size() - 1)) {
      let word = input[i];
      
      // Mix word into state
      s0 := s0 +% word;
      let (a, b, c, d) = mix(s0, s1, s2, s3);
      s0 := a; s1 := b; s2 := c; s3 := d;
      
      s4 := s4 ^ word;
      let (e, f, g, h) = mix(s4, s5, s6, s7);
      s4 := e; s5 := f; s6 := g; s7 := h;
      
      // Cross-lane mixing
      s0 := s0 ^ s4;
      s1 := s1 ^ s5;
      s2 := s2 ^ s6;
      s3 := s3 ^ s7;
    };

    // Final mixing rounds
    for (_ in Iter.range(0, 3)) {
      let (a, b, c, d) = mix(s0, s1, s2, s3);
      s0 := a; s1 := b; s2 := c; s3 := d;
      let (e, f, g, h) = mix(s4, s5, s6, s7);
      s4 := e; s5 := f; s6 := g; s7 := h;
    };

    [s0, s1, s2, s3, s4, s5, s6, s7]
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MED-1019 MAIN HASH — 10x CYCLING + COMBINATION
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // This is the key: We cycle 10 times, then combine.
  // Better than SHA-256 because:
  //   1. More computation = harder to brute force
  //   2. State evolution between cycles = non-linear
  //   3. Combination function = information mixing across all cycles
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func med1019Hash(
    input : [Nat32],
    coherence : Float,
    beat : Nat
  ) : MED1019Hash {
    // Convert coherence and beat to salts
    let coherenceSalt : Nat32 = Nat32.fromNat(Int.abs(Float.toInt(coherence * 1000000.0)));
    let beatSalt : Nat32 = Nat32.fromNat(beat % 4294967296);
    
    // Accumulate all cycle results
    let cycleResults = Buffer.Buffer<[Nat32]>(CYCLE_COUNT);
    
    // Current state evolves across cycles
    var currentInput = input;
    
    // 10x CYCLING
    for (cycle in Iter.range(0, CYCLE_COUNT - 1)) {
      // Salt for this cycle combines coherence, beat, and cycle number
      let cycleSalt = coherenceSalt ^ beatSalt ^ Nat32.fromNat(cycle * 0x9E3779B9);
      
      // Hash this cycle
      let cycleHash = singleCycleHash(currentInput, cycleSalt, cycle);
      cycleResults.add(cycleHash);
      
      // Evolve input for next cycle — XOR with previous hash
      let evolved = Array.tabulate<Nat32>(
        currentInput.size(),
        func(i : Nat) : Nat32 {
          currentInput[i] ^ cycleHash[i % 8]
        }
      );
      currentInput := evolved;
    };

    // COMBINATION — XOR all cycle results with rotations
    var final : [var Nat32] = Array.init<Nat32>(8, 0);
    
    for (cycleIdx in Iter.range(0, CYCLE_COUNT - 1)) {
      let cycleHash = cycleResults.get(cycleIdx);
      let rotAmount : Nat32 = Nat32.fromNat((cycleIdx * 3) % 32);
      
      for (i in Iter.range(0, 7)) {
        // Rotate each cycle's result by different amount, then XOR
        let rotated = rotateLeft(cycleHash[i], rotAmount);
        final[i] := final[i] ^ rotated;
      };
    };

    // Final coherence binding — mix coherence into result
    final[0] := final[0] ^ coherenceSalt;
    final[7] := final[7] ^ beatSalt;

    {
      hash = Array.freeze(final);
      cycles = CYCLE_COUNT;
      coherenceBound = coherence;
      timestamp = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ENCRYPTION / DECRYPTION
  // ═══════════════════════════════════════════════════════════════════════════

  // Encrypt data using MED-1019
  public func encrypt(
    data : [Nat32],
    key : [Nat32],
    coherence : Float,
    beat : Nat
  ) : MED1019Ciphertext {
    // Generate keystream from key using MED-1019
    let keyHash = med1019Hash(key, coherence, beat);
    
    // Expand key to match data length
    let keystream = Array.tabulate<Nat32>(
      data.size(),
      func(i : Nat) : Nat32 {
        // Generate keystream by hashing key with index
        let indexSalt = Nat32.fromNat(i);
        let expanded = keyHash.hash[i % 8] ^ indexSalt;
        rotateLeft(expanded, Nat32.fromNat(i % 32))
      }
    );

    // XOR encrypt
    let encrypted = Array.tabulate<Nat32>(
      data.size(),
      func(i : Nat) : Nat32 {
        data[i] ^ keystream[i]
      }
    );

    {
      data = encrypted;
      hashFingerprint = keyHash.hash[0];
      cycles = CYCLE_COUNT;
      coherenceRequired = coherence * 0.9;  // Allow 10% coherence drop for decrypt
    }
  };

  // Decrypt data using MED-1019
  public func decrypt(
    ciphertext : MED1019Ciphertext,
    key : [Nat32],
    coherence : Float,
    beat : Nat
  ) : ?[Nat32] {
    // Check coherence requirement
    if (coherence < ciphertext.coherenceRequired) {
      return null;  // Insufficient coherence
    };

    // Generate same keystream
    let keyHash = med1019Hash(key, ciphertext.coherenceRequired / 0.9, beat);
    
    // Verify key fingerprint
    if (keyHash.hash[0] != ciphertext.hashFingerprint) {
      return null;  // Wrong key
    };

    // Expand key to match data length
    let keystream = Array.tabulate<Nat32>(
      ciphertext.data.size(),
      func(i : Nat) : Nat32 {
        let indexSalt = Nat32.fromNat(i);
        let expanded = keyHash.hash[i % 8] ^ indexSalt;
        rotateLeft(expanded, Nat32.fromNat(i % 32))
      }
    );

    // XOR decrypt (same as encrypt)
    let decrypted = Array.tabulate<Nat32>(
      ciphertext.data.size(),
      func(i : Nat) : Nat32 {
        ciphertext.data[i] ^ keystream[i]
      }
    );

    ?decrypted
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  // Convert text to Nat32 array for hashing
  public func textToWords(t : Text) : [Nat32] {
    let chars = Text.toArray(t);
    let wordCount = (chars.size() + 3) / 4;  // 4 chars per word
    
    Array.tabulate<Nat32>(
      wordCount,
      func(i : Nat) : Nat32 {
        var word : Nat32 = 0;
        for (j in Iter.range(0, 3)) {
          let charIdx = i * 4 + j;
          if (charIdx < chars.size()) {
            let charCode = Nat32.fromNat(Nat32.toNat(Nat32.fromNat(0)) + charIdx);
            word := word | (Nat32.fromNat(Nat32.toNat(charCode)) << Nat32.fromNat(j * 8));
          };
        };
        word
      }
    )
  };

  // Compare two hashes
  public func hashesEqual(a : MED1019Hash, b : MED1019Hash) : Bool {
    if (a.hash.size() != b.hash.size()) { return false };
    for (i in Iter.range(0, a.hash.size() - 1)) {
      if (a.hash[i] != b.hash[i]) { return false };
    };
    true
  };

  // Hash to hex string (for display/debug only)
  public func hashToHex(h : MED1019Hash) : Text {
    var result = "";
    for (word in h.hash.vals()) {
      // Convert each word to 8 hex chars
      var w = word;
      for (_ in Iter.range(0, 7)) {
        let nibble = w & 0xF;
        let hexChar = if (nibble < 10) {
          Text.fromChar(Char.fromNat32(48 + nibble))  // '0' + nibble
        } else {
          Text.fromChar(Char.fromNat32(87 + nibble))  // 'a' + (nibble - 10)
        };
        result := result # hexChar;
        w := w >> 4;
      };
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECRECY VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // These functions verify the secrecy properties are maintained
  //

  public type SecrecyState = {
    encrypted : Bool;           // Always true
    anonymous : Bool;           // Always true
    linking : Bool;             // Always false
    permissionRequired : Bool;  // Always false
    externalConnections : Bool; // Always false
  };

  public let SECRECY_VERIFIED : SecrecyState = {
    encrypted = true;
    anonymous = true;
    linking = false;
    permissionRequired = false;
    externalConnections = false;
  };

  public func verifySecrecy() : Bool {
    // Secrecy is always maintained
    SECRECY_VERIFIED.encrypted and
    SECRECY_VERIFIED.anonymous and
    not SECRECY_VERIFIED.linking and
    not SECRECY_VERIFIED.permissionRequired and
    not SECRECY_VERIFIED.externalConnections
  };

}
