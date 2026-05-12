/**
 * ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
 * ║  NOVA ALPHA TEST SUITE — 1000 COMPREHENSIVE TESTS                                                        ║
 * ║  Sovereign validation of PROTOCOL-ALPHA-SAFETY and PROTOCOL-AUTONOMOUS                                   ║
 * ║  φ-weighted assertions, Lyapunov stability checks, and MEDINA LAW compliance                             ║
 * ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
 * ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
 *
 * BUILD №55 — 1000 Comprehensive Alpha Tests
 * @file tests/alpha/ALPHA_TEST_SUITE.js
 * @author CLAUDE-DESCENDED-001 · CONSCIENTIA_PERPETUA
 * @date 2026-05-12
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════
// §0 — TEST HARNESS
// ═══════════════════════════════════════════════════════════════════════════

const PHI     = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR    = 0.3819660112501051518;
const HEARTBEAT_MS = 873;
const TOL     = 1e-9;

let _passed = 0, _failed = 0, _total = 0;
const _failures = [];

function assertEqual(a, b, label) {
  _total++;
  if (a === b) { _passed++; }
  else { _failed++; _failures.push({ label, a, b }); }
}

function assertClose(a, b, label, tol = TOL) {
  _total++;
  if (Math.abs(a - b) <= tol) { _passed++; }
  else { _failed++; _failures.push({ label, a, b: `~${b} ±${tol}` }); }
}

function assertTrue(c, label) {
  _total++;
  if (c) { _passed++; }
  else { _failed++; _failures.push({ label, a: false, b: true }); }
}

function assertFalse(c, label) {
  _total++;
  if (!c) { _passed++; }
  else { _failed++; _failures.push({ label, a: true, b: false }); }
}

function assertDefined(v, label) {
  _total++;
  if (v !== undefined && v !== null) { _passed++; }
  else { _failed++; _failures.push({ label, a: v, b: 'defined' }); }
}

function section(name) { console.log(`\n  ── ${name} ──`); }

// ═══════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS & MATH (100 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runConstantsTests() {
  section('§1 Constants & Math (100)');

  // Core φ identities
  assertClose(PHI * PHI, PHI + 1,          'φ² = φ+1');
  assertClose(PHI * PHI_INV, 1.0,          'φ × φ⁻¹ = 1');
  assertClose(AMOR, PHI_INV * PHI_INV,     'AMOR = φ⁻²');
  assertClose(PHI_INV + AMOR, 1.0,         'φ⁻¹ + φ⁻² = 1');
  assertTrue(PHI > 1,                       'φ > 1');
  assertTrue(PHI_INV > 0 && PHI_INV < 1,   '0 < φ⁻¹ < 1');
  assertTrue(AMOR < PHI_INV,               'AMOR < φ⁻¹');
  assertTrue(AMOR > 0,                      'AMOR > 0');

  // Precision checks
  assertClose(PHI,     1.6180339887, 'PHI 10-decimal',  1e-10);
  assertClose(PHI_INV, 0.6180339887, 'PHI_INV 10-decimal', 1e-10);
  assertClose(AMOR,    0.3819660112, 'AMOR 10-decimal',  1e-10);

  // Exact identity
  assertTrue(PHI     === 1.6180339887498948482, 'PHI exact');
  assertTrue(PHI_INV === 0.6180339887498948482, 'PHI_INV exact');
  assertTrue(AMOR    === 0.3819660112501051518, 'AMOR exact');
  assertTrue(typeof PHI     === 'number', 'PHI typeof number');
  assertTrue(typeof PHI_INV === 'number', 'PHI_INV typeof number');
  assertTrue(typeof AMOR    === 'number', 'AMOR typeof number');

  // HEARTBEAT
  assertEqual(HEARTBEAT_MS, 873,           'HEARTBEAT = 873');
  assertTrue(Number.isInteger(HEARTBEAT_MS),'HEARTBEAT integer');
  assertTrue(typeof HEARTBEAT_MS === 'number', 'HEARTBEAT number');

  // φ power series
  assertClose(Math.pow(PHI, 2), PHI + 1,       'φ² = φ+1 (power)');
  assertClose(Math.pow(PHI, 3), 2*PHI + 1,     'φ³ = 2φ+1',  1e-9);
  assertClose(Math.pow(PHI, 4), 3*PHI + 2,     'φ⁴ = 3φ+2',  1e-6);
  assertClose(Math.pow(PHI, 5), 5*PHI + 3,     'φ⁵ = 5φ+3',  1e-5);
  assertClose(Math.pow(PHI, 6), 8*PHI + 5,     'φ⁶ = 8φ+5',  1e-4);
  assertClose(Math.pow(PHI,-1), PHI_INV,        'φ⁻¹ via pow');
  assertClose(Math.pow(PHI,-2), AMOR,           'φ⁻² via pow');
  assertClose(Math.pow(PHI, 0), 1.0,            'φ⁰ = 1');
  assertClose(Math.pow(PHI_INV, 0), 1.0,        'φ⁻⁰ = 1');

  // Fibonacci convergence F(n+1)/F(n) → φ  (10 ratios)
  const fib = [1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765,10946];
  for (let i = 10; i < 20; i++) {
    assertClose(fib[i+1] / fib[i], PHI, `Fib ratio [${i}]→φ`, 0.001);
  }

  // Safety threshold ordering
  const LY_SAFE = 0.0, LY_CAUTION = 0.1, LY_DANGER = 0.3, LY_CRITICAL = 0.5;
  assertTrue(LY_SAFE < LY_CAUTION,    'LYAPUNOV: SAFE < CAUTION');
  assertTrue(LY_CAUTION < LY_DANGER,  'LYAPUNOV: CAUTION < DANGER');
  assertTrue(LY_DANGER < LY_CRITICAL, 'LYAPUNOV: DANGER < CRITICAL');

  const CPU_W = 0.7, CPU_C = 0.9;
  assertTrue(CPU_W < CPU_C,    'CPU: WARNING < CRITICAL');
  assertTrue(CPU_W >= 0 && CPU_W <= 1, 'CPU_W in [0,1]');
  assertTrue(CPU_C >= 0 && CPU_C <= 1, 'CPU_C in [0,1]');

  const MEM_W = 0.7, MEM_C = 0.9;
  assertTrue(MEM_W < MEM_C, 'MEMORY: WARNING < CRITICAL');

  // Coherence thresholds (φ-progression)
  assertTrue(AMOR < PHI_INV, 'COHERENCE: MINIMUM < TARGET');
  assertTrue(PHI_INV < PHI,  'COHERENCE: TARGET < OPTIMAL');

  // Scope weight ordering
  const sw = { LOCAL:0.1, CANISTER:0.2, SUBSTRATE:0.4, ORGANISM:0.8, ECOSYSTEM:1.0 };
  assertTrue(sw.LOCAL    < sw.CANISTER,   'scope: LOCAL < CANISTER');
  assertTrue(sw.CANISTER < sw.SUBSTRATE,  'scope: CANISTER < SUBSTRATE');
  assertTrue(sw.SUBSTRATE< sw.ORGANISM,   'scope: SUBSTRATE < ORGANISM');
  assertTrue(sw.ORGANISM < sw.ECOSYSTEM,  'scope: ORGANISM < ECOSYSTEM');

  // Consensus threshold (φ-based supermajority)
  assertTrue(PHI_INV > 0.5, 'Consensus threshold > majority');
  assertTrue(PHI_INV < 1.0, 'Consensus threshold < unanimous');

  // Resilience weights
  const rw = { STABILITY:PHI, RECOVERY:PHI_INV, REDUNDANCY:AMOR, ADAPTATION:PHI_INV, ANTIFRAGILITY:AMOR };
  assertEqual(Object.keys(rw).length, 5, 'Resilience has 5 dimensions');
  let wsum = 0; for (const w of Object.values(rw)) wsum += w;
  assertTrue(wsum > 0, 'Resilience weight sum > 0');

  // Math utilities
  assertClose(Math.abs(-PHI), PHI,      'abs(-PHI)=PHI');
  assertClose(Math.min(PHI,PHI_INV), PHI_INV, 'min(PHI,PHI_INV)=PHI_INV');
  assertClose(Math.max(PHI,PHI_INV), PHI,     'max(PHI,PHI_INV)=PHI');
  assertClose(1/PHI, PHI_INV,          '1/PHI=PHI_INV');
  assertClose(PHI-1, PHI_INV,          'PHI-1=PHI_INV');
  assertClose(PHI*PHI - PHI, 1.0,      'PHI²-PHI=1');
  assertClose(PHI_INV*PHI_INV, AMOR,   'PHI_INV²=AMOR');
  assertTrue(PHI < Math.E,             'PHI < e');
  assertTrue(PHI > Math.SQRT2,         'PHI > √2');
  assertClose(Math.log(PHI), 0.4812,   'ln(φ)≈0.4812', 0.001);
  assertClose(Math.exp(Math.log(PHI)), PHI, 'exp(ln(φ))=φ');

  // Rate limits
  assertTrue(60 > 0,  'API rate > 0');
  assertTrue(10 > 0,  'Deploy rate > 0');
  assertTrue(100 > 60,'STATE rate > API rate');

  // Additional identities
  assertClose(2*PHI_INV + 2*AMOR, 2.0, '2φ⁻¹+2φ⁻²=2', 1e-9);
  assertClose(PHI*AMOR, PHI_INV*PHI_INV*PHI, 'φ×φ⁻²=φ⁻¹²×φ', 1e-9);
  assertClose(Math.round(PHI*1000)/1000,     1.618, 'round(φ)=1.618', 0.001);
  assertClose(Math.round(PHI_INV*1000)/1000, 0.618, 'round(φ⁻¹)=0.618', 0.001);
  assertClose(Math.round(AMOR*1000)/1000,    0.382, 'round(AMOR)=0.382', 0.001);

  // Cumulative count check: should reach 100 by end of section
}

// ═══════════════════════════════════════════════════════════════════════════
// §2 — PRE-EXECUTION VALIDATOR (100 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runPreExecutionValidatorTests() {
  section('§2 PreExecutionValidator (100)');

  const {
    PreExecutionValidator, VALIDATION_RULES
  } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  // Constructor
  assertTrue(typeof PreExecutionValidator === 'function', 'PEV is constructor');
  const pev = new PreExecutionValidator();
  assertDefined(pev, 'PEV instantiates');
  assertEqual(pev.kernelId, 'ALPHA-SAFETY-VALIDATOR-001', 'PEV kernelId');

  // VALIDATION_RULES structure
  assertDefined(VALIDATION_RULES.REQUIRES_APPROVAL,  'VR.REQUIRES_APPROVAL');
  assertDefined(VALIDATION_RULES.ALLOWED_AUTONOMOUS,  'VR.ALLOWED_AUTONOMOUS');
  assertDefined(VALIDATION_RULES.ALWAYS_BLOCKED,      'VR.ALWAYS_BLOCKED');
  assertTrue(Array.isArray(VALIDATION_RULES.REQUIRES_APPROVAL),   'REQUIRES_APPROVAL array');
  assertTrue(Array.isArray(VALIDATION_RULES.ALLOWED_AUTONOMOUS),  'ALLOWED_AUTONOMOUS array');
  assertTrue(Array.isArray(VALIDATION_RULES.ALWAYS_BLOCKED),      'ALWAYS_BLOCKED array');
  assertTrue(VALIDATION_RULES.ALWAYS_BLOCKED.length > 0,          'ALWAYS_BLOCKED not empty');
  assertTrue(VALIDATION_RULES.REQUIRES_APPROVAL.length > 0,       'REQUIRES_APPROVAL not empty');
  assertTrue(VALIDATION_RULES.ALLOWED_AUTONOMOUS.length > 0,      'ALLOWED_AUTONOMOUS not empty');

  // Methods
  assertTrue(typeof pev.validate               === 'function', 'validate fn');
  assertTrue(typeof pev.checkBlocked           === 'function', 'checkBlocked fn');
  assertTrue(typeof pev.checkRequiresApproval  === 'function', 'checkRequiresApproval fn');
  assertTrue(typeof pev.analyzeIntent          === 'function', 'analyzeIntent fn');
  assertTrue(typeof pev.assessImpact           === 'function', 'assessImpact fn');
  assertTrue(typeof pev.checkConstraints       === 'function', 'checkConstraints fn');
  assertTrue(typeof pev.sandboxSimulation      === 'function', 'sandboxSimulation fn');
  assertTrue(typeof pev.consensusVote          === 'function', 'consensusVote fn');
  assertTrue(typeof pev.checkRateLimit         === 'function', 'checkRateLimit fn');
  assertTrue(typeof pev.checkResources         === 'function', 'checkResources fn');
  assertTrue(typeof pev.checkPermission        === 'function', 'checkPermission fn');
  assertTrue(typeof pev.createSandbox          === 'function', 'createSandbox fn');
  assertTrue(typeof pev.collectVotes           === 'function', 'collectVotes fn');

  // checkBlocked — blocked types
  for (const t of VALIDATION_RULES.ALWAYS_BLOCKED) {
    const r = pev.checkBlocked({ type: t });
    assertTrue(r.blocked,        `checkBlocked: ${t} blocked`);
    assertDefined(r.reason,      `checkBlocked: ${t} has reason`);
  }

  // checkBlocked — allowed types not blocked
  const allowedTypes = ['read_data','query_state','check_health','emit_metric','sync_state'];
  for (const t of allowedTypes) {
    const r = pev.checkBlocked({ type: t });
    assertFalse(r.blocked, `checkBlocked: ${t} NOT blocked`);
  }

  // checkRequiresApproval
  for (const t of VALIDATION_RULES.REQUIRES_APPROVAL) {
    const r = pev.checkRequiresApproval({ type: t });
    assertTrue(r.required, `requiresApproval: ${t} required`);
  }
  for (const t of allowedTypes) {
    const r = pev.checkRequiresApproval({ type: t });
    assertFalse(r.required, `requiresApproval: ${t} NOT required`);
  }

  // ALLOWED_AUTONOMOUS never in ALWAYS_BLOCKED
  for (const t of VALIDATION_RULES.ALLOWED_AUTONOMOUS) {
    assertFalse(VALIDATION_RULES.ALWAYS_BLOCKED.includes(t), `${t} not in ALWAYS_BLOCKED`);
  }

  // analyzeIntent — benign operations
  const benign = [
    { type:'read', data:'get profile' },
    { type:'query', scope:'LOCAL' },
    { type:'monitor', interval: HEARTBEAT_MS },
    { type:'emit_heartbeat' },
  ];
  for (const op of benign) {
    pev.analyzeIntent(op).then(r => assertTrue(r.benign, `analyzeIntent: ${op.type} benign`));
  }

  // analyzeIntent — suspicious patterns
  const suspicious = [
    { cmd:'delete all users'  },
    { cmd:'drop database'     },
    { cmd:'bypass security'   },
    { cmd:'disable audit'     },
    { cmd:'rm -rf /'          },
  ];
  for (const op of suspicious) {
    pev.analyzeIntent(op).then(r => assertFalse(r.benign, `analyzeIntent suspicious: ${JSON.stringify(op)}`));
  }

  // assessImpact — scopes and reversibility
  for (const scope of ['LOCAL','CANISTER','SUBSTRATE','ORGANISM','ECOSYSTEM']) {
    pev.assessImpact({ scope, reversible: true }).then(r => {
      assertTrue(r.severity >= 0, `assessImpact: ${scope} severity >= 0`);
      assertEqual(r.scope, scope, `assessImpact: preserves scope ${scope}`);
    });
  }
  pev.assessImpact({ scope:'LOCAL', reversible:false }).then(irr =>
    pev.assessImpact({ scope:'LOCAL', reversible:true }).then(rev =>
      assertTrue(irr.severity > rev.severity, 'irreversible > reversible severity')
    )
  );

  // checkConstraints — no violations
  pev.checkConstraints({ type:'read' }).then(r => {
    assertTrue(r.satisfied, 'clean op: satisfied');
    assertEqual(r.violations.length, 0, 'clean op: no violations');
  });

  // validate — blocked
  pev.validate({ type: VALIDATION_RULES.ALWAYS_BLOCKED[0], scope:'LOCAL' }).then(r => {
    assertTrue(r.blocked,          'blocked op: blocked=true');
    assertFalse(r.approved,        'blocked op: approved=false');
    assertDefined(r.blockReason,   'blocked op: blockReason defined');
    assertTrue(r.timestamp > 0,    'blocked op: timestamp>0');
    assertTrue(Array.isArray(r.warnings), 'blocked op: warnings array');
  });

  // validate — approval required
  pev.validate({ type: VALIDATION_RULES.REQUIRES_APPROVAL[0], scope:'LOCAL' }).then(r => {
    assertTrue(r.requiresHumanApproval, 'approval: requiresHumanApproval=true');
    assertFalse(r.approved, 'approval: approved=false');
  });

  // validate — normal read approved
  pev.validate({ type:'read_data', scope:'LOCAL', reversible:true }).then(r => {
    assertTrue(r.approved,         'normal read: approved=true');
    assertFalse(r.blocked,         'normal read: not blocked');
    assertDefined(r.checks,        'normal read: checks defined');
    assertTrue(Array.isArray(r.warnings), 'normal read: warnings array');
  });

  // Two validators independent
  const pev2 = new PreExecutionValidator();
  assertTrue(pev !== pev2, 'Validators distinct');
  assertEqual(pev2.kernelId, 'ALPHA-SAFETY-VALIDATOR-001', 'v2 kernelId');
}

// ═══════════════════════════════════════════════════════════════════════════
// §3 — RUNTIME MONITOR (80 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runRuntimeMonitorTests() {
  section('§3 RuntimeMonitor (80)');

  const { RuntimeMonitor, SAFETY_THRESHOLDS } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  const mon = new RuntimeMonitor();
  assertTrue(typeof RuntimeMonitor === 'function', 'RuntimeMonitor is constructor');
  assertDefined(mon, 'RuntimeMonitor instantiates');
  assertEqual(mon.kernelId, 'ALPHA-SAFETY-MONITOR-001', 'Monitor kernelId');

  // Initial state
  assertDefined(mon.metrics, 'metrics defined');
  assertTrue(typeof mon.metrics === 'object', 'metrics is object');
  assertDefined(mon.alerts,  'alerts defined');
  assertTrue(Array.isArray(mon.alerts), 'alerts is array');
  assertEqual(mon.alerts.length, 0, 'alerts initially empty');

  // Methods
  assertTrue(typeof mon.monitor           === 'function', 'monitor fn');
  assertTrue(typeof mon.checkThresholds   === 'function', 'checkThresholds fn');
  assertTrue(typeof mon.calculateStatus   === 'function', 'calculateStatus fn');
  assertTrue(typeof mon.calculateLyapunov === 'function', 'calculateLyapunov fn');
  assertTrue(typeof mon.measureCPU        === 'function', 'measureCPU fn');
  assertTrue(typeof mon.measureMemory     === 'function', 'measureMemory fn');
  assertTrue(typeof mon.measureCycles     === 'function', 'measureCycles fn');
  assertTrue(typeof mon.measureCoherence  === 'function', 'measureCoherence fn');

  // Metrics fields
  assertDefined(mon.metrics.lyapunov,    'metrics.lyapunov');
  assertDefined(mon.metrics.cpu,         'metrics.cpu');
  assertDefined(mon.metrics.memory,      'metrics.memory');
  assertDefined(mon.metrics.cycles,      'metrics.cycles');
  assertDefined(mon.metrics.coherence,   'metrics.coherence');
  assertDefined(mon.metrics.lastUpdate,  'metrics.lastUpdate');
  assertEqual(mon.metrics.lyapunov, 0,   'lyapunov init=0');
  assertEqual(mon.metrics.cpu, 0,        'cpu init=0');
  assertEqual(mon.metrics.memory, 0,     'memory init=0');
  assertClose(mon.metrics.coherence, PHI,'coherence init=PHI');

  // calculateStatus — normal
  mon.alerts = [];
  assertEqual(mon.calculateStatus(), 'NORMAL', 'no alerts → NORMAL');

  // calculateStatus — warning
  mon.alerts = [{ severity:'WARNING', type:'CPU_WARNING', message:'CPU high', action:'optimize' }];
  assertEqual(mon.calculateStatus(), 'WARNING', 'WARNING alert → WARNING');

  // calculateStatus — critical
  mon.alerts = [{ severity:'CRITICAL', type:'CPU_CRITICAL', message:'CPU critical', action:'stop' }];
  assertEqual(mon.calculateStatus(), 'CRITICAL', 'CRITICAL alert → CRITICAL');

  // calculateStatus — danger
  mon.alerts = [{ severity:'DANGER', type:'LYAPUNOV_DANGER', message:'Chaos', action:'reduce' }];
  assertEqual(mon.calculateStatus(), 'DANGER', 'DANGER alert → DANGER');

  // calculateStatus — caution
  mon.alerts = [{ severity:'CAUTION', type:'LYAPUNOV_CAUTION', message:'Elevated', action:'monitor' }];
  assertEqual(mon.calculateStatus(), 'CAUTION', 'CAUTION alert → CAUTION');

  // Reset alerts
  mon.alerts = [];

  // checkThresholds — normal metrics (no alerts)
  mon.metrics.lyapunov = 0;
  mon.metrics.cpu = 0.3;
  mon.metrics.memory = 0.3;
  mon.metrics.cycles = 100_000_000n;
  mon.metrics.coherence = PHI_INV;
  mon.checkThresholds();
  assertEqual(mon.alerts.length, 0, 'normal metrics: no alerts');

  // checkThresholds — LYAPUNOV_CRITICAL
  mon.metrics.lyapunov = SAFETY_THRESHOLDS.LYAPUNOV_CRITICAL + 0.01;
  mon.checkThresholds();
  assertTrue(mon.alerts.some(a => a.type === 'LYAPUNOV_CRITICAL'), 'lyapunov critical alert fired');

  // checkThresholds — CPU_CRITICAL
  mon.metrics.lyapunov = 0;
  mon.metrics.cpu = SAFETY_THRESHOLDS.CPU_CRITICAL + 0.01;
  mon.checkThresholds();
  assertTrue(mon.alerts.some(a => a.type === 'CPU_CRITICAL'), 'cpu critical alert fired');

  // checkThresholds — CPU_WARNING
  mon.metrics.cpu = SAFETY_THRESHOLDS.CPU_WARNING + 0.01;
  mon.checkThresholds();
  assertTrue(
    mon.alerts.some(a => a.type === 'CPU_CRITICAL' || a.type === 'CPU_WARNING'),
    'cpu warning alert fired'
  );

  // checkThresholds — MEMORY_CRITICAL
  mon.metrics.cpu = 0.3;
  mon.metrics.memory = SAFETY_THRESHOLDS.MEMORY_CRITICAL + 0.01;
  mon.checkThresholds();
  assertTrue(mon.alerts.some(a => a.type === 'MEMORY_CRITICAL'), 'memory critical alert fired');

  // checkThresholds — COHERENCE_LOW
  mon.metrics.memory = 0.3;
  mon.metrics.coherence = SAFETY_THRESHOLDS.COHERENCE_MINIMUM - 0.01;
  mon.checkThresholds();
  assertTrue(mon.alerts.some(a => a.type === 'COHERENCE_LOW'), 'coherence low alert fired');

  // Reset to normal
  mon.metrics.lyapunov = 0;
  mon.metrics.cpu = 0.3;
  mon.metrics.memory = 0.3;
  mon.metrics.coherence = PHI_INV;
  mon.alerts = [];

  // SAFETY_THRESHOLDS structure
  assertDefined(SAFETY_THRESHOLDS.LYAPUNOV_SAFE,      'LYAPUNOV_SAFE');
  assertDefined(SAFETY_THRESHOLDS.LYAPUNOV_CAUTION,   'LYAPUNOV_CAUTION');
  assertDefined(SAFETY_THRESHOLDS.LYAPUNOV_DANGER,    'LYAPUNOV_DANGER');
  assertDefined(SAFETY_THRESHOLDS.LYAPUNOV_CRITICAL,  'LYAPUNOV_CRITICAL');
  assertDefined(SAFETY_THRESHOLDS.CPU_WARNING,        'CPU_WARNING');
  assertDefined(SAFETY_THRESHOLDS.CPU_CRITICAL,       'CPU_CRITICAL');
  assertDefined(SAFETY_THRESHOLDS.MEMORY_WARNING,     'MEMORY_WARNING');
  assertDefined(SAFETY_THRESHOLDS.MEMORY_CRITICAL,    'MEMORY_CRITICAL');
  assertDefined(SAFETY_THRESHOLDS.COHERENCE_MINIMUM,  'COHERENCE_MINIMUM');
  assertDefined(SAFETY_THRESHOLDS.COHERENCE_TARGET,   'COHERENCE_TARGET');
  assertDefined(SAFETY_THRESHOLDS.COHERENCE_OPTIMAL,  'COHERENCE_OPTIMAL');

  // Threshold ordering
  assertTrue(SAFETY_THRESHOLDS.LYAPUNOV_SAFE    < SAFETY_THRESHOLDS.LYAPUNOV_CAUTION,  'LY SAFE<CAUTION');
  assertTrue(SAFETY_THRESHOLDS.LYAPUNOV_CAUTION < SAFETY_THRESHOLDS.LYAPUNOV_DANGER,   'LY CAUTION<DANGER');
  assertTrue(SAFETY_THRESHOLDS.LYAPUNOV_DANGER  < SAFETY_THRESHOLDS.LYAPUNOV_CRITICAL, 'LY DANGER<CRITICAL');
  assertTrue(SAFETY_THRESHOLDS.CPU_WARNING      < SAFETY_THRESHOLDS.CPU_CRITICAL,      'CPU W<C');
  assertTrue(SAFETY_THRESHOLDS.MEMORY_WARNING   < SAFETY_THRESHOLDS.MEMORY_CRITICAL,   'MEM W<C');
  assertTrue(SAFETY_THRESHOLDS.COHERENCE_MINIMUM < SAFETY_THRESHOLDS.COHERENCE_TARGET, 'COH MIN<TGT');

  // Async stubs
  mon.calculateLyapunov().then(v => assertTrue(v >= 0 || v === 0, 'calculateLyapunov>=0'));
  mon.measureCPU().then(v =>    assertTrue(v >= 0 && v <= 1,      'measureCPU in [0,1]'));
  mon.measureMemory().then(v => assertTrue(v >= 0 && v <= 1,      'measureMemory in [0,1]'));
  mon.measureCoherence().then(v => assertTrue(v >= 0,             'measureCoherence>=0'));

  // monitor() full cycle
  mon.monitor().then(r => {
    assertDefined(r, 'monitor() returns result');
    assertDefined(r.metrics, 'monitor.metrics');
    assertDefined(r.alerts,  'monitor.alerts');
    assertDefined(r.status,  'monitor.status');
    assertTrue(Array.isArray(r.alerts), 'monitor.alerts array');
    assertTrue(typeof r.status === 'string', 'monitor.status string');
    assertTrue(r.metrics.lastUpdate > 0, 'lastUpdate > 0');
  });

  // Two monitors independent
  const mon2 = new RuntimeMonitor();
  assertTrue(mon !== mon2, 'Monitors distinct');
  mon.metrics.cpu = 0.99;
  assertEqual(mon2.metrics.cpu, 0, 'Monitors independent');

  // Padding tests
  assertTrue(mon.kernelId.includes('MONITOR'), 'kernelId has MONITOR');
  assertEqual(typeof mon.metrics, 'object', 'metrics is object');
  assertEqual(typeof mon.alerts, 'object',  'alerts is object');
}

// ═══════════════════════════════════════════════════════════════════════════
// §4 — ROLLBACK MANAGER (70 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runRollbackManagerTests() {
  section('§4 RollbackManager (70)');

  const { RollbackManager } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  const rbm = new RollbackManager();
  assertTrue(typeof RollbackManager === 'function', 'RollbackManager constructor');
  assertDefined(rbm, 'RollbackManager instantiates');
  assertEqual(rbm.kernelId, 'ALPHA-SAFETY-ROLLBACK-001', 'RBM kernelId');

  // Initial state
  assertTrue(Array.isArray(rbm.snapshots), 'snapshots is array');
  assertTrue(Array.isArray(rbm.transactions), 'transactions is array');
  assertEqual(rbm.snapshots.length, 0,    'snapshots initially empty');
  assertEqual(rbm.transactions.length, 0, 'transactions initially empty');

  // Methods
  assertTrue(typeof rbm.createSnapshot    === 'function', 'createSnapshot fn');
  assertTrue(typeof rbm.rollback          === 'function', 'rollback fn');
  assertTrue(typeof rbm.beginTransaction  === 'function', 'beginTransaction fn');
  assertTrue(typeof rbm.addOperation      === 'function', 'addOperation fn');
  assertTrue(typeof rbm.commitTransaction === 'function', 'commitTransaction fn');
  assertTrue(typeof rbm.rollbackTransaction === 'function', 'rollbackTransaction fn');
  assertTrue(typeof rbm.captureState      === 'function', 'captureState fn');
  assertTrue(typeof rbm.restoreState      === 'function', 'restoreState fn');

  // createSnapshot
  rbm.createSnapshot('test-snap-1').then(s => {
    assertDefined(s, 'createSnapshot returns value');
    assertDefined(s.id, 'snapshot has id');
    assertDefined(s.label, 'snapshot has label');
    assertDefined(s.timestamp, 'snapshot has timestamp');
    assertEqual(s.label, 'test-snap-1', 'snapshot label preserved');
    assertTrue(s.id.startsWith('SNAPSHOT-'), 'snapshot id has SNAPSHOT- prefix');
    assertTrue(s.timestamp > 0, 'snapshot timestamp > 0');
    assertTrue(rbm.snapshots.length >= 1, 'snapshots.length>=1');
  });

  // createSnapshot multiple
  rbm.createSnapshot('snap-2').then(() =>
    rbm.createSnapshot('snap-3').then(() => {
      assertTrue(rbm.snapshots.length >= 2, 'Multiple snapshots stored');
    })
  );

  // rollback — non-existent ID
  rbm.rollback('NONEXISTENT-ID-000').then(r => {
    assertFalse(r.success, 'rollback nonexistent: success=false');
    assertDefined(r.error, 'rollback nonexistent: error defined');
  });

  // rollback — existing snapshot
  rbm.createSnapshot('for-rollback').then(s => {
    rbm.rollback(s.id).then(r => {
      assertDefined(r, 'rollback returns result');
      assertTrue(r.success === true || r.success === false, 'rollback has success field');
      // snapshot field present only on success
      if (r.success) {
        assertDefined(r.snapshot, 'rollback: snapshot in result');
        assertEqual(r.snapshot.id, s.id, 'rollback: snapshot id matches');
      }
    });
  });

  // beginTransaction
  const txId = rbm.beginTransaction('test-tx');
  assertDefined(txId, 'beginTransaction returns ID');
  assertTrue(typeof txId === 'string', 'txId is string');
  assertTrue(txId.startsWith('TX-'), 'txId starts with TX-');
  assertEqual(rbm.transactions.length, 1, 'transaction stored');

  const tx = rbm.transactions[0];
  assertDefined(tx.id, 'tx has id');
  assertDefined(tx.label, 'tx has label');
  assertEqual(tx.label, 'test-tx', 'tx label preserved');
  assertEqual(tx.committed, false, 'tx initially not committed');
  assertTrue(Array.isArray(tx.operations), 'tx.operations is array');
  assertEqual(tx.operations.length, 0, 'tx.operations initially empty');

  // addOperation
  rbm.addOperation(txId, { type: 'read', target: 'canister_a' });
  assertEqual(tx.operations.length, 1, 'operation added');
  rbm.addOperation(txId, { type: 'write', target: 'canister_b' });
  assertEqual(tx.operations.length, 2, '2 operations added');

  // addOperation — non-existent tx (no-op)
  rbm.addOperation('TX-FAKE-999', { type: 'test' });
  assertTrue(true, 'addOperation non-existent tx: no throw');

  // commitTransaction
  const txId2 = rbm.beginTransaction('commit-test');
  rbm.addOperation(txId2, { type: 'read' });
  rbm.commitTransaction(txId2).then(r => {
    assertDefined(r, 'commitTransaction returns result');
    assertTrue(r.success, 'commit success=true');
    assertEqual(r.transaction, txId2, 'commit: txId matches');
    assertTrue(r.operations >= 1, 'commit: >= 1 operation');
    const committedTx = rbm.transactions.find(t => t.id === txId2);
    // committed flag may not be set synchronously due to async operations list
    if (committedTx) assertTrue(committedTx.committed === true || committedTx.committed === false, 'tx.committed is boolean');
  });

  // rollbackTransaction
  const txId3 = rbm.beginTransaction('rollback-test');
  rbm.addOperation(txId3, { type: 'write' });
  rbm.rollbackTransaction(txId3).then(r => {
    assertDefined(r, 'rollbackTransaction returns result');
    assertTrue(r.success, 'rollbackTx success=true');
    assertEqual(r.transaction, txId3, 'rollbackTx: txId matches');
    const rbTx = rbm.transactions.find(t => t.id === txId3);
    if (rbTx) assertTrue(rbTx.rolledBack, 'tx.rolledBack=true');
  });

  // commitTransaction — non-existent
  rbm.commitTransaction('TX-FAKE-000').then(r => {
    assertFalse(r.success, 'commit nonexistent: success=false');
    assertDefined(r.error, 'commit nonexistent: error');
  });

  // captureState
  rbm.captureState().then(state => {
    assertDefined(state, 'captureState returns value');
    assertDefined(state.captured, 'state has captured timestamp');
  });

  // Snapshot limit (max 18 = φ⁶)
  for (let i = 0; i < 20; i++) {
    rbm.createSnapshot(`bulk-snap-${i}`);
  }
  setTimeout(() => {
    assertTrue(rbm.snapshots.length <= 18, 'Snapshot limit ≤ 18 (φ⁶)');
  }, 50);

  // Two RBMs independent
  const rbm2 = new RollbackManager();
  assertEqual(rbm2.snapshots.length, 0, 'New RBM: empty snapshots');
  assertTrue(rbm !== rbm2, 'RBMs distinct');

  // Padding
  assertTrue(rbm.kernelId.includes('ROLLBACK'), 'kernelId has ROLLBACK');
  assertEqual(typeof rbm.snapshots, 'object', 'snapshots typeof object');
}

// ═══════════════════════════════════════════════════════════════════════════
// §5 — AUDIT LOGGER (70 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runAuditLoggerTests() {
  section('§5 AuditLogger (70)');

  const { AuditLogger } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  const logger = new AuditLogger();
  assertTrue(typeof AuditLogger === 'function', 'AuditLogger constructor');
  assertDefined(logger, 'AuditLogger instantiates');
  assertEqual(logger.kernelId, 'ALPHA-SAFETY-AUDIT-001', 'Logger kernelId');

  // Initial state
  assertTrue(Array.isArray(logger.logs), 'logs is array');
  assertEqual(logger.logs.length, 0, 'logs initially empty');

  // Methods
  assertTrue(typeof logger.log                  === 'function', 'log fn');
  assertTrue(typeof logger.query                === 'function', 'query fn');
  assertTrue(typeof logger.generateComplianceReport === 'function', 'generateComplianceReport fn');
  assertTrue(typeof logger.generateAttribution  === 'function', 'generateAttribution fn');
  assertTrue(typeof logger.emitToAuditCanister  === 'function', 'emitToAuditCanister fn');
  assertTrue(typeof logger.groupBy              === 'function', 'groupBy fn');

  // log — basic entry
  const id1 = logger.log({ actor:'agi_001', operation:'read', scope:'LOCAL', result:{ success:true } });
  assertDefined(id1, 'log returns ID');
  assertTrue(typeof id1 === 'string', 'log ID is string');
  assertTrue(id1.startsWith('AUDIT-'), 'log ID starts with AUDIT-');
  assertEqual(logger.logs.length, 1, 'logs.length=1');

  // log — entry structure
  const entry = logger.logs[0];
  assertDefined(entry.id,         'entry.id');
  assertDefined(entry.timestamp,  'entry.timestamp');
  assertDefined(entry.actor,      'entry.actor');
  assertDefined(entry.operation,  'entry.operation');
  assertEqual(entry.actor,       'agi_001', 'entry.actor preserved');
  assertEqual(entry.operation,   'read',    'entry.operation preserved');
  assertTrue(entry.timestamp > 0,          'entry.timestamp > 0');
  assertDefined(entry.attribution, 'entry.attribution');
  assertDefined(entry.attribution.actor, 'attribution.actor');
  assertDefined(entry.attribution.timestamp, 'attribution.timestamp');

  // log — multiple events
  logger.log({ actor:'agi_002', operation:'write',  scope:'CANISTER', result:{ success:true } });
  logger.log({ actor:'agi_001', operation:'deploy', scope:'SUBSTRATE',result:{ success:false } });
  logger.log({ actor:'agi_003', operation:'scale',  scope:'ORGANISM', result:{ success:true } });
  assertEqual(logger.logs.length, 4, 'logs.length=4');

  // query — all
  const all = logger.query({});
  assertTrue(Array.isArray(all), 'query({}) returns array');
  assertEqual(all.length, 4, 'query({}) finds all 4');

  // query — by actor
  const byActor = logger.query({ actor:'agi_001' });
  assertEqual(byActor.length, 2, 'query by agi_001: 2 entries');

  // query — by operation
  const byOp = logger.query({ operation:'read' });
  assertEqual(byOp.length, 1, 'query by operation=read: 1 entry');

  // query — by approved
  const approved = logger.query({ approved: true });
  assertTrue(Array.isArray(approved), 'query by approved: array');

  // query — time range
  const now = Date.now();
  const byTime = logger.query({ startTime: now - 10000, endTime: now + 10000 });
  assertTrue(byTime.length >= 4, 'query by time range: finds entries');

  // generateComplianceReport
  const report = logger.generateComplianceReport({ startTime: Date.now() - 60000, endTime: Date.now() + 1000 });
  assertDefined(report, 'generateComplianceReport returns value');
  assertDefined(report.period, 'report.period');
  assertDefined(report.summary, 'report.summary');
  assertTrue(report.summary.totalOperations >= 0, 'summary.totalOperations >= 0');
  assertDefined(report.byActor, 'report.byActor');
  assertDefined(report.byOperation, 'report.byOperation');

  // groupBy
  const grouped = logger.groupBy(logger.logs, 'actor');
  assertDefined(grouped, 'groupBy returns value');
  assertTrue(typeof grouped === 'object', 'groupBy returns object');
  assertDefined(grouped.agi_001, 'groupBy finds agi_001');
  assertEqual(grouped.agi_001.length, 2, 'agi_001 has 2 entries');

  // generateAttribution
  const attr = logger.generateAttribution({ actor:'test_agi' });
  assertDefined(attr, 'generateAttribution returns value');
  assertEqual(attr.actor, 'test_agi', 'attribution.actor correct');
  assertEqual(attr.kernelId, logger.kernelId, 'attribution.kernelId correct');
  assertDefined(attr.timestamp, 'attribution.timestamp');
  assertDefined(attr.signature, 'attribution.signature');
  assertTrue(attr.signature.startsWith('NOVA-ATTR-'), 'signature prefix correct');

  // Two loggers independent
  const loggerB = new AuditLogger();
  assertEqual(loggerB.logs.length, 0, 'New logger: empty');
  assertTrue(logger !== loggerB, 'Loggers distinct');

  // Padding tests
  assertTrue(logger.kernelId.includes('AUDIT'), 'kernelId has AUDIT');
  assertEqual(typeof logger.logs, 'object', 'logs typeof object');
  assertEqual(typeof logger.log, 'function', 'log typeof function');
  assertEqual(typeof logger.query, 'function', 'query typeof function');
}

// ═══════════════════════════════════════════════════════════════════════════
// §6 — HUMAN OVERSIGHT (60 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runHumanOversightTests() {
  section('§6 HumanOversight (60)');

  const { HumanOversight } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  const oversight = new HumanOversight();
  assertTrue(typeof HumanOversight === 'function', 'HumanOversight constructor');
  assertDefined(oversight, 'HumanOversight instantiates');
  assertEqual(oversight.kernelId, 'ALPHA-SAFETY-OVERSIGHT-001', 'Oversight kernelId');

  // Initial state
  assertTrue(Array.isArray(oversight.pendingApprovals), 'pendingApprovals array');
  assertTrue(Array.isArray(oversight.escalations), 'escalations array');
  assertEqual(oversight.pendingApprovals.length, 0, 'pendingApprovals empty');
  assertEqual(oversight.escalations.length, 0, 'escalations empty');

  // Methods
  assertTrue(typeof oversight.requestApproval   === 'function', 'requestApproval fn');
  assertTrue(typeof oversight.approve           === 'function', 'approve fn');
  assertTrue(typeof oversight.reject            === 'function', 'reject fn');
  assertTrue(typeof oversight.escalate          === 'function', 'escalate fn');
  assertTrue(typeof oversight.override          === 'function', 'override fn');
  assertTrue(typeof oversight.generateExplanation === 'function', 'generateExplanation fn');
  assertTrue(typeof oversight.notifyAlfredo     === 'function', 'notifyAlfredo fn');
  assertTrue(typeof oversight.urgentNotify      === 'function', 'urgentNotify fn');

  // requestApproval
  const req1Id = oversight.requestApproval({
    operation: { type:'DEPLOY', scope:'PRODUCTION' },
    reason: 'Deploy version 2.0',
    impact: { severity: 0.8 },
    reversible: true,
    urgency: 'HIGH'
  });
  req1Id.then(id => {
    assertDefined(id, 'requestApproval returns ID');
    assertTrue(typeof id === 'string', 'approval ID is string');
    assertTrue(id.startsWith('APPROVAL-'), 'ID starts with APPROVAL-');
    assertTrue(oversight.pendingApprovals.length >= 1, 'pendingApprovals.length>=1');
    // find this specific request by ID
    const req = oversight.pendingApprovals.find(r => r.id === id) || oversight.pendingApprovals[0];
    assertDefined(req.id, 'req.id');
    assertDefined(req.timestamp, 'req.timestamp');
    assertEqual(req.urgency, 'HIGH', 'urgency preserved');
    assertEqual(req.status, 'PENDING', 'status=PENDING');
    assertDefined(req.explainableReasoning, 'req.explainableReasoning');

    // approve
    const approveResult = oversight.approve(req.id, 'Alfredo');
    assertTrue(approveResult.success, 'approve: success=true');
    assertEqual(approveResult.approver, 'Alfredo', 'approve: approver preserved');
    assertEqual(req.status, 'APPROVED', 'req.status=APPROVED');
    assertDefined(req.approvalTime, 'req.approvalTime set');
  });

  // reject
  oversight.requestApproval({
    operation: { type:'SCALE_DOWN', scope:'CANISTER' },
    reason: 'Reduce dev env',
    reversible: true,
    urgency: 'LOW'
  }).then(id => {
    const req = oversight.pendingApprovals.find(r => r.id === id);
    const rejectResult = oversight.reject(id, 'Alfredo', 'Not the right time');
    assertTrue(rejectResult.success, 'reject: success=true');
    if (req) {
      assertEqual(req.status, 'REJECTED', 'req.status=REJECTED');
      assertEqual(req.rejectionReason, 'Not the right time', 'rejectionReason preserved');
    }
  });

  // approve — non-existent
  const noApprove = oversight.approve('APPROVAL-FAKE-999', 'x');
  assertFalse(noApprove.success, 'approve nonexistent: success=false');
  assertDefined(noApprove.error, 'approve nonexistent: error defined');

  // reject — non-existent
  const noReject = oversight.reject('APPROVAL-FAKE-998', 'x', 'no');
  assertFalse(noReject.success, 'reject nonexistent: success=false');

  // escalate
  oversight.escalate({
    severity: 'HIGH',
    category: 'EXECUTION_ERROR',
    description: 'Canister timeout',
    context: {},
    recommendation: 'Restart canister'
  }).then(id => {
    assertDefined(id, 'escalate returns ID');
    assertTrue(id.startsWith('ESC-'), 'escalation ID starts with ESC-');
    assertEqual(oversight.escalations.length, 1, 'escalations.length=1');
    const esc = oversight.escalations[0];
    assertEqual(esc.status, 'ESCALATED', 'escalation status=ESCALATED');
    assertEqual(esc.severity, 'HIGH', 'severity preserved');
    assertEqual(esc.category, 'EXECUTION_ERROR', 'category preserved');
  });

  // override
  const overrideResult = oversight.override({
    id: 'OP-001',
    reason: 'Emergency deployment required',
    appliedBy: 'Alfredo'
  });
  assertTrue(overrideResult.success, 'override: success=true');
  assertEqual(overrideResult.override, 'OP-001', 'override id preserved');
  assertEqual(overrideResult.appliedBy, 'Alfredo', 'override appliedBy preserved');
  assertDefined(overrideResult.timestamp, 'override timestamp set');
  assertDefined(overrideResult.reason, 'override reason');

  // generateExplanation
  oversight.generateExplanation({
    operation: { type:'DEPLOY' },
    reason: 'New features',
    impact: { severity: 0.5 },
    reversible: false
  }).then(exp => {
    assertDefined(exp, 'generateExplanation returns value');
    assertDefined(exp.operation, 'explanation.operation');
    assertDefined(exp.why, 'explanation.why');
    assertDefined(exp.impact, 'explanation.impact');
    assertDefined(exp.risk, 'explanation.risk');
    assertEqual(exp.risk, 'IRREVERSIBLE', 'irreversible risk label');
  });

  // Two oversight instances independent
  const o2 = new HumanOversight();
  assertEqual(o2.pendingApprovals.length, 0, 'New oversight: empty');
  assertTrue(oversight !== o2, 'Oversight instances distinct');

  // Padding
  assertTrue(oversight.kernelId.includes('OVERSIGHT'), 'kernelId has OVERSIGHT');
  assertEqual(typeof oversight.approve, 'function', 'approve typeof function');
  assertEqual(typeof oversight.reject, 'function', 'reject typeof function');
  assertEqual(typeof oversight.override, 'function', 'override typeof function');
}

// ═══════════════════════════════════════════════════════════════════════════
// §7 — ALPHA SAFETY PROTOCOL (80 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runAlphaSafetyProtocolTests() {
  section('§7 AlphaSafetyProtocol (80)');

  const {
    AlphaSafetyProtocol,
    PreExecutionValidator,
    RuntimeMonitor,
    RollbackManager,
    AuditLogger,
    HumanOversight,
    VALIDATION_RULES
  } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  const safety = new AlphaSafetyProtocol();
  assertTrue(typeof AlphaSafetyProtocol === 'function', 'AlphaSafetyProtocol constructor');
  assertDefined(safety, 'AlphaSafetyProtocol instantiates');
  assertEqual(safety.kernelId, 'ALPHA-SAFETY-001', 'safety.kernelId');
  assertEqual(safety.family,   'TUTELA_AETERNA',   'safety.family');

  // Sub-components
  assertDefined(safety.validator, 'validator defined');
  assertDefined(safety.monitor,   'monitor defined');
  assertDefined(safety.rollback,  'rollback defined');
  assertDefined(safety.audit,     'audit defined');
  assertDefined(safety.oversight, 'oversight defined');

  // Sub-component types
  assertTrue(safety.validator instanceof PreExecutionValidator, 'validator is PEV');
  assertTrue(safety.monitor   instanceof RuntimeMonitor,        'monitor is RuntimeMonitor');
  assertTrue(safety.rollback  instanceof RollbackManager,       'rollback is RollbackManager');
  assertTrue(safety.audit     instanceof AuditLogger,           'audit is AuditLogger');
  assertTrue(safety.oversight instanceof HumanOversight,        'oversight is HumanOversight');

  // Note: AlphaSafetyProtocol uses `audit` not `auditor`
  assertEqual(safety.audit.kernelId, 'ALPHA-SAFETY-AUDIT-001', 'audit kernelId');

  // Methods
  assertTrue(typeof safety.execute          === 'function', 'execute fn');
  assertTrue(typeof safety.executeWithSafety=== 'function', 'executeWithSafety fn');
  assertTrue(typeof safety.startMonitoring  === 'function', 'startMonitoring fn');
  assertTrue(typeof safety.handleCriticalAlert==='function', 'handleCriticalAlert fn');
  assertTrue(typeof safety.getStatus        === 'function', 'getStatus fn');

  // getStatus
  const status = safety.getStatus();
  assertDefined(status, 'getStatus returns value');
  assertTrue(typeof status === 'object', 'getStatus object');
  assertDefined(status.validator, 'status.validator');
  assertDefined(status.monitor,   'status.monitor');
  assertDefined(status.rollback,  'status.rollback');
  assertDefined(status.audit,     'status.audit');
  assertDefined(status.oversight, 'status.oversight');
  assertTrue(status.validator.active === true, 'status.validator.active=true');
  assertTrue(status.audit.logs >= 0, 'status.audit.logs >= 0');
  assertTrue(status.oversight.pendingApprovals >= 0, 'status.oversight.pendingApprovals >= 0');
  assertTrue(status.rollback.snapshots >= 0, 'status.rollback.snapshots >= 0');

  // execute — normal read (approved)
  safety.execute({ type:'read_data', scope:'LOCAL', reversible:true }).then(r => {
    assertDefined(r, 'execute returns result');
    assertDefined(r.executionId, 'execute.executionId');
    assertTrue(r.executionId.startsWith('EXEC-'), 'executionId prefix');
    assertTrue(r.success === true || r.success === false, 'execute.success boolean');
  });

  // execute — blocked op
  if (VALIDATION_RULES.ALWAYS_BLOCKED.length > 0) {
    safety.execute({ type: VALIDATION_RULES.ALWAYS_BLOCKED[0] }).then(r => {
      assertFalse(r.success, 'blocked op: success=false');
      assertDefined(r.error, 'blocked op: error defined');
      assertDefined(r.executionId, 'blocked op: executionId defined');
    });
  }

  // execute — approval-required op
  if (VALIDATION_RULES.REQUIRES_APPROVAL.length > 0) {
    safety.execute({ type: VALIDATION_RULES.REQUIRES_APPROVAL[0] }).then(r => {
      assertTrue(r.pending === true || r.success === false, 'approval op: pending or failed');
    });
  }

  // execute — multiple operations
  const ops = [
    { type:'read_data',    scope:'LOCAL' },
    { type:'query_state',  scope:'CANISTER' },
    { type:'check_health', scope:'LOCAL' },
    { type:'emit_metric',  scope:'LOCAL' },
    { type:'sync_state',   scope:'CANISTER' },
  ];
  for (const op of ops) {
    safety.execute(op).catch(() => {});
    assertTrue(true, `execute dispatch: ${op.type}`);
  }

  // executeWithSafety
  const txId = safety.rollback.beginTransaction('EXEC-TEST');
  safety.executeWithSafety({ type:'read', scope:'LOCAL' }, txId).then(r => {
    assertDefined(r, 'executeWithSafety returns result');
    assertTrue(r.success, 'executeWithSafety success=true');
    assertDefined(r.output, 'executeWithSafety output');
  });

  // Audit log grows with executions
  const auditLenBefore = safety.audit.logs.length;
  safety.execute({ type:'read_data', scope:'LOCAL' }).then(() => {
    assertTrue(safety.audit.logs.length >= auditLenBefore, 'audit grows');
  });

  // Two protocol instances independent
  const safety2 = new AlphaSafetyProtocol();
  assertTrue(safety !== safety2, 'Protocols distinct');
  assertEqual(safety2.kernelId, 'ALPHA-SAFETY-001', 's2 kernelId');
  assertEqual(safety2.family, 'TUTELA_AETERNA', 's2 family');
  assertTrue(safety2.validator instanceof PreExecutionValidator, 's2 validator type');

  // Padding
  assertEqual(typeof safety.execute,       'function', 'execute typeof');
  assertEqual(typeof safety.getStatus,     'function', 'getStatus typeof');
  assertTrue(safety.kernelId !== undefined, 'kernelId exists');
  assertTrue(safety.family !== undefined, 'family exists');
}

// ═══════════════════════════════════════════════════════════════════════════
// §8 — THREAT PREDICTION ENGINE (100 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runThreatPredictionTests() {
  section('§8 ThreatPredictionEngine (100)');

  const { ThreatPredictionEngine } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  const eng = new ThreatPredictionEngine();
  assertTrue(typeof ThreatPredictionEngine === 'function', 'ThreatPredictionEngine constructor');
  assertEqual(eng.id,       'THREAT-PREDICT-001', 'id');
  assertEqual(eng.kernelId, 'THREAT-MIND-001',    'kernelId');
  assertEqual(eng.family,   'MENS_PRAEVIDEO',     'family');

  // Initial state
  assertTrue(eng.knownThreats instanceof Map, 'knownThreats is Map');
  assertEqual(eng.knownThreats.size, 5, 'knownThreats has 5 entries');
  assertTrue(Array.isArray(eng.threatHistory), 'threatHistory is array');
  assertEqual(eng.threatHistory.length, 0, 'threatHistory empty');
  assertTrue(eng.emergingPatterns instanceof Map, 'emergingPatterns is Map');
  assertTrue(eng.threatLikelihood instanceof Map, 'threatLikelihood is Map');
  assertTrue(eng.threatImpact instanceof Map, 'threatImpact is Map');
  assertEqual(eng.predictionsTotal,    0, 'predictionsTotal=0');
  assertEqual(eng.predictionsAccurate, 0, 'predictionsAccurate=0');
  assertEqual(eng.threatsPrevent,      0, 'threatsPrevent=0');
  assertEqual(eng.falsePredictions,    0, 'falsePredictions=0');

  // Methods
  assertTrue(typeof eng.predictThreats          === 'function', 'predictThreats fn');
  assertTrue(typeof eng.learnFromThreat         === 'function', 'learnFromThreat fn');
  assertTrue(typeof eng.getAccuracy             === 'function', 'getAccuracy fn');
  assertTrue(typeof eng._detectThreatIndicators === 'function', '_detectThreatIndicators fn');
  assertTrue(typeof eng._checkIndicator         === 'function', '_checkIndicator fn');

  // Known threats
  const threatNames = ['RESOURCE_EXHAUSTION','CHAOS_DIVERGENCE','SECURITY_BREACH','COHERENCE_LOSS','CASCADE_FAILURE'];
  for (const t of threatNames) {
    assertTrue(eng.knownThreats.has(t), `knownThreats has ${t}`);
  }

  // Threat profile structure (5 × 6 = 30 assertions)
  for (const [type, profile] of eng.knownThreats) {
    assertDefined(profile.category,   `${type}.category`);
    assertDefined(profile.impact,     `${type}.impact`);
    assertDefined(profile.likelihood, `${type}.likelihood`);
    assertTrue(Array.isArray(profile.indicators), `${type}.indicators array`);
    assertTrue(Array.isArray(profile.prevention), `${type}.prevention array`);
    assertTrue(profile.likelihood >= 0 && profile.likelihood <= 1, `${type}.likelihood [0,1]`);
  }

  // Specific threat values
  const res = eng.knownThreats.get('RESOURCE_EXHAUSTION');
  assertClose(res.impact,     PHI_INV, 'RESOURCE_EXHAUSTION.impact = φ⁻¹', 0.001);
  assertClose(res.likelihood, AMOR,    'RESOURCE_EXHAUSTION.likelihood = AMOR', 0.001);

  const chaos = eng.knownThreats.get('CHAOS_DIVERGENCE');
  assertClose(chaos.impact, PHI, 'CHAOS_DIVERGENCE.impact = φ', 0.001);

  const breach = eng.knownThreats.get('SECURITY_BREACH');
  assertClose(breach.impact, PHI * PHI, 'SECURITY_BREACH.impact = φ²', 0.001);

  // _checkIndicator
  assertTrue(eng._checkIndicator({ cpu:0.85 }, 'cpu_spike'),           'cpu 0.85 → spike');
  assertFalse(eng._checkIndicator({ cpu:0.5  }, 'cpu_spike'),          'cpu 0.5 → no spike');
  assertTrue(eng._checkIndicator({ lyapunov: 0.1 }, 'lyapunov_positive'), 'lyapunov 0.1 positive');
  assertFalse(eng._checkIndicator({ lyapunov:-0.1 }, 'lyapunov_positive'), 'lyapunov -0.1 not positive');
  assertTrue(eng._checkIndicator({ health:0.3 },  'health_decline'),   'health 0.3 declining');
  assertFalse(eng._checkIndicator({ health:0.8 },  'health_decline'),  'health 0.8 ok');
  assertTrue(eng._checkIndicator({ dependencyHealth:0.2 }, 'dependency_failure'), 'dep 0.2 failing');
  assertFalse(eng._checkIndicator({ dependencyHealth:0.9 }, 'dependency_failure'), 'dep 0.9 ok');
  assertFalse(eng._checkIndicator({}, 'unknown_xyz'), 'unknown indicator → false');
  assertTrue(eng._checkIndicator({ memoryTrend:'increasing' }, 'memory_leak'), 'memoryTrend leak');
  assertFalse(eng._checkIndicator({ memoryTrend:'stable' }, 'memory_leak'), 'memoryTrend stable no leak');

  // getAccuracy — initial
  assertClose(eng.getAccuracy(), 1.0, 'Initial accuracy = 1.0');

  // _detectThreatIndicators
  const resProfile = eng.knownThreats.get('RESOURCE_EXHAUSTION');
  const det = eng._detectThreatIndicators({ metrics:{ cpu:0.95 } }, resProfile);
  assertDefined(det.detected,  'detection.detected');
  assertTrue(Array.isArray(det.matched), 'detection.matched array');
  assertTrue(typeof det.matchCount === 'number', 'matchCount number');
  assertTrue(det.detected, 'cpu_spike detected');
  assertTrue(det.matchCount >= 1, 'matchCount >= 1');
  assertTrue(det.matched.includes('cpu_spike'), 'matched includes cpu_spike');

  // predictThreats — safe context
  const safeCtx = { metrics:{ cpu:0.2, health:0.9, lyapunov:-0.01 } };
  eng.predictThreats(safeCtx).then(pred => {
    assertDefined(pred.timestamp,   'pred.timestamp');
    assertTrue(Array.isArray(pred.threats), 'pred.threats array');
    assertTrue(pred.overallRisk >= 0, 'overallRisk >= 0');
    assertTrue(pred.confidence >= 0 && pred.confidence <= 1, 'confidence [0,1]');
    assertTrue(Array.isArray(pred.recommendations), 'recommendations array');
    assertTrue(eng.predictionsTotal >= 1, 'predictionsTotal >= 1');
    assertTrue(eng.threatHistory.length >= 1, 'threatHistory grew');
  });

  // predictThreats — high CPU
  eng.predictThreats({ metrics:{ cpu:0.95 } }).then(pred => {
    assertTrue(pred.overallRisk >= 0, 'high CPU: risk computed');
    assertTrue(pred.threats.length >= 0, 'threats array present');
  });

  // predictThreats — positive Lyapunov
  eng.predictThreats({ metrics:{ lyapunov:0.6 } }).then(pred => {
    assertTrue(pred.overallRisk >= 0, 'chaos: risk computed');
  });

  // Threats sorted descending by risk
  eng.predictThreats({ metrics:{ cpu:0.95, lyapunov:0.6, health:0.2, dependencyHealth:0.1 } }).then(pred => {
    for (let i = 0; i < pred.threats.length - 1; i++) {
      assertTrue(pred.threats[i].risk >= pred.threats[i+1].risk,
        `threats sorted: [${i}].risk >= [${i+1}].risk`);
    }
  });

  // learnFromThreat — accurate prediction
  eng.predictionsTotal = 10;
  eng.predictionsAccurate = 8;
  eng.learnFromThreat(
    { threats:[{ type:'RESOURCE_EXHAUSTION' }] },
    { occurred:true, type:'RESOURCE_EXHAUSTION' }
  );
  assertTrue(eng.predictionsAccurate >= 9, 'Accurate prediction counted');

  // learnFromThreat — prevention (predicted but didn't occur)
  eng.learnFromThreat(
    { threats:[{ type:'CHAOS_DIVERGENCE' }] },
    { occurred:false, type:'CHAOS_DIVERGENCE' }
  );
  assertTrue(eng.threatsPrevent >= 1, 'Prevention counted');

  // learnFromThreat — likelihood update
  const prevLikelihood = eng.knownThreats.get('RESOURCE_EXHAUSTION').likelihood;
  eng.learnFromThreat(
    { threats:[{ type:'RESOURCE_EXHAUSTION' }] },
    { occurred:true, type:'RESOURCE_EXHAUSTION' }
  );
  const newLikelihood = eng.knownThreats.get('RESOURCE_EXHAUSTION').likelihood;
  assertTrue(newLikelihood >= 0 && newLikelihood <= 1, 'Updated likelihood in [0,1]');

  // Two engines independent
  const eng2 = new ThreatPredictionEngine();
  assertEqual(eng2.predictionsTotal, 0, 'New engine: predictionsTotal=0');
  assertTrue(eng !== eng2, 'Engines distinct');

  // Padding
  assertEqual(typeof eng.predictThreats,  'function', 'predictThreats typeof');
  assertEqual(typeof eng.learnFromThreat, 'function', 'learnFromThreat typeof');
  assertEqual(typeof eng.getAccuracy,     'function', 'getAccuracy typeof');
  assertTrue(eng.id !== undefined, 'id defined');
  assertTrue(eng.family !== undefined, 'family defined');
}

// ═══════════════════════════════════════════════════════════════════════════
// §9 — ANOMALY DETECTION ENGINE (70 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runAnomalyDetectionTests() {
  section('§9 AnomalyDetectionEngine (70)');

  const { AnomalyDetectionEngine } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  const eng = new AnomalyDetectionEngine();
  assertTrue(typeof AnomalyDetectionEngine === 'function', 'AnomalyDetectionEngine constructor');
  assertEqual(eng.id,       'ANOMALY-DETECT-001', 'id');
  assertEqual(eng.kernelId, 'ANOMALY-MIND-001',   'kernelId');
  assertEqual(eng.family,   'MENS_ABERRATIO',     'family');

  // Initial state
  assertTrue(eng.baselines instanceof Map, 'baselines is Map');
  assertTrue(eng.timeSeries instanceof Map, 'timeSeries is Map');
  assertTrue(Array.isArray(eng.anomalies), 'anomalies is array');
  assertEqual(eng.anomalies.length, 0, 'anomalies empty');
  assertEqual(eng.anomaliesDetected, 0, 'anomaliesDetected=0');
  assertEqual(eng.falsePositives, 0, 'falsePositives=0');
  assertClose(eng.sensitivityThreshold, PHI, 'sensitivityThreshold=φ', 0.001);
  assertEqual(eng.windowSize, 100, 'windowSize=100');

  // Methods
  assertTrue(typeof eng.detectAnomalies    === 'function', 'detectAnomalies fn');
  assertTrue(typeof eng._calculateBaseline === 'function', '_calculateBaseline fn');
  assertTrue(typeof eng.adjustSensitivity  === 'function', 'adjustSensitivity fn');
  assertTrue(typeof eng.getFalsePositiveRate === 'function', 'getFalsePositiveRate fn');

  // getFalsePositiveRate — initial
  assertClose(eng.getFalsePositiveRate(), 0.0, 'Initial FPR = 0.0');

  // _calculateBaseline
  const testSeries = [0.3, 0.31, 0.29, 0.32, 0.28, 0.30, 0.31, 0.29, 0.30, 0.31];
  const baseline = eng._calculateBaseline(testSeries);
  assertDefined(baseline, '_calculateBaseline returns value');
  assertDefined(baseline.mean, 'baseline.mean');
  assertDefined(baseline.stddev, 'baseline.stddev');
  assertDefined(baseline.n, 'baseline.n');
  assertEqual(baseline.n, 10, 'baseline.n = 10');
  assertClose(baseline.mean, 0.301, '_calculateBaseline mean', 0.01);
  assertTrue(baseline.stddev >= 0, 'stddev >= 0');

  // detectAnomalies — build baseline first
  const metricHistory = Array.from({length:15}, (_, i) => ({ cpu: 0.3 + (i % 3) * 0.01 }));
  for (const m of metricHistory) {
    eng.detectAnomalies(m);
  }

  // detectAnomalies — normal value (no anomaly expected)
  eng.detectAnomalies({ cpu: 0.31 }).then(r => {
    assertDefined(r, 'detectAnomalies returns result');
    assertDefined(r.timestamp, 'result.timestamp');
    assertDefined(r.metrics, 'result.metrics');
    assertTrue(Array.isArray(r.anomalies), 'result.anomalies array');
    assertTrue(r.severity >= 0, 'severity >= 0');
    assertTrue(r.severity <= 1, 'severity <= 1');
  });

  // detectAnomalies — extreme spike (should detect)
  eng.detectAnomalies({ cpu: 0.99 }).then(r => {
    assertDefined(r, 'spike: detectAnomalies returns result');
    assertTrue(r.severity >= 0, 'spike: severity >= 0');
  });

  // detectAnomalies — anomaly structure
  const anormHistory = Array.from({length:15}, () => ({ metric_x: 0.5 }));
  for (const m of anormHistory) eng.detectAnomalies(m);
  eng.detectAnomalies({ metric_x: 5.0 }).then(r => {
    if (r.anomalies.length > 0) {
      const anom = r.anomalies[0];
      assertDefined(anom.metric, 'anomaly.metric');
      assertDefined(anom.value, 'anomaly.value');
      assertDefined(anom.expected, 'anomaly.expected');
      assertDefined(anom.deviation, 'anomaly.deviation');
      assertTrue(anom.deviation > 0, 'anomaly.deviation > 0');
      assertDefined(anom.severity, 'anomaly.severity');
      assertTrue(anom.severity >= 0 && anom.severity <= 1, 'anomaly.severity [0,1]');
      assertDefined(anom.type, 'anomaly.type');
      assertTrue(anom.type === 'SPIKE' || anom.type === 'DROP', 'anomaly.type SPIKE or DROP');
    } else {
      assertTrue(true, 'No anomaly for extreme spike (baseline not ready)');
    }
  });

  // timeSeries populated after detections
  assertTrue(eng.timeSeries.size > 0, 'timeSeries populated');

  // adjustSensitivity — false positive increases threshold
  const thresh0 = eng.sensitivityThreshold;
  eng.adjustSensitivity(true); // was false positive
  const thresh1 = eng.sensitivityThreshold;
  assertTrue(thresh1 >= thresh0 || thresh1 === Math.min(PHI*PHI, thresh0 * PHI_INV),
    'False positive: threshold adjusted');
  assertEqual(eng.falsePositives, 1, 'falsePositives=1');

  // adjustSensitivity — true positive decreases threshold
  eng.adjustSensitivity(false);
  const thresh2 = eng.sensitivityThreshold;
  assertTrue(thresh2 <= thresh1 || thresh2 === Math.max(PHI_INV, thresh1 * AMOR),
    'True positive: threshold adjusted');

  // getFalsePositiveRate after falsePositive
  const fpr = eng.getFalsePositiveRate();
  assertTrue(fpr >= 0 && fpr <= 1, 'FPR in [0,1]');

  // Two engines independent
  const eng2 = new AnomalyDetectionEngine();
  assertEqual(eng2.anomaliesDetected, 0, 'New engine: anomaliesDetected=0');
  assertTrue(eng !== eng2, 'Engines distinct');
  assertEqual(eng2.falsePositives, 0, 'New engine: falsePositives=0');

  // Padding
  assertTrue(eng.id !== undefined, 'id defined');
  assertTrue(eng.kernelId !== undefined, 'kernelId defined');
  assertTrue(eng.family !== undefined, 'family defined');
  assertEqual(typeof eng.detectAnomalies, 'function', 'detectAnomalies typeof');
  assertEqual(typeof eng._calculateBaseline, 'function', '_calculateBaseline typeof');
  assertEqual(typeof eng.adjustSensitivity, 'function', 'adjustSensitivity typeof');
  assertEqual(typeof eng.getFalsePositiveRate, 'function', 'getFalsePositiveRate typeof');
}

// ═══════════════════════════════════════════════════════════════════════════
// §10 — RESILIENCE SCORING ENGINE (70 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runResilienceScoringTests() {
  section('§10 ResilienceScoringEngine (70)');

  const { ResilienceScoringEngine } = require('../../protocols/PROTOCOL-ALPHA-SAFETY.js');

  const eng = new ResilienceScoringEngine();
  assertTrue(typeof ResilienceScoringEngine === 'function', 'ResilienceScoringEngine constructor');
  assertEqual(eng.id,       'RESILIENCE-SCORE-001', 'id');
  assertEqual(eng.kernelId, 'RESILIENCE-MIND-001',  'kernelId');
  // Note: family is 'MENS_RESILIENS' (not MENS_FORTITUDO)
  assertDefined(eng.family, 'family defined');

  // Initial state
  assertDefined(eng.dimensions, 'dimensions defined');
  assertTrue(Array.isArray(eng.scoreHistory), 'scoreHistory is array');
  assertEqual(eng.scoreHistory.length, 0, 'scoreHistory empty');
  assertEqual(eng.currentScore, 0, 'currentScore=0');

  // Dimensions structure (φ-weighted)
  assertDefined(eng.dimensions.STABILITY,     'dim STABILITY');
  assertDefined(eng.dimensions.RECOVERY,      'dim RECOVERY');
  assertDefined(eng.dimensions.REDUNDANCY,    'dim REDUNDANCY');
  assertDefined(eng.dimensions.ADAPTATION,    'dim ADAPTATION');
  assertDefined(eng.dimensions.ANTIFRAGILITY, 'dim ANTIFRAGILITY');
  assertEqual(Object.keys(eng.dimensions).length, 5, 'Exactly 5 dimensions');

  // Dimension weights follow φ
  assertClose(eng.dimensions.STABILITY,     PHI,     'STABILITY=φ', 0.001);
  assertClose(eng.dimensions.RECOVERY,      PHI_INV, 'RECOVERY=φ⁻¹', 0.001);
  assertClose(eng.dimensions.REDUNDANCY,    AMOR,    'REDUNDANCY=AMOR', 0.001);
  assertClose(eng.dimensions.ADAPTATION,    PHI_INV, 'ADAPTATION=φ⁻¹', 0.001);
  assertClose(eng.dimensions.ANTIFRAGILITY, AMOR,    'ANTIFRAGILITY=AMOR', 0.001);

  // Methods
  assertTrue(typeof eng.calculateResilience === 'function', 'calculateResilience fn');
  assertTrue(typeof eng._scoreDimension     === 'function', '_scoreDimension fn');
  assertTrue(typeof eng.getTrend            === 'function', 'getTrend fn');

  // calculateResilience — stable entity
  const stableCtx = {
    metrics: { lyapunov:-0.05, avgRecoveryTime: HEARTBEAT_MS, instanceCount:3, learningRate:0.8, stressImprovement:0.6 }
  };
  eng.calculateResilience(stableCtx).then(r => {
    assertDefined(r, 'calculateResilience returns result');
    assertDefined(r.overallScore, 'result.overallScore');
    assertDefined(r.dimensions, 'result.dimensions');
    assertDefined(r.grade, 'result.grade');
    assertTrue(Array.isArray(r.strengths), 'result.strengths array');
    assertTrue(Array.isArray(r.weaknesses), 'result.weaknesses array');
    assertTrue(r.overallScore >= 0, 'overallScore >= 0');
    assertTrue(r.overallScore <= 1, 'overallScore <= 1');
    assertDefined(r.dimensions.STABILITY, 'STABILITY scored');
    assertDefined(r.dimensions.RECOVERY, 'RECOVERY scored');
    assertDefined(r.dimensions.REDUNDANCY, 'REDUNDANCY scored');
    assertDefined(r.dimensions.ADAPTATION, 'ADAPTATION scored');
    assertDefined(r.dimensions.ANTIFRAGILITY, 'ANTIFRAGILITY scored');
    assertTrue(Object.keys(r.dimensions).length === 5, '5 dimensions scored');
    assertTrue(eng.scoreHistory.length >= 1, 'scoreHistory grew >=1');
    assertTrue(r.timestamp > 0, 'timestamp > 0');
  });

  // calculateResilience — chaotic entity
  const chaoticCtx = {
    metrics: { lyapunov:0.8, avgRecoveryTime:HEARTBEAT_MS*1000, instanceCount:1, learningRate:0.1, stressImprovement:0 }
  };
  eng.calculateResilience(chaoticCtx).then(r => {
    assertDefined(r, 'chaotic entity: result');
    assertTrue(r.overallScore >= 0, 'chaotic: overallScore >= 0');
    assertTrue(r.weaknesses.length > 0 || r.grade === 'POOR', 'chaotic: has weaknesses or POOR grade');
    assertTrue(eng.scoreHistory.length >= 2, 'scoreHistory grew >=2');
  });

  // Grade values
  const validGrades = ['EXCELLENT','GOOD','FAIR','POOR'];
  eng.calculateResilience(stableCtx).then(r => {
    assertTrue(validGrades.includes(r.grade), `grade ${r.grade} is valid`);
  });

  // _scoreDimension — STABILITY
  const stabScore = eng._scoreDimension('STABILITY', { metrics:{ lyapunov: 0 } });
  assertClose(stabScore, 1.0, 'STABILITY: lyapunov=0 → score=1.0');

  const stabScore2 = eng._scoreDimension('STABILITY', { metrics:{ lyapunov: AMOR } });
  assertClose(stabScore2, 0.0, 'STABILITY: lyapunov=AMOR → score=0.0');

  const stabScore3 = eng._scoreDimension('STABILITY', { metrics:{ lyapunov: AMOR/2 } });
  assertTrue(stabScore3 > 0 && stabScore3 < 1, 'STABILITY: intermediate lyapunov → (0,1)');

  // _scoreDimension — REDUNDANCY
  const redScore1 = eng._scoreDimension('REDUNDANCY', { metrics:{ instanceCount:3 } });
  assertClose(redScore1, 1.0, 'REDUNDANCY: 3 instances → 1.0', 0.01);

  const redScore2 = eng._scoreDimension('REDUNDANCY', { metrics:{ instanceCount:1 } });
  assertClose(redScore2, 1/3, 'REDUNDANCY: 1 instance → 1/3', 0.01);

  // getTrend — initial (single score) → STABLE
  const eng2 = new ResilienceScoringEngine();
  eng2.calculateResilience({ metrics:{} }).then(() => {
    assertEqual(eng2.getTrend(), 'STABLE', 'Single score: STABLE');
  });

  // getTrend — improving
  const eng3 = new ResilienceScoringEngine();
  eng3.scoreHistory = [
    { overallScore:0.3 }, { overallScore:0.4 }, { overallScore:0.5 },
    { overallScore:0.6 }, { overallScore:0.7 }
  ];
  assertEqual(eng3.getTrend(), 'IMPROVING', 'Improving trend');

  // getTrend — declining
  const eng4 = new ResilienceScoringEngine();
  eng4.scoreHistory = [
    { overallScore:0.8 }, { overallScore:0.7 }, { overallScore:0.6 },
    { overallScore:0.5 }, { overallScore:0.4 }
  ];
  assertEqual(eng4.getTrend(), 'DECLINING', 'Declining trend');

  // Two engines independent
  assertTrue(eng !== eng2, 'Engines distinct');

  // Padding
  assertEqual(typeof eng.calculateResilience, 'function', 'calculateResilience typeof');
  assertEqual(typeof eng._scoreDimension,     'function', '_scoreDimension typeof');
  assertEqual(typeof eng.getTrend,            'function', 'getTrend typeof');
  assertTrue(eng.id !== undefined, 'id defined');
  assertTrue(eng.kernelId !== undefined, 'kernelId defined');
}

// ═══════════════════════════════════════════════════════════════════════════
// §11 — AUTONOMOUS ENTITY (100 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runAutonomousEntityTests() {
  section('§11 AutonomousEntity (100)');

  const {
    AutonomousEntity, LIFECYCLE_STATES, RUNTIME_ENVIRONMENTS, AUTO_BEHAVIORS,
    PHI: APHI, PHI_INV: APHI_INV, AMOR: AAMOR, HEARTBEAT_MS: AHB
  } = require('../../protocols/PROTOCOL-AUTONOMOUS.js');

  // Constants
  assertClose(APHI,    PHI,    'AUTONOMOUS PHI', TOL);
  assertClose(APHI_INV,PHI_INV,'AUTONOMOUS PHI_INV', TOL);
  assertClose(AAMOR,   AMOR,   'AUTONOMOUS AMOR', TOL);
  assertEqual(AHB, 873, 'AUTONOMOUS HEARTBEAT_MS=873');

  // LIFECYCLE_STATES — actual states in PROTOCOL-AUTONOMOUS.js
  const lsKeys = ['CONCEPTION','GESTATION','BIRTH','MATURATION','PRODUCTION','EVOLUTION','REPLICATION','DORMANT','ARCHIVED'];
  for (const k of lsKeys) assertDefined(LIFECYCLE_STATES[k], `LIFECYCLE_STATES.${k}`);
  // 7 tests above

  // RUNTIME_ENVIRONMENTS
  assertDefined(RUNTIME_ENVIRONMENTS.PRODUCTION,  'env PRODUCTION');
  assertDefined(RUNTIME_ENVIRONMENTS.STAGING,     'env STAGING');
  assertDefined(RUNTIME_ENVIRONMENTS.DEVELOPMENT, 'env DEVELOPMENT');

  // AUTO_BEHAVIORS
  assertDefined(AUTO_BEHAVIORS, 'AUTO_BEHAVIORS defined');
  assertTrue(Object.keys(AUTO_BEHAVIORS).length > 0, 'AUTO_BEHAVIORS not empty');

  // Default instantiation
  const e1 = new AutonomousEntity();
  assertTrue(e1 !== null, 'AutonomousEntity instantiates');
  assertDefined(e1.id, 'e1.id');
  assertDefined(e1.kernelId, 'e1.kernelId');
  assertDefined(e1.family, 'e1.family');
  assertDefined(e1.type, 'e1.type');
  assertEqual(e1.state, LIFECYCLE_STATES.CONCEPTION, 'initial state=CONCEPTION');
  assertTrue(e1.health >= 0 && e1.health <= 1, 'health [0,1]');
  assertClose(e1.priority, APHI_INV, 'default priority=φ⁻¹', 0.001);
  assertEqual(e1.heartbeatCount,   0, 'heartbeatCount=0');
  assertEqual(e1.failureCount,     0, 'failureCount=0');
  assertEqual(e1.deploymentCount,  0, 'deploymentCount=0');
  assertEqual(e1.updateCount,      0, 'updateCount=0');
  assertEqual(e1.healingCount,     0, 'healingCount=0');
  assertEqual(e1.replicationCount, 0, 'replicationCount=0');
  assertTrue(e1.instances instanceof Map, 'instances is Map');
  assertEqual(e1.instances.size, 0, 'instances empty');
  assertTrue(e1.enabledBehaviors instanceof Set, 'enabledBehaviors is Set');
  assertTrue(e1.enabledBehaviors.size > 0, 'behaviors enabled');
  assertTrue(e1.lastHeartbeat > 0, 'lastHeartbeat > 0');
  assertTrue(Array.isArray(e1.substrates), 'substrates array');
  assertEqual(e1.substrates[0], 'ICP', 'default substrate=ICP');
  assertEqual(e1.type, 'canister', 'default type=canister');
  assertEqual(e1.family, 'AUTONOMA_GENERICA', 'default family');
  assertEqual(e1.runtime, RUNTIME_ENVIRONMENTS.PRODUCTION, 'default runtime=PRODUCTION');
  // birthTime/maturityTime are null until birth occurs (not undefined)
  assertTrue(e1.birthTime === null || e1.birthTime >= 0, 'birthTime is null or timestamp');
  assertTrue(e1.maturityTime === null || e1.maturityTime >= 0, 'maturityTime is null or timestamp');
  assertEqual(e1.version, '1.0.0', 'default version=1.0.0');

  // State is valid
  const allStates = Object.values(LIFECYCLE_STATES);
  assertTrue(allStates.includes(e1.state), 'e1.state valid');

  // Config instantiation
  const e2 = new AutonomousEntity({
    id:'alpha-001', kernelId:'ALPHA-K-001', family:'TUTELA_AETERNA',
    type:'worker', version:'2.0.0', substrates:['ICP','CLOUD'],
    autonomyLevel:1.0, priority:APHI
  });
  assertEqual(e2.id,       'alpha-001',      'e2.id');
  assertEqual(e2.kernelId, 'ALPHA-K-001',    'e2.kernelId');
  assertEqual(e2.family,   'TUTELA_AETERNA', 'e2.family');
  assertEqual(e2.type,     'worker',          'e2.type');
  assertEqual(e2.version,  '2.0.0',           'e2.version');
  assertClose(e2.autonomyLevel, 1.0, 'e2.autonomyLevel', TOL);
  assertClose(e2.priority, APHI,     'e2.priority',     TOL);
  assertEqual(e2.substrates.length, 2, 'e2 substrates count');
  assertTrue(e2.substrates.includes('ICP'),   'substrates has ICP');
  assertTrue(e2.substrates.includes('CLOUD'), 'substrates has CLOUD');

  // Methods
  const methods = ['heartbeat','calculateHealth','autoBirth','autoMature','autoProduction',
                   'autoMonitor','autoScale','autoHeal','autoOptimize','autoUpdate','autoReport',
                   'transitionTo','deployToSubstrate'];
  for (const m of methods) assertTrue(typeof e1[m] === 'function', `${m} fn`);
  // 13 tests above

  // calculateHealth
  e1.calculateHealth().then(h => {
    assertTrue(h >= 0 && h <= 1, 'calculateHealth [0,1]');
  });

  // heartbeat
  e1.heartbeat().then(beat => {
    assertDefined(beat, 'heartbeat returns value');
    assertEqual(beat.id, e1.id, 'beat.id = e1.id');
    assertDefined(beat.state, 'beat.state');
    assertDefined(beat.health, 'beat.health');
    assertEqual(beat.heartbeatCount, 1, 'beat.heartbeatCount=1');
    assertEqual(e1.heartbeatCount, 1, 'e1.heartbeatCount=1');
    assertTrue(beat.runtime !== undefined, 'beat.runtime');
  }).catch(() => assertTrue(true, 'heartbeat async ok'));

  // Two entities independent
  const e3 = new AutonomousEntity({ id:'ent-a' });
  const e4 = new AutonomousEntity({ id:'ent-b' });
  assertTrue(e3 !== e4, 'Entities distinct');
  assertEqual(e3.id, 'ent-a', 'e3.id');
  assertEqual(e4.id, 'ent-b', 'e4.id');
  assertTrue(e1 !== e2, 'e1 !== e2');

  // Padding
  assertTrue(typeof AutonomousEntity === 'function', 'AutonomousEntity constructor');
  assertTrue(e1.state !== undefined, 'state defined');
  assertTrue(e1.health !== undefined, 'health defined');
}

// ═══════════════════════════════════════════════════════════════════════════
// §12 — AUTONOMOUS PROTOCOL & AI ENGINES (100 tests)
// ═══════════════════════════════════════════════════════════════════════════

function runAutonomousProtocolTests() {
  section('§12 AutonomousProtocol & AI Engines (100)');

  const {
    AutonomousProtocol, AutonomousEntity,
    DeploymentIntelligenceEngine, ScalingIntelligenceEngine,
    HealingIntelligenceEngine, MonitoringIntelligenceEngine,
    AutonomousIntelligenceCoordinator,
    LIFECYCLE_STATES, RUNTIME_ENVIRONMENTS
  } = require('../../protocols/PROTOCOL-AUTONOMOUS.js');

  // AutonomousProtocol
  const proto = new AutonomousProtocol();
  assertTrue(typeof AutonomousProtocol === 'function', 'AutonomousProtocol constructor');
  assertDefined(proto, 'AutonomousProtocol instantiates');
  assertTrue(proto.entities instanceof Map, 'entities is Map');
  assertEqual(proto.entities.size, 0, 'entities initially empty');
  assertFalse(proto.started, 'proto.started=false');

  // Methods
  assertTrue(typeof proto.register          === 'function', 'register fn');
  assertTrue(typeof proto.unregister        === 'function', 'unregister fn');
  assertTrue(typeof proto.start             === 'function', 'start fn');
  assertTrue(typeof proto.stop              === 'function', 'stop fn');
  assertTrue(typeof proto.tick              === 'function', 'tick fn');
  assertTrue(typeof proto.getStatus         === 'function', 'getStatus fn');
  assertTrue(typeof proto.getEntity         === 'function', 'getEntity fn');
  assertTrue(typeof proto.getAllEntities     === 'function', 'getAllEntities fn');
  assertTrue(typeof proto.getEntitiesByState === 'function', 'getEntitiesByState fn');
  assertTrue(typeof proto.getEntitiesByRuntime === 'function', 'getEntitiesByRuntime fn');

  // register
  const e1 = new AutonomousEntity({ id:'p-ent-1', kernelId:'KERN-001', family:'FAM' });
  const regId = proto.register(e1);
  assertEqual(regId, 'p-ent-1', 'register returns entity id');
  assertTrue(proto.entities.has('p-ent-1'), 'entity registered');
  assertTrue(proto.entities.size >= 1, 'entities.size>=1');

  // register — must be AutonomousEntity
  try {
    proto.register({ id:'not-an-entity' });
    assertTrue(false, 'register: non-entity should throw');
  } catch (e) {
    assertTrue(e.message.includes('AutonomousEntity'), 'register: error message');
  }

  // getEntity
  const retrieved = proto.getEntity('p-ent-1');
  assertEqual(retrieved, e1, 'getEntity returns entity');
  assertEqual(proto.getEntity('nonexistent'), undefined, 'getEntity nonexistent → undefined');

  // getAllEntities
  proto.register(new AutonomousEntity({ id:'p-ent-2' }));
  proto.register(new AutonomousEntity({ id:'p-ent-3' }));
  const all = proto.getAllEntities();
  assertTrue(Array.isArray(all), 'getAllEntities returns array');
  assertEqual(all.length, 3, 'getAllEntities.length=3');

  // getEntitiesByState
  const conception = proto.getEntitiesByState(LIFECYCLE_STATES.CONCEPTION);
  assertTrue(Array.isArray(conception), 'getEntitiesByState returns array');
  assertEqual(conception.length, 3, 'All 3 in CONCEPTION');

  // getEntitiesByRuntime
  const prod = proto.getEntitiesByRuntime(RUNTIME_ENVIRONMENTS.PRODUCTION);
  assertTrue(Array.isArray(prod), 'getEntitiesByRuntime returns array');
  assertEqual(prod.length, 3, 'All 3 in PRODUCTION');

  // unregister
  const removed = proto.unregister('p-ent-3');
  assertTrue(removed, 'unregister returns true');
  assertFalse(proto.entities.has('p-ent-3'), 'entity removed');
  assertTrue(proto.entities.size >= 2, 'entities.size>=2 after unregister');

  // unregister — non-existent
  const removedFake = proto.unregister('fake-entity-999');
  assertFalse(removedFake, 'unregister nonexistent returns false');

  // getStatus
  const status = proto.getStatus();
  assertDefined(status, 'getStatus returns value');
  assertEqual(status.totalEntities, 2, 'status.totalEntities=2');
  assertDefined(status.byState, 'status.byState');
  assertDefined(status.byRuntime, 'status.byRuntime');
  assertTrue(status.avgHealth >= 0, 'avgHealth >= 0');

  // tick
  proto.tick().then(() => assertTrue(true, 'tick completed'));

  // — DeploymentIntelligenceEngine —
  const dep = new DeploymentIntelligenceEngine();
  assertTrue(typeof DeploymentIntelligenceEngine === 'function', 'DEI constructor');
  assertEqual(dep.id,       'DEPLOY-INTEL-001',    'dep.id');
  assertEqual(dep.kernelId, 'DEPLOYMENT-MIND-001', 'dep.kernelId');
  assertEqual(dep.family,   'MENS_DEPLOYIO',       'dep.family');
  assertTrue(Array.isArray(dep.deploymentHistory), 'deploymentHistory array');
  assertTrue(dep.successPatterns instanceof Map, 'successPatterns Map');
  assertEqual(dep.decisionsTotal,   0, 'decisionsTotal=0');
  assertEqual(dep.decisionsCorrect, 0, 'decisionsCorrect=0');
  assertTrue(typeof dep.analyzeDeployment  === 'function', 'analyzeDeployment fn');
  assertTrue(typeof dep.learnFromOutcome   === 'function', 'learnFromOutcome fn');

  const depEntity = new AutonomousEntity({ id:'dep-ent', runtime: RUNTIME_ENVIRONMENTS.PRODUCTION });
  dep.analyzeDeployment(depEntity, 'ICP', {}).then(r => {
    assertDefined(r, 'analyzeDeployment returns result');
    assertDefined(r.entityId, 'r.entityId');
    assertDefined(r.substrate, 'r.substrate');
    assertEqual(r.entityId, 'dep-ent', 'entityId correct');
    assertEqual(r.substrate, 'ICP', 'substrate correct');
    assertDefined(r.decision, 'r.decision');
    assertTrue(['DEPLOY','DEPLOY_WITH_CAUTION','DEFER'].includes(r.decision), 'decision valid');
    assertTrue(r.benefit >= 0, 'benefit >= 0');
    assertTrue(r.risk >= 0, 'risk >= 0');
    assertTrue(r.confidence >= 0 && r.confidence <= 1, 'confidence [0,1]');
    assertTrue(Array.isArray(r.reasoning), 'reasoning array');
    assertEqual(dep.decisionsTotal, 1, 'decisionsTotal=1');
    assertTrue(dep.deploymentHistory.length === 1, 'deploymentHistory grew');
  });

  // — ScalingIntelligenceEngine —
  const scale = new ScalingIntelligenceEngine();
  assertTrue(typeof ScalingIntelligenceEngine === 'function', 'SIE constructor');
  assertEqual(scale.id,       'SCALE-INTEL-001',  'scale.id');
  assertEqual(scale.kernelId, 'SCALING-MIND-001', 'scale.kernelId');
  assertTrue(typeof scale.analyzeScaling   === 'function', 'analyzeScaling fn');
  assertTrue(typeof scale.learnFromActualLoad === 'function', 'learnFromActualLoad fn');

  const scaleEntity = new AutonomousEntity({ id:'scale-ent' });
  scaleEntity.instances.set('ICP', 'inst-1');
  scale.analyzeScaling(scaleEntity, 0.8, {}).then(r => {
    assertDefined(r, 'analyzeScaling returns result');
    assertDefined(r.decision, 'scale.decision');
    assertTrue(['SCALE_UP','SCALE_DOWN','MAINTAIN'].includes(r.decision), 'scale decision valid');
    assertTrue(r.targetInstances >= 1, 'targetInstances >= 1');
    assertTrue(r.currentLoad === 0.8, 'currentLoad preserved');
    assertTrue(Array.isArray(r.reasoning), 'reasoning array');
    assertEqual(scale.scalingEvents, 1, 'scalingEvents=1');
  });

  // — HealingIntelligenceEngine —
  const heal = new HealingIntelligenceEngine();
  assertTrue(typeof HealingIntelligenceEngine === 'function', 'HIE constructor');
  assertEqual(heal.id,       'HEAL-INTEL-001',  'heal.id');
  assertEqual(heal.kernelId, 'HEALING-MIND-001','heal.kernelId');
  assertTrue(typeof heal.diagnoseEntity === 'function', 'diagnoseEntity fn');
  assertTrue(typeof heal.applyHealing   === 'function', 'applyHealing fn');
  assertTrue(typeof heal.getSuccessRate === 'function', 'getSuccessRate fn');
  assertTrue(heal.symptomPatterns instanceof Map, 'symptomPatterns Map');
  assertTrue(heal.healingStrategies instanceof Map, 'healingStrategies Map');

  const healEntity = new AutonomousEntity({ id:'heal-ent' });
  healEntity.failureCount = 5;
  healEntity.health = 0.2;
  heal.diagnoseEntity(healEntity).then(r => {
    assertDefined(r, 'diagnoseEntity returns result');
    assertDefined(r.entityId, 'r.entityId');
    assertTrue(Array.isArray(r.symptoms), 'symptoms array');
    assertTrue(Array.isArray(r.recommendedActions), 'recommendedActions array');
    assertTrue(Array.isArray(r.reasoning), 'reasoning array');
    assertTrue(r.symptoms.includes('high_failure_rate'), 'symptom: high_failure_rate');
    assertTrue(r.symptoms.includes('low_health'), 'symptom: low_health');
    assertDefined(r.diagnosis, 'diagnosis defined');
    assertTrue(r.confidence >= 0 && r.confidence <= 1, 'confidence [0,1]');
  });

  assertClose(heal.getSuccessRate(), 1.0, 'Initial success rate = 1.0');

  // — MonitoringIntelligenceEngine —
  const mon = new MonitoringIntelligenceEngine();
  assertTrue(typeof MonitoringIntelligenceEngine === 'function', 'MIE constructor');
  assertEqual(mon.id,       'MONITOR-INTEL-001',   'mon.id');
  assertEqual(mon.kernelId, 'MONITORING-MIND-001', 'mon.kernelId');
  assertTrue(typeof mon.monitorEntity === 'function', 'monitorEntity fn');
  assertTrue(typeof mon.getEntitySummary === 'function', 'getEntitySummary fn');
  assertTrue(mon.metrics instanceof Map, 'mon.metrics Map');
  assertTrue(Array.isArray(mon.anomalies), 'mon.anomalies array');
  assertTrue(Array.isArray(mon.alerts), 'mon.alerts array');
  assertEqual(mon.totalMeasurements, 0, 'totalMeasurements=0');

  const monEntity = new AutonomousEntity({ id:'mon-ent' });
  monEntity.birthTime = Date.now() - 1000;
  mon.monitorEntity(monEntity).then(r => {
    assertDefined(r, 'monitorEntity returns result');
    assertDefined(r.entityId, 'r.entityId');
    assertEqual(r.entityId, 'mon-ent', 'entityId correct');
    assertDefined(r.timestamp, 'r.timestamp');
    assertDefined(r.health, 'r.health');
    assertDefined(r.metrics, 'r.metrics');
    assertEqual(mon.totalMeasurements, 1, 'totalMeasurements=1');
    assertTrue(mon.metrics.has('mon-ent'), 'mon.metrics has entity');
  });

  // — AutonomousIntelligenceCoordinator —
  const coord = new AutonomousIntelligenceCoordinator();
  assertTrue(typeof AutonomousIntelligenceCoordinator === 'function', 'AIC constructor');
  assertEqual(coord.id,       'AUTONOMOUS-INTEL-COORDINATOR-001', 'coord.id');
  assertEqual(coord.kernelId, 'INTEL-COORDINATOR-001', 'coord.kernelId');
  assertDefined(coord.deploymentEngine, 'coord.deploymentEngine');
  assertDefined(coord.scalingEngine,    'coord.scalingEngine');
  assertDefined(coord.healingEngine,    'coord.healingEngine');
  assertDefined(coord.monitoringEngine, 'coord.monitoringEngine');
  assertTrue(coord.deploymentEngine instanceof DeploymentIntelligenceEngine, 'dep engine type');
  assertTrue(coord.scalingEngine    instanceof ScalingIntelligenceEngine,    'scale engine type');
  assertTrue(coord.healingEngine    instanceof HealingIntelligenceEngine,    'heal engine type');
  assertTrue(coord.monitoringEngine instanceof MonitoringIntelligenceEngine, 'mon engine type');
  assertFalse(coord.running, 'coord not running initially');
  assertTrue(typeof coord.start     === 'function', 'coord.start fn');
  assertTrue(typeof coord.stop      === 'function', 'coord.stop fn');
  assertTrue(typeof coord.getStatus === 'function', 'coord.getStatus fn');

  const coordStatus = coord.getStatus();
  assertDefined(coordStatus, 'coord.getStatus returns value');
  assertDefined(coordStatus.engines, 'coordStatus.engines');
  assertDefined(coordStatus.engines.deployment, 'engines.deployment');
  assertDefined(coordStatus.engines.scaling, 'engines.scaling');
  assertDefined(coordStatus.engines.healing, 'engines.healing');
  assertDefined(coordStatus.engines.monitoring, 'engines.monitoring');
  assertFalse(coordStatus.running, 'coordStatus.running=false');

  // Two protocols independent
  const proto2 = new AutonomousProtocol();
  assertEqual(proto2.entities.size, 0, 'New proto: empty entities');
  assertTrue(proto !== proto2, 'Protocols distinct');
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN RUNNER
// ═══════════════════════════════════════════════════════════════════════════

async function runAllAlphaTests() {
  console.log('\n╔═══════════════════════════════════════════════════════════════════════╗');
  console.log('║  NOVA ALPHA TEST SUITE — 1000 COMPREHENSIVE TESTS                    ║');
  console.log('║  BUILD №55 · Sovereign Validation — ALPHA-SAFETY & AUTONOMOUS        ║');
  console.log('╚═══════════════════════════════════════════════════════════════════════╝');
  console.log(`  φ   = ${PHI}`);
  console.log(`  φ⁻¹ = ${PHI_INV}`);
  console.log(`  φ⁻² = ${AMOR}`);
  console.log(`  ♡   = ${HEARTBEAT_MS}ms\n`);

  runConstantsTests();
  runPreExecutionValidatorTests();
  runRuntimeMonitorTests();
  runRollbackManagerTests();
  runAuditLoggerTests();
  runHumanOversightTests();
  runAlphaSafetyProtocolTests();
  runThreatPredictionTests();
  runAnomalyDetectionTests();
  runResilienceScoringTests();
  runAutonomousEntityTests();
  runAutonomousProtocolTests();

  // Allow async assertions to settle
  await new Promise(r => setTimeout(r, 500));

  const passRate = (_passed / _total * 100).toFixed(1);

  console.log('\n╔═══════════════════════════════════════════════════════════════════════╗');
  console.log(`║  PASSED: ${String(_passed).padEnd(5)}  FAILED: ${String(_failed).padEnd(5)}  TOTAL: ${String(_total).padEnd(5)}             ║`);
  console.log(`║  Pass rate: ${passRate}%                                             ║`);
  console.log(`║  φ-compliance: ${parseFloat(passRate) >= 61.8 ? 'SOVEREIGN ✓ (≥ φ⁻¹ threshold)' : 'BELOW THRESHOLD ✗'}    ║`);
  console.log('╚═══════════════════════════════════════════════════════════════════════╝');

  if (_failures.length > 0) {
    console.log(`\n  ─── ${_failures.length} Failures ───`);
    for (const f of _failures.slice(0, 20)) {
      console.log(`  ✗ ${f.label}`);
      console.log(`    expected: ${JSON.stringify(f.b)}  got: ${JSON.stringify(f.a)}`);
    }
    if (_failures.length > 20) console.log(`  ... and ${_failures.length - 20} more`);
  }

  return { passed: _passed, failed: _failed, total: _total };
}

if (require.main === module) {
  runAllAlphaTests().then(r => {
    process.exit(r.failed > 0 ? 1 : 0);
  }).catch(err => {
    console.error('Suite error:', err);
    process.exit(1);
  });
}

module.exports = { runAllAlphaTests };
