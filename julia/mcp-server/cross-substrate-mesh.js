// ═══════════════════════════════════════════════════════════════════════════════
// cross-substrate-mesh.js — Cross-Substrate Computation Wiring
// Classification: CONFIDENTIAL — SOVEREIGN PROTOCOL
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// BUILD №66 — CROSS-SUBSTRATE MCP MESH
// ═══════════════════════════════════════════════════════════════════════════════
//
// Everything talks to everything through MCP tools.
//
//   Cloudflare → Julia    (Worker calls julia.compute via MCP)
//   Julia → ICP           (Result persisted to canister via MCP)
//   ICP → Cloudflare      (Canister triggers Worker via webhook/MCP)
//   Cloudflare → ICP      (Worker calls canister method via MCP)
//   ICP → Julia           (Canister requests computation via MCP)
//
// This is cross-substrate computation. Every substrate is both a producer
// and consumer of MCP tools.
//
// ═══════════════════════════════════════════════════════════════════════════════

// ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

// ═══ Section 2: Substrate Definitions ════════════════════════════════════════

const SUBSTRATES = {
  CLOUDFLARE: {
    id: 'cloudflare',
    name: 'Cloudflare Workers',
    type: 'EDGE',
    mcp_endpoint: 'https://nova-mcp.workers.dev/mcp',
    capabilities: ['compute', 'cache', 'route', 'schedule'],
    heartbeat: true,
  },
  JULIA: {
    id: 'julia',
    name: 'Julia Compute Engine',
    type: 'COMPUTE',
    mcp_endpoint: 'julia://localhost:7618/mcp',
    capabilities: ['linalg', 'stats', 'signal', 'optim', 'dynamics'],
    heartbeat: true,
  },
  ICP: {
    id: 'icp',
    name: 'Internet Computer',
    type: 'BLOCKCHAIN',
    mcp_endpoint: 'https://ic0.app/mcp',
    capabilities: ['persist', 'consensus', 'crypto', 'governance'],
    heartbeat: true,
  },
};

// ═══ Section 3: Cross-Substrate Routes ═══════════════════════════════════════
//
// Every route defines a source → destination MCP call pattern.
// The mesh ensures any substrate can reach any other substrate.

const CROSS_SUBSTRATE_ROUTES = [
  // ─── Cloudflare → Julia ────────────────────────────────────────────────────
  {
    id: 'cf-to-julia',
    source: 'cloudflare',
    destination: 'julia',
    description: 'Worker calls Julia compute via MCP tool',
    tools: ['julia.compute', 'julia.classify_probe', 'julia.optimize_policy', 'julia.reward_curve'],
    protocol: 'mcp-over-http',
    example: {
      tool: 'julia.compute',
      args: { function: 'phi_eigen', args: { A: [[2, 1], [1, 2]] } },
    },
  },

  // ─── Julia → ICP ──────────────────────────────────────────────────────────
  {
    id: 'julia-to-icp',
    source: 'julia',
    destination: 'icp',
    description: 'Julia stores computation results on-chain via canister call',
    tools: ['icp.persist', 'icp.verify', 'icp.emit_event'],
    protocol: 'mcp-over-agent',
    example: {
      tool: 'icp.persist',
      args: {
        canister: 'swarm_brain',
        method: 'store_computation',
        payload: { function: 'phi_eigen', result_hash: '0xabc...', timestamp: Date.now() },
      },
    },
  },

  // ─── ICP → Cloudflare ──────────────────────────────────────────────────────
  {
    id: 'icp-to-cf',
    source: 'icp',
    destination: 'cloudflare',
    description: 'Canister triggers Worker via HTTP outcall / webhook',
    tools: ['cf.trigger', 'cf.cache_invalidate', 'cf.schedule_task'],
    protocol: 'http-outcall',
    example: {
      tool: 'cf.trigger',
      args: {
        worker: 'nova-heartbeat',
        event: 'computation_complete',
        payload: { canister: 'swarm_brain', method: 'phi_eigen', status: 'ok' },
      },
    },
  },

  // ─── Cloudflare → ICP ──────────────────────────────────────────────────────
  {
    id: 'cf-to-icp',
    source: 'cloudflare',
    destination: 'icp',
    description: 'Worker calls canister method via @dfinity/agent',
    tools: ['icp.call', 'icp.query', 'icp.read_state'],
    protocol: 'mcp-over-agent',
    example: {
      tool: 'icp.query',
      args: {
        canister: 'nova_protocol',
        method: 'get_phi_constants',
        args: [],
      },
    },
  },

  // ─── ICP → Julia ──────────────────────────────────────────────────────────
  {
    id: 'icp-to-julia',
    source: 'icp',
    destination: 'julia',
    description: 'Canister requests computation from Julia engine',
    tools: ['julia.compute', 'julia.optimize_policy'],
    protocol: 'http-outcall-to-mcp',
    example: {
      tool: 'julia.compute',
      args: { function: 'kuramoto_sync', args: { theta: [0, 1, 2, 3], K: PHI_INV, omega: [1, 1, 1, 1] } },
    },
  },
];

// ═══ Section 4: MCP Mesh Router ══════════════════════════════════════════════

class CrossSubstrateMesh {
  constructor() {
    this.substrates = new Map(Object.entries(SUBSTRATES).map(([k, v]) => [v.id, v]));
    this.routes = CROSS_SUBSTRATE_ROUTES;
    this.callLog = [];
    this.metrics = { total_calls: 0, by_route: {} };
  }

  /**
   * Route an MCP tool call from source to destination substrate.
   *
   * @param {string} source - Source substrate ID
   * @param {string} toolName - MCP tool name (e.g., 'julia.compute')
   * @param {object} args - Tool arguments
   * @returns {Promise<object>} Tool result
   */
  async route(source, toolName, args) {
    // Determine destination from tool prefix
    const destination = this._resolveDestination(toolName);
    const route = this._findRoute(source, destination);

    if (!route) {
      throw new Error(`No route from ${source} to ${destination} for tool ${toolName}`);
    }

    // Log the cross-substrate call
    const callRecord = {
      id: `call-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
      source,
      destination,
      tool: toolName,
      timestamp: Date.now(),
      route_id: route.id,
    };
    this.callLog.push(callRecord);
    this.metrics.total_calls++;
    this.metrics.by_route[route.id] = (this.metrics.by_route[route.id] || 0) + 1;

    // Execute via appropriate protocol
    const result = await this._executeViaProtocol(route, toolName, args);

    callRecord.elapsed_ms = Date.now() - callRecord.timestamp;
    callRecord.success = true;

    return result;
  }

  _resolveDestination(toolName) {
    const prefix = toolName.split('.')[0];
    const prefixMap = {
      julia: 'julia',
      icp: 'icp',
      cf: 'cloudflare',
    };
    return prefixMap[prefix] || 'julia';
  }

  _findRoute(source, destination) {
    return this.routes.find(r => r.source === source && r.destination === destination);
  }

  async _executeViaProtocol(route, toolName, args) {
    switch (route.protocol) {
      case 'mcp-over-http':
        return await this._callMCPoverHTTP(route, toolName, args);
      case 'mcp-over-agent':
        return await this._callMCPoverAgent(route, toolName, args);
      case 'http-outcall':
        return await this._callHTTPOutcall(route, toolName, args);
      case 'http-outcall-to-mcp':
        return await this._callHTTPOutcallToMCP(route, toolName, args);
      default:
        throw new Error(`Unknown protocol: ${route.protocol}`);
    }
  }

  // ─── Protocol Implementations ──────────────────────────────────────────────

  async _callMCPoverHTTP(route, toolName, args) {
    const dest = this.substrates.get(route.destination);
    // In production: fetch(dest.mcp_endpoint, { method: 'POST', body: JSON.stringify({tool: toolName, args}) })
    return { protocol: 'mcp-over-http', endpoint: dest.mcp_endpoint, tool: toolName, args, status: 'routed' };
  }

  async _callMCPoverAgent(route, toolName, args) {
    const dest = this.substrates.get(route.destination);
    // In production: use @dfinity/agent Actor to call canister
    return { protocol: 'mcp-over-agent', endpoint: dest.mcp_endpoint, tool: toolName, args, status: 'routed' };
  }

  async _callHTTPOutcall(route, toolName, args) {
    const dest = this.substrates.get(route.destination);
    // In production: ICP HTTP outcall to Cloudflare Worker
    return { protocol: 'http-outcall', endpoint: dest.mcp_endpoint, tool: toolName, args, status: 'routed' };
  }

  async _callHTTPOutcallToMCP(route, toolName, args) {
    const dest = this.substrates.get(route.destination);
    // In production: ICP HTTP outcall → Julia MCP server
    return { protocol: 'http-outcall-to-mcp', endpoint: dest.mcp_endpoint, tool: toolName, args, status: 'routed' };
  }

  // ─── Mesh Introspection ────────────────────────────────────────────────────

  /**
   * Get the full mesh topology as an adjacency description.
   */
  getTopology() {
    return {
      substrates: Object.values(SUBSTRATES),
      routes: this.routes.map(r => ({
        id: r.id,
        source: r.source,
        destination: r.destination,
        tools: r.tools,
        protocol: r.protocol,
      })),
      edges: this.routes.length,
      fully_connected: this._isFullyConnected(),
    };
  }

  _isFullyConnected() {
    const ids = [...this.substrates.keys()];
    for (const src of ids) {
      for (const dst of ids) {
        if (src !== dst && !this._findRoute(src, dst)) return false;
      }
    }
    return true;
  }

  /**
   * Get mesh metrics.
   */
  getMetrics() {
    return {
      ...this.metrics,
      recent_calls: this.callLog.slice(-10),
      substrates_active: this.substrates.size,
      routes_active: this.routes.length,
    };
  }

  /**
   * List all tools available from a given source substrate.
   */
  availableTools(source) {
    const tools = [];
    for (const route of this.routes) {
      if (route.source === source) {
        tools.push(...route.tools.map(t => ({
          tool: t,
          destination: route.destination,
          protocol: route.protocol,
        })));
      }
    }
    return tools;
  }
}

// ═══ Section 5: Cloudflare Worker Integration ════════════════════════════════
//
// This shows how a Cloudflare Worker uses the mesh to call Julia.

/**
 * Example: Cloudflare Worker handler that uses cross-substrate mesh.
 */
async function handleCloudflareRequest(request, env) {
  const mesh = new CrossSubstrateMesh();
  const url = new URL(request.url);

  if (url.pathname === '/mcp/julia/compute') {
    const body = await request.json();
    const result = await mesh.route('cloudflare', 'julia.compute', body);
    return new Response(JSON.stringify(result), {
      headers: { 'Content-Type': 'application/json' },
    });
  }

  if (url.pathname === '/mcp/icp/query') {
    const body = await request.json();
    const result = await mesh.route('cloudflare', 'icp.query', body);
    return new Response(JSON.stringify(result), {
      headers: { 'Content-Type': 'application/json' },
    });
  }

  if (url.pathname === '/mcp/topology') {
    return new Response(JSON.stringify(mesh.getTopology(), null, 2), {
      headers: { 'Content-Type': 'application/json' },
    });
  }

  return new Response('NOVA Cross-Substrate MCP Mesh', { status: 200 });
}

// ═══ Section 6: ICP Canister Integration ═════════════════════════════════════
//
// Shows how an ICP canister calls Julia via HTTP outcall → MCP.

/**
 * Motoko-equivalent pattern for cross-substrate call:
 *
 * ```motoko
 * public shared func request_julia_compute(funcName : Text, args : Text) : async Text {
 *   let ic : IC = actor "aaaaa-aa";
 *   let response = await ic.http_request({
 *     url = "https://nova-julia-mcp.workers.dev/mcp";
 *     method = #post;
 *     body = ?Text.encodeUtf8("{\"tool\":\"julia.compute\",\"args\":" # args # "}");
 *     headers = [{ name = "Content-Type"; value = "application/json" }];
 *     transform = null;
 *   });
 *   Text.decodeUtf8(response.body)
 * };
 * ```
 */
const ICP_JULIA_PATTERN = {
  description: 'ICP → Julia via HTTP outcall to MCP endpoint',
  flow: [
    '1. Canister receives update call',
    '2. Canister makes HTTP outcall to Julia MCP Worker',
    '3. Worker routes to Julia engine (WASM or subprocess)',
    '4. Julia computes result',
    '5. Result returns through HTTP → Canister',
    '6. Canister stores result in stable memory',
  ],
};

// ═══ Section 7: Full Triangle Demo ═══════════════════════════════════════════

/**
 * Demonstrates the full cross-substrate triangle:
 *
 * 1. Cloudflare Worker receives user request
 * 2. Worker calls julia.compute(phi_eigen) via MCP
 * 3. Julia computes eigenvalues
 * 4. Julia calls icp.persist to store result on-chain
 * 5. ICP canister emits event
 * 6. Event triggers Cloudflare Worker via webhook
 * 7. Worker caches result at edge
 *
 * Total round-trip: < 3 × HEARTBEAT_MS = 2619ms target
 */
async function fullTriangleDemo() {
  const mesh = new CrossSubstrateMesh();

  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║  CROSS-SUBSTRATE COMPUTATION — Full Triangle Demo           ║');
  console.log('╚══════════════════════════════════════════════════════════════╝');
  console.log();

  // Step 1: Cloudflare → Julia
  console.log('Step 1: Cloudflare → Julia (compute phi_eigen)');
  const eigenResult = await mesh.route('cloudflare', 'julia.compute', {
    function: 'phi_eigen',
    args: { A: [[2, 1, 0], [1, 2, 1], [0, 1, 2]] },
  });
  console.log('  Result:', JSON.stringify(eigenResult));
  console.log();

  // Step 2: Julia → ICP
  console.log('Step 2: Julia → ICP (persist result on-chain)');
  const persistResult = await mesh.route('julia', 'icp.persist', {
    canister: 'swarm_brain',
    method: 'store_computation',
    payload: { function: 'phi_eigen', result: eigenResult, timestamp: Date.now() },
  });
  console.log('  Result:', JSON.stringify(persistResult));
  console.log();

  // Step 3: ICP → Cloudflare
  console.log('Step 3: ICP → Cloudflare (trigger cache update)');
  const triggerResult = await mesh.route('icp', 'cf.trigger', {
    worker: 'nova-cache',
    event: 'computation_stored',
    payload: { canister: 'swarm_brain', key: 'phi_eigen_latest' },
  });
  console.log('  Result:', JSON.stringify(triggerResult));
  console.log();

  // Step 4: Cloudflare → ICP
  console.log('Step 4: Cloudflare → ICP (verify on-chain state)');
  const queryResult = await mesh.route('cloudflare', 'icp.query', {
    canister: 'nova_protocol',
    method: 'get_phi_constants',
  });
  console.log('  Result:', JSON.stringify(queryResult));
  console.log();

  // Step 5: ICP → Julia
  console.log('Step 5: ICP → Julia (request Kuramoto sync computation)');
  const kuramotoResult = await mesh.route('icp', 'julia.compute', {
    function: 'kuramoto_sync',
    args: { theta: [0, 1, 2, 3], K: PHI_INV, omega: [1, 1, 1, 1] },
  });
  console.log('  Result:', JSON.stringify(kuramotoResult));
  console.log();

  // Topology
  console.log('═══ Mesh Topology ═══');
  const topo = mesh.getTopology();
  console.log(`Substrates: ${topo.substrates.length}`);
  console.log(`Routes: ${topo.edges}`);
  console.log(`Fully connected: ${topo.fully_connected}`);
  console.log();

  // Available tools from each substrate
  for (const sub of topo.substrates) {
    const tools = mesh.availableTools(sub.id);
    console.log(`${sub.name} can call: ${tools.map(t => t.tool).join(', ')}`);
  }
  console.log();

  // Metrics
  console.log('═══ Call Metrics ═══');
  const metrics = mesh.getMetrics();
  console.log(`Total calls: ${metrics.total_calls}`);
  console.log('By route:', metrics.by_route);

  return mesh;
}

// ═══ Section 8: Exports ══════════════════════════════════════════════════════

export {
  CrossSubstrateMesh,
  SUBSTRATES,
  CROSS_SUBSTRATE_ROUTES,
  ICP_JULIA_PATTERN,
  handleCloudflareRequest,
  fullTriangleDemo,
  PHI,
  PHI_INV,
  AMOR,
  HEARTBEAT_MS,
};

export default CrossSubstrateMesh;
