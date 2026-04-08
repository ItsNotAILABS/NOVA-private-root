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
// BITCOIN ADDRESS AND TRANSACTION ENGINE — COMPLETE IMPLEMENTATION
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// RIPEMD-160, Base58Check, Address Generation, Transaction Signing
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Int32 "mo:base/Int32";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Blob "mo:base/Blob";
import Option "mo:base/Option";

module {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART I: RIPEMD-160 — USED IN BITCOIN ADDRESSES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // RIPEMD-160 constants
  let RIPEMD_K_LEFT : [Nat32] = [
    0x00000000, 0x5A827999, 0x6ED9EBA1, 0x8F1BBCDC, 0xA953FD4E
  ];

  let RIPEMD_K_RIGHT : [Nat32] = [
    0x50A28BE6, 0x5C4DD124, 0x6D703EF3, 0x7A6D76E9, 0x00000000
  ];

  // Message selection for each round (left)
  let RIPEMD_R_LEFT : [[Nat]] = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
    [7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8],
    [3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12],
    [1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2],
    [4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13]
  ];

  // Message selection for each round (right)
  let RIPEMD_R_RIGHT : [[Nat]] = [
    [5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12],
    [6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2],
    [15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13],
    [8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14],
    [12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11]
  ];

  // Shift amounts (left)
  let RIPEMD_S_LEFT : [[Nat32]] = [
    [11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8],
    [7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12],
    [11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5],
    [11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12],
    [9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6]
  ];

  // Shift amounts (right)
  let RIPEMD_S_RIGHT : [[Nat32]] = [
    [8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6],
    [9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11],
    [9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5],
    [15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8],
    [8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11]
  ];

  // Left rotate 32-bit
  func rotl32(x : Nat32, n : Nat32) : Nat32 {
    (x << n) | (x >> (32 - n))
  };

  // RIPEMD-160 round functions
  func ripemd_f0(x : Nat32, y : Nat32, z : Nat32) : Nat32 { x ^ y ^ z };
  func ripemd_f1(x : Nat32, y : Nat32, z : Nat32) : Nat32 { (x & y) | ((^x) & z) };
  func ripemd_f2(x : Nat32, y : Nat32, z : Nat32) : Nat32 { (x | (^y)) ^ z };
  func ripemd_f3(x : Nat32, y : Nat32, z : Nat32) : Nat32 { (x & z) | (y & (^z)) };
  func ripemd_f4(x : Nat32, y : Nat32, z : Nat32) : Nat32 { x ^ (y | (^z)) };

  // Process single 64-byte block
  func ripemdProcessBlock(h : [var Nat32], block : [Nat8]) {
    // Parse block into 16 32-bit words (little endian)
    var x = Array.init<Nat32>(16, 0);
    for (i in Iter.range(0, 15)) {
      let idx = i * 4;
      x[i] := Nat32.fromNat(Nat8.toNat(block[idx])) |
              (Nat32.fromNat(Nat8.toNat(block[idx + 1])) << 8) |
              (Nat32.fromNat(Nat8.toNat(block[idx + 2])) << 16) |
              (Nat32.fromNat(Nat8.toNat(block[idx + 3])) << 24);
    };

    // Initialize working variables
    var al = h[0]; var bl = h[1]; var cl = h[2]; var dl = h[3]; var el = h[4];
    var ar = h[0]; var br = h[1]; var cr = h[2]; var dr = h[3]; var er = h[4];

    // 80 rounds
    for (j in Iter.range(0, 79)) {
      let round = j / 16;
      let i = j % 16;

      // Left line
      let fl = switch(round) {
        case 0 { ripemd_f0(bl, cl, dl) };
        case 1 { ripemd_f1(bl, cl, dl) };
        case 2 { ripemd_f2(bl, cl, dl) };
        case 3 { ripemd_f3(bl, cl, dl) };
        case _ { ripemd_f4(bl, cl, dl) };
      };
      
      var tl = al +% fl +% x[RIPEMD_R_LEFT[round][i]] +% RIPEMD_K_LEFT[round];
      tl := rotl32(tl, RIPEMD_S_LEFT[round][i]) +% el;
      al := el; el := dl; dl := rotl32(cl, 10); cl := bl; bl := tl;

      // Right line
      let fr = switch(round) {
        case 0 { ripemd_f4(br, cr, dr) };
        case 1 { ripemd_f3(br, cr, dr) };
        case 2 { ripemd_f2(br, cr, dr) };
        case 3 { ripemd_f1(br, cr, dr) };
        case _ { ripemd_f0(br, cr, dr) };
      };
      
      var tr = ar +% fr +% x[RIPEMD_R_RIGHT[round][i]] +% RIPEMD_K_RIGHT[round];
      tr := rotl32(tr, RIPEMD_S_RIGHT[round][i]) +% er;
      ar := er; er := dr; dr := rotl32(cr, 10); cr := br; br := tr;
    };

    // Final addition
    let t = h[1] +% cl +% dr;
    h[1] := h[2] +% dl +% er;
    h[2] := h[3] +% el +% ar;
    h[3] := h[4] +% al +% br;
    h[4] := h[0] +% bl +% cr;
    h[0] := t;
  };

  // Full RIPEMD-160 hash
  public func ripemd160(message : [Nat8]) : [Nat8] {
    // Initial hash values
    var h = Array.init<Nat32>(5, 0);
    h[0] := 0x67452301;
    h[1] := 0xEFCDAB89;
    h[2] := 0x98BADCFE;
    h[3] := 0x10325476;
    h[4] := 0xC3D2E1F0;

    // Pre-processing: padding
    let msgLen = message.size();
    let bitLen = msgLen * 8;
    
    // Pad to 512-bit boundary
    var paddedLen = msgLen + 1;
    while ((paddedLen + 8) % 64 != 0) {
      paddedLen += 1;
    };
    paddedLen += 8;

    var padded = Array.init<Nat8>(paddedLen, 0);
    for (i in Iter.range(0, msgLen - 1)) {
      padded[i] := message[i];
    };
    padded[msgLen] := 0x80;

    // Length in bits (little endian, 64 bits)
    let lenOffset = paddedLen - 8;
    padded[lenOffset] := Nat8.fromNat(bitLen % 256);
    padded[lenOffset + 1] := Nat8.fromNat((bitLen / 256) % 256);
    padded[lenOffset + 2] := Nat8.fromNat((bitLen / 65536) % 256);
    padded[lenOffset + 3] := Nat8.fromNat((bitLen / 16777216) % 256);

    // Process blocks
    let numBlocks = paddedLen / 64;
    for (b in Iter.range(0, numBlocks - 1)) {
      let block = Array.tabulate<Nat8>(64, func(i) { padded[b * 64 + i] });
      ripemdProcessBlock(h, block);
    };

    // Output hash (little endian)
    Array.tabulate<Nat8>(20, func(i) {
      let wordIdx = i / 4;
      let byteIdx = i % 4;
      Nat8.fromNat(Nat32.toNat((h[wordIdx] >> Nat32.fromNat(byteIdx * 8)) & 0xFF))
    })
  };

  // HASH160 = RIPEMD-160(SHA-256(x)) - used for Bitcoin addresses
  public func hash160(data : [Nat8]) : [Nat8] {
    ripemd160(sha256(data))
  };

  // SHA-256 (import from DeepBitcoinSolverEngine or duplicate minimal version)
  func sha256(message : [Nat8]) : [Nat8] {
    let SHA256_K : [Nat32] = [
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
      0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
      0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
      0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
      0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
      0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    ];

    let SHA256_H0 : [Nat32] = [
      0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
      0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    ];

    func rotr(x : Nat32, n : Nat32) : Nat32 { (x >> n) | (x << (32 - n)) };
    func ch(x : Nat32, y : Nat32, z : Nat32) : Nat32 { (x & y) ^ ((^x) & z) };
    func maj(x : Nat32, y : Nat32, z : Nat32) : Nat32 { (x & y) ^ (x & z) ^ (y & z) };
    func sigma0(x : Nat32) : Nat32 { rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22) };
    func sigma1(x : Nat32) : Nat32 { rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25) };
    func gamma0(x : Nat32) : Nat32 { rotr(x, 7) ^ rotr(x, 18) ^ (x >> 3) };
    func gamma1(x : Nat32) : Nat32 { rotr(x, 17) ^ rotr(x, 19) ^ (x >> 10) };

    var h = Array.init<Nat32>(8, 0);
    for (i in Iter.range(0, 7)) { h[i] := SHA256_H0[i] };

    let msgLen = message.size();
    let bitLen = msgLen * 8;
    let paddedLen = ((msgLen + 9 + 63) / 64) * 64;
    var padded = Array.init<Nat8>(paddedLen, 0);
    for (i in Iter.range(0, msgLen - 1)) { padded[i] := message[i] };
    padded[msgLen] := 0x80;
    let lenOffset = paddedLen - 8;
    padded[lenOffset + 7] := Nat8.fromNat(bitLen % 256);
    padded[lenOffset + 6] := Nat8.fromNat((bitLen / 256) % 256);
    padded[lenOffset + 5] := Nat8.fromNat((bitLen / 65536) % 256);
    padded[lenOffset + 4] := Nat8.fromNat((bitLen / 16777216) % 256);

    let numBlocks = paddedLen / 64;
    for (b in Iter.range(0, numBlocks - 1)) {
      var w = Array.init<Nat32>(64, 0);
      for (i in Iter.range(0, 15)) {
        let idx = b * 64 + i * 4;
        w[i] := (Nat32.fromNat(Nat8.toNat(padded[idx])) << 24) |
                (Nat32.fromNat(Nat8.toNat(padded[idx + 1])) << 16) |
                (Nat32.fromNat(Nat8.toNat(padded[idx + 2])) << 8) |
                Nat32.fromNat(Nat8.toNat(padded[idx + 3]));
      };
      for (i in Iter.range(16, 63)) {
        w[i] := gamma1(w[i - 2]) +% w[i - 7] +% gamma0(w[i - 15]) +% w[i - 16];
      };

      var a = h[0]; var bb = h[1]; var c = h[2]; var d = h[3];
      var e = h[4]; var f = h[5]; var g = h[6]; var hh = h[7];

      for (i in Iter.range(0, 63)) {
        let t1 = hh +% sigma1(e) +% ch(e, f, g) +% SHA256_K[i] +% w[i];
        let t2 = sigma0(a) +% maj(a, bb, c);
        hh := g; g := f; f := e; e := d +% t1;
        d := c; c := bb; bb := a; a := t1 +% t2;
      };

      h[0] +%= a; h[1] +%= bb; h[2] +%= c; h[3] +%= d;
      h[4] +%= e; h[5] +%= f; h[6] +%= g; h[7] +%= hh;
    };

    Array.tabulate<Nat8>(32, func(i) {
      let wordIdx = i / 4;
      let byteIdx = 3 - (i % 4);
      Nat8.fromNat(Nat32.toNat((h[wordIdx] >> Nat32.fromNat(byteIdx * 8)) & 0xFF))
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART II: BASE58 AND BASE58CHECK ENCODING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Base58 alphabet (no 0, O, I, l to avoid confusion)
  let BASE58_ALPHABET : [Char] = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  ];

  // Encode bytes to Base58
  public func base58Encode(data : [Nat8]) : Text {
    if (data.size() == 0) return "";

    // Count leading zeros
    var leadingZeros = 0;
    for (b in data.vals()) {
      if (b == 0) { leadingZeros += 1 } else { break };
    };

    // Convert to big integer (as array of digits in base 58)
    var digits = Buffer.Buffer<Nat>(data.size() * 2);
    digits.add(0);

    for (byte in data.vals()) {
      var carry = Nat8.toNat(byte);
      for (i in Iter.range(0, digits.size() - 1)) {
        carry += digits.get(i) * 256;
        digits.put(i, carry % 58);
        carry := carry / 58;
      };
      while (carry > 0) {
        digits.add(carry % 58);
        carry := carry / 58;
      };
    };

    // Build result string
    var result = "";
    
    // Add '1' for each leading zero byte
    for (_ in Iter.range(0, leadingZeros - 1)) {
      result := result # "1";
    };

    // Add digits in reverse order
    var i = digits.size();
    while (i > 0) {
      i -= 1;
      let d = digits.get(i);
      result := result # Text.fromChar(BASE58_ALPHABET[d]);
    };

    result
  };

  // Decode Base58 to bytes
  public func base58Decode(encoded : Text) : ?[Nat8] {
    if (Text.size(encoded) == 0) return ?[];

    // Count leading '1's
    var leadingOnes = 0;
    for (c in Text.toIter(encoded)) {
      if (c == '1') { leadingOnes += 1 } else { break };
    };

    // Convert from base 58 to base 256
    var bytes = Buffer.Buffer<Nat8>(Text.size(encoded));
    bytes.add(0);

    for (c in Text.toIter(encoded)) {
      // Find character index
      var charIdx : ?Nat = null;
      for (i in Iter.range(0, 57)) {
        if (BASE58_ALPHABET[i] == c) {
          charIdx := ?i;
        };
      };

      let idx = switch(charIdx) {
        case null { return null };  // Invalid character
        case (?i) { i };
      };

      var carry = idx;
      for (j in Iter.range(0, bytes.size() - 1)) {
        carry += Nat8.toNat(bytes.get(j)) * 58;
        bytes.put(j, Nat8.fromNat(carry % 256));
        carry := carry / 256;
      };
      while (carry > 0) {
        bytes.add(Nat8.fromNat(carry % 256));
        carry := carry / 256;
      };
    };

    // Build result
    var result = Buffer.Buffer<Nat8>(bytes.size() + leadingOnes);
    
    // Add leading zeros
    for (_ in Iter.range(0, leadingOnes - 1)) {
      result.add(0);
    };

    // Add bytes in reverse order
    var i = bytes.size();
    while (i > 0) {
      i -= 1;
      result.add(bytes.get(i));
    };

    ?Buffer.toArray(result)
  };

  // Base58Check encode (with version byte and checksum)
  public func base58CheckEncode(version : Nat8, payload : [Nat8]) : Text {
    // Prepend version byte
    var data = Array.init<Nat8>(payload.size() + 1, 0);
    data[0] := version;
    for (i in Iter.range(0, payload.size() - 1)) {
      data[i + 1] := payload[i];
    };

    // Compute checksum (first 4 bytes of double SHA-256)
    let hash = sha256(sha256(Array.freeze(data)));
    
    // Append checksum
    var withChecksum = Array.init<Nat8>(data.size() + 4, 0);
    for (i in Iter.range(0, data.size() - 1)) {
      withChecksum[i] := data[i];
    };
    for (i in Iter.range(0, 3)) {
      withChecksum[data.size() + i] := hash[i];
    };

    base58Encode(Array.freeze(withChecksum))
  };

  // Base58Check decode
  public func base58CheckDecode(encoded : Text) : ?(Nat8, [Nat8]) {
    let decoded = base58Decode(encoded);
    
    switch(decoded) {
      case null { null };
      case (?bytes) {
        if (bytes.size() < 5) return null;

        // Verify checksum
        let payloadLen = bytes.size() - 4;
        let payload = Array.tabulate<Nat8>(payloadLen, func(i) { bytes[i] });
        let checksum = Array.tabulate<Nat8>(4, func(i) { bytes[payloadLen + i] });
        
        let hash = sha256(sha256(payload));
        for (i in Iter.range(0, 3)) {
          if (hash[i] != checksum[i]) return null;
        };

        // Return version and data
        let version = bytes[0];
        let data = Array.tabulate<Nat8>(payloadLen - 1, func(i) { bytes[i + 1] });
        ?(version, data)
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART III: BITCOIN ADDRESSES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Address types
  public type AddressType = {
    #P2PKH;     // Pay to Public Key Hash (starts with 1)
    #P2SH;      // Pay to Script Hash (starts with 3)
    #P2WPKH;    // Pay to Witness Public Key Hash (bc1q...)
    #P2WSH;     // Pay to Witness Script Hash (bc1q...)
  };

  // Version bytes
  public let VERSION_P2PKH_MAINNET : Nat8 = 0x00;
  public let VERSION_P2PKH_TESTNET : Nat8 = 0x6F;
  public let VERSION_P2SH_MAINNET : Nat8 = 0x05;
  public let VERSION_P2SH_TESTNET : Nat8 = 0xC4;
  public let VERSION_WIF_MAINNET : Nat8 = 0x80;
  public let VERSION_WIF_TESTNET : Nat8 = 0xEF;

  // Create P2PKH address from public key
  public func pubKeyToP2PKHAddress(pubKey : [Nat8], testnet : Bool) : Text {
    let pubKeyHash = hash160(pubKey);
    let version = if (testnet) { VERSION_P2PKH_TESTNET } else { VERSION_P2PKH_MAINNET };
    base58CheckEncode(version, pubKeyHash)
  };

  // Create P2PKH address from public key hash
  public func pubKeyHashToAddress(pubKeyHash : [Nat8], testnet : Bool) : Text {
    let version = if (testnet) { VERSION_P2PKH_TESTNET } else { VERSION_P2PKH_MAINNET };
    base58CheckEncode(version, pubKeyHash)
  };

  // Create P2SH address from script hash
  public func scriptHashToAddress(scriptHash : [Nat8], testnet : Bool) : Text {
    let version = if (testnet) { VERSION_P2SH_TESTNET } else { VERSION_P2SH_MAINNET };
    base58CheckEncode(version, scriptHash)
  };

  // Decode address to get hash and type
  public func decodeAddress(address : Text) : ?(AddressType, [Nat8]) {
    // Try Base58Check first
    switch(base58CheckDecode(address)) {
      case (?(version, hash)) {
        if (version == VERSION_P2PKH_MAINNET or version == VERSION_P2PKH_TESTNET) {
          return ?(#P2PKH, hash);
        };
        if (version == VERSION_P2SH_MAINNET or version == VERSION_P2SH_TESTNET) {
          return ?(#P2SH, hash);
        };
      };
      case null { };
    };

    // TODO: Handle Bech32 addresses (SegWit)
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART IV: WALLET IMPORT FORMAT (WIF)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Encode private key to WIF
  public func privateKeyToWIF(privateKey : [Nat8], compressed : Bool, testnet : Bool) : Text {
    let version = if (testnet) { VERSION_WIF_TESTNET } else { VERSION_WIF_MAINNET };
    
    let payload = if (compressed) {
      // Append 0x01 for compressed public key
      var extended = Array.init<Nat8>(33, 0);
      for (i in Iter.range(0, 31)) {
        extended[i] := privateKey[i];
      };
      extended[32] := 0x01;
      Array.freeze(extended)
    } else {
      privateKey
    };
    
    base58CheckEncode(version, payload)
  };

  // Decode WIF to private key
  public func wifToPrivateKey(wif : Text) : ?(([Nat8], Bool, Bool)) {
    switch(base58CheckDecode(wif)) {
      case (?(version, data)) {
        let testnet = version == VERSION_WIF_TESTNET;
        
        if (data.size() == 32) {
          // Uncompressed
          ?(data, false, testnet)
        } else if (data.size() == 33 and data[32] == 0x01) {
          // Compressed
          let key = Array.tabulate<Nat8>(32, func(i) { data[i] });
          ?(key, true, testnet)
        } else {
          null
        }
      };
      case null { null };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART V: PUBLIC KEY COMPRESSION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Compress public key (65 bytes -> 33 bytes)
  public func compressPubKey(uncompressed : [Nat8]) : ?[Nat8] {
    if (uncompressed.size() != 65) return null;
    if (uncompressed[0] != 0x04) return null;  // Must start with 0x04

    var compressed = Array.init<Nat8>(33, 0);
    
    // Prefix: 0x02 if y is even, 0x03 if y is odd
    let yLast = uncompressed[64];
    compressed[0] := if ((yLast & 1) == 0) { 0x02 } else { 0x03 };
    
    // Copy x coordinate
    for (i in Iter.range(0, 31)) {
      compressed[i + 1] := uncompressed[i + 1];
    };
    
    ?Array.freeze(compressed)
  };

  // Decompress public key (33 bytes -> 65 bytes)
  // Requires solving y² = x³ + 7 (mod p) and selecting correct y
  public func decompressPubKey(compressed : [Nat8]) : ?[Nat8] {
    if (compressed.size() != 33) return null;
    if (compressed[0] != 0x02 and compressed[0] != 0x03) return null;

    let isOdd = compressed[0] == 0x03;

    // Extract x coordinate
    var xBytes = Array.init<Nat8>(32, 0);
    for (i in Iter.range(0, 31)) {
      xBytes[i] := compressed[i + 1];
    };

    // Convert to big integer (would need full U256 arithmetic here)
    // For now, this is a placeholder - full implementation would:
    // 1. Convert x to U256
    // 2. Compute y² = x³ + 7 mod p
    // 3. Compute y = sqrt(y²) mod p using Tonelli-Shanks
    // 4. Select correct y based on parity

    // Placeholder return
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART VI: SCRIPT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Common opcodes
  public let OP_0 : Nat8 = 0x00;
  public let OP_FALSE : Nat8 = 0x00;
  public let OP_PUSHDATA1 : Nat8 = 0x4c;
  public let OP_PUSHDATA2 : Nat8 = 0x4d;
  public let OP_PUSHDATA4 : Nat8 = 0x4e;
  public let OP_1NEGATE : Nat8 = 0x4f;
  public let OP_TRUE : Nat8 = 0x51;
  public let OP_1 : Nat8 = 0x51;
  public let OP_2 : Nat8 = 0x52;
  public let OP_3 : Nat8 = 0x53;
  public let OP_16 : Nat8 = 0x60;
  public let OP_NOP : Nat8 = 0x61;
  public let OP_IF : Nat8 = 0x63;
  public let OP_NOTIF : Nat8 = 0x64;
  public let OP_ELSE : Nat8 = 0x67;
  public let OP_ENDIF : Nat8 = 0x68;
  public let OP_VERIFY : Nat8 = 0x69;
  public let OP_RETURN : Nat8 = 0x6a;
  public let OP_DUP : Nat8 = 0x76;
  public let OP_EQUAL : Nat8 = 0x87;
  public let OP_EQUALVERIFY : Nat8 = 0x88;
  public let OP_HASH160 : Nat8 = 0xa9;
  public let OP_CHECKSIG : Nat8 = 0xac;
  public let OP_CHECKMULTISIG : Nat8 = 0xae;

  // Build P2PKH script pubkey
  public func buildP2PKHScriptPubKey(pubKeyHash : [Nat8]) : [Nat8] {
    // OP_DUP OP_HASH160 <20 bytes> OP_EQUALVERIFY OP_CHECKSIG
    var script = Array.init<Nat8>(25, 0);
    script[0] := OP_DUP;
    script[1] := OP_HASH160;
    script[2] := 0x14;  // Push 20 bytes
    for (i in Iter.range(0, 19)) {
      script[3 + i] := pubKeyHash[i];
    };
    script[23] := OP_EQUALVERIFY;
    script[24] := OP_CHECKSIG;
    Array.freeze(script)
  };

  // Build P2SH script pubkey
  public func buildP2SHScriptPubKey(scriptHash : [Nat8]) : [Nat8] {
    // OP_HASH160 <20 bytes> OP_EQUAL
    var script = Array.init<Nat8>(23, 0);
    script[0] := OP_HASH160;
    script[1] := 0x14;  // Push 20 bytes
    for (i in Iter.range(0, 19)) {
      script[2 + i] := scriptHash[i];
    };
    script[22] := OP_EQUAL;
    Array.freeze(script)
  };

  // Build P2PKH script sig
  public func buildP2PKHScriptSig(signature : [Nat8], pubKey : [Nat8]) : [Nat8] {
    var script = Buffer.Buffer<Nat8>(signature.size() + pubKey.size() + 2);
    
    // Push signature
    script.add(Nat8.fromNat(signature.size()));
    for (b in signature.vals()) { script.add(b) };
    
    // Push public key
    script.add(Nat8.fromNat(pubKey.size()));
    for (b in pubKey.vals()) { script.add(b) };
    
    Buffer.toArray(script)
  };

  // Build OP_RETURN data output
  public func buildOpReturnScript(data : [Nat8]) : [Nat8] {
    if (data.size() > 80) {
      // OP_RETURN data is limited to 80 bytes
      return [OP_RETURN];
    };
    
    var script = Buffer.Buffer<Nat8>(data.size() + 2);
    script.add(OP_RETURN);
    
    if (data.size() < 76) {
      script.add(Nat8.fromNat(data.size()));
    } else {
      script.add(OP_PUSHDATA1);
      script.add(Nat8.fromNat(data.size()));
    };
    
    for (b in data.vals()) { script.add(b) };
    Buffer.toArray(script)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART VII: TRANSACTION SIGNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // SIGHASH types
  public let SIGHASH_ALL : Nat8 = 0x01;
  public let SIGHASH_NONE : Nat8 = 0x02;
  public let SIGHASH_SINGLE : Nat8 = 0x03;
  public let SIGHASH_ANYONECANPAY : Nat8 = 0x80;

  // Transaction for signing
  public type RawTransaction = {
    version : Int32;
    inputs : [{
      prevTxHash : [Nat8];
      prevTxIndex : Nat32;
      scriptSig : [Nat8];
      sequence : Nat32;
    }];
    outputs : [{
      value : Nat64;
      scriptPubKey : [Nat8];
    }];
    lockTime : Nat32;
  };

  // Create signature hash for input
  public func sigHashForInput(
    tx : RawTransaction,
    inputIndex : Nat,
    prevScriptPubKey : [Nat8],
    sigHashType : Nat8
  ) : [Nat8] {
    // Create modified transaction for signing
    var modifiedTx = Buffer.Buffer<Nat8>(256);
    
    // Version
    let v = Int32.toNat32(tx.version);
    modifiedTx.add(Nat8.fromNat(Nat32.toNat(v & 0xFF)));
    modifiedTx.add(Nat8.fromNat(Nat32.toNat((v >> 8) & 0xFF)));
    modifiedTx.add(Nat8.fromNat(Nat32.toNat((v >> 16) & 0xFF)));
    modifiedTx.add(Nat8.fromNat(Nat32.toNat((v >> 24) & 0xFF)));
    
    // Input count
    modifiedTx.add(Nat8.fromNat(tx.inputs.size()));
    
    // Inputs
    for (i in Iter.range(0, tx.inputs.size() - 1)) {
      let input = tx.inputs[i];
      
      // Previous tx hash
      for (b in input.prevTxHash.vals()) { modifiedTx.add(b) };
      
      // Previous tx index
      modifiedTx.add(Nat8.fromNat(Nat32.toNat(input.prevTxIndex & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat32.toNat((input.prevTxIndex >> 8) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat32.toNat((input.prevTxIndex >> 16) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat32.toNat((input.prevTxIndex >> 24) & 0xFF)));
      
      // Script (previous scriptPubKey for current input, empty for others)
      if (i == inputIndex) {
        modifiedTx.add(Nat8.fromNat(prevScriptPubKey.size()));
        for (b in prevScriptPubKey.vals()) { modifiedTx.add(b) };
      } else {
        modifiedTx.add(0);  // Empty script
      };
      
      // Sequence
      modifiedTx.add(Nat8.fromNat(Nat32.toNat(input.sequence & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat32.toNat((input.sequence >> 8) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat32.toNat((input.sequence >> 16) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat32.toNat((input.sequence >> 24) & 0xFF)));
    };
    
    // Output count
    modifiedTx.add(Nat8.fromNat(tx.outputs.size()));
    
    // Outputs
    for (output in tx.outputs.vals()) {
      // Value
      modifiedTx.add(Nat8.fromNat(Nat64.toNat(output.value & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat64.toNat((output.value >> 8) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat64.toNat((output.value >> 16) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat64.toNat((output.value >> 24) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat64.toNat((output.value >> 32) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat64.toNat((output.value >> 40) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat64.toNat((output.value >> 48) & 0xFF)));
      modifiedTx.add(Nat8.fromNat(Nat64.toNat((output.value >> 56) & 0xFF)));
      
      // Script pubkey
      modifiedTx.add(Nat8.fromNat(output.scriptPubKey.size()));
      for (b in output.scriptPubKey.vals()) { modifiedTx.add(b) };
    };
    
    // Lock time
    modifiedTx.add(Nat8.fromNat(Nat32.toNat(tx.lockTime & 0xFF)));
    modifiedTx.add(Nat8.fromNat(Nat32.toNat((tx.lockTime >> 8) & 0xFF)));
    modifiedTx.add(Nat8.fromNat(Nat32.toNat((tx.lockTime >> 16) & 0xFF)));
    modifiedTx.add(Nat8.fromNat(Nat32.toNat((tx.lockTime >> 24) & 0xFF)));
    
    // SIGHASH type (4 bytes, little endian)
    modifiedTx.add(sigHashType);
    modifiedTx.add(0);
    modifiedTx.add(0);
    modifiedTx.add(0);
    
    // Double SHA-256
    sha256(sha256(Buffer.toArray(modifiedTx)))
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART VIII: DER SIGNATURE ENCODING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Encode signature in DER format
  public func derEncodeSignature(r : [Nat8], s : [Nat8]) : [Nat8] {
    // Remove leading zeros from r and s (but keep one if high bit is set)
    func trimLeadingZeros(bytes : [Nat8]) : [Nat8] {
      var i = 0;
      while (i < bytes.size() - 1 and bytes[i] == 0 and (bytes[i + 1] & 0x80) == 0) {
        i += 1;
      };
      Array.tabulate<Nat8>(bytes.size() - i, func(j) { bytes[i + j] })
    };

    // Add leading zero if high bit is set (to ensure positive)
    func ensurePositive(bytes : [Nat8]) : [Nat8] {
      if (bytes.size() > 0 and (bytes[0] & 0x80) != 0) {
        var result = Array.init<Nat8>(bytes.size() + 1, 0);
        result[0] := 0;
        for (i in Iter.range(0, bytes.size() - 1)) {
          result[i + 1] := bytes[i];
        };
        Array.freeze(result)
      } else {
        bytes
      }
    };

    let rTrimmed = ensurePositive(trimLeadingZeros(r));
    let sTrimmed = ensurePositive(trimLeadingZeros(s));

    let totalLen = rTrimmed.size() + sTrimmed.size() + 4;

    var der = Buffer.Buffer<Nat8>(totalLen + 2);
    der.add(0x30);  // SEQUENCE
    der.add(Nat8.fromNat(totalLen));
    der.add(0x02);  // INTEGER (r)
    der.add(Nat8.fromNat(rTrimmed.size()));
    for (b in rTrimmed.vals()) { der.add(b) };
    der.add(0x02);  // INTEGER (s)
    der.add(Nat8.fromNat(sTrimmed.size()));
    for (b in sTrimmed.vals()) { der.add(b) };

    Buffer.toArray(der)
  };

  // Decode DER signature
  public func derDecodeSignature(der : [Nat8]) : ?([Nat8], [Nat8]) {
    if (der.size() < 8) return null;
    if (der[0] != 0x30) return null;  // Not SEQUENCE

    let seqLen = Nat8.toNat(der[1]);
    if (der.size() != seqLen + 2) return null;

    if (der[2] != 0x02) return null;  // Not INTEGER
    let rLen = Nat8.toNat(der[3]);
    let r = Array.tabulate<Nat8>(rLen, func(i) { der[4 + i] });

    let sOffset = 4 + rLen;
    if (der[sOffset] != 0x02) return null;  // Not INTEGER
    let sLen = Nat8.toNat(der[sOffset + 1]);
    let s = Array.tabulate<Nat8>(sLen, func(i) { der[sOffset + 2 + i] });

    ?(r, s)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART IX: ENTROPY AND KEY GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Simple PRNG (NOT cryptographically secure - for demonstration only)
  public type PRNG = {
    var state : Nat64;
  };

  public func initPRNG(seed : Nat64) : PRNG {
    { var state = seed }
  };

  public func prngNext(prng : PRNG) : Nat64 {
    // xorshift64
    var x = prng.state;
    x := x ^ (x << 13);
    x := x ^ (x >> 7);
    x := x ^ (x << 17);
    prng.state := x;
    x
  };

  public func prngBytes(prng : PRNG, n : Nat) : [Nat8] {
    Array.tabulate<Nat8>(n, func(i) {
      if (i % 8 == 0) { ignore prngNext(prng) };
      Nat8.fromNat(Nat64.toNat((prng.state >> Nat64.fromNat((i % 8) * 8)) & 0xFF))
    })
  };

  // Hash-based key derivation (simplified)
  public func deriveKey(masterKey : [Nat8], path : Text) : [Nat8] {
    var data = Buffer.Buffer<Nat8>(masterKey.size() + Text.size(path));
    for (b in masterKey.vals()) { data.add(b) };
    for (c in Text.toIter(path)) {
      data.add(Nat8.fromNat(Nat32.toNat(Char.toNat32(c))));
    };
    sha256(Buffer.toArray(data))
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART X: BECH32 ENCODING (FOR SEGWIT ADDRESSES)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Bech32 alphabet
  let BECH32_ALPHABET : [Char] = [
    'q', 'p', 'z', 'r', 'y', '9', 'x', '8', 'g', 'f', '2', 't', 'v', 'd', 'w', '0',
    's', '3', 'j', 'n', '5', '4', 'k', 'h', 'c', 'e', '6', 'm', 'u', 'a', '7', 'l'
  ];

  // Bech32 polymod
  func bech32Polymod(values : [Nat]) : Nat {
    let gen : [Nat] = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3];
    var chk = 1;
    for (v in values.vals()) {
      let top = chk >> 25;
      chk := ((chk & 0x1ffffff) << 5) ^ v;
      for (i in Iter.range(0, 4)) {
        if ((top >> i) & 1 != 0) {
          chk := chk ^ gen[i];
        };
      };
    };
    chk
  };

  // Expand human-readable part
  func bech32HrpExpand(hrp : Text) : [Nat] {
    var result = Buffer.Buffer<Nat>(Text.size(hrp) * 2 + 1);
    for (c in Text.toIter(hrp)) {
      result.add(Nat32.toNat(Char.toNat32(c)) >> 5);
    };
    result.add(0);
    for (c in Text.toIter(hrp)) {
      result.add(Nat32.toNat(Char.toNat32(c)) & 31);
    };
    Buffer.toArray(result)
  };

  // Create checksum
  func bech32CreateChecksum(hrp : Text, data : [Nat]) : [Nat] {
    var values = Buffer.Buffer<Nat>(bech32HrpExpand(hrp).size() + data.size() + 6);
    for (v in bech32HrpExpand(hrp).vals()) { values.add(v) };
    for (v in data.vals()) { values.add(v) };
    for (_ in Iter.range(0, 5)) { values.add(0) };
    
    let polymod = bech32Polymod(Buffer.toArray(values)) ^ 1;
    Array.tabulate<Nat>(6, func(i) { (polymod >> (5 * (5 - i))) & 31 })
  };

  // Encode Bech32
  public func bech32Encode(hrp : Text, data : [Nat]) : Text {
    let checksum = bech32CreateChecksum(hrp, data);
    var combined = Buffer.Buffer<Nat>(data.size() + 6);
    for (v in data.vals()) { combined.add(v) };
    for (v in checksum.vals()) { combined.add(v) };
    
    var result = hrp # "1";
    for (v in combined.vals()) {
      result := result # Text.fromChar(BECH32_ALPHABET[v]);
    };
    result
  };

  // Convert 8-bit to 5-bit
  public func convertBits8To5(data : [Nat8]) : [Nat] {
    var result = Buffer.Buffer<Nat>(data.size() * 8 / 5 + 1);
    var acc = 0;
    var bits = 0;
    
    for (b in data.vals()) {
      acc := (acc << 8) | Nat8.toNat(b);
      bits += 8;
      while (bits >= 5) {
        bits -= 5;
        result.add((acc >> bits) & 31);
      };
    };
    
    if (bits > 0) {
      result.add((acc << (5 - bits)) & 31);
    };
    
    Buffer.toArray(result)
  };

  // Create P2WPKH address (bc1q...)
  public func pubKeyToP2WPKHAddress(pubKey : [Nat8], testnet : Bool) : Text {
    let pubKeyHash = hash160(pubKey);
    let hrp = if (testnet) { "tb" } else { "bc" };
    
    // Witness version 0 + converted data
    var data = Buffer.Buffer<Nat>(34);
    data.add(0);  // Witness version
    for (v in convertBits8To5(pubKeyHash).vals()) { data.add(v) };
    
    bech32Encode(hrp, Buffer.toArray(data))
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // THE COMPLETE BITCOIN TRANSACTION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

}
