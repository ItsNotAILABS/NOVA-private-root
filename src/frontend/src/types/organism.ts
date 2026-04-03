// ─── NOVA / PARALLAX — Organism & Drone Type System ──────────────────────────
// Full TypeScript type definitions for drones, swarm, organism families.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import type {
  NeurochemicalState,
  QuantumChannels,
} from '../math/core';

// ── Drone Classification ──────────────────────────────────────────────────────
export type DroneClass =
  | 'SCOUT'
  | 'STRIKER'
  | 'GUARDIAN'
  | 'RELAY'
  | 'MEDIC'
  | 'SOVEREIGN';

export const DRONE_CLASSES: DroneClass[] = ['SCOUT', 'STRIKER', 'GUARDIAN', 'RELAY', 'MEDIC', 'SOVEREIGN'];

// ── Full Drone State ──────────────────────────────────────────────────────────
export interface DroneState {
  // Identity
  id:          number;
  cls:         DroneClass;

  // Spatial
  posX:        number;
  posY:        number;
  posZ:        number;
  velX:        number;
  velZ:        number;

  // Oscillator
  phase:       number;   // Kuramoto phase φᵢ
  omega:       number;   // Natural frequency ωᵢ
  signal:      number;   // Broadcast signal strength

  // Neurochemical substrate (sovereign floor S₀=1.0 enforced)
  dopamine:       number;
  cortisol:       number;
  norepinephrine: number;
  oxytocin:       number;

  // Energy
  energy:      number;   // ∈ [0.2, 2.0]

  // 6-node micro-brain
  brainWeights:     number[];  // flat 6×6 row-major weight matrix
  brainActivation:  number[];  // [SENSOR, MEMORY, EXECUTIVE, EMOTIONAL, MOTOR, OUTPUT]

  // Quantum cognitive channels
  qAlpha:       number;  // spatial/sensor
  qBeta:        number;  // temporal/memory
  qGamma:       number;  // relational
  qDelta:       number;  // executive-motor
  qConvergence: number;  // alignment ∈ [0,1]
  qCoherence:   number;  // internal+swarm ∈ [0,1]
  nowAttention: number;  // present-moment focus ∈ [0,1]

  // Lifecycle
  sacrificed:  boolean;
  lastBeat:    number;

  // Scores (updated each beat)
  trustScore:      number;   // T_s ∈ [0,1]
  anomalyScore:    number;   // A_s ∈ [0,1]
  loadPulse:       number;   // L_p ∈ [0,1]
}

// ── Swarm State ───────────────────────────────────────────────────────────────
export interface SwarmState {
  beat:          number;
  drones:        DroneState[];
  rSwarm:        number;   // Kuramoto order r ∈ [0,1]
  psi:           number;   // Mean phase Ψ
  jDrift:        number;   // Jasmine Lyapunov drift J(t)

  // Swarm-wide averages
  swarmQCoherence:    number;
  swarmConvergence:   number;
  swarmNowAttention:  number;

  // Scores
  continuityScore:    number;  // K_c
  trustScore:         number;  // T_s
  anomalyScore:       number;  // A_s
  loadPulseScore:     number;  // L_p
  simConfidence:      number;  // SC

  // Mission
  missionStatus:  'IDLE' | 'ACTIVE' | 'EMERGENCY_STOP' | 'COMPLETE';
  missionName:    string;
  emergencyActive: boolean;
  commsLost:      boolean;

  // HITL queue
  pendingActions: HITLRequest[];
  auditLog:       AuditEntry[];

  // Architect signal from operator
  architectSignal: number;  // ∈ [0,1]

  // Hebbian inter-drone weight matrix [n×n]
  hebbMatrix:     number[][];
}

// ── HITL (Human In The Loop) ──────────────────────────────────────────────────
export interface HITLRequest {
  id:       number;
  droneId:  number;
  action:   string;
  reason:   string;
  urgency:  number;      // P_w priority score
  deadline: number;      // ms timestamp
}

export interface AuditEntry {
  beat:    number;
  kind:    string;
  message: string;
  ts:      number;
}

// ── Organism Families ─────────────────────────────────────────────────────────
// These are the 4 real living system families (not helper bots).

export type OrganismFamilyId = 'MERIDIAN' | 'ORO_NOVA' | 'IRONCLAD' | 'NEUROCORE';

export interface OrganismFamily {
  id:          OrganismFamilyId;
  name:        string;
  description: string;
  coherence:   number;   // family-level Kuramoto order
  trust:       number;   // T_s
  anomaly:     number;   // A_s
  loadPulse:   number;   // L_p
  domains:     string[]; // what it owns
}

export const ORGANISM_FAMILY_DEFS: Omit<OrganismFamily, 'coherence' | 'trust' | 'anomaly' | 'loadPulse'>[] = [
  {
    id: 'MERIDIAN',
    name: 'MERIDIAN — Visible Manifestation',
    description: 'Workspace shell, navigation, pages, rooms, threads, dashboards, boards, search surfaces, artifact views, approval views, collaboration surfaces, and role-specific interfaces.',
    domains: ['workspace', 'navigation', 'pages', 'rooms', 'threads', 'dashboards', 'artifacts', 'approvals', 'search'],
  },
  {
    id: 'ORO_NOVA',
    name: 'ORO/NOVA — Runtime Continuity',
    description: 'Continuity, unresolved-state, monitor-next, context persistence, session continuity, work continuity, memory synthesis, narrative continuity, what-changed/what-matters-now.',
    domains: ['continuity', 'unresolved-state', 'monitor-next', 'memory-synthesis', 'narrative'],
  },
  {
    id: 'IRONCLAD',
    name: 'IRONCLAD — Integrity & Defense',
    description: 'Anomaly detection, suspicious change detection, trust scoring, integrity fingerprints, repeat-pattern detection, conflict severity, review escalation, quarantine, confidence penalties.',
    domains: ['anomaly', 'trust', 'integrity', 'conflict', 'quarantine', 'review-escalation'],
  },
  {
    id: 'NEUROCORE',
    name: 'NEUROCORE — Expansion & Branching',
    description: 'Worker spawning, branch creation, module registration, capability manifests, division-specific worker ecosystems, new artifact types, new page types, commercial branch generation.',
    domains: ['spawning', 'branching', 'registration', 'expansion', 'capability', 'division-ecosystems'],
  },
];

// ── Worker Society Types ──────────────────────────────────────────────────────
export type WorkerClass =
  | 'execution'
  | 'memory'
  | 'artifact'
  | 'analysis'
  | 'risk_integrity'
  | 'coordination'
  | 'executive_brief'
  | 'simulation'
  | 'search_retrieval'
  | 'division_finance'
  | 'division_legal'
  | 'division_sales'
  | 'division_operations'
  | 'division_pm'
  | 'division_support'
  | 'division_engineering'
  | 'division_admin'
  | 'division_rd';

export type WorkerStatus = 'idle' | 'active' | 'thinking' | 'blocked' | 'disagreeing' | 'escalating';

export interface Worker {
  id:          string;
  name:        string;
  cls:         WorkerClass;
  division:    string;
  status:      WorkerStatus;
  trust:       number;   // T_s
  anomaly:     number;   // A_s
  loadPulse:   number;   // L_p
  continuity:  number;   // K_c
  memory:      WorkerMemoryPolicy;
  permissions: WorkerPermissions;
  currentTask: string | null;
  outputQueue: WorkerOutput[];
  hebbWeight:  number;   // inter-worker Hebbian bond strength
}

export interface WorkerMemoryPolicy {
  maxAge:       number;  // beats before archiving
  compressAt:   number;  // beat count to compress
  retainTypes:  string[];
}

export interface WorkerPermissions {
  canWrite:      boolean;
  canApprove:    boolean;
  canEscalate:   boolean;
  canSpawn:      boolean;
  maxAutonomy:   number;  // ∈ [0,1] — how much action without human approval
}

export type WorkerOutput =
  | { type: 'artifact';     artifactId: string; confidence: number }
  | { type: 'disagreement'; partnerId: string; severity: number; topic: string }
  | { type: 'escalation';   reason: string; urgency: number }
  | { type: 'synthesis';    inputs: string[]; summary: string }
  | { type: 'answer';       content: string; confidence: number };

// ── Memory Substrate Types ────────────────────────────────────────────────────
export type MemoryClass =
  | 'conversation'
  | 'operational'
  | 'artifact'
  | 'decision'
  | 'project'
  | 'division'
  | 'room_page'
  | 'worker'
  | 'unresolved';

export interface MemoryObject {
  id:           string;
  cls:          MemoryClass;
  content:      string;
  refs:         string[];          // related memory IDs
  division:     string;
  projectId:    string | null;
  workerId:     string | null;
  roomId:       string | null;
  beat:         number;            // creation beat
  age:          number;            // beats since creation
  confidence:   number;            // ∈ [0,1]
  compressed:   boolean;
  archived:     boolean;
  continuity:   number;            // K_c for this memory object
  tags:         string[];
}

// ── Artifact System Types ─────────────────────────────────────────────────────
export type ArtifactClass =
  | 'brief'
  | 'memo'
  | 'summary'
  | 'executive_digest'
  | 'pm_update'
  | 'decision_packet'
  | 'approval_packet'
  | 'proposal'
  | 'estimate_packet'
  | 'handoff_packet'
  | 'risk_report'
  | 'anomaly_report'
  | 'continuity_report'
  | 'meeting_artifact'
  | 'simulation_artifact'
  | 'release_artifact'
  | 'external_share';

export type ReviewState = 'draft' | 'in_review' | 'approved' | 'rejected' | 'archived';
export type VisibilityClass = 'private' | 'division' | 'org' | 'external_safe';

export interface Artifact {
  id:              string;
  cls:             ArtifactClass;
  title:           string;
  content:         string;
  sourceRefs:      string[];
  lineage:         string[];      // chain of artifact IDs this derives from
  trustScore:      number;        // T_a
  continuityScore: number;        // K_c
  anomalyBurden:   number;        // A_s
  reviewState:     ReviewState;
  visibility:      VisibilityClass;
  version:         number;
  history:         ArtifactVersion[];
  approvals:       ArtifactApproval[];
  comments:        ArtifactComment[];
  beat:            number;
  workerAuthor:    string;
  divisionId:      string;
}

export interface ArtifactVersion {
  version: number;
  beat:    number;
  diff:    string;
  author:  string;
}

export interface ArtifactApproval {
  approver: string;  // user or worker ID
  beat:     number;
  decision: 'approved' | 'rejected';
  note:     string;
}

export interface ArtifactComment {
  id:      string;
  author:  string;
  content: string;
  beat:    number;
}

// ── World Object Types ────────────────────────────────────────────────────────
export type FactionId = string;

export interface WorldObject {
  id:           string;
  structureClass: import('../math/core').WorldStructureClass;
  geometry: {
    type:   'point' | 'line' | 'polygon' | 'field';
    coords: number[][];  // [x,y] pairs in world space
    radius?: number;
  };
  material:     import('../math/core').MaterialState;
  faction:      FactionId | null;
  coherence:    number;
  damage:       number;
  age:          number;
  pulse:        number;  // L_p for this structure
  emission:     number;  // visual emission intensity ∈ [0,1]
  unlocked:     boolean;
  domainId:     string | null;
  historyRefs:  string[];  // scar/monument refs
}

// ── Macro-State (simulation substrate) ───────────────────────────────────────
export interface MacroState {
  beat:              number;
  coherence:         number;   // global organism coherence r
  escalation:        number;   // conflict escalation pressure
  pressure:          number;   // urgency/stress field average
  trust:             number;   // T_s global
  lawDensity:        number;   // how much of system is law-governed
  damage:            number;   // structural damage burden
  memoryDensity:     number;   // K_c proxy
  stability:         number;   // 1 − instability
  energy:            number;   // swarm mean energy
  trafficFlow:       number;   // swarm mean movement / signaling
  anomalyDensity:    number;   // A_s global
  domainActivation:  number;   // fraction of domains unlocked
  infrastructureMaturity: number; // 0=fluid, 1=hardened
  nodeMaturity:      number;   // hub density
  worldAge:          number;   // beats since world genesis
}

// ── Presence System ───────────────────────────────────────────────────────────
export type PresenceState = 'active' | 'idle' | 'focused' | 'reviewing' | 'overloaded' | 'offline';

export interface UserPresence {
  userId:       string;
  name:         string;
  division:     string;
  presence:     PresenceState;
  loadPulse:    number;
  currentRoom:  string | null;
  lastBeat:     number;
}

export interface SpacePresence {
  spaceId:      string;
  name:         string;
  heat:         number;   // activity level ∈ [0,1]
  users:        string[];
  workers:      string[];
  pressure:     number;   // L_p
}

export interface TeamPulse {
  teamId:     string;
  division:   string;
  loadPulse:  number;   // L_p
  trust:      number;
  anomaly:    number;
  stalling:   boolean;
}

// ── Division Types ────────────────────────────────────────────────────────────
export type DivisionId =
  | 'EXECUTIVE'
  | 'OPERATIONS'
  | 'PM'
  | 'FINANCE'
  | 'LEGAL'
  | 'SALES'
  | 'SUPPORT'
  | 'ENGINEERING'
  | 'RD'
  | 'ADMIN';

export interface Division {
  id:          DivisionId;
  name:        string;
  loadPulse:   number;
  trust:       number;
  anomaly:     number;
  continuity:  number;
  workerIds:   string[];
  userIds:     string[];
  activeArtifacts: number;
  pendingApprovals: number;
  pressure:    number;
}

export const DIVISION_DEFS: { id: DivisionId; name: string }[] = [
  { id: 'EXECUTIVE',   name: 'Executive' },
  { id: 'OPERATIONS',  name: 'Operations' },
  { id: 'PM',          name: 'Project Management' },
  { id: 'FINANCE',     name: 'Finance' },
  { id: 'LEGAL',       name: 'Legal' },
  { id: 'SALES',       name: 'Sales' },
  { id: 'SUPPORT',     name: 'Support' },
  { id: 'ENGINEERING', name: 'Engineering' },
  { id: 'RD',          name: 'R&D' },
  { id: 'ADMIN',       name: 'Admin' },
];
