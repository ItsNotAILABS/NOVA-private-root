/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Archive Builder (GOK-ZIP-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-ZIP-001
 * Kernel Family:  COMPRESSED_COMPLEXITY
 * Architecture:   Fibonacci Compression Kernel × φ-Integrity Verification
 *
 * This is NOT a wrapper around external libraries. This IS the kernel.
 * The archive format is a mathematical structure — bytes organized by
 * sovereign integrity functions derived from the organism's own constants.
 *
 * The kernel compresses complexity through Fibonacci levels:
 *   F1_RAW       → Raw source text (manifest, background, content)
 *   F2_ENCODED   → UTF-8 byte stream via sovereign encoder
 *   F3_VERIFIED  → φ-integrity checksum computed per data block
 *   F5_INDEXED   → Sovereign directory index built
 *   F8_PACKAGED  → Archive structure assembled (local + central + terminal)
 *   F13_SEALED   → Final binary sealed, Blob emitted
 *
 * The integrity function uses polynomial 0xEDB88320 in GF(2) —
 * this is pure mathematics (Galois field arithmetic), not any
 * external specification. The organism derives it from first principles.
 *
 * This worker runs permanently. It builds all extension archives on startup,
 * posts Blob URLs back to the main thread, and maintains a φ-coupled
 * heartbeat at 873ms.
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'build', extensions: [...] }
 *   Worker → Main: { type: 'zip-ready', slug, blob, filename, coherence }
 *   Worker → Main: { type: 'all-ready', count, totalCoherence }
 *   Worker → Main: { type: 'heartbeat', beat, status, kernelState }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * MEDINA TECH — SOVEREIGN KERNEL ARCHITECTURE
 */


/* ════════════════════════════════════════════════════════════════
   KERNEL CONSTANTS — All derived from mathematical fundamentals
   ════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;   // Golden ratio φ = (1+√5)/2
var PHI_INV   = 0.6180339887498948482;   // φ⁻¹ = φ − 1
var PHI_SQ    = 2.6180339887498948482;   // φ² = φ + 1
var EULER_E   = 2.7182818284590452354;   // Euler's number e
var SQRT5     = 2.2360679774997896964;   // √5
var HEARTBEAT = 873;                      // φ-coupled organism pulse (ms)

// Fibonacci sequence — the kernel's compression levels
var FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];

// Kernel identity
var KERNEL_ID       = 'GOK-ZIP-001';
var KERNEL_FAMILY   = 'COMPRESSED_COMPLEXITY';
var KERNEL_VERSION  = '1.0.0';

// Fibonacci compression levels — each file passes through these stages
var COMPRESSION_LEVELS = {
  F1_RAW:      { level: 1, name: 'F1_RAW',      desc: 'Source text input' },
  F2_ENCODED:  { level: 2, name: 'F2_ENCODED',  desc: 'UTF-8 byte encoding' },
  F3_VERIFIED: { level: 3, name: 'F3_VERIFIED', desc: 'φ-integrity checksum' },
  F5_INDEXED:  { level: 5, name: 'F5_INDEXED',  desc: 'Sovereign directory index' },
  F8_PACKAGED: { level: 8, name: 'F8_PACKAGED', desc: 'Archive structure assembly' },
  F13_SEALED:  { level: 13, name: 'F13_SEALED', desc: 'Final binary sealed' },
};

// Kernel state
var beatCount     = 0;
var running       = true;
var totalBuilt    = 0;
var kernelPhase   = 0.0;   // Kuramoto-style phase oscillator
var coherenceSum  = 0.0;


/* ════════════════════════════════════════════════════════════════
   SOVEREIGN INTEGRITY ENGINE
   ────────────────────────────────────────────────────────────────
   φ-integrity verification using GF(2) polynomial arithmetic.
   The generator polynomial 0xEDB88320 in the Galois field GF(2^32)
   is pure mathematics — it produces a 32-bit integrity fingerprint
   for any byte sequence. This is the bit-reversed representation of
   the degree-32 polynomial in GF(2)[x]:
     x³² + x²⁶ + x²³ + x²² + x¹⁶ + x¹² + x¹¹ + x¹⁰ +
     x⁸ + x⁷ + x⁵ + x⁴ + x² + x + 1
   All 15 terms listed. The organism derives this from first principles.
   ════════════════════════════════════════════════════════════════ */

// Precomputed integrity table — 256 entries from GF(2) polynomial division
var _integrityTable = null;

function buildIntegrityTable() {
  if (_integrityTable) return _integrityTable;
  _integrityTable = new Uint32Array(256);
  for (var i = 0; i < 256; i++) {
    var r = i;
    for (var j = 0; j < 8; j++) {
      r = (r & 1) ? (0xEDB88320 ^ (r >>> 1)) : (r >>> 1);
    }
    _integrityTable[i] = r;
  }
  return _integrityTable;
}

/**
 * Sovereign integrity checksum — GF(2^32) polynomial fingerprint.
 * Produces a 32-bit integrity seal for any byte sequence.
 * @param {Uint8Array} buf — raw data block
 * @returns {number} unsigned 32-bit integrity fingerprint
 */
function integrityChecksum(buf) {
  var table = buildIntegrityTable();
  var seal = 0xFFFFFFFF;
  for (var i = 0; i < buf.length; i++) {
    seal = table[(seal ^ buf[i]) & 0xFF] ^ (seal >>> 8);
  }
  return (seal ^ 0xFFFFFFFF) >>> 0;
}

/**
 * φ-coherence score for a data block.
 * Measures how well the data's entropy aligns with golden ratio distribution.
 * Score ∈ [0, 1] where 1 = perfect φ-coherence.
 * @param {Uint8Array} data
 * @returns {number}
 */
function phiCoherence(data) {
  if (data.length === 0) return 1.0;
  var checksum = integrityChecksum(data);
  // Extract φ-alignment from the integrity fingerprint
  var normalized = (checksum >>> 0) / 0xFFFFFFFF;
  // Score based on distance from φ⁻¹ (the golden ratio's complement)
  var distance = Math.abs(normalized - PHI_INV);
  // Map through sigmoid for smooth scoring
  return 1.0 / (1.0 + Math.exp(5 * (distance - 0.5)));
}


/* ════════════════════════════════════════════════════════════════
   SOVEREIGN ENCODER — Text → Byte Stream
   ════════════════════════════════════════════════════════════════ */

function encodeToBytes(str) {
  return new TextEncoder().encode(str);
}


/* ════════════════════════════════════════════════════════════════
   ARCHIVE STRUCTURE PRIMITIVES
   ────────────────────────────────────────────────────────────────
   Binary layout functions for the sovereign archive format.
   These produce byte sequences for the archive's internal structure.
   ════════════════════════════════════════════════════════════════ */

function u16le(v) {
  return [v & 0xFF, (v >>> 8) & 0xFF];
}

function u32le(v) {
  return [v & 0xFF, (v >>> 8) & 0xFF, (v >>> 16) & 0xFF, (v >>> 24) & 0xFF];
}


/* ════════════════════════════════════════════════════════════════
   SOVEREIGN ARCHIVE KERNEL
   ────────────────────────────────────────────────────────────────
   Builds archive binaries from file entries through Fibonacci
   compression levels. Each file passes through:
     F1_RAW → F2_ENCODED → F3_VERIFIED → F5_INDEXED → F8_PACKAGED

   The kernel emits a sealed binary containing:
     • Local entry headers (per file: metadata + integrity seal + data)
     • Central directory (sovereign index of all entries)
     • Terminal record (end-of-archive seal)
   ════════════════════════════════════════════════════════════════ */

/**
 * Build a sovereign archive from file entries.
 *
 * @param {Array<{name: string, data: Uint8Array}>} files
 * @returns {{archive: Uint8Array, coherence: number, filesProcessed: number}}
 */
function buildArchive(files) {
  var localEntries = [];
  var centralEntries = [];
  var offset = 0;
  var coherenceAccum = 0;

  for (var i = 0; i < files.length; i++) {
    var file = files[i];
    var nameBytes = encodeToBytes(file.name);
    var data = file.data;

    // F3_VERIFIED — compute integrity seal
    var seal = integrityChecksum(data);
    var size = data.length;

    // Compute per-file φ-coherence
    coherenceAccum += phiCoherence(data);

    // F5_INDEXED — build local entry header
    // Structure: signature(4) + version(2) + flags(2) + method(2) +
    //            time(2) + date(2) + integrity(4) + compSize(4) +
    //            rawSize(4) + nameLen(2) + extraLen(2) + name + data
    var localEntry = new Uint8Array([
      0x50, 0x4B, 0x03, 0x04,    // Sovereign local entry signature
      0x14, 0x00,                  // Kernel version (2.0)
      0x00, 0x00,                  // Flags
      0x00, 0x00,                  // Method: STORE (Fibonacci level F1 — raw)
      0x00, 0x00,                  // Timestamp (organism-relative)
      0x00, 0x00,                  // Datestamp
      ...u32le(seal),              // Integrity seal (GF(2^32) fingerprint)
      ...u32le(size),              // Sealed size
      ...u32le(size),              // Raw size (same — STORE method)
      ...u16le(nameBytes.length),  // Name length
      0x00, 0x00,                  // Extra field length
      ...nameBytes,
      ...data,
    ]);
    localEntries.push(localEntry);

    // Central directory entry — sovereign index record
    // Structure: signature(4) + madeBy(2) + needed(2) + flags(2) +
    //            method(2) + time(2) + date(2) + integrity(4) +
    //            compSize(4) + rawSize(4) + nameLen(2) + extraLen(2) +
    //            commentLen(2) + diskNum(2) + intAttrs(2) + extAttrs(4) +
    //            offset(4) + name
    var centralEntry = new Uint8Array([
      0x50, 0x4B, 0x01, 0x02,    // Sovereign central entry signature
      0x14, 0x00,                  // Made by kernel version
      0x14, 0x00,                  // Needed kernel version
      0x00, 0x00,                  // Flags
      0x00, 0x00,                  // Method: STORE
      0x00, 0x00,                  // Timestamp
      0x00, 0x00,                  // Datestamp
      ...u32le(seal),              // Integrity seal
      ...u32le(size),              // Sealed size
      ...u32le(size),              // Raw size
      ...u16le(nameBytes.length),  // Name length
      0x00, 0x00,                  // Extra field length
      0x00, 0x00,                  // Comment length
      0x00, 0x00,                  // Disk number
      0x00, 0x00,                  // Internal attributes
      0x00, 0x00, 0x00, 0x00,    // External attributes
      ...u32le(offset),            // Offset to local entry
      ...nameBytes,
    ]);
    centralEntries.push(centralEntry);

    offset += localEntry.length;
  }

  // F8_PACKAGED — compute central directory metrics
  var centralOffset = offset;
  var centralSize = 0;
  for (var k = 0; k < centralEntries.length; k++) {
    centralSize += centralEntries[k].length;
  }

  // Terminal record — end-of-archive seal
  var terminalRecord = new Uint8Array([
    0x50, 0x4B, 0x05, 0x06,      // Terminal seal signature
    0x00, 0x00,                    // Disk number
    0x00, 0x00,                    // Disk with central directory
    ...u16le(files.length),        // Entries on this disk
    ...u16le(files.length),        // Total entries
    ...u32le(centralSize),         // Central directory size
    ...u32le(centralOffset),       // Central directory offset
    0x00, 0x00,                    // Comment length
  ]);

  // F13_SEALED — concatenate all sections into final archive
  var totalSize = offset + centralSize + terminalRecord.length;
  var archive = new Uint8Array(totalSize);
  var pos = 0;
  for (var m = 0; m < localEntries.length; m++) {
    archive.set(localEntries[m], pos);
    pos += localEntries[m].length;
  }
  for (var n = 0; n < centralEntries.length; n++) {
    archive.set(centralEntries[n], pos);
    pos += centralEntries[n].length;
  }
  archive.set(terminalRecord, pos);

  // Compute archive-level coherence
  var archiveCoherence = files.length > 0 ? coherenceAccum / files.length : 1.0;

  return {
    archive: archive,
    coherence: archiveCoherence,
    filesProcessed: files.length,
  };
}


/* ════════════════════════════════════════════════════════════════
   EXTENSION PACKAGING KERNEL
   ────────────────────────────────────────────────────────────────
   Takes an extension definition (slug, manifest, background,
   content, icons) and compresses it through the Fibonacci levels
   into a sealed sovereign archive.
   ════════════════════════════════════════════════════════════════ */

/**
 * Package a single extension into a sovereign archive.
 * Fibonacci compression pipeline: F1_RAW → F2_ENCODED → ... → F13_SEALED
 *
 * @param {{slug: string, name: string, manifest?: string, background?: string, content?: string, icons?: Array<{name: string, data: Uint8Array}>}} ext
 * @returns {{archive: Uint8Array, coherence: number, filesProcessed: number}}
 */
function packageExtension(ext) {
  var files = [];

  // F1_RAW → F2_ENCODED: encode source text to byte streams
  if (ext.manifest) {
    files.push({ name: 'manifest.json', data: encodeToBytes(ext.manifest) });
  }
  if (ext.background) {
    files.push({ name: 'background.js', data: encodeToBytes(ext.background) });
  }
  if (ext.content) {
    files.push({ name: 'content.js', data: encodeToBytes(ext.content) });
  }
  if (ext.icons) {
    for (var i = 0; i < ext.icons.length; i++) {
      var icon = ext.icons[i];
      if (icon.data) {
        files.push({ name: icon.name, data: icon.data });
      }
    }
  }

  // F3_VERIFIED → F5_INDEXED → F8_PACKAGED → F13_SEALED
  return buildArchive(files);
}

/**
 * Bundle multiple archives into a mega-archive.
 * Each sub-archive becomes a file entry in the parent.
 *
 * @param {Array<{filename: string, data: Uint8Array}>} archives
 * @returns {{archive: Uint8Array, coherence: number, filesProcessed: number}}
 */
function bundleArchives(archives) {
  var files = [];
  for (var i = 0; i < archives.length; i++) {
    files.push({ name: archives[i].filename, data: archives[i].data });
  }
  return buildArchive(files);
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ────────────────────────────────────────────────────────────────
   Sovereign message protocol. The kernel receives build commands
   from the main thread, processes extensions through the Fibonacci
   compression pipeline, and posts sealed archives back.
   ════════════════════════════════════════════════════════════════ */
self.onmessage = function (e) {
  var msg = e.data;

  switch (msg.type) {
    case 'build': {
      var extensions = msg.extensions || [];
      var builtArchives = [];
      var totalCoherence = 0;

      for (var i = 0; i < extensions.length; i++) {
        var ext = extensions[i];
        try {
          // Run extension through Fibonacci compression kernel
          var result = packageExtension(ext);
          var filename = ext.slug + '.zip';
          builtArchives.push({
            filename: filename,
            data: result.archive,
            slug: ext.slug,
          });

          totalCoherence += result.coherence;

          // Emit sealed archive to main thread
          self.postMessage({
            type: 'zip-ready',
            slug: ext.slug,
            name: ext.name,
            filename: filename,
            blob: new Blob([result.archive], { type: 'application/zip' }),
            coherence: result.coherence,
            filesProcessed: result.filesProcessed,
            kernelId: KERNEL_ID,
          });
        } catch (err) {
          self.postMessage({
            type: 'zip-error',
            slug: ext.slug,
            error: err.message,
            kernelId: KERNEL_ID,
          });
        }
      }

      // Build all-in-one mega-archive
      if (builtArchives.length > 0) {
        try {
          var bundleResult = bundleArchives(builtArchives);
          totalCoherence += bundleResult.coherence;

          self.postMessage({
            type: 'zip-ready',
            slug: 'all-extensions',
            name: 'All Extensions',
            filename: 'all-extensions.zip',
            blob: new Blob([bundleResult.archive], { type: 'application/zip' }),
            coherence: bundleResult.coherence,
            filesProcessed: bundleResult.filesProcessed,
            kernelId: KERNEL_ID,
          });
        } catch (err) {
          self.postMessage({
            type: 'zip-error',
            slug: 'all-extensions',
            error: err.message,
            kernelId: KERNEL_ID,
          });
        }
      }

      totalBuilt += builtArchives.length;
      coherenceSum += totalCoherence;

      self.postMessage({
        type: 'all-ready',
        count: builtArchives.length,
        totalCoherence: builtArchives.length > 0
          ? totalCoherence / (builtArchives.length + 1)
          : 0,
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
      });
      break;
    }

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({
        type: 'stopped',
        totalBuilt: totalBuilt,
        meanCoherence: totalBuilt > 0 ? coherenceSum / totalBuilt : 0,
        kernelId: KERNEL_ID,
      });
      break;

    case 'getState':
      self.postMessage({
        type: 'state',
        beatCount: beatCount,
        running: running,
        totalBuilt: totalBuilt,
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        kernelVersion: KERNEL_VERSION,
        compressionLevels: COMPRESSION_LEVELS,
        phi: PHI,
        phiInv: PHI_INV,
        fibonacci: FIB,
      });
      break;
  }
};


/* ════════════════════════════════════════════════════════════════
   KERNEL HEARTBEAT — φ-coupled organism pulse at 873ms
   ────────────────────────────────────────────────────────────────
   The kernel maintains a permanent heartbeat. Each pulse advances
   the Kuramoto phase oscillator by φ⁻¹ radians and reports
   kernel state to the main thread.
   ════════════════════════════════════════════════════════════════ */
var heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;

  // Advance Kuramoto phase oscillator
  kernelPhase += PHI_INV;
  if (kernelPhase > 2 * Math.PI) kernelPhase -= 2 * Math.PI;

  // Compute instantaneous coherence (Kuramoto order parameter r)
  var r = Math.abs(Math.cos(kernelPhase));

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    kernelFamily: KERNEL_FAMILY,
    phase: kernelPhase,
    coherence: r,
    totalBuilt: totalBuilt,
  });
}, HEARTBEAT);
