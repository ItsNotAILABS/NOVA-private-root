// ═══════════════════════════════════════════════════════════════════════════════
// SPHAERA — Sovereign Webbed Sphere Networking Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// Geodesic sphere mesh networking with φ-optimized Fibonacci lattice placement,
// Kuramoto oscillator synchronization, self-healing triangulation, and
// great-circle message routing.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── KERNEL IDENTITY ────────────────────────────────────────────────────────────
const KERNEL_ID         = 'GOL-SPHAERA-001';
const KERNEL_NAME       = 'SPHAERA RETICULATA';
const KERNEL_FAMILY     = 'RETIS_AETERNA';
const KERNEL_VERSION    = '1.0.0';
const KERNEL_BUILD      = 66;

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI            = 1.6180339887498948482;
const PHI_INV        = 0.6180339887498948482;
const AMOR           = 0.3819660112501051518;
const TAU            = 6.283185307179586;
const GOLDEN_ANGLE   = TAU * PHI_INV;
const HEARTBEAT_MS   = 873;

// ─── ICOSAHEDRAL CONSTANTS ──────────────────────────────────────────────────────
const ICOSA_FACES    = 20;
const MIN_DEGREE     = 5;
const MAX_DEGREE     = 6;
const SPHERE_SIZE    = 64;
const MAX_HOPS       = 8;

// ─── MINI HEART — Kuramoto Phase Oscillator (COR_PARVUM) ────────────────────────
const COR_PARVUM = {
  phase:          0,
  frequency:      TAU / HEARTBEAT_MS,
  couplingK:      PHI_INV,
  orderParameter: 0,
  beatCount:      0,
  lastBeat:       Date.now(),
};

// ─── CEREBRUM_COMPOSITUM — Composite Brain ──────────────────────────────────────
const CEREBRUM_COMPOSITUM = {
  regions: [
    { name: 'topology',     activation: 0.5, spikes: 0 },
    { name: 'routing',      activation: 0.4, spikes: 0 },
    { name: 'synchrony',    activation: 0.6, spikes: 0 },
    { name: 'healing',      activation: 0.3, spikes: 0 },
    { name: 'coherence',    activation: 0.5, spikes: 0 },
  ],
  thoughtCount: 0,
};

// ─── SPHERE GEOMETRY ────────────────────────────────────────────────────────────

function sphericalToCartesian(theta, phi) {
  const sinT = Math.sin(theta);
  return { x: sinT * Math.cos(phi), y: sinT * Math.sin(phi), z: Math.cos(theta) };
}

function geodesicDistance(p1, p2) {
  const dx = p2.x - p1.x, dy = p2.y - p1.y, dz = p2.z - p1.z;
  const chord = Math.sqrt(dx * dx + dy * dy + dz * dz);
  return 2 * Math.asin(Math.min(1, chord / 2));
}

function icosahedralSector(point) {
  const phi = Math.atan2(point.y, point.x);
  const phiNorm = (phi + Math.PI) / TAU;
  if (point.z > 0.7) return Math.floor(phiNorm * 5);
  if (point.z < -0.7) return 15 + Math.floor(phiNorm * 5);
  return 5 + Math.floor(phiNorm * 10) % 10;
}

// ─── FIBONACCI LATTICE ──────────────────────────────────────────────────────────

function fibonacciLattice(n) {
  const points = [];
  for (let i = 0; i < n; i++) {
    const theta = Math.acos(1 - (2 * i) / (n - 1 || 1));
    const phi = GOLDEN_ANGLE * i;
    const pos = sphericalToCartesian(theta, phi);
    pos.index = i;
    pos.sector = icosahedralSector(pos);
    points.push(pos);
  }
  return points;
}

// ─── SPHERE MESH ────────────────────────────────────────────────────────────────

const MESH = {
  points: [],
  edges: new Map(),
  sectors: new Map(),
};

function buildMesh(n) {
  MESH.points = fibonacciLattice(n);
  MESH.edges = new Map();
  MESH.sectors = new Map();

  for (let i = 0; i < ICOSA_FACES; i++) MESH.sectors.set(i, new Set());
  for (const p of MESH.points) MESH.sectors.get(p.sector).add(p.index);
  for (let i = 0; i < n; i++) MESH.edges.set(i, new Set());

  // Connect each node to nearest neighbors
  for (let i = 0; i < n; i++) {
    const p = MESH.points[i];
    const dists = [];
    for (let j = 0; j < n; j++) {
      if (j === i) continue;
      dists.push({ idx: j, dist: geodesicDistance(p, MESH.points[j]) });
    }
    dists.sort((a, b) => a.dist - b.dist);
    const k = Math.min(i < 12 ? MIN_DEGREE : MAX_DEGREE, dists.length);
    for (let c = 0; c < k; c++) {
      MESH.edges.get(i).add(dists[c].idx);
      MESH.edges.get(dists[c].idx).add(i);
    }
  }
}

// ─── KURAMOTO PHASES ────────────────────────────────────────────────────────────

let phases = new Float64Array(SPHERE_SIZE);
let frequencies = new Float64Array(SPHERE_SIZE);

function initKuramoto(n) {
  phases = new Float64Array(n);
  frequencies = new Float64Array(n);
  for (let i = 0; i < n; i++) {
    phases[i] = (GOLDEN_ANGLE * i) % TAU;
    frequencies[i] = COR_PARVUM.frequency * (1 + AMOR * (Math.random() - 0.5) * 0.1);
  }
}

function stepKuramoto() {
  const n = MESH.points.length;
  const dt = 0.01;
  const dPhases = new Float64Array(n);

  for (let i = 0; i < n; i++) {
    let coupling = 0;
    const neighbors = MESH.edges.get(i);
    if (!neighbors) continue;
    for (const j of neighbors) {
      coupling += Math.sin(phases[j] - phases[i]);
    }
    const avg = neighbors.size > 0 ? coupling / neighbors.size : 0;
    dPhases[i] = frequencies[i] + COR_PARVUM.couplingK * avg;
  }

  for (let i = 0; i < n; i++) {
    phases[i] = (phases[i] + dPhases[i] * dt) % TAU;
    if (phases[i] < 0) phases[i] += TAU;
  }

  // Compute order parameter
  let sumCos = 0, sumSin = 0;
  for (let i = 0; i < n; i++) {
    sumCos += Math.cos(phases[i]);
    sumSin += Math.sin(phases[i]);
  }
  COR_PARVUM.orderParameter = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
}

// ─── GEODESIC ROUTING ───────────────────────────────────────────────────────────

function routeMessage(src, dst) {
  if (src === dst) return [src];
  const dstPos = MESH.points[dst];
  if (!dstPos) return [];

  const path = [src];
  const visited = new Set([src]);
  let current = src;

  for (let hop = 0; hop < MAX_HOPS; hop++) {
    if (current === dst) break;
    const neighbors = MESH.edges.get(current);
    if (!neighbors || !neighbors.size) break;

    let bestIdx = -1, bestDist = Infinity;
    for (const n of neighbors) {
      if (visited.has(n)) continue;
      const dist = geodesicDistance(MESH.points[n], dstPos);
      if (dist < bestDist) { bestDist = dist; bestIdx = n; }
    }
    if (bestIdx === -1) break;
    visited.add(bestIdx);
    path.push(bestIdx);
    current = bestIdx;
  }
  return path;
}

// ─── MACHINA_VIRTUALIS — State Machine ──────────────────────────────────────────

const STATES = {
  IDLE:       'IDLE',
  BUILD:      'BUILD',
  SYNC:       'SYNC',
  ROUTE:      'ROUTE',
  HEAL:       'HEAL',
  EMIT:       'EMIT',
};

let currentState = STATES.IDLE;
let meshBuilt = false;

// ─── STATISTICS ─────────────────────────────────────────────────────────────────

const stats = {
  heartbeats:   0,
  routes:       0,
  repairs:      0,
  messages:     0,
  meshSize:     0,
  edgeCount:    0,
  uptime:       0,
  startTime:    Date.now(),
};

// ─── MAIN TICK ──────────────────────────────────────────────────────────────────

function tick() {
  // State: BUILD
  if (!meshBuilt) {
    currentState = STATES.BUILD;
    buildMesh(SPHERE_SIZE);
    initKuramoto(SPHERE_SIZE);
    meshBuilt = true;
    stats.meshSize = SPHERE_SIZE;
    let edgeCount = 0;
    for (const [, ns] of MESH.edges) edgeCount += ns.size;
    stats.edgeCount = edgeCount / 2;
    CEREBRUM_COMPOSITUM.regions[0].spikes++;
  }

  // State: SYNC (Kuramoto step)
  currentState = STATES.SYNC;
  stepKuramoto();
  COR_PARVUM.beatCount++;
  COR_PARVUM.lastBeat = Date.now();
  COR_PARVUM.phase = (COR_PARVUM.phase + COR_PARVUM.frequency * 0.01) % TAU;
  CEREBRUM_COMPOSITUM.regions[2].spikes++;

  // State: ROUTE (demo route every 5 ticks)
  if (COR_PARVUM.beatCount % 5 === 0) {
    currentState = STATES.ROUTE;
    const src = Math.floor(Math.random() * SPHERE_SIZE);
    const dst = Math.floor(Math.random() * SPHERE_SIZE);
    const path = routeMessage(src, dst);
    stats.routes++;
    CEREBRUM_COMPOSITUM.regions[1].spikes++;
  }

  // State: EMIT
  currentState = STATES.EMIT;
  stats.heartbeats++;
  stats.uptime = Date.now() - stats.startTime;
  CEREBRUM_COMPOSITUM.thoughtCount++;

  // Emit telemetry
  self.postMessage({
    type: 'TELEMETRY',
    kernel: KERNEL_ID,
    family: KERNEL_FAMILY,
    state: currentState,
    cor_parvum: {
      phase:          Math.round(COR_PARVUM.phase * 1000) / 1000,
      orderParameter: Math.round(COR_PARVUM.orderParameter * 10000) / 10000,
      beatCount:      COR_PARVUM.beatCount,
    },
    mesh: {
      nodes:     stats.meshSize,
      edges:     stats.edgeCount,
      sectors:   ICOSA_FACES,
    },
    stats: { ...stats },
    timestamp: Date.now(),
  });

  currentState = STATES.IDLE;
}

// ─── HEARTBEAT LOOP ─────────────────────────────────────────────────────────────

setInterval(tick, HEARTBEAT_MS);

// Initial tick
tick();

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────

self.onmessage = function(evt) {
  const msg = evt.data;
  stats.messages++;

  switch (msg.type) {
    case 'ROUTE': {
      const path = routeMessage(msg.src || 0, msg.dst || SPHERE_SIZE - 1);
      self.postMessage({ type: 'ROUTE_RESULT', path, hops: path.length - 1 });
      stats.routes++;
      break;
    }
    case 'MESH_DATA': {
      const nodes = MESH.points.map(p => ({ x: p.x, y: p.y, z: p.z, sector: p.sector }));
      const edges = [];
      const seen = new Set();
      for (const [i, ns] of MESH.edges) {
        for (const j of ns) {
          const key = Math.min(i, j) + '-' + Math.max(i, j);
          if (!seen.has(key)) { seen.add(key); edges.push([i, j]); }
        }
      }
      self.postMessage({ type: 'MESH_DATA', nodes, edges });
      break;
    }
    case 'STATUS':
      self.postMessage({
        type: 'STATUS',
        kernel: KERNEL_ID,
        name: KERNEL_NAME,
        family: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        build: KERNEL_BUILD,
        state: currentState,
        coherence: COR_PARVUM.orderParameter,
        stats: { ...stats },
      });
      break;
    default:
      break;
  }
};
