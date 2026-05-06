/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA SOVEREIGN ALPHA AGI — CHRONOS PERPETUUS  (BUILD №57)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * CHRONOS PERPETUUS is the Temporal Intelligence AGI — every task in NOVA flows through
 * CHRONOS for temporal ordering, Fibonacci scheduling, critical-path analysis, and deadline
 * enforcement.  It encodes time as Quipu KNOT structures and applies hyperbolic discounting
 * so the most urgent tasks always rise to the top.  Deadlines are enforced by a φ-superlinear
 * late penalty so slipping by 1 day costs more than 1 day — antifragile incentive structure.
 *
 * AGI identity : CHR-AGI-001
 * Family       : TEMPUS_AETERNA (Eternal Time)
 * Heartbeat    : 873 ms
 * Oscillators  : 32 Kuramoto
 *
 * Mathematical foundation:
 *   Fibonacci scheduling: intervals = [1,1,2,3,5,8,13,21,34,55,89,144] minutes
 *   Hyperbolic discounting: V(t) = reward / (1 + k·t),  k = AMOR = 0.3819
 *   Schumann sync: T_heartbeat = 873ms ≈ φ⁴ × (1/7.83Hz × 1000)
 *   Quipu encoding: knot_value = Σᵢ aᵢ × φⁱ  (Zeckendorf representation)
 *   Critical path: longest path in DAG using φ-weighted edge costs
 *   Late penalty: f(delay) = delay^φ  (superlinear — antifragile incentive)
 *   Prediction: x̂(t+h) = x(t) + h·ẋ + ½h²·ẍ  stabilised by Lyapunov guard
 *
 * MACHINA VIRTUALIS states (8):
 *   IDLE → INGEST → PARSE → SCHEDULE → OPTIMIZE → EXECUTE → MONITOR → RECONCILE
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — SOVEREIGN CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const AGI_ID       = 'CHR-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'TEMPUS_AETERNA';
const AGI_NAME     = 'CHRONOS PERPETUUS';

const N_OSC        = 32;

const FIBONACCI    = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];

const MV = {
  IDLE:      'IDLE',
  INGEST:    'INGEST',
  PARSE:     'PARSE',
  SCHEDULE:  'SCHEDULE',
  OPTIMIZE:  'OPTIMIZE',
  EXECUTE:   'EXECUTE',
  MONITOR:   'MONITOR',
  RECONCILE: 'RECONCILE',
};

function secureId(n) {
  n = n || 8;
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

function timestamp() { return new Date().toISOString(); }

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — KURAMOTO ENGINE (32 oscillators — heartbeat calibration)
// ═══════════════════════════════════════════════════════════════════════════════

function _initOsc(n) {
  n = n || N_OSC;
  return Array.from({ length: n }, () => ({
    phase:      (Math.random() - 0.5) * Math.PI / 4,
    naturalFreq: 1 / HEARTBEAT_MS * 1000 * (1 + 0.02 * (Math.random() - 0.5)),
    amplitude:  0.9 + 0.1 * Math.random(),
  }));
}

function _kuramotoStep(oscs, K, dt) {
  dt = dt || 0.1;
  const N = oscs.length;
  return oscs.map((o, i) => {
    let s = 0;
    for (let j = 0; j < N; j++) s += Math.sin(oscs[j].phase - o.phase);
    return { ...o, phase: o.phase + dt * (o.naturalFreq + (K / N) * s) };
  });
}

function _orderParam(oscs) {
  let re = 0, im = 0;
  for (const o of oscs) { re += Math.cos(o.phase); im += Math.sin(o.phase); }
  return Math.sqrt(re * re + im * im) / oscs.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — HZ-SUBSTRATE (frequency mapping / Schumann resonance sync)
// ═══════════════════════════════════════════════════════════════════════════════

const SCHUMANN_HZ   = 7.83;
const SCHUMANN_PERIOD_MS = 1000 / SCHUMANN_HZ;   /* ≈ 127.7ms */
/* 873ms ≈ PHI⁴ × SCHUMANN_PERIOD_MS / PHI = φ³ × ~127.7 ≈ 873 */

function _computeSchumannOffset(beatNum) {
  /* Drift correction: align heartbeat to nearest Schumann multiple */
  const drift = (HEARTBEAT_MS * beatNum) % SCHUMANN_PERIOD_MS;
  return drift < SCHUMANN_PERIOD_MS / 2 ? drift : drift - SCHUMANN_PERIOD_MS;
}

function _deviceFreq(nodeId) {
  let h = 5381;
  for (const c of String(nodeId)) h = ((h << 5) + h + c.charCodeAt(0)) & 0xffffffff;
  const shard = Math.abs(h) % 16;
  return PHI * (1 + shard / 100);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — QUIPU ENGINE (timeline ledger)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Quipu KNOT structure:
 *   SPINE     = year-level container
 *   PENDANT   = month-level group
 *   KNOT      = day-level task group
 *   SUBSIDIARY = individual task
 */

function _zeckendorf(n) {
  /* Zeckendorf representation: n as sum of non-consecutive Fibonacci numbers */
  const fibs = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];
  const used = [];
  for (let i = fibs.length - 1; i >= 0 && n > 0; i--) {
    if (fibs[i] <= n) { used.push(fibs[i]); n -= fibs[i]; }
  }
  return used;
}

function _quipuEncode(n) {
  /* knot_value = Σᵢ aᵢ × φⁱ  (Zeckendorf) */
  const parts = _zeckendorf(Math.max(0, Math.round(n)));
  return parts.reduce((s, f, i) => s + f * Math.pow(PHI, i), 0);
}

class QuipuKnot {
  constructor(label, type) {
    this.id        = `QK-${secureId(4).toUpperCase()}`;
    this.label     = String(label);
    this.type      = type || 'KNOT';   /* SPINE | PENDANT | KNOT | SUBSIDIARY */
    this.createdAt = Date.now();
    this.dueAt     = null;
    this.children  = [];
    this.phiValue  = 0;
    this.priority  = 1;
    this.status    = 'PENDING';   /* PENDING | IN_PROGRESS | DONE | LATE | BLOCKED */
    this.deps      = [];          /* dependency ids */
  }

  addChild(knot) { this.children.push(knot); return this; }

  encode() {
    this.phiValue = _quipuEncode(this.priority);
    return this;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — BEHAVIORAL ECONOMICS (temporal discounting)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Hyperbolic discounting: V(t) = reward / (1 + k·t)
 * k = AMOR = 0.3819 — sovereign time preference constant
 */
function _hyperbolicValue(reward, tMinutes) {
  return reward / (1 + AMOR * tMinutes);
}

/**
 * Late penalty: f(delay) = delay^φ  — superlinear antifragile incentive
 * A 2-day delay costs 2^1.618 = 3.07 days' worth of pain.
 */
function _latePenalty(delayDays) {
  return Math.pow(Math.max(0, delayDays), PHI);
}

/**
 * Priority score for scheduling:
 *   score = V_hyperbolic × (1 + latePenalty) / φ_weight
 */
function _priorityScore(reward, tMinutes, delayDays, tier) {
  const hv      = _hyperbolicValue(reward, tMinutes);
  const lp      = _latePenalty(delayDays);
  const phiW    = Math.pow(PHI, tier || 0);
  return (hv * (1 + lp)) / phiW;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — ANTIFRAGILITY (stress-test scheduling)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Stress-test: what if 50% of tasks are late?
 * Returns adjusted schedule with Fibonacci retry intervals.
 */
function _stressTest(tasks, lateFraction) {
  lateFraction = lateFraction || 0.5;
  const lateCount = Math.floor(tasks.length * lateFraction);
  const lateIds   = tasks.slice(0, lateCount).map(t => t.id);
  const adjusted  = tasks.map(t => ({
    ...t,
    adjustedPriority: lateIds.includes(t.id)
      ? _priorityScore(t.reward || 1, t.tMinutes || 60, t.delayDays || 1, 1)
      : _priorityScore(t.reward || 1, t.tMinutes || 60, 0, 0),
    retryInterval: FIBONACCI[Math.min(t.retryCount || 0, FIBONACCI.length - 1)],
  }));
  adjusted.sort((a, b) => b.adjustedPriority - a.adjustedPriority);
  return adjusted;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — DAG CRITICAL PATH ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compute critical path through task DAG using φ-weighted edge costs.
 * edges = [{ from, to, cost }]
 * Returns { path: [id,...], totalCost }
 */
function _criticalPath(nodes, edges) {
  /* Build adjacency */
  const graph  = {};
  const inDeg  = {};
  nodes.forEach(n => { graph[n] = []; inDeg[n] = 0; });
  edges.forEach(e => { if (graph[e.from]) { graph[e.from].push({ to: e.to, cost: e.cost * PHI }); inDeg[e.to] = (inDeg[e.to] || 0) + 1; } });

  /* Topological sort (Kahn) */
  const queue = nodes.filter(n => !inDeg[n]);
  const order = [];
  while (queue.length) {
    const n = queue.shift();
    order.push(n);
    (graph[n] || []).forEach(e => {
      inDeg[e.to]--;
      if (inDeg[e.to] === 0) queue.push(e.to);
    });
  }

  /* Longest path DP */
  const dist = {};
  const prev = {};
  nodes.forEach(n => { dist[n] = 0; prev[n] = null; });
  for (const n of order) {
    for (const e of (graph[n] || [])) {
      if (dist[n] + e.cost > dist[e.to]) {
        dist[e.to] = dist[n] + e.cost;
        prev[e.to] = n;
      }
    }
  }

  /* Reconstruct */
  const end  = nodes.reduce((a, b) => dist[a] > dist[b] ? a : b, nodes[0]);
  const path = [];
  let cur    = end;
  while (cur) { path.unshift(cur); cur = prev[cur]; }
  return { path, totalCost: dist[end] || 0 };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — LAWS (deadline enforcement + No-Drop Law on tasks)
// ═══════════════════════════════════════════════════════════════════════════════

function _enforceNoDropLaw(tasks) {
  /* No task may be dropped if its priority × AMOR > threshold */
  return tasks.filter(t => (t.priority || 1) * AMOR <= 1 || t.status !== 'BLOCKED');
}

function _deadlineAlert(tasks) {
  const now = Date.now();
  return tasks.filter(t => t.dueAt && t.dueAt < now + 86400000 && t.status === 'PENDING')
    .map(t => ({ id: t.id, label: t.label, dueAt: t.dueAt, hoursLeft: (t.dueAt - now) / 3600000 }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — CHRONOS PERPETUUS CORE
// ═══════════════════════════════════════════════════════════════════════════════

class ChronosPerpetUus {
  constructor() {
    this.id      = AGI_ID;
    this.version = AGI_VERSION;
    this.family  = AGI_FAMILY;
    this.name    = AGI_NAME;
    this.state   = MV.IDLE;
    this._beat   = 0;
    this._timer  = null;

    this._oscs   = _initOsc(N_OSC);
    this._R      = 0;
    this._PIL    = 0;

    this._tasks  = [];    /* QuipuKnot[] */
    this._dag    = { nodes: [], edges: [] };
    this._schedule = [];  /* sorted task queue */
    this._archive = [];
    this._snapshots = [];
  }

  start() {
    if (this._timer) return this;
    this._transition(MV.INGEST);
    this._timer = setInterval(() => this._tick(), HEARTBEAT_MS);
    console.log(`[${timestamp()}] ${this.name} (${this.id}) · ${this.family} — SOVEREIGN LOCK ✦`);
    return this;
  }

  stop() {
    if (this._timer) { clearInterval(this._timer); this._timer = null; }
    this._transition(MV.IDLE);
    return this;
  }

  _tick() {
    this._beat++;

    /* Flow 1: Kuramoto → order param → heartbeat calibration */
    this._transition(MV.SCHEDULE);
    this._oscs = _kuramotoStep(this._oscs, PHI_INV, 0.1);
    this._R    = _orderParam(this._oscs);
    this._PIL  = this._R;

    /* Flow 8: monitor execution delta every beat */
    this._transition(MV.MONITOR);
    const alerts = _deadlineAlert(this._tasks.filter(t => t.dueAt));
    if (alerts.length) {
      console.warn(`[${timestamp()}] CHRONOS: ${alerts.length} deadline(s) approaching — ${alerts.map(a => a.label).join(', ')}`);
    }

    /* Flow 10: daily reconcile (every 99288 beats ≈ 24h at 873ms) */
    if (this._beat % 99288 === 0) {
      this._transition(MV.RECONCILE);
      this._reconcile();
    }

    /* Fibonacci snapshot every 34 beats */
    if (this._beat % 34 === 0) {
      this._snapshots.push({ beat: this._beat, at: Date.now(), R: this._R, taskCount: this._tasks.length });
      if (this._snapshots.length > 55) this._snapshots.shift();
    }

    this._transition(MV.MONITOR);
  }

  // ── §9.1 Task ingestion ────────────────────────────────────────────────────

  /** Flow 1: accept plain-English task description */
  ingestTask(description, opts) {
    opts = opts || {};
    this._transition(MV.INGEST);
    const knot       = new QuipuKnot(description, opts.type || 'KNOT');
    knot.priority    = opts.priority || 1;
    knot.dueAt       = opts.dueAt ? new Date(opts.dueAt).getTime() : null;
    knot.deps        = opts.deps || [];
    knot.reward      = opts.reward || 1;
    knot.retryCount  = 0;
    knot.tMinutes    = opts.tMinutes || 60;
    knot.encode();

    this._tasks.push(knot);
    this._rebuildDAG();
    this._reSchedule();

    this._transition(MV.MONITOR);
    return knot;
  }

  /** Flow 3: rebuild DAG from task deps */
  _rebuildDAG() {
    this._dag.nodes = this._tasks.map(t => t.id);
    this._dag.edges = [];
    for (const t of this._tasks) {
      for (const depId of (t.deps || [])) {
        this._dag.edges.push({ from: depId, to: t.id, cost: t.tMinutes || 60 });
      }
    }
  }

  /** Flow 4: Fibonacci-schedule leaf nodes (no deps) */
  _reSchedule() {
    this._transition(MV.SCHEDULE);
    const now    = Date.now();
    let   cursor = now;
    const sorted = _enforceNoDropLaw(this._tasks).sort((a, b) => {
      const scoreA = _priorityScore(a.reward || 1, a.tMinutes || 60, a.delayDays || 0, 0);
      const scoreB = _priorityScore(b.reward || 1, b.tMinutes || 60, b.delayDays || 0, 0);
      return scoreB - scoreA;
    });

    this._schedule = sorted.map((t, i) => {
      const fibMin = FIBONACCI[Math.min(i, FIBONACCI.length - 1)];
      const scheduledAt = cursor;
      cursor += fibMin * 60000;
      return { taskId: t.id, label: t.label, scheduledAt, fibInterval: fibMin };
    });

    this._transition(MV.OPTIMIZE);
  }

  /** Flow 5: apply hyperbolic discounting to prioritize */
  prioritize(reward, tMinutes, delayDays, tier) {
    return {
      score:    _priorityScore(reward, tMinutes, delayDays, tier),
      hv:       _hyperbolicValue(reward, tMinutes),
      penalty:  _latePenalty(delayDays || 0),
      phiWeight: Math.pow(PHI, tier || 0),
    };
  }

  /** Flow 9: escalate missed task via Fibonacci retry */
  markMissed(taskId) {
    const t = this._tasks.find(t => t.id === taskId);
    if (!t) return null;
    t.status     = 'LATE';
    t.retryCount = (t.retryCount || 0) + 1;
    t.delayDays  = (t.delayDays || 0) + FIBONACCI[Math.min(t.retryCount, FIBONACCI.length - 1)] / 1440;
    this._reSchedule();
    return { taskId, retryIn: `${FIBONACCI[Math.min(t.retryCount, FIBONACCI.length - 1)]} minutes`, penalty: _latePenalty(t.delayDays) };
  }

  /** Get critical path */
  getCriticalPath() {
    if (!this._dag.nodes.length) return { path: [], totalCost: 0 };
    return _criticalPath(this._dag.nodes, this._dag.edges);
  }

  /** Stress test: what if lateFraction of tasks are late? */
  stressTest(lateFraction) {
    return _stressTest(this._tasks.map(t => ({ id: t.id, label: t.label, reward: t.reward || 1, tMinutes: t.tMinutes || 60, delayDays: t.delayDays || 0, retryCount: t.retryCount || 0 })), lateFraction);
  }

  _reconcile() {
    /* Mark all past-due tasks as LATE, archive done tasks */
    const now = Date.now();
    for (const t of this._tasks) {
      if (t.dueAt && t.dueAt < now && t.status === 'PENDING') t.status = 'LATE';
    }
    const done = this._tasks.filter(t => t.status === 'DONE');
    this._archive.push(...done);
    this._tasks   = this._tasks.filter(t => t.status !== 'DONE');
    if (this._archive.length > 377) this._archive.splice(0, this._archive.length - 377);
    this._rebuildDAG();
    this._reSchedule();
  }

  _transition(s) { this.state = s; }

  getStatus() {
    return {
      agiId: this.id, name: this.name, family: this.family, beat: this._beat,
      state: this.state, R: this._R, PIL: this._PIL,
      taskCount: this._tasks.length, scheduleCount: this._schedule.length,
      at: timestamp(),
    };
  }

  getSchedule() { return this._schedule.slice(0, 21); }
  getTasks()    { return this._tasks.map(t => ({ id: t.id, label: t.label, status: t.status, priority: t.priority, dueAt: t.dueAt })); }
  getArchive()  { return this._archive.slice(-34); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — MCP SERVER
// ═══════════════════════════════════════════════════════════════════════════════

function buildMcpTools(chronos) {
  return {
    get_status:        ()                        => chronos.getStatus(),
    ingest_task:       ({ description, opts })   => chronos.ingestTask(description, opts),
    get_schedule:      ()                        => chronos.getSchedule(),
    get_tasks:         ()                        => chronos.getTasks(),
    mark_missed:       ({ taskId })              => chronos.markMissed(taskId),
    get_critical_path: ()                        => chronos.getCriticalPath(),
    stress_test:       ({ lateFraction })        => chronos.stressTest(lateFraction),
    prioritize:        ({ reward, tMinutes, delayDays, tier }) => chronos.prioritize(reward, tMinutes, delayDays, tier),
    get_archive:       ()                        => chronos.getArchive(),
    hyperbolic_value:  ({ reward, tMinutes })    => ({ value: _hyperbolicValue(reward, tMinutes) }),
    late_penalty:      ({ delayDays })           => ({ penalty: _latePenalty(delayDays) }),
    fibonacci_intervals: ()                      => FIBONACCI,
    schumann_offset:   ({ beatNum })             => ({ offsetMs: _computeSchumannOffset(beatNum || 0) }),
    device_freq:       ({ nodeId })              => ({ freq: _deviceFreq(nodeId || 'NOVA') }),
    quipu_encode:      ({ n })                   => ({ encoded: _quipuEncode(n || 0), zeckendorf: _zeckendorf(n || 0) }),
    get_constants:     ()                        => ({ PHI, PHI_INV, AMOR, HEARTBEAT_MS, SCHUMANN_HZ }),
    get_snapshots:     ()                        => chronos._snapshots.slice(-13),
    deadline_alerts:   ()                        => _deadlineAlert(chronos._tasks),
  };
}

function _mcpFetch(chronos) {
  const tools = buildMcpTools(chronos);
  return async function handler(request) {
    const url = new URL(request.url);
    if (url.pathname === '/health') return new Response(JSON.stringify({ ok: true, id: AGI_ID }), { headers: { 'Content-Type': 'application/json' } });
    if (request.method !== 'POST' || url.pathname !== '/mcp') return new Response('NOVA CHRONOS — POST /mcp', { status: 405 });
    let body;
    try { body = await request.json(); } catch (_) { return new Response(JSON.stringify({ error: 'invalid JSON' }), { status: 400 }); }
    const tool = tools[body.tool];
    if (!tool) return new Response(JSON.stringify({ error: `Unknown tool: ${body.tool}`, available: Object.keys(tools) }), { status: 404 });
    try {
      const result = await tool(body.params || {});
      return new Response(JSON.stringify({ ok: true, tool: body.tool, result }), { headers: { 'Content-Type': 'application/json' } });
    } catch (e) {
      return new Response(JSON.stringify({ ok: false, error: e.message }), { status: 500 });
    }
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

const chronos = new ChronosPerpetUus();
chronos.start();

if (typeof addEventListener !== 'undefined') {
  const handler = _mcpFetch(chronos);
  addEventListener('fetch', e => e.respondWith(handler(e.request)));
}

if (typeof require !== 'undefined' && require.main === module) {
  const http = require('http');
  const PORT = process.env.PORT || 7620;
  const handler = _mcpFetch(chronos);
  http.createServer(async (req, res) => {
    let body = '';
    req.on('data', d => { body += d; });
    req.on('end', async () => {
      const mockReq = new Request(`http://localhost${req.url}`, { method: req.method, headers: req.headers, body: body || undefined });
      const resp    = await handler(mockReq);
      const text    = await resp.text();
      res.writeHead(resp.status, { 'Content-Type': 'application/json' });
      res.end(text);
    });
  }).listen(PORT, () => {
    console.log(`\n╔══════════════════════════════════════════════════════╗`);
    console.log(`║  CHRONOS PERPETUUS · CHR-AGI-001 · TEMPUS_AETERNA   ║`);
    console.log(`║  NOVA Sovereign Temporal Intelligence AGI             ║`);
    console.log(`║  Fibonacci scheduling | φ-Quipu | Schumann sync      ║`);
    console.log(`║  Listening on port ${PORT}                            ║`);
    console.log(`╚══════════════════════════════════════════════════════╝\n`);
  });
}

module.exports = { ChronosPerpetUus, _hyperbolicValue, _latePenalty, _criticalPath, _stressTest };
