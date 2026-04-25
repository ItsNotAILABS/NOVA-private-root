/**
 * ============================================================================
 *  BUILDINGS WORKER — AEDIFICIUM OPERATIONUM
 *  Kernel AI GOK-BUILDINGS-001  ·  Family: BUILDINGS_ORGANISM
 * ============================================================================
 *
 *  Enterprise buildings where AIs deploy from and manage workflows. Each
 *  building is a structural business unit with floors, rooms, workers, and
 *  workflow pipelines — like real office buildings but for AI operations.
 *
 *  12 Buildings:
 *    HQ              — Executive command, strategy, governance
 *    ENGINEERING      — Core development, code synthesis, architecture
 *    DATA_CENTER      — Storage, compute, data pipelines, ETL
 *    RESEARCH_LAB     — R&D, experiments, innovation, papers
 *    SECURITY_FORTRESS— Defense, threat detection, compliance, audit
 *    OPERATIONS       — DevOps, deployment, monitoring, SRE
 *    ANALYTICS_TOWER  — BI, reporting, metrics, dashboards
 *    COMMERCE_HUB     — Sales, marketplace, payments, billing
 *    TRAINING_ACADEMY — Learning, certification, skill development
 *    COMMUNICATIONS   — Messaging, notifications, external APIs
 *    LEGAL_OFFICE     — Contracts, compliance, IP, regulatory
 *    INNOVATION_LAB   — Prototyping, incubation, moonshots
 *
 *  Workflow Lifecycle:
 *    QUEUED → ASSIGNED → IN_PROGRESS → REVIEW → COMPLETE
 *
 *  MiniHeart  — 873 ms Kuramoto pulse, φ-phase advance
 *  MiniBrain  — 5 regions, 3 chemicals, LIF membrane model
 *
 *  Commands:
 *    CREATE_WORKFLOW   — submit a new workflow to a building
 *    ASSIGN_WORKER     — assign an AI worker to a workflow
 *    ADVANCE_WORKFLOW  — advance workflow to next stage
 *    GET_BUILDINGS     — list all buildings and status
 *    GET_BUILDING      — details of a specific building (floors/rooms)
 *    GET_WORKFLOWS     — list workflows (optionally filter by building)
 *    GET_OCCUPANCY     — campus-wide occupancy report
 *    GET_CAMPUS_MAP    — full campus topology
 *    GET_VITALS        — MiniHeart + MiniBrain + campus vitals
 *    status            — kernel status
 *    stop              — graceful shutdown
 *
 *  Zero external dependencies.
 * ============================================================================
 */

/* ── §1  CONSTANTS ──────────────────────────────────────────────────────── */

var KERNEL_ID      = 'GOK-BUILDINGS-001';
var KERNEL_FAMILY  = 'BUILDINGS_ORGANISM';
var KERNEL_VERSION = '1.0.0';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var PHI_SQ    = 2.6180339887498948482;
var SQRT5     = 2.2360679774997896964;
var HEARTBEAT = 873;

/* ── §2  MINI-HEART ─────────────────────────────────────────────────────── */

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  tickWorkflows();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    phase:       kernelPhase,
    buildings:   buildings.length,
    activeWorkflows: workflows.filter(function(w) { return w.status !== 'COMPLETE'; }).length,
    totalWorkers: getTotalWorkers()
  });
}

/* ── §3  MINI-BRAIN ─────────────────────────────────────────────────────── */

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0 },
    { name: 'Associative',  activation: 0.0, lif: -70.0 },
    { name: 'Executive',    activation: 0.0, lif: -70.0 },
    { name: 'Motor',        activation: 0.0, lif: -70.0 },
    { name: 'Memory',       activation: 0.0, lif: -70.0 }
  ],
  chemicals: {
    dopamine:      0.5,
    serotonin:     0.5,
    acetylcholine: 0.5
  },
  coherenceField: 0.0
};

function tickBrain() {
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += ((-70.0 - r.lif) * 0.05) + (Math.random() * 3.0);
    if (r.lif >= -55.0) {
      r.activation = Math.min(1.0, r.activation + 0.2);
      r.lif = -70.0;
    }
    r.activation *= 0.95;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  var sum = 0;
  for (var j = 0; j < brain.regions.length; j++) sum += brain.regions[j].activation;
  brain.coherenceField = sum / brain.regions.length;
}

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

/* ── §4  BUILDING DEFINITIONS ───────────────────────────────────────────── */

var buildings = [];

(function initBuildings() {
  var defs = [
    {
      code: 'HQ', name: 'Headquarters', floors: 5,
      departments: ['Executive', 'Strategy', 'Governance', 'Board Room'],
      capacity: 50, desc: 'Central command and executive decision-making'
    },
    {
      code: 'ENGINEERING', name: 'Engineering Tower', floors: 10,
      departments: ['Frontend', 'Backend', 'Infrastructure', 'Architecture', 'QA'],
      capacity: 120, desc: 'Core software development and code synthesis'
    },
    {
      code: 'DATA_CENTER', name: 'Data Center', floors: 3,
      departments: ['Storage', 'Compute', 'Pipelines', 'ETL'],
      capacity: 40, desc: 'Data processing, storage, and compute infrastructure'
    },
    {
      code: 'RESEARCH_LAB', name: 'Research Laboratory', floors: 4,
      departments: ['AI Research', 'Quantum Lab', 'Neuroscience', 'Publications'],
      capacity: 35, desc: 'R&D, experimental protocols, and academic output'
    },
    {
      code: 'SECURITY_FORTRESS', name: 'Security Fortress', floors: 3,
      departments: ['Threat Intel', 'Incident Response', 'Compliance', 'Audit'],
      capacity: 30, desc: 'Defense, threat detection, and compliance enforcement'
    },
    {
      code: 'OPERATIONS', name: 'Operations Center', floors: 4,
      departments: ['DevOps', 'SRE', 'Monitoring', 'Deployment'],
      capacity: 45, desc: 'Infrastructure operations, deployment, and SRE'
    },
    {
      code: 'ANALYTICS_TOWER', name: 'Analytics Tower', floors: 6,
      departments: ['BI', 'Reporting', 'Metrics', 'Dashboards', 'Forecasting'],
      capacity: 55, desc: 'Business intelligence, analytics, and reporting'
    },
    {
      code: 'COMMERCE_HUB', name: 'Commerce Hub', floors: 4,
      departments: ['Sales', 'Marketplace', 'Payments', 'Billing'],
      capacity: 40, desc: 'Revenue operations, marketplace, and transactions'
    },
    {
      code: 'TRAINING_ACADEMY', name: 'Training Academy', floors: 5,
      departments: ['Courses', 'Certification', 'Mentorship', 'Skills Lab', 'Assessment'],
      capacity: 60, desc: 'AI/AGI training, skill development, and certification'
    },
    {
      code: 'COMMUNICATIONS', name: 'Communications Center', floors: 3,
      departments: ['Messaging', 'Notifications', 'External APIs', 'Broadcast'],
      capacity: 25, desc: 'Internal and external communications infrastructure'
    },
    {
      code: 'LEGAL_OFFICE', name: 'Legal Office', floors: 2,
      departments: ['Contracts', 'IP', 'Regulatory', 'Ethics'],
      capacity: 20, desc: 'Legal, contracts, intellectual property, and ethics'
    },
    {
      code: 'INNOVATION_LAB', name: 'Innovation Lab', floors: 3,
      departments: ['Prototyping', 'Incubator', 'Moonshots'],
      capacity: 30, desc: 'Rapid prototyping, experimental projects, and moonshots'
    }
  ];

  for (var i = 0; i < defs.length; i++) {
    var d = defs[i];
    var floorList = [];
    for (var f = 1; f <= d.floors; f++) {
      var rooms = [];
      /* each floor gets rooms based on departments */
      var deptIdx = (f - 1) % d.departments.length;
      rooms.push({
        id: d.code + '-F' + f + '-R1',
        name: d.departments[deptIdx] + ' Main',
        type: 'WORKSPACE',
        capacity: Math.floor(d.capacity / d.floors * PHI_INV),
        occupants: 0
      });
      rooms.push({
        id: d.code + '-F' + f + '-R2',
        name: d.departments[deptIdx] + ' Meeting',
        type: 'MEETING',
        capacity: 8,
        occupants: 0
      });
      rooms.push({
        id: d.code + '-F' + f + '-R3',
        name: 'Server Room ' + f,
        type: 'SERVER',
        capacity: 0,
        occupants: 0
      });
      floorList.push({
        floor:  f,
        name:   'Floor ' + f + ' — ' + d.departments[deptIdx],
        rooms:  rooms
      });
    }

    buildings.push({
      id:          'BLD-' + String(i + 1).padStart(3, '0'),
      code:        d.code,
      name:        d.name,
      floors:      floorList,
      floorCount:  d.floors,
      departments: d.departments,
      capacity:    d.capacity,
      workers:     0,
      desc:        d.desc,
      status:      'OPERATIONAL',
      health:      1.0
    });
  }
})();

/* ── §5  WORKFLOW ENGINE ────────────────────────────────────────────────── */

var workflows = [];
var workflowId = 0;

var WORKFLOW_STAGES = ['QUEUED', 'ASSIGNED', 'IN_PROGRESS', 'REVIEW', 'COMPLETE'];

var WORKFLOW_TYPES = [
  'CODE_REVIEW',   'DEPLOYMENT',     'BUG_FIX',        'FEATURE_DEV',
  'SECURITY_SCAN', 'DATA_PIPELINE',  'MODEL_TRAINING',  'DOCUMENTATION',
  'TESTING',       'INFRASTRUCTURE', 'MONITORING',      'RESEARCH',
  'OPTIMIZATION',  'MIGRATION',      'INCIDENT_RESPONSE'
];

function createWorkflow(buildingCode, workflowType, priority, description) {
  var bld = buildings.find(function(b) { return b.code === buildingCode; });
  if (!bld) return { error: 'Building not found: ' + buildingCode };

  workflowId++;
  var wf = {
    id:           'WF-' + String(workflowId).padStart(5, '0'),
    buildingCode: buildingCode,
    buildingName: bld.name,
    type:         workflowType || 'FEATURE_DEV',
    priority:     priority || 'MEDIUM',
    description:  description || '',
    status:       'QUEUED',
    stageIndex:   0,
    assignedTo:   null,
    createdAt:    Date.now(),
    createdBeat:  beatCount,
    updatedAt:    Date.now(),
    completedAt:  null,
    history:      [{ event: 'CREATED', beat: beatCount, timestamp: Date.now() }]
  };
  workflows.push(wf);
  return wf;
}

function assignWorker(workflowIdStr, workerId) {
  var wf = workflows.find(function(w) { return w.id === workflowIdStr; });
  if (!wf) return { error: 'Workflow not found: ' + workflowIdStr };
  if (wf.status === 'COMPLETE') return { error: 'Workflow already complete' };

  wf.assignedTo = workerId || 'AUTO-' + Date.now().toString(36);
  wf.status     = 'ASSIGNED';
  wf.stageIndex = 1;
  wf.updatedAt  = Date.now();
  wf.history.push({ event: 'ASSIGNED', beat: beatCount, worker: wf.assignedTo });

  /* increment building worker count */
  var bld = buildings.find(function(b) { return b.code === wf.buildingCode; });
  if (bld && bld.workers < bld.capacity) bld.workers++;

  return { workflowId: wf.id, assignedTo: wf.assignedTo, building: wf.buildingCode };
}

function advanceWorkflow(workflowIdStr) {
  var wf = workflows.find(function(w) { return w.id === workflowIdStr; });
  if (!wf) return { error: 'Workflow not found: ' + workflowIdStr };
  if (wf.status === 'COMPLETE') return { error: 'Already complete' };

  if (wf.stageIndex < WORKFLOW_STAGES.length - 1) {
    wf.stageIndex++;
    wf.status    = WORKFLOW_STAGES[wf.stageIndex];
    wf.updatedAt = Date.now();
    wf.history.push({ event: 'ADVANCED', beat: beatCount, stage: wf.status });

    if (wf.status === 'COMPLETE') {
      wf.completedAt = Date.now();
      /* free worker from building */
      var bld = buildings.find(function(b) { return b.code === wf.buildingCode; });
      if (bld && bld.workers > 0) bld.workers--;
    }
  }
  return { workflowId: wf.id, status: wf.status, stage: wf.stageIndex };
}

/* ── §6  WORKFLOW AUTO-TICK ─────────────────────────────────────────────── */

function tickWorkflows() {
  /* auto-advance in-progress workflows probabilistically */
  for (var i = 0; i < workflows.length; i++) {
    var wf = workflows[i];
    if (wf.status === 'IN_PROGRESS' && Math.random() < 0.05 * PHI_INV) {
      advanceWorkflow(wf.id);
    }
    if (wf.status === 'REVIEW' && Math.random() < 0.08 * PHI_INV) {
      advanceWorkflow(wf.id);
    }
  }

  /* update building health based on workflow completion rate */
  for (var j = 0; j < buildings.length; j++) {
    var b = buildings[j];
    var bwf = workflows.filter(function(w) { return w.buildingCode === b.code; });
    var done = bwf.filter(function(w) { return w.status === 'COMPLETE'; }).length;
    var total = bwf.length;
    b.health = total > 0
      ? clamp01((done / total) * PHI_INV + (1 - b.workers / Math.max(1, b.capacity)) * (1 - PHI_INV))
      : 1.0;
  }
}

/* ── §7  OCCUPANCY & CAMPUS METRICS ─────────────────────────────────────── */

function getTotalWorkers() {
  var total = 0;
  for (var i = 0; i < buildings.length; i++) total += buildings[i].workers;
  return total;
}

function getTotalCapacity() {
  var total = 0;
  for (var i = 0; i < buildings.length; i++) total += buildings[i].capacity;
  return total;
}

function getOccupancyReport() {
  return buildings.map(function(b) {
    return {
      code:       b.code,
      name:       b.name,
      capacity:   b.capacity,
      workers:    b.workers,
      occupancy:  b.capacity > 0 ? b.workers / b.capacity : 0,
      health:     b.health,
      workflows:  workflows.filter(function(w) { return w.buildingCode === b.code && w.status !== 'COMPLETE'; }).length
    };
  });
}

function getCampusMap() {
  return {
    buildings:    buildings.length,
    totalFloors:  buildings.reduce(function(s, b) { return s + b.floorCount; }, 0),
    totalRooms:   buildings.reduce(function(s, b) {
      return s + b.floors.reduce(function(s2, f) { return s2 + f.rooms.length; }, 0);
    }, 0),
    totalCapacity:   getTotalCapacity(),
    totalWorkers:    getTotalWorkers(),
    campusOccupancy: getTotalCapacity() > 0 ? getTotalWorkers() / getTotalCapacity() : 0,
    activeWorkflows: workflows.filter(function(w) { return w.status !== 'COMPLETE'; }).length,
    completedWorkflows: workflows.filter(function(w) { return w.status === 'COMPLETE'; }).length,
    topology: buildings.map(function(b) {
      return {
        code:        b.code,
        name:        b.name,
        floors:      b.floorCount,
        departments: b.departments,
        status:      b.status
      };
    }),
    coherence: brain.coherenceField,
    phiCampusHealth: clamp01(
      buildings.reduce(function(s, b) { return s + b.health; }, 0) / buildings.length * PHI_INV +
      brain.coherenceField * (1 - PHI_INV)
    )
  };
}

/* ── §8  MESSAGE HANDLER ────────────────────────────────────────────────── */

self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {
    case 'CREATE_WORKFLOW': {
      var wf = createWorkflow(msg.buildingCode, msg.workflowType, msg.priority, msg.description);
      self.postMessage({ type: 'WORKFLOW_CREATED', result: wf, kernelId: KERNEL_ID });
      break;
    }
    case 'ASSIGN_WORKER': {
      var aw = assignWorker(msg.workflowId, msg.workerId);
      self.postMessage({ type: 'WORKER_ASSIGNED', result: aw, kernelId: KERNEL_ID });
      break;
    }
    case 'ADVANCE_WORKFLOW': {
      var adv = advanceWorkflow(msg.workflowId);
      self.postMessage({ type: 'WORKFLOW_ADVANCED', result: adv, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_BUILDINGS': {
      var summary = buildings.map(function(b) {
        return {
          id: b.id, code: b.code, name: b.name, floors: b.floorCount,
          departments: b.departments, capacity: b.capacity, workers: b.workers,
          health: b.health, status: b.status, desc: b.desc
        };
      });
      self.postMessage({ type: 'BUILDINGS', result: summary, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_BUILDING': {
      var bld = buildings.find(function(b) { return b.code === msg.buildingCode; });
      if (!bld) {
        self.postMessage({ type: 'BUILDING_DETAIL', result: { error: 'Not found' }, kernelId: KERNEL_ID });
      } else {
        self.postMessage({ type: 'BUILDING_DETAIL', result: bld, kernelId: KERNEL_ID });
      }
      break;
    }
    case 'GET_WORKFLOWS': {
      var filtered = msg.buildingCode
        ? workflows.filter(function(w) { return w.buildingCode === msg.buildingCode; })
        : workflows;
      self.postMessage({ type: 'WORKFLOWS', result: filtered, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_OCCUPANCY': {
      self.postMessage({ type: 'OCCUPANCY', result: getOccupancyReport(), kernelId: KERNEL_ID });
      break;
    }
    case 'GET_CAMPUS_MAP': {
      self.postMessage({ type: 'CAMPUS_MAP', result: getCampusMap(), kernelId: KERNEL_ID });
      break;
    }
    case 'GET_VITALS': {
      self.postMessage({
        type: 'VITALS',
        result: {
          heart: { beat: beatCount, phase: kernelPhase, bpm: 60000 / HEARTBEAT },
          brain: brain,
          buildings: buildings.length,
          totalWorkers: getTotalWorkers(),
          totalCapacity: getTotalCapacity(),
          activeWorkflows: workflows.filter(function(w) { return w.status !== 'COMPLETE'; }).length
        },
        kernelId: KERNEL_ID
      });
      break;
    }
    case 'status': {
      self.postMessage({
        type:         'status-report',
        kernelId:     KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version:      KERNEL_VERSION,
        beat:         beatCount,
        phase:        kernelPhase,
        buildings:    buildings.length,
        workflows:    workflows.length,
        totalWorkers: getTotalWorkers()
      });
      break;
    }
    case 'stop': {
      running = false;
      if (_hbi) clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
    }
  }
};

/* ── §9  BOOT ───────────────────────────────────────────────────────────── */

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);

self.postMessage({
  type:     'init',
  kernelId: KERNEL_ID,
  family:   KERNEL_FAMILY,
  version:  KERNEL_VERSION,
  buildings: buildings.length,
  totalFloors: buildings.reduce(function(s, b) { return s + b.floorCount; }, 0),
  totalRooms: buildings.reduce(function(s, b) {
    return s + b.floors.reduce(function(s2, f) { return s2 + f.rooms.length; }, 0);
  }, 0),
  totalCapacity: getTotalCapacity(),
  workflowTypes: WORKFLOW_TYPES.length,
  commands: [
    'CREATE_WORKFLOW', 'ASSIGN_WORKER', 'ADVANCE_WORKFLOW',
    'GET_BUILDINGS', 'GET_BUILDING', 'GET_WORKFLOWS',
    'GET_OCCUPANCY', 'GET_CAMPUS_MAP', 'GET_VITALS',
    'status', 'stop'
  ]
});
