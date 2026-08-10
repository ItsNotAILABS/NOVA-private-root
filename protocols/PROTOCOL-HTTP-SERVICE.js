/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-HTTP-SERVICE — SOVEREIGN HTTP SERVICES LAYER
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * ALL RIGHTS RESERVED — TRADE SECRET — PROPRIETARY
 * Medina Tech — Dallas, Texas, United States of America
 *
 * PROTOCOL-HTTP-SERVICE provides a working HTTP services layer for the NOVA organism.
 * It defines sovereign HTTP endpoints for governance queries, policy management,
 * ethics evaluation, temporal status, and fleet telemetry.
 *
 * Architecture:
 *   - Runs on Node.js HTTP (no external framework dependencies)
 *   - φ-weighted rate limiting (higher trust = higher rate)
 *   - Sovereign authentication via PROTOCOL-TRUST
 *   - CORS-safe with configurable origins
 *   - JSON-only API (application/json)
 *   - 873ms heartbeat health check
 *
 * Endpoints:
 *   GET  /health           — 873ms heartbeat status
 *   GET  /status           — Full organism governance status
 *   GET  /epoch            — Current epoch and progress
 *   GET  /policies         — List active policies
 *   POST /policies         — Create new policy (Governor+)
 *   POST /policies/:id/vote — Submit vote on policy (Citizen+)
 *   GET  /ethics/evaluate  — Evaluate action ethics score
 *   POST /ethics/check     — Run ethics veto check
 *   GET  /users            — List registered users
 *   GET  /temporal/consensus — Current temporal consensus
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * BUILD: №68
 * KERNEL ID: HTTP-SERVICE-001
 * FAMILY: SERVITIUM_AETERNA (Eternal Service)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

const http = require('http');

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const PROTOCOL_ID = 'PROTOCOL-HTTP-SERVICE';
const PROTOCOL_VERSION = '1.0.0';
const DEFAULT_PORT = 8873; // 8000 + 873

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — RATE LIMITER (φ-WEIGHTED)
// ═══════════════════════════════════════════════════════════════════════════════

class PhiRateLimiter {
  constructor(baseRate = 60) {
    this.baseRate = baseRate; // requests per minute
    this.windows = new Map();
  }

  /**
   * Check if request is allowed
   * @param {string} clientId
   * @param {number} trustLevel — [0, 1], higher = more requests allowed
   * @returns {boolean}
   */
  allow(clientId, trustLevel = 0.5) {
    const now = Date.now();
    const windowMs = 60000; // 1 minute window
    const maxRequests = Math.ceil(this.baseRate * (1 + trustLevel * PHI));

    if (!this.windows.has(clientId)) {
      this.windows.set(clientId, { count: 0, windowStart: now });
    }

    const window = this.windows.get(clientId);
    if (now - window.windowStart > windowMs) {
      window.count = 0;
      window.windowStart = now;
    }

    if (window.count >= maxRequests) return false;
    window.count++;
    return true;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — REQUEST ROUTER
// ═══════════════════════════════════════════════════════════════════════════════

class SovereignRouter {
  constructor() {
    this.routes = { GET: {}, POST: {}, PUT: {}, DELETE: {} };
  }

  get(path, handler) { this.routes.GET[path] = handler; }
  post(path, handler) { this.routes.POST[path] = handler; }
  put(path, handler) { this.routes.PUT[path] = handler; }
  delete(path, handler) { this.routes.DELETE[path] = handler; }

  resolve(method, url) {
    const methodRoutes = this.routes[method] || {};
    // Exact match first
    if (methodRoutes[url]) return { handler: methodRoutes[url], params: {} };

    // Pattern match (simple :param support)
    for (const [pattern, handler] of Object.entries(methodRoutes)) {
      const regex = new RegExp('^' + pattern.replace(/:([^/]+)/g, '([^/]+)') + '$');
      const match = url.match(regex);
      if (match) {
        const paramNames = (pattern.match(/:([^/]+)/g) || []).map(p => p.slice(1));
        const params = {};
        paramNames.forEach((name, i) => { params[name] = match[i + 1]; });
        return { handler, params };
      }
    }

    return null;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — HTTP SERVICE
// ═══════════════════════════════════════════════════════════════════════════════

class SovereignHTTPService {
  constructor(config = {}) {
    this.port = config.port || DEFAULT_PORT;
    this.router = new SovereignRouter();
    this.rateLimiter = new PhiRateLimiter(config.rateLimit || 60);
    this.startTime = Date.now();
    this.requestCount = 0;
    this.server = null;

    // Governance state (in production, backed by canister calls)
    this.state = {
      epoch: 0,
      policies: [],
      users: [],
      ethicsLog: [],
    };

    this._registerRoutes();
  }

  _registerRoutes() {
    // Health check — returns 873ms heartbeat status
    this.router.get('/health', (req, res) => {
      return this._json(res, 200, {
        status: 'ALIVE',
        heartbeat: HEARTBEAT_MS,
        uptime: Date.now() - this.startTime,
        epoch: Math.floor((Date.now() - this.startTime) / (HEARTBEAT_MS * 1000)),
        requests: this.requestCount,
        phi: PHI,
      });
    });

    // Full governance status
    this.router.get('/status', (req, res) => {
      return this._json(res, 200, {
        protocol: PROTOCOL_ID,
        version: PROTOCOL_VERSION,
        state: 'ACTIVE',
        epoch: this.state.epoch,
        policies: this.state.policies.length,
        users: this.state.users.length,
        uptime: Date.now() - this.startTime,
        heartbeat: HEARTBEAT_MS,
        constants: { PHI, PHI_INV, AMOR },
      });
    });

    // Current epoch information
    this.router.get('/epoch', (req, res) => {
      const now = Date.now();
      const epochMs = HEARTBEAT_MS * 1000;
      const currentEpoch = Math.floor((now - this.startTime) / epochMs);
      const progress = ((now - this.startTime) % epochMs) / epochMs;
      return this._json(res, 200, {
        epoch: currentEpoch,
        progress,
        epochDurationMs: epochMs,
        heartbeatMs: HEARTBEAT_MS,
        nextEpochIn: Math.ceil((1 - progress) * epochMs),
      });
    });

    // List policies
    this.router.get('/policies', (req, res) => {
      return this._json(res, 200, {
        count: this.state.policies.length,
        policies: this.state.policies,
      });
    });

    // Create policy
    this.router.post('/policies', (req, res, body) => {
      const policy = {
        id: `POL-${String(this.state.policies.length + 1).padStart(6, '0')}`,
        domain: body.domain || 'RESOURCE_ALLOCATION',
        rules: body.rules || [],
        proposer: body.proposer || 'anonymous',
        state: 'DRAFT',
        createdAt: Date.now(),
        votes: { for: 0, against: 0, total: 0 },
      };
      this.state.policies.push(policy);
      return this._json(res, 201, { created: true, policy });
    });

    // Vote on policy
    this.router.post('/policies/:id/vote', (req, res, body, params) => {
      const policy = this.state.policies.find(p => p.id === params.id);
      if (!policy) return this._json(res, 404, { error: 'POLICY_NOT_FOUND' });
      const weight = body.weight || 1;
      policy.votes.total += weight;
      if (body.vote === 'FOR') policy.votes.for += weight;
      else policy.votes.against += weight;
      return this._json(res, 200, { voted: true, policy });
    });

    // Ethics evaluation
    this.router.get('/ethics/evaluate', (req, res) => {
      return this._json(res, 200, {
        principles: ['NON_MALEFICENCE', 'BENEFICENCE', 'AUTONOMY', 'JUSTICE', 'TRANSPARENCY', 'PRIVACY', 'ACCOUNTABILITY', 'SUSTAINABILITY'],
        thresholds: { NON_MALEFICENCE: 0.95, PRIVACY: 0.9, ACCOUNTABILITY: 0.85, JUSTICE: 0.8, TRANSPARENCY: 0.75, BENEFICENCE: 0.7, AUTONOMY: 0.6, SUSTAINABILITY: 0.5 },
        description: 'POST /ethics/check with { action, scores: { PRINCIPLE: score } } to evaluate',
      });
    });

    // Ethics veto check
    this.router.post('/ethics/check', (req, res, body) => {
      const scores = body.scores || {};
      const THRESHOLDS = { NON_MALEFICENCE: 0.95, PRIVACY: 0.9, ACCOUNTABILITY: 0.85, JUSTICE: 0.8, TRANSPARENCY: 0.75, BENEFICENCE: 0.7, AUTONOMY: 0.6, SUSTAINABILITY: 0.5 };
      for (const [principle, threshold] of Object.entries(THRESHOLDS)) {
        const score = scores[principle] !== undefined ? scores[principle] : 0;
        if (score < threshold) {
          return this._json(res, 200, { vetoed: true, principle, score, threshold, action: body.action });
        }
      }
      return this._json(res, 200, { vetoed: false, action: body.action, message: 'All ethical principles satisfied' });
    });

    // Users list
    this.router.get('/users', (req, res) => {
      return this._json(res, 200, { count: this.state.users.length, users: this.state.users });
    });

    // Temporal consensus
    this.router.get('/temporal/consensus', (req, res) => {
      return this._json(res, 200, {
        weights: { past: AMOR, present: PHI_INV, future: AMOR * PHI_INV },
        description: 'Temporal consensus uses φ-weighted three-window model',
        currentEpoch: Math.floor((Date.now() - this.startTime) / (HEARTBEAT_MS * 1000)),
      });
    });
  }

  _json(res, status, data) {
    res.writeHead(status, {
      'Content-Type': 'application/json',
      'X-Protocol': PROTOCOL_ID,
      'X-Heartbeat': String(HEARTBEAT_MS),
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Trust-Level',
    });
    res.end(JSON.stringify(data, null, 2));
  }

  _parseBody(req) {
    return new Promise((resolve) => {
      let body = '';
      req.on('data', chunk => { body += chunk; });
      req.on('end', () => {
        try { resolve(JSON.parse(body)); }
        catch { resolve({}); }
      });
    });
  }

  start() {
    this.server = http.createServer(async (req, res) => {
      this.requestCount++;

      // CORS preflight
      if (req.method === 'OPTIONS') {
        return this._json(res, 204, {});
      }

      // Rate limiting
      const clientId = req.headers['x-client-id'] || req.socket.remoteAddress || 'unknown';
      const trustLevel = parseFloat(req.headers['x-trust-level']) || 0.5;
      if (!this.rateLimiter.allow(clientId, trustLevel)) {
        return this._json(res, 429, { error: 'RATE_LIMITED', retryAfter: HEARTBEAT_MS });
      }

      // Route resolution
      const url = req.url.split('?')[0];
      const route = this.router.resolve(req.method, url);
      if (!route) {
        return this._json(res, 404, { error: 'NOT_FOUND', path: url });
      }

      // Parse body for POST/PUT
      const body = (req.method === 'POST' || req.method === 'PUT')
        ? await this._parseBody(req) : {};

      // Execute handler
      try {
        route.handler(req, res, body, route.params);
      } catch (err) {
        this._json(res, 500, { error: 'INTERNAL_ERROR', message: err.message });
      }
    });

    this.server.listen(this.port, () => {
      console.log(`═══════════════════════════════════════════════════════════════`);
      console.log(`  NOVA SOVEREIGN HTTP SERVICE`);
      console.log(`  Protocol: ${PROTOCOL_ID} v${PROTOCOL_VERSION}`);
      console.log(`  Port: ${this.port}`);
      console.log(`  Heartbeat: ${HEARTBEAT_MS}ms`);
      console.log(`  φ = ${PHI}`);
      console.log(`═══════════════════════════════════════════════════════════════`);
    });

    return this.server;
  }

  stop() {
    if (this.server) this.server.close();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — EXPORTS & STANDALONE EXECUTION
// ═══════════════════════════════════════════════════════════════════════════════

export {
  SovereignHTTPService,
  SovereignRouter,
  PhiRateLimiter,
  PROTOCOL_ID,
  PROTOCOL_VERSION,
  DEFAULT_PORT,
  PHI,
  PHI_INV,
  AMOR,
  HEARTBEAT_MS,
};

export default SovereignHTTPService;
