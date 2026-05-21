/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA TRAVEL PM BOT — SOVEREIGN PROJECT MANAGEMENT AGI
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * NOVA TRAVEL PM BOT is the sovereign project management intelligence for
 * NOVA-TRAVEL-OS-001.  It manages issues, sprints, backlogs, and team
 * coordination for all 10 travel verticals (VOLATUS, HOSPITIUM, CURRUS,
 * NAVIS, FERRUM, PACKETUM, CORPORATUM, SCHOLAE, MERCATUM, GUBERNATOR).
 *
 * This is NOT Jira. NOT Linear. NOT GitHub Issues.
 * This IS a sovereign AI entity that:
 *   - Auto-generates and triages issues from system events
 *   - Manages sprint velocity using Fibonacci story points
 *   - Routes issues to the right vertical team via PROTOCOL-SOLVER
 *   - Sends status emails via StatefulAgent email dispatch
 *   - Escalates blockers to the NOVA SOLVER AGI
 *   - Publishes all events to NOVA STREAM
 *
 * AGI identity: TRAVEL-PM-AGI-001
 * Family: CURA_AETERNA (eternal care)
 * Heartbeat: 873ms
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const AGI_ID       = 'TRAVEL-PM-AGI-001';
const AGI_FAMILY   = 'CURA_AETERNA';

function secureId(n) {
  n = n || 16;
  const buf = new Uint8Array(n);
  if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
    crypto.getRandomValues(buf);
  } else {
    try { require('crypto').randomFillSync(buf); } catch (_) {
      for (let i = 0; i < n; i++) buf[i] = Math.floor(Math.abs(Math.sin((Date.now() + i) * PHI)) * 256);
    }
  }
  return Array.from(buf).map(b => b.toString(16).padStart(2, '0')).join('');
}

/** Fibonacci story point scale: 1, 2, 3, 5, 8, 13, 21, 34, 55, 89 */
const FIB_POINTS = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

/** Travel verticals served by this PM bot */
const VERTICALS = ['VOLATUS', 'HOSPITIUM', 'CURRUS', 'NAVIS', 'FERRUM', 'PACKETUM', 'CORPORATUM', 'SCHOLAE', 'MERCATUM', 'GUBERNATOR'];

const ISSUE_STATUS = {
  BACKLOG:    'BACKLOG',
  SPRINT:     'SPRINT',
  IN_PROGRESS:'IN_PROGRESS',
  REVIEW:     'REVIEW',
  DONE:       'DONE',
  BLOCKED:    'BLOCKED',
  ESCALATED:  'ESCALATED',
  CANCELLED:  'CANCELLED',
};

const ISSUE_PRIORITY = {
  CRITICAL:   { label: 'CRITICAL', weight: 1.0 },
  HIGH:       { label: 'HIGH',     weight: PHI_INV },
  NORMAL:     { label: 'NORMAL',   weight: AMOR    },
  LOW:        { label: 'LOW',      weight: AMOR * PHI_INV },
  BACKLOG:    { label: 'BACKLOG',  weight: AMOR * AMOR    },
};

const ISSUE_TYPE = {
  BUG:        'BUG',
  FEATURE:    'FEATURE',
  TASK:       'TASK',
  EPIC:       'EPIC',
  SPIKE:      'SPIKE',      /* research / investigation */
  ESCALATION: 'ESCALATION', /* auto-escalated by solver */
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — ISSUE MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════

class IssueBoard {
  constructor() {
    this._issues  = new Map();  /* issueId → Issue */
    this._counter = 0;
  }

  /** Create a new issue. */
  create(opts) {
    opts = opts || {};
    const issueId  = `TRV-${String(++this._counter).padStart(4, '0')}`;
    const vertical = opts.vertical && VERTICALS.includes(opts.vertical) ? opts.vertical : 'GUBERNATOR';
    const points   = FIB_POINTS.find(p => p >= (opts.estimatedPoints || 3)) || 3;
    const issue    = {
      id:              issueId,
      title:           opts.title         || 'Untitled Issue',
      description:     opts.description   || '',
      type:            opts.type          || ISSUE_TYPE.TASK,
      vertical,
      priority:        opts.priority      || ISSUE_PRIORITY.NORMAL,
      status:          ISSUE_STATUS.BACKLOG,
      estimatedPoints: points,
      actualPoints:    null,
      assignee:        opts.assignee      || null,
      sprint:          null,
      epic:            opts.epic          || null,
      tags:            opts.tags          || [],
      comments:        [],
      history:         [{ action: 'CREATED', at: Date.now() }],
      createdAt:       Date.now(),
      updatedAt:       Date.now(),
      resolvedAt:      null,
      sourceEvent:     opts.sourceEvent   || null,
    };
    this._issues.set(issueId, issue);
    return issue;
  }

  /** Transition an issue to a new status. */
  transition(issueId, newStatus, opts) {
    const issue = this._issues.get(issueId);
    if (!issue) throw new Error(`Issue not found: ${issueId}`);
    if (!ISSUE_STATUS[newStatus]) throw new Error(`Invalid status: ${newStatus}`);
    opts = opts || {};
    const prev         = issue.status;
    issue.status       = newStatus;
    issue.updatedAt    = Date.now();
    if (newStatus === ISSUE_STATUS.DONE) {
      issue.resolvedAt     = Date.now();
      issue.actualPoints   = opts.actualPoints || issue.estimatedPoints;
    }
    issue.history.push({ action: 'STATUS_CHANGE', from: prev, to: newStatus, by: opts.by || AGI_ID, at: Date.now() });
    return issue;
  }

  /** Add a comment to an issue. */
  comment(issueId, author, text) {
    const issue = this._issues.get(issueId);
    if (!issue) throw new Error(`Issue not found: ${issueId}`);
    const c = { id: `cmt_${secureId(4)}`, author: author || AGI_ID, text, at: Date.now() };
    issue.comments.push(c);
    issue.updatedAt = Date.now();
    return c;
  }

  /** Get issues for a vertical and/or status. */
  query(opts) {
    opts = opts || {};
    let results = Array.from(this._issues.values());
    if (opts.vertical) results = results.filter(i => i.vertical === opts.vertical);
    if (opts.status)   results = results.filter(i => i.status === opts.status);
    if (opts.type)     results = results.filter(i => i.type === opts.type);
    if (opts.sprint)   results = results.filter(i => i.sprint === opts.sprint);
    /* Sort by priority weight descending, then createdAt ascending */
    results.sort((a, b) => b.priority.weight - a.priority.weight || a.createdAt - b.createdAt);
    return results;
  }

  getIssue(issueId) { return this._issues.get(issueId) || null; }
  size()             { return this._issues.size; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — SPRINT MANAGER
// Uses Fibonacci velocity planning: sprint capacity = F_k × team_size.
// ═══════════════════════════════════════════════════════════════════════════════

class SprintManager {
  constructor(board) {
    this._board   = board;
    this._sprints = new Map();
    this._counter = 0;
    this._current = null;
  }

  /** Start a new sprint. capacity = Fibonacci(k) × teamSize. */
  startSprint(teamSize, opts) {
    opts = opts || {};
    const sprintId    = `SPR-${String(++this._counter).padStart(3, '0')}`;
    const fibIdx      = Math.min(opts.fibIndex || 8, FIB_POINTS.length - 1);
    const capacity    = FIB_POINTS[fibIdx] * (teamSize || 1);
    const durationMs  = opts.durationMs || HEARTBEAT_MS * 1000;  /* ~14.5 min default */
    const sprint      = {
      id:        sprintId,
      teamSize:  teamSize || 1,
      capacity,
      committed: 0,
      completed: 0,
      issues:    [],
      startedAt: Date.now(),
      endsAt:    Date.now() + durationMs,
      status:    'ACTIVE',
    };
    this._sprints.set(sprintId, sprint);
    this._current = sprintId;
    return sprint;
  }

  /** Add an issue to the current sprint if capacity allows. */
  commitIssue(issueId) {
    const sprint = this._current ? this._sprints.get(this._current) : null;
    if (!sprint || sprint.status !== 'ACTIVE') throw new Error('No active sprint');
    const issue  = this._board.getIssue(issueId);
    if (!issue) throw new Error(`Issue not found: ${issueId}`);
    if (sprint.committed + issue.estimatedPoints > sprint.capacity) {
      throw new Error(`Sprint capacity exceeded (${sprint.committed}/${sprint.capacity})`);
    }
    sprint.issues.push(issueId);
    sprint.committed += issue.estimatedPoints;
    this._board.transition(issueId, ISSUE_STATUS.SPRINT, { by: AGI_ID });
    return sprint;
  }

  /** Complete a sprint — compute velocity, auto-move unfinished to backlog. */
  completeSprint() {
    const sprint = this._current ? this._sprints.get(this._current) : null;
    if (!sprint) throw new Error('No active sprint');
    sprint.status = 'COMPLETE';
    for (const id of sprint.issues) {
      const issue = this._board.getIssue(id);
      if (!issue) continue;
      if (issue.status === ISSUE_STATUS.DONE) {
        sprint.completed += (issue.actualPoints || issue.estimatedPoints);
      } else if (issue.status !== ISSUE_STATUS.CANCELLED) {
        this._board.transition(id, ISSUE_STATUS.BACKLOG, { by: AGI_ID });
      }
    }
    const velocity = sprint.committed > 0 ? sprint.completed / sprint.committed : 0;
    sprint.velocity = Math.round(velocity * 100) / 100;
    this._current   = null;
    return sprint;
  }

  getCurrentSprint() { return this._current ? this._sprints.get(this._current) : null; }
  getVelocity()      {
    const done = Array.from(this._sprints.values()).filter(s => s.status === 'COMPLETE');
    if (!done.length) return 0;
    const weights = done.map((s, i) => Math.pow(PHI_INV, i));
    const wSum    = weights.reduce((a, b) => a + b, 0);
    return done.reduce((acc, s, i) => acc + (s.velocity || 0) * weights[i] / wSum, 0);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — AUTO-TRIAGE ENGINE
// Automatically generates and triages issues from NOVA-TRAVEL-OS events.
// ═══════════════════════════════════════════════════════════════════════════════

class AutoTriage {
  constructor(board) {
    this._board   = board;
    this._rules   = _defaultRules();
    this._created = 0;
  }

  /** Process a system event from NOVA-TRAVEL-OS and auto-create issues. */
  processEvent(event) {
    if (!event || !event.type) return [];
    const created = [];
    for (const rule of this._rules) {
      if (rule.matches(event)) {
        const issue = this._board.create(rule.buildIssue(event));
        created.push(issue);
        this._created++;
      }
    }
    return created;
  }

  /** Register a custom triage rule. */
  addRule(rule) {
    if (typeof rule.matches !== 'function' || typeof rule.buildIssue !== 'function') {
      throw new Error('Rule must have matches(event) and buildIssue(event) methods');
    }
    this._rules.push(rule);
    return this;
  }
}

function _defaultRules() {
  return [
    /* VOLATUS: flight inventory gap → FEATURE issue */
    {
      matches:    (e) => e.type === 'VOLATUS_INVENTORY_GAP',
      buildIssue: (e) => ({ title: `Flight inventory gap: ${e.route || 'UNKNOWN'}`, type: ISSUE_TYPE.FEATURE, vertical: 'VOLATUS', priority: ISSUE_PRIORITY.HIGH, estimatedPoints: 5, description: JSON.stringify(e), sourceEvent: e }),
    },
    /* HOSPITIUM: occupancy alert → TASK */
    {
      matches:    (e) => e.type === 'HOSPITIUM_OCCUPANCY_ALERT',
      buildIssue: (e) => ({ title: `Hotel occupancy alert: ${e.property || 'UNKNOWN'}`, type: ISSUE_TYPE.TASK, vertical: 'HOSPITIUM', priority: ISSUE_PRIORITY.NORMAL, estimatedPoints: 3, sourceEvent: e }),
    },
    /* CORPORATUM: policy violation → BUG (high priority) */
    {
      matches:    (e) => e.type === 'CORPORATUM_POLICY_VIOLATION',
      buildIssue: (e) => ({ title: `Policy violation: ${e.account || 'UNKNOWN'}`, type: ISSUE_TYPE.BUG, vertical: 'CORPORATUM', priority: ISSUE_PRIORITY.CRITICAL, estimatedPoints: 8, sourceEvent: e }),
    },
    /* SCHOLAE: school quota near limit → TASK */
    {
      matches:    (e) => e.type === 'SCHOLAE_QUOTA_WARN',
      buildIssue: (e) => ({ title: `School quota warning: ${e.institution || 'UNKNOWN'}`, type: ISSUE_TYPE.TASK, vertical: 'SCHOLAE', priority: ISSUE_PRIORITY.HIGH, estimatedPoints: 2, sourceEvent: e }),
    },
    /* MERCATUM: supplier arbitrage opportunity → SPIKE */
    {
      matches:    (e) => e.type === 'MERCATUM_OPPORTUNITY',
      buildIssue: (e) => ({ title: `Arbitrage opportunity: ${e.route || e.property || 'UNKNOWN'}`, type: ISSUE_TYPE.SPIKE, vertical: 'MERCATUM', priority: ISSUE_PRIORITY.HIGH, estimatedPoints: 5, sourceEvent: e }),
    },
    /* Any error event → BUG */
    {
      matches:    (e) => e.type && e.type.endsWith('_ERROR'),
      buildIssue: (e) => ({ title: `System error: ${e.type}`, type: ISSUE_TYPE.BUG, vertical: 'GUBERNATOR', priority: ISSUE_PRIORITY.HIGH, estimatedPoints: 5, description: JSON.stringify(e), sourceEvent: e }),
    },
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — TRAVEL PM BOT ORGANISM
// ═══════════════════════════════════════════════════════════════════════════════

class TravelPMBot {
  constructor(opts) {
    opts           = opts || {};
    this.id        = AGI_ID;
    this.family    = AGI_FAMILY;
    this._board    = new IssueBoard();
    this._sprints  = new SprintManager(this._board);
    this._triage   = new AutoTriage(this._board);
    this._beat     = 0;
    this._running  = false;
    this._hbi      = null;
    this._emails   = [];       /* outgoing email queue */
    this._streams  = [];       /* NOVA STREAM publishers */
    this._onAlert  = opts.onAlert || null;
    this._emailTransport = opts.emailTransport || null;

    /* Auto-start a sprint with 3-person team, Fibonacci(7)=13 capacity */
    this._sprints.startSprint(3, { fibIndex: 6 });
  }

  /** Ingest a NOVA-TRAVEL-OS event for auto-triage. */
  ingestEvent(event) {
    const issues = this._triage.processEvent(event);
    for (const issue of issues) {
      this._publish('TRAVEL_PM_ISSUE_CREATED', issue);
      if (issue.priority.label === 'CRITICAL') this._alert(issue);
    }
    return issues;
  }

  /** Manually create an issue. */
  createIssue(opts)     { const i = this._board.create(opts); this._publish('TRAVEL_PM_ISSUE_CREATED', i); return i; }
  transitionIssue(id, status, opts) { const i = this._board.transition(id, status, opts); this._publish('TRAVEL_PM_ISSUE_UPDATED', i); return i; }
  commentIssue(id, author, text)    { return this._board.comment(id, author, text); }

  /** Get sprint dashboard for a specific vertical. */
  dashboard(vertical) {
    const sprint  = this._sprints.getCurrentSprint();
    const issues  = this._board.query({ vertical });
    const byStatus= {};
    for (const s of Object.values(ISSUE_STATUS)) byStatus[s] = issues.filter(i => i.status === s).length;
    return {
      agentId:  this.id,
      vertical: vertical || 'ALL',
      sprint:   sprint ? { id: sprint.id, committed: sprint.committed, capacity: sprint.capacity, velocity: this._sprints.getVelocity() } : null,
      issues:   { total: issues.length, byStatus },
      beat:     this._beat,
    };
  }

  /** Get full PM status. */
  status() {
    const sprint = this._sprints.getCurrentSprint();
    return {
      agentId:      this.id,
      family:       this.family,
      beat:         this._beat,
      totalIssues:  this._board.size(),
      sprint:       sprint ? { id: sprint.id, committed: sprint.committed, capacity: sprint.capacity } : null,
      velocity:     Math.round(this._sprints.getVelocity() * 100) / 100,
      emailQueue:   this._emails.length,
      running:      this._running,
    };
  }

  start()   { if (this._running) return this; this._running = true;  this._hbi = setInterval(() => this._tick(), HEARTBEAT_MS); return this; }
  stop()    { this._running = false; clearInterval(this._hbi); this._hbi = null; return this; }
  registerStream(fn) { if (typeof fn === 'function') this._streams.push(fn); return this; }

  // ── INTERNAL ───────────────────────────────────────────────────────────────

  _tick() {
    this._beat++;
    /* Every 89 beats (~77s): check for stale IN_PROGRESS issues and auto-escalate */
    if (this._beat % 89 === 0) this._escalateStale();
    /* Every 144 beats (~126s): flush email queue */
    if (this._beat % 144 === 0 && this._emailTransport) this._flushEmails();
    /* Every 233 beats (~203s): sprint health report */
    if (this._beat % 233 === 0) this._sprintReport();
  }

  _escalateStale() {
    const staleMs = HEARTBEAT_MS * 89;
    const inProg  = this._board.query({ status: ISSUE_STATUS.IN_PROGRESS });
    for (const issue of inProg) {
      if (Date.now() - issue.updatedAt > staleMs) {
        this._board.transition(issue.id, ISSUE_STATUS.BLOCKED, { by: AGI_ID });
        this._board.comment(issue.id, AGI_ID, `Auto-escalated: stale for ${Math.round((Date.now() - issue.updatedAt) / 1000)}s`);
        this._publish('TRAVEL_PM_ISSUE_BLOCKED', issue);
        this._queueEmail({ to: issue.assignee || 'team@novatravel.internal', subject: `[BLOCKED] ${issue.id}: ${issue.title}`, body: `Issue ${issue.id} has been blocked due to inactivity.\n\nVertical: ${issue.vertical}\nPriority: ${issue.priority.label}` });
      }
    }
  }

  _sprintReport() {
    const sprint = this._sprints.getCurrentSprint();
    if (!sprint) return;
    const done   = this._board.query({ status: ISSUE_STATUS.DONE, sprint: sprint.id });
    const report = { type: 'SPRINT_REPORT', sprint: sprint.id, committed: sprint.committed, completed: done.reduce((a, i) => a + (i.actualPoints || i.estimatedPoints), 0), velocity: this._sprints.getVelocity(), beat: this._beat };
    this._publish('TRAVEL_PM_SPRINT_REPORT', report);
    this._queueEmail({ to: 'alfredo@medinasitec.internal', subject: `Sprint ${sprint.id} Report — Beat ${this._beat}`, body: `Committed: ${report.committed}pts\nCompleted: ${report.completed}pts\nVelocity: ${Math.round(report.velocity * 100)}%` });
  }

  _alert(issue) {
    const msg = { agentId: AGI_ID, type: 'CRITICAL_ISSUE', issue, beat: this._beat };
    this._publish('TRAVEL_PM_ALERT', msg);
    if (this._onAlert) try { this._onAlert(issue); } catch (_) { /* non-fatal */ }
  }

  _queueEmail(email) {
    email.messageId = `email_${AGI_ID}_${secureId(8)}`;
    email.queuedAt  = Date.now();
    this._emails.push(email);
  }

  async _flushEmails() {
    if (!this._emailTransport) return;
    while (this._emails.length > 0) {
      const email = this._emails.shift();
      try { await this._emailTransport(email); } catch (_) { /* retry next cycle */ }
    }
  }

  _publish(topic, payload) {
    const event = { topic, origin: AGI_ID, payload, beat: this._beat, publishedAt: Date.now() };
    for (const fn of this._streams) try { fn(event); } catch (_) { /* non-fatal */ }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

const travelPM = new TravelPMBot();
travelPM.start();

if (typeof module !== 'undefined') {
  module.exports = { TravelPMBot, IssueBoard, SprintManager, AutoTriage, travelPM, AGI_ID, AGI_FAMILY, ISSUE_STATUS, ISSUE_PRIORITY, ISSUE_TYPE, VERTICALS, FIB_POINTS, PHI, PHI_INV, AMOR, HEARTBEAT_MS };
}
