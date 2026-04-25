/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Validate Worker (GOK-VALIDATE-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-VALIDATE-001
 * Kernel Family:  INPUT_VALIDATION
 * Architecture:   Schema Validation × Input Sanitization × Type Checking × Rule Engine
 *
 * Full-spectrum input validation kernel for the NOVA organism. Enforces schema
 * constraints, sanitises untrusted input against XSS/SQLi/path-traversal,
 * performs deep type checking, and exposes a pluggable custom rule engine.
 * 20 built-in rules ship out of the box with batch validation support.
 *
 * Features:
 *   • 20 built-in validation rules (required, email, uuid, range, …)
 *   • Schema-driven field validation with detailed error reports
 *   • XSS / SQL injection / path traversal sanitisation
 *   • Deep type checking (string, number, array, email, uuid, date, …)
 *   • Custom rule registry with dynamic rule addition
 *   • Batch validation for bulk data sets
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'validate',       data, schema }
 *   Main → Worker: { type: 'sanitize',       input }
 *   Main → Worker: { type: 'type-check',     value, expectedType }
 *   Main → Worker: { type: 'add-rule',       name, rule }
 *   Main → Worker: { type: 'batch-validate', items, schema }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'validation-result',       valid, errors, fieldCount, kernelId }
 *   Worker → Main: { type: 'sanitized',                original, sanitized, threats, threatCount, kernelId }
 *   Worker → Main: { type: 'type-result',              value, expectedType, valid, actualType, kernelId }
 *   Worker → Main: { type: 'rule-added',               name, totalRules, kernelId }
 *   Worker → Main: { type: 'batch-validation-result',  total, passed, failed, errors, kernelId }
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

var KERNEL_ID      = 'GOK-VALIDATE-001';
var KERNEL_FAMILY  = 'INPUT_VALIDATION';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;


/* ════════════════════════════════════════════════════════════════
   BUILT-IN VALIDATION RULES (20)
   ════════════════════════════════════════════════════════════════ */

var EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
var URL_RE   = /^https?:\/\/[^\s/$.?#].[^\s]*$/i;
var UUID_RE  = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
var DATE_RE  = /^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})?)?$/;
var ALNUM_RE = /^[a-zA-Z0-9]+$/;

var BUILTIN_RULES = {
  required: function(value) {
    return value !== null && value !== undefined && value !== '';
  },
  minLength: function(value, min) {
    return typeof value === 'string' && value.length >= min;
  },
  maxLength: function(value, max) {
    return typeof value === 'string' && value.length <= max;
  },
  pattern: function(value, pat) {
    var re = (pat instanceof RegExp) ? pat : new RegExp(pat);
    return re.test(String(value));
  },
  min: function(value, threshold) {
    return typeof value === 'number' && value >= threshold;
  },
  max: function(value, threshold) {
    return typeof value === 'number' && value <= threshold;
  },
  email: function(value) {
    return typeof value === 'string' && EMAIL_RE.test(value);
  },
  url: function(value) {
    return typeof value === 'string' && URL_RE.test(value);
  },
  uuid: function(value) {
    return typeof value === 'string' && UUID_RE.test(value);
  },
  date: function(value) {
    return typeof value === 'string' && DATE_RE.test(value) && !isNaN(Date.parse(value));
  },
  enum: function(value, allowed) {
    if (!Array.isArray(allowed)) return false;
    for (var i = 0; i < allowed.length; i++) {
      if (allowed[i] === value) return true;
    }
    return false;
  },
  range: function(value, bounds) {
    if (typeof value !== 'number') return false;
    var lo = (bounds && bounds[0] !== undefined) ? bounds[0] : -Infinity;
    var hi = (bounds && bounds[1] !== undefined) ? bounds[1] : Infinity;
    return value >= lo && value <= hi;
  },
  equals: function(value, expected) {
    return value === expected;
  },
  notEmpty: function(value) {
    if (typeof value === 'string') return value.trim().length > 0;
    if (Array.isArray(value)) return value.length > 0;
    if (value && typeof value === 'object') return Object.keys(value).length > 0;
    return value !== null && value !== undefined;
  },
  alphanumeric: function(value) {
    return typeof value === 'string' && ALNUM_RE.test(value);
  },
  integer: function(value) {
    return typeof value === 'number' && Number.isFinite(value) && Math.floor(value) === value;
  },
  positive: function(value) {
    return typeof value === 'number' && value > 0;
  },
  noSpecialChars: function(value) {
    return typeof value === 'string' && /^[a-zA-Z0-9 _-]+$/.test(value);
  },
  maxItems: function(value, max) {
    return Array.isArray(value) && value.length <= max;
  },
  minItems: function(value, min) {
    return Array.isArray(value) && value.length >= min;
  }
};


/* ════════════════════════════════════════════════════════════════
   CUSTOM RULE REGISTRY
   ════════════════════════════════════════════════════════════════ */

var customRules = {};

function addCustomRule(name, ruleFn) {
  if (typeof ruleFn === 'string') {
    ruleFn = new Function('value', 'params', ruleFn);
  }
  customRules[name] = ruleFn;
  return Object.keys(customRules).length;
}

function evaluateRule(name, value, params) {
  if (customRules[name]) return !!customRules[name](value, params);
  if (BUILTIN_RULES[name]) return !!BUILTIN_RULES[name](value, params);
  return false;
}

function totalRuleCount() {
  return Object.keys(BUILTIN_RULES).length + Object.keys(customRules).length;
}


/* ════════════════════════════════════════════════════════════════
   SCHEMA VALIDATION
   ════════════════════════════════════════════════════════════════ */

function validateSchema(data, schema) {
  var errors = [];
  var fields = Object.keys(schema);
  for (var i = 0; i < fields.length; i++) {
    var field = fields[i];
    var rules = schema[field];
    var value = data ? data[field] : undefined;
    if (!rules || typeof rules !== 'object') continue;
    var ruleNames = Object.keys(rules);
    for (var r = 0; r < ruleNames.length; r++) {
      var ruleName = ruleNames[r];
      var ruleParam = rules[ruleName];
      var passed = false;
      if (BUILTIN_RULES[ruleName]) {
        passed = BUILTIN_RULES[ruleName](value, ruleParam);
      } else if (customRules[ruleName]) {
        passed = !!customRules[ruleName](value, ruleParam);
      } else {
        errors.push({ field: field, rule: ruleName, message: 'Unknown rule: ' + ruleName });
        continue;
      }
      if (!passed) {
        errors.push({
          field: field,
          rule: ruleName,
          message: 'Field "' + field + '" failed rule "' + ruleName + '"',
          value: value,
          expected: ruleParam
        });
      }
    }
  }
  return { valid: errors.length === 0, errors: errors, fieldCount: fields.length };
}


/* ════════════════════════════════════════════════════════════════
   INPUT SANITIZATION
   ════════════════════════════════════════════════════════════════ */

var XSS_PATTERNS = [
  { re: /<script[\s>]/gi,                  name: 'script-tag' },
  { re: /<\/script>/gi,                    name: 'script-close' },
  { re: /javascript\s*:/gi,               name: 'javascript-uri' },
  { re: /\bon\w+\s*=\s*["']?[^"'>]*/gi,   name: 'event-handler' },
  { re: /<iframe[\s>]/gi,                  name: 'iframe-tag' },
  { re: /<object[\s>]/gi,                  name: 'object-tag' },
  { re: /<embed[\s>]/gi,                   name: 'embed-tag' }
];

var SQLI_PATTERNS = [
  { re: /\bDROP\s+TABLE\b/gi,             name: 'drop-table' },
  { re: /\bSELECT\s+.+\s+FROM\b/gi,      name: 'select-from' },
  { re: /\bUNION\s+SELECT\b/gi,           name: 'union-select' },
  { re: /\bINSERT\s+INTO\b/gi,            name: 'insert-into' },
  { re: /\bDELETE\s+FROM\b/gi,            name: 'delete-from' },
  { re: /--\s/g,                           name: 'sql-comment' },
  { re: /;\s*$/g,                          name: 'statement-terminator' }
];

var TRAVERSAL_PATTERNS = [
  { re: /\.\.\//g,                         name: 'dot-dot-slash' },
  { re: /\.\.\\/g,                         name: 'dot-dot-backslash' },
  { re: /%2e%2e[\/\\]/gi,                 name: 'encoded-traversal' }
];

function sanitizeInput(input) {
  if (typeof input !== 'string') {
    return { original: input, sanitized: input, threats: [], threatCount: 0 };
  }
  var threats = [];
  var sanitized = input;
  var allPatterns = [].concat(XSS_PATTERNS, SQLI_PATTERNS, TRAVERSAL_PATTERNS);
  for (var i = 0; i < allPatterns.length; i++) {
    var pat = allPatterns[i];
    if (pat.re.test(sanitized)) {
      threats.push(pat.name);
      pat.re.lastIndex = 0;
      sanitized = sanitized.replace(pat.re, '');
    }
    pat.re.lastIndex = 0;
  }
  sanitized = sanitized.replace(/</g, '&lt;').replace(/>/g, '&gt;');
  return { original: input, sanitized: sanitized, threats: threats, threatCount: threats.length };
}


/* ════════════════════════════════════════════════════════════════
   TYPE CHECKING
   ════════════════════════════════════════════════════════════════ */

function actualType(value) {
  if (value === null) return 'null';
  if (value === undefined) return 'undefined';
  if (Array.isArray(value)) return 'array';
  return typeof value;
}

function checkType(value, expectedType) {
  var at = actualType(value);
  var valid = false;
  switch (expectedType) {
    case 'string':  valid = at === 'string'; break;
    case 'number':  valid = at === 'number' && !isNaN(value); break;
    case 'boolean': valid = at === 'boolean'; break;
    case 'array':   valid = at === 'array'; break;
    case 'object':  valid = at === 'object' && !Array.isArray(value) && value !== null; break;
    case 'email':   valid = at === 'string' && EMAIL_RE.test(value); break;
    case 'url':     valid = at === 'string' && URL_RE.test(value); break;
    case 'uuid':    valid = at === 'string' && UUID_RE.test(value); break;
    case 'date':    valid = at === 'string' && DATE_RE.test(value) && !isNaN(Date.parse(value)); break;
    case 'integer': valid = at === 'number' && Number.isFinite(value) && Math.floor(value) === value; break;
    case 'float':   valid = at === 'number' && Number.isFinite(value); break;
    default:        valid = at === expectedType;
  }
  return { value: value, expectedType: expectedType, actualType: at, valid: valid };
}


/* ════════════════════════════════════════════════════════════════
   BATCH VALIDATION
   ════════════════════════════════════════════════════════════════ */

function batchValidate(items, schema) {
  if (!Array.isArray(items)) {
    return { total: 0, passed: 0, failed: 0, errors: [{ index: -1, message: 'Items must be an array' }] };
  }
  var passed = 0;
  var failed = 0;
  var allErrors = [];
  for (var i = 0; i < items.length; i++) {
    var result = validateSchema(items[i], schema);
    if (result.valid) {
      passed++;
    } else {
      failed++;
      for (var e = 0; e < result.errors.length; e++) {
        allErrors.push({
          index: i,
          field: result.errors[e].field,
          rule: result.errors[e].rule,
          message: result.errors[e].message
        });
      }
    }
  }
  return { total: items.length, passed: passed, failed: failed, errors: allErrors };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'validate': {
      var vResult = validateSchema(msg.data || {}, msg.schema || {});
      self.postMessage({
        type: 'validation-result',
        valid: vResult.valid,
        errors: vResult.errors,
        fieldCount: vResult.fieldCount,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'sanitize': {
      var sResult = sanitizeInput(msg.input);
      self.postMessage({
        type: 'sanitized',
        original: sResult.original,
        sanitized: sResult.sanitized,
        threats: sResult.threats,
        threatCount: sResult.threatCount,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'type-check': {
      var tResult = checkType(msg.value, msg.expectedType);
      self.postMessage({
        type: 'type-result',
        value: tResult.value,
        expectedType: tResult.expectedType,
        valid: tResult.valid,
        actualType: tResult.actualType,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'add-rule': {
      var count = addCustomRule(msg.name, msg.rule);
      self.postMessage({
        type: 'rule-added',
        name: msg.name,
        totalRules: count + Object.keys(BUILTIN_RULES).length,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'batch-validate': {
      var bResult = batchValidate(msg.items || [], msg.schema || {});
      self.postMessage({
        type: 'batch-validation-result',
        total: bResult.total,
        passed: bResult.passed,
        failed: bResult.failed,
        errors: bResult.errors,
        kernelId: KERNEL_ID
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'validate-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        builtinRules: Object.keys(BUILTIN_RULES).length,
        customRules: Object.keys(customRules).length,
        totalRules: totalRuleCount(),
        beat: beatCount,
        phase: kernelPhase,
        phi: PHI,
        running: running,
        timestamp: Date.now()
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
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase
  });
}, HEARTBEAT);
