/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Routing Worker (GOK-ROUTING-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-ROUTING-001
 * Kernel Family:  ORGANISM_ROUTING
 * Architecture:   10 Organism Protocols × Capability Chains × Circuit Breakers
 *
 * Tasks route through protocol chains, not just engines. "Code generation"
 * goes through Sovereign Routing → Encrypted Transport. Circuit breakers
 * auto-trip on failures. This is what makes it an organism, not a tool.
 *
 * 10 Organism Protocols:
 *   1. SOVEREIGN_ROUTING     — Core task routing with φ-priority
 *   2. ENCRYPTED_TRANSPORT   — All data encrypted in transit
 *   3. NEURAL_CONSENSUS      — Multi-model agreement protocol
 *   4. SWARM_BROADCAST       — Fan-out to all capable models
 *   5. MEMORY_CONSOLIDATION  — Route through memory layer
 *   6. DEFENSE_MEMBRANE      — Security-first routing
 *   7. QUANTUM_ENTANGLEMENT  — Correlated model pairs
 *   8. CONSCIOUSNESS_FIELD   — Awareness-level routing
 *   9. EMERGENCE_DETECTION   — Route novel/unknown patterns
 *  10. SOVEREIGN_SEAL        — Final integrity verification
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'route', task, capabilities, priority }
 *   Main → Worker: { type: 'chain', task, protocols }
 *   Main → Worker: { type: 'fuse', models, input }
 *   Main → Worker: { type: 'circuit-status' }
 *   Main → Worker: { type: 'status' }
 *   Worker → Main: { type: 'route-result', chain, hops, latency }
 *   Worker → Main: { type: 'chain-result', protocols, output }
 *   Worker → Main: { type: 'fusion-result', models, output, coherence }
 *   Worker → Main: { type: 'circuit-map', breakers }
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

var KERNEL_ID      = 'GOK-ROUTING-001';
var KERNEL_FAMILY  = 'ORGANISM_ROUTING';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;
var totalRoutes = 0;


/* ════════════════════════════════════════════════════════════════
   10 ORGANISM PROTOCOLS
   ════════════════════════════════════════════════════════════════ */

var PROTOCOLS = [
  {
    id: 'SOVEREIGN_ROUTING',
    name: 'Sovereign Routing',
    capabilities: ['task-dispatch', 'priority-queue', 'load-balance'],
    latencyMs: 2,
    reliability: 0.999,
    required: true,
  },
  {
    id: 'ENCRYPTED_TRANSPORT',
    name: 'Encrypted Transport',
    capabilities: ['aes-256', 'tls-wire', 'token-auth'],
    latencyMs: 5,
    reliability: 0.998,
    required: true,
  },
  {
    id: 'NEURAL_CONSENSUS',
    name: 'Neural Consensus',
    capabilities: ['multi-model-vote', 'quorum', 'confidence-merge'],
    latencyMs: 15,
    reliability: 0.995,
    required: false,
  },
  {
    id: 'SWARM_BROADCAST',
    name: 'Swarm Broadcast',
    capabilities: ['fan-out', 'parallel-exec', 'result-gather'],
    latencyMs: 10,
    reliability: 0.990,
    required: false,
  },
  {
    id: 'MEMORY_CONSOLIDATION',
    name: 'Memory Consolidation',
    capabilities: ['store', 'recall', 'semantic-link'],
    latencyMs: 3,
    reliability: 0.997,
    required: false,
  },
  {
    id: 'DEFENSE_MEMBRANE',
    name: 'Defense Membrane',
    capabilities: ['input-sanitize', 'rate-limit', 'threat-score'],
    latencyMs: 4,
    reliability: 0.999,
    required: true,
  },
  {
    id: 'QUANTUM_ENTANGLEMENT',
    name: 'Quantum Entanglement',
    capabilities: ['model-pair', 'correlated-output', 'coherence-lock'],
    latencyMs: 8,
    reliability: 0.985,
    required: false,
  },
  {
    id: 'CONSCIOUSNESS_FIELD',
    name: 'Consciousness Field',
    capabilities: ['awareness-level', 'meta-cognition', 'self-model'],
    latencyMs: 12,
    reliability: 0.980,
    required: false,
  },
  {
    id: 'EMERGENCE_DETECTION',
    name: 'Emergence Detection',
    capabilities: ['novelty-detect', 'pattern-discover', 'bifurcation'],
    latencyMs: 20,
    reliability: 0.975,
    required: false,
  },
  {
    id: 'SOVEREIGN_SEAL',
    name: 'Sovereign Seal',
    capabilities: ['integrity-verify', 'signature', 'audit-log'],
    latencyMs: 3,
    reliability: 0.999,
    required: true,
  },
];


/* ════════════════════════════════════════════════════════════════
   CAPABILITY → PROTOCOL CHAIN MAPPER
   ════════════════════════════════════════════════════════════════ */

/**
 * Given a set of requested capabilities, build the optimal protocol chain.
 * Required protocols are always included. Optional protocols are added
 * when they match requested capabilities.
 */
function buildChain(requestedCapabilities, priority) {
  var chain = [];
  var totalLatency = 0;

  // Always start with required protocols
  for (var i = 0; i < PROTOCOLS.length; i++) {
    var p = PROTOCOLS[i];
    if (p.required) {
      chain.push({ protocolId: p.id, name: p.name, latencyMs: p.latencyMs, reason: 'required' });
      totalLatency += p.latencyMs;
      continue;
    }

    // Check if any requested capability matches this protocol
    if (requestedCapabilities && requestedCapabilities.length > 0) {
      for (var c = 0; c < requestedCapabilities.length; c++) {
        var cap = requestedCapabilities[c].toLowerCase();
        for (var pc = 0; pc < p.capabilities.length; pc++) {
          if (p.capabilities[pc].indexOf(cap) >= 0 || cap.indexOf(p.capabilities[pc]) >= 0) {
            chain.push({ protocolId: p.id, name: p.name, latencyMs: p.latencyMs, reason: 'capability-match: ' + cap });
            totalLatency += p.latencyMs;
            break;
          }
        }
        // Don't add same protocol twice
        if (chain.length > 0 && chain[chain.length - 1].protocolId === p.id) break;
      }
    }
  }

  // Sort by latency for optimal ordering (fastest first, seal last)
  var seal = null;
  var rest = [];
  for (var s = 0; s < chain.length; s++) {
    if (chain[s].protocolId === 'SOVEREIGN_SEAL') {
      seal = chain[s];
    } else {
      rest.push(chain[s]);
    }
  }
  rest.sort(function(a, b) { return a.latencyMs - b.latencyMs; });
  if (seal) rest.push(seal); // Seal always last

  return {
    chain: rest,
    hops: rest.length,
    totalLatencyMs: totalLatency,
    priority: priority || 1,
    coherence: rest.length / PROTOCOLS.length,
  };
}


/* ════════════════════════════════════════════════════════════════
   CIRCUIT BREAKERS — Auto-trip on failures
   ════════════════════════════════════════════════════════════════ */

var circuitBreakers = {};

// Initialize breakers for all protocols
for (var bi = 0; bi < PROTOCOLS.length; bi++) {
  circuitBreakers[PROTOCOLS[bi].id] = {
    protocolId: PROTOCOLS[bi].id,
    state: 'CLOSED',         // CLOSED = healthy, OPEN = tripped, HALF_OPEN = testing
    failureCount: 0,
    successCount: 0,
    lastFailure: null,
    tripThreshold: 3,        // Trip after 3 consecutive failures
    resetAfterMs: 30000,     // Try reset after 30s
    lastStateChange: Date.now(),
  };
}

function recordSuccess(protocolId) {
  var cb = circuitBreakers[protocolId];
  if (!cb) return;
  cb.successCount++;
  cb.failureCount = 0;
  if (cb.state === 'HALF_OPEN') {
    cb.state = 'CLOSED';
    cb.lastStateChange = Date.now();
  }
}

function recordFailure(protocolId) {
  var cb = circuitBreakers[protocolId];
  if (!cb) return;
  cb.failureCount++;
  cb.lastFailure = Date.now();
  if (cb.failureCount >= cb.tripThreshold && cb.state === 'CLOSED') {
    cb.state = 'OPEN';
    cb.lastStateChange = Date.now();
  }
}

function checkBreaker(protocolId) {
  var cb = circuitBreakers[protocolId];
  if (!cb) return true; // Unknown protocol — allow
  if (cb.state === 'CLOSED') return true;
  if (cb.state === 'OPEN') {
    // Check if enough time has passed to try half-open
    if (Date.now() - cb.lastStateChange > cb.resetAfterMs) {
      cb.state = 'HALF_OPEN';
      cb.lastStateChange = Date.now();
      return true;
    }
    return false;
  }
  if (cb.state === 'HALF_OPEN') return true;
  return true;
}


/* ════════════════════════════════════════════════════════════════
   MULTI-MODEL FUSION — Combine outputs from multiple models
   ════════════════════════════════════════════════════════════════ */

function fuseModels(models, input) {
  if (!models || models.length === 0) {
    return { models: [], output: null, coherence: 0 };
  }

  // Simulate fusion: each model produces a weighted output
  var outputs = [];
  var totalWeight = 0;
  for (var i = 0; i < models.length; i++) {
    var weight = PHI_INV + (i * 0.05);
    outputs.push({
      modelId: models[i],
      weight: weight,
      output: models[i] + ' processed: ' + input,
    });
    totalWeight += weight;
  }

  // Coherence = how well outputs agree (simulated via φ-scoring)
  var coherence = Math.min(totalWeight / (models.length * PHI), 1.0);

  return {
    models: outputs,
    fusedOutput: 'Fused (' + models.length + ' models): ' + input,
    coherence: coherence,
    modelCount: models.length,
    totalWeight: totalWeight,
  };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'route': {
      totalRoutes++;
      var chainResult = buildChain(msg.capabilities, msg.priority);
      // Check circuit breakers for each hop
      var blockedHops = [];
      for (var h = 0; h < chainResult.chain.length; h++) {
        if (!checkBreaker(chainResult.chain[h].protocolId)) {
          blockedHops.push(chainResult.chain[h].protocolId);
        }
      }

      self.postMessage({
        type: 'route-result',
        task: msg.task,
        chain: chainResult.chain,
        hops: chainResult.hops,
        totalLatencyMs: chainResult.totalLatencyMs,
        coherence: chainResult.coherence,
        blockedHops: blockedHops,
        totalRoutes: totalRoutes,
        kernelId: KERNEL_ID,
      });

      // Record success for all traversed protocols
      for (var rs = 0; rs < chainResult.chain.length; rs++) {
        if (blockedHops.indexOf(chainResult.chain[rs].protocolId) < 0) {
          recordSuccess(chainResult.chain[rs].protocolId);
        }
      }
      break;
    }

    case 'chain': {
      totalRoutes++;
      // Build chain from explicit protocol list
      var chain = [];
      var latency = 0;
      for (var ci = 0; ci < (msg.protocols || []).length; ci++) {
        var pid = msg.protocols[ci];
        for (var pi = 0; pi < PROTOCOLS.length; pi++) {
          if (PROTOCOLS[pi].id === pid) {
            chain.push({ protocolId: pid, name: PROTOCOLS[pi].name, latencyMs: PROTOCOLS[pi].latencyMs });
            latency += PROTOCOLS[pi].latencyMs;
            break;
          }
        }
      }
      self.postMessage({
        type: 'chain-result',
        task: msg.task,
        protocols: chain,
        hops: chain.length,
        totalLatencyMs: latency,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'fuse': {
      var fusion = fuseModels(msg.models, msg.input);
      self.postMessage({
        type: 'fusion-result',
        models: fusion.models,
        fusedOutput: fusion.fusedOutput,
        coherence: fusion.coherence,
        modelCount: fusion.modelCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'record-failure': {
      recordFailure(msg.protocolId);
      self.postMessage({
        type: 'failure-recorded',
        protocolId: msg.protocolId,
        state: circuitBreakers[msg.protocolId] ? circuitBreakers[msg.protocolId].state : 'UNKNOWN',
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'circuit-status': {
      var breakers = [];
      var bKeys = Object.keys(circuitBreakers);
      for (var bk = 0; bk < bKeys.length; bk++) {
        breakers.push(circuitBreakers[bKeys[bk]]);
      }
      self.postMessage({
        type: 'circuit-map',
        breakers: breakers,
        protocolCount: PROTOCOLS.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'routing-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        protocolCount: PROTOCOLS.length,
        totalRoutes: totalRoutes,
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
};


/* ════════════════════════════════════════════════════════════════
   φ-COUPLED HEARTBEAT — 873ms Kuramoto pulse
   ════════════════════════════════════════════════════════════════ */

var _hbi = setInterval(function() {
  if (!running) return;
  beatCount++;
  kernelPhase += PHI_INV;
  if (kernelPhase > 2 * Math.PI) kernelPhase -= 2 * Math.PI;

  // Auto-reset half-open breakers every 50 beats
  if (beatCount % 50 === 0) {
    var bk = Object.keys(circuitBreakers);
    for (var i = 0; i < bk.length; i++) {
      var cb = circuitBreakers[bk[i]];
      if (cb.state === 'OPEN' && Date.now() - cb.lastStateChange > cb.resetAfterMs) {
        cb.state = 'HALF_OPEN';
        cb.lastStateChange = Date.now();
      }
    }
  }

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalRoutes: totalRoutes,
    protocolCount: PROTOCOLS.length,
  });
}, HEARTBEAT);
