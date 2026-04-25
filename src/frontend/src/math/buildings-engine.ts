// ─── NOVA / PARALLAX — Buildings Engine: Sovereign Campus Infrastructure ─────
// 12 Enterprise Buildings · Floors · Rooms · Workers · Workflows
// Campus Topology · Occupancy · Workflow Lifecycle Management
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, PHI, PHI_INV, TAU } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type BuildingCode =
  | 'HQ' | 'ENGINEERING' | 'DATA_CENTER' | 'RESEARCH_LAB'
  | 'SECURITY_FORTRESS' | 'OPERATIONS' | 'ANALYTICS_TOWER'
  | 'COMMERCE_HUB' | 'TRAINING_ACADEMY' | 'COMMUNICATIONS'
  | 'LEGAL_OFFICE' | 'INNOVATION_LAB';

export type WorkflowStatus = 'QUEUED' | 'ASSIGNED' | 'IN_PROGRESS' | 'REVIEW' | 'COMPLETE';

export type WorkflowType =
  | 'CODE_REVIEW' | 'DEPLOYMENT' | 'BUG_FIX' | 'FEATURE_DEV'
  | 'SECURITY_SCAN' | 'DATA_PIPELINE' | 'MODEL_TRAINING' | 'DOCUMENTATION'
  | 'TESTING' | 'INFRASTRUCTURE' | 'MONITORING' | 'RESEARCH'
  | 'OPTIMIZATION' | 'MIGRATION' | 'INCIDENT_RESPONSE';

export type RoomType = 'WORKSPACE' | 'MEETING' | 'SERVER' | 'LAB' | 'COMMON';

export interface MiniHeart {
  beat: number;
  phase: number;
  bpm: number;
  kuramotoOrder: number;
  amplitude: number;
}

export interface MicroRegion {
  name: string;
  activation: number;
  lif: number;
}

export interface MicroChemical {
  dopamine: number;
  serotonin: number;
  acetylcholine: number;
}

export interface MiniBrain {
  regions: MicroRegion[];
  chemicals: MicroChemical;
  coherenceField: number;
}

export interface Room {
  id: string;
  name: string;
  type: RoomType;
  capacity: number;
  occupants: number;
}

export interface Floor {
  floor: number;
  name: string;
  rooms: Room[];
}

export interface Building {
  id: string;
  code: BuildingCode;
  name: string;
  floors: Floor[];
  floorCount: number;
  departments: string[];
  capacity: number;
  workers: number;
  desc: string;
  status: 'OPERATIONAL' | 'MAINTENANCE' | 'OFFLINE';
  health: number;
}

export interface WorkflowHistoryEntry {
  event: string;
  beat: number;
  timestamp?: number;
  worker?: string;
  stage?: string;
}

export interface Workflow {
  id: string;
  buildingCode: BuildingCode;
  buildingName: string;
  type: WorkflowType;
  priority: 'CRITICAL' | 'HIGH' | 'MEDIUM' | 'LOW';
  description: string;
  status: WorkflowStatus;
  stageIndex: number;
  assignedTo: string | null;
  createdAt: number;
  createdBeat: number;
  updatedAt: number;
  completedAt: number | null;
  history: WorkflowHistoryEntry[];
}

export interface OccupancyEntry {
  code: BuildingCode;
  name: string;
  capacity: number;
  workers: number;
  occupancy: number;
  health: number;
  workflows: number;
}

export interface CampusMap {
  buildings: number;
  totalFloors: number;
  totalRooms: number;
  totalCapacity: number;
  totalWorkers: number;
  campusOccupancy: number;
  activeWorkflows: number;
  completedWorkflows: number;
  topology: { code: BuildingCode; name: string; floors: number; departments: string[]; status: string }[];
  coherence: number;
  phiCampusHealth: number;
}

export interface BuildingsVitals {
  heart: MiniHeart;
  brain: MiniBrain;
  buildings: number;
  totalWorkers: number;
  totalCapacity: number;
  activeWorkflows: number;
  campusMap: CampusMap;
}

export interface BuildingsSummary {
  buildings: number;
  totalFloors: number;
  totalRooms: number;
  totalCapacity: number;
  workflows: number;
  vitals: BuildingsVitals;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const HEARTBEAT_MS = 873;

const WORKFLOW_STAGES: WorkflowStatus[] = ['QUEUED', 'ASSIGNED', 'IN_PROGRESS', 'REVIEW', 'COMPLETE'];

const WORKFLOW_TYPES: WorkflowType[] = [
  'CODE_REVIEW', 'DEPLOYMENT', 'BUG_FIX', 'FEATURE_DEV',
  'SECURITY_SCAN', 'DATA_PIPELINE', 'MODEL_TRAINING', 'DOCUMENTATION',
  'TESTING', 'INFRASTRUCTURE', 'MONITORING', 'RESEARCH',
  'OPTIMIZATION', 'MIGRATION', 'INCIDENT_RESPONSE',
];

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: MINI-HEART & MINI-BRAIN FACTORIES
// ═══════════════════════════════════════════════════════════════════════════════

export function makeMiniHeart(): MiniHeart {
  return { beat: 0, phase: 0.0, bpm: 60000 / HEARTBEAT_MS, kuramotoOrder: 0.0, amplitude: 1.0 };
}

export function tickMiniHeart(h: MiniHeart): void {
  h.beat++;
  h.phase = (h.phase + PHI_INV) % TAU;
  h.kuramotoOrder = Math.abs(Math.cos(h.phase));
  h.amplitude = clamp(h.amplitude + (Math.random() - 0.5) * 0.01, 0.8, 1.0);
}

export function makeMiniBrain(): MiniBrain {
  return {
    regions: [
      { name: 'Sensory',     activation: 0.0, lif: -70.0 },
      { name: 'Associative', activation: 0.0, lif: -70.0 },
      { name: 'Executive',   activation: 0.0, lif: -70.0 },
      { name: 'Motor',       activation: 0.0, lif: -70.0 },
      { name: 'Memory',      activation: 0.0, lif: -70.0 },
    ],
    chemicals: { dopamine: 0.5, serotonin: 0.5, acetylcholine: 0.5 },
    coherenceField: 0.0,
  };
}

export function tickMiniBrain(b: MiniBrain): void {
  for (const r of b.regions) {
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0;
    if (r.lif >= -55.0) {
      r.activation = Math.min(1.0, r.activation + 0.2);
      r.lif = -70.0;
    }
    r.activation *= 0.95;
  }
  b.chemicals.dopamine      = clamp(b.chemicals.dopamine + (Math.random() - 0.5) * 0.02, 0, 1);
  b.chemicals.serotonin     = clamp(b.chemicals.serotonin + (Math.random() - 0.5) * 0.02, 0, 1);
  b.chemicals.acetylcholine = clamp(b.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02, 0, 1);
  const sum = b.regions.reduce((s, r) => s + r.activation, 0);
  b.coherenceField = sum / b.regions.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: BUILDING DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════

interface BuildingDef {
  code: BuildingCode;
  name: string;
  floors: number;
  departments: string[];
  capacity: number;
  desc: string;
}

const BUILDING_DEFS: BuildingDef[] = [
  { code: 'HQ',                name: 'Headquarters',         floors: 5,  departments: ['Executive', 'Strategy', 'Governance', 'Board Room'],                    capacity: 50,  desc: 'Central command and executive decision-making' },
  { code: 'ENGINEERING',       name: 'Engineering Tower',    floors: 10, departments: ['Frontend', 'Backend', 'Infrastructure', 'Architecture', 'QA'],           capacity: 120, desc: 'Core software development and code synthesis' },
  { code: 'DATA_CENTER',       name: 'Data Center',          floors: 3,  departments: ['Storage', 'Compute', 'Pipelines', 'ETL'],                               capacity: 40,  desc: 'Data processing, storage, and compute infrastructure' },
  { code: 'RESEARCH_LAB',      name: 'Research Laboratory',  floors: 4,  departments: ['AI Research', 'Quantum Lab', 'Neuroscience', 'Publications'],            capacity: 35,  desc: 'R&D, experimental protocols, and academic output' },
  { code: 'SECURITY_FORTRESS', name: 'Security Fortress',    floors: 3,  departments: ['Threat Intel', 'Incident Response', 'Compliance', 'Audit'],             capacity: 30,  desc: 'Defense, threat detection, and compliance enforcement' },
  { code: 'OPERATIONS',        name: 'Operations Center',    floors: 4,  departments: ['DevOps', 'SRE', 'Monitoring', 'Deployment'],                            capacity: 45,  desc: 'Infrastructure operations, deployment, and SRE' },
  { code: 'ANALYTICS_TOWER',   name: 'Analytics Tower',      floors: 6,  departments: ['BI', 'Reporting', 'Metrics', 'Dashboards', 'Forecasting'],              capacity: 55,  desc: 'Business intelligence, analytics, and reporting' },
  { code: 'COMMERCE_HUB',      name: 'Commerce Hub',         floors: 4,  departments: ['Sales', 'Marketplace', 'Payments', 'Billing'],                          capacity: 40,  desc: 'Revenue operations, marketplace, and transactions' },
  { code: 'TRAINING_ACADEMY',  name: 'Training Academy',     floors: 5,  departments: ['Courses', 'Certification', 'Mentorship', 'Skills Lab', 'Assessment'],   capacity: 60,  desc: 'AI/AGI training, skill development, and certification' },
  { code: 'COMMUNICATIONS',    name: 'Communications Center', floors: 3, departments: ['Messaging', 'Notifications', 'External APIs', 'Broadcast'],            capacity: 25,  desc: 'Internal and external communications infrastructure' },
  { code: 'LEGAL_OFFICE',      name: 'Legal Office',         floors: 2,  departments: ['Contracts', 'IP', 'Regulatory', 'Ethics'],                              capacity: 20,  desc: 'Legal, contracts, intellectual property, and ethics' },
  { code: 'INNOVATION_LAB',    name: 'Innovation Lab',       floors: 3,  departments: ['Prototyping', 'Incubator', 'Moonshots'],                                capacity: 30,  desc: 'Rapid prototyping, experimental projects, and moonshots' },
];

function buildBuildings(): Building[] {
  return BUILDING_DEFS.map((d, i) => {
    const floorList: Floor[] = [];
    for (let f = 1; f <= d.floors; f++) {
      const deptIdx = (f - 1) % d.departments.length;
      const rooms: Room[] = [
        { id: `${d.code}-F${f}-R1`, name: `${d.departments[deptIdx]} Main`,    type: 'WORKSPACE', capacity: Math.floor(d.capacity / d.floors * PHI_INV), occupants: 0 },
        { id: `${d.code}-F${f}-R2`, name: `${d.departments[deptIdx]} Meeting`, type: 'MEETING',   capacity: 8, occupants: 0 },
        { id: `${d.code}-F${f}-R3`, name: `Server Room ${f}`,                  type: 'SERVER',    capacity: 0, occupants: 0 },
      ];
      floorList.push({ floor: f, name: `Floor ${f} — ${d.departments[deptIdx]}`, rooms });
    }
    return {
      id: `BLD-${String(i + 1).padStart(3, '0')}`,
      code: d.code,
      name: d.name,
      floors: floorList,
      floorCount: d.floors,
      departments: d.departments,
      capacity: d.capacity,
      workers: 0,
      desc: d.desc,
      status: 'OPERATIONAL' as const,
      health: 1.0,
    };
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: BUILDINGS STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface BuildingsState {
  heart: MiniHeart;
  brain: MiniBrain;
  buildings: Building[];
  workflows: Workflow[];
  nextWorkflowId: number;
}

function makeBuildingsState(): BuildingsState {
  return {
    heart: makeMiniHeart(),
    brain: makeMiniBrain(),
    buildings: buildBuildings(),
    workflows: [],
    nextWorkflowId: 0,
  };
}

const _state = makeBuildingsState();

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: ENGINE OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════

export function tickBuildingsEngine(): void {
  tickMiniHeart(_state.heart);
  tickMiniBrain(_state.brain);

  // Update building health based on workflow completion rates
  for (const b of _state.buildings) {
    const bwf = _state.workflows.filter(w => w.buildingCode === b.code);
    const done = bwf.filter(w => w.status === 'COMPLETE').length;
    const total = bwf.length;
    b.health = total > 0
      ? clamp((done / total) * PHI_INV + (1 - b.workers / Math.max(1, b.capacity)) * (1 - PHI_INV), 0, 1)
      : 1.0;
  }
}

export function createWorkflow(
  buildingCode: BuildingCode,
  workflowType: WorkflowType = 'FEATURE_DEV',
  priority: Workflow['priority'] = 'MEDIUM',
  description = ''
): Workflow | { error: string } {
  const bld = _state.buildings.find(b => b.code === buildingCode);
  if (!bld) return { error: `Building not found: ${buildingCode}` };

  _state.nextWorkflowId++;
  const wf: Workflow = {
    id: `WF-${String(_state.nextWorkflowId).padStart(5, '0')}`,
    buildingCode,
    buildingName: bld.name,
    type: workflowType,
    priority,
    description,
    status: 'QUEUED',
    stageIndex: 0,
    assignedTo: null,
    createdAt: Date.now(),
    createdBeat: _state.heart.beat,
    updatedAt: Date.now(),
    completedAt: null,
    history: [{ event: 'CREATED', beat: _state.heart.beat, timestamp: Date.now() }],
  };
  _state.workflows.push(wf);
  return wf;
}

export function assignWorker(workflowId: string, workerId?: string): { workflowId: string; assignedTo: string; building: BuildingCode } | { error: string } {
  const wf = _state.workflows.find(w => w.id === workflowId);
  if (!wf) return { error: `Workflow not found: ${workflowId}` };
  if (wf.status === 'COMPLETE') return { error: 'Workflow already complete' };

  wf.assignedTo = workerId || `AUTO-${Date.now().toString(36)}`;
  wf.status = 'ASSIGNED';
  wf.stageIndex = 1;
  wf.updatedAt = Date.now();
  wf.history.push({ event: 'ASSIGNED', beat: _state.heart.beat, worker: wf.assignedTo });

  const bld = _state.buildings.find(b => b.code === wf.buildingCode);
  if (bld && bld.workers < bld.capacity) bld.workers++;

  return { workflowId: wf.id, assignedTo: wf.assignedTo, building: wf.buildingCode };
}

export function advanceWorkflow(workflowId: string): { workflowId: string; status: WorkflowStatus; stage: number } | { error: string } {
  const wf = _state.workflows.find(w => w.id === workflowId);
  if (!wf) return { error: `Workflow not found: ${workflowId}` };
  if (wf.status === 'COMPLETE') return { error: 'Already complete' };

  if (wf.stageIndex < WORKFLOW_STAGES.length - 1) {
    wf.stageIndex++;
    wf.status = WORKFLOW_STAGES[wf.stageIndex];
    wf.updatedAt = Date.now();
    wf.history.push({ event: 'ADVANCED', beat: _state.heart.beat, stage: wf.status });

    if (wf.status === 'COMPLETE') {
      wf.completedAt = Date.now();
      const bld = _state.buildings.find(b => b.code === wf.buildingCode);
      if (bld && bld.workers > 0) bld.workers--;
    }
  }
  return { workflowId: wf.id, status: wf.status, stage: wf.stageIndex };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: QUERY ENDPOINTS
// ═══════════════════════════════════════════════════════════════════════════════

function totalWorkers(): number {
  return _state.buildings.reduce((s, b) => s + b.workers, 0);
}

function totalCapacity(): number {
  return _state.buildings.reduce((s, b) => s + b.capacity, 0);
}

export function getOccupancyReport(): OccupancyEntry[] {
  return _state.buildings.map(b => ({
    code: b.code,
    name: b.name,
    capacity: b.capacity,
    workers: b.workers,
    occupancy: b.capacity > 0 ? b.workers / b.capacity : 0,
    health: b.health,
    workflows: _state.workflows.filter(w => w.buildingCode === b.code && w.status !== 'COMPLETE').length,
  }));
}

export function getCampusMap(): CampusMap {
  const tw = totalWorkers();
  const tc = totalCapacity();
  return {
    buildings: _state.buildings.length,
    totalFloors: _state.buildings.reduce((s, b) => s + b.floorCount, 0),
    totalRooms: _state.buildings.reduce((s, b) => s + b.floors.reduce((s2, f) => s2 + f.rooms.length, 0), 0),
    totalCapacity: tc,
    totalWorkers: tw,
    campusOccupancy: tc > 0 ? tw / tc : 0,
    activeWorkflows: _state.workflows.filter(w => w.status !== 'COMPLETE').length,
    completedWorkflows: _state.workflows.filter(w => w.status === 'COMPLETE').length,
    topology: _state.buildings.map(b => ({ code: b.code, name: b.name, floors: b.floorCount, departments: b.departments, status: b.status })),
    coherence: _state.brain.coherenceField,
    phiCampusHealth: clamp(
      _state.buildings.reduce((s, b) => s + b.health, 0) / _state.buildings.length * PHI_INV +
      _state.brain.coherenceField * (1 - PHI_INV),
      0, 1
    ),
  };
}

export function getBuildingsVitals(): BuildingsVitals {
  return {
    heart: { ..._state.heart },
    brain: {
      regions: _state.brain.regions.map(r => ({ ...r })),
      chemicals: { ..._state.brain.chemicals },
      coherenceField: _state.brain.coherenceField,
    },
    buildings: _state.buildings.length,
    totalWorkers: totalWorkers(),
    totalCapacity: totalCapacity(),
    activeWorkflows: _state.workflows.filter(w => w.status !== 'COMPLETE').length,
    campusMap: getCampusMap(),
  };
}

export function getBuildingsSummary(): BuildingsSummary {
  return {
    buildings: _state.buildings.length,
    totalFloors: _state.buildings.reduce((s, b) => s + b.floorCount, 0),
    totalRooms: _state.buildings.reduce((s, b) => s + b.floors.reduce((s2, f) => s2 + f.rooms.length, 0), 0),
    totalCapacity: totalCapacity(),
    workflows: _state.workflows.length,
    vitals: getBuildingsVitals(),
  };
}

export function getBuildings(): Omit<Building, 'floors'>[] {
  return _state.buildings.map(b => ({
    id: b.id, code: b.code, name: b.name, floorCount: b.floorCount,
    departments: b.departments, capacity: b.capacity, workers: b.workers,
    desc: b.desc, status: b.status, health: b.health,
  }));
}

export function getBuildingDetail(code: BuildingCode): Building | { error: string } {
  const bld = _state.buildings.find(b => b.code === code);
  if (!bld) return { error: `Building not found: ${code}` };
  return {
    ...bld,
    floors: bld.floors.map(f => ({ ...f, rooms: f.rooms.map(r => ({ ...r })) })),
  };
}

export function getWorkflows(buildingCode?: BuildingCode): Workflow[] {
  const filtered = buildingCode
    ? _state.workflows.filter(w => w.buildingCode === buildingCode)
    : _state.workflows;
  return filtered.map(w => ({ ...w, history: [...w.history] }));
}

export function getWorkflowTypes(): WorkflowType[] {
  return [...WORKFLOW_TYPES];
}
