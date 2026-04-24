/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Crypto Worker (GOK-CRYPTO-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-CRYPTO-001
 * Kernel Family:  SOVEREIGN_CRYPTO
 * Architecture:   AES-256-GCM × PBKDF2-100K × SHA-256/512 × HMAC × Wire Tokens
 *
 * All crypto runs off the main thread. Encrypt data, hash passwords, generate
 * wire tokens — the UI never freezes. Every wire can now have encrypted
 * authentication.
 *
 * Capabilities:
 *   • AES-256-GCM symmetric encryption/decryption
 *   • PBKDF2 with 100,000 iterations for key derivation
 *   • SHA-256 and SHA-512 hashing
 *   • HMAC-SHA-256 for message authentication
 *   • Sovereign wire token generation (φ-encoded)
 *   • Random key/IV generation via crypto.getRandomValues
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'encrypt', plaintext, password }
 *   Main → Worker: { type: 'decrypt', ciphertext, password, iv, salt }
 *   Main → Worker: { type: 'hash', data, algorithm }
 *   Main → Worker: { type: 'hmac', data, key }
 *   Main → Worker: { type: 'derive-key', password, salt, iterations }
 *   Main → Worker: { type: 'wire-token', wireId, payload }
 *   Main → Worker: { type: 'random', bytes }
 *   Main → Worker: { type: 'status' }
 *   Worker → Main: { type: 'encrypted', ciphertext, iv, salt }
 *   Worker → Main: { type: 'decrypted', plaintext }
 *   Worker → Main: { type: 'hashed', hash, algorithm }
 *   Worker → Main: { type: 'hmac-result', mac }
 *   Worker → Main: { type: 'key-derived', key }
 *   Worker → Main: { type: 'wire-token-result', token }
 *   Worker → Main: { type: 'random-result', bytes }
 *   Worker → Main: { type: 'heartbeat', ... }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * MEDINA TECH — SOVEREIGN KERNEL ARCHITECTURE
 */


/* ════════════════════════════════════════════════════════════════
   KERNEL CONSTANTS
   ════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var KERNEL_ID      = 'GOK-CRYPTO-001';
var KERNEL_FAMILY  = 'SOVEREIGN_CRYPTO';
var KERNEL_VERSION = '1.0.0';

var beatCount       = 0;
var running         = true;
var kernelPhase     = 0.0;
var totalOperations = 0;

var PBKDF2_ITERATIONS = 100000;
var AES_KEY_BITS      = 256;


/* ════════════════════════════════════════════════════════════════
   UTILITY — Hex encoding/decoding
   ════════════════════════════════════════════════════════════════ */

function bufToHex(buf) {
  var arr = new Uint8Array(buf);
  var hex = '';
  for (var i = 0; i < arr.length; i++) {
    hex += ('0' + arr[i].toString(16)).slice(-2);
  }
  return hex;
}

function hexToBuf(hex) {
  var arr = new Uint8Array(hex.length / 2);
  for (var i = 0; i < arr.length; i++) {
    arr[i] = parseInt(hex.substr(i * 2, 2), 16);
  }
  return arr.buffer;
}

function strToBuf(str) {
  return new TextEncoder().encode(str);
}

function bufToStr(buf) {
  return new TextDecoder().decode(buf);
}


/* ════════════════════════════════════════════════════════════════
   KEY DERIVATION — PBKDF2 with 100,000 iterations
   ════════════════════════════════════════════════════════════════ */

async function deriveKey(password, salt, iterations) {
  var keyMaterial = await crypto.subtle.importKey(
    'raw',
    strToBuf(password),
    'PBKDF2',
    false,
    ['deriveKey']
  );

  return crypto.subtle.deriveKey(
    {
      name: 'PBKDF2',
      salt: salt,
      iterations: iterations || PBKDF2_ITERATIONS,
      hash: 'SHA-256',
    },
    keyMaterial,
    { name: 'AES-GCM', length: AES_KEY_BITS },
    true,
    ['encrypt', 'decrypt']
  );
}


/* ════════════════════════════════════════════════════════════════
   AES-256-GCM ENCRYPTION
   ════════════════════════════════════════════════════════════════ */

async function encryptData(plaintext, password) {
  totalOperations++;
  var salt = crypto.getRandomValues(new Uint8Array(16));
  var iv   = crypto.getRandomValues(new Uint8Array(12));
  var key  = await deriveKey(password, salt);

  var ciphertext = await crypto.subtle.encrypt(
    { name: 'AES-GCM', iv: iv },
    key,
    strToBuf(plaintext)
  );

  return {
    ciphertext: bufToHex(ciphertext),
    iv:         bufToHex(iv),
    salt:       bufToHex(salt),
    algorithm:  'AES-256-GCM',
    iterations: PBKDF2_ITERATIONS,
  };
}

async function decryptData(ciphertextHex, password, ivHex, saltHex) {
  totalOperations++;
  var salt = hexToBuf(saltHex);
  var iv   = hexToBuf(ivHex);
  var key  = await deriveKey(password, new Uint8Array(salt));

  var plaintext = await crypto.subtle.decrypt(
    { name: 'AES-GCM', iv: new Uint8Array(iv) },
    key,
    hexToBuf(ciphertextHex)
  );

  return { plaintext: bufToStr(plaintext) };
}


/* ════════════════════════════════════════════════════════════════
   HASHING — SHA-256 / SHA-512
   ════════════════════════════════════════════════════════════════ */

async function hashData(data, algorithm) {
  totalOperations++;
  var algo = (algorithm || 'SHA-256').toUpperCase();
  if (algo !== 'SHA-256' && algo !== 'SHA-512') algo = 'SHA-256';

  var hash = await crypto.subtle.digest(algo, strToBuf(data));
  return { hash: bufToHex(hash), algorithm: algo };
}


/* ════════════════════════════════════════════════════════════════
   HMAC — SHA-256 message authentication
   ════════════════════════════════════════════════════════════════ */

async function computeHMAC(data, keyStr) {
  totalOperations++;
  var key = await crypto.subtle.importKey(
    'raw',
    strToBuf(keyStr),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  );

  var mac = await crypto.subtle.sign('HMAC', key, strToBuf(data));
  return { mac: bufToHex(mac) };
}


/* ════════════════════════════════════════════════════════════════
   WIRE TOKENS — φ-encoded sovereign tokens
   ════════════════════════════════════════════════════════════════ */

async function generateWireToken(wireId, payload) {
  totalOperations++;

  // Token structure: wireId + timestamp + phi-nonce + HMAC
  var timestamp = Date.now().toString(36);
  var nonce = Math.floor(kernelPhase * 1000000).toString(36);
  var tokenBody = wireId + '.' + timestamp + '.' + nonce;

  if (payload) {
    // Hash payload for inclusion in token
    var payloadHash = await crypto.subtle.digest('SHA-256', strToBuf(JSON.stringify(payload)));
    tokenBody += '.' + bufToHex(payloadHash).slice(0, 16);
  }

  // Sign the token with a sovereign key derived from the wire ID
  var key = await crypto.subtle.importKey(
    'raw',
    strToBuf('NOVA-SOVEREIGN-' + wireId + '-' + PHI.toString()),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  );

  var sig = await crypto.subtle.sign('HMAC', key, strToBuf(tokenBody));
  var token = tokenBody + '.' + bufToHex(sig).slice(0, 32);

  return {
    token: token,
    wireId: wireId,
    timestamp: Date.now(),
    expiresIn: 3600000, // 1 hour
  };
}


/* ════════════════════════════════════════════════════════════════
   RANDOM GENERATION
   ════════════════════════════════════════════════════════════════ */

function generateRandom(byteCount) {
  totalOperations++;
  var bytes = crypto.getRandomValues(new Uint8Array(byteCount || 32));
  return { hex: bufToHex(bytes), bytes: byteCount || 32 };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = async function(e) {
  var msg = e.data;

  try {
    switch (msg.type) {
      case 'encrypt': {
        var enc = await encryptData(msg.plaintext, msg.password);
        self.postMessage({
          type: 'encrypted',
          ciphertext: enc.ciphertext,
          iv: enc.iv,
          salt: enc.salt,
          algorithm: enc.algorithm,
          iterations: enc.iterations,
          kernelId: KERNEL_ID,
        });
        break;
      }

      case 'decrypt': {
        var dec = await decryptData(msg.ciphertext, msg.password, msg.iv, msg.salt);
        self.postMessage({
          type: 'decrypted',
          plaintext: dec.plaintext,
          kernelId: KERNEL_ID,
        });
        break;
      }

      case 'hash': {
        var h = await hashData(msg.data, msg.algorithm);
        self.postMessage({
          type: 'hashed',
          hash: h.hash,
          algorithm: h.algorithm,
          kernelId: KERNEL_ID,
        });
        break;
      }

      case 'hmac': {
        var hm = await computeHMAC(msg.data, msg.key);
        self.postMessage({
          type: 'hmac-result',
          mac: hm.mac,
          kernelId: KERNEL_ID,
        });
        break;
      }

      case 'derive-key': {
        var salt = msg.salt ? hexToBuf(msg.salt) : crypto.getRandomValues(new Uint8Array(16));
        var key = await deriveKey(msg.password, new Uint8Array(salt), msg.iterations);
        var exported = await crypto.subtle.exportKey('raw', key);
        self.postMessage({
          type: 'key-derived',
          key: bufToHex(exported),
          salt: bufToHex(salt),
          iterations: msg.iterations || PBKDF2_ITERATIONS,
          kernelId: KERNEL_ID,
        });
        break;
      }

      case 'wire-token': {
        var wt = await generateWireToken(msg.wireId, msg.payload);
        self.postMessage({
          type: 'wire-token-result',
          token: wt.token,
          wireId: wt.wireId,
          timestamp: wt.timestamp,
          expiresIn: wt.expiresIn,
          kernelId: KERNEL_ID,
        });
        break;
      }

      case 'random': {
        var rnd = generateRandom(msg.bytes);
        self.postMessage({
          type: 'random-result',
          hex: rnd.hex,
          bytes: rnd.bytes,
          kernelId: KERNEL_ID,
        });
        break;
      }

      case 'status': {
        self.postMessage({
          type: 'crypto-status',
          kernelId: KERNEL_ID,
          kernelFamily: KERNEL_FAMILY,
          version: KERNEL_VERSION,
          totalOperations: totalOperations,
          capabilities: ['AES-256-GCM', 'PBKDF2-100K', 'SHA-256', 'SHA-512', 'HMAC-SHA-256', 'wire-tokens'],
          beat: beatCount,
          phase: kernelPhase,
          phi: PHI,
        });
        break;
      }

      case 'stop': {
        running = false;
        clearInterval(_hbi);
        self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
        break;
      }
    }
  } catch (err) {
    self.postMessage({
      type: 'crypto-error',
      error: err.message,
      operation: msg.type,
      kernelId: KERNEL_ID,
    });
  }
};


/* ════════════════════════════════════════════════════════════════
   φ-COUPLED HEARTBEAT — 873ms Kuramoto pulse
   ════════════════════════════════════════════════════════════════ */

var _hbi = setInterval(function() {
  if (!running) return;
  beatCount++;
  kernelPhase += PHI_INV;
  if (kernelPhase > 2 * Math.PI) kernelPhase -= 2 * Math.PI;
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalOperations: totalOperations,
  });
}, HEARTBEAT);
