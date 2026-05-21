// ═══════════════════════════════════════════════════════════════════════════════
// bridge_demo.js — JavaScript SDK Demo for NOVA Julia-Motoko Bridge
// Classification: CONFIDENTIAL — SOVEREIGN PROTOCOL
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// BUILD №66 — MCP TOOLS + CROSS-SUBSTRATE MESH
// ═══════════════════════════════════════════════════════════════════════════════
//
// Demonstrates all 15 API functions via MCP tools + cross-substrate wiring.
//
// MCP TOOLS:
//   julia.compute(phi_eigen)     — Execute any registered function
//   julia.classify_probe         — Classify input data
//   julia.optimize_policy        — Run optimization
//   julia.reward_curve           — Compute reward/decay curves
//
// CROSS-SUBSTRATE:
//   Cloudflare → Julia → ICP → Cloudflare → ICP → Julia
//
// ═══════════════════════════════════════════════════════════════════════════════

import MCPJuliaServer from '../mcp-server/mcp-julia-tools.js';
import CrossSubstrateMesh from '../mcp-server/cross-substrate-mesh.js';

// ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

// ═══ Section 2: MCP Tool Demonstrations ══════════════════════════════════════

async function main() {
  console.log('╔══════════════════════════════════════════════════════════════════╗');
  console.log('║  NOVA Julia-Motoko Bridge — MCP Tools + Cross-Substrate Demo    ║');
  console.log('╚══════════════════════════════════════════════════════════════════╝');
  console.log();

  // Initialize MCP server
  const server = new MCPJuliaServer();
  const mesh = new CrossSubstrateMesh();

  // ─── List Available Tools ──────────────────────────────────────────────────
  console.log('═══ MCP Tools Available ═══');
  const tools = server.listTools();
  for (const tool of tools) {
    console.log(`  ${tool.name} — ${tool.description}`);
  }
  console.log();

  // ─── Demo 1: julia.compute — All 15 Functions ─────────────────────────────
  console.log('═══ Demo 1: julia.compute — Calling All 15 Functions ═══');
  console.log();

  const demos = [
    { function: 'phi_fibonacci', args: { n: 10 }, label: 'Fibonacci(10)' },
    { function: 'phi_decay', args: { t: 2.0, tau: 1.0 }, label: 'φ-Decay(t=2, τ=1)' },
    { function: 'phi_learning_rate', args: { base: 0.01 }, label: 'Learning Rate(0.01)' },
    { function: 'phi_mean', args: { x: [1, 2, 3, 4, 5, 100] }, label: 'φ-Mean([1..5, 100])' },
    { function: 'phi_std', args: { x: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }, label: 'φ-Std([1..10])' },
    { function: 'phi_var', args: { x: [2, 4, 4, 4, 5, 5, 7, 9] }, label: 'φ-Var' },
    { function: 'phi_cov', args: { x: [1, 2, 3, 4, 5], y: [2, 4, 6, 8, 10] }, label: 'φ-Cov' },
    { function: 'phi_cor', args: { x: [1, 2, 3, 4, 5], y: [2, 4, 5, 4, 5] }, label: 'φ-Cor' },
    { function: 'kuramoto_sync', args: { theta: [0, 1, 2, 3, 4, 5, 6, 7], K: PHI_INV, omega: [1, 1, 1, 1, 1, 1, 1, 1] }, label: 'Kuramoto(8 osc.)' },
    { function: 'phi_eigen', args: { A: [[2, 1], [1, 2]] }, label: 'φ-Eigen(2×2)' },
    { function: 'phi_svd', args: { A: [[1, 2], [3, 4], [5, 6]] }, label: 'φ-SVD(3×2)' },
    { function: 'phi_fft', args: { x: [1, 0, -1, 0, 1, 0, -1, 0] }, label: 'φ-FFT(8pt)' },
    { function: 'phi_ifft', args: { X: [0, 4, 0, 0, 0, 0, 0, -4] }, label: 'φ-IFFT' },
    { function: 'phi_linsolve', args: { A: [[4, 1], [1, 3]], b: [1, 2] }, label: 'φ-LinSolve' },
    { function: 'golden_section', args: { a: 0, b: 3 }, label: 'Golden Section' },
  ];

  for (const demo of demos) {
    const result = await server.callTool('julia.compute', demo);
    const parsed = JSON.parse(result.content[0].text);
    const display = parsed.result !== undefined
      ? (typeof parsed.result === 'object' ? JSON.stringify(parsed.result).slice(0, 60) : parsed.result)
      : JSON.stringify(parsed).slice(0, 60);
    console.log(`  julia.compute(${demo.function}) → ${display}`);
  }
  console.log();

  // ─── Demo 2: julia.classify_probe ──────────────────────────────────────────
  console.log('═══ Demo 2: julia.classify_probe — Auto-Routing ═══');
  console.log();

  const probes = [
    { data: [[2, 1], [1, 2]], intent: 'auto' },
    { data: [1, 2, 3, 4, 5, 6, 7, 8], intent: 'transform' },
    { data: [10, 20, 30, 40, 50], intent: 'analyze' },
    { data: 3.14, intent: 'simulate' },
  ];

  for (const probe of probes) {
    const result = await server.callTool('julia.classify_probe', probe);
    const parsed = JSON.parse(result.content[0].text);
    console.log(`  Input: ${JSON.stringify(probe.data).slice(0, 30)}  Intent: ${probe.intent}`);
    console.log(`    → Type: ${parsed.type}, Recommended: ${parsed.recommended_function}`);
  }
  console.log();

  // ─── Demo 3: julia.reward_curve ────────────────────────────────────────────
  console.log('═══ Demo 3: julia.reward_curve — Decay & Growth Curves ═══');
  console.log();

  const curves = [
    { curve_type: 'phi_decay', parameters: { tau: 1.0 }, time_range: { start: 0, end: 5, points: 6 } },
    { curve_type: 'learning_rate', parameters: { base_lr: 0.01 }, time_range: { start: 0, end: 5, points: 6 } },
    { curve_type: 'fibonacci_growth', parameters: {}, time_range: { start: 0, end: 10, points: 11 } },
    { curve_type: 'kuramoto_sync', parameters: { coupling_K: PHI_INV }, time_range: { start: 0, end: 5, points: 6 } },
  ];

  for (const curve of curves) {
    const result = await server.callTool('julia.reward_curve', curve);
    const parsed = JSON.parse(result.content[0].text);
    const vals = parsed.values.slice(0, 6).map(v => v.toFixed(4));
    console.log(`  ${curve.curve_type}: [${vals.join(', ')}...]`);
  }
  console.log();

  // ─── Demo 4: Cross-Substrate Mesh ──────────────────────────────────────────
  console.log('═══ Demo 4: Cross-Substrate Mesh — Everything Talks to Everything ═══');
  console.log();

  // Show topology
  const topo = mesh.getTopology();
  console.log(`  Substrates: ${topo.substrates.map(s => s.name).join(', ')}`);
  console.log(`  Routes: ${topo.edges} (fully connected: ${topo.fully_connected})`);
  console.log();

  // Execute cross-substrate calls
  const crossCalls = [
    { source: 'cloudflare', tool: 'julia.compute', args: { function: 'phi_eigen', args: { A: [[2, 1], [1, 2]] } } },
    { source: 'julia', tool: 'icp.persist', args: { canister: 'swarm_brain', method: 'store' } },
    { source: 'icp', tool: 'cf.trigger', args: { worker: 'nova-heartbeat', event: 'sync' } },
    { source: 'cloudflare', tool: 'icp.query', args: { canister: 'nova_protocol', method: 'get_phi' } },
    { source: 'icp', tool: 'julia.compute', args: { function: 'kuramoto_sync' } },
  ];

  for (const call of crossCalls) {
    const result = await mesh.route(call.source, call.tool, call.args);
    console.log(`  ${call.source} → ${call.tool} [${result.protocol}] ✓`);
  }
  console.log();

  // Metrics
  const metrics = mesh.getMetrics();
  console.log(`  Total cross-substrate calls: ${metrics.total_calls}`);
  console.log(`  Routes used: ${Object.keys(metrics.by_route).join(', ')}`);
  console.log();

  // ─── Summary ───────────────────────────────────────────────────────────────
  console.log('═══ Bridge Statistics ═══');
  console.log('  15 Math Functions — all exposed as MCP tools');
  console.log('  4  MCP Call Doors (compute, classify_probe, optimize_policy, reward_curve)');
  console.log('  3  Type Layers (Julia ↔ Motoko ↔ JavaScript)');
  console.log('  5  Cross-Substrate Routes (Cloudflare ↔ Julia ↔ ICP full mesh)');
  console.log('  BUILD №66');
  console.log();
  console.log('  Ready to Bridge Julia & Blockchain ✓');
}

// ═══ Run ══════════════════════════════════════════════════════════════════════

main().catch(console.error);
