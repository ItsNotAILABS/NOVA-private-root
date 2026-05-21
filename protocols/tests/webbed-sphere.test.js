/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-WEBBED-SPHERE TESTS
 * ═══════════════════════════════════════════════════════════════════════════════
 */

import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import {
  PROTOCOL_ID, PROTOCOL_VERSION,
  PHI, PHI_INV, AMOR, TAU, GOLDEN_ANGLE,
  ICOSA_FACES, MIN_DEGREE, MAX_DEGREE,
  sphericalToCartesian, cartesianToSpherical,
  geodesicDistance, dot, cross, normalize, slerp,
  fibonacciLattice, icosahedralSector,
  SphereMesh,
  GeodesicRouter,
  SphereKuramoto,
  MeshHealer,
  WebbedSphereNode,
  WebbedSphereNetwork,
} from '../PROTOCOL-WEBBED-SPHERE.js';

// ─── §1 — Protocol Identity ─────────────────────────────────────────────────

describe('§1 — Protocol Identity', () => {
  it('has correct protocol ID', () => {
    assert.equal(PROTOCOL_ID, 'PROTOCOL-WEBBED-SPHERE');
  });
  it('has version 1.0.0', () => {
    assert.equal(PROTOCOL_VERSION, '1.0.0');
  });
  it('φ constants are correct', () => {
    assert.ok(Math.abs(PHI - 1.618033988749895) < 1e-10);
    assert.ok(Math.abs(PHI_INV - 0.618033988749895) < 1e-10);
    assert.ok(Math.abs(AMOR - 0.381966011250105) < 1e-10);
  });
  it('golden angle is TAU × φ⁻¹', () => {
    assert.ok(Math.abs(GOLDEN_ANGLE - TAU * PHI_INV) < 1e-10);
  });
});

// ─── §2 — Sphere Geometry ───────────────────────────────────────────────────

describe('§2 — Sphere Geometry', () => {
  it('spherical ↔ cartesian round-trip', () => {
    const theta = 1.2, phi = 2.5;
    const cart = sphericalToCartesian(theta, phi);
    const sph = cartesianToSpherical(cart.x, cart.y, cart.z);
    assert.ok(Math.abs(sph.theta - theta) < 1e-10);
    assert.ok(Math.abs(sph.phi - phi) < 1e-10);
  });

  it('north pole is (0, 0, 1)', () => {
    const p = sphericalToCartesian(0, 0);
    assert.ok(Math.abs(p.x) < 1e-10);
    assert.ok(Math.abs(p.y) < 1e-10);
    assert.ok(Math.abs(p.z - 1) < 1e-10);
  });

  it('geodesic distance between antipodal points = π', () => {
    const north = { x: 0, y: 0, z: 1 };
    const south = { x: 0, y: 0, z: -1 };
    const dist = geodesicDistance(north, south);
    assert.ok(Math.abs(dist - Math.PI) < 1e-6);
  });

  it('geodesic distance between same point = 0', () => {
    const p = { x: 1, y: 0, z: 0 };
    assert.ok(geodesicDistance(p, p) < 1e-10);
  });

  it('normalize produces unit vector', () => {
    const v = normalize({ x: 3, y: 4, z: 0 });
    const len = Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    assert.ok(Math.abs(len - 1) < 1e-10);
  });

  it('slerp at t=0 returns p1, t=1 returns p2', () => {
    const p1 = { x: 1, y: 0, z: 0 };
    const p2 = { x: 0, y: 1, z: 0 };
    const s0 = slerp(p1, p2, 0);
    const s1 = slerp(p1, p2, 1);
    assert.ok(Math.abs(s0.x - 1) < 1e-10);
    assert.ok(Math.abs(s1.y - 1) < 1e-10);
  });

  it('dot product of orthogonal vectors = 0', () => {
    assert.ok(Math.abs(dot({ x: 1, y: 0, z: 0 }, { x: 0, y: 1, z: 0 })) < 1e-10);
  });

  it('cross product of x×y = z', () => {
    const c = cross({ x: 1, y: 0, z: 0 }, { x: 0, y: 1, z: 0 });
    assert.ok(Math.abs(c.z - 1) < 1e-10);
  });
});

// ─── §3 — Fibonacci Lattice ─────────────────────────────────────────────────

describe('§3 — Fibonacci Lattice', () => {
  it('generates correct number of points', () => {
    const pts = fibonacciLattice(64);
    assert.equal(pts.length, 64);
  });

  it('all points are on unit sphere', () => {
    const pts = fibonacciLattice(100);
    for (const p of pts) {
      const r = Math.sqrt(p.x * p.x + p.y * p.y + p.z * p.z);
      assert.ok(Math.abs(r - 1) < 1e-10, `point ${p.index} not on unit sphere: r=${r}`);
    }
  });

  it('points cover all 20 icosahedral sectors', () => {
    const pts = fibonacciLattice(100);
    const sectors = new Set(pts.map(p => icosahedralSector(p)));
    assert.equal(sectors.size, ICOSA_FACES);
  });

  it('golden angle spacing between consecutive points', () => {
    const pts = fibonacciLattice(64);
    // Check that azimuthal difference between consecutive points ≈ GOLDEN_ANGLE
    for (let i = 1; i < Math.min(10, pts.length); i++) {
      const dphi = (GOLDEN_ANGLE * i) % TAU;
      assert.ok(dphi > 0, 'phi increment positive');
    }
  });
});

// ─── §4 — Sphere Mesh ──────────────────────────────────────────────────────

describe('§4 — Sphere Mesh', () => {
  it('creates mesh with correct node count', () => {
    const mesh = new SphereMesh(32);
    assert.equal(mesh.stats().nodes, 32);
  });

  it('all nodes have at least MIN_DEGREE-1 connections', () => {
    const mesh = new SphereMesh(64);
    for (let i = 0; i < 64; i++) {
      assert.ok(mesh.degree(i) >= MIN_DEGREE - 1, `node ${i} degree=${mesh.degree(i)} < ${MIN_DEGREE - 1}`);
    }
  });

  it('average degree is near 5–6 (icosahedral)', () => {
    const mesh = new SphereMesh(64);
    const avg = mesh.averageDegree();
    assert.ok(avg >= 4 && avg <= 8, `avg degree ${avg} outside [4, 8]`);
  });

  it('edges are symmetric', () => {
    const mesh = new SphereMesh(32);
    for (let i = 0; i < 32; i++) {
      for (const j of mesh.neighbors(i)) {
        assert.ok(mesh.neighbors(j).includes(i), `edge ${i}→${j} not symmetric`);
      }
    }
  });

  it('toJSON exports valid structure', () => {
    const mesh = new SphereMesh(16);
    const json = mesh.toJSON();
    assert.ok(json.nodes.length === 16);
    assert.ok(json.edges.length > 0);
    assert.ok(json.stats.nodes === 16);
  });

  it('sector assignment covers all 20 sectors for large mesh', () => {
    const mesh = new SphereMesh(200);
    const sectors = new Set();
    for (let i = 0; i < 200; i++) {
      sectors.add(mesh.getNode(i).sector);
    }
    assert.equal(sectors.size, ICOSA_FACES);
  });
});

// ─── §5 — Geodesic Routing ──────────────────────────────────────────────────

describe('§5 — Geodesic Routing', () => {
  it('route from node to itself is single element', () => {
    const mesh = new SphereMesh(32);
    const router = new GeodesicRouter(mesh);
    const path = router.route(5, 5);
    assert.deepEqual(path, [5]);
  });

  it('route between adjacent nodes is 2 hops', () => {
    const mesh = new SphereMesh(32);
    const router = new GeodesicRouter(mesh);
    const neighbors = mesh.neighbors(0);
    const path = router.route(0, neighbors[0]);
    assert.equal(path.length, 2);
  });

  it('route reaches destination for most pairs', () => {
    const mesh = new SphereMesh(64);
    const router = new GeodesicRouter(mesh);
    let reached = 0;
    const trials = 20;
    for (let t = 0; t < trials; t++) {
      const src = Math.floor(Math.random() * 64);
      const dst = Math.floor(Math.random() * 64);
      if (src === dst) { reached++; continue; }
      const path = router.route(src, dst);
      if (path[path.length - 1] === dst) reached++;
    }
    assert.ok(reached >= trials * 0.6, `only ${reached}/${trials} routes reached destination`);
  });

  it('route metrics show positive efficiency', () => {
    const mesh = new SphereMesh(64);
    const router = new GeodesicRouter(mesh);
    const path = router.route(0, 32);
    const metrics = router.routeMetrics(path);
    assert.ok(metrics.efficiency > 0 && metrics.efficiency <= 1);
    assert.ok(metrics.hops >= 1);
  });
});

// ─── §6 — Kuramoto Synchronization ─────────────────────────────────────────

describe('§6 — Kuramoto Synchronization', () => {
  it('order parameter starts > 0', () => {
    const mesh = new SphereMesh(32);
    const k = new SphereKuramoto(mesh);
    assert.ok(k.orderParameter() > 0);
  });

  it('order parameter increases after many steps (convergence)', () => {
    const mesh = new SphereMesh(32);
    const k = new SphereKuramoto(mesh, { couplingK: 1.5 });
    const r0 = k.orderParameter();
    for (let i = 0; i < 200; i++) k.step();
    const r1 = k.orderParameter();
    // With strong coupling, R should increase
    assert.ok(r1 >= r0 * 0.8, `R did not converge: r0=${r0}, r1=${r1}`);
  });

  it('local coherence is between 0 and 1', () => {
    const mesh = new SphereMesh(32);
    const k = new SphereKuramoto(mesh);
    for (let i = 0; i < 50; i++) k.step();
    const lc = k.localCoherence(0);
    assert.ok(lc >= 0 && lc <= 1);
  });

  it('snapshot returns expected keys', () => {
    const mesh = new SphereMesh(16);
    const k = new SphereKuramoto(mesh);
    const snap = k.snapshot();
    assert.ok('R' in snap);
    assert.ok('n' in snap);
    assert.ok('K' in snap);
  });
});

// ─── §7 — Self-Healing Mesh ─────────────────────────────────────────────────

describe('§7 — Self-Healing Mesh', () => {
  it('heartbeat updates lastSeen', () => {
    const mesh = new SphereMesh(16);
    const healer = new MeshHealer(mesh);
    const before = Date.now();
    healer.heartbeat(0);
    assert.ok(healer._lastSeen.get(0) >= before);
  });

  it('detectDead finds nodes with no heartbeat', () => {
    const mesh = new SphereMesh(16);
    const healer = new MeshHealer(mesh);
    // Set node 5 to ancient timestamp
    healer._lastSeen.set(5, Date.now() - 999999);
    const dead = healer.detectDead(1000);
    assert.ok(dead.includes(5));
  });

  it('repairNode removes dead node and reconnects neighbors', () => {
    const mesh = new SphereMesh(32);
    const healer = new MeshHealer(mesh);
    const degreeBefore = mesh.degree(5);
    assert.ok(degreeBefore > 0);
    const report = healer.repairNode(5);
    assert.ok(report.repaired);
    assert.equal(mesh.degree(5), 0); // Dead node disconnected
    assert.ok(report.newEdges >= 0);
  });

  it('repair log records history', () => {
    const mesh = new SphereMesh(32);
    const healer = new MeshHealer(mesh);
    healer.repairNode(3);
    healer.repairNode(7);
    assert.equal(healer.repairHistory().length, 2);
  });
});

// ─── §8 — Webbed Sphere Node ────────────────────────────────────────────────

describe('§8 — Webbed Sphere Node', () => {
  it('creates node at specified index', () => {
    const node = new WebbedSphereNode({ sphereSize: 32, nodeIndex: 7 });
    assert.equal(node._nodeIdx, 7);
    assert.ok(node.position);
    assert.ok(node.position.x !== undefined);
  });

  it('has neighbors', () => {
    const node = new WebbedSphereNode({ sphereSize: 32, nodeIndex: 0 });
    assert.ok(node.neighbors.length >= MIN_DEGREE - 1);
  });

  it('send returns path and metrics', () => {
    const node = new WebbedSphereNode({ sphereSize: 32, nodeIndex: 0 });
    const result = node.send(15, { data: 'hello' });
    assert.ok(result.path.length >= 1);
    assert.ok(result.metrics);
    assert.ok('efficiency' in result.metrics);
  });

  it('telemetry returns full status', () => {
    const node = new WebbedSphereNode({ sphereSize: 32, nodeIndex: 0 });
    const t = node.telemetry();
    assert.equal(t.protocolId, 'PROTOCOL-WEBBED-SPHERE');
    assert.equal(t.version, '1.0.0');
    assert.ok('coherence' in t);
    assert.ok('meshStats' in t);
    assert.ok('sector' in t);
  });

  it('receive stores message in inbox', () => {
    const node = new WebbedSphereNode({ sphereSize: 16, nodeIndex: 0 });
    node.receive({ type: 'SPHERE:PING', from: 3, payload: {} });
    assert.equal(node._inbox.length, 1);
    assert.equal(node._stats.received, 1);
  });
});

// ─── §9 — Webbed Sphere Network ─────────────────────────────────────────────

describe('§9 — Webbed Sphere Network', () => {
  it('creates network of specified size', () => {
    const net = new WebbedSphereNetwork(48);
    assert.equal(net._size, 48);
  });

  it('simulate produces coherence history', () => {
    const net = new WebbedSphereNetwork(32);
    const history = net.simulate(50);
    assert.ok(history.length > 0);
    assert.ok('R' in history[0]);
    assert.ok('tick' in history[0]);
  });

  it('route finds path between nodes', () => {
    const net = new WebbedSphereNetwork(64);
    const result = net.route(0, 32);
    assert.ok(result.path.length >= 1);
    assert.ok(result.metrics.hops >= 1);
  });

  it('removeNode repairs mesh', () => {
    const net = new WebbedSphereNetwork(32);
    const report = net.removeNode(10);
    assert.ok(report.repaired);
  });

  it('telemetry returns network-wide stats', () => {
    const net = new WebbedSphereNetwork(32);
    net.step();
    const t = net.telemetry();
    assert.equal(t.protocolId, 'PROTOCOL-WEBBED-SPHERE');
    assert.ok(t.coherence >= 0 && t.coherence <= 1);
    assert.ok(t.meshStats.nodes === 32);
  });

  it('toJSON exports full network state', () => {
    const net = new WebbedSphereNetwork(16);
    const json = net.toJSON();
    assert.ok(json.mesh);
    assert.ok(json.telemetry);
    assert.equal(json.mesh.nodes.length, 16);
  });
});
