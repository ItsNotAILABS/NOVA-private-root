/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Registry Worker (GOK-REGISTRY-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-REGISTRY-001
 * Kernel Family:  SERVICE_REGISTRY
 * Architecture:   Service Discovery × Dependency Graph × Semver × Health Checks
 *
 * Central service registry for the NOVA organism. Every worker, canister
 * endpoint, and SDK service registers here. Supports dependency resolution
 * via topological sort, semver-based version management, capability-based
 * discovery, and periodic health checks.
 *
 * Features:
 *   • Service registration with capabilities and version
 *   • Dependency resolution via topological sort (Kahn's algorithm)
 *   • Semver comparison for version constraints
 *   • Capability-based service discovery
 *   • Health check tracking with φ-weighted freshness
 *   • 30+ pre-registered NOVA organism services
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'register', id, service }
 *   Main → Worker: { type: 'deregister', id }
 *   Main → Worker: { type: 'discover', capability }
 *   Main → Worker: { type: 'resolve-deps', id }
 *   Main → Worker: { type: 'health-check', id }
 *   Main → Worker: { type: 'list-all' }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'registered', id }
 *   Worker → Main: { type: 'deregistered', id }
 *   Worker → Main: { type: 'discovered', services }
 *   Worker → Main: { type: 'deps-resolved', order }
 *   Worker → Main: { type: 'health-report', id, health }
 *   Worker → Main: { type: 'service-list', services, count }
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

var KERNEL_ID      = 'GOK-REGISTRY-001';
var KERNEL_FAMILY  = 'SERVICE_REGISTRY';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;


/* ════════════════════════════════════════════════════════════════
   SERVICE STORE
   ════════════════════════════════════════════════════════════════ */

var services = {};   // id → service descriptor
var capIndex = {};   // capability → [service ids]


/* ════════════════════════════════════════════════════════════════
   SEMVER UTILITIES
   ════════════════════════════════════════════════════════════════ */

function parseSemver(v) {
  var parts = String(v || '0.0.0').split('.');
  return {
    major: parseInt(parts[0], 10) || 0,
    minor: parseInt(parts[1], 10) || 0,
    patch: parseInt(parts[2], 10) || 0,
  };
}

function compareSemver(a, b) {
  var pa = parseSemver(a);
  var pb = parseSemver(b);
  if (pa.major !== pb.major) return pa.major - pb.major;
  if (pa.minor !== pb.minor) return pa.minor - pb.minor;
  return pa.patch - pb.patch;
}

function satisfiesVersion(version, constraint) {
  if (!constraint || constraint === '*') return true;
  var op = '=';
  var cv = constraint;
  if (constraint.charAt(0) === '^') {
    op = '^';
    cv = constraint.substring(1);
  } else if (constraint.charAt(0) === '~') {
    op = '~';
    cv = constraint.substring(1);
  } else if (constraint.substring(0, 2) === '>=') {
    op = '>=';
    cv = constraint.substring(2);
  }
  var pv = parseSemver(version);
  var pc = parseSemver(cv);
  switch (op) {
    case '=':  return compareSemver(version, cv) === 0;
    case '>=': return compareSemver(version, cv) >= 0;
    case '^':  return pv.major === pc.major && compareSemver(version, cv) >= 0;
    case '~':  return pv.major === pc.major && pv.minor === pc.minor && compareSemver(version, cv) >= 0;
    default:   return true;
  }
}


/* ════════════════════════════════════════════════════════════════
   REGISTRATION / DEREGISTRATION
   ════════════════════════════════════════════════════════════════ */

function registerService(id, descriptor) {
  var svc = {
    id: id,
    name: descriptor.name || id,
    version: descriptor.version || '1.0.0',
    capabilities: descriptor.capabilities || [],
    dependencies: descriptor.dependencies || [],
    endpoint: descriptor.endpoint || null,
    status: 'registered',
    registeredAt: Date.now(),
    lastHealthCheck: Date.now(),
    healthScore: 1.0,
    metadata: descriptor.metadata || {},
  };
  services[id] = svc;

  // Update capability index
  for (var i = 0; i < svc.capabilities.length; i++) {
    var cap = svc.capabilities[i];
    if (!capIndex[cap]) capIndex[cap] = [];
    if (capIndex[cap].indexOf(id) === -1) capIndex[cap].push(id);
  }

  return svc;
}

function deregisterService(id) {
  var svc = services[id];
  if (!svc) return false;
  // Remove from capability index
  for (var i = 0; i < svc.capabilities.length; i++) {
    var cap = svc.capabilities[i];
    if (capIndex[cap]) {
      var idx = capIndex[cap].indexOf(id);
      if (idx > -1) capIndex[cap].splice(idx, 1);
      if (capIndex[cap].length === 0) delete capIndex[cap];
    }
  }
  delete services[id];
  return true;
}


/* ════════════════════════════════════════════════════════════════
   DISCOVERY — capability-based lookup
   ════════════════════════════════════════════════════════════════ */

function discoverByCapability(capability) {
  var ids = capIndex[capability] || [];
  var results = [];
  for (var i = 0; i < ids.length; i++) {
    var svc = services[ids[i]];
    if (svc) {
      results.push({
        id: svc.id,
        name: svc.name,
        version: svc.version,
        capabilities: svc.capabilities,
        status: svc.status,
        healthScore: svc.healthScore,
      });
    }
  }
  // Sort by φ-weighted health score
  results.sort(function(a, b) {
    return (b.healthScore * PHI) - (a.healthScore * PHI);
  });
  return results;
}


/* ════════════════════════════════════════════════════════════════
   DEPENDENCY RESOLUTION — Kahn's topological sort
   ════════════════════════════════════════════════════════════════ */

function resolveDependencies(rootId) {
  var visited = {};
  var inDegree = {};
  var adjList = {};
  var queue = [rootId];

  // BFS to collect the subgraph
  while (queue.length > 0) {
    var cur = queue.shift();
    if (visited[cur]) continue;
    visited[cur] = true;
    var svc = services[cur];
    if (!svc) continue;
    if (!adjList[cur]) adjList[cur] = [];
    if (!inDegree[cur]) inDegree[cur] = 0;
    for (var d = 0; d < svc.dependencies.length; d++) {
      var depId = svc.dependencies[d];
      if (!adjList[depId]) adjList[depId] = [];
      adjList[depId].push(cur);
      inDegree[cur] = (inDegree[cur] || 0) + 1;
      if (!inDegree[depId] && inDegree[depId] !== 0) inDegree[depId] = 0;
      if (!visited[depId]) queue.push(depId);
    }
  }

  // Kahn's algorithm
  var sorted = [];
  var zeroQueue = [];
  var nodes = Object.keys(inDegree);
  for (var n = 0; n < nodes.length; n++) {
    if (inDegree[nodes[n]] === 0) zeroQueue.push(nodes[n]);
  }
  while (zeroQueue.length > 0) {
    var node = zeroQueue.shift();
    sorted.push(node);
    var neighbors = adjList[node] || [];
    for (var nb = 0; nb < neighbors.length; nb++) {
      inDegree[neighbors[nb]]--;
      if (inDegree[neighbors[nb]] === 0) zeroQueue.push(neighbors[nb]);
    }
  }

  var hasCycle = sorted.length !== nodes.length;
  return { order: sorted, hasCycle: hasCycle, nodeCount: nodes.length };
}


/* ════════════════════════════════════════════════════════════════
   HEALTH CHECK — φ-weighted freshness
   ════════════════════════════════════════════════════════════════ */

function healthCheck(id) {
  var svc = services[id];
  if (!svc) return null;
  var now = Date.now();
  var elapsed = now - svc.lastHealthCheck;
  // Decay health by φ⁻¹ for each missed heartbeat window
  var missedBeats = Math.floor(elapsed / HEARTBEAT);
  var decayFactor = Math.pow(PHI_INV, Math.min(missedBeats, 20));
  svc.healthScore = Math.max(svc.healthScore * decayFactor, 0.01);
  svc.lastHealthCheck = now;
  svc.status = svc.healthScore > 0.5 ? 'healthy' : (svc.healthScore > 0.1 ? 'degraded' : 'critical');
  return {
    id: svc.id,
    name: svc.name,
    status: svc.status,
    healthScore: svc.healthScore,
    lastCheck: now,
    missedBeats: missedBeats,
  };
}

function refreshHealth(id) {
  var svc = services[id];
  if (!svc) return;
  svc.lastHealthCheck = Date.now();
  svc.healthScore = 1.0;
  svc.status = 'healthy';
}


/* ════════════════════════════════════════════════════════════════
   PRE-REGISTERED NOVA SERVICES (30+)
   ════════════════════════════════════════════════════════════════ */

var NOVA_SERVICES = [
  { id: 'nova-engine',        name: 'Engine Worker',        caps: ['reasoning', 'generation', 'dispatch'],   deps: [] },
  { id: 'nova-memory',        name: 'Memory Worker',        caps: ['storage', 'recall', 'search'],           deps: [] },
  { id: 'nova-routing',       name: 'Routing Worker',       caps: ['routing', 'protocol', 'chain'],          deps: ['nova-engine'] },
  { id: 'nova-crypto',        name: 'Crypto Worker',        caps: ['encryption', 'hashing', 'signing'],      deps: [] },
  { id: 'nova-telemetry',     name: 'Telemetry Worker',     caps: ['monitoring', 'health', 'alerts'],        deps: [] },
  { id: 'nova-download',      name: 'Download Worker',      caps: ['archive', 'export', 'zip'],              deps: [] },
  { id: 'nova-learning',      name: 'Learning Worker',      caps: ['training', 'adaptation', 'feedback'],    deps: ['nova-memory'] },
  { id: 'nova-planning',      name: 'Planning Worker',      caps: ['planning', 'decomposition', 'goals'],    deps: ['nova-engine', 'nova-memory'] },
  { id: 'nova-cache',         name: 'Cache Worker',         caps: ['caching', 'prefetch', 'ttl'],            deps: [] },
  { id: 'nova-archive',       name: 'Archive Worker',       caps: ['cold-storage', 'compression', 'tiers'],  deps: [] },
  { id: 'nova-scheduler',     name: 'Scheduler Worker',     caps: ['scheduling', 'cron', 'queue'],           deps: [] },
  { id: 'nova-config',        name: 'Config Worker',        caps: ['configuration', 'flags', 'schema'],      deps: [] },
  { id: 'nova-registry',      name: 'Registry Worker',      caps: ['discovery', 'deps', 'health'],           deps: [] },
  { id: 'canister-brain',     name: 'Swarm Brain',          caps: ['canister', 'compute', 'consensus'],      deps: [] },
  { id: 'canister-organism',  name: 'Swarm Organism',       caps: ['canister', 'orchestration', 'state'],    deps: ['canister-brain'] },
  { id: 'sdk-icp-agent',      name: 'ICP Agent SDK',        caps: ['icp', 'agent', 'identity'],              deps: [] },
  { id: 'sdk-candid',         name: 'Candid Interface',     caps: ['icp', 'candid', 'serialization'],        deps: ['sdk-icp-agent'] },
  { id: 'sdk-auth',           name: 'Auth Service',         caps: ['authentication', 'identity', 'ii'],      deps: ['sdk-icp-agent'] },
  { id: 'sdk-ledger',         name: 'Ledger Service',       caps: ['icp', 'ledger', 'tokens'],               deps: ['sdk-icp-agent', 'sdk-candid'] },
  { id: 'frontend-ui',        name: 'Frontend UI',          caps: ['rendering', 'ui', 'interaction'],        deps: ['nova-engine', 'nova-routing'] },
  { id: 'frontend-state',     name: 'Frontend State',       caps: ['state', 'store', 'reactivity'],          deps: ['frontend-ui'] },
  { id: 'net-http',           name: 'HTTP Client',          caps: ['network', 'http', 'fetch'],              deps: [] },
  { id: 'net-websocket',      name: 'WebSocket Client',     caps: ['network', 'websocket', 'realtime'],      deps: [] },
  { id: 'defense-membrane',   name: 'Defense Membrane',     caps: ['security', 'firewall', 'filtering'],     deps: ['nova-crypto'] },
  { id: 'defense-audit',      name: 'Audit Logger',         caps: ['security', 'audit', 'logging'],          deps: ['nova-memory'] },
  { id: 'geo-sacred',         name: 'Sacred Geometry',      caps: ['geometry', 'phi', 'harmonics'],          deps: [] },
  { id: 'consciousness',      name: 'Consciousness Field',  caps: ['awareness', 'emergence', 'coherence'],   deps: ['nova-telemetry'] },
  { id: 'swarm-broadcast',    name: 'Swarm Broadcast',      caps: ['broadcast', 'fanout', 'multicast'],      deps: ['nova-routing'] },
  { id: 'quantum-entangle',   name: 'Quantum Entanglement', caps: ['correlation', 'pairing', 'entanglement'],deps: [] },
  { id: 'neural-consensus',   name: 'Neural Consensus',     caps: ['consensus', 'voting', 'agreement'],      deps: ['nova-engine', 'nova-routing'] },
  { id: 'emergence-detect',   name: 'Emergence Detector',   caps: ['emergence', 'novelty', 'patterns'],      deps: ['nova-telemetry', 'nova-memory'] },
  { id: 'sovereign-seal',     name: 'Sovereign Seal',       caps: ['integrity', 'verification', 'seal'],     deps: ['nova-crypto'] },
];

// Bootstrap pre-registered services
for (var si = 0; si < NOVA_SERVICES.length; si++) {
  var s = NOVA_SERVICES[si];
  registerService(s.id, {
    name: s.name,
    version: '1.0.0',
    capabilities: s.caps,
    dependencies: s.deps,
    metadata: { preRegistered: true },
  });
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'register': {
      var svc = registerService(msg.id, msg.service || {});
      self.postMessage({
        type: 'registered',
        id: svc.id,
        name: svc.name,
        version: svc.version,
        capabilities: svc.capabilities,
        totalServices: Object.keys(services).length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'deregister': {
      var removed = deregisterService(msg.id);
      self.postMessage({
        type: 'deregistered',
        id: msg.id,
        success: removed,
        totalServices: Object.keys(services).length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'discover': {
      var found = discoverByCapability(msg.capability);
      self.postMessage({
        type: 'discovered',
        capability: msg.capability,
        services: found,
        count: found.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'resolve-deps': {
      var resolution = resolveDependencies(msg.id);
      self.postMessage({
        type: 'deps-resolved',
        id: msg.id,
        order: resolution.order,
        hasCycle: resolution.hasCycle,
        nodeCount: resolution.nodeCount,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'health-check': {
      if (msg.id) {
        if (msg.refresh) {
          refreshHealth(msg.id);
        }
        var report = healthCheck(msg.id);
        self.postMessage({
          type: 'health-report',
          service: report,
          kernelId: KERNEL_ID,
        });
      } else {
        // Check all services
        var reports = [];
        var ids = Object.keys(services);
        for (var h = 0; h < ids.length; h++) {
          reports.push(healthCheck(ids[h]));
        }
        self.postMessage({
          type: 'health-report',
          services: reports,
          totalServices: ids.length,
          kernelId: KERNEL_ID,
        });
      }
      break;
    }

    case 'list-all': {
      var list = [];
      var allIds = Object.keys(services);
      for (var l = 0; l < allIds.length; l++) {
        var sv = services[allIds[l]];
        list.push({
          id: sv.id,
          name: sv.name,
          version: sv.version,
          capabilities: sv.capabilities,
          dependencies: sv.dependencies,
          status: sv.status,
          healthScore: sv.healthScore,
        });
      }
      self.postMessage({
        type: 'service-list',
        services: list,
        count: list.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'registry-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalServices: Object.keys(services).length,
        totalCapabilities: Object.keys(capIndex).length,
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

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalServices: Object.keys(services).length,
  });
}, HEARTBEAT);
