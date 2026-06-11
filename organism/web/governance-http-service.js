/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA GOVERNANCE HTTP SERVICE — SOVEREIGN CPL-F WORKER
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * ALL RIGHTS RESERVED — TRADE SECRET — PROPRIETARY
 *
 * Kernel ID: GOL-GOV-001
 * Family: GUBERNATIO_AETERNA (Eternal Governance)
 *
 * This is the governance HTTP service worker — a sovereign SERVITOR that
 * exposes governance protocol endpoints over HTTP. It bridges the on-chain
 * governance (Motoko canisters) with external HTTP consumers.
 *
 * Endpoints:
 *   GET  /health           — 873ms heartbeat status
 *   GET  /governance/status — Full governance state
 *   GET  /governance/epoch  — Current epoch information
 *   POST /governance/evaluate — Evaluate an action against ethics + policies
 *   GET  /governance/principles — List ethical principles
 *   GET  /governance/policies — List active policies
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══ §1 — SACRED CONSTANTS ═══
const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const HEARTBEAT_MS = 873;
const EPOCH_HEARTBEATS = 1000;
const EPOCH_MS = EPOCH_HEARTBEATS * HEARTBEAT_MS;

// ═══ §2 — KERNEL IDENTITY ═══
const KERNEL = {
  id: 'GOL-GOV-001',
  name: 'GOVERNANCE-HTTP-SERVITOR',
  family: 'GUBERNATIO_AETERNA',
  version: '1.0.0',
  birthTimestamp: Date.now(),
};

// ═══ §3 — COR PARVUM (873ms MiniHeart) ═══
let heartbeatCount = 0;
let lastHeartbeat = Date.now();

function corParvum() {
  heartbeatCount++;
  lastHeartbeat = Date.now();
}

// Start heartbeat
const heartbeatInterval = setInterval(corParvum, HEARTBEAT_MS);

// ═══ §4 — ETHICAL PRINCIPLES ═══
const PRINCIPLES = {
  NON_MALEFICENCE: { weight: PHI, threshold: 0.95, latin: 'PRIMUM NON NOCERE' },
  BENEFICENCE: { weight: 1.0, threshold: 0.7, latin: 'BONUM FACERE' },
  AUTONOMY: { weight: PHI_INV, threshold: 0.6, latin: 'LIBERTAS VOLUNTATIS' },
  JUSTICE: { weight: PHI, threshold: 0.8, latin: 'IUSTITIA PERPETUA' },
  TRANSPARENCY: { weight: 1.0, threshold: 0.75, latin: 'LUX VERITATIS' },
  PRIVACY: { weight: PHI, threshold: 0.9, latin: 'SANCTITAS PRIVATA' },
  ACCOUNTABILITY: { weight: PHI_INV, threshold: 0.85, latin: 'RATIO REDDENDA' },
  SUSTAINABILITY: { weight: AMOR, threshold: 0.5, latin: 'PERPETUITAS VITAE' },
};

// ═══ §5 — GOVERNANCE STATE ═══
const governanceState = {
  state: 'ACTIVE',
  genesisTimestamp: Date.now(),
  policies: [],
  ethicsLog: [],
  epoch: 0,
};

function currentEpoch() {
  return Math.floor((Date.now() - governanceState.genesisTimestamp) / EPOCH_MS);
}

function epochProgress() {
  return ((Date.now() - governanceState.genesisTimestamp) % EPOCH_MS) / EPOCH_MS;
}

// ═══ §6 — ETHICS ENGINE ═══
function evaluateEthics(action, scores) {
  // Check veto
  for (const [principle, config] of Object.entries(PRINCIPLES)) {
    const score = scores[principle] !== undefined ? scores[principle] : 0;
    if (score < config.threshold) {
      return { vetoed: true, principle, score, threshold: config.threshold, action };
    }
  }

  // Compute overall score
  let weightedSum = 0;
  let totalWeight = 0;
  for (const [principle, config] of Object.entries(PRINCIPLES)) {
    const score = scores[principle] !== undefined ? scores[principle] : 0;
    weightedSum += score * config.weight;
    totalWeight += config.weight;
  }

  const overallScore = totalWeight > 0 ? weightedSum / totalWeight : 0;
  return { vetoed: false, overallScore, action };
}

// ═══ §7 — HTTP SERVICE (Cloudflare Workers / Node.js compatible) ═══

function handleRequest(request) {
  const url = new URL(request.url, 'http://localhost');
  const path = url.pathname;
  const method = request.method;

  // CORS
  const headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'X-Kernel-ID': KERNEL.id,
    'X-Heartbeat': String(HEARTBEAT_MS),
    'X-Family': KERNEL.family,
  };

  if (method === 'OPTIONS') {
    return new Response(null, { status: 204, headers });
  }

  // Route: Health
  if (path === '/health' && method === 'GET') {
    return new Response(JSON.stringify({
      status: 'ALIVE',
      kernel: KERNEL.id,
      family: KERNEL.family,
      heartbeat: HEARTBEAT_MS,
      heartbeats: heartbeatCount,
      uptime: Date.now() - KERNEL.birthTimestamp,
      phi: PHI,
    }, null, 2), { status: 200, headers });
  }

  // Route: Governance Status
  if (path === '/governance/status' && method === 'GET') {
    return new Response(JSON.stringify({
      kernel: KERNEL,
      state: governanceState.state,
      epoch: currentEpoch(),
      epochProgress: epochProgress(),
      policies: governanceState.policies.length,
      ethicsEvaluations: governanceState.ethicsLog.length,
      heartbeats: heartbeatCount,
      constants: { PHI, PHI_INV, AMOR, HEARTBEAT_MS, EPOCH_MS },
    }, null, 2), { status: 200, headers });
  }

  // Route: Epoch
  if (path === '/governance/epoch' && method === 'GET') {
    const epoch = currentEpoch();
    const progress = epochProgress();
    return new Response(JSON.stringify({
      epoch,
      progress,
      epochDurationMs: EPOCH_MS,
      epochHeartbeats: EPOCH_HEARTBEATS,
      nextEpochIn: Math.ceil((1 - progress) * EPOCH_MS),
      totalHeartbeats: heartbeatCount,
    }, null, 2), { status: 200, headers });
  }

  // Route: Principles
  if (path === '/governance/principles' && method === 'GET') {
    return new Response(JSON.stringify({
      count: Object.keys(PRINCIPLES).length,
      principles: PRINCIPLES,
      description: 'Immutable ethical principles — cannot be amended or overridden',
    }, null, 2), { status: 200, headers });
  }

  // Route: Policies
  if (path === '/governance/policies' && method === 'GET') {
    return new Response(JSON.stringify({
      count: governanceState.policies.length,
      policies: governanceState.policies,
    }, null, 2), { status: 200, headers });
  }

  // Route: Evaluate action
  if (path === '/governance/evaluate' && method === 'POST') {
    return request.json().then(body => {
      const result = evaluateEthics(body.action || 'unknown', body.scores || {});
      governanceState.ethicsLog.push({ ...result, timestamp: Date.now() });
      return new Response(JSON.stringify(result, null, 2), { status: 200, headers });
    }).catch(() => {
      return new Response(JSON.stringify({ error: 'INVALID_JSON' }, null, 2), { status: 400, headers });
    });
  }

  // 404
  return new Response(JSON.stringify({
    error: 'NOT_FOUND',
    path,
    availableEndpoints: [
      'GET /health',
      'GET /governance/status',
      'GET /governance/epoch',
      'GET /governance/principles',
      'GET /governance/policies',
      'POST /governance/evaluate',
    ],
  }, null, 2), { status: 404, headers });
}

// ═══ §8 — WORKER EXPORT (Cloudflare Workers compatible) ═══
if (typeof addEventListener !== 'undefined') {
  addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request));
  });
}

// ═══ §9 — NODE.JS STANDALONE (for local development) ═══
if (typeof require !== 'undefined' && typeof module !== 'undefined') {
  if (require.main === module) {
    const http = require('http');
    const PORT = parseInt(process.env.PORT) || 8873;

    const server = http.createServer(async (req, res) => {
      // Adapt Node.js request to fetch-like interface
      let body = '';
      req.on('data', chunk => { body += chunk; });
      req.on('end', async () => {
        const request = {
          url: `http://localhost:${PORT}${req.url}`,
          method: req.method,
          json: () => Promise.resolve(body ? JSON.parse(body) : {}),
        };

        const response = await handleRequest(request);
        const responseBody = await response.text();
        const responseHeaders = {};
        response.headers.forEach((value, key) => { responseHeaders[key] = value; });

        res.writeHead(response.status, responseHeaders);
        res.end(responseBody);
      });
    });

    server.listen(PORT, () => {
      console.log(`═══════════════════════════════════════════════════════`);
      console.log(`  NOVA GOVERNANCE HTTP SERVITOR`);
      console.log(`  Kernel: ${KERNEL.id} (${KERNEL.family})`);
      console.log(`  Port: ${PORT}`);
      console.log(`  Heartbeat: ${HEARTBEAT_MS}ms`);
      console.log(`  φ = ${PHI}`);
      console.log(`═══════════════════════════════════════════════════════`);
    });
  }

  module.exports = { handleRequest, evaluateEthics, PRINCIPLES, KERNEL };
}
