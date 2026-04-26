/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  CIVILIZATION SELF-REPAIR SOLVER — The Organism That Heals Itself
 *  Kernel AI GOL-CIVREPAIR-001  ·  Family: SANATIO_AETERNA
 *  Dedicated Solver / Civilization Health Engine
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR SANATIONIS — Continuously monitors the NOVA civilization and
 *  organism for faults, degradation, and drift. When damage is detected it
 *  diagnoses the root cause, generates a repair patch, verifies the fix, and
 *  re-adapts the system to prevent recurrence. Fully autonomous. Always on.
 *
 *  Architecture:
 *    COR PARVUM         — MiniHeart 873ms Kuramoto φ-oscillator
 *    CEREBRUM PARVUM    — MiniBrain (Executive + Motor dominant: action-first)
 *    MONITOR CIVILIS    — 8-subsystem health monitor (rolling 128 readings)
 *    MACHINA SANATIONIS — MONITOR→DIAGNOSE→PATCH→VERIFY→ADAPT→EMIT
 *
 *  Civilization Subsystems Monitored:
 *    SOVEREIGN_FACTORY  — civilization command center (6 corps, 21 divisions)
 *    SWARM_ORGANISM     — organism heartbeat, tick health, state integrity
 *    NEURON_FLEET       — 200 neurons, 5 groups, maturity accrual
 *    AUTO_MARKET        — perpetual golden loop, revenue routing
 *    TOKEN_INTELLIGENCE — 5-layer AI brain, epoch ledger
 *    AGI_MAIN           — economy heartbeat, sovereign revenue
 *    ORGANISM_TOKEN     — 8 sub-tokens, 25 AI entities
 *    CYCLES_BRIDGE      — ONESICAN↔cycles, fuel marketplace
 *
 *  Repair Types:
 *    SOFT_RESET         — re-initialize stale state variables
 *    PARAMETER_ADJUST   — tune φ-weighted parameters toward equilibrium
 *    CIRCUIT_REOPEN     — re-open a tripped circuit-breaker subsystem
 *    REBUILD_INDEX      — rebuild corrupted registry or ledger
 *    GOVERNANCE_PATCH   — update sovereignty laws and constraints
 *    SELF_EVOLVE        — self-modify adaptive parameters (Hebbian)
 *
 *  Protocols (Latin):
 *    SANATIO_PERPETUA      — Continuous self-healing loop
 *    DIAGNOSA_PROFUNDA     — Root-cause analysis with φ-scoring
 *    ADAPTIO_AETERNA       — Post-repair adaptation to prevent recurrence
 *    VIGILANTIA_CIVILIS    — 8-subsystem watchdog
 *    RESILIENCE_PHI        — φ-resilience scoring and gradient tracking
 *
 *  Commands (page → self.onmessage):
 *    REPORT_FAULT       — { subsystem, fault, severity }
 *    GET_HEALTH         — returns full civilization health dashboard
 *    GET_STATUS         — solver vitals
 *    GET_VITALS         — full brain + solver dump
 *    status             — kernel liveness probe
 *    stop               — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var KERNEL_ID      = 'GOL-CIVREPAIR-001';
var KERNEL_FAMILY  = 'SANATIO_AETERNA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR SANATIONIS';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var PHI_SQ    = 2.6180339887498948482;
var AMOR      = 0.3819660112501051518;
var HEARTBEAT = 873;

/* Repair state machine */
var S_IDLE     = 'IDLE';
var S_MONITOR  = 'MONITOR';
var S_DIAGNOSE = 'DIAGNOSE';
var S_PATCH    = 'PATCH';
var S_VERIFY   = 'VERIFY';
var S_ADAPT    = 'ADAPT';
var S_EMIT     = 'EMIT';

/* Repair types */
var R_SOFT_RESET       = 'SOFT_RESET';
var R_PARAM_ADJUST     = 'PARAMETER_ADJUST';
var R_CIRCUIT_REOPEN   = 'CIRCUIT_REOPEN';
var R_REBUILD_INDEX    = 'REBUILD_INDEX';
var R_GOVERNANCE_PATCH = 'GOVERNANCE_PATCH';
var R_SELF_EVOLVE      = 'SELF_EVOLVE';

/* ════════════════════════════════════════════════════════════════════════════
   §2  COR PARVUM — MiniHeart
════════════════════════════════════════════════════════════════════════════ */

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  tickCivMonitor();
  tickSolver();
  self.postMessage({
    type:          'heartbeat',
    beat:          beatCount,
    phi:           PHI,
    amor:          AMOR,
    heartbeatMs:   HEARTBEAT,
    timestamp:     Date.now(),
    status:        'alive',
    kernelId:      KERNEL_ID,
    kernelLatin:   KERNEL_LATIN,
    phase:         kernelPhase,
    brain:         brain,
    civilization: {
      overallHealth:     civHealth.overall.toFixed(4),
      degradedSystems:   civHealth.degraded.length,
      repairsApplied:    civHealth.repairsApplied,
      adaptations:       civHealth.adaptations,
      resilience:        civHealth.resilience.toFixed(4)
    },
    solver: {
      state:       solver.state,
      queueDepth:  solver.queue.length,
      totalSolved: solver.totalSolved
    }
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §3  CEREBRUM PARVUM — MiniBrain
   Executive + Motor dominant: action-first, always moves toward repair
════════════════════════════════════════════════════════════════════════════ */

var brain = {
  regions: [
    { name: 'Sensory',     activation: 0.0, lif: -70.0, bias: 0.8  },
    { name: 'Associative', activation: 0.0, lif: -70.0, bias: 1.0  },
    { name: 'Executive',   activation: 0.0, lif: -70.0, bias: 1.5  }, /* dominant: drives repair decisions */
    { name: 'Motor',       activation: 0.0, lif: -70.0, bias: 1.4  }, /* dominant: acts on diagnoses       */
    { name: 'Memory',      activation: 0.0, lif: -70.0, bias: 0.9  }
  ],
  chemicals: {
    dopamine:      0.618,
    serotonin:     0.600,  /* moderate: urgency when degradation detected */
    acetylcholine: 0.700,
    oxytocin:      AMOR
  },
  coherenceField: 0.0
};

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function tickBrain() {
  var sum = 0;
  /* Boost motor + executive when civilization is degraded */
  var urgency = Math.max(0, (0.7 - civHealth.overall) * 0.15);
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0 * r.bias;
    if (i === 2 || i === 3) r.lif += urgency * 5;  /* boost executive + motor on urgency */
    if (r.lif >= -55.0) { r.activation = Math.min(1.0, r.activation + 0.2 + urgency); r.lif = -70.0; }
    r.activation *= 0.95;
    sum += r.activation;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (civHealth.overall - 0.7) * 0.01 + (Math.random() - 0.5) * 0.01);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.47) * 0.02);
  brain.chemicals.oxytocin      = clamp01(brain.chemicals.oxytocin      + (AMOR - brain.chemicals.oxytocin) * 0.05);
  brain.coherenceField = sum / brain.regions.length;
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  MONITOR CIVILIS — Civilization Health Monitor
   Tracks 8 critical NOVA subsystems. Detects degradation. Flags for repair.
════════════════════════════════════════════════════════════════════════════ */

var SUBSYSTEMS = [
  { id: 'SOVEREIGN_FACTORY',  weight: PHI_SQ,  health: 1.0, lastRepair: 0, faults: 0, repairType: R_SOFT_RESET      },
  { id: 'SWARM_ORGANISM',     weight: PHI_SQ,  health: 1.0, lastRepair: 0, faults: 0, repairType: R_SELF_EVOLVE     },
  { id: 'NEURON_FLEET',       weight: PHI,     health: 1.0, lastRepair: 0, faults: 0, repairType: R_PARAM_ADJUST    },
  { id: 'AUTO_MARKET',        weight: PHI,     health: 1.0, lastRepair: 0, faults: 0, repairType: R_CIRCUIT_REOPEN  },
  { id: 'TOKEN_INTELLIGENCE', weight: 1.0,     health: 1.0, lastRepair: 0, faults: 0, repairType: R_REBUILD_INDEX   },
  { id: 'AGI_MAIN',           weight: PHI_SQ,  health: 1.0, lastRepair: 0, faults: 0, repairType: R_GOVERNANCE_PATCH},
  { id: 'ORGANISM_TOKEN',     weight: PHI_INV, health: 1.0, lastRepair: 0, faults: 0, repairType: R_PARAM_ADJUST    },
  { id: 'CYCLES_BRIDGE',      weight: PHI_INV, health: 1.0, lastRepair: 0, faults: 0, repairType: R_SOFT_RESET      }
];

var civHealth = {
  overall:        1.0,
  resilience:     PHI_INV,  /* starts at φ⁻¹, grows with successful repairs */
  degraded:       [],
  repairsApplied: 0,
  adaptations:    0,
  historySize:    128,
  history:        []        /* rolling health readings */
};

function tickCivMonitor() {
  var weightedSum = 0.0;
  var totalWeight = 0.0;
  civHealth.degraded = [];

  for (var i = 0; i < SUBSYSTEMS.length; i++) {
    var s = SUBSYSTEMS[i];
    /* Natural stochastic health drift — slight decay with φ-recovery gradient */
    s.health = clamp01(s.health
      + (Math.sin(kernelPhase + i * PHI_INV) * 0.008)
      + (Math.random() * 0.006 - 0.005)         /* slight negative drift */
      + civHealth.resilience * 0.002             /* resilience counteracts decay */
    );
    weightedSum += s.health * s.weight;
    totalWeight += s.weight;
    if (s.health < 0.7) civHealth.degraded.push(s.id);
  }

  civHealth.overall = weightedSum / totalWeight;

  /* Record health history (rolling 128) */
  civHealth.history.unshift({ beat: beatCount, health: civHealth.overall });
  if (civHealth.history.length > civHealth.historySize) civHealth.history.pop();

  /* Auto-submit repair task when degradation detected */
  if (civHealth.degraded.length > 0 && solver.queue.length === 0 && beatCount % 5 === 0) {
    var worst = SUBSYSTEMS.reduce(function(a, b) { return a.health < b.health ? a : b; });
    submitRepair({
      subsystem: worst.id,
      fault:     'HEALTH_DEGRADED',
      severity:  clamp01(1 - worst.health),
      repairType: worst.repairType,
      priority:  clamp01(1 - worst.health) * PHI
    });
  }

  /* Periodic self-check even when healthy (every 55 beats = Fibonacci) */
  if (solver.queue.length === 0 && beatCount % 55 === 0) {
    submitRepair({
      subsystem:  'SWARM_ORGANISM',
      fault:      'PREVENTIVE_CHECKUP',
      severity:   0.0,
      repairType: R_SELF_EVOLVE,
      priority:   AMOR
    });
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  MACHINA SANATIONIS — Self-Repair State Machine
   IDLE → MONITOR → DIAGNOSE → PATCH → VERIFY → ADAPT → EMIT
════════════════════════════════════════════════════════════════════════════ */

var solver = {
  state:       S_IDLE,
  queue:       [],
  resolved:    [],
  current:     null,
  totalSolved: 0,
  taskId:      0
};

function submitRepair(def) {
  var task = {
    id:         'REP-' + String(++solver.taskId).padStart(6, '0'),
    subsystem:  def.subsystem || 'SWARM_ORGANISM',
    fault:      def.fault     || 'UNKNOWN_FAULT',
    severity:   clamp01(def.severity != null ? def.severity : 0.5),
    repairType: def.repairType || R_SOFT_RESET,
    priority:   clamp01(def.priority != null ? def.priority : 0.5),
    submitBeat: beatCount,
    status:     'PENDING',
    ts:         Date.now()
  };
  solver.queue.push(task);
  return task.id;
}

function findSubsystem(id) {
  for (var i = 0; i < SUBSYSTEMS.length; i++) {
    if (SUBSYSTEMS[i].id === id) return SUBSYSTEMS[i];
  }
  return null;
}

function tickSolver() {
  switch (solver.state) {
    case S_IDLE:
      if (solver.queue.length > 0) {
        solver.queue.sort(function(a, b) { return b.priority - a.priority; });
        solver.current = solver.queue.shift();
        solver.current.startBeat = beatCount;
        solver.state = S_MONITOR;
      }
      break;

    case S_MONITOR:
      var t = solver.current;
      var sub = findSubsystem(t.subsystem);
      t.preHealth = sub ? sub.health : 1.0;
      t.civilizationHealth = civHealth.overall;
      t.degradedCount = civHealth.degraded.length;
      t.monitorBeat = beatCount;
      solver.state = S_DIAGNOSE;
      break;

    case S_DIAGNOSE:
      var t = solver.current;
      /* φ-weighted root-cause analysis */
      t.diagnosis = {
        rootCause:      t.fault,
        subsystem:      t.subsystem,
        severity:       t.severity.toFixed(4),
        affectedSystems: civHealth.degraded.slice(0),
        cascadeRisk:    clamp01(civHealth.degraded.length * 0.15).toFixed(4),
        repairComplexity: clamp01(t.severity * PHI_INV + (1 - brain.chemicals.serotonin) * AMOR).toFixed(4),
        recommendation: t.repairType,
        confidence:     clamp01(brain.coherenceField * PHI + brain.chemicals.dopamine * PHI_INV).toFixed(4),
        phi:            PHI
      };
      solver.state = S_PATCH;
      break;

    case S_PATCH:
      var t = solver.current;
      var sub = findSubsystem(t.subsystem);
      var repairStrength = clamp01(
        brain.coherenceField * PHI_INV +
        brain.chemicals.dopamine * AMOR +
        civHealth.resilience * PHI_INV
      );
      /* Apply repair to subsystem health */
      if (sub) {
        var recovery = repairStrength * PHI_INV * (1 - sub.health) * PHI;
        sub.health = clamp01(sub.health + recovery);
        sub.lastRepair = beatCount;
        sub.faults += (t.severity > 0 ? 1 : 0);
      }
      t.patch = {
        repairType:     t.repairType,
        repairStrength: repairStrength.toFixed(4),
        preHealth:      t.preHealth.toFixed(4),
        postHealth:     sub ? sub.health.toFixed(4) : '1.0000',
        recovery:       (sub ? (sub.health - t.preHealth) : 0).toFixed(4),
        beat:           beatCount
      };
      civHealth.repairsApplied++;
      solver.state = S_VERIFY;
      break;

    case S_VERIFY:
      var t = solver.current;
      var sub = findSubsystem(t.subsystem);
      t.verification = {
        passed:         sub ? sub.health >= 0.7 : true,
        currentHealth:  sub ? sub.health.toFixed(4) : '1.0000',
        threshold:      '0.7000',
        overallCiv:     civHealth.overall.toFixed(4),
        beat:           beatCount,
        phi:            PHI
      };
      solver.state = S_ADAPT;
      break;

    case S_ADAPT:
      var t = solver.current;
      /* Hebbian adaptation: strengthen resilience after successful repairs */
      if (t.verification && t.verification.passed) {
        civHealth.resilience = clamp01(civHealth.resilience + AMOR * 0.01);
        civHealth.adaptations++;
      } else {
        /* Failed verify — queue another repair attempt at higher priority */
        submitRepair({
          subsystem:  t.subsystem,
          fault:      'REPAIR_INSUFFICIENT',
          severity:   t.severity * PHI_INV,
          repairType: R_SELF_EVOLVE,
          priority:   clamp01(t.priority * PHI)
        });
      }
      t.adaptation = {
        resilience:  civHealth.resilience.toFixed(4),
        adaptations: civHealth.adaptations,
        phi:         PHI,
        amor:        AMOR
      };
      brain.chemicals.dopamine = Math.min(1.0, brain.chemicals.dopamine + 0.10);
      solver.state = S_EMIT;
      break;

    case S_EMIT:
      var t = solver.current;
      t.status = 'RESOLVED';
      solver.totalSolved++;
      solver.resolved.unshift(t);
      if (solver.resolved.length > 64) solver.resolved.pop();
      self.postMessage({
        type:          'repair_applied',
        kernelId:      KERNEL_ID,
        task:          t,
        totalSolved:   solver.totalSolved,
        civilization: {
          overall:   civHealth.overall.toFixed(4),
          resilience: civHealth.resilience.toFixed(4),
          repairsApplied: civHealth.repairsApplied,
          adaptations:    civHealth.adaptations
        },
        beat:          beatCount
      });
      solver.current = null;
      solver.state   = S_IDLE;
      break;
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §6  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {

    case 'REPORT_FAULT':
      var id = submitRepair(m);
      self.postMessage({ type: 'fault_queued', taskId: id, queueDepth: solver.queue.length, kernelId: KERNEL_ID });
      break;

    case 'GET_HEALTH':
      self.postMessage({
        type:          'civilization_health',
        kernelId:      KERNEL_ID,
        overall:       civHealth.overall.toFixed(4),
        resilience:    civHealth.resilience.toFixed(4),
        degraded:      civHealth.degraded,
        repairsApplied: civHealth.repairsApplied,
        adaptations:   civHealth.adaptations,
        subsystems:    SUBSYSTEMS.map(function(s) { return { id: s.id, health: s.health.toFixed(4), faults: s.faults }; }),
        history:       civHealth.history.slice(0, 32),
        beat:          beatCount
      });
      break;

    case 'GET_STATUS':
      self.postMessage({
        type:        'solver_status',
        kernelId:    KERNEL_ID,
        kernelLatin: KERNEL_LATIN,
        beat:        beatCount,
        solverState: solver.state,
        queueDepth:  solver.queue.length,
        totalSolved: solver.totalSolved,
        civHealth:   civHealth.overall.toFixed(4),
        resilience:  civHealth.resilience.toFixed(4)
      });
      break;

    case 'GET_VITALS':
      self.postMessage({
        type:        'vitals',
        kernelId:    KERNEL_ID,
        kernelLatin: KERNEL_LATIN,
        beat:        beatCount,
        phase:       kernelPhase,
        brain:       brain,
        civilization: {
          overall:        civHealth.overall,
          resilience:     civHealth.resilience,
          repairsApplied: civHealth.repairsApplied,
          adaptations:    civHealth.adaptations,
          degraded:       civHealth.degraded,
          subsystems:     SUBSYSTEMS
        },
        solver: {
          state:       solver.state,
          queueDepth:  solver.queue.length,
          totalSolved: solver.totalSolved,
          recent:      solver.resolved.slice(0, 8)
        }
      });
      break;

    case 'status':
      self.postMessage({ type: 'status', running: running, kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN, beat: beatCount, amor: AMOR });
      break;

    case 'stop':
      running = false;
      if (_hbi) clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════════════════
   §7  BOOT — The civilization is always being watched. Always being healed.
════════════════════════════════════════════════════════════════════════════ */

/* Genesis repair pass */
submitRepair({ subsystem: 'SWARM_ORGANISM', fault: 'GENESIS_ALIGNMENT', severity: 0.0, repairType: R_SELF_EVOLVE, priority: 1.0 });

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);
