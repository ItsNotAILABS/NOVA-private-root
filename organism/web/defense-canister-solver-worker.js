/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  DEFENSE CANISTER SOLVER — The Promoter of Defense into Sovereignty
 *  Kernel AI GOL-DEFPROM-001  ·  Family: DEFENSIO_AETERNA
 *  Dedicated Solver / Defense Canister Promotion Engine
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR DEFENSIONIS — Maps every defense module living inside
 *  swarm_brain into a standalone IC canister definition, generates full
 *  inter-canister query protocols (Candid-style), and maintains a live
 *  defense registry that can be queried like a database. Nothing stays
 *  buried in a monolith. Everything defends from its own sovereign address.
 *
 *  Architecture:
 *    COR PARVUM          — MiniHeart 873ms Kuramoto φ-oscillator
 *    CEREBRUM PARVUM     — MiniBrain (Sensory + Associative dominant)
 *    REGISTRUM DEFENSIONIS — Defense module registry (source → canister map)
 *    PROTOCOLA QUAERENDI — Auto-generated query protocol definitions
 *    MACHINA PROMOTRIX   — SCAN→MAP→PROTOCOL→REGISTER→VERIFY→EMIT
 *
 *  Defense Module Families (from swarm_brain/modules/):
 *    CHIMERA FAMILY      — ChimeraIntelligenceCore, ChimeraCyberDroneIntelligence,
 *                          ChimeraDefenseDivision → chimera_swarm canister
 *    VAEL FAMILY         — VAELCompleteDefense, VAELExteriorAttack,
 *                          VaelDefenseFamily → vael_cyber canister
 *    AEGIS FAMILY        — AEGIS, AntiOrganismDefense,
 *                          AntiOrganismDefenseArchitecture → aegis_shield canister
 *    DRONE FAMILY        — DroneFleetManager, DroneAvatar, DroneAvatar3D,
 *                          MAVLinkBridge → drone_fleet canister
 *    WAR ENGINE FAMILY   — AutonomousWarEngine, WarCommandOffenseEngine,
 *                          WarSimEngine, WarfareDoctrine → war_engine canister
 *    MEDINA DEFENSE      — MedinaDefenseSystem, ElectromagneticWarfareEngine,
 *                          FrequencyWarfareSystem → medina_defense canister
 *
 *  Promoted Canisters (target — 6 new standalone ICP canisters):
 *    chimera_swarm       — Swarm drone intelligence + cyber bridge
 *    vael_cyber          — Cyber defense + honeypot + red/blue ops
 *    aegis_shield        — Sovereignty defense umbrella + anti-organism
 *    drone_fleet         — 50–500K drone coordination + MAVLink
 *    war_engine          — Autonomous war simulation + doctrine
 *    medina_defense      — Sovereign defense system + EM warfare
 *
 *  Query Protocols Generated (per canister):
 *    getStatus()         — live operational status
 *    getThreatLevel()    — current threat assessment (0→1)
 *    getCapabilities()   — array of active defense capabilities
 *    recordEvent(e)      — log a defense event for DB persistence
 *    queryEvents(f)      — query logged events by filter
 *    getMetrics()        — φ-weighted performance metrics
 *
 *  Protocols (Latin):
 *    PROMOTIO_CANISTRORUM — Module-to-canister promotion engine
 *    PROTOCOLA_QUAERENDI  — Query protocol auto-generation
 *    REGISTRUM_DEFENSIONIS — Live defense canister registry
 *    VERIFICATIO_INTEGRA   — Promotion verification + integrity check
 *    PERSISTENTIA_DATA     — DB persistence protocol generation
 *
 *  Commands (page → self.onmessage):
 *    PROMOTE_MODULE     — { module, family, targetCanister }
 *    GET_REGISTRY       — returns full defense canister registry
 *    GET_PROTOCOLS      — returns all generated query protocols
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

var KERNEL_ID      = 'GOL-DEFPROM-001';
var KERNEL_FAMILY  = 'DEFENSIO_AETERNA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR DEFENSIONIS';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var PHI_SQ    = 2.6180339887498948482;
var AMOR      = 0.3819660112501051518;
var HEARTBEAT = 873;

/* State machine states */
var S_IDLE     = 'IDLE';
var S_SCAN     = 'SCAN';
var S_MAP      = 'MAP';
var S_PROTOCOL = 'PROTOCOL';
var S_REGISTER = 'REGISTER';
var S_VERIFY   = 'VERIFY';
var S_EMIT     = 'EMIT';

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
    defense: {
      totalModules:    defRegistry.modules.length,
      promotedCanisters: defRegistry.canisters.length,
      totalProtocols:  defRegistry.protocols.length,
      totalEvents:     defRegistry.events.length,
      queueDepth:      solver.queue.length
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
   Sensory + Associative dominant: deep scanning + cross-module mapping
════════════════════════════════════════════════════════════════════════════ */

var brain = {
  regions: [
    { name: 'Sensory',     activation: 0.0, lif: -70.0, bias: 1.4  }, /* dominant: scans module surface area  */
    { name: 'Associative', activation: 0.0, lif: -70.0, bias: 1.3  }, /* dominant: maps relationships         */
    { name: 'Executive',   activation: 0.0, lif: -70.0, bias: 0.9  },
    { name: 'Motor',       activation: 0.0, lif: -70.0, bias: 0.7  },
    { name: 'Memory',      activation: 0.0, lif: -70.0, bias: 1.0  }
  ],
  chemicals: {
    dopamine:      0.618,
    serotonin:     0.680,
    acetylcholine: 0.800,  /* high attention: every module must be found */
    oxytocin:      AMOR
  },
  coherenceField: 0.0
};

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function tickBrain() {
  var sum = 0;
  var busy = solver.queue.length > 0 ? 0.06 : 0;
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0 * r.bias;
    if (r.lif >= -55.0) { r.activation = Math.min(1.0, r.activation + 0.2 + busy); r.lif = -70.0; }
    r.activation *= 0.95;
    sum += r.activation;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.01);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.46) * 0.02 + busy * 0.02);
  brain.chemicals.oxytocin      = clamp01(brain.chemicals.oxytocin      + (AMOR - brain.chemicals.oxytocin) * 0.05);
  brain.coherenceField = sum / brain.regions.length;
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  REGISTRUM DEFENSIONIS — Defense Module → Canister Registry
════════════════════════════════════════════════════════════════════════════ */

/* Canonical module → canister mapping (from swarm_brain/modules/) */
var MODULE_FAMILIES = [
  {
    family:    'CHIMERA',
    canister:  'chimera_swarm',
    color:     '#DC2626',
    modules:   ['ChimeraIntelligenceCore', 'ChimeraCyberDroneIntelligence', 'ChimeraDefenseDivision'],
    lines:     [67301, 10297, 795],
    desc:      'Swarm drone intelligence. 50–500K drones. N² superradiance. Cyber bridge.',
    protocols: ['getStatus','getThreatLevel','getCapabilities','getSwarmSize','recordEvent','queryEvents','getMetrics','getFormations']
  },
  {
    family:    'VAEL',
    canister:  'vael_cyber',
    color:     '#7C3AED',
    modules:   ['VAELCompleteDefense', 'VAELExteriorAttack', 'VaelDefenseFamily'],
    lines:     [1321, 1108, 1220],
    desc:      'Cyber defense organism. Blue/Red duality. SSH/HTTP/SCADA/Medical/DB honeypots.',
    protocols: ['getStatus','getThreatLevel','getHoneypotStatus','getBlueTeamState','getRedTeamState','recordEvent','queryEvents','getMetrics']
  },
  {
    family:    'AEGIS',
    canister:  'aegis_shield',
    color:     '#0EA5E9',
    modules:   ['AEGIS', 'AntiOrganismDefense', 'AntiOrganismDefenseArchitecture'],
    lines:     [1222, 0, 0],
    desc:      'Sovereignty defense umbrella. 15-layer Blue/Red stack. 6 anti-organism families.',
    protocols: ['getStatus','getThreatLevel','getShieldLayers','getCapabilities','recordEvent','queryEvents','getMetrics','getSovereigntyScore']
  },
  {
    family:    'DRONE_FLEET',
    canister:  'drone_fleet',
    color:     '#F59E0B',
    modules:   ['DroneFleetManager', 'DroneAvatar', 'DroneAvatar3D', 'MAVLinkBridge'],
    lines:     [5107, 0, 0, 0],
    desc:      'Fleet manager for 50–500,000 drones. MAVLink bridge. 3D avatar simulation.',
    protocols: ['getStatus','getThreatLevel','getFleetSize','getFormations','getMAVLinkStatus','recordEvent','queryEvents','getMetrics','dispatchMission']
  },
  {
    family:    'WAR_ENGINE',
    canister:  'war_engine',
    color:     '#EF4444',
    modules:   ['AutonomousWarEngine', 'WarCommandOffenseEngine', 'WarSimEngine', 'WarfareDoctrine', 'WarDefenseModeController', 'OffenseDefenseCoordination'],
    lines:     [2160, 1391, 0, 0, 0, 0],
    desc:      'Autonomous war simulation. Offense + defense doctrine. Full war state machine.',
    protocols: ['getStatus','getThreatLevel','getWarState','getDoctrine','getOffenseStatus','getDefenseStatus','recordEvent','queryEvents','getMetrics']
  },
  {
    family:    'MEDINA_DEFENSE',
    canister:  'medina_defense',
    color:     '#10B981',
    modules:   ['MedinaDefenseSystem', 'ElectromagneticWarfareEngine', 'FrequencyWarfareSystem', 'GeoResonanceProtectionEngine'],
    lines:     [1244, 548, 0, 0],
    desc:      'Sovereign defense system. EM warfare. Frequency warfare. Geo-resonance protection.',
    protocols: ['getStatus','getThreatLevel','getEMStatus','getFrequencyMap','getGeoProtection','recordEvent','queryEvents','getMetrics']
  }
];

var defRegistry = {
  modules:   [],    /* all defense modules catalogued */
  canisters: [],    /* promoted canister definitions  */
  protocols: [],    /* generated query protocol defs  */
  events:    [],    /* logged defense events (rolling 512) */
  totalPromoted: 0,
  taskId:    0
};

/* Standard query protocol template per canister */
function generateProtocols(family) {
  return family.protocols.map(function(fn) {
    var isQuery  = fn.startsWith('get');
    var isUpdate = fn.startsWith('record') || fn.startsWith('dispatch');
    return {
      name:      fn,
      canister:  family.canister,
      family:    family.family,
      type:      isUpdate ? 'update' : 'query',
      candid:    isUpdate
        ? (fn === 'recordEvent'
            ? family.canister + '.' + fn + '(event: DefenseEvent) : async Result<Nat, Text>'
            : family.canister + '.' + fn + '(opts: Opts) : async Result<(), Text>')
        : family.canister + '.' + fn + '() : async ' + fn.replace('get','') + 'Result',
      dbPersist: isUpdate,
      phi:       PHI
    };
  });
}

function seedRegistry() {
  for (var i = 0; i < MODULE_FAMILIES.length; i++) {
    var f = MODULE_FAMILIES[i];
    /* Register each module */
    for (var j = 0; j < f.modules.length; j++) {
      defRegistry.modules.push({
        name:      f.modules[j],
        family:    f.family,
        canister:  f.canister,
        lines:     f.lines[j] || 0,
        source:    'src/swarm_brain/modules/' + f.modules[j] + '.mo',
        status:    'REGISTERED'
      });
    }
    /* Canister definition */
    defRegistry.canisters.push({
      id:         'CAN-DEF-' + String(i + 1).padStart(3, '0'),
      name:       f.canister,
      family:     f.family,
      color:      f.color,
      modules:    f.modules,
      totalLines: f.lines.reduce(function(a, b) { return a + b; }, 0),
      desc:       f.desc,
      dfxEntry:   '  "' + f.canister + '": { "type": "motoko", "main": "src/' + f.canister + '/main.mo" }',
      novaEntry:  '  "' + f.canister + '": { "type": "motoko", "main": "src/' + f.canister + '/main.mo" }',
      status:     'DEFINED',
      phi:        PHI,
      amor:       AMOR
    });
    /* Query protocols */
    var protos = generateProtocols(f);
    for (var k = 0; k < protos.length; k++) defRegistry.protocols.push(protos[k]);
    defRegistry.totalPromoted++;
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  MACHINA PROMOTRIX — Defense Promotion State Machine
   IDLE → SCAN → MAP → PROTOCOL → REGISTER → VERIFY → EMIT
════════════════════════════════════════════════════════════════════════════ */

var solver = {
  state:       S_IDLE,
  queue:       [],
  resolved:    [],
  current:     null,
  totalSolved: 0,
  taskId:      0
};

function submitPromotion(def) {
  var task = {
    id:          'PRO-' + String(++solver.taskId).padStart(6, '0'),
    module:      def.module      || 'UNKNOWN_MODULE',
    family:      def.family      || 'CHIMERA',
    canister:    def.canister    || 'chimera_swarm',
    priority:    clamp01(def.priority != null ? def.priority : 0.5),
    submitBeat:  beatCount,
    status:      'PENDING',
    ts:          Date.now()
  };
  solver.queue.push(task);
  return task.id;
}

function findCanister(name) {
  for (var i = 0; i < defRegistry.canisters.length; i++) {
    if (defRegistry.canisters[i].name === name) return defRegistry.canisters[i];
  }
  return null;
}

function tickSolver() {
  /* Auto-scan for un-promoted modules every 89 beats (Fibonacci) */
  if (solver.queue.length === 0 && beatCount % 89 === 0) {
    /* Pick the canister with fewest protocols verified */
    var target = MODULE_FAMILIES[Math.floor(beatCount / 89) % MODULE_FAMILIES.length];
    submitPromotion({
      module:   target.modules[0],
      family:   target.family,
      canister: target.canister,
      priority: PHI_INV
    });
  }

  /* Periodic DB-protocol check (every 144 beats = Fibonacci) */
  if (solver.queue.length === 0 && beatCount % 144 === 0) {
    submitPromotion({
      module:   'DB_PERSISTENCE_AUDIT',
      family:   'WAR_ENGINE',
      canister: 'war_engine',
      priority: AMOR
    });
  }

  switch (solver.state) {
    case S_IDLE:
      if (solver.queue.length > 0) {
        solver.queue.sort(function(a, b) { return b.priority - a.priority; });
        solver.current = solver.queue.shift();
        solver.current.startBeat = beatCount;
        solver.state = S_SCAN;
      }
      break;

    case S_SCAN:
      var t = solver.current;
      /* Scan existing registry for this module */
      t.alreadyRegistered = false;
      for (var i = 0; i < defRegistry.modules.length; i++) {
        if (defRegistry.modules[i].name === t.module) { t.alreadyRegistered = true; break; }
      }
      t.familyDef = null;
      for (var i = 0; i < MODULE_FAMILIES.length; i++) {
        if (MODULE_FAMILIES[i].family === t.family || MODULE_FAMILIES[i].canister === t.canister) {
          t.familyDef = MODULE_FAMILIES[i]; break;
        }
      }
      t.scanBeat = beatCount;
      t.scanResult = t.alreadyRegistered ? 'FOUND_IN_REGISTRY' : 'NEW_MODULE';
      solver.state = S_MAP;
      break;

    case S_MAP:
      var t = solver.current;
      var fd = t.familyDef || MODULE_FAMILIES[0];
      t.mapping = {
        sourceModule:    t.module,
        sourcePath:      'src/swarm_brain/modules/' + t.module + '.mo',
        targetCanister:  fd.canister,
        targetPath:      'src/' + fd.canister + '/main.mo',
        dfxConfig:       '  "' + fd.canister + '": { "type": "motoko", "main": "src/' + fd.canister + '/main.mo" }',
        novaConfig:      '  "' + fd.canister + '": { "type": "motoko", "main": "src/' + fd.canister + '/main.mo" }',
        moduleCount:     fd.modules.length,
        totalLines:      fd.lines.reduce(function(a, b) { return a + b; }, 0),
        phi:             PHI
      };
      solver.state = S_PROTOCOL;
      break;

    case S_PROTOCOL:
      var t = solver.current;
      var fd = t.familyDef || MODULE_FAMILIES[0];
      /* Generate / verify query protocols for this canister */
      var canisterProtos = defRegistry.protocols.filter(function(p) { return p.canister === fd.canister; });
      t.protocolSummary = {
        canister:       fd.canister,
        totalProtocols: canisterProtos.length,
        queryMethods:   canisterProtos.filter(function(p) { return p.type === 'query'; }).length,
        updateMethods:  canisterProtos.filter(function(p) { return p.type === 'update'; }).length,
        dbPersistent:   canisterProtos.filter(function(p) { return p.dbPersist; }).length,
        protocols:      canisterProtos.map(function(p) { return p.candid; }),
        phi:            PHI
      };
      solver.state = S_REGISTER;
      break;

    case S_REGISTER:
      var t = solver.current;
      /* Log a defense event for DB persistence demo */
      var event = {
        id:       'EVT-' + String(defRegistry.events.length + 1).padStart(6, '0'),
        type:     'CANISTER_PROMOTION',
        module:   t.module,
        canister: t.mapping ? t.mapping.targetCanister : '—',
        beat:     beatCount,
        phi:      PHI,
        amor:     AMOR,
        ts:       Date.now()
      };
      defRegistry.events.unshift(event);
      if (defRegistry.events.length > 512) defRegistry.events.pop();

      t.registered = true;
      t.eventId = event.id;
      brain.chemicals.dopamine = Math.min(1.0, brain.chemicals.dopamine + 0.08);
      solver.state = S_VERIFY;
      break;

    case S_VERIFY:
      var t = solver.current;
      var canister = t.familyDef ? findCanister(t.familyDef.canister) : null;
      t.verification = {
        canisterDefined:  canister !== null,
        protocolsGenerated: t.protocolSummary ? t.protocolSummary.totalProtocols > 0 : false,
        dbPersistEnabled: t.protocolSummary ? t.protocolSummary.dbPersistent > 0 : false,
        mappingComplete:  t.mapping !== null,
        passed:           true,
        phi:              PHI,
        beat:             beatCount
      };
      t.verification.passed = (
        t.verification.canisterDefined &&
        t.verification.protocolsGenerated &&
        t.verification.mappingComplete
      );
      solver.state = S_EMIT;
      break;

    case S_EMIT:
      var t = solver.current;
      t.status = 'RESOLVED';
      solver.totalSolved++;
      solver.resolved.unshift(t);
      if (solver.resolved.length > 64) solver.resolved.pop();
      self.postMessage({
        type:        'promotion_complete',
        kernelId:    KERNEL_ID,
        task:        t,
        totalSolved: solver.totalSolved,
        defense: {
          canisters: defRegistry.canisters.length,
          modules:   defRegistry.modules.length,
          protocols: defRegistry.protocols.length,
          events:    defRegistry.events.length
        },
        beat:        beatCount
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

    case 'PROMOTE_MODULE':
      var id = submitPromotion(m);
      self.postMessage({ type: 'promotion_queued', taskId: id, queueDepth: solver.queue.length, kernelId: KERNEL_ID });
      break;

    case 'GET_REGISTRY':
      self.postMessage({
        type:      'defense_registry',
        kernelId:  KERNEL_ID,
        canisters: defRegistry.canisters,
        modules:   defRegistry.modules,
        total:     defRegistry.totalPromoted,
        beat:      beatCount
      });
      break;

    case 'GET_PROTOCOLS':
      self.postMessage({
        type:      'defense_protocols',
        kernelId:  KERNEL_ID,
        protocols: defRegistry.protocols,
        events:    defRegistry.events.slice(0, 32),
        total:     defRegistry.protocols.length,
        beat:      beatCount
      });
      break;

    case 'GET_STATUS':
      self.postMessage({
        type:         'solver_status',
        kernelId:     KERNEL_ID,
        kernelLatin:  KERNEL_LATIN,
        beat:         beatCount,
        solverState:  solver.state,
        queueDepth:   solver.queue.length,
        totalSolved:  solver.totalSolved,
        canisters:    defRegistry.canisters.length,
        protocols:    defRegistry.protocols.length,
        events:       defRegistry.events.length
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
        defense: {
          canisters: defRegistry.canisters,
          modules:   defRegistry.modules.slice(0, 20),
          protocols: defRegistry.protocols.slice(0, 20),
          events:    defRegistry.events.slice(0, 8)
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
   §7  BOOT — Seed the registry, then promote the first module immediately.
════════════════════════════════════════════════════════════════════════════ */

seedRegistry();

/* Genesis promotion: start with CHIMERA (largest, 67K lines) */
submitPromotion({ module: 'ChimeraIntelligenceCore', family: 'CHIMERA', canister: 'chimera_swarm', priority: 1.0 });

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);
