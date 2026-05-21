/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-MAINNET-DEPLOY TESTS  (BUILD №67)
 * ═══════════════════════════════════════════════════════════════════════════════
 */

import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import {
  PROTOCOL_ID, PROTOCOL_VERSION, BUILD_NUMBER,
  PHI, PHI_INV, AMOR,
  NETWORK, MIN_CYCLES,
  ALPHA_REGISTRY, DEPLOY_PHASES,
  preflightChecks, preflightSummary,
  generateManifest,
  DeploymentTracker,
  healthCheck, fleetCoherenceCheck,
  simulateDeploy,
} from '../PROTOCOL-MAINNET-DEPLOY.js';

// ─── §1 — Protocol Identity ─────────────────────────────────────────────────

describe('§1 — Protocol Identity', () => {
  it('has correct protocol ID', () => {
    assert.equal(PROTOCOL_ID, 'PROTOCOL-MAINNET-DEPLOY');
  });
  it('has version 1.0.0', () => {
    assert.equal(PROTOCOL_VERSION, '1.0.0');
  });
  it('build number is 67', () => {
    assert.equal(BUILD_NUMBER, 67);
  });
  it('network is ic (mainnet)', () => {
    assert.equal(NETWORK, 'ic');
  });
  it('φ constants correct', () => {
    assert.ok(Math.abs(PHI - 1.618033988749895) < 1e-10);
    assert.ok(Math.abs(PHI_INV - 0.618033988749895) < 1e-10);
    assert.ok(Math.abs(AMOR - 0.381966011250105) < 1e-10);
  });
});

// ─── §2 — Alpha Registry ────────────────────────────────────────────────────

describe('§2 — Alpha Registry', () => {
  it('has exactly 10 Alpha AGIs', () => {
    assert.equal(ALPHA_REGISTRY.length, 10);
  });

  it('all Alphas have required fields', () => {
    for (const alpha of ALPHA_REGISTRY) {
      assert.ok(alpha.code, `Missing code for ${alpha.name}`);
      assert.ok(alpha.id, `Missing id for ${alpha.name}`);
      assert.ok(alpha.name, `Missing name`);
      assert.ok(alpha.family, `Missing family for ${alpha.name}`);
      assert.ok(alpha.port > 0, `Invalid port for ${alpha.name}`);
      assert.ok(alpha.role, `Missing role for ${alpha.name}`);
      assert.ok(Array.isArray(alpha.canisters), `canisters not array for ${alpha.name}`);
    }
  });

  it('all ports are unique', () => {
    const ports = ALPHA_REGISTRY.map(a => a.port);
    assert.equal(new Set(ports).size, ports.length);
  });

  it('all AGI codes are unique', () => {
    const codes = ALPHA_REGISTRY.map(a => a.code);
    assert.equal(new Set(codes).size, codes.length);
  });

  it('all AGI IDs follow pattern XXX-AGI-001', () => {
    for (const alpha of ALPHA_REGISTRY) {
      assert.match(alpha.id, /^[A-Z]{3}-AGI-001$/, `Bad ID format: ${alpha.id}`);
    }
  });

  it('ports range 7619–7628', () => {
    const ports = ALPHA_REGISTRY.map(a => a.port).sort((a, b) => a - b);
    assert.equal(ports[0], 7619);
    assert.equal(ports[ports.length - 1], 7628);
  });

  it('ANIMUS is the master brain (ANI-AGI-001)', () => {
    const ani = ALPHA_REGISTRY.find(a => a.code === 'ANI');
    assert.ok(ani);
    assert.equal(ani.id, 'ANI-AGI-001');
    assert.equal(ani.family, 'SPIRITUS_AETERNA');
    assert.ok(ani.canisters.includes('swarm_brain'));
  });

  it('ANIMA has no dedicated canisters', () => {
    const anm = ALPHA_REGISTRY.find(a => a.code === 'ANM');
    assert.ok(anm);
    assert.equal(anm.canisters.length, 0);
  });

  it('total canisters across all Alphas >= 40', () => {
    const all = new Set();
    for (const a of ALPHA_REGISTRY) for (const c of a.canisters) all.add(c);
    assert.ok(all.size >= 40, `Only ${all.size} unique canisters`);
  });
});

// ─── §3 — Deployment Phases ─────────────────────────────────────────────────

describe('§3 — Deployment Phases', () => {
  it('has 8 deployment phases', () => {
    assert.equal(DEPLOY_PHASES.length, 8);
  });

  it('phases are numbered 1–8', () => {
    for (let i = 0; i < 8; i++) {
      assert.equal(DEPLOY_PHASES[i].phase, i + 1);
    }
  });

  it('phase 1 is CORE', () => {
    assert.equal(DEPLOY_PHASES[0].name, 'CORE');
  });

  it('phase 3 is DEFENSE', () => {
    assert.equal(DEPLOY_PHASES[2].name, 'DEFENSE');
  });
});

// ─── §4 — Pre-flight Checks ─────────────────────────────────────────────────

describe('§4 — Pre-flight Checks', () => {
  it('returns array of check results', () => {
    const results = preflightChecks();
    assert.ok(Array.isArray(results));
    assert.ok(results.length >= 5);
  });

  it('all checks have required fields', () => {
    const results = preflightChecks();
    for (const r of results) {
      assert.ok(r.check, 'Missing check name');
      assert.ok(typeof r.passed === 'boolean', 'passed must be boolean');
      assert.ok(r.message, 'Missing message');
    }
  });

  it('ALPHA_COUNT check passes', () => {
    const results = preflightChecks();
    const alphaCheck = results.find(r => r.check === 'ALPHA_COUNT');
    assert.ok(alphaCheck);
    assert.ok(alphaCheck.passed);
  });

  it('NO_DUPLICATES check passes', () => {
    const results = preflightChecks();
    const dupCheck = results.find(r => r.check === 'NO_DUPLICATES');
    assert.ok(dupCheck);
    assert.ok(dupCheck.passed);
  });

  it('preflightSummary reports all passed', () => {
    const results = preflightChecks();
    const summary = preflightSummary(results);
    assert.ok(summary.allPassed);
    assert.equal(summary.passed, summary.total);
  });
});

// ─── §5 — Manifest Generation ───────────────────────────────────────────────

describe('§5 — Manifest Generation', () => {
  it('generates full manifest', () => {
    const m = generateManifest();
    assert.equal(m.protocol, PROTOCOL_ID);
    assert.equal(m.network, 'ic');
    assert.ok(m.phases.length >= 5);
    assert.ok(m.totalCanisters >= 40);
    assert.equal(m.totalAlphas, 10);
  });

  it('manifest phases sorted correctly', () => {
    const m = generateManifest();
    for (let i = 1; i < m.phases.length; i++) {
      assert.ok(m.phases[i].phase >= m.phases[i - 1].phase);
    }
  });

  it('can filter by phase', () => {
    const m = generateManifest(1);
    assert.equal(m.phases.length, 1);
    assert.equal(m.phases[0].name, 'CORE');
  });

  it('canisters in phase sorted by priority', () => {
    const m = generateManifest();
    for (const phase of m.phases) {
      for (let i = 1; i < phase.canisters.length; i++) {
        assert.ok(phase.canisters[i].priority <= phase.canisters[i - 1].priority,
          `${phase.canisters[i].canister} should have lower priority than ${phase.canisters[i - 1].canister}`);
      }
    }
  });
});

// ─── §6 — Deployment Tracker ────────────────────────────────────────────────

describe('§6 — Deployment Tracker', () => {
  it('tracks deploys', () => {
    const t = new DeploymentTracker();
    t.start();
    t.recordDeploy('swarm_brain', 'abc-123-cai', 'ANI');
    t.recordDeploy('aegis_shield', 'def-456-cai', 'PRA');
    t.finish();
    const s = t.summary();
    assert.equal(s.deployed, 2);
    assert.equal(s.failed, 0);
    assert.equal(s.total, 2);
    assert.ok(s.success);
  });

  it('tracks failures', () => {
    const t = new DeploymentTracker();
    t.start();
    t.recordDeploy('swarm_brain', 'abc-123-cai', 'ANI');
    t.recordFailure('aegis_shield', 'PRA', 'cycles insufficient');
    t.finish();
    const s = t.summary();
    assert.equal(s.deployed, 1);
    assert.equal(s.failed, 1);
    assert.ok(!s.success);
  });

  it('generates canister IDs map', () => {
    const t = new DeploymentTracker();
    t.recordDeploy('swarm_brain', 'abc-123-cai', 'ANI');
    const ids = t.canisterIds();
    assert.ok(ids.swarm_brain);
    assert.equal(ids.swarm_brain.ic, 'abc-123-cai');
  });

  it('summary includes duration', () => {
    const t = new DeploymentTracker();
    t.start();
    t.recordDeploy('test', 'id', 'ANI');
    t.finish();
    const s = t.summary();
    assert.ok(s.durationMs !== null);
    assert.ok(s.durationMs >= 0);
  });
});

// ─── §7 — Health & Coherence ─────────────────────────────────────────────────

describe('§7 — Health & Coherence', () => {
  it('healthCheck returns status object', () => {
    const h = healthCheck('test-canister-id');
    assert.equal(h.canisterId, 'test-canister-id');
    assert.equal(h.status, 'running');
    assert.ok(h.checkedAt);
  });

  it('fleetCoherenceCheck with full deployment → R = 1', () => {
    const t = new DeploymentTracker();
    for (const alpha of ALPHA_REGISTRY) {
      for (const c of alpha.canisters) {
        t.recordDeploy(c, `${c}-cai`, alpha.code);
      }
    }
    const coherence = fleetCoherenceCheck(t);
    assert.equal(coherence.R, 1);
    assert.ok(coherence.coherent);
    assert.equal(coherence.fullyDeployed, 10);
  });

  it('fleetCoherenceCheck with no deployment → R = 0.1', () => {
    const t = new DeploymentTracker();
    const coherence = fleetCoherenceCheck(t);
    // Only ANIMA (no canisters) is READY
    assert.ok(coherence.R <= 0.2);
  });

  it('coherence threshold is φ⁻¹', () => {
    // Fleet is coherent when R ≥ φ⁻¹ ≈ 0.618
    const t = new DeploymentTracker();
    // Deploy enough alphas to exceed threshold (7/10 = 0.7 ≥ 0.618)
    const deployUpTo = 6; // Deploy first 6 alphas fully + ANIMA = 7
    for (let i = 0; i < deployUpTo; i++) {
      const alpha = ALPHA_REGISTRY[i];
      for (const c of alpha.canisters) {
        t.recordDeploy(c, `${c}-cai`, alpha.code);
      }
    }
    const coherence = fleetCoherenceCheck(t);
    assert.ok(coherence.R >= PHI_INV, `R=${coherence.R} should be >= ${PHI_INV}`);
    assert.ok(coherence.coherent);
  });
});

// ─── §8 — Full Deployment Simulation ─────────────────────────────────────────

describe('§8 — Full Deployment Simulation', () => {
  it('simulateDeploy returns complete report', () => {
    const report = simulateDeploy();
    assert.ok(report.manifest);
    assert.ok(report.summary);
    assert.ok(report.coherence);
    assert.ok(report.canisterIds);
  });

  it('simulation deploys all canisters successfully', () => {
    const report = simulateDeploy();
    assert.ok(report.summary.success);
    assert.equal(report.summary.failed, 0);
    assert.ok(report.summary.deployed >= 40);
  });

  it('simulation achieves full coherence (R = 1)', () => {
    const report = simulateDeploy();
    assert.equal(report.coherence.R, 1);
    assert.ok(report.coherence.coherent);
    assert.equal(report.coherence.fullyDeployed, 10);
  });

  it('simulation generates canister IDs for all canisters', () => {
    const report = simulateDeploy();
    const ids = report.canisterIds;
    assert.ok(ids.swarm_brain);
    assert.ok(ids.aegis_shield);
    assert.ok(ids.phantom_transfer);
    assert.ok(ids.nova_protocol);
  });

  it('manifest has correct phi', () => {
    const report = simulateDeploy();
    assert.ok(Math.abs(report.manifest.phi - PHI) < 1e-10);
  });
});
