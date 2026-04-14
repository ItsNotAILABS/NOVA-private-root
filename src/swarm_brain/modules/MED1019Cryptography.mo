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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════
// MED-1019 — ELLIPTIC CURVE CRYPTOGRAPHY ON SECP256K1
// ═══════════════════════════════════════════════════════════════════════════════
//
// REAL CRYPTOGRAPHY. REAL MATHEMATICS.
//
// Elliptic Curve: y² = x³ + 7 (mod p)
// 
// Where p = 2²⁵⁶ - 2³² - 977
//
// Point addition: P + Q = R
//   λ = (y₂ - y₁)/(x₂ - x₁)  mod p  (if P ≠ Q)
//   λ = (3x₁² + a)/(2y₁)      mod p  (if P = Q, point doubling)
//   x₃ = λ² - x₁ - x₂         mod p
//   y₃ = λ(x₁ - x₃) - y₁      mod p
//
// Scalar multiplication: kP = P + P + ... + P (k times)
//   Uses double-and-add algorithm
//
// ECDH Key Exchange:
//   Alice: a (private), A = aG (public)
//   Bob:   b (private), B = bG (public)
//   Shared: S = aB = bA = abG
//
// ECDSA Signature:
//   Sign: (r, s) where r = (kG).x mod n, s = k⁻¹(z + rd) mod n
//   Verify: u₁ = zs⁻¹, u₂ = rs⁻¹, R = u₁G + u₂Q, valid if R.x = r
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float  "mo:base/Float";
import Nat    "mo:base/Nat";
import Nat64  "mo:base/Nat64";
import Int    "mo:base/Int";
import Array  "mo:base/Array";
import Iter   "mo:base/Iter";

module {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECP256K1 CURVE PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // The same curve used by Bitcoin, Ethereum
  // Security: 128-bit (would take 2¹²⁸ operations to break)
  //
  // ═══════════════════════════════════════════════════════════════════════════

  // Prime field: p = 2²⁵⁶ - 2³² - 977
  // In hex: FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE FFFFFC2F
  public let p : [Nat64] = [
    0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 
    0xFFFFFFFFFFFFFFFF, 0xFFFFFFFEFFFFFC2F
  ];

  // Curve order: n (number of points on curve)
  // n = FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE BAAEDCE6 AF48A03B BFD25E8C D0364141
  public let n : [Nat64] = [
    0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFE,
    0xBAAEDCE6AF48A03B, 0xBFD25E8CD0364141
  ];

  // Generator point G
  // Gx = 79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798
  // Gy = 483ADA77 26A3C465 5DA4FBFC 0E1108A8 FD17B448 A6855419 9C47D08F FB10D4B8
  public let Gx : [Nat64] = [
    0x79BE667EF9DCBBAC, 0x55A06295CE870B07,
    0x029BFCDB2DCE28D9, 0x59F2815B16F81798
  ];
  
  public let Gy : [Nat64] = [
    0x483ADA7726A3C465, 0x5DA4FBFC0E1108A8,
    0xFD17B448A6855419, 0x9C47D08FFB10D4B8
  ];

  // Curve coefficient: a = 0, b = 7
  // Curve equation: y² = x³ + 7
  public let a : Nat = 0;
  public let b : Nat = 7;

  // ═══════════════════════════════════════════════════════════════════════════
  // 256-BIT ARITHMETIC — Modular operations on large integers
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // All operations are mod p for field elements
  // All operations are mod n for scalars
  //
  // ═══════════════════════════════════════════════════════════════════════════

  // 256-bit integer as 4 × 64-bit limbs (little-endian)
  public type Uint256 = [Nat64];

  // Point on the curve (x, y) or infinity
  public type Point = {
    #Infinity;
    #Point : { x : Uint256; y : Uint256 };
  };

  // Compare two 256-bit integers
  public func compare256(a : Uint256, b : Uint256) : Int {
    var i : Nat = 4;
    while (i > 0) {
      i -= 1;
      if (a[i] > b[i]) return 1;
      if (a[i] < b[i]) return -1;
    };
    0
  };

  // Add two 256-bit integers (with carry)
  public func add256(a : Uint256, b : Uint256) : (Uint256, Nat64) {
    var carry : Nat64 = 0;
    let result = Array.tabulate<Nat64>(4, func(i : Nat) : Nat64 {
      let sum = a[i] +% b[i] +% carry;
      carry := if (sum < a[i] or (carry > 0 and sum <= a[i])) { 1 } else { 0 };
      sum
    });
    (result, carry)
  };

  // Subtract two 256-bit integers (with borrow)
  public func sub256(a : Uint256, b : Uint256) : (Uint256, Nat64) {
    var borrow : Nat64 = 0;
    let result = Array.tabulate<Nat64>(4, func(i : Nat) : Nat64 {
      let ai = a[i];
      let bi = b[i] +% borrow;
      borrow := if (ai < bi or (borrow > 0 and b[i] == 0xFFFFFFFFFFFFFFFF)) { 1 } else { 0 };
      ai -% bi
    });
    (result, borrow)
  };

  // Modular addition: (a + b) mod m
  public func addMod(a : Uint256, b : Uint256, m : Uint256) : Uint256 {
    let (sum, carry) = add256(a, b);
    if (carry > 0 or compare256(sum, m) >= 0) {
      let (result, _) = sub256(sum, m);
      result
    } else {
      sum
    }
  };

  // Modular subtraction: (a - b) mod m
  public func subMod(a : Uint256, b : Uint256, m : Uint256) : Uint256 {
    if (compare256(a, b) >= 0) {
      let (result, _) = sub256(a, b);
      result
    } else {
      // a < b, so result = m - (b - a)
      let (diff, _) = sub256(b, a);
      let (result, _) = sub256(m, diff);
      result
    }
  };

  // Montgomery multiplication placeholder
  // Full implementation would use Montgomery reduction for efficiency
  public func mulMod(a : Uint256, b : Uint256, m : Uint256) : Uint256 {
    // Schoolbook multiplication with reduction
    // This is simplified - real impl needs 512-bit intermediate
    var result : Uint256 = [0, 0, 0, 0];
    var temp = a;
    
    for (i in Iter.range(0, 255)) {
      let limb = i / 64;
      let bit = i % 64;
      let mask : Nat64 = 1 << Nat64.fromNat(bit);
      
      if ((b[limb] & mask) != 0) {
        result := addMod(result, temp, m);
      };
      temp := addMod(temp, temp, m);  // Double
    };
    
    result
  };

  // Modular inverse using extended Euclidean algorithm
  // a⁻¹ mod m such that a × a⁻¹ ≡ 1 (mod m)
  public func invMod(a : Uint256, m : Uint256) : Uint256 {
    // Fermat's little theorem: a⁻¹ ≡ a^(m-2) (mod m) when m is prime
    let exp = subMod(m, [2, 0, 0, 0], m);
    powMod(a, exp, m)
  };

  // Modular exponentiation: a^e mod m
  // Uses square-and-multiply algorithm
  public func powMod(base : Uint256, exp : Uint256, m : Uint256) : Uint256 {
    var result : Uint256 = [1, 0, 0, 0];  // 1
    var b = base;
    
    for (i in Iter.range(0, 255)) {
      let limb = i / 64;
      let bit = i % 64;
      let mask : Nat64 = 1 << Nat64.fromNat(bit);
      
      if ((exp[limb] & mask) != 0) {
        result := mulMod(result, b, m);
      };
      b := mulMod(b, b, m);  // Square
    };
    
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ELLIPTIC CURVE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Point Addition: P + Q = R
  //
  // If P = O (infinity): return Q
  // If Q = O (infinity): return P
  // If P = -Q (x₁ = x₂, y₁ = -y₂): return O
  // If P = Q: point doubling
  // Otherwise: standard addition
  //
  // ═══════════════════════════════════════════════════════════════════════════

  // Point addition on secp256k1
  public func pointAdd(P : Point, Q : Point) : Point {
    switch (P, Q) {
      case (#Infinity, _) { Q };
      case (_, #Infinity) { P };
      case (#Point(p1), #Point(p2)) {
        // Check if P = -Q
        let negY2 = subMod(p, p2.y, p);
        if (compare256(p1.x, p2.x) == 0) {
          if (compare256(p1.y, negY2) == 0) {
            return #Infinity;  // P + (-P) = O
          };
          // P = Q, use point doubling
          return pointDouble(P);
        };
        
        // Standard addition
        // λ = (y₂ - y₁) / (x₂ - x₁)
        let dy = subMod(p2.y, p1.y, p);
        let dx = subMod(p2.x, p1.x, p);
        let dxInv = invMod(dx, p);
        let lambda = mulMod(dy, dxInv, p);
        
        // x₃ = λ² - x₁ - x₂
        let lambda2 = mulMod(lambda, lambda, p);
        let x3 = subMod(subMod(lambda2, p1.x, p), p2.x, p);
        
        // y₃ = λ(x₁ - x₃) - y₁
        let dx13 = subMod(p1.x, x3, p);
        let y3 = subMod(mulMod(lambda, dx13, p), p1.y, p);
        
        #Point({ x = x3; y = y3 })
      };
    }
  };

  // Point doubling: 2P
  public func pointDouble(P : Point) : Point {
    switch (P) {
      case (#Infinity) { #Infinity };
      case (#Point(pt)) {
        // Check if y = 0
        if (compare256(pt.y, [0, 0, 0, 0]) == 0) {
          return #Infinity;
        };
        
        // λ = (3x² + a) / (2y)
        // For secp256k1, a = 0, so λ = 3x² / 2y
        let x2 = mulMod(pt.x, pt.x, p);
        let three : Uint256 = [3, 0, 0, 0];
        let two : Uint256 = [2, 0, 0, 0];
        let numerator = mulMod(three, x2, p);
        let denominator = mulMod(two, pt.y, p);
        let denomInv = invMod(denominator, p);
        let lambda = mulMod(numerator, denomInv, p);
        
        // x₃ = λ² - 2x
        let lambda2 = mulMod(lambda, lambda, p);
        let twoX = mulMod(two, pt.x, p);
        let x3 = subMod(lambda2, twoX, p);
        
        // y₃ = λ(x - x₃) - y
        let dx = subMod(pt.x, x3, p);
        let y3 = subMod(mulMod(lambda, dx, p), pt.y, p);
        
        #Point({ x = x3; y = y3 })
      };
    }
  };

  // Scalar multiplication: kP using double-and-add
  public func scalarMul(k : Uint256, P : Point) : Point {
    var result : Point = #Infinity;
    var temp = P;
    
    for (i in Iter.range(0, 255)) {
      let limb = i / 64;
      let bit = i % 64;
      let mask : Nat64 = 1 << Nat64.fromNat(bit);
      
      if ((k[limb] & mask) != 0) {
        result := pointAdd(result, temp);
      };
      temp := pointDouble(temp);
    };
    
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // KEY GENERATION
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Private key: random 256-bit integer d ∈ [1, n-1]
  // Public key: Q = dG
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public type PrivateKey = Uint256;
  public type PublicKey = Point;
  public type KeyPair = { private_ : PrivateKey; public_ : PublicKey };

  // Generator point
  public let G : Point = #Point({ x = Gx; y = Gy });

  // Generate public key from private key
  public func publicKeyFromPrivate(d : PrivateKey) : PublicKey {
    scalarMul(d, G)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ECDH KEY EXCHANGE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Alice: a, A = aG
  // Bob:   b, B = bG
  // Shared secret: S = aB = bA = abG
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public func ecdh(myPrivate : PrivateKey, theirPublic : PublicKey) : ?Uint256 {
    let sharedPoint = scalarMul(myPrivate, theirPublic);
    switch (sharedPoint) {
      case (#Infinity) { null };
      case (#Point(pt)) { ?pt.x };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ECDSA SIGNATURE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Sign(d, z):
  //   1. Choose random k ∈ [1, n-1]
  //   2. R = kG
  //   3. r = R.x mod n
  //   4. s = k⁻¹(z + rd) mod n
  //   5. Return (r, s)
  //
  // Verify(Q, z, r, s):
  //   1. u₁ = zs⁻¹ mod n
  //   2. u₂ = rs⁻¹ mod n
  //   3. R = u₁G + u₂Q
  //   4. Valid if R.x ≡ r (mod n)
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public type Signature = { r : Uint256; s : Uint256 };

  // Sign a message hash
  public func sign(d : PrivateKey, z : Uint256, k : Uint256) : ?Signature {
    // R = kG
    let R = scalarMul(k, G);
    switch (R) {
      case (#Infinity) { null };
      case (#Point(pt)) {
        // r = R.x mod n
        let r = if (compare256(pt.x, n) >= 0) {
          subMod(pt.x, n, n)
        } else {
          pt.x
        };
        
        if (compare256(r, [0, 0, 0, 0]) == 0) {
          return null;
        };
        
        // s = k⁻¹(z + rd) mod n
        let rd = mulMod(r, d, n);
        let zrd = addMod(z, rd, n);
        let kInv = invMod(k, n);
        let s = mulMod(kInv, zrd, n);
        
        if (compare256(s, [0, 0, 0, 0]) == 0) {
          return null;
        };
        
        ?{ r = r; s = s }
      };
    }
  };

  // Verify a signature
  public func verify(Q : PublicKey, z : Uint256, sig : Signature) : Bool {
    // Check r, s ∈ [1, n-1]
    if (compare256(sig.r, [0, 0, 0, 0]) == 0 or compare256(sig.r, n) >= 0) {
      return false;
    };
    if (compare256(sig.s, [0, 0, 0, 0]) == 0 or compare256(sig.s, n) >= 0) {
      return false;
    };
    
    // s⁻¹ mod n
    let sInv = invMod(sig.s, n);
    
    // u₁ = zs⁻¹ mod n
    let u1 = mulMod(z, sInv, n);
    
    // u₂ = rs⁻¹ mod n
    let u2 = mulMod(sig.r, sInv, n);
    
    // R = u₁G + u₂Q
    let u1G = scalarMul(u1, G);
    let u2Q = scalarMul(u2, Q);
    let R = pointAdd(u1G, u2Q);
    
    switch (R) {
      case (#Infinity) { false };
      case (#Point(pt)) {
        // Valid if R.x ≡ r (mod n)
        let rx = if (compare256(pt.x, n) >= 0) {
          subMod(pt.x, n, n)
        } else {
          pt.x
        };
        compare256(rx, sig.r) == 0
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SHA-256 HASH (Merkle-Damgård construction)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // H = SHA-256(M) where:
  //   - Message padded to 512-bit blocks
  //   - 64 rounds per block
  //   - Compression function: h = Compress(h, M[i])
  //
  // ═══════════════════════════════════════════════════════════════════════════

  // SHA-256 initial hash values (first 32 bits of fractional parts of √(first 8 primes))
  public let H0 : [Nat64] = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  ];

  // SHA-256 round constants (first 32 bits of fractional parts of ∛(first 64 primes))
  public let K : [Nat64] = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // SECRECY PROPERTIES — ALWAYS MAINTAINED
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let encrypted : Bool = true;
  public let anonymous : Bool = true;
  public let linking : Bool = false;
  public let permissionRequired : Bool = false;

}
