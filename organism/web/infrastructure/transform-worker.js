/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Transform Worker (GOK-TRANSFORM-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-TRANSFORM-001
 * Kernel Family:  DATA_TRANSFORM
 * Architecture:   Format Converters × Data Pipeline × Schema Mapping
 *
 * Multi-format data transformation engine providing bidirectional conversion
 * between JSON, XML, CSV, YAML, TOML, Markdown, and HTML. Includes a chainable
 * data pipeline and a schema mapper for field-level remapping.
 *
 * Features:
 *   • Bidirectional converters: JSON↔XML↔CSV↔YAML↔TOML↔Markdown↔HTML
 *   • Chainable data pipeline with ordered transform steps
 *   • Schema mapping with rename / default / transform rules
 *   • Batch conversion with per-item progress tracking
 *   • φ-weighted heartbeat pulse for telemetry ring integration
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'convert' | 'pipeline' | 'map-schema' | 'batch' |
 *                          'list-formats' | 'status' | 'stop' }
 *   Worker → Main: { type: 'converted' | 'pipeline-result' | 'schema-mapped' |
 *                          'batch-complete' | 'formats' | 'heartbeat' | 'stopped' }
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
var KERNEL_ID      = 'GOK-TRANSFORM-001';
var KERNEL_FAMILY  = 'DATA_TRANSFORM';
var KERNEL_VERSION = '1.0.0';
var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;
var SUPPORTED_FORMATS = ['json', 'xml', 'csv', 'yaml', 'toml', 'markdown', 'html'];

/* ════════════════════════════════════════════════════════════════
   UTILITY HELPERS
   ════════════════════════════════════════════════════════════════ */
function escapeXml(s) {
  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;')
    .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
function escapeHtml(s) {
  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;')
    .replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

/* ════════════════════════════════════════════════════════════════
   FORMAT CONVERTERS — JSON ↔ XML
   ════════════════════════════════════════════════════════════════ */
function jsonToXml(obj, root) {
  root = root || 'root';
  var xml = '', keys = Object.keys(obj);
  for (var i = 0; i < keys.length; i++) {
    var k = keys[i], v = obj[k];
    if (Array.isArray(v)) {
      for (var a = 0; a < v.length; a++) {
        xml += (typeof v[a] === 'object' && v[a] !== null)
          ? '<' + k + '>' + jsonToXml(v[a], null) + '</' + k + '>'
          : '<' + k + '>' + escapeXml(v[a]) + '</' + k + '>';
      }
    } else if (typeof v === 'object' && v !== null) {
      xml += '<' + k + '>' + jsonToXml(v, null) + '</' + k + '>';
    } else {
      xml += '<' + k + '>' + escapeXml(v) + '</' + k + '>';
    }
  }
  return root ? '<' + root + '>' + xml + '</' + root + '>' : xml;
}

function xmlToJson(xmlStr) {
  var result = {}, re = /<(\w+)>([\s\S]*?)<\/\1>/g, m;
  while ((m = re.exec(xmlStr)) !== null) {
    var tag = m[1], inner = m[2].trim();
    var val = /<\w+>/.test(inner) ? xmlToJson(inner) : inner;
    if (result[tag] !== undefined) {
      if (!Array.isArray(result[tag])) result[tag] = [result[tag]];
      result[tag].push(val);
    } else {
      result[tag] = val;
    }
  }
  return result;
}

/* ════════════════════════════════════════════════════════════════
   FORMAT CONVERTERS — JSON ↔ CSV
   ════════════════════════════════════════════════════════════════ */
function jsonToCsv(data) {
  if (!Array.isArray(data) || data.length === 0) return '';
  var hdr = Object.keys(data[0]), lines = [hdr.join(',')];
  for (var i = 0; i < data.length; i++) {
    var row = [];
    for (var h = 0; h < hdr.length; h++) {
      var c = data[i][hdr[h]];
      c = (c === undefined || c === null) ? '' : String(c);
      if (c.indexOf(',') > -1 || c.indexOf('"') > -1) c = '"' + c.replace(/"/g, '""') + '"';
      row.push(c);
    }
    lines.push(row.join(','));
  }
  return lines.join('\n');
}

function csvToJson(csv) {
  var lines = csv.trim().split('\n');
  if (lines.length < 2) return [];
  var hdr = lines[0].split(',').map(function(h) { return h.trim(); });
  var out = [];
  for (var i = 1; i < lines.length; i++) {
    var vals = lines[i].split(','), obj = {};
    for (var h = 0; h < hdr.length; h++) obj[hdr[h]] = vals[h] !== undefined ? vals[h].trim() : '';
    out.push(obj);
  }
  return out;
}

/* ════════════════════════════════════════════════════════════════
   FORMAT CONVERTERS — JSON ↔ YAML
   ════════════════════════════════════════════════════════════════ */
function jsonToYaml(obj, depth) {
  depth = depth || 0;
  var pad = ''; for (var p = 0; p < depth; p++) pad += '  ';
  var y = '', keys = Object.keys(obj);
  for (var i = 0; i < keys.length; i++) {
    var k = keys[i], v = obj[k];
    if (Array.isArray(v)) {
      y += pad + k + ':\n';
      for (var a = 0; a < v.length; a++) {
        y += (typeof v[a] === 'object' && v[a] !== null)
          ? pad + '  -\n' + jsonToYaml(v[a], depth + 2)
          : pad + '  - ' + String(v[a]) + '\n';
      }
    } else if (typeof v === 'object' && v !== null) {
      y += pad + k + ':\n' + jsonToYaml(v, depth + 1);
    } else {
      y += pad + k + ': ' + String(v) + '\n';
    }
  }
  return y;
}

function yamlToJson(str) {
  var result = {}, lines = str.split('\n');
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i].trim();
    if (line === '' || line.charAt(0) === '#' || line.charAt(0) === '-') continue;
    var ci = line.indexOf(':');
    if (ci === -1) continue;
    var key = line.substring(0, ci).trim(), val = line.substring(ci + 1).trim();
    result[key] = val === '' ? {} : (isNaN(Number(val)) ? val : Number(val));
  }
  return result;
}

/* ════════════════════════════════════════════════════════════════
   FORMAT CONVERTERS — JSON ↔ TOML
   ════════════════════════════════════════════════════════════════ */
function tomlVal(v) {
  if (typeof v === 'string') return '"' + v.replace(/"/g, '\\"') + '"';
  if (typeof v === 'boolean') return v ? 'true' : 'false';
  if (Array.isArray(v)) return '[' + v.map(tomlVal).join(', ') + ']';
  return String(v);
}

function jsonToToml(obj) {
  var t = '', keys = Object.keys(obj);
  for (var i = 0; i < keys.length; i++) {
    var k = keys[i], v = obj[k];
    if (typeof v === 'object' && v !== null && !Array.isArray(v)) {
      t += '\n[' + k + ']\n';
      var sk = Object.keys(v);
      for (var s = 0; s < sk.length; s++) t += sk[s] + ' = ' + tomlVal(v[sk[s]]) + '\n';
    } else {
      t += k + ' = ' + tomlVal(v) + '\n';
    }
  }
  return t;
}

function parseTomlVal(raw) {
  if (raw.charAt(0) === '"' && raw.charAt(raw.length - 1) === '"') return raw.slice(1, -1);
  if (raw === 'true') return true;
  if (raw === 'false') return false;
  if (!isNaN(Number(raw))) return Number(raw);
  return raw;
}

function tomlToJson(str) {
  var result = {}, cur = result, lines = str.split('\n');
  for (var i = 0; i < lines.length; i++) {
    var ln = lines[i].trim();
    if (ln === '' || ln.charAt(0) === '#') continue;
    if (ln.charAt(0) === '[' && ln.charAt(ln.length - 1) === ']') {
      var sec = ln.slice(1, -1).trim();
      result[sec] = {}; cur = result[sec]; continue;
    }
    var eq = ln.indexOf('=');
    if (eq === -1) continue;
    cur[ln.substring(0, eq).trim()] = parseTomlVal(ln.substring(eq + 1).trim());
  }
  return result;
}

/* ════════════════════════════════════════════════════════════════
   FORMAT CONVERTERS — JSON → Markdown / HTML
   ════════════════════════════════════════════════════════════════ */
function jsonToMarkdown(data) {
  if (Array.isArray(data) && data.length > 0) {
    var h = Object.keys(data[0]);
    var md = '| ' + h.join(' | ') + ' |\n| ' + h.map(function() { return '---'; }).join(' | ') + ' |\n';
    for (var i = 0; i < data.length; i++) {
      var cells = [];
      for (var c = 0; c < h.length; c++) cells.push(String(data[i][h[c]] !== undefined ? data[i][h[c]] : ''));
      md += '| ' + cells.join(' | ') + ' |\n';
    }
    return md;
  }
  if (typeof data === 'object' && data !== null) {
    var keys = Object.keys(data);
    return keys.map(function(k) { return '- **' + k + '**: ' + String(data[k]); }).join('\n') + '\n';
  }
  return String(data);
}

function jsonToHtml(data) {
  if (Array.isArray(data) && data.length > 0) {
    var h = Object.keys(data[0]), html = '<table><thead><tr>';
    for (var j = 0; j < h.length; j++) html += '<th>' + escapeHtml(h[j]) + '</th>';
    html += '</tr></thead><tbody>';
    for (var i = 0; i < data.length; i++) {
      html += '<tr>';
      for (var c = 0; c < h.length; c++) html += '<td>' + escapeHtml(data[i][h[c]] !== undefined ? data[i][h[c]] : '') + '</td>';
      html += '</tr>';
    }
    return html + '</tbody></table>';
  }
  if (typeof data === 'object' && data !== null) {
    var dl = '<dl>', keys = Object.keys(data);
    for (var k = 0; k < keys.length; k++) dl += '<dt>' + escapeHtml(keys[k]) + '</dt><dd>' + escapeHtml(data[keys[k]]) + '</dd>';
    return dl + '</dl>';
  }
  return '<span>' + escapeHtml(data) + '</span>';
}

/* ════════════════════════════════════════════════════════════════
   CONVERSION DISPATCHER
   ════════════════════════════════════════════════════════════════ */
function convert(from, to, data) {
  var obj = data;
  if (from === 'xml' && typeof data === 'string')      obj = xmlToJson(data);
  else if (from === 'csv' && typeof data === 'string')  obj = csvToJson(data);
  else if (from === 'yaml' && typeof data === 'string') obj = yamlToJson(data);
  else if (from === 'toml' && typeof data === 'string') obj = tomlToJson(data);
  else if (from === 'json' && typeof data === 'string') obj = JSON.parse(data);
  if (to === 'json')     return JSON.stringify(obj, null, 2);
  if (to === 'xml')      return jsonToXml(obj);
  if (to === 'csv')      return jsonToCsv(Array.isArray(obj) ? obj : [obj]);
  if (to === 'yaml')     return jsonToYaml(obj);
  if (to === 'toml')     return jsonToToml(obj);
  if (to === 'markdown') return jsonToMarkdown(obj);
  if (to === 'html')     return jsonToHtml(obj);
  return obj;
}

/* ════════════════════════════════════════════════════════════════
   DATA PIPELINE — chainable transform steps
   ════════════════════════════════════════════════════════════════ */
function executePipeline(data, steps) {
  var cur = data, stepsRun = 0;
  for (var i = 0; i < steps.length; i++) {
    var step = steps[i], opts = step.options || {};
    if (step.transform === 'convert') {
      cur = convert(opts.from || 'json', opts.to || 'json', cur);
    } else if (step.transform === 'filter' && Array.isArray(cur) && opts.field) {
      cur = cur.filter(function(item) { return String(item[opts.field]) === String(opts.value); });
    } else if (step.transform === 'pick' && opts.fields) {
      var fields = opts.fields;
      var pickFn = function(item) {
        var p = {};
        for (var f = 0; f < fields.length; f++) {
          if (item[fields[f]] !== undefined) p[fields[f]] = item[fields[f]];
        }
        return p;
      };
      cur = Array.isArray(cur) ? cur.map(pickFn) : pickFn(cur);
    } else if (step.transform === 'rename' && opts.map) {
      var rmap = opts.map;
      var renameFn = function(item) {
        var o = {}, ks = Object.keys(item);
        for (var j = 0; j < ks.length; j++) o[rmap[ks[j]] || ks[j]] = item[ks[j]];
        return o;
      };
      cur = Array.isArray(cur) ? cur.map(renameFn) : renameFn(cur);
    }
    stepsRun++;
  }
  return { result: cur, stepsRun: stepsRun };
}

/* ════════════════════════════════════════════════════════════════
   SCHEMA MAPPING — field-level remapping with transforms
   ════════════════════════════════════════════════════════════════ */
function applySchemaMap(data, mappings) {
  var fieldsApplied = 0;
  var mapOne = function(item) {
    var out = {};
    for (var m = 0; m < mappings.length; m++) {
      var rule = mappings[m], tgt = rule.target || rule.source;
      var val = item[rule.source];
      if (val === undefined || val === null) val = rule['default'] !== undefined ? rule['default'] : null;
      if (rule.transform === 'uppercase' && typeof val === 'string') val = val.toUpperCase();
      else if (rule.transform === 'lowercase' && typeof val === 'string') val = val.toLowerCase();
      else if (rule.transform === 'number') val = Number(val);
      else if (rule.transform === 'string') val = String(val);
      else if (rule.transform === 'boolean') val = Boolean(val);
      else if (rule.transform === 'trim' && typeof val === 'string') val = val.trim();
      out[tgt] = val;
      fieldsApplied++;
    }
    return out;
  };
  return { result: Array.isArray(data) ? data.map(mapOne) : mapOne(data), fieldsApplied: fieldsApplied };
}

/* ════════════════════════════════════════════════════════════════
   BATCH TRANSFORM — bulk conversion with progress
   ════════════════════════════════════════════════════════════════ */
function batchTransform(items, from, to) {
  var results = [], successCount = 0, total = items.length;
  for (var i = 0; i < total; i++) {
    try {
      results.push({ index: i, success: true, result: convert(from, to, items[i]) });
      successCount++;
    } catch (err) {
      results.push({ index: i, success: false, error: err.message });
    }
    if (total > 1 && (i % 10 === 0 || i === total - 1)) {
      self.postMessage({
        type: 'batch-progress', completed: i + 1, total: total,
        percent: Math.round(((i + 1) / total) * 100), kernelId: KERNEL_ID,
      });
    }
  }
  return { results: results, total: total, successCount: successCount };
}

/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */
self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {
    case 'convert': {
      try {
        var cvt = convert(msg.from, msg.to, msg.data);
        self.postMessage({
          type: 'converted', from: msg.from, to: msg.to,
          result: cvt, kernelId: KERNEL_ID,
        });
      } catch (err) {
        self.postMessage({
          type: 'convert-error', from: msg.from, to: msg.to,
          error: err.message, kernelId: KERNEL_ID,
        });
      }
      break;
    }
    case 'pipeline': {
      try {
        var pOut = executePipeline(msg.data, msg.steps || []);
        self.postMessage({
          type: 'pipeline-result', result: pOut.result,
          stepsRun: pOut.stepsRun, kernelId: KERNEL_ID,
        });
      } catch (err) {
        self.postMessage({ type: 'pipeline-error', error: err.message, kernelId: KERNEL_ID });
      }
      break;
    }
    case 'map-schema': {
      try {
        var mOut = applySchemaMap(msg.data, msg.mappings || []);
        self.postMessage({
          type: 'schema-mapped', result: mOut.result,
          fieldsApplied: mOut.fieldsApplied, kernelId: KERNEL_ID,
        });
      } catch (err) {
        self.postMessage({ type: 'schema-map-error', error: err.message, kernelId: KERNEL_ID });
      }
      break;
    }
    case 'batch': {
      try {
        var bOut = batchTransform(msg.items || [], msg.from, msg.to);
        self.postMessage({
          type: 'batch-complete', results: bOut.results,
          total: bOut.total, successCount: bOut.successCount, kernelId: KERNEL_ID,
        });
      } catch (err) {
        self.postMessage({ type: 'batch-error', error: err.message, kernelId: KERNEL_ID });
      }
      break;
    }
    case 'list-formats': {
      self.postMessage({ type: 'formats', formats: SUPPORTED_FORMATS, kernelId: KERNEL_ID });
      break;
    }
    case 'status': {
      self.postMessage({
        type: 'transform-status', kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY, version: KERNEL_VERSION,
        supportedFormats: SUPPORTED_FORMATS, beat: beatCount,
        phase: kernelPhase, phi: PHI, running: running,
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
    type: 'heartbeat', beat: beatCount, phi: PHI,
    heartbeatMs: HEARTBEAT, timestamp: Date.now(),
    status: 'alive', kernelId: KERNEL_ID, phase: kernelPhase,
  });
}, HEARTBEAT);
