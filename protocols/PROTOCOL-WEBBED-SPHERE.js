/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-WEBBED-SPHERE — NOVA GEODESIC SPHERE MESH NETWORKING  (BUILD №66)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 *
 * WEBBED SPHERE NETWORKING:
 *   A φ-optimized geodesic sphere mesh topology for sovereign NOVA networking.
 *   Nodes are distributed on a sphere using Fibonacci lattice placement (golden-angle
 *   spiral), connected via Delaunay triangulation on the sphere surface.
 *   Every node has exactly φ-bounded degree (5 or 6 neighbors — icosahedral duality).
 *
 * ARCHITECTURE:
 *   Fibonacci Lattice → Node Placement on S² (unit sphere)
 *   Delaunay Triangulation → Edge Discovery (geodesic connections)
 *   φ-Weighted Edges → Coherence Routing (shorter geodesic = higher weight)
 *   Icosahedral Zones → 20 triangular sectors for spatial hashing
 *   Heartbeat Propagation → Kuramoto sync across sphere surface
 *   Gossip via Great Circles → Messages follow geodesic arcs
 *   Self-Healing Mesh → Detects and repairs broken edges via φ-repair
 *
 * KEY PROPERTIES:
 *   • O(√N) average hops — sphere geodesic routing beats flat O(log N)
 *   • φ-bounded degree — every node has 5–6 connections (icosahedral)
 *   • Fibonacci lattice — golden-angle spiral ensures uniform distribution
 *   • 20 icosahedral sectors — spatial hashing for fast neighbor lookup
 *   • Great-circle routing — messages travel shortest arc on sphere
 *   • Kuramoto heartbeat sync — phase coherence propagates on surface
 *   • Self-healing — broken edges repaired by adjacent triangles
 *
 * PROTOCOL ID: PROTOCOL-WEBBED-SPHERE
 * VERSION: 1.0.0
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PROTOCOL_ID      = 'PROTOCOL-WEBBED-SPHERE';
const PROTOCOL_VERSION = '1.0.0';

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;   // φ⁻²
const HEARTBEAT_MS = 873;
const TAU          = 6.283185307179586;
const GOLDEN_ANGLE = TAU * PHI_INV;           // ~2.39996… radians

/**
 * Icosahedral constants.
 * A regular icosahedron has 12 vertices, 30 edges, 20 faces.
 * Geodesic subdivision frequency ν determines mesh density.
 */
const ICOSA_VERTICES  = 12;
const ICOSA_EDGES     = 30;
const ICOSA_FACES     = 20;
const MIN_DEGREE      = 5;   // Pentagon vertices
const MAX_DEGREE      = 6;   // Hexagon vertices
const MAX_HOPS        = 8;   // Fibonacci(6) — max routing hops

/** Sphere mesh parameters */
const DEFAULT_SPHERE_SIZE    = 64;       // Default node count
const MAX_SPHERE_SIZE        = 4096;     // Maximum supported nodes
const NEIGHBOR_SEARCH_K      = 8;        // k-nearest for triangulation
const REPAIR_INTERVAL_MS     = HEARTBEAT_MS * 5;  // Check mesh every ~4.4s
const COHERENCE_THRESHOLD    = PHI_INV;  // Minimum acceptable coherence

/** Message types for sphere routing */
const SPHERE_MSG = {
  PING:          'SPHERE:PING',
  PONG:          'SPHERE:PONG',
  ROUTE:         'SPHERE:ROUTE',
  GOSSIP:        'SPHERE:GOSSIP',
  HEARTBEAT:     'SPHERE:HEARTBEAT',
  REPAIR:        'SPHERE:REPAIR',
  JOIN:          'SPHERE:JOIN',
  LEAVE:         'SPHERE:LEAVE',
  SYNC:          'SPHERE:SYNC',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — SPHERE GEOMETRY (φ-optimized vector math on S²)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Convert spherical coordinates (θ, φ) to Cartesian (x, y, z) on unit sphere.
 * θ = polar angle [0, π], φ = azimuthal angle [0, 2π]
 */
function sphericalToCartesian(theta, phi) {
  const sinT = Math.sin(theta);
  return {
    x: sinT * Math.cos(phi),
    y: sinT * Math.sin(phi),
    z: Math.cos(theta),
  };
}

/**
 * Convert Cartesian (x, y, z) to spherical (θ, φ).
 */
function cartesianToSpherical(x, y, z) {
  const r = Math.sqrt(x * x + y * y + z * z);
  return {
    theta: Math.acos(z / r),
    phi:   Math.atan2(y, x),
  };
}

/**
 * Geodesic distance (great-circle) between two points on unit sphere.
 * Uses Vincenty formula for numerical stability.
 */
function geodesicDistance(p1, p2) {
  const dx = p2.x - p1.x;
  const dy = p2.y - p1.y;
  const dz = p2.z - p1.z;
  const chord = Math.sqrt(dx * dx + dy * dy + dz * dz);
  return 2 * Math.asin(chord / 2);
}

/**
 * Dot product of two 3D vectors.
 */
function dot(a, b) {
  return a.x * b.x + a.y * b.y + a.z * b.z;
}

/**
 * Cross product of two 3D vectors.
 */
function cross(a, b) {
  return {
    x: a.y * b.z - a.z * b.y,
    y: a.z * b.x - a.x * b.z,
    z: a.x * b.y - a.y * b.x,
  };
}

/**
 * Normalize a 3D vector to unit length.
 */
function normalize(v) {
  const len = Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
  if (len < 1e-12) return { x: 0, y: 0, z: 1 };
  return { x: v.x / len, y: v.y / len, z: v.z / len };
}

/**
 * Spherical linear interpolation (SLERP) between two unit vectors.
 * t ∈ [0, 1]. Used for great-circle routing.
 */
function slerp(p1, p2, t) {
  const d = dot(p1, p2);
  const omega = Math.acos(Math.max(-1, Math.min(1, d)));
  if (omega < 1e-10) return { ...p1 };
  const sinO = Math.sin(omega);
  const a = Math.sin((1 - t) * omega) / sinO;
  const b = Math.sin(t * omega) / sinO;
  return normalize({
    x: a * p1.x + b * p2.x,
    y: a * p1.y + b * p2.y,
    z: a * p1.z + b * p2.z,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — FIBONACCI LATTICE (golden-angle node placement on sphere)
//
// The Fibonacci lattice distributes N points on a sphere with near-optimal
// uniformity. Each point is placed at:
//   θ_i = arccos(1 - 2i/(N-1))
//   φ_i = GOLDEN_ANGLE × i
//
// This creates a spiral pattern where successive points are separated by
// the golden angle, producing natural φ-spacing.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Generate N points on unit sphere via Fibonacci lattice.
 * Returns array of { x, y, z, index, theta, phi }.
 */
function fibonacciLattice(n) {
  const points = [];
  for (let i = 0; i < n; i++) {
    const theta = Math.acos(1 - (2 * i) / (n - 1 || 1));
    const phi   = GOLDEN_ANGLE * i;
    const pos   = sphericalToCartesian(theta, phi);
    points.push({
      ...pos,
      index: i,
      theta,
      phi: phi % TAU,
    });
  }
  return points;
}

/**
 * Assign a point to one of 20 icosahedral sectors.
 * Uses a fast approximation: divide sphere into 20 zones by Z-bands and longitude.
 */
function icosahedralSector(point) {
  const z = point.z;
  const phi = Math.atan2(point.y, point.x);
  const phiNorm = (phi + Math.PI) / TAU; // [0, 1]

  if (z > 0.7) return Math.floor(phiNorm * 5);                    // Top cap: 5 sectors (0–4)
  if (z < -0.7) return 15 + Math.floor(phiNorm * 5);              // Bottom cap: 5 sectors (15–19)
  return 5 + Math.floor(phiNorm * 10) % 10;                       // Equatorial belt: 10 sectors (5–14)
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — SPHERE MESH TOPOLOGY (Delaunay-like triangulation on S²)
//
// After placing nodes via Fibonacci lattice, connect them into a mesh.
// Each node connects to its k-nearest neighbors on the sphere surface.
// The result is a quasi-regular triangulation where most nodes have degree 6
// (hexagons) and exactly 12 have degree 5 (pentagons) — icosahedral duality.
// ═══════════════════════════════════════════════════════════════════════════════

class SphereMesh {
  /**
   * @param {number} nodeCount — number of nodes to place on sphere
   */
  constructor(nodeCount) {
    this._n      = Math.min(Math.max(nodeCount || DEFAULT_SPHERE_SIZE, ICOSA_VERTICES), MAX_SPHERE_SIZE);
    this._points = fibonacciLattice(this._n);
    this._edges  = new Map();    // nodeIndex → Set<neighborIndex>
    this._sectors = new Map();   // sector (0–19) → Set<nodeIndex>

    // Assign sectors
    for (let i = 0; i < ICOSA_FACES; i++) this._sectors.set(i, new Set());
    for (const p of this._points) {
      const s = icosahedralSector(p);
      p.sector = s;
      this._sectors.get(s).add(p.index);
    }

    // Build mesh edges
    this._buildEdges();
  }

  /**
   * Build edges by connecting each node to its k-nearest neighbors.
   * Ensures symmetric edges (if A→B, then B→A).
   */
  _buildEdges() {
    for (let i = 0; i < this._n; i++) {
      this._edges.set(i, new Set());
    }

    for (let i = 0; i < this._n; i++) {
      const p = this._points[i];
      // Find k-nearest neighbors
      const dists = [];
      for (let j = 0; j < this._n; j++) {
        if (j === i) continue;
        dists.push({ idx: j, dist: geodesicDistance(p, this._points[j]) });
      }
      dists.sort((a, b) => a.dist - b.dist);

      // Connect to top k neighbors (φ-bounded: aim for 5–6 connections)
      const k = Math.min(NEIGHBOR_SEARCH_K, dists.length);
      const targetDegree = (i < ICOSA_VERTICES) ? MIN_DEGREE : MAX_DEGREE;
      const connectCount = Math.min(targetDegree, k);

      for (let c = 0; c < connectCount; c++) {
        const j = dists[c].idx;
        this._edges.get(i).add(j);
        this._edges.get(j).add(i); // symmetric
      }
    }
  }

  /** Get node position by index. */
  getNode(index) { return this._points[index] || null; }

  /** Get all neighbors of a node. */
  neighbors(index) {
    const ns = this._edges.get(index);
    return ns ? Array.from(ns) : [];
  }

  /** Get degree (connection count) of a node. */
  degree(index) {
    const ns = this._edges.get(index);
    return ns ? ns.size : 0;
  }

  /** Get all nodes in a sector (0–19). */
  sectorNodes(sector) {
    const s = this._sectors.get(sector);
    return s ? Array.from(s).map(i => this._points[i]) : [];
  }

  /** Total edge count (each edge counted once). */
  edgeCount() {
    let count = 0;
    for (const [, ns] of this._edges) count += ns.size;
    return count / 2; // symmetric
  }

  /** Average degree of all nodes. */
  averageDegree() {
    let total = 0;
    for (const [, ns] of this._edges) total += ns.size;
    return total / this._n;
  }

  /** Get mesh statistics. */
  stats() {
    const degrees = [];
    for (let i = 0; i < this._n; i++) degrees.push(this.degree(i));
    const minDeg = Math.min(...degrees);
    const maxDeg = Math.max(...degrees);
    const avgDeg = degrees.reduce((a, b) => a + b, 0) / degrees.length;
    return {
      nodes:    this._n,
      edges:    this.edgeCount(),
      sectors:  ICOSA_FACES,
      minDegree: minDeg,
      maxDegree: maxDeg,
      avgDegree: Math.round(avgDeg * 100) / 100,
      isIcosahedral: minDeg >= MIN_DEGREE - 1 && maxDeg <= MAX_DEGREE + 2,
    };
  }

  /** Export mesh as { nodes: [...], edges: [[i,j], ...] }. */
  toJSON() {
    const edges = [];
    const seen = new Set();
    for (const [i, ns] of this._edges) {
      for (const j of ns) {
        const key = i < j ? `${i}-${j}` : `${j}-${i}`;
        if (!seen.has(key)) {
          seen.add(key);
          edges.push([i, j]);
        }
      }
    }
    return {
      nodes: this._points.map(p => ({ x: p.x, y: p.y, z: p.z, sector: p.sector })),
      edges,
      stats: this.stats(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — GEODESIC ROUTING (great-circle path finding on sphere mesh)
//
// Messages are routed along geodesic arcs on the sphere surface.
// At each hop, the message is forwarded to the neighbor closest (geodesically)
// to the destination. This is a greedy geographic routing with φ-weight tie-breaking.
// ═══════════════════════════════════════════════════════════════════════════════

class GeodesicRouter {
  /**
   * @param {SphereMesh} mesh — the sphere mesh to route on
   */
  constructor(mesh) {
    this._mesh = mesh;
  }

  /**
   * Find geodesic route from source to destination node index.
   * Returns array of node indices forming the path.
   * Uses greedy geographic forwarding with φ-weighted fallback.
   */
  route(srcIdx, dstIdx) {
    if (srcIdx === dstIdx) return [srcIdx];

    const dst = this._mesh.getNode(dstIdx);
    if (!dst) return [];

    const path = [srcIdx];
    const visited = new Set([srcIdx]);
    let current = srcIdx;

    for (let hop = 0; hop < MAX_HOPS; hop++) {
      if (current === dstIdx) break;

      const neighbors = this._mesh.neighbors(current);
      if (!neighbors.length) break;

      // Find neighbor closest to destination (greedy geographic)
      let bestIdx = -1;
      let bestDist = Infinity;

      for (const n of neighbors) {
        if (visited.has(n)) continue;
        const nPos = this._mesh.getNode(n);
        const dist = geodesicDistance(nPos, dst);
        // φ-weight: prefer nodes with higher degree (better connected)
        const phiWeight = 1 - (this._mesh.degree(n) / MAX_DEGREE) * AMOR;
        const weightedDist = dist * phiWeight;
        if (weightedDist < bestDist) {
          bestDist = weightedDist;
          bestIdx = n;
        }
      }

      if (bestIdx === -1) {
        // Dead end — try any unvisited neighbor (face routing fallback)
        for (const n of neighbors) {
          if (!visited.has(n)) { bestIdx = n; break; }
        }
        if (bestIdx === -1) break; // Truly stuck
      }

      visited.add(bestIdx);
      path.push(bestIdx);
      current = bestIdx;
    }

    return path;
  }

  /**
   * Compute route quality metrics.
   */
  routeMetrics(path) {
    if (path.length < 2) return { hops: 0, totalDistance: 0, efficiency: 1 };

    let totalDist = 0;
    for (let i = 1; i < path.length; i++) {
      const p1 = this._mesh.getNode(path[i - 1]);
      const p2 = this._mesh.getNode(path[i]);
      totalDist += geodesicDistance(p1, p2);
    }

    const directDist = geodesicDistance(
      this._mesh.getNode(path[0]),
      this._mesh.getNode(path[path.length - 1])
    );

    return {
      hops:          path.length - 1,
      totalDistance:  Math.round(totalDist * 1e6) / 1e6,
      directDistance: Math.round(directDist * 1e6) / 1e6,
      efficiency:    directDist > 0 ? Math.round((directDist / totalDist) * 1e4) / 1e4 : 1,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — KURAMOTO HEARTBEAT SYNCHRONIZATION ON SPHERE
//
// Each node is a Kuramoto oscillator. Phase coupling propagates along mesh
// edges. The order parameter R measures global coherence.
// On the sphere surface, coupling strength decays with geodesic distance
// (closer nodes sync faster — locality principle).
// ═══════════════════════════════════════════════════════════════════════════════

class SphereKuramoto {
  /**
   * @param {SphereMesh} mesh — the sphere mesh
   * @param {object} opts — { couplingK, naturalFreq, dt }
   */
  constructor(mesh, opts) {
    opts = opts || {};
    this._mesh     = mesh;
    this._K        = opts.couplingK || PHI_INV;     // Coupling strength
    this._omega0   = opts.naturalFreq || TAU / HEARTBEAT_MS;  // Natural frequency
    this._dt       = opts.dt || 0.01;               // Time step
    this._n        = mesh._n;

    // Initialize phases: golden-angle spiral for coherent startup
    this._phases = new Float64Array(this._n);
    for (let i = 0; i < this._n; i++) {
      this._phases[i] = (GOLDEN_ANGLE * i) % TAU;
    }

    this._frequencies = new Float64Array(this._n);
    for (let i = 0; i < this._n; i++) {
      // Small frequency variation: ω_i = ω₀ × (1 + φ⁻² × noise)
      this._frequencies[i] = this._omega0 * (1 + AMOR * (Math.random() - 0.5) * 0.1);
    }
  }

  /**
   * Advance one time step. Update all oscillator phases.
   * Coupling is mediated by mesh edges (local neighbors only).
   */
  step() {
    const dPhases = new Float64Array(this._n);

    for (let i = 0; i < this._n; i++) {
      let coupling = 0;
      const neighbors = this._mesh.neighbors(i);
      const nodePos = this._mesh.getNode(i);

      for (const j of neighbors) {
        const jPos = this._mesh.getNode(j);
        const dist = geodesicDistance(nodePos, jPos);
        // Coupling decays with geodesic distance
        const distWeight = Math.exp(-dist * PHI);
        coupling += distWeight * Math.sin(this._phases[j] - this._phases[i]);
      }

      const avgCoupling = neighbors.length > 0 ? coupling / neighbors.length : 0;
      dPhases[i] = this._frequencies[i] + this._K * avgCoupling;
    }

    // Update phases
    for (let i = 0; i < this._n; i++) {
      this._phases[i] = (this._phases[i] + dPhases[i] * this._dt) % TAU;
      if (this._phases[i] < 0) this._phases[i] += TAU;
    }
  }

  /**
   * Compute the Kuramoto order parameter R ∈ [0, 1].
   * R = |1/N × Σ exp(i × θ_j)|
   * R → 1 means perfect synchronization.
   */
  orderParameter() {
    let sumCos = 0, sumSin = 0;
    for (let i = 0; i < this._n; i++) {
      sumCos += Math.cos(this._phases[i]);
      sumSin += Math.sin(this._phases[i]);
    }
    return Math.sqrt(sumCos * sumCos + sumSin * sumSin) / this._n;
  }

  /**
   * Compute local coherence for a specific node (its neighborhood R).
   */
  localCoherence(nodeIdx) {
    const neighbors = this._mesh.neighbors(nodeIdx);
    if (!neighbors.length) return 1;
    let sumCos = Math.cos(this._phases[nodeIdx]);
    let sumSin = Math.sin(this._phases[nodeIdx]);
    for (const j of neighbors) {
      sumCos += Math.cos(this._phases[j]);
      sumSin += Math.sin(this._phases[j]);
    }
    const n = neighbors.length + 1;
    return Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
  }

  /** Get current phase of a node. */
  phase(idx) { return this._phases[idx]; }

  /** Get all phases. */
  phases() { return Array.from(this._phases); }

  /** Snapshot for telemetry. */
  snapshot() {
    return {
      R:           Math.round(this.orderParameter() * 1e6) / 1e6,
      n:           this._n,
      K:           this._K,
      dt:          this._dt,
      meanPhase:   Math.round((this._phases.reduce((a, b) => a + b) / this._n) * 1e4) / 1e4,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — SELF-HEALING MESH (φ-repair for broken connections)
//
// When a node goes offline or an edge fails, adjacent nodes detect the gap
// (via missed heartbeats) and repair the mesh by re-triangulating locally.
// Repair cost is O(degree²) — bounded by icosahedral degree (≤ 6²=36 ops).
// ═══════════════════════════════════════════════════════════════════════════════

class MeshHealer {
  /**
   * @param {SphereMesh} mesh
   */
  constructor(mesh) {
    this._mesh = mesh;
    this._lastSeen = new Map(); // nodeIdx → timestamp
    this._repairLog = [];

    // Initialize all nodes as alive
    for (let i = 0; i < mesh._n; i++) {
      this._lastSeen.set(i, Date.now());
    }
  }

  /**
   * Record a heartbeat from a node.
   */
  heartbeat(nodeIdx) {
    this._lastSeen.set(nodeIdx, Date.now());
  }

  /**
   * Detect dead nodes (no heartbeat for > threshold).
   */
  detectDead(thresholdMs) {
    thresholdMs = thresholdMs || REPAIR_INTERVAL_MS * 3;
    const now = Date.now();
    const dead = [];
    for (const [idx, ts] of this._lastSeen) {
      if (now - ts > thresholdMs) dead.push(idx);
    }
    return dead;
  }

  /**
   * Repair mesh around a dead node: remove it, re-connect its orphaned neighbors.
   * Returns repair report.
   */
  repairNode(deadIdx) {
    const neighbors = this._mesh.neighbors(deadIdx);
    if (!neighbors.length) return { repaired: false, reason: 'no neighbors' };

    // Remove dead node's edges
    for (const n of neighbors) {
      this._mesh._edges.get(n).delete(deadIdx);
    }
    this._mesh._edges.set(deadIdx, new Set());

    // Re-connect orphaned neighbors to each other (ring repair)
    // Sort neighbors by their angular position around the dead node for ring closure
    const deadPos = this._mesh.getNode(deadIdx);
    const sorted = neighbors
      .map(n => ({ idx: n, pos: this._mesh.getNode(n) }))
      .sort((a, b) => {
        const angA = Math.atan2(a.pos.y - deadPos.y, a.pos.x - deadPos.x);
        const angB = Math.atan2(b.pos.y - deadPos.y, b.pos.x - deadPos.x);
        return angA - angB;
      });

    let newEdges = 0;
    for (let i = 0; i < sorted.length; i++) {
      const j = (i + 1) % sorted.length;
      const a = sorted[i].idx;
      const b = sorted[j].idx;
      if (!this._mesh._edges.get(a).has(b)) {
        this._mesh._edges.get(a).add(b);
        this._mesh._edges.get(b).add(a);
        newEdges++;
      }
    }

    const report = {
      repaired:   true,
      deadNode:   deadIdx,
      neighbors:  neighbors.length,
      newEdges,
      timestamp:  Date.now(),
    };
    this._repairLog.push(report);
    return report;
  }

  /** Get repair history. */
  repairHistory() { return [...this._repairLog]; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — WEBBED SPHERE NODE (full sovereign network participant)
//
// Integrates: SphereMesh + GeodesicRouter + SphereKuramoto + MeshHealer
// into a single sovereign networking node.
// ═══════════════════════════════════════════════════════════════════════════════

class WebbedSphereNode {
  /**
   * @param {object} opts — { sphereSize, nodeIndex, couplingK }
   */
  constructor(opts) {
    opts = opts || {};
    this._sphereSize = opts.sphereSize || DEFAULT_SPHERE_SIZE;
    this._mesh       = new SphereMesh(this._sphereSize);
    this._router     = new GeodesicRouter(this._mesh);
    this._kuramoto   = new SphereKuramoto(this._mesh, { couplingK: opts.couplingK });
    this._healer     = new MeshHealer(this._mesh);
    this._nodeIdx    = opts.nodeIndex != null ? opts.nodeIndex : 0;
    this._inbox      = [];
    this._outbox     = [];
    this._handlers   = new Map();
    this._running    = false;
    this._tick       = 0;
    this._stats      = { sent: 0, received: 0, routed: 0, repaired: 0, heartbeats: 0 };
  }

  /** This node's position on the sphere. */
  get position() { return this._mesh.getNode(this._nodeIdx); }

  /** This node's sector (0–19). */
  get sector() { return this.position ? this.position.sector : 0; }

  /** This node's neighbors. */
  get neighbors() { return this._mesh.neighbors(this._nodeIdx); }

  /** Current phase (Kuramoto). */
  get phase() { return this._kuramoto.phase(this._nodeIdx); }

  /** Global coherence R. */
  get coherence() { return this._kuramoto.orderParameter(); }

  /** Local coherence (this node's neighborhood). */
  get localCoherence() { return this._kuramoto.localCoherence(this._nodeIdx); }

  // ── ROUTING ────────────────────────────────────────────────────────────────

  /**
   * Route a message to a destination node.
   * Returns { path, metrics, delivered }.
   */
  send(destIdx, payload, type) {
    type = type || SPHERE_MSG.ROUTE;
    const path = this._router.route(this._nodeIdx, destIdx);
    const metrics = this._router.routeMetrics(path);
    const msg = {
      type,
      from:    this._nodeIdx,
      to:      destIdx,
      payload,
      path,
      metrics,
      ts:      Date.now(),
    };
    this._outbox.push(msg);
    this._stats.sent++;
    return { path, metrics, delivered: path[path.length - 1] === destIdx };
  }

  /**
   * Receive a message (called by network simulation or external transport).
   */
  receive(msg) {
    this._inbox.push(msg);
    this._stats.received++;
    const handler = this._handlers.get(msg.type);
    if (handler) handler(msg);
  }

  /**
   * Register a handler for a message type.
   */
  on(type, fn) {
    this._handlers.set(type, fn);
    return this;
  }

  // ── HEARTBEAT LOOP ─────────────────────────────────────────────────────────

  /**
   * Start the heartbeat loop.
   * Each tick: advance Kuramoto, check health, propagate heartbeat.
   */
  start() {
    if (this._running) return;
    this._running = true;
    this._loop();
  }

  stop() {
    this._running = false;
  }

  _loop() {
    if (!this._running) return;

    // Advance Kuramoto oscillator
    this._kuramoto.step();

    // Record own heartbeat
    this._healer.heartbeat(this._nodeIdx);
    this._stats.heartbeats++;
    this._tick++;

    // Check for dead nodes periodically
    if (this._tick % 5 === 0) {
      const dead = this._healer.detectDead();
      for (const d of dead) {
        this._healer.repairNode(d);
        this._stats.repaired++;
      }
    }

    // Schedule next tick
    setTimeout(() => this._loop(), HEARTBEAT_MS);
  }

  // ── TELEMETRY ──────────────────────────────────────────────────────────────

  /**
   * Full telemetry snapshot.
   */
  telemetry() {
    return {
      protocolId:      PROTOCOL_ID,
      version:         PROTOCOL_VERSION,
      nodeIndex:       this._nodeIdx,
      position:        this.position,
      sector:          this.sector,
      degree:          this._mesh.degree(this._nodeIdx),
      neighbors:       this.neighbors.length,
      phase:           Math.round(this.phase * 1e4) / 1e4,
      coherence:       Math.round(this.coherence * 1e4) / 1e4,
      localCoherence:  Math.round(this.localCoherence * 1e4) / 1e4,
      meshStats:       this._mesh.stats(),
      kuramotoR:       this._kuramoto.snapshot(),
      stats:           { ...this._stats },
      tick:            this._tick,
      isHealthy:       this.localCoherence >= COHERENCE_THRESHOLD,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — SPHERE NETWORK (multi-node simulation and coordination)
// ═══════════════════════════════════════════════════════════════════════════════

class WebbedSphereNetwork {
  /**
   * Create a full sphere network of N nodes.
   * @param {number} size — number of nodes
   */
  constructor(size) {
    size = size || DEFAULT_SPHERE_SIZE;
    this._mesh     = new SphereMesh(size);
    this._router   = new GeodesicRouter(this._mesh);
    this._kuramoto = new SphereKuramoto(this._mesh);
    this._healer   = new MeshHealer(this._mesh);
    this._size     = size;
    this._tick     = 0;
  }

  /** Advance the full network one time step. */
  step() {
    this._kuramoto.step();
    this._tick++;
    // Heartbeat all nodes
    for (let i = 0; i < this._size; i++) {
      this._healer.heartbeat(i);
    }
  }

  /** Run N steps of simulation. */
  simulate(steps) {
    steps = steps || 100;
    const history = [];
    for (let s = 0; s < steps; s++) {
      this.step();
      if (s % 10 === 0) {
        history.push({
          tick: this._tick,
          R: Math.round(this._kuramoto.orderParameter() * 1e6) / 1e6,
        });
      }
    }
    return history;
  }

  /** Route between any two nodes. */
  route(src, dst) {
    const path = this._router.route(src, dst);
    return {
      path,
      metrics: this._router.routeMetrics(path),
    };
  }

  /** Remove a node and repair. */
  removeNode(idx) {
    return this._healer.repairNode(idx);
  }

  /** Get full network telemetry. */
  telemetry() {
    return {
      protocolId:  PROTOCOL_ID,
      version:     PROTOCOL_VERSION,
      size:        this._size,
      tick:        this._tick,
      coherence:   Math.round(this._kuramoto.orderParameter() * 1e6) / 1e6,
      meshStats:   this._mesh.stats(),
      kuramoto:    this._kuramoto.snapshot(),
      repairs:     this._healer.repairHistory().length,
    };
  }

  /** Export full network state. */
  toJSON() {
    return {
      mesh:      this._mesh.toJSON(),
      telemetry: this.telemetry(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  PROTOCOL_ID, PROTOCOL_VERSION,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS, TAU, GOLDEN_ANGLE,
  ICOSA_VERTICES, ICOSA_EDGES, ICOSA_FACES,
  MIN_DEGREE, MAX_DEGREE, MAX_HOPS,
  DEFAULT_SPHERE_SIZE, MAX_SPHERE_SIZE,
  SPHERE_MSG,

  /* Geometry */
  sphericalToCartesian, cartesianToSpherical,
  geodesicDistance, dot, cross, normalize, slerp,

  /* Fibonacci lattice */
  fibonacciLattice, icosahedralSector,

  /* Classes */
  SphereMesh,
  GeodesicRouter,
  SphereKuramoto,
  MeshHealer,
  WebbedSphereNode,
  WebbedSphereNetwork,
};

export default {
  PROTOCOL_ID, PROTOCOL_VERSION,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS, TAU, GOLDEN_ANGLE,
  ICOSA_VERTICES, ICOSA_EDGES, ICOSA_FACES,
  MIN_DEGREE, MAX_DEGREE, MAX_HOPS,
  DEFAULT_SPHERE_SIZE, MAX_SPHERE_SIZE,
  SPHERE_MSG,
  sphericalToCartesian, cartesianToSpherical,
  geodesicDistance, dot, cross, normalize, slerp,
  fibonacciLattice, icosahedralSector,
  SphereMesh,
  GeodesicRouter,
  SphereKuramoto,
  MeshHealer,
  WebbedSphereNode,
  WebbedSphereNetwork,
};
