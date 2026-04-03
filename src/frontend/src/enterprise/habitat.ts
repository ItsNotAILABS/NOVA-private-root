// ─── NOVA / PARALLAX — Enterprise Habitat Engine ────────────────────────────
// Memory substrate, artifact system, worker society, council, trust,
// anomaly detection, continuity engine, pulse engine, presence system.
// The doctrine rule: the pass never drops.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import {
  clamp, continuitySore, trustScore, anomalyScore, loadPulseScore,
  workPriorityScore, artifactTrustScore, conflictSeverityScore,
  mahalanobisApprox, zScore,
} from '../math/core';

import type {
  Worker, WorkerClass, WorkerStatus, WorkerOutput, WorkerMemoryPolicy, WorkerPermissions,
  MemoryObject, MemoryClass,
  Artifact, ArtifactClass, ArtifactVersion, ReviewState, VisibilityClass,
  UserPresence, SpacePresence, TeamPulse,
  Division, DivisionId, DIVISION_DEFS,
} from '../types/organism';

// ─────────────────────────────────────────────────────────────────────────────
// MEMORY SUBSTRATE
// The pass never drops. Important state is not ephemeral.
// ─────────────────────────────────────────────────────────────────────────────

export class MemorySubstrate {
  private store: Map<string, MemoryObject> = new Map();
  private nextId = 1;
  private readonly MAX_ITEMS = 10000;

  /**
   * Save a memory object. Auto-compresses when count exceeds threshold.
   */
  save(
    cls: MemoryClass,
    content: string,
    opts: Partial<Omit<MemoryObject, 'id' | 'cls' | 'content' | 'age' | 'compressed' | 'archived'>> & { beat: number }
  ): MemoryObject {
    const id = `mem_${cls}_${this.nextId++}_${opts.beat}`;
    const obj: MemoryObject = {
      id,
      cls,
      content,
      refs:       opts.refs      ?? [],
      division:   opts.division  ?? 'GLOBAL',
      projectId:  opts.projectId ?? null,
      workerId:   opts.workerId  ?? null,
      roomId:     opts.roomId    ?? null,
      beat:       opts.beat,
      age:        0,
      confidence: opts.confidence ?? 0.75,
      compressed: false,
      archived:   false,
      continuity: opts.continuity ?? 0.80,
      tags:       opts.tags ?? [],
    };
    this.store.set(id, obj);
    this.enforceCapacity();
    return obj;
  }

  /** Retrieve by exact ID */
  get(id: string): MemoryObject | undefined {
    return this.store.get(id);
  }

  /**
   * Semantic retrieval — keyword + division + class filter.
   * Returns top-N by confidence × continuity, recency weighted.
   */
  retrieve(query: {
    keywords?:  string[];
    division?:  string;
    cls?:       MemoryClass;
    projectId?: string;
    tag?:       string;
    limit?:     number;
  }): MemoryObject[] {
    const { keywords = [], division, cls, projectId, tag, limit = 20 } = query;
    return [...this.store.values()]
      .filter(m => {
        if (m.archived) return false;
        if (division && m.division !== division) return false;
        if (cls && m.cls !== cls) return false;
        if (projectId && m.projectId !== projectId) return false;
        if (tag && !m.tags.includes(tag)) return false;
        if (keywords.length > 0) {
          const text = m.content.toLowerCase();
          return keywords.some(k => text.includes(k.toLowerCase()));
        }
        return true;
      })
      .sort((a, b) => {
        const scoreA = a.confidence * a.continuity * Math.exp(-a.age / 500);
        const scoreB = b.confidence * b.continuity * Math.exp(-b.age / 500);
        return scoreB - scoreA;
      })
      .slice(0, limit);
  }

  /** Age all memory objects by 1 beat; compress old ones */
  tick(beat: number): void {
    for (const [id, obj] of this.store) {
      const aged = { ...obj, age: beat - obj.beat };
      // Compress after 200 beats
      if (aged.age > 200 && !aged.compressed) {
        this.store.set(id, {
          ...aged,
          compressed: true,
          content: aged.content.slice(0, 200) + '…[compressed]',
          confidence: aged.confidence * 0.98,
        });
      }
      // Archive after 2000 beats
      if (aged.age > 2000 && !aged.archived) {
        this.store.set(id, { ...aged, archived: true });
      }
    }
  }

  /** Relink two memory objects (builds relational web) */
  relink(idA: string, idB: string): void {
    const a = this.store.get(idA);
    const b = this.store.get(idB);
    if (a && !a.refs.includes(idB)) this.store.set(idA, { ...a, refs: [...a.refs, idB] });
    if (b && !b.refs.includes(idA)) this.store.set(idB, { ...b, refs: [...b.refs, idA] });
  }

  /** Restore from archived state */
  restore(id: string): MemoryObject | undefined {
    const obj = this.store.get(id);
    if (obj?.archived) {
      const restored = { ...obj, archived: false, confidence: obj.confidence * 0.90 };
      this.store.set(id, restored);
      return restored;
    }
    return obj;
  }

  get size(): number { return this.store.size; }

  private enforceCapacity(): void {
    if (this.store.size > this.MAX_ITEMS) {
      // Archive oldest non-permanent memories
      const sorted = [...this.store.entries()].sort(([, a], [, b]) => a.beat - b.beat);
      const toArchive = sorted.slice(0, this.store.size - this.MAX_ITEMS);
      for (const [id, obj] of toArchive) {
        this.store.set(id, { ...obj, archived: true });
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ARTIFACT SYSTEM
// Artifacts are first-class durable objects. Not exports, not reports at edge.
// ─────────────────────────────────────────────────────────────────────────────

let artifactCounter = 1;

export class ArtifactSystem {
  private artifacts: Map<string, Artifact> = new Map();

  create(params: {
    cls:          ArtifactClass;
    title:        string;
    content:      string;
    sourceRefs?:  string[];
    workerAuthor: string;
    divisionId:   string;
    beat:         number;
    trustScore?:  number;
    continuityScore?: number;
  }): Artifact {
    const id = `art_${params.cls}_${artifactCounter++}`;
    const a: Artifact = {
      id,
      cls:             params.cls,
      title:           params.title,
      content:         params.content,
      sourceRefs:      params.sourceRefs ?? [],
      lineage:         [],
      trustScore:      params.trustScore      ?? 0.70,
      continuityScore: params.continuityScore ?? 0.75,
      anomalyBurden:   0.05,
      reviewState:     'draft',
      visibility:      'division',
      version:         1,
      history:         [],
      approvals:       [],
      comments:        [],
      beat:            params.beat,
      workerAuthor:    params.workerAuthor,
      divisionId:      params.divisionId,
    };
    this.artifacts.set(id, a);
    return a;
  }

  /** Update artifact content; bumps version */
  update(id: string, content: string, author: string, beat: number): Artifact | undefined {
    const a = this.artifacts.get(id);
    if (!a) return;
    const version: ArtifactVersion = { version: a.version, beat, diff: `Updated by ${author}`, author };
    const updated: Artifact = {
      ...a,
      content,
      version: a.version + 1,
      history: [...a.history, version],
    };
    // Recalculate trust
    updated.trustScore = artifactTrustScore(
      a.trustScore, a.continuityScore, clamp(a.sourceRefs.length / 5, 0, 1), a.anomalyBurden
    );
    this.artifacts.set(id, updated);
    return updated;
  }

  approve(id: string, approver: string, decision: 'approved' | 'rejected', note: string, beat: number): void {
    const a = this.artifacts.get(id);
    if (!a) return;
    this.artifacts.set(id, {
      ...a,
      reviewState: decision === 'approved' ? 'approved' : 'rejected',
      approvals: [...a.approvals, { approver, beat, decision, note }],
    });
  }

  addComment(id: string, author: string, content: string, beat: number): void {
    const a = this.artifacts.get(id);
    if (!a) return;
    const cid = `cmt_${Date.now()}`;
    this.artifacts.set(id, { ...a, comments: [...a.comments, { id: cid, author, content, beat }] });
  }

  get(id: string): Artifact | undefined { return this.artifacts.get(id); }

  list(filter?: { divisionId?: string; cls?: ArtifactClass; reviewState?: ReviewState }): Artifact[] {
    return [...this.artifacts.values()].filter(a => {
      if (filter?.divisionId && a.divisionId !== filter.divisionId) return false;
      if (filter?.cls && a.cls !== filter.cls) return false;
      if (filter?.reviewState && a.reviewState !== filter.reviewState) return false;
      return true;
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WORKER SOCIETY
// A real society of workers — not one generic assistant renamed.
// Workers act in parallel, disagree, synthesize, escalate, and hand off.
// ─────────────────────────────────────────────────────────────────────────────

const DEFAULT_MEMORY_POLICY: WorkerMemoryPolicy = {
  maxAge:      500,
  compressAt:  200,
  retainTypes: ['decision', 'artifact', 'unresolved'],
};

const DEFAULT_PERMISSIONS: WorkerPermissions = {
  canWrite:    true,
  canApprove:  false,
  canEscalate: true,
  canSpawn:    false,
  maxAutonomy: 0.5,
};

const WORKER_DEFS: Array<{
  id: string; name: string; cls: WorkerClass; division: string;
  permissions?: Partial<WorkerPermissions>;
}> = [
  // Core workers
  { id: 'w_exec_01',    name: 'EXECUTOR',           cls: 'execution',       division: 'GLOBAL' },
  { id: 'w_exec_02',    name: 'EXECUTOR-B',          cls: 'execution',       division: 'GLOBAL' },
  { id: 'w_mem_01',     name: 'ARCHIVIST',           cls: 'memory',          division: 'GLOBAL' },
  { id: 'w_mem_02',     name: 'RECALL',              cls: 'memory',          division: 'GLOBAL' },
  { id: 'w_art_01',     name: 'SCRIBE',              cls: 'artifact',        division: 'GLOBAL' },
  { id: 'w_art_02',     name: 'DOCUMENTER',          cls: 'artifact',        division: 'GLOBAL' },
  { id: 'w_ana_01',     name: 'ANALYST',             cls: 'analysis',        division: 'GLOBAL' },
  { id: 'w_ana_02',     name: 'SURVEYOR',            cls: 'analysis',        division: 'GLOBAL' },
  { id: 'w_risk_01',    name: 'SENTINEL',            cls: 'risk_integrity',  division: 'GLOBAL', permissions: { canApprove: true, maxAutonomy: 0.3 } },
  { id: 'w_coord_01',   name: 'COORDINATOR',         cls: 'coordination',    division: 'GLOBAL', permissions: { canApprove: true } },
  { id: 'w_brief_01',   name: 'HERALD',              cls: 'executive_brief', division: 'EXECUTIVE', permissions: { canApprove: true, maxAutonomy: 0.7 } },
  { id: 'w_sim_01',     name: 'ORACLE',              cls: 'simulation',      division: 'GLOBAL' },
  { id: 'w_search_01',  name: 'FINDER',              cls: 'search_retrieval',division: 'GLOBAL' },
  // Division workers
  { id: 'w_fin_01',     name: 'CFO-AGENT',           cls: 'division_finance',     division: 'FINANCE', permissions: { canApprove: true, maxAutonomy: 0.4 } },
  { id: 'w_legal_01',   name: 'COUNSEL',             cls: 'division_legal',       division: 'LEGAL',   permissions: { canApprove: true, maxAutonomy: 0.3 } },
  { id: 'w_sales_01',   name: 'CLOSER',              cls: 'division_sales',       division: 'SALES' },
  { id: 'w_ops_01',     name: 'OPS-RUNNER',          cls: 'division_operations',  division: 'OPERATIONS' },
  { id: 'w_pm_01',      name: 'PM-AGENT',            cls: 'division_pm',          division: 'PM', permissions: { canApprove: true } },
  { id: 'w_spt_01',     name: 'SUPPORTER',           cls: 'division_support',     division: 'SUPPORT' },
  { id: 'w_eng_01',     name: 'ENGINEER',            cls: 'division_engineering', division: 'ENGINEERING' },
  { id: 'w_eng_02',     name: 'ARCHITECT',           cls: 'division_engineering', division: 'ENGINEERING', permissions: { canSpawn: true } },
  { id: 'w_admin_01',   name: 'ADMIN-AGENT',         cls: 'division_admin',       division: 'ADMIN', permissions: { canApprove: true } },
  { id: 'w_rd_01',      name: 'RESEARCHER',          cls: 'division_rd',          division: 'RD', permissions: { canSpawn: true } },
];

let workerIdCounter = 1;

function makeWorker(def: typeof WORKER_DEFS[0]): Worker {
  return {
    id:          def.id,
    name:        def.name,
    cls:         def.cls,
    division:    def.division,
    status:      'idle',
    trust:       0.75 + Math.random() * 0.15,
    anomaly:     0.02 + Math.random() * 0.05,
    loadPulse:   0.10 + Math.random() * 0.15,
    continuity:  0.80 + Math.random() * 0.10,
    memory:      { ...DEFAULT_MEMORY_POLICY },
    permissions: { ...DEFAULT_PERMISSIONS, ...(def.permissions ?? {}) },
    currentTask: null,
    outputQueue: [],
    hebbWeight:  1.0,
  };
}

// DisagreementObject — first-class conflict record
export interface DisagreementObject {
  id:        string;
  beat:      number;
  workerA:   string;
  workerB:   string;
  topic:     string;
  positionA: string;
  positionB: string;
  severity:  number;     // C_s
  resolved:  boolean;
  resolution?: string;
}

export class WorkerSociety {
  private workers: Map<string, Worker>;
  private disagreements: Map<string, DisagreementObject> = new Map();
  private nextDid = 1;
  private memory: MemorySubstrate;
  private artifacts: ArtifactSystem;

  constructor(memory: MemorySubstrate, artifacts: ArtifactSystem) {
    this.memory    = memory;
    this.artifacts = artifacts;
    this.workers   = new Map(WORKER_DEFS.map(def => [def.id, makeWorker(def)]));
  }

  get all(): Worker[] { return [...this.workers.values()]; }

  getById(id: string): Worker | undefined { return this.workers.get(id); }

  getByDivision(division: string): Worker[] {
    return this.all.filter(w => w.division === division || w.division === 'GLOBAL');
  }

  /** Invoke a worker to perform a task */
  invoke(workerId: string, task: string, beat: number): WorkerOutput | null {
    const w = this.workers.get(workerId);
    if (!w) return null;
    if (w.status === 'blocked' || w.loadPulse > 0.90) return null;

    // Update worker status
    this.workers.set(workerId, { ...w, status: 'active', currentTask: task });

    // Generate a synthetic output based on worker class and trust
    const output = this.generateOutput(w, task, beat);

    // Save output to memory
    this.memory.save('worker', `${w.name} output: ${task}`, {
      beat, workerId, confidence: w.trust, continuity: w.continuity,
      division: w.division, tags: [w.cls, 'worker-output'],
    });

    // Push to output queue and clear task
    const updated = { ...w, status: 'idle' as WorkerStatus, currentTask: null, outputQueue: [...w.outputQueue, output] };
    this.workers.set(workerId, updated);
    return output;
  }

  private generateOutput(w: Worker, task: string, beat: number): WorkerOutput {
    const conf = clamp(w.trust * w.continuity, 0, 1);
    // Artifact workers produce artifacts
    if (w.cls === 'artifact' || w.cls === 'executive_brief') {
      const artClass: ArtifactClass = w.cls === 'executive_brief' ? 'executive_digest' : 'summary';
      const art = this.artifacts.create({
        cls: artClass, title: task.slice(0, 80), content: `${w.name} produced: ${task}`,
        workerAuthor: w.id, divisionId: w.division, beat,
        trustScore: w.trust, continuityScore: w.continuity,
      });
      return { type: 'artifact', artifactId: art.id, confidence: conf };
    }
    // Analysis workers return answers
    return { type: 'answer', content: `${w.name} analysis: ${task}`, confidence: conf };
  }

  /**
   * Council behavior: invoke multiple workers, detect disagreements.
   * If workers disagree materially (C_s > 0.5), preserve disagreement as first-class object.
   */
  council(workerIds: string[], task: string, beat: number): {
    outputs:       WorkerOutput[];
    disagreements: DisagreementObject[];
    synthesis:     WorkerOutput | null;
  } {
    const outputs = workerIds.flatMap(id => {
      const out = this.invoke(id, task, beat);
      return out ? [out] : [];
    });

    // Detect disagreements among answer-type outputs
    const answers = outputs.filter(o => o.type === 'answer') as Array<{ type: 'answer'; content: string; confidence: number }>;
    const newDisagreements: DisagreementObject[] = [];

    for (let i = 0; i < answers.length; i++) {
      for (let j = i + 1; j < answers.length; j++) {
        const confDiff = Math.abs((answers[i]?.confidence ?? 0) - (answers[j]?.confidence ?? 0));
        const severity = conflictSeverityScore({
          fieldDivergence:        confDiff,
          timingDivergence:       0.1,
          userRoleDivergence:     0.2,
          attachmentDivergence:   0.1,
          operationalConsequence: confDiff * 0.5,
        });
        if (severity > 0.30) {
          const did = `dis_${this.nextDid++}`;
          const dis: DisagreementObject = {
            id: did, beat,
            workerA:   workerIds[i] ?? 'unknown',
            workerB:   workerIds[j] ?? 'unknown',
            topic:     task,
            positionA: answers[i]?.content ?? '',
            positionB: answers[j]?.content ?? '',
            severity,
            resolved:  false,
          };
          this.disagreements.set(did, dis);
          newDisagreements.push(dis);
          // Mark workers as disagreeing
          const wA = this.workers.get(workerIds[i] ?? '');
          const wB = this.workers.get(workerIds[j] ?? '');
          if (wA) this.workers.set(wA.id, { ...wA, status: 'disagreeing' });
          if (wB) this.workers.set(wB.id, { ...wB, status: 'disagreeing' });
        }
      }
    }

    // Synthesis if no major disagreement
    const synthesis: WorkerOutput | null = newDisagreements.length === 0 && answers.length > 0
      ? {
          type:    'synthesis',
          inputs:  workerIds,
          summary: answers.map(a => a.content).join(' | '),
        }
      : null;

    return { outputs, disagreements: newDisagreements, synthesis };
  }

  get allDisagreements(): DisagreementObject[] {
    return [...this.disagreements.values()];
  }

  resolveDisagreement(id: string, resolution: string): void {
    const d = this.disagreements.get(id);
    if (d) this.disagreements.set(id, { ...d, resolved: true, resolution });
  }

  /** Tick: update worker pulse scores and trust */
  tick(beat: number, rSwarm: number): void {
    for (const [id, w] of this.workers) {
      const lp = loadPulseScore({
        queueBurden:        w.outputQueue.length / 10,
        notificationBurden: w.status === 'active' ? 0.5 : 0.1,
        blockerBurden:      w.status === 'blocked' ? 0.8 : 0.0,
        anomalyBurden:      w.anomaly,
        workloadPressure:   w.loadPulse * 0.8,
      });
      const ts = trustScore({
        continuityQuality:     w.continuity,
        lineageCompleteness:   clamp(w.outputQueue.length / 5, 0, 1),
        reviewConfidence:      rSwarm,
        anomalyBurden:         w.anomaly,
        versionConflictBurden: this.allDisagreements.filter(d => d.workerA === id || d.workerB === id && !d.resolved).length / 10,
      });
      this.workers.set(id, { ...w, loadPulse: lp, trust: ts });
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTINUITY ENGINE — K_c tracking across the enterprise
// ─────────────────────────────────────────────────────────────────────────────

export class ContinuityEngine {
  private kc: number = 0.85;
  private history: number[] = [];

  tick(inputs: {
    contextGap:          number;
    lostReferences:      number;
    contradictionBurden: number;
    handoffBreakage:     number;
    memoryDecay:         number;
  }): number {
    this.kc = continuitySore(inputs);
    this.history.push(this.kc);
    if (this.history.length > 500) this.history.shift();
    return this.kc;
  }

  get current(): number { return this.kc; }
  get trend(): 'improving' | 'stable' | 'degrading' {
    if (this.history.length < 10) return 'stable';
    const recent = this.history.slice(-10);
    const older  = this.history.slice(-20, -10);
    const rMean  = recent.reduce((a, b) => a + b, 0) / recent.length;
    const oMean  = older.reduce((a, b) => a + b, 0)  / older.length;
    if (rMean - oMean >  0.02) return 'improving';
    if (rMean - oMean < -0.02) return 'degrading';
    return 'stable';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANOMALY ENGINE — Ironclad family
// ─────────────────────────────────────────────────────────────────────────────

export interface AnomalyEvent {
  id:        string;
  beat:      number;
  score:     number;   // A_s
  source:    string;
  detail:    string;
  quarantined: boolean;
}

export class AnomalyEngine {
  private events: AnomalyEvent[] = [];
  private nextId = 1;
  private runningMean: number[] = [];
  private runningStd:  number[] = [];

  /** Feed a metric vector and detect anomalies */
  feed(values: number[], labels: string[], beat: number, source: string): AnomalyEvent | null {
    if (this.runningMean.length === 0) {
      this.runningMean = values.slice();
      this.runningStd  = values.map(() => 0.1);
      return null;
    }

    const z = values.map((v, i) => Math.abs(zScore(v, this.runningMean[i] ?? 0, this.runningStd[i] ?? 0.1)));
    const zMax = Math.max(...z);

    const as_ = anomalyScore({
      mahalanobisAbnormality: clamp(mahalanobisApprox(values, this.runningMean, this.runningStd) / 4, 0, 1),
      isolationForestSignal:  clamp(zMax / 4, 0, 1),
      zScoreExcursion:        clamp(zMax / 3, 0, 1),
      fingerprintDeviation:   clamp(values.reduce((s, v, i) => s + Math.abs(v - (this.runningMean[i] ?? 0)), 0) / values.length, 0, 1),
    });

    // Update running stats (EMA)
    this.runningMean = this.runningMean.map((m, i) => m * 0.95 + (values[i] ?? m) * 0.05);
    this.runningStd  = this.runningStd.map((s, i) => {
      const newVar = s * s * 0.95 + ((values[i] ?? 0) - (this.runningMean[i] ?? 0)) ** 2 * 0.05;
      return Math.sqrt(Math.max(newVar, 0.0001));
    });

    if (as_ > 0.45) {
      const evt: AnomalyEvent = {
        id:          `anm_${this.nextId++}`,
        beat, score: as_, source,
        detail:      labels.map((l, i) => `${l}:${(values[i] ?? 0).toFixed(3)}`).join(', '),
        quarantined: as_ > 0.80,
      };
      this.events.push(evt);
      if (this.events.length > 500) this.events.shift();
      return evt;
    }
    return null;
  }

  get recent(): AnomalyEvent[] { return this.events.slice(-20); }
  get quarantined(): AnomalyEvent[] { return this.events.filter(e => e.quarantined); }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRESENCE SYSTEM — Habitat visibility
// ─────────────────────────────────────────────────────────────────────────────

export class PresenceSystem {
  private users:  Map<string, UserPresence>  = new Map();
  private spaces: Map<string, SpacePresence> = new Map();
  private teams:  Map<string, TeamPulse>     = new Map();

  setUserPresence(user: UserPresence): void {
    this.users.set(user.userId, user);
  }

  setSpacePresence(space: SpacePresence): void {
    this.spaces.set(space.spaceId, space);
  }

  updateTeamPulse(pulse: TeamPulse): void {
    this.teams.set(pulse.teamId, pulse);
  }

  /** Tick: decay presence of users not updated recently */
  tick(beat: number): void {
    for (const [id, u] of this.users) {
      if (beat - u.lastBeat > 10 && u.presence !== 'offline') {
        this.users.set(id, { ...u, presence: 'idle' });
      }
    }
  }

  get allUsers():  UserPresence[]  { return [...this.users.values()]; }
  get allSpaces(): SpacePresence[] { return [...this.spaces.values()]; }
  get allTeams():  TeamPulse[]     { return [...this.teams.values()]; }

  /** Company pulse: aggregate L_p across all teams */
  get companyPulse(): number {
    const teams = this.allTeams;
    if (!teams.length) return 0.2;
    return teams.reduce((s, t) => s + t.loadPulse, 0) / teams.length;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ENTERPRISE HABITAT — Top-level container
// Wires all subsystems together.
// ─────────────────────────────────────────────────────────────────────────────

export interface EnterpriseSnapshot {
  beat:           number;
  continuity:     number;
  companyPulse:   number;
  workers:        Worker[];
  recentArtifacts: Artifact[];
  disagreements:  DisagreementObject[];
  anomalies:      AnomalyEvent[];
  users:          UserPresence[];
  spaces:         SpacePresence[];
  teams:          TeamPulse[];
}

export class EnterpriseHabitat {
  readonly memory:      MemorySubstrate;
  readonly artifacts:   ArtifactSystem;
  readonly workers:     WorkerSociety;
  readonly continuity:  ContinuityEngine;
  readonly anomaly:     AnomalyEngine;
  readonly presence:    PresenceSystem;

  constructor() {
    this.memory     = new MemorySubstrate();
    this.artifacts  = new ArtifactSystem();
    this.workers    = new WorkerSociety(this.memory, this.artifacts);
    this.continuity = new ContinuityEngine();
    this.anomaly    = new AnomalyEngine();
    this.presence   = new PresenceSystem();
  }

  /**
   * Master tick — keeps the enterprise alive.
   * Called once per simulation beat with swarm aggregates.
   */
  tick(beat: number, rSwarm: number, jDrift: number, meanTrust: number, meanAnomaly: number): EnterpriseSnapshot {
    // Continuity
    this.continuity.tick({
      contextGap:          clamp(jDrift / 3, 0, 1),
      lostReferences:      clamp(1 - rSwarm, 0, 1),
      contradictionBurden: clamp(this.workers.allDisagreements.filter(d => !d.resolved).length / 10, 0, 1),
      handoffBreakage:     clamp(1 - meanTrust, 0, 1),
      memoryDecay:         clamp(this.memory.size > 5000 ? 0.3 : 0.1, 0, 1),
    });

    // Memory age tick
    this.memory.tick(beat);

    // Worker tick
    this.workers.tick(beat, rSwarm);

    // Presence tick
    this.presence.tick(beat);

    // Anomaly detection on swarm vitals
    this.anomaly.feed(
      [rSwarm, jDrift, meanTrust, meanAnomaly],
      ['rSwarm', 'jDrift', 'meanTrust', 'meanAnomaly'],
      beat, 'swarm'
    );

    return this.snapshot(beat);
  }

  snapshot(beat: number): EnterpriseSnapshot {
    return {
      beat,
      continuity:       this.continuity.current,
      companyPulse:     this.presence.companyPulse,
      workers:          this.workers.all,
      recentArtifacts:  this.artifacts.list().slice(-20),
      disagreements:    this.workers.allDisagreements,
      anomalies:        this.anomaly.recent,
      users:            this.presence.allUsers,
      spaces:           this.presence.allSpaces,
      teams:            this.presence.allTeams,
    };
  }
}
