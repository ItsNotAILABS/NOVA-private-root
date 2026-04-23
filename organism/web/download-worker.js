/**
 * Download Worker — Sovereign Zip Builder
 *
 * Web Worker that builds real .zip files from extension source code
 * entirely in the browser. No server. No GitHub. No dependencies.
 *
 * Uses a minimal pure-JS zip implementation (STORE method, no compression
 * needed — extensions are tiny). Generates Blob URLs that trigger real
 * file downloads when clicked.
 *
 * This worker runs permanently on the user's device. It builds all
 * extension zips on startup, posts blob URLs back to the main thread,
 * and keeps a heartbeat alive at 873ms.
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'build', extensions: [...] }
 *   Worker → Main: { type: 'zip-ready', slug, blob, filename }
 *   Worker → Main: { type: 'all-ready', count }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;

let beatCount = 0;
let running = true;

/* ════════════════════════════════════════════════════════════════
   Minimal ZIP builder — pure JS, zero dependencies
   Implements PKZIP STORE (no compression) which is perfect for
   small text files like manifest.json, background.js, content.js

   References:
     PKZIP APPNOTE §4.3.7  — Local file header
     PKZIP APPNOTE §4.3.12 — Central directory header
     PKZIP APPNOTE §4.3.16 — End of central directory record
   ════════════════════════════════════════════════════════════════ */

/**
 * CRC-32 — IEEE 802.3 polynomial 0xEDB88320 (reflected)
 * Used by ZIP, PNG, Ethernet. Table-driven for performance.
 * @param {Uint8Array} buf
 * @returns {number} unsigned 32-bit CRC
 */
function crc32(buf) {
  // Build lookup table (256 entries, one-time)
  var table = new Uint32Array(256);
  for (var i = 0; i < 256; i++) {
    var c = i;
    for (var j = 0; j < 8; j++) {
      c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
    }
    table[i] = c;
  }
  var crc = 0xFFFFFFFF;
  for (var i = 0; i < buf.length; i++) {
    crc = table[(crc ^ buf[i]) & 0xFF] ^ (crc >>> 8);
  }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

/**
 * String → UTF-8 bytes
 * @param {string} str
 * @returns {Uint8Array}
 */
function strToBytes(str) {
  return new TextEncoder().encode(str);
}

/**
 * Little-endian 16-bit value → 2 bytes
 * @param {number} v
 * @returns {number[]}
 */
function u16le(v) {
  return [v & 0xFF, (v >>> 8) & 0xFF];
}

/**
 * Little-endian 32-bit value → 4 bytes
 * @param {number} v
 * @returns {number[]}
 */
function u32le(v) {
  return [v & 0xFF, (v >>> 8) & 0xFF, (v >>> 16) & 0xFF, (v >>> 24) & 0xFF];
}

/**
 * Build a valid .zip file from an array of {name, data} entries.
 * Uses STORE method (no compression) — perfect for small text files.
 *
 * ZIP format:
 *   [Local file header + file data] × N
 *   [Central directory entry] × N
 *   [End of central directory record]
 *
 * @param {Array<{name: string, data: Uint8Array}>} files
 * @returns {Uint8Array} complete ZIP file
 */
function buildZip(files) {
  var localHeaders = [];
  var centralHeaders = [];
  var offset = 0;

  for (var i = 0; i < files.length; i++) {
    var file = files[i];
    var nameBytes = strToBytes(file.name);
    var data = file.data;
    var crc = crc32(data);
    var size = data.length;

    // Local file header (30 bytes + name + data)
    // PKZIP APPNOTE §4.3.7
    var local = new Uint8Array([
      0x50, 0x4B, 0x03, 0x04,    // Local file header signature
      0x14, 0x00,                  // Version needed to extract (2.0)
      0x00, 0x00,                  // General purpose bit flag
      0x00, 0x00,                  // Compression method: STORE
      0x00, 0x00,                  // Last mod file time
      0x00, 0x00,                  // Last mod file date
      ...u32le(crc),               // CRC-32
      ...u32le(size),              // Compressed size
      ...u32le(size),              // Uncompressed size (same — STORE)
      ...u16le(nameBytes.length),  // File name length
      0x00, 0x00,                  // Extra field length
      ...nameBytes,
      ...data,
    ]);
    localHeaders.push(local);

    // Central directory file header (46 bytes + name)
    // PKZIP APPNOTE §4.3.12
    var central = new Uint8Array([
      0x50, 0x4B, 0x01, 0x02,    // Central file header signature
      0x14, 0x00,                  // Version made by
      0x14, 0x00,                  // Version needed to extract
      0x00, 0x00,                  // General purpose bit flag
      0x00, 0x00,                  // Compression method: STORE
      0x00, 0x00,                  // Last mod file time
      0x00, 0x00,                  // Last mod file date
      ...u32le(crc),               // CRC-32
      ...u32le(size),              // Compressed size
      ...u32le(size),              // Uncompressed size
      ...u16le(nameBytes.length),  // File name length
      0x00, 0x00,                  // Extra field length
      0x00, 0x00,                  // File comment length
      0x00, 0x00,                  // Disk number start
      0x00, 0x00,                  // Internal file attributes
      0x00, 0x00, 0x00, 0x00,    // External file attributes
      ...u32le(offset),            // Relative offset of local header
      ...nameBytes,
    ]);
    centralHeaders.push(central);

    offset += local.length;
  }

  var centralOffset = offset;
  var centralSize = 0;
  for (var k = 0; k < centralHeaders.length; k++) {
    centralSize += centralHeaders[k].length;
  }

  // End of central directory record (22 bytes)
  // PKZIP APPNOTE §4.3.16
  var eocd = new Uint8Array([
    0x50, 0x4B, 0x05, 0x06,      // EOCD signature
    0x00, 0x00,                    // Number of this disk
    0x00, 0x00,                    // Disk where central dir starts
    ...u16le(files.length),        // Entries in central dir on this disk
    ...u16le(files.length),        // Total entries in central dir
    ...u32le(centralSize),         // Size of central directory
    ...u32le(centralOffset),       // Offset of central directory
    0x00, 0x00,                    // Comment length
  ]);

  // Concatenate: local headers + central headers + EOCD
  var totalSize = offset + centralSize + eocd.length;
  var result = new Uint8Array(totalSize);
  var pos = 0;
  for (var m = 0; m < localHeaders.length; m++) {
    result.set(localHeaders[m], pos);
    pos += localHeaders[m].length;
  }
  for (var n = 0; n < centralHeaders.length; n++) {
    result.set(centralHeaders[n], pos);
    pos += centralHeaders[n].length;
  }
  result.set(eocd, pos);
  return result;
}


/* ════════════════════════════════════════════════════════════════
   Build pipeline — packages each extension into a zip
   ════════════════════════════════════════════════════════════════ */

/**
 * Build a single extension zip from its source files.
 * @param {{slug: string, name: string, manifest?: string, background?: string, content?: string, icons?: Array<{name: string, data: Uint8Array}>}} ext
 * @returns {Uint8Array} ZIP data
 */
function buildExtensionZip(ext) {
  var files = [];

  if (ext.manifest) {
    files.push({ name: 'manifest.json', data: strToBytes(ext.manifest) });
  }
  if (ext.background) {
    files.push({ name: 'background.js', data: strToBytes(ext.background) });
  }
  if (ext.content) {
    files.push({ name: 'content.js', data: strToBytes(ext.content) });
  }
  if (ext.icons) {
    for (var i = 0; i < ext.icons.length; i++) {
      var icon = ext.icons[i];
      if (icon.data) {
        files.push({ name: icon.name, data: icon.data });
      }
    }
  }

  return buildZip(files);
}

/**
 * Bundle all individual zips into one mega-zip.
 * @param {Array<{filename: string, data: Uint8Array}>} individualZips
 * @returns {Uint8Array}
 */
function buildAllZip(individualZips) {
  var files = [];
  for (var i = 0; i < individualZips.length; i++) {
    files.push({ name: individualZips[i].filename, data: individualZips[i].data });
  }
  return buildZip(files);
}


/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */
self.onmessage = function (e) {
  var msg = e.data;

  switch (msg.type) {
    case 'build': {
      var extensions = msg.extensions || [];
      var builtZips = [];

      for (var i = 0; i < extensions.length; i++) {
        var ext = extensions[i];
        try {
          var zipData = buildExtensionZip(ext);
          var filename = ext.slug + '.zip';
          builtZips.push({ filename: filename, data: zipData, slug: ext.slug });

          self.postMessage({
            type: 'zip-ready',
            slug: ext.slug,
            name: ext.name,
            filename: filename,
            blob: new Blob([zipData], { type: 'application/zip' }),
          });
        } catch (err) {
          self.postMessage({
            type: 'zip-error',
            slug: ext.slug,
            error: err.message,
          });
        }
      }

      // Build all-in-one bundle
      if (builtZips.length > 0) {
        try {
          var allData = buildAllZip(builtZips);
          self.postMessage({
            type: 'zip-ready',
            slug: 'all-extensions',
            name: 'All Extensions',
            filename: 'all-extensions.zip',
            blob: new Blob([allData], { type: 'application/zip' }),
          });
        } catch (err) {
          self.postMessage({ type: 'zip-error', slug: 'all-extensions', error: err.message });
        }
      }

      self.postMessage({ type: 'all-ready', count: builtZips.length });
      break;
    }

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped' });
      break;

    case 'getState':
      self.postMessage({ type: 'state', beatCount: beatCount, running: running });
      break;
  }
};


/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms (φ-coupled organism pulse)
   ════════════════════════════════════════════════════════════════ */
var heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
  });
}, HEARTBEAT);
